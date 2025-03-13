# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: axri080.4gl
# Descriptions...: 客戶信用評等及備抵呆帳提列率維護作業
# Date & Author..: FUN-B50044 11/05/10 By zhangweib
# Modify.........: No.FUN-B70131 11/08/01 By belle 修改規格-避免日後追單困難,原程式全部註解,置於最下方
# Modify.........: No.TQC-B80164 11/08/22 By guoch 是否依??分段?位去掉非空值

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE g_omii       RECORD LIKE omii_file.*,
       g_omii_t     RECORD LIKE omii_file.*,   #備份舊值
       g_omii00_t   LIKE omii_file.omii00,     #Key值備份
       g_omii18_t   LIKE omii_file.omii18,
       g_omii07_t   LIKE omii_file.omii07,
       g_wc         STRING,                    #儲存 user 的查詢條件
       g_sql        STRING                     #組 sql 用

DEFINE g_forupd_sql          STRING         #SELECT ... FOR UPDATE NOWAIT SQL        #No.FUN-680102
DEFINE g_before_input_done   LIKE type_file.num5          #判斷是否已執行 Before Input指令        #No.FUN-680102 SMALLINT
DEFINE g_cnt                 LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE g_msg                 LIKE type_file.chr1000       #No.FUN-680102 VARCHAR(72)  
DEFINE g_curs_index          LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE g_row_count           LIKE type_file.num10         #總筆數        #No.FUN-680102 INTEGER
DEFINE g_jump                LIKE type_file.num10         #查詢指定的筆數        #No.FUN-680102 INTEGER
DEFINE mi_no_ask             LIKE type_file.num5          #是否開啟指定筆視窗        #No.FUN-680102 SMALLINT  #No.FUN-6A0066

MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5    #No.FUN-680102 SMALLINT

    OPTIONS
        INPUT NO WRAP                          #輸入的方式: 不打轉
    DEFER INTERRUPT                            #擷取中斷鍵

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF

   LET p_row = ARG_VAL(1)
   LET p_col = ARG_VAL(2)
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   INITIALIZE g_omii.* TO NULL

   LET g_forupd_sql = "SELECT * FROM omii_file WHERE omii00 = ? FOR UPDATE "       #TQC-780042 mod
   CALL cl_forupd_sql(g_forupd_sql) RETURNING g_forupd_sql   
   DECLARE i080_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR

   LET p_row = 5 LET p_col = 10

   OPEN WINDOW i080_w AT p_row,p_col WITH FORM "axr/42f/axri080"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN

   CALL cl_ui_init()

   LET g_action_choice = ""
   CALL i080_menu()

   CLOSE WINDOW i080_w
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0081
END MAIN

FUNCTION i080_curs()
DEFINE ls      STRING
    CLEAR FORM
    INITIALIZE g_omii.* TO NULL
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取條件
        omii00,omii18,omii07
        BEFORE CONSTRUCT
           CALL cl_qbe_init()

        ON ACTION controlp
           CASE
              WHEN INFIELD(omii07)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_omi"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_omii.omii07
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO omii07
                 NEXT FIELD omii07
              OTHERWISE
                 EXIT CASE
           END CASE
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
	 CALL cl_qbe_save()
    END CONSTRUCT

    #資料權限的檢查
    IF g_priv2='4' THEN                           #只能使用自己的資料
        LET g_wc = g_wc clipped," AND omiiuser = '",g_user,"'"
    END IF
    IF g_priv3='4' THEN                           #只能使用相同群的資料
        LET g_wc = g_wc clipped," AND omiigrup MATCHES '",
                   g_grup CLIPPED,"*'"
    END IF

    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
        LET g_wc = g_wc clipped," AND omiigrup IN ",cl_chk_tgrup_list()
    END IF

    LET g_sql="SELECT omii00 FROM omii_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY omii00"
    PREPARE i080_prepare FROM g_sql
    DECLARE i080_cs                                # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i080_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM omii_file WHERE ",g_wc CLIPPED
    PREPARE i080_precount FROM g_sql
    DECLARE i080_count CURSOR FOR i080_precount
END FUNCTION

FUNCTION i080_menu()
   DEFINE l_cmd  LIKE type_file.chr1000       #No.FUN-780056   
    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)

        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i080_a()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i080_r()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i080_q()
            END IF
        ON ACTION next
            CALL i080_fetch('N')
        ON ACTION previous
            CALL i080_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i080_u()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL i080_fetch('/')
        ON ACTION first
            CALL i080_fetch('F')
        ON ACTION last
            CALL i080_fetch('L')
        ON ACTION controlg
            CALL cl_cmdask()
        ON ACTION locale
            CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE MENU
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

        COMMAND KEY(INTERRUPT)
             LET INT_FLAG=FALSE 		#MOD-570244	mars
           LET g_action_choice = "exit"
           EXIT MENU
    END MENU
    CLOSE i080_cs
END FUNCTION

FUNCTION i080_a()
    MESSAGE ""
    CLEAR FORM                                   # 清螢幕欄位內容
    INITIALIZE g_omii.* LIKE omii_file.*
    LET g_omii00_t = NULL
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_omii.omii18 = 'N'  #TQC-B80164 add
        CALL i080_i("a")
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_omii.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF cl_null(g_omii.omii00) THEN             # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO omii_file VALUES(g_omii.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","omii_file",g_omii.omii00,"",SQLCA.sqlcode,"","",0)   #No:FUN-660131
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION

FUNCTION i080_i(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1,          #No.FUN-680102 VARCHAR(1)
            l_n       LIKE type_file.num5           #No.FUN-680102 SMALLINT
   DISPLAY BY NAME
      g_omii.omii01,g_omii.omii011,g_omii.omii02,g_omii.omii021,g_omii.omii03,g_omii.omii031,
      g_omii.omii04,g_omii.omii041,g_omii.omii05,g_omii.omii051,g_omii.omii06,g_omii.omii061,
      g_omii.omii08,g_omii.omii09,g_omii.omii10,g_omii.omii11,g_omii.omii12,
      g_omii.omii13,g_omii.omii14,g_omii.omii15,g_omii.omii16,g_omii.omii17
 
   INPUT BY NAME
      g_omii.omii00,g_omii.omii18,g_omii.omii07,
      g_omii.omii01,g_omii.omii011,g_omii.omii02,g_omii.omii021,g_omii.omii03,g_omii.omii031,
      g_omii.omii04,g_omii.omii041,g_omii.omii05,g_omii.omii051,g_omii.omii06,g_omii.omii061,
      g_omii.omii08,g_omii.omii09,g_omii.omii10,g_omii.omii11,g_omii.omii12,
      g_omii.omii13,g_omii.omii14,g_omii.omii15,g_omii.omii16,g_omii.omii17
      WITHOUT DEFAULTS

      BEFORE INPUT
         IF p_cmd = 'a' THEN
            LET g_omii.omii18 = 'Y'
         END IF
         CALL i080_set_entry(p_cmd)
         CALL i080_set_no_entry(p_cmd)
         LET g_omii18_t = g_omii.omii18
         LET g_omii07_t = g_omii.omii07

      AFTER FIELD omii00              #key值處理
         IF g_omii.omii00 IS NOT NULL THEN
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
               (p_cmd = "u" AND g_omii.omii00 != g_omii00_t) THEN
               SELECT count(*) INTO l_n FROM omii_file WHERE omii00 = g_omii.omii00
               IF l_n > 0 THEN
                  CALL cl_err(g_omii.omii08,-239,1)
                  LET g_omii.omii00 = g_omii00_t
                  DISPLAY BY NAME g_omii.omii00
                  NEXT FIELD omii00
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('omii00:',g_errno,1)
                  LET g_omii.omii00 = g_omii00_t
                  DISPLAY BY NAME g_omii.omii00
                  NEXT FIELD omii00
               END IF
            END IF
         END IF

      ON CHANGE omii18
         IF g_omii.omii18 = 'Y' THEN
            CALL i080_set_entry(p_cmd)
            CALL i080_set_no_entry(p_cmd)
            CALL cl_set_comp_required("omii07",TRUE)
            LET g_omii18_t = g_omii.omii18
         END IF
         IF g_omii.omii18 = 'N' THEN
            CALL i080_set_no_entry(p_cmd)
            CALL i080_set_entry(p_cmd)
            IF g_omii.omii18 <> g_omii18_t THEN
               LET g_omii.omii07 = ' '
               LET g_omii.omii01 = ' '
               LET g_omii.omii02 = ' '
               LET g_omii.omii03 = ' '
               LET g_omii.omii04 = ' '
               LET g_omii.omii05 = ' '
               LET g_omii.omii06 = ' '
               LET g_omii.omii011 = ' '
               LET g_omii.omii021 = ' '
               LET g_omii.omii031 = ' '
               LET g_omii.omii041 = ' '
               LET g_omii.omii051 = ' '
               LET g_omii.omii061 = ' '
               DISPLAY BY NAME g_omii.omii07,g_omii.omii01,g_omii.omii02,g_omii.omii03,
                               g_omii.omii04,g_omii.omii05,g_omii.omii06,
                               g_omii.omii011,g_omii.omii021,g_omii.omii031,
                               g_omii.omii041,g_omii.omii051,g_omii.omii061
            END IF
            LET g_omii18_t = g_omii.omii18
         END IF

      AFTER FIELD omii07
         IF g_omii.omii18 = 'Y' AND cl_null(g_omii.omii07) THEN
            CALL cl_err("","aar-011",1)
            NEXT FIELD omii07
         END IF
         IF NOT cl_null(g_omii.omii07) THEN
            IF g_omii.omii07 <> g_omii07_t OR cl_null(g_omii07_t) THEN
               SELECT count(*) INTO l_n from omi_file where omi01 = g_omii.omii07
                  IF l_n = 0 THEN
                     CALL cl_err("","ain-070",1)
                     LET g_omii.omii07 = g_omii_t.omii07
                     DISPLAY BY NAME g_omii.omii07
                     NEXT FIELD omii07
                  ELSE
                     SELECT omi11,omi12,omi13,omi14,omi15,omi16,
                            omi21,omi22,omi23,omi24,omi25,omi26 
                       INTO g_omii.omii01,g_omii.omii02,g_omii.omii03,
                            g_omii.omii04,g_omii.omii05,g_omii.omii06,
                            g_omii.omii011,g_omii.omii021,g_omii.omii031,
                            g_omii.omii041,g_omii.omii051,g_omii.omii061
                       FROM omi_file
                      WHERE omi01 = g_omii.omii07
                      DISPLAY BY NAME g_omii.omii01,g_omii.omii02,g_omii.omii03,
                                      g_omii.omii04,g_omii.omii05,g_omii.omii06,
                                      g_omii.omii011,g_omii.omii021,g_omii.omii031,
                                      g_omii.omii041,g_omii.omii051,g_omii.omii061
                  END IF
               LET g_omii07_t = g_omii.omii07
            END IF
         END IF

      AFTER FIELD omii011
         IF g_omii.omii18 = 'N' AND g_omii.omii011 < 0 THEN
            CALL cl_err("","aec-020",1)
            NEXT FIELD omii011
         END IF

      AFTER FIELD omii021
         IF g_omii.omii18 = 'N' AND g_omii.omii021 < 0 THEN
            CALL cl_err("","aec-020",1)
            NEXT FIELD omii021
         END IF

      AFTER FIELD omii031
         IF g_omii.omii18 = 'N' AND g_omii.omii031 < 0 THEN
            CALL cl_err("","aec-020",1)
            NEXT FIELD omii031
         END IF

      AFTER FIELD omii041
         IF g_omii.omii18 = 'N' AND g_omii.omii041 < 0 THEN
            CALL cl_err("","aec-020",1)
            NEXT FIELD omii041
         END IF

      AFTER FIELD omii051
         IF g_omii.omii18 = 'N' AND g_omii.omii051 < 0 THEN
            CALL cl_err("","aec-020",1)
            NEXT FIELD omii051
         END IF

      AFTER FIELD omii061
         IF g_omii.omii18 = 'N' AND g_omii.omii061 < 0 THEN
            CALL cl_err("","aec-020",1)
            NEXT FIELD omii061
         END IF

      AFTER FIELD omii08
        IF NOT cl_null(g_omii.omii08) THEN
           SELECT * from ocg_file where ocgacti = 'Y' AND ocg01 = g_omii.omii08
           IF SQLCA.sqlcode THEN
              CALL cl_err3("sel","ocg_file",g_omii.omii08,"",SQLCA.sqlcode,"","sel ocg",1)
              LET g_omii.omii08 = g_omii_t.omii08
              DISPLAY BY NAME g_omii.omii08
              NEXT FIELD omii08
           END IF
        END IF

      AFTER FIELD omii09
        IF NOT cl_null(g_omii.omii09) THEN
           SELECT * from ocg_file where ocgacti = 'Y' AND ocg01 = g_omii.omii09
           IF SQLCA.sqlcode THEN
              CALL cl_err3("sel","ocg_file",g_omii.omii09,"",SQLCA.sqlcode,"","sel ocg",1)
              LET g_omii.omii09 = g_omii_t.omii09
              DISPLAY BY NAME g_omii.omii09
              NEXT FIELD omii09
           END IF
        END IF

      AFTER FIELD omii10
        IF NOT cl_null(g_omii.omii10) THEN
           SELECT * from ocg_file where ocgacti = 'Y' AND ocg01 = g_omii.omii10
           IF SQLCA.sqlcode THEN
              CALL cl_err3("sel","ocg_file",g_omii.omii10,"",SQLCA.sqlcode,"","sel ocg",1)
              LET g_omii.omii10 = g_omii_t.omii10
              DISPLAY BY NAME g_omii.omii10
              NEXT FIELD omii10
           END IF
        END IF

      AFTER FIELD omii11
        IF NOT cl_null(g_omii.omii11) THEN
           SELECT * from ocg_file where ocgacti = 'Y' AND ocg01 = g_omii.omii11
           IF SQLCA.sqlcode THEN
              CALL cl_err3("sel","ocg_file",g_omii.omii11,"",SQLCA.sqlcode,"","sel ocg",1)
              LET g_omii.omii11 = g_omii_t.omii11
              DISPLAY BY NAME g_omii.omii11
              NEXT FIELD omii11
           END IF
        END IF

      AFTER FIELD omii12
        IF NOT cl_null(g_omii.omii12) THEN
           SELECT * from ocg_file where ocgacti = 'Y' AND ocg01 = g_omii.omii12
           IF SQLCA.sqlcode THEN
              CALL cl_err3("sel","ocg_file",g_omii.omii12,"",SQLCA.sqlcode,"","sel ocg",1)
              LET g_omii.omii12 = g_omii_t.omii12
              DISPLAY BY NAME g_omii.omii12
              NEXT FIELD omii12
           END IF
        END IF

      AFTER FIELD omii13
        IF NOT cl_null(g_omii.omii13) THEN
           SELECT * from ocg_file where ocgacti = 'Y' AND ocg01 = g_omii.omii13
           IF SQLCA.sqlcode THEN
              CALL cl_err3("sel","ocg_file",g_omii.omii13,"",SQLCA.sqlcode,"","sel ocg",1)
              LET g_omii.omii13 = g_omii_t.omii13
              DISPLAY BY NAME g_omii.omii13
              NEXT FIELD omii13
           END IF
        END IF

      AFTER FIELD omii14
        IF NOT cl_null(g_omii.omii14) THEN
           SELECT * from ocg_file where ocgacti = 'Y' AND ocg01 = g_omii.omii14
           IF SQLCA.sqlcode THEN
              CALL cl_err3("sel","ocg_file",g_omii.omii14,"",SQLCA.sqlcode,"","sel ocg",1)
              LET g_omii.omii14 = g_omii_t.omii14
              DISPLAY BY NAME g_omii.omii14
              NEXT FIELD omii14
           END IF
        END IF

      AFTER FIELD omii15
        IF NOT cl_null(g_omii.omii15) THEN
           SELECT * from ocg_file where ocgacti = 'Y' AND ocg01 = g_omii.omii15
           IF SQLCA.sqlcode THEN
              CALL cl_err3("sel","ocg_file",g_omii.omii15,"",SQLCA.sqlcode,"","sel ocg",1)
              LET g_omii.omii15 = g_omii_t.omii15
              DISPLAY BY NAME g_omii.omii15
              NEXT FIELD omii15
           END IF
        END IF

      AFTER FIELD omii16
        IF NOT cl_null(g_omii.omii16) THEN
           SELECT * from ocg_file where ocgacti = 'Y' AND ocg01 = g_omii.omii16
           IF SQLCA.sqlcode THEN
              CALL cl_err3("sel","ocg_file",g_omii.omii16,"",SQLCA.sqlcode,"","sel ocg",1)
              LET g_omii.omii16 = g_omii_t.omii16
              DISPLAY BY NAME g_omii.omii16
              NEXT FIELD omii16
           END IF
        END IF

      AFTER FIELD omii17
        IF NOT cl_null(g_omii.omii17) THEN
           SELECT * from ocg_file where ocgacti = 'Y' AND ocg01 = g_omii.omii17
           IF SQLCA.sqlcode THEN
              CALL cl_err3("sel","ocg_file",g_omii.omii17,"",SQLCA.sqlcode,"","sel ocg",1)
              LET g_omii.omii17 = g_omii_t.omii17
              DISPLAY BY NAME g_omii.omii17
              NEXT FIELD omii17
           END IF
        END IF

      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         IF g_omii.omii00 IS NULL THEN
            DISPLAY BY NAME g_omii.omii00
         END IF
 
      ON ACTION CONTROLO                        # 沿用所有欄位
         IF INFIELD(omii00) THEN
            LET g_omii.* = g_omii_t.*
            CALL i080_show()
            NEXT FIELD omii00
         END IF

     ON ACTION controlp
        CASE

           WHEN INFIELD(omii07)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_omi"
              LET g_qryparam.default1 = g_omii.omii07
              CALL cl_create_qry() RETURNING g_omii.omii07
              DISPLAY BY NAME g_omii.omii07
              NEXT FIELD omii07

           WHEN INFIELD(omii08)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ocg"
              LET g_qryparam.default1 = g_omii.omii08
              CALL cl_create_qry() RETURNING g_omii.omii08
              DISPLAY BY NAME g_omii.omii08
              NEXT FIELD omii08

            WHEN INFIELD(omii09)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ocg"
              LET g_qryparam.default1 = g_omii.omii09
              CALL cl_create_qry() RETURNING g_omii.omii09
              DISPLAY BY NAME g_omii.omii09
              NEXT FIELD omii09

            WHEN INFIELD(omii10)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ocg"
              LET g_qryparam.default1 = g_omii.omii10
              CALL cl_create_qry() RETURNING g_omii.omii10
              DISPLAY BY NAME g_omii.omii10
              NEXT FIELD omii10

            WHEN INFIELD(omii11)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ocg"
              LET g_qryparam.default1 = g_omii.omii11
              CALL cl_create_qry() RETURNING g_omii.omii11
              DISPLAY BY NAME g_omii.omii11
              NEXT FIELD omii11

            WHEN INFIELD(omii12)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ocg"
              LET g_qryparam.default1 = g_omii.omii12
              CALL cl_create_qry() RETURNING g_omii.omii12
              DISPLAY BY NAME g_omii.omii12
              NEXT FIELD omii12

            WHEN INFIELD(omii13)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ocg"
              LET g_qryparam.default1 = g_omii.omii13
              CALL cl_create_qry() RETURNING g_omii.omii13
              DISPLAY BY NAME g_omii.omii13
              NEXT FIELD omii13

            WHEN INFIELD(omii14)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ocg"
              LET g_qryparam.default1 = g_omii.omii14
              CALL cl_create_qry() RETURNING g_omii.omii14
              DISPLAY BY NAME g_omii.omii14
              NEXT FIELD omii14

            WHEN INFIELD(omii15)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ocg"
              LET g_qryparam.default1 = g_omii.omii15
              CALL cl_create_qry() RETURNING g_omii.omii15
              DISPLAY BY NAME g_omii.omii15
              NEXT FIELD omii15

            WHEN INFIELD(omii16)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ocg"
              LET g_qryparam.default1 = g_omii.omii16
              CALL cl_create_qry() RETURNING g_omii.omii16
              DISPLAY BY NAME g_omii.omii16
              NEXT FIELD omii16

            WHEN INFIELD(omii17)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ocg"
              LET g_qryparam.default1 = g_omii.omii17
              CALL cl_create_qry() RETURNING g_omii.omii17
              DISPLAY BY NAME g_omii.omii17
              NEXT FIELD omii17
              
           OTHERWISE
              EXIT CASE
           END CASE

   ON ACTION CONTROLR
      CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   END INPUT
END FUNCTION

FUNCTION i080_r()
   IF cl_null(g_omii.omii00) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
    
   BEGIN WORK

   OPEN i080_cl USING g_omii.omii00
   IF STATUS THEN
      CALL cl_err("OPEN i080_cl:", STATUS, 0)
      CLOSE i080_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i080_cl INTO g_omii.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_omii.omii00,SQLCA.sqlcode,0)
      RETURN
   END IF
   
   CALL i080_show()
   IF cl_delete() THEN
      INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
      LET g_doc.column1 = "omii00"        #No.FUN-9B0098 10/02/24
      LET g_doc.value1 = g_omii.omii00    #No.FUN-9B0098 10/02/24
      CALL cl_del_doc()                   #No.FUN-9B0098 10/02/24
      DELETE FROM omii_file WHERE omii00 = g_omii.omii00
      CLEAR FORM
      OPEN i080_count
      FETCH i080_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i080_cs
      IF g_row_count > 0 THEN
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i080_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE                 
            CALL i080_fetch('/')
         END IF
      END IF
   END IF
   CLOSE i080_cl
   COMMIT WORK
