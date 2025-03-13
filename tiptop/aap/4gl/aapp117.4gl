# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aapp117.4gl
# Descriptions...: 退貨無發票帳款暫估整批產生作業
# Date & Author..: 05/11/16 By wujie     
# Modify.........: No.FUN-5B0089 05/12/30 By Rosayu 產生apa資料後要加判斷單別設定產生分錄底稿
# Modify.........: NO.FUN-630043 06/03/14 By Melody 多工廠帳務中心功能修改
# Modify.........: No.FUN-640022 06/04/08 By kim GP3.0 匯率參數功能改善
# Modify.........: No.TQC-640193 06/04/28 By Smapmin 單別抓取有誤
# Modify.........: No.FUN-660117 06/06/16 By Rainy Char改為 Like
# Modify.........: No.FUN-660122 06/06/27 By Hellen cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/04 By rainy 權限修正
# Modify.........: No.FUN-670064 06/07/19 By kim GP3.5 利潤中心
# Modify.........: No.FUN-680027 06/08/14 By Rayven 多帳期修改
# Modify.........: No.FUN-680029 06/08/17 By Rayven 新增多帳套功能
# Modify.........: No.FUN-650164 06/08/30 By rainy 取消'RTN' 判斷
# Modify.........: No.FUN-680110 06/09/05 By Sarah 資料改產生至aapt260,apa00='21'改成apa00='26'處理
# Modify.........: No.FUN-690028 06/09/12 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.CHI-6A0004 06/10/30 By Jackho  本（原）幣取位修改
# Modify.........: No.TQC-6B0151 06/12/08 By Smapmin 數量應抓取計價數量
# Modify.........: No.TQC-6B0066 06/12/13 By Rayven 對原幣和本幣合計按幣種進行截位
# Modify.........: No.FUN-710014 07/01/15 By atsea 增加修改單身批處理錯誤統整功能
# Modify.........: No.TQC-740142 07/04/19 By Rayven g_sql的定義的字符長度不夠，導致溢出
#                                                   大陸版倉退單不對應原收貨單應該可以產生退貨應付
# Modify.........: No.TQC-770051 07/07/11 By Rayven 稅種開窗應該為零稅率無申報的稅種
#                                                   生成的暫估退貨作業,單價與金額與倉退單不一致,只取整數部分
# Modify.........: No.TQC-790080 07/09/13 By wujie   產生資料時，發票號碼不一定要為空
# Modify.........: No.TQC-790141 07/09/26 By lumxa 豖億拸楷き婃嘛莉汜釬珛QBE爵祥剒猁恁楷き瘍鎢
# Modify.........: No.TQC-790128 07/09/26 By Judy 付款日，票據到期日賦初始值
# Modify.........: No.TQC-7A0032 07/10/15 By Judy 暫估資料單身的單價、金額都無小數位
# Modify.........: No.TQC-7B0005 07/11/01 By chenl  1.大陸版下，無源倉退單取值有問題，修正sql錯誤。
# Modify.........:                                  2.增加付款方式輸入，FORMONLY型，程序中，凡用到付款方式皆為界面輸入的值。
# Modify.........: No.TQC-7B0083 07/11/20 By Carrier 暫估時不考慮分期,只插入一筆apc_file & rvv23不含暫估數量,更新rvv88
# Modify.........: No.MOD-830072 08/03/10 By Smapmin列印次數default為0
# Modify.........: No.FUN-810045 08/03/24 By rainy 項目管理，專案相關欄位代入pab_file
# Modify.........: No.FUN-840006 08/04/02 By hellen項目管理，去掉預算編號相關欄位
# Modify.........: No.TQC-850001 08/05/05 By Carrier TQC-840010 追單
# Modify.........: No.TQC-860021 08/06/10 By Sarah INPUT段漏了ON IDLE控制
# Modify.........: No.MOD-870073 08/08/06 By Sarah apa52,apa521稅額科目直接給值''
# Modify.........: No.MOD-890113 08/09/17 By Sarah 大陸版在抓幣別時,先抓pmc22,抓不到才給營運中心幣別
# Modify.........: No.TQC-8A0079 08/11/11 By Sarah 單價含稅時,含稅金額=含稅單價*計價數量
#                                                             未稅金額=含稅金額/(1+稅額)/100
#                                                  單價未稅時,未稅金額=未稅單價*計價數量
#                                                             含稅金額=未稅金額*(1+稅額)/100
# Modify.........: No.CHI-8C0004 08/12/10 By Sarah 大陸版時付款條件(p_type)允許不輸入,以廠商(rvv06)帶出廠商檔的付款條件(pmc17)
# Modify.........: No.MOD-8C0065 08/12/10 By Sarah 台灣版的g_sql裡rva_file,rvb_file,pmm_file,pmn_file四個Table改為OUTER
# Modify.........: No.MOD-910038 09/01/06 By Nicola cl_null(apa01)時，不能進入ins_apc
# Modify.........: No.MOD-920013 09/02/02 By sherry 如果單價含稅，算未稅單價時先取位再除于稅率
# Modify.........: No.MOD-920250 09/02/19 By Sarah 1.數量為0的倉退單apb24,apb24t應直接抓rvv39,rvv39t
#                                                  2.apb23取位請改用t_azi03
# Modify.........: No.MOD-930018 09/03/04 By Sarah 需判斷已產生到aapt110的倉退單不可再產生到aapt260
# Modify.........: No.TQC-8C0025 09/03/04 By Sarah 在抓g_apb.apb27前,先清空變數,以免殘留前值
# Modify.........: No.FUN-930106 09/03/16 By destiny 增加費用原因的條件
# Modify.........: No.MOD-940112 09/04/25 By Sarah 當沒有輸入收貨單號,無法串回採購單抓取幣別時,改抓廠商慣用幣別
# Modify.........: No.MOD-950003 09/05/04 By wujie 倉退單數量不為0時，根據apb中的數量總和判斷是否拋轉
# Modify.........: No.MOD-940411 09/05/04 By Sarah p117_upd_apa57()段,請取消判斷要不要做差異處理的條件g_apa.apa31=0
# Modify.........: No.FUN-930165 09/05/15 By jan MISC料件改抓請購單單頭的部門(pmk13)
# Modify.........: No.FUN-940083 09/05/26 By zhaijie采購功能改善
# Modify.........: No.FUN-960141 09/06/29 By dongbg GP5.2修改:增加門店編號欄位
# Modify.........: No.FUN-960140 09/07/23 By lutingting GP5.2修改:取科目得時候增加經營方式為代銷得考慮 
# Modify.........: No.FUN-980001 09/08/12 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.MOD-960356 09/06/30 By Carrier 無入庫倉退時,無幣種時,重新取取位
# Modify.........: No.MOD-970050 09/07/06 By Sarah 判斷該倉退單是否已產生過,若有則不再產生
# Modify.........: No.MOD-970061 09/07/09 By Sarah 檢查該倉退單對應的收貨單若已有發票,就不可再產生退貨暫估
# Modify.........: No.TQC-970205 09/07/21 By Carrier 新增AP資料時,賦apa63初值
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990069 09/09/27 By baofei 修改GP5.2的相關設定
# Modify.........: No.TQC-9A0046 09/10/12 By Sarah 台灣版當畫面上的付款條件沒有輸入時,帶出原先抓到的採購單的付款條件
# Modify.........: No:MOD-990264 09/10/19 By sabrina 台灣版付款欄位不卡為〝必輸欄位〞 
# Modify.........: No:MOD-990168 09/10/21 By mike 调整抓取 apyapr 方式   
# Modify.........: No.FUN-990031 09/10/22 By lutingtingGP5.2財務營運中心欄位調整,營運中心要控制在同一法人下,条件选项来源营运中心隐藏
# Modify.........: No.TQC-9A0193 09/10/28 By Carrier SQL STANDARDIZE
# Modify.........: No.FUN-9A0093 09/11/02 By lutingting拋轉apb時給欄位apb37賦值
# Modify.........: No:MOD-9B0199 09/11/30 By wujie 设定暂估税率为0的代码移动位置
# Modify.........: No:MOD-9C0064 09/12/07 By Smapmin 增加錯誤訊息的顯示
# Modify.........: No.FUN-9C0041 09/12/10 By lutingting 應付賬款可以按照經營方式匯總
# Modify.........: No.MOD-9C0355 09/12/22 By sabrina aza26!='2'時不顯示"付款條件"
# Modify.........: No:FUN-9C0140 09/12/22 By shiwuying 從同法人下的不同db抓資料
# Modify.........: No.FUN-9C0077 10/01/18 By baofei 程序精簡
# Modify.........: No.FUN-A20006 10/02/02 By lutingting 修改p117_upd_apa57()寫法
# Modify.........: No:CHI-A40012 10/04/07 By sabrina 每筆資料年月之檢核由FUNCTION p117_chkdate()改由FOREACH p117_cs裡判斷
#                                                    且將不符合的單據顯示出來
# Modify.........: No.FUN-A40041 10/04/20 By wujie     g_sys->AAP
# Modify.........: No:FUN-A40003 10/05/21 By wujie   增加apa79，预设为N
# Modify.........: No:FUN-A60024 10/06/12 By wujie   调整apa79的值为0 
# Modify.........: No.FUN-A60056 10/06/24 By lutingting GP5.2財務串前段問題整批調整
# Modify.........: No.FUN-A50102 10/07/22 By vealxu 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:MOD-AA0021 10/10/06 By Dido 單價改用原 rvv38/rvv38t 計算;更新 apa15/apa16
# Modify.........: No:CHI-A90002 10/10/06 By Summer 應過濾pmcacti='Y'才能立帳
# Modify.........: No:CHI-AB0011 10/11/19 By Summer QBE增加採購人員(pmm12) 
# Modify.........: No:CHI-AC0005 10/12/09 By Summer 倉退單號增加開窗功能 
# Modify.........: No:MOD-AC0113 10/12/14 By Dido 取重評資料函式未處理 
# Modify.........: No:FUN-B30211 11/03/30 By yangtingting 未加離開前的 cl_used(2)
# Modify.........: No:FUN-B50016 11/05/04 By guoch 廠商編號、採購單號進行開創查詢
# Modify.........: No:FUN-B50016 11/05/04 By guoch 廠商編號、採購單號進行開創查詢
# Modify.........: No:MOD-B60115 11/06/15 By wujie 参考aapp115整理抓取的sql
# Modify.........: No:MOD-B70134 11/07/14 By zhangll 大陆版应考虑多次开票的情况
# Modify.........: No.MOD-B80028 11/08/02 By Polly   調整 p_type 若未給值,則抓取 pmc17(不區分大陸版)
# Modify.........: No.FUN-B80058 11/08/05 By lixia 兩套帳內容修改，新增azf141
# Modify.........: No.MOD-B80345 11/08/31 By Polly 調整判斷aapt210有倉退單就不產生暫估退貨單條件
# Modify.........: No.TQC-BA0025 11/10/09 By yinhy 來源營運中心編號欄位azp01應預設默認值
# Modify.........: No.TQC-BA0178 11/10/28 By yinhy 增加檢核，帳款日不可小於入庫日
# Modify.........: No.MOD-BB0118 11/11/09 By suncx 報‘aap-129’錯誤之後任然提示執行成功 
# Modify.........: No.FUN-BB0084 11/12/27 By lixh1 增加數量欄位小數取位
# Modify.........: No.FUN-BB0002 312/01/18 By pauline rvb22無資料時進入取rvv22 
# Modify.........: No.TQC-C10017 12/01/05 By yinhy 調整apb25，apb26，apb27，apb36，apb31，apb930欄位的值
# Modify.........: No.MOD-C50033 12/05/08 By Elise 若多角則不應產生aapt260
# Modify.........: No.MOD-C50181 12/05/28 By Polly 文字型態不可累加
# Modify.........: No.FUN-C70052 12/07/12 By xuxz 區分採購性質立帳選項
# Modify.........: No.FUN-C80022 12/08/07 By xuxz mod  FUN-C70052 添加採購性質下拉框
# Modify.........: No.MOD-CA0221 12/10/30 By yinhy 暫估單應先抓取倉退單上的幣種
# Modify.........: No.MOD-D10264 13/02/01 By yinhy 大陸版本去掉依廠商匯總時去掉付款方式限制
# Modify.........: No.FUN-CB0056 13/03/04 By minpp 画面档税种给默认值aps02
# Modify.........: No.FUN-D40003 13/04/22 By zhangweib 自動帶出稅種
# Modify.........: No.MOD-D60145 13/06/18 By yinhy 判斷若是留置廠商不可更新金額
# Modify.........: No.FUN-D60083 13/06/19 By yangtt 调用p117_stock_act(的地方增加判断，若该入库单+项次的仓库rvv32,若存在于axci500,即为非成本仓，则科目取ima164;
#                                                 使用多帐套则加取ima1641.否则依原来的逻辑根据ccz07取值不变
# Modify.........: No.FUN-D70021 13/07/04 By yangtt 畫面檔增加選項MISC料件是否立帳，如果為否的話，不立暫估
# Modify.........: No.yinhy131205  13/12/05 By yinhy 改用計價單位

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_rvv01         LIKE rvv_file.rvv01,    #倉退單
       t_rvv01         LIKE rvv_file.rvv01,    #倉退單舊值
       g_vendor        LIKE rvv_file.rvv06,    #供應廠商
       t_vendor        LIKE rvv_file.rvv06,    #供應廠商舊值
       g_vendor2       LIKE pmc_file.pmc04,    #付款廠商pmc04
       g_abbr          LIKE pmc_file.pmc03,    #地址
       g_rvv09         LIKE rvv_file.rvv09,
       purchas_sw      LIKE type_file.chr1,   #No.FUN-C70052 VARCHAR(1),
       trtype          LIKE apy_file.apyslip,
       begin_no,end_no LIKE apa_file.apa01,
       g_amt1,g_amt2   LIKE type_file.num20_6, # No.FUN-690028 DEC(20,6),  #FUN-4B0079
       f_amt1,f_amt2   LIKE type_file.num20_6, # No.FUN-690028 DEC(20,6),  #FUN-4B0079
       g_gec04         LIKE gec_file.gec04,
       t_apb06         LIKE apb_file.apb06,
       t_pmm20         LIKE pmm_file.pmm20,
       t_pmm21         LIKE pmm_file.pmm21,
       t_pmm22         LIKE pmm_file.pmm22,
       g_apa02         LIKE apa_file.apa02,
       g_apa21         LIKE apa_file.apa21,
       g_apa22         LIKE apa_file.apa22,
       g_apa36         LIKE apa_file.apa36,
       g_apa15         LIKE apa_file.apa15,
       g_pmm02         LIKE pmm_file.pmm02,
      #g_pmm02_t       LIKE pmm_file.pmm02, #FUN-C70052 add#FUN-C80022 mark
       g_pmm25         LIKE pmm_file.pmm25,       #MOD-8C0065 add
       t_pmn122        LIKE pmn_file.pmn122,
       g_pmn122        LIKE pmn_file.pmn122,
       g_pmm13         LIKE pmm_file.pmm13,
       g_pmm12         LIKE pmm_file.pmm12,
       g_pmn40         LIKE pmn_file.pmn40,    #96/07/18 modify
       g_pmn401        LIKE pmn_file.pmn401,   #NoFUN-680029 
       g_rvv25         LIKE rvv_file.rvv25,
       g_pmc54         LIKE pmc_file.pmc54,
       g_pmc17         LIKE pmc_file.pmc17,       #CHI-8C0004 add
       g_rva04         LIKE rva_file.rva04,
       g_rvu10         LIKE rvu_file.rvu10,
       g_apa           RECORD LIKE apa_file.*,
       g_apb           RECORD LIKE apb_file.*,
       g_apc           RECORD LIKE apc_file.*, #No.FUN-680027
       g_azi           RECORD LIKE azi_file.*,
       t_azi           RECORD LIKE azi_file.*,
       g_pmm           RECORD LIKE pmm_file.*,    #MOD-8C0065 add
       enter_account   LIKE type_file.chr1,    # No.FUN-690028 VARCHAR(1),   #No.MOD-540080
       summary_sw      LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
       l_flag          LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
       g_n             LIKE type_file.num10,   # No.FUN-690028 INTEGER,
       l_cnt           LIKE type_file.num5,    #No.FUN-690028 SMALLINT
       g_wc            LIKE type_file.chr1000, #No.TQC-740142
       g_wc2           STRING,  #CHI-AB0011 add
       g_sql           STRING                  #No.TQC-740142
