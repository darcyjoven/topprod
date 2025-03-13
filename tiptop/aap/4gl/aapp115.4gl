# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aapp115.4gl
# Descriptions...: 暫沖帳款產生
# Date & Author..: 01/05/14 By plum
# Note...........: a.立暫估應為零稅率且不申報(格式='XX')
#                : b.不產生發票檔(apk_file)
# Modify.........: No.8946 03/12/17 By Kitty function p115_apa15未取到gec08
# Modify ........: No.FUN-4B0079 04/11/30 By ching 單價,金額改成 DEC(20,6)
# Modify ........: No.MOD-540080 05/04/12 By Nicola 多一選項:單價為0立帳否
# Modify.........: No.FUN-560002 05/06/03 By Will 單據編號修改
# Modify.........: No.FUN-560070 05/06/17 By Smapmin 單位數量改抓計價單位計價數量
# Modify.........: No.MOD-580258 05/08/29 By Smapmin '單價為0是否立帳'預設為'N'
# Modify.........: No.MOD-5A0267 05/10/21 By Smapmin 暫估應付應排除付款條件為 3.LC ~ 8.LLC 的部份
# Modify.........: No.MOD-590440 05/11/03 By ice 依月底重評價對AP未付金額調整,修正未付金額apa73的計算方法
# Modify.........: No.MOD-5A0434 05/11/23 By Smapmin 將變數值清空.拋轉後簽核欄位變為NULL
# Modify.........: No.TQC-5B0180 05/11/24 By Carrier SQL錯誤
# Modify.........: No.FUN-5B0089 05/12/30 By Rosayu 產生apa資料後要加判斷單別設定產生分錄底稿
# Modify.........: No.FUN-570112 06/02/23 By yiting 批次背景執行
# Modify.........: No.MOD-620079 06/03/02 By Smapmin 產生至帳款的狀況碼應DEFAULT為0
# Modify.........: No.TQC-610108 06/03/02 By Smapmin 應將入庫與退貨一併產生到aapt110的單身
# Modify.........: NO.FUN-630043 06/03/14 By Melody 多工廠帳務中心功能修改
# Modify.........: No.MOD-630123 06/03/31 By Smapmin 修正TQC-610108
# Modify.........: No.FUN-640022 06/04/08 By kim GP3.0 匯率參數功能改善
# Modify.........: No.TQC-640193 06/04/28 By Smapmin 單別抓取有誤
# Modify.........: No.FUN-660028 06/06/13 By rainy 若apa01單別為需拋轉傳票,一併將npp_file/npq_file產生
# Modify.........: No.FUN-660122 06/06/16 By Hellen cl_err --> cl_err3
# Modify.........: No.MOD-660122 06/06/29 By Smampin 要剔除pmm02=TAP,TRI
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-670064 06/07/19 By kim GP3.5 利潤中心
# Modify.........: No.FUN-680027 06/08/14 By Rayven 多帳期修改
# Modify.........: No.FUN-680029 06/08/17 By Rayven 新增多帳套功能
# Modify.........: No.FUN-650164 06/08/30 By rainy 取消 'RTN' 判斷
# Modify.........: No.FUN-680110 06/09/05 By Sarah 資料改產生至aapt160,apa00='11'改成apa00='16'處理  
# Modify.........: No.FUN-690028 06/09/12 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.CHI-6A0004 06/10/27 By Jackho 本（原）幣取位修改
# Modify.........: No.TQC-6B0066 06/12/13 By Rayven 對原幣和本幣合計按幣種進行截位
# Modify.........: No.FUN-710014 07/01/08 By dxfwo  錯誤訊息匯總顯示修改
# Modify.........: No.TQC-740080 07/04/13 By Rayven 當拋轉到aapt160的單據作廢后，可以讓它重新拋轉
# Modify.........: No.TQC-750139 07/05/23 By rainy p115_upd_apa57多做了一次拋轉分錄的動作造成每次都會出現分錄已存在，是否重新產生的訊息
# Modify.........: No.TQC-770012 07/07/02 By Rayven 拋轉的暫估單據單身單價金額取小數位有誤
# Modify.........: No.TQC-770051 07/07/11 By Rayven 參數“依部門區分缺省會計科目”未勾選,錄入"帳款類型"時仍然報錯
#                                                   稅種開窗應該只顯示零稅率不申報的稅種
# Modify.........: No.FUN-780009 07/08/06 By Smapmin 入庫單號/廠商編號加開窗功能
# Modify.........: No.TQC-790080 07/09/13 By wujie   產生資料時，發票號碼不一定要為空
# Modify.........: No.TQC-790141 07/09/26 By lumxa 輛億拸楷き婃嘛莉汜釬珛QBE爵祥剒猁恁楷き瘍鎢
# Modify.........: No.TQC-790149 07/09/26 By rainy FUN-660028產生分錄的程式碼放置的位置錯誤
# Modify.........: No.TQC-790159 07/09/28 By xufeng 如果一張入庫單已有部分暫估,剩余數量不能整批生成暫估
# Modify.........: No.TQC-790171 07/09/29 By chenl  若一筆入庫部分開發票立應付，部分立暫估，則暫估金額和數量沒有扣除已開發票的部分
# Modify.........: No.TQC-7A0032 07/10/15 By Judy 暫估資料單身的單價、金額都無小數位
# Modify.........: No.TQC-7B0078 07/11/14 By Rayven 稅種控管不嚴，未開窗出的稅種也可以過
# Modify.........: No.TQC-7B0083 07/11/19 By Carrier 控管每筆入庫單+項次最多對一張暫估 & 暫估時不考慮分期,只插入一筆apc_file
# Modify.........: No.MOD-830072 08/03/10 By Smapmin列印次數default為0
# Modify.........: No.TQC-830013 08/03/12 By xufeng 當匯總類型選擇'1'時,同一入庫單號對應有不同的采購幣種時,依照幣種的不同分開立賬
# Modify.........: No.FUN-810045 08/03/24 By rainy 項目管理，專案相關欄位代入pab_file
# Modify.........: No.FUN-840006 08/04/02 By hellen項目管理，去掉預算編號相關欄位
# Modify.........: No.MOD-840031 08/04/07 by Smapmin 已拋轉的單據不應再做其他處理
# Modify.........: No.TQC-850001 08/05/05 By Carrier TQC-840010 追單
# Modify.........: No.TQC-860021 08/06/10 By Sarah INPUT段漏了ON IDLE控制
# Modify.........: No.CHI-8A0038 08/10/30 By Sarah 單價含稅時,含稅金額=含稅單價*計價數量
#                                                             未稅金額=含稅金額/(1+稅額)/100
#                                                  單價未稅時,未稅金額=未稅單價*計價數量
#                                                             含稅金額=未稅金額*(1+稅額)/100
# Modify.........: No.TQC-8A0079 08/11/11 By Sarah 修正CHI-8A0038問題,當gec07='N'時,依照原計算邏輯算apb24
# Modify.........: No.MOD-8C0035 08/12/09 By Sarah 判斷要不要列留置前,需對apa57f,apa57做取位,否則會誤判
# Modify.........: No.MOD-8C0116 08/12/11 By sherry 在抓g_apb.apb27前,先清空變數,以免殘留前值  
# Modify.........: No.MOD-8C0146 08/12/16 By Sarah 將SQL中rvv87=0條件拿掉
# Modify.........: No.MOD-920013 09/02/02 By sherry 如果單價含稅，算未稅單價時先取位再除于稅率
# Modify.........: No.CHI-920018 09/02/05 By Sarah 若採購單身有多筆,且專案編號不同,直接彙總成一筆AP,將專案編號寫入單身,單頭專案編號給''
# Modify.........: No.MOD-910236 09/02/06 By Sarah apb25按apa51='STOCK'的邏輯重新抓取科目資料
# Modify.........: No.MOD-930039 09/03/10 By lilingyu 金額取位異常問題
# Modify.........: No.FUN-930104 09/03/23 By dxfwo   理由碼的分類改善
# Modify.........: No.MOD-940022 09/04/02 By chenl 取單號失敗則報錯處理。
# Modify.........: No.MOD-940182 09/04/14 By lilingyu 增加一個KEY
# Modify.........: No.MOD-940232 09/04/16 By chenl 單價應取入庫單而不是收貨單，切分大陸版和其他版本。
# Modify.........: No.FUN-940083 09/05/14 By shiwuying 採購改善-VMI 改用temp_table寫法
# Modify.........: No.FUN-930165 09/06/22 By jan MISC料件改抓請購單單頭的部門(pmk13)
# Modify.........: No.FUN-960141 09/06/29 By dongbg GP5.2修改:增加門店編號欄位
# Modify.........: No.FUN-960140 09/07/23 By lutingting GP5.2修改:取科目得時候增加經營方式為代銷得考慮
# Modify.........: No.FUN-980001 09/08/12 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-980281 09/09/03 By sabrina 在FOREACH做判斷，若料件非misc則判斷該料件是否存在料件主檔
# Modify.........: No.FUN-990069 09/09/27 By baofei 修改GP5.2的相關設定
# Modify.........: No:MOD-990168 09/10/21 By mike 调整抓取 apyapr 方式     
# Modify.........: No.FUN-990031 09/10/26 By lutingtingGP5.2財務營運中心欄位調整,營運中心要控制在同一法人下,条件选项来源营运中心隐藏
# Modify.........: No.FUN-9A0093 09/11/02 By lutingting拋轉apb時給欄位apb37賦值
# Modify.........: No.FUN-9C0041 09/12/10 By lutingting應付賬款可以按照經營方式匯總
# Modify.........: No.MOD-9C0334 09/12/21 By sabrina 拋轉資料後有出現錯誤訊息，但資料卻有拋入aapt160 
# Modify.........: No.FUN-A10011 09/12/28 By lutingting QBE門店編號改為來源營運中心,實現可由當前法人下DB得入庫單產生暫估賬款
# Modify.........: No.FUN-9C0077 10/01/18 By baofei 程序精簡
# Modify.........: No.FUN-A20006 10/02/02 By lutingting 修改p115_upd_apa57()寫法
# Modify.........: No.TQC-A30098 10/03/19 By wujie  sql少了一个括号 
# Modify.........: No:CHI-A40012 10/04/07 By sabrina 每筆資料年月之檢核由FUNCTION p115_chkdate()改由FOREACH p115_cs裡判斷
#                                                    且將不符合的單據顯示出來
# Modify.........: No.FUN-A40041 10/04/20 By wujie     g_sys->AAP
# Modify.........: No:FUN-A40003 10/05/21 By wujie   增加apa79，预设为N
# Modify.........: No:MOD-A50151 10/05/24 By sabrina 當入庫單金額為0且單別設定不拋轉傳票時，差異(apa56)應該要給0
# Modify.........: No:FUN-A60024 10/06/12 By wujie   调整apa79的值为0 
# Modify.........: No:MOD-A60155 10/06/23 By Dido 若畫面已有定義 apa21/apa22 則以畫面的為主;否則才用採購人員與其所屬的部門 
# Modify.........: No.FUN-A60056 10/06/24 By lutingting GP5.2財務串前段問題整批調整
# Modify.........: No.FUN-A50102 10/07/21 By vealxu 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A70139 10/07/29 By lutingting 過單
# Modify.........: No.FUN-A80026 10/08/26 By Carrier 入库单直接产生AP-加入传参g_wc2
# Modify.........: No:MOD-AA0021 10/10/06 By Dido 單價改用原 rvv38/rvv38t 計算
# Modify.........: No:CHI-A90002 10/10/06 By Summer 應過濾pmcacti='Y'才能立帳
# Modify.........: No:CHI-AB0011 10/11/19 By Summer QBE增加採購人員(pmm12) 
# Modify.........: No:TQC-AC0287 10/12/18 By aapp115在接收參數ARG_VAL時解析錯誤,而無法產生帳款
# Modify.........: No.TQC-AC0288 10/12/22 By chenmoyan 過單CHI-AB0011
# Modify.........: No:TQC-B20093 11/02/17 By Nicola 組sql時，應判斷AND rvv89 <> 'Y'非rvu117 is null
# Modify.........: No:MOD-B20088 11/02/18 By Dido apa37/apa37f 預設為 0 
# Modify.........: No:MOD-B30064 11/03/08 By Dido 取位變數使用有誤 
# Modify.........: No:FUN-B30211 11/03/30 By yangtingting 未加離開前的 cl_used(2)
# Modify.........: No:FUN-B50019 11/05/04 By elva 支持无采购无收货单的入库单产生应付
# Modify.........: No:FUN-B50016 11/05/05 By guoch 采购单号开查询窗体
# Modify.........: No:MOD-B50062 11/05/09 By Dido 檢核rva00='1'抓取 pmm20,rva00='2'抓取rvu111
# Modify.........: No.FUN-B80058 11/08/05 By lixia 兩套帳內容修改，新增azf141
# Modify.........: No:MOD-B80123 11/08/11 By yinhy 取位變數更改
# Modify.........: No:MOD-B90229 11/09/29 By Dido 背景作業預設科目有誤
# Modify.........: No:TQC-BA0175 11/10/28 By yinhy 增加檢核，帳款日不可小於入庫日
# Modify.........: No:MOD-BB0172 11/11/15 By yinhy 稅率抓取方式更改
# Modify.........: No:FUN-BB0084 11/12/27 By lixh1 增加數量欄位小數取位
# Modify.........: No.TQC-C10017 12/02/10 By yinhy 調整apb25，apb26，apb27，apb36，apb31，apb930欄位的值
# Modify.........: No.MOD-C50092 12/05/14 By yinhy JIT收貨產生的入庫單做暫估時，單據產生失敗
# Modify.........: No.MOD-C50181 12/05/28 By Polly 文字型態不可累加
# Modify.........: No.FUN-C70052 12/07/12 By xuxz 區分採購性質立帳選項
# Modify.........: No.FUN-C80022 12/08/07 By xuxz mod  FUN-C70052 添加採購性質下拉框
# Modify.........: No.MOD-C80158 12/08/30 By Elise sql 排除rvv22不為null
# Modify.........: No.MOD-CA0127 12/11/07 By Elise 還原抓取 pmm20/21/22
# Modify.........: No.MOD-D10264 13/02/01 By yinhy 大陸版本去掉依廠商匯總時去掉付款方式限制
# Modify.........: No.FUN-CB0056 13/03/04 By minpp 画面税种给默认值aps02
# Modify.........: No.MOD-D30222 13/03/27 By Alberti 修改PREPARE p115_tmp_prep之條件
# Modify.........: No.MOD-D40068 13/04/11 By Lori rvb_File改rvb_file
# Modify.........: No.MOD-D40099 13/04/17 By Lori 新增外部參數傳purchas_sw值
# Modify.........: No.FUN-D40003 13/04/01 By yinhy 自動帶出稅種
# Modify.........: No.MOD-D60145 13/06/18 By yinhy 判斷若是留置廠商不可更新金額
# Modify.........: No.FUN-D60083 13/08/26 By yangtt 调用p115_stock_act(的地方增加判断，若该入库单+项次的仓库rvv32若存在于axci500,即为非成本仓，则科目取ima164;
#                                                   使用多帐套则加取ima1641.否则依原来的逻辑根据ccz07取值不变
# Modify.........: No.FUN-D70021 13/08/26 By yangtt 畫面檔增加選項MISC料件是否立帳，如果為否的話，不立暫估
# Modify.........: No.MOD-DB0042 13/11/06 By SunLM  調整单价为零金额有值的暂估单的問題
# Modify.........: No.yinhy131205  13/12/05 By yinhy 改用計價單位

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE g_rvv01         LIKE rvv_file.rvv01,       #入庫單
       t_rvv01         LIKE rvv_file.rvv01,       #入庫單舊值
       g_vendor        LIKE rvv_file.rvv06,       #供應廠商
       t_vendor        LIKE rvv_file.rvv06,       #供應廠商舊值
       g_vendor2       LIKE pmc_file.pmc04,       #付款廠商pmc04
       g_abbr          LIKE pmc_file.pmc03,       #地址
       g_rvv09         LIKE rvv_file.rvv09,
       trtype          LIKE apy_file.apyslip,
       purchas_sw      LIKE type_file.chr1,   #No.FUN-C70052 VARCHAR(1),
       begin_no,end_no LIKE apa_file.apa01,
       g_amt1,g_amt2   LIKE type_file.num20_6,
       f_amt1,f_amt2   LIKE type_file.num20_6,
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
       t_pmn122        LIKE pmn_file.pmn122,
       g_pmn122        LIKE pmn_file.pmn122,
       g_pmm13         LIKE pmm_file.pmm13,
       g_pmm12         LIKE pmm_file.pmm12,
       g_pmn40         LIKE pmn_file.pmn40,       #96/07/18 modify
       g_pmn401        LIKE pmn_file.pmn401,      #No.FUN-680029
       g_rvv25         LIKE rvv_file.rvv25,
       g_pmc54         LIKE pmc_file.pmc54,
       g_rva04         LIKE rva_file.rva04,
       g_rvu10         LIKE rvu_file.rvu10,
       g_apa           RECORD LIKE apa_file.*,
       g_apb           RECORD LIKE apb_file.*,
       g_apc           RECORD LIKE apc_file.*,    #No.FUN-680027
       g_pmb           RECORD LIKE pmb_file.*,    #No.FUN-680027
       g_temp          LIKE apa_file.apa24,       #No.FUN-680027 
       g_azi           RECORD LIKE azi_file.*,
       t_azi           RECORD LIKE azi_file.*,
       enter_account   LIKE type_file.chr1,   #No.FUN-690028 VARCHAR(1)
       summary_sw      LIKE type_file.chr1,   #No.FUN-690028 VARCHAR(1)
       l_flag          LIKE type_file.chr1,   #No.FUN-690028 VARCHAR(1)
       g_n             LIKE type_file.num10,  #No.FUN-690028 INTEGER,
       l_cnt           LIKE type_file.num5,   #No.FUN-690028 SMALLINT
       g_wc,g_sql      string,  #No.FUN-580092 HCN
       g_change_lang   LIKE type_file.chr1                 #是否有做語言切換 No.FUN-570112  #No.FUN-690028 VARCHAR(1)
