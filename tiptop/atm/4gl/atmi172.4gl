# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Descriptions...: 運輸途徑維護作業
# Date & Author..: 03/10/10 By Carrier
# Modify.........: No.MOD-4B0067 04/11/08 By Elva  將變數用Like方式定義,報表拉成一行
# Modify.........: No.MOD-4B0123 04/11/10 By Carrier
# Modify.........: No.FUN-4C0052 04/12/08 By pengu Data and Group權限控管
# Modify.........: No.FUN-520024 05/02/24 By Day 報表轉XML
# Modify.........: No.MOD-540145 05/05/10 By vivien  刪除HELP FILE
# Modify.........: No.FUN-5B0113 05/11/22 By Claire 修改單身後單頭的資料更改者及最近修改日應update
# Modify.........: No.TQC-5B0212 05/12/02 By kevin 報表須設定 g_company
# Modify.........: No.FUN-650065 06/05/30 By Rayven axd模塊轉atm模塊
# Modify.........: NO.FUN-660104 06/06/15 By Tracy cl_err -> cl_err3
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換 
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: Mo.FUN-6A0072 06/10/24 By xumin g_no_ask改g_no_ask    
# Modify.........: No.FUN-6A0090 06/11/01 By dxfwo 欄位類型修改(修改apm_file.apm08)
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/10 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-6B0043 06/11/24 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-760083 07/07/16 By mike  報表格式修改為crystal reports
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.FUN-8B0123 08/12/01 By hongmei 修改單身顯示問題
# Modify.........: No.TQC-8C0077 08/12/29 By clover cl_setup模組修改到 ATM
# Modify.........: No.TQC-8C0076 09/01/09 By clover mark #ATTRIBUTE(YELLOW)
# Modify.........: No.FUN-8A0067 09/03/04 By destiny 修改打印時報-201的錯
# Modify.........: No.FUN-940135 09/04/29 By Carrier 去掉顏色的ATTRIBUTE設置
# Modify.........: No.TQC-940018 09/05/07 By mike atmi172無效資料可以刪除
# Modify.........: No.FUN-870100 09/07/20 By cockroach 零售超市移植
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9A0159 09/10/28 By lilingyu 4gl有使用到(+)符號,修改
# Modify.........: No.FUN-9C0073 10/01/08 By chenls 程序精簡
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-A30041 10/03/41 By Cockroach add oriu/orig
# Modify.........: No.TQC-A90056 10/10/14 By houlia g_msg取值問題，調整desc跟g_msg定義 類型及g_msg取值
# Modify.........: No.TQC-AC0050 10/12/07 By houlia 添加報錯信息art-986、art-987
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面
# Modify.........: No:TQC-C90010 12/09/04 By yangxf 歸屬配送中心(obn06)欄位開窗,添加存在與部門檔的控管
# Modify.........: No:FUN-D30033 13/04/15 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_obn           RECORD LIKE obn_file.*,       #簽核等級 (假單頭)
    g_obn_t         RECORD LIKE obn_file.*,       #簽核等級 (舊值)
    g_obn_o         RECORD LIKE obn_file.*,       #簽核等級 (舊值)
    g_obn01_t       LIKE obn_file.obn01,   #簽核等級 (舊值)
    g_obo           DYNAMIC ARRAY OF RECORD#程式變數(Program Variables)
     obo02       LIKE obo_file.obo02,   #簽核順序
        obo03       LIKE obo_file.obo03,   #人員代號
#       desc        LIKE type_file.chr4,   #Job Description             #No.FUN-680120 VARCHAR(04)   #TQC-840066
        desc        LIKE ze_file.ze03,   #TQC-A90056
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
#       desc        LIKE type_file.chr4,   #Job Description             #No.FUN-680120 VARCHAR(04)  #TQC-840066
        desc        LIKE ze_file.ze03,   #TQC-A90056
        obo04       LIKE obo_file.obo04,   #備注
        obo05       LIKE obo_file.obo05,   #備注
        oac02b      LIKE oac_file.oac02,
        obo06       LIKE obo_file.obo06,   #備注
        oac02c      LIKE oac_file.oac02,
        obo07       LIKE obo_file.obo07    #備注
                    END RECORD,
     g_wc,g_wc2,g_sql    STRING,
     g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680120 SMALLINT
     l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT    #No.FUN-680120 SMALLINT
DEFINE   g_before_input_done LIKE type_file.num5          #No.FUN-680120 SMALLINT
DEFINE   g_forupd_sql   STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt          LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE   g_chr          LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
DEFINE   g_i            LIKE type_file.num5     #count/index for any purpose        #No.FUN-680120 SMALLINT
#DEFINE   g_msg          LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(72) 
DEFINE   g_msg          LIKE ze_file.ze03       #TQC-A90056
DEFINE   g_curs_index   LIKE type_file.num10          #No.FUN-680120 INTEGER
DEFINE   g_row_count    LIKE type_file.num10          #No.FUN-680120 INTEGER
DEFINE   g_jump         LIKE type_file.num10          #No.FUN-680120 INTEGER
DEFINE   g_no_ask       LIKE type_file.num5           #No.FUN-680120 SMALLINT   #No.FUN-6A0072
DEFINE   g_table        STRING                        #No.FUN-760083
DEFINE   g_str          STRING                        #No.FUN-760083
 
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("ATM")) THEN     #TQC-8C0077
       EXIT PROGRAM
    END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
    LET g_sql="obn01.obn_file.obn01,",
              "obo02.obo_file.obo02,",
              "obo03.obo_file.obo03,",
              "obo04.obo_file.obo04,",
              "obo05.obo_file.obo05,",
              "oac02b.oac_file.oac02,",
              "obo06.obo_file.obo06,",
              "oac02c.oac_file.oac02,",
              "obo07.obo_file.obo07,",
              "l_desc1.apo_file.apo02" 
    LET g_table=cl_prt_temptable("atmi172",g_sql) CLIPPED
    IF g_table=-1 THEN EXIT PROGRAM END IF
    LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,g_table CLIPPED,      #No.FUN-8A0067
              " VALUES(?,?,?,?,?,?,?,?,?,?)"
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
      CALL cl_err("insert_prep:",status,1)  
    END IF
 
    OPEN WINDOW i172_w WITH FORM "atm/42f/atmi172"
        ATTRIBUTE(STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()
 
    IF g_azw.azw04 <> '2' THEN                      #No.FUN-870100
       CALL cl_set_comp_visible('obn06,obn06_desc,obn07,obn07_desc,obn08,obn08_desc',FALSE)   #No.FUN-870100
    ELSE                                                                 #No.FUN-870100
       CALL cl_set_comp_visible('obo03,desc,obo04',FALSE)           #No.FUN-870100
    END IF                                         #No.FUN-870100
 
    CALL g_x.clear()
    LET g_forupd_sql = "SELECT * FROM obn_file WHERE obn01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i172_cl CURSOR FROM g_forupd_sql
 
    CALL i172_menu()
    CLOSE WINDOW i172_w                 #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
#QBE 查詢資料
FUNCTION i172_cs()
    CLEAR FORM                             #清除畫面
    CALL g_obo.clear()
 
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_obn.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
         obn01,obn02,obn04,obn05,obn06,obn07,obn08,     #No.FUN-870100
         obnuser,obngrup,obnmodu,obndate,obnacti
        ,obnoriu,obnorig                               #TQC-A30041 ADD
     ON ACTION CONTROLP
            CASE
                WHEN INFIELD(obn04)
                    CALL cl_init_qry_var()
                    IF g_azw.azw04 ='2' THEN
                       LET g_qryparam.form ="q_obn04" 
                    ELSE
                       LET g_qryparam.form ="q_oac"
                    END IF
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO obn04
                    NEXT FIELD obn04
                WHEN INFIELD(obn05)
                    CALL cl_init_qry_var()
                    IF g_azw.azw04 ='2' THEN 
                       LET g_qryparam.form ="q_obn05"
                    ELSE
                       LET g_qryparam.form ="q_oac" 
                    END IF 
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO obn05
                    NEXT FIELD obn05
                WHEN INFIELD(obn06)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_obn06"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO obn06
                    NEXT FIELD obn06
                WHEN INFIELD(obn07)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_obn07"  
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO obn07
                    NEXT FIELD obn07
                WHEN INFIELD(obn08)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_obn08"     
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO obn08
                    NEXT FIELD obn08
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
    IF INT_FLAG THEN RETURN END IF
    #資料權限的檢查
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('obnuser', 'obngrup')
 
 
 CONSTRUCT g_wc2 ON obo02,obo03,obo04,obo05,obo06,obo07   # 螢幕上取單身條件
            FROM s_obo[1].obo02,s_obo[1].obo03,s_obo[1].obo04,
                 s_obo[1].obo05,s_obo[1].obo06,s_obo[1].obo07
         ON ACTION CONTROLP
            CASE
                WHEN INFIELD(obo05)
                     CALL cl_init_qry_var()
                     IF g_azw.azw04 = '2' THEN
                        LET g_qryparam.form="q_obo05"   
                     ELSE
                        LET g_qryparam.form="q_oac"
                     END IF 
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO s_obo[1].obo05
                     NEXT FIELD obo05
                WHEN INFIELD(obo06)
                     CALL cl_init_qry_var()
                     IF g_azw.azw04 = '2' THEN  
                        LET g_qryparam.form="q_obo06"
                     ELSE
                        LET g_qryparam.form="q_oac"
                     END IF                    
                     LET g_qryparam.state = 'c'
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
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT  obn01 FROM obn_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY obn01"
    ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE obn_file. obn01 ",
                   "  FROM obn_file, obo_file ",
                   " WHERE obn01 = obo01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY obn01"
    END IF
 
    PREPARE i172_prepare FROM g_sql
    DECLARE i172_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i172_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM obn_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT obn01) FROM obn_file,obo_file WHERE ",
                  "obo01=obn01 ",
                  " AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
 
    END IF
    PREPARE i172_precount FROM g_sql
    DECLARE i172_count CURSOR FOR i172_precount
