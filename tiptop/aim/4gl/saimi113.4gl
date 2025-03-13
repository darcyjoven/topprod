# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: saimi113.4gl
# Descriptions...: 料件分群碼基本資料維護作業-成本資料
# Date & Author..: 92/01/02 By  MAY
# Modify.........: No.MOD-480047 04/08/20 By Nicola 成本中心開窗取消時，回傳錯誤
# Modify.........: No.FUN-4C0053 04/12/08 By Mandy Q,U,R 加入權限控管處理
# Modify.........: No.FUN-510017 05/01/13 By Mandy 報表轉XML
# Modify.........: No.FUN-560183 05/06/22 By kim 移除imz86成本單位
# Modify.........: No.MOD-590038 05/10/17 By Rosayu 沒有第一筆、最後一筆、指定筆的按鈕
# Modify.........: NO.FUN-660156 06/06/26 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-640213 06/07/13 By rainy 連續二次查詢key值時,若第二次查詢不到key值時, 會顯示錯誤key值
# Modify.........: No.FUN-690026 06/09/12 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-680046 06/09/26 By jamie 1.FUNCTION i113_q() 一開始應清空g_imz.*值
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
#                                                    2.新增action"相關文件"
# Modify.........: No.TQC-6A0078 06/11/09 By ice 修正報表格式錯誤
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.CHI-730030 07/04/10 By claire 加入成本說明
# Modify.........: No.MOD-780100 07/08/17 By kim 成本中心開窗及其他欄位輸入的問題
# Modify.........: No.FUN-7C0043 07/12/25 By destiny 報表改為p_query輸出
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-A10072 10/01/07 By sherry "間接物料分攤率 ""間接人工分攤率"欄位沒有做大於100的控管
# Modify.........: No:MOD-AC0331 10/12/27 By lixh1 查看成本資料時,改為系統自動進入顯示狀態
# Modify.........: No:TQC-B20025 11/02/12 By destiny show的时候未显示oriu,orig
# Modify.........: No.TQC-B90177 11/09/29 By destiny oriu,orig不能查询
# Modify.........: No.TQC-C40155 12/04/18 By xianghui 修改時點取消，還原成舊值的處理
# Modify.........: No.TQC-C40219 12/04/24 By xianghui 修正TQC-C40155的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_argv1             LIKE imz_file.imz01,
    g_imz               RECORD LIKE imz_file.*,
    g_imz_t             RECORD LIKE imz_file.*,
    g_imz_o             RECORD LIKE imz_file.*,
    g_imz01_t           LIKE imz_file.imz01,
    g_sw                LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    g_wc,g_sql          STRING                  #TQC-630166
 
DEFINE g_forupd_sql    STRING                   #SELECT ... FOR UPDATE SQL
DEFINE g_chr           LIKE type_file.chr1      #No.FUN-690026 VARCHAR(1)
DEFINE g_cnt           LIKE type_file.num10     #No.FUN-690026 INTEGER
DEFINE g_i             LIKE type_file.num5      #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_msg           LIKE type_file.chr1000   #No.FUN-690026 VARCHAR(72)
DEFINE g_row_count     LIKE type_file.num10     #No.FUN-690026 INTEGER
DEFINE g_curs_index    LIKE type_file.num10     #No.FUN-690026 INTEGER
DEFINE g_jump          LIKE type_file.num10     #No.FUN-690026 INTEGER
DEFINE g_no_ask       LIKE type_file.num5      #No.FUN-690026 SMALLINT

FUNCTION aimi113(p_argv1)
    DEFINE  p_argv1         LIKE imz_file.imz01

    WHENEVER ERROR CALL cl_err_msg_log
 
    INITIALIZE g_imz.* TO NULL
    INITIALIZE g_imz_t.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM imz_file WHERE imz01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE aimi113_curl CURSOR FROM g_forupd_sql              # LOCK CURSOR

    OPEN WINDOW aimi113_w WITH FORM "aim/42f/aimi113"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    LET g_argv1 = p_argv1
    IF g_argv1 IS NOT NULL AND g_argv1 != ' ' THEN
       CALL aimi113_q()
      #CALL aimi113_u()      #MOD-AC0331
    END IF
 
    WHILE TRUE
      LET g_action_choice=""
    CALL aimi113_menu()
      IF g_action_choice="exit" THEN EXIT WHILE END IF
    END WHILE
 
    CLOSE WINDOW aimi113_w
