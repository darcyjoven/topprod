# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: axmt710.4gl
# Descriptions...: 客訴單資料記錄維護作業
# Date & Author..: 02/03/19 By Mandy
# Modify.........: No:7829 03/08/18 Carol 單據程式中呼叫單據自動編號時,
#                                         應該是要包覆在 BEGIN WORK 中(transaction)
#                                         才會達到lock 的功能
# Modify.........: No.MOD-4A0252 04/10/19 By Smapmin 增加客訴單號開窗功能
# Modify.........: No.FUN-4B0038 04/11/15 By pengu ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4B0050 04/11/23 By Mandy 匯率加開窗功能
# Modify.........: No.FUN-4C0006 04/12/03 By Carol 單價/金額欄位放大(20),位數改為dec(20,6)
# Modify.........: No.FUN-4C0057 04/12/09 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.FUN-4C0076 04/12/15 By pengu  匯率幣別欄位修改，與aoos010的aza17做判斷，
                                                    #如果二個幣別相同時，匯率強制為 1
# Modify.........: No.MOD-510096 05/01/13 By ching 抓ima02
# Modify.........: No.FUN-550070 05/05/26 By Will 單據編號放大
# Modify.........: No.FUN-590052 05/09/09 By Nicola 客訴日期不可小於原銷貨日期
# Modify.........: No.FUN-590008 05/10/21 By Kevin 加入複製功能
# Modify.........: No.FUN-5B0028 05/11/03 By kim加入列印功能,列印串axmr762
# Modify.........: No.FUN-5B0116 05/11/22 By Claire 修改單身後單頭的資料更改者及最近修改日應update
# Modify.........: No.FUN-610020 06/01/17 By Carrier 出貨驗收功能 -- 修改oga09的判斷
# Modify.........: No.TQC-630066 06/03/07 By Kevin 流程訊息通知功能修改
# Modify.........: No.TQC-630107 06/03/10 By Alexstar 單身筆數限制
# Modify.........: No.FUN-650010 06/05/03 By Sarah 新增時原出貨單開窗改為q_ogb04,回傳單號與項次
# Modify.........: No.TQC-610089 06/05/16 By Pengu Review所有報表程式接收的外部參數是否完整
# Modify.........: No.TQC-660088 06/06/21 By Claire 流程訊息通知功能修改
# Modify.........: No.FUN-660167 06/06/23 By cl cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE
# Modify.........: No.FUN-690023 06/09/11 By jamie 判斷occacti
# Modify.........: No.FUN-690022 06/09/20 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0020 06/10/16 By jamie 1.FUNCTION t710()_fetch 一開始應清空g_ohc.ohc01的值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0094 06/11/01 By yjkhero l_time轉g_time 
# Modify.........: No.FUN-6A0092 06/11/14 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0117 06/11/21 By day 欄位加控管 
# Modify.........: No.FUN-730018 07/03/28 By kim 行業別架構
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.CHI-7B0023/CHI-7B0039 07/11/14 By kim 移除GP5.0行業別功能的所有程式段
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840042 08/04/11 By TSD.Wind 自定欄位功能修改
# Modify.........: No.TQC-930004 09/03/02 By chenyu 復制一筆已經審核過的資料，當前狀態為“1.處理中”
# Modify.........: No.MOD-950069 09/05/08 By Smapmin 沒有出貨單時,幣別沒預設.
#                                                    匯率未依幣別計算出來
# Modify.........: No.MOD-950261 09/05/26 By Smapmin 借貨償價出貨單也要可以登打
# Modify.........: No.TQC-960018 09/07/13 By lilingyu "單價,補貨數量,換貨數量,銷貨退回,折讓金額"欄位錄入負數沒有控管
# Modify.........: No.TQC-970420 09/08/06 By lilingyu 當ohc09客戶訂單單號為空時,點擊"出貨狀況"增加提示訊息
# Modify.........: No.FUN-980010 09/08/24 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-A10036 10/01/07 By sherry 單頭匯率沒有做負數控管
# Modify.........: No:FUN-9C0071 10/01/12 By huangrh 精簡程式
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A40041 10/04/20 By wujie     g_sys->AXM
# Modify.........: No.FUN-AA0059 10/10/25 By chenying 料號開窗控管
# Modify.........: No.TQC-AC0158 10/12/15 By baogc   將ACTION review修改為review1
# Modify.........: No.TQC-AC0007 10/12/17 By houlia 對ohc11增加控管
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80089 11/08/10 By minpp程序撰寫規範修改
# Modify.........: No:MOD-B80162 11/08/16 By Summer 輸入完出貨項次後,判斷訂單單號沒有資料時,改抓ogb31 
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C30085 12/07/04 By nanbing CR改串GR
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面
# Modify.........: No:TQC-D10021 13/01/06 By qirl 增加開窗
# Modify.........: No:FUN-D20025 13/01/19 By huangtao 將原本的「作廢」功能鍵拆為二個「作廢」/「取消作廢」 
# Modify.........: No:FUN-D30034 13/04/16 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_ohc           RECORD LIKE ohc_file.*,#(假單頭)
    g_ohc_t         RECORD LIKE ohc_file.*,#(舊值)
    g_ohc_o         RECORD LIKE ohc_file.*,#(舊值)
    g_ohc01_t       LIKE ohc_file.ohc01,   #(舊值)
    g_t1            LIKE oay_file.oayslip,              #No.FUN-550070        #No.FUN-680137 VARCHAR(05)
    g_ohd           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
          ohd02       LIKE ohd_file.ohd02,   #項次
          ohd03       LIKE ohd_file.ohd03    #客訴內容說明
                    END RECORD,
 
    g_ohd_t         RECORD                 #程式變數 (舊值)
        ohd02       LIKE ohd_file.ohd02,   #項次
        ohd03       LIKE ohd_file.ohd03    #客訴內容說明
                    END RECORD,
 
    g_ohd_o         RECORD                 #程式變數 (舊值)
        ohd02       LIKE ohd_file.ohd02,   #項次
        ohd03       LIKE ohd_file.ohd03    #客訴內容說明
                    END RECORD,
    g_argv1         LIKE ohd_file.ohd01,   #
     g_wc,g_wc2,g_sql  string,  #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680137 SMALLINT
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT        #No.FUN-680137 SMALLINT
    g_cmd           LIKE type_file.chr1000,       #No.FUN-680137  VARCHAR(100)
    p_row,p_col     LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
#主程式開始
DEFINE g_forupd_sql STRING  #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
DEFINE   g_chr2          LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680137  VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_jump         LIKE type_file.num10,         #No.FUN-680137 INTEGER
         mi_no_ask       LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE   g_argv2        STRING           #No.TQC-630066
MAIN
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP,
        FIELD ORDER FORM                   #整個畫面會依照p_per所設定的欄位順序(忽略4gl寫的順序)  #FUN-730018
 
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818 #NO.FUN-6A0094
        RETURNING g_time                  #NO.FUN-6A0094   
 
    LET g_argv1 = ARG_VAL(1)               #參數-1(詢價單號)
    LET g_argv2 = ARG_VAL(2)           #No.TQC-630066
 
    LET g_forupd_sql = "SELECT * FROM ohc_file WHERE ohc01 = ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t710_cl CURSOR FROM g_forupd_sql
 
    LET p_row = 2 LET p_col = 11
 
    OPEN WINDOW t710_w AT p_row,p_col      #顯示畫面
         WITH FORM "axm/42f/axmt710"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
 
    CALL t710_za()                         #將za的資料載入
    IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL t710_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL t710_a()
            END IF
         OTHERWISE
               CALL t710_q()
      END CASE
    END IF
 
    IF g_argv1 IS NOT NULL AND g_argv1 != ' ' THEN
       CALL t710_q()
    END IF
 
    WHILE TRUE
      LET g_action_choice = ""
      CALL t710_menu()
      IF g_action_choice = 'exit' THEN EXIT WHILE END IF
    END WHILE
 
    CLOSE WINDOW t710_w                      #結束畫面
      CALL cl_used(g_prog,g_time,2)         #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818 #NO.FUN-6A0094
         RETURNING g_time                    #NO.FUN-6A0094       
