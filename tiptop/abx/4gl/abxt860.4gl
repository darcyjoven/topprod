# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: abxt860.4gl
# Descriptions...: 保稅在製工單盤點維護作業
# Modify.........: No.MOD-470041 04/07/19 By Nicola 修改INSERT INTO 語法
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-550033 05/05/23 By will 單據編號加大
# Modify.........: NO.FUN-550033 05/05/22 By jackie 單據編號加大
# Modify.........: No.MOD-530074 05/06/09 By Mandy 取消ima02,ima25的QBE
# Modify.........: No.FUN-580110 05/08/24 By Tracy 2.0憑証類報表修改,轉XML格式
# Modify.........: No.MOD-580274 05/08/31 By Rosayu 規格ima021沒有選出
# Modify.........: No.MOD-580323 05/08/30 By jackie 將程序中寫死為中文的錯誤信息改由p_ze維護
# Modify.........: No.FUN-5B0013 05/11/02 By Rosayu 將料號/品名/規格 欄位設成[1,,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: NO.FUN-590118 06/01/03 By Rosayu 將項次改成'###&'
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660052 05/06/14 By ice cl_err3訊息修改
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換  
# Modify.........: No.FUN-6A0046 06/10/19 By jamie 1.FUNCTION t860()_q 一開始應清空g_bwb.*的值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0007 06/11/06 By kim GP3.5 台虹保稅客製功能回收修改
# Modify.........: No.FUN-6B0033 06/11/13 By hellen 新增單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-850089 08/05/27 By TSD.Wind 傳統報表轉Crystal Report
# Modify.........: No.FUN-890101 08/09/23 By dxfwo  CR 追單到31區
# Modify.........: No.TQC-8C0039 08/12/23 By clover 單頭資料KEY值修改，單身資料的KEY值做相應的修改
# Modify.........: No.FUN-980001 09/08/10 By TSD.hoho GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-9A0022 09/10/06 By Smapmin bwb01/bwc01放大到16
# Modify.........: No.FUN-9A0024 09/10/10 By destiny display xxx.*改為display對應欄位
# Modify.........: No.FUN-9A0099 09/10/29 By TSD.apple GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/25 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/27 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.FUN-B50062 11/05/18 By xianghui BUG修改，刪除時提取資料報400錯誤 
# Modify.........: No.CHI-C30002 12/05/15 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-D30034 13/04/17 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_bwb    RECORD LIKE bwb_file.*,       #保稅工單盤點單頭資料檔
    g_bwb_t  RECORD LIKE bwb_file.*,       #保稅工單盤點單頭資料檔(舊值)
    g_bwb_o  RECORD LIKE bwb_file.*,       #保稅工單盤點單頭資料檔(舊值)
    g_bwb01_t       LIKE bwb_file.bwb01,   #盤點標簽
    g_bwb011_t   LIKE bwb_file.bwb011,  #FUN-6A0007
    g_bwc           DYNAMIC ARRAY OF RECORD   #保稅工單盤點單身資料檔
    bwc02 LIKE bwc_file.bwc02,             #序號　　　　　　　　
    bwc03 LIKE bwc_file.bwc03,             #料件編號
    ima02  LIKE ima_file.ima02,            #品名 #FUN-6A0007
    ima021 LIKE ima_file.ima021,           #規格 #FUN-6A0007
    ima25 LIKE ima_file.ima25,             #庫存單位
    bwc04 LIKE bwc_file.bwc04,             #作業序號
    bwc05 LIKE bwc_file.bwc05              #盤存數量(庫存單位)
    END RECORD,
    g_bwc_t         RECORD                 #保稅工單盤點單身資料檔 (舊值)
    bwc02 LIKE bwc_file.bwc02,             #序號
    bwc03 LIKE bwc_file.bwc03,             #料件編號
    ima02  LIKE ima_file.ima02,            #品名 #FUN-6A0007
    ima021 LIKE ima_file.ima021,           #規格 #FUN-6A0007
    ima25 LIKE ima_file.ima25,             #庫存單位
    bwc04 LIKE bwc_file.bwc04,             #作業序號
    bwc05 LIKE bwc_file.bwc05              #盤存數量(庫存單位)
    END RECORD,
    g_wc,g_sql,g_wc2    STRING,  #No.FUN-580092 HCN      
    g_argv1           LIKE bwb_file.bwb01,   #倉庫別
    g_argv2           LIKE type_file.chr1,                #是否具有新增功能(ASM#41)  #No.FUN-680062    VARCHAR(1)  
    g_rec_b           LIKE type_file.num5,                #單身筆數                  #No.FUN-680062    SMALLINT
    l_ac              LIKE type_file.num5                 #目前處理的ARRAY CNT       #No.FUN-680062    SMALLINT
 
#主程式開始
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL        
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680062  INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680062 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000  #No.FUN-680062 VARCHAR(72)
DEFINE   g_before_input_done LIKE type_file.num5          #No.FUN-680062  SMALLINT
DEFINE   g_curs_index   LIKE type_file.num10              #No.FUN-680062  INTEGER
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680062  INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680062  INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680062  SMALLINT
DEFINE   l_table        STRING,                  #FUN-850089 add
         g_str          STRING                   #FUN-850089 add
 
MAIN
DEFINE p_row,p_col   LIKE type_file.num5          #No.FUN-680062  SMALLINT
 
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
 
 
     CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818
       RETURNING g_time
 
#---FUN-850089 add ---start
 ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
  LET g_sql = "bwb01.bwb_file.bwb01,",            #標籤編號 
              "bwb02.bwb_file.bwb02,",            #工單號碼
              "bwb03.bwb_file.bwb03,",            #工單成品料號
              "g_ima02_1.ima_file.ima02,",        #成品品名
              "bwb04.bwb_file.bwb04,",            #工單待入庫量
              "g_ima021_1.ima_file.ima021,",      #成品規格
              "bwc02.bwc_file.bwc02,",            #序號
              "bwc03.bwc_file.bwc03,",            #料件編號
              "g_ima02.ima_file.ima02,",          #料件品名
              "g_ima25.ima_file.ima25,",          #料件庫存單位
              "bwc04.bwc_file.bwc04,",            #作業序號
              "bwc05.bwc_file.bwc05,",            #盤存數量
              "g_ima021.ima_file.ima021 "         #料件規格
                                          #13 items
  LET l_table = cl_prt_temptable('abxt860',g_sql) CLIPPED   # 產生Temp Table
  IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
  LET g_sql = "INSERT INTO ",g_cr_db_str,l_table CLIPPED,
              " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?)"
  PREPARE insert_prep FROM g_sql
  IF STATUS THEN
     CALL cl_err('insert_prep:',status,1)
     EXIT PROGRAM
  END IF
 #------------------------------ CR (1) ------------------------------#
#---FUN-850089 add ---end
 
   LET g_bwb01_t = NULL                   #清除鍵值
 
   INITIALIZE g_bwb_t.* TO NULL
   INITIALIZE g_bwb.* TO NULL
 
   LET p_row = 4 LET p_col = 20
   OPEN WINDOW t860_w AT p_row,p_col              #顯示畫面
   WITH FORM "abx/42f/abxt860"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   IF NOT cl_null(g_argv1) THEN
      CALL t860_q()
   END IF
 
#  LET g_forupd_sql = "SELECT * FROM bwb_file WHERE bwb01 = ? FOR UPDATE"
   LET g_forupd_sql = "SELECT * FROM bwb_file WHERE bwb01 = ? AND bwb011 = ? FOR UPDATE"   #FUN-6A0007
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t860_cl CURSOR FROM g_forupd_sql
 
   CALL t860_menu()
 
   CLOSE WINDOW t860_w                    #結束畫面
     CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818
       RETURNING g_time
 
END MAIN
 
#QBE 查詢資料
FUNCTION t860_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
 
   CLEAR FORM                          #清除畫面
   CALL g_bwc.clear()
                                       #螢幕上取單頭條件
   #CONSTRUCT BY NAME g_wc ON bwb01,bwb02,bwb03,ima02,bwb04 #MOD-530074 移除ima02 的QBE
   #CONSTRUCT BY NAME g_wc ON bwb01,bwb02,bwb03,bwb04       #MOD-530074
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0033
   INITIALIZE g_bwb.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON bwb01,bwb011,bwb02,bwb03,bwb04,bwb07   #FUN-6A0007
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
       #FUN-6A0007--start
       ON ACTION controlp
          IF INFIELD(bwb03) THEN
