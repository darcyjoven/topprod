# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: apmi204.4gl
# Descriptions...: 送貨/帳單地址資料維護作業
# Date & Author..: 91/09/05 By TED
# Modify.........: No.FUN-4C0056 04/12/08 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.FUN-4C0095 05/01/24 By Mandy 報表轉XML
# Modify.........: No.TQC-5B0212 05/12/01 By kevin 刪除時不清變數
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.FUN-680136 06/08/31 By Jackho 欄位類型修改
# Modify.........: No.TQC-6A0090 06/11/07 By baogui 表頭多行空白
# Modify.........: No.FUN-6A0162 06/11/11 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.TQC-6B0088 06/11/16 By day 狀態頁要作顯示
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-760194 07/08/29 By claire 調整key值抓取只有一個
# Modify.........: No.FUN-7B0101 07/11/19 By Pengu 調整為CR報表
# Modify.........: No.TQC-870018 08/07/11 By Jerry 修正若程式寫法為SELECT .....寫法會出現ORA-600的錯誤
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.TQC-950181 09/05/27 By chenyu 無效資料不可以刪除
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50063 11/06/01 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:TQC-B80234 11/08/30 By guoch 资料建立者，资料建立部门查询时无法下条件
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_pme   RECORD LIKE pme_file.*,		#送貨/帳單地址資料檔
    g_pme_t RECORD LIKE pme_file.*,		#送貨/帳單地址資料檔
    g_pme01_t LIKE pme_file.pme01,		#地址代號
    g_pme02_t LIKE pme_file.pme02,		#地址代號
    g_wc,g_sql         STRING,
    g_wc2              STRING                   #No.FUN-7B0101 add
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   STRING
DEFINE g_str                 STRING       #No.FUN-7B0101 add
DEFINE   g_chr           LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680136 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-680136 SMALLINT
DEFINE   g_msg           LIKE ze_file.ze03       #No.FUN-680136 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10    #No.FUN-680136 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10    #No.FUN-680136 INTEGER
DEFINE   g_jump          LIKE type_file.num10    #No.FUN-680136 INTEGER
DEFINE   g_no_ask       LIKE type_file.num5     #No.FUN-680136 SMALLINT
 
MAIN
    OPTIONS					#改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT				#擷取中斷鍵,由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time

    INITIALIZE g_pme.* TO NULL
    INITIALIZE g_pme_t.* TO NULL
 
    LET g_forupd_sql = " SELECT * FROM pme_file WHERE pme01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i204_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    OPEN WINDOW i204_w WITH FORM "apm/42f/apmi204"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    LET g_action_choice=""
    CALL i204_menu()
 
    CLOSE WINDOW i204_w

    CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION i204_cs()
    CLEAR FORM
    INITIALIZE g_pme.* TO NULL      #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        pme01,pme02,pme031,pme032,pme033,pme034,pme035,
        pmeuser,pmegrup,pmemodu,pmedate,pmeacti,
        pmeoriu,pmeorig   #TQC-B80234  add
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
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
    #        LET g_wc = g_wc clipped," AND pmeuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND pmegrup LIKE '",g_grup CLIPPED,"%'"
        #CHI-8A0001 寫ora
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND pmegrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pmeuser', 'pmegrup')
    #End:FUN-980030
 
   #TQC-760194 modify
   #LET g_sql = "SELECT pme01,pme02 FROM pme_file ", # 組合出 SQL 指令 #TQC-870018
    LET g_sql = "SELECT pme01 FROM pme_file ", # 組合出 SQL 指令
   #TQC-760194 modify
        " WHERE ",g_wc CLIPPED, " ORDER BY pme01"
    PREPARE i204_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i204_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i204_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM pme_file WHERE ",g_wc CLIPPED
    PREPARE i204_precount FROM g_sql
    DECLARE i204_count CURSOR FOR i204_precount
END FUNCTION
 
FUNCTION i204_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i204_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i204_q()
            END IF
        ON ACTION next
            CALL i204_fetch('N')
        ON ACTION previous
            CALL i204_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i204_u()
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL i204_x()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i204_r()
            END IF
       ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                 CALL i204_copy()
            END IF
       ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth()
               THEN CALL i204_out()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#           EXIT MENU
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL i204_fetch('/')
        ON ACTION first
            CALL i204_fetch('F')
        ON ACTION last
            CALL i204_fetch('L')

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            LET g_action_choice = "exit"
            EXIT MENU
 
         ON ACTION related_document     #No.MOD-470518
            LET g_action_choice="related_document"
            IF cl_chk_act_auth() THEN
               IF g_pme.pme01 IS NOT NULL THEN
                  LET g_doc.column1 = "pme01"
                  LET g_doc.value1 = g_pme.pme01
                  CALL cl_doc()
               END IF
            END IF
    END MENU
    CLOSE i204_cs
