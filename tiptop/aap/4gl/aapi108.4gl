# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: aapi108.4gl
# Descriptions...: 雜項客戶維護作業
# Date & Author..: 95/10/03 By Roger
# Modify.........: No.FUN-570158 05/08/03 By Sarah 在複製裡增加set_entry段
# Modify.........: No.FUN-630081 06/03/31 By Smapmin 拿掉單頭的CONTROLO
# Modify.........: No.FUN-650017 06/06/15 By Echo 報表段的LEFT MARGIN的值改為 g_left_margin
# Modify.........: No.FUN-660122 06/06/27 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-680046 06/09/29 By jamie 1.FUNCTION i108_q() 一開始應清空g_apl.*值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0052 06/11/16 By dxfwo 修改空白行問題
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-770093 07/07/26 By johnray 修改報表功能，使用p_query打印報表
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50062 11/05/13 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C30027 12/08/09 By bart 複製後停在新料號畫面

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_apl               RECORD LIKE apl_file.*,
    g_before_input_done LIKE type_file.num5,    #No.FUN-690028 SMALLINT
    g_apl_t             RECORD LIKE apl_file.*,
    g_apl01_t           LIKE apl_file.apl01,
    g_wc,g_sql          string                 #No.FUN-580092 HCN
DEFINE g_forupd_sql  STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690028 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_no_ask       LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 

   INITIALIZE g_apl.* TO NULL
   INITIALIZE g_apl_t.* TO NULL
 
   LET g_forupd_sql = " SELECT * FROM apl_file WHERE apl01 = ? FOR UPDATE"
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i108_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
   OPEN WINDOW i108_w WITH FORM "aap/42f/aapi108"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()
 
      LET g_action_choice=""
      CALL i108_menu()
 
   CLOSE WINDOW i108_w

   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION i108_cs()
    CLEAR FORM
   INITIALIZE g_apl.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        apl01,apl02,apl021,apl03
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
    LET g_sql="SELECT apl01 FROM apl_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY apl01"
    PREPARE i108_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i108_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i108_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM apl_file WHERE ",g_wc CLIPPED
    PREPARE i108_precount FROM g_sql
    DECLARE i108_count CURSOR FOR i108_precount
END FUNCTION
 
FUNCTION i108_menu()
    DEFINE l_cmd     STRING         #No.FUN-770093
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i108_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i108_q()
            END IF
        ON ACTION next
            CALL i108_fetch('N')
        ON ACTION previous
            CALL i108_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i108_u()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i108_r()
            END IF
       ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                 CALL i108_copy()
            END IF
        ON ACTION output                   #No.MOD-480006
             LET g_action_choice="output"  #No.MOD-480006
            IF cl_chk_act_auth() THEN
#No.FUN-770093 -- begin --
#               CALL i108_out()
               IF cl_null(g_wc) THEN LET g_wc = " 1=1" END IF
               LET l_cmd='p_query "aapi108" "',g_wc CLIPPED,'"'
               CALL cl_cmdrun(l_cmd)
