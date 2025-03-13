# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: acoi003.4gl
# Descriptions...: 商品編號開帳作業--FOR 材料
# Date & Author..: 05/03/24 By wujie
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
# Modify.........: No.FUN-980002 09/08/05 By TSD.SusanWu GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50062 11/05/18 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-910088 12/01/15 By chenjing 增加數量欄位小數取位

 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:TQC-C20183 12/02/15 By chenjing 增加數量欄位小數取位
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No.CHI-C80041 12/12/20 By bart 排除作廢

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_cnw       RECORD LIKE cnw_file.*,
       g_cnw_t     RECORD LIKE cnw_file.*,  #備份舊值
       g_cnw01_t   LIKE cnw_file.cnw01,     #Key值備份
       g_cnw02_t   LIKE cnw_file.cnw02,     #Key值備份
       g_cnw03_t   LIKE cnw_file.cnw03,     #Key值備份
       g_cnw04_t   LIKE cnw_file.cnw04,     #Key值備份
       g_wc        STRING,              #儲存 user 的查詢條件  #No.FUN-580092 HCN        #No.FUN-680069
       g_sql       STRING,                  #組 sql 用        #No.FUN-680069
       l_cob04     LIKE cob_file.cob04
 
DEFINE g_forupd_sql          STRING         #SELECT ... FOR UPDATE SQL        #No.FUN-680069
DEFINE g_before_input_done   LIKE type_file.num5         #判斷是否已執行 Before Input指令        #No.FUN-680069 SMALLINT
DEFINE g_chr                 LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
DEFINE g_cnt                 LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE g_i                   LIKE type_file.num5         #count/index for any purpose        #No.FUN-680069 SMALLINT
DEFINE g_msg                 LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(72)
DEFINE g_curs_index          LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE g_row_count           LIKE type_file.num10         #總筆數        #No.FUN-680069 INTEGER
DEFINE g_jump                LIKE type_file.num10         #查詢指定的筆數        #No.FUN-680069 INTEGER
DEFINE mi_no_ask              LIKE type_file.num5         #是否開啟指定筆視窗        #No.FUN-680069 SMALLINT   #No.FUN-6A0059
DEFINE g_cnw05_t             LIKE cnw_file.cnw05          #FUN-910088--add--
 
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5         #No.FUN-680069 SMALLINT
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
 
   INITIALIZE g_cnw.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM cnw_file WHERE cnw01 = ? AND cnw02 = ? AND cnw03 = ? AND cnw04 = ?  FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i003_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   LET p_row = 5 LET p_col = 10
 
   OPEN WINDOW i003_w AT p_row,p_col WITH FORM "aco/42f/acoi003"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   LET g_action_choice = ""
   CALL i003_menu()
 
   CLOSE WINDOW i003_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