END MAIN
FUNCTION t710_za()
DEFINE l_za05 LIKE za_file.za05
END FUNCTION
 
 
#QBE 查詢資料
FUNCTION t710_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
   CALL g_ohd.clear()
 
    IF NOT cl_null(g_argv1) THEN   #NO:7140
        LET g_wc = " ohc01 = '",g_argv1,"'"
        LET g_wc2= " 1=1 "
    ELSE
        CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
   INITIALIZE g_ohc.* TO NULL    #No.FUN-750051
        CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
            ohc01,ohc04,ohc041,ohc05,ohc07,ohc09,ohc06,ohc061,
            ohc08,ohc081,ohc18,ohc02,ohc10,ohc11,ohc13,ohc14,
            ohc15,ohc16,ohc17,ohc181,ohc182,ohc183,ohc184,
            ohc03,ohcconf,
            ohcuser,ohcgrup,ohcmodu,ohcdate,
            ohcud01,ohcud02,ohcud03,ohcud04,ohcud05,
            ohcud06,ohcud07,ohcud08,ohcud09,ohcud10,
            ohcud11,ohcud12,ohcud13,ohcud14,ohcud15
 
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
        ON ACTION controlp
           CASE
            #TQC-D10021--add--star--
              WHEN INFIELD(ohc09)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_ohc09"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ohc09
                 NEXT FIELD ohc09
            #TQC-D10021--add--end---
               WHEN INFIELD(ohc01) #客訴單號  #MOD-4A0252
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_ohc1"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ohc01
                 NEXT FIELD ohc01
              WHEN INFIELD(ohc04) #原出貨單
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_oga"
                 LET g_qryparam.where = "( oga09='2'  OR oga09='3' OR oga09='4' OR oga09='6' OR oga09='8' OR (oga09='A' AND oga00 <> 'A'))"  #No.FUN-610020   #MOD-950261
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ohc04
                 NEXT FIELD ohc04
              WHEN INFIELD(ohc06) #客戶編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_occ"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ohc06
                 NEXT FIELD ohc06
              WHEN INFIELD(ohc08) #產品代號
#FUN-AA0059---------mod------------str-----------------              
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.state = "c"
#                 LET g_qryparam.form ="q_ima"
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                 DISPLAY g_qryparam.multiret TO ohc08
                 NEXT FIELD ohc08
              WHEN INFIELD(ohc10) #負責業務
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_gen"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ohc10
                 NEXT FIELD ohc10
              WHEN INFIELD(ohc11) #處理人員
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_gen"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ohc11
                 NEXT FIELD ohc11
              WHEN INFIELD(ohc15) #幣別
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_azi"
                 LET g_qryparam.default1 = g_ohc.ohc15
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ohc15
                 NEXT FIELD ohc15
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
                 ON ACTION qbe_select
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
        END CONSTRUCT
 
        IF INT_FLAG THEN RETURN END IF
 
        LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ohcuser', 'ohcgrup')
 
        CONSTRUCT g_wc2 ON ohd02,ohd03  #螢幕上取單身條件
             FROM s_ohd[1].ohd02,s_ohd[1].ohd03
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
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
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
        END CONSTRUCT
 
        IF INT_FLAG THEN RETURN END IF
    END IF
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
        LET g_sql = "SELECT  ohc01 FROM ohc_file ",
                    " WHERE ", g_wc CLIPPED,
                    " ORDER BY 1"
    ELSE					# 若單身有輸入條件
        LET g_sql = "SELECT UNIQUE ohc_file. ohc01 ",
                    "  FROM ohc_file, ohd_file ",
                    " WHERE ohc01 = ohd01",
                    "   AND ", g_wc  CLIPPED,
                    "   AND ", g_wc2 CLIPPED,
                    " ORDER BY 1"
    END IF
    PREPARE t710_prepare FROM g_sql
    DECLARE t710_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t710_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM ohc_file ",
                  " WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(*) FROM ohc_file,ohd_file ",
                  " WHERE ohd01 = ohc01 ",
                  "   AND ",g_wc  CLIPPED,
                  "   AND ",g_wc2 CLIPPED
    END IF
    PREPARE t710_precount FROM g_sql
    DECLARE t710_count CURSOR FOR t710_precount
END FUNCTION
 
FUNCTION t710_menu()
 
   WHILE TRUE
      CALL t710_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t710_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t710_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t710_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t710_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t710_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t710_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t710_y()
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t710_z()
            END IF
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t710_x(1)     #FUN-D20025 add
            END IF
         #FUN-D20025-----------sta
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t710_x(2)
            END IF
         #FUN-D20025-----------end
         WHEN "close_the_case"
            IF cl_chk_act_auth() THEN
               CALL t710_w()
            END IF
         WHEN "complant_reason"
            IF cl_chk_act_auth() THEN
               SELECT COUNT(*) INTO g_cnt FROM ohf_file
                  WHERE ohf01 = g_ohc.ohc01 AND ohf02 = '0'
               IF g_cnt <=0 THEN
                  INSERT INTO ohf_file(ohf01,ohf02) VALUES(g_ohc.ohc01,'0')
               END IF
               LET g_msg="axmt7101 '",g_ohc.ohc01,"'"," '0'"
               CALL cl_cmdrun_wait(g_msg CLIPPED)  #FUN-660216 add
            END IF
         WHEN "finding"
            IF cl_chk_act_auth() THEN
               SELECT COUNT(*) INTO g_cnt FROM ohf_file
                  WHERE ohf01 = g_ohc.ohc01 AND ohf02 = '1'
               IF g_cnt <=0 THEN
                  INSERT INTO ohf_file(ohf01,ohf02) VALUES(g_ohc.ohc01,'1')
               END IF
               LET g_msg="axmt7102 '",g_ohc.ohc01,"'"," '1'"
               CALL cl_cmdrun_wait(g_msg CLIPPED) #FUN-660216 add
            END IF
         WHEN "processed_counterplan_meliorative_counte"
            IF cl_chk_act_auth() THEN
               SELECT COUNT(*) INTO g_cnt FROM ohf_file
                  WHERE ohf01 = g_ohc.ohc01 AND ohf02 = '2'
               IF g_cnt <=0 THEN
                  INSERT INTO ohf_file(ohf01,ohf02) VALUES(g_ohc.ohc01,'2')
               END IF
               LET g_msg="axmt7103 '",g_ohc.ohc01,"'"," '2'"
               CALL cl_cmdrun_wait(g_msg CLIPPED)  #FUN-660216 add
            END IF
  #       WHEN "review"    #TQC-AC0158  MARK
         WHEN "review1"    #TQC-AC0158  ADD
            IF cl_chk_act_auth() THEN
               SELECT COUNT(*) INTO g_cnt FROM ohf_file
                  WHERE ohf01 = g_ohc.ohc01 AND ohf02 = '3'
               IF g_cnt <=0 THEN
                  INSERT INTO ohf_file(ohf01,ohf02) VALUES(g_ohc.ohc01,'3')
               END IF
               LET g_msg="axmt7104 '",g_ohc.ohc01,"'"," '3'"
               CALL cl_cmdrun_wait(g_msg CLIPPED)  #FUN-660216 add
            END IF
         WHEN "adjudicate"
            IF cl_chk_act_auth() THEN
               SELECT COUNT(*) INTO g_cnt FROM ohf_file
                  WHERE ohf01 = g_ohc.ohc01 AND ohf02 = '4'
               IF g_cnt <=0 THEN
                  INSERT INTO ohf_file(ohf01,ohf02) VALUES(g_ohc.ohc01,'4')
               END IF
               LET g_msg="axmt7105 '",g_ohc.ohc01,"'"," '4'"
               CALL cl_cmdrun_wait(g_msg CLIPPED)  #FUN-660216 add
            END IF
         WHEN "memo_closing"
            IF cl_chk_act_auth() THEN
               SELECT COUNT(*) INTO g_cnt FROM ohf_file
                  WHERE ohf01 = g_ohc.ohc01 AND ohf02 = '5'
               IF g_cnt <=0 THEN
                  INSERT INTO ohf_file(ohf01,ohf02) VALUES(g_ohc.ohc01,'5')
               END IF
               LET g_msg="axmt7106 '",g_ohc.ohc01,"'"," '5'"
               CALL cl_cmdrun_wait(g_msg CLIPPED)  #FUN-660216 add
            END IF
         WHEN "delivery_status"
             IF cl_chk_act_auth() THEN  
                IF cl_null(g_ohc.ohc09) THEN 
                   CALL cl_err('','axm-097',1)
                ELSE             	      
                  LET g_msg = "axmq410 '",g_ohc.ohc09,"' "
                  CALL cl_cmdrun(g_msg CLIPPED)
                END IF   #TQC-970420    
            END IF       
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ohd),'','')
            END IF
         WHEN "reproduce" #FUN-590008
            IF cl_chk_act_auth() THEN
               CALL t710_copy()
            END IF
 
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_ohc.ohc01 IS NOT NULL THEN
                LET g_doc.column1 = "ohc01"
                LET g_doc.value1 = g_ohc.ohc01
                CALL cl_doc()
             END IF 
          END IF
      END CASE
   END WHILE
 
END FUNCTION
 
