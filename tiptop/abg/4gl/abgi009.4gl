# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: abgi009.4gl
# Descriptions...: 費用項目提撥作業
# Date & Author..: 02/10/01 By qazzaq
# Modify.........: No.MOD-470041 04/07/16 By Nicola 修改INSERT INTO 語法
# Modify.........: No.FUN-4B0021 04/11/04 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-510025 05/01/14 By Smapmin 報表轉XML格式
# Modify.........: No.MOD-530026 05/04/05 By ice 單身對應錯誤
# Modify.........: No.FUN-660105 06/06/15 By hellen      cl_err --> cl_err3
# Modify.........: No.FUN-5A0134 06/06/20 By rainy  按上筆單身資料沒改變
# Modify.........: No.FUN-680061 06/08/25 By cheunl 欄位型態定義，改為LIKE 
# Modify.........: No.FUN-6A0003 06/10/14 By jamie 1.FUNCTION i009()_q 一開始應清空g_bha.*的值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0057 06/10/20 By hongmei 將 g_no_ask 改為 g_no_ask 
# Modify.........: No.FUN-6A0056 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/13 By hellen 新增單頭折疊功能
# Modify.........: No.TQC-6C0220 07/01/09 By rainy QBE單身下條件時查詢出筆數錯誤
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-770033 07/07/11 By destiny 報表改為使用crystal report
# Modify.........: No.TQC-8C0076 09/01/09 By clover mark #ATTRIBUTE(YELLOW)
# Modify.........: No.FUN-940135 09/04/29 By Carrier 去掉顏色的ATTRIBUTE設置
# Modify.........: No.TQC-970283 09/07/27 By xiaofeizhu 單身“提拔比率或金額”欄位對負數值加控管
# Modify.........: No.FUN-980001 09/08/05 By TSD.hoho GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50062 11/05/13 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.CHI-C30002 12/05/14 By yuhuabao 離開單身單身無資料時候提示是否刪除單頭資料
# Modify.........: No:FUN-C30027 12/08/09 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30032 13/04/02 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    new_ver         LIKE bgm_file.bgm01,     #NO.FUN-680061 VARCHAR(10)
    g_tot           LIKE type_file.num20_6,  #NO.FUN-680061 DEC(20,6)
    g_bha           RECORD LIKE bha_file.*,  #主件料件(假單頭)
    g_bha_t         RECORD LIKE bha_file.*,  #主件料件(舊值)
    g_bha_o         RECORD LIKE bha_file.*,  #主件料件(舊值)
    g_bha01_t       LIKE bha_file.bha01,     #(舊值)
    g_bha02_t       LIKE bha_file.bha02,     #(舊值)
    g_bha03_t       LIKE bha_file.bha03,     #(舊值)
    g_bhb           DYNAMIC ARRAY of RECORD          #程式變數(Program Variables)
                    bhb04     LIKE bhb_file.bhb04,   #來源費用項目
                    bgs02_1   LIKE bgs_file.bgs02,   #費用項目說明
                    bhb05     LIKE bhb_file.bhb05,   #提撥方式
                    bhb06     LIKE bhb_file.bhb06    #提撥比率或金額
                    END RECORD,
    g_bhb_t         RECORD                           #程式變數(舊值)
                    bhb04     LIKE bhb_file.bhb04,   #來源費用項目
                    bgs02_1   LIKE bgs_file.bgs02,   #費用項目說明
                    bhb05     LIKE bhb_file.bhb05,   #提撥方式
                    bhb06     LIKE bhb_file.bhb06    #提撥比率或金額
                    END RECORD,
    g_bhb_o         RECORD                           #程式變數(舊值)
                    bhb04     LIKE bhb_file.bhb04,   #來源費用項目
                    bgs02_1   LIKE bgs_file.bgs02,   #費用項目說明
                    bhb05     LIKE bhb_file.bhb05,   #提撥方式
                    bhb06     LIKE bhb_file.bhb06    #提撥比率或金額
                    END RECORD,
    g_ima01         LIKE  ima_file.ima01,
    g_sql           string,  #No.FUN-580092 HCN
    g_wc,g_wc2      string,  #No.FUN-580092 HCN
    g_sw            LIKe type_file.num5,             #單位是否可轉換 #FUN-680061 SMALLINT
    g_cmd           LIKE type_file.chr1000,          #No.FUN-680061 VARCHAR(60)
    g_aflag         LIKE type_file.chr1,             #No.FUN-680061 VARCHAR(01)
    g_modify_flag   LIKE type_file.chr1,             #No.FUN-680061 VARCHAR(01)
    g_rec_b         LIKE type_file.num5,             #單身筆數 #No.FUN-680061 SMALLINT
    l_ac            LIKE type_file.num5              #目前處理的ARRAY CNT   #No.FUN-680061 SMALLINT
 
DEFINE g_forupd_sql STRING                   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5      #No.FUN-680061 SMALLINT
DEFINE g_cnt        LIKE type_file.num10     #No.FUN-680061 INTEGER
DEFINE g_i          LIKE type_file.num5      #count/index for any purpose  #No.FUN-680061 SMALLINT
DEFINE g_msg        LIKE ze_file.ze03        #No.FUN-680061 VARCHAR(72)
DEFINE g_chr        LIKE type_file.chr1      #No.FUN-680061 VARCHAR(01)
DEFINE g_row_count  LIKE type_file.num10     #No.FUN-680061 INTEGER
DEFINE g_curs_index LIKE type_file.num10     #No.FUN-680061 INTEGER
DEFINE g_jump       LIKE type_file.num10     #No.FUN-680061 INTEGER
DEFINE g_no_ask     LIKE type_file.num5      #No.FUN-680061 SMALLINT #No.FUN-6A0057 g_no_ask 
DEFINE l_table      STRING                   #No.FUN-770033 
DEFINE l_sql        STRING                   #No.FUN-770033
DEFINE g_str        STRING                   #No.FUN-770033
 
MAIN
 
    OPTIONS                                  #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                          #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("ABG")) THEN
       EXIT PROGRAM
    END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0056
 
#No.FUN-770033--start--
    LET g_sql= "bha01.bha_file.bha01,",
               "bha02.bha_file.bha02,",
               "bha03.bha_file.bha03,",
               "l_bgs02.bgs_file.bgs02,",
               "bha04.bha_file.bha04,",
               "bhb04.bhb_file.bhb04,",
               "bgs02.bgs_file.bgs02,",
               "bhb05.bhb_file.bhb05,",
               "bhb06.bhb_file.bhb06"
 
    LET l_table= cl_prt_temptable('abgi009',g_sql) CLIPPED
    IF  l_table= -1 THEN EXIT PROGRAM END IF 
    LET g_sql= "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?)"
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN 
       CALL cl_err('insert_prep',status,1) EXIT PROGRAM
    END IF