#FUN-AA0059 --Begin--
           #  CALL cl_init_qry_var()
           #  LET g_qryparam.state    = "c"
           #  LET g_qryparam.form     = "q_ima"
           #  CALL cl_create_qry() RETURNING g_qryparam.multiret
             CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
             DISPLAY g_qryparam.multiret TO bwb03
             NEXT FIELD bwb03
          END IF
      #FUN-6A0007--end
 
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
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
   IF INT_FLAG THEN RETURN END IF
 
    CONSTRUCT g_wc2 ON bwc02,bwc03,bwc04,bwc05   #螢幕上取單身條件 #MOD-530074 移除ima25 的QBE
         FROM s_bwc[1].bwc02,s_bwc[1].bwc03,s_bwc[1].bwc04,        #MOD-530074 移除ima25 的QBE
             s_bwc[1].bwc05
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
       #FUN-6A0007--start
       ON ACTION controlp
          IF INFIELD(bwc03) THEN
#FUN-AA0059 --Begin--
           #  CALL cl_init_qry_var()
           #  LET g_qryparam.state    = "c"
           #  LET g_qryparam.form     = "q_ima"
           #  CALL cl_create_qry() RETURNING g_qryparam.multiret
             CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
             DISPLAY g_qryparam.multiret TO bwc03
             NEXT FIELD bwc03
          END IF
       #FUN-6A0007--end
 
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
 
   IF INT_FLAG THEN  RETURN END IF
 
   IF g_wc2 = " 1=1" THEN                       # 若單身未輸入條件
     #LET g_sql = "SELECT bwb01 FROM bwb_file ",  #FUN-6A0007 mark
      LET g_sql = "SELECT bwb01,bwb011 FROM bwb_file ",  #FUN-6A0007
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY bwb01"
   ELSE                                 # 若單身有輸入條件
     #LET g_sql = "SELECT UNIQUE bwb_file.bwb01 ", #FUN-6A0007 mark
      LET g_sql = "SELECT UNIQUE bwb_file.bwb01,bwb011 ", #FUN-6A0007
                  "  FROM bwb_file, bwc_file ",
                  " WHERE bwb01 = bwc01",
                  "   AND bwb011=bwc011",   #FUN-6A0007
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY bwb01"
   END IF
 
   PREPARE t860_prepare FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,0)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
 
   DECLARE t860_cs                         #SCROLL CURSOR
      SCROLL CURSOR WITH HOLD FOR t860_prepare
 
   IF g_wc2 = " 1=1" THEN                      # 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM bwb_file WHERE ",g_wc CLIPPED
   ELSE
     #LET g_sql="SELECT COUNT(distinct bwb01)",  #FUN-6A0007 mark
     #LET g_sql="SELECT COUNT(bwb01,bwb011)",  #FUN-6A0007
     #          " FROM bwb_file,bwc_file WHERE ",
     #          " bwb01=bwc01 AND ",g_wc CLIPPED,
     #          "   AND bwb011=bwc011", #FUN-6A0007
     #          " AND ",g_wc2 CLIPPED,
   END IF
  #FUN-6A0007--start
  #PREPARE t860_precount FROM g_sql
  #DECLARE t860_count CURSOR FOR t860_precount
  #FUN-6A0007--end
 
END FUNCTION
 
FUNCTION t860_menu()
 
   WHILE TRUE
      CALL t860_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t860_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t860_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t860_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t860_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t860_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
             IF cl_chk_act_auth() THEN
                  CALL t860_out()
             END IF
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
       #@WHEN "轉入在製工單資料"
         WHEN "trans_in_w_o"
            CALL tran()
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bwc),'','')
            END IF
         #No.FUN-6A0046-------add--------str----
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               IF g_bwb.bwb01 IS NOT NULL THEN
                 LET g_doc.column1 = "bwb01"
                 LET g_doc.value1 = g_bwb.bwb01
                 CALL cl_doc()
               END IF
           END IF
         #No.FUN-6A0046-------add--------end----
       #FUN-6A0007--start
       #@WHEN "轉入在製盤點資料"  
         WHEN "trans_in_check"
            CALL tran_check()
       #FUN-6A0007--end
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION t860_a()
 
   MESSAGE ""
   CLEAR FORM                                   # 清螢墓欄位內容
   CALL g_bwc.clear()
   INITIALIZE g_bwb.* LIKE bwb_file.*
   LET g_bwb01_t = NULL
   LET g_bwb011_t = NULL  #FUN-6A0007
   LET g_bwb_t.*=g_bwb.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_bwb.bwb07 = 'N'    #FUN-6A0007
 
      LET g_bwb.bwbplant = g_plant  #FUN-980001 add
      LET g_bwb.bwblegal = g_legal  #FUN-980001 add
 
      CALL t860_i("a")                         # 各欄位輸入
 
      IF INT_FLAG THEN                         # 若按了DEL鍵
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         CLEAR FORM
         CALL g_bwc.clear()
         EXIT WHILE
      END IF
 
      #IF g_bwb.bwb01 IS NULL THEN                # KEY 不可空白#FUN-6A0007 mark
      IF cl_null(g_bwb.bwb01) OR cl_null(g_bwb.bwb011) THEN                # KEY 不可空白#FUN-6A0007
         CONTINUE WHILE
      END IF
 
      INSERT INTO bwb_file VALUES(g_bwb.*)       # DISK WRITE
      IF SQLCA.sqlcode THEN