END FUNCTION
 
 
FUNCTION i204_a()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_pme.* LIKE pme_file.*
    LET g_wc = NULL
    LET g_pme01_t = NULL
    LET g_pme_t.*=g_pme.*
    LET g_pme.pme02 = 0				 # DEFAULT
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_pme.pmeacti = 'Y'                  #有效的資料
        LET g_pme.pmeuser = g_user		 #使用者
        LET g_pme.pmeoriu = g_user #FUN-980030
        LET g_pme.pmeorig = g_grup #FUN-980030
        LET g_pme.pmegrup = g_grup               #使用者所屬群
        LET g_pme.pmedate = g_today		 #更改日期
        CALL i204_i("a")                      #各欄位輸入
        IF INT_FLAG THEN                         #若按了DEL鍵
            INITIALIZE g_pme.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_pme.pme01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO pme_file VALUES(g_pme.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_pme.pme01,SQLCA.sqlcode,0)   #No.FUN-660129
            CALL cl_err3("ins","pme_file",g_pme.pme01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
            CONTINUE WHILE
        ELSE
            LET g_pme_t.* = g_pme.*                # 保存上筆資料
            SELECT pme01,pme02 INTO g_pme.pme01,g_pme.pme02 FROM pme_file
                WHERE pme01 = g_pme.pme01      # TQC-760194 mark AND pme02 = g_pme.pme02
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i204_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,         #No.FUN-680136 VARCHAR(1)
        l_flag          LIKE type_file.chr1,  	     #是否必要欄位有輸入        #No.FUN-680136 VARCHAR(1)
        l_n             LIKE type_file.num5          #No.FUN-680136 SMALLINT
 
    DISPLAY BY NAME g_pme.pmeuser,g_pme.pmegrup,
        g_pme.pmedate, g_pme.pmeacti
    INPUT BY NAME g_pme.pmeoriu,g_pme.pmeorig,
        g_pme.pme01,g_pme.pme02,g_pme.pme031,g_pme.pme032,
        g_pme.pme033,g_pme.pme034,g_pme.pme035
        WITHOUT DEFAULTS
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i204_set_entry(p_cmd)
           CALL i204_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
 
        AFTER FIELD pme01			 #地址代號
          IF g_pme.pme01 IS NOT NULL THEN
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND g_pme.pme01 != g_pme01_t) THEN
                SELECT count(*) INTO l_n FROM pme_file
                    WHERE pme01 = g_pme.pme01
                IF l_n > 0 THEN                  # Duplicated
                    CALL cl_err(g_pme.pme01,-239,0)
                    LET g_pme.pme01 = g_pme01_t
                    DISPLAY BY NAME g_pme.pme01
                    NEXT FIELD pme01
                END IF
            END IF
          END IF
 
        AFTER FIELD pme02                       #資料性質
            IF g_pme.pme02 NOT MATCHES '[012]' OR g_pme.pme02 =' '
               OR g_pme.pme02 IS NULL THEN
                LET g_pme.pme02=g_pme02_t
                DISPLAY BY NAME g_pme.pme02
               CALL cl_err(g_pme.pme02,'mfg3325',0)
               NEXT FIELD pme02
            END IF
            LET g_pme02_t=g_pme.pme02
 
    AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
       LET g_pme.pmeuser = s_get_data_owner("pme_file") #FUN-C10039
       LET g_pme.pmegrup = s_get_data_group("pme_file") #FUN-C10039
       IF INT_FLAG THEN
          EXIT INPUT
       END IF
       IF g_pme.pme02 NOT MATCHES '[012]' THEN
          NEXT FIELD pme02
       END IF
       
       #MOD-650015 --start 
       #ON ACTION CONTROLO                        # 沿用所有欄位
       #     IF INFIELD(pme01) THEN
       #         LET g_pme.* = g_pme_t.*
       #         DISPLAY BY NAME g_pme.*
       #         NEXT FIELD pme01
       #     END IF
       #MOD-650015 --end
 
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
 
