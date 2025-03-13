# Prog. Version..: '5.30.06-13.04.09(00005)'     #
#
# Pattern name...: almi570.4gl 兌換方案代碼維護作業 
# Date & Author..: 12/05/10 By pauline 
# Modify.........: No.FUN-C50045 
# Modify.........: No.FUN-C60037 12/06/11 By pauline 錯誤訊息修改
# Modify.........: No.FUN-C60054 12/06/15 By pauline 修正變數名稱,當已被積分換物/累計消費換物使用時不可取消確認
# Modify.........: No.CHI-C80041 12/12/20 By bart 排除作廢
# Modify.........: No.CHI-D20015 13/03/26 By fengrui 統一確認和取消確認時確認人員和確認日期的寫法

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_lsl                 RECORD LIKE lsl_file.*,
       g_lsl_t               RECORD LIKE lsl_file.*,
       g_lsl01_t             LIKE  lsl_file.lsl01,
       g_lsl02_t             LIKE  lsl_file.lsl02

DEFINE g_forupd_sql          STRING
DEFINE g_before_input_done   LIKE type_file.num5
DEFINE g_wc                  STRING
DEFINE g_sql                 STRING
DEFINE g_chr                 LIKE lsl_file.lslacti
DEFINE g_cnt                 LIKE type_file.num10
DEFINE g_msg                 LIKE type_file.chr1000
DEFINE g_curs_index          LIKE type_file.num10
DEFINE g_row_count           LIKE type_file.num10
DEFINE g_jump                LIKE type_file.num10
DEFINE mi_no_ask             LIKE type_file.num5
DEFINE l_msg                 STRING
DEFINE g_str                 STRING

MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT

    IF (NOT cl_user()) THEN
      EXIT PROGRAM
    END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF

   CALL  cl_used(g_prog,g_time,1) RETURNING g_time
   INITIALIZE g_lsl.* TO NULL

   LET g_forupd_sql = "SELECT * FROM lsl_file WHERE lsl01 = ? AND lsl02 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i570_cl CURSOR FROM g_forupd_sql

   OPEN WINDOW w_curr WITH FORM "alm/42f/almi570"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

   LET g_action_choice = ''
   CALL i570_menu()

   CLOSE WINDOW w_curr

   CALL  cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION i570_menu()

    MENU ""
      BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)

       ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i570_a()
            END IF

        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                CALL i570_q()
            END IF
        ON ACTION next
            CALL i570_fetch('N')

        ON ACTION previous
            CALL i570_fetch('P')

        ON ACTION modify
           LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i570_u()
            END IF

        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL i570_x()
            END IF

        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
               CALL i570_r()
            END IF

        ON ACTION reproduce
             LET g_action_choice="reproduce"
             IF cl_chk_act_auth() THEN
                CALL i570_copy()
             END IF

        ON ACTION confirm
           LET g_action_choice="confirm"
           IF cl_chk_act_auth() THEN
              CALL i570_confirm()
           END IF

        ON ACTION unconfirm
           LET g_action_choice="unconfirm"
           IF cl_chk_act_auth() THEN
              CALL i570_unconfirm()
           END IF

        ON ACTION help
            CALL cl_show_help()

        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU

        ON ACTION jump
            CALL i570_fetch('/')

        ON ACTION first
            CALL i570_fetch('F')

        ON ACTION last
            CALL i570_fetch('L')

        ON ACTION controlg
            CALL cl_cmdask()

        ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()
            IF g_lsl.lslconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
            CALL cl_set_field_pic(g_lsl.lslconf,"","","",g_chr,"")

        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE MENU

        ON ACTION close       
            LET INT_FLAG=FALSE
            LET g_action_choice = "exit"
           EXIT MENU

        ON ACTION related_document
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
              IF NOT cl_null(g_lsl.lsl01) AND NOT cl_null(g_lsl.lsl02)  THEN
                 LET g_doc.column1 = "lsl01"
                 LET g_doc.column2 = "lsl02"
                 LET g_doc.value1 = g_lsl.lsl01
                 LET g_doc.value2 = g_lsl.lsl02
                 CALL cl_doc()
              END IF
           END IF

    END MENU
END FUNCTION