END FUNCTION
 
FUNCTION i172_menu()
   WHILE TRUE
      CALL i172_bp("G")
      CASE g_action_choice
        WHEN "insert"
           IF cl_chk_act_auth() THEN
              CALL i172_a()
           END IF
        WHEN "query"
           IF cl_chk_act_auth() THEN
              CALL i172_q()
           END IF
        WHEN "delete"
           IF cl_chk_act_auth() THEN
              CALL i172_r()
           END IF
        WHEN "reproduce"
           IF cl_chk_act_auth() THEN
              CALL i172_copy()
           END IF
        WHEN "modify"
           IF cl_chk_act_auth() THEN
              CALL i172_u()
           END IF
        WHEN "detail"
           IF cl_chk_act_auth() THEN
              CALL i172_b()
           ELSE
              LET g_action_choice = NULL
           END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i172_x()
            END IF
        WHEN "output"
           IF cl_chk_act_auth() THEN
              CALL i172_out()
           END IF
        WHEN "help"
           CALL cl_show_help()
        WHEN "exit"
           EXIT WHILE
        WHEN "controlg"
           CALL cl_cmdask()
        WHEN "related_document"  #相關文件
             IF cl_chk_act_auth() THEN
                IF g_obn.obn01 IS NOT NULL THEN
                LET g_doc.column1 = "obn01"
                LET g_doc.value1 = g_obn.obn01
                CALL cl_doc()
              END IF
        END IF
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION i172_a()
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
        LET g_obn.obnoriu = g_user #FUN-980030
        LET g_obn.obnorig = g_grup #FUN-980030
        LET g_obn.obngrup=g_grup
        LET g_obn.obndate=g_today
        LET g_obn.obnacti='Y'              #資料有效

        DISPLAY BY NAME g_obn.obnuser,g_obn.obnoriu,g_obn.obnorig,g_obn.obngrup,g_obn.obndate,g_obn.obnacti #TQC-A30041 ADD

        CALL i172_i("a")                #輸入單頭
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
            CALL cl_err3("ins","obn_file",g_obn.obn01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
            CONTINUE WHILE
        END IF
        SELECT obn01 INTO g_obn.obn01 FROM obn_file
            WHERE obn01 = g_obn.obn01  # AND obnplant = g_obn.obnplant      #FUN-870100
        LET g_obn01_t = g_obn.obn01        #保留舊值
        LET g_obn_t.* = g_obn.*
        LET g_rec_b=0
        CALL g_obo.clear()
        CALL i172_b()                   #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i172_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_obn.obn01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_obn.* FROM obn_file WHERE obn01=g_obn.obn01 #AND obnplant=g_plant  #No.FUN-870100
    IF g_obn.obnacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_obn.obn01,9027,0)
       RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_obn01_t = g_obn.obn01
    LET g_obn_o.* = g_obn.*
    BEGIN WORK
    OPEN i172_cl USING g_obn.obn01
    IF STATUS THEN
       CALL cl_err("OPEN i172_cl:", STATUS, 1)
       CLOSE i172_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i172_cl INTO g_obn.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_obn.obn01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE i172_cl ROLLBACK WORK RETURN
    END IF
    CALL i172_show()
    WHILE TRUE
        LET g_obn01_t = g_obn.obn01
        LET g_obn.obnmodu=g_user
        LET g_obn.obndate=g_today
        CALL i172_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_obn.*=g_obn_t.*
            CALL i172_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
     IF g_obn.obn01 != g_obn01_t THEN            # 更改單號
            UPDATE obo_file SET obo01 = g_obn.obn01
                WHERE obo01 = g_obn01_t
            IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","obo_file",g_obn01_t,"",
                              SQLCA.sqlcode,"","",1) CONTINUE WHILE   #No.FUN-660104
            END IF
        END IF
UPDATE obn_file SET obn_file.* = g_obn.*
     WHERE obn01 = g_obn01_t
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","obn_file",g_obn.obn01,"",
                          SQLCA.sqlcode,"","",1)  #No.FUN-660104
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i172_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i172_obn06(p_cmd)
DEFINE  p_cmd        LIKE type_file.chr1
DEFINE  l_obn06_desc LIKE gem_file.gem02
 
  SELECT gem02 INTO l_obn06_desc FROM gem_file WHERE gem01 = g_obn.obn06 AND gemacti='Y'
 
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     DISPLAY l_obn06_desc TO FORMONLY.obn06_desc
  END IF
 
END FUNCTION
 
FUNCTION i172_obn07(p_cmd)
DEFINE  p_cmd        LIKE type_file.chr1
DEFINE  l_obn07_desc LIKE gem_file.gem02
 
  SELECT rvj02 INTO l_obn07_desc FROM rvj_file WHERE rvj01 = g_obn.obn07 AND rvjacti='Y'
 
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     DISPLAY l_obn07_desc TO FORMONLY.obn07_desc
  END IF
 
END FUNCTION
 