END FUNCTION
 
FUNCTION aimi113_curs()
    CLEAR FORM
    IF g_argv1 IS NULL OR g_argv1 = " " THEN
       INITIALIZE g_imz.* TO NULL    #FUN-640213 add
       CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
           imz01, imz02, imz08, imz25, imz03,
          #imz86, imz86_fac, #FUN-560183
           imz34, imz87, imz872,imz874,
           imz871,imz873,imzuser, imzgrup,
           imzmodu, imzdate, imzacti
           ,imzoriu,imzorig  #TQC-B90177
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION controlp
           CASE
              #Mark by FUN-560183
              {
              WHEN INFIELD(imz86)                       # 成本單位 (imz86)
#                CALL q_gfe(10,3,g_imz.imz86) RETURNING g_imz.imz86
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_gfe"
                 LET g_qryparam.default1 = g_imz.imz86
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO imz86
                 NEXT FIELD imz86
              }
              WHEN INFIELD(imz34) #成本中心
#                CALL q_smh(11,4) RETURNING g_imz.imz34
                 CALL cl_init_qry_var()
                #LET g_qryparam.form ="q_smh"  #MOD-780100
                 LET g_qryparam.form = "q_gem" #MOD-780100
                 LET g_qryparam.state ="c"
                 LET g_qryparam.default1 = g_imz.imz34 #MOD-780100
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO imz34
                 NEXT FIELD imz34
              WHEN INFIELD(imz87)                       # 成本項目 (imz86)
#                CALL q_smg(11,32,g_imz.imz87) RETURNING g_imz.imz87
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_smg"
                 LET g_qryparam.state ="c"
                 LET g_qryparam.default1 = g_imz.imz87
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO imz87
                 NEXT FIELD imz87
              WHEN INFIELD(imz872)           #材料制造費用成本項目
#                CALL q_smg(11,32,g_imz.imz872) RETURNING g_imz.imz872
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_smg"
                 LET g_qryparam.state ="c"
                 LET g_qryparam.default1 = g_imz.imz872
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO imz872
                 NEXT FIELD imz872
              WHEN INFIELD(imz874)           #人工制造費用成本項目
#                CALL q_smg(11,32,g_imz.imz874) RETURNING g_imz.imz874
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_smg"
                 LET g_qryparam.state ="c"
                 LET g_qryparam.default1 = g_imz.imz874
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO imz874
                 NEXT FIELD imz874
               OTHERWISE EXIT CASE
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
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
        END CONSTRUCT
        IF INT_FLAG THEN RETURN END IF
    ELSE
       LET g_wc = " imz01 = '",g_argv1,"'"
    END IF
      #資料權限的檢查
      #Begin:FUN-980030
      #      IF g_priv2='4' THEN                           #只能使用自己的資料
      #          LET g_wc = g_wc clipped," AND imzuser = '",g_user,"'"
      #      END IF
      #      IF g_priv3='4' THEN                           #只能使用相同群的資料
      #          LET g_wc = g_wc clipped," AND imzgrup MATCHES '",g_grup CLIPPED,"*'"
      #      END IF
 
      #      IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
      #          LET g_wc = g_wc clipped," AND imzgrup IN ",cl_chk_tgrup_list()
      #      END IF
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('imzuser', 'imzgrup')
      #End:FUN-980030
 
    LET g_sql="SELECT imz01 FROM imz_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY imz01"
    PREPARE aimi113_prepare FROM g_sql             # RUNTIME 編譯
    DECLARE aimi113_curs                           # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR aimi113_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM imz_file WHERE ",g_wc CLIPPED
    PREPARE aimi113_precount FROM g_sql
    DECLARE aimi113_count CURSOR FOR aimi113_precount
END FUNCTION
 
FUNCTION aimi113_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL aimi113_q()
            END IF
        ON ACTION next
            CALL aimi113_fetch('N')
        ON ACTION previous
            CALL aimi113_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL aimi113_u()
            END IF
       ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth() 
               THEN CALL aimi113_out()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           CALL cl_set_field_pic("","","","","",g_imz.imzacti)