#        CALL cl_err(g_bwb.bwb01,SQLCA.sqlcode,0)  #No.FUN-660052
         CALL cl_err3("ins","bwb_file",g_bwb.bwb01,"",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
 
      SELECT bwb01,bwb011 INTO g_bwb.bwb01,g_bwb.bwb011 FROM bwb_file
       WHERE bwb01 = g_bwb.bwb01
         AND bwb011=g_bwb.bwb011   #FUN-6A0007
 
      LET g_bwb_t.* = g_bwb.*
 
      CALL g_bwc.clear()
      LET g_rec_b = 0
 
      CALL t860_b()                   #輸入單身
 
      LET g_bwb01_t = g_bwb.bwb01        #保留舊值
      LET g_bwb011_t = g_bwb.bwb011  #FUN-6A0007
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t860_i(p_cmd)
    DEFINE
        l_utbwc       LIKE type_file.chr1,     #檢查是否第一次更改    #No.FUN-680062    VARCHAR(1)  
        l_dir1        LIKE type_file.chr1,     #CURSOR JUMP DIRECTION #No.FUN-680062    VARCHAR(1)
        l_dir2        LIKE type_file.chr1,     #CURSOR JUMP DIRECTION #No.FUN-680062    VARCHAR(1)
        l_sw          LIKE type_file.chr1,     #檢查必要欄位是否空白  #No.FUN-680062    VARCHAR(1)
        p_cmd         LIKE type_file.chr1,     #No.FUN-680062  VARCHAR(1)
        l_n           LIKE type_file.num5,     #No.FUN-680062  smallint
        x_buf         LIKE ima_file.ima02,     #No.FUN-680062  VARCHAR(30)
        l_ima021        LIKE ima_file.ima021,            #FUN-6A0007
        l_sfb02         LIKE sfb_file.sfb02, #FUN-6A0007
        l_sfb05         LIKE sfb_file.sfb05  #FUN-6A0007
 
   LET l_utbwc = 'Y'
   #FUN-6A0007--start
   #INPUT BY NAME g_bwb.bwb01,g_bwb.bwb02,g_bwb.bwb03,g_bwb.bwb04,
   CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
   INPUT BY NAME g_bwb.bwb01,g_bwb.bwb011,g_bwb.bwb02,g_bwb.bwb03,g_bwb.bwb04,
                 g_bwb.bwb07
   #FUN-6A0007--end
                 WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t860_set_entry(p_cmd)
         CALL t860_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("bwb02")      #No.FUN-550033
 
      #FUN-6A0007--start
      AFTER FIELD bwb011
         IF NOT cl_null(g_bwb.bwb011) THEN
            IF p_cmd = "a" OR
               (p_cmd = 'u' AND g_bwb.bwb011 != g_bwb011_t) THEN       # 若輸入KEY值不可重複
               SELECT count(*) INTO l_n FROM bwb_file
                WHERE bwb01 = g_bwb.bwb01
                  AND bwb011 = g_bwb.bwb011
               IF l_n > 0 THEN                  # Duplicated
                  CALL cl_err(g_bwb.bwb011,-239,0)
                  LET g_bwb.bwb011 = g_bwb011_t
                  DISPLAY BY NAME g_bwb.bwb011 
                  NEXT FIELD bwb011
               END IF
            END IF
         END IF
      #FUN-6A0007--end
 
      AFTER FIELD bwb01
         IF NOT cl_null(g_bwb.bwb01) THEN
           #IF p_cmd = "a" THEN       # 若輸入KEY值不可重複  #FUN-6A0007 mark
            IF p_cmd = "a"  OR
              (p_cmd = 'u' AND g_bwb.bwb01 != g_bwb01_t) THEN       # 若輸入KEY值不可重複  #FUN-6A0007
               SELECT count(*) INTO l_n FROM bwb_file
                WHERE bwb01 = g_bwb.bwb01
                  AND bwb011 = g_bwb.bwb011   #FUN-6A0007
               IF l_n > 0 THEN                  # Duplicated
                  CALL cl_err(g_bwb.bwb01,-239,0)
                  LET g_bwb.bwb01 = g_bwb01_t
                  DISPLAY BY NAME g_bwb.bwb01
                  NEXT FIELD bwb01
               END IF
            END IF
         END IF
 
      #FUN-6A0007--start
      BEFORE FIELD bwb02
         CALL t860_set_entry(p_cmd)
          
      AFTER FIELD bwb02  #工單編號 
         IF NOT cl_null(g_bwb.bwb02) THEN
             LET l_sfb05 = ''   LET l_sfb02 = ''
             SELECT sfb05,sfb02 
               INTO l_sfb05,l_sfb02
               FROM sfb_file
              WHERE sfb01=g_bwb.bwb02
             IF SQLCA.SQLCODE THEN LET l_sfb05 = '' LET l_sfb02='' END IF
             IF NOT cl_null(l_sfb05) THEN  #已存在的
                 LET g_bwb.bwb03 = l_sfb05
                 SELECT ima02,ima021 INTO x_buf,l_ima021
                   FROM ima_file
                  WHERE ima01=g_bwb.bwb03
                 IF l_sfb02 MATCHES "[78]" THEN
                     LET g_bwb.bwb07 = 'Y' 
                 ELSE
                     LET g_bwb.bwb07 = 'N' 
                 END IF
 
                 CALL t860_set_no_entry(p_cmd) 
 
                 DISPLAY BY NAME g_bwb.bwb03,g_bwb.bwb07
                 DISPLAY l_sfb02 TO sfb02 LET l_sfb02 = NULL 
                 DISPLAY x_buf   TO FORMONLY.ima02_h LET x_buf = NULL
                 DISPLAY l_ima021  TO FORMONLY.ima021_h LET l_ima021 = NULL
             END IF
         END IF
     #FUN-6A0007--end
 
      AFTER FIELD bwb03  #不可空白
         IF NOT cl_null(g_bwb.bwb03) THEN
            #FUN-AA0059 ------------------------------add start-------------------------
            IF NOT s_chk_item_no(g_bwb.bwb03,'') THEN
               CALL cl_err('',g_errno,1)
               NEXT FIELD bwb03
            END IF 
            #FUN-AA0059 ------------------------------add end--------------------------
            SELECT COUNT(*) INTO l_n FROM ima_file
             WHERE ima01 = g_bwb.bwb03
            IF l_n = 0 THEN
               CALL cl_err(g_bwb.bwb03,'apj-004',1) #FUN-6A0007
               NEXT FIELD bwb03
            ELSE
              #SELECT ima02 INTO x_buf FROM ima_file
               SELECT ima02,ima021 INTO x_buf,l_ima021 FROM ima_file  #FUN-6A0007
                WHERE ima01 = g_bwb.bwb03
               DISPLAY x_buf TO formonly.ima02_h
               DISPLAY l_ima021 TO FORMONLY.ima021_h
               LET x_buf = NULL LET l_ima021 = NULL  #FUN-6A0007
            END IF
         END IF
 
      AFTER INPUT
         IF INT_FLAG THEN EXIT INPUT END IF
         IF cl_null(g_bwb.bwb02) THEN
            DISPLAY BY NAME g_bwb.bwb02
            LET l_sw = 'Y'
         END IF
         IF cl_null(g_bwb.bwb03) THEN
            DISPLAY BY NAME g_bwb.bwb03
            LET l_sw = 'Y'
         END IF
         IF l_sw = 'Y' THEN
            CALL cl_err('','9033',0)
            LET l_sw = 'N'
            NEXT FIELD bwb01
         END IF
 
        #MOD-650015 --start  
      #ON ACTION CONTROLO                        # 沿用所有欄位
      #   IF INFIELD(bwb01) THEN
      #      LET g_bwb.* = g_bwb_t.*
      #      DISPLAY BY NAME g_bwb.*
      #      NEXT FIELD bwb01
      #   END IF
      #MOD-650015 --end 
       #FUN-6A0007--start
         SELECT sfb05,sfb02
           INTO l_sfb05,l_sfb02
           FROM sfb_file
          WHERE sfb01=g_bwb.bwb02
 
         IF NOT cl_null(l_sfb02) THEN  #已存在的工單
             IF l_sfb02 MATCHES "[78]" THEN
                 IF g_bwb.bwb07 != 'Y' THEN
                     CALL cl_err(g_bwb.bwb02,'abx-078',1)
                     NEXT FIELD bwb07
                 END IF
             ELSE    
             	 IF g_bwb.bwb07 = 'Y' THEN
             	     CALL cl_err(g_bwb.bwb02,'abx-079',1)
                     NEXT FIELD bwb07
                 END IF    
             END IF
         END IF 
      #FUN-6A0007--end
 
      #FUN-6A0007--start
      ON ACTION controlp 
         IF INFIELD(bwb03) THEN
#FUN-AA0059 --Begin--
           #  CALL cl_init_qry_var()
           #  LET g_qryparam.form     = "q_ima"
           #  LET g_qryparam.default1 = g_bwb.bwb03
           #  CALL cl_create_qry() RETURNING g_bwb.bwb03
             CALL q_sel_ima(FALSE, "q_ima", "",g_bwb.bwb03, "", "", "", "" ,"",'' )  RETURNING g_bwb.bwb03 
#FUN-AA0059 --End--
             DISPLAY BY NAME g_bwb.bwb03
             NEXT FIELD bwb03
         END IF
      #FUN-6A0007--end
 
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
 
FUNCTION t860_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_bwb.* TO NULL            #No.FUN-6A0046
   MESSAGE ""
   CALL cl_opmsg('q')
   DISPLAY '   ' TO FORMONLY.cnt
 
   CALL t860_cs()                          # 宣告 SCROLL CURSOR
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLEAR FORM
      CALL g_bwc.clear()
      RETURN
   END IF
 
   MESSAGE "Waiting...."
 
  #FUN-6A0007--start
  #OPEN t860_count
  #FETCH t860_count INTO g_row_count
   CALL t860_count()
  #FUN-6A0007--end
   DISPLAY g_row_count TO FORMONLY.cnt
   OPEN t860_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_bwb.bwb01,SQLCA.sqlcode,0)
      INITIALIZE g_bwb.* TO NULL
   ELSE
      CALL t860_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
   MESSAGE ""
 
END FUNCTION
 
FUNCTION t860_fetch(p_flag)
    DEFINE
        p_flag           LIKE type_file.chr1          #No.FUN-680062  VARCHAR(1)
 
    CASE p_flag
      #FUN-6A0007--start
      #WHEN 'N' FETCH NEXT     t860_cs INTO g_bwb.bwb01,g_bwb.bwb011,g_bwb.bwb01
      #WHEN 'P' FETCH PREVIOUS t860_cs INTO g_bwb.bwb01,g_bwb.bwb011,g_bwb.bwb01
      #WHEN 'F' FETCH FIRST    t860_cs INTO g_bwb.bwb01,g_bwb.bwb011,g_bwb.bwb01
      #WHEN 'L' FETCH LAST     t860_cs INTO g_bwb.bwb01,g_bwb.bwb011,g_bwb.bwb01
       WHEN 'N' FETCH NEXT     t860_cs INTO g_bwb.bwb01,g_bwb.bwb011,g_bwb.bwb01,g_bwb.bwb011
       WHEN 'P' FETCH PREVIOUS t860_cs INTO g_bwb.bwb01,g_bwb.bwb011,g_bwb.bwb01,g_bwb.bwb011
       WHEN 'F' FETCH FIRST    t860_cs INTO g_bwb.bwb01,g_bwb.bwb011,g_bwb.bwb01,g_bwb.bwb011
       WHEN 'L' FETCH LAST     t860_cs INTO g_bwb.bwb01,g_bwb.bwb011,g_bwb.bwb01,g_bwb.bwb011
      #FUN-6A0007--end
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
           #FETCH ABSOLUTE g_jump t860_cs INTO g_bwb.bwb01,g_bwb.bwb011,g_bwb.bwb01  #FUN-6A0007 mark
            FETCH ABSOLUTE g_jump t860_cs INTO g_bwb.bwb01,g_bwb.bwb011,g_bwb.bwb01,g_bwb.bwb011  #FUN-6A0007
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_bwb.* TO NULL  #TQC-6B0105
       RETURN
    ELSE
         CASE p_flag
            WHEN 'F' LET g_curs_index = 1
            WHEN 'P' LET g_curs_index = g_curs_index - 1
            WHEN 'N' LET g_curs_index = g_curs_index + 1
            WHEN 'L' LET g_curs_index = g_row_count
            WHEN '/' LET g_curs_index = g_jump          --改g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
    END IF
 
    SELECT * INTO g_bwb.* FROM bwb_file            # 重讀DB,因TEMP有不被更新特性
     WHERE bwb01 = g_bwb.bwb01 AND bwb011 = g_bwb.bwb011
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_bwb.bwb01,SQLCA.sqlcode,0)    #No.FUN-660052
       CALL cl_err3("sel","bwb_file",g_bwb.bwb01,"",SQLCA.sqlcode,"","",1)
    ELSE
       CALL t860_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t860_show()