#No.FUN-770033--end--
    LET g_wc2=' 1=1'
 
    LET g_forupd_sql= "SELECT * FROM bha_file WHERE bha01 = ? AND bha02 = ? AND bha03 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i009_curl CURSOR FROM g_forupd_sql
 
    OPEN WINDOW i009_w WITH FORM "abg/42f/abgi009"
         ATTRIBUTE(STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()
 
    CALL i009_menu()
 
    CLOSE WINDOW i009_w                 #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0056
END MAIN
 
#QBE 查詢資料
FUNCTION i009_curs()
DEFINE  lc_qbe_sn  LIKE gbm_file.gbm01     #No.FUN-580031  HCN
DEFINE l_flag      LIKE type_file.chr1     #判斷單身是否給條件 #No.FUN-680061 VARCHAR(01)
 
    CLEAR FORM                             #清除畫面
    CALL g_bhb.clear()
 
	LET l_flag = 'N'
    CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
   INITIALIZE g_bha.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                                 # 螢幕上取單頭條件
     bha01,bha02,bha03,bha04,bhauser,bhagrup,bhamodu,bhadate
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
 
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(bha03) #幣別
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_bgs"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO bha03
                 NEXT FIELD bha03
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
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
        END CONSTRUCT
 
    IF INT_FLAG THEN RETURN END IF
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND bhauser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND bhagrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND bhagrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('bhauser', 'bhagrup')
    #End:FUN-980030
 
 
    CONSTRUCT g_wc2 ON bhb04,bhb05,bhb06
         FROM s_bhb[1].bhb04,s_bhb[1].bhb05,s_bhb[1].bhb06
 
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(bhb04) #幣別
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_bgs"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO bhb04
                 NEXT FIELD bhb04
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
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
        END CONSTRUCT
    IF g_wc2 != " 1=1" THEN LET l_flag = 'Y' END IF
 
 
    IF INT_FLAG THEN RETURN END IF
    IF l_flag = 'N' THEN			# 若單身未輸入條件
       LET g_sql = "SELECT bha01,bha02,bha03,bha04 FROM bha_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY bha01"
    ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT DISTINCT bha01,bha02,bha03,bha04 ",
                   "  FROM bha_file, bhb_file ",
                   " WHERE bha01 = bhb01",
                   "   AND bha02 = bhb02",
                   "   AND bha03 = bhb03",
                   "   AND ",g_wc CLIPPED,
                   "   AND ",g_wc2 CLIPPED,
                   " ORDER BY bha01"
    END IF
 
    PREPARE i009_prepare FROM g_sql
	DECLARE i009_curs
        SCROLL CURSOR WITH HOLD FOR i009_prepare
 
    IF l_flag = 'N' THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM bha_file WHERE ",g_wc CLIPPED
    ELSE
        #LET g_sql="SELECT COUNT(*) FROM bha_file,bhb_file ",           #TQC-6C0220
        LET g_sql="SELECT COUNT(UNIQUE bha01||cast(bha02 as char)||bha03) FROM bha_file,bhb_file ", #TQC-6C0220
                  "WHERE bhb01=bha01 AND bhb02=bha02 AND bhb03=bha03 ",
                  " AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE i009_precount FROM g_sql
    DECLARE i009_count CURSOR FOR i009_precount
END FUNCTION
 
FUNCTION i009_menu()
   WHILE TRUE
      CALL i009_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i009_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i009_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i009_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i009_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i009_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
#         WHEN "invalid"
#            IF cl_chk_act_auth() THEN
#               CALL i009_x()
#            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i009_out()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i009_copy()
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0021
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bhb),'','')
            END IF
         #No.FUN-6A0003-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_bha.bha01 IS NOT NULL THEN
                LET g_doc.column1 = "bha01"
                LET g_doc.column2 = "bha02"
                LET g_doc.column3 = "bha03"
                LET g_doc.value1 = g_bha.bha01
                LET g_doc.value2 = g_bha.bha02
                LET g_doc.value3 = g_bha.bha03
                CALL cl_doc()
             END IF 
          END IF
         #No.FUN-6A0003-------add--------end----
      END CASE
   END WHILE
 
END FUNCTION
 
 
#Add  輸入
FUNCTION i009_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    INITIALIZE g_bha.* LIKE bha_file.*             #DEFAULT 設定
    LET g_bha01_t = NULL
    LET g_bha02_t = NULL
    LET g_bha03_t = NULL
    #預設值及將數值類變數清成零
    CALL g_bhb.clear()
    LET g_bha_t.* = g_bha.*
    LET g_bha_o.* = g_bha.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_bha.bha04  = 0
        LET g_bha.bhauser=g_user
        LET g_bha.bhaoriu = g_user #FUN-980030
        LET g_bha.bhaorig = g_grup #FUN-980030
        LET g_bha.bhagrup=g_grup
        LET g_bha.bhadate=g_today
        LET g_bha.bha02=YEAR(g_today)
        LET g_bha.bhaacti='Y'              #資料有效
        CALL i009_i("a")                   #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            INITIALIZE g_bha.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF cl_null(g_bha.bha02) OR cl_null(g_bha.bha03) THEN # KEY 不可空白
            CONTINUE WHILE
        END IF
 
        BEGIN WORK
 
        INSERT INTO bha_file VALUES (g_bha.*)
        IF SQLCA.sqlcode THEN   			#置入資料庫不成功
