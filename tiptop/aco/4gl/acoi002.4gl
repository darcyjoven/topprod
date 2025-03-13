# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: acoi002.4gl
# Descriptions...: 商品編號開帳作業--FOR成品
# Date & Author..: 05/03/25 By day
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.TQC-660045 06/06/12 By hellen cl_err --> cl_err3
# MOdify.........: No.FUN-680069 06/08/23 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0059 23/10/16 By xumin g_no_ask 改為 mi_no_ask
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.FUN-6A0168 06/10/28 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.修改action"相關文件"
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.TQC-960157 09/06/22 By Carrier copy時問題修改
# Modify.........: No.FUN-980002 09/08/05 By TSD.SusanWu GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50062 11/05/18 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.MOD-B50162 11/07/17 by Summer 判斷g_errno應用cl_null
# Modify.........: No.FUN-910088 12/01/12 By chenjing 增加數量欄位小數取位
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:TQC-C20183 12/02/15 By chenjing 增加數量欄位小數取位
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No.CHI-C80041 12/12/20 By bart 排除作廢

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_cnx       RECORD LIKE cnx_file.*,
       g_cnx_t     RECORD LIKE cnx_file.*,  #備份舊值
 
       g_cnx01_t   LIKE cnx_file.cnx01,     #Key值備份
       g_cnx02_t   LIKE cnx_file.cnx02,     #Key值備份
       g_cnx03_t   LIKE cnx_file.cnx03,     #Key值備份
       g_cnx04_t   LIKE cnx_file.cnx04,     #Key值備份
       g_wc        STRING,              #儲存 user 的查詢條件  #No.FUN-580092 HCN        #No.FUN-680069
       g_sql       STRING                  #組 sql 用        #No.FUN-680069
DEFINE g_forupd_sql          STRING         #SELECT ... FOR UPDATE SQL        #No.FUN-680069
DEFINE g_before_input_done   LIKE type_file.num5         #判斷是否已執行 Before Input指令        #No.FUN-680069 SMALLINT
DEFINE g_chr                 LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
DEFINE g_cnt                 LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE g_i                   LIKE type_file.num5         #count/index for any purpose        #No.FUN-680069 SMALLINT
DEFINE g_msg                 LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(72)
DEFINE g_curs_index          LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE g_row_count           LIKE type_file.num10         #總筆數        #No.FUN-680069 INTEGER
DEFINE g_jump                LIKE type_file.num10         #查詢指定的筆數        #No.FUN-680069 INTEGER
DEFINE mi_no_ask              LIKE type_file.num5         #是否開啟指定筆視窗        #No.FUN-680069 SMALLINT  #No.FUN-6A0059
DEFINE g_cnx05_t             LIKE cnx_file.cnx05          #FUN-910088--add--
 
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5          #No.FUN-680069 SMALLINT
#       l_time        LIKE type_file.chr8              #No.FUN-6A0063
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT                            #擷取中斷鍵
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ACO")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690109
 
   INITIALIZE g_cnx.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM cnx_file WHERE cnx01 = ? AND cnx02 = ? AND cnx03 = ? AND cnx04 = ?  FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i002_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   LET p_row = 5 LET p_col = 10
 
   OPEN WINDOW i002_w AT p_row,p_col WITH FORM "aco/42f/acoi002"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   LET g_action_choice = ""
   CALL i002_menu()
 
   CLOSE WINDOW i002_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
