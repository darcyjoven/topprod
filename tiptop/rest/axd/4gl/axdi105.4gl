# Prog. Version..: '5.10.00-08.01.04(00000)'     #
#
# Pattern name...: axdi105.4gl
# Descriptions...: 運輸途徑維護作業
# Date & Author..: 03/10/10 By Carrier
# Modify.........: No.MOD-4B0067 04/11/08 By Elva  將變數用Like方式定義,報表拉成一行
# Modify.........: No.MOD-4B0123 04/11/10 By Carrier
# Modify.........: No.FUN-4C0052 04/12/08 By pengu Data and Group權限控管
# Modify.........: No.FUN-520024 05/02/24 By Day 報表轉XML
# Modify.........: No.MOD-540145 05/05/10 By vivien  刪除HELP FILE
# Modify.........: No:FUN-5B0113 05/11/22 By Claire 修改單身後單頭的資料更改者及最近修改日應update
# Modify.........: No.TQC-5B0212 05/12/02 By kevin 報表須設定 g_company
# Modify.........: No.FUN-680108 06/08/28 By Xufeng 字段類型定義改為LIKE   
# Modify.........: Mo.FUN-6A0078 06/10/24 By xumin g_no_ask改mi_no_ask    
# Modify.........: No:FUN-6A0091 06/10/27 By douzh l_time轉g_time
# Modify.........: No:FUN-6A0165 06/11/08 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No:FUN-6A0092 06/11/14 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No:FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值

DATABASE ds

GLOBALS "../../config/top.global"

#模組變數(Module Variables)
DEFINE
    g_obn           RECORD LIKE obn_file.*,       #簽核等級 (假單頭)
    g_obn_t         RECORD LIKE obn_file.*,       #簽核等級 (舊值)
    g_obn_o         RECORD LIKE obn_file.*,       #簽核等級 (舊值)
    g_obn01_t       LIKE obn_file.obn01,   #簽核等級 (舊值)
    g_obn_rowid     LIKE type_file.chr18,  #ROWID            #No.FUN-680108 INT
    g_obo           DYNAMIC ARRAY OF RECORD#程式變數(Program Variables)
     obo02       LIKE obo_file.obo02,   #簽核順序
        obo03       LIKE obo_file.obo03,   #人員代號
        desc        LIKE type_file.chr4,   #Job Description  #No.FUN-680108 VARCHAR(04)
        obo04       LIKE obo_file.obo04,   #備注
        obo05       LIKE obo_file.obo05,   #備注
        oac02b      LIKE oac_file.oac02,
        obo06       LIKE obo_file.obo06,   #備注
        oac02c      LIKE oac_file.oac02,
        obo07       LIKE obo_file.obo07    #備注
                    END RECORD,
    g_obo_t         RECORD                 #程式變數 (舊值)
     obo02       LIKE obo_file.obo02,   #簽核順序
        obo03       LIKE obo_file.obo03,   #人員代號
        desc        LIKE type_file.chr4,   #Job Description  #No.FUN-680108 VARCHAR(04)
        obo04       LIKE obo_file.obo04,   #備注
        obo05       LIKE obo_file.obo05,   #備注
        oac02b      LIKE oac_file.oac02,
        obo06       LIKE obo_file.obo06,   #備注
        oac02c      LIKE oac_file.oac02,
        obo07       LIKE obo_file.obo07    #備注
                    END RECORD,
    g_wc,g_wc2,g_sql    STRING,  #No:FUN-580092 HCN  
    l_za05          LIKE za_file.za05,     #NO.MOD-4B0067
    g_rec_b         LIKE type_file.num5,   #單身筆數    #No.FUN-680108 SMALLINT
    l_ac            LIKE type_file.num5    #目前處理的ARRAY CNT   #No.FUN-680108 SMALLINT
DEFINE   g_before_input_done LIKE type_file.num5        #No.FUN-680108 SMALLINT

DEFINE   g_forupd_sql   STRING   #SELECT ... FOR UPDATE NOWAIT SQL 
DEFINE   g_cnt          LIKE type_file.num10     #No.FUN-680108 INTEGER
DEFINE   g_chr          LIKE type_file.chr1      #No.FUN-680108 VARCHAR(01)
DEFINE   g_i            LIKE type_file.num5      #count/index for any purpose#No.FUN-680108 SMALLINT
DEFINE   g_msg          LIKE type_file.chr1000   #No.FUN-680108 VARCHAR(72)
DEFINE   g_curs_index   LIKE type_file.num10     #No.FUN-680108 INTEGER
DEFINE   g_row_count    LIKE type_file.num10     #No.FUN-680108 INTEGER
DEFINE   g_jump         LIKE type_file.num10     #No.FUN-680108 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5      #No.FUN-680108 SMALLINT   #No.FUN-6A0078

#主程式開始
MAIN
#DEFINE
#       l_time    LIKE type_file.chr8             #No.FUN-6A0091
DEFINE p_row,p_col LIKE type_file.num5     #No.FUN-680108 SMALLINT
    OPTIONS                                #改變一些系統預設值
        MESSAGE LINE    LAST,              #訊息顯示的位置
        PROMPT LINE     LAST,              #提示訊息的位置
        INPUT NO WRAP                      #輸入的方式: 不打轉
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF

    WHENEVER ERROR CALL cl_err_msg_log

    IF (NOT cl_setup("AXD")) THEN
       EXIT PROGRAM
    END IF
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
         RETURNING g_time    #No.FUN-6A0091
    LET p_row = 4 LET p_col = 10
    OPEN WINDOW i105_w AT p_row,p_col WITH FORM "axd/42f/axdi105"
        ATTRIBUTE(STYLE = g_win_style)
    CALL cl_ui_init()

    CALL g_x.clear()
    LET g_forupd_sql = "SELECT * FROM obn_file WHERE ROWID = ? FOR UPDATE NOWAIT "
    DECLARE i105_cl CURSOR FROM g_forupd_sql

    CALL i105_menu()
    CLOSE WINDOW i105_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
         RETURNING g_time    #No.FUN-6A0091
END MAIN