#           CALL cl_err(g_bha.bha01,SQLCA.sqlcode,1) #FUN-660105
            CALL cl_err3("ins","bha_file",g_bha.bha01,g_bha.bha02,SQLCA.sqlcode,"","",1) #FUN-660105
            ROLLBACK WORK
            CONTINUE WHILE
        END IF
        LET g_bha01_t = g_bha.bha01        #保留舊值
        LET g_bha02_t = g_bha.bha02        #保留舊值
        LET g_bha03_t = g_bha.bha03        #保留舊值
        LET g_bha_t.* = g_bha.*
        CALL g_bhb.clear()
        LET g_rec_b=0
        CALL i009_b_fill(' 1=1')
        CALL i009_b()                   #輸入單身
        LET g_wc="      bha01='",g_bha.bha01,"' ",
                 " AND  bha02='",g_bha.bha02,"' ",
                 " AND  bha03='",g_bha.bha03,"' "
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i009_u()
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_bha.bha02) OR cl_null(g_bha.bha03) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    CALL cl_opmsg('u')
    LET g_bha01_t = g_bha.bha01
    LET g_bha02_t = g_bha.bha02
    LET g_bha03_t = g_bha.bha03
    BEGIN WORK
    OPEN i009_curl USING g_bha.bha01,g_bha.bha02,g_bha.bha03
    IF STATUS THEN
       CALL cl_err("OPEN i009_curl:", STATUS, 1)
       CLOSE i009_curl
       ROLLBACK WORK
       RETURN
    END IF
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bha.bha01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE i009_curl
        ROLLBACK WORK
        RETURN
    END IF
    FETCH i009_curl INTO g_bha.*            # 鎖住將被更改或取消的資料
    CALL i009_show()
    WHILE TRUE
        LET g_bha01_t = g_bha.bha01
        LET g_bha02_t = g_bha.bha02
        LET g_bha03_t = g_bha.bha03
        LET g_bha.bhamodu=g_user
        LET g_bha.bhadate=g_today
        CALL i009_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_bha.*=g_bha_t.*
            CALL i009_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_bha.bha01 != g_bha01_t OR g_bha.bha02 != g_bha02_t
           OR g_bha.bha03 != g_bha03_t THEN                     # 更改KEY
           UPDATE bhb_file SET bhb01 = g_bha.bha01,
                               bhb02 = g_bha.bha02,
                               bhb03 = g_bha.bha03
                WHERE bhb01 = g_bha01_t
                  AND bhb02 = g_bha02_t
                  AND bhb03 = g_bha03_t
           IF SQLCA.sqlcode THEN
#             CALL cl_err('bhb',SQLCA.sqlcode,0) #FUN-660105
              CALL cl_err3("upd","bhb_file",g_bha01_t,g_bha02_t,SQLCA.sqlcode,"","bhb",1) #FUN-660105
              CONTINUE WHILE  
           END IF
        END IF
        UPDATE bha_file SET bha_file.* = g_bha.*
         WHERE bha01=g_bha01_t AND bha02=g_bha02_t AND bha03=g_bha03_t
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_bha.bha01,SQLCA.sqlcode,0) #FUN-660105
           CALL cl_err3("upd","bha_file",g_bha.bha01,g_bha.bha02,SQLCA.sqlcode,"","",1) #FUN-660105
           CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i009_curl
    COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION i009_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,     #a:輸入 u:更改 #No.FUN-680061 VARCHAR(01)
    l_cmd           LIKE type_file.chr50     #No.FUN-680061 VARCHAR(40) 
    CALL cl_set_head_visible("","YES")       #No.FUN-6B0033
#    IF s_shut(0) THEN RETURN END IF
    DISPLAY BY NAME g_bha.bha01,g_bha.bha02,g_bha.bha03,g_bha.bha04,
                    g_bha.bhauser,g_bha.bhamodu,g_bha.bhagrup,g_bha.bhadate
 
    INPUT BY NAME g_bha.bha01,g_bha.bha02,g_bha.bha03,g_bha.bha04, g_bha.bhaoriu,g_bha.bhaorig
                  WITHOUT DEFAULTS
 
 
        BEFORE FIELD bha01
            IF p_cmd = 'u' AND g_chkey matches'[Nn]' THEN
               NEXT FIELD bha04
               RETURN
            END IF
 
        AFTER FIELD bha01
            IF cl_null(g_bha.bha01) THEN
               LET g_bha.bha01=' '
            END IF
 
 
        AFTER FIELD bha03                          #
            IF NOT cl_null(g_bha.bha03) THEN
               IF g_bha.bha03 != g_bha03_t OR cl_null(g_bha03_t) THEN
                  SELECT count(*) INTO g_cnt FROM bha_file
                  WHERE bha01 = g_bha.bha01
                    AND bha02 = g_bha.bha02
                    AND bha03 = g_bha.bha03
                  IF g_cnt > 0 THEN   #資料重複
                     CALL cl_err(g_bha.bha03,'abg-003',0)
                     LET g_bha.bha03 = g_bha03_t
                     DISPLAY BY NAME g_bha.bha03
                     NEXT FIELD bha03
                  END IF
               END IF
               IF g_bha.bha03 != g_bha03_t OR cl_null(g_bha03_t) THEN
                  SELECT count(*) INTO g_cnt FROM bgz_file
                  WHERE bgz27 = g_bha.bha03
                     OR bgz29 = g_bha.bha03
                     OR bgz33 = g_bha.bha03
                     OR bgz34 = g_bha.bha03
                     OR bgz35 = g_bha.bha03
                  IF g_cnt > 0 THEN   #資料重複
                     CALL cl_err(g_bha.bha03,'abg-008',0)
                     LET g_bha.bha03 = g_bha03_t
                     DISPLAY BY NAME g_bha.bha03
                     NEXT FIELD bha03
                  END IF
                END IF
                CALL i009_bha03('a',g_bha.bha03)
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_bha.bha03,g_errno,0)
                   LET g_bha.bha03 = g_bha_o.bha03
                   DISPLAY BY NAME g_bha.bha03
                   NEXT FIELD bha03
                END IF
            END IF
 
 
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLP
            CASE
              WHEN INFIELD(bha03) #原出貨單
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_bgs"
                   CALL cl_create_qry() RETURNING g_bha.bha03
#                   CALL FGL_DIALOG_SETBUFFER( g_bha.bha03 )
                   DISPLAY BY NAME g_bha.bha03
                   NEXT FIELD bha03
            END CASE
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
{        ON KEY(CONTROL-P)     #查詢條件
            CASE
               WHEN INFIELD(bha03) #費用項目
                  CALL q_bgs(4,16,g_bha.bha03) RETURNING g_bha.bha03
                  DISPLAY BY NAME g_bha.bha03
                  NEXT FIELD bha03
               OTHERWISE EXIT CASE
             END CASE
}
    END INPUT
END FUNCTION
 
FUNCTION i009_bha03(p_cmd,p_key)            #主件料件
    DEFINE p_cmd     LIKE type_file.chr1,   #No.FUN-680061 VARCHAR(01)
           p_key     LIKE bha_file.bha03,
           l_bgs02   LIKE bgs_file.bgs02
 
    LET g_errno = ' '
    SELECT  bgs02 INTO  l_bgs02
      FROM  bgs_file
     WHERE  bgs01 = p_key
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'abg-004'
                            LET l_bgs02 = NULL
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_bgs02 TO FORMONLY.bgs02
    END IF
