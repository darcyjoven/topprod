# Prog. Version..: '5.30.06-13.04.03(00010)'     #
#
# Pattern name...: asfp700.4gl
# Descriptions...: 製程委外工單轉採購單作業
# Date & Author..: 99/05/21 By Sophia
# Modify.........: 01/09/04 By Carol:NO.3452 單身增加一欄位:預計交貨日
# Modify.........: No.MOD-490166 04/09/14 ching 輸入修改
# Modify.........: No.FUN-4B0059 04/11/25 By Mandy 匯率加開窗功能
# Modify.........: No.FUN-4C0025 04/12/06 By Mandy 單價金額位數改為dec(20,6) 或DEFINE 用LIKE方式
# Modify.........: No.FUN-550109 05/05/26 By Danny 採購含稅單價
# Modify.........: No.FUN-550067 05/05/31 By Trisy 單據編號加大
# Modify.........: No.FUN-560011 05/06/07 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.FUN-560102 05/06/18 By Danny 採購含稅單價取消判斷大陸版
# Modify.........: No.FUN-580133 05/08/25 By Carrier 多單位內容修改
# Modify.........: NO.MOD-580007 05/08/22 BY yiting 委外完工的數量不用扣
# Modify.........: No.FUN-560157 05/12/29 By pengu  1.QBE 條件工單及製程均需增加查詢功能
# Modify.........: No.FUN-610018 06/01/11 By ice 採購含稅單價功能調整
# Modify.........: No.MOD-640314 06/04/10 By Rayven 委外P/O單身的保稅否和急料否設預設值
# Modify.........: No.FUN-660128 06/06/19 By Xumin cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.TQC-670031 06/07/10 By Claire 補上'
# Modify.........: No.FUN-670061 06/07/17 By kim GP3.5 利潤中心
# Modify.........: No.FUN-670099 06/08/28 By Nicola 價格管理修改
# Modify.........: No.FUN-680121 06/09/13 By huchenghao 類型轉換
# Modify.........: No.FUN-690024 06/09/21 By jamie 判斷pmcacti
# Modify.........: No.FUN-690025 06/09/21 By jamie 改判斷狀況碼pmc05
# Modify.........: No.FUN-690047 06/09/28 By Sarah pmm45,pmn38預設為'N'
# Modify.........: No.CHI-6A0004 06/10/27 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.MOD-6A0146 06/11/02 By Ray 下制程序號pmn431付值錯誤
# Modify.........: No.FUN-6A0090 06/11/07 By douzh l_time轉g_time
# Modify.........: No.CHI-690043 06/11/21 By Sarah pmn_file增加pmn90(取出單價),INSERT INTO pmn_file前要增加LET pmn90=pmn31
# Modify.........: No.CHI-680014 06/12/04 By rainy INSERT INTO pmn_file要處理pmn88/pmn88t
# Modify.........: No.FUN-710026 07/01/15 By hongmei 錯誤訊息匯總顯示修改
# Modify.........: No.TQC-710107 07/03/02 By Ray 點擊語言轉換后，錄入工單和工藝序后就會出現語言轉換的浮動小按鈕
# Modify.........: No.TQC-760202 07/06/28 By chenl 數量不可為空
# Modify.........: No.TQC-770003 07/07/02 By zhoufeng 維護幫助按鈕
# Modify.........: No.MOD-770042 07/07/11 By pengu 指定幣別時無法自動轉至apmt590
# Modify.........: No.TQC-790002 07/09/03 By Sarah Primary Key：複合key在INSERT INTO table前需增加判斷，如果是NULL就給值blank(字串型態) or 0(數值型態)
# Modify.........: No.MOD-780243 07/09/17 By pengu 沒有預設委外採購單頭驗收單列印欄位
# Modify.........: No.MOD-730044 07/09/19 By claire 需考慮採購單位與料件採購資料的採購單位換算
# Modify.........: NO.MOD-7B0090 07/11/09 BY claire 轉委外採購單時要計算超/短交率(pmn13)
# Modify.........: NO.FUN-810016 08/01/21 BY ve007 增加工藝單元轉出采購的功能，增加委外采購單元分段取價功能
# Modify.........: No.FUN-7B0018 08/02/29 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: NO.FUN-840178 08/03/26 By ve007 修改工單checkin=NULL 的bug
# Modify.........: No.MOD-840417 08/04/21 By Pengu p700_tmp TEMP TABLE中的sgd05欄位型態不對
# Modify.........: NO.FUN-840240 08/04/30 By ve007 
# Modify.........: No.MOD-860081 08/06/06 By jamie ON IDLE問題
# Modify.........: No.MOD-870037 08/07/03 By claire 字串長度以實際長度取得
# Modify.........: No.MOD-860226 08/07/16 By Pengu 調整MOD-580007修改地方
# Modify.........: No.MOD-870344 08/07/31 By chenl 調整采購量計算公式
# Modify.........: No.FUN-870117 08/08/15 by ve007 查詢條件增加PBI 
# Modify.........: No.CHI-8A0013 08/10/09 By claire 依轉採購單別給多是否簽核(pmmmksg)的值
# Modify.........: No.FUN-8A0086 08/10/21 By baofei 完善FUN-710050的錯誤匯總的修改
# Modify.........: No.MOD-8B0273 08/12/04 By chenyu 采購單單頭單價含稅時，未稅單價=未稅金額/計價數量
# Modify.........: No.FUN-930148 09/03/26 By ve007 采購取價和定價
# Modify.........: No.CHI-960096 09/07/14 By mike 1.若_process() 中 g_success = 'N' 不可顯示產生單號                                
#                                                 2.成功后應 POP msg !   
# Modify.........: No.FUN-960130 09/08/13 By Sunyanchun 零售業的必要欄位賦值
# Modify.........: No.TQC-980183 09/08/26 By xiaofeizhu 還原MOD-8B0273修改的內容
# Modify.........: No.FUN-980008 09/08/26 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-960048 09/10/20 By Pengu s_defprice，參數裡面有傳pmn86，不過似乎沒給值
# Modify.........: No.FUN-9B0016 09/10/31 By sunyanchun post no
# Modify.........: No.TQC-9B0203 09/11/25 By douzh pmn58為NULL時賦初始值0
# Modify.........: No.FUN-9C0072 10/01/11 By vealxu 精簡程式碼
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造
#                                                   成 ima26* 角色混亂的狀況，因此对ima26的调整 
# Modify.........: No.TQC-A40110 10/04/29 By destiny 第一次点退出后依然可以录入，应直接退出程序
# Modify.........: No:MOD-A50025 10/05/05 By Sarah 資料產生成功後再顯示產生的採購單號
# Modify.........: No.TQC-A50120 10/05/21 By destiny 工艺序的开窗不能根据工单单号带出相应的值 
# Modify.........: No.FUN-A60011 10/06/03 By Carrier 平行工艺 增加key05,key06,ecm012,ecu014
# Modfiy.........: No.FUN-A60076 10/07/01 By vealxu 製造功能優化-平行制程
# Modfiy.........: No.FUN-A60095 10/07/09 By jan 改寫下製程序的取得方法
# Modify.........: No.FUN-A80102 10/09/20 By kim GP5.25號機管理
# Modify.........: No.TQC-AC0374 10/12/29 By Mengxw 從ecu_file撈取資料時，制程料號改用s_schdat_sel_ima571()撈取 
# Modify.........: No.MOD-AC0368 10/12/29 By suncx s_defprice()改為調用s_defprice_new()
# Modify.........: No.FUN-B10056 11/02/15 By vealxu 修改制程段號的管控
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-B50046 11/05/13 By abby APS GP5.25 追版 str-----------------
# Modify.........: No:FUN-9A0047 09/10/20 By Mandy 當有與APS整合時,需將vmn18轉到委外採購單的供應商
# Modify.........: No:FUN-B50046 11/05/13 By abby APS GP5.25 追版 end-----------------
# Modify.........: No:FUN-B30177 11/05/24 By lixiang INSERT INTO pmn_file時，如果pmn58為null則給'0'
# Modify.........: No:CHI-B60092 11/06/29 By jason QBE條件工單/作業編號/制程序要可以複選
# Modify.........: No:CHI-B70039 11/08/04 By joHung 金額 = 計價數量 x 單價
# Modify.........: No.FUN-BB0084 11/11/24 By lixh1 增加數量欄位小數取位
# Modify.........: No:FUN-C10002 12/02/02 By bart 作業編號pmn78帶預設值
# Modify.........: No:TQC-C50217 12/05/28 By fengrui 修改未抓到資料時的報錯信息
# Modify.........: No:TQC-C70143 12/08/01 By lixh1 單身新增CheckBox選項
# Modify.........: No:TQC-C80049 12/08/07 By fengrui 添加交貨日期不可小於採購日期控管
# Modify.........: No:MOD-CA0230 12/11/06 By Elise 執行失敗時顯示原因
# Modify.........: No:MOD-CC0268 13/01/08 By Elise 放大欄位長度
# Modify.........: No:MOD-D30070 13/03/08 By bart 依SMA904傳給 s_curr3
# Modify.........: No:MOD-D40019 13/04/03 By bart g_wc定義為string
# Modify.........: No:TQC-D50092 13/07/15 By qirl 料件做供應商管制時，要對供應商編號做控管
# Modify.........: No:TQC-D70044 13/07/18 By qirl TQC-D50092判斷料件/供應商的SQL中應加上准核狀態碼、作業編號、幣別

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_rec_b         LIKE type_file.num5,    #單身筆數  #No.FUN-680121 SMALLINT
    g_exit          LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(01),              #
    g_add_po        LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(01),  #判斷是否為新增之採購單
    tm              RECORD
         a1         LIKE type_file.chr1,    #No.FUN-810016
        #wc         LIKE type_file.chr1000, #No.FUN-680121 VARCHAR(200)  #MOD-CC0268 mark
         #wc         VARCHAR(2000),          #MOD-CC0268  #MOD-D40019
         wc         STRING,  #MOD-D40019
         key01      LIKE ecm_file.ecm01,
         key02      LIKE ecm_file.ecm03,
         key03      LIKE sga_file.sga01,    #No.FUN-810016
         #No.FUN-A60011  --Begin
         key05      LIKE ecm_file.ecm04,
         key06      LIKE ecm_file.ecm012,
         #No.FUN-A60011  --End  
         pmm01      LIKE pmm_file.pmm01,
         pmm04      LIKE pmm_file.pmm04,
         pmm12      LIKE pmm_file.pmm12,
         pmm22      LIKE pmm_file.pmm22,
         pmm42      LIKE pmm_file.pmm42
                    END RECORD,
    g_pmn           DYNAMIC ARRAY OF RECORD
         chk        LIKE type_file.chr1,     #TQC-C70143
         ecm01      LIKE ecm_file.ecm01,
         ecm45      LIKE ecm_file.ecm45,
         #No.FUN-A60011  --Begin
         ecm012     LIKE ecm_file.ecm012,
         ecu014     LIKE ecu_file.ecu014,
         #No.FUN-A60011  --End  
         ecm03      LIKE ecm_file.ecm03,
         sgd05      LIKE sgd_file.sgd05,      #No.FUN-810016
         sga02      LIKE sga_file.sga02,      #No.FUN-810016
         ecm03_par  LIKE ecm_file.ecm03_par,
         ima02      LIKE ima_file.ima02,
         ima021     LIKE ima_file.ima021,
         pmn33      LIKE pmn_file.pmn33,