#  DEFINE x_buf        LIKE ima_file.ima02    #No.FUN-680062 VARCHAR(30)
   #FUN-6A0007--start
   DEFINE x_buf          LIKE ima_file.ima02,
          l_ima021       LIKE ima_file.ima021,
          l_sfb02        LIKE sfb_file.sfb02 
   #FUN-6A0007--end
 
   LET g_bwb_t.* = g_bwb.*
   #No.FUN-9A0024--begin 
   #DISPLAY BY NAME g_bwb.*
   DISPLAY BY NAME g_bwb.bwb01,g_bwb.bwb011,g_bwb.bwb02,g_bwb.bwb03,g_bwb.bwb04,
                   g_bwb.bwb07
   #No.FUN-9A0024--end 
#  SELECT ima02 INTO x_buf FROM ima_file
   SELECT ima02,ima021 INTO x_buf,l_ima021 FROM ima_file   #FUN-6A0007
    WHERE ima01 = g_bwb.bwb03
#FUN-6A0007--start
   SELECT sfb02 INTO l_sfb02 FROM sfb_file
    WHERE sfb01 = g_bwb.bwb02 
   DISPLAY l_sfb02 TO sfb02
#FUN-6A0007--end
 
#  DISPLAY x_buf TO formonly.ima02
   DISPLAY x_buf TO FORMONLY.ima02_h      #FUN-6A0007
   DISPLAY l_ima021 TO FORMONLY.ima021_h  #FUN-6A0007
 
   CALL t860_b_fill(g_wc2)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t860_u()
   #若非由MENU進入本程式,則無更新之功能
   #IF g_bwb.bwb01 IS NULL THEN #FUN-6A0007 mark
   IF cl_null(g_bwb.bwb01) OR cl_null(g_bwb.bwb011) THEN  #FUN-6A0007
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_bwb.* FROM bwb_file WHERE bwb01=g_bwb.bwb01
                                         AND bwb011 = g_bwb.bwb011  #FUN-6A0007
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_bwb01_t = g_bwb.bwb01
   LET g_bwb011_t = g_bwb.bwb011   #FUN-6A0007
   LET g_bwb_o.* = g_bwb.*
   BEGIN WORK
 
   OPEN t860_cl USING g_bwb.bwb01,g_bwb.bwb011
   IF STATUS THEN
      CALL cl_err("OPEN t860_cl:", STATUS, 1)
      CLOSE t860_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t860_cl INTO g_bwb.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_bwb.bwb01,SQLCA.sqlcode,0)
      RETURN
   END IF
   CALL t860_show()                          # 顯示最新資料
 
   WHILE TRUE
      CALL t860_i("u")                      # 欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_bwb.*=g_bwb_t.*
         CALL t860_show()
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
    
      #TQC-8C0039--add--start
      IF g_bwb.bwb01 != g_bwb01_t OR g_bwb.bwb011 != g_bwb011_t THEN
            UPDATE bwc_file SET bwc01 = g_bwb.bwb01,bwc011=g_bwb.bwb011
                WHERE bwc01 = g_bwb01_t AND bwc011 = g_bwb011_t
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","bwc_file",g_bwb01_t,"",SQLCA.sqlcode,"","bwb",0)
               CONTINUE WHILE
            END IF
       END IF
      #TQC-8C0039--add--end
 
        UPDATE bwb_file SET bwb_file.* = g_bwb.*    # 更新DB
         WHERE bwb01 = g_bwb01_t AND bwb011 = g_bwb011_t
      IF SQLCA.sqlcode THEN
#        CALL cl_err(g_bwb.bwb01,SQLCA.sqlcode,0) #No.FUN-660052
         CALL cl_err3("upd","bwb_file",g_bwb01_t,"",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      CALL t860_show()
      EXIT WHILE
   END WHILE
 
   CLOSE t860_cl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION t860_r()
 
   DEFINE l_chr LIKE type_file.chr1       #No.FUN-680062      VARCHAR(1)
#  DEFINE l_buf LIKE type_file.chr1000    #儲存下游檔案的名稱 #No.FUN-680062 VARCHAR(80)
 
   #FUN-6A0007--start
  # IF g_bwb.bwb01 IS NULL THEN
   IF cl_null(g_bwb.bwb01) OR cl_null(g_bwb.bwb011) THEN
   #FUN-6A0007--end 
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   BEGIN WORK
   #FUN-6A0007--start
  # OPEN t860_cl USING g_bwb.bwb01
   OPEN t860_cl USING g_bwb.bwb01,g_bwb.bwb011
   #FUN-6A0007--end
   IF STATUS THEN
      CALL cl_err("OPEN t860_cl:", STATUS, 1)
      CLOSE t860_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t860_cl INTO g_bwb.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_bwb.bwb01,SQLCA.sqlcode,0)
      RETURN
   END IF
 
   CALL t860_show()
 
   IF cl_delh(15,16) THEN
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "bwb01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_bwb.bwb01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
      DELETE FROM bwb_file WHERE bwb01 = g_bwb.bwb01 AND bwb011 = g_bwb.bwb011
      DELETE FROM bwc_file WHERE bwc01 = g_bwb.bwb01
                             AND bwc011 = g_bwb.bwb011   #FUN-6A0007
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#        CALL cl_err(g_bwb.bwb01,SQLCA.sqlcode,0)  #No.FUN-660052
         CALL cl_err3("del","bwc_file",g_bwb.bwb01,"",SQLCA.sqlcode,"","",1)
      ELSE
         CLEAR FORM
         CALL g_bwc.clear()
        #FUN-6A0007--start
        #OPEN t860_count
        #FETCH t860_count INTO g_row_count
         CALL t860_count()
        #FUN-6A0007--end
          #FUN-B50062-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE t860_cs
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t860_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t860_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL t860_fetch('/')
         END IF
      END IF
   END IF
 
   CLOSE t860_cl
   COMMIT WORK
 
END FUNCTION
 