END FUNCTION
 
#Query 查詢
FUNCTION i009_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_bha.* TO NULL             #No.FUN-6A0003
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_bhb.clear()
    DISPLAY '   ' TO FORMONLY.cnt
#    CALL cl_getmsg('mfg2618',g_lang) RETURNING g_msg
#    DISPLAY g_msg CLIPPED AT 6,1
    CALL i009_curs()
    IF INT_FLAG THEN
        INITIALIZE g_bha.* TO NULL
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN i009_curs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_bha.* TO NULL
    ELSE
        OPEN i009_count
        FETCH i009_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt  #ATTRIBUTE(MAGENTA)
        CALL i009_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i009_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1      #處理方式 #No.FUN-680061 VARCHAR(01)
 
    CASE p_flag
      WHEN 'N' FETCH NEXT     i009_curs INTO g_bha.bha01,
                                             g_bha.bha02,g_bha.bha03
      WHEN 'P' FETCH PREVIOUS i009_curs INTO g_bha.bha01,
                                             g_bha.bha02,g_bha.bha03
      WHEN 'F' FETCH FIRST    i009_curs INTO g_bha.bha01,
                                             g_bha.bha02,g_bha.bha03
      WHEN 'L' FETCH LAST     i009_curs INTO g_bha.bha01,
                                             g_bha.bha02,g_bha.bha03
      WHEN '/'
         IF (NOT g_no_ask) THEN      #No.FUN-6A0057 g_no_ask 
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
             LET INT_FLAG = 0	
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
         FETCH ABSOLUTE g_jump i009_curs INTO g_bha.bha01,
                                              g_bha.bha02,g_bha.bha03
         LET g_no_ask = FALSE      #No.FUN-6A0057 g_no_ask 
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bha.bha01,SQLCA.sqlcode,0)
        INITIALIZE g_bha.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_bha.* FROM bha_file WHERE bha01 = g_bha.bha01 AND bha02 = g_bha.bha02 AND bha03 = g_bha.bha03
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_bha.bha01,SQLCA.sqlcode,0) #FUN-660105
        CALL cl_err3("sel","bha_file",g_bha.bha01,g_bha.bha02,SQLCA.sqlcode,"","",1) #FUN-660105
        INITIALIZE g_bha.* TO NULL
        RETURN
    END IF
   LET g_data_owner = g_bha.bhauser   #FUN-4C0067
   LET g_data_group = g_bha.bhagrup   #FUN-4C0067
   CALL i009_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i009_show()
    LET g_bha_t.* = g_bha.*                #保存單頭舊值
    DISPLAY BY NAME g_bha.bhaoriu,g_bha.bhaorig,                        # 顯示單頭值
     g_bha.bha01,g_bha.bha02,g_bha.bha03,g_bha.bha04,g_bha.bhauser,
        g_bha.bhagrup,g_bha.bhamodu,g_bha.bhadate
 
    CALL i009_bha03('d',g_bha.bha03)
    CALL i009_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i009_x()
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_bha.bha02) OR cl_null(g_bha.bha03) THEN
       CALL cl_err("",-400,0)
       RETURN
    END IF
    BEGIN WORK
    OPEN i009_curl USING g_bha.bha01,g_bha.bha02,g_bha.bha03
    IF STATUS THEN
       CALL cl_err("OPEN i009_curl:", STATUS, 1)
       CLOSE i009_curl
       ROLLBACK WORK
       RETURN
    END IF
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bha.bha01,SQLCA.sqlcode,0)          #資料被他人LOCK
        CLOSE i009_curl
        ROLLBACK WORK
        RETURN
    END IF
    FETCH i009_curl INTO g_bha.*               # 鎖住將被更改或取消的資料
    CALL i009_show()
    IF cl_exp(0,0,g_bha.bhaacti) THEN
        LET g_chr=g_bha.bhaacti
        IF g_bha.bhaacti='Y' THEN
           LET g_bha.bhaacti='N'
        ELSE
           LET g_bha.bhaacti='Y'
        END IF
        UPDATE bha_file                    #更改有效碼
           SET bhaacti=g_bha.bhaacti
         WHERE bha01=g_bha.bha01
           AND bha02=g_bha.bha02
           AND bha03=g_bha.bha03
        IF SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err(g_bha.bha01,SQLCA.sqlcode,0) #FUN-660105
            CALL cl_err3("upd","bha_file",g_bha.bha01,g_bha.bha02,SQLCA.sqlcode,"","",1) #FUN-660105
            LET g_bha.bhaacti=g_chr
        END IF
  #     DISPLAY BY NAME g_bha.bhaacti ATTRIBUTE(RED)
    END IF
    CLOSE i009_curl
    COMMIT WORK
END FUNCTION
 