#QBE 查詢資料
FUNCTION i105_cs()
    CLEAR FORM                             #清除畫面
    CALL g_obo.clear()

 #NO.MOD-4B0123   --begin
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092

   INITIALIZE g_obn.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
     obn01,obn02,obn04,obn05,
        obnuser,obngrup,obnmodu,obndate,obnacti
     ON ACTION CONTROLP
            CASE
                WHEN INFIELD(obn04)
                #   CALL q_oac(10,3,g_obn.obn04)
                #       RETURNING g_obn.obn04
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_oac"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO obn04
                    NEXT FIELD obn04
                WHEN INFIELD(obn05)
                #   CALL q_oac(10,3,g_obn.obn05)
                #       RETURNING g_obn.obn05
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_oac"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO obn05
                    NEXT FIELD obn05
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
 
       END CONSTRUCT
 #NO.MOD-4B0123   --end
    IF INT_FLAG THEN RETURN END IF
    #資料權限的檢查
    IF g_priv2='4' THEN                           #只能使用自己的資料
        LET g_wc = g_wc clipped," AND obnuser = '",g_user,"'"
    END IF
    IF g_priv3='4' THEN                           #只能使用相同群的資料
        LET g_wc = g_wc clipped," AND obngrup MATCHES '",g_grup CLIPPED,"*'"
    END IF

    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
        LET g_wc = g_wc clipped," AND obngrup IN ",cl_chk_tgrup_list()
    END IF


 CONSTRUCT g_wc2 ON obo02,obo03,obo04,obo05,obo06,obo07   # 螢幕上取單身條件
            FROM s_obo[1].obo02,s_obo[1].obo03,s_obo[1].obo04,
                 s_obo[1].obo05,s_obo[1].obo06,s_obo[1].obo07
         ON ACTION CONTROLP
            CASE
 #NO.MOD-4B0123  --begin
                WHEN INFIELD(obo05)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form="q_oac"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO s_obo[1].obo05
                     NEXT FIELD obo05
                WHEN INFIELD(obo06)
                #    CALL q_oac(10,3,g_obo[l_ac].obo06)
                #         RETURNING g_obo[l_ac].obo06
                     CALL cl_init_qry_var()
                     LET g_qryparam.form="q_oac"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO s_obo[1].obo06
                     NEXT FIELD obo06
 #NO.MOD-4B0123   --end
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
 
       END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT ROWID, obn01 FROM obn_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY obn01"
    ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE obn_file.ROWID, obn01 ",
                   "  FROM obn_file, obo_file ",
                   " WHERE obn01 = obo01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY obn01"
    END IF

    PREPARE i105_prepare FROM g_sql
    DECLARE i105_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i105_prepare

    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM obn_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT obn01) FROM obn_file,obo_file WHERE ",
                  "obo01=obn01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE i105_precount FROM g_sql
    DECLARE i105_count CURSOR FOR i105_precount
END FUNCTION

FUNCTION i105_menu()
   WHILE TRUE
      CALL i105_bp("G")
      CASE g_action_choice
        WHEN "insert"
           IF cl_chk_act_auth() THEN
              CALL i105_a()
           END IF
        WHEN "query"
           IF cl_chk_act_auth() THEN
              CALL i105_q()
           END IF
        WHEN "delete"
           IF cl_chk_act_auth() THEN
              CALL i105_r()
           END IF
        WHEN "reproduce"
           IF cl_chk_act_auth() THEN
              CALL i105_copy()
           END IF
        WHEN "modify"
           IF cl_chk_act_auth() THEN
              CALL i105_u()
           END IF
        WHEN "detail"
           IF cl_chk_act_auth() THEN
              CALL i105_b()
           ELSE
              LET g_action_choice = NULL
           END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i105_x()
            END IF
        WHEN "output"
           IF cl_chk_act_auth() THEN
              CALL i105_out()
           END IF
        WHEN "help"
           CALL cl_show_help()
        WHEN "exit"
           EXIT WHILE
        WHEN "controlg"
           CALL cl_cmdask()
        #No:FUN-6A0165-------add--------str----
        WHEN "related_document"  #相關文件
             IF cl_chk_act_auth() THEN
                IF g_obn.obn01 IS NOT NULL THEN
                LET g_doc.column1 = "obn01"
                LET g_doc.value1 = g_obn.obn01
                CALL cl_doc()
              END IF
        END IF
        #No:FUN-6A0165-------add--------end----
      END CASE
   END WHILE
END FUNCTION

#Add  輸入
FUNCTION i105_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_obo.clear()
    INITIALIZE g_obn.* LIKE obn_file.*             #DEFAULT 設定
    LET g_obn01_t = NULL
 #預設值及將數值類變數清成零
    LET g_obn_o.* = g_obn.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_obn.obnuser=g_user
        LET g_obn.obngrup=g_grup
        LET g_obn.obndate=g_today
        LET g_obn.obnacti='Y'              #資料有效
        CALL i105_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            INITIALIZE g_obn.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_obn.obn01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO obn_file VALUES (g_obn.*)
        IF SQLCA.sqlcode THEN
            CALL cl_err(g_obn.obn01,SQLCA.sqlcode,1)
            CONTINUE WHILE
        END IF
        SELECT ROWID INTO g_obn_rowid FROM obn_file
            WHERE obn01 = g_obn.obn01
        LET g_obn01_t = g_obn.obn01        #保留舊值
        LET g_obn_t.* = g_obn.*
        LET g_rec_b=0
        CALL g_obo.clear()
        CALL i105_b()                   #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION

FUNCTION i105_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_obn.obn01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_obn.* FROM obn_file WHERE obn01=g_obn.obn01
    IF g_obn.obnacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_obn.obn01,9027,0)
       RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_obn01_t = g_obn.obn01
    LET g_obn_o.* = g_obn.*
    BEGIN WORK
    OPEN i105_cl USING g_obn_rowid
    IF STATUS THEN
       CALL cl_err("OPEN i105_cl:", STATUS, 1)
       CLOSE i105_cl
       ROLLBACK WORK
       RETURN
    END IF
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_obn.obn01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE i105_cl ROLLBACK WORK RETURN
    END IF
    FETCH i105_cl INTO g_obn.*            # 鎖住將被更改或取消的資料
    CALL i105_show()
    WHILE TRUE
        LET g_obn01_t = g_obn.obn01
        LET g_obn.obnmodu=g_user
        LET g_obn.obndate=g_today
        CALL i105_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_obn.*=g_obn_t.*
            CALL i105_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
     IF g_obn.obn01 != g_obn01_t THEN            # 更改單號
            UPDATE obo_file SET obo01 = g_obn.obn01
                WHERE obo01 = g_obn01_t
            IF SQLCA.sqlcode THEN
                CALL cl_err('obo',SQLCA.sqlcode,0) CONTINUE WHILE
            END IF
        END IF
        UPDATE obn_file SET obn_file.* = g_obn.*
            WHERE ROWID = g_obn_rowid
        IF SQLCA.sqlcode THEN
            CALL cl_err(g_obn.obn01,SQLCA.sqlcode,0)
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i105_cl
    COMMIT WORK