#單身
FUNCTION t860_b()
DEFINE
#  l_buf           LIKE type_file.chr1000,       #儲存尚在使用中之下游檔案之檔名        #No.FUN-680062 VARCHAR(80)
   x_buf           LIKE ima_file.ima02,          #No.FUN-680062    VARCHAR(30)
   l_ac_t          LIKE type_file.num5,          #未取消的ARRAY CN  #No.FUN-680062 smallint
   l_n             LIKE type_file.num5,          #檢查重複用        #No.FUN-680062 smallint
   l_lock_sw       LIKE type_file.chr1,          #單身鎖住否        #No.FUN-680062 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,          #處理狀態          #No.FUN-680062 VARCHAR(1)
   l_bcur          LIKE type_file.chr1,          #'1':表存放位置有值,'2':則為NULL   #No.FUN-680062 
   l_dir           LIKE type_file.chr1,          #next field flag   #No.FUN-680062  VARCHAR(1)
   l_dir1          LIKE type_file.chr1,          #next field flag   #No.FUN-680062  VARCHAR(1)
   l_dir2          LIKE type_file.chr1,          #next field flag   #No.FUN-680062  VARCHAR(1)
   l_dir3          LIKE type_file.chr1,          #next field flag   #No.FUN-680062  VARCHAR(1)
   l_allow_insert  LIKE type_file.num5,          #可新增否          #No.FUN-680062  smallint
   l_allow_delete  LIKE type_file.num5           #可刪除否          #No.FUN-680062  smallint
 
   LET g_action_choice = ""
   #IF g_bwb.bwb01 IS NULL THEN   #FUN-6A0007 mark
   IF cl_null(g_bwb.bwb01) OR cl_null(g_bwb.bwb011) THEN   #FUN-6A0007
      RETURN
   END IF
   SELECT * INTO g_bwb.* FROM bwb_file WHERE bwb01=g_bwb.bwb01
                                         AND bwb011 = g_bwb.bwb011 #FUN-6A0007
 
   CALL cl_opmsg('b')
 
  #LET g_forupd_sql = " SELECT bwc02,bwc03,'',bwc04,bwc05 ",
   LET g_forupd_sql = " SELECT bwc02,bwc03,'','','',bwc04,bwc05 ",   #FUN-6A0007
                      "   FROM bwc_file ",
                      "   WHERE bwc02= ? ",
                      "    AND bwc01= ? ",
                      "    AND bwc011= ? ",  #FUN-6A0007
                      " FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t860_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_bwc WITHOUT DEFAULTS FROM s_bwc.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_dir= ' '   #modi by nick
         LET l_n  = ARR_COUNT()
         BEGIN WORK
 
        #OPEN t860_cl USING g_bwb.bwb01   #FUN-6A0007 mark
         OPEN t860_cl USING g_bwb.bwb01,g_bwb.bwb011  #FUN-6A0007
         IF STATUS THEN
            CALL cl_err("OPEN t860_cl:", STATUS, 1)
            CLOSE t860_cl
            ROLLBACK WORK
            RETURN
         END IF
         FETCH t860_cl INTO g_bwb.*               # 對DB鎖定
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_bwb.bwb01,SQLCA.sqlcode,0)
            RETURN
         END IF
 
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
 
            LET g_bwc_t.* = g_bwc[l_ac].*  #BACKUP
           #OPEN t860_bcl USING g_bwc_t.bwc02,g_bwb.bwb01
            OPEN t860_bcl USING g_bwc_t.bwc02,g_bwb.bwb01,g_bwb.bwb011  #FUN-6A0007
            IF STATUS THEN
               CALL cl_err("OPEN t860_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH t860_bcl INTO g_bwc[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err('lock bxj',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
                 #SELECT ima25 INTO g_bwc[l_ac].ima25 FROM ima_file
                 # WHERE ima01 = g_bwc[l_ac].bwc03
                  SELECT ima02,ima021,ima25   #FUN-6A0007
                    INTO g_bwc[l_ac].ima02,g_bwc[l_ac].ima021,g_bwc[l_ac].ima25
                    FROM ima_file
                   WHERE ima01 = g_bwc[l_ac].bwc03
               END IF
            END IF
 
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         #INSERT INTO bwc_file(bwc01,bwc02,bwc03,bwc04,bwc05)  #No.MOD-470041
         #    VALUES(g_bwb.bwb01,g_bwc[l_ac].bwc02,g_bwc[l_ac].bwc03,
         #           g_bwc[l_ac].bwc04,g_bwc[l_ac].bwc05)
          INSERT INTO bwc_file(bwc011,bwc01,bwc02,bwc03,bwc04,bwc05,  #FUN-6A0007
                               bwcplant,bwclegal) #FUN-980001 add
              VALUES(g_bwb.bwb011,g_bwb.bwb01,g_bwc[l_ac].bwc02,g_bwc[l_ac].bwc03,
                     g_bwc[l_ac].bwc04,g_bwc[l_ac].bwc05,
                     g_plant,g_legal) #FUN-980001 add
 
         IF STATUS THEN
#           CALL cl_err(g_bwc[l_ac].bwc02,SQLCA.sqlcode,0)    #No.FUN-660052
            CALL cl_err3("ins","bwc_file",g_bwb.bwb01,g_bwc[l_ac].bwc02,SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_bwc[l_ac].* TO NULL      #900423
         LET g_bwc_t.* = g_bwc[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD bwc02
 
      BEFORE FIELD bwc02
         IF cl_null(g_bwc[l_ac].bwc02) THEN
            SELECT MAX(bwc02)+1 INTO g_bwc[l_ac].bwc02 FROM bwc_file
            #WHERE bwc01=g_bwb.bwb01
             WHERE bwc01=g_bwb.bwb01 AND bwc011=g_bwb.bwb011  #FUN-6A0007
            IF cl_null(g_bwc[l_ac].bwc02) THEN
               LET g_bwc[l_ac].bwc02 = 1
            END IF
         END IF
 
      AFTER FIELD bwc02
         IF cl_null(g_bwc_t.bwc02) OR g_bwc_t.bwc02!=g_bwc[l_ac].bwc02 THEN
            SELECT count(*) INTO l_n FROM bwc_file
             WHERE bwc01 = g_bwb.bwb01 AND bwc02 = g_bwc[l_ac].bwc02
               AND bwc011 = g_bwb.bwb011   #FUN-6A0007
            IF l_n > 0 THEN
               CALL cl_err('',-239,0)
               LET g_bwc[l_ac].bwc02 = g_bwc_t.bwc02
               NEXT FIELD bwc02
            END IF
         END IF
 
      AFTER FIELD bwc03
         IF NOT cl_null(g_bwc[l_ac].bwc03) THEN
           #FUN-AA0059 --------------------------------add start--------------------
            IF NOT s_chk_item_no(g_bwc[l_ac].bwc03,'') THEN
               CALL cl_err('',g_errno,1)
               NEXT FIELD bwc03
            END IF 
           #FUN-AA0059 ------------------------------add end---------------------- 
            SELECT COUNT(*) INTO l_n FROM ima_file
             WHERE ima01 = g_bwc[l_ac].bwc03
            IF l_n > 0 THEN
              #SELECT ima02,ima25 INTO x_buf,g_bwc[l_ac].ima25 FROM ima_file
               SELECT ima02,ima021,ima25 INTO x_buf,g_bwc[l_ac].ima021,g_bwc[l_ac].ima25 FROM ima_file   #FUN-6A0007
                WHERE ima01 = g_bwc[l_ac].bwc03
                #------MOD-5A0095 START----------
                DISPLAY BY NAME g_bwc[l_ac].ima25
                #------MOD-5A0095 END------------
               NEXT FIELD bwc04
            ELSE
               CALL cl_err('','100',0)
               NEXT FIELD bwc03
            END IF
         END IF
 
      BEFORE DELETE
         IF NOT cl_delb(0,0) THEN
            CANCEL DELETE
         END IF
         IF l_lock_sw = "Y" THEN
            CALL cl_err("", -263, 1)
            CANCEL DELETE
         END IF
         DELETE FROM bwc_file
          WHERE bwc01=g_bwb.bwb01
            AND bwc011=g_bwb.bwb011  #FUN-6A0007
            AND bwc02 = g_bwc_t.bwc02
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_bwc_t.bwc02,SQLCA.sqlcode,0)  #No.FUN-660052
            CALL cl_err3("del","bwc_file",g_bwb.bwb01,g_bwc_t.bwc02,SQLCA.sqlcode,"","",1)
            ROLLBACK WORK
            CANCEL DELETE
         END IF
         LET g_rec_b=g_rec_b-1
         DISPLAY g_rec_b TO FORMONLY.cn2
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_bwc[l_ac].* = g_bwc_t.*
            CLOSE t860_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_bwc[l_ac].bwc02,-263,1)
            LET g_bwc[l_ac].* = g_bwc_t.*
         ELSE
            UPDATE bwc_file SET bwc02=g_bwc[l_ac].bwc02,
                                bwc03=g_bwc[l_ac].bwc03,
                                bwc04=g_bwc[l_ac].bwc04,
                                bwc05=g_bwc[l_ac].bwc05
             WHERE bwc02=g_bwc_t.bwc02
               AND bwc01=g_bwb.bwb01
               AND bwc011=g_bwb.bwb011  #FUN-6A0007
 
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_bwc[l_ac].bwc02,SQLCA.sqlcode,0)  #No.FUN-660052
               CALL cl_err3("upd","bwc_file",g_bwb.bwb01,g_bwc_t.bwc02,SQLCA.sqlcode,"","",1)
               LET g_bwc[l_ac].* = g_bwc_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac   #FUN-D30034 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
                LET g_bwc[l_ac].* = g_bwc_t.*
            #FUN-D30034--add--begin--
            ELSE
               CALL g_bwc.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end----
            END IF
            CLOSE t860_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac   #FUN-D30034 add
         CLOSE t860_bcl
         COMMIT WORK
 
      #FUN-6A0007--start
      ON ACTION controlp 
         IF INFIELD(bwc03) THEN
#FUN-AA0059 --Begin--
           #  CALL cl_init_qry_var()
           #  LET g_qryparam.form     = "q_ima"
           #  LET g_qryparam.default1 = g_bwc[l_ac].bwc03
           #  CALL cl_create_qry() RETURNING g_bwc[l_ac].bwc03
             CALL q_sel_ima(FALSE, "q_ima", "", g_bwc[l_ac].bwc03 , "", "", "", "" ,"",'' )  RETURNING g_bwc[l_ac].bwc03
#FUN-AA0059 --End--
             DISPLAY BY NAME g_bwc[l_ac].bwc03
             NEXT FIELD bwc03
         END IF
      #FUN-6A0007--end
 
#     ON ACTION CONTROLN
#        CALL t860_b_askkey()
#        EXIT INPUT
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(bwc02) AND l_ac > 1 THEN
            LET g_bwc[l_ac].* = g_bwc[l_ac-1].*
            NEXT FIELD bwc02
         END IF
 
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
 
      ON ACTION controls                       #No.FUN-6B0033
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
   END INPUT
 
   CLOSE t860_bcl
   COMMIT WORK