#           EXIT MENU
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU

        ON ACTION jump
            CALL aimi113_fetch('/')
        ON ACTION first
            CALL aimi113_fetch('F')
        ON ACTION last
            CALL aimi113_fetch('L')

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      #相關文件"
      ON ACTION related_document                          #No.FUN-680046
          LET g_action_choice="related_document"
              IF cl_chk_act_auth() THEN
                 IF g_imz.imz01 IS NOT NULL THEN
                  LET g_doc.column1 = "imz01"
                  LET g_doc.value1 = g_imz.imz01
                  CALL cl_doc()
              END IF
           END IF 
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
 
    END MENU
    CLOSE aimi113_curs
END FUNCTION
 
 
FUNCTION aimi113_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
        l_imz08         LIKE imz_file.imz08,
        p_flag          LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       #p_imz86_fac     LIKE imz_file.imz86_fac,#FUN-560183
        l_n             LIKE type_file.num5     #No.FUN-690026 SMALLINT
 
    DISPLAY BY NAME g_imz.imzuser,g_imz.imzgrup,
      g_imz.imzdate, g_imz.imzacti
    INPUT BY NAME
     #g_imz.imz86, g_imz.imz86_fac, #FUN-560183
      g_imz.imz34,g_imz.imz87 ,
      g_imz.imz872, g_imz.imz874,   g_imz.imz871,
      g_imz.imz873
      WITHOUT DEFAULTS
 
#Mark by FUN-560183
{
      AFTER FIELD imz86           #成本單位
         IF g_imz.imz86 IS NOT NULL THEN
            IF g_imz_o.imz86 IS NULL OR (g_imz.imz86 != g_imz_o.imz86 ) THEN
               SELECT gfe01
                 FROM gfe_file WHERE gfe01=g_imz.imz86 AND
                                     gfeacti IN ('Y','y')
               IF SQLCA.sqlcode  THEN
#                 CALL cl_err(g_imz.imz86,'mfg1203',0) #No.FUN-660156
                  CALL cl_err3("sel","gfe_file",g_imz.imz86,"","mfg1203","",
                               "",1)   #No.FUN-660156
                  LET g_imz.imz86 = g_imz_o.imz86
                  DISPLAY BY NAME g_imz.imz86
                  NEXT FIELD imz86
               END IF
            END IF
         END IF
#--->default 轉換率 1992/10/20 by pin
         IF g_imz.imz25 IS NULL OR g_imz.imz86 IS NULL
            OR g_imz.imz25=' ' OR g_imz.imz86 =' ' THEN
            LET g_imz.imz86_fac = ''
            DISPLAY BY NAME g_imz.imz86_fac
         ELSE
            IF g_imz.imz25 = g_imz.imz86 THEN
               LET g_imz.imz86_fac = 1
               DISPLAY BY NAME g_imz.imz86_fac
            ELSE
               IF (g_imz_o.imz25 !=g_imz.imz25) OR
                  (g_imz_o.imz86 !=g_imz.imz86) OR
                  (g_imz_o.imz86 IS NULL OR g_imz_o.imz86=' ') THEN
                  CALL s_umfchk('',g_imz.imz86,g_imz.imz25)
                  RETURNING p_flag,p_imz86_fac
                  IF NOT p_flag THEN
                     LET g_imz.imz86_fac=p_imz86_fac
                     DISPLAY  BY NAME g_imz.imz86_fac
                  ELSE
                     CALL cl_err(g_imz.imz86,'mfg1206',0)
                     NEXT FIELD imz86
                  END IF
               END IF
            END IF
         END IF
         LET g_imz_o.imz86 = g_imz.imz86
         LET g_imz_o.imz86_fac = g_imz.imz86_fac
 
      AFTER FIELD imz86_fac
         IF g_imz.imz86 IS NOT NULL AND g_imz.imz25 IS NOT NULL
            AND g_imz.imz86 !=' ' AND g_imz.imz25 !=' ' THEN
            IF g_imz.imz86_fac IS NULL OR g_imz.imz86_fac = ' '
               OR g_imz.imz86_fac <= 0 THEN
               CALL cl_err(g_imz.imz86_fac,'mfg1322',0)
               LET g_imz.imz86_fac = g_imz_o.imz86_fac
               DISPLAY BY NAME g_imz.imz86_fac
               NEXT FIELD imz86_fac
            END IF
         END IF
         LET g_imz_o.imz86_fac = g_imz.imz86_fac
}
      AFTER FIELD imz34     #成本中心
         IF g_imz.imz34 IS NOT NULL THEN
            IF (g_imz_o.imz34 IS NULL) OR (g_imz_o.imz34 != g_imz.imz34) THEN
              #MOD-780100...............mark begin
              #SELECT smh01 FROM smh_file
              # WHERE smh01 = g_imz.imz34
              #IF SQLCA.sqlcode != 0 THEN
