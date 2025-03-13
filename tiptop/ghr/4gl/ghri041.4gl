# Prog. Version..: '5.10.03-08.08.20(009)''     #
#
# Pattern name...: ghri041.4gl
# Descriptions...: 人员排班维护作业
# Date & Author..: 13/05/24 zhuzw

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE
         g_hrca_a           RECORD
            hrca01          LIKE hrca_file.hrca01,
            hrca02          LIKE hrca_file.hrca02,
            hrca03          LIKE hrca_file.hrca03,
            hrca04          LIKE hrca_file.hrca04,
            hrbo03          LIKE hrbo_file.hrbo03,
            hrca05          LIKE hrca_file.hrca05,
            hrbp03          LIKE hrbp_file.hrbp03,
            hrca06          LIKE hrca_file.hrca06,
            hrbpa03         LIKE hrbpa_file.hrbpa03,
            hrca07          LIKE hrca_file.hrca07,
            hrca08          LIKE hrca_file.hrca08,
            hrca09          LIKE hrca_file.hrca09,
            hrca10          LIKE hrca_file.hrca10,
            hrca10_1        LIKE hrca_file.hrca10,
            hrca11          LIKE hrca_file.hrca11,
            hrca12          LIKE hrca_file.hrca12,
            hrcaud02        LIKE hrca_file.hrcaud02
                      END RECORD,
         g_hrca_a_t           RECORD
            hrca01          LIKE hrca_file.hrca01,
            hrca02          LIKE hrca_file.hrca02,
            hrca03          LIKE hrca_file.hrca03,
            hrca04          LIKE hrca_file.hrca04,
            hrbo03          LIKE hrbo_file.hrbo03,
            hrca05          LIKE hrca_file.hrca05,
            hrbp03          LIKE hrbp_file.hrbp03,
            hrca06          LIKE hrca_file.hrca06,
            hrbpa03         LIKE hrbpa_file.hrbpa03,
            hrca07          LIKE hrca_file.hrca07,
            hrca08          LIKE hrca_file.hrca08,
            hrca09          LIKE hrca_file.hrca09,
            hrca10          LIKE hrca_file.hrca10,
            hrca10_1        LIKE hrca_file.hrca10,
            hrca11          LIKE hrca_file.hrca11,
            hrca12          LIKE hrca_file.hrca12,
            hrcaud02        LIKE hrca_file.hrcaud02

                      END RECORD,
         g_hrca_lock      RECORD LIKE hrca_file.*,

         g_hrca    DYNAMIC ARRAY of RECORD
            hrca13          LIKE hrca_file.hrca13,
            hrca02_a        LIKE hrca_file.hrca02,
            hrca14          LIKE hrca_file.hrca14,
            hrca15          LIKE hrca_file.hrca15
                      END RECORD,
         g_hrca_t           RECORD
            hrca13          LIKE hrca_file.hrca13,
            hrca02_a        LIKE hrca_file.hrca02,
            hrca14          LIKE hrca_file.hrca14,
            hrca15          LIKE hrca_file.hrca15
                      END RECORD,
         g_cnt2                LIKE type_file.num5,
         g_wc                  STRING,
         g_sql                 STRING,
         g_rec_b               LIKE type_file.num5,
         l_ac                  LIKE type_file.num5
DEFINE   g_chr                 LIKE type_file.chr1
DEFINE   g_cnt                 LIKE type_file.num10
DEFINE   g_msg                 LIKE type_file.chr100
DEFINE   g_forupd_sql          STRING
DEFINE   g_before_input_done   LIKE type_file.num5
DEFINE   g_curs_index          LIKE type_file.num10
DEFINE   g_row_count           LIKE type_file.num10
DEFINE   g_jump                LIKE type_file.num10
DEFINE   g_no_ask              LIKE type_file.num5
DEFINE   g_std_id              LIKE smb_file.smb01
DEFINE   g_db_type             LIKE type_file.chr3
DEFINE  g_mulit_res           STRING
DEFINE g_hrca_1   DYNAMIC ARRAY OF RECORD
         hrca01     LIKE   hrca_file.hrca01,
         hrca02     LIKE   hrca_file.hrca02,
         hrca03     LIKE   hrca_file.hrca03,
         hrca04     LIKE   hrca_file.hrca04,
         hrbo03     LIKE   hrbo_file.hrbo03,
         hrca11     LIKE   hrca_file.hrca11,
         hrca12     LIKE   hrca_file.hrca12,
         hrca05     LIKE   hrca_file.hrca05,
         hrbp03     LIKE   hrbp_file.hrbp03,
         hrca06     LIKE   hrca_file.hrca06,
         hrbpa03    LIKE   hrbpa_file.hrbpa03,
         hrca07     LIKE   hrca_file.hrca07,
         hrca08     LIKE   hrca_file.hrca08,
         hrca09     LIKE   hrca_file.hrca09,
         hrca10     LIKE   hrca_file.hrca10,
         hrbo03_2   LIKE   hrbo_file.hrbo03
                  END RECORD,
       g_rec_b1,l_ac1   LIKE  type_file.num5
DEFINE g_bp_flag           LIKE type_file.chr1

MAIN
   DEFINE l_items  STRING

   OPTIONS
      FORM LINE       FIRST + 2,                  #畫面開始的位置
      MESSAGE LINE    LAST,                       #訊息顯示的位置
      PROMPT LINE     LAST,                       #提示訊息的位置
      INPUT NO WRAP
   DEFER INTERRUPT


   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   INITIALIZE g_hrca_a.*  TO NULL

   OPEN WINDOW i041_w WITH FORM "ghr/42f/ghri041"
   ATTRIBUTE(STYLE=g_win_style CLIPPED)

   CALL cl_ui_init()
   CALL cl_set_label_justify("i041_w","right")
   LET g_forupd_sql =" SELECT * FROM hrca_file ",
                      " WHERE hrca01 = ?  ",
                      " FOR UPDATE NOWAIT "
   DECLARE i041_lock_u CURSOR FROM g_forupd_sql
   CALL i041_get_items() RETURNING l_items,l_items
   CALL cl_set_combo_items("hrcaud02",l_items,l_items)
   CALL i041_menu()

   CLOSE WINDOW i041_w
     CALL  cl_used(g_prog,g_time,2)
         RETURNING g_time
END MAIN

FUNCTION i041_curs()                         # QBE
   CLEAR FORM
   CALL g_hrca.clear()
   INITIALIZE g_hrca_a.* TO NULL
      CALL cl_set_head_visible("","YES")

      CONSTRUCT g_wc ON hrca01,hrca02,hrca03,hrca04,hrca05,hrca06,hrca07,hrca08,hrca09,hrca10,hrca11,hrca12,hrcaud02,hrca02_a,hrca13,hrca14,hrca15
                   FROM hrca01,hrca02,hrca03,hrca04,hrca05,hrca06,hrca07,hrca08,hrca09,hrca10,hrca11,hrca12,hrcaud02,
                        s_hrca[1].hrca02_a,s_hrca[1].hrca13,s_hrca[1].hrca14,s_hrca[1].hrca15

      ON ACTION controlp
         CASE
            WHEN INFIELD(hrca01)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hrca01"
               LET g_qryparam.state = "c"
               LET g_qryparam.default1 = g_hrca_a.hrca01
               CALL cl_create_qry() RETURNING g_hrca_a.hrca01
               DISPLAY BY NAME g_hrca_a.hrca01
               NEXT FIELD hrca04
            WHEN INFIELD(hrca04)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hrbo02"
               LET g_qryparam.state = "c"
               LET g_qryparam.default1 = g_hrca_a.hrca04
               CALL cl_create_qry() RETURNING g_hrca_a.hrca04
               DISPLAY BY NAME g_hrca_a.hrca04
               NEXT FIELD hrca04
            WHEN INFIELD(hrca05)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hrbp02"
               LET g_qryparam.state = "c"
               LET g_qryparam.default1 = g_hrca_a.hrca05
               CALL cl_create_qry() RETURNING g_hrca_a.hrca05
               DISPLAY BY NAME g_hrca_a.hrca05
               NEXT FIELD hrca05
            WHEN INFIELD(hrca06)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hrbo02"
               LET g_qryparam.state = "c"
               LET g_qryparam.default1 = g_hrca_a.hrca06
               CALL cl_create_qry() RETURNING g_hrca_a.hrca06
               DISPLAY BY NAME g_hrca_a.hrca06
               NEXT FIELD hrca06
            WHEN INFIELD(hrca10)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hrbo02_1"
               LET g_qryparam.state = "c"
               LET g_qryparam.default1 = g_hrca_a.hrca10
               CALL cl_create_qry() RETURNING g_hrca_a.hrca10
               DISPLAY BY NAME g_hrca_a.hrca10
               NEXT FIELD hrca10
            WHEN INFIELD(hrca14)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "cq_hrca14"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hrca14
               NEXT FIELD hrca14
            OTHERWISE EXIT CASE
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
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hrcauser', 'hrcagrup')
      IF INT_FLAG THEN RETURN END IF
         LET g_wc = cl_replace_str(g_wc,"hrca02_a","hrca02")
         LET g_sql=" SELECT UNIQUE hrca01,hrca02,hrca03,hrca04,hrca05,hrca06,hrca07,hrca08,hrca09,hrca10,hrca11,hrca12,hrcaud02 FROM hrca_file",
                    " WHERE ",g_wc CLIPPED,
                    " ORDER BY hrca01"
   PREPARE i041_prepare FROM g_sql
   DECLARE i041_b_curs
   SCROLL CURSOR WITH HOLD FOR i041_prepare

