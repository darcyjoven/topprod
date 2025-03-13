# Prog. Version..: '5.30.06-13.04.22(00005)'     #
#
# Pattern name...: arti140.4gl
# Descriptions...: 營運中心銷售目標設定作業
# Date & Author..: No.FUN-B40070 11/04/27 By baogc
# Modify.........: No:FUN-B50067 11/05/16 By baogc 修改BUG
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80085 11/08/09 By fanbj 用g_time替换l_time,rollback位置调整
# Modify.........: No.TQC-C20063 12/02/07 By baogc 單身重複性檢查
# Modify.........: No:FUN-D30033 13/04/18 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題


DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_rwt           RECORD LIKE rwt_file.*,
       g_rwt_t         RECORD LIKE rwt_file.*
DEFINE g_rwt_b         DYNAMIC ARRAY OF RECORD
           rwt01_b     LIKE rwt_file.rwt01,
           azw08_4     LIKE azw_file.azw08,
           rwt02_b     LIKE rwt_file.rwt01,
           rwt201_desc LIKE type_file.num5,
           rwt201_b    LIKE rwt_file.rwt201,
           rwt202_desc LIKE type_file.num5,
           rwt202_b    LIKE rwt_file.rwt202,
           rwt203_desc LIKE type_file.num5,
           rwt203_b    LIKE rwt_file.rwt203,
           rwt204_desc LIKE type_file.num5,
           rwt204_b    LIKE rwt_file.rwt204,
           rwt205_desc LIKE type_file.num5,
           rwt205_b    LIKE rwt_file.rwt205,
           rwt206_desc LIKE type_file.num5,
           rwt206_b    LIKE rwt_file.rwt206,
           rwt207_desc LIKE type_file.num5,
           rwt207_b    LIKE rwt_file.rwt207,
           rwt208_desc LIKE type_file.num5,
           rwt208_b    LIKE rwt_file.rwt208,
           rwt209_desc LIKE type_file.num5,
           rwt209_b    LIKE rwt_file.rwt209,
           rwt210_desc LIKE type_file.num5,
           rwt210_b    LIKE rwt_file.rwt210,
           rwt211_desc LIKE type_file.num5,
           rwt211_b    LIKE rwt_file.rwt211,
           rwt212_desc LIKE type_file.num5,
           rwt212_b    LIKE rwt_file.rwt212
                     END RECORD,
       g_rwt_b_t     RECORD
           rwt01_b     LIKE rwt_file.rwt01,
           azw08_4     LIKE azw_file.azw08,
           rwt02_b     LIKE rwt_file.rwt01,
           rwt201_desc LIKE type_file.num5,
           rwt201_b    LIKE rwt_file.rwt201,
           rwt202_desc LIKE type_file.num5,
           rwt202_b    LIKE rwt_file.rwt202,
           rwt203_desc LIKE type_file.num5,
           rwt203_b    LIKE rwt_file.rwt203,
           rwt204_desc LIKE type_file.num5,
           rwt204_b    LIKE rwt_file.rwt204,
           rwt205_desc LIKE type_file.num5,
           rwt205_b    LIKE rwt_file.rwt205,
           rwt206_desc LIKE type_file.num5,
           rwt206_b    LIKE rwt_file.rwt206,
           rwt207_desc LIKE type_file.num5,
           rwt207_b    LIKE rwt_file.rwt207,
           rwt208_desc LIKE type_file.num5,
           rwt208_b    LIKE rwt_file.rwt208,
           rwt209_desc LIKE type_file.num5,
           rwt209_b    LIKE rwt_file.rwt209,
           rwt210_desc LIKE type_file.num5,
           rwt210_b    LIKE rwt_file.rwt210,
           rwt211_desc LIKE type_file.num5,
           rwt211_b    LIKE rwt_file.rwt211,
           rwt212_desc LIKE type_file.num5,
           rwt212_b    LIKE rwt_file.rwt212
                     END RECORD,
       g_rwu         DYNAMIC ARRAY OF RECORD
           rwu03     LIKE rwu_file.rwu03,
           gen02     LIKE gen_file.gen02,
           rwu02     LIKE rwu_file.rwu02,
           rwu201_desc LIKE type_file.num5,
           rwu201      LIKE rwu_file.rwu201,
           rwu202_desc LIKE type_file.num5,
           rwu202      LIKE rwu_file.rwu202,
           rwu203_desc LIKE type_file.num5,
           rwu203      LIKE rwu_file.rwu203,
           rwu204_desc LIKE type_file.num5,
           rwu204      LIKE rwu_file.rwu204,
           rwu205_desc LIKE type_file.num5,
           rwu205      LIKE rwu_file.rwu205,
           rwu206_desc LIKE type_file.num5,
           rwu206      LIKE rwu_file.rwu206,
           rwu207_desc LIKE type_file.num5,
           rwu207      LIKE rwu_file.rwu207,
           rwu208_desc LIKE type_file.num5,
           rwu208      LIKE rwu_file.rwu208,
           rwu209_desc LIKE type_file.num5,
           rwu209      LIKE rwu_file.rwu209,
           rwu210_desc LIKE type_file.num5,
           rwu210      LIKE rwu_file.rwu210,
           rwu211_desc LIKE type_file.num5,
           rwu211      LIKE rwu_file.rwu211,
           rwu212_desc LIKE type_file.num5,
           rwu212      LIKE rwu_file.rwu212
                     END RECORD,
       g_rwu_t       RECORD                
           rwu03     LIKE rwu_file.rwu03,
           gen02     LIKE gen_file.gen02,
           rwu02     LIKE rwu_file.rwu02,
           rwu201_desc LIKE type_file.num5,
           rwu201      LIKE rwu_file.rwu201,
           rwu202_desc LIKE type_file.num5,
           rwu202      LIKE rwu_file.rwu202,
           rwu203_desc LIKE type_file.num5,
           rwu203      LIKE rwu_file.rwu203,
           rwu204_desc LIKE type_file.num5,
           rwu204      LIKE rwu_file.rwu204,
           rwu205_desc LIKE type_file.num5,
           rwu205      LIKE rwu_file.rwu205,
           rwu206_desc LIKE type_file.num5,
           rwu206      LIKE rwu_file.rwu206,
           rwu207_desc LIKE type_file.num5,
           rwu207      LIKE rwu_file.rwu207,
           rwu208_desc LIKE type_file.num5,
           rwu208      LIKE rwu_file.rwu208,
           rwu209_desc LIKE type_file.num5,
           rwu209      LIKE rwu_file.rwu209,
           rwu210_desc LIKE type_file.num5,
           rwu210      LIKE rwu_file.rwu210,
           rwu211_desc LIKE type_file.num5,
           rwu211      LIKE rwu_file.rwu211,
           rwu212_desc LIKE type_file.num5,
           rwu212      LIKE rwu_file.rwu212
                     END RECORD,
       g_sql         STRING,                      
       g_wc          STRING,
       g_rec_b1      LIKE type_file.num5,
       g_rec_b2      LIKE type_file.num5,
       l_ac1         LIKE type_file.num5,
       l_ac2         LIKE type_file.num5
DEFINE g_forupd_sql        STRING                
DEFINE g_before_input_done LIKE type_file.num5   
DEFINE g_chr               LIKE type_file.chr1    
DEFINE g_cnt1              LIKE type_file.num10    
DEFINE g_cnt2              LIKE type_file.num10    
DEFINE g_msg               LIKE ze_file.ze03     
DEFINE g_curs_index        LIKE type_file.num10  
DEFINE g_row_count         LIKE type_file.num10   
DEFINE g_jump              LIKE type_file.num10   
DEFINE mi_no_ask           LIKE type_file.num5
DEFINE l_azw08             LIKE azw_file.azw08
DEFINE l_azw08_2           LIKE azw_file.azw08
DEFINE l_azw08_3           LIKE azw_file.azw08
DEFINE g_rwt01_p           LIKE rwt_file.rwt01
DEFINE g_rwt02_p           LIKE rwt_file.rwt02
DEFINE g_azw07_n           LIKE type_file.num5
DEFINE g_chs               LIKE type_file.chr1
DEFINE g_replace           LIKE type_file.num20_6

MAIN
   DEFINE l_time   LIKE type_file.chr8


   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF


   #CALL cl_used(g_prog,l_time,1) RETURNING l_time    #FUN-B80085--mark--
   CALL cl_used(g_prog,g_time,1) RETURNING g_time     #FUN-B80085--add---

   INITIALIZE g_rwt01_p TO NULL
   LET g_rwt01_p = ARG_VAL(1)
   LET g_rwt02_p = ARG_VAL(2)
   INITIALIZE g_rwt.* TO NULL

   LET g_forupd_sql = "SELECT * FROM rwt_file 
                        WHERE rwt01 = ? AND rwt02 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i140_cl CURSOR FROM g_forupd_sql

   OPEN WINDOW i140_w WITH FORM "art/42f/arti140"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   LET g_azw07_n = 0
   SELECT COUNT(*) INTO g_azw07_n FROM azw_file WHERE azw07 = g_plant
   IF g_azw07_n > 0 THEN
      CALL cl_set_comp_visible("level",TRUE)
      CALL cl_set_comp_visible("staff",FALSE)
      CALL cl_set_act_visible("set_lower_level",TRUE)
      CALL cl_set_act_visible("qry_lower_level",TRUE)
      CALL cl_set_act_visible("set_staff_goal",FALSE)
   ELSE
      CALL cl_set_comp_visible("level",FALSE)
      CALL cl_set_comp_visible("staff",TRUE)
      CALL cl_set_act_visible("set_lower_level",FALSE)
      CALL cl_set_act_visible("qry_lower_level",FALSE)
      CALL cl_set_act_visible("set_staff_goal",TRUE)
   END IF

   LET g_action_choice = ""
   IF NOT cl_null(g_rwt01_p) AND NOT cl_null(g_rwt02_p)THEN
      LET g_azw07_n = 0       
      SELECT COUNT(*) INTO g_azw07_n FROM azw_file WHERE azw07 = g_rwt01_p
      IF g_azw07_n > 0 THEN   
        CALL cl_set_comp_visible("level",TRUE)
         CALL cl_set_comp_visible("staff",FALSE)
         CALL cl_set_act_visible("set_lower_level",TRUE)
         CALL cl_set_act_visible("qry_lower_level",TRUE)
         CALL cl_set_act_visible("set_staff_goal",FALSE)
      ELSE
         CALL cl_set_comp_visible("level",FALSE)
         CALL cl_set_comp_visible("staff",TRUE)
         CALL cl_set_act_visible("set_lower_level",FALSE)
         CALL cl_set_act_visible("qry_lower_level",FALSE)
         CALL cl_set_act_visible("set_staff_goal",TRUE)
      END IF
      SELECT * INTO g_rwt.* FROM rwt_file WHERE rwt01 = g_rwt01_p AND rwt02 = g_rwt02_p
      CALL i140_show()
   END IF

   CALL i140_menu()
   CLOSE WINDOW i140_w

   #CALL cl_used(g_prog,l_time,2) RETURNING l_time    #FUN-B80085--mark--
    CALL cl_used(g_prog,g_time,2) RETURNING g_time     #FUN-B80085--add---

END MAIN

FUNCTION i140_cs()

   CLEAR FORM 
   CALL g_rwu.clear()
  
   INITIALIZE g_rwt.* TO NULL   
   CONSTRUCT BY NAME g_wc ON rwt01,rwt02,rwt04,rwt03,rwt201,
                             rwt202,rwt203,rwt204,rwt205,rwt206,rwt207,
                             rwt208,rwt209,rwt210,rwt211,rwt212,rwtdate,
                             rwtgrup,rwtmodu,rwtorig,rwtoriu,rwtuser

      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION controlp
         CASE
            WHEN INFIELD(rwt01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_azw"
               LET g_qryparam.where = "azw01 IN",g_auth
               LET g_qryparam.default1 = g_rwt.rwt01
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rwt01
               NEXT FIELD rwt01
            WHEN INFIELD(rwt03)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_azw"
               LET g_qryparam.default1 = g_rwt.rwt03
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rwt03
               NEXT FIELD rwt03
            WHEN INFIELD(rwt04)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_azw"
               LET g_qryparam.where = "azw01 IN (SELECT DISTINCT azw07   ",
                                      "            FROM azw_file         ",
                                      "           WHERE azw07 IS NOT NULL"
               LET g_qryparam.default1 = g_rwt.rwt04
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rwt04
               NEXT FIELD rwt04
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
      
   END CONSTRUCT
      
   IF INT_FLAG THEN
      RETURN
   END IF

   LET g_sql = "SELECT rwt01,rwt02 FROM rwt_file",
               " WHERE ", g_wc CLIPPED,
               "   AND rwt01 IN ",g_auth,
               " ORDER BY rwt01"

   PREPARE i140_prepare FROM g_sql
   DECLARE i140_cs                    
      SCROLL CURSOR WITH HOLD FOR i140_prepare

   LET g_sql = "SELECT COUNT(*) FROM rwt_file",
               " WHERE ", g_wc CLIPPED,
               "   AND rwt01 IN ",g_auth,
               " ORDER BY rwt01"

   PREPARE i140_precount FROM g_sql
   DECLARE i140_count CURSOR FOR i140_precount

END FUNCTION

FUNCTION i140_menu()
DEFINE l_azw07  LIKE azw_file.azw07
DEFINE l_n      LIKE type_file.num5

   WHILE TRUE
      IF NOT cl_null(g_rwt.rwt01) THEN
         LET g_azw07_n = 0
         SELECT COUNT(*) INTO g_azw07_n FROM azw_file WHERE azw07 = g_rwt.rwt01
         IF g_azw07_n > 0 THEN
            CALL cl_set_comp_visible("level",TRUE)
            CALL cl_set_comp_visible("staff",FALSE)
            CALL cl_set_act_visible("set_lower_level",TRUE)
            CALL cl_set_act_visible("qry_lower_level",TRUE)
            CALL cl_set_act_visible("set_staff_goal",FALSE)
         ELSE
            CALL cl_set_comp_visible("level",FALSE)
            CALL cl_set_comp_visible("staff",TRUE)
            CALL cl_set_act_visible("set_lower_level",FALSE)
            CALL cl_set_act_visible("qry_lower_level",FALSE)
            CALL cl_set_act_visible("set_staff_goal",TRUE)
         END IF
      END IF
      CALL i140_fill_head()
      CALL i140_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               INITIALIZE l_azw07 TO NULL
               SELECT azw07 INTO l_azw07 FROM azw_file WHERE azw01 = g_plant AND azwacti = 'Y'
               IF NOT cl_null(l_azw07) THEN
                  CALL cl_err('','art-699',0)
               ELSE
                  CALL i140_a()
               END IF
            END IF

         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i140_q()
            END IF

         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i140_r()
            END IF

         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i140_u()
            END IF

         WHEN "set_lower_level"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_rwt.rwt01) THEN
                  CALL i140_b1()
               END IF
            ELSE
               LET g_action_choice = NULL
            END IF
             
         WHEN "qry_lower_level"
            IF cl_chk_act_auth() THEN
               IF l_ac1 = 0 THEN LET l_ac1 = 1 END IF
               IF NOT cl_null(g_rwt_b[l_ac1].rwt01_b) AND NOT cl_null(g_rwt_b[l_ac1].rwt02_b) THEN
                  LET g_msg = "arti140 ","'",g_rwt_b[l_ac1].rwt01_b,"' '",g_rwt_b[l_ac1].rwt02_b,"'"
                  CALL cl_cmdrun_wait(g_msg)
               END IF
            END IF

         WHEN "set_staff_goal"
            IF cl_chk_act_auth() THEN
                CALL i140_b2()
            ELSE
               LET g_action_choice = NULL
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

FUNCTION i140_a()

   MESSAGE ""
   CLEAR FORM
   CALL g_rwu.clear()
   LET g_wc  = NULL

   IF s_shut(0) THEN
      RETURN
   END IF

   INITIALIZE g_rwt.* TO NULL

   LET g_rwt_t.* = g_rwt.*
   CALL cl_opmsg('a')

   WHILE TRUE
      LET g_rwt.rwtuser = g_user
      LET g_rwt.rwtgrup = g_grup
      LET g_rwt.rwtdate = ''
      LET g_rwt.rwtoriu = g_user
      LET g_rwt.rwtorig = g_grup
      LET g_rwt.rwtmodu = ''
      LET g_rwt.rwt03   = g_plant
      SELECT azw08 INTO l_azw08_3 FROM azw_file WHERE azw01 = g_rwt.rwt03
      DISPLAY l_azw08_3 TO FORMONLY.azw08_3
      
      CALL i140_i("a")

      IF INT_FLAG THEN
         INITIALIZE g_rwt.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF

      IF cl_null(g_rwt.rwt01) OR cl_null(g_rwt.rwt02) THEN
         CONTINUE WHILE
      END IF
   
      BEGIN WORK
      DISPLAY BY NAME g_rwt.rwt01,g_rwt.rwt02

      INSERT INTO rwt_file VALUES (g_rwt.*)
      IF SQLCA.sqlcode THEN 
      #   ROLLBACK WORK              #FUN-B80085---回滾放在報錯後---
         CALL cl_err3("ins","rwt_file",g_rwt.rwt01,"",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK               #FUN-B80085--add--
         CONTINUE WHILE
      ELSE
         COMMIT WORK
      END IF

      LET g_rwt_t.* = g_rwt.*
      CALL g_rwu.clear()

      EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION i140_u()
DEFINE l_azw07  LIKE azw_file.azw07

   IF s_shut(0) THEN
      RETURN
   END IF

   IF g_rwt.rwt01 IS NULL OR g_rwt.rwt02 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   INITIALIZE l_azw07 TO NULL 
   SELECT azw07 INTO l_azw07 FROM azw_file WHERE azw01 = g_rwt.rwt01
   IF NOT cl_null(l_azw07) THEN
      CALL cl_err('','art-697',0)
      RETURN
   END IF

   SELECT * INTO g_rwt.* FROM rwt_file
    WHERE rwt01 = g_rwt.rwt01
      AND rwt02 = g_rwt.rwt02

   MESSAGE ""
   CALL cl_opmsg('u')
   BEGIN WORK

   OPEN i140_cl USING g_rwt.rwt01,g_rwt.rwt02
   IF STATUS THEN
      CALL cl_err("OPEN i140_cl:", STATUS, 1)
      CLOSE i140_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH i140_cl INTO g_rwt.*
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_rwt.rwt01,SQLCA.sqlcode,0)
       CLOSE i140_cl
       ROLLBACK WORK
       RETURN
   END IF

   CALL i140_show()

   WHILE TRUE
      LET g_rwt_t.* = g_rwt.*
      LET g_rwt.rwtmodu = g_user
      LET g_rwt.rwtdate = g_today

      CALL i140_i("u")

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_rwt.* = g_rwt_t.*
         CALL i140_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF

      UPDATE rwt_file SET rwt_file.* = g_rwt.*
       WHERE rwt01 = g_rwt.rwt01
         AND rwt02 = g_rwt.rwt02

      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","rwt_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE

   CLOSE i140_cl
   COMMIT WORK
END FUNCTION