END FUNCTION

#處理INPUT
FUNCTION i105_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,                 #判斷必要欄位是否有輸入#No.FUN-680108 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #a:輸入 u:更改         #No.FUN-680108 VARCHAR(1)
    l_obm02         LIKE obm_file.obm02,
    l_oac02         LIKE oac_file.oac02,
    l_oac02a        LIKE oac_file.oac02,
    l_cnt           LIKE type_file.num5                                         #No.FUN-680108 SMALLINT
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092

    INPUT BY NAME
      g_obn.obn01,g_obn.obn02,g_obn.obn04,g_obn.obn05,  #NO.MOD-4B0123
        g_obn.obnuser,g_obn.obngrup,g_obn.obnmodu,g_obn.obndate,g_obn.obnacti
        WITHOUT DEFAULTS HELP 1

        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i105_set_entry(p_cmd)
            CALL i105_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE

        AFTER FIELD obn01                  #簽核等級
            IF NOT cl_null(g_obn.obn01) THEN
               IF g_obn.obn01 != g_obn01_t OR g_obn01_t IS NULL THEN
                   SELECT COUNT(*) INTO g_cnt FROM obn_file
                    WHERE obn01 = g_obn.obn01
                   IF g_cnt > 0 THEN   #資料重復
                       CALL cl_err(g_obn.obn01,-239,0)
                       LET g_obn.obn01 = g_obn01_t
                       DISPLAY BY NAME g_obn.obn01
                       NEXT FIELD obn01
                   END IF
               END IF
            END IF
 #NO.MOD-4B0123   --begin
#        AFTER FIELD obn03
#            IF NOT cl_null(g_obn.obn03) THEN
#               SELECT obm02 INTO l_obm02 FROM obm_file
#                WHERE obm01 = g_obn.obn03
#               IF STATUS THEN
#                  CALL cl_err(g_obn.obn03,'axd-058',0) NEXT FIELD obn03
#               END IF
#               DISPLAY l_obm02 TO obm02
#            END IF
 #NO.MOD-4B0123   --end
        AFTER FIELD obn04
            IF NOT cl_null(g_obn.obn04) THEN
               SELECT oac02 INTO l_oac02 FROM oac_file
                WHERE oac01 = g_obn.obn04
               IF STATUS THEN
                  CALL cl_err(g_obn.obn04,'mfg3119',0) NEXT FIELD obn04
               END IF
               DISPLAY l_oac02 TO oac02
            END IF

        AFTER FIELD obn05
            IF NOT cl_null(g_obn.obn05) THEN
               SELECT oac02 INTO l_oac02a FROM oac_file
                WHERE oac01 = g_obn.obn05
               IF STATUS THEN
                  CALL cl_err(g_obn.obn05,'mfg3119',0) NEXT FIELD obn05
               END IF
               DISPLAY l_oac02a TO oac02a
            END IF

        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,并要求重新輸入
            LET l_flag='N'
            IF INT_FLAG THEN
               EXIT INPUT
            END IF

        ON ACTION CONTROLF                 #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 

     ON ACTION CONTROLP
            CASE
 #NO.MOD-4B0123   --begin
#                WHEN INFIELD(obn03)
#                #   CALL q_obm(10,3,g_obn.obn03)
#                #       RETURNING g_obn.obn03
#                    CALL cl_init_qry_var()
#                    LET g_qryparam.form ="q_obm"
#                    LET g_qryparam.default1 = g_obn.obn03
#                    CALL cl_create_qry() RETURNING g_obn.obn03
#                    DISPLAY g_obn.obn03 TO obn03
 #NO.MOD-4B0123   --end
                WHEN INFIELD(obn04)
                #   CALL q_oac(10,3,g_obn.obn04)
                #       RETURNING g_obn.obn04
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_oac"
                    LET g_qryparam.default1 = g_obn.obn04
                    CALL cl_create_qry() RETURNING g_obn.obn04
                    DISPLAY g_obn.obn04 TO obn04
                WHEN INFIELD(obn05)
                #   CALL q_oac(10,3,g_obn.obn05)
                #       RETURNING g_obn.obn05
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_oac"
                    LET g_qryparam.default1 = g_obn.obn05
                    CALL cl_create_qry() RETURNING g_obn.obn05
                    DISPLAY g_obn.obn05 TO obn05
                OTHERWISE
                    EXIT CASE
            END CASE

        ON ACTION CONTROLZ
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
            CALL cl_cmdask()

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
    END INPUT
END FUNCTION

#Query 查詢
FUNCTION i105_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_obn.* TO NULL               #No.FUN-6A0165
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_obo.clear()
    DISPLAY '   ' TO FORMONLY.cnt  #ATTRIBUTE(YELLOW)
    CALL i105_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    MESSAGE " SEARCHING ! " ATTRIBUTE(REVERSE)
    OPEN i105_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_obn.* TO NULL
    ELSE
        OPEN i105_count
        FETCH i105_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i105_fetch('F')                  # 讀出TEMP第一筆并顯示
    END IF
    MESSAGE ""
END FUNCTION

#處理資料的讀取
FUNCTION i105_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680108 VARCHAR(1)


    CASE p_flag
        WHEN 'N' FETCH NEXT     i105_cs INTO g_obn_rowid,g_obn.obn01
        WHEN 'P' FETCH PREVIOUS i105_cs INTO g_obn_rowid,g_obn.obn01
        WHEN 'F' FETCH FIRST    i105_cs INTO g_obn_rowid,g_obn.obn01
        WHEN 'L' FETCH LAST     i105_cs INTO g_obn_rowid,g_obn.obn01
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
          FETCH ABSOLUTE g_jump i105_cs INTO g_obn_rowid,g_obn.obn01
          LET mi_no_ask = FALSE    #No.FUN-6A0078
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_obn.obn01,SQLCA.sqlcode,0)
        RETURN
    END IF
    SELECT * INTO g_obn.* FROM obn_file WHERE ROWID = g_obn_rowid
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_obn.obn01,SQLCA.sqlcode,0)
        INITIALIZE g_obn.* TO NULL
        RETURN
    ELSE
       CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE

      CALL cl_navigator_setting( g_curs_index, g_row_count )
      LET g_data_owner=g_obn.obnuser             #FUN-4C0052權限控管
      LET g_data_group=g_obn.obngrup
    END IF
    CALL i105_show()
