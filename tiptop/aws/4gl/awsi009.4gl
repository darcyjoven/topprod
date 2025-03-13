# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: awsi009.4gl                                                                                                      
# Descriptions...:                                                                                                                  
# Date & Author..: 07/03/15 By flowld                                                                                                 
# Modify.........: 新建立 FUN-8A0122 binbin 
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-B80064 11/08/05 By Lujh 模組程序撰寫規範修正
 
DATABASE ds                                                                                                                         
                                                                                                                                    
GLOBALS "../../config/top.global"
DEFINE  g_argv1          STRING
DEFINE  g_argv2          STRING
DEFINE  g_argv3          STRING
DEFINE  g_wak01          LIKE wak_file.wak01
DEFINE  g_wak01_t        LIKE wak_file.wak01
DEFINE  g_wak02          LIKE wak_file.wak02
DEFINE  g_wak02_t        LIKE wak_file.wak02
DEFINE  g_wak03          LIKE wak_file.wak03
DEFINE  g_wak03_t        LIKE wak_file.wak03 
DEFINE  g_wak            DYNAMIC ARRAY OF RECORD 
           wak04         LIKE wak_file.wak04,
           wak05         LIKE wak_file.wak05
                         END RECORD          
DEFINE  g_rec_b           LIKE type_file.num5
DEFINE  g_wc,g_wc2        STRING
DEFINE  g_sql             STRING
DEFINE  g_wak_t           RECORD 
           wak04          LIKE wak_file.wak04,
           wak05          LIKE wak_file.wak05
                          END RECORD
DEFINE  l_ac              LIKE type_file.num5
DEFINE  l_ac_t            LIKE type_file.num5
DEFINE  g_row_count       LIKE type_file.num5
DEFINE  g_curs_index      LIKE type_file.num5
DEFINE  g_jump            LIKE type_file.num5
DEFINE  g_no_ask          LIKE type_file.num5
DEFINE  g_msg             LIKE type_file.chr100
DEFINE  g_cnt             LIKE type_file.num5
DEFINE  g_forupd_sql      STRING          #鎖
 
MAIN
   OPTIONS                                        # 改變一些系統預設值
      INPUT NO WRAP
      DEFER INTERRUPT                             # 擷取中斷鍵, 由程式處理
 
     LET g_argv1 = ARG_VAL(1)
     LET g_argv2 = ARG_VAL(2)
     LET g_argv3 = ARG_VAL(3) 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AWS")) THEN
      EXIT PROGRAM
   END IF
       
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
    OPEN WINDOW awsi009_w WITH FORM "aws/42f/awsi009"
         ATTRIBUTE(STYLE=g_win_style CLIPPED)
    CALL cl_ui_init()
 
      IF NOT cl_null(g_argv1) THEN
         CALL i009_q()
        IF g_wak[1].wak04 IS NULL AND g_wak[1].wak05 IS NULL THEN
         CALL i009_a()
        END IF 
        LET g_argv1 = NULL
        LET g_argv2 = NULL
        LET g_argv3 = NULL
      END IF 
 
    CALL i009_menu()
 
    CLOSE WINDOW awsi009_w
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN 


FUNCTION i009_menu()
 
   WHILE TRUE
      
      IF g_action_choice = "exit" THEN
          EXIT WHILE
      END IF
 
       CALL i009_bp()
  
      CASE g_action_choice
        WHEN "insert"
          IF cl_chk_act_auth() THEN
             CALL i009_a()
          END IF
        WHEN "query"
          IF cl_chk_act_auth() THEN
             CALL i009_q()
          ELSE
            LET g_curs_index=0
          END IF   
        WHEN "delete"
          IF cl_chk_act_auth() THEN
             CALL i009_r()
          END IF
        WHEN "detail"
          IF cl_chk_act_auth() THEN
             CALL i009_b()
          END IF
        WHEN "cancel"
          EXIT WHILE
 
        WHEN "exit"
          EXIT WHILE
        WHEN "controlg"
          CALL cl_cmdask()
      END CASE
    END WHILE