DEFINE g_wc3           STRING  #CHI-AB0011 add
DEFINE g_net           LIKE apv_file.apv04    #MOD-590440
DEFINE g_cnt           LIKE type_file.num10   #CHI-920018 add
DEFINE g_i             LIKE type_file.num5    #count/index for any purpose  #No.FUN-690028 SMALLINT
DEFINE source          LIKE apb_file.apb03    #No.FUN-690028 VARCHAR(10)     #FUN-630043
DEFINE g_rvv930        LIKE rvv_file.rvv930   #FUN-670064
DEFINE g_rvuplant      LIKE rvu_file.rvuplant #FUN-960141
DEFINE t_rvuplant      LIKE rvu_file.rvuplant #FUN-960141
DEFINE g_rty06         LIKE rty_file.rty06    #FUN-960140
DEFINE t_rty06         LIKE rty_file.rty06    #FUN-960140
DEFINE g_ccz07         LIKE ccz_file.ccz07    #FUN-960140
DEFINE g_rvu21         LIKE rvu_file.rvu21    #FUN-9C0041
DEFINE t_rvu21         LIKE rvu_file.rvu21    #FUN-9C0041
DEFINE g_apb24t        LIKE apb_file.apb24    #CHI-8A0038 add   #含稅金額
DEFINE g_flag          LIKE type_file.chr1    #MOD-910236 add
DEFINE g_bookno1       LIKE aza_file.aza81    #MOD-910236 add
DEFINE g_bookno2       LIKE aza_file.aza82    #MOD-910236 add
DEFINE g_wc2           STRING                 #FUN-A10011
DEFINE l_dbs           LIKE type_file.chr21   #FUN-A10011
DEFINE l_azp01         LIKE azp_file.azp01    #FUN-A10011
DEFINE t_azp01         LIKE azp_file.azp01    #FUN-A10011
DEFINE t_azp03         LIKE azp_file.azp03    #FUN-A10011
DEFINE g_a             LIKE type_file.chr1    #FUN-D70021 #MISC料件是否立帳
DEFINE g_b             LIKE type_file.chr1    #FUN-D60083 #非成本倉是否立賬

MAIN
   DEFINE ls_date       STRING    #->No.FUN-570112
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc           = ARG_VAL(1)       #QBE條件
   LET trtype         = ARG_VAL(2)       #帳款單別
   LET ls_date        = ARG_VAL(3)
   LET g_apa.apa02    = cl_batch_bg_date_convert(ls_date)   #帳款日期
   LET g_apa.apa21    = ARG_VAL(4)       #帳款人員
   LET g_apa.apa22    = ARG_VAL(5)       #帳款部門
   LET g_apa.apa36    = ARG_VAL(6)       #帳款類別
   LET g_apa.apa15    = ARG_VAL(7)       #帳款稅別
   LET enter_account  = ARG_VAL(8)       #單價為0立帳否
   LET summary_sw     = ARG_VAL(9)       #匯總方式
   LET g_bgjob        = ARG_VAL(10)      #背景作業
   #No.FUN-A80026  --Begin
   LET g_wc2          = ARG_VAL(11)      #营运中心CONSTRUCT值
   #No.FUN-A80026  --End  
   LET g_wc3          = ARG_VAL(12)      #CHI-AB0011 add
   LET purchas_sw     = ARG_VAL(13)      #MOD-D40099
   LET g_wc= cl_replace_str(g_wc,"\\\"","'")   #TQC-AC0287
   LET g_wc2= cl_replace_str(g_wc2,"\\\"","'") #TQC-AC0287
   LET g_wc3= cl_replace_str(g_wc3,"\\\"","'") #TQC-AC0287
   LET g_a=ARG_VAL(14) #FUN-D70021 #MISC料件是否立帳
   LET g_b=ARG_VAL(15) #FUN-D60083 #非成本倉是否立賬

   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055

   CALL p115_create_temp_table()  #No.FUN-940083 add
 
   WHILE TRUE
      #No.FUN-A80026  --Begin
      #IF g_bgjob = "N" THEN
      IF g_bgjob = "N" OR cl_null(g_wc) THEN
      #No.FUN-A80026  --End  
         CALL p115()
         IF cl_sure(18,20) THEN
            LET g_success = 'Y'
            BEGIN WORK
            CALL p115_process()
            CALL s_showmsg()             # No.FUN-710014  add 
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
               CLOSE WINDOW p115_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         #No.FUN-A80026  --Begin
         IF cl_null(g_wc2) THEN
            LET g_wc2 = " azp01 = '",g_plant,"'"
         END IF
         #No.FUN-A80026  --End  
         LET g_success = 'Y'
         BEGIN WORK
         CALL p115_process()
         CALL s_showmsg()             # No.FUN-710014  add 
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE


   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
END MAIN
 