DEFINE g_net           LIKE apv_file.apv04 
DEFINE g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690028 SMALLINT
DEFINE source          LIKE apb_file.apb03     # No.FUN-690028 VARCHAR(10)     #FUN-630043
DEFINE g_rvv930        LIKE rvv_file.rvv930    #FUN-670064
DEFINE g_rvuplant      LIKE rvu_file.rvuplant  #FUN-960141
DEFINE t_rvuplant      LIKE rvu_file.rvuplant  #FUN-960141
DEFINE g_rty06         LIKE rty_file.rty06    #FUN-960140                                                                           
DEFINE t_rty06         LIKE rty_file.rty06    #FUN-960140                                                                           
DEFINE g_ccz07         LIKE ccz_file.ccz07    #FUN-960140  
DEFINE g_rvu21         LIKE rvu_file.rvu21     #FUN-9C0041
DEFINE t_rvu21         LIKE rvu_file.rvu21     #FUN-9C0041
DEFINE g_count         LIKE type_file.num5     #No.TQC-740142
DEFINE ptype           LIKE pma_file.pma01     #付款方式      #No.TQC-7B0005 
DEFINE g_apb24t        LIKE apb_file.apb24     #TQC-8A0079 add   #含稅金額
DEFINE l_dbs           LIKE type_file.chr21    #No.FUN-9C0140 Add
DEFINE g_azp01         LIKE azp_file.azp01     #No.FUN-9C0140 Add
DEFINE g_wc1           LIKE type_file.chr1000  #No.FUN-9C0140 Add
DEFINE g_start         LIKE apa_file.apa01     #No.FUN-9C0140 Add
DEFINE t_azp01         LIKE azp_file.azp01     #FUN-9C0140 luttb
DEFINE t_azp03         LIKE azp_file.azp03     #FUN-9C0140 luttb
DEFINE g_a             LIKE type_file.chr1     #FUN-D70021 #MISC料件是否立帳
DEFINE g_b             LIKE type_file.chr1     #FUN-D60083 #非成本倉是否立賬

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time 

   OPEN WINDOW p117_w WITH FORM "aap/42f/aapp117"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
   
   CALL cl_set_comp_visible("group05", FALSE)   #FUN-990031 
   IF g_aza.aza26 != '2' THEN
      CALL cl_set_comp_visible("ptype,pt_name", FALSE)   #FUN-990031 
   END IF
   CALL p117()

   IF g_aza.aza53='Y' AND source!=g_plant THEN
      DATABASE g_dbs      
      CALL cl_ins_del_sid(1,g_plant) #FUN-980030  #FUN-990069
   END IF
 
   CLOSE WINDOW p117_w 

   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION p117()
   DEFINE l_flag   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
   DEFINE li_result LIKE type_file.num5    #No.FUN-690028 SMALLINT
   DEFINE l_azp02   LIKE azp_file.azp02  #FUN-630043
   DEFINE l_azp03   LIKE azp_file.azp03  #FUN-630043
   DEFINE l_n       LIKE type_file.num5  #No.TQC-7B0005
   DEFINE l_depno   LIKE aps_file.aps01  #FUN-CB0056
   DEFINE l_rvu06   LIKE rvu_file.rvu06  #FUN-D40003
   DEFINE l_azp01   LIKE azp_file.azp01  #FUN-D40003
 
   WHILE TRUE
      LET g_action_choice = ""
      
      CLEAR FORM
      LET source=g_plant 
     #LET g_pmm02_t = '' #FUN-C70052 add#FUN-C80022 mark
      LET l_azp02=''
      DISPLAY BY NAME source
      SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01=source
      DISPLAY l_azp02 TO FORMONLY.azp02
      IF g_aza.aza53='Y' THEN
         INPUT BY NAME source WITHOUT DEFAULTS
            AFTER FIELD source 
               LET l_azp02=''
               SELECT azp02 INTO l_azp02 FROM azp_file
                  WHERE azp01=source
               IF STATUS THEN
                  CALL cl_err3("sel","azp_file",source,"","100","","",0)   #No.FUN-660122
                  NEXT FIELD source
               END IF
               DISPLAY l_azp02 TO FORMONLY.azp02
 
            AFTER INPUT
               IF INT_FLAG THEN EXIT INPUT END IF  
 
            ON ACTION CONTROLP
               CASE
                  WHEN INFIELD(source)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_azp"
                       LET g_qryparam.default1 = source
                       CALL cl_create_qry() RETURNING source 
                       DISPLAY BY NAME source
                       NEXT FIELD source
               END CASE
 
            ON ACTION exit              #加離開功能genero
               LET INT_FLAG = 1
               EXIT INPUT
 
            ON ACTION controlg       #TQC-860021
               CALL cl_cmdask()      #TQC-860021
 
            ON IDLE g_idle_seconds   #TQC-860021
               CALL cl_on_idle()     #TQC-860021
               CONTINUE INPUT        #TQC-860021
 
            ON ACTION about          #TQC-860021
               CALL cl_about()       #TQC-860021
 
            ON ACTION help           #TQC-860021
               CALL cl_show_help()   #TQC-860021
         END INPUT
         IF INT_FLAG THEN
            LET INT_FLAG = 0 
            CLOSE WINDOW p117_w 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time     #FUN-B30211
            EXIT PROGRAM
         END IF
         IF source!=g_plant THEN
            SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01=source
            IF STATUS THEN LET l_azp03=g_dbs END IF
            DATABASE l_azp03    
            CALL cl_ins_del_sid(1,source) #FUN-980030    #FUN-990069
         END IF
      END IF

      WHILE TRUE
         CALL cl_opmsg('w')
         MESSAGE ""
         CONSTRUCT BY NAME g_wc1 ON azp01
            #No.TQC-BA0025  --Begin
            BEFORE CONSTRUCT
               CALL cl_qbe_init()
               DISPLAY g_plant TO azp01
            #No.TQC-BA0025  --End

            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE CONSTRUCT

            ON ACTION about
               CALL cl_about()

            ON ACTION help
               CALL cl_show_help()

            ON ACTION controlg
               CALL cl_cmdask()

            ON ACTION locale
               LET g_action_choice='locale'
               EXIT CONSTRUCT

            ON ACTION exit              #加離開功能genero
               LET INT_FLAG = 1
               EXIT CONSTRUCT

            ON ACTION CONTROLP
               CASE
                  WHEN INFIELD(azp01)  #機構別
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_azw"
                     LET g_qryparam.where = "azw02 = '",g_legal,"' "
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO azp01
                     NEXT FIELD azp01
               END CASE
         END CONSTRUCT
         IF g_action_choice = 'locale' THEN
            CALL cl_dynamic_locale()
            CONTINUE WHILE
         END IF
         IF INT_FLAG THEN
            LET INT_FLAG = 0
            CLOSE WINDOW p310_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
         END IF
         IF g_wc1 = ' 1=1' THEN
            CALL cl_err('','9046',0)
            CONTINUE WHILE
         END IF
         EXIT WHILE
      END WHILE
 
      CONSTRUCT BY NAME g_wc ON rvv01,rvv09,rvv06,rvv36,rvuplant #NO.TQC-790141  #FUN-960141
      
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
         ON ACTION CONTROLP                                                                                                         
            CASE                                                                                                                    
         #CHI-AC0005 add --start--
               WHEN INFIELD(rvv01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_rvv8"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rvv01
                  NEXT FIELD rvv01
         #CHI-AC0005 add --end--
#FUN-B50016  --begin
               WHEN INFIELD(rvv06)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_pmc2"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rvv06
                  NEXT FIELD rvv06
               WHEN INFIELD(rvv36)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_rvv32"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rvv36
                  NEXT FIELD rvv36
#FUN-B50016  --end         
               WHEN INFIELD(rvuplant)                                                                                               
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.state = "c"                                                                                        
                  LET g_qryparam.form = "q_azw"   
                  LET g_qryparam.where = "azw02 = '",g_legal,"' "
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  DISPLAY g_qryparam.multiret TO rvuplant                                                                           
                  NEXT FIELD rvuplant  
            END CASE
 
         ON ACTION locale
            LET g_action_choice='locale'
            EXIT CONSTRUCT
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT
 
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
 
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030

      #CHI-AB0011 add --start--
      CONSTRUCT BY NAME g_wc2 ON pmm12 

         ON ACTION locale
            LET g_action_choice='locale'
            EXIT CONSTRUCT

         BEFORE CONSTRUCT
             CALL cl_qbe_init()

         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(pmm12) #採購員
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gen"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmm12
                  NEXT FIELD pmm12
            END CASE

         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT

         ON ACTION about
            CALL cl_about()

         ON ACTION help 
            CALL cl_show_help()

         ON ACTION controlg
            CALL cl_cmdask()

         ON ACTION qbe_select
            CALL cl_qbe_select()

      END CONSTRUCT
      #CHI-AB0011 add --end--
      
      IF g_action_choice = 'locale' THEN
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      
      IF INT_FLAG THEN
         RETURN 
      END IF
      
      INITIALIZE g_apa.* TO NULL
      INITIALIZE g_apb.* TO NULL
      LET g_apa.apa02 = g_today
      LET g_apa.apa12 = g_apa.apa02
      LET g_apa.apa64 = g_apa.apa02
      LET g_apa.apa24 = 0
      LET g_apa.apa21 = g_user
      LET g_apa.apa22 = g_grup
     #No.FUN-D40003 ---start--- Mark
     ##FUN-CB0056---add---str
     #IF g_apz.apz13 = 'Y' THEN
     #   LET l_depno = g_apa.apa22
     #ELSE
     #   LET l_depno = ' '
     #END IF
     #SELECT aps02 INTO g_apa.apa15 FROM aps_file
     # WHERE aps01 = l_depno
     #SELECT gec04 INTO g_apa.apa16 FROM gec_file
     # WHERE gec01 = g_apa.apa15 AND gec011= '1'
     #DISPLAY BY NAME g_apa.apa15,g_apa.apa16
     ##FUN-CB0056---add---end
     #No.FUN-D40003 ---start--- Mark
      LET enter_account = 'N' 
      LET g_a='N' #FUN-D70021
      LET g_b='N' #FUN-D60083
      LET summary_sw = '1'
      LET t_vendor =NULL                                                                                                            
      LET t_rvv01 =NULL                                                                                                             
      LET t_rvuplant = NULL   #FUN-960141                                                                                           
      LET t_rvu21 = NULL      #FUN-9C0041
      LET t_apb06 =NULL                                                                                                             
      LET t_pmm20 =NULL                                                                                                             
      LET t_pmm22 =NULL                                                                                                             
      LET t_pmn122 =NULL                                                                                                            
      LET begin_no =NULL 
      #No.FUN-D40003  --Begin
      IF g_apz.apz13 = 'N' THEN
         SELECT aps02 INTO g_apa.apa15 FROM aps_file WHERE aps01=' '
      ELSE
         LET g_sql = "SELECT azp01 FROM azp_file,azw_file ",
             " WHERE ",g_wc2 CLIPPED ,
             "   AND azw01 = azp01 AND azw02 = '",g_legal,"' ",
             " ORDER BY azp01 "
         PREPARE sel_azp03_pre1 FROM g_sql
         DECLARE sel_azp03_cs1 CURSOR FOR sel_azp03_pre1
         FOREACH sel_azp03_cs1 INTO l_azp01
            LET g_sql = "SELECT DISTINCT rvu06 FROM rvu_file,rvv_file",
                        " WHERE ",g_wc CLIPPED,
                        "   AND rvu01=rvv01",
                        "   AND rvuplant = '",l_azp01,"' ",
                        "   AND rvuconf='Y' "
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql
            PREPARE p115_prepare_rvu06 FROM g_sql
            IF STATUS THEN
               LET g_success = 'N'
               CALL cl_err('prepare:',STATUS,1)
               RETURN
            END IF
            DECLARE p115_cs_rvu06 CURSOR WITH HOLD FOR p115_prepare_rvu06
            FOREACH p115_cs_rvu06 INTO l_rvu06
               SELECT aps02 INTO g_apa.apa15 FROM aps_file WHERE aps01=l_rvu06
               IF NOT cl_null(g_apa.apa15) THEN
                  EXIT FOREACH
               END IF
            END FOREACH
         END FOREACH
      END IF
      IF NOT cl_null(g_apa.apa15) THEN
         CALL p117_apa15()
      END IF
      #No.FUN-D40003  --End
      LET purchas_sw = '1'#FUN-C70052 add#FUN-C80022 mod N-->1
      
      INPUT BY NAME trtype,g_apa.apa02,g_apa.apa21, g_apa.apa22,
                    g_apa.apa36,g_apa.apa15,
                    g_a,  #FUN-D70021 #MISC料件是否立帳
                    enter_account, 
                    g_b,  #FUN-D60083 #非成本倉是否立賬
                    ptype,#No.TQC-7B0005 
                    purchas_sw,     #FUN-C70052 add
                    summary_sw WITHOUT DEFAULTS 
         BEFORE INPUT
 
      
         AFTER FIELD trtype
            IF cl_null(trtype) THEN 
               LET summary_sw='1' 
            ELSE
#              CALL s_check_no(g_sys,trtype,"","26","","","")     #檢查單別   #FUN-680110
               CALL s_check_no("aap",trtype,"","26","","","")     #檢查單別   #FUN-680110    #No.FUN-A40041
                 RETURNING li_result,trtype                                                                                         
               IF (NOT li_result) THEN                                                                                              
                  NEXT FIELD trtype                                                                                                 
               END IF  
               LET g_apa.apamksg = g_apy.apyapr
            END IF
      
         AFTER FIELD apa21         #96/07/17 modify 可空白
            IF NOT cl_null(g_apa.apa21) THEN 
               CALL p117_apa21()
               IF NOT cl_null(g_errno) THEN                   #抱歉, 有問題
                  CALL cl_err(g_apa.apa21,g_errno,0)
                  NEXT FIELD apa21
               END IF
            END IF
            IF cl_null(g_apa.apa21) THEN
               LET g_apa.apa21 = ' '
            END IF 
      
         AFTER FIELD apa22    
            IF NOT cl_null(g_apa.apa22) THEN
               CALL p117_apa22()
               IF NOT cl_null(g_errno) THEN                   #抱歉, 有問題
                  CALL cl_err(g_apa.apa22,g_errno,0)
                  NEXT FIELD apa22
               END IF
            END IF
            IF cl_null(g_apa.apa22) THEN
               LET g_apa.apa22 = ' '
            END IF
      
         AFTER FIELD apa36
            IF NOT cl_null(g_apa.apa36) THEN
               CALL p117_apa36()
               IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_apa.apa36,g_errno,0)
                  NEXT FIELD apa36
               END IF
            END IF
      
         AFTER FIELD apa15
            IF NOT cl_null(g_apa.apa15) THEN 
               CALL p117_apa15()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_apa.apa15,g_errno,0)
                  NEXT FIELD apa15
               END IF
            END IF
 
         AFTER FIELD ptype
           IF NOT cl_null(ptype) THEN
              CALL p117_ptype()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(ptype,g_errno,0)
                 NEXT FIELD ptype
              END IF
           END IF 
      
         AFTER FIELD summary_sw
            IF cl_null(trtype) AND summary_sw MATCHES '[23]'THEN 
               CALL cl_err('','anm-217',0)
               NEXT FIELD trtype 
            END IF
      
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG 
            CALL cl_cmdask()
      
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(trtype) #
                  CALL q_apy(0,0,trtype,'26','AAP') RETURNING trtype  #TQC-670008   #FUN-680110
                  DISPLAY BY NAME trtype
               WHEN INFIELD(apa21)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gen"
                  LET g_qryparam.default1 = g_apa.apa21
                  CALL cl_create_qry() RETURNING g_apa.apa21
                  DISPLAY BY NAME g_apa.apa21
               WHEN INFIELD(apa22)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem"
                  LET g_qryparam.default1 = g_apa.apa22
                  CALL cl_create_qry() RETURNING g_apa.apa22
                  DISPLAY BY NAME g_apa.apa22
               WHEN INFIELD(apa36)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_apr"
                  LET g_qryparam.default1 = g_apa.apa36
                  CALL cl_create_qry() RETURNING g_apa.apa36
                  DISPLAY BY NAME g_apa.apa36
               WHEN INFIELD(apa15) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gec7"  #No.TQC-770051
                  LET g_qryparam.default1 = g_apa.apa15
                  LET g_qryparam.arg1 = "1"
                  CALL cl_create_qry() RETURNING g_apa.apa15
                  DISPLAY BY NAME g_apa.apa15
               WHEN INFIELD(ptype)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_pma"  
                  LET g_qryparam.default1 = ptype
                  CALL cl_create_qry() RETURNING ptype
                  DISPLAY BY NAME ptype
            END CASE
      
         ON ACTION locale
            LET g_action_choice='locale'
            EXIT INPUT
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
      
          ON ACTION about         #MOD-4C0121
             CALL cl_about()      #MOD-4C0121
       
          ON ACTION help          #MOD-4C0121
             CALL cl_show_help()  #MOD-4C0121
      
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END INPUT
      
      IF g_action_choice = 'locale' THEN
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      
      IF INT_FLAG THEN
         RETURN
      END IF
      
      IF cl_sure(20,20) THEN
         LET g_success = 'Y'
         BEGIN WORK
 
         CALL p117_process()
         CALL s_showmsg()             #No.FUN-710014
 
         IF g_success = 'Y' THEN
            COMMIT WORK
            CALL cl_end2(1) RETURNING l_flag
         ELSE
            ROLLBACK WORK
            CALL cl_end2(2) RETURNING l_flag
         END IF
 
         IF l_flag THEN
            CONTINUE WHILE
         ELSE 
            EXIT WHILE
         END IF
      END IF
   END WHILE
 
