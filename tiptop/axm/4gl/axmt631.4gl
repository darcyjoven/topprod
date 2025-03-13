# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: axmt631.4gl
# Descriptions...: 出貨麥頭檔維護作業
# Date & Author..: 96/10/15 by WUPN (Rayban)
# Modify.........: No.FUN-4C0057 04/12/09 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.FUN-550070 05/05/26 By Will 單據編號放大
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能monster代
# Modify.........: No.FUN-660167 06/06/23 By cl cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6A0020 06/11/17 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_oge   RECORD LIKE oge_file.*,
    g_oge_t RECORD LIKE oge_file.*,
    g_oge01_t LIKE oge_file.oge01,
     g_wc,g_sql        STRING,  #No.FUN-580092 HCN
    g_argv1             LIKE oge_file.oge01
 
DEFINE   g_forupd_sql  STRING #SELECT ... FOR UPDATE SQL
DEFINE   g_before_input_done    STRING
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680137  VARCHAR(72) 
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
    OPTIONS
        INPUT NO WRAP,
        FIELD ORDER FORM
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
    LET g_argv1 = ARG_VAL(1)

    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
    INITIALIZE g_oge.* TO NULL
    INITIALIZE g_oge_t.* TO NULL
 
    LET g_forupd_sql = " SELECT * FROM oge_file WHERE oge01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t631_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    OPEN WINDOW t631_w WITH FORM "axm/42f/axmt631"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
	IF NOT cl_null(g_argv1) THEN CALL t631_q() END IF
 
      LET g_action_choice=""
    CALL t631_menu()
 
    CLOSE WINDOW t631_w

    CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
END MAIN
 
FUNCTION t631_curs()
   CLEAR FORM
   IF cl_null(g_argv1) THEN
   INITIALIZE g_oge.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
		oge01,  oge101, oge102, oge103, oge104, oge105, oge106,
		oge107, oge108, oge109, oge110, oge111, oge112, oge201, oge202,
		oge203,	oge204, oge205, oge206, oge207, oge208, oge209, oge210,
		oge211,	oge212
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
   ELSE
      LET g_wc = "oge01 ='",g_argv1,"'"
      LET g_oge.oge01 = g_argv1
   END IF
   IF INT_FLAG THEN
      RETURN
   END IF
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #     LET g_wc = g_wc clipped," AND ogeuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND ogegrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET g_wc = g_wc clipped," AND ogegrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ogeuser', 'ogegrup')
   #End:FUN-980030
 
   LET g_sql="SELECT oge01 FROM oge_file ", # 組合出 SQL 指令
           " WHERE ",g_wc CLIPPED, " ORDER BY oge01"
   PREPARE t631_prepare FROM g_sql           # RUNTIME 編譯
   DECLARE t631_cs                         # SCROLL CURSOR
      SCROLL CURSOR WITH HOLD FOR t631_prepare
   LET g_sql= "SELECT COUNT(*) FROM oge_file WHERE ",g_wc CLIPPED
   PREPARE t631_precount FROM g_sql
   DECLARE t631_count CURSOR FOR t631_precount
END FUNCTION
 