END FUNCTION


FUNCTION i041_count()

   DEFINE la_hrca   DYNAMIC ARRAY of RECORD
            hrca01          LIKE hrca_file.hrca01
                           END RECORD
   DEFINE li_cnt   LIKE type_file.num10
   DEFINE li_rec_b LIKE type_file.num10

   LET g_sql= "SELECT UNIQUE hrca01,hrca02,hrca03,hrca04,hrca05,hrca06,hrca07,hrca08,hrca09,hrca10,hrca11,hrca12 FROM hrca_file ",
              " WHERE ", g_wc CLIPPED,
              " ORDER BY hrca01"

   PREPARE i041_precount FROM g_sql
   DECLARE i041_count CURSOR FOR i041_precount
   LET li_cnt=1
   LET li_rec_b=0
   FOREACH i041_count INTO g_hrca[li_cnt].*
       LET li_rec_b = li_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          LET li_rec_b = li_rec_b - 1
          EXIT FOREACH
       END IF
       LET li_cnt = li_cnt + 1
    END FOREACH
    LET g_row_count=li_rec_b

END FUNCTION

FUNCTION i041_menu()

   WHILE TRUE
      CALL i041_bp("G")

      IF NOT cl_null(g_action_choice) AND l_ac1>0 THEN
#FUN-151022 wangjy
#---------------------mark---------------------
#         SELECT hrca_file.* INTO g_hrca_a.*
#           FROM hrca_file
#           WHERE hrca01=g_hrca_1[l_ac1].hrca01
#---------------------mark---------------------
         SELECT hrca01,hrca02,hrca03,hrca04,hrca05,hrca06,hrca07,
                hrca08,hrca09,hrca10,hrca11,hrca12,hrcaud02
           INTO g_hrca_a.hrca01,g_hrca_a.hrca02,g_hrca_a.hrca03,g_hrca_a.hrca04,g_hrca_a.hrca05,
                g_hrca_a.hrca06,g_hrca_a.hrca07,g_hrca_a.hrca08,g_hrca_a.hrca09,g_hrca_a.hrca10,
                g_hrca_a.hrca11,g_hrca_a.hrca12,g_hrca_a.hrcaud02
           FROM hrca_file
          WHERE hrca01=g_hrca_1[l_ac1].hrca01
          IF NOT cl_null(g_hrca_a.hrca04) THEN
             SELECT hrbo03 INTO g_hrca_a.hrbo03 FROM hrbo_file
              WHERE hrbo02 = g_hrca_a.hrca04
          END IF
          IF NOT cl_null(g_hrca_a.hrca05) THEN
              SELECT hrbpa01,hrbpa03 INTO  g_hrca_a.hrca06,g_hrca_a.hrbpa03 FROM hrbpa_file
              WHERE hrbpa05 = g_hrca_a.hrca05
          END IF
          IF NOT cl_null(g_hrca_a.hrca10) THEN
             SELECT hrbo03 INTO g_hrca_a.hrca10_1 FROM hrbo_file
              WHERE hrbo02 = g_hrca_a.hrca10
          END IF
#FUN-151022 wangjy
      END IF

      IF g_action_choice != "" THEN
         LET g_bp_flag = 'Page2'
         LET l_ac1 = ARR_CURR()
         LET g_jump = l_ac1
         LET g_no_ask = TRUE
         IF g_rec_b >0 THEN
             CALL i041_fetch('/')
         END IF
         CALL cl_set_comp_visible("Page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("Page3", TRUE)
      END IF

      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i041_a()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i041_u()
            END IF
        WHEN "delete"
           IF cl_chk_act_auth() THEN
              CALL i041_r()
           END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i041_q()
            END IF
         --* zhoumj 20160113 --
         WHEN "Work_plan"
            IF cl_chk_act_auth() THEN
               CALL cl_cmdrun_wait("ghri084")
            END IF
         -- zhoumj 20160113 *--
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i041_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B049
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrca),'','')
            END IF

      END CASE
   END WHILE
END FUNCTION

FUNCTION i041_get_items()
DEFINE l_hrbk01   LIKE hrdk_file.hrdk01
DEFINE l_items  STRING
DEFINE l_sql    STRING

       LET l_sql=" SELECT DISTINCT hrbk01 FROM hrbk_file"
       PREPARE i041_get_hrdk FROM l_sql
       DECLARE i041_items CURSOR FOR i041_get_hrdk
       LET l_items=''
       FOREACH i041_items INTO l_hrbk01
          IF NOT cl_null(l_hrbk01) AND cl_null(l_items) THEN
            LET l_items=l_hrbk01
          ELSE
            LET l_items=l_items CLIPPED,",",l_hrbk01 CLIPPED
          END IF
       END FOREACH
       RETURN l_items,l_items
END FUNCTION

FUNCTION i041_a()
DEFINE l_hrca01 LIKE hrca_file.hrca01
   MESSAGE ""
   CLEAR FORM
   CALL g_hrca.clear()
   CALL cl_opmsg('a')
   INITIALIZE g_hrca_a.*  TO NULL
   WHILE TRUE
      SELECT MAX(hrca01) INTO l_hrca01 FROM hrca_file
      IF NOT cl_null(l_hrca01) THEN
         LET g_hrca_a.hrca01 = l_hrca01 + 1
      ELSE
      	LET  g_hrca_a.hrca01 = 0
      END IF
      CALL cl_set_comp_entry("hrca04",TRUE)
      CALL cl_set_comp_required("hrca01,hrca02,hrca03,hrca04,hrca05",TRUE)
      LET g_hrca_a.hrca02 = 1
      LET g_hrca_a.hrca03 = 1
      LET g_hrca_a.hrca07 = ''
      LET g_hrca_a.hrca08 = 'N'
      LET g_hrca_a.hrca09 = 'N'
      LET g_hrca_a.hrca11 = g_today
#      LET g_hrca_a.hrca12	= g_today      #FUN-160107 wjy MARK
      LET g_hrca_a.hrca12	= '99/12/30'   #FUN-160107 wjy ADD

      CALL i041_i("a")

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      LET g_rec_b = 0
         CALL g_hrca.clear()
      CALL i041_b()
      LET g_hrca_a_t.*=g_hrca_a.*
      EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION i041_i(p_cmd)                       #

   DEFINE   p_cmd        LIKE type_file.chr1
   DEFINE   l_count,l_n      LIKE type_file.num5


   IF s_shut(0) THEN
      RETURN
   END IF

   DISPLAY g_hrca_a.hrca01,g_hrca_a.hrca02,g_hrca_a.hrca03,g_hrca_a.hrca11,g_hrca_a.hrca12
        TO hrca01,hrca02,hrca03,hrca11,hrca12
   CALL cl_set_head_visible("","YES")
   INPUT BY NAME g_hrca_a.hrca01,g_hrca_a.hrca02,g_hrca_a.hrca03,g_hrca_a.hrca04,
                 g_hrca_a.hrca11,g_hrca_a.hrca12,g_hrca_a.hrca05,
                 g_hrca_a.hrca06,g_hrca_a.hrca07,g_hrca_a.hrca08,g_hrca_a.hrca09,g_hrca_a.hrca10,g_hrca_a.hrcaud02
    WITHOUT DEFAULTS

    BEFORE INPUT
        LET g_before_input_done = FALSE
        CALL i041_set_no_entry(p_cmd)
        LET g_before_input_done = TRUE
    AFTER FIELD hrca02
       IF cl_null(g_hrca_a.hrca02) THEN
          NEXT FIELD hrca02
       END IF
    ON CHANGE hrca03
       IF g_hrca_a.hrca03 = 1 THEN
             CALL cl_set_comp_entry("hrca04",TRUE)
             CALL cl_set_comp_entry("hrca05,hrca06,hrca08,hrca09",FALSE)
             LET g_hrca_a.hrca05 = ''
             LET g_hrca_a.hrca06 = ''
             LET g_hrca_a.hrca07 = ''
             LET g_hrca_a.hrca08 = 'N'
             LET g_hrca_a.hrca09 = 'N'
             LET g_hrca_a.hrca10 = ''
             LET g_hrca_a.hrca10_1 = ''
             LET g_hrca_a.hrbp03 = ''
             LET g_hrca_a.hrbpa03 = ''
             DISPLAY BY NAME g_hrca_a.hrca05,g_hrca_a.hrca06,g_hrca_a.hrca07,g_hrca_a.hrca08,
                             g_hrca_a.hrca09,g_hrca_a.hrca10,g_hrca_a.hrca10_1,g_hrca_a.hrbp03,g_hrca_a.hrbpa03
             NEXT FIELD hrca04
          ELSE
          	 LET g_hrca_a.hrca04 = ''
          	 LET g_hrca_a.hrbo03 = ''
          	 DISPLAY BY NAME g_hrca_a.hrca04,g_hrca_a.hrbo03
          	 CALL cl_set_comp_entry("hrca04",FALSE)
          	 CALL cl_set_comp_entry("hrca05,hrca06,hrca10",TRUE)
             NEXT FIELD hrca11
       END IF
    AFTER FIELD hrca04
       IF NOT cl_null(g_hrca_a.hrca04) THEN
          LET l_n = 0
          SELECT COUNT(*) INTO l_n FROM  hrbo_file
           WHERE hrbo02 = g_hrca_a.hrca04
          IF l_n = 0 THEN
             CALL cl_err(g_hrca_a.hrca04,'ghr-078',0)
             NEXT FIELD hrca04
          END IF
          SELECT hrbo03 INTO g_hrca_a.hrbo03 FROM hrbo_file
           WHERE hrbo02 = g_hrca_a.hrca04
           DISPLAY BY NAME   g_hrca_a.hrbo03
