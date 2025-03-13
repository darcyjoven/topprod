# Prog. Version..: '5.30.06-13.04.22(00005)'     #
#Pattern name...: axmi411.4gl
#Descriptions...: 產品配比維護作業
#Date & Author..: No.FUN-A50011 10/05/25  By yangfeng
#Modify.........: No.FUN-B90105 11/09/26  By linlin 按不同版本維護產品尺碼配比比率
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30034 13/04/16 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
GLOBALS "../../config/top.global"
DEFINE g_odu     RECORD LIKE odu_file.*,
       g_odu_t   RECORD LIKE odu_file.*,
       g_odu01_t LIKE odu_file.odu01,
      
       g_odv     DYNAMIC ARRAY OF RECORD
         odv02   LIKE odv_file.odv02,
         tqa02_c LIKE tqa_file.tqa02, 
         odv03   LIKE odv_file.odv03
                 END RECORD,
       g_odv_t    RECORD
         odv02   LIKE odv_file.odv02,
         tqa02_c LIKE tqa_file.tqa02, 
         odv03   LIKE odv_file.odv03
                 END RECORD,
       g_wc,g_wc2,g_sql LIKE type_file.chr1000,
       g_rec_b          LIKE type_file.num5,
       l_ac	        LIKE type_file.num5	