FUNCTION i172_obn08(p_cmd)
DEFINE  p_cmd        LIKE type_file.chr1
DEFINE  l_obn08_desc LIKE gem_file.gem02
 
  SELECT rvi02 INTO l_obn08_desc FROM rvi_file WHERE rvi01 = g_obn.obn08 AND rviacti='Y'
 
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     DISPLAY l_obn08_desc TO FORMONLY.obn08_desc
  END IF
 
END FUNCTION
 
 
#處理INPUT
FUNCTION i172_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,                 #判斷必要欄位是否有輸入    #No.FUN-680120 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #a:輸入 u:更改             #No.FUN-680120 VARCHAR(1)
    l_desc          LIKE ima_file.ima01,                 #No.FUN-680120 
    l_obm02         LIKE obm_file.obm02,
    l_oac02         LIKE oac_file.oac02,
    l_oac02a        LIKE oac_file.oac02,
    l_cnt           LIKE type_file.num5,                 #No.FUN-680120 SMALLINT
    l_n             LIKE type_file.num5                   #FUN-870100
 
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
    INPUT BY NAME g_obn.obnoriu,g_obn.obnorig,
        g_obn.obn01,g_obn.obn02,g_obn.obn04,g_obn.obn05,g_obn.obn06,g_obn.obn07,g_obn.obn08,#g_obn.obnplant,  #NO.MOD-4B0123  #No.FUN-870100
        g_obn.obnuser,g_obn.obngrup,g_obn.obnmodu,g_obn.obndate,g_obn.obnacti
        WITHOUT DEFAULTS HELP 1
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i172_set_entry(p_cmd)
            CALL i172_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
            LET l_cnt=0
  
        AFTER FIELD obn01                  #簽核等級
            IF NOT cl_null(g_obn.obn01) THEN
               IF g_obn.obn01 != g_obn01_t OR g_obn01_t IS NULL THEN
                   SELECT COUNT(*) INTO g_cnt FROM obn_file
                    WHERE obn01 = g_obn.obn01  # AND obnplant=g_plant   #No.FUN-870100
                   IF g_cnt > 0 THEN   #資料重復
                       CALL cl_err(g_obn.obn01,-239,0)
                       LET g_obn.obn01 = g_obn01_t
                       DISPLAY BY NAME g_obn.obn01
                       NEXT FIELD obn01
                   END IF
               END IF
            END IF
        AFTER FIELD obn04
            IF NOT cl_null(g_obn.obn04) THEN
               IF g_azw.azw04<>'2' THEN                    #FUN-870100 ADD
                  SELECT oac02 INTO l_oac02 FROM oac_file
                   WHERE oac01 = g_obn.obn04
               ELSE
               	  IF p_cmd = 'a' OR (p_cmd = 'u' AND g_obn.obn04!=g_obn_t.obn04) THEN
                     IF NOT cl_null(g_obn.obn05) THEN
                        IF g_obn.obn04 = g_obn.obn05 THEN
                           CALL cl_err('','atm-814',0)
                           LET g_obn.obn04=g_obn_t.obn04
                           DISPLAY BY NAME g_obn.obn04
                           NEXT FIELD obn04
                        END IF
                     END IF
                  END IF
                  SELECT azp02 INTO l_oac02 FROM azp_file           #No.FUN-870100
                   WHERE azp01 = g_obn.obn04                        #No.FUN-870100
               END IF                                               #No.FUN-870100 
                  IF STATUS THEN
                  CALL cl_err3("sel","azp_file",g_obn.obn04,"",
                                "mfg3119","","",1)  NEXT FIELD obn04 #No.FUN-660104
               END IF
               DISPLAY l_oac02 TO oac02
            END IF
 
        AFTER FIELD obn05
            IF NOT cl_null(g_obn.obn05) THEN
               IF g_azw.azw04<>'2' THEN                            #No.FUN-870100
                  SELECT oac02 INTO l_oac02a FROM oac_file
                  WHERE oac01 = g_obn.obn05
               ELSE
               	  IF p_cmd = 'a' OR (p_cmd = 'u' AND g_obn.obn05!=g_obn_t.obn05) THEN
               	     SELECT COUNT(*) INTO l_n FROM azp_file WHERE azp01=g_obn.obn05 
                     IF l_n=0 THEN
                        CALL cl_err('','atm-818',0)
                        LET g_obn.obn05=g_obn_t.obn05
                        DISPLAY BY NAME g_obn.obn05
                        NEXT FIELD obn05
                     END IF
                     IF NOT cl_null(g_obn.obn04) THEN
                        IF g_obn.obn05 = g_obn.obn04 THEN
                           CALL cl_err('','atm-814',0)
                           LET g_obn.obn05=g_obn_t.obn05
                           DISPLAY BY NAME g_obn.obn05
                           NEXT FIELD obn05
                        END IF
                     END IF
                  END IF
               END IF 
               IF STATUS THEN
                  CALL cl_err3("sel","oac_file",g_obn.obn05,"",
                                "mfg3119","","",1)  NEXT FIELD obn05  #No.FUN-660104
               END IF
               SELECT azp02 INTO l_oac02a FROM azp_file          #No.FUN-870100
               WHERE azp01 = g_obn.obn05                         #No.FUN-870100
               DISPLAY l_oac02a TO oac02a
            END IF
 
        AFTER FIELD obn06
           IF NOT cl_null(g_obn.obn06) THEN
              SELECT COUNT(*) INTO l_cnt FROM gem_file WHERE gem01=g_obn.obn06 AND gemacti='Y'
              IF l_cnt>0 THEN
                 CALL i172_obn06('a')
              ELSE
                 CALL cl_err('','art-188',0)
                 LET g_obn.obn06=g_obn_t.obn06
                 DISPLAY BY NAME g_obn.obn06
                 NEXT FIELD obn06
              END IF
              IF p_cmd = 'a' OR (p_cmd = 'u' AND g_obn.obn06!=g_obn_t.obn06) THEN
                 IF NOT cl_null(g_obn.obn05) AND NOT cl_null(g_obn.obn08) THEN
                    SELECT COUNT(*) INTO l_n FROM obn_file WHERE obn06=g_obn.obn06 AND obn05=g_obn.obn05 AND obn08=g_obn.obn08      #FUN-870100
                    IF l_n>0 THEN
                       CALL cl_err('','atm-816',0)
                       LET g_obn.obn06=g_obn_t.obn06
                       DISPLAY BY NAME g_obn.obn06
                       NEXT FIELD obn06
                    END IF
                    IF g_obn.obn05 = g_obn.obn04 THEN
                       CALL cl_err('','atm-814',0)
                       LET g_obn.obn06=g_obn_t.obn06
                       DISPLAY BY NAME g_obn.obn06
                       NEXT FIELD obn06
                    END IF
                 END IF
              END IF
           END IF
 
        AFTER FIELD obn07
           IF NOT cl_null(g_obn.obn07) THEN
              SELECT COUNT(*) INTO l_cnt FROM rvj_file WHERE rvj01=g_obn.obn07 AND rvjacti='Y'
              IF l_cnt>0 THEN
                 CALL i172_obn07('a')
              ELSE
             #   CALL cl_err('','art-188',0)       #TQC-AC0050  --mark
                 CALL cl_err('','art-986',0)       #TQC-AC0050  --modify
                 LET g_obn.obn07=g_obn_t.obn07
                 DISPLAY BY NAME g_obn.obn07
                 NEXT FIELD obn07
              END IF
           END IF
 
        AFTER FIELD obn08
           IF NOT cl_null(g_obn.obn08) THEN
              SELECT COUNT(*) INTO l_cnt FROM rvi_file WHERE rvi01=g_obn.obn08 AND rviacti='Y'
              IF l_cnt>0 THEN
                 CALL i172_obn08('a')
              ELSE
              #  CALL cl_err('','art-188',0)      #TQC-AC0050   --mark
                 CALL cl_err('','art-987',0)      #TQC-AC0050   --modify
                 LET g_obn.obn08=g_obn_t.obn08
                 DISPLAY BY NAME g_obn.obn08
                 NEXT FIELD obn08
              END IF
              IF p_cmd = 'a' OR (p_cmd = 'u' AND g_obn.obn08!=g_obn_t.obn08) THEN
                 IF NOT cl_null(g_obn.obn05) AND NOT cl_null(g_obn.obn06) THEN
                    SELECT COUNT(*) INTO l_n FROM obn_file WHERE obn06=g_obn.obn06 AND obn05=g_obn.obn05 AND obn08=g_obn.obn08       #FUN-870100
                    IF l_n>0 THEN
                       CALL cl_err('','atm-817',0)
                       LET g_obn.obn08=g_obn_t.obn08
                       DISPLAY BY NAME g_obn.obn08
                       NEXT FIELD obn08
                    END IF
                 END IF
              END IF
           END IF
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,并要求重新輸入
           LET g_obn.obnuser = s_get_data_owner("obn_file") #FUN-C10039
           LET g_obn.obngrup = s_get_data_group("obn_file") #FUN-C10039
            LET l_flag='N'
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
 
        ON ACTION CONTROLF                 #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
     ON ACTION CONTROLP
            CASE
                WHEN INFIELD(obn04)
                    CALL cl_init_qry_var()
                    IF g_azw.azw04<>'2' THEN                  #No.FUN-870100
                       LET g_qryparam.form ="q_oac"
                    ELSE
                       LET g_qryparam.form ="q_azp"        #No.FUN-870100
                    END IF                                   #No.FUN-870100
                    LET g_qryparam.default1 = g_obn.obn04
                    CALL cl_create_qry() RETURNING g_obn.obn04
                    DISPLAY g_obn.obn04 TO obn04
                WHEN INFIELD(obn05)
                    CALL cl_init_qry_var()
                    IF g_azw.azw04<>'2' THEN                  #No.FUN-870100
                       LET g_qryparam.form ="q_oac"
                    ELSE
                       LET g_qryparam.form ="q_azp"        #No.FUN-870100
                    END IF                                   #No.FUN-870100
                    LET g_qryparam.default1 = g_obn.obn05
                    CALL cl_create_qry() RETURNING g_obn.obn05
                    DISPLAY g_obn.obn05 TO obn05
                WHEN INFIELD(obn06)
                    CALL cl_init_qry_var()
                   #LET g_qryparam.form ="q_geu"                 #TQC-C90010 mark
                    LET g_qryparam.form ="q_geu2"                #TQC-C90010 add
                    LET g_qryparam.default1 = g_obn.obn06
                    LET g_qryparam.arg1 = '8' 
                    CALL cl_create_qry() RETURNING g_obn.obn06
                    DISPLAY g_obn.obn06 TO obn06
                    CALL i172_obn06('a')
                    NEXT FIELD obn06
                WHEN INFIELD(obn07)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_rvj1"
                    LET g_qryparam.default1 = g_obn.obn07
                    LET g_qryparam.arg1 = g_obn.obn06
                    CALL cl_create_qry() RETURNING g_obn.obn07
                    DISPLAY g_obn.obn07 TO obn07
                    CALL i172_obn07('a')
                    NEXT FIELD obn07
                WHEN INFIELD(obn08)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_rvi01"
                    LET g_qryparam.default1 = g_obn.obn08
                    CALL cl_create_qry() RETURNING g_obn.obn08
                    DISPLAY g_obn.obn08 TO obn08
                    CALL i172_obn08('a')
                    NEXT FIELD obn08
                OTHERWISE
                    EXIT CASE
            END CASE
 
        ON ACTION CONTROLR
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
FUNCTION i172_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_obn.* TO NULL               #No.FUN-6B0043
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_obo.clear()
    DISPLAY '   ' TO FORMONLY.cnt  #ATTRIBUTE(YELLOW)
    CALL i172_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    MESSAGE " SEARCHING ! " ATTRIBUTE(REVERSE)
    OPEN i172_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_obn.* TO NULL
    ELSE
        OPEN i172_count
        FETCH i172_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i172_fetch('F')                  # 讀出TEMP第一筆并顯示
    END IF
    MESSAGE ""