END FUNCTION
 
FUNCTION p117_process()
 DEFINE   l_rvv87       LIKE rvv_file.rvv87    #No.MOD-950003 
 DEFINE   l_apa100_t    LIKE apa_file.apa100   #FUN-9C0140 luttb
 DEFINE   l_apa01_t     LIKE apa_file.apa01    #FUN-9C0140 luttb
 DEFINE   l_rvu27       LIKE rvu_file.rvu27    #FUN-BB0002 add 
   LET g_apa02 = g_apa.apa02
   LET g_apa21 = g_apa.apa21
   LET g_apa22 = g_apa.apa22
   LET g_apa36 = g_apa.apa36
   LET g_apa15 = g_apa.apa15

   CALL s_showmsg_init()
   LET g_start = ''
   LET g_sql = "SELECT azp01 FROM azp_file,azw_file ",
               " WHERE ",g_wc1 CLIPPED,
               "   AND azw01 = azp01 AND azw02 = '",g_legal,"'"
   PREPARE sel_azp03_pre FROM g_sql
   DECLARE sel_azp03_cs CURSOR FOR sel_azp03_pre
   LET t_azp01 = ' '   #luttb
   LET t_azp03 = ' '   #luttb
   LET t_rvv01 =' '
   LET t_apb06 =' '
   LET g_apa.apa01 = NULL
   LET t_pmn122=' '
   LET t_rvuplant =' '  
   LET t_rvu21 = ' '     
   FOREACH sel_azp03_cs INTO g_azp01
      IF STATUS THEN
         CALL cl_err('p310(ckp#1):',SQLCA.sqlcode,1)
         RETURN
      END IF
      LET g_plant_new = g_azp01
      CALL s_gettrandbs()
      LET l_dbs = g_dbs_tra
 
   #check帳款日和異動日不可有不同年月的情形發生
   IF NOT cl_null(g_apa02) THEN
      LET l_flag='N'
     #CALL p117_chkdate()       #CHI-A40012 mark
      IF l_flag ='X' THEN
         LET g_success = 'N'
         RETURN 
      END IF
      IF l_flag='Y' THEN
         LET g_success = 'N'
         CALL cl_err('','axr-065',1)
         RETURN
      END IF
   END IF
#No.MOD-B60115 --begin 
#  LET g_sql = "SELECT COUNT(*) ",
#            # "  FROM ",l_dbs CLIPPED,"rvu_file,",l_dbs CLIPPED,"rva_file,",l_dbs CLIPPED,"rvb_file,",l_dbs CLIPPED,"pmn_file,",           #FUN-A50102 mark
#            # "       ",l_dbs CLIPPED,"pmm_file LEFT OUTER JOIN gen_file ",                                                                #FUN-A50102 mark
#              "  FROM ",cl_get_target_table(g_azp01,'rvu_file'),",",cl_get_target_table(g_azp01,'rva_file'),",",        #FUN-A50102
#                        cl_get_target_table(g_azp01,'rvb_file'),",",cl_get_target_table(g_azp01,'pmn_file'),",",        #FUN-A50102
#                        cl_get_target_table(g_azp01,'pmm_file')," LEFT OUTER JOIN gen_file ",                           #FUN-A50102 
#              "                ON  pmm_file.pmm12 = gen_file.gen01 ",
#              "                LEFT OUTER JOIN gec_file ",
#              "                ON  pmm_file.pmm21 = gec_file.gec01 AND gec_file.gec011='1' ",
#              "                LEFT OUTER JOIN azi_file ",
#              "                ON  pmm_file.pmm22 = azi_file.azi01",
#            # "                LEFT OUTER JOIN ",l_dbs CLIPPED,"pma_file ",                          #FUN-A50102 mark
#              "                 LEFT OUTER JOIN ",cl_get_target_table(g_azp01,'pma_file'),           #FUN-A50102
#              "                ON  pmm_file.pmm20 = pma_file.pma01 AND pma_file.pma11 <> '3' ",
#              "                AND pma_file.pma11 <> '4' AND pma_file.pma11 <> '5' ",
#              "                AND pma_file.pma11 <> '6' AND pma_file.pma11 <> '7' ",
#              "                AND pma_file.pma11 <> '8', ",
#            # "       ",l_dbs CLIPPED,"rvv_file LEFT OUTER JOIN ",l_dbs CLIPPED,"ima_file ",         #FUN-A50102 mark
#              "       ",cl_get_target_table(g_azp01,'rvv_file')," LEFT OUTER JOIN ",                 #FUN-A50102
#                        cl_get_target_table(g_azp01,'ima_file'),                                     #FUN-A50102  
#              "                ON  rvv31 = ima_file.ima01 ",
#            # "                LEFT OUTER JOIN ",l_dbs CLIPPED,"pmc_file ",                          #FUN-A50102
#              "                LEFT OUTER JOIN ",cl_get_target_table(g_azp01,'pmc_file'),            #FUN-A50102 
#              "                ON  rvv06 = pmc_file.pmc01",
#              " WHERE ",g_wc CLIPPED,
#              "   AND rvv04 = rvb01 AND rvv05 = rvb02",
#              "   AND rvv04 = rva01 AND rvaconf='Y' ",
#              "   AND rvu01 = rvv01 AND rvuconf='Y' ",        #FUN-940083 add ,
#              "   AND rvv36 = pmm_file.pmm01 ",               #FUN-940083
#              "   AND (pmm_file.pmm25='2' OR pmm_file.pmm25 = '6')",     #FUN-940083
#              "   AND rvv36 = pmn_file.pmn01 AND rvv37 = pmn_file.pmn02",  #FUN-940083
#              "   AND rvv03 ='3' ",
#              "   AND (rvv87 - rvv23 - rvv88 > 0 OR rvv87=0) ",  #No.TQC-7B0083
#              "   AND rvv89 <>'Y' AND rvu10 = 'Y' "           #FUN-940083 add
#
#  #No.TQC-9A0193  --End  
#  CALL cl_replace_sqldb(g_sql) RETURNING g_sql                #FUN-A50102
#  CALL cl_parse_qry_sql(g_sql,g_azp01) RETURNING g_sql        #FUN-A50102
#  PREPARE p117_prepare1 FROM g_sql
#  DECLARE p117_cs1 CURSOR FOR p117_prepare1
#  OPEN p117_cs1
#  FETCH p117_cs1 INTO g_count
#  IF g_count = 0 AND g_aza.aza26 = '2' THEN
#     LET g_sql = "SELECT rvv06,'',rvv09,pmc04,pmc24,rvv01,rvv02,rvv03,rvv04,rvv05,",
#                 "       rvv36,rvv37,pmc22,rvv38,rvv87-rvv23-rvv88,'','',", 
#                 "       rvv31,'','','','','','','',",
#                 "       '','','','',pmc54,rvv25,'',rvu10,rvv930,rvuplant,rvu21 ",    #FUN-960141 add rvuplant #FUN-960140 add rty06       #FUN-9C0041 rty06->rvu21 
#               # "  FROM ",l_dbs CLIPPED,"rvu_file,",l_dbs CLIPPED,"rvv_file LEFT OUTER JOIN ",l_dbs CLIPPED,"ima_file ", #No.FUN-9C0140   #FUN-A50102
#                 "  FROM ",cl_get_target_table(g_azp01,'rvu_file'),",",cl_get_target_table(g_azp01,'rvv_file'),          #FUN-A50102    
#                 " LEFT OUTER JOIN ",cl_get_target_table(g_azp01,'ima_file'),                                             #FUN-A50102     
#                 "                         ON  rvv31 = ima_file.ima01 ",
#               # "                         LEFT OUTER JOIN ",l_dbs CLIPPED,"pmc_file ",  #No.FUN-9C0140                   #FUN-A50102
#                 "                         LEFT OUTER JOIN ",cl_get_target_table(g_azp01,'pmc_file'),                     #FUN-A50102   
#                 "                         ON  rvv06 = pmc_file.pmc01",
#                 " WHERE ",g_wc CLIPPED,
#                 "   AND rvuplant = '",g_azp01,"' ",            #FUN-9C0140 luttb
#                 "   AND rvv03 ='3' ",
#                 "   AND (rvv87-rvv23-rvv88 > 0 OR rvv87=0) ",  #No.TQC-7B0083
#                 "   AND rvu01 = rvv01 AND rvuconf='Y' ",       #FUN-940083 add ,
#                 "   AND rvv89 <>'Y' AND rvu10 = 'Y' "          #FUN-940083 add
#  ELSE   
#     LET g_sql = "SELECT rvv06,'',rvv09,pmc04,pmc24,rvv01,rvv02,rvv03,rvv04,rvv05,",        #No.TQC-850001
#                #"       rvv36,rvv37,pmm22,rvv38,rvv87-rvv23-rvv88,(rvv87-rvv23-rvv88)*rvb10,",   #TQC-6B0151  #No.TQC-7B0083 #MOD-AA0021 mark
#                 "       rvv36,rvv37,pmm22,rvv38,rvv87-rvv23-rvv88,(rvv87-rvv23-rvv88)*rvv38,",   #TQC-6B0151  #No.TQC-7B0083 #MOD-AA0021
#                #"       (rvv87-rvv23-rvv88)*rvb10t,",   #TQC-8A0079 add  #MOD-AA0021 mark
#                 "       (rvv87-rvv23-rvv88)*rvv38t,",   #TQC-8A0079 add  #MOD-AA0021
#                 "       rvv31,rva06,pmm20,pmm21,pmm44,pmm02,'',pmn122,",
#                 "       '','','','',pmc54,rvv25,rva04,rvu10,rvv930,rvuplant,rvu21 ",  #FUN-670064      #MOD-870073    #FUN-960141 add rvuplant #FUN-960140 add rty06   #FUN-9C0041 rty06->rvu21 
#               # "  FROM ",l_dbs CLIPPED,"rvu_file,",l_dbs CLIPPED,"rvv_file LEFT OUTER JOIN ",l_dbs CLIPPED,"rva_file ",      #FUN-A50102 mark
#                 "  FROM ",cl_get_target_table(g_azp01,'rvu_file'),",",cl_get_target_table(g_azp01,'rvv_file'),        #FUN-A50102
#                 "  LEFT OUTER JOIN ",cl_get_target_table(g_azp01,'rva_file'),                                         #FUN-A50102  
#                 "                         ON  rvv04 = rva_file.rva01 AND rva_file.rvaconf='Y' ",
#               # "                         LEFT OUTER JOIN ",l_dbs CLIPPED,"ima_file ",                  #FUN-A50102 mark
#                 "                         LEFT OUTER JOIN ",cl_get_target_table(g_azp01,'ima_file'),    #FUN-A50102
#                 "                         ON  rvv31 = ima_file.ima01 ",
#               # "                         LEFT OUTER JOIN ",l_dbs CLIPPED,"pmm_file ",                  #FUN-A50102 mark
#                 "                         LEFT OUTER JOIN ",cl_get_target_table(g_azp01,'pmm_file'),    #FUN-A50102   
#                 "                         ON  rvv36 = pmm_file.pmm01 ",
#               # "                         LEFT OUTER JOIN ",l_dbs CLIPPED,"pmn_file ",                  #FUN-A50102 mark
#                 "                         LEFT OUTER JOIN ",cl_get_target_table(g_azp01,'pmn_file'),    #FUN-A50102
#                 "                         ON  rvv36 = pmn_file.pmn01 AND rvv37 = pmn_file.pmn02",
#               # "                         LEFT OUTER JOIN ",l_dbs CLIPPED,"pmc_file ",                  #FUN-A50102 mark
#                 "                         LEFT OUTER JOIN ",cl_get_target_table(g_azp01,'pmc_file'),    #FUN-A50102   
#                 "                         ON  rvv06 = pmc_file.pmc01",
#               # "                         LEFT OUTER JOIN ",l_dbs CLIPPED,"rvb_file ",                  #FUN-A50102 mark
#                 "                         LEFT OUTER JOIN ",cl_get_target_table(g_azp01,'rvb_file'),    #FUN-A50102
#                 "                         ON  rvv04 = rvb_file.rvb01 AND rvv05 = rvb_file.rvb02",
#                 " WHERE ",g_wc CLIPPED,
#                 "   AND rvuplant = '",g_azp01,"' ",            #FUN-9C0140 luttb
#                 "   AND rvv03 ='3' ", 
#                 "   AND (rvv87 - rvv23 - rvv88 > 0 OR rvv87=0) ",
#                 "   AND rvu01 = rvv01 AND rvuconf='Y' ",     
#                 "   AND rvv89 <>'Y' AND rvu10 = 'Y' "       
#  END IF  #No.TQC-740142
   LET g_sql = "SELECT rvv06,'',rvv09,pmc04,pmc24,rvv01,rvv02,rvv03,rvv04,rvv05,",      
               "       rvv36,rvv37,pmm22,rvv38,rvv87-rvv23-rvv88,(rvv87-rvv23-rvv88)*rvv38,",  
               "       (rvv87-rvv23-rvv88)*rvv38t,",  
               "       rvv31,rva06,pmm20,pmm21,pmm44,pmm02,'',pmn122,",
               "       '','','','',pmc54,rvv25,rva04,rvu10,rvv930,rvuplant,rvu21 ", 
               "  FROM ",cl_get_target_table(g_azp01,'rvu_file'),",",cl_get_target_table(g_azp01,'rvv_file'),       
               "  LEFT OUTER JOIN ",cl_get_target_table(g_azp01,'rva_file'),                                       
               "                         ON  rvv04 = rva_file.rva01 AND rva_file.rvaconf='Y' ",
               "                         LEFT OUTER JOIN ",cl_get_target_table(g_azp01,'ima_file'),  
               "                         ON  rvv31 = ima_file.ima01 ",
               "                         LEFT OUTER JOIN ",cl_get_target_table(g_azp01,'pmm_file'),      
               "                         ON  rvv36 = pmm_file.pmm01 ",
               "                         LEFT OUTER JOIN ",cl_get_target_table(g_azp01,'pmn_file'),    
               "                         ON  rvv36 = pmn_file.pmn01 AND rvv37 = pmn_file.pmn02",
               "                         LEFT OUTER JOIN ",cl_get_target_table(g_azp01,'pmc_file'),  
               "                         ON  rvv06 = pmc_file.pmc01",
               "                         LEFT OUTER JOIN ",cl_get_target_table(g_azp01,'rvb_file'),  
               "                         ON  rvv04 = rvb_file.rvb01 AND rvv05 = rvb_file.rvb02",
               " WHERE ",g_wc CLIPPED,
               "   AND rvuplant = '",g_azp01,"' ",          
               "   AND rvv03 ='3' ", 
               "   AND (rvv87 - rvv23 - rvv88 > 0 OR rvv87=0) ",
               "   AND rvu01 = rvv01 AND rvuconf='Y' ",     
               "   AND rvv89 <>'Y' AND rvu10 = 'Y' ",
               "   AND rvu99 IS NULL "  #MOD-C50033 add

   #FUN-D70021--add--str--
   IF g_a='N' THEN
      LET g_sql=g_sql CLIPPED," AND rvv31 NOT LIKE 'MISC%'"
   END IF
   #FUN-D70021--add--end

   #FUN-D60083--add--str--
   IF g_b = 'N' THEN
      LET g_sql=g_sql CLIPPED," AND rvv32 NOT IN (SELECT jce02 FROM ",
                              cl_get_target_table(g_azp01,'jce_file'),
                              ")"
   END IF
   #FUN-D60083--add--end--
 