#             #   CALL cl_err(g_imz.imz34,'mfg1318',0) #No.FUN-660156
              #   CALL cl_err3("sel","smh_file",g_imz.imz34,"","mfg1318","",
              #                "",1)   #No.FUN-660156
              #   LET g_imz.imz34 = g_imz_o.imz34
              #   DISPLAY BY NAME g_imz.imz34
              #   NEXT FIELD imz34
              #END IF
              #MOD-780100...............mark end
              #CHI-730030-begin-add
               CALL aimi113_imz34('a')
               IF g_chr = 'E' THEN
                  CALL cl_err(g_imz.imz34,100,0)
                  LET g_imz.imz34 = g_imz_o.imz34
                  DISPLAY BY NAME g_imz.imz34
                  NEXT FIELD imz34
               END IF
              #CHI-730030-end-add
            END IF
         ELSE
            DISPLAY NULL TO FORMONLY.smh02   #MOD-780100
         END IF
         LET g_imz_o.imz34 = g_imz.imz34
 
      AFTER FIELD imz87          #成本項目
         IF g_imz.imz87 IS NOT NULL  AND g_imz.imz87 != ' ' THEN
            IF (g_imz_o.imz87 IS NULL) OR
               (g_imz.imz87 != g_imz_o.imz87) THEN
               CALL aimi113_imz87('a')
               IF g_chr = 'E' THEN
                  CALL cl_err(g_imz.imz87,'mfg1313',0)
                  LET g_imz.imz87 = g_imz_o.imz87
                  DISPLAY BY NAME g_imz.imz87
                  NEXT FIELD imz87
               END IF
            END IF
         ELSE
            DISPLAY NULL TO FORMONLY.smg02_1 #MOD-780100
         END IF
         LET g_imz_o.imz87 = g_imz.imz87
 
      AFTER FIELD imz872          #材料製造費用成本項目
         IF g_imz.imz872 IS NOT NULL AND g_imz.imz872 != ' ' THEN
            IF (g_imz_o.imz872 IS NULL) OR
               (g_imz.imz872 != g_imz_o.imz872) THEN
               CALL aimi113_imz872('a')
               IF g_chr = 'E' THEN
                  CALL cl_err(g_imz.imz872,'mfg1313',0)
                  LET g_imz.imz872 = g_imz_o.imz872
                  DISPLAY BY NAME g_imz.imz872
                  NEXT FIELD imz872
               END IF
            END IF
         ELSE
            DISPLAY NULL TO FORMONLY.smg02_2 #MOD-780100
         END IF
         LET g_imz_o.imz872 = g_imz.imz872
 
      AFTER FIELD imz874          #人工製造費用成本項目
         IF g_imz.imz874 IS NOT NULL AND g_imz.imz874 != ' ' THEN
            IF (g_imz_o.imz874 IS NULL) OR
               (g_imz.imz874 != g_imz_o.imz874) THEN
               CALL aimi113_imz874('a')
               IF g_chr = 'E' THEN
                  CALL cl_err(g_imz.imz874,'mfg1313',0)
                  LET g_imz.imz874 = g_imz_o.imz874
                  DISPLAY BY NAME g_imz.imz874
                  NEXT FIELD imz874
               END IF
            END IF
         ELSE
            DISPLAY NULL TO FORMONLY.smg02_3 #MOD-780100
         END IF
         LET g_imz_o.imz874 = g_imz.imz874
 
      AFTER FIELD imz871
         #IF g_imz.imz871 < 0 THEN     #TQC-A10072
         IF g_imz.imz871 < 0 or g_imz.imz871>100 THEN   #TQC-A10072
            CALL cl_err(g_imz.imz871,'mfg0013',0)
            LET g_imz.imz871 = g_imz_o.imz871
            DISPLAY BY NAME g_imz.imz871
            NEXT FIELD imz871
         END IF
         LET g_imz_o.imz871 = g_imz.imz871
 
      AFTER FIELD imz873
         #IF g_imz.imz873 < 0 THEN   #TQC-A10072
         IF g_imz.imz873 < 0 or g_imz.imz873 > 100 THEN #TQC-A10072
            CALL cl_err(g_imz.imz873,'mfg0013',0)
            LET g_imz.imz873 = g_imz_o.imz873
            DISPLAY BY NAME g_imz.imz873
            NEXT FIELD imz873
         END IF
         LET g_imz_o.imz873 = g_imz.imz873
 
        ON ACTION mntn_unit
                    CALL cl_cmdrun("aooi101 ")
 
        ON ACTION mntn_unit_conv
                    CALL cl_cmdrun("aooi102 ")
 
        ON ACTION mntn_item_unit_conv
                    CALL cl_cmdrun("aooi103 ")
 
 
      ON ACTION controlp
         CASE
