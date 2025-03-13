# Prog. Version..: '5.10.00-08.01.04(00000)'     #
# Pattern name...: axdi112.4gl
# Descriptions...: 車輛基本資料維護作業
# Date & Author..: 2003/12/02 By Leagh
# Modify.........: No:MOD-4A0329 04/10/27 By Carrier
# Modify.........: No.MOD-4B0067 04/11/15 By Elva 將變數用Like方式定義,報表拉成一行
# Modify.........: No:FUN-4C0052 04/12/08 By pengu Data and Group權限控管
# Modify.........: No:FUN-520024 05/02/24 By Day 報表轉XML
# Modify.........: No.MOD-540145 05/05/10 By vivien  刪除HELP FILE
# Modify.........: No:MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能monster代
# Modify.........: No.TQC-660099 06/06/21 By Mandy TQC-630166的MARK不要用{}改用#
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
    g_obw               RECORD LIKE obw_file.*,
    g_obw_t             RECORD LIKE obw_file.*,
    g_obw01_t           LIKE obw_file.obw01,
     #g_desc            LIKE type_file.chr1000, #No.FUN-680108 VARCHAR(04)
     #g_desc1           LIKE type_file.chr1000, #No.FUN-680108 VARCHAR(06)
    g_wc,g_sql          STRING,#TQC-630166    
    g_obw_rowid         LIKE type_file.chr18,   #No.FUN-680108 INT
    p_row,p_col         LIKE type_file.num5     #No.FUN-680108 SMALLINT
DEFINE   g_before_input_done LIKE type_file.num5    #No.FUN-680108 SMALLINT

DEFINE   g_forupd_sql   STRING   #SELECT ... FOR UPDATE NOWAIT SQL 
DEFINE   g_cnt          LIKE type_file.num10    #No.FUN-680108 INTEGER
DEFINE   g_chr          LIKE type_file.chr1     #No.FUN-680108 VARCHAR(01)
DEFINE   g_i            LIKE type_file.num5     #count/index for any purpose        #No.FUN-680108 SMALLINT
DEFINE   g_msg          LIKE type_file.chr1000  #No.FUN-680108 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10    #No.FUN-680108 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10    #No.FUN-680108 INTEGER
DEFINE   g_jump         LIKE type_file.num10    #No.FUN-680108 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5     #No.FUN-680108 SMALLINT    #No.FUN-6A0078

MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5    #No.FUN-680108 SMALLINT
#       l_time        LIKE type_file.chr8              #No.FUN-6A0091

    OPTIONS
        FORM LINE     FIRST + 2,               #畫面開始的位置
        MESSAGE LINE  LAST,                    #訊息顯示的位置
        PROMPT LINE   LAST,                    #提示訊息的位置
        INPUT NO WRAP                          #輸入的方式: 不打轉
        DEFER INTERRUPT                        #擷取中斷鍵
    WHENEVER ERROR CONTINUE                    #忽略一切錯誤

    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF

    WHENEVER ERROR CALL cl_err_msg_log

    IF (NOT cl_setup("AXD")) THEN
       EXIT PROGRAM
    END IF
    LET p_row = ARG_VAL(1)
    LET p_col = ARG_VAL(2)
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
    INITIALIZE g_obw.* TO NULL
    LET g_forupd_sql = " SELECT * FROM obw_file WHERE ROWID = ? FOR UPDATE NOWAIT "
    DECLARE i112_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
    LET p_row = 2 LET p_col=15

    OPEN WINDOW i112_w AT p_row,p_col
        WITH FORM "axd/42f/axdi112" ATTRIBUTE(STYLE = g_win_style)
    CALL cl_ui_init()
    CALL g_x.clear()


    # 2004/02/23 hjwang: 單檔要做locale的範例
#    WHILE TRUE
       LET g_action_choice = ""
       CALL i112_menu()
#       IF g_action_choice="exit" THEN EXIT WHILE END IF
#    END WHILE
    CLOSE WINDOW i112_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
END MAIN