#Add  輸入
FUNCTION t710_a()
DEFINE li_result LIKE type_file.num5                            #No.FUN-550070        #No.FUN-680137 SMALLINT
    MESSAGE ""
    CLEAR FORM
   CALL g_ohd.clear()
    IF s_shut(0) THEN RETURN END IF
    INITIALIZE g_ohc.* LIKE ohc_file.*             #DEFAULT 設定
    LET g_ohc01_t    = NULL
    LET g_ohc.ohc03  = '0'
    LET g_ohc.ohc11  = g_user
    LET g_ohc.ohc17  = 0
    LET g_ohc.ohc18  = 0
    LET g_ohc.ohc181 = 0
    LET g_ohc.ohc182 = 0
    LET g_ohc.ohc183 = 0
    LET g_ohc.ohc184 = 0
    LET g_ohc_t.* = g_ohc.*
    LET g_ohc_o.* = g_ohc.*
      IF NOT cl_null(g_argv1) AND (g_argv2 = "insert") THEN
         LET g_ohc.ohc01 = g_argv1
      END IF
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_ohc.ohcuser=g_user
        LET g_ohc.ohcoriu = g_user #FUN-980030
        LET g_ohc.ohcorig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_ohc.ohcgrup=g_grup
        LET g_ohc.ohcdate=g_today
        LET g_ohc.ohc02  =g_today
        LET g_ohc.ohcconf='N'           #資料未確認
        LET g_ohc.ohcplant = g_plant 
        LET g_ohc.ohclegal = g_legal 
        CALL t710_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            INITIALIZE g_ohc.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_ohc.ohc01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
 
        BEGIN WORK           #No:7829 add
#       CALL s_auto_assign_no(g_sys,g_ohc.ohc01,g_ohc.ohc02,"90","ohc_file","ohc01","","","")
        CALL s_auto_assign_no("axm",g_ohc.ohc01,g_ohc.ohc02,"90","ohc_file","ohc01","","","")   #No.FUN-A40041
          RETURNING li_result,g_ohc.ohc01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_ohc.ohc01
 
        INSERT INTO ohc_file VALUES (g_ohc.*)
        IF SQLCA.sqlcode THEN   			#置入資料庫不成功
            CALL cl_err3("ins","ohc_file",g_ohc.ohc01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
            ROLLBACK WORK   #No:7829
            CONTINUE WHILE
        END IF
        COMMIT WORK           #No:7829
        CALL cl_flow_notify(g_ohc.ohc01,'I')
 
        SELECT ohc01 INTO g_ohc.ohc01 FROM ohc_file
            WHERE ohc01 = g_ohc.ohc01
 
        LET g_ohc01_t = g_ohc.ohc01        #保留舊值
        LET g_ohc_t.* = g_ohc.*
        LET g_ohc_o.* = g_ohc.*
        CALL g_ohd.clear()
        LET g_rec_b=0
        CALL t710_b()                   #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t710_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_ohc.ohc01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_ohc.* FROM ohc_file
     WHERE ohc01=g_ohc.ohc01
 
    IF g_ohc.ohcconf ='Y' OR g_ohc.ohcconf = 'X' THEN
        #此筆資料已確認(作廢), 不可更改
        CALL cl_err(g_ohc.ohc01,'9022',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_ohc01_t = g_ohc.ohc01
 
    BEGIN WORK
 
    OPEN t710_cl USING g_ohc.ohc01
    IF STATUS THEN
       CALL cl_err("OPEN t710_cl:", STATUS, 1)
       CLOSE t710_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH t710_cl INTO g_ohc.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ohc.ohc01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE t710_cl
        ROLLBACK WORK
        RETURN
    END IF
    CALL t710_show()
    WHILE TRUE
        LET g_ohc01_t = g_ohc.ohc01
        LET g_ohc_o.* = g_ohc.*
        LET g_ohc.ohcmodu=g_user
        LET g_ohc.ohcdate=g_today
        CALL t710_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_ohc.*=g_ohc_t.*
            CALL t710_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_ohc.ohc01 != g_ohc01_t THEN            # 更改單號
            UPDATE ohd_file SET ohd01 = g_ohc.ohc01
                WHERE ohd01 = g_ohc01_t
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                CALL cl_err3("upd","ohd_file",g_ohc01_t,"",SQLCA.sqlcode,"","ohd",1)  #No.FUN-660167
                CONTINUE WHILE
            END IF
        END IF
        UPDATE ohc_file SET ohc_file.* = g_ohc.*
            WHERE ohc01 = g_ohc01_t
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","ohc_file",g_ohc01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
 
    CLOSE t710_cl
    COMMIT WORK
    CALL cl_flow_notify(g_ohc.ohc01,'U')
 
END FUNCTION
 
#處理INPUT
FUNCTION t710_i(p_cmd)
DEFINE
    l_n		LIKE type_file.num5,          #No.FUN-680137 SMALLINT
    p_cmd       LIKE type_file.chr1,                  #a:輸入 u:更改        #No.FUN-680137 VARCHAR(1)
    li_result   LIKE type_file.num5                  #No.FUN-550070        #No.FUN-680137 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    DISPLAY BY NAME
          g_ohc.ohc01,g_ohc.ohc04,g_ohc.ohc041,g_ohc.ohc06,g_ohc.ohc061,
          g_ohc.ohc08,g_ohc.ohc081,g_ohc.ohc10,g_ohc.ohc11,g_ohc.ohc13,g_ohc.ohc14,
          g_ohc.ohc18, g_ohc.ohc02,g_ohc.ohc05,g_ohc.ohc07,g_ohc.ohc09,g_ohc.ohc15,
          g_ohc.ohc16,g_ohc.ohc17,g_ohc.ohc03,
          g_ohc.ohc181,g_ohc.ohc182,g_ohc.ohc183,g_ohc.ohc184,
          g_ohc.ohcconf,g_ohc.ohcuser,g_ohc.ohcgrup,g_ohc.ohcmodu,
          g_ohc.ohcdate
 
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
    INPUT BY NAME g_ohc.ohcoriu,g_ohc.ohcorig,
          g_ohc.ohc01, g_ohc.ohc04,g_ohc.ohc041,
          g_ohc.ohc05,g_ohc.ohc07,g_ohc.ohc09,
          g_ohc.ohc06,g_ohc.ohc061,
          g_ohc.ohc08,g_ohc.ohc081,g_ohc.ohc18,g_ohc.ohc02,
          g_ohc.ohc10,g_ohc.ohc11,g_ohc.ohc13,g_ohc.ohc14,
          g_ohc.ohc15,g_ohc.ohc16,g_ohc.ohc17,
          g_ohc.ohc181,g_ohc.ohc182,g_ohc.ohc183,g_ohc.ohc184,
          g_ohc.ohc03,g_ohc.ohcconf,
          g_ohc.ohcuser,g_ohc.ohcgrup,g_ohc.ohcmodu,g_ohc.ohcdate,
          g_ohc.ohcud01,g_ohc.ohcud02,g_ohc.ohcud03,g_ohc.ohcud04,
          g_ohc.ohcud05,g_ohc.ohcud06,g_ohc.ohcud07,g_ohc.ohcud08,
          g_ohc.ohcud09,g_ohc.ohcud10,g_ohc.ohcud11,g_ohc.ohcud12,
          g_ohc.ohcud13,g_ohc.ohcud14,g_ohc.ohcud15 
        WITHOUT DEFAULTS
 
        BEFORE INPUT
          CALL cl_set_docno_format("ohc01")
          CALL cl_set_docno_format("ohc04")
          CALL cl_set_docno_format("ohc09")
 
        BEFORE FIELD ohc01    #本系統不允許修改key
        IF p_cmd = 'u'  AND g_chkey = 'N' THEN NEXT FIELD ohc04 END IF
 
        AFTER FIELD ohc01
            IF cl_null(g_ohc.ohc01) THEN
                NEXT FIELD ohc01
            END IF
#           CALL s_check_no(g_sys,g_ohc.ohc01,g_ohc_t.ohc01,"90","ohc_file","ohc01","")
            CALL s_check_no("axm",g_ohc.ohc01,g_ohc_t.ohc01,"90","ohc_file","ohc01","")   #No.FUN-A40041
              RETURNING li_result,g_ohc.ohc01
            DISPLAY BY NAME g_ohc.ohc01
            IF (NOT li_result) THEN
    	        NEXT FIELD ohc01
            END IF
 
        AFTER FIELD ohc04 #原出貨單號
            IF NOT cl_null(g_ohc.ohc04) THEN
                CALL t710_ohc04('a')
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_ohc.ohc04,g_errno,0)
                    NEXT FIELD ohc04
                ELSE
                    IF NOT cl_null(g_ohc.ohc06) THEN
                        CALL t710_ohc06('d')
                    END IF
                END IF
            END IF
        AFTER FIELD ohc041 #原出貨單項次
            IF NOT cl_null(g_ohc.ohc041) THEN
                CALL t710_ohc041('a')
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_ohc.ohc041,g_errno,0)
                    NEXT FIELD ohc041
                ELSE
                    IF NOT cl_null(g_ohc.ohc08) THEN
                        CALL t710_ohc08('d')
                    END IF
                END IF
            END IF
 
        AFTER FIELD ohc05
           IF NOT cl_null(g_ohc.ohc05) AND NOT cl_null(g_ohc.ohc02) THEN
              IF g_ohc.ohc05 > g_ohc.ohc02 THEN
                 CALL cl_err("","axm-053",0)
                 NEXT FIELD ohc05
              END IF
           END IF
 
        AFTER FIELD ohc02
           IF NOT cl_null(g_ohc.ohc05) AND NOT cl_null(g_ohc.ohc02) THEN
              IF g_ohc.ohc05 > g_ohc.ohc02 THEN
                 CALL cl_err("","axm-053",0)
                 NEXT FIELD ohc02
              END IF
           END IF
 
        AFTER FIELD ohc06 #客戶編號
            IF NOT cl_null(g_ohc.ohc06) THEN
                CALL t710_ohc06('a')
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_ohc.ohc06,g_errno,0)
                    NEXT FIELD ohc06
                END IF
                IF cl_null(g_ohc.ohc15) THEN
                   SELECT occ42 INTO g_ohc.ohc15 FROM occ_file
                      WHERE occ01 = g_ohc.ohc06     
                   DISPLAY BY NAME g_ohc.ohc15
                   SELECT rmz15 INTO g_rmz.rmz15 FROM rmz_file
                   CALL s_curr3(g_ohc.ohc15,g_ohc.ohc02,g_rmz.rmz15) 
                        RETURNING g_ohc.ohc16
                   DISPLAY BY NAME g_ohc.ohc16
                END IF 
            END IF
        AFTER FIELD ohc08 #產品編號
            IF NOT cl_null(g_ohc.ohc08) THEN