#Mark by FUN-560183
{
            WHEN INFIELD(imz86)                       # 成本單位 (imz86)
#              CALL q_gfe(10,3,g_imz.imz86) RETURNING g_imz.imz86
#              CALL FGL_DIALOG_SETBUFFER( g_imz.imz86 )
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gfe"
               LET g_qryparam.default1 = g_imz.imz86
               CALL cl_create_qry() RETURNING g_imz.imz86
#               CALL FGL_DIALOG_SETBUFFER( g_imz.imz86 )
               DISPLAY BY NAME g_imz.imz86
               NEXT FIELD imz86
}
            WHEN INFIELD(imz34) #成本中心
#              CALL q_smh(11,4) RETURNING g_imz.imz34
#              CALL FGL_DIALOG_SETBUFFER( g_imz.imz34 )
               CALL cl_init_qry_var()
              #LET g_qryparam.form ="q_smh" #MOD-780100
               LET g_qryparam.form ="q_gem" #MOD-780100
 #              LET g_qryparam.default1 = 11,4              #No.MOD-480047 Mark
               LET g_qryparam.default1 = g_imz.imz34
               CALL cl_create_qry() RETURNING g_imz.imz34
#               CALL FGL_DIALOG_SETBUFFER( g_imz.imz34 )
               DISPLAY BY NAME g_imz.imz34
               CALL aimi113_imz34('d')    #CHI-730030
               NEXT FIELD imz34
            WHEN INFIELD(imz87)                       # 成本項目 (imz86)
#              CALL q_smg(11,32,g_imz.imz87) RETURNING g_imz.imz87
#              CALL FGL_DIALOG_SETBUFFER( g_imz.imz87 )
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_smg"
               LET g_qryparam.default1 = g_imz.imz87
               CALL cl_create_qry() RETURNING g_imz.imz87
#               CALL FGL_DIALOG_SETBUFFER( g_imz.imz87 )
               DISPLAY BY NAME g_imz.imz87
               CALL aimi113_imz87('d')
               NEXT FIELD imz87
            WHEN INFIELD(imz872)           #材料制造費用成本項目
#              CALL q_smg(11,32,g_imz.imz872) RETURNING g_imz.imz872
#              CALL FGL_DIALOG_SETBUFFER( g_imz.imz872 )
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_smg"
               LET g_qryparam.default1 = g_imz.imz872
               CALL cl_create_qry() RETURNING g_imz.imz872
#               CALL FGL_DIALOG_SETBUFFER( g_imz.imz872 )
               DISPLAY BY NAME g_imz.imz872
               CALL aimi113_imz872('d')
               NEXT FIELD imz872
            WHEN INFIELD(imz874)           #人工制造費用成本項目
#              CALL q_smg(11,32,g_imz.imz874) RETURNING g_imz.imz874
#              CALL FGL_DIALOG_SETBUFFER( g_imz.imz874 )
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_smg"
               LET g_qryparam.default1 = g_imz.imz874
               CALL cl_create_qry() RETURNING g_imz.imz874
#               CALL FGL_DIALOG_SETBUFFER( g_imz.imz874 )
               DISPLAY BY NAME g_imz.imz874
               CALL aimi113_imz874('d')
               NEXT FIELD imz874
             OTHERWISE EXIT CASE
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
 
