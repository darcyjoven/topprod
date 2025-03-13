# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: acoi103.4gl
# Descriptions...: 海關基本資料維護作業
# Date & Author..: 00/07/24 Carol
# Modify.........: No.FUN-510042 05/01/20 By pengu 報表轉XML
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
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50062 11/05/18 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_cna   RECORD LIKE cna_file.*,		#海關基本資料檔
    g_cna_t RECORD LIKE cna_file.*,		#海關基本資料檔
    g_cna01_t           LIKE cna_file.cna01,              #海關代號
   #g_wc,g_sql          STRING #TQC-630166        #No.FUN-680069
    g_wc,g_sql          STRING    #TQC-630166        #No.FUN-680069
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL        #No.FUN-680069
 
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680069 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(72)
 
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680069 INTEGER
#CKP3
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680069 SMALLINT
DEFINE   g_str          STRING                       #No.FUN-770006
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
 
 
    INITIALIZE g_cna.* TO NULL
    INITIALIZE g_cna_t.* TO NULL
 
    LET g_forupd_sql = " SELECT * FROM cna_file WHERE cna01 = ? ",
                        " FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i103_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET p_row = 4 LET p_col = 30
    OPEN WINDOW i103_w AT p_row,p_col WITH FORM "aco/42f/acoi103"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
      CALL i103_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW i103_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
FUNCTION i103_cs()
    CLEAR FORM
   INITIALIZE g_cna.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        cna01,cna02,cna03,cna04,cnauser,cnagrup,cnamodu,cnadate,cnaacti
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
    #        LET g_wc = g_wc clipped," AND cnauser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND cnagrup LIKE '",g_grup CLIPPED,"%'"
        #CHI-8A0001 寫ora
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND cnagrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('cnauser', 'cnagrup')
    #End:FUN-980030
 
    LET g_sql = "SELECT cna01 FROM cna_file ", # 組合出 SQL 指令
                " WHERE ",g_wc CLIPPED," ORDER BY cna01"
    PREPARE i103_prepare FROM g_sql         # RUNTIME 編譯
    DECLARE i103_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i103_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM cna_file WHERE ",g_wc CLIPPED
    PREPARE i103_precount FROM g_sql
    DECLARE i103_count CURSOR FOR i103_precount
END FUNCTION
 
FUNCTION i103_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i103_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i103_q()
            END IF
        ON ACTION next
            CALL i103_fetch('N')
        ON ACTION previous
            CALL i103_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i103_u()
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL i103_x()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i103_r()
            END IF
       ON ACTION reproduce
            IF cl_chk_act_auth() THEN
                 CALL i103_copy()
            END IF
       ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth() THEN
               CALL i103_out()
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
            CALL i103_fetch('/')
        ON ACTION first
            CALL i103_fetch('F')
        ON ACTION last
            CALL i103_fetch('L')
        ON ACTION controlg    #KEY(CONTROL-G)
            CALL cl_cmdask()
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
        #No.FUN-6A0168-------add--------str----
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
               IF g_cna.cna01 IS NOT NULL THEN
                  LET g_doc.column1 = "cna01"
                  LET g_doc.value1 = g_cna.cna01
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
    CLOSE i103_cs