#       ELSE
#
#       	  IF g_hrca_a.hrca03 = 1 THEN
#       	     CALL cl_err('固定班次','azz-527',0)
#       	     NEXT FIELD hrca04
#       	  END IF
       END IF
    AFTER FIELD hrca05
       IF NOT cl_null(g_hrca_a.hrca05) THEN
          LET l_n = 0
          SELECT COUNT(*) INTO l_n FROM  hrbp_file
           WHERE hrbp02 = g_hrca_a.hrca05
          IF l_n = 0 THEN
             CALL cl_err(g_hrca_a.hrca05,'ghr-078',0)
             NEXT FIELD hrca05
          END IF
          SELECT hrbp03 INTO g_hrca_a.hrbp03 FROM hrbp_file
           WHERE hrbp02 = g_hrca_a.hrca05
          IF p_cmd='a' THEN
           SELECT hrbpa01,hrbpa03 INTO  g_hrca_a.hrca06,g_hrca_a.hrbpa03 FROM hrbpa_file
           WHERE hrbpa05 = g_hrca_a.hrca05
             AND hrbpa01 = 1
          END IF
           DISPLAY BY NAME  g_hrca_a.hrbp03,g_hrca_a.hrca06,g_hrca_a.hrbpa03
#       ELSE
#       	  IF g_hrca_a.hrca03 = 2 THEN
#       	     CALL cl_err('轮班','azz-527',0)
#       	     NEXT FIELD hrca05
#       	  END IF
        END IF
    AFTER FIELD hrca06
       IF NOT cl_null(g_hrca_a.hrca06) THEN
          LET l_n = 0
          SELECT COUNT(*) INTO l_n FROM  hrbpa_file
           WHERE hrbpa05 = g_hrca_a.hrca05
             AND hrbpa01 = g_hrca_a.hrca06

          IF l_n = 0 THEN
             CALL cl_err(g_hrca_a.hrca06,'ghr-078',0)
             NEXT FIELD hrca06
          END IF
          SELECT hrbpa03 INTO g_hrca_a.hrbpa03 FROM hrbpa_file
           WHERE hrbpa05 = g_hrca_a.hrca05
             AND hrbpa01 = g_hrca_a.hrca06
           DISPLAY BY NAME g_hrca_a.hrbpa03
#       ELSE
#       	  IF g_hrca_a.hrca03 = 2 THEN
#       	     NEXT FIELD hrca06
#       	  END IF
       END IF
#    AFTER FIELD hrca07
#       IF NOT cl_null(g_hrca_a.hrca07) THEN
#          CALL cl_set_comp_entry("hrca08,hrca09",TRUE)
#       ELSE
#       	  CALL cl_set_comp_entry("hrca08,hrca09",FALSE)
#       END IF
    ON CHANGE hrca07
       IF NOT cl_null(g_hrca_a.hrca07) THEN
          CALL cl_set_comp_entry("hrca08,hrca09",TRUE)
       ELSE
       	  CALL cl_set_comp_entry("hrca08,hrca09",FALSE)
       END IF
       IF g_hrca_a.hrca03 = '1' THEN #add by zhuzw 20160105 固定班次处理
          CALL cl_set_comp_entry("hrca08,hrca09",TRUE)
       END IF
    AFTER FIELD hrca10
       IF NOT cl_null(g_hrca_a.hrca10) THEN
          LET l_n = 0
          SELECT COUNT(*) INTO l_n FROM  hrbo_file
           WHERE hrbo02 = g_hrca_a.hrca10
             AND hrbo06 = 'Y'
          IF l_n = 0 THEN
             CALL cl_err(g_hrca_a.hrca10,'ghr-078',0)
             NEXT FIELD hrca04
          END IF
          SELECT hrbo03 INTO g_hrca_a.hrca10_1 FROM hrbo_file
           WHERE hrbo02 = g_hrca_a.hrca10
           DISPLAY BY NAME   g_hrca_a.hrca10_1
       END IF
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION controlp
         CASE
            WHEN INFIELD(hrca04)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hrbo02"
               LET g_qryparam.default1 = g_hrca_a.hrca04
               CALL cl_create_qry() RETURNING g_hrca_a.hrca04
               DISPLAY BY NAME g_hrca_a.hrca04
               NEXT FIELD hrca04
            WHEN INFIELD(hrca05)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hrbp02"
               LET g_qryparam.default1 = g_hrca_a.hrca05
               CALL cl_create_qry() RETURNING g_hrca_a.hrca05
               DISPLAY BY NAME g_hrca_a.hrca05
               NEXT FIELD hrca05
            WHEN INFIELD(hrca06)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hrbpa02_2" #"q_hrbpa02_1"
               LET g_qryparam.arg1 = g_hrca_a.hrca05
               LET g_qryparam.default1 = g_hrca_a.hrca06
               CALL cl_create_qry() RETURNING g_hrca_a.hrca06
               DISPLAY BY NAME g_hrca_a.hrca06
               NEXT FIELD hrca06
            WHEN INFIELD(hrca10)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hrbo02_1"
               LET g_qryparam.default1 = g_hrca_a.hrca10
               CALL cl_create_qry() RETURNING g_hrca_a.hrca10
               DISPLAY BY NAME g_hrca_a.hrca10
               NEXT FIELD hrca10
            OTHERWISE EXIT CASE
          END CASE

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

#      ON ACTION controlg
#         CALL cl_cmdask()

   END INPUT
END FUNCTION


