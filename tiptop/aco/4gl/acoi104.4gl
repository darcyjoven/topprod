# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: acoi104.4gl
# Descriptions...: 公司基本資料維護作業
# Date & Author..: 00/07/24 Carol
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.TQC-660045 06/06/12 BY cheunl  cl_err --->cl_err3
# MOdify.........: No.FUN-680069 06/08/23 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.FUN-6A0168 06/10/28 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-770006 07/07/05 By zhoufeng 報表輸出改為Crystal Reports
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-990099 09/10/10 By lilingyu "注冊資本""投資總額""進口設備免稅額度"未控管負數
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50062 11/05/18 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_cnb   RECORD LIKE cnb_file.*,		#海關基本資料檔
    g_cnb_t RECORD LIKE cnb_file.*,		#海關基本資料檔
    g_cnb01_t LIKE cnb_file.cnb01,              #海關代號
   #g_wc,g_sql          STRING #TQC-630166        #No.FUN-680069
    g_wc,g_sql          STRING    #TQC-630166        #No.FUN-680069
 
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL        #No.FUN-680069
DEFINE   g_before_input_done   STRING      #No.FUN-680069
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680069 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680069 INTEGER
#CKP3
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680069 SMALLINT
DEFINE l_table         STRING                       #No.FUN-770006              
DEFINE g_str           STRING                       #No.FUN-770006 
MAIN
#     DEFINEl_time LIKE type_file.chr8              #No.FUN-6A0063
DEFINE p_row,p_col     LIKE type_file.num5          #No.FUN-680069 SMALLINT
 
    OPTIONS					#改變一些系統預設值
						
        INPUT NO WRAP
    DEFER INTERRUPT				#擷取中斷鍵,由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ACO")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690109