FUNCTION i003_curs()
DEFINE ls  STRING  
 
    CLEAR FORM
    INITIALIZE g_cnw.* TO NULL      #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取條件
        cnw01,cnw02,cnw03,cnw04,cnw05,cnwconf,cnw06,cnw07,cnw08,cnw09,
        cnw10,cnw11,cnw12,cnw13,cnw14,cnwuser,
        cnwgrup,cnwmodu,cnwdate,cnwacti
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(cnw01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_cob3"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_cnw.cnw01
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO cnw01
                 NEXT FIELD cnw01
               WHEN INFIELD(cnw02)         #手冊編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_coc204"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_cnw.cnw02
                 LET g_qryparam.arg1 = g_cnw.cnw01
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO cnw02
                 NEXT FIELD cnw02
              WHEN INFIELD(cnw05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_cnw.cnw05
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO cnw05
                 NEXT FIELD cnw05
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
    #        LET g_wc = g_wc clipped," AND cnwuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND cnwgrup MATCHES '",
    #                   g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND cnwgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('cnwuser', 'cnwgrup')
    #End:FUN-980030
 
    LET g_sql="SELECT cnw01,cnw02,cnw03,cnw04 FROM cnw_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY cnw01"
    PREPARE i003_prepare FROM g_sql
    DECLARE i003_cs                                # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i003_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM cnw_file WHERE ",g_wc CLIPPED
    PREPARE i003_precount FROM g_sql
    DECLARE i003_count CURSOR FOR i003_precount
END FUNCTION
 
FUNCTION i003_menu()
 
   DEFINE l_cmd  LIKE gbc_file.gbc05        #No.FUN-680069 VARCHAR(100)
    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i003_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i003_q()
            END IF
        ON ACTION confirm
            LET g_action_choice="confirm"
            IF cl_chk_act_auth() THEN
               CALL i003_y()
               CALL cl_set_field_pic(g_cnw.cnwconf,"","","","",g_cnw.cnwacti)
            END IF
        ON ACTION next
            CALL i003_fetch('N')
        ON ACTION previous
            CALL i003_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i003_u()
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL i003_x()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i003_r()
            END IF
       ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                 CALL i003_copy()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL i003_fetch('/')
        ON ACTION first
            CALL i003_fetch('F')
        ON ACTION last
            CALL i003_fetch('L')
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
             LET INT_FLAG=FALSE 		    #MOD-570244	mars
           LET g_action_choice = "exit"
           EXIT MENU
 
         ON ACTION related_document                 #No.MOD-470515
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
              IF g_cnw.cnw01 IS NOT NULL THEN
                 LET g_doc.column1 = "cnw01"
                 LET g_doc.column2 = "cnw02"        #No.FUN-6A0168
                 LET g_doc.column3 = "cnw03"        #No.FUN-6A0168
                 LET g_doc.column4 = "cnw04"        #No.FUN-6A0168
                 LET g_doc.value1 = g_cnw.cnw01     
                 LET g_doc.value2 = g_cnw.cnw02     #No.FUN-6A0168
                 LET g_doc.value3 = g_cnw.cnw03     #No.FUN-6A0168
                 LET g_doc.value4 = g_cnw.cnw04     #No.FUN-6A0168
                 CALL cl_doc()
              END IF
           END IF
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
    END MENU
    CLOSE i003_cs
END FUNCTION
 
 
FUNCTION i003_a()
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_cnw.* LIKE cnw_file.*
    LET g_cnw01_t = NULL
    LET g_cnw02_t = NULL
    LET g_cnw03_t = NULL
    LET g_cnw04_t = NULL
    LET g_cnw05_t = NULL       #FUN-910088--add--
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_cnw.cnwuser = g_user
        LET g_cnw.cnworiu = g_user #FUN-980030
        LET g_cnw.cnworig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_cnw.cnwgrup = g_grup               #使用者所屬群
        LET g_cnw.cnwdate = g_today
        LET g_cnw.cnwacti = 'Y'
        LET g_cnw.cnwconf = 'N'
        LET g_cnw.cnw03 = YEAR(g_today)
        LET g_cnw.cnw04 = MONTH(g_today)
        LET g_cnw.cnw05 = ' '
        LET g_cnw.cnw06 = 0
        LET g_cnw.cnw07 = 0
        LET g_cnw.cnw08 = 0
        LET g_cnw.cnw09 = 0
        LET g_cnw.cnw10 = 0
        LET g_cnw.cnw11 = 0
        LET g_cnw.cnw12 = 0
        LET g_cnw.cnw13 = 0
        LET g_cnw.cnw14 = 0
        LET g_cnw.cnwplant = g_plant   #FUN-980002
        LET g_cnw.cnwlegal = g_legal   #FUN-980002
        
        CALL i003_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_cnw.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9002,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF (g_cnw.cnw01 IS NULL OR g_cnw.cnw02 IS NULL
           OR g_cnw.cnw03 IS NULL OR g_cnw.cnw04 IS NULL) THEN
            CONTINUE WHILE
        END IF
        INSERT INTO cnw_file VALUES(g_cnw.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_cnw.cnw01,SQLCA.sqlcode,0) #No.TQC-660045
            CALL cl_err3("ins","cnw_file",g_cnw.cnw01,g_cnw.cnw02,SQLCA.sqlcode,"","",1)  #TQC-660045
            CONTINUE WHILE
        ELSE
            SELECT cnw01,cnw02,cnw03,cnw04 INTO g_cnw.cnw01,g_cnw.cnw02,g_cnw.cnw03,g_cnw.cnw04 FROM cnw_file
                     WHERE cnw01 = g_cnw.cnw01
                       AND cnw02 = g_cnw.cnw02
                       AND cnw03 = g_cnw.cnw03
                       AND cnw04 = g_cnw.cnw04
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION i003_i(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1,          #No.FUN-680069 VARCHAR(1)
            l_flag    LIKE type_file.chr1,          #No.FUN-680069 VARCHAR(1)
            l_cob02   LIKE cob_file.cob02,
            l_cob021  LIKE cob_file.cob021,
            l_coc04   LIKE coc_file.coc04,
            l_input   LIKE type_file.chr1,          #No.FUN-680069 VARCHAR(1)
            l_edate   LIKE type_file.dat,           #No.FUN-680069 DATE
            l_coc05   LIKE coc_file.coc05,
            l_bdate   LIKE type_file.dat,           #No.FUN-680069 DATE
            l_n       LIKE type_file.num5,          #No.FUN-680069 SMALLINT
            g_n       LIKE type_file.num5,          #No.FUN-680069 SMALLINT
            g_cnt     LIKE type_file.num5          #No.FUN-680069 SMALLINT
   DEFINE   l_case    STRING                       #TQC-C20183 
 
   DISPLAY BY NAME
        g_cnw.cnw01,g_cnw.cnw02,g_cnw.cnw03,g_cnw.cnw04,
        g_cnw.cnw06,g_cnw.cnw07,g_cnw.cnw08,g_cnw.cnw09,g_cnw.cnw10,
        g_cnw.cnw11,g_cnw.cnw12,g_cnw.cnw13,g_cnw.cnw14,g_cnw.cnwconf,
        g_cnw.cnwuser,g_cnw.cnwgrup,g_cnw.cnwmodu,g_cnw.cnwdate,g_cnw.cnwacti
 
   INPUT BY NAME g_cnw.cnworiu,g_cnw.cnworig,
        g_cnw.cnw01,g_cnw.cnw02,g_cnw.cnw03,g_cnw.cnw04,
        g_cnw.cnw06,g_cnw.cnw07,g_cnw.cnw08,g_cnw.cnw09,g_cnw.cnw10,
        g_cnw.cnw11,g_cnw.cnw12,g_cnw.cnw13,g_cnw.cnw14,g_cnw.cnwconf
      WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL i003_set_entry(p_cmd)
          CALL i003_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
 
      AFTER FIELD cnw01
         LET l_case = NULL    #TQC-C20183--add--
         IF NOT cl_null(g_cnw.cnw01) THEN
            CALL i003_cnw01('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_cnw.cnw01,g_errno,1)
               LET g_cnw.cnw01 = g_cnw01_t
               DISPLAY BY NAME g_cnw.cnw01
               NEXT FIELD cnw01
            END IF
         #TQC-C20183--add--start--
            IF NOT i003_cnw06_check() THEN
               LET l_case = "cnw06"
            END IF
            IF NOT i003_cnw07_check() THEN
               LET l_case = "cnw07"
            END IF
            IF NOT i003_cnw08_check() THEN
               LET l_case = "cnw08"
            END IF
            IF NOT i003_cnw09_check() THEN
               LET l_case = "cnw09"
            END IF
            IF NOT i003_cnw10_check() THEN
               LET l_case = "cnw10"
            END IF
            IF NOT i003_cnw11_check() THEN
               LET l_case = "cnw11"
            END IF
            IF NOT i003_cnw12_check() THEN
               LET l_case = "cnw12"
            END IF
            IF NOT i003_cnw13_check() THEN
               LET l_case = "cnw13"
            END IF
            IF NOT i003_cnw14_check() THEN
               LET l_case = "cnw14"
            END IF
            LET g_cnw05_t = g_cnw.cnw05
            CASE l_case
               WHEN "cnw06"
                  NEXT FIELD cnw06
               WHEN "cnw07"
                  NEXT FIELD cnw07
               WHEN "cnw08"
                  NEXT FIELD cnw08
               WHEN "cnw09"
                  NEXT FIELD cnw09
               WHEN "cnw10"
                  NEXT FIELD cnw10
               WHEN "cnw11"
                  NEXT FIELD cnw11
               WHEN "cnw12"
                  NEXT FIELD cnw12
               WHEN "cnw13"
                  NEXT FIELD cnw13
               WHEN "cnw14"
                  NEXT FIELD cnw14
               OTHERWISE
                  EXIT CASE
           END CASE
         #TQC-C20183--add--end--
         END IF
 
      AFTER FIELD cnw02
         IF NOT cl_null(g_cnw.cnw02) THEN
            SELECT count(*) INTO l_n FROM coc_file
             WHERE coc03 = g_cnw.cnw02
               AND coc07 IS NULL
          IF l_n <=0 THEN
            LET g_cnw.cnw02 = NULL
            NEXT FIELD cnw02
          END IF
         END IF
         IF (NOT cl_null(g_cnw.cnw01)) AND (NOT cl_null(g_cnw.cnw02)) THEN
            SELECT count(*) INTO g_n FROM coc_file,coe_file
             WHERE coc01 = coe01
               AND coc03 = g_cnw.cnw02
               AND coe03 = g_cnw.cnw01
          IF g_n <=0 THEN
            CALL cl_err(g_cnw.cnw01,'aco-221',1)
            NEXT FIELD cnw01
          END IF
         END IF
 
      AFTER FIELD cnw03
         IF NOT cl_null(g_cnw.cnw03) THEN
            IF g_cnw.cnw03<=0 THEN
               NEXT FIELD cnw03
            END IF
         END IF
 
      AFTER FIELD cnw04
         IF NOT cl_null(g_cnw.cnw04) THEN
            IF g_cnw.cnw04 > 12 OR g_cnw.cnw04 < 1 THEN
               NEXT FIELD cnw04
            END IF
            SELECT COUNT(*) INTO g_cnt FROM cnw_file
             WHERE cnw01 = g_cnw.cnw01
               AND cnw02 = g_cnw.cnw02
               AND cnw03 = g_cnw.cnw03
               AND cnw04 = g_cnw.cnw04
            IF g_cnt > 0 THEN   #資料重復
               LET g_errno='-239'
               NEXT FIELD cnw01
            END IF
         END IF
 
 
      AFTER FIELD cnw06
         IF NOT i003_cnw06_check() THEN NEXT FIELD cnw06 END IF    #FUN-910088--add--
       #FUN-910088--mark--start--
       # IF NOT cl_null(g_cnw.cnw06) THEN
       #    IF g_cnw.cnw06 < 0 THEN
       #       LET g_cnw.cnw06 = NULL
       #       NEXT FIELD cnw06
       #    END IF
       # END IF
       #FUN-910088--mark--end--
 
      AFTER FIELD cnw07
         IF NOT i003_cnw07_check() THEN NEXT FIELD cnw07 END IF   #FUN-910088--add--
      #FUN-910088--mark--start--
      #  IF NOT cl_null(g_cnw.cnw07) THEN
      #     IF g_cnw.cnw07 < 0 THEN
      #        LET g_cnw.cnw07 = NULL
      #        NEXT FIELD cnw07
      #     END IF
      #  END IF
      #FUN-910088--mark--end--
      AFTER FIELD cnw08
         IF NOT i003_cnw08_check() THEN NEXT FIELD cnw08 END IF  #FUN-910088--add--
      #FUN-910088--mark--start--
      #  IF NOT cl_null(g_cnw.cnw08) THEN
      #     IF g_cnw.cnw08 < 0 THEN
      #        LET g_cnw.cnw08 = NULL
      #        NEXT FIELD cnw08
      #     END IF
      #  END IF
      #FUN-910088--mark--end--
      AFTER FIELD cnw09
         IF NOT i003_cnw09_check() THEN NEXT FIELD cnw09 END IF  #FUN-910088--add--
      #FUN-910088--mark--start--
      #  IF NOT cl_null(g_cnw.cnw09) THEN
      #     IF g_cnw.cnw09 < 0 THEN
      #        LET g_cnw.cnw09 = NULL
      #        NEXT FIELD cnw09
      #     END IF
      #  END IF
      #FUN-910088--mark--end--
      AFTER FIELD cnw10
         IF NOT i003_cnw10_check() THEN NEXT FIELD cnw10 END IF  #FUN-910088--add--
      #FUN-910088--mark--start--
      #  IF NOT cl_null(g_cnw.cnw10) THEN
      #     IF g_cnw.cnw10 < 0 THEN
      #        LET g_cnw.cnw10 = NULL
      #        NEXT FIELD cnw10
      #     END IF
      #  END IF
      #FUN-910088--mark--end--
      AFTER FIELD cnw11
         IF NOT i003_cnw11_check() THEN NEXT FIELD cnw11 END IF  #FUN-910088--add--
      #FUN-910088--mark--start-- 
      #  IF NOT cl_null(g_cnw.cnw11) THEN
      #     IF g_cnw.cnw11 < 0 THEN
      #        LET g_cnw.cnw11 = NULL
      #        NEXT FIELD cnw11
      #     END IF
      #  END IF
      #FUN-910088--mark--end--
      AFTER FIELD cnw12
         IF NOT i003_cnw12_check() THEN NEXT FIELD cnw12 END IF  #FUN-910088--add--
      #FUN-910088--mark--start--
      #  IF NOT cl_null(g_cnw.cnw12) THEN
      #     IF g_cnw.cnw12 < 0 THEN
      #        LET g_cnw.cnw12 = NULL
      #        NEXT FIELD cnw12
      #     END IF
      #  END IF
      #FUN-910088--mark--end--
      AFTER FIELD cnw13
         IF NOT i003_cnw13_check() THEN NEXT FIELD cnw13 END IF  #FUN-910088--add--
      #FUN-910088--mark--start--
      #  IF NOT cl_null(g_cnw.cnw13) THEN
      #     IF g_cnw.cnw13 < 0 THEN
      #        LET g_cnw.cnw13 = NULL
      #        NEXT FIELD cnw13
      #     END IF
      #  END IF
      #FUN-910088--mark--end--
      AFTER FIELD cnw14
         IF NOT i003_cnw14_check() THEN NEXT FIELD cnw14 END IF  #FUN-910088--add--
      #FUN-910088--mark--start--
      #  IF NOT cl_null(g_cnw.cnw14) THEN
      #     IF g_cnw.cnw14 < 0 THEN
      #        LET g_cnw.cnw14 = NULL
      #        NEXT FIELD cnw14
      #     END IF
      #  END IF
      #FUN-910088--mark--end--
 
      AFTER INPUT
         LET g_cnw.cnwuser = s_get_data_owner("cnw_file") #FUN-C10039
         LET g_cnw.cnwgrup = s_get_data_group("cnw_file") #FUN-C10039
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF (g_cnw.cnw01 IS NULL OR g_cnw.cnw02 IS NULL
               OR g_cnw.cnw03 IS NULL OR g_cnw.cnw04 IS NULL) THEN
               NEXT FIELD cnw01
            END IF
            CALL i003_check()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_cnw.cnw01,g_errno,1)
               NEXT FIELD cnw01
            END IF
         IF (NOT cl_null(g_cnw.cnw01)) AND (NOT cl_null(g_cnw.cnw02)) THEN
            SELECT count(*) INTO g_n FROM coc_file,coe_file
             WHERE coc01 = coe01
               AND coc03 = g_cnw.cnw02
               AND coe03 = g_cnw.cnw01
          IF g_n <=0 THEN
            CALL cl_err(g_cnw.cnw01,'aco-221',1)
            NEXT FIELD cnw01
          END IF
         END IF
         CALL s_azm(g_cnw.cnw03,g_cnw.cnw04) RETURNING l_flag,l_bdate,l_edate
         SELECT coc05 INTO l_coc05 FROM coc_file
          WHERE coc03=g_cnw.cnw02
             IF l_edate>l_coc05 THEN
               CALL cl_err('','aco-233',1)
                NEXT FIELD cnw03
             END IF
 
     #MOD-650015 --start 
     # ON ACTION CONTROLO                        # 沿用所有欄位
     #    IF INFIELD(cnw01) THEN
     #       LET g_cnw.* = g_cnw_t.*
     #       CALL i003_show()
     #       NEXT FIELD cnw01
     #    END IF
     #MOD-650015 --end
 
     ON ACTION controlp
        CASE
           WHEN INFIELD(cnw01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_cob3"
              LET g_qryparam.default1 = g_cnw.cnw01
              CALL cl_create_qry() RETURNING g_cnw.cnw01
              CALL i003_cnw01('a')
              DISPLAY BY NAME g_cnw.cnw01
              NEXT FIELD cnw01
            WHEN INFIELD(cnw02)         #手冊編號
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_coc204"
              LET g_qryparam.default1 = g_cnw.cnw02
              LET g_qryparam.arg1 = g_cnw.cnw01
              CALL cl_create_qry() RETURNING g_cnw.cnw02
              DISPLAY BY NAME g_cnw.cnw02
              NEXT FIELD cnw02
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
 
FUNCTION i003_cnw01(p_cmd)
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
    WHERE cob01=g_cnw.cnw01
      AND cob03 = '2'
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='aco-002'
                                LET l_cob02=NULL
                                LET l_cob021=NULL
                                LET l_cob04=NULL
       WHEN l_cobacti='N'       LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY l_cob02 TO FORMONLY.cob02
      DISPLAY l_cob021 TO FORMONLY.cob021
      LET g_cnw.cnw05=l_cob04
      DISPLAY BY NAME g_cnw.cnw05
   END IF
END FUNCTION
 
FUNCTION i003_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_cnw.* TO NULL            #No.FUN-6A0168
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i003_curs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i003_count
    FETCH i003_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i003_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cnw.cnw01,SQLCA.sqlcode,0)
        INITIALIZE g_cnw.* TO NULL
    ELSE
        CALL i003_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i003_fetch(p_flcnw)
    DEFINE
        p_flcnw       LIKE type_file.chr1         #No.FUN-680069 VARCHAR(1)
 
    CASE p_flcnw
        WHEN 'N' FETCH NEXT     i003_cs INTO g_cnw.cnw01,g_cnw.cnw02,g_cnw.cnw03,g_cnw.cnw04
        WHEN 'P' FETCH PREVIOUS i003_cs INTO g_cnw.cnw01,g_cnw.cnw02,g_cnw.cnw03,g_cnw.cnw04
        WHEN 'F' FETCH FIRST    i003_cs INTO g_cnw.cnw01,g_cnw.cnw02,g_cnw.cnw03,g_cnw.cnw04
        WHEN 'L' FETCH LAST     i003_cs INTO g_cnw.cnw01,g_cnw.cnw02,g_cnw.cnw03,g_cnw.cnw04
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
            FETCH ABSOLUTE g_jump i003_cs INTO g_cnw.cnw01,g_cnw.cnw02,g_cnw.cnw03,g_cnw.cnw04
            LET mi_no_ask = FALSE   #No.FUN-6A0059
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cnw.cnw01,SQLCA.sqlcode,0)
        INITIALIZE g_cnw.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
      CASE p_flcnw
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
    END IF
 
    SELECT * INTO g_cnw.* FROM cnw_file    # 重讀DB,因TEMP有不被更新特性
       WHERE cnw01 = g_cnw.cnw01 AND cnw02 = g_cnw.cnw02 AND cnw03 = g_cnw.cnw03 AND cnw04 = g_cnw.cnw04
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_cnw.cnw01,SQLCA.sqlcode,0) #No.TQC-660045
        CALL cl_err3("sel","cnw_file",g_cnw.cnw01,"",SQLCA.sqlcode,"","",1)  #TQC-660045
    ELSE
        LET g_data_owner=g_cnw.cnwuser           #FUN-4C0044權限控管
        LET g_data_group=g_cnw.cnwgrup
        LET g_data_plant = g_cnw.cnwplant #FUN-980030
        CALL i003_show()                   # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i003_show()
    LET g_cnw_t.* = g_cnw.*
    #FUN-910088--add--start--
    CALL i003_cnw01('d')
    LET g_cnw.cnw06 = s_digqty(g_cnw.cnw06,g_cnw.cnw05)
    LET g_cnw.cnw07 = s_digqty(g_cnw.cnw07,g_cnw.cnw05)
    LET g_cnw.cnw08 = s_digqty(g_cnw.cnw08,g_cnw.cnw05)
    LET g_cnw.cnw09 = s_digqty(g_cnw.cnw09,g_cnw.cnw05)
    LET g_cnw.cnw10 = s_digqty(g_cnw.cnw10,g_cnw.cnw05)
    LET g_cnw.cnw11 = s_digqty(g_cnw.cnw11,g_cnw.cnw05)
    LET g_cnw.cnw12 = s_digqty(g_cnw.cnw12,g_cnw.cnw05)
    LET g_cnw.cnw13 = s_digqty(g_cnw.cnw13,g_cnw.cnw05)
    LET g_cnw.cnw14 = s_digqty(g_cnw.cnw14,g_cnw.cnw05)
    #FUN-910088--add--end--
    DISPLAY BY NAME g_cnw.cnw01,g_cnw.cnw02,g_cnw.cnw03,g_cnw.cnw04, g_cnw.cnworiu,g_cnw.cnworig,
                    g_cnw.cnw05,g_cnw.cnw06,g_cnw.cnw07,g_cnw.cnw08,
                    g_cnw.cnw09,g_cnw.cnw10,g_cnw.cnw11,g_cnw.cnw12,
                    g_cnw.cnw13,g_cnw.cnw14,g_cnw.cnwuser,g_cnw.cnwgrup,
                    g_cnw.cnwmodu,g_cnw.cnwdate,g_cnw.cnwacti,g_cnw.cnwconf
  # CALL i003_cnw01('d')    #FUN-910088--mark--
    CALL cl_set_field_pic(g_cnw.cnwconf,"","","","",g_cnw.cnwacti)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i003_u()
    IF (g_cnw.cnw01 IS NULL AND g_cnw.cnw02 IS NULL
       AND g_cnw.cnw03 IS NULL AND g_cnw.cnw04 IS NULL) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    IF g_cnw.cnwacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    IF g_cnw.cnwconf='Y' THEN
       CALL cl_err(g_cnw.cnwconf,'9003',0)
       RETURN
    END IF
 
    SELECT * INTO g_cnw.* FROM cnw_file
     WHERE cnw01 = g_cnw.cnw01
       AND cnw02 = g_cnw.cnw02
       AND cnw03 = g_cnw.cnw03
       AND cnw04 = g_cnw.cnw04
    IF g_cnw.cnwacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_cnw01_t = g_cnw.cnw01
    LET g_cnw02_t = g_cnw.cnw02
    LET g_cnw03_t = g_cnw.cnw03
    LET g_cnw04_t = g_cnw.cnw04
    LET g_cnw05_t = g_cnw.cnw05     #FUN-910088--add--
    BEGIN WORK
 
    OPEN i003_cl USING g_cnw.cnw01,g_cnw.cnw02,g_cnw.cnw03,g_cnw.cnw04
    IF STATUS THEN
       CALL cl_err("OPEN i003_cl:", STATUS, 1)
       CLOSE i003_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i003_cl INTO g_cnw.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cnw.cnw01,SQLCA.sqlcode,1)
        RETURN
    END IF
    LET g_cnw.cnwmodu=g_user                  #修改者
    LET g_cnw.cnwdate = g_today               #修改日期
    CALL i003_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i003_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_cnw.*=g_cnw_t.*
            CALL i003_show()
