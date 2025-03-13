# Prog. Version..: '5.10.00-08.01.04(00006)'     #
#
# Pattern name...: axdi130.4gl
# Descriptions...: 集團間銷售預測維護作業
# Date & Author..: 04/03/25 By Hawk
# Modify.........: 04/07/19 By Wiky Bugno:MOD-470041 修改INSERT INTO...
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬ima02
# Modify.........: No.MOD-4A0332 04/10/28 By Carrier
# Modify.........: No.MOD-4B0067 04/11/18 BY DAY 將變數用Like方式定義
# Modify.........: No:FUN-520024 05/02/24 By Day 報表轉XML
# Modify.........: No.MOD-580212 05/09/08 By ice 小數位數根據azi檔的設置來取位
# Modify.........: No:TQC-5B0110 05/11/12 By CoCo 料號位置調整
# Modify.........: No:FUN-5B0113 05/11/22 By Claire 修改單身後單頭的資料更改者及最近修改日應update
# Modify.........: NO.FUN-590118 06/01/12 By Rosayu 將項次改成'###&'
# Modify.........: No:MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能monster代
# Modify.........: No:FUN-680108 06/08/29 By Xufeng 字段類型定義改為LIKE     
# Modify.........: No:FUN-690022 06/09/19 By jamie 判斷imaacti
# Modify.........: Mo.FUN-6A0078 06/10/24 By xumin g_no_ask改mi_no_ask
# Modify.........: No:FUN-6A0165 06/11/09 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No:FUN-6A0092 06/11/14 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上

DATABASE ds

GLOBALS "../../config/top.global"

#模組變數(Module Variables)
DEFINE
    g_obc    RECORD LIKE obc_file.*,       #集團間銷售預測單頭檔
    g_obc_t  RECORD LIKE obc_file.*,       #集團間銷售預測單頭檔(舊值)
    g_obc_o  RECORD LIKE obc_file.*,       #集團間銷售預測單頭檔(舊值)
    g_obc01_t       LIKE obc_file.obc01,   #(舊值)
    g_obc02_t       LIKE obc_file.obc02,   #(舊值)#NO.MOD-4A0332
    g_obc021_t      INT,  #(舊值)#NO.MOD-4A0332
    g_obc_rowid     LIKE type_file.chr18,         #No.FUN-680108 INT
 g_obd           DYNAMIC ARRAY OF RECORD#
        obd03       LIKE obd_file.obd03,   #序號
        obd04       LIKE obd_file.obd04,   #計劃期別
        obd06       LIKE obd_file.obd06,   #單價
        obd07       LIKE obd_file.obd07,   #金額
        obd08       LIKE obd_file.obd08,   #本階需求量
        obd09       LIKE obd_file.obd09,   #本階調整量
        obd10       LIKE obd_file.obd10,   #下階需求量
        obd11       LIKE obd_file.obd11,   #下階調整量
        obd12       LIKE obd_file.obd12    #小計
                    END RECORD,
 g_obd_t         RECORD                 #派車單單身檔 (舊值)
        obd03       LIKE obd_file.obd03,   #序號
        obd04       LIKE obd_file.obd04,   #計劃期別
        obd06       LIKE obd_file.obd06,   #單價
        obd07       LIKE obd_file.obd07,   #金額
        obd08       LIKE obd_file.obd08,   #本階需求量
        obd09       LIKE obd_file.obd09,   #本階調整量
        obd10       LIKE obd_file.obd10,   #下階需求量
        obd11       LIKE obd_file.obd11,   #下階調整量
        obd12       LIKE obd_file.obd12    #小計
                    END RECORD,
    g_cmd           LIKE type_file.chr1000,       #No.FUN-680108 VARCHAR(200) 
    g_wc            STRING,
    g_sql           STRING,
    g_wc2           STRING,
    g_adf       RECORD LIKE adf_file.*,
    g_adg       RECORD LIKE adg_file.*,
    g_yy            LIKE type_file.num5,     #No.FUN-680108 SMALLINT
    g_mm            LIKE type_file.num5,     #No.FUN-680108 SMALLINT
    g_wk            LIKE type_file.num5,     #No.FUN-680108 SMALLINT
    g_xx            LIKE type_file.num5,     #No.FUN-680108 SMALLINT
    g_rec_b         LIKE type_file.num5,     #單身筆數        #No.FUN-680108 SMALLINT 
    g_flag          LIKE type_file.chr1,     #No.FUN-680108 VARCHAR(1)
    l_ac            LIKE type_file.num5,     #目前處理的ARRAY CNT#No.FUN-680108 SMALLINT
    p_row,p_col     LIKE type_file.num5      #No.FUN-680108 SMALLINT

DEFINE   g_before_input_done LIKE type_file.num5                         #No.FUN-680108 SMALLINT

DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE NOWAIT SQL
DEFINE   g_cnt          LIKE type_file.num10     #No.FUN-680108 INTEGER
DEFINE   g_chr          LIKE type_file.chr1      #No.FUN-680108 VARCHAR(01)
DEFINE   g_i            LIKE type_file.num5      #count/index for any purpose#No.FUN-680108 SMALLINT
DEFINE   g_msg          LIKE type_file.chr1000   #No.FUN-680108 VARCHAR(72)
DEFINE   i              LIKE type_file.num5      #No.FUN-680108 SMALLINT
DEFINE   g_row_count    LIKE type_file.num10     #No.FUN-680108 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10     #No.FUN-680108 INTEGER
DEFINE   g_jump         LIKE type_file.num10     #No.FUN-680108 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5      #No.FUN-680108 SMALLINT    #No.FUN-6A0078

#主程式開始
MAIN
DEFINE
    l_tobd         LIKE type_file.chr8     #計算被使用時間               #No.FUN-680108 VARCHAR(8)

    OPTIONS                                #改變一些系統預設值
        FORM LINE       FIRST + 2,         #畫面開始的位置
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

    LET p_row = 4 LET p_col = 7

    LET g_obc01_t = NULL                   #清除鍵值
    INITIALIZE g_obc_t.* TO NULL
    INITIALIZE g_obc.* TO NULL

    OPEN WINDOW i130_w AT p_row,p_col      #顯示畫面
        WITH FORM "axd/42f/axdi130"
         ATTRIBUTE(STYLE = g_win_style)
    CALL cl_ui_init()


    CALL g_x.clear()

    LET g_forupd_sql = "SELECT * FROM obc_file WHERE obc01 =? ",
                       "   AND obc02 =? AND obc021=? FOR UPDATE NOWAIT "
    DECLARE i130_cl CURSOR FROM g_forupd_sql

    CALL i130_menu()    #中文
    CLOSE WINDOW i130_w                    #結束畫面
      CALL cl_used(g_prog,l_tobd,2)       #計算使用時間 (退出使間) #No:MOD-580088  HCN 20050818
        RETURNING l_tobd
END MAIN

#QBE 查詢資料
FUNCTION i130_cs()
    DEFINE   lc_qbe_sn   LIKE gbm_file.gbm01   #No:FUN-580031

    CLEAR FORM
    CALL g_obd.clear()
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092

 CONSTRUCT BY NAME g_wc ON
                  obc01,obc04,obc05,obc07,obc02,
                  obc021,obc03,obcconf,obc06

       BEFORE CONSTRUCT
           CALL cl_qbe_init()           #No:FUN-580031

       ON ACTION CONTROLP
           CASE WHEN INFIELD(obc01)
#                   CALL q_ima(0,0,g_obc.obc01) RETURNING g_obc.obc01
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_ima"
                    LET g_qryparam.state="c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO obc01
                    NEXT FIELD obc01
                WHEN INFIELD(obc04)
#                   CALL q_gen(0,0,g_obc.obc04) RETURNING g_obc.obc04
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gen"
                    LET g_qryparam.state="c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO obc04
                    NEXT FIELD obc04
                WHEN INFIELD(obc05)
#                   CALL q_gem(0,0,g_obc.obc05) RETURNING g_obc.obc05
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gem"
                    LET g_qryparam.state="c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO obc05
                    NEXT FIELD obc05
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

      #No:FUN-580031 --start--
      ON ACTION qbe_select
          CALL cl_qbe_list() RETURNING lc_qbe_sn
          CALL cl_qbe_display_condition(lc_qbe_sn)
      #No:FUN-580031 ---end---
 
       END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF

    CONSTRUCT g_wc2 ON obd03,obdd04,obd06,
                       obd07,obd08,obd09,obd10,obd11,obd12
                  FROM s_obd[1].obd03,s_obd[1].obd04,s_obd[1].obd06,
                       s_obd[1].obd07,s_obd[1].obd08,s_obd[1].obd09,
                       s_obd[1].obd10,s_obd[1].obd11,s_obd[1].obd12

            #No:FUN-580031 --start--
            BEFORE CONSTRUCT
                CALL cl_qbe_display_condition(lc_qbe_sn)
            #No:FUN-580031 ---end---

            ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
            ON ACTION about         #MOD-4C0121
               CALL cl_about()      #MOD-4C0121
 
            ON ACTION help          #MOD-4C0121
               CALL cl_show_help()  #MOD-4C0121
 
            ON ACTION controlg      #MOD-4C0121
               CALL cl_cmdask()     #MOD-4C0121

            #No:FUN-580031 --start--
            ON ACTION qbe_save
                CALL cl_qbe_save()
            #No:FUN-580031 ---end---
 
       END CONSTRUCT
    IF INT_FLAG THEN  RETURN END IF

    IF g_priv2='4' THEN                           #只能使用自己的資料
        LET g_wc = g_wc clipped," AND obcuser = '",g_user,"'"
    END IF
    IF g_priv3='4' THEN                           #只能使用相同群的資料
        LET g_wc = g_wc clipped," AND obcgrup MATCHES '",g_grup CLIPPED,"*'"
    END IF

    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
        LET g_wc = g_wc clipped," AND obcgrup IN ",cl_chk_tgrup_list()
    END IF

 #NO.MOD-4A0332  ---begin
    IF g_wc2 = " 1=1" THEN		           # 若單身未輸入條件
        LET g_sql = "SELECT ROWID, obc01,obc02,obc021 FROM obc_file ",
                    " WHERE ", g_wc CLIPPED,
                    " ORDER BY obc01,obc02,obc021"
    ELSE	                	           # 若單身有輸入條件
        LET g_sql = "SELECT UNIQUE obc_file.ROWID, obc01,obc02,obc021 ",
                    "  FROM obc_file, obd_file ",
                    " WHERE obc01 = obd01",
                    "   AND obc02 = obd02",
                    "   AND obc021= obd021",
                    "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                    " ORDER BY obc01,obc02,obc021"
    END IF
 #NO.MOD-4A0332  --end
    PREPARE i130_prepare FROM g_sql
    IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,0)
        EXIT PROGRAM
    END IF
    DECLARE i130_cs                            #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i130_prepare
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM obc_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(*)",
                  " FROM obc_file,obd_file WHERE ",
                  " obc01=obd01 AND obc02=obd02 AND obd021=obd021",
                  " AND ",g_wc CLIPPED,
                  " AND ",g_wc2 CLIPPED
    END IF
    PREPARE i130_precount FROM g_sql
    DECLARE i130_count CURSOR FOR i130_precount