#No.FUN-770006 --start--
   LET g_sql="cnbacti.cnb_file.cnbacti,cnb01.cnb_file.cnb01,",
             "cnb06.cnb_file.cnb06,cnb07.cnb_file.cnb07,cnb03.cnb_file.cnb03,",
             "cnb05.cnb_file.cnb05,cna02.cna_file.cna02"
 
   LET l_table = cl_prt_temptable('acoi104',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF 
#No.FUN-770006 --end--
 
    INITIALIZE g_cnb.* TO NULL
    INITIALIZE g_cnb_t.* TO NULL
 
    LET g_forupd_sql =
      " SELECT * FROM cnb_file WHERE cnb01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i104_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET p_row = 3 LET p_col = 3
    OPEN WINDOW i104_w AT p_row,p_col WITH FORM "aco/42f/acoi104"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
      CALL i104_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW i104_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
FUNCTION i104_cs()
    CLEAR FORM
   INITIALIZE g_cnb.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        cnb01,cnb03,cnb04,cnb05,cnb06,cnb061,cnb07,cnb071,cnb08,cnb081,
        cnb09,cnb10,cnb11,cnb12,cnb13,cnb14,cnb15,cnb16,cnb17,cnb18,cnb19,
        cnbuser,cnbgrup,cnbmodu,cnbdate,cnbacti
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
       ON ACTION controlp
           CASE
              WHEN INFIELD(cnb05)
                CALL cl_init_qry_var()
                LET g_qryparam.state= "c"
                LET g_qryparam.form = "q_cna"
                LET g_qryparam.default1 = g_cnb.cnb05
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO cnb05
                NEXT FIELD cnb05
              WHEN INFIELD(cnb10)
                CALL cl_init_qry_var()
                LET g_qryparam.state= "c"
                LET g_qryparam.form = "q_azi"
                LET g_qryparam.default1 = g_cnb.cnb10
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO cnb10
                NEXT FIELD cnb10
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
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND cnbuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND cnbgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND cnbgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('cnbuser', 'cnbgrup')
    #End:FUN-980030
 
    LET g_sql = "SELECT cnb01 FROM cnb_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY cnb01"
    PREPARE i104_prepare FROM g_sql         # RUNTIME 編譯
    DECLARE i104_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i104_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM cnb_file WHERE ",g_wc CLIPPED
    PREPARE i104_precount FROM g_sql
    DECLARE i104_count CURSOR FOR i104_precount
END FUNCTION
 
FUNCTION i104_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i104_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i104_q()
            END IF
        ON ACTION next
            CALL i104_fetch('N')
        ON ACTION previous
            CALL i104_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
               CALL i104_u()
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
               CALL i104_x()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
               CALL i104_r()
            END IF
       ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                 CALL i104_copy()
            END IF
       ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth()
               THEN CALL i104_out()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#          EXIT MENU
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
        ON ACTION jump
            CALL i104_fetch('/')
        ON ACTION first
            CALL i104_fetch('F')
        ON ACTION last
            CALL i104_fetch('L')
        ON ACTION CONTROLG
            CALL cl_cmdask()
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
        #No.FUN-6A0168-------add--------str----
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
               IF g_cnb.cnb01 IS NOT NULL THEN
                  LET g_doc.column1 = "cnb01"
                  LET g_doc.value1 = g_cnb.cnb01
                  CALL cl_doc()
               END IF
           END IF
        #No.FUN-6A0168-------add--------end----
           LET g_action_choice = "exit"
           CONTINUE MENU
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE i104_cs
END FUNCTION
 
 
FUNCTION i104_a()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    MESSAGE ""
    CLEAR FORM                                     #清螢幕欄位內容
    INITIALIZE g_cnb.* LIKE cnb_file.*
    LET g_cnb01_t = NULL
    LET g_cnb_t.*=g_cnb.*
    LET g_cnb.cnb02 = 0				 # DEFAULT
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_cnb.cnbacti = 'Y'                  #有效的資料
        LET g_cnb.cnbuser = g_user		 #用戶
        LET g_cnb.cnboriu = g_user #FUN-980030
        LET g_cnb.cnborig = g_grup #FUN-980030
        LET g_cnb.cnbgrup = g_grup               #用戶所屬群
        LET g_cnb.cnbdate = g_today		 #更改日期
        CALL i104_i("a")                      #各欄位輸入
        IF INT_FLAG THEN                         #若按了DEL鍵
            INITIALIZE g_cnb.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_cnb.cnb01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO cnb_file VALUES(g_cnb.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
        #   CALL cl_err(g_cnb.cnb01,SQLCA.sqlcode,0) #No.TQC-660045
            CALL cl_err3("ins","cnb_file",g_cnb.cnb01,"",SQLCA.sqlcode,"","",1)  #No.TQC-660045
            CONTINUE WHILE
        ELSE
            LET g_cnb_t.* = g_cnb.*                # 保存上筆資料
            SELECT cnb01D INTO g_cnb.cnb01 FROM cnb_file
             WHERE cnb01 = g_cnb.cnb01
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION i104_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,          #No.FUN-680069 VARCHAR(1)
        l_flag          LIKE type_file.chr1,  		 #是否必要欄位有輸入        #No.FUN-680069 VARCHAR(1)
        l_n             LIKE type_file.num5          #No.FUN-680069 SMALLINT
 
    DISPLAY BY NAME g_cnb.cnbuser,g_cnb.cnbgrup,
        g_cnb.cnbdate, g_cnb.cnbacti
    INPUT BY NAME g_cnb.cnboriu,g_cnb.cnborig,
        g_cnb.cnb01,g_cnb.cnb03,g_cnb.cnb04,g_cnb.cnb05,g_cnb.cnb06,
        g_cnb.cnb061,g_cnb.cnb07,g_cnb.cnb071,g_cnb.cnb08,g_cnb.cnb081,
        g_cnb.cnb09,g_cnb.cnb10,g_cnb.cnb11,g_cnb.cnb12,g_cnb.cnb13,
        g_cnb.cnb14,g_cnb.cnb15,g_cnb.cnb16,g_cnb.cnb17,g_cnb.cnb18,
        g_cnb.cnb19
        WITHOUT DEFAULTS
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i104_set_entry(p_cmd)
           CALL i104_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
 
        AFTER FIELD cnb01			 #公司代碼
          IF g_cnb.cnb01 IS NOT NULL THEN
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND g_cnb.cnb01 != g_cnb01_t) THEN
                SELECT count(*) INTO l_n FROM cnb_file
                    WHERE cnb01 = g_cnb.cnb01
                IF l_n > 0 THEN                  # Duplicated
                    CALL cl_err(g_cnb.cnb01,-239,0)
                    LET g_cnb.cnb01 = g_cnb01_t
                    DISPLAY BY NAME g_cnb.cnb01
                    NEXT FIELD cnb01
                END IF
            END IF
          END IF
 
        AFTER FIELD cnb05                         #海關編碼
            IF NOT cl_null(g_cnb.cnb05) THEN
               CALL i104_cnb05('a')
               IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_cnb.cnb05,g_errno,0)
                  NEXT FIELD cnb05
               END IF
            END IF
 
        AFTER FIELD cnb10                         #幣別編碼
            IF NOT cl_null(g_cnb.cnb10) THEN
               CALL i104_cnb10('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_cnb.cnb10,g_errno,0)                 
                  NEXT FIELD cnb10
               END IF
            END IF
 
#TQC-990099 --begin--
        AFTER FIELD cnb09
            IF NOT cl_null(g_cnb.cnb09) THEN
               IF g_cnb.cnb09 < 0 THEN
                  CALL cl_err('','aec-020',0)
                  NEXT FIELD cnb09
               END IF 
            END IF     
 
        AFTER FIELD cnb11
          IF NOT cl_null(g_cnb.cnb11) THEN
             IF g_cnb.cnb11 < 0 THEN
                CALL cl_err('','aec-020',0)
                NEXT FIELD cnb11
             END IF
          END IF
 
 
        AFTER FIELD cnb12
           IF NOT cl_null(g_cnb.cnb12) THEN
             IF g_cnb.cnb12 < 0 THEN
                CALL cl_err('','aec-020',0)
                NEXT FIELD cnb12
             END IF
            END IF
#TQC-990099 --end--
 
 
       AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
            LET l_flag='N'
            IF INT_FLAG THEN EXIT INPUT  END IF
            IF cl_null(g_cnb.cnb01) THEN
                LET l_flag='Y'
                DISPLAY BY NAME g_cnb.cnb01
            END IF
            IF l_flag='Y' THEN
               CALL cl_err('','9033',0)
               NEXT FIELD cnb01
            END IF
 
        #MOD-650015 --start 
       #ON ACTION CONTROLO                        # 沿用所有欄位
       #   IF INFIELD(cnb01) THEN
       #      LET g_cnb.* = g_cnb_t.*
       #      DISPLAY BY NAME g_cnb.*
       #      NEXT FIELD cnb01
       #   END IF
        #MOD-650015 --end
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON ACTION controlp
           CASE
              WHEN INFIELD(cnb05)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_cna"
                LET g_qryparam.default1 = g_cnb.cnb05
                CALL cl_create_qry() RETURNING g_cnb.cnb05
#                CALL FGL_DIALOG_SETBUFFER( g_cnb.cnb05 )
                DISPLAY BY NAME g_cnb.cnb05
                NEXT FIELD cnb05
              WHEN INFIELD(cnb10)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_azi"
                LET g_qryparam.default1 = g_cnb.cnb10
                CALL cl_create_qry() RETURNING g_cnb.cnb10
#                CALL FGL_DIALOG_SETBUFFER( g_cnb.cnb10 )
                DISPLAY BY NAME g_cnb.cnb10
                NEXT FIELD cnb10
              OTHERWISE EXIT CASE
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
 
FUNCTION i104_cnb10(p_cmd)  #幣別
    DEFINE l_azi02   LIKE azi_file.azi02,
           l_aziacti LIKE azi_file.aziacti,
           p_cmd     LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT azi02,aziacti
      INTO l_azi02,l_aziacti
      FROM azi_file WHERE azi01 = g_cnb.cnb10
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3008'
         WHEN l_aziacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION i104_cnb05(p_cmd)  #
    DEFINE l_cna02   LIKE cna_file.cna02,
           l_cnaacti LIKE cna_file.cnaacti,
           p_cmd     LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
    LET g_errno = ' '
    SELECT cna02,cnaacti INTO l_cna02,l_cnaacti
      FROM cna_file WHERE cna01 = g_cnb.cnb05
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aco-016'
         WHEN l_cnaacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION i104_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_cnb.* TO NULL              #No.FUN-6A0168
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i104_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        INITIALIZE g_cnb.* TO NULL
        RETURN
    END IF
    OPEN i104_count
    FETCH i104_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i104_cs                            # 從DB生成合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cnb.cnb01,SQLCA.sqlcode,0)
        INITIALIZE g_cnb.* TO NULL
    ELSE
        CALL i104_fetch('F')                # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i104_fetch(p_flcnb)
    DEFINE
        p_flcnb         LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)
        l_abso          LIKE type_file.num10         #No.FUN-680069 INTEGER
 
    CASE p_flcnb
        WHEN 'N' FETCH NEXT     i104_cs INTO g_cnb.cnb01
        WHEN 'P' FETCH PREVIOUS i104_cs INTO g_cnb.cnb01
        WHEN 'F' FETCH FIRST    i104_cs INTO g_cnb.cnb01
        WHEN 'L' FETCH LAST     i104_cs INTO g_cnb.cnb01
        WHEN '/'
         #CKP3
         IF (NOT mi_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR g_jump #CKP3
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
#                  CONTINUE PROMPT
 
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
         #CKP3
         END IF
         FETCH ABSOLUTE g_jump i104_cs INTO g_cnb.cnb01
         LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        LET g_msg = g_cnb.cnb01 CLIPPED
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        INITIALIZE g_cnb.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flcnb
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump #CKP3
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_cnb.* FROM cnb_file            # 重讀DB,因TEMP有不被更新特性
       WHERE cnb01 = g_cnb.cnb01
    IF SQLCA.sqlcode THEN
        LET g_msg = g_cnb.cnb01 CLIPPED
      # CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.TQC-660045
        CALL cl_err3("sel","cnb_file",g_msg,"",SQLCA.sqlcode,"","",1)      #No.TQC-660045
    ELSE
#       LET g_data_owner = g_cnb.cnbuser
#       LET g_data_group = g_cnb.cnbgrup
        CALL i104_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i104_show()
    LET g_cnb_t.* = g_cnb.*
    DISPLAY BY NAME g_cnb.cnboriu,g_cnb.cnborig,
            g_cnb.cnb01,g_cnb.cnb03,g_cnb.cnb04,g_cnb.cnb05,
            g_cnb.cnb06,g_cnb.cnb061,g_cnb.cnb07,g_cnb.cnb071,
            g_cnb.cnb08,g_cnb.cnb081,g_cnb.cnb09,g_cnb.cnb10,
            g_cnb.cnb11,g_cnb.cnb12,g_cnb.cnb13,g_cnb.cnb14,
            g_cnb.cnb15,g_cnb.cnb16,g_cnb.cnb17,g_cnb.cnb18,
            g_cnb.cnb19,g_cnb.cnbacti,g_cnb.cnbuser,g_cnb.cnbmodu,
            g_cnb.cnbdate,g_cnb.cnbgrup
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i104_u()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_cnb.cnb01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_cnb.cnbacti ='N' THEN                     #檢查資料是否為無效
        CALL cl_err(g_cnb.cnb01,'mfg1000',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_cnb01_t = g_cnb.cnb01
    BEGIN WORK
 
    OPEN i104_cl USING g_cnb.cnb01
    IF STATUS THEN
       CALL cl_err("OPEN i104_cl:", STATUS, 1)
       CLOSE i104_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i104_cl INTO g_cnb.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cnb.cnb01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_cnb.cnbmodu = g_user                   #更改者
    LET g_cnb.cnbdate = g_today                  #更改日期
    CALL i104_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i104_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_cnb.* = g_cnb_t.*
            CALL i104_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE cnb_file SET cnb_file.* = g_cnb.*    # 更新DB
            WHERE cnb01 = g_cnb.cnb01               # COLAUTH?
        IF SQLCA.sqlcode THEN
           LET g_msg = g_cnb.cnb01 CLIPPED
        #  CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.TQC-660045
           CALL cl_err3("upd","cnb_file",g_msg,"",SQLCA.sqlcode,"","",1)   #No.TQC-660045
           CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i104_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i104_x()
    DEFINE
        l_chr LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_cnb.cnb01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i104_cl USING g_cnb.cnb01
    IF STATUS THEN
       CALL cl_err("OPEN i104_cl:", STATUS, 1)
       CLOSE i104_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i104_cl INTO g_cnb.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cnb.cnb01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i104_show()
    IF cl_exp(0,0,g_cnb.cnbacti) THEN
        LET g_chr = g_cnb.cnbacti
        IF g_cnb.cnbacti = 'Y' THEN
           LET g_cnb.cnbacti = 'N'
        ELSE
           LET g_cnb.cnbacti = 'Y'
        END IF
        UPDATE cnb_file
            SET cnbacti = g_cnb.cnbacti,
                cnbmodu = g_user, cnbdate = g_today
            WHERE cnb01 = g_cnb.cnb01
        IF SQLCA.SQLERRD[3] = 0 THEN
        #   CALL cl_err(g_cnb.cnb01,SQLCA.sqlcode,0) #No.TQC-660045
            CALL cl_err3("udp","cnb_file",g_cnb.cnb01,"",SQLCA.sqlcode,"","",1)     #No.TQC-660045  
            LET g_cnb.cnbacti = g_chr
        END IF
        DISPLAY BY NAME g_cnb.cnbacti
    END IF
    CLOSE i104_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i104_r()
    DEFINE
        l_chr LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_cnb.cnb01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i104_cl USING g_cnb.cnb01
    IF STATUS THEN
       CALL cl_err("OPEN i104_cl:", STATUS, 1)
       CLOSE i104_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i104_cl INTO g_cnb.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cnb.cnb01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i104_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "cnb01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_cnb.cnb01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM cnb_file WHERE cnb01 = g_cnb.cnb01
       CLEAR FORM
         #CKP3
         OPEN i104_count
         #FUN-B50062-add-start--
         IF STATUS THEN
            CLOSE i104_cs
            CLOSE i104_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         FETCH i104_count INTO g_row_count
         #FUN-B50062-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i104_cs
            CLOSE i104_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i104_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i104_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL i104_fetch('/')
         END IF
    END IF
    CLOSE i104_cl
    INITIALIZE g_cnb.* TO NULL
    COMMIT WORK
END FUNCTION
 
FUNCTION i104_copy()
    DEFINE
        l_n             LIKE type_file.num5,          #No.FUN-680069 SMALLINT
        l_newno,l_oldno LIKE cnb_file.cnb01
 
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_cnb.cnb01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
   #DISPLAY "" AT 1,1
    LET g_before_input_done = FALSE
    CALL i104_set_entry("a")
    CALL i104_set_no_entry("a")
    LET g_before_input_done = TRUE
 
    INPUT l_newno FROM cnb01
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i104_set_entry("a")
           CALL i104_set_no_entry("a")
           LET g_before_input_done = TRUE
 
        AFTER FIELD cnb01
          IF l_newno IS NOT NULL THEN
            SELECT count(*) INTO g_cnt FROM cnb_file
                WHERE cnb01 = l_newno
            IF g_cnt > 0 THEN
                CALL cl_err(l_newno,-239,0)
                NEXT FIELD cnb01
            END IF
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
        DISPLAY BY NAME g_cnb.cnb01
        RETURN
    END IF
    DROP TABLE x
    SELECT * FROM cnb_file
        WHERE cnb01 = g_cnb.cnb01
        INTO TEMP x
    UPDATE x
        SET cnb01   = l_newno,     #資料鍵值
            cnbuser = g_user,      #資料所有者
            cnbgrup = g_grup,      #資料所有者所屬群
            cnbmodu = NULL,        #
            cnbdate = g_today,     #資料建立日期
            cnbacti = 'Y'          #有效資料
    INSERT INTO cnb_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
    #   CALL cl_err(g_cnb.cnb01,SQLCA.sqlcode,0) #No.TQC-660045
        CALL cl_err3("ins","cnb_file",g_cnb.cnb01,"",SQLCA.sqlcode,"","",1)     #No.TQC-660045
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K'
        LET l_oldno = g_cnb.cnb01
        SELECT cnb_file.* INTO g_cnb.* FROM cnb_file
                       WHERE cnb01 = l_newno
        CALL i104_u()
        #SELECT cnb_file.* INTO g_cnb.* FROM cnb_file  #FUN-C30027
        #               WHERE cnb01 = l_oldno          #FUN-C30027
    END IF
    CALL i104_show()
END FUNCTION
 
FUNCTION i104_out()
    DEFINE
        l_i             LIKE type_file.num5,          #No.FUN-680069 SMALLINT
        sr RECORD       LIKE cnb_file.*,
        l_name          LIKE type_file.chr20,        #No.FUN-680069 VARCHAR(20) # External(Disk) file name
        l_za05          LIKE cob_file.cob01,         #No.FUN-680069 VARCHAR(40)
        l_chr           LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
    DEFINE
        l_cna02         LIKE cna_file.cna02,         #No.FUN-770006
        l_cnbacti       LIKE cnb_file.cnbacti,       #No.FUN-770006
        l_sql           LIKE type_file.chr1000       #NO.FUN-770006
 
    CALL cl_del_data(l_table)                        #No.FUN-770006
 
    IF cl_null(g_wc) AND NOT cl_null(g_cnb.cnb01) THEN
       LET g_wc=" cnb01='",g_cnb.cnb01,"'"
    END IF
 
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
#   CALL cl_outnam('acoi104') RETURNING l_name      #No.FUN-770006
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql = " SELECT * FROM cnb_file ",         # 組合出 SQL 指令
                " WHERE ",g_wc CLIPPED
    PREPARE i104_p1 FROM g_sql                      # RUNTIME 編譯
    DECLARE i104_co CURSOR FOR i104_p1
 
#   START REPORT i104_rep TO l_name                 #No.FUN-770006
 
    FOREACH i104_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
#       OUTPUT TO REPORT i104_rep(sr.*)             #No.FUN-770006
#No.FUN-770006 --start--
        SELECT cna02 INTO l_cna02 FROM cna_file           
            WHERE cna01=sr.cnb05        
            IF SQLCA.sqlcode THEN       
               LET l_cna02 = ' '        
            END IF   
        IF sr.cnbacti = 'N' THEN 
           LET l_cnbacti = '*'
        ELSE
           LET l_cnbacti = ' '
        END IF
        EXECUTE insert_prep USING l_cnbacti,sr.cnb01,sr.cnb06,sr.cnb07,
                                  sr.cnb03,sr.cnb05,l_cna02
#No.FUN-770006 --end--
    END FOREACH
 
#   FINISH REPORT i104_rep                          #No.FUN-770006
 
    CLOSE i104_co
    ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)              #No.FUN-770006
#No.FUN-770006 --start--
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(g_wc,'cnb01,cnb03,cnb04,cnb05,cnb06,cnb061,cnb07,cnb071,cnb08,cnb081,         
                     cnb09,cnb10,cnb11,cnb12,cnb13,cnb14,cnb15,cnb16,cnb17,cnb18,cnb19,      
                     cnbuser,cnbgrup,cnbmodu,cnbdate,cnbacti')
            RETURNING g_str
    END IF
    LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
    CALL cl_prt_cs3('acoi104','acoi104',l_sql,g_str)
#No.FUN-770006 --end--
END FUNCTION
#No.FUN-770006 --start-- mark
{REPORT i104_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)
        l_cna02         LIKE cna_file.cna02,
        sr RECORD       LIKE cnb_file.*,
        l_chr           LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.cnb01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
                  LET g_pageno = g_pageno + 1
                  LET pageno_total = PAGENO USING '<<<',"/pageno"
                  PRINT g_head CLIPPED,pageno_total
            PRINT COLUMN((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            PRINT ' '
            PRINT g_dash[1,g_len]
            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
                  g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED
            PRINT g_dash1
            LET l_trailer_sw = 'y'
        ON EVERY ROW
           SELECT cna02 INTO l_cna02 FROM cna_file
            WHERE cna01=sr.cnb05
            IF SQLCA.sqlcode THEN
               LET l_cna02 = ' '
            END IF
            IF sr.cnbacti = 'N' THEN PRINT COLUMN g_c[31],'*'; END IF
            PRINT COLUMN g_c[32],sr.cnb01,
                  COLUMN g_c[33],sr.cnb06,
                  COLUMN g_c[34],sr.cnb07,
                  COLUMN g_c[35],sr.cnb03,
                  COLUMN g_c[36],sr.cnb05,
                  COLUMN g_c[37],l_cna02
        ON LAST ROW
            IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
               THEN PRINT g_dash[1,g_len]
                   #IF g_wc[001,080] > ' ' THEN
		   #   PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
                   #IF g_wc[071,140] > ' ' THEN
		   #   PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
                   #IF g_wc[141,210] > ' ' THEN
		   #   PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
                    CALL cl_prt_pos_wc(g_wc) #TQC-630166
            END IF
            PRINT g_dash[1,g_len]
            LET l_trailer_sw = 'n'
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT}
#No.FUN-770006 --end--
FUNCTION i104_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("cnb01",TRUE)
   END IF
END FUNCTION
 
FUNCTION i104_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("cnb01",FALSE)
 
   END IF
END FUNCTION
 