#No.MOD-B60115 --end
   IF summary_sw='1' THEN   #倉退單
      LET g_sql=g_sql CLIPPED, " ORDER BY rvuplant,rvu21,rvv01,rvv02 "   #FUN-960141   #FUN-960140 add rty06  #FUN-9C0041 rty06->rvu21
   END IF
   IF summary_sw='2' THEN   #采購單
      LET g_sql=g_sql CLIPPED, " ORDER BY rvuplant,rvu21,rvv36,rvv37 "   #FUN-960141   #FUN-960140 add rty06  #FUN-9C0041 rty06->rvu21
   END IF
   IF summary_sw='3' THEN   #廠商
      LET g_sql=g_sql CLIPPED, " ORDER BY rvuplant,rvu21,rvv06,rvv01 "   #No.TQC-7B0005   #FUN-960141  #FUN-960140 add rty06  #FUN-9C0041 rty06->rvu21
   END IF
   IF summary_sw='4' THEN   #來源營運中心
      LET g_sql=g_sql CLIPPED, " ORDER BY rvuplant,rvu21,rvv01,rvv02 "
   END IF
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql                    #FUN-A50102
   CALL cl_parse_qry_sql(g_sql,g_azp01) RETURNING g_sql            #FUN-A50102  
   PREPARE p117_prepare FROM g_sql
   IF STATUS THEN
      LET g_success = 'N'
      CALL cl_err('prepare:',STATUS,1) 
      RETURN
   END IF
 
   DECLARE p117_cs CURSOR WITH HOLD FOR p117_prepare

   FOREACH p117_cs INTO g_vendor,g_rvv01,g_rvv09,g_vendor2,g_apa.apa18,         #No.TQC-850001
                        g_apb.apb21,g_apb.apb22,g_apb.apb29,g_apb.apb04,
                        g_apb.apb05,g_apb.apb06,g_apb.apb07,g_apa.apa13,
                        g_apb.apb23,g_apb.apb09,g_apb.apb24,
                        g_apb24t,   #TQC-8A0079 add
                        g_apb.apb12,g_apa.apa09,g_apa.apa11,
                        g_apa.apa15,g_apa.apa17,g_pmm02,g_apa.apa22,g_pmn122,
                        g_apa.apa52,g_apa.apa16,t_azi.azi03,t_azi.azi04,  #No.TQC-770051
                        g_pmc54,g_rvv25,g_rva04,g_rvu10,g_rvv930,  #FUN-670064
                        g_rvuplant,g_rvu21   #FUN-960141    #FUN-960140 add rty06  #FUN-9C0041 rty06->rvu21
 
      IF STATUS THEN
         CALL s_errmsg('','','找倉退資料出錯:',SQLCA.sqlcode,1) #No.FUN-710014 Add
         LET g_success = 'N'
         EXIT FOREACH
      END IF
     #CHI-A40012---add---start---
      IF (YEAR(g_rvv09) != YEAR(g_apa02)) OR (MONTH(g_rvv09) != MONTH(g_apa02)) THEN 
         CALL s_errmsg('apb21',g_apb.apb21,'','axr-065',1)
         CONTINUE FOREACH
      END IF
     #CHI-A40012---add---end---
 
     #No.TQC-BA0178  --Begin
     IF g_rvv09  > g_apa02 THEN 
        CONTINUE FOREACH
     END IF 
     #No.TQC-BA0178  --End

     LET g_sql = "SELECT rvv87",
               # "  FROM ",l_dbs CLIPPED,"rvv_file",                #FUN-A50102 mark
                 "  FROM ",cl_get_target_table(g_azp01,'rvv_file'), #FUN-A50102 
                 " WHERE rvv01 = '",g_apb.apb21,"'",
                 "   AND rvv02 = '",g_apb.apb22,"'"
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql                #FUN-A50102
     CALL cl_parse_qry_sql(g_sql,g_azp01) RETURNING g_sql        #FUN-A50102 
     PREPARE sel_rvv_pre01 FROM g_sql
     EXECUTE sel_rvv_pre01 INTO l_rvv87
     IF l_rvv87 =0 THEN
       #若到aapt110找得到此張倉退單就跳過不產生
        LET l_cnt = 0
        SELECT COUNT(*) INTO l_cnt FROM apb_file,apa_file
         WHERE apa01=apb01 AND apa00='11'
           AND apb29='3'
           AND apb21=g_apb.apb21 AND apb22=g_apb.apb22
           AND apb37=g_azp01     #FUN-A20006

        IF l_cnt > 0 THEN
           CONTINUE FOREACH
        END IF
       #若在aapt210找得到此張倉退單就跳過不產生
        LET l_cnt = 0
        SELECT COUNT(*) INTO l_cnt FROM apb_file,apa_file
         WHERE apa01=apb01 AND apa00='21'
           AND apb21=g_apb.apb21 AND apb22=g_apb.apb22
          #AND apa01 <> g_apa.apa01                       #No.MOD-B80345 mark
           AND apb37 = g_azp01   #FUN-A20006
        IF l_cnt > 0 THEN
           CONTINUE FOREACH
        END IF
     END IF   #No.MOD-950003 
    #若倉退單對應的收貨單若已有發票就跳過不產生
     IF g_aza.aza26 = '0' THEN  #MOD-B70134 add
        LET l_cnt = 0
  
       #MOD-B70134 mark
       #IF g_aza.aza26 = '2' THEN
       #   LET g_sql = " SELECT COUNT(*) ",
       #             # "   FROM ",l_dbs CLIPPED,"rvw_file ",                #FUN-A50102 mark
       #               "   FROM ", cl_get_target_table(g_azp01,'rvw_file'), #FUN-A50102 
       #               "  WHERE rvw08 = '",g_apb.apb21,"'",
       #               "    AND rvw09 = '",g_apb.apb22,"'"
       #ELSE
       #MOD-B70134 mark--end 
         #FUN-BB0002 add START
           SELECT rvu27 INTO l_rvu27 FROM rvu_file WHERE rvu01 = g_apb.apb21
           IF cl_null(l_rvu27) THEN
              LET l_rvu27 = '1'
           END IF
           IF l_rvu27 = '2' OR l_rvu27 = '3'  OR l_rvu27 = '4' THEN
              LET g_sql = " SELECT COUNT(*) ",
                          "   FROM ",cl_get_target_table(g_azp01,'rvv_file')," ",
                          "  WHERE rvv01 = '",g_apb.apb21,"' AND rvv02 = '",g_apb.apb22,"'",
                          "     AND rvv22 IS NOT NULL AND rvv22 != ' '"
           ELSE
         #FUN-BB0002 add END
              LET g_sql = " SELECT COUNT(*) ",
                        # "   FROM ",l_dbs CLIPPED,"rvv_file,",l_dbs CLIPPED,"rvb_file",         #FUN-A50102 mark
                          "   FROM ",cl_get_target_table(g_azp01,'rvv_file'),",",                #FUN-A50102
                                     cl_get_target_table(g_azp01,'rvb_file'),                    #FUN-A50102    
                          "  WHERE rvv01 = '",g_apb.apb21,"' AND rvv02 = '",g_apb.apb22,"'",
                          "    AND rvv04 = rvb01       AND rvv05 = rvb02",
                          "    AND rvb22 IS NOT NULL   AND rvb22 != ' ' "
           END IF    #FUN-BB0002 add
       #END IF  #MOD-B70134 mark
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql                #FUN-A50102
        CALL cl_parse_qry_sql(g_sql,g_azp01) RETURNING g_sql        #FUN-A50102
        PREPARE sel_rvv_pre02 FROM g_sql
        EXECUTE sel_rvv_pre02 INTO l_cnt
        IF l_cnt > 0 THEN
           LET g_showmsg=g_apb.apb21,"/",g_apb.apb22   #MOD-9C0064                                   
           CALL s_errmsg('apb21,apb22',g_showmsg,'','aap-360',1)   #MOD-9C0064
           CONTINUE FOREACH
        END IF
     END IF  #MOD-B70134 add

     #CHI-AB0011 add --start--
     IF g_wc2 != ' 1=1' THEN
        LET l_cnt = 0
        LET g_sql="SELECT COUNT(*) FROM pmm_file ",
                  " WHERE ",g_wc2 CLIPPED,
                  "   AND pmm01 = '",g_apb.apb06,"'"
        PREPARE p117_precount FROM g_sql
        DECLARE p117_count CURSOR FOR p117_precount
        OPEN p117_count
        FETCH p117_count INTO l_cnt
        IF l_cnt = 0 THEN
           CONTINUE FOREACH
        END IF
     END IF
     #CHI-AB0011 add --end--
 
     #因為台灣版的pmm_file改為OUTER寫法,SQL中不允許判斷條件中有OR,如下例
     #   " AND (pmm_file.pmm25='2' OR pmm_file.pmm25 = '6')"
     #故改在FOREACH裡判斷
     #IF g_count != 0 OR g_aza.aza26 != '2' THEN   #MOD-CA0221 mark
         IF cl_null(g_apb.apb06) THEN
            IF cl_null(g_apb.apb04) THEN
               LET g_sql = " SELECT rvu111,rvu113,rvu115,'' ",
                         # "   FROM ",l_dbs CLIPPED,"rvu_file,",l_dbs CLIPPED,"rvv_file",      #FUN-A50102 mark
                           "   FROM ",cl_get_target_table(g_azp01,'rvu_file'),","              #FUN-A50102
                                     ,cl_get_target_table(g_azp01,'rvv_file'),                 #FUN-A50102     
                           "  WHERE rvv01 = rvu01 AND rvv01 = '",g_apb.apb21,"'",
                           "    AND rvv02 = '",g_apb.apb22,"'"
            ELSE
               LET g_sql = " SELECT rva111,rva113,rva115,rva10 ",
                         # "   FROM ",l_dbs CLIPPED,"rva_file,",l_dbs CLIPPED,"rvb_file",      #FUN-A50102 mark
                           "   FROM ",cl_get_target_table(g_azp01,'rva_file'),",",             #FUN-A50102
                                      cl_get_target_table(g_azp01,'rvb_file'),                 #FUN-A50102
                           "  WHERE rvb01 = rva01",
                           "    AND rvb01 = '",g_apb.apb04,"'",
                           "    AND rvb02 = '",g_apb.apb05,"'"
            END IF
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102
            CALL cl_parse_qry_sql(g_sql,g_azp01) RETURNING g_sql          #FUN-A50102 
            PREPARE sel_rvv_pre03 FROM g_sql
            EXECUTE sel_rvv_pre03 INTO g_apa.apa11,g_apa.apa13,g_apa.apa15,g_pmm02
            LET g_sql = "SELECT rvu07 ",
                      # "  FROM ",l_dbs CLIPPED,"rvu_file",                         #FUN-A50102 mark
                        "  FROM ",cl_get_target_table(g_azp01,'rvu_file'),          #FUN-A50102 
                        " WHERE rvu01 = '",g_apb.apb21,"' AND rvuconf != 'X' "
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql           #FUN-A50102
            CALL cl_parse_qry_sql(g_sql,g_azp01) RETURNING g_sql   #FUN-A50102
            PREPARE sel_rvu_pre04 FROM g_sql
            EXECUTE sel_rvu_pre04 INTO g_pmm.pmm12
            LET  g_apa.apa17 = ''
            LET  g_apa.apa22 = ''
            LET  g_pmn122 = ''
         ELSE
       # LET g_sql = "SELECT * FROM ",l_dbs CLIPPED,"pmm_file WHERE pmm01='",g_apb.apb06,"'"                   #FUN-A50102 mark
         LET g_sql = "SELECT * FROM ",cl_get_target_table(g_azp01,'pmm_file')," WHERE pmm01='",g_apb.apb06,"'" #FUN-A50102
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql          #FUN-A50102
         CALL cl_parse_qry_sql(g_sql,g_azp01) RETURNING g_sql  #FUN-A50102
         PREPARE sel_pmm_pre05 FROM g_sql
         EXECUTE sel_pmm_pre05 INTO g_pmm.*
         IF g_pmm.pmm25 != '2' AND g_pmm.pmm25 != '6' THEN
            CONTINUE FOREACH
         END IF
         #END IF    #FUN-940083 add  #MOD-CA0221 mark
         LET l_cnt = 0
       # LET g_sql = " SELECT COUNT(*) FROM ",l_dbs CLIPPED,"pma_file ",                           #FUN-A50102 mark
         LET g_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(g_azp01,'pma_file'),             #FUN-A50102 
                     "  WHERE pma01='",g_apa.apa11,"' AND pma11 MATCHES '[345678]' "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql               #FUN-A50102
         CALL cl_parse_qry_sql(g_sql,g_azp01) RETURNING g_sql       #FUN-A50102
         PREPARE sel_pma_pre06 FROM g_sql
         EXECUTE sel_pma_pre06 INTO l_cnt
         IF l_cnt > 0 THEN
            CONTINUE FOREACH
         END IF
 
         SELECT gen03 INTO g_apa.apa22 FROM gen_file
          WHERE gen01=g_pmm.pmm12
         SELECT gec04 INTO g_apa.apa16 FROM gec_file
          #WHERE gec01=g_pmm.pmm21 AND gec011='1'  #進項 #FUN-940083
          WHERE gec01=g_apa.apa15 AND gec011='1'  #進項  #FUN-940083
         SELECT azi03,azi04 INTO t_azi.azi03,t_azi.azi04 FROM azi_file
          #WHERE azi01=g_pmm.pmm22       #FUN-940083 mark
          WHERE azi01=g_apa.apa13        #FUN-940083
      END IF
 
      #FUN-C80022--add--str
      IF purchas_sw = 1 THEN
         IF g_pmm02 = 'SUB' THEN
            CONTINUE FOREACH
         END IF
      ELSE
         IF g_pmm02 != 'SUB' THEN
            CONTINUE FOREACH
         END IF
      END IF
      #FUN-C80022--add--end
     #大陸版付款條件(p_type)允許不輸入,以廠商(rvv06)帶出廠商檔的付款條件(pmc17)
     #IF g_aza.aza26 ='2' THEN        #No.MOD-B80028 mark
         IF cl_null(ptype) THEN
            LET g_pmc17 = ''
          # LET g_sql = "SELECT pmc17 FROM ",l_dbs CLIPPED,"pmc_file WHERE pmc01='",g_vendor,"'"   #FUN-A50102 mark
            LET g_sql = "SELECT pmc17 FROM ",cl_get_target_table(g_azp01,'pmc_file'),              #FUN-A50102
                        " WHERE pmc01='",g_vendor,"'"                                              #FUN-A50102           
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql               #FUN-A50102
            CALL cl_parse_qry_sql(g_sql,g_azp01) RETURNING g_sql       #FUN-A50102  
            PREPARE sel_pmc_pre07 FROM g_sql
            EXECUTE sel_pmc_pre07 INTO g_pmc17
            IF cl_null(g_pmc17) THEN LET g_pmc17=' ' END IF
            LET g_apa.apa11 = g_pmc17
         ELSE
            LET g_apa.apa11 = ptype    #No.TQC-7B0005 add 付款方式固定為界面輸入值
         END IF
     #ELSE                                                #No.MOD-B80028 mark 
     #   IF NOT cl_null(ptype) THEN   #TQC-9A0046 add     #No.MOD-B80028 mark
     #      LET g_apa.apa11 = ptype   #No.TQC-7B0005 add 付款方式固定為界面輸入值  #No.MOD-B80028 mark
     #   END IF                       #TQC-9A0046 add     #No.MOD-B80028 mark
     #END IF
 
         IF g_success='N' THEN  
            LET g_totsuccess='N'  
            LET g_success="Y"   
         END IF 
 
      LET g_rvv01=g_apb.apb21
      IF g_rva04 = 'Y' THEN 
         CONTINUE FOREACH
      END IF
 
     #只抓倉退資料
 
     #當沒有輸入收貨單號,無法串回採購單抓取幣別時,改抓廠商慣用幣別
      IF g_apa.apa13 IS NULL THEN
       # LET g_sql = "SELECT pmc22 FROM ",l_dbs CLIPPED,"pmc_file WHERE pmc01='",g_vendor,"'"      #FUN-A50102 mark
         LET g_sql = "SELECT pmc22 FROM ",cl_get_target_table(g_azp01,'pmc_file'),                 #FUN-A50102
                     " WHERE pmc01='",g_vendor,"'"                                                 #FUN-A50102
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql               #FUN-A50102
         CALL cl_parse_qry_sql(g_sql,g_azp01) RETURNING g_sql       #FUN-A50102
         PREPARE sel_pmc_pre08 FROM g_sql
         #EXECUTE sel_pmc_pre08 INTO g_pmc17     #MOD-CA0221 mark
         EXECUTE sel_pmc_pre08 INTO g_apa.apa13  #MOD-CA0221
      END IF
 
      IF g_apa.apa13 IS NULL THEN
         LET g_apa.apa13=g_aza.aza17
         SELECT * INTO t_azi.* FROM azi_file WHERE azi01=g_apa.apa13
      END IF
 
      SELECT * INTO t_azi.* FROM azi_file WHERE azi01=g_apa.apa13
 
     #check 有無已立暫估
      LET l_cnt=0
      SELECT COUNT(*) INTO l_cnt FROM apa_file,apb_file
       WHERE apa00='26' AND apa01=apb01    #FUN-680110
         AND apb21 = g_apb.apb21 AND apb22=g_apb.apb22  #No.3280
         AND apa42 <> 'Y' 
         AND apa08 = 'UNAP'     
         AND apb37=g_azp01    #FUN-A20006
      IF l_cnt !=0  THEN 
         CONTINUE FOREACH
      END IF

      DISPLAY g_apb.apb21,' ',g_apb.apb22 AT 1,1

 
      LET g_apa.apa52 = ''   #MOD-870073 add
      LET g_apa.apa521= ''   #MOD-870073 add
 
      IF g_apa.apa16 IS NULL THEN 
         LET g_apa.apa16 = 0 
      END IF
 
      IF t_azi.azi03 IS NULL THEN  #No.TQC-770051 g_azi -> t_azi
         LET t_azi.azi03 = 0       #No.TQC-770051 g_azi -> t_azi
      END IF
 
      IF t_azi.azi04 IS NULL THEN  #No.TQC-770051 g_azi -> t_azi
         LET t_azi.azi04 = 0       #No.TQC-770051 g_azi -> t_azi
      END IF
 
      IF g_apb.apb23 IS NULL OR g_rvv25='Y' THEN    #若為樣品則單價為0
         LET g_apb.apb23 = 0 
      END IF
 
      IF enter_account = "N" THEN
         IF g_apb.apb23 = 0 THEN
            CONTINUE FOREACH
         END IF
      END IF
 
      IF g_vendor2 IS NULL THEN
         LET g_vendor2 = g_vendor
      END IF
 
    # LET g_sql = " SELECT pmc03 FROM ",l_dbs CLIPPED,"pmc_file WHERE pmc01='",g_vendor2,"'"       #FUN-A50102 mark
      LET g_sql = " SELECT pmc03 FROM ",cl_get_target_table(g_azp01,'pmc_file'),                   #FUN-A50102
                  " WHERE pmc01='",g_vendor2,"'"                                                   #FUN-A50102
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102
      CALL cl_parse_qry_sql(g_sql,g_azp01) RETURNING g_sql      #FUN-A50102
      PREPARE sel_pmc_pre09 FROM g_sql
      EXECUTE sel_pmc_pre09 INTO g_abbr
 
      IF g_pmn122  IS NULL THEN
         LET g_pmn122  = ' '   
      END IF
 
      IF g_pmn122 !=t_pmn122
         OR g_rvu21 != t_rvu21          #FUN-9C0041  不同經營方式不可合并 
         OR ( summary_sw='1' AND g_apb.apb21 != t_rvv01 )      
         OR ( summary_sw='2' AND g_apb.apb06 != t_apb06 )      
         OR ( summary_sw='4' AND (g_azp01 != t_azp01 OR t_azp01 IS NULL))    #FUN-9C0140 luttb 
        #FUN-C80022 mark--str
        #OR ( purchas_sw = 'Y' AND #FUN-C70052 add
        #    ((g_pmm02 = 'SUB' AND g_pmm02 != g_pmm02_t)OR #FUN-C70052 add
        #     (g_pmm02_t = 'SUB' AND g_pmm02 != 'SUB')))  #FUN-C70052 add
        #FUN-C80022--mark--end
         OR ( summary_sw='3' AND
         #No.3300 多一括號將OR 條件括起來
         ( (t_vendor IS NULL OR g_vendor != t_vendor)      OR    #廠商
         #(t_pmm20  IS NULL OR g_apa.apa11 != t_pmm20)    OR    #付款條件      #MOD-D10264 mark
         ((t_pmm20 IS NULL AND g_aza.aza26 <> '2') OR (g_apa.apa11 != t_pmm20 AND g_aza.aza26 <> '2')) OR   #MOD-D10264
         (t_pmm22  IS NULL OR g_apa.apa13 != t_pmm22) ) ) THEN 
         #No.MOD-D60145  --Begin
         CALL p117_apa05('')
         IF NOT cl_null(g_errno) THEN
            LET g_success = 'N'
            CALL s_errmsg("apa05",g_vendor,'',g_errno,1)
            CONTINUE FOREACH
         END IF
         #No.MOD-D60145  --End
         IF g_apa.apa01 IS NOT NULL THEN
            CALL p117_upd_apa57(t_azp01)   #FUN-9C0140 luttb add 參數t_azp03
            CALL p117_ins_apc()  #No.TQC-7B0083
         END IF
         CALL p117_ins_apa()                                   #Insert Head
         IF g_success = 'N' THEN 
             CONTINUE FOREACH                #No.FUN-710014 
         END IF
        #LET g_pmm02_t = g_pmm02 #FUN-C70052 add
         LET l_apa100_t = g_apa.apa100
         LET l_apa01_t = g_apa.apa01
      ELSE
         IF g_azp01 <> l_apa100_t THEN
            UPDATE apa_file SET apa100 = ''
             WHERE apa01 = l_apa01_t
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","apa_file",g_apa.apa01,g_apa.apa100,SQLCA.sqlcode,"","",1)
               LET g_success ='N'
            END IF
         END IF
      END IF
 
      LET t_rvv01  = g_apb.apb21
      LET t_apb06  = g_apb.apb06
      LET t_vendor = g_vendor
      LET t_pmm20  = g_apa.apa11
      LET t_pmm21  = g_apa.apa15
      LET t_pmm22  = g_apa.apa13
      LET t_pmn122 = g_pmn122
      LET t_rvuplant = g_rvuplant  #FUN-960141
      LET t_rvu21 = g_rvu21        #FUN-9C0041
      LET t_azp01 = g_azp01     #FUN-9C0140 luttb
      LET t_azp03 = l_dbs       #FUN-9C0140 luttb
 
      SELECT azi03,azi04 INTO t_azi03,t_azi04 FROM azi_file
       WHERE azi01=g_apa.apa13
      CALL p117_ins_apb()
 
      IF g_success = 'N' THEN
          CONTINUE FOREACH     #No.FUN-710014 
      END IF
   END FOREACH
 END FOREACH    #FUN-9C0140 luttb add 
  IF g_totsuccess="N" THEN
           LET g_success="N"
  END IF 
 
   IF t_rvv01 IS NOT NULL THEN
      CALL p117_upd_apa57(g_azp01)   #FUN-9C0140 luttb add g_azp01
      CALL p117_ins_apc()  #No.TQC-7B0083
   END IF
 

   LET begin_no = g_start  #No.FUN-9C0140 Add 
   IF begin_no IS NOT NULL THEN
      DISPLAY begin_no TO start_no
      DISPLAY end_no   TO end_no
   ELSE
      CALL s_errmsg('','','','aap-129',1)   #No.FUN-710014   	
      LET g_success = 'N'    #MOD-BB0118 add
   END IF
 