END FUNCTION

FUNCTION i080_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_omii.* TO NULL            #No.FUN-6A0015
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i080_curs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i080_count
    FETCH i080_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i080_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_omii.omii00,SQLCA.sqlcode,0)
        INITIALIZE g_omii.* TO NULL
    ELSE
        CALL i080_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION

FUNCTION i080_fetch(p_flomii)
    DEFINE
        p_flomii         LIKE type_file.chr1           #No:FUN-680102 VARCHAR(1)  

    CASE p_flomii
        WHEN 'N' FETCH NEXT     i080_cs INTO g_omii.omii00
        WHEN 'P' FETCH PREVIOUS i080_cs INTO g_omii.omii00
        WHEN 'F' FETCH FIRST    i080_cs INTO g_omii.omii00
        WHEN 'L' FETCH LAST     i080_cs INTO g_omii.omii00
        WHEN '/'
            IF (NOT mi_no_ask) THEN                   #No.FUN-6A0066
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump i080_cs INTO g_omii.omii00
            LET mi_no_ask = FALSE         #No.FUN-6A0066
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_omii.omii00,SQLCA.sqlcode,0)
        INITIALIZE g_omii.* TO NULL
        RETURN
    ELSE
      CASE p_flomii
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE

      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx                 #No:FUN-4A0089
    END IF

    SELECT * INTO g_omii.* FROM omii_file    # 重讀DB,因TEMP有不被更新特性
       WHERE omii00 = g_omii.omii00
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","omii_file",g_omii.omii00,"",SQLCA.sqlcode,"","",0)  #No:FUN-660131
    ELSE
        CALL i080_show()                   # 重新顯示
    END IF
