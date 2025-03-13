# Prog. Version..: '5.10.00-08.01.04(00000)'     #
#
# Pattern name...: axdi110.4gl
# Descriptions...: 車輛保養項目維護作業
# Date & Author..: 03/12/1 By HAWK
# Modify.........: No.MOD-4B0067 04/11/18 By DAY  將變數用Like方式定義
# Modify.........: No.FUN-4C0052 04/12/08 By pengu Data and Group權限控管
# Modify.........: No.FUN-520024 05/02/24 By Day 報表轉XML
# Modify.........: No.MOD-540145 05/05/10 By vivien  刪除HELP FILE
# Modify.........: No:FUN-580028 05/08/22 By Sarah 在複製裡增加set_entry段
# Modify.........: No:FUN-680108 06/08/29 By Xufeng 字段類型定義改為LIKE     
# Modify.........: Mo.FUN-6A0078 06/10/24 By xumin g_no_ask改mi_no_ask    
# Modify.........: No:FUN-6A0091 06/10/27 By douzh l_time轉g_time
# Modify.........: No:FUN-6A0165 06/11/08 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No:FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE
    g_obu   RECORD LIKE obu_file.*,
    g_obu_t RECORD LIKE obu_file.*,
    g_obu01_t LIKE obu_file.obu01,
    g_wc,g_sql         STRING,  #No:FUN-580092 HCN 
    g_obu_rowid        LIKE type_file.chr18              #No.FUN-680108 INT 
DEFINE   g_before_input_done LIKE type_file.num5         #No.FUN-680108 SMALLINT

DEFINE   g_forupd_sql   STRING   #SELECT ... FOR UPDATE NOWAIT SQL 
DEFINE   g_cnt          LIKE type_file.num10    #No.FUN-680108 INTEGER
DEFINE   g_chr          LIKE type_file.chr1     #No.FUN-680108 VARCHAR(01)
DEFINE   g_i            LIKE type_file.num5     #count/index for any purpose        #No.FUN-680108 SMALLINT
DEFINE   g_msg          LIKE type_file.chr1000  #No.FUN-680108 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10    #No.FUN-680108 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10    #No.FUN-680108 INTEGER
DEFINE   g_jump         LIKE type_file.num10    #No.FUN-680108 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5     #No.FUN-680108 SMALLINT  #No.FUN-6A0078


MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5    #No.FUN-680108 SMALLINT
#       l_time        LIKE type_file.chr8              #No.FUN-6A0091

    OPTIONS
        FORM LINE     FIRST + 2,
        MESSAGE LINE  LAST,
        PROMPT LINE   LAST,
        INPUT NO WRAP
    DEFER INTERRUPT

    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF

    WHENEVER ERROR CALL cl_err_msg_log

    IF (NOT cl_setup("AXD")) THEN
       EXIT PROGRAM
    END IF
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
    INITIALIZE g_obu.* TO NULL
    INITIALIZE g_obu_t.* TO NULL
    LET g_forupd_sql = " SELECT * FROM obu_file WHERE ROWID = ? FOR UPDATE NOWAIT "
    DECLARE i110_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
    LET p_row = ARG_VAL(1)
    LET p_col = ARG_VAL(2)
    IF p_row = 0 OR p_row IS NULL THEN           # 螢墓位置
        LET p_row = 4
        LET p_col = 12
    END IF
    LET p_row = 5 LET p_col = 25
    OPEN WINDOW axdi110_w AT p_row,p_col
        WITH FORM "axd/42f/axdi110" ATTRIBUTE(STYLE = g_win_style)
    CALL cl_ui_init()
    CALL g_x.clear()


    # 2004/02/23 hjwang: 單檔要做locale的範例
#   WHILE TRUE
       LET g_action_choice = ""
       CALL i110_menu()
#      IF g_action_choice="exit" THEN EXIT WHILE END IF
#   END WHILE
    CLOSE WINDOW axdi110_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