FUNCTION i140_i(p_cmd)
   DEFINE
      l_n       LIKE type_file.num5,   
      p_cmd     LIKE type_file.chr1, 
      l_rwt02   STRING,
      l_sum     LIKE rwt_file.rwt201

   IF s_shut(0) THEN
      RETURN
   END IF

   DISPLAY BY NAME g_rwt.rwt01,g_rwt.rwt02,g_rwt.rwt04,g_rwt.rwt03,
                   g_rwt.rwt201,g_rwt.rwt202,g_rwt.rwt203,g_rwt.rwt204,
                   g_rwt.rwt205,g_rwt.rwt206,g_rwt.rwt207,g_rwt.rwt208,
                   g_rwt.rwt209,g_rwt.rwt210,g_rwt.rwt211,g_rwt.rwt212,
                   g_rwt.rwtdate,g_rwt.rwtgrup,g_rwt.rwtmodu,
                   g_rwt.rwtorig,g_rwt.rwtoriu,g_rwt.rwtuser

   CALL cl_set_head_visible("","YES")

   INPUT BY NAME g_rwt.rwt01,g_rwt.rwt02,g_rwt.rwt04,g_rwt.rwt03,
                 g_rwt.rwt201,g_rwt.rwt202,g_rwt.rwt203,g_rwt.rwt204,
                 g_rwt.rwt205,g_rwt.rwt206,g_rwt.rwt207,g_rwt.rwt208,
                 g_rwt.rwt209,g_rwt.rwt210,g_rwt.rwt211,g_rwt.rwt212,
                 g_rwt.rwtdate,g_rwt.rwtgrup,g_rwt.rwtmodu,
                 g_rwt.rwtorig,g_rwt.rwtoriu,g_rwt.rwtuser
                 WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i140_set_entry(p_cmd)
         CALL i140_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE

      AFTER FIELD rwt01
         DISPLAY "AFTER FIELD rwt01"
         IF NOT cl_null(g_rwt.rwt01) THEN
            IF p_cmd = "a" OR
               (p_cmd = "u" AND g_rwt.rwt01 <> g_rwt_t.rwt01) THEN
               LET l_n = 0
               SELECT count(*) INTO l_n 
                 FROM rwt_file 
                WHERE rwt01 = g_rwt.rwt01
                  AND rwt02 = g_rwt.rwt02
               IF l_n > 0 THEN
                  CALL cl_err(g_rwt.rwt01,-239,1)
                  LET g_rwt.rwt01 = g_rwt_t.rwt01
                  DISPLAY BY NAME g_rwt.rwt01
                  NEXT FIELD rwt01
               END IF
               CALL i140_rwt01('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('rwt01:',g_errno,1)
                  LET g_rwt.rwt01 = g_rwt_t.rwt01
                  DISPLAY BY NAME g_rwt.rwt01
                  NEXT FIELD rwt01
               END IF
               LET l_n = 0
               SELECT COUNT(*) INTO l_n FROM azw_file 
                WHERE azw01 IN (SELECT azw01 FROM azw_file 
                                 WHERE (azw07 = g_plant OR azw01 = g_plant)
                                   AND azwacti = 'Y')
                  AND azw01 = g_rwt.rwt01
               IF l_n = 0 THEN
                  CALL cl_err('','art-500',0)
                  NEXT FIELD rwt01
               END IF
            END IF
         END IF
	        
      AFTER FIELD rwt02
         DISPLAY "AFTER FIELD rwt02"
         IF NOT cl_null(g_rwt.rwt02) THEN
            IF p_cmd = "a" OR
               (p_cmd = "u" AND g_rwt.rwt02 <> g_rwt_t.rwt02) THEN
               LET l_n = 0
               SELECT count(*) INTO l_n 
                 FROM rwt_file 
                WHERE rwt01 = g_rwt.rwt01
                  AND rwt02 = g_rwt.rwt02
               IF l_n > 0 THEN
                  CALL cl_err(g_rwt.rwt01,-239,1)
                  LET g_rwt.rwt02 = g_rwt_t.rwt02
                  DISPLAY BY NAME g_rwt.rwt02
                  NEXT FIELD rwt02
               END IF
               LET l_rwt02 = g_rwt.rwt02
               IF l_rwt02.getLength() <> 4 THEN
                  CALL cl_err('','alm-672',0)
                  NEXT FIELD rwt02
               END IF
               IF g_rwt.rwt02 < 0 THEN
                  CALL cl_err('','alm-105',0)
                  NEXT FIELD rwt02
               END IF
            END IF
         END IF

      AFTER FIELD rwt201
         IF NOT cl_null(g_rwt.rwt201) THEN
            IF g_rwt.rwt201 < 0 THEN
               CALL cl_err('','alm-342',0)
               NEXT FIELD rwt201
            END IF
            LET l_sum = 0
            IF g_azw07_n > 0 THEN
               SELECT COALESCE(SUM(rwt201),0) INTO l_sum FROM rwt_file WHERE rwt02 = g_rwt.rwt02 AND rwt04 = g_rwt.rwt01
            ELSE
               SELECT COALESCE(SUM(rwu201),0) INTO l_sum FROM rwu_file WHERE rwu01 = g_rwt.rwt01 AND rwu02 = g_rwt.rwt02
            END IF
            IF g_rwt.rwt201 < l_sum THEN
               CALL cl_err('','art-709',0)
               NEXT FIELD rwt201
            END IF
            CALL i140_fill_head()
         END IF

      AFTER FIELD rwt202
         IF NOT cl_null(g_rwt.rwt202) THEN
            IF g_rwt.rwt202 < 0 THEN
               CALL cl_err('','alm-342',0)
               NEXT FIELD rwt202
            END IF
            LET l_sum = 0
            IF g_azw07_n > 0 THEN
               SELECT COALESCE(SUM(rwt202),0) INTO l_sum FROM rwt_file WHERE rwt02 = g_rwt.rwt02 AND rwt04 = g_rwt.rwt01
            ELSE
               SELECT COALESCE(SUM(rwu202),0) INTO l_sum FROM rwu_file WHERE rwu01 = g_rwt.rwt01 AND rwu02 = g_rwt.rwt02
            END IF
            IF g_rwt.rwt202 < l_sum THEN
               CALL cl_err('','art-709',0)
               NEXT FIELD rwt202
            END IF 
            CALL i140_fill_head()
         END IF

      AFTER FIELD rwt203
         IF NOT cl_null(g_rwt.rwt203) THEN
            IF g_rwt.rwt203 < 0 THEN
               CALL cl_err('','alm-342',0)
               NEXT FIELD rwt203
            END IF
            LET l_sum = 0
            IF g_azw07_n > 0 THEN
               SELECT COALESCE(SUM(rwt203),0) INTO l_sum FROM rwt_file WHERE rwt02 = g_rwt.rwt02 AND rwt04 = g_rwt.rwt01
            ELSE
               SELECT COALESCE(SUM(rwu203),0) INTO l_sum FROM rwu_file WHERE rwu01 = g_rwt.rwt01 AND rwu02 = g_rwt.rwt02
            END IF
            IF g_rwt.rwt203 < l_sum THEN
               CALL cl_err('','art-709',0)
               NEXT FIELD rwt203
            END IF 
            CALL i140_fill_head()
         END IF

      AFTER FIELD rwt204
         IF NOT cl_null(g_rwt.rwt204) THEN
            IF g_rwt.rwt204 < 0 THEN
               CALL cl_err('','alm-342',0)
               NEXT FIELD rwt204
            END IF
            LET l_sum = 0
            IF g_azw07_n > 0 THEN
               SELECT COALESCE(SUM(rwt204),0) INTO l_sum FROM rwt_file WHERE rwt02 = g_rwt.rwt02 AND rwt04 = g_rwt.rwt01
            ELSE
               SELECT COALESCE(SUM(rwu204),0) INTO l_sum FROM rwu_file WHERE rwu01 = g_rwt.rwt01 AND rwu02 = g_rwt.rwt02
            END IF
            IF g_rwt.rwt204 < l_sum THEN
               CALL cl_err('','art-709',0)
               NEXT FIELD rwt204
            END IF 
            CALL i140_fill_head()
         END IF

      AFTER FIELD rwt205
         IF NOT cl_null(g_rwt.rwt205) THEN
            IF g_rwt.rwt205 < 0 THEN
               CALL cl_err('','alm-342',0)
               NEXT FIELD rwt205
            END IF
            LET l_sum = 0
            IF g_azw07_n > 0 THEN
               SELECT COALESCE(SUM(rwt205),0) INTO l_sum FROM rwt_file WHERE rwt02 = g_rwt.rwt02 AND rwt04 = g_rwt.rwt01
            ELSE
               SELECT COALESCE(SUM(rwu205),0) INTO l_sum FROM rwu_file WHERE rwu01 = g_rwt.rwt01 AND rwu02 = g_rwt.rwt02
            END IF
            IF g_rwt.rwt205 < l_sum THEN
               CALL cl_err('','art-709',0)
               NEXT FIELD rwt205
            END IF 
            CALL i140_fill_head()
         END IF

      AFTER FIELD rwt206
         IF NOT cl_null(g_rwt.rwt206) THEN
            IF g_rwt.rwt206 < 0 THEN
               CALL cl_err('','alm-342',0)
               NEXT FIELD rwt206
            END IF
            LET l_sum = 0
            IF g_azw07_n > 0 THEN
               SELECT COALESCE(SUM(rwt206),0) INTO l_sum FROM rwt_file WHERE rwt02 = g_rwt.rwt02 AND rwt04 = g_rwt.rwt01
            ELSE
               SELECT COALESCE(SUM(rwu206),0) INTO l_sum FROM rwu_file WHERE rwu01 = g_rwt.rwt01 AND rwu02 = g_rwt.rwt02
            END IF
            IF g_rwt.rwt206 < l_sum THEN
               CALL cl_err('','art-709',0)
               NEXT FIELD rwt206
            END IF 
            CALL i140_fill_head()
         END IF

      AFTER FIELD rwt207
         IF NOT cl_null(g_rwt.rwt207) THEN
            IF g_rwt.rwt207 < 0 THEN
               CALL cl_err('','alm-342',0)
               NEXT FIELD rwt207
            END IF
            LET l_sum = 0
            IF g_azw07_n > 0 THEN
               SELECT COALESCE(SUM(rwt207),0) INTO l_sum FROM rwt_file WHERE rwt02 = g_rwt.rwt02 AND rwt04 = g_rwt.rwt01
            ELSE
               SELECT COALESCE(SUM(rwu207),0) INTO l_sum FROM rwu_file WHERE rwu01 = g_rwt.rwt01 AND rwu02 = g_rwt.rwt02
            END IF
            IF g_rwt.rwt207 < l_sum THEN
               CALL cl_err('','art-709',0)
               NEXT FIELD rwt207
            END IF 
            CALL i140_fill_head()
         END IF

      AFTER FIELD rwt208
         IF NOT cl_null(g_rwt.rwt208) THEN
            IF g_rwt.rwt208 < 0 THEN
               CALL cl_err('','alm-342',0)
               NEXT FIELD rwt208
            END IF
            LET l_sum = 0
            IF g_azw07_n > 0 THEN
               SELECT COALESCE(SUM(rwt208),0) INTO l_sum FROM rwt_file WHERE rwt02 = g_rwt.rwt02 AND rwt04 = g_rwt.rwt01
            ELSE
               SELECT COALESCE(SUM(rwu208),0) INTO l_sum FROM rwu_file WHERE rwu01 = g_rwt.rwt01 AND rwu02 = g_rwt.rwt02
            END IF
            IF g_rwt.rwt208 < l_sum THEN
               CALL cl_err('','art-709',0)
               NEXT FIELD rwt208
            END IF 
            CALL i140_fill_head()
         END IF

      AFTER FIELD rwt209
         IF NOT cl_null(g_rwt.rwt209) THEN
            IF g_rwt.rwt209 < 0 THEN
               CALL cl_err('','alm-342',0)
               NEXT FIELD rwt209
            END IF
            LET l_sum = 0
            IF g_azw07_n > 0 THEN
               SELECT COALESCE(SUM(rwt209),0) INTO l_sum FROM rwt_file WHERE rwt02 = g_rwt.rwt02 AND rwt04 = g_rwt.rwt01
            ELSE
               SELECT COALESCE(SUM(rwu209),0) INTO l_sum FROM rwu_file WHERE rwu01 = g_rwt.rwt01 AND rwu02 = g_rwt.rwt02
            END IF
            IF g_rwt.rwt209 < l_sum THEN
               CALL cl_err('','art-709',0)
               NEXT FIELD rwt209
            END IF 
            CALL i140_fill_head()
         END IF

      AFTER FIELD rwt210
         IF NOT cl_null(g_rwt.rwt210) THEN
            IF g_rwt.rwt210 < 0 THEN
               CALL cl_err('','alm-342',0)
               NEXT FIELD rwt210
            END IF
            LET l_sum = 0
            IF g_azw07_n > 0 THEN
               SELECT COALESCE(SUM(rwt210),0) INTO l_sum FROM rwt_file WHERE rwt02 = g_rwt.rwt02 AND rwt04 = g_rwt.rwt01
            ELSE
               SELECT COALESCE(SUM(rwu210),0) INTO l_sum FROM rwu_file WHERE rwu01 = g_rwt.rwt01 AND rwu02 = g_rwt.rwt02
            END IF
            IF g_rwt.rwt210 < l_sum THEN
               CALL cl_err('','art-709',0)
               NEXT FIELD rwt210
            END IF 
            CALL i140_fill_head()
         END IF

      AFTER FIELD rwt211
         IF NOT cl_null(g_rwt.rwt211) THEN
            IF g_rwt.rwt211 < 0 THEN
               CALL cl_err('','alm-342',0)
               NEXT FIELD rwt211
            END IF
            LET l_sum = 0
            IF g_azw07_n > 0 THEN
               SELECT COALESCE(SUM(rwt211),0) INTO l_sum FROM rwt_file WHERE rwt02 = g_rwt.rwt02 AND rwt04 = g_rwt.rwt01
            ELSE
               SELECT COALESCE(SUM(rwu211),0) INTO l_sum FROM rwu_file WHERE rwu01 = g_rwt.rwt01 AND rwu02 = g_rwt.rwt02
            END IF
            IF g_rwt.rwt211 < l_sum THEN
               CALL cl_err('','art-709',0)
               NEXT FIELD rwt211
            END IF 
            CALL i140_fill_head()
         END IF

      AFTER FIELD rwt212
         IF NOT cl_null(g_rwt.rwt212) THEN
            IF g_rwt.rwt212 < 0 THEN
               CALL cl_err('','alm-342',0)
               NEXT FIELD rwt212
            END IF
            LET l_sum = 0
            IF g_azw07_n > 0 THEN
               SELECT COALESCE(SUM(rwt212),0) INTO l_sum FROM rwt_file WHERE rwt02 = g_rwt.rwt02 AND rwt04 = g_rwt.rwt01
            ELSE
               SELECT COALESCE(SUM(rwu212),0) INTO l_sum FROM rwu_file WHERE rwu01 = g_rwt.rwt01 AND rwu02 = g_rwt.rwt02
            END IF
            IF g_rwt.rwt212 < l_sum THEN
               CALL cl_err('','art-709',0)
               NEXT FIELD rwt212
            END IF 
            CALL i140_fill_head()
         END IF

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION controlp
         CASE
            WHEN INFIELD(rwt01)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_azw"
               LET g_qryparam.where = " azw07 IS NULL AND  azw01 IN ",g_auth
               LET g_qryparam.default1 = g_rwt.rwt01
               CALL cl_create_qry() RETURNING g_rwt.rwt01
               DISPLAY g_rwt.rwt01 TO rwt01
               NEXT FIELD rwt01
         END CASE

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about       
         CALL cl_about()    
 
      ON ACTION help       
         CALL cl_show_help()  
 
   END INPUT

END FUNCTION

FUNCTION i140_rwt01(p_cmd)
DEFINE p_cmd     LIKE type_file.chr1
DEFINE l_azw07   LIKE azw_file.azw07
DEFINE l_azw08   LIKE azw_file.azw08
DEFINE l_azwacti LIKE azw_file.azwacti

   INITIALIZE l_azw07 TO NULL
   SELECT azw07,azw08,azwacti INTO l_azw07,l_azw08,l_azwacti FROM azw_file 
    WHERE azw01 = g_rwt.rwt01
   
   CASE
      WHEN SQLCA.sqlcode = 100 
         LET g_errno = 'aap-025'
         LET l_azw08 = NULL
      WHEN l_azwacti = 'N' LET g_errno = '9028'
      #---應由上層營運中心制定目標---#
      WHEN NOT cl_null(l_azw07) LET g_errno = 'art-697'
      OTHERWISE
         LET g_errno = SQLCA.sqlcode USING '------'
   END CASE

   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      DISPLAY l_azw08 TO FORMONLY.azw08
   END IF
END FUNCTION

FUNCTION i140_q()

   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_rwt_b.clear()
   CALL g_rwu.clear()
   DISPLAY ' ' TO FORMONLY.cnt

   CALL i140_cs()

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_rwt.* TO NULL
      RETURN
   END IF

   OPEN i140_cs 
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_rwt.* TO NULL
   ELSE
      OPEN i140_count
      FETCH i140_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i140_fetch('F')
   END IF

END FUNCTION

FUNCTION i140_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1

   CASE p_flag
      WHEN 'N' FETCH NEXT     i140_cs INTO g_rwt.rwt01,g_rwt.rwt02
      WHEN 'P' FETCH PREVIOUS i140_cs INTO g_rwt.rwt01,g_rwt.rwt02
      WHEN 'F' FETCH FIRST    i140_cs INTO g_rwt.rwt01,g_rwt.rwt02
      WHEN 'L' FETCH LAST     i140_cs INTO g_rwt.rwt01,g_rwt.rwt02
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
            FETCH ABSOLUTE g_jump i140_cs INTO g_rwt.rwt01,g_rwt.rwt02
            LET mi_no_ask = FALSE
   END CASE

   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rwt.rwt01,SQLCA.sqlcode,0)
      INITIALIZE g_rwt.* TO NULL      
      RETURN
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/'
	    IF NOT cl_null(g_jump) THEN
	       LET g_curs_index = g_jump
	    END IF
      END CASE
      CALL cl_navigator_setting( g_curs_index, g_row_count )
      DISPLAY g_curs_index TO FORMONLY.idx 
   END IF

   SELECT * INTO g_rwt.* FROM rwt_file WHERE rwt01 = g_rwt.rwt01 AND rwt02 = g_rwt.rwt02
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","rwt_file","","",SQLCA.sqlcode,"","",1)
      INITIALIZE g_rwt.* TO NULL
      RETURN
   END IF
   LET g_data_owner = g_rwt.rwtuser    
   LET g_data_group = g_rwt.rwtgrup  

   CALL i140_show()

END FUNCTION

FUNCTION i140_show()
DEFINE l_azw08    LIKE azw_file.azw08
DEFINE l_azw08_2  LIKE azw_file.azw08
DEFINE l_azw08_3  LIKE azw_file.azw08

   LET g_rwt_t.* = g_rwt.*

   DISPLAY BY NAME g_rwt.rwt01,g_rwt.rwt02,g_rwt.rwt04,g_rwt.rwt03,
                   g_rwt.rwt201,g_rwt.rwt202,g_rwt.rwt203,g_rwt.rwt204,
                   g_rwt.rwt205,g_rwt.rwt206,g_rwt.rwt207,g_rwt.rwt208,
                   g_rwt.rwt209,g_rwt.rwt210,g_rwt.rwt211,g_rwt.rwt212,
                   g_rwt.rwtdate,g_rwt.rwtgrup,g_rwt.rwtmodu,
                   g_rwt.rwtorig,g_rwt.rwtoriu,g_rwt.rwtuser
   SELECT azw08 INTO l_azw08 FROM azw_file 
    WHERE azw01 = g_rwt.rwt01 AND azwacti = 'Y'
   DISPLAY l_azw08 TO FORMONLY.azw08
   SELECT azw08 INTO l_azw08_2 FROM azw_file 
    WHERE azw01 = g_rwt.rwt04 AND azwacti = 'Y'
   DISPLAY l_azw08_2 TO FORMONLY.azw08_2
   SELECT azw08 INTO l_azw08_3 FROM azw_file 
    WHERE azw01 = g_rwt.rwt03 AND azwacti = 'Y'
   DISPLAY l_azw08_3 TO FORMONLY.azw08_3
   CALL i140_fill_head()

   CALL i140_b1_fill()
   CALL i140_b2_fill()
   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION i140_r()
DEFINE l_azw07  LIKE azw_file.azw07
DEFINE l_n      LIKE type_file.num5

   IF s_shut(0) THEN
      RETURN
   END IF

   IF g_rwt.rwt01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF

   SELECT * INTO g_rwt.* FROM rwt_file
    WHERE rwt01 = g_rwt.rwt01
      AND rwt02 = g_rwt.rwt02

   SELECT azw07 INTO l_azw07 FROM azw_file WHERE azw01 = g_rwt.rwt01
   IF NOT cl_null(l_azw07) THEN
      #---應由上級營運中心刪除資料---#
      CALL cl_err('','art-697',0)
      RETURN
   END IF
   SELECT COUNT(*) INTO l_n FROM rwt_file 
    WHERE rwt04 = g_rwt.rwt01 AND rwt02 = g_rwt.rwt02
   IF l_n > 0 THEN
      #---已設定下級營運中心的銷售目標，不允許刪除---#
      CALL cl_err('','art-695',0)
      RETURN
   END IF

   BEGIN WORK

   OPEN i140_cl USING g_rwt.rwt01,g_rwt.rwt02
   IF STATUS THEN
      CALL cl_err("OPEN i140_cl:", STATUS, 1)
      CLOSE i140_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH i140_cl INTO g_rwt.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rwt.rwt01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF

   CALL i140_show()

   IF cl_delh(0,0) THEN 
      DELETE FROM rwt_file WHERE rwt01 = g_rwt.rwt01 AND rwt02 = g_rwt.rwt02
      CLEAR FORM 
      CALL g_rwt_b.clear()
      CALL g_rwu.clear()
      OPEN i140_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE i140_cs
         CLOSE i140_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      FETCH i140_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i140_cs
         CLOSE i140_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i140_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i140_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL i140_fetch('/')
      END IF
   END IF

   CLOSE i140_cl
   COMMIT WORK

END FUNCTION