END FUNCTION

#中文的MENU
FUNCTION i130_menu()
   WHILE TRUE
      CALL i130_bp("G")
      CASE g_action_choice
        WHEN "insert"
           IF cl_chk_act_auth() THEN
              CALL i130_a()
           END IF
        WHEN "query"
           IF cl_chk_act_auth() THEN
              CALL i130_q()
           END IF
        WHEN "delete"
           IF cl_chk_act_auth() THEN
              CALL i130_r()
           END IF
        WHEN "modify"
           IF cl_chk_act_auth() THEN
              CALL i130_u()
           END IF
        WHEN "detail"
           IF cl_chk_act_auth() THEN
              CALL i130_b()
           ELSE
              LET g_action_choice = NULL
           END IF
        WHEN "invalid"
           IF cl_chk_act_auth() THEN
              CALL i130_x()
               CALL cl_set_field_pic(g_obc.obcconf,"","","","",g_obc.obcacti)  #NO.MOD-4A0332
           END IF
        WHEN "sub_plant_req_qty_modify"
           IF cl_chk_act_auth() THEN
               CALL i130_d()
           END IF
        WHEN "confirm"
           IF cl_chk_act_auth() THEN
              CALL i130_y()
               CALL cl_set_field_pic(g_obc.obcconf,"","","","",g_obc.obcacti)  #NO.MOD-4A0332
           END IF
        WHEN "undo_confirm"
           IF cl_chk_act_auth() THEN
              CALL i130_z()
               CALL cl_set_field_pic(g_obc.obcconf,"","","","",g_obc.obcacti)  #NO.MOD-4A0332
           END IF
        WHEN "output"
           IF cl_chk_act_auth() THEN
              CALL i130_out()
           END IF
        WHEN "help"
           CALL cl_show_help()
        WHEN "exit"
           EXIT WHILE
        WHEN "controlg"
           CALL cl_cmdask()
        #No:FUN-6A0165-------add--------str----
        WHEN "related_document"           #相關文件
         IF cl_chk_act_auth() THEN
            IF g_obc.obc01 IS NOT NULL THEN
               LET g_doc.column1 = "obc01"
               LET g_doc.column2 = "obc02"
               LET g_doc.value1 = g_obc.obc01
               LET g_doc.value2 = g_obc.obc02
               CALL cl_doc()
            END IF 
         END IF
        #No:FUN-6A0165-------add--------end----
      END CASE
   END WHILE
END FUNCTION

#Add  輸入
FUNCTION i130_a()
DEFINE l_time LIKE type_file.chr1000,      #No.FUN-680108 VARCHAR(10)
       l_n    LIKE type_file.num5          #No.FUN-680108 SMALLINT
    MESSAGE ""
    IF s_shut(0) THEN RETURN END IF
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_obc.* LIKE obc_file.*
    LET g_obc01_t = NULL
     LET g_obc021_t = NULL    #NO.MOD-4A0332
    LET g_obc_t.*=g_obc.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_obc.obc04   = g_user
        #CALL i130_gen('a')
        LET g_obc.obc05   = g_grup
        #CALL i130_gem('a')
        LET g_obc.obc06   ='N'
        LET g_obc.obcacti ='Y'                   #有效的資料
        LET g_obc.obcconf ='N'                   #有效的資料
        LET g_obc.obcuser = g_user
        LET g_obc.obcgrup = g_grup               #使用者所屬群
        LET g_obc.obcdate = g_today
        CALL i130_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
           INITIALIZE g_obc.* TO NULL
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           CLEAR FORM
           EXIT WHILE
        END IF
        IF g_obc.obc01 IS NULL THEN              # KEY 不可空白
           CONTINUE WHILE
        END IF
 #NO.MOD-4A0332  --begin