FUNCTION i112_curs()
    CLEAR FORM
   INITIALIZE g_obw.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取條件
 #MOD-4A0329  --begin
        obw01,obw05,obw02,obw03,obw04,obw08,obw09,obw10,
        obw06,obw07,obw26,obw25,obw11,obw12,obw13,obw14,
        obw16,obw17,obw18,obw19,obw21,obw22,obw23,obw24,obw20,
        obwuser,obwgrup,obwmodu,obwdate,obwacti
 #MOD-4A0329  --end

        #No:FUN-580031 --start--     HCN
        BEFORE CONSTRUCT
           CALL cl_qbe_init()
        #No:FUN-580031 --end--       HCN

        ON ACTION CONTROLP                       # 沿用所有欄位
            CASE
                WHEN INFIELD(obw02)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_obq"
                     LET g_qryparam.state ="c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO obw02
                     NEXT FIELD obw02
                WHEN INFIELD(obw03)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_obs"
                     LET g_qryparam.state ="c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO obw03
                     NEXT FIELD obw03
                WHEN INFIELD(obw04)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_obt"
                     LET g_qryparam.state ="c"
                     LET g_qryparam.default1 = g_obw.obw04
                     LET g_qryparam.arg1 = g_obw.obw03
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO obw04
                     NEXT FIELD obw04
                WHEN INFIELD(obw05)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state ="c"
                     LET g_qryparam.form ="q_obr"
                     LET g_qryparam.default1 = g_obw.obw05
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO obw05
                     NEXT FIELD obw05
                WHEN INFIELD(obw14)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gen"
                     LET g_qryparam.state ="c"
                     LET g_qryparam.default1 = g_obw.obw14
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO obw14
                     NEXT FIELD obw14
 #MOD-4A0329  --begin
           #     WHEN INFIELD(obw15)
           #          CALL cl_init_qry_var()
           #          LET g_qryparam.form ="q_obv"
           #          LET g_qryparam.state ="c"
           #          LET g_qryparam.default1 = g_obw.obw15
           #          CALL cl_create_qry() RETURNING g_qryparam.multiret
           #          DISPLAY g_qryparam.multiret TO obw15
           #          NEXT FIELD obw15
 #MOD-4A0329  --end
                WHEN INFIELD(obw16)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gen"
                     LET g_qryparam.state ="c"
                     LET g_qryparam.default1 = g_obw.obw16
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO obw16
                     NEXT FIELD obw16
                WHEN INFIELD(obw17)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gen"
                     LET g_qryparam.state ="c"
                     LET g_qryparam.default1 = g_obw.obw17
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO obw17
                     NEXT FIELD obw17
                WHEN INFIELD(obw18)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state ="c"
                     LET g_qryparam.form ="q_gen"
                     LET g_qryparam.default1 = g_obw.obw18
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO obw18
                     NEXT FIELD obw18
                WHEN INFIELD(obw19)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gen"
                     LET g_qryparam.state ="c"
                     LET g_qryparam.default1 = g_obw.obw19
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO obw19
                     NEXT FIELD obw19
                WHEN INFIELD(obw20)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_obz"
                     LET g_qryparam.state ="c"
                     LET g_qryparam.default1 = g_obw.obw20
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO obw20
                     NEXT FIELD obw20
                WHEN INFIELD(obw23)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_faj"
                     LET g_qryparam.state ="c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO obw23
                     NEXT FIELD obw23
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
 
       #No:FUN-580031 --start--     HCN
       ON ACTION qbe_select
           CALL cl_qbe_select()
       ON ACTION qbe_save
           CALL cl_qbe_save()
       #No:FUN-580031 --end--       HCN
    END CONSTRUCT
    #資料權限的檢查
    IF g_priv2='4' THEN                           #只能使用自己的資料
       LET g_wc = g_wc CLIPPED," AND obwuser = '",g_user,"'"
    END IF
    IF g_priv3='4' THEN                           #只能使用相同群的資料
       LET g_wc = g_wc CLIPPED," AND obwgrup MATCHES '",g_grup CLIPPED,"*'"
    END IF

    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
       LET g_wc = g_wc CLIPPED," AND obwgrup IN ",cl_chk_tgrup_list()
    END IF

    LET g_sql="SELECT ROWID,obw01 FROM obw_file ", # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED," ORDER BY obw01"
    PREPARE i112_prepare FROM g_sql
    DECLARE i112_cs                                # SCROLL CURSOR
     SCROLL CURSOR WITH HOLD FOR i112_prepare
    LET g_sql= "SELECT COUNT(*) FROM obw_file WHERE ",g_wc CLIPPED
    PREPARE i112_precount FROM g_sql
    DECLARE i112_count CURSOR FOR i112_precount
END FUNCTION

FUNCTION i112_menu()
    MENU ""

        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )

        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i112_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                CALL i112_q()
            END IF
        ON ACTION next
            CALL i112_fetch('N')
        ON ACTION previous
            CALL i112_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i112_u()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i112_r()
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
               CALL i112_x()
            END IF
        ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                CALL i112_copy()
            END IF
        ON ACTION output
           LET g_action_choice="output"
           IF cl_chk_act_auth()
               THEN CALL i112_out()
           END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
#       ON ACTION cancel
#          LET g_action_choice="exit"
#          EXIT MENU

        ON ACTION jump
            CALL i112_fetch('/')
        ON ACTION first
            CALL i112_fetch('F')
        ON ACTION last
            CALL i112_fetch('L')
        ON ACTION controlg
            CALL cl_cmdask()
        ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
            EXIT MENU
        COMMAND KEY(CONTROL-G)
            CALL cl_cmdask()
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121

        #No:FUN-6A0165-------add--------str----
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
               IF g_obw.obw01 IS NOT NULL THEN
                  LET g_doc.column1 = "obw01"
                  LET g_doc.value1 = g_obw.obw01
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
    CLOSE i112_cs
END FUNCTION