FUNCTION p115()
   DEFINE li_result LIKE type_file.num5      #No.FUN-560002   #No.FUN-690028 SMALLINT
   DEFINE lc_cmd    LIKE type_file.chr1000   #NoFUN-690028 VARCHAR(500)           #No.FUN-570112
   DEFINE l_azp02   LIKE azp_file.azp02  #FUN-630043
   DEFINE l_azp03   LIKE azp_file.azp03  #FUN-630043
   DEFINE l_depno   LIKE aps_file.aps01  #FUN-CB0056
   DEFINE l_rvu06   LIKE rvu_file.rvu06  #FUN-D40003
   DEFINE l_azp01   LIKE azp_file.azp01  #FUN-D40003
 
   WHILE TRUE
      LET g_action_choice = ""
 
   OPEN WINDOW p115_w WITH FORM "aap/42f/aapp115"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
  #LET g_pmm02_t = '' #FUN-C70052 add   #FUN-C80022 mark
   CALL cl_set_comp_visible("group05", FALSE)   #FUN-990031   #FUN-A10011 mark

      CLEAR FORM
 
 
      CONSTRUCT BY NAME g_wc2 ON azp01

         ON ACTION locale
            LET g_change_lang = TRUE
            DISPLAY g_plant TO azp01   #MOD-D10264
            EXIT CONSTRUCT

         BEFORE CONSTRUCT
             CALL cl_qbe_init()
             DISPLAY g_plant TO azp01      #TQC-D50012 add

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

         ON ACTION CONTROLP
            CASE
              WHEN INFIELD(azp01)   #來源營運中心
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azw"
                   LET g_qryparam.where = "azw02 = '",g_legal,"' "
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO azp01
                   NEXT FIELD azp01
            END CASE
      END CONSTRUCT

      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         EXIT WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p115_w
         CALL  cl_used(g_prog,g_time,2) RETURNING g_time        #FUN-B30211
         EXIT PROGRAM
      END IF

      CONSTRUCT BY NAME g_wc ON rvv01,rvv09,rvv06,rvv36           #FUN-A10011
      
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
         ON ACTION CONTROLP
            CASE 
               WHEN INFIELD(rvv01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_rvv7"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rvv01
                  NEXT FIELD rvv01
               WHEN INFIELD(rvv06)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_pmc2"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rvv06
                  NEXT FIELD rvv06
#FUN-B50016--Begin
              WHEN INFIELD(rvv36)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_rvv32"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rvv36
                  NEXT FIELD rvv36
#FUN-B50016--End
 
            END CASE
 
         ON ACTION locale
            LET g_change_lang = TRUE       #->No.FUN-570112
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
      CONSTRUCT BY NAME g_wc3 ON pmm12 

        ON ACTION locale
           LET g_change_lang = TRUE
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
      

      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         EXIT WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p115_w
         CALL  cl_used(g_prog,g_time,2) RETURNING g_time        #FUN-B30211
         EXIT PROGRAM
      END IF
 
 
 
 
      INITIALIZE g_apa.* TO NULL
      INITIALIZE g_apb.* TO NULL
      LET g_apa.apa02 = g_today
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
      LET enter_account = 'N'   #MOD-580258
      LET g_a='N' #FUN-D70021
      LET g_b='N' #FUN-D60083
      LET summary_sw = '1'
     LET t_vendor =NULL
     LET purchas_sw = '1'  #FUN-C70052 add#FUN-C80022 mod N-->1    #
     LET t_rvv01 =NULL
     LET t_apb06 =NULL
     LET t_pmm20 =NULL
     LET t_pmm22 =NULL
     LET t_pmn122 =NULL
     LET begin_no =NULL
     LET t_rty06 = NULL    #FUN-960140
     LET t_rvu21 = NULL    #FUN-9C0041
     LET g_bgjob = "N"   #No.FUN-570112
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
        CALL p115_apa15()
     END IF
     #No.FUN-D40003  --End
     CALL s_get_bookno(YEAR(g_apa.apa02)) RETURNING g_flag,g_bookno1,g_bookno2
     IF g_flag = '1' THEN
        CALL cl_err(g_apa.apa02,'aoo-081',1)
     END IF
      
      INPUT BY NAME trtype,g_apa.apa02,g_apa.apa21, g_apa.apa22,
                     g_apa.apa36,g_apa.apa15,
                    g_a,  #FUN-D70021 #MISC料件是否立帳
                    enter_account,   #No.MOD-540080
                    g_b,  #FUN-D60083 #非成本倉是否立賬
                    #summary_sw WITHOUT DEFAULTS 
                    purchas_sw,     #FUN-C70052 add
                    summary_sw,g_bgjob WITHOUT DEFAULTS   #NO.FUN-570112 
      
         AFTER FIELD trtype
            IF cl_null(trtype) THEN 
               LET summary_sw='1' 
            ELSE
#              CALL s_check_no(g_sys,trtype,"","16","","","")   #FUN-680110
               CALL s_check_no("aap",trtype,"","16","","","")   #FUN-680110   #No.FUN-A40041
                    RETURNING li_result,trtype
               IF (NOT li_result) THEN
    	          NEXT FIELD trtype
               END IF

               LET g_apa.apamksg = g_apy.apyapr
            END IF
      
         AFTER FIELD apa21         #96/07/17 modify 可空白
            IF NOT cl_null(g_apa.apa21) THEN 
               CALL p115_apa21()
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
               CALL p115_apa22()
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
               CALL p115_apa36()
               IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_apa.apa36,g_errno,0)
                  NEXT FIELD apa36
               END IF
            END IF
      
         AFTER FIELD apa15
            IF NOT cl_null(g_apa.apa15) THEN 
               CALL p115_apa15()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_apa.apa15,g_errno,0)
                  NEXT FIELD apa15
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
                  CALL q_apy(0,0,trtype,'16','AAP') RETURNING trtype  #TQC-670008   #FUN-680110
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
            END CASE
      
         ON ACTION locale
            LET g_change_lang = TRUE      #->No.FUN-570112
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
      

      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p115_w
         CALL  cl_used(g_prog,g_time,2) RETURNING g_time        #FUN-B30211
         EXIT PROGRAM
      END IF
      IF g_bgjob = "Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "aapp115"
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('aapp115','9031',1)
         ELSE
            LET g_wc=cl_replace_str(g_wc, "'", "\"")
            LET g_wc3=cl_replace_str(g_wc3, "'", "\"") #CHI-AB0011 add
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",g_wc CLIPPED,"'",
                         " '",trtype CLIPPED,"'",
                         " '",g_apa.apa02 CLIPPED,"'",
                         " '",g_apa.apa21 CLIPPED,"'",
                         " '",g_apa.apa22 CLIPPED,"'",
                         " '",g_apa.apa36 CLIPPED,"'",
                         " '",g_apa.apa15 CLIPPED,"'",
                         " '",enter_account CLIPPED,"'",
                         " '",summary_sw CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_wc2   CLIPPED,"'",     #No.FUN-A80026 #CHI-AB0011 add ,
                         " '",g_wc3 CLIPPED,"'"        #CHI-AB0011 add
                        ," '",purchas_sw CLIPPED,"'"   #MOD-D40099 add
                        ," '",g_a CLIPPED,"'"          #FUN-D70021 #MISC料件是否立帳
                        ," '",g_b CLIPPED,"'"          #FUN-D60083 #非成本倉是否立賬
            CALL cl_cmdat('aapp115',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p115_w
         CALL  cl_used(g_prog,g_time,2) RETURNING g_time        #FUN-B30211
         EXIT PROGRAM
      END IF
      EXIT WHILE
END WHILE
END FUNCTION
 
FUNCTION p115_create_temp_table()
 
   DROP TABLE aapp115_temp
   CREATE TEMP TABLE aapp115_temp(
      rvv06 LIKE rvv_file.rvv06,
      rvv01t LIKE rvv_file.rvv01,
      rvv09 LIKE rvv_file.rvv09,
      pmc04 LIKE pmc_file.pmc04,
      pmc24 LIKE pmc_file.pmc24,
      rvv01 LIKE rvv_file.rvv01,
      rvv02 LIKE rvv_file.rvv02,
      rvv03 LIKE rvv_file.rvv03,
      rvv04 LIKE rvv_file.rvv04,
      rvv05 LIKE rvv_file.rvv05,
      rvv36 LIKE rvv_file.rvv36,
      rvv37 LIKE rvv_file.rvv37,
      pmm22 LIKE pmm_file.pmm22,
      rvv38 LIKE rvv_file.rvv38,
      apb09 LIKE apb_file.apb09,
      apb24 LIKE apb_file.apb24,
      apb24t LIKE apb_file.apb24,
      rvv31 LIKE rvv_file.rvv31,
      rva06 LIKE rva_file.rva06,
      pmm20 LIKE pmm_file.pmm20,
      pmm21 LIKE pmm_file.pmm21,
      pmm44 LIKE pmm_file.pmm44,
      pmm02 LIKE pmm_file.pmm02,
      pmn122 LIKE pmn_file.pmn122,
      gec03 LIKE gec_file.gec03,
      gec04 LIKE gec_file.gec04,
      azi03 LIKE azi_file.azi03,
      azi04 LIKE azi_file.azi04,
      pmc54 LIKE pmc_file.pmc54,
      rvv25 LIKE rvv_file.rvv25,
      rva04 LIKE rva_file.rva04,
      rvu10 LIKE rvu_file.rvu10,
      rvv930 LIKE rvv_file.rvv930,
      rvu21  LIKE rvu_file.rvu21,        #FUN-9C0041
      rvv87 LIKE rvv_file.rvv87);
 
END FUNCTION
 
FUNCTION p115_process()
   DEFINE l_cnt     LIKE type_file.num5     #TQC-610108  #No.FUN-690028 SMALLINT
   DEFINE l_t1      LIKE apy_file.apyslip #No.FUN-690028  VARCHAR(5)             #No.FUN-660028
   DEFINE l_apydmy3   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)             #No.FUN-660028
   DEFINE l_n         LIKE type_file.num5              #No.FUN-680027  #No.FUN-690028 SMALLINT
   DEFINE l_apc13     LIKE apc_file.apc13 #No.FUN-680027
   DEFINE g_rvv87     LIKE rvv_file.rvv87 #No.TQC-790159
   DEFINE g_apb09     LIKE apb_file.apb09 #No.TQC-790159
   DEFINE l_pmm12   LIKE pmm_file.pmm12
   DEFINE l_rva00   LIKE rva_file.rva00   #MOD-B50062
   DEFINE l_rva10   LIKE rva_file.rva10
   DEFINE l_temp    RECORD
           rvv06    LIKE rvv_file.rvv06,
           rvv01t   LIKE rvv_file.rvv01,
           rvv09    LIKE rvv_file.rvv09,
           pmc04    LIKE pmc_file.pmc04,
           pmc24    LIKE pmc_file.pmc24,
           rvv01    LIKE rvv_file.rvv01,
           rvv02    LIKE rvv_file.rvv02,
           rvv03    LIKE rvv_file.rvv03,
           rvv04    LIKE rvv_file.rvv04,
           rvv05    LIKE rvv_file.rvv05,
           rvv36    LIKE rvv_file.rvv36,
           rvv37    LIKE rvv_file.rvv37,
           pmm22    LIKE pmm_file.pmm22,
           rvv38    LIKE rvv_file.rvv38,
           apb09    LIKE apb_file.apb09,
           apb24    LIKE apb_file.apb24,
           apb24t   LIKE apb_file.apb24,
           rvv31    LIKE rvv_file.rvv31,
           rva06    LIKE rva_file.rva06,
           pmm20    LIKE pmm_file.pmm20,
           pmm21    LIKE pmm_file.pmm21,
           pmm44    LIKE pmm_file.pmm44,
           pmm02    LIKE pmm_file.pmm02,
          #gen03    LIKE gen_file.gen03,     #MOD-A60155 mark
           pmn122   LIKE pmn_file.pmn122,
           gec03    LIKE gec_file.gec03,
           gec04    LIKE gec_file.gec04,
           azi03    LIKE azi_file.azi03,
           azi04    LIKE azi_file.azi04,
           pmc54    LIKE pmc_file.pmc54,
           rvv25    LIKE rvv_file.rvv25,
           rva04    LIKE rva_file.rva04,
           rvu10    LIKE rvu_file.rvu10,
           rvv930   LIKE rvv_file.rvv930,
           rvu21    LIKE rvu_file.rvu21,       #FUN-9C0041
           rvv87    LIKE rvv_file.rvv87 
        END RECORD
   DEFINE l_rvv31     LIKE rvv_file.rvv31      #FUN-960140 add
   DEFINE l_rvvplant  LIKE rvv_file.rvvplant   #FUN-960140 add
   DEFINE t_ima01     SMALLINT            #MOD-980281 add
   DEFINE l_apa100_t  LIKE apa_file.apa100 #FUN-A10011
   DEFINE l_apa01_t   LIKE apa_file.apa01  #FUN-A10011
 
   LET g_apa02 = g_apa.apa02
   LET g_apa21 = g_apa.apa21
   LET g_apa22 = g_apa.apa22
   LET g_apa36 = g_apa.apa36
   LET g_apa15 = g_apa.apa15
 
   LET g_sql = "SELECT azp01 FROM azp_file,azw_file ",
               " WHERE ",g_wc2 CLIPPED ,
               "   AND azw01 = azp01 AND azw02 = '",g_legal,"' ",
               " ORDER BY azp01 "
   PREPARE sel_azp03_pre FROM g_sql
   DECLARE sel_azp03_cs CURSOR FOR sel_azp03_pre
   LET t_azp01 = NULL
   LET t_azp03 = NULL
   LET t_rvv01 =' '
   LET t_apb06 =' '
   LET g_apa.apa01 = NULL
   LET t_pmn122=' '
   LET t_rvu21 = ' '
   FOREACH sel_azp03_cs INTO l_azp01
      IF STATUS THEN
         CALL cl_err('p115(ckp#1):',SQLCA.sqlcode,1)
         RETURN
      END IF
      LET g_plant_new = l_azp01
      CALL s_gettrandbs()
      LET l_dbs = g_dbs_tra

   #check帳款日和異動日不可有不同年月的情形發生
   IF NOT cl_null(g_apa02) THEN
      LET l_flag='N'
     #CALL p115_chkdate()      #CHI-A40012 mark
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
   DELETE FROM aapp115_temp

   IF g_aza.aza26 ='2' THEN 

      LET g_sql = "SELECT rvv06,'',rvv09,'','',rvv01,rvv02,rvv03,rvv04,rvv05,",
                 #"       rvv36,rvv37,'',rvv38,rvv87-rvv23-rvv88,(rvv87-rvv23-rvv88)*rvv38,", #FUN-B50019
                  "       rvv36,rvv37,rvu113,rvv38,rvv87-rvv23-rvv88,(rvv87-rvv23-rvv88)*rvv38,", #FUN-B50019
                  "       (rvv87-rvv23-rvv88)*rvv38t,",
                 #"       rvv31,rva06,'','','','','','',",                                     #MOD-A60155 mark
                 #"       rvv31,rva06,'','','','','',",                                        #MOD-A60155  #FUN-B50019
                  "       rvv31,rva06,rvu111,rvu115,'','','',",                                        #MOD-A60155  #FUN-B50019
                  "       '','','','','',rvv25,rva04,rvu10,rvv930,rvu21,rvv87",   #FUN-960141 add rvuplant   #FUN-960140 add rty06   #FUN-9C0041 rty06-->rvu21    #FUN-A10011 del rvuplant  
                 #"  FROM ",l_dbs CLIPPED,"rvv_file LEFT OUTER JOIN ",l_dbs CLIPPED,"ima_file ON rvv_file.rvv31 = ima_file.ima01 ",   #FUN-A10011 add             #FUN-A50102 mark
                 #"                                 LEFT OUTER JOIN ",l_dbs CLIPPED,"pmc_file ON rvv_file.rvv06 = pmc_file.pmc01,",   #FUN-A10011 add             #FUN-A50102
                 #  l_dbs CLIPPED,"rvu_file,",l_dbs CLIPPED,"rva_file,",l_dbs CLIPPED,"rvb_file ",   #FUN-A10011                      #FUN-A50012        
                 #FUN-B50019 --begin
                 #"  FROM ",cl_get_target_table(l_azp01,'rvv_file'),                                                  #FUN-A50102
                 #" LEFT OUTER JOIN ",cl_get_target_table(l_azp01,'ima_file')," ON rvv_file.rvv31 = ima_file.ima01 ", #FUN-A50102
                 #" LEFT OUTER JOIN ",cl_get_target_table(l_azp01,'pmc_file')," ON rvv_file.rvv06 = pmc_file.pmc01,", #FUN-A50102
                 #  cl_get_target_table(l_azp01,'rvu_file'),",",cl_get_target_table(l_azp01,'rva_file'),",",          #FUN-A50102
                 #  cl_get_target_table(l_azp01,'rvb_file'),                                                          #FUN-A50102  
                  "  FROM ",cl_get_target_table(l_azp01,'rvu_file'),",",cl_get_target_table(l_azp01,'rvv_file'),                                                  #FUN-A50102
                  " LEFT OUTER JOIN ",cl_get_target_table(l_azp01,'ima_file')," ON rvv_file.rvv31 = ima_file.ima01 ", #FUN-A50102
                  " LEFT OUTER JOIN ",cl_get_target_table(l_azp01,'pmc_file')," ON rvv_file.rvv06 = pmc_file.pmc01 ", #FUN-A50102
                  " LEFT OUTER JOIN ",cl_get_target_table(l_azp01,'rva_file')," ON rvv_file.rvv04 = rva_file.rva01 ",
                  " LEFT OUTER JOIN ",cl_get_target_table(l_azp01,'rvb_file')," ON rvv_file.rvv04 = rvb_file.rvb01 AND rvv_file.rvv05=rvb_file.rvb02 AND rva_file.rvaconf='Y' ",    #MOD-D40068 rvb_File->rvb_file
                  # cl_get_target_table(l_azp01,'rvu_file'),",",cl_get_target_table(l_azp01,'rva_file'),",",          #FUN-A50102
                  # cl_get_target_table(l_azp01,'rvb_file'),                                                          #FUN-A50102  
                 #FUN-B50019 --end
                  " WHERE ",g_wc CLIPPED,
                  "   AND rvvplant = '",l_azp01,"' ",    #FUN-A10011
                  "   AND rvv03 ='1' ",
                  "   AND rvv87-rvv23-rvv88 > 0 ",
                 #"   AND rvv04 = rvb01 AND rvv05 = rvb02", #FUN-B50019
                 #"   AND rvv04 = rva01 AND rvaconf='Y' ", #FUN-B50019
                  "   AND rvu01 = rvv01 AND rvuconf='Y' ",
                # "   AND rvu117 IS NULL"    #FUN-960140 
                 #"   AND rvv22 IS NULL",    #MOD-C80158 add  #MOD-D30222 mark
                  "   AND (rvv22 = ' ' OR rvv22 IS NULL) ",   #MOD-D30222
                  "   AND rvv89 <> 'Y'"   #No:TQC-B20093 
   ELSE

     LET g_sql = "SELECT rvv06,'',rvv09,'','',rvv01,rvv02,rvv03,rvv04,rvv05,",
                 #"       rvv36,rvv37,'',rvv38,rvv87-rvv23-rvv88,(rvv87-rvv23-rvv88)*rvb10,",   #MOD-AA0021 mark
                 #"       rvv36,rvv37,'',rvv38,rvv87-rvv23-rvv88,(rvv87-rvv23-rvv88)*rvv38,",   #MOD-AA0021 #FUN-B50019
                  "       rvv36,rvv37,rvu113,rvv38,rvv87-rvv23-rvv88,(rvv87-rvv23-rvv88)*rvv38,",   #MOD-AA0021 #FUN-B50019
                 #"       (rvv87-rvv23-rvv88)*rvb10t,",   #MOD-AA0021 mark
                  "       (rvv87-rvv23-rvv88)*rvv38t,",   #MOD-AA0021
                 #"       rvv31,rva06,'','','','','','',",                                     #MOD-A60155 mark
                 #"       rvv31,rva06,'','','','','',",                                        #MOD-A60155 #FUN-B50019
                  "       rvv31,rva06,rvu111,rvu115,'','','',",                                        #MOD-A60155 #FUN-B50019
                  "       '','','','','',rvv25,rva04,rvu10,rvv930,rvu21,rvv87",     #FUN-960141 add rvuplant #FUN-960140 add rty06   #FUN-9C0041 rty06-->rvu21   #FUN-A10011 del rvuplant  
                 #" FROM ",l_dbs CLIPPED,"rvv_file LEFT OUTER JOIN ",l_dbs CLIPPED,"ima_file ON rvv_file.rvv31 = ima_file.ima01 ",   #FUN-A10011                 #FUN-A50102 mark
                 #"                                LEFT OUTER JOIN ",l_dbs CLIPPED,"pmc_file ON rvv_file.rvv06 = pmc_file.pmc01 ,",  #FUN-A10011                 #FUN-A50102 mark
                 #  l_dbs CLIPPED,"rvu_file,",l_dbs CLIPPED,"rva_file,",l_dbs CLIPPED,"rvb_file ",   #FUN-A10011                     #FUN-A50102 mark
                 #FUN-B50019 --begin
                  " FROM ",cl_get_target_table(l_azp01,'rvu_file'),",",cl_get_target_table(l_azp01,'rvv_file'),                                                   #FUN-A50102
                  " LEFT OUTER JOIN ",cl_get_target_table(l_azp01,'ima_file')," ON rvv_file.rvv31 = ima_file.ima01 ", #FUN-A50102
                  " LEFT OUTER JOIN ",cl_get_target_table(l_azp01,'pmc_file')," ON rvv_file.rvv06 = pmc_file.pmc01 ", #FUN-A50102
                  " LEFT OUTER JOIN ",cl_get_target_table(l_azp01,'rva_file')," ON rvv_file.rvv04 = rva_file.rva01 ",
                  " LEFT OUTER JOIN ",cl_get_target_table(l_azp01,'rvb_file')," ON rvv_file.rvv04 = rvb_file.rvb01 AND rvv_file.rvv05=rvb_file.rvb02 AND rva_file.rvaconf='Y' ",     #MOD-D40068 rvb_File->rvb_file
                  # cl_get_target_table(l_azp01,'rvu_file'),",",cl_get_target_table(l_azp01,'rva_file'),",",          #FUN-A50102
                  # cl_get_target_table(l_azp01,'rvb_file'),                                                          #FUN-A50102
                 #FUN-B50019 --end
                  " WHERE ",g_wc CLIPPED,
                  "   AND rvvplant = '",l_azp01,"' ",    #FUN-A10011
                  "   AND rvv03 ='1' ",
                  "   AND rvv87-rvv23-rvv88 > 0 ",
                 #"   AND rvv04 = rvb01 AND rvv05 = rvb02", #FUN-B50019
                 #"   AND rvv04 = rva01 AND rvaconf='Y' ",  #FUN-B50019
                  "   AND rvu01 = rvv01 AND rvuconf='Y' ",
                 #"   AND rvu117 IS NULL"    #FUN-960140
                 #"   AND rvv22 IS NULL",    #MOD-C80158 add  #MOD-D30222 mark
                  "   AND (rvv22 = ' ' OR rvv22 IS NULL) ",   #MOD-D30222
                  "   AND rvv89 <> 'Y'"   #No:TQC-B20093 
   END IF  #No.MOD-940232

   #FUN-D70021--add--str--
   IF g_a='N' THEN
      LET g_sql=g_sql CLIPPED," AND rvv31 NOT LIKE 'MISC%'"
   END IF
   #FUN-D70021--add--end
   #FUN-D60083--add--str--
   IF g_b = 'N' THEN
      LET g_sql=g_sql CLIPPED," AND rvv32 NOT IN (SELECT jce02 FROM ",
                              cl_get_target_table(l_azp01,'jce_file'),
                              ")"
   END IF
   #FUN-D60083--add--end--
 
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql               #FUN-A50102
   CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql       #FUN-A50102 
   PREPARE p115_tmp_prep FROM g_sql
   DECLARE p115_tmp_cs CURSOR WITH HOLD FOR p115_tmp_prep
   FOREACH p115_tmp_cs INTO l_temp.*
      IF cl_null(l_temp.rvv36) THEN
         IF NOT cl_null(l_temp.rvv04) THEN   #FUN-B50019
           #LET g_sql = "SELECT rva111,rva115,rva113,rva10 ",  #FUN-B50019
            LET g_sql = "SELECT rva10 ",  #FUN-B50019
                      # "  FROM ",l_dbs CLIPPED,"rva_file ",                   #FUN-A50102 mark
                        "  FROM ",cl_get_target_table(l_azp01,'rva_file'),     #FUN-A50102
                        " WHERE rva01 = '",l_temp.rvv04,"' "
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102
            CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql      #FUN-A50102
            PREPARE sel_rva111_pre FROM g_sql
           #EXECUTE sel_rva111_pre INTO l_temp.pmm20,l_temp.pmm21,l_temp.pmm22,l_rva10  #FUN-B50019
            EXECUTE sel_rva111_pre INTO l_rva10  #FUN-B50019
            LET l_temp.pmm44 = ' '
            LET l_temp.pmn122 = ' '
            LET l_temp.pmm02 = l_rva10
         END IF  #FUN-B50019
      ELSE
 
         LET g_sql = "SELECT pmm12,pmm20,pmm21,pmm22,pmm44,pmm02,pmn122 ",  #FUN-B50019  #MOD-CA0127 remark
        #LET g_sql = "SELECT pmm12,pmm44,pmm02,pmn122 ",  #FUN-B50019       #MOD-CA0127 mark
                   # "  FROM ",l_dbs CLIPPED,"pmm_file,",l_dbs CLIPPED,"pmn_file,",              #FUN-A50102 mark
                   # " OUTER ",l_dbs CLIPPED,"pma_file ",                                        #FUN-A50102 mark
                     "  FROM ",cl_get_target_table(l_azp01,'pmm_file'),",",         #FUN-A50102
                               cl_get_target_table(l_azp01,'pmn_file'),",",         #FUN-A50102
                     " OUTER ",cl_get_target_table(l_azp01,'pma_file'),             #FUN-A50102    
                     " WHERE pmm01 = '",l_temp.rvv36,"' ",
                     "   AND pmn01 = pmm01 ",
                     "   AND pmn02 = '",l_temp.rvv37,"' ",