FUNCTION i041_u()
  DEFINE l_greatest LIKE hrca_file.hrca11
  DEFINE l_least    LIKE hrca_file.hrca11
  DEFINE l_msg STRING
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_hrca_a.hrca01) THEN
      CALL cl_err('',-40,0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_hrca_a_t.* = g_hrca_a.*

   BEGIN WORK
   OPEN i041_lock_u USING g_hrca_a.hrca01
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE i041_lock_u
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i041_lock_u INTO g_hrca_lock.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("hrca01 LOCK:",SQLCA.sqlcode,1)
      CLOSE i041_lock_u
      ROLLBACK WORK
      RETURN
   END IF

   WHILE TRUE
   	  IF g_hrca_a.hrca03 = 1 THEN
           CALL cl_set_comp_entry("hrca04",TRUE)
           CALL cl_set_comp_entry("hrca05,hrca06",FALSE)
      ELSE
        	 CALL cl_set_comp_entry("hrca04",FALSE)
        	 CALL cl_set_comp_entry("hrca05,hrca06,hrca10",TRUE)
      END IF
      CALL i041_i("u")
      IF INT_FLAG THEN
         LET g_hrca_a.* = g_hrca_a_t.*
         DISPLAY BY NAME g_hrca_a.hrca01,g_hrca_a.hrca02,g_hrca_a.hrca03,g_hrca_a.hrca04,g_hrca_a.hrca05,
                         g_hrca_a.hrca06,g_hrca_a.hrca07,g_hrca_a.hrca08,g_hrca_a.hrca09,g_hrca_a.hrca10,
                         g_hrca_a.hrca11,g_hrca_a.hrca12,g_hrca_a.hrcaud02
         LET INT_FLAG = 0
         CALL cl_err('',901,0)
         EXIT WHILE
      END IF
      UPDATE hrca_file
         SET hrca01 = g_hrca_a.hrca01,
             hrca02 = g_hrca_a.hrca02,
             hrca03 = g_hrca_a.hrca03,
             hrca04 = g_hrca_a.hrca04,
             hrca05 = g_hrca_a.hrca05,
             hrca06 = g_hrca_a.hrca06,
             hrca07 = g_hrca_a.hrca07,
             hrca08 = g_hrca_a.hrca08,
             hrca09 = g_hrca_a.hrca09,
             hrca10 = g_hrca_a.hrca10,
             hrca11 = g_hrca_a.hrca11,
             hrca12 = g_hrca_a.hrca12,
             hrcaud02 = g_hrca_a.hrcaud02
       WHERE hrca01 = g_hrca_a_t.hrca01
       IF g_hrca_a.hrca11=g_hrca_a_t.hrca11 AND g_hrca_a.hrca12=g_hrca_a_t.hrca12 THEN
#        UPDATE hrcp_file
#           SET hrcp35='N',
#               hrcp04=' ',
#               hrcp05=' '
#         WHERE hrcp03>=g_hrca_a.hrca11
#           AND hrcp03<=g_hrca_a.hrca12
#           AND hrcp07<>'Y'
        ELSE
        SELECT greatest(g_hrca_a.hrca11,g_hrca_a_t.hrca11,g_hrca_a.hrca12,g_hrca_a_t.hrca12) INTO l_greatest FROM dual
        SELECT least(g_hrca_a.hrca11,g_hrca_a_t.hrca11,g_hrca_a.hrca12,g_hrca_a_t.hrca12) INTO l_least FROM dual
#        UPDATE hrcp_file
#           SET hrcp35='N',
#               hrcp04=' ',
#               hrcp05=' '
#         WHERE hrcp03>=l_least
#           AND hrcp03<=l_greatest
#           AND hrcp07<>'Y'
       END IF

      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","hrca_file",g_hrca_a_t.hrca01,"",SQLCA.sqlcode,"","",1) #No.FUN-66081
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   COMMIT WORK
    #add by zhuzw 20160108 start
      LET l_msg="ghrp084 Y '",g_hrca_a.hrca11,"' '",g_hrca_a.hrca12,"' '",g_hrca_a.hrca01,"' "
      CALL cl_cmdrun(l_msg)
   #add end
END FUNCTION

FUNCTION i041_q()
   MESSAGE ""
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CLEAR FORM
   CALL g_hrca.clear()
   DISPLAY '' TO FORMONLY.cnt
   CALL i041_curs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN i041_b_curs
   IF SQLCA.SQLCODE THEN
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_hrca_a.* TO NULL
   ELSE
      CALL i041_count()
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i041_fetch('F')
      CALL i041_b1_fill(g_wc)
    END IF
END FUNCTION

FUNCTION i041_fetch(p_flag)
   DEFINE   p_flag   LIKE type_file.chr1,
            l_abso   LIKE type_file.num10

   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     i041_b_curs INTO g_hrca_a.hrca01,g_hrca_a.hrca02,g_hrca_a.hrca03,g_hrca_a.hrca04,g_hrca_a.hrca05,
                                               g_hrca_a.hrca06,g_hrca_a.hrca07,g_hrca_a.hrca08,g_hrca_a.hrca09,g_hrca_a.hrca10,
                                               g_hrca_a.hrca11,g_hrca_a.hrca12,g_hrca_a.hrcaud02
      WHEN 'P' FETCH PREVIOUS i041_b_curs INTO g_hrca_a.hrca01,g_hrca_a.hrca02,g_hrca_a.hrca03,g_hrca_a.hrca04,g_hrca_a.hrca05,
                                               g_hrca_a.hrca06,g_hrca_a.hrca07,g_hrca_a.hrca08,g_hrca_a.hrca09,g_hrca_a.hrca10,
                                               g_hrca_a.hrca11,g_hrca_a.hrca12,g_hrca_a.hrcaud02
      WHEN 'F' FETCH FIRST    i041_b_curs INTO g_hrca_a.hrca01,g_hrca_a.hrca02,g_hrca_a.hrca03,g_hrca_a.hrca04,g_hrca_a.hrca05,
                                               g_hrca_a.hrca06,g_hrca_a.hrca07,g_hrca_a.hrca08,g_hrca_a.hrca09,g_hrca_a.hrca10,
                                               g_hrca_a.hrca11,g_hrca_a.hrca12,g_hrca_a.hrcaud02
      WHEN 'L' FETCH LAST     i041_b_curs INTO g_hrca_a.hrca01,g_hrca_a.hrca02,g_hrca_a.hrca03,g_hrca_a.hrca04,g_hrca_a.hrca05,
                                               g_hrca_a.hrca06,g_hrca_a.hrca07,g_hrca_a.hrca08,g_hrca_a.hrca09,g_hrca_a.hrca10,
                                               g_hrca_a.hrca11,g_hrca_a.hrca12,g_hrca_a.hrcaud02
      WHEN '/'
         IF (NOT g_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0
            PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()

                ON ACTION controlp
                   CALL cl_cmdask()

                ON ACTION help
                   CALL cl_show_help()

                ON ACTION about
                   CALL cl_about()

            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump i041_b_curs INTO g_hrca_a.hrca01,g_hrca_a.hrca02,g_hrca_a.hrca03,g_hrca_a.hrca04,g_hrca_a.hrca05,
                                                g_hrca_a.hrca06,g_hrca_a.hrca07,g_hrca_a.hrca08,g_hrca_a.hrca09,g_hrca_a.hrca10,
                                                g_hrca_a.hrca11,g_hrca_a.hrca12,g_hrca_a.hrcaud02
         LET g_no_ask = FALSE
   END CASE

   IF SQLCA.sqlcode THEN
      CALL cl_err(g_hrca_a.hrca01,SQLCA.sqlcode,0)
      INITIALIZE g_hrca_a.* TO NULL
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE

      CALL cl_navigator_setting(g_curs_index, g_row_count)

      CALL i041_show()
   END IF
END FUNCTION

FUNCTION i041_show()
   DISPLAY BY NAME g_hrca_a.hrca01,g_hrca_a.hrca02,g_hrca_a.hrca03,g_hrca_a.hrca04,g_hrca_a.hrca05,
                   g_hrca_a.hrca06,g_hrca_a.hrca07,g_hrca_a.hrca08,g_hrca_a.hrca09,g_hrca_a.hrca10,
                   g_hrca_a.hrca11,g_hrca_a.hrca12,g_hrca_a.hrcaud02
   SELECT hrbo03 INTO g_hrca_a.hrbo03 FROM hrbo_file
    WHERE hrbo02 = g_hrca_a.hrca04
   IF cl_null(g_hrca_a.hrca04) THEN
      LET g_hrca_a.hrbo03 = ''
   END IF
   DISPLAY BY NAME   g_hrca_a.hrbo03
   SELECT hrbp03 INTO g_hrca_a.hrbp03 FROM hrbp_file
    WHERE hrbp02 = g_hrca_a.hrca05
   IF cl_null(g_hrca_a.hrca05) THEN
      LET g_hrca_a.hrbp03 = ''
   END IF
   DISPLAY BY NAME g_hrca_a.hrbp03
   SELECT hrbpa03 INTO  g_hrca_a.hrbpa03 FROM hrbpa_file
           WHERE hrbpa05 = g_hrca_a.hrca05
             AND hrbpa02 = g_hrca_a.hrca06
   IF cl_null(g_hrca_a.hrca06) THEN
      LET g_hrca_a.hrbpa03 = ''
   END IF
   DISPLAY BY NAME g_hrca_a.hrbpa03

   SELECT hrbo03 INTO g_hrca_a.hrca10_1 FROM hrbo_file
    WHERE hrbo02 = g_hrca_a.hrca10
   IF cl_null(g_hrca_a.hrca10) THEN
      LET g_hrca_a.hrca10_1 = ''
   END IF
   DISPLAY BY NAME   g_hrca_a.hrca10_1
   CALL i041_b_fill(g_wc)
   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION i041_r()
   DEFINE   l_cnt   LIKE type_file.num5,
            l_hrca   RECORD LIKE hrca_file.*
DEFINE l_msg STRING
DEFINE l_hratid LIKE hrat_file.hratid
DEFINE l_i   LIKE type_file.num10
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_hrca_a.hrca01) THEN
      CALL cl_err('',-40,0)
      RETURN
   END IF
   BEGIN WORK
   IF cl_delh(0,0) THEN
#	   	   UPDATE hrcp_file
#	          SET hrcp35='N',
#	              hrcp04=' ',
#	              hrcp05=' '
#	        WHERE hrcp03>=g_hrca_a.hrca11
#	          AND hrcp03<=g_hrca_a.hrca12
#	          AND hrcp07<>'Y'

      DELETE FROM hrca_file
      WHERE hrca01 = g_hrca_a.hrca01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","hrca_file",g_hrca_a.hrca01,"",SQLCA.sqlcode,"","BODY DELETE",0)
      ELSE
      #add by zhuzw 20160108 start
         FOR l_i = 1 TO g_rec_b
                IF  g_hrca_a.hrca02 = '1' THEN
                    SELECT hratid INTO l_hratid FROM hrat_file
                     WHERE hrat01 =  g_hrca[l_i].hrca14
                  DELETE FROM hrdq_file
                   WHERE hrdq02 = g_hrca_a.hrca02
                     AND hrdq03 = l_hratid
                     AND hrdq05 BETWEEN g_hrca_a.hrca11 AND g_hrca_a.hrca12
                 ELSE
                   DELETE FROM hrdq_file
                    WHERE hrdq02 = g_hrca_a.hrca02
                      AND hrdq03 = g_hrca[l_i].hrca14
                      AND hrdq05 BETWEEN g_hrca_a.hrca11 AND g_hrca_a.hrca12
                 END IF
          END FOR
        #add by zhuzw 201601008 end
         CLEAR FORM
         CALL g_hrca.clear()
         CALL i041_count()
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i041_b_curs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i041_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE
            CALL i041_fetch('/')
         END IF
      END IF
   END IF
   COMMIT WORK
   CALL i041_b1_fill(g_wc)
END FUNCTION

FUNCTION i041_b()
   DEFINE   l_ac_t          LIKE type_file.num5,
            l_n             LIKE type_file.num5,
            l_m             LIKE type_file.num5,
            l_cnt           LIKE type_file.num5,
            l_gau01         LIKE type_file.num5,
            l_lock_sw       LIKE type_file.chr1,
            p_cmd           LIKE type_file.chr1,
            l_allow_insert  LIKE type_file.num5,
            l_allow_delete  LIKE type_file.num5
   DEFINE   l_count         LIKE type_file.num5
   DEFINE   ls_msg_o        STRING
   DEFINE   ls_msg_n        STRING
   DEFINE   l_hratid        LIKE hrat_file.hratid
   DEFINE l_msg STRING
   LET g_action_choice = ""
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_hrca_a.hrca01) THEN
      CALL cl_err('',-40,0)
      RETURN
   END IF

   CALL cl_opmsg('b')

   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   LET g_forupd_sql= "SELECT hrca13,hrca02,hrca14,hrca15 ",
                     "  FROM hrca_file ",
                     " WHERE hrca01 = ?  AND hrca13 = ? ",
                       " FOR UPDATE NOWAIT "
   DECLARE i041_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   LET l_ac_t = 0

   INPUT ARRAY g_hrca WITHOUT DEFAULTS FROM s_hrca.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         LET g_before_input_done = FALSE
         LET g_before_input_done = TRUE
         CALL cl_set_comp_entry("hrca15,hrca02_a",FALSE)
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         LET l_n  = ARR_COUNT()

         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_hrca_t.* = g_hrca[l_ac].*    #BACKUP
            OPEN i041_bcl USING g_hrca_a.hrca01,g_hrca[l_ac].hrca13
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN i041_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
#FUN-151022 wangjya
               FETCH i041_bcl INTO g_hrca[l_ac].*
                IF g_hrca_a.hrca02 = '1' THEN
                SELECT hrat01 INTO g_hrca[l_ac].hrca14 FROM hrat_file
                WHERE hratid=g_hrca[l_ac].hrca14
                END IF
               IF SQLCA.sqlcode THEN
                  CALL cl_err('FETCH i041_bcl:',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()
         END IF

      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_hrca[l_ac].* TO NULL

         SELECT MAX(hrca13)+1 INTO g_hrca[l_ac].hrca13 FROM hrca_file
          WHERE hrca01=g_hrca_a.hrca01
         IF cl_null(g_hrca[l_ac].hrca13) THEN
         	  LET g_hrca[l_ac].hrca13=1
         END IF

         LET g_hrca[l_ac].hrca02_a = g_hrca_a.hrca02
#         DISPLAY BY NAME g_hrca[l_ac].hrca02_a
         LET g_hrca_t.* = g_hrca[l_ac].*
         CALL cl_show_fld_cont()
#         NEXT FIELD hrca14
         NEXT FIELD hrca13

      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',901,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF

#         SELECT MAX(hrca13) INTO g_hrca[l_ac].hrca13 FROM hrca_file WHERE hrca01=g_hrca_a.hrca01
#         IF cl_null(g_hrca[l_ac].hrca13) THEN LET g_hrca[l_ac].hrca13=1 END IF
#         LET g_hrca[l_ac].hrca13 = g_hrca[l_ac].hrca13 + 1
          #add by zhuzw 20160108 start
          IF g_hrca_a.hrca02 = '1' THEN
             SELECT COUNT(*) INTO l_n FROM hrca_file
              WHERE hrca01 = g_hrca_a.hrca01
                AND hrca14 = l_hratid
             IF l_n = 1 THEN
                DELETE FROM hrca_file
                WHERE hrca01 = g_hrca_a.hrca01
                  AND hrca14 = l_hratid
                #add by zhuzw 20160108 start
                DELETE FROM hrdq_file
                 WHERE hrdq02 = g_hrca_a.hrca02
                   AND hrdq03 = l_hratid
                   AND hrdq05 BETWEEN g_hrca_a.hrca11 AND g_hrca_a.hrca12
                #add end
             END IF
          ELSE
             SELECT COUNT(*) INTO l_n FROM hrca_file
              WHERE hrca01 = g_hrca_a.hrca01
                AND hrca14 = g_hrca[l_ac].hrca14
             IF l_n = 1 THEN
                 DELETE FROM hrca_file
                 WHERE hrca01 = g_hrca_a.hrca01
                   AND hrca14 = g_hrca[l_ac].hrca14
                #add by zhuzw 20160108 start
                DELETE FROM hrdq_file
                 WHERE hrdq02 = g_hrca_a.hrca02
                   AND hrdq03 = g_hrca[l_ac].hrca14
                   AND hrdq05 BETWEEN g_hrca_a.hrca11 AND g_hrca_a.hrca12
                #add end
             END IF
          END IF
         #add end
              IF g_hrca_a.hrca02 = '1' THEN
                 INSERT INTO hrca_file(hrca01,hrca02,hrca03,hrca04,hrca05,
                                  hrca06,hrca07,hrca08,hrca09,hrca10,
                                  hrca11,hrca12,hrca13,hrca14,hrca15,hrcaud02)
                         VALUES (g_hrca_a.hrca01,g_hrca_a.hrca02,g_hrca_a.hrca03,g_hrca_a.hrca04,g_hrca_a.hrca05,
                                 g_hrca_a.hrca06,g_hrca_a.hrca07,g_hrca_a.hrca08,g_hrca_a.hrca09,g_hrca_a.hrca10,
                                 g_hrca_a.hrca11,g_hrca_a.hrca12,g_hrca[l_ac].hrca13,l_hratid,g_hrca[l_ac].hrca15,g_hrca_a.hrcaud02)
           ELSE
                 INSERT INTO hrca_file(hrca01,hrca02,hrca03,hrca04,hrca05,
                                  hrca06,hrca07,hrca08,hrca09,hrca10,
                                  hrca11,hrca12,hrca13,hrca14,hrca15,hrcaud02)
                         VALUES (g_hrca_a.hrca01,g_hrca_a.hrca02,g_hrca_a.hrca03,g_hrca_a.hrca04,g_hrca_a.hrca05,
                                 g_hrca_a.hrca06,g_hrca_a.hrca07,g_hrca_a.hrca08,g_hrca_a.hrca09,g_hrca_a.hrca10,
                                 g_hrca_a.hrca11,g_hrca_a.hrca12,g_hrca[l_ac].hrca13,g_hrca[l_ac].hrca14,g_hrca[l_ac].hrca15,g_hrca_a.hrcaud02)

            END IF
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","hrca_file",g_hrca_a.hrca01,"",SQLCA.sqlcode,"","",0)
               CANCEL INSERT
            END IF
             MESSAGE 'INSERT O.K'
             LET g_rec_b = g_rec_b + 1
             DISPLAY g_rec_b TO FORMONLY.cn2

      #FUN-160108 WJY
#      BEFORE FIELD hrca13
#           IF cl_null(g_hrca[l_ac].hrca13) THEN
#               SELECT MAX(hrca13)+1 INTO g_hrca[l_ac].hrca13 FROM hrca_file
#                WHERE hrca01=g_hrca_a.hrca01
#               IF cl_null(g_hrca[l_ac].hrca13) THEN
#               	 LET g_hrca[l_ac].hrca13=1
#               END IF
#           END IF
#
#      AFTER FIELD hrca13
#           IF NOT cl_null(g_hrca[l_ac].hrca13) THEN
#              IF g_hrca[l_ac].hrca13 != g_hrca_t.hrca13 OR
#                 g_hrca_t.hrca13 IS NULL THEN
#                 LET l_m = 0
#                 SELECT COUNT(*) INTO l_m FROM hrca_file
#                  WHERE hrca01=g_hrca_a.hrca01
#                    AND hrca13=g_hrca[l_ac].hrca13
#                 IF l_m > 0 THEN
#                    CALL cl_err(g_hrca[l_ac].hrca13,'-239',0)
#                    NEXT FIELD hrca13
#                 END IF
#              END IF
#           END IF
      #FUN-160108 WJY
      BEFORE FIELD hrca14
           IF g_hrca[l_ac].hrca13 IS NULL OR g_hrca[l_ac].hrca13 = 0 THEN
              SELECT max(hrca13)+1
                INTO g_hrca[l_ac].hrca13
                FROM hrca_file
               WHERE hrca01 = g_hrca_a.hrca01
              IF g_hrca[l_ac].hrca13 IS NULL THEN
                 LET g_hrca[l_ac].hrca13 = 1
              END IF
           END IF
           LET  g_hrca[l_ac].hrca02_a=  g_hrca_a.hrca02


      AFTER FIELD hrca14
         IF NOT cl_null(g_hrca[l_ac].hrca14) THEN
            IF g_hrca[l_ac].hrca14 != g_hrca_t.hrca14 OR g_hrca_t.hrca14 IS NULL THEN
               IF g_hrca_a.hrca02 = 1 THEN         #人员（工号）
                  SELECT hratid,hrat02 INTO l_hratid,g_hrca[l_ac].hrca15 FROM hrat_file
                   WHERE hrat01 =  g_hrca[l_ac].hrca14
                     AND hratconf = 'Y'
                   IF cl_null(l_hratid) THEN
                      CALL cl_err(g_hrca[l_ac].hrca14,'ghr-081',0)
                      NEXT FIELD hrca14
                   ELSE
                      DISPLAY BY NAME g_hrca[l_ac].hrca15
                   END IF
               END IF

               IF g_hrca_a.hrca02 = 2 OR g_hrca_a.hrca02 = 5 OR g_hrca_a.hrca02 = 6 THEN
                  SELECT hrao02 INTO g_hrca[l_ac].hrca15 FROM hrao_file
                   WHERE hrao01 = g_hrca[l_ac].hrca14
                     AND hraoacti = 'Y'
                  IF cl_null(g_hrca[l_ac].hrca15) THEN
                     CALL cl_err(g_hrca[l_ac].hrca14,'ghr-082',0)
                     NEXT FIELD hrca14
                  END IF
                  DISPLAY BY NAME g_hrca[l_ac].hrca15
               END IF

               IF g_hrca_a.hrca02 = 3 THEN
                  #FUN-160107 wjy
                  LET l_m = 0
                  SELECT COUNT(*) INTO l_m FROM hraa_file WHERE hraa01 = g_hrca[l_ac].hrca14
                  IF l_m = 0 THEN
                     CALL cl_err(g_hrca[l_ac].hrca14,'ghr-949',0)
                     NEXT FIELD hrca14
                  END IF
                  #FUN-160107 wjy
                  SELECT hraa02 INTO g_hrca[l_ac].hrca15 FROM hraa_file
                   WHERE hraa01 = g_hrca[l_ac].hrca14
                     AND hraaacti = 'Y'
                  IF cl_null(g_hrca[l_ac].hrca15) THEN
                     CALL cl_err(g_hrca[l_ac].hrca14,'ghr-082',0)
                     NEXT FIELD hrca14
                  END IF
                  DISPLAY BY NAME g_hrca[l_ac].hrca15
               END IF
               IF g_hrca_a.hrca02 = 4 THEN
                  #FUN-160107 wjy
                  LET l_m = 0
                  SELECT COUNT(*) INTO l_m FROM hrcb_file WHERE hrcb01 = g_hrca[l_ac].hrca14
                  IF l_m = 0 THEN
                     CALL cl_err(g_hrca[l_ac].hrca14,'ghr-101',0)
                     NEXT FIELD hrca14
                  END IF
                  #FUN-160107 wjy
                  SELECT DISTINCT  hrcb02 INTO g_hrca[l_ac].hrca15 FROM hrcb_file
                   WHERE hrcb01 = g_hrca[l_ac].hrca14
                  IF cl_null(g_hrca[l_ac].hrca15) THEN
                     CALL cl_err(g_hrca[l_ac].hrca14,'ghr-082',0)
                     NEXT FIELD hrca14
                  END IF
                  DISPLAY BY NAME g_hrca[l_ac].hrca15
               END IF
            END IF
#            NEXT FIELD hrca14
         END IF

      BEFORE DELETE
         IF NOT cl_null(g_hrca_t.hrca13) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM hrca_file WHERE hrca01 = g_hrca_a.hrca01
                                    AND hrca13 = g_hrca[l_ac].hrca13
#            UPDATE hrcp_file
#              SET hrcp35='N',
#                  hrcp04=' ',
#                  hrcp05=' '
#            WHERE hrcp03>=g_hrca_a.hrca11
#              AND hrcp03<=g_hrca_a.hrca12
#              AND hrcp07<>'Y'
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","hrca_file",g_hrca_t.hrca13,"",SQLCA.sqlcode,"","",0)
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b = g_rec_b - 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK

      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',901,0)
            LET INT_FLAG = 0
            LET g_hrca[l_ac].* = g_hrca_t.*
            CLOSE i041_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_hrca[l_ac].hrca13,-263,1)
            LET g_hrca[l_ac].* = g_hrca_t.*
         ELSE
         	 IF g_hrca_a.hrca02 = 1 THEN
         	 	LET g_hrca[l_ac].hrca14=l_hratid
         	 END IF
            UPDATE hrca_file
               SET hrca13 = g_hrca[l_ac].hrca13,
                   hrca14 = g_hrca[l_ac].hrca14,
                   hrca15 = g_hrca[l_ac].hrca15
             WHERE hrca01 = g_hrca_a.hrca01
               AND hrca13 = g_hrca_t.hrca13