END FUNCTION
FUNCTION i009_bp()
 
   CALL cl_set_act_visible("accept,cancel",FALSE)
   DISPLAY ARRAY g_wak TO s_wak.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      
   BEFORE DISPLAY
      CALL cl_navigator_setting(g_curs_index,g_row_count)
      
   ON ACTION insert
      LET g_action_choice="insert"
      EXIT DISPLAY 
   ON ACTION delete
      LET g_action_choice="delete"
      EXIT DISPLAY
 
   ON ACTION query
      LET g_action_choice="query"
      EXIT DISPLAY
   ON ACTION detail
      LET g_action_choice="detail"
      EXIT DISPLAY
   ON ACTION first
      CALL i009_fetch('F')
      CALL cl_navigator_setting(g_curs_index,g_row_count)
      IF g_rec_b != 0 THEN
        CALL fgl_set_arr_curr(1)
      END IF
   ON ACTION previous
      CALL i009_fetch('P')                                                                                                          
      CALL cl_navigator_setting(g_curs_index,g_row_count)                                                                           
      IF g_rec_b != 0 THEN                                                                                                          
        CALL fgl_set_arr_curr(1)                                                                                                     
      END IF
   ON ACTION jump
      CALL i009_fetch('/')                                                                                                          
      CALL cl_navigator_setting(g_curs_index,g_row_count)                                                                           
      IF g_rec_b != 0 THEN                                                                                                          
        CALL fgl_set_arr_curr(1)                                                                                                     
      END IF
   ON ACTION next
      CALL i009_fetch('N')                                                                                                          
      CALL cl_navigator_setting(g_curs_index,g_row_count)                                                                           
      IF g_rec_b != 0 THEN                                                                                                          
        CALL fgl_set_arr_curr(1)                                                                                                     
      END IF 
   ON ACTION last
      CALL i009_fetch('L')                                                                                                          
      CALL cl_navigator_setting(g_curs_index,g_row_count)                                                                           
      IF g_rec_b != 0 THEN                                                                                                          
        CALL fgl_set_arr_curr(1)                                                                                                     
      END IF
   ON ACTION exit
      LET g_action_choice="exit"
      EXIT DISPLAY
   ON ACTION controlg
      LET g_action_choice="controlg"
      EXIT DISPLAY
   ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE DISPLAY
   ON ACTION cancel
      LET g_action_choice = "exit"
      EXIT DISPLAY
  
   ON ACTION accept
      LET g_action_choice = "detail"
      LET l_ac = ARR_CURR()
      EXIT DISPLAY
 
  END DISPLAY
    CALL cl_set_act_visible("accept,cancel",TRUE)    
END FUNCTION
 
