# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aooi402.4gl
# Descriptions...: 編碼類別資料維護作業
# Date & Author..: 03/06/25 By Carrier
# Date & Modify..: 03/10/08 By Carrier
# Modi...........: No.A086 03/11/26 By ching append
# Modify.........: No.MOD-470515 04/10/06 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4B0020 04/11/03 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-4C0044 04/12/07 By pengu Data and Group權限控管
# Modify.........: No.FUN-510027 05/01/14 By pengu 報表轉XML
# Modify.........: No.MOD-530002 05/03/22 By ching 單身刪除refresh單頭
# Modify.........: No.FUN-5B0136 05/12/02 By Sarah 修改單身後單頭的資料更改者,最近修改日應update
# Modify.........: No.TQC-5C0077 05/12/16 By Claire 單身修改長度refresh單頭長度
# Modify.........: No.TQC-5C0118 05/12/26 By Claire 每個類別只能有一段流水號
# Modify.........: No.FUN-660131 06/06/19 By Cheunl cl_err --> cl_err3
# Modify.........: No.FUN-680102 06/08/28 By zdyllq 類型轉換 
# Modify.........: No.FUN-6A0015 06/10/25 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.FUN-6A0081 06/11/01 By atsea l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/13 By bnlent  單頭折疊功能修改
# Modify.........: No.MOD-6B0090 06/11/17 By Claire aoo-122訊息有誤
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-750041 07/05/15 By Lynn 打印無效資料，報表未體現出
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-780056 07/07/11 By mike 報表格式修改為p_query
# Modify.........: No.TQC-7B0133 07/11/26 By Smapmin 型態為流水號時,說明應不可輸入
# Modify.........: No.FUN-810036 08/01/16 By Nicola 序號管理
# Modify.........: No.MOD-840240 08/04/20 By Nicola 型態設"月"時，會出現長度不合的錯誤訊息
# Modify.........: No.MOD-840294 08/04/21 By Nicola 批/序號不可選擇獨立段編碼
# Modify.........: No.FUN-850100 08/05/19 By Nicola 批/序號管理第二階段
# Modify.........: No.MOD-870057 08/07/04 By Nicola 獨立段開窗修改
# Modify.........: No.MOD-870065 08/07/07 By Nicola AFTER FIELD 獨立段修改
# Modify.........: No.MOD-870304 08/07/29 BY chenl  修正gel05欄位即說明欄位查詢開窗蕩出的問題。
# Modify.........: No.TQC-890004 08/09/02 BY claire gaj_file應改為gej_file
# Modify.........: No.FUN-8B0123 08/12/01 By hongmei 修改單身顯示問題
# Modify.........: No.TQC-930109 09/03/18 By Sunyanchun 新錄一筆數據后，“狀態”頁簽中的“資料更改者”欄位不應該有值
# Modify.........: No.TQC-930126 09/03/18 By Sunyanchun 點擊“查詢”功能鈕，單頭“編碼類型”欄位需要開窗查詢
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9C0016 09/12/19 By liuxqa 以下项次加一，执行后并未马上显示结果。
# Modify.........: No:FUN-9C0071 10/01/13 By huangrh 精簡程式
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-AB0041 10/12/14 By lixh1  CONSTRUCT時開放geioriu,geiorig欄位
# Modify.........: No.FUN-B50063 11/05/26 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D10021 13/01/07 By dongsz 編碼性質為C時，gel04可以選4：欄位值
# Modify.........: No.DEV-D30026 13/03/15 By Nina GP5.3 追版:DEV-CA0008、DEV-D10003、DEV-D10004為GP5.25 的單號
# Modify.........: No:FUN-D40030 13/04/08 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE g_gei           RECORD LIKE gei_file.*,
       g_gei_t         RECORD LIKE gei_file.*,
       g_gei_o         RECORD LIKE gei_file.*,
       g_gei01_t       LIKE gei_file.gei01,
       g_gel           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
           gel02       LIKE gel_file.gel02,
           gel06       LIKE gel_file.gel06,
           gel03       LIKE gel_file.gel03,
           gel04       LIKE gel_file.gel04,
           gel05       LIKE gel_file.gel05,
           gel07       LIKE gel_file.gel07
                       END RECORD,
       g_gel_t         RECORD                 #程式變數 (舊值)
           gel02       LIKE gel_file.gel02,
           gel06       LIKE gel_file.gel06,
           gel03       LIKE gel_file.gel03,
           gel04       LIKE gel_file.gel04,
           gel05       LIKE gel_file.gel05,
           gel07       LIKE gel_file.gel07
                       END RECORD,
       g_wc,g_wc2,g_sql    STRING,  #No.FUN-580092 HCN     
       l_za05          LIKE za_file.za05,
       g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680102 SMALLINT
       l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680102 SMALLINT
DEFINE g_before_input_done   LIKE type_file.num5          #No.FUN-680102 SMALLINT
 
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL   
DEFINE g_chr        LIKE gei_file.geiacti        #No.FUN-680102 VARCHAR(1)
DEFINE g_cnt        LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE g_i          LIKE type_file.num5      #count/index for any purpose        #No.FUN-680102 SMALLINT
DEFINE g_msg        LIKE ze_file.ze03        #No.FUN-680102CHAR(72)
 
# 2004/02/06 by Hiko : 為了上下筆資料的控制而加的變數.
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680102 INTEGER
# 2004/02/20 by saki : Delete 後能夠跳至上下筆
DEFINE   g_jump         LIKE type_file.num10,         #No.FUN-680102 INTEGER
         mi_no_ask       LIKE type_file.num5          #No.FUN-680102 SMALLINT
 
MAIN
   DEFINE p_row,p_col LIKE type_file.num5          #No.FUN-680102 SMALLINT
 
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP,
   FIELD ORDER FORM                   #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序) #DEV-D30026--ADD--
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
      RETURNING g_time    #No.FUN-6A0081
 
   LET p_row = 3 LET p_col = 4
 
   OPEN WINDOW i402_w AT p_row,p_col              #顯示畫面
     WITH FORM "aoo/42f/aooi402"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   LET g_forupd_sql = "SELECT * FROM gei_file WHERE gei01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i402_cl CURSOR FROM g_forupd_sql
 
   CALL i402_menu()
 
   CLOSE WINDOW i402_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
      RETURNING g_time    #No.FUN-6A0081
 
END MAIN
 