END FUNCTION

#將資料顯示在畫面上
FUNCTION i105_show()
    DEFINE l_cnt      LIKE type_file.num5          #No.FUN-680108 SMALLINT
    DEFINE l_obm02    LIKE obm_file.obm02,
           l_oac02    LIKE oac_file.oac02,
           l_oac02a   LIKE oac_file.oac02
    LET g_obn_t.* = g_obn.*                      #保存單頭舊值
    DISPLAY BY NAME                              # 顯示單頭值
      g_obn.obn01,g_obn.obn02,    #NO.MOD-4B0123
        g_obn.obn04,g_obn.obn05,
        g_obn.obnuser,g_obn.obngrup,g_obn.obnmodu,
        g_obn.obndate,g_obn.obnacti
 #    SELECT obm02 INTO l_obm02  FROM obm_file WHERE obm01 = g_obn.obn03  #NO.MOD-4B0123
    SELECT oac02 INTO l_oac02  FROM oac_file WHERE oac01 = g_obn.obn04
    SELECT oac02 INTO l_oac02a FROM oac_file WHERE oac01 = g_obn.obn05
 #    DISPLAY l_obm02  TO FORMONLY.obm02  #NO.MOD-4B0123
    DISPLAY l_oac02  TO FORMONLY.oac02
    DISPLAY l_oac02a TO FORMONLY.oac02a
    CALL i105_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
END FUNCTION

#取消整筆 (所有合乎單頭的資料)
FUNCTION i105_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_obn.obn01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
    BEGIN WORK
    OPEN i105_cl USING g_obn_rowid
    IF STATUS THEN
       CALL cl_err("OPEN i105_cl:", STATUS, 1)
       CLOSE i105_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i105_cl INTO g_obn.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_obn.obn01,SQLCA.sqlcode,0)          #資料被他人LOCK
        CLOSE i105_cl ROLLBACK WORK RETURN
    END IF
    CALL i105_show()
    IF cl_delh(0,0) THEN                   #確認一下
         DELETE FROM obn_file WHERE obn01 = g_obn.obn01
         DELETE FROM obo_file WHERE obo01 = g_obn.obn01
         INITIALIZE g_obn.* TO NULL
         CLEAR FORM
         CALL g_obo.clear()
         OPEN i105_count
         FETCH i105_count INTO g_row_count
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i105_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i105_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE     #No.FUN-6A0078
            CALL i105_fetch('/')
         END IF
    END IF
    CLOSE i105_cl
    COMMIT WORK
END FUNCTION

FUNCTION i105_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_obn.obn01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
    BEGIN WORK
    OPEN i105_cl USING g_obn_rowid
    IF STATUS THEN
       CALL cl_err("OPEN i105_cl:", STATUS, 1)
       CLOSE i105_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i105_cl INTO g_obn.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_obn.obn01,SQLCA.sqlcode,0)          #資料被他人LOCK
        CLOSE i105_cl ROLLBACK WORK RETURN
    END IF
    CALL i105_show()
    IF cl_exp(0,0,g_obn.obnacti) THEN                   #確認一下
        LET g_chr=g_obn.obnacti
        IF g_obn.obnacti='Y' THEN
            LET g_obn.obnacti='N'
        ELSE
            LET g_obn.obnacti='Y'
        END IF
        UPDATE obn_file                    #更改有效碼
            SET obnacti=g_obn.obnacti
            WHERE obn01=g_obn.obn01
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(g_obn.obn01,SQLCA.sqlcode,0)
            LET g_obn.obnacti=g_chr
        END IF
        DISPLAY BY NAME g_obn.obnacti ATTRIBUTE(RED)
    END IF
    CLOSE i105_cl
    COMMIT WORK
END FUNCTION

#單身
FUNCTION i105_b()
DEFINE
    l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT    #No.FUN-680108 SMALLINT
    l_n,l_n1        LIKE type_file.num5,   #檢查重復用           #No.FUN-680108 SMALLINT
    l_lock_sw       LIKE type_file.chr1,   #單身鎖住否           #No.FUN-680108 VARCHAR(1)
    l_exit_sw       LIKE type_file.chr1,   #Esc結束INPUT ARRAY 否#No.FUN-680108 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,   #處理狀態             #No.FUN-680108 VARCHAR(1)
    l_obo02         LIKE obo_file.obo02,   #NO.MOD-4B0067
    l_allow_insert  LIKE type_file.num5,   #可新增否             #No.FUN-680108 SMALLINT
    l_allow_delete  LIKE type_file.num5    #可刪除否             #No.FUN-680108 SMALLINT

    LET g_action_choice = ""

    IF s_shut(0) THEN RETURN END IF
    IF g_obn.obn01 IS NULL THEN
        RETURN
    END IF
    SELECT * INTO g_obn.* FROM obn_file WHERE obn01=g_obn.obn01
    IF g_obn.obnacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_obn.obn01,'aom-000',0)
        RETURN
    END IF

    CALL cl_opmsg('b')

    LET g_forupd_sql = " SELECT obo02,obo03,'',obo04,obo05,'',obo06,'',obo07 ",
                       "   FROM obo_file WHERE obo01= ? AND obo02= ? FOR UPDATE NOWAIT"
    DECLARE i105_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