#            CALL cl_err('',9002,0)
            EXIT WHILE
        END IF
        UPDATE cnw_file SET cnw_file.* = g_cnw.*    # 更新DB
            WHERE cnw01 = g_cnw.cnw01 AND cnw02 = g_cnw.cnw02 AND cnw03 = g_cnw.cnw03 AND cnw04 = g_cnw.cnw04
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_cnw.cnw01,SQLCA.sqlcode,0) #No.TQC-660045
            CALL cl_err3("upd","cnw_file",g_cnw01_t,"",SQLCA.sqlcode,"","",1)  #TQC-660045
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i003_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i003_x()
    IF (g_cnw.cnw01 IS NULL AND g_cnw.cnw02 IS NULL
       AND g_cnw.cnw03 IS NULL AND g_cnw.cnw04 IS NULL) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    IF g_cnw.cnwconf='Y' THEN
       CALL cl_err(g_cnw.cnwconf,'9003',0)
       RETURN
    END IF
    BEGIN WORK
 
    OPEN i003_cl USING g_cnw.cnw01,g_cnw.cnw02,g_cnw.cnw03,g_cnw.cnw04
    IF STATUS THEN
       CALL cl_err("OPEN i003_cl:", STATUS, 1)
       CLOSE i003_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i003_cl INTO g_cnw.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_cnw.cnw01,SQLCA.sqlcode,1)
       RETURN
    END IF
    CALL i003_show()
    IF cl_exp(0,0,g_cnw.cnwacti) THEN
        LET g_chr=g_cnw.cnwacti
        IF g_cnw.cnwacti='Y' THEN
            LET g_cnw.cnwacti='N'
        ELSE
            LET g_cnw.cnwacti='Y'
        END IF
        UPDATE cnw_file
            SET cnwacti=g_cnw.cnwacti
            WHERE cnw01 = g_cnw.cnw01 AND cnw02 = g_cnw.cnw02 AND cnw03 = g_cnw.cnw03 AND cnw04 = g_cnw.cnw04
        IF SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err(g_cnw.cnw01,SQLCA.sqlcode,0) #No.TQC-660045
            CALL cl_err3("upd","cnw_file",g_cnw.cnw01,"",SQLCA.sqlcode,"","",1)  #TQC-660045
            LET g_cnw.cnwacti=g_chr
        END IF
        DISPLAY BY NAME g_cnw.cnwacti
        CALL cl_set_field_pic(g_cnw.cnwconf,"","","","",g_cnw.cnwacti)
    END IF
    CLOSE i003_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i003_r()
    IF (g_cnw.cnw01 IS NULL AND g_cnw.cnw02 IS NULL
       AND g_cnw.cnw03 IS NULL AND g_cnw.cnw04 IS NULL) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_cnw.cnwacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    IF g_cnw.cnwconf='Y' THEN
       CALL cl_err(g_cnw.cnwconf,'9003',0)
       RETURN
    END IF
    BEGIN WORK
 
    OPEN i003_cl USING g_cnw.cnw01,g_cnw.cnw02,g_cnw.cnw03,g_cnw.cnw04
    IF STATUS THEN
       CALL cl_err("OPEN i003_cl:", STATUS, 0)
       CLOSE i003_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i003_cl INTO g_cnw.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_cnw.cnw01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i003_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL               #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "cnw01"              #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "cnw02"              #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "cnw03"              #No.FUN-9B0098 10/02/24
        LET g_doc.column4 = "cnw04"              #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_cnw.cnw01           #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_cnw.cnw02           #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_cnw.cnw03           #No.FUN-9B0098 10/02/24
        LET g_doc.value4 = g_cnw.cnw04           #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                              #No.FUN-9B0098 10/02/24
       DELETE FROM cnw_file
        WHERE cnw01 = g_cnw.cnw01
          AND cnw02 = g_cnw.cnw02
          AND cnw03 = g_cnw.cnw03
          AND cnw04 = g_cnw.cnw04
       CLEAR FORM
       OPEN i003_count
       #FUN-B50062-add-start--
       IF STATUS THEN
          CLOSE i003_cs
          CLOSE i003_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--

       FETCH i003_count INTO g_row_count
       #FUN-B50062-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i003_cs
          CLOSE i003_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i003_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i003_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE  #No.FUN-6A0059
          CALL i003_fetch('/')
       END IF
    END IF
    CLOSE i003_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i003_y()