#                    "   AND (pmm25='2' OR pmm25 = '6' ",
                     "   AND (pmm25='2' OR pmm25 = '6') ",    #No.TQC-A30098
                     "   AND pmm20 = pma01 AND pma11 <> '3' AND pma11 <> '4' ",
                     "   AND pma11 <> '5' AND pma11 <> '6' AND pma11 <> '7' ",
                     "   AND pma11 <> '8' "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102
         CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql          #FUN-A50102
         PREPARE sel_pmm12 FROM g_sql
         EXECUTE sel_pmm12 INTO l_pmm12,l_temp.pmm20,l_temp.pmm21,l_temp.pmm22, #FUN-B50019  #MOD-CA0127 remark
        #EXECUTE sel_pmm12 INTO l_pmm12,  #FUN-B50019  #MOD-CA0127 mark
                                l_temp.pmm44,l_temp.pmm02,l_temp.pmn122
        #LET g_sql = "SELECT pmc04,pmc24 FROM ",l_dbs CLIPPED,"pmc_file ",                 #FUN-A50102 mark
         LET g_sql = "SELECT pmc04,pmc24 FROM ",cl_get_target_table(l_azp01,'pmc_file'),   #FUN-A50102
                     " WHERE pmc01 = '",l_temp.rvv06,"' "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql         #FUN-A50102
         CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-A50102 
         PREPARE sel_pmc04_pre FROM g_sql
         EXECUTE sel_pmc04_pre INTO l_temp.pmc04,l_temp.pmc24
        #SELECT gen03 INTO l_temp.gen03 FROM gen_file              #MOD-A60155 mark
        # WHERE gen01 = l_pmm12                                    #MOD-A60155 mark
         SELECT gec03,gec04 INTO l_temp.gec03,l_temp.gec04
           FROM gec_file
          WHERE gec01=l_temp.pmm21
            AND gec011='1'
         SELECT azi03,azi04 INTO l_temp.azi03,l_temp.azi04
           FROM azi_file
          WHERE azi01 =l_temp.pmm22
      END IF
      INSERT INTO aapp115_temp VALUES(l_temp.*)
   END FOREACH
   LET g_sql = " SELECT * FROM aapp115_temp "
 
   IF summary_sw='1' THEN   #入庫單
      LET g_sql=g_sql CLIPPED, " ORDER BY rvu21,rvv01,pmm22,rvv02 "   #TQC-830013    #FUN-960141  #FUN-960140 add rty06   #FUN-9C0041 rty06->rvu21  #FUN-A10011 del rvuplant
   END IF
 
   IF summary_sw='2' THEN   #採購單
      LET g_sql=g_sql CLIPPED, " ORDER BY rvu21,rvv36,rvv37 "  #FUN-960141  #FUN-960140 add rty06 #FUN-9C0041 rty06->rvu21   #FUN-A10011 del rvuplant
   END IF
 
   IF summary_sw='3' THEN   #廠商
      #No.MOD-D10264  --Begin
      IF g_aza.aza26 = '2' THEN
         LET g_sql=g_sql CLIPPED, " ORDER BY rvu21,rvv06,pmm22,pmm21,rvv01 "
      ELSE
      #No.MOD-D10264  --End
         LET g_sql=g_sql CLIPPED, " ORDER BY rvu21,rvv06,pmm22,pmm20,pmm21,rvv01 "    #FUN-960141  #FUN-960140 add rty06  #FUN-9C0041 rty06->rvu21   #FUN-A10011 del rvuplant
      END IF  #MOD-D10264
   END IF

 
   PREPARE p115_prepare FROM g_sql
   IF STATUS THEN
      LET g_success = 'N'
      CALL cl_err('prepare:',STATUS,1) 
      RETURN
   END IF
 
   DECLARE p115_cs CURSOR WITH HOLD FOR p115_prepare
 

   CALL s_showmsg_init()              #NO. FUN-710014
   FOREACH p115_cs INTO g_vendor,g_rvv01,g_rvv09,g_vendor2,g_apa.apa18,         #No.TQC-850001
                        g_apb.apb21,g_apb.apb22,g_apb.apb29,g_apb.apb04,
                        g_apb.apb05,g_apb.apb06,g_apb.apb07,g_apa.apa13,
                        g_apb.apb23,g_apb.apb09,g_apb.apb24,
                        g_apb24t,   #CHI-8A0038 add
                        g_apb.apb12,g_apa.apa09,g_apa.apa11,
                       #g_apa.apa15,g_apa.apa17,g_pmm02,g_apa.apa22,g_pmn122,    #MOD-A60155 mark
                        g_apa.apa15,g_apa.apa17,g_pmm02,g_pmn122,                #MOD-A60155
                        g_apa.apa52,g_apa.apa16,t_azi.azi03,t_azi.azi04,  #No.TQC-770012
                        g_pmc54,g_rvv25,g_rva04,g_rvu10,g_rvv930,   #FUN-670064
                        g_rvu21,    #FUN-960141 add g_rvuplant    #FUN-960140 add g_rty06 #FUN-9C0041 g_rty06->rvu21  #FUN-A10011 del rvuplant 
                        g_rvv87   #TQC-790159  add                        
      IF STATUS THEN
         CALL s_errmsg('','','p115(ckp#1):',SQLCA.sqlcode,1)    #NO. FUN-710014    
         LET g_success = 'N'
         EXIT FOREACH
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
     #CHI-A40012---add---start---
      IF (YEAR(g_rvv09) != YEAR(g_apa02)) OR (MONTH(g_rvv09) != MONTH(g_apa02)) THEN 
         CALL s_errmsg('apb21',g_apb.apb21,'','axr-065',1)
         CONTINUE FOREACH
      END IF
     #CHI-A40012---add---end---
     #No.TQC-BA0175  --Begin
      IF g_rvv09  > g_apa02 THEN 
         CONTINUE FOREACH
      END IF
      #No.TQC-BA0175  --End

     #CHI-AB0011 add --start--
     IF NOT cl_null(g_apb.apb06) THEN
        IF g_wc3 != ' 1=1' THEN
           LET l_cnt = 0
           LET g_sql="SELECT COUNT(*) FROM pmm_file ",
                     " WHERE ",g_wc3 CLIPPED,
                     "   AND pmm01 = '",g_apb.apb06,"'"
           PREPARE p115_precount FROM g_sql
           DECLARE p115_count CURSOR FOR p115_precount
           OPEN p115_count
           FETCH p115_count INTO l_cnt
           IF l_cnt = 0 THEN
              CONTINUE FOREACH
           END IF
        END IF
     END IF
     #CHI-AB0011 add --end--

     #FUN-B50019 --begin 以上sql中已经从入库单取得rvu111,rvu113,不需要重复抓取,故MARK
     # IF cl_null(g_apb.apb06) THEN
     #    IF cl_null(g_apb.apb04) THEN

     #       LET g_sql = "SELECT rvu111,rvu113 ",
     #                 # "  FROM ",l_dbs CLIPPED,"rvu_file,",l_dbs CLIPPED,"rvv_file ",           #FUN-A50102 mark
     #                   "  FROM ",cl_get_target_table(l_azp01,'rvu_file'),",",                   #FUN-A50102
     #                             cl_get_target_table(l_azp01,'rvv_file'),                       #FUN-A50102 
     #                   " WHERE rvv01 = rvu01 ",
     #                   "   AND rvv01 = '",g_apb.apb21,"' ",
     #                   "   AND rvv02 = '",g_apb.apb22,"' "
     #       CALL cl_replace_sqldb(g_sql) RETURNING g_sql           #FUN-A50102 
     #       CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql   #FUN-A50102
     #       PREPARE sel_rvu111_pre FROM g_sql
     #       EXECUTE sel_rvu111_pre INTO g_apa.apa11,g_apa.apa13
     #    ELSE 
     #FUN-B50019 --end

    #-MOD-B50062-add-  
     LET g_sql = "SELECT rva00 ", 
                 "  FROM ",cl_get_target_table(l_azp01,'rva_file'),
                 " WHERE rva01 = '",g_apb.apb04,"' "
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql          
     CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql 
     PREPARE sel_rvu111_pre1 FROM g_sql
     EXECUTE sel_rvu111_pre1 INTO l_rva00

     IF l_rva00 = '1' THEN
        LET g_sql = "SELECT pmm20,pmm22 ",
                    "  FROM ",cl_get_target_table(l_azp01,'pmm_file'),   
                    " WHERE pmm01='",g_apb.apb06,"' "
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql         
        CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql 
        PREPARE sel_pmm20_pre FROM g_sql
        EXECUTE sel_pmm20_pre INTO g_apa.apa11,g_apa.apa13
     END IF
    #-MOD-B50062-end-  
     #No.MOD-C50092  --Begin
     IF l_rva00 = '2' THEN
        LET g_sql = "SELECT rva111,rva113",
                    "  FROM ",cl_get_target_table(l_azp01,'rva_file'),
                    " WHERE rva01='",g_apb.apb04,"' "
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql
        CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql
        PREPARE sel_rva113_pre FROM g_sql
        EXECUTE sel_rva113_pre INTO g_apa.apa11,g_apa.apa13
     END IF
     #No.MOD-C50092  --End

      IF g_apb.apb12[1,4] <> 'MISC' THEN
       # LET g_sql = "SELECT COUNT(ima01) FROM ",l_dbs CLIPPED,"ima_file ",                   #FUN-A50102 mark
         LET g_sql = "SELECT COUNT(ima01) FROM ",cl_get_target_table(l_azp01,'ima_file'),     #FUN-A50102
                     " WHERE ima01 = '",g_apb.apb12,"' "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
         CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql     #FUN-A50102
         PREPARE sel_cout_ima01 FROM g_sql
         EXECUTE sel_cout_ima01 INTO t_ima01
         IF t_ima01 = 0 THEN
            CONTINUE FOREACH
         END IF
      END IF
 
      IF g_success='N' THEN
         LET g_totsuccess='N'
         LET g_success='Y'
      END IF
      LET g_rvv01=g_apb.apb21
      IF g_rva04 = 'Y' THEN 
         CONTINUE FOREACH
      END IF
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM apa_file,apb_file #No.TQC-740080
       WHERE apb21 = g_apb.apb21 AND apb22 = g_apb.apb22   #MOD-630123
         AND apa01 = apb01         #No.TQC-740080
         AND apa42 <> 'Y'          #No.TQC-740080
         AND apb37 = l_azp01       #FUN-A20006   #避免兩個營運中心得入庫單號恰巧相同得情況
 
      IF g_apa.apa13 IS NULL THEN
         LET g_apa.apa13=g_aza.aza17
      END IF
 
     #check 有無已立暫估
      LET l_cnt=0
      SELECT COUNT(*) INTO l_cnt FROM apa_file,apb_file
       WHERE apa00='16' AND apa01=apb01   #FUN-680110
         AND apb21 = g_apb.apb21 AND apb22=g_apb.apb22  #No.3280
         AND apa42 <> 'Y' #modi 01/08/03
         AND apa08 = 'UNAP'     #no.6824
         AND apb37 = l_azp01    #FUN-A20006
 
     #一張入庫單+項次最多只能對應一筆暫估,不能有一筆以上,否則后續會有問題
     IF l_cnt > 0 THEN
        LET g_showmsg = g_apb.apb21,'/',g_apb.apb22 USING "<<<<<"
        IF g_bgerr THEN 
           CALL s_errmsg('apb21,apb22',g_showmsg,'','aap-815',1)
        ELSE
           CALL cl_err(g_showmsg,'aap-815',1)
        END IF
        CONTINUE FOREACH
     END IF
 
      IF g_pmm02 = 'TAP' OR g_pmm02 = 'TRI' THEN    #MOD-660122      #FUN-650164
         CONTINUE FOREACH
      END IF
      IF g_bgjob = 'N' THEN                       #FUN-570112
          DISPLAY g_apb.apb21,' ',g_apb.apb22 AT 1,1
      END IF                                      #FUN-570112
     #ps.請注意: 暫估款應為零稅不申報
      IF NOT cl_null(g_apa15) THEN
         LET g_apa.apa15=g_apa15
         LET g_apa.apa16=g_gec04
      END IF
 
      IF g_apa.apa16 IS NULL THEN 
         LET g_apa.apa16 = 0 
      END IF
 
      IF t_azi.azi03 IS NULL THEN  #No.TQC-770012 g_azi -> t_azi
         LET t_azi.azi03 = 0       #No.TQC-770012 g_azi -> t_azi
      END IF
 
      IF t_azi.azi04 IS NULL THEN  #No.TQC-770012 g_azi -> t_azi
         LET t_azi.azi04 = 0       #No.TQC-770012 g_azi -> t_azi
      END IF
 
      #IF g_apb.apb23 IS NULL OR g_rvv25='Y' THEN        #若為樣品則單價為   #MOD-DB0042
      IF g_apb.apb23 IS NULL  THEN    #MOD-DB0042
         LET g_apb.apb23 = 0 
      END IF

      #MOD-DB0042  --Begin
      IF g_rvv25 = 'Y' THEN
         LET g_apb.apb23 = 0
         LET g_apb24t = 0
      END IF
      #MOD-DB0042  --Begin
 
      IF enter_account = "N" THEN
         IF g_apb.apb23 = 0 THEN
            CONTINUE FOREACH
         END IF
      END IF
 
      IF g_vendor2 IS NULL THEN
         LET g_vendor2 = g_vendor
      END IF
 
      SELECT pmc03 INTO g_abbr FROM pmc_file WHERE pmc01 = g_vendor2
 
      IF g_pmn122  IS NULL THEN
         LET g_pmn122  = ' '   
      END IF
 
 
     IF (summary_sw='4' AND (l_azp01 != t_azp01 OR t_azp01 IS NULL))   #FUN-A10011 add
         OR ( summary_sw='1' AND (g_apb.apb21 != t_rvv01 OR g_apa.apa13 != t_pmm22))  #FUN-A10011
         OR (g_rvu21 != t_rvu21)     #FUN-9C0041  不同經營方式的資料不能匯總 
         OR ( summary_sw='2' AND g_apb.apb06 != t_apb06 )      
       #FUN-C80022 mark--str
       # OR (purchas_sw = 'Y' AND #FUN-C70052 add
       #     ((g_pmm02 = 'SUB' AND g_pmm02 != g_pmm02_t)OR #FUN-C70052 add
       #      (g_pmm02_t = 'SUB' AND g_pmm02 != 'SUB')))  #FUN-C70052 add
       #FUN-C80022 mark--end
         OR ( summary_sw='3' AND
         #No.3300 多一括號將OR 條件括起來
         ( (t_vendor IS NULL OR g_vendor != t_vendor)      OR    #廠商
         #(t_pmm20  IS NULL OR g_apa.apa11 != t_pmm20)    OR    #付款條件
         ((t_pmm20 IS NULL AND g_aza.aza26 <> '2') OR (g_apa.apa11 != t_pmm20 AND g_aza.aza26 <> '2')) OR     #付款條件 #MOD-D10264
         (t_pmm22  IS NULL OR g_apa.apa13 != t_pmm22) ) )  THEN  #幣別
         #No.MOD-D60145  --Begin
         CALL p115_apa05('')
         IF NOT cl_null(g_errno) THEN
            LET g_success = 'N'
            CALL s_errmsg("apa05",g_vendor,'',g_errno,1)
            CONTINUE FOREACH
         END IF
         #No.MOD-D60145  --End
         IF g_apa.apa01 IS NOT NULL THEN
            CALL p115_upd_apa57(t_azp01)   #FUN-A10011 add 參數t_azp01
            CALL p115_upd_apa66()   #CHI-920018 add
            CALL p115_ins_apc()  #No.TQC-7B0083
         END IF
         CALL p115_ins_apa()                                   #Insert Head
         IF g_success = 'N' THEN 
            CONTINUE FOREACH       #NO. FUN-710014   
         END IF
         LET l_apa100_t = g_apa.apa100
         LET l_apa01_t = g_apa.apa01
        #LET g_pmm02_t = g_pmm02#FUN-C70052 add #FUN-C80022 mark
      ELSE
         IF l_azp01 <> l_apa100_t THEN
            UPDATE apa_file SET apa100 = ''
             WHERE apa01 = l_apa01_t
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","apa_file",g_apa.apa01,g_apa.apa100,SQLCA.sqlcode,"","",1)
               LET g_success ='N'
            END IF
         END IF
      END IF
      
      LET t_azp01 = l_azp01        #FUN-A10011
      LET t_azp03 = l_dbs          #FUN-A10011
      LET t_rvv01  = g_apb.apb21
      LET t_apb06  = g_apb.apb06
      LET t_vendor = g_vendor
      LET t_pmm20  = g_apa.apa11
      LET t_pmm21  = g_apa.apa15
      LET t_pmm22  = g_apa.apa13
      LET t_pmn122 = g_pmn122
      LET t_rty06 = g_rty06     #FUN-960140
      LET t_rvu21 = g_rvu21     #FUN-9C0041
 
     #SELECT azi03,azi04 INTO t_azi03,t_azi04 FROM azi_file #FUN-B50019
      SELECT azi03,azi04 INTO t_azi.azi03,t_azi.azi04 FROM azi_file #FUN-B50019
       WHERE azi01=g_apa.apa13
      CALL p115_ins_apb()
 
      IF g_success = 'N' THEN
         CONTINUE FOREACH   #NO. FUN-710014 
      END IF
   

   END FOREACH
  END FOREACH   #FUN-A10011
       IF g_totsuccess="N" THEN
          LET g_success="N"
       END IF
 
   IF NOT cl_null(t_rvv01) THEN   #MOD-840031
      CALL p115_upd_apa57(l_azp01)   #FUN-A10011 add 參數l_azp01
      CALL p115_upd_apa66()   #CHI-920018 add
      CALL p115_ins_apc()  #No.TQC-7B0083
   END IF
 

 
   IF begin_no IS NOT NULL THEN
      IF g_bgjob = 'N' THEN                       #FUN-570112
          DISPLAY begin_no TO start_no
          DISPLAY end_no   TO end_no
      END IF   #FUN-570112
   ELSE
     #CALL cl_err('','aap-129',1) #CHI-A90002 mark
      CALL s_errmsg('apa01',begin_no,'','aap-129',1) #CHI-A90002
      LET g_success = 'N'   #FUN-560070
   END IF
