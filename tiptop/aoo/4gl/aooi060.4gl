# Prog. Version..: '5.30.06-13.03.15(00010)'     #
#
# Pattern name...: aooi060.4gl
# Descriptions...: 幣別匯率
# Date & Author..: 91/06/11 By Lee
#      Modify    : 92/05/06 By David
# Modify.........: No.MOD-480240 04/08/10 By Nicola 更改資料後，複製有問題
# Modify.........: No.MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4B0068 04/11/25 By ching add 匯率開窗 call s_rate
# Modify.........: No.FUN-4C0044 04/12/07 By pengu Data and Group權限控管
# Modify.........: No.FUN-4C0083 04/12/16 By pengu  匯率幣別欄位修改，與aoos010的aza17做判斷，
                                                    #如果二個幣別相同時，匯率強制為 1
# Modify.........: No.FUN-510027 05/02/03 By pengu 報表轉XML
# Modify.........: No.FUN-530067 05/05/02 By saki  匯率欄位顯示
# Modify.........: No.FUN-550037 05/05/13 By saki  欄位comment顯示
# Modify.........: No.MOD-550113 05/06/15 By pengu 查詢或新增模式下, 幣別名稱欄位皆無資料帶出 !!
# Modify.........: No.MOD-570015 05/07/14 By pengu 複製時,輸入幣別與年份後,單身自動變成最後一筆資料而不是當前的資料
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.FUN-640012 06/04/06 By kim GP3.0 匯率參數功能改善
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660131 06/06/19 By Cheunl cl_err --> cl_err3
# Modify.........: No.FUN-680102 06/08/28 By zdyllq 類型轉換 
# Modify.........: No.FUN-6A0015 06/10/25 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.FUN-6A0081 06/11/01 By atsea l_time轉g_time
# Modify.........: No.CHI-6A0004 06/11/07 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-680138 06/11/15 By Claire 年月欄位做月份合理性的判斷
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-740074 07/04/23 By jacklai 透過java抓取台銀網站的匯率純文字檔匯入azj_file
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-750164 07/05/24 By chenl   增加打印字段，有效否。
# Modify.........: No.FUN-760083 07/07/05 By mike 報表格式改為crystal reports
# Modify.........: No.MOD-7A0031 07/10/08 By Smapmin 將程式重新過單
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: NO.TQC-9B0052 09/11/16 By liuxqa 资料修改者未显示。
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50063 11/05/26 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:MOD-D20169 13/03/04 By bart 因FUN-980041有增加兩個欄位，導致傳的參數錯誤

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_azj   RECORD LIKE azj_file.*,
    g_azj_t RECORD LIKE azj_file.*,
    g_azj01_t LIKE azj_file.azj01,
    g_azj02_t LIKE azj_file.azj02,
    g_azj03_t LIKE azj_file.azj03,
    g_azj04_t LIKE azj_file.azj04,
   #g_azj05_t LIKE azj_file.azj05, #FUN-640012
   #g_azj06_t LIKE azj_file.azj06, #FUN-640012
    g_azj041_t LIKE azj_file.azj041,  #FUN-640012
    g_azj051_t LIKE azj_file.azj051,  #FUN-640012
    g_azj052_t LIKE azj_file.azj052,  #FUN-640012 
    g_azj07_t LIKE azj_file.azj07,
    g_wc,g_sql          STRING     
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL  
DEFINE g_before_input_done   LIKE type_file.num5          #No.FUN-680102 SMALLINT
DEFINE   g_chr           LIKE azj_file.azjacti        #No.FUN-680102 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680102 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680102CHAR(72)
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680102 SMALLINT
DEFINE   l_table         STRING                       #No.FUN-760083
DEFINE   g_str           STRING                       #No.FUN-760083
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5          #No.FUN-680102 SMALLINT
#       l_time        LIKE type_file.chr8              #No.FUN-6A0081
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF
 
 
    LET p_row = ARG_VAL(1)
    LET p_col = ARG_VAL(2)
 
        LET p_row = 4
        LET p_col = 14
 
    #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081 #FUN-BB0047 mark
    INITIALIZE g_azj.* TO NULL
    INITIALIZE g_azj_t.* TO NULL
 
#No.FUN-760083 --BEGIN--
    LET g_sql="azj01.azj_file.azj01,",
              "azj02.azj_file.azj02,",
              "azj03.azj_file.azj03,",
              "azj04.azj_file.azj04,",
              "azj041.azj_file.azj041,",
              "azj05.azj_file.azj05,",
              "azj051.azj_file.azj051,",
              "azj052.azj_file.azj052,",
              "azj06.azj_file.azj06,",
              "azj07.azj_file.azj07,",
              "azj08.azj_file.azj08,",
              "azj09.azj_file.azj09,",
              "azj10.azj_file.azj10,",
              "azjacti.azj_file.azjacti,",
              "azjuser.azj_file.azjuser,",
              "azjgrup.azj_file.azjgrup,",
              "azjmodu.azj_file.azjmodu,",
              "azjdate.azj_file.azjdate,",
              "azi02.azi_file.azi02,",
              "azi07.azi_file.azi07"
     LET l_table=cl_prt_temptable("aooi060",g_sql) CLIPPED
     IF l_table=-1 THEN EXIT PROGRAM END IF
     LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
       CALL cl_err("insert_prep:",status,1)
     END IF