END FUNCTION
 
#處理資料的讀取
FUNCTION i172_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680120 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i172_cs INTO g_obn.obn01
        WHEN 'P' FETCH PREVIOUS i172_cs INTO g_obn.obn01
        WHEN 'F' FETCH FIRST    i172_cs INTO g_obn.obn01
        WHEN 'L' FETCH LAST     i172_cs INTO g_obn.obn01
        WHEN '/'
          IF (NOT g_no_ask) THEN   #No.FUN-6A0072
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
          FETCH ABSOLUTE g_jump i172_cs INTO g_obn.obn01
          LET g_no_ask = FALSE   #No.FUN-6A0072
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_obn.obn01,SQLCA.sqlcode,0)
        RETURN
    END IF
    SELECT * INTO g_obn.* FROM obn_file WHERE obn01 = g_obn.obn01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","obn_file",g_obn.obn01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
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
    CALL i172_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i172_show()
    DEFINE l_cnt      LIKE type_file.num5          #No.FUN-680120 SMALLINT
    DEFINE l_desc     LIKE ima_file.ima01,         #No.FUN-680120 VARCHAR(10) 
           l_obm02    LIKE obm_file.obm02,
           l_oac02    LIKE oac_file.oac02,
           l_oac02a   LIKE oac_file.oac02
    LET g_obn_t.* = g_obn.*                      #保存單頭舊值
    DISPLAY BY NAME g_obn.obnoriu,g_obn.obnorig,                              # 顯示單頭值
      g_obn.obn01,g_obn.obn02,    #NO.MOD-4B0123
        g_obn.obn04,g_obn.obn05,g_obn.obn06,g_obn.obn07,g_obn.obn08, # g_obn.obnplant,   #No.FUN-870100
        g_obn.obnuser,g_obn.obngrup,g_obn.obnmodu,
        g_obn.obndate,g_obn.obnacti
 IF g_azw.azw04<>'2' THEN                                                      #No.FUN-870100
    SELECT oac02 INTO l_oac02  FROM oac_file WHERE oac01 = g_obn.obn04
    SELECT oac02 INTO l_oac02a FROM oac_file WHERE oac01 = g_obn.obn05
 ELSE                                                                           #No.FUN-870100
    SELECT azp02 INTO l_oac02  FROM azp_file WHERE azp01 = g_obn.obn04          #No.FUN-870100
    SELECT azp02 INTO l_oac02a FROM azp_file WHERE azp01 = g_obn.obn05          #No.FUN-870100
 END IF                                                                         #No.FUN-870100
    DISPLAY l_oac02  TO FORMONLY.oac02
    DISPLAY l_oac02a TO FORMONLY.oac02a
    CALL i172_obn06('d')                      #No.FUN-870100
    CALL i172_obn07('d')                      #No.FUN-870100
    CALL i172_obn08('d')                      #No.FUN-870100
    CALL i172_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i172_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_obn.obn01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
    IF g_obn.obnacti='N' THEN CALL cl_err("",'abm-950',0) RETURN END IF #TQC-940018  
    BEGIN WORK
    OPEN i172_cl USING g_obn.obn01
    IF STATUS THEN
       CALL cl_err("OPEN i172_cl:", STATUS, 1)
       CLOSE i172_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i172_cl INTO g_obn.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_obn.obn01,SQLCA.sqlcode,0)          #資料被他人LOCK
        CLOSE i172_cl ROLLBACK WORK RETURN
    END IF
    CALL i172_show()
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "obn01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_obn.obn01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
         DELETE FROM obn_file WHERE obn01 = g_obn.obn01 # AND obnplant=g_plant  #No.FUN-870100
         DELETE FROM obo_file WHERE obo01 = g_obn.obn01 # AND oboplant=g_plant  #No.FUN-870100
         INITIALIZE g_obn.* TO NULL
         CLEAR FORM
         CALL g_obo.clear()
         OPEN i172_count
         #FUN-B50064-add-start--
         IF STATUS THEN
            CLOSE i172_cs
            CLOSE i172_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         FETCH i172_count INTO g_row_count
         #FUN-B50064-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i172_cs
            CLOSE i172_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i172_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i172_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE   #No.FUN-6A0072
            CALL i172_fetch('/')
         END IF
    END IF
    CLOSE i172_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i172_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_obn.obn01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
    BEGIN WORK
    OPEN i172_cl USING g_obn.obn01
    IF STATUS THEN
       CALL cl_err("OPEN i172_cl:", STATUS, 1)
       CLOSE i172_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i172_cl INTO g_obn.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_obn.obn01,SQLCA.sqlcode,0)          #資料被他人LOCK
        CLOSE i172_cl ROLLBACK WORK RETURN
    END IF
    CALL i172_show()
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
            CALL cl_err3("upd","obn_file",g_obn.obn01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
            LET g_obn.obnacti=g_chr
        END IF
        DISPLAY BY NAME g_obn.obnacti #ATTRIBUTE(RED)    #No.FUN-940135
    END IF
    CLOSE i172_cl
    COMMIT WORK
END FUNCTION
 
#單身
FUNCTION i172_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680120 SMALLINT
    l_n,l_n1        LIKE type_file.num5,                #檢查重復用         #No.FUN-680120 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680120 VARCHAR(1)
    l_exit_sw       LIKE type_file.chr1,                 #No.FUN-680120 VARCHAR(1)    #Esc結束INPUT ARRAY 否
    p_cmd           LIKE type_file.chr1,                 #處理狀態          #No.FUN-680120 VARCHAR(1)
     l_obo02         LIKE obo_file.obo02,               #NO.MOD-4B0067
    l_allow_insert  LIKE type_file.num5,                #可新增否           #No.FUN-680120 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否           #No.FUN-680120 SMALLINT
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
    IF g_obn.obn01 IS NULL THEN
        RETURN
    END IF
    SELECT * INTO g_obn.* FROM obn_file WHERE obn01=g_obn.obn01 #AND obnplant = g_obn.obnplant      #FUN-870100
    IF g_obn.obnacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_obn.obn01,'aom-000',0)
        RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT obo02,obo03,'',obo04,obo05,'',obo06,'',obo07 ",
                       "   FROM obo_file WHERE obo01= ? AND obo02= ?  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i172_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
      LET l_allow_insert = cl_detail_input_auth("insert")
      LET l_allow_delete = cl_detail_input_auth("delete")
 
      INPUT ARRAY g_obo WITHOUT DEFAULTS FROM s_obo.*
            ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                      APPEND ROW=l_allow_insert)
 
    BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
    BEFORE ROW
            LET p_cmd=' '
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            BEGIN WORK
            OPEN i172_cl USING g_obn.obn01
            IF STATUS THEN
               CALL cl_err("OPEN i172_cl:", STATUS, 1)
               CLOSE i172_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH i172_cl INTO g_obn.*            # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
                CALL cl_err(g_obn.obn01,SQLCA.sqlcode,0)      # 資料被他人LOCK
                CLOSE i172_cl ROLLBACK WORK RETURN
            END IF
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_obo_t.* = g_obo[l_ac].*  #BACKUP
                OPEN i172_bcl USING g_obn.obn01,g_obo_t.obo02
                IF STATUS THEN
                   CALL cl_err("OPEN i172_bcl:", STATUS, 1)
                   LET l_lock_sw='Y'
                ELSE
                   FETCH i172_bcl INTO g_obo[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_obo_t.obo02,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                   CALL cl_getmsg('axd-034',g_lang) RETURNING g_msg
                   CASE g_obo[l_ac].obo03
#TQC-A90056  --modify
  #                  WHEN '1'  LET g_obo[l_ac].desc=g_msg[1,4]
  #                  WHEN '2'  LET g_obo[l_ac].desc=g_msg[5,8]
  #                  WHEN '3'  LET g_obo[l_ac].desc=g_msg[9,12]
                     WHEN '1'  LET g_obo[l_ac].desc=g_msg[1,6]
                     WHEN '2'  LET g_obo[l_ac].desc=g_msg[7,12]
                     WHEN '3'  LET g_obo[l_ac].desc=g_msg[13,18]
#TQC-A90056  --end
                   END CASE
                   IF g_azw.azw04<>'2' THEN
                      SELECT oac02 INTO g_obo[l_ac].oac02b FROM oac_file
                       WHERE oac01=g_obo[l_ac].obo05
                      SELECT oac02 INTO g_obo[l_ac].oac02c FROM oac_file 
                       WHERE oac01=g_obo[l_ac].obo06              
                   ELSE
                      SELECT azp02 INTO g_obo[l_ac].oac02b FROM azp_file
                       WHERE azp01=g_obo[l_ac].obo05
                      SELECT azp02 INTO g_obo[l_ac].oac02c FROM azp_file
                       WHERE azp01=g_obo[l_ac].obo06
                   END IF
                END IF
                CALL i172_set_entry_b(p_cmd)
                CALL i172_set_no_entry_b(p_cmd)
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
    BEFORE INSERT
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
                   CALL cl_err3("del","obo_file",g_obn_t.obn02,"",
                                 SQLCA.sqlcode,"","",1)  #No.FUN-660104
                   LET l_exit_sw = "n"
                   LET l_ac_t = l_ac
                   EXIT INPUT
               ELSE
                   LET g_rec_b=g_rec_b-l_n1-1
               END IF
               DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
               CLEAR FORM
               CALL g_obo.clear()
               CALL i172_show()
            END IF
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
         INITIALIZE g_obo[l_ac].* TO NULL      #900423
            LET g_obo_t.* = g_obo[l_ac].*         #新輸入資料
            CALL i172_set_entry_b(p_cmd)
            CALL i172_set_no_entry_b(p_cmd)
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD obo02
 
    AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO obo_file(obo01,obo02,obo03,obo04,obo05,obo06,obo07)      #No.FUN-870100
                       VALUES(g_obn.obn01,g_obo[l_ac].obo02,
                              g_obo[l_ac].obo03,g_obo[l_ac].obo04,
                              g_obo[l_ac].obo05,g_obo[l_ac].obo06,
                              g_obo[l_ac].obo07)                           #No.FUN-870100
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","obo_file",g_obo[l_ac].obo02,"",
                             SQLCA.sqlcode,"","",1)  #No.FUN-660104
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
                WHERE obo01 = g_obn.obn01  # AND oboplant = g_obn.obnplant      #FUN-870100
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
               IF g_azw.azw04<>'2' THEN                                   #No.FUN-870100
                  SELECT oac02 INTO g_obo[l_ac].oac02b FROM oac_file
                   WHERE oac01=g_obo[l_ac].obo05
               ELSE
                  SELECT azp02 INTO g_obo[l_ac].oac02b FROM azp_file
                   WHERE azp01=g_obo[l_ac].obo05
               END IF
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
            CALL i172_set_entry_b(p_cmd)
 
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
#TQC-A90056  --modify
              #  WHEN '1'  LET g_obo[l_ac].desc=g_msg[1,4]   
              #  WHEN '2'  LET g_obo[l_ac].desc=g_msg[5,8]
              #  WHEN '3'  LET g_obo[l_ac].desc=g_msg[9,12]
                 WHEN '1'  LET g_obo[l_ac].desc=g_msg[1,6]   
                 WHEN '2'  LET g_obo[l_ac].desc=g_msg[7,12]
                 WHEN '3'  LET g_obo[l_ac].desc=g_msg[13,18]