END MAIN

FUNCTION i110_curs()
    CLEAR FORM
   INITIALIZE g_obu.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        obu01,obu02,obu03,obu04,obu05,obu06,obu07,
        obuuser,obugrup,obumodu,obudate,obuacti

       #No:FUN-580031 --start--     HCN
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
       #No:FUN-580031 --end--       HCN

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
 
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
 
       #No:FUN-580031 --start--     HCN
       ON ACTION qbe_select
           CALL cl_qbe_select()
       ON ACTION qbe_save
           CALL cl_qbe_save()
       #No:FUN-580031 --end--       HCN
    END CONSTRUCT
    #資料權限的檢查
    IF g_priv2='4' THEN                           #只能使用自己的資料
        LET g_wc = g_wc clipped," AND obuuser = '",g_user,"'"
    END IF
    IF g_priv3='4' THEN                           #只能使用相同群的資料
        LET g_wc = g_wc clipped," AND obugrup = '",g_grup,"'"
    END IF
    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
        LET g_wc = g_wc clipped," AND obugrup IN ",cl_chk_tgrup_list()
    END IF

    LET g_sql="SELECT ROWID,obu01 FROM obu_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY obu01"
    PREPARE i110_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i110_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i110_prepare
 
    LET g_sql=
        "SELECT COUNT(*) FROM obu_file WHERE ",g_wc CLIPPED
    PREPARE i110_precount FROM g_sql
    DECLARE i110_count CURSOR FOR i110_precount

END FUNCTION


FUNCTION i110_menu()
    MENU ""

        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )

        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i110_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i110_q()
            END IF
        ON ACTION next
            CALL i110_fetch('N')
        ON ACTION previous
            CALL i110_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i110_u()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i110_r()
            END IF
       ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                 CALL i110_copy()
            END IF
       ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth()
               THEN CALL i110_out()
            END IF
       ON ACTION help
           CALL cl_show_help()
       ON ACTION locale
          CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
           EXIT MENU
       ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
       ON ACTION jump
           CALL i110_fetch('/')
       ON ACTION first
           CALL i110_fetch('F')
       ON ACTION last
           CALL i110_fetch('L')
        COMMAND KEY(CONTROL-G)
            CALL cl_cmdask()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
  
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
 
       #No:FUN-6A0165-------add--------str----
       ON ACTION related_document       #相關文件
          LET g_action_choice="related_document"
          IF cl_chk_act_auth() THEN
              IF g_obu.obu01 IS NOT NULL THEN
                 LET g_doc.column1 = "obu01"
                 LET g_doc.value1 = g_obu.obu01
                 CALL cl_doc()
              END IF
          END IF
       #No:FUN-6A0165-------add--------end----
          CONTINUE MENU
 
        -- for Windows close event trapped
        COMMAND KEY(INTERRUPT)
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU

    END MENU
    CLOSE i110_cs
END FUNCTION