#No.FUN-760083--END--
  
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
    LET g_forupd_sql = "SELECT * FROM azj_file  WHERE azj01=? AND azj02=? FOR UPDATE"                                                          
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i060_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR    
    LET p_row = 4 LET p_col = 14
    OPEN WINDOW i060_w AT p_row,p_col
        WITH FORM "aoo/42f/aooi060"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    IF g_aza.aza19='2' THEN  #使用每日匯率時,本作業不必輸入
       CALL cl_err('','aoo-066',0)
    END IF
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL i060_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW i060_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
END MAIN
 
FUNCTION i060_cs()
    CLEAR FORM
   INITIALIZE g_azj.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        azj01,azj02,azj03,azj04,azj041,azj051,azj052,  #azj05,azj06,  #FUN-640012
        azj07,
        azjuser,azjgrup,azjmodu,azjdate,azjacti
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION controlp                        # 查詢其他主檔資料
            IF INFIELD(azj01) THEN  #幣別
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azi"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_azj.azj01
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO azj01
                 NEXT FIELD azj01
            END IF
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
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND azjuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND azjgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND azjgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('azjuser', 'azjgrup')
    #End:FUN-980030
 
    LET g_sql="SELECT azj01,azj02 FROM azj_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY azj01"
    PREPARE i060_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i060cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i060_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM azj_file WHERE ",g_wc CLIPPED
    PREPARE i060_precount FROM g_sql
    DECLARE i060_count CURSOR FOR i060_precount
END FUNCTION
 
FUNCTION i060_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i060_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i060_q()
            END IF
        ON ACTION next
            CALL i060_fetch('N')
        ON ACTION previous
            CALL i060_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i060_u()
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL i060_x()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i060_r()
            END IF
       ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                 CALL i060_copy()
            END IF
       ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth()
               THEN CALL i060_out()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()          #No.FUN-550037