#TQC-A90056  --end
               END CASE
               IF g_obo[l_ac].obo03 = '1' THEN
                  IF g_obo[l_ac].obo05 = g_obo[l_ac].obo06 THEN
                     LET g_obo[l_ac].obo06 = ''
                  END IF
               END IF
               IF g_obo[l_ac].obo03 = '2' OR g_obo[l_ac].obo03 = '3' THEN
                  LET g_obo[l_ac].obo06 = g_obo[l_ac].obo05
               END IF
               IF g_azw.azw04<>'2' THEN                                    #No.FUN-870100
                  SELECT oac02 INTO g_obo[l_ac].oac02b FROM oac_file
                   WHERE oac01=g_obo[l_ac].obo05
                  SELECT oac02 INTO g_obo[l_ac].oac02c FROM oac_file
                   WHERE oac01=g_obo[l_ac].obo06
               ELSE
                  SELECT azp02 INTO g_obo[l_ac].oac02b FROM azp_file
                   WHERE azp01=g_obo[l_ac].obo05
                  SELECT azp02 INTO g_obo[l_ac].oac02c FROM azp_file
                   WHERE azp01=g_obo[l_ac].obo06 
               END IF
 
            END IF
            DISPLAY BY NAME g_obo[l_ac].desc
            DISPLAY BY NAME g_obo[l_ac].obo06
            DISPLAY BY NAME g_obo[l_ac].oac02b
            DISPLAY BY NAME g_obo[l_ac].oac02c
               DISPLAY BY NAME g_obo[l_ac].oac02c
               DISPLAY BY NAME g_obo[l_ac].obo06
               DISPLAY BY NAME g_obo[l_ac].obo05
            CALL i172_set_no_entry_b(p_cmd)
 
 
        AFTER FIELD obo05
            IF NOT cl_null(g_obo[l_ac].obo05) THEN
               IF p_cmd = 'a' OR (p_cmd = 'u' AND g_obo[l_ac].obo05!=g_obo_t.obo05) THEN
                  IF g_azw.azw04='2' THEN
                     SELECT COUNT(*) INTO l_n FROM azp_file WHERE azp01 = g_obo[l_ac].obo05 
                     IF l_n<=0 THEN 
                        CALL cl_err('','atm-808',0)
                        LET g_obo[l_ac].obo05=g_obo_t.obo05
                        DISPLAY BY NAME g_obo[l_ac].obo05
                        NEXT FIELD obo05
                     END IF
                     IF g_obo_t.obo05 IS NOT NULL AND
                        g_obo_t.obo05 <> g_obo[l_ac].obo06 THEN
                        IF NOT cl_confirm('axd-054') THEN
                           LET g_obo[l_ac].obo05 = g_obo_t.obo06
                           NEXT FIELD obo05
                        END IF
                     END IF
                     IF g_azw.azw04='2' THEN
                        IF g_obo[l_ac].obo05 = g_obo[l_ac].obo06 THEN
                           CALL cl_err(g_obo[l_ac].obo05,'atm-811',0)
                           NEXT FIELD obo05
                        END IF
                     END IF
                     IF g_azw.azw04<>'2' THEN
                        IF g_obo[l_ac].obo03 = '1' THEN 
                           IF g_obo[l_ac].obo05 = g_obo[l_ac].obo06 THEN
                              CALL cl_err(g_obo[l_ac].obo05,'axd-055',0)
                              NEXT FIELD obo05
                           END IF
                        ELSE 
                           IF g_obo[l_ac].obo05 <> g_obo[l_ac].obo06 THEN      
                              LET g_obo[l_ac].obo05 = g_obo[l_ac].obo06
                              CALL cl_err(g_obo[l_ac].obo05,'axd-056',0)
                              NEXT FIELD obo05
                           END IF
                        END IF
                     END IF
                  END IF
               END IF
               IF g_azw.azw04<>'2' THEN
                  SELECT oac02 INTO g_obo[l_ac].oac02b FROM oac_file
                   WHERE oac01=g_obo[l_ac].obo05
               ELSE
                  SELECT azp02 INTO g_obo[l_ac].oac02b FROM azp_file
                   WHERE azp01=g_obo[l_ac].obo05
               END IF
            END IF
        AFTER FIELD obo06
            IF NOT cl_null(g_obo[l_ac].obo06) THEN
               IF g_azw.azw04<>'2' THEN                           #No.FUN-870100
                  SELECT * FROM oac_file
                  WHERE oac01 = g_obo[l_ac].obo06
               END IF                                           #No.FUN-870100
               IF p_cmd = 'a' OR (p_cmd = 'u' AND g_obo[l_ac].obo06!=g_obo_t.obo06) THEN    #No.FUN-870100
                  IF g_azw.azw04='2' THEN                            #No.FUN-870100
                     SELECT * FROM azp_file                            #No.FUN-870100
                     WHERE azp01 = g_obo[l_ac].obo06                    #No.FUN-870100
                  END IF                                               #No.FUN-870100
                  IF STATUS = 100 THEN
                     CALL cl_err3("sel","oac_file",g_obo[l_ac].obo06,"",
                                "100","","",1)  #No.FUN-660104
                     NEXT FIELD obo06
                  END IF
                  SELECT COUNT(*) INTO l_n FROM obo_file 
                   WHERE obo01=g_obn.obn01 
                     AND obo06=g_obn.obn05 
                  IF l_n>0 THEN
                     CALL cl_err('','atm-810',0)
                     LET g_obo[l_ac].obo06=g_obo_t.obo06
                     DISPLAY BY NAME g_obo[l_ac].obo06
                     NEXT FIELD obo06 
                  END IF
                  IF g_obo[l_ac].obo05 = g_obo[l_ac].obo06 THEN
                     CALL cl_err(g_obo[l_ac].obo06,'atm-811',0)
                     LET g_obo[l_ac].obo06=g_obo_t.obo06
                     DISPLAY BY NAME g_obo[l_ac].obo06
                     NEXT FIELD obo06
                  END IF
 
                  IF g_obo_t.obo06 IS NOT NULL AND
                     g_obo_t.obo06 <> g_obo[l_ac].obo06 THEN
                     IF NOT cl_confirm('axd-054') THEN
                        LET g_obo[l_ac].obo06 = g_obo_t.obo06
                        NEXT FIELD obo06
                     END IF
                  END IF
 
                  IF g_azw.azw04<>'2' THEN                                     #No.FUN-870100
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
                  END IF                                                           #No.FUN-870100
               END IF                                                           #No.FUN-870100 
               IF g_azw.azw04<>'2' THEN                                          #No.FUN-870100
                  SELECT oac02 INTO g_obo[l_ac].oac02c FROM oac_file
                  WHERE oac01=g_obo[l_ac].obo06
               ELSE
                  SELECT azp02 INTO g_obo[l_ac].oac02c FROM azp_file
                   WHERE azp01=g_obo[l_ac].obo06 
               END IF
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
                       CALL cl_err3("del","obo_file",g_obo_t.obo02,"",
                                     SQLCA.sqlcode,"","",1)  #No.FUN-660104
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
                        CALL cl_err3("del","obo_file",g_obo_t.obo02,"",
                                      SQLCA.sqlcode,"","",1)  #No.FUN-660104
                        LET l_exit_sw = "n"
                        LET l_ac_t = l_ac
                        EXIT INPUT
                    ELSE
                        LET g_rec_b=g_rec_b-l_n1-1
                    END IF
                END IF
                DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
                CALL i172_show()
            END IF
            COMMIT WORK
 
    ON ROW CHANGE
        DISPLAY "ON ROW CHANGE"
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_obo[l_ac].* = g_obo_t.*
               CLOSE i172_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_obo[l_ac].obo02,-263,1)
               LET g_obo[l_ac].* = g_obo_t.*
            ELSE
               UPDATE obo_file SET(obo02,obo03,obo04,obo05,obo06,obo07)
                                 =(g_obo[l_ac].obo02,g_obo[l_ac].obo03,
                                   g_obo[l_ac].obo04,g_obo[l_ac].obo05,
                                   g_obo[l_ac].obo06,g_obo[l_ac].obo07)
                WHERE CURRENT OF i172_bcl
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","obo_file",g_obo[l_ac].obo02,"",
                                SQLCA.sqlcode,"","",1)  #No.FUN-660104
                  LET g_obo[l_ac].* = g_obo_t.*
               ELSE
                  LET g_obo_t.* = g_obo[l_ac].*
                  DELETE FROM obo_file WHERE obo01 = g_obn.obn01
                     AND obo02 > g_obo[l_ac].obo02
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("del","obo_file",g_obn.obn01,"",
                                   SQLCA.sqlcode,"","",1)  #No.FUN-660104
                     EXIT INPUT
                  END IF
                  CLEAR FORM
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
                  CALL i172_show()
                  EXIT INPUT
               END IF
            END IF
 
    AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac  #FUN-D30033 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_obo[l_ac].* = g_obo_t.*
               #FUN-D30033--add--begin--
               ELSE
                  CALL g_obo.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30033--add--end----
               END IF
               CLOSE i172_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac   #FUN-D30033 add
            CLOSE i172_bcl
            COMMIT WORK
 
         ON ACTION CONTROLP
            CASE
                WHEN INFIELD(obo05)                                             #No.FUN-870100
                     CALL cl_init_qry_var()                                     #No.FUN-870100
                     IF g_azw.azw04<>'2' THEN                                    #No.FUN-870100
                        LET g_qryparam.form="q_oac"
                     ELSE                                                       #No.FUN-870100
                        LET g_qryparam.form="q_azp"                           #No.FUN-870100
                     END IF                                                     #No.FUN-870100
                     CALL cl_create_qry() RETURNING g_obo[l_ac].obo05           #No.FUN-870100
                     NEXT FIELD obo05                                           #No.FUN-870100
                WHEN INFIELD(obo06)
                     CALL cl_init_qry_var()
                     IF g_azw.azw04<>'2' THEN                                    #No.FUN-870100
                        LET g_qryparam.form="q_oac"
                     ELSE                                                       #No.FUN-870100
                        LET g_qryparam.form="q_azp"                           #No.FUN-870100
                     END IF                                                     #No.FUN-870100
                     CALL cl_create_qry() RETURNING g_obo[l_ac].obo06
                     NEXT FIELD obo06
                OTHERWISE
                     EXIT CASE
            END CASE
 
        ON ACTION CONTROLN
            CALL i172_b_askkey()
            EXIT INPUT
 
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
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
        END INPUT
 
 
     LET g_obn.obnmodu = g_user
     LET g_obn.obndate = g_today
     UPDATE obn_file SET obnmodu = g_obn.obnmodu,obndate = g_obn.obndate
      WHERE obn01 = g_obn.obn01  # AND obnpalnt=g_plant  #No.FUN-870100
     IF SQLCA.SQLCODE OR STATUS = 100 THEN
        CALL cl_err3("upd","obn_file",g_obn.obn01,"",
                      SQLCA.sqlcode,"","upd obn",1)  #No.FUN-660104
     END IF
     DISPLAY BY NAME g_obn.obnmodu,g_obn.obndate
 
    CLOSE i172_bcl
    COMMIT WORK