#        subqty     LIKE ima_file.ima26,      #No.FUN-680121 DEC(12,3),
         subqty     LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
         pmm09      LIKE pmm_file.pmm09,
         pmc03      LIKE pmc_file.pmc03,
         pmn20      LIKE pmn_file.pmn20,
         pmn31      LIKE pmn_file.pmn31,
         pmn31t     LIKE pmn_file.pmn31t,        #含稅單價   No.FUN-550109
         pmc47      LIKE pmc_file.pmc47,         #稅別       No.FUN-550109
         gec04      LIKE gec_file.gec04          #稅率       No.FUN-550109
                    END RECORD,
    g_pmn_t         RECORD
         chk        LIKE type_file.chr1,     #TQC-C70143
         ecm01      LIKE ecm_file.ecm01,
         ecm45      LIKE ecm_file.ecm45,
         #No.FUN-A60011  --Begin
         ecm012     LIKE ecm_file.ecm012,
         ecu014     LIKE ecu_file.ecu014,
         #No.FUN-A60011  --End  
         ecm03      LIKE ecm_file.ecm03,
         sgd05      LIKE sgd_file.sgd05,      #No.FUN-810016
         sga02      LIKE sga_file.sga02,      #No.FUN-810016
         ecm03_par  LIKE ecm_file.ecm03_par,
         ima02      LIKE ima_file.ima02,
         ima021     LIKE ima_file.ima021,
         pmn33      LIKE pmn_file.pmn33,
#        subqty     LIKE ima_file.ima26,      #No.FUN-680121 DEC(12,3),
         subqty     LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
         pmm09      LIKE pmm_file.pmm09,
         pmc03      LIKE pmc_file.pmc03,
         pmn20      LIKE pmn_file.pmn20,
         pmn31      LIKE pmn_file.pmn31,
         pmn31t     LIKE pmn_file.pmn31t,        #含稅單價   No.FUN-550109
         pmc47      LIKE pmc_file.pmc47,         #稅別       No.FUN-550109
         gec04      LIKE gec_file.gec04          #稅率       No.FUN-550109
                    END RECORD,
    g_tmp           RECORD
         chk        LIKE type_file.chr1,     #TQC-C70143
         ecm01      LIKE ecm_file.ecm01,
         ecm45      LIKE ecm_file.ecm45,
         #No.FUN-A60011  --Begin
         ecm012     LIKE ecm_file.ecm012,
         ecu014     LIKE ecu_file.ecu014,
         #No.FUN-A60011  --End  
         ecm03      LIKE ecm_file.ecm03,
         sgd05      LIKE sgd_file.sgd05,      #No.FUN-810016
         sga02      LIKE sga_file.sga02,      #No.FUN-810016
         ecm03_par  LIKE ecm_file.ecm03_par,
         ima02      LIKE ima_file.ima02,
         ima021     LIKE ima_file.ima021,
         pmn33      LIKE pmn_file.pmn33,
#        subqty     LIKE ima_file.ima26,  #No.FUN-680121 DEC(12,3),
         subqty     LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
         pmm09      LIKE pmm_file.pmm09,
         pmc03      LIKE pmc_file.pmc03,
         pmn20      LIKE pmn_file.pmn20,
         pmn31      LIKE pmn_file.pmn31,
         pmn31t     LIKE pmn_file.pmn31t,        #含稅單價   No.FUN-550109
         pmc47      LIKE pmc_file.pmc47,         #稅別       No.FUN-550109
         gec04      LIKE gec_file.gec04          #稅率       No.FUN-550109
                    END RECORD,
    l_exit          LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(01),              #目前處理的ARRAY CNT
    l_smyslip       LIKE oay_file.oayslip,  #No.FUN-680121 VARCHAR(05),              #No.FUN-550067
    l_smyapr        LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(01),              #
    l_flag          LIKE type_file.chr1,                #  #No.FUN-680121 VARCHAR(1)
    l_flag1         LIKE type_file.chr1,                #  #No.FUN-680121 VARCHAR(1)
   #l_sql           LIKE type_file.chr1000,            #  #No.FUN-680121 VARCHAR(300)  #MOD-CC0268 mark
    l_sql           VARCHAR(2000),                     #MOD-CC0268
    l_pmm25         LIKE pmm_file.pmm25,   #
    l_sfb82         LIKE sfb_file.sfb82,   #
    l_pmmacti       LIKE pmm_file.pmmacti, #
    b_pmn           RECORD LIKE pmn_file.*,
    b_pmm           RECORD LIKE pmm_file.*,
    g_pmc03         LIKE pmc_file.pmc03,   #
    g_gec07         LIKE gec_file.gec07,   #No.FUN-550109
    g_tot           LIKE pmm_file.pmm40,   #
    g_tott          LIKE pmm_file.pmm40t,  #No.FUN-610018
    g_start,g_end   LIKE oea_file.oea01,  #No.FUN-680121 VARCHAR(16),     #No.FUN-550067
#   l_k1            LIKE ima_file.ima26,  #No.FUN-680121 DECIMAL(11,3),
    l_k1            LIKE type_file.num15_3,    ###GP5.2  #NO.FUN-A20044
    l_ac,l_k        LIKE type_file.num5,  #目前處理的ARRAY CNT  #No.FUN-680121 SMALLINT
    l_nn            LIKE type_file.num5,    #No.FUN-680121 SMALLINT,              #
    l_sl            LIKE type_file.num5     #No.FUN-680121 SMALLINT               #目前處理的SCREEN LINE
DEFINE  g_pmc17     LIKE pmc_file.pmc17     #No.FUN-930148
DEFINE  g_pmc49     LIKE pmc_file.pmc49     #No.FUN-930148
 
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-680121 INTEGER
DEFINE   i               LIKE type_file.num5    #No.FUN-680121 SMALLINT
DEFINE   j               LIKE type_file.num5    #MOD-870037
#No.FUN-A60011  --Begin
DEFINE g_argv1      LIKE type_file.chr1     #tm.a1
DEFINE g_argv2      STRING                  #tm.wc
#No.FUN-A60011  --End 
DEFINE g_pmn73      LIKE pmn_file.pmn73,    #MOD-AC0368 add
       g_pmn74      LIKE pmn_file.pmn74     #MOD-AC0368 add
 
MAIN
   DEFINE p_row,p_col     LIKE type_file.num5    #No.FUN-680121 SMALLINT
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   #No.FUN-A60011  --Begin
   LET g_argv1 = ARG_VAL(1)           #參數-1 tm.a1
   LET g_argv2 = ARG_VAL(2)           #參數-1 tm.wc
   #No.FUN-A60011  --End  
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
        RETURNING g_time    #No.FUN-6A0090
 
   LET p_row = 2 LET p_col = 15
   OPEN WINDOW p700_w AT p_row,p_col WITH FORM "asf/42f/asfp700"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
   CALL cl_set_comp_visible("key06,ecm012,ecu014",g_sma.sma541='Y')  #No.FUN-A60011
 
   IF g_sma.sma124 = 'slk' THEN    
     CALL cl_set_comp_visible("key04",TRUE) 
     CALL cl_set_comp_visible("key01",FALSE) 
   ELSE
     CALL cl_set_comp_visible("key04",FALSE)
     CALL cl_set_comp_visible("key01",TRUE) 
   END IF
 
   CALL cl_opmsg('b')
   CALL p700_cre_tmp()
   CALL p700()
   CLOSE WINDOW p700_w
   CALL cl_used(g_prog,g_time,2)   #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
        RETURNING g_time    #No.FUN-6A0090
END MAIN
 
