# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: abxi060.4gl
# Descriptions...: 委外加工核准函維護作業
# Date & Author..: 04/25/97 By Elaine
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能\
# Modify.........: No.FUN-660052 05/06/13 By ice cl_err3訊息修改
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換 
# Modify.........: No.FUN-6A0046 06/10/18 By jamie 1.FUNCTION i060()_q 一開始應清空g_bnk.*的值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-860063 08/06/17 By Carol 民國年欄位放大
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/10 By destiny display xxx.*改為display對應欄位
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50062 11/05/18 By xianghui BUG修改，刪除時提取資料報400錯誤
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_bnk   RECORD LIKE bnk_file.*,
    g_bnk_t RECORD LIKE bnk_file.*,
    g_bnk01_t LIKE bnk_file.bnk01,
    g_bnk02_t LIKE bnk_file.bnk02,
    g_wc,g_sql          STRING   #No.FUN-580092
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL  
DEFINE g_before_input_done  STRING    
DEFINE g_cnt          LIKE type_file.num10          #No.FUN-680062  INTEGER
DEFINE g_msg          LIKE type_file.chr1000        #No.FUN-680062  VARCHAR(72)
DEFINE g_row_count    LIKE type_file.num10          #No.FUN-680062 INTEGER
DEFINE g_curs_index   LIKE type_file.num10          #No.FUN-680062 INTEGER
DEFINE g_jump         LIKE type_file.num10          #No.FUN-680062 INTEGER
DEFINE mi_no_ask      LIKE type_file.num5           #No.FUN-680062 SMALLINT
 
MAIN
    DEFINE
        p_row,p_col   LIKE type_file.num5           #No.FUN-680062  SMALLINT
#       l_time        LIKE type_file.chr8           #No.FUN-6A0062
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
 
   LET p_row = ARG_VAL(1)
   LET p_col = ARG_VAL(2)
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0062
   INITIALIZE g_bnk.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM bnk_file WHERE bnk01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i060_cl CURSOR FROM g_forupd_sql           # LOCK CURSOR
 
   LET p_row = 5 LET p_col = 10
   OPEN WINDOW i060_w AT p_row,p_col WITH FORM "abx/42f/abxi060"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
      CALL i060_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW i060_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0062
END MAIN
 
FUNCTION i060_curs()
    CLEAR FORM
   INITIALIZE g_bnk.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        bnk01,bnk02,bnk03,bnk04,bnk05
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
        ON ACTION controlp                        # 查詢條件
            CASE WHEN INFIELD(bnk02)    #供應廠商編號
#                CALL q_pmc1(0,0,g_bnk.bnk02) RETURNING g_bnk.bnk02
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pmc1"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_bnk.bnk02
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO bnk02
                 NEXT FIELD bnk02
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
    #        LET g_wc = g_wc clipped," AND gebuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND gebgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND gebgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('gebuser', 'gebgrup')
    #End:FUN-980030
 
    LET g_sql="SELECT bnk01 FROM bnk_file ", # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED, " ORDER BY bnk01 "
    PREPARE i060_prepare FROM g_sql           # RUNTIME 編譯
    IF STATUS THEN 
       CALL cl_err('i060_pre',STATUS,0) 
       RETURN 
    END IF
    DECLARE i060_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i060_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM bnk_file WHERE ",g_wc CLIPPED
    PREPARE i060_cntpre FROM g_sql
    DECLARE i060_count CURSOR FOR i060_cntpre
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
            NEXT OPTION "next"
        ON ACTION next
            CALL i060_fetch('N')
        ON ACTION previous
            CALL i060_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i060_u()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i060_r()
            END IF