#             	  UPDATE hrcp_file
#             	    SET hrcp35='N',
#             	        hrcp04=' ',
#             	        hrcp05=' '
#             	  WHERE hrcp03>=g_hrca_a.hrca11
#             	    AND hrcp03<=g_hrca_a.hrca12
#             	    AND hrcp07<>'Y'
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","hrca_file",g_hrca_t.hrca13,"",SQLCA.sqlcode,"","",0)
               LET g_hrca[l_ac].* = g_hrca_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
            END IF
         END IF

      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
#         IF g_hrca[l_ac].hrca14 != g_hrca_t.hrca14 OR g_hrca_t.hrca14 IS NULL THEN
#            CALL cl_err('',901,0)
#         END IF
         IF INT_FLAG THEN
            CALL cl_err('',901,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_hrca[l_ac].* = g_hrca_t.*
            END IF
            CLOSE i041_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE i041_bcl
         COMMIT WORK

      ON ACTION CONTROLO
         IF INFIELD(hrca03) AND l_ac > 1 THEN
            LET g_hrca[l_ac].* = g_hrca[l_ac-1].*
            NEXT FIELD hrca03
         END IF

      ON ACTION CONTROLG
          CALL cl_cmdask()

      ON ACTION CONTROLZ
         CALL cl_show_req_fields()

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(hrca14)
                  CALL cl_init_qry_var()
                  IF g_hrca_a.hrca02 = 1 THEN
                  LET g_qryparam.form = "q_hrat01"
                    END IF
{                  IF g_hrca_a.hrca02 = 2 THEN
                    LET g_qryparam.form = "q_hrao01_1"
                  END IF}
                  IF g_hrca_a.hrca02 = 3 THEN
                    LET g_qryparam.form = "q_hraa01"
                  END IF
                  IF g_hrca_a.hrca02 = 4 THEN
                    LET g_qryparam.form = "q_hrcb"
                  END IF
                  IF g_hrca_a.hrca02 = 2 THEN
#                    LET g_qryparam.form = "q_hrao01_1"   #FUN-160107 WJY mark
                    LET g_qryparam.form = "q_hrao01_2"    #FUN-160107 WJY add
                    LET g_qryparam.arg1='1'
                  END IF
                  IF g_hrca_a.hrca02 = 5 THEN
                    LET g_qryparam.form = "cq_hrao01"
                    LET g_qryparam.arg1='2'
                  END IF
                  IF g_hrca_a.hrca02 = 6 THEN
                    LET g_qryparam.form = "cq_hrao01"
                    LET g_qryparam.arg1='3'
                  END IF
                  LET g_qryparam.default1 = g_hrca[l_ac].hrca14
                  IF  cl_null(g_hrca[l_ac].hrca14) OR p_cmd != 'u' THEN #add by zhuzw 20160108
                     LET g_qryparam.state = "c"
#                     CALL cl_create_qry() RETURNING g_hrca[l_ac].hrca14
                     CALL cl_create_qry() RETURNING g_mulit_res
                     IF NOT cl_null(g_mulit_res) THEN
                        CALL i041_b_mulit()
                        CALL i041_show()
                     END IF
                  ELSE
                  	 CALL cl_create_qry() RETURNING   g_hrca[l_ac].hrca14
                  END IF
#                  CALL i041_b_mulit(g_mulit_res)
#                  CALL i041_b_fill(g_wc)
                  DISPLAY BY NAME g_hrca[l_ac].hrca14
                  NEXT FIELD hrca14
            OTHERWISE
               EXIT CASE
         END CASE

      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION help
         CALL cl_show_help()

      ON ACTION about
         CALL cl_about()
     ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

   END INPUT
   CALL i041_b_fill(g_wc)
   CLOSE i041_bcl
   COMMIT WORK
   #add by zhuzw 20160108 start
      LET l_msg="ghrp084 Y '",g_hrca_a.hrca11,"' '",g_hrca_a.hrca12,"' '",g_hrca_a.hrca01,"' "
      CALL cl_cmdrun(l_msg)
   #add end
END FUNCTION


FUNCTION i041_b_fill(p_wc)               #BODY FILL UP

   DEFINE p_wc         STRING #No.FUN-680135 VARCHAR(30)
#    LET p_wc = cl_replace_str(p_wc,"hrca02","hrca02_a")
    IF NOT cl_null(p_wc) THEN
       LET g_sql = "SELECT hrca13,hrca02,hrca14,hrca15 ",
                   "  FROM hrca_file ",
                   " WHERE ",p_wc CLIPPED," AND hrca01 = '",g_hrca_a.hrca01,"'",
                   " ORDER BY hrca13 "
    ELSE
       LET g_sql = "SELECT hrca13,hrca02,hrca14,hrca15 ",
                "  FROM hrca_file ",
                " WHERE hrca01 = '",g_hrca_a.hrca01,"'",
                " ORDER BY hrca13 "
    END IF

    PREPARE i041_prepare2 FROM g_sql
    DECLARE hrca_curs CURSOR FOR i041_prepare2

    CALL g_hrca.clear()

    LET g_cnt = 1
    LET g_rec_b = 0

    FOREACH hrca_curs INTO g_hrca[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF  g_hrca_a.hrca02 = 1 THEN
          SELECT hrat01 INTO g_hrca[g_cnt].hrca14 FROM hrat_file
           WHERE hratid = g_hrca[g_cnt].hrca14
       END IF
       LET g_rec_b = g_rec_b + 1

       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_hrca.deleteElement(g_cnt)

    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION i041_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL SET_COUNT(g_rec_b)

  DIALOG ATTRIBUTES(UNBUFFERED)
   DISPLAY ARRAY g_hrca TO s_hrca.* ATTRIBUTE(COUNT=g_rec_b)

      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)

      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()

      ON ACTION insert
         LET g_action_choice='insert'
         #EXIT DISPLAY
         EXIT DIALOG

      ON ACTION query
         LET g_action_choice='query'
         #EXIT DISPLAY
         EXIT DIALOG

      --* zhoumj 20160113 --
      ON ACTION Work_plan
         LET g_action_choice='Work_plan'
         EXIT DIALOG
      -- zhoumj 20160113 *--

      ON ACTION modify
         LET g_action_choice='modify'
         #EXIT DISPLAY
         EXIT DIALOG

     ON ACTION delete
        LET g_action_choice='delete'
         #EXIT DISPLAY
         EXIT DIALOG

      ON ACTION detail
         LET g_action_choice='detail'
         LET l_ac = ARR_CURR()
         #EXIT DISPLAY
         EXIT DIALOG

      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         #EXIT DISPLAY
         EXIT DIALOG

      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         #EXIT DISPLAY
         EXIT DIALOG

      ON ACTION first
         CALL i041_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)
         END IF
         #ACCEPT DISPLAY
         ACCEPT DIALOG

      ON ACTION previous
         CALL i041_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)
         END IF
         #ACCEPT DISPLAY
         ACCEPT DIALOG

      ON ACTION jump
         CALL i041_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)
         END IF
         #ACCEPT DISPLAY
         ACCEPT DIALOG

      ON ACTION next
         CALL i041_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         #ACCEPT DISPLAY
         ACCEPT DIALOG

      ON ACTION last
         CALL i041_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         #ACCEPT DISPLAY
         ACCEPT DIALOG

       ON ACTION help
          LET g_action_choice='help'
         #EXIT DISPLAY
         EXIT DIALOG

      ON ACTION exit
         LET g_action_choice='exit'
         #EXIT DISPLAY
         EXIT DIALOG

      ON ACTION close
         LET g_action_choice='exit'
         #EXIT DISPLAY
         EXIT DIALOG

      ON ACTION controlg
         LET g_action_choice="controlg"
         #EXIT DISPLAY
         EXIT DIALOG

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         #CONTINUE DISPLAY
         CONTINUE DIALOG

      ON ACTION about
         CALL cl_about()

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         #EXIT DISPLAY
         EXIT DIALOG

      AFTER DISPLAY
         #CONTINUE DISPLAY
         CONTINUE DIALOG

     ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

    END DISPLAY

    DISPLAY ARRAY g_hrca_1 TO s_hrca_1.* ATTRIBUTE(COUNT=g_rec_b1)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
      BEFORE ROW
         LET l_ac1 = ARR_CURR()
         CALL cl_show_fld_cont()

      ON ACTION accept
         LET l_ac1 = ARR_CURR()
         LET g_jump = l_ac1
         LET g_no_ask = TRUE
         LET g_bp_flag = NULL
         CALL i041_fetch('/')
         CALL cl_set_comp_visible("Page3", FALSE)
         CALL ui.interface.refresh()                  #NO.FUN-840018 ADD
         CALL cl_set_comp_visible("Page3", TRUE)
         EXIT DIALOG

      ON ACTION insert
         LET g_action_choice="insert"
         #EXIT DISPLAY
         EXIT DIALOG

      ON ACTION query
         LET g_action_choice="query"
         #EXIT DISPLAY
         EXIT DIALOG

      ON ACTION modify
         LET g_action_choice="modify"
         #EXIT DISPLAY
         EXIT DIALOG

      --* zhoumj 20160113 --
      ON ACTION Work_plan
         LET g_action_choice='Work_plan'
         EXIT DIALOG
      -- zhoumj 20160113 *--

      ON ACTION help
        LET g_action_choice="help"
        #EXIT DISPLAY
        EXIT DIALOG

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

      ON ACTION exit
         LET g_action_choice="exit"
         #EXIT DISPLAY
         EXIT DIALOG

      ON ACTION controlg
         LET g_action_choice="controlg"
         #EXIT DISPLAY
         EXIT DIALOG

      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         #EXIT DISPLAY
         EXIT DIALOG

      ON ACTION close
         LET g_action_choice="exit"
         #EXIT DISPLAY
         EXIT DIALOG

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         #CONTINUE DISPLAY
         CONTINUE DIALOG

      ON ACTION about
         CALL cl_about()

      AFTER DISPLAY
         #CONTINUE DISPLAY
         CONTINUE DIALOG

      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

