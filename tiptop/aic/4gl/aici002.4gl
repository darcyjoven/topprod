# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: aici002.4gl
# Descriptions...: ICD產業主檔分群維護作業
# Date & Author..: No.FUN-7B0076 07/11/21 By johnray
# Modify.........: No.FUN-850068 08/05/15 By TSD.Wind 自定欄位功能修改
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤 

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.TQC-C40075 12/04/11 By xianghui 查詢時增加iccoriu,iccorig
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_icc       RECORD LIKE icc_file.*,
       g_icc_t     RECORD LIKE icc_file.*,            #備份舊值
       g_icc01_t  LIKE icc_file.icc01                 #Key值備份
DEFINE g_wc                  STRING
DEFINE g_sql                 STRING                   #組 sql 用
DEFINE g_forupd_sql          STRING                   #SELECT ... FOR UPDATE  SQL
DEFINE g_before_input_done   LIKE type_file.num5      #判斷是否已執行 Before Input指令
DEFINE g_chr                 LIKE type_file.chr1
DEFINE g_cnt                 LIKE type_file.num10
DEFINE g_i                   LIKE type_file.num5      #count/index for any purpose
DEFINE g_msg                 LIKE type_file.chr1000
DEFINE g_curs_index          LIKE type_file.num10
DEFINE g_row_count           LIKE type_file.num10     #總筆數
DEFINE g_jump                LIKE type_file.num10     #查詢指定的筆數
DEFINE mi_no_ask             LIKE type_file.num5      #是否開啟指定筆視窗
DEFINE g_str                 STRING
 
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5,
        g_time          LIKE type_file.chr8
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT                            #擷取中斷鍵
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIC")) THEN
      EXIT PROGRAM
   END IF
 
   IF (NOT s_industry("icd")) THEN
      CALL cl_err('','aic-999',1)
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_forupd_sql = "SELECT * FROM icc_file WHERE icc01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i002_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   LET p_row = 5 LET p_col = 10
 
   OPEN WINDOW i002_w AT p_row,p_col WITH FORM "aic/42f/aici002"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   LET g_action_choice = ""
   CALL i002_menu()
 
   CLOSE WINDOW i002_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION i002_curs()
 
    CLEAR FORM
    INITIALIZE g_icc.* TO NULL
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取條件
                      icc01,icc04,icc05,icc09,icc11,
                      icc12,icc14,icc06,icc07,icc08,
                      icc27,icc13,icc15,icc10,icc16,
                      icc17,icc18,icc30,icc32,icc34,
                      icc36,icc38,icc19,icc20,icc33,
                      icc35,icc37,icc21,icc22,icc23,
                      icc25,icc26,iccuser,iccmodu,
                      iccgrup,iccdate,iccacti,iccoriu,iccorig,                          #TQC-C40075  add  iccoriu,iccorig
                      #FUN-850068   ---start---
                      iccud01,iccud02,iccud03,iccud04,iccud05,
                      iccud06,iccud07,iccud08,iccud09,iccud10,
                      iccud11,iccud12,iccud13,iccud14,iccud15
                      #FUN-850068    ----end----
 
      BEFORE CONSTRUCT
        CALL cl_qbe_init()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(icc01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_icc"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO icc01
                 NEXT FIELD icc01
 
              WHEN INFIELD(icc08)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pmc1"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO icc08
                 NEXT FIELD icc08
 
              WHEN INFIELD(icc11)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pmc1"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO icc11
                 NEXT FIELD icc11
 
              WHEN INFIELD(icc07)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_icd1"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.arg1 = "K"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO icc07
                 NEXT FIELD icc07
 
              WHEN INFIELD(icc09)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_icd1"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.arg1 = "M"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO icc09
                 NEXT FIELD icc09
 
              WHEN INFIELD(icc12)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_icd1"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.arg1 = "J"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO icc12
                 NEXT FIELD icc12
 
              WHEN INFIELD(icc14)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_icd1"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.arg1 = "L"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO icc14
                 NEXT FIELD icc14
 
              WHEN INFIELD(icc15)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_icd1"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.arg1 = "N"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO icc15
                 NEXT FIELD icc15
 
              WHEN INFIELD(iccuser)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_zx"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO iccuser
                 NEXT FIELD iccuser
 
              WHEN INFIELD(iccmodu)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_zx"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO iccmodu
                 NEXT FIELD iccmodu
 
              WHEN INFIELD(iccgrup)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO iccgrup
                 NEXT FIELD iccgrup
 
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
 
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                              #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND iccuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                              #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND iccgrup LIKE '",g_grup CLIPPED,"%'"
        #CHI-8A0001 寫ora
    #    END IF
    #    IF g_priv3 MATCHES "[5678]" THEN
    #        LET g_wc = g_wc clipped," AND iccgrup IN",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('iccuser', 'iccgrup')
    #End:FUN-980030
 
    LET g_sql = "SELECT icc01 FROM icc_file ", #組合出 SQL 指令
                " WHERE ",g_wc CLIPPED,
                " ORDER BY icc01"
 
    PREPARE i002_prepare FROM g_sql
    DECLARE i002_cs                                  # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i002_prepare
 
    LET g_sql = "SELECT COUNT(*) FROM icc_file WHERE ",g_wc CLIPPED
    PREPARE i002_precount FROM g_sql
    DECLARE i002_count CURSOR FOR i002_precount
END FUNCTION
 
FUNCTION i002_menu()
 
   MENU ""
      BEFORE MENU
         CALL cl_navigator_setting(g_curs_index,g_row_count)
 
      ON ACTION insert
         LET g_action_choice="insert"
         IF cl_chk_act_auth() THEN
            CALL i002_a()
         END IF
 
      ON ACTION query
         LET g_action_choice="query"
         IF cl_chk_act_auth() THEN
            CALL i002_q()
         END IF
 
      ON ACTION next
         CALL i002_fetch('N')
 
      ON ACTION previous
         CALL i002_fetch('P')
 
      ON ACTION modify
         LET g_action_choice="modify"
         IF cl_chk_act_auth() THEN
            CALL i002_u()
         END IF
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         IF cl_chk_act_auth() THEN
            CALL i002_x()
         END IF
 
      ON ACTION output
         IF cl_chk_act_auth() THEN
            CALL i002_out()
         END IF
 
      ON ACTION delete
         LET g_action_choice="delete"
         IF cl_chk_act_auth() THEN
            CALL i002_r()
         END IF
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         IF cl_chk_act_auth() THEN
            CALL i002_copy()
         END IF
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION exit
         LET g_action_choice = "exit"
         EXIT MENU
 
      ON ACTION jump
         CALL i002_fetch('/')
 
      ON ACTION first
         CALL i002_fetch('F')
 
      ON ACTION last
         CALL i002_fetch('L')
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE MENU
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
         LET INT_FLAG = FALSE
         LET g_action_choice = "exit"
         EXIT MENU
 
      ON ACTION related_document
         LET g_action_choice="related_document"
         IF cl_chk_act_auth() THEN
            IF NOT cl_null(g_icc.icc01) THEN
               LET g_doc.column1 = "icc01"
               LET g_doc.value1 = g_icc.icc01
               CALL cl_doc()
            ELSE
               CALL cl_err('',-400,0)
            END IF
         END IF
 
    END MENU
    CLOSE i002_cs
END FUNCTION
 
FUNCTION i002_a()
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_icc.* LIKE icc_file.*
    LET g_icc.icc06 = '1'
    LET g_icc.icc30 = 'N'
    INITIALIZE g_icc_t.* LIKE icc_file.*
    LET g_icc01_t = NULL
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_icc.iccuser = g_user
        LET g_icc.iccoriu = g_user #FUN-980030
        LET g_icc.iccorig = g_grup #FUN-980030
        LET g_icc.iccgrup = g_grup
        LET g_icc.iccdate = g_today
        LET g_icc.iccacti = 'Y'
        CALL i002_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
           LET INT_FLAG = 0
           INITIALIZE g_icc.* TO NULL
           LET g_icc01_t = NULL
           CALL cl_err('',9001,0)
           CLEAR FORM
           EXIT WHILE
        END IF
        IF cl_null(g_icc.icc01) THEN             # KEY 不可空白
           CONTINUE WHILE
        END IF
        INSERT INTO icc_file VALUES(g_icc.*)
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
           CALL cl_err3("ins","icc_file",g_icc.icc01,"",SQLCA.sqlcode,"","",0)
           CONTINUE WHILE
        ELSE
           SELECT icc01 INTO g_icc.icc01 FROM icc_file
            WHERE icc01 = g_icc.icc01
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc = NULL
END FUNCTION
 
FUNCTION i002_i(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1
DEFINE   l_cnt     LIKE type_file.num5
 
   INPUT BY NAME g_icc.icc01,g_icc.icc04, g_icc.iccoriu,g_icc.iccorig,
                 g_icc.icc05,g_icc.icc09,
                 g_icc.icc11,g_icc.icc12,
                 g_icc.icc14,g_icc.icc06,
                 g_icc.icc07,g_icc.icc08,
                 g_icc.icc27,g_icc.icc13,
                 g_icc.icc15,g_icc.icc10,
                 g_icc.icc16,g_icc.icc17,
                 g_icc.icc18,g_icc.icc30,
                 g_icc.icc32,g_icc.icc34,
                 g_icc.icc36,g_icc.icc38,
                 g_icc.icc19,g_icc.icc20,
                 g_icc.icc33,g_icc.icc35,
                 g_icc.icc37,g_icc.icc21,
                 g_icc.icc22,g_icc.icc23,
                 g_icc.icc25,g_icc.icc26,
                 #FUN-850068     ---start---
                 g_icc.iccud01,g_icc.iccud02,g_icc.iccud03,g_icc.iccud04,
                 g_icc.iccud05,g_icc.iccud06,g_icc.iccud07,g_icc.iccud08,
                 g_icc.iccud09,g_icc.iccud10,g_icc.iccud11,g_icc.iccud12,
                 g_icc.iccud13,g_icc.iccud14,g_icc.iccud15 
                 #FUN-850068     ----end----
      WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL i002_set_entry(p_cmd)
          CALL i002_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
 
      AFTER FIELD icc01
         IF NOT cl_null(g_icc.icc01) THEN
            IF p_cmd = 'a' OR
              (p_cmd = 'u' AND g_icc.icc01 != g_icc_t.icc01) THEN
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt
                 FROM icc_file
                WHERE icc01 = g_icc.icc01
               IF l_cnt > 0 THEN
                  CALL cl_err(g_icc.icc01,-239,0)
                  LET g_icc.icc01 = g_icc_t.icc01
                  DISPLAY BY NAME g_icc.icc01
                  NEXT FIELD icc01
               END IF
            END IF
         END IF
 
      AFTER FIELD icc07
        IF NOT cl_null(g_icc.icc07) THEN
           CALL i002_icd_chk(g_icc.icc07,'K')
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_icc.icc07,g_errno,0)
              LET g_icc.icc07 = g_icc_t.icc07
              DISPLAY BY NAME g_icc.icc07
              NEXT FIELD icc07
           END IF
        END IF
 
      AFTER FIELD icc09
        IF NOT cl_null(g_icc.icc09) THEN
           CALL i002_icd_chk(g_icc.icc09,'M')
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_icc.icc09,g_errno,0)
              LET g_icc.icc09 = g_icc_t.icc09
              DISPLAY BY NAME g_icc.icc09
              NEXT FIELD icc09
           END IF
        END IF
 
      AFTER FIELD icc12
        IF NOT cl_null(g_icc.icc12) THEN
           CALL i002_icd_chk(g_icc.icc12,'J')
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_icc.icc12,g_errno,0)
              LET g_icc.icc12 = g_icc_t.icc12
              DISPLAY BY NAME g_icc.icc12
              NEXT FIELD icc12
           END IF
        END IF
 
      AFTER FIELD icc14
        IF NOT cl_null(g_icc.icc14) THEN
           CALL i002_icd_chk(g_icc.icc14,'L')
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_icc.icc14,g_errno,0)
              LET g_icc.icc14 = g_icc_t.icc14
              DISPLAY BY NAME g_icc.icc14
              NEXT FIELD icc14
           END IF
        END IF
 
      AFTER FIELD icc15
        IF NOT cl_null(g_icc.icc15) THEN
           CALL i002_icd_chk(g_icc.icc15,'N')
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_icc.icc15,g_errno,0)
              LET g_icc.icc15 = g_icc_t.icc15
              DISPLAY BY NAME g_icc.icc15
              NEXT FIELD icc15
           END IF
        END IF
 
      AFTER FIELD icc06
        IF NOT cl_null(g_icc.icc06) THEN
           IF g_icc.icc06 NOT MATCHES '[1234]' THEN
              NEXT FIELD icc06
           END IF
        END IF
 
      AFTER FIELD icc30
        IF NOT cl_null(g_icc.icc30) THEN
           IF g_icc.icc30 NOT MATCHES '[YN]' THEN
              NEXT FIELD icc30
           END IF
        END IF
 
      AFTER FIELD icc04
        IF NOT cl_null(g_icc.icc04) THEN
           IF g_icc.icc04 < 0 THEN
              CALL cl_err(g_icc.icc04,'aom-103',0)
              LET g_icc.icc04 = g_icc_t.icc04
              DISPLAY BY NAME g_icc.icc04
              NEXT FIELD icc04
           END IF
        END IF
 
      AFTER FIELD icc05
        IF NOT cl_null(g_icc.icc05) THEN
           IF g_icc.icc05 < 0 THEN
              CALL cl_err(g_icc.icc05,'aom-103',0)
              LET g_icc.icc05 = g_icc_t.icc05
              DISPLAY BY NAME g_icc.icc05
              NEXT FIELD icc05
           END IF
        END IF
 
      AFTER FIELD icc16
        IF NOT cl_null(g_icc.icc16) THEN
           IF g_icc.icc16 < 0 THEN
              CALL cl_err(g_icc.icc16,'aom-103',0)
              LET g_icc.icc16 = g_icc_t.icc16
              DISPLAY BY NAME g_icc.icc16
              NEXT FIELD icc16
           END IF
        END IF
 
      AFTER FIELD icc17
        IF NOT cl_null(g_icc.icc17) THEN
           IF g_icc.icc17 < 0 THEN
              CALL cl_err(g_icc.icc17,'aom-103',0)
              LET g_icc.icc17 = g_icc_t.icc17
              DISPLAY BY NAME g_icc.icc17
              NEXT FIELD icc17
           END IF
        END IF
 
      AFTER FIELD icc18
        IF NOT cl_null(g_icc.icc18) THEN
           IF g_icc.icc18 < 0 THEN
              CALL cl_err(g_icc.icc18,'aom-103',0)
              LET g_icc.icc18 = g_icc_t.icc18
              DISPLAY BY NAME g_icc.icc18
              NEXT FIELD icc18
           END IF
        END IF
 
      AFTER FIELD icc19
        IF NOT cl_null(g_icc.icc19) THEN
           IF g_icc.icc19 < 0 THEN
              CALL cl_err(g_icc.icc19,'aom-103',0)
              LET g_icc.icc19 = g_icc_t.icc19
              DISPLAY BY NAME g_icc.icc19
              NEXT FIELD icc19
           END IF
        END IF
 
      AFTER FIELD icc20
        IF NOT cl_null(g_icc.icc20) THEN
           IF g_icc.icc20 < 0 THEN
              CALL cl_err(g_icc.icc20,'aom-103',0)
              LET g_icc.icc20 = g_icc_t.icc20
              DISPLAY BY NAME g_icc.icc20
              NEXT FIELD icc20
           END IF
        END IF
 
      AFTER FIELD icc26
        IF NOT cl_null(g_icc.icc26) THEN
           IF g_icc.icc26 < 0 THEN
              CALL cl_err(g_icc.icc26,'aom-103',0)
              LET g_icc.icc26 = g_icc_t.icc26
              DISPLAY BY NAME g_icc.icc26
              NEXT FIELD icc26
           END IF
        END IF
 
      AFTER FIELD icc08
        IF NOT cl_null(g_icc.icc08) THEN
           CALL i002_pmc_chk(g_icc.icc08,'1','a')
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_icc.icc08,g_errno,0)
              LET g_icc.icc08 = g_icc_t.icc08
              DISPLAY BY NAME g_icc.icc08
              NEXT FIELD icc08
           END IF
        ELSE
           DISPLAY ' ' TO FORMONLY.icc08_desc
        END IF
 
      AFTER FIELD icc11
        IF NOT cl_null(g_icc.icc11) THEN
           CALL i002_pmc_chk(g_icc.icc11,'2','a')
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_icc.icc11,g_errno,0)
              LET g_icc.icc11 = g_icc_t.icc11
              DISPLAY BY NAME g_icc.icc11
              NEXT FIELD icc11
           END IF
        ELSE
           DISPLAY ' ' TO FORMONLY.icc11_desc
        END IF
 
      #FUN-850068     ---start---
      AFTER FIELD iccud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD iccud02
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD iccud03
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD iccud04
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD iccud05
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD iccud06
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD iccud07
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD iccud08
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD iccud09
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD iccud10
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD iccud11
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD iccud12
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD iccud13
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD iccud14
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD iccud15
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      #FUN-850068     ----end----
 
      AFTER INPUT
         LET g_icc.iccuser = s_get_data_owner("icc_file") #FUN-C10039
         LET g_icc.iccgrup = s_get_data_group("icc_file") #FUN-C10039
        IF INT_FLAG THEN
           EXIT INPUT
        END IF
 
     ON ACTION CONTROLP
        CASE
          WHEN INFIELD(icc08)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_pmc1"
            LET g_qryparam.default1 = g_icc.icc08
            CALL cl_create_qry() RETURNING g_icc.icc08
            DISPLAY BY NAME g_icc.icc08
            NEXT FIELD icc08
 
          WHEN INFIELD(icc11)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_pmc1"
            LET g_qryparam.default1 = g_icc.icc11
            CALL cl_create_qry() RETURNING g_icc.icc11
            DISPLAY BY NAME g_icc.icc11
            NEXT FIELD icc11
 
          WHEN INFIELD(icc07)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_icd1"
            LET g_qryparam.arg1 = "K"
            LET g_qryparam.default1 = g_icc.icc07
            CALL cl_create_qry() RETURNING g_icc.icc07
            DISPLAY BY NAME g_icc.icc07
            NEXT FIELD icc07
 
          WHEN INFIELD(icc09)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_icd1"
            LET g_qryparam.arg1 = "M"
            LET g_qryparam.default1 = g_icc.icc09
            CALL cl_create_qry() RETURNING g_icc.icc09
            DISPLAY BY NAME g_icc.icc09
            NEXT FIELD icc09
 
          WHEN INFIELD(icc12)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_icd1"
            LET g_qryparam.arg1 = "J"
            LET g_qryparam.default1 = g_icc.icc12
            CALL cl_create_qry() RETURNING g_icc.icc12
            DISPLAY BY NAME g_icc.icc12
            NEXT FIELD icc12
 
          WHEN INFIELD(icc14)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_icd1"
            LET g_qryparam.arg1 = "L"
            LET g_qryparam.default1 = g_icc.icc14
            CALL cl_create_qry() RETURNING g_icc.icc14
            DISPLAY BY NAME g_icc.icc14
            NEXT FIELD icc14
 
          WHEN INFIELD(icc15)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_icd1"
            LET g_qryparam.arg1 = "N"
            LET g_qryparam.default1 = g_icc.icc15
            CALL cl_create_qry() RETURNING g_icc.icc15
            DISPLAY BY NAME g_icc.icc15
            NEXT FIELD icc15
 
        END CASE
 
     ON ACTION CONTROLR
        CALL cl_show_req_fields()
 
     ON ACTION CONTROLG
        CALL cl_cmdask()
 
     ON ACTION CONTROLF                        # 欄位說明
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
 
   END INPUT