FUNCTION i009_r()
    DEFINE l_chr LIKE type_file.chr1    #No.FUN-680061 VARCHAR(01)
    DEFINE l_cnt LIKE type_file.num10   #No.FUN-680061 INTEGER
 
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_bha.bha02) AND cl_null(g_bha.bha03) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    BEGIN WORK
 
    OPEN  i009_curl USING g_bha.bha01,g_bha.bha02,g_bha.bha03
    IF STATUS THEN
       CALL cl_err("OPEN i009_curl:", STATUS, 1)
       CLOSE i009_curl
       ROLLBACK WORK
       RETURN
    END IF
 
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_bha.bha01,SQLCA.sqlcode,0)
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i009_curl INTO g_bha.*
    CALL i009_show()
    IF cl_delh(15,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "bha01"         #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "bha02"         #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "bha03"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_bha.bha01      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_bha.bha02      #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_bha.bha03      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
       DELETE FROM bha_file WHERE bha01=g_bha.bha01 AND bha02=g_bha.bha02 AND bha03=g_bha.bha03
       IF SQLCA.SQLERRD[3]=0 THEN
#         CALL cl_err(g_bha.bha01,SQLCA.sqlcode,0) #FUN-660105
          CALL cl_err3("del","bha_file",g_bha.bha01,g_bha.bha02,SQLCA.sqlcode,"","",1) #FUN-660105
          ROLLBACK WORK
          RETURN
       ELSE
          DELETE FROM bhb_file WHERE bhb01=g_bha.bha01
                                 AND bhb02=g_bha.bha02
                                 AND bhb03=g_bha.bha03
          LET g_msg=TIME
          INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980001 add
          VALUES ('abgi009',g_user,g_today,g_msg,g_bha.bha01||"|"||g_bha.bha02||"|"||g_bha.bha03,'delete',g_plant,g_legal) #FUN-980001 add
          CLEAR FORM
          CALL g_bhb.clear()
          OPEN i009_count
          #FUN-B50062-add-start--
          IF STATUS THEN
             CLOSE i009_curs
             CLOSE i009_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
          FETCH i009_count INTO g_row_count
          #FUN-B50062-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE i009_curs
             CLOSE i009_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
          DISPLAY g_row_count TO FORMONLY.cnt
          OPEN i009_curs
          IF g_curs_index = g_row_count + 1 THEN
             LET g_jump = g_row_count
             CALL i009_fetch('L')
          ELSE
             LET g_jump = g_curs_index
             LET g_no_ask = TRUE        #No.FUN-6A0057 g_no_ask 
             CALL i009_fetch('/')
          END IF
       END IF
    END IF
    CLOSE i009_curl
    COMMIT WORK
END FUNCTION
 
#單身
FUNCTION i009_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT #No.FUN-680061 SMALLINT
    l_n             LIKE type_file.num5,    #檢查重複用        #No.FUN-680061 SMALLINT
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否        #No.FUN-680061 VARCHAR(01)
    p_cmd           LIKE type_file.chr1,    #處理狀態          #No.FUN-680061 VARCHAR(01)
    l_allow_insert  LIKE type_file.num5,    #可新增否          #No.FUN-680061 VARCHAR(01)
    l_allow_delete  LIKE type_file.num5,    #可更改否 (含取消) #No.FUN-680061 VARCHAR(01)
    l_buf           LIKE type_file.chr50,   #No.FUN-680061 VARCHAR(40) 
    l_cmd           LIKE type_file.chr1000, #No.FUN-680061 VARCHAR(200)
    l_uflag,l_chr   LIKE type_file.chr1     #No.FUN-680061 VARCHAR(01)
 
    LET g_action_choice = ""
#    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_bha.bha02) OR cl_null(g_bha.bha03) THEN
        RETURN
    END IF
  #  IF g_bha.bhaacti ='N' THEN    #資料若為無效,仍可更改.
  #     CALL cl_err(g_bha.bha01,'mfg1000',0) RETURN
  #  END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
       "SELECT bhb04,' ',bhb05,bhb06 FROM bhb_file ",
       "  WHERE bhb01 = ? AND bhb02 = ? AND bhb03 = ? ",
       "  AND bhb04 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i009_b_curl CURSOR FROM g_forupd_sql
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_bhb WITHOUT DEFAULTS FROM s_bhb.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
                  BEGIN WORK
                  LET p_cmd='u'
                  LET g_bhb_t.* = g_bhb[l_ac].*  #BACKUP
                  OPEN i009_b_curl USING g_bha.bha01,
                                         g_bha.bha02,
                                         g_bha.bha03,
                                         g_bhb_t.bhb04
                  IF STATUS THEN
                     CALL cl_err("OPEN i009_b_curl:", STATUS, 1)
                     LET l_lock_sw = "Y"
                  ELSE
                     IF SQLCA.sqlcode THEN
                        CALL cl_err(g_bhb_t.bhb04,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                     END IF
                     FETCH i009_b_curl INTO g_bhb[l_ac].*
                     CALL i009_bhb04('d')
                  END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
#           NEXT FIELD bhb04
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_bhb[l_ac].* TO NULL      #900423
            LET g_bhb[l_ac].bhb06 = 0         #Body default
            LET g_bhb_t.* = g_bhb[l_ac].*         #新輸入資料
            LET g_bhb_o.* = g_bhb[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD bhb04
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
             INSERT INTO bhb_file(bhb01,bhb02,bhb03,bhb04,bhb05,bhb06) #No.MOD-470041
                 VALUES(g_bha.bha01,g_bha.bha02,g_bha.bha03,g_bhb[l_ac].bhb04,
                        g_bhb[l_ac].bhb05,g_bhb[l_ac].bhb06)
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_bhb[l_ac].bhb04,SQLCA.sqlcode,0) #FUN-660105
               CALL cl_err3("ins","bhb_file",g_bha.bha01,g_bha.bha02,SQLCA.sqlcode,"","",1) #FUN-660105
               CANCEL INSERT
            ELSE
               UPDATE bha_file SET bhadate = g_today
                WHERE bha01=g_bha.bha01 AND bha02=g_bha.bha02 AND bha03=g_bha.bha03
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
            END IF
 
        BEFORE FIELD bhb05                         #費用項目
            IF NOT cl_null(g_bhb[l_ac].bhb04) THEN
               IF cl_null(g_bhb_t.bhb04) THEN
                  SELECT COUNT(*) INTO l_n FROM bhb_file
                   WHERE bhb01=g_bha.bha01
                     AND bhb02=g_bha.bha02
                     AND bhb03=g_bha.bha03
                     AND bhb04=g_bhb[l_ac].bhb04
                  IF l_n>0 THEN
                     CALL cl_err(g_bhb[l_ac].bhb04,'abg-003',0)
                     NEXT FIELD bhb04
                  END IF
               END IF
               CALL i009_bhb04('a')      #必需讀取(費用項目)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_bhb[l_ac].bhb04=g_bhb_t.bhb04
                  NEXT FIELD bhb04
               END IF
           END IF
 
        AFTER FIELD bhb05    #提撥方式1或2
          IF NOT cl_null(g_bhb[l_ac].bhb05) THEN
             IF g_bhb[l_ac].bhb05 NOT MATCHES "[12]" THEN
                CALL cl_err(g_bhb[l_ac].bhb05,'abg-005',0)
                LET g_bhb[l_ac].bhb05 = g_bhb_o.bhb05
                NEXT FIELD bhb05
             END IF
             LET g_bhb_o.bhb05 = g_bhb[l_ac].bhb05
          END IF
 
        BEFORE FIELD bhb06
            IF g_bhb[l_ac].bhb05 =1 THEN
               LET l_buf = cl_getmsg('abg-012',g_lang)
            ELSE
               LET l_buf = cl_getmsg('abg-013',g_lang)
            END IF
            MESSAGE l_buf
 
        AFTER FIELD bhb06    #提撥比率或金額
            IF NOT cl_null(g_bhb[l_ac].bhb06) THEN
               #TQC-970283--Add--Begin--#                                                                                        
               IF g_bhb[l_ac].bhb06 <0 THEN                                                                                      
                  CALL cl_err(g_bhb[l_ac].bhb06,'mfg4012',0)                                                                     
                  LET g_bhb[l_ac].bhb06 = g_bhb_t.bhb06                                                                          
                  NEXT FIELD bhb06                                                                                               
               END IF                                                                                                            
               #TQC-970283--Add--End--#            
               IF g_bhb[l_ac].bhb05 = 2 THEN
                  IF g_bhb[l_ac].bhb06 >100 THEN
                     CALL cl_err(g_bhb[l_ac].bhb06,'abg-006',0)
                     LET g_bhb[l_ac].bhb06 = g_bhb_t.bhb06
                     NEXT FIELD bhb06
                  END IF
               END IF
               LET g_bhb_o.bhb06 = g_bhb[l_ac].bhb06
            END IF
 
        BEFORE DELETE                            #是否取消單身
           # IF g_bhb_t.bhb04 > 0 AND (NOT cl_null(g_bhb_t.bhb04)) THEN
            IF NOT cl_null(g_bhb_t.bhb04) THEN
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
 
               DELETE FROM bhb_file
                WHERE bhb01 = g_bha.bha01
                  AND bhb02 = g_bha.bha02
                  AND bhb03 = g_bha.bha03
                  AND bhb04 = g_bhb_t.bhb04
               IF SQLCA.sqlcode THEN
                 # LET l_buf = g_bhb_t.bhb04 clipped
                 # CALL cl_err(l_buf,SQLCA.sqlcode,0)
#                 CALL cl_err(g_bhb_t.bhb04,SQLCA.sqlcode,0) #FUN-660105
                  CALL cl_err3("del","bhb_file",g_bha.bha01,g_bhb_t.bhb04,SQLCA.sqlcode,"","",1) #FUN-660105
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
            END IF
	    COMMIT WORK
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_bhb[l_ac].* = g_bhb_t.*
               CLOSE i009_b_curl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_bhb[l_ac].bhb04,-263,1)
               LET g_bhb[l_ac].* = g_bhb_t.*
            ELSE
           UPDATE bhb_file SET bhb04=g_bhb[l_ac].bhb04,
                               bhb05=g_bhb[l_ac].bhb05,
                               bhb06=g_bhb[l_ac].bhb06
                WHERE bhb01=g_bha.bha01
                  AND bhb02=g_bha.bha02
                  AND bhb03=g_bha.bha03
                  AND bhb04=g_bhb_t.bhb04
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_bhb[l_ac].bhb04,SQLCA.sqlcode,0) #FUN-660105
                  CALL cl_err3("upd","bhb_file",g_bha.bha01,g_bhb_t.bhb04,SQLCA.sqlcode,"","",1) #FUN-660105
                  LET g_bhb[l_ac].* = g_bhb_t.*
                  ROLLBACK WORK
               ELSE
                  UPDATE bha_file SET bhadate = g_today
                   WHERE bha01=g_bha.bha01 AND bha02=g_bha.bha02 AND bha03=g_bha.bha03
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
             END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac   #FUN-D30032 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_bhb[l_ac].* = g_bhb_t.*
               #FUN-D30032--add--begin--
               ELSE
                  CALL g_bhb.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30032--add--end----
               END IF
               CLOSE i009_b_curl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D30032 add
            CLOSE i009_b_curl
            COMMIT WORK
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(bhb04) #幣別
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_bgs"
                   LET g_qryparam.default1 = g_bhb[l_ac].bhb04
                   CALL cl_create_qry() RETURNING g_bhb[l_ac].bhb04