FUNCTION i402_cs()
   DEFINE lc_qbe_sn LIKE gbm_file.gbm01    #No.FUN-580031  HCN
   DEFINE l_geh04   LIKE geh_file.geh04    #FUN-D10021 add
 
   CLEAR FORM                             #清除畫面
 
   CALL g_gel.clear()
 
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
 
   SELECT geh04 INTO l_geh04 FROM geh_file           #FUN-D10021 add
               WHERE geh01 = g_gei.gei03             #FUN-D10021 add
 
   INITIALIZE g_gei.* TO NULL    #No.FUN-750051
 
   CONSTRUCT BY NAME g_wc ON gei01,gei02,gei03,gei04,gei05,geiuser,geigrup,
                             geioriu,geiorig,                  #TQC-AB0041                         
                             geimodu,geidate,geiacti
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(gei01) 
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gei"
               LET g_qryparam.state = "c" 
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO gei01
            WHEN INFIELD(gei03)       #編碼性質
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_geh"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO gei03
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
 
      ON ACTION qbe_select
         CALL cl_qbe_list() RETURNING lc_qbe_sn
         CALL cl_qbe_display_condition(lc_qbe_sn)
 
   END CONSTRUCT
 
   IF INT_FLAG THEN RETURN END IF
 
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('geiuser', 'geigrup')
 
   CONSTRUCT g_wc2 ON gel02,gel06,gel03,gel04,gel05,gel07  # 螢幕上取單身條件
                 FROM s_gel[1].gel02,s_gel[1].gel06,s_gel[1].gel03,
                      s_gel[1].gel04,s_gel[1].gel05,s_gel[1].gel07
 
      BEFORE CONSTRUCT
         CALL cl_qbe_display_condition(lc_qbe_sn)
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(gel05)
               CALL cl_init_qry_var()
               IF g_gel[1].gel04 = '4' THEN   #NO.MOD-870304
                  LET g_qryparam.form = "q_gaq"
                  LET g_qryparam.arg1 = g_lang
         #        LET g_qryparam.arg2 = 'ima'        #FUN-D10021 mark
                  IF l_geh04 = 'C' THEN              #FUN-D10021 add
                     LET g_qryparam.arg2 = 'rtz01'   #FUN-D10021 add
                  ELSE                               #FUN-D10021 add
                     LET g_qryparam.arg2 = 'ima'     #FUN-D10021 add
                  END IF                             #FUN-D10021 add
               ELSE
                  LET g_qryparam.form = "q_gej"
               END IF 
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO gel05
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
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
 
   END CONSTRUCT
 
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
   IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
      LET g_sql = "SELECT  gei01 FROM gei_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY 1"
   ELSE                              # 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE gei_file. gei01 ",
                  "  FROM gei_file, gel_file ",
                  " WHERE gei01 = gel01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY 1"
   END IF
 
   PREPARE i402_prepare FROM g_sql
   DECLARE i402_cs                         #SCROLL CURSOR
      SCROLL CURSOR WITH HOLD FOR i402_prepare
 
   IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM gei_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT gei01) FROM gei_file,gel_file WHERE ",
                "gel01=gei01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
 
   PREPARE i402_precount FROM g_sql
   DECLARE i402_count CURSOR FOR i402_precount
 
   OPEN i402_count
   FETCH i402_count INTO g_row_count
   CLOSE i402_count
 
END FUNCTION
 
FUNCTION i402_menu()
  DEFINE l_cmd  LIKE type_file.chr1000                  #No.FUN-780056
   WHILE TRUE
      CALL i402_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i402_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i402_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
              #DEV-D30026 add str-----------
               LET g_success = 'Y'
               CALL i402_del_chk()
               IF g_success = 'Y' THEN
              #DEV-D30026 add end-----------
                  CALL i402_r()
              #DEV-D30026 add str-----------
               ELSE
                  CALL cl_err('','aba-131',1)
               END IF
              #DEV-D30026 add end-----------
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i402_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
              #DEV-D30026 add str-----------
               LET g_success = 'Y'
               CALL i402_del_chk()
               IF g_success = 'Y' THEN
              #DEV-D30026 add end-----------
                  CALL i402_x()
              #DEV-D30026 add str-----------
               ELSE
                  CALL cl_err('','aba-132',1)
               END IF
              #DEV-D30026 add end-----------
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i402_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i402_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth()
               THEN                                                    #No.FUN-780056
                   IF cl_null(g_wc) THEN LET g_wc='1=1' END IF         #No.FUN-780056
                   LET l_cmd = 'p_query "aooi402" "',g_wc CLIPPED,'"'  #No.FUN-780056
                   CALL cl_cmdrun(l_cmd)                               #No.FUN-780056
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_gei.gei01 IS NOT NULL THEN
                  LET g_doc.column1 = "gei01"
                  LET g_doc.value1 = g_gei.gei01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gel),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i402_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_gel.clear()
    INITIALIZE g_gei.* LIKE gei_file.*             #DEFAULT 設定
    LET g_gei01_t = NULL
    #預設值及將數值類變數清成零
    LET g_gei_o.* = g_gei.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_gei.gei04  = 0
        LET g_gei.gei05  = 0
        LET g_gei.geiuser=g_user
        LET g_gei.geioriu = g_user #FUN-980030
        LET g_gei.geiorig = g_grup #FUN-980030
        LET g_gei.geigrup=g_grup
        LET g_gei.geidate=g_today
        LET g_gei.geiacti='Y'              #資料有效
        #DEV-D30026---ADD----STR----
        IF cl_confirm('aoo1007') THEN
           LET g_gei.gei08='Y'
        ELSE
           LET g_gei.gei08='N'
        END IF
        DISPLAY g_gei.gei08 TO gei08
        #DEV-D30026----ADD-----END----
        CALL i402_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            INITIALIZE g_gei.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_gei.gei01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO gei_file VALUES (g_gei.*)
        IF SQLCA.sqlcode THEN                     #置入資料庫不成功
            CALL cl_err3("ins","gei_file",g_gei.gei01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
            CONTINUE WHILE
        END IF
        SELECT gei01 INTO g_gei.gei01 FROM gei_file
         WHERE gei01 = g_gei.gei01
        LET g_gei01_t = g_gei.gei01        #保留舊值
        LET g_gei_t.* = g_gei.*
 
        CALL g_gel.clear()
        LET g_rec_b = 0
        IF g_gei.gei08='Y' THEN            #DEV-D30026----ADD--
           CALL i402_ins_b()               #DEV-D30026----ADD--
           CALL i402_b_fill(" 1=1")        #DEV-D30026----ADD--
        END IF                             #DEV-D30026----ADD--
        CALL i402_b()                   #輸入單身
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION i402_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_gei.gei01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_gei.* FROM gei_file WHERE gei01=g_gei.gei01
    IF g_gei.geiacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_gei.gei01,9027,0)
       RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_gei01_t = g_gei.gei01
    LET g_gei_o.* = g_gei.*
    BEGIN WORK
 
    OPEN i402_cl USING g_gei.gei01
    IF STATUS THEN
       CALL cl_err("OPEN i402_cl:", STATUS, 1)
       CLOSE i402_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i402_cl INTO g_gei.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_gei.gei01,SQLCA.sqlcode,1)      # 資料被他人LOCK
        CLOSE i402_cl ROLLBACK WORK RETURN
    END IF
    CALL i402_show()
    WHILE TRUE
        LET g_gei01_t = g_gei.gei01
        LET g_gei.geimodu=g_user
        LET g_gei.geidate=g_today
        CALL i402_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_gei.*=g_gei_t.*
            CALL i402_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_gei.gei01 != g_gei01_t THEN            # 更改單號
            UPDATE gel_file SET gel01 = g_gei.gei01
                WHERE gel01 = g_gei01_t
            IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","gel_file",g_gei01_t,"",SQLCA.sqlcode,"","gel",1)  #No.FUN-660131
                CONTINUE WHILE
            END IF
        END IF
        UPDATE gei_file SET gei_file.* = g_gei.*
            WHERE gei01 = g_gei.gei01
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","gei_file",g_gei.gei01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i402_cl
    COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION i402_i(p_cmd)
   DEFINE   l_flag   LIKE type_file.chr1,                 #判斷必要欄位是否有輸入        #No.FUN-680102 VARCHAR(1)
            p_cmd    LIKE type_file.chr1,                 #a:輸入 u:更改        #No.FUN-680102 VARCHAR(1)
            l_cnt    LIKE type_file.num5          #No.FUN-680102 SMALLINT
#DEV-D30026----ADD-----STR-----
   DEFINE   l_gel         RECORD
            gel02       LIKE gel_file.gel02,
            gel06       LIKE gel_file.gel06,
            gel03       LIKE gel_file.gel03,
            gel04       LIKE gel_file.gel04,
            gel05       LIKE gel_file.gel05,
            gel07       LIKE gel_file.gel07
                       END RECORD,
            l_sma119    LIKE sma_file.sma119,
            l_geh04     LIKE geh_file.geh04
   DEFINE   l_gei04     LIKE gei_file.gei04
   DEFINE   l_gei05     LIKE gei_file.gei05