END FUNCTION
 
FUNCTION i002_icd_chk(p_key,p_kind)
DEFINE p_key      LIKE icd_file.icd01
DEFINE p_kind     LIKE icd_file.icd02
DEFINE l_icd02    LIKE icd_file.icd02
DEFINE l_icdacti  LIKE icd_file.icdacti
 
  LET g_errno = ''
 
  SELECT icdacti
    INTO l_icd02,l_icdacti
    FROM icd_file
   WHERE icd01 = p_key
     AND icd02 = p_kind
 
  CASE
    WHEN SQLCA.SQLCODE = 100   LET g_errno = 'mfg1306'
    WHEN l_icdacti = 'N'       LET g_errno = '9028'
    OTHERWISE
         LET g_errno = SQLCA.SQLCODE USING '------'
  END CASE
 
END FUNCTION
 
FUNCTION i002_pmc_chk(p_key,p_ary,p_cmd)
DEFINE p_key       LIKE pmc_file.pmc01
DEFINE p_ary       LIKE type_file.chr1
DEFINE p_cmd       LIKE type_file.chr1
DEFINE l_pmc03     LIKE pmc_file.pmc03
DEFINE l_pmc30     LIKE pmc_file.pmc30
DEFINE l_pmcacti   LIKE pmc_file.pmcacti
 
   LET g_errno = ''
 
   SELECT pmc03,pmc30,pmcacti
     INTO l_pmc03,l_pmc30,l_pmcacti
     FROM pmc_file
    WHERE pmc01 = p_key
 
   IF p_cmd = 'a' THEN
      CASE
        WHEN SQLCA.SQLCODE = 100        LET g_errno = 'mfg3014'
        WHEN l_pmc30 NOT MATCHES '[13]' LET g_errno = 'mfg3290'
        WHEN l_pmcacti = 'N'            LET g_errno = '9028'
        OTHERWISE
             LET g_errno = SQLCA.SQLCODE USING '------'
      END CASE
   END IF
 
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      IF p_ary = '1' THEN
         DISPLAY l_pmc03 TO FORMONLY.icc08_desc
      ELSE
         DISPLAY l_pmc03 TO FORMONLY.icc11_desc
      END IF
   END IF