FUNCTION p700()
  #DEFINE   l_sql   LIKE type_file.chr1000 #No.FUN-560157 modify  #No.FUN-680121 VARCHAR(2000)  #MOD-CC0268 mark
   #DEFINE   l_sql   VARCHAR(2000)          #MOD-CC0268 #MOD-D40019
   DEFINE   l_sql       STRING  #MOD-D40019
   DEFINE   li_result   LIKE type_file.num5          #No.FUN-550067  #No.FUN-680121 SMALLINT
   DEFINE   l_sql2      STRING                 #MOD-870037
   DEFINE   l_ecm01     LIKE ecm_file.ecm01    #No.TQC-A50120 
   LET l_exit   = 'n'
 
   WHILE TRUE
 
      CALL g_pmn.clear()
      CLEAR FORM
 
      LET g_exit = 'N'
      DELETE FROM asfp700_tmp
      CALL cl_set_comp_visible("key03",FALSE)     #No.FUN-810016
      
      #No.FUN-A10062  --Begin
      IF NOT cl_null(g_argv1) THEN
         LET tm.a1 = g_argv1
      ELSE
         LET tm.a1 = 'N'
         DISPLAY BY NAME tm.a1
         INPUT BY NAME tm.a1 WITHOUT DEFAULTS
          ON ACTION CONTROLR
               CALL cl_show_req_fields()
 
          ON ACTION CONTROLG
               CALL cl_cmdask()
 
          ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE INPUT
 
          ON ACTION exit 
               LET INT_FLAG = 1
               EXIT INPUT
     
         END INPUT 
         #No.TQC-A40110--begin
         IF INT_FLAG THEN
            LET INT_FLAG = 0
            CLOSE WINDOW p700_w
            EXIT WHILE
         END IF 
      END IF
      #No.TQC-A40110--end
      IF tm.a1 = 'Y' THEN 
          CALL cl_set_comp_visible("key03",TRUE) 
      ELSE
          CALL cl_set_comp_visible("key03",FALSE)
      END IF  	
 
      #No.FUN-A60011  --Begin
      IF NOT cl_null(g_argv2) THEN
         LET tm.wc = g_argv2
      ELSE
         CONSTRUCT BY NAME tm.wc ON key04,key01,key05,key06,key02,key03         #No.FUN-810016  #No.FUN-870117 add key04  #No.FUN-A60011
           ON ACTION CONTROLP
              CASE
               #No.FUN-A60011  --Begin
               WHEN INFIELD (key05)               #作业编号
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ecd3"
                  LET g_qryparam.state    = "c"                               #No.TQC-A50120
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO FORMONLY.key05
                  NEXT FIELD key05
               WHEN INFIELD (key06)               #工艺段号
                  CALL cl_init_qry_var()
                # LET g_qryparam.form = "q_ecu012_1"     #FUN-B10056 mark
                  LET g_qryparam.form = "q_ecb012_1"     #FUN-B10056
                  LET g_qryparam.state    = "c"                               #No.TQC-A50120
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO FORMONLY.key06
                  NEXT FIELD key06
               #No.FUN-A60011  --End  
               WHEN INFIELD(key01) #工單編號
                  CALL cl_init_qry_var()
                  IF tm.a1 = 'Y'  THEN 
                    LET g_qryparam.form = "q_ecm6_1"
                  ELSE 
                  	 LET g_qryparam.form = "q_ecm6"
                  END IF 	   
                  LET g_qryparam.state    = "c"                             #No.TQC-A50120  #CHI-B60092 UnMark  
                  CALL cl_create_qry() RETURNING g_qryparam.multiret        #No.TQC-A50120  #CHI-B60092 UnMark
                  #CALL cl_create_qry() RETURNING l_ecm01                   #No.TQC-A50120  #CHI-B60092 Mark   
                  DISPLAY g_qryparam.multiret TO FORMONLY.key01                             #CHI-B60092 UnMark
                  #DISPLAY l_ecm01 TO FORMONLY.key01                                        #CHI-B60092 Mark  
                  NEXT FIELD key01
               WHEN INFIELD(key02) #製程序
                  CALL cl_init_qry_var()
                  IF tm.a1 = 'Y'  THEN 
                    LET g_qryparam.form = "q_ecm7_1"
                  ELSE 
                  	 LET g_qryparam.form = "q_ecm7"
                  END IF 	
                  LET g_qryparam.state    = "c"                              #No.TQC-A50120 #CHI-B60092 UnMark
                  LET g_qryparam.arg1    =l_ecm01                            #No.TQC-A50120
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO FORMONLY.key02
                  NEXT FIELD key02
                       NEXT FIELD key02
               WHEN INFIELD (key03) #單元代號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_sgd"
                  LET g_qryparam.state    = "c"                               #No.TQC-A50120 #CHI-B60092 UnMark
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO FORMONLY.key03
                  NEXT FIELD key03
               WHEN INFIELD (key04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_sfc"
                  LET g_qryparam.state    = "c"                               #No.TQC-A50120 #CHI-B60092 UnMark   
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO FORMONLY.key04
                  NEXT FIELD key04
               OTHERWISE EXIT CASE
            END CASE
 
            ON ACTION locale
               LET g_action_choice='locale'
               CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
               EXIT CONSTRUCT
 
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE CONSTRUCT
            ON ACTION exit                            #加離開功能
               LET INT_FLAG = 1
               EXIT CONSTRUCT
            ON ACTION help                               #No.TQC-770003
               CALL cl_show_help()
 
         END CONSTRUCT
      END IF
      #No.FUN-A60011  --End
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      IF g_action_choice = 'locale' THEN
         CALL cl_dynamic_locale()
         LET g_action_choice = NULL     #No.TQC-710107
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p700_w
         EXIT WHILE
      END IF
#MOD-D40019---begin mark 
#      LET l_sql = tm.wc
#      LET l_sql2 = l_sql                             #MOD-870037 
#      LET j = l_sql2.getLength()-4                   #MOD-870037 add
#      FOR i = 1 TO j     #將畫面的sql欄位資料改變    #MOD-870037 
#         IF l_sql[i,i+4]='key01' THEN
#            LET tm.wc[i,i+4]='ecm01'
#         END IF
#         IF l_sql[i,i+4]='key02' THEN
#            LET tm.wc[i,i+4]='ecm03'
#         END IF
#         IF l_sql[i,i+4]='key03' THEN
#           LET tm.wc[i,i+4]='sgd05'
#         END IF
#         IF l_sql[i,i+4]='key04' THEN
#           LET tm.wc[i,i+4]='sfb85'
#         END IF
#         #No.FUN-A60011  --Begin
#         IF l_sql[i,i+4]='key05' THEN
#           LET tm.wc[i,i+4]='ecm04'
#         END IF
#         IF l_sql[i,i+4]='key06' THEN
#           LET tm.wc[i,i+4]='ecmxx'
#         END IF
#         #No.FUN-A60011  --End  
#      END FOR
#      #No.FUN-A60011  --Begin
#      CALL cl_replace_str(tm.wc,"ecmxx","ecm012") RETURNING tm.wc
#      #No.FUN-A60011  --End  
#MOD-D40019---end 
#MOD-D40019---begin
      CALL cl_replace_str(tm.wc,"key01","ecm01") RETURNING tm.wc
      CALL cl_replace_str(tm.wc,"key02","ecm03") RETURNING tm.wc
      CALL cl_replace_str(tm.wc,"key03","sgd05") RETURNING tm.wc
      CALL cl_replace_str(tm.wc,"key04","sfb85") RETURNING tm.wc
      CALL cl_replace_str(tm.wc,"key05","ecm04") RETURNING tm.wc
      CALL cl_replace_str(tm.wc,"key06","ecm012") RETURNING tm.wc
#MOD-D40019---end   
      CALL p700_b_fill()
 
      #No.FUN-A60011  --Begin
      IF NOT cl_null(g_argv1) AND g_exit = 'Y' THEN
         EXIT WHILE
      END IF
      #No.FUN-A60011  --End  
      IF g_exit='Y' THEN
         CONTINUE WHILE
      END IF
      LET tm.pmm12=g_user
      LET tm.pmm42=NULL
      LET tm.pmm01=NULL
      LET tm.pmm22=NULL
      LET tm.pmm04=g_today
      DISPLAY tm.pmm04 TO FORMONLY.pmm04
      DISPLAY tm.pmm01 TO FORMONLY.pmm01
      DISPLAY tm.pmm22 TO FORMONLY.pmm22
      DISPLAY tm.pmm12 TO FORMONLY.pmm12
      DISPLAY tm.pmm42 TO FORMONLY.pmm42
 
      INPUT BY NAME tm.pmm01,tm.pmm04,tm.pmm12,tm.pmm22,tm.pmm42
         WITHOUT DEFAULTS
 
         AFTER FIELD pmm01                      #採購單號
 
            IF cl_null(tm.pmm01) THEN
               NEXT FIELD pmm01
            END IF
            LET l_smyslip = tm.pmm01[1,g_doc_len]
            CALL s_check_no("apm",l_smyslip,"","2","","","")
            RETURNING li_result,tm.pmm01
            LET tm.pmm01 = s_get_doc_no(tm.pmm01)
            DISPLAY BY NAME tm.pmm01
            IF (NOT li_result) THEN
               NEXT FIELD pmm01
            END IF
 
            SELECT smyapr INTO l_smyapr FROM smy_file
             WHERE smyslip = l_smyslip
            LET g_cnt=0
 
         AFTER FIELD pmm04                      #採購日期
            IF cl_null(tm.pmm04) THEN
               NEXT FIELD pmm04
            END IF
 
         AFTER FIELD pmm22                      #採購幣別
            IF cl_null(tm.pmm22) THEN
               NEXT FIELD pmm22
            ELSE
               CALL p700_pmm22()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(tm.pmm22,g_errno,0)
                  NEXT FIELD pmm22
               END IF
               #CALL s_curr3(tm.pmm22,tm.pmm04,'S') RETURNING tm.pmm42  #MOD-D30070
               CALL s_curr3(tm.pmm22,tm.pmm04,g_sma.sma904) RETURNING tm.pmm42  #MOD-D30070
               DISPLAY tm.pmm42 TO FORMONLY.pmm42
            END IF
 
         AFTER FIELD pmm12                      #採購人員
            IF cl_null(tm.pmm12) THEN
               NEXT FIELD pmm12
            ELSE
               CALL p700_pmm12()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(tm.pmm12,g_errno,0)
                  NEXT FIELD pmm12
               END IF
            END IF
 
         AFTER FIELD pmm42
            IF cl_null(tm.pmm42)  THEN
               NEXT FIELD pmm42
            END IF
            IF tm.pmm42 <=0 THEN
               NEXT FIELD pmm42
            END IF
 
         AFTER INPUT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               LET l_exit   = 'y'   
               EXIT INPUT
            END IF
            IF cl_null(tm.pmm01) THEN
               NEXT FIELD pmm01
            END IF
            IF cl_null(tm.pmm04) THEN
               NEXT FIELD pmm04
            END IF
            IF cl_null(tm.pmm22) THEN
               NEXT FIELD pmm22
            END IF
            IF cl_null(tm.pmm12) THEN
               NEXT FIELD pmm12
            END IF
            IF cl_null(tm.pmm42) THEN
               NEXT FIELD pmm42
            END IF
 
         ON ACTION qry_po
                  CALL q_pmm2(FALSE,TRUE,tm.pmm01,'01') RETURNING tm.pmm01
                  DISPLAY tm.pmm01 TO FORMONLY.pmm01
                  NEXT FIELD pmm01
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(pmm01) #採購單號
               LET l_smyslip = s_get_doc_no(tm.pmm01)     #No.FUN-550067
               CALL q_smy(FALSE,FALSE,l_smyslip,'APM','2') RETURNING l_smyslip   #TQC-670008 #TQC-670031
               LET tm.pmm01=l_smyslip       #No.FUN-550067
               DISPLAY tm.pmm01 TO FORMONLY.pmm01
               NEXT FIELD pmm01
            WHEN INFIELD(pmm22) #查詢幣別檔
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azi"
               LET g_qryparam.default1 = tm.pmm22
               CALL cl_create_qry() RETURNING tm.pmm22
               DISPLAY tm.pmm22 TO FORMONLY.pmm22
               NEXT FIELD pmm22
            WHEN INFIELD(pmm42)
               CALL s_rate(tm.pmm22,tm.pmm42) RETURNING tm.pmm42
               DISPLAY tm.pmm42 TO FORMONLY.pmm42
               NEXT FIELD pmm42
            WHEN INFIELD(pmm12) #採購員
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gen"
               LET g_qryparam.default1 = tm.pmm12
               CALL cl_create_qry() RETURNING tm.pmm12
               DISPLAY BY NAME tm.pmm12
               CALL p700_pmm12()
               NEXT FIELD pmm12
            OTHERWISE EXIT CASE
         END CASE
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT INPUT
         
         ON ACTION help                            #No.TQC-770003
            CALL cl_show_help()
 
      END INPUT
 
      IF l_exit = 'n' THEN
         CALL p700_b()                   #修改單身資料
      ELSE
         EXIT WHILE
      END IF
   END WHILE
 
END FUNCTION
 
FUNCTION p700_b_fill()                 #單身填充
 #DEFINE l_sql      LIKE type_file.chr1000,       #No.FUN-560157 modify  #No.FUN-680121 VARCHAR(2000)  #MOD-CC0268 mark
  DEFINE l_sql      VARCHAR(2000),                #MOD-CC0268
         l_ecm321   LIKE ecm_file.ecm321,
         l_ecm322   LIKE ecm_file.ecm322,
         l_ecm54    LIKE ecm_file.ecm54,    # check in 否
#        l_wip      LIKE ima_file.ima26,    #No.FUN-680121 DEC(12,3),
         l_wip      LIKE type_file.num15_3, ###GP5.2  #NO.FUN-A20044
#        l_qty      LIKE ima_file.ima26     #No.FUN-680121 DEC(12,3)
         l_qty      LIKE type_file.num15_3  ###GP5.2  #NO.FUN-A20044
  DEFINE l_ecm301   LIKE ecm_file.ecm301    #No.MOD-870344 
  DEFINE l_ecm302   LIKE ecm_file.ecm302    #No.MOD-870344 
  DEFINE l_ecm303   LIKE ecm_file.ecm303    #No.MOD-870344 
  DEFINE l_sfb06    LIKE sfb_file.sfb06     #No.FUN-A60011
  DEFINE l_flag     LIKE type_file.num5     #No.FUN-A60011
  DEFINE l_sfb05    LIKE sfb_file.sfb05     #TQC-AC0374
  DEFINE l_flag1    LIKE type_file.num5     #TQC-AC0374 
  DEFINE l_ecm04    LIKE ecm_file.ecm04     #No.FUN-9A0047 add
  DEFINE l_vmn18    LIKE vmn_file.vmn18     #No.FUN-9A0047 add
         
    IF tm.a1 = 'Y' THEN 
    #  LET l_sql = " SELECT ecm01,ecm45,ecm012,'',ecm03,sgd05,sga02,ecm03_par,ima02,ima021,'',0,ecm67,pmc03,0,0,",  #No.FUN-A60011  #FUN-A80102  #TQC-C70143 mark
       LET l_sql = " SELECT 'N',ecm01,ecm45,ecm012,'',ecm03,sgd05,sga02,ecm03_par,ima02,ima021,'',0,ecm67,pmc03,0,0,",              #TQC-C70143     
                     "   0,'',0,ecm321,ecm54,ecm322,ecm04,sfb06",   #No.FUN-550109    #No.FUN-A60011   #FUN-9A0047 add ecm04
                     " FROM ecm_file,sfb_file,sgd_file,OUTER ima_file,sga_file,pmc_file",  #FUN-A80102
                     " WHERE  ecm_file.ecm03_par = ima_file.ima01  ",
                     " AND ecm01 = sfb01 AND sfb04 !='8' AND sfb87 ='Y' ",
                     " AND sgd_file.sgd00 = ecm_file.ecm01 AND sgd_file.sgd03 = ecm_file.ecm03",
                     " AND sgd_file.sgd05 = sga_file.sga01 and sgd_file.sgd13 = 'Y'",
                     " AND ecm_file.ecm67 = pmc_file.pmc01",  #FUN-A80102
                     "   AND ",tm.wc CLIPPED,
                     " ORDER BY ecm01,ecm012,ecm03 "          #No.FUN-A60011
    ELSE                  
    #  LET l_sql = " SELECT ecm01,ecm45,ecm012,'',ecm03,'','',ecm03_par,ima02,ima021,'',0,ecm67,pmc03,0,0,",   #No.FUN-840240   #No.FUN-A60011  #FUN-A80102   #TQC-C70143 mark
       LET l_sql = " SELECT 'N',ecm01,ecm45,ecm012,'',ecm03,'','',ecm03_par,ima02,ima021,'',0,ecm67,pmc03,0,0,",                #TQC-C70143 
                     "   0,'',0,ecm321,ecm54,ecm322,ecm04,sfb06",   #No.FUN-550109    #No.FUN-A60011  #FUN-9A0047 add ecm04
                     " FROM ecm_file LEFT OUTER JOIN pmc_file ON (pmc01=ecm67)",
                     " LEFT OUTER JOIN ima_file ON (ecm03_par = ima01) ,sfb_file",  #FUN-A80102
                     " WHERE ecm01 = sfb01 AND sfb04 !='8' AND sfb87 ='Y' ",
     #               "   AND ecm52='Y' ",                     #No.FUN-A60011 ecm52现在已经无法手动修改,后续有SUB PO才会更新成'Y'
                     "   AND ",tm.wc CLIPPED,
                     " ORDER BY ecm01,ecm012,ecm03 "          #No.FUN-A60011
    END IF                                 #No.FUN-810016                 
    PREPARE p700_prepare FROM l_sql
    MESSAGE " SEARCHING! "
    CALL ui.Interface.refresh()
    DECLARE p700_cur CURSOR FOR p700_prepare
    LET g_cnt = 1
    FOREACH p700_cur INTO g_pmn[g_cnt].*,l_ecm321,l_ecm54,l_ecm322,l_ecm04,l_sfb06   #No.FUN-A60011  #FUN-9A0047 add l_ecm04
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       #FUN-9A0047--add----str---
       IF NOT cl_null(g_sma.sma901) AND g_sma.sma901 = 'Y' THEN
           LET l_vmn18 = ''                            #FUN-9A0047(2) add避免值未清空,後續一連串的default都帶錯
           SELECT vmn18 INTO l_vmn18
             FROM vmn_file
            WHERE vmn01 = g_pmn[g_cnt].ecm03_par       #料號
              AND vmn02 = g_pmn[g_cnt].ecm01           #途程編號
              AND vmn03 = g_pmn[g_cnt].ecm03           #加工序號
              AND vmn04 = l_ecm04           #作業編號
           IF NOT cl_null(l_vmn18) THEN
               LET g_pmn[g_cnt].pmm09 = l_vmn18

           END IF
       END IF
       #FUN-9A0047--add----end---
       DISPLAY g_pmn[g_cnt].ecm01
      #FUN-B10056 --------mod start------------
      ##No.FUN-A60011  --Begin
      #CALL s_schdat_sel_ima571(g_pmn[g_cnt].ecm01) RETURNING l_flag1,l_sfb05  #TQC-AC0374
      #SELECT ecu014 INTO g_pmn[g_cnt].ecu014 FROM ecu_file
      # WHERE ecu01 = l_sfb05   #TQC-AC0374
      #   AND ecu02 = l_sfb06
      #   AND ecu012= g_pmn[g_cnt].ecm012
      ##No.FUN-A60011  --End  
       CALL s_schdat_ecm014(g_pmn[g_cnt].ecm01,g_pmn[g_cnt].ecm012) RETURNING g_pmn[g_cnt].ecu014
      #FUN-B10056 -------mod end--------------

       #No.FUN-A60011  --Begin
       #IF cl_null(l_ecm321) THEN LET l_ecm321 = 0 END IF
       #IF cl_null(l_ecm322) THEN LET l_ecm322 = 0 END IF
       #SELECT SUM(pmn20) INTO l_qty FROM pmn_file,pmm_file
       # WHERE pmn41 = g_pmn[g_cnt].ecm01
       #   AND pmn04 = g_pmn[g_cnt].ecm03_par
       #   AND pmn01 = pmm01
       #   AND pmm18 = 'N'    #未確認
       #IF cl_null(l_qty) THEN LET l_qty = 0 END IF
       #IF l_ecm54 = 'Y' THEN    #工單作check-in                      #No.FUN-840178
       #   SELECT ecm291-(ecm311+ecm312+ecm313+ecm314+ecm316)*ecm59                                                                  
       #     INTO l_wip                                                                                                              
       #     FROM ecm_file                                                                                                           
       #    WHERE ecm01 = g_pmn[g_cnt].ecm01                                                                                         
       #      AND ecm03 = g_pmn[g_cnt].ecm03
       #ELSE
       #   SELECT ecm301+ecm302+ecm303-(ecm311+ecm312+ecm313+ecm314+ecm316)*ecm59
       #     INTO l_wip
       #     FROM ecm_file
       #    WHERE ecm01 = g_pmn[g_cnt].ecm01
       #      AND ecm03 = g_pmn[g_cnt].ecm03
       #END IF
       #IF cl_null(l_wip) THEN LET l_wip = 0 END IF
 
       #SELECT ecm301,ecm302,ecm303
       #  INTO l_ecm301,l_ecm302,l_ecm303
       #  FROM ecm_file
       # WHERE ecm01 = g_pmn[g_cnt].ecm01
       #   AND ecm03 = g_pmn[g_cnt].ecm03
       #LET g_pmn[g_cnt].subqty = l_ecm301+l_ecm302+l_ecm303-l_ecm321
 
       #计算可委外量的逻辑  check.....carrier
       CALL s_sub_available_qty(g_pmn[g_cnt].ecm01,g_pmn[g_cnt].ecm012,g_pmn[g_cnt].ecm03)
            RETURNING l_flag,l_wip
       IF l_flag = FALSE THEN
          INITIALIZE g_pmn[g_cnt].* TO NULL
          CONTINUE FOREACH
       END IF
       LET g_pmn[g_cnt].subqty = l_wip
       IF g_pmn[g_cnt].subqty <= 0 THEN
          INITIALIZE g_pmn[g_cnt].* TO NULL
          CONTINUE FOREACH
       END IF
       #No.FUN-A60011  --End  
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_pmn.deleteElement(g_cnt)
    #IF g_cnt= 1 THEN CALL cl_err('',9057,0) LET g_exit = 'Y' END IF       #TQC-C50217 mark
    IF g_cnt= 1 THEN CALL cl_err('','mfg2601',0) LET g_exit = 'Y' END IF   #TQC-C50217 add
    LET g_rec_b = g_cnt - 1
    LET g_cnt = 0
 
    DISPLAY ARRAY g_pmn TO s_pmn.* ATTRIBUTE(COUNT=g_rec_b)
       BEFORE DISPLAY
          EXIT DISPLAY
         ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                 CONTINUE DISPLAY
         
         ON ACTION about         
            CALL cl_about()      
         
         ON ACTION controlg      
            CALL cl_cmdask()     
         
         ON ACTION help          
            CALL cl_show_help()  
    END DISPLAY
END FUNCTION
 
FUNCTION p700_b()                          #單身
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680121 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用  #No.FUN-680121 SMALLINT
    l_modify_flag   LIKE type_file.chr1,                 #單身更改否  #No.FUN-680121 VARCHAR(1)
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否  #No.FUN-680121 VARCHAR(1)
    l_exit_sw       LIKE type_file.chr1,                 #No.FUN-680121 VARCHAR(1),               #Esc結束INPUT ARRAY 否
    p_cmd           LIKE type_file.chr1,                 #處理狀態  #No.FUN-680121 VARCHAR(1)
    l_insert        LIKE type_file.chr1,                 #No.FUN-680121 VARCHAR(01),              #可新增否
    l_update        LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(01),              #可更改否 (含取消)
    l_jump          LIKE type_file.num5,    #No.FUN-680121 SMALLINT, #判斷是否跳過AFTER ROW的處理
    l_flag          LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(1)
    l_date          LIKE type_file.dat,     #No.FUN-680121 DATE,
    l_ima07  LIKE ima_file.ima07,
    l_pmn41  LIKE pmn_file.pmn41,
    l_pmn86  LIKE pmn_file.pmn86,           #No:MOD-960048 add
    l_ecm321 LIKE ecm_file.ecm321,
#   l_wip           LIKE ima_file.ima26,  #No.FUN-680121 DEC(12,3),
#   l_qty           LIKE ima_file.ima26,  #No.FUN-680121 DEC(12,3),
#   l_over          LIKE ima_file.ima26,  #No.FUN-680121 DECIMAL(13,3),
#   l_total         LIKE ima_file.ima26,  #No.FUN-680121 DECIMAL(13,3),
    l_wip           LIKE type_file.num15_3,    ###GP5.2  #NO.FUN-A20044
    l_qty           LIKE type_file.num15_3,    ###GP5.2  #NO.FUN-A20044
    l_over          LIKE type_file.num15_3,    ###GP5.2  #NO.FUN-A20044
    l_total         LIKE type_file.num15_3,    ###GP5.2  #NO.FUN-A20044
    l_ecm04         LIKE ecm_file.ecm04 #NO:7178
    DEFINE l_msg STRING #CHI-960096 
    LET l_insert='N'
    LET l_update='N'
 
    CALL cl_opmsg('b')
 
    LET l_ac_t = 0
    LET l_ac = 1         #No.FUN-550109
 
        LET l_exit_sw = "y"                #正常結束,除非 ^N
        INPUT ARRAY g_pmn WITHOUT DEFAULTS FROM s_pmn.*
            ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            CALL p700_set_entry_b()
            CALL p700_set_no_entry_b()
        
 
        BEFORE ROW
            LET l_ac = ARR_CURR()
            LET g_pmn_t.* = g_pmn[l_ac].*  #BACKUP
            IF l_ac < l_ac_t THEN
                let l_jump = 1
                NEXT FIELD ima02           #跳下一ROW
            ELSE
                LET l_ac_t = 0
                let l_jump = 0
            END IF
            LET l_modify_flag = 'N'        #DEFAULT
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_sl = SCR_LINE()
            LET l_n  = ARR_COUNT()
            IF l_ac <= l_n then                   #DISPLAY NEWEST
                DISPLAY g_pmn[l_ac].* TO s_pmn[l_sl].*
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
        #   NEXT FIELD ecm01            #TQC-C70143   mark
            NEXT FIELD chk              #TQC-C70143

#TQC-C70143 ---------------Begin-----------------
        BEFORE FIELD chk
           IF g_pmn[l_ac].chk = 'Y' THEN
              CALL cl_set_comp_required("pmm09",TRUE)
           ELSE
              CALL cl_set_comp_required("pmm09",FALSE)
           END IF
      
        AFTER FIELD chk
           IF g_pmn[l_ac].chk = 'Y' THEN
              CALL cl_set_comp_required("pmm09",TRUE)
           ELSE
              CALL cl_set_comp_required("pmm09",FALSE)
              LET g_pmn[l_ac].pmn20 = 0
           END IF
#TQC-C70143 ---------------End-------------------
 
        BEFORE FIELD pmn33
            IF l_ac > 1 AND g_pmn[l_ac].ecm01 IS NULL THEN
               LET l_exit_sw = 'n'
               EXIT INPUT
            END IF
            IF cl_null(g_pmn[l_ac].pmn33) THEN
               LET g_pmn[l_ac].pmn33 = g_today
               DISPLAY g_pmn[l_ac].pmn33 TO s_pmn[l_sl].pmn33
            END IF
 
         AFTER FIELD pmn33       #預計交貨日期
            IF NOT cl_null(g_pmn[l_ac].pmn33) THEN
               CALL s_wkday(g_pmn[l_ac].pmn33) RETURNING l_flag,l_date
               IF cl_null(l_date) THEN
                  NEXT FIELD pmn33
               ELSE
                  LET g_pmn[l_ac].pmn33 = l_date
                  DISPLAY g_pmn[l_ac].pmn33 TO s_pmn[l_sl].pmn33
               END IF
               #TQC-C80049--add--str--
               IF g_pmn[l_ac].pmn33 < tm.pmm04 THEN 
                  CALL cl_err(g_pmn[l_ac].pmn33,'apm-029',0)
                  NEXT FIELD pmn33
               END IF
               #TQC-C80049--add--end--
            END IF
 
        BEFORE FIELD pmm09
            CALL p700_set_entry_b()
 
        AFTER FIELD pmm09
            IF g_pmn[l_ac].chk = 'Y' THEN    #TQC-C70143
               IF cl_null(g_pmn[l_ac].pmm09) THEN
                  NEXT FIELD pmm09
               END IF
               CALL p700_pmm09()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_pmn[l_ac].pmm09,g_errno,0)
                  NEXT FIELD pmm09
               END IF
               #CALL p700_set_no_entry_b()     #No.FUN-550109  #TQC-C80049 mark
               SELECT pmc17,pmc49
               INTO g_pmc17,g_pmc49
                  FROM pmc_file
               WHERE pmc01=g_pmn[l_ac].pmm09
            END IF    #TQC-C70143                      
            CALL p700_set_no_entry_b()  #TQC-C80049 add
 
        AFTER FIELD pmn20
            IF cl_null(g_pmn[l_ac].pmn20) THEN
               NEXT FIELD pmn20
            END IF
            SELECT ecm58 into b_pmn.pmn86 FROM ecm_file  #No.FUN-A60011
             WHERE ecm03 = g_pmn[l_ac].ecm03 AND ecm01 = g_pmn[l_ac].ecm01
               AND ecm012= g_pmn[l_ac].ecm012    #No.FUN-A60011 
            LET g_pmn[l_ac].pmn20 = s_digqty(g_pmn[l_ac].pmn20,b_pmn.pmn86)  #FUN-BB0084
            IF g_pmn[l_ac].pmn20 < 0 THEN                   
               CALL cl_err(g_pmn[l_ac].pmn20,'afa-043',0) 
               NEXT FIELD pmn20
            END IF 
            #TQC-C70143 ------------Begin---------------
            IF g_pmn[l_ac].chk = 'Y' THEN
               IF g_pmn[l_ac].pmn20 = 0 THEN
                  CALL cl_err(g_pmn[l_ac].pmn20,'asf-230',0)
                  NEXT FIELD pmn20
               END IF
            ELSE
               LET g_pmn[l_ac].pmn20 = 0
            END IF  
            #TQC-C70143 ------------End-----------------
            IF g_pmn[l_ac].pmn20 > g_pmn[l_ac].subqty THEN
               CALL cl_err(g_pmn[l_ac].pmn20,'asf-722',0)
               NEXT FIELD pmn20
            END IF
            IF g_pmn[l_ac].pmn20 <> g_pmn_t.pmn20 THEN
              #MOD-AC0368 mark ---begin---------------------  
              #CALL s_defprice(g_pmn[l_ac].ecm03_par,g_pmn[l_ac].pmm09,
              #                 tm.pmm22,tm.pmm04,g_pmn[l_ac].pmn20,l_ecm04,g_pmn[l_ac].pmc47,g_pmn[l_ac].gec04,'2',b_pmn.pmn86,'',g_pmc49,g_pmc17) 
              #      RETURNING g_pmn[l_ac].pmn31,g_pmn[l_ac].pmn31t   
              #MOD-AC0368 mark ----end----------------------
              #MOD-AC0368 add---begin-----------------------
               CALL s_defprice_new(g_pmn[l_ac].ecm03_par,g_pmn[l_ac].pmm09,
                                   tm.pmm22,tm.pmm04,g_pmn[l_ac].pmn20,l_ecm04,
                                   g_pmn[l_ac].pmc47,g_pmn[l_ac].gec04,'2',
                                   b_pmn.pmn86,'',g_pmc49,g_pmc17,g_plant)
                    RETURNING g_pmn[l_ac].pmn31,g_pmn[l_ac].pmn31t,g_pmn73,g_pmn74
              #MOD-AC0368 add---end-------------------------
            END IF 
            DISPLAY BY NAME g_pmn[l_ac].pmn20    #FUN-BB0084
        
        BEFORE FIELD pmn31
            IF g_pmn[l_ac].pmn31=0 AND g_pmn[l_ac].pmn20>0 THEN
               SELECT ecm04,ecm58 INTO l_ecm04,l_pmn86   #No:MOD-960048 modify  #No.FUN-A60011
                 FROM ecm_file
                WHERE ecm01 = g_pmn[l_ac].ecm01
                  AND ecm03 = g_pmn[l_ac].ecm03
                  AND ecm012= g_pmn[l_ac].ecm012   #No.FUN-A60011
               IF l_ecm04 IS NULL OR l_ecm04='' THEN
                  #MOD-AC0368 mark ---begin---------------------
                  #CALL s_defprice(g_pmn[l_ac].ecm03_par,g_pmn[l_ac].pmm09,
                  #                tm.pmm22,tm.pmm04,g_pmn[l_ac].pmn20,l_ecm04,g_pmn[l_ac].pmc47,g_pmn[l_ac].gec04,'2',l_pmn86,'',g_pmc49,g_pmc17) #NO:7178  #No.FUN-670099  #No.FUN-930148 add pmc17,pmc49  #MOD-960048 modify
                  #     RETURNING g_pmn[l_ac].pmn31,g_pmn[l_ac].pmn31t
                  #MOD-AC0368 mark ----end----------------------
                  #MOD-AC0368 add---begin-----------------------
                  CALL s_defprice_new(g_pmn[l_ac].ecm03_par,g_pmn[l_ac].pmm09,
                                      tm.pmm22,tm.pmm04,g_pmn[l_ac].pmn20,l_ecm04,
                                      g_pmn[l_ac].pmc47,g_pmn[l_ac].gec04,'2',
                                      l_pmn86,'',g_pmc49,g_pmc17,g_plant)
                       RETURNING g_pmn[l_ac].pmn31,g_pmn[l_ac].pmn31t,g_pmn73,g_pmn74
                  #MOD-AC0368 add---end------------------------- 
               ELSE
                  #MOD-AC0368 mark ---begin--------------------- 
               	  #CALL s_defprice(g_pmn[l_ac].ecm03_par,g_pmn[l_ac].pmm09,
                  #              tm.pmm22,tm.pmm04,g_pmn[l_ac].pmn20,l_ecm04,g_pmn[l_ac].pmc47,g_pmn[l_ac].gec04,'2',l_pmn86,g_pmn[l_ac].sgd05,g_pmc49,g_pmc17) #NO:7178  #No.FUN-670099 #No.FUN-930148 add pmc17,pmc49  #MOD-960048 modify
                  #   RETURNING g_pmn[l_ac].pmn31,g_pmn[l_ac].pmn31t      
                  #MOD-AC0368 mark ----end----------------------
                  #MOD-AC0368 add---begin-----------------------
                  CALL s_defprice_new(g_pmn[l_ac].ecm03_par,g_pmn[l_ac].pmm09,
                                      tm.pmm22,tm.pmm04,g_pmn[l_ac].pmn20,l_ecm04,
                                      g_pmn[l_ac].pmc47,g_pmn[l_ac].gec04,'2',l_pmn86,
                                      g_pmn[l_ac].sgd05,g_pmc49,g_pmc17,g_plant)
                       RETURNING g_pmn[l_ac].pmn31,g_pmn[l_ac].pmn31t,g_pmn73,g_pmn74
                  #MOD-AC0368 add---end-------------------------
               END IF       
               LET g_pmn[l_ac].pmn31 = cl_digcut(g_pmn[l_ac].pmn31,t_azi03)   #No.CHI-6A0004
               LET g_pmn[l_ac].pmn31t = cl_digcut(g_pmn[l_ac].pmn31t,t_azi03)   #No.CHI-6A0004
               DISPLAY g_pmn[l_ac].pmn31 TO s_pmn[l_sl].pmn31
               DISPLAY g_pmn[l_ac].pmn31t TO s_pmn[l_sl].pmn31t
            END IF
 
        AFTER FIELD pmn31                     #單價
            IF cl_null(g_pmn[l_ac].pmn31) AND g_pmn[l_ac].pmn20>0 THEN
               LET g_pmn[l_ac].pmn31=0
            END IF
            IF NOT cl_null(g_pmn[l_ac].pmn31) THEN
               LET g_pmn[l_ac].pmn31 = cl_digcut(g_pmn[l_ac].pmn31,t_azi03)   #No.CHI-6A0004
               LET g_pmn[l_ac].pmn31t =
                   g_pmn[l_ac].pmn31 * ( 1 + g_pmn[l_ac].gec04 /100)
               LET g_pmn[l_ac].pmn31t = cl_digcut(g_pmn[l_ac].pmn31t,t_azi03)  #No.CHI-6A0004
            END IF
 
        BEFORE FIELD pmn31t
            IF g_pmn[l_ac].pmn31t=0 AND g_pmn[l_ac].pmn20>0 THEN
               SELECT ecm04,ecm58 INTO l_ecm04,l_pmn86    #No:MOD-960048 modify  #No.FUN-A60011
                 FROM ecm_file
                WHERE ecm01 = g_pmn[l_ac].ecm01
                  AND ecm03 = g_pmn[l_ac].ecm03
                  AND ecm012= g_pmn[l_ac].ecm012   #No.FUN-A60011
               IF l_ecm04 IS NULL OR l_ecm04='' THEN
                  #MOD-AC0368 mark ---begin--------------------- 
                  #CALL s_defprice(g_pmn[l_ac].ecm03_par,g_pmn[l_ac].pmm09,
                  #                tm.pmm22,tm.pmm04,g_pmn[l_ac].pmn20,l_ecm04,g_pmn[l_ac].pmc47,g_pmn[l_ac].gec04,'2',l_pmn86,'',g_pmc49,g_pmc17) #NO:7178  #No.FUN-670099 #No.FUN-930148 add pmc17,pmc49  #MOD-960048 modify
                  #     RETURNING g_pmn[l_ac].pmn31,g_pmn[l_ac].pmn31t
                  #MOD-AC0368 mark ----end----------------------
                  #MOD-AC0368 add---begin-----------------------
                  CALL s_defprice_new(g_pmn[l_ac].ecm03_par,g_pmn[l_ac].pmm09,
                                      tm.pmm22,tm.pmm04,g_pmn[l_ac].pmn20,l_ecm04,
                                      g_pmn[l_ac].pmc47,g_pmn[l_ac].gec04,'2',
                                      l_pmn86,'',g_pmc49,g_pmc17,g_plant)
                       RETURNING g_pmn[l_ac].pmn31,g_pmn[l_ac].pmn31t,g_pmn73,g_pmn74
                  #MOD-AC0368 add---end-------------------------
               ELSE
                  #MOD-AC0368 mark ---begin--------------------- 
                  #CALL s_defprice(g_pmn[l_ac].ecm03_par,g_pmn[l_ac].pmm09,
                  #                tm.pmm22,tm.pmm04,g_pmn[l_ac].pmn20,l_ecm04,g_pmn[l_ac].pmc47,g_pmn[l_ac].gec04,'2',l_pmn86,g_pmn[l_ac].sgd05,g_pmc49,g_pmc17) #NO:7178  #No.FUN-670099 #No.FUN-930148 add pmc17,pmc49  #MOD-960048 modify
                  #     RETURNING g_pmn[l_ac].pmn31,g_pmn[l_ac].pmn31t  
                  #MOD-AC0368 mark ----end----------------------
                  #MOD-AC0368 add---begin-----------------------
                  CALL s_defprice_new(g_pmn[l_ac].ecm03_par,g_pmn[l_ac].pmm09,
                                      tm.pmm22,tm.pmm04,g_pmn[l_ac].pmn20,l_ecm04,
                                      g_pmn[l_ac].pmc47,g_pmn[l_ac].gec04,'2',l_pmn86,
                                      g_pmn[l_ac].sgd05,g_pmc49,g_pmc17,g_plant)
                       RETURNING g_pmn[l_ac].pmn31,g_pmn[l_ac].pmn31t,g_pmn73,g_pmn74
                  #MOD-AC0368 add---end------------------------
               END IF 
 