#      ON ACTION related_document
#         LET g_action_choice="related_document"
#         #EXIT DISPLAY
#         EXIT DIALOG
   END DISPLAY

   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i041_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
    CALL cl_set_comp_entry("hrca01",FALSE)
    IF g_hrca_a.hrca03 = 1 THEN
       CALL cl_set_comp_entry("hrca05,hrca06",FALSE)
    ELSE
    	 CALL cl_set_comp_entry("hrca05,hrca06",TRUE)
    END IF
    IF NOT cl_null(g_hrca_a.hrca07)  THEN
       CALL cl_set_comp_entry("hrca08,hrca09",TRUE)
    END IF
    #FUN-160107 wjy
    IF p_cmd='u' THEN
       CALL cl_set_comp_entry("hrca02",FALSE)
    END IF
    #FUN-160107 wjy
END FUNCTION

FUNCTION i041_b1_fill(p_wc)
DEFINE p_wc     STRING
DEFINE l_sql    STRING
DEFINE l_i      LIKE   type_file.num5


        CALL g_hrca_1.clear()
        LET l_sql = " SELECT DISTINCT hrca01,hrca02,hrca03,hrca04,'',  ",
                    "        hrca11,hrca12,hrca05,'',hrca06,  ",
                    "        '',hrca07,hrca08,hrca09,hrca10,'' ",
                    "  FROM hrca_file ",
                    " WHERE ",p_wc CLIPPED,
                    " ORDER BY hrca01 "

        PREPARE i041_b1_pre FROM l_sql
        DECLARE i041_b1_cs CURSOR FOR i041_b1_pre

        LET l_i=1

        FOREACH i041_b1_cs INTO g_hrca_1[l_i].*
            SELECT hrbo03 INTO g_hrca_1[l_i].hrbo03 FROM hrbo_file
              WHERE hrbo02 = g_hrca_1[l_i].hrca04
            SELECT hrbp03 INTO g_hrca_1[l_i].hrbp03 FROM hrbp_file
              WHERE hrbp02 = g_hrca_1[l_i].hrca05
            SELECT hrbpa03 INTO g_hrca_1[l_i].hrbpa03 FROM hrbpa_file
              WHERE hrbpa05 = g_hrca_1[l_i].hrca05
                AND hrbpa02 = g_hrca_1[l_i].hrca06
            SELECT hrbo03 INTO g_hrca_1[l_i].hrbo03_2 FROM hrbo_file
              WHERE hrbo02 = g_hrca_1[l_i].hrca10

           LET l_i=l_i+1

           IF l_i > g_max_rec THEN
              IF g_action_choice ="query"  THEN   #CHI-BB0034 add
                 CALL cl_err( '', 9035, 0 )
              END IF                              #CHI-BB0034 add
              EXIT FOREACH
           END IF
        END FOREACH
        CALL g_hrca_1.deleteElement(l_i)
        LET g_rec_b1 = l_i - 1