FUNCTION i140_b1()
   DEFINE
      l_ac_t1         LIKE type_file.num5, 
      l_n             LIKE type_file.num5,       
      l_lock_sw       LIKE type_file.chr1,   
      p_cmd           LIKE type_file.chr1,  
      l_allow_insert  LIKE type_file.num5,   
      l_allow_delete  LIKE type_file.num5,
      l_sum_rwt       LIKE rwt_file.rwt201
   DEFINE l_azw07_n   LIKE type_file.num5

    LET g_action_choice = ""

    IF s_shut(0) THEN
       RETURN
    END IF

    IF g_rwt.rwt01 IS NULL THEN
       RETURN
    END IF
    
    IF g_rwt.rwt01 <> g_plant THEN
       CALL cl_err('','art-708',0)
       RETURN
    END IF

    LET l_n = 0
    SELECT COUNT(*) INTO l_n FROM rwt_file WHERE rwt04 = g_rwt.rwt01 AND rwt02 = g_rwt.rwt02
    IF l_n = 0 THEN
       CALL cl_getmsg('art-706',g_lang) RETURNING g_msg
       LET INT_FLAG = 0
       LET g_chs = NULL
       PROMPT g_msg CLIPPED,': ' FOR g_chs
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
 
          ON ACTION about
             CALL cl_about()

          ON ACTION help
             CALL cl_show_help()

          ON ACTION controlg
             CALL cl_cmdask()
       END PROMPT
       IF INT_FLAG OR g_chs = '1' THEN
          LET INT_FLAG = 0
       END IF
       IF g_chs = '2' THEN
          CALL i140_rwt_p1()
       END IF
       IF g_chs = '3' THEN
          CALL i140_rwt_p2()
       END IF
    END IF

    SELECT * INTO g_rwt.* FROM rwt_file
     WHERE rwt01 = g_rwt.rwt01
       AND rwt02 = g_rwt.rwt02

    CALL cl_opmsg('b')

    LET g_forupd_sql = "SELECT rwt01,'',rwt02,'',rwt201,'',rwt202,'',  ",
                       "       rwt203,'',rwt204,'',rwt205,'',rwt206,'',",
                       "       rwt207,'',rwt208,'',rwt209,'',rwt210,'',",
                       "       rwt211,'',rwt212",                       
                       "  FROM rwt_file",
                       " WHERE rwt01=? AND rwt02=? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i140_bcl1 CURSOR FROM g_forupd_sql 

    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

    INPUT ARRAY g_rwt_b WITHOUT DEFAULTS FROM s_rwt.*
          ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)

        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           IF g_rec_b1 != 0 THEN
              CALL fgl_set_arr_curr(l_ac1)
           END IF

        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac1 = ARR_CURR()
           LET l_lock_sw = 'N' 
           LET l_n  = ARR_COUNT()

        BEGIN WORK

           OPEN i140_cl USING g_rwt.rwt01,g_rwt.rwt02
           IF STATUS THEN
              CALL cl_err("OPEN i140_cl:", STATUS, 1)
              CLOSE i140_cl
              ROLLBACK WORK
              RETURN
           END IF

           FETCH i140_cl INTO g_rwt.* 
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_rwt.rwt01,SQLCA.sqlcode,0)
              CLOSE i140_cl
              ROLLBACK WORK
              RETURN
           END IF

           IF g_rec_b1 >= l_ac1 THEN
              LET p_cmd='u'
              LET g_rwt_b_t.* = g_rwt_b[l_ac1].*
              OPEN i140_bcl1 USING g_rwt_b_t.rwt01_b,g_rwt_b_t.rwt02_b
              IF STATUS THEN
                 CALL cl_err("OPEN i140_bcl2:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i140_bcl1 INTO g_rwt_b[l_ac1].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_rwt_b_t.rwt01_b,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 SELECT azw08 INTO g_rwt_b[l_ac1].azw08_4 FROM azw_file
                  WHERE azw01 = g_rwt_b[l_ac1].rwt01_b
                    AND azwacti = 'Y'
                 CALL i140_fill_b1(l_ac1)
              END IF
              CALL cl_show_fld_cont()     
           END IF

        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_rwt_b[l_ac1].* TO NULL 
           LET g_rwt_b[l_ac1].rwt02_b = g_rwt.rwt02
           LET g_rwt_b_t.* = g_rwt_b[l_ac1].* 
           CALL cl_show_fld_cont()   
           NEXT FIELD rwt01_b

        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO rwt_file(rwt01,rwt02,rwt03,rwt04,rwt201,rwt202,rwt203,
                                rwt204,rwt205,rwt206,rwt207,rwt208,rwt209,
                                rwt210,rwt211,rwt212,rwtdate,rwtgrup,rwtmodu,
                                rwtorig,rwtoriu,rwtuser)
           VALUES(g_rwt_b[l_ac1].rwt01_b,g_rwt_b[l_ac1].rwt02_b,g_plant,g_rwt.rwt01,
                  g_rwt_b[l_ac1].rwt201_b,g_rwt_b[l_ac1].rwt202_b,
                  g_rwt_b[l_ac1].rwt203_b,g_rwt_b[l_ac1].rwt204_b,
                  g_rwt_b[l_ac1].rwt205_b,g_rwt_b[l_ac1].rwt206_b,
                  g_rwt_b[l_ac1].rwt207_b,g_rwt_b[l_ac1].rwt208_b,
                  g_rwt_b[l_ac1].rwt209_b,g_rwt_b[l_ac1].rwt210_b,
                  g_rwt_b[l_ac1].rwt211_b,g_rwt_b[l_ac1].rwt212_b,
                  '',g_grup,'',g_grup,g_user,g_user)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","rwt_file",g_rwt_b[l_ac1].rwt01_b,
                           g_rwt_b[l_ac1].rwt02_b,SQLCA.sqlcode,"","",1)
              CANCEL INSERT
           ELSE
              COMMIT WORK
              LET g_rec_b1=g_rec_b1+1
              DISPLAY g_rec_b1 TO FORMONLY.cn2
           END IF

        BEFORE FIELD rwt01_b
           IF p_cmd = 'u' THEN
              CALL cl_set_comp_entry("rwt01_b",FALSE)
           END IF
           IF p_cmd = 'a' THEN
              CALL cl_set_comp_entry("rwt01_b",TRUE)
           END IF

        AFTER FIELD rwt01_b  
           IF NOT cl_null(g_rwt_b[l_ac1].rwt01_b) THEN
              IF p_cmd = "a" OR
                 (p_cmd = "u" AND g_rwt_b[l_ac1].rwt01_b <> g_rwt_b_t.rwt01_b) THEN
                #TQC-C20063 Add Begin ---
                 LET l_n = 0
                 SELECT COUNT(*) INTO l_n FROM rwt_file
                  WHERE rwt01 = g_rwt_b[l_ac1].rwt01_b
                    AND rwt02 = g_rwt_b[l_ac1].rwt02_b
                 IF l_n > 0 THEN
                    CALL cl_err('','-239',0)
                    NEXT FIELD rwt01_b
                 END IF
                #TQC-C20063 Add End -----
                 LET l_n = 0
                 SELECT COUNT(*) INTO l_n FROM azw_file 
                  WHERE azw01 = g_rwt_b[l_ac1].rwt01_b
                    AND azwacti = 'Y'
                 IF l_n = 0 THEN
                    CALL cl_err('','aap-025',0)
                    NEXT FIELD rwt01_b
                 END IF
                 LET l_n = 0 
                 SELECT COUNT(*) INTO l_n FROM azw_file 
                  WHERE azw01 IN (SELECT azw01 FROM azw_file
                                   WHERE azw07 = g_rwt.rwt01
                                     AND azwacti = 'Y')
                    AND azw01 = g_rwt_b[l_ac1].rwt01_b
                 IF l_n = 0 THEN
                    #---只能設定當前營運中心下級的銷售目標---#
                    CALL cl_err('','art-621',0)
                    NEXT FIELD rwt01_b
                 END IF
                 SELECT azw08 INTO g_rwt_b[l_ac1].azw08_4 FROM azw_file
                  WHERE azw01 = g_rwt_b[l_ac1].rwt01_b
                 DISPLAY BY NAME g_rwt_b[l_ac1].azw08_4
              END IF
           END IF

        AFTER FIELD rwt201_desc
           IF NOT cl_null(g_rwt_b[l_ac1].rwt201_desc) THEN
              IF p_cmd = "a" OR
               (p_cmd = "u" AND g_rwt_b[l_ac1].rwt201_desc <> g_rwt_b_t.rwt201_desc) THEN
                 IF g_rwt_b[l_ac1].rwt201_desc < 0 OR g_rwt_b[l_ac1].rwt201_desc > 100 THEN
                    CALL cl_err('','apc-133',0)
                    NEXT FIELD rwt201_desc
                 END IF
                 LET g_rwt_b[l_ac1].rwt201_b = cl_digcut(g_rwt_b[l_ac1].rwt201_desc*g_rwt.rwt201/100,g_azi04)
                 DISPLAY BY NAME g_rwt_b[l_ac1].rwt201_desc
                 LET l_sum_rwt = 0
                 SELECT COALESCE(SUM(rwt201),0) INTO l_sum_rwt FROM rwt_file WHERE rwt04 = g_rwt.rwt01
                    AND rwt02 = g_rwt.rwt02
                    AND rwt01 <> g_rwt_b[l_ac1].rwt01_b
                 LET l_sum_rwt = l_sum_rwt + g_rwt_b[l_ac1].rwt201_b
                 IF l_sum_rwt > g_rwt.rwt201 THEN
                    IF i140_sure(0,0) THEN
                       LET l_sum_rwt = 0
                       SELECT COALESCE(SUM(rwt201),0) INTO l_sum_rwt FROM rwt_file
                        WHERE rwt04 = g_rwt.rwt01 AND rwt01 <> g_rwt_b[l_ac1].rwt01_b
                          AND rwt02 = g_rwt.rwt02
                       LET g_rwt_b[l_ac1].rwt201_b = g_rwt.rwt201 - l_sum_rwt
                       LET g_replace = g_rwt_b[l_ac1].rwt201_b/g_rwt.rwt201*100
                       LET g_rwt_b[l_ac1].rwt201_desc = cl_digcut(g_replace,0)
                       DISPLAY BY NAME g_rwt_b[l_ac1].rwt201_b,g_rwt_b[l_ac1].rwt201_desc
                       NEXT FIELD rwt201_b
                    ELSE
                       NEXT FIELD rwt201_desc
                    END IF
                 END IF
              END IF
           END IF

        AFTER FIELD rwt201_b
           IF NOT cl_null(g_rwt_b[l_ac1].rwt201_b) THEN
              IF g_rwt_b[l_ac1].rwt201_b < 0 THEN
                 CALL cl_err('','alm-342',0)
                 NEXT FIELD rwt201_b
              END IF
              LET l_sum_rwt = 0
              SELECT COALESCE(SUM(rwt201),0) INTO l_sum_rwt FROM rwt_file WHERE rwt04 = g_rwt.rwt01
                 AND rwt02 = g_rwt.rwt02
                 AND rwt01 <> g_rwt_b[l_ac1].rwt01_b 
              LET l_sum_rwt = l_sum_rwt + g_rwt_b[l_ac1].rwt201_b
              IF l_sum_rwt > g_rwt.rwt201 THEN
                 IF i140_sure(0,0) THEN
                    LET l_sum_rwt = 0
                    SELECT COALESCE(SUM(rwt201),0) INTO l_sum_rwt FROM rwt_file 
                     WHERE rwt04 = g_rwt.rwt01 AND rwt01 <> g_rwt_b[l_ac1].rwt01_b
                       AND rwt02 = g_rwt.rwt02
                    LET g_rwt_b[l_ac1].rwt201_b = g_rwt.rwt201 - l_sum_rwt
                    LET g_replace = g_rwt_b[l_ac1].rwt201_b/g_rwt.rwt201*100
                    LET g_rwt_b[l_ac1].rwt201_desc = cl_digcut(g_replace,0)
                    DISPLAY BY NAME g_rwt_b[l_ac1].rwt201_b,g_rwt_b[l_ac1].rwt201_desc
                    NEXT FIELD rwt201_b
                 ELSE
                    NEXT FIELD rwt201_b
                 END IF
              END IF
              LET g_replace = g_rwt_b[l_ac1].rwt201_b/g_rwt.rwt201*100
              LET g_rwt_b[l_ac1].rwt201_desc = cl_digcut(g_replace,0)
              DISPLAY BY NAME g_rwt_b[l_ac1].rwt201_desc
           END IF 

        AFTER FIELD rwt202_desc
           IF NOT cl_null(g_rwt_b[l_ac1].rwt202_desc) THEN
              IF p_cmd = "a" OR
               (p_cmd = "u" AND g_rwt_b[l_ac1].rwt202_desc <> g_rwt_b_t.rwt202_desc) THEN
                 IF g_rwt_b[l_ac1].rwt202_desc < 0 OR g_rwt_b[l_ac1].rwt202_desc > 100 THEN
                    CALL cl_err('','apc-133',0)
                    NEXT FIELD rwt202_desc
                 END IF
                 LET g_rwt_b[l_ac1].rwt202_b = cl_digcut(g_rwt_b[l_ac1].rwt202_desc*g_rwt.rwt202/100,g_azi04)
                 DISPLAY BY NAME g_rwt_b[l_ac1].rwt202_desc
                 LET l_sum_rwt = 0
                 SELECT COALESCE(SUM(rwt202),0) INTO l_sum_rwt FROM rwt_file WHERE rwt04 = g_rwt.rwt01
                    AND rwt02 = g_rwt.rwt02
                    AND rwt01 <> g_rwt_b[l_ac1].rwt01_b
                 LET l_sum_rwt = l_sum_rwt + g_rwt_b[l_ac1].rwt202_b
                 IF l_sum_rwt > g_rwt.rwt202 THEN
                    IF i140_sure(0,0) THEN
                       LET l_sum_rwt = 0
                       SELECT COALESCE(SUM(rwt202),0) INTO l_sum_rwt FROM rwt_file
                        WHERE rwt04 = g_rwt.rwt01 AND rwt01 <> g_rwt_b[l_ac1].rwt01_b
                          AND rwt02 = g_rwt.rwt02
                       LET g_rwt_b[l_ac1].rwt202_b = g_rwt.rwt202 - l_sum_rwt
                       LET g_replace = g_rwt_b[l_ac1].rwt202_b/g_rwt.rwt202*100
                       LET g_rwt_b[l_ac1].rwt202_desc = cl_digcut(g_replace,0)
                       DISPLAY BY NAME g_rwt_b[l_ac1].rwt202_b,g_rwt_b[l_ac1].rwt202_desc
                       NEXT FIELD rwt202_b
                    ELSE
                       NEXT FIELD rwt202_desc
                    END IF
                 END IF
              END IF
           END IF
          
        AFTER FIELD rwt202_b
           IF NOT cl_null(g_rwt_b[l_ac1].rwt202_b) THEN
              IF g_rwt_b[l_ac1].rwt202_b < 0 THEN
                 CALL cl_err('','alm-342',0)
                 NEXT FIELD rwt202_b
              END IF 
              LET l_sum_rwt = 0
              SELECT COALESCE(SUM(rwt202),0) INTO l_sum_rwt FROM rwt_file WHERE rwt04 = g_rwt.rwt01
                 AND rwt02 = g_rwt.rwt02
                 AND rwt01 <> g_rwt_b[l_ac1].rwt01_b 
              LET l_sum_rwt = l_sum_rwt + g_rwt_b[l_ac1].rwt202_b
              IF l_sum_rwt > g_rwt.rwt202 THEN
                 IF i140_sure(0,0) THEN
                    LET l_sum_rwt = 0
                    SELECT COALESCE(SUM(rwt202),0) INTO l_sum_rwt FROM rwt_file
                     WHERE rwt04 = g_rwt.rwt01 AND rwt01 <> g_rwt_b[l_ac1].rwt01_b
                       AND rwt02 = g_rwt.rwt02
                    LET g_rwt_b[l_ac1].rwt202_b = g_rwt.rwt202 - l_sum_rwt
                    LET g_replace = g_rwt_b[l_ac1].rwt202_b/g_rwt.rwt202*100
                    LET g_rwt_b[l_ac1].rwt202_desc = cl_digcut(g_replace,0)
                    DISPLAY BY NAME g_rwt_b[l_ac1].rwt202_b,g_rwt_b[l_ac1].rwt202_desc
                    NEXT FIELD rwt202_b
                 ELSE
                    NEXT FIELD rwt202_b
                 END IF
              END IF
              LET g_replace = g_rwt_b[l_ac1].rwt202_b/g_rwt.rwt202*100
              LET g_rwt_b[l_ac1].rwt202_desc = cl_digcut(g_replace,0)
              DISPLAY BY NAME g_rwt_b[l_ac1].rwt202_desc
           END IF 
         
        AFTER FIELD rwt203_desc
           IF NOT cl_null(g_rwt_b[l_ac1].rwt203_desc) THEN
              IF p_cmd = "a" OR
               (p_cmd = "u" AND g_rwt_b[l_ac1].rwt203_desc <> g_rwt_b_t.rwt203_desc) THEN
                 IF g_rwt_b[l_ac1].rwt203_desc < 0 OR g_rwt_b[l_ac1].rwt203_desc > 100 THEN
                    CALL cl_err('','apc-133',0)
                    NEXT FIELD rwt203_desc
                 END IF
                 LET g_rwt_b[l_ac1].rwt203_b = cl_digcut(g_rwt_b[l_ac1].rwt203_desc*g_rwt.rwt203/100,g_azi04)
                 DISPLAY BY NAME g_rwt_b[l_ac1].rwt203_desc
                 LET l_sum_rwt = 0
                 SELECT COALESCE(SUM(rwt203),0) INTO l_sum_rwt FROM rwt_file WHERE rwt04 = g_rwt.rwt01
                    AND rwt02 = g_rwt.rwt02
                    AND rwt01 <> g_rwt_b[l_ac1].rwt01_b
                 LET l_sum_rwt = l_sum_rwt + g_rwt_b[l_ac1].rwt203_b
                 IF l_sum_rwt > g_rwt.rwt203 THEN
                    IF i140_sure(0,0) THEN
                       LET l_sum_rwt = 0
                       SELECT COALESCE(SUM(rwt203),0) INTO l_sum_rwt FROM rwt_file
                        WHERE rwt04 = g_rwt.rwt01 AND rwt01 <> g_rwt_b[l_ac1].rwt01_b
                          AND rwt02 = g_rwt.rwt02
                       LET g_rwt_b[l_ac1].rwt203_b = g_rwt.rwt203 - l_sum_rwt
                       LET g_replace = g_rwt_b[l_ac1].rwt203_b/g_rwt.rwt203*100
                       LET g_rwt_b[l_ac1].rwt203_desc = cl_digcut(g_replace,0)
                       DISPLAY BY NAME g_rwt_b[l_ac1].rwt203_b,g_rwt_b[l_ac1].rwt203_desc
                       NEXT FIELD rwt203_b
                    ELSE
                       NEXT FIELD rwt203_desc
                    END IF
                 END IF
              END IF
           END IF

        AFTER FIELD rwt203_b
           IF NOT cl_null(g_rwt_b[l_ac1].rwt203_b) THEN
              IF g_rwt_b[l_ac1].rwt203_b < 0 THEN
                 CALL cl_err('','alm-342',0)
                 NEXT FIELD rwt203_b
              END IF
              LET l_sum_rwt = 0
              SELECT COALESCE(SUM(rwt203),0) INTO l_sum_rwt FROM rwt_file WHERE rwt04 = g_rwt.rwt01
                 AND rwt02 = g_rwt.rwt02
                 AND rwt01 <> g_rwt_b[l_ac1].rwt01_b
              LET l_sum_rwt = l_sum_rwt + g_rwt_b[l_ac1].rwt203_b
              IF l_sum_rwt > g_rwt.rwt203 THEN
                 IF i140_sure(0,0) THEN
                    LET l_sum_rwt = 0
                    SELECT COALESCE(SUM(rwt203),0) INTO l_sum_rwt FROM rwt_file
                     WHERE rwt04 = g_rwt.rwt01 AND rwt01 <> g_rwt_b[l_ac1].rwt01_b
                       AND rwt02 = g_rwt.rwt02
                    LET g_rwt_b[l_ac1].rwt203_b = g_rwt.rwt203 - l_sum_rwt
                    LET g_replace = g_rwt_b[l_ac1].rwt203_b/g_rwt.rwt203*100
                    LET g_rwt_b[l_ac1].rwt203_desc = cl_digcut(g_replace,0)
                    DISPLAY BY NAME g_rwt_b[l_ac1].rwt203_b,g_rwt_b[l_ac1].rwt203_desc
                    NEXT FIELD rwt203_b
                 ELSE
                    NEXT FIELD rwt203_b
                 END IF
              END IF
              LET g_replace = g_rwt_b[l_ac1].rwt203_b/g_rwt.rwt203*100
              LET g_rwt_b[l_ac1].rwt203_desc = cl_digcut(g_replace,0)
              DISPLAY BY NAME g_rwt_b[l_ac1].rwt203_desc
           END IF

        AFTER FIELD rwt204_desc
           IF NOT cl_null(g_rwt_b[l_ac1].rwt204_desc) THEN
              IF p_cmd = "a" OR
               (p_cmd = "u" AND g_rwt_b[l_ac1].rwt204_desc <> g_rwt_b_t.rwt204_desc) THEN
                 IF g_rwt_b[l_ac1].rwt204_desc < 0 OR g_rwt_b[l_ac1].rwt204_desc > 100 THEN
                    CALL cl_err('','apc-133',0)
                    NEXT FIELD rwt204_desc
                 END IF
                 LET g_rwt_b[l_ac1].rwt204_b = cl_digcut(g_rwt_b[l_ac1].rwt204_desc*g_rwt.rwt204/100,g_azi04)
                 DISPLAY BY NAME g_rwt_b[l_ac1].rwt204_desc
                 LET l_sum_rwt = 0
                 SELECT COALESCE(SUM(rwt204),0) INTO l_sum_rwt FROM rwt_file WHERE rwt04 = g_rwt.rwt01
                    AND rwt02 = g_rwt.rwt02
                    AND rwt01 <> g_rwt_b[l_ac1].rwt01_b
                 LET l_sum_rwt = l_sum_rwt + g_rwt_b[l_ac1].rwt204_b
                 IF l_sum_rwt > g_rwt.rwt204 THEN
                    IF i140_sure(0,0) THEN
                       LET l_sum_rwt = 0
                       SELECT COALESCE(SUM(rwt204),0) INTO l_sum_rwt FROM rwt_file
                        WHERE rwt04 = g_rwt.rwt01 AND rwt01 <> g_rwt_b[l_ac1].rwt01_b
                          AND rwt02 = g_rwt.rwt02
                       LET g_rwt_b[l_ac1].rwt204_b = g_rwt.rwt204 - l_sum_rwt
                       LET g_replace = g_rwt_b[l_ac1].rwt204_b/g_rwt.rwt204*100
                       LET g_rwt_b[l_ac1].rwt204_desc = cl_digcut(g_replace,0)
                       DISPLAY BY NAME g_rwt_b[l_ac1].rwt204_b,g_rwt_b[l_ac1].rwt204_desc
                       NEXT FIELD rwt204_b
                    ELSE
                       NEXT FIELD rwt204_desc
                    END IF
                 END IF
              END IF
           END IF

        AFTER FIELD rwt204_b
           IF NOT cl_null(g_rwt_b[l_ac1].rwt204_b) THEN
              IF g_rwt_b[l_ac1].rwt204_b < 0 THEN
                 CALL cl_err('','alm-342',0)
                 NEXT FIELD rwt204_b
              END IF
              LET l_sum_rwt = 0
              SELECT COALESCE(SUM(rwt204),0) INTO l_sum_rwt FROM rwt_file WHERE rwt04 = g_rwt.rwt01
                 AND rwt02 = g_rwt.rwt02
                 AND rwt01 <> g_rwt_b[l_ac1].rwt01_b 
              LET l_sum_rwt = l_sum_rwt + g_rwt_b[l_ac1].rwt204_b
              IF l_sum_rwt > g_rwt.rwt204 THEN
                 IF i140_sure(0,0) THEN
                    LET l_sum_rwt = 0
                    SELECT COALESCE(SUM(rwt204),0) INTO l_sum_rwt FROM rwt_file
                     WHERE rwt04 = g_rwt.rwt01 AND rwt01 <> g_rwt_b[l_ac1].rwt01_b
                       AND rwt02 = g_rwt.rwt02
                    LET g_rwt_b[l_ac1].rwt204_b = g_rwt.rwt204 - l_sum_rwt
                    LET g_replace = g_rwt_b[l_ac1].rwt204_b/g_rwt.rwt204*100 
                    LET g_rwt_b[l_ac1].rwt204_desc = cl_digcut(g_replace,0)
                    DISPLAY BY NAME g_rwt_b[l_ac1].rwt204_b,g_rwt_b[l_ac1].rwt204_desc
                    NEXT FIELD rwt204_b
                 ELSE
                    NEXT FIELD rwt204_b
                 END IF
              END IF
              LET g_replace = g_rwt_b[l_ac1].rwt204_b/g_rwt.rwt204*100
              LET g_rwt_b[l_ac1].rwt204_desc = cl_digcut(g_replace,0)
              DISPLAY BY NAME g_rwt_b[l_ac1].rwt204_desc
           END IF

        AFTER FIELD rwt205_desc
           IF NOT cl_null(g_rwt_b[l_ac1].rwt205_desc) THEN
              IF p_cmd = "a" OR
               (p_cmd = "u" AND g_rwt_b[l_ac1].rwt205_desc <> g_rwt_b_t.rwt205_desc) THEN
                 IF g_rwt_b[l_ac1].rwt205_desc < 0 OR g_rwt_b[l_ac1].rwt205_desc > 100 THEN
                    CALL cl_err('','apc-133',0)
                    NEXT FIELD rwt205_desc
                 END IF
                 LET g_rwt_b[l_ac1].rwt205_b = cl_digcut(g_rwt_b[l_ac1].rwt205_desc*g_rwt.rwt205/100,g_azi04)
                 DISPLAY BY NAME g_rwt_b[l_ac1].rwt205_desc
                 LET l_sum_rwt = 0
                 SELECT COALESCE(SUM(rwt205),0) INTO l_sum_rwt FROM rwt_file WHERE rwt04 = g_rwt.rwt01
                    AND rwt02 = g_rwt.rwt02
                    AND rwt01 <> g_rwt_b[l_ac1].rwt01_b
                 LET l_sum_rwt = l_sum_rwt + g_rwt_b[l_ac1].rwt205_b
                 IF l_sum_rwt > g_rwt.rwt205 THEN
                    IF i140_sure(0,0) THEN
                       LET l_sum_rwt = 0
                       SELECT COALESCE(SUM(rwt205),0) INTO l_sum_rwt FROM rwt_file
                        WHERE rwt04 = g_rwt.rwt01 AND rwt01 <> g_rwt_b[l_ac1].rwt01_b
                          AND rwt02 = g_rwt.rwt02
                       LET g_rwt_b[l_ac1].rwt205_b = g_rwt.rwt205 - l_sum_rwt
                       LET g_replace = g_rwt_b[l_ac1].rwt205_b/g_rwt.rwt205*100
                       LET g_rwt_b[l_ac1].rwt205_desc = cl_digcut(g_replace,0)
                       DISPLAY BY NAME g_rwt_b[l_ac1].rwt205_b,g_rwt_b[l_ac1].rwt205_desc
                       NEXT FIELD rwt205_b
                    ELSE
                       NEXT FIELD rwt205_desc
                    END IF
                 END IF
              END IF
           END IF

        AFTER FIELD rwt205_b
           IF NOT cl_null(g_rwt_b[l_ac1].rwt205_b) THEN
              IF g_rwt_b[l_ac1].rwt205_b < 0 THEN
                 CALL cl_err('','alm-342',0)
                 NEXT FIELD rwt205_b
              END IF
              LET l_sum_rwt = 0
              SELECT COALESCE(SUM(rwt205),0) INTO l_sum_rwt FROM rwt_file WHERE rwt04 = g_rwt.rwt01
                 AND rwt02 = g_rwt.rwt02
                 AND rwt01 <> g_rwt_b[l_ac1].rwt01_b 
              LET l_sum_rwt = l_sum_rwt + g_rwt_b[l_ac1].rwt205_b
              IF l_sum_rwt > g_rwt.rwt205 THEN
                 IF i140_sure(0,0) THEN
                    LET l_sum_rwt = 0
                    SELECT COALESCE(SUM(rwt205),0) INTO l_sum_rwt FROM rwt_file
                     WHERE rwt04 = g_rwt.rwt01 AND rwt01 <> g_rwt_b[l_ac1].rwt01_b
                       AND rwt02 = g_rwt.rwt02
                    LET g_rwt_b[l_ac1].rwt205_b = g_rwt.rwt205 - l_sum_rwt
                    LET g_replace = g_rwt_b[l_ac1].rwt205_b/g_rwt.rwt205*100
                    LET g_rwt_b[l_ac1].rwt205_desc = cl_digcut(g_replace,0)
                    DISPLAY BY NAME g_rwt_b[l_ac1].rwt205_b,g_rwt_b[l_ac1].rwt205_desc
                    NEXT FIELD rwt205_b
                 ELSE
                    NEXT FIELD rwt205_b
                 END IF
              END IF
              LET g_replace = g_rwt_b[l_ac1].rwt205_b/g_rwt.rwt205*100
              LET g_rwt_b[l_ac1].rwt205_desc = cl_digcut(g_replace,0)
              DISPLAY BY NAME g_rwt_b[l_ac1].rwt205_desc
           END IF

        AFTER FIELD rwt206_desc
           IF NOT cl_null(g_rwt_b[l_ac1].rwt206_desc) THEN
              IF p_cmd = "a" OR
               (p_cmd = "u" AND g_rwt_b[l_ac1].rwt206_desc <> g_rwt_b_t.rwt206_desc) THEN
                 IF g_rwt_b[l_ac1].rwt206_desc < 0 OR g_rwt_b[l_ac1].rwt206_desc > 100 THEN
                    CALL cl_err('','apc-133',0)
                    NEXT FIELD rwt206_desc
                 END IF
                 LET g_rwt_b[l_ac1].rwt206_b = cl_digcut(g_rwt_b[l_ac1].rwt206_desc*g_rwt.rwt206/100,g_azi04)
                 DISPLAY BY NAME g_rwt_b[l_ac1].rwt206_desc
                 LET l_sum_rwt = 0
                 SELECT COALESCE(SUM(rwt206),0) INTO l_sum_rwt FROM rwt_file WHERE rwt04 = g_rwt.rwt01
                    AND rwt02 = g_rwt.rwt02
                    AND rwt01 <> g_rwt_b[l_ac1].rwt01_b
                 LET l_sum_rwt = l_sum_rwt + g_rwt_b[l_ac1].rwt206_b
                 IF l_sum_rwt > g_rwt.rwt206 THEN
                    IF i140_sure(0,0) THEN
                       LET l_sum_rwt = 0
                       SELECT COALESCE(SUM(rwt206),0) INTO l_sum_rwt FROM rwt_file
                        WHERE rwt04 = g_rwt.rwt01 AND rwt01 <> g_rwt_b[l_ac1].rwt01_b
                          AND rwt02 = g_rwt.rwt02
                       LET g_rwt_b[l_ac1].rwt206_b = g_rwt.rwt206 - l_sum_rwt
                       LET g_replace = g_rwt_b[l_ac1].rwt206_b/g_rwt.rwt206*100
                       LET g_rwt_b[l_ac1].rwt206_desc = cl_digcut(g_replace,0)
                       DISPLAY BY NAME g_rwt_b[l_ac1].rwt206_b,g_rwt_b[l_ac1].rwt206_desc
                       NEXT FIELD rwt206_b
                    ELSE
                       NEXT FIELD rwt206_desc
                    END IF
                 END IF
              END IF
           END IF

        AFTER FIELD rwt206_b
           IF NOT cl_null(g_rwt_b[l_ac1].rwt206_b) THEN
              IF g_rwt_b[l_ac1].rwt206_b < 0 THEN
                 CALL cl_err('','alm-342',0)
                 NEXT FIELD rwt206_b
              END IF
              LET l_sum_rwt = 0
              SELECT COALESCE(SUM(rwt206),0) INTO l_sum_rwt FROM rwt_file WHERE rwt04 = g_rwt.rwt01
                 AND rwt02 = g_rwt.rwt02
                 AND rwt01 <> g_rwt_b[l_ac1].rwt01_b 
              LET l_sum_rwt = l_sum_rwt + g_rwt_b[l_ac1].rwt206_b
              IF l_sum_rwt > g_rwt.rwt206 THEN
                 IF i140_sure(0,0) THEN
                    LET l_sum_rwt = 0
                    SELECT COALESCE(SUM(rwt206),0) INTO l_sum_rwt FROM rwt_file
                     WHERE rwt04 = g_rwt.rwt01 AND rwt01 <> g_rwt_b[l_ac1].rwt01_b
                       AND rwt02 = g_rwt.rwt02
                    LET g_rwt_b[l_ac1].rwt206_b = g_rwt.rwt206 - l_sum_rwt
                    LET g_replace = g_rwt_b[l_ac1].rwt206_b/g_rwt.rwt206*100
                    LET g_rwt_b[l_ac1].rwt206_desc = cl_digcut(g_replace,0)
                    DISPLAY BY NAME g_rwt_b[l_ac1].rwt206_b,g_rwt_b[l_ac1].rwt206_desc
                    NEXT FIELD rwt206_b
                 ELSE
                    NEXT FIELD rwt206_b
                 END IF
              END IF
              LET g_replace = g_rwt_b[l_ac1].rwt206_b/g_rwt.rwt206*100
              LET g_rwt_b[l_ac1].rwt206_desc = cl_digcut(g_replace,0)
              DISPLAY BY NAME g_rwt_b[l_ac1].rwt206_desc
           END IF

        AFTER FIELD rwt207_desc
           IF NOT cl_null(g_rwt_b[l_ac1].rwt207_desc) THEN
              IF p_cmd = "a" OR
               (p_cmd = "u" AND g_rwt_b[l_ac1].rwt207_desc <> g_rwt_b_t.rwt207_desc) THEN
                 IF g_rwt_b[l_ac1].rwt207_desc < 0 OR g_rwt_b[l_ac1].rwt207_desc > 100 THEN
                    CALL cl_err('','apc-133',0)
                    NEXT FIELD rwt207_desc
                 END IF
                 LET g_rwt_b[l_ac1].rwt207_b = cl_digcut(g_rwt_b[l_ac1].rwt207_desc*g_rwt.rwt207/100,g_azi04)
                 DISPLAY BY NAME g_rwt_b[l_ac1].rwt207_desc
                 LET l_sum_rwt = 0
                 SELECT COALESCE(SUM(rwt207),0) INTO l_sum_rwt FROM rwt_file WHERE rwt04 = g_rwt.rwt01
                    AND rwt02 = g_rwt.rwt02
                    AND rwt01 <> g_rwt_b[l_ac1].rwt01_b
                 LET l_sum_rwt = l_sum_rwt + g_rwt_b[l_ac1].rwt207_b
                 IF l_sum_rwt > g_rwt.rwt207 THEN
                    IF i140_sure(0,0) THEN
                       LET l_sum_rwt = 0
                       SELECT COALESCE(SUM(rwt207),0) INTO l_sum_rwt FROM rwt_file
                        WHERE rwt04 = g_rwt.rwt01 AND rwt01 <> g_rwt_b[l_ac1].rwt01_b
                          AND rwt02 = g_rwt.rwt02
                       LET g_rwt_b[l_ac1].rwt207_b = g_rwt.rwt207 - l_sum_rwt
                       LET g_replace = g_rwt_b[l_ac1].rwt207_b/g_rwt.rwt207*100
                       LET g_rwt_b[l_ac1].rwt207_desc = cl_digcut(g_replace,0)
                       DISPLAY BY NAME g_rwt_b[l_ac1].rwt207_b,g_rwt_b[l_ac1].rwt207_desc
                       NEXT FIELD rwt207_b
                    ELSE
                       NEXT FIELD rwt207_desc
                    END IF
                 END IF
              END IF
           END IF

        AFTER FIELD rwt207_b
           IF NOT cl_null(g_rwt_b[l_ac1].rwt207_b) THEN
              IF g_rwt_b[l_ac1].rwt207_b < 0 THEN
                 CALL cl_err('','alm-342',0)
                 NEXT FIELD rwt207_b
              END IF
              LET l_sum_rwt = 0
              SELECT COALESCE(SUM(rwt207),0) INTO l_sum_rwt FROM rwt_file WHERE rwt04 = g_rwt.rwt01
                 AND rwt02 = g_rwt.rwt02
                 AND rwt01 <> g_rwt_b[l_ac1].rwt01_b 
              LET l_sum_rwt = l_sum_rwt + g_rwt_b[l_ac1].rwt207_b
              IF l_sum_rwt > g_rwt.rwt207 THEN
                 IF i140_sure(0,0) THEN
                    LET l_sum_rwt = 0
                    SELECT COALESCE(SUM(rwt207),0) INTO l_sum_rwt FROM rwt_file
                     WHERE rwt04 = g_rwt.rwt01 AND rwt01 <> g_rwt_b[l_ac1].rwt01_b
                       AND rwt02 = g_rwt.rwt02
                    LET g_rwt_b[l_ac1].rwt207_b = g_rwt.rwt207 - l_sum_rwt
                    LET g_replace = g_rwt_b[l_ac1].rwt207_b/g_rwt.rwt207*100
                    LET g_rwt_b[l_ac1].rwt207_desc = cl_digcut(g_replace,0)
                    DISPLAY BY NAME g_rwt_b[l_ac1].rwt207_b,g_rwt_b[l_ac1].rwt207_desc
                    NEXT FIELD rwt207_b
                 ELSE
                    NEXT FIELD rwt207_b
                 END IF
              END IF
              LET g_replace = g_rwt_b[l_ac1].rwt207_b/g_rwt.rwt207*100
              LET g_rwt_b[l_ac1].rwt207_desc = cl_digcut(g_replace,0)
              DISPLAY BY NAME g_rwt_b[l_ac1].rwt207_desc
           END IF

        AFTER FIELD rwt208_desc
           IF NOT cl_null(g_rwt_b[l_ac1].rwt208_desc) THEN
              IF p_cmd = "a" OR
               (p_cmd = "u" AND g_rwt_b[l_ac1].rwt208_desc <> g_rwt_b_t.rwt208_desc) THEN
                 IF g_rwt_b[l_ac1].rwt208_desc < 0 OR g_rwt_b[l_ac1].rwt208_desc > 100 THEN
                    CALL cl_err('','apc-133',0)
                    NEXT FIELD rwt208_desc
                 END IF
                 LET g_rwt_b[l_ac1].rwt208_b = cl_digcut(g_rwt_b[l_ac1].rwt208_desc*g_rwt.rwt208/100,g_azi04)
                 DISPLAY BY NAME g_rwt_b[l_ac1].rwt208_desc
                 LET l_sum_rwt = 0
                 SELECT COALESCE(SUM(rwt208),0) INTO l_sum_rwt FROM rwt_file WHERE rwt04 = g_rwt.rwt01
                    AND rwt02 = g_rwt.rwt02
                    AND rwt01 <> g_rwt_b[l_ac1].rwt01_b
                 LET l_sum_rwt = l_sum_rwt + g_rwt_b[l_ac1].rwt208_b
                 IF l_sum_rwt > g_rwt.rwt208 THEN
                    IF i140_sure(0,0) THEN
                       LET l_sum_rwt = 0
                       SELECT COALESCE(SUM(rwt208),0) INTO l_sum_rwt FROM rwt_file
                        WHERE rwt04 = g_rwt.rwt01 AND rwt01 <> g_rwt_b[l_ac1].rwt01_b
                          AND rwt02 = g_rwt.rwt02
                       LET g_rwt_b[l_ac1].rwt208_b = g_rwt.rwt208 - l_sum_rwt
                       LET g_replace = g_rwt_b[l_ac1].rwt208_b/g_rwt.rwt208*100
                       LET g_rwt_b[l_ac1].rwt208_desc = cl_digcut(g_replace,0)
                       DISPLAY BY NAME g_rwt_b[l_ac1].rwt208_b,g_rwt_b[l_ac1].rwt208_desc
                       NEXT FIELD rwt208_b
                    ELSE
                       NEXT FIELD rwt208_desc
                    END IF
                 END IF
              END IF
           END IF

        AFTER FIELD rwt208_b
           IF NOT cl_null(g_rwt_b[l_ac1].rwt208_b) THEN
              IF g_rwt_b[l_ac1].rwt208_b < 0 THEN
                 CALL cl_err('','alm-342',0)
                 NEXT FIELD rwt208_b
              END IF
              LET l_sum_rwt = 0
              SELECT COALESCE(SUM(rwt208),0) INTO l_sum_rwt FROM rwt_file WHERE rwt04 = g_rwt.rwt01
                 AND rwt02 = g_rwt.rwt02
                 AND rwt01 <> g_rwt_b[l_ac1].rwt01_b 
              LET l_sum_rwt = l_sum_rwt + g_rwt_b[l_ac1].rwt208_b
              IF l_sum_rwt > g_rwt.rwt208 THEN
                 IF i140_sure(0,0) THEN
                    LET l_sum_rwt = 0
                    SELECT COALESCE(SUM(rwt208),0) INTO l_sum_rwt FROM rwt_file
                     WHERE rwt04 = g_rwt.rwt01 AND rwt01 <> g_rwt_b[l_ac1].rwt01_b
                       AND rwt02 = g_rwt.rwt02
                    LET g_rwt_b[l_ac1].rwt208_b = g_rwt.rwt208 - l_sum_rwt
                    LET g_replace = g_rwt_b[l_ac1].rwt208_b/g_rwt.rwt208*100
                    LET g_rwt_b[l_ac1].rwt208_desc = cl_digcut(g_replace,0)
                    DISPLAY BY NAME g_rwt_b[l_ac1].rwt208_b,g_rwt_b[l_ac1].rwt208_desc
                    NEXT FIELD rwt208_b
                 ELSE
                    NEXT FIELD rwt208_b
                 END IF
              END IF
              LET g_replace = g_rwt_b[l_ac1].rwt208_b/g_rwt.rwt208*100
              LET g_rwt_b[l_ac1].rwt208_desc = cl_digcut(g_replace,0)
              DISPLAY BY NAME g_rwt_b[l_ac1].rwt208_desc
           END IF

        AFTER FIELD rwt209_b
           IF NOT cl_null(g_rwt_b[l_ac1].rwt209_b) THEN
              IF g_rwt_b[l_ac1].rwt209_b < 0 THEN
                 CALL cl_err('','alm-342',0)
                 NEXT FIELD rwt209_b
              END IF
              LET l_sum_rwt = 0
              SELECT COALESCE(SUM(rwt209),0) INTO l_sum_rwt FROM rwt_file WHERE rwt04 = g_rwt.rwt01
                 AND rwt02 = g_rwt.rwt02
                 AND rwt01 <> g_rwt_b[l_ac1].rwt01_b
              LET l_sum_rwt = l_sum_rwt + g_rwt_b[l_ac1].rwt209_b
              IF l_sum_rwt > g_rwt.rwt209 THEN
                 IF i140_sure(0,0) THEN
                    LET l_sum_rwt = 0
                    SELECT COALESCE(SUM(rwt209),0) INTO l_sum_rwt FROM rwt_file
                     WHERE rwt04 = g_rwt.rwt01 AND rwt01 <> g_rwt_b[l_ac1].rwt01_b
                       AND rwt02 = g_rwt.rwt02
                    LET g_rwt_b[l_ac1].rwt209_b = g_rwt.rwt209 - l_sum_rwt
                    LET g_replace = g_rwt_b[l_ac1].rwt209_b/g_rwt.rwt209*100
                    LET g_rwt_b[l_ac1].rwt209_desc = cl_digcut(g_replace,0)
                    DISPLAY BY NAME g_rwt_b[l_ac1].rwt209_b,g_rwt_b[l_ac1].rwt209_desc
                    NEXT FIELD rwt209_b
                 ELSE
                    NEXT FIELD rwt209_b
                 END IF
              END IF
              LET g_replace = g_rwt_b[l_ac1].rwt209_b/g_rwt.rwt209*100
              LET g_rwt_b[l_ac1].rwt209_desc = cl_digcut(g_replace,0)
              DISPLAY BY NAME g_rwt_b[l_ac1].rwt209_desc
           END IF

        AFTER FIELD rwt209_desc
           IF NOT cl_null(g_rwt_b[l_ac1].rwt209_desc) THEN
              IF p_cmd = "a" OR
               (p_cmd = "u" AND g_rwt_b[l_ac1].rwt209_desc <> g_rwt_b_t.rwt209_desc) THEN
                 IF g_rwt_b[l_ac1].rwt209_desc < 0 OR g_rwt_b[l_ac1].rwt209_desc > 100 THEN
                    CALL cl_err('','apc-133',0)
                    NEXT FIELD rwt209_desc
                 END IF
                 LET g_rwt_b[l_ac1].rwt209_b = cl_digcut(g_rwt_b[l_ac1].rwt209_desc*g_rwt.rwt209/100,g_azi04)
                 DISPLAY BY NAME g_rwt_b[l_ac1].rwt209_desc
                 LET l_sum_rwt = 0
                 SELECT COALESCE(SUM(rwt209),0) INTO l_sum_rwt FROM rwt_file WHERE rwt04 = g_rwt.rwt01
                    AND rwt02 = g_rwt.rwt02
                    AND rwt01 <> g_rwt_b[l_ac1].rwt01_b
                 LET l_sum_rwt = l_sum_rwt + g_rwt_b[l_ac1].rwt209_b
                 IF l_sum_rwt > g_rwt.rwt209 THEN
                    IF i140_sure(0,0) THEN
                       LET l_sum_rwt = 0
                       SELECT COALESCE(SUM(rwt209),0) INTO l_sum_rwt FROM rwt_file
                        WHERE rwt04 = g_rwt.rwt01 AND rwt01 <> g_rwt_b[l_ac1].rwt01_b
                          AND rwt02 = g_rwt.rwt02
                       LET g_rwt_b[l_ac1].rwt209_b = g_rwt.rwt209 - l_sum_rwt
                       LET g_replace = g_rwt_b[l_ac1].rwt209_b/g_rwt.rwt209*100
                       LET g_rwt_b[l_ac1].rwt209_desc = cl_digcut(g_replace,0)
                       DISPLAY BY NAME g_rwt_b[l_ac1].rwt209_b,g_rwt_b[l_ac1].rwt209_desc
                       NEXT FIELD rwt209_b
                    ELSE
                       NEXT FIELD rwt209_desc
                    END IF
                 END IF
              END IF
           END IF

        AFTER FIELD rwt210_b
           IF NOT cl_null(g_rwt_b[l_ac1].rwt210_b) THEN
              IF g_rwt_b[l_ac1].rwt210_b < 0 THEN
                 CALL cl_err('','alm-342',0)
                 NEXT FIELD rwt210_b
              END IF
              LET l_sum_rwt = 0
              SELECT COALESCE(SUM(rwt210),0) INTO l_sum_rwt FROM rwt_file WHERE rwt04 = g_rwt.rwt01
                 AND rwt02 = g_rwt.rwt02
                 AND rwt01 <> g_rwt_b[l_ac1].rwt01_b 
              LET l_sum_rwt = l_sum_rwt + g_rwt_b[l_ac1].rwt210_b
              IF l_sum_rwt > g_rwt.rwt210 THEN
                 IF i140_sure(0,0) THEN
                    LET l_sum_rwt = 0
                    SELECT COALESCE(SUM(rwt210),0) INTO l_sum_rwt FROM rwt_file
                     WHERE rwt04 = g_rwt.rwt01 AND rwt01 <> g_rwt_b[l_ac1].rwt01_b
                       AND rwt02 = g_rwt.rwt02
                    LET g_rwt_b[l_ac1].rwt210_b = g_rwt.rwt210 - l_sum_rwt
                    LET g_replace = g_rwt_b[l_ac1].rwt210_b/g_rwt.rwt210*100
                    LET g_rwt_b[l_ac1].rwt210_desc = cl_digcut(g_replace,0)
                    DISPLAY BY NAME g_rwt_b[l_ac1].rwt210_b,g_rwt_b[l_ac1].rwt210_desc
                    NEXT FIELD rwt210_b
                 ELSE
                    NEXT FIELD rwt210_b
                 END IF
              END IF
              LET g_replace = g_rwt_b[l_ac1].rwt210_b/g_rwt.rwt210*100
              LET g_rwt_b[l_ac1].rwt210_desc = cl_digcut(g_replace,0)
              DISPLAY BY NAME g_rwt_b[l_ac1].rwt210_desc
           END IF

        AFTER FIELD rwt210_desc
           IF NOT cl_null(g_rwt_b[l_ac1].rwt210_desc) THEN
              IF p_cmd = "a" OR
               (p_cmd = "u" AND g_rwt_b[l_ac1].rwt210_desc <> g_rwt_b_t.rwt210_desc) THEN
                 IF g_rwt_b[l_ac1].rwt210_desc < 0 OR g_rwt_b[l_ac1].rwt210_desc > 100 THEN
                    CALL cl_err('','apc-133',0)
                    NEXT FIELD rwt210_desc
                 END IF
                 LET g_rwt_b[l_ac1].rwt210_b = cl_digcut(g_rwt_b[l_ac1].rwt210_desc*g_rwt.rwt210/100,g_azi04)
                 DISPLAY BY NAME g_rwt_b[l_ac1].rwt210_desc
                 LET l_sum_rwt = 0
                 SELECT COALESCE(SUM(rwt210),0) INTO l_sum_rwt FROM rwt_file WHERE rwt04 = g_rwt.rwt01
                    AND rwt02 = g_rwt.rwt02
                    AND rwt01 <> g_rwt_b[l_ac1].rwt01_b
                 LET l_sum_rwt = l_sum_rwt + g_rwt_b[l_ac1].rwt210_b
                 IF l_sum_rwt > g_rwt.rwt210 THEN
                    IF i140_sure(0,0) THEN
                       LET l_sum_rwt = 0
                       SELECT COALESCE(SUM(rwt210),0) INTO l_sum_rwt FROM rwt_file
                        WHERE rwt04 = g_rwt.rwt01 AND rwt01 <> g_rwt_b[l_ac1].rwt01_b
                          AND rwt02 = g_rwt.rwt02
                       LET g_rwt_b[l_ac1].rwt210_b = g_rwt.rwt210 - l_sum_rwt
                       LET g_replace = g_rwt_b[l_ac1].rwt210_b/g_rwt.rwt210*100
                       LET g_rwt_b[l_ac1].rwt210_desc = cl_digcut(g_replace,0)
                       DISPLAY BY NAME g_rwt_b[l_ac1].rwt210_b,g_rwt_b[l_ac1].rwt210_desc
                       NEXT FIELD rwt210_b
                    ELSE
                       NEXT FIELD rwt210_desc
                    END IF
                 END IF
              END IF
           END IF

        AFTER FIELD rwt211_desc
           IF NOT cl_null(g_rwt_b[l_ac1].rwt211_desc) THEN
              IF p_cmd = "a" OR
               (p_cmd = "u" AND g_rwt_b[l_ac1].rwt211_desc <> g_rwt_b_t.rwt211_desc) THEN
                 IF g_rwt_b[l_ac1].rwt211_desc < 0 OR g_rwt_b[l_ac1].rwt211_desc > 100 THEN
                    CALL cl_err('','apc-133',0)
                    NEXT FIELD rwt211_desc
                 END IF
                 LET g_rwt_b[l_ac1].rwt211_b = cl_digcut(g_rwt_b[l_ac1].rwt211_desc*g_rwt.rwt211/100,g_azi04)
                 DISPLAY BY NAME g_rwt_b[l_ac1].rwt211_desc
                 LET l_sum_rwt = 0
                 SELECT COALESCE(SUM(rwt211),0) INTO l_sum_rwt FROM rwt_file WHERE rwt04 = g_rwt.rwt01
                    AND rwt02 = g_rwt.rwt02
                    AND rwt01 <> g_rwt_b[l_ac1].rwt01_b
                 LET l_sum_rwt = l_sum_rwt + g_rwt_b[l_ac1].rwt211_b
                 IF l_sum_rwt > g_rwt.rwt211 THEN
                    IF i140_sure(0,0) THEN
                       LET l_sum_rwt = 0
                       SELECT COALESCE(SUM(rwt211),0) INTO l_sum_rwt FROM rwt_file
                        WHERE rwt04 = g_rwt.rwt01 AND rwt01 <> g_rwt_b[l_ac1].rwt01_b
                          AND rwt02 = g_rwt.rwt02
                       LET g_rwt_b[l_ac1].rwt211_b = g_rwt.rwt211 - l_sum_rwt
                       LET g_replace = g_rwt_b[l_ac1].rwt211_b/g_rwt.rwt211*100
                       LET g_rwt_b[l_ac1].rwt211_desc = cl_digcut(g_replace,0)
                       DISPLAY BY NAME g_rwt_b[l_ac1].rwt211_b,g_rwt_b[l_ac1].rwt211_desc
                       NEXT FIELD rwt211_b
                    ELSE
                       NEXT FIELD rwt211_desc
                    END IF
                 END IF
              END IF
           END IF

        AFTER FIELD rwt211_b
           IF NOT cl_null(g_rwt_b[l_ac1].rwt211_b) THEN
              IF g_rwt_b[l_ac1].rwt211_b < 0 THEN
                 CALL cl_err('','alm-342',0)
                 NEXT FIELD rwt211_b
              END IF
              LET l_sum_rwt = 0
              SELECT COALESCE(SUM(rwt211),0) INTO l_sum_rwt FROM rwt_file WHERE rwt04 = g_rwt.rwt01
                 AND rwt02 = g_rwt.rwt02
                 AND rwt01 <> g_rwt_b[l_ac1].rwt01_b 
              LET l_sum_rwt = l_sum_rwt + g_rwt_b[l_ac1].rwt211_b
              IF l_sum_rwt > g_rwt.rwt211 THEN
                 IF i140_sure(0,0) THEN
                    LET l_sum_rwt = 0
                    SELECT COALESCE(SUM(rwt211),0) INTO l_sum_rwt FROM rwt_file
                     WHERE rwt04 = g_rwt.rwt01 AND rwt01 <> g_rwt_b[l_ac1].rwt01_b
                       AND rwt02 = g_rwt.rwt02
                    LET g_rwt_b[l_ac1].rwt211_b = g_rwt.rwt211 - l_sum_rwt
                    LET g_replace = g_rwt_b[l_ac1].rwt211_b/g_rwt.rwt211*100
                    LET g_rwt_b[l_ac1].rwt211_desc = cl_digcut(g_replace,0)
                    DISPLAY BY NAME g_rwt_b[l_ac1].rwt211_b,g_rwt_b[l_ac1].rwt211_desc
                    NEXT FIELD rwt211_b
                 ELSE
                    NEXT FIELD rwt211_b
                 END IF
              END IF
              LET g_replace = g_rwt_b[l_ac1].rwt211_b/g_rwt.rwt211*100
              LET g_rwt_b[l_ac1].rwt211_desc = cl_digcut(g_replace,0)
              DISPLAY BY NAME g_rwt_b[l_ac1].rwt211_desc
           END IF

        AFTER FIELD rwt212_desc
           IF NOT cl_null(g_rwt_b[l_ac1].rwt212_desc) THEN
              IF p_cmd = "a" OR
               (p_cmd = "u" AND g_rwt_b[l_ac1].rwt212_desc <> g_rwt_b_t.rwt212_desc) THEN
                 IF g_rwt_b[l_ac1].rwt212_desc < 0 OR g_rwt_b[l_ac1].rwt212_desc > 100 THEN
                    CALL cl_err('','apc-133',0)
                    NEXT FIELD rwt212_desc
                 END IF
                 LET g_rwt_b[l_ac1].rwt212_b = cl_digcut(g_rwt_b[l_ac1].rwt212_desc*g_rwt.rwt212/100,g_azi04)
                 DISPLAY BY NAME g_rwt_b[l_ac1].rwt212_desc
                 LET l_sum_rwt = 0
                 SELECT COALESCE(SUM(rwt212),0) INTO l_sum_rwt FROM rwt_file WHERE rwt04 = g_rwt.rwt01
                    AND rwt02 = g_rwt.rwt02
                    AND rwt01 <> g_rwt_b[l_ac1].rwt01_b
                 LET l_sum_rwt = l_sum_rwt + g_rwt_b[l_ac1].rwt212_b
                 IF l_sum_rwt > g_rwt.rwt212 THEN
                    IF i140_sure(0,0) THEN
                       LET l_sum_rwt = 0
                       SELECT COALESCE(SUM(rwt212),0) INTO l_sum_rwt FROM rwt_file
                        WHERE rwt04 = g_rwt.rwt01 AND rwt01 <> g_rwt_b[l_ac1].rwt01_b
                          AND rwt02 = g_rwt.rwt02
                       LET g_rwt_b[l_ac1].rwt212_b = g_rwt.rwt212 - l_sum_rwt
                       LET g_replace = g_rwt_b[l_ac1].rwt212_b/g_rwt.rwt212*100
                       LET g_rwt_b[l_ac1].rwt212_desc = cl_digcut(g_replace,0)
                       DISPLAY BY NAME g_rwt_b[l_ac1].rwt212_b,g_rwt_b[l_ac1].rwt212_desc
                       NEXT FIELD rwt212_b
                    ELSE
                       NEXT FIELD rwt212_desc
                    END IF
                 END IF
              END IF
           END IF

        AFTER FIELD rwt212_b
           IF NOT cl_null(g_rwt_b[l_ac1].rwt212_b) THEN
              IF g_rwt_b[l_ac1].rwt212_b < 0 THEN
                 CALL cl_err('','alm-342',0)
                 NEXT FIELD rwt212_b
              END IF
              LET l_sum_rwt = 0
              SELECT COALESCE(SUM(rwt212),0) INTO l_sum_rwt FROM rwt_file WHERE rwt04 = g_rwt.rwt01
                 AND rwt02 = g_rwt.rwt02
                 AND rwt01 <> g_rwt_b[l_ac1].rwt01_b
              LET l_sum_rwt = l_sum_rwt + g_rwt_b[l_ac1].rwt212_b
              IF l_sum_rwt > g_rwt.rwt212 THEN
                 IF i140_sure(0,0) THEN
                    LET l_sum_rwt = 0
                    SELECT COALESCE(SUM(rwt212),0) INTO l_sum_rwt FROM rwt_file
                     WHERE rwt04 = g_rwt.rwt01 AND rwt01 <> g_rwt_b[l_ac1].rwt01_b
                       AND rwt02 = g_rwt.rwt02
                    LET g_rwt_b[l_ac1].rwt212_b = g_rwt.rwt212 - l_sum_rwt
                    LET g_replace = g_rwt_b[l_ac1].rwt212_b/g_rwt.rwt212*100
                    LET g_rwt_b[l_ac1].rwt212_desc = cl_digcut(g_replace,0)
                    DISPLAY BY NAME g_rwt_b[l_ac1].rwt212_b,g_rwt_b[l_ac1].rwt212_desc
                    NEXT FIELD rwt212_b
                 ELSE
                    NEXT FIELD rwt212_b
                 END IF
              END IF
              LET g_replace = g_rwt_b[l_ac1].rwt212_b/g_rwt.rwt212*100
              LET g_rwt_b[l_ac1].rwt212_desc = cl_digcut(g_replace,0)
              DISPLAY BY NAME g_rwt_b[l_ac1].rwt212_desc
           END IF

        BEFORE DELETE  
           DISPLAY "BEFORE DELETE"
           IF NOT cl_null(g_rwt_b[l_ac1].rwt01_b) AND NOT cl_null(g_rwt_b[l_ac1].rwt02_b) THEN
              LET l_azw07_n = 0
              SELECT COUNT(*) INTO l_azw07_n FROM azw_file WHERE azw07 = g_rwt_b[l_ac1].rwt01_b AND azwacti = 'Y'
              LET l_n = 0
              IF l_azw07_n > 0 THEN
                 SELECT COUNT(*) INTO l_n FROM rwt_file 
                  WHERE rwt04 = g_rwt_b[l_ac1].rwt01_b AND rwt02 = g_rwt_b[l_ac1].rwt02_b
              ELSE
                 SELECT COUNT(*) INTO l_n FROM rwu_file
                  WHERE rwu01 = g_rwt_b[l_ac1].rwt01_b AND rwu02 = g_rwt_b[l_ac1].rwt02_b
              END IF
              IF l_n > 0 THEN
                 #---已設定下級營運中心的銷售目標，不允許刪除---#
                 CALL cl_err('','art-695',0)
                 CANCEL DELETE
              END IF
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rwt_file
               WHERE rwt01 = g_rwt_b_t.rwt01_b
                 AND rwt02 = g_rwt_b_t.rwt02_b
                 
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","rwt_file",g_rwt_b_t.rwt01_b,
                              g_rwt_b_t.rwt02_b,SQLCA.sqlcode,"","",1)
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b1=g_rec_b1-1
              DISPLAY g_rec_b1 TO FORMONLY.cn2
           END IF
           COMMIT WORK

        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rwt_b[l_ac1].* = g_rwt_b_t.*
              CLOSE i140_bcl1
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_rwt_b[l_ac1].rwt01_b,-263,1)
              LET g_rwt_b[l_ac1].* = g_rwt_b_t.*
           ELSE
              UPDATE rwt_file SET rwt201  = g_rwt_b[l_ac1].rwt201_b,
                                  rwt202  = g_rwt_b[l_ac1].rwt202_b,
                                  rwt203  = g_rwt_b[l_ac1].rwt203_b,
                                  rwt204  = g_rwt_b[l_ac1].rwt204_b,
                                  rwt205  = g_rwt_b[l_ac1].rwt205_b,
                                  rwt206  = g_rwt_b[l_ac1].rwt206_b,
                                  rwt207  = g_rwt_b[l_ac1].rwt207_b,
                                  rwt208  = g_rwt_b[l_ac1].rwt208_b,
                                  rwt209  = g_rwt_b[l_ac1].rwt209_b,
                                  rwt210  = g_rwt_b[l_ac1].rwt210_b,
                                  rwt211  = g_rwt_b[l_ac1].rwt211_b,
                                  rwt212  = g_rwt_b[l_ac1].rwt212_b,
                                  rwtdate = g_today,
                                  rwtmodu = g_user
               WHERE rwt01 = g_rwt_b_t.rwt01_b
                 AND rwt02 = g_rwt_b_t.rwt02_b
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rwt_file",g_rwt_b_t.rwt01_b,
                              g_rwt_b_t.rwt02_b,SQLCA.sqlcode,"","",1)
                 LET g_rwt_b[l_ac1].* = g_rwt_b_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF

        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac1 = ARR_CURR()
          #LET l_ac_t1 = l_ac1  #FUN-D30033 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rwt_b[l_ac1].* = g_rwt_b_t.*
              #FUN-D30033--add--begin--
              ELSE
                 CALL g_rwt_b.deleteElement(l_ac1)
                 IF g_rec_b1 != 0 THEN
                    LET g_action_choice = "set_lower_level"
                    LET l_ac1 = l_ac_t1
                 END IF
              #FUN-D30033--add--end----
              END IF
              CLOSE i140_bcl1
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t1 = l_ac1  #FUN-D30033 add
           CLOSE i140_bcl1
           COMMIT WORK

        AFTER INPUT
           IF INT_FLAG THEN
              EXIT INPUT
           END IF
           CALL i140_fill_head()

        ON ACTION CONTROLR
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
           CALL cl_cmdask()

        ON ACTION controlp
           CASE
             WHEN INFIELD(rwt01_b)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_azw"
                LET g_qryparam.where = " azw01 IN (SELECT azw01 FROM azw_file ",
                                       "            WHERE azw07 = '",g_rwt.rwt01,"' ",
                                       "              AND azwacti = 'Y')"
                LET g_qryparam.default1 = g_rwt_b[l_ac1].rwt01_b
                CALL cl_create_qry() RETURNING g_rwt_b[l_ac1].rwt01_b
                DISPLAY g_rwt_b[l_ac1].rwt01_b TO rwt01
                NEXT FIELD rwt01_b
           END CASE

      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) 
            RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
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

    CLOSE i140_bcl1
    COMMIT WORK