#           EXIT MENU
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL i060_fetch('/')
        ON ACTION first
            CALL i060_fetch('F')
        ON ACTION last
            CALL i060_fetch('L')

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
         ON ACTION related_document    #No.MOD-470515
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
              IF g_azj.azj01 IS NOT NULL THEN
                 LET g_doc.column1 = "azj01"
                 LET g_doc.value1 = g_azj.azj01
                 LET g_doc.column2 = "azj02"
                 LET g_doc.value2 = g_azj.azj02
                 CALL cl_doc()
              END IF
           END IF
 
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE i060cs
END FUNCTION
 
 
FUNCTION i060_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_azj.* LIKE azj_file.*
    LET g_azj01_t = NULL                         #預設欄位值
    LET g_azj02_t = NULL                         #預設欄位值
    LET g_azj.azj03=0
    LET g_azj.azj04=0
    #LET g_azj.azj05=0 #FUN-640012
    #LET g_azj.azj06=0 #FUN-640012
    LET g_azj.azj041=0 #FUN-640012
    LET g_azj.azj051=0 #FUN-640012
    LET g_azj.azj052=0 #FUN-640012
    LET g_azj.azj07=0
    LET g_azj_t.*=g_azj.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_azj.azjuser = g_user
        LET g_azj.azjoriu = g_user #FUN-980030
        LET g_azj.azjorig = g_grup #FUN-980030
        LET g_azj.azjgrup = g_grup               #使用者所屬群
        LET g_azj.azjdate = g_today
        LET g_azj.azjacti = 'Y'
        CALL i060_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_azj.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_azj.azj01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO azj_file VALUES(g_azj.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_azj.azj01,SQLCA.sqlcode,0)   #No.FUN-660131
            CALL cl_err3("ins","azj_file",g_azj.azj01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
            CONTINUE WHILE
        ELSE
            LET g_azj_t.* = g_azj.*                # 保存上筆資料
            SELECT azj01 INTO g_azj.azj01 FROM azj_file
                WHERE azj01 = g_azj.azj01
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION i060_i(p_cmd)
   DEFINE   p_cmd    LIKE type_file.chr1,          #No.FUN-680102 VARCHAR(1)
            l_flag   LIKE type_file.chr1,                 #判斷必要欄位是否有輸入        #No.FUN-680102 VARCHAR(1)
            l_n      LIKE type_file.num5          #No.FUN-680102 SMALLINT
 
 
   DISPLAY BY NAME g_azj.azjuser,g_azj.azjgrup, g_azj.azjdate,g_azj.azjacti
   INPUT BY NAME g_azj.azjoriu,g_azj.azjorig,
      g_azj.azj01,g_azj.azj02, g_azj.azj03,g_azj.azj04,
      #g_azj.azj05,g_azj.azj06,  #FUN-640012
      g_azj.azj041,g_azj.azj051,g_azj.azj052,  #FUN-640012
      g_azj.azj07
      WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL i060_set_entry(p_cmd)
          CALL i060_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
 
      AFTER FIELD azj01
           IF g_azj.azj01 IS NOT NULL THEN
              IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
                 (p_cmd = "u" AND g_azj.azj01 != g_azj01_t) THEN
                 SELECT azi01            #檢查幣別
                   FROM azi_file
                  WHERE azi01=g_azj.azj01 AND aziacti='Y'
                 IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_azj.azj01,'aoo-011',0)   #No.FUN-660131
                    CALL cl_err3("sel","azi_file",g_azj.azj01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                    LET g_azj.azj01=g_azj_t.azj01
                    NEXT FIELD azj01
                 END IF
              END IF
           END IF
           CALL i060_azj01('a')
 
      AFTER FIELD azj02   #年月
           IF NOT i060_chkym(g_azj.azj02) THEN
              CALL cl_err('','aoo-142',1)   #FUN-680138
              NEXT FIELD azj02
           END IF
           IF g_azj.azj02 IS NOT NULL THEN
              IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
                 (p_cmd = "u" AND (g_azj.azj01 != g_azj01_t OR
                 g_azj.azj02!=g_azj02_t)) THEN
                 SELECT count(*) INTO l_n FROM azj_file
                  WHERE azj01 = g_azj.azj01 AND azj02=g_azj.azj02
                 IF l_n > 0 THEN                  # Duplicated
                    CALL cl_err(g_azj.azj01,-239,0)
                    LET g_azj.azj01 = g_azj01_t
                    LET g_azj.azj02 = g_azj02_t
                    DISPLAY BY NAME g_azj.azj01
                    DISPLAY BY NAME g_azj.azj02
                    NEXT FIELD azj01
                 END IF
              END IF
           ELSE
               LET g_azj.azj02=g_azj02_t
           END IF
 
      AFTER FIELD azj03   #銀行賣出匯率
           #IF g_azj.azj03 <= 0 THEN  #FUN-640012
            IF g_azj.azj03 IS NULL OR g_azj.azj03 < 0 THEN  #FUN-640012
              NEXT FIELD azj03
           END IF
 
           #FUN-4C0083
           IF g_azj.azj03 IS NOT NULL THEN
              IF g_azj.azj01=g_aza.aza17 THEN
                 LET g_azj.azj03 =1
                 DISPLAY BY NAME g_azj.azj03
              END IF
           END IF
           #--END
           LET g_azj03_t=g_azj.azj03
 
      AFTER FIELD azj04   #銀行賣出匯率
           #IF g_azj.azj04 <= 0 THEN  #FUN-640012 
            IF g_azj.azj04 IS NULL OR g_azj.azj04 < 0 THEN   #FUN-640012
              NEXT FIELD azj04
           END IF
 
           #FUN-4C0083
           IF g_azj.azj04 IS NOT NULL THEN
              IF g_azj.azj01=g_aza.aza17 THEN
                 LET g_azj.azj04 =1
                 DISPLAY BY NAME g_azj.azj04
              END IF
           END IF
           #--END
 
           LET g_azj04_t=g_azj.azj04
 
      #FUN-640012...............begin
      #AFTER FIELD azj05   #月底採購匯率
      #     IF g_azj.azj05 <= 0 THEN
      #        NEXT FIELD azj05
      #     END IF
      #
      #     #FUN-4C0083
      #     IF g_azj.azj05 IS NOT NULL THEN
      #        IF g_azj.azj01=g_aza.aza17 THEN
      #           LET g_azj.azj05 =1
      #           DISPLAY BY NAME g_azj.azj05
      #        END IF
      #     END IF
      #     #--END
      #
      #     LET g_azj05_t=g_azj.azj05
      #
      #AFTER FIELD azj06   #月底銷售匯率
      #     IF g_azj.azj06 <= 0 THEN
      #        NEXT FIELD azj06
      #     END IF
      #
      #     #FUN-4C0083
      #     IF g_azj.azj06 IS NOT NULL THEN
      #        IF g_azj.azj01=g_aza.aza17 THEN
      #           LET g_azj.azj06 =1
      #           DISPLAY BY NAME g_azj.azj06
      #         END IF
      #     END IF
      #     #--END
      #
      #     LET g_azj06_t=g_azj.azj06
      ##add by danny 020304  期末調匯(A008)
 
      AFTER FIELD azj041                 #銀行中價匯率
         IF g_azj.azj041 IS NULL OR g_azj.azj041< 0  THEN
            NEXT FIELD azj041
         END IF
 
         IF g_azj.azj041 IS NOT NULL THEN
            IF g_azj.azj01=g_aza.aza17 THEN
               LET g_azj.azj041 =1
               DISPLAY BY NAME g_azj.azj041
            END IF
         END IF
 
      AFTER FIELD azj051                  #海關買入匯率
         IF g_azj.azj051 IS NULL OR g_azj.azj051< 0  THEN
            NEXT FIELD azj051
         END IF
 
         IF g_azj.azj051 IS NOT NULL THEN
            IF g_azj.azj01=g_aza.aza17 THEN
               LET g_azj.azj051 =1
               DISPLAY BY NAME g_azj.azj051
            END IF
         END IF
 
      AFTER FIELD azj052                  #海關賣出匯率
         IF g_azj.azj052 IS NULL OR g_azj.azj052< 0  THEN
            NEXT FIELD azj052
         END IF
 
         IF g_azj.azj052 IS NOT NULL THEN
            IF g_azj.azj01=g_aza.aza17 THEN
               LET g_azj.azj052 =1
               DISPLAY BY NAME g_azj.azj052
            END IF
         END IF
      #FUN-640012...............end
      
      AFTER FIELD azj07   #月底重評價匯率
           #IF g_azj.azj07 <= 0 THEN #FUN-640012
           IF g_azj.azj07 < 0 THEN #FUN-640012
              NEXT FIELD azj07
           END IF
 
           #FUN-4C0083
           IF g_azj.azj07 IS NOT NULL THEN
              IF g_azj.azj01=g_aza.aza17 THEN
                 LET g_azj.azj07 =1
                 DISPLAY BY NAME g_azj.azj07
              END IF
           END IF
           #--END
 
           LET g_azj07_t=g_azj.azj07
 
      AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
         LET g_azj.azjuser = s_get_data_owner("azj_file") #FUN-C10039
         LET g_azj.azjgrup = s_get_data_group("azj_file") #FUN-C10039
         LET l_flag='N'
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         IF g_azj.azj01 IS NULL THEN
            LET l_flag='Y'
            DISPLAY BY NAME g_azj.azj01
         END IF
         IF g_azj.azj02 IS NULL THEN
            LET l_flag='Y'
            DISPLAY BY NAME g_azj.azj02
         END IF
         #IF g_azj.azj03 IS NULL OR g_azj.azj03 <=0  THEN #FUN-640012
         IF g_azj.azj03 IS NULL OR g_azj.azj03 <0  THEN #FUN-640012
            LET l_flag='Y'
            DISPLAY BY NAME g_azj.azj03
         END IF
         #IF g_azj.azj04 IS NULL OR g_azj.azj04 <=0  THEN #FUN-640012
          IF g_azj.azj04 IS NULL OR g_azj.azj04 <0  THEN #FUN-640012
            LET l_flag='Y'
            DISPLAY BY NAME g_azj.azj04
         END IF
         #IF g_azj.azj05 IS NULL OR g_azj.azj05 <=0  THEN #FUN-640012
         IF g_azj.azj041 IS NULL OR g_azj.azj041 <0  THEN #FUN-640012
            LET l_flag='Y'
            DISPLAY BY NAME g_azj.azj041 ##FUN-640012 5->41
         END IF
         #IF g_azj.azj06 IS NULL OR g_azj.azj06 <=0  THEN #FUN-640012
         IF g_azj.azj051 IS NULL OR g_azj.azj051 <0  THEN #FUN-640012
            LET l_flag='Y'
            DISPLAY BY NAME g_azj.azj051 ##FUN-640012 6->51
         END IF
 
         #FUN-640012...............begin
         IF g_azj.azj052 IS NULL OR g_azj.azj052 <0  THEN
            LET l_flag='Y'
            DISPLAY BY NAME g_azj.azj052
         END IF
         #FUN-640012...............end
 
         #IF g_azj.azj07 IS NULL OR g_azj.azj07 <=0  THEN #FUN-640012
          IF g_azj.azj07 IS NULL OR g_azj.azj07 <0  THEN #FUN-640012
            LET l_flag='Y'
            DISPLAY BY NAME g_azj.azj07
         END IF
         IF l_flag='Y' THEN
            CALL cl_err('','9033',0)
            NEXT FIELD azj01
         END IF
 
        #MOD-650015 --start 
      #ON ACTION CONTROLO                        # 沿用所有欄位
      #   IF INFIELD(azj01) THEN
      #      LET g_azj.* = g_azj_t.*
      #      DISPLAY BY NAME g_azj.*
      #      NEXT FIELD azj01
      #   END IF
        #MOD-650015 --end
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION controlp                        # 查詢其他主檔資料
 
         CASE
            WHEN INFIELD(azj01)       #幣別
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azi"
                 LET g_qryparam.default1 = g_azj.azj01
                 CALL cl_create_qry() RETURNING g_azj.azj01
                 DISPLAY BY NAME g_azj.azj01
                 NEXT FIELD azj01
 
              #FUN-4B0068
              WHEN INFIELD(azj03)
                 CALL s_rate(g_azj.azj01,g_azj.azj03)
                 RETURNING g_azj.azj03
                 DISPLAY BY NAME g_azj.azj03
                 NEXT FIELD azj03
              WHEN INFIELD(azj04)
                 CALL s_rate(g_azj.azj01,g_azj.azj04)
                 RETURNING g_azj.azj04
                 DISPLAY BY NAME g_azj.azj04
                 NEXT FIELD azj04
              #FUN-640012..........begin
              #WHEN INFIELD(azj05)
              #   CALL s_rate(g_azj.azj01,g_azj.azj05)
              #   RETURNING g_azj.azj05
              #   DISPLAY BY NAME g_azj.azj05
              #   NEXT FIELD azj05
              #WHEN INFIELD(azj06)
              #   CALL s_rate(g_azj.azj01,g_azj.azj06)
              #   RETURNING g_azj.azj06
              #   DISPLAY BY NAME g_azj.azj06
              #   NEXT FIELD azj06
              WHEN INFIELD(azj041)
                 CALL s_rate(g_azj.azj01,g_azj.azj041)
                 RETURNING g_azj.azj041
                 DISPLAY BY NAME g_azj.azj041
                 NEXT FIELD azj041
              WHEN INFIELD(azj051)
                 CALL s_rate(g_azj.azj01,g_azj.azj051)
                 RETURNING g_azj.azj051
                 DISPLAY BY NAME g_azj.azj051
                 NEXT FIELD azj05
              WHEN INFIELD(azj052)
                 CALL s_rate(g_azj.azj01,g_azj.azj052)
                 RETURNING g_azj.azj052
                 DISPLAY BY NAME g_azj.azj052
                 NEXT FIELD azj052
              #FUN-640012..........end
              WHEN INFIELD(azj07)
                 CALL s_rate(g_azj.azj01,g_azj.azj07)
                 RETURNING g_azj.azj07
                 DISPLAY BY NAME g_azj.azj07
                 NEXT FIELD azj07
              #--
         END CASE
 
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
 
 
FUNCTION i060_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_azj.* TO NULL              #No.FUN-6A0015
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i060_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i060_count
    FETCH i060_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i060cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_azj.azj01,SQLCA.sqlcode,0)
        INITIALIZE g_azj.* TO NULL
    ELSE
    CALL i060_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
 