FUNCTION i110_a()
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_obu.* LIKE obu_file.*
    LET g_obu01_t = NULL

    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_obu.obuuser = g_user
        LET g_obu.obugrup = g_grup               #使用者所屬群
        LET g_obu.obudate = g_today
        LET g_obu.obuacti = 'Y'
        CALL i110_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_obu.obu01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO obu_file VALUES(g_obu.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
            CALL cl_err(g_obu.obu01,SQLCA.sqlcode,0)
            CONTINUE WHILE
        ELSE
            LET g_obu_t.* = g_obu.*                # 保存上筆資料
            SELECT ROWID INTO g_obu_rowid FROM obu_file
             WHERE obu01 = g_obu.obu01
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION

FUNCTION i110_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,         #No.FUN-680108 VARCHAR(1)
        l_n             LIKE type_file.num5          #No.FUN-680108 SMALLINT

    INPUT BY NAME
        g_obu.obu01,g_obu.obu02,g_obu.obu03,g_obu.obu04,g_obu.obu05,
        g_obu.obu06,g_obu.obu07,g_obu.obuuser,g_obu.obugrup,
        g_obu.obudate,g_obu.obuacti,g_obu.obumodu WITHOUT DEFAULTS HELP 1
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i110_set_entry(p_cmd)
           CALL i110_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE

        AFTER FIELD obu01
          IF g_obu.obu01 IS NOT NULL THEN
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND g_obu.obu01 != g_obu01_t) THEN
               SELECT COUNT(*) INTO l_n FROM obu_file
                WHERE obu01 = g_obu.obu01
               IF l_n > 0 THEN                  # Duplicated
                  CALL cl_err(g_obu.obu01,-239,0)
                  LET g_obu.obu01 = g_obu01_t
                  DISPLAY BY NAME g_obu.obu01 ATTRIBUTE(YELLOW)
                  NEXT FIELD obu01
               END IF
            END IF
          END IF

        AFTER FIELD obu03
          IF g_obu.obu03 IS NOT NULL THEN
            CALL i110_obu03()
          END IF
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 

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
END FUNCTION

FUNCTION i110_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_obu.* TO NULL               #No.FUN-6A0165
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt  #ATTRIBUTE(GREEN)
    CALL i110_curs()                         # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i110_cs                             # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_obu.obu01,SQLCA.sqlcode,0)
        INITIALIZE g_obu.* TO NULL
    ELSE
        OPEN i110_count
        FETCH i110_COUNT INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i110_fetch('F')                 # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION

FUNCTION i110_fetch(p_flzx)
    DEFINE
        p_flzx          LIKE type_file.chr1     #No.FUN-680108 VARCHAR(1)     

    CASE p_flzx
        WHEN 'N' FETCH NEXT     i110_cs INTO g_obu_rowid,g_obu.obu01
        WHEN 'P' FETCH PREVIOUS i110_cs INTO g_obu_rowid,g_obu.obu01
        WHEN 'F' FETCH FIRST    i110_cs INTO g_obu_rowid,g_obu.obu01
        WHEN 'L' FETCH LAST     i110_cs INTO g_obu_rowid,g_obu.obu01
        WHEN '/'
         IF (NOT mi_no_ask) THEN    #No.FUN-6A0078
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
         FETCH ABSOLUTE g_jump i110_cs INTO g_obu_rowid,g_obu.obu01
         LET mi_no_ask = FALSE     #No.FUN-6A0078
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_obu.obu01,SQLCA.sqlcode,0)
        INITIALIZE g_obu.* TO NULL  #TQC-6B0105
        LET g_obu_rowid = NULL      #TQC-6B0105
        RETURN
    ELSE
       CASE p_flzx
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF

    SELECT * INTO g_obu.* FROM obu_file            # 重讀DB,因TEMP有不被更新特性
       WHERE ROWID = g_obu_rowid
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_obu.obu01,SQLCA.sqlcode,0)
    ELSE
         LET g_data_owner=g_obu.obuuser         #FUN-4C0052權限控管
         LET g_data_group=g_obu.obugrup
        CALL i110_show()                        # 重新顯示
    END IF
END FUNCTION

FUNCTION i110_obu03()                           #顯示desc
    DEFINE l_desc    LIKE ze_file.ze03          #No.FUN-680108 VARCHAR(10)

    CASE
      WHEN g_obu.obu03 = '1'
           CALL cl_getmsg('axd-051',g_lang) RETURNING l_desc
      WHEN g_obu.obu03 = '2'
           CALL cl_getmsg('axd-052',g_lang) RETURNING l_desc
      OTHERWISE
           LET l_desc = NULL
    END CASE
    DISPLAY l_desc TO FORMONLY.desc ATTRIBUTE(YELLOW)
END FUNCTION