END FUNCTION
 
FUNCTION p117_upd_apa57(m_azp01)   #FUN-9C0140 luttb 
  DEFINE l_apydmy3         LIKE apy_file.apydmy3   #FUN-5B0089 add
  DEFINE l_trtype          LIKE apy_file.apyslip   # No.FUN-690028 VARCHAR(5) #FUN-5B0089 add
  DEFINE l_azp03           LIKE type_file.chr21    #FUN-9C0140 luttb
  DEFINE m_azp01           LIKE azp_file.azp01     #FUN-9C0140 luttb
  DEFINE l_azp01           LIKE azp_file.azp01     #FUN-A20006 

#FUN-A20006--add--str--
 LET g_sql = "SELECT DISTINCT apb37 FROM apb_file ",
             " WHERE apb01 = '",g_apa.apa01,"'"
 PREPARE sel_apb37_pre FROM g_sql
 DECLARE sel_apb37_cur CURSOR FOR sel_apb37_pre
 FOREACH sel_apb37_cur INTO l_azp01
#FUN-A20006--add--end
 #IF cl_null(m_azp01) THEN   #FUN-A20006
  IF cl_null(l_azp01) THEN   #FUN-A20006
     LET l_azp03 = NULL
  ELSE
    #LET g_plant_new = m_azp01    #FUN-A20006
     LET g_plant_new = l_azp01    #FUN-A20006
     CALL s_gettrandbs()
     LET l_azp03 = g_dbs_tra
  END IF
  LET g_sql = "SELECT SUM(apb24),SUM(apb10) FROM apb_file,",
            #  l_azp03 CLIPPED,"rvv_file,",l_azp03 CLIPPED,"rvu_file ",                              #FUN-A50102 mark
               cl_get_target_table(l_azp01,'rvv_file'),",",cl_get_target_table(l_azp01,'rvu_file'),  #FUN-A50102
              " WHERE apb01='",g_apa.apa01,"' AND rvu01=rvv01 ", 
              "   AND rvuconf='Y'   AND apb21 = rvv01 ",
              "   AND apb37 = '",l_azp01,"' ",    #FUN-A20006
              "   AND apb22 = rvv02 AND rvv03 = '3' "
  CALL cl_replace_sqldb(g_sql) RETURNING g_sql            #FUN-A50102
  CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql    #FUN-A50102  
  PREPARE sel_sum_apb24 FROM g_sql
  EXECUTE sel_sum_apb24 INTO f_amt1,g_amt1

    IF f_amt1 IS NULL THEN LET f_amt1 = 0 END IF
    IF g_amt1 IS NULL THEN LET g_amt1 = 0 END IF
    
 
    #no.4191幣別取位必須要抓t_pmm22的
    #       否則會用到上一張的幣別取位
    IF NOT cl_null(t_pmm22) THEN
       SELECT azi04 INTO t_azi.azi04                        #No.CHI-6A0004 g_azi-->t_azi
        FROM azi_file 
        WHERE azi01 = t_pmm22
    END IF
    IF NOT cl_null(g_apa15) THEN                                              
       LET g_apa.apa15=g_apa15                                                
       LET g_apa.apa16=g_gec04                                                
    END IF                                                                    
    IF cl_null(g_apa.apa16) THEN LET g_apa.apa16 = 0 END IF
   #暫估款皆為零稅不申報
    LET g_apa.apa31f=f_amt1
    LET g_apa.apa31 =g_amt1
    LET g_apa.apa31f= cl_digcut(g_apa.apa31f,t_azi.azi04)    #No.CHI-6A0004 g_azi-->t_azi
    LET g_apa.apa31 = cl_digcut(g_apa.apa31 ,g_azi04)        #No.TQC-770051
 
    LET g_apa.apa32f= g_apa.apa31f* g_apa.apa16 / 100   # 四舍五入
    LET g_apa.apa32f= cl_digcut(g_apa.apa32f,t_azi.azi04)    #No.CHI-6A0004 g_azi-->t_azi 
    LET g_apa.apa32 = g_apa.apa31 * g_apa.apa16 / 100   # 四舍五入
    LET g_apa.apa32 = cl_digcut(g_apa.apa32,g_azi04)         #No.TQC-770051
 
    LET g_apa.apa34f=g_apa.apa31f+g_apa.apa32f
    LET g_apa.apa34 =g_apa.apa31 +g_apa.apa32
 
    LET g_apa.apa57f=f_amt1
    LET g_apa.apa57 =g_amt1
    LET g_apa.apa33f=g_apa.apa57f-g_apa.apa31f
    LET g_apa.apa33 =g_apa.apa57 -g_apa.apa31
    IF g_apa.apa31f<>g_apa.apa57f+g_apa.apa60f OR
       g_apa.apa31 <>g_apa.apa57 +g_apa.apa60  THEN #MOD-940411 mod
       LET g_apa.apa56 = '1'
       LET g_apa.apa19 = g_apz.apz12
       LET g_apa.apa20 = g_apa.apa31f+g_apa.apa32f
    END IF
    LET g_apa.apa73=g_apa.apa34-g_apa.apa35    
    CALL p117_comp_oox(g_apa.apa01) RETURNING g_net   #MOD-AC0113 mod 
    LET g_apa.apa73=g_apa.apa34-g_apa.apa35 + g_net  
   #FUN-A20006--mod--str--
   #UPDATE apa_file set apa31f=g_apa.apa31f,
   #                    apa31=g_apa.apa31,
   #                    apa32f=g_apa.apa32f,
   #                    apa32=g_apa.apa32,
   #                    apa34f=g_apa.apa34f,
   #                    apa34=g_apa.apa34,
   #                    apa73=g_apa.apa73,    
   #                    apa57f=g_apa.apa57f,
   #                    apa57=g_apa.apa57,
   #                    apa33f=g_apa.apa33f,
   #                    apa33=g_apa.apa33,
   #                    apa56=g_apa.apa56,
   #                    apa19=g_apa.apa19,
   #                    apa20=g_apa.apa20
    UPDATE apa_file set apa31f=apa31f+g_apa.apa31f,
                        apa31=apa31+g_apa.apa31,
                        apa32f=apa32f+g_apa.apa32f,
                        apa32=apa32+g_apa.apa32,
                        apa34f=apa34f+g_apa.apa34f,
                        apa34=apa34+g_apa.apa34,
                        apa73=apa73+g_apa.apa73,
                        apa57f=apa57f+g_apa.apa57f,
                        apa57=apa57+g_apa.apa57,
                        apa33f=apa33f+g_apa.apa33f,
                        apa33=apa33+g_apa.apa33,
                       #apa56 = apa56+g_apa.apa56,    #MOD-C50181 mark
                        apa56 = g_apa.apa56,          #MOD-C50181 add
                        apa15 = g_apa.apa15,    #MOD-AA0021 
                        apa16 =g_apa.apa16,    #MOD-AA0021
                       #apa19 = apa19+g_apa.apa19,    #MOD-C50181 mark
                        apa19 = g_apa.apa19,          #MOD-C50181 add
                        apa20=apa20+g_apa.apa20
   #FUN-A20006--mod--end
        WHERE apa01 = g_apa.apa01
 END FOREACH    #FUN-A20006
    LET l_trtype = trtype[1,g_doc_len]
    SELECT apydmy3 INTO l_apydmy3 FROM apy_file WHERE apyslip = l_trtype
    IF SQLCA.sqlcode THEN
        CALL s_errmsg('trtype',l_trtype,'sel apy:',STATUS,1)    #No.FUN-710014
        LET g_success = 'N'
    END IF
    IF l_apydmy3 = 'Y' THEN   #是否拋轉傳票
       CALL t110_g_gl(g_apa.apa00,g_apa.apa01,'0',m_azp01)  #No.FUN-680029 新增參數'0'  #No.FUN-9C0140 Add m_azp01
       IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
          CALL t110_g_gl(g_apa.apa00,g_apa.apa01,'1',m_azp01) #No.FUN-9C0140 Add m_azp01
       END IF
    END IF
 
END FUNCTION
 