#CHI-730030-begin-add
FUNCTION aimi113_imz34(p_cmd)    #成本中心說明
    DEFINE  p_cmd     LIKE type_file.chr1,  
            l_gem02   LIKE gem_file.gem02,  #MOD-780100
            l_gemacti LIKE gem_file.gemacti #MOD-780100
 
    LET g_chr = ' '
    IF g_imz.imz34 IS NULL
      THEN #LET g_chr = 'E' #MOD-780100
           LET g_chr=' '    #MOD-780100
           LET l_gem02 = NULL #MOD-780100
      ELSE 
          #MOD-780100............begin
          #SELECT smh02,smhacti INTO l_smh02,l_smhacti
          #  FROM smh_file WHERE smh01 = g_imz.imz34
          SELECT gem02,gemacti INTO l_gem02,l_gemacti FROM gem_file
           WHERE gem01 = g_imz.imz34
          #MOD-780100............end
 
           IF SQLCA.sqlcode
             THEN LET l_gem02 = NULL #MOD-780100
                  LET g_chr = 'E'
             ELSE IF l_gemacti matches'[Nn]' #MOD-780100
                     THEN LET g_chr = 'E'
                  END IF
           END IF
    END IF
    IF g_chr = ' ' OR p_cmd = 'd'
      THEN DISPLAY l_gem02 TO smh02 #MOD-780100
    END IF
END FUNCTION
#CHI-730030-end-add
 
FUNCTION aimi113_imz87(p_cmd)    #成本項目
    DEFINE  p_cmd     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
            l_smg02   LIKE smg_file.smg02,
            l_smgacti LIKE smg_file.smgacti
 
    LET g_chr = ' '
    IF g_imz.imz87 IS NULL
      THEN #LET g_chr = 'E' #MOD-780100
            LET g_chr = ' ' #MOD-780100
           LET l_smg02 = NULL
      ELSE SELECT smg02,smgacti INTO l_smg02,l_smgacti
             FROM smg_file WHERE smg01 = g_imz.imz87
           IF SQLCA.sqlcode
             THEN LET l_smg02 = NULL
                  LET g_chr = 'E'
             ELSE IF l_smgacti matches'[Nn]'
                     THEN LET g_chr = 'E'
                  END IF
           END IF
    END IF
    IF g_chr = ' ' OR p_cmd = 'd'
      THEN DISPLAY l_smg02 TO smg02_1
    END IF
END FUNCTION
 
FUNCTION aimi113_imz872(p_cmd)    #成本項目
    DEFINE  p_cmd     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
            l_smg02   LIKE smg_file.smg02,
            l_smgacti LIKE smg_file.smgacti
 
    LET g_chr = ' '
    IF g_imz.imz872 IS NULL
      THEN #LET g_chr = 'E' #MOD-780100
           LET g_chr = ' ' #MOD-780100
           LET l_smg02 = NULL
      ELSE SELECT smg02,smgacti INTO l_smg02,l_smgacti
             FROM smg_file WHERE smg01 = g_imz.imz872
           IF SQLCA.sqlcode
             THEN LET l_smg02 = NULL
                  LET g_chr = 'E'
             ELSE IF l_smgacti matches'[Nn]'
                     THEN LET g_chr = 'E'
                  END IF
           END IF
    END IF
    IF g_chr = ' ' OR p_cmd = 'd'
      THEN DISPLAY l_smg02 TO smg02_2
    END IF
END FUNCTION
 
FUNCTION aimi113_imz874(p_cmd)    #成本項目
    DEFINE  p_cmd     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
            l_smg02   LIKE smg_file.smg02,
            l_smgacti LIKE smg_file.smgacti
 
    LET g_chr = ' '
    IF g_imz.imz874 IS NULL
      THEN #LET g_chr = 'E' #MOD-780100
           LET g_chr = ' ' #MOD-780100
           LET l_smg02 = NULL
      ELSE SELECT smg02,smgacti INTO l_smg02,l_smgacti
             FROM smg_file WHERE smg01 = g_imz.imz874
           IF SQLCA.sqlcode
             THEN LET l_smg02 = NULL
                  LET g_chr = 'E'
             ELSE IF l_smgacti matches'[Nn]'
                     THEN LET g_chr = 'E'
                  END IF
           END IF
    END IF
    IF g_chr = ' ' OR p_cmd = 'd'
      THEN DISPLAY l_smg02 TO smg02_3
    END IF
