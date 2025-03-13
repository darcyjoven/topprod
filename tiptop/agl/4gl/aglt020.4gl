# Prog. Version..: '5.30.06-13.04.22(00003)'     #
# Pattern name...: aglt020.4gl
# Descriptions...: 合併直接法項目調整作業
# Date & Author..: 2011/03/24 By zhangweib
# Modify.........: NO.FUN-B40104 11/05/05 By jll   合并报表作业
# Modify.........: NO.TQC-B70103 11/07/18 By yinhy 查詢時，合并帳套和最上層公司位置錯了
# Modify.........: No:FUN-D30032 13/04/01 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_aet      RECORD
       aet01      LIKE aet_file.aet01,
       aet02      LIKE aet_file.aet02,
       aet03      LIKE aet_file.aet03
                  END RECORD
DEFINE g_aet_t    RECORD
       aet01      LIKE aet_file.aet01,
       aet02      LIKE aet_file.aet02,
       aet03      LIKE aet_file.aet03
                  END RECORD
DEFINE g_aet_b    DYNAMIC ARRAY OF RECORD
       aet04      LIKE aet_file.aet04,
       aet05      LIKE aet_file.aet05,
       aet05_1    LIKE nml_file.nml02,
       aet06      LIKE aet_file.aet06,
       aet07      LIKE aet_file.aet07,
       aet08      LIKE aet_file.aet08,
       aet09      LIKE aet_file.aet09
                  END RECORD
DEFINE g_aet_b_t RECORD
       aet04      LIKE aet_file.aet04,
       aet05      LIKE aet_file.aet05,
       aet05_1    LIKE nml_file.nml02,
       aet06      LIKE aet_file.aet06,
       aet07      LIKE aet_file.aet07,
       aet08      LIKE aet_file.aet08,
       aet09      LIKE aet_file.aet09
                  END RECORD
DEFINE p_cmd      LIKE type_file.chr1 
DEFINE l_table    STRING 
DEFINE g_str      STRING
DEFINE g_sql      STRING
DEFINE g_rec_b    LIKE type_file.num10
DEFINE g_wc       STRING 
DEFINE l_ac       LIKE type_file.num5
DEFINE g_sql_tmp  STRING

DEFINE g_forupd_sql    STRING 
DEFINE g_cnt           LIKE type_file.num10    
DEFINE g_i             LIKE type_file.num5    
DEFINE g_msg           LIKE ze_file.ze03     
DEFINE g_row_count     LIKE type_file.num10 
DEFINE g_curs_index    LIKE type_file.num10
DEFINE g_jump          LIKE type_file.num10 
DEFINE mi_no_ask       LIKE type_file.num5 
DEFINE g_before_input_done  LIKE type_file.num5
DEFINE g_dbs_axz03     LIKE axz_file.axz03   #TQC-B70103

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT          

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time 

   OPEN WINDOW aglt020 WITH FORM "agl/42f/aglt020" ATTRIBUTE(STYLE = g_win_style)              
                                                                                
   CALL cl_ui_init()                                                           

   CALL t020_menu()                                                            
   CLOSE WINDOW aglt020 

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION t020_cs()
   CLEAR FORM  
   CALL g_aet_b.clear()
   CALL cl_set_head_visible("","YES")     

   CONSTRUCT g_wc ON aet01,aet02,aet03,aet04,aet05,aet06,aet07,aet08,aet09
                FROM aet01,aet02,aet03,s_aet1[1].aet04,s_aet1[1].aet05,
                     s_aet1[1].aet06,s_aet1[1].aet07,s_aet1[1].aet08,
                     s_aet1[1].aet09

      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION controlp 
         CASE
          WHEN INFIELD(aet01)                                                                                                 
             CALL cl_init_qry_var()                                                                                           
             LET g_qryparam.state = "c"                                                                                       
             LET g_qryparam.form ="q_aep01"                                                                               
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aet01                                                                             
             NEXT FIELD aet01
          WHEN INFIELD(aet04)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_axz"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aet04           
             NEXT FIELD aet04
          WHEN INFIELD(aet05)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_nml"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aet05
             NEXT FIELD aet05
          WHEN INFIELD(aet08)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_axz"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aet08           
             NEXT FIELD aet08
          OTHERWISE
             EXIT CASE
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

   IF INT_FLAG THEN RETURN END IF
   LET g_sql="SELECT UNIQUE aet01,aet02,aet03 FROM aet_file ",
             " WHERE ", g_wc CLIPPED,
             " ORDER BY aet01,aet02,aet03 "
   PREPARE t020_prepare FROM g_sql 
   DECLARE t020_b_cs
       SCROLL CURSOR WITH HOLD FOR t020_prepare

   LET g_sql_tmp= "SELECT UNIQUE aet01,aet02,aet03 FROM aet_file ",                                                     
                  " WHERE ",g_wc CLIPPED,                                                                                     
                  "   INTO TEMP x"                                                                                            
   DROP TABLE x                                                                                                               
   PREPARE t020_pre_x FROM g_sql_tmp
   EXECUTE t020_pre_x                                                                                                         
   LET g_sql = "SELECT COUNT(*) FROM x"                                                                                       
   PREPARE t020_precount FROM g_sql
   DECLARE t020_count CURSOR FOR t020_precount