#FUN-AA0059 ---------------------start----------------------------
               IF NOT s_chk_item_no(g_ohc.ohc08,"") THEN
                  CALL cl_err('',g_errno,1)
                  LET g_ohc.ohc08= g_ohc_t.ohc08 
                  NEXT FIELD ohc08
               END IF
#FUN-AA0059 ---------------------end-------------------------------
                CALL t710_ohc08('a')
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_ohc.ohc08,g_errno,0)
                    NEXT FIELD ohc08
                END IF
            END IF
        AFTER FIELD ohc10 #負責業務
            IF NOT cl_null(g_ohc.ohc10) THEN
                CALL t710_ohc10('a')
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_ohc.ohc10,g_errno,0)
                    NEXT FIELD ohc10
                END IF
            END IF
        
        AFTER FIELD ohc11   #TQC-AC0007
            IF NOT cl_null(g_ohc.ohc11) THEN
                CALL t710_ohc11('a')
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_ohc.ohc11,g_errno,0)
                    NEXT FIELD ohc11
                END IF
            END IF
        AFTER FIELD ohc15 #幣別
            IF NOT cl_null(g_ohc.ohc15) THEN
                SELECT COUNT(*) INTO l_n  FROM azi_file
                 WHERE azi01 = g_ohc.ohc15
                   AND aziacti = 'Y'  #No.TQC-6B0117
                IF l_n = 0 THEN                            #No.TQC-6B0117
                   CALL cl_err(g_ohc.ohc15,'aap-002',0)    #No.TQC-6B0117
                    NEXT FIELD ohc15
                END IF
                SELECT rmz15 INTO g_rmz.rmz15 FROM rmz_file
                CALL s_curr3(g_ohc.ohc15,g_ohc.ohc02,g_rmz.rmz15) 
                     RETURNING g_ohc.ohc16
                DISPLAY BY NAME g_ohc.ohc16
            END IF
 
        AFTER FIELD ohc17
          IF NOT cl_null(g_ohc.ohc17) THEN 
             IF g_ohc.ohc17 < 0 THEN 
                CALL cl_err('','asf-209',0)
                NEXT FIELD ohc17
             END IF 
          END IF 
          
        AFTER FIELD ohc181 
          IF NOT cl_null(g_ohc.ohc181) THEN 
             IF g_ohc.ohc181 < 0 THEN 
                CALL cl_err('','asf-209',0)
                NEXT FIELD ohc181
             END IF 
          END IF 
                  
        AFTER FIELD ohc182
          IF NOT cl_null(g_ohc.ohc182) THEN 
             IF g_ohc.ohc182 < 0 THEN 
                CALL cl_err('','asf-209',0)
                NEXT FIELD ohc182
             END IF 
          END IF 
                  
        AFTER FIELD ohc183
          IF NOT cl_null(g_ohc.ohc183) THEN 
             IF g_ohc.ohc183 < 0 THEN 
                CALL cl_err('','asf-209',0)
                NEXT FIELD ohc183
             END IF 
          END IF 
                  
        AFTER FIELD ohc184
          IF NOT cl_null(g_ohc.ohc184) THEN 
             IF g_ohc.ohc184 < 0 THEN 
                CALL cl_err('','asf-209',0)
                NEXT FIELD ohc184
             END IF 
          END IF         
 
        AFTER FIELD ohc18  #客訴數量 
            IF NOT cl_null(g_ohc.ohc18) THEN
               IF g_ohc.ohc18 < 0 THEN
                  CALL cl_err(g_ohc.ohc18,'afa-043',0)
                  NEXT FIELD ohc18
               END IF
            END IF
 
        AFTER FIELD ohc16     #匯率
           IF g_ohc.ohc16 <= 0 THEN
              CALL cl_err(g_ohc.ohc16,'axm4011',0)
              NEXT FIELD ohc16
           END IF
            IF g_ohc.ohc15 =g_aza.aza17 THEN
               LET g_ohc.ohc16 =1
               DISPLAY g_ohc.ohc16  TO ohc16
            END IF
        AFTER FIELD ohcud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ohcud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ohcud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ohcud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ohcud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ohcud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ohcud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ohcud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ohcud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ohcud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ohcud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ohcud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ohcud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ohcud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ohcud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION controlp
           CASE
            #TQC-D10021--add--star--
              WHEN INFIELD(ohc09)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_ohc09"
                   LET g_qryparam.default1 = g_ohc.ohc09
                   CALL cl_create_qry() RETURNING g_ohc.ohc09
                   DISPLAY BY NAME g_ohc.ohc09
                   NEXT FIELD ohc09
            #TQC-D10021--add--end---
              WHEN INFIELD(ohc01) #單據編號
                   LET g_t1 = s_get_doc_no(g_ohc.ohc01)    #No.FUN-550070
                   CALL q_oay(FALSE,FALSE,g_t1,'90','AXM') RETURNING g_t1   #TQC-670008
                   LET g_ohc.ohc01=g_t1                    #No.FUN-550070
                   DISPLAY BY NAME g_ohc.ohc01
                   NEXT FIELD ohc01
              WHEN INFIELD(ohc04) #原出貨單
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_ogb04"
                   LET g_qryparam.default1 = g_ohc.ohc04
                   LET g_qryparam.default2 = g_ohc.ohc041
                   LET g_qryparam.where = "( oga09='2'  OR oga09='3' OR oga09='4' OR oga09='6' OR oga09='8' OR (oga09='A' AND oga00 <> 'A'))"  #No.FUN-610020   #MOD-950261
                   CALL cl_create_qry() RETURNING g_ohc.ohc04,g_ohc.ohc041
                   DISPLAY BY NAME g_ohc.ohc04,g_ohc.ohc041
                   NEXT FIELD ohc04
              WHEN INFIELD(ohc06) #客戶編號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_occ"
                   LET g_qryparam.default1 = g_ohc.ohc06
                   CALL cl_create_qry() RETURNING g_ohc.ohc06
                   DISPLAY BY NAME g_ohc.ohc06
                   NEXT FIELD ohc06
              WHEN INFIELD(ohc08) #產品代號
#FUN-AA0059---------mod------------str-----------------              
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.form ="q_ima"
#                   LET g_qryparam.default1 = g_ohc.ohc08
#                   CALL cl_create_qry() RETURNING g_ohc.ohc08
                   CALL q_sel_ima(FALSE, "q_ima","",g_ohc.ohc08,"","","","","",'' ) 
                        RETURNING  g_ohc.ohc08

#FUN-AA0059---------mod------------end-----------------
                   DISPLAY BY NAME g_ohc.ohc08
                   NEXT FIELD ohc08
              WHEN INFIELD(ohc10) #負責業務
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gen"
                   LET g_qryparam.default1 = g_ohc.ohc10
                   CALL cl_create_qry() RETURNING g_ohc.ohc10
                   DISPLAY BY NAME g_ohc.ohc10
                   NEXT FIELD ohc10
              WHEN INFIELD(ohc11) #處理人員
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gen"
                   LET g_qryparam.default1 = g_ohc.ohc11
                   CALL cl_create_qry() RETURNING g_ohc.ohc11
                   DISPLAY BY NAME g_ohc.ohc11
                   NEXT FIELD ohc11
              WHEN INFIELD(ohc15) #幣別
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_azi"
                   LET g_qryparam.default1 = g_ohc.ohc15
                   CALL cl_create_qry() RETURNING g_ohc.ohc15
                   DISPLAY BY NAME g_ohc.ohc15
                   NEXT FIELD ohc15
              WHEN INFIELD(ohc16)
                   CALL s_rate(g_ohc.ohc15,g_ohc.ohc16) RETURNING g_ohc.ohc16
                   DISPLAY BY NAME g_ohc.ohc16
                   NEXT FIELD ohc16
              OTHERWISE EXIT CASE
           END CASE
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
END FUNCTION
 