FUNCTION i002_curs()
DEFINE ls   STRING
 
    CLEAR FORM
    INITIALIZE g_cnx.* TO NULL      #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取條件
        cnx01,cnx02,cnx03,cnx04,cnx05,cnxconf,
        cnx06,cnx07,cnx08,cnx09,
        cnxuser,cnxgrup,cnxmodu,cnxdate,cnxacti
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(cnx01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_cob2"
                 LET g_qryparam.default1 = g_cnx.cnx01
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO cnx01
                 NEXT FIELD cnx01
               WHEN INFIELD(cnx02)         #手冊編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_coc203"
                 LET g_qryparam.default1 = g_cnx.cnx02
                 LET g_qryparam.arg1 = g_cnx.cnx01
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO cnx02
                 NEXT FIELD cnx02
              WHEN INFIELD(cnx05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.default1 = g_cnx.cnx05
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO cnx05
                 NEXT FIELD cnx05
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
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
 
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND cnxuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND cnxgrup MATCHES '",
    #                   g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND cnxgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('cnxuser', 'cnxgrup')
    #End:FUN-980030
 
    LET g_sql="SELECT cnx01,cnx02,cnx03,cnx04 FROM cnx_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY cnx01,cnx02,cnx03,cnx04"
    PREPARE i002_prepare FROM g_sql
    DECLARE i002_cs                                # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i002_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM cnx_file WHERE ",g_wc CLIPPED
    PREPARE i002_precount FROM g_sql
    DECLARE i002_count CURSOR FOR i002_precount
END FUNCTION
 
FUNCTION i002_menu()
 
   DEFINE l_cmd  LIKE gbc_file.gbc05        #No.FUN-680069 VARCHAR(100)
    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
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
        ON ACTION confirm
            LET g_action_choice="confirm"
            IF cl_chk_act_auth() THEN
               CALL i002_y()
               CALL cl_set_field_pic(g_cnx.cnxconf,"","","","",g_cnx.cnxacti)
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
                 CALL cl_set_field_pic(g_cnx.cnxconf,"","","","",g_cnx.cnxacti)
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
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE MENU
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
           LET g_action_choice = "exit"
           EXIT MENU
# {                                             #No.FUN-6A0168
         ON ACTION related_document             #No.MOD-470515
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
              IF g_cnx.cnx01 IS NOT NULL THEN
                 LET g_doc.column1 = "cnx01"
                 LET g_doc.column2 = "cnx02"    #No.FUN-6A0168 
                 LET g_doc.column3 = "cnx04"    #No.FUN-6A0168
                 LET g_doc.value1 = g_cnx.cnx01 
                 LET g_doc.value2 = g_cnx.cnx02 #No.FUN-6A0168
                 LET g_doc.value3 = g_cnx.cnx04 #No.FUN-6A0168
                 CALL cl_doc()
              END IF
           END IF
# }                                             #NO.FUN-6A0168
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
    END MENU
    CLOSE i002_cs
END FUNCTION
 
 
FUNCTION i002_a()
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_cnx.* LIKE cnx_file.*
    LET g_cnx01_t = NULL
    LET g_cnx02_t = NULL
    LET g_cnx03_t = NULL
    LET g_cnx04_t = NULL
    LET g_cnx05_t = NULL     #FUN-910088--add--
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_cnx.cnxuser = g_user
        LET g_cnx.cnxoriu = g_user #FUN-980030
        LET g_cnx.cnxorig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_cnx.cnxgrup = g_grup               #使用者所屬群
        LET g_cnx.cnxdate = g_today
        LET g_cnx.cnxacti = 'Y'
        LET g_cnx.cnxconf = 'N'
        LET g_cnx.cnx03 = YEAR(g_today)
        LET g_cnx.cnx04 = MONTH(g_today)
        LET g_cnx.cnx05 = ' '
        LET g_cnx.cnx06 = 0
        LET g_cnx.cnx07 = 0
        LET g_cnx.cnx08 = 0
        LET g_cnx.cnx09 = 0
        LET g_cnx.cnxplant = g_plant  ##FUN-980002
        LET g_cnx.cnxlegal = g_legal  ##FUN-980002
        CALL i002_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_cnx.* TO NULL
            LET INT_FLAG = 0
            CLEAR FORM
            EXIT WHILE
        END IF
        IF (g_cnx.cnx01 IS NULL OR g_cnx.cnx02 IS NULL
           OR g_cnx.cnx03 IS NULL OR g_cnx.cnx04 IS NULL) THEN
            CONTINUE WHILE
        END IF
        INSERT INTO cnx_file VALUES(g_cnx.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
 #          CALL cl_err(g_cnx.cnx01,SQLCA.sqlcode,0) #No.TQC-660045
            CALL cl_err3("ins","cnx_file",g_cnx.cnx01,g_cnx.cnx02,SQLCA.sqlcode,"","",1) #TQC-660045
            CONTINUE WHILE
        ELSE
            SELECT cnx01,cnx02,cnx03,cnx04 INTO g_cnx.cnx01,g_cnx.cnx02,g_cnx.cnx03,g_cnx.cnx04 FROM cnx_file
                     WHERE cnx01 = g_cnx.cnx01
                       AND cnx02 = g_cnx.cnx02
                       AND cnx03 = g_cnx.cnx03
                       AND cnx04 = g_cnx.cnx04
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION i002_i(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1,          #No.FUN-680069 VARCHAR(1)
            l_flag    LIKE type_file.chr1,          #No.FUN-680069 VARCHAR(1)
            l_cob02   LIKE cob_file.cob02,
            l_cob021  LIKE cob_file.cob021,
            l_coc04   LIKE coc_file.coc04,
            l_coc05   LIKE coc_file.coc05,
            l_input   LIKE type_file.chr1,          #No.FUN-680069 VARCHAR(1)
            l_n       LIKE type_file.num5,          #No.FUN-680069 SMALLINT
            l_edate   LIKE type_file.dat,           #No.FUN-680069 DATE
            l_bdate   LIKE type_file.dat,           #No.FUN-680069 DATE
            g_n       LIKE type_file.num5,           #No.FUN-680069 SMALLINT
            l_n1      LIKE type_file.num5           #No.FUN-680069 SMALLINT
   DEFINE  l_case   STRING         #TQC-C20183--add--
 
   DISPLAY BY NAME
        g_cnx.cnx01,g_cnx.cnx02,g_cnx.cnx03,g_cnx.cnx04,g_cnx.cnx05,
        g_cnx.cnx06,g_cnx.cnx07,g_cnx.cnx08,g_cnx.cnx09,
        g_cnx.cnxconf,g_cnx.cnxuser,g_cnx.cnxgrup,
        g_cnx.cnxmodu,g_cnx.cnxdate,g_cnx.cnxacti
 
   INPUT BY NAME g_cnx.cnxoriu,g_cnx.cnxorig,
        g_cnx.cnx01,g_cnx.cnx02,g_cnx.cnx03,g_cnx.cnx04,g_cnx.cnx06,
        g_cnx.cnx07,g_cnx.cnx08,g_cnx.cnx09,g_cnx.cnxconf
      WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL i002_set_entry(p_cmd)
          CALL i002_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
 
      AFTER FIELD cnx01
         LET l_case = NULL         #TQC-C20183--add
         IF NOT cl_null(g_cnx.cnx01) THEN
            CALL i002_cnx01('a',g_cnx.cnx01)  #No.TQC-960157
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_cnx.cnx01,g_errno,1)
               LET g_cnx.cnx01 = g_cnx01_t
               DISPLAY BY NAME g_cnx.cnx01
               NEXT FIELD cnx01
            END IF
          #TQC-C20183--add--start--
            IF NOT i002_cnx06_check() THEN
               LET l_case = "cnx06"
            END IF
            IF NOT i002_cnx07_check() THEN
               LET l_case = "cnx07"
            END IF
            IF NOT i002_cnx08_check() THEN
               LET l_case = "cnx08"
            END IF
            IF NOT i002_cnx09_check() THEN
               LET l_case = "cnx09"
            END IF
            LET g_cnx05_t = g_cnx.cnx05
            CASE l_case
               WHEN "cnx06"
                  NEXT FIELD cnx06
               WHEN "cnx07"
                  NEXT FIELD cnx07
               WHEN "cnx08"
                  NEXT FIELD cnx08
               WHEN "cnx09"
                  NEXT FIELD cnx09
               OTHERWISE EXIT CASE
            END CASE
          #TQC-C20183--add--end--
         END IF
 
      AFTER FIELD cnx02
         IF NOT cl_null(g_cnx.cnx02) THEN
            SELECT count(*) INTO l_n1 FROM coc_file
             WHERE coc03 = g_cnx.cnx02
               AND coc07 IS NULL
            IF l_n1 <= 0 THEN
              CALL cl_err(g_cnx.cnx02,'aco-062',1)
              LET g_cnx.cnx02 = NULL
              NEXT FIELD cnx02
            END IF
         END IF
         IF (NOT cl_null(g_cnx.cnx01)) AND (NOT cl_null(g_cnx.cnx02)) THEN
            SELECT count(*) INTO g_n FROM coc_file,cod_file
             WHERE coc01 = cod01
               AND coc03 = g_cnx.cnx02
               AND cod03 = g_cnx.cnx01
          IF g_n <=0 THEN
            CALL cl_err(g_cnx.cnx01,'aco-221',1)
            NEXT FIELD cnx01
          END IF
         END IF
 
      AFTER FIELD cnx03
         IF NOT cl_null(g_cnx.cnx03) THEN
            IF g_cnx.cnx03<=0 THEN
               NEXT FIELD cnx03
            END IF
         END IF
 
      AFTER FIELD cnx04
         IF NOT cl_null(g_cnx.cnx04) THEN
            IF g_cnx.cnx04 > 12 OR g_cnx.cnx04 < 1 THEN
               NEXT FIELD cnx04
            END IF
            SELECT COUNT(*) INTO l_n FROM cnx_file
             WHERE cnx01 = g_cnx.cnx01
               AND cnx02 = g_cnx.cnx02
               AND cnx03 = g_cnx.cnx03
               AND cnx04 = g_cnx.cnx04
            IF l_n > 0 THEN   #資料重復
               LET g_errno='-239'
               CALL cl_err('',g_errno,1)
               NEXT FIELD cnx01
            END IF
         END IF
 
 
      AFTER FIELD cnx06
         IF NOT i002_cnx06_check() THEN NEXT FIELD cnx06 END IF    #FUN-910088--add--
       #FUN-910088--mark--start--
       # IF NOT cl_null(g_cnx.cnx06) THEN
       #    IF g_cnx.cnx06 < 0 THEN
       #       LET g_cnx.cnx06 = NULL
       #       NEXT FIELD cnx06
       #    END IF
       # END IF
       #FUN-910088--mark--end--
 
      AFTER FIELD cnx07
         IF NOT i002_cnx07_check() THEN NEXT FIELD cnx07 END IF    #FUN-910088--add--
       #FUN-910088--mark--start--
       # IF NOT cl_null(g_cnx.cnx07) THEN
       #    IF g_cnx.cnx07 < 0 THEN
       #       LET g_cnx.cnx07 = NULL
       #       NEXT FIELD cnx07
       #    END IF
       # END IF
       #FUN-910088--mark--end--
 
      AFTER FIELD cnx08
         IF NOT i002_cnx08_check() THEN NEXT FIELD cnx08 END IF    #FUN-910088--add--
       #FUN-910088--mark--start--
       # IF NOT cl_null(g_cnx.cnx08) THEN
       #    IF g_cnx.cnx08 < 0 THEN
       #       LET g_cnx.cnx08 = NULL
       #       NEXT FIELD cnx08
       #    END IF
       # END IF
       ##FUN-910088--mark--end--
 
      AFTER FIELD cnx09
         IF NOT i002_cnx09_check() THEN NEXT FIELD cnx09 END IF    #FUN-910088--add--
       #FUN-910088--mark--start--
       # IF NOT cl_null(g_cnx.cnx09) THEN
       #    IF g_cnx.cnx09 < 0 THEN
       #       LET g_cnx.cnx09 = NULL
       #       NEXT FIELD cnx09
       #    END IF
       # END IF
        #FUN-910088--mark--end--
 
      AFTER INPUT
         LET g_cnx.cnxuser = s_get_data_owner("cnx_file") #FUN-C10039
         LET g_cnx.cnxgrup = s_get_data_group("cnx_file") #FUN-C10039
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF (g_cnx.cnx01 IS NULL OR g_cnx.cnx02 IS NULL
               OR g_cnx.cnx03 IS NULL OR g_cnx.cnx04 IS NULL) THEN
               NEXT FIELD cnx01
            ELSE
               CALL s_azm(g_cnx.cnx03,g_cnx.cnx04) RETURNING l_flag,l_bdate,l_edate
               SELECT MAX(coc05) INTO l_coc05 FROM coc_file
                WHERE coc03=g_cnx.cnx02
                   IF l_edate>l_coc05 THEN
                      CALL cl_err('','aco-233',1)
                      NEXT FIELD cnx03
                   ELSE
                      CALL i002_check()
                      IF NOT cl_null(g_errno) THEN
                         CALL cl_err(g_cnx.cnx01,g_errno,1)
                         NEXT FIELD cnx01
                      END IF
                   END IF
            END IF
            IF (NOT cl_null(g_cnx.cnx01)) AND (NOT cl_null(g_cnx.cnx02)) THEN
               SELECT count(*) INTO g_n FROM coc_file,cod_file
                WHERE coc01 = cod01
                  AND coc03 = g_cnx.cnx02
                  AND cod03 = g_cnx.cnx01
                IF g_n <=0 THEN
                  LET g_cnx.cnx01 = NULL
                  CALL cl_err(g_cnx.cnx01,'aco-221',1)
                  NEXT FIELD cnx01
                END IF
            END IF
 
      #MOD-650015 --start  
      #ON ACTION CONTROLO                        # 沿用所有欄位
      #   IF INFIELD(cnx01) THEN
      #      LET g_cnx.* = g_cnx_t.*
      #      CALL i002_show()
      #      NEXT FIELD cnx01
      #   END IF
       #MOD-650015 --end 
 
     ON ACTION controlp
        CASE
           WHEN INFIELD(cnx01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_cob2"
              LET g_qryparam.default1 = g_cnx.cnx01
              CALL cl_create_qry() RETURNING g_cnx.cnx01
              CALL i002_cnx01('a',g_cnx.cnx01)  #No.TQC-960157
              DISPLAY BY NAME g_cnx.cnx01
              NEXT FIELD cnx01
            WHEN INFIELD(cnx02)         #手冊編號
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_coc203"
              LET g_qryparam.default1 = g_cnx.cnx02
              LET g_qryparam.arg1 = g_cnx.cnx01
              CALL cl_create_qry() RETURNING g_cnx.cnx02
              DISPLAY BY NAME g_cnx.cnx02
              NEXT FIELD cnx02
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
 
FUNCTION i002_cnx01(p_cmd,p_cnx01)        #No.TQC-960157
DEFINE p_cnx01     LIKE cnx_file.cnx01    #No.TQC-960157
DEFINE
   p_cmd      LIKE type_file.chr1,          #No.FUN-680069 VARCHAR(1)
   l_cob02    LIKE cob_file.cob02,
   l_cob021   LIKE cob_file.cob021,
   l_cob04    LIKE cob_file.cob04,
   l_cobacti  LIKE cob_file.cobacti
 
   LET g_errno=''
   SELECT cob02,cob021,cob04,cobacti
     INTO l_cob02,l_cob021,l_cob04,l_cobacti
     FROM cob_file
  # WHERE cob01=g_cnx.cnx01    #No.TQC-960157
    WHERE cob01=p_cnx01        #No.TQC-960157
      AND cob03 = '1'
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='aco-002'
                                LET l_cob02=NULL
                                LET l_cob021=NULL
                                LET l_cob04=NULL
       WHEN l_cobacti='N'       LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
 
   IF p_cmd='d' OR cl_null(g_errno) THEN
      DISPLAY l_cob02 TO FORMONLY.cob02
      DISPLAY l_cob021 TO FORMONLY.cob021
      LET g_cnx.cnx05=l_cob04
      DISPLAY BY NAME g_cnx.cnx05
   END IF
END FUNCTION
 
FUNCTION i002_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_cnx.* TO NULL            #No.FUN-6A0168
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i002_curs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i002_count
    FETCH i002_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i002_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cnx.cnx01,SQLCA.sqlcode,0)
        INITIALIZE g_cnx.* TO NULL
    ELSE
        CALL i002_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i002_fetch(p_flcnx)
    DEFINE
        p_flcnx     LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    CASE p_flcnx
        WHEN 'N' FETCH NEXT     i002_cs INTO g_cnx.cnx01,g_cnx.cnx02,g_cnx.cnx03,g_cnx.cnx04
        WHEN 'P' FETCH PREVIOUS i002_cs INTO g_cnx.cnx01,g_cnx.cnx02,g_cnx.cnx03,g_cnx.cnx04
        WHEN 'F' FETCH FIRST    i002_cs INTO g_cnx.cnx01,g_cnx.cnx02,g_cnx.cnx03,g_cnx.cnx04
        WHEN 'L' FETCH LAST     i002_cs INTO g_cnx.cnx01,g_cnx.cnx02,g_cnx.cnx03,g_cnx.cnx04
        WHEN '/'
            IF (NOT mi_no_ask) THEN   #No.FUN-6A0059
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
            FETCH ABSOLUTE g_jump i002_cs INTO g_cnx.cnx01,g_cnx.cnx02,g_cnx.cnx03,g_cnx.cnx04
            LET mi_no_ask = FALSE   #No.FUN-6A0059
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cnx.cnx01,SQLCA.sqlcode,0)
        INITIALIZE g_cnx.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
      CASE p_flcnx
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
    END IF
 
    SELECT * INTO g_cnx.* FROM cnx_file    # 重讀DB,因TEMP有不被更新特性
       WHERE cnx01=g_cnx.cnx01 AND cnx02= g_cnx.cnx02 AND cnx03 = g_cnx.cnx03 AND cnx04 = g_cnx.cnx04
    IF SQLCA.sqlcode THEN
 #     CALL cl_err(g_cnx.cnx01,SQLCA.sqlcode,0) #No.TQC-660045
       CALL cl_err3("sel","cnx_file",g_cnx.cnx01,g_cnx.cnx02,SQLCA.sqlcode,"","",1) #TQC-660045 
    ELSE
        LET g_data_owner=g_cnx.cnxuser           #FUN-4C0044權限控管
        LET g_data_group=g_cnx.cnxgrup
        LET g_data_plant = g_cnx.cnxplant #FUN-980030
        CALL i002_show()                   # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i002_show()
    LET g_cnx_t.* = g_cnx.*
  #FUN-910088--add--start--
    CALL i002_cnx01('d',g_cnx.cnx01)  
    LET g_cnx.cnx06 = s_digqty(g_cnx.cnx06,g_cnx.cnx05)
    LET g_cnx.cnx07 = s_digqty(g_cnx.cnx07,g_cnx.cnx05)
    LET g_cnx.cnx08 = s_digqty(g_cnx.cnx08,g_cnx.cnx05)
    LET g_cnx.cnx09 = s_digqty(g_cnx.cnx09,g_cnx.cnx05)
  #FUN-910088--add--end--
    DISPLAY BY NAME g_cnx.cnx01,g_cnx.cnx02,g_cnx.cnx03,g_cnx.cnx04, g_cnx.cnxoriu,g_cnx.cnxorig,
                    g_cnx.cnx05,g_cnx.cnx06,g_cnx.cnx07,g_cnx.cnx08,
                    g_cnx.cnx09,g_cnx.cnxconf,g_cnx.cnxuser,
                    g_cnx.cnxgrup,g_cnx.cnxmodu,g_cnx.cnxdate,
                    g_cnx.cnxacti,g_cnx.cnxconf
   #CALL i002_cnx01('d',g_cnx.cnx01)  #No.TQC-960157   #FUN-910088--mark--
    CALL cl_set_field_pic(g_cnx.cnxconf,"","","","",g_cnx.cnxacti)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i002_u()
    IF (g_cnx.cnx01 IS NULL AND g_cnx.cnx02 IS NULL
       AND g_cnx.cnx03 IS NULL AND g_cnx.cnx04 IS NULL) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    IF g_cnx.cnxacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    IF g_cnx.cnxconf='Y' THEN
       CALL cl_err(g_cnx.cnxconf,'aco-232',0)
       RETURN
    END IF
 
    SELECT * INTO g_cnx.* FROM cnx_file
     WHERE cnx01 = g_cnx.cnx01
       AND cnx02 = g_cnx.cnx02
       AND cnx03 = g_cnx.cnx03
       AND cnx04 = g_cnx.cnx04
    IF g_cnx.cnxacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_cnx01_t = g_cnx.cnx01
    LET g_cnx02_t = g_cnx.cnx02
    LET g_cnx03_t = g_cnx.cnx03
    LET g_cnx04_t = g_cnx.cnx04
    LET g_cnx05_t = g_cnx.cnx05    #FUN-910088--add--
    BEGIN WORK
 
    OPEN i002_cl USING g_cnx.cnx01,g_cnx.cnx02,g_cnx.cnx03,g_cnx.cnx04
    IF STATUS THEN
       CALL cl_err("OPEN i002_cl:", STATUS, 1)
       CLOSE i002_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i002_cl INTO g_cnx.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cnx.cnx01,SQLCA.sqlcode,1)
        RETURN
    END IF
    LET g_cnx.cnxmodu=g_user                  #修改者
    LET g_cnx.cnxdate=g_today                 #修改日期
    CALL i002_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i002_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_cnx.*=g_cnx_t.*
            CALL i002_show()
            EXIT WHILE
        END IF
        UPDATE cnx_file SET cnx_file.* = g_cnx.*    # 更新DB
            WHERE cnx01=g_cnx.cnx01 AND cnx02= g_cnx.cnx02 AND cnx03 = g_cnx.cnx03 AND cnx04 = g_cnx.cnx04
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_cnx.cnx01,SQLCA.sqlcode,0) #No.TQC-660045
           CALL cl_err3("upd","cnx_file",g_cnx01_t,g_cnx02_t,SQLCA.sqlcode,"","",1)  #TQC-660045
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i002_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i002_x()
    IF (g_cnx.cnx01 IS NULL AND g_cnx.cnx02 IS NULL
       AND g_cnx.cnx03 IS NULL AND g_cnx.cnx04 IS NULL) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    IF g_cnx.cnxconf='Y' THEN
       CALL cl_err(g_cnx.cnxconf,'aco-232',0)
       RETURN
    END IF
    BEGIN WORK
 
    OPEN i002_cl USING g_cnx.cnx01,g_cnx.cnx02,g_cnx.cnx03,g_cnx.cnx04
    IF STATUS THEN
       CALL cl_err("OPEN i002_cl:", STATUS, 1)
       CLOSE i002_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i002_cl INTO g_cnx.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_cnx.cnx01,SQLCA.sqlcode,1)
       RETURN
    END IF
    CALL i002_show()
    IF cl_exp(0,0,g_cnx.cnxacti) THEN
        LET g_chr=g_cnx.cnxacti
        IF g_cnx.cnxacti='Y' THEN
            LET g_cnx.cnxacti='N'
        ELSE
            LET g_cnx.cnxacti='Y'
        END IF
        UPDATE cnx_file
            SET cnxacti=g_cnx.cnxacti
            WHERE cnx01=g_cnx.cnx01 AND cnx02= g_cnx.cnx02 AND cnx03 = g_cnx.cnx03 AND cnx04 = g_cnx.cnx04
        IF SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err(g_cnx.cnx01,SQLCA.sqlcode,0) #No.TQC-660045
            CALL cl_err3("upd","cnx_file",g_cnx.cnx01,g_cnx.cnx02,SQLCA.sqlcode,"","",1)  #TQC-660045
            LET g_cnx.cnxacti=g_chr
        END IF
        DISPLAY BY NAME g_cnx.cnxacti
        CALL cl_set_field_pic(g_cnx.cnxconf,"","","","",g_cnx.cnxacti)
    END IF
    CLOSE i002_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i002_r()
    IF (g_cnx.cnx01 IS NULL AND g_cnx.cnx02 IS NULL
       AND g_cnx.cnx03 IS NULL AND g_cnx.cnx04 IS NULL) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_cnx.cnxacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    IF g_cnx.cnxconf='Y' THEN
       CALL cl_err(g_cnx.cnxconf,'aco-232',0)
       RETURN
    END IF
    BEGIN WORK
 
    OPEN i002_cl USING g_cnx.cnx01,g_cnx.cnx02,g_cnx.cnx03,g_cnx.cnx04
    IF STATUS THEN
       CALL cl_err("OPEN i002_cl:", STATUS, 0)
       CLOSE i002_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i002_cl INTO g_cnx.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_cnx.cnx01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i002_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL           #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "cnx01"          #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "cnx02"          #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "cnx04"          #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_cnx.cnx01       #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_cnx.cnx02       #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_cnx.cnx04       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
       DELETE FROM cnx_file
        WHERE cnx01 = g_cnx.cnx01
          AND cnx02 = g_cnx.cnx02
          AND cnx03 = g_cnx.cnx03
          AND cnx04 = g_cnx.cnx04
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
          LET mi_no_ask = TRUE    #No.FUN-6A0059
          CALL i002_fetch('/')
       END IF
    END IF
    CLOSE i002_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i002_y()