#DEV-D30026----ADD-----END------
 

   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
 
   INPUT BY NAME g_gei.gei01,g_gei.gei02,g_gei.gei03,g_gei.gei04,g_gei.gei05, g_gei.geioriu,g_gei.geiorig,
                 g_gei.geiuser,g_gei.geigrup,g_gei.geimodu,g_gei.geidate,
                 g_gei.geiacti
      WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i402_set_entry(p_cmd)
         CALL i402_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER FIELD gei01                  #獨立段編號
         IF NOT cl_null(g_gei.gei01) THEN
            IF g_gei.gei01 != g_gei01_t OR cl_null(g_gei01_t) THEN
               SELECT COUNT(*) INTO g_cnt FROM gei_file
                WHERE gei01 = g_gei.gei01
               IF g_cnt > 0 THEN   #資料重複
                  CALL cl_err(g_gei.gei01,-239,0)
                  LET g_gei.gei01 = g_gei01_t
                  DISPLAY BY NAME g_gei.gei01
                  NEXT FIELD gei01
               END IF
            END IF
         END IF

      #DEV-D30026----ADD-----STR----
      BEFORE FIELD gei03
         IF p_cmd = 'u' THEN
            CALL cl_set_comp_entry("gei03",g_gei.gei08='N')
         ELSE
            CALL cl_set_comp_entry("gei03",TRUE)
         END IF
      #DEV-D30026----ADD-----END----
 
      AFTER FIELD gei03
         IF NOT cl_null(g_gei.gei03) THEN
            IF p_cmd = 'a' OR (p_cmd = 'u' AND g_gei.gei03 != g_gei_t.gei03) THEN
               SELECT COUNT(*) INTO l_cnt FROM geh_file
                WHERE geh01 = g_gei.gei03 AND gehacti = 'Y'
               IF l_cnt = 0 THEN
                  CALL cl_err(g_gei.gei03,'aoo-131',0)
                  NEXT FIELD gei03
               END IF
            END IF
            #DEV-D30026----ADD-----STR-----
            IF g_gei.gei08='Y' THEN
               SELECT count(*) INTO l_cnt FROM geh_file
                WHERE geh01= g_gei.gei03
                  AND geh04 IN ('F','G','H','5','6')
               IF l_cnt<=0 THEN
                  CALL cl_err(g_gei.gei03,'aoo1008',0)
                  NEXT FIELD gei03
               END IF
            END IF
            CALL i402_gei03()
            #DEV-D30026-----ADD-----END-----
         END IF
 
      AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
         LET g_gei.geiuser = s_get_data_owner("gei_file") #FUN-C10039
         LET g_gei.geigrup = s_get_data_group("gei_file") #FUN-C10039
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
 
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
      ON ACTION controlp
           CASE
              WHEN INFIELD(gei03)       #編碼性質
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_geh"
                 LET g_qryparam.default1 = g_gei.gei03
                 #DEV-D30026----ADD----STR----
                 IF g_gei.gei08 = 'Y' THEN
                    LET g_qryparam.where = " geh04 in ('F','G','H','5','6')"
                 END IF
                 #DEV-D30026----ADD----END---
                 CALL cl_create_qry() RETURNING g_gei.gei03
                 DISPLAY g_gei.gei03 TO gei03
                 NEXT FIELD gei03
                 CALL i402_gei03() #DEV-D30026----ADD----
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

#DEV-D30026-----ADD-----STR---
FUNCTION i402_gei03()
DEFINE l_geh04  LIKE geh_file.geh04
   SELECT geh04 INTO l_geh04 FROM geh_file
    WHERE geh01 = g_gei.gei03
   DISPLAY l_geh04 TO geh04
END FUNCTION
#DEV-D30026-----ADD-----END---
 
FUNCTION i402_set_entry(p_cmd)
   DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
      IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("gei01",TRUE)
         CALL cl_set_comp_entry("gei08",TRUE)    #DEV-D30026----ADD---
      END IF
 
END FUNCTION
 
FUNCTION i402_set_no_entry(p_cmd)
   DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
      IF p_cmd = 'u' AND g_chkey = 'N' AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("gei01",FALSE)
         CALL cl_set_comp_entry("gei08",FALSE)    #DEV-D30026----ADD---
      END IF
 
END FUNCTION
 
FUNCTION i402_set_entry_b()
 
   CALL cl_set_comp_entry("gel05",TRUE)
 
END FUNCTION
 
FUNCTION i402_set_no_entry_b()
 
   IF g_gel[l_ac].gel04 MATCHES '[36789ABC]' THEN  #No.FUN-810036 #DEV-D30026----ADD DEF
      CALL cl_set_comp_entry("gel05",FALSE)
   END IF
 
   IF g_gel[l_ac].gel04 MATCHES '[6789]' THEN
      CALL cl_set_comp_entry("gel05",FALSE)
   END IF
 
END FUNCTION
 
FUNCTION i402_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_gei.* TO NULL              #No.FUN-6A0015
 
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_gel.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i402_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN i402_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_gei.* TO NULL
    ELSE
        OPEN i402_count
        FETCH i402_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i402_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
#處理資料的讀取
FUNCTION i402_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680102 VARCHAR(1)
    ls_jump         LIKE ze_file.ze03
 
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i402_cs INTO g_gei.gei01
        WHEN 'P' FETCH PREVIOUS i402_cs INTO g_gei.gei01
        WHEN 'F' FETCH FIRST    i402_cs INTO g_gei.gei01
        WHEN 'L' FETCH LAST     i402_cs INTO g_gei.gei01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED || ': ' FOR g_jump
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
            FETCH ABSOLUTE g_jump i402_cs INTO g_gei.gei01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_gei.gei01,SQLCA.sqlcode,0)
        INITIALIZE g_gei.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
    END IF
 
    SELECT * INTO g_gei.* FROM gei_file WHERE gei01 = g_gei.gei01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","gei_file",g_gei.gei01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
        INITIALIZE g_gei.* TO NULL
        RETURN
    ELSE                                    #FUN-4C0044權限控管
       LET g_data_owner=g_gei.geiuser
       LET g_data_group=g_gei.geigrup
    END IF
 
    CALL i402_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i402_show()
    DEFINE l_cnt      LIKE type_file.num5          #No.FUN-680102 SMALLINT
    LET g_gei_t.* = g_gei.*                      #保存單頭舊值
    DISPLAY BY NAME g_gei.gei01,g_gei.gei02,g_gei.gei03,g_gei.gei04,g_gei.gei05, g_gei.geioriu,g_gei.geiorig,
                    g_gei.geiuser,g_gei.geigrup,g_gei.geimodu,g_gei.geidate,g_gei.geiacti,g_gei.gei08 #DEV-D30026-ADD-gei08
    CALL i402_gei03() #DEV-D30026----ADD--
    CALL i402_b_fill(g_wc2)                 #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i402_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_gei.gei01 IS NULL THEN
       CALL cl_err("",-400,0)
       RETURN
    END IF
    BEGIN WORK
 
    OPEN i402_cl USING g_gei.gei01
    IF STATUS THEN
       CALL cl_err("OPEN i402_cl:", STATUS, 1)
       CLOSE i402_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i402_cl INTO g_gei.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_gei.gei01,SQLCA.sqlcode,0)          #資料被他人LOCK
        CLOSE i402_cl ROLLBACK WORK RETURN
    END IF
    CALL i402_show()
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "gei01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_gei.gei01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
         DELETE FROM gei_file WHERE gei01 = g_gei.gei01
         DELETE FROM gel_file WHERE gel01 = g_gei.gei01
         INITIALIZE g_gei.* TO NULL
         CLEAR FORM
         CALL g_gel.clear()
         OPEN i402_count
         #FUN-B50063-add-start--
         IF STATUS THEN
            CLOSE i402_cs
            CLOSE i402_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end-- 
         FETCH i402_count INTO g_row_count
         #FUN-B50063-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i402_cs
            CLOSE i402_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i402_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i402_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL i402_fetch('/')
         END IF
    END IF
    CLOSE i402_cl
    COMMIT WORK