FUNCTION i204_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_pme.* TO NULL              #No.FUN-6A0162
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i204_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        INITIALIZE g_pme.* TO NULL
        RETURN
    END IF
    OPEN i204_count
    FETCH i204_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i204_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pme.pme01,SQLCA.sqlcode,0)
        INITIALIZE g_pme.* TO NULL
    ELSE
        CALL i204_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i204_fetch(p_flpme)
    DEFINE
        p_flpme          LIKE type_file.chr1           #No.FUN-680136 VARCHAR(1)
 
    CASE p_flpme
        WHEN 'N' FETCH NEXT     i204_cs INTO
				g_pme.pme01  #TQC-760194 modify
        WHEN 'P' FETCH PREVIOUS i204_cs INTO
				g_pme.pme01  #TQC-760194 modify
        WHEN 'F' FETCH FIRST    i204_cs INTO
				g_pme.pme01  #TQC-760194 modify
        WHEN 'L' FETCH LAST     i204_cs INTO
				g_pme.pme01  #TQC-760194 modify
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
            FETCH ABSOLUTE g_jump i204_cs INTO
			          g_pme.pme01 #TQC-760194 modify
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        LET g_msg = g_pme.pme01 CLIPPED,'+',g_pme.pme02 CLIPPED
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        INITIALIZE g_pme.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flpme
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_pme.* FROM pme_file            # 重讀DB,因TEMP有不被更新特性
       WHERE pme01=g_pme.pme01
    IF SQLCA.sqlcode THEN
       LET g_msg = g_pme.pme01 CLIPPED,'+',g_pme.pme02 CLIPPED
#      CALL cl_err(g_msg,SQLCA.sqlcode,0)   #No.FUN-660129
       CALL cl_err3("sel","pme_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
#      INITIALIZE g_pme.* TO NULL
    ELSE
       LET g_data_owner = g_pme.pmeuser      #FUN-4C0056
       LET g_data_group = g_pme.pmegrup      #FUN-4C0056
       CALL i204_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i204_show()
    LET g_pme_t.* = g_pme.*
    DISPLAY BY NAME g_pme.pme01,g_pme.pme02,g_pme.pme031, g_pme.pmeoriu,g_pme.pmeorig,
                    g_pme.pme032,g_pme.pme033,g_pme.pme034,g_pme.pme035
    #No.TQC-6B0088--begin
    DISPLAY BY NAME g_pme.pmeuser,g_pme.pmegrup,g_pme.pmemodu,
                    g_pme.pmedate, g_pme.pmeacti 
    #No.TQC-6B0088--end  
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i204_u()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_pme.pme01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_pme.pmeacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_pme.pme01,'mfg1000',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_pme01_t = g_pme.pme01
    LET g_pme02_t = g_pme.pme02
    BEGIN WORK
 
    OPEN i204_cl USING g_pme.pme01
    IF STATUS THEN
       CALL cl_err("OPEN i204_cl:", STATUS, 1)
       CLOSE i204_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i204_cl INTO g_pme.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pme.pme01,SQLCA.sqlcode,0)
        ROLLBACK WORK
        RETURN
    END IF
    LET g_pme.pmemodu = g_user                   #修改者
    LET g_pme.pmedate = g_today                  #修改日期
    CALL i204_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i204_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_pme.* = g_pme_t.*
            CALL i204_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE pme_file SET pme_file.* = g_pme.*    # 更新DB
            WHERE pme01=g_pme.pme01               # COLAUTH?
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
           LET g_msg = g_pme.pme01 CLIPPED,'+',g_pme.pme02 CLIPPED