FUNCTION i060_fetch(p_flazj)
    DEFINE
        p_flazj         LIKE type_file.chr1,           #No.FUN-680102CHAR(1),
        l_abso          LIKE type_file.num10         #No.FUN-680102 INTEGER
 
    CASE p_flazj
        WHEN 'N' FETCH NEXT     i060cs INTO g_azj.azj01,g_azj.azj02
        WHEN 'P' FETCH PREVIOUS i060cs INTO g_azj.azj01,g_azj.azj02
        WHEN 'F' FETCH FIRST    i060cs INTO g_azj.azj01,g_azj.azj02
        WHEN 'L' FETCH LAST     i060cs INTO g_azj.azj01,g_azj.azj02
        WHEN '/'
            IF (NOT mi_no_ask) THEN
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
            FETCH ABSOLUTE g_jump i060cs INTO g_azj.azj01,g_azj.azj02
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_azj.azj01,SQLCA.sqlcode,0)
        INITIALIZE g_azj.* TO NULL  #TQC-6B0105
        LET g_azj.azj01 = NULL      #TQC-6B0105
        RETURN
    ELSE
       CASE p_flazj
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_azj.* FROM azj_file            # 重讀DB,因TEMP有不被更新特性
       WHERE azj01=g_azj.azj01 AND azj02=g_azj.azj02
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_azj.azj01,SQLCA.sqlcode,0)   #No.FUN-660131
       CALL cl_err3("sel","azj_file",g_azj.azj01,g_azj.azj02,SQLCA.sqlcode,"","",1)  #No.FUN-660131
    ELSE                                      #FUN-4C0044權限控管
       LET g_data_owner = g_azj.azjuser
       LET g_data_group = g_azj.azjgrup
        CALL i060_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i060_show()
    LET g_azj_t.* = g_azj.*
    DISPLAY BY NAME g_azj.azj01,g_azj.azj02,g_azj.azj03,g_azj.azj04, g_azj.azjoriu,g_azj.azjorig,
                    #g_azj.azj05,g_azj.azj06, #FUN-640012
                    g_azj.azj041,g_azj.azj051,g_azj.azj052, #FUN-640012
                    g_azj.azj07,
                    g_azj.azjuser,g_azj.azjgrup,g_azj.azjmodu,       #TQC-9B0052 Mod
                    g_azj.azjdate,g_azj.azjacti
 
    CALL i060_azj01('d')
    CALL cl_show_fld_cont()             #No.FUN-550037