#  CALL t860_delall()  #CHI-C30002 mark
   CALL t860_delHeader()     #CHI-C30002 add
 
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t860_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM bwb_file WHERE bwb01 = g_bwb.bwb01
                                AND bwb011=g_bwb.bwb011
         INITIALIZE g_bwb.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION t860_delall()
#
#  SELECT COUNT(*) INTO g_cnt FROM bwc_file
#   WHERE bwc01 = g_bwb.bwb01
#     AND bwc011=g_bwb.bwb011  #FUN-6A0007
#
#  IF g_cnt = 0 THEN                   # 未輸入單身資料, 是否取消單頭資料
#     CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#     ERROR g_msg CLIPPED
#     DELETE FROM bwb_file WHERE bwb01 = g_bwb.bwb01
#                            AND bwb011=g_bwb.bwb011  #FUN-6A0007
#  END IF
#
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION t860_b_askkey()
DEFINE
    l_wc       LIKE type_file.chr1000  #No.FUN-680062  VARCHAR(200)
 
  #FUN-6A0007--start
  #CONSTRUCT l_wc ON bwc02,bwc03,ima25,bwcd04,bwc05 #螢幕上取單身條件
  #     FROM s_bwc[1].bwc02,s_bwc[1].bwc03,s_bwc[1].ima25,s_bwc[1].bwc04,
  #          s_bwc[1].bwc05
   CONSTRUCT l_wc ON bwc02,bwc03,ima02,ima021,ima25,bwcd04,bwc05
        FROM s_bwc[1].bwc02,s_bwc[1].bwc03,s_bwc[1].ima02,s_bwc[1].ima021,
             s_bwc[1].ima25,s_bwc[1].bwc04,s_bwc[1].bwc05
  #FUN-6A0007--end   
 
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
 
   CALL t860_b_fill(l_wc)
 
END FUNCTION
 
FUNCTION t860_b_fill(p_wc)              #BODY FILL UP
DEFINE
   p_wc     LIKE type_file.chr1000 #No.FUN-680062 VARCHAR(400)
 
  #LET g_sql = "SELECT bwc02,bwc03,ima25,bwc04,bwc05 ",
  #            " FROM bwc_file,ima_file",
  #            " WHERE bwc01 = '",g_bwb.bwb01,"' AND ",p_wc CLIPPED,
  #            " AND   bwc03 = ima01 ",
  #            " ORDER BY bwc02"
   LET g_sql = "SELECT bwc02,bwc03,ima02,ima021,ima25,bwc04,bwc05 ",  #FUN-6A0007
               " FROM bwc_file,ima_file",
               " WHERE bwc011='",g_bwb.bwb011,"'",
               "   AND bwc01 = '",g_bwb.bwb01,"' AND ",p_wc CLIPPED,
               " AND   bwc03 = ima01 ",
               " ORDER BY bwc02"
 
   PREPARE t860_prepare2 FROM g_sql      #預備一下
   DECLARE bwc_cs CURSOR FOR t860_prepare2
 
   CALL g_bwc.clear()
   LET g_cnt = 1
   LET g_rec_b=0
 
   FOREACH bwc_cs INTO g_bwc[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_bwc.deleteElement(g_cnt)
 
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t860_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1       #No.FUN-680062   VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bwc TO s_bwc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
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
         CALL t860_fetch('F')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t860_fetch('P')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t860_fetch('/')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t860_fetch('N')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t860_fetch('L')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
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
#@    ON ACTION 轉入在製工單資料
      ON ACTION trans_in_w_o
         LET g_action_choice= "trans_in_w_o"
         EXIT DISPLAY
 
     #FUN-6A0007--start
     #ON ACTION 轉入在製盤點資料
      ON ACTION trans_in_check
         LET g_action_choice= "trans_in_check"
         EXIT DISPLAY
     #FUN-6A0007--end
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION related_document                #No.FUN-6A0046  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY  
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                      #No.FUN-6B0033
         CALL cl_set_head_visible("","AUTO")  #No.FUN-6B0033
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION t860_out()
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680062  smallint
    bwb RECORD LIKE bwb_file.*,
    bwc RECORD LIKE bwc_file.*,
    l_name          LIKE type_file.chr20,         #External(Disk) file name  #No.FUN-680062 VARCHAR(20)
    l_za05          LIKE za_file.za05             ##No.FUN-680062  VARCHAR(40)   
 
#FUN-850089 add---START
DEFINE l_sql    STRING,
       g_ima02,g_ima02_1   LIKE ima_file.ima02,  
       g_ima021,g_ima021_1 LIKE ima_file.ima021,
       g_ima25             LIKE ima_file.ima25
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
    CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
#FUN-850089 add---END
 
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
    LET g_sql="SELECT bwb_file.*,bwc_file.* ",
              " FROM bwb_file,bwc_file",      #組合出 SQL 指令
             #" WHERE bwb01=bwc01 AND ",g_wc CLIPPED
              " WHERE bwb01=bwc01 ",  #FUN-6A0007
              "   AND bwb011=bwc011",
              "   AND ",g_wc CLIPPED
    PREPARE t860_p1 FROM g_sql                #RUNTIME 編譯
    DECLARE t860_co                           #SCROLL CURSOR
         CURSOR FOR t860_p1
 
#    CALL cl_outnam('abxt860') RETURNING l_name  #No.FUN-890101
#    START REPORT t860_rep TO l_name             #No.FUN-890101
  
    FOREACH t860_co INTO bwb.*,bwc.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
      #---FUN-850089 add---START
        SELECT ima02,ima021 INTO g_ima02_1,g_ima021_1 FROM ima_file
         WHERE ima01 = bwb.bwb03
        SELECT ima02,ima25,ima021 INTO g_ima02,g_ima25,g_ima021  
          FROM ima_file WHERE ima01 = bwc.bwc03
        EXECUTE insert_prep USING  bwb.bwb01,  bwb.bwb02, bwb.bwb03, g_ima02_1,
                                   bwb.bwb04, g_ima021_1, bwc.bwc02, bwc.bwc03, 
                                     g_ima02,    g_ima25, bwc.bwc04, bwc.bwc05, 
                                    g_ima021 
       IF SQLCA.sqlcode  THEN
          CALL cl_err('insert_prep:',STATUS,1) EXIT FOREACH
       END IF
      #---FUN-850089 add---END
#        OUTPUT TO REPORT t860_rep(bwb.*,bwc.*)
    END FOREACH
 
#    FINISH REPORT t860_rep               #No.FUN-890101
  #FUN-850089  ---start---

     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> 
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " ORDER BY bwb01,bwc02"
  
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(g_wc,'bwb01,bwb011,bwb02,bwb03,bwb04,bwb07')
             RETURNING g_str
     ELSE
        LET g_str = ''
     END IF
     LET g_str = g_str
     CALL cl_prt_cs3('abxt860','abxt860',l_sql,g_str)
     #------------------------------ CR (4) ------------------------------#
      #FUN-850089  ----end---

    CLOSE t860_co
    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)    #No.FUN-890101