END FUNCTION
 
 
FUNCTION i103_a()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    MESSAGE ""
    CLEAR FORM                                     #清螢幕欄位內容
    INITIALIZE g_cna.* LIKE cna_file.*
    LET g_cna01_t = NULL
    LET g_cna_t.*=g_cna.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_cna.cnaacti = 'Y'                  #有效的資料
        LET g_cna.cnauser = g_user		 #用戶
        LET g_cna.cnagrup = g_grup               #用戶所屬群
        LET g_cna.cnadate = g_today		 #更改日期
        CALL i103_i("a")                      #各欄位輸入
        IF INT_FLAG THEN                         #若按了DEL鍵
            INITIALIZE g_cna.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)          
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_cna.cna01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        LET g_cna.cnaoriu = g_user      #No.FUN-980030 10/01/04
        LET g_cna.cnaorig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO cna_file VALUES(g_cna.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
          # CALL cl_err(g_cna.cna01,SQLCA.sqlcode,0) #No.TQC-660045
            CALL cl_err3("ins","cna_file",g_cna.cna01,"",SQLCA.sqlcode,"","",1) #No.TQC-660045
            CONTINUE WHILE
        ELSE
            LET g_cna_t.* = g_cna.*                # 保存上筆資料
            SELECT cna01 INTO g_cna.cna01 FROM cna_file
             WHERE cna01 = g_cna.cna01
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION i103_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,          #No.FUN-680069 VARCHAR(1)
        l_flag          LIKE type_file.chr1,  		 #是否必要欄位有輸入        #No.FUN-680069 VARCHAR(1)
        l_n             LIKE type_file.num5          #No.FUN-680069 SMALLINT
 
    DISPLAY BY NAME g_cna.cnauser,g_cna.cnagrup,
        g_cna.cnadate, g_cna.cnaacti
    INPUT BY NAME
        g_cna.cna01,g_cna.cna02,g_cna.cna03,g_cna.cna04
        WITHOUT DEFAULTS
 
        BEFORE FIELD cna01    #判斷是否可更改KEY值
            IF p_cmd='u' AND g_chkey='N' THEN NEXT FIELD cna02 END IF
 
        AFTER FIELD cna01			
            IF g_cna.cna01 IS NULL THEN
                NEXT FIELD cna01
            END IF
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND g_cna.cna01 != g_cna01_t) THEN
                SELECT count(*) INTO l_n FROM cna_file
                    WHERE cna01 = g_cna.cna01
                IF l_n > 0 THEN                  # Duplicated
                    CALL cl_err(g_cna.cna01,-239,0)
                    LET g_cna.cna01 = g_cna01_t
                    DISPLAY BY NAME g_cna.cna01
                    NEXT FIELD cna01
                END IF
            END IF
 
    AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
       LET l_flag='N'
       IF INT_FLAG THEN EXIT INPUT  END IF
       IF cl_null(g_cna.cna01) THEN  #廠商編號
           LET l_flag='Y'
           DISPLAY BY NAME g_cna.cna01
       END IF
       IF l_flag='Y' THEN
          CALL cl_err('','9033',0)
          NEXT FIELD cna01
       END IF
 
        #MOD-650015 --start 
       #ON ACTION CONTROLO                        # 沿用所有欄位
       #   IF INFIELD(cna01) THEN
       #      LET g_cna.* = g_cna_t.*
       #      DISPLAY BY NAME g_cna.*
       #      NEXT FIELD cna01
       #   END IF
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
 
