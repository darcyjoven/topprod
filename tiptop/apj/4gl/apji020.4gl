# Prog. Version..: '5.30.06-13.03.18(00001)'     #
#
# Pattern name...: apji020.4gl
# Descriptions...: 部門會計科目維護作業
# Date & Author..: 13/02/20 By Elise
# Modify.........: No:CHI-CA0064 13/02/20 By Elise 部門會計科目維護作業

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE 
    g_pkb           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        pkb01       LIKE pkb_file.pkb01,   #部門代碼
        pkb02       LIKE pkb_file.pkb02,   #直間接        
        pkbacti     LIKE pkb_file.pkbacti  #CHAR(1) 
                    END RECORD,
    g_pkb_t         RECORD                 #程式變數 (舊值)
        pkb01       LIKE pkb_file.pkb01,   #部門代碼
        pkb02       LIKE pkb_file.pkb02,   #直間接        
        pkbacti     LIKE pkb_file.pkbacti  #CHAR(1) 
                    END RECORD,
    g_wc2,g_sql     string,  
    g_rec_b         LIKE type_file.num5,   #單身筆數               #SMALLINT
    l_ac            LIKE type_file.num5    #目前處理的ARRAY CNT    #SMALLINT
DEFINE g_bookno1    LIKE aza_file.aza81    
DEFINE g_bookno2    LIKE aza_file.aza82    
DEFINE g_flag       LIKE type_file.chr1    
DEFINE g_forupd_sql STRING                  #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   STRING
DEFINE g_cnt        LIKE type_file.num10    #INTEGER
DEFINE g_i          LIKE type_file.num5     #count/index for any purpose        #SMALLINT

MAIN

    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP                      #輸入的方式: 不打轉
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
  
    WHENEVER ERROR CALL cl_err_msg_log
  
    IF (NOT cl_setup("APJ")) THEN
       EXIT PROGRAM
    END IF

    CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間)
         RETURNING g_time   

    OPEN WINDOW i020_w WITH FORM "apj/42f/apji020"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
    CALL cl_ui_init()

    LET g_wc2 = '1=1' CALL i020_b_fill(g_wc2)
    CALL i020_menu()
    CLOSE WINDOW i020_w                 #結束畫面
    CALL  cl_used(g_prog,g_time,2)      #計算使用時間 (退出使間)
       RETURNING g_time   
END MAIN

FUNCTION i020_menu()
DEFINE   l_cmd LIKE type_file.chr1000                         

   WHILE TRUE
      CALL i020_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i020_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i020_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
                CALL i020_out()
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
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_pkb),'','')
             END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION i020_q()
   CALL i020_b_askkey()
END FUNCTION