FUNCTION t710_ohc04(p_cmd)  #原出貨單號
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
           l_ogaconf LIKE oga_file.ogaconf,
           l_gen02_1 LIKE gen_file.gen02
 
    LET g_errno = " "
    SELECT oga02,oga03,oma10,oga16,
           oga14,oga23,oga24,gen02
      INTO g_ohc.ohc05,g_ohc.ohc06,g_ohc.ohc07,g_ohc.ohc09,
           g_ohc.ohc10,g_ohc.ohc15,g_ohc.ohc16,l_gen02_1
      FROM oga_file,OUTER oma_file,OUTER gen_file
     WHERE oga01 = g_ohc.ohc04
       AND oga_file.oga10 = oma_file.oma01
       AND gen_file.gen01 = oga_file.oga14
       AND oga09 IN ('2','3','4','6','8','A') #NO:7140  #No.FUN-610020   #MOD-950261 add
       AND oga00 <> 'A'   #MOD-950261 add
                         AND oga65='N'     #No.FUN-610020
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = '100'
         WHEN l_ogaconf='X' LET g_errno = '9024'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
        DISPLAY BY NAME
                       g_ohc.ohc05,g_ohc.ohc06,g_ohc.ohc07,g_ohc.ohc09,
                       g_ohc.ohc10,g_ohc.ohc15,g_ohc.ohc16
        DISPLAY l_gen02_1 TO FORMONLY.gen02_1
    END IF
END FUNCTION
 
FUNCTION t710_ohc041(p_cmd)  #原出貨單項次
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
           l_ogaconf LIKE oga_file.ogaconf,
           l_ima021  LIKE ima_file.ima021
 
    LET g_errno = " "
    SELECT ogb04,ogb06,ogb13,ogb31 #MOD-B80162 add ogb31
      INTO g_ohc.ohc08,g_ohc.ohc081,g_ohc.ohc17,g_ohc.ohc09 #MOD-B80162 add ohc09
      FROM ogb_file
     WHERE ogb01 = g_ohc.ohc04
       AND ogb03 = g_ohc.ohc041
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = '100'
         WHEN l_ogaconf='X' LET g_errno = '9024'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
        DISPLAY BY NAME
            g_ohc.ohc08,g_ohc.ohc081,g_ohc.ohc17,g_ohc.ohc09 #MOD-B80162 add ohc09
    END IF
END FUNCTION
FUNCTION t710_ohc06(p_cmd)  #客戶編號
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
           l_occacti LIKE occ_file.occacti
 
    LET g_errno = " "
    SELECT occ02
      INTO g_ohc.ohc061
      FROM occ_file
     WHERE occ01 = g_ohc.ohc06
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = '100'
         WHEN l_occacti='N' LET g_errno = '9028'
         WHEN l_occacti MATCHES '[PH]'  LET g_errno = '9038'  #NO.FUN690023 add
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
        DISPLAY BY NAME g_ohc.ohc061
    END IF
END FUNCTION
 
FUNCTION t710_ohc08(p_cmd)  #產品編號
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
           l_imaacti LIKE ima_file.imaacti,
            l_ima02   LIKE ima_file.ima02 ,  #MOD-510096
           l_ima021  LIKE ima_file.ima021
 
    LET g_errno = " "
    SELECT ima02,ima021
      INTO l_ima02,l_ima021
      FROM ima_file
     WHERE ima01 = g_ohc.ohc08
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = '100'
         WHEN l_imaacti='N' LET g_errno = '9028'
         WHEN l_imaacti MATCHES '[PH]'  LET g_errno = '9038'  #NO.FUN-690022 add
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    LET g_ohc.ohc081=l_ima02
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
        DISPLAY g_ohc.ohc081 TO ohc081
        DISPLAY l_ima021 TO FORMONLY.ima021
    END IF
END FUNCTION
FUNCTION t710_ohc10(p_cmd)  #負責業務
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
           l_genacti LIKE gen_file.genacti,
           l_gen02_1 LIKE gen_file.gen02
 
    LET g_errno = " "
    SELECT gen02,genacti
      INTO l_gen02_1,l_genacti
      FROM gen_file
     WHERE gen01 = g_ohc.ohc10
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = '100'
         WHEN l_genacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
        DISPLAY l_gen02_1 TO FORMONLY.gen02_1
    END IF
END FUNCTION
FUNCTION t710_ohc11(p_cmd)  #處理人員
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
           l_genacti LIKE gen_file.genacti,
           l_gen02_2 LIKE gen_file.gen02
 
    LET g_errno = " "
    SELECT gen02,genacti
      INTO l_gen02_2,l_genacti
      FROM gen_file
     WHERE gen01 = g_ohc.ohc11
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = '100'
         WHEN l_genacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
        DISPLAY l_gen02_2 TO FORMONLY.gen02_2
    END IF
END FUNCTION
 
#Query 查詢
FUNCTION t710_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
   CALL g_ohd.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t710_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_ohc.* TO NULL
        RETURN
    END IF
    OPEN t710_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_ohc.* TO NULL
    ELSE
       OPEN t710_count
       FETCH t710_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL t710_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION t710_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680137 VARCHAR(1)
    g_jump          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680137 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t710_cs INTO g_ohc.ohc01
        WHEN 'P' FETCH PREVIOUS t710_cs INTO g_ohc.ohc01
        WHEN 'F' FETCH FIRST    t710_cs INTO g_ohc.ohc01
        WHEN 'L' FETCH LAST     t710_cs INTO g_ohc.ohc01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
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
            LET mi_no_ask = FALSE
            FETCH ABSOLUTE g_jump t710_cs INTO g_ohc.ohc01
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ohc.ohc01,SQLCA.sqlcode,0)
        INITIALIZE g_ohc.ohc01 TO NULL         #No.FUN-6A0020
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
    SELECT * INTO g_ohc.* FROM ohc_file WHERE ohc01 = g_ohc.ohc01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","ohc_file",g_ohc.ohc01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
        INITIALIZE g_ohc.* TO NULL
        RETURN
    END IF
    LET g_data_owner = g_ohc.ohcuser      #FUN-4C0057 add
    LET g_data_group = g_ohc.ohcgrup      #FUN-4C0057 add
    LET g_data_plant = g_ohc.ohcplant #FUN-980030
    CALL t710_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t710_show()
    LET g_ohc_t.* = g_ohc.*                #保存單頭舊值
    LET g_ohc_o.* = g_ohc.*                #保存單頭舊值
    DISPLAY BY NAME g_ohc.ohcoriu,g_ohc.ohcorig,                              # 顯示單頭值
          g_ohc.ohc01,g_ohc.ohc04,g_ohc.ohc041,g_ohc.ohc06,g_ohc.ohc061,
          g_ohc.ohc08,g_ohc.ohc081,g_ohc.ohc10,g_ohc.ohc11,g_ohc.ohc18,
          g_ohc.ohc02,g_ohc.ohc05,g_ohc.ohc07,g_ohc.ohc09,g_ohc.ohc15,
          g_ohc.ohc16,g_ohc.ohc17,g_ohc.ohc03,g_ohc.ohc13,g_ohc.ohc14,
          g_ohc.ohc181,g_ohc.ohc182,g_ohc.ohc183,g_ohc.ohc184,
          g_ohc.ohcconf,g_ohc.ohcuser,g_ohc.ohcgrup,g_ohc.ohcmodu,
          g_ohc.ohcdate,
          g_ohc.ohcud01,g_ohc.ohcud02,g_ohc.ohcud03,g_ohc.ohcud04,
          g_ohc.ohcud05,g_ohc.ohcud06,g_ohc.ohcud07,g_ohc.ohcud08,
          g_ohc.ohcud09,g_ohc.ohcud10,g_ohc.ohcud11,g_ohc.ohcud12,
          g_ohc.ohcud13,g_ohc.ohcud14,g_ohc.ohcud15
 
 
    #CKP
    IF g_ohc.ohcconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    IF g_ohc.ohc03  ='2' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
    CALL cl_set_field_pic(g_ohc.ohcconf,"","",g_chr2,g_chr,"")
 
    CALL t710_ohc06('d')
    CALL t710_ohc08('d')
    CALL t710_ohc10('d')
    CALL t710_ohc11('d')
    CALL t710_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t710_x(p_type) #作廢/取消作废
