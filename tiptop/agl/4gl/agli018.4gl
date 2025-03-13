# Prog. Version..: '5.30.06-13.04.22(00002)'     #
#
# Pattern name...: agli018.4gl
# Descriptions...: 母公司現金流量錶維護作業
# Date & Author..: No.FUN-B70003 11/07/04 By Lujh 
# Modify.........: NO.MOD-BB0262 11/11/23 By xuxz 註釋中版本號修改
# Modify.........: No:FUN-D30032 13/04/03 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
       g_aes                DYNAMIC ARRAY OF RECORD      #程式變數(Program Variables)
           aes01            LIKE aes_file.aes01,         #銀行調節碼
           aes02            LIKE aes_file.aes02,         #調節說明
           aes03            LIKE aes_file.aes03,         #銀行存款加減方式
           aes05            LIKE aes_file.aes05,         #行次 
           aesacti          LIKE aes_file.aesacti        
                            END RECORD,
       g_aes_t              RECORD                       #程式變數 (舊值)
           aes01            LIKE aes_file.aes01,         #銀行調節碼
           aes02            LIKE aes_file.aes02,         #調節說明
           aes03            LIKE aes_file.aes03,         #銀行存款加減方式
           aes05            LIKE aes_file.aes05,         #行次 
           aesacti          LIKE aes_file.aesacti        
                            END RECORD,
       g_wc,g_sql           STRING,                    
       g_rec_b              LIKE type_file.num5,         #單身筆數 
       l_ac                 LIKE type_file.num5          #目前處理的ARRAY 
DEFINE g_str                STRING
DEFINE g_forupd_sql         STRING                       #SELECT ... FOR UPDATE SQL
DEFINE g_cnt                LIKE type_file.num10         
DEFINE g_i                  LIKE type_file.num5          #count/index for any purpose        
DEFINE g_before_input_done  LIKE type_file.num5  
DEFINE g_table              LIKE type_file.chr1

MAIN
   DEFINE  p_row,p_col      LIKE type_file.num5       
 
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time   #計算使用時間 (進入時間) 

   LET p_row = 3 LET p_col = 10
   OPEN WINDOW i018_w AT p_row,p_col WITH FORM "agl/42f/agli018"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()
   LET g_wc = '1=1' 
   CALL i018_b_fill(g_wc)
   CALL i018_menu()
   CLOSE WINDOW i018_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time   #計算使用時間 (退出時間) 
END MAIN
 
FUNCTION i018_menu()
 
   WHILE TRUE
      CALL i018_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i018_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i018_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i018_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "automatic_produce_detail"
            IF cl_chk_act_auth() THEN
               CALL i018_produce_detail()
            END IF
         WHEN "exporttoexcel"     
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_aes),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i018_q()
   CALL i018_b_askkey()
END FUNCTION
 