DEFINE   l_coe06       LIKE coe_file.coe06
DEFINE   l_coj05       LIKE coj_file.coj05
DEFINE   l_year        LIKE type_file.num10        #No.FUN-680069 INTEGER
DEFINE   l_year_now    LIKE type_file.num10        #No.FUN-680069 INTEGER
DEFINE   l_coc01       LIKE coc_file.coc01
 
    IF (g_cnw.cnw01 IS NULL AND g_cnw.cnw02 IS NULL
       AND g_cnw.cnw03 IS NULL AND g_cnw.cnw04 IS NULL) THEN
       RETURN
    END IF
    SELECT * INTO g_cnw.* FROM cnw_file
     WHERE cnw01 = g_cnw.cnw01
       AND cnw02 = g_cnw.cnw02
       AND cnw03 = g_cnw.cnw03
       AND cnw04 = g_cnw.cnw04
    IF g_cnw.cnwacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    IF g_cnw.cnwconf='Y' THEN CALL cl_err(g_cnw.cnwconf,'aco-232',0) RETURN END IF
 
    IF NOT cl_confirm('axm-108') THEN RETURN END IF
    BEGIN WORK
    OPEN i003_cl USING g_cnw.cnw01,g_cnw.cnw02,g_cnw.cnw03,g_cnw.cnw04
    IF STATUS THEN
       CALL cl_err("OPEN i003_cl:", STATUS, 1)
       CLOSE i003_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i003_cl INTO g_cnw.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cnw.cnw01,SQLCA.sqlcode,0)          #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    #審核時，當前的年度期別不能小于同樣商品編號和手冊編號的年度期別
    SELECT max(cnw03*12+cnw04) INTO l_year FROM cnw_file
     WHERE cnw01 = g_cnw.cnw01
       AND cnw02 = g_cnw.cnw02
       AND cnwconf = 'Y'
    LET l_year_now = g_cnw.cnw03*12+g_cnw.cnw04
    IF l_year > l_year_now THEN
       CALL cl_err(g_cnw.cnw03,'aco-225',1)
       RETURN
    END IF
    #檢查數量的有效性
     CALL i003_check()
     IF NOT cl_null(g_errno) THEN
        CALL cl_err('cnw01:',g_errno,1)
        RETURN
     END IF
 
    SELECT SUM(coj05) INTO l_coj05 FROM coi_file,coj_file
     WHERE coi01=coj01 AND coi03=g_cnw.cnw02
       AND coj03=g_cnw.cnw01
       AND coiconf <> 'X'  #CHI-C80041
    IF cl_null(l_coj05) THEN
       LET l_coj05 = 0
    END IF
 
    SELECT coc01 INTO l_coc01 FROM coc_file WHERE coc03=g_cnw.cnw02
 
    #若數量有效性檢查符合則更新以下欄位
    #      手冊轉入coe051 = cnw06
    #  直接進口數量coe09  = cnw07
    #      直接耗用coe091 = cnw08
    #  轉廠進口數量coe101 = cnw09
    #      轉廠耗用coe102 = cnw10
    #  國內采購數量coe107 = cnw11
    #      內銷耗用coe106 = cnw12
    #      報廢數量coe105 = cnw13
    #      加簽數量coe10  = l_coj05 + cnw14   (這樣可以修正原來coe10錯誤的情況)
    #  條件        coe01=l_coc01 AND coe03=g_cnw.cnw01
     UPDATE coe_file SET coe051 = g_cnw.cnw06,
                         coe09  = g_cnw.cnw07,
                         coe091 = g_cnw.cnw08,
                         coe101 = g_cnw.cnw09,
                         coe102 = g_cnw.cnw10,
                         coe107 = g_cnw.cnw11,
                         coe106 = g_cnw.cnw12,
                         coe105 = g_cnw.cnw13,
                         coe10  = l_coj05 + g_cnw.cnw14
      WHERE coe01=l_coc01 AND coe03=g_cnw.cnw01
    LET g_success = 'Y'
    UPDATE cnw_file SET cnwconf='Y'
     WHERE cnw01 = g_cnw.cnw01
       AND cnw02 = g_cnw.cnw02
       AND cnw03 = g_cnw.cnw03
       AND cnw04 = g_cnw.cnw04
    COMMIT WORK
    SELECT cnwconf INTO g_cnw.cnwconf FROM cnw_file
    WHERE cnw01 = g_cnw.cnw01
      AND cnw02 = g_cnw.cnw02
      AND cnw03 = g_cnw.cnw03
      AND cnw04 = g_cnw.cnw04
    DISPLAY BY NAME g_cnw.cnwconf
    CALL cl_set_field_pic(g_cnw.cnwconf,"","","","",g_cnw.cnwacti)