DEFINE p_type    LIKE type_file.chr1   #FUN-D20025 add '1' 作废  '2' 取消作废

    IF s_shut(0) THEN RETURN END IF
    SELECT * INTO g_ohc.* FROM ohc_file WHERE ohc01=g_ohc.ohc01
    IF g_ohc.ohc01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
    #FUN-D20025 ----------sta
    IF p_type = 1 THEN
       IF g_ohc.ohcconf='X' THEN RETURN END IF
    ELSE
       IF g_ohc.ohcconf<>'X' THEN RETURN END IF
    END IF
    #FUN-D20025 ----------end 
    IF g_ohc.ohcconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
    LET g_success = 'Y'
 
    BEGIN WORK
 
    OPEN t710_cl USING g_ohc.ohc01
    IF STATUS THEN
       CALL cl_err("OPEN t710_cl:", STATUS, 1)
       CLOSE t710_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH t710_cl INTO g_ohc.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ohc.ohc01,SQLCA.sqlcode,0)          #資料被他人LOCK
        CLOSE t710_cl ROLLBACK WORK RETURN
    END IF
    CALL t710_show()
    IF cl_void(0,0,g_ohc.ohcconf) THEN                   #確認一下
        LET g_chr=g_ohc.ohcconf
        IF g_ohc.ohcconf='N' THEN
            LET g_ohc.ohcconf='X'
        ELSE
            LET g_ohc.ohcconf='N'
        END IF
        UPDATE ohc_file SET                   #更改有效碼
               ohcconf=g_ohc.ohcconf,
               ohcmodu=g_user,
               ohcdate=g_today
         WHERE ohc01=g_ohc.ohc01
        IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","ohc_file",g_ohc.ohc01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
            LET g_ohc.ohcconf=g_chr
            LET g_success = 'N'
        END IF
    END IF
    CLOSE t710_cl
    IF g_success = 'Y' THEN
       COMMIT WORK
 
 
       CALL cl_flow_notify(g_ohc.ohc01,'V')
    ELSE
       ROLLBACK WORK
    END IF
 
    SELECT ohcconf,ohcmodu,ohcdate
      INTO g_ohc.ohcconf,g_ohc.ohcmodu,g_ohc.ohcdate FROM ohc_file
     WHERE ohc01=g_ohc.ohc01
    DISPLAY BY NAME g_ohc.ohcconf,g_ohc.ohcmodu,g_ohc.ohcdate
    #CKP
    IF g_ohc.ohcconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    IF g_ohc.ohc03  ='2' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
    CALL cl_set_field_pic(g_ohc.ohcconf,"","",g_chr2,g_chr,"")
 
END FUNCTION
 


FUNCTION t710_w() #結案
DEFINE l_ohc14    LIKE ohc_file.ohc14,
       l_yn       LIKE type_file.chr1        # No.FUN-680137  VARCHAR(01)
    IF s_shut(0) THEN RETURN END IF
    SELECT * INTO g_ohc.* FROM ohc_file WHERE ohc01=g_ohc.ohc01
    IF g_ohc.ohc01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
    IF g_ohc.ohcconf != 'Y' THEN CALL cl_err('',9026,0) RETURN END IF
    IF g_ohc.ohc03 = '0' THEN CALL cl_err('','mfg6060',0) RETURN END IF
    LET g_success = 'Y'
 
    BEGIN WORK
 
    OPEN t710_cl USING g_ohc.ohc01
    IF STATUS THEN
       CALL cl_err("OPEN t710_cl:", STATUS, 1)
       CLOSE t710_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH t710_cl INTO g_ohc.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ohc.ohc01,SQLCA.sqlcode,0)          #資料被他人LOCK
        CLOSE t710_cl ROLLBACK WORK RETURN
    END IF
    CALL t710_show()
    IF g_ohc.ohc03 = '2' THEN
        LET l_yn = 'Y'
    ELSE
        LET l_yn = 'N'
    END IF
     IF cl_close(0,0,l_yn) THEN                   #確認一下
        LET g_chr=g_ohc.ohc03
        LET l_ohc14=g_ohc.ohc14
        IF g_ohc.ohc03 ='1' THEN #已處理
            LET g_ohc.ohc03 ='2'  #結案
            LET g_ohc.ohc14 = g_today
        ELSE
            LET g_ohc.ohc03 ='1'  #已處理
            LET g_ohc.ohc14 = ''
        END IF
        UPDATE ohc_file SET                   #更改有效碼
               ohc03=g_ohc.ohc03,
               ohc14=g_ohc.ohc14,
               ohcmodu=g_user,
               ohcdate=g_today
         WHERE ohc01=g_ohc.ohc01
        IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","ohc_file",g_ohc.ohc01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
            LET g_ohc.ohc03=g_chr
            LET g_ohc.ohc14=l_ohc14
            LET g_success = 'N'
        END IF
    END IF
    CLOSE t710_cl
    IF g_success = 'Y' THEN
       COMMIT WORK
       CALL cl_flow_notify(g_ohc.ohc01,'S')
    ELSE
       ROLLBACK WORK
    END IF
    SELECT *
      INTO g_ohc.* FROM ohc_file
     WHERE ohc01=g_ohc.ohc01
    DISPLAY BY NAME g_ohc.ohc03,g_ohc.ohc14,g_ohc.ohcmodu,g_ohc.ohcdate
    #CKP
    IF g_ohc.ohcconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    IF g_ohc.ohc03  ='2' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
    CALL cl_set_field_pic(g_ohc.ohcconf,"","",g_chr2,g_chr,"")
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION t710_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_ohc.ohc01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    SELECT * INTO g_ohc.* FROM ohc_file
     WHERE ohc01=g_ohc.ohc01
    IF g_ohc.ohcconf !='N' THEN
        #此筆資料已確認(作廢), 不可取消
        CALL cl_err(g_ohc.ohc01,'9021',0)
        RETURN
    END IF
 
    BEGIN WORK
 
    OPEN  t710_cl USING g_ohc.ohc01
    #--Add exception check during OPEN CURSOR
    IF STATUS THEN
       CALL cl_err("OPEN t710_cl:", STATUS, 1)
       CLOSE t710_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t710_cl INTO g_ohc.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ohc.ohc01,SQLCA.sqlcode,0)          #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    CALL t710_show()
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "ohc01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_ohc.ohc01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
       DELETE FROM ohc_file WHERE ohc01 = g_ohc.ohc01
       IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err3("del","ohc_file",g_ohc.ohc01,"",'',"","No ohc deleted",1)  #No.FUN-660167
          ROLLBACK WORK
          RETURN
       END IF
       DELETE FROM ohd_file WHERE ohd01 = g_ohc.ohc01
       DELETE FROM ohf_file WHERE ohf01 = g_ohc.ohc01 #BugNo:6500
       DELETE FROM ohe_file WHERE ohe01 = g_ohc.ohc01
       DELETE FROM ohg_file WHERE ohg01 = g_ohc.ohc01
       CLEAR FORM
       CALL g_ohd.clear()
       INITIALIZE g_ohc.* TO NULL
       OPEN t710_count
       #FUN-B50064-add-start--
       IF STATUS THEN
          CLOSE t710_cs
          CLOSE t710_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end--
       FETCH t710_count INTO g_row_count
       #FUN-B50064-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t710_cs
          CLOSE t710_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t710_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t710_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL t710_fetch('/')
       END IF
 
    END IF
 
    CLOSE t710_cl
    COMMIT WORK
 
    CALL cl_flow_notify(g_ohc.ohc01,'D')
 
END FUNCTION
 