#                   CALL FGL_DIALOG_SETBUFFER( g_bhb[l_ac].bhb04 )
                   NEXT FIELD bhb04
           END CASE
 
        ON ACTION CONTROLN
            CALL i009_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                       #沿用所有欄位
           IF INFIELD(bhb04) AND l_ac > 1 THEN
              LET g_bhb[l_ac].* = g_bhb[l_ac-1].*
              LET g_bhb[l_ac].bhb04 = NULL
              NEXT FIELD bhb04
           END IF
 
        ON ACTION CONTROLR
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
 
      ON ACTION controls                      #No.FUN-6B0033
         CALL cl_set_head_visible("","AUTO")  #No.FUN-6B0033
    END INPUT

    UPDATE bha_file SET bhamodu = g_user,bhadate = g_today
     WHERE bha01=g_bha.bha01 AND bha02=g_bha.bha02 AND bha03=g_bha.bha03
 
    CALL i009_delHeader()   #CHI-C30002 add  
    CLOSE i009_b_curl
    COMMIT WORK
#   CALL i009_delall()  #CHI-C30002 mark
END FUNCTION

#CHI-C30002 -------- add --------- begin
FUNCTION i009_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM bha_file WHERE bha01=g_bha.bha01 
                                AND bha02=g_bha.bha02 
                                AND bha03=g_bha.bha03
         INITIALIZE g_bha.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add --------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION i009_delall()
#   SELECT COUNT(*) INTO g_cnt FROM bhb_file
#       WHERE bhb01=g_bha.bha01
#         AND bhb02=g_bha.bha02
#         AND bhb03=g_bha.bha03
#   IF g_cnt = 0 THEN 			# 未輸入單身資料, 則取消單頭資料
#      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#      ERROR g_msg CLIPPED
#      DELETE FROM bha_file
#       WHERE bha01 = g_bha.bha01
#         AND bha02 = g_bha.bha02
#         AND bha03 = g_bha.bha03
#   END IF
#END FUNCTION
#CHI-C30002 -------- mark -------- end 