FUNCTION i112_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                   # 清螢幕欄位內容
    INITIALIZE g_obw.* LIKE obw_file.*
    LET g_obw01_t = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_obw.obw06 = '1'                    # 所有權
        LET g_obw.obw07 = '1'                    # 狀態
        LET g_obw.obw11 = g_today                # 出廠日期
        LET g_obw.obw12 = g_today                # 購買日期
        LET g_obw.obwacti = 'Y'                  # 有效否
        LET g_obw.obwuser = g_user               # 使用者
        LET g_obw.obwgrup = g_grup               # 使用者所屬群
        LET g_obw.obwmodu = ''                   # 更改者
        LET g_obw.obwdate = g_today
        CALL i112_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_obw.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_obw.obw01 IS NULL THEN              # KEY 不可空白
           CONTINUE WHILE
        END IF
        INSERT INTO obw_file VALUES(g_obw.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
           CALL cl_err(g_obw.obw01,SQLCA.sqlcode,0)
           CONTINUE WHILE
        ELSE
           SELECT ROWID INTO g_obw_rowid FROM obw_file
            WHERE obw01 = g_obw.obw01
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION

FUNCTION i112_i(p_cmd)
    DEFINE
        p_cmd          LIKE type_file.chr1,      #No.FUN-680108 VARCHAR(1)
        l_n            LIKE type_file.num5       #No.FUN-680108 SMALLINT

    INPUT BY NAME
 #MOD-4A0329  --begin
        g_obw.obw01,g_obw.obw05,g_obw.obw02,g_obw.obw03,g_obw.obw04,
        g_obw.obw08,g_obw.obw09,g_obw.obw10,g_obw.obw06,g_obw.obw07,
        g_obw.obw25,g_obw.obw11,g_obw.obw12,
        g_obw.obw13,g_obw.obw14,
        g_obw.obw16,g_obw.obw17,g_obw.obw18,g_obw.obw19,
        g_obw.obw21,g_obw.obw22,g_obw.obw23,g_obw.obw24,g_obw.obw20,
        g_obw.obwuser,g_obw.obwgrup,g_obw.obwmodu,g_obw.obwdate,
        g_obw.obwacti WITHOUT DEFAULTS HELP 1
 #MOD-4A0329  --end

        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i112_set_entry(p_cmd)
           CALL i112_set_no_entry(p_cmd)
            CALL i112_set_no_required()  #MOD-4A0329
            CALL i112_set_required()  #MOD-4A0329
           LET g_before_input_done = TRUE

        AFTER FIELD obw01                        # 車輛代號
          IF g_obw.obw01 IS NOT NULL THEN
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND g_obw.obw01 != g_obw01_t) THEN
                SELECT COUNT(*) INTO l_n FROM obw_file
                 WHERE obw01 = g_obw.obw01
                IF l_n > 0 THEN                  # Duplicated
                    CALL cl_err(g_obw.obw01,-239,0)
                    LET g_obw.obw01 = g_obw01_t
                    DISPLAY BY NAME g_obw.obw01
                    NEXT FIELD obw01
                END IF
            END IF
          END IF
 
        AFTER FIELD obw02                        # 車輛類型
          IF NOT cl_null(g_obw.obw02) THEN
            IF p_cmd='a' OR (p_cmd='u' OR g_obw.obw02 != g_obw_t.obw02) THEN
               SELECT obq01 FROM obq_file WHERE obq01 = g_obw.obw02
               IF STATUS THEN
                  CALL cl_err(g_obw.obw02,STATUS,0) NEXT FIELD obw02
               END IF
            END IF
          END IF

        AFTER FIELD obw03                        # 廠牌
          IF NOT cl_null(g_obw.obw03) THEN
            IF p_cmd='a' OR (p_cmd='u' OR g_obw.obw03 != g_obw_t.obw03) THEN
               SELECT obs01 FROM obs_file WHERE obs01 = g_obw.obw03
               IF STATUS THEN
                  CALL cl_err(g_obw.obw03,STATUS,0) NEXT FIELD obw03
               END IF
            END IF
          END IF

        AFTER FIELD obw04                       # 型號
          IF NOT cl_null(g_obw.obw04) THEN
            IF p_cmd='a' OR (p_cmd='u' OR g_obw.obw04 != g_obw_t.obw04) THEN
               SELECT obt01 FROM obt_file
                WHERE obt01 = g_obw.obw03 AND obt02 = g_obw.obw04
               IF STATUS THEN
                  CALL cl_err(g_obw.obw04,STATUS,0) NEXT FIELD obw04
               END IF
            END IF
          END IF

        AFTER FIELD obw05                       # 級別
          IF NOT cl_null(g_obw.obw05) THEN
            IF p_cmd='a' OR (p_cmd='u' OR g_obw.obw05 != g_obw_t.obw05) THEN
               SELECT obr01 FROM obr_file WHERE obr01 = g_obw.obw05
               IF STATUS THEN
                  CALL cl_err(g_obw.obw05,STATUS,0) NEXT FIELD obw05
               END IF
            END IF
          END IF

 #MOD-4A0329  --begin
        BEFORE FIELD obw06
           CALL i112_set_entry(p_cmd)
           CALL i112_set_no_required()

        AFTER FIELD obw06                       # 所有權
#          IF NOT cl_null(g_obw.obw06) THEN
#             CALL i112_desc(g_obw.obw06)
#          END IF
           CALL i112_set_no_entry(p_cmd)
           CALL i112_set_required()
{
        AFTER FIELD obw07                       # 狀態
          IF NOT cl_null(g_obw.obw07) THEN
             CALL i112_desc1(g_obw.obw07)
          END IF

        AFTER FIELD obw11                       # 出廠日期
            IF g_obw.obw06 = '1' AND cl_null(g_obw.obw11) THEN
               NEXT FIELD obw11
            END IF

        AFTER FIELD obw12                       #購買日期
            IF g_obw.obw06 = '1' AND cl_null(g_obw.obw12) THEN
               NEXT FIELD obw12
            END IF
}
 #MOD-4A0329  --end

        AFTER FIELD obw14                       # 保管人
          IF NOT cl_null(g_obw.obw14) THEN
            IF p_cmd='a' OR (p_cmd='u' OR g_obw.obw14 != g_obw_t.obw14) THEN
               CALL i112_gen02('obw14')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_obw.obw14,g_errno,0) NEXT FIELD obw14
               END IF
            END IF
          END IF

 #MOD-4A0329  --begin