END FUNCTION
 
FUNCTION i002_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_icc.* TO NULL
    INITIALIZE g_icc_t.* TO NULL
    LET g_icc01_t = NULL
    LET g_wc = NULL
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i002_curs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       INITIALIZE g_icc.* TO NULL
       LET g_icc01_t = NULL
       LET g_wc = NULL
       RETURN
    END IF
    OPEN i002_count
    FETCH i002_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i002_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_icc.icc01,SQLCA.sqlcode,0)
       INITIALIZE g_icc.* TO NULL
       LET g_icc01_t = NULL
       LET g_wc = NULL
    ELSE
       CALL i002_fetch('F')               # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i002_fetch(p_flicc)
 DEFINE p_flicc  LIKE type_file.chr1
 
    CASE p_flicc
        WHEN 'N' FETCH NEXT     i002_cs INTO g_icc.icc01
        WHEN 'P' FETCH PREVIOUS i002_cs INTO g_icc.icc01
        WHEN 'F' FETCH FIRST    i002_cs INTO g_icc.icc01
        WHEN 'L' FETCH LAST     i002_cs INTO g_icc.icc01
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
            FETCH ABSOLUTE g_jump i002_cs INTO g_icc.icc01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_icc.icc01,SQLCA.sqlcode,0)
       INITIALIZE g_icc.* TO NULL
       LET g_icc01_t = NULL
       RETURN
    ELSE
      CASE p_flicc
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index,g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx
    END IF
 
    SELECT * INTO g_icc.* FROM icc_file    # 重讀DB,因TEMP有不被更新特性
     WHERE icc01 = g_icc.icc01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","icc_file",g_icc.icc01,"",SQLCA.sqlcode,"","",0)
    ELSE
       LET g_data_owner = g_icc.iccuser
       LET g_data_group = g_icc.iccgrup
       CALL i002_show()
    END IF