#No.FUN-770093 -- end --
            END IF
       ON ACTION help
           CALL cl_show_help()
       ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#         EXIT MENU
       ON ACTION exit
          LET g_action_choice="exit"
          EXIT MENU
       ON ACTION jump
          CALL i108_fetch('/')
       ON ACTION first
          CALL i108_fetch('F')
       ON ACTION last
          CALL i108_fetch('L')
       ON ACTION CONTROLG
          CALL cl_cmdask()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
          LET g_action_choice="exit"
          CONTINUE MENU
 
      #No.FUN-680046-------add--------str----
      ON ACTION related_document       #相關文件
         LET g_action_choice="related_document"
         IF cl_chk_act_auth() THEN
             IF g_apl.apl01 IS NOT NULL THEN
                LET g_doc.column1 = "apl01"
                LET g_doc.value1 = g_apl.apl01
                CALL cl_doc()
             END IF
         END IF
      #No.FUN-680046-------add--------end---- 
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE i108_cs
END FUNCTION
 
 
FUNCTION i108_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_apl.* LIKE apl_file.*
    LET g_apl01_t = NULL
    LET g_apl_t.*=g_apl.*
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i108_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            INITIALIZE g_apl.* TO NULL
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_apl.apl01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO apl_file(apl01,apl02,apl021,apl03)
                      VALUES(g_apl.apl01,g_apl.apl02,g_apl.apl021,g_apl.apl03)
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_apl.apl01,SQLCA.sqlcode,0)   #No.FUN-660122
            CALL cl_err3("ins","apl_file",g_apl.apl01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122
            CONTINUE WHILE
        ELSE
            LET g_apl_t.* = g_apl.*                # 保存上筆資料
            SELECT apl01 INTO g_apl.apl01 FROM apl_file
                WHERE apl01 = g_apl.apl01
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i108_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
        l_flag          LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
        l_n             LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
    INPUT BY NAME
        g_apl.apl01,g_apl.apl02,g_apl.apl021,g_apl.apl03
        WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i108_set_entry(p_cmd)
         CALL i108_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
 
        AFTER FIELD apl01
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND g_apl.apl01 != g_apl01_t) THEN
                SELECT count(*) INTO l_n FROM apl_file
                    WHERE apl01 = g_apl.apl01
                IF l_n > 0 THEN                  # Duplicated
                    CALL cl_err(g_apl.apl01,-239,0)
                    LET g_apl.apl01 = g_apl01_t
                    DISPLAY BY NAME g_apl.apl01
                    NEXT FIELD apl01
                END IF
            END IF
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
            LET l_flag='N'
            IF INT_FLAG THEN
                EXIT INPUT
            END IF
            IF l_flag='Y' THEN
                 CALL cl_err('','9033',0)
                 NEXT FIELD apl01
            END IF
 
        #-----FUN-630081---------
        #ON ACTION CONTROLO                        # 沿用所有欄位
        #    IF INFIELD(apl01) THEN
        #        LET g_apl.* = g_apl_t.*
        #        DISPLAY BY NAME g_apl.*
        #        NEXT FIELD apl01
        #    END IF
        #-----END FUN-630081-----
 
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
 