#              {CALL s_defprice(g_pmn[l_ac].ecm03_par,g_pmn[l_ac].pmm09,
#                              tm.pmm22,tm.pmm04,b_pmn.pmn87,l_ecm04,'','','2',b_pmn.pmn86)   #MOD-730044 modify
#                   RETURNING g_pmn[l_ac].pmn31,g_pmn[l_ac].pmn31t}
               LET g_pmn[l_ac].pmn31 = cl_digcut(g_pmn[l_ac].pmn31,t_azi03)
               LET g_pmn[l_ac].pmn31t = cl_digcut(g_pmn[l_ac].pmn31t,t_azi03)
               DISPLAY g_pmn[l_ac].pmn31 TO s_pmn[l_sl].pmn31
               DISPLAY g_pmn[l_ac].pmn31t TO s_pmn[l_sl].pmn31t
            END IF
 
        AFTER FIELD pmn31t   #含稅單價
            IF NOT cl_null(g_pmn[l_ac].pmn31t) THEN
               LET g_pmn[l_ac].pmn31t = cl_digcut(g_pmn[l_ac].pmn31t,t_azi03)   #No.CHI-6A0004
               LET g_pmn[l_ac].pmn31 =                                                                                              
                   g_pmn[l_ac].pmn31t / ( 1 + g_pmn[l_ac].gec04 / 100)
               LET g_pmn[l_ac].pmn31 = cl_digcut(g_pmn[l_ac].pmn31,t_azi03)     #No.CHI-6A0004
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_pmn_t.ecm01 IS NOT NULL THEN
                    LET g_rec_b=g_rec_b-1
            END IF
 
        AFTER DELETE
          LET l_n = ARR_COUNT()
          INITIALIZE g_pmn[l_n+1].* TO NULL
          LET l_jump = 1
 
        AFTER ROW
            IF NOT l_jump THEN
                DISPLAY g_pmn[l_ac].* TO s_pmn[l_sl].*
                IF INT_FLAG THEN                 #900423
                    LET g_pmn[l_ac].* = g_pmn_t.*
                    DISPLAY g_pmn[l_ac].* TO s_pmn[l_sl].*
                    EXIT INPUT
                END IF
                LET g_pmn_t.*=g_pmn[l_ac].*
            END IF