FUNCTION i009_a()
  DEFINE  l_i    LIKE type_file.num5
 
   MESSAGE ""
   CLEAR FORM
 
  IF NOT cl_null(g_argv1) THEN
    LET g_wak01 = g_argv1
    LET g_wak02 = g_argv2
    LET g_wak03 = g_argv3
    DISPLAY g_wak01,g_wak02,g_wak03 TO wak01,wak02,wak03
  ELSE  
    INPUT g_wak01,g_wak02,g_wak03 FROM wak01,wak02,wak03
     ATTRIBUTE(UNBUFFERED)
      
      AFTER FIELD wak01
        IF cl_null(g_wak01) THEN
           CALL cl_err('wak_file.wak01','aim-927',0)
           NEXT FIELD wak01
        ELSE 
           SELECT COUNT(*) INTO l_i FROM wac_file WHERE wac01=g_wak01
           IF l_i<1 THEN
              CALL cl_err("wac_file.wac01='"||g_wak01||"'",100,0)
              NEXT FIELD wak01
           END IF
        END IF
 
      AFTER FIELD wak02
        IF cl_null(g_wak02) THEN
           CALL cl_err('wak_file.wak02','aim-927',0)
           NEXT FIELD wak02
        ELSE 
           SELECT COUNT(*) INTO l_i FROM wac_file WHERE wac01=g_wak01 AND wac02=g_wak02
           IF l_i<1 THEN
              CALL cl_err("wac_file.wac02='"||g_wak02||"'",100,0)
              NEXT FIELD wak02
           END IF
        END IF
 
     AFTER FIELD wak03
        IF cl_null(g_wak03) THEN
           CALL cl_err('wak_file.wak03','aim-927',0)
           NEXT FIELD wak03
        ELSE 
           SELECT COUNT(*) INTO l_i FROM wac_file WHERE wac01=g_wak01 AND wac02=g_wak02 AND wac03=g_wak03
           IF l_i<1 THEN
              CALL cl_err("wac_file.wac03='"||g_wak03||"'",100,0)
              NEXT FIELD wak03
           END IF
        END IF
 
     ON ACTION controlp
       CASE 
          WHEN INFIELD(wak01)
              CALL cl_init_qry_var()                                                                                                
              LET g_qryparam.form = "q_wac"                                                                                         
              LET g_qryparam.state = "i"                                                                                            
              LET g_qryparam.default1=g_wak01 
              CALL cl_create_qry() RETURNING g_wak01                                                                    
               NEXT FIELD wak01
          WHEN INFIELD(wak02)       
              CALL cl_init_qry_var()                                                                                                
              LET g_qryparam.form = "q_wac1"                                                                                         
              LET g_qryparam.state = "i"                                                                                            
              LET g_qryparam.arg1= g_wak01
              LET g_qryparam.default1=g_wak02                                                                                       
              CALL cl_create_qry() RETURNING g_wak02                                                                                
               NEXT FIELD wak02
          WHEN INFIELD(wak03)
              CALL cl_init_qry_var()                                                                                                
              LET g_qryparam.form = "q_wac2"                                                                                         
              LET g_qryparam.state = "i"  
              LET g_qryparam.arg1= g_wak01
              LET g_qryparam.arg2= g_wak02                                                                                  
              LET g_qryparam.default1=g_wak03                                                                                       
              CALL cl_create_qry() RETURNING g_wak03                                                                                
               NEXT FIELD wak03
          OTHERWISE
              EXIT CASE
        END CASE
    END INPUT 
  END IF 
  WHILE TRUE
     IF INT_FLAG THEN 
       CALL g_wak.clear()
       LET INT_FLAG = 0
       CALL cl_err('',9001,0)
       EXIT WHILE
     END IF 
     CALL i009_b_fill(" 1=1")
     CALL i009_b()
     EXIT WHILE
  END WHILE
         
END FUNCTION
 
FUNCTION i009_cs()
   CLEAR FORM
   CALL g_wak.clear()
   
   IF NOT cl_null(g_argv1) THEN
       LET g_wc = " wak01 = '",g_argv1 CLIPPED,"'",
                  " AND wak02 = '",g_argv2 CLIPPED,"'",
                  " AND wak03 = '",g_argv3 CLIPPED,"'"
   ELSE 
    
     CONSTRUCT BY NAME g_wc ON wak01,wak02,wak03  
 
       ON ACTION controlp
         CASE
           WHEN INFIELD(wak01)
              CALL cl_init_qry_var()                                                                                            
              LET g_qryparam.form = "q_wac"                                                                                     
              LET g_qryparam.state = "i"                                                                                        
              CALL cl_create_qry() RETURNING g_wak01                                                                
              IF NOT cl_null(g_wak01) THEN
              DISPLAY g_wak01 TO wak01                                                                              
              END IF
               NEXT FIELD wak01
           WHEN INFIELD(wak02)                                                                                                      
              CALL cl_init_qry_var()                                                                                                
              LET g_qryparam.form = "q_wac1"                                                                                         
              LET g_qryparam.state = "i"       
              LET g_qryparam.arg1 = g_wak01                                                                                     
              CALL cl_create_qry() RETURNING g_wak02                                                                    
              IF NOT cl_null(g_wak02) THEN
              DISPLAY g_wak02 TO wak02                                                                                  
              END IF
               NEXT FIELD wak02
           WHEN INFIELD(wak03)                                                                                                      
              CALL cl_init_qry_var()                                                                                                
              LET g_qryparam.form = "q_wac2"                                                                                         
              LET g_qryparam.state = "i"
              LET g_qryparam.arg1 = g_wak01
              LET g_qryparam.arg2 = g_wak02
              CALL cl_create_qry() RETURNING g_wak03                                                                   
              IF NOT cl_null(g_wak03) THEN
              DISPLAY g_wak03 TO wak03                                                                                  
              END IF
               NEXT FIELD wak03
           OTHERWISE 
              EXIT CASE
       END CASE
 
          ON IDLE g_idle_seconds                                                                                                    
             CALL cl_on_idle()                                                                                                      
             CONTINUE CONSTRUCT
 
          ON ACTION help                                                                                                            
             CALL cl_show_help()                                                                                                    
          ON ACTION controlg                                                                                                        
             CALL cl_cmdask()                                                                                                       
          ON ACTION about                                                                                                           
             CALL cl_about()
 
      END CONSTRUCT                    
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
    END IF
                             
    IF INT_FLAG THEN 
      RETURN
    END IF
 
    LET g_sql="SELECT UNIQUE wak03,wak02,wak01 FROM wak_file ",
              " WHERE ",g_wc CLIPPED,
              " ORDER BY wak01 "
 
    PREPARE i009_prepare FROM g_sql
    DECLARE i009_curs 
       SCROLL CURSOR WITH HOLD FOR i009_prepare 
 
    LET g_sql = "SELECT COUNT(DISTINCT wak03) FROM wak_file ",
                " WHERE ",g_wc CLIPPED
         
    PREPARE i009_count_prepare FROM g_sql
    DECLARE i009_count_curs CURSOR FOR i009_count_prepare
     
 