END FUNCTION

FUNCTION i041_b_mulit()
#  DEFINE  p_mulit_hrat   STRING
  DEFINE  tok            base.StringTokenizer
  DEFINE  l_hrca14       LIKE hrca_file.hrca14
  DEFINE  l_n            LIKE type_file.num5
  DEFINE  l_t            LIKE type_file.num5
  DEFINE  l_num,l_m      LIKE type_file.num5
  DEFINE  l_hratid2      LIKE hrat_file.hratid
  DEFINE  l_err		    STRING
  DEFINE  l_hrca13       LIKE hrca_file.hrca13
  DEFINE  l_hrca        RECORD
                         hrca13          LIKE hrca_file.hrca13,
                         hrca02_a        LIKE hrca_file.hrca02,
                         hrca14          LIKE hrca_file.hrca14,
                         hrca15          LIKE hrca_file.hrca15
                         END RECORD

  LET l_n = 1
  LET tok = base.StringTokenizer.create(g_mulit_res,"|")
  WHILE tok.hasMoreTokens()
     LET l_hrca14 = tok.nextToken()
     IF l_n > 1 THEN
        CALL g_hrca.appendElement()
     END IF
     LET l_num = g_hrca.getLength()

      SELECT MAX(hrca13)+1 INTO l_hrca13 FROM hrca_file WHERE hrca01=g_hrca_a.hrca01
      IF cl_null(l_hrca13) THEN
         LET l_hrca13 = 1
      END IF

     LET l_hrca.hrca14 = l_hrca14
     LET l_hrca.hrca13 = l_hrca13
     LET l_hrca.hrca02_a = g_hrca_a.hrca02

     SELECT hratid,hrat02 INTO l_hratid2,l_hrca.hrca15
       FROM hrat_file
      WHERE hrat01 = l_hrca.hrca14
        AND hratconf = 'Y'

     IF NOT cl_null(l_hrca.hrca14) THEN
         IF g_hrca_a.hrca02 = 1 THEN
            SELECT hratid,hrat02 INTO l_hratid2,l_hrca.hrca15 FROM hrat_file
             WHERE hrat01 =  l_hrca.hrca14
               AND hratconf = 'Y'

             IF cl_null(l_hratid2) THEN
                CALL cl_err(l_hratid2,'ghr-081',0)
                CONTINUE WHILE
             END IF
             IF NOT cl_null(l_hratid2) THEN
             	 LET l_m = 0
                SELECT COUNT(*) INTO l_m FROM hrca_file
                 WHERE hrca01 = g_hrca_a.hrca01