DEFINE   l_export_sum  LIKE cnx_file.cnx06           #已出口量
DEFINE   l_appl_sum    LIKE cnx_file.cnx13           #申請總量
DEFINE   l_coc10       LIKE coc_file.coc10
DEFINE   l_coc01       LIKE coc_file.coc01
DEFINE   l_coh05       LIKE coh_file.coh05
DEFINE   l_con03       LIKE con_file.con03
DEFINE   l_con05       LIKE con_file.con05
DEFINE   l_con06       LIKE con_file.con06
DEFINE   l_cost        LIKE con_file.con06           #單耗
DEFINE   l_cob04       LIKE cob_file.cob04
DEFINE   l_use1        LIKE cnx_file.cnx06
DEFINE   l_use2        LIKE cnx_file.cnx06
DEFINE   l_use3        LIKE cnx_file.cnx06
DEFINE   l_use4        LIKE cnx_file.cnx06
DEFINE   l_n           LIKE type_file.num5          #No.FUN-680069 SMALLINT
DEFINE   l_cnx01       LIKE cnx_file.cnx01
DEFINE   l_cnx02       LIKE cnx_file.cnx02
DEFINE   l_cnx03       LIKE cnx_file.cnx03
DEFINE   l_cnx04       LIKE cnx_file.cnx04
DEFINE   l_cnxconf     LIKE cnx_file.cnxconf
DEFINE   l_cnw01       LIKE cnw_file.cnw01
DEFINE   l_cnw02       LIKE cnw_file.cnw02
DEFINE   l_cnw03       LIKE cnw_file.cnw03
DEFINE   l_cnw04       LIKE cnw_file.cnw04
DEFINE   l_cnw06       LIKE cnw_file.cnw06
DEFINE   l_cnw07       LIKE cnw_file.cnw07
DEFINE   l_cnw09       LIKE cnw_file.cnw09
DEFINE   l_cnw08       LIKE cnw_file.cnw08
DEFINE   l_cnw10       LIKE cnw_file.cnw10
DEFINE   l_cnw12       LIKE cnw_file.cnw12
DEFINE   l_cnw14       LIKE cnw_file.cnw14
DEFINE   l_cnwconf     LIKE cnw_file.cnwconf
DEFINE   l_cnw05       LIKE cnw_file.cnw05      #FUN-910088--add--
 
    IF (g_cnx.cnx01 IS NULL AND g_cnx.cnx02 IS NULL
       AND g_cnx.cnx03 IS NULL AND g_cnx.cnx04 IS NULL) THEN
       RETURN
    END IF
    SELECT * INTO g_cnx.* FROM cnx_file
     WHERE cnx01 = g_cnx.cnx01
       AND cnx02 = g_cnx.cnx02
       AND cnx03 = g_cnx.cnx03
       AND cnx04 = g_cnx.cnx04
    IF g_cnx.cnxacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    IF g_cnx.cnxconf='Y' THEN CALL cl_err(g_cnx.cnxconf,'aco-232',0) RETURN END IF