#        BEGIN WORK
#        IF g_adz.adzauno='Y' THEN
#           CALL s_axdauno(g_obc.obc01,g_obc.obc02) RETURNING g_i,g_obc.obc01
#           IF g_i THEN #有問題
#              ROLLBACK WORK   #No:7829
#              CONTINUE WHILE
#           END IF
#           DISPLAY BY NAME g_obc.obc01
#       END IF
        INSERT INTO obc_file VALUES(g_obc.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
           CALL cl_err(g_obc.obc01,SQLCA.sqlcode,0)
           CONTINUE WHILE
        END IF
#        COMMIT WORK
 #NO.MOD-4A0332  --end
        SELECT ROWID INTO g_obc_rowid FROM obc_file
         WHERE obc01 = g_obc.obc01
           AND obc02 = g_obc.obc02
           AND obc021= g_obc.obc021
        SELECT * INTO g_obc.* FROM obc_file WHERE ROWID=g_obc_rowid
        LET g_obc01_t = g_obc.obc01        #保留舊值
         LET g_obc02_t = g_obc.obc02        #保留舊值 #NO.MOD-4A0332
         LET g_obc021_t= g_obc.obc021       #保留舊值 #NO.MOD-4A0332
        LET g_obc_t.* = g_obc.*
        LET g_obc_o.* = g_obc.*
        CALL g_obd.clear()
        CALL i130_g_obd()
         CALL i130_b_fill(" 1=1")        #NO.MOD-4A0332
        CALL i130_b()                   #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION

FUNCTION i130_i(p_cmd)
    DEFINE
        l_sw            LIKE type_file.chr1,    #檢查必要欄位是否空白  #No.FUN-680108 VARCHAR(1)
        p_cmd           LIKE type_file.chr1,    #No.FUN-680108 VARCHAR(1)
        l_n             LIKE type_file.num5,    #No.FUN-680108 SMALLINT
        l_no            LIKE type_file.num5,    #No.FUN-680108 SMALLINT
        l_obw           RECORD LIKE obw_file.*
 
 #NO.MOD-4A0332  --begin
    DISPLAY BY NAME g_obc.obc06,g_obc.obcconf,g_obc.obcacti,g_obc.obcuser,
                    g_obc.obcgrup,g_obc.obcdate
 #NO.MOD-4A0332  --end
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092

    INPUT BY NAME g_obc.obc01,g_obc.obc04,g_obc.obc05,g_obc.obc07,
                  g_obc.obc02,g_obc.obc021,g_obc.obc03,g_obc.obc06
                  WITHOUT DEFAULTS HELP 1

        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i130_set_entry(p_cmd)
            CALL i130_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE

        AFTER FIELD obc01
            IF NOT cl_null(g_obc.obc01) THEN
               SELECT ima01 FROM ima_file WHERE ima01 = g_obc.obc01
               IF SQLCA.sqlcode THEN
                  NEXT FIELD obc01
               END IF
               CALL i130_ima02('a')
 #NO.MOD-4A0332  ---begin
               CALL i130_obc()
               IF NOT cl_null(g_errno)  THEN
                  CALL cl_err(g_obc.obc01,g_errno,0)
                  NEXT FIELD obc01
               END IF
 #NO.MOD-4A0332  ---end
            END IF
 #MOD-4A03032  --begin
        #BEFORE FIELD obc021
        #    IF g_obc.obc02 NOT MATCHES '[123]' THEN
        #        LET g_obc.obc021 = 0
        #    END IF
 #MOD-4A03032  --end

        AFTER FIELD obc021
          IF NOT cl_null(g_obc.obc021) THEN
            IF g_obc.obc02 MATCHES '[12]' THEN
                IF g_obc.obc021 > 999999 OR g_obc.obc021 < 100001 THEN
                    CALL cl_err('','axd-085',0)
                    NEXT FIELD obc021
                END IF
            END IF
            IF g_obc.obc02 = '3' THEN
                IF g_obc.obc021 > 99999999 OR g_obc.obc021 < 10000001 THEN
                    CALL cl_err('','axd-085',0)
                    NEXT FIELD obc021
                END IF
            END IF
            CALL i130_date(g_obc.obc021)  #取得年月周旬
            IF (g_obc.obc02 = '1' AND (g_mm > 12 OR g_mm = 0)) OR
               (g_obc.obc02 = '2' AND (g_wk > 53 OR g_wk = 0)) OR
               (g_obc.obc02 = '3' AND (g_mm > 12 OR g_mm = 0 OR
                                       g_xx > 3 OR g_xx = 0)) THEN
                 CALL cl_err('','axd-085',0)
                 NEXT FIELD obc021
            END IF
            SELECT count(*) INTO l_no FROM obc_file
             WHERE obc01 = g_obc.obc01
               AND obc02 = g_obc.obc02
               AND obc021= g_obc.obc021
            IF l_no > 0 THEN
               CALL cl_err('',-239,0)
               NEXT FIELD obc01
            END IF
          END IF

        AFTER FIELD obc04
            IF NOT cl_null(g_obc.obc04) THEN
               IF p_cmd = 'a' OR
                 (p_cmd = 'u' AND g_obc.obc04 != g_obc_t.obc04) THEN
                  CALL i130_gen('a')
                  IF NOT cl_null(g_errno)  THEN
                     CALL cl_err(g_obc.obc04,g_errno,0)
                     LET g_obc.obc04 = g_obc_t.obc04
                     DISPLAY BY NAME g_obc.obc04
                     NEXT FIELD obc04
                  END IF
                  SELECT gen03 INTO g_obc.obc05 FROM gen_file
                   WHERE gen01 = g_obc.obc04
                  DISPLAY BY NAME g_obc.obc04
                  DISPLAY BY NAME g_obc.obc05
               END IF
            END IF

       AFTER FIELD obc05
            IF NOT cl_null(g_obc.obc05) THEN
               IF p_cmd = 'a' OR
                 (p_cmd = 'u' AND g_obc.obc05 != g_obc_t.obc05) THEN
                  CALL i130_gem('a')
                  IF NOT cl_null(g_errno)  THEN
                     CALL cl_err(g_obc.obc05,g_errno,0)
                     LET g_obc.obc05 = g_obc_t.obc05
                     DISPLAY BY NAME g_obc.obc05
                     NEXT FIELD obc05
                  END IF
               END IF
 #NO.MOD-4A0332   --begin
               #CALL i130_obc()
               #IF NOT cl_null(g_errno)  THEN
               #   CALL cl_err(g_obc.obc01,'axd-093',0)
               #   CALL i130_a()
               #END IF
 #NO.MOD-4A0332   --end
            END IF


       ON ACTION CONTROLO
            IF INFIELD(obc01) THEN
                LET g_obc.* = g_obc_t.*
                NEXT FIELD obc01
            END IF

       ON ACTION CONTROLP
           CASE WHEN INFIELD(obc01)
#                   CALL q_ima(0,0,g_obc.obc01) RETURNING g_obc.obc01
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_ima"
                    LET g_qryparam.default1=g_obc.obc01
                    CALL cl_create_qry() RETURNING g_obc.obc01
#                    CALL FGL_DIALOG_SETBUFFER( g_obc.obc01 )
                    DISPLAY BY NAME g_obc.obc01
                    NEXT FIELD obc01
                WHEN INFIELD(obc04)
#                   CALL q_gen(0,0,g_obc.obc04) RETURNING g_obc.obc04
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gen"
                    LET g_qryparam.default1 = g_obc.obc04
                    CALL cl_create_qry() RETURNING g_obc.obc04
#                    CALL FGL_DIALOG_SETBUFFER( g_obc.obc04 )
                    DISPLAY BY NAME g_obc.obc04
                    NEXT FIELD obc04
                WHEN INFIELD(obc05)
#                   CALL q_gem(0,0,g_obc.obc05) RETURNING g_obc.obc05
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gem"
                    LET g_qryparam.default1 = g_obc.obc05
                    CALL cl_create_qry() RETURNING g_obc.obc05
#                    CALL FGL_DIALOG_SETBUFFER( g_obc.obc05 )
                    DISPLAY BY NAME g_obc.obc05
                    NEXT FIELD obc05
                OTHERWISE EXIT CASE
            END CASE

        ON ACTION CONTROLZ
           CALL cl_show_req_fields()

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
END FUNCTION

FUNCTION i130_gem(p_cmd)    #部門
DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680108 VARCHAR(01)
       l_gem02     LIKE gem_file.gem02,
       l_gemacti   LIKE gem_file.gemacti

    LET g_errno = ' '
    SELECT gem02,gemacti INTO l_gem02,l_gemacti
      FROM gem_file
     WHERE gem01 = g_obc.obc05

    CASE
         WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3097'
                                   LET g_obc.obc05 = NULL
         WHEN l_gemacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
        DISPLAY l_gem02 TO FORMONLY.gem02
    END IF
END FUNCTION

FUNCTION i130_gen(p_cmd)    #人員
DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680108 VARCHAR(01)
       l_gen02     LIKE gen_file.gen02,
       l_genacti   LIKE gen_file.genacti

    LET g_errno = ' '
    SELECT gen02,genacti INTO l_gen02,l_genacti
      FROM gen_file
     WHERE gen01 = g_obc.obc04
    CASE
       WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3096'
                                 LET g_obc.obc04 = NULL
       WHEN l_genacti='N' LET g_errno = '9028'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
        DISPLAY l_gen02 TO FORMONLY.gen02
    END IF
END FUNCTION

FUNCTION i130_ima02(p_cmd)    #品名規格
DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680108 VARCHAR(01)
       l_ima02     LIKE ima_file.ima02, 
       l_ima021    LIKE ima_file.ima021,
       l_imaacti   LIKE ima_file.imaacti

    LET g_errno = ' '
    SELECT ima02,ima021,imaacti INTO l_ima02,l_ima021,l_imaacti
      FROM ima_file
     WHERE ima01 = g_obc.obc01
    CASE
       WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3096'
                                 LET g_obc.obc01 = NULL
       WHEN l_imaacti='N' LET g_errno = '9028'
    #FUN-690022------mod-------
       WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
    #FUN-690022------mod-------       
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
        DISPLAY l_ima02 TO FORMONLY.ima02
    END IF
END FUNCTION

FUNCTION i130_obc()           #顯示其他欄位
DEFINE l_imaacti   LIKE ima_file.imaacti

    LET g_errno = ' '
    SELECT ima25,ima96,ima97,imaacti
      INTO g_obc.obc07,g_obc.obc02,g_obc.obc03,l_imaacti
      FROM ima_file
     WHERE ima01 = g_obc.obc01
    CASE
       WHEN (cl_null(g_obc.obc02) OR cl_null(g_obc.obc03))
              LET g_errno = 'axd-093'      #NO.MOD-4A0332
       WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3096'
                                 LET g_obc.obc01 = NULL
       WHEN l_imaacti='N' LET g_errno = '9028'
   #FUN-690022------mod-------
       WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
   #FUN-690022------mod-------       
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    DISPLAY g_obc.obc07 TO obc07
    DISPLAY g_obc.obc02 TO obc02
    DISPLAY g_obc.obc03 TO obc03
END FUNCTION

FUNCTION i130_date(l_date)         #取得年月周旬
DEFINE l_date INT
    IF g_obc.obc02 MATCHES '[12]' THEN
        LET g_yy = l_date/100
        IF g_obc.obc02 = '1' THEN
            LET g_mm = l_date-g_yy*100
        ELSE
            LET g_wk = l_date-g_yy*100
        END IF
    ELSE
        LET g_yy = l_date/10000
        LET g_xx = l_date - g_yy*10000
        LET g_mm = g_xx/100
        LET g_xx = g_xx - g_mm * 100
    END IF
END FUNCTION

FUNCTION i130_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_obc.* TO NULL              #No.FUN-6A0165

    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt           #ATTRIBUTE(GREEN)
    CALL i130_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    MESSAGE "Waiting...." ATTRIBUTE(REVERSE)
    OPEN i130_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_obc.obc01,SQLCA.sqlcode,0)
        INITIALIZE g_obc.* TO NULL
    ELSE
        OPEN i130_count
        FETCH i130_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i130_t('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION

FUNCTION i130_t(p_flag)
    DEFINE
        p_flag          LIKE type_file.chr1,        #No.FUN-680108 VARCHAR(1)
        l_abso          LIKE type_file.num10        #No.FUN-680108 INTEGER

 #NO.MOD-4A0332  --begin
    CASE p_flag
        WHEN 'N' FETCH NEXT     i130_cs INTO g_obc_rowid,g_obc.obc01,g_obc.obc02,g_obc.obc021
        WHEN 'P' FETCH PREVIOUS i130_cs INTO g_obc_rowid,g_obc.obc01,g_obc.obc02,g_obc.obc021
        WHEN 'F' FETCH FIRST    i130_cs INTO g_obc_rowid,g_obc.obc01,g_obc.obc02,g_obc.obc021
        WHEN 'L' FETCH LAST     i130_cs INTO g_obc_rowid,g_obc.obc01,g_obc.obc02,g_obc.obc021
        WHEN '/'
            IF (NOT mi_no_ask) THEN   #No.FUN-6A0078
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED || ': ' FOR g_jump   --改g_jump
#               PROMPT g_msg CLIPPED,': ' FOR l_abso
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
            END IF
            FETCH ABSOLUTE g_jump i130_cs INTO g_obc_rowid,g_obc.obc01,g_obc.obc02,g_obc.obc021
    END CASE
 #NO.MOD-4A0332  --end

    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_obc.* TO NULL   #No.TQC-6B0105
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
    END IF

    SELECT * INTO g_obc.* FROM obc_file            # 重讀DB,因TEMP有不被更新特性
       WHERE ROWID = g_obc_rowid
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_obc.obc01,SQLCA.sqlcode,0)
    END IF
    CALL i130_show()                      # 重新顯示
END FUNCTION

FUNCTION i130_show()
    DEFINE l_str LIKE type_file.chr8    #No.FUN-680108 VARCHAR(08)

    LET g_obc_t.* = g_obc.*
    DISPLAY BY NAME g_obc.obc01,g_obc.obc04,g_obc.obc05,g_obc.obc07,
                    g_obc.obc02,g_obc.obc021,g_obc.obc03,g_obc.obc06,
                    g_obc.obcconf
     CALL cl_set_field_pic(g_obc.obcconf,"","","","",g_obc.obcacti)  #NO.MOD-4A0332
    CALL i130_gen('d')
    CALL i130_gem('d')
    CALL i130_ima02('d')
    CALL i130_b_fill(g_wc2)
    CALL i130_obdsum()
    CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
END FUNCTION