END FUNCTION

FUNCTION i140_b2()
   DEFINE
      l_ac_t2         LIKE type_file.num5, 
      l_n             LIKE type_file.num5,       
      l_lock_sw       LIKE type_file.chr1,   
      p_cmd           LIKE type_file.chr1,  
      l_allow_insert  LIKE type_file.num5,   
      l_allow_delete  LIKE type_file.num5  
   DEFINE l_sum_rwu   LIKE rwu_file.rwu201

    LET g_action_choice = ""

    IF s_shut(0) THEN
       RETURN
    END IF

    IF g_rwt.rwt01 IS NULL THEN
       RETURN
    END IF
    
    IF g_rwt.rwt01 <> g_plant THEN
       CALL cl_err('','art-708',0)
       RETURN
    END IF

    LET l_n = 0
    SELECT COUNT(*) INTO l_n FROM rwu_file WHERE rwu01 = g_rwt.rwt01 AND rwu02 = g_rwt.rwt02
    IF l_n = 0 THEN
       CALL cl_getmsg('art-707',g_lang) RETURNING g_msg
       LET INT_FLAG = 0
       LET g_chs = NULL
       PROMPT g_msg CLIPPED,': ' FOR g_chs
          ON IDLE g_idle_seconds
             CALL cl_on_idle()

          ON ACTION about
             CALL cl_about()
   
          ON ACTION help
             CALL cl_show_help()

          ON ACTION controlg
             CALL cl_cmdask()
       END PROMPT
       IF INT_FLAG OR g_chs = '1' THEN
          LET INT_FLAG = 0
       END IF
       IF g_chs = '2' THEN
          CALL i140_rwu_p1()
       END IF
       IF g_chs = '3' THEN
          CALL i140_rwu_p2()
       END IF
    END IF

    SELECT * INTO g_rwt.* FROM rwt_file
     WHERE rwu01 = g_rwt.rwt01
       AND rwu02 = g_rwt.rwt02

    CALL cl_opmsg('b')

    LET g_forupd_sql = "SELECT rwu03,'',rwu02,'',rwu201,'',rwu202,'',  ",
                       "       rwu203,'',rwu204,'',rwu205,'',rwu206,'',",
                       "       rwu207,'',rwu208,'',rwu209,'',rwu210,'',",
                       "       rwu211,'',rwu212",                       
                       "  FROM rwu_file",
                       " WHERE rwu01=? AND rwu02=? AND rwu03=? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i140_bcl2 CURSOR FROM g_forupd_sql 

    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

    INPUT ARRAY g_rwu WITHOUT DEFAULTS FROM s_rwu.*
          ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)

        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           IF g_rec_b2 != 0 THEN
              CALL fgl_set_arr_curr(l_ac2)
           END IF

        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac2 = ARR_CURR()
           LET l_lock_sw = 'N' 
           LET l_n  = ARR_COUNT()

        BEGIN WORK

           OPEN i140_cl USING g_rwt.rwt01,g_rwt.rwt02
           IF STATUS THEN
              CALL cl_err("OPEN i140_cl:", STATUS, 1)
              CLOSE i140_cl
              ROLLBACK WORK
              RETURN
           END IF

           FETCH i140_cl INTO g_rwt.* 
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_rwt.rwt01,SQLCA.sqlcode,0)
              CLOSE i140_cl
              ROLLBACK WORK
              RETURN
           END IF

           IF g_rec_b2 >= l_ac2 THEN
              LET p_cmd='u'
              LET g_rwu_t.* = g_rwu[l_ac2].*
              OPEN i140_bcl2 USING g_rwt.rwt01,g_rwu_t.rwu02,g_rwu_t.rwu03
              IF STATUS THEN
                 CALL cl_err("OPEN i140_bcl2:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i140_bcl2 INTO g_rwu[l_ac2].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_rwu_t.rwu03,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 SELECT gen02 INTO g_rwu[l_ac2].gen02 FROM gen_file
                  WHERE gen01 = g_rwu[l_ac2].rwu03
                   AND genacti = 'Y'
                 CALL i140_fill_b2(l_ac2)
              END IF
              CALL cl_show_fld_cont()     
           END IF

        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_rwu[l_ac2].* TO NULL 
           LET g_rwu[l_ac2].rwu02 = g_rwt.rwt02
           LET g_rwu_t.* = g_rwu[l_ac2].* 
           CALL cl_show_fld_cont()   
           NEXT FIELD rwu03

        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO rwu_file(rwu01,rwu02,rwu03,rwu201,rwu202,rwu203,
                                rwu204,rwu205,rwu206,rwu207,rwu208,rwu209,
                                rwu210,rwu211,rwu212)
           VALUES(g_rwt.rwt01,g_rwu[l_ac2].rwu02,g_rwu[l_ac2].rwu03,
                  g_rwu[l_ac2].rwu201,g_rwu[l_ac2].rwu202,
                  g_rwu[l_ac2].rwu203,g_rwu[l_ac2].rwu204,
                  g_rwu[l_ac2].rwu205,g_rwu[l_ac2].rwu206,
                  g_rwu[l_ac2].rwu207,g_rwu[l_ac2].rwu208,
                  g_rwu[l_ac2].rwu209,g_rwu[l_ac2].rwu210,
                  g_rwu[l_ac2].rwu211,g_rwu[l_ac2].rwu212)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","rwu_file",g_rwu[l_ac2].rwu02,
                           g_rwu[l_ac2].rwu03,SQLCA.sqlcode,"","",1)
              CANCEL INSERT
           ELSE
              COMMIT WORK
              LET g_rec_b2=g_rec_b2+1
              DISPLAY g_rec_b2 TO FORMONLY.cn2
           END IF

        BEFORE FIELD rwu03
           IF p_cmd = 'u' THEN
              CALL cl_set_comp_entry("rwu03",FALSE)
           END IF 
           IF p_cmd = 'a' THEN
              CALL cl_set_comp_entry("rwu03",TRUE)
           END IF

        AFTER FIELD rwu03  
           IF NOT cl_null(g_rwu[l_ac2].rwu03) THEN
              IF p_cmd = "a" OR
                 (p_cmd = "u" AND g_rwu[l_ac2].rwu03 <> g_rwu_t.rwu03) THEN
                 LET l_n = 0 
                 SELECT COUNT(*) INTO l_n FROM gen_file 
                  WHERE gen01 = g_rwu[l_ac2].rwu03 AND genacti = 'Y'
                 IF l_n = 0 THEN
                    CALL cl_err('','aap-038',0)
                    NEXT FIELD rwu03
                 END IF
                 LET l_n = 0 
                 SELECT COUNT(*) INTO l_n FROM rwu_file 
                  WHERE rwu01 = g_rwt.rwt01 
                    AND rwu02 = g_rwt.rwt02 AND rwu03 = g_rwu[l_ac2].rwu03
                 IF l_n > 0 THEN
                    CALL cl_err('','-239',0)
                    NEXT FIELD rwu03
                 END IF
                 LET l_n = 0
                 SELECT COUNT(*) INTO l_n FROM gen_file 
                  WHERE gen01 IN (SELECT gen01 FROM gen_file 
                                   WHERE gen07 = g_rwt.rwt01 
                                     AND genacti = 'Y')
                    AND gen01 = g_rwu[l_ac2].rwu03
                 IF l_n = 0 THEN
                    #---只允許設定當前營運中心下的員工銷售目標---#
                    CALL cl_err('','art-696',0)
                    NEXT FIELD rwu03
                 END IF
                 SELECT gen02 INTO g_rwu[l_ac2].gen02 FROM gen_file 
                  WHERE gen01 = g_rwu[l_ac2].rwu03 
                    AND genacti = 'Y' AND gen07 = g_rwt.rwt01
                 DISPLAY BY NAME g_rwu[l_ac2].gen02
              END IF
           END IF

        AFTER FIELD rwu201_desc 
           IF NOT cl_null(g_rwu[l_ac2].rwu201_desc) THEN
              IF p_cmd = "a" OR
               (p_cmd = "u" AND g_rwu[l_ac2].rwu201_desc <> g_rwu_t.rwu201_desc) THEN
                 IF g_rwu[l_ac2].rwu201_desc < 0 OR g_rwu[l_ac2].rwu201_desc > 100 THEN
                    CALL cl_err('','apc-133',0)
                    NEXT FIELD rwu201_desc
                 END IF
                 LET g_rwu[l_ac2].rwu201 = cl_digcut(g_rwu[l_ac2].rwu201_desc*g_rwt.rwt201/100,g_azi04)
                 DISPLAY BY NAME g_rwu[l_ac2].rwu201_desc
                 LET l_sum_rwu = 0
                 SELECT COALESCE(SUM(rwu201),0) INTO l_sum_rwu FROM rwu_file WHERE rwu01 = g_rwt.rwt01
                    AND rwu02 = g_rwt.rwt02
                    AND rwu03 <> g_rwu[l_ac2].rwu03
                 LET l_sum_rwu = l_sum_rwu + g_rwu[l_ac2].rwu201
                 IF l_sum_rwu > g_rwt.rwt201 THEN
                    IF i140_sure(0,0) THEN
                       LET l_sum_rwu = 0
                       SELECT COALESCE(SUM(rwu201),0) INTO l_sum_rwu FROM rwu_file
                        WHERE rwu01 = g_rwt.rwt01 AND rwu03 <> g_rwu[l_ac2].rwu03
                          AND rwu02 = g_rwt.rwt02
                       LET g_rwu[l_ac2].rwu201 = g_rwt.rwt201 - l_sum_rwu
                       LET g_replace = g_rwu[l_ac2].rwu201/g_rwt.rwt201*100
                       LET g_rwu[l_ac2].rwu201_desc = cl_digcut(g_replace,0)
                       DISPLAY BY NAME g_rwu[l_ac2].rwu201,g_rwu[l_ac2].rwu201_desc
                       NEXT FIELD rwu201
                    ELSE
                       NEXT FIELD rwu201_desc
                    END IF
                 END IF
              END IF
           END IF

        AFTER FIELD rwu201
           IF NOT cl_null(g_rwu[l_ac2].rwu201) THEN
              IF g_rwu[l_ac2].rwu201 < 0 THEN
                 CALL cl_err('','alm-342',0)
                 NEXT FIELD rwu201
              END IF
              LET l_sum_rwu = 0
              SELECT COALESCE(SUM(rwu201),0) INTO l_sum_rwu FROM rwu_file WHERE rwu01 = g_rwt.rwt01
                 AND rwu02 = g_rwt.rwt02
                 AND rwu03 <> g_rwu[l_ac2].rwu03
              LET l_sum_rwu = l_sum_rwu + g_rwu[l_ac2].rwu201
              IF l_sum_rwu > g_rwt.rwt201 THEN
                 IF i140_sure(0,0) THEN
                    LET l_sum_rwu = 0
                    SELECT COALESCE(SUM(rwu201),0) INTO l_sum_rwu FROM rwu_file
                     WHERE rwu01 = g_rwt.rwt01 AND rwu03 <> g_rwu[l_ac2].rwu03
                       AND rwu02 = g_rwt.rwt02
                    LET g_rwu[l_ac2].rwu201 = g_rwt.rwt201 - l_sum_rwu
                    LET g_replace = g_rwu[l_ac2].rwu201/g_rwt.rwt201*100
                    LET g_rwu[l_ac2].rwu201_desc = cl_digcut(g_replace,0)
                    DISPLAY BY NAME g_rwu[l_ac2].rwu201,g_rwu[l_ac2].rwu201_desc
                    NEXT FIELD rwu201
                 ELSE
                    NEXT FIELD rwu201
                 END IF
              END IF
              LET g_replace = g_rwu[l_ac2].rwu201/g_rwt.rwt201*100
              LET g_rwu[l_ac2].rwu201_desc = cl_digcut(g_replace,0)
              DISPLAY BY NAME g_rwu[l_ac2].rwu201_desc
           END IF

        AFTER FIELD rwu202_desc 
           IF NOT cl_null(g_rwu[l_ac2].rwu202_desc) THEN
              IF p_cmd = "a" OR
               (p_cmd = "u" AND g_rwu[l_ac2].rwu202_desc <> g_rwu_t.rwu202_desc) THEN
                 IF g_rwu[l_ac2].rwu202_desc < 0 OR g_rwu[l_ac2].rwu202_desc > 100 THEN
                    CALL cl_err('','apc-133',0)
                    NEXT FIELD rwu202_desc
                 END IF
                 LET g_rwu[l_ac2].rwu202 = cl_digcut(g_rwu[l_ac2].rwu202_desc*g_rwt.rwt202/100,g_azi04)
                 DISPLAY BY NAME g_rwu[l_ac2].rwu202_desc
                 LET l_sum_rwu = 0              
                 SELECT COALESCE(SUM(rwu202),0) INTO l_sum_rwu FROM rwu_file WHERE rwu01 = g_rwt.rwt01
                    AND rwu02 = g_rwt.rwt02
                    AND rwu03 <> g_rwu[l_ac2].rwu03
                 LET l_sum_rwu = l_sum_rwu + g_rwu[l_ac2].rwu202
                 IF l_sum_rwu > g_rwt.rwt202 THEN
                    IF i140_sure(0,0) THEN
                       LET l_sum_rwu = 0
                       SELECT COALESCE(SUM(rwu202),0) INTO l_sum_rwu FROM rwu_file
                        WHERE rwu01 = g_rwt.rwt01 AND rwu03 <> g_rwu[l_ac2].rwu03
                          AND rwu02 = g_rwt.rwt02
                       LET g_rwu[l_ac2].rwu202 = g_rwt.rwt202 - l_sum_rwu
                       LET g_replace = g_rwu[l_ac2].rwu202/g_rwt.rwt202*100
                       LET g_rwu[l_ac2].rwu202_desc = cl_digcut(g_replace,0)
                       DISPLAY BY NAME g_rwu[l_ac2].rwu202,g_rwu[l_ac2].rwu202_desc
                       NEXT FIELD rwu202
                    ELSE
                       NEXT FIELD rwu202_desc
                    END IF
                 END IF
              END IF
           END IF

        AFTER FIELD rwu202
           IF NOT cl_null(g_rwu[l_ac2].rwu202) THEN
              IF g_rwu[l_ac2].rwu202 < 0 THEN
                 CALL cl_err('','alm-342',0)
                 NEXT FIELD rwu202
              END IF
              LET l_sum_rwu = 0
              SELECT COALESCE(SUM(rwu202),0) INTO l_sum_rwu FROM rwu_file WHERE rwu01 = g_rwt.rwt01
                 AND rwu02 = g_rwt.rwt02
                 AND rwu03 <> g_rwu[l_ac2].rwu03
              LET l_sum_rwu = l_sum_rwu + g_rwu[l_ac2].rwu202
              IF l_sum_rwu > g_rwt.rwt202 THEN
                 IF i140_sure(0,0) THEN
                    LET l_sum_rwu = 0
                    SELECT COALESCE(SUM(rwu202),0) INTO l_sum_rwu FROM rwu_file
                     WHERE rwu01 = g_rwt.rwt01 AND rwu03 <> g_rwu[l_ac2].rwu03
                       AND rwu02 = g_rwt.rwt02
                    LET g_rwu[l_ac2].rwu202 = g_rwt.rwt202 - l_sum_rwu
                    LET g_replace = g_rwu[l_ac2].rwu202/g_rwt.rwt202*100
                    LET g_rwu[l_ac2].rwu202_desc = cl_digcut(g_replace,0)
                    DISPLAY BY NAME g_rwu[l_ac2].rwu202,g_rwu[l_ac2].rwu202_desc
                    NEXT FIELD rwu202
                 ELSE
                    NEXT FIELD rwu202
                 END IF
              END IF
              LET g_replace = g_rwu[l_ac2].rwu202/g_rwt.rwt202*100
              LET g_rwu[l_ac2].rwu202_desc = cl_digcut(g_replace,0)
              DISPLAY BY NAME g_rwu[l_ac2].rwu202_desc
           END IF

        AFTER FIELD rwu203_desc 
           IF NOT cl_null(g_rwu[l_ac2].rwu203_desc) THEN
              IF p_cmd = "a" OR
               (p_cmd = "u" AND g_rwu[l_ac2].rwu203_desc <> g_rwu_t.rwu203_desc) THEN
                 IF g_rwu[l_ac2].rwu203_desc < 0 OR g_rwu[l_ac2].rwu203_desc > 100 THEN
                   CALL cl_err('','apc-133',0)
                    NEXT FIELD rwu203_desc
                 END IF
                 LET g_rwu[l_ac2].rwu203 = cl_digcut(g_rwu[l_ac2].rwu203_desc*g_rwt.rwt203/100,g_azi04)
                 DISPLAY BY NAME g_rwu[l_ac2].rwu203_desc
                 LET l_sum_rwu = 0              
                 SELECT COALESCE(SUM(rwu203),0) INTO l_sum_rwu FROM rwu_file WHERE rwu01 = g_rwt.rwt01
                    AND rwu02 = g_rwt.rwt02
                    AND rwu03 <> g_rwu[l_ac2].rwu03
                 LET l_sum_rwu = l_sum_rwu + g_rwu[l_ac2].rwu203
                 IF l_sum_rwu > g_rwt.rwt203 THEN
                    IF i140_sure(0,0) THEN
                       LET l_sum_rwu = 0
                       SELECT COALESCE(SUM(rwu203),0) INTO l_sum_rwu FROM rwu_file
                        WHERE rwu01 = g_rwt.rwt01 AND rwu03 <> g_rwu[l_ac2].rwu03
                          AND rwu02 = g_rwt.rwt02
                       LET g_rwu[l_ac2].rwu203 = g_rwt.rwt203 - l_sum_rwu
                       LET g_replace = g_rwu[l_ac2].rwu203/g_rwt.rwt203*100
                       LET g_rwu[l_ac2].rwu203_desc = cl_digcut(g_replace,0)
                       DISPLAY BY NAME g_rwu[l_ac2].rwu203,g_rwu[l_ac2].rwu203_desc
                       NEXT FIELD rwu203
                    ELSE
                       NEXT FIELD rwu203_desc
                    END IF
                 END IF
              END IF
           END IF

        AFTER FIELD rwu203
           IF NOT cl_null(g_rwu[l_ac2].rwu203) THEN
              IF g_rwu[l_ac2].rwu203 < 0 THEN
                 CALL cl_err('','alm-342',0)
                 NEXT FIELD rwu203
              END IF
              LET l_sum_rwu = 0
              SELECT COALESCE(SUM(rwu203),0) INTO l_sum_rwu FROM rwu_file WHERE rwu01 = g_rwt.rwt01
                 AND rwu02 = g_rwt.rwt02
                 AND rwu03 <> g_rwu[l_ac2].rwu03
              LET l_sum_rwu = l_sum_rwu + g_rwu[l_ac2].rwu203
              IF l_sum_rwu > g_rwt.rwt203 THEN
                 IF i140_sure(0,0) THEN
                    LET l_sum_rwu = 0
                    SELECT COALESCE(SUM(rwu203),0) INTO l_sum_rwu FROM rwu_file
                     WHERE rwu01 = g_rwt.rwt01 AND rwu03 <> g_rwu[l_ac2].rwu03
                       AND rwu02 = g_rwt.rwt02
                    LET g_rwu[l_ac2].rwu203 = g_rwt.rwt203 - l_sum_rwu
                    LET g_replace = g_rwu[l_ac2].rwu203/g_rwt.rwt203*100
                    LET g_rwu[l_ac2].rwu203_desc = cl_digcut(g_replace,0)
                    DISPLAY BY NAME g_rwu[l_ac2].rwu203,g_rwu[l_ac2].rwu203_desc
                    NEXT FIELD rwu203
                 ELSE
                    NEXT FIELD rwu203
                 END IF
              END IF
              LET g_replace = g_rwu[l_ac2].rwu203/g_rwt.rwt203*100
              LET g_rwu[l_ac2].rwu203_desc = cl_digcut(g_replace,0)
              DISPLAY BY NAME g_rwu[l_ac2].rwu203_desc
           END IF

        AFTER FIELD rwu204_desc 
           IF NOT cl_null(g_rwu[l_ac2].rwu204_desc) THEN
              IF p_cmd = "a" OR
               (p_cmd = "u" AND g_rwu[l_ac2].rwu204_desc <> g_rwu_t.rwu204_desc) THEN
                 IF g_rwu[l_ac2].rwu204_desc < 0 OR g_rwu[l_ac2].rwu204_desc > 100 THEN
                    CALL cl_err('','apc-133',0)
                    NEXT FIELD rwu204_desc
                 END IF
                 LET g_rwu[l_ac2].rwu204 = cl_digcut(g_rwu[l_ac2].rwu204_desc*g_rwt.rwt204/100,g_azi04)
                 DISPLAY BY NAME g_rwu[l_ac2].rwu204_desc
                 LET l_sum_rwu = 0              
                 SELECT COALESCE(SUM(rwu204),0) INTO l_sum_rwu FROM rwu_file WHERE rwu01 = g_rwt.rwt01
                    AND rwu02 = g_rwt.rwt02
                    AND rwu03 <> g_rwu[l_ac2].rwu03
                 LET l_sum_rwu = l_sum_rwu + g_rwu[l_ac2].rwu204
                 IF l_sum_rwu > g_rwt.rwt204 THEN
                    IF i140_sure(0,0) THEN
                       LET l_sum_rwu = 0
                       SELECT COALESCE(SUM(rwu204),0) INTO l_sum_rwu FROM rwu_file
                        WHERE rwu01 = g_rwt.rwt01 AND rwu03 <> g_rwu[l_ac2].rwu03
                          AND rwu02 = g_rwt.rwt02
                       LET g_rwu[l_ac2].rwu204 = g_rwt.rwt204 - l_sum_rwu
                       LET g_replace = g_rwu[l_ac2].rwu204/g_rwt.rwt204*100
                       LET g_rwu[l_ac2].rwu204_desc = cl_digcut(g_replace,0)
                       DISPLAY BY NAME g_rwu[l_ac2].rwu204,g_rwu[l_ac2].rwu204_desc
                       NEXT FIELD rwu204
                    ELSE
                       NEXT FIELD rwu204_desc
                    END IF
                 END IF
              END IF
           END IF

        AFTER FIELD rwu204
           IF NOT cl_null(g_rwu[l_ac2].rwu204) THEN
              IF g_rwu[l_ac2].rwu204 < 0 THEN
                 CALL cl_err('','alm-342',0)
                 NEXT FIELD rwu204
              END IF
              LET l_sum_rwu = 0
              SELECT COALESCE(SUM(rwu204),0) INTO l_sum_rwu FROM rwu_file WHERE rwu01 = g_rwt.rwt01
                 AND rwu02 = g_rwt.rwt02
                 AND rwu03 <> g_rwu[l_ac2].rwu03
              LET l_sum_rwu = l_sum_rwu + g_rwu[l_ac2].rwu204
              IF l_sum_rwu > g_rwt.rwt204 THEN
                 IF i140_sure(0,0) THEN
                    LET l_sum_rwu = 0
                    SELECT COALESCE(SUM(rwu204),0) INTO l_sum_rwu FROM rwu_file
                     WHERE rwu01 = g_rwt.rwt01 AND rwu03 <> g_rwu[l_ac2].rwu03
                       AND rwu02 = g_rwt.rwt02
                    LET g_rwu[l_ac2].rwu204 = g_rwt.rwt204 - l_sum_rwu
                    LET g_replace = g_rwu[l_ac2].rwu204/g_rwt.rwt204*100
                    LET g_rwu[l_ac2].rwu204_desc = cl_digcut(g_replace,0)
                    DISPLAY BY NAME g_rwu[l_ac2].rwu204,g_rwu[l_ac2].rwu204_desc
                    NEXT FIELD rwu204
                 ELSE
                    NEXT FIELD rwu204
                 END IF
              END IF
              LET g_replace = g_rwu[l_ac2].rwu204/g_rwt.rwt204*100
              LET g_rwu[l_ac2].rwu204_desc = cl_digcut(g_replace,0)
              DISPLAY BY NAME g_rwu[l_ac2].rwu204_desc
           END IF

        AFTER FIELD rwu205_desc 
           IF NOT cl_null(g_rwu[l_ac2].rwu205_desc) THEN
              IF p_cmd = "a" OR
               (p_cmd = "u" AND g_rwu[l_ac2].rwu205_desc <> g_rwu_t.rwu205_desc) THEN
                 IF g_rwu[l_ac2].rwu205_desc < 0 OR g_rwu[l_ac2].rwu205_desc > 100 THEN
                    CALL cl_err('','apc-133',0)
                    NEXT FIELD rwu205_desc
                 END IF
                 LET g_rwu[l_ac2].rwu205 = cl_digcut(g_rwu[l_ac2].rwu205_desc*g_rwt.rwt205/100,g_azi04)
                 DISPLAY BY NAME g_rwu[l_ac2].rwu205_desc
                 LET l_sum_rwu = 0              
                 SELECT COALESCE(SUM(rwu205),0) INTO l_sum_rwu FROM rwu_file WHERE rwu01 = g_rwt.rwt01
                    AND rwu02 = g_rwt.rwt02
                    AND rwu03 <> g_rwu[l_ac2].rwu03
                 LET l_sum_rwu = l_sum_rwu + g_rwu[l_ac2].rwu205
                 IF l_sum_rwu > g_rwt.rwt205 THEN
                    IF i140_sure(0,0) THEN
                       LET l_sum_rwu = 0
                       SELECT COALESCE(SUM(rwu205),0) INTO l_sum_rwu FROM rwu_file
                        WHERE rwu01 = g_rwt.rwt01 AND rwu03 <> g_rwu[l_ac2].rwu03
                          AND rwu02 = g_rwt.rwt02
                       LET g_rwu[l_ac2].rwu205 = g_rwt.rwt205 - l_sum_rwu
                       LET g_replace = g_rwu[l_ac2].rwu205/g_rwt.rwt205*100
                       LET g_rwu[l_ac2].rwu205_desc = cl_digcut(g_replace,0)
                       DISPLAY BY NAME g_rwu[l_ac2].rwu205,g_rwu[l_ac2].rwu205_desc
                       NEXT FIELD rwu205
                    ELSE
                       NEXT FIELD rwu205_desc
                    END IF
                 END IF
              END IF
           END IF

        AFTER FIELD rwu205
           IF NOT cl_null(g_rwu[l_ac2].rwu205) THEN
              IF g_rwu[l_ac2].rwu205 < 0 THEN
                 CALL cl_err('','alm-342',0)
                 NEXT FIELD rwu205
              END IF
              LET l_sum_rwu = 0
              SELECT COALESCE(SUM(rwu205),0) INTO l_sum_rwu FROM rwu_file WHERE rwu01 = g_rwt.rwt01
                 AND rwu02 = g_rwt.rwt02
                 AND rwu03 <> g_rwu[l_ac2].rwu03
              LET l_sum_rwu = l_sum_rwu + g_rwu[l_ac2].rwu205
              IF l_sum_rwu > g_rwt.rwt205 THEN
                 IF i140_sure(0,0) THEN
                    LET l_sum_rwu = 0
                    SELECT COALESCE(SUM(rwu205),0) INTO l_sum_rwu FROM rwu_file
                     WHERE rwu01 = g_rwt.rwt01 AND rwu03 <> g_rwu[l_ac2].rwu03
                       AND rwu02 = g_rwt.rwt02
                    LET g_rwu[l_ac2].rwu205 = g_rwt.rwt205 - l_sum_rwu
                    LET g_replace = g_rwu[l_ac2].rwu205/g_rwt.rwt205*100
                    LET g_rwu[l_ac2].rwu205_desc = cl_digcut(g_replace,0)
                    DISPLAY BY NAME g_rwu[l_ac2].rwu205,g_rwu[l_ac2].rwu205_desc
                    NEXT FIELD rwu205
                 ELSE
                    NEXT FIELD rwu205
                 END IF
              END IF
              LET g_replace = g_rwu[l_ac2].rwu205/g_rwt.rwt205*100
              LET g_rwu[l_ac2].rwu205_desc = cl_digcut(g_replace,0)
              DISPLAY BY NAME g_rwu[l_ac2].rwu205_desc
           END IF

        AFTER FIELD rwu206_desc 
           IF NOT cl_null(g_rwu[l_ac2].rwu206_desc) THEN
              IF p_cmd = "a" OR
               (p_cmd = "u" AND g_rwu[l_ac2].rwu206_desc <> g_rwu_t.rwu206_desc) THEN
                 IF g_rwu[l_ac2].rwu206_desc < 0 OR g_rwu[l_ac2].rwu206_desc > 100 THEN
                    CALL cl_err('','apc-133',0)
                    NEXT FIELD rwu206_desc
                 END IF
                 LET g_rwu[l_ac2].rwu206 = cl_digcut(g_rwu[l_ac2].rwu206_desc*g_rwt.rwt206/100,g_azi04)
                 DISPLAY BY NAME g_rwu[l_ac2].rwu206_desc
                 LET l_sum_rwu = 0              
                 SELECT COALESCE(SUM(rwu206),0) INTO l_sum_rwu FROM rwu_file WHERE rwu01 = g_rwt.rwt01
                    AND rwu02 = g_rwt.rwt02
                    AND rwu03 <> g_rwu[l_ac2].rwu03
                 LET l_sum_rwu = l_sum_rwu + g_rwu[l_ac2].rwu206
                 IF l_sum_rwu > g_rwt.rwt206 THEN
                    IF i140_sure(0,0) THEN
                       LET l_sum_rwu = 0
                       SELECT COALESCE(SUM(rwu206),0) INTO l_sum_rwu FROM rwu_file
                        WHERE rwu01 = g_rwt.rwt01 AND rwu03 <> g_rwu[l_ac2].rwu03
                          AND rwu02 = g_rwt.rwt02
                       LET g_rwu[l_ac2].rwu206 = g_rwt.rwt206 - l_sum_rwu
                       LET g_replace = g_rwu[l_ac2].rwu206/g_rwt.rwt206*100
                       LET g_rwu[l_ac2].rwu206_desc = cl_digcut(g_replace,0)
                       DISPLAY BY NAME g_rwu[l_ac2].rwu206,g_rwu[l_ac2].rwu206_desc
                       NEXT FIELD rwu206
                    ELSE
                       NEXT FIELD rwu206_desc
                    END IF
                 END IF
              END IF
           END IF

        AFTER FIELD rwu206
           IF NOT cl_null(g_rwu[l_ac2].rwu206) THEN
              IF g_rwu[l_ac2].rwu206 < 0 THEN
                 CALL cl_err('','alm-342',0)
                 NEXT FIELD rwu206
              END IF
              LET l_sum_rwu = 0
              SELECT COALESCE(SUM(rwu206),0) INTO l_sum_rwu FROM rwu_file WHERE rwu01 = g_rwt.rwt01
                 AND rwu02 = g_rwt.rwt02
                 AND rwu03 <> g_rwu[l_ac2].rwu03
              LET l_sum_rwu = l_sum_rwu + g_rwu[l_ac2].rwu206
              IF l_sum_rwu > g_rwt.rwt206 THEN
                 IF i140_sure(0,0) THEN
                    LET l_sum_rwu = 0
                    SELECT COALESCE(SUM(rwu206),0) INTO l_sum_rwu FROM rwu_file
                     WHERE rwu01 = g_rwt.rwt01 AND rwu03 <> g_rwu[l_ac2].rwu03
                       AND rwu02 = g_rwt.rwt02
                    LET g_rwu[l_ac2].rwu206 = g_rwt.rwt206 - l_sum_rwu
                    LET g_replace = g_rwu[l_ac2].rwu206/g_rwt.rwt206*100
                    LET g_rwu[l_ac2].rwu206_desc = cl_digcut(g_replace,0)
                    DISPLAY BY NAME g_rwu[l_ac2].rwu206,g_rwu[l_ac2].rwu206_desc
                    NEXT FIELD rwu206
                 ELSE
                    NEXT FIELD rwu206
                 END IF
              END IF
              LET g_replace = g_rwu[l_ac2].rwu206/g_rwt.rwt206*100
              LET g_rwu[l_ac2].rwu206_desc = cl_digcut(g_replace,0)
              DISPLAY BY NAME g_rwu[l_ac2].rwu206_desc
           END IF

        AFTER FIELD rwu207_desc 
           IF NOT cl_null(g_rwu[l_ac2].rwu207_desc) THEN
              IF p_cmd = "a" OR
               (p_cmd = "u" AND g_rwu[l_ac2].rwu207_desc <> g_rwu_t.rwu207_desc) THEN
                 IF g_rwu[l_ac2].rwu207_desc < 0 OR g_rwu[l_ac2].rwu207_desc > 100 THEN
                    CALL cl_err('','apc-133',0)
                    NEXT FIELD rwu207_desc
                 END IF
                 LET g_rwu[l_ac2].rwu207 = cl_digcut(g_rwu[l_ac2].rwu207_desc*g_rwt.rwt207/100,g_azi04)
                 DISPLAY BY NAME g_rwu[l_ac2].rwu207_desc
                 LET l_sum_rwu = 0              
                 SELECT COALESCE(SUM(rwu207),0) INTO l_sum_rwu FROM rwu_file WHERE rwu01 = g_rwt.rwt01
                    AND rwu02 = g_rwt.rwt02
                    AND rwu03 <> g_rwu[l_ac2].rwu03
                 LET l_sum_rwu = l_sum_rwu + g_rwu[l_ac2].rwu207
                 IF l_sum_rwu > g_rwt.rwt207 THEN
                    IF i140_sure(0,0) THEN
                       LET l_sum_rwu = 0
                       SELECT COALESCE(SUM(rwu207),0) INTO l_sum_rwu FROM rwu_file
                        WHERE rwu01 = g_rwt.rwt01 AND rwu03 <> g_rwu[l_ac2].rwu03
                          AND rwu02 = g_rwt.rwt02
                       LET g_rwu[l_ac2].rwu207 = g_rwt.rwt207 - l_sum_rwu
                       LET g_replace = g_rwu[l_ac2].rwu207/g_rwt.rwt207*100
                       LET g_rwu[l_ac2].rwu207_desc = cl_digcut(g_replace,0)
                       DISPLAY BY NAME g_rwu[l_ac2].rwu207,g_rwu[l_ac2].rwu207_desc
                       NEXT FIELD rwu207
                    ELSE
                       NEXT FIELD rwu207_desc
                    END IF
                 END IF
              END IF
           END IF

        AFTER FIELD rwu207
           IF NOT cl_null(g_rwu[l_ac2].rwu207) THEN
              IF g_rwu[l_ac2].rwu207 < 0 THEN
                 CALL cl_err('','alm-342',0)
                 NEXT FIELD rwu207
              END IF
              LET l_sum_rwu = 0
              SELECT COALESCE(SUM(rwu207),0) INTO l_sum_rwu FROM rwu_file WHERE rwu01 = g_rwt.rwt01
                 AND rwu02 = g_rwt.rwt02
                 AND rwu03 <> g_rwu[l_ac2].rwu03
              LET l_sum_rwu = l_sum_rwu + g_rwu[l_ac2].rwu207
              IF l_sum_rwu > g_rwt.rwt207 THEN
                 IF i140_sure(0,0) THEN
                    LET l_sum_rwu = 0
                    SELECT COALESCE(SUM(rwu207),0) INTO l_sum_rwu FROM rwu_file
                     WHERE rwu01 = g_rwt.rwt01 AND rwu03 <> g_rwu[l_ac2].rwu03
                       AND rwu02 = g_rwt.rwt02
                    LET g_rwu[l_ac2].rwu207 = g_rwt.rwt207 - l_sum_rwu
                    LET g_replace = g_rwu[l_ac2].rwu207/g_rwt.rwt207*100
                    LET g_rwu[l_ac2].rwu207_desc = cl_digcut(g_replace,0)
                    DISPLAY BY NAME g_rwu[l_ac2].rwu207,g_rwu[l_ac2].rwu207_desc
                    NEXT FIELD rwu207
                 ELSE
                    NEXT FIELD rwu207
                 END IF
              END IF
              LET g_replace = g_rwu[l_ac2].rwu207/g_rwt.rwt207*100
              LET g_rwu[l_ac2].rwu207_desc = cl_digcut(g_replace,0)
              DISPLAY BY NAME g_rwu[l_ac2].rwu207_desc
           END IF

        AFTER FIELD rwu208_desc 
           IF NOT cl_null(g_rwu[l_ac2].rwu208_desc) THEN
              IF p_cmd = "a" OR
               (p_cmd = "u" AND g_rwu[l_ac2].rwu208_desc <> g_rwu_t.rwu208_desc) THEN
                 IF g_rwu[l_ac2].rwu208_desc < 0 OR g_rwu[l_ac2].rwu208_desc > 100 THEN
                    CALL cl_err('','apc-133',0)
                    NEXT FIELD rwu208_desc
                 END IF
                 LET g_rwu[l_ac2].rwu208 = cl_digcut(g_rwu[l_ac2].rwu208_desc*g_rwt.rwt208/100,g_azi04)
                 DISPLAY BY NAME g_rwu[l_ac2].rwu208_desc
                 LET l_sum_rwu = 0              
                 SELECT COALESCE(SUM(rwu208),0) INTO l_sum_rwu FROM rwu_file WHERE rwu01 = g_rwt.rwt01
                    AND rwu02 = g_rwt.rwt02
                    AND rwu03 <> g_rwu[l_ac2].rwu03
                 LET l_sum_rwu = l_sum_rwu + g_rwu[l_ac2].rwu208
                 IF l_sum_rwu > g_rwt.rwt208 THEN
                    IF i140_sure(0,0) THEN
                       LET l_sum_rwu = 0
                       SELECT COALESCE(SUM(rwu208),0) INTO l_sum_rwu FROM rwu_file
                        WHERE rwu01 = g_rwt.rwt01 AND rwu03 <> g_rwu[l_ac2].rwu03
                          AND rwu02 = g_rwt.rwt02
                       LET g_rwu[l_ac2].rwu208 = g_rwt.rwt208 - l_sum_rwu
                       LET g_replace = g_rwu[l_ac2].rwu208/g_rwt.rwt208*100
                       LET g_rwu[l_ac2].rwu208_desc = cl_digcut(g_replace,0)
                       DISPLAY BY NAME g_rwu[l_ac2].rwu208,g_rwu[l_ac2].rwu208_desc
                       NEXT FIELD rwu208
                    ELSE
                       NEXT FIELD rwu208_desc
                    END IF
                 END IF
              END IF
           END IF

        AFTER FIELD rwu208
           IF NOT cl_null(g_rwu[l_ac2].rwu208) THEN
              IF g_rwu[l_ac2].rwu208 < 0 THEN
                 CALL cl_err('','alm-342',0)
                 NEXT FIELD rwu208
              END IF
              LET l_sum_rwu = 0
              SELECT COALESCE(SUM(rwu208),0) INTO l_sum_rwu FROM rwu_file WHERE rwu01 = g_rwt.rwt01
                 AND rwu02 = g_rwt.rwt02
                 AND rwu03 <> g_rwu[l_ac2].rwu03
              LET l_sum_rwu = l_sum_rwu + g_rwu[l_ac2].rwu208
              IF l_sum_rwu > g_rwt.rwt208 THEN
                 IF i140_sure(0,0) THEN
                    LET l_sum_rwu = 0
                    SELECT COALESCE(SUM(rwu208),0) INTO l_sum_rwu FROM rwu_file
                     WHERE rwu01 = g_rwt.rwt01 AND rwu03 <> g_rwu[l_ac2].rwu03
                       AND rwu02 = g_rwt.rwt02
                    LET g_rwu[l_ac2].rwu208 = g_rwt.rwt208 - l_sum_rwu
                    LET g_replace = g_rwu[l_ac2].rwu208/g_rwt.rwt208*100
                    LET g_rwu[l_ac2].rwu208_desc = cl_digcut(g_replace,0)
                    DISPLAY BY NAME g_rwu[l_ac2].rwu208,g_rwu[l_ac2].rwu208_desc
                    NEXT FIELD rwu208
                 ELSE
                    NEXT FIELD rwu208
                 END IF
              END IF
              LET g_replace = g_rwu[l_ac2].rwu208/g_rwt.rwt208*100
              LET g_rwu[l_ac2].rwu208_desc = cl_digcut(g_replace,0)
              DISPLAY BY NAME g_rwu[l_ac2].rwu208_desc
           END IF

        AFTER FIELD rwu209_desc 
           IF NOT cl_null(g_rwu[l_ac2].rwu209_desc) THEN
              IF p_cmd = "a" OR
               (p_cmd = "u" AND g_rwu[l_ac2].rwu209_desc <> g_rwu_t.rwu209_desc) THEN
                 IF g_rwu[l_ac2].rwu209_desc < 0 OR g_rwu[l_ac2].rwu209_desc > 100 THEN
                    CALL cl_err('','apc-133',0)
                    NEXT FIELD rwu209_desc
                 END IF
                 LET g_rwu[l_ac2].rwu209 = cl_digcut(g_rwu[l_ac2].rwu209_desc*g_rwt.rwt209/100,g_azi04)
                 DISPLAY BY NAME g_rwu[l_ac2].rwu209_desc
                 LET l_sum_rwu = 0              
                 SELECT COALESCE(SUM(rwu209),0) INTO l_sum_rwu FROM rwu_file WHERE rwu01 = g_rwt.rwt01
                    AND rwu02 = g_rwt.rwt02
                    AND rwu03 <> g_rwu[l_ac2].rwu03
                 LET l_sum_rwu = l_sum_rwu + g_rwu[l_ac2].rwu209
                 IF l_sum_rwu > g_rwt.rwt209 THEN
                    IF i140_sure(0,0) THEN
                       LET l_sum_rwu = 0
                       SELECT COALESCE(SUM(rwu209),0) INTO l_sum_rwu FROM rwu_file
                        WHERE rwu01 = g_rwt.rwt01 AND rwu03 <> g_rwu[l_ac2].rwu03
                          AND rwu02 = g_rwt.rwt02
                       LET g_rwu[l_ac2].rwu209 = g_rwt.rwt209 - l_sum_rwu
                       LET g_replace = g_rwu[l_ac2].rwu209/g_rwt.rwt209*100
                       LET g_rwu[l_ac2].rwu209_desc = cl_digcut(g_replace,0)
                       DISPLAY BY NAME g_rwu[l_ac2].rwu209,g_rwu[l_ac2].rwu209_desc
                       NEXT FIELD rwu209
                    ELSE
                       NEXT FIELD rwu209_desc
                    END IF
                 END IF
              END IF
           END IF

        AFTER FIELD rwu209
           IF NOT cl_null(g_rwu[l_ac2].rwu209) THEN
              IF g_rwu[l_ac2].rwu209 < 0 THEN
                 CALL cl_err('','alm-342',0)
                 NEXT FIELD rwu209
              END IF
              LET l_sum_rwu = 0
              SELECT COALESCE(SUM(rwu209),0) INTO l_sum_rwu FROM rwu_file WHERE rwu01 = g_rwt.rwt01
                 AND rwu02 = g_rwt.rwt02
                 AND rwu03 <> g_rwu[l_ac2].rwu03
              LET l_sum_rwu = l_sum_rwu + g_rwu[l_ac2].rwu209
              IF l_sum_rwu > g_rwt.rwt209 THEN
                 IF i140_sure(0,0) THEN
                    LET l_sum_rwu = 0
                    SELECT COALESCE(SUM(rwu209),0) INTO l_sum_rwu FROM rwu_file
                     WHERE rwu01 = g_rwt.rwt01 AND rwu03 <> g_rwu[l_ac2].rwu03
                       AND rwu02 = g_rwt.rwt02
                    LET g_rwu[l_ac2].rwu209 = g_rwt.rwt209 - l_sum_rwu
                    LET g_replace = g_rwu[l_ac2].rwu209/g_rwt.rwt209*100
                    LET g_rwu[l_ac2].rwu209_desc = cl_digcut(g_replace,0)
                    DISPLAY BY NAME g_rwu[l_ac2].rwu209,g_rwu[l_ac2].rwu209_desc
                    NEXT FIELD rwu209
                 ELSE
                    NEXT FIELD rwu209
                 END IF
              END IF
              LET g_replace = g_rwu[l_ac2].rwu209/g_rwt.rwt209*100
              LET g_rwu[l_ac2].rwu209_desc = cl_digcut(g_replace,0)
              DISPLAY BY NAME g_rwu[l_ac2].rwu209_desc
           END IF

        AFTER FIELD rwu210_desc 
           IF NOT cl_null(g_rwu[l_ac2].rwu210_desc) THEN
              IF p_cmd = "a" OR
               (p_cmd = "u" AND g_rwu[l_ac2].rwu210_desc <> g_rwu_t.rwu210_desc) THEN
                 IF g_rwu[l_ac2].rwu210_desc < 0 OR g_rwu[l_ac2].rwu210_desc > 100 THEN
                    CALL cl_err('','apc-133',0)
                    NEXT FIELD rwu210_desc
                 END IF
                 LET g_rwu[l_ac2].rwu210 = cl_digcut(g_rwu[l_ac2].rwu210_desc*g_rwt.rwt210/100,g_azi04)
                 DISPLAY BY NAME g_rwu[l_ac2].rwu210_desc
                 LET l_sum_rwu = 0              
                 SELECT COALESCE(SUM(rwu210),0) INTO l_sum_rwu FROM rwu_file WHERE rwu01 = g_rwt.rwt01
                    AND rwu02 = g_rwt.rwt02
                    AND rwu03 <> g_rwu[l_ac2].rwu03
                 LET l_sum_rwu = l_sum_rwu + g_rwu[l_ac2].rwu210
                 IF l_sum_rwu > g_rwt.rwt210 THEN
                    IF i140_sure(0,0) THEN
                       LET l_sum_rwu = 0
                       SELECT COALESCE(SUM(rwu210),0) INTO l_sum_rwu FROM rwu_file
                        WHERE rwu01 = g_rwt.rwt01 AND rwu03 <> g_rwu[l_ac2].rwu03
                          AND rwu02 = g_rwt.rwt02
                       LET g_rwu[l_ac2].rwu210 = g_rwt.rwt210 - l_sum_rwu
                       LET g_replace = g_rwu[l_ac2].rwu210/g_rwt.rwt210*100
                       LET g_rwu[l_ac2].rwu210_desc = cl_digcut(g_replace,0)
                       DISPLAY BY NAME g_rwu[l_ac2].rwu210,g_rwu[l_ac2].rwu210_desc
                       NEXT FIELD rwu210
                    ELSE
                       NEXT FIELD rwu210_desc
                    END IF
                 END IF
              END IF
           END IF

        AFTER FIELD rwu210
           IF NOT cl_null(g_rwu[l_ac2].rwu210) THEN
              IF g_rwu[l_ac2].rwu210 < 0 THEN
                 CALL cl_err('','alm-342',0)
                 NEXT FIELD rwu210
              END IF
              LET l_sum_rwu = 0
              SELECT COALESCE(SUM(rwu210),0) INTO l_sum_rwu FROM rwu_file WHERE rwu01 = g_rwt.rwt01
                 AND rwu02 = g_rwt.rwt02
                 AND rwu03 <> g_rwu[l_ac2].rwu03
              LET l_sum_rwu = l_sum_rwu + g_rwu[l_ac2].rwu210
              IF l_sum_rwu > g_rwt.rwt210 THEN
                 IF i140_sure(0,0) THEN
                    LET l_sum_rwu = 0
                    SELECT COALESCE(SUM(rwu210),0) INTO l_sum_rwu FROM rwu_file
                     WHERE rwu01 = g_rwt.rwt01 AND rwu03 <> g_rwu[l_ac2].rwu03
                       AND rwu02 = g_rwt.rwt02
                    LET g_rwu[l_ac2].rwu210 = g_rwt.rwt210 - l_sum_rwu
                    LET g_replace = g_rwu[l_ac2].rwu210/g_rwt.rwt210*100
                    LET g_rwu[l_ac2].rwu210_desc = cl_digcut(g_replace,0)
                    DISPLAY BY NAME g_rwu[l_ac2].rwu210,g_rwu[l_ac2].rwu210_desc
                    NEXT FIELD rwu210
                 ELSE
                    NEXT FIELD rwu210
                 END IF
              END IF
              LET g_replace = g_rwu[l_ac2].rwu210/g_rwt.rwt210*100
              LET g_rwu[l_ac2].rwu210_desc = cl_digcut(g_replace,0)
              DISPLAY BY NAME g_rwu[l_ac2].rwu210_desc
           END IF

        AFTER FIELD rwu211_desc 
           IF NOT cl_null(g_rwu[l_ac2].rwu211_desc) THEN
              IF p_cmd = "a" OR
               (p_cmd = "u" AND g_rwu[l_ac2].rwu211_desc <> g_rwu_t.rwu211_desc) THEN
                 IF g_rwu[l_ac2].rwu211_desc < 0 OR g_rwu[l_ac2].rwu211_desc > 100 THEN
                    CALL cl_err('','apc-133',0)
                    NEXT FIELD rwu211_desc
                 END IF
                 LET g_rwu[l_ac2].rwu211 = cl_digcut(g_rwu[l_ac2].rwu211_desc*g_rwt.rwt211/100,g_azi04)
                 DISPLAY BY NAME g_rwu[l_ac2].rwu211_desc
                 LET l_sum_rwu = 0              
                 SELECT COALESCE(SUM(rwu211),0) INTO l_sum_rwu FROM rwu_file WHERE rwu01 = g_rwt.rwt01
                    AND rwu02 = g_rwt.rwt02
                    AND rwu03 <> g_rwu[l_ac2].rwu03
                 LET l_sum_rwu = l_sum_rwu + g_rwu[l_ac2].rwu211
                 IF l_sum_rwu > g_rwt.rwt211 THEN
                    IF i140_sure(0,0) THEN
                       LET l_sum_rwu = 0
                       SELECT COALESCE(SUM(rwu211),0) INTO l_sum_rwu FROM rwu_file
                        WHERE rwu01 = g_rwt.rwt01 AND rwu03 <> g_rwu[l_ac2].rwu03
                          AND rwu02 = g_rwt.rwt02
                       LET g_rwu[l_ac2].rwu211 = g_rwt.rwt211 - l_sum_rwu
                       LET g_replace = g_rwu[l_ac2].rwu211/g_rwt.rwt211*100
                       LET g_rwu[l_ac2].rwu211_desc = cl_digcut(g_replace,0)
                       DISPLAY BY NAME g_rwu[l_ac2].rwu211,g_rwu[l_ac2].rwu211_desc
                       NEXT FIELD rwu211
                    ELSE
                       NEXT FIELD rwu211_desc
                    END IF
                 END IF
              END IF
           END IF

        AFTER FIELD rwu211
           IF NOT cl_null(g_rwu[l_ac2].rwu211) THEN
              IF g_rwu[l_ac2].rwu211 < 0 THEN
                 CALL cl_err('','alm-342',0)
                 NEXT FIELD rwu211
              END IF
              LET l_sum_rwu = 0
              SELECT COALESCE(SUM(rwu211),0) INTO l_sum_rwu FROM rwu_file WHERE rwu01 = g_rwt.rwt01
                 AND rwu02 = g_rwt.rwt02
                 AND rwu03 <> g_rwu[l_ac2].rwu03
              LET l_sum_rwu = l_sum_rwu + g_rwu[l_ac2].rwu211
              IF l_sum_rwu > g_rwt.rwt211 THEN
                 IF i140_sure(0,0) THEN
                    LET l_sum_rwu = 0
                    SELECT COALESCE(SUM(rwu211),0) INTO l_sum_rwu FROM rwu_file
                     WHERE rwu01 = g_rwt.rwt01 AND rwu03 <> g_rwu[l_ac2].rwu03
                       AND rwu02 = g_rwt.rwt02
                    LET g_rwu[l_ac2].rwu211 = g_rwt.rwt211 - l_sum_rwu
                    LET g_replace = g_rwu[l_ac2].rwu211/g_rwt.rwt211*100
                    LET g_rwu[l_ac2].rwu211_desc = cl_digcut(g_replace,0)
                    DISPLAY BY NAME g_rwu[l_ac2].rwu211,g_rwu[l_ac2].rwu211_desc
                    NEXT FIELD rwu211
                 ELSE
                    NEXT FIELD rwu211
                 END IF
              END IF
              LET g_replace = g_rwu[l_ac2].rwu211/g_rwt.rwt211*100
              LET g_rwu[l_ac2].rwu211_desc = cl_digcut(g_replace,0)
              DISPLAY BY NAME g_rwu[l_ac2].rwu211_desc
           END IF

        AFTER FIELD rwu212_desc 
           IF NOT cl_null(g_rwu[l_ac2].rwu212_desc) THEN
              IF p_cmd = "a" OR
               (p_cmd = "u" AND g_rwu[l_ac2].rwu212_desc <> g_rwu_t.rwu212_desc) THEN
                 IF g_rwu[l_ac2].rwu212_desc < 0 OR g_rwu[l_ac2].rwu212_desc > 100 THEN
                    CALL cl_err('','apc-133',0)
                    NEXT FIELD rwu212_desc
                 END IF
                 LET g_rwu[l_ac2].rwu212 = cl_digcut(g_rwu[l_ac2].rwu212_desc*g_rwt.rwt212/100,g_azi04)
                 DISPLAY BY NAME g_rwu[l_ac2].rwu212_desc
                 LET l_sum_rwu = 0              
                 SELECT COALESCE(SUM(rwu212),0) INTO l_sum_rwu FROM rwu_file WHERE rwu01 = g_rwt.rwt01
                    AND rwu02 = g_rwt.rwt02
                    AND rwu03 <> g_rwu[l_ac2].rwu03
                 LET l_sum_rwu = l_sum_rwu + g_rwu[l_ac2].rwu212
                 IF l_sum_rwu > g_rwt.rwt212 THEN
                    IF i140_sure(0,0) THEN
                       LET l_sum_rwu = 0
                       SELECT COALESCE(SUM(rwu212),0) INTO l_sum_rwu FROM rwu_file
                        WHERE rwu01 = g_rwt.rwt01 AND rwu03 <> g_rwu[l_ac2].rwu03
                          AND rwu02 = g_rwt.rwt02
                       LET g_rwu[l_ac2].rwu212 = g_rwt.rwt212 - l_sum_rwu
                       LET g_replace = g_rwu[l_ac2].rwu212/g_rwt.rwt212*100
                       LET g_rwu[l_ac2].rwu212_desc = cl_digcut(g_replace,0)
                       DISPLAY BY NAME g_rwu[l_ac2].rwu212,g_rwu[l_ac2].rwu212_desc
                       NEXT FIELD rwu212
                    ELSE
                       NEXT FIELD rwu212_desc
                    END IF
                 END IF
              END IF
           END IF

        AFTER FIELD rwu212
           IF NOT cl_null(g_rwu[l_ac2].rwu212) THEN
              IF g_rwu[l_ac2].rwu212 < 0 THEN
                 CALL cl_err('','alm-342',0)
                 NEXT FIELD rwu212
              END IF
              LET l_sum_rwu = 0
              SELECT COALESCE(SUM(rwu212),0) INTO l_sum_rwu FROM rwu_file WHERE rwu01 = g_rwt.rwt01
                 AND rwu02 = g_rwt.rwt02
                 AND rwu03 <> g_rwu[l_ac2].rwu03
              LET l_sum_rwu = l_sum_rwu + g_rwu[l_ac2].rwu212
              IF l_sum_rwu > g_rwt.rwt212 THEN
                 IF i140_sure(0,0) THEN
                    LET l_sum_rwu = 0
                    SELECT COALESCE(SUM(rwu212),0) INTO l_sum_rwu FROM rwu_file
                     WHERE rwu01 = g_rwt.rwt01 AND rwu03 <> g_rwu[l_ac2].rwu03
                       AND rwu02 = g_rwt.rwt02
                    LET g_rwu[l_ac2].rwu212 = g_rwt.rwt212 - l_sum_rwu
                    LET g_replace = g_rwu[l_ac2].rwu212/g_rwt.rwt212*100
                    LET g_rwu[l_ac2].rwu212_desc = cl_digcut(g_replace,0)
                    DISPLAY BY NAME g_rwu[l_ac2].rwu212,g_rwu[l_ac2].rwu212_desc
                    NEXT FIELD rwu212
                 ELSE
                    NEXT FIELD rwu212
                 END IF
              END IF
              LET g_replace = g_rwu[l_ac2].rwu212/g_rwt.rwt212*100
              LET g_rwu[l_ac2].rwu212_desc = cl_digcut(g_replace,0)
              DISPLAY BY NAME g_rwu[l_ac2].rwu212_desc
           END IF

        BEFORE DELETE  
           DISPLAY "BEFORE DELETE"
           IF g_rwu[l_ac2].rwu03 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rwu_file
               WHERE rwu01 = g_rwt.rwt01
                 AND rwu02 = g_rwu_t.rwu02
                 AND rwu03 = g_rwu_t.rwu03
                 
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","rwu_file",g_rwu_t.rwu03,
                              g_rwu_t.rwu02,SQLCA.sqlcode,"","",1)
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b2=g_rec_b2-1
              DISPLAY g_rec_b2 TO FORMONLY.cn2
           END IF
           COMMIT WORK

        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rwu[l_ac2].* = g_rwu_t.*
              CLOSE i140_bcl2
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_rwu[l_ac2].rwu03,-263,1)
              LET g_rwu[l_ac2].* = g_rwu_t.*
           ELSE
              UPDATE rwu_file SET rwu201  = g_rwu[l_ac2].rwu201,
                                  rwu202  = g_rwu[l_ac2].rwu202,
                                  rwu203  = g_rwu[l_ac2].rwu203,
                                  rwu204  = g_rwu[l_ac2].rwu204,
                                  rwu205  = g_rwu[l_ac2].rwu205,
                                  rwu206  = g_rwu[l_ac2].rwu206,
                                  rwu207  = g_rwu[l_ac2].rwu207,
                                  rwu208  = g_rwu[l_ac2].rwu208,
                                  rwu209  = g_rwu[l_ac2].rwu209,
                                  rwu210  = g_rwu[l_ac2].rwu210,
                                  rwu211  = g_rwu[l_ac2].rwu211,
                                  rwu212  = g_rwu[l_ac2].rwu212
               WHERE rwu01 = g_rwt.rwt01
                 AND rwu02 = g_rwu_t.rwu02 
                 AND rwu03 = g_rwu_t.rwu03
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rwu_file",g_rwu_t.rwu03,
                              g_rwu_t.rwu02,SQLCA.sqlcode,"","",1)
                 LET g_rwu[l_ac2].* = g_rwu_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF

        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac2 = ARR_CURR()
          #LET l_ac_t2 = l_ac2  #FUN-D30034 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rwu[l_ac2].* = g_rwu_t.*
              #FUN-D30034--add--begin--
              ELSE
                 CALL g_rwu.deleteElement(l_ac2)
                 IF g_rec_b2 != 0 THEN
                    LET g_action_choice = "set_staff_goal"
                    LET l_ac2 = l_ac_t2
                 END IF
              #FUN-D30034--add--end----
              END IF
              CLOSE i140_bcl2
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t2 = l_ac2  #FUN-D30034 add
           CLOSE i140_bcl2
           COMMIT WORK

        AFTER INPUT
           IF INT_FLAG THEN
              EXIT INPUT
           END IF
           CALL i140_fill_head()

        ON ACTION CONTROLR
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
           CALL cl_cmdask()

        ON ACTION controlp
           CASE
             WHEN INFIELD(rwu03)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_gen"
                LET g_qryparam.where = " gen07 = '",g_rwt.rwt01,"'"
                LET g_qryparam.default1 = g_rwu[l_ac2].rwu03
                CALL cl_create_qry() RETURNING g_rwu[l_ac2].rwu03
                DISPLAY g_rwu[l_ac2].rwu03 TO rwu03
                NEXT FIELD rwu03
           END CASE

      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) 
            RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
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

    CLOSE i140_bcl2
    COMMIT WORK