END FUNCTION
 
 
FUNCTION p115_upd_apa57(m_azp01)    #FUN-A10011 add m_azp01
  DEFINE l_apydmy3         LIKE apy_file.apydmy3 #FUN-5B0089 add
  DEFINE l_trtype          LIKE apy_file.apyslip #NO.FUN-690028 VARCHAR(5) #FUN-5B0089 add
  DEFINE l_azp03   LIKE type_file.chr21  #FUN-A10011
  DEFINE m_azp01   LIKE azp_file.azp01   #FUN-A10011  
  DEFINE l_azp01   LIKE azp_file.azp01   #FUN-A20006 
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
     #LET g_plant_new = m_azp01   #FUN-A20006
      LET g_plant_new = l_azp01   #FUN-A20006
      CALL s_gettrandbs()
      LET l_azp03 = g_dbs_tra
    END IF
 
    LET g_sql = "SELECT SUM(apb24),SUM(apb10) FROM apb_file,",
              #  l_azp03 CLIPPED,"rvv_file,",l_azp03 CLIPPED,"rvu_file ",          #FUN-A50102 mark
                 cl_get_target_table(l_azp01,'rvv_file'),",",                      #FUN-A50102
                 cl_get_target_table(l_azp01,'rvu_file'),                          #FUN-A50102
                " WHERE apb01='",g_apa.apa01,"' AND rvu01=rvv01 ",
                "   AND rvuconf='Y'   AND apb21 = rvv01 ",
                "   AND apb37 = '",l_azp01,"'",    #FUN-A20006
                "   AND apb22 = rvv02 AND rvv03 = '1' "          
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql                 #FUN-A50102
    CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql         #FUN-A50102
    PREPARE sel_sum_apb24 FROM g_sql
    EXECUTE sel_sum_apb24 INTO f_amt1,g_amt1
    IF f_amt1 IS NULL THEN LET f_amt1 = 0 END IF
    IF g_amt1 IS NULL THEN LET g_amt1 = 0 END IF
 

    LET g_sql = "SELECT SUM(apb24),SUM(apb10) FROM apb_file,",
              #   l_azp03 CLIPPED,"rvv_file,",l_azp03 CLIPPED,"rvu_file ",         #FUN-A50102 mark
                 cl_get_target_table(l_azp01,'rvv_file'),",",                      #FUN-A50102
                 cl_get_target_table(l_azp01,'rvu_file'),                          #FUN-A50102
                " WHERE apb01 = '",g_apa.apa01,"' AND rvu01=rvv01",
                "   AND rvuconf='Y' AND apb21 = rvv01 ",          
                "   AND apb37 = '",l_azp01,"'",    #FUN-A20006
                "   AND apb22 = rvv02 AND rvv03 = '3'"
    PREPARE sel_sum_apb10 FROM g_sql
    EXECUTE sel_sum_apb10 INTO f_amt2,g_amt2 
    IF f_amt2 IS NULL THEN LET f_amt2 = 0 END IF
    IF g_amt2 IS NULL THEN LET g_amt2 = 0 END IF
 
    #no.4191幣別取位必須要抓t_pmm22的
    #       否則會用到上一張的幣別取位
    IF NOT cl_null(t_pmm22) THEN
       SELECT azi04 INTO t_azi.azi04           #No.CHI-6A0004 g_azi-->t_azi
        FROM azi_file 
        WHERE azi01 = t_pmm22
    END IF
   #暫估款皆為零稅不申報
    LET g_apa.apa31f=(f_amt1+f_amt2)
    LET g_apa.apa31 =(g_amt1+g_amt2)
    LET g_apa.apa31f= cl_digcut(g_apa.apa31f,t_azi.azi04)      #No.CHI-6A0004 g_azi-->t_azi
    LET g_apa.apa31 = cl_digcut(g_apa.apa31 ,g_azi04)          #No.TQC-770012
 
    LET g_apa.apa32f= g_apa.apa31f* g_apa.apa16 / 100   # 四捨五入
    LET g_apa.apa32f= cl_digcut(g_apa.apa32f,t_azi.azi04)        #No.CHI-6A0004 g_azi-->t_azi
    LET g_apa.apa32 = g_apa.apa31 * g_apa.apa16 / 100   # 四捨五入
    LET g_apa.apa32 = cl_digcut(g_apa.apa32,g_azi04)           #No.TQC-770012
 
    LET g_apa.apa34f=g_apa.apa31f+g_apa.apa32f
    LET g_apa.apa34 =g_apa.apa31 +g_apa.apa32
 
    LET g_apa.apa57f=f_amt1+f_amt2
    LET g_apa.apa57 =g_amt1+g_amt2
    LET g_apa.apa57f= cl_digcut(g_apa.apa57f,t_azi.azi04)  #MOD-8C0035 add
    LET g_apa.apa57 = cl_digcut(g_apa.apa57,g_azi04)       #MOD-8C0035 add
    LET g_apa.apa33f=g_apa.apa57f-g_apa.apa31f
    LET g_apa.apa33 =g_apa.apa57 -g_apa.apa31
   #MOD-A50151---modify---start---
   #IF g_apa.apa31f<>g_apa.apa57f+g_apa.apa60f OR
   #   g_apa.apa31 <>g_apa.apa57 +g_apa.apa60  OR
   #   g_apa.apa31 = 0 THEN
    IF (g_apa.apa31f<>g_apa.apa57f+g_apa.apa60f OR
       g_apa.apa31 <>g_apa.apa57 +g_apa.apa60  OR
       g_apa.apa31 = 0) AND enter_account = 'N' THEN 
   #MOD-A50151---modify---end---
       LET g_apa.apa56 = '1'
       LET g_apa.apa19 = g_apz.apz12
       LET g_apa.apa20 = g_apa.apa31f+g_apa.apa32f
    END IF
    CALL p115_comp_oox(g_apa.apa01) RETURNING g_net                                                                                 
    LET g_apa.apa73=g_apa.apa34-g_apa.apa35 + g_net    #A059                                                                        
   #FUN-A20006--mod--str--
   #UPDATE apa_file set apa31f=g_apa.apa31f,
   #                    apa31=g_apa.apa31,
   #                    apa32f=g_apa.apa32f,
   #                    apa32=g_apa.apa32,
   #                    apa34f=g_apa.apa34f,
   #                    apa34=g_apa.apa34,
   #                    apa73=g_apa.apa73,      #A059
   #                    apa57f=g_apa.apa57f,
   #                    apa57=g_apa.apa57,
   #                    apa33f=g_apa.apa33f,
   #                    apa33=g_apa.apa33,
   #                    apa56=g_apa.apa56,
   #                    apa19=g_apa.apa19,
   #                    apa20=g_apa.apa20
    UPDATE apa_file set apa31f = apa31f + g_apa.apa31f,
                        apa31 = apa31 + g_apa.apa31,
                        apa32f = apa32f + g_apa.apa32f,
                        apa32 = apa32 + g_apa.apa32,
                        apa34f = apa34f + g_apa.apa34f,
                        apa34 = apa34 + g_apa.apa34,
                        apa73 = apa73 + g_apa.apa73,      
                        apa57f = apa57f + g_apa.apa57f,
                        apa57 = apa57 + g_apa.apa57,
                        apa33f = apa33f + g_apa.apa33f,
                        apa33 = apa33 + g_apa.apa33,
                       #apa56 = apa56 + g_apa.apa56,        #MOD-C50181 mark
                       #apa19 = apa19 + g_apa.apa19,        #MOD-C50181 mark
                        apa56 = g_apa.apa56,              #MOD-C50181 add
                        apa19 = g_apa.apa19,              #MOD-C50181 add
                        apa20=apa20+g_apa.apa20
   #FUN-A20006--mod--end
        WHERE apa01 = g_apa.apa01
 END FOREACH   #FUN-A20006
        LET l_trtype = trtype[1,g_doc_len]
        SELECT apydmy3 INTO l_apydmy3 FROM apy_file WHERE apyslip = l_trtype
        IF SQLCA.sqlcode THEN
           CALL cl_err3("sel","apy_file",l_trtype,"",STATUS,"","sel apy:",0) #No.FUN-660122
           LET g_success = 'N'
        END IF
        IF l_apydmy3 = 'Y' THEN   #是否拋轉傳票
           CALL t110_g_gl(g_apa.apa00,g_apa.apa01,'0',m_azp01)  #No.FUN-680029 新增參數'0'   #FUN-A10011 add m_azp01
           IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
              CALL t110_g_gl(g_apa.apa00,g_apa.apa01,'1',m_azp01)  #FUN-A10011 add m_azp01
           END IF
        END IF