#          CALL cl_err(g_msg,SQLCA.sqlcode,0)   #No.FUN-660129
           CALL cl_err3("upd","pme_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
           CONTINUE WHILE
        ELSE
           LET g_pme_t.* = g_pme.*# 保存上筆資料
           SELECT pme01,pme02 INTO g_pme.pme01,g_pme.pme02 FROM pme_file
            WHERE pme01 = g_pme.pme01
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i204_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i204_x()
    DEFINE
        l_chr LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_pme.pme01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i204_cl USING g_pme.pme01
    IF STATUS THEN
       CALL cl_err("OPEN i204_cl:", STATUS, 1)
       CLOSE i204_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i204_cl INTO g_pme.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pme.pme01,SQLCA.sqlcode,0)
        ROLLBACK WORK
        RETURN
    END IF
    CALL i204_show()
    IF cl_exp(0,0,g_pme.pmeacti) THEN
        LET g_chr = g_pme.pmeacti
        IF g_pme.pmeacti = 'Y' THEN
           LET g_pme.pmeacti = 'N'
        ELSE
           LET g_pme.pmeacti = 'Y'
        END IF
        UPDATE pme_file
            SET pmeacti = g_pme.pmeacti,
               pmemodu = g_user, pmedate = g_today
            WHERE pme01=g_pme.pme01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#           CALL cl_err(g_pme.pme01,SQLCA.sqlcode,0)   #No.FUN-660129
            CALL cl_err3("upd","pme_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
            LET g_pme.pmeacti = g_chr
        END IF
        DISPLAY BY NAME g_pme.pmeacti
    END IF
    CLOSE i204_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i204_r()
    DEFINE
        l_chr LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_pme.pme01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i204_cl USING g_pme.pme01
    IF STATUS THEN
       CALL cl_err("OPEN i204_cl:", STATUS, 1)
       CLOSE i204_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i204_cl INTO g_pme.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pme.pme01,SQLCA.sqlcode,0)
        ROLLBACK WORK
        RETURN
    END IF
    #No.TQC-950181 add --begin
    IF g_pme.pmeacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_pme.pme01,'mfg1000',0)
       RETURN
    END IF
    #No.TQC-950181 add --end
    CALL i204_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "pme01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_pme.pme01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
            DELETE FROM pme_file WHERE pme01=g_pme.pme01
            CLEAR FORM
         OPEN i204_count
         #FUN-B50063-add-start--
         IF STATUS THEN
            CLOSE i204_cs
            CLOSE i204_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end-- 
         FETCH i204_count INTO g_row_count
         #FUN-B50063-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i204_cs
            CLOSE i204_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i204_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i204_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE
            CALL i204_fetch('/')
         END IF
    END IF
    CLOSE i204_cl
#   INITIALIZE g_pme.* TO NULL #No.TQC-5B0212
    COMMIT WORK
END FUNCTION
 