FUNCTION p117_ins_apa()
    DEFINE l_gen03     LIKE gen_file.gen03
    DEFINE li_result LIKE type_file.num5    #No.FUN-690028 SMALLINT
    DEFINE l_depno     LIKE apa_file.apa22     #FUN-960140
    DEFINE g_t2      LIKE apy_file.apyslip       #MOD-990168        
    LET g_apa.apa02 = g_apa02 
    LET g_apa.apa36 = g_apa36 
    IF g_apa.apa19 = g_apz.apz12 THEN
       LET g_apa.apa56 = '0'
       LET g_apa.apa19 = NULL
       LET g_apa.apa20 = 0
    END IF
    LET g_apa.apa00 = '26'    #FUN-680110
    LET g_apa.apa05 = g_vendor
    #CHI-A90002 add --start--
    CALL p117_apa05('')
    IF NOT cl_null(g_errno) THEN
       LET g_success = 'N'
       CALL s_errmsg("apa05",g_apa.apa05,'',g_errno,1)
       RETURN
    END IF
    #CHI-A90002 add --end--
    LET g_apa.apa06 = g_vendor2
    LET g_apa.apa07 = g_abbr
    LET g_apa.apa08 = 'UNAP'
    CALL s_paydate_m(g_azp01,'a','',g_apa.apa09,g_apa.apa02,g_apa.apa11,g_apa.apa06) #No.FUN-9C0140
         RETURNING g_apa.apa12,g_apa.apa64,g_apa.apa24
 
    LET g_apa.apa14 = 1
    CALL s_curr3(g_apa.apa13,g_apa.apa02,g_apz.apz33) RETURNING g_apa.apa14 #FUN-640022
    LET g_apa.apa72 = g_apa.apa14             
    IF cl_null(g_apa.apa21) THEN
       IF cl_null(g_apb.apb06) THEN
 
          LET g_sql = " SELECT rvu07 ",
                    # "   FROM ",l_dbs CLIPPED,"rvu_file",                            #FUN-A50102 mark
                      "   FROM ",cl_get_target_table(g_azp01,'rvu_file'),             #FUN-A50102
                      "  WHERE rvu01 = '",g_apb.apb21,"' AND rvuconf != 'X'"
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102
          CALL cl_parse_qry_sql(g_sql,g_azp01) RETURNING g_sql      #FUN-A50102
          PREPARE sel_rvu_pre10 FROM g_sql
          EXECUTE sel_rvu_pre10 INTO g_pmm12
       ELSE

         #LET g_sql = " SELECT pmm12 FROM ",l_dbs CLIPPED,"pmm_file ",                #FUN-A50102 mark
          LET g_sql = " SELECT pmm12 FROM ",cl_get_target_table(g_azp01,'pmm_file'),  #FUN-A50102  
                      "  WHERE pmm01 ='",g_apb.apb06,"'",
                      "    AND pmm18 !='X'"
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102
          CALL cl_parse_qry_sql(g_sql,g_azp01) RETURNING g_sql      #FUN-A50102  
          PREPARE sel_pmm_pre11 FROM g_sql
          EXECUTE sel_pmm_pre11 INTO g_pmm12
       END IF         #FUN-940083 add
       LET g_apa.apa21 = g_pmm12
    END IF
    IF cl_null(g_apa.apa22) THEN 
       SELECT gen03 INTO l_gen03 FROM gen_file WHERE gen01=g_pmm12
       LET g_pmm13=l_gen03 
       LET g_apa.apa22 = g_pmm13
    END IF
 
    IF cl_null(g_apa.apa22) AND g_aza.aza26 = '2' AND g_count = 0 THEN
       SELECT gen03 INTO l_gen03 FROM gen_file WHERE gen01=g_apa.apa21
       LET g_apa.apa22 = l_gen03
    END IF
 
    SELECT gec06,gec08 INTO g_apa.apa172,g_apa.apa171 FROM gec_file
     WHERE gec01 = g_apa.apa15
    LET g_apa.apa17 = '1'
    IF cl_null(g_apa.apa171) THEN LET g_apa.apa171 = 'XX' END IF
    IF cl_null(g_apa.apa172) THEN
       CASE 
          WHEN g_apa.apa16 = 0   LET g_apa.apa172 = '2' 
          WHEN g_apa.apa16 = 100 LET g_apa.apa172 = '3' 
          OTHERWISE              LET g_apa.apa172 = '1' 
       END CASE
    END IF
    LET g_apa.apa20 = 0
    LET g_apa.apa31f= 0 LET g_apa.apa31 = 0
    LET g_apa.apa32f= 0 LET g_apa.apa32 = 0
    LET g_apa.apa33f= 0 LET g_apa.apa33 = 0
    LET g_apa.apa34f= 0 LET g_apa.apa34 = 0
    LET g_apa.apa73 = 0       
    LET g_apa.apa35f= 0 LET g_apa.apa35 = 0
    LET g_apa.apa65f= 0 LET g_apa.apa65 = 0
    LET g_apa.apa41 = 'N'
    LET g_apa.apa42 = 'N'
    LET g_apa.apa55 = '1'
    LET g_apa.apa56 = '0'
    LET g_apa.apa57f= 0 LET g_apa.apa57 = 0
    LET g_apa.apa60f= 0 LET g_apa.apa60 = 0
    LET g_apa.apa61f= 0 LET g_apa.apa61 = 0
    LET g_apa.apa66 = g_pmn122  
    LET g_apa.apa74 = 'N'
    LET g_apa.apa75 = 'N'
    LET g_apa.apaacti = 'Y'
    LET g_apa.apainpd = g_today
    LET g_apa.apauser = g_user
    LET g_apa.apagrup = g_grup
    LET g_apa.apadate = g_today
    LET g_apa.apa58='2'
    LET g_apa.apa63 = 0   #No.TQC-970205
    IF g_azw.azw04 = '2' AND (g_rvu21 = '2' OR g_rvu21 = '3') THEN  #經營方式為代銷                                                                         
       IF g_apz.apz13 = 'Y' THEN                                                                                                    
          LET l_depno = g_apa.apa22                                                                                                 
       ELSE                                                                                                                         
          LET l_depno = ' '                                                                                                         
       END IF                                                                                                                       
       SELECT apt06 INTO g_apa.apa51 FROM apt_file                                                                                  
        WHERE apt01 = g_apa.apa36 AND apt02 = l_depno                                                                               
       IF g_aza.aza63 = 'Y' THEN                                                                                                    
          SELECT apt061 INTO g_apa.apa511 FROM apt_file                                                                             
           WHERE apt01 = g_apa.apa36 AND apt02 = l_depno                                                                            
       END IF                                                                                                                       
    END IF                                                                                                                          
    LET g_apa.apa930=s_costcenter_stock_apa(g_apa.apa22,g_rvv930,g_apa.apa51)  #FUN-670064
    LET g_t2 = trtype[1,g_doc_len]                                                                                                  
    SELECT apyapr INTO g_apa.apamksg FROM apy_file                                                                                  
     WHERE apyslip = g_t2                 
   
    IF summary_sw='1' THEN   #倉退單
       IF NOT cl_null(trtype) THEN
          CALL s_auto_assign_no("aap",trtype,g_apa.apa02,g_apa.apa00,"","","","","")
                                RETURNING li_result,g_apa.apa01 
          IF (NOT li_result) THEN                                                                                              
              RETURN                                                                                                            
          END IF
       ELSE
          LET g_apa.apa01=g_apb.apb21
          LET g_apa.apamksg ='N'
       END IF
    ELSE
       CALL s_auto_assign_no("aap",trtype,g_apa.apa02,g_apa.apa00,"","","","","")
                             RETURNING li_result,g_apa.apa01
          IF (NOT li_result) THEN                                                                                              
              RETURN                                                                                                            
          END IF
       LET g_apa.apamksg = g_apy.apyapr
    END IF
    DISPLAY "insert apa:",g_apa.apa01,' ',g_apa.apa02,' ',g_apa.apa06
            AT 2,1
    LET g_apa.apaprno = 0   #MOD-830072
    LET g_apa.apa100 = g_azp01      #FUN-9C0140 luttb
    LET g_apa.apalegal= g_legal     #FUN-980001 add
    LET g_apa.apa76 = g_rvu21       #FUN-9C0041 
    LET g_apa.apa79 = '0'           #FUN-A40003      #No.FUN-A60024
    INSERT INTO apa_file VALUES(g_apa.*)
    IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
       CALL s_errmsg('apa01',g_apa.apa01,'p117_ins_apa(ckp#1)',SQLCA.sqlcode,1)    #No.FUN-710014 Add
       LET g_success = 'N'
    END IF
    IF begin_no IS NULL THEN LET begin_no=g_apa.apa01 END IF
    IF cl_null(g_start) AND NOT cl_null(begin_no) THEN
       LET g_start = begin_no
    END IF
    LET end_no=g_apa.apa01
    LET g_pmm12 = g_apa21
    LET g_pmm13 = g_apa22
    LET g_pmn40 = ' '
    LET g_apb.apb01 = g_apa.apa01
    LET g_apb.apb02 = 0
    LET g_apb.apb13f = 0 LET g_apb.apb13 = 0
    LET g_apb.apb14f = 0 LET g_apb.apb14 = 0
    LET g_apb.apb15  = 0
    LET g_apb.apb930 = s_costcenter_stock_apb(g_apa.apa930,g_rvv930,g_apa.apa51)  #FUN-670064
END FUNCTION
 