FUNCTION i570_q()

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)

    INITIALIZE g_lsl.* TO NULL

    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '  ' TO FORMONLY.cnt

    CALL i570_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF

    LET g_sql="SELECT lsl01,lsl02 FROM lsl_file ",
        " WHERE ",g_wc CLIPPED, " ORDER BY lsl01,lsl02"
    PREPARE i570_prepare FROM g_sql
    DECLARE i570_cs SCROLL CURSOR WITH HOLD FOR i570_prepare


    OPEN i570_cs
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_lsl.lsl01,SQLCA.sqlcode,0)
        INITIALIZE g_lsl.* TO NULL
    ELSE
        CALL i570_count() 
        CALL i570_fetch('F')
    END IF

END FUNCTION

FUNCTION i570_cs()

    CLEAR FORM
    CONSTRUCT BY NAME g_wc ON lsl01, lsl02, lsl03, lsl04, lsl05, lsl06, 
                              lslcond, lslconf, lslconu, lslcrat, lsldate, lslgrup, 
                              lslacti, lslmodu, lslorig, lsloriu, lsluser 

        BEFORE CONSTRUCT
           CALL cl_qbe_init()

        ON ACTION controlp
           CASE
              WHEN INFIELD(lsl02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form ="q_lsl02_1"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lsl02
                  NEXT FIELD lsl02
              WHEN INFIELD(lsl01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form ="q_lsl01_1"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lsl01
                  NEXT FIELD lsl01
              WHEN INFIELD(lslconu)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_lslconu"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lslconu
                 NEXT FIELD lslconu
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

        ON ACTION qbe_select
          CALL cl_qbe_select()

        ON ACTION qbe_save
          CALL cl_qbe_save()

    END CONSTRUCT

    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lsluser', 'lslgrup')


END FUNCTION

FUNCTION i570_fetch(p_fllsl)
    DEFINE  p_fllsl         LIKE type_file.chr1

    CASE p_fllsl
        WHEN 'N' FETCH NEXT     i570_cs INTO g_lsl.lsl01,g_lsl.lsl02
        WHEN 'P' FETCH PREVIOUS i570_cs INTO g_lsl.lsl01,g_lsl.lsl02
        WHEN 'F' FETCH FIRST    i570_cs INTO g_lsl.lsl01,g_lsl.lsl02
        WHEN 'L' FETCH LAST     i570_cs INTO g_lsl.lsl01,g_lsl.lsl02
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
            FETCH ABSOLUTE g_jump i570_cs INTO g_lsl.lsl01,g_lsl.lsl02
            LET mi_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_lsl.lsl02,SQLCA.sqlcode,0)
        INITIALIZE g_lsl.* TO NULL
        RETURN
    ELSE
      CASE p_fllsl
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx
    END IF

    SELECT * INTO g_lsl.* FROM lsl_file
       WHERE lsl01 = g_lsl.lsl01 AND lsl02 = g_lsl.lsl02
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","lsl_file",g_lsl.lsl01,g_lsl.lsl02,SQLCA.sqlcode,"","",0)
    ELSE
        CALL i570_show()
    END IF
END FUNCTION

FUNCTION i570_show()
    LET g_lsl_t.* = g_lsl.*
    DISPLAY BY NAME g_lsl.lsl01,g_lsl.lsl02,g_lsl.lsl03,g_lsl.lsl04,g_lsl.lsl05,g_lsl.lsl06,
                    g_lsl.lslconf,g_lsl.lslcond,g_lsl.lslconu,
                    g_lsl.lsluser,g_lsl.lslgrup,g_lsl.lslmodu,g_lsl.lsldate,g_lsl.lslacti,
                    g_lsl.lslcrat,g_lsl.lslorig,g_lsl.lsloriu
    IF g_lsl.lslconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    CALL cl_set_field_pic(g_lsl.lslconf,"","","",g_chr,"")
    CALL i570_lsl01('d')
    CALL cl_show_fld_cont()
END FUNCTION

FUNCTION i570_lsl01(p_cmd)
DEFINE  p_cmd      LIKE type_file.chr1,
        l_lsl01_desc    LIKE azp_file.azp02

   SELECT azp02 INTO l_lsl01_desc FROM azp_file WHERE azp01 = g_lsl.lsl01
   DISPLAY l_lsl01_desc TO FORMONLY.lsl01_desc

END FUNCTION


FUNCTION i570_a()
    MESSAGE ""
    CLEAR FORM

    INITIALIZE g_lsl.* LIKE lsl_file.*
    LET g_lsl01_t = NULL
    LET g_lsl02_t = NULL
    LET g_wc = NULL

    CALL cl_opmsg('a')

    WHILE TRUE
        LET g_lsl.lsluser = g_user
        LET g_lsl.lsloriu = g_user 
        LET g_lsl.lslorig = g_grup 
        LET g_lsl.lslgrup = g_grup
        LET g_lsl.lslcrat = g_today
        LET g_lsl.lslacti = 'Y'

        CALL i570_i("a")
        IF INT_FLAG THEN
            INITIALIZE g_lsl.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF

        INSERT INTO lsl_file VALUES(g_lsl.*)
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","lsl_file",g_lsl.lsl01,"",SQLCA.sqlcode,"","",0)
           CONTINUE WHILE
        ELSE
           CALL i570_count() 
        END IF
        EXIT WHILE
    END WHILE

    LET g_wc=' '
END FUNCTION

FUNCTION i570_i(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1,
            l_n       LIKE type_file.num5
   DEFINE   l_i,l_j   LIKE type_file.num5 

   DISPLAY BY NAME
      g_lsl.lsl01,g_lsl.lsl02,g_lsl.lsl03,g_lsl.lsl04,g_lsl.lsl05,g_lsl.lsl06,
      g_lsl.lslconf,g_lsl.lslcond,g_lsl.lslconu,
      g_lsl.lsluser,g_lsl.lslgrup,g_lsl.lslmodu,
      g_lsl.lsldate,g_lsl.lslacti,g_lsl.lslcrat,
      g_lsl.lsloriu,g_lsl.lslorig              

   LET g_lsl01_t = g_lsl.lsl01
   LET g_lsl02_t = g_lsl.lsl02
   LET g_lsl_t.* = g_lsl.*

   INPUT BY NAME g_lsl.lsloriu,g_lsl.lslorig,
      g_lsl.lsl01,g_lsl.lsl02,g_lsl.lsl03,g_lsl.lsl04,g_lsl.lsl05,
      g_lsl.lsl06,g_lsl.lslconf,g_lsl.lslcond,g_lsl.lslconu,
      g_lsl.lsluser,g_lsl.lslgrup,g_lsl.lslmodu,
      g_lsl.lsldate,g_lsl.lslacti,g_lsl.lslcrat
      WITHOUT DEFAULTS

      BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL i570_set_entry(p_cmd)
          CALL i570_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
          IF p_cmd = 'a' THEN
              CALL cl_set_comp_entry("lsl01",FALSE)
          END IF
          IF p_cmd = 'u' THEN
              CALL cl_set_comp_entry("lsl01",FALSE)
              CALL cl_set_comp_entry("lsl02",FALSE)
           ELSE
              CALL cl_set_comp_entry("lsl02",TRUE)
           END IF
          LET g_lsl.lsl01 = g_plant
          DISPLAY BY NAME g_lsl.lsl01
          CALL i570_lsl01('d')
          IF p_cmd='a' THEN
             LET g_lsl.lsl04 = g_today
          END IF
          DISPLAY BY NAME g_lsl.lsl04
          LET g_lsl.lslconf = 'N'
          DISPLAY BY NAME g_lsl.lslconf

      AFTER FIELD lsl02
         IF NOT cl_null(g_lsl.lsl02) THEN
            SELECT COUNT(*) INTO l_n FROM lsl_file WHERE lsl01=g_lsl.lsl01 AND lsl02=g_lsl.lsl02
            IF l_n>0 THEN
               CALL cl_err('','-239',0)
               LET g_lsl.lsl02=g_lsl_t.lsl02
               DISPLAY BY NAME g_lsl.lsl02
               NEXT FIELD lsl02
            END IF
         END IF

      AFTER FIELD lsl04
        IF NOT cl_null(g_lsl.lsl04) THEN
          IF p_cmd = 'a' OR (p_cmd = 'u' AND g_lsl.lsl05!=g_lsl_t.lsl04) THEN
            IF cl_null(g_lsl.lsl05) THEN
               IF p_cmd = 'a' THEN
                  IF g_lsl.lsl04<g_today THEN
                    CALL cl_err('','art-200',0)
                     LET g_lsl.lsl04 = g_lsl_t.lsl04
                     DISPLAY BY NAME g_lsl.lsl04
                     NEXT FIELD lsl04
                  END IF
               END IF
               IF p_cmd = 'u' AND g_lsl.lsl04!=g_lsl_t.lsl04 THEN
                  IF g_lsl.lsl04<g_lsl_t.lsl04 THEN
                     CALL cl_err('','art-202',0)
                     LET g_lsl.lsl04 = g_lsl_t.lsl04 
                     DISPLAY BY NAME g_lsl.lsl04
                     NEXT FIELD lsl04
                  END IF
               END IF
            ELSE
               IF p_cmd = 'a' THEN
                  IF g_lsl.lsl04<g_today THEN
                    CALL cl_err('','art-200',0)
                     LET g_lsl.lsl04 = g_lsl_t.lsl04
                     DISPLAY BY NAME g_lsl.lsl04
                     NEXT FIELD lsl04
                  END IF
               END IF
               IF p_cmd = 'u' AND g_lsl.lsl04!=g_lsl_t.lsl04 THEN
                  IF g_lsl.lsl04<g_lsl_t.lsl04 THEN
                     CALL cl_err('','art-202',0)
                     LET g_lsl.lsl05 = g_lsl_t.lsl04
                     DISPLAY BY NAME g_lsl.lsl04
                     NEXT FIELD lsl04
                  END IF
               END IF
               IF g_lsl.lsl04>g_lsl.lsl05 THEN
                  CALL cl_err ('','art-201',0)
                  LET g_lsl.lsl04 = g_lsl_t.lsl04
                  DISPLAY BY NAME g_lsl.lsl04
                  NEXT FIELD lsl04
               END IF
            END IF
          END IF
        END IF

      AFTER FIELD lsl05
         IF NOT cl_null(g_lsl.lsl05) THEN
          IF p_cmd = 'a' OR (p_cmd = 'u' AND g_lsl.lsl05!=g_lsl_t.lsl05) THEN
            IF cl_null(g_lsl.lsl04) THEN
               IF p_cmd = 'a' THEN
                  IF g_lsl.lsl05<g_today THEN
                    CALL cl_err('','art-480',0)
                     LET g_lsl.lsl05 = g_lsl_t.lsl05
                     DISPLAY BY NAME g_lsl.lsl05
                     NEXT FIELD lsl05
                  END IF
               END IF
               IF p_cmd = 'u' AND g_lsl.lsl05!=g_lsl_t.lsl05 THEN
                  IF g_lsl.lsl05<g_lsl_t.lsl05 THEN
                     CALL cl_err('','art-202',0)
                     LET g_lsl.lsl05 = g_lsl_t.lsl05
                     DISPLAY BY NAME g_lsl.lsl05
                     NEXT FIELD lsl05
                  END IF
               END IF
            ELSE
               IF p_cmd = 'a' THEN
                  IF g_lsl.lsl05<g_today THEN
                    CALL cl_err('','art-480',0)
                     LET g_lsl.lsl05 = g_lsl_t.lsl06
                     DISPLAY BY NAME g_lsl.lsl05
                     NEXT FIELD lsl05
                  END IF
               END IF
               IF p_cmd = 'u' AND g_lsl.lsl05!=g_lsl_t.lsl05 THEN
                  IF g_lsl.lsl05<g_lsl_t.lsl05 THEN
                     CALL cl_err('','art-202',0)
                     LET g_lsl.lsl05 = g_lsl_t.lsl05
                     DISPLAY BY NAME g_lsl.lsl05
                     NEXT FIELD lsl05
                  END IF
               END IF
               IF g_lsl.lsl05<g_lsl.lsl04 THEN
                  CALL cl_err ('','art-201',0)
                  LET g_lsl.lsl05 = g_lsl_t.lsl05
                  DISPLAY BY NAME g_lsl.lsl05
                  NEXT FIELD lsl05
               END IF
            END IF
          END IF
        END IF

     AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF cl_null(g_lsl.lsl01)  THEN
              NEXT FIELD lsl01
            END IF
            IF cl_null(g_lsl.lsl02)  THEN
              NEXT FIELD lsl02
            END IF
            IF cl_null(g_lsl.lsl04)  THEN
              NEXT FIELD lsl01
            END IF
            IF cl_null(g_lsl.lsl05)  THEN
              NEXT FIELD lsl02
            END IF

   ON ACTION CONTROLO
      IF INFIELD(lsl01) THEN
         LET g_lsl.* = g_lsl_t.*
         CALL i570_show()
         NEXT FIELD lsl01 
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

END FUNCTION

FUNCTION i570_out()
#p_query
DEFINE l_cmd  STRING

    IF cl_null(g_wc) THEN
       CALL cl_err('','9057',0) RETURN
    END IF
    LET l_cmd = 'p_query "almi570" "',g_wc CLIPPED,'"'
    CALL cl_cmdrun(l_cmd)

END FUNCTION

FUNCTION i570_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1

     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("lsl01,lsl02,lsl03,lsl04,lsl05,lsl06",TRUE)
     END IF

END FUNCTION

FUNCTION i570_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1

    IF p_cmd = 'u' AND g_chkey = 'N' THEN
       CALL cl_set_comp_entry("lsl01",FALSE)
       CALL cl_set_comp_entry("lsl02,lsl03,lsl04,lsl05,lsl06",TRUE)
    END IF

END FUNCTION

FUNCTION i570_u()

    IF g_lsl.lsl01 <> g_plant THEN
       CALL cl_err('','art-977',0)
       RETURN
    END IF

    IF cl_null(g_lsl.lsl01) OR cl_null(g_lsl.lsl02) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_lsl.* FROM lsl_file WHERE lsl01 = g_lsl.lsl01 AND lsl02 = g_lsl.lsl02

    IF g_lsl.lslacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_lsl01_t = g_lsl.lsl01
    LET g_lsl02_t = g_lsl.lsl02

    IF g_lsl.lslconf='Y' THEN
      CALL  cl_err('','alm-027',1)
      RETURN
    END IF

    BEGIN WORK

    OPEN i570_cl USING g_lsl.lsl01,g_lsl.lsl02
    IF STATUS THEN
       CALL cl_err("OPEN i570_cl:", STATUS, 0)
       CLOSE i570_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i570_cl INTO g_lsl.*
    IF SQLCA.sqlcode THEN
       LET l_msg = g_lsl.lsl01 CLIPPED,g_lsl.lsl02 CLIPPED
       CALL cl_err(l_msg,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_lsl.lslmodu = g_user
    LET g_lsl.lsldate = g_today
    CALL i570_show()
    WHILE TRUE
        CALL i570_i("u")
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_lsl.*=g_lsl_t.*
            CALL i570_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE lsl_file SET lsl_file.* = g_lsl.*
            WHERE lsl01 = g_lsl.lsl01 AND lsl02 = g_lsl.lsl02
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","lsl_file",g_lsl.lsl01,g_lsl.lsl02,SQLCA.sqlcode,"","",0)
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    IF g_lsl.lslconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    CALL cl_set_field_pic(g_lsl.lslconf,"","","",g_chr,"")
    CLOSE i570_cl
    COMMIT WORK
END FUNCTION

FUNCTION i570_x()
DEFINE  l_n       LIKE type_file.num5
DEFINE  l_o       LIKE type_file.num5     
DEFINE  l_q       LIKE type_file.num5     

    IF g_lsl.lsl01 <> g_plant THEN
       CALL cl_err('','art-977',0)
       RETURN
    END IF

    IF cl_null(g_lsl.lsl01) OR cl_null(g_lsl.lsl02) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF

    IF g_lsl.lslconf='Y' THEN
      CALL  cl_err('','axr-913',1)
      RETURN
    END IF
   
  #若已被使用則不可作廢 
  #當已被積分換券設定作業/累計消費換券設定作業使用
   LET l_n = 0
   SELECT COUNT(*) INTO l_n FROM lst_file WHERE lst01 = g_lsl.lsl02 AND lst14 = g_lsl.lsl01
      IF l_n>0 THEN
        #CALL  cl_err('','art-991',1)  #FUN-C60037 mark      
         CALL  cl_err('','alm-h41',0)  #FUN-C60037 add
         RETURN
      END IF

  #當已被積分換券/累計消費換券單使用
  #LET l_n = 0
   SELECT COUNT(*) INTO l_n FROM lrj_file WHERE lrj05 = g_lsl.lsl02 AND lrj00 = g_lsl.lsl01
                                            AND lrj10 <> 'X'  #CHI-C80041
      IF l_n>0 THEN
        #CALL  cl_err('','art-991',1) #FUN-C60037 mark     
         CALL  cl_err('','alm-h41',0)  #FUN-C60037 add
         RETURN
      END IF


    BEGIN WORK

    OPEN i570_cl USING g_lsl.lsl01,g_lsl.lsl02
    IF STATUS THEN
       CALL cl_err("OPEN i570_cl:", STATUS, 0)
       CLOSE i570_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i570_cl INTO g_lsl.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lsl.lsl01,SQLCA.sqlcode,0)
       RETURN
    END IF
    LET g_lsl.lslmodu = g_user
    LET g_lsl.lsldate = g_today
    CALL i570_show()
    IF cl_exp(0,0,g_lsl.lslacti) THEN
        LET g_chr=g_lsl.lslacti
        IF g_lsl.lslacti='Y' THEN
            LET g_lsl.lslacti='N'
        ELSE
            LET g_lsl.lslacti='Y'
        END IF
        UPDATE lsl_file
            SET lslacti=g_lsl.lslacti
            WHERE lsl01 = g_lsl.lsl01 AND lsl02 = g_lsl.lsl02
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(g_lsl.lsl01,SQLCA.sqlcode,0)
            LET g_lsl.lslacti=g_chr
        END IF
        DISPLAY BY NAME g_lsl.lslacti
    END IF
    CLOSE i570_cl
    COMMIT WORK
END FUNCTION

FUNCTION i570_r()
DEFINE  l_n       LIKE type_file.num5
DEFINE  l_o       LIKE type_file.num5     
DEFINE  l_q       LIKE type_file.num5     

    IF g_lsl.lsl01 <> g_plant THEN
       CALL cl_err('','art-977',0)
       RETURN
    END IF

    IF cl_null(g_lsl.lsl01) OR cl_null(g_lsl.lsl02)THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF

    IF g_lsl.lslacti='N' THEN
      CALL  cl_err('','aic-201',1)
      RETURN
    END IF

    IF g_lsl.lslconf='Y' THEN
      CALL  cl_err('','alm-028',1)
      RETURN
    END IF

  #當有被使用後就不可以刪除
  #當已被積分換券設定作業/累計消費換券設定作業使用
   LET l_n = 0
   SELECT COUNT(*) INTO l_n FROM lst_file WHERE lst01 = g_lsl.lsl02 AND lst14 = g_lsl.lsl01
      IF l_n>0 THEN
        #CALL  cl_err('','art-991',1)  #FUN-C60037 mark
         CALL  cl_err('','alm-h41',0)  #FUN-C60037 add
         RETURN
      END IF

  #當已被積分換券/累計消費換券單使用 
  #LET l_n = 0
  #SELECT COUNT(*) INTO l_n FROM lrj_file WHERE lrj05 = g_lsl.lsl02 AND lrj00 = g_lsl.lpl01  #FUN-C60054 mark 
   SELECT COUNT(*) INTO l_n FROM lrj_file WHERE lrj05 = g_lsl.lsl02 AND lrj00 = g_lsl.lsl01  #FUN-C60054 add
                                            AND lrj10 <> 'X'  #CHI-C80041
      IF l_n>0 THEN
        #CALL  cl_err('','art-991',1)  #FUN-C60037 mark
         CALL  cl_err('','alm-h41',0)  #FUN-C60037 add
         RETURN
      END IF

    BEGIN WORK

    OPEN i570_cl USING g_lsl.lsl01,g_lsl.lsl02
    IF STATUS THEN
       CALL cl_err("OPEN i570_cl:", STATUS, 0)
       CLOSE i570_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i570_cl INTO g_lsl.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lsl.lsl01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i570_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          
        LET g_doc.column1 = "lsl01"         
        LET g_doc.column2 = "lsl02"         
        LET g_doc.value1 = g_lsl.lsl01      
        LET g_doc.value2 = g_lsl.lsl02      
        CALL cl_del_doc()                                    
       DELETE FROM lsl_file WHERE lsl01 = g_lsl.lsl01 AND lsl02 = g_lsl.lsl02 AND lslacti = 'Y'
       CLEAR FORM
       CALL i570_count()
       OPEN i570_cs
       IF g_row_count > 0 THEN
        IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i570_fetch('L')
        ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL i570_fetch('/')
        END IF
       END IF
    END IF
    CLOSE i570_cl
    COMMIT WORK
END FUNCTION

FUNCTION i570_confirm()
   DEFINE l_lsl01      LIKE lsl_file.lsl01
   DEFINE l_n          LIKE type_file.num5
   IF cl_null(g_lsl.lsl01) OR cl_null(g_lsl.lsl02)THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   IF g_lsl.lsl01 <> g_plant THEN
      CALL cl_err('','art-977',0)
      RETURN
   END IF

   IF g_lsl.lslconf = 'Y' THEN
      CALL cl_err('','aap-232',0)
      RETURN
   END IF

   IF g_lsl.lslacti='N' THEN
      CALL cl_err('','mfg0301',0)
      RETURN
   END IF

   IF NOT cl_confirm('aim-301') THEN RETURN END IF
   BEGIN WORK

   OPEN i570_cl USING g_lsl.lsl01,g_lsl.lsl02
   IF STATUS THEN
       CALL cl_err("OPEN i570_cl:", STATUS, 0)
       CLOSE i570_cl
       ROLLBACK WORK
       RETURN
   END IF
   FETCH i570_cl INTO g_lsl.*
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      RETURN
   END IF

   CALL i570_show()
   LET g_lsl.lslconf = 'Y'
   LET g_lsl.lslacti = 'Y'
   UPDATE lsl_file
      SET lslconf=g_lsl.lslconf,
          lslconu=g_user,
          lslcond=g_today
    WHERE lsl01 = g_lsl.lsl01 AND lsl02 = g_lsl.lsl02
   IF SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("upd","lsl_file",g_lsl.lsl01,"",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK
   END IF

   CLOSE i570_cl
   COMMIT WORK
   SELECT * INTO g_lsl.* FROM lsl_file WHERE lsl01 = g_lsl.lsl01 AND lsl02 = g_lsl.lsl02
   CALL i570_show()
END FUNCTION

FUNCTION i570_unconfirm()
   DEFINE l_lsl01 LIKE lsl_file.lsl01
   DEFINE l_n     LIKE type_file.num5
   DEFINE l_o     LIKE type_file.num5    
   DEFINE l_q     LIKE type_file.num5    

   IF g_lsl.lsl01 <> g_plant THEN
      CALL cl_err('','art-977',0)
      RETURN
   END IF

   IF cl_null(g_lsl.lsl01) OR cl_null(g_lsl.lsl02) THEN
      CALL cl_err('','-400',0)
   END IF

  #若已被使用則不可取消確認
  #當已被積分換券設定作業/累計消費換券設定作業使用
   LET l_n = 0
   SELECT COUNT(*) INTO l_n FROM lst_file WHERE lst01 = g_lsl.lsl02 AND lst14 = g_lsl.lsl01
      IF l_n>0 THEN
        #CALL  cl_err('','art-991',0)  #FUN-C60037 mark
         CALL  cl_err('','alm-h41',0)  #FUN-C60037 add
         RETURN
      END IF

  #FUN-C60054 add START
  #當已被積分換物設定作業/累計消費換物設定作業使用
   LET l_n = 0
   SELECT COUNT(*) INTO l_n FROM lpq_file WHERE lpq01 = g_lsl.lsl02 AND lpq13 = g_lsl.lsl01
      IF l_n>0 THEN
         CALL  cl_err('','alm-h41',0) 
         RETURN
      END IF
  #FUN-C60054 add END

  #當已被積分換券/累計消費換券單使用 
   LET l_n = 0
  #SELECT COUNT(*) INTO l_n FROM lrj_file WHERE lrj05 = g_lsl.lsl02 AND lrj00 = g_ls.lsl01         #FUN-C60054 mark
   SELECT COUNT(*) INTO l_n FROM lrj_file WHERE lrj05 = g_lsl.lsl02 AND lrj00 = g_lsl.lsl01        #FUN-C60054 add
                                            AND lrj10 <> 'X'  #CHI-C80041 
      IF l_n>0 THEN
        #CALL  cl_err('','art-991',0)  #FUN-C60037 mark
         CALL  cl_err('','alm-h41',0)  #FUN-C60037 add
         RETURN
      END IF

   IF g_lsl.lslacti='N' THEN
      CALL cl_err('','mfg0301',0)
      RETURN
   END IF

   IF g_lsl.lslconf!='Y' THEN
      CALL  cl_err('','atm-053',1)
      RETURN
   END IF

   IF NOT cl_confirm('aim-302') THEN RETURN END IF
   BEGIN WORK

   OPEN i570_cl USING g_lsl.lsl01,g_lsl.lsl02
   IF STATUS THEN
       CALL cl_err("OPEN i570_cl:", STATUS, 0)
       CLOSE i570_cl
       ROLLBACK WORK
       RETURN
   END IF
   FETCH i570_cl INTO g_lsl.*
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      RETURN
   END IF
   CALL i570_show()
   UPDATE lsl_file
      SET lslconf='N',
          #CHI-D20015--modify--str--
          #lslconu='',
          #lslcond=''
          lslconu= g_user,
          lslcond= g_today
          #CHI-D20015--modify--str--
    WHERE lsl01 = g_lsl.lsl01 AND lsl02 = g_lsl.lsl02
   IF SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("upd","lsl_file",g_lsl.lsl01,"",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK
   END IF
   CLOSE i570_cl
   COMMIT WORK
   SELECT * INTO g_lsl.* FROM lsl_file 
      WHERE lsl01 = g_lsl.lsl01 AND lsl02 = g_lsl.lsl02
   CALL i570_show()
END FUNCTION

FUNCTION i570_copy()
  
   IF cl_null(g_lsl.lsl01 ) OR cl_null(g_lsl.lsl02) THEN
      CALL cl_err('','-400',0)  
      RETURN
   END IF

 
   WHILE TRUE
        LET g_lsl.lsluser = g_user
        LET g_lsl.lsloriu = g_user 
        LET g_lsl.lslorig = g_grup 
        LET g_lsl.lslgrup = g_grup
        LET g_lsl.lslcrat = g_today
        LET g_lsl.lslacti = 'Y'

        CALL i570_i("a")
        IF INT_FLAG THEN
           INITIALIZE g_lsl.* TO NULL
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           CLEAR FORM
           EXIT WHILE
        END IF   

        INSERT INTO lsl_file VALUES(g_lsl.*)
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","lsl_file",g_lsl.lsl01,"",SQLCA.sqlcode,"","",0)
           CONTINUE WHILE
        ELSE
           CALL i570_count()
        END IF
        EXIT WHILE

   END WHILE 

  
END FUNCTION

FUNCTION i570_count()

   IF cl_null(g_wc) THEN
      LET g_wc = " 1=1" 
   END IF

   LET g_sql = "SELECT COUNT(*) FROM lsl_file WHERE ",g_wc CLIPPED
   PREPARE i570_precount FROM g_sql
   DECLARE i570_count CURSOR FOR i570_precount

   OPEN i570_count
   IF STATUS THEN
      CLOSE i570_cs
      CLOSE i570_count
      COMMIT WORK
      RETURN
   END IF
   FETCH i570_count INTO g_row_count
   IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
      CLOSE i570_cs
      CLOSE i570_count
      COMMIT WORK
      RETURN
   END IF
   DISPLAY g_row_count TO FORMONLY.cnt
 
END FUNCTION

#FUN-C50045 