#TQC-C70143 ---------------Begin--------------
            IF g_pmn[l_ac].chk = 'Y' THEN
               IF g_pmn[l_ac].pmn20  = 0 THEN
                  CALL cl_err(g_pmn[l_ac].pmn20,'asf-230',0)
                  NEXT FIELD pmn20
               END IF
            END IF
#TQC-C70143 ---------------End----------------

       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON ACTION CONTROLP
          CASE
              WHEN INFIELD(pmm09) #廠商編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pmc"
                 LET g_qryparam.default1 = g_pmn[l_ac].pmm09
                 CALL cl_create_qry() RETURNING g_pmn[l_ac].pmm09
                 DISPLAY g_pmn[l_ac].pmm09 TO s_pmn[l_sl].pmm09
                 NEXT FIELD pmm09
              OTHERWISE EXIT CASE
           END CASE
 
       ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
        END INPUT
 
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           RETURN
        END IF
 
        LET l_flag='N'
        FOR i=1 TO g_rec_b             #判斷單身是否有輸入
        #   IF g_pmn[i].ecm01 IS NOT NULL AND g_pmn[i].pmn20>0 THEN                         #TQC-C70143  mark
            IF g_pmn[i].ecm01 IS NOT NULL AND g_pmn[i].pmn20>0 AND g_pmn[i].chk = 'Y' THEN  #TQC-C70143
               LET l_flag='Y'
               EXIT FOR
            END IF
        END FOR
        FOR i = 1 TO g_rec_b
            IF g_pmn[i].ecm01 IS NOT NULL AND  g_pmn[i].pmn20 > 0 THEN
               INSERT INTO asfp700_tmp VALUES (g_pmn[i].*)
            END IF
        END FOR
        IF l_flag='Y' THEN        #確認
           IF cl_sure(0,0) THEN
              LET g_success='Y'
              BEGIN WORK
              LET g_start = NULL  #No.FUN-A60011
              LET g_end   = NULL  #No.FUN-A60011
               CALL p700_process()   #產生單身
              #str MOD-A50025 mark
              #IF g_success='Y' THEN
              #   LET l_msg='執行成功！產生采購單號:No. ',g_start,' To ',g_end
              #   CALL cl_msgany(0,0,l_msg)
              #END IF  
              #end MOD-A50025 mark
               CALL s_showmsg()      #MOD-CA0230 add
               IF g_success='Y' THEN
                  COMMIT WORK
                 #str MOD-A50025 add
                  CALL cl_getmsg('asf-720',g_lang) RETURNING l_msg
                  LET l_msg = l_msg CLIPPED,'No. ',g_start,' To ',g_end
                  CALL cl_msgany(0,0,l_msg)
                 #end MOD-A50025 add
                  CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
               ELSE
                  ROLLBACK WORK
                  CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
               END IF
               CLEAR FORM
               CALL g_pmn.clear()
               IF l_flag THEN
                  RETURN
               ELSE
                  CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
                  EXIT PROGRAM
               END IF
           END IF
        END IF
 