END FUNCTION


FUNCTION i140_b1_fill()

   LET g_sql = "SELECT rwt01,'',rwt02,'',rwt201,'',rwt202,'',  ",
               "       rwt203,'',rwt204,'',rwt205,'',rwt206,'',",
               "       rwt207,'',rwt208,'',rwt209,'',rwt210,'',",
               "       rwt211,'',rwt212",                      
               "  FROM rwt_file",
               " WHERE rwt04 = '",g_rwt.rwt01,"' ",
               "   AND rwt02 = '",g_rwt.rwt02,"' "
               
   LET g_sql=g_sql CLIPPED," ORDER BY rwt01 "
   DISPLAY g_sql

   PREPARE i140_pb1 FROM g_sql
   DECLARE rwt_cs CURSOR FOR i140_pb1

   CALL g_rwt_b.clear()
   LET g_cnt1 = 1

   FOREACH rwt_cs INTO g_rwt_b[g_cnt1].* 
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT azw08 INTO g_rwt_b[g_cnt1].azw08_4 FROM azw_file
        WHERE azw01 = g_rwt_b[g_cnt1].rwt01_b
          AND azwacti = 'Y'
       CALL i140_fill_b1(g_cnt1)
       LET g_cnt1 = g_cnt1 + 1
       IF g_cnt1 > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_rwt_b.deleteElement(g_cnt1)
 
   LET g_rec_b1 = g_cnt1-1
   DISPLAY g_rec_b1 TO FORMONLY.cn2
   LET g_cnt1 = 0