#      ON ACTION output
#           IF cl_chk_act_auth()
#              THEN CALL i060_out()
#           END IF
 
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
            CALL i060_fetch('/')
        ON ACTION first
            CALL i060_fetch('F')
        ON ACTION last
            CALL i060_fetch('L')
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        #No.FUN-6A0046-------add--------str----
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
               IF g_bnk.bnk01 IS NOT NULL THEN
                  LET g_doc.column1 = "bnk01"
                  LET g_doc.value1 = g_bnk.bnk01
                  CALL cl_doc()
               END IF
           END IF
        #No.FUN-6A0046-------add--------end---- 
 
           LET g_action_choice = "exit"
           CONTINUE MENU
 
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE i060_cs
END FUNCTION
 
 
FUNCTION i060_a()
    MESSAGE ""
    IF s_shut(0) THEN RETURN END IF
    CLEAR FORM                                   # 清螢幕欄位內容
    INITIALIZE g_bnk.* LIKE bnk_file.*
    LET g_bnk01_t = NULL
    LET g_bnk02_t = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_bnk.bnk03 = TODAY
        LET g_bnk.bnk04 = TODAY
        LET g_bnk.bnk05 = 'N'
        CALL i060_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_bnk.bnk01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO bnk_file VALUES(g_bnk.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_bnk.bnk01,SQLCA.sqlcode,0)  #No.FUN-660052
            CALL cl_err3("ins","bnk_file",g_bnk.bnk01,"",SQLCA.sqlcode,"","",1)
            CONTINUE WHILE
        ELSE
            LET g_bnk_t.* = g_bnk.*                # 保存上筆資料
            SELECT bnk01 INTO g_bnk.bnk01 FROM bnk_file
                WHERE bnk01 = g_bnk.bnk01
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i060_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,          #No.FUN-680062 VARCHAR(1)
        l_n             LIKE type_file.num5,          #No.FUN-680062 SMALLINT
        l_yy            LIKE type_file.chr3,          #FUN-860063-modify chr2->chr3     #No.FUN-680062  VARCHAR(2)  
        l_sql           STRING,                       
        l_bnk01         LIKE  bnk_file.bnk01          #No.FUN-680062  VARCHAR(8)
 
    INPUT BY NAME
        g_bnk.bnk01,g_bnk.bnk02,g_bnk.bnk03,g_bnk.bnk04,g_bnk.bnk05
        WITHOUT DEFAULTS
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i060_set_entry(p_cmd)
           CALL i060_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
 
{  不需自動編號, 由user自行輸入05/02/97
#------->  若p_cmd='a'則將bnk01依年度來自動編號
            LET l_yy = YEAR(TODAY)-1911
            LET l_sql= l_yy,'*'
            DECLARE i060_curo SCROLL CURSOR WITH HOLD FOR
             SELECT bnk01 FROM bnk_file
              WHERE bnk01 MATCHES l_sql
 
            OPEN i060_curo
            FETCH LAST i060_curo INTO l_bnk01
            LET l_bnk01[1,2]=l_yy
            IF cl_null(l_bnk01[3,8]) THEN
               LET l_bnk01[3,8]='000000'
            END IF
            LET g_bnk.bnk01=l_bnk01[1,2],(l_bnk01[3,8]+1) USING '&&&&&&'
            DISPLAY BY NAME g_bnk.bnk01
#-----------------------------------------------
}
 
        AFTER FIELD bnk01
          IF NOT cl_null(g_bnk.bnk01) THEN
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND
              ( g_bnk.bnk01 !=g_bnk01_t)) THEN
                SELECT count(*) INTO l_n FROM bnk_file
                 WHERE bnk01 = g_bnk.bnk01
                IF l_n > 0 THEN                  # Duplicated
                    CALL cl_err(g_bnk.bnk01,-239,0)
                    LET g_bnk.bnk01 = g_bnk01_t
                    DISPLAY BY NAME g_bnk.bnk01
                    NEXT FIELD bnk01
                END IF
            END IF
          END IF
 
        ON ACTION controlp                        # 查詢條件
            CASE WHEN INFIELD(bnk02)    #供應廠商編號
#                CALL q_pmc1(0,0,g_bnk.bnk02) RETURNING g_bnk.bnk02
#                CALL FGL_DIALOG_SETBUFFER( g_bnk.bnk02 )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pmc1"
                 LET g_qryparam.default1 = g_bnk.bnk02
                 CALL cl_create_qry() RETURNING g_bnk.bnk02