END FUNCTION
 
#-------------#
# 產生採購單  #
#-------------#
FUNCTION p700_process()
  DEFINE l_pmm09     LIKE pmm_file.pmm09,
         l_cnt       LIKE type_file.num5,    #No.FUN-680121 SMALLINT
         l_nn        LIKE type_file.num5     #No.FUN-680121 SMALLINT
  DEFINE li_result   LIKE type_file.num5     #No.FUN-550067  #No.FUN-680121 SMALLINT
  DEFINE l_pmni      RECORD LIKE pmni_file.* #No.FUN-7B0018
 
  LET l_cnt = 1
  LET l_nn = 0
  INITIALIZE g_tmp.* TO NULL
  DECLARE p700_ins_pmm CURSOR FOR
   SELECT * FROM asfp700_tmp
    ORDER BY pmm09      #廠商編號
  CALL s_showmsg_init()    #NO.FUN-710026
  FOREACH p700_ins_pmm INTO g_tmp.*
    IF STATUS THEN 
       LET g_success = 'N'  #No.FUN-8A0086
       CALL s_errmsg('','','foreach tmp',STATUS,0)      #NO.FUN-710026
       EXIT FOREACH 
    END IF
    IF g_success='N' THEN                                                                                                          
       LET g_totsuccess='N'                                                                                                       
       LET g_success="Y"                                                                                                          
    END IF                    
 
    IF l_cnt = 1 THEN
       SELECT COUNT(*) INTO g_cnt FROM asfp700_tmp
        WHERE pmm09 = g_tmp.pmm09
       IF cl_null(g_cnt) THEN LET g_cnt = 0 END IF
          CALL s_auto_assign_no("apm",tm.pmm01,tm.pmm04,"","pmm_file","pmm01","","","")
               RETURNING li_result,tm.pmm01
          IF (NOT li_result) THEN
             RETURN
             DISPLAY tm.pmm01 TO pmm01
          END IF
          #FUN-A80102(S)
          INITIALIZE b_pmm.* TO NULL
          CALL p700sub_pmm(tm.pmm01,tm.pmm04,g_tmp.pmm09,tm.pmm12,tm.pmm22)            #產生採購單頭資料(新增)
             RETURNING b_pmm.*
          LET tm.pmm42 = b_pmm.pmm42
          #FUN-A80102(E)
          LET g_start = tm.pmm01
          INSERT INTO pmm_file VALUES (b_pmm.*)
          IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
             CALL s_errmsg('pmm01',b_pmm.pmm01,'ins pmm',STATUS,0)                #NO.FUN-710026
             LET g_success = 'N'
             CONTINUE FOREACH                                                       #NO.FUN-710026
          END IF
          LET l_nn = 0
    ELSE
       IF l_pmm09 != g_tmp.pmm09 THEN
          LET tm.pmm01=tm.pmm01[1,g_doc_len],'       '
          CALL s_auto_assign_no("apm",tm.pmm01,tm.pmm04,"","pmm_file","pmm01","","","")
               RETURNING li_result,tm.pmm01
          IF (NOT li_result) THEN
             RETURN
             DISPLAY tm.pmm01 TO pmm01
          END IF
          #FUN-A80102(S)
          INITIALIZE b_pmm.* TO NULL
          CALL p700sub_pmm(tm.pmm01,tm.pmm04,g_tmp.pmm09,tm.pmm12,tm.pmm22)            #產生採購單頭資料(新增)
             RETURNING b_pmm.*
          LET tm.pmm42 = b_pmm.pmm42
          #FUN-A80102(E)
          IF cl_null(g_start) THEN LET g_start = tm.pmm01 END IF
          INSERT INTO pmm_file VALUES (b_pmm.*)
          IF SQLCA.sqlcode THEN
             CALL s_errmsg('pmm01',b_pmm.pmm01,'ins pmm',SQLCA.sqlcode,1)                #NO.FUN-710026 
             LET g_success='N'                                                             #NO.FUN-710026
             CONTINUE FOREACH                                                              #NO.FUN-710026 
          END IF
          LET l_nn = 0
       END IF
    END IF
    LET l_nn=l_nn+1
    #FUN-A80102(S)
    INITIALIZE b_pmn.* TO NULL
    CALL p700sub_pmn(tm.pmm01,l_nn,g_tmp.ecm03_par,g_tmp.ecm01,g_tmp.ecm012,
                     g_tmp.ecm03,g_tmp.pmn20,g_tmp.pmn31,g_tmp.sgd05,
                     g_tmp.pmn31t,g_tmp.pmn33,b_pmm.pmm13,b_pmm.pmm22)
        RETURNING b_pmn.*
    #FUN-A80102(E)