END FUNCTION
 
 
FUNCTION i003_copy()
    DEFINE l_cnt         LIKE type_file.num10        #No.FUN-680069 INTEGER
    DEFINE
        l_newno1         LIKE cnw_file.cnw01,
        l_newno2         LIKE cnw_file.cnw02,
        l_newno3         LIKE cnw_file.cnw03,
        l_newno4         LIKE cnw_file.cnw04,
        l_oldno1         LIKE cnw_file.cnw01,
        l_oldno2         LIKE cnw_file.cnw02,
        l_oldno3         LIKE cnw_file.cnw03,
        l_oldno4         LIKE cnw_file.cnw04,
        l_coc04          LIKE coc_file.coc04,
        l_coc05          LIKE coc_file.coc05,
        l_flag           LIKE type_file.chr1,          #No.FUN-680069 VARCHAR(1)
        l_bdate          LIKE type_file.dat,           #No.FUN-680069 date
        l_edate          LIKE type_file.dat,           #No.FUN-680069 date
        g_n              LIKE type_file.num5,          #No.FUN-680069 SMALLINT
        l_n              LIKE type_file.num5,          #No.FUN-680069 SMALLINT
        p_cmd            LIKE type_file.chr1,          #No.FUN-680069 VARCHAR(1)
        l_input          LIKE type_file.chr1           #No.FUN-680069 VARCHAR(1)
    DEFINE l_case  STRING   #FUN-910088--add--
 
    IF (g_cnw.cnw01 IS NULL AND g_cnw.cnw02 IS NULL
       AND g_cnw.cnw03 IS NULL AND g_cnw.cnw04 IS NULL) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    IF g_cnw.cnwacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    IF g_cnw.cnwconf='Y' THEN
       LET g_cnw.cnwconf='N'
    END IF
    CALL cl_set_field_pic(g_cnw.cnwconf,"","","","",g_cnw.cnwacti)
 
    LET g_before_input_done = FALSE
    CALL i003_set_entry('a')
    LET g_before_input_done = TRUE
 
    INPUT l_newno1,l_newno2,l_newno3,l_newno4
     FROM cnw01,cnw02,cnw03,cnw04
 
        AFTER FIELD cnw04
              SELECT count(*) INTO l_cnt FROM cnw_file
                  WHERE cnw01 = l_newno1
                    AND cnw02 = l_newno2
                    AND cnw03 = l_newno3
                    AND cnw04 = l_newno4
              IF l_cnt > 0 THEN
                  CALL cl_err(l_newno1,-239,0)
                  NEXT FIELD cnw01
              END IF
                  SELECT cob02,cob021
                  FROM cob_file
                  WHERE cob01= l_newno1
                  IF SQLCA.sqlcode THEN
                      DISPLAY BY NAME g_cnw.cnw01
                      LET l_newno1 = NULL
                      NEXT FIELD cnw01
                  END IF
              CALL i003_cnw01('d')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(l_newno1,g_errno,1)
                 LET l_newno1 = NULL
                 NEXT FIELD cnw01
              END IF
              IF NOT cl_null(g_cnw.cnw02) THEN
                 SELECT count(*) INTO l_n FROM coc_file
                  WHERE coc03 = g_cnw.cnw02
                    AND coc07 IS NULL
               IF l_n <=0 THEN
                 LET g_cnw.cnw02 = NULL
                 NEXT FIELD cnw02
               END IF
              END IF
              IF (NOT cl_null(l_newno1)) AND (NOT cl_null(l_newno2)) THEN
                 SELECT count(*) INTO g_n FROM coc_file,coe_file
                  WHERE coc01 = coe01
                    AND coc03 = l_newno2
                    AND coe03 = l_newno1
               IF g_n <=0 THEN
                 CALL cl_err(l_newno1,'aco-221',1)
                 NEXT FIELD cnw01
               END IF
              END IF
            IF (NOT cl_null(l_newno1) AND NOT cl_null(l_newno2)
               AND NOT cl_null(l_newno3) AND NOT cl_null(l_newno4)) THEN
               CALL s_azm(l_newno3,l_newno4) RETURNING l_flag,l_bdate,l_edate
               SELECT MAX(coc05) INTO l_coc05 FROM coc_file
                WHERE coc03=l_newno2
                   IF l_edate>l_coc05 THEN
                      CALL cl_err('','aco-233',1)
                      NEXT FIELD cnw03
                   END IF
            END IF

 
        ON ACTION controlp                        # 沿用所有欄位
           CASE
             WHEN INFIELD(cnw01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_cob3"
                LET g_qryparam.default1 = g_cnw.cnw01
                CALL cl_create_qry() RETURNING l_newno1
                DISPLAY BY NAME l_newno1
                CALL i003_cnw01('a')
                IF NOT cl_null(g_errno) THEN
                   DISPLAY BY NAME g_cnw.cnw01
                   LET l_newno1 = NULL
                   NEXT FIELD cnw01
                END IF
                NEXT FIELD cnw01
              WHEN INFIELD(cnw02)         #手冊編號
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_coc204"
                LET g_qryparam.default1 = g_cnw.cnw02
                LET g_qryparam.arg1 = l_newno1
                CALL cl_create_qry() RETURNING l_newno2
                DISPLAY BY NAME l_newno2
              NEXT FIELD cnw02
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
        DISPLAY BY NAME g_cnw.cnw01,g_cnw.cnw02,g_cnw.cnw03,g_cnw.cnw04
        RETURN
    END IF
    DROP TABLE x
    SELECT * FROM cnw_file
        WHERE cnw01 = g_cnw.cnw01 AND cnw02 = g_cnw.cnw02 AND cnw03 = g_cnw.cnw03 AND cnw04 = g_cnw.cnw04
        INTO TEMP x
    UPDATE x
        SET cnw01=l_newno1,    #資料鍵值
            cnw02=l_newno2,
            cnw03=l_newno3,
            cnw04=l_newno4,
            cnwconf='N',      #資料確認否
            cnwacti='Y',      #資料有效碼
            cnwuser=g_user,   #資料所有者
            cnwgrup=g_grup,   #資料所有者所屬群
            cnwmodu=NULL,     #資料修改日期
            cnwdate=g_today   #資料建立日期
    INSERT INTO cnw_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_cnw.cnw01,SQLCA.sqlcode,0) #No.TQC-660045
        CALL cl_err3("ins","cnw_file",g_cnw.cnw01,g_cnw.cnw02,SQLCA.sqlcode,"","",1)  #TQC-660045
    ELSE
        MESSAGE 'ROW(',l_newno1,') O.K'
        LET l_oldno1 = g_cnw.cnw01
        LET l_oldno2 = g_cnw.cnw02
        LET l_oldno3 = g_cnw.cnw03
        LET l_oldno4 = g_cnw.cnw04
        LET g_cnw.cnw01 = l_newno1
        LET g_cnw.cnw02 = l_newno2
        LET g_cnw.cnw03 = l_newno3
        LET g_cnw.cnw04 = l_newno4
        SELECT cnw_file.* INTO g_cnw.* FROM cnw_file
               WHERE cnw01=l_newno1
                 AND cnw02=l_newno2
                 AND cnw03=l_newno3
                 AND cnw04=l_newno4
        CALL i003_u()
        #FUN-C30027---begin
        #SELECT cnw_file.* INTO g_cnw.* FROM cnw_file
        #       WHERE cnw01=l_oldno1
        #         AND cnw02=l_oldno2
        #         AND cnw03=l_oldno3
        #         AND cnw04=l_oldno4
        #FUN-C30027--end
    END IF
    #FUN-C30027---begin
    #LET g_cnw.cnw01 = l_oldno1
    #LET g_cnw.cnw02=l_oldno2
    #LET g_cnw.cnw03=l_oldno3
    #LET g_cnw.cnw04=l_oldno4
    #FUN-C30027---end
    CALL i003_show()