FUNCTION p117_ins_apb()
    DEFINE l_invoice   LIKE apa_file.apa08
    DEFINE l_depno     LIKE apa_file.apa22
    DEFINE l_d_actno   LIKE apa_file.apa51
    DEFINE l_c_actno   LIKE apa_file.apa54
    DEFINE l_pmk13     LIKE pmk_file.pmk13
    DEFINE l_gec04     LIKE gec_file.gec04     #TQC-8A0079 add
    DEFINE l_gec07     LIKE gec_file.gec07     #TQC-8A0079 add
    DEFINE l_pmn24     LIKE pmn_file.pmn24     #FUN-930165 add 
    DEFINE l_rvv31     LIKE rvv_file.rvv31     #FUN-D60083 add
    DEFINE l_rvv32     LIKE rvv_file.rvv32     #FUN-960140 add
    DEFINE l_rvv33     LIKE rvv_file.rvv33     #FUN-960140 add
    DEFINE l_azf141    LIKE azf_file.azf141  #FUN-B80058
    DEFINE l_n         LIKE type_file.num5     #FUN-D60083 add
 
    SELECT MAX(apb02)+1 INTO g_apb.apb02 FROM apb_file WHERE apb01=g_apb.apb01
    IF g_apb.apb02 IS NULL THEN LET g_apb.apb02 = 1 END IF
 
    LET g_apb.apb23 = cl_digcut(g_apb.apb23,t_azi03)   #No.CHI-6A0004 g_azi--t_azi      #MOD-920250
    IF g_apb.apb09 IS NULL THEN LET g_apb.apb09 = 0 END IF

   #當異動類別(apb29)為3.倉退,且數量(apb09)為0時,金額直接抓rvv39,rvv39t
    IF g_apb.apb29 = '3' AND g_apb.apb09 = 0 THEN
 
       LET g_sql = "SELECT rvv39,rvv39t ",
                 # "  FROM ",l_dbs CLIPPED,"rvv_file",                         #FUN-A50102 mark
                   "  FROM ",cl_get_target_table(g_azp01,'rvv_file'),          #FUN-A50102
                   " WHERE rvv01='",g_apb.apb21,"'",
                   "   AND rvv02='",g_apb.apb22,"'"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
       CALL cl_parse_qry_sql(g_sql,g_azp01) RETURNING g_sql     #FUN-A50102
       PREPARE sel_rvv_pre12 FROM g_sql
       EXECUTE sel_rvv_pre12 INTO g_apb.apb24,g_apb24t
       IF cl_null(g_apb.apb24) THEN LET g_apb.apb24=0 END IF
       IF cl_null(g_apb24t) THEN LET g_apb24t=0 END IF
    END IF
    LET g_apb.apb37 = g_azp01           #FUN-9C0140 luttb
   #單價含稅時,不使用單價*數量=金額,改以含稅金額回推稅率,以避免小數位差的問題
    LET l_gec04 = 0   LET l_gec07 = ''
    IF cl_null(g_apb.apb06) THEN
      #FUN-A60056--mod--str--
      #SELECT gec04,gec07 INTO l_gec04,l_gec07
      #  FROM gec_file,rvu_file
      # WHERE gec01 = rvu115 AND rvu01 = g_apb.apb21
       LET g_sql = "SELECT gec04,gec07 FROM ",cl_get_target_table(g_apb.apb37,'gec_file'),",",
                     cl_get_target_table(g_apb.apb37,'rvu_file'),
                   " WHERE gec01 = rvu115 AND rvu01 = '",g_apb.apb21,"'"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql
       CALL cl_parse_qry_sql(g_sql,g_apb.apb37) RETURNING g_sql
       PREPARE sel_gec07_cs FROM g_sql
       EXECUTE sel_gec07_cs INTO l_gec04,l_gec07
      #FUN-A60056--mod--end
    ELSE
   #FUN-A60056--mod--str--
   #SELECT gec04,gec07 INTO l_gec04,l_gec07 FROM gec_file,pmm_file
   # WHERE gec01 = pmm21 AND pmm01 = g_apb.apb06
    LET g_sql = "SELECT gec04,gec07 FROM ",cl_get_target_table(g_apb.apb37,'gec_file'),",",
                  cl_get_target_table(g_apb.apb37,'pmm_file'),
                " WHERE gec01 = pmm21 AND pmm01 = '",g_apb.apb06,"'"
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql
    CALL cl_parse_qry_sql(g_sql,g_apb.apb37) RETURNING g_sql
    PREPARE sel_gec07_cs1 FROM g_sql
    EXECUTE sel_gec07_cs1 INTO l_gec04,l_gec07
   #FUN-A60056--mod--end
    END IF      #FUN-940083 add 
    IF cl_null(l_gec04) THEN LET l_gec04=0   END IF
    IF cl_null(l_gec07) THEN LET l_gec07='N' END IF
    IF l_gec07='Y' THEN
       LET g_apb24t = cl_digcut(g_apb24t,t_azi.azi04)    #MOD-920013 add
       LET g_apb.apb24 = g_apb24t / (1+l_gec04/100)
    ELSE
       IF g_apb.apb09>0 THEN
          LET g_apb.apb24 = g_apb.apb23 * g_apb.apb09
       END IF
    END IF
    LET g_apb.apb24 = cl_digcut(g_apb.apb24,t_azi.azi04)   #No.CHI-6A0004 g_azi-->t_azi
 
    LET g_apb.apb08 = g_apb.apb23 * g_apa.apa14
    LET g_apb.apb08 = cl_digcut(g_apb.apb08,g_azi03)        #No.TQC-770051
    LET g_apb.apb10 = g_apb.apb24 * g_apa.apa14
    LET g_apb.apb10 = cl_digcut(g_apb.apb10,g_azi04)        #No.TQC-770051
    LET g_apb.apb081 = g_apb.apb08
    LET g_apb.apb101 = g_apb.apb10
 
   # 帶出品名,單位,科目,部門
    LET g_pmn401 = ''  #No.FUN-680029 
    LET g_apb.apb27 = ''   #TQC-8C0025 add
    IF cl_null(g_apb.apb06) THEN

       #LET g_sql = " SELECT rvv031,rvv35 ",           #yinhy131205 mark
       LET g_sql = " SELECT rvv031,rvv86 ",            #yinhy131205
                 # "   FROM ",l_dbs CLIPPED,"rvv_file ",                   #FUN-A50102 mark
                   "   FROM ",cl_get_target_table(g_azp01,'rvv_file'),     #FUN-A50102
                   "  WHERE rvv01 = '",g_apb.apb21,"'",
                   "    AND rvv02 = '",g_apb.apb22,"'"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql           #FUN-A50102 
       CALL cl_parse_qry_sql(g_sql,g_azp01) RETURNING g_sql   #FUN-A50102
       PREPARE sel_rvv_pre13 FROM g_sql
       EXECUTE sel_rvv_pre13 INTO g_apb.apb27,g_apb.apb28
       LET g_pmn401 = ''
       LET g_apb.apb26 = ''
       LET l_pmk13= ''

       LET g_sql = " SELECT ima39 ",
                 # "   FROM ",l_dbs CLIPPED,"ima_file",                #FUN-A50102 mark
                   "   FROM ",cl_get_target_table(g_azp01,'ima_file'), #FUN-A50102 
                   "  WHERE ima01 = '",g_apb.apb12,"'"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql            #FUN-A50102
       CALL cl_parse_qry_sql(g_sql,g_azp01) RETURNING g_sql    #FUN-A50102
       PREPARE sel_ima_pre14 FROM g_sql
       EXECUTE sel_ima_pre14 INTO g_apb.apb25
    ELSE

       LET g_sql = "SELECT pmn041,pmn07,pmn40,pmn401,pmn67,pmk13,pmn24",
                 # "  FROM ",l_dbs CLIPPED,"pmn_file LEFT OUTER JOIN ",l_dbs CLIPPED,"pmk_file ON pmn_file.pmn24 = pmk_file.pmk01",         #FUN-A50102 mark
                   "  FROM ",cl_get_target_table(g_azp01,'pmn_file')," LEFT OUTER JOIN ",                           #FUN-A50102
                             cl_get_target_table(g_azp01,'pmk_file')," ON pmn_file.pmn24 = pmk_file.pmk01",          #FUN-A50102
                   " WHERE pmn01='",g_apb.apb06,"' AND pmn02='",g_apb.apb07,"'"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql           #FUN-A50102
       CALL cl_parse_qry_sql(g_sql,g_azp01) RETURNING g_sql   #FUN-A50102
       PREPARE sel_pmn_pre15 FROM g_sql
       EXECUTE sel_pmn_pre15 INTO g_apb.apb27,g_apb.apb28,g_apb.apb25,g_pmn401,g_apb.apb26,l_pmk13,l_pmn24
    END IF         #FUN-940083  add
    IF g_apb.apb12[1,4]='MISC' AND NOT cl_null(l_pmn24) THEN

       LET g_sql = " SELECT pmk13 ",
                 # "   FROM ",l_dbs CLIPPED,"pmn_file ",                           #FUN-A50102 mark
                 # "   LEFT OUTER JOIN ",l_dbs CLIPPED,"pmk_file ",                #FUN-A50102 mark
                   "   FROM ",cl_get_target_table(g_azp01,'pmn_file'),             #FUN-A50102
                   "   LEFT OUTER JOIN ",cl_get_target_table(g_azp01,'pmk_file'),  #FUN-A50102 
                   "     ON pmn_file.pmn24 = pmk_file.pmk01 ",
                   "  WHERE pmn01='",g_apb.apb06,"' AND pmn02='",g_apb.apb07,"'",
                   "    AND pmn24='",l_pmn24,"'"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql                    #FUN-A50102
       CALL cl_parse_qry_sql(g_sql,g_azp01) RETURNING g_sql            #FUN-A50102 
       PREPARE sel_pmn_pre16 FROM g_sql
       EXECUTE sel_pmn_pre16 INTO g_apb.apb26
    END IF 
    IF g_aza.aza63 = 'Y' THEN
       LET g_apb.apb251 = g_pmn401
    END IF
    IF cl_null(g_apb.apb27) THEN     # 帶出品名,單位
     # LET g_sql = " SELECT ima02,ima25 FROM ",l_dbs CLIPPED,"ima_file",                 #FUN-A50102 mark
       LET g_sql = " SELECT ima02,ima25 FROM ",cl_get_target_table(g_azp01,'ima_file'),  #FUN-A50102
                   "  WHERE ima01='",g_apb.apb12,"'"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql            #FUN-A50102
       CALL cl_parse_qry_sql(g_sql,g_azp01) RETURNING g_sql    #FUN-A50102	
       PREPARE sel_ima_pre17 FROM g_sql
       EXECUTE sel_ima_pre17 INTO g_apb.apb27,g_apb.apb28
    END IF
    DISPLAY "insert apb:",g_apb.apb01,' ',g_apb.apb02,' ',
                          g_apb.apb21,' ',g_apb.apb22,' ',g_apb.apb10 AT 3,1
    IF cl_null(g_apb.apb13f) THEN LET g_apb.apb13f = 0 END IF
    IF cl_null(g_apb.apb13)  THEN LET g_apb.apb13  = 0 END IF
    IF cl_null(g_apb.apb14f) THEN LET g_apb.apb14f = 0 END IF
    IF cl_null(g_apb.apb14)  THEN LET g_apb.apb14  = 0 END IF
    IF cl_null(g_apb.apb15)  THEN LET g_apb.apb15  = 0 END IF
    LET g_apb.apb34 = 'N'    #No.TQC-7B0083
 
    IF (g_rvu21 = '2' OR g_rvu21 = '3') AND g_apa.apa51 = 'STOCK' THEN  #經營方式為代銷且借方科目為STOCK,則抓代銷科目
     # LET g_sql = " SELECT rvv32,rvv33 FROM ",l_dbs CLIPPED,"rvv_file ",                   #FUN-A50102 mark
       LET g_sql = " SELECT rvv31,rvv32,rvv33 FROM ",cl_get_target_table(g_azp01,'rvv_file'),     #FUN-A50102 #FUN-D60083 add rvv31
                   "  WHERE rvv01 = '",g_apb.apb21,"' AND rvv02 = '",g_apb.apb22,"'"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql            #FUN-A50102
       CALL cl_parse_qry_sql(g_sql,g_azp01) RETURNING g_sql    #FUN-A50102
       PREPARE sel_rvv_pre18 FROM g_sql
       EXECUTE sel_rvv_pre18 INTO l_rvv31,l_rvv32,l_rvv33   #FUN-D60083 add l_rvv31
       #FUN-D60083--add--str--
       SELECT count(*) INTO l_n FROM jce_file
        WHERE jce02 = l_rvv32
       IF l_n > 0 THEN
          SELECT ima164 INTO g_apb.apb25 FROM ima_file
           WHERE ima01 = l_rvv31
          IF cl_null(g_apb.apb25) THEN
             CALL s_errmsg('',l_rvv31,'','aap-445',1)
             LET g_success = 'N'
          END IF
       ELSE
       #FUN-D60083--add--end--
          CALL p117_stock_act(g_apb.apb12,l_rvv32,l_rvv33,'0')                                     
               RETURNING g_apb.apb25         
       END IF   #FUN-D60083 add                                                          
       IF g_aza.aza63 = 'Y' THEN                    
          #FUN-D60083--add--str--
          IF l_n > 0 THEN
             SELECT ima1641 INTO g_apb.apb251 FROM ima_file
              WHERE ima01 = l_rvv31
             IF cl_null(g_apb.apb251) THEN
                CALL s_errmsg('',l_rvv31,'','aap-445',1)
                LET g_success = 'N'
             END IF
          ELSE
          #FUN-D60083--add--end--                                                   
             CALL p117_stock_act(g_apb.apb12,l_rvv32,l_rvv33,'1')                                      
                  RETURNING g_apb.apb251                                
          END IF #FUN-D60083 add                                                             
       END IF
    ELSE
      IF cl_null(g_apb.apb06) THEN
         LET g_apb.apb25  = ''
         LET g_apb.apb251 = ''
         LET g_apb.apb26  = ''
         LET g_apb.apb35  = ''
         LET g_apb.apb36  = ''
         LET g_apb.apb31  = ''
      ELSE
 
         LET g_sql = " SELECT pmn40,pmn401,pmn67,pmn122,pmn96,pmn98",
                   # "   FROM ",l_dbs CLIPPED,"pmn_file",                          #FUN-A50102 mark
                     "   FROM ",cl_get_target_table(g_azp01,'pmn_file'),           #FUN-A50102  
                     "  WHERE pmn01='",g_apb.apb06,"' and pmn02='",g_apb.apb07,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql          #FUN-A50102
         CALL cl_parse_qry_sql(g_sql,g_azp01) RETURNING g_sql  #FUN-A50102 
         PREPARE sel_pmm_pre19 FROM g_sql
         EXECUTE sel_pmm_pre19 INTO g_apb.apb25,g_apb.apb251,g_apb.apb26,g_apb.apb35,g_apb.apb36,g_apb.apb31
      END IF      #FUN-940083 add
   END IF   #FUN-9C0041 add
   IF cl_null(g_apb.apb25) AND NOT cl_null(g_apb.apb31) THEN
     SELECT azf14,azf141 INTO g_apb.apb25,l_azf141   #FUN-B80058 add azf141
       FROM azf_file
     WHERE azf01=g_apb.apb31 AND azf02='2' AND azfacti='Y' AND azf09='7'     #No.FUN-930106
     IF g_aza.aza63='Y' AND cl_null(g_apb.apb251) THEN
       #LET g_apb.apb251 = g_apb.apb25
       LET g_apb.apb251 = l_azf141   #FUN-B80058
     END IF
   END IF
   LET g_apb.apblegal= g_legal         #FUN-980001 add
   LET g_apb.apb37 = g_azp01           #FUN-9C0140 luttb
    LET g_apb.apb09 = s_digqty(g_apb.apb09,g_apb.apb28)    #FUN-BB0084
    LET g_apb.apb15 = s_digqty(g_apb.apb15,g_apb.apb28)    #FUN-BB0084
    #TQC-C10017  --Begin
    IF cl_null(g_apb.apb25) THEN LET g_apb.apb25= ' ' END IF
    IF cl_null(g_apb.apb26) THEN LET g_apb.apb26= ' ' END IF
    IF cl_null(g_apb.apb27) THEN LET g_apb.apb27= ' ' END IF
    IF cl_null(g_apb.apb31) THEN LET g_apb.apb31= ' ' END IF
    IF cl_null(g_apb.apb35) THEN LET g_apb.apb35= ' ' END IF
    IF cl_null(g_apb.apb36) THEN LET g_apb.apb36= ' ' END IF
    IF cl_null(g_apb.apb930) THEN LET g_apb.apb930= ' ' END IF
    #TQC-C10017  --End
    INSERT INTO apb_file VALUES(g_apb.*)
    IF STATUS THEN
        LET g_showmsg=g_apb.apb01,"/",g_apb.apb02                                     
        CALL s_errmsg('apb01,apb02',g_showmsg,'p117_ins_apb(ckp#1)',SQLCA.sqlcode,1) 
       LET g_success = 'N'
    END IF
    LET g_apa.apa34f= g_apa.apa31f+ g_apa.apa32f
    LET g_apa.apa34 = g_apa.apa31 + g_apa.apa32
    LET g_apa.apa73 = g_apa.apa34 - g_apa.apa35 
    CALL p117_comp_oox(g_apa.apa01) RETURNING g_net   #MOD-AC0113 mod 
    LET g_apa.apa73=g_apa.apa34-g_apa.apa35 + g_net 
    UPDATE apa_file SET apa31f=g_apa.apa31f,
                        apa32f=g_apa.apa32f,
                        apa34f=g_apa.apa34f,
                        apa60f=g_apa.apa60f,
                        apa61f=g_apa.apa61f,
                        apa31=g_apa.apa31 ,
                        apa32=g_apa.apa32 ,
                        apa34=g_apa.apa34, 
                        apa73=g_apa.apa73,     
                        apa60=g_apa.apa60 ,
                        apa61=g_apa.apa61 ,
                        apa56=g_apa.apa56
     WHERE apa01 = g_apa.apa01
    IF STATUS THEN 
       CALL s_errmsg('apa01',g_apa.apa01,'upd apa',STATUS,1)
       LET g_success='N' 
    END IF
 
 
  # LET g_sql = "UPDATE ",l_dbs CLIPPED,"rvv_file SET rvv88 = (rvv88 + ?),", #No.FUN-9C0140      #FUN-A50102 mark
    LET g_sql = "UPDATE ",cl_get_target_table(g_azp01,'rvv_file'), " SET rvv88 = (rvv88 + ?),",  #FUN-A50102
                "                    rvv40 = 'Y'         ", 
                " WHERE rvv01 = ? AND rvv02 = ?"
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql          #FUN-A50102
    CALL cl_parse_qry_sql(g_sql,g_azp01) RETURNING g_sql  #FUN-A50102
    PREPARE p117_ins_apb_p FROM g_sql
    EXECUTE p117_ins_apb_p USING g_apb.apb09,g_apb.apb21,g_apb.apb22
    IF STATUS THEN
       CALL s_errmsg('','','p117_ins_apb(ckp#2):',STATUS,1)  #No.FUN-710014
       LET g_success = 'N'
    END IF
END FUNCTION
 
FUNCTION p117_apa15()
    DEFINE l_gec06    LIKE gec_file.gec06,
           l_gec08    LIKE gec_file.gec08,
           l_gecacti  LIKE gec_file.gecacti
 
    LET g_errno = ' '
    SELECT gec04,gec06,gec08,gecacti
      INTO g_gec04,l_gec06,l_gec08,l_gecacti
      FROM gec_file   
     WHERE gec01 = g_apa.apa15 AND gec011='1'
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg3044'
         WHEN l_gec06   !='2'     LET g_errno = 'aap-008'
         WHEN l_gec08   !='XX'    LET g_errno = 'aap-008'
         WHEN l_gecacti  ='N'     LET g_errno = '9028'
         OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-----'
    END CASE
    LET g_apa.apa16=g_gec04
    DISPLAY BY NAME g_apa.apa16
END FUNCTION
 