END FUNCTION

FUNCTION t020_menu()
   WHILE TRUE
      CALL t020_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t020_a()
            END IF
     #   WHEN "modify"
     #      IF cl_chk_act_auth() THEN
     #         CALL t020_u()
     #      END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t020_r()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t020_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t020_q() 
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
          #    CALL t020_out()
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

FUNCTION t020_a()
   DEFINE li_chk_bookno  LIKE type_file.num5  
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_sw           LIKE type_file.chr1, 
          l_cmd          LIKE type_file.chr1000, 
          l_n            LIKE type_file.num5

   IF s_shut(0) THEN RETURN END IF   
   MESSAGE ""
   INITIALIZE g_aet.* TO NULL 
   CLEAR FORM
   CALL g_aet_b.clear()
   CALL cl_opmsg('a')
   
   WHILE TRUE
      CALL t020_i("a")  
      IF INT_FLAG THEN    
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      CALL g_aet_b.clear()
      SELECT COUNT(*) INTO l_n FROM aet_file WHERE aet01 = g_aet.aet01
                                               AND aet02 = g_aet.aet02 
                                               AND aet03 = g_aet.aet03
      LET g_rec_b = 0
      IF l_n > 0 THEN
         CALL t020_b_fill('1=1')
      END IF
      CALL t020_b()
     
 
      LET g_aet_t.aet01 = g_aet.aet01
      LET g_aet_t.aet02 = g_aet.aet02
      LET g_aet_t.aet03 = g_aet.aet03

      EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION t020_i(p_cmd)
DEFINE
   p_cmd           LIKE type_file.chr1,  
   l_cnt           LIKE type_file.num5,       
   l_n1,l_n        LIKE type_file.num5,      
   l_axa02         LIKE axa_file.axa02,
   l_axa03         LIKE axa_file.axa03

   CALL cl_set_head_visible("","YES")
   INPUT BY NAME g_aet.aet01,g_aet.aet02,g_aet.aet03 WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t020_set_entry(p_cmd)
         CALL t020_set_no_entry(p_cmd)
         CALL cl_qbe_init()

 
      AFTER FIELD aet01
         IF NOT cl_null(g_aet.aet01) THEN
            SELECT COUNT(*) INTO l_n FROM axa_file WHERE axa01 = g_aet.aet01 AND axa04 = 'Y'
            IF l_n = 0 THEN
               CALL cl_err(g_aet.aet01,100,0)
               NEXT FIELD aet01
            END IF
            SELECT axa02,axa03 INTO l_axa02,l_axa03 FROM axa_file WHERE axa01 = g_aet.aet01 AND axa04 = 'Y'
         ELSE
            LET l_axa02 = NULL
            LET l_axa03 = NULL
         END IF
         DISPLAY l_axa02 TO FORMONLY.aet01_2
         DISPLAY l_axa03 TO FORMONLY.aet01_1

      AFTER FIELD aet02
         IF NOT cl_null(g_aet.aet02) THEN
            IF g_aet.aet02 < 0 THEN
               CALL cl_err(g_aet.aet02,'afa-370',0)
               NEXT FIELD aet02
            END IF
         END IF

      AFTER FIELD aet03
         IF NOT cl_null(g_aet.aet03) THEN
            IF g_aet.aet03 < 0 OR g_aet.aet03 > 12 THEN
               CALL cl_err(g_aet.aet03,'agl-020',0)
               NEXT FIELD aet03
            END IF 
         END IF

      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF

      ON ACTION controlp
         CASE
            WHEN INFIELD(aet01)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_axa1"
               LET g_qryparam.default1 = g_aet.aet01 
               CALL cl_create_qry() RETURNING g_aet.aet01 
               DISPLAY BY NAME g_aet.aet01
               NEXT FIELD aet01
            END CASE

      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about 
         CALL cl_about()    
 
      ON ACTION help    
         CALL cl_show_help()

      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
   END INPUT