END FUNCTION
 
FUNCTION i003_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("cnw01,cnw02,cnw03,cnw04",TRUE)
     END IF
 
END FUNCTION
 
FUNCTION i003_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' THEN
       CALL cl_set_comp_entry("cnw01,cnw02,cnw03,cnw04",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION i003_check()
DEFINE   l_import_qty      LIKE cnw_file.cnw06           #已進口量
DEFINE   l_extra_apply_qty LIKE cnw_file.cnw14       #加簽數量
DEFINE   l_scrap_qty       LIKE cnw_file.cnw13           #已報廢量
DEFINE   l_used_total      LIKE cnw_file.cnw08           #耗用總量
DEFINE   l_apply_qty       LIKE coe_file.coe05           #申請數量
 
   LET g_errno=''
 
    #檢查數量的有效性
    #已進口量=cnw06+cnw07+cnw09+cnw11
     LET l_import_qty = g_cnw.cnw06+g_cnw.cnw07+g_cnw.cnw09+g_cnw.cnw11
 
    #加簽數量=cnw14
    LET l_extra_apply_qty = g_cnw.cnw14
 
    #已報廢量=cnw13
     LET l_scrap_qty = g_cnw.cnw13
 
    #耗用總數=cnw08+cnw10+cnw12
     LET l_used_total = g_cnw.cnw08+g_cnw.cnw10+g_cnw.cnw12
 
    #申請數量=select coe05+coe10 from coc_file,coe_file
    #          where coc01=coe01 and coc03=g_cnw.cnw02 and coe03=g_cnw.cnw01
     SELECT (coe05+coe10) INTO l_apply_qty FROM coc_file,coe_file
      WHERE coc01=coe01 and coc03=g_cnw.cnw02 and coe03=g_cnw.cnw01
 
    #已進口量 > 加簽數量+申請數量 error
     IF l_import_qty >(l_extra_apply_qty+l_apply_qty) THEN
        LET g_errno = 'aco-219'
     ELSE
        LET g_errno = ''
     END IF
 
    #已進口量 < 已報廢量+耗用總量 error
     IF l_import_qty <(l_used_total+l_scrap_qty) THEN
         LET g_errno = 'aco-220'
     END IF
END FUNCTION

#FUN-910088--add--start--
FUNCTION i003_cnw06_check()
    IF NOT cl_null(g_cnw.cnw06) AND NOT cl_null(g_cnw.cnw05) THEN
       IF cl_null(g_cnw05_t) OR cl_null(g_cnw_t.cnw06) OR g_cnw05_t != g_cnw.cnw05 OR g_cnw_t.cnw06 != g_cnw.cnw06 THEN
          LET g_cnw.cnw06 = s_digqty(g_cnw.cnw06,g_cnw.cnw05)
          DISPLAY BY NAME g_cnw.cnw06
       END IF
    END IF
    IF NOT cl_null(g_cnw.cnw06) THEN
       IF g_cnw.cnw06 < 0 THEN
          LET g_cnw.cnw06 = NULL
          RETURN FALSE
       END IF
    END IF
    RETURN TRUE
END FUNCTION

FUNCTION i003_cnw07_check()
    IF NOT cl_null(g_cnw.cnw07) AND NOT cl_null(g_cnw.cnw05) THEN
       IF cl_null(g_cnw05_t) OR cl_null(g_cnw_t.cnw07) OR g_cnw05_t != g_cnw.cnw05 OR g_cnw_t.cnw07 != g_cnw.cnw07 THEN
          LET g_cnw.cnw07 = s_digqty(g_cnw.cnw07,g_cnw.cnw05)
          DISPLAY BY NAME g_cnw.cnw07
       END IF
    END IF
    IF NOT cl_null(g_cnw.cnw07) THEN
       IF g_cnw.cnw07 < 0 THEN
          LET g_cnw.cnw07 = NULL
          RETURN FALSE
       END IF
    END IF
    RETURN TRUE
END FUNCTION

FUNCTION i003_cnw08_check()
    IF NOT cl_null(g_cnw.cnw08) AND NOT cl_null(g_cnw.cnw05) THEN
       IF cl_null(g_cnw05_t) OR cl_null(g_cnw_t.cnw08) OR g_cnw05_t != g_cnw.cnw05 OR g_cnw_t.cnw08 != g_cnw.cnw08 THEN
          LET g_cnw.cnw08 = s_digqty(g_cnw.cnw08,g_cnw.cnw05)
          DISPLAY BY NAME g_cnw.cnw08
       END IF
    END IF
    IF NOT cl_null(g_cnw.cnw08) THEN
       IF g_cnw.cnw08 < 0 THEN
          LET g_cnw.cnw08 = NULL
          RETURN FALSE
       END IF
    END IF
    RETURN TRUE
END FUNCTION

FUNCTION i003_cnw09_check()
    IF NOT cl_null(g_cnw.cnw09) AND NOT cl_null(g_cnw.cnw05) THEN
       IF cl_null(g_cnw05_t) OR cl_null(g_cnw_t.cnw09) OR g_cnw05_t != g_cnw.cnw05 OR g_cnw_t.cnw09 != g_cnw.cnw09 THEN
          LET g_cnw.cnw09 = s_digqty(g_cnw.cnw09,g_cnw.cnw05)
          DISPLAY BY NAME g_cnw.cnw09
       END IF
    END IF
    IF NOT cl_null(g_cnw.cnw09) THEN
       IF g_cnw.cnw09 < 0 THEN
          LET g_cnw.cnw09 = NULL
          RETURN FALSE
       END IF
    END IF
    RETURN TRUE
END FUNCTION

FUNCTION i003_cnw10_check()
    IF NOT cl_null(g_cnw.cnw10) AND NOT cl_null(g_cnw.cnw05) THEN
       IF cl_null(g_cnw05_t) OR cl_null(g_cnw_t.cnw10) OR g_cnw05_t != g_cnw.cnw05 OR g_cnw_t.cnw10 != g_cnw.cnw10 THEN
          LET g_cnw.cnw10 = s_digqty(g_cnw.cnw10,g_cnw.cnw05)
          DISPLAY BY NAME g_cnw.cnw10
       END IF
    END IF
    IF NOT cl_null(g_cnw.cnw10) THEN
       IF g_cnw.cnw10 < 0 THEN
          LET g_cnw.cnw10 = NULL
          RETURN FALSE
       END IF
    END IF
    RETURN TRUE
END FUNCTION

FUNCTION i003_cnw11_check()
    IF NOT cl_null(g_cnw.cnw11) AND NOT cl_null(g_cnw.cnw05) THEN
       IF cl_null(g_cnw05_t) OR cl_null(g_cnw_t.cnw11) OR g_cnw05_t != g_cnw.cnw05 OR g_cnw_t.cnw11 != g_cnw.cnw11 THEN
          LET g_cnw.cnw11 = s_digqty(g_cnw.cnw11,g_cnw.cnw05)
          DISPLAY BY NAME g_cnw.cnw11
       END IF
    END IF
    IF NOT cl_null(g_cnw.cnw11) THEN
       IF g_cnw.cnw11 < 0 THEN
          LET g_cnw.cnw11 = NULL
          RETURN FALSE
       END IF
    END IF
    RETURN TRUE
END FUNCTION

FUNCTION i003_cnw12_check()
    IF NOT cl_null(g_cnw.cnw12) AND NOT cl_null(g_cnw.cnw05) THEN
       IF cl_null(g_cnw05_t) OR cl_null(g_cnw_t.cnw12) OR g_cnw05_t != g_cnw.cnw05 OR g_cnw_t.cnw12 != g_cnw.cnw12 THEN
          LET g_cnw.cnw12 = s_digqty(g_cnw.cnw12,g_cnw.cnw05)
          DISPLAY BY NAME g_cnw.cnw12
       END IF
    END IF
    IF NOT cl_null(g_cnw.cnw12) THEN
       IF g_cnw.cnw12 < 0 THEN
          LET g_cnw.cnw12 = NULL
          RETURN FALSE
       END IF
    END IF
    RETURN TRUE
END FUNCTION

FUNCTION i003_cnw13_check()
    IF NOT cl_null(g_cnw.cnw13) AND NOT cl_null(g_cnw.cnw05) THEN
       IF cl_null(g_cnw05_t) OR cl_null(g_cnw_t.cnw13) OR g_cnw05_t != g_cnw.cnw05 OR g_cnw_t.cnw13 != g_cnw.cnw13 THEN
          LET g_cnw.cnw13 = s_digqty(g_cnw.cnw13,g_cnw.cnw05)
          DISPLAY BY NAME g_cnw.cnw13
       END IF
    END IF
    IF NOT cl_null(g_cnw.cnw13) THEN
       IF g_cnw.cnw13 < 0 THEN
          LET g_cnw.cnw13 = NULL
          RETURN FALSE
       END IF
    END IF
    RETURN TRUE
END FUNCTION

FUNCTION i003_cnw14_check()
    IF NOT cl_null(g_cnw.cnw14) AND NOT cl_null(g_cnw.cnw05) THEN
       IF cl_null(g_cnw05_t) OR cl_null(g_cnw_t.cnw14) OR g_cnw05_t != g_cnw.cnw05 OR g_cnw_t.cnw14 != g_cnw.cnw14 THEN
          LET g_cnw.cnw14 = s_digqty(g_cnw.cnw14,g_cnw.cnw05)
          DISPLAY BY NAME g_cnw.cnw14
       END IF
    END IF
    IF NOT cl_null(g_cnw.cnw14) THEN
       IF g_cnw.cnw14 < 0 THEN
          LET g_cnw.cnw14 = NULL
          RETURN FALSE
       END IF
    END IF
    RETURN TRUE
END FUNCTION
#FUN-910088--add--end--