FUNCTION i103_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_cna.* TO NULL              #NO.FUN-6A0168
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i103_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        INITIALIZE g_cna.* TO NULL
        RETURN
    END IF
 
    OPEN i103_count
    FETCH i103_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
 
    OPEN i103_cs                            # 從DB生成合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cna.cna01,SQLCA.sqlcode,0)
        INITIALIZE g_cna.* TO NULL
    ELSE
        CALL i103_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i103_fetch(p_flcna)
    DEFINE
        p_flcna         LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)
        l_abso          LIKE type_file.num10         #No.FUN-680069 INTEGER
 
    CASE p_flcna
        WHEN 'N' FETCH NEXT     i103_cs INTO g_cna.cna01
        WHEN 'P' FETCH PREVIOUS i103_cs INTO g_cna.cna01
        WHEN 'F' FETCH FIRST    i103_cs INTO g_cna.cna01
        WHEN 'L' FETCH LAST     i103_cs INTO g_cna.cna01
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
         FETCH ABSOLUTE g_jump i103_cs INTO g_cna.cna01
         LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        LET g_msg = g_cna.cna01 CLIPPED
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        INITIALIZE g_cna.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flcna
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_cna.* FROM cna_file            # 重讀DB,因TEMP有不被更新特性
       WHERE cna01 = g_cna.cna01
    IF SQLCA.sqlcode THEN
        LET g_msg = g_cna.cna01 CLIPPED
      # CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.TQC-660045
        CALL cl_err3("sel","cna_file",g_cna.cna01,"",SQLCA.sqlcode,"","",1)     #No.TQC-660045
    ELSE
        CALL i103_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i103_show()
    LET g_cna_t.* = g_cna.*
    DISPLAY BY NAME g_cna.cna01,g_cna.cna02,g_cna.cna03,g_cna.cna04,
                    g_cna.cnauser,g_cna.cnagrup,g_cna.cnadate,
                    g_cna.cnaacti,g_cna.cnamodu
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i103_u()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_cna.cna01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_cna.cnaacti ='N' THEN                     #檢查資料是否為無效
        CALL cl_err(g_cna.cna01,'mfg1000',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_cna01_t = g_cna.cna01
    BEGIN WORK
 
    OPEN i103_cl USING g_cna.cna01
 
    IF STATUS THEN
       CALL cl_err("OPEN i103_cl:", STATUS, 1)
       CLOSE i103_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH i103_cl INTO g_cna.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cna.cna01,SQLCA.sqlcode,1)
        RETURN
    END IF
 
    LET g_cna.cnamodu = g_user                #更改者
    LET g_cna.cnadate = g_today               #更改日期
    CALL i103_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i103_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_cna.* = g_cna_t.*
            CALL i103_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE cna_file SET cna_file.* = g_cna.*    # 更新DB
            WHERE cna01 = g_cna.cna01               # COLAUTH?
        IF SQLCA.sqlcode THEN
           LET g_msg = g_cna.cna01 CLIPPED
         # CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.TQC-660045
           CALL cl_err3("upd","cna_file",g_msg,"",SQLCA.sqlcode,"","",1) #No.TQC-660045
           CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i103_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i103_x()
    DEFINE
        l_chr LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_cna.cna01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i103_cl USING  g_cna.cna01
    IF STATUS THEN
       CALL cl_err("OPEN i103_cl:", STATUS, 1)
       CLOSE i103_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH i103_cl INTO g_cna.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cna.cna01,SQLCA.sqlcode,1)
        RETURN
    END IF
 
    CALL i103_show()
    IF cl_exp(0,0,g_cna.cnaacti) THEN
        LET g_chr = g_cna.cnaacti
        IF g_cna.cnaacti = 'Y' THEN
           LET g_cna.cnaacti = 'N'
        ELSE
           LET g_cna.cnaacti = 'Y'
        END IF
        UPDATE cna_file
            SET cnaacti = g_cna.cnaacti,
                cnamodu = g_user, cnadate = g_today
            WHERE cna01 = g_cna.cna01
        IF SQLCA.SQLERRD[3] = 0 THEN
          # CALL cl_err(g_cna.cna01,SQLCA.sqlcode,0) #No.TQC-660045
            CALL cl_err3("upd","cna_file",g_cna.cna01,"",SQLCA.sqlcode,"","",1) #No.TQC-660045
            LET g_cna.cnaacti = g_chr
        END IF
        DISPLAY BY NAME g_cna.cnaacti
    END IF
    CLOSE i103_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i103_r()
    DEFINE
        l_chr LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_cna.cna01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i103_cl USING g_cna.cna01
    IF STATUS THEN
       CALL cl_err("OPEN i103_cl:", STATUS, 1)
       CLOSE i103_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH i103_cl INTO g_cna.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cna.cna01,SQLCA.sqlcode,1)
        RETURN
    END IF
    CALL i103_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "cna01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_cna.cna01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM cna_file WHERE cna01 = g_cna.cna01
       CLEAR FORM
         #CKP3
         OPEN i103_count
         #FUN-B50062-add-start--
         IF STATUS THEN
            CLOSE i103_cs
            CLOSE i103_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         FETCH i103_count INTO g_row_count
         #FUN-B50062-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i103_cs
            CLOSE i103_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i103_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i103_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL i103_fetch('/')
         END IF
    END IF
    CLOSE i103_cl
    INITIALIZE g_cna.* TO NULL
    COMMIT WORK
END FUNCTION
 