#再選一次資料，看相應的商品編號與手冊編號有無日期更近的成品資料，若有，則提示返回
    DECLARE i002_date_cl CURSOR FOR
     SELECT cnx01,cnx02,cnx03,cnx04,cnxconf FROM cnx_file
      WHERE cnx01 = g_cnx.cnx01
        AND cnx02 = g_cnx.cnx02
    FOREACH i002_date_cl INTO l_cnx01,l_cnx02,l_cnx03,l_cnx04,l_cnxconf
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         IF (l_cnx03>g_cnx.cnx03)
            OR (l_cnx03=g_cnx.cnx03 AND l_cnx04>g_cnx.cnx04) THEN
            IF l_cnxconf<>'N' THEN
               CALL cl_err('','aco-224',1)
               RETURN
            END IF
         END IF
    END FOREACH
    IF NOT cl_confirm('axm-108') THEN RETURN END IF
    LET l_cost=0
    BEGIN WORK
    OPEN i002_cl USING g_cnx.cnx01,g_cnx.cnx02,g_cnx.cnx03,g_cnx.cnx04
    IF STATUS THEN
       CALL cl_err("OPEN i002_cl:", STATUS, 1)
       CLOSE i002_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i002_cl INTO g_cnx.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cnx.cnx01,SQLCA.sqlcode,0)          #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    CALL i002_check()
    IF NOT cl_null(g_errno) THEN
       CALL cl_err('cnx01:',g_errno,1)
       ROLLBACK WORK
       RETURN
    END IF
    SELECT coc10 INTO l_coc10  FROM coc_file WHERE coc03=g_cnx.cnx02  #海關代號
    DECLARE i002_sel_cl CURSOR FOR   #找到此成品對應的所有材料資料
     SELECT con03,con05,con06
       FROM con_file,coe_file,coc_file,cod_file
      WHERE con01=g_cnx.cnx01
        AND con013= ' '   #con013=' ',此BOM為此成品的標准BOM,如果找不到此BOM,提示錯誤
        AND con08=l_coc10
        AND coc01=coe01 AND coc03=g_cnx.cnx02
        AND coc01=cod01 AND cod03=g_cnx.cnx01
        AND con01=cod03 AND coe03=con03
    FOREACH i002_sel_cl INTO l_con03,l_con05,l_con06
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         IF cl_null(l_con03) THEN
            CALL cl_err('','aco-223',1)
            LET g_errno='aco-223'
            EXIT FOREACH
         ELSE