END FUNCTION
 
FUNCTION p115_upd_apa66()
   LET g_cnt = 0 
   SELECT COUNT(DISTINCT apb35) INTO g_cnt FROM apb_file
    WHERE apb01 = g_apa.apa01
   IF cl_null(g_cnt) THEN LET g_cnt = 0 END IF
   IF g_cnt = 1 THEN   #表示單身只有一個專案編號,可回寫單頭專案編號欄位
      SELECT DISTINCT apb35 INTO g_apa.apa66 
        FROM apb_file
       WHERE apb01 = g_apa.apa01
 
      UPDATE apa_file SET apa66 = g_apa.apa66
                    WHERE apa01 = g_apa.apa01
      IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
         LET g_success = 'N'
         CALL s_errmsg("apa01",g_apa.apa01,"upd apa:",SQLCA.sqlcode,1)
      END IF
   END IF
END FUNCTION
 
FUNCTION p115_ins_apa()
    DEFINE l_gen03     LIKE gen_file.gen03
    DEFINE li_result   LIKE type_file.num5     #FUN-560070  #No.FUN-690028 SMALLINT
    DEFINE l_depno     LIKE apa_file.apa22     #FUN-960140
    DEFINE g_t2        LIKE apy_file.apyslip       #MOD-990168     

    LET g_apa.apa02 = g_apa02 
    LET g_apa.apa36 = g_apa36 
    IF g_bgjob = 'Y' THEN CALL p115_apa36() END IF #MOD-B90229
    IF g_apa.apa19 = g_apz.apz12 THEN
       LET g_apa.apa56 = '0'
       LET g_apa.apa19 = NULL
       LET g_apa.apa20 = 0
    END IF
    LET g_apa.apa00 = '16'   #FUN-680110
    LET g_apa.apa05 = g_vendor
    #CHI-A90002 add --start--
    CALL p115_apa05('')
    IF NOT cl_null(g_errno) THEN
       LET g_success = 'N'
       CALL s_errmsg("apa05",g_apa.apa05,'',g_errno,1)
       RETURN
    END IF
    #CHI-A90002 add --end--
    LET g_apa.apa06 = g_vendor2
    LET g_apa.apa07 = g_abbr
    LET g_apa.apa08 = 'UNAP'
    CALL s_paydate('a','',g_apa.apa09,g_apa.apa02,g_apa.apa11,g_apa.apa06)
         RETURNING g_apa.apa12,g_apa.apa64,g_apa.apa24
 
    LET g_apa.apa14 = 1
    CALL s_curr3(g_apa.apa13,g_apa.apa02,g_apz.apz33) RETURNING g_apa.apa14 #FUN-640022
    LET g_apa.apa72 = g_apa.apa14             #A059
   #當稅率(apa16)為零時，稅額科目不需輸入
    IF g_apa.apa16=0 THEN
       LET g_apa.apa52 = ''
       LET g_apa.apa521= ''
    END IF
    IF cl_null(g_apa.apa21) THEN
      #FUN-A60056--mod--str--
      #SELECT pmm12 INTO g_pmm12 FROM pmm_file WHERE pmm01 =g_apb.apb06 
      #       AND pmm18 !='X'
       LET g_sql = "SELECT pmm12 FROM ",cl_get_target_table(l_azp01,'pmm_file'),
                   " WHERE pmm01 ='",g_apb.apb06,"'",
                   "   AND pmm18 !='X'"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql
       CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql
       PREPARE sel_pmm12_pre FROM g_sql
       EXECUTE sel_pmm12_pre INTO g_pmm12 
      #FUN-A60056--mod--end
       LET g_apa.apa21 = g_pmm12
    END IF
    IF cl_null(g_apa.apa22) THEN 
       SELECT gen03 INTO l_gen03 FROM gen_file WHERE gen01=g_pmm12
       LET g_pmm13=l_gen03 
       LET g_apa.apa22 = g_pmm13
    END IF
 
    SELECT gec06,gec08 INTO g_apa.apa172,g_apa.apa171 FROM gec_file
     WHERE gec01 = g_apa.apa15
       AND gec011 = '1'          #MOD-940182
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
    LET g_apa.apa73 = 0                        #A059
    LET g_apa.apa35f= 0 LET g_apa.apa35 = 0
    LET g_apa.apa37f = 0    #MOD-B20088
    LET g_apa.apa37 = 0     #MOD-B20088
    LET g_apa.apa65f= 0 LET g_apa.apa65 = 0
    LET g_apa.apa41 = 'N'
    LET g_apa.apa42 = 'N'
    LET g_apa.apa55 = '1'
    LET g_apa.apa56 = '0'
    LET g_apa.apa57f= 0 LET g_apa.apa57 = 0
    LET g_apa.apa60f= 0 LET g_apa.apa60 = 0
    LET g_apa.apa61f= 0 LET g_apa.apa61 = 0
    LET g_apa.apa74 = 'N'
    LET g_apa.apa75 = 'N'
    LET g_apa.apaacti = 'Y'
    LET g_apa.apainpd = g_today
    LET g_apa.apauser = g_user
    LET g_apa.apagrup = g_grup
    LET g_apa.apadate = g_today
    LET g_apa.apa63 = 0   #MOD-620079
    IF g_azw.azw04 = '2' AND (g_rvu21 = '2' OR g_rvu21 = '3') THEN  #業態為零售且經營方式為代銷
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
 
    IF summary_sw='1' THEN   #入庫單
       IF NOT cl_null(trtype) THEN
          CALL s_auto_assign_no("aap",trtype,g_apa.apa02,g_apa.apa00,"","","","","")   #FUN-560070
                                RETURNING li_result,g_apa.apa01   #FUN-560070
       ELSE
          LET g_apa.apa01=g_apb.apb21
          LET g_apa.apamksg ='N'
       END IF
    ELSE
       CALL s_auto_assign_no("aap",trtype,g_apa.apa02,g_apa.apa00,"","","","","")   #FUN-560070
                             RETURNING li_result,g_apa.apa01   #FUN-560070
       LET g_apa.apamksg = g_apy.apyapr
    END IF
    IF NOT li_result THEN 
       LET g_success = 'N'
       CALL s_errmsg("apa01",g_apa.apa01,"auto_assign_no fail",'abm-621',1)
       RETURN
    END IF 
    IF g_bgjob = 'N' THEN                       #FUN-570112
        DISPLAY "insert apa:",g_apa.apa01,' ',g_apa.apa02,' ',g_apa.apa06
            AT 2,1
    END IF               #FUN-570112
    LET g_apa.apaprno = 0   #MOD-830072
    LET g_apa.apa100 = l_azp01        #FUN-A10011
    LET g_apa.apalegal = g_legal      #FUN-980001
    LET g_apa.apa76 = g_rvu21          #FUN-9C0041
    LET g_apa.apaoriu = g_user      #No.FUN-980030 10/01/04
    LET g_apa.apaorig = g_grup      #No.FUN-980030 10/01/04
    LET g_apa.apa79 = '0'           #No.FUN-A40003     #No.FUN-A60024
    INSERT INTO apa_file VALUES(g_apa.*)
    IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
       CALL cl_err3("ins","apa_file",g_apa.apa01,"",SQLCA.sqlcode,"","p115_ins_apa(ckp#1):",1) #No.FUN-660122
       LET g_success = 'N'
    END IF
    IF begin_no IS NULL THEN LET begin_no=g_apa.apa01 END IF
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
 