FUNCTION i130_g_obd()
DEFINE l_n         LIKE type_file.num5          #No.FUN-680108 SMALLINT
DEFINE l_obd       RECORD LIKE obd_file.*

    FOR i =1 TO g_obc.obc03
        LET g_obd[i].obd03 = i
        CALL i130_obd04(i)
        SELECT * INTO l_obd.* FROM obd_file
         WHERE obd01=g_obc.obc01 AND obd02=g_obc.obc02
           AND obd04=g_obd[i].obd04
           AND obd021=(SELECT MAX(obd021) FROM obd_file
                        WHERE obd01=g_obc.obc01 AND obd02=g_obc.obc02
                          AND obd04=g_obd[i].obd04
                          AND obd021<g_obc.obc021)
        IF SQLCA.sqlcode THEN
           INSERT INTO obd_file(obd01,obd02,obd021,obd03,obd04,obd05 ,
                                obd06,obd07 ,obd08,obd09,obd10 ,
                                 obd11,obd12 ,obd13,obd14,obdconf) #No.MOD-470041
                         VALUES(g_obc.obc01,
                                g_obc.obc02,g_obc.obc021,
                                g_obd[i].obd03, g_obd[i].obd04,'',
                                0,0,0,0,0,0,0,'','','N')
       ELSE
           INSERT INTO obd_file(obd01,obd02,obd021,obd03,obd04,obd05 ,
                                obd06,obd07 ,obd08,obd09,obd10 ,
                                 obd11,obd12 ,obd13,obd14,obdconf) #No.MOD-470041
                         VALUES(g_obc.obc01,g_obc.obc02,g_obc.obc021,
                                g_obd[i].obd03, g_obd[i].obd04,'',
                                l_obd.obd06,l_obd.obd06*l_obd.obd08,
                                l_obd.obd08,0,0,0,l_obd.obd08,'','','N')
       END IF
    END FOR
    LET g_rec_b=g_obc.obc03
     CALL i130_show()   #NO.MOD-4A0332

END FUNCTION

FUNCTION i130_u()
    IF s_shut(0) THEN RETURN END IF
    #若非由MENU進入本程式,則無更新之功能
    IF g_obc.obc01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_obc.obc06 = 'Y' THEN     #檢查資料是否被擷取
        CALL cl_err('','axd-090',0)
        RETURN
    END IF
    SELECT * INTO g_obc.* FROM obc_file
     WHERE obc01 = g_obc.obc01
       AND obc02 = g_obc.obc02
       AND obc021= g_obc.obc021
    IF g_obc.obcacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_obc.obc01,'mfg1000',0)
        RETURN
    END IF
    IF g_obc.obcconf ='Y' THEN    #檢查資料是否為無效
        CALL cl_err(g_obc.obc01,'9022',0)
        RETURN
    END IF
    IF g_obc.obc06 = 'Y' THEN     #檢查資料是否被擷取
        CALL cl_err('','axd-090',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_obc01_t = g_obc.obc01
    LET g_obc_t.* = g_obc.*
    LET g_obc_o.* = g_obc.*
    BEGIN WORK
    OPEN i130_cl USING g_obc.obc01,g_obc.obc02,g_obc.obc021
    IF STATUS THEN
       CALL cl_err("OPEN i130_cl:", STATUS, 1)
       CLOSE i130_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i130_cl INTO g_obc.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_obc.obc01,SQLCA.sqlcode,0)
        CLOSE i130_cl ROLLBACK WORK RETURN
    END IF
    LET g_obc.obcmodu=g_user                     #修改者
    LET g_obc.obcdate = g_today                  #修改日期
    CALL i130_show()                             # 顯示最新資料
    WHILE TRUE
        CALL i130_i("u")                         # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_obc.*=g_obc_t.*
            CALL i130_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
 #NO.MOD-4A0332  --begin
        IF g_obc.obc01 != g_obc01_t OR g_obc.obc021 != g_obc_t.obc021 THEN
           IF cl_confirm('axd-096') THEN
              DELETE FROM obd_file
               WHERE obd01 =g_obc01_t
                 AND obd02 =g_obc_t.obc02
                 AND obd021=g_obc_t.obc021
              DELETE FROM obh_file
               WHERE obh01 =g_obc_t.obc01
                 AND obh02 =g_obc_t.obc02
                 AND obh021=g_obc_t.obc021
              CALL g_obd.clear()
              CALL i130_g_obd()
              CALL i130_b_fill(" 1=1")
           ELSE
              LET g_obc.*=g_obc_t.*
              CONTINUE WHILE
           END IF
        END IF
        UPDATE obc_file SET obc_file.* = g_obc.*    # 更新DB
         WHERE ROWID = g_obc_rowid             # COLAUTH?
        IF SQLCA.sqlcode THEN
            CALL cl_err(g_obc.obc01,SQLCA.sqlcode,0)
            CONTINUE WHILE
        END IF
 #NO.MOD-4A0332  --end
        EXIT WHILE
    END WHILE
    CLOSE i130_cl
    COMMIT WORK
END FUNCTION

FUNCTION i130_x()
DEFINE l_chr       LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)
    IF s_shut(0) THEN RETURN END IF
    IF g_obc.obc01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_obc.obcconf ='Y' THEN    #檢查資料是否為無效
        CALL cl_err(g_obc.obc01,'9022',0)
        RETURN
    END IF
    IF g_obc.obc06 = 'Y' THEN     #檢查資料是否被擷取
        CALL cl_err('','axd-090',0)
        RETURN
    END IF
    BEGIN WORK
    OPEN i130_cl USING g_obc.obc01,g_obc.obc02,g_obc.obc021
    IF STATUS THEN
       CALL cl_err("OPEN i130_cl:", STATUS, 1)
       CLOSE i130_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i130_cl INTO g_obc.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_obc.obc01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i130_show()
    IF cl_exp(0,0,g_obc.obcacti) THEN
        LET g_chr=g_obc.obcacti
        IF g_obc.obcacti='Y' THEN
            LET g_obc.obcacti='N'
        ELSE
            LET g_obc.obcacti='Y'
        END IF
        UPDATE obc_file
            SET obcacti=g_obc.obcacti,
                obcmodu=g_user,
                obcdate=g_today
            WHERE ROWID=g_obc_rowid
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(g_obc.obc01,SQLCA.sqlcode,0)
            LET g_obc.obcacti=g_chr
        END IF
        DISPLAY BY NAME g_obc.obcacti
    END IF
    CLOSE i130_cl
    COMMIT WORK
END FUNCTION

FUNCTION i130_r()
DEFINE l_chr LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)
    IF s_shut(0) THEN RETURN END IF
    IF g_obc.obc01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_obc.obcconf ='Y' THEN    #檢查資料是否為無效
        CALL cl_err(g_obc.obc01,'9022',0)
        RETURN
    END IF
    IF g_obc.obc06 = 'Y' THEN     #檢查資料是否被擷取
        CALL cl_err('','axd-090',0)
        RETURN
    END IF
    BEGIN WORK
    OPEN i130_cl USING g_obc.obc01,g_obc.obc02,g_obc.obc021
    IF STATUS THEN
       CALL cl_err("OPEN i130_cl:", STATUS, 1)
       CLOSE i130_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i130_cl INTO g_obc.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_obc.obc01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i130_show()
    IF cl_delh(15,16) THEN
        DELETE FROM obc_file WHERE ROWID = g_obc_rowid
        IF SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err(g_obc.obc01,SQLCA.sqlcode,0)
        ELSE
           DELETE FROM obd_file WHERE obd01 = g_obc.obc01
                                  AND obd02 = g_obc.obc02
                                  AND obd021= g_obc.obc021
           DELETE FROM obh_file WHERE obh01 = g_obc.obc01
                                  AND obh02 = g_obc.obc02
                                  AND obh021= g_obc.obc021
           CLEAR FORM
           CALL g_obd.clear()