#        AFTER FIELD obw15                       # 保養組
#            IF g_obw.obw06 = '1' AND cl_null(g_obw.obw15) THEN
#               NEXT FIELD obw15
#            END IF
#            IF p_cmd = 'a' OR
#              (p_cmd = 'u' AND g_obw.obw15 != g_obw_t.obw15) THEN
#               SELECT UNIQUE obv012 INTO g_msg FROM obv_file
#                WHERE obv01 = g_obw.obw15
#               IF STATUS THEN
#                  CALL cl_err(g_obw.obw15,STATUS,0) NEXT FIELD obw15
#               END IF
#               DISPLAY g_msg TO obv012
#            END IF
 #MOD-4A0329  --end

        AFTER FIELD obw16                       # 駕駛員
            IF NOT cl_null(g_obw.obw16) THEN
               CALL i112_gen02('obw16')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_obw.obw16,g_errno,0) NEXT FIELD obw16
               END IF
            END IF

        AFTER FIELD obw17                      # 隨車人員
            IF NOT cl_null(g_obw.obw17) THEN
               CALL i112_gen02('obw17')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_obw.obw17,g_errno,0) NEXT FIELD obw17
               END IF
            END IF

        AFTER FIELD obw18                     # 隨車人員
            IF NOT cl_null(g_obw.obw18) THEN
               CALL i112_gen02('obw18')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_obw.obw18,g_errno,0) NEXT FIELD obw18
               END IF
            END IF

        AFTER FIELD obw19                     # 隨車人員
            IF NOT cl_null(g_obw.obw19) THEN
               CALL i112_gen02('obw19')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_obw.obw19,g_errno,0) NEXT FIELD obw19
               END IF
            END IF

        AFTER FIELD obw20                    # 車隊代號
          IF NOT cl_null(g_obw.obw20) THEN
            IF p_cmd='a' OR (p_cmd='u' OR g_obw.obw20 != g_obw_t.obw20) THEN
               SELECT obz01 FROM obz_file WHERE obz01 = g_obw.obw20
               IF STATUS THEN
                  CALL cl_err(g_obw.obw20,STATUS,0)
                  NEXT FIELD obw20
               END IF
            END IF
          END IF

 #MOD-4A0329  --begin
{        AFTER FIELD obw21                    # 外租車計價方式
          IF NOT cl_null(g_obw.obw21) THEN
            IF g_obw.obw06 ='1' THEN
               IF g_obw.obw21 NOT MATCHES '[123]' THEN
                  NEXT FIELD obw21
               END IF
            END IF
            IF g_obw.obw06 = '2' THEN
               IF cl_null(g_obw.obw21) OR g_obw.obw21 NOT MATCHES '[123]' THEN
                  NEXT FIELD obw21
               END IF
            END IF
             #CALL i112_desc2(g_obw.obw21) #MOD-4A0329
          END IF

        AFTER FIELD obw22                    # 外租車單位金額
            IF g_obw.obw06 = '2' AND cl_null(g_obw.obw22) THEN
               NEXT FIELD obw22
            END IF

        AFTER FIELD obw23                    # 財產編號
            IF g_obw.obw06 = '1' AND cl_null(g_obw.obw23) THEN
               NEXT FIELD obw23
            END IF
}
 #MOD-4A0329  --end
        AFTER FIELD obw24                    # 財產編號
            IF cl_null(g_obw.obw24) THEN
               LET g_obw.obw24 = ' '
            END IF
            IF NOT cl_null(g_obw.obw23) OR NOT cl_null(g_obw.obw24) THEN
               SELECT faj01 FROM faj_file
                WHERE faj02 = g_obw.obw23 AND faj022 = g_obw.obw24
               IF STATUS THEN
                  CALL cl_err(g_obw.obw23,'afa-911',0)
                  NEXT FIELD obw23
               END IF
            END IF

        ON ACTION CONTROLP                       # 沿用所有欄位
            CASE
                WHEN INFIELD(obw02)
                #    CALL q_obq(0,0,g_obw.obw02) RETURNING g_obw.obw02
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_obq"
                     LET g_qryparam.default1 = g_obw.obw02
                     CALL cl_create_qry() RETURNING g_obw.obw02
                     DISPLAY BY NAME g_obw.obw02
                     NEXT FIELD obw02
                WHEN INFIELD(obw03)
                #    CALL q_obs(0,0,g_obw.obw03) RETURNING g_obw.obw03
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_obs"
                     LET g_qryparam.default1 = g_obw.obw03
                     CALL cl_create_qry() RETURNING g_obw.obw03
                     DISPLAY BY NAME g_obw.obw03
                     NEXT FIELD obw03
                WHEN INFIELD(obw04)
                #    CALL q_obt(0,0,g_obw.obw04,g_obw.obw03)
                #         RETURNING g_obw.obw04
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_obt"
                     LET g_qryparam.default1 = g_obw.obw04
                     LET g_qryparam.arg1 = g_obw.obw03
                     CALL cl_create_qry() RETURNING g_obw.obw04
                     DISPLAY BY NAME g_obw.obw04
                     NEXT FIELD obw04
                WHEN INFIELD(obw05)
                #    CALL q_obr(0,0,g_obw.obw05) RETURNING g_obw.obw05
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_obr"
                     LET g_qryparam.default1 = g_obw.obw05
                     CALL cl_create_qry() RETURNING g_obw.obw05
                     DISPLAY BY NAME g_obw.obw05
                     NEXT FIELD obw05
                WHEN INFIELD(obw14)
                #    CALL q_gen(0,0,g_obw.obw14) RETURNING g_obw.obw14
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gen"
                     LET g_qryparam.default1 = g_obw.obw14
                     CALL cl_create_qry() RETURNING g_obw.obw14
                     DISPLAY BY NAME g_obw.obw14
                     NEXT FIELD obw14
 #MOD-4A0329  --begin