FUNCTION p115_ins_apb()
    DEFINE l_invoice   LIKE apa_file.apa08
    DEFINE l_depno     LIKE apa_file.apa22
    DEFINE l_d_actno   LIKE apa_file.apa51
    DEFINE l_c_actno   LIKE apa_file.apa54
    DEFINE l_pmk13     LIKE pmk_file.pmk13
    DEFINE l_rvw10     LIKE rvw_file.rvw10     #No.TQC-790171
    DEFINE l_gec04     LIKE gec_file.gec04     #CHI-8A0038 add
    DEFINE l_gec07     LIKE gec_file.gec07     #CHI-8A0038 add
    DEFINE l_rvv31     LIKE rvv_file.rvv31     #FUN-D60083 add
    DEFINE l_rvv32     LIKE rvv_file.rvv32     #MOD-910236 add
    DEFINE l_rvv33     LIKE rvv_file.rvv33     #MOD-910236 add
    DEFINE l_aag05     LIKE aag_file.aag05     #MOD-910236 add
    DEFINE l_pmn24     LIKE pmn_file.pmn24     #FUN-930165 add
    DEFINE l_azf141    LIKE azf_file.azf141  #FUN-B80058
    DEFINE l_n         LIKE type_file.num5     #FUN-D60083 add
 
    SELECT MAX(apb02)+1 INTO g_apb.apb02 FROM apb_file WHERE apb01=g_apb.apb01
    IF g_apb.apb02 IS NULL THEN LET g_apb.apb02 = 1 END IF
 
    IF g_apb.apb29 = '3' THEN
       LET g_apb.apb23 = cl_digcut(g_apb.apb23,t_azi.azi03) * -1          #No.CHI-6A0004 g_azi-->t_azi
    ELSE
       LET g_apb.apb23 = cl_digcut(g_apb.apb23,t_azi.azi03)           #No.CHI-6A0004 g_azi-->t_azi
    END IF   #TQC-610108
 
 
    IF g_apb.apb09 IS NULL THEN LET g_apb.apb09 = 0 END IF

   #單價含稅時,不使用單價*數量=金額,改以含稅金額回推稅率,以避免小數位差的問題
    LET l_gec04 = 0   LET l_gec07 = ''

   #LET g_sql = "SELECT gec04,gec07 FROM ",l_dbs CLIPPED,"gec_file,",l_dbs CLIPPED,"pmm_file ",          #FUN-A50102 mark
    IF cl_null(g_apb.apb06) THEN   #MOD-BB0172
       LET g_sql = "SELECT gec04,gec07 FROM ",cl_get_target_table(l_azp01,'gec_file'),                  #FUN-A50102
        #                                     cl_get_target_table(l_azp01,'pmm_file'),                      #FUN-A50102
                  #" WHERE gec01 = pmm21 AND pmm01 = '",g_apb.apb06,"' ",
                   " WHERE gec01 = '",g_apa.apa15,"' ",
                   "   AND gec011 = '1' "
    #No.MOD-BB0172  --Begin
    ELSE 
       LET g_sql = "SELECT gec04,gec07 FROM ",cl_get_target_table(l_azp01,'gec_file'),",",
                                             cl_get_target_table(l_azp01,'pmm_file'),
                  " WHERE gec01 = pmm21 AND pmm01 = '",g_apb.apb06,"' ",
                   "   AND gec011 = '1' "
    END IF
    #No.MOD-BB0172  --End
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
    CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql     #FUN-A50102 
    PREPARE sel_gec04_pre FROM g_sql
    EXECUTE sel_gec04_pre INTO l_gec04,l_gec07
    IF cl_null(l_gec04) THEN LET l_gec04=0   END IF
    IF cl_null(l_gec07) THEN LET l_gec07='N' END IF
    IF l_gec07='Y' THEN
       #LET g_apb24t = cl_digcut(g_apb24t,t_azi04)    #MOD-920013 add  #MOD-B80123 mark
       LET g_apb24t = cl_digcut(g_apb24t,t_azi.azi04)    #MOD-B80123
       LET g_apb.apb24 = g_apb24t / (1+l_gec04/100)
    ELSE
       IF g_apb.apb09>0 THEN
          LET g_apb.apb24 = g_apb.apb23 * g_apb.apb09
         #LET g_apb.apb24 = cl_digcut(g_apb.apb24,t_azi04)   #MOD-930039 #MOD-B30064 mark
       END IF
    END IF
   LET g_apb.apb24 = cl_digcut(g_apb.apb24,t_azi.azi04)         #No.CHI-6A0004 g_azi-->t_azi #MOD-B30064 mark #MOD-B80123 还原
   # LET g_apb.apb24 = cl_digcut(g_apb.apb24,t_azi04)                                          #MOD-B30064 #MOD-B80123 mark
 
    LET g_apb.apb08 = g_apb.apb23 * g_apa.apa14
    LET g_apb.apb08 = cl_digcut(g_apb.apb08,g_azi03)      #No.TQC-770012
    LET g_apb.apb10 = g_apb.apb24 * g_apa.apa14 
    LET g_apb.apb10 = cl_digcut(g_apb.apb10,g_azi04)      #No.TQC-770012
    LET g_apb.apb081 = g_apb.apb08
    LET g_apb.apb101 = g_apb.apb10
 
   # 帶出品名,單位,科目,部門
    LET g_pmn401 = '' #No.FUN-680029
    LET g_apb.apb27 = ''   #MOD-8C0116 add   

    #FUN-B50019 --begin
   #LET g_sql = "SELECT pmn041,pmn86,pmn40,pmn401,pmn67,pmk13,pmn122,pmn96,pmn98,pmn24 ",
   #          # "  FROM ",l_dbs CLIPPED,"pmn_file LEFT OUTER JOIN ",l_dbs CLIPPED,"pmk_file ", #FUN-A50102 mark
   #            "  FROM ",cl_get_target_table(l_azp01,'pmn_file'),                             #FUN-A50102
   #            " LEFT OUTER JOIN ",cl_get_target_table(l_azp01,'pmk_file'),                   #FUN-A50102
   #            "                                      ON pmn_file.pmn24 = pmk_file.pmk01 ",
   #            " WHERE pmn01='",g_apb.apb06,"' AND pmn02='",g_apb.apb07,"' "
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql          #FUN-A50102
   #CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql  #FUN-A50102
   #PREPARE sel_pmn_pre FROM g_sql
   #EXECUTE sel_pmn_pre INTO g_apb.apb27,g_apb.apb28,g_apb.apb25,g_pmn401,
   #                         g_apb.apb26,l_pmk13,g_apb.apb35,g_apb.apb36,
   #                         g_apb.apb31,l_pmn24
    IF cl_null(g_apb.apb06) THEN
       #LET g_sql = " SELECT rvv031,rvv35 ",        #yinhy131205  mark
       LET g_sql = " SELECT rvv031,rvv86 ",         #yinhy131205
                   "   FROM ",cl_get_target_table(l_azp01,'rvv_file'),     #FUN-A50102
                   "  WHERE rvv01 = '",g_apb.apb21,"'",
                   "    AND rvv02 = '",g_apb.apb22,"'"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql           #FUN-A50102
       CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql   #FUN-A50102
       PREPARE sel_rvv_pre13 FROM g_sql
       EXECUTE sel_rvv_pre13 INTO g_apb.apb27,g_apb.apb28
       LET g_pmn401 = ''
       LET g_apb.apb26 = ''
       LET l_pmk13= ''

       LET g_sql = " SELECT ima39 ",
                   "   FROM ",cl_get_target_table(l_azp01,'ima_file'), #FUN-A50102
                   "  WHERE ima01 = '",g_apb.apb12,"'"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql            #FUN-A50102
       CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql    #FUN-A50102
       PREPARE sel_ima_pre14 FROM g_sql
       EXECUTE sel_ima_pre14 INTO g_apb.apb25
    ELSE
       LET g_sql = "SELECT pmn041,pmn86,pmn40,pmn401,pmn67,pmk13,pmn122,pmn96,pmn98,pmn24 ",
                 # "  FROM ",l_dbs CLIPPED,"pmn_file LEFT OUTER JOIN ",l_dbs CLIPPED,"pmk_file ", #FUN-A50102 mark
                   "  FROM ",cl_get_target_table(l_azp01,'pmn_file'),                             #FUN-A50102
                   " LEFT OUTER JOIN ",cl_get_target_table(l_azp01,'pmk_file'),                   #FUN-A50102
                   "                                      ON pmn_file.pmn24 = pmk_file.pmk01 ",
                   " WHERE pmn01='",g_apb.apb06,"' AND pmn02='",g_apb.apb07,"' "
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql          #FUN-A50102
       CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql  #FUN-A50102
       PREPARE sel_pmn_pre FROM g_sql
       EXECUTE sel_pmn_pre INTO g_apb.apb27,g_apb.apb28,g_apb.apb25,g_pmn401,
                                g_apb.apb26,l_pmk13,g_apb.apb35,g_apb.apb36,
                                g_apb.apb31,l_pmn24
    END IF
    #FUN-B50019 --end
 
    IF g_apb.apb12[1,4]='MISC' AND NOT cl_null(l_pmn24) THEN

     # LET g_sql = "SELECT pmk13 FROM ",l_dbs CLIPPED,"pmn_file  ",                                                    #FUN-A50102 mark
     #             "  LEFT OUTER JOIN ",l_dbs CLIPPED,"pmk_file ON pmn_file.pmn24 = pmk_file.pmk01",                   #FUN-A50102 mark
       LET g_sql = "SELECT pmk13 FROM ",cl_get_target_table(l_azp01,'pmn_file'),                                       #FUN-A50102
                   " LEFT OUTER JOIN ",cl_get_target_table(l_azp01,'pmk_file')," ON pmn_file.pmn24 = pmk_file.pmk01",  #FUN-A50102                 
                   " WHERE pmn01='",g_apb.apb06,"' AND pmn02='",g_apb.apb07,"' ",
                   "   AND pmn24='",l_pmn24,"' AND pmn24=pmk01 "
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql          #FUN-A50102
       CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql  #FUN-A50102    
       PREPARE sel_pmk13_pre FROM g_sql
       EXECUTE sel_pmk13_pre INTO g_apb.apb26
    END IF
 
    IF g_aza.aza63 = 'Y' THEN
       LET g_apb.apb251 = g_pmn401
    END IF
 
   IF g_apa.apa51 = 'STOCK' THEN
    # LET g_sql = "SELECT rvv32,rvv33 FROM ",l_dbs CLIPPED,"rvv_file ",                  #FUN-A50102 mark
      LET g_sql = "SELECT rvv31,rvv32,rvv33 FROM ",cl_get_target_table(l_azp01,'rvv_file'),    #FUN-A50102 #FUN-D60083 add rvv31
                  " WHERE rvv01 = '",g_apb.apb21,"' ",
                  "   AND rvv02 = '",g_apb.apb22,"' "    
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql           #FUN-A50102
      CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql   #FUN-A50102
      PREPARE sel_rvv32_pre FROM g_sql
      EXECUTE sel_rvv32_pre INTO l_rvv31,l_rvv32,l_rvv33  #FUN-D60083 add l_rvv31

      #FUN-D60083--add--str--
      SELECT count(*) INTO l_n FROM jce_file
          WHERE jce02 = l_rvv32
      #FUN-D60083--add--end--

      IF g_azw.azw04 = '2' AND (g_rvu21 = '2' OR g_rvu21 = '3') THEN   #若經營方式為代銷,則抓相應得代銷科目 
       # CALL p115_stock_act(g_apb.apb12,l_rvv32,l_rvv33,'0',l_dbs)    #FUN-A10011 add l_dbs      #FUN-A50102 mark
         #FUN-D60083--add--str--
         IF l_n > 0 THEN
            SELECT ima164 INTO g_apb.apb25 FROM ima_file
             WHERE ima01 = l_rvv31
            IF cl_null(g_apb.apb25) THEN
               CALL s_errmsg('',l_rvv31,'','aap-445',1)
               LET g_success = 'N'
            END IF
         ELSE
         #FUN-D60083--add--end--
            CALL p115_stock_act(g_apb.apb12,l_rvv32,l_rvv33,'0',l_azp01)  #FUN-A50102
                 RETURNING g_apb.apb25
         END IF   #FUN-D60083 add
         IF g_aza.aza63 = 'Y' THEN
          # CALL p115_stock_act(g_apb.apb12,l_rvv32,l_rvv33,'1',l_dbs) #FUN-A10011 add l_dbs      #FUN-A50102 mark
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
               CALL p115_stock_act(g_apb.apb12,l_rvv32,l_rvv33,'1',l_azp01)  #FUN-A50102
                    RETURNING g_apb.apb251
            END IF   #FUN-D60083 add
         END IF 
      ELSE
         #FUN-D60083--add--str--
         IF l_n > 0 THEN
            SELECT ima164 INTO g_apb.apb25 FROM ima_file
             WHERE ima01 = l_rvv31
            IF cl_null(g_apb.apb25) THEN
               CALL s_errmsg('',l_rvv31,'','aap-445',1)
               LET g_success = 'N'
            END IF
         ELSE
         #FUN-D60083--add--end--
            CALL t110_stock_act(g_apb.apb12,l_rvv32,l_rvv33,'0',l_azp01)   #FUN-9C0041 add "" #FUN-A10011 ""->l_azp01
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
               CALL t110_stock_act(g_apb.apb12,l_rvv32,l_rvv33,'1',l_azp01) #FUN-9C0041 add "" #FUN-A10011 ""->l_azp01
                    RETURNING g_apb.apb251
            END IF   #FUN-D60083 add
         END IF
      END IF    #FUN-9C0041 add
   END IF   
   SELECT aag05 INTO l_aag05 FROM aag_file
    WHERE aag01 = g_apb.apb25
      AND aag00 = g_bookno1
   IF l_aag05 = "Y" AND cl_null(g_apb.apb26) THEN
      LET g_apb.apb26 = g_apa.apa22
   END IF
 
   IF cl_null(g_apb.apb25) AND NOT cl_null(g_apb.apb31) THEN
     SELECT azf14,azf141 INTO g_apb.apb25,l_azf141     #FUN-B80058 add azf141
       FROM azf_file 
     WHERE azf01=g_apb.apb31 AND azf02='2' AND azfacti='Y' AND azf09 = '7'   #No.FUN-930104
     IF g_aza.aza63='Y' AND cl_null(g_apb.apb251) THEN
       #LET g_apb.apb251 = g_apb.apb25
       LET g_apb.apb251 = l_azf141     #FUN-B80058
     END IF
   END IF
    IF cl_null(g_apb.apb27) THEN     # 帶出品名,單位
     # LET g_sql = "SELECT ima02,ima25 FROM ",l_dbs CLIPPED,"ima_file ",                  #FUN-A50102 mark
       LET g_sql = "SELECT ima02,ima25 FROM ",cl_get_target_table(l_azp01,'ima_file'),    #FUN-A50102          
                   " WHERE ima01='",g_apb.apb12,"' "
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102
       CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql      #FUN-A50102
       PREPARE sel_ima02_pre FROM g_sql
       EXECUTE sel_ima02_pre INTO g_apb.apb27,g_apb.apb28
    END IF
 
    IF g_bgjob = 'N' THEN                       #FUN-570112
        DISPLAY "insert apb:",g_apb.apb01,' ',g_apb.apb02,' ',
                              g_apb.apb21,' ',g_apb.apb22,' ',g_apb.apb10 AT 3,1
    END IF  #NO.FUN-570112
    IF cl_null(g_apb.apb13f) THEN LET g_apb.apb13f = 0 END IF
    IF cl_null(g_apb.apb13)  THEN LET g_apb.apb13  = 0 END IF
    IF cl_null(g_apb.apb14f) THEN LET g_apb.apb14f = 0 END IF
    IF cl_null(g_apb.apb14)  THEN LET g_apb.apb14  = 0 END IF
    IF cl_null(g_apb.apb15)  THEN LET g_apb.apb15  = 0 END IF
    LET g_apb.apb34 = 'N'    #No.TQC-7B0083
    LET g_apb.apblegal = g_legal          #FUN-980001 add
    LET g_apb.apb37 = l_azp01              #FUN-A10011
  # LET g_apb.apb09 = s_digqty(g_apb.apb09,g_apb.apb28) #FUN-BB0084   #mark by lifang 180312
  # LET g_apb.apb15 = s_digqty(g_apb.apb15,g_apb.apb28) #FUN-BB0084   #mark by lifang 180312
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
       CALL cl_err3("ins","apb_file",g_apb.apb01,g_apb.apb02,SQLCA.sqlcode,"","p115_ins_apb(ckp#1):",1) #No.FUN-660122
       LET g_success = 'N'
    END IF
    LET g_apa.apa34f= g_apa.apa31f+ g_apa.apa32f
    LET g_apa.apa34 = g_apa.apa31 + g_apa.apa32
    CALL p115_comp_oox(g_apa.apa01) RETURNING g_net                                                                                 
    LET g_apa.apa73=g_apa.apa34-g_apa.apa35 + g_net    #A059                                                                        
    UPDATE apa_file SET apa31f=g_apa.apa31f,
                        apa32f=g_apa.apa32f,
                        apa34f=g_apa.apa34f,
                        apa60f=g_apa.apa60f,
                        apa61f=g_apa.apa61f,
                        apa31=g_apa.apa31 ,
                        apa32=g_apa.apa32 ,
                        apa34=g_apa.apa34, 
                        apa73=g_apa.apa73,           #A059
                        apa60=g_apa.apa60 ,
                        apa61=g_apa.apa61 ,
                        apa56=g_apa.apa56
     WHERE apa01 = g_apa.apa01
    IF STATUS THEN 
    CALL cl_err3("upd","apa_file",g_apa.apa01,"",STATUS,"","upd apa:",0) #No.FUN-660122
    LET g_success='N' END IF
 

    #rvv23是發票數量,rvv88為暫估數量,立暫估時與發票數量無關,僅會增加rvv88數量
   #LET g_sql = "UPDATE ",l_dbs CLIPPED," rvv_file SET rvv40 = ?, rvv88 = (rvv88 + ?) ",  #FUN-A10011     #FUN-A50102 mark
    LET g_sql = "UPDATE ",cl_get_target_table(l_azp01,'rvv_file'),                        #FUN-A50102
                " SET rvv40 = ?, rvv88 = (rvv88 + ?) ",                                   #FUN-A50102  
                " WHERE rvv01 = ? AND rvv02 = ?"
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
    CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql     #FUN-A50102                         
    PREPARE p115_ins_apb_p FROM g_sql
    EXECUTE p115_ins_apb_p USING 'Y',g_apb.apb09,g_apb.apb21,g_apb.apb22  #No.TQC-7B0083
    IF STATUS THEN
       CALL cl_err('p115_ins_apb(ckp#2):',STATUS,1) LET g_success = 'N'
    END IF
    #FUN-B50019 --begin
    IF NOT cl_null(g_apb.apb04) AND NOT cl_null(g_apb.apb05) THEN
       CALL p115_upd_rvb06()
    END IF
    #FUN-B50019 --end
END FUNCTION
 
 
FUNCTION p115_apa15()
    DEFINE l_gec06    LIKE gec_file.gec06,
           l_gec05    LIKE gec_file.gec05, #No.TQC-7B0078
           l_gec08    LIKE gec_file.gec08,
           l_gecacti  LIKE gec_file.gecacti
 
    LET g_errno = ' '
    SELECT gec04,gec05,gec06,gec08,gecacti INTO g_gec04,l_gec05,l_gec06,l_gec08,l_gecacti FROM gec_file   #No:8946 #No.TQC-7B0078 add gec05
     WHERE gec01 = g_apa.apa15 AND gec011='1'
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg3044'
         WHEN l_gec05   !='X' OR                           #No.TQC-7B0078
              cl_null(l_gec05)    LET g_errno = 'aap-977'  #No.TQC-7B0078
         WHEN l_gec06   !='2'     LET g_errno = 'aap-008'
         WHEN l_gec08   !='XX'    LET g_errno = 'aap-008'
         WHEN l_gecacti  ='N'     LET g_errno = '9028'
         OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-----'
    END CASE
    LET g_apa.apa16=g_gec04
    IF g_bgjob = 'N' THEN                       #FUN-570112
        DISPLAY BY NAME g_apa.apa16
    END IF   #FUN-570112 
END FUNCTION
 
#CHI-A90002 add --start--
FUNCTION p115_apa05(p_cmd)
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

FUNCTION p115_apa36()
    DEFINE l_apr02 LIKE apr_file.apr02
    DEFINE l_aps   RECORD LIKE aps_file.*
    DEFINE l_depno     LIKE apa_file.apa22    #FUN-660117 
    DEFINE l_d_actno   LIKE apt_file.apt03    #FUN-660117
    DEFINE l_c_actno   LIKE apt_file.apt04    #FUN-660117
    DEFINE l_e_actno   LIKE apa_file.apa511   #No.FUN-680029
    DEFINE l_f_actno   LIKE apa_file.apa541   #No.FUN-680029
 
    LET g_errno = ' '
    SELECT apr02 INTO l_apr02 FROM apr_file WHERE apr01 = g_apa.apa36
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-044'
         WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
    END CASE
    IF NOT cl_null(g_errno) THEN LET l_apr02 = '' END IF
    IF g_bgjob = 'N' THEN                       #FUN-570112
        DISPLAY l_apr02 TO apr02
    END IF   #FUN-570112 
    IF g_apz.apz13 = 'Y'
       THEN LET l_depno = g_apa.apa22
       ELSE LET l_depno = ' '
    END IF
    IF g_apz.apz13 = 'Y' THEN  #No.TQC-770051
       SELECT * INTO l_aps.* FROM aps_file WHERE aps01 = l_depno
       IF SQLCA.sqlcode THEN 
       CALL cl_err3("sel","aps_file",l_depno,"","aap-053","","",1) #No.FUN-660122
       RETURN END IF
    END IF    #No.TQC-770051
 
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
 