END FUNCTION
 
#   Change to nonactivity
FUNCTION i402_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_gei.gei01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i402_cl USING g_gei.gei01
    IF STATUS THEN
       CALL cl_err("OPEN i402_cl:", STATUS, 1)
       CLOSE i402_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i402_cl INTO g_gei.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_gei.gei01,SQLCA.sqlcode,0)          #資料被他人LOCK
        CLOSE i402_cl ROLLBACK WORK RETURN
    END IF
    CALL i402_show()
    IF cl_exp(0,0,g_gei.geiacti) THEN                   #確認一下
        LET g_chr=g_gei.geiacti
        IF g_gei.geiacti='Y' THEN
            LET g_gei.geiacti='N'
        ELSE
            LET g_gei.geiacti='Y'
        END IF
        UPDATE gei_file                    #更改有效碼
            SET geiacti=g_gei.geiacti
            WHERE gei01=g_gei.gei01
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","gei_file",g_gei.gei01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
            LET g_gei.geiacti=g_chr
        END IF
        DISPLAY BY NAME g_gei.geiacti
    END IF
    CLOSE i402_cl
    COMMIT WORK
END FUNCTION
 
#單身
FUNCTION i402_b()
   DEFINE l_ac_t          LIKE type_file.num5,                 #未取消的ARRAY CNT        #No.FUN-680102 SMALLINT
          l_n             LIKE type_file.num5,                 #檢查重複用        #No.FUN-680102 SMALLINT
          g_n             LIKE type_file.num5,                 #No.FUN-680102 SMALLINT,             #檢查流水段筆數 #TQC-5C0118
          l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680102 VARCHAR(1)
          l_i,l_cnt       LIKE type_file.num5,                 #No.FUN-680102 SMALLINT
          p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680102 VARCHAR(1)
          l_gej03         LIKE gej_file.gej03,
          l_allow_insert  LIKE type_file.chr1,           #No.FUN-680102  VARCHAR(1),            #可新增否
          l_allow_delete  LIKE type_file.chr1            #No.FUN-680102  VARCHAR(1)            #可刪除否
   DEFINE l_geh04         LIKE geh_file.geh04  #No.FUN-810036
   DEFINE l_gff02         LIKE gff_file.gff02  #No.FUN-810036
#DEV-D30026----ADD--STR------
   DEFINE l_gel04         LIKE gel_file.gel04
   DEFINE l_gel02         LIKE gel_file.gel02
   DEFINE l_gel05         LIKE gel_file.gel05
   DEFINE l_gel           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
           gel02          LIKE gel_file.gel02,
           gel06          LIKE gel_file.gel06,
           gel03          LIKE gel_file.gel03,
           gel04          LIKE gel_file.gel04,
           gel05          LIKE gel_file.gel05,
           gel07          LIKE gel_file.gel07
                          END RECORD
   DEFINE l_cnt1          LIKE type_file.num5
   DEFINE l_cnt2          LIKE type_file.num5
   DEFINE l_sql           STRING
#DEV-D30026----ADD--END-----
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_gei.gei01 IS NULL THEN
       RETURN
    END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    SELECT * INTO g_gei.* FROM gei_file WHERE gei01=g_gei.gei01
    IF g_gei.geiacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_gei.gei01,'aom-000',0)
       RETURN
    END IF
 
    SELECT COUNT(*) INTO l_cnt FROM gef_file
     WHERE gef01 = g_gei.gei01
    IF l_cnt > 0 THEN
       CALL cl_err(g_gei.gei01,'aoo-138',0)
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT gel02,gel06,gel03,gel04,gel05,gel07 FROM gel_file",
                       " WHERE gel01=? AND gel02=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i402_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_gel WITHOUT DEFAULTS FROM s_gel.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
#DEV-D30026-----ADD----STR----
           IF g_gei.gei08='Y' THEN
              CALL cl_set_comp_entry("gel02",FALSE)
           ELSE
              CALL cl_set_comp_entry("gel02",TRUE)
           END IF