FUNCTION i009_bhb04(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,   #No.FUN-680061 VARCHAR(01)
    l_bgsacti       LIKE bgs_file.bgsacti
 
    LET g_errno = ' '
    SELECT bgs02,bgsacti
      INTO g_bhb[l_ac].bgs02_1,l_bgsacti
      FROM bgs_file
     WHERE bgs01 = g_bhb[l_ac].bhb04
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'abg-004'
                                   LET g_bhb[l_ac].bgs02_1 = NULL
                                   LET l_bgsacti = NULL
         WHEN l_bgsacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
 
FUNCTION i009_b_askkey()
DEFINE
    l_wc2   LIKE type_file.chr1000  #No.FUN-680061 VARCHAR(200)
 
    CLEAR bgs02_1
    CONSTRUCT l_wc2 ON bhb04,bhb05,bhb06 # 螢幕上取單身條件
         FROM s_bhb[1].bhb04,s_bhb[1].bhb05,s_bhb[1].bhb06
 
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
 
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    CALL i009_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i009_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2       LIKE type_file.chr1000   #No.FUN-680061 VARCHAR(300)
 
    LET g_sql =
        "SELECT bhb04,'',bhb05,bhb06",
        "  FROM bhb_file, OUTER bgs_file",
        " WHERE bhb01 ='",g_bha.bha01,"' ",
        "   AND bhb02 ='",g_bha.bha02,"' ",
        "   AND bhb03 ='",g_bha.bha03,"' ",
        "   AND bhb_file.bhb04 = bgs_file.bgs01 ",
        "   AND ",p_wc2 CLIPPED
 
    PREPARE i009_pb FROM g_sql
    DECLARE bhb_curs                       #SCROLL CURSOR
        CURSOR FOR i009_pb
 
    CALL g_bhb.clear()
 
    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH bhb_curs INTO g_bhb[g_cnt].*   #單身 ARRAY 填充
     #MOD-530026 start
        SELECT bgs02 INTO g_bhb[g_cnt].bgs02_1
          FROM bgs_file
         WHERE bgs01 = g_bhb[g_cnt].bhb04
     #MOD-530026 end
        LET g_rec_b = g_rec_b + 1
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err('',9035,0)
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_bhb.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i009_bp(p_ud)
DEFINE
    p_ud    LIKE type_file.chr1     #No.FUN-680061 VARCHAR(01)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   #DISPLAY ARRAY g_bhb TO s_bhb.* ATTRIBUTE(COUNT=g_rec_b)           #FUN-5A0134 remark
   DISPLAY ARRAY g_bhb TO s_bhb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED) #FUN-5A0134
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION first
         CALL i009_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
         EXIT DISPLAY
      ON ACTION previous
         CALL i009_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
         EXIT DISPLAY
 
      ON ACTION jump
         CALL i009_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
         EXIT DISPLAY
 
      ON ACTION next
         CALL i009_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
         EXIT DISPLAY
 
      ON ACTION last
         CALL i009_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
#      ON ACTION invalid
#         LET g_action_choice="invalid"
#         EXIT DISPLAY
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
 
 
      ON ACTION exporttoexcel   #No.FUN-4B0021
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6A0003  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                       #No.FUN-6B0033
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
 
 
FUNCTION i009_out()
    DEFINE
        l_i    LIKE type_file.num5,    #No.FUN-680061 SMALLINT
        l_name LIKE type_file.chr20,   # External(Disk) file name #NO.FUN-680061 VARCHAR(20)
        l_za05 LIKE type_file.chr1000, #NO.FUN-680061 VARCHAR(40)  
        l_bgs02         LIKE ima_file.ima02,     #No.FUN-770033
        sr RECORD
             bha01      LIKE bha_file.bha01,
             bha02      LIKE bha_file.bha02,
             bha03      LIKE bha_file.bha03,
             bha04      LIKE bha_file.bha04,
             bhb04      LIKE bhb_file.bhb04,
             bhb05      LIKE bhb_file.bhb05,
             bhb06      LIKE bhb_file.bhb06,
             bgs02      LIKE bgs_file.bgs02,
             bhaacti    LIKE bha_file.bhaacti
        END RECORD
 
    IF cl_null(g_wc) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    CALL cl_wait()
#    CALL cl_outnam('abgi009') RETURNING l_name            #No.FUN-770033
    CALL cl_del_data(l_table)                              #No.FUN-770033
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 LET g_sql="SELECT bha01,bha02,bha03,bha04,bhb04,bhb05,bhb06,bgs02 ",
              "  FROM bha_file,bhb_file,OUTER bgs_file ",   # 組合出 SQL 指令  #No.FUN-770033
              " WHERE bha01=bhb01 AND bha02=bhb02 AND bha03=bhb03 ",
              "   AND bhb_file.bhb04=bgs_file.bgs01 ",                       #No.FUN-770033
              "   AND ",g_wc CLIPPED ,
              "   AND ",g_wc2 CLIPPED ,
              " ORDER BY bha01,bha02,bha03 "
    PREPARE i009_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i009_co CURSOR FOR i009_p1
 
#    START REPORT i009_rep TO l_name          #No.FUN-770033
 
    FOREACH i009_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
#No.FUN-770033--start--
    SELECT bgs02  INTO l_bgs02       
          FROM bgs_file                                                                                                         
          WHERE bgs01 = sr.bha03                                                                                                 
          IF SQLCA.sqlcode THEN                                                                                                    
             LET l_bgs02=''                                                                                                        
          END IF  
    EXECUTE insert_prep USING
            sr.bha01,sr.bha02,sr.bha03,l_bgs02,sr.bha04,sr.bhb04,sr.bgs02,
            sr.bhb05,sr.bhb06
#No.FUN-770033--end--
 
#        OUTPUT TO REPORT i009_rep(sr.*)     #No.FUN-770033
    END FOREACH
#No.FUN-770033--start--
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    LET l_sql= "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED    
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(g_wc,'bha01,bha02,bha03,bha04,bhauser,bhagrup,bhamodu,bhadate')
            RETURNING g_wc
       LET g_str = g_wc
    END IF
    LET g_str=g_str                                                    
#No.FUN-770033--end-- 
#    FINISH REPORT i009_rep                                             #No.FUN-770033
 
    CLOSE i009_co
    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)                                  #No.FUN-770033
     CALL cl_prt_cs3('abgi009','abgi009',l_sql,g_str)                   #No.FUN-770033
