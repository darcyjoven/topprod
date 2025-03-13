# Prog. Version..: '5.30.06-13.03.18(00001)'     #
#
# Pattern name...: apji010.4gl
# Descriptions...: 技能專長代號資料維護作業
# Date & Author..: 13/02/23 By Elise 
# Modify.........: No:CHI-CA0060 13/02/23 By Elise 技能專長代號維護

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE 
    g_pka           DYNAMIC ARRAY OF RECORD  #程式變數(Program Variables)
        pka01       LIKE pka_file.pka01,   
        pka02       LIKE pka_file.pka02,  
        pkaacti     LIKE pka_file.pkaacti    

                    END RECORD,
    g_pka_t         RECORD                   #程式變數 (舊值)
        pka01       LIKE pka_file.pka01,   
        pka02       LIKE pka_file.pka02,  
        pkaacti     LIKE pka_file.pkaacti    #CHAR(1)
                    END RECORD,
    g_wc2,g_sql     LIKE type_file.chr1000,  #CHAR(1)
    p_row,p_col     LIKE type_file.num5,     #SMALLINT
    g_rec_b         LIKE type_file.num5,     #單身筆數  SMALLINT
    l_ac            LIKE type_file.num5      #目前處理的ARRAY CNT  SMALLINT
DEFINE g_before_input_done  LIKE type_file.num5     #SMALLINT
DEFINE g_forupd_sql STRING                   #SELECT ... FOR UPDATE SQL
DEFINE g_cnt        LIKE type_file.num10     #INTEGER
DEFINE g_i          LIKE type_file.num5      #count/index for any purpose        #SMALLINT
DEFINE l_sql        LIKE type_file.chr1000  
DEFINE g_str        LIKE type_file.chr1000  
MAIN

    OPTIONS                                #改變一些系統預設值
       #FORM LINE       FIRST + 2,         #畫面開始的位置
       #MESSAGE LINE    LAST,              #訊息顯示的位置
       #PROMPT LINE     LAST,              #提示訊息的位置
        INPUT NO WRAP                      #輸入的方式: 不打轉
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APJ")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 


    LET p_row = 4 LET p_col = 2

    OPEN WINDOW i010_w AT p_row,p_col WITH FORM "apj/42f/apji010"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
    CALL cl_ui_init()


    LET g_wc2 = '1=1' CALL i010_b_fill(g_wc2)
    CALL i010_menu()
    CLOSE WINDOW i010_w                 #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION i010_menu()

   WHILE TRUE
      CALL i010_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i010_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i010_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i010_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg" 
            CALL cl_cmdask()

         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_pka),'','')
             END IF

      END CASE
   END WHILE
END FUNCTION

FUNCTION i010_q()
   CALL i010_b_askkey()
END FUNCTION