FUNCTION p115_apa21()
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
    IF g_bgjob = 'N' THEN                       #FUN-570112
        DISPLAY BY NAME g_apa.apa22
    END IF   #FUN-570112  
END FUNCTION
 
FUNCTION p115_apa211()
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
    IF g_bgjob = 'N' THEN                       #FUN-570112
        DISPLAY BY NAME g_apa.apa22
    END IF        #FUN-570112 
END FUNCTION
   
FUNCTION p115_apa22()
    DEFINE l_gemacti LIKE gem_file.gemacti
    DEFINE l_depno   LIKE aps_file.aps01      #FUN-CB0056
 
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
   # WHERE aps01 = l_depno
   #IF NOT cl_null(g_apa.apa15) THEN
   #   SELECT gec04 INTO g_apa.apa16 FROM gec_file
   #    WHERE gec01= g_apa.apa15 AND gec011 = '1'
   #END IF
   #DISPLAY BY NAME g_apa.apa15,g_apa.apa16
   ##FUN-CB0056--add--end
   #No.FUN-D40003 ---start--- Mark
END FUNCTION
 
FUNCTION p115_upd_rvb06()
DEFINE l_qty LIKE apb_file.apb09

    # LET g_sql = "SELECT SUM(rvv23+rvv88) FROM ",l_dbs CLIPPED,"rvv_file ",                #FUN-A50102 mark
      LET g_sql = "SELECT SUM(rvv23+rvv88) FROM ",cl_get_target_table(l_azp01,'rvv_file'),  #FUN-A50102
                  " WHERE rvv04 = '",g_apb.apb04,"' ",
                  "   AND rvv05 = '",g_apb.apb05,"' ",
                  "   AND rvv03 = '1'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql               #FUN-A50102
      CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql       #FUN-A50102
      PREPARE sel_sum_rvv23 FROM g_sql
      EXECUTE sel_sum_rvv23 INTO l_qty
      IF STATUS THEN
         LET g_showmsg = g_apb.apb04,"/",g_apb.apb05
         IF g_bgerr THEN 
            CALL s_errmsg('rvv04,rvv05',g_showmsg,'',STATUS,1)
         ELSE
            CALL cl_err(g_showmsg,STATUS,1)
         END IF
      END IF
      IF cl_null(l_qty) THEN LET l_qty = 0 END IF
 
    # LET g_sql = "UPDATE ",l_dbs CLIPPED,"rvb_file SET rvb06 = '",l_qty,"' ",                    #FUN-A50102 mark
      LET g_sql = "UPDATE ",cl_get_target_table(l_azp01,'rvb_file')," SET rvb06 = '",l_qty,"' ",  #FUN-A50102 
                  " WHERE rvb01 = '",g_apb.apb04,"' AND rvb02 = '",g_apb.apb05,"' "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql            #FUN-A50102
      CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql    #FUN-A50102 
      PREPARE upd_rvb06_pre FROM g_sql
      EXECUTE upd_rvb06_pre      
      IF STATUS THEN 
      CALL cl_err3("upd","rvb_file",g_apb.apb04,g_apb.apb05,STATUS,"","upd rvb06:",1) #No.FUN-660122
      LET g_success='N' END IF
END FUNCTION

#CHI-A40012---mark---start---  #將此段判斷改由FOREACH p115_cs做處理
#FUNCTION p115_chkdate()
#    DEFINE l_sql         VARCHAR(1500)
#    DEFINE l_yy,l_mm     LIKE type_file.num5    #No.FUN-690028 SMALLINT
#
#    LET l_sql=" SELECT UNIQUE YEAR(rvv09),MONTH(rvv09) ",
#              "  FROM ",l_dbs CLIPPED,"rvv_file LEFT OUTER JOIN ",l_dbs CLIPPED,"ima_file ",
#              "                                 ON rvv_file.rvv31 = ima_file.ima01",
#              "                                 LEFT OUTER JOIN ",l_dbs CLIPPED,"pmc_file ",
#              "                                 ON rvv_file.rvv06 = pmc_file.pmc01,",
#                        l_dbs CLIPPED,"rvu_file,",l_dbs CLIPPED,"rva_file,",l_dbs CLIPPED,"pmn_file,",
#                        l_dbs CLIPPED,"rvb_file LEFT OUTER JOIN ",l_dbs CLIPPED,"rvw_file ",
#              "                                 ON rvb_file.rvb22 = rvw_file.rvw01, ",
#                        l_dbs CLIPPED,"pmm_file LEFT OUTER JOIN ",l_dbs CLIPPED,"gen_file ",
#              "                                 ON pmm_file.pmm12 = gen_file.gen01 ",
#              "                                 LEFT OUTER JOIN ",l_dbs CLIPPED,"gec_file ",
#              "                                 ON pmm_file.pmm21 = gec_file.gec01 AND gec011='1' ",
#              "                                 LEFT OUTER JOIN ",l_dbs CLIPPED,"azi_file ",
#              "                                 ON pmm_file.pmm22 = azi_file.azi01 ",
#              " WHERE ",g_wc CLIPPED,
#              "   AND ( YEAR(rvv09) != YEAR('",g_apa02,"') ",
#              "    OR  (YEAR(rvv09)  = YEAR('",g_apa02,"') ",
#              "   AND   MONTH(rvv09)!= MONTH('",g_apa02,"'))) ",
#              "   AND rvv03 ='1' ",
#              "   AND (rvb22 IS NULL OR rvb22 = ' ') ",
#              "   AND rvv87-rvv23-rvv88 > 0 ",   #FUN-560070  #No.TQC-7B0083               #MOD-8C0146
#              "   AND rvv04 = rvb01 AND rvv05 = rvb02",
#              "   AND rvv04 = rva01 ",
#              "   AND rvv36 = pmm01",
#              "   AND (pmm25='2' OR pmm25 = '6')",
#              "   AND rvv36 = pmn01 AND rvv37 = pmn02",
#              "   AND pmm21 = gec_file.gec01 AND gec011='1'",    #
#              "   AND rvaconf='Y' ",
#              "   AND rvu01 = rvv01 AND rvuconf='Y' "
#
#   PREPARE p115_prechk FROM l_sql
#   IF STATUS THEN CALL cl_err('Prepare chkdate: ',STATUS,1) 
#      LET l_flag='X' RETURN 
#   END IF
#   DECLARE p115_chkdate CURSOR WITH HOLD FOR p115_prechk
#   FOREACH p115_chkdate INTO l_yy,l_mm
#     IF STATUS THEN CALL cl_err('foreach chkdate: ',STATUS,1) 
#         LET l_flag='X' EXIT FOREACH
#     END IF
#     LET l_flag='Y' EXIT FOREACH
#   END FOREACH
#
#END FUNCTION
#CHI-A40012---mark---end---
 
FUNCTION p115_comp_oox(p_apv03)                                                                                                     
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
 
FUNCTION p115_ins_apc()                                                                                                     
  DEFINE l_apa   RECORD LIKE apa_file.*
 
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
    LET g_apc.apc10 = 0
    LET g_apc.apc11 = 0
    LET g_apc.apc12 = l_apa.apa08
    LET g_apc.apc13 = l_apa.apa73
    LET g_apc.apc14 = 0
    LET g_apc.apc15 = 0
    LET g_apc.apc16 = 0
    #No.MOD-B80123  --Begin
    #LET g_apc.apc08 = cl_digcut(g_apc.apc08,t_azi04)
    SELECT azi04 INTO t_azi.azi04 FROM azi_file 
       WHERE azi01=g_apa.apa13 
    LET g_apc.apc08 = cl_digcut(g_apc.apc08,t_azi.azi04)
    #No.MOD-B80123  --End
    LET g_apc.apc08 = cl_digcut(g_apc.apc08,t_azi04)
    LET g_apc.apc09 = cl_digcut(g_apc.apc09,g_azi04)
    #LET g_apc.apc13 = cl_digcut(g_apc.apc09,g_azi04)  #MOD-B80123 mark
    LET g_apc.apc13 = cl_digcut(g_apc.apc13,g_azi04)   #MOD-B80123
    #LET g_apc.apcplant = g_apa.apaplant   #FUN-960141   #FUN-960141 090824 mark
    LET g_apc.apclegal = g_legal          #FUN-980001 add
    INSERT INTO apc_file VALUES(g_apc.*)
    IF STATUS THEN
       IF g_bgerr THEN 
          CALL s_errmsg('apc01',g_apc.apc01,'',SQLCA.sqlcode,1)
       ELSE
          CALL cl_err3("ins","apc_file",g_apc.apc01,"",SQLCA.sqlcode,"","",1)
       END IF
       LET g_success = 'N'
    END IF
END FUNCTION
 
#FUNCTION p115_stock_act(p_item,p_ware,p_loc,p_npptype,m_dbs)   #FUN-A10011 add m_dbs   #FUN-A50102 mark
FUNCTION p115_stock_act(p_item,p_ware,p_loc,p_npptype,p_plant)  #FUN-A50102 
  DEFINE p_item    LIKE ima_file.ima01                                                                                              
  DEFINE p_ware    LIKE ime_file.ime01                                                                                              
  DEFINE p_loc     LIKE ime_file.ime02                                                                                              
  DEFINE l_actno   LIKE aag_file.aag01                                                                                              
  DEFINE p_npptype LIKE npp_file.npptype 
  DEFINE m_dbs     LIKE type_file.chr21    #FUN-A10011  
  DEFINE p_plant   LIKE azp_file.azp01     #FUN-A50102

  SELECT ccz07 INTO g_ccz07 FROM ccz_file WHERE ccz00='0'                                                                        
                                                                                                                                    
     CASE WHEN g_ccz07='1' IF p_npptype = '0' THEN  
                            # LET g_sql = "SELECT ima149 FROM ",m_dbs CLIPPED,"ima_file",                   #FUN-A50102 mark
                              LET g_sql = "SELECT ima149 FROM ",cl_get_target_table(p_plant,'ima_file'),    #FUN-A50102  
                                          " WHERE ima01='",p_item,"' "
                              CALL cl_replace_sqldb(g_sql) RETURNING g_sql                #FUN-A50102
                              CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql        #FUN-A50102    
                              PREPARE sel_ima149_pre FROM g_sql
                              EXECUTE sel_ima149_pre INTO l_actno
                           ELSE                                                                                                     
                             #LET g_sql = "SELECT ima1491 FROM ",m_dbs CLIPPED,"ima_file",                  #FUN-A50102 mark
                              LET g_sql = "SELECT ima1491 FROM ",cl_get_target_table(p_plant,'ima_file'),   #FUN-A50102   
                                          " WHERE ima01='",p_item,"'"
                              CALL cl_replace_sqldb(g_sql) RETURNING g_sql                #FUN-A50102
                              CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql        #FUN-A50102  
                              PREPARE sel_ima1491_pre FROM g_sql
                              EXECUTE sel_ima1491_pre INTO l_actno
                           END IF                                                                                                   
          WHEN g_ccz07='2' IF p_npptype = '0' THEN  
                              LET g_sql= "SELECT imz73 FROM ",
                                        #  m_dbs CLIPPED,"ima_file,",m_dbs CLIPPED,"imz_file",              #FUN-A50102 mark
                                           cl_get_target_table(p_plant,'ima_file'),",",   #FUN-A50102
                                           cl_get_target_table(p_plant,'imz_file'),       #FUN-A50102 
                                         " WHERE ima01='",p_item,"' ",
                                         "   AND ima06=imz01"
                              CALL cl_replace_sqldb(g_sql) RETURNING g_sql                #FUN-A50102
                              CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql        #FUN-A50102 
                              PREPARE sel_imz73_pre FROM g_sql
                              EXECUTE sel_imz73_pre INTO l_actno
                           ELSE                                                                                                     
                              LET g_sql = "SELECT imz731 FROM ",
                                        #   m_dbs CLIPPED,"ima_file,",m_dbs CLIPPED,"imz_file",             #FUN-A50102 mark
                                            cl_get_target_table(p_plant,'ima_file'),",",  #FUN-A50102
                                            cl_get_target_table(p_plant,'imz_file'),      #FUN-A50102
                                          " WHERE ima01='",p_item,"' AND ima06=imz01"
                              CALL cl_replace_sqldb(g_sql) RETURNING g_sql                #FUN-A50102
                              CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql        #FUN-A50102  
                              PREPARE sel_imz731_pre FROM g_sql
                              EXECUTE sel_imz731_pre INTO l_actno
                           END IF
          WHEN g_ccz07='3' IF p_npptype = '0' THEN 
                            # LET g_sql = "SELECT imd21 FROM ",m_dbs CLIPPED,"imd_file ",                  #FUN-A50102 mark
                              LET g_sql = "SELECT imd21 FROM ",cl_get_target_table(p_plant,'imd_file'),    #FUN-A50102    
                                          " WHERE imd01='",p_ware,"' "
                              CALL cl_replace_sqldb(g_sql) RETURNING g_sql               #FUN-A50102
                              CALL  cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql      #FUN-A50102 
                              PREPARE sel_imd21_pre FROM g_sql
                              EXECUTE sel_imd21_pre INTO l_actno
                           ELSE                                                                                                     
                             #LET g_sql ="SELECT imd211 FROM ",m_dbs CLIPPED,"imd_file ",                  #FUN-A50102 mark
                              LET g_sql ="SELECT imd211 FROM ",cl_get_target_table(p_plant,'imd_file'),    #FUN-A50102 
                                         " WHERE imd01='",p_ware,"' "   
                              CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102
                              CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql      #FUN-A50102
                              PREPARE sel_imd211_pre FROM g_sql
                              EXECUTE sel_imd211_pre INTO l_actno
                           END IF                                                                                                   
          WHEN g_ccz07='4' IF p_npptype = '0' THEN
                            # LET g_sql = "SELECT ime13 FROM ",m_dbs CLIPPED,"ime_file ",                  #FUN-A50102 mark
                              LET g_sql = "SELECT ime13 FROM ",cl_get_target_table(p_plant,'ime_file'),    #FUN-A50102 
                                          " WHERE ime01='",p_ware,"' ",
                                          "   AND ime02='",p_loc,"'"       
                              CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102
                              CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql      #FUN-A50102  
                              PREPARE sel_ime13_pre FROM g_sql
                              EXECUTE sel_ime13_pre INTO l_actno
                           ELSE                                                                                                     
                             #LET g_sql = "SELECT ime131 FROM ",m_dbs CLIPPED,"ime_file ",                 #FUN-A50102 mark
                              LET g_sql = "SELECT ime131 FROM ",cl_get_target_table(p_plant,'ime_file'),   #FUN-A50102  
                                          " WHERE ime01='",p_ware,"' ",
                                          "   AND ime02='",p_loc,"'"
                              CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102 
                              CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql      #FUN-A50102  
                              PREPARE sel_ime131_pre FROM g_sql
                              EXECUTE sel_ime131_pre INTO l_actno
                           END IF                                                                                                   
     END CASE 
     RETURN l_actno 
END FUNCTION
#FUN-9C0077
#TQC-AC0288
#FUN-A70139