FUNCTION i103_copy()
    DEFINE
        l_n             LIKE type_file.num5,          #No.FUN-680069 SMALLINT
        l_newno,l_oldno LIKE cna_file.cna01
 
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_cna.cna01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
   #DISPLAY "" AT 1,1
    INPUT l_newno FROM cna01
        AFTER FIELD cna01
            IF l_newno IS NULL THEN
                NEXT FIELD cna01
            END IF
            SELECT count(*) INTO g_cnt FROM cna_file
                WHERE cna01 = l_newno
            IF g_cnt > 0 THEN
                CALL cl_err(l_newno,-239,0)
                NEXT FIELD cna01
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
        DISPLAY BY NAME g_cna.cna01
        RETURN
    END IF
    DROP TABLE x
    SELECT * FROM cna_file
        WHERE cna01 = g_cna.cna01
        INTO TEMP x
    UPDATE x
        SET cna01   = l_newno,     #資料鍵值
            cnauser = g_user,      #資料所有者
            cnagrup = g_grup,      #資料所有者所屬群
            cnamodu = NULL,        #
            cnadate = g_today,     #資料建立日期
            cnaacti = 'Y'          #有效資料
    INSERT INTO cna_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
  #     CALL cl_err(g_cna.cna01,SQLCA.sqlcode,0) #No.TQC-660045
        CALL cl_err3("ins","cns_file",g_cna.cna01,"",SQLCA.sqlcode,"","",1)   #No.TQC-660045
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K'
        LET l_oldno = g_cna.cna01
        SELECT cna_file.* INTO g_cna.* FROM cna_file
                       WHERE cna01 = l_newno
        CALL i103_u()
        #SELECT cna_file.* INTO g_cna.* FROM cna_file  #FUN-C30027
        #               WHERE cna01 = l_oldno          #FUN-C30027
    END IF
    CALL i103_show()
END FUNCTION
 
FUNCTION i103_out()
    DEFINE
        l_i             LIKE type_file.num5,         #No.FUN-680069 SMALLINT
        sr RECORD       LIKE cna_file.*,
        l_name          LIKE type_file.chr20,        #No.FUN-680069 VARCHAR(20) # External(Disk) file name
        l_za05          LIKE cob_file.cob01,         #No.FUN-680069 VARCHAR(40)
        l_chr           LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    IF cl_null(g_wc) THEN
       LET g_wc=" cna01='",g_cna.cna01,"'"
    END IF
 
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
#   CALL cl_outnam('acoi103') RETURNING l_name#No.FUN-770006        
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql = " SELECT * FROM cna_file ",   # 組合出 SQL 指令
                " WHERE ",g_wc CLIPPED
#No.FUN-770006 --start--
#   PREPARE i103_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE i103_co CURSOR FOR i103_p1
 
#   START REPORT i103_rep TO l_name           #No.FUN-770006
#   LET g_pageno = 0                          #No.FUN-770006
 
#    FOREACH i103_co INTO sr.*
#        IF SQLCA.sqlcode THEN
#            CALL cl_err('foreach:',SQLCA.sqlcode,1)
#            EXIT FOREACH
#        END IF
#        OUTPUT TO REPORT i103_rep(sr.*)
#    END FOREACH
#
#    FINISH REPORT i103_rep
 
#    CLOSE i103_co
#   ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)
#No.FUN-770006 --end--
#No.FUN-770006 --start--
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(g_wc,'cna01,cna02,cna03,cna04,
                           cnauser,cnagrup,cnamodu,cnadate,cnaacti')
            RETURNING g_str
    END IF
    CALL cl_prt_cs1('acoi103','acoi103',g_sql,g_str)   
END FUNCTION
#No.FUN-770006 --start-- mark
{REPORT i103_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1) 
        sr    RECORD    LIKE cna_file.*,
        l_chr           LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.cna01
 
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
                  g_x[35] CLIPPED
            PRINT g_dash1
            LET l_trailer_sw = 'y'
        ON EVERY ROW
            IF sr.cnaacti = 'N' THEN PRINT g_c[31],'*'; END IF
            PRINT COLUMN g_c[32],sr.cna01,
                  COLUMN g_c[33],sr.cna02,
                  COLUMN g_c[34],sr.cna03,
                  COLUMN g_c[35],sr.cna04
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