#   CALL i172_delall()                              #No.FUN-870100 #CHI-C30002 mark
    CALL i172_delHeader()     #CHI-C30002 add
    CALL i172_show()                                #No.FUN-870100
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION i172_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM obn_file WHERE obn01 = g_obn.obn01
         INITIALIZE g_obn.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION i172_delall()
#  SELECT COUNT(*) INTO g_cnt FROM obo_file
#   WHERE obo01 = g_obn.obn01
#
#  IF g_cnt = 0 THEN                  
#     CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#     ERROR g_msg CLIPPED
#     DELETE FROM obn_file WHERE obn01 = g_obn.obn01   #AND obnplant = g_obn.obnplant
#  END IF
#
#END FUNCTION
#CHI-C30002 -------- mark -------- end
FUNCTION i172_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
 
    CLEAR gen02                           #清除FORMONLY欄位
 CONSTRUCT l_wc2 ON obo02,obo03,obo04,obo05,obo06,obo07
            FROM s_obo[1].obo02,s_obo[1].obo03,s_obo[1].obo04,
                 s_obo[1].obo05,s_obo[1].obo06,s_obo[1].obo07
         ON ACTION CONTROLP
            CASE
                WHEN INFIELD(obo05)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state="c"
                     IF g_azw.azw04='2' THEN 
                        LET g_qryparam.form="q_obo05"
                     ELSE
                        LET g_qryparam.form="q_oac"
                     END IF
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO s_obo[1].obo05
                     NEXT FIELD obo05
                WHEN INFIELD(obo06)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state="c"
                     IF g_azw.azw04='2' THEN                                                                                        
                        LET g_qryparam.form="q_obo06"                                                                             
                     ELSE                                                                                                           
                        LET g_qryparam.form="q_oac"                                                                                 
                     END IF                                                                                                         
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
    CALL i172_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i172_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
 
    LET g_sql =
        "SELECT obo02,obo03,'',obo04,obo05,'',obo06,'',obo07,''",
        "  FROM obo_file ",
        " WHERE obo01 ='",g_obn.obn01,"'"
    IF NOT cl_null(p_wc2) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED 
    END IF 
    LET g_sql=g_sql CLIPPED," ORDER BY obo02 " 
    DISPLAY g_sql
 
    PREPARE i172_pb FROM g_sql
    DECLARE obo_curs                       #SCROLL CURSOR
        CURSOR FOR i172_pb
 
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
#TQC-A90056 --modify
 #        WHEN '1'  LET g_obo[g_cnt].desc=g_msg[1,4]
 #        WHEN '2'  LET g_obo[g_cnt].desc=g_msg[5,8]
 #        WHEN '3'  LET g_obo[g_cnt].desc=g_msg[9,12]
          WHEN '1'  LET g_obo[g_cnt].desc=g_msg[1,6]
          WHEN '2'  LET g_obo[g_cnt].desc=g_msg[7,12]
          WHEN '3'  LET g_obo[g_cnt].desc=g_msg[13,18]