END FUNCTION

FUNCTION t020_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_aet.* TO NULL      

   MESSAGE ""
   CALL cl_opmsg('q')
   CALL t020_cs()
   IF INT_FLAG THEN  
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN t020_b_cs    
   IF SQLCA.sqlcode THEN  
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_aet.* TO NULL
   ELSE
      CALL t020_fetch('F') 
      OPEN t020_count
      FETCH t020_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
   END IF
END FUNCTION

FUNCTION t020_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,
   l_abso          LIKE type_file.num10

   MESSAGE ""
   CASE p_flag
       WHEN 'N' FETCH NEXT     t020_b_cs INTO g_aet.aet01,g_aet.aet02,g_aet.aet03
       WHEN 'P' FETCH PREVIOUS t020_b_cs INTO g_aet.aet01,g_aet.aet02,g_aet.aet03
       WHEN 'F' FETCH FIRST    t020_b_cs INTO g_aet.aet01,g_aet.aet02,g_aet.aet03
       WHEN 'L' FETCH LAST     t020_b_cs INTO g_aet.aet01,g_aet.aet02,g_aet.aet03
       WHEN '/'
            IF (NOT mi_no_ask) THEN
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

            FETCH ABSOLUTE g_jump t020_b_cs INTO g_aet.aet01,g_aet.aet02,g_aet.aet03
            LET mi_no_ask = FALSE
   END CASE
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aet.aet01,SQLCA.sqlcode,0)   
      INITIALIZE g_aet.* TO NULL 
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

   CALL t020_show()
END FUNCTION

FUNCTION t020_show()
DEFINE l_axa02    LIKE axa_file.axa02
DEFINE l_axa03    LIKE axa_file.axa03
DEFINE g_aaw01    LIKE aaw_file.aaw01  #TQC-B70103
   SELECT axa02,axa03 INTO l_axa02,l_axa03 FROM axa_file WHERE axa01 = g_aet.aet01 AND axa04 = 'Y'
   #No.TQC-B70103 --Begin
   #DISPLAY l_axa02 TO FORMONLY.aet01_1
   #DISPLAY l_axa03 TO FORMONLY.aet01_2
   CALL s_aaz641_dbs(g_aet.aet01,l_axa02) RETURNING g_dbs_axz03
   CALL s_get_aaz641(g_dbs_axz03) RETURNING g_aaw01
   DISPLAY l_axa02 TO FORMONLY.aet01_2 
   DISPLAY g_aaw01 TO FORMONLY.aet01_1  
   #No.TQC-B70103 --Begin
   DISPLAY BY NAME g_aet.*              

   CALL t020_b_fill(g_wc)  
   CALL cl_show_fld_cont()  
END FUNCTION