END FUNCTION
 
FUNCTION i060_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_azj.azj01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_azj.* FROM azj_file WHERE azj01=g_azj.azj01
                                          AND azj02=g_azj.azj02
    IF g_azj.azjacti ='N' THEN
        CALL cl_err('','aoo-062',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_azj01_t = g_azj.azj01
    LET g_azj02_t = g_azj.azj02
    LET g_azj03_t = g_azj.azj03
    LET g_azj04_t = g_azj.azj04
    #LET g_azj05_t = g_azj.azj05 #FUN-640012
    #LET g_azj06_t = g_azj.azj06 #FUN-640012
    LET g_azj041_t = g_azj.azj041 #FUN-640012
    LET g_azj051_t = g_azj.azj051 #FUN-640012
    LET g_azj052_t = g_azj.azj052 #FUN-640012
    LET g_azj07_t = g_azj.azj07
    BEGIN WORK
 
    OPEN i060_cl USING g_azj.azj01,g_azj.azj02
    IF STATUS THEN
       CALL cl_err("OPEN i060_cl:", STATUS, 1)
       CLOSE i060_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i060_cl INTO g_azj.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_azj.azj01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_azj.azjmodu=g_user                     #修改者
    LET g_azj.azjdate = g_today                  #修改日期
    CALL i060_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i060_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
  LET g_azj.*=g_azj_t.*
            CALL i060_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE azj_file SET azj_file.* = g_azj.*    # 更新DB
            WHERE azj01=g_azj.azj01 AND azj02=g_azj.azj02             # COLAUTH?
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_azj.azj01,SQLCA.sqlcode,0)   #No.FUN-660131
            CALL cl_err3("upd","azj_file",g_azj_t.azj01,g_azj_t.azj02,SQLCA.sqlcode,"","",1)  #No.FUN-660131
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i060_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION  i060_azj01(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,          #No.FUN-680102 VARCHAR(1)
    l_azi02         LIKE azi_file.azi02,
    l_aziacti       LIKE azi_file.aziacti
 
    SELECT azi02,aziacti
        INTO l_azi02,l_aziacti
        FROM azi_file
        WHERE azi01 = g_azj.azj01
    LET g_chr = ' '
    IF SQLCA.sqlcode THEN
        LET g_chr = 'E'
        LET l_azi02 = NULL
    ELSE
        IF l_aziacti='N' THEN
            LET g_chr = 'E'
        END IF
    END IF
     DISPLAY l_azi02 TO azi02       #MOD-550113
   { IF p_cmd = 'd' OR cl_null(g_chr) THEN
     i("u") THEN                     # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_azj.*=g_azj_t.*
            CALL i060_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE azj_file SET azj_file.* = g_azj.*    # 更新DB
            WHERE azj01=g_azj.azj01 AND azj02=g_azj.azj02             # COLAUTH?
        IF SQLCA.sqlcode THEN
            CALL cl_err(g_azj.azj01,SQLCA.sqlcode,0)   
            CONTINUE WHILE
        END IF
        EXIT WHILE
 
    END WHILE
    CLOSE i060_cl
    COMMIT WORK}
END FUNCTION
 
FUNCTION i060_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_azj.azj01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    #-genero-------------------------------------------------------------
    #(1) If you have "?" inside above DECLARE SELECT FOR UPDATE SQL
    #(2) Then using syntax: "OPEN cursor USING variable"
    #For example, "OPEN a USING g_a_worid"
    #
    #* Remember to remove releated block of *.ora file, no more needed
    #--------------------------------------------------------------------
    #--Put variable into LOCK CURSOR
    OPEN i060_cl USING g_azj.azj01,g_azj.azj02
    #--Add exception check during OPEN CURSOR
    IF STATUS THEN
       CALL cl_err("OPEN i060_cl:", STATUS, 1)
       CLOSE i060_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i060_cl INTO g_azj.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_azj.azj01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i060_show()
    IF cl_exp(0,0,g_azj.azjacti) THEN
        LET g_chr=g_azj.azjacti
        IF g_azj.azjacti='Y' THEN
            LET g_azj.azjacti='N'
        ELSE
            LET g_azj.azjacti='Y'
        END IF
        UPDATE azj_file
            SET azjacti=g_azj.azjacti
            WHERE azj01=g_azj.azj01 AND azj02=g_azj.azj02
        IF SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err(g_azj.azj01,SQLCA.sqlcode,0)   #No.FUN-660131
            CALL cl_err3("upd","azj_file",g_azj.azj01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
            LET g_azj.azjacti=g_chr
        END IF
        DISPLAY BY NAME g_azj.azjacti
    END IF
    CLOSE i060_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i060_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_azj.azj01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    #-genero-------------------------------------------------------------
    #(1) If you have "?" inside above DECLARE SELECT FOR UPDATE SQL
    #(2) Then using syntax: "OPEN cursor USING variable"
    #For example, "OPEN a USING g_a_worid"
    #
    #* Remember to remove releated block of *.ora file, no more needed
    #--------------------------------------------------------------------
    #--Put variable into LOCK CURSOR
    OPEN i060_cl USING g_azj.azj01,g_azj.azj02
    #--Add exception check during OPEN CURSOR
    IF STATUS THEN
       CALL cl_err("OPEN i060_cl:", STATUS, 1)
       CLOSE i060_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i060_cl INTO g_azj.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_azj.azj01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i060_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "azj01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_azj.azj01      #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "azj02"         #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_azj.azj02      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM azj_file WHERE azj01=g_azj.azj01 AND azj02=g_azj.azj02
       CLEAR FORM
       OPEN i060_count
       #FUN-B50063-add-start--
       IF STATUS THEN
          CLOSE i060cs
          CLOSE i060_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end-- 
       FETCH i060_count INTO g_row_count
       #FUN-B50063-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i060cs
          CLOSE i060_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i060cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i060_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL i060_fetch('/')
       END IF
    END IF
    CLOSE i060_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i060_copy()
    DEFINE
        l_azj		RECORD LIKE azj_file.*,
        l_newno,l_oldno         LIKE azj_file.azj01,
        l_newno2,l_oldno2       LIKE azj_file.azj02
 
    IF s_shut(0) THEN RETURN END IF
    IF g_azj.azj01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
     #-----No.MOD-480240-----
    LET g_before_input_done = FALSE
    CALL i060_set_entry("a")
    LET g_before_input_done = TRUE
    #-----END---------------
 
    INPUT l_newno,l_newno2 FROM azj01,azj02
 
       AFTER FIELD azj01
          IF l_newno IS NOT NULL THEN
             SELECT azi01            #檢查幣別
                 FROM azi_file
                 WHERE azi01=l_newno
             IF SQLCA.sqlcode THEN
#                CALL cl_err(l_newno,'aoo-011',0)   #No.FUN-660131
                 CALL cl_err3("sel","azi_file",l_newno,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                 NEXT FIELD azj01
             END IF
          END IF
 
       AFTER FIELD azj02
          IF l_newno2 IS NOT NULL AND i060_chkym(l_newno2) THEN
             SELECT count(*) INTO g_cnt FROM azj_file
                 WHERE azj01 = l_newno AND
                       azj02=l_newno2
             IF g_cnt > 0 THEN                  # Duplicated
                 CALL cl_err(l_newno2,-239,0)
                 NEXT FIELD azj01
             END IF
          END IF
          #FUN-680138-begin-add
           IF NOT i060_chkym(l_newno2) THEN
              CALL cl_err('','aoo-142',1)  
              NEXT FIELD azj02
           END IF
          #FUN-680138-end-add
 
       ON ACTION controlp                        # 查詢其他主檔資料
           IF INFIELD(azj01) THEN  #幣別
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_azi"
                LET g_qryparam.default1 = g_azj.azj01
                CALL cl_create_qry() RETURNING l_newno
#                CALL FGL_DIALOG_SETBUFFER( l_newno )
                DISPLAY BY NAME l_newno
                NEXT FIELD azj01
           END IF
 
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
       RETURN
    END IF
 
    LET l_azj.* = g_azj.*
    LET l_azj.azj01  =l_newno   #新的鍵值
    LET l_azj.azj02  =l_newno2  #新的鍵值
    LET l_azj.azjuser=g_user    #資料所有者
    LET l_azj.azjgrup=g_grup    #資料所有者所屬群
    LET l_azj.azjmodu=NULL      #資料修改日期
    LET l_azj.azjdate=g_today   #資料建立日期
    LET l_azj.azjacti='Y'       #有效資料
 
    DROP TABLE x  #No.MOD-570015 add
   SELECT * FROM azj_file
    WHERE azj01=g_azj.azj01 AND azj02=g_azj.azj02
     INTO TEMP x
 
   UPDATE x
       SET azj01=l_newno,    #資料鍵值
           azj02=l_newno2,
           azjacti='Y',      #資料所有者
           azjuser=g_user,   #資料所有者
           azjgrup=g_grup,   #資料所有者所屬群
           azjmodu=NULL,     #資料修改日期
           azjdate=g_today   #資料建立日期
 
   INSERT INTO azj_file SELECT * FROM x
 
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_azj.azj01,SQLCA.sqlcode,0)   #No.FUN-660131
      CALL cl_err3("ins","azj_file",g_azj.azj01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
   ELSE
      MESSAGE 'ROW(',l_newno,'-',l_newno2,') O.K'
      LET l_oldno = g_azj.azj01
      LET l_oldno2 = g_azj.azj02
      SELECT azj_file.* INTO g_azj.* FROM azj_file
       WHERE azj01 = l_newno AND azj02=l_newno2
      CALL i060_u()
      #SELECT azj_file.* INTO g_azj.* FROM azj_file  #FUN-C80046
      # WHERE azj01 = l_oldno AND azj02=l_oldno2     #FUN-C80046
   END IF
   CALL i060_show()
END FUNCTION
 
FUNCTION i060_out()
    DEFINE
        l_i             LIKE type_file.num5,          #No.FUN-680102 SMALLINT
        l_name          LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680102 VARCHAR(20)
        l_za05          LIKE za_file.za05,            #No.FUN-680102 VARCHAR(40)
        sr RECORD LIKE azj_file.*
    DEFINE l_azi02      LIKE azi_file.azi02           #No.FUN-760083 
    DEFINE t_azi07      LIKE azi_file.azi07           #No.FUN-760083
    IF cl_null(g_wc) THEN
       LET g_wc=" azj01='",g_azj.azj01,"' AND"," azj02='",g_azj.azj02,"'"
    END IF
    LET g_str=''                                                      #No.FUN-760083
    CALL cl_del_data(l_table)                                         #No.FUN-760083
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog            #No.FUN-760083
    IF g_wc IS NULL THEN
     #  CALL cl_err('',-400,0)
        CALL cl_err('','9057',0)
        RETURN
    END IF
    CALL cl_wait()
  # LET l_name = 'i060.out'
    #CALL cl_outnam('aooi060') RETURNING l_name                       #No.FUN-760083
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM azj_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED
    PREPARE i060_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i060_co                         # SCROLL CURSOR
         CURSOR FOR i060_p1
 
    #START REPORT i060_rep TO l_name                                   #No.FUN-760083
 
    FOREACH i060_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)    
            EXIT FOREACH
            END IF
#No.FUN-760083  --begin--
        #OUTPUT TO REPORT i060_rep(sr.*)                               #No.FUN-760083
         SELECT azi02,azi07 INTO l_azi02 ,t_azi07 FROM azi_file WHERE azi01=sr.azj01                                              
            IF SQLCA.sqlcode THEN                                                                                                   
               LET l_azi02=NULL                   
               LET t_azi07=0                                                                                  
            END IF          
            IF cl_null(t_azi07) THEN
               LET t_azi07=0
            END IF       
         #MOD-D20169---begin           
         #EXECUTE insert_prep USING sr.* ,l_azi02,t_azi07               #No.FUN-760083
         EXECUTE insert_prep USING sr.azj01,sr.azj02,sr.azj03,sr.azj04,sr.azj041,sr.azj05,sr.azj051,sr.azj052,
                                   sr.azj06,sr.azj07,sr.azj08,sr.azj09,sr.azj10,
                                   sr.azjacti,sr.azjuser,sr.azjgrup,sr.azjmodu,sr.azjdate,l_azi02,t_azi07
         #MOD-D20169---end                          
#No.FUN-760083 --end--
    END FOREACH
 
    #FINISH REPORT i060_rep                                            #No.FUN-760083
 
    CLOSE i060_co
    ERROR ""
    #CALL cl_prt(l_name,' ','1',g_len)                                 #No.FUN-760083
    LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED     #No.FUN-760083
    IF g_zz05='Y' THEN                                                    #No.FUN-760083
        CALL cl_wcchp(g_wc,'azj01,azj02,azj03,azj04,azj041,azj051,azj052, #No.FUN-760083                                                 
                       azj07,azjuser,azjgrup,azjmodu,azjdate,azjacti')    #No.FUN-760083                                                                                                                  
        RETURNING   g_wc                                                  #No.FUN-760083
    END IF                                                                #No.FUN-760083
    LET g_str=g_wc                                                        #No.FUN-760083
    CALL cl_prt_cs3("aooi060","aooi060",g_sql,g_str)                      #No.FUN-760083
END FUNCTION
 
#No.FUN-760083 --begin--
{
REPORT i060_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,           #No.FUN-680102CHAR(1)
        l_chr           LIKE type_file.chr1,          #No.FUN-680102 VARCHAR(1)
      #  t_azi07         LIKE azi_file.azi07, #FUN-640012 #NO.CHI-6A0004
        l_azi02         LIKE azi_file.azi02, #FUN-640012
        sr RECORD LIKE azj_file.*
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.azj01,sr.azj02
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT g_dash
            PRINT COLUMN (g_c[34]+20),g_x[9] CLIPPED,
                  COLUMN (g_c[37]+14),g_x[10]
            PRINT COLUMN g_c[34],g_dash2[1,g_w[34]+g_w[35]+g_w[36]+2],
                  COLUMN g_c[37],g_dash2[1,g_w[37]+g_w[38]+1]
            PRINT g_x[31],g_x[32],g_x[33],g_x[34],
                  g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40]      #No.TQC-750164
            PRINT g_dash1
            LET l_trailer_sw = 'y'
        ON EVERY ROW
            SELECT azi02,azi07 INTO l_azi02,t_azi07 FROM azi_file WHERE azi01=sr.azj01
            IF SQLCA.sqlcode THEN
               LET l_azi02=NULL
               LET t_azi07=0
            END IF
            IF cl_null(t_azi07) THEN
               LET t_azi07=0
            END IF
            PRINT COLUMN g_c[31],sr.azj01,
                  COLUMN g_c[32],l_azi02,
                  COLUMN g_c[33],sr.azj02,
                  COLUMN g_c[34],cl_numfor(sr.azj03  ,34,t_azi07),
                  COLUMN g_c[35],cl_numfor(sr.azj04  ,35,t_azi07),
                  COLUMN g_c[36],cl_numfor(sr.azj041 ,36,t_azi07),
                  COLUMN g_c[37],cl_numfor(sr.azj051 ,37,t_azi07),
                  COLUMN g_c[38],cl_numfor(sr.azj052 ,38,t_azi07),
                  COLUMN g_c[39],cl_numfor(sr.azj07  ,39,t_azi07),
                  COLUMN g_c[40],sr.azjacti
        ON LAST ROW
            IF g_zz05 = 'Y' THEN PRINT 
               g_dash
               CALL cl_prt_pos_wc(g_wc)
            END IF
            PRINT g_dash
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
}
#No.FUN-760083 --end--
 
FUNCTION i060_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("azj01,azj02",TRUE)
     END IF
 
END FUNCTION
 
FUNCTION i060_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' THEN
       CALL cl_set_comp_entry("azj01,azj02",FALSE)
    END IF
 
END FUNCTION
 
##################################################
# Description  	: 檢查文字型態變數是否為年月型態.
# Date & Author : 2003/09/22 by Hiko
# Parameter   	: p_str VARCHAR(6) 文字型態變數
# Return   	: TRUE:是年月型態 FALSE:非年月型態
# Memo        	:
# Modify   	:
##################################################
FUNCTION i060_chkym(p_str)
   DEFINE p_str         LIKE azj_file.azj02,      #No.FUN-680102CHAR(6),
          yy		LIKE type_file.chr4,      #No.FUN-680102 VARCHAR(4),
          mm		LIKE type_file.chr2       #No.FUN-680102  VARCHAR(2) 
 
   LET yy = p_str[1,4]
   LET mm = p_str[5,6]
 
   #FUN-680138-begin-add
   IF cl_null(yy) OR cl_null(MM) OR  Length(yy) <> 4 THEN
      RETURN 0
   END IF
   #FUN-680138-end-add
 
   IF yy < '00' OR yy > '9999'
      THEN RETURN 0
   END IF
   IF mm < '01' OR mm > '12'
      THEN RETURN 0
   END IF
   RETURN 1
END FUNCTION
 
#No.FUN-740074 remove java function
 
#MOD-7A0031