END FUNCTION
#
#REPORT t860_rep(bwb,bwc)
#DEFINE
#    l_trailer_sw        LIKE type_file.chr1,       #No.FUN-680062  VARCHAR(1)
#    l_ima02,l_ima02_1   LIKE ima_file.ima02,  
#    l_ima021,l_ima021_1 LIKE ima_file.ima021,
#    l_ima25             LIKE ima_file.ima25,
#    bwb RECORD LIKE bwb_file.*,
#    bwc RECORD LIKE bwc_file.*
#
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
#
#    ORDER BY bwb.bwb01,bwc.bwc02
#
#    FORMAT
#        PAGE HEADER
##No.FUN-580110 --start--
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED, pageno_total
#      PRINT g_dash
##No.FUN-580110 --end--
#            LET l_trailer_sw = 'y'
#
##No.FUN-580110 --start--
#      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
#                     g_x[38],g_x[39],g_x[40],g_x[41]
#      PRINTX name=H2 g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],g_x[47],g_x[48],
#                     g_x[49]
#      PRINT g_dash1
##No.FUN-580110 --end--
#        BEFORE GROUP OF bwb.bwb01  #盤點標籤
#            SELECT ima02,ima021 INTO l_ima02_1,l_ima021_1 FROM ima_file
#             WHERE ima01 = bwb.bwb03
##No.FUN-580110 --start--
#            PRINTX name=D1
#                  COLUMN g_c[31],bwb.bwb01,
#                  COLUMN g_c[32],bwb.bwb02,
#                  COLUMN g_c[33],bwb.bwb03,
#                  COLUMN g_c[34],l_ima02_1 CLIPPED, #FUN-5B0013 add CLIPPED
#                  COLUMN g_c[35],bwb.bwb04 USING '###########.##&';
#            PRINTX name=D2
#                  COLUMN g_c[45],l_ima021_1 CLIPPED; #FUN-5B0013 add CLIPPED
##No.FUN-580110 --end--
#        ON EVERY ROW
#            SELECT ima02,ima25,ima021 INTO l_ima02,l_ima25,l_ima021  #MOD-580274
#            FROM ima_file WHERE ima01 = bwc.bwc03
##No.FUN-580110 --start--
#            PRINTX name=D1
#                   COLUMN g_c[36],bwc.bwc02 USING '###&', #FUN-590118
#                   #COLUMN g_c[37],bwc.bwc03[1,20] CLIPPED, #FUN-5B0013 mark
#                   COLUMN g_c[37],bwc.bwc03 CLIPPED,   #FUN-5B0013 add
#                   COLUMN g_c[38],l_ima02 CLIPPED,
#                   COLUMN g_c[39],l_ima25 CLIPPED,
#                   COLUMN g_c[40],bwc.bwc04 USING '#######&',
#                   COLUMN g_c[41],bwc.bwc05 USING '###########.##&'
#            PRINTX name=D2
#                   COLUMN g_c[49],l_ima021 CLIPPED #FUN-5B0013 add CLIPPED
##No.FUN-580110 --end--
#        AFTER GROUP OF bwb.bwb01
#            PRINT ''
#
#        ON LAST ROW
#            PRINT g_dash
#            PRINT g_x[4] CLIPPED, COLUMN (g_len-9),g_x[7] CLIPPED
#            LET l_trailer_sw = 'n'
#
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash
#                PRINT g_x[4] CLIPPED, COLUMN (g_len-9),g_x[06] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
#No.FUN-890101
 
FUNCTION tran()
   DEFINE sfb    RECORD LIKE sfb_file.*
   DEFINE sfa    RECORD LIKE sfa_file.*
   DEFINE bwb    RECORD LIKE bwb_file.*
   DEFINE bwc    RECORD LIKE bwc_file.*
   DEFINE wc     LIKE type_file.chr1000            #No.FUN-680062   VARCHAR(300)
   DEFINE g_sql  STRING  #No.FUN-580092 HCN       
   DEFINE II,JJ  LIKE type_file.num10              #No.FUN-680062  integer
   DEFINE l_str1,l_str2,l_str3,l_str4,l_str5  STRING  #No.MOD-580323 
 
   LET II = 1
   LET JJ = 1
 
   OPEN WINDOW t860_w3 AT 8,20 WITH FORM "abx/42f/abxt8602"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("abxt8602")
 
   CONSTRUCT BY NAME wc ON sfb01
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
      CLOSE WINDOW t860_w3
      LET INT_FLAG =0  #FUN-6A0007
      RETURN
   END IF
#FUN-6A0007--start
   INPUT BY NAME g_bwb.bwb011
         WITHOUT DEFAULTS
 
      AFTER FIELD bwb011 
        IF g_bwb.bwb011 < 1 OR cl_null(g_bwb.bwb011) THEN
           CALL cl_err('','afa-370',0)
           NEXT FIELD bwb011
        END IF 
      ON ACTION about 
         CALL cl_about()     
 
      ON ACTION help        
         CALL cl_show_help()
 
      ON ACTION controlg   
         CALL cl_cmdask() 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT 
   END INPUT
   IF INT_FLAG THEN
   CLOSE WINDOW t860_w3
      LET INT_FLAG = 0
      RETURN
   END IF
   IF NOT cl_sure(0,0) THEN
      CLOSE WINDOW t860_w3
      RETURN
   END IF
 
#FUN-6A0007--end
   CLOSE WINDOW t860_w3
 #No.MOD-580323 --start--
   CALL cl_getmsg('mfg8601',g_lang) RETURNING l_str1
   MESSAGE l_str1
#   MESSAGE "轉檔中....."
   LET g_sql = "select sfb_file.* from sfb_file ",
               "where sfb04 IN ('4','5','6','7','8') ",
               "and   sfb081 > sfb09            ",
               "and ",wc clipped
 
   PREPARE t860_p3 FROM g_sql
   DECLARE t860_co3 CURSOR FOR t860_p3
   FOREACH t860_co3 INTO sfb.*
       #LET bwb.bwb01 = ii USING "&&&&&&&&&#"   #MOD-9A0022
       LET bwb.bwb01 = ii USING "&&&&&&&&&&&&&&&#"   #MOD-9A0022
       LET bwb.bwb02 = sfb.sfb01
       LET bwb.bwb03 = sfb.sfb05
       LET bwb.bwb04 = (sfb.sfb081-sfb.sfb09)
 
       #FUN-6A0007--start
       LET bwb.bwb011 = g_bwb.bwb011
 
       IF sfb.sfb02 MATCHES "[78]" THEN
           LET bwb.bwb07='Y'
       ELSE
           LET bwb.bwb07='N'
       END IF
       #FUN-6A0007--end
 
       LET bwb.bwbplant = g_plant  #FUN-9A0099 add
       LET bwb.bwblegal = g_legal  #FUN-9A0099 add

       INSERT INTO bwb_file VALUES (bwb.*)
       CALL cl_getmsg('mfg8602',g_lang) RETURNING l_str2
       CALL cl_getmsg('mfg8603',g_lang) RETURNING l_str3
       CALL cl_getmsg('mfg8604',g_lang) RETURNING l_str4
       MESSAGE l_str2,sfb.sfb01,' ',l_str3,sfb.sfb05,' ',
               l_str4,bwb.bwb04
#       MESSAGE "工單號碼=",sfb.sfb01," 主件=",sfb.sfb05,
#               " 尚未入庫量=",bwb.bwb04
 
       LET JJ = 1
       declare selsfa cursor for
          select * from sfa_file
       where sfa01 = sfb.sfb01
       foreach selsfa into sfa.*
           LET bwc.bwc01 = bwb.bwb01
           LET bwc.bwc011=bwb.bwb011  #FUN-6A0007
           LET bwc.bwc02 = jj
           LET bwc.bwc03 = sfa.sfa03
           LET bwc.bwc04 = sfa.sfa08
           LET bwc.bwc05 = bwb.bwb04 * sfa.sfa161

           LET bwc.bwcplant = g_plant  #FUN-9A0099 add
           LET bwc.bwclegal = g_legal  #FUN-9A0099 add

           INSERT INTO bwc_file VALUES (bwc.*)
           CALL cl_getmsg('mfg8602',g_lang) RETURNING l_str2
           CALL cl_getmsg('mfg8603',g_lang) RETURNING l_str3
           CALL cl_getmsg('mfg8604',g_lang) RETURNING l_str4
           CALL cl_getmsg('mfg8605',g_lang) RETURNING l_str5
           MESSAGE l_str2,sfb.sfb01,' ',l_str3,sfb.sfb05 clipped,
                   l_str5,sfa.sfa03 clipped, l_str4,bwb.bwb04
#           MESSAGE "工單號碼=",sfb.sfb01," 主件=",sfb.sfb05 clipped,
#                   "元件=",sfa.sfa03 clipped, " 尚未入庫量=",bwb.bwb04
 #No.MOD-580323 --end--
           LET jj = jj + 1
       end foreach
       LET II = II + 1
   END FOREACH
END FUNCTION
 
FUNCTION t860_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680062  VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
      #CALL cl_set_comp_entry("bwb01",TRUE)  #FUN-6A0007 mark
       CALL cl_set_comp_entry("bwb01,bwb011",TRUE)       #FUN-6A0007
   END IF
   
   CALL cl_set_comp_entry("bwb03",TRUE)  #FUN-6A0007
 
END FUNCTION
 
FUNCTION t860_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680062 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       IF p_cmd = 'u' AND g_chkey = 'N' THEN
          #CALL cl_set_comp_entry("bwb01",FALSE)  #FUN-6A0007 mark
           CALL cl_set_comp_entry("bwb01,bwb011",FALSE)  #FUN-6A0007
       END IF
   END IF
   CALL cl_set_comp_entry("bwb03",FALSE)  #FUN-6A0007
 
END FUNCTION
#Patch....NO.MOD-5A0095 <001> #
 