#看相應的商品編號與手冊編號有無日期更近的材料資料
            DECLARE i002_date1_cl CURSOR FOR
             SELECT cnw01,cnw02,cnw03,cnw04,cnwconf FROM cnw_file
              WHERE cnw01 = l_con03
                AND cnw02 = g_cnx.cnx02
            FOREACH i002_date1_cl INTO l_cnw01,l_cnw02,l_cnw03,l_cnw04,l_cnwconf
                 IF SQLCA.sqlcode THEN
                    CALL cl_err('foreach:',SQLCA.sqlcode,1)
                    EXIT FOREACH
                 END IF
                 IF (l_cnw03>g_cnx.cnx03)
                    OR (l_cnw03=g_cnx.cnx03 AND l_cnw04>g_cnx.cnx04) THEN
                    IF l_cnwconf<>'N' THEN
                       CALL cl_err('','aco-225',1)
                       RETURN
                       ROLLBACK WORK
                    END IF
                 END IF
            END FOREACH
        #FUN-910088--add--start--
            SELECT cnw05 INTO l_cnw05 FROM cnw_file
             WHERE cnw01=l_con03
               AND cnw02=g_cnx.cnx02
               AND cnw03=g_cnx.cnx03
               AND cnw04=g_cnx.cnx04
        #FUN-910088--add--end--
            LET g_errno= NULL
            LET l_cost = l_con05 /(1-l_con06/100) # 確定每筆材料的單耗
            LET l_use1 = g_cnx.cnx06*l_cost    # 直接耗用
            LET l_use2 = g_cnx.cnx07*l_cost    # 轉廠耗用
            LET l_use3 = g_cnx.cnx08*l_cost    # 內銷耗用
            LET l_use4 = g_cnx.cnx09*l_cost    # 加簽耗用
            LET l_cnw01=''
            LET l_cnw02=''
            LET l_cnw03=0
            LET l_cnw04=0
            LET l_cnwconf='N'
            DECLARE i002_cnw_cl CURSOR FOR
                   SELECT cnw01,cnw02,cnw03,cnw04,cnw06,cnw07,cnw08,
                          cnw09,cnw10,cnw12,cnw14,cnwconf
                     FROM cnw_file
                    WHERE cnw01=l_con03
                      AND cnw02=g_cnx.cnx02
                      AND cnw03=g_cnx.cnx03
                      AND cnw04=g_cnx.cnx04
            FOREACH i002_cnw_cl INTO l_cnw01,l_cnw02,l_cnw03,l_cnw04,l_cnw06,l_cnw07,l_cnw08,l_cnw09,
                                     l_cnw10,l_cnw12,l_cnw14,l_cnwconf
                IF SQLCA.sqlcode THEN
                   CALL cl_err('foreach cnw_cl:',SQLCA.sqlcode,1)
                   EXIT FOREACH
                END IF
            END FOREACH
            IF l_cnwconf='Y' THEN    #如果材料已經確認了,則不能更新,退出
               CALL cl_err(l_cnwconf,'aco-227',0)
               ROLLBACK WORK
               RETURN
            ELSE
               #判斷是否有對應材料的資料,如果沒有的話,insert into cnw_file..
               #                         如果已有材料的record,update cnw_file
               SELECT COUNT(*) INTO l_n FROM cnw_file
                WHERE cnw01=l_con03
                  AND cnw02=g_cnx.cnx02
                  AND cnw03=g_cnx.cnx03
                  AND cnw04=g_cnx.cnx04
               IF l_n = 0 THEN
                  SELECT cob04 INTO l_cob04 FROM cob_file WHERE cob01=l_con03
                #FUN-910088--add--start--
                  LET l_use1 = s_digqty(l_use1,l_cob04)
                  LET l_use2 = s_digqty(l_use2,l_cob04)    
                  LET l_use3 = s_digqty(l_use3,l_cob04)   
                  LET l_use4 = s_digqty(l_use4,l_cob04) 
                #FUN-910088--add--end--
                  INSERT INTO cnw_file(cnw01,cnw02,cnw03,cnw04,cnw05,cnw06,cnw07,cnw08,
                                       cnw09,cnw10,cnw11,cnw12,cnw13,cnw14,
                                       #cnwconf,cnwacti,cnwuser,cnwgrup,cnwmodu,cnwdate,cnworiu,cnworig) #FUN-980002
                                       cnwconf,cnwacti,cnwuser,cnwgrup,cnwmodu,cnwdate,  #FUN-980002
                                       cnwplant,cnwlegal)  #FUN-980002
                         VALUES(l_con03,g_cnx.cnx02,g_cnx.cnx03,g_cnx.cnx04,l_cob04,0,
                                0,l_use1,0,l_use2,0,l_use3,0,l_use4,
                                #'N','Y',g_user,g_grup,NULL,g_today, g_user, g_grup) #FUN-980002      #No.FUN-980030 10/01/04  insert columns oriu, orig
                                'N','Y',g_user,g_grup,NULL,g_today,  #FUN-980002
                                g_plant,g_legal)  #FUN-980002
                  IF SQLCA.sqlcode THEN