#                WHEN INFIELD(obw15)
#                #    CALL q_obv(0,0,g_obw.obw15) RETURNING g_obw.obw15
#                     CALL cl_init_qry_var()
#                     LET g_qryparam.form ="q_obv"
#                     LET g_qryparam.default1 = g_obw.obw15
#                     CALL cl_create_qry() RETURNING g_obw.obw15
#                     DISPLAY BY NAME g_obw.obw15
#                     NEXT FIELD obw15
 #MOD-4A0329  --end
                WHEN INFIELD(obw16)
                #    CALL q_gen(0,0,g_obw.obw16) RETURNING g_obw.obw16
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gen"
                     LET g_qryparam.default1 = g_obw.obw16
                     CALL cl_create_qry() RETURNING g_obw.obw16
                     DISPLAY BY NAME g_obw.obw16
                     NEXT FIELD obw16
                WHEN INFIELD(obw17)
                #    CALL q_gen(0,0,g_obw.obw17) RETURNING g_obw.obw17
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gen"
                     LET g_qryparam.default1 = g_obw.obw17
                     CALL cl_create_qry() RETURNING g_obw.obw17
                     DISPLAY BY NAME g_obw.obw17
                     NEXT FIELD obw17
                WHEN INFIELD(obw18)
                #    CALL q_gen(0,0,g_obw.obw18) RETURNING g_obw.obw18
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gen"
                     LET g_qryparam.default1 = g_obw.obw18
                     CALL cl_create_qry() RETURNING g_obw.obw18
                     DISPLAY BY NAME g_obw.obw18
                     NEXT FIELD obw18
                WHEN INFIELD(obw19)
                #    CALL q_gen(0,0,g_obw.obw19) RETURNING g_obw.obw19
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gen"
                     LET g_qryparam.default1 = g_obw.obw19
                     CALL cl_create_qry() RETURNING g_obw.obw19
                     DISPLAY BY NAME g_obw.obw19
                     NEXT FIELD obw19
                WHEN INFIELD(obw20)
                #    CALL q_obz(0,0,g_obw.obw20) RETURNING g_obw.obw20
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_obz"
                     LET g_qryparam.default1 = g_obw.obw20
                     CALL cl_create_qry() RETURNING g_obw.obw20
                     DISPLAY BY NAME g_obw.obw20
                     NEXT FIELD obw20
                WHEN INFIELD(obw23)
                #    CALL q_faj(0,0,g_obw.obw23,g_obw.obw24)
                #         RETURNING g_obw.obw23,g_obw.obw24
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_faj"
                     LET g_qryparam.default1 = g_obw.obw23
                     LET g_qryparam.default2 = g_obw.obw24
                     CALL cl_create_qry() RETURNING g_obw.obw23,g_obw.obw24
#                     CALL FGL_DIALOG_SETBUFFER( g_obw.obw23 )
#                     CALL FGL_DIALOG_SETBUFFER( g_obw.obw24 )
                     DISPLAY BY NAME g_obw.obw23,g_obw.obw24
                     NEXT FIELD obw23
               OTHERWISE
                    EXIT CASE
            END CASE
      #MOD-650015 --start
      #  ON ACTION CONTROLO                       # 沿用所有欄位
      #      IF INFIELD(obw01) THEN
      #          LET g_obw.* = g_obw_t.*
      #          CALL i112_show()
      #          NEXT FIELD obw01
      #      END IF
      #MOD-650015 --start

        ON ACTION CONTROLZ
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
            CALL cl_cmdask()

        ON ACTION CONTROLF                       # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 

        AFTER INPUT
            IF INT_FLAG THEN EXIT INPUT END IF

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
    END INPUT
END FUNCTION

FUNCTION i112_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_obw.* TO NULL            #No.FUN-6A0165 
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i112_curs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i112_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_obw.obw01,SQLCA.sqlcode,0)
        INITIALIZE g_obw.* TO NULL
    ELSE
        OPEN i112_count
        FETCH i112_COUNT INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i112_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION

FUNCTION i112_fetch(p_flobw)
    DEFINE
        p_flobw          LIKE type_file.chr1     #No.FUN-680108 VARCHAR(1)

    CASE p_flobw
        WHEN 'N' FETCH NEXT     i112_cs INTO g_obw_rowid,g_obw.obw01
        WHEN 'P' FETCH PREVIOUS i112_cs INTO g_obw_rowid,g_obw.obw01
        WHEN 'F' FETCH FIRST    i112_cs INTO g_obw_rowid,g_obw.obw01
        WHEN 'L' FETCH LAST     i112_cs INTO g_obw_rowid,g_obw.obw01
        WHEN '/'
         IF (NOT mi_no_ask) THEN   #No.FUN-6A0078
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
         FETCH ABSOLUTE g_jump i112_cs INTO g_obw_rowid,g_obw.obw01
         LET mi_no_ask = FALSE   #No.FUN-6A0078
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_obw.obw01,SQLCA.sqlcode,0)
        INITIALIZE g_obw.* TO NULL  #TQC-6B0105
        LET g_obw_rowid = NULL      #TQC-6B0105
        RETURN
    ELSE
       CASE p_flobw
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF

    SELECT * INTO g_obw.* FROM obw_file    # 重讀DB,因TEMP有不被更新特性
       WHERE ROWID = g_obw_rowid
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_obw.obw01,SQLCA.sqlcode,0)
    ELSE
        LET g_data_owner=g_obw.obwuser           #FUN-4C0052權限控管
        LET g_data_group=g_obw.obwgrup
        CALL i112_show()                   # 重新顯示
    END IF
END FUNCTION

FUNCTION i112_show()
    LET g_obw_t.* = g_obw.*
 #MOD-4A0329  --begin
    DISPLAY BY NAME
        g_obw.obw01,g_obw.obw02,g_obw.obw03,g_obw.obw04,g_obw.obw05,
        g_obw.obw06,g_obw.obw07,g_obw.obw08,g_obw.obw09,g_obw.obw10,
        g_obw.obw11,g_obw.obw12,g_obw.obw13,g_obw.obw14,g_obw.obw26,
        g_obw.obw16,g_obw.obw17,g_obw.obw18,g_obw.obw19,g_obw.obw20,
        g_obw.obw21,g_obw.obw22,g_obw.obw23,g_obw.obw24,g_obw.obw25,
        g_obw.obwacti,g_obw.obwuser,g_obw.obwgrup,g_obw.obwmodu,
        g_obw.obwdate