#FUN-6A0007--start
FUNCTION tran_check()
   DEFINE pid       RECORD LIKE pid_file.*
   DEFINE pie       RECORD LIKE pie_file.*
   DEFINE bwb       RECORD LIKE bwb_file.*
   DEFINE bwc       RECORD LIKE bwc_file.*
   DEFINE wc        STRING
   DEFINE g_sql     STRING
   DEFINE II,JJ     LIKE type_file.num10
   DEFINE l_cnt     LIKE type_file.num10
   DEFINE l_cnt1    LIKE type_file.num10
   DEFINE l_sfb02   LIKE sfb_file.sfb02,
          l_sfb08   LIKE sfb_file.sfb08,
          l_sfb09   LIKE sfb_file.sfb09
   
   LET II = 1 
 
   OPEN WINDOW t860_w4 AT 8,20 WITH FORM "abx/42f/abxt8603"
   ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_locale("abxt8603")
 
   ## 標籤編號、工單編號、生產料件
   CONSTRUCT BY NAME wc ON pid01,pid02,pid03
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
   END CONSTRUCT
   IF INT_FLAG THEN
      CLOSE WINDOW t860_w4
      LET INT_FLAG =0
      RETURN
   END IF
 
   ## 年度
   INPUT BY NAME g_bwb.bwb011
         WITHOUT DEFAULTS
 
      AFTER FIELD bwb011 
        IF g_bwb.bwb011 < 1 OR cl_null(g_bwb.bwb011) THEN
           CALL cl_err('','afa-370',0)
           NEXT FIELD bwb011
        END IF 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT 
   END INPUT
   IF INT_FLAG THEN
      CLOSE WINDOW t860_w4
      LET INT_FLAG =0
      RETURN
   END IF
   IF NOT cl_sure(0,0) THEN
      CLOSE WINDOW t860_w4
      RETURN
   END IF
 
   CLOSE WINDOW t860_w4
 
   LET g_success = 'N'
   MESSAGE "轉檔中....."
   LET g_sql = " select pid_file.* from pid_file ",
               "  where ",wc clipped 
 
   PREPARE t860_p4 FROM g_sql
   DECLARE t860_co4 CURSOR FOR t860_p4
   FOREACH t860_co4 INTO pid.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('For pid:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       ## 判斷是否存在 bwb_file
       LET l_cnt = 0
       SELECT COUNT(*) INTO l_cnt 
         FROM bwb_file
        WHERE bwb01     = pid.pid01           ## 標籤編號
          AND bwb02     = pid.pid02           ## 工單號碼
          AND bwb011 = g_bwb.bwb011     ## 盤點年度
       IF l_cnt !=0 THEN
          CALL cl_err(pid.pid01,'mfg0121',1)
          CONTINUE FOREACH
       END IF
 
       LET bwb.bwb011=g_bwb.bwb011
       LET bwb.bwb01 = pid.pid01                          ## 盤點標籤
       LET bwb.bwb02 = pid.pid02                          ## 工單號碼
       LET bwb.bwb03 = pid.pid03                          ## 成品編號
       LET l_sfb02 = ''
       LET l_sfb08 = 0
       LET l_sfb09 = 0
       SELECT sfb02,sfb08,sfb09 INTO l_sfb02,l_sfb08,l_sfb09
         FROM sfb_file
        WHERE sfb01 = pid.pid02
       IF cl_null(l_sfb08) THEN LET l_sfb08 = 0 END IF
       IF cl_null(l_sfb09) THEN LET l_sfb09 = 0 END IF
       LET bwb.bwb04 = (l_sfb08 - l_sfb09)                ## 未入庫量
       IF l_sfb02 MATCHES "[78]" THEN
          LET bwb.bwb07='Y'
       ELSE
          LET bwb.bwb07='N'
       END IF 
 
       LET bwb.bwbplant = g_plant  #FUN-9A0099 add
       LET bwb.bwblegal = g_legal  #FUN-9A0099 add

       INSERT INTO bwb_file VALUES (bwb.*)
       IF SQLCA.sqlcode THEN
          CALL cl_err(bwb.bwb01,SQLCA.sqlcode,0)
       END IF
       MESSAGE "工單號碼=",pid.pid02," 主件=",pid.pid03,
               " 尚未入庫量=",bwb.bwb04
       LET JJ = 0
       ## 取最大序號值
       SELECT MAX(bwc02) INTO JJ
         FROM bwc_file
        WHERE bwc01 = bwb.bwb01
          AND bwc011=bwb.bwb011
 
       IF cl_null(JJ) THEN LET JJ = 0 END IF
 
       DECLARE selpie CURSOR FOR 
        SELECT * FROM pie_file 
         WHERE pie01 = pid.pid01 
       LET JJ = JJ + 1
       LET l_cnt1 = 0
       FOREACH selpie INTO pie.*
           IF SQLCA.sqlcode THEN
              CALL cl_err('for selpie:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
 
           #FUN-6A0007 保留此條件，暫不Check是否存在bom
           ## 條件a.生效日期(bnd02)、失效日期(bnd03)
        #  LET l_cnt = 0
        #  SELECT COUNT(*) INTO l_cnt
        #    FROM bnd_file
        #   WHERE bnd01 = pie.pie02       ## 主件料號
        #     AND ((YEAR(bnd02) = g_bwb.bwb011 AND YEAR(bnd03) = g_bwb.bwb011)
        #      OR (YEAR(bnd02) = g_bwb.bwb011 AND (bnd03 = ' ' OR bnd03 IS NULL OR bnd03 = '')))
        #  IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
        #  
        #  IF l_cnt  =0 THEN
        # #IF l_cnt !=0 THEN
        #     CONTINUE FOREACH
        #  END IF
 
           ## 條件b.
           LET l_cnt = 0
           SELECT COUNT(*) INTO l_cnt
             FROM bwc_file
            WHERE bwc01     = pie.pie01 
              AND bwc03     = pie.pie02
              AND bwc011 = g_bwb.bwb011
           IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
           IF l_cnt !=0 THEN   #不存在要insert,存在就不用update
              CONTINUE FOREACH
           END IF   
          
           LET bwc.bwc01 = bwb.bwb01 
           LET bwc.bwc02 = JJ 
           LET bwc.bwc03 = pie.pie02 
           LET bwc.bwc04 = ''
           IF cl_null(pie.pie50) OR pie.pie50 = 0 THEN
              IF cl_null(pie.pie30) THEN LET pie.pie30 = 0 END IF 
              IF cl_null(pie.pie152) THEN LET pie.pie152 = 1 END IF 
              LET bwc.bwc05 = pie.pie30 * pie.pie152 
           ELSE
              IF cl_null(pie.pie50) THEN LET pie.pie50 = 0 END IF 
              IF cl_null(pie.pie152) THEN LET pie.pie152 = 1 END IF 
              LET bwc.bwc05 = pie.pie50 * pie.pie152 
           END IF
           LET bwc.bwc011 = g_bwb.bwb011      

           LET bwc.bwcplant = g_plant  #FUN-9A0099 add
           LET bwc.bwclegal = g_legal  #FUN-9A0099 add

           INSERT INTO bwc_file VALUES (bwc.*)
           IF SQLCA.sqlcode THEN
              CALL cl_err(bwc.bwc01,SQLCA.sqlcode,0)
           END IF
           ## MESSAGE "工單號碼=",pid.pid02," 主件=",pid.pid03 clipped,
           ##         "元件=",pie.pie02 clipped, " 尚未入庫量=",bwb.bwb04
           LET JJ = JJ + 1
           LET l_cnt1 = l_cnt1 + 1
       END FOREACH
       ## 若單身無資料時，把單頭資料一並刪除 
       IF l_cnt1 = 0 THEN
          DELETE FROM bwb_file WHERE bwb01 = pid.pid01 
          IF SQLCA.sqlcode THEN
             CALL cl_err('del_bwb',SQLCA.sqlcode,0)
          END IF
       END IF
       LET II = II + 1
       LET g_success = 'Y'
   END FOREACH 
   IF g_success = 'N' THEN MESSAGE "無資料" END IF
END FUNCTION 
 
#FUN-6A0007--start
FUNCTION t860_count()
   DEFINE l_bwb   DYNAMIC ARRAY of RECORD        # 程式變數
          bwb01          LIKE bwb_file.bwb01,
          bwb011      LIKE bwb_file.bwb011
                  END RECORD
 
   DEFINE l_cnt   LIKE type_file.num10
   DEFINE l_rec_b LIKE type_file.num10
 
   LET g_sql="SELECT UNIQUE bwb01,bwb011", 
             " FROM bwb_file,bwc_file WHERE ",
             " bwb01=bwc01 AND ",g_wc CLIPPED,
             "   AND bwb011=bwc011",
             " AND ",g_wc2 CLIPPED,
             " GROUP BY bwb01,bwb011"
 
   PREPARE t860_precount FROM g_sql
   DECLARE t860_count CURSOR FOR t860_precount
   LET l_cnt=1
   LET l_rec_b=0
   FOREACH t860_count INTO l_bwb[l_cnt].*
       LET l_rec_b = l_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          LET l_rec_b = l_rec_b - 1
          EXIT FOREACH
       END IF
       LET l_cnt = l_cnt + 1
    END FOREACH
    LET g_row_count=l_rec_b
 
END FUNCTION
#FUN-6A0007--end