#                    CALL cl_err('insert into cnw_file',g_errno,0) #No.TQC-660045
                     CALL cl_err3("ins","cnw_file",l_con03,g_cnx.cnx02,SQLCA.sqlcode,"","insert into cnw_file",1)  #TQC-660045
                     ROLLBACK WORK
                     RETURN
                  END IF
               ELSE
                #FUN-910088--add--start--
                  SELECT cnw05 INTO l_cnw05 FROM cnw_file
                   WHERE cnw01=l_con03
                     AND cnw02=g_cnx.cnx02
                     AND cnw03=g_cnx.cnx03
                     AND cnw04=g_cnx.cnx04
                  LET l_use1 = s_digqty(l_use1,l_cnw05)
                  LET l_use2 = s_digqty(l_use2,l_cnw05)    
                  LET l_use3 = s_digqty(l_use3,l_cnw05)   
                  LET l_use4 = s_digqty(l_use4,l_cnw05) 
                #FUN-910088--add--end--
                  UPDATE cnw_file SET cnw08=l_cnw08+l_use1,
                                      cnw10=l_cnw10+l_use2,
                                      cnw12=l_cnw12+l_use3,
                                      cnw14=l_cnw14+l_use4
                                WHERE cnw01=l_con03
                                  AND cnw02=g_cnx.cnx02
                                  AND cnw03=g_cnx.cnx03
                                  AND cnw04=g_cnx.cnx04
                  IF SQLCA.sqlcode THEN
#                    CALL cl_err('update cnw_file',g_errno,0) #No.TQC-660045
                     CALL cl_err3("upd","cnw_file",l_con03,g_cnx.cnx02,SQLCA.sqlcode,"","update cnw_file",1)  #TQC-660045
                     ROLLBACK WORK
                  END IF
               END IF
             END IF
 
             # 若以上均符合則更新cod_file欄位
             # 直接出口數量cod09  = cnw06
             # 轉廠出口數量cod101 = cnw07
             #     內銷數量cod106 = cnw08
             #     加簽數量cod10  = cnw09 + l_coh05
             # 條件 WHERE cod01=l_coc01 AND cod03=g_cnx.cnx01
               SELECT SUM(coh05) INTO l_coh05 FROM cog_file,coh_file
                WHERE cog01=coh01
                  AND cog03=g_cnx.cnx02
                  AND coh03=g_cnx.cnx01
                  AND cogcong <> 'X'  #CHI-C80041
                   IF l_coh05 IS NULL THEN
                      LET l_coh05=0
                   END IF
               SELECT coc01 INTO l_coc01 FROM coc_file WHERE coc03=g_cnx.cnx02
               IF NOT STATUS THEN
                  UPDATE cod_file SET cod09  = g_cnx.cnx06,
                                      cod101 = g_cnx.cnx07,
                                      cod106 = g_cnx.cnx08,
                                      cod10  = g_cnx.cnx09+l_coh05
                                WHERE cod01=l_coc01
                                  AND cod03=g_cnx.cnx01
               END IF
         END IF
 
    END FOREACH
 
   #IF (NOT STATUS) AND (g_errno IS NULL) THEN     #MOD-B50162 mark
    IF (NOT STATUS) AND cl_null(g_errno) THEN      #MOD-B50162 add
       LET g_success = 'Y'
       UPDATE cnx_file SET cnxconf='Y'
        WHERE cnx01 = g_cnx.cnx01
          AND cnx02 = g_cnx.cnx02
          AND cnx03 = g_cnx.cnx03
          AND cnx04 = g_cnx.cnx04
       COMMIT WORK
    ELSE
       CALL cl_err('','aco-222',1)
       ROLLBACK WORK
       RETURN
    END IF
 
 
    SELECT cnxconf INTO g_cnx.cnxconf FROM cnx_file
    WHERE cnx01 = g_cnx.cnx01
      AND cnx02 = g_cnx.cnx02
      AND cnx03 = g_cnx.cnx03
      AND cnx04 = g_cnx.cnx04
    DISPLAY BY NAME g_cnx.cnxconf
    CALL cl_set_field_pic(g_cnx.cnxconf,"","","","",g_cnx.cnxacti)