--mi
         OPEN i130_count
         FETCH i130_count INTO g_row_count
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i130_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i130_t('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE   #No.FUN-6A0078
            CALL i130_t('/')
         END IF
--#
        END IF
    END IF
    CLOSE i130_cl
    COMMIT WORK
END FUNCTION

#單身
FUNCTION i130_b()
DEFINE
    l_buf           LIKE type_file.chr1000,  #儲存尚在使用中之下游檔案之檔名    #No.FUN-680108 VARCHAR(80)
    l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT                 #No.FUN-680108 SMALLINT
    l_n             LIKE type_file.num5,     #檢查重複用                        #No.FUN-680108 SMALLINT
    l_lock_sw       LIKE type_file.chr1,     #單身鎖住否                        #No.FUN-680108 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,     #處理狀態                          #No.FUN-680108 VARCHAR(1)
    l_bcur          LIKE type_file.chr1,     #'1':表存放位置有值,'2':則為NULL   #No.FUN-680108 VARCHAR(01)
    l_obc021        INT,
    l_allow_insert  LIKE type_file.num5,     #可新增否                          #No.FUN-680108 SMALLINT
    l_allow_delete  LIKE type_file.num5      #可刪除否                          #No.FUN-680108 SMALLINT

    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_obc.obc01 IS NULL THEN
       RETURN
    END IF
    SELECT * INTO g_obc.* FROM obc_file
     WHERE obc01 = g_obc.obc01
       AND obc02 = g_obc.obc02
       AND obc021= g_obc.obc021

    IF g_obc.obcacti MATCHES'[Nn]' THEN
       CALL cl_err(g_obc.obc01,'mfg1000',0)
       RETURN
    END IF
    IF g_obc.obcconf ='Y' THEN    #檢查資料是否為審核
        CALL cl_err(g_obc.obc01,'9022',0)
        RETURN
    END IF
    IF g_obc.obc06 = 'Y' THEN     #檢查資料是否被擷取
        CALL cl_err('','axd-090',0)
        RETURN
    END IF

    CALL cl_opmsg('b')
    LET g_forupd_sql = "SELECT obd03,obd04,obd06,obd07,obd08,",
                       "       obd09,obd10,obd11,obd12 FROM obd_file ",
                       " WHERE obd01 =? AND obd02 =? AND obd021=? ",
                       "   AND obd03 =? FOR UPDATE NOWAIT "
    DECLARE i130_bcl CURSOR FROM g_forupd_sql

    LET l_ac_t = 0

      LET l_allow_insert = cl_detail_input_auth("insert")
      LET l_allow_delete = cl_detail_input_auth("delete")

 #NO.MOD-4A0332  --begin
      INPUT ARRAY g_obd WITHOUT DEFAULTS FROM s_obd.*
            ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=FALSE,DELETE ROW=FALSE,
                      APPEND ROW=l_allow_insert)
 #NO.MOD-4A0332  --end

    BEFORE INPUT
        DISPLAY "BEFORE INPUT"
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
           LET g_i=g_obd.getLength()

    BEFORE ROW
        DISPLAY "BEFORE ROW"
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            IF l_ac > g_obc.obc03 THEN
               EXIT INPUT
            END IF
            BEGIN WORK
            OPEN i130_cl USING g_obc.obc01,g_obc.obc02,g_obc.obc021
            IF STATUS THEN
               CALL cl_err("OPEN i130_cl:", STATUS, 1)
               CLOSE i130_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH i130_cl INTO g_obc.*               # 對DB鎖定
            IF SQLCA.sqlcode THEN
                CALL cl_err(g_obc.obc01,SQLCA.sqlcode,0)
                CLOSE i130_cl ROLLBACK WORK RETURN
            END IF
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_obd_t.* = g_obd[l_ac].*  #BACKUP
                OPEN i130_bcl USING g_obc.obc01,g_obc.obc02,g_obc.obc021,g_obd_t.obd03
                IF STATUS THEN
                   CALL cl_err("OPEN i130_bcl:", STATUS, 1)
                   LET l_lock_sw='Y'
                ELSE
                   FETCH i130_bcl INTO g_obd[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_obd_t.obd03,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                END IF
#                CALL i130_set_entry_b(p_cmd)
#                CALL i130_set_no_entry_b(p_cmd)
                 CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF

    BEFORE INSERT
        DISPLAY "BEFORE INSERT"
            LET p_cmd='a'
            LET l_n = ARR_COUNT()
            INITIALIZE g_obd[l_ac].* TO NULL      #900423
            LET g_obd_t.* = g_obd[l_ac].*     #新輸入資料
#            CALL i130_set_entry_b(p_cmd)
#            CALL i130_set_no_entry_b(p_cmd)
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD obd03

    AFTER INSERT
        DISPLAY "AFTER INSERT"
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO obd_file(obd01,obd02,obd021,obd03,obd04,obd05 ,
                                 obd06,obd07 ,obd08,obd09,obd10 ,
                                  obd11,obd12 ,obd13,obd14,obdconf) #No.MOD-470041
                          VALUES(g_obc.obc01,g_obc.obc02,g_obc.obc021,
                                 g_obd[l_ac].obd03, g_obd[l_ac].obd04, '',
                                 g_obd[l_ac].obd06, g_obd[l_ac].obd07,
                                 g_obd[l_ac].obd08, g_obd[l_ac].obd09,
                                 g_obd[l_ac].obd10, g_obd[l_ac].obd11,
                                 g_obd[l_ac].obd12,'','','N')
            IF SQLCA.SQLcode  THEN
                        CALL cl_err(g_obd[l_ac].obd03,SQLCA.sqlcode,0)
                        CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
               CALL i130_obdsum()    #顯示合計
            END IF


        BEFORE FIELD obd03                        # dgeeault 序號
            IF g_obd[l_ac].obd03 IS NULL or g_obd[l_ac].obd03 = 0 THEN
                SELECT max(obd03)+1 INTO g_obd[l_ac].obd03 FROM obd_file
                    WHERE obd01 = g_obc.obc01
                      AND obd02 = g_obc.obc02
                      AND obd021= g_obc.obc021
                IF g_obd[l_ac].obd03 IS NULL THEN
                    LET g_obd[l_ac].obd03 = 1
                END IF
            END IF
            CALL i130_obd04(l_ac)
            NEXT FIELD obd06

        AFTER FIELD obd06
            IF NOT cl_null(g_obd[l_ac].obd06) THEN
               IF g_obd[l_ac].obd06 < 0 THEN
                NEXT FIELD obd06
               END IF
            END IF

        AFTER FIELD obd08
          IF NOT cl_null(g_obd[l_ac].obd08) THEN
            IF g_obd[l_ac].obd08<0 THEN
            NEXT FIELD obd08
            END IF
            IF cl_null(g_obd[l_ac].obd09) THEN LET g_obd[l_ac].obd09 = 0 END IF
            IF cl_null(g_obd[l_ac].obd10) THEN LET g_obd[l_ac].obd10 = 0 END IF
            IF cl_null(g_obd[l_ac].obd11) THEN LET g_obd[l_ac].obd11 = 0 END IF
            LET g_obd[l_ac].obd12 = g_obd[l_ac].obd08 +
                                    g_obd[l_ac].obd10 +
                                    g_obd[l_ac].obd11
            LET g_obd[l_ac].obd07 = g_obd[l_ac].obd12 * g_obd[l_ac].obd06
            #------MOD-5A0095 START----------
            DISPLAY BY NAME g_obd[l_ac].obd12
            DISPLAY BY NAME g_obd[l_ac].obd07
            #------MOD-5A0095 END------------
          END IF

        BEFORE DELETE                            #是否取消單身
            IF NOT cl_null(g_obd_t.obd03) THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM obd_file
                    WHERE obd01 = g_obc.obc01
                      AND obd02 = g_obc.obc02
                      AND obd021= g_obc.obc021
                      AND obd03 = g_obd_t.obd03
                IF SQLCA.sqlcode THEN
                    CALL cl_err(g_obd_t.obd03,SQLCA.sqlcode,0)
                    ROLLBACK WORK
                    CANCEL DELETE
 #NO.MOD-4A0332  --begin
                ELSE
                    DELETE FROM obh_file
                     WHERE obh01 = g_obc.obc01
                       AND obh02 = g_obc.obc02
                       AND obh021= g_obc.obc021
                       AND obh03 = g_obd_t.obd03
 #NO.MOD-4A0332  --end
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
            END IF
            COMMIT WORK

    ON ROW CHANGE
        DISPLAY "ON ROW CHANGE"
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_obd[l_ac].* = g_obd_t.*
               CLOSE i130_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_obd[l_ac].obd03,-263,1)
               LET g_obd[l_ac].* = g_obd_t.*
            ELSE
               UPDATE obd_file
                  SET obd03 = g_obd[l_ac].obd03,
                      obd04 = g_obd[l_ac].obd04,
                      obd06 = g_obd[l_ac].obd06,
                      obd07 = g_obd[l_ac].obd07,
                      obd08 = g_obd[l_ac].obd08,
                      obd09 = g_obd[l_ac].obd09,
                      obd10 = g_obd[l_ac].obd10,
                      obd11 = g_obd[l_ac].obd11,
                      obd12 = g_obd[l_ac].obd12
                WHERE CURRENT OF i130_bcl
               IF SQLCA.sqlcode THEN
                   CALL cl_err(g_obd[l_ac].obd03,SQLCA.sqlcode,0)
                   LET g_obd[l_ac].* = g_obd_t.*
               ELSE
 #NO.MOD-4A0332  --begin
               IF g_obd[l_ac].obd03 <> g_obd_t.obd03 THEN
                  UPDATE obh_file SET obh03=g_obd[l_ac].obd03
                   WHERE obh01 = g_obc.obc01
                     AND obh02 = g_obc.obc02
                     AND obh021= g_obc.obc021
                     AND obh03 = g_obd_t.obd03
               END IF
 #NO.MOD-4A0332  --end
                   MESSAGE 'UPDATE O.K'
                   CALL i130_obdsum()    #顯示合計
                   COMMIT WORK
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
                  LET g_obd[l_ac].* = g_obd_t.*
               END IF
               CLOSE i130_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE i130_bcl
            COMMIT WORK

       ON ACTION CONTROLN
           CALL i130_b_askkey()
           EXIT INPUT
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092

      #MOD-650015 --start
      #  ON ACTION CONTROLO                       #沿用所有欄位
      #      IF INFIELD(obd03) AND l_ac > 1 THEN
      #          LET g_obd[l_ac].* = g_obd[l_ac-1].*
      #          NEXT FIELD obd03
      #      END IF
      #MOD-650015 --start

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
     UPDATE obc_file SET obcmodu = g_user,obcdate = g_today
      WHERE obc01 = g_obc.obc01
        AND obc02 = g_obc.obc02
        AND obc021 = g_obc.obc021
     IF SQLCA.SQLCODE OR STATUS = 100 THEN
        CALL cl_err('upd obc',SQLCA.SQLCODE,1)
     END IF
    #FUN-5B0113-end

    CLOSE i130_bcl
    COMMIT WORK
    CALL i130_delall()
END FUNCTION

FUNCTION i130_delall()
    SELECT COUNT(*) INTO g_cnt FROM obd_file
        WHERE obd01 = g_obc.obc01
          AND obd02 = g_obc.obc02
          AND obd021= g_obc.obc021
    IF g_cnt = 0 THEN                   # 未輸入單身資料, 是否取消單頭資料
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED
       DELETE FROM obc_file WHERE ROWID = g_obc_rowid
       IF SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err(g_obc.obc01,SQLCA.sqlcode,0)
       END IF
    END IF
END FUNCTION

FUNCTION i130_obdsum()                #顯示合計
DEFINE l_obd07t LIKE obd_file.obd07,
       l_obd08t LIKE obd_file.obd08,
       l_obd10t LIKE obd_file.obd10,
       l_obd12t LIKE obd_file.obd12
    LET l_obd07t = 0
    LET l_obd08t = 0
    LET l_obd10t = 0
    LET l_obd12t = 0
    FOR i = 1 TO g_obc.obc03
        IF cl_null(g_obd[i].obd03) THEN
            EXIT FOR
        END IF
        LET l_obd07t = l_obd07t + g_obd[i].obd07
        LET l_obd08t = l_obd08t + g_obd[i].obd08
        LET l_obd10t = l_obd10t + g_obd[i].obd10
        LET l_obd12t = l_obd12t + g_obd[i].obd12
    END FOR
    DISPLAY l_obd07t,l_obd08t,l_obd10t,l_obd12t
         TO FORMONLY.obd07t,FORMONLY.obd08t,FORMONLY.obd10t,
            FORMONLY.obd12t