FUNCTION t020_b()
DEFINE
   l_ac_t          LIKE type_file.num5,    
   l_n             LIKE type_file.num5,   
   l_n1            LIKE type_file.num5,
   l_n2            LIKE type_file.num5,
   l_lock_sw       LIKE type_file.chr1, 
   p_cmd           LIKE type_file.chr1,    
   l_aet_delyn     LIKE type_file.chr1,  
   l_chr           LIKE type_file.chr1,   
   l_allow_insert  LIKE type_file.num5,       
   l_allow_delete  LIKE type_file.num5   

   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF 
   IF cl_null(g_aet.aet01) OR cl_null(g_aet.aet02) OR cl_null(g_aet.aet03) THEN
       RETURN
   END IF

   CALL cl_opmsg('b') 

   LET g_forupd_sql = "SELECT aet04,aet05,'',aet06,aet07,aet08,aet09 FROM aet_file",
                      " WHERE aet01 = ? AND aet02 = ? AND aet03 = ? ",
                      "   AND aet04 = ? AND aet05 = ? AND aet06 = ? ",
                      "   AND aet08 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql) 
   DECLARE t020_bcl CURSOR FROM g_forupd_sql

   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   INPUT ARRAY g_aet_b WITHOUT DEFAULTS FROM s_aet1.*
      ATTRIBUTE (COUNT = g_rec_b,MAXCOUNT = g_max_rec,UNBUFFERED,
                 INSERT ROW = l_allow_insert,DELETE ROW = l_allow_delete,
                 APPEND ROW = l_allow_insert)
      BEFORE INPUT
         LET g_action_choice = ""
         IF g_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF

      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N' 
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET  g_before_input_done = FALSE
            CALL t020_set_entry(p_cmd)
            CALL t020_set_no_entry(p_cmd)
            LET  g_before_input_done = TRUE
            BEGIN WORK
            LET p_cmd='u'
            LET g_aet_b_t.* = g_aet_b[l_ac].*
            OPEN t020_bcl USING g_aet.aet01,g_aet.aet02,g_aet.aet03,
                                g_aet_b[l_ac].aet04,g_aet_b[l_ac].aet05,
                                g_aet_b[l_ac].aet06,g_aet_b[l_ac].aet08
            IF STATUS THEN
               CALL cl_err("OPEN t020_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH t020_bcl INTO g_aet_b[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_aet_b_t.aet04,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               SELECT nml02 INTO g_aet_b[l_ac].aet05_1 FROM nml_file 
                WHERE nml01 = g_aet_b[l_ac].aet05
            END IF
            CALL cl_show_fld_cont()
         END IF

      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_aet_b[l_ac].* TO NULL
         LET g_aet_b_t.* = g_aet_b[l_ac].* 
         LET  g_before_input_done = FALSE
         CALL t020_set_entry(p_cmd)
         LET  g_before_input_done = TRUE
         CALL cl_show_fld_cont() 
         NEXT FIELD aet04

      AFTER INSERT
         IF INT_FLAG THEN 
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
            CLOSE t020_bcl
         END IF
         INSERT INTO aet_file 
            VALUES(g_aet.aet01,g_aet.aet02,g_aet.aet03,g_aet_b[l_ac].aet04,
                   g_aet_b[l_ac].aet05,g_aet_b[l_ac].aet06,
                   g_aet_b[l_ac].aet07,g_aet_b[l_ac].aet08,g_aet_b[l_ac].aet09,g_legal)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","aet_file",g_aet_b[l_ac].aet04,"",SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b = g_rec_b + 1
         END IF

      AFTER FIELD aet04
         IF (cl_null(g_aet_b_t.aet04) OR g_aet_b[l_ac].aet04 != g_aet_b_t.aet04) 
                         AND NOT cl_null(g_aet_b[l_ac].aet04) THEN
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM axz_file WHERE axz01 = g_aet_b[l_ac].aet04
            IF l_n = 0 THEN
               CALL cl_err(g_aet_b[l_ac].aet04,100,0)
               NEXT FIELD aet04
            END IF
            LET l_n = 0
            CALL t020_check(l_ac) RETURNING l_n
            IF l_n <> 0 THEN
               LET g_aet_b[l_ac].aet04 = g_aet_b_t.aet04
               CALL cl_err('','-239',0)
               NEXT FIELD aet04
            END IF
         END IF          

      AFTER FIELD aet05
         IF NOT cl_null(g_aet_b[l_ac].aet05) THEN
            LET l_n = 0
            SELECT COUNT(nml01) INTO l_n FROM nml_file WHERE nml01 = g_aet_b[l_ac].aet05
            IF l_n < 1 THEN
              CALL cl_err(g_aet_b[l_ac].aet05,'',1)
              NEXT FIELD aet05
            ELSE 
               LET l_n = 0
               CALL t020_check(l_ac) RETURNING l_n
               IF l_n <> 0 THEN
                  LET g_aet_b[l_ac].aet05 = g_aet_b_t.aet05
                  CALL cl_err('','-239',0)
                  NEXT FIELD aet05
               END IF
               SELECT nml02 INTO g_aet_b[l_ac].aet05_1 FROM nml_file
                WHERE nml01 = g_aet_b[l_ac].aet05
            END IF 
         ELSE
            LET g_aet_b[l_ac].aet05_1 = NULL
         END IF
         DISPLAY g_aet_b[l_ac].aet05_1 TO aet05_1

      AFTER FIELD aet06
         IF NOT cl_null(g_aet_b[l_ac].aet06) THEN
            LET l_n = 0
            CALL t020_check(l_ac) RETURNING l_n
            IF l_n <> 0 THEN
               LET g_aet_b[l_ac].aet06 = g_aet_b_t.aet06
               CALL cl_err('','-239',0)
               NEXT FIELD aet06
            END IF
         END IF


      AFTER FIELD aet07
         IF NOT cl_null(g_aet_b[l_ac].aet07) THEN
            IF g_aet_b[l_ac].aet07 < 0 THEN
               CALL cl_err(g_aet_b[l_ac].aet07,'',1)
               NEXT FIELD aet07
            END IF
         END IF 

      AFTER FIELD aet08
         IF (cl_null(g_aet_b_t.aet08) OR g_aet_b[l_ac].aet08 != g_aet_b_t.aet08)
                         AND NOT cl_null(g_aet_b[l_ac].aet08) THEN
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM axz_file WHERE axz01 = g_aet_b[l_ac].aet08
            IF l_n = 0 THEN
               CALL cl_err(g_aet_b[l_ac].aet08,100,0)
               NEXT FIELD aet08
            END IF
            LET l_n = 0
            CALL t020_check(l_ac) RETURNING l_n
            IF l_n <> 0 THEN
               LET g_aet_b[l_ac].aet08 = g_aet_b_t.aet08
               CALL cl_err('','-239',0)
               NEXT FIELD aet08
            END IF
         END IF
         
      BEFORE DELETE
         IF NOT cl_null(g_aet_b_t.aet04) AND NOT cl_null(g_aet_b_t.aet05) 
            AND NOT cl_null(g_aet_b_t.aet06)AND NOT cl_null(g_aet_b_t.aet08) THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM aet_file
             WHERE aet01 = g_aet.aet01   
               AND aet02 = g_aet.aet02
               AND aet03 = g_aet.aet03
               AND aet04 = g_aet_b_t.aet04
               AND aet05 = g_aet_b_t.aet05
               AND aet06 = g_aet_b_t.aet06
               AND aet08 = g_aet_b_t.aet08

            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","aet_file",g_aet_b_t.aet04,"",SQLCA.sqlcode,"","",1)
               CANCEL DELETE
            END IF
            LET g_rec_b = g_rec_b - 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK

      ON ROW CHANGE
         IF NOT cl_null(g_aet_b_t.aet04) AND NOT cl_null(g_aet_b_t.aet05) 
            AND NOT cl_null(g_aet_b_t.aet06) AND NOT cl_null(g_aet_b_t.aet08) THEN 
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_aet_b[l_ac].aet04,-263,1)
               LET g_aet_b[l_ac].* = g_aet_b_t.*
            ELSE
               UPDATE aet_file SET aet07 = g_aet_b[l_ac].aet07,
                                   aet09 = g_aet_b[l_ac].aet09
                WHERE aet01 = g_aet.aet01 AND aet02 = g_aet.aet02
                  AND aet03 = g_aet.aet03 AND aet04 = g_aet_b_t.aet04
                  AND aet05 = g_aet_b_t.aet05 AND aet06 = g_aet_b_t.aet06
                  AND aet08 = g_aet_b_t.aet08
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","aet_file",g_aet.aet01,g_aet.aet02,SQLCA.sqlcode,"","",1)
                  LET g_aet_b[l_ac].* = g_aet_b_t.*
               ELSE
                  CALL cl_msg('UPDATE O.K')
               END IF
            END IF
         END IF

      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac    #FUN-D30032 mark
        #IF p_cmd = 'u' THEN  #FUN-D30032 mark
        #   CLOSE t020_bcl    #FUN-D30032 mark
        #END IF               #FUN-D30032 mark    
        #FUN-D30032--add--begin--
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_aet_b[l_ac].* = g_aet_b_t.* 
            ELSE
               CALL g_aet_b.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            END IF
            CLOSE t020_bcl 
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac  #FUN-D30032 add
         CLOSE t020_bcl
         COMMIT WORK
        #FUN-D30032--add--end----

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(aet04)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_axz"
              LET g_qryparam.default1 = g_aet_b[l_ac].aet04
              CALL cl_create_qry() RETURNING g_aet_b[l_ac].aet04
              NEXT FIELD aet04
            WHEN INFIELD(aet05)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_nml"
              LET g_qryparam.default1 = g_aet_b[l_ac].aet05
              CALL cl_create_qry() RETURNING g_aet_b[l_ac].aet05
              NEXT FIELD aet05
            WHEN INFIELD(aet08)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_axz"
              LET g_qryparam.default1 = g_aet_b[l_ac].aet08
              CALL cl_create_qry() RETURNING g_aet_b[l_ac].aet08
              NEXT FIELD aet08
            OTHERWISE
              EXIT CASE
         END CASE

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
          CALL cl_cmdask()

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about    
         CALL cl_about()  

      ON ACTION help       
         CALL cl_show_help()

      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
   END INPUT

   CLOSE t020_bcl
   COMMIT WORK