END FUNCTION
 
FUNCTION i002_check()
DEFINE   p_cmd             LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
DEFINE   l_export_sum      LIKE cnx_file.cnx06           #出品總量
DEFINE   l_extra_appl_qty  LIKE cnx_file.cnx09           #加簽總量
DEFINE   l_appl_qty        LIKE cod_file.cod05           #申請總量
 
   LET g_errno=''
   LET l_export_sum=0
   LET l_extra_appl_qty=0
   LET l_appl_qty=0
    #檢查數量的有效性
    #出品總量=cnx06+cnx07+cnx08
     LET l_export_sum = g_cnx.cnx06+g_cnx.cnx07+g_cnx.cnx08
 
    #加簽總量=cnx09
     LET l_extra_appl_qty=g_cnx.cnx09
 
    #申請總量=cod05+cod10
      DECLARE i002_cod_cl CURSOR FOR
       SELECT (cod05+cod10) FROM coc_file,cod_file
        WHERE coc01=cod01
          AND coc03=g_cnx.cnx02
          AND cod03=g_cnx.cnx01
      FOREACH i002_cod_cl INTO l_appl_qty
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
      END FOREACH
 
    #出口總量>加簽總量+申請數量 error
     IF l_export_sum > (l_extra_appl_qty+l_appl_qty) THEN
        LET g_errno='aco-218'
     ELSE
        LET g_errno=' '
     END IF
END FUNCTION
 