END FUNCTION
 
FUNCTION i002_show()
    LET g_icc_t.* = g_icc.*
    DISPLAY BY NAME g_icc.icc01,g_icc.icc04, g_icc.iccoriu,g_icc.iccorig,
                    g_icc.icc05,g_icc.icc09,
                    g_icc.icc08,g_icc.icc11,
                    g_icc.icc12,g_icc.icc14,
                    g_icc.icc10,g_icc.icc06,
                    g_icc.icc07,g_icc.icc27,
                    g_icc.icc13,g_icc.icc15,
                    g_icc.icc16,g_icc.icc17,
                    g_icc.icc18,g_icc.icc30,
                    g_icc.icc32,g_icc.icc34,
                    g_icc.icc36,g_icc.icc38,
                    g_icc.icc19,g_icc.icc20,
                    g_icc.icc33,g_icc.icc35,
                    g_icc.icc37,g_icc.icc21,
                    g_icc.icc22,g_icc.icc23,
                    g_icc.icc25,
                    g_icc.icc26,g_icc.iccuser,
                    g_icc.iccgrup,g_icc.iccmodu,
                    g_icc.iccdate,g_icc.iccacti,
                    #FUN-850068     ---start---
                    g_icc.iccud01,g_icc.iccud02,g_icc.iccud03,g_icc.iccud04,
                    g_icc.iccud05,g_icc.iccud06,g_icc.iccud07,g_icc.iccud08,
                    g_icc.iccud09,g_icc.iccud10,g_icc.iccud11,g_icc.iccud12,
                    g_icc.iccud13,g_icc.iccud14,g_icc.iccud15 
                    #FUN-850068     ----end----
    CALL i002_pmc_chk(g_icc.icc08,'1','d')
    CALL i002_pmc_chk(g_icc.icc11,'2','d')
    CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION i002_u()
    IF cl_null(g_icc.icc01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    SELECT * INTO g_icc.* FROM icc_file WHERE icc01=g_icc.icc01
 
    IF g_icc.iccacti = 'N' THEN
       CALL cl_err(g_icc.icc01,9027,0)
       RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_icc01_t = g_icc.icc01
    BEGIN WORK
 
    OPEN i002_cl USING g_icc.icc01
    IF STATUS THEN
       CALL cl_err("OPEN i002_cl:",STATUS,1)
       CLOSE i002_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i002_cl INTO g_icc.*             # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_icc.icc01,SQLCA.sqlcode,1)
       ROLLBACK WORK
       RETURN
    END IF
    LET g_icc.iccmodu = g_user             # 修改者
    LET g_icc.iccdate = g_today            # 修改日期
    CALL i002_show()                       # 顯示最新資料
    WHILE TRUE
        CALL i002_i("u")                   # 欄位更改
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           LET g_icc.*=g_icc_t.*
           CALL i002_show()
           CALL cl_err('',9001,0)
           EXIT WHILE
        END IF
        UPDATE icc_file SET icc_file.* = g_icc.*    # 更新DB
         WHERE icc01 = g_icc01_t
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
           CALL cl_err3("upd","icc_file",g_icc.icc01,"",SQLCA.sqlcode,"","",0)
           CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i002_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i002_x()
    IF cl_null(g_icc.icc01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    BEGIN WORK
 
    OPEN i002_cl USING g_icc.icc01
    IF STATUS THEN
       CALL cl_err("OPEN i002_cl:",STATUS,1)
       CLOSE i002_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i002_cl INTO g_icc.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_icc.icc01,SQLCA.sqlcode,1)
       ROLLBACK WORK
       RETURN
    END IF
    CALL i002_show()
    IF cl_exp(0,0,g_icc.iccacti) THEN
       LET g_chr=g_icc.iccacti
       IF g_icc.iccacti='Y' THEN
          LET g_icc.iccacti='N'
       ELSE
          LET g_icc.iccacti='Y'
       END IF
       UPDATE icc_file SET iccacti = g_icc.iccacti
        WHERE icc01 = g_icc.icc01
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
          CALL cl_err(g_icc.icc01,SQLCA.sqlcode,0)
          LET g_icc.iccacti = g_chr
          ROLLBACK WORK
       END IF
       DISPLAY BY NAME g_icc.iccacti
    END IF
    CLOSE i002_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i002_r()
    IF cl_null(g_icc.icc01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    BEGIN WORK
 
    OPEN i002_cl USING g_icc.icc01
    IF STATUS THEN
       CALL cl_err("OPEN i002_cl:",STATUS,0)
       CLOSE i002_cl
       RETURN
    END IF
    FETCH i002_cl INTO g_icc.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_icc.icc01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i002_show()
    IF g_icc.iccacti = 'N' THEN
       CALL cl_err('','afa-916',1)
       RETURN
    END IF
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "icc01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_icc.icc01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM icc_file WHERE icc01 = g_icc.icc01
       CLEAR FORM
       OPEN i002_count
       #FUN-B50062-add-start--
       IF STATUS THEN
          CLOSE i002_cs
          CLOSE i002_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       FETCH i002_count INTO g_row_count
       #FUN-B50062-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i002_cs
          CLOSE i002_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i002_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i002_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL i002_fetch('/')
       END IF
    END IF
    CLOSE i002_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i002_copy()
DEFINE l_newno   LIKE icc_file.icc01
DEFINE l_oldno   LIKE icc_file.icc01
 
   IF cl_null(g_icc.icc01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
   CALL i002_set_entry('a')
   LET g_before_input_done = TRUE
 
   INPUT l_newno FROM icc01
 
      AFTER FIELD icc01
         IF NOT cl_null(l_newno) THEN
            LET g_cnt = 0
            SELECT COUNT(*) INTO g_cnt FROM icc_file
             WHERE icc01 = l_newno
            IF g_cnt > 0 THEN
               CALL cl_err(l_newno,-239,0)
               LET l_newno = NULL
               DISPLAY l_newno TO icc01
               NEXT FIELD icc01
            END IF
         END IF
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode())
              RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY BY NAME g_icc.icc01
      RETURN
   END IF
 
   DROP TABLE x
   SELECT * FROM icc_file
    WHERE icc01 = g_icc.icc01
     INTO TEMP x
   UPDATE x
       SET icc01=l_newno,    #資料鍵值
           iccacti='Y',      #資料有效碼
           iccuser=g_user,   #資料所有者
           iccgrup=g_grup,   #資料所有者所屬群
           iccmodu=NULL,     #資料修改日期
           iccdate=g_today   #資料建立日期
   INSERT INTO icc_file SELECT * FROM x
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err3("ins","icc_file",l_newno,"",SQLCA.sqlcode,"","",0)
   ELSE
      MESSAGE 'ROW(',l_newno,') O.K'
      LET l_oldno = g_icc.icc01
      LET g_icc.icc01 = l_newno
      SELECT icc_file.* INTO g_icc.*
        FROM icc_file
       WHERE icc01 = l_newno
      CALL i002_u()
      #SELECT icc_file.* INTO g_icc.*  #FUN-C30027
      #  FROM icc_file                 #FUN-C30027
      # WHERE icc01 = l_oldno          #FUN-C30027
   END IF
   #LET g_icc.icc01 = l_oldno          #FUN-C30027
   CALL i002_show()
END FUNCTION
 
FUNCTION i002_out()
DEFINE sr RECORD
             icc01 LIKE icc_file.icc01,
             icc02 LIKE icc_file.icc02,
             icc03 LIKE icc_file.icc03
          END RECORD
 
   IF g_wc IS NULL THEN
      CALL cl_err('','9057',0)
      RETURN
   END IF
 
   CALL cl_wait()
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
   LET g_sql = 'SELECT icc01,icc02,icc03 FROM icc_file WHERE ',g_wc CLIPPED,
               ' ORDER BY icc01,icc02,icc03'
   CALL cl_wcchp(g_wc,'icc01') RETURNING g_wc
   LET g_str = g_wc,"'",g_zz05
   CALL cl_prt_cs1('aici002','aici002',g_sql,g_str)
 
END FUNCTION
 
FUNCTION i002_set_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("icc01",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i002_set_no_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1
 
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("icc01",FALSE)
   END IF
 
END FUNCTION
#No.FUN-7B0076