FUNCTION i018_b()
   DEFINE
    l_ac_t          LIKE type_file.num5,   #未取消的ARRAY 
    l_n             LIKE type_file.num5,   #檢查重複用     
    l_lock_sw       LIKE type_file.chr1,   #單身鎖住否    
    p_cmd           LIKE type_file.chr1,   #處理狀態       
    l_allow_insert  LIKE type_file.num5,   #可新增否                           
    l_allow_delete  LIKE type_file.num5    #可刪除否                      
 
    LET g_action_choice = ""                                                    
 
    IF s_anmshut(0) THEN RETURN END IF
    LET l_allow_insert = cl_detail_input_auth('insert')                         
    LET l_allow_delete = cl_detail_input_auth('delete')               
    CALL cl_opmsg('b')

    LET g_forupd_sql = "SELECT aes01,aes02,aes03,aes05,aesacti FROM aes_file WHERE aes01=? FOR UPDATE"    
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i018_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        INPUT ARRAY g_aes
            WITHOUT DEFAULTS
            FROM s_aes.*
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,           
                         INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)   
 
        BEFORE INPUT 
         IF g_rec_b!=0 THEN
          CALL fgl_set_arr_curr(l_ac)
         END IF
 
        BEFORE ROW
            LET p_cmd='u' 
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b>=l_ac THEN
               LET p_cmd='u'
               LET g_aes_t.* = g_aes[l_ac].*  #BACKUP
                                                       
               LET g_before_input_done = FALSE                                 
               CALL i018_set_entry(p_cmd)                                      
               CALL i018_set_no_entry(p_cmd)                                   
               LET g_before_input_done = TRUE                                  
 
               BEGIN WORK
                  OPEN i018_bcl USING g_aes_t.aes01
                  IF STATUS THEN
                     CALL cl_err("OPEN i018_bcl:", STATUS, 1)
                     LET l_lock_sw = "Y"
                  ELSE
                     FETCH i018_bcl INTO g_aes[l_ac].* 
                     IF SQLCA.sqlcode THEN
                        CALL cl_err(g_aes_t.aes01,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                     END IF
                  END IF
                  CALL cl_show_fld_cont()     
            END IF

 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
                                                          
            LET g_before_input_done = FALSE                                     
            CALL i018_set_entry(p_cmd)                                          
            CALL i018_set_no_entry(p_cmd)                                       
            LET g_before_input_done = TRUE                                      
   
            INITIALIZE g_aes[l_ac].* TO NULL     
            LET g_aes[l_ac].aesacti = 'Y'       #Body default
            LET g_aes_t.* = g_aes[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     
            NEXT FIELD aes01
 
        AFTER INSERT                                                            
            IF INT_FLAG THEN                 
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO aes_file(aes01,aes02,aes03,aes05,    
                                 aesacti,aesuser,aesdate,aesoriu,aesorig)
            VALUES(g_aes[l_ac].aes01,g_aes[l_ac].aes02,
                   g_aes[l_ac].aes03,g_aes[l_ac].aes05,g_aes[l_ac].aesacti,     
                   g_user,g_today, g_user, g_grup)      
            IF SQLCA.sqlcode THEN

               CALL cl_err3("ins","aes_file",g_aes[l_ac].aes01,"",SQLCA.sqlcode,"","",1)  
               CANCEL INSERT

            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2  
            END IF
 
        AFTER FIELD aes01                        #check 編號是否重複
            IF g_aes[l_ac].aes01 != g_aes_t.aes01 OR
               (g_aes[l_ac].aes01 IS NOT NULL AND g_aes_t.aes01 IS NULL) THEN
                SELECT count(*) INTO l_n FROM aes_file
                    WHERE aes01 = g_aes[l_ac].aes01
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_aes[l_ac].aes01 = g_aes_t.aes01
                    NEXT FIELD aes01
                END IF
            END IF
 
	    AFTER FIELD aes03
               IF (g_aes[l_ac].aes03 != '10' AND g_aes[l_ac].aes03 != '11' AND
                   g_aes[l_ac].aes03 != '20' AND g_aes[l_ac].aes03 != '21' AND
                   g_aes[l_ac].aes03 != '30' AND g_aes[l_ac].aes03 != '31' AND
                   g_aes[l_ac].aes03 != '40') OR cl_null(g_aes[l_ac].aes03) THEN
                  LET g_aes[l_ac].aes03 = g_aes_t.aes03
                  NEXT FIELD aes03
               END IF                                                       
         AFTER FIELD aes05                                                       
            IF NOT cl_null(g_aes[l_ac].aes05) THEN                              
               IF g_aes[l_ac].aes05 <= 0 THEN                                   
                  CALL cl_err(g_aes[l_ac].aes05,'mfg9243',0)                    
                  NEXT FIELD aes05                                              
               END IF                                                           
            END IF                                                              

 
         BEFORE DELETE                            #是否取消單身
            IF g_aes_t.aes01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM aes_file WHERE aes01 = g_aes_t.aes01
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","aes_file",g_aes_t.aes01,"",SQLCA.sqlcode,"","",1)  
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                MESSAGE "Delete OK"                                             
                CLOSE i018_bcl         
                COMMIT WORK
            END IF
 
         ON ROW CHANGE                                                           
          IF INT_FLAG THEN                 
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_aes[l_ac].* = g_aes_t.*
               CLOSE i018_bcl   
               ROLLBACK WORK     
               EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN                                               
             CALL cl_err(g_aes[l_ac].aes01,-263,1)                            
             LET g_aes[l_ac].* = g_aes_t.*                                      
          ELSE                                      
            UPDATE aes_file SET   aes01 = g_aes[l_ac].aes01,
                                  aes02 = g_aes[l_ac].aes02,
                                  aes03 = g_aes[l_ac].aes03,
                                  aes05 = g_aes[l_ac].aes05,   
                                aesacti = g_aes[l_ac].aesacti,
                                aesmodu = g_user,
                                aesdate = g_today
                          WHERE aes01   = g_aes_t.aes01
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","aes_file",g_aes_t.aes01,"",SQLCA.sqlcode,"","",1)  
                LET g_aes[l_ac].* = g_aes_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                CLOSE i018_bcl         
             END IF
          END IF
 
         AFTER ROW
           LET l_ac = ARR_CURR()
           IF INT_FLAG THEN                 
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_aes[l_ac].* = g_aes_t.*
             #FUN-D30032--add--str--
             ELSE
                CALL g_aes.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D30032--add--end--
             END IF
             CLOSE i018_bcl                                                     
             ROLLBACK WORK  
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac                                                     
          CLOSE i018_bcl                                                        
          COMMIT WORK   
 
         ON ACTION CONTROLN
            CALL i018_b_askkey()
            EXIT INPUT
 
         ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(aes01) AND l_ac > 1 THEN
                LET g_aes[l_ac].* = g_aes[l_ac-1].*
                NEXT FIELD aes01
            END IF
 
         ON ACTION CONTROLR
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
        
      CLOSE i018_bcl
      COMMIT WORK
END FUNCTION
 
FUNCTION i018_b_askkey()
    CLEAR FORM
    CALL g_aes.clear()
    CONSTRUCT g_wc ON aes01,aes02,aes03,aes05,aesacti  
            FROM s_aes[1].aes01,s_aes[1].aes02,s_aes[1].aes03
			       ,s_aes[1].aes05,s_aes[1].aesacti    
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('aesuser', 'aesgrup')

    IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc = NULL
      RETURN
    END IF

    CALL i018_b_fill(g_wc)
END FUNCTION
 
FUNCTION i018_b_fill(p_wc2)        #BODY FILL UP
DEFINE
    p_wc2  LIKE type_file.chr1000  
 
    LET g_sql =
        "SELECT aes01,aes02,aes03,aes05,aesacti",    
        " FROM aes_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE i018_pb FROM g_sql
    DECLARE aes_curs CURSOR FOR i018_pb
 
    FOR g_cnt = 1 TO g_aes.getLength()                #單身 ARRAY 乾洗
       INITIALIZE g_aes[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH aes_curs INTO g_aes[g_cnt].*              #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_aes.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i018_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_aes TO s_aes.*  ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   
 
     
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
 
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
                                                                                
      ON ACTION accept                                                          
         LET g_action_choice="detail"                                           
         LET l_ac = ARR_CURR()                                                  
         EXIT DISPLAY   

      ON ACTION automatic_produce_detail
         LET g_action_choice="automatic_produce_detail"
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

FUNCTION i018_out()
   DEFINE  l_aes           RECORD LIKE aes_file.*,
           l_i             LIKE type_file.num5,     
           l_name          LIKE type_file.chr20,    
           l_wc            LIKE type_file.chr1000,  
           l_za05          LIKE type_file.chr1000   
    DEFINE p_aes03         LIKE aes_file.aes03
    DEFINE l_aes03         STRING
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0) RETURN
    END IF

    CALL cl_wait()
    #CALL cl_outnam('agli018') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang

    CALL cl_prt_pos_len()
    LET g_sql="SELECT * FROM aes_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED,
              " AND aes03 IN ('10','11','20','21','30','31','40')",
              " ORDER BY 1"    
    CALL cl_wcchp(g_wc,'aes01,aes02,aes03,aes05,aesacti')
      RETURNING l_wc             

    LET g_str=l_wc   
    CALL cl_prt_cs1('agli018','agli018',g_sql,g_str)          

END FUNCTION
                                                       
FUNCTION i018_set_entry(p_cmd)                                                  
   DEFINE p_cmd   LIKE type_file.chr1    
                                                                                
   IF p_cmd='a' AND ( NOT g_before_input_done ) THEN                            
      CALL cl_set_comp_entry("aes01",TRUE)                                       
   END IF                                                                       
END FUNCTION                                                                    
                                                                                
FUNCTION i018_set_no_entry(p_cmd)                                               
   DEFINE p_cmd   LIKE type_file.chr1    
                                                                                
   IF p_cmd='u' AND  ( NOT g_before_input_done ) AND g_chkey='N' THEN           
     CALL cl_set_comp_entry("aes01",FALSE)                                      
   END IF                                                                       
END FUNCTION   

FUNCTION i018_produce_detail()           # 清空单身资料，从nml_file表里取资料填充
DEFINE   l_n   LIKE type_file.num5
 
   SELECT count(*) INTO l_n FROM aes_file
   IF l_n > 0 THEN
       IF NOT cl_confirm('agl-604') THEN RETURN END IF
   END IF
   CLEAR FORM
   CALL g_aes.clear()
   BEGIN WORK

   DELETE FROM aes_file

   INSERT INTO aes_file(aes01,aes02,aes03,aes05,aesacti,aesdate,aesgrup,aesmodu,aesorig,aesoriu,aesuser) 
                 SELECT nml01,nml02,nml03,nml05,nmlacti,nmldate,nmlgrup,nmlmodu,nmlorig,nmloriu,nmluser 
                   FROM nml_file
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","aes_file","","",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK
      RETURN  
   ELSE
      COMMIT WORK
      MESSAGE 'INSERT O.K' 
   END IF
   CALL i018_b_fill('1=1')

END FUNCTION                                                                  
#NO.FUN-B70003     
#MOD-BB0262