END FUNCTION

FUNCTION i140_b2_fill()

   LET g_sql = "SELECT rwu03,'',rwu02,'',rwu201,'',rwu202,'',  ",
               "       rwu203,'',rwu204,'',rwu205,'',rwu206,'',",
               "       rwu207,'',rwu208,'',rwu209,'',rwu210,'',",
               "       rwu211,'',rwu212",                      
               "  FROM rwu_file",
               " WHERE rwu01 = '",g_rwt.rwt01,"' ",
               "   AND rwu02 = '",g_rwt.rwt02,"' "  #FUN-B50067 ADD
               
   LET g_sql=g_sql CLIPPED," ORDER BY rwu03 "
   DISPLAY g_sql

   PREPARE i140_pb2 FROM g_sql
   DECLARE rwu_cs CURSOR FOR i140_pb2

   CALL g_rwu.clear()
   LET g_cnt2 = 1

   FOREACH rwu_cs INTO g_rwu[g_cnt2].* 
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT gen02 INTO g_rwu[g_cnt2].gen02 FROM gen_file 
        WHERE gen01 = g_rwu[g_cnt2].rwu03
          AND genacti = 'Y'
       CALL i140_fill_b2(g_cnt2)
       LET g_cnt2 = g_cnt2 + 1
       IF g_cnt2 > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_rwu.deleteElement(g_cnt2)
 
   LET g_rec_b2 = g_cnt2-1
   DISPLAY g_rec_b2 TO FORMONLY.cn2
   LET g_cnt2 = 0