END FUNCTION
 
FUNCTION aimi113_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_imz.* TO NULL                   #No.FUN-680046
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL aimi113_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN aimi113_count
    FETCH aimi113_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN aimi113_curs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imz.imz01,SQLCA.sqlcode,0)
        INITIALIZE g_imz.* TO NULL
    ELSE
        CALL aimi113_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION aimi113_fetch(p_flimz)
    DEFINE
        p_flimz          LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    CASE p_flimz
        WHEN 'N' FETCH NEXT     aimi113_curs INTO g_imz.imz01
        WHEN 'P' FETCH PREVIOUS aimi113_curs INTO g_imz.imz01
        WHEN 'F' FETCH FIRST    aimi113_curs INTO g_imz.imz01
        WHEN 'L' FETCH LAST     aimi113_curs INTO g_imz.imz01
        WHEN '/'
            IF (NOT g_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                      CONTINUE PROMPT
 
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
            FETCH ABSOLUTE g_jump aimi113_curs INTO g_imz.imz01
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imz.imz01,SQLCA.sqlcode,0)
        INITIALIZE g_imz.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flimz
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_imz.* FROM imz_file            # 重讀DB,因TEMP有不被更新特性
       WHERE imz01 = g_imz.imz01
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_imz.imz01,SQLCA.sqlcode,0) #No.FUN-660156
       CALL cl_err3("sel","imz_file",g_imz.imz01,"",SQLCA.sqlcode,"",
                    "",1)   #No.FUN-660156
    ELSE
        LET g_data_owner = g_imz.imzuser #FUN-4C0053
        LET g_data_group = g_imz.imzgrup #FUN-4C0053
        CALL aimi113_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION aimi113_show()
 
    LET g_imz_t.* = g_imz.*
    DISPLAY BY NAME
      g_imz.imz01, g_imz.imz02, g_imz.imz03,
      g_imz.imz25, g_imz.imz08, #g_imz.imz86, #FUN-560183
     #g_imz.imz86_fac, #FUN-560183
      g_imz.imz34,g_imz.imz87, g_imz.imz871,g_imz.imz872,
      g_imz.imz873,g_imz.imz874, g_imz.imzuser,
      g_imz.imzgrup, g_imz.imzmodu,g_imz.imzdate,
      g_imz.imzacti,g_imz.imzoriu,g_imz.imzorig   #TQC-B20025
 
      CALL aimi113_imz34('d')   #CHI-730030
      CALL aimi113_imz87('d')
      CALL aimi113_imz872('d')
      CALL aimi113_imz874('d')
      CALL cl_set_field_pic("","","","","",g_imz.imzacti)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION aimi113_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_imz.imz01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_imz.imzacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_imz.imz01,'mfg1000',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_imz01_t = g_imz.imz01
    LET g_imz_o.* = g_imz.*
    BEGIN WORK
 
    OPEN aimi113_curl USING g_imz.imz01
    IF STATUS THEN
       CALL cl_err("OPEN aimi113_curl:", STATUS, 1)
       CLOSE aimi113_curl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH aimi113_curl INTO g_imz.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imz.imz01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_imz.imzmodu = g_user                   #修改者
    LET g_imz.imzdate = g_today                  #修改日期
    CALL aimi113_show()                          # 顯示最新資料
    WHILE TRUE
        CALL aimi113_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_imz_t.imzdate=g_imz_o.imzdate        #TQC-C40219
            LET g_imz_t.imzmodu=g_imz_o.imzmodu        #TQC-C40219
            LET g_imz.*=g_imz_t.*     #TQC-C40155 #TQC-C40219
           #LET g_imz.*=g_imz_o.*     #TQC-C40155 #TQC-C40219
            CALL aimi113_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