FUNCTION i108_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("apl01",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i108_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("apl01",FALSE)
   END IF
 
END FUNCTION
 
 
FUNCTION i108_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_apl.* TO NULL             #No.FUN-680046
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i108_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i108_count
    FETCH i108_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i108_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_apl.apl01,SQLCA.sqlcode,0)
        INITIALIZE g_apl.* TO NULL
    ELSE
        CALL i108_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i108_fetch(p_flapl)
    DEFINE
        p_flapl          LIKE type_file.chr1        # No.FUN-690028 VARCHAR(1)
 
    CASE p_flapl
        WHEN 'N' FETCH NEXT     i108_cs INTO g_apl.apl01
        WHEN 'P' FETCH PREVIOUS i108_cs INTO g_apl.apl01
        WHEN 'F' FETCH FIRST    i108_cs INTO g_apl.apl01
        WHEN 'L' FETCH LAST     i108_cs INTO g_apl.apl01
        WHEN '/'
            IF NOT g_no_ask THEN
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
            FETCH ABSOLUTE g_jump i108_cs INTO g_apl.apl01
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_apl.apl01,SQLCA.sqlcode,0)
        INITIALIZE g_apl.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flapl
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_apl.* FROM apl_file            # 重讀DB,因TEMP有不被更新特性
       WHERE apl01 = g_apl.apl01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_apl.apl01,SQLCA.sqlcode,0)   #No.FUN-660122
        CALL cl_err3("sel","apl_file",g_apl.apl01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122
    ELSE
 
        CALL i108_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i108_show()
    LET g_apl_t.* = g_apl.*
    DISPLAY BY NAME g_apl.apl01,g_apl.apl02,g_apl.apl021,g_apl.apl03
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i108_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_apl.apl01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_apl01_t = g_apl.apl01
    BEGIN WORK
 
    OPEN i108_cl USING g_apl.apl01
    IF STATUS THEN
       CALL cl_err("OPEN i108_cl:", STATUS, 1)
       CLOSE i108_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i108_cl INTO g_apl.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_apl.apl01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i108_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i108_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_apl.*=g_apl_t.*
            CALL i108_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE apl_file SET apl_file.* = g_apl.*    # 更新DB
            WHERE apl01 = g_apl01_t             # COLAUTH?
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_apl.apl01,SQLCA.sqlcode,0)   #No.FUN-660122
            CALL cl_err3("upd","apl_file",g_apl01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i108_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i108_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_apl.apl01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i108_cl USING g_apl.apl01
    IF STATUS THEN
       CALL cl_err("OPEN i108_cl:", STATUS, 1)
       CLOSE i108_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i108_cl INTO g_apl.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_apl.apl01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i108_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "apl01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_apl.apl01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM apl_file WHERE apl01 = g_apl.apl01
       CLEAR FORM
       OPEN i108_count
       #FUN-B50062-add-start--
       IF STATUS THEN
          CLOSE i108_cl
          CLOSE i108_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       FETCH i108_count INTO g_row_count
       #FUN-B50062-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i108_cl
          CLOSE i108_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i108_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i108_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE
          CALL i108_fetch('/')
       END IF
    END IF
    CLOSE i108_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i108_copy()
    DEFINE
        l_newno         LIKE apl_file.apl01,
        l_oldno         LIKE apl_file.apl01
 
    IF s_shut(0) THEN RETURN END IF
    IF g_apl.apl01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    LET g_before_input_done = FALSE   #FUN-570158
    CALL i108_set_entry('a')          #FUN-570158
    LET g_before_input_done = TRUE    #FUN-570158
   #DISPLAY "" AT 1,1
    INPUT l_newno FROM apl01
        AFTER FIELD apl01
            IF l_newno IS NULL THEN
                NEXT FIELD apl01
            END IF
            SELECT count(*) INTO g_cnt FROM apl_file
                WHERE apl01 = l_newno
            IF g_cnt > 0 THEN
                CALL cl_err(l_newno,-239,0)
                NEXT FIELD apl01
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
        DISPLAY BY NAME g_apl.apl01
        RETURN
    END IF
    SELECT * FROM apl_file
        WHERE apl01 = g_apl.apl01
        INTO TEMP x
    UPDATE x SET apl01=l_newno    #資料鍵值
    INSERT INTO apl_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_apl.apl01,SQLCA.sqlcode,0)   #No.FUN-660122
        CALL cl_err3("ins","apl_file",l_newno,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K'
  	LET l_oldno = g_apl.apl01
  	LET g_apl.apl01 = l_oldno
	SELECT apl_file.* INTO g_apl.*
	  FROM apl_file WHERE apl01 = l_newno
	CALL i108_u()
    #FUN-C30027---begin
	#LET g_apl.apl01 = l_oldno
	#SELECT apl_file.* INTO g_apl.*
	#  FROM apl_file WHERE apl01 = l_oldno
	#CALL i108_show()
    #FUN-C30027---end
    END IF
    DISPLAY BY NAME g_apl.apl01
END FUNCTION
 
FUNCTION i108_out()
    DEFINE
        l_i             LIKE type_file.num5,    #No.FUN-690028 SMALLINT
        l_name          LIKE type_file.chr20,                 # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
        l_za05          LIKE type_file.chr1000                #  #No.FUN-690028 VARCHAR(40)
 
    IF g_wc IS NULL THEN
 #      CALL cl_err('',-400,0)
        CALL cl_err('','9057',0)
        RETURN
    END IF
    CALL cl_wait()
 
   #LET l_name = 'aapi108.out'
    CALL cl_outnam('aapi108') RETURNING l_name  #FUN-650017
 
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz17 INTO g_len FROM zz_file WHERE zz01 = 'aapi108'
   #IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF   #FUN-650017
   #FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR     #FUN-650017
    LET g_sql="SELECT * FROM apl_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED
    PREPARE i108_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i108_co CURSOR FOR i108_p1
 
   
    START REPORT i108_rep TO l_name
    #LET g_page_line = 11   #No..TQC-6B0052
    FOREACH i108_co INTO g_apl.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT i108_rep(g_apl.*)
    END FOREACH
 
    FINISH REPORT i108_rep
 
    CLOSE i108_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT i108_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
        sr RECORD LIKE apl_file.*
 
   OUTPUT TOP MARGIN g_top_margin 
          LEFT MARGIN g_left_margin          #FUN-650017 
          BOTTOM MARGIN g_bottom_margin 
          PAGE LENGTH g_page_line
 
    ORDER BY sr.apl01
 
    FORMAT
        ON EVERY ROW
           PRINT sr.apl01 CLIPPED
           PRINT sr.apl02 CLIPPED
           PRINT sr.apl021 CLIPPED
           PRINT sr.apl03 CLIPPED
END REPORT
 
#Patch....NO.TQC-610035 <001> #