#CHI-A90002 add --start--
FUNCTION p117_apa05(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1
   DEFINE l_pmc05   LIKE pmc_file.pmc05
   DEFINE l_pmcacti LIKE pmc_file.pmcacti

   SELECT pmc05,pmcacti
     INTO l_pmc05,l_pmcacti
     #FROM pmc_file WHERE pmc01 = g_apa.apa05   #MOD-D60145
     FROM pmc_file WHERE pmc01=g_vendor          #MOD-D60145

   LET g_errno = ' '

   CASE
      WHEN l_pmcacti = 'N'            LET g_errno = '9028'
      WHEN l_pmcacti MATCHES '[PH]'   LET g_errno = '9038'
     
      WHEN l_pmc05   = '0'            LET g_errno = 'aap-032'        
      WHEN l_pmc05   = '3'            LET g_errno = 'aap-033' 
 
      WHEN STATUS=100 LET g_errno = '100'
      WHEN SQLCA.SQLCODE != 0
         LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE

   IF NOT cl_null(g_errno) THEN
      RETURN
   END IF

   IF p_cmd='d' THEN
      RETURN
   END IF

END FUNCTION
#CHI-A90002 add --end--

FUNCTION p117_apa36()
    DEFINE l_apr02 LIKE apr_file.apr02
    DEFINE l_aps   RECORD LIKE aps_file.*
    DEFINE l_depno     LIKE apa_file.apa22  #FUN-660117
    DEFINE l_d_actno   LIKE apt_file.apt03  #FUN-660117
    DEFINE l_c_actno   LIKE apt_file.apt04  #FUN-660117
    DEFINE l_e_actno   LIKE apa_file.apa511   #No.FUN-680029
    DEFINE l_f_actno   LIKE apa_file.apa541   #No.FUN-680029
 
    LET g_errno = ' '
    SELECT apr02 INTO l_apr02 FROM apr_file WHERE apr01 = g_apa.apa36
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-044'
         WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
    END CASE
    IF NOT cl_null(g_errno) THEN LET l_apr02 = '' END IF
    DISPLAY l_apr02 TO apr02
    IF g_apz.apz13 = 'Y'
       THEN LET l_depno = g_apa.apa22
       ELSE LET l_depno = ' '
    END IF
    SELECT * INTO l_aps.* FROM aps_file WHERE aps01 = l_depno
    IF SQLCA.sqlcode THEN 
       CALL cl_err3("sel","aps_file",l_depno,"","aap-053","","",1)  #No.FUN-660122
       RETURN 
    END IF
    SELECT apt03,apt04 INTO l_d_actno,l_c_actno FROM apt_file
           WHERE apt01 = g_apa.apa36 AND apt02 = l_depno
    IF SQLCA.sqlcode THEN
       LET l_d_actno = l_aps.aps21
       LET l_c_actno = l_aps.aps22
    END IF
    IF g_aza.aza63 = 'Y' THEN  
       SELECT apt031,apt041 INTO l_e_actno,l_f_actno FROM apt_file
        WHERE apt01 = g_apa.apa36
          AND apt02 = l_depno
       IF SQLCA.sqlcode THEN
          LET l_e_actno = l_aps.aps211
          LET l_f_actno = l_aps.aps221
       END IF
    END IF
    IF g_apy.apydmy5='Y' THEN
       LET g_apa.apa51='    '  #--有作預算控管則以單身科目為分錄科目,單頭須空白
    ELSE
       LET g_apa.apa51 = l_d_actno
       IF g_aza.aza63 = 'Y' THEN
          LET g_apa.apa511 = l_e_actno
       END IF
    END IF
    LET g_apa.apa54 = l_c_actno
    IF g_aza.aza63 = 'Y' THEN
       LET g_apa.apa541 = l_f_actno
    END IF
END FUNCTION
 
FUNCTION p117_apa21()
    DEFINE l_gen03   LIKE gen_file.gen03   
    DEFINE l_genacti LIKE gen_file.genacti
 
    SELECT gen03,genacti INTO l_gen03,l_genacti
           FROM gen_file WHERE gen01 = g_apa.apa21
    LET g_errno = ' '
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-038'
         WHEN l_genacti = 'N'     LET g_errno = '9028'
         WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
    END CASE
    IF NOT cl_null(g_errno) THEN RETURN END IF
    LET g_apa.apa22 = l_gen03
    DISPLAY BY NAME g_apa.apa22
END FUNCTION
 
FUNCTION p117_apa211()
    DEFINE l_gen03   LIKE gen_file.gen03   
    DEFINE l_genacti LIKE gen_file.genacti
 
    SELECT gen03,genacti INTO l_gen03,l_genacti
           FROM gen_file WHERE gen01 = g_apa.apa21
    LET g_errno = ' '
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-038'
         WHEN l_genacti = 'N'     LET g_errno = '9028'
         WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
    END CASE
    IF NOT cl_null(g_errno) THEN RETURN END IF
    LET g_apa.apa22 = l_gen03
    DISPLAY BY NAME g_apa.apa22
END FUNCTION
   
FUNCTION p117_apa22()
    DEFINE l_gemacti LIKE gem_file.gemacti
    DEFINE l_depno   LIKE aps_file.aps01     #FUN-CB0056

    SELECT gemacti INTO l_gemacti
           FROM gem_file WHERE gem01 = g_apa.apa22
    LET g_errno = ' '
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-039'
         WHEN l_gemacti = 'N'     LET g_errno = '9028'
         WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
    END CASE
    IF NOT cl_null(g_errno) THEN RETURN END IF
   #No.FUN-D40003 ---start--- Mark
   ##FUN-CB0056---add---str
   #IF g_apz.apz13 = 'Y' THEN
   #   LET l_depno = g_apa.apa22
   #ELSE
   #   LET l_depno =' '
   #END IF
   #LET g_apa.apa15=''
   #LET g_apa.apa16=0
   #SELECT aps02 INTO g_apa.apa15 FROM aps_file
   # WHERE aps01 = g_apa.apa22
   #IF NOT cl_null(g_apa.apa15) THEN
   #   SELECT gec04 INTO g_apa.apa16 FROM gec_file
   #    WHERE gec01= g_apa.apa15 AND gec011 = '1'
   #END IF
   #DISPLAY BY NAME g_apa.apa15,g_apa.apa16
   ##FUN-CB0056--add--end
   #No.FUN-D40003 ---end  --- Mark
END FUNCTION
 
#FUN-A50102 -----------------mark start----------------
#FUNCTION p117_upd_rvb06()
#DEFINE l_qty LIKE apb_file.apb09
# 
#
#      LET g_sql = " SELECT SUM(rvv23+rvv88) FROM ",l_dbs CLIPPED,"rvv_file",
#                  "  WHERE rvv04 = '",g_apb.apb04,"' AND rvv05 = '",g_apb.apb05,"'"
#      PREPARE sel_rvv_pre20 FROM g_sql
#      EXECUTE sel_rvv_pre20 INTO l_qty
#      IF l_qty IS NULL THEN LET l_qty = 0 END IF
#      LET g_sql = "UPDATE ",l_dbs CLIPPED,"rvb_file SET rvb06 = '",l_qty,"'",
#                  " WHERE rvb01 = '",g_apb.apb04,"' AND rvb02 = '",g_apb.apb05,"'"
#      PREPARE sel_rvb_pre21 FROM g_sql
#      EXECUTE sel_rvb_pre21
#      IF STATUS THEN 
#
#          LET g_showmsg = g_apb.apb04,"/",g_apb.apb05
#          CALL s_errmsg('rvb01,rvb02',g_showmsg,'upd rvb06',STATUS,1)
#         LET g_success='N' 
#      END IF
#END FUNCTION
#FUN-A50102 ---------------mark end-------------------
 
#CHI-A40012---mark---start---         #將此段判斷改由FOREACH p117_cs做處理
#FUNCTION p117_chkdate()
# DEFINE l_sql         STRING
# DEFINE l_yy,l_mm     LIKE type_file.num5    

# IF cl_null(g_apb.apb06) THEN
#    LET l_sql=" SELECT UNIQUE YEAR(rvv09),MONTH(rvv09) ",
#              "  FROM rvv_file,rvu_file,rva_file,rvb_file LEFT OUTER JOIN rvw_file ",
#              "                                           ON  rvb22 = rvw_file.rvw01",
#              " WHERE ",g_wc CLIPPED,
#              "   AND ( YEAR(rvv09) != YEAR('",g_apa02,"') ",
#              "    OR  (YEAR(rvv09)  = YEAR('",g_apa02,"') ",
#              "   AND   MONTH(rvv09)!= MONTH('",g_apa02,"'))) ",
#              "   AND rvv03 ='3' ",
#              "   AND rvv04 = rvb01 AND rvv05 = rvb02",
#              "   AND rvv04 = rva01  ",
#              "   AND rvaconf='Y' ",
#              "   AND rvu01 = rvv01 AND rvuconf='Y' "
# ELSE
#    LET l_sql=" SELECT UNIQUE YEAR(rvv09),MONTH(rvv09) ",
#              "   FROM rvv_file LEFT OUTER JOIN pmc_file ON rvv_file.rvv06=pmc_file.pmc01 ",
#              "                 LEFT OUTER JOIN ima_file ON rvv_file.rvv31=ima_file.ima01,",
#              "        rvu_file,rva_file,pmn_file, ",
#              "        rvb_file LEFT OUTER JOIN rvw_file ON rvb_file.rvb22 = rvw_file.rvw01,",
#              "        pmm_file LEFT OUTER JOIN gen_file ON pmm_file.pmm12 = gen_file.gen01",
#              "                 LEFT OUTER JOIN gec_file ON pmm_file.pmm21 = gec_file.gec01 AND gec011='1' ",
#              "                 LEFT OUTER JOIN azi_file ON pmm_file.pmm22 = azi_file.azi01",
#              " WHERE ",g_wc CLIPPED,
#              "   AND ( YEAR(rvv09) != YEAR('",g_apa02,"') ",
#              "    OR  (YEAR(rvv09)  = YEAR('",g_apa02,"') ",
#              "   AND   MONTH(rvv09)!= MONTH('",g_apa02,"'))) ",
#              "   AND rvv03 ='3' ",
#              "   AND (rvv87-rvv23-rvv88 > 0  OR rvv87=0) ",   #TQC-6B0151  #No.TQC-7B0083
#              "   AND rvv04 = rvb01 AND rvv05 = rvb02",
#              "   AND rvv04 = rva01  ",
#              "   AND rvv36 = pmm01",
#              "   AND (pmm25='2' OR pmm25 = '6')",
#              "   AND rvv36 = pmn01 AND rvv37 = pmn02",
#              "   AND rvaconf='Y' ",
#              "   AND rvu01 = rvv01 AND rvuconf='Y' "
#   END IF      #FUN-940083---add
#   PREPARE p117_prechk FROM l_sql
#   IF STATUS THEN CALL cl_err('Prepare chkdate: ',STATUS,1) 
#      LET l_flag='X' RETURN 
#   END IF
#   DECLARE p117_chkdate CURSOR WITH HOLD FOR p117_prechk
#   FOREACH p117_chkdate INTO l_yy,l_mm
#     IF STATUS THEN CALL cl_err('foreach chkdate: ',STATUS,1) 
#         LET l_flag='X' EXIT FOREACH
#     END IF
#     LET l_flag='Y' EXIT FOREACH
#   END FOREACH
#END FUNCTION
#CHI-A40012---mark---end---

FUNCTION p117_comp_oox(p_apv03)         #MOD-AC0113 mod 
DEFINE l_net     LIKE apv_file.apv04                                                                                                
DEFINE p_apv03   LIKE apv_file.apv03                                                                                                
DEFINE l_apa00   LIKE apa_file.apa00                                                                                                
                                                                                                                                    
    LET l_net = 0                                                                                                                   
    IF g_apz.apz27 = 'Y' THEN                                                                                                       
       SELECT SUM(oox10) INTO l_net FROM oox_file                                                                                   
        WHERE oox00 = 'AP' AND oox03 = p_apv03                                                                                      
       IF cl_null(l_net) THEN                                                                                                       
          LET l_net = 0                                                                                                             
       END IF                                                                                                                       
    END IF                                                                                                                          
    SELECT apa00 INTO l_apa00 FROM apa_file WHERE apa01=p_apv03                                                                     
    IF l_apa00 MATCHES '1*' THEN LET l_net = l_net * ( -1) END IF                                                                   
                                                                                                                                    
    RETURN l_net                                                                                                                    
END FUNCTION  
 
#判斷付款條件合法性
FUNCTION p117_ptype()
DEFINE   l_pma02   LIKE pma_file.pma02
DEFINE   l_pmaacti LIKE pma_file.pmaacti
 
     LET g_errno = NULL
 
   # LET g_sql = " SELECT pma02,pmaacti FROM ",l_dbs CLIPPED,"pma_file",                 #FUN-A50102 mark
     LET g_sql = " SELECT pma02,pmaacti FROM ",cl_get_target_table(g_azp01,'pma_file'),  #FUN-A50012 
                 "  WHERE pma01 = '",ptype,"'"
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql           #FUN-A50102
     CALL cl_parse_qry_sql(g_sql,g_azp01) RETURNING g_sql   #FUN-A50102	
     PREPARE sel_pma_pre22 FROM g_sql
     EXECUTE sel_pma_pre22 INTO l_pma02,l_pmaacti
     CASE
       WHEN SQLCA.sqlcode = 100    LET g_errno = 'aap-016'
                                   LET l_pma02 = NULL
       WHEN l_pmaacti = 'N'        LET g_errno = '9028'
       OTHERWISE    LET g_errno = SQLCA.sqlcode USING '-----'
     END CASE
 
     IF cl_null(g_errno) THEN
        DISPLAY l_pma02 TO FORMONLY.pt_name
     END IF
 
END FUNCTION
 
FUNCTION p117_ins_apc()
  DEFINE l_apa   RECORD LIKE apa_file.*
 
   IF cl_null(g_apa.apa01) THEN
      RETURN
   END IF
 
    SELECT * INTO l_apa.* FROM apa_file WHERE apa01=g_apa.apa01
    IF SQLCA.sqlcode THEN
       IF g_bgerr THEN 
          CALL s_errmsg('apa01',g_apa.apa01,'',SQLCA.sqlcode,1)
       ELSE
          CALL cl_err(g_apa.apa01,SQLCA.sqlcode,1)
       END IF
       LET g_success = 'N'
    END IF 
    LET g_apc.apc01 = l_apa.apa01
    LET g_apc.apc02 = 1
    LET g_apc.apc03 = l_apa.apa11
    LET g_apc.apc04 = l_apa.apa12
    LET g_apc.apc05 = l_apa.apa64
    LET g_apc.apc06 = l_apa.apa14
    LET g_apc.apc07 = l_apa.apa72
    LET g_apc.apc08 = l_apa.apa34f
    LET g_apc.apc09 = l_apa.apa34
    LET g_apc.apc10 = l_apa.apa35f
    LET g_apc.apc11 = l_apa.apa35
    LET g_apc.apc12 = l_apa.apa08
    LET g_apc.apc13 = l_apa.apa73
    LET g_apc.apc14 = l_apa.apa65f
    LET g_apc.apc15 = l_apa.apa65
    LET g_apc.apc16 = l_apa.apa20
    LET g_apc.apc08 = cl_digcut(g_apc.apc08,t_azi04)
    LET g_apc.apc09 = cl_digcut(g_apc.apc09,g_azi04)
    LET g_apc.apc10 = cl_digcut(g_apc.apc10,t_azi04)
    LET g_apc.apc11 = cl_digcut(g_apc.apc11,g_azi04)
    LET g_apc.apc13 = cl_digcut(g_apc.apc13,g_azi04)
    LET g_apc.apc14 = cl_digcut(g_apc.apc14,t_azi04)
    LET g_apc.apc15 = cl_digcut(g_apc.apc15,g_azi04)
    LET g_apc.apc16 = cl_digcut(g_apc.apc16,t_azi04)
    LET g_apc.apclegal= g_legal         #FUN-980001 add
    INSERT INTO apc_file VALUES(g_apc.*)
    IF STATUS THEN
       CALL s_errmsg('apc01',g_apc.apc01,'ins apc_file',SQLCA.sqlcode,1)
       LET g_success = 'N'
    END IF
END FUNCTION
 
FUNCTION p117_stock_act(p_item,p_ware,p_loc,p_npptype)                                                                              
  DEFINE p_item    LIKE ima_file.ima01                                                                                              
  DEFINE p_ware    LIKE ime_file.ime01                                                                                              
  DEFINE p_loc     LIKE ime_file.ime02                                                                                              
  DEFINE l_actno   LIKE aag_file.aag01                                                                                              
  DEFINE p_npptype LIKE npp_file.npptype                                                                                            

 #LET g_sql = " SELECT ccz07 FROM ",l_dbs CLIPPED,"ccz_file WHERE ccz00='0'"                        #FUN-A50102 mark
  LET g_sql = " SELECT ccz07 FROM ",cl_get_target_table(g_azp01,'ccz_file')," WHERE ccz00='0'"      #FUN-A50102
  CALL cl_replace_sqldb(g_sql) RETURNING g_sql            #FUN-A50102
  CALL cl_parse_qry_sql(g_sql,g_azp01) RETURNING g_sql    #FUN-A50102
  PREPARE sel_ccz_pre23 FROM g_sql
  EXECUTE sel_ccz_pre23 INTO g_ccz07
                                                                                                                                    


     CASE
        WHEN g_ccz07='1'
           IF p_npptype = '0' THEN
            # LET g_sql = " SELECT ima149 FROM ",l_dbs CLIPPED,"ima_file",                 #FUN-A50102 mark
              LET g_sql = " SELECT ima149 FROM ",cl_get_target_table(g_azp01,'ima_file'),  #FUN-A50102
                          "  WHERE ima01='",p_item,"'"
           ELSE
            # LET g_sql = " SELECT ima1491 FROM ",l_dbs CLIPPED,"ima_file",               #FUN-A50102 mark
              LET g_sql = " SELECT ima1491 FROM ",cl_get_target_table(g_azp01,'ima_file'),#FUN-A50102 
                          "  WHERE ima01='",p_item,"'" 
           END IF
        WHEN g_ccz07='2'
           IF p_npptype = '0' THEN
              LET g_sql = " SELECT imz73 ",
                        # "   FROM ",l_dbs CLIPPED,"ima_file,",l_dbs CLIPPED,"imz_file",    #FUN-A50102 mark
                          "   FROM ",cl_get_target_table(g_azp01,'ima_file'),",",           #FUN-A50102
                                     cl_get_target_table(g_azp01,'imz_file'),               #FUN-A50102            
                          "  WHERE ima01='",p_item,"' AND ima06=imz01"
           ELSE
              LET g_sql = " SELECT imz731 ",
                        # "   FROM ",l_dbs CLIPPED,"ima_file,",l_dbs CLIPPED,"imz_file",    #FUN-A50102 mark
                          "   FROM ",cl_get_target_table(g_azp01,'ima_file'),",",           #FUN-A50102
                                     cl_get_target_table(g_azp01,'imz_file'),               #FUN-A50102
                          "  WHERE ima01='",p_item,"' AND ima06=imz01"
           END IF
        WHEN g_ccz07='3'
           IF p_npptype = '0' THEN
            # LET g_sql = " SELECT imd21 FROM ",l_dbs CLIPPED,"imd_file",                 #FUN-A50102 mark
              LET g_sql = " SELECT imd21 FROM ",cl_get_target_table(g_azp01,'imd_file'),  #FUN-A50102
                          "  WHERE imd01='",p_ware,"'"
           ELSE
            # LET g_sql = " SELECT imd211 FROM ",l_dbs CLIPPED,"imd_file",                #FUN-A50102 mark
              LET g_sql = " SELECT imd211 FROM ",cl_get_target_table(g_azp01,'imd_file'), #FUN-A50102
                          "  WHERE imd01='",p_ware,"'"
           END IF
        WHEN g_ccz07='4'
           IF p_npptype = '0' THEN
            # LET g_sql = " SELECT ime13 FROM ",l_dbs CLIPPED,"ime_file",                 #FUN-A50102 mark
              LET g_sql = " SELECT ime13 FROM ",cl_get_target_table(g_azp01,'ime_file'),  #FUN-A50102
                          "  WHERE ime01='",p_ware,"' AND ime02='",p_loc,"'"
           ELSE
            # LET g_sql = " SELECT ime131 FROM ",l_dbs CLIPPED,"ime_file",                 #FUN-A50102 mark
              LET g_sql = " SELECT ime131 FROM ",cl_get_target_table(g_azp01,'ime_file'),  #FUN-A50102
                          "  WHERE ime01='",p_ware,"' AND ime02='",p_loc,"'"
           END IF
     END CASE
     RETURN l_actno                                                                                                                 
END FUNCTION                                                                                                                        
#FUN-9C0077