FUNCTION i002_copy()
    DEFINE l_cnt         LIKE type_file.num10         #No.FUN-680069 INTEGER
    DEFINE
        l_newno1         LIKE cnx_file.cnx01,
        l_newno2         LIKE cnx_file.cnx02,
        l_newno3         LIKE cnx_file.cnx03,
        l_newno4         LIKE cnx_file.cnx04,
        l_oldno1         LIKE cnx_file.cnx01,
        l_oldno2         LIKE cnx_file.cnx02,
        l_oldno3         LIKE cnx_file.cnx03,
        l_oldno4         LIKE cnx_file.cnx04,
        l_oldno5         LIKE cnx_file.cnx05,    #No.TQC-960157	
        l_coc04          LIKE coc_file.coc04,
        l_cob02          LIKE cob_file.cob02,
        l_cob04          LIKE cob_file.cob04,
        l_cob021         LIKE cob_file.cob021,
        l_coc05          LIKE coc_file.coc05,
        p_cmd            LIKE type_file.chr1,          #No.FUN-680069 VARCHAR(1)
        l_flag           LIKE type_file.chr1,          #No.FUN-680069 VARCHAR(1)
        l_bdate          LIKE type_file.dat,           #No.FUN-680069 DATE
        l_edate          LIKE type_file.dat,           #No.FUN-680069 DATE
        g_n              LIKE type_file.num5,          #No.FUN-680069 SMALLINT
        l_input          LIKE type_file.chr1           #No.FUN-680069 VARCHAR(1)
   DEFINE l_case    STRING     #FUN-910088--add--
 
    IF (g_cnx.cnx01 IS NULL AND g_cnx.cnx02 IS NULL
       AND g_cnx.cnx03 IS NULL AND g_cnx.cnx04 IS NULL) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    IF g_cnx.cnxacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
 
    LET g_before_input_done = FALSE
    CALL i002_set_entry('a')
    LET g_before_input_done = TRUE
    LET l_oldno5 = g_cnx.cnx05   #No.TQC-960157
 
    INPUT l_newno1,l_newno2,l_newno3,l_newno4
     FROM cnx01,cnx02,cnx03,cnx04
 
        AFTER FIELD cnx01
              SELECT cob02,cob021
                FROM cob_file
              WHERE cob01= l_newno1
              IF SQLCA.sqlcode THEN
                  DISPLAY BY NAME g_cnx.cnx01
                  LET l_newno1 = NULL
                  NEXT FIELD cnx01
              END IF
              #No.TQC-960157  --Begin
              CALL i002_cnx01('d',l_newno1)  
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(l_newno1,g_errno,1)
                 DISPLAY BY NAME g_cnx.cnx01
                 LET l_newno1 = NULL
                 NEXT FIELD cnx01
              END IF
              #No.TQC-960157  --End  
 
        #No.TQC-960157  --Begin
        AFTER FIELD cnx02
           IF NOT cl_null(l_newno2) THEN
              SELECT count(*) INTO g_n FROM coc_file
               WHERE coc03 = l_newno2
                 AND coc07 IS NULL
              IF g_n <= 0 THEN
                CALL cl_err(l_newno2,'aco-062',1)
                LET l_newno2 = NULL
                NEXT FIELD cnx02
              END IF
           END IF
        #No.TQC-960157  --End  
 
        AFTER FIELD cnx04
              SELECT COUNT(*) INTO l_cnt FROM cnx_file
                  WHERE cnx01 = l_newno1
                    AND cnx02 = l_newno2
                    AND cnx03 = l_newno3
                    AND cnx04 = l_newno4
              IF l_cnt > 0 THEN
                  CALL cl_err(l_newno1,-239,0)
                  NEXT FIELD cnx01
              END IF
              SELECT COUNT(*) INTO g_n FROM coc_file,cod_file
               WHERE coc01 = cod01
                 AND coc03 = l_newno2
                 AND cod03 = l_newno1
                 AND coc07 IS NULL
               IF g_n <=0 THEN
                 LET l_newno1 = NULL
                 LET l_newno2 = NULL
                 CALL cl_err(l_newno1,'aco-221',1)
                 NEXT FIELD cnx01
               END IF
            IF (NOT cl_null(l_newno1) AND NOT cl_null(l_newno2)
               AND NOT cl_null(l_newno3) AND NOT cl_null(l_newno4)) THEN
               CALL s_azm(l_newno3,l_newno4) RETURNING l_flag,l_bdate,l_edate
               SELECT MAX(coc05) INTO l_coc05 FROM coc_file
                WHERE coc03=l_newno2
                   IF l_edate>l_coc05 THEN
                      CALL cl_err('','aco-233',1)
                      NEXT FIELD cnx03
                   END IF
            END IF
 
        ON ACTION controlp                        # 沿用所有欄位
           CASE
             WHEN INFIELD(cnx01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_cob2"
                LET g_qryparam.default1 = g_cnx.cnx01
                CALL cl_create_qry() RETURNING l_newno1
                #No.TQC-960157  --Begin
                #DISPLAY BY NAME l_newno1
                DISPLAY l_newno1 TO cnx01
                CALL i002_cnx01('a',l_newno1)  #No.TQC-960157
                #IF SQLCA.sqlcode THEN
                #   DISPLAY BY NAME g_cnx.cnx01
                #   LET l_newno1 = NULL
                #   NEXT FIELD cnx01
                #END IF
                #No.TQC-960157  --End  
                NEXT FIELD cnx01
              WHEN INFIELD(cnx02)         #手冊編號
                CALL cl_init_qry_var()
                #No.TQC-960157  --Begin
                #LET g_qryparam.form = "q_coc023"
                LET g_qryparam.form = "q_coc203" #No.TQC-960157  --End  
                LET g_qryparam.default1 = g_cnx.cnx02
                LET g_qryparam.arg1 = l_newno1
                CALL cl_create_qry() RETURNING l_newno2
                #No.TQC-960157  --Begin
                #DISPLAY BY NAME l_newno2
                DISPLAY l_newno2 TO cnx02
                #No.TQC-960157  --End  
                NEXT FIELD cnx02
            END CASE
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
    END INPUT
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_cnx.cnx01,g_cnx.cnx02,g_cnx.cnx03,g_cnx.cnx04
        #No.TQC-960157  --Begin
        LET g_cnx.cnx05 = l_oldno5
        DISPLAY BY NAME g_cnx.cnx05
        #No.TQC-960157  --End  
        RETURN
    END IF
    DROP TABLE y
    SELECT * FROM cnx_file
        WHERE cnx01=g_cnx.cnx01 AND cnx02= g_cnx.cnx02 AND cnx03 = g_cnx.cnx03 AND cnx04 = g_cnx.cnx04
        INTO TEMP y
    UPDATE y
        SET cnx01=l_newno1,    #資料鍵值
            cnx02=l_newno2,
            cnx03=l_newno3,
            cnx04=l_newno4,
            cnx05=g_cnx.cnx05, #No.TQC-960157
            cnxacti='Y',      #資料有效碼
            cnxconf='N',
            cnxuser=g_user,   #資料所有者
            cnxgrup=g_grup,   #資料所有者所屬群
            cnxmodu=NULL,     #資料修改日期
            cnxdate=g_today   #資料建立日期
    INSERT INTO cnx_file
        SELECT * FROM y
    IF SQLCA.sqlcode THEN
 #     CALL cl_err(g_cnx.cnx01,SQLCA.sqlcode,0) #No.TQC-660045
       CALL cl_err3("ins","cnx_file",g_cnx.cnx01,g_cnx.cnx02,SQLCA.sqlcode,"","",1) #TQC-660045 
    ELSE
        MESSAGE 'ROW(',l_newno1,') O.K'
        LET l_oldno1 = g_cnx.cnx01
        LET l_oldno2 = g_cnx.cnx02
        LET l_oldno3 = g_cnx.cnx03
        LET l_oldno4 = g_cnx.cnx04
        LET g_cnx.cnx01 = l_newno1
        LET g_cnx.cnx02 = l_newno2
        LET g_cnx.cnx03 = l_newno3
        LET g_cnx.cnx04 = l_newno4
        SELECT cnx_file.* INTO g_cnx.* FROM cnx_file
               WHERE cnx01=l_newno1
                 AND cnx02=l_newno2
                 AND cnx03=l_newno3
                 AND cnx04=l_newno4
        CALL i002_u()
        #FUN-C30027---begin
        #SELECT cnx_file.* INTO g_cnx.* FROM cnx_file
        #       WHERE cnx01=l_oldno1
        #         AND cnx02=l_oldno2
        #         AND cnx03=l_oldno3
        #         AND cnx04=l_oldno4
        #FUN-C30027---end
    END IF
    #FUN-C30027---begin
    #LET g_cnx.cnx01 = l_oldno1
    #LET g_cnx.cnx02=l_oldno2
    #LET g_cnx.cnx03=l_oldno3
    #LET g_cnx.cnx04=l_oldno4
    #FUN-C30027---end
    CALL i002_show()
END FUNCTION
 
FUNCTION i002_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("cnx01,cnx02,cnx03,cnx04",TRUE)
     END IF
 
END FUNCTION
 
FUNCTION i002_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' THEN
       CALL cl_set_comp_entry("cnx01,cnx02,cnx03,cnx04",FALSE)
    END IF
 
END FUNCTION

#FUN-910088--add--start--
FUNCTION i002_cnx06_check()
   IF NOT cl_null(g_cnx.cnx06) AND NOT cl_null(g_cnx.cnx05) THEN
      IF cl_null(g_cnx05_t) OR cl_null(g_cnx_t.cnx06) OR g_cnx05_t != g_cnx.cnx05 OR g_cnx_t.cnx06 != g_cnx.cnx06 THEN
         LET g_cnx.cnx06 = s_digqty(g_cnx.cnx06,g_cnx.cnx05)
         DISPLAY BY NAME g_cnx.cnx06
      END IF
   END IF
   IF NOT cl_null(g_cnx.cnx06) THEN
      IF g_cnx.cnx06 < 0 THEN
         LET g_cnx.cnx06 = NULL
         RETURN FALSE    
      END IF
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION i002_cnx07_check()
   IF NOT cl_null(g_cnx.cnx07) AND NOT cl_null(g_cnx.cnx05) THEN
      IF cl_null(g_cnx05_t) OR cl_null(g_cnx_t.cnx07) OR g_cnx05_t != g_cnx.cnx05 OR g_cnx_t.cnx07 != g_cnx.cnx07 THEN
         LET g_cnx.cnx07 = s_digqty(g_cnx.cnx07,g_cnx.cnx05)
         DISPLAY BY NAME g_cnx.cnx07
      END IF
   END IF
   IF NOT cl_null(g_cnx.cnx07) THEN
      IF g_cnx.cnx07 < 0 THEN
         LET g_cnx.cnx07 = NULL
         RETURN FALSE    
      END IF
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION i002_cnx08_check()
   IF NOT cl_null(g_cnx.cnx08) AND NOT cl_null(g_cnx.cnx05) THEN
      IF cl_null(g_cnx05_t) OR cl_null(g_cnx_t.cnx08) OR g_cnx05_t != g_cnx.cnx05 OR g_cnx_t.cnx08 != g_cnx.cnx08 THEN
         LET g_cnx.cnx08 = s_digqty(g_cnx.cnx08,g_cnx.cnx05)
         DISPLAY BY NAME g_cnx.cnx08
      END IF
   END IF
   IF NOT cl_null(g_cnx.cnx08) THEN
      IF g_cnx.cnx08 < 0 THEN
         LET g_cnx.cnx08 = NULL
         RETURN FALSE    
      END IF
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION i002_cnx09_check()
   IF NOT cl_null(g_cnx.cnx09) AND NOT cl_null(g_cnx.cnx05) THEN
      IF cl_null(g_cnx05_t) OR cl_null(g_cnx_t.cnx09) OR g_cnx05_t != g_cnx.cnx05 OR g_cnx_t.cnx09 != g_cnx.cnx09 THEN
         LET g_cnx.cnx09 = s_digqty(g_cnx.cnx09,g_cnx.cnx05)
         DISPLAY BY NAME g_cnx.cnx09
      END IF
   END IF
   IF NOT cl_null(g_cnx.cnx09) THEN
      IF g_cnx.cnx09 < 0 THEN
         LET g_cnx.cnx09 = NULL
         RETURN FALSE    
      END IF
   END IF
   RETURN TRUE
END FUNCTION
#FUN-910088--add--end--