DEFINE g_forupd_sql     STRING 
DEFINE g_before_input_done   LIKE type_file.num5 
DEFINE g_chr	             LIKE type_file.chr1	
DEFINE g_cnt  	             LIKE type_file.num10	
DEFINE g_msg  	             LIKE type_file.chr1000	
DEFINE g_curs_index          LIKE type_file.num10
DEFINE g_row_count           LIKE type_file.num10
DEFINE g_jump 		     LIKE type_file.num10
DEFINE g_no_ask		     LIKE type_file.num5
DEFINE g_odv03_count     LIKE type_file.num5          #FUN-B90105 ADD
MAIN
DEFINE p_row,p_col           LIKE type_file.num5
DEFINE l_time,l_today String
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
   IF(NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   WHENEVER ERROR CALL cl_err_msg_log
   IF(NOT cl_setup("AXM")) THEN
     EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   LET g_forupd_sql = "SELECT * FROM odu_file WHERE odu01 = ? FOR UPDATE " 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i411_cl CURSOR FROM g_forupd_sql
   LET p_row = 5
   LET p_col = 10

   LET l_today = g_today
   LET l_time =  g_time
   OPEN WINDOW i411_w AT p_row,p_col WITH FORM "axm/42f/axmi411"
   ATTRIBUTE(STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
   CALL i411_menu()
   CLOSE WINDOW i411_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
FUNCTION i411_cs()
   CLEAR FORM 
   CALL g_odv.clear()
   INITIALIZE g_odu.odu01 TO NULL
   DIALOG ATTRIBUTES(UNBUFFERED)
   CONSTRUCT BY NAME g_wc ON odu01,odu02,odu03,odu04
      {ON ACTION controlp
         CASE 
             WHEN INFIELD(odu01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.form = "p_odu"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
 		 DISPLAY g_qryparam.multiret TO odu01
	         NEXT FIELD odu01
             WHEN INFIELD(odu03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.form = "q_imz"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
 		 DISPLAY g_qryparam.multiret TO odu03
	         NEXT FIELD odu03
             WHEN INFIELD(odu04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.form = "q_geo"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
 		 DISPLAY g_qryparam.multiret TO odu04
	         NEXT FIELD odu04
             OTHERWISE 
                 EXIT CASE
         END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT  } 
    END CONSTRUCT
    {IF INT_FLAG THEN
       RETURN
    END IF
    IF g_priv2 = '4' THEN
       LET g_wc = g_wc CLIPPED," AND oduuser= '",g_user,"'"
    END IF
    IF g_priv3 = '4' THEN
       LET g_wc = g_wc CLIPPED," AND odugrup MATCHES '",g_grup CLIPPED,".*'"
    END IF }
    CONSTRUCT g_wc2 ON odv02,odv03
                    FROM s_odv[1].odv02,s_odv[1].odv03
    END CONSTRUCT
      ON ACTION controlp
         CASE 
             WHEN INFIELD(odu01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.form = "p_odu"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
 		 DISPLAY g_qryparam.multiret TO odu01
	         NEXT FIELD odu01
             WHEN INFIELD(odu03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.form = "q_imz"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
 		 DISPLAY g_qryparam.multiret TO odu03
	         NEXT FIELD odu03
             WHEN INFIELD(odu04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.form = "q_geo"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
 		 DISPLAY g_qryparam.multiret TO odu04
	         NEXT FIELD odu04
             WHEN INFIELD(odv02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.form = "q_tqa"
                 LET g_qryparam.arg1 = "26"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
 		 DISPLAY g_qryparam.multiret TO odv02
	         NEXT FIELD odv02
         END CASE
       ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE DIALOG 
       ON ACTION accept
           EXIT DIALOG
       ON ACTION exit
           LET INT_FLAG = TRUE
           EXIT DIALOG
       ON ACTION cancel
           LET INT_FLAG = TRUE
           EXIT DIALOG
       ON ACTION about
           CALL cl_about()
       ON ACTION help
           CALL cl_show_help()
       ON ACTION controlg
           CALL cl_cmdask()
    END DIALOG
    IF INT_FLAG THEN
       RETURN
    END IF
    IF g_priv2 = '4' THEN
       LET g_wc = g_wc CLIPPED," AND oduuser= '",g_user,"'"
    END IF
    IF g_priv3 = '4' THEN
       LET g_wc = g_wc CLIPPED," AND odugrup MATCHES '",g_grup CLIPPED,".*'"
    END IF
    IF g_wc2 = " 1=1" THEN
       LET g_sql = "SELECT odu01 FROM odu_file"," WHERE ",g_wc CLIPPED
    ELSE 
       LET g_sql = "SELECT odu01 ",
                   " FROM odu_file,odv_file",
                   " WHERE odu01 = odv01"," AND ",g_wc CLIPPED, " AND ",
                   g_wc2 CLIPPED 
    END IF
    PREPARE i411_prepare FROM g_sql
    DECLARE i411_cs SCROLL CURSOR WITH HOLD FOR i411_prepare
    IF g_wc2 = " 1=1" THEN
       LET g_sql = "SELECT COUNT(*) FROM odu_file WHERE ",g_wc CLIPPED
    ELSE 
       LET g_sql = "SELECT COUNT(DISTINCT odu01) FROM odu_file,odv_file WHERE",
                   " odu01 = odv01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE i411_precount FROM g_sql
    DECLARE i411_count CURSOR FOR i411_precount
END FUNCTION
FUNCTION i411_menu()
   WHILE TRUE
       CALL i411_bp("G")
       CASE g_action_choice
           WHEN "query" 
               IF cl_chk_act_auth() THEN
                     CALL i411_q()
               END IF
           WHEN "reproduce"
               IF cl_chk_act_auth() THEN
                     CALL i411_copy()
               END IF
  	   WHEN "insert"
  	       IF cl_chk_act_auth() THEN
                     CALL i411_a()
               END IF
           WHEN "delete"
               IF cl_chk_act_auth() THEN
                     CALL i411_r()
               END IF
           WHEN "detail"
               IF cl_chk_act_auth() THEN
                     CALL i411_b()
               ELSE 
                  LET g_action_choice = NULL
               END IF
           WHEN "modify"
               IF cl_chk_act_auth() THEN
                  CALL i411_u()
               END IF
           WHEN "related_document"
               IF cl_chk_act_auth() THEN
                  IF g_odu.odu01 IS NULL THEN
                      LET g_doc.column1 = "odu01"
                      LET g_doc.value1 = g_odu.odu01
                      CALL cl_doc()
                  END IF
               END IF
           WHEN "help"
               CALL cl_show_help()
           WHEN "controlg"
               CALL cl_cmdask()
           WHEN "exit"
               EXIT WHILE  
       END CASE
   END WHILE
END FUNCTION 
FUNCTION i411_bp(p_ud)
    DEFINE p_ud     LIKE type_file.chr1
    IF p_ud <>"G" OR g_action_choice = "detail" THEN
       RETURN
    END IF
    LET g_action_choice = ""
    CALL cl_set_act_visible("accept,cancel",FALSE)
    DISPLAY ARRAY g_odv TO s_odv.* ATTRIBUTE(COUNT = g_rec_b,UNBUFFERED)
        BEFORE DISPLAY
            CALL cl_navigator_setting(g_curs_index,g_row_count)
        BEFORE ROW
            LET l_ac = ARR_CURR()
        ON ACTION insert
            LET g_action_choice = "insert"
   	    EXIT DISPLAY
        ON ACTION query
            LET g_action_choice = "query"
            EXIT DISPLAY
        ON ACTION reproduce 
            LET g_action_choice = "reproduce"
            EXIT DISPLAY
        ON ACTION delete
            LET g_action_choice = "delete"
            EXIT DISPLAY
        ON ACTION detail
            LET g_action_choice = "detail"
            LET l_ac = 1
            EXIT DISPLAY
        ON ACTION modify
            LET g_action_choice = "modify"
            EXIT DISPLAY
        ON ACTION accept
            LET g_action_choice = "detail"
            LET l_ac = ARR_CURR()
            EXIT DISPLAY
        ON ACTION related_document
            LET g_action_choice = "related_document"
            EXIT DISPLAY
        ON ACTION first
            CALL i411_fetch('F')
            CALL cl_navigator_setting(g_curs_index,g_row_count)
            CALL fgl_set_arr_curr(1)
        ON ACTION previous
            CALL i411_fetch('P')
            CALL cl_navigator_setting(g_curs_index,g_row_count)
            CALL fgl_set_arr_curr(1)
        ON ACTION next
            CALL i411_fetch('N') 
            CALL cl_navigator_setting(g_curs_index,g_row_count)
            CALL fgl_set_arr_curr(1)
        ON ACTION last
            CALL i411_fetch('L')
            CALL cl_navigator_setting(g_curs_index,g_row_count)
            CALL fgl_set_arr_curr(1)
        ON ACTION jump
            CALL i411_fetch('/')
            CALL cl_navigator_setting(g_curs_index,g_row_count)
            CALL fgl_set_arr_curr(1)
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT DISPLAY
        ON ACTION cancel
            LET g_action_choice = "exit"
            EXIT DISPLAY
        ON ACTION controlg
            LET g_action_choice = "controlg"
            EXIT DISPLAY
        ON ACTION help
            LET g_action_choice = "help"
            EXIT DISPLAY
        ON ACTION locale
            CALL cl_dynamic_locale()
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DISPLAY
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel",TRUE)
END FUNCTION
FUNCTION i411_a()
    MESSAGE ""
    CLEAR FORM
    CALL g_odv.clear()
    IF s_shut(0) THEN
       RETURN
    END IF
    INITIALIZE g_odu.* LIKE odu_file.*
    LET g_odu01_t = NULL
    LET g_odu_t.* = g_odu.*
    LET g_odu.oduacti = 'Y'
    LET g_odu.odudate = g_today
    LET g_odu.oduuser = g_user
    LET g_odu.odugrup = g_grup
    LET g_odu.oduorig = g_grup
    LET g_odu.oduoriu = g_user
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i411_i("a")
        IF INT_FLAG THEN
           INITIALIZE g_odu.* TO NULL
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           EXIT WHILE
        END IF
        IF cl_null(g_odu.odu01) THEN
           CONTINUE WHILE
        END IF
        INSERT INTO odu_file VALUES(g_odu.*)
        IF SQLCA.sqlcode THEN
           CALL cl_err(g_odu.odu01,SQLCA.sqlcode,0)
           CONTINUE WHILE
        END IF
        LET g_odu01_t = g_odu.odu01
        LET g_odu_t.* = g_odu.*
       
        CALL g_odv.clear()
        CALL i411_b()
        EXIT WHILE
     END WHILE  
END FUNCTION
FUNCTION i411_i(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1,
          l_n     LIKE type_file.num5,
          l_input LIKE type_file.chr1
   IF s_shut(0) THEN
       RETURN
   END IF
   INPUT BY NAME g_odu.odu01,g_odu.odu02,g_odu.odu03,g_odu.odu04 WITHOUT DEFAULTS
       BEFORE INPUT
          LET l_input = 'N'
          LET g_before_input_done = "FALSE"
          CALL i411_set_entry(p_cmd)
          CALL i411_set_no_entry(p_cmd)
          LET g_before_input_done = "TRUE"
      AFTER FIELD odu01
          IF g_odu.odu01 IS NOT NULL THEN
              IF p_cmd = "a" OR (p_cmd = "u" AND g_odu.odu01 != g_odu01_t) THEN
                   SELECT count(*) INTO l_n FROM odu_file
                   WHERE odu01 = g_odu.odu01
		   IF l_n > 0 THEN
                        CALL cl_err(g_odu.odu01,-239,1)
			LET g_odu.odu01 = g_odu01_t
                        DISPLAY BY NAME g_odu.odu01
                        NEXT FIELD odu01
                   END IF
              END IF
          END IF
      AFTER FIELD odu03                                                         
          IF g_odu.odu03 IS NOT NULL THEN                                       
                   CALL i411_odu03('a')                                         
                   IF NOT cl_null(g_errno) THEN                                 
                        CALL cl_err("odu03:",g_errno,1)                         
                        LET g_odu.odu03 = NULL
                        DISPLAY BY NAME g_odu.odu03                             
                        NEXT FIELD odu03                                        
                   END IF                                                       
          END IF       
      AFTER FIELD odu04                                                         
          IF g_odu.odu04 IS NOT NULL THEN                                       
                   CALL i411_odu04('a')                                         
                   IF NOT cl_null(g_errno) THEN                                 
                        CALL cl_err("odu04:",g_errno,1)
                        LET g_odu.odu04 = NULL                          
                        DISPLAY BY NAME g_odu.odu04                             
                        NEXT FIELD odu04                                        
                   END IF                                                       
          END IF       
     AFTER INPUT
          IF INT_FLAG THEN
               EXIT INPUT
          END IF
          IF g_odu.odu01 IS NULL THEN
               DISPLAY BY NAME g_odu.odu01
               LET l_input = 'Y'
          END IF
     ON ACTION help
          CALL cl_show_help()
     ON ACTION about
   	  CALL cl_about()
     ON ACTION controlg
          CALL cl_cmdask()
     ON ACTION controlp
          CASE 
             WHEN INFIELD(odu03)
                 CALL cl_init_qry_var()
		 LET g_qryparam.form = "q_imz"
 		 LET g_qryparam.default1 = g_odu.odu03
  		 CALL cl_create_qry() RETURNING g_odu.odu03
		 DISPLAY BY NAME g_odu.odu03
 		 NEXT FIELD odu03
             WHEN INFIELD(odu04)
                 CALL cl_init_qry_var()
		 LET g_qryparam.form = "q_geo"
 		 LET g_qryparam.default1 = g_odu.odu04
  		 CALL cl_create_qry() RETURNING g_odu.odu04
		 DISPLAY BY NAME g_odu.odu04
 		 NEXT FIELD odu04
             OTHERWISE
                 EXIT CASE
          END CASE
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
    END INPUT
END FUNCTION
FUNCTION i411_set_entry(p_cmd)
    DEFINE p_cmd LIKE type_file.chr1
    IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
          CALL cl_set_comp_entry("odu01",TRUE) 
    END IF
END FUNCTION
FUNCTION i411_set_no_entry(p_cmd)
    DEFINE p_cmd LIKE type_file.chr1
    IF p_cmd = 'u' AND g_chkey = 'N' THEN
          CALL cl_set_comp_entry("odu01",FALSE)
    END IF
END FUNCTION
FUNCTION i411_copy()
   DEFINE l_newno     LIKE odu_file.odu01,
          l_oldno     LIKE odu_file.odu01,
          l_n         LIKE type_file.num5
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_odu.odu01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
   CALL i411_set_entry('a')
 
   CALL cl_set_head_visible("","YES")         
   INPUT l_newno FROM odu01
       BEFORE INPUT
          #CALL cl_set_docno_format("odu01")
 
      AFTER FIELD odu01
          IF g_odu.odu01 IS NOT NULL THEN
                   SELECT count(*) INTO l_n FROM odu_file
                   WHERE odu01 = g_odu.odu01
                   IF l_n > 0 THEN
                        CALL cl_err(g_odu.odu01,-239,1)
                        LET g_odu.odu01 = g_odu01_t
                        DISPLAY BY NAME g_odu.odu01
                        NEXT FIELD odu01
                   END IF
          END IF
 
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
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY BY NAME g_odu.odu01
      ROLLBACK WORK
      RETURN
   END IF
 
   DROP TABLE y
 
   SELECT * FROM odu_file         
       WHERE odu01=g_odu.odu01
       INTO TEMP y
 
   UPDATE y
       SET odu01=l_newno,             
           oduuser=g_user,            
           odugrup=g_grup,  
           odumodu=NULL,    
           odudate=g_today, 
           oduacti='Y',  
           oduoriu=g_user,
           oduorig=g_grup     
 
   INSERT INTO odu_file SELECT * FROM y
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","odu_file","","",SQLCA.sqlcode,"","",1)  
      ROLLBACK WORK
      RETURN
   ELSE
      COMMIT WORK
   END IF
 
   DROP TABLE x
 
   SELECT * FROM odv_file        
       WHERE odv01=g_odu.odu01
       INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)  
      RETURN
   END IF
 
   UPDATE x SET odv01=l_newno
 
   INSERT INTO odv_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
  #    ROLLBACK WORK      BY FUN-B90105 MAK
      CALL cl_err3("ins","odv_file","","",SQLCA.sqlcode,"","",1)  
       ROLLBACK WORK    # BY FUN-B90105 ADD
      RETURN
   ELSE
       COMMIT WORK 
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno = g_odu.odu01
   SELECT odu_file.* INTO g_odu.* FROM odu_file WHERE odu01 = l_newno
   CALL i411_u()
   CALL i411_b()
   #SELECT odu_file.* INTO g_odu.* FROM odu_file WHERE odu01 = l_oldno  #FUN-C80046
   #CALL i411_show()  #FUN-C80046
 
END FUNCTION
FUNCTION i411_odu03(p_cmd)
    DEFINE p_cmd    LIKE type_file.chr1,
           l_tqa02  LIKE imz_file.imz02
    LET g_errno = ''
    SELECT imz02 INTO l_tqa02 FROM imz_file
    WHERE imz01 = g_odu.odu03 AND imzacti = 'Y'
    CASE 
        WHEN SQLCA.sqlcode = 100 
             LET g_errno = 'axm-070'
             LET l_tqa02 = NULL
        OTHERWISE
             LET g_errno = SQLCA.sqlcode USING '------'
    END CASE
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
        DISPLAY l_tqa02 TO tqa02 
    END IF 
END FUNCTION
FUNCTION i411_odu04(p_cmd)
    DEFINE p_cmd      LIKE type_file.chr1,
           l_tqa02_b  LIKE geo_file.geo02
    LET g_errno = ''
    SELECT geo02 INTO l_tqa02_b FROM geo_file
    WHERE geo01 = g_odu.odu04 AND geoacti = 'Y'
    CASE 
        WHEN SQLCA.sqlcode = 100 
             LET g_errno = 'axm-070'
             LET l_tqa02_b = NULL
        OTHERWISE
             LET g_errno = SQLCA.sqlcode USING '------'
    END CASE
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
        DISPLAY l_tqa02_b TO tqa02_b 
    END IF 
END FUNCTION
FUNCTION i411_odv02(p_cmd)
    DEFINE p_cmd    LIKE type_file.chr1
    LET g_errno = ''
    SELECT tqa02 INTO g_odv[l_ac].tqa02_c FROM tqa_file
    WHERE tqa01 = g_odv[l_ac].odv02 AND tqaacti = 'Y' AND tqa03 = '26'
    CASE 
        WHEN SQLCA.sqlcode = 100 
             LET g_errno = 'axm-070'
             LET g_odv[l_ac].tqa02_c = NULL
        OTHERWISE
             LET g_errno = SQLCA.sqlcode USING '------'
    END CASE
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
        DISPLAY g_odv[l_ac].tqa02_c TO tqa02_c 
    END IF 
END FUNCTION
FUNCTION i411_b()
    DEFINE l_ac_t     LIKE type_file.num5,
           l_n        LIKE type_file.num5,
	   l_cnt      LIKE type_file.num5,
           l_lock_sw  LIKE type_file.chr1,
	   p_cmd      LIKE type_file.chr1, 
	   l_allow_insert  LIKE type_file.num5,
	   l_allow_delete  LIKE type_file.num5
    LET g_action_choice = ""
    IF s_shut(0) THEN
       RETURN
    END IF
    IF g_odu.odu01 IS NULL THEN
       RETURN
    END IF
    SELECT * INTO g_odu.* FROM odu_file WHERE odu01 = g_odu.odu01
    IF g_odu.oduacti = 'N' THEN
       CALL cl_err(g_odu.odu01,'mfg1000',0)
       RETURN
    END IF
    CALL cl_opmsg('b')
    LET g_forupd_sql = "SELECT odv02,'',odv03 FROM odv_file",
                       " WHERE odv01 = ? AND odv02 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i411_bcl CURSOR FROM g_forupd_sql
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
    INPUT ARRAY g_odv WITHOUT DEFAULTS FROM s_odv.*
        ATTRIBUTE(COUNT = g_rec_b,MAXCOUNT = g_max_rec, UNBUFFERED,
                  INSERT ROW = l_allow_insert,DELETE ROW = l_allow_delete,
                  APPEND ROW = l_allow_insert)
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'
            LET l_n = ARR_COUNT()
        BEGIN WORK
        OPEN i411_cl USING g_odu.odu01
        IF STATUS THEN
            CALL cl_err("OPEN i411_cl:",STATUS,1)
            CLOSE i411_cl
            ROLLBACK WORK
            RETURN
        END IF
        FETCH i411_cl INTO g_odu.*
        IF SQLCA.sqlcode THEN
            CALL cl_err(g_odu.odu01,SQLCA.sqlcode,0)
            CLOSE i411_cl
            ROLLBACK WORK
            RETURN
        END IF
        IF g_rec_b >= l_ac THEN
            LET p_cmd = 'u'
            LET g_odv_t.* = g_odv[l_ac].*
             
            OPEN i411_bcl USING g_odu.odu01,g_odv_t.odv02
              IF STATUS THEN
                 CALL cl_err("OPEN i411_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i411_bcl INTO g_odv[l_ac].*                                  
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_odv_t.odv02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
              SELECT tqa02 INTO g_odv[l_ac].tqa02_c  FROM tqa_file WHERE tqa01= g_odv[l_ac].odv02 AND tqaacti ='Y' AND tqa03 = '26'
              END IF
        END IF
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd = 'a'
           INITIALIZE g_odv[l_ac].* TO NULL
           LET g_odv_t.* = g_odv[l_ac].*
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
	      LET INT_FLAG =0
              CANCEL INSERT
           END IF
           INSERT INTO odv_file(odv01,odv02,odv03) VALUES(
               g_odu.odu01,
               g_odv[l_ac].odv02,
               g_odv[l_ac].odv03)
           IF SQLCA.sqlcode THEN
               CALL cl_err(g_odv[l_ac].odv02,SQLCA.sqlcode,0)
               CANCEL INSERT
           ELSE
               MESSAGE "INSERT O.K"
               COMMIT WORK
               LET g_rec_b = g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cni
           END IF
        AFTER FIELD odv02
           IF NOT cl_null(g_odv[l_ac].odv02) THEN
               IF g_odv[l_ac].odv02 != g_odv_t.odv02
                  OR g_odv_t.odv02 IS NULL THEN
                  SELECT count(*) INTO l_n FROM odv_file 
                  WHERE odv01 = g_odu.odu01 AND odv02 = g_odv[l_ac].odv02
                  IF l_n>0 THEN
                     CALL cl_err('',-239,0)
		     LET g_odv[l_ac].odv02 = g_odv_t.odv02
		     NEXT FIELD odv02
                  END IF
                  CALL i411_odv02('d')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,1)
                     LET g_odv[l_ac].odv02 = NULL
                     NEXT FIELD odv02
                  END IF
               END IF
            END IF
#FUN-B90105 add------begin-----
        AFTER FIELD odv03
           IF NOT cl_null(g_odv[l_ac].odv03) THEN
              IF g_odv[l_ac].odv03 < 0 THEN    
                 CALL cl_err(g_odv[l_ac].odv03,'axm1101',0)
                 LET g_odv[l_ac].odv03 = 0
              ELSE
                 LET g_odv03_count = 0            
                 CALL i411_odv03_count()
                 IF g_odv03_count + g_odv[l_ac].odv03 > 100 THEN   
                    CALL cl_err(g_odv03_count,'axm1102',0)
                    LET g_odv[l_ac].odv03 = 0
                    #DISPLAY g_odv[l_ac].odv03 TO odv03 
                    NEXT FIELD odv03
                 END IF                  
              END IF 
           END IF
#FUN-B90105 add---------end---------
        BEFORE DELETE 
            IF g_odv_t.odv02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                    CANCEL DELETE
                END IF
                IF l_lock_sw = 'Y' THEN
                    CALL cl_err("",-263,1)
		    CANCEL DELETE
                END IF
                DELETE FROM odv_file
                WHERE odv01 = g_odu.odu01
                  AND odv02 = g_odv_t.odv02
                IF SQLCA.sqlcode THEN
                    CALL cl_err(g_odv_t.odv02,SQLCA.sqlcode,0)
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b = g_rec_b - 1
                DISPLAY g_rec_b TO FORMONLY.cni
            END IF
            COMMIT WORK
      ON ROW CHANGE
            IF INT_FLAG THEN
                CALL cl_err('',9001,0)
		LET INT_FLAG = 0
                LET g_odv[l_ac].* = g_odv_t.*
                CLOSE i411_bcl
                ROLLBACK WORK
                EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_odv[l_ac].odv02,-263,1)
                LET g_odv[l_ac].* = g_odv_t.*
            ELSE
                UPDATE odv_file SET odv02 = g_odv[l_ac].odv02,
				    odv03 = g_odv[l_ac].odv03 
                WHERE odv01 = g_odu.odu01 AND odv02 = g_odv_t.odv02
                IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0  THEN
                    CALL cl_err(g_odv[l_ac].odv02,SQLCA.sqlcode,0)
                    LET g_odv[l_ac].* = g_odv_t.*
                ELSE 
 		    MESSAGE "UPDATE O.K"
		    COMMIT WORK
                END IF
            END IF
        AFTER ROW 
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac   #FUN-D30034 mark
            IF INT_FLAG THEN
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0 
                IF p_cmd = 'u' THEN
                   LET g_odv[l_ac].* = g_odv_t.*
                #FUN-D30034--add--begin--
                ELSE
                   CALL g_odv.deleteElement(l_ac)
                   IF g_rec_b != 0 THEN
                      LET g_action_choice = "detail"
                      LET l_ac = l_ac_t
                   END IF
                #FUN-D30034--add--end----
                END IF
                CLOSE i411_bcl
                ROLLBACK WORK
                EXIT INPUT
             END IF
             LET l_ac_t = l_ac   #FUN-D30034 add
             CLOSE i411_bcl
             COMMIT WORK
       ON ACTION controlo
           IF INFIELD(odv02) AND l_ac > 1 THEN
              LET g_odv[l_ac].* = g_odv[l_ac-1].*
              LET g_odv[l_ac].odv02 = g_rec_b+1
              NEXT FIELD odv02
           END IF
       ON ACTION controlz
           CALL cl_show_req_fields()
       ON ACTION controlg
           CALL cl_cmdask()
       ON ACTION itemno
           IF g_sma.sma38 matches '[Yy]' THEN
              CALL cl_cmdrun("aimi109")
           ELSE 
              CALL cl_err(g_sma.sma38,'mfg0035',1)
           END IF
       ON ACTION controlf
           CASE
              WHEN INFIELD(odv02)
                 CALL cl_fldhlp('odv02')
	      WHEN INFIELD(odv03)                                               
                 CALL cl_fldhlp('odv03')   
              OTHERWISE
                 CALL cl_fldhlp(' ')
           END CASE
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
        ON ACTION controlp
           CASE
              WHEN INFIELD(odv02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_tqa"
                  LET g_qryparam.arg1 = "26"
                  LET g_qryparam.where = "tqaacti = 'Y'"
                  LET g_qryparam.default1 = "g_odv[l_ac].odv02"
                  CALL cl_create_qry() RETURNING g_odv[l_ac].odv02
                  DISPLAY g_odv[l_ac].odv02 TO odv02
                  NEXT FIELD odv02
           END CASE
    END INPUT
    CLOSE i411_bcl
#   CALL i411_delall()        #CHI-C30002 mark
    CALL i411_delHeader()     #CHI-C30002 add
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION i411_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM  odu_file WHERE odu01 = g_odu.odu01
         INITIALIZE g_odu.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION i411_delall()
#   SELECT count(*) INTO g_cnt FROM odv_file WHERE odv01 = g_odu.odu01
#   IF g_cnt = 0 THEN
#       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#       ERROR g_msg CLIPPED
#       DELETE FROM odu_file WHERE odu01 = g_odu.odu01
#   END IF
#END FUNCTION
#CHI-C30002 -------- mark -------- end
FUNCTION i411_b_fill(l_wc2)
    DEFINE l_wc2  LIKE type_file.chr1000 
    LET g_sql = "SELECT odv02,tqa02,odv03 FROM odv_file LEFT OUTER JOIN tqa_file",
                "  ON odv02=tqa01 ",
                " WHERE odv01 = '",g_odu.odu01,"'",
                "  AND  tqa03 = '26'",
                "  AND ",l_wc2 CLIPPED
                
    PREPARE i411_pb FROM g_sql
    DECLARE odv_cs CURSOR FOR i411_pb
    CALL g_odv.clear()
    LET g_cnt = 1
    FOREACH odv_cs INTO g_odv[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt>g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
        END IF
    END FOREACH
    CALL g_odv.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cni
    LET g_cnt = 0
END FUNCTION
FUNCTION i411_show()
    LET g_odu_t.* = g_odu.*
    DISPLAY BY NAME g_odu.odu01,g_odu.odu02,g_odu.odu03,g_odu.odu04
    CALL i411_odu03('d')
    CALL i411_odu04('d')
    CALL i411_b_fill(g_wc2)
END FUNCTION
FUNCTION i411_r()
    IF s_shut(0) THEN
       RETURN
    END IF
    IF g_odu.odu01 IS NULL THEN
       CALL cl_err("",-400,0)
       RETURN
    END IF
    SELECT * INTO g_odu.* FROM odu_file WHERE odu01 = g_odu.odu01
    IF g_odu.oduacti = 'N' THEN
       CALL cl_err(g_odu.odu01,'mfg1000',0)
       RETURN
    END IF 
    BEGIN WORK
    OPEN i411_cl USING g_odu.odu01
    IF STATUS THEN
       CALL cl_err("OPEN i411_cl:",STATUS,1)
       CLOSE i411_cl
       ROLLBACK WORK
       RETURN
    END IF
    CALL i411_show()
    IF cl_delh(0,0) THEN
       DELETE FROM odu_file WHERE odu01 = g_odu.odu01
       DELETE FROM odv_file WHERE odv01 = g_odu.odu01
       CLEAR FORM
       CALL g_odv.clear()
       OPEN i411_count
       FETCH i411_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i411_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i411_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE
          CALL i411_fetch('/')
       END IF
    END IF
    CLOSE i411_cl
    COMMIT WORK
    CALL cl_flow_notify(g_odu.odu01,'D')
END FUNCTION
FUNCTION i411_u()
    IF s_shut(0) THEN
       RETURN
    END IF
    IF g_odu.odu01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    SELECT * INTO g_odu.* FROM odu_file WHERE odu01 = g_odu.odu01
    IF g_odu.oduacti = 'N' THEN
       CALL cl_err(g_odu.odu01,'mfg1000',0)
       RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_odu01_t = g_odu.odu01
    BEGIN WORK
    OPEN i411_cl USING g_odu.odu01
    IF STATUS THEN
       CALL cl_err("OPEN i411_cs:",STATUS,1)
       CLOSE i411_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i411_cl INTO g_odu.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_odu.odu01,SQLCA.sqlcode,0)
       CLOSE i411_cl
       ROLLBACK WORK
       RETURN
    END IF
    CALL i411_show()
    WHILE TRUE 
       LET g_odu01_t = g_odu.odu01
       LET g_odu.odumodu = g_user
       LET g_odu.odudate = g_today
       CALL i411_i("u")
       IF INT_FLAG THEN
          LET INT_FLAG = 0
          LET g_odu.* = g_odu_t.*
          CALL i411_show()
          CALL cl_err('','9001',0)
          EXIT WHILE
       END IF
       IF g_odu.odu01 != g_odu01_t THEN
          UPDATE odv_file SET odv01 = g_odu.odu01 WHERE odv01 = g_odu01_t
          IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
              CALL cl_err('odv',SQLCA.sqlcode,0)
              CONTINUE WHILE
          END IF
       END IF
       UPDATE odu_file SET odu_file.* = g_odu.* WHERE odu01 = g_odu.odu01
       IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
          CALL cl_err(g_odu.odu01,SQLCA.sqlcode,0)
          CONTINUE WHILE
       END IF
       EXIT WHILE
    END WHILE
    CLOSE i411_cl
    COMMIT WORK
    CALL cl_flow_notify(g_odu.odu01,'U')
END FUNCTION
FUNCTION i411_fetch(p_flag)
    DEFINE p_flag   LIKE type_file.chr1 
    CASE p_flag
       WHEN 'N' FETCH NEXT     i411_cs INTO g_odu.odu01
       WHEN 'P' FETCH PREVIOUS i411_cs INTO g_odu.odu01
       WHEN 'F' FETCH FIRST    i411_cs INTO g_odu.odu01
       WHEN 'L' FETCH LAST     i411_cs INTO g_odu.odu01
       WHEN '/'
           IF (NOT g_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
  		     CALL cl_on_idle()
               END PROMPT
               IF INT_FLAG THEN
                  LET INT_FLAG = 0
                  EXIT CASE
               END IF
           END IF
           FETCH ABSOLUTE g_jump i411_cs INTO g_odu.odu01
           LET g_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_odu.odu01,SQLCA.sqlcode,0)
        RETURN
    ELSE
       CASE p_flag
           WHEN 'F' LET g_curs_index = 1
           WHEN 'P' LET g_curs_index = g_curs_index - 1
           WHEN 'N' LET g_curs_index = g_curs_index + 1  
           WHEN 'L' LET g_curs_index = g_row_count  
           WHEN '/' LET g_curs_index = g_jump
       END CASE
       CALL cl_navigator_setting(g_curs_index,g_row_count)
       DISPLAY g_curs_index TO FORMONLY.idx
    END IF
    SELECT * INTO g_odu.* FROM odu_file WHERE odu01 = g_odu.odu01
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_odu.odu01,SQLCA.sqlcode,0)
       INITIALIZE g_odu.* TO NULL
       RETURN
    END IF
    CALL i411_show() 
END FUNCTION
FUNCTION i411_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_odv.clear()
    DISPLAY '' TO FORMONLY.cnt
    CALL i411_cs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       INITIALIZE g_odu.* TO NULL
       RETURN
    END IF
    OPEN i411_cs
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_odu.* TO NULL
    ELSE 
       OPEN i411_count
       FETCH i411_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL i411_fetch('F')
    END IF
END FUNCTION
#FUN-B90105 add------begin-----
FUNCTION i411_odv03_count()
 DEFINE l_odv03_count  LIKE odv_file.odv03 
    LET g_sql = "SELECT odv03 FROM odv_file ",
                " WHERE odv01 = '",g_odu.odu01,"'",
                "   AND odv02 <> '",g_odv[l_ac].odv02,"'"
                            
    PREPARE i411_odv03_count_pre FROM g_sql
    DECLARE i411_odv03_count_cs CURSOR FOR i411_odv03_count_pre
    FOREACH i411_odv03_count_cs INTO l_odv03_count
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET g_odv03_count = g_odv03_count + l_odv03_count
    END FOREACH 
END FUNCTION
#FUN-B90105 add------end-----
#FUN-A50011