END FUNCTION
#No.FUN-770033--start--
{REPORT i009_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,    #No.FUN-680061 VARCHAR(01)
        l_i             LIKE type_file.num5,    #No.FUN-680061 SMALLINT
        l_bgs02         LIKE ima_file.ima02,
        sr RECORD
             bha01      LIKE bha_file.bha01,
             bha02      LIKE bha_file.bha02,
             bha03      LIKE bha_file.bha03,
             bha04      LIKE bha_file.bha04,
             bhb04      LIKE bhb_file.bhb04,
             bhb05      LIKE bhb_file.bhb05,
             bhb06      LIKE bhb_file.bhb06,
             bgs02      LIKE bgs_file.bgs02,
             bhaacti    LIKE bha_file.bhaacti
        END RECORD
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.bha01,sr.bha02,sr.bha03,sr.bhb04
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1] CLIPPED
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED, pageno_total
            PRINT g_dash[1,g_len]
            PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
                  g_x[38],g_x[39]
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        BEFORE GROUP OF sr.bha01    #,sr.bha02,sr.bha03,sr.bha04
           PRINT COLUMN g_c[31],sr.bha01[1,9];
        BEFORE GROUP OF sr.bha02
           PRINT COLUMN g_c[32],sr.bha02 USING '####';
        BEFORE GROUP OF sr.bha03
           SELECT bgs02
              INTO l_bgs02
              FROM bgs_file
             WHERE bgs01 = sr.bha03
           IF SQLCA.sqlcode THEN
              LET l_bgs02=''
           END IF
           PRINT COLUMN g_c[33],sr.bha03,
                 COLUMN g_c[34],l_bgs02[1,10],
                 COLUMN g_c[35],cl_numfor(sr.bha04,35,0);
 
        ON EVERY ROW
           PRINT COLUMN g_c[36],sr.bhb04,
                 COLUMN g_c[37],sr.bgs02[1,13];
           IF sr.bhb05 =1 THEN
	      PRINT COLUMN g_c[38],g_x[9] CLIPPED,
                    COLUMN g_c[39],cl_numfor(sr.bhb06,39,6)
           ELSE
              PRINT COLUMN g_c[38],g_x[10] CLIPPED,
                    COLUMN g_c[39],cl_numfor(sr.bhb06,39,6)
           END IF
 
        ON LAST ROW
          PRINT g_dash[1,g_len]
          LET l_trailer_sw = 'n'
          PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT}
#No.FUN-770033--end--
 
FUNCTION i009_copy()
DEFINE
    new_ver     LIKE bha_file.bha01,
    old_ver     LIKE bha_file.bha01,
    new_year    LIKE bha_file.bha02,
    old_year    LIKE bha_file.bha02,
    new_item    LIKE bha_file.bha03,
    old_item    LIKE bha_file.bha03,
    l_bgs02     LIKE bgs_file.bgs02,
    l_bgsacti   LIKE bgs_file.bgsacti
 
 
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_bha.bha02) OR cl_null(g_bha.bha03) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   DISPLAY "" AT 1,1
   CALL cl_getmsg('copy',g_lang) RETURNING g_msg
   DISPLAY g_msg AT 2,1 #ATTRIBUTE(RED)    #No.FUN-940135
   CALL cl_set_head_visible("","YES")      #No.FUN-6B0033
 WHILE TRUE
   INPUT new_ver,new_year,new_item FROM bha01,bha02,bha03
       AFTER FIELD bha01
           IF cl_null(new_ver) THEN
              LET new_ver = ' '
           END IF
 
       AFTER FIELD bha02
           IF cl_null(new_year) THEN
              NEXT FIELD bha02
           END IF
 
       AFTER FIELD bha03
           IF cl_null(new_item) THEN
              NEXT FIELD bha03
           END IF
           SELECT COUNT(*) INTO g_cnt FROM bha_file
            WHERE bha01=new_ver
              AND bha02=new_year
              AND bha03=new_item
           IF g_cnt >0 THEN
              CALL cl_err(new_item,'abg-003',0)
              NEXT FIELD bha03
           END IF
           CALL i009_bha03('a',new_item)
           IF NOT cl_null(g_errno) THEN
              CALL cl_err('',g_errno,0)
              NEXT FIELD bha03
           END IF
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(bha03) #客戶編號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_bgs"
                   LET g_qryparam.default1 = new_item
                   CALL cl_create_qry() RETURNING new_item
                   DISPLAY new_item TO bha03 #ATTRIBUTE(YELLOW)   #TQC-8C0076
                   NEXT FIELD bha03
           END CASE
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
      LET INT_FLAG=0
      DISPLAY BY NAME g_bha.bha01
      DISPLAY BY NAME g_bha.bha02
      DISPLAY BY NAME g_bha.bha03
      RETURN
   END IF
   IF new_ver IS NULL OR
      cl_null(new_year) OR
      cl_null(new_item) THEN
      CONTINUE WHILE
   END IF
   EXIT WHILE
 END WHILE
 
   DROP TABLE y
   SELECT * FROM bha_file
    WHERE bha01=g_bha.bha01
      AND bha02=g_bha.bha02
      AND bha03=g_bha.bha03
     INTO TEMP y
   UPDATE y
      SET bha01 = new_ver,
          bha02 = new_year,
          bha03 = new_item,
          bhauser=g_user,
          bhagrup=g_grup,
          bhamodu=NULL,
          bhadate=g_today,
          bhaacti='Y'
   INSERT INTO bha_file
      SELECT * FROM y
 
   DROP TABLE x
   SELECT * FROM bhb_file
       WHERE bhb01=g_bha.bha01
         AND bhb02=g_bha.bha02
         AND bhb03=g_bha.bha03
        INTO TEMP x
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_bha.bha01,SQLCA.sqlcode,0) #FUN-660105
      CALL cl_err3("ins","x",g_bha.bha01,g_bha.bha02,SQLCA.sqlcode,"","",1) #FUN-660105
      RETURN
   END IF
   UPDATE x
      SET bhb01=new_ver,
          bhb02=new_year,
          bhb03=new_item
   INSERT INTO bhb_file
      SELECT * FROM x
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_bha.bha01,SQLCA.sqlcode,0) #FUN-660105
      CALL cl_err3("ins","bhb_file",new_ver,new_year,SQLCA.sqlcode,"","",1) #FUN-660105
      RETURN
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',new_ver,') OK'
      ATTRIBUTE(REVERSE)
   LET old_ver = g_bha.bha01
   LET old_year= g_bha.bha02
   LET old_item= g_bha.bha03
   SELECT bha_file.* INTO g_bha.* FROM bha_file
    WHERE bha01=new_ver
      AND bha02=new_year
      AND bha03=new_item
   LET g_bha.bha01=new_ver
   LET g_bha.bha02=new_year
   LET g_bha.bha03=new_item
   CALL i009_show()
   CALL i009_u()
   CALL i009_b()
   #FUN-C30027---begin
   #SELECT bha_file.* INTO g_bha.* FROM bha_file
   # WHERE bha01= old_ver
   #   AND bha02= old_year
   #   AND bha03= old_item
   #CALL i009_show()
   #FUN-C30027---end
END FUNCTION