#單身
FUNCTION t710_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680137 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680137 SMALLINT
    l_cnt           LIKE type_file.num5,                #檢查重複用        #No.FUN-680137 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680137 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680137 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680137 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680137 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_ohc.ohc01 IS NULL THEN
        RETURN
    END IF
    SELECT * INTO g_ohc.* FROM ohc_file
     WHERE ohc01=g_ohc.ohc01
    IF g_ohc.ohcconf != 'N' THEN
        #此筆資料已確認(作廢), 不可更改
        CALL cl_err(g_ohc.ohc01,'9022',0)
        RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT ohd02,ohd03 ", 
                       " FROM ohd_file",
                       " WHERE ohd01= ? AND ohd02= ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t710_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_ohd WITHOUT DEFAULTS FROM s_ohd.*
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
 
            BEGIN WORK
 
            OPEN t710_cl USING g_ohc.ohc01
            IF STATUS THEN
               CALL cl_err("OPEN t710_cl:", STATUS, 1)
               CLOSE t710_cl
               ROLLBACK WORK
               RETURN
            END IF
 
            FETCH t710_cl INTO g_ohc.*            # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
                CALL cl_err(g_ohc.ohc01,SQLCA.sqlcode,0)      # 資料被他人LOCK
                CLOSE t710_cl
                ROLLBACK WORK
                RETURN
            END IF
 
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_ohd_t.* = g_ohd[l_ac].*  #BACKUP
                LET g_ohd_o.* = g_ohd[l_ac].*  #BACKUP
 
                OPEN t710_bcl USING g_ohc.ohc01, g_ohd_t.ohd02
                IF STATUS THEN
                   CALL cl_err("OPEN t710_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH t710_bcl INTO g_ohd[l_ac].*
                   IF SQLCA.sqlcode THEN
                      CALL cl_err(g_ohd_t.ohd02,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_ohd[l_ac].* TO NULL
            LET g_ohd_t.* = g_ohd[l_ac].*         #新輸入資料
            LET g_ohd_o.* = g_ohd[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD ohd02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO ohd_file(ohd01,ohd02,ohd03,ohdplant,ohdlegal)  #FUN980010 add plant & legal 
                          VALUES(g_ohc.ohc01,g_ohd[l_ac].ohd02,
                                 g_ohd[l_ac].ohd03,g_plant,g_legal)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","ohd_file",g_ohc.ohc01,g_ohd[l_ac].ohd02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
               COMMIT WORK
            END IF
 
        BEFORE FIELD ohd02                        #default 序號
            IF g_ohd[l_ac].ohd02 IS NULL OR
               g_ohd[l_ac].ohd02 = 0 THEN
                SELECT MAX(ohd02)+1 INTO g_ohd[l_ac].ohd02 FROM ohd_file
                 WHERE ohd01 = g_ohc.ohc01
                IF cl_null(g_ohd[l_ac].ohd02) THEN
                   LET g_ohd[l_ac].ohd02 = 1
                END IF
            END IF
 
        AFTER FIELD ohd02                        #check 序號是否重複
            IF NOT cl_null(g_ohd[l_ac].ohd02) THEN
               IF g_ohd[l_ac].ohd02 != g_ohd_t.ohd02 OR
                  cl_null(g_ohd_t.ohd02) THEN
                   SELECT COUNT(*) INTO l_n FROM ohd_file
                    WHERE ohd01 = g_ohc.ohc01
                      AND ohd02 = g_ohd[l_ac].ohd02
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_ohd[l_ac].ohd02 = g_ohd_t.ohd02
                       NEXT FIELD ohd02
                   END IF
               END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_ohd_t.ohd02 > 0 AND
               g_ohd_t.ohd02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
 
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
 
                DELETE FROM ohd_file
                 WHERE ohd01 = g_ohc.ohc01
                   AND ohd02 = g_ohd_t.ohd02
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","ohd_file",g_ohc.ohc01,g_ohd_t.ohd02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                COMMIT WORK
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_ohd[l_ac].* = g_ohd_t.*
               CLOSE t710_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_ohd[l_ac].ohd02,-263,1)
               LET g_ohd[l_ac].* = g_ohd_t.*
            ELSE
               UPDATE ohd_file SET ohd02=g_ohd[l_ac].ohd02,
                                   ohd03=g_ohd[l_ac].ohd03
                WHERE ohd01=g_ohc.ohc01
                  AND ohd02=g_ohd_t.ohd02
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","ohd_file",g_ohc.ohc01,g_ohd_t.ohd02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                  LET g_ohd[l_ac].* = g_ohd_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac      #FUN-D30034 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_ohd[l_ac].* = g_ohd_t.*
               #FUN-D30034--add--str--
               ELSE
                  CALL g_ohd.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end--
               END IF
               CLOSE t710_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac      #FUN-D30034 Add
            CLOSE t710_bcl
            COMMIT WORK
 
        ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(ohd02) AND l_ac > 1 THEN
                LET g_ohd[l_ac].* = g_ohd[l_ac-1].*
                NEXT FIELD ohd02
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
 
 
    END INPUT
 
     LET g_ohc.ohcmodu = g_user
     LET g_ohc.ohcdate = g_today
     UPDATE ohc_file SET ohcmodu = g_ohc.ohcmodu,ohcdate = g_ohc.ohcdate
      WHERE ohc01 = g_ohc.ohc01
     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
        CALL cl_err3("upd","ohc_file",g_ohc.ohc01,"",SQLCA.SQLCODE,"","upd ohc",1)  #No.FUN-660167
     END IF
     DISPLAY BY NAME g_ohc.ohcmodu,g_ohc.ohcdate
 
    CLOSE t710_bcl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION t710_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680137  VARCHAR(200)
 
    CONSTRUCT l_wc2 ON ohd02,ohd03
            FROM s_ohd[1].ohd02,s_ohd[1].ohd03
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
    CALL t710_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t710_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680137  VARCHAR(200)
 
    IF cl_null(p_wc2) THEN
       LET p_wc2=" 1=1  "
    END IF
 
    LET g_sql = "SELECT ohd02,ohd03 ",
                "  FROM ohd_file",
                " WHERE ohd01 ='",g_ohc.ohc01,"'", #單頭
                "   AND ", p_wc2 CLIPPED,
                " ORDER BY 1,2"
    PREPARE t710_pb FROM g_sql
    DECLARE ohd_cs                       #CURSOR
        CURSOR FOR t710_pb
 
    CALL g_ohd.clear()
 
    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH ohd_cs INTO g_ohd[g_cnt].*   #單身 ARRAY 填充
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
    CALL g_ohd.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t710_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ohd TO s_ohd.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
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
         CALL t710_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t710_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t710_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t710_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t710_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
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
         #CKP
         IF g_ohc.ohcconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
         IF g_ohc.ohc03  ='2' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
         CALL cl_set_field_pic(g_ohc.ohcconf,"","",g_chr2,g_chr,"")
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
#@    ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
#@    ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
#@    ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #FUN-D20025 ------------sta
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #FUN-D20025 ------------end
#@    ON ACTION 結案
      ON ACTION close_the_case
         LET g_action_choice="close_the_case"
         EXIT DISPLAY
#@    ON ACTION 客訴原因
      ON ACTION complant_reason
         LET g_action_choice="complant_reason"
         EXIT DISPLAY
#@    ON ACTION 調查結果
      ON ACTION finding
         LET g_action_choice="finding"
         EXIT DISPLAY
#@    ON ACTION 處理對策及改善對策
      ON ACTION processed_counterplan_meliorative_counte
         LET g_action_choice="processed_counterplan_meliorative_counte"
         EXIT DISPLAY
#@    ON ACTION 審核
#      ON ACTION review      #TQC-AC0158 MARK
      ON ACTION review1      #TQC-AC0158 ADD
#         LET g_action_choice="review"    #TQC-AC0158 MARK
         LET g_action_choice ="review1"   #TQC-AC0158 ADD
         EXIT DISPLAY
#@    ON ACTION 核決
      ON ACTION adjudicate
         LET g_action_choice="adjudicate"
         EXIT DISPLAY
#@    ON ACTION 結案註記
      ON ACTION memo_closing
         LET g_action_choice="memo_closing"
         EXIT DISPLAY
#@    ON ACTION 出貨狀況
      ON ACTION delivery_status
         LET g_action_choice="delivery_status"
         EXIT DISPLAY
 
   ON ACTION accept
      LET g_action_choice="detail"
      LET l_ac = ARR_CURR()
      EXIT DISPLAY
 
   ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
      LET g_action_choice="exit"
      EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel       #FUN-4B0038
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      ON ACTION reproduce #FUN-590008
         LET g_action_choice = 'reproduce'
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6A0020  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
      AFTER DISPLAY
         CONTINUE DISPLAY
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
 
FUNCTION t710_y() # 確認when g_ohc.ohcconf='N' (Turn to 'Y')
   DEFINE g_start,g_end         LIKE faj_file.faj02        # No.FUN-680137 VARCHAR(10)
   DEFINE l_cnt                 LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
#CHI-C30107 ---------------------- add -------------------- begin
   IF g_ohc.ohcconf='Y' THEN RETURN END IF
   IF g_ohc.ohcconf = 'X' THEN CALL cl_err(g_ohc.ohc01,'9024',0) RETURN END IF
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
#CHI-C30107 ---------------------- add -------------------- end
   SELECT * INTO g_ohc.* FROM ohc_file WHERE ohc01 = g_ohc.ohc01
   IF g_ohc.ohcconf='Y' THEN RETURN END IF
   IF g_ohc.ohcconf = 'X' THEN CALL cl_err(g_ohc.ohc01,'9024',0) RETURN END IF
 
#---BUGNO:7379---無單身資料不可確認
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM ohd_file
    WHERE ohd01=g_ohc.ohc01
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
 
#TQC-AC0007  --add
   IF NOT cl_null(g_ohc.ohc11) THEN
      CALL t710_ohc11('a')
      IF NOT cl_null(g_errno) THEN
          CALL cl_err(g_ohc.ohc11,g_errno,0)
      END IF
   END IF
#TQC-AC0007  --end 
#  IF NOT cl_confirm('axm-108') THEN RETURN END IF #CHI-C30107 mark
 
   BEGIN WORK
 
   OPEN t710_cl USING g_ohc.ohc01
   IF STATUS THEN
      CALL cl_err("OPEN t710_cl:", STATUS, 1)
      CLOSE t710_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t710_cl INTO g_ohc.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ohc.ohc01,SQLCA.sqlcode,0)
      CLOSE t710_cl ROLLBACK WORK RETURN
   END IF
   LET g_success = 'Y'
 
   UPDATE ohc_file SET ohcconf = 'Y',ohc03 = '1'  WHERE ohc01 = g_ohc.ohc01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","ohc_file",g_ohc.ohc01,"",SQLCA.SQLCODE,"","upd ofaconf",1)  #No.FUN-660167
      LET g_success = 'N'
      RETURN
   END IF
 
   IF g_success = 'Y' THEN
       SELECT * INTO g_ohc.* FROM ohc_file
        WHERE ohc01 = g_ohc.ohc01
       COMMIT WORK
       CALL cl_flow_notify(g_ohc.ohc01,'Y')
       DISPLAY BY NAME g_ohc.ohcconf,g_ohc.ohc03
   ELSE
       LET g_ohc.ohcconf='N'
       ROLLBACK WORK
   END IF
    #CKP
    IF g_ohc.ohcconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    IF g_ohc.ohc03  ='2' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
    CALL cl_set_field_pic(g_ohc.ohcconf,"","",g_chr2,g_chr,"")
END FUNCTION
 
FUNCTION t710_z() # 取消確認 when g_ohc.ohcconf='Y' (Turn to 'N')
   DEFINE l_n LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
   SELECT * INTO g_ohc.* FROM ohc_file WHERE ohc01 = g_ohc.ohc01
   IF g_ohc.ohcconf='N' THEN RETURN END IF
   IF g_ohc.ohcconf = 'X' THEN CALL cl_err(g_ohc.ohc01,'9024',0) RETURN END IF
   IF g_ohc.ohc03 = '2' THEN CALL cl_err(g_ohc.ohc01,'9004',0) RETURN END IF
 
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
 
   BEGIN WORK
 
   OPEN t710_cl USING g_ohc.ohc01
   IF STATUS THEN
      CALL cl_err("OPEN t710_cl:", STATUS, 1)
      CLOSE t710_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t710_cl INTO g_ohc.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ohc.ohc01,SQLCA.sqlcode,0)
      CLOSE t710_cl ROLLBACK WORK RETURN
   END IF
   LET g_success = 'Y'
 
   UPDATE ohc_file SET ohcconf = 'N',ohc03 = '0' WHERE ohc01 = g_ohc.ohc01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","ohc_file",g_ohc.ohc01,"",SQLCA.SQLCODE,"","upd ofaconf",1)  #No.FUN-660167
      LET g_success = 'N' RETURN
   END IF
 
   IF g_success = 'Y' THEN
      SELECT * INTO g_ohc.* FROM ohc_file
       WHERE ohc01 = g_ohc.ohc01
      COMMIT WORK
      DISPLAY BY NAME g_ohc.ohcconf,g_ohc.ohc03
   ELSE
      LET g_ohc.ohcconf='Y' ROLLBACK WORK
   END IF
    #CKP
    IF g_ohc.ohcconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    IF g_ohc.ohc03  ='2' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
    CALL cl_set_field_pic(g_ohc.ohcconf,"","",g_chr2,g_chr,"")