#   LET l_ac_t = 0
      LET l_allow_insert = cl_detail_input_auth("insert")
      LET l_allow_delete = cl_detail_input_auth("delete")

      INPUT ARRAY g_obo WITHOUT DEFAULTS FROM s_obo.*
            ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                      APPEND ROW=l_allow_insert)

    BEFORE INPUT
        DISPLAY "BEFORE INPUT"
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF

    BEFORE ROW
        DISPLAY "BEFORE ROW"
            LET p_cmd=' '
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            BEGIN WORK
            OPEN i105_cl USING g_obn_rowid
            IF STATUS THEN
               CALL cl_err("OPEN i105_cl:", STATUS, 1)
               CLOSE i105_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH i105_cl INTO g_obn.*            # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
                CALL cl_err(g_obn.obn01,SQLCA.sqlcode,0)      # 資料被他人LOCK
                CLOSE i105_cl ROLLBACK WORK RETURN
            END IF
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_obo_t.* = g_obo[l_ac].*  #BACKUP
                OPEN i105_bcl USING g_obn.obn01,g_obo_t.obo02
                IF STATUS THEN
                   CALL cl_err("OPEN i105_bcl:", STATUS, 1)
                   LET l_lock_sw='Y'
                ELSE
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_obo_t.obo02,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                   FETCH i105_bcl INTO g_obo[l_ac].*
                   CALL cl_getmsg('axd-034',g_lang) RETURNING g_msg
                   CASE g_obo[l_ac].obo03
                     WHEN '1'  LET g_obo[l_ac].desc=g_msg[1,4]
                     WHEN '2'  LET g_obo[l_ac].desc=g_msg[5,8]
                     WHEN '3'  LET g_obo[l_ac].desc=g_msg[9,12]
                   END CASE
                   SELECT oac02 INTO g_obo[l_ac].oac02b FROM oac_file
                    WHERE oac01=g_obo[l_ac].obo05
                   SELECT oac02 INTO g_obo[l_ac].oac02c FROM oac_file
                    WHERE oac01=g_obo[l_ac].obo06
                END IF
                CALL i105_set_entry_b(p_cmd)
                CALL i105_set_no_entry_b(p_cmd)
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF

    BEFORE INSERT
        DISPLAY "BEFORE INSERT"
            IF g_rec_b < l_ac THEN
                LET g_obo_t.* = g_obo[l_ac].*  #BACKUP
                LET p_cmd='a'  #輸入新資料
             INITIALIZE g_obo[l_ac].* TO NULL  #900423
            END IF
            IF NOT cl_null(g_obo_t.obo02) THEN
               IF NOT cl_confirm('axd-057') THEN
                  CANCEL INSERT
                  LET l_ac_t = l_ac
                  EXIT INPUT
               END IF
               DELETE FROM obo_file
                WHERE obo01 = g_obn.obn01 AND
                      obo02 >= g_obo_t.obo02
               IF SQLCA.sqlcode THEN
                   CALL cl_err(g_obo_t.obo02,SQLCA.sqlcode,0)
                   LET l_exit_sw = "n"
                   LET l_ac_t = l_ac
                   EXIT INPUT
               ELSE
                   LET g_rec_b=g_rec_b-l_n1-1
               END IF
               DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
               CLEAR FORM
               CALL g_obo.clear()
               CALL i105_show()
            END IF
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
         INITIALIZE g_obo[l_ac].* TO NULL      #900423
            LET g_obo_t.* = g_obo[l_ac].*         #新輸入資料
            CALL i105_set_entry_b(p_cmd)
            CALL i105_set_no_entry_b(p_cmd)
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD obo02

    AFTER INSERT
        DISPLAY "AFTER INSERT"
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO obo_file(obo01,obo02,obo03,obo04,obo05,obo06,obo07)
                       VALUES(g_obn.obn01,g_obo[l_ac].obo02,
                              g_obo[l_ac].obo03,g_obo[l_ac].obo04,
                              g_obo[l_ac].obo05,g_obo[l_ac].obo06,
                              g_obo[l_ac].obo07)
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_obo[l_ac].obo02,SQLCA.sqlcode,0)
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
               COMMIT WORK
            END IF

        BEFORE FIELD obo02                        #default 序號
            IF g_obo[l_ac].obo02 IS NULL OR g_obo[l_ac].obo02 = 0 THEN
               SELECT max(obo02)+1 INTO l_obo02 FROM obo_file
                WHERE obo01 = g_obn.obn01
               IF l_obo02 IS NULL THEN LET l_obo02 = 1 END IF
               LET g_obo[l_ac].obo02=l_obo02
            END IF
            IF p_cmd = 'a' THEN
               LET g_obo[l_ac].obo04 = g_obn.obn03
               IF g_obo[l_ac].obo02 = 1 THEN
                  LET g_obo[l_ac].obo05 = g_obn.obn04
               ELSE
                  LET g_obo[l_ac].obo05 = g_obo[l_ac-1].obo06
               END IF
               SELECT oac02 INTO g_obo[l_ac].oac02b FROM oac_file
                WHERE oac01=g_obo[l_ac].obo05
            END IF

        AFTER FIELD obo02
            IF NOT cl_null(g_obo[l_ac].obo02) THEN
               IF g_obo[l_ac].obo02 != g_obo_t.obo02 AND
                  g_obo_t.obo02 IS NOT NULL THEN
                  NEXT FIELD obo02
               END IF
               IF g_obo_t.obo02 IS NULL THEN
                  SELECT MAX(obo02) INTO l_obo02 FROM obo_file
                   WHERE obo01 = g_obn.obn01
                  IF cl_null(l_obo02) THEN
                     LET l_obo02 = 0
                  END IF
                  IF g_obo[l_ac].obo02 <> l_obo02 + 1 THEN
                     CALL cl_err('','axd-053',0)
                     LET g_obo[l_ac].obo02 = g_obo_t.obo02
                     NEXT FIELD obo02
                  END IF
                  SELECT count(*) INTO l_n
                    FROM obo_file
                   WHERE obo01 = g_obn.obn01 AND
                         obo02 = g_obo[l_ac].obo02
                  IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_obo[l_ac].obo02 = g_obo_t.obo02
                     NEXT FIELD obo02
                  END IF
               END IF
            END IF

        BEFORE FIELD obo03
            CALL i105_set_entry_b(p_cmd)

        AFTER FIELD obo03
            IF g_obo[l_ac].obo03 MATCHES '[123]' THEN
               IF g_obo_t.obo03 IS NOT NULL
                  AND g_obo_t.obo03 <> g_obo[l_ac].obo03 THEN
                  IF NOT cl_confirm('axd-054') THEN
                     LET g_obo[l_ac].obo03 = g_obo_t.obo03
                     NEXT FIELD obo03
                  END IF
               END IF
               CALL cl_getmsg('axd-034',g_lang) RETURNING g_msg
               CASE g_obo[l_ac].obo03
                 WHEN '1'  LET g_obo[l_ac].desc=g_msg[1,4]
                 WHEN '2'  LET g_obo[l_ac].desc=g_msg[5,8]
                 WHEN '3'  LET g_obo[l_ac].desc=g_msg[9,12]
               END CASE
               IF g_obo[l_ac].obo03 = '1' THEN
                  IF g_obo[l_ac].obo05 = g_obo[l_ac].obo06 THEN
                     LET g_obo[l_ac].obo06 = ''
                  END IF
               END IF
               IF g_obo[l_ac].obo03 = '2' OR g_obo[l_ac].obo03 = '3' THEN
                  LET g_obo[l_ac].obo06 = g_obo[l_ac].obo05
               END IF
               SELECT oac02 INTO g_obo[l_ac].oac02b FROM oac_file
                WHERE oac01=g_obo[l_ac].obo05
               SELECT oac02 INTO g_obo[l_ac].oac02c FROM oac_file
                WHERE oac01=g_obo[l_ac].obo06
            END IF
            #------MOD-5A0095 START----------
            DISPLAY BY NAME g_obo[l_ac].desc
            DISPLAY BY NAME g_obo[l_ac].obo06
            DISPLAY BY NAME g_obo[l_ac].oac02b
            DISPLAY BY NAME g_obo[l_ac].oac02c
            #------MOD-5A0095 END------------
               #------MOD-5A0095 START----------
               DISPLAY BY NAME g_obo[l_ac].oac02c
               DISPLAY BY NAME g_obo[l_ac].obo06
               DISPLAY BY NAME g_obo[l_ac].obo05
               #------MOD-5A0095 END------------
            CALL i105_set_no_entry_b(p_cmd)

 #NO.MOD-4B0123   --begin