FUNCTION i010_b()
DEFINE
    l_ac_t          LIKE type_file.num5,      #未取消的ARRAY CNT SMALLINT
    l_n             LIKE type_file.num5,      #檢查重複用        SMALLINT
    l_lock_sw       LIKE type_file.chr1,      #單身鎖住否        CHAR(1)
    p_cmd           LIKE type_file.chr1,      #處理狀態          CHAR(1)
    l_allow_insert  LIKE type_file.chr1,      
    l_allow_delete  LIKE type_file.chr1       

    LET g_action_choice = ""

    IF s_shut(0) THEN RETURN END IF

    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')

    CALL cl_opmsg('b')

    LET g_forupd_sql = "SELECT pka01,pka02,pkaacti FROM pka_file WHERE pka01= ? FOR UPDATE"

    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i010_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
   
   IF g_rec_b=0 THEN CALL g_pka.clear() END IF

   INPUT ARRAY g_pka WITHOUT DEFAULTS FROM s_pka.*

              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,
              UNBUFFERED, INSERT ROW = l_allow_insert,
              DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

        BEFORE INPUT   
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF

        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'               #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_pka_t.* = g_pka[l_ac].*  #BACKUP
                                                                                                        
               LET  g_before_input_done = FALSE                                                                                     
               CALL i010_set_entry(p_cmd)                                                                                           
               CALL i010_set_no_entry(p_cmd)                                                                                        
               LET  g_before_input_done = TRUE                                                                                      
     
               BEGIN WORK
               OPEN i010_bcl USING g_pka_t.pka01
               IF STATUS THEN
                  CALL cl_err("OPEN i010_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE   
               FETCH i010_bcl INTO g_pka[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_pka_t.pka01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     
            END IF

        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'                                                                                             
            LET  g_before_input_done = FALSE                                                                                        
            CALL i010_set_entry(p_cmd)                                                                                              
            CALL i010_set_no_entry(p_cmd)                                                                                           
            LET  g_before_input_done = TRUE                                                                                         

            INITIALIZE g_pka[l_ac].* TO NULL      
            LET g_pka[l_ac].pkaacti = 'Y'       #Body default
            LET g_pka_t.* = g_pka[l_ac].*       #新輸入資料 
            CALL cl_show_fld_cont()     
            NEXT FIELD pka01

      AFTER INSERT
         IF INT_FLAG THEN                 
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
               CLOSE i010_bcl
               CANCEL INSERT 
         END IF
         INSERT INTO pka_file(pka01,pka02,pkaacti,pkauser,pkadate)
         VALUES(g_pka[l_ac].pka01,g_pka[l_ac].pka02,
                g_pka[l_ac].pkaacti,g_user,g_today)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","pka_file",g_pka[l_ac].pka01,"",SQLCA.sqlcode,"","",1)  
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF

        AFTER FIELD pka01                        #check 編號是否重複
            IF g_pka[l_ac].pka01 IS NOT NULL THEN 
               IF g_pka[l_ac].pka01 != g_pka_t.pka01 OR
                 (g_pka[l_ac].pka01 IS NOT NULL AND g_pka_t.pka01 IS NULL) THEN
                  SELECT count(*) INTO l_n FROM pka_file
                   WHERE pka01 = g_pka[l_ac].pka01
                  IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_pka[l_ac].pka01 = g_pka_t.pka01
                     NEXT FIELD pka01
                  END IF
               END IF
            END IF

        BEFORE DELETE                            #是否取消單身
            IF g_pka_t.pka01 IS NOT NULL THEN
               IF NOT cl_delete() THEN
                  CANCEL DELETE
               END IF
               IF l_lock_sw = "Y" THEN 
                  CALL cl_err("", -263, 1) 
                  CANCEL DELETE 
               END IF 
               DELETE FROM pka_file WHERE pka01 = g_pka_t.pka01
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","pka_file",g_pka_t.pka01,"",SQLCA.sqlcode,"","",1)
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2  
               MESSAGE "Delete OK" 
               CLOSE i010_bcl     
               COMMIT WORK
            END IF

        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_pka[l_ac].* = g_pka_t.*
              CLOSE i010_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_pka[l_ac].pka01,-263,1)
              LET g_pka[l_ac].* = g_pka_t.*
           ELSE
              UPDATE pka_file SET pka01=g_pka[l_ac].pka01,
                                  pka02=g_pka[l_ac].pka02,
                                  pkaacti=g_pka[l_ac].pkaacti,
                                  pkamodu=g_user,
                                  pkadate=g_today
               WHERE pka01=g_pka_t.pka01
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","pka_file",g_pka_t.pka01,"",SQLCA.sqlcode,"","",1)  
                 LET g_pka[l_ac].* = g_pka_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 CLOSE i010_bcl
                 COMMIT WORK
              END IF
           END IF

        AFTER ROW
            LET l_ac = ARR_CURR()                                               
            IF INT_FLAG THEN                
               CALL cl_err('',9001,0)                                           
               LET INT_FLAG = 0                                                 
               IF p_cmd = 'u' THEN 
                  LET g_pka[l_ac].* = g_pka_t.*                                    
               END IF 
               CLOSE i010_bcl                                                   
               ROLLBACK WORK                                                    
               EXIT INPUT                                                       
            END IF                                                              
            LET l_ac_t = l_ac                                                   
            CLOSE i010_bcl                                                      
            COMMIT WORK            

        ON ACTION CONTROLN
            CALL i010_b_askkey()
            EXIT INPUT

        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(pka01) AND l_ac > 1 THEN
                LET g_pka[l_ac].* = g_pka[l_ac-1].*
                NEXT FIELD pka01
            END IF

        ON ACTION CONTROLZ
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
            CALL cl_cmdask()

        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
          
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()   
        
        END INPUT

    CLOSE i010_bcl
    COMMIT WORK
    OPTIONS
        INSERT KEY F1,
        DELETE KEY F2
END FUNCTION

FUNCTION i010_b_askkey()
    CLEAR FORM
   CALL g_pka.clear()
    CONSTRUCT g_wc2 ON pka01,pka02,pkaacti
            FROM s_pka[1].pka01,s_pka[1].pka02,s_pka[1].pkaacti
            
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
         
      ON ACTION qbe_save
         CALL cl_qbe_save()
		
    END CONSTRUCT

    IF INT_FLAG THEN
       LET INT_FLAG = 0
       LET g_wc2 = NULL
       RETURN
    END IF
    CALL i010_b_fill(g_wc2)
END FUNCTION

FUNCTION i010_b_fill(p_wc2)               #BODY FILL UP
DEFINE
    p_wc2    LIKE type_file.chr1000       #CHAR(200)

    LET g_sql =
        "SELECT pka01,pka02,pkaacti",
        " FROM pka_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE i010_pb FROM g_sql
    DECLARE pka_curs CURSOR FOR i010_pb

    CALL g_pka.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH pka_curs INTO g_pka[g_cnt].*    #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_pka.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0

END FUNCTION

FUNCTION i010_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #CHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
      RETURN                                                                    
   END IF                                                                       

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pka TO s_pka.* ATTRIBUTE(COUNT=g_rec_b)

      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   

      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION accept                                                          
         LET g_action_choice="detail"                                           
         LET l_ac = ARR_CURR()                                                  
         EXIT DISPLAY                                                           
                                                                                
      ON ACTION cancel                                                          
             LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"                                             
         EXIT DISPLAY                                                           

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i010_out()
    DEFINE
        l_pka           RECORD LIKE pka_file.*,
        l_i             LIKE type_file.num5,          #SMALLINT
        l_name          LIKE type_file.chr20,         #External(Disk) file name        #CHAR(20)
        l_za05          LIKE za_file.za05             #CHAR(40)        
   
    IF g_wc2 IS NULL THEN 
       CALL cl_err('','9057',0)
    RETURN END IF
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM pka_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED

    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    IF g_zz05 = 'Y' THEN                                                        
       CALL cl_wcchp(g_wc2,'pka01,pka02,pkaacti')         
            RETURNING g_str                                                    
    END IF
    LET l_sql = "SELECT pka01,pka02,pkaacti FROM pka_file",                                                                   
                " WHERE ",g_wc2 CLIPPED                                                                                             
    CALL cl_prt_cs1('apji010','apji010',l_sql,g_str)
END FUNCTION

#函式說明:算出一字串,位於數個連續表頭的中央位置
#l_sta -  zaa起始序號   l_end - zaa結束序號  l_sta -字串長度
#傳回值 - 字串起始位置
FUNCTION i010_getStartPos(l_sta,l_end,l_str)
DEFINE l_sta,l_end,l_length,l_pos,l_w_tot,   l_i LIKE type_file.num5      #SMALLINT
DEFINE l_str STRING
   LET l_str=l_str.trim()
   LET l_length=l_str.getLength()
   LET l_w_tot=0
   FOR l_i=l_sta to l_end
      LET l_w_tot=l_w_tot+g_w[l_i]
   END FOR
   LET l_pos=(l_w_tot/2)-(l_length/2)
   IF l_pos<0 THEN LET l_pos=0 END IF
   LET l_pos=l_pos+g_c[l_sta]+(l_end-l_sta)
   RETURN l_pos
END FUNCTION
                                                                                                
FUNCTION i010_set_entry(p_cmd)                                                                                                      
  DEFINE p_cmd   LIKE type_file.chr1       #CHAR(1)
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                               
     CALL cl_set_comp_entry("pka01",TRUE)                                                                                           
  END IF                                                                                                                            
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION i010_set_no_entry(p_cmd)                                                                                                   
  DEFINE p_cmd   LIKE type_file.chr1       #CHAR(1)
  IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                               
     CALL cl_set_comp_entry("pka01",FALSE)                                                                                          
  END IF                                                                                                                            
END FUNCTION                                                                                                                           
#CHI-CA0060