#    CALL i112_desc(g_obw.obw06)
#    CALL i112_desc1(g_obw.obw07)
#    CALL i112_desc2(g_obw.obw21)
 #MOD-4A0329  --end
    CALL i112_gen02('obw14')
    CALL i112_gen02('obw16')
    CALL i112_gen02('obw17')
    CALL i112_gen02('obw18')
    CALL i112_gen02('obw19')
 #MOD-4A0329  --begin
#    SELECT UNIQUE obv012 INTO g_msg FROM obv_file WHERE obv01 = g_obw.obw15
#    DISPLAY g_msg TO obv012
 #MOD-4A0329  --end
    CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
END FUNCTION

FUNCTION i112_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_obw.obw01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_obw.* FROM obw_file WHERE obw01=g_obw.obw01
    IF g_obw.obwacti = 'N' THEN CALL cl_err('',9027,0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_obw01_t = g_obw.obw01
    BEGIN WORK
    OPEN i112_cl USING g_obw_rowid
    IF STATUS THEN
       CALL cl_err("OPEN i112_cl:", STATUS, 1)
       CLOSE i112_cl
       ROLLBACK WORK
       RETURN
    END IF
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_obw.obw01,SQLCA.sqlcode,0)
        RETURN
    END IF
    FETCH i112_cl INTO g_obw.*               # 對DB鎖定
    LET g_obw.obwmodu=g_user                  #修改者
    LET g_obw.obwdate = g_today               #修改日期
    CALL i112_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i112_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_obw.*=g_obw_t.*
            CALL i112_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE obw_file SET obw_file.* = g_obw.*    # 更新DB
         WHERE ROWID = g_obw_rowid
        IF SQLCA.sqlcode THEN
            CALL cl_err(g_obw.obw01,SQLCA.sqlcode,0)
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i112_cl
    COMMIT WORK
END FUNCTION

FUNCTION i112_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_obw.obw01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    BEGIN WORK
    OPEN i112_cl USING g_obw_rowid
    IF STATUS THEN
       CALL cl_err("OPEN i112_cl:", STATUS, 1)
       CLOSE i112_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i112_cl INTO g_obw.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_obw.obw01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i112_show()
    IF cl_exp(0,0,g_obw.obwacti) THEN
        LET g_chr=g_obw.obwacti
        IF g_obw.obwacti='Y' THEN
            LET g_obw.obwacti='N'
        ELSE
            LET g_obw.obwacti='Y'
        END IF
        UPDATE obw_file
            SET obwacti=g_obw.obwacti
            WHERE ROWID=g_obw_rowid
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(g_obw.obw01,SQLCA.sqlcode,0)
            LET g_obw.obwacti=g_chr
        END IF
        DISPLAY BY NAME g_obw.obwacti
    END IF
    CLOSE i112_cl
    COMMIT WORK
END FUNCTION

FUNCTION i112_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_obw.obw01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    BEGIN WORK
    OPEN i112_cl USING g_obw_rowid
    IF STATUS THEN
       CALL cl_err("OPEN i112_cl:", STATUS, 1)
       CLOSE i112_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i112_cl INTO g_obw.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_obw.obw01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i112_show()
    IF cl_delete() THEN
       DELETE FROM obw_file WHERE obw01 = g_obw.obw01
       CLEAR FORM
       OPEN i112_count
       FETCH i112_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i112_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i112_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE    #No.FUN-6A0078
          CALL i112_fetch('/')
       END IF
    END IF
    CLOSE i112_cl
    COMMIT WORK
END FUNCTION

FUNCTION i112_copy()
DEFINE l_newno1,l_oldno1  LIKE obw_file.obw01,
       l_n                LIKE type_file.num5          #No.FUN-680108 SMALLINT

    IF s_shut(0) THEN RETURN END IF
    IF g_obw.obw01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    LET g_before_input_done = FALSE
    CALL i112_set_entry('a')
    LET g_before_input_done = TRUE
    INPUT l_newno1 FROM obw01
        AFTER FIELD obw01
          IF NOT cl_null(l_newno1) THEN
            SELECT COUNT(*) INTO l_n FROM obw_file WHERE obw01=l_newno1
            IF l_n > 0 THEN
               CALL cl_err('',-239,0)
               NEXT FIELD obw01
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
    IF INT_FLAG
       THEN LET INT_FLAG = 0
            DISPLAY g_obw.obw01 TO obw01  ATTRIBUTE(YELLOW)
            RETURN
    END IF

    DROP TABLE x
    SELECT * FROM obw_file         #單身複製
     WHERE obw01=g_obw.obw01
      INTO TEMP x
    IF SQLCA.sqlcode THEN
       LET g_msg = g_obw.obw01 CLIPPED
       CALL cl_err(g_msg,SQLCA.sqlcode,0)
       RETURN
    END IF
    UPDATE x SET obw01 = l_newno1
    INSERT INTO obw_file SELECT * FROM x
    IF SQLCA.sqlcode THEN
       LET g_msg = l_newno1 CLIPPED
       CALL cl_err(g_msg,SQLCA.sqlcode,0)
       RETURN
    END IF
    LET l_oldno1= g_obw.obw01
    LET g_obw.obw01=l_newno1
    SELECT ROWID,obw_file.* INTO g_obw_rowid,g_obw.* FROM obw_file WHERE obw01 = l_newno1
    CALL i112_u()
    LET g_obw.obw01=l_oldno1
    CALL i112_show()