END FUNCTION
FUNCTION i009_q()
    MESSAGE " "
#　　CLEAR FORM
    CALL g_wak.clear()
    LET g_curs_index = 0
    DISPLAY '  ' TO cnt
 
    CALL i009_cs()
 
     IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
     END IF
 
     OPEN i009_curs 
     IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_wak01 TO NULL
        INITIALIZE g_wak02 TO NULL
        INITIALIZE g_wak03 TO NULL  
     ELSE
        CALL i009_fetch('F')
        OPEN i009_count_curs 
        FETCH i009_count_curs INTO g_row_count
        DISPLAY g_row_count TO cnt1
     END IF
END FUNCTION
FUNCTION i009_fetch(p_flag)
   DEFINE p_flag   LIKE type_file.chr1
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     i009_curs INTO g_wak03,g_wak02,g_wak01 
      WHEN 'P' FETCH PREVIOUS i009_curs INTO g_wak03,g_wak02,g_wak01
      WHEN 'F' FETCH FIRST    i009_curs INTO g_wak03,g_wak02,g_wak01
      WHEN 'L' FETCH LAST     i009_curs INTO g_wak03,g_wak02,g_wak01
      WHEN '/' 
        IF (NOT g_no_ask) THEN
          CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
          LET INT_FLAG = 0
          PROMPT g_msg CLIPPED,':' FOR g_jump
          IF INT_FLAG THEN
             LET INT_FLAG = FALSE
             RETURN
          END IF
        END IF
        LET g_no_ask = FALSE
        FETCH ABSOLUTE g_jump i009_curs INTO g_wak03,g_wak02,g_wak01
    END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      LET g_wak01 = NULL
      LET g_wak02 = NULL
      LET g_wak03 = NULL 
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      CALL cl_navigator_setting(g_curs_index,g_row_count)
 
      CALL i009_show()
   END IF
END FUNCTION
FUNCTION i009_show()
 
    DISPLAY g_wak01,g_wak02,g_wak03,g_curs_index,g_row_count TO wak01,wak02,wak03,cnt,cnt1  
   
    CALL i009_b_fill(g_wc)
 
END FUNCTION       
FUNCTION i009_b_fill(p_wc)
    DEFINE 
         #p_wc   LIKE type_file.chr300
         p_wc         STRING       #NO.FUN-910082
 
    LET g_sql="SELECT wak04,wak05 FROM wak_file",
              " WHERE wak01 = '",g_wak01 CLIPPED,"'",
              "   AND wak02 = '",g_wak02 CLIPPED,"'",
              "   AND wak03 = '",g_wak03 CLIPPED,"'",
              "   AND ",p_wc CLIPPED,
              " ORDER BY wak04,wak05 "
 
    PREPARE i009_fill_prepare FROM g_sql
    DECLARE i009_fill_curs CURSOR FOR i009_fill_prepare
 
      CALL g_wak.clear()
      
     LET g_cnt = 1
     LET g_rec_b = 0
 
    FOREACH i009_fill_curs INTO g_wak[g_cnt].*
       LET g_rec_b = g_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1 
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_wak.deleteElement(g_cnt) 
 
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cnt2
    LET g_cnt = 0
