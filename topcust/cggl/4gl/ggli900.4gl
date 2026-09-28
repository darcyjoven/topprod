# Prog. Version..: '5.30.06-09.02.11(00009)'     #
# Pattern name...: scggls920.4gl
# Descriptions...: 财务月结参数设置档
# Date & Author..: 2013/06/03 By Exia

DATABASE ds
GLOBALS "../../../tiptop/config/top.global"

DEFINE p_row,p_col     LIKE type_file.num5
DEFINE g_forupd_sql    STRING
DEFINE g_cnt           LIKE type_file.num10  
DEFINE g_before_input_done    LIKE type_file.num5
DEFINE l_ac    LIKE type_file.num5
DEFINE g_rec_b  LIKE type_file.num5
DEFINE g_wc2    STRING
DEFINE g_sql    STRING
DEFINE g_curs_index        LIKE type_file.num10
DEFINE g_row_count         LIKE type_file.num10
DEFINE g_jump              LIKE type_file.num10
DEFINE g_no_ask            LIKE type_file.num5
DEFINE g_msg               STRING

DEFINE g_tc_aag DYNAMIC ARRAY OF RECORD
          tc_aag01  LIKE tc_aag_file.tc_aag01,
          aag02     LIKE aag_file.aag02,
          tc_aag02  LIKE tc_aag_file.tc_aag02,
          tc_aag03  LIKE tc_aag_file.tc_aag03,
          tc_aag04  LIKE tc_aag_file.tc_aag04
       END RECORD 
       
DEFINE g_tc_aag_t RECORD
          tc_aag01  LIKE tc_aag_file.tc_aag01,
          aag02     LIKE aag_file.aag02,
          tc_aag02  LIKE tc_aag_file.tc_aag02,
          tc_aag03  LIKE tc_aag_file.tc_aag03,
          tc_aag04  LIKE tc_aag_file.tc_aag04
       END RECORD 
DEFINE g_tc_aag00   LIKE tc_aag_file.tc_aag00
DEFINE tm         RECORD
          tc_aag00    LIKE  tc_aag_file.tc_aag00,
          tc_aag02    LIKE  tc_aag_file.tc_aag02,
          wc          STRING
                  END RECORD