FUNCTION t631_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL t631_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL t631_q()
            END IF
        ON ACTION next
            CALL t631_fetch('N')
        ON ACTION previous
            CALL t631_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL t631_u()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL t631_r()
            END IF
       ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth()
               THEN CALL t631_out()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            #EXIT MENU
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL t631_fetch('/')
        ON ACTION first
            CALL t631_fetch('F')
        ON ACTION last
            CALL t631_fetch('L')

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
  
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121
 
        #No.FUN-6A0020-------add--------str----
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
             IF cl_chk_act_auth() THEN
                IF g_oge.oge01 IS NOT NULL THEN
                LET g_doc.column1 = "oge01"
                LET g_doc.value1 = g_oge.oge01
                CALL cl_doc()
              END IF
           END IF
        #No.FUN-6A0020-------add--------end----
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE t631_cs
END FUNCTION
 
 
FUNCTION t631_a()
    MESSAGE ""
    IF s_shut(0) THEN RETURN END IF
    CLEAR FORM
    INITIALIZE g_oge.* TO NULL
    LET g_oge01_t = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL t631_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_oge.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_oge.oge01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO oge_file VALUES(g_oge.*)
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_oge.oge01,SQLCA.sqlcode,0)   #No.FUN-660167
            CALL cl_err3("ins","oge_file",g_oge.oge01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
            CONTINUE WHILE
        ELSE
            LET g_oge_t.* = g_oge.*                # 保存上筆資料
            SELECT oge01 INTO g_oge.oge01 FROM oge_file
                WHERE oge01 = g_oge.oge01
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t631_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
        l_n             LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
    DISPLAY BY NAME g_oge.oge01
    INPUT BY NAME
		g_oge.oge01 ,g_oge.oge101, g_oge.oge102,
		g_oge.oge103,g_oge.oge104,
		g_oge.oge105,g_oge.oge106, g_oge.oge107, g_oge.oge108,
		g_oge.oge109,g_oge.oge110, g_oge.oge111, g_oge.oge112,
		g_oge.oge201,g_oge.oge202, g_oge.oge203, g_oge.oge204,
		g_oge.oge205,g_oge.oge206, g_oge.oge207, g_oge.oge208,
		g_oge.oge209,g_oge.oge210, g_oge.oge211, g_oge.oge212
        WITHOUT DEFAULTS
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL t631_set_entry(p_cmd)
           CALL t631_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
           CALL cl_set_docno_format("oge01")     #No.FUN-550070
 
        AFTER FIELD oge01
          IF g_oge.oge01 IS NOT NULL THEN
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND g_oge.oge01 != g_oge_t.oge01) THEN
                SELECT count(*) INTO l_n FROM oge_file
                    WHERE oge01 = g_oge.oge01
                IF l_n > 0 THEN                  # Duplicated
                    CALL cl_err('oge01',-239,0)
                    LET g_oge.oge01 = g_oge_t.oge01
                    DISPLAY BY NAME g_oge.oge01
                    NEXT FIELD oge01
                END IF
                SELECT COUNT(*) INTO l_n FROM oga_file
                 WHERE oga01 = g_oge.oge01
                IF l_n = 0 THEN
                   CALL cl_err('','abx-002',1)
                   NEXT FIELD oge01
                END IF
            END IF
          END IF
      #MOD-650015 --start
      #  ON ACTION CONTROLO                        # 沿用所有欄位
      #      IF INFIELD(oge01) THEN
      #         LET g_oge.* = g_oge_t.*
      #         DISPLAY BY NAME
      #  	g_oge.oge01, g_oge.oge102, g_oge.oge103, g_oge.oge104,
      #  	g_oge.oge105,g_oge.oge106, g_oge.oge107, g_oge.oge108,
      #  	g_oge.oge109,g_oge.oge110, g_oge.oge111, g_oge.oge112,
      #  	g_oge.oge201,g_oge.oge202, g_oge.oge203, g_oge.oge204,
      #  	g_oge.oge205,g_oge.oge206, g_oge.oge207, g_oge.oge208,
      #  	g_oge.oge209,g_oge.oge210, g_oge.oge211, g_oge.oge212
      #         NEXT FIELD oge01
      #      END IF
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
 