#        AFTER FIELD obo04
#            IF NOT cl_null(g_obo[l_ac].obo04) THEN
#               SELECT * FROM obm_file
#                WHERE obm01 = g_obo[l_ac].obo04
#               IF STATUS = 100 THEN
#                  CALL cl_err(g_obo[l_ac].obo04,'axd-058',0)
#                  NEXT FIELD obo04
#               END IF
#            END IF
 #NO.MOD-4B0123   --end
        AFTER FIELD obo06
            IF NOT cl_null(g_obo[l_ac].obo06) THEN
               SELECT * FROM oac_file
                WHERE oac01 = g_obo[l_ac].obo06
               IF STATUS = 100 THEN
                  CALL cl_err(g_obo[l_ac].obo06,100,0)
                  NEXT FIELD obo06
               END IF
               IF g_obo_t.obo06 IS NOT NULL AND
                  g_obo_t.obo06 <> g_obo[l_ac].obo06 THEN
                  IF NOT cl_confirm('axd-054') THEN
                     LET g_obo[l_ac].obo06 = g_obo_t.obo06
                     NEXT FIELD obo06
                  END IF
               END IF
               IF g_obo[l_ac].obo03 = '1' THEN
                  IF g_obo[l_ac].obo05 = g_obo[l_ac].obo06 THEN
                     CALL cl_err(g_obo[l_ac].obo06,'axd-055',0)
                     NEXT FIELD obo06
                  END IF
               ELSE
                  IF g_obo[l_ac].obo05 <> g_obo[l_ac].obo06 THEN
                     LET g_obo[l_ac].obo06 = g_obo[l_ac].obo05
                     CALL cl_err(g_obo[l_ac].obo06,'axd-056',0)
                     NEXT FIELD obo06
                  END IF
               END IF
               SELECT oac02 INTO g_obo[l_ac].oac02c FROM oac_file
                WHERE oac01=g_obo[l_ac].obo06
            END IF

        AFTER FIELD obo07
            IF g_obo[l_ac].obo07 < 0 THEN
               NEXT FIELD obo07
            END IF

        BEFORE DELETE                            #是否取消單身
            IF g_obo_t.obo02 > 0 AND
               g_obo_t.obo02 IS NOT NULL THEN
               SELECT COUNT(*) INTO l_n1 FROM obo_file
                WHERE obo01 = g_obn.obn01
                  AND obo02 > g_obo_t.obo02
               IF l_n1 > 0 THEN
                  IF NOT cl_confirm('axd-057') THEN
                     LET l_exit_sw = "n"
                     LET l_ac_t = l_ac
                     EXIT INPUT
                  END IF
                  DELETE FROM obo_file
                   WHERE obo01 = g_obn.obn01 AND
                         obo02 >= g_obo_t.obo02
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_obo_t.obo02,SQLCA.sqlcode,0)
                       LET l_exit_sw = "n"
                       LET l_ac_t = l_ac
                       EXIT INPUT
                   ELSE
                       LET g_rec_b=g_rec_b-l_n1-1
                   END IF
                ELSE
                   IF NOT cl_delb(0,0) THEN
                      CANCEL DELETE
                   END IF
                   IF l_lock_sw = "Y" THEN
                      CALL cl_err("", -263, 1)
                      CANCEL DELETE
                   END IF
                   DELETE FROM obo_file
                    WHERE obo01 = g_obn.obn01 AND
                          obo02 = g_obo_t.obo02
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_obo_t.obo02,SQLCA.sqlcode,0)
                        LET l_exit_sw = "n"
                        LET l_ac_t = l_ac
                        EXIT INPUT
                    ELSE
                        LET g_rec_b=g_rec_b-l_n1-1
                    END IF
                END IF
                DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
                CALL i105_show()
            END IF
            COMMIT WORK

    ON ROW CHANGE
        DISPLAY "ON ROW CHANGE"
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_obo[l_ac].* = g_obo_t.*
               CLOSE i105_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_obo[l_ac].obo02,-263,1)
               LET g_obo[l_ac].* = g_obo_t.*
            ELSE
   UPDATE obo_file
      SET obo02=g_obo[l_ac].obo02,obo03=g_obo[l_ac].obo03,   
          obo04=g_obo[l_ac].obo04,obo05=g_obo[l_ac].obo05,   
          obo06=g_obo[l_ac].obo06,obo07=g_obo[l_ac].obo07   
    WHERE CURRENT OF i105_bcl
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_obo[l_ac].obo02,SQLCA.sqlcode,0)
                  LET g_obo[l_ac].* = g_obo_t.*
               ELSE
                  LET g_obo_t.* = g_obo[l_ac].*
                  DELETE FROM obo_file WHERE obo01 = g_obn.obn01
                     AND obo02 > g_obo[l_ac].obo02
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('',SQLCA.sqlcode,0)
                     EXIT INPUT
                  END IF
                  CLEAR FORM
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
                  CALL i105_show()
                  EXIT INPUT
               END IF
            END IF

    AFTER ROW
        DISPLAY "AFTER ROW"
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_obo[l_ac].* = g_obo_t.*
               END IF
               CLOSE i105_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE i105_bcl
            COMMIT WORK

         ON ACTION CONTROLP
            CASE
 #NO.MOD-4B0123   --begin