END FUNCTION
 
FUNCTION t710_copy()
 
   DEFINE l_newno         LIKE ohc_file.ohc01,
          p_stat          LIKE type_file.chr1,        # No.FUN-680137  VARCHAR(01)
          l_oldno         LIKE ohc_file.ohc01,
          li_result       LIKE type_file.num5                  #No.FUN-550070        #No.FUN-680137 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    IF g_ohc.ohc01 IS NULL THEN CALL cl_err('',-420,0) RETURN END IF
 
    BEGIN WORK   #No:7829
       LET g_before_input_done = FALSE #MOD-480130
       CALL t710_set_entry('a')        #MOD-480130
       LET g_before_input_done = TRUE  #MOD-480130
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
    INPUT l_newno WITHOUT DEFAULTS FROM ohc01
          BEFORE INPUT
                CALL cl_set_docno_format("ohc01")     #No.FUN-550070
 
          AFTER FIELD ohc01
 
#           CALL s_check_no(g_sys,l_newno,"","90","ohc_file","ohc01","")
            CALL s_check_no("axm",l_newno,"","90","ohc_file","ohc01","")   #No.FUN-A40041
              RETURNING li_result,l_newno
            DISPLAY l_newno to ohc01
            IF (NOT li_result) THEN
    	        NEXT FIELD ohc01
            END IF
 
#           CALL s_auto_assign_no(g_sys,l_newno,g_today,"90","ohc_file","ohc01","","","")
            CALL s_auto_assign_no("axm",l_newno,g_today,"90","ohc_file","ohc01","","","")   #No.FUN-A40041
                  RETURNING li_result,l_newno
            IF (NOT li_result) THEN
                NEXT FIELD ohc01
            END IF
            DISPLAY l_newno to ohc01
 
          ON ACTION controlp
           CASE
               WHEN INFIELD(ohc01) #客訴單號  #MOD-4A0252
                   LET g_t1 = s_get_doc_no(g_ohc.ohc01)    #No.FUN-550070
                   CALL q_oay(FALSE,FALSE,g_t1,'90','AXM') RETURNING g_t1    #TQC-670008
                   LET l_newno=g_t1
                   DISPLAY BY NAME l_newno
                   NEXT FIELD ohc01
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
       LET INT_FLAG = 0
       DISPLAY BY NAME g_ohc.ohc01
       RETURN
    END IF
 
    DROP TABLE y
    SELECT * FROM ohc_file         #單頭複製
        WHERE ohc01=g_ohc.ohc01 INTO TEMP y
 
    UPDATE y
	SET ohc01=l_newno,    #新的鍵值
            ohc02=g_today,    #單據日期
            ohc03='0',        #No.TQC-930004 add
            ohc13=g_today,
            ohcconf='N',
            ohcuser=g_user,   #資料所有者
            ohcgrup=g_grup,   #資料所有者所屬群
            ohcmodu=NULL,     #資料修改日期
            ohcdate=g_today  #資料建立日期
 
    INSERT INTO ohc_file
        SELECT * FROM y
 
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","ohc_file",l_newno,"",SQLCA.sqlcode,"","",1)    #FUN-B80089 ADD
       ROLLBACK WORK
    #  CALL cl_err3("ins","ohc_file",l_newno,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167     #FUN-B80089 MARK
       RETURN
    END IF
 
    DROP TABLE x
 
    SELECT * FROM ohd_file WHERE ohd01=g_ohc.ohc01 INTO TEMP x
 
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","ohd_file",g_ohc.ohc01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
       RETURN
    END IF
 
    UPDATE x
	SET ohd01=l_newno
    INSERT INTO ohd_file
	SELECT * FROM x
	
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","ohd_file",l_newno,"",SQLCA.sqlcode,"","",1) #FUN-B80089 ADD
       ROLLBACK WORK
    #  CALL cl_err3("ins","ohd_file",l_newno,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167    #FUN-B80089 MARK
       RETURN
    ELSE
       COMMIT WORK
    END IF
 
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') OK'
 
    LET l_oldno = g_ohc.ohc01
    SELECT ohc_file.* INTO g_ohc.* FROM ohc_file
     WHERE ohc01 = l_newno
 
    CALL t710_u()
    CALL t710_b()
 
    #SELECT ohc_file.* INTO g_ohc.* FROM ohc_file  #FUN-C80046
    # WHERE ohc01 = l_newno                        #FUN-C80046
 
    #CALL t710_show()                              #FUN-C80046
 
END FUNCTION
 
FUNCTION t710_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("ohc01",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION t710_out()
DEFINE l_wc LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(100)
   IF cl_null(g_ohc.ohc01) THEN
      CALL cl_err('','9057',1)
      RETURN
   END IF
   LET l_wc = 'ohc01 = "',g_ohc.ohc01,'"'
 #   LET g_cmd ="axmr762 ",  #FUN-C30085 mark
   LET g_cmd ="axmg762 ", #FUN-C30085 add
               " '",g_today,"'",
               " '",g_user,"'",
               " '",g_lang,"'",
               " 'Y'",
               " ' '",
               " '1'",
               " '",l_wc CLIPPED,"'",
               " '3'" 
   CALL cl_cmdrun_wait(g_cmd CLIPPED)
END FUNCTION
#No:FUN-9C0071--------精簡程式-----