MAIN

   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log
   WHENEVER ERROR CONTINUE

   IF (NOT cl_setup("CGGL")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   OPEN WINDOW ss920_w AT 0,0 WITH FORM "cggl/42f/ggli900"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

   CALL i900_menu()

   CLOSE WINDOW ss920_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION i900_cs()
   CLEAR FORM
   CALL g_tc_aag.clear()
   CONSTRUCT g_wc2 ON tc_aag00,tc_aag01,tc_aag02,tc_aag03,tc_aag04
        FROM tc_aag00,s_tc_aag[1].tc_aag01,s_tc_aag[1].tc_aag02,
             s_tc_aag[1].tc_aag03,s_tc_aag[1].tc_aag04
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      
      ON ACTION controlp
         CASE
            WHEN INFIELD(tc_aag00)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aaa"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tc_aag00
               NEXT FIELD tc_aag00
            WHEN INFIELD(tc_aag01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag02"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tc_aag01
               NEXT FIELD tc_aag01

             OTHERWISE
                EXIT CASE
         END CASE

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
      ON ACTION about
         CALL cl_about()
      ON ACTION HELP
         CALL cl_show_help()
      ON ACTION controlg
         CALL cl_cmdask()
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()
   END CONSTRUCT
   IF INT_FLAG THEN
      LET g_wc2 = NULL
      RETURN
   END IF

   LET g_sql = "SELECT DISTINCT tc_aag00 FROM tc_aag_file ",
               " WHERE ",g_wc2 CLIPPED, 
               " ORDER BY tc_aag00"
   PREPARE i900_prepare FROM g_sql
   DECLARE i900_cs SCROLL CURSOR WITH HOLD FOR i900_prepare 
   LET g_sql="SELECT COUNT(DISTINCT tc_aag00) FROM tc_aag_file WHERE ",g_wc2 CLIPPED
   PREPARE i900_precount FROM g_sql
   DECLARE i900_count CURSOR FOR i900_precount
END FUNCTION

FUNCTION i900_menu()
   WHILE TRUE
      CALL i900_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i900_a()
            END IF

         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i900_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i900_b() 
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "fast_get"
            IF cl_chk_act_auth() THEN
               CALL i900_g()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg" 
            CALL cl_cmdask() 
      END CASE
   END WHILE
END FUNCTION

FUNCTION i900_bp(p_ud) 
DEFINE p_ud   LIKE type_file.chr1
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tc_aag TO  s_tc_aag.*  ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
     
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      #整批生成
      ON ACTION fast_get
         LET g_action_choice="fast_get"
         EXIT DISPLAY
      ON ACTION first
         CALL i900_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
      ON ACTION previous
         CALL i900_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY  
      ON ACTION jump
         CALL i900_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
      ON ACTION next
         CALL i900_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
      ON ACTION last
         CALL i900_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
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
      ON ACTION cancel
         LET INT_FLAG=FALSE 
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
      ON ACTION about
         CALL cl_about()
      AFTER DISPLAY
         CONTINUE DISPLAY
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i900_a()
   
   CLEAR FORM
   CALL g_tc_aag.clear()
   LET g_wc2= NULL 

   IF s_shut(0) THEN
      RETURN
   END IF

   CALL cl_set_head_visible("","YES")
   INPUT g_tc_aag00 FROM tc_aag00
      ON ACTION controlp
         CASE
            WHEN INFIELD(tc_aag00)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aaa"
               LET g_qryparam.default1 = g_tc_aag00
               CALL cl_create_qry() RETURNING g_tc_aag00
               DISPLAY g_tc_aag00 TO tc_aag00
               NEXT FIELD tc_aag00
            OTHERWISE EXIT CASE    
         END CASE
      ON ACTION CONTROLG
         CALL cl_cmdask()
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
      ON ACTION about   
         CALL cl_about() 
      ON ACTION help    
         CALL cl_show_help()
   END INPUT

   CALL i900_b_fill(" 1=1")
   CALL i900_b()

END FUNCTION

FUNCTION i900_fetch(p_flag)
DEFINE  p_flag     LIKE type_file.chr1 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i900_cs INTO g_tc_aag00
      WHEN 'P' FETCH PREVIOUS i900_cs INTO g_tc_aag00
      WHEN 'F' FETCH FIRST    i900_cs INTO g_tc_aag00
      WHEN 'L' FETCH LAST     i900_cs INTO g_tc_aag00
      WHEN '/'
         IF (NOT g_no_ask) THEN    
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0
            PROMPT g_msg CLIPPED,': ' FOR g_jump
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
               ON ACTION about    
                  CALL cl_about()
               ON ACTION help   
                  CALL cl_show_help()
               ON ACTION controlg   
                  CALL cl_cmdask() 
            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               EXIT CASE
            END IF
         END IF
      FETCH ABSOLUTE g_jump i900_cs INTO g_tc_aag00
      LET g_no_ask = FALSE 
   END CASE
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tc_aag00,SQLCA.sqlcode,0)
      RETURN
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
   DISPLAY g_tc_aag00 TO tc_aag00
   CALL i900_b_fill(g_wc2)
END FUNCTION

FUNCTION i900_b()
DEFINE l_ac_t          LIKE type_file.num5,
       l_n             LIKE type_file.num5,
       l_lock_sw       LIKE type_file.chr1,
       p_cmd           LIKE type_file.chr1,
       l_allow_insert  LIKE type_file.num5,
       l_allow_delete  LIKE type_file.num5, 
       l_cnt           LIKE type_file.num10 

   LET g_action_choice = ""
   IF s_shut(0) THEN 
      RETURN 
   END IF
   IF cl_null(g_tc_aag00) THEN
      RETURN
   END IF 
   CALL cl_opmsg('b')
   LET g_forupd_sql = "SELECT tc_aag01,'',tc_aag02,tc_aag03,tc_aag04 ", 
                      "  FROM tc_aag_file WHERE tc_aag00=? AND tc_aag01=? ",
                       "  FOR UPDATE NOWAIT " 
   DECLARE i900_bcl CURSOR FROM g_forupd_sql
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
   INPUT ARRAY g_tc_aag WITHOUT DEFAULTS FROM s_tc_aag.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED,
           INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)        
   
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
      BEFORE ROW
         LET p_cmd = ''
         LET g_errno=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_tc_aag_t.* = g_tc_aag[l_ac].*
            BEGIN WORK
            OPEN i900_bcl USING g_tc_aag00,g_tc_aag_t.tc_aag01
            IF STATUS THEN
               CALL cl_err("OPEN i900_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE  
               FETCH i900_bcl INTO g_tc_aag[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_tc_aag_t.tc_aag01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               LET g_tc_aag[l_ac].aag02 = g_tc_aag_t.aag02
            END IF
            CALL i900_set_entry_b(p_cmd)    
            CALL i900_set_no_entry_b(p_cmd) 
            CALL cl_show_fld_cont()
         END IF

      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_tc_aag[l_ac].* TO NULL
         LET g_tc_aag[l_ac].tc_aag04='Y'
         LET g_tc_aag_t.* = g_tc_aag[l_ac].*
         CALL cl_show_fld_cont()
         CALL i900_set_entry_b(p_cmd)   
         CALL i900_set_no_entry_b(p_cmd)
         NEXT FIELD tc_aag01
           
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO tc_aag_file(tc_aag00,tc_aag01,tc_aag02,tc_aag03,tc_aag04,tc_aaguser,tc_aaggrup,
                                 tc_aagmodu,tc_aagdate,tc_aagoriu,tc_aagorig) 
                         VALUES(g_tc_aag00,g_tc_aag[l_ac].tc_aag01,g_tc_aag[l_ac].tc_aag02,g_tc_aag[l_ac].tc_aag03,
                                g_tc_aag[l_ac].tc_aag04,g_user,g_grup,'','',g_user,g_grup)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","tc_aag_file",g_tc_aag00,g_tc_aag[l_ac].tc_aag01,SQLCA.sqlcode,"","",1) 
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF

      AFTER FIELD tc_aag01
         IF NOT cl_null(g_tc_aag[l_ac].tc_aag01) THEN
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM aag_file 
             WHERE aag00 = g_tc_aag00 AND aag01 = g_tc_aag[l_ac].tc_aag01
               #AND aag07 IN('2','3') 
               AND aagacti = 'Y' 
            IF cl_null(l_n) THEN LET l_n = 0 END IF 
            IF l_n = 0 THEN
               CALL cl_err('录入的科目编号不存在',"!",0)
               NEXT FIELD tc_aag01
            END IF 
            SELECT aag02 INTO g_tc_aag[l_ac].aag02 FROM aag_file WHERE aag00 = g_tc_aag00 AND aag01 = g_tc_aag[l_ac].tc_aag01
         END IF 

      BEFORE DELETE
         IF NOT cl_null(g_tc_aag_t.tc_aag01)THEN
            IF NOT cl_delete() THEN
                CANCEL DELETE
            END IF     

            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF     
            DELETE FROM tc_aag_file WHERE tc_aag00 = g_tc_aag00 AND tc_aag01 = g_tc_aag_t.tc_aag01
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","tc_aag_file",g_tc_aag_t.tc_aag01,"",SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2 
            MESSAGE "Delete OK"
            CLOSE i900_bcl
            COMMIT WORK
         END IF

      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_tc_aag[l_ac].* = g_tc_aag_t.*
            CLOSE i900_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_tc_aag[l_ac].tc_aag02,-263,1)
            LET g_tc_aag[l_ac].* = g_tc_aag_t.*
         ELSE
            UPDATE tc_aag_file SET tc_aag01=g_tc_aag[l_ac].tc_aag01,
                                   tc_aag02=g_tc_aag[l_ac].tc_aag02,
                                   tc_aag03=g_tc_aag[l_ac].tc_aag03,
                                   tc_aag04=g_tc_aag[l_ac].tc_aag04
                WHERE tc_aag00 = g_tc_aag00
                  AND  tc_aag01 = g_tc_aag_t.tc_aag01
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","tc_aag_file",g_tc_aag_t.tc_aag01,"",SQLCA.sqlcode,"","",1) 
               LET g_tc_aag[l_ac].* = g_tc_aag_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               CLOSE i900_bcl
               COMMIT WORK
            END IF
         END IF
      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_tc_aag[l_ac].* = g_tc_aag_t.*
            END IF
            CLOSE i900_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE i900_bcl
         COMMIT WORK
      ON ACTION controlp
         CASE
            WHEN INFIELD(tc_aag01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag02"
               LET g_qryparam.arg1 = g_tc_aag00
               LET g_qryparam.default1 = g_tc_aag[l_ac].tc_aag01
               CALL cl_create_qry() RETURNING g_tc_aag[l_ac].tc_aag01
               DISPLAY BY NAME g_tc_aag[l_ac].tc_aag01
               NEXT FIELD tc_aag01
            OTHERWISE EXIT CASE     
         END CASE
    
      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT 
      ON ACTION about 
         CALL cl_about() 
 
      ON ACTION help        
         CALL cl_show_help()      
   END INPUT
END FUNCTION

FUNCTION i900_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   DISPLAY ' ' TO FORMONLY.cn2
   CALL i900_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN i900_cs      
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
   ELSE
      OPEN i900_count
      FETCH i900_count INTO g_row_count
      CALL i900_fetch('F')             
   END IF
END FUNCTION

FUNCTION i900_b_fill(p_wc2)
DEFINE p_wc2  STRING  
   LET g_sql = "SELECT tc_aag01,'',tc_aag02,tc_aag03,tc_aag04 ",
               " FROM tc_aag_file",
               " WHERE tc_aag00 ='",g_tc_aag00,"' AND ", p_wc2 CLIPPED,
               " ORDER BY 1"
   PREPARE i900_pb FROM g_sql
   DECLARE tc_aag_curs CURSOR FOR i900_pb
   CALL g_tc_aag.clear()
   LET g_cnt = 1

   FOREACH tc_aag_curs INTO g_tc_aag[g_cnt].*
      IF STATUS THEN 
         CALL cl_err('foreach:',STATUS,1) 
         EXIT FOREACH 
      END IF
      SELECT aag02 INTO g_tc_aag[g_cnt].aag02 FROM aag_file WHERE aag00 = g_tc_aag00 AND aag01 = g_tc_aag[g_cnt].tc_aag01
      LET g_cnt = g_cnt + 1    
   END FOREACH
   CALL g_tc_aag.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2 
   LET g_cnt = 0    
END FUNCTION

FUNCTION i900_set_entry_b(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1   
   IF p_cmd = 'a' THEN
      CALL cl_set_comp_entry("tc_aag01",TRUE)
   END IF 
END FUNCTION
 
FUNCTION i900_set_no_entry_b(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1
   IF p_cmd = 'u' THEN
      CALL cl_set_comp_entry("tc_aag01",FALSE)
   END IF 
END FUNCTION 


#整批生成
FUNCTION i900_g()
DEFINE l_n   LIKE  type_file.num5

   OPEN WINDOW ggli900_1_w WITH FORM "cggl/42f/ggli900_1"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
   INITIALIZE tm.* TO NULL
   WHILE TRUE
      INPUT BY NAME tm.tc_aag00,tm.tc_aag02 WITHOUT DEFAULTS
         AFTER FIELD tc_aag00
            IF NOT cl_null(tm.tc_aag00) THEN
               LET l_n = 0
               SELECT COUNT(*) INTO l_n FROM aaa_file WHERE aaa01 = tm.tc_aag00
               IF cl_null(l_n) THEN
                  CALL cl_err('录入的帐套不存在','!',0)
                  NEXT FIELD tc_aag00
               END IF
            END IF
         ON ACTION controlp
            CASE
               WHEN INFIELD(tc_aag00)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aaa"
                  LET g_qryparam.default1 = tm.tc_aag00
                  CALL cl_create_qry() RETURNING tm.tc_aag00
                  DISPLAY tm.tc_aag00 TO tc_aag00
                  NEXT FIELD tc_aag00
               OTHERWISE EXIT CASE
            END CASE
         ON ACTION controlg
            CALL cl_cmdask()
         ON ACTION EXIT
            LET INT_FLAG = 1
            EXIT INPUT
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         EXIT WHILE
      END IF

      CONSTRUCT tm.wc ON aag01 FROM aag01
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(aag01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "cq_aag02"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.arg1 = tm.tc_aag00
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO aag01
                  NEXT FIELD aag01
            END CASE
         ON ACTION controlg
            CALL cl_cmdask()
         ON ACTION EXIT
            LET INT_FLAG = 1
            EXIT CONSTRUCT
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
      END CONSTRUCT

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         EXIT WHILE
      END IF 

      IF NOT cl_sure(18,20) THEN
         CLOSE WINDOW ggli900_1_w
         RETURN
      END IF
      LET g_success = 'Y'
      BEGIN WORK
      CALL i900_insdb()
      IF g_success = 'Y' THEN
         CALL cl_err('数据更新成功','!',0)
         COMMIT WORK
      ELSE
         CALL cl_err('数据更新失败','!',0)
         ROLLBACK WORK
      END IF
   END WHILE 
   CLOSE WINDOW ggli900_1_w
END FUNCTION

#将数据写入到表中
FUNCTION i900_insdb()
DEFINE l_sql     STRING
DEFINE l_tc_aag  RECORD LIKE tc_aag_file.*

   LET l_sql = "SELECT aag01 FROM aag_file ",
               " WHERE aag00 = '",tm.tc_aag00,"' ",
               "   AND ",tm.wc,
               "   AND (aag07='2' OR aag07='3') AND aagacti ='Y' "
   PREPARE i900_pre_g FROM l_sql
   DECLARE i900_cs_g CURSOR FOR i900_pre_g
   FOREACH i900_cs_g INTO l_tc_aag.tc_aag01
      LET l_tc_aag.tc_aag00 = tm.tc_aag00
      LET l_tc_aag.tc_aag02 = tm.tc_aag02
      LET l_tc_aag.tc_aag04 = 'Y'
      LET l_tc_aag.tc_aaguser = g_user
      LET l_tc_aag.tc_aaggrup = g_grup
      LET l_tc_aag.tc_aagoriu = g_user
      LET l_tc_aag.tc_aagorig = g_grup
      LET l_tc_aag.tc_aagmodu = ''
      LET l_tc_aag.tc_aagdate = ''
      INSERT INTO tc_aag_file VALUES(l_tc_aag.*)
      IF SQLCA.sqlcode THEN
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
            UPDATE tc_aag_file SET tc_aag02 = l_tc_aag.tc_aag02,
                                   tc_aag04 = l_tc_aag.tc_aag04,
                                   tc_aagmodu = g_user,
                                   tc_aagdate = g_today
             WHERE tc_aag00 = l_tc_aag.tc_aag00 AND tc_aag01 = l_tc_aag.tc_aag01
         ELSE
            CALL cl_err3("ins","tc_aag_file",l_tc_aag.tc_aag00,l_tc_aag.tc_aag01,SQLCA.sqlcode,"","",1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF
      END IF
      INITIALIZE l_tc_aag.* TO NULL
   END FOREACH
END FUNCTION