FUNCTION i110_show()
    LET g_obu_t.* = g_obu.*
    DISPLAY BY NAME
        g_obu.obu01,g_obu.obu02,g_obu.obu03,g_obu.obu04,g_obu.obu05,
        g_obu.obu06,g_obu.obu07,g_obu.obuuser,g_obu.obugrup,
        g_obu.obudate,g_obu.obumodu,g_obu.obuacti
    CALL i110_obu03()
    CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
END FUNCTION

FUNCTION i110_u()
DEFINE l_n      LIKE type_file.num5          #No.FUN-680108 SMALLINT
    IF g_obu.obu01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_obu01_t = g_obu.obu01
    LET g_obu_t.*=g_obu.*
    BEGIN WORK
    OPEN i110_cl USING g_obu_rowid
    IF STATUS THEN
       CALL cl_err("OPEN i110_cl:", STATUS, 1)
       CLOSE i110_cl
       ROLLBACK WORK
       RETURN
    END IF
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_obu.obu01,SQLCA.sqlcode,0)
        RETURN
    END IF
    FETCH i110_cl INTO g_obu.*               # 對DB鎖定
    LET g_obu.obumodu = g_user                   #修改者
    LET g_obu.obudate = g_today                  #修改日期
    CALL i110_show()                             #顯示最新資料
    WHILE TRUE
        CALL i110_i("u")                         #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_obu.*=g_obu_t.*
            CALL i110_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE obu_file SET obu_file.* = g_obu.*    # 更新DB
         WHERE ROWID = g_obu_rowid
        IF SQLCA.sqlcode THEN
            CALL cl_err(g_obu.obu01,SQLCA.sqlcode,0)
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i110_cl
    COMMIT WORK
END FUNCTION

FUNCTION i110_r()
    DEFINE l_chr       LIKE type_file.chr1        #No.FUN-680108 VARCHAR(1)

    IF g_obu.obu01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    BEGIN WORK
    OPEN i110_cl USING g_obu_rowid
    IF STATUS THEN
       CALL cl_err("OPEN i110_cl:", STATUS, 1)
       CLOSE i110_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i110_cl INTO g_obu.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_obu.obu01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i110_show()
    IF cl_delete() THEN
        DELETE FROM obu_file WHERE ROWID = g_obu_rowid
        IF SQLCA.sqlcode THEN
            CALL cl_err(g_obu.obu01,SQLCA.sqlcode,0)
        ELSE
            CLEAR FORM
            INITIALIZE g_obu.* LIKE obu_file.*
            OPEN i110_count
            FETCH i110_count INTO g_row_count
            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN i110_cs
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL i110_fetch('L')
            ELSE
               LET g_jump = g_curs_index
               LET mi_no_ask = TRUE   #No.FUN-6A0078
               CALL i110_fetch('/')
            END IF
        END IF
    END IF
    CLOSE i110_cl
    COMMIT WORK
END FUNCTION