#DEV-D30026-----ADD----END---- 

        BEFORE ROW
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           #DEV-D30026----ADD---STR---

           SELECT COUNT(gel01) INTO l_cnt FROM gel_file
            WHERE gel01=g_gei.gei01
           IF l_cnt>=10 THEN
              CALL cl_err('','aoo1013',1)
              RETURN
           END IF
           #DEV-D30026----ADD----END----
           BEGIN WORK
           OPEN i402_cl USING g_gei.gei01
           IF STATUS THEN
              CALL cl_err("OPEN i402_cl:", STATUS, 1)
              CLOSE i402_cl
              ROLLBACK WORK
              RETURN
           END IF
           FETCH i402_cl INTO g_gei.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_gei.gei01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE i402_cl
              ROLLBACK WORK
              RETURN
           END IF
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_gel_t.* = g_gel[l_ac].*  #BACKUP
              OPEN i402_bcl USING g_gei.gei01,g_gel_t.gel02
              IF STATUS THEN
                 CALL cl_err("OPEN i402_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i402_bcl INTO g_gel[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_gel_t.gel02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
              CALL cl_show_fld_cont()     #FUN-550037(smin)
           END IF
           CALL i402_set_entry_b()   #TQC-7B0133
           CALL i402_set_no_entry_b()   #TQC-7B0133
 
        BEFORE INSERT
           LET p_cmd='a'
           LET l_n = ARR_COUNT()
           INITIALIZE g_gel[l_ac].* TO NULL      #900423
           LET g_gel_t.* = g_gel[l_ac].*         #新輸入資料
           LET g_gel[l_ac].gel02 = 0
           LET g_gel[l_ac].gel03 = 0
           LET g_gel[l_ac].gel07 = 'N'
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           NEXT FIELD gel02
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO gel_file(gel01,gel02,gel03,gel04,gel05,gel06,gel07)
                VALUES (g_gei.gei01,g_gel[l_ac].gel02,g_gel[l_ac].gel03,
                        g_gel[l_ac].gel04,g_gel[l_ac].gel05,g_gel[l_ac].gel06,
                        g_gel[l_ac].gel07)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","gel_file",g_gel[l_ac].gel02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
              CALL i402_bu()
           END IF
 
        BEFORE FIELD gel02                        #default 序號
           IF cl_null(g_gel[l_ac].gel02) OR g_gel[l_ac].gel02 = 0 THEN
              SELECT MAX(gel02)+1 INTO g_gel[l_ac].gel02
                FROM gel_file
               WHERE gel01 = g_gei.gei01
              IF cl_null(g_gel[l_ac].gel02) THEN
                 LET g_gel[l_ac].gel02 = 1
              END IF
           END IF
 
        BEFORE FIELD gel06                        #check 序號是否重複
           IF NOT cl_null(g_gel[l_ac].gel02) THEN
              IF g_gel[l_ac].gel02 != g_gel_t.gel02 OR cl_null(g_gel_t.gel02) THEN
                 SELECT COUNT(*) INTO l_n FROM gel_file
                  WHERE gel01 = g_gei.gei01
                    AND gel02 = g_gel[l_ac].gel02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_gel[l_ac].gel02 = g_gel_t.gel02
                    DISPLAY BY NAME g_gel[l_ac].gel02
                    NEXT FIELD gel02
                 END IF
              END IF
           END IF
 
        AFTER FIELD gel03
           IF NOT cl_null(g_gel[l_ac].gel03) THEN
              IF g_gel[l_ac].gel03 <= 0 THEN
                 NEXT FIELD gel03
              END IF
           END IF
 
        AFTER FIELD gel04
           IF NOT cl_null(g_gel[l_ac].gel04) THEN
              IF g_gel[l_ac].gel04 NOT MATCHES '[123456789ABC]' THEN  #No.FUN-810036  #No.FUN-850100 #DEV-D30026--ADD-DEF
                 NEXT FIELD gel04
              END IF
              SELECT geh04 INTO l_geh04 FROM geh_file
               WHERE geh01 = g_gei.gei03
              IF g_gel[l_ac].gel04 MATCHES '[456789]' THEN  #No.FUN-850100
        #        IF l_geh04 NOT MATCHES '[56]' THEN               #FUN-D10021 mark
                 IF NOT (l_geh04 MATCHES '[56]' OR (l_geh04 = 'C' AND g_gel[l_ac].gel04 = '4')) THEN    #FUN-D10021 add
                    CALL cl_err(g_gel[l_ac].gel04,'aic-048',1)
                    NEXT FIELD gel04
                 END IF
                 IF g_gel[l_ac].gel04 = '5' THEN
                    SELECT COUNT(*) INTO l_n FROM gff_file
                     WHERE gff02 = g_gel[l_ac].gel03
                    IF l_n = 0 THEN
                       CALL cl_err(g_gel[l_ac].gel04,'aoo-121',1)
                       NEXT FIELD gel04
                    END IF
                 END IF
                 IF g_gel[l_ac].gel04 MATCHES '[6789]' THEN
                    IF g_gel[l_ac].gel03 <> 2 THEN   #No.MOD-840240 
                       CALL cl_err(g_gel[l_ac].gel05,'aoo-121',0)
                       LET g_gel[l_ac].gel03 = 2
                       DISPLAY BY NAME g_gel[l_ac].gel03
                       NEXT FIELD gel04
                    END IF   #No.MOD-840240
                 END IF
              END IF
              #批/序號編碼不可使用獨立段
              IF g_gel[l_ac].gel04 = '2' THEN
                 IF l_geh04 MATCHES '[56FG]' THEN #DEV-D30026--MODIFY---
                    CALL cl_err(g_gel[l_ac].gel04,'aic-048',1)
                    NEXT FIELD gel04
                 END IF
              END IF
             LET g_n = 0
             IF g_gel[l_ac].gel04 = '3' THEN
                SELECT count(*) INTO g_n FROM gel_file
                 WHERE gel01 = g_gei.gei01
                   AND gel02 != g_gel[l_ac].gel02  #MOD-6B0090
                   AND gel04 = g_gel[l_ac].gel04
                IF g_n > 0 THEN
                   CALL cl_err(g_gel[l_ac].gel05,'aoo-122',0)
                   NEXT FIELD gel04
                END IF
             END IF
           ELSE
              LET g_gel[l_ac].gel05 = ' '
           END IF
           CALL i402_set_entry_b()   #TQC-7B0133
           CALL i402_set_no_entry_b()   #TQC-7B0133
           #DEV-D30026----ADD----STR---
           IF NOT cl_null(g_gel[l_ac].gel04) THEN
              IF g_gei.gei08 = 'Y' THEN
                 IF (g_gel[l_ac].gel04 = 'A' OR g_gel[l_ac].gel04 = 'B' OR g_gel[l_ac].gel04 = 'C') THEN
                    SELECT count(geh01) INTO l_cnt FROM geh_file
                     WHERE geh01=g_gei.gei03
                       AND geh04 IN ('F','G','H','5','6')
                    IF l_cnt<=0 THEN
                       CALL cl_err('','aoo1016',1)
                       NEXT FIELD gel04
                    END IF
#                    CALL cl_set_comp_entry("gel05",FALSE)
#                 ELSE
#                    CALL cl_set_comp_entry("gel05",TRUE)
                 END IF
              ELSE
                 IF (g_gel[l_ac].gel04 = 'A' OR g_gel[l_ac].gel04 = 'B' OR g_gel[l_ac].gel04 = 'C') THEN
                    CALL cl_err('','aoo1016',1)
                    NEXT FIELD gel04
                 END IF
              END IF
           END IF

         #DEV-D30026----ADD----END---
 
        AFTER FIELD gel05
           IF NOT cl_null(g_gel[l_ac].gel05) THEN
              IF g_gel[l_ac].gel04 = '1' THEN    #固定值
                 IF LENGTH(g_gel[l_ac].gel05) != g_gel[l_ac].gel03 THEN
                    CALL cl_err(g_gel[l_ac].gel05,'aoo-120',0)
                    NEXT FIELD gel05
                 END IF
                 IF g_gel[l_ac].gel05 MATCHES '[*%_?]' THEN
                    CALL cl_err('','aoo-111',0)
                    NEXT FIELD gel05
                 END IF
              ELSE                               #獨立段
                 IF g_gel[l_ac].gel04 = '2' THEN  #No.FUN-810036
                    SELECT gej03 INTO l_gej03 FROM gej_file
                     WHERE gej01 = g_gel[l_ac].gel05
                    IF STATUS THEN
                       CALL cl_err3("sel","gej_file",g_gel[l_ac].gel05,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                       NEXT FIELD gel05
                    END IF
                    IF l_gej03 != g_gel[l_ac].gel03 THEN
                       CALL cl_err(g_gel[l_ac].gel05,'aoo-125',0)
                       LET g_gel[l_ac].gel03 = l_gej03
                       DISPLAY BY NAME g_gel[l_ac].gel03
                       NEXT FIELD gel03
                    END IF
                 END IF  #No.FUN-810036
                 IF g_gel[l_ac].gel04 = '2' THEN  #No.FUN-810036
                    SELECT * FROM gej_file          #No.MOD-870065  #TQC-890004
                     WHERE gej01 = g_gel[l_ac].gel05    #No.MOD-870065 #TQC-890004
                    IF STATUS OR STATUS=100 THEN
                       CALL cl_err3("sel","gej_file",g_gel[l_ac].gel05,"",SQLCA.sqlcode,"","",1)
                       NEXT FIELD gel05
                    END IF
                 END IF
                 IF g_gel[l_ac].gel04 = '5' THEN 
                    SELECT COUNT(*) INTO l_gff02 FROM gff_file
                     WHERE gff02 = g_gel[l_ac].gel05
                    IF STATUS THEN
                       CALL cl_err3("sel","gej_file",g_gel[l_ac].gel05,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                       NEXT FIELD gel05
                    END IF
                    IF l_gff02 != g_gel[l_ac].gel03 THEN
                       CALL cl_err(g_gel[l_ac].gel05,'aoo-125',0)
                       LET g_gel[l_ac].gel03 = l_gff02
                       DISPLAY BY NAME g_gel[l_ac].gel03
                       NEXT FIELD gel03
                    END IF
                 END IF
              END IF
           END IF
 
        AFTER FIELD gel07
           IF NOT cl_null(g_gel[l_ac].gel07) THEN
              IF g_gel[l_ac].gel07 NOT MATCHES '[YN]' THEN
                 CALL cl_err('','mfg1002',0)
                 NEXT FIELD gel07
              END IF
           END IF
 
        BEFORE DELETE                            #是否取消單身
#DEV-D30026----ADD----STR---
           IF g_gei.gei08='Y' AND p_cmd!='a' THEN
              SELECT geh04 INTO l_geh04 FROM geh_file
               WHERE geh01=g_gei.gei03
              IF l_ac=1 OR (l_ac=2 AND (l_geh04='F' OR l_geh04='G'))THEN
                 CALL cl_err('','aoo1018',1)
                 CANCEL DELETE
              END IF
           END IF
#DEV-D30026---ADD-----END---
           IF g_gel_t.gel02 > 0 AND g_gel_t.gel02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM gel_file
               WHERE gel01 = g_gei.gei01
                 AND gel02 = g_gel_t.gel02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","gel_file",g_gel_t.gel02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
              MESSAGE "Delete Ok"
              CLOSE i402_bcl
              COMMIT WORK
              CALL i402_bu()  #MOD-530002
           END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_gel[l_ac].* = g_gel_t.*
              CLOSE i402_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
#DEV-D30026----ADD----STR---
           IF g_gei.gei08='Y' AND p_cmd!='a' THEN
              SELECT geh04 INTO l_geh04 FROM geh_file
               WHERE geh01=g_gei.gei03
              IF l_ac=1 OR (l_ac=2 AND (l_geh04='F' OR l_geh04='G'))THEN
                 CALL cl_err('','aoo1019',1)
                 CLOSE i402_bcl
                 ROLLBACK WORK
                 CALL i402_b_fill(" 1=1")
                 EXIT INPUT
              END IF
           END IF
#DEV-D30026---ADD-----END---
 
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_gel[l_ac].gel02,-263,1)
              LET g_gel[l_ac].* = g_gel_t.*
           ELSE
              UPDATE gel_file SET gel02 = g_gel[l_ac].gel02,
                                  gel03 = g_gel[l_ac].gel03,
                                  gel04 = g_gel[l_ac].gel04,
                                  gel05 = g_gel[l_ac].gel05,
                                  gel06 = g_gel[l_ac].gel06,
                                  gel07 = g_gel[l_ac].gel07
               WHERE gel01=g_gei.gei01
                 AND gel02=g_gel_t.gel02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","gel_file",g_gei.gei01,g_gel_t.gel02,SQLCA.sqlcode,"","",1)  #No.FUN-660131
                 LET g_gel[l_ac].* = g_gel_t.*
                 CLOSE i402_bcl
                 ROLLBACK WORK
              ELSE
                 MESSAGE 'UPDATE O.K'
                 CLOSE i402_bcl
                 CALL i402_bu()  #TQC-5C0077
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac  #FUN-D40030
           IF INT_FLAG THEN                 #900423
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_gel[l_ac].* = g_gel_t.*
              #FUN-D40030--add--str--
              ELSE
                 CALL g_gel.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D40030--add--end--
              END IF
              CLOSE i402_bcl
              ROLLBACK WORK
        #DEV-D30026----ADD----STR----
              IF g_gei.gei08='Y' THEN

                 SELECT geh04 INTO l_geh04 FROM geh_file
                  WHERE geh01=g_gei.gei03
                 IF l_geh04 = '5' OR l_geh04='6' OR l_geh04='H' THEN
                 IF l_geh04='5' THEN
                    SELECT max(gel02) INTO l_gel02 FROM gel_file
                    WHERE gel01=g_gei.gei01
                    IF l_gel02<3 THEN
                       SELECT gel04,gel05 INTO l_gel04,l_gel05
                         FROM gel_file
                        WHERE gel01=g_gei.gei01
                          AND gel02=2
                       IF l_gel04='4' AND (l_gel05="ima01" OR l_gel05="sfb01") THEN
                          CALL cl_err('','aoo1012',1)
                          CALL i402_b()
                       END IF
                    END IF
                 END IF
                 IF l_geh04='6' THEN
                    SELECT count(gel01) INTO l_cnt FROM gel_file
                    WHERE gel01=g_gei.gei01
                      AND gel04='3'
                    IF l_cnt<=0 THEN
                       CALL cl_err('','aoo1014',1)
                       CALL i402_b()
                    END IF
                 END IF
                 IF l_geh04='H'  THEN
                    SELECT count(gel01) INTO l_cnt FROM gel_file
                    WHERE gel01=g_gei.gei01
                       AND gel04='A'
                    IF l_cnt<=0 THEN
                       CALL cl_err('','aoo1015',1)
                       CALL i402_b()
#                 RETURN
                    END IF
                 END IF
                 LET l_sql = "SELECT gel02,gel06,gel03,gel04,gel05,gel07 ",
                             "  FROM gel_file ",
                             " WHERE gel01 = '",g_gei.gei01,"' "
                  PREPARE i402_l_sql_pre1 FROM l_sql
                 DECLARE i402_sql_cs1 CURSOR FOR i402_l_sql_pre1
                 LET l_cnt1=1
                 LET l_cnt2=1
                 CALL l_gel.clear()
                 FOREACH i402_sql_cs1 INTO l_gel[l_cnt1].*
                    SELECT COUNT(*) INTO l_cnt FROM gel_file
                     WHERE gel01 != g_gei.gei01
                       AND gel04 = l_gel[l_cnt1].gel04
                       AND gel05 = l_gel[l_cnt1].gel05
                    IF l_cnt>0 THEN
                       LET l_cnt2 = l_cnt2+1
                    END IF
                    LET l_cnt1 = l_cnt1+1
                 END FOREACH

                 IF l_cnt1 = l_cnt2 THEN
                    CALL cl_err('','aoo1017',1)
                    CALL i402_b()
                 END IF
                 ELSE
                    EXIT INPUT
                 END IF
              ELSE
                 EXIT INPUT
              END IF
        #DEV-D30026----ADD----END-----
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac  #FUN-D40030
           CLOSE i402_bcl
           COMMIT WORK
        #DEV-D30026----ADD----STR----
        AFTER INPUT
        IF g_gei.gei08='Y' THEN
           SELECT geh04 INTO l_geh04 FROM geh_file
            WHERE geh01=g_gei.gei03
           IF l_geh04='5' THEN
              SELECT max(gel02) INTO l_gel02 FROM gel_file
               WHERE gel01=g_gei.gei01

              IF l_gel02=2 THEN
                 SELECT gel04,gel05 INTO l_gel04,l_gel05
                   FROM gel_file
                  WHERE gel01=g_gei.gei01
                    AND gel02=2
                 IF l_gel04='4' AND (l_gel05="ima01" OR l_gel05="sfb01") THEN
                    CALL cl_err('','aoo1012',1)
                    CALL i402_b()
                 END IF
              END IF
           END IF
           IF l_geh04='6' THEN
              SELECT count(gel01) INTO l_cnt FROM gel_file
               WHERE gel01=g_gei.gei01
                 AND gel04='3'
              IF l_cnt<=0 THEN
                 CALL cl_err('','aoo1014',1)
#                 RETURN
                 CALL i402_b()
              END IF
           END IF
           IF l_geh04='H'  THEN
              SELECT count(gel01) INTO l_cnt FROM gel_file
               WHERE gel01=g_gei.gei01
                 AND gel04='A'
              IF l_cnt<=0 THEN
                 CALL cl_err('','aoo1015',1)
                 CALL i402_b()
#                 RETURN
              END IF
           END IF
           LET l_sql = "SELECT gel02,gel06,gel03,gel04,gel05,gel07 ",
                       "  FROM gel_file ",
                       " WHERE gel01 = '",g_gei.gei01,"' "
           PREPARE i402_l_sql_pre FROM l_sql
           DECLARE i402_sql_cs CURSOR FOR i402_l_sql_pre
           LET l_cnt1=1
           LET l_cnt2=1
           CALL l_gel.clear()
           FOREACH i402_sql_cs INTO l_gel[l_cnt1].*
              SELECT COUNT(*) INTO l_cnt FROM gel_file
               WHERE gel01 != g_gei.gei01
                 AND gel04 = l_gel[l_cnt1].gel04
                 AND gel05 = l_gel[l_cnt1].gel05
              IF l_cnt>0 THEN
                 LET l_cnt2 = l_cnt2+1
              END IF
              LET l_cnt1 = l_cnt1+1
           END FOREACH
           IF l_cnt1 == l_cnt2 THEN
              CALL cl_err('','aoo1017',1)
              CALL i402_b()
           END IF
        END IF
        #DEV-D30026----ADD----END-----
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(gel05)  #No.FUN-810036
                 IF g_gel[l_ac].gel04 = '2' OR g_gel[l_ac].gel04 = '4' THEN   #No.MOD-870057 
                    CALL cl_init_qry_var()
                    IF g_gel[l_ac].gel04 = '2' THEN  #No.FUN-810036
                       LET g_qryparam.form = "q_gej"
                    END IF
                    IF g_gel[l_ac].gel04 = '4' THEN
                       LET g_qryparam.form = "q_gaq"
                       LET g_qryparam.arg1 = g_lang
             #         LET g_qryparam.arg2 = 'ima'        #FUN-D10021 mark
                       IF l_geh04 = 'C' THEN              #FUN-D10021 add
                          LET g_qryparam.arg2 = 'rtz01'   #FUN-D10021 add
                       ELSE                               #FUN-D10021 add
                          LET g_qryparam.arg2 = 'ima'     #FUN-D10021 add
                       END IF                             #FUN-D10021 add   
                    END IF 
                    LET g_qryparam.default1 = g_gel[l_ac].gel05   #No.MOD-870057
                    CALL cl_create_qry() RETURNING g_gel[l_ac].gel05
                    NEXT FIELD gel05
                 END IF
              OTHERWISE
                 EXIT CASE
           END CASE
 
        ON ACTION CONTROLN
           CALL i402_b_askkey()
           EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(gel02) AND l_ac > 1 THEN
              LET g_gel[l_ac].* = g_gel[l_ac-1].*
              NEXT FIELD gel02
           END IF
 
        ON ACTION lineno_from_1_resort
           IF INFIELD(gel02) THEN
              CALL i402_b_y()
              CALL i402_b_fill(" 1=1")
              EXIT INPUT
           END IF
 
        ON ACTION addno
           CALL i402_b_u()
 
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
 
       ON ACTION controls                                                                                                             
           CALL cl_set_head_visible("","AUTO")                                                                                        
 
    END INPUT
    IF p_cmd = 'u' THEN
       LET g_gei.geimodu = g_user
       LET g_gei.geidate = g_today
       UPDATE gei_file SET geimodu = g_gei.geimodu,geidate = g_gei.geidate
          WHERE gei01 = g_gei.gei01
       DISPLAY BY NAME g_gei.geimodu,g_gei.geidate
   END IF
 
   CLOSE i402_bcl
   CLOSE i402_cl
   COMMIT WORK
   CALL i402_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i402_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM gei_file WHERE gei01 = g_gei.gei01
         INITIALIZE g_gei.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION i402_b_y()
   DEFINE r,i,j     LIKE type_file.num10         #No.FUN-680102INTEGER 
 
   DECLARE i402_b_y_c CURSOR FOR SELECT gel02 FROM gel_file
                                  WHERE gel01 = g_gei.gei01 ORDER BY gel02
 
   BEGIN WORK
   LET g_success = 'Y'
   LET i=0
 
   FOREACH i402_b_y_c INTO j
      IF STATUS THEN
         CALL cl_err('foreach',STATUS,1)    
         LET g_success = 'N'
         EXIT FOREACH
      END IF
 
      LET i=i+1
 
      UPDATE gel_file SET gel02 = i WHERE gel01=g_gei.gei01 AND gel02=j
 
      IF STATUS THEN
         CALL cl_err('upd gel02',STATUS,1)    
         LET g_success = 'N'
         EXIT FOREACH
      END IF
   END FOREACH
 
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
      RETURN
   END IF
 
END FUNCTION
 
FUNCTION i402_b_u()
   DEFINE r,i,j    LIKE type_file.num10          #No.FUN-680102INTEGER
   DEFINE l_ac_1   LIKE type_file.num5           #NO.TQC-9C0016 add 
 
   DECLARE i402_b_u_c CURSOR FOR
    SELECT gel02 FROM gel_file
     WHERE gel01 = g_gei.gei01 AND gel02 >= g_gel[l_ac].gel02
     ORDER BY gel02 DESC
 
   BEGIN WORK
   LET g_success = 'Y'
   LET l_ac_1 = l_ac                             #No.TQC-9C0016 add
   FOREACH i402_b_u_c INTO j
     IF STATUS THEN
        CALL cl_err('foreach',STATUS,1) LET g_success = 'N' EXIT FOREACH    
     END IF
     UPDATE gel_file SET gel02 = gel02 + 1 WHERE gel01=g_gei.gei01 AND gel02=j
     LET g_gel[l_ac].gel02 = g_gel[l_ac].gel02 + 1             #TQC-9C0016 add     
     DISPLAY g_gel[l_ac].gel02 TO s_gel[j].gel02               #TQC-9C0016 add
     LET l_ac = l_ac + 1                                       #TQC-9C0016 add
     IF STATUS THEN
        CALL cl_err3("upd","gel_file","","",SQLCA.sqlcode,"","upd gel02",1)  #No.FUN-660131
        LET g_success = 'N' EXIT FOREACH   
     END IF
   END FOREACH
   IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK RETURN END IF
   LET l_ac = l_ac_1                       #TQC-9C0016 mod
   LET g_gel_t.gel02 = g_gel[l_ac].gel02   
END FUNCTION
 
FUNCTION i402_bu()
   DEFINE l_cnt  LIKE type_file.num5          #No.FUN-680102 SMALLINT
   DEFINE l_tot  LIKE type_file.num5           #No.FUN-680102 SMALLINT 
 
   SELECT COUNT(*),SUM(gel03) INTO l_cnt,l_tot
     FROM gel_file
    WHERE gel01 = g_gei.gei01
 
   IF cl_null(l_tot) THEN
      LET l_tot = 0
   END IF
 
   UPDATE gei_file SET gei04 = l_cnt, gei05 = l_tot
    WHERE gei01 = g_gei.gei01
 
   IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err3("upd","gei_file",g_gei.gei01,"",SQLCA.sqlcode,"","upd gei",1)  #No.FUN-660131
   END IF
 
   SELECT * INTO g_gei.* FROM gei_file WHERE gei01 = g_gei.gei01
 
   DISPLAY BY NAME g_gei.gei04,g_gei.gei05
 
END FUNCTION
 
 
FUNCTION i402_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680102 VARCHAR(200) 
 
    CLEAR gen02                           #清除FORMONLY欄位
    CONSTRUCT l_wc2 ON gel02,gel06,gel03,gel04,gel05,gel07
                  FROM s_gel[1].gel02,s_gel[1].gel06,s_gel[1].gel03,
                       s_gel[1].gel04,s_gel[1].gel05,s_gel[1].gel07
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
                 ON ACTION qbe_select
                  CALL cl_qbe_select()
                 ON ACTION qbe_save
               CALL cl_qbe_save()
    END CONSTRUCT
 
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
 
    CALL i402_b_fill(l_wc2)
 
END FUNCTION
 
FUNCTION i402_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2         LIKE type_file.chr1000       #No.FUN-680102 VARCHAR(200) 
 
    LET g_sql = "SELECT gel02,gel06,gel03,gel04,gel05,gel07 ",
                "  FROM gel_file",
                " WHERE gel01 ='",g_gei.gei01,"'"  #單頭
    IF NOT cl_null(p_wc2) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED 
    END IF 
    LET g_sql=g_sql CLIPPED," ORDER BY gel02 " 
    DISPLAY g_sql
    
    PREPARE i402_pb FROM g_sql
    DECLARE gel_curs                       #SCROLL CURSOR
        CURSOR FOR i402_pb
 
     CALL g_gel.clear()
 
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH gel_curs INTO g_gel[g_cnt].*   #單身 ARRAY 填充
        LET g_rec_b = g_rec_b + 1
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_gel.deleteElement(g_cnt)
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i402_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_gel TO s_gel.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)
 
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
         CALL i402_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL i402_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
      ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL i402_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
      ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL i402_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
      ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
display "i402_bp_refresh()"
      ON ACTION last
         CALL i402_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
      ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
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
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE             #MOD-570244      mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
#@    ON ACTION 相關文件
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
 
FUNCTION i402_copy()
DEFINE
    l_gei            RECORD LIKE gei_file.*,
    l_oldno,l_newno      LIKE gei_file.gei01
 
    IF s_shut(0) THEN RETURN END IF
    IF g_gei.gei01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
    LET g_before_input_done = FALSE
    CALL i402_set_entry('a')
    CALL i402_set_no_entry('a')
    LET g_before_input_done = TRUE
 
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    INPUT l_newno FROM gei01
 
        AFTER FIELD gei01
           IF NOT cl_null(l_newno) THEN
              SELECT count(*) INTO g_cnt FROM gei_file
               WHERE gei01 = l_newno
              IF g_cnt > 0 THEN
                 CALL cl_err(l_newno,-239,0)
                 NEXT FIELD gei01
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
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       DISPLAY BY NAME g_gei.gei01
       RETURN
    END IF
 
    LET l_gei.* = g_gei.*
    LET l_gei.gei01  =l_newno   #新的鍵值
    LET l_gei.geiuser=g_user    #資料所有者
    LET l_gei.geigrup=g_grup    #資料所有者所屬群
    LET l_gei.geimodu=NULL      #資料修改日期
    LET l_gei.geidate=g_today   #資料建立日期
    LET l_gei.geiacti='Y'       #有效資料
    BEGIN WORK
    LET l_gei.geioriu = g_user      #No.FUN-980030 10/01/04
    LET l_gei.geiorig = g_grup      #No.FUN-980030 10/01/04
    INSERT INTO gei_file VALUES (l_gei.*)
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","gei_file",g_gei.gei01,"",SQLCA.sqlcode,"","gei:",1)  #No.FUN-660131
        RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM gel_file         #單身複製
        WHERE gel01=g_gei.gei01
        INTO TEMP x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","gel_file",g_gei.gei01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
        RETURN
    END IF
    UPDATE x
        SET   gel01=l_newno
    INSERT INTO gel_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","gel_file","","",SQLCA.sqlcode,"","gel:",1)  #No.FUN-660131
        ROLLBACK WORK
        RETURN
    END IF
    COMMIT WORK
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
     LET l_oldno = g_gei.gei01
     SELECT gei_file.* INTO g_gei.* FROM gei_file WHERE gei01 = l_newno
     CALL i402_u()
     CALL i402_b()
     #SELECT gei_file.* INTO g_gei.* FROM gei_file WHERE gei01 = l_oldno  #FUN-C80046
     #CALL i402_show()  #FUN-C80046
END FUNCTION
#No:FUN-9C0071--------精簡程式-----

#DEV-D30026-----ADD----STR----
FUNCTION i402_ins_b()
   DEFINE   l_gel         RECORD
            gel02       LIKE gel_file.gel02,
            gel06       LIKE gel_file.gel06,
            gel03       LIKE gel_file.gel03,
            gel04       LIKE gel_file.gel04,
            gel05       LIKE gel_file.gel05,
            gel07       LIKE gel_file.gel07
                       END RECORD,
            l_sma119    LIKE sma_file.sma119,
            l_geh04     LIKE geh_file.geh04
   DEFINE   l_gei04     LIKE gei_file.gei04
   DEFINE   l_gei05     LIKE gei_file.gei05
         IF g_gei.gei08 = 'Y' THEN
            LET l_gel.gel02=1
            LET l_gel.gel03=1
            LET l_gel.gel04='1'
            SELECT geh04 INTO l_gel.gel05 FROM geh_file
             WHERE geh01 = g_gei.gei03
               AND geh04 IN ('F','G','H','5','6')
            IF cl_null(l_gel.gel05) THEN
               LET l_gel.gel05='A'
            END IF
            CALL cl_getmsg('aoo1009',g_lang) RETURNING l_gel.gel06
            LET l_gel.gel07='N'
            INSERT INTO gel_file VALUES(g_gei.gei01,l_gel.gel02,l_gel.gel03,l_gel.gel04,
                                        l_gel.gel05,l_gel.gel06,l_gel.gel07)
            IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","gel_file",g_gel[l_ac].gel02,"",SQLCA.sqlcode,"","",1)
              RETURN
            ELSE
               SELECT count(*) INTO l_gei04 FROM gel_file WHERE gel01=g_gei.gei01
               SELECT sum(gel03) INTO l_gei05 FROM gel_file WHERE gel01=g_gei.gei01
               UPDATE gei_file SET gei04=l_gei04,
                                   gei05=l_gei05
                WHERE gei01 = g_gei.gei01
               DISPLAY l_gei04 TO gei04
               DISPLAY l_gei05 TO gei05
            END IF
            INITIALIZE l_gel.* TO NULL
            SELECT geh04 INTO l_geh04 FROM geh_file
             WHERE geh01 = g_gei.gei03
               AND geh04 IN ('F','G','H','5','6')
            IF l_geh04 ='F' THEN
               LET l_gel.gel02=2
               CASE g_sma.sma119
                  WHEN '0'
                     LET l_gel.gel03=20
                  WHEN '1'
                     LET l_gel.gel03=30
                  WHEN '2'
                     LET l_gel.gel03=40
               END CASE
               LET l_gel.gel04='4'
               LET l_gel.gel05='ima01'
               CALL cl_getmsg('aoo1010',g_lang) RETURNING l_gel.gel06
               LET l_gel.gel07='N'
               INSERT INTO gel_file VALUES(g_gei.gei01,l_gel.gel02,l_gel.gel03,l_gel.gel04,
                                        l_gel.gel05,l_gel.gel06,l_gel.gel07)
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("ins","gel_file",g_gel[l_ac].gel02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                  RETURN
               ELSE
                  SELECT count(*) INTO l_gei04 FROM gel_file WHERE gel01=g_gei.gei01
                  SELECT sum(gel03) INTO l_gei05 FROM gel_file WHERE gel01=g_gei.gei01
                  UPDATE gei_file SET gei04=l_gei04,
                                      gei05=l_gei05
                   WHERE gei01 = g_gei.gei01
                  DISPLAY l_gei04 TO gei04
                  DISPLAY l_gei05 TO gei05
               END IF
            END IF
            INITIALIZE l_gel.* TO NULL
            IF l_geh04  ='G' THEN
               LET l_gel.gel02=2
               LET l_gel.gel03=20
               LET l_gel.gel04='B'
               LET l_gel.gel05='sfb01'
               CALL cl_getmsg('aoo1011',g_lang) RETURNING l_gel.gel06
               LET l_gel.gel07='N'
               INSERT INTO gel_file VALUES(g_gei.gei01,l_gel.gel02,l_gel.gel03,l_gel.gel04,
                                        l_gel.gel05,l_gel.gel06,l_gel.gel07)
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("ins","gel_file",g_gel[l_ac].gel02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                  RETURN
               ELSE
                  SELECT count(*) INTO l_gei04 FROM gel_file WHERE gel01=g_gei.gei01
                  SELECT sum(gel03) INTO l_gei05 FROM gel_file WHERE gel01=g_gei.gei01
                  UPDATE gei_file SET gei04=l_gei04,
                                      gei05=l_gei05
                   WHERE gei01 = g_gei.gei01
                  DISPLAY l_gei04 TO gei04
                  DISPLAY l_gei05 TO gei05
               END IF
            END IF
         END IF
END FUNCTION
#DEV-D30026-----ADD----END----
 
#DEV-D30026 add str-----------
FUNCTION i402_del_chk()   #控卡刪除前需先check是否已被aimi100使用
  DEFINE l_cnt LIKE type_file.num5

  LET l_cnt = 0
  SELECT COUNT(*) INTO l_cnt FROM ima_file
   WHERE ima920 = g_gei.gei01 or ima923 = g_gei.gei01 or ima933 = g_gei.gei01

  IF l_cnt > 0 THEN LET g_success = 'N' END IF
END FUNCTION
#DEV-D30026 add end-----------