FUNCTION i204_copy()
    DEFINE
        l_n             LIKE type_file.num5,          #No.FUN-680136 SMALLINT
        l_newno,l_oldno LIKE pme_file.pme01
 
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_pme.pme01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
    LET g_before_input_done = FALSE
    CALL i204_set_entry("a")
    CALL i204_set_no_entry("a")
 
    INPUT l_newno FROM pme01
 
        AFTER FIELD pme01
          IF l_newno IS NOT NULL THEN
            SELECT count(*) INTO g_cnt FROM pme_file
                WHERE pme01 = l_newno
            IF g_cnt > 0 THEN
                CALL cl_err(l_newno,-239,0)
                NEXT FIELD pme01
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
        DISPLAY BY NAME g_pme.pme01
        RETURN
    END IF
    DROP TABLE x
    SELECT * FROM pme_file
        WHERE pme01=g_pme.pme01
        INTO TEMP x
    UPDATE x
        SET pme01   = l_newno,     #資料鍵值
            pmeuser = g_user,      #資料所有者
            pmegrup = g_grup,      #資料所有者所屬群
            pmemodu = NULL,        #
            pmedate = g_today,     #資料建立日期
            pmeacti = 'Y'          #有效資料
    INSERT INTO pme_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_pme.pme01,SQLCA.sqlcode,0)   #No.FUN-660129
        CALL cl_err3("sel","pme_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K'
        LET l_oldno = g_pme.pme01
        SELECT pme_file.* INTO g_pme.* FROM pme_file
                       WHERE pme01 = l_newno
        CALL i204_u()
        #SELECT pme_file.* INTO g_pme.* FROM pme_file  #FUN-C80046
        #               WHERE pme01 = l_oldno          #FUN-C80046
    END IF
    CALL i204_show()
END FUNCTION
 
FUNCTION i204_out()
    DEFINE
        l_i             LIKE type_file.num5,         #No.FUN-680136 SMALLINT
        sr              RECORD LIKE pme_file.*,
        l_name          LIKE type_file.chr20,        # External(Disk) file name #No.FUN-680136 VARCHAR(20)
        l_za05          LIKE za_file.za05,           #No.FUN-680136 VARCHAR(40)
        l_chr           LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
    IF cl_null(g_wc) THEN
        LET g_wc=" pme01='",g_pme.pme01,"'"
    END IF
    CALL cl_wait()
   #CALL cl_outnam('apmi204') RETURNING l_name                #No.FUN-7B0101 mark
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang  
    LET g_sql = " SELECT * ",
	        " FROM pme_file ",          # 組合出 SQL 指令
                " WHERE ",g_wc CLIPPED
#----------------------------No.FUN-7B0101 modify---------------------
#   PREPARE i204_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE i204_co                         # CURSOR
#       CURSOR WITH HOLD FOR i204_p1
 
#   START REPORT i204_rep TO l_name
 
#   FOREACH i204_co INTO sr.*
#       IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1)
#           EXIT FOREACH
#       END IF
#       OUTPUT TO REPORT i204_rep(sr.*)
#   END FOREACH
 
#   FINISH REPORT i204_rep
 
#   CLOSE i204_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
    LET g_str=''
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog 
    IF g_zz05='Y' THEN 
        CALL cl_wcchp(g_wc2,'pme01,pme02,pme031,pme032,pme033,pme034,pme035,pmeacti')
        RETURNING g_wc2
    END IF
    LET g_str=g_wc2
    CALL cl_prt_cs1("apmi204","apmi204",g_sql,g_str)
#----------------------------No.FUN-7B0101 end--------------------
END FUNCTION
 
#---------------------------No.FUN-7B0101 mark--------------------------------
#REPORT i204_rep(sr)
#   DEFINE
#       l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680136 VARCHAR(1)
#       sr              RECORD LIKE pme_file.*,
#       l_chr           LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.pme01
 
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#           LET g_pageno = g_pageno + 1
#           LET pageno_total = PAGENO USING '<<<',"/pageno"
#           PRINT g_head CLIPPED,pageno_total
#  #        PRINT                             #TQC-6A0090
#           PRINT g_dash
#           PRINT g_x[31],g_x[32],g_x[33],g_x[34]
#           PRINT g_dash1
#           LET l_trailer_sw = 'y'
#       ON EVERY ROW
#           IF sr.pmeacti = 'N' THEN
#               PRINT COLUMN g_c[31],'*';
#           END IF
#               PRINT COLUMN g_c[31],' ';
#           PRINT COLUMN g_c[32],sr.pme01;
#           IF sr.pme02 = 0 THEN PRINT COLUMN g_c[33],sr.pme02,':',g_x[14] CLIPPED; END IF
#           IF sr.pme02 = 1 THEN PRINT COLUMN g_c[33],sr.pme02,':',g_x[15] CLIPPED; END IF
#           IF sr.pme02 = 2 THEN PRINT COLUMN g_c[33],sr.pme02,':',g_x[16] CLIPPED; END IF
#           IF sr.pme02 NOT MATCHES '[012]' THEN PRINT COLUMN 17,':   '; END IF
#           IF NOT cl_null(sr.pme031) THEN
#              PRINT COLUMN g_c[34],sr.pme031
#           END IF
#           IF NOT cl_null(sr.pme032) THEN
#              PRINT COLUMN g_c[34],sr.pme032
#           END IF
#           IF NOT cl_null(sr.pme033) THEN
#              PRINT COLUMN g_c[34],sr.pme033
#           END IF
#           IF NOT cl_null(sr.pme034) THEN
#              PRINT COLUMN g_c[34],sr.pme034
#           END IF
#           IF NOT cl_null(sr.pme035) THEN
#              PRINT COLUMN g_c[34],sr.pme035
#           END IF
#           PRINT  " "
#       ON LAST ROW
#           IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
#              THEN PRINT g_dash
#NO.TQC-630166 start-
#                    IF g_wc[001,080] > ' ' THEN
#		       PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
#                    IF g_wc[071,140] > ' ' THEN
#		       PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
#                    IF g_wc[141,210] > ' ' THEN
#		       PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
#                    CALL cl_prt_pos_wc(g_wc)
#NO.TQC-630166 end--
#           END IF
#           PRINT g_dash
#           LET l_trailer_sw = 'n'
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash[1,g_len]
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#---------------------------No.FUN-7B0101 end--------------------------------
 
FUNCTION i204_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("pme01",TRUE)
   END IF
END FUNCTION
 
FUNCTION i204_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("pme01",FALSE)
   END IF
END FUNCTION
 