#TQC-A90056 --end
        END CASE
        IF g_azw.azw04<>'2' THEN                                         #No.FUN-870100
           SELECT oac02 INTO g_obo[g_cnt].oac02b FROM oac_file
            WHERE oac01=g_obo[g_cnt].obo05
           SELECT oac02 INTO g_obo[g_cnt].oac02c FROM oac_file
            WHERE oac01=g_obo[g_cnt].obo06
        ELSE                                                            #No.FUN-870100
           SELECT azp02 INTO g_obo[g_cnt].oac02b FROM azp_file          #No.FUN-870100
            WHERE azp01=g_obo[g_cnt].obo05                              #No.FUN-870100
           SELECT azp02 INTO g_obo[g_cnt].oac02c FROM azp_file          #No.FUN-870100
            WHERE azp01=g_obo[g_cnt].obo06                              #No.FUN-870100
        END IF                                                          #No.FUN-870100
 
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
 
FUNCTION i172_bp(p_ud)
DEFINE
    p_ud            LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
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
      ON ACTION first
         CALL i172_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION previous
         CALL i172_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION jump
         CALL i172_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION next
         CALL i172_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION last
         CALL i172_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
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
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
 
      ON ACTION CONTROLS                                                                                                          
         CALL cl_set_head_visible("","AUTO")                                                                                      
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
 
      ON ACTION related_document                #No.FUN-6B0043  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
 