FUNCTION i020_b()
DEFINE
    l_ac_t          LIKE type_file.num5,      #未取消的ARRAY CNT   SMALLINT
    l_n             LIKE type_file.num5,      #檢查重複用          SMALLINT
    l_lock_sw       LIKE type_file.chr1,      #單身鎖住否          CHAR(1)
    p_cmd           LIKE type_file.chr1,      #處理狀態            CHAR(1)
    l_allow_insert  LIKE type_file.chr1,      #CHAR(01) 
    l_aag05         LIKE aag_file.aag05,      
    l_allow_delete  LIKE type_file.chr1       #CHAR(01) 

    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF

    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')

    CALL cl_opmsg('b')

    LET g_forupd_sql= "SELECT pkb01,pkb02,pkbacti ", 
                      "  FROM pkb_file ",
                      " WHERE pkb01= ? ",
                      "   FOR UPDATE"

    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i020_bcl CURSOR FROM g_forupd_sql      #LOCK CURSOR

   IF g_rec_b=0 THEN CALL g_pkb.clear() END IF

   INPUT ARRAY g_pkb WITHOUT DEFAULTS FROM s_pkb.*

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
            LET l_lock_sw = 'N'                 #DEFAULT
            LET l_n  = ARR_COUNT()

            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_pkb_t.* = g_pkb[l_ac].*    #BACKUP
               LET  g_before_input_done = FALSE                                                                                     
               CALL i020_set_entry(p_cmd)                                                                                           
               CALL i020_set_no_entry(p_cmd)                                                                                        
               LET  g_before_input_done = TRUE                                                                                      
               BEGIN WORK
               OPEN i020_bcl USING g_pkb_t.pkb01
               IF STATUS THEN
                  CALL cl_err("OPEN i020_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE  
                  FETCH i020_bcl INTO g_pkb[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_pkb_t.pkb01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF                  
               END IF
               LET g_before_input_done = FALSE                                   
               CALL i020_set_entry(p_cmd)                                        
               CALL i020_set_no_entry(p_cmd)                                     
               LET g_before_input_done = TRUE
               CALL cl_show_fld_cont()     
            END IF
       
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'                                                                                                    
            LET  g_before_input_done = FALSE                                                                                        
            CALL i020_set_entry(p_cmd)                                                                                              
            CALL i020_set_no_entry(p_cmd)                                                                                           
            LET  g_before_input_done = TRUE                                                                                         
            INITIALIZE g_pkb[l_ac].* TO NULL     
            LET g_pkb[l_ac].pkbacti = 'Y'         #Body default
            LET g_pkb_t.* = g_pkb[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()    
            NEXT FIELD pkb01

      AFTER INSERT
         IF INT_FLAG THEN              
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0        
            INITIALIZE g_pkb[l_ac].* TO NULL      #重要欄位空白,無效
            DISPLAY g_pkb[l_ac].* TO s_pkb.*
            CALL g_pkb.deleteElement(g_rec_b+1)
            ROLLBACK WORK
            CANCEL INSERT
            EXIT INPUT
         END IF
         INSERT INTO pkb_file(pkb01,pkb02,pkbacti,pkbuser,pkbdate) 
         VALUES(g_pkb[l_ac].pkb01,g_pkb[l_ac].pkb02,                
                g_pkb[l_ac].pkbacti,g_user,g_today)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","pkb_file",g_pkb[l_ac].pkb01,"",SQLCA.sqlcode,"","",1) 
            CANCEL INSERT
         ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF

        AFTER FIELD pkb02 
            IF NOT cl_null(g_pkb[l_ac].pkb02) THEN
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_pkb[l_ac].pkb02,g_errno,0)
                  LET g_pkb[l_ac].pkb02 = g_pkb_t.pkb02

                  DISPLAY g_pkb[l_ac].pkb02 TO s_pkb[l_ac].pkb02
                  NEXT FIELD pkb02 
               END IF
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01=g_pkb[l_ac].pkb02
                  AND aag00=g_bookno1    
               IF l_aag05<>'Y' THEN
                 CALL cl_err(g_pkb[l_ac].pkb02,'apj-603',1)
                 LET g_pkb[l_ac].pkb02 = g_pkb_t.pkb02
                 DISPLAY g_pkb[l_ac].pkb02 TO s_pkb[l_ac].pkb02
                 NEXT FIELD pkb02 
               END IF
            END IF

        BEFORE DELETE                            #是否取消單身
            IF g_pkb_t.pkb01 IS NOT NULL THEN
               IF NOT cl_delete() THEN
                  CANCEL DELETE
               END IF
               IF l_lock_sw = "Y" THEN 
                  CALL cl_err("", -263, 1) 
                  CANCEL DELETE 
               END IF 
               DELETE FROM pkb_file WHERE pkb01 = g_pkb_t.pkb01 
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","pkb_file",g_pkb_t.pkb01,"",SQLCA.sqlcode,"","",1) 
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2  
               MESSAGE "Delete OK" 
               CLOSE i020_bcl     
               COMMIT WORK
            END IF

        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_pkb[l_ac].* = g_pkb_t.*
              CLOSE i020_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_pkb[l_ac].pkb01,-263,1)
              LET g_pkb[l_ac].* = g_pkb_t.*
           ELSE
              UPDATE pkb_file SET pkb01 =g_pkb[l_ac].pkb01,
                                  pkb02 =g_pkb[l_ac].pkb02,                                  
                                  pkbacti=g_pkb[l_ac].pkbacti,
                                  pkbmodu=g_user,
                                  pkbdate=g_today
               WHERE pkb01 = g_pkb_t.pkb01
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","pkb_file",g_pkb_t.pkb01,"",SQLCA.sqlcode,"","",1)  
                  LET g_pkb[l_ac].* = g_pkb_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  CLOSE i020_bcl
                  COMMIT WORK
               END IF
           END IF

        AFTER ROW
            LET l_ac = ARR_CURR()                                               
            IF INT_FLAG THEN              
               CALL cl_err('',9001,0)                                           
               LET INT_FLAG = 0                                                 
               IF p_cmd = 'u' THEN 
                  LET g_pkb[l_ac].* = g_pkb_t.*                                    
               END IF 
               CLOSE i020_bcl                                                   
               ROLLBACK WORK                                                    
               EXIT INPUT                                                       
            END IF                                                              
            LET l_ac_t = l_ac                                                   
            CLOSE i020_bcl                                                      
            COMMIT WORK                        
            CALL g_pkb.deleteElement(g_rec_b+1)

        ON ACTION controlp
           CASE 
              WHEN INFIELD(pkb01)         #部門主檔
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gem"
                 LET g_qryparam.default1 = g_pkb[l_ac].pkb01 
                 CALL cl_create_qry() RETURNING g_pkb[l_ac].pkb01 
                 DISPLAY BY NAME g_pkb[l_ac].pkb01      
                 NEXT FIELD pkb01

              WHEN INFIELD(pkb02)         #會計科目
                 CALL i020_amt() 
                 CALL q_m_aag(FALSE,TRUE,g_plant,g_pkb[1].pkb02,'23',g_bookno1)   
                 RETURNING g_pkb[l_ac].pkb02
                 DISPLAY g_pkb[l_ac].pkb02 TO pkb02   
                 NEXT FIELD pkb02
	      
              OTHERWISE EXIT CASE
           END  CASE 

        ON ACTION CONTROLN
            CALL i020_b_askkey()
            EXIT INPUT

        ON ACTION CONTROLO                 #沿用所有欄位
            IF INFIELD(pkb01) AND l_ac > 1 THEN
                LET g_pkb[l_ac].* = g_pkb[l_ac-1].*
                NEXT FIELD pkb01
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
 
        ON ACTION HELP          
           CALL cl_show_help()          
        END INPUT

    CLOSE i020_bcl
    COMMIT WORK
    OPTIONS
        INSERT KEY F1,
        DELETE KEY F2
END FUNCTION  

FUNCTION i020_pkb01(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,          #CHAR(1)
    l_gemacti       LIKE gem_file.gemacti

    LET g_errno = ' '
    SELECT gemacti INTO l_gemacti FROM gem_file
        WHERE gem01 = g_pkb[l_ac].pkb01

    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-039'
                                   LET l_gemacti = NULL
         WHEN l_gemacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION

FUNCTION i020_pkb02(p_cmd)  #會計科目
    DEFINE p_cmd    LIKE type_file.chr1,         
           l_flag   LIKE type_file.num5,         
           l_smb02  LIKE aag_file.aag02          

    LET g_errno=' ' 
    CALL i020_amt()
    CALL s_actchk2(g_pkb[l_ac].pkb02,g_plant,g_bookno1) RETURNING l_flag,l_smb02  
END FUNCTION

FUNCTION i020_amt()
   CALL s_get_bookno1(NULL,g_plant) RETURNING g_flag,g_bookno1,g_bookno2
   IF g_flag = '1' THEN   #抓不到帳別
      CALL cl_err(g_plant,'aoo-081',1)
   END IF
END FUNCTION

FUNCTION i020_b_askkey()
    CLEAR FORM
    CALL g_pkb.clear()
    CONSTRUCT g_wc2 ON pkb01,pkb02,pkbacti  
            FROM s_pkb[1].pkb01,s_pkb[1].pkb02,s_pkb[1].pkbacti  
              
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              
      ON ACTION controlp
           CASE 
              WHEN INFIELD(pkb01)      #部門主檔
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gem"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_pkb[1].pkb01 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pkb01
                 NEXT FIELD pkb01
              WHEN INFIELD(pkb02)   #會計科目
                 CALL i020_amt()                  
                 CALL q_m_aag(TRUE,TRUE,g_plant,g_pkb[1].pkb02,'23',g_bookno1) 
                 RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pkb02 
                 NEXT FIELD pkb02 

              OTHERWISE EXIT CASE
           END CASE 

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
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i020_b_fill(g_wc2)
END FUNCTION

FUNCTION i020_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #CHAR(200)

    LET g_sql =
        "SELECT pkb01,pkb02,pkbacti", 
        " FROM pkb_file ",
        " WHERE ", p_wc2 CLIPPED,    #單身
        " ORDER BY 1"
    PREPARE i020_pb FROM g_sql
    DECLARE pkb_curs CURSOR FOR i020_pb

    CALL g_pkb.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH pkb_curs INTO g_pkb[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_pkb.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0

END FUNCTION

FUNCTION i020_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #CHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
      RETURN                                                                    
   END IF                                                                       

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pkb TO s_pkb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

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
         EXIT DISPLAY                              

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

      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i020_out()
DEFINE l_cmd  LIKE type_file.chr1000           
    IF g_wc2 IS NULL THEN                                                                                                            
       CALL cl_err('','9057',0)                                                                                                      
    RETURN END IF
    LET l_cmd = 'p_query "apji020" "',g_bookno1,'" "',g_bookno2,'" "',g_wc2 CLIPPED,'"'
    CALL cl_cmdrun(l_cmd)                                                                                                            
    RETURN 
END FUNCTION

FUNCTION i020_t()
 DEFINE l_success LIKE type_file.chr1,        #CHAR(01)
        l_sql LIKE type_file.chr1000,         #CHAR(1000)
        l_wc  LIKE type_file.chr1000,         #CHAR(300)
        l_aag05    LIKE aag_file.aag05,       
        tm    RECORD
              e     LIKE aag_file.aag01,
              x     LIKE type_file.chr1  
              END RECORD,
        l_gem RECORD LIKE gem_file.*,
        l_pkb RECORD LIKE pkb_file.*,
        l_n      LIKE type_file.num5,             #SMALLINT
        l_flag   LIKE type_file.chr1           #CHAR(1)

   OPEN WINDOW i020_w_t WITH FORM "apj/42f/apji020t"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) 

   CALL cl_ui_locale("apji020t")
   CALL cl_set_comp_visible("f",g_aza.aza63='Y')          

   INITIALIZE tm.* TO NULL
   LET tm.x='N'
   CALL i020_set_comb('b')                                           
   DISPLAY BY NAME tm.e,tm.x
   CONSTRUCT BY NAME l_wc ON gem07,gem01 

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
   IF INT_FLAG THEN LET INT_FLAG=0 CLOSE WINDOW i020_w_t RETURN END IF

   CALL s_get_bookno1(NULL,g_plant) RETURNING g_flag,g_bookno1,g_bookno2                                                              
   IF g_flag =  '1' THEN     #抓不到帳別   
      CALL cl_err(g_plant,'aoo-081',1)                                                                                                
   END IF                                                                                                                           

   INPUT BY NAME tm.e,tm.x WITHOUT DEFAULTS                

     AFTER FIELD e   #會計科目
         IF cl_null(tm.e) THEN NEXT FIELD e END IF
         IF g_sma.sma03 MATCHES '[yY]' THEN
            CALL s_actchk2(tm.e,g_plant,g_bookno1) RETURNING l_flag,g_dash 

            SELECT aag05 INTO l_aag05 FROM aag_file
             WHERE aag01=tm.e
               AND aag00=g_bookno1  
            IF l_aag05<>'Y' THEN
              CALL cl_err(tm.e,'apj-603',1)
              NEXT FIELD e
            END IF 
         END IF

    AFTER FIELD x
        IF cl_null(tm.x) OR tm.x NOT MATCHES "[YN]" THEN NEXT FIELD x END IF

    ON ACTION controlp
       CASE 
          WHEN INFIELD(e)
             CALL q_m_aag(FALSE,TRUE,g_plant,tm.e,'23',g_bookno1) 
             RETURNING tm.e                   
             DISPLAY tm.e TO FORMONLY.e 
             NEXT FIELD e

          OTHERWISE EXIT CASE
      END CASE

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help         
         CALL cl_show_help() 
 
      ON ACTION controlg    
         CALL cl_cmdask()   
   
   END INPUT

   IF INT_FLAG THEN LET INT_FLAG=0 CLOSE WINDOW i020_w_t RETURN END IF
   LET l_sql="SELECT * FROM gem_file ",
             " WHERE ",l_wc CLIPPED
   PREPARE t102_t_p FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('foreach:',SQLCA.sqlcode,1)
      CLOSE WINDOW i020_w_t
      RETURN
   END IF
   DECLARE t102_t_c CURSOR FOR t102_t_p
   BEGIN WORK
   LET l_success='Y'
   FOREACH t102_t_c INTO l_gem.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('for',SQLCA.sqlcode,0)
         LET l_success='N'
         EXIT FOREACH
      END IF
      LET l_pkb.pkb01=l_gem.gem01      #部門代碼
      LET l_pkb.pkb02=tm.e             #會計科目 
      LET l_pkb.pkbacti='Y'            #資料有效否
      LET l_pkb.pkbuser=g_user         #資料所有者
      LET l_pkb.pkbdate=g_today        #最近修改日
     MESSAGE l_pkb.pkb01,' ',' ',' '

     INSERT INTO pkb_file VALUES(l_pkb.*)
       IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN  
          CALL cl_err3("ins","pkb_file",l_pkb.pkb01,"",SQLCA.sqlcode,"","ins pkb",1)  
          LET l_success='N'
          EXIT FOREACH
       END IF

       IF cl_sql_dup_value(SQLCA.SQLCODE) THEN 
          IF tm.x='Y' THEN                    
              UPDATE pkb_file SET pkb02 = l_pkb.pkb02
                   WHERE pkb01 = l_pkb.pkb01
                        
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                CALL cl_err3("upd","pkb_file",l_pkb.pkb01,"",SQLCA.sqlcode,"","upd pkb",1)  
                LET l_success='N'
                EXIT FOREACH
              END IF
          ELSE CONTINUE FOREACH END IF
       END IF
   END FOREACH
   IF l_success='Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
   CLOSE WINDOW i020_w_t
   CALL i020_b_fill(' 1=1')
END FUNCTION

FUNCTION i020_set_entry(p_cmd)                                                  
DEFINE p_cmd   LIKE type_file.chr1             #CHAR(1)
                                                                                                                                    
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                              
      CALL cl_set_comp_entry("pkb01",TRUE)                                                                        
   END IF                                                                                                                           
END FUNCTION                                                                    
                                                                                
FUNCTION i020_set_no_entry(p_cmd)                                               
DEFINE p_cmd   LIKE type_file.chr1             #CHAR(1)
                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                              
      CALL cl_set_comp_entry("pkb01",FALSE)                                                                       
   END IF                                                                                                                           
END FUNCTION            

FUNCTION i020_set_comb(comb_str)
  DEFINE comb_str   STRING
  DEFINE comb_value STRING
  DEFINE comb_item  LIKE type_file.chr1000   

    IF g_aza.aza26='2' THEN                                                                                                           
       LET comb_value = '1,2,3,4,5,6,7,8,9,E'                                                                                       
    ELSE 
       LET comb_value = '1,2,3,4,5,6,7,8,9,A,B,C,D,F'  
    END IF
    IF g_aza.aza26='2' THEN                                                                                                           
       SELECT ze03 INTO comb_item FROM ze_file                                                                                      
         WHERE ze01='apj-605' AND ze02=g_lang                                                                                       
    ELSE 
       SELECT ze03 INTO comb_item FROM ze_file
         WHERE ze01='apj-604' AND ze02=g_lang
    END IF
    CALL cl_set_combo_items(comb_str,comb_value,comb_item)
END FUNCTION
#CHI-CA0064