#       LET g_imz.imz93[5,5] = 'Y'
        #FUN-560183................begin
        LET g_imz.imz86=g_imz.imz25
        LET g_imz.imz86_fac=1
        #FUN-560183................end
        UPDATE imz_file SET imz_file.* = g_imz.*    # 更新DB
            WHERE imz01 = g_imz01_t               # COLAUTH?
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_imz.imz01,SQLCA.sqlcode,0) #No.FUN-660156
           CALL cl_err3("upd","imz_file",g_imz_t.imz01,"",SQLCA.sqlcode,"",
                        "",1)   #No.FUN-660156
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE aimi113_curl
    COMMIT WORK
END FUNCTION
#No.FUN-7C0043--start--
FUNCTION aimi113_out()
   DEFINE
       l_i             LIKE type_file.num5,   #No.FUN-690026 SMALLINT
       l_name          LIKE type_file.chr20,  # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
       l_za05          LIKE za_file.za05,     #No.FUN-690026 VARCHAR(40)
       l_chr           LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
   DEFINE l_cmd  LIKE type_file.chr1000             #No.FUN-7C0043                                                                 
                                                                                                                                    
    IF cl_null(g_wc) AND NOT cl_null(g_imz.imz01)THEN                                                                               
        LET g_wc=" imz01='",g_imz.imz01,"'"                                                                                         
    END IF                                                                                                                          
    IF g_wc IS NULL THEN                                                                                                            
       CALL cl_err('','9057',0) RETURN                                                                                              
    END IF                                                                                                                          
    LET l_cmd = 'p_query "aimi113" "',g_wc CLIPPED,'"'                                                                              
    CALL cl_cmdrun(l_cmd)                                                                                                           
    RETURN 
#   IF cl_null(g_wc) THEN
#       LET g_wc=" imz01='",g_imz.imz01,"'"
#   END IF
#   CALL cl_wait()
#   CALL cl_outnam('aimi113') RETURNING l_name
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#   LET g_sql="SELECT * FROM imz_file ",          # 組合出 SQL 指令
#             " WHERE ",g_wc CLIPPED
#   PREPARE aimi113_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE aimi113_curo                         # CURSOR
#       CURSOR FOR aimi113_p1
 
#   START REPORT aimi113_rep TO l_name
 
#   FOREACH aimi113_curo INTO g_imz.*
#       IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1)
#           EXIT FOREACH
#       END IF
#       OUTPUT TO REPORT aimi113_rep(g_imz.*)
#   END FOREACH
 
#   FINISH REPORT aimi113_rep
 
#   CLOSE aimi113_curo
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT aimi113_rep(sr)
#   DEFINE
#       l_trailer_sw    LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#       sr              RECORD LIKE imz_file.*,
#       l_chr           LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
#
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.imz01
 
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1 ,g_x[1] CLIPPED    #No.TQC-6A0078
#           LET g_pageno = g_pageno + 1
#           LET pageno_total = PAGENO USING '<<<',"/pageno"
#           PRINT g_head CLIPPED,pageno_total
#           PRINT
#           PRINT g_dash[1,g_len]   #No.TQC-6A0078
#           PRINT g_x[31],g_x[32],g_x[33],g_x[36] #FUN-560183 del g_x[34],g_x[35]
#           PRINT g_dash1
#           LET l_trailer_sw = 'y'
#       ON EVERY ROW
#           IF sr.imzacti = 'N' THEN
#               PRINT COLUMN g_c[31],'*';
#           ELSE
#               PRINT COLUMN g_c[31],' ';
#           END IF
#           PRINT COLUMN g_c[32],sr.imz01,
#                 COLUMN g_c[33],sr.imz02,
#                #COLUMN g_c[34],sr.imz86, #FUN-560183
#                #COLUMN g_c[35],sr.imz86_fac USING '---&.&&&&', #FUN-560183
#                 COLUMN g_c[36],sr.imz34
#       ON LAST ROW
#           IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
#              THEN PRINT g_dash[1,g_len]   #No.TQC-6A0078
#                   CALL cl_prt_pos_wc(g_wc) #TQC-630166
#           END IF
#           PRINT g_dash[1,g_len]   #No.TQC-6A0078
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_len-9, g_x[7] CLIPPED   #No.TQC-6A0078
#           LET l_trailer_sw = 'n'
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash[1,g_len]   #No.TQC-6A0078
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_len-9, g_x[6] CLIPPED   #No.TQC-6A0078
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#No.FUN-7C0043--end-- 