#str----add by guanyao160509
    LET b_pmn.pmnud02 =g_tmp.ecm03 
#end----add by guanyao160509
   
    IF cl_null(b_pmn.pmn58) THEN LET b_pmn.pmn58 = 0 END IF    #No.FUN-B30177
    CALL s_schdat_pmn78(b_pmn.pmn41,b_pmn.pmn012,b_pmn.pmn43,b_pmn.pmn18,   #FUN-C10002
                                    b_pmn.pmn32) RETURNING b_pmn.pmn78      #FUN-C10002
    INSERT INTO pmn_file VALUES (b_pmn.*)
    IF SQLCA.sqlcode THEN
       CALL s_errmsg('pmm01',b_pmm.pmm01,'ins pmn',SQLCA.sqlcode,1)                         #NO.FUN-710026
       LET g_success='N'                                                                      #NO.FUN-710026
       CONTINUE FOREACH                                                                       #NO.FUN-710026
    END IF
    #No.FUN-A60011  --Begin
    CALL p700_pmm40()     #update 採購單頭的總金額
    IF g_success = 'N' THEN CONTINUE FOREACH END IF
    #No.FUN-A60011  --End  

    IF NOT s_industry('std') THEN
       INITIALIZE l_pmni.* TO NULL
       SELECT sfcislk01 INTO l_pmni.pmnislk01  FROM sfci_file ,sfb_file
          WHERE sfb01 = g_tmp.ecm01 AND sfb85 = sfci01 
       LET l_pmni.pmni01 = b_pmn.pmn01
       LET l_pmni.pmni02 = b_pmn.pmn02
       IF NOT s_ins_pmni(l_pmni.*,'') THEN
          LET g_success='N'                                                                      #NO.FUN-710026
          CONTINUE FOREACH                                                                       #NO.FUN-710026
       END IF
    END IF
    LET l_cnt = l_cnt + 1
    LET l_pmm09 = g_tmp.pmm09
  END FOREACH
  IF g_totsuccess="N" THEN                                                                                                         
     LET g_success="N"                                                                                                             
  END IF 
 
  #No.FUN-A60011  --Begin
  #LET g_end = tm.pmm01
  #IF g_start IS NOT NULL THEN
  #   SELECT SUM(pmn20*pmn31),SUM(pmn20*pmn31t)
  #     INTO g_tot,g_tott
  #     FROM pmn_file
  #    WHERE pmn01 BETWEEN g_start AND g_end
  #   LET g_tot = cl_digcut(g_tot,t_azi04)   #No.CHI-6A0004
  #   LET g_tott= cl_digcut(g_tott,t_azi04)  #No.CHI-6A0004
  #   UPDATE pmm_file SET pmm40 = g_tot,
  #                       pmm40t= g_tott
  #    WHERE pmm01 BETWEEN g_start AND g_end
  #   IF SQLCA.sqlcode THEN
  #      CALL s_errmsg('','','upd pmm40',SQLCA.sqlcode,1)                             #NO.FUN-710026 
  #      LET g_success='N'                                                            #NO.FUN-710026
  #   END IF
  #END IF
  #No.FUN-A60011  --End  