END FUNCTION

FUNCTION i140_bp(p_ud)
   DEFINE p_ud LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" 
      OR g_action_choice = "set_lower_level"      #FUN-D30033 add
      OR g_action_choice = "set_staff_goal"  THEN #FUN-D30033 add 
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel",FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_rwt_b TO s_rwt.* ATTRIBUTE(COUNT=g_rec_b1)

         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )

         BEFORE ROW
            LET l_ac1 = ARR_CURR()
            CALL cl_show_fld_cont()

         ON ACTION insert
            LET g_action_choice="insert"
            EXIT DIALOG

         ON ACTION query
            LET g_action_choice="query"
            EXIT DIALOG

         ON ACTION delete
            LET g_action_choice="delete"
            EXIT DIALOG

         ON ACTION modify
            LET g_action_choice="modify"
            EXIT DIALOG

         ON ACTION first
            CALL i140_fetch('F')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            CALL fgl_set_arr_curr(1)
            ACCEPT DIALOG 

         ON ACTION previous
            CALL i140_fetch('P')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            CALL fgl_set_arr_curr(1)
            ACCEPT DIALOG 

         ON ACTION jump
            CALL i140_fetch('/')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            CALL fgl_set_arr_curr(1)
            ACCEPT DIALOG 

         ON ACTION next
            CALL i140_fetch('N')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            CALL fgl_set_arr_curr(1)
            ACCEPT DIALOG 

         ON ACTION last
            CALL i140_fetch('L')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            CALL fgl_set_arr_curr(1)
            ACCEPT DIALOG

         ON ACTION set_lower_level
            LET g_action_choice="set_lower_level"
            LET l_ac1 = 1
            EXIT DIALOG
             
         ON ACTION qry_lower_level
            LET g_action_choice="qry_lower_level"
            EXIT DIALOG 

         ON ACTION set_staff_goal
            LET g_action_choice="set_staff_goal"
            LET l_ac1 = 1
            EXIT DIALOG

         ON ACTION help
            LET g_action_choice="help"
            EXIT DIALOG

         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()

         ON ACTION exit
            LET g_action_choice="exit"
            EXIT DIALOG

         ON ACTION controlg
            LET g_action_choice="controlg"
            EXIT DIALOG

         ON ACTION cancel
            LET INT_FLAG=FALSE     
            LET g_action_choice="exit"
            EXIT DIALOG

         ON ACTION close                #視窗右上角的"x"            
            LET INT_FLAG=FALSE            
            LET g_action_choice="exit"            
            EXIT DIALOG

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG
 
         ON ACTION about    
            CALL cl_about()  

         AFTER DISPLAY
            CONTINUE DIALOG


         ON ACTION controls                                    
            CALL cl_set_head_visible("","AUTO")   

      END DISPLAY

      DISPLAY ARRAY g_rwu TO s_rwu.* ATTRIBUTE(COUNT=g_rec_b2)

         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )

         BEFORE ROW
            LET l_ac2 = ARR_CURR()
            CALL cl_show_fld_cont()

         ON ACTION insert
            LET g_action_choice="insert"
            EXIT DIALOG

         ON ACTION query
            LET g_action_choice="query"
            EXIT DIALOG

         ON ACTION delete
            LET g_action_choice="delete"
            EXIT DIALOG

         ON ACTION modify
            LET g_action_choice="modify"
            EXIT DIALOG

         ON ACTION first
            CALL i140_fetch('F')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            CALL fgl_set_arr_curr(1)
            ACCEPT DIALOG 

         ON ACTION previous
            CALL i140_fetch('P')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            CALL fgl_set_arr_curr(1)
            ACCEPT DIALOG 

         ON ACTION jump
            CALL i140_fetch('/')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            CALL fgl_set_arr_curr(1)
            ACCEPT DIALOG 

         ON ACTION next
            CALL i140_fetch('N')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            CALL fgl_set_arr_curr(1)
            ACCEPT DIALOG 

         ON ACTION last
            CALL i140_fetch('L')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            CALL fgl_set_arr_curr(1)
            ACCEPT DIALOG

         ON ACTION set_lower_level
            LET g_action_choice="set_lower_level"
            LET l_ac2 = 1
            EXIT DIALOG
             
         ON ACTION qry_lower_level
            LET g_action_choice="qry_lower_level"
            EXIT DIALOG 

         ON ACTION set_staff_goal
            LET g_action_choice="set_staff_goal"
            LET l_ac2 = 1
            EXIT DIALOG

         ON ACTION help
            LET g_action_choice="help"
            EXIT DIALOG

         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()

         ON ACTION exit
            LET g_action_choice="exit"
            EXIT DIALOG

         ON ACTION controlg
            LET g_action_choice="controlg"
            EXIT DIALOG

         ON ACTION cancel
            LET INT_FLAG=FALSE     
            LET g_action_choice="exit"
            EXIT DIALOG

         ON ACTION close                #視窗右上角的"x"            
            LET INT_FLAG=FALSE            
            LET g_action_choice="exit"            
            EXIT DIALOG

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG
 
         ON ACTION about    
            CALL cl_about()  

         AFTER DISPLAY
            CONTINUE DIALOG


         ON ACTION controls                                    
            CALL cl_set_head_visible("","AUTO")   

      END DISPLAY

   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i140_set_entry(p_cmd)

  DEFINE p_cmd   LIKE type_file.chr1

    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("rwt01,rwt02",TRUE)
    END IF

END FUNCTION

FUNCTION i140_set_no_entry(p_cmd)

  DEFINE p_cmd   LIKE type_file.chr1

    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("rwt01,rwt02",FALSE)
    END IF

END FUNCTION