FUNCTION i172_copy()
DEFINE
    l_obn		RECORD LIKE obn_file.*,
    l_oldno,l_newno	LIKE obn_file.obn01
 
    IF s_shut(0) THEN RETURN END IF
    IF g_obn.obn01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    LET g_before_input_done = FALSE
    CALL i172_set_entry('a')
    LET g_before_input_done = TRUE 
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
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
        DISPLAY BY NAME g_obn.obn01 #ATTRIBUTE(YELLOW)   #TQC-8C0076
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
    LET l_obn.obnoriu = g_user      #No.FUN-980030 10/01/04
    LET l_obn.obnorig = g_grup      #No.FUN-980030 10/01/04
    INSERT INTO obn_file VALUES (l_obn.*)
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","obn_file",l_obn.obn01,"",
                      SQLCA.sqlcode,"","obn",1)  #No.FUN-660104
        RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM obo_file         #單身復制
        WHERE obo01=g_obn.obn01  # AND oboplant = g_obn.obnplant      #FUN-870100
        INTO TEMP x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","x",g_obn.obn01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
        RETURN
    END IF
    UPDATE x
        SET   obo01=l_newno
    INSERT INTO obo_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","obo_file",g_obn.obn01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
        ROLLBACK WORK
        RETURN
    END IF
    COMMIT WORK
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
        ATTRIBUTE(REVERSE)
     LET l_oldno = g_obn.obn01
     SELECT obn_file.* INTO g_obn.* FROM obn_file WHERE obn01 = l_newno #AND obnplant = g_obn.obnplant      #FUN-870100
     CALL i172_u()
     CALL i172_b()
     #SELECT obn_file.* INTO g_obn.* FROM obn_file WHERE obn01 = l_oldno  #AND obnplant = g_obn.obnplant      #FUN-870100 #FUN-C80046
     #CALL i172_show()  #FUN-C80046
END FUNCTION
 
FUNCTION i172_out()
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680120 SMALLINT
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
        l_name      LIKE type_file.chr20            #No.FUN-680120 VARCHAR(20)              #External(Disk) file name
 DEFINE l_desc1     LIKE apo_file.apo02             #No.FUN-760083
    IF cl_null(g_wc) AND NOT cl_null(g_obn.obn01) THEN
       LET g_wc = " obn01 = '",g_obn.obn01,"'"
    END IF
    IF cl_null(g_wc2) THEN LET g_wc2 = "1=1"
    END IF
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang #No.TQC-5B0212
    LET g_sql="SELECT obn01,obo02,obo03,obo04,obo05,'',obo06,'',obo07 ",
          " FROM obn_file LEFT OUTER JOIN obo_file ON obn01=obo01 ",
          " WHERE ",g_wc CLIPPED,   #TQC-9A0159
          " AND ",g_wc2 CLIPPED
 
    PREPARE i172_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i172_co                         # SCROLL CURSOR
         CURSOR FOR i172_p1
 
    #START REPORT i172_rep TO l_name                        #No.FUN-760083
    CALL cl_del_data(g_table)                               #No.FUN-760083
    LET g_str=''                                            #No.FUN-760083
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog  #No.FUN-760083
    FOREACH i172_co INTO sr.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        IF cl_null(sr.obo07) THEN LET sr.obo07 = 0 END IF
        SELECT oac02 INTO sr.oac02b FROM oac_file WHERE oac01=sr.obo05
        SELECT oac02 INTO sr.oac02c FROM oac_file WHERE oac01=sr.obo06
        #OUTPUT TO REPORT i172_rep(sr.*)                    #No.FUN-760083
        CASE sr.obo03                                                                                                           
                 WHEN '1' CALL cl_getmsg('axd-105',g_lang) RETURNING l_desc1                                                        
                 WHEN '2' CALL cl_getmsg('axd-106',g_lang) RETURNING l_desc1                                                        
                 WHEN '3' CALL cl_getmsg('axd-107',g_lang) RETURNING l_desc1                                                        
        END CASE                     
        EXECUTE insert_prep USING  sr.obn01,sr.obo02,sr.obo03,sr.obo04,sr.obo05,sr.oac02b,   #No.FUN-760083
                                   sr.obo06,sr.oac02c,sr.obo07,l_desc1                       #No.FUN-760083
 
    END FOREACH
 
    #FINISH REPORT i172_rep                         #No.FUN-760083
 
    CLOSE i172_co
    ERROR ""
    LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,g_table CLIPPED  #No.FUN-760083
    IF g_zz05='Y' THEN                                              #No.FUN-760083
       CALL cl_wcchp(g_wc,'obn01,obn02,obn04,obn05,                 #No.FUN-760083                                                                               
                        obnuser,obngrup,obnmodu,obndate,obnacti')   #No.FUN-760083
       RETURNING   g_wc                                             #No.FUN-760083
    END IF                                                          #No.FUN-760083
    LET g_str=g_wc                                                  #No.FUN-760083
    CALL cl_prt_cs3("atmi172","atmi172",g_sql,g_str)                #No.FUN-760083
END FUNCTION
 
 
FUNCTION i172_set_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   IF INFIELD(obo03) OR (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("obo06",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i172_set_no_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
   IF INFIELD(obo03) OR (NOT g_before_input_done) THEN
        IF g_obo[l_ac].obo03 <> '1' THEN
            CALL cl_set_comp_entry("obo06",FALSE)
        END IF
   END IF
END FUNCTION
 
FUNCTION i172_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("obn01",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i172_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       IF p_cmd = 'u' AND g_chkey = 'N' THEN
           CALL cl_set_comp_entry("obn01",FALSE)
       END IF
   END IF
 
END FUNCTION
# No.FUN-9C0073  ----------------By chenls  程序精簡