END FUNCTION

FUNCTION i112_gen02(p_arg)  # 人員名稱
    DEFINE p_arg    LIKE type_file.chr5,     #No.FUN-680108 VARCHAR(05)
 #MOD-4B0067  --begin
           p_gen01  LIKE gen_file.gen01,
           l_gen02  LIKE gen_file.gen02,
 #MOD-4B0067  --end
           l_genacti LIKE gen_file.genacti

  LET g_errno = ' '
  IF cl_null(p_arg) THEN RETURN END IF
  CASE WHEN p_arg = 'obw14' LET p_gen01 = g_obw.obw14
       WHEN p_arg = 'obw16' LET p_gen01 = g_obw.obw16
       WHEN p_arg = 'obw17' LET p_gen01 = g_obw.obw17
       WHEN p_arg = 'obw18' LET p_gen01 = g_obw.obw18
       WHEN p_arg = 'obw19' LET p_gen01 = g_obw.obw19
       OTHERWISE RETURN
  END CASE
  SELECT gen02,genacti INTO l_gen02,l_genacti FROM gen_file
   WHERE gen01 = p_gen01

    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3096'
                            LET l_gen02 = NULL
         WHEN l_genacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
  CASE WHEN p_arg = 'obw14' DISPLAY l_gen02 TO gen02
       WHEN p_arg = 'obw16' DISPLAY l_gen02 TO gen02a
       WHEN p_arg = 'obw17' DISPLAY l_gen02 TO gen02b
       WHEN p_arg = 'obw18' DISPLAY l_gen02 TO gen02c
       WHEN p_arg = 'obw19' DISPLAY l_gen02 TO gen02d
       OTHERWISE RETURN
  END CASE
END FUNCTION

 #MOD-4A0329  --begin
{
FUNCTION i112_desc(p_obw06)  # 所有權
DEFINE p_obw06   LIKE obw_file.obw06,
       l_desc    LIKE type_file.chr1000  #No.FUN-680108 VARCHAR(04)

  IF cl_null(p_obw06) THEN RETURN END IF
  IF p_obw06 = '1' THEN
     CALL cl_getmsg('axd-035',g_lang) RETURNING l_desc
  ELSE
     CALL cl_getmsg('axd-036',g_lang) RETURNING l_desc
  END IF
  DISPLAY l_desc TO desc
END FUNCTION

FUNCTION i112_desc1(p_obw07) # 狀態
DEFINE p_obw07   LIKE obw_file.obw07,
       l_desc1   LIKE type_file.chr1000  #No.FUN-680108 VARCHAR(06)

  IF cl_null(p_obw07) THEN RETURN END IF
 
  IF p_obw07 = '1' THEN
     CALL cl_getmsg('axd-037',g_lang) RETURNING l_desc1
  ELSE
     CALL cl_getmsg('axd-038',g_lang) RETURNING l_desc1
  END IF
  DISPLAY l_desc1 TO desc1
END FUNCTION

FUNCTION i112_desc2(p_obw21)  # 外租車計價方式
DEFINE p_obw21   LIKE obw_file.obw21,
       l_desc2   LIKE type_file.chr1000  #No.FUN-680108 VARCHAR(12)

#  IF cl_null(p_obw21) THEN RETURN END IF
  CASE WHEN p_obw21 = '1'
         CALL cl_getmsg('axd-039',g_lang) RETURNING l_desc2
       WHEN p_obw21 = '2'
         CALL cl_getmsg('axd-040',g_lang) RETURNING l_desc2
       WHEN p_obw21 = '3'
         CALL cl_getmsg('axd-041',g_lang) RETURNING l_desc2
       OTHERWISE  LET l_desc2 = ''
  END CASE
  DISPLAY l_desc2 TO desc2
END FUNCTION
}
 #MOD-4A0329  --end

FUNCTION i112_out()
DEFINE
    l_i        LIKE type_file.num5,       #No.FUN-680108 SMALLINT
    sr              RECORD
        obw01       LIKE obw_file.obw01,   # 車輛代號
        obw02       LIKE obw_file.obw02,   # 車輛類型
        obw03       LIKE obw_file.obw03,   # 車輛廠牌
        obw04       LIKE obw_file.obw04,   # 車輛型號
        obw05       LIKE obw_file.obw05,   # 車輛級別
        obw06       LIKE obw_file.obw06,   # 所有權
        desc        LIKE type_file.chr6,   #No.FUN-680108 VARCHAR(06)
        obw07       LIKE obw_file.obw07,   # 車輛狀態
        desc1       LIKE type_file.chr6,   #No.FUN-680108 VARCHAR(06)
        obw08       LIKE obw_file.obw08,   # 車輛號碼
        obw09       LIKE obw_file.obw09,   # 引擎號碼
        obw23       LIKE obw_file.obw23,   # 財產編號
        obw24       LIKE obw_file.obw24    # 財產附號
                    END RECORD,
    l_name          LIKE type_file.chr20,  #External(Disk) file name  #No.FUN-680108 VARCHAR(20)
    l_za05          LIKE za_file.za05      #NO.MOD-4B0067
 
    IF cl_null(g_wc) AND NOT cl_null(g_obw.obw01) THEN
       LET g_wc = " obw01 = '",g_obw.obw01,"'"
    END IF

    IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
    CALL cl_outnam('axdi112') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 LET g_sql="SELECT obw01,obw02,obw03,obw04,obw05,obw06,'',obw07,'',",        
              "       obw08,obw09,obw23,obw24 ",                                
              "  FROM obw_file ",                             
              " WHERE ",g_wc CLIPPED,                                           
              " ORDER BY obw01"
    PREPARE i112_p1 FROM g_sql              # RUNTIME 編譯
    DECLARE i112_co                         # CURSOR
        CURSOR FOR i112_p1
    START REPORT i112_rep TO l_name
    FOREACH i112_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF sr.obw06 = '1' THEN
           CALL cl_getmsg('axd-035',g_lang) RETURNING sr.desc
        ELSE
           CALL cl_getmsg('axd-036',g_lang) RETURNING sr.desc
        END IF
        IF sr.obw07 = '1' THEN
           CALL cl_getmsg('axd-037',g_lang) RETURNING sr.desc1
        ELSE
           CALL cl_getmsg('axd-038',g_lang) RETURNING sr.desc1
        END IF
        OUTPUT TO REPORT i112_rep(sr.*)
    END FOREACH
    FINISH REPORT i112_rep
    CLOSE i112_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION

REPORT i112_rep(sr)
DEFINE
    l_trailer_sw    LIKE type_file.chr1,    #No.FUN-680108 VARCHAR(1)
    l_obwacti       LIKE type_file.chr1,    #No.FUN-680108 VARCHAR(1)
    l_acti          LIKE type_file.chr1,    #No.FUN-680108 VARCHAR(1)
    l_sw            LIKE type_file.chr1,    #No.FUN-680108 VARCHAR(1)
    sr              RECORD
        obw01       LIKE obw_file.obw01,   # 車輛代號
        obw02       LIKE obw_file.obw02,   # 車輛類型
        obw03       LIKE obw_file.obw03,   # 車輛廠牌
        obw04       LIKE obw_file.obw04,   # 車輛型號
        obw05       LIKE obw_file.obw05,   # 車輛級別
        obw06       LIKE obw_file.obw06,   # 所有權
        desc        LIKE type_file.chr6,   #No.FUN-680108 VARCHAR(06)
        obw07       LIKE obw_file.obw07,   # 車輛狀態
        desc1       LIKE type_file.chr6,   #No.FUN-680108 VARCHAR(06)
        obw08       LIKE obw_file.obw08,   # 車輛號碼
        obw09       LIKE obw_file.obw09,   # 引擎號碼
        obw23       LIKE obw_file.obw23,   # 財產編號
        obw24       LIKE obw_file.obw24    # 財產附號
                    END RECORD

   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line

    ORDER BY sr.obw01

    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED

            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total

            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
            PRINT
            PRINT g_dash[1,g_len]

            PRINT g_x[31], g_x[32],g_x[33],g_x[34], g_x[35],g_x[36],
                  g_x[37], g_x[38],g_x[39],g_x[40], g_x[41],g_x[42],g_x[43]
            PRINT g_dash1
            LET l_trailer_sw = 'y'

 #MOD-4B0067  --begin

        ON EVERY ROW
            PRINT COLUMN g_c[31],sr.obw01,
               COLUMN g_c[32],sr.obw02,
                  COLUMN g_c[33],sr.obw05,
               COLUMN g_c[34],sr.obw03,
                  COLUMN g_c[35],sr.obw04,
                  COLUMN g_c[36],sr.obw06,
                  COLUMN g_c[37],sr.desc,
                  COLUMN g_c[38],sr.obw07,
                  COLUMN g_c[39],sr.desc1,
                  COLUMN g_c[40],sr.obw08,
                  COLUMN g_c[41],sr.obw09,
                  COLUMN g_c[42],sr.obw23,
                  COLUMN g_c[43],sr.obw24
 #MOD-4B0067  --end

        ON LAST ROW
            IF g_zz05 = 'Y' THEN     # 80:70,140,210      132:120,240
               PRINT g_dash[1,g_len]

           ##TQC-630166
           #{
        #   IF g_sql[001,080] > ' ' THEN
	   #           PRINT g_x[8] CLIPPED,g_sql[001,070] CLIPPED END IF
           #   IF g_sql[071,140] > ' ' THEN
	   #           PRINT COLUMN 10,     g_sql[071,140] CLIPPED END IF
           #   IF g_sql[141,210] > ' ' THEN
	   #           PRINT COLUMN 10,     g_sql[141,210] CLIPPED END IF
           #}
              CALL cl_prt_pos_wc(g_sql)
            #END TQC-630166

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
END REPORT

 #MOD-4A0329  --begin
FUNCTION i112_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)

   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("obw01",TRUE)
   END IF
   CALL cl_set_comp_entry("obw11,obw12,obw23,obw24,obw21,obw22",TRUE)
END FUNCTION

FUNCTION i112_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)

   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("obw01",FALSE)
   END IF
   CASE g_obw.obw06
        WHEN '1' LET g_obw.obw21=''
                 LET g_obw.obw22=''
                 DISPLAY BY NAME g_obw.obw21,g_obw.obw22
                 CALL cl_set_comp_entry("obw21,obw22",FALSE)
        WHEN '2' LET g_obw.obw11=''
                 LET g_obw.obw12=''
                 LET g_obw.obw23=''
                 LET g_obw.obw24=''
                 DISPLAY BY NAME g_obw.obw11,g_obw.obw12,g_obw.obw23,g_obw.obw24
                 CALL cl_set_comp_entry("obw11,obw12,obw23,obw24",FALSE)
   END CASE
END FUNCTION

FUNCTION i112_set_required()

 IF g_obw.obw06 = '1' THEN
    CALL cl_set_comp_required("obw11,obw12,obw23",TRUE)
 END IF
 IF g_obw.obw06 = '2' THEN
    CALL cl_set_comp_required("obw21,obw22",TRUE)
 END IF

END FUNCTION

FUNCTION i112_set_no_required()

 CALL cl_set_comp_required("obw11,obw12,obw23,obw21,obw22",FALSE)

END FUNCTION