END FUNCTION

FUNCTION i080_show()
    LET g_omii_t.* = g_omii.*
    DISPLAY BY NAME g_omii.*
    CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
END FUNCTION

FUNCTION i080_u()
    IF g_omii.omii00 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    CALL cl_opmsg('u')
    LET g_omii00_t = g_omii.omii00
    BEGIN WORK

    OPEN i080_cl USING g_omii.omii00 
    IF STATUS THEN
       CALL cl_err("OPEN i080_cl:", STATUS, 1)
       CLOSE i080_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i080_cl INTO g_omii.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_omii.omii00,SQLCA.sqlcode,1)
        RETURN
    END IF
    CALL i080_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i080_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_omii.*=g_omii_t.*
            CALL i080_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE omii_file SET omii_file.* = g_omii.*    # 更新DB
            WHERE omii00 = g_omii.omii00 
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","omii_file",g_omii.omii00,"",SQLCA.sqlcode,"","",0)  #No:FUN-660131
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i080_cl
    COMMIT WORK
END FUNCTION

FUNCTION i080_set_entry(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1
   IF (p_cmd = 'a'OR p_cmd = 'u') AND g_omii.omii18 = 'Y' THEN
      CALL cl_set_comp_entry("omii07,omii01,omii02,omii03,omii04,omii05,omii06",TRUE)
   END IF
   IF (p_cmd = 'a'OR p_cmd = 'u') AND g_omii.omii18 = 'N' THEN
      CALL cl_set_comp_entry("omii011,omii021,omii031,omii041,omii051,omii061",TRUE)
   END IF
   IF p_cmd = 'a' THEN
      CALL cl_set_comp_entry("omii00",TRUE)
   END IF
END FUNCTION

FUNCTION i080_set_no_entry(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
   IF (p_cmd = 'a'OR p_cmd = 'u') AND g_omii.omii18 = 'N' THEN
      CALL cl_set_comp_entry("omii07,omii01,omii02,omii03,omii04,omii05,omii06",FALSE)
   END IF
   IF (p_cmd = 'a'OR p_cmd = 'u') AND g_omii.omii18 = 'Y' THEN
      CALL cl_set_comp_entry("omii01,omii02,omii03,omii04,omii05,omii06,omii011,omii021,omii031,omii041,omii051,omii061",FALSE)
   END IF
   IF p_cmd = 'u' THEN
      CALL cl_set_comp_entry("omii00",FALSE)
   END IF
END FUNCTION
#FUN-B70131--beging-- 
#DEFINE 
#   g_omm             DYNAMIC ARRAY OF RECORD  #程式變數(Program Variables)  #FUN-B50044
#           omm00     LIKE omm_file.omm00,
#           omm01     LIKE omm_file.omm01,
#           omm011    LIKE omm_file.omm011,
#           omm02     LIKE omm_file.omm02,
#           omm021    LIKE omm_file.omm021,
#           omm03     LIKE omm_file.omm03,
#           omm031    LIKE omm_file.omm031,
#           omm04     LIKE omm_file.omm04,
#           omm041    LIKE omm_file.omm041,
#           omm05     LIKE omm_file.omm05,
#           omm051    LIKE omm_file.omm051,
#           omm06     LIKE omm_file.omm06,
#           omm061    LIKE omm_file.omm061,
#           omm07     LIKE omm_file.omm07,
#           omm071    LIKE omm_file.omm071,
#           omm08     LIKE omm_file.omm08,
#           omm081    LIKE omm_file.omm081,
#           omm09     LIKE omm_file.omm09,
#           omm091    LIKE omm_file.omm091,
#           omm10     LIKE omm_file.omm10,
#           omm101    LIKE omm_file.omm101
#                             END RECORD,
#   g_omm_t           RECORD              #程式變數 (舊值)
#           omm00     LIKE omm_file.omm00,
#           omm01     LIKE omm_file.omm01,
#           omm011    LIKE omm_file.omm011,
#           omm02     LIKE omm_file.omm02,
#           omm021    LIKE omm_file.omm021,
#           omm03     LIKE omm_file.omm03,
#           omm031    LIKE omm_file.omm031,
#           omm04     LIKE omm_file.omm04,
#           omm041    LIKE omm_file.omm041,
#           omm05     LIKE omm_file.omm05,
#           omm051    LIKE omm_file.omm051, 
#           omm06     LIKE omm_file.omm06,
#           omm061    LIKE omm_file.omm061,
#           omm07     LIKE omm_file.omm07,
#           omm071    LIKE omm_file.omm071,
#           omm08     LIKE omm_file.omm08,
#           omm081    LIKE omm_file.omm081,
#           omm09     LIKE omm_file.omm09,
#           omm091    LIKE omm_file.omm091,
#           omm10     LIKE omm_file.omm10,
#           omm101    LIKE omm_file.omm101
#                     END RECORD,
#   g_wc2,g_sql       STRING,  
#   g_rec_b           LIKE type_file.num5, #單身筆數
#   l_ac              LIKE type_file.num5  #目前處理的ARRAY CNT
#DEFINE g_forupd_sql  STRING               #SELECT ... FOR UPDATE SQL
#DEFINE g_cnt         LIKE type_file.num10
#DEFINE g_i           LIKE type_file.num5 
#DEFINE g_before_input_done   LIKE type_file.num5
# 
#MAIN
#   OPTIONS                  #改變一些系統預設值
#      INPUT NO WRAP
#   DEFER INTERRUPT          #擷取中斷鍵, 由程式處理
# 
#   IF (NOT cl_user()) THEN
#      EXIT PROGRAM
#   END IF
#  
#   WHENEVER ERROR CALL cl_err_msg_log
#  
#   IF (NOT cl_setup("AXR")) THEN
#      EXIT PROGRAM
#   END IF
# 
#    CALL  cl_used(g_prog,g_time,1) RETURNING g_time
# 
#    OPEN WINDOW i080_w WITH FORM "axr/42f/axri080"
#          ATTRIBUTE (STYLE = g_win_style CLIPPED)
#    
#    CALL cl_ui_init()
# 
#    LET g_wc2 = '1=1' CALL i080_b_fill(g_wc2)
#    CALL i080_menu()
#    CLOSE WINDOW i080_w                 #結束畫面
# 
#    CALL cl_used(g_prog,g_time,2) RETURNING g_time
#END MAIN
# 
#FUNCTION i080_menu()
# 
#   WHILE TRUE
#      CALL i080_bp("G")
#      CASE g_action_choice
#         WHEN "query" 
#            IF cl_chk_act_auth() THEN
#               CALL i080_q()
#            END IF
#         WHEN "detail" 
#            IF cl_chk_act_auth() THEN
#               CALL i080_b()
#            ELSE
#               LET g_action_choice = NULL
#            END IF
#         WHEN "help" 
#            CALL cl_show_help()
#         WHEN "exit"
#            EXIT WHILE
#         WHEN "controlg"
#            CALL cl_cmdask()
#         WHEN "exporttoexcel"
#             IF cl_chk_act_auth() THEN
#                CALL cl_export_to_excel
#                (ui.Interface.getRootNode(),base.TypeInfo.create(g_omm),'','')
#             END IF
#      END CASE
#   END WHILE
#END FUNCTION
# 
#FUNCTION i080_q()
#   CALL i080_b_askkey()
#END FUNCTION
# 
#FUNCTION i080_b()
#DEFINE
#   l_ac_t          LIKE type_file.num5,       #未取消的ARRAY CNT
#   l_n             LIKE type_file.num5,       #檢查重複用
#   l_lock_sw       LIKE type_file.chr1,       #單身鎖住否
#   p_cmd           LIKE type_file.chr1,       #處理狀態
#   l_allow_insert  LIKE type_file.chr1,
#   l_allow_delete  LIKE type_file.chr1
# 
#   LET g_action_choice = ""
# 
#   IF s_shut(0) THEN RETURN END IF
# 
#   LET l_allow_insert = cl_detail_input_auth('insert')
#   LET l_allow_delete = cl_detail_input_auth('delete')
# 
#   CALL cl_opmsg('b')
# 
#   LET g_forupd_sql = "SELECT omm00,omm01,omm011,omm02,omm021,omm03,omm031,",
#                      "       omm04,omm041,omm05,omm051,omm06,omm061,omm07,",
#                      "       omm071,omm08,omm081,omm09,omm091,omm10,omm101",
#                      "  FROM omm_file WHERE omm00=? FOR UPDATE"
# 
#   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
#   DECLARE i080_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
# 
#   INPUT ARRAY g_omm WITHOUT DEFAULTS FROM s_omm.* 
#      ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED, 
#      INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,
#      APPEND ROW=l_allow_insert)
# 
#      BEFORE INPUT
#         IF g_rec_b != 0 THEN
#            CALL fgl_set_arr_curr(l_ac) 
#         END IF
#
#      BEFORE ROW
#         LET p_cmd = ''
#         LET l_ac = ARR_CURR()
#         LET l_lock_sw = 'N'            #DEFAULT
#         LET l_n  = ARR_COUNT()
#         IF g_rec_b>=l_ac THEN
#            LET p_cmd='u'
#            LET g_omm_t.* = g_omm[l_ac].*  #BACKUP
#            LET g_before_input_done = FALSE
#            CALL i080_set_entry(p_cmd)
#            CALL i080_set_no_entry(p_cmd)
#            LET g_before_input_done = TRUE
#            BEGIN WORK
#            OPEN i080_bcl USING g_omm_t.omm00
#            IF STATUS THEN
#               CALL cl_err("OPEN i080_bcl:", STATUS, 1)
#               LET l_lock_sw = "Y"
#            ELSE  
#               FETCH i080_bcl INTO g_omm[l_ac].* 
#               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_omm_t.omm00,SQLCA.sqlcode,1)
#                  LET l_lock_sw = "Y"
#               END IF
#            END IF
#            CALL cl_show_fld_cont()
#         END IF
# 
#      BEFORE INSERT
#         LET l_n = ARR_COUNT()
#         LET p_cmd='a'
#         INITIALIZE g_omm[l_ac].* TO NULL
#         LET g_omm_t.* = g_omm[l_ac].*         #新輸入資料
#         LET g_before_input_done = FALSE
#         CALL i080_set_entry(p_cmd)
#         CALL i080_set_no_entry(p_cmd)
#         LET g_before_input_done = TRUE
#         CALL cl_show_fld_cont()
#         NEXT FIELD omm00
# 
#      AFTER INSERT
#         IF INT_FLAG THEN
#            CALL cl_err('',9001,0)
#            LET INT_FLAG = 0
#            CANCEL INSERT 
#         END IF
#         INSERT INTO omm_file(omm00,omm01,omm011,omm02,omm021,omm03,omm031,
#                                    omm04,omm041,omm05,omm051,omm06,omm061,
#                                    omm07,omm071,omm08,omm081,omm09,omm091,
#                                    omm10,omm101)
#           VALUES(g_omm[l_ac].omm00,g_omm[l_ac].omm01,g_omm[l_ac].omm011,
#                                    g_omm[l_ac].omm02,g_omm[l_ac].omm021,
#                                    g_omm[l_ac].omm03,g_omm[l_ac].omm031,
#                                    g_omm[l_ac].omm04,g_omm[l_ac].omm041,
#                                    g_omm[l_ac].omm05,g_omm[l_ac].omm051,
#                                    g_omm[l_ac].omm06,g_omm[l_ac].omm061,
#                                    g_omm[l_ac].omm07,g_omm[l_ac].omm071,
#                                    g_omm[l_ac].omm08,g_omm[l_ac].omm081,
#                                    g_omm[l_ac].omm09,g_omm[l_ac].omm091,
#                                    g_omm[l_ac].omm10,g_omm[l_ac].omm101)
#         IF SQLCA.sqlcode THEN
#            CALL cl_err3("ins","omm_file",g_omm[l_ac].omm00,"",SQLCA.sqlcode,"","",1)
#            CANCEL INSERT
#         ELSE
#            MESSAGE 'INSERT O.K'
#            LET g_rec_b=g_rec_b+1
#            DISPLAY g_rec_b TO FORMONLY.cn2  
#         END IF
# 
#      AFTER FIELD omm00                        #check 編號是否重複
#         IF NOT cl_null(g_omm[l_ac].omm00) THEN
#            IF g_omm[l_ac].omm00 != g_omm_t.omm00 OR
#               (NOT cl_null(g_omm[l_ac].omm00) AND cl_null(g_omm_t.omm00)) THEN
#               SELECT count(*) INTO l_n FROM omm_file
#                WHERE omm00 = g_omm[l_ac].omm00
#               IF l_n > 0 THEN
#                  CALL cl_err('',-239,1)
#                  LET g_omm[l_ac].omm00 = g_omm_t.omm00
#                  NEXT FIELD omm00
#               END IF
#            END IF
#         END IF
#
#      AFTER FIELD omm01
#         IF NOT cl_null(g_omm[l_ac].omm01) THEN
#            LET l_n = 0
#            SELECT COUNT(*) INTO l_n FROM ocg_file WHERE ocg01 = g_omm[l_ac].omm01
#            IF l_n < 1 THEN
#               CALL cl_err('','axr-326',1)
#               LET g_omm[l_ac].omm01 = g_omm_t.omm01
#               NEXT FIELD omm01
#            END IF
#         END IF
#
#      AFTER FIELD omm011
#         IF NOT cl_null(g_omm[l_ac].omm011) THEN
#            IF g_omm[l_ac].omm011 < 0 THEN
#               CALL cl_err('','mfg4012',1)
#               LET g_omm[l_ac].omm011 = g_omm_t.omm011
#               NEXT FIELD omm011
#            END IF
#         END IF
#
#      AFTER FIELD omm02
#         IF NOT cl_null(g_omm[l_ac].omm02) THEN
#            LET l_n = 0
#            SELECT COUNT(*) INTO l_n FROM ocg_file WHERE ocg01 = g_omm[l_ac].omm02
#            IF l_n < 1 THEN
#               CALL cl_err('','axr-326',1)
#               LET g_omm[l_ac].omm02 = g_omm_t.omm02
#               NEXT FIELD omm02
#            END IF
#         END IF
#
#      AFTER FIELD omm021
#         IF NOT cl_null(g_omm[l_ac].omm021) THEN
#            IF g_omm[l_ac].omm021 < 0 THEN
#               CALL cl_err('','mfg4012',1)
#               LET g_omm[l_ac].omm021 = g_omm_t.omm021
#               NEXT FIELD omm021
#            END IF
#         END IF
#
#      AFTER FIELD omm03
#         IF NOT cl_null(g_omm[l_ac].omm03) THEN
#            LET l_n = 0
#            SELECT COUNT(*) INTO l_n FROM ocg_file WHERE ocg01 = g_omm[l_ac].omm03
#            IF l_n < 1 THEN
#               CALL cl_err('','axr-326',1)
#               LET g_omm[l_ac].omm03 = g_omm_t.omm03
#               NEXT FIELD omm03
#            END IF
#         END IF
#
#      AFTER FIELD omm031
#         IF NOT cl_null(g_omm[l_ac].omm031) THEN
#            IF g_omm[l_ac].omm031 < 0 THEN
#               CALL cl_err('','mfg4012',1)
#               LET g_omm[l_ac].omm031 = g_omm_t.omm031
#               NEXT FIELD omm031
#            END IF
#         END IF
#
#      AFTER FIELD omm04
#         IF NOT cl_null(g_omm[l_ac].omm04) THEN
#            LET l_n = 0
#            SELECT COUNT(*) INTO l_n FROM ocg_file WHERE ocg01 = g_omm[l_ac].omm04
#            IF l_n < 1 THEN
#               CALL cl_err('','axr-326',1)
#               LET g_omm[l_ac].omm04 = g_omm_t.omm04
#               NEXT FIELD omm04
#            END IF
#         END IF
#
#      AFTER FIELD omm041
#         IF NOT cl_null(g_omm[l_ac].omm041) THEN
#            IF g_omm[l_ac].omm041 < 0 THEN
#               CALL cl_err('','mfg4012',1)
#               LET g_omm[l_ac].omm041 = g_omm_t.omm041
#               NEXT FIELD omm041
#            END IF
#         END IF
#
#      AFTER FIELD omm05
#         IF NOT cl_null(g_omm[l_ac].omm05) THEN
#            LET l_n = 0
#            SELECT COUNT(*) INTO l_n FROM ocg_file WHERE ocg01 = g_omm[l_ac].omm05
#            IF l_n < 1 THEN
#               CALL cl_err('','axr-326',1)
#               LET g_omm[l_ac].omm05 = g_omm_t.omm05
#               NEXT FIELD omm05
#            END IF
#         END IF
#
#      AFTER FIELD omm051
#         IF NOT cl_null(g_omm[l_ac].omm051) THEN
#            IF g_omm[l_ac].omm051 < 0 THEN
#               CALL cl_err('','mfg4012',1)
#               LET g_omm[l_ac].omm051 = g_omm_t.omm051
#               NEXT FIELD omm051
#            END IF
#         END IF
#
#      AFTER FIELD omm06
#         IF NOT cl_null(g_omm[l_ac].omm06) THEN
#            LET l_n = 0
#            SELECT COUNT(*) INTO l_n FROM ocg_file WHERE ocg01 = g_omm[l_ac].omm06
#            IF l_n < 1 THEN
#               CALL cl_err('','axr-326',1)
#               LET g_omm[l_ac].omm06 = g_omm_t.omm06
#               NEXT FIELD omm06
#            END IF
#         END IF
#
#      AFTER FIELD omm061
#         IF NOT cl_null(g_omm[l_ac].omm061) THEN
#            IF g_omm[l_ac].omm061 < 0 THEN
#               CALL cl_err('','mfg4012',1)
#               LET g_omm[l_ac].omm061 = g_omm_t.omm061
#               NEXT FIELD omm061
#            END IF
#         END IF
#
#      AFTER FIELD omm07
#         IF NOT cl_null(g_omm[l_ac].omm07) THEN
#            LET l_n = 0
#            SELECT COUNT(*) INTO l_n FROM ocg_file WHERE ocg01 = g_omm[l_ac].omm07
#            IF l_n < 1 THEN
#               CALL cl_err('','axr-326',1)
#               LET g_omm[l_ac].omm07 = g_omm_t.omm07
#               NEXT FIELD omm07
#            END IF
#         END IF
#
#      AFTER FIELD omm071
#         IF NOT cl_null(g_omm[l_ac].omm071) THEN
#            IF g_omm[l_ac].omm071 < 0 THEN
#               CALL cl_err('','mfg4012',1)
#               LET g_omm[l_ac].omm071 = g_omm_t.omm071
#               NEXT FIELD omm071
#            END IF
#         END IF
#
#      AFTER FIELD omm08
#         IF NOT cl_null(g_omm[l_ac].omm08) THEN
#            LET l_n = 0
#            SELECT COUNT(*) INTO l_n FROM ocg_file WHERE ocg01 = g_omm[l_ac].omm08
#            IF l_n < 1 THEN
#               CALL cl_err('','axr-326',1)
#               LET g_omm[l_ac].omm08 = g_omm_t.omm08
#               NEXT FIELD omm08
#            END IF
#         END IF
#
#      AFTER FIELD omm081
#         IF NOT cl_null(g_omm[l_ac].omm081) THEN
#            IF g_omm[l_ac].omm081 < 0 THEN
#               CALL cl_err('','mfg4012',1)
#               LET g_omm[l_ac].omm081 = g_omm_t.omm081
#               NEXT FIELD omm081
#            END IF
#         END IF
#
#      AFTER FIELD omm09
#         IF NOT cl_null(g_omm[l_ac].omm09) THEN
#            LET l_n = 0
#            SELECT COUNT(*) INTO l_n FROM ocg_file WHERE ocg01 = g_omm[l_ac].omm09
#            IF l_n < 1 THEN
#               CALL cl_err('','axr-326',1)
#               LET g_omm[l_ac].omm09 = g_omm_t.omm09
#               NEXT FIELD omm09
#            END IF
#         END IF
#
#      AFTER FIELD omm091
#         IF NOT cl_null(g_omm[l_ac].omm091) THEN
#            IF g_omm[l_ac].omm091 < 0 THEN
#               CALL cl_err('','mfg4012',1)
#               LET g_omm[l_ac].omm091 = g_omm_t.omm091
#               NEXT FIELD omm091
#            END IF
#         END IF
#
#      AFTER FIELD omm10
#         IF NOT cl_null(g_omm[l_ac].omm10) THEN
#            LET l_n = 0
#            SELECT COUNT(*) INTO l_n FROM ocg_file WHERE ocg01 = g_omm[l_ac].omm10
#            IF l_n < 1 THEN
#               CALL cl_err('','axr-326',1)
#               LET g_omm[l_ac].omm10 = g_omm_t.omm10
#               NEXT FIELD omm10
#            END IF
#         END IF
#
#      AFTER FIELD omm101
#         IF NOT cl_null(g_omm[l_ac].omm101) THEN
#            IF g_omm[l_ac].omm101 < 0 THEN
#               CALL cl_err('','mfg4012',1)
#               LET g_omm[l_ac].omm101 = g_omm_t.omm101
#               NEXT FIELD omm101
#            END IF
#         END IF
#
#      BEFORE DELETE                            #是否取消單身
#      IF g_omm_t.omm00 IS NOT NULL THEN
#         IF NOT cl_delete() THEN
#            CANCEL DELETE
#         END IF
#         IF l_lock_sw = "Y" THEN 
#            CALL cl_err("", -263, 1) 
#            CANCEL DELETE 
#         END IF 
#         DELETE FROM omm_file WHERE omm00 = g_omm_t.omm00
#         IF SQLCA.sqlcode THEN
#            CALL cl_err3("del","omm_file",g_omm_t.omm00,"",SQLCA.sqlcode,"","",1)
#            ROLLBACK WORK
#            CANCEL DELETE
#         END IF
#         LET g_rec_b=g_rec_b-1
#         DISPLAY g_rec_b TO FORMONLY.cn2  
#         MESSAGE "Delete OK" 
#         CLOSE i080_bcl     
#         COMMIT WORK
#      END IF
# 
#      ON ROW CHANGE
#         IF INT_FLAG THEN                 #新增程式段
#            CALL cl_err('',9001,0)
#            LET INT_FLAG = 0
#            LET g_omm[l_ac].* = g_omm_t.*
#            CLOSE i080_bcl
#            ROLLBACK WORK
#            EXIT INPUT
#         END IF
#         IF l_lock_sw = 'Y' THEN
#            CALL cl_err(g_omm[l_ac].omm00,-263,1)
#            LET g_omm[l_ac].* = g_omm_t.*
#         ELSE
#            UPDATE omm_file SET omm00 = g_omm[l_ac].omm00,
#                   omm01 = g_omm[l_ac].omm01,omm011 = g_omm[l_ac].omm011,
#                   omm02 = g_omm[l_ac].omm02,omm021 = g_omm[l_ac].omm021,
#                   omm03 = g_omm[l_ac].omm03,omm031 = g_omm[l_ac].omm031,
#                   omm04 = g_omm[l_ac].omm04,omm041 = g_omm[l_ac].omm041,
#                   omm05 = g_omm[l_ac].omm05,omm051 = g_omm[l_ac].omm051,
#                   omm06 = g_omm[l_ac].omm06,omm061 = g_omm[l_ac].omm061,
#                   omm07 = g_omm[l_ac].omm07,omm071 = g_omm[l_ac].omm071,
#                   omm08 = g_omm[l_ac].omm08,omm081 = g_omm[l_ac].omm081,
#                   omm09 = g_omm[l_ac].omm09,omm091 = g_omm[l_ac].omm091,
#                   omm10 = g_omm[l_ac].omm10,omm101 = g_omm[l_ac].omm101
#             WHERE omm00 = g_omm_t.omm00
#            IF SQLCA.sqlcode THEN
#               CALL cl_err3("upd","omm_file",g_omm_t.omm00,"",SQLCA.sqlcode,"","",1)
#               LET g_omm[l_ac].* = g_omm_t.*
#            ELSE
#               MESSAGE 'UPDATE O.K'
#               COMMIT WORK
#            END IF
#         END IF
# 
#      AFTER ROW
#         LET l_ac = ARR_CURR()                                               
#         IF INT_FLAG THEN                         
#            CALL cl_err('',9001,0)                                           
#            LET INT_FLAG = 0                                                 
#            IF p_cmd = 'u' THEN
#               LET g_omm[l_ac].* = g_omm_t.*                                    
#            END IF
#            CLOSE i080_bcl                                                   
#            ROLLBACK WORK                                                    
#            EXIT INPUT                                                       
#         END IF                                                              
#         LET l_ac_t = l_ac                                                   
#         CLOSE i080_bcl                                                      
#         COMMIT WORK            
#
#      ON ACTION controlp
#         CASE
#            WHEN INFIELD(omm01) 
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_ocg"
#               LET g_qryparam.default1 = g_omm[l_ac].omm01
#               CALL cl_create_qry() RETURNING g_omm[l_ac].omm01
#               DISPLAY BY NAME g_omm[l_ac].omm01
#               NEXT FIELD omm01
#            WHEN INFIELD(omm02) 
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_ocg"
#               LET g_qryparam.default1 = g_omm[l_ac].omm02
#               CALL cl_create_qry() RETURNING g_omm[l_ac].omm02
#               DISPLAY BY NAME g_omm[l_ac].omm02
#               NEXT FIELD omm02
#            WHEN INFIELD(omm03) 
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_ocg"
#               LET g_qryparam.default1 = g_omm[l_ac].omm03
#               CALL cl_create_qry() RETURNING g_omm[l_ac].omm03
#               DISPLAY BY NAME g_omm[l_ac].omm03
#               NEXT FIELD omm03
#            WHEN INFIELD(omm04) 
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_ocg"
#               LET g_qryparam.default1 = g_omm[l_ac].omm04
#               CALL cl_create_qry() RETURNING g_omm[l_ac].omm04
#               DISPLAY BY NAME g_omm[l_ac].omm04
#               NEXT FIELD omm04
#            WHEN INFIELD(omm05) 
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_ocg"
#               LET g_qryparam.default1 = g_omm[l_ac].omm05
#               CALL cl_create_qry() RETURNING g_omm[l_ac].omm05
#               DISPLAY BY NAME g_omm[l_ac].omm05
#               NEXT FIELD omm05
#            WHEN INFIELD(omm06) 
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_ocg"
#               LET g_qryparam.default1 = g_omm[l_ac].omm06
#               CALL cl_create_qry() RETURNING g_omm[l_ac].omm06
#               DISPLAY BY NAME g_omm[l_ac].omm06
#               NEXT FIELD omm06
#            WHEN INFIELD(omm07) 
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_ocg"
#               LET g_qryparam.default1 = g_omm[l_ac].omm07
#               CALL cl_create_qry() RETURNING g_omm[l_ac].omm07
#               DISPLAY BY NAME g_omm[l_ac].omm07
#               NEXT FIELD omm07
#            WHEN INFIELD(omm08) 
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_ocg"
#               LET g_qryparam.default1 = g_omm[l_ac].omm08
#               CALL cl_create_qry() RETURNING g_omm[l_ac].omm08
#               DISPLAY BY NAME g_omm[l_ac].omm08
#               NEXT FIELD omm08
#            WHEN INFIELD(omm09) 
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_ocg"
#               LET g_qryparam.default1 = g_omm[l_ac].omm09
#               CALL cl_create_qry() RETURNING g_omm[l_ac].omm09
#               DISPLAY BY NAME g_omm[l_ac].omm09
#               NEXT FIELD omm09
#            WHEN INFIELD(omm10) 
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_ocg"
#               LET g_qryparam.default1 = g_omm[l_ac].omm10
#               CALL cl_create_qry() RETURNING g_omm[l_ac].omm10
#               DISPLAY BY NAME g_omm[l_ac].omm10
#               NEXT FIELD omm10
#          END CASE
#
#      ON ACTION CONTROLN
#         CALL i080_b_askkey()
#         EXIT INPUT
# 
#      ON ACTION CONTROLO                        #沿用所有欄位
#         IF INFIELD(omm00) AND l_ac > 1 THEN
#            LET g_omm[l_ac].* = g_omm[l_ac-1].*
#               NEXT FIELD omm00
#            END IF
# 
#      ON ACTION CONTROLR
#         CALL cl_show_req_fields()
# 
#      ON ACTION CONTROLG
#         CALL cl_cmdask()
# 
#      ON ACTION CONTROLF
#         CALL cl_set_focus_form(ui.Interface.getRootNode()) 
#                     RETURNING g_fld_name,g_frm_name
#         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
#          
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE INPUT
# 
#      ON ACTION about
#         CALL cl_about()
# 
#      ON ACTION help
#         CALL cl_show_help()
#
#   END INPUT
#
#   CLOSE i080_bcl
#   COMMIT WORK
#END FUNCTION
# 
#FUNCTION i080_b_askkey()
#   CLEAR FORM
#   CALL g_omm.clear()
#   CONSTRUCT g_wc2 ON omm00,omm01,omm011,omm02,omm021,omm03,omm031,
#                      omm04,omm041,omm05,omm051,omm06,omm061,omm07,
#                      omm071,omm08,omm081,omm09,omm091,omm10,omm101
#            FROM s_omm[1].omm00,s_omm[1].omm01,s_omm[1].omm011,
#                 s_omm[1].omm02,s_omm[1].omm021,s_omm[1].omm03,
#                 s_omm[1].omm031,s_omm[1].omm04,s_omm[1].omm041,
#                 s_omm[1].omm05,s_omm[1].omm051,s_omm[1].omm06,
#                 s_omm[1].omm061,s_omm[1].omm07,s_omm[1].omm071,
#                 s_omm[1].omm08,s_omm[1].omm081,s_omm[1].omm09,
#                 s_omm[1].omm091,s_omm[1].omm10,s_omm[1].omm101
#      BEFORE CONSTRUCT
#         CALL cl_qbe_init()
#
#      ON ACTION controlp
#         CASE
#            WHEN INFIELD(omm01) 
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_ocg"
#               LET g_qryparam.state = "c"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret 
#               DISPLAY g_qryparam.multiret TO omm01
#               NEXT FIELD omm01
#            WHEN INFIELD(omm02) 
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_ocg"
#               LET g_qryparam.state = "c"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret 
#               DISPLAY g_qryparam.multiret TO omm02
#               NEXT FIELD omm02
#            WHEN INFIELD(omm03) 
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_ocg"
#               LET g_qryparam.state = "c"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO omm03
#               NEXT FIELD omm03
#            WHEN INFIELD(omm04) 
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_ocg"
#               LET g_qryparam.state = "c"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO omm04
#               NEXT FIELD omm04
#            WHEN INFIELD(omm05) 
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_ocg"
#               LET g_qryparam.state = "c"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO omm05
#               NEXT FIELD omm05
#            WHEN INFIELD(omm06) 
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_ocg"
#               LET g_qryparam.state = "c"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO omm06
#               NEXT FIELD omm06
#            WHEN INFIELD(omm07) 
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_ocg"
#               LET g_qryparam.state = "c"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO omm07
#               NEXT FIELD omm07
#            WHEN INFIELD(omm08) 
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_ocg"
#               LET g_qryparam.state = "c"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO omm08
#               NEXT FIELD omm08
#            WHEN INFIELD(omm09) 
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_ocg"
#               LET g_qryparam.state = "c"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO omm09
#               NEXT FIELD omm09
#            WHEN INFIELD(omm10) 
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_ocg"
#               LET g_qryparam.state = "c"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO omm10
#               NEXT FIELD omm10
#          END CASE
#
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE CONSTRUCT
# 
#      ON ACTION about
#         CALL cl_about()
# 
#      ON ACTION help
#         CALL cl_show_help()
# 
#      ON ACTION controlg
#         CALL cl_cmdask()
#
#      ON ACTION qbe_select
#         CALL cl_qbe_select() 
#
#      ON ACTION qbe_save
#         CALL cl_qbe_save()
#
#   END CONSTRUCT
#
#   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null)
#   IF INT_FLAG THEN
#      LET INT_FLAG = 0
#      LET g_wc2 = NULL
#      RETURN
#   END IF
#
#   CALL i080_b_fill(g_wc2)
#   
#END FUNCTION
# 
#FUNCTION i080_b_fill(p_wc2)                   #BODY FILL UP
#DEFINE
#    p_wc2           LIKE type_file.chr1000
# 
#    LET g_sql =
#        "SELECT omm00,omm01,omm011,omm02,omm021,omm03,omm031,omm04,",
#        "       omm041,omm05,omm051,omm06,omm061,omm07,omm071,omm08,",
#        "       omm081,omm09,omm091,omm10,omm101 ",
#        " FROM omm_file",
#        " WHERE ", p_wc2 CLIPPED,                     #單身
#        " ORDER BY omm00"
#    PREPARE i080_pb FROM g_sql
#    DECLARE omm_curs CURSOR FOR i080_pb
# 
#    CALL g_omm.clear()
#    LET g_cnt = 1
#    MESSAGE "Searching!" 
#    FOREACH omm_curs INTO g_omm[g_cnt].*   #單身 ARRAY 填充
#        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
#        LET g_cnt = g_cnt + 1
#        IF g_cnt > g_max_rec THEN
#           CALL cl_err( '', 9035, 0 )
#           EXIT FOREACH
#        END IF
#    END FOREACH
#    CALL g_omm.deleteElement(g_cnt)
#    MESSAGE ""
#    LET g_rec_b = g_cnt-1
#    DISPLAY g_rec_b TO FORMONLY.cn2  
#    LET g_cnt = 0
# 
#END FUNCTION
# 
#FUNCTION i080_bp(p_ud)
#   DEFINE   p_ud   LIKE type_file.chr1
# 
#   IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
#      RETURN                                                                    
#   END IF                                                                       
# 
#   LET g_action_choice = " "
# 
#   CALL cl_set_act_visible("accept,cancel", FALSE)
#   DISPLAY ARRAY g_omm TO s_omm.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
# 
#      BEFORE ROW
#         LET l_ac = ARR_CURR()
#      CALL cl_show_fld_cont()
# 
#      ##########################################################################
#      # Standard 4ad ACTION
#      ##########################################################################
#      ON ACTION query
#         LET g_action_choice="query"
#         EXIT DISPLAY
#      ON ACTION detail
#         LET g_action_choice="detail"
#         EXIT DISPLAY
#      ON ACTION help
#         LET g_action_choice="help"
#         EXIT DISPLAY
# 
#      ON ACTION locale
#         CALL cl_dynamic_locale()
#          CALL cl_show_fld_cont()
# 
#      ON ACTION exit
#         LET g_action_choice="exit"
#         EXIT DISPLAY
# 
#      ##########################################################################
#      # Special 4ad ACTION
#      ##########################################################################
#      ON ACTION controlg
#         LET g_action_choice="controlg"
#         EXIT DISPLAY
# 
#      ON ACTION accept                                                          
#         LET g_action_choice="detail"                                           
#         LET l_ac = ARR_CURR()                                                  
#         EXIT DISPLAY                                                           
#                                                                                
#      ON ACTION cancel                                                          
#             LET INT_FLAG=FALSE
#         LET g_action_choice="exit"                                             
#         EXIT DISPLAY                                                           
# 
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE DISPLAY
# 
#      ON ACTION about
#         CALL cl_about()
#
#      ON ACTION exporttoexcel
#         LET g_action_choice = 'exporttoexcel'
#         EXIT DISPLAY
#
#      AFTER DISPLAY
#         CONTINUE DISPLAY
#
#   END DISPLAY
#   CALL cl_set_act_visible("accept,cancel", TRUE)
#END FUNCTION
#
#FUNCTION i080_set_entry(p_cmd)                                                  
#  DEFINE p_cmd   LIKE type_file.chr1                                                         #No.FUN-680123
#
#   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
#      CALL cl_set_comp_entry("omm00",TRUE)                                       
#   END IF                                                                       
#END FUNCTION                                                                    
#                                                                                
#FUNCTION i080_set_no_entry(p_cmd)                                               
#  DEFINE p_cmd   LIKE type_file.chr1                                                      #No.FUN-680123
#
#   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
#      CALL cl_set_comp_entry("omm00",FALSE)                                      
#   END IF                                                                       
#END FUNCTION
#FUN-B70131---end---