END FUNCTION

FUNCTION t020_b_fill(p_wc)  
DEFINE
   p_wc            STRING,        
   l_flag          LIKE type_file.chr1,   
   l_sql           STRING       

   LET l_sql = "SELECT aet04,aet05,'',aet06,aet07,aet08,aet09 FROM aet_file ",
               " WHERE aet01 = '",g_aet.aet01,"'",     
               "   AND aet02 = '",g_aet.aet02,"'",
               "   AND aet03 = '",g_aet.aet03,"'",
               "   AND ",p_wc CLIPPED, 
               " ORDER BY aet01,aet02,aet03 "

   PREPARE aet_pre FROM l_sql
   DECLARE aet_cs CURSOR FOR aet_pre

   CALL g_aet_b.clear()
   LET g_cnt = 1
   LET l_flag='N'
   LET g_rec_b=0
   FOREACH aet_cs INTO g_aet_b[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT nml02 INTO g_aet_b[g_cnt].aet05_1 FROM nml_file 
       WHERE nml01 = g_aet_b[g_cnt].aet05
      LET l_flag = 'Y'
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
       EXIT FOREACH
      END IF
   END FOREACH
   CALL g_aet_b.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   IF l_flag='N' THEN LET g_rec_b = 0 END IF
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION

FUNCTION t020_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1  

   IF p_cmd='a' AND (NOT g_before_input_done) THEN                                            
       CALL cl_set_comp_entry("aet04,aet05,aet06,aet08",TRUE)                               
   END IF
 
END FUNCTION
 
FUNCTION t020_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1 

   IF p_cmd='u' AND g_chkey='N' AND (NOT g_before_input_done) THEN                                            
       CALL cl_set_comp_entry("aet04,aet05,aet06,aet08",FALSE)             
   END IF 
 
END FUNCTION

FUNCTION t020_bp(p_ud)
DEFINE
    p_ud   LIKE type_file.chr1 

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_aet_b TO s_aet1.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
       BEFORE DISPLAY
          CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()     

      ON ACTION insert 
         LET g_action_choice="insert"
         EXIT DISPLAY

      ON ACTION delete 
         LET g_action_choice="delete"
         EXIT DISPLAY  

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION first
         CALL t020_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY      
 
      ON ACTION previous
         CALL t020_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)                         
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY 

      ON ACTION jump
         CALL t020_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)                         
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY            

      ON ACTION next
         CALL t020_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY            

      ON ACTION last
         CALL t020_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY           

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
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

      ON ACTION cancel
         LET INT_FLAG=FALSE 	
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION close
      LET g_action_choice="exit"
      EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION t020_r()

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_aet.aet01) AND cl_null(g_aet.aet02) AND cl_null(g_aet.aet03) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF
   BEGIN WORK

   IF cl_delh(0,0) THEN
      DELETE FROM aet_file WHERE aet01 = g_aet.aet01 AND aet02 = g_aet.aet02  
                             AND aet03 = g_aet.aet03                                  
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","aet_file",g_aet.aet01,'',SQLCA.sqlcode,"","",1)
      ELSE
         CLEAR FORM
         CALL g_aet_b.clear()
         OPEN t020_count
         FETCH t020_count INTO g_row_count
         LET g_row_count = g_row_count - 1 
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t020_b_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t020_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE 
            CALL t020_fetch('/')
         END IF
      END IF
   END IF
   COMMIT WORK
END FUNCTION

FUNCTION t020_check(l_ac)
DEFINE l_n,l_ac    LIKE type_file.num5

    SELECT COUNT(*) INTO l_n FROM aet_file
             WHERE aet01 = g_aet.aet01 AND aet02 = g_aet.aet02
               AND aet03 = g_aet.aet03 AND aet04 = g_aet_b[l_ac].aet04
               AND aet05 = g_aet_b[l_ac].aet05
               AND aet06 = g_aet_b[l_ac].aet06
               AND aet08 = g_aet_b[l_ac].aet08

   RETURN l_n
END FUNCTION
#NO.FUN-B40104