FUNCTION i110_copy()
    DEFINE
        l_n                     LIKE type_file.num5,          #No.FUN-680108 SMALLINT
        l_newno,l_oldno         LIKE obu_file.obu01

    IF g_obu.obu01 IS NULL THEN  CALL cl_err('',-400,0) RETURN END IF
    CALL cl_getmsg('copy',g_lang) RETURNING g_msg
    DISPLAY g_msg AT 2,1 ATTRIBUTE(RED)
    LET g_before_input_done = FALSE   #FUN-580028
    CALL i110_set_entry('a')          #FUN-580028
    LET g_before_input_done = TRUE    #FUN-580028
    INPUT l_newno FROM obu01
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i110_set_entry("a")
           LET g_before_input_done = TRUE

         AFTER FIELD obu01
            SELECT COUNT(*) INTO l_n FROM obu_file WHERE obu01 = l_newno
            IF l_n > 0 THEN
               CALL cl_err(l_newno,-239,0)
               NEXT FIELD obu01
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
    IF INT_FLAG OR l_newno IS NULL THEN LET INT_FLAG = 0 RETURN END IF

    DROP TABLE x
    SELECT * FROM obu_file
        WHERE ROWID=g_obu_rowid
        INTO TEMP x
    UPDATE x
        SET obu01=l_newno,    #資料鍵值
            obuuser=g_user,   #資料所有者
            obugrup=g_grup,   #資料所有者所屬群
            obumodu=NULL,     #資料修改日期
            obudate=g_today   #資料建立日期
    INSERT INTO obu_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_obu.obu01,SQLCA.sqlcode,0)
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K' ATTRIBUTE(REVERSE)
    END IF
 
    LET l_oldno = g_obu.obu01
    SELECT ROWID,obu_file.* INTO g_obu_rowid,g_obu.* FROM obu_file
              WHERE obu01 =  l_newno
    LET g_obu.obu01 = l_newno
    CALL i110_u()
    CALL i110_show()
    SELECT ROWID,obu_file.* INTO g_obu_rowid,g_obu.* FROM obu_file
     WHERE obu01 = g_obu.obu01
    CALL i110_show()
END FUNCTION

FUNCTION i110_out()
    DEFINE
        l_i             LIKE type_file.num5,     #No.FUN-680108 SMALLINT
        l_name          LIKE type_file.chr20,    # External(Disk) file name #No.FUN-680108 VARCHAR(20)
        l_za05          LIKE za_file.za05,       #MOD-4B0067
        l_chr           LIKE type_file.chr1      #No.FUN-680108 VARCHAR(1)
 
    IF cl_null(g_wc) AND NOT cl_null(g_obu.obu01) THEN
       LET g_wc = " obu01 = '",g_obu.obu01,"'"
    END IF
    IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
    CALL cl_outnam('axdi110') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM obu_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED
    PREPARE i110_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i110_curo                         # SCROLL CURSOR
         CURSOR FOR i110_p1

    START REPORT i110_rep TO l_name

    FOREACH i110_curo INTO g_obu.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        OUTPUT TO REPORT i110_rep(g_obu.*)
    END FOREACH

    FINISH REPORT i110_rep

    CLOSE i110_curo
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION

REPORT i110_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,    #No.FUN-680108 VARCHAR(1)
        sr     RECORD LIKE obu_file.*,
        l_chr           LIKE type_file.chr1,    #No.FUN-680108 VARCHAR(1)
        l_desc1         LIKE type_file.chr20    #No.FUN-680108 VARCHAR(20)
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line

    ORDER BY sr.obu01

    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED

            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED, pageno_total
 
            PRINT COLUMN (((g_len-FGL_WIDTH(g_x[1])))/2)+1 ,g_x[1]
            PRINT
            PRINT g_dash[1,g_len]

            PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35]
            PRINT g_dash1
            LET l_trailer_sw = 'y'

            CASE sr.obu03
                 WHEN '1' CALL cl_getmsg('axd-051',g_lang) RETURNING l_desc1
                 WHEN '2' CALL cl_getmsg('axd-052',g_lang) RETURNING l_desc1
            END CASE

   BEFORE GROUP OF sr.obu01
         SKIP TO TOP OF PAGE

            PRINTX name=D1 COLUMN g_c[31],sr.obu01,
                           COLUMN g_c[32],sr.obu02,
                           COLUMN g_c[33],sr.obu03,
                           COLUMN g_c[34],l_desc1,
                           COLUMN g_c[35],sr.obu04

            PRINTX name=D2 COLUMN g_c[35],sr.obu05
            PRINTX name=D3 COLUMN g_c[35],sr.obu06
            PRINTX name=D4 COLUMN g_c[35],sr.obu07

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

FUNCTION i110_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)

   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("obu01",TRUE)
   END IF
END FUNCTION

FUNCTION i110_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)

   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("obu01",FALSE)
  END IF
END FUNCTION