FUNCTION i140_fill_head()
DEFINE l_i    LIKE type_file.num5
DEFINE l_sum  LIKE rwt_file.rwt201
DEFINE l_dif  LIKE rwt_file.rwt201

   FOR l_i = 1 TO 12
      CASE l_i
         WHEN 1
            INITIALIZE l_sum,l_dif TO NULL
            IF g_azw07_n > 0 THEN
               SELECT COALESCE(SUM(rwt201),0) INTO l_sum FROM rwt_file WHERE rwt04 = g_rwt.rwt01 AND rwt02 = g_rwt.rwt02
            ELSE
               SELECT COALESCE(SUM(rwu201),0) INTO l_sum FROM rwu_file WHERE rwu01 = g_rwt.rwt01 AND rwu02 = g_rwt.rwt02
            END IF
            LET l_dif = g_rwt.rwt201 - l_sum
            DISPLAY l_dif TO FORMONLY.rwt201_1
         WHEN 2
            INITIALIZE l_sum,l_dif TO NULL
            IF g_azw07_n > 0 THEN
               SELECT COALESCE(SUM(rwt202),0) INTO l_sum FROM rwt_file WHERE rwt04 = g_rwt.rwt01 AND rwt02 = g_rwt.rwt02
            ELSE
               SELECT COALESCE(SUM(rwu202),0) INTO l_sum FROM rwu_file WHERE rwu01 = g_rwt.rwt01 AND rwu02 = g_rwt.rwt02
            END IF
            LET l_dif = g_rwt.rwt202 - l_sum
            DISPLAY l_dif TO FORMONLY.rwt202_1
         WHEN 3
            INITIALIZE l_sum,l_dif TO NULL
            IF g_azw07_n > 0 THEN
               SELECT COALESCE(SUM(rwt203),0) INTO l_sum FROM rwt_file WHERE rwt04 = g_rwt.rwt01 AND rwt02 = g_rwt.rwt02
            ELSE
               SELECT COALESCE(SUM(rwu203),0) INTO l_sum FROM rwu_file WHERE rwu01 = g_rwt.rwt01 AND rwu02 = g_rwt.rwt02
            END IF
            LET l_dif = g_rwt.rwt203 - l_sum
            DISPLAY l_dif TO FORMONLY.rwt203_1
         WHEN 4
            INITIALIZE l_sum,l_dif TO NULL
            IF g_azw07_n > 0 THEN
               SELECT COALESCE(SUM(rwt204),0) INTO l_sum FROM rwt_file WHERE rwt04 = g_rwt.rwt01 AND rwt02 = g_rwt.rwt02
            ELSE
               SELECT COALESCE(SUM(rwu204),0) INTO l_sum FROM rwu_file WHERE rwu01 = g_rwt.rwt01 AND rwu02 = g_rwt.rwt02
            END IF
            LET l_dif = g_rwt.rwt204 - l_sum
            DISPLAY l_dif TO FORMONLY.rwt204_1
         WHEN 5
            INITIALIZE l_sum,l_dif TO NULL
            IF g_azw07_n > 0 THEN
               SELECT COALESCE(SUM(rwt205),0) INTO l_sum FROM rwt_file WHERE rwt04 = g_rwt.rwt01 AND rwt02 = g_rwt.rwt02
            ELSE
               SELECT COALESCE(SUM(rwu205),0) INTO l_sum FROM rwu_file WHERE rwu01 = g_rwt.rwt01 AND rwu02 = g_rwt.rwt02
            END IF
            LET l_dif = g_rwt.rwt205 - l_sum
            DISPLAY l_dif TO FORMONLY.rwt205_1
         WHEN 6
            INITIALIZE l_sum,l_dif TO NULL
            IF g_azw07_n > 0 THEN
               SELECT COALESCE(SUM(rwt206),0) INTO l_sum FROM rwt_file WHERE rwt04 = g_rwt.rwt01 AND rwt02 = g_rwt.rwt02
            ELSE
               SELECT COALESCE(SUM(rwu206),0) INTO l_sum FROM rwu_file WHERE rwu01 = g_rwt.rwt01 AND rwu02 = g_rwt.rwt02
            END IF
            LET l_dif = g_rwt.rwt206 - l_sum
            DISPLAY l_dif TO FORMONLY.rwt206_1
         WHEN 7
            INITIALIZE l_sum,l_dif TO NULL
            IF g_azw07_n > 0 THEN
               SELECT COALESCE(SUM(rwt207),0) INTO l_sum FROM rwt_file WHERE rwt04 = g_rwt.rwt01 AND rwt02 = g_rwt.rwt02
            ELSE
               SELECT COALESCE(SUM(rwu207),0) INTO l_sum FROM rwu_file WHERE rwu01 = g_rwt.rwt01 AND rwu02 = g_rwt.rwt02
            END IF
            LET l_dif = g_rwt.rwt207 - l_sum
            DISPLAY l_dif TO FORMONLY.rwt207_1
         WHEN 8
            INITIALIZE l_sum,l_dif TO NULL
            IF g_azw07_n > 0 THEN
               SELECT COALESCE(SUM(rwt208),0) INTO l_sum FROM rwt_file WHERE rwt04 = g_rwt.rwt01 AND rwt02 = g_rwt.rwt02
            ELSE
               SELECT COALESCE(SUM(rwu208),0) INTO l_sum FROM rwu_file WHERE rwu01 = g_rwt.rwt01 AND rwu02 = g_rwt.rwt02
            END IF
            LET l_dif = g_rwt.rwt208 - l_sum
            DISPLAY l_dif TO FORMONLY.rwt208_1
         WHEN 9
            INITIALIZE l_sum,l_dif TO NULL
            IF g_azw07_n > 0 THEN
               SELECT COALESCE(SUM(rwt209),0) INTO l_sum FROM rwt_file WHERE rwt04 = g_rwt.rwt01 AND rwt02 = g_rwt.rwt02
            ELSE
               SELECT COALESCE(SUM(rwu209),0) INTO l_sum FROM rwu_file WHERE rwu01 = g_rwt.rwt01 AND rwu02 = g_rwt.rwt02
            END IF
            LET l_dif = g_rwt.rwt209 - l_sum
            DISPLAY l_dif TO FORMONLY.rwt209_1
         WHEN 10
            INITIALIZE l_sum,l_dif TO NULL
            IF g_azw07_n > 0 THEN
               SELECT COALESCE(SUM(rwt210),0) INTO l_sum FROM rwt_file WHERE rwt04 = g_rwt.rwt01 AND rwt02 = g_rwt.rwt02
            ELSE
               SELECT COALESCE(SUM(rwu210),0) INTO l_sum FROM rwu_file WHERE rwu01 = g_rwt.rwt01 AND rwu02 = g_rwt.rwt02
            END IF
            LET l_dif = g_rwt.rwt210 - l_sum
            DISPLAY l_dif TO FORMONLY.rwt210_1
         WHEN 11
            INITIALIZE l_sum,l_dif TO NULL
            IF g_azw07_n > 0 THEN
               SELECT COALESCE(SUM(rwt211),0) INTO l_sum FROM rwt_file WHERE rwt04 = g_rwt.rwt01 AND rwt02 = g_rwt.rwt02
            ELSE
               SELECT COALESCE(SUM(rwu211),0) INTO l_sum FROM rwu_file WHERE rwu01 = g_rwt.rwt01 AND rwu02 = g_rwt.rwt02
            END IF
            LET l_dif = g_rwt.rwt211 - l_sum
            DISPLAY l_dif TO FORMONLY.rwt211_1
         WHEN 12
            INITIALIZE l_sum,l_dif TO NULL
            IF g_azw07_n > 0 THEN
               SELECT COALESCE(SUM(rwt212),0) INTO l_sum FROM rwt_file WHERE rwt04 = g_rwt.rwt01 AND rwt02 = g_rwt.rwt02
            ELSE
               SELECT COALESCE(SUM(rwu212),0) INTO l_sum FROM rwu_file WHERE rwu01 = g_rwt.rwt01 AND rwu02 = g_rwt.rwt02
            END IF
            LET l_dif = g_rwt.rwt212 - l_sum
            DISPLAY l_dif TO FORMONLY.rwt212_1
      END CASE
   END FOR
END FUNCTION

FUNCTION i140_fill_b1(p_num)
DEFINE l_i     LIKE type_file.num5
DEFINE p_num   LIKE type_file.num5

   FOR l_i = 1 TO 12
      CASE l_i
         WHEN 1
            LET g_replace = g_rwt_b[p_num].rwt201_b/g_rwt.rwt201*100
            LET g_rwt_b[p_num].rwt201_desc = cl_digcut(g_replace,0)
         WHEN 2
            LET g_replace = g_rwt_b[p_num].rwt202_b/g_rwt.rwt202*100
            LET g_rwt_b[p_num].rwt202_desc = cl_digcut(g_replace,0)
         WHEN 3
            LET g_replace = g_rwt_b[p_num].rwt203_b/g_rwt.rwt203*100
            LET g_rwt_b[p_num].rwt203_desc = cl_digcut(g_replace,0)
         WHEN 4
            LET g_replace = g_rwt_b[p_num].rwt204_b/g_rwt.rwt204*100
            LET g_rwt_b[p_num].rwt204_desc = cl_digcut(g_replace,0)
         WHEN 5
            LET g_replace = g_rwt_b[p_num].rwt205_b/g_rwt.rwt205*100
            LET g_rwt_b[p_num].rwt205_desc = cl_digcut(g_replace,0)
         WHEN 6
            LET g_replace = g_rwt_b[p_num].rwt206_b/g_rwt.rwt206*100
            LET g_rwt_b[p_num].rwt206_desc = cl_digcut(g_replace,0)
         WHEN 7
            LET g_replace = g_rwt_b[p_num].rwt207_b/g_rwt.rwt207*100
            LET g_rwt_b[p_num].rwt207_desc = cl_digcut(g_replace,0)
         WHEN 8
            LET g_replace = g_rwt_b[p_num].rwt208_b/g_rwt.rwt208*100
            LET g_rwt_b[p_num].rwt208_desc = cl_digcut(g_replace,0)
         WHEN 9
            LET g_replace = g_rwt_b[p_num].rwt209_b/g_rwt.rwt209*100
            LET g_rwt_b[p_num].rwt209_desc = cl_digcut(g_replace,0)
         WHEN 10
            LET g_replace = g_rwt_b[p_num].rwt210_b/g_rwt.rwt210*100
            LET g_rwt_b[p_num].rwt210_desc = cl_digcut(g_replace,0)
         WHEN 11
            LET g_replace = g_rwt_b[p_num].rwt211_b/g_rwt.rwt211*100
            LET g_rwt_b[p_num].rwt211_desc = cl_digcut(g_replace,0)
         WHEN 12
            LET g_replace = g_rwt_b[p_num].rwt212_b/g_rwt.rwt212*100
            LET g_rwt_b[p_num].rwt212_desc = cl_digcut(g_replace,0)
      END CASE
   END FOR
END FUNCTION

FUNCTION i140_fill_b2(p_num)
DEFINE l_i     LIKE type_file.num5
DEFINE p_num   LIKE type_file.num5

   FOR l_i = 1 TO 12
      CASE l_i
         WHEN 1
            LET g_replace = g_rwu[p_num].rwu201/g_rwt.rwt201*100
            LET g_rwu[p_num].rwu201_desc = cl_digcut(g_replace,0)
         WHEN 2
            LET g_replace = g_rwu[p_num].rwu202/g_rwt.rwt202*100
            LET g_rwu[p_num].rwu202_desc = cl_digcut(g_replace,0)
         WHEN 3
            LET g_replace = g_rwu[p_num].rwu203/g_rwt.rwt203*100
            LET g_rwu[p_num].rwu203_desc = cl_digcut(g_replace,0)
         WHEN 4
            LET g_replace = g_rwu[p_num].rwu204/g_rwt.rwt204*100
            LET g_rwu[p_num].rwu204_desc = cl_digcut(g_replace,0)
         WHEN 5
            LET g_replace = g_rwu[p_num].rwu205/g_rwt.rwt205*100
            LET g_rwu[p_num].rwu205_desc = cl_digcut(g_replace,0)
         WHEN 6
            LET g_replace = g_rwu[p_num].rwu206/g_rwt.rwt206*100
            LET g_rwu[p_num].rwu206_desc = cl_digcut(g_replace,0)
         WHEN 7
            LET g_replace = g_rwu[p_num].rwu207/g_rwt.rwt207*100
            LET g_rwu[p_num].rwu207_desc = cl_digcut(g_replace,0)
         WHEN 8
            LET g_replace = g_rwu[p_num].rwu208/g_rwt.rwt208*100
            LET g_rwu[p_num].rwu208_desc = cl_digcut(g_replace,0)
         WHEN 9
            LET g_replace = g_rwu[p_num].rwu209/g_rwt.rwt209*100
            LET g_rwu[p_num].rwu209_desc = cl_digcut(g_replace,0)
         WHEN 10
            LET g_replace = g_rwu[p_num].rwu210/g_rwt.rwt210*100
            LET g_rwu[p_num].rwu210_desc = cl_digcut(g_replace,0)
         WHEN 11
            LET g_replace = g_rwu[p_num].rwu211/g_rwt.rwt211*100
            LET g_rwu[p_num].rwu211_desc = cl_digcut(g_replace,0)
         WHEN 12
            LET g_replace = g_rwu[p_num].rwu212/g_rwt.rwt212*100
            LET g_rwu[p_num].rwu212_desc = cl_digcut(g_replace,0)
      END CASE
   END FOR
END FUNCTION

FUNCTION i140_sure(p_row,p_col)   
DEFINE   ls_msg        LIKE ze_file.ze03       
DEFINE   li_result     LIKE type_file.num5     
DEFINE   p_row,p_col   LIKE type_file.num5     
 
   SELECT ze03 INTO ls_msg FROM ze_file WHERE ze01 = 'art-698' AND ze02 = g_lang   
   MENU "" ATTRIBUTE (STYLE="dialog", COMMENT=ls_msg CLIPPED, IMAGE="question")      
      ON ACTION yes      
         LET li_result = TRUE   
         EXIT MENU      
      ON ACTION no         
         EXIT MENU      
      ON IDLE g_idle_seconds     
         CALL cl_on_idle()      
         CONTINUE MENU 
   END MENU  
   IF (INT_FLAG) THEN  
      LET INT_FLAG = FALSE  
      LET li_result = FALSE
   END IF 
   RETURN li_result
END FUNCTION

FUNCTION i140_rwt_p1()
DEFINE l_rwt     RECORD LIKE rwt_file.*
DEFINE l_success LIKE type_file.chr1

   LET g_sql = "SELECT azw01 FROM azw_file WHERE azw07 = '",g_rwt.rwt01,"' AND azwacti = 'Y' ORDER BY 1"
   PREPARE p_ins_rwt_pre1 FROM g_sql
   DECLARE p_ins_rwt_cs1 CURSOR FOR p_ins_rwt_pre1
   INITIALIZE l_rwt.* TO NULL
   BEGIN WORK
   LET l_success = 'Y'
   FOREACH p_ins_rwt_cs1 INTO l_rwt.rwt01
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET l_rwt.rwt02 = g_rwt.rwt02
      LET l_rwt.rwt03 = g_rwt.rwt01
      LET l_rwt.rwt04 = g_plant
      LET l_rwt.rwt201 = 0
      LET l_rwt.rwt202 = 0
      LET l_rwt.rwt203 = 0
      LET l_rwt.rwt204 = 0
      LET l_rwt.rwt205 = 0
      LET l_rwt.rwt206 = 0
      LET l_rwt.rwt207 = 0
      LET l_rwt.rwt208 = 0
      LET l_rwt.rwt209 = 0
      LET l_rwt.rwt210 = 0
      LET l_rwt.rwt211 = 0
      LET l_rwt.rwt212 = 0
      LET l_rwt.rwtdate = ''
      LET l_rwt.rwtgrup = g_grup
      LET l_rwt.rwtuser = g_user
      LET l_rwt.rwtmodu = ''
      LET l_rwt.rwtorig = g_grup
      LET l_rwt.rwtoriu = g_user
      INSERT INTO rwt_file VALUES(l_rwt.*)
      IF SQLCA.sqlcode THEN
         LET l_success = 'N'
         EXIT FOREACH
      END IF
   END FOREACH
   IF l_success = 'Y' THEN
      COMMIT WORK
      CALL cl_err('','abm-019',0)
   ELSE
      ROLLBACK WORK
      CALL cl_err('','abm-020',0)
   END IF
   CALL i140_show()
END FUNCTION

FUNCTION i140_rwt_p2()
DEFINE l_rwt     RECORD LIKE rwt_file.*
DEFINE l_success LIKE type_file.chr1
DEFINE l_azw01_n LIKE type_file.num5
   
   SELECT COUNT(*) INTO l_azw01_n FROM azw_file 
    WHERE azw07 = g_rwt.rwt01 AND azwacti = 'Y'
   LET g_sql = "SELECT azw01 FROM azw_file WHERE azw07 = '",g_rwt.rwt01,"' AND azwacti = 'Y' ORDER BY 1"
   PREPARE p_ins_rwt_pre2 FROM g_sql
   DECLARE p_ins_rwt_cs2 CURSOR FOR p_ins_rwt_pre2
   INITIALIZE l_rwt.* TO NULL
   BEGIN WORK
   LET l_success = 'Y'
   FOREACH p_ins_rwt_cs2 INTO l_rwt.rwt01
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET l_rwt.rwt02 = g_rwt.rwt02
      LET l_rwt.rwt03 = g_rwt.rwt01
      LET l_rwt.rwt04 = g_plant
      LET l_rwt.rwt201 = cl_digcut(g_rwt.rwt201/l_azw01_n,g_azi04)
      LET l_rwt.rwt202 = cl_digcut(g_rwt.rwt202/l_azw01_n,g_azi04)
      LET l_rwt.rwt203 = cl_digcut(g_rwt.rwt203/l_azw01_n,g_azi04)
      LET l_rwt.rwt204 = cl_digcut(g_rwt.rwt204/l_azw01_n,g_azi04)
      LET l_rwt.rwt205 = cl_digcut(g_rwt.rwt205/l_azw01_n,g_azi04)
      LET l_rwt.rwt206 = cl_digcut(g_rwt.rwt206/l_azw01_n,g_azi04)
      LET l_rwt.rwt207 = cl_digcut(g_rwt.rwt207/l_azw01_n,g_azi04)
      LET l_rwt.rwt208 = cl_digcut(g_rwt.rwt208/l_azw01_n,g_azi04)
      LET l_rwt.rwt209 = cl_digcut(g_rwt.rwt209/l_azw01_n,g_azi04)
      LET l_rwt.rwt210 = cl_digcut(g_rwt.rwt210/l_azw01_n,g_azi04)
      LET l_rwt.rwt211 = cl_digcut(g_rwt.rwt211/l_azw01_n,g_azi04)
      LET l_rwt.rwt212 = cl_digcut(g_rwt.rwt212/l_azw01_n,g_azi04)
      LET l_rwt.rwtdate = ''
      LET l_rwt.rwtgrup = g_grup
      LET l_rwt.rwtuser = g_user
      LET l_rwt.rwtmodu = ''
      LET l_rwt.rwtorig = g_grup
      LET l_rwt.rwtoriu = g_user

      INSERT INTO rwt_file VALUES(l_rwt.*)
      IF SQLCA.sqlcode THEN
         LET l_success = 'N'
         EXIT FOREACH
      END IF
   END FOREACH
   IF NOT cl_null(l_rwt.rwt01) THEN
      SELECT COALESCE(SUM(rwt201),0),COALESCE(SUM(rwt202),0),COALESCE(SUM(rwt203),0),
             COALESCE(SUM(rwt204),0),COALESCE(SUM(rwt205),0),COALESCE(SUM(rwt206),0),
             COALESCE(SUM(rwt207),0),COALESCE(SUM(rwt208),0),COALESCE(SUM(rwt209),0),
             COALESCE(SUM(rwt210),0),COALESCE(SUM(rwt211),0),COALESCE(SUM(rwt212),0)
        INTO l_rwt.rwt201,l_rwt.rwt202,l_rwt.rwt203,l_rwt.rwt204,l_rwt.rwt205,l_rwt.rwt206,
             l_rwt.rwt207,l_rwt.rwt208,l_rwt.rwt209,l_rwt.rwt210,l_rwt.rwt211,l_rwt.rwt212
        FROM rwt_file
       WHERE rwt01 <> l_rwt.rwt01
         AND rwt02 = g_rwt.rwt02
         AND rwt03 = g_rwt.rwt01
         AND rwt04 = g_plant
      UPDATE rwt_file SET rwt201 = g_rwt.rwt201 - l_rwt.rwt201,
                          rwt202 = g_rwt.rwt202 - l_rwt.rwt202, 
                          rwt203 = g_rwt.rwt203 - l_rwt.rwt203, 
                          rwt204 = g_rwt.rwt204 - l_rwt.rwt204, 
                          rwt205 = g_rwt.rwt205 - l_rwt.rwt205, 
                          rwt206 = g_rwt.rwt206 - l_rwt.rwt206, 
                          rwt207 = g_rwt.rwt207 - l_rwt.rwt207, 
                          rwt208 = g_rwt.rwt208 - l_rwt.rwt208, 
                          rwt209 = g_rwt.rwt209 - l_rwt.rwt209, 
                          rwt210 = g_rwt.rwt210 - l_rwt.rwt210, 
                          rwt211 = g_rwt.rwt211 - l_rwt.rwt211, 
                          rwt212 = g_rwt.rwt212 - l_rwt.rwt212
       WHERE rwt01 = l_rwt.rwt01
         AND rwt02 = g_rwt.rwt02
         AND rwt03 = g_rwt.rwt01
         AND rwt04 = g_plant
   END IF
   IF l_success = 'Y' THEN
      COMMIT WORK
      CALL cl_err('','abm-019',0)
   ELSE
      ROLLBACK WORK
      CALL cl_err('','abm-020',0)
   END IF
   CALL i140_show()
END FUNCTION

FUNCTION i140_rwu_p1()
DEFINE l_rwu     RECORD LIKE rwu_file.*
DEFINE l_success LIKE type_file.chr1

   LET g_sql = "SELECT gen01 FROM gen_file WHERE gen07 = '",g_rwt.rwt01,"' AND genacti = 'Y' ORDER BY 1"
   PREPARE p_ins_rwu_pre1 FROM g_sql
   DECLARE p_ins_rwu_cs1 CURSOR FOR p_ins_rwu_pre1
   INITIALIZE l_rwu.* TO NULL
   BEGIN WORK
   LET l_success = 'Y'
   FOREACH p_ins_rwu_cs1 INTO l_rwu.rwu03
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET l_rwu.rwu02 = g_rwt.rwt02
      LET l_rwu.rwu01 = g_rwt.rwt01
      LET l_rwu.rwu201 = 0
      LET l_rwu.rwu202 = 0
      LET l_rwu.rwu203 = 0
      LET l_rwu.rwu204 = 0
      LET l_rwu.rwu205 = 0
      LET l_rwu.rwu206 = 0
      LET l_rwu.rwu207 = 0
      LET l_rwu.rwu208 = 0
      LET l_rwu.rwu209 = 0
      LET l_rwu.rwu210 = 0
      LET l_rwu.rwu211 = 0
      LET l_rwu.rwu212 = 0

      INSERT INTO rwu_file VALUES(l_rwu.*)
      IF SQLCA.sqlcode THEN
         LET l_success = 'N'
         EXIT FOREACH
      END IF
   END FOREACH
   IF l_success = 'Y' THEN
      COMMIT WORK
      CALL cl_err('','abm-019',0)
   ELSE
      ROLLBACK WORK
      CALL cl_err('','abm-020',0)
   END IF
   CALL i140_show()
END FUNCTION

FUNCTION i140_rwu_p2()
DEFINE l_rwu     RECORD LIKE rwu_file.*
DEFINE l_success LIKE type_file.chr1
DEFINE l_gen01_n LIKE type_file.num5
   
   SELECT COUNT(*) INTO l_gen01_n FROM gen_file 
    WHERE gen07 = g_rwt.rwt01 AND genacti = 'Y'
   LET g_sql = "SELECT gen01 FROM gen_file WHERE gen07 = '",g_rwt.rwt01,"' AND genacti = 'Y' ORDER BY 1"
   PREPARE p_ins_rwu_pre2 FROM g_sql
   DECLARE p_ins_rwu_cs2 CURSOR FOR p_ins_rwu_pre2
   INITIALIZE l_rwu.* TO NULL
   BEGIN WORK
   LET l_success = 'Y'
   FOREACH p_ins_rwu_cs2 INTO l_rwu.rwu03
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET l_rwu.rwu02 = g_rwt.rwt02
      LET l_rwu.rwu01 = g_rwt.rwt01
      LET l_rwu.rwu201 = cl_digcut(g_rwt.rwt201/l_gen01_n,g_azi04)
      LET l_rwu.rwu202 = cl_digcut(g_rwt.rwt202/l_gen01_n,g_azi04)
      LET l_rwu.rwu203 = cl_digcut(g_rwt.rwt203/l_gen01_n,g_azi04)
      LET l_rwu.rwu204 = cl_digcut(g_rwt.rwt204/l_gen01_n,g_azi04)
      LET l_rwu.rwu205 = cl_digcut(g_rwt.rwt205/l_gen01_n,g_azi04)
      LET l_rwu.rwu206 = cl_digcut(g_rwt.rwt206/l_gen01_n,g_azi04)
      LET l_rwu.rwu207 = cl_digcut(g_rwt.rwt207/l_gen01_n,g_azi04)
      LET l_rwu.rwu208 = cl_digcut(g_rwt.rwt208/l_gen01_n,g_azi04)
      LET l_rwu.rwu209 = cl_digcut(g_rwt.rwt209/l_gen01_n,g_azi04)
      LET l_rwu.rwu210 = cl_digcut(g_rwt.rwt210/l_gen01_n,g_azi04)
      LET l_rwu.rwu211 = cl_digcut(g_rwt.rwt211/l_gen01_n,g_azi04)
      LET l_rwu.rwu212 = cl_digcut(g_rwt.rwt212/l_gen01_n,g_azi04)

      INSERT INTO rwu_file VALUES(l_rwu.*)
      IF SQLCA.sqlcode THEN
         LET l_success = 'N'
         EXIT FOREACH
      END IF
   END FOREACH
   IF NOT cl_null(l_rwu.rwu03) THEN
      SELECT COALESCE(SUM(rwu201),0),COALESCE(SUM(rwu202),0),COALESCE(SUM(rwu203),0),
             COALESCE(SUM(rwu204),0),COALESCE(SUM(rwu205),0),COALESCE(SUM(rwu206),0),
             COALESCE(SUM(rwu207),0),COALESCE(SUM(rwu208),0),COALESCE(SUM(rwu209),0),
             COALESCE(SUM(rwu210),0),COALESCE(SUM(rwu211),0),COALESCE(SUM(rwu212),0)
        INTO l_rwu.rwu201,l_rwu.rwu202,l_rwu.rwu203,l_rwu.rwu204,l_rwu.rwu205,l_rwu.rwu206,
             l_rwu.rwu207,l_rwu.rwu208,l_rwu.rwu209,l_rwu.rwu210,l_rwu.rwu211,l_rwu.rwu212
        FROM rwu_file
       WHERE rwu01 = g_rwt.rwt01 AND rwu02 = g_rwt.rwt02 AND rwu03 <> l_rwu.rwu03
      UPDATE rwu_file SET rwu201 = g_rwt.rwt201 - l_rwu.rwu201,
                          rwu202 = g_rwt.rwt202 - l_rwu.rwu202,
                          rwu203 = g_rwt.rwt203 - l_rwu.rwu203,
                          rwu204 = g_rwt.rwt204 - l_rwu.rwu204,
                          rwu205 = g_rwt.rwt205 - l_rwu.rwu205,
                          rwu206 = g_rwt.rwt206 - l_rwu.rwu206,
                          rwu207 = g_rwt.rwt207 - l_rwu.rwu207,
                          rwu208 = g_rwt.rwt208 - l_rwu.rwu208,
                          rwu209 = g_rwt.rwt209 - l_rwu.rwu209,
                          rwu210 = g_rwt.rwt210 - l_rwu.rwu210,
                          rwu211 = g_rwt.rwt211 - l_rwu.rwu211,
                          rwu212 = g_rwt.rwt212 - l_rwu.rwu212
       WHERE rwu01 = g_rwt.rwt01
         AND rwu02 = g_rwt.rwt02
         AND rwu03 = l_rwu.rwu03
   END IF
   IF l_success = 'Y' THEN
      COMMIT WORK
      CALL cl_err('','abm-019',0)
   ELSE
      ROLLBACK WORK
      CALL cl_err('','abm-020',0)
   END IF
   CALL i140_show()
END FUNCTION


#FUN-B40070 ADD