FUNCTION t631_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_oge.* TO NULL               #No.FUN-6A0020 
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t631_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN t631_count
    FETCH t631_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t631_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_oge.oge01,SQLCA.sqlcode,0)
        INITIALIZE g_oge.* TO NULL
    ELSE
        CALL t631_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION t631_fetch(p_floge)
    DEFINE
        p_floge         LIKE type_file.chr1        # No.FUN-680137 VARCHAR(1)
 
    CASE p_floge
        WHEN 'N' FETCH NEXT     t631_cs INTO g_oge.oge01
        WHEN 'P' FETCH PREVIOUS t631_cs INTO g_oge.oge01
        WHEN 'F' FETCH FIRST    t631_cs INTO g_oge.oge01
        WHEN 'L' FETCH LAST     t631_cs INTO g_oge.oge01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
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
            LET mi_no_ask = FALSE
            FETCH ABSOLUTE g_jump t631_cs INTO g_oge.oge01
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_oge.oge01,SQLCA.sqlcode,0)
        INITIALIZE g_oge.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_floge
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_oge.* FROM oge_file
     WHERE oge01 = g_oge.oge01
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_oge.oge01,SQLCA.sqlcode,0)   #No.FUN-660167
       CALL cl_err3("sel","oge_file",g_oge.oge01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
       INITIALIZE g_oge.* TO NULL #FUN-4C0057 add
    ELSE
       LET g_data_owner = ''      #FUN-4C0057 add
       LET g_data_group = ''      #FUN-4C0057 add
       CALL t631_show()           # 重新顯示
    END IF
 
END FUNCTION
 
FUNCTION t631_show()
    LET g_oge_t.*=g_oge.*
    DISPLAY BY NAME
		g_oge.oge01 ,g_oge.oge101, g_oge.oge102,
		g_oge.oge103,g_oge.oge104,
		g_oge.oge105,g_oge.oge106, g_oge.oge107, g_oge.oge108,
		g_oge.oge109,g_oge.oge110, g_oge.oge111, g_oge.oge112,
		g_oge.oge201,g_oge.oge202, g_oge.oge203, g_oge.oge204,
		g_oge.oge205,g_oge.oge206, g_oge.oge207, g_oge.oge208,
		g_oge.oge209,g_oge.oge210, g_oge.oge211, g_oge.oge212
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t631_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_oge.oge01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_oge01_t = g_oge.oge01
    BEGIN WORK
 
    OPEN t631_cl USING g_oge.oge01
    IF STATUS THEN
       CALL cl_err("OPEN t631_cl:", STATUS, 1)
       CLOSE t631_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t631_cl INTO g_oge.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_oge.oge01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL t631_show()                          # 顯示最新資料
    WHILE TRUE
        CALL t631_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_oge.*=g_oge_t.*
            CALL t631_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE oge_file SET oge_file.* = g_oge.*  # 更新DB
            WHERE oge01 = g_oge.oge01             # COLAUTH?
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_oge.oge01,SQLCA.sqlcode,0)   #No.FUN-660167
            CALL cl_err3("upd","oge_file",g_oge01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t631_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t631_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_oge.oge01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN t631_cl USING g_oge.oge01
    IF STATUS THEN
       CALL cl_err("OPEN t631_cl:", STATUS, 1)
       CLOSE t631_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t631_cl INTO g_oge.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_oge.oge01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL t631_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "oge01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_oge.oge01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM oge_file WHERE oge01 = g_oge.oge01
       CLEAR FORM
       INITIALIZE g_oge.* TO NULL
       INITIALIZE g_oge_t.* TO NULL
       OPEN t631_count
       FETCH t631_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t631_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t631_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL t631_fetch('/')
       END IF
    END IF
    CLOSE t631_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t631_out()
    DEFINE
    l_oge           RECORD LIKE oge_file.*,
        l_i             LIKE type_file.num5,          #No.FUN-680137 SMALLINT
        l_name          LIKE type_file.chr20,                 # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
        l_za05          LIKE type_file.chr1000                #        #No.FUN-680137 VARCHAR(40)
 
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
    #LET l_name = 'axmt631.out'
    CALL cl_outnam('axmt631') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz17 INTO g_len FROM zz_file WHERE zz01 = 'axmt631'
    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
    LET g_sql="SELECT * FROM oge_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED
    PREPARE t631_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE t631_co                         # CURSOR
        CURSOR FOR t631_p1
 
    START REPORT t631_rep TO l_name
 
    FOREACH t631_co INTO l_oge.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT t631_rep(l_oge.*)
    END FOREACH
 
    FINISH REPORT t631_rep
 
    CLOSE t631_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT t631_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(1)
    sr              RECORD LIKE oge_file.*
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.oge01
 
    FORMAT
        PAGE HEADER
            PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
            PRINT ' '
            PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
            PRINT ' '
            PRINT g_x[2] CLIPPED,g_today,' ',TIME,
                COLUMN g_len-10,g_x[3] CLIPPED,PAGENO USING '<<<'
            PRINT g_dash[1,g_len]
		BEFORE GROUP OF sr.oge01
            PRINT COLUMN 10,g_x[11] CLIPPED,sr.oge01
          	PRINT '       ------------------------------   ',
          	      '------------------------------'
			PRINT COLUMN 21,g_x[13],
			      COLUMN 45,g_x[14]
			PRINT '       ------------------------------   ',
          	      '------------------------------'
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
            PRINT COLUMN 8,sr.oge101,
                  COLUMN 41,sr.oge201
            PRINT COLUMN 8,sr.oge102,
                  COLUMN 41,sr.oge202
            PRINT COLUMN 8,sr.oge103,
                  COLUMN 41,sr.oge203
            PRINT COLUMN 8,sr.oge104,
                  COLUMN 41,sr.oge204
            PRINT COLUMN 8,sr.oge105,
                  COLUMN 41,sr.oge205
            PRINT COLUMN 8,sr.oge106,
                  COLUMN 41,sr.oge206
            PRINT COLUMN 8,sr.oge107,
                  COLUMN 41,sr.oge207
            PRINT COLUMN 8,sr.oge108,
                  COLUMN 41,sr.oge208
            PRINT COLUMN 8,sr.oge109,
                  COLUMN 41,sr.oge209
            PRINT COLUMN 8,sr.oge110,
                  COLUMN 41,sr.oge210
            PRINT COLUMN 8,sr.oge111,
                  COLUMN 41,sr.oge211
            PRINT COLUMN 8,sr.oge112,
                  COLUMN 41,sr.oge212
 
        ON LAST ROW
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
 
FUNCTION t631_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("oge01",TRUE)
   END IF
END FUNCTION
 
FUNCTION t631_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("oge01",FALSE)
  END IF
END FUNCTION
 
#Patch....NO.TQC-610037 <001> #