#                WHEN INFIELD(obo04)
#                #    CALL q_obm(10,3,g_obo[l_ac].obo04)
#                #         RETURNING g_obo[l_ac].obo04
#                     CALL cl_init_qry_var()
#                     LET g_qryparam.form ="q_obm"
#                     LET g_qryparam.default1 = g_obo[l_ac].obo04
#                     CALL cl_create_qry() RETURNING g_obo[l_ac].obo04
#                     CALL FGL_DIALOG_SETBUFFER( g_obo[l_ac].obo04 )
#                     NEXT FIELD obo04
 #NO.MOD-4B0123   --end
                WHEN INFIELD(obo06)
                #    CALL q_oac(10,3,g_obo[l_ac].obo06)
                #         RETURNING g_obo[l_ac].obo06
                     CALL cl_init_qry_var()
                     LET g_qryparam.form="q_oac"
                     CALL cl_create_qry() RETURNING g_obo[l_ac].obo06
#                     CALL FGL_DIALOG_SETBUFFER( g_obo[l_ac].obo06 )
                     NEXT FIELD obo06
                OTHERWISE
                     EXIT CASE
            END CASE

        ON ACTION CONTROLN
            CALL i105_b_askkey()
            EXIT INPUT
        ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092

        ON ACTION CONTROLG
            CALL cl_cmdask()

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
 
        END INPUT

 
    #FUN-5B0113-begin
     LET g_obn.obnmodu = g_user
     LET g_obn.obndate = g_today
     UPDATE obn_file SET obnmodu = g_obn.obnmodu,obndate = g_obn.obndate
      WHERE obn01 = g_obn.obn01
     IF SQLCA.SQLCODE OR STATUS = 100 THEN
        CALL cl_err('upd obn',SQLCA.SQLCODE,1)
     END IF
     DISPLAY BY NAME g_obn.obnmodu,g_obn.obndate
    #FUN-5B0113-end

    CLOSE i105_bcl
    COMMIT WORK
END FUNCTION

FUNCTION i105_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680108 VARCHAR(200)

    CLEAR gen02                           #清除FORMONLY欄位
 CONSTRUCT l_wc2 ON obo02,obo03,obo04,obo05,obo06,obo07
            FROM s_obo[1].obo02,s_obo[1].obo03,s_obo[1].obo04,
                 s_obo[1].obo05,s_obo[1].obo06,s_obo[1].obo07
         ON ACTION CONTROLP
            CASE
 #NO.MOD-4B0123   -begin
#                WHEN INFIELD(obo04)
#                #    CALL q_obm(10,3,g_obo[l_ac].obo04)
#                #         RETURNING g_obo[l_ac].obo04
#                     CALL cl_init_qry_var()
#                     LET g_qryparam.state ="c"
#                     LET g_qryparam.form ="q_obm"
#                     LET g_qryparam.default1 = g_obo[l_ac].obo04
#                     CALL cl_create_qry() RETURNING g_qryparam.multiret
#                     DISPLAY g_qryparam.multiret TO s_obo[1].obo04
#                     NEXT FIELD obo04
                WHEN INFIELD(obo05)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state="c"
                     LET g_qryparam.form="q_oac"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO s_obo[1].obo05
                     NEXT FIELD obo05
 #NO.MOD-4B0123   --end
                WHEN INFIELD(obo06)
                #    CALL q_oac(10,3,g_obo[l_ac].obo06)
                #         RETURNING g_obo[l_ac].obo06
                     CALL cl_init_qry_var()
                     LET g_qryparam.state="c"
                     LET g_qryparam.form="q_oac"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO s_obo[1].obo06
                     NEXT FIELD obo06
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
 
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i105_b_fill(l_wc2)
END FUNCTION

FUNCTION i105_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680108 VARCHAR(200)

    LET g_sql =
        "SELECT obo02,obo03,'',obo04,obo05,'',obo06,'',obo07,''",
        "  FROM obo_file ",
        " WHERE obo01 ='",g_obn.obn01,"'",
        "   AND ",p_wc2 CLIPPED,                     #單身
        " ORDER BY obo02"
    PREPARE i105_pb FROM g_sql
    DECLARE obo_curs                       #SCROLL CURSOR
        CURSOR FOR i105_pb

    CALL g_obo.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    CALL cl_getmsg('axd-034',g_lang) RETURNING g_msg
    FOREACH obo_curs INTO g_obo[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        CASE g_obo[g_cnt].obo03
          WHEN '1'  LET g_obo[g_cnt].desc=g_msg[1,4]
          WHEN '2'  LET g_obo[g_cnt].desc=g_msg[5,8]
          WHEN '3'  LET g_obo[g_cnt].desc=g_msg[9,12]
        END CASE
        SELECT oac02 INTO g_obo[g_cnt].oac02b FROM oac_file
         WHERE oac01=g_obo[g_cnt].obo05
        SELECT oac02 INTO g_obo[g_cnt].oac02c FROM oac_file
         WHERE oac01=g_obo[g_cnt].obo06
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
        END IF
    END FOREACH
    CALL g_obo.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
    LET g_cnt = 0
END FUNCTION

FUNCTION i105_bp(p_ud)
DEFINE
    p_ud            LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_obo TO s_obo.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL i105_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
      ON ACTION previous
         CALL i105_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
      ON ACTION jump
         CALL i105_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
      ON ACTION next
         CALL i105_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
      ON ACTION last
         CALL i105_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION related_document                #No:FUN-6A0165  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092

      # No:FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No:FUN-530067 ---end---

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)

END FUNCTION