END FUNCTION

FUNCTION i130_obd04(j)       #自動獲取obd04
DEFINE l_obc021 INT,
       j        LIKE type_file.num5          #No.FUN-680108 SMALLINT
    IF j = 1 THEN
        LET g_obd[j].obd04 = g_obc.obc021
    ELSE
        LET l_obc021 = g_obd[j-1].obd04
        CALL i130_date(l_obc021)
        CASE g_obc.obc02
           WHEN '1'
                   IF g_mm = 12 THEN
                       LET g_obd[j].obd04 = l_obc021 + 89
                   ELSE
                       LET g_obd[j].obd04 = l_obc021+1
                   END IF
           WHEN '2'
                   IF g_wk = 53 THEN
                       LET g_obd[j].obd04 = l_obc021 + 49
                   ELSE
                       LET g_obd[j].obd04 = l_obc021+1
                   END IF
           WHEN '3'
                   IF g_xx =  3 THEN
                       IF g_mm = 12 THEN
                         LET g_obd[j].obd04 = l_obc021 + 8898
                       ELSE
                         LET g_obd[j].obd04 = l_obc021 + 98
                       END IF
                   ELSE
                       LET g_obd[j].obd04 = l_obc021 + 1
                   END IF
        END CASE
    END IF
END FUNCTION

FUNCTION i130_b_askkey()
DEFINE l_wc   LIKE type_file.chr1000       #No.FUN-680108 VARCHAR(200)

    CONSTRUCT l_wc ON obd03,obdd04,obd06,  #螢幕上取單身條件
                      obd07,obd08,obd09,obd10,obd11,obd12
       FROM s_obd[1].obd03,s_obd[1].obd04,s_obd[1].obd06,s_obd[1].obd07,
            s_obd[1].obd08,s_obd[1].obd09,s_obd[1].obd10,s_obd[1].obd11,
            s_obd[1].obd12

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
    CALL i130_b_fill(l_wc)
END FUNCTION