END FUNCTION 
FUNCTION i009_b()
  DEFINE     l_allow_insert  LIKE type_file.num5
  DEFINE     l_allow_delete  LIKE type_file.num5
  DEFINE     l_n             LIKE type_file.num5
  DEFINE     l_lock_sw       LIKE type_file.chr1
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_wak01) OR cl_null(g_wak02) OR cl_null(g_wak03) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF  
 
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
    LET g_forupd_sql="SELECT wak04,wak05 FROM wak_file",
                     " WHERE wak01 = ? AND wak02 = ? AND wak03= ? AND wak04=? ",
                     " FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i009_lock_curs CURSOR FROM g_forupd_sql           #LOCK CURSOR
 
    INPUT ARRAY g_wak WITHOUT DEFAULTS FROM s_wak.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT    
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF 
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET g_wak_t.* = g_wak[l_ac].* 
 
            OPEN i009_lock_curs USING g_wak01,g_wak02,g_wak03,g_wak[l_ac].wak04
              IF SQLCA.sqlcode THEN
                 CALL cl_err("OPEN i009_lock_curs:", STATUS, 1)
                 LET l_lock_sw = 'Y'
              ELSE
                 FETCH i009_lock_curs INTO g_wak[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err('',SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         INITIALIZE g_wak[l_ac].* TO NULL   
         LET g_wak_t.* = g_wak[l_ac].*      
 
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF 
 
         INSERT INTO wak_file(wak01,wak02,wak03,wak04,wak05)
               VALUES (g_wak01,g_wak02,g_wak03,g_wak[l_ac].wak04,g_wak[l_ac].wak05)
 
         IF SQLCA.sqlcode THEN
            CALL cl_err('',SQLCA.sqlcode,0)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b = g_rec_b + 1
         END IF     
 
      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_wak_t.wak04) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF                
 
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
 
            DELETE FROM wak_file WHERE wak01 = g_wak01
                                  AND  wak02 = g_wak02
                                  AND  wak03 = g_wak03
                                  AND  wak04 = g_wak[l_ac].wak04
 
           IF SQLCA.sqlcode THEN
               CALL cl_err('',SQLCA.sqlcode,0)
               ROLLBACK WORK
               CANCEL DELETE
            END IF 
            LET g_rec_b = g_rec_b - 1
         END IF
         COMMIT WORK             
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_wak[l_ac].* = g_wak_t.*
            CLOSE i009_lock_curs
            ROLLBACK WORK
            EXIT INPUT
         END IF  
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_wak[l_ac].wak04,-263,1)
            LET g_wak[l_ac].* = g_wak_t.*
         ELSE
            UPDATE wak_file 
               SET wak01 = g_wak01,
                   wak02 = g_wak02,
                   wak03 = g_wak03,
                   wak04 = g_wak[l_ac].wak04,
                   wak05 = g_wak[l_ac].wak05
             WHERE wak01 = g_wak01
               AND wak02 = g_wak02
               AND wak03 = g_wak03
               AND wak04 = g_wak_t.wak04
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_wak[l_ac].wak04,SQLCA.sqlcode,0)
               LET g_wak[l_ac].* = g_wak_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CLOSE i009_lock_curs
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE i009_lock_curs
         COMMIT WORK
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
          
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
   END INPUT
   CLOSE i009_lock_curs
   COMMIT WORK
END FUNCTION
 
FUNCTION i009_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_wak01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   BEGIN WORK
   CALL i009_show()
 
   IF cl_delh(0,0) THEN
      DELETE FROM wak_file WHERE wak01 = g_wak01 AND wak02 =g_wak02 AND wak03 =g_wak03
      CLEAR FORM 
      CALL g_wak.clear()
      OPEN i009_count_curs
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE i009_curs
         CLOSE i009_count_curs
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      FETCH i009_count_curs INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i009_curs
         CLOSE i009_count_curs
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i009_curs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i009_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL i009_fetch('/')
      END IF
    END IF
    
    COMMIT WORK
    CALL cl_flow_notify(g_wak01,'D')
 
END FUNCTION
 
#No.FUN-8A0122
#FUN-B80064