FUNCTION i105_copy()
DEFINE
    l_obn		RECORD LIKE obn_file.*,
    l_oldno,l_newno	LIKE obn_file.obn01

    IF s_shut(0) THEN RETURN END IF
    IF g_obn.obn01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    LET g_before_input_done = FALSE
    CALL i105_set_entry('a')
    LET g_before_input_done = TRUE
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092

    INPUT l_newno FROM obn01
        AFTER FIELD obn01
            IF l_newno IS NULL THEN NEXT FIELD obn01 END IF
            SELECT COUNT(*) INTO g_cnt FROM obn_file WHERE obn01 = l_newno
            IF g_cnt > 0 THEN
                CALL cl_err(l_newno,-239,0)
                NEXT FIELD obn01
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
        DISPLAY BY NAME g_obn.obn01 ATTRIBUTE(YELLOW)
        RETURN
    END IF
    LET l_obn.* = g_obn.*
    LET l_obn.obn01  =l_newno   #新的鍵值
    LET l_obn.obnuser=g_user    #資料所有者
    LET l_obn.obngrup=g_grup    #資料所有者所屬群
    LET l_obn.obnmodu=NULL      #資料修改日期
    LET l_obn.obndate=g_today   #資料建立日期
    LET l_obn.obnacti='Y'       #有效資料
    BEGIN WORK
    INSERT INTO obn_file VALUES (l_obn.*)
    IF SQLCA.sqlcode THEN
        CALL cl_err('obn:',SQLCA.sqlcode,0)
        RETURN
    END IF

    DROP TABLE x
    SELECT * FROM obo_file         #單身復制
        WHERE obo01=g_obn.obn01
        INTO TEMP x
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_obn.obn01,SQLCA.sqlcode,0)
        RETURN
    END IF
    UPDATE x
        SET   obo01=l_newno
    INSERT INTO obo_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err('obo:',SQLCA.sqlcode,0)
        ROLLBACK WORK
        RETURN
    END IF
    COMMIT WORK
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
        ATTRIBUTE(REVERSE)
     LET l_oldno = g_obn.obn01
     SELECT ROWID,obn_file.* INTO g_obn_rowid,g_obn.* FROM obn_file WHERE obn01 = l_newno
     CALL i105_u()
     CALL i105_b()
     SELECT ROWID,obn_file.* INTO g_obn_rowid,g_obn.* FROM obn_file WHERE obn01 = l_oldno
     CALL i105_show()
END FUNCTION

FUNCTION i105_out()
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680108 SMALLINT
    sr              RECORD
        obn01       LIKE obn_file.obn01,
        obo02       LIKE obo_file.obo02,
        obo03       LIKE obo_file.obo03,
        obo04       LIKE obo_file.obo04,
        obo05       LIKE obo_file.obo05,
        oac02b      LIKE oac_file.oac02,
        obo06       LIKE obo_file.obo06,
        oac02c      LIKE oac_file.oac02,
        obo07       LIKE obo_file.obo07
                    END RECORD,
        l_name      LIKE type_file.chr20   #External(Disk) file name  #No.FUN-680108 VARCHAR(20)
    IF cl_null(g_wc) AND NOT cl_null(g_obn.obn01) THEN
       LET g_wc = " obn01 = '",g_obn.obn01,"'"
    END IF
    IF cl_null(g_wc2) THEN LET g_wc2 = "1=1"
    END IF
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang #No.TQC-5B0212
    LET g_sql="SELECT obn01,obo02,obo03,obo04,obo05,'',obo06,'',obo07 ",
          " FROM obn_file,OUTER obo_file ",
          " WHERE obn01 = obo_file.obo01 AND ",g_wc CLIPPED,
          " AND ",g_wc2 CLIPPED
    PREPARE i105_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i105_co                         # SCROLL CURSOR
         CURSOR FOR i105_p1

    CALL cl_outnam('axdi105') RETURNING l_name
    START REPORT i105_rep TO l_name

    FOREACH i105_co INTO sr.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        IF cl_null(sr.obo07) THEN LET sr.obo07 = 0 END IF
        SELECT oac02 INTO sr.oac02b FROM oac_file WHERE oac01=sr.obo05
        SELECT oac02 INTO sr.oac02c FROM oac_file WHERE oac01=sr.obo06
        OUTPUT TO REPORT i105_rep(sr.*)

    END FOREACH

    FINISH REPORT i105_rep

    CLOSE i105_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION

REPORT i105_rep(sr)
DEFINE
    l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680108 VARCHAR(1)
    l_sw            LIKE type_file.chr1,          #No.FUN-680108 VARCHAR(1)
    l_i             LIKE type_file.num5,          #No.FUN-680108 SMALLINT
    l_desc1         LIKE ze_file.ze03,            #No.FUN-680108 VARCHAR(20)
    sr              RECORD
        obn01       LIKE obn_file.obn01,
        obo02       LIKE obo_file.obo02,
        obo03       LIKE obo_file.obo03,
        obo04       LIKE obo_file.obo04,
        obo05       LIKE obo_file.obo05,
        oac02b      LIKE oac_file.oac02,
        obo06       LIKE obo_file.obo06,
        oac02c      LIKE oac_file.oac02,
        obo07       LIKE obo_file.obo07
                    END RECORD
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line

    ORDER BY sr.obn01,sr.obo02

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
                  g_x[37], g_x[38],g_x[39],g_x[40]
            PRINT g_dash1
            LET l_trailer_sw = 'y'

 #NO.MOD-4B0067  --begin
#       BEFORE GROUP OF sr.obn01  #等級
#           PRINT COLUMN 02,sr.obn01 CLIPPED;
 #NO.MOD-4B0067  --end

        ON EVERY ROW
            CASE sr.obo03
                 WHEN '1' CALL cl_getmsg('axd-105',g_lang) RETURNING l_desc1
                 WHEN '2' CALL cl_getmsg('axd-106',g_lang) RETURNING l_desc1
                 WHEN '3' CALL cl_getmsg('axd-107',g_lang) RETURNING l_desc1
            END CASE
            PRINT COLUMN g_c[31],sr.obn01,
                  COLUMN g_c[32],sr.obo02 USING '<<<<',
                  COLUMN g_c[33],sr.obo03,
                  COLUMN g_c[34],l_desc1,
                  COLUMN g_c[35],sr.obo04,
                  COLUMN g_c[36],sr.obo05,
                  COLUMN g_c[37],sr.oac02b,
                  COLUMN g_c[38],sr.obo06,
                  COLUMN g_c[39],sr.oac02c,
                  COLUMN g_c[40],sr.obo07 USING "-------&"

        AFTER GROUP OF sr.obn01  #等級
            PRINT

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

FUNCTION i105_set_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)

   IF INFIELD(obo03) OR (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("obo06",TRUE)
   END IF

END FUNCTION

FUNCTION i105_set_no_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)
   IF INFIELD(obo03) OR (NOT g_before_input_done) THEN
        IF g_obo[l_ac].obo03 <> '1' THEN
            CALL cl_set_comp_entry("obo06",FALSE)
        END IF
   END IF
END FUNCTION

FUNCTION i105_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)

   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("obn01",TRUE)
   END IF

END FUNCTION

FUNCTION i105_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)

   IF (NOT g_before_input_done) THEN
       IF p_cmd = 'u' AND g_chkey = 'N' THEN
           CALL cl_set_comp_entry("obn01",FALSE)
       END IF
   END IF

END FUNCTION
#Patch....NO:MOD-5A0095 <001,002> #