FUNCTION i130_b_fill(p_wc)              #BODY FILL UP
DEFINE p_wc    LIKE type_file.chr1000       #No.FUN-680108 VARCHAR(400)

    LET g_sql =
    "SELECT obd03,obd04,obd06,",
       " obd07,obd08,obd09,obd10,obd11,obd12",
       " FROM obd_file",
       " WHERE obd01 = '",g_obc.obc01,"'",
       "   AND obd02 = '",g_obc.obc02,"'",
       "   AND obd021 = '",g_obc.obc021,"'",
       "   AND ",p_wc CLIPPED ,
       " ORDER BY 1"
    PREPARE i130_prepare2 FROM g_sql      #預備一下
    DECLARE obd_cs CURSOR FOR i130_prepare2
    CALL g_obd.clear()
    LET g_cnt = 1
    LET g_rec_b=0
    FOREACH obd_cs INTO g_obd[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err('','9035',0)
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_obd.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
 #NO.MOD-4A0332  ---begin
    #IF g_rec_b=0 AND g_cnt > 1 THEN
    #   LET g_rec_b=999
    #END IF
 #NO.MOD-4A0332  --end
    DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
    LET g_cnt = 0
END FUNCTION

FUNCTION i130_bp(p_ud)
DEFINE
    p_ud            LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_obd TO s_obd.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

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
         CALL i130_t('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST

      ON ACTION previous
         CALL i130_t('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST

      ON ACTION jump
         CALL i130_t('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST

      ON ACTION next
         CALL i130_t('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST

      ON ACTION last
         CALL i130_t('L')
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
      ON ACTION sub_plant_req_qty_modify
         LET g_action_choice="sub_plant_req_qty_modify"
         EXIT DISPLAY
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
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


FUNCTION i130_y() #確認
DEFINE l_no  LIKE type_file.num5,         #No.FUN-680108 SMALLINT
       l_n   LIKE type_file.num5          #No.FUN-680108 SMALLINT
    IF g_obc.obc01 IS NULL THEN RETURN END IF
    SELECT * INTO g_obc.* FROM obc_file
     WHERE obc01 = g_obc.obc01
       AND obc02 = g_obc.obc02
       AND obc021= g_obc.obc021
    IF g_obc.obcconf='Y' THEN RETURN END IF
    IF g_obc.obcacti='N' THEN RETURN END IF
    SELECT COUNT(adb02) INTO l_n FROM adb_file
     WHERE adb01 = g_plant
    IF l_n > 0 THEN
        SELECT COUNT(*) INTO l_no FROM obd_file
         WHERE obd01 = g_obc.obc01
           AND obd02 = g_obc.obc02
           AND obd021 = g_obc.obc021
           AND obdconf = 'N'
        IF l_no > 0 THEN
            CALL cl_err('','axd-087',0)
            RETURN
        END IF
    END IF
    IF NOT cl_confirm('axm-108') THEN RETURN END IF
 #NO.MOD-4A0332  --begin
    BEGIN WORK
    OPEN i130_cl USING g_obc.obc01,g_obc.obc02,g_obc.obc021
    IF STATUS THEN
       CALL cl_err("OPEN i130_cl:", STATUS, 1)
       CLOSE i130_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i130_cl INTO g_obc.*  # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_obc.obc01,SQLCA.sqlcode,0)
        CLOSE i130_cl
        ROLLBACK WORK
        RETURN
    END IF
    LET g_success='Y'
    IF l_n = 0 THEN          #??????????????????????
       UPDATE obd_file SET obdconf = 'Y'
        WHERE obd01 = g_obc.obc01
          AND obd02 = g_obc.obc02
          AND obd021= g_obc.obc021
    ELSE
       CALL i130_obc06('Y')
        CALL i130_axmi171_1()     #NO.MOD-4A0332
    END IF
    IF g_success = 'Y' THEN
       UPDATE obc_file SET obcconf='Y'
        WHERE obc01 = g_obc.obc01
          AND obc02 = g_obc.obc02
          AND obc021= g_obc.obc021
       IF STATUS THEN
          CALL cl_err('upd obcconf',STATUS,0)
          ROLLBACK WORK
          RETURN
       ELSE
          COMMIT WORK
       END IF
    ELSE
       ROLLBACK WORK
       RETURN
    END IF
    SELECT obcconf INTO g_obc.obcconf FROM obc_file
     WHERE obc01 = g_obc.obc01
       AND obc02 = g_obc.obc02
       AND obc021= g_obc.obc021
    DISPLAY BY NAME g_obc.obcconf
 #NO.MOD-4A0332  --end
END FUNCTION

FUNCTION i130_obc06(l_log)
DEFINE l_dbs  LIKE azp_file.azp03,
       l_n    LIKE type_file.num5,          #No.FUN-680108 SMALLINT
       l_log  LIKE type_file.chr1,          #No.FUN-680108 VARCHAR(01)
       l_cmd  LIKE type_file.chr1000,       #No.FUN-680108 VARCHAR(200)
       l_sql  LIKE type_file.chr1000        #No.FUN-680108 VARCHAR(200)
    SELECT COUNT(adb02) INTO l_n FROM adb_file
     WHERE adb01 = g_plant
    IF SQLCA.sqlcode THEN
       CALL cl_err('cannot foreach ',SQLCA.sqlcode,1)
       LET g_success='N'
       RETURN
    END IF
    LET l_cmd = " SELECT azp03 FROM azp_file,adb_file",
                 "  WHERE azp01 = adb02 ",
                 "    AND adb01 = '",g_plant,"'"
    PREPARE i130_prepare1 FROM l_cmd
    DECLARE i130_cur1 CURSOR FOR i130_prepare1
    LET i = 1
    FOREACH i130_cur1 INTO l_dbs
      IF SQLCA.sqlcode THEN
           CALL cl_err('cannot foreach ',SQLCA.sqlcode,1)
           EXIT FOREACH
      END IF
      IF i > l_n THEN EXIT FOREACH END IF
      LET l_sql =" UPDATE ",l_dbs CLIPPED, ".obc_file SET obc06 = '",l_log,"'",
                 " WHERE obc01 = '", g_obc.obc01,"'",
                   " AND obc02 = '", g_obc.obc02,"'",
                   " AND obc021= '", g_obc.obc021,"'"
      PREPARE i130_upd_obc06 FROM l_sql
      IF SQLCA.sqlcode THEN
          CALL cl_err('UPDATE obc06',SQLCA.sqlcode,0)
          LET g_success='N'
          RETURN
      END IF
      EXECUTE i130_upd_obc06
      LET i = i+1
    END FOREACH
END FUNCTION

FUNCTION i130_z() #取消確認
DEFINE  l_n    LIKE type_file.num5          #No.FUN-680108 SMALLINT
    IF g_obc.obc01 IS NULL THEN RETURN END IF 
    IF g_obc.obc06 = 'Y' THEN     #檢查資料是否被擷取
        CALL cl_err('','axd-090',0)
        RETURN
    END IF
    SELECT * INTO g_obc.* FROM obc_file
     WHERE obc01=g_obc.obc01
       AND obc02 = g_obc.obc02
       AND obc021= g_obc.obc021
    IF g_obc.obcconf='N' THEN RETURN END IF
    IF NOT cl_confirm('axm-109') THEN RETURN END IF

 #NO.MOD-4A0332  --begin
    LET g_success='Y'
    BEGIN WORK

    OPEN i130_cl USING g_obc.obc01,g_obc.obc02,g_obc.obc021
    IF STATUS THEN
       CALL cl_err("OPEN i130_cl:", STATUS, 1)
       CLOSE i130_cl
       RETURN
    END IF
    FETCH i130_cl INTO g_obc.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_obc.obc01,SQLCA.sqlcode,0)
        CLOSE i130_cl
        RETURN
    END IF

    SELECT COUNT(adb02) INTO l_n FROM adb_file
     WHERE adb01 = g_plant
    IF l_n =0 THEN
       UPDATE obd_file SET obdconf='N'
        WHERE obd01 = g_obc.obc01
          AND obd02 = g_obc.obc02
          AND obd021= g_obc.obc021
       IF STATUS THEN
           CALL cl_err('upd cofconf',STATUS,0)
           LET g_success='N'
       END IF
    ELSE
        CALL i130_obc06('N')
        CALL i130_axmi171_2()
    END IF
    UPDATE obc_file SET obcconf='N'
        WHERE obc01 = g_obc.obc01
          AND obc02 = g_obc.obc02
          AND obc021= g_obc.obc021
    IF SQLCA.sqlcode THEN
       CALL cl_err('update obcconf',SQLCA.sqlcode,0)
       LET g_success='N'
    END IF
 #NO.MOD-4A0332  --end
    IF g_success = 'Y' THEN
        COMMIT WORK
        CALL cl_cmmsg(1)
    ELSE
        ROLLBACK WORK
        CALL cl_rbmsg(1)
    END IF
    SELECT obcconf INTO g_obc.obcconf FROM obc_file
     WHERE obc01 = g_obc.obc01
       AND obc02 = g_obc.obc02
       AND obc021= g_obc.obc021
    DISPLAY BY NAME g_obc.obcconf,g_obc.obc06
END FUNCTION

FUNCTION i130_d()
DEFINE l_obd03 LIKE obd_file.obd03,
       l_cmd   LIKE type_file.chr1000       #No.FUN-680108 VARCHAR(500)

    OPEN WINDOW i130_m_w AT 10,10           #顯示畫面
        WITH FORM "axd/42f/axdi130_m"
        ATTRIBUTE(STYLE = g_win_style)
   CALL cl_ui_locale("axdi130_m")
    LET l_obd03 = 1
    DISPLAY l_obd03 TO obd03
    INPUT l_obd03 WITHOUT DEFAULTS FROM obd03
       AFTER FIELD obd03
          IF l_obd03<1 OR l_obd03 > g_obc.obc03 THEN
             NEXT FIELD obd03
          END IF
    END INPUT
     IF INT_FLAG THEN  #No.MOD-4A0332  --begin
        LET INT_FLAG = 0
        CLOSE WINDOW i130_m_w                    #結束畫面
        RETURN
     END IF            #No.MOD-4A0332  --end
    CLOSE WINDOW i130_m_w                    #結束畫面
    LET l_cmd = "axdi132"," '",g_obc.obc01 CLIPPED,"' '",g_obc.obc02,"'",
                " '",g_obc.obc021 CLIPPED,"' '",l_obd03,"'"
     CALL cl_cmdrun_wait(l_cmd)  #NO.MOD-4A0332
    IF g_obc.obc01 IS NULL THEN RETURN END IF
    SELECT * INTO g_obc.* FROM obc_file
     WHERE obc01 = g_obc.obc01
       AND obc02 = g_obc.obc02
       AND obc021= g_obc.obc021
    CALL i130_show()
END FUNCTION

 #NO.MOD-4A0332  ---begin
FUNCTION i130_start_date(p_obc021)
  DEFINE p_obc021     INT
  DEFINE l_sdate      LIKE type_file.dat     #No.FUN-680108 DATE
  DEFINE l_1,l_2,l_3  LIKE type_file.num10   #No.FUN-680108 INTEGER
 
  CASE g_obc.obc02
    WHEN '1'   LET l_1 = p_obc021/100
               LET l_2 = p_obc021 MOD 100
               LET l_sdate=MDY(l_2,1,l_1)
    WHEN '2'   LET l_1 = p_obc021/100
               LET l_2 = p_obc021 MOD 100
               LET l_sdate=MDY(1,1,l_1)+(l_2-1)*7
    WHEN '3'   LET l_1 = p_obc021/10000
               LET l_2 = (p_obc021 - l_1*10000) / 100
               LET l_3 = p_obc021 MOD 100
               LET l_sdate=MDY(l_2,1,l_1)+(l_3-1)*10
  END CASE
 
  RETURN l_sdate

END FUNCTION

FUNCTION i130_last_date(p_obd04)
  DEFINE p_obd04      LIKE obd_file.obd04
  DEFINE l_date       LIKE type_file.dat     #No.FUN-680108 DATE
  DEFINE l_1,l_2,l_3  LIKE type_file.num10   #No.FUN-680108 INTEGER
 
  CASE g_obc.obc02
    WHEN '1'   LET l_1 = p_obd04 /100
               LET l_2 = p_obd04  MOD 100
               LET l_date=s_last(MDY(l_2,1,l_1))
    WHEN '2'   LET l_1 = p_obd04 /100
               LET l_2 = p_obd04  MOD 100
               LET l_date=MDY(1,1,l_1)+l_2*7-1
    WHEN '3'   LET l_1 = p_obd04 /10000
               LET l_2 = (p_obd04  - l_1*10000) / 100
               LET l_3 = p_obd04  MOD 100
               IF l_3 = 3 THEN   #第三旬為最后一天
                  LET l_date=s_last(MDY(l_2,1,l_1))
               ELSE
                  LET l_date=MDY(l_2,1,l_1)+l_3*10-1
               END IF
  END CASE
  RETURN l_date
 
END FUNCTION

FUNCTION i130_axmi171_1()
  DEFINE  l_opd      RECORD LIKE opd_file.*,
          l_opc06    LIKE opc_file.opc06,
          l_azp01    LIKE azp_file.azp01,
          l_azp03    LIKE azp_file.azp03,
          l_obd      RECORD
                     obd03  LIKE obd_file.obd03,
                     obd04  LIKE obd_file.obd04,
                     obd06  LIKE obd_file.obd06,
                     obd08  LIKE obd_file.obd08,
                     obd09  LIKE obd_file.obd09,
                     obd10  LIKE obd_file.obd10,
                     obd11  LIKE obd_file.obd11
                     END RECORD,
          l_obd12    LIKE obd_file.obd12,
          l_obd07    LIKE obd_file.obd07,
          l_bdate    LIKE type_file.dat,           #No.FUN-680108 DATE 
          l_edate    LIKE type_file.dat,           #No.FUN-680108 DATE
          l_sql      LIKE type_file.chr1000,       #No.FUN-680108 VARCHAR(500)
          l_sql1     LIKE type_file.chr1000,       #No.FUN-680108 VARCHAR(500)
          l_i,l_j    LIKE type_file.num5,          #No.FUN-680108 SMALLINT
          l_sdate    LIKE type_file.dat            #No.FUN-680108 DATE
 
 
    IF NOT cl_confirm('axd-097') THEN RETURN END IF
    CALL i130_start_date(g_obc.obc021) RETURNING l_sdate
    CASE g_obc.obc02
         WHEN '1'  LET l_opc06='5'
         WHEN '2'  LET l_opc06='3'
         WHEN '3'  LET l_opc06='4'
    END CASE
 
    DECLARE cur1 CURSOR FOR
     SELECT azp01,azp03 FROM azp_file,adb_file
      WHERE azp01 = adb02
        AND adb01 = g_plant

    FOREACH cur1 INTO l_azp01,l_azp03
      IF SQLCA.sqlcode THEN
           CALL cl_err('foreach cur1',SQLCA.sqlcode,1)
           EXIT FOREACH
      END IF
      #insert axmi171 head
      INSERT INTO opc_file(opc01,opc02,opc03,opc04,opc05,opc06,opc07)
      VALUES(g_obc.obc01,l_azp01,l_sdate,g_obc.obc04,g_obc.obc05,
             l_opc06,g_obc.obc03)
      IF SQLCA.sqlcode THEN
         CALL cl_err('insert opc_file',SQLCA.sqlcode,0)
   #      LET g_success='N'
         RETURN
      END IF
      LET l_i = 1

      LET l_sql1=" SELECT obd03,obd04,obd06,obd08,obd09,obd10,obd11 ",
                 "   FROM ",l_azp03 CLIPPED,".obd_file",
                 "  WHERE obd01='",g_obc.obc01,"'",
                 "    AND obd02='",g_obc.obc02,"'",
                 "    AND obd021=",g_obc.obc021,
                 "    AND obdconf='Y'"
      PREPARE p2 FROM l_sql1
      DECLARE cur2 CURSOR FOR p2

      FOREACH cur2 INTO l_obd.*
         IF SQLCA.sqlcode THEN
              CALL cl_err('foreach cur',SQLCA.sqlcode,1)
              EXIT FOREACH
         END IF
         CALL i130_start_date(l_obd.obd04) RETURNING l_bdate
         CALL i130_last_date(l_obd.obd04)  RETURNING l_edate
         IF cl_null(l_obd.obd06) THEN LET l_obd.obd06=0 END IF
         IF cl_null(l_obd.obd08) THEN LET l_obd.obd08=0 END IF
         IF cl_null(l_obd.obd09) THEN LET l_obd.obd09=0 END IF
         IF cl_null(l_obd.obd10) THEN LET l_obd.obd10=0 END IF
         IF cl_null(l_obd.obd11) THEN LET l_obd.obd11=0 END IF
         LET l_obd12=l_obd.obd08+l_obd.obd09+l_obd.obd10+l_obd.obd11
         LET l_obd07=l_obd12*l_obd.obd06
 
         INSERT INTO opd_file(opd01,opd02,opd03,opd04,opd05,
                              opd06,opd07,opd08,opd09,opd10,opd11)
         VALUES(g_obc.obc01,l_azp01,l_sdate,g_obc.obc04,l_i,
                l_bdate,l_edate,l_obd12,0,l_obd.obd06,l_obd07)
         IF SQLCA.sqlcode THEN
            CALL cl_err('insert opd_file',SQLCA.sqlcode,0)
            LET g_success='N'
            RETURN
         END IF
 
         LET l_i=l_i+1
         IF l_i > g_max_rec THEN
            CALL cl_err( '', 9035, 0 )
            EXIT FOREACH
         END IF
      END FOREACH
    END FOREACH

END FUNCTION

FUNCTION i130_axmi171_2()
  DEFINE l_adb02   LIKE adb_file.adb02
  DEFINE l_sdate   LIKE type_file.dat     #No.FUN-680108 DATE

    IF NOT cl_confirm('axd-098') THEN RETURN END IF
    CALL i130_start_date(g_obc.obc021) RETURNING l_sdate
 
    DECLARE cur2_1 CURSOR FOR
     SELECT adb02 FROM adb_file WHERE adb01 = g_plant

    FOREACH cur2_1 INTO l_adb02
      IF SQLCA.sqlcode THEN
           CALL cl_err('foreach cur1',SQLCA.sqlcode,1)
           EXIT FOREACH
      END IF
      DELETE FROM opc_file
       WHERE opc01=g_obc.obc01 AND opc02=l_adb02
         AND opc03=l_sdate     AND opc04=g_obc.obc04
      IF SQLCA.sqlcode THEN
         CALL cl_err('delete opc_file',SQLCA.sqlcode,0)
         LET g_success='N'
         RETURN
      END IF
      DELETE FROM opd_file
       WHERE opd01=g_obc.obc01 AND opd02=l_adb02
         AND opd03=l_sdate     AND opd04=g_obc.obc04
      IF SQLCA.sqlcode THEN
         CALL cl_err('delete opd_file',SQLCA.sqlcode,0)
         LET g_success='N'
         RETURN
      END IF
    END FOREACH
END FUNCTION
 #NO.MOD-4A0332  --end

FUNCTION i130_out()
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680108 SMALLINT
    sr              RECORD
          obc01     LIKE obc_file.obc01,
          obc02     LIKE obc_file.obc02,
          obc021    INT,
          obc03     LIKE obc_file.obc03,
          obc06     LIKE obc_file.obc06,
          obc07     LIKE obc_file.obc07,
          obd03     LIKE obd_file.obd03,
          obd04     LIKE obd_file.obd04,
          obd06     LIKE obd_file.obd06,
          obd07     LIKE obd_file.obd07,
          obd08     LIKE obd_file.obd08,
          obd09     LIKE obd_file.obd09,
          obd10     LIKE obd_file.obd10,
          obd11     LIKE obd_file.obd11,
          obd12     LIKE obd_file.obd12,
          ima02     LIKE ima_file.ima02,
          ima021    LIKE ima_file.ima021
                    END RECORD,
    l_name          LIKE type_file.chr20,     #External(Disk) file name  #No.FUN-680108 VARCHAR(20)
     l_za05          LIKE za_file.za05  #MOD-4B0067

    IF cl_null(g_wc) AND NOT cl_null(g_obc.obc01) AND NOT cl_null(g_obc.obc02)
       AND NOT cl_null(g_obc.obc021) THEN
       LET g_wc = " obc01 = '",g_obc.obc01,"' AND obc02 = '",g_obc.obc02,"' AND obc021 = '",g_obc.obc021,"'"
    END IF
    IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
    IF g_wc2 IS NULL THEN LET g_wc2 = "1=1" END IF
    CALL cl_wait()
    CALL cl_outnam('axdi130') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql=" SELECT obc01,obc02,obc021,obc03,obc06,obc07, ",
                     " obd03,obd04,obd06,obd07,obd08,obd09, ",
                     " obd10,obd11,obd12,ima02,ima021 ",
              " FROM obc_file,obd_file,OUTER ima_file ",
              " WHERE obc_file.obc01 = obd_file.obd01 ",
                " AND obc_file.obc02 = obd_file.obd02 ",
                " AND obc_file.obc021= obd_file.obd021 ",
                " AND ima_file.ima01 = obc_file.obc01 ",
                " AND ",g_wc CLIPPED,
                " AND ",g_wc2 CLIPPED,
              " ORDER BY obc01,obc02,obc021,obd03 "
    PREPARE i130_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i130_co                           # CURSOR
        CURSOR FOR i130_p1

    START REPORT i130_rep TO l_name

    FOREACH i130_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT i130_rep(sr.*)
    END FOREACH

    FINISH REPORT i130_rep

    CLOSE i130_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION

REPORT i130_rep(sr)
DEFINE
    l_trailer_sw    LIKE type_file.chr1,   #No.FUN-680108 VARCHAR(1)
    l_desc          LIKE type_file.chr20,  #No.FUN-680108 VARCHAR(20)
    sr              RECORD
          obc01     LIKE obc_file.obc01,
          obc02     LIKE obc_file.obc02,
          obc021    INT,
          obc03     LIKE obc_file.obc03,
          obc06     LIKE obc_file.obc06,
          obc07     LIKE obc_file.obc07,
          obd03     LIKE obd_file.obd03,
          obd04     LIKE obd_file.obd04,
          obd06     LIKE obd_file.obd06,
          obd07     LIKE obd_file.obd07,
          obd08     LIKE obd_file.obd08,
          obd09     LIKE obd_file.obd09,
          obd10     LIKE obd_file.obd10,
          obd11     LIKE obd_file.obd11,
          obd12     LIKE obd_file.obd12,
          ima02     LIKE ima_file.ima02,
          ima021    LIKE ima_file.ima021
                    END RECORD
    OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line

    ORDER BY sr.obc01,sr.obc02,sr.obc021,sr.obd03

    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED

            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total

            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
            PRINT
            PRINT g_dash[1,g_len]
            PRINT COLUMN  1,g_x[9] CLIPPED,sr.obc01 CLIPPED,' ',
                  COLUMN 56,g_x[10] CLIPPED,sr.ima02   ##TQC-5B0110&051112 START##
                 #           g_x[10] CLIPPED,sr.ima02,
                 # COLUMN 54,g_x[17] CLIPPED,sr.ima021
            PRINT COLUMN 56,g_x[17] CLIPPED,sr.ima021  ##TQC-5B0110&051112 END##
            PRINT COLUMN  1,g_x[11] CLIPPED,sr.obc07,
                  COLUMN 54,g_x[15] CLIPPED,sr.obc06,' ',
                            g_x[12] CLIPPED,sr.obc02 CLIPPED,' ',
                            g_x[13],l_desc,
                  COLUMN 85,g_x[14] CLIPPED,sr.obc03 USING '<<'
            PRINT
            PRINT g_x[31], g_x[32],g_x[33],g_x[34], g_x[35],
                  g_x[36], g_x[37],g_x[38],g_x[39], g_x[40]
            PRINT g_dash1
            LET l_trailer_sw = 'y'

            CASE sr.obc02
                 WHEN '1' CALL cl_getmsg('axd-108',g_lang) RETURNING l_desc
                 WHEN '2' CALL cl_getmsg('axd-109',g_lang) RETURNING l_desc
                 WHEN '3' CALL cl_getmsg('axd-110',g_lang) RETURNING l_desc
            END CASE

        BEFORE GROUP OF sr.obc01
            SKIP TO TOP OF PAGE

        ON EVERY ROW
            PRINT COLUMN g_c[31],sr.obc021 USING '<<<<<<<<',
                  COLUMN g_c[32],sr.obd03 USING '###&', #FUN-590118
                  COLUMN g_c[33],sr.obd04 USING '<<<<<<<<',
                  COLUMN g_c[34],cl_numfor(sr.obd06,34,g_azi03),  #No.MOD-580212
                  COLUMN g_c[35],cl_numfor(sr.obd07,35,g_azi04),  #No.MOD-580212
                  COLUMN g_c[34],sr.obd06 USING '-------&.&&&&&&',
                  COLUMN g_c[35],sr.obd07 USING '-------&.&&&&&&',
                  COLUMN g_c[36],sr.obd08 USING '----------&.&&&' ,
                  COLUMN g_c[37],sr.obd09 USING '----------&.&&&',
                  COLUMN g_c[38],sr.obd10 USING '----------&.&&&',
                  COLUMN g_c[39],sr.obd11 USING '----------&.&&&',
                  COLUMN g_c[40],cl_numfor(sr.obd12,40,g_azi05)  #No.MOD-580212

        AFTER GROUP OF sr.obc021
              PRINTX name=S1 COLUMN g_c[31],g_x[16] CLIPPED,
                    COLUMN g_c[35],cl_numfor(GROUP SUM(sr.obd07),35,g_azi05),  #No.MOD-580212
                    COLUMN g_c[36],GROUP SUM(sr.obd08) USING '----------&.&&&' ,
                    COLUMN g_c[37],GROUP SUM(sr.obd09) USING '----------&.&&&',
                    COLUMN g_c[38],GROUP SUM(sr.obd10) USING '----------&.&&&',
                    COLUMN g_c[39],GROUP SUM(sr.obd11) USING '----------&.&&&',
                    COLUMN g_c[40],cl_numfor(GROUP SUM(sr.obd12),40,g_azi05)  #MOD-580212
             PRINT

        AFTER GROUP OF sr.obc01
             LET l_trailer_sw = 'y'

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

FUNCTION i130_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)

   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("obc01,obc021",TRUE)
   END IF

END FUNCTION

FUNCTION i130_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)

   IF (NOT g_before_input_done) THEN
       IF p_cmd = 'u' AND g_chkey = 'N' THEN
           CALL cl_set_comp_entry("obc01,obc021",FALSE)
       END IF
   END IF

END FUNCTION
{
FUNCTION i130_set_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)

      CALL cl_set_comp_entry("obd03",TRUE)

END FUNCTION

FUNCTION i130_set_no_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)

      CALL cl_set_comp_entry("obd03",FALSE)

END FUNCTION
}
#Patch....NO:MOD-5A0095 <001> #