END FUNCTION
 

FUNCTION  p700_pmm40()     #update 採購單頭的總金額
 
#  SELECT SUM(pmn20*pmn31),SUM(pmn20*pmn31t)   #CHI-B70039 mark
   SELECT SUM(pmn87*pmn31),SUM(pmn87*pmn31t)   #CHI-B70039
     INTO g_tot,g_tott
     FROM pmn_file
    WHERE pmn01 = tm.pmm01
   LET g_tot = cl_digcut(g_tot,t_azi04)   #No.CHI-6A0004
   LET g_tott= cl_digcut(g_tott,t_azi04)  #No.CHI-6A0004
   UPDATE pmm_file SET pmm40 = g_tot,
                       pmm40t= g_tott
    WHERE pmm01 = tm.pmm01
   IF SQLCA.sqlcode THEN
      LET g_success='N'
      CALL s_errmsg('pmm01',tm.pmm01,'upd pmm40',SQLCA.sqlcode,1)        #No.FUN-A60011
      RETURN
   END IF
END FUNCTION
 
FUNCTION p700_pmm09()   #供應商check
   DEFINE l_pmcacti   LIKE pmc_file.pmcacti,
          l_pmc05     LIKE pmc_file.pmc05,
          l_pmc22     LIKE pmc_file.pmc22
   DEFINE l_ima915    LIKE ima_file.ima915  #TQC-D50092  add
   DEFINE l_n         LIKE type_file.num5   #TQC-D50092  add
   DEFINE l_ecm04     LIKE ecm_file.ecm04   #TQC-D70044  add 
 
   LET g_errno=' '
   SELECT pmcacti,pmc05,pmc03,pmc22,pmc47
     INTO l_pmcacti,l_pmc05,g_pmc03,l_pmc22,g_pmn[l_ac].pmc47
     FROM pmc_file
    WHERE pmc01=g_pmn[l_ac].pmm09
   CASE WHEN SQLCA.sqlcode=100  LET g_errno='mfg3014'
                                LET g_pmc03=NULL
        WHEN l_pmcacti='N'      LET g_errno='9028'
        WHEN l_pmcacti MATCHES '[PH]'       LET g_errno = '9038'
        WHEN l_pmc05='0'        LET g_errno='aap-032'
                                LET g_pmc03=NULL
        WHEN l_pmc05='3'        LET g_errno='aap-033'
                                LET g_pmc03=NULL
   END CASE
   #TQC-D50092--add--str--
   SELECT ima915 INTO l_ima915 FROM ima_file
    WHERE ima01 = g_pmn[l_ac].ecm03_par

   #TQC-D70044--add--str--
   SELECT ecm04 INTO l_ecm04 FROM ecm_file 
    WHERE ecm01 = g_pmn[l_ac].ecm01
      AND ecm03 = g_pmn[l_ac].ecm03
      AND ecm012 = g_pmn[l_ac].ecm012
   #TQC-D70044--add--end--

   IF l_ima915 = '2' OR l_ima915 = '3' THEN
      SELECT COUNT(*) INTO l_n FROM  pmh_file
       WHERE pmh01 = g_pmn[l_ac].ecm03_par
         AND pmh02 = g_pmn[l_ac].pmm09
         AND pmh22 = '2'
         #TQC-D70044--add--str--
         AND pmh05 = '0' 
         AND pmh13 = tm.pmm22
         AND pmh21 = l_ecm04 
         #TQC-D70044--add--end--
         AND pmhacti = 'Y'
      IF l_n = 0 THEN
         LET g_errno='asf-416'
      END IF
   END IF
   #TQC-D50092--add--end--
   LET g_pmn[l_ac].pmc03 = g_pmc03
   DISPLAY g_pmn[l_ac].pmc03 TO s_pmn[l_sl].pmc03
 
   SELECT gec04,gec07 INTO g_pmn[l_ac].gec04,g_gec07
     FROM gec_file WHERE gec01 = g_pmn[l_ac].pmc47
   IF cl_null(g_gec07) THEN LET g_gec07 = 'N' END IF
 
END FUNCTION
 
FUNCTION p700_pmm22()  #幣別
   DEFINE l_aziacti LIKE azi_file.aziacti
 
   LET g_errno = " "
   SELECT azi03,aziacti INTO t_azi03,l_aziacti FROM azi_file    #No.FUN-550109   #No.CHI-6A0004
    WHERE azi01 = tm.pmm22
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3008'
                                  LET l_aziacti = NULL
        WHEN l_aziacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION
 
FUNCTION p700_pmm12()  #人員
  DEFINE l_gen02     LIKE gen_file.gen02,
         l_genacti   LIKE gen_file.genacti
 
    LET g_errno = ' '
    SELECT gen02,genacti INTO l_gen02,l_genacti
      FROM gen_file WHERE gen01 = tm.pmm12
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-038'
                            LET l_gen02 = NULL
         WHEN l_genacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno)  THEN
       DISPLAY l_gen02  TO FORMONLY.gen02
    END IF
END FUNCTION
 
FUNCTION p700_cre_tmp()
 
    DROP TABLE asfp700_tmp;
    CREATE TEMP TABLE asfp700_tmp(
       chk          LIKE type_file.chr1,      #TQC-C70143
       ecm01        LIKE ecm_file.ecm01,
       ecm45        LIKE ecm_file.ecm45,
       ecm012       LIKE ecm_file.ecm012,     #No.FUN-A60011
       ecu014       LIKE ecu_file.ecu014,     #No.FUN-A60011
       ecm03        LIKE ecm_file.ecm03,    
       sgd05        LIKE sgd_file.sgd05,      #No.FUN-810016  #MOD-840417 modify
       sga02        LIKE sga_file.sga02,      #No.FUN-810016
       ecm03_par    LIKE ecm_file.ecm03_par,  #No.FUN-840240
       ima02        LIKE ima_file.ima02,
       ima021       LIKE ima_file.ima021,
       pmn33        LIKE pmn_file.pmn33,
       subqty       LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
       pmm09        LIKE pmm_file.pmm09,
       pmc03        LIKE pmc_file.pmc03,
       pmn20        LIKE pmn_file.pmn20,
       pmn31        LIKE pmn_file.pmn31,
       pmn31t       LIKE pmn_file.pmn31t,
       pmc47        LIKE pmc_file.pmc47,
       gec04        LIKE gec_file.gec04)

END FUNCTION
 
FUNCTION p700_set_entry_b()
 
   CALL cl_set_comp_entry("pmn31,pmn31t",TRUE)
 
END FUNCTION
 
FUNCTION p700_set_no_entry_b()
 
   IF g_gec07 = 'N' THEN       #No.FUN-560102
      CALL cl_set_comp_entry("pmn31t",FALSE)
   ELSE
      CALL cl_set_comp_entry("pmn31",FALSE)
   END IF
 
END FUNCTION
#No.FUN-9C0072 精簡程式碼
#FUN-B50046