#                   AND hrca13 = l_hrca.hrca13  #FUN-160107 wjy
                   AND hrca14 = l_hratid2
                IF l_m > 0 THEN
                   CALL cl_err(l_hrca.hrca14,-239,0)
                   LET l_hrca.hrca14 = g_hrca_t.hrca14
                   CONTINUE WHILE
                END IF
             END IF
#             DISPLAY l_hrca.hrca15 TO hrca15
         END IF

         IF g_hrca_a.hrca02 = 2 THEN
            SELECT hrao02 INTO l_hrca.hrca15 FROM hrao_file
             WHERE hrao01 = l_hrca.hrca14
               AND hraoacti = 'Y'
            IF cl_null(l_hrca.hrca15) THEN
               CALL cl_err(l_hrca.hrca14,'ghr-082',0)
               CONTINUE WHILE
            END IF
#            DISPLAY l_hrca.hrca15 TO hrca15
         END IF
         IF g_hrca_a.hrca02 = 3 THEN
            SELECT hraa02 INTO l_hrca.hrca15 FROM hraa_file
             WHERE hraa01 = l_hrca.hrca14
               AND hraaacti = 'Y'
            IF cl_null(l_hrca.hrca15) THEN
               CALL cl_err(l_hrca.hrca14,'ghr-082',0)
               CONTINUE WHILE
            END IF
#            DISPLAY l_hrca.hrca15 TO hrca15
         END IF
         IF g_hrca_a.hrca02 = 4 THEN
            SELECT DISTINCT  hrcb02 INTO l_hrca.hrca15 FROM hrcb_file
             WHERE hrcb01 = l_hrca.hrca14

            IF cl_null(l_hrca.hrca15) THEN
               CALL cl_err(l_hrca.hrca14,'ghr-082',0)
               CONTINUE WHILE
            END IF
#            DISPLAY l_hrca.hrca15 TO hrca15
         END IF
         IF g_hrca_a.hrca02 = 5 THEN
            SELECT hrao02 INTO l_hrca.hrca15 FROM hrao_file
             WHERE hrao01 = l_hrca.hrca14
               AND hraoacti = 'Y'
            IF cl_null(l_hrca.hrca15) THEN
               CALL cl_err(l_hrca.hrca14,'ghr-082',0)
               CONTINUE WHILE
            END IF
#            DISPLAY l_hrca.hrca15 TO hrca15
         END IF
          IF g_hrca_a.hrca02 = 6 THEN
            SELECT hrao02 INTO l_hrca.hrca15 FROM hrao_file
             WHERE hrao01 = l_hrca.hrca14
               AND hraoacti = 'Y'
            IF cl_null(l_hrca.hrca15) THEN
               CALL cl_err(l_hrca.hrca14,'ghr-082',0)
               CONTINUE WHILE
            END IF
#            DISPLAY l_hrca.hrca15 TO hrca15
         END IF
     ELSE
         CALL cl_err('人群编号','azz-527',1)
         #NEXT FIELD hrca14
     END IF

     IF g_hrca_a.hrca02 = 1 THEN
         INSERT INTO hrca_file(hrca01,hrca02,hrca03,hrca04,hrca05,hrca06,hrca07,hrca08,hrca09,hrca10,hrca11,
                     hrca12,hrca13,hrca14,hrca15,hrcaud02)
             VALUES(g_hrca_a.hrca01,g_hrca_a.hrca02,g_hrca_a.hrca03,g_hrca_a.hrca04,g_hrca_a.hrca05,
                    g_hrca_a.hrca06,g_hrca_a.hrca07,g_hrca_a.hrca08,g_hrca_a.hrca09,g_hrca_a.hrca10,
                    g_hrca_a.hrca11,g_hrca_a.hrca12,l_hrca.hrca13,l_hratid2,l_hrca.hrca15,g_hrca_a.hrcaud02)
     ELSE
         INSERT INTO hrca_file(hrca01,hrca02,hrca03,hrca04,hrca05,hrca06,hrca07,hrca08,hrca09,hrca10,hrca11,
                               hrca12,hrca13,hrca14,hrca15,hrcaud02)
               VALUES(g_hrca_a.hrca01,g_hrca_a.hrca02,g_hrca_a.hrca03,g_hrca_a.hrca04,g_hrca_a.hrca05,
                      g_hrca_a.hrca06,g_hrca_a.hrca07,g_hrca_a.hrca08,g_hrca_a.hrca09,g_hrca_a.hrca10,
                      g_hrca_a.hrca11,g_hrca_a.hrca12,l_hrca.hrca13,l_hrca.hrca14,l_hrca.hrca15,g_hrca_a.hrcaud02)
     END IF
     IF STATUS THEN
        CALL s_errmsg('hrca14',l_hrca.hrca14,'hrca_file:',STATUS,1)
        CONTINUE WHILE
     END IF
     LET l_n = l_n + 1
  END WHILE
  LET l_n = l_n - 1

#  DISPLAY ARRAY g_hrat  TO s_hrat.*
#     BEFORE DISPLAY
#        EXIT DISPLAY
#
#  END DISPLAY
# CALL i041_b_fill(g_wc)

END FUNCTION