#                 CALL FGL_DIALOG_SETBUFFER( g_bnk.bnk02 )
                 DISPLAY BY NAME g_bnk.bnk02
                 NEXT FIELD bnk02
            END CASE
 
        #MOD-650015 --start 
        #ON ACTION CONTROLO                        # 沿用所有欄位
        #    IF INFIELD(bnk01) THEN
        #        LET g_bnk.* = g_bnk_t.*
        #        CALL i060_show()
        #        NEXT FIELD bnk01
        #    END IF
        #MOD-650015 --end 
 
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
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
 
FUNCTION i060_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_bnk.* TO NULL                #No.FUN-6A0046
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i060_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i060_count
    FETCH i060_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i060_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bnk.bnk01,SQLCA.sqlcode,0)
        INITIALIZE g_bnk.* TO NULL
    ELSE
        CALL i060_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i060_fetch(p_flbnk)
    DEFINE
        p_flbnk         LIKE type_file.chr1,         #No.FUN-680062  VARCHAR(1) 
        l_abso          LIKE type_file.num10         #No.FUN-680062  INTEGER
 
    CASE p_flbnk
        WHEN 'N' FETCH NEXT     i060_cs INTO g_bnk.bnk01
        WHEN 'P' FETCH PREVIOUS i060_cs INTO g_bnk.bnk01
        WHEN 'F' FETCH FIRST    i060_cs INTO g_bnk.bnk01
        WHEN 'L' FETCH LAST     i060_cs INTO g_bnk.bnk01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
#                     CONTINUE PROMPT
 
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
            FETCH ABSOLUTE g_jump i060_cs INTO g_bnk.bnk01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bnk.bnk01,SQLCA.sqlcode,0)
        INITIALIZE g_bnk.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flbnk
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_bnk.* FROM bnk_file            # 重讀DB,因TEMP有不被更新特性
       WHERE bnk01 = g_bnk.bnk01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_bnk.bnk01,SQLCA.sqlcode,0)   #No.FUN-660052
        CALL cl_err3("sel","bnk_file",g_bnk.bnk01,"",SQLCA.sqlcode,"","",1)
    ELSE
        CALL i060_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i060_show()
    LET g_bnk_t.* = g_bnk.*
    #No.FUN-9A0024--begin
    #DISPLAY BY NAME g_bnk.*
    DISPLAY BY NAME g_bnk.bnk01,g_bnk.bnk02,g_bnk.bnk03,g_bnk.bnk04,g_bnk.bnk05
    #No.FUN-9A0024--end
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i060_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_bnk.bnk01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_bnk01_t = g_bnk.bnk01
    LET g_bnk02_t = g_bnk.bnk02
    BEGIN WORK
 
    OPEN i060_cl USING g_bnk.bnk01
    IF STATUS THEN
       CALL cl_err("OPEN i060_cl:", STATUS, 1)
       CLOSE i060_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH i060_cl INTO g_bnk.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bnk.bnk01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i060_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i060_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_bnk.*=g_bnk_t.*
            CALL i060_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE bnk_file SET bnk_file.* = g_bnk.*    # 更新DB
         WHERE bnk01 = g_bnk01_t             # COLAUTH?
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_bnk.bnk01,SQLCA.sqlcode,0) #No.FUN-660052
           CALL cl_err3("upd","bnk_file",g_bnk01_t,"",SQLCA.sqlcode,"","",1)
           CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i060_cl
    COMMIT WORK
END FUNCTION
 
 
FUNCTION i060_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_bnk.bnk01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i060_cl USING g_bnk.bnk01
    IF STATUS THEN
       CALL cl_err("OPEN i060_cl:", STATUS, 1)
       CLOSE i060_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i060_cl INTO g_bnk.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_bnk.bnk01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i060_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "bnk01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_bnk.bnk01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM bnk_file WHERE bnk01=g_bnk.bnk01
       CLEAR FORM
       OPEN i060_count
       #FUN-B50062-add-start--
       IF STATUS THEN
          CLOSE i060_cs
          CLOSE i060_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       FETCH i060_count INTO g_row_count
       #FUN-B50062-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i060_cs
          CLOSE i060_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i060_cs
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
 
FUNCTION i060_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1         #No.FUN-680062  VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("bnk01",TRUE)
   END IF
END FUNCTION
 
FUNCTION i060_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1        #No.FUN-680062   VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("bnk01",FALSE)
   END IF
END FUNCTION
 
#Patch....NO.TQC-610035 <001> #
