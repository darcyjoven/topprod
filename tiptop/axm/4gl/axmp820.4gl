# Prog. Version..: '5.30.06-13.04.17(00010)'     #
#
# Pattern name...: axmp820.4gl
# Descriptions...: 三角貿易出貨單拋轉作業
# Date & Author..: 98/12/08 By Linda
# Modify.........: 00/01/13 By Kammy Insert 1.驗收單       2.入庫單
#                                           3.Packing List 4.Invoice
# Modify.........: No.7742 03/08/07 Kammy 1.備品資料不回寫訂單已出貨量
#                                         2.若為備品資料金額單價皆為零
# Modify.........: No.7993 03/08/31 Kammy 1.流程抓取方式修改(poz_file,poy_file)
#                                         2.拋轉各單號多工廠重新取號
#                                         3.回寫oga99多角序號
#                                         4.正拋時改可扣大陸庫存
#                                         5.INVOICE 與 出貨通知單
# Modify.........: No.9598 04/07/02 ching INVOICE拋轉未做取位
# Modify.........: No.MOD-4B0148 04/11/15 ching tlf11,tlf12 單位錯誤
# Modify.........: No.FUN-4C0006 04/12/03 By Carol 單價/金額欄位放大(20),位數改為dec(20,6)
# Modify.........: No.MOD-520122 05/03/03 By ching tlf19修正
# Modify.........: No.MOD-530005 05/03/03 By ching UPDATE pmn修正
# Modify.........: No.FUN-550018 05/05/09 By ice 發票號碼加大到16位
# Modify.........: No.FUN-550070 05/05/26 By Will 單據編號放大
# Modify.........: NO.FUN-560043 05/06/22 By Smapmin 根據雙單位做調整,多角序號放大,單號放大
# Modify.........: NO.FUN-620024 06/02/15 By Rayven 增加拋轉時有代送銷退單產生
# Modify.........: No.MOD-630019 06/04/06 第1185行LET l_ogb.ogb091= l_oeb.oeb092應該是l_ogb.ogb092
# Modify.........: NO.TQC-640078 06/04/08 BY yiting 產生收貨單不成功 
# Modify.........: NO.FUN-640167 06/04/18 BY yiting 出貨或入庫扣帳拋單時，中間廠都會詢問"這是新的倉儲批，是否新增? -->不用問，直接產生 
# Modify.........: NO.TQC-650089 06/05/24 BY elva 選取出貨單時過濾掉返利的單子
# Modify.........: No.FUN-660167 06/06/23 By Ray cl_err --> cl_err3
# Modify.........: No.MOD-660122 06/06/30 By Rayven 當ima25與img09的單位一樣時，imgg21及imgg211所存的轉換率，也應該要一樣
# Modify.........: NO.FUN-670007 06/07/27 BY yiting 1.oaz32->oax01,oaz08->oax03,oaz204->oax05,oaz203->oax04
#                                                   2.因出通單確認時，會去CHECK PACKING/INVOICE來源為出貨/出通單，如為出通單則己直接拋轉，
#                                                     所以此處不再做拋轉動作
# Modify.........: No.MOD-680058 06/08/18 By day 增加對ohb1005的預設
# Modify.........: NO.FUN-660068 06/07/13 by yiting 單頭科目別要一同拋轉到各區出貨單
# Modify.........: NO.FUN-670007 06/08/30 by Yiting 三角改善專案 1.拋轉時不再拋出通單，己新增axmp821出通單拋轉程式
#                                                   2.拋轉時應抓取設立的站別資料(單別/倉庫別)
#                                                   3.抓取該站的訂單/採購 成本中心              
# Modify.........: No.FUN-680137 06/09/08 By ice 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0094 06/11/03 By yjkhero l_time轉g_time 
# Modify.........: NO.TQC-690057 06/11/15 BY Claire img_file值要取自imd_file
# Modify.........: No.FUN-6B0065 06/11/21 By Ray atmi217并入aooi313(azf09,10,11,12,13取代tqe03,04,05,11,08)
# Modify.........: NO.TQC-6A0084 06/12/05 By Nicola 含稅金額、未稅金額調整
# Modify.........: NO.MOD-6A0046 06/12/11 BY Claire FUN-620024造成未回寫數量
# Modify.........: NO.MOD-6C0086 06/12/14 BY Claire 語法調整
# Modify.........: No.FUN-710046 07/01/24 By hellen 錯誤訊息匯總顯示修改
# Modify.........: NO.FUN-6B0064 07/02/02 BY rainy 沒資料時要秀訊息,不可顯示執行成功
# Modify.........: NO.TQC-740105 07/04/28 BY yiting rvb87位置錯誤，造成後端rvv39取不到值
# Modify.........: NO.TQC-750243 07/06/06 BY yiting ofa011拋轉時，寫入錯誤
# Modify.........: NO.TQC-760054 07/06/06 By xufeng azf_file的index是azf_01(azf01,azf02),但是在抓‘中文說明’內容時，WHERE條件卻只有 azf01 = g_xxx
# Modify.........: No.CHI-770019 07/07/26 By Carrier 多單位:參考單位時,交易單位不寫入tlff
# Modify.........: NO.TQC-760146 07/08/09 BY Claire 拋出後的出通單沒有回寫出貨單號
# Modify.........: No.TQC-750014 07/08/15 By pengu 庫存轉換率異常
# Modify.........: No.MOD-770131 07/08/24 By Claire 重取訂單流程序號再重新取得各站訂單號碼
# Modify.........: NO.MOD-780191 07/08/29 BY yiting 拋轉時應檢核單別設定資料是否齊全
# Modify.........: NO.FUN-780025 07/08/31 BY yiting 拋轉出貨單時應一併拋轉ogbb_file
# Modify.........: No.MOD-780264 07/08/31 By Claire 未回寫呆滯日期 
# MOdify.........: No.CHI-790001 07/09/02 By Nicole 修正Insert Into Error
# Modify.........: NO.TQC-790003 07/09/03 BY yiting insert into前給予預設值
# Modify.........: No.MOD-7A0051 07/10/09 By Claire Invoice單身應以(計價數量*單價)而非(數量*單價)
# Modify.........: No.MOD-7A0156 07/10/25 By Claire oga30,oga903,ogamksg拋至下站時,要給來源站的值
# Modify.........: No.FUN-7B0091 07/11/19 By Sarah oga65預設值抓oea65
# Modify.........: No.TQC-7B0083 07/11/22 By Carrier rvv88給預設值
# Modify.........: No.TQC-7C0064 07/12/08 By Beryl 判斷單別在拋轉資料庫是否存在，如果不存在，則報錯，批處理運行不成功．提示user單據別無效或不存在其資料庫中
# Modify.........: NO.MOD-810014 08/01/03 BY Claire 回寫數量條件錯誤
# Modify.........: No.FUN-7B0018 08/01/31 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.MOD-810179 08/03/18 By claire 對img09要重計轉換率(ogb15_fac,rvv35_fac)
# Modify.........: No.FUN-850100 08/05/19 By Nicola 批/序號管理第二階段
# Modify.........: No.FUN-850145 08/05/27 By hellen 去掉行業別相關標識，不拆分成.src文件
# Modify.........: No.MOD-880139 08/08/20 By claire tlf036判斷給值錯誤,會造成拋轉還原時,無法delete tlf_file
# Modify.........: No.FUN-8A0086 08/10/21 By lutingting完善錯誤訊息匯總
# Modify.........: No.MOD-910027 09/01/05 By claire FUN-850145程式再調整
# Modify.........: No.MOD-8C0228 08/12/23 By claire 取收貨/入庫單別的調整
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.MOD-920261 09/02/20 By claire ogb930值應以原訂單資料為來源
# Modify.........: No.TQC-930155 09/04/08 By Sunyanchun 加報錯信息
# Modify.........: No.MOD-940299 09/05/07 By Dido 科目別改用多角流程設定
# Modify.........: No.FUN-940083 09/05/18 By zhaijie調整批處理賦值
# Modify.........: No.CHI-960012 09/06/10 By Dido 出貨理由碼抓取原理由碼
# Modify.........: No.MOD-970169 09/07/20 By Dido 抓取收貨入庫單別邏輯調整
# Modify.........: No.MOD-980058 09/08/10 By Dido tlf111 日期傳遞錯誤
# Modify.........: No.FUN-980081 09/08/19 By destiny 修改傳到s_mupimg里的參數
# Modify.........: No.FUN-980010 09/08/28 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980020 09/09/01 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980059 09/09/09 By arman GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-980092 09/09/21 By TSD.sar2436  GP5.2 跨資料庫語法修改
# Modify.........: No.MOD-990233 09/09/28 By Dido 多角庫存過帳後更新訂單 oeb23,oeb24,oeb29 問題   
# Modify.........: No.CHI-950020 09/10/20 By chenmoyan 将自定义栏位的值抛转各站
# Modify.........: No:TQC-9A0133 09/10/26 By Dido 各站出貨單的出通單號抓取有誤   
# Modify.........: No.MOD-9A0138 09/10/26 By Dido 增加更新訂單對應多張出通直接取此出貨之出通單 
# Modify.........: No.CHI-9B0008 09/11/11 By Dido 增加拋轉 tlf930
# Modify.........: No:TQC-9B0013 09/11/27 By Dido 單別於建檔刪除後,應控卡不可產生拋轉
# Modify.........: No:TQC-9C0120 09/12/15 By Sarah 修正CHI-9B0008的錯字
# Modify.........: No:TQC-9C0119 09/12/15 By jan 修正SQL語句
# Modify.........: No:FUN-9C0071 10/01/11 By huangrh 精簡程式
# Modify.........: No.FUN-A10036 10/01/13 By baofei 手動修改INSERT INTO xxx_file ，增加xxx_file xxxoriu, xxxorig這二個欄位 
# Modify.........: No:CHI-9C0037 10/01/14 By Dido 取消第一站新增 tlf_file,已於出貨庫存扣帳產生 
# Modify.........: No:CHI-940042 10/01/19 By Dido 參考 oea18 設定出貨與invoice匯率 
# Modify.........: No.CHI-990031 10/01/28 By shiwuying 增加rvbs13這一字段
# Modify.........: No:CHI-A10031 10/01/28 By Dido 來源站產生入庫時需更新 img10,imgg10 
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26*
# Modify.........: No.TQC-A50131 10/05/24 By houlia 目前最大只能到16碼，導致編入plant code的單號無法插入，pab_no 字段修改為LIKE oga_file.oga01到varchar(20)的大小；出貨單號增加開窗查詢
# Modify.........: No.FUN-A50102 10/06/12 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:MOD-A60145 10/07/30 By Smapmin 修正prepare id 
# Modify.........: No:MOD-A60153 10/07/30 By Smapmin 出貨單過帳後才能拋轉出貨單到各站
# Modify.........: No:MOD-A60181 10/07/30 By Smapmin 同一站別的出入庫別要一致
# Modify.........: No:MOD-A90029 10/09/13 By Smapmin 出貨單拋轉時,若單別為不產生帳款,則相對的入庫單樣品否要打勾.
# Modify.........: No.FUN-AB0061 10/11/16 By chenying 銷退單加基礎單價字段ohb37
# Modify.........: No.FUN-AB0061 10/11/17 By shenyang 出貨單加基礎單價字段ogb37
# Modify.........: No.FUN-AB0096 10/11/25 By vealxu 因新增ogb50,ohb71的not null欄位,所導致其他作業無法insert into資料的問題修正
# Modify.........: No.FUN-AC0055 10/12/21 By suncx 取消預設ohb71值，新增oha55欄位預設值
# Modify.........: No.FUN-AC0055 10/12/21 By wangxin oga57,ogb50欄位預設值修正
# Modify.........: No.MOD-B30267 11/03/12 By chenying invoice取價時，單別改抓poy48;
#                                                     ins ofb時，出現-201         
# Modify.........: No.MOD-B30584 11/03/11 By chenying 填充收貨檔時，rvb90應給原採購單位 
# Modify.........: No.FUN-AB0023 11/03/17 By Lilan EF整合功能(EasyFlow) 
# Modify.........: No:TQC-B60065 11/06/16 By shiwuying 增加虛擬類型rvu27
# Modify.........: No:FUN-B70074 11/07/20 By fengrui 添加行業別表的新增於刪除
# Modify.........: No:MOD-B70254 11/08/29 By Summer 在來源站輸入出貨單axmt820扣帳後會自動拋轉axmp820，來源站的訂單已交量數量會變成double
# Modify.........: No:FUN-B90012 11/09/15 By lixh1 多角增加ICD行業
# Modify.........: No:TQC-B90240 11/09/29 By lixh1 修正跨庫時營運中心傳參問題
# Modify.........: No.FUN-BA0051 11/11/09 By jason 一批號多DATECODE功能
# Modify.........: No.FUN-BB0084 11/11/24 By lixh1 增加數量欄位小數取位
# Modify.........: No:FUN-BB0083 11/12/01 By xujing 增加數量欄位小數取位
# Modify.........: No.FUN-BB0001 12/01/11 By pauline 新增rvv22,INSERT/UPDATE rvb22時,同時INSERT/UPDATE rvv22          
# Modify.........: No.TQC-C30052 12/03/02 By Sakura 比照21區增加LET l_rvb.rvb31 = 0 預設值
# Modify.........: No:MOD-C30663 12/03/14 By ck2yuan tlfs07單位應寫img09
# Modify.........: No.CHI-C40031 12/05/24 By Sakura 走多倉出貨改為抓取ogc、ogg轉換率,若為多倉儲時,rvbs022 應累增
# Modify.........: No:FUN-C50097 12/06/13 By SunLM  對非空字段進行判斷ogb50,51,52       
# Modify.........: No.FUN-C50136 12/08/09 By xianghui 多角訂單拋磚時，如果已確認則需進行對oib_file和oic_file的插入與更新
# Modify.........: No.CHI-C80009 12/08/15 By Sakura 一批號多DATECODE功能時,FOREACH需多傳倉儲批;修正CALL icd_ida參數值
# Modify.........: No.CHI-C80042 12/08/30 By Vampire 多角入/出庫,正逆拋都要更新 ima73, ima74, ima29
# Modify.........: No.FUN-C80001 12/08/31 By bart 多角拋轉時，批號需一併拋轉sma96 1.多倉儲 2.雙單位 3.ICD 4.批序號
# Modify.........: No.FUN-CB0087 12/12/20 By xianghui 庫存理由碼改善
# Modify.........: No:MOD-CC0289 12/12/31 By SunLM 插入tlfcost时候,根据ccz28参数(成本计算方式)
# Modify.........: No:MOD-CC0242 13/01/31 By jt_chen 來源站訂單於出貨扣帳已有更新oea62,axmp820不需要再累加更新一次,故mark掉s_oea62的程式段
# Modify.........: No.MOD-C80064 13/02/04 By Elise rvb88及rvb88t需做取位
# Modify.........: No.TQC-D20042 13/02/25 By xianghui 理由碼調整
# Modify.........: No.TQC-D20047 13/02/27 By xianghui 理由碼調整
# Modify.........: No.TQC-D20067 13/02/28 By xujing   理由碼調整
# Modify.........: No.TQC-D30004 13/03/01 By xianghui 更改營運中心的變量
# Modify.........: No:FUN-BC0062 13/03/08 By lixh1 當成本計算方式ccz28選擇'6'，過帳還原時控制不可過帳還原
# Modify.........: No:FUN-D10007 13/03/12 By Sakura 銷售正拋加上axms070,oax03重新取價判斷
# Modify.........: No:MOD-C40162 13/03/13 By Elise 當ogaconf='Y',oga55要為1
# Modify.........: No.FUN-CC0157 13/03/20 By zm tlf920赋值(配合发出商品修改)
# Modify.........: No:FUN-D30099 13/03/29 By Elise 將asms230的sma96搬到apms010,欄位改為pod08
# Modify.........: No:FUN-D20062 13/04/02 By jt_chen 季會決議：
#                                                    1.有效期限一併拋轉，已經存在的img有效期限就update
#                                                    2.不能BY流程，維持用參數決定
#                                                    3.用參數pod08決定是否update img18有效期限
# Modify.........: No.TQC-D40097 13/05/23 By SunLM 尾差調整
# Modify.........: No.TQC-D40064 13/06/19 By fengrui  理由碼調整

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_oea   RECORD LIKE oea_file.*
DEFINE g_oeb   RECORD LIKE oeb_file.*
DEFINE g_oga   RECORD LIKE oga_file.*    #出貨單(來源)
DEFINE g_ogb   RECORD LIKE ogb_file.*    #出貨單(來源)
DEFINE l_oga   RECORD LIKE oga_file.*    #出貨單(各廠)
DEFINE l_ogb   RECORD LIKE ogb_file.*    #出貨單(各廠)
DEFINE t_oga   RECORD LIKE oga_file.*    #出貨通知單(來源)
DEFINE t_ogb   RECORD LIKE ogb_file.*    #出貨通知單(來源)
DEFINE x_oga   RECORD LIKE oga_file.*    #出貨通知單(各廠)
DEFINE x_ogb   RECORD LIKE ogb_file.*    #出貨通知單(各廠)
DEFINE g_ogd   RECORD LIKE ogd_file.*
DEFINE g_ofa   RECORD LIKE ofa_file.*
DEFINE g_ofb   RECORD LIKE ofb_file.*
DEFINE l_oea   RECORD LIKE oea_file.*
DEFINE l_oeb   RECORD LIKE oeb_file.*
DEFINE l_rva   RECORD LIKE rva_file.*
DEFINE l_rvb   RECORD LIKE rvb_file.*
DEFINE l_rvu   RECORD LIKE rvu_file.*
DEFINE l_rvv   RECORD LIKE rvv_file.*
DEFINE g_pmm   RECORD LIKE pmm_file.*
DEFINE g_pmn   RECORD LIKE pmn_file.*
DEFINE g_oan   RECORD LIKE oan_file.*
DEFINE l_oha   RECORD LIKE oha_file.*   #NO.FUN-620024
DEFINE l_ohb   RECORD LIKE ohb_file.*   #NO.FUN-620024
DEFINE g_poz   RECORD LIKE poz_file.*   #流程代碼資料(單頭) No.7993
DEFINE g_poy   RECORD LIKE poy_file.*   #流程代碼資料(單身) No.7993
DEFINE s_poy   RECORD LIKE poy_file.*,  #來源流程資料(單身) No.7993
       g_imd10      LIKE imd_file.imd10,    #倉儲類別
       g_imd11      LIKE imd_file.imd11,    #是否為可用倉儲
       g_imd12      LIKE imd_file.imd12,    #MRP倉否
       g_imd13      LIKE imd_file.imd13,    #保稅否
       g_imd14      LIKE imd_file.imd14,    #生產發料順序
       g_imd15      LIKE imd_file.imd15     #銷售出貨順序
DEFINE tm RECORD
          wc    LIKE type_file.chr1000  #No.FUN-680137 VARCHAR(600) 
       END RECORD
DEFINE p_pmm09  LIKE pmm_file.pmm09,    #廠商代號
       p_oea03  LIKE oea_file.oea03,    #客戶代號
       p_poy04  LIKE poy_file.poy04,    #工廠編號
       p_poz03  LIKE poz_file.poz03,    #申報方式
       p_poy06  LIKE poy_file.poy06,    #付款條件
       p_poy07  LIKE poy_file.poy07,    #收款條件
       p_poy08  LIKE poy_file.poy08,    #SO稅別
       p_poy09  LIKE poy_file.poy09,    #PO稅別
       p_poy10  LIKE poy_file.poy10,    #銷售分類
       p_poy12  LIKE poy_file.poy12,    #發票別
       p_poy16  LIKE poy_file.poy16,    #AR科目類別 #MOD-940299
       p_poy28  LIKE poy_file.poy28,    #出貨理由碼 #NO.FUN-620024
       p_poy29  LIKE poy_file.poy29,    #代送商編號 #NO.FUN-620024
       p_pox03  LIKE pox_file.pox03,    #計價基準
       p_pox05  LIKE pox_file.pox05,    #計價方式
       p_pox06  LIKE pox_file.pox06,    #計價比率
       p_azi01  LIKE azi_file.azi01,    #計價幣別 
       p_imd01  LIKE imd_file.imd01,    #各廠預設倉庫
       s_imd01  LIKE imd_file.imd01,    #各廠預設倉庫(來源)
       p_oea911 LIKE oea_file.oea911,   #送貨客戶代號
       p_cnt    LIKE type_file.num5     #計價方式符合筆數 #No.FUN-680137 SMALLINT
  DEFINE g_flow99 LIKE oga_file.oga99   #多角序號   #FUN-560043 #No.FUN-680137 VARCHAR(17)
  DEFINE l_oga99        LIKE oga_file.oga99			#TQC-9A0133
  DEFINE s_oga          RECORD LIKE oga_file.*  #出通單(各廠)  	#TQC-9A0133
  DEFINE t_dbs    LIKE type_file.chr21  #來源廠 DataBase Name #No.FUN-680137 VARCHAR(21)
  DEFINE t_plant  LIKE type_file.chr21  #FUN-980020 
  DEFINE s_dbs_new LIKE type_file.chr21  #New DataBase Name #No.FUN-680137 VARCHAR(21)
  DEFINE l_dbs_new LIKE type_file.chr21  #New DataBase Name #No.FUN-680137 VARCHAR(21)
  DEFINE l_plant_new LIKE type_file.chr10  #FUN-980020
  DEFINE l_aza  RECORD LIKE aza_file.*
  DEFINE s_aza  RECORD LIKE aza_file.*
  DEFINE s_azp  RECORD LIKE azp_file.*
  DEFINE l_azp  RECORD LIKE azp_file.*
  DEFINE s_azi  RECORD LIKE azi_file.*
  DEFINE l_azi  RECORD LIKE azi_file.*
  DEFINE g_sw   LIKE type_file.chr1     #No.FUN-680137 VARCHAR(1)
  DEFINE g_argv1  LIKE oga_file.oga01
  DEFINE p_last   LIKE type_file.num5   #流程之最後家數 #No.FUN-680137 SMALLINT
  DEFINE p_last_plant LIKE azp_file.azp01 #No.FUN-680137 VARCHAR(10)
  DEFINE g_t1     LIKE oay_file.oayslip   #No.FUN-550070   #No.FUN-680137 VARCHAR(05)
  DEFINE l_t      LIKE oay_file.oayslip   #No.FUN-620024   #No.FUN-680137 VARCHAR(05)
  DEFINE oga_t1   LIKE oay_file.oayslip   #No.FUN-550070   #No.FUN-680137 VARCHAR(05)
  DEFINE rva_t1   LIKE oay_file.oayslip   #No.FUN-550070   #No.FUN-680137 VARCHAR(05)
  DEFINE rvu_t1   LIKE oay_file.oayslip   #No.FUN-550070   #No.FUN-680137 VARCHAR(05)
  DEFINE g_ima906 LIKE ima_file.ima906    #FUN-560043
  DEFINE g_oha01  LIKE oha_file.oha01     #銷退單號   #NO.FUN-620024
  DEFINE g_oay18  LIKE oay_file.oay18     #銷退理由碼 #NO.FUN-620024
 
  DEFINE g_cnt    LIKE type_file.num10    #No.FUN-680137 INTEGER
  DEFINE g_msg    LIKE type_file.chr1000  #No.FUN-680137 VARCHAR(72)
  DEFINE g_fac    LIKE ogb_file.ogb15_fac,#MOD-810179 add
         g_unit   LIKE ogb_file.ogb15     #MOD-810179 add 
  DEFINE g_ima918 LIKE ima_file.ima918    #No.FUN-850100
  DEFINE g_ima921 LIKE ima_file.ima921    #No.FUN-850100
  DEFINE l_rvbs   RECORD LIKE rvbs_file.* #No.FUN-850100
  DEFINE g_type   LIKE type_file.chr1     #No.FUN-850145
  DEFINE b_ogb    RECORD LIKE ogb_file.*  #No.FUN-850145
  DEFINE b_ogbi   RECORD LIKE ogbi_file.* #No.FUN-850145
  DEFINE g_oebi   RECORD LIKE oebi_file.* #No.FUN-850145
  DEFINE g_chr2   LIKE type_file.chr1     #No.FUN-850145
  DEFINE g_sql    STRING                  #No.FUN-850145
  DEFINE g_argv0  LIKE type_file.chr1     #No.FUN-850145
  DEFINE gp_legal   LIKE azw_file.azw02    #FUN-980010 add
  DEFINE sp_legal   LIKE azw_file.azw02    #FUN-980010 add
  DEFINE gp_plant   LIKE azp_file.azp01    #FUN-980010 add
  DEFINE sp_plant   LIKE azp_file.azp01    #FUN-980010 add
  DEFINE l_dbs_tra  LIKE azw_file.azw05    #FUN-980092 add
  DEFINE s_dbs_tra  LIKE azw_file.azw05    #FUN-980092 add
  DEFINE s_plant_new  LIKE azp_file.azp01    #FUN-980092 add
  DEFINE g_oay11        LIKE oay_file.oay11      #MOD-A90029

MAIN
   OPTIONS                                 #改變一些系統預設值
        INPUT NO WRAP,
        FIELD ORDER FORM
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
    LET g_argv1 = ARG_VAL(1)
    SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
      CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #NO.CHI-6A0094 
    IF cl_null(g_oax.oax01) THEN       #三角貿易使用匯率
       LET g_oax.oax01='S'
    END IF
    LET t_plant = g_plant              #FUN-980020
    LET t_dbs = g_dbs CLIPPED,'.'
    #若有傳參數則不用輸入畫面
    IF cl_null(g_argv1) THEN
 
       CALL p820_p1()
       CLOSE WINDOW p820_w
    ELSE
       OPEN WINDOW p820_w WITH FORM "axm/42f/axmp820" 
             ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
       CALL cl_ui_init()
       LET tm.wc = " oga01='",g_argv1,"' " 
 
       CALL p820_p2()
 
       CLOSE WINDOW p820_w
    END IF
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818 #NO.CHI-6A0094 
END MAIN
 
FUNCTION p820_p1()
 DEFINE l_ac   LIKE type_file.num5    #No.FUN-680137 SMALLINT
 DEFINE l_i    LIKE type_file.num5    #No.FUN-680137 SMALLINT
 DEFINE l_cnt  LIKE type_file.num5    #No.FUN-680137 SMALLINT
 DEFINE l_flag LIKE type_file.num5    #No.FUN-680137 SMALLINT
 
    OPEN WINDOW p820_w WITH FORM "axm/42f/axmp820" 
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
    
 
    CALL cl_opmsg('z')
 
 
 WHILE TRUE
    LET g_action_choice = ''
 
    CONSTRUCT BY NAME tm.wc ON oga01,oga02 
 
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
#TQC-A50131 --add
       ON ACTION controlp
           CASE
              WHEN INFIELD(oga01)   #出貨單號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_oga_01"
                   LET g_qryparam.default1 = g_oga.oga01
                   CALL cl_create_qry() RETURNING g_oga.oga01
                   DISPLAY BY NAME g_oga.oga01 
                   NEXT FIELD oga01 
            END CASE
#TQC-A50131 --end 
       ON ACTION locale
          LET g_action_choice='locale'
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
    END CONSTRUCT
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ogauser', 'ogagrup') #FUN-980030
    IF g_action_choice = 'locale' THEN
       CALL cl_dynamic_locale()
       CONTINUE WHILE
    END IF
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    IF cl_sure(0,0) THEN
       CALL p820_p2()
       IF g_success = 'Y' THEN
          CALL cl_end2(1) RETURNING l_flag
       ELSE
          CALL cl_end2(2) RETURNING l_flag
       END IF
       IF l_flag THEN CONTINUE WHILE ELSE EXIT WHILE END IF
    END IF
 END WHILE
 CLOSE WINDOW p820_w
END FUNCTION
 
FUNCTION p820_p2()
  DEFINE l_pmm  RECORD LIKE pmm_file.*
  DEFINE l_pmn  RECORD LIKE pmn_file.*
  DEFINE l_occ  RECORD LIKE occ_file.*
  DEFINE l_pmc  RECORD LIKE pmc_file.*
  DEFINE l_gec  RECORD LIKE gec_file.*
  DEFINE l_ima  RECORD LIKE ima_file.*
  DEFINE #l_sql  LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1200)
          l_sql,l_sql1,l_sql2,l_sql3    STRING     #NO.FUN-910082 #FUN-C80001 add l_sql3
  #DEFINE l_sql2 LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1600)
  DEFINE i,l_i  LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE l_cnt  LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE l_cnt0 LIKE type_file.num5    #No.FUN-6B0064
  DEFINE l_j    LIKE type_file.num5,   #No.FUN-680137 SMALLINT
         l_msg  LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(60)
  DEFINE l_oea62 LIKE oea_file.oea62
 #DEFINE s_oea62 LIKE oea_file.oea62   #MOD-CC0242 mark
  DEFINE l_oeb24 LIKE oeb_file.oeb24 
  DEFINE l_occ02 LIKE occ_file.occ02,
         l_occ08 LIKE occ_file.occ08,
         l_occ11 LIKE occ_file.occ11
  DEFINE p_i     LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE l_no    LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE l_price LIKE ogb_file.ogb13,
         l_currm LIKE pmm_file.pmm42,      #計價幣別依原始來源廠的匯率
         x_currm LIKE pmm_file.pmm42,
         l_curr  LIKE pmm_file.pmm22      #No.FUN-680137 VARCHAR(04)
  DEFINE l_x     LIKE type_file.chr3      #No.FUN-620024   #No.FUN-680137 VARCHAR(3)
  DEFINE p_oeb   RECORD LIKE oeb_file.*
  DEFINE l_ogd01 LIKE ogd_file.ogd01       #包裝單號
  DEFINE g_ogd01 LIKE ogd_file.ogd01       #包裝單號
  DEFINE l_ofa01 LIKE ofa_file.ofa01       #INVOICE 單號
  DEFINE l_c     LIKE type_file.num5       #NO.FUN-670007 #No.FUN-680137 SMALLINT
  DEFINE l_poy02     LIKE poy_file.poy02       #NO.FUN-670007
  DEFINE k       LIKE type_file.num5       #MOD-8C0228
 
  CALL cl_wait() 
  LET l_cnt0 = 0    #FUN-6B0064 add
  BEGIN WORK 
  LET g_success='Y'
  CREATE TEMP TABLE p820_file(
         p_no       LIKE type_file.num5,  
#        pab_no     LIKE ofa_file.ofa01,    #No.FUN-550018
         pab_no     LIKE oga_file.oga01,    #No.TQC-A50131
         pab_item   LIKE ofb_file.ofb03,
         pab_price  LIKE ofb_file.ofb13,    #FUN-4C0006
         pab_curr   LIKE ofa_file.ofa23,
         pab_type   LIKE type_file.chr1); #1->出貨單  2->Invoice
  DELETE FROM p820_file
  #讀取符合條件之三角貿易訂單資料
  LET l_sql="SELECT * FROM oga_file ",
            " WHERE oga909='Y' ",    #三角貿易出貨單
             " AND oga905='N'  ",    #拋轉否
             " AND oga906='Y' ",     #必須為起始出貨單
             " AND ogaconf='Y' ",    #必須為確認單
             " AND ogapost='Y' ",    #MOD-A60153
             " AND oga09='4'  ",     #單據別=4三角貿易出貨單
             " AND ",tm.wc CLIPPED
  PREPARE p820_p1 FROM l_sql
  IF SQLCA.SQLCODE THEN CALL cl_err('pre1',SQLCA.SQLCODE,1) END IF
  DECLARE p820_curs1 CURSOR FOR p820_p1
  CALL s_showmsg_init()     #No.FUN-710046
  FOREACH p820_curs1 INTO g_oga.*
     IF SQLCA.SQLCODE <> 0 THEN  
        LET g_success= 'N'         #No.FUN-8A0086 
        EXIT FOREACH
     END IF
     IF g_success='N' THEN                                                                                                         
        LET g_totsuccess='N'                                                                                                       
        LET g_success="Y"                                                                                                          
     END IF                                                                                                                        
 
     IF cl_null(g_oga.oga16) THEN     #modi in 00/02/24 by kammy
        #只讀取第一筆訂單之資料
        LET l_sql1= " SELECT * FROM oea_file,ogb_file ",
                    "  WHERE oea01 = ogb31 ",
                    "    AND ogb01 = '",g_oga.oga01,"'",
                    "    AND oeaconf = 'Y' "  #01/08/16 mandy
        PREPARE oea_pre FROM l_sql1
        DECLARE oea_f CURSOR FOR oea_pre
        OPEN oea_f 
        FETCH oea_f INTO g_oea.*
     ELSE
        #讀取該出貨單之訂單
        SELECT * INTO g_oea.*
          FROM oea_file
         WHERE oea01 = g_oga.oga16
           AND oeaconf = 'Y' #01/08/16 mandy
     END IF

     IF NOT cl_null(g_oga.oga011) THEN   
        SELECT oga99 INTO l_oga99 FROM oga_file
         WHERE oga01 = g_oga.oga011 
           AND oga09 = '5'
        IF cl_null(l_oga99) THEN
           CALL s_errmsg('oga011',g_oga.oga011,' ','axm-951',1)  
           LET g_success = 'N'
           CONTINUE FOREACH                          
        END IF
     END IF

     #no.6158檢查各工廠關帳日(sma53)
     IF s_mchksma53(g_oea.oea904,g_oga.oga02) THEN
        LET g_success='N' CONTINUE FOREACH #No.FUN-710046
     END IF
     #讀取三角貿易流程代碼資料
     SELECT * INTO g_poz.*
       FROM poz_file
      WHERE poz01=g_oea.oea904 AND poz00='1'
     IF SQLCA.sqlcode THEN
        LET g_showmsg = g_oea.oea904,"/",'0'                               #No.FUN-710046
        CALL s_errmsg('poz01,poz00',g_showmsg,g_oea.oea904,'axm-318',1)    #No.FUN-710046
        LET g_success = 'N'
        CONTINUE FOREACH  #No.FUN-710046
     END IF
     IF g_poz.pozacti = 'N' THEN 
        CALL s_errmsg('pozacti','N',g_oea.oea904,'tri-009',1)  #No.FUN-710046
        LET g_success = 'N'
        CONTINUE FOREACH  #No.FUN-710046
     END IF
     IF g_poz.poz011 = '2' THEN
        CALL s_errmsg('','','2','axm-411',1)  #No.FUN-710046
        LET g_success = 'N' 
        CONTINUE FOREACH  #No.FUN-710046
     END IF
     #no.4526抓取單別拋轉設定檔
     #No.MOD-680058--mark--移到站別資料之後做
     CALL p820_flow99()                           #No.7993 取得多角序號
     CALL s_mtrade_last_plant(g_oea.oea904) 
                 RETURNING p_last,p_last_plant    #記錄最後一筆之家數
    #LET s_oea62=0   #MOD-CC0242 mark

     #-----MOD-A90029---------
     LET g_oay11 = NULL
     LET g_t1 = s_get_doc_no(g_oga.oga01)
     SELECT oay11 INTO g_oay11 FROM oay_file
       WHERE oayslip = g_t1 
     #-----END MOD-A90029-----   

     #依流程代碼最多6層
     FOR i = 1 TO p_last
           LET k = i+1  #MOD-8C0228 add
           #得到廠商/客戶代碼及database
           CALL p820_azp(i)      
 
           LET gp_plant = g_poy.poy04                    #FUN-980010 add
           CALL s_getlegal(gp_plant) RETURNING gp_legal  #FUN-980010 add
 
           LET sp_plant = s_poy.poy04                    #FUN-980010 add
           CALL s_getlegal(sp_plant) RETURNING sp_legal  #FUN-980010 add
 
           #No.MOD-680058--mark--移到站別資料之後做(增加傳入流程序號及站別)
               LET g_t1 = s_get_doc_no(g_oga.oga01)         #No.FUN-550070 
               CALL s_mutislip('1','1',g_t1,g_poz.poz01,i)                      
                    RETURNING g_sw,oga_t1,l_x,l_x,l_x,l_x   #MOD-8C0228 add
               IF g_sw THEN 
                  LET g_success = 'N' CONTINUE FOREACH   #No.FUN-710046
               END IF 
               IF cl_null(oga_t1) THEN
                   CALL cl_err('','axm4012',1)
                   LET g_success = 'N'
                   EXIT FOREACH
               ELSE                                                                                                                   
                  LET l_cnt = 0                                                                                                       
                  #LET l_sql = "SELECT COUNT(*) FROM ",l_dbs_new,"oay_file ",
                  LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new,'oay_file'), #FUN-A50102                 
                              " WHERE oayslip = '",oga_t1,"'"                                                                         
 	              CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                  CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
                  PREPARE oay_pre1 FROM l_sql                                                                                         
                  EXECUTE oay_pre1 INTO l_cnt                                                                                         
                  IF l_cnt = 0 THEN                                                                                                   
                     LET g_msg = l_dbs_new CLIPPED,oga_t1 CLIPPED                                                                     
                     CALL cl_err3("","","","",'axm-931',"","g_msg",1)                                                                 
                     LET g_success = 'N'                                                                                              
                     EXIT FOREACH                                                                                                     
                  END IF                                                                                                              
	       #MOD-8C0228 add 入庫/出貨單別應抓下一站---
               #MOD-970169 add 入庫/出貨單別應抓當站設定---
		   CALL s_mutislip('1','1',g_t1,g_poz.poz01,i)                      
			RETURNING g_sw,l_x,rva_t1,rvu_t1,l_x,l_x 
		   IF g_sw THEN 
		       LET g_success = 'N' 
		       CONTINUE FOREACH  
		   END IF 
	       IF i <> 0 THEN                    #第0站不會有入庫/收貨資料
	       #---no.MOD-8C0228 add ------------------
               END IF
               IF cl_null(rva_t1) THEN
                   CALL cl_err('','axm4013',1)
                   LET g_success = 'N'
                   EXIT FOREACH
               ELSE                                                                                                                   
                  LET l_cnt = 0                                                                                                       
                  #LET l_sql = "SELECT COUNT(*) FROM ",s_dbs_new,"smy_file ",        #MOD-8C0228 modify l_dbs_new->s_dbs_new 
                  LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(s_plant_new,'smy_file'), #FUN-A50102                   
                              " WHERE smyslip = '",rva_t1,"'"                                                                         
 	              CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                  CALL cl_parse_qry_sql(l_sql,s_plant_new) RETURNING l_sql #FUN-A50102
                  PREPARE smy_pre1 FROM l_sql                                                                                         
                  EXECUTE smy_pre1 INTO l_cnt                                                                                         
                  IF l_cnt = 0 THEN                                                                                                   
                     LET g_msg = s_dbs_new CLIPPED,rva_t1 CLIPPED  #MOD-8C0228 modify                                                                    
                     CALL cl_err3("","","","",'axm-931',"","g_msg",1)                                                                 
                     LET g_success = 'N'                                                                                              
                     EXIT FOREACH                                                                                                     
                  END IF                                                                                                              
               END IF
               IF NOT cl_null(rvu_t1) THEN                                                                                            
                  LET l_cnt = 0                                                                                                       
                  #LET l_sql = "SELECT COUNT(*) FROM ",s_dbs_new,"smy_file ",         #MOD-8C0228 modify l_dbs_new->s_dbs_new 
                  LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(s_plant_new,'smy_file'), #FUN-A50102                   
                              " WHERE smyslip = '",rvu_t1,"'"                                                                         
 	              CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                  CALL cl_parse_qry_sql(l_sql,s_plant_new) RETURNING l_sql #FUN-A50102
                  PREPARE smy_pre2 FROM l_sql                                                                                         
                  EXECUTE smy_pre2 INTO l_cnt                                                                                         
                  IF l_cnt = 0 THEN                                                                                                   
                     LET g_msg = s_dbs_new CLIPPED,rvu_t1 CLIPPED      #MOD-8C0228 modify                                                                
                     CALL cl_err3("","","","",'axm-931',"","g_msg",1)                                                                 
                     LET g_success = 'N'                                                                                              
                     EXIT FOREACH                                                                                                     
                  END IF                                                                                                              
               END IF                                                                                                                 
               LET l_cnt = 0                                                                                                          
           END IF                            #no.MOD-8C0228 add
           CALL p820_chk99()                        #No.7993
           #CALL p820_azi(g_oea.oea23,t_dbs)              #讀取幣別資料  #FUN-670007
           CALL p820_azi(g_oea.oea23,g_plant)    #FUN-A50102
           CALL p820_oea911(i) RETURNING p_oea911  #讀取送貨客戶
           #讀取該料號之計價方式(依流程代碼+生效日期+廠商)
           IF s_aza.aza50 ='N' THEN     #NO.FUN-620024
              CALL s_pox(g_oea.oea904,i,g_oga.oga02)
                   RETURNING p_pox03,p_pox05,p_pox06,p_cnt
           END IF                       #NO.FUN-620024
 
          #LET l_sql2 = "INSERT INTO ",l_dbs_tra CLIPPED,"rvbs_file",  #FUN-980092 add
          LET l_sql2 = "INSERT INTO ",cl_get_target_table(l_plant_new,'rvbs_file'), #FUN-A50102 
                        "(rvbs00,rvbs01,rvbs02,rvbs021,rvbs022,rvbs03,",
                        " rvbs04,rvbs05,rvbs06,rvbs07,rvbs08,rvbs09,",
                        " rvbsplant,rvbslegal,rvbs13) ",   #FUN-980010 #No.CHI-990031 add rvbs13
                        " VALUES( ?,?,?,?,?,?, ?,?,?,?,?,?,  ?,?,?) " #FUN-980010 #No.CHI-990031 add ?
 
 	       CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
          CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092 
           PREPARE ins_rvbs FROM l_sql2
#FUN-C80001---add---START--拋轉收貨單、入庫單批序號資料
           LET l_sql3 = "INSERT INTO ",cl_get_target_table(s_plant_new,'rvbs_file'), 
                        "(rvbs00,rvbs01,rvbs02,rvbs021,rvbs022,rvbs03,",
                        " rvbs04,rvbs05,rvbs06,rvbs07,rvbs08,rvbs09,",
                        " rvbsplant,rvbslegal,rvbs13) ",   
                        " VALUES( ?,?,?,?,?,?, ?,?,?,?,?,?,  ?,?,?) " 
               CALL cl_replace_sqldb(l_sql3) RETURNING l_sql3        
           CALL cl_parse_qry_sql(l_sql3,s_plant_new) RETURNING l_sql3 
           PREPARE ins_rvbs1 FROM l_sql3 
#FUN-C80001---add-----END
 
           CALL p820_p3(i)              #NO.FUN-670007
     END FOR  {一個訂單流程代碼結束}   
 
     MESSAGE ""
     
    ##更新起始訂單檔之已出貨金額
     
     #更新起始出貨單單頭檔之拋轉否='Y'
     UPDATE oga_file
        SET oga905='Y',
            oga906='Y',
            ogapost='Y'
       WHERE oga01=g_oga.oga01
     IF SQLCA.SQLCODE <> 0 OR sqlca.sqlerrd[3]=0 THEN
        CALL s_errmsg('oga01',g_oga.oga01,'upd pmm',STATUS,1)               #No.FUN-710046
        LET g_success='N'
        CONTINUE FOREACH   #No.FUN-710046
     END IF
     IF NOT cl_null(g_oga.oga011) THEN #通知單號
        UPDATE oga_file SET ogapost='Y' WHERE oga01=g_oga.oga011
     END IF
     LET l_cnt0 = l_cnt0 + 1
  END FOREACH     
  IF l_cnt0 = 0 THEN
    CALL cl_err('','mfg3160',1)
    LET g_success = 'N'
  END IF
 
  IF g_totsuccess="N" THEN                                                                                                        
     LET g_success="N"                                                                                                            
  END IF                                                                                                                          
  CALL s_showmsg()     #No.FUN-710046
  IF g_success = 'Y'
      THEN COMMIT WORK
      ELSE ROLLBACK WORK
  END IF
  DROP TABLE p820_file
END FUNCTION 
 
#NO.FUN-670007 start--把原本的process段拆到p820_p3()
FUNCTION p820_p3(i)
DEFINE l_pmm  RECORD LIKE pmm_file.*
DEFINE l_pmn  RECORD LIKE pmn_file.*
DEFINE l_occ  RECORD LIKE occ_file.*
DEFINE l_pmc  RECORD LIKE pmc_file.*
DEFINE l_gec  RECORD LIKE gec_file.*
DEFINE l_ima  RECORD LIKE ima_file.*
#DEFINE l_sql  LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1200)   #CHI-940042 mark
#DEFINE l_sql1 LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(600)    #CHI-940042 mark
#DEFINE l_sql2 LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1600)   #CHI-940042 mark
DEFINE l_sql,l_sql1,l_sql2 STRING     #CHI-940042
DEFINE i,l_i  LIKE type_file.num5    #No.FUN-680137 SMALLINT
DEFINE l_cnt  LIKE type_file.num5    #No.FUN-680137 SMALLINT
DEFINE l_j    LIKE type_file.num5,   #No.FUN-680137 SMALLINT
       l_msg  LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(60)
DEFINE l_oea62 LIKE oea_file.oea62
#DEFINE s_oea62 LIKE oea_file.oea62             #MOD-CC0242 mark
DEFINE l_oeb24 LIKE oeb_file.oeb24 
DEFINE l_tot3  		LIKE ogb_file.ogb12	#MOD-990233
DEFINE l_tot2  		LIKE ogb_file.ogb12	#MOD-990233
DEFINE l_tot1  		LIKE ogb_file.ogb12  	#MOD-990233
DEFINE l_tot4  		LIKE ogb_file.ogb12 	#MOD-990233
DEFINE l_chr   		LIKE type_file.chr1	#MOD-990233
DEFINE l_oeahold	LIKE oea_file.oeahold	#MOD-990233
DEFINE l_occ02 LIKE occ_file.occ02,
       l_occ08 LIKE occ_file.occ08,
       l_occ11 LIKE occ_file.occ11
DEFINE p_i     LIKE type_file.num5    #No.FUN-680137 SMALLINT
DEFINE l_no    LIKE type_file.num5    #No.FUN-680137 SMALLINT
DEFINE l_price LIKE ogb_file.ogb13,
       l_currm LIKE pmm_file.pmm42,      #計價幣別依原始來源廠的匯率
       x_currm LIKE pmm_file.pmm42,
       l_curr  LIKE pmm_file.pmm22      #No.FUN-680137 VARCHAR(04)
DEFINE l_x     LIKE type_file.chr3      #No.FUN-620024   #No.FUN-680137 VARCHAR(3)
DEFINE p_oeb   RECORD LIKE oeb_file.*
DEFINE l_ogd01 LIKE ogd_file.ogd01       #包裝單號
DEFINE g_ogd01 LIKE ogd_file.ogd01       #包裝單號
DEFINE l_ofa01 LIKE ofa_file.ofa01       #INVOICE 單號
DEFINE l_ogbb  RECORD LIKE ogbb_file.*   #NO.FUN-780025
DEFINE l_ogdi  RECORD LIKE ogdi_file.*   #NO.FUN-7B0018
DEFINE li_result LIKE type_file.num5     #TQC-9B0013
 
    #新增出貨單單單頭檔(oga_file)
    CALL p820_ogains() 
    #新增收貨單單頭檔(rva_file)-->s_dbs_new
    CALL p820_rvains()
 
    #新增入庫單單頭檔(rvu_file)-->s_dbs_new
    CALL p820_rvuins()
 
    LET l_oea62=0
 
    #讀取出貨單身檔(ogb_file)
    DECLARE ogb_cus CURSOR FOR
       SELECT *
         FROM ogb_file
        WHERE ogb01 = g_oga.oga01
          AND ogb1005='1' #TQC-650089
 
    FOREACH ogb_cus INTO g_ogb.* 
       IF SQLCA.SQLCODE <>0 THEN
          EXIT FOREACH
       END IF 
 
       SELECT ima906 INTO g_ima906 FROM ima_file 
        WHERE ima01 = g_ogb.ogb04
 
       #重新取得單身的訂單號碼
       LET l_sql1= " SELECT oea99 ",
                   "   FROM oea_file ",
                   "  WHERE oea01 = '",g_ogb.ogb31,"'"
 
       PREPARE oea99_pre FROM l_sql1
 
       DECLARE oea99_cus CURSOR FOR oea99_pre
 
       OPEN oea99_cus
 
       FETCH oea99_cus INTO g_oea.oea99
 
       CLOSE oea99_cus
 
       DECLARE p820_g_rvbs CURSOR FOR SELECT * FROM rvbs_file
                                         WHERE rvbs01 = g_oga.oga01
                                           AND rvbs02 = g_ogb.ogb03

#CHI-C40031---add---START
       LET l_sql = " SELECT * FROM ogg_file ",
                   "  WHERE ogg01 = '",g_oga.oga01,"'",
                   "    AND ogg03 = '",g_ogb.ogb03,"'",
                   "    AND ogg18 = ? "
       DECLARE p820_g_ogg CURSOR FROM l_sql
       LET l_sql = " SELECT * FROM ogc_file ",
                   "  WHERE ogc01 = '",g_oga.oga01,"'",
                   "    AND ogc03 = '",g_ogb.ogb03,"'",
                   "    AND ogc18 = ? "
       DECLARE p820_g_ogc CURSOR FROM l_sql
#CHI-C40031---add-----END
 
#FUN-B90012 --------------------Begin-----------------------
       IF s_industry('icd') THEN
          DECLARE p820_g_idd CURSOR FOR SELECT * FROM idd_file
                              WHERE idd10 = g_oga.oga01
                                AND idd11 = g_ogb.ogb03 
          #FUN-C80001---begin
          LET l_sql = " SELECT idd04,idd05,idd06 FROM idd_file ",
                      "  WHERE idd10 = '",g_oga.oga01,"'",
                      "    AND idd11 = ",g_ogb.ogb03,
                      "    AND idd04 = ? ",
                      " GROUP BY idd04,idd05,idd06 "
          DECLARE p820_g_idd1 CURSOR FROM l_sql

          LET l_sql = " SELECT * FROM idd_file ",
                      " WHERE idd10 = '",g_oga.oga01,"'",
                      "   AND idd11 = ",g_ogb.ogb03,
                      "   AND idd04 = ? ",
                      "   AND idd05 = ? ",
                      "   AND idd06 = ? "
          DECLARE p820_g_idd2 CURSOR FROM l_sql 
          #FUN-C80001---end
       END IF
#FUN-B90012 --------------------End-------------------------
       #新增出貨單單身檔(ogb_file)
       CALL p820_ogbins(i) 
       IF l_ogb.ogb17 <> 'Y' THEN  #FUN-C80001
          CALL p820_log(l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,
                        l_ogb.ogb092,l_ogb.ogb12,'1',l_plant_new,i,'L',l_ogb.ogb915)  #FUN-980092 add #FUN-C80001

          IF i = p_last THEN
              CALL s_mupimg(-1,l_ogb.ogb04,  
                            l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,
                            l_ogb.ogb12*l_ogb.ogb15_fac, #MOD-4B0148
                            g_oga.oga02,g_poy.poy04,-1,l_ogb.ogb01,l_ogb.ogb03)  #No.FUN-850100  #No.FUN-980081 
              IF g_ima906 = '2' THEN                    #NO.FUN-620024
                 CALL s_mupimgg(-1,l_ogb.ogb04,  
                                  l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,
                                  l_ogb.ogb910,l_ogb.ogb912,
                                  g_oga.oga02,
                                  l_plant_new) #FUN-980092 add
                 CALL s_mupimgg(-1,l_ogb.ogb04,  
                                  l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,
                                  l_ogb.ogb913,l_ogb.ogb915, 
                                  g_oga.oga02,
                                  l_plant_new) #FUN-980092 add
              ELSE
                 IF g_ima906 = '3' THEN
                    CALL s_mupimgg(-1,l_ogb.ogb04,  
                                     l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,
                                     l_ogb.ogb913,l_ogb.ogb915, 
                                     g_oga.oga02,
                                     l_plant_new) #FUN-980092 add
                 END IF
              END IF
              CALL s_mudima(l_ogb.ogb04,l_plant_new) #FUN-980092 add
          END IF
       END IF  #FUN-C80001
       IF g_success = 'N' THEN EXIT FOREACH END IF   #NO.FUN-620024
 
       #No.7993 並且最終出貨單扣庫存
 
       IF s_aza.aza50 ='Y' THEN      #使用分銷功能     
          IF l_oga.oga00 = '6' THEN  #代送出貨單     
 
             CALL p820_log(l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,
                           l_ogb.ogb092,l_ogb.ogb12,'4',l_plant_new,i,'L',l_ogb.ogb915)  #FUN-980092 add #FUN-C80001
             IF i = p_last THEN
                CALL s_mupimg(+1,l_ogb.ogb04,   
                              l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,
                              l_ogb.ogb12*l_ogb.ogb15_fac, #MOD-4B0148
                              g_oga.oga02,g_poy.poy04,-1,l_ogb.ogb01,l_ogb.ogb03)  #No.FUN-850100    #No.FUN-980081 
                IF g_ima906 = '2' THEN                    #NO.FUN-620024
                   CALL s_mupimgg(+1,l_ogb.ogb04,   
                                    l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,
                                    l_ogb.ogb910,l_ogb.ogb912,
                                    g_oga.oga02,
                                    l_plant_new) #FUN-980092 add
                   CALL s_mupimgg(+1,l_ogb.ogb04,   
                                    l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,
                                    l_ogb.ogb913,l_ogb.ogb915, 
                                    g_oga.oga02,
                                    l_plant_new)#FUN-980092 add
                ELSE
                   IF g_ima906 = '3' THEN
                      CALL s_mupimgg(+1,l_ogb.ogb04,   
                                       l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,
                                       l_ogb.ogb913,l_ogb.ogb915, 
                                       g_oga.oga02,
                                       l_dbs_new)
                   END IF
                END IF
                CALL s_mudima(l_ogb.ogb04,l_plant_new) #FUN-980092 add
             END IF
          END IF  
       END IF
 
       IF g_success = 'N' THEN EXIT FOREACH END IF
       
      #-CHI-A10031-remark- 
      #-CHI-9C0037-mark- 
       #新增 tlf_file for 出貨單 -->s_dbs_new(來源)
      #IF g_sma.sma96 = 'Y' AND g_ogb.ogb17 = 'Y' THEN   #FUN-C80001 #FUN-D30099 mark
       IF g_pod.pod08 = 'Y' AND g_ogb.ogb17 = 'Y' THEN   #FUN-D30099
          CALL p820_rvbins1(i)     #FUN-C80001
       ELSE                        #FUN-C80001
          IF i = 1 THEN
             CALL p820_log(g_ogb.ogb04,g_ogb.ogb09,g_ogb.ogb091,
                           g_ogb.ogb092,g_ogb.ogb12,'1',s_plant_new,0,'S',g_ogb.ogb915) #FUN-C80001
          END IF
      #-CHI-9C0037-end- 
      #-CHI-A10031-end- 

       #新增收貨單單身檔(rvb_file)-->s_dbs_new
          CALL p820_rvbins(i)
          CALL p820_log(l_rvb.rvb05,l_rvb.rvb36,l_rvb.rvb37,l_rvb.rvb38,
                        l_rvb.rvb07,'2',s_plant_new,i,'S',l_rvb.rvb85) #FUN-980092 add #FUN-C80001
 
       #新增入庫單單身檔(rvv_file)-->s_dbs_new
          CALL p820_rvvins(i)
          CALL p820_log(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                        l_rvv.rvv17,'3',s_plant_new,i,'S',l_rvv.rvv85) #FUN-980092 add #FUN-C80001
       END IF                      #FUN-C80001
       IF g_success='N' THEN EXIT FOREACH END IF
       
       #IF s_aza.aza50 = 'Y' THEN   #MOD-810014 mark
          LET l_sql1 = "SELECT pmm01 ",
                       #" FROM ",s_dbs_tra CLIPPED,"pmm_file ",  #FUN-980092 add
                       " FROM ",cl_get_target_table(s_plant_new,'pmm_file'), #FUN-A50102
                       " WHERE pmm99='",g_oea.oea99,"' AND pmm18 <> 'X'" 
 	      CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
          CALL cl_parse_qry_sql(l_sql1,s_plant_new) RETURNING l_sql1 #FUN-980092
          PREPARE pmm_p2 FROM l_sql1
          IF SQLCA.SQLCODE THEN 
             CALL s_errmsg('','','pmm_p2',SQLCA.SQLCODE,0) #No.FUN-710046
          END IF
          DECLARE pmm_c2 CURSOR FOR pmm_p2
          OPEN pmm_c2
          FETCH pmm_c2 INTO g_pmm.pmm01
          IF SQLCA.SQLCODE <> 0 THEN
             LET g_success='N'
             RETURN
          END IF
          CLOSE pmm_c2
       IF NOT p820_chkoeo(g_ogb.ogb31, 
                          g_ogb.ogb32,g_ogb.ogb04) THEN #No.7742
          #更新採購單身之入庫量及交貨量
         IF s_aza.aza50 = 'Y' THEN         #NO.FUN-620024
            #LET l_sql2="UPDATE ",s_dbs_tra CLIPPED,"pmn_file",
            LET l_sql2="UPDATE ",cl_get_target_table(s_plant_new,'pmn_file'), #FUN-A50102
                         " SET pmn50 = pmn50 + ?,",
                         "     pmn53 = pmn53 + ? ",
                       " WHERE pmn01 = ? AND pmn02 = ? "  #MOD-530005
 	        CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
            CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2 #FUN-980092
            PREPARE upd_pmn FROM l_sql2
            EXECUTE upd_pmn USING 
                 l_ogb.ogb12,l_ogb.ogb12,
                 g_pmm.pmm01,g_ogb.ogb32  #NO.FUN-620024  #MOD-810014 modify l_ogb.ogb32->g_ogb.ogb32
            IF SQLCA.sqlcode<>0 THEN
               LET g_showmsg = l_ogb.ogb12,"/",l_ogb.ogb12,"/",g_pmm.pmm01,"/",l_ogb.ogb32    #No.FUN-710046
               CALL s_errmsg('pmn24,pmn25,pmn01,pmn02',g_showmsg,'upd pmn:',SQLCA.sqlcode,1)  #No.FUN-710046
               LET g_success = 'N'
            END IF
          ELSE
            #LET l_sql2="UPDATE ",s_dbs_tra CLIPPED,"pmn_file",  #FUN-980092 add
            LET l_sql2="UPDATE ",cl_get_target_table(s_plant_new,'pmn_file'), #FUN-A50102
                    " SET pmn50 = pmn50 + ?,",
                    "     pmn53 = pmn53 + ? ",
                    " WHERE pmn01 = ? AND pmn02 = ? " 
 	        CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
            CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2 #FUN-980092
            PREPARE upd_pmn_1 FROM l_sql2
            EXECUTE upd_pmn_1 USING 
                 l_ogb.ogb12,l_ogb.ogb12,
                 g_pmm.pmm01,g_ogb.ogb32     #MOD-810014 
            IF SQLCA.sqlcode<>0 THEN
               LET g_showmsg = g_pmm.pmm01,"/",g_ogb.ogb32  #No.FUN-710046 #MOD-810014 modify
               CALL s_errmsg('pmn01,pmn02',g_showmsg,'upd pmn:',SQLCA.sqlcode,1)  #No.FUN-710046
               LET g_success = 'N'
            END IF
         END IF                            #NO.FUN-620024              
 
          #更新銷單之已出貨量
          LET l_oeb24 = l_oeb.oeb24 + l_ogb.ogb12 
          IF l_oeb24 IS NULL THEN LET l_oeb24=0 END IF
          #LET l_sql2="UPDATE ",l_dbs_tra CLIPPED,"oeb_file",  #FUN-980092 add
          LET l_sql2="UPDATE ",cl_get_target_table(l_plant_new,'oeb_file'), #FUN-A50102
                       " SET oeb24 = ? ",
                     " WHERE oeb01 = ? AND oeb03 = ? "
 	      CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
          CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
          PREPARE upd_oeb2 FROM l_sql2
          EXECUTE upd_oeb2 USING 
                  l_oeb24, l_ogb.ogb31,l_ogb.ogb32
          IF SQLCA.sqlcode<>0 THEN
              LET g_showmsg = l_ogb.ogb31,"/",l_ogb.ogb32 #No.FUN-710046
              CALL s_errmsg('oeb01,oeb03',g_showmsg,'upd oeb24:',SQLCA.sqlcode,1)   #No.FUN-710046
              LET g_success = 'N'
          END IF
          LET l_oea62 = l_oea62 + l_ogb.ogb12*l_oeb.oeb13
          IF i = 1 THEN
             #讀取來源銷單資料
             SELECT * INTO g_oeb.*
               FROM oeb_file
              WHERE oeb01 = g_ogb.ogb31 AND oeb03 = g_ogb.ogb32
 
             SELECT SUM(ogb12) INTO l_tot3
               FROM oga_file,ogb_file
              WHERE ogb31 = g_ogb.ogb31 AND ogb32 = g_ogb.ogb32 AND ogb01 = oga01
                AND ogb01 <> g_oga.oga01 AND oga09 = '4' AND ogaconf = 'Y' 
                AND ogapost = 'N' 
             IF cl_null(l_tot3) THEN LET l_tot3 = 0 END IF
 
             SELECT SUM(ogb12) INTO l_tot1 FROM ogb_file,oga_file
                 WHERE ogb31=g_ogb.ogb31 AND ogb32=g_ogb.ogb32
                   AND ogb01 = g_oga.oga01 
                   AND ogb01=oga01 AND oga09 = '4' 
             IF cl_null(l_tot1) THEN LET l_tot1 = 0 END IF
 
             LET l_chr='N'
             SELECT (oeb12*((100+oea09)/100)+oeb25),oeb70,oeahold
                  INTO l_tot2,l_chr,l_oeahold
                  FROM oeb_file, oea_file
                 WHERE oeb01 = g_ogb.ogb31 AND oeb03 = g_ogb.ogb32 AND oeb01=oea01
             IF cl_null(l_tot2) THEN LET l_tot2 = 0 END IF
             IF l_chr='Y' THEN
                CALL cl_err(l_ogb.ogb32,'axm-150',1) LET g_success = 'N' RETURN
             END IF
             IF NOT cl_null(l_oeahold) THEN
                LET l_msg = g_ogb.ogb31 ,' + ', g_ogb.ogb32
                CALL cl_err(l_msg,'axm-151',1) 
                LET g_success = 'N' 
                RETURN
             END IF
             IF l_tot1 > l_tot2 THEN
                CALL cl_err(g_ogb.ogb31||' l_tot1 > oeb24','axm-174',1) 
                LET g_success = 'N' 
                RETURN  
             END IF
 
             SELECT SUM(ogb12) INTO l_tot4 FROM ogb_file,oga_file
                 WHERE ogb31=g_ogb.ogb31
                   AND ogb32=g_ogb.ogb32
                   AND ogb04=g_ogb.ogb04
                   AND ogb01=oga01 AND oga00='B'
                   AND ogaconf='Y'
                   AND ogapost='Y'  
             IF cl_null(l_tot4) THEN LET l_tot4 = 0 END IF
             #更新來源銷單之已出貨量
             UPDATE oeb_file
               #SET oeb24 = oeb24 + g_ogb.ogb12,    #MOD-B70254 mark
               #    oeb23 = l_tot3,	#MOD-990233 #MOD-B70254 mark
                SET oeb23 = l_tot3,	            #MOD-B70254
                   oeb29 = l_tot4       #MOD-990233
              WHERE oeb01 = g_ogb.ogb31 AND oeb03 = g_ogb.ogb32
             IF SQLCA.sqlcode<>0 THEN
                 LET g_showmsg = g_ogb.ogb31,"/",g_ogb.ogb32  #No.FUN-710046
                #CALL s_errmsg('oeb01,oeb03',g_showmsg,'upd2 oeb24:',SQLCA.sqlcode,1)   #No.FUN-710046 #MOD-B70254 mark
                 CALL s_errmsg('oeb01,oeb03',g_showmsg,'upd2 oeb23:',SQLCA.sqlcode,1)                  #MOD-B70254
                 LET g_success = 'N'
             END IF
            #MOD-CC0242 -- mark start --
            #LET s_oea62 = g_ogb.ogb12*g_oeb.oeb13
            ##更新起始訂單檔之已出貨金額 2000/02/24 add
            #UPDATE oea_file
            #   SET oea62 = oea62 + s_oea62
            #  WHERE oea01 = g_ogb.ogb31
            #IF SQLCA.SQLCODE <> 0 THEN
            #   LET g_success='N' 
            #END IF
            #MOD-CC0242 -- mark end --
           END IF
       END IF  ##No.7742(end)
 
    END FOREACH {ogb_cus}
 
    #更新銷單已出貨未稅金額
    #LET l_sql2="UPDATE ",l_dbs_tra CLIPPED,"oea_file",   #FUN-980092 add
    LET l_sql2="UPDATE ",cl_get_target_table(l_plant_new,'oea_file'), #FUN-A50102
            " SET oea62 = oea62 + ? ",
            " WHERE oea01 = ?  "
    CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
    CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
    PREPARE upd_oea2 FROM l_sql2
    EXECUTE upd_oea2 USING l_oea62, l_ogb.ogb31
    IF SQLCA.sqlcode<>0 THEN
        CALL s_errmsg('oea01',l_ogb.ogb31,'upd oea62:',SQLCA.sqlcode,1) #No.FUN-710046
        LET g_success = 'N'
    END IF
    #no.FUN-780025 start---拋轉ogbb_file 出貨單序號檔------------------
    DECLARE ogbb_cs CURSOR FOR
     SELECT * FROM ogbb_file WHERE ogbb01 = g_oga.oga01
    FOREACH ogbb_cs INTO l_ogbb.* 
        LET l_ogbb.ogbb01 = l_oga.oga01
        #LET l_sql2 = "INSERT INTO ",l_dbs_tra CLIPPED,"ogbb_file",  #FUN-980092 add
        LET l_sql2 = "INSERT INTO ",cl_get_target_table(l_plant_new,'ogbb_file'), #FUN-A50102
                     "     (ogbb01,ogbb012,ogbb02, ogbbplant,ogbblegal) ",  #FUN-980010
                     " VALUES(?,?,?,  ?,?) "   #FUN-980010
 	    CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
        CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
        PREPARE ins_ogbb FROM l_sql2
        EXECUTE ins_ogbb USING l_ogbb.ogbb01,l_ogbb.ogbb012,l_ogbb.ogbb02,
                               gp_plant,gp_legal   #FUN-980010
          IF SQLCA.sqlcode<>0 THEN
             LET g_msg = l_dbs_new CLIPPED,"ins ogbb"
             CALL s_errmsg('','',g_msg,SQLCA.sqlcode,1) 
             LET g_success = 'N'
          END IF
    END FOREACH
 
    #---------------- 是否拋轉 Packing List ----------------------
    IF g_oax.oax05='Y' THEN   #NO.FUN-670007
       LET l_cnt = 0
       IF g_oga.oga30 = 'Y' THEN 
         #若包裝單之出貨單號來源為'2'出貨單
          IF g_oaz.oaz67 = '2' THEN  
             SELECT COUNT(*) INTO l_cnt FROM ogd_file
              WHERE ogd01=g_oga.oga01 
          END IF 
          IF g_oaz.oaz67 = '1' THEN  
             SELECT COUNT(*) INTO l_cnt FROM ogd_file
              WHERE ogd01=g_oga.oga011 
          END IF 
       END IF  
       IF l_cnt > 0  AND g_oaz.oaz67 = '2' THEN  #有輸入Packing List才拋轉
#NO.出通單己經執行過拋轉的動作，此處不再拋出通單
            LET l_ogd01 = l_oga.oga01    #No.7993
            LET g_ogd01 = g_oga.oga01
            DECLARE ogd_cs CURSOR FOR 
             SELECT * FROM ogd_file 
              WHERE ogd01=g_ogd01
            FOREACH ogd_cs INTO g_ogd.*
               IF SQLCA.SQLCODE <>0 THEN EXIT FOREACH END IF 
               #新增Packing List
               LET g_ogd.ogd01 = l_ogd01
               IF cl_null(g_ogd.ogd01) THEN LET g_ogd.ogd01=' ' END IF
               #LET l_sql2="INSERT INTO ",l_dbs_tra CLIPPED,"ogd_file",  #FUN-980092 add
               LET l_sql2="INSERT INTO ",cl_get_target_table(l_plant_new,'ogd_file'), #FUN-A50102 
                          "(ogd01,ogd03,ogd04,ogd08,ogd09, ",
                          " ogd10,ogd11,ogd12b,ogd12e,ogd13, ",
                          " ogd14,ogd15,ogd16,ogd14t,ogd15t, ",
                          " ogd16t,ogdplant,ogdlegal)",   #FUN-980010
                          " VALUES( ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
                          "         ?,?,? )"    #FUN-980010
 	           CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
               CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
               PREPARE ins_ogd FROM l_sql2
               EXECUTE ins_ogd USING 
                g_ogd.ogd01,g_ogd.ogd03,g_ogd.ogd04,g_ogd.ogd08,g_ogd.ogd09,
                g_ogd.ogd10,g_ogd.ogd11,g_ogd.ogd12b,g_ogd.ogd12e,
                g_ogd.ogd13,
                g_ogd.ogd14,g_ogd.ogd15,g_ogd.ogd16,g_ogd.ogd14t,
                g_ogd.ogd15t,g_ogd.ogd16t,
                gp_plant,gp_legal   #FUN-980010
                IF SQLCA.sqlcode<>0 THEN
                   LET g_showmsg = g_ogd.ogd01,"/",g_ogd.ogd03,"/",g_ogd.ogd04 #No.FUN-710046
                   CALL s_errmsg('ogd01,ogd03,ogd04',g_showmsg,'ins ogd:',SQLCA.sqlcode,1) #No.FUN-710046
                   LET g_success = 'N' EXIT FOREACH 
                END IF
                IF NOT s_industry('std') THEN
                   INITIALIZE l_ogdi.* TO NULL
                   LET l_ogdi.ogdi01 = g_ogd.ogd01
                   LET l_ogdi.ogdi03 = g_ogd.ogd03
                   LET l_ogdi.ogdi04 = g_ogd.ogd04
                   IF NOT s_ins_ogdi(l_ogdi.*,l_plant_new) THEN #FUN-980092 add
                      LET g_success = 'N'
                   END IF
                END IF
            END FOREACH
            #更新包裝單確認碼
            #LET l_sql2="UPDATE ",l_dbs_tra CLIPPED,"oga_file",   #FUN-980092 add
            LET l_sql2="UPDATE ",cl_get_target_table(l_plant_new,'oga_file'), #FUN-A50102
                         " SET oga30 = 'Y' ",
                       " WHERE oga01 = ?  "
 	        CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
            CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
            PREPARE upd_oga30 FROM l_sql2
            EXECUTE upd_oga30 USING l_ogd01
            IF SQLCA.sqlcode<>0 THEN
               CALL s_errmsg('oga01',l_ogd01,'upd oga30:',SQLCA.sqlcode,1) #No.FUN-710046
               LET g_success = 'N' RETURN    #FUN-670007
            END IF
       END IF
    END IF
    #------------- 是否拋轉 Invoice --------------------------
    IF g_oax.oax04='Y' AND g_oaz.oaz67 = '2'  THEN  #NO.FUN-670007
        SELECT COUNT(*) INTO l_cnt FROM ofa_file,ofb_file
         WHERE ofa01=g_oga.oga27 AND ofaconf='Y'
        IF l_cnt = 0 THEN
           LET g_showmsg = g_oga.oga27,"/",'Y'     #No.FUN-710046
           CALL s_errmsg('ofa01,ofaconf',g_showmsg,'sel ofa:',SQLCA.SQLCODE,1) #No.FUN-710046
           LET g_success='N' RETURN   #FUN-67007
        ELSE
           #---INSERT Invoice 單頭檔
           SELECT * INTO g_ofa.* FROM ofa_file
            WHERE ofa01 = g_oga.oga27
           LET g_t1 = s_get_doc_no(g_poy.poy48)         #No.FUN-550070  #MOD-B30267 g_oga.oga27-->g_poy.poy48 
              CALL s_auto_assign_no("axm",g_t1,g_ofa.ofa02,"","ofa_file","ofa01",l_plant_new,"","") #NO.FUN-620024 #FUN-980092 add
              RETURNING li_result,l_ofa01
              IF (NOT li_result) THEN 
                 LET g_msg = l_plant_new CLIPPED,l_ofa01
                 CALL s_errmsg("ofa01",l_ofa01,g_msg CLIPPED,"mfg3046",1) 
                 LET g_success ='N'
                 RETURN
              END IF   
           LET g_ofa.ofa03=p_oea03
           #No.7804 取得帳款客戶之 BILL TO 相關資料
           #LET l_sql = " SELECT * FROM ",l_dbs_new CLIPPED,"occ_file ",
           LET l_sql = " SELECT * FROM ",cl_get_target_table(l_plant_new,'occ_file'), #FUN-A50102
                       "  WHERE occ01 = '",g_ofa.ofa03,"'"
 	       CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
           CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
           PREPARE occ_pre FROM l_sql
           DECLARE occ_cs CURSOR FOR occ_pre
           OPEN occ_cs 
           FETCH occ_cs INTO l_occ.*
           IF SQLCA.SQLCODE THEN
              CALL s_errmsg('occ01',g_ofa.ofa03,l_dbs_new CLIPPED,'anm-045',1)  #No.FUN-710046
              LET g_success = 'N' RETURN   #FUN-670007 
           END IF
           LET g_ofa.ofa032  = l_occ.occ02
           LET g_ofa.ofa0351 = l_occ.occ18
           LET g_ofa.ofa0352 = l_occ.occ19
           LET g_ofa.ofa0353 = l_occ.occ231
           LET g_ofa.ofa0354 = l_occ.occ232
           LET g_ofa.ofa0355 = l_occ.occ233
           LET g_ofa.ofa04=g_oga.oga04
           LET g_ofa.ofa23=l_oga.oga23
           LET g_ofa.ofa24=l_oga.oga24
          #-CHI-940042-add-  
           IF l_oea.oea18 IS NOT NULL AND l_oea.oea18='Y' THEN
              LET g_ofa.ofa24 = l_oea.oea24
           END IF
           IF cl_null(g_ofa.ofa24) THEN LET g_ofa.ofa24=1 END IF
          #-CHI-940042-end-  
           LET g_ofa.ofa99=g_flow99         #No.7993
           LET g_ofa.ofa011 = l_oga.oga01   #NO.TQC-750243
           #LET l_sql2="INSERT INTO ",l_dbs_tra CLIPPED,"ofa_file",   #FUN-980092 add
           LET l_sql2="INSERT INTO ",cl_get_target_table(l_plant_new,'ofa_file'), #FUN-A50102
                       " (ofa00,ofa01,ofa011,ofa02,ofa03,",
                       "  ofa032,ofa033,ofa0351,ofa0352,ofa0353,",
                       "  ofa0354,ofa0355,ofa04,ofa044,ofa0451, ",
                       "  ofa0452,ofa0453,ofa0454,ofa0455,ofa08, ",
                       "  ofa10,ofa16,ofa18,ofa21,ofa211, ",
                       "  ofa212,ofa213,ofa23,ofa24,ofa25, ",
                       "  ofa26,ofa27,ofa28,ofa29,ofa30, ",
                       "  ofa31,ofa32,ofa33,ofa35,ofa36, ",
                       "  ofa37,ofa38,ofa39,ofa41,ofa99, ", #No.7993
                       "  ofa42,ofa43,ofa44,ofa45,ofa46, ",
                       "  ofa47,ofa48,ofa49,ofa50,ofa61, ",
                       "  ofa62,ofa63,ofa71,ofa72,ofa73, ",
                       "  ofa741,ofa742,ofa743,ofa75,ofa76, ",
                       "  ofa77,ofa78,ofa79,ofa908,ofaconf, ",
                       "  ofaprsw,ofauser,ofagrup,ofamodu,ofadate, ",
                       "  ofaplant,ofalegal , ",
                       "  ofaud01,ofaud02,ofaud03,ofaud04,ofaud05,",            
                       "  ofaud06,ofaud07,ofaud08,ofaud09,ofaud10,",            
                       "  ofaud11,ofaud12,ofaud13,ofaud14,ofaud15,ofaoriu,ofaorig)",#FUN-A10036            
                       " VALUES(?,?,?,?,?, ?,?,?,?,?, ",
                       "        ?,?,?,?,?, ?,?,?,?,?, ",
                       "        ?,?,?,?,?, ?,?,?,?,?, ",
                       "        ?,?,?,?,?, ?,?,?,?,?, ",
                       "        ?,?,?,?,?, ?,?,?,?,?, ",    #No.CHI-950020
                       "        ?,?,?,?,?,",                #No.CHI-950020
                       "        ?,?,?,?,?, ?,?,?,?,?, ",
                       "        ?,?,?,?,?, ?,?,?,?,?, ",
                       "        ?,?,?,?,?, ?,?,?,?,?,  ",
                       "        ?,?,?,?,?, ?,?,?,?) "   #FUN-980010  #FUN-A10036
 	        CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
            CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
            PREPARE ins_ofa FROM l_sql2
            EXECUTE ins_ofa USING 
                     g_ofa.ofa00,l_ofa01,g_ofa.ofa011,g_ofa.ofa02,
                     g_ofa.ofa03,
                     g_ofa.ofa032,g_ofa.ofa033,g_ofa.ofa0351,
                     g_ofa.ofa0352,g_ofa.ofa0353,
                     g_ofa.ofa0354,g_ofa.ofa0355,g_ofa.ofa04,
                     g_ofa.ofa044,g_ofa.ofa0451,
                     g_ofa.ofa0452,g_ofa.ofa0453,g_ofa.ofa0454,
                     g_ofa.ofa0455,g_ofa.ofa08,
                     g_ofa.ofa10,g_ofa.ofa16,g_ofa.ofa18,g_ofa.ofa21,
                     g_ofa.ofa211,
                     g_ofa.ofa212,g_ofa.ofa213,g_ofa.ofa23,g_ofa.ofa24,
                     g_ofa.ofa25,
                     g_ofa.ofa26,g_ofa.ofa27,g_ofa.ofa28,g_ofa.ofa29,
                     g_ofa.ofa30,
                     g_ofa.ofa31,g_ofa.ofa32,g_ofa.ofa33,g_ofa.ofa35,
                     g_ofa.ofa36,
                     g_ofa.ofa37,g_ofa.ofa38,g_ofa.ofa39,
                     g_ofa.ofa41,g_ofa.ofa99,
                     g_ofa.ofa42,g_ofa.ofa43,g_ofa.ofa44,g_ofa.ofa45,
                     g_ofa.ofa46,
                     g_ofa.ofa47,g_ofa.ofa48,g_ofa.ofa49,g_ofa.ofa50,
                     g_ofa.ofa61,
                     g_ofa.ofa62,g_ofa.ofa63,g_ofa.ofa71,g_ofa.ofa72,
                     g_ofa.ofa73,
                     g_ofa.ofa741,g_ofa.ofa742,g_ofa.ofa743,g_ofa.ofa75,
                     g_ofa.ofa76,
                     g_ofa.ofa77,g_ofa.ofa78,g_ofa.ofa79,g_ofa.ofa908,
                     g_ofa.ofaconf,
                     g_ofa.ofaprsw,g_ofa.ofauser,g_ofa.ofagrup,
                     g_ofa.ofamodu,g_ofa.ofadate,
                     gp_plant,gp_legal   #FUN-980010
                    ,g_ofa.ofaud01,g_ofa.ofaud02,g_ofa.ofaud03,                 
                     g_ofa.ofaud04,g_ofa.ofaud05,g_ofa.ofaud06,                 
                     g_ofa.ofaud07,g_ofa.ofaud08,g_ofa.ofaud09,                 
                     g_ofa.ofaud10,g_ofa.ofaud11,g_ofa.ofaud12,                 
                     g_ofa.ofaud13,g_ofa.ofaud14,g_ofa.ofaud15,g_user,g_grup  #FUN-A10036                  
               IF SQLCA.sqlcode<>0 THEN
                  CALL s_errmsg('ofa01',l_ofa01,'ins ofa:',SQLCA.sqlcode,1) #No.FUN-710046
                  LET g_success = 'N' RETURN  #FUN-670007
               END IF
           #---INSERT Invoice 單身檔
           DECLARE ofb_cs CURSOR FOR
            SELECT * FROM ofb_file WHERE ofb01=g_ofa.ofa01
           FOREACH ofb_cs INTO g_ofb.*
               #重取invoice 單身訂單編號
                LET l_sql1= " SELECT oea99 ",
                            "   FROM oea_file ",
                            "  WHERE oea01 = '",g_ofb.ofb31,"'"
                PREPARE oea99_pre2 FROM l_sql1
                DECLARE oea99_cus2 CURSOR FOR oea99_pre2
                OPEN oea99_cus2
                FETCH oea99_cus2 INTO g_oea.oea99
                CLOSE oea99_cus2
                LET l_sql1 = "SELECT oea01 ",
                             #"  FROM ",l_dbs_tra CLIPPED,"oea_file" ,   #FUN-980092 add
                             "  FROM ",cl_get_target_table(l_plant_new,'oea_file'), #FUN-A50102
                             " WHERE oea99 ='",g_oea.oea99,"'" 
 	            CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
                CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-980092
                PREPARE oeb_p2 FROM l_sql1
                IF SQLCA.SQLCODE THEN CALL cl_err('oeb_p1',SQLCA.SQLCODE,1) END IF
                DECLARE oeb_c2 CURSOR FOR oeb_p2
                OPEN oeb_c2
                FETCH oeb_c2 INTO g_ofb.ofb31
                IF SQLCA.SQLCODE <> 0 THEN
                   LET g_success='N'
                   RETURN
                END IF
                CLOSE oeb_c2
 
               LET l_sql1 = "SELECT * ",
                            #" FROM ",l_dbs_tra CLIPPED,"oeb_file ",  #FUN-980092 add
                            " FROM ",cl_get_target_table(l_plant_new,'oeb_file'), #FUN-A50102
                            " WHERE oeb01='",g_ofb.ofb31,"' ",
                            "   AND oeb03=",g_ofb.ofb32
 	           CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
               CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-980092
               PREPARE oeb_p3 FROM l_sql1
               IF SQLCA.SQLCODE THEN 
                  LET g_showmsg = g_ofb.ofb31,"/",g_ofb.ofb32    #No.FUN-710046
                  CALL s_errmsg('oeb01,oeb03',g_showmsg,'oeb_p3',SQLCA.SQLCODE,1) #No.FUN-710046
                  LET g_success = 'N' EXIT FOREACH
               END IF
               DECLARE oeb_c3 CURSOR FOR oeb_p3
               OPEN oeb_c3
               FETCH oeb_c3 INTO p_oeb.*
               CLOSE oeb_c3
               IF g_oax.oax03 = 'N' OR s_aza.aza50 ='Y' THEN   #NO.FUN-670007
                   LET g_ofb.ofb13=p_oeb.oeb13
                   IF g_ofa.ofa213 = 'N'
                      THEN LET g_ofb.ofb14 =g_ofb.ofb917*g_ofb.ofb13  #MOD-7A0051 modify ofb12->ofb917
                           LET g_ofb.ofb14t=g_ofb.ofb14*(1+g_ofa.ofa211/100)
                   ELSE LET g_ofb.ofb14t=g_ofb.ofb917*g_ofb.ofb13      #MOD-7A0051 modify ofb12->ofb917
                        LET g_ofb.ofb14 =g_ofb.ofb14t/(1+g_ofa.ofa211/100)
                   END IF
               ELSE
                   #出貨必須重新計算價格, 因為分批出貨時, 有可能計價方式亦改變了
                   #依計價方式來判斷價格
                   CASE p_pox05
                      WHEN '1'
                         IF p_pox03='1' THEN   #依來源工廠 
                            #單價*比率
                            #modi in 00/02/23 (換算匯率) NO:1218
                            IF g_oea.oea23=l_oga.oga23 THEN
                               LET g_ofb.ofb13 = g_ofb.ofb13 * p_pox06 / 100
                            END IF
                            IF g_oea.oea23 <> l_oga.oga23 THEN
                               LET l_price = g_ofb.ofb13 * g_oea.oea24 #換算為台幣
                               ##依計價幣別抓來源廠的匯率 no:3463
                               CALL s_currm(g_ofa.ofa23,l_oga.oga02,
                                            g_oax.oax01,t_plant) #FUN-980020
                                   RETURNING l_currm
                               LET g_ofb.ofb13 = l_price / l_currm * p_pox06/100
                            END IF
                            IF cl_null(l_azi.azi03) THEN
                               LET l_azi.azi03=5
                            END IF
                            CALL cl_digcut(g_ofb.ofb13,l_azi.azi03)
                                      RETURNING g_ofb.ofb13
                         ELSE
                            #依上游廠商計算, 先讀取S/O價格
                            IF i=1 THEN
                               #單價*比率
                               #modi in 00/02/23 (換算匯率) NO:1218
                               IF g_oea.oea23=l_oga.oga23 THEN
                                  LET g_ofb.ofb13 = g_ofb.ofb13 * p_pox06 / 100
                               END IF
                               IF g_oea.oea23 <> l_oga.oga23 THEN
                                  LET l_price = g_ofb.ofb13 * g_oea.oea24 #換算為台幣
                                  ##依計價幣別抓來源廠的匯率 no:3463
                                  CALL s_currm(g_ofa.ofa23,l_oga.oga02,
                                               g_oax.oax01,t_plant)   #FUN-980020
                                      RETURNING l_currm
                                  LET g_ofb.ofb13 = l_price / l_currm * p_pox06/100
                               END IF
                               IF cl_null(l_azi.azi03) THEN
                                  LET l_azi.azi03=5
                               END IF
                               CALL cl_digcut(g_ofb.ofb13,l_azi.azi03)
                                         RETURNING g_ofb.ofb13
                            ELSE
                               LET l_no = i-1
                               SELECT pab_price,pab_curr INTO l_price,l_curr
                                 FROM p820_file
                                WHERE p_no = l_no
                                  AND pab_no = l_ofa01
                                  AND pab_item=g_ofb.ofb03
                                  AND pab_type='2'
                               #modi in 00/02/23 (換算匯率) NO:1218
                               IF l_curr != g_ofa.ofa23 THEN
                                  CALL s_currm(l_curr,l_oga.oga02,
                                               g_oax.oax01,t_plant)  #FUN-980020
                                   RETURNING x_currm
                                  LET l_price = l_price * x_currm   #換算成本幣
                                  #依計價幣別抓來源廠的匯率 no:3463  
                                  CALL s_currm(g_ofa.ofa23,l_oga.oga02,
                                               g_oax.oax01,t_plant)  #FUN-980020
                                   RETURNING l_currm
                                  LET g_ofb.ofb13 = l_price / l_currm
                                                                 * p_pox06/100
                               ELSE
                                  #單價*比率
                                  LET g_ofb.ofb13= l_price * p_pox06/100
                               END IF
                             END IF  
                         END IF
                         CALL cl_digcut(g_ofb.ofb13,l_azi.azi03) 
                               RETURNING g_ofb.ofb13
                      WHEN '2'
                         #讀取合乎料件條件之價格
                         CALL s_pow(g_oea.oea904,g_ofb.ofb04,p_poy04,g_oga.oga02)
                                RETURNING g_sw,g_ofb.ofb13
                          IF g_sw='N' THEN
                            CALL s_errmsg('','','sel pow:','axm-333',1) #No.FUN-710046
                            LET g_success = 'N'
                          END IF
                          CALL cl_digcut(g_ofb.ofb13,l_azi.azi03) 
                          RETURNING g_ofb.ofb13
                      WHEN '3'   #單價若為0, 則給0, 否則抓料件之固定價格
                          IF g_ofb.ofb13 <> 0 THEN
                             CALL s_pow(g_oea.oea904,g_ofb.ofb04,p_poy04,g_oga.oga02)
                                RETURNING g_sw,g_ofb.ofb13
                             IF g_sw='N' THEN
                                CALL s_errmsg('','','sel pow:','axm-333',1) #No.FUN-710046
                                LET g_success = 'N'
                             END IF
                          ELSE
                             LET g_ofb.ofb13 = 0
                          END IF
                          CALL cl_digcut(g_ofb.ofb13,l_azi.azi03) 
                          RETURNING g_ofb.ofb13
                   END CASE
                   IF g_ofb.ofb13 IS NULL THEN LET g_ofb.ofb13 =0 END IF
                   IF g_ofa.ofa213 = 'N'
                      THEN LET g_ofb.ofb14 =g_ofb.ofb917*g_ofb.ofb13  #MOD-7A0051 modify ofb12->ofb917
                           LET g_ofb.ofb14t=g_ofb.ofb14*(1+g_ofa.ofa211/100)
                   ELSE LET g_ofb.ofb14t=g_ofb.ofb917*g_ofb.ofb13      #MOD-7A0051 modify ofb12->ofb917
                        LET g_ofb.ofb14 =g_ofb.ofb14t/(1+g_ofa.ofa211/100)
                   END IF
               END IF
               CALL cl_digcut(g_ofb.ofb14,l_azi.azi04) RETURNING g_ofb.ofb14
               CALL cl_digcut(g_ofb.ofb14t,l_azi.azi04) RETURNING g_ofb.ofb14t
               #LET l_sql2="INSERT INTO ",l_dbs_tra CLIPPED,"ofb_file",   #FUN-980092 add
               LET l_sql2="INSERT INTO ",cl_get_target_table(l_plant_new,'ofb_file'), #FUN-A50102
                          " (ofb01,ofb03,ofb04,ofb05,ofb06,",
                          " ofb07,ofb11,ofb12,ofb13,",
                          " ofb14,ofb14t,ofb31,ofb32,ofb33,",
                         #" ofb34,ofb35,ofbplant,ofblegal )", #MOD-B30267 mark
                          " ofb34,ofb35,ofbplant,ofblegal ,", #MOD-B30267 add
                          " ofbud01,ofbud02,ofbud03,ofbud04,ofbud05,",
                          " ofbud06,ofbud07,ofbud08,ofbud09,ofbud10,",
                          " ofbud11,ofbud12,ofbud13,ofbud14,ofbud15)",
                          " VALUES(?,?,?,?,?, ?,?,?,?,?, ",
                          "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",    #No.CHI-950020
                          "        ?,?,?,?,?, ?,?,? )"         #FUN-980010
 	           CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
               CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
               PREPARE ins_ofb FROM l_sql2
               EXECUTE ins_ofb USING 
               l_ofa01,g_ofb.ofb03,g_ofb.ofb04,g_ofb.ofb05,g_ofb.ofb06,
               g_ofb.ofb07,g_ofb.ofb11,g_ofb.ofb12,g_ofb.ofb13,
               g_ofb.ofb14,g_ofb.ofb14t,g_ofb.ofb31,g_ofb.ofb32,g_ofb.ofb33,
               g_ofb.ofb34,g_ofb.ofb35,
               gp_plant,gp_legal   #FUN-980010
              ,g_ofb.ofbud01,g_ofb.ofbud02,g_ofb.ofbud03,
               g_ofb.ofbud04,g_ofb.ofbud05,g_ofb.ofbud06,
               g_ofb.ofbud07,g_ofb.ofbud08,g_ofb.ofbud09,
               g_ofb.ofbud10,g_ofb.ofbud11,g_ofb.ofbud12,
               g_ofb.ofbud13,g_ofb.ofbud14,g_ofb.ofbud15
               IF SQLCA.sqlcode<>0 THEN
                  LET g_showmsg = l_ofa01,"/",g_ofb.ofb03  #No.FUN-710046
                  CALL s_errmsg('ofb01,ofb03',g_showmsg,'ins ofb:',SQLCA.sqlcode,1)  #No.FUN-710046
                  LET g_success = 'N' EXIT FOREACH 
               END IF
               #新增至暫存檔中
               INSERT INTO p820_file VALUES(i,l_ofa01,g_ofb.ofb03,
                                     g_ofb.ofb13,g_ofa.ofa23,'2')
               IF SQLCA.sqlcode<>0 THEN
                  CALL s_errmsg('','','ins p820_file:',SQLCA.sqlcode,1)   #No.FUN-710046
                  LET g_success = 'N'
               END IF
        END FOREACH
        #-------- no.3995 02/01/17 重計單頭金額 ---------------
        #LET l_sql ="SELECT SUM(ofb14) FROM ",l_dbs_tra CLIPPED,  #FUN-980092 add
        #           " ofb_file ",
        LET l_sql ="SELECT SUM(ofb14) FROM ",cl_get_target_table(l_plant_new,'ofb_file'), #FUN-A50102 
                   " WHERE ofb01 ='", l_ofa01,"'"
 	    CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
        PREPARE ofa50_pre FROM l_sql
        DECLARE ofa50_cs CURSOR FOR ofa50_pre
        OPEN ofa50_cs
        FETCH ofa50_cs INTO g_ofa.ofa50
        IF SQLCA.SQLCODE THEN
           CALL s_errmsg('ofb01',l_ofa01,'sum ofa14:',SQLCA.SQLCODE,1) #No.FUN-710046
           LET g_success='N'
        END IF
        #LET l_sql =" UPDATE ",l_dbs_tra CLIPPED," ofa_file ",  #FUN-980092 add
        LET l_sql =" UPDATE ",cl_get_target_table(l_plant_new,'ofa_file'), #FUN-A50102 
                   "    SET ofa50 =",g_ofa.ofa50,
                   " WHERE ofa01 = '",l_ofa01,"'"
 	    CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
        PREPARE upofa50_pre FROM l_sql
        EXECUTE upofa50_pre
        IF SQLCA.SQLCODE THEN
           CALL s_errmsg('ofa01',l_ofa01,'upd ofa50:',SQLCA.SQLCODE,0) #No.FUN-710046
        END IF
        #No.7993  出貨單
        #LET l_sql = "UPDATE ",l_dbs_tra CLIPPED, "oga_file",   #FUN-980092 add
        LET l_sql = "UPDATE ",cl_get_target_table(l_plant_new,'oga_file'), #FUN-A50102 
                     "  SET oga27  =  ? ",
                    " WHERE oga01 = '",l_oga.oga01,"'"
 	    CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
        PREPARE ofa27_upd1 FROM l_sql
        EXECUTE ofa27_upd1 USING l_ofa01
        #出貨通知單
        #LET l_sql = "UPDATE ",l_dbs_tra CLIPPED, "oga_file",  #FUN-980092 add
        LET l_sql = "UPDATE ",cl_get_target_table(l_plant_new,'oga_file'), #FUN-A50102 
                    "  SET oga27  =  ? ",
                    " WHERE oga01 = '",x_oga.oga01,"'"
 	    CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
        PREPARE ofa27_upd2 FROM l_sql
        EXECUTE ofa27_upd2 USING l_ofa01
           END IF
        END IF
END FUNCTION
 
#判斷目前之下游廠商為何,並得知S/O及P/O之客戶/廠商代碼 
FUNCTION p820_azp(l_n)
  DEFINE l_source LIKE type_file.num5,   #來源站別 #No.FUN-680137 SMALLINT
         l_n      LIKE type_file.num5,   #當站站別 #No.FUN-680137 SMALLINT
        #l_sql1   LIKE type_file.chr1000, #No.FUN-680137 VARCHAR(800)   #CHI-940042 mark
         l_sql1   STRING,                 #CHI-940042 
         l_front  LIKE type_file.num5,    #FUN-670007
         l_next   LIKE type_file.num5     #FUN-670007
 
     ##-------------取得前一資料庫(收貨/入庫單)-----------------
      LET l_front = l_n - 1
      LET l_source = l_n 
      LET l_next = l_n + 1   
 
      SELECT * INTO s_poy.* FROM poy_file 
      WHERE poy01 = g_poz.poz01 AND poy02 = l_front   #FUN-670007
 
     SELECT * INTO s_azp.* FROM azp_file WHERE azp01 = s_poy.poy04
     LET s_dbs_new = s_azp.azp03 CLIPPED,"."
 
     LET g_plant_new = s_azp.azp01
     LET s_plant_new = g_plant_new
     CALL s_gettrandbs()
     LET s_dbs_tra = g_dbs_tra
 
     LET l_sql1 = "SELECT * ",                         #取得來源本幣
                  #" FROM ",s_dbs_new CLIPPED,"aza_file ",
                  " FROM ",cl_get_target_table(s_plant_new,'aza_file'), #FUN-A50102
                  " WHERE aza01 = '0' "
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,s_plant_new) RETURNING l_sql1 #FUN-A50102
     PREPARE aza_p1 FROM l_sql1
     IF SQLCA.SQLCODE THEN 
        CALL s_errmsg('aza01','0','aza_p2',SQLCA.SQLCODE,0) #No.FUN-710046
     END IF
     DECLARE aza_c1  CURSOR FOR aza_p1
     OPEN aza_c1 
     FETCH aza_c1 INTO s_aza.* 
     CLOSE aza_c1
     LET s_imd01 = s_poy.poy11
 
     ##-------------取得當站資料庫(出貨)-----------------
      SELECT * INTO g_poy.* FROM poy_file               #取得當站流程設定
       WHERE poy01 = g_poz.poz01 AND poy02 = l_n
 
      SELECT * INTO l_azp.* FROM azp_file WHERE azp01=g_poy.poy04
      LET l_plant_new = l_azp.azp01                     #FUN-980020
      LET l_dbs_new = l_azp.azp03 CLIPPED,"."
 
     #--FUN-980092 add----GP5.2 Modify #改抓Transaction DB
      LET g_plant_new = l_azp.azp01
      LET l_plant_new = g_plant_new
      CALL s_gettrandbs()
      LET l_dbs_tra = g_dbs_tra
 
      LET l_sql1 = "SELECT * ",
                   #" FROM ",l_dbs_new CLIPPED,"aza_file ",
                   " FROM ",cl_get_target_table(l_plant_new,'aza_file'), #FUN-A50102
                   " WHERE aza01 = '0' "
 	  CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
      CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-A50102
      PREPARE aza_p2 FROM l_sql1
      IF SQLCA.SQLCODE THEN 
         CALL s_errmsg('aza01','0','aza_p2',SQLCA.SQLCODE,0)  #No.FUN-710046
      END IF
      DECLARE aza_c2 CURSOR FOR aza_p2
      OPEN aza_c2
      FETCH aza_c2 INTO l_aza.* 
      CLOSE aza_c2
      LET p_oea03 = s_poy.poy03    #帳款客戶(上游廠商)
      LET p_pmm09 = g_poy.poy03    #廠商
      LET p_poz03 = g_poy.poy20    #營業額申報方式
      LET p_poy04 = g_poy.poy04    #工廠編號
      IF g_poz.poz09 = 'Y' THEN    #指定幣別
         LET p_azi01 = g_poy.poy05 #流程幣別
      ELSE
         LET p_azi01 = g_oea.oea23 #接單幣別
      END IF
      LET p_poy06 = g_poy.poy06    #付款條件
      LET p_poy07 = g_poy.poy07    #收款條件
      LET p_poy08 = g_poy.poy08    #S/O 稅別
      LET p_poy09 = g_poy.poy09    #P/O 稅別
      LET p_poy10 = g_poy.poy10    #銷售分類
      LET p_poy12 = g_poy.poy12    #發票別 
      LET p_poy16 = g_poy.poy16    #AR科目類別 #MOD-940299
      LET p_poy28 = g_poy.poy28    #NO.FUN-620024
      LET p_poy29 = g_poy.poy29    #NO.FUN-620024
      LET p_imd01 = g_poy.poy11    #倉庫別
END FUNCTION
 
#讀取幣別檔之資料
#FUNCTION p820_azi(l_oga23,l_dbs)        #FUN-670007
FUNCTION p820_azi(l_oga23,l_plant)        #FUN-A50102
 #DEFINE l_sql1  LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(800)   #CHI-940042 mark
  DEFINE l_sql1  STRING                 #CHI-940042 
  DEFINE l_oga23 LIKE oga_file.oga23
  #DEFINE l_dbs   LIKE type_file.chr21     #FUN-670007
  DEFINE l_plant LIKE type_file.chr10  #FUN-A50102
 
   #讀取s_dbs_new 之本幣資料
   LET l_sql1 = "SELECT * ",
                #" FROM ",l_dbs CLIPPED,"azi_file ",   #FUN-670007
                " FROM ",cl_get_target_table(l_plant,'azi_file'), #FUN-A50102
                " WHERE azi01='",s_aza.aza17,"' "
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,l_plant) RETURNING l_sql1 #FUN-A50102
   PREPARE azi_p1 FROM l_sql1
   IF SQLCA.SQLCODE THEN
      CALL s_errmsg('azi01',s_aza.aza17,'azi_p1',SQLCA.SQLCODE,0) #No.FUN-710046
   END IF
   DECLARE azi_c1 CURSOR FOR azi_p1
   OPEN azi_c1
   FETCH azi_c1 INTO s_azi.* 
   CLOSE azi_c1
   #讀取l_dbs_new 之原幣資料
   LET l_sql1 = "SELECT * ",
                #" FROM ",l_dbs CLIPPED,"azi_file ",    #FUN-670007
                " FROM ",cl_get_target_table(l_plant,'azi_file'), #FUN-A50102 
                " WHERE azi01='",l_oga23,"' " 
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,l_plant) RETURNING l_sql1 #FUN-A50102
   PREPARE azi_p2 FROM l_sql1
   IF SQLCA.SQLCODE THEN
      CALL s_errmsg('azi01',l_oga23,'azi_p2',SQLCA.SQLCODE,0) #No.FUN-710046
   END IF
   DECLARE azi_c2 CURSOR FOR azi_p2
   OPEN azi_c2
   FETCH azi_c2 INTO l_azi.* 
   CLOSE azi_c2
END FUNCTION
 
FUNCTION p820_ogains()
 #DEFINE l_sql  LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1200)   #CHI-940042 mark
 #DEFINE l_sql1 LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(600)    #CHI-940042 mark
  DEFINE l_sql,l_sql1,l_sql2 STRING   #CHI-950020 #CHI-940042        
  DEFINE i,l_i  LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE li_result LIKE type_file.num5     #TQC-9B0013
   
  #讀取該流程代碼之銷單資料
   LET l_sql1 = "SELECT * ",
                #" FROM ",l_dbs_tra CLIPPED,"oea_file ",  #FUN-980092 add
                " FROM ",cl_get_target_table(l_plant_new,'oea_file'), #FUN-A50102
                " WHERE oea99='",g_oea.oea99,"' ",     #NO.FUN-620024
                "   AND oeaconf = 'Y' " #01/08/16 mandy
    CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
    CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-980092
   PREPARE oea_p1 FROM l_sql1
   IF SQLCA.SQLCODE THEN 
      LET g_showmsg = g_oea.oea01,"/",g_oea.oea99,"/",'Y' #No.FUN-710046
      CALL s_errmsg('oea01,oea99,oeaconf',g_showmsg,'oea_p1',SQLCA.SQLCODE,0) #No.FUN-710046
   END IF
   DECLARE oea_c1 CURSOR FOR oea_p1
   OPEN oea_c1
   FETCH oea_c1 INTO l_oea.*
   IF SQLCA.SQLCODE <> 0 THEN
      CALL s_errmsg('oea01,oea99,oeaconf',g_showmsg,'oea_p1',SQLCA.SQLCODE,0) #No.TQC-930155
      LET g_success='N'
      RETURN
   END IF
   CLOSE oea_c1
 
  #新增出貨單單頭檔(oga_file)
        CALL s_auto_assign_no("axm",oga_t1,g_oga.oga02,"","oga_file","oga01",l_plant_new,"","") #NO.FUN-620024 #FUN-980092 add
        RETURNING li_result,l_oga.oga01
        IF (NOT li_result) THEN 
           LET g_msg = l_plant_new CLIPPED,l_oga.oga01
           CALL s_errmsg("oga01",l_oga.oga01,g_msg CLIPPED,"mfg3046",1) 
           LET g_success ='N'
           RETURN
        END IF   
 
    IF cl_null(l_oga99) THEN
       LET l_oga.oga011=g_oga.oga011        #出貨通知單號
    ELSE
       LET l_sql1 = "SELECT * ",
                    #"  FROM ",l_dbs_new CLIPPED,"oga_file ",
                    "  FROM ",cl_get_target_table(l_plant_new,'oga_file'), #FUN-A50102
                    " WHERE oga99 ='",l_oga99,"' ",
                    "   AND oga09 = '5' "
       CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1		#FUN-920032
       CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-A50102
       PREPARE oga_p1 FROM l_sql1
      
       DECLARE oga_c1 CURSOR FOR oga_p1
      
       OPEN oga_c1
       FETCH oga_c1 INTO s_oga.*
          LET l_oga.oga011= s_oga.oga01       #出貨通知單號
    END IF
    LET l_oga.oga00 = l_oea.oea00        #出貨別
    LET l_oga.oga02 = g_oga.oga02        #出貨日期
    LET l_oga.oga021= g_oga.oga021       #結關日期
    LET l_oga.oga022= g_oga.oga022       #裝船日期
    LET l_oga.oga03 = l_oea.oea03
    LET l_oga.oga032= l_oea.oea032
    LET l_oga.oga033= l_oea.oea033
    LET l_oga.oga04 = l_oea.oea04
    LET l_oga.oga044= l_oea.oea044
    LET l_oga.oga05 = l_oea.oea05
    LET l_oga.oga06 = l_oea.oea06
    LET l_oga.oga07 = l_oea.oea07
    LET l_oga.oga08 = l_oea.oea08
    LET l_oga.oga09 = '4'
    LET l_oga.oga10 = null
    LET l_oga.oga11 = null
    LET l_oga.oga12 = null
    LET l_oga.oga13 = p_poy16                      #MOD-940299 add
    LET l_oga.oga14 = l_oea.oea14
    LET l_oga.oga15 = l_oea.oea15
    IF cl_null(g_oga.oga16) THEN
       LET l_oga.oga16 = g_oga.oga16
    ELSE 
       LET l_oga.oga16 = l_oea.oea01                     #NO.FUN-620024
    END IF
    LET l_oga.oga161= l_oea.oea161
    LET l_oga.oga162= l_oea.oea162
    LET l_oga.oga163= l_oea.oea163
    LET l_oga.oga18 = l_oea.oea17
    LET l_oga.oga19 = null
    LET l_oga.oga20 = 'Y'
    LET l_oga.oga21 = l_oea.oea21
    LET l_oga.oga211= l_oea.oea211
    LET l_oga.oga212= l_oea.oea212
    LET l_oga.oga213= l_oea.oea213
    LET l_oga.oga23 = l_oea.oea23
    LET l_oga.ogaud01 = g_oga.ogaud01
    LET l_oga.ogaud02 = g_oga.ogaud02
    LET l_oga.ogaud03 = g_oga.ogaud03
    LET l_oga.ogaud04 = g_oga.ogaud04
    LET l_oga.ogaud05 = g_oga.ogaud05
    LET l_oga.ogaud06 = g_oga.ogaud06
    LET l_oga.ogaud07 = g_oga.ogaud07
    LET l_oga.ogaud08 = g_oga.ogaud08
    LET l_oga.ogaud09 = g_oga.ogaud09
    LET l_oga.ogaud10 = g_oga.ogaud10
    LET l_oga.ogaud11 = g_oga.ogaud11
    LET l_oga.ogaud12 = g_oga.ogaud12
    LET l_oga.ogaud13 = g_oga.ogaud13
    LET l_oga.ogaud14 = g_oga.ogaud14
    LET l_oga.ogaud15 = g_oga.ogaud15
    #CALL p820_azi(l_oea.oea23,l_dbs_new)   #讀取幣別資料   #FUN-670007
    CALL p820_azi(l_oea.oea23,l_plant_new)    #FUN-A50102
 
    #出貨時重新抓取匯率
    CALL s_currm(l_oga.oga23,l_oga.oga02,g_oax.oax01,l_plant_new)   #NO.FUN-980020
        RETURNING l_oga.oga24
 
    #若出貨單頭之幣別=本幣幣別, 則匯率給1, (COI美金立帳, 99.03.05)
    IF l_oga.oga23 = l_aza.aza17 THEN
       LET l_oga.oga24=1
    END IF
    IF cl_null(l_oga.oga24) THEN LET l_oga.oga24=l_oea.oea24 END IF
   #-CHI-940042-add-  
    IF l_oea.oea18 IS NOT NULL AND l_oea.oea18='Y' THEN
       LET l_oga.oga24 = l_oea.oea24
    END IF
    IF cl_null(l_oga.oga24) THEN LET l_oga.oga24=1 END IF
   #-CHI-940042-end-  
    LET l_oga.oga25 = l_oea.oea25
    LET l_oga.oga26 = l_oea.oea26
    LET l_oga.oga27 = g_oga.oga27
    LET l_oga.oga28 = l_oea.oea18
    LET l_oga.oga29 = 0
    LET l_oga.oga30 = g_oga.oga30  #MOD-7A0156 modify 'N'
    LET l_oga.oga31 = l_oea.oea31
    LET l_oga.oga32 = l_oea.oea32
    LET l_oga.oga33 = l_oea.oea33
    LET l_oga.oga34 = 0
    LET l_oga.oga35 = g_oga.oga35
    LET l_oga.oga36 = g_oga.oga36
    LET l_oga.oga37 = g_oga.oga37
    LET l_oga.oga38 = g_oga.oga38
    LET l_oga.oga39 = g_oga.oga39
    LET l_oga.oga40 = l_oea.oea19
    LET l_oga.oga41 = l_oea.oea41
    LET l_oga.oga42 = l_oea.oea42
    LET l_oga.oga43 = l_oea.oea43
    LET l_oga.oga44 = l_oea.oea44
    LET l_oga.oga45 = l_oea.oea45
    LET l_oga.oga46 = l_oea.oea46
    LET l_oga.oga47 = g_oga.oga47
    LET l_oga.oga48 = g_oga.oga48
    LET l_oga.oga49 = g_oga.oga49
    LET l_oga.oga50 = 0
    LET l_oga.oga52 = 0
    LET l_oga.oga53 = 0
    LET l_oga.oga54 = 0
    LET l_oga.oga57 = '1'             #FUN-AC0055 add
    LET l_oga.oga65 = l_oea.oea65     #FUN-7B0091 add
    LET l_oga.oga69 = g_oga.oga69     #FUN-670007
    LET l_oga.oga99 = g_flow99    #No.7993
    LET l_oga.oga901='N'
    LET l_oga.oga905='Y'
    LET l_oga.oga906='N'
    LET l_oga.oga909='Y'
    LET l_oga.oga903 = g_oga.oga903  #MOD-7A0156
    LET l_oga.ogamksg = g_oga.ogamksg  #MOD-7A0156
    IF s_aza.aza50 = 'Y' THEN
       LET l_oga.oga1001 = l_oea.oea1001  #收款客戶編號
       LET l_oga.oga1002 = l_oea.oea1002  #債權代碼
       LET l_oga.oga1003 = l_oea.oea1003  #業績歸屬方
       LET l_oga.oga1004 = l_oea.oea1004  #代送商
       LET l_oga.oga1005 = l_oea.oea1005  #是否計算業績
       LET l_oga.oga1006 = l_oea.oea1006  #未稅金額
       LET l_oga.oga1007 = l_oea.oea1007  #含稅金額
       LET l_oga.oga1008 = 0              #出貨總含稅金額
       LET l_oga.oga1009 = l_oea.oea1009  #客戶所屬渠道
       LET l_oga.oga1010 = l_oea.oea1010  #客戶所屬方
       LET l_oga.oga1011 = l_oea.oea1011  #開票客戶
       LET l_oga.oga1012 = ''             #銷退單單號
       LET l_oga.oga1013 = 'N'            #已打印提單否
       LET l_oga.oga1014 = 'N'            #是否對應代送銷退單
       LET l_oga.oga1015 = '0'            #導物流狀況碼
    END IF
    LET l_oga.ogaconf='Y'
    LET l_oga.oga55 = '1' #MOD-C40162 add
    LET l_oga.ogapost='Y'
    LET l_oga.ogaprsw=0
    LET l_oga.ogauser=g_user
    LET l_oga.ogagrup=g_grup
    LET l_oga.ogamodu=null
    LET l_oga.ogadate=null
 
    #新增出貨單頭檔(oga_file)
    #LET l_sql2="INSERT INTO ",l_dbs_tra CLIPPED,"oga_file",  #FUN-980092 add
    LET l_sql2="INSERT INTO ",cl_get_target_table(l_plant_new,'oga_file'), #FUN-A50102
               "( oga00,oga01,oga011,oga02, ",
               "  oga021,oga022,oga03,oga032,",
               "  oga033,oga04,oga044,oga05,",
               "  oga06,oga07,oga08,oga09,",
               "  oga10,oga11,oga12,oga13,",
               "  oga14,oga15,oga16,oga161,",
               "  oga162,oga163,oga17,oga18,",
               "  oga19,oga20,oga21,oga211,",
               "  oga212,oga213,oga23,oga24,",
               "  oga25,oga26,oga27,oga28,",
               "  oga29,oga30,oga31,oga32,",
               "  oga33,oga34,oga35,",
               "  oga36,oga37,oga38,oga39,",
               "  oga40,oga41,oga42,oga43,",
               "  oga44,oga45,oga46,oga47,",
               "  oga48,oga49,oga50,oga52,",
               "  oga53,oga54,oga57,oga65,oga99,",          #No.7993   #FUN-7B0091 add oga65  #FUN-AC0055 add oga57
               "  oga69,",                            #FUN-670007
               "  oga901,oga902,",
               "  oga903,oga904,oga905,oga906,",
               "  oga907,oga908,oga909,oga1001,",     #NO.FUN-620024
               "  oga1002,oga1003,oga1004,oga1005,",  #NO.FUN-620024               
               "  oga1006,oga1007,oga1008,oga1009,",  #NO.FUN-620024
               "  oga1010,oga1011,oga1012,oga1013,",  #NO.FUN-620024
               "  oga1014,oga1015,ogaconf,oga55,",    #NO.FUN-620024 #MOD-C40162 add oga55
               "  ogapost,ogaprsw,ogauser,ogagrup,",
               "  ogamodu,ogadate,ogamksg,ogaplant,ogalegal, ",
               "  ogaud01,ogaud02,ogaud03, ",
               "  ogaud04,ogaud05,ogaud06, ",
               "  ogaud07,ogaud08,ogaud09, ",
               "  ogaud10,ogaud11,ogaud12, ",
               "  ogaud13,ogaud14,ogaud15,ogaoriu,ogaorig)", #FUN-A10036
               " VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                        "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                        "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                        "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                        "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                        "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",    #No.CHI-950020
                        "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,",    #NO.FUN-620024
                        "?,?,?,?, ?,?,?,?, ?,? ) "  #FUN-A10036 #MOD-7A0156 modify #FUN-7B0091 add ? #FUN-980010 #MOD-C40162 add ?
           CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
           CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
           PREPARE ins_oga FROM l_sql2
           EXECUTE ins_oga USING 
                 l_oga.oga00,l_oga.oga01,l_oga.oga011,l_oga.oga02, 
                 l_oga.oga021,l_oga.oga022,l_oga.oga03,l_oga.oga032,
                 l_oga.oga033,l_oga.oga04,l_oga.oga044,l_oga.oga05,
                 l_oga.oga06,l_oga.oga07,l_oga.oga08,l_oga.oga09,
                 l_oga.oga10,l_oga.oga11,l_oga.oga12,l_oga.oga13,
                 l_oga.oga14,l_oga.oga15,l_oga.oga16,l_oga.oga161,
                 l_oga.oga162,l_oga.oga163,l_oga.oga17,l_oga.oga18,
                 l_oga.oga19,l_oga.oga20,l_oga.oga21,l_oga.oga211,
                 l_oga.oga212,l_oga.oga213,l_oga.oga23,l_oga.oga24,
                 l_oga.oga25,l_oga.oga26,l_oga.oga27,l_oga.oga28,
                 l_oga.oga29,l_oga.oga30,l_oga.oga31,l_oga.oga32,
                 l_oga.oga33,l_oga.oga34,l_oga.oga35,
                 l_oga.oga36,l_oga.oga37,l_oga.oga38,l_oga.oga39,
                 l_oga.oga40,l_oga.oga41,l_oga.oga42,l_oga.oga43,
                 l_oga.oga44,l_oga.oga45,l_oga.oga46,l_oga.oga47,
                 l_oga.oga48,l_oga.oga49,l_oga.oga50,l_oga.oga52,
                 l_oga.oga53,l_oga.oga54,l_oga.oga57,l_oga.oga65,l_oga.oga99,  #No.7993  #FUN-7B0091 add oga65   #FUN-AC0055 add l_oga.oga57
                 l_oga.oga69,                                      #FUN-670007
                 l_oga.oga901,l_oga.oga902,
                 l_oga.oga903,l_oga.oga904,l_oga.oga905,l_oga.oga906,
                 l_oga.oga907,l_oga.oga908,l_oga.oga909,l_oga.oga1001,    #NO.FUN-620024
                 l_oga.oga1002,l_oga.oga1003,l_oga.oga1004,l_oga.oga1005, #NO.FUN-620024
                 l_oga.oga1006,l_oga.oga1007,l_oga.oga1008,l_oga.oga1009, #NO.FUN-620024
                 l_oga.oga1010,l_oga.oga1011,l_oga.oga1012,l_oga.oga1013, #NO.FUN-620024
                 l_oga.oga1014,l_oga.oga1015,l_oga.ogaconf,l_oga.oga55,   #NO.FUN-620024 #MOD-C40162 add l_oga.oga55
                 l_oga.ogapost,l_oga.ogaprsw,l_oga.ogauser,l_oga.ogagrup,
                 l_oga.ogamodu,l_oga.ogadate,l_oga.ogamksg,  #MOD-7A0156 modify 
                 gp_plant,gp_legal   #FUN-980010
                ,l_oga.ogaud01,l_oga.ogaud02,l_oga.ogaud03,
                 l_oga.ogaud04,l_oga.ogaud05,l_oga.ogaud06,
                 l_oga.ogaud07,l_oga.ogaud08,l_oga.ogaud09,
                 l_oga.ogaud10,l_oga.ogaud11,l_oga.ogaud12,
                 l_oga.ogaud13,l_oga.ogaud14,l_oga.ogaud15,g_user,g_grup  #FUN-A10036
              IF SQLCA.sqlcode<>0 THEN
                 CALL s_errmsg('oga01',l_oga.oga01,'ins oga:',SQLCA.sqlcode,1) #No.FUN-710046
                 LET g_success = 'N'
              END IF
              IF s_aza.aza50 = 'Y' AND l_oea.oea00 = '6' THEN    #NO.FUN-620024
                 CALL p820_ohains()                              #NO.FUN-620024
              END IF                                             #NO.FUN-620024
              #FUN-C80001---begin  刪除出通單idb
              IF s_industry('icd') THEN 
                 LET l_sql2 = " DELETE FROM ",cl_get_target_table(l_plant_new,'idb_file'),
                              " WHERE idb07 = '",l_oga.oga011,"'"
                 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2       
                 CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 
                 PREPARE del_idb FROM l_sql2
                 EXECUTE del_idb
              END IF    
              #FUN-C80001---end
END FUNCTION
 
#出貨單身檔
FUNCTION p820_ogbins(p_i)
 #DEFINE l_sql  LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1200)   #CHI-940042 mark
 #DEFINE l_sql1 LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(600)    #CHI-940042 mark
 #DEFINE l_sql2 LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1600)   #CHI-940042 mark
 #DEFINE l_sql3 LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(400)    #CHI-940042 mark
  DEFINE p_i    LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE l_no   LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE l_price LIKE ogb_file.ogb13
  DEFINE i,l_i   LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE l_msg   LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(80)
  DEFINE l_chr   LIKE type_file.chr1,   #No.FUN-680137 VARCHAR(1)
         l_currm LIKE pmm_file.pmm42,   #依計價幣別抓來源廠的匯率
         x_currm LIKE pmm_file.pmm42,
         l_curr  LIKE pmm_file.pmm22    #No.FUN-680137 VARCHAR(04)
  DEFINE l_ima02 LIKE ima_file.ima02
  DEFINE l_ima25 LIKE ima_file.ima25
#  DEFINE l_imaqty LIKE ima_file.ima262 #FUN-A20044
  DEFINE l_imaqty LIKE type_file.num15_3 #FUN-A20044
  DEFINE l_ima86 LIKE ima_file.ima86
  DEFINE l_ima39 LIKE ima_file.ima39
  DEFINE l_ima35 LIKE ima_file.ima35
  DEFINE l_ima36 LIKE ima_file.ima36
 #DEFINE l_sql4  LIKE type_file.chr1000  #NO.FUN-620024  #No.FUN-680137 VARCHAR(600)   #CHI-940042 mark
  DEFINE l_sql,l_sql1,l_sql2,l_sql3,l_sql4 STRING       #CHI-940042        
  DEFINE l_ogbi  RECORD LIKE ogbi_file.* #No.FUN-7B0018 
  DEFINE l_flag  SMALLINT     #MOD-810179 add
  DEFINE l_rvbs  RECORD LIKE rvbs_file.* #No.FUN-850100
  DEFINE l_n     LIKE type_file.num5     #No.FUN-850145
  DEFINE l_slip  LIKE oga_file.oga01	#MOD-9A0138
  DEFINE l_idd   RECORD LIKE idd_file.*            #FUN-B90012
  DEFINE l_flag1        LIKE type_file.num10       #FUN-B90012
  #DEFINE l_imaicd08     LIKE imaicd_file.imaicd08  #FUN-B90012 #FUN-BA0051 mark
  DEFINE l_ogbiicd028   LIKE ogbi_file.ogbiicd028  #FUN-B90012
  DEFINE l_ogbiicd029   LIKE ogbi_file.ogbiicd029  #FUN-B90012
  DEFINE g_ogg   RECORD LIKE ogg_file.*      #CHI-C40031 add
  DEFINE g_ogc   RECORD LIKE ogc_file.*      #CHI-C40031 add
  DEFINE l_cnt          LIKE type_file.num5  #CHI-C40031 add
# DEFINE l_oia07  LIKE oia_file.oia07    #FUN-C50136 add
  DEFINE l_ima29 LIKE ima_file.ima29     #CHI-C80042 add
  DEFINE l_fac   LIKE ima_file.ima31_fac     #FUN-C80001
  DEFINE l_img09 LIKE img_file.img09         #FUN-C80001
  DEFINE l_qty   LIKE ogb_file.ogb915        #FUN-C80001
  DEFINE l_oga14 LIKE oga_file.oga14  #FUN-CB0087
  DEFINE l_oga15 LIKE oga_file.oga15  #FUN-CB0087
 
     #讀取訂單單身檔(oeb_file)
     LET l_sql1 = #"SELECT ",l_dbs_tra CLIPPED,"oeb_file.* ", #FUN-980092 add
                  #"  FROM ",l_dbs_tra CLIPPED,"oeb_file,",l_dbs_tra CLIPPED,"oea_file", #FUN-980092 add
                  "SELECT ",cl_get_target_table(l_plant_new,'oeb_file.*'),   #FUN-A50102
                  "  FROM ",cl_get_target_table(l_plant_new,'oeb_file'),",", #FUN-A50102
                            cl_get_target_table(l_plant_new,'oea_file'),     #FUN-A50102
                  " WHERE oeb01 = oea01",
                  "   AND oea99 ='",g_oea.oea99,"'", 
                  "   AND oeb03 =",g_ogb.ogb32
 
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-980092
     PREPARE oeb_p1 FROM l_sql1
     IF SQLCA.SQLCODE THEN 
        LET g_showmsg = g_oea.oea99,"/",g_ogb.ogb32           #No.FUN-710046
        CALL s_errmsg('oea99,oeb03',g_showmsg,'oeb_p1',SQLCA.SQLCODE,0)  #No.FUN-710046
     END IF
 
     DECLARE oeb_c1 CURSOR FOR oeb_p1
 
     OPEN oeb_c1
 
     FETCH oeb_c1 INTO l_oeb.*
     IF SQLCA.SQLCODE <> 0 THEN
        LET g_success='N'
        RETURN
     END IF
 
     CLOSE oeb_c1

     #新增出貨單身檔[ogb_file]
     LET l_ogb.ogb01 = l_oga.oga01      #出貨單號 No.7993
     LET l_ogb.ogb03 = g_ogb.ogb03      #項次
     LET l_ogb.ogb04 = g_ogb.ogb04      #產品編號 No.7742
     LET l_ogb.ogb05 = g_ogb.ogb05      #銷售單位 No.7742
     LET l_ogb.ogb05_fac= g_ogb.ogb05_fac  #換算率No.7742
     LET l_ogb.ogb06 = g_ogb.ogb06      #品名規格 No.7742
     LET l_ogb.ogb07 = g_ogb.ogb07      #額外品名編號 No.7742
     LET l_ogb.ogb08 = l_oeb.oeb08      #出貨工廠
     LET l_ogb.ogbud01 = g_ogb.ogbud01
     LET l_ogb.ogbud02 = g_ogb.ogbud02
     LET l_ogb.ogbud03 = g_ogb.ogbud03
     LET l_ogb.ogbud04 = g_ogb.ogbud04
     LET l_ogb.ogbud05 = g_ogb.ogbud05
     LET l_ogb.ogbud06 = g_ogb.ogbud06
     LET l_ogb.ogbud07 = g_ogb.ogbud07
     LET l_ogb.ogbud08 = g_ogb.ogbud08
     LET l_ogb.ogbud09 = g_ogb.ogbud09
     LET l_ogb.ogbud10 = g_ogb.ogbud10
     LET l_ogb.ogbud11 = g_ogb.ogbud11
     LET l_ogb.ogbud12 = g_ogb.ogbud12
     LET l_ogb.ogbud13 = g_ogb.ogbud13
     LET l_ogb.ogbud14 = g_ogb.ogbud14
     LET l_ogb.ogbud15 = g_ogb.ogbud15
 
     CALL p820_ima(l_ogb.ogb04,l_plant_new) #FUN-980092 add
        RETURNING l_ima02,l_ima25,l_imaqty,l_ima86,l_ima39,l_ima35,l_ima36
     IF cl_null(l_ima35) THEN LET l_ima35=' ' END IF
     IF cl_null(l_ima36) THEN LET l_ima36=' ' END IF
 
     IF NOT cl_null(p_imd01) THEN
        CALL p820_imd(p_imd01,l_plant_new)  #FUN-980092 add
        LET l_ogb.ogb09 = p_imd01          #出貨倉庫
        LET l_ogb.ogb091= ' '              #出貨儲位
        LET l_ogb.ogb092= ' '              #出貨批號
     ELSE
        IF NOT cl_null(l_ima35) THEN
           LET l_ogb.ogb09 = l_ima35          #出貨倉庫
           LET l_ogb.ogb091= l_ima36          #出貨儲位
           LET l_ogb.ogb092= ' '              #出貨批號
        ELSE
           LET l_ogb.ogb09 = l_oeb.oeb09
           LET l_ogb.ogb091= l_oeb.oeb091
           LET l_ogb.ogb092= l_oeb.oeb092      #No.MOD-630019 modify
        END IF
     END IF
    #IF g_sma.sma96 = 'Y' THEN          #FUN-C80001 #FUN-D30099 mark
     IF g_pod.pod08 = 'Y' THEN          #FUN-D30099 
        LET l_ogb.ogb092= g_ogb.ogb092  #FUN-C80001
     END IF                             #FUN-C80001
     LET l_ogb.ogb11 = g_ogb.ogb11      #客戶產品編號 No.7742
     LET l_ogb.ogb12 = g_ogb.ogb12      #實際出貨數量
    #LET l_ogb.ogb13 = l_oeb.oeb13      #原幣單價 #FUN-D10007 mark 
#FUN-D10007---add---START  
     IF g_oax.oax03 = 'N' OR s_aza.aza50 = 'Y' THEN
        LET l_ogb.ogb13 = l_oeb.oeb13    #原幣單價
     ELSE
        #出貨必須重新計算價格, 因為分批出貨時, 有可能計價方式亦改變了
        #依計價方式來判斷價格
              CASE p_pox05
                 WHEN '1'
                    IF p_pox03='1' THEN   #依來源工廠 
                       #單價*比率
                       #換算匯率
                       IF g_oea.oea23 = l_oga.oga23 THEN
                          LET l_ogb.ogb13 = t_ogb.ogb13 * p_pox06 /100
                       END IF
                       IF g_oea.oea23 <> l_oga.oga23 THEN  
                          LET l_price = t_ogb.ogb13 * g_oga.oga24 #先換算本幣
                          #依計價幣別抓來源工廠的匯率
                          CALL s_currm(l_oga.oga23,l_oga.oga02,
                                        g_oax.oax01,t_dbs)
                          #g_oax.oax01 多角貿易使用匯率 s/b/c/d                                        
                               RETURNING l_currm
                          LET l_ogb.ogb13= l_price/l_currm * p_pox06/100  
                       END IF
                    ELSE
                       #依上游廠商計算, 先讀取S/O價格
                       IF p_i=1 THEN
                         #單價*比率
                         #(換算匯率)
                         IF g_oea.oea23 = l_oga.oga23 THEN
                            LET l_ogb.ogb13 = t_ogb.ogb13 * p_pox06 /100
                         END IF
                         IF g_oea.oea23 <> l_oga.oga23 THEN  
                            LET l_price = t_ogb.ogb13 * g_oga.oga24 #先換算本幣
                            #依計價幣別抓來源工廠的匯率
                            CALL s_currm(l_oga.oga23,l_oga.oga02,
                                          g_oax.oax01,t_plant)
                                 RETURNING l_currm
                            LET l_ogb.ogb13= l_price/l_currm * p_pox06/100  
                         END IF
                       ELSE
                          LET l_no = p_i-1
                          SELECT pab_price,pab_curr INTO l_price,l_curr
                            FROM p820_file
                           WHERE p_no = l_no
                             AND pab_no = l_ogb.ogb01
                             AND pab_item=t_ogb.ogb03
                             AND pab_type='1'
                         #(換算匯率)
                          IF l_curr != l_oga.oga23 THEN
                             CALL s_currm(l_curr,l_oga.oga02,
                                          g_oax.oax01,t_plant)
                              RETURNING l_currm
                             LET l_price = l_price * l_currm   #換算成本幣
                             #依計價幣別抓來源廠的匯率
                             CALL s_currm(l_oga.oga23,l_oga.oga02,
                                          g_oax.oax01,t_plant)
                              RETURNING l_currm
                             LET l_ogb.ogb13 = l_price / l_currm * p_pox06/100
                          ELSE
                             #單價*比率
                             LET l_ogb.ogb13= l_price * p_pox06/100
                          END IF
                        END IF  
                    END IF
                    CALL cl_digcut(l_ogb.ogb13,l_azi.azi03) 
                          RETURNING l_ogb.ogb13
                 WHEN '2'
                    #讀取合乎料件條件之價格
                    CALL s_pow(g_oea.oea904,l_ogb.ogb04,p_poy04,g_oga.oga02)
                           RETURNING g_sw,l_ogb.ogb13
                     IF g_sw='N' THEN
                       CALL cl_err('sel pow:','axm-333',1)
                       LET g_success = 'N'
                     END IF
                 WHEN '3'   #單價若為0, 則給0, 否則抓料件之固定價格
                     IF t_ogb.ogb13 <> 0 THEN
                        CALL s_pow(g_oea.oea904,l_ogb.ogb04,p_poy04,g_oga.oga02)
                           RETURNING g_sw,l_ogb.ogb13
                        IF g_sw='N' THEN
                          CALL cl_err('sel pow:','axm-333',1)
                          LET g_success = 'N'
                        END IF
                     ELSE
                        LET l_ogb.ogb13 = 0
                     END IF
              END CASE
              IF l_ogb.ogb13 IS NULL THEN LET l_ogb.ogb13 =0 END IF
     END IF
#FUN-D10007---add-----END
     LET l_ogb.ogb37 = l_oeb.oeb37      #FUN-AB0061
     LET l_ogb.ogb917 = g_ogb.ogb917   #No.TQC-6A0084
 
     #未稅金額/含稅金額 : oeb14/oeb14t
     IF l_oga.oga213 = 'N' THEN
        LET l_ogb.ogb14=l_ogb.ogb917*l_ogb.ogb13  #No.TQC-6A0084
        LET l_ogb.ogb14t=l_ogb.ogb14*(1+l_oga.oga211/100)
     ELSE 
        LET l_ogb.ogb14t=l_ogb.ogb917*l_ogb.ogb13  #No.TQC-6A0084
        LET l_ogb.ogb14=l_ogb.ogb14t/(1+l_oga.oga211/100)
     END IF
     LET l_ogb.ogb15 = l_ogb.ogb05 #No.7742
     LET l_ogb.ogb15_fac = l_ogb.ogb05_fac #MOD-4B0148
     #與庫存單位轉換率的計算
     #ogb15存放的是倉庫的單位(img09)，因此不管目前l_ogb.ogb15
     #是否為NULL都必須重新塞值給l_ogb.ogb15
      IF l_ogb.ogb09  IS NULL THEN LET l_ogb.ogb09  = ' ' END IF
      IF l_ogb.ogb091 IS NULL THEN LET l_ogb.ogb091 = ' ' END IF
      IF l_ogb.ogb092 IS NULL THEN LET l_ogb.ogb092 = ' ' END IF
      LET l_sql1 = "SELECT img09 ",                                 
                   #" FROM ",l_dbs_tra CLIPPED,"img_file ",     #FUN-980092 add
                   " FROM ",cl_get_target_table(l_plant_new,'img_file'), #FUN-A50102
                   " WHERE img01 ='", l_ogb.ogb04,"' ",
                   "   AND img02 ='", l_ogb.ogb09,"' ",
                   "   AND img03 ='", l_ogb.ogb091,"' ",
                   "   AND img04 ='", l_ogb.ogb092,"' "
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-980092
     PREPARE img_p1 FROM l_sql1
     IF SQLCA.SQLCODE THEN 
        CALL cl_err('img_p1',SQLCA.SQLCODE,1)
     END IF
     DECLARE img_c1 CURSOR FOR img_p1
     OPEN img_c1
     FETCH img_c1 INTO l_ogb.ogb15
 
      IF STATUS=0 THEN
         IF l_ogb.ogb05 = l_ogb.ogb15 THEN
             LET l_ogb.ogb15_fac =1
         ELSE
             #檢查該銷售單位與倉庫的庫存單位是否可以轉換
             CALL s_umfchkm(l_ogb.ogb04,l_ogb.ogb05,l_ogb.ogb15,l_plant_new)#FUN-980092 add
                  RETURNING l_flag,l_ogb.ogb15_fac
             IF l_flag THEN
                LET g_msg=l_plant_new CLIPPED,' ',l_ogb.ogb04 #FUN-980092 add
                CALL cl_err(g_msg,'mfg3075',1)
                LET g_success = 'N'
             END IF 
         END IF
      END IF
      IF cl_null(l_ogb.ogb15) THEN LET l_ogb.ogb15  = l_ogb.ogb05 END IF
      IF cl_null(l_ogb.ogb15_fac) THEN LET l_ogb.ogb15_fac = 1 END IF
      
      #銷售單位/庫存單位轉換率
      CALL s_umfchkm(l_ogb.ogb04,l_ogb.ogb05,l_ima25,l_plant_new) #FUN-980092 add
           RETURNING l_flag,l_ogb.ogb05_fac
      IF l_flag THEN
         LET g_msg=l_plant_new CLIPPED,' ',l_ogb.ogb04 #FUN-980092 add
         CALL cl_err(g_msg,'mfg3075',1)
         LET g_success = 'N'
      END IF 
 
     LET l_ogb.ogb16 = l_ogb.ogb12 * l_ogb.ogb15_fac
     LET l_ogb.ogb16 = s_digqty(l_ogb.ogb16,l_ogb.ogb15) #FUN-BB0083 add
    #IF g_sma.sma96 = 'Y' THEN         #FUN-C80001 #FUN-D30099 mark
     IF g_pod.pod08 = 'Y' THEN         #FUN-D30099  
        LET l_ogb.ogb17 = g_ogb.ogb17  #FUN-C80001
     ELSE                              #FUN-C80001
        LET l_ogb.ogb17 = 'N'
     END IF                            #FUN-C80001
     LET l_ogb.ogb18 = l_ogb.ogb12
     LET l_ogb.ogb19 = g_ogb.ogb19  #檢驗否 #NO.FUN-620024
     LET l_ogb.ogb20 =' '
     LET l_ogb.ogb31 = l_oeb.oeb01
     LET l_ogb.ogb32 = l_oeb.oeb03
     LET l_ogb.ogb60 =0
     LET l_ogb.ogb63 =0
     LET l_ogb.ogb64 =0
     LET l_ogb.ogb910 = g_ogb.ogb910
     LET l_ogb.ogb911 = g_ogb.ogb911
     LET l_ogb.ogb912 = g_ogb.ogb912
     LET l_ogb.ogb913 = g_ogb.ogb913
     LET l_ogb.ogb914 = g_ogb.ogb914
     LET l_ogb.ogb915 = g_ogb.ogb915
     LET l_ogb.ogb916 = g_ogb.ogb916
     LET l_ogb.ogb1014='N' #保稅放行否 #FUN-6B0044
     LET l_ogb.ogb1001 = ''            #TQC-D20067 add
     IF s_aza.aza50 = 'Y' THEN   
        #LET l_ogb.ogb1001 = l_oeb.oeb1001  #原因碼  #TQC-D40064 mark
        LET l_ogb.ogb1002 = l_oeb.oeb1002  #訂價編號
        LET l_ogb.ogb1003 = l_oeb.oeb15    #預計出貨日期
        LET l_ogb.ogb1004 = l_oeb.oeb1004  #提案編號
        LET l_ogb.ogb1005 = l_oeb.oeb1003  #作業方式
        LET l_ogb.ogb1007 = ''             #現金折扣單號
        LET l_ogb.ogb1008 = ''             #稅種
        LET l_ogb.ogb1009 = ''             #稅率
        LET l_ogb.ogb1010 = ''             #含稅否
        LET l_ogb.ogb1011 = ''             #非直營KAB
        LET l_ogb.ogb1006 = l_oeb.oeb1006  #折扣率
        LET l_ogb.ogb1012 = l_oeb.oeb1012  #搭贈
     END IF
     LET l_ogb.ogb1001 = l_oeb.oeb1001     #原因碼                         #TQC-D40064 add
     IF cl_null(l_ogb.ogb1001) THEN LET l_ogb.ogb1001 = g_poy.poy28 END IF #TQC-D40064 add
     CALL cl_digcut(l_ogb.ogb14,l_azi.azi04) RETURNING l_ogb.ogb14
     CALL cl_digcut(l_ogb.ogb14t,l_azi.azi04)RETURNING l_ogb.ogb14t
     IF l_ogb.ogb1012 = 'Y' THEN   #NO.FUN-620024
        LET l_ogb.ogb14 =0         #NO.FUN-620024
        LET l_ogb.ogb14t=0         #NO.FUN-620024
     END IF                        #NO.FUN-620024
     #No.7742 備品時金額、單價應為零
     IF p820_chkoeo(l_ogb.ogb31,l_ogb.ogb32,l_ogb.ogb04) THEN
        LET l_ogb.ogb13 = 0 
        LET l_ogb.ogb14 = 0 
        LET l_ogb.ogb14t= 0 
     END IF
   LET l_ogb.ogb930 = l_oeb.oeb930  #MOD-920261 add
##NO.FUN-670047 --抓各站設定的訂單成本中心--
#FUN-AB0061 -----------add start----------------                             
     IF cl_null(l_ogb.ogb37) OR l_ogb.ogb37=0 THEN           
        LET l_ogb.ogb37=l_ogb.ogb13                         
     END IF                                                                             
#FUN-AB0061 -----------add end----------------   
#FUN-AC0055 mark ---------------------begin-----------------------
##FUN-AB0096 -----------add start----------------
#     IF cl_null(l_ogb.ogb50) THEN
#        LET l_ogb.ogb50 = '1'
#     END IF
##FUN-AB0096 ---------- add end----------------
#FUN-AC0055 mark ----------------------end------------------------
     IF g_aza.aza50 = 'N' THEN LET l_ogb.ogb1005 = '1' END IF   #FUN-670007
     #FUN-C50097 ADD BEGIN-----
     IF cl_null(l_ogb.ogb50) THEN 
       LET l_ogb.ogb50 = 0
     END IF 
     IF cl_null(l_ogb.ogb51) THEN 
       LET l_ogb.ogb51 = 0
     END IF 
     IF cl_null(l_ogb.ogb52) THEN 
       LET l_ogb.ogb52 = 0
     END IF   
     IF cl_null(l_ogb.ogb53) THEN 
       LET l_ogb.ogb53 = 0
     END IF 
     IF cl_null(l_ogb.ogb54) THEN 
       LET l_ogb.ogb54 = 0
     END IF 
     IF cl_null(l_ogb.ogb55) THEN 
       LET l_ogb.ogb55 = 0
     END IF                                        
     #FUN-C50097 ADD END-------       
     #FUN-CB0087--add--str--
     #TQC-D20047--add--str--
     LET l_sql2 = "SELECT aza115 FROM ",cl_get_target_table(l_plant_new,'aza_file')," WHERE aza01 = '0' " 
     PREPARE aza115_pr FROM l_sql2
     EXECUTE aza115_pr INTO g_aza.aza115   
     #TQC-D20047--add--end--
     #IF g_aza.aza115='Y' THEN                            #TQC-D40064 mark
     IF g_aza.aza115='Y' AND cl_null(l_ogb.ogb1001) THEN  #TQC-D40064 add
       #SELECT oga14,oga15 INTO l_oga14,l_oga15 FROM oga_file WHERE oga01 = l_ogb.ogb01
        #TQC-D20042--add--str--
        LET l_sql2 = "SELECT oga14,oga15 FROM ",cl_get_target_table(l_plant_new,'oga_file')," WHERE oga01 = '",l_ogb.ogb01,"'"
        PREPARE ogb1001_pr FROM l_sql2
        EXECUTE ogb1001_pr INTO l_oga14,l_oga15
        #TQC-D20042--add--end--
       #CALL s_reason_code(l_ogb.ogb01,l_ogb.ogb31,'',l_ogb.ogb04,l_ogb.ogb09,l_oga14,l_oga15) RETURNING l_ogb.ogb1001  #TQC-D20042 mark
        CALL s_reason_code1(l_ogb.ogb01,l_ogb.ogb31,'',l_ogb.ogb04,l_ogb.ogb09,l_oga14,l_oga15,l_plant_new) RETURNING l_ogb.ogb1001  #TQC-D20042
        IF cl_null(l_ogb.ogb1001) THEN
           #CALL cl_err(l_ogb.ogb1001,'aim-425',1)  #TQC-D20047
           LET g_showmsg = l_plant_new,"/",l_ogb.ogb01                  #TQC-D20047 
           CALL s_errmsg('oga01',g_showmsg,'up ogb1001:','aim-425',1)   #TQC-D20047
           LET g_success="N"
           RETURN
        END IF
     END IF
     #FUN-CB0087--add--end-- 
     #新增出貨單身檔
     #LET l_sql2="INSERT INTO ",l_dbs_tra CLIPPED,"ogb_file",#FUN-980092 add #TQC-9C0119
     LET l_sql2="INSERT INTO ",cl_get_target_table(l_plant_new,'ogb_file'), #FUN-A50102
      "(ogb01,ogb03,ogb04,ogb05, ",
      " ogb05_fac,ogb06,ogb07,ogb08, ",
      " ogb09,ogb091,ogb092,ogb11, ",
      " ogb12,ogb37,ogb13,ogb14,ogb14t,",  #FUN-AB0061 
      " ogb15,ogb15_fac,ogb16,ogb17, ",
      " ogb18,ogb19,ogb20,ogb31,",
      " ogb32,ogb60,ogb63,ogb64,",
      " ogb901,ogb902,ogb903,ogb904,",
      " ogb905,ogb906,ogb907,ogb908,",
      " ogb909,ogb910,ogb911,ogb912,",   #FUN-560043
      " ogb913,ogb914,ogb915,ogb916,",   #FUN-560043
      " ogb917,ogb930,ogb1001,ogb1002,ogb1003,", #NO.FUN-620024   #MOD-920261 add ogb930 
      " ogb1004,ogb1005,ogb1007,ogb1008,",#NO.FUN-620024
      " ogb1009,ogb1010,ogb1011,ogb1012,ogb1006,ogb1014 ,",       #NO.FUN-620024 #FUN-6B0044
      " ogbplant,ogblegal , ",
      " ogbud01,ogbud02,ogbud03,ogbud04,ogbud05,",
      " ogbud06,ogbud07,ogbud08,ogbud09,ogbud10,",
      " ogbud11,ogbud12,ogbud13,ogbud14,ogbud15,ogb50,ogb51,ogb52,ogb53,ogb54,ogb55)",       #FUN-AB0096 add ogb50 
      " VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
      "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
      "         ?,?,?,?, ?,?,?,?, ?,?,?,?,?,  ",  #NO.FUN-620024
      "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,",   #No.CHI-950020
      "         ?,?,?,?, ?,?,?,?, ?,?,?,?,?,?,  ?,?,?,  ?,?,?,  ?,?,?) "   #FUN-560043 #FUN-6B0044  #MOD-920261 add ? #FUN-980010 #FUN-AB0096 add? #FUN-C50097 add ???
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
     PREPARE ins_ogb FROM l_sql2
     EXECUTE ins_ogb USING 
       l_ogb.ogb01,l_ogb.ogb03,l_ogb.ogb04,l_ogb.ogb05, 
       l_ogb.ogb05_fac,l_ogb.ogb06,l_ogb.ogb07,l_ogb.ogb08, 
       l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,l_ogb.ogb11, 
       l_ogb.ogb12,l_ogb.ogb37,l_ogb.ogb13,l_ogb.ogb14,l_ogb.ogb14t, #FUN-AB0061 
       l_ogb.ogb15,l_ogb.ogb15_fac,l_ogb.ogb16,l_ogb.ogb17, 
       l_ogb.ogb18,l_ogb.ogb19,l_ogb.ogb20,l_ogb.ogb31,
       l_ogb.ogb32,l_ogb.ogb60,l_ogb.ogb63,l_ogb.ogb64,
       l_ogb.ogb901,l_ogb.ogb902,l_ogb.ogb903,l_ogb.ogb904,
       l_ogb.ogb905,l_ogb.ogb906,l_ogb.ogb907,l_ogb.ogb908,
       l_ogb.ogb909,l_ogb.ogb910,l_ogb.ogb911,l_ogb.ogb912,   #FUN-560043
       l_ogb.ogb913,l_ogb.ogb914,l_ogb.ogb915,l_ogb.ogb916,   #FUN-560043
       l_ogb.ogb917,l_ogb.ogb930,l_ogb.ogb1001,l_ogb.ogb1002,l_ogb.ogb1003,  #NO.FUN-620024  #MOD-920261 add ogb930
       l_ogb.ogb1004,l_ogb.ogb1005,l_ogb.ogb1007,l_ogb.ogb1008, #NO.FUN-620024 
       l_ogb.ogb1009,l_ogb.ogb1010,l_ogb.ogb1011,l_ogb.ogb1012,l_ogb.ogb1006,l_ogb.ogb1014, #NO.FUN-620024 #FUN-6B0044
       gp_plant,gp_legal   #FUN-980010
      ,l_ogb.ogbud01,l_ogb.ogbud02,l_ogb.ogbud03,l_ogb.ogbud04,l_ogb.ogbud05,
       l_ogb.ogbud06,l_ogb.ogbud07,l_ogb.ogbud08,l_ogb.ogbud09,l_ogb.ogbud10,
       l_ogb.ogbud11,l_ogb.ogbud12,l_ogb.ogbud13,l_ogb.ogbud14,l_ogb.ogbud15,
       l_ogb.ogb50,l_ogb.ogb51,l_ogb.ogb52,l_ogb.ogb53,l_ogb.ogb54,l_ogb.ogb55  #FUN-AB0096 add ogb50 #FUN-C50097 add ???
       IF SQLCA.sqlcode<>0 THEN
          LET g_showmsg = l_ogb.ogb01,"/",l_ogb.ogb03 #No.FUN-710046
          CALL s_errmsg('ogb01,ogb03',g_showmsg,'ins ogb:',SQLCA.sqlcode,1) #No.FUN-710046
          LET g_success = 'N'
       ELSE
          IF NOT s_industry('std') THEN
             INITIALIZE l_ogbi.* TO NULL
             LET l_ogbi.ogbi01 = l_ogb.ogb01
             LET l_ogbi.ogbi03 = l_ogb.ogb03
             IF NOT s_ins_ogbi(l_ogbi.*,l_plant_new) THEN #FUN-980092 add
                LET g_success = 'N'
             END IF
          END IF
#         #FUN-C50136----add----str----
#         IF g_oaz.oaz96 ='Y' THEN
#            CALL s_ccc_oia07('D',l_oga.oga03) RETURNING l_oia07
#            IF l_oia07 MATCHES '[01]' THEN
#               CALL s_ccc_oia(l_oga.oga03,'D',l_oga.oga01,0,l_plant_new)
#            END IF
#         END IF
#         #FUN-C50136----add----end----
       END IF
     #新增至暫存檔中
     INSERT INTO p820_file VALUES(p_i,l_ogb.ogb01,g_ogb.ogb03,
                                         l_ogb.ogb13,l_oga.oga23,'1')
     IF SQLCA.sqlcode<>0 THEN 
        CALL s_errmsg('','','ins p820_file:',SQLCA.sqlcode,1)   #No.FUN-710046
        LET g_success = 'N'
     END IF

#FUN-C80001---begin
     IF s_industry('icd') THEN 
        LET l_sql1 = "SELECT ogbiicd028,ogbiicd029 FROM ",cl_get_target_table(l_plant_new,'ogbi_file'),
                     " WHERE ogbi01 = '",l_ogb.ogb01,"'",
                     "   AND ogbi03 =  ",l_ogb.ogb03
        CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1
        CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1
        PREPARE p820_ogbi FROM l_sql1
        EXECUTE p820_ogbi INTO l_ogbiicd028,l_ogbiicd029 
     END IF  
     
     LET l_sql2 = "SELECT ima918,ima921 FROM ",cl_get_target_table(l_plant_new,'ima_file'), 
                  " WHERE ima01 = '",l_ogb.ogb04,"'",
                  "   AND imaacti = 'Y'"
 
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2       
     CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 
     PREPARE ima_ogb FROM l_sql2
 
     EXECUTE ima_ogb INTO g_ima918,g_ima921   
     
     LET l_cnt = 0
     IF l_ogb.ogb17='Y' THEN
        IF g_sma.sma115 = 'Y' THEN
           DECLARE p821_g_ogg1 CURSOR FOR 
              SELECT ogg17,ogg092,ogg20 FROM ogg_file
               WHERE ogg01= g_oga.oga01
                 AND ogg03= g_ogb.ogb03
               GROUP BY ogg17,ogg092,ogg20 
               ORDER BY ogg20

           FOREACH p821_g_ogg1 INTO g_ogg.ogg17,g_ogg.ogg092,g_ogg.ogg20
              IF STATUS THEN
                 CALL cl_err('ogg1',STATUS,1)
              END IF

              SELECT * INTO g_ogg.* FROM ogg_file
               WHERE ogg01= g_oga.oga01
                 AND ogg03= g_ogb.ogb03
                 AND ogg17= g_ogg.ogg17
                 AND ogg092= g_ogg.ogg092
                 AND ogg20= g_ogg.ogg20
   
              SELECT SUM(ogg12) INTO g_ogg.ogg12 FROM ogg_file
               WHERE ogg01= g_oga.oga01
                 AND ogg03= g_ogb.ogb03
                 AND ogg092= g_ogg.ogg092    
                 AND ogg20= g_ogg.ogg20
               GROUP BY ogg17,ogg092

              #LET l_fac = 1
              #SELECT img09 INTO l_img09 FROM img_file
              # WHERE img01 = l_ogb.ogb04
              #   AND img02 = g_ogg.ogg09
              #   AND img03 = g_ogg.ogg091
              #   AND img04 = g_ogg.ogg092
              #IF g_ogg.ogg15 <> l_img09 THEN
              #   CALL s_umfchk(l_ogb.ogb04,g_ogg.ogg15,l_img09) 
              #        RETURNING l_flag,l_fac
              #   IF l_flag = 1 THEN
              #      CALL cl_err('','mfg3075',1)
              #      LET l_fac = 1
              #   END IF
              #END IF
              #LET g_ogg.ogg16 = g_ogg.ogg12 * l_fac
              LET g_ogg.ogg16 = g_ogg.ogg12 * g_ogg.ogg15_fac
                
              LET g_ogg.ogg01 = l_oga.oga01
              LET g_ogg.ogg09 = l_ogb.ogb09
              LET g_ogg.ogg091= l_ogb.ogb091
           
              LET l_sql2 = "INSERT INTO ",cl_get_target_table(l_plant_new,'ogg_file'),   
                           "(ogg01,ogg03,ogg09,ogg091,ogg092,ogg10,",
                           " ogg12,ogg15,ogg15_fac,ogg16,ogg20,ogg17,ogg18,",           
                           " oggplant,ogglegal,ogg13) ", 
                           " VALUES( ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?) "  
 
 	          CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        
              CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 
              PREPARE ins_ogg FROM l_sql2
           
              EXECUTE ins_ogg USING g_ogg.ogg01,g_ogg.ogg03,g_ogg.ogg09,g_ogg.ogg091,g_ogg.ogg092,g_ogg.ogg10,
                                    g_ogg.ogg12,g_ogg.ogg15,g_ogg.ogg15_fac,g_ogg.ogg16,g_ogg.ogg20,g_ogg.ogg17,g_ogg.ogg18,
                                    gp_plant,gp_legal,g_ogg.ogg13  
        
              IF STATUS OR SQLCA.SQLCODE THEN
                 LET g_showmsg = g_oga.oga01,"/",g_ogb.ogb03
                 CALL s_errmsg('oga01,oga03',g_showmsg,'ins ogg:',SQLCA.sqlcode,1) 
                 LET g_success='N'
              END IF  
              IF g_ogg.ogg20 = 1 THEN 
                 SELECT SUM(ogg12) INTO l_qty 
                   FROM ogg_file
                  WHERE ogg01= g_oga.oga01
                    AND ogg03= g_ogb.ogb03
                    AND ogg092= g_ogg.ogg092    
                    AND ogg20= 2
                  GROUP BY ogg17,ogg092
                 CALL p820_log(g_ogg.ogg17,g_ogg.ogg09,g_ogg.ogg091,
                               g_ogg.ogg092,g_ogg.ogg12,'1',l_plant_new,p_i,'L',l_qty)  
              END IF  

              IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                 DECLARE p820_g_rvbs4 CURSOR FOR 
                                        SELECT rvbs_file.* FROM rvbs_file,ogg_file
                                         WHERE rvbs01 = ogg01
                                           AND rvbs02 = ogg03
                                           AND rvbs13 = ogg18
                                           AND rvbs01 = g_oga.oga01
                                           AND rvbs02 = g_ogb.ogb03
                                           AND ogg092 = g_ogg.ogg092
                                           AND ogg20 = g_ogg.ogg20   
                 
                 FOREACH p820_g_rvbs4 INTO l_rvbs.*
                    IF STATUS THEN
                       CALL cl_err('rvbs',STATUS,1)
                    END IF
        
                    LET l_rvbs.rvbs00 = "axmt820"
     
                    LET l_rvbs.rvbs01 = l_ogb.ogb01
             
                    LET l_cnt = l_cnt + 1      
                    LET l_rvbs.rvbs022 = l_cnt 
        
                    LET l_rvbs.rvbs09 = -1
 
                    IF cl_null(l_rvbs.rvbs06) THEN
                       LET l_rvbs.rvbs06 = 0
                    END IF
    
                    LET l_rvbs.rvbs13=g_ogg.ogg18

                    #新增批/序號資料檔
                    EXECUTE ins_rvbs USING l_rvbs.rvbs00,l_rvbs.rvbs01,l_rvbs.rvbs02,
                                           l_rvbs.rvbs021,l_rvbs.rvbs022,l_rvbs.rvbs03,
                                           l_rvbs.rvbs04,l_rvbs.rvbs05,l_rvbs.rvbs06,
                                           l_rvbs.rvbs07,l_rvbs.rvbs08,l_rvbs.rvbs09,
                                           gp_plant,gp_legal   
                                           ,l_rvbs.rvbs13                       
     
                    IF STATUS OR SQLCA.SQLCODE THEN
                       LET g_showmsg = l_rvbs.rvbs01,"/",l_rvbs.rvbs03
                       CALL s_errmsg('rvbs01,rvbs03',g_showmsg,'ins rvbs:',SQLCA.sqlcode,1) 
                       LET g_success='N'
                    END IF
        
                    CALL p820_imgs(g_ogg.ogg09,g_ogg.ogg091,g_ogg.ogg092,l_oga.oga02,l_rvbs.*,p_i)  #FUN-C80001
     
                 END FOREACH
              END IF
              
              IF p_i = p_last THEN
                 IF g_ima906 = '2' THEN 
                    IF g_ogg.ogg20 = 2 THEN
                       SELECT SUM(ogg12) INTO l_qty 
                         FROM ogg_file
                        WHERE ogg01= g_oga.oga01
                          AND ogg03= g_ogb.ogb03
                          AND ogg092= g_ogg.ogg092    
                          AND ogg20= 1
                        GROUP BY ogg092
                    
                       CALL s_umfchk(l_ogb.ogb04,g_ogg.ogg15,l_ogb.ogb15) 
                            RETURNING l_flag,l_fac 
                       CALL s_mupimg(-1,g_ogg.ogg17,  
                                      g_ogg.ogg09,g_ogg.ogg091,l_ogb.ogb092,
                                      l_qty+g_ogg.ogg12*l_fac, 
                                      g_oga.oga02,g_poy.poy04,-1,l_ogb.ogb01,l_ogb.ogb03)
                    END IF 
                 ELSE 
                    IF g_ogg.ogg20 = 1 THEN   
                       CALL s_mupimg(-1,g_ogg.ogg17,  
                                      g_ogg.ogg09,g_ogg.ogg091,l_ogb.ogb092,
                                      g_ogg.ogg12*g_ogg.ogg15_fac, 
                                      g_oga.oga02,g_poy.poy04,-1,l_ogb.ogb01,l_ogb.ogb03) 
                    END IF 
                 END IF 

                 IF g_ima906 = '2' THEN 
                    IF g_ogg.ogg20 = 1 THEN                 
                       CALL s_mupimgg(-1,g_ogg.ogg17,  
                                       g_ogg.ogg09,g_ogg.ogg091,g_ogg.ogg092,
                                       g_ogg.ogg15,g_ogg.ogg12,
                                       g_oga.oga02,
                                       l_plant_new) 
                    ELSE 
                       CALL s_mupimgg(-1,g_ogg.ogg17,  
                                       g_ogg.ogg09,g_ogg.ogg091,g_ogg.ogg092,
                                       g_ogg.ogg15,g_ogg.ogg12, 
                                       g_oga.oga02,
                                       l_plant_new) 
                    END IF 
                 ELSE
                    IF g_ima906 = '3' THEN
                       IF g_ogg.ogg20 = 2 THEN
                          CALL s_mupimgg(-1,g_ogg.ogg17,  
                                          g_ogg.ogg09,g_ogg.ogg091,g_ogg.ogg092,
                                          g_ogg.ogg15,g_ogg.ogg12, 
                                          g_oga.oga02,
                                          l_plant_new)
                       END IF    
                    END IF
                 END IF
                 CALL s_mudima(g_ogg.ogg17,l_plant_new) 
              END IF 
              IF s_industry('icd') AND g_ogg.ogg20 = 1 THEN 
                 IF s_icdbin_multi(l_ogb.ogb04,l_plant_new) THEN  
                 
                    FOREACH p820_g_idd1 USING g_ogg.ogg092 INTO l_idd.idd04,l_idd.idd05,l_idd.idd06

                       OPEN p820_g_idd2 USING l_idd.idd04,l_idd.idd05,l_idd.idd06
                       FETCH p820_g_idd2 INTO l_idd.*
                       CLOSE p820_g_idd2
              
                       SELECT SUM(idd13),SUM(idd18),SUM(idd19)
                         INTO l_idd.idd13,l_idd.idd18,l_idd.idd19
                         FROM idd_file
                        WHERE idd10 = g_oga.oga01
                          AND idd11 = g_ogb.ogb03 
                          AND idd04 = l_idd.idd04
                          AND idd05 = l_idd.idd05
                          AND idd06 = l_idd.idd06
                 
                       LET l_idd.idd10 = l_ogb.ogb01
                       LET l_idd.idd11 = l_ogb.ogb03 
                       LET l_idd.idd02 = g_ogg.ogg09
                       LET l_idd.idd03 = g_ogg.ogg091
                       LET l_idd.idd04 = g_ogg.ogg092

                       CALL icd_idb(l_idd.*,l_plant_new)
                    END FOREACH 
                 END IF    
                 CALL s_icdpost(12,l_ogb.ogb04,g_ogg.ogg09,g_ogg.ogg091,g_ogg.ogg092,l_ogb.ogb05,g_ogg.ogg12,l_ogb.ogb01,l_ogb.ogb03,
                                l_oga.oga02,'Y','','',l_ogbiicd029,l_ogbiicd028,l_plant_new)
                      RETURNING l_flag1
                 IF l_flag1 = 0 THEN
                    LET g_success = 'N'
                 END IF  
              END IF   

           END FOREACH 
           DECLARE p821_g_ogc2 CURSOR FOR
              SELECT ogc17,ogc092 FROM ogc_file  
               WHERE ogc01= g_oga.oga01
                 AND ogc03= g_ogb.ogb03
            GROUP BY ogc17,ogc092

           FOREACH p821_g_ogc2 INTO g_ogc.ogc17,g_ogc.ogc092
              IF STATUS THEN
                 CALL cl_err('ogc1',STATUS,1)
              END IF
              SELECT * INTO g_ogc.* FROM ogc_file
               WHERE ogc01= g_oga.oga01
                 AND ogc03= g_ogb.ogb03
                 AND ogc17= g_ogc.ogc17
                 AND ogc092= g_ogc.ogc092
              
              SELECT SUM(ogc12) INTO g_ogc.ogc12 FROM ogc_file
               WHERE ogc01= g_oga.oga01
                 AND ogc03= l_ogb.ogb03
                 AND ogc092= g_ogc.ogc092   
               GROUP BY ogc17,ogc092 

               #LET l_fac = 1
               #SELECT img09 INTO l_img09 FROM img_file
               # WHERE img01 = l_ogb.ogb04
               #   AND img02 = g_ogc.ogc09
               #   AND img03 = g_ogc.ogc091
               #   AND img04 = g_ogc.ogc092
               #IF g_ogc.ogc15 <> l_img09 THEN
               #   CALL s_umfchk(l_ogb.ogb04,g_ogc.ogc15,l_img09) 
               #        RETURNING l_flag,l_fac
               #   IF l_flag = 1 THEN
               #      CALL cl_err('','mfg3075',1)
               #      LET l_fac = 1
               #   END IF
               #END IF
               #LET g_ogc.ogc16 = g_ogc.ogc12 * l_fac
              LET g_ogc.ogc16 = g_ogc.ogc12 * g_ogc.ogc15_fac
            
              LET g_ogc.ogc01 = l_oga.oga01
              LET g_ogc.ogc09 = l_ogb.ogb09
              LET g_ogc.ogc091= l_ogb.ogb091
           
              LET l_sql2 = "INSERT INTO ",cl_get_target_table(l_plant_new,'ogc_file'),   
                           "(ogc01,ogc03,ogc09,ogc091,ogc092,",
                           " ogc12,ogc15,ogc15_fac,ogc16,ogc17,ogc18,",           
                           " ogcplant,ogclegal,ogc13) ", 
                           " VALUES( ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?) "  
 
 	          CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        
              CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 
              PREPARE ins_ogc1 FROM l_sql2
           
              EXECUTE ins_ogc1 USING g_ogc.ogc01,g_ogc.ogc03,g_ogc.ogc09,g_ogc.ogc091,g_ogc.ogc092,
                                    g_ogc.ogc12,g_ogc.ogc15,g_ogc.ogc15_fac,g_ogc.ogc16,g_ogc.ogc17,g_ogc.ogc18,
                                    gp_plant,gp_legal,g_ogc.ogc13  
        
              IF STATUS OR SQLCA.SQLCODE THEN
                 LET g_showmsg = g_oga.oga01,"/",g_ogb.ogb03
                 CALL s_errmsg('oga01,oga03',g_showmsg,'ins ogc:',SQLCA.sqlcode,1) 
                 LET g_success='N'
              END IF  
           END FOREACH 
        ELSE 
           DECLARE p821_g_ogc1 CURSOR FOR
              SELECT ogc17,ogc092 FROM ogc_file  
               WHERE ogc01= g_oga.oga01
                 AND ogc03= g_ogb.ogb03
            GROUP BY ogc17,ogc092

           FOREACH p821_g_ogc1 INTO g_ogc.ogc17,g_ogc.ogc092
              IF STATUS THEN
                 CALL cl_err('ogc1',STATUS,1)
              END IF
              SELECT * INTO g_ogc.* FROM ogc_file
               WHERE ogc01= g_oga.oga01
                 AND ogc03= g_ogb.ogb03
                 AND ogc17= g_ogc.ogc17
                 AND ogc092= g_ogc.ogc092
              
              SELECT SUM(ogc12) INTO g_ogc.ogc12 FROM ogc_file
               WHERE ogc01= g_oga.oga01
                 AND ogc03= l_ogb.ogb03
                 AND ogc092= g_ogc.ogc092   
               GROUP BY ogc17,ogc092 

               #LET l_fac = 1
               #SELECT img09 INTO l_img09 FROM img_file
               # WHERE img01 = l_ogb.ogb04
               #   AND img02 = g_ogc.ogc09
               #   AND img03 = g_ogc.ogc091
               #   AND img04 = g_ogc.ogc092
               #IF g_ogc.ogc15 <> l_img09 THEN
               #   CALL s_umfchk(l_ogb.ogb04,g_ogc.ogc15,l_img09) 
               #        RETURNING l_flag,l_fac
               #   IF l_flag = 1 THEN
               #      CALL cl_err('','mfg3075',1)
               #      LET l_fac = 1
               #   END IF
               #END IF
               #LET g_ogc.ogc16 = g_ogc.ogc12 * l_fac
               LET g_ogc.ogc16 = g_ogc.ogc12 * g_ogc.ogc15_fac
            
              LET g_ogc.ogc01 = l_oga.oga01
              LET g_ogc.ogc09 = l_ogb.ogb09
              LET g_ogc.ogc091= l_ogb.ogb091
           
              LET l_sql2 = "INSERT INTO ",cl_get_target_table(l_plant_new,'ogc_file'),   
                           "(ogc01,ogc03,ogc09,ogc091,ogc092,",
                           " ogc12,ogc15,ogc15_fac,ogc16,ogc17,ogc18,",           
                           " ogcplant,ogclegal,ogc13) ", 
                           " VALUES( ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?) "  
 
 	          CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        
              CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 
              PREPARE ins_ogc FROM l_sql2
           
              EXECUTE ins_ogc USING g_ogc.ogc01,g_ogc.ogc03,g_ogc.ogc09,g_ogc.ogc091,g_ogc.ogc092,
                                    g_ogc.ogc12,g_ogc.ogc15,g_ogc.ogc15_fac,g_ogc.ogc16,g_ogc.ogc17,g_ogc.ogc18,
                                    gp_plant,gp_legal,g_ogc.ogc13  
        
              IF STATUS OR SQLCA.SQLCODE THEN
                 LET g_showmsg = g_oga.oga01,"/",g_ogb.ogb03
                 CALL s_errmsg('oga01,oga03',g_showmsg,'ins ogc:',SQLCA.sqlcode,1) 
                 LET g_success='N'
              END IF  
  
              CALL p820_log(g_ogc.ogc17,g_ogc.ogc09,g_ogc.ogc091,
                            g_ogc.ogc092,g_ogc.ogc12,'1',l_plant_new,p_i,'L','')  

              IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                 DECLARE p820_g_rvbs3 CURSOR FOR 
                                        SELECT rvbs_file.* FROM rvbs_file,ogc_file
                                         WHERE rvbs01 = ogc01
                                           AND rvbs02 = ogc03
                                           AND rvbs13 = ogc18
                                           AND rvbs01 = g_oga.oga01
                                           AND rvbs02 = g_ogb.ogb03
                                           AND ogc092 = g_ogc.ogc092   
                 
                 FOREACH p820_g_rvbs3 INTO l_rvbs.*
                    IF STATUS THEN
                       CALL cl_err('rvbs',STATUS,1)
                    END IF
        
                    LET l_rvbs.rvbs00 = "axmt820"
     
                    LET l_rvbs.rvbs01 = l_ogb.ogb01
             
                    LET l_cnt = l_cnt + 1      
                    LET l_rvbs.rvbs022 = l_cnt 
        
                    LET l_rvbs.rvbs09 = -1
 
                    IF cl_null(l_rvbs.rvbs06) THEN
                       LET l_rvbs.rvbs06 = 0
                    END IF
    
                    LET l_rvbs.rvbs13 = g_ogc.ogc18

                    #新增批/序號資料檔
                    EXECUTE ins_rvbs USING l_rvbs.rvbs00,l_rvbs.rvbs01,l_rvbs.rvbs02,
                                           l_rvbs.rvbs021,l_rvbs.rvbs022,l_rvbs.rvbs03,
                                           l_rvbs.rvbs04,l_rvbs.rvbs05,l_rvbs.rvbs06,
                                           l_rvbs.rvbs07,l_rvbs.rvbs08,l_rvbs.rvbs09,
                                           gp_plant,gp_legal   
                                           ,l_rvbs.rvbs13                       
     
                    IF STATUS OR SQLCA.SQLCODE THEN
                       LET g_showmsg = l_rvbs.rvbs01,"/",l_rvbs.rvbs03
                       CALL s_errmsg('rvbs01,rvbs03',g_showmsg,'ins rvbs:',SQLCA.sqlcode,1) 
                       LET g_success='N'
                    END IF
        
                    CALL p820_imgs(g_ogc.ogc09,g_ogc.ogc091,g_ogc.ogc092,l_oga.oga02,l_rvbs.*,p_i)  #FUN-C80001
     
                 END FOREACH
              END IF
                            
              IF p_i = p_last THEN
                 CALL s_mupimg(-1,g_ogc.ogc17,  
                                g_ogc.ogc09,g_ogc.ogc091,g_ogc.ogc092,
                                g_ogc.ogc12*g_ogc.ogc15_fac, 
                                g_oga.oga02,g_poy.poy04,-1,l_ogb.ogb01,l_ogb.ogb03)  
 
                 CALL s_mudima(g_ogc.ogc17,l_plant_new) 
              END IF
              IF s_industry('icd') THEN 
                 IF s_icdbin_multi(l_ogb.ogb04,l_plant_new) THEN 
                    FOREACH p820_g_idd1 USING g_ogc.ogc092 INTO l_idd.idd04,l_idd.idd05,l_idd.idd06

                       OPEN p820_g_idd2 USING l_idd.idd04,l_idd.idd05,l_idd.idd06
                       FETCH p820_g_idd2 INTO l_idd.*
                       CLOSE p820_g_idd2
              
                       SELECT SUM(idd13),SUM(idd18),SUM(idd19)
                         INTO l_idd.idd13,l_idd.idd18,l_idd.idd19
                         FROM idd_file
                        WHERE idd10 = g_oga.oga01
                          AND idd11 = g_ogb.ogb03 
                          AND idd04 = l_idd.idd04
                          AND idd05 = l_idd.idd05
                          AND idd06 = l_idd.idd06

                       LET l_idd.idd10 = l_ogb.ogb01
                       LET l_idd.idd11 = l_ogb.ogb03 
                       LET l_idd.idd02 = g_ogc.ogc09
                       LET l_idd.idd03 = g_ogc.ogc091
                       LET l_idd.idd04 = g_ogc.ogc092

                       CALL icd_idb(l_idd.*,l_plant_new)
                    END FOREACH 
                 END IF    
                 CALL s_icdpost(12,l_ogb.ogb04,g_ogc.ogc09,g_ogc.ogc091,g_ogc.ogc092,l_ogb.ogb05,g_ogc.ogc12,l_ogb.ogb01,l_ogb.ogb03,
                                l_oga.oga02,'Y','','',l_ogbiicd029,l_ogbiicd028,l_plant_new)
                      RETURNING l_flag1
                 IF l_flag1 = 0 THEN
                    LET g_success = 'N'
                 END IF  
              END IF 

           END FOREACH 
        END IF 
     ELSE
#FUN-C80001---end
#FUN-C80001---begin mark 移到上面
#     #LET l_sql2 = "SELECT ima918,ima921 FROM ",l_dbs_new CLIPPED,"ima_file",
#     LET l_sql2 = "SELECT ima918,ima921 FROM ",cl_get_target_table(l_plant_new,'ima_file'), #FUN-A50102
#                  " WHERE ima01 = '",l_ogb.ogb04,"'",
#                  "   AND imaacti = 'Y'"
# 
# 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
#     CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
#     PREPARE ima_ogb FROM l_sql2
# 
#     EXECUTE ima_ogb INTO g_ima918,g_ima921                                                                             
#FUN-C80001---end     
        IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
        
           #LET l_cnt = 0 #CHI-C40031 add  #FUN-C80001
           FOREACH p820_g_rvbs INTO l_rvbs.*
              IF STATUS THEN
                 CALL cl_err('rvbs',STATUS,1)
              END IF
        
              LET l_rvbs.rvbs00 = "axmt820"
     
              LET l_rvbs.rvbs01 = l_ogb.ogb01
          
              LET l_cnt = l_cnt + 1      #CHI-C40031 add
              LET l_rvbs.rvbs022 = l_cnt #CHI-C40031 add
             #IF g_sma.sma96 <> 'Y' THEN   #FUN-C80001 #FUN-D30099 mark
              IF g_pod.pod08 <> 'Y' THEN   #FUN-D30099  
              #LET l_rvbs.rvbs06 = l_rvbs.rvbs06 * l_ogb.ogb15_fac #CHI-C40031 mark 

#CHI-C40031---add---START
                 IF g_ogb.ogb17='Y' THEN        #多倉儲出貨
                    IF g_sma.sma115 = 'Y' THEN  #多單位
                       OPEN p820_g_ogg USING l_rvbs.rvbs13
                       FETCH p820_g_ogg INTO g_ogg.*
                          IF STATUS THEN
                             CALL cl_err('ogg',STATUS,1)
                          END IF
                          IF g_ima906 = '3' AND g_ogg.ogg20 = '2' THEN
                             LET l_rvbs.rvbs06 = l_rvbs.rvbs06 * 1
                          ELSE
                             LET l_rvbs.rvbs06 = l_rvbs.rvbs06 * g_ogg.ogg15_fac
                          END IF
                    ELSE
                       OPEN p820_g_ogc USING l_rvbs.rvbs13
                       FETCH p820_g_ogc INTO g_ogc.*
                          IF STATUS THEN
                             CALL cl_err('ogc',STATUS,1)
                          END IF
                          LET l_rvbs.rvbs06 = l_rvbs.rvbs06 * g_ogc.ogc15_fac
                    END IF
                 ELSE
                    LET l_rvbs.rvbs06 = l_rvbs.rvbs06 * l_ogb.ogb15_fac
                 END IF
#CHI-C40031---add-----END
              END IF   #FUN-C80001
              LET l_rvbs.rvbs09 = -1
 
              IF cl_null(l_rvbs.rvbs06) THEN
                 LET l_rvbs.rvbs06 = 0
              END IF
             #IF g_sma.sma96 <> 'Y' THEN   #FUN-C80001 #FUN-D30099 mark
              IF g_pod.pod08 <> 'Y' THEN   #FUN-D30099 
                 LET l_rvbs.rvbs13=0                 #No.CHI-990031
              END IF                       #FUN-C80001
              #新增批/序號資料檔
              EXECUTE ins_rvbs USING l_rvbs.rvbs00,l_rvbs.rvbs01,l_rvbs.rvbs02,
                                     l_rvbs.rvbs021,l_rvbs.rvbs022,l_rvbs.rvbs03,
                                     l_rvbs.rvbs04,l_rvbs.rvbs05,l_rvbs.rvbs06,
                                     l_rvbs.rvbs07,l_rvbs.rvbs08,l_rvbs.rvbs09,
                                     gp_plant,gp_legal   #FUN-980010
                                     ,l_rvbs.rvbs13                        #CHI-990031 add rvbs13
     
              IF STATUS OR SQLCA.SQLCODE THEN
                 LET g_showmsg = l_rvbs.rvbs01,"/",l_rvbs.rvbs03
                 CALL s_errmsg('rvbs01,rvbs03',g_showmsg,'ins rvbs:',SQLCA.sqlcode,1) 
                 LET g_success='N'
              END IF
        
              CALL p820_imgs(l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,l_oga.oga02,l_rvbs.*,p_i)  #FUN-C80001
     
           END FOREACH
        END IF

#FUN-B90012 ------------------Begin------------------------
        IF s_industry('icd') THEN 

        #FUN-BA0051 --START mark--
        #LET l_sql2 = "SELECT imaicd08 FROM ",cl_get_target_table(l_plant_new,'imaicd_file'),",",
        #                                     cl_get_target_table(l_plant_new,'ima_file'),
        #             " WHERE imaicd00 = '",l_ogb.ogb04,"'",
        #             "   AND ima01 = imaicd00 ",
        #             "   AND imaacti = 'Y'"
        #          
 	    #CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        
        #CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 
        #PREPARE p820_ogb_imaicd08 FROM l_sql2
        #  
        #EXECUTE p820_ogb_imaicd08 INTO l_imaicd08 
        # 
        #IF l_imaicd08 = 'Y' THEN
        #FUN-BA0051 --END mark--
           IF s_icdbin_multi(l_ogb.ogb04,l_plant_new) THEN   #FUN-BA0051 
              FOREACH p820_g_idd INTO l_idd.*
                 LET l_idd.idd10 = l_ogb.ogb01
                 LET l_idd.idd11 = l_ogb.ogb03 
        #CHI-C80009---add---START
                 LET l_idd.idd02 = l_ogb.ogb09
                 LET l_idd.idd03 = l_ogb.ogb091
                #IF g_sma.sma96 <> 'Y' THEN  #FUN-C80001 #FUN-D30099 mark
                 IF g_pod.pod08 <> 'Y' THEN  #FUN-D30099 
                    LET l_idd.idd04 = l_ogb.ogb092
                 END IF   #FUN-C80001
        #CHI-C80009---add-----END
                 CALL icd_idb(l_idd.*,l_plant_new)
              END FOREACH 
           END IF
           #FUN-C80001---begin  移到上面
           #LET l_sql1 = "SELECT ogbiicd028,ogbiicd029 FROM ",cl_get_target_table(l_plant_new,'ogbi_file'),
           #             " WHERE ogbi01 = '",l_ogb.ogb01,"'",
           #             "   AND ogbi03 =  ",l_ogb.ogb03
           #CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1
           #CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1
           #PREPARE p820_ogbi FROM l_sql1
           #EXECUTE p820_ogbi INTO l_ogbiicd028,l_ogbiicd029 
           #FUN-C80001  
           CALL s_icdpost(12,l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,l_ogb.ogb05,l_ogb.ogb12,l_ogb.ogb01,l_ogb.ogb03,
                          l_oga.oga02,'Y','','',l_ogbiicd029,l_ogbiicd028,l_plant_new)
                RETURNING l_flag1
           IF l_flag1 = 0 THEN
              LET g_success = 'N'
           END IF  
        END IF       
     END IF   #FUN-C80001 
#FUN-B90012 ------------------End--------------------------
 
     #單頭之出貨金額
     LET l_oga.oga50 =l_oga.oga50 + l_ogb.ogb14   #原幣出貨金額(未稅)
     LET l_oga.oga51 =l_oga.oga51 + l_ogb.ogb14t  #原幣出貨金額(含稅)
     LET l_oga.oga52 = l_oga.oga50 * l_oga.oga161/100
     LET l_oga.oga53 = l_oga.oga50 * (l_oga.oga162+l_oga.oga163)/100
 
     IF s_aza.aza50 = 'Y' THEN     #使用分銷功能
     #單頭之含稅出貨總金額
        LET l_oga.oga1008 =l_oga.oga1008 + l_ogb.ogb14t   #原幣出貨金額(含稅)
        #LET l_sql4="UPDATE ",l_dbs_tra CLIPPED,"oga_file",   #FUN-980092 add
        LET l_sql4="UPDATE ",cl_get_target_table(l_plant_new,'oga_file'), #FUN-A50102 
                   "   SET oga1008 = ? ",
                   " WHERE oga01 = ? "
 	    CALL cl_replace_sqldb(l_sql4) RETURNING l_sql4        #FUN-920032
        CALL cl_parse_qry_sql(l_sql4,l_plant_new) RETURNING l_sql4 #FUN-980092
        PREPARE upd_oga1008 FROM l_sql4
        EXECUTE upd_oga1008 USING l_oga.oga1008,l_oga.oga01
        IF SQLCA.sqlcode<>0 THEN
           CALL s_errmsg('oga01',l_oga.oga01,'upd oga:',SQLCA.sqlcode,1)  #No.FUN-710046
           LET g_success = 'N'
        END IF
     END IF
 
     #LET l_sql3="UPDATE ",l_dbs_tra CLIPPED,"oga_file",   #FUN-980092 add
     LET l_sql3="UPDATE ",cl_get_target_table(l_plant_new,'oga_file'), #FUN-A50102 
                "   SET oga50 = ?, ",
                "       oga51 = ?, ",
                "       oga52 = ?, ",
                "       oga53 = ? ",
                " WHERE oga01 = ? "
 	 CALL cl_replace_sqldb(l_sql3) RETURNING l_sql3        #FUN-920032
     CALL cl_parse_qry_sql(l_sql3,l_plant_new) RETURNING l_sql3 #FUN-980092
     PREPARE upd_oga50 FROM l_sql3
     EXECUTE upd_oga50 USING l_oga.oga50,l_oga.oga51,l_oga.oga52,
                             l_oga.oga53,l_oga.oga01
     IF SQLCA.sqlcode<>0 THEN
        CALL s_errmsg('oga01',l_oga.oga01,'upd oga:',SQLCA.sqlcode,1) #No.FUN-710046
        LET g_success = 'N'
     END IF
 
     IF s_aza.aza50 = 'Y' AND l_oea.oea00 = '6' THEN    #NO.FUN-620024
        CALL p820_ohbins()                              #NO.FUN-620024
     END IF                                             #NO.FUN-620024
   #LET l_sql2="SELECT oga011 FROM ",l_dbs_new CLIPPED,"oga_file", 
   LET l_sql2="SELECT oga011 FROM ",cl_get_target_table(l_plant_new,'oga_file'), #FUN-A50102    
              " WHERE oga01 = '",l_oga.oga01,"'"                                          
   CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
   CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
   PREPARE oga_t FROM l_sql2                                                
   EXECUTE oga_t INTO l_slip

   #LET l_sql2="UPDATE ",l_dbs_new CLIPPED,"oga_file",  
   LET l_sql2="UPDATE ",cl_get_target_table(l_plant_new,'oga_file'), #FUN-A50102   
              "   SET oga011  = ? ",                                          
              " WHERE oga01  = ? "                                           
   CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
   CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
   PREPARE upd_oga_t FROM l_sql2                                                
   EXECUTE upd_oga_t USING l_oga.oga01,l_slip
   IF SQLCA.sqlcode<>0 THEN                                                   
      CALL s_errmsg('oga01',l_oga.oga01,'upd oga:',SQLCA.sqlcode,1)
      LET g_success = 'N'                                                     
      RETURN                                                                  
   END IF
   #CHI-C80042 add start -----
   #回寫最近出庫日 ima74
   LET l_sql = "SELECT ima29 FROM ",cl_get_target_table(l_plant_new,'ima_file'),
               " WHERE ima01='",l_ogb.ogb04,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql
   PREPARE ima_p2 FROM l_sql
   IF SQLCA.SQLCODE THEN
     IF g_bgerr THEN
        CALL s_errmsg("ima01",l_ogb.ogb04,"",SQLCA.sqlcode,1)
     ELSE
        CALL cl_err3("","","","",SQLCA.sqlcode,"","",1)
     END IF
   END IF
   DECLARE ima_c2 CURSOR FOR ima_p2
   OPEN ima_c2
   FETCH ima_c2 INTO l_ima29
   #異動日期需大於原來的異動日期才可
   #必須判斷null,否則新料不會update
   IF (l_oga.oga02 > l_ima29 OR l_ima29 IS NULL)  THEN
      LET l_sql = "UPDATE ",cl_get_target_table(l_plant_new,'ima_file'),
                  " SET ima74 = ? , ima29 = ? WHERE ima01 = ?  "
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql
      PREPARE upd_ima1 FROM l_sql
      EXECUTE upd_ima1 USING l_oga.oga02,l_oga.oga02,l_ogb.ogb04
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
         IF g_bgerr THEN
            CALL s_errmsg('ima01',l_ogb.ogb04,'upd ima',STATUS,1)
         ELSE
            CALL cl_err('upd ima:',STATUS,1)
         END IF
         LET g_success='N'
      END IF
   END IF
   #CHI-C80042 add end  -----
END FUNCTION
 
FUNCTION p820_ohains()
 DEFINE l_oayauno LIKE oay_file.oayauno,  #自動編號否
        l_oay17   LIKE oay_file.oay17,    #銷退單別
        l_oay18   LIKE oay_file.oay18,    #銷退理由碼
        l_oay20   LIKE oay_file.oay20,    #債權代碼
        l_occ02   LIKE occ_file.occ02,    #客戶簡稱
        l_occ07   LIKE occ_file.occ07,    #收款客戶編號
        l_occ08   LIKE occ_file.occ08,    #慣用發票別
        l_occ09   LIKE occ_file.occ09,    #送貨客戶編號
        l_occ11   LIKE occ_file.occ11,    #稅號
        l_occ1023 LIKE occ_file.occ1023,  #收款客戶編號
        l_occ1005 LIKE occ_file.occ1005,  #所屬方
        l_occ1006 LIKE occ_file.occ1006,  #所屬渠道
        l_occ1022 LIKE occ_file.occ1022,  #發票客戶編號
        l_tqk04   LIKE tqk_file.tqk04     #收款條件編號
#DEFINE  l_sql     LIKE type_file.chr1000, #No.FUN-680137 VARCHAR(1200)   #CHI-940042 mark
#        l_sql1    LIKE type_file.chr1000  #No.FUN-680137 VARCHAR(1200)   #CHI-940042 mark
DEFINE  l_sql,l_sql1 STRING               #CHI-940042        
DEFINE  li_result LIKE type_file.num5     #TQC-9B0013
 
   #生成代送銷退單單頭
    INITIALIZE l_oha.* TO NULL
 
   #取得產生銷退單別
   LET l_t = s_get_doc_no(g_oga.oga01)
 
   LET l_sql1 = "SELECT oayauno,oay17,oay18,oay20 ",                            
                #" FROM ",l_dbs_new CLIPPED,"oay_file ", 
                " FROM ",cl_get_target_table(l_plant_new,'oay_file'), #FUN-A50102                
                " WHERE oayslip='",l_t,"'"                                      
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-A50102
   PREPARE oay_p2 FROM l_sql1                                                   
   IF SQLCA.SQLCODE THEN                                                        
      CALL s_errmsg('oayslip',l_t,'oay_p2',SQLCA.SQLCODE,0) #No.FUN-710046                                  
   END IF                                                                       
   DECLARE oay_c2 CURSOR FOR oay_p2                                             
   OPEN oay_c2                                                                  
   FETCH oay_c2 INTO l_oayauno,l_oay17,l_oay18,l_oay20                          
   IF SQLCA.SQLCODE <> 0 THEN                                                   
      LET g_success='N'                                                         
      RETURN                                                                    
   ELSE                                                                         
      LET g_oay18=l_oay18                                                       
   END IF                                                                       
   CLOSE oay_c2
 
       CALL s_auto_assign_no("axm",l_oay17,l_oga.oga02,"","oga_file","oga01",l_plant_new,"","")  #FUN-980092 add
          RETURNING li_result,g_oha01
       IF (NOT li_result) THEN 
          LET g_msg = l_plant_new CLIPPED,g_oha01
          CALL s_errmsg("oha01",g_oha01,g_msg CLIPPED,"mfg3046",1) 
          LET g_success ='N'
          RETURN
       END IF   
          LET l_oha.oha01 = g_oha01
   IF g_cnt = 0 THEN    
      CALL s_errmsg('','','','mfg3326',1)   #No.FUN-710046
      LET g_success = 'N'
      RETURN
   END IF
 
   LET l_sql1 = "SELECT occ07,occ08,occ09,occ1023,occ1005,occ1006,occ1022 ",    
                #" FROM ",l_dbs_new CLIPPED,"occ_file ", 
                " FROM ",cl_get_target_table(l_plant_new,'occ_file'), #FUN-A50102 
                " WHERE occ01 ='",l_oga.oga1004,"'"                             
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-A50102
   PREPARE occ_p1 FROM l_sql1                                                   
   IF SQLCA.SQLCODE THEN                                                        
      CALL s_errmsg('occ01',l_oga.oga1004,'occ_p1',SQLCA.SQLCODE,0)  #No.FUN-710046                                   
   END IF                                                                       
   DECLARE occ_c1 CURSOR FOR occ_p1                                             
   OPEN occ_c1                                                                  
   FETCH occ_c1 INTO l_occ07,l_occ08,l_occ09,l_occ1023,
                     l_occ1005,l_occ1006,l_occ1022
   IF SQLCA.SQLCODE <> 0 AND SQLCA.SQLCODE <> 100 THEN                                                   
      LET g_success='N'                                                         
      RETURN                                                                    
   END IF                                                                       
   CLOSE occ_c1
   
   IF cl_null(l_occ07) THEN LET l_occ07=' ' END IF
   IF cl_null(l_occ08) THEN LET l_occ08=' ' END IF
   IF cl_null(l_occ09) THEN LET l_occ09=' ' END IF
   IF cl_null(l_occ1005) THEN LET l_occ1005=' ' END IF
   IF cl_null(l_occ1006) THEN LET l_occ1006=' ' END IF
   IF cl_null(l_occ1023) THEN LET l_occ1023=' ' END IF
   IF cl_null(l_occ1022) THEN LET l_occ1022=' ' END IF
 
   LET l_sql1 = "SELECT occ02,occ11 ",    
                #" FROM ",l_dbs_new CLIPPED,"occ_file ", 
                " FROM ",cl_get_target_table(l_plant_new,'occ_file'), #FUN-A50102  
                " WHERE occ01 ='",l_occ07,"'"                             
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-A50102
   PREPARE occ_p2 FROM l_sql1                                                   
   IF SQLCA.SQLCODE THEN                                                        
      CALL s_errmsg('occ01',l_occ07,'occ_p2',SQLCA.SQLCODE,0) #No.FUN-710046                                   
   END IF                                                                       
   DECLARE occ_c2 CURSOR FOR occ_p2                                             
   OPEN occ_c2                                                                  
   FETCH occ_c2 INTO l_occ02,l_occ11                        
   IF SQLCA.SQLCODE <> 0 AND SQLCA.SQLCODE <> 100 THEN                          
      LET g_success='N'                                                         
      RETURN                                                                    
   END IF                                                                       
   CLOSE occ_c2
 
   IF cl_null(l_occ02) THEN LET l_occ02=' ' END IF
   IF cl_null(l_occ11) THEN LET l_occ11=' ' END IF
 
   LET l_sql1 = "SELECT tqk04 ",    
                #" FROM ",l_dbs_new CLIPPED,"tqk_file ", 
                " FROM ",cl_get_target_table(l_plant_new,'tqk_file'), #FUN-A50102 
                " WHERE tqk01 ='",l_oga.oga1004,"'",
                "   AND tqk02 ='",l_oga.oga1002,"'",
                "   AND tqk03 ='",l_occ1023,"'"
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-A50102
   PREPARE tqk_p1 FROM l_sql1                                                   
   IF SQLCA.SQLCODE THEN                                                        
      LET g_showmsg = l_oga.oga1004,"/",l_oga.oga1002,"/",l_occ1023         #No.FUN-710046                                   
      CALL s_errmsg('tqk01,tqk02,tqk03',g_showmsg,'tqk_p1',SQLCA.SQLCODE,0) #No.FUN-710046                                   
   END IF                                                                       
   DECLARE tqk_c1 CURSOR FOR tqk_p1                                             
   OPEN tqk_c1                                                                  
   FETCH tqk_c1 INTO l_tqk04                         
   IF SQLCA.SQLCODE <> 0 AND SQLCA.SQLCODE <> 100 THEN                          
      LET g_success='N'                                                         
      RETURN                                                                    
   END IF                                                                       
   CLOSE tqk_c1
 
   IF cl_null(l_tqk04) THEN LET l_tqk04=' ' END IF
   
   LET l_oha.oha01 = g_oha01               #銷退單號
   LET l_oha.oha02 = l_oga.oga02           #銷退日期
   LET l_oha.oha03 = l_occ07               #帳款客戶編號           
   LET l_oha.oha032 = l_occ02              #客戶簡稱
   LET l_oha.oha04 = l_oga.oga1004         #退貨客戶編號：代送商
   LET l_oha.oha05 = '1'                   #銷退別
   LET l_oha.oha08 = '1'                   #內銷
   LET l_oha.oha09 = '1'                   #銷退處理方式：銷退折讓
   LET l_oha.oha10 = ''                    #帳單編號
   LET l_oha.oha14 = l_oga.oga14           #人員編號
   LET l_oha.oha15 = l_oga.oga15           #部門編號
   LET l_oha.oha16 = ''                    #出貨單號
   LET l_oha.oha17 = ''                    # RMA單號
   LET l_oha.oha21 = l_oga.oga21           #稅別
   LET l_oha.oha211 = l_oga.oga211         #稅率 
   LET l_oha.oha212 = l_oga.oga212         #聯數
   LET l_oha.oha213 = l_oga.oga213         #含稅否
   LET l_oha.oha23 = l_oga.oga23           #幣別
   LET l_oha.oha24 = l_oga.oga24           #匯率
   LET l_oha.oha25 = l_oga.oga25           #銷售分類一
   LET l_oha.oha26 = l_oga.oga26           #銷售分類二
   LET l_oha.oha31 = l_oga.oga31           #價格條件編號
   LET l_oha.oha41 ='N'                    #三角貿易銷退單否
   LET l_oha.oha42 ='N'                    #是否入庫存
   LET l_oha.oha43 ='N'                    #起始三角貿易銷退單否
   LET l_oha.oha44 ='N'                    #拋轉否
   LET l_oha.oha50 = 0                     #原幣銷退金額(未稅)
   LET l_oha.oha53 = 0                     #原幣應開發票未稅金額
   LET l_oha.oha54 = 0                     #原幣已開發票未稅金額
   LET l_oha.ohaconf = 'Y'                 #確認否/作廢碼
   LET l_oha.ohapost = 'Y'                 #銷退扣帳否
   LET l_oha.ohaprsw = 0                   #列印次數
   LET l_oha.ohauser = g_user              #資料所有者
   LET l_oha.ohagrup = g_grup              #資料所有部門
   LET l_oha.ohadate = g_today             #最近修改日
   LET l_oha.oha1001 = l_occ1023           #收款客戶編號
   LET l_oha.oha1002 = l_oay20             #債權
   LET l_oha.oha1003 = l_oga.oga1003       #業績歸屬方
   LET l_oha.oha1004 = l_oay18             #退貨原因碼
   LET l_oha.oha1005 = l_oga.oga1005       #是否計算業績
   LET l_oha.oha1006 = 0                   #折扣金額(未稅)
   LET l_oha.oha1007 = 0                   #折扣金額(含稅)
   LET l_oha.oha1008 = 0                   #銷退單總含稅金額
   LET l_oha.oha1009 = l_occ1006           #客戶所屬渠道
   LET l_oha.oha1010 = l_occ1005           #客戶所屬方
   LET l_oha.oha1011 = l_occ1022           #開票客戶
   LET l_oha.oha1012 = ''                  #原始退單號       
   LET l_oha.oha1013 = ''                  #收料驗收單號
   LET l_oha.oha1014 = ''                  #代送商
   LET l_oha.oha1015 = 'Y'                 #是否對應代送出貨
   LET l_oha.oha1016 = l_oga.oga1004       #客戶編號  
   LET l_oha.oha1017 = 0                   #導物流狀況碼
   LET l_oha.oha1018 = l_oga.oga01         #代送出貨單號
   LET l_oha.ohaud01 = l_oga.ogaud01
   LET l_oha.ohaud02 = l_oga.ogaud02
   LET l_oha.ohaud03 = l_oga.ogaud03
   LET l_oha.ohaud04 = l_oga.ogaud04
   LET l_oha.ohaud05 = l_oga.ogaud05
   LET l_oha.ohaud06 = l_oga.ogaud06
   LET l_oha.ohaud07 = l_oga.ogaud07
   LET l_oha.ohaud08 = l_oga.ogaud08
   LET l_oha.ohaud09 = l_oga.ogaud09
   LET l_oha.ohaud10 = l_oga.ogaud10
   LET l_oha.ohaud11 = l_oga.ogaud11
   LET l_oha.ohaud12 = l_oga.ogaud12
   LET l_oha.ohaud13 = l_oga.ogaud13
   LET l_oha.ohaud14 = l_oga.ogaud14
   LET l_oha.ohaud15 = l_oga.ogaud15
   IF cl_null(l_oha.oha57) THEN LET l_oha.oha57 = '1' END IF #FUN-AC0055 add   
 
   #LET l_sql="INSERT INTO ",l_dbs_tra CLIPPED,"oha_file ",    #FUN-980092 add 
   LET l_sql="INSERT INTO ",cl_get_target_table(l_plant_new,'oha_file'), #FUN-A50102   
               "( oha01,oha02,oha03,oha032,oha04, ",                            
               "  oha05,oha08,oha09,oha10,oha14,",                              
               "  oha15,oha16,oha17,oha21,oha211,",                             
               "  oha212,oha213,oha23,oha24,oha25,",                            
               "  oha26,oha31,oha41,oha42,oha43,",                              
               "  oha44,oha50,oha53,oha54,ohaconf,",                            
               "  ohapost,ohaprsw,ohauser,ohagrup,",                            
               "  ohadate,oha1001,oha1002,oha1003,oha1004,",                    
               "  oha1005,oha1006,oha1007,oha1008,oha1009,",                    
               "  oha1010,oha1011,oha1012,oha1013,oha1014,",                    
               "  oha1015,oha1016,oha1017,oha1018, ",                           
               "  ohaplant,ohalegal , ",
               "  ohaud01,ohaud02,ohaud03,ohaud04,ohaud05,",
               "  ohaud06,ohaud07,ohaud08,ohaud09,ohaud10,",
               "  ohaud11,ohaud12,ohaud13,ohaud14,ohaud15,ohaoriu,ohaorig,oha57)",  #FUN-A10036 #FUN-AC0055 add oha57
               "  VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",                 
                         "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",                 
                         "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",                 
                         "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,",   #No.CHI-950020
                         "?,?,?,?, ?,  ?,?,?,?,?) "  #FUN-980010  #FUNA-A10036                          
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
   PREPARE ins_oha FROM l_sql                                                   
   EXECUTE ins_oha USING                                                        
      l_oha.oha01,l_oha.oha02,l_oha.oha03,l_oha.oha032,l_oha.oha04,             
      l_oha.oha05,l_oha.oha08,l_oha.oha09,l_oha.oha10,l_oha.oha14,              
      l_oha.oha15,l_oha.oha16,l_oha.oha17,l_oha.oha21,l_oha.oha211,             
      l_oha.oha212,l_oha.oha213,l_oha.oha23,l_oha.oha24,l_oha.oha25,            
      l_oha.oha26,l_oha.oha31,l_oha.oha41,l_oha.oha42,l_oha.oha43,
      l_oha.oha44,l_oha.oha50,l_oha.oha53,l_oha.oha54,l_oha.ohaconf,            
      l_oha.ohapost,l_oha.ohaprsw,l_oha.ohauser,l_oha.ohagrup,                  
      l_oha.ohadate,l_oha.oha1001,l_oha.oha1002,l_oha.oha1003,l_oha.oha1004,    
      l_oha.oha1005,l_oha.oha1006,l_oha.oha1007,l_oha.oha1008,l_oha.oha1009,    
      l_oha.oha1010,l_oha.oha1011,l_oha.oha1012,l_oha.oha1013,l_oha.oha1014,    
      l_oha.oha1015,l_oha.oha1016,l_oha.oha1017,l_oha.oha1018,
      gp_plant,gp_legal   #FUN-980010
     ,l_oha.ohaud01,l_oha.ohaud02,l_oha.ohaud03,l_oha.ohaud04,l_oha.ohaud05,
      l_oha.ohaud06,l_oha.ohaud07,l_oha.ohaud08,l_oha.ohaud09,l_oha.ohaud10,
      l_oha.ohaud11,l_oha.ohaud12,l_oha.ohaud13,l_oha.ohaud14,l_oha.ohaud15,g_user,g_grup,  #FUN-A10036
      l_oha.oha57  #FUN-AC0055 add oha57
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('oha01',l_oha.oha01,'',SQLCA.sqlcode,1)  #No.FUN-710046
         LET g_success = 'N'
         RETURN
      END IF
END FUNCTION
 
FUNCTION p820_ohbins()
 DEFINE l_ohb03   LIKE ohb_file.ohb03,    #項次
        l_occ1027 LIKE occ_file.occ1027,  #是否更改訂單單價
        l_unit    LIKE ogb_file.ogb916,   #計價單位
        l_ohb1001 LIKE ohb_file.ohb1001,  #訂價編號
        l_ohb13   LIKE ohb_file.ohb13,    #原幣單價
        l_ohb14   LIKE ohb_file.ohb14,    #原幣稅前金額
        l_ohb13t  LIKE ohb_file.ohb13,    #原幣含稅單價
        l_ohb14t  LIKE ohb_file.ohb14t,   #原幣含稅金額
        l_oay18   LIKE oay_file.oay18,    #銷退理由碼
        p_success LIKE type_file.chr4     #No.FUN-680137 VARCHAR(04)
#DEFINE l_sql     LIKE type_file.chr1000, #No.FUN-680137 VARCHAR(1200)   #CHI-940042 mark
#       l_sql2    LIKE type_file.chr1000, #No.FUN-680137 VARCHAR(1200)   #CHI-940042 mark
#       l_sql3    LIKE type_file.chr1000  #No.FUN-680137 VARCHAR(1200)   #CHI-940042 mark
 DEFINE l_sql,l_sql2,l_sql3 STRING        #CHI-940042        
 DEFINE l_ohbi   RECORD LIKE ohbi_file.*  #FUN-B70074 add
#DEFINE l_oia07  LIKE oia_file.oia07    #FUN-C50136 add
 DEFINE l_oha14  LIKE oha_file.oha14    #FUN-CB0087
 DEFINE l_oha15  LIKE oha_file.oha15    #FUN-CB0087
 
    #生成代送銷退單單身 
 
    INITIALIZE l_ohb.* TO NULL
    #產生銷退單身
    LET l_sql = "SELECT MAX(ohb03)+1 ",    
                #" FROM ",l_dbs_tra CLIPPED,"ohb_file ",   #FUN-980092 add 
                " FROM ",cl_get_target_table(l_plant_new,'ohb_file'), #FUN-A50102 
                " WHERE ohb01 ='",g_oha01,"'"                             
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
    PREPARE ohb_p1 FROM l_sql                                                    
    IF SQLCA.SQLCODE THEN                                                        
       CALL s_errmsg('ohb01',g_oha01,'ohb_p1',SQLCA.SQLCODE,0) #No.FUN-710046                                  
    END IF                                                                       
    DECLARE ohb_c1 CURSOR FOR ohb_p1                                             
    OPEN ohb_c1                                                                  
    FETCH ohb_c1 INTO l_ohb03                         
    IF SQLCA.SQLCODE <> 0 AND SQLCA.SQLCODE <> 100 THEN                          
       LET g_success='N'                                                         
       RETURN                                                                    
    END IF                                                                       
    CLOSE ohb_c1
 
    IF cl_null(l_ohb03) OR l_ohb03 = 0 THEN
       LET l_ohb03 = 1
    END IF  
 
    LET l_sql = "SELECT occ1027 ",    
                #" FROM ",l_dbs_new CLIPPED,"occ_file ",  
                " FROM ",cl_get_target_table(l_plant_new,'occ_file'), #FUN-A50102                  
                " WHERE occ01 ='",l_oga.oga1004,"'",
                "   AND occ1014 = '3'"                             
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
    PREPARE occ_p3 FROM l_sql                                                    
    IF SQLCA.SQLCODE THEN                                                        
       LET g_showmsg = l_oga.oga1004,"/",'3'  #No.FUN-710046                                  
       CALL s_errmsg('occ01,occ1014',g_showmsg,'occ_p3',SQLCA.SQLCODE,0)  #No.FUN-710046                                   
    END IF                                                                       
    DECLARE occ_c3 CURSOR FOR occ_p3                                             
    OPEN occ_c3                                                                  
    FETCH occ_c3 INTO l_occ1027                         
    CLOSE occ_c3
 
    IF l_occ1027 ='Y' THEN
       CALL s_errmsg('','',l_oga.oga1004,'atm-255',1) #No.FUN-710046 
       LET g_success='N'   
       RETURN
    END IF
 
    #根據客戶+產品編號+單位+日期+定價類型取定價編號及單價  
    IF g_sma.sma116 MATCHES '[23]' THEN 
       LET l_unit=l_ogb.ogb916
    ELSE
       LET l_unit=l_ogb.ogb05
    END IF 
 
    CALL s_fetch_price2(l_oga.oga1004,l_ogb.ogb04,l_unit,l_oga.oga02,'1',
                        l_plant_new,l_oga.oga23)   #No.FUN-980059
         RETURNING l_ohb1001,l_ohb13,p_success        
    IF p_success ='N' THEN                                             
       CALL s_errmsg('','','fetch price','atm-256',1)  #No.FUN-710046
       LET  g_success='N'
       RETURN                                              
    END IF
 
    #根據單頭單價是否含稅 進行未稅、含稅金額的計算
    IF l_oga.oga213='N' THEN
       LET l_ohb14 = l_ohb13*l_ogb.ogb12
       LET l_ohb13t = l_ohb13*(1+g_oga.oga211/100)
       LET l_ohb14t = l_ohb13t*l_ogb.ogb12
    ELSE
       LET l_ohb13t = l_ohb13/(1+g_oga.oga211/100)
       LET l_ohb14 = l_ohb13t*l_ogb.ogb12       
       LET l_ohb14t = l_ohb13*l_ogb.ogb12      
    END IF

    LET l_ohb.ohb01     = g_oha01             #銷退單號
    LET l_ohb.ohb03     = l_ohb03             #項次
    LET l_ohb.ohb04     = l_ogb.ogb04         #產品編號
    LET l_ohb.ohb05     = l_ogb.ogb05         #銷售單位
    LET l_ohb.ohb05_fac = l_ogb.ogb05_fac     #銷售/庫存單位換算率
    LET l_ohb.ohb910    = l_ogb.ogb910        #第一單位
    LET l_ohb.ohb911    = l_ogb.ogb911        #第一單位轉換率
    LET l_ohb.ohb912    = l_ogb.ogb912        #第一單位數量
    LET l_ohb.ohb913    = l_ogb.ogb913        #第二單位
    LET l_ohb.ohb914    = l_ogb.ogb914        #第二單位轉換率
    LET l_ohb.ohb915    = l_ogb.ogb915        #第二單位數量
    LET l_ohb.ohb916    = l_ogb.ogb916        #計價單位
    LET l_ohb.ohb917    = l_ogb.ogb917        #計價數量
    LET l_ohb.ohb06     = l_ogb.ogb06         #品名規格
    LET l_ohb.ohb07     = l_ogb.ogb07         #額外品名規格
    LET l_ohb.ohb08     = l_ogb.ogb08         #銷退工廠
    LET l_ohb.ohb09     = l_ogb.ogb09         #銷退倉庫
    LET l_ohb.ohb091    = l_ogb.ogb091        #銷退庫位
    LET l_ohb.ohb092    = l_ogb.ogb092        #銷退批號
    LET l_ohb.ohb11     = l_ogb.ogb11         #客戶產品編號
    LET l_ohb.ohb12     = l_ogb.ogb12         #銷退數量
    LET l_ohb.ohb13     = l_ohb13             #原幣單價
    LET l_ohb.ohb14     = l_ohb14             #原幣稅前金額
    LET l_ohb.ohb14t    = l_ohb14t            #原幣含稅金額
    LET l_ohb.ohb15     = l_ogb.ogb15         #庫存明細單位
    LET l_ohb.ohb15_fac = l_ogb.ogb15_fac     #銷售/庫存明細單位換算率
    LET l_ohb.ohb16     = l_ogb.ogb16         #數量
    LET l_ohb.ohb30     = ''                  #原出貨發票號
    LET l_ohb.ohb31     = ''                  #出貨單號
    LET l_ohb.ohb32     = ''                  #出貨項次
    LET l_ohb.ohb33     = ''                  #訂單單號  
    LET l_ohb.ohb34     = ''                  #訂單項次
    LET l_ohb.ohb50     = g_oay18             #退貨理由碼
    IF cl_null(l_ohb.ohb50) THEN LET l_ohb.ohb50 = g_poy.poy31 END IF  #TQC-D40064 add
    #TQC-D20047--add--str--
    LET l_sql2 = "SELECT aza115 FROM ",cl_get_target_table(l_plant_new,'aza_file')," WHERE aza01 = '0' "
    PREPARE aza115_pr2 FROM l_sql2
    EXECUTE aza115_pr2 INTO g_aza.aza115   
    #TQC-D20047--add--end--
    #FUN-CB0087--add--str---
    IF g_aza.aza115 ='Y' THEN 
       IF cl_null(l_ohb.ohb50) THEN  #TQC-D20067 mark  #TQC-D40064 remark
         #SELECT oha14,oha15 INTO l_oha14,l_oha15 FROM oha_file WHERE oha01 = l_ohb.ohb01
         #TQC-D20042--add--str--
         LET l_sql3 ="SELECT oha14,oha15 FROM ",cl_get_target_table(l_plant_new,'oha_file')," WHERE oha01 = '",l_ohb.ohb01,"'"
         PREPARE ohb50_pr FROM l_sql3
         EXECUTE ohb50_pr INTO l_oha14,l_oha15  
         #TQC-D20042--add--end--
         #CALL s_reason_code(l_ohb.ohb01,l_ohb.ohb31,'',l_ohb.ohb04,l_ohb.ohb09,l_oha14,l_oha15) RETURNING l_ohb.ohb50   #TQC-D20042 mark
          CALL s_reason_code1(l_ohb.ohb01,l_ohb.ohb31,'',l_ohb.ohb04,l_ohb.ohb09,l_oha14,l_oha15,l_plant_new) RETURNING l_ohb.ohb50  #TQC-D20042
          IF cl_null(l_ohb.ohb50) THEN
             #CALL cl_err(l_ohb.ohb50,'aim-425',1)   #TQC-D20047
             LET g_showmsg = l_plant_new,"/",l_ohb.ohb01                #TQC-D20047       
             CALL s_errmsg('oha01',g_showmsg,'up ohb50:','aim-425',1)   #TQC-D20047
             LET g_success="N"
             RETURN
          END IF          
       END IF  #TQC-D20067 mark  #TQC-D40064 remark
    END IF
    #FUN-CB0087--add--end--
    LET l_ohb.ohb60     = 0                   #已開折讓數量
    LET l_ohb.ohb1001   = l_ohb1001           #定價編號
    LET l_ohb.ohb1002   = l_ogb.ogb1004       #提案編號   
    LET l_ohb.ohb1003   = l_ogb.ogb1006       #折扣率          
    LET l_ohb.ohb1005   = l_ogb.ogb1005       #No.MOD-680058
    LET l_ohb.ohbud01   = l_ogb.ogbud01
    LET l_ohb.ohbud02   = l_ogb.ogbud02
    LET l_ohb.ohbud03   = l_ogb.ogbud03
    LET l_ohb.ohbud04   = l_ogb.ogbud04
    LET l_ohb.ohbud05   = l_ogb.ogbud05
    LET l_ohb.ohbud06   = l_ogb.ogbud06
    LET l_ohb.ohbud07   = l_ogb.ogbud07
    LET l_ohb.ohbud08   = l_ogb.ogbud08
    LET l_ohb.ohbud09   = l_ogb.ogbud09
    LET l_ohb.ohbud10   = l_ogb.ogbud10
    LET l_ohb.ohbud11   = l_ogb.ogbud11
    LET l_ohb.ohbud12   = l_ogb.ogbud12
    LET l_ohb.ohbud13   = l_ogb.ogbud13
    LET l_ohb.ohbud14   = l_ogb.ogbud14
    LET l_ohb.ohbud15   = l_ogb.ogbud15
 
    LET l_sql3 = "SELECT azf10 ",                            
                 #" FROM ",l_dbs_new CLIPPED,"azf_file ",
                 " FROM ",cl_get_target_table(l_plant_new,'azf_file'), #FUN-A50102                   
                 " WHERE azf01 = '",l_ohb.ohb50,"'",
                 "   AND azf02 = '2'"          #No.TQC-760054                                      
 	 CALL cl_replace_sqldb(l_sql3) RETURNING l_sql3        #FUN-920032
     CALL cl_parse_qry_sql(l_sql3,l_plant_new) RETURNING l_sql3 #FUN-A50102
    PREPARE azf_p2 FROM l_sql3                                                   
    IF SQLCA.SQLCODE THEN                                                        
       CALL s_errmsg('azf01',l_ohb.ohb50,'azf_p2',SQLCA.SQLCODE,0) #No.FUN-710046
    END IF                                                                       
    DECLARE azf_c2 CURSOR FOR azf_p2                                             
    OPEN azf_c2                                                                  
    FETCH azf_c2 INTO l_ohb.ohb1004                          
    IF SQLCA.SQLCODE <> 0 THEN                                                   
       LET g_success='N'                                                         
       RETURN                                                                    
    END IF                                                                       
    CLOSE azf_c2     #No.FUN-6B0065
 
    IF l_ohb.ohb1004 = 'Y' THEN
       LET l_ohb.ohb14 = 0
       LET l_ohb.ohb14t= 0
    END IF
              
    #LET l_sql="INSERT INTO ",l_dbs_tra CLIPPED,"ohb_file ",    #FUN-980092 add
    #FUN-AB0061----------add---------------str----------------
    IF cl_null(l_ohb.ohb37) OR l_ohb.ohb37 = 0 THEN
       LET l_ohb.ohb37 = l_ohb.ohb13
    END IF
    #FUN-AB0061----------add---------------end----------------
    #FUN-AB0096 ---------------add start---------------------
    #IF cl_null(l_ohb.ohb71) THEN   #FUN-AC0055 mark
    #   LET l_ohb.ohb71 = '1'
    #END IF
    #FUN-AB0096 --------------add end-------------------------
    LET l_sql="INSERT INTO ",cl_get_target_table(l_plant_new,'ohb_file'), #FUN-A50102    
                "( ohb01,ohb03,ohb04,ohb05,ohb05_fac, ",                         
                "  ohb910,ohb911,ohb912,ohb913,ohb914,",                         
                "  ohb915,ohb916,ohb917,ohb06,ohb07,",                           
                "  ohb08,ohb09,ohb091,ohb092,ohb11,",                            
                "  ohb12,ohb37,ohb13,ohb14,ohb14t,ohb15,",    #FUN-AB0061 add ohb37                                
                "  ohb15_fac,ohb16,ohb30,ohb31,ohb32,",                          
                "  ohb33,ohb34,ohb50,ohb60,ohb1001,",                            
                "  ohb1002,ohb1003,ohb1004,ohb1005, ",    #No.MOD-680058                                               
                "  ohbplant,ohblegal, ",
                "  ohbud01,ohbud02,ohbud03,ohbud04,ohbud05,",
                "  ohbud06,ohbud07,ohbud08,ohbud09,ohbud10,",
                #"  ohbud11,ohbud12,ohbud13,ohbud14,ohbud15,ohb71)",       #FUN-AB0096 add ohb71
                "  ohbud11,ohbud12,ohbud13,ohbud14,ohbud15)",     #FUN-AC0055 remove ohb71
                "  VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",                 
                          "?,?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",  #FUN-AB0061 add ?               
                          "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,",  #No.CHI-950020
                          "?,?,?,?, ?,?,?,  ?,? ) "      #No.MOD-680058  #FUN-980010          #FUN-AB0096 add ?        
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
    PREPARE ins_ohb FROM l_sql                                                   
    EXECUTE ins_ohb USING                                                        
       l_ohb.ohb01,l_ohb.ohb03,l_ohb.ohb04,l_ohb.ohb05,l_ohb.ohb05_fac,          
       l_ohb.ohb910,l_ohb.ohb911,l_ohb.ohb912,l_ohb.ohb913,l_ohb.ohb914,         
       l_ohb.ohb915,l_ohb.ohb916,l_ohb.ohb917,l_ohb.ohb06,l_ohb.ohb07,           
       l_ohb.ohb08,l_ohb.ohb09,l_ohb.ohb091,l_ohb.ohb092,l_ohb.ohb11,            
       l_ohb.ohb12,l_ohb.ohb37,l_ohb.ohb13,l_ohb.ohb14,l_ohb.ohb14t,l_ohb.ohb15,    #FUN-AB0061 add ohb37         
       l_ohb.ohb15_fac,l_ohb.ohb16,l_ohb.ohb30,l_ohb.ohb31,l_ohb.ohb32,          
       l_ohb.ohb33,l_ohb.ohb34,l_ohb.ohb50,l_ohb.ohb60,l_ohb.ohb1001,            
       l_ohb.ohb1002,l_ohb.ohb1003,l_ohb.ohb1004,l_ohb.ohb1005, #No.MOD-680058
       gp_plant,gp_legal   #FUN-980010
      ,l_ohb.ohbud01,l_ohb.ohbud02,l_ohb.ohbud03,l_ohb.ohbud04,l_ohb.ohbud05,
       l_ohb.ohbud06,l_ohb.ohbud07,l_ohb.ohbud08,l_ohb.ohbud09,l_ohb.ohbud10,
       #l_ohb.ohbud11,l_ohb.ohbud12,l_ohb.ohbud13,l_ohb.ohbud14,l_ohb.ohbud15,l_ohb.ohb71   #FUN-AB0096 add ohb71
       l_ohb.ohbud11,l_ohb.ohbud12,l_ohb.ohbud13,l_ohb.ohbud14,l_ohb.ohbud15  #FUN-AC0055 remove ohb71 

     IF SQLCA.sqlcode THEN
        LET g_showmsg = l_ohb.ohb01,"/",l_ohb.ohb03               #No.FUN-710046
        CALL s_errmsg('ohb01,ohb03',g_showmsg,'',SQLCA.sqlcode,1) #No.FUN-710046
        LET g_success = 'N'
        RETURN
#FUN-B70074--add--insert--
     ELSE
        IF NOT s_industry('std') THEN
           INITIALIZE l_ohbi.* TO NULL
           LET l_ohbi.ohbi01 = l_ohb.ohb01
           LET l_ohbi.ohbi03 = l_ohb.ohb03
           IF NOT s_ins_ohbi(l_ohbi.*,l_plant_new ) THEN
              LET g_success = 'N'  
              RETURN
           END IF
        END IF 
#FUN-B70074--add--insert--
#       #FUN-C50136----add----str----
#       IF g_oaz.oaz96 ='Y' THEN
#          CALL s_ccc_oia07('G',l_oha.oha03) RETURNING l_oia07
#          IF l_oia07 = '0' THEN
#             CALL s_ccc_oia(l_oha.oha03,'G',l_oha.oha01,0,l_plant_new)
#          END IF
#       END IF
#       #FUN-C50136----add----end----
     END IF
 
     LET l_oha.oha50  =l_oha.oha50  +l_ohb.ohb14                                  
     LET l_oha.oha53  =l_oha.oha53  +l_ohb.ohb14                                  
     LET l_oha.oha1008=l_oha.oha1008+l_ohb.ohb14t                                 
                                                                                   
     #LET l_sql2="UPDATE ",l_dbs_tra CLIPPED,"oha_file",  #FUN-980092 add
     LET l_sql2="UPDATE ",cl_get_target_table(l_plant_new,'oha_file'), #FUN-A50102
                "   SET oha50  = ? ,",                                            
                "       oha53  = ?, ",                                            
                "       oha1008= ? ",                                             
                " WHERE oha01  = ?  "                                             
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
     PREPARE upd_oha FROM l_sql2                                                  
     EXECUTE upd_oha USING l_oha.oha50,l_oha.oha53,                               
                           l_oha.oha1008,l_oha.oha01                              
     IF SQLCA.sqlcode<>0 THEN                                                     
        CALL s_errmsg('oha01',l_oha.oha01,'upd oha:',SQLCA.sqlcode,1) #No.FUN-710046                                  
        LET g_success = 'N'                                                       
        RETURN                                                                    
     END IF
 
END FUNCTION
 
#no.4495 insert 出貨通知單頭
FUNCTION p820_t_ogains()
  DEFINE l_sql  LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1200)   
  DEFINE l_sql1 LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(600)  
  DEFINE l_sql2 LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1600)
  DEFINE i,l_i  LIKE type_file.num5    #No.FUN-680137 SMALLINT
   
  #讀取該流程代碼之銷單資料
   LET l_sql1 = "SELECT * ",
                #" FROM ",l_dbs_tra CLIPPED,"oea_file ",  #FUN-980092 add
                " FROM ",cl_get_target_table(l_plant_new,'oea_file'), #FUN-A50102
                " WHERE oea99='",g_oea.oea99,"' ",     #MOD-770131 mark
                "   AND oeaconf = 'Y' " #01/08/16 mandy
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-980092
   PREPARE toea_p1 FROM l_sql1
   IF SQLCA.SQLCODE THEN CALL cl_err('oea_p1',SQLCA.SQLCODE,1) END IF
   DECLARE toea_c1 CURSOR FOR toea_p1
   OPEN toea_c1
   FETCH toea_c1 INTO l_oea.*
   IF SQLCA.SQLCODE <> 0 THEN
      LET g_success='N'
      RETURN
   END IF
   CLOSE toea_c1
 
  #新增出貨通知單單頭檔(oga_file)
    LET x_oga.oga00 = l_oea.oea00        #出貨別
    LET x_oga.oga01 = l_oga.oga011       #出貨通知單號
    LET g_t1 = s_get_doc_no(x_oga.oga01) #No.FUN-550070 
        CALL s_auto_assign_no("axm",g_t1,t_oga.oga02,"","oga_file","oga01",l_plant_new,"","") #NO.FUN-620024 #FUN-980092 add
        RETURNING g_sw,x_oga.oga01
    LET x_oga.oga011= l_oga.oga01        #出貨單號   #TQC-760146 add
    LET x_oga.oga02 = t_oga.oga02        #出貨日期
    LET x_oga.oga021= t_oga.oga021       #結關日期
    LET x_oga.oga022= t_oga.oga022       #裝船日期
    LET x_oga.oga03 = l_oea.oea03
    LET x_oga.oga032= l_oea.oea032
    LET x_oga.oga033= l_oea.oea033
    LET x_oga.oga04 = l_oea.oea04
    LET x_oga.oga044= l_oea.oea044
    LET x_oga.oga05 = l_oea.oea05
    LET x_oga.oga06 = l_oea.oea06
    LET x_oga.oga07 = l_oea.oea07
    LET x_oga.oga08 = l_oea.oea08
    LET x_oga.oga09 = '5'
    LET x_oga.oga10 = null
    LET x_oga.oga11 = null
    LET x_oga.oga12 = null
    LET x_oga.oga13 = g_oga.oga13   #NO.FUN-660068
    LET x_oga.oga14 = l_oea.oea14
    LET x_oga.oga15 = l_oea.oea15
    LET x_oga.ogaud01 = t_oga.ogaud01
    LET x_oga.ogaud02 = t_oga.ogaud02
    LET x_oga.ogaud03 = t_oga.ogaud03
    LET x_oga.ogaud04 = t_oga.ogaud04
    LET x_oga.ogaud05 = t_oga.ogaud05
    LET x_oga.ogaud06 = t_oga.ogaud06
    LET x_oga.ogaud07 = t_oga.ogaud07
    LET x_oga.ogaud08 = t_oga.ogaud08
    LET x_oga.ogaud09 = t_oga.ogaud09
    LET x_oga.ogaud10 = t_oga.ogaud10
    LET x_oga.ogaud11 = t_oga.ogaud11
    LET x_oga.ogaud12 = t_oga.ogaud12
    LET x_oga.ogaud13 = t_oga.ogaud13
    LET x_oga.ogaud14 = t_oga.ogaud14
    LET x_oga.ogaud15 = t_oga.ogaud15
    IF cl_null(g_oga.oga16) THEN
       LET x_oga.oga16 = g_oga.oga16
    ELSE 
       LET x_oga.oga16 = l_oea.oea01                     #NO.FUN-620024
    END IF
    LET x_oga.oga161= l_oea.oea161
    LET x_oga.oga162= l_oea.oea162
    LET x_oga.oga163= l_oea.oea163
    LET x_oga.oga18 = l_oea.oea17
    LET x_oga.oga19 = null
    LET x_oga.oga20 = 'Y'
    LET x_oga.oga21 = l_oea.oea21
    LET x_oga.oga211= l_oea.oea211
    LET x_oga.oga212= l_oea.oea212
    LET x_oga.oga213= l_oea.oea213
    LET x_oga.oga23 = l_oea.oea23
    #CALL p820_azi(l_oea.oea23,l_dbs_new)   #讀取幣別資料   #FUN-670007
    CALL p820_azi(l_oea.oea23,l_plant_new)    #FUN-A50102
 
    #出貨時重新抓取匯率
    CALL s_currm(x_oga.oga23,x_oga.oga02,g_oax.oax01,l_plant_new)   #FUN-980020
        RETURNING x_oga.oga24
 
    #若出貨單頭之幣別=本幣幣別, 則匯率給1, (COI美金立帳, 99.03.05)
    IF x_oga.oga23 = l_aza.aza17 THEN
       LET x_oga.oga24=1
    END IF
    IF cl_null(x_oga.oga24) THEN LET x_oga.oga24=l_oea.oea24 END IF
    LET x_oga.oga25 = l_oea.oea25
    LET x_oga.oga26 = l_oea.oea26
    LET x_oga.oga27 = t_oga.oga27
    LET x_oga.oga28 = l_oea.oea18
    LET x_oga.oga29 = 0
    LET x_oga.oga30 = 'Y'
    LET x_oga.oga31 = l_oea.oea31
    LET x_oga.oga32 = l_oea.oea32
    LET x_oga.oga33 = l_oea.oea33
    LET x_oga.oga34 = 0
    LET x_oga.oga35 = t_oga.oga35
    LET x_oga.oga36 = t_oga.oga36
    LET x_oga.oga37 = t_oga.oga37
    LET x_oga.oga38 = t_oga.oga38
    LET x_oga.oga39 = t_oga.oga39
    LET x_oga.oga40 = l_oea.oea19
    LET x_oga.oga41 = l_oea.oea41
    LET x_oga.oga42 = l_oea.oea42
    LET x_oga.oga43 = l_oea.oea43
    LET x_oga.oga44 = l_oea.oea44
    LET x_oga.oga45 = l_oea.oea45
    LET x_oga.oga46 = l_oea.oea46
    LET x_oga.oga47 = t_oga.oga47
    LET x_oga.oga48 = t_oga.oga48
    LET x_oga.oga49 = t_oga.oga49
    LET x_oga.oga50 = 0
    LET x_oga.oga52 = 0
    LET x_oga.oga53 = 0
    LET x_oga.oga54 = 0
    LET x_oga.oga57 ='1'              #FUN-AC0055 add
    LET x_oga.oga65 = l_oea.oea65     #FUN-7B0091 add
    LET x_oga.oga99 = g_flow99        #No.7993
    LET x_oga.oga901='N'
    LET x_oga.oga905='Y'
    LET x_oga.oga906='N'
    LET x_oga.oga909='Y'
    IF s_aza.aza50 = 'Y' THEN
       LET x_oga.oga1001=l_oea.oea1001   #收款客戶編號
       LET x_oga.oga1002=l_oea.oea1002   #債權代碼
       LET x_oga.oga1003=l_oea.oea1003   #業績歸屬方
       LET x_oga.oga1004=l_oea.oea1004   #代送商
       LET x_oga.oga1005=l_oea.oea1005   #是否計算業績
       LET x_oga.oga1006=0               #未稅金額
       LET x_oga.oga1007=0               #含稅金額
       LET x_oga.oga1008=0               #出貨總含稅金額
       LET x_oga.oga1009=l_oea.oea1009   #客戶所屬渠道
       LET x_oga.oga1010=l_oea.oea1010   #客戶所屬方
       LET x_oga.oga1011=l_oea.oea1011   #開票客戶
       LET x_oga.oga1012=''              #銷退單單號   
       LET x_oga.oga1013='N'             #已打印提案否
       LET x_oga.oga1014='N'             #是否對應代送銷退單
       LET x_oga.oga1015='0'             #導物流狀況碼
    END IF
    LET x_oga.ogaconf='Y'
    LET x_oga.oga55 = '1' #MOD-C40162 add
    LET x_oga.ogapost='Y'
    LET x_oga.ogaprsw=0
    LET x_oga.ogauser=g_user
    LET x_oga.ogagrup=g_grup
    LET x_oga.ogamodu=null
    LET x_oga.ogadate=null
    #新增出貨單頭檔(oga_file)
    #LET l_sql2="INSERT INTO ",l_dbs_tra CLIPPED,"oga_file",   #FUN-980092 add
    LET l_sql2="INSERT INTO ",cl_get_target_table(l_plant_new,'oga_file'), #FUN-A50102
               "( oga00,oga01,oga011,oga02, ",
               "  oga021,oga022,oga03,oga032,",
               "  oga033,oga04,oga044,oga05,",
               "  oga06,oga07,oga08,oga09,",
               "  oga10,oga11,oga12,oga13,",
               "  oga14,oga15,oga16,oga161,",
               "  oga162,oga163,oga17,oga18,",
               "  oga19,oga20,oga21,oga211,",
               "  oga212,oga213,oga23,oga24,",
               "  oga25,oga26,oga27,oga28,",
               "  oga29,oga30,oga31,oga32,",
               "  oga33,oga34,oga35,",
               "  oga36,oga37,oga38,oga39,",
               "  oga40,oga41,oga42,oga43,",
               "  oga44,oga45,oga46,oga47,",
               "  oga48,oga49,oga50,oga52,",
               "  oga53,oga54,oga57,oga65,oga99,", #No.7993   #FUN-7B0091 add oga65  #FUN-AC0055 add oga57
               "  oga901,oga902,",
               "  oga903,oga904,oga905,oga906,",
               "  oga907,oga908,oga909,oga1001,",    #NO.FUN-620024
               "  oga1002,oga1003,oga1004,oga1005,", #NO.FUN-620024
               "  oga1006,oga1007,oga1008,oga1009,", #NO.FUN-620024
               "  oga1010,oga1011,oga1012,oga1013,", #NO.FUN-620024
               "  oga1014,oga1015,ogaconf,oga55,",   #NO.FUN-620024 #MOD-C40162 add oga55
               "  ogapost,ogaprsw,ogauser,ogagrup,",
               "  ogamodu,ogadate, ",
               "  ogaplant,ogalegal , ",
               "  ogaud01,ogaud02,ogaud03,ogaud04,ogaud05,",
               "  ogaud06,ogaud07,ogaud08,ogaud09,ogaud10,",
               "  ogaud11,ogaud12,ogaud13,ogaud14,ogaud15,ogaoriu,ogaorig)",  #FUN-A10036
               " VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                        "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                        "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                        "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                        "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                        "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,",   #No.CHI-950020
                        "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",   #NO.FUN-620024
                        "?,?,?,?, ?,?,?,? ) "   #FUN-7B0091 add ?  #FUN-980010 #FUN-A10036 #MOD-C40162 add ?
 	       CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
           CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
           PREPARE ins_t_oga FROM l_sql2
           EXECUTE ins_t_oga USING 
                 x_oga.oga00,x_oga.oga01,x_oga.oga011,x_oga.oga02, 
                 x_oga.oga021,x_oga.oga022,x_oga.oga03,x_oga.oga032,
                 x_oga.oga033,x_oga.oga04,x_oga.oga044,x_oga.oga05,
                 x_oga.oga06,x_oga.oga07,x_oga.oga08,x_oga.oga09,
                 x_oga.oga10,x_oga.oga11,x_oga.oga12,x_oga.oga13,
                 x_oga.oga14,x_oga.oga15,x_oga.oga16,x_oga.oga161,
                 x_oga.oga162,x_oga.oga163,x_oga.oga17,x_oga.oga18,
                 x_oga.oga19,x_oga.oga20,x_oga.oga21,x_oga.oga211,
                 x_oga.oga212,x_oga.oga213,x_oga.oga23,x_oga.oga24,
                 x_oga.oga25,x_oga.oga26,x_oga.oga27,x_oga.oga28,
                 x_oga.oga29,x_oga.oga30,x_oga.oga31,x_oga.oga32,
                 x_oga.oga33,x_oga.oga34,x_oga.oga35,
                 x_oga.oga36,x_oga.oga37,x_oga.oga38,x_oga.oga39,
                 x_oga.oga40,x_oga.oga41,x_oga.oga42,x_oga.oga43,
                 x_oga.oga44,x_oga.oga45,x_oga.oga46,x_oga.oga47,
                 x_oga.oga48,x_oga.oga49,x_oga.oga50,x_oga.oga52,
                 x_oga.oga53,x_oga.oga54,x_oga.oga57,x_oga.oga65,x_oga.oga99, #No.7993   #FUN-7B0091 add oga65   #FUN-AC0055 add x_oga.oga57
                 x_oga.oga901,x_oga.oga902,
                 x_oga.oga903,x_oga.oga904,x_oga.oga905,x_oga.oga906,
                 x_oga.oga907,x_oga.oga908,x_oga.oga909,x_oga.oga1001,    #NO.FUN-620024
                 x_oga.oga1002,x_oga.oga1003,x_oga.oga1004,x_oga.oga1005, #NO.FUN-620024
                 x_oga.oga1006,x_oga.oga1007,x_oga.oga1008,x_oga.oga1009, #NO.FUN-620024
                 x_oga.oga1010,x_oga.oga1011,x_oga.oga1012,x_oga.oga1013, #NO.FUN-620024
                 x_oga.oga1014,x_oga.oga1015,x_oga.ogaconf,x_oga.oga55,   #NO.FUN-620024 #MOD-C40162 add x_oga.oga55
                 x_oga.ogapost,x_oga.ogaprsw,x_oga.ogauser,x_oga.ogagrup,
                 x_oga.ogamodu,x_oga.ogadate,
                 gp_plant,gp_legal   #FUN-980010
                ,x_oga.ogaud01,x_oga.ogaud02,x_oga.ogaud03,
                 x_oga.ogaud04,x_oga.ogaud05,x_oga.ogaud06,
                 x_oga.ogaud07,x_oga.ogaud08,x_oga.ogaud09,
                 x_oga.ogaud10,x_oga.ogaud11,x_oga.ogaud12,
                 x_oga.ogaud13,x_oga.ogaud14,x_oga.ogaud15,g_user,g_grup #FUN-A10036

              IF SQLCA.sqlcode<>0 THEN
               CALL cl_err('ins oga:',SQLCA.sqlcode,1)
               LET g_success = 'N'
              END IF
END FUNCTION
 
#no.4495 insert 出貨通知單身
FUNCTION p820_t_ogbins(p_i)
  DEFINE l_sql  LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1200)   
  DEFINE l_sql1 LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(600)   
  DEFINE l_sql2 LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1600) 
  DEFINE l_sql3 LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(400) 
  DEFINE l_sql5 LIKE type_file.chr1000 #NO.FUN-620024  #No.FUN-680137 VARCHAR(700) #CHI-940042 mark
  DEFINE p_i    LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE l_no   LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE l_price LIKE ogb_file.ogb13
  DEFINE i,l_i   LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE l_msg   LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(80)
  DEFINE l_chr   LIKE type_file.chr1,   #No.FUN-680137 VARCHAR(1)
         l_currm LIKE pmm_file.pmm42,   #依計價幣別抓來源廠的匯率
         x_currm LIKE pmm_file.pmm42,
         l_curr  LIKE pmm_file.pmm22    #No.FUN-680137 VARCHAR(04)
  DEFINE l_ima02 LIKE ima_file.ima02
  DEFINE l_ima25 LIKE ima_file.ima25
 # DEFINE l_imaqty LIKE ima_file.ima262 #FUN-A20044
  DEFINE l_imaqty LIKE type_file.num15_3 #FUN-A20044
  DEFINE l_ima86 LIKE ima_file.ima86
  DEFINE l_ima39 LIKE ima_file.ima39
  DEFINE l_ima35 LIKE ima_file.ima35
  DEFINE l_ima36 LIKE ima_file.ima36
  DEFINE l_ogbi  RECORD LIKE ogbi_file.* #No.FUN-7B0018 
# DEFINE l_oia07  LIKE oia_file.oia07    #FUN-C50136 add
  DEFINE x_oga14  LIKE oga_file.oga14  #FUN-CB0087
  DEFINE x_oga15  LIKE oga_file.oga15  #FUN-CB0087
   
     #讀取訂單單身檔(oeb_file)
     #LET l_sql1 = "SELECT ",l_dbs_tra CLIPPED,"oeb_file.* ",#MOD-770131 add  #FUN-980092 add
     #             " FROM ",l_dbs_tra CLIPPED,"oeb_file, ",  #MOD-770131 add, #FUN-980092 add
     #                      l_dbs_tra CLIPPED,"oea_file  ",  #MOD-770131 add  #FUN-980092 add
     LET l_sql1 = "SELECT ",cl_get_target_table(l_plant_new,'oeb_file.*'),  #FUN-A50102
                   " FROM ",cl_get_target_table(l_plant_new,'oeb_file'),",", #FUN-A50102
                            cl_get_target_table(l_plant_new,'oea_file'),     #FUN-A50102
                  " WHERE oea99='",g_oea.oea99,"'",         #MOD-770131 add
                  "  AND oeb01 = oea01",                    #MOD-770131 add
                  "  AND oeb03 =",g_ogb.ogb32
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
         CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-980092
     PREPARE toeb_p1 FROM l_sql1
     IF SQLCA.SQLCODE THEN CALL cl_err('oeb_p1',SQLCA.SQLCODE,1) END IF
     DECLARE toeb_c1 CURSOR FOR toeb_p1                     #MOD-770131 modify
     OPEN toeb_c1
     FETCH toeb_c1 INTO l_oeb.*
     IF SQLCA.SQLCODE <> 0 THEN
        LET g_success='N'
        RETURN
     END IF
     CLOSE toeb_c1
 
     #新增出貨單身檔[ogb_file]
     LET x_ogb.ogb01 = x_oga.oga01      #出貨單號 No.7993
     LET x_ogb.ogb03 = t_ogb.ogb03      #項次
     LET x_ogb.ogb04 = t_ogb.ogb04      #產品編號
     LET x_ogb.ogb05 = l_oeb.oeb05      #銷售單位
     LET x_ogb.ogb05_fac= l_oeb.oeb05_fac  #換算率
     LET x_ogb.ogb06 = l_oeb.oeb06      #品名規格
     LET x_ogb.ogb07 = l_oeb.oeb07      #額外品名編號
     LET x_ogb.ogb08 = l_oeb.oeb08      #出貨工廠
     CALL p820_ima(x_ogb.ogb04,l_plant_new)  #FUN-980092 add
        RETURNING l_ima02,l_ima25,l_imaqty,l_ima86,l_ima39,l_ima35,l_ima36
     IF cl_null(l_ima35) THEN LET l_ima35=' ' END IF
     IF cl_null(l_ima36) THEN LET l_ima36=' ' END IF
 
    IF NOT cl_null(p_imd01) THEN
       CALL p820_imd(p_imd01,l_plant_new)#FUN-980092 add
       LET x_ogb.ogb09 = p_imd01          #出貨倉庫
       LET x_ogb.ogb091= ' '              #出貨儲位
       LET x_ogb.ogb092= ' '              #出貨批號
    ELSE
       IF NOT cl_null(l_ima35) THEN
          LET x_ogb.ogb09 = l_ima35          #出貨倉庫
          LET x_ogb.ogb091= l_ima36          #出貨儲位
          LET x_ogb.ogb092= ' '              #出貨批號
       ELSE
          LET x_ogb.ogb09 = l_oeb.oeb09
          LET x_ogb.ogb091= l_oeb.oeb091
          LET x_ogb.ogb092= l_oeb.oeb092
       END IF
    END IF
 
     LET x_ogb.ogb11 = l_oeb.oeb11      #客戶產品編號
     LET x_ogb.ogb12 = t_ogb.ogb12      #實際出貨數量
     IF g_oax.oax03 = 'N' OR s_aza.aza50 = 'Y' THEN  #NO.FUN-620024   #NO.FUN-670007
        LET x_ogb.ogb13 = l_oeb.oeb13      #原幣單價
     ELSE
        #出貨必須重新計算價格, 因為分批出貨時, 有可能計價方式亦改變了
        #依計價方式來判斷價格
              CASE p_pox05
                 WHEN '1'
                    IF p_pox03='1' THEN   #依來源工廠 
                       #單價*比率
                       #modi 00/01/23 (換算匯率) NO:1218
                       IF g_oea.oea23 = x_oga.oga23 THEN
                          LET x_ogb.ogb13 = t_ogb.ogb13 * p_pox06 /100
                       END IF
                       IF g_oea.oea23 <> x_oga.oga23 THEN  
                          LET l_price = t_ogb.ogb13 * g_oga.oga24 #先換算本幣
                          #依計價幣別抓來源工廠的匯率  no:3463
                          CALL s_currm(x_oga.oga23,x_oga.oga02,
                                        g_oax.oax01,t_dbs)   #NO.FUN-670007
                               RETURNING l_currm
                          LET x_ogb.ogb13= l_price/l_currm * p_pox06/100  
                       END IF
                    ELSE
                       #依上游廠商計算, 先讀取S/O價格
                       IF p_i=1 THEN
                         #單價*比率
                         #modi 00/01/23 (換算匯率) NO:1218
                         IF g_oea.oea23 = x_oga.oga23 THEN
                            LET x_ogb.ogb13 = t_ogb.ogb13 * p_pox06 /100
                         END IF
                         IF g_oea.oea23 <> x_oga.oga23 THEN  
                            LET l_price = t_ogb.ogb13 * g_oga.oga24 #先換算本幣
                            #依計價幣別抓來源工廠的匯率 no:3463
                            CALL s_currm(x_oga.oga23,x_oga.oga02,
                                          g_oax.oax01,t_plant)  #FUN-980020
                                 RETURNING l_currm
                            LET x_ogb.ogb13= l_price/l_currm * p_pox06/100  
                         END IF
                       ELSE
                          LET l_no = p_i-1
                          SELECT pab_price,pab_curr INTO l_price,l_curr
                            FROM p820_file
                           WHERE p_no = l_no
                             AND pab_no = x_ogb.ogb01
                             AND pab_item=t_ogb.ogb03
                             AND pab_type='1'
                         #modi 00/01/23 (換算匯率) NO:1218
                          IF l_curr != x_oga.oga23 THEN
                             CALL s_currm(l_curr,x_oga.oga02,
                                          g_oax.oax01,t_plant)  #FUN-980020
                              RETURNING x_currm
                             LET l_price = l_price * x_currm   #換算成本幣
                             #依計價幣別抓來源廠的匯率 no:3463
                             CALL s_currm(x_oga.oga23,x_oga.oga02,
                                          g_oax.oax01,t_plant)  #FUN-980020
                              RETURNING l_currm
                             LET x_ogb.ogb13 = l_price / l_currm * p_pox06/100
                          ELSE
                             #單價*比率
                             LET x_ogb.ogb13= l_price * p_pox06/100
                          END IF
                        END IF  
                    END IF
                    CALL cl_digcut(x_ogb.ogb13,l_azi.azi03) 
                          RETURNING x_ogb.ogb13
                 WHEN '2'
                    #讀取合乎料件條件之價格
                    CALL s_pow(g_oea.oea904,x_ogb.ogb04,p_poy04,g_oga.oga02)
                           RETURNING g_sw,x_ogb.ogb13
                     IF g_sw='N' THEN
                       CALL cl_err('sel pow:','axm-333',1)
                       LET g_success = 'N'
                     END IF
                 WHEN '3'   #單價若為0, 則給0, 否則抓料件之固定價格
                     IF t_ogb.ogb13 <> 0 THEN
                        CALL s_pow(g_oea.oea904,x_ogb.ogb04,p_poy04,g_oga.oga02)
                           RETURNING g_sw,x_ogb.ogb13
                        IF g_sw='N' THEN
                          CALL cl_err('sel pow:','axm-333',1)
                          LET g_success = 'N'
                        END IF
                     ELSE
                        LET x_ogb.ogb13 = 0
                     END IF
              END CASE
              IF x_ogb.ogb13 IS NULL THEN LET x_ogb.ogb13 =0 END IF
     END IF
 
            LET INT_FLAG = 0  ######add for prompt bug
     #未稅金額/含稅金額 : oeb14/oeb14t
     IF x_oga.oga213 = 'N' THEN
        LET x_ogb.ogb14=x_ogb.ogb917*x_ogb.ogb13  #No.TQC-6A0084
        LET x_ogb.ogb14t=x_ogb.ogb14*(1+x_oga.oga211/100)
     ELSE 
        LET x_ogb.ogb14t=x_ogb.ogb917*x_ogb.ogb13  #No.TQC-6A0084
        LET x_ogb.ogb14=x_ogb.ogb14t/(1+x_oga.oga211/100)
     END IF
     LET x_ogb.ogb15 = l_oeb.oeb05
      LET x_ogb.ogb15_fac = l_oeb.oeb05_fac #MOD-4B0148
     LET x_ogb.ogb16 = x_ogb.ogb12
     LET x_ogb.ogb17 = 'N'
     LET x_ogb.ogb18 = x_ogb.ogb12
     LET x_ogb.ogb19 = g_ogb.ogb19  #NO.FUN-620024
     LET x_ogb.ogb20 =' '
     LET x_ogb.ogb31 = l_oeb.oeb01
     LET x_ogb.ogb32 = l_oeb.oeb03
     LET x_ogb.ogb60 =0
     LET x_ogb.ogb63 =0
     LET x_ogb.ogb64 =0
     CALL cl_digcut(x_ogb.ogb14,l_azi.azi04) RETURNING x_ogb.ogb14
     CALL cl_digcut(x_ogb.ogb14t,l_azi.azi04)RETURNING x_ogb.ogb14t
     LET x_ogb.ogb1014='N' #保稅放行否 #FUN-6B0044
  
     LET x_ogb.ogb1001 = ''           #TQC-D20067 add
     IF s_aza.aza50 = 'Y' THEN  
        #LET x_ogb.ogb1001 = l_oeb.oeb1001  #原因碼  #CHI-960012  #TQC-D40064 mark
        LET x_ogb.ogb1002 = l_oeb.oeb1002   #訂價編號
        LET x_ogb.ogb1003 = l_oeb.oeb15     #預計出貨日期
        LET x_ogb.ogb1004 = l_oeb.oeb1004   #提案編號
        LET x_ogb.ogb1005 = l_oeb.oeb1003   #作業方式
        LET x_ogb.ogb1007 = ''              #現金折扣單號
        LET x_ogb.ogb1008 = ''              #稅種
        LET x_ogb.ogb1009 = ''              #稅率
        LET x_ogb.ogb1010 = ''              #含稅否
        LET x_ogb.ogb1011 = ''              #非直營KAB
        LET x_ogb.ogb1006 = l_oeb.oeb1006   #折扣率                              
        LET x_ogb.ogb1012 = l_oeb.oeb1012   #搭贈
     END IF
     LET x_ogb.ogb1001 = l_oeb.oeb1001      #原因碼                         #TQC-D40064 add
     IF cl_null(x_ogb.ogb1001) THEN LET x_ogb.ogb1001 = g_poy.poy28 END IF  #TQC-D40064 add
     IF x_ogb.ogb1012 = 'Y' THEN                                                  
        LET x_ogb.ogb14 =0                                                        
        LET x_ogb.ogb14t=0                                                        
     END IF
     LET x_ogb.ogbud01 = t_ogb.ogbud01
     LET x_ogb.ogbud02 = t_ogb.ogbud02
     LET x_ogb.ogbud03 = t_ogb.ogbud03
     LET x_ogb.ogbud04 = t_ogb.ogbud04
     LET x_ogb.ogbud05 = t_ogb.ogbud05
     LET x_ogb.ogbud06 = t_ogb.ogbud06
     LET x_ogb.ogbud07 = t_ogb.ogbud07
     LET x_ogb.ogbud08 = t_ogb.ogbud08
     LET x_ogb.ogbud09 = t_ogb.ogbud09
     LET x_ogb.ogbud10 = t_ogb.ogbud10
     LET x_ogb.ogbud11 = t_ogb.ogbud11
     LET x_ogb.ogbud12 = t_ogb.ogbud12
     LET x_ogb.ogbud13 = t_ogb.ogbud13
     LET x_ogb.ogbud14 = t_ogb.ogbud14
     LET x_ogb.ogbud15 = t_ogb.ogbud15
 #FUN-AB0061 -----------add start----------------                             
     IF cl_null(x_ogb.ogb37) OR x_ogb.ogb37=0 THEN           
        LET x_ogb.ogb37=x_ogb.ogb13                         
     END IF                                                                             
#FUN-AB0061 -----------add end----------------   
#FUN-AC0055 mark ---------------------begin-----------------------
##FUN-AB0096 -----------add start----------------
#     IF cl_null(x_ogb.ogb50) THEN
#         LET x_ogb.ogb50 = '1'
#     END IF
##FUN-AB0096 -----------add end--------------------------  
#FUN-AC0055 mark ----------------------end------------------------
     #FUN-C50097 ADD BEGIN-----
     IF cl_null(x_ogb.ogb50) THEN 
       LET x_ogb.ogb50 = 0
     END IF 
     IF cl_null(x_ogb.ogb51) THEN 
       LET x_ogb.ogb51 = 0
     END IF 
     IF cl_null(x_ogb.ogb52) THEN 
       LET x_ogb.ogb52 = 0
     END IF  
     IF cl_null(x_ogb.ogb53) THEN 
       LET x_ogb.ogb53 = 0
     END IF 
     IF cl_null(x_ogb.ogb54) THEN 
       LET x_ogb.ogb54 = 0
     END IF 
     IF cl_null(x_ogb.ogb55) THEN 
       LET x_ogb.ogb55 = 0
     END IF                                         
     #FUN-C50097 ADD END------- 
     #TQC-D20047--add--str--
     LET l_sql2 = "SELECT aza115 FROM ",cl_get_target_table(l_plant_new,'aza_file')," WHERE aza01 = '0' "
     PREPARE aza115_pr3 FROM l_sql2
     EXECUTE aza115_pr3 INTO g_aza.aza115   
     #TQC-D20047--add--end--
     #FUN-CB0087--add--str--
     #IF g_aza.aza115='Y' THEN                            #TQC-D40064 mark
     IF g_aza.aza115='Y' AND cl_null(x_ogb.ogb1001) THEN  #TQC-D40064 add
       #SELECT oga14,oga15 INTO x_oga14,x_oga15 FROM oga_file WHERE oga01 = x_ogb.ogb01
        #TQC-D20042--add--str--
        LET l_sql2= "SELECT oga14,oga15 FROM ",cl_get_target_table(l_plant_new,'oga_file')," WHERE oga01 = '",x_ogb.ogb01,"'"
        PREPARE ogb1001_pr1 FROM l_sql2
        EXECUTE ogb1001_pr1 INTO x_oga14,x_oga15
        #TQC-D20042--add--end--
       #CALL s_reason_code(x_ogb.ogb01,x_ogb.ogb31,'',x_ogb.ogb04,x_ogb.ogb09,x_oga14,x_oga15) RETURNING x_ogb.ogb1001  #TQC-D20042 mark
        CALL s_reason_code1(x_ogb.ogb01,x_ogb.ogb31,'',x_ogb.ogb04,x_ogb.ogb09,x_oga14,x_oga15,l_plant_new) RETURNING x_ogb.ogb1001  #TQC-D20042
        IF cl_null(x_ogb.ogb1001) THEN
           #CALL cl_err(x_ogb.ogb1001,'aim-425',1)  #TQC-D20047
           LET g_showmsg = l_plant_new,"/",x_ogb.ogb01                  #TQC-D20047       
           CALL s_errmsg('oga01',g_showmsg,'up ogb1001:','aim-425',1)   #TQC-D20047
           LET g_success="N"
           RETURN
        END IF
     END IF
     #FUN-CB0087--add--end--
     #新增出貨單身檔
     #LET l_sql2="INSERT INTO ",l_dbs_tra CLIPPED,"ogb_file",  #FUN-980092 add
     LET l_sql2="INSERT INTO ",cl_get_target_table(l_plant_new,'ogb_file'), #FUN-A50102
      "(ogb01,ogb03,ogb04,ogb05, ",
      " ogb05_fac,ogb06,ogb07,ogb08, ",
      " ogb09,ogb091,ogb092,ogb11, ",
      " ogb12,ogb37,ogb13,ogb14,ogb14t,",#FUN-AB0061 
      " ogb15,ogb15_fac,ogb16,ogb17, ",
      " ogb18,ogb19,ogb20,ogb31,",
      " ogb32,ogb60,ogb63,ogb64,",
      " ogb901,ogb902,ogb903,ogb904,",
      " ogb905,ogb906,ogb907,ogb908,",
      " ogb909,ogb910,ogb911,ogb912,",   #FUN-560043
      " ogb913,ogb914,ogb915,ogb916,",   #FUN-560043
      " ogb917,ogb1001,ogb1002,ogb1003,",   #NO.FUN-620024
      " ogb1004,ogb1005,ogb1007,ogb1008,",  #NO.FUN-620024 
      " ogb1009,ogb1010,ogb1011,ogb1006,ogb1012,ogb1014, ", #NO.FUN-620024 #FUN-6B0044
      " ogbplant,ogblegal , ",
      " ogbud01,ogbud02,ogbud03,ogbud04,ogbud05,",
      " ogbud06,ogbud07,ogbud08,ogbud09,ogbud10,",
      " ogbud11,ogbud12,ogbud13,ogbud14,ogbud15,ogb50,ogb51,ogb52,ogb53,ogb54,ogb55)",    #FUN-AB0096 add #ogb50 FUN-C50097 ADD 50,51,52
      " VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
      "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
      "         ?,?,?,?, ?,?,?,?, ?,?,?,?,",    #NO.FUN-620024
      "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,", #No.CHI-950020
      "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?, ?,?,?, ?,?,?, ?,?,?) "  #FUN-560043 #FUN-6B0044 #FUN-980010#FUN-AB0061 #FUN-AB0096 add? #FUN-C50097 ADD 50,51,52 
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
     PREPARE ins_t_ogb FROM l_sql2
     EXECUTE ins_t_ogb USING 
       x_ogb.ogb01,x_ogb.ogb03,x_ogb.ogb04,x_ogb.ogb05, 
       x_ogb.ogb05_fac,x_ogb.ogb06,x_ogb.ogb07,x_ogb.ogb08, 
       x_ogb.ogb09,x_ogb.ogb091,x_ogb.ogb092,x_ogb.ogb11, 
       x_ogb.ogb12,x_ogb.ogb37,x_ogb.ogb13,x_ogb.ogb14,x_ogb.ogb14t,#FUN-AB0061 
       x_ogb.ogb15,x_ogb.ogb15_fac,x_ogb.ogb16,x_ogb.ogb17, 
       x_ogb.ogb18,x_ogb.ogb19,x_ogb.ogb20,x_ogb.ogb31,
       x_ogb.ogb32,x_ogb.ogb60,x_ogb.ogb63,x_ogb.ogb64,
       x_ogb.ogb901,x_ogb.ogb902,x_ogb.ogb903,x_ogb.ogb904,
       x_ogb.ogb905,x_ogb.ogb906,x_ogb.ogb907,x_ogb.ogb908,
       x_ogb.ogb909,x_ogb.ogb910,x_ogb.ogb911,x_ogb.ogb912,   #FUN-560043
       x_ogb.ogb913,x_ogb.ogb914,x_ogb.ogb915,x_ogb.ogb916,   #FUN-560043
       x_ogb.ogb917,x_ogb.ogb1001,x_ogb.ogb1002,x_ogb.ogb1003,   #NO.FUN-620024
       x_ogb.ogb1004,x_ogb.ogb1005,x_ogb.ogb1007,x_ogb.ogb1008,  #NO.FUN-620024
       x_ogb.ogb1009,x_ogb.ogb1010,x_ogb.ogb1011,x_ogb.ogb1006,x_ogb.ogb1012,x_ogb.ogb1014,  #NO.FUN-620024 #FUN-6B0044
       gp_plant,gp_legal   #FUN-980010
      ,x_ogb.ogbud01,x_ogb.ogbud02,x_ogb.ogbud03,
       x_ogb.ogbud04,x_ogb.ogbud05,x_ogb.ogbud06,
       x_ogb.ogbud07,x_ogb.ogbud08,x_ogb.ogbud09,
       x_ogb.ogbud10,x_ogb.ogbud11,x_ogb.ogbud12,
       x_ogb.ogbud13,x_ogb.ogbud14,x_ogb.ogbud15,
       x_ogb.ogb50,x_ogb.ogb51,x_ogb.ogb52,x_ogb.ogb53,x_ogb.ogb54,x_ogb.ogb55        #FUN-AB0096 add ogb50 #FUN-C50097 ADD 50,51,52
       IF SQLCA.sqlcode<>0 THEN
          CALL cl_err('ins ogb:',SQLCA.sqlcode,1)
          LET g_success = 'N'
       ELSE
          IF NOT s_industry('std') THEN
             INITIALIZE l_ogbi.* TO NULL
             LET l_ogbi.ogbi01 = x_ogb.ogb01
             LET l_ogbi.ogbi03 = x_ogb.ogb03
             IF NOT s_ins_ogbi(l_ogbi.*,l_plant_new) THEN #FUN-980092 add
                LET g_success = 'N'
             END IF
          END IF
#         #FUN-C50136----add----str----
#         IF g_oaz.oaz96 ='Y' THEN
#            CALL s_ccc_oia07('D',x_oga.oga03) RETURNING l_oia07
#            IF l_oia07 = '0' THEN
#               CALL s_ccc_oia(x_oga.oga03,'D',x_oga.oga01,0,l_plant_new)
#            END IF
#         END IF
#         #FUN-C50136----add----end----
       END IF
     #新增至暫存檔中
     INSERT INTO p820_file VALUES(p_i,x_ogb.ogb01,t_ogb.ogb03,
                                         x_ogb.ogb13,x_oga.oga23,'1')
     IF SQLCA.sqlcode<>0 THEN
        CALL cl_err3("ins","p820_file","","",SQLCA.sqlcode,"","ins p820_file",1)   #No.FUN-660167
        LET g_success = 'N'
     END IF
 
     IF s_aza.aza50 = 'Y' THEN     #使用分銷功能
     #單頭之含稅出貨總金額                                                            
        LET x_oga.oga1008 = x_oga.oga1008 + x_ogb.ogb14t   #原幣出貨金額(含稅)           
        #LET l_sql5="UPDATE ",l_dbs_tra CLIPPED,"oga_file",    #FUN-980092 add 
        LET l_sql5="UPDATE ",cl_get_target_table(l_plant_new,'oga_file'), #FUN-A50102        
                   "   SET oga1008 = ? ",                                            
                   " WHERE oga01 = ? "                                             
 	    CALL cl_replace_sqldb(l_sql5) RETURNING l_sql5        #FUN-920032
        CALL cl_parse_qry_sql(l_sql5,l_plant_new) RETURNING l_sql5 #FUN-980092
        PREPARE upd_oga1008a FROM l_sql5
        EXECUTE upd_oga1008a USING x_oga.oga1008,x_oga.oga01                            
        IF SQLCA.sqlcode<>0 THEN                                                   
           CALL cl_err('upd oga:',SQLCA.sqlcode,1)                                 
           LET g_success = 'N'                                                     
        END IF
     END IF
 
     #單頭之出貨金額
     LET x_oga.oga50 =x_oga.oga50 + x_ogb.ogb14   #原幣出貨金額(未稅)
     LET x_oga.oga51 =x_oga.oga51 + x_ogb.ogb14t  #原幣出貨金額(含稅)
     LET x_oga.oga52 = x_oga.oga50 * x_oga.oga161/100
     LET x_oga.oga53 = x_oga.oga50 * (x_oga.oga162+x_oga.oga163)/100
 
     #LET l_sql3="UPDATE ",l_dbs_tra CLIPPED,"oga_file",  #FUN-980092 add
     LET l_sql3="UPDATE ",cl_get_target_table(l_plant_new,'oga_file'), #FUN-A50102  
                "   SET oga50 = ?, ",
                "       oga51 = ?, ",
                "       oga52 = ?, ",
                "       oga53 = ? ",
                " WHERE oga01 = ? "
 	 CALL cl_replace_sqldb(l_sql3) RETURNING l_sql3        #FUN-920032
     CALL cl_parse_qry_sql(l_sql3,l_plant_new) RETURNING l_sql3 #FUN-980092
     PREPARE upd_t_oga50 FROM l_sql3
     EXECUTE upd_t_oga50 USING x_oga.oga50,x_oga.oga51,x_oga.oga52,
                             x_oga.oga53,x_oga.oga01
     IF SQLCA.sqlcode<>0 THEN
        CALL cl_err('upd oga:',SQLCA.sqlcode,1)
        LET g_success = 'N'
     END IF
END FUNCTION
 
#INSERT s_dbs_new 收貨單頭
FUNCTION p820_rvains()
 #DEFINE l_sql   LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1200)   #CHI-940042 mark
 #DEFINE l_sql1  LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(600)    #CHI-940042 mark
  DEFINE l_sql,l_sql1 STRING            #CHI-940042        
  DEFINE i,l_i   LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE li_result LIKE type_file.num5  #TQC-9B0013
 
  #讀取該流程代碼之採購單資料
     LET l_sql1 = "SELECT * ",
                  #" FROM ",s_dbs_tra CLIPPED,"pmm_file ",   #FUN-980092 add
                  " FROM ",cl_get_target_table(s_plant_new,'pmm_file'), #FUN-A50102  
                  " WHERE pmm99='",g_oea.oea99,"' AND pmm18 <> 'X'"  #NO.FUN-620024
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,s_plant_new) RETURNING l_sql1 #FUN-980092
     PREPARE pmm_p1 FROM l_sql1
     IF SQLCA.SQLCODE THEN 
        CALL s_errmsg('','','pmm_p1',SQLCA.SQLCODE,0) #No.FUN-710046
     END IF
     DECLARE pmm_c1 CURSOR FOR pmm_p1
     OPEN pmm_c1
     FETCH pmm_c1 INTO g_pmm.*
     IF SQLCA.SQLCODE <> 0 THEN
        CALL s_errmsg('','','pmm_p1',SQLCA.SQLCODE,0) #No.TQC-930155---add---
        LET g_success='N'
        RETURN
     END IF
     CLOSE pmm_c1
  #新增驗收單單頭檔(rva_file)
        CALL s_auto_assign_no("apm",rva_t1,g_oga.oga02,"","rva_file","rva01",s_plant_new,"","") #NO.FUN-620024 #FUN-980092 add
        RETURNING li_result,l_rva.rva01
        IF (NOT li_result) THEN 
           LET g_msg = s_plant_new CLIPPED,l_rva.rva01
           CALL s_errmsg("rva01",l_rva.rva01,g_msg CLIPPED,"mfg3046",1) 
           LET g_success ='N'
           RETURN
        END IF   
    IF cl_null(g_oga.oga16) THEN
       LET l_rva.rva02 = g_oga.oga16
    ELSE 
       LET l_rva.rva02 = g_pmm.pmm01                    #NO.FUN-620024
    END IF
    LET l_rva.rva04 = 'N'                #是否為 L/C 收料
    LET l_rva.rva05 = g_pmm.pmm09        #供應廠商
    LET l_rva.rva06 = g_oga.oga02        #收貨日期
    LET l_rva.rva10 = g_pmm.pmm02        #採購類別
    LET l_rva.rvaprsw='Y'                #是否需列印驗收單 
    LET l_rva.rva21 = NULL
    LET l_rva.rva23 = NULL
    LET l_rva.rva99 = g_flow99           #No.7993
    LET l_rva.rvaconf= 'Y'
    LET l_rva.rvaacti= 'Y'
    LET l_rva.rvaprno= 0
    LET l_rva.rvauser= g_user
    LET l_rva.rvagrup= g_grup
    LET l_rva.rvamodu= null
    LET l_rva.rvadate= null
    LET l_rva.rva00 = '1'                #FUN-940083
    LET l_rva.rvaud01= g_oga.ogaud01
    LET l_rva.rvaud02= g_oga.ogaud02
    LET l_rva.rvaud03= g_oga.ogaud03
    LET l_rva.rvaud04= g_oga.ogaud04
    LET l_rva.rvaud05= g_oga.ogaud05
    LET l_rva.rvaud06= g_oga.ogaud06
    LET l_rva.rvaud07= g_oga.ogaud07
    LET l_rva.rvaud08= g_oga.ogaud08
    LET l_rva.rvaud09= g_oga.ogaud09
    LET l_rva.rvaud10= g_oga.ogaud10
    LET l_rva.rvaud11= g_oga.ogaud11
    LET l_rva.rvaud12= g_oga.ogaud12
    LET l_rva.rvaud13= g_oga.ogaud13
    LET l_rva.rvaud14= g_oga.ogaud14
    LET l_rva.rvaud15= g_oga.ogaud15
    #新增收貨單頭
     #LET l_sql="INSERT INTO ",s_dbs_tra CLIPPED,"rva_file",  #FUN-980092 add
     LET l_sql="INSERT INTO ",cl_get_target_table(s_plant_new,'rva_file'), #FUN-A50102
      "(rva01  ,rva02  ,rva03  ,rva04  ,rva05  ,",
      " rva06  ,rva07  ,rva08  ,rva09  ,rva10  ,",
      " rvaprsw,rva20  ,rva21  ,rva22  ,rva23  ,",
      " rva24  ,rva25  ,rva26  ,rva27  ,rva28  ,",
      " rvaconf,rvaprno,rvaacti,rvauser,rvagrup,",
      " rvamodu,rvadate,rva99,rva00, ",                 #No.7993 #FUN-940083 add rva00
      " rvaplant,rvalegal ,  ",
      " rvaud01,rvaud02,rvaud03,rvaud04,rvaud05,",
      " rvaud06,rvaud07,rvaud08,rvaud09,rvaud10,",
      " rvaud11,rvaud12,rvaud13,rvaud14,rvaud15,rvaoriu,rvaorig)", #FUN-A10036
      " VALUES( ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,",
      "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,",     #No.CHI-950020
      "         ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,  ?,?,?,?)"   #FUN-A10036      #No7993 #FUN-940083  #FUN-980010
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,s_plant_new) RETURNING l_sql #FUN-A50102
     PREPARE ins_rva FROM l_sql
     EXECUTE ins_rva USING 
        l_rva.rva01, l_rva.rva02 ,l_rva.rva03,l_rva.rva04,l_rva.rva05,
        l_rva.rva06, l_rva.rva07 ,l_rva.rva08,l_rva.rva09,l_rva.rva10,
        l_rva.rvaprsw,l_rva.rva20,l_rva.rva21,l_rva.rva22,l_rva.rva23,
        l_rva.rva24, l_rva.rva25 ,l_rva.rva26,l_rva.rva27,l_rva.rva28,
        l_rva.rvaconf,l_rva.rvaprno,l_rva.rvaacti,l_rva.rvauser,l_rva.rvagrup,
        l_rva.rvamodu,l_rva.rvadate,l_rva.rva99,l_rva.rva00,    #No.7993 #FUN-940083 add rva00
        sp_plant,sp_legal   #FUN-980010
       ,l_rva.rvaud01,l_rva.rvaud02,l_rva.rvaud03,
        l_rva.rvaud04,l_rva.rvaud05,l_rva.rvaud06,
        l_rva.rvaud07,l_rva.rvaud08,l_rva.rvaud09,
        l_rva.rvaud10,l_rva.rvaud11,l_rva.rvaud12,
        l_rva.rvaud13,l_rva.rvaud14,l_rva.rvaud15,g_user,g_grup #FUN-A10036
     IF SQLCA.sqlcode<>0 THEN
        CALL s_errmsg('rva01',l_rva.rva01,'ins rva:',SQLCA.sqlcode,1)  #No.FUN-710046
        LET g_success = 'N'
     END IF
END FUNCTION
 
#收貨單身檔
FUNCTION p820_rvbins(p_i)
 #DEFINE l_sql  LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1200)   #CHI-940042 mark
 #DEFINE l_sql1 LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(600)    #CHI-940042 mark
 #DEFINE l_sql2 LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1600)   #CHI-940042 mark
  DEFINE l_sql,l_sql1,l_sql2 STRING    #CHI-940042        
  DEFINE p_i    LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE l_no   LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE l_price LIKE ogb_file.ogb13
  DEFINE i,l_i   LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE l_msg   LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(80)
  DEFINE l_chr   LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
  DEFINE l_ima491 LIKE ima_file.ima491
  DEFINE l_ima02  LIKE ima_file.ima02
  DEFINE l_ima25  LIKE ima_file.ima25
 # DEFINE l_qoh    LIKE ima_file.ima262 #FUN-A20044
  DEFINE l_qoh    LIKE type_file.num15_3 #FUN-A20044
  DEFINE l_ima39  LIKE ima_file.ima39
  DEFINE l_ima86  LIKE ima_file.ima86
  DEFINE l_cmd    LIKE type_file.chr1000, #No.FUN-680137 VARCHAR(100)
         l_currm LIKE pmm_file.pmm42,     #FUN-670007 #依計價幣別抓來源廠的匯率
         x_currm LIKE pmm_file.pmm42,     #FUN-670007
         l_curr  LIKE pmm_file.pmm22      #FUN-670007
  DEFINE l_rvbi  RECORD LIKE rvbi_file.*  #NO.FUN-7B0018
  DEFINE l_flag   SMALLINT     #MOD-810179 add
  DEFINE l_rvbs  RECORD LIKE rvbs_file.*  #No.FUN-850100
  DEFINE l_sma90 LIKE sma_file.sma90  #No.FUN-850100
  DEFINE l_idd   RECORD LIKE idd_file.*            #FUN-B90012
  DEFINE l_flag1        LIKE type_file.num10       #FUN-B90012
  #DEFINE l_imaicd08     LIKE imaicd_file.imaicd08  #FUN-B90012 #FUN-BA0051 mark
  DEFINE l_rvbiicd08    LIKE rvbi_file.rvbiicd08   #FUN-B90012
  DEFINE l_rvbiicd16    LIKE rvbi_file.rvbiicd16   #FUN-B90012
  DEFINE g_ogg   RECORD LIKE ogg_file.*      #CHI-C40031 add
  DEFINE g_ogc   RECORD LIKE ogc_file.*      #CHI-C40031 add
  DEFINE l_cnt          LIKE type_file.num5  #CHI-C40031 add
  DEFINE l_rvb02        LIKE rvb_file.rvb02  #FUN-C80001
   
     #讀取採購單身檔(pmn_file)
     #LET l_sql1 = "SELECT ",s_dbs_tra CLIPPED,"pmn_file.* ",#FUN-980092 add
     #             "  FROM ",s_dbs_tra CLIPPED,"pmn_file,",s_dbs_tra CLIPPED,"pmm_file",#FUN-980092 add
     LET l_sql1 = "SELECT ",cl_get_target_table(s_plant_new,'pmn_file.*'), #FUN-A50102
                  "  FROM ",cl_get_target_table(s_plant_new,'pmn_file'),",", #FUN-A50102
                            cl_get_target_table(s_plant_new,'pmm_file'), #FUN-A50102
                  " WHERE pmn01 = pmm01",
                  "   AND pmm99 ='",g_oea.oea99,"'", 
                  "  AND pmn02 =",g_ogb.ogb32
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,s_plant_new) RETURNING l_sql1 #FUN-980092
     PREPARE pmn_p1 FROM l_sql1
     IF SQLCA.SQLCODE THEN 
        LET g_showmsg = g_oea.oea99,"/",g_ogb.ogb32    #No.FUN-710046
        CALL s_errmsg('pmm99,pmn02',g_showmsg,'pmn_p1',SQLCA.SQLCODE,0)  #No.FUN-710046
     END IF
     DECLARE pmn_c1 CURSOR FOR pmn_p1
     OPEN pmn_c1
     FETCH pmn_c1 INTO g_pmn.*
     IF SQLCA.SQLCODE <> 0 THEN
        LET g_success='N'
        RETURN
     END IF
     CLOSE pmn_c1
     #新增採購單身檔[pmn_file]
     LET l_rvb.rvb01 = l_rva.rva01      #驗收單身檔
     #FUN-C80001---begin
    #IF g_sma.sma96 = 'Y' THEN  #FUN-D30099 mark
     IF g_pod.pod08 = 'Y' THEN  #FUN-D30099 
        SELECT MAX(rvb02) INTO l_rvb02
          FROM rvb_file
         WHERE rvb01 = l_rva.rva01
        IF cl_null(l_rvb02) THEN LET l_rvb02 = 0 END IF 
        LET l_rvb02 = l_rvb02 + 1
        LET l_rvb.rvb02 = l_rvb02
     ELSE  
     #FUN-C80001---end
        LET l_rvb.rvb02 = g_ogb.ogb03      #驗收單項次
     END IF  #FUN-C80001
     LET l_rvb.rvb03 = g_pmn.pmn02      #採購單項次
     LET l_rvb.rvb04 = g_pmn.pmn01      #採購單號
     LET l_rvb.rvb05 = g_ogb.ogb04      #料件編號 No.7742
     LET l_rvb.rvb06 = 0                #已請款量
     LET l_rvb.rvb07 = g_ogb.ogb12      #實收數量
     LET l_rvb.rvb08 = g_ogb.ogb12      #收貨數量
     LET l_rvb.rvb09 = 0                #允請款量
     LET l_rvb.rvb90 = g_pmn.pmn07      #MOD-B30584 add
     LET l_rvb.rvb07 = s_digqty(l_rvb.rvb07,l_rvb.rvb90) #FUN-BB0083 add
     LET l_rvb.rvb08 = s_digqty(l_rvb.rvb08,l_rvb.rvb90) #FUN-BB0083 add
 
     IF l_oga.oga213 = 'N' THEN
        LET l_rvb.rvb10 = l_ogb.ogb13
        LET l_rvb.rvb10t= l_ogb.ogb13*(1+l_oga.oga211/100)
     ELSE 
        LET l_rvb.rvb10t= l_ogb.ogb13
        LET l_rvb.rvb10 = l_ogb.ogb13/(1+l_oga.oga211/100)
     END IF
 
     #No.7742 備品時金額、單價應為零
     IF p820_chkoeo(g_ogb.ogb31,g_ogb.ogb32,g_ogb.ogb04) THEN
        LET l_rvb.rvb10 = 0 
        LET l_rvb.rvb10t= 0 #NO.FUN-620024
     END IF
     LET l_rvb.rvb11 = 0
 
     LET l_cmd = " SELECT ima491",
                 #"   FROM ",s_dbs_new CLIPPED," ima_file ",
                 "   FROM ",cl_get_target_table(s_plant_new,'ima_file'), #FUN-A50102
                 "  WHERE ima01 = '",l_rvb.rvb05,"'"
 	 CALL cl_replace_sqldb(l_cmd) RETURNING l_cmd        #FUN-920032
     CALL cl_parse_qry_sql(l_cmd,s_plant_new) RETURNING l_cmd #FUN-A50102
     PREPARE ima_pre FROM l_cmd
     DECLARE ima_c1  CURSOR FOR ima_pre
     OPEN ima_c1    
     FETCH ima_c1 INTo l_ima491
     CLOSE ima_c1
 
     IF cl_null(l_ima491) THEN LET l_ima491 = 0 END IF
     IF l_ima491 > 0 THEN
        CALL s_getdate1(g_oga.oga02,l_ima491) RETURNING l_rvb.rvb12
     ELSE
        IF cl_null(l_rvb.rvb12) THEN
           LET l_rvb.rvb12= g_oga.oga02
        END IF
     END IF
     LET l_rvb.rvb13 = NULL
     LET l_rvb.rvb14 = NULL
     LET l_rvb.rvb15 = 0
     LET l_rvb.rvb16 = 0 
     LET l_rvb.rvb17 = NULL
     LET l_rvb.rvb18 = '10'
     LET l_rvb.rvb19 = '1'
     LET l_rvb.rvb20 = NULL
     LET l_rvb.rvb21 = NULL
     LET l_rvb.rvb27 = 0 
     LET l_rvb.rvb28 = 0 
     LET l_rvb.rvb29 = 0 
     LET l_rvb.rvb30 = l_rvb.rvb07
     LET l_rvb.rvb31 = 0 #TQC-C30052 add
     LET l_rvb.rvb35 = 'N'
     CALL p820_ima(l_rvb.rvb05,s_plant_new) #FUN-980092 add
       RETURNING l_ima02,l_ima25,l_qoh,l_ima86,l_ima39,
                 l_rvb.rvb36,l_rvb.rvb37
     LET l_rvb.rvb38 = ' '
 
     #IF NOT cl_null(s_imd01) THEN   #MOD-A60181
     IF NOT cl_null(s_imd01) AND p_i > 1 THEN   #MOD-A60181
        CALL p820_imd(s_imd01,s_plant_new) #FUN-980092 add
        LET l_rvb.rvb36 = s_imd01
        LET l_rvb.rvb37 = ' '
        LET l_rvb.rvb38 = ' '
     ELSE
        LET l_rvb.rvb36 = g_ogb.ogb09
        LET l_rvb.rvb37 = g_ogb.ogb091
        LET l_rvb.rvb38 = g_ogb.ogb092
     END IF
    #IF g_sma.sma96 = 'Y' THEN          #FUN-C80001 #FUN-D30099 mark
     IF g_pod.pod08 = 'Y' THEN          #FUN-D30099
        LET l_rvb.rvb38 = g_ogb.ogb092  #FUN-C80001
     END IF                             #FUN-C80001
     #收料單位與倉庫的庫存單位轉換率的計算
      LET l_sql1 = "SELECT img09 ",                                 
                   #" FROM ",s_dbs_tra CLIPPED,"img_file ",    #FUN-980092 add
                   " FROM ",cl_get_target_table(s_plant_new,'img_file'), #FUN-A50102
                   " WHERE img01 ='", l_rvb.rvb05,"' ",
                   "   AND img02 ='", l_rvb.rvb36,"' ",
                   "   AND img03 ='", l_rvb.rvb37,"' ",
                   "   AND img04 ='", l_rvb.rvb38,"' "
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,s_plant_new) RETURNING l_sql1 #FUN-980092
     PREPARE img1_p1 FROM l_sql1
     IF SQLCA.SQLCODE THEN 
        CALL cl_err('img1_p1',SQLCA.SQLCODE,1)
     END IF
     DECLARE img1_c1 CURSOR FOR img1_p1
     OPEN img1_c1
     FETCH img1_c1 INTO l_ogb.ogb15
 
      IF STATUS=0 THEN
         IF g_pmn.pmn07 = l_ogb.ogb15 THEN
             LET g_pmn.pmn09 = 1
         ELSE
             #檢查該銷售單位與倉庫的庫存單位是否可以轉換
             CALL s_umfchkm(l_rvb.rvb05,g_pmn.pmn07,l_ogb.ogb15,s_plant_new)  #FUN-980092 add
                  RETURNING l_flag,g_pmn.pmn09
             IF l_flag THEN
                LET g_msg=s_plant_new CLIPPED,' ',l_ogb.ogb04  #FUN-980092 add
                CALL cl_err(g_msg,'mfg3075',1)
                LET g_success = 'N'
             END IF 
         END IF
      END IF
      IF cl_null(g_pmn.pmn09) THEN LET g_pmn.pmn09=1 END IF
 
     LET l_rvb.rvb39 = 'N'   #免驗
     LET l_rvb.rvb40 = NULL
     LET l_rvb.rvb41 = NULL
     LET l_rvb.rvb80 = g_ogb.ogb910 
     LET l_rvb.rvb81 = g_ogb.ogb911 
     LET l_rvb.rvb82 = g_ogb.ogb912 
     LET l_rvb.rvb83 = g_ogb.ogb913 
     LET l_rvb.rvb84 = g_ogb.ogb914 
     LET l_rvb.rvb85 = g_ogb.ogb915 
     LET l_rvb.rvb86 = g_ogb.ogb916 
     LET l_rvb.rvb87 = g_ogb.ogb917 
     LET l_rvb.rvbud01 = g_ogb.ogbud01
     LET l_rvb.rvbud02 = g_ogb.ogbud02
     LET l_rvb.rvbud03 = g_ogb.ogbud03
     LET l_rvb.rvbud04 = g_ogb.ogbud04
     LET l_rvb.rvbud05 = g_ogb.ogbud05
     LET l_rvb.rvbud06 = g_ogb.ogbud06
     LET l_rvb.rvbud07 = g_ogb.ogbud07
     LET l_rvb.rvbud08 = g_ogb.ogbud08
     LET l_rvb.rvbud09 = g_ogb.ogbud09
     LET l_rvb.rvbud10 = g_ogb.ogbud10
     LET l_rvb.rvbud11 = g_ogb.ogbud11
     LET l_rvb.rvbud12 = g_ogb.ogbud12
     LET l_rvb.rvbud13 = g_ogb.ogbud13
     LET l_rvb.rvbud14 = g_ogb.ogbud14
     LET l_rvb.rvbud15 = g_ogb.ogbud15
 

     #LET l_rvb.rvb88=l_rvb.rvb87*l_rvb.rvb10  #TQC-D40097 mark
     #LET l_rvb.rvb88t=l_rvb.rvb87*l_rvb.rvb10t #TQC-D40097 mark
     LET l_rvb.rvb88= g_ogb.ogb14 #TQC-D40097 add
     LET l_rvb.rvb88t= g_ogb.ogb14t  #TQC-D40097 ADD 
     #MOD-C80064 add start -----
     LET l_sql = "SELECT azi04 FROM ",cl_get_target_table(s_plant_new,'azi_file'),
                 " WHERE azi01='",g_pmm.pmm22,"' "
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql
     CALL cl_parse_qry_sql(l_sql,s_plant_new) RETURNING l_sql
     PREPARE azi_rvb88 FROM l_sql
     IF SQLCA.SQLCODE THEN
        IF g_bgerr THEN
          CALL s_errmsg('azi01',g_pmm.pmm22,'azi_rvb88',SQLCA.SQLCODE,0) 
        ELSE
          CALL cl_err('azi_rvb88',SQLCA.SQLCODE,1)
        END IF
     END IF
     DECLARE azi_c_rvb88 CURSOR FOR azi_rvb88
     OPEN azi_c_rvb88
     FETCH azi_c_rvb88 INTO t_azi04
     CLOSE azi_c_rvb88
        
     CALL cl_digcut(l_rvb.rvb88,t_azi04) RETURNING l_rvb.rvb88
     CALL cl_digcut(l_rvb.rvb88t,t_azi04) RETURNING l_rvb.rvb88t
     #MOD-C80064 add end   -----

     LET l_rvb.rvb930 = g_pmn.pmn930  #MOD-920261 add 
     LET l_rvb.rvb89 = 'N'            #FUN-940083 add 
##NO.FUN-670047 --各站抓apmi000設定的採購成本中心--
 
     #新增出貨單身檔
     #LET l_sql2="INSERT INTO ",s_dbs_tra CLIPPED,"rvb_file",  #FUN-980092 add
     LET l_sql2="INSERT INTO ",cl_get_target_table(s_plant_new,'rvb_file'), #FUN-A50102
      "(rvb01,rvb02,rvb03,rvb04,rvb05, ",
      " rvb06,rvb07,rvb08,rvb09,rvb10, ",
      " rvb11,rvb12,rvb13,rvb14,rvb15, ",
      " rvb16,rvb17,rvb18,rvb19,rvb20, ",
      " rvb21,rvb22,rvb25,rvb26,rvb27, ",
      " rvb28,rvb29,rvb30,rvb31,rvb32, ",
      " rvb33,rvb34,rvb35,rvb36,rvb37, ",
      " rvb38,rvb39,rvb40,rvb41,rvb80, ",   #FUN-560043
      " rvb81,rvb82,rvb83,rvb84,rvb85, ",   #FUN-560043
      " rvb86,rvb87,rvb10t,rvb88,rvb88t,rvb930,rvb89,", #NO.FUN-620024  #No.TQC-6A0084  #MOD-920261 rvb930 #FUN-940083 rvb89
      " rvbplant,rvblegal , ",
      " rvbud01,rvbud02,rvbud03,rvbud04,rvbud05,",
      " rvbud06,rvbud07,rvbud08,rvbud09,rvbud10,",
      " rvbud11,rvbud12,rvbud13,rvbud14,rvbud15,rvb90)",    #MOD-B30584 add rvb90
      " VALUES( ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,",
      "         ?,?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,",  #NO.FUN-620024
      "         ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,",    #No.CHI-950020
      "         ?,?,?,?,?,  ?,?,?,?, ?,?,?,?, ?,?,?,?,?, ?,?,?,  ?,?,? ) "   #FUN-560043  #No.TQC-6A0084  #MOD-920261 add ? #FUN-940083  #FUN-980010 #MOD-B30584 add ?
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2 #FUN-A50102
     PREPARE ins_rvb FROM l_sql2
     EXECUTE ins_rvb USING 
        l_rvb.rvb01,l_rvb.rvb02,l_rvb.rvb03,l_rvb.rvb04,l_rvb.rvb05,
        l_rvb.rvb06,l_rvb.rvb07,l_rvb.rvb08,l_rvb.rvb09,l_rvb.rvb10,
        l_rvb.rvb11,l_rvb.rvb12,l_rvb.rvb13,l_rvb.rvb14,l_rvb.rvb15,
        l_rvb.rvb16,l_rvb.rvb17,l_rvb.rvb18,l_rvb.rvb19,l_rvb.rvb20,
        l_rvb.rvb21,l_rvb.rvb22,l_rvb.rvb25,l_rvb.rvb26,l_rvb.rvb27,
        l_rvb.rvb28,l_rvb.rvb29,l_rvb.rvb30,l_rvb.rvb31,l_rvb.rvb32,
        l_rvb.rvb33,l_rvb.rvb34,l_rvb.rvb35,l_rvb.rvb36,l_rvb.rvb37,
        l_rvb.rvb38,l_rvb.rvb39,l_rvb.rvb40,l_rvb.rvb41,l_rvb.rvb80,   #FUN-560043
        l_rvb.rvb81,l_rvb.rvb82,l_rvb.rvb83,l_rvb.rvb84,l_rvb.rvb85,   #FUN-560043
        l_rvb.rvb86,l_rvb.rvb87,l_rvb.rvb10t,  #NO.FUN-620024
        l_rvb.rvb88,l_rvb.rvb88t,l_rvb.rvb930, #No.TQC-6A0084  #MOD-920261 add
        l_rvb.rvb89,                           #No.FUN-940083 add
        sp_plant,sp_legal   #FUN-980010
       ,l_rvb.rvbud01,l_rvb.rvbud02,l_rvb.rvbud03,
        l_rvb.rvbud04,l_rvb.rvbud05,l_rvb.rvbud06,
        l_rvb.rvbud07,l_rvb.rvbud08,l_rvb.rvbud09,
        l_rvb.rvbud10,l_rvb.rvbud11,l_rvb.rvbud12,
        l_rvb.rvbud13,l_rvb.rvbud14,l_rvb.rvbud15,l_rvb.rvb90   #MOD-B30584 add rvb90
     IF SQLCA.sqlcode<>0 THEN
        LET g_showmsg = l_rvb.rvb01,"/",l_rvb.rvb02 #No.FUN-710046
        CALL s_errmsg('rvb01,rvb02',g_showmsg,'ins rvb:',SQLCA.sqlcode,1) #No.FUN-710046
        LET g_success = 'N'
     ELSE
        IF NOT s_industry('std') THEN
           INITIALIZE l_rvbi.* TO NULL
           LET l_rvbi.rvbi01 = l_rvb.rvb01
           LET l_rvbi.rvbi02 = l_rvb.rvb02
           IF NOT s_ins_rvbi(l_rvbi.*,s_plant_new) THEN #FUN-980092 add
              LET g_success = 'N'
           END IF
        END IF
     END IF
 
   #LET l_sql2 = "SELECT ima918,ima921 FROM ",l_dbs_new CLIPPED,"ima_file",
#  LET l_sql2 = "SELECT ima918,ima921 FROM ",cl_get_target_table(l_plant_new,'ima_file'), #FUN-A50102   #TQC-B90240
   LET l_sql2 = "SELECT ima918,ima921 FROM ",cl_get_target_table(s_plant_new,'ima_file'), #TQC-B90240
                " WHERE ima01 = '",l_rvb.rvb05,"'",
                "   AND imaacti = 'Y'"
 
   CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
#  CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102  #TQC-B90240
   CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2 #TQC-B90240 
   PREPARE ima_rvb FROM l_sql2
 
   EXECUTE ima_rvb INTO g_ima918,g_ima921                                                                             
     
   #LET l_sql2 = "SELECT sma90 FROM ",l_dbs_new CLIPPED,"sma_file",
#  LET l_sql2 = "SELECT sma90 FROM ",cl_get_target_table(l_plant_new,'sma_file'), #FUN-A50102  #TQC-B90240
   LET l_sql2 = "SELECT sma90 FROM ",cl_get_target_table(s_plant_new,'sma_file'), #TQC-B90240
                " WHERE sma00 = '0'"
   
   CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
#  CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102   #TQC-B90240
   CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2 #TQC-B90240
   PREPARE sma_rvb FROM l_sql2
   
   EXECUTE sma_rvb INTO l_sma90
     
   IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
      IF l_sma90 = "Y" THEN
      
         LET l_cnt = 0 #CHI-C40031 add
         FOREACH p820_g_rvbs INTO l_rvbs.*
            IF STATUS THEN
               CALL cl_err('rvbs',STATUS,1)
            END IF
 
            LET l_rvbs.rvbs00 = "apmt300"
         
            LET l_rvbs.rvbs01 = l_rvb.rvb01

            LET l_cnt = l_cnt + 1      #CHI-C40031 add
            LET l_rvbs.rvbs022 = l_cnt #CHI-C40031 add

           #LET l_rvbs.rvbs06 = l_rvbs.rvbs06 * l_ogb.ogb05_fac #CHI-C40031 mark
      
#CHI-C40031---add---START
            IF g_ogb.ogb17='Y' THEN        #多倉儲出貨
               IF g_sma.sma115 = 'Y' THEN  #多單位
                  OPEN p820_g_ogg USING l_rvbs.rvbs13
                  FETCH p820_g_ogg INTO g_ogg.*
                     IF STATUS THEN
                        CALL cl_err('ogg',STATUS,1)
                     END IF
                     IF g_ima906 = '3' AND g_ogg.ogg20 = '2' THEN
                        LET l_rvbs.rvbs06 = l_rvbs.rvbs06 * 1
                     ELSE
                        LET l_rvbs.rvbs06 = l_rvbs.rvbs06 * g_ogg.ogg15_fac
                     END IF
               ELSE
                  OPEN p820_g_ogc USING l_rvbs.rvbs13
                  FETCH p820_g_ogc INTO g_ogc.*
                     IF STATUS THEN
                        CALL cl_err('ogc',STATUS,1)
                     END IF
                     LET l_rvbs.rvbs06 = l_rvbs.rvbs06 * g_ogc.ogc15_fac
               END IF
            ELSE
               LET l_rvbs.rvbs06 = l_rvbs.rvbs06 * l_ogb.ogb05_fac
            END IF
#CHI-C40031---add-----END

           LET l_rvbs.rvbs09 = 1
 
            IF cl_null(l_rvbs.rvbs06) THEN
               LET l_rvbs.rvbs06 = 0
            END IF
            LET l_rvbs.rvbs13=0                 #No.CHI-990031
 
            #新增批/序號資料檔
           #EXECUTE ins_rvbs USING l_rvbs.rvbs00,l_rvbs.rvbs01,l_rvbs.rvbs02,  #FUN-C80001 mark
            EXECUTE ins_rvbs1 USING l_rvbs.rvbs00,l_rvbs.rvbs01,l_rvbs.rvbs02, #FUN-C80001 add
                                   l_rvbs.rvbs021,l_rvbs.rvbs022,l_rvbs.rvbs03,
                                   l_rvbs.rvbs04,l_rvbs.rvbs05,l_rvbs.rvbs06,
                                   l_rvbs.rvbs07,l_rvbs.rvbs08,l_rvbs.rvbs09,
                                  #gp_plant,gp_legal   #FUN-980010 #FUN-C80001 mark
                                   sp_plant,sp_legal   #FUN-C80001 add
                                  ,l_rvbs.rvbs13       #No.CHI-990031 add rvbs13
      
            IF STATUS OR SQLCA.SQLCODE THEN
               LET g_showmsg = l_rvbs.rvbs01,"/",l_rvbs.rvbs03
               CALL s_errmsg('rvbs01,rvbs03',g_showmsg,'ins rvbs:',SQLCA.sqlcode,1) 
               LET g_success='N'
            END IF
         
            CALL p820_imgs(l_rvb.rvb36,l_rvb.rvb37,l_rvb.rvb38,l_rva.rva06,l_rvbs.*,p_i)	#MOD-980058 #FUN-C80001
 
         END FOREACH
      END IF
   END IF

#FUN-B90012 ---------------------------Begin------------------------------
   IF s_industry('icd') THEN 
#     LET l_sql2 = "SELECT imaicd08 FROM ",cl_get_target_table(l_plant_new,'imaicd_file'),",",    #TQC-B90240
#                                          cl_get_target_table(l_plant_new,'ima_file'),           #TQC-B90240 
      #FUN-BA0051 --START mark--   
      #LET l_sql2 = "SELECT imaicd08 FROM ",cl_get_target_table(s_plant_new,'imaicd_file'),",",  #TQC-B90240
      #                                     cl_get_target_table(s_plant_new,'ima_file'),         #TQC-B90240
      #             " WHERE imaicd00 = '",l_rvb.rvb05,"'",
      #             "   AND ima01 = imaicd00 ",
      #             "   AND imaacti = 'Y'"
      #CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        
      ##CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2   #TQC-B90240
      #CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2   #TQC-B90240
      #PREPARE p820_rvb_imaicd08 FROM l_sql2
      #EXECUTE p820_rvb_imaicd08 INTO l_imaicd08 
      #IF l_imaicd08 = 'Y' THEN
      #FUN-BA0051 --END mark--
      IF s_icdbin_multi(l_rvb.rvb05,s_plant_new) THEN   #FUN-BA0051
         FOREACH p820_g_idd INTO l_idd.*
            LET l_idd.idd10 = l_rvb.rvb01
            LET l_idd.idd11 = l_rvb.rvb02
         #CHI-C80009---add---START
            LET l_idd.idd02 = l_rvb.rvb36
            LET l_idd.idd03 = l_rvb.rvb37
            LET l_idd.idd04 = l_rvb.rvb38
         #CHI-C80009---add-----END
      #     CALL icd_ida(1,l_idd.*,l_plant_new)   #TQC-B90240
            CALL icd_ida(1,l_idd.*,s_plant_new)   #TQC-B90240
         END FOREACH 
      END IF
#     LET l_sql1 = "SELECT rvbiicd08,rvbiicd16 FROM ",cl_get_target_table(l_plant_new,'rvbi_file'),  #TQC-B90240 
      LET l_sql1 = "SELECT rvbiicd08,rvbiicd16 FROM ",cl_get_target_table(s_plant_new,'rvbi_file'),  #TQC-B90240
                   " WHERE rvbi01 = '",l_rvb.rvb01,"'",
                   "   AND rvbi02 =  ",l_rvb.rvb02
      CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1
#     CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1    #TQC-B90240
      CALL cl_parse_qry_sql(l_sql1,s_plant_new) RETURNING l_sql1    #TQC-B90240
      PREPARE p820_rvbi FROM l_sql1
      EXECUTE p820_rvbi INTO l_rvbiicd08,l_rvbiicd16
      CALL s_icdpost(13,l_rvb.rvb05,l_rvb.rvb36,l_rvb.rvb37,l_rvb.rvb38,g_pmn.pmn07,l_rvb.rvb07,l_rvb.rvb01,l_rvb.rvb02,
      #              l_rva.rva06,'Y','','',l_rvbiicd16,l_rvbiicd08,l_plant_new)   #TQC-B90240
                     l_rva.rva06,'Y','','',l_rvbiicd16,l_rvbiicd08,s_plant_new)   #TQC-B90240
           RETURNING l_flag1
      IF l_flag1 = 0 THEN
         LET g_success = 'N'
      END IF   
   END IF
#FUN-B90012 ---------------------------End--------------------------------
 
END FUNCTION
#FUN-C80001---begin
#收貨單身檔-多倉儲
FUNCTION p820_rvbins1(p_i)
  DEFINE l_sql,l_sql1,l_sql2 STRING        
  DEFINE p_i    LIKE type_file.num5  
  DEFINE l_no   LIKE type_file.num5    
  DEFINE l_price LIKE ogb_file.ogb13
  DEFINE i,l_i   LIKE type_file.num5   
  DEFINE l_msg   LIKE type_file.chr1000
  DEFINE l_chr   LIKE type_file.chr1   
  DEFINE l_ima491 LIKE ima_file.ima491
  DEFINE l_ima02  LIKE ima_file.ima02
  DEFINE l_ima25  LIKE ima_file.ima25
  DEFINE l_qoh    LIKE type_file.num15_3 
  DEFINE l_ima39  LIKE ima_file.ima39
  DEFINE l_ima86  LIKE ima_file.ima86
  DEFINE l_cmd    LIKE type_file.chr1000,
         l_currm LIKE pmm_file.pmm42,     
         x_currm LIKE pmm_file.pmm42,     
         l_curr  LIKE pmm_file.pmm22     
  DEFINE l_rvbi  RECORD LIKE rvbi_file.*  
  DEFINE l_flag   SMALLINT   
  DEFINE l_rvbs  RECORD LIKE rvbs_file.*  
  DEFINE l_sma90 LIKE sma_file.sma90  
  DEFINE l_idd   RECORD LIKE idd_file.*            
  DEFINE l_flag1        LIKE type_file.num10       
  DEFINE l_rvbiicd08    LIKE rvbi_file.rvbiicd08   
  DEFINE l_rvbiicd16    LIKE rvbi_file.rvbiicd16      
  DEFINE l_cnt          LIKE type_file.num5
  DEFINE l_rvb02        LIKE rvb_file.rvb02 
  DEFINE l_ogc   RECORD 
                 ogc09  LIKE ogc_file.ogc09,
                 ogc091 LIKE ogc_file.ogc091,
                 ogc092 LIKE ogc_file.ogc092,
                 ogc12  LIKE ogc_file.ogc12
                 END RECORD
  DEFINE l_ogg   RECORD LIKE ogg_file.*
    IF p_i = 1 THEN
       IF g_sma.sma115 = 'Y' THEN
          LET l_sql1 = " SELECT ogg09,ogg091,ogg092,SUM(ogg12) FROM ogg_file ",
                      "  WHERE ogg01 = '",g_oga.oga01,"'",
                      "    AND ogg03 = '",g_ogb.ogb03,"'",
                      "    AND ogg20 = 1 ",
                      "  GROUP BY ogg09,ogg091,ogg092 "
       ELSE 
          LET l_sql1 = " SELECT ogc09,ogc091,ogc092,SUM(ogc12) FROM ogc_file ",
                         "  WHERE ogc01 = '",g_oga.oga01,"'",
                         "    AND ogc03 = '",g_ogb.ogb03,"'",
                         "  GROUP BY ogc09,ogc091,ogc092 "
       END IF
    ELSE
       IF g_sma.sma115 = 'Y' THEN
          LET l_sql1 = " SELECT '','',ogg092,SUM(ogg12) FROM ogg_file ",
                      "  WHERE ogg01 = '",g_oga.oga01,"'",
                      "    AND ogg03 = '",g_ogb.ogb03,"'",
                      "    AND ogg20 = 1 ",
                      "  GROUP BY ogg092 "
       ELSE        
          LET l_sql1 = " SELECT '','',ogc092,SUM(ogc12) FROM ogc_file ",
                         "  WHERE ogc01 = '",g_oga.oga01,"'",
                         "    AND ogc03 = '",g_ogb.ogb03,"'",
                         "  GROUP BY ogc092 "
       END IF
    END IF
  DECLARE p820_ogc_c1 CURSOR FROM l_sql1
   
  #讀取採購單身檔(pmn_file)
  LET l_sql1 = "SELECT ",cl_get_target_table(s_plant_new,'pmn_file.*'), 
               "  FROM ",cl_get_target_table(s_plant_new,'pmn_file'),",", 
                         cl_get_target_table(s_plant_new,'pmm_file'), 
               " WHERE pmn01 = pmm01",
               "   AND pmm99 ='",g_oea.oea99,"'", 
               "  AND pmn02 =",g_ogb.ogb32
  CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        
  CALL cl_parse_qry_sql(l_sql1,s_plant_new) RETURNING l_sql1 
  PREPARE pmn_p2 FROM l_sql1
  IF SQLCA.SQLCODE THEN 
     LET g_showmsg = g_oea.oea99,"/",g_ogb.ogb32    
     CALL s_errmsg('pmm99,pmn02',g_showmsg,'pmn_p1',SQLCA.SQLCODE,0)  
  END IF
  DECLARE pmn_c2 CURSOR FOR pmn_p2
  OPEN pmn_c2
  FETCH pmn_c2 INTO g_pmn.*
  IF SQLCA.SQLCODE <> 0 THEN
     LET g_success='N'
     RETURN
  END IF
  CLOSE pmn_c2

  LET l_sql2 = "SELECT sma90 FROM ",cl_get_target_table(s_plant_new,'sma_file'),
               " WHERE sma00 = '0'"
   
  CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2       
  CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2 
  PREPARE sma_rvb2 FROM l_sql2
   
  EXECUTE sma_rvb2 INTO l_sma90
  
  SELECT MAX(rvb02) INTO l_rvb02
    FROM rvb_file
   WHERE rvb01 = l_rva.rva01
  IF cl_null(l_rvb02) THEN LET l_rvb02 = 0 END IF 
   
  FOREACH p820_ogc_c1 INTO l_ogc.*
     LET l_rvb.rvb01 = l_rva.rva01      #驗收單身檔
     LET l_rvb02 = l_rvb02 + 1
     LET l_rvb.rvb02 = l_rvb02          #驗收單項次
     LET l_rvb.rvb03 = g_pmn.pmn02      #採購單項次
     LET l_rvb.rvb04 = g_pmn.pmn01      #採購單號
     LET l_rvb.rvb05 = g_ogb.ogb04      #料件編號
     LET l_rvb.rvb06 = 0                #已請款量
     LET l_rvb.rvb07 = l_ogc.ogc12      #實收數量 銷售
     LET l_rvb.rvb08 = l_ogc.ogc12      #收貨數量
     LET l_rvb.rvb09 = 0                #允請款量
     LET l_rvb.rvb90 = g_pmn.pmn07      
     LET l_rvb.rvb07 = s_digqty(l_rvb.rvb07,l_rvb.rvb90) 
     LET l_rvb.rvb08 = s_digqty(l_rvb.rvb08,l_rvb.rvb90) 
 
     IF l_oga.oga213 = 'N' THEN
        LET l_rvb.rvb10 = l_ogb.ogb13
        LET l_rvb.rvb10t= l_ogb.ogb13*(1+l_oga.oga211/100)
     ELSE 
        LET l_rvb.rvb10t= l_ogb.ogb13
        LET l_rvb.rvb10 = l_ogb.ogb13/(1+l_oga.oga211/100)
     END IF
 
     #備品時金額、單價應為零
     IF p820_chkoeo(g_ogb.ogb31,g_ogb.ogb32,g_ogb.ogb04) THEN
        LET l_rvb.rvb10 = 0 
        LET l_rvb.rvb10t= 0 
     END IF
     LET l_rvb.rvb11 = 0
 
     LET l_cmd = " SELECT ima491",
                 "   FROM ",cl_get_target_table(s_plant_new,'ima_file'), 
                 "  WHERE ima01 = '",l_rvb.rvb05,"'"
 	 CALL cl_replace_sqldb(l_cmd) RETURNING l_cmd        
     CALL cl_parse_qry_sql(l_cmd,s_plant_new) RETURNING l_cmd 
     PREPARE ima_pre4 FROM l_cmd
     DECLARE ima_c4  CURSOR FOR ima_pre4
     OPEN ima_c4    
     FETCH ima_c4 INTo l_ima491
     CLOSE ima_c4
 
     IF cl_null(l_ima491) THEN LET l_ima491 = 0 END IF
     IF l_ima491 > 0 THEN
        CALL s_getdate1(g_oga.oga02,l_ima491) RETURNING l_rvb.rvb12
     ELSE
        IF cl_null(l_rvb.rvb12) THEN
           LET l_rvb.rvb12= g_oga.oga02
        END IF
     END IF
     LET l_rvb.rvb13 = NULL
     LET l_rvb.rvb14 = NULL
     LET l_rvb.rvb15 = 0
     LET l_rvb.rvb16 = 0 
     LET l_rvb.rvb17 = NULL
     LET l_rvb.rvb18 = '10'
     LET l_rvb.rvb19 = '1'
     LET l_rvb.rvb20 = NULL
     LET l_rvb.rvb21 = NULL
     LET l_rvb.rvb27 = 0 
     LET l_rvb.rvb28 = 0 
     LET l_rvb.rvb29 = 0 
     LET l_rvb.rvb30 = l_rvb.rvb07
     LET l_rvb.rvb31 = 0 
     LET l_rvb.rvb35 = 'N'
     CALL p820_ima(l_rvb.rvb05,s_plant_new) 
       RETURNING l_ima02,l_ima25,l_qoh,l_ima86,l_ima39,
                 l_rvb.rvb36,l_rvb.rvb37
 
     IF NOT cl_null(s_imd01) AND p_i > 1 THEN  
        CALL p820_imd(s_imd01,s_plant_new)
        LET l_rvb.rvb36 = s_imd01
        LET l_rvb.rvb37 = ' '
     ELSE
        LET l_rvb.rvb36 = l_ogc.ogc09
        LET l_rvb.rvb37 = l_ogc.ogc091
     END IF
     IF cl_null(l_rvb.rvb37) THEN LET l_rvb.rvb37 = ' ' END IF 
     LET l_rvb.rvb38 = l_ogc.ogc092  
     
     #收料單位與倉庫的庫存單位轉換率的計算
      LET l_sql1 = "SELECT img09 ",                                 
                   " FROM ",cl_get_target_table(s_plant_new,'img_file'), 
                   " WHERE img01 ='", l_rvb.rvb05,"' ",
                   "   AND img02 ='", l_rvb.rvb36,"' ",
                   "   AND img03 ='", l_rvb.rvb37,"' ",
                   "   AND img04 ='", l_rvb.rvb38,"' "
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        
     CALL cl_parse_qry_sql(l_sql1,s_plant_new) RETURNING l_sql1 
     PREPARE img1_p2 FROM l_sql1
     IF SQLCA.SQLCODE THEN 
        CALL cl_err('img1_p1',SQLCA.SQLCODE,1)
     END IF
     DECLARE img1_c2 CURSOR FOR img1_p2
     OPEN img1_c2
     FETCH img1_c2 INTO l_ogb.ogb15
 
      IF STATUS=0 THEN
         IF g_pmn.pmn07 = l_ogb.ogb15 THEN
             LET g_pmn.pmn09 = 1
         ELSE
             #檢查該銷售單位與倉庫的庫存單位是否可以轉換
             CALL s_umfchkm(l_rvb.rvb05,g_pmn.pmn07,l_ogb.ogb15,s_plant_new)
                  RETURNING l_flag,g_pmn.pmn09
             IF l_flag THEN
                LET g_msg=s_plant_new CLIPPED,' ',l_ogb.ogb04  
                CALL cl_err(g_msg,'mfg3075',1)
                LET g_success = 'N'
             END IF 
         END IF
      END IF
      IF cl_null(g_pmn.pmn09) THEN LET g_pmn.pmn09=1 END IF
 
     LET l_rvb.rvb39 = 'N'   #免驗
     LET l_rvb.rvb40 = NULL
     LET l_rvb.rvb41 = NULL
     IF g_sma.sma115 = 'Y' THEN
        LET l_rvb.rvb80 = g_ogb.ogb910 
        LET l_rvb.rvb81 = g_ogb.ogb911 
        LET l_rvb.rvb82 = l_ogc.ogc12 
        LET l_rvb.rvb83 = NULL  
        LET l_rvb.rvb84 = NULL
        LET l_rvb.rvb85 = NULL
        
        SELECT ogg15,ogg15_fac,SUM(ogg12)
          INTO l_rvb.rvb83,l_rvb.rvb84,l_rvb.rvb85
          FROM ogg_file
         WHERE ogg01 = g_oga.oga01
           AND ogg03 = g_ogb.ogb03
           AND ogg20 = 2
           AND ogg092 = l_ogc.ogc092
         GROUP BY ogg092,ogg15,ogg15_fac
        IF g_ima906 = '2' THEN
             CALL s_umfchk(l_rvb.rvb05,l_rvb.rvb83,l_ogb.ogb15) 
                  RETURNING l_flag,l_rvb.rvb84
        END IF 
     ELSE 
        LET l_rvb.rvb80 = g_ogb.ogb910 
        LET l_rvb.rvb81 = g_ogb.ogb911 
        LET l_rvb.rvb82 = l_ogc.ogc12 
        LET l_rvb.rvb83 = g_ogb.ogb913 
        LET l_rvb.rvb84 = g_ogb.ogb914 
        LET l_rvb.rvb85 = g_ogb.ogb915 
     END IF 
     LET l_rvb.rvb86 = g_ogb.ogb916 
     IF g_ima906 = '2' THEN
        LET l_rvb.rvb87 = l_ogc.ogc12 + (l_rvb.rvb85*l_rvb.rvb84)
        LET l_rvb.rvb07 = l_ogc.ogc12 + (l_rvb.rvb85*l_rvb.rvb84)
        LET l_rvb.rvb08 = l_ogc.ogc12 + (l_rvb.rvb85*l_rvb.rvb84)
        LET l_rvb.rvb07 = s_digqty(l_rvb.rvb07,l_rvb.rvb90)
        LET l_rvb.rvb08 = s_digqty(l_rvb.rvb08,l_rvb.rvb90)
        LET l_rvb.rvb30 = l_rvb.rvb07
     ELSE 
        LET l_rvb.rvb87 = l_ogc.ogc12   
     END IF  
     LET l_rvb.rvbud01 = g_ogb.ogbud01
     LET l_rvb.rvbud02 = g_ogb.ogbud02
     LET l_rvb.rvbud03 = g_ogb.ogbud03
     LET l_rvb.rvbud04 = g_ogb.ogbud04
     LET l_rvb.rvbud05 = g_ogb.ogbud05
     LET l_rvb.rvbud06 = g_ogb.ogbud06
     LET l_rvb.rvbud07 = g_ogb.ogbud07
     LET l_rvb.rvbud08 = g_ogb.ogbud08
     LET l_rvb.rvbud09 = g_ogb.ogbud09
     LET l_rvb.rvbud10 = g_ogb.ogbud10
     LET l_rvb.rvbud11 = g_ogb.ogbud11
     LET l_rvb.rvbud12 = g_ogb.ogbud12
     LET l_rvb.rvbud13 = g_ogb.ogbud13
     LET l_rvb.rvbud14 = g_ogb.ogbud14
     LET l_rvb.rvbud15 = g_ogb.ogbud15
 
     LET l_rvb.rvb88=l_rvb.rvb87*l_rvb.rvb10
     LET l_rvb.rvb88t=l_rvb.rvb87*l_rvb.rvb10t
 
     LET l_rvb.rvb930 = g_pmn.pmn930  
     LET l_rvb.rvb89 = 'N'           
 
     #新增出貨單身檔
     LET l_sql2="INSERT INTO ",cl_get_target_table(s_plant_new,'rvb_file'), 
      "(rvb01,rvb02,rvb03,rvb04,rvb05, ",
      " rvb06,rvb07,rvb08,rvb09,rvb10, ",
      " rvb11,rvb12,rvb13,rvb14,rvb15, ",
      " rvb16,rvb17,rvb18,rvb19,rvb20, ",
      " rvb21,rvb22,rvb25,rvb26,rvb27, ",
      " rvb28,rvb29,rvb30,rvb31,rvb32, ",
      " rvb33,rvb34,rvb35,rvb36,rvb37, ",
      " rvb38,rvb39,rvb40,rvb41,rvb80, ",   
      " rvb81,rvb82,rvb83,rvb84,rvb85, ",   
      " rvb86,rvb87,rvb10t,rvb88,rvb88t,rvb930,rvb89,", 
      " rvbplant,rvblegal , ",
      " rvbud01,rvbud02,rvbud03,rvbud04,rvbud05,",
      " rvbud06,rvbud07,rvbud08,rvbud09,rvbud10,",
      " rvbud11,rvbud12,rvbud13,rvbud14,rvbud15,rvb90)",   
      " VALUES( ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,",
      "         ?,?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,",  
      "         ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,",    
      "         ?,?,?,?,?,  ?,?,?,?, ?,?,?,?, ?,?,?,?,?, ?,?,?,  ?,?,? ) "  
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2       
     CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2 
     PREPARE ins_rvb2 FROM l_sql2
     EXECUTE ins_rvb2 USING 
        l_rvb.rvb01,l_rvb.rvb02,l_rvb.rvb03,l_rvb.rvb04,l_rvb.rvb05,
        l_rvb.rvb06,l_rvb.rvb07,l_rvb.rvb08,l_rvb.rvb09,l_rvb.rvb10,
        l_rvb.rvb11,l_rvb.rvb12,l_rvb.rvb13,l_rvb.rvb14,l_rvb.rvb15,
        l_rvb.rvb16,l_rvb.rvb17,l_rvb.rvb18,l_rvb.rvb19,l_rvb.rvb20,
        l_rvb.rvb21,l_rvb.rvb22,l_rvb.rvb25,l_rvb.rvb26,l_rvb.rvb27,
        l_rvb.rvb28,l_rvb.rvb29,l_rvb.rvb30,l_rvb.rvb31,l_rvb.rvb32,
        l_rvb.rvb33,l_rvb.rvb34,l_rvb.rvb35,l_rvb.rvb36,l_rvb.rvb37,
        l_rvb.rvb38,l_rvb.rvb39,l_rvb.rvb40,l_rvb.rvb41,l_rvb.rvb80,  
        l_rvb.rvb81,l_rvb.rvb82,l_rvb.rvb83,l_rvb.rvb84,l_rvb.rvb85,   
        l_rvb.rvb86,l_rvb.rvb87,l_rvb.rvb10t,  
        l_rvb.rvb88,l_rvb.rvb88t,l_rvb.rvb930, 
        l_rvb.rvb89,                          
        sp_plant,sp_legal  
       ,l_rvb.rvbud01,l_rvb.rvbud02,l_rvb.rvbud03,
        l_rvb.rvbud04,l_rvb.rvbud05,l_rvb.rvbud06,
        l_rvb.rvbud07,l_rvb.rvbud08,l_rvb.rvbud09,
        l_rvb.rvbud10,l_rvb.rvbud11,l_rvb.rvbud12,
        l_rvb.rvbud13,l_rvb.rvbud14,l_rvb.rvbud15,l_rvb.rvb90  
     IF SQLCA.sqlcode<>0 THEN
        LET g_showmsg = l_rvb.rvb01,"/",l_rvb.rvb02 
        CALL s_errmsg('rvb01,rvb02',g_showmsg,'ins rvb:',SQLCA.sqlcode,1) 
        LET g_success = 'N'
     ELSE
        IF NOT s_industry('std') THEN
           INITIALIZE l_rvbi.* TO NULL
           LET l_rvbi.rvbi01 = l_rvb.rvb01
           LET l_rvbi.rvbi02 = l_rvb.rvb02
           IF NOT s_ins_rvbi(l_rvbi.*,s_plant_new) THEN 
              LET g_success = 'N'
           END IF
        END IF
     END IF
  
     LET l_sql2 = "SELECT ima918,ima921 FROM ",cl_get_target_table(s_plant_new,'ima_file'), #TQC-B90240
                  " WHERE ima01 = '",l_rvb.rvb05,"'",
                  "   AND imaacti = 'Y'"
 
     CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2 
     CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2 
     PREPARE ima_rvb2 FROM l_sql2
 
     EXECUTE ima_rvb2 INTO g_ima918,g_ima921                                                                             
     
     IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
        IF l_sma90 = "Y" THEN
           IF g_sma.sma115 = 'Y' THEN 
              LET l_sql1 = " SELECT rvbs_file.* FROM rvbs_file,ogg_file ",
                           "  WHERE rvbs01 = ogg01 ",
                           "    AND rvbs02 = ogg03 ",
                           "    AND rvbs13 = ogg18 ",
                           "    AND rvbs01 ='",g_oga.oga01,"'",
                           "    AND rvbs02 =",g_ogb.ogb03,
                           "    AND ogg092 ='",l_ogc.ogc092,"'"
           ELSE 
              LET l_sql1 = " SELECT rvbs_file.* FROM rvbs_file,ogc_file ",
                           "  WHERE rvbs01 = ogc01 ",
                           "    AND rvbs02 = ogc03 ",
                           "    AND rvbs13 = ogc18 ",
                           "    AND rvbs01 ='",g_oga.oga01,"'",
                           "    AND rvbs02 =",g_ogb.ogb03,
                           "    AND ogc092 ='",l_ogc.ogc092,"'"
           END IF  
           DECLARE p820_g_rvbs1 CURSOR FROM l_sql1
  
           LET l_cnt = 0 
           FOREACH p820_g_rvbs1 INTO l_rvbs.*
              IF STATUS THEN
                 CALL cl_err('rvbs',STATUS,1)
              END IF
 
              LET l_rvbs.rvbs00 = "apmt300"
         
              LET l_rvbs.rvbs01 = l_rvb.rvb01
              LET l_rvbs.rvbs02 = l_rvb.rvb02

              LET l_cnt = l_cnt + 1      
              LET l_rvbs.rvbs022 = l_cnt 

              LET l_rvbs.rvbs09 = 1
 
              IF cl_null(l_rvbs.rvbs06) THEN
                 LET l_rvbs.rvbs06 = 0
              END IF
              LET l_rvbs.rvbs13 = 0
            
              #新增批/序號資料檔
             #EXECUTE ins_rvbs USING l_rvbs.rvbs00,l_rvbs.rvbs01,l_rvbs.rvbs02,  #FUN-C80001 mark
              EXECUTE ins_rvbs1 USING l_rvbs.rvbs00,l_rvbs.rvbs01,l_rvbs.rvbs02, #FUN-C80001 add
                                     l_rvbs.rvbs021,l_rvbs.rvbs022,l_rvbs.rvbs03,
                                     l_rvbs.rvbs04,l_rvbs.rvbs05,l_rvbs.rvbs06,
                                     l_rvbs.rvbs07,l_rvbs.rvbs08,l_rvbs.rvbs09,
                                    #gp_plant,gp_legal   #FUN-C80001 mark 
                                     sp_plant,sp_legal   #FUN-C80001 add
                                    ,l_rvbs.rvbs13       
      
              IF STATUS OR SQLCA.SQLCODE THEN
                 LET g_showmsg = l_rvbs.rvbs01,"/",l_rvbs.rvbs03
                 CALL s_errmsg('rvbs01,rvbs03',g_showmsg,'ins rvbs:',SQLCA.sqlcode,1) 
                 LET g_success='N'
              END IF
         
              CALL p820_imgs(l_rvb.rvb36,l_rvb.rvb37,l_rvb.rvb38,l_rva.rva06,l_rvbs.*,p_i)	#FUN-C80001
           END FOREACH
        END IF
     END IF

     IF s_industry('icd') THEN 
        IF s_icdbin_multi(l_rvb.rvb05,s_plant_new) THEN 
           
           FOREACH p820_g_idd1 USING l_rvb.rvb38 INTO l_idd.idd04,l_idd.idd05,l_idd.idd06

              OPEN p820_g_idd2 USING l_idd.idd04,l_idd.idd05,l_idd.idd06
              FETCH p820_g_idd2 INTO l_idd.*
              CLOSE p820_g_idd2
              
              SELECT SUM(idd13),SUM(idd18),SUM(idd19)
                INTO l_idd.idd13,l_idd.idd18,l_idd.idd19
                FROM idd_file
               WHERE idd10 = g_oga.oga01
                 AND idd11 = g_ogb.ogb03 
                 AND idd04 = l_idd.idd04
                 AND idd05 = l_idd.idd05
                 AND idd06 = l_idd.idd06
                    
              LET l_idd.idd10 = l_rvb.rvb01
              LET l_idd.idd11 = l_rvb.rvb02
              LET l_idd.idd02 = l_rvb.rvb36
              LET l_idd.idd03 = l_rvb.rvb37
              #LET l_idd.idd04 = l_rvb.rvb38
              CALL icd_ida(1,l_idd.*,s_plant_new) 
           END FOREACH 
        END IF
        LET l_sql1 = "SELECT rvbiicd08,rvbiicd16 FROM ",cl_get_target_table(s_plant_new,'rvbi_file'),  #TQC-B90240
                     " WHERE rvbi01 = '",l_rvb.rvb01,"'",
                     "   AND rvbi02 =  ",l_rvb.rvb02
        CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1
        CALL cl_parse_qry_sql(l_sql1,s_plant_new) RETURNING l_sql1   
        PREPARE p820_rvbi2 FROM l_sql1
        EXECUTE p820_rvbi2 INTO l_rvbiicd08,l_rvbiicd16
        CALL s_icdpost(13,l_rvb.rvb05,l_rvb.rvb36,l_rvb.rvb37,l_rvb.rvb38,g_pmn.pmn07,l_rvb.rvb07,l_rvb.rvb01,l_rvb.rvb02,
                       l_rva.rva06,'Y','','',l_rvbiicd16,l_rvbiicd08,s_plant_new)   
             RETURNING l_flag1
        IF l_flag1 = 0 THEN
           LET g_success = 'N'
        END IF   
     END IF

     CALL p820_log(l_rvb.rvb05,l_rvb.rvb36,l_rvb.rvb37,l_rvb.rvb38,
                   l_rvb.rvb07,'2',s_plant_new,p_i,'S',l_rvb.rvb85) 
 
     CALL p820_rvvins(p_i)

     IF p_i = 1 THEN
        CALL p820_log(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,
                      l_rvv.rvv34,l_rvv.rvv17,'1',s_plant_new,0,'S',l_rvv.rvv85) 
     END IF

     CALL p820_log(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                   l_rvv.rvv17,'3',s_plant_new,p_i,'S',l_rvv.rvv85) 
  END FOREACH 
END FUNCTION
#FUN-C80001---end
FUNCTION p820_rvuins()
 #DEFINE l_sql  LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1200)   #CHI-940042 mark
 #DEFINE l_sql1 LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(600)    #CHI-940042 mark
 #DEFINE l_sql2 LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1600)   #CHI-940042 mark
  DEFINE l_sql,l_sql1,l_sql2 STRING    #CHI-940042        
  DEFINE i,l_i  LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE l_cmd  LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(100)
  DEFINE li_result LIKE type_file.num5 #TQC-9B0013
 
  #新增入庫單單頭檔(rvu_file)
    LET l_rvu.rvu00 = '1'                #異動別
        CALL s_auto_assign_no("apm",rvu_t1,g_oga.oga02,"","rvu_file","rvu01",s_plant_new,"","") #NO.FUN-620024 #FUN-980092 add
        RETURNING li_result,l_rvu.rvu01
        IF (NOT li_result) THEN 
           LET g_msg = s_plant_new CLIPPED,l_rvu.rvu01
           CALL s_errmsg("rvu01",l_rvu.rvu01,g_msg CLIPPED,"mfg3046",1) 
           LET g_success ='N'
           RETURN
        END IF   
    LET l_rvu.rvu02 = l_rva.rva01        #驗收單號
    LET l_rvu.rvu03 = g_oga.oga02        #異動日期
    LET l_rvu.rvu04 = g_pmm.pmm09        #廠商編號
    #廠商簡稱
    LET l_cmd = " SELECT pmc03 ",
                #" FROM ",s_dbs_new CLIPPED," pmc_file",
                " FROM ",cl_get_target_table(s_plant_new,'pmc_file'), #FUN-A50102
                " WHERE pmc01='",l_rvu.rvu04,"'"
 	 CALL cl_replace_sqldb(l_cmd) RETURNING l_cmd        #FUN-920032
     CALL cl_parse_qry_sql(l_cmd,s_plant_new) RETURNING l_cmd #FUN-A50102
    PREPARE pmc_pre FROM l_cmd
    DECLARE pmc_c1 CURSOR FOR pmc_pre
    OPEN pmc_c1
    FETCH pmc_c1 INTO l_rvu.rvu05
    CLOSE pmc_c1
       
    LET l_rvu.rvu06 = g_pmm.pmm13        #採購部門
    LET l_rvu.rvu07 = g_pmm.pmm15        #人員
    LET l_rvu.rvu08 = g_pmm.pmm02        #採購性質
    LET l_rvu.rvu09 = null
    LET l_rvu.rvu11 = null
    LET l_rvu.rvu12 = null
    LET l_rvu.rvu20 = 'Y'                #已拋轉 no.4475
    LET l_rvu.rvu99 = g_flow99           #No.7993
    LET l_rvu.rvuconf= 'Y'
    LET l_rvu.rvuacti= 'Y'
    LET l_rvu.rvu17  = '1'               #簽核狀況:1.已核准  #FUN-AB0023 add
    LET l_rvu.rvumksg= 'N'               #是否簽核           #FUN-AB0023 add
    LET l_rvu.rvuuser= g_user
    LET l_rvu.rvugrup= g_grup
    LET l_rvu.rvumodu= null
    LET l_rvu.rvudate= null
    LET l_rvu.rvuud01= l_rva.rvaud01
    LET l_rvu.rvuud02= l_rva.rvaud02
    LET l_rvu.rvuud03= l_rva.rvaud03
    LET l_rvu.rvuud04= l_rva.rvaud04
    LET l_rvu.rvuud05= l_rva.rvaud05
    LET l_rvu.rvuud06= l_rva.rvaud06
    LET l_rvu.rvuud07= l_rva.rvaud07
    LET l_rvu.rvuud08= l_rva.rvaud08
    LET l_rvu.rvuud09= l_rva.rvaud09
    LET l_rvu.rvuud10= l_rva.rvaud10
    LET l_rvu.rvuud11= l_rva.rvaud11
    LET l_rvu.rvuud12= l_rva.rvaud12
    LET l_rvu.rvuud13= l_rva.rvaud13
    LET l_rvu.rvuud14= l_rva.rvaud14
    LET l_rvu.rvuud15= l_rva.rvaud15
    LET l_rvu.rvu27  = '1'            #TQC-B60065
    #新增入庫單頭
     #LET l_sql="INSERT INTO ",s_dbs_tra CLIPPED,"rvu_file",  #FUN-980092 add
     LET l_sql="INSERT INTO ",cl_get_target_table(s_plant_new,'rvu_file'), #FUN-A50102
      "(rvu00  ,rvu01  ,rvu02  ,rvu03  ,rvu04  ,",
      " rvu05  ,rvu06  ,rvu07  ,rvu08  ,rvu09  ,",
      " rvu10  ,rvu11  ,rvu12  ,rvu13  ,rvu14  ,",
      " rvu15  ,rvu20  ,rvu99  ,rvuconf,rvuacti,",   #No.7993
      " rvu17  ,rvumksg,",                           #FUN-AB0023 add
      " rvu27  ,",                                   #TQC-B60065
      " rvuuser,rvugrup,rvumodu,rvudate,",
      " rvuplant,rvulegal, ",
      " rvuud01,rvuud02,rvuud03,rvuud04,rvuud05,",
      " rvuud06,rvuud07,rvuud08,rvuud09,rvuud10,",
      " rvuud11,rvuud12,rvuud13,rvuud14,rvuud15,rvuoriu,rvuorig)", #FUN-A10036
      " VALUES( ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,",
      "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,?,",  #No.CHI-950020
      "         ?,?,?,?,?,  ?,?,?,?,  ?,?,?,?,?)"       #No.7993 #FUN-980010 ##FUN-A10036 #TQC-B60065 Add ?
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,s_plant_new) RETURNING l_sql #FUN-A50102
     PREPARE ins_rvu FROM l_sql
     EXECUTE ins_rvu USING 
         l_rvu.rvu00,l_rvu.rvu01,l_rvu.rvu02,l_rvu.rvu03,l_rvu.rvu04,
         l_rvu.rvu05,l_rvu.rvu06,l_rvu.rvu07,l_rvu.rvu08,l_rvu.rvu09,
         l_rvu.rvu10,l_rvu.rvu11,l_rvu.rvu12,l_rvu.rvu13,l_rvu.rvu14,
         l_rvu.rvu15,l_rvu.rvu20,l_rvu.rvu99,l_rvu.rvuconf,l_rvu.rvuacti,#7993
         l_rvu.rvu17,l_rvu.rvumksg,                                      #FUN-AB0023 add
         l_rvu.rvu27,                                                    #TQC-B60065
         l_rvu.rvuuser,l_rvu.rvugrup,l_rvu.rvumodu,l_rvu.rvudate,
         sp_plant,sp_legal   #FUN-980010
        ,l_rvu.rvuud01,l_rvu.rvuud02,l_rvu.rvuud03,
         l_rvu.rvuud04,l_rvu.rvuud05,l_rvu.rvuud06,
         l_rvu.rvuud07,l_rvu.rvuud08,l_rvu.rvuud09,
         l_rvu.rvuud10,l_rvu.rvuud11,l_rvu.rvuud12,
         l_rvu.rvuud13,l_rvu.rvuud14,l_rvu.rvuud15,g_user,g_grup  #FUN-A10036
     IF SQLCA.sqlcode<>0 THEN
        CALL s_errmsg('rvu01',l_rvu.rvu01,'ins rvu:',SQLCA.sqlcode,1)  #No.FUN-710046
        LET g_success = 'N'
     END IF
END FUNCTION
 
#入庫單單身檔
FUNCTION p820_rvvins(p_i)
 #DEFINE l_sql  LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1200)   #CHI-940042 mark
 #DEFINE l_sql1 LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(600)    #CHI-940042 mark
 #DEFINE l_sql2 LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1600)   #CHI-940042 mark
  DEFINE l_sql,l_sql1,l_sql2 STRING    #CHI-940042        
  DEFINE p_i    LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE l_no   LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE l_price LIKE ogb_file.ogb13
  DEFINE i,l_i   LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE l_flag  LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE l_msg   LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(80)
  DEFINE l_chr   LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
#  DEFINE l_qoh   LIKE ima_file.ima262 #FUN-A20044
  DEFINE l_qoh   LIKE type_file.num15_3 #FUN-A20044
  DEFINE l_ima86 LIKE ima_file.ima86
  DEFINE l_ima39 LIKE ima_file.ima39
  DEFINE l_ima35 LIKE ima_file.ima35
  DEFINE l_ima36 LIKE ima_file.ima36
  DEFINE l_rvvi  RECORD LIKE rvvi_file.* #NO.FUN-7B0018
  DEFINE l_oea01 LIKE oea_file.oea01  #MOD-810179 add
  DEFINE l_rvbs  RECORD LIKE rvbs_file.*  #No.FUN-850100
  DEFINE l_idd   RECORD LIKE idd_file.*            #FUN-B90012
  DEFINE l_flag1        LIKE type_file.num10       #FUN-B90012
  #DEFINE l_imaicd08     LIKE imaicd_file.imaicd08  #FUN-B90012 #FUN-BA0051 mark
  DEFINE l_rvviicd02    LIKE rvvi_file.rvviicd02   #FUN-B90012
  DEFINE l_rvviicd05    LIKE rvvi_file.rvviicd05   #FUN-B90012
  DEFINE l_cnt          LIKE type_file.num5        #CHI-C40031 add
  DEFINE l_ima29   LIKE ima_file.ima29     #CHI-C80042 add
  DEFINE l_rvu06   LIKE rvu_file.rvu06     #FUN-CB0087
  DEFINE l_rvu07   LIKE rvu_file.rvu07     #FUN-CB0087
   
     #讀取收貨單身檔(rvb_file)
     LET l_sql1 = "SELECT * ",
                  #" FROM ",s_dbs_tra CLIPPED,"rvb_file ",   #FUN-980092 add
                  " FROM ",cl_get_target_table(s_plant_new,'rvb_file'), #FUN-A50102
                  " WHERE rvb01='",l_rvb.rvb01,"' " ,
                  "  AND rvb02 =",l_rvb.rvb02
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,s_plant_new) RETURNING l_sql1 #FUN-980092
     PREPARE rvb_p1 FROM l_sql1
     IF SQLCA.SQLCODE THEN 
        LET g_showmsg = l_rvb.rvb01,"/",l_rvb.rvb02    #No.FUN-710046
        CALL s_errmsg('rvb01,rvb02',g_showmsg,'rvb_p1',SQLCA.SQLCODE,0) #No.FUN-710046
     END IF
     DECLARE rvb_c1 CURSOR FOR rvb_p1
     OPEN rvb_c1
     FETCH rvb_c1 INTO l_rvb.*
     IF SQLCA.SQLCODE <> 0 THEN
        LET g_success='N'
        RETURN
     END IF
     CLOSE rvb_c1
     #新增入庫單身檔[rvv_file]
     LET l_rvv.rvv01 = l_rvu.rvu01     #入庫單號
     LET l_rvv.rvv02 = l_rvb.rvb02     #項次
     LET l_rvv.rvv03 = '1'             #異動類別
     LET l_rvv.rvv04 = l_rvb.rvb01     #驗收單號
     LET l_rvv.rvv05 = l_rvb.rvb02     #項次
     LET l_rvv.rvv06 = g_pmm.pmm09     #廠商編號
     LET l_rvv.rvv09 = g_oga.oga02     #異動日期 
     LET l_rvv.rvv17 = l_rvb.rvb07     #數量
     LET l_rvv.rvv23 = 0               #已請款匹配量
     LET l_rvv.rvv88 = 0               #暫估數量  #No.TQC-7B0083
     #-----MOD-A90029---------
     #LET l_rvv.rvv25 = 'N'             #樣品否
     IF g_oay11 = 'Y' THEN
        LET l_rvv.rvv25 = 'N'
     ELSE 
        LET l_rvv.rvv25 = 'Y'
     END IF
     #-----END MOD-A90029-----
     LET l_rvv.rvv31 = l_rvb.rvb05     #料件編號
     CALL p820_ima(l_rvv.rvv31,s_plant_new) #FUN-980092 add
       RETURNING l_rvv.rvv031,l_rvv.rvv35,l_qoh,l_ima86,l_ima39,
                 l_ima35,l_ima36
     LET l_rvv.rvv32 = l_rvb.rvb36     #倉庫
     LET l_rvv.rvv33 = l_rvb.rvb37     #儲   
     LET l_rvv.rvv34 = l_rvb.rvb38     #批
     LET l_rvv.rvv80 = l_rvb.rvb80
     LET l_rvv.rvv81 = l_rvb.rvb81
     LET l_rvv.rvv82 = l_rvb.rvb82
     LET l_rvv.rvv83 = l_rvb.rvb83
     LET l_rvv.rvv84 = l_rvb.rvb84
     LET l_rvv.rvv85 = l_rvb.rvb85
     LET l_rvv.rvv86 = l_rvb.rvb86
     LET l_rvv.rvv87 = l_rvb.rvb87
     CALL s_umfchkm(l_rvb.rvb05,g_ogb.ogb05,l_rvv.rvv35,s_plant_new) #FUN-980092 add
     RETURNING l_flag,l_rvv.rvv35_fac
     LET l_rvv.rvv35 = g_ogb.ogb05
     LET l_rvv.rvv17 = s_digqty(l_rvv.rvv17,l_rvv.rvv35)   #FUN-BB0084
 
     LET l_rvv.rvv36 = g_pmn.pmn01     #採購單號
     LET l_rvv.rvv37 = g_pmn.pmn02     #採購序號
 
     #倉庫,單位,轉換率來自同一站的出貨單
     LET l_sql1 = "SELECT oea01 ",
                  #" FROM ",s_dbs_tra CLIPPED,"pmm_file, ",   #FUN-980092 add
                  #         s_dbs_tra CLIPPED,"oea_file ",    #FUN-980092 add
                  " FROM ",cl_get_target_table(s_plant_new,'pmm_file'),",", #FUN-A50102
                           cl_get_target_table(s_plant_new,'oea_file'), #FUN-A50102
                  " WHERE pmm01='",l_rvv.rvv36,"' ",
                  "   AND oea99 = pmm99 "
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,s_plant_new) RETURNING l_sql1 #FUN-980092
     PREPARE oea01_p1 FROM l_sql1
     IF SQLCA.SQLCODE THEN CALL cl_err('oea01_p1',SQLCA.SQLCODE,1) END IF
     DECLARE oea01_c1 CURSOR FOR oea01_p1
     OPEN oea01_c1
     FETCH oea01_c1 INTO l_oea01
     IF SQLCA.SQLCODE <> 0 THEN
        LET g_success='N'
        RETURN
     END IF
     CLOSE oea01_c1
 
     LET l_sql1 = "SELECT ogb15_fac ",
                  #" FROM ",s_dbs_tra CLIPPED,"ogb_file ",  #FUN-980092 add
                  " FROM ",cl_get_target_table(s_plant_new,'ogb_file'), #FUN-A50102
                  " WHERE ogb31 ='",l_oea01,"'  ",
                  "   AND ogb32 ='",l_rvv.rvv37,"' "
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,s_plant_new) RETURNING l_sql1 #FUN-980092
     PREPARE ogb_p1 FROM l_sql1
     IF SQLCA.SQLCODE THEN CALL cl_err('ogb_p1',SQLCA.SQLCODE,1) END IF
     DECLARE ogb_c1 CURSOR FOR ogb_p1
     OPEN ogb_c1
     FETCH ogb_c1 INTO l_rvv.rvv35_fac
     IF SQLCA.SQLCODE <> 0 THEN
        LET g_success='N'
        RETURN
     END IF
     CLOSE ogb_c1
          
 
     LET l_rvv.rvv38 = l_rvb.rvb10     #單價
     LET l_rvv.rvv38t= l_rvb.rvb10t                                   #NO.FUN-620024
     CALL cl_digcut(l_rvv.rvv38,l_azi.azi03) RETURNING l_rvv.rvv38
     CALL cl_digcut(l_rvv.rvv38t,l_azi.azi03) RETURNING l_rvv.rvv38t  #NO.FUN-620024 
     #LET l_rvv.rvv39 = l_rvv.rvv38 * l_rvv.rvv87   #金額  #No.TQC-6A0084 #TQC-D40097 mark
     #LET l_rvv.rvv39t= l_rvv.rvv38t * l_rvv.rvv87                     #NO.FUN-620024   #No.TQC-6A0084 #TQC-D40097 mark
     LET l_rvv.rvv39 = l_rvb.rvb88  #TQC-D40097 add
     LET l_rvv.rvv39t = l_rvb.rvb88t  #TQC-D40097 add 
     CALL cl_digcut(l_rvv.rvv39,l_azi.azi04) RETURNING l_rvv.rvv39
     CALL cl_digcut(l_rvv.rvv39t,l_azi.azi04) RETURNING l_rvv.rvv39t  #NO.FUN-620024
     LET l_rvv.rvvud01= l_rvb.rvbud01
     LET l_rvv.rvvud02= l_rvb.rvbud02
     LET l_rvv.rvvud03= l_rvb.rvbud03
     LET l_rvv.rvvud04= l_rvb.rvbud04
     LET l_rvv.rvvud05= l_rvb.rvbud05
     LET l_rvv.rvvud06= l_rvb.rvbud06
     LET l_rvv.rvvud07= l_rvb.rvbud07
     LET l_rvv.rvvud08= l_rvb.rvbud08
     LET l_rvv.rvvud09= l_rvb.rvbud09
     LET l_rvv.rvvud10= l_rvb.rvbud10
     LET l_rvv.rvvud11= l_rvb.rvbud11
     LET l_rvv.rvvud12= l_rvb.rvbud12
     LET l_rvv.rvvud13= l_rvb.rvbud13
     LET l_rvv.rvvud14= l_rvb.rvbud14
     LET l_rvv.rvvud15= l_rvb.rvbud15
      LET l_rvv.rvv930 = g_pmn.pmn930 #MOD-920261 add 
      LET l_rvv.rvv89 = 'N'           #FUN-940083 add 
     IF cl_null(l_rvv.rvv02) THEN LET l_rvv.rvv02 = 1 END IF  #no.TQC-790003
     #流通代銷無收貨單,將發票記錄rvb22同時新增到rvv22內
     LET l_rvv.rvv22 = l_rvb.rvb22      #FUN-BB0001 add
     #TQC-D20067---add---str---
     LET l_rvv.rvv26 = ''
     IF cl_null(l_rvv.rvv26) THEN LET l_rvv.rvv26 = g_poy.poy30 END IF  #TQC-D40064 add
     #LET l_sql2 = "SELECT aza115 FROM ",cl_get_target_table(l_plant_new,'aza_file')," WHERE aza01 = '0' " #TQC-D30004 mark
     LET l_sql2 = "SELECT aza115 FROM ",cl_get_target_table(s_plant_new,'aza_file')," WHERE aza01 = '0' "  #TQC-D30004
     PREPARE aza115_pr5 FROM l_sql2
     EXECUTE aza115_pr5 INTO g_aza.aza115
     #TQC-D20067---add---end---
     #FUN-CB0087--add--str--
#    IF l_aza.aza115 ='Y' THEN         #TQC-D20067 mark
     IF g_aza.aza115 ='Y' THEN         #TQC-D20067 add
        IF cl_null(l_rvv.rvv26) THEN   #TQC-D20067 mark #TQC-D40064 remark
          #SELECT rvu06,rvu07 INTO l_rvu06,l_rvu07 FROM rvu_file WHERE rvu01 = l_rvv.rvv01
           #TQC-D20042--add--str--
           LET l_sql2= "SELECT rvu06,rvu07 FROM ",cl_get_target_table(s_plant_new,'rvu_file')," WHERE rvu01 ='",l_rvv.rvv01,"'"
           PREPARE rvv26_pr2 FROM l_sql2
           EXECUTE rvv26_pr2 INTO l_rvu06,l_rvu07
           #TQC-D20042--add--end--
          #CALL s_reason_code(l_rvv.rvv01,l_rvv.rvv04,'',l_rvv.rvv31,l_rvv.rvv32,l_rvu07,l_rvu06) RETURNING l_rvv.rvv26   #TQC-D20042 mark
           CALL s_reason_code1(l_rvv.rvv01,l_rvv.rvv04,'',l_rvv.rvv31,l_rvv.rvv32,l_rvu07,l_rvu06,s_plant_new) RETURNING l_rvv.rvv26  #TQC-D20042
           IF cl_null(l_rvv.rvv26) THEN
              #CALL cl_err(l_rvv.rvv26,'aim-425',1)   #QTC-D20047
              LET g_showmsg = s_plant_new,"/",l_rvv.rvv01                #TQC-D20047       
              CALL s_errmsg('rvu01',g_showmsg,'up rvv26:','aim-425',1)   #TQC-D20047
              LET g_success="N"
              RETURN
           END IF
        END IF  #TQC-D20067 mark  #TQC-D40064 remark
     END IF
     #FUN-CB0087--add--end--
     #新增入庫單身檔
     #LET l_sql2="INSERT INTO ",s_dbs_tra CLIPPED,"rvv_file",  #FUN-980092 add
     LET l_sql2="INSERT INTO ",cl_get_target_table(s_plant_new,'rvv_file'), #FUN-A50102
      "(rvv01,rvv02,rvv03,rvv04,rvv05, ",
      " rvv06,rvv09,rvv17,rvv18,rvv23, ",
      " rvv24,rvv25,rvv26,rvv31,rvv031, ",
      " rvv32,rvv33,rvv34,rvv35,rvv35_fac,",
      " rvv36,rvv37,rvv38,rvv39,rvv40, ",
      " rvv41,rvv42,rvv43,rvv80,rvv81,rvv82,",   #FUN-560043
      " rvv83,rvv84,rvv85,rvv86,rvv87,rvv38t,rvv39t,rvv88,rvv930,rvv89,",   #NO.FUN-620024  #No.TQC-7B0083  #MOD-920261 add rvv930 #FUN-940083 add rvv89
      " rvvplant,rvvlegal , ",
      " rvvud01,rvvud02,rvvud03,rvvud04,rvvud05,",
      " rvvud06,rvvud07,rvvud08,rvvud09,rvvud10,",
      " rvvud11,rvvud12,rvvud13,rvvud14,rvvud15,",
      " rvv22 )",          #FUN-BB0001 add rvv22 
      " VALUES( ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
      "         ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",    #No.CHI-950020
      "         ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?) "      #NO.FUN-620024  #No.TQC-7B0083  #MOD-920261 add ? #FUN-940083 #FUN-980010   #FUN-BB0001 add ?
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2 #FUN-A50102
     PREPARE ins_rvv FROM l_sql2
     EXECUTE ins_rvv USING 
       l_rvv.rvv01,l_rvv.rvv02,l_rvv.rvv03,l_rvv.rvv04,l_rvv.rvv05,
       l_rvv.rvv06,l_rvv.rvv09,l_rvv.rvv17,l_rvv.rvv18,l_rvv.rvv23,
       l_rvv.rvv24,l_rvv.rvv25,l_rvv.rvv26,l_rvv.rvv31,l_rvv.rvv031,
       l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,l_rvv.rvv35,l_rvv.rvv35_fac,
       l_rvv.rvv36,l_rvv.rvv37,l_rvv.rvv38,l_rvv.rvv39,l_rvv.rvv40,
       l_rvv.rvv41,l_rvv.rvv42,l_rvv.rvv43,l_rvv.rvv80,l_rvv.rvv81,   #FUN-560043
       l_rvv.rvv82,l_rvv.rvv83,l_rvv.rvv84,l_rvv.rvv85,l_rvv.rvv86,   #FUN-560043
       l_rvv.rvv87,l_rvv.rvv38t,l_rvv.rvv39t,l_rvv.rvv88,l_rvv.rvv930, #NO.FUN-620024  #No.TQC-7B0083  #MOD-920261 add rvv930
       l_rvv.rvv89,                                                    #NO.FUN-940083 add
       sp_plant,sp_legal   #FUN-980010
      ,l_rvv.rvvud01,l_rvv.rvvud02,l_rvv.rvvud03,
       l_rvv.rvvud04,l_rvv.rvvud05,l_rvv.rvvud06,
       l_rvv.rvvud07,l_rvv.rvvud08,l_rvv.rvvud09,
       l_rvv.rvvud10,l_rvv.rvvud11,l_rvv.rvvud12,
       l_rvv.rvvud13,l_rvv.rvvud14,l_rvv.rvvud15,
       l_rvv.rvv22           #FUN-BB0001 add
     IF SQLCA.sqlcode<>0 THEN
        LET g_showmsg = l_rvv.rvv01,"/",l_rvv.rvv02      #No.FUN-710046
        CALL s_errmsg('rvv01,rvv02',g_showmsg,'ins rvv:',SQLCA.sqlcode,1) #No.FUN-710046
        LET g_success = 'N'
     ELSE
        IF NOT s_industry('std') THEN
           INITIALIZE l_rvvi.* TO NULL
           LET l_rvvi.rvvi01 = l_rvv.rvv01
           LET l_rvvi.rvvi02 = l_rvv.rvv02
           IF NOT s_ins_rvvi(l_rvvi.*,s_plant_new) THEN #FUN-980092 add
              LET g_success = 'N'
           END IF
        END IF
     END IF
 
   #LET l_sql2 = "SELECT ima918,ima921 FROM ",l_dbs_new CLIPPED,"ima_file",
#  LET l_sql2 = "SELECT ima918,ima921 FROM ",cl_get_target_table(l_plant_new,'ima_file'), #FUN-A50102  #TQC-B90240
   LET l_sql2 = "SELECT ima918,ima921 FROM ",cl_get_target_table(s_plant_new,'ima_file'), #TQC-B90240
                " WHERE ima01 = '",l_rvv.rvv31,"'",
                "   AND imaacti = 'Y'"
 
   CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
#  CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102   #TQC-B90240
   CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2 #TQC-B90240
   PREPARE ima_rvv FROM l_sql2
 
   EXECUTE ima_rvv INTO g_ima918,g_ima921                                                                             
     
   IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
      
      LET l_cnt = 0 #CHI-C40031 add
      #FUN-C80001---begin
     #IF g_sma.sma96 = 'Y' THEN  #FUN-D30099 mark
      IF g_pod.pod08 = 'Y' THEN  #FUN-D30099
         IF g_sma.sma115 = 'Y' THEN 
            LET l_sql1 = " SELECT rvbs_file.* FROM rvbs_file,ogg_file ",
                         "  WHERE rvbs01 = ogg01 ",
                         "    AND rvbs02 = ogg03 ",
                         "    AND rvbs13 = ogg18 ",
                         "    AND rvbs01 ='",g_oga.oga01,"'",
                         "    AND rvbs02 =",g_ogb.ogb03,
                         "    AND ogg092 ='",l_rvv.rvv34,"'"
         ELSE 
            LET l_sql1 = " SELECT rvbs_file.* FROM rvbs_file,ogc_file ",
                         "  WHERE rvbs01 = ogc01 ",
                         "    AND rvbs02 = ogc03 ",
                         "    AND rvbs13 = ogc18 ",
                         "    AND rvbs01 ='",g_oga.oga01,"'",
                         "    AND rvbs02 =",g_ogb.ogb03,
                         "    AND ogc092 ='",l_rvv.rvv34,"'"
         END IF  
         DECLARE p820_g_rvbs2 CURSOR FROM l_sql1
    
         FOREACH p820_g_rvbs2 INTO l_rvbs.*
            IF STATUS THEN
               CALL cl_err('rvbs',STATUS,1)
            END IF
 
            LET l_rvbs.rvbs00 = "apmt740"
      
            LET l_rvbs.rvbs01 = l_rvv.rvv01
            LET l_rvbs.rvbs02 = l_rvv.rvv02

            LET l_cnt = l_cnt + 1      
            LET l_rvbs.rvbs022 = l_cnt 
      
            LET l_rvbs.rvbs06 = l_rvbs.rvbs06 * l_rvv.rvv35_fac
 
            LET l_rvbs.rvbs09 = 1
 
            IF cl_null(l_rvbs.rvbs06) THEN
               LET l_rvbs.rvbs06 = 0
            END IF
            LET l_rvbs.rvbs13=0                

         #新增批/序號資料檔
           #EXECUTE ins_rvbs USING l_rvbs.rvbs00,l_rvbs.rvbs01,l_rvbs.rvbs02,  #FUN-C80001 mark
            EXECUTE ins_rvbs1 USING l_rvbs.rvbs00,l_rvbs.rvbs01,l_rvbs.rvbs02, #FUN-C80001 add
                                   l_rvbs.rvbs021,l_rvbs.rvbs022,l_rvbs.rvbs03,
                                   l_rvbs.rvbs04,l_rvbs.rvbs05,l_rvbs.rvbs06,
                                   l_rvbs.rvbs07,l_rvbs.rvbs08,l_rvbs.rvbs09,
                                  #gp_plant,gp_legal   #FUN-C80001 mark 
                                   sp_plant,sp_legal   #FUN-C80001 add
                                  ,l_rvbs.rvbs13      
 
            IF STATUS OR SQLCA.SQLCODE THEN
               LET g_showmsg = l_rvbs.rvbs01,"/",l_rvbs.rvbs03
               CALL s_errmsg('rvbs01,rvbs03',g_showmsg,'ins rvbs:',SQLCA.sqlcode,1) 
               LET g_success='N'
            END IF
            IF p_i = 1 THEN
               CALL p820_imgs(l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,l_rvu.rvu03,l_rvbs.*,0)
            ELSE 
               CALL p820_imgs(l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,l_rvu.rvu03,l_rvbs.*,p_i)
            END IF 
         END FOREACH
      ELSE 
      #FUN-C80001---end
         FOREACH p820_g_rvbs INTO l_rvbs.*
            IF STATUS THEN
               CALL cl_err('rvbs',STATUS,1)
            END IF
 
            LET l_rvbs.rvbs00 = "apmt740"
      
            LET l_rvbs.rvbs01 = l_rvv.rvv01

            LET l_cnt = l_cnt + 1      #CHI-C40031 add
            LET l_rvbs.rvbs022 = l_cnt #CHI-C40031 add
      
            LET l_rvbs.rvbs06 = l_rvbs.rvbs06 * l_rvv.rvv35_fac
 
            LET l_rvbs.rvbs09 = 1
 
            IF cl_null(l_rvbs.rvbs06) THEN
               LET l_rvbs.rvbs06 = 0
            END IF
            LET l_rvbs.rvbs13=0                 #No.CHI-990031

         #新增批/序號資料檔
           #EXECUTE ins_rvbs USING l_rvbs.rvbs00,l_rvbs.rvbs01,l_rvbs.rvbs02, #FUN-C80001 mark
            EXECUTE ins_rvbs USING l_rvbs.rvbs00,l_rvbs.rvbs01,l_rvbs.rvbs02, #FUN-C80001 add
                                   l_rvbs.rvbs021,l_rvbs.rvbs022,l_rvbs.rvbs03,
                                   l_rvbs.rvbs04,l_rvbs.rvbs05,l_rvbs.rvbs06,
                                   l_rvbs.rvbs07,l_rvbs.rvbs08,l_rvbs.rvbs09,
                                  #gp_plant,gp_legal   #FUN-980010 #FUN-C80001 mark
                                   sp_plant,sp_legal   #FUN-C80001 add
                                  ,l_rvbs.rvbs13       #No.CHI-990031 add rvbs13
 
            IF STATUS OR SQLCA.SQLCODE THEN
               LET g_showmsg = l_rvbs.rvbs01,"/",l_rvbs.rvbs03
               CALL s_errmsg('rvbs01,rvbs03',g_showmsg,'ins rvbs:',SQLCA.sqlcode,1) 
               LET g_success='N'
            END IF
            #FUN-C80001---begin
            IF p_i = 1 THEN
               CALL p820_imgs(l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,l_rvu.rvu03,l_rvbs.*,0)
            ELSE 
            #FUN-C80001
               CALL p820_imgs(l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,l_rvu.rvu03,l_rvbs.*,p_i)	#MOD-980058 #FUN-C80001
            END IF  #FUN-C80001
         END FOREACH
      END IF  #FUN-C80001
   END IF
 
#FUN-B90012 ---------------------Begin-------------------------
   IF s_industry('icd') THEN
   #  LET l_sql2 = "SELECT imaicd08 FROM ",cl_get_target_table(l_plant_new,'imaicd_file'),",",  #TQC-B90240
   #                                       cl_get_target_table(l_plant_new,'ima_file'),         #TQC-B90240
      #FUN-BA0051 --START mark--
      #LET l_sql2 = "SELECT imaicd08 FROM ",cl_get_target_table(s_plant_new,'imaicd_file'),",",    #TQC-B90240
      #                                     cl_get_target_table(s_plant_new,'ima_file'),           #TQC-B90240
      #             " WHERE imaicd00 = '",l_rvv.rvv31,"'",
      #             "   AND ima01 = imaicd00 ",
      #             "   AND imaacti = 'Y'"
      #          
      #CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        
      ##CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2   #TQC-B90240
      #CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2   #TQC-B90240 
      #PREPARE p820_rvv_imaicd08 FROM l_sql2 
      # 
      #EXECUTE p820_rvv_imaicd08 INTO l_imaicd08 
      # 
      #IF l_imaicd08 = 'Y' THEN
      #FUN-BA0051 --END mark--
      IF s_icdbin_multi(l_rvv.rvv31,s_plant_new) THEN   #FUN-BA0051
         #FUN-C80001---begin
        #IF g_ogb.ogb17 = 'Y' AND g_sma.sma96 = 'Y' THEN  #FUN-D30099 mark
         IF g_ogb.ogb17 = 'Y' AND g_pod.pod08 = 'Y' THEN  #FUN-D30099
           FOREACH p820_g_idd1 USING l_rvv.rvv34 INTO l_idd.idd04,l_idd.idd05,l_idd.idd06
           
              OPEN p820_g_idd2 USING l_idd.idd04,l_idd.idd05,l_idd.idd06
              FETCH p820_g_idd2 INTO l_idd.*
              CLOSE p820_g_idd2
              
              SELECT SUM(idd13),SUM(idd18),SUM(idd19)
                INTO l_idd.idd13,l_idd.idd18,l_idd.idd19
                FROM idd_file
               WHERE idd10 = g_oga.oga01
                 AND idd11 = g_ogb.ogb03 
                 AND idd04 = l_idd.idd04
                 AND idd05 = l_idd.idd05
                 AND idd06 = l_idd.idd06
                    
              LET l_idd.idd10 = l_rvv.rvv01
              LET l_idd.idd11 = l_rvv.rvv02
              LET l_idd.idd02 = l_rvv.rvv32
              LET l_idd.idd03 = l_rvv.rvv33
              #LET l_idd.idd04 = l_rvv.rvv34
              CALL icd_ida(1,l_idd.*,s_plant_new) 
           END FOREACH 
         ELSE        
         #FUN-C80001---end
            FOREACH p820_g_idd INTO l_idd.*
               LET l_idd.idd10 = l_rvv.rvv01
               LET l_idd.idd11 = l_rvv.rvv02
            #CHI-C80009---add---START
               LET l_idd.idd02 = l_rvv.rvv32
               LET l_idd.idd03 = l_rvv.rvv33
              #IF g_sma.sma96 <> 'Y' THEN  #FUN-C80001 #FUN-D30099 mark
               IF g_pod.pod08 <> 'Y' THEN  #FUN-D30099 
                  LET l_idd.idd04 = l_rvv.rvv34
               END IF  #FUN-C80001
            #CHI-C80009---add-----END
              #CALL icd_ida(1,l_idd.*,l_plant_new) #CHI-C80009 mark
               CALL icd_ida(1,l_idd.*,s_plant_new) #CHI-C80009 add
            END FOREACH
         END IF  #FUN-C80001
      END IF
   #  LET l_sql1 = "SELECT rvviicd02,rvviicd05 FROM ",cl_get_target_table(l_plant_new,'rvvi_file'),   #TQC-B90240
      LET l_sql1 = "SELECT rvviicd02,rvviicd05 FROM ",cl_get_target_table(s_plant_new,'rvvi_file'),   #TQC-B90240
                   " WHERE rvvi01 = '",l_rvv.rvv01,"'",
                   "   AND rvvi02 =  ",l_rvv.rvv02
      CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1
   #  CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1   #TQC-B90240
      CALL cl_parse_qry_sql(l_sql1,s_plant_new) RETURNING l_sql1   #TQC-B90240 
      PREPARE p820_rvvi FROM l_sql1
      EXECUTE p820_rvvi INTO l_rvviicd02,l_rvviicd05
      CALL s_icdpost(11,l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,l_rvv.rvv35,l_rvv.rvv17,l_rvv.rvv01,l_rvv.rvv02,
      #              l_rvu.rvu03,'Y',l_rvv.rvv04,l_rvv.rvv05,l_rvviicd05,l_rvviicd02,l_plant_new)  #TQC-B90240
                     l_rvu.rvu03,'Y',l_rvv.rvv04,l_rvv.rvv05,l_rvviicd05,l_rvviicd02,s_plant_new)  #TQC-B90240
           RETURNING l_flag1
      IF l_flag1 = 0 THEN
         LET g_success = 'N'
      END IF
   END IF
#FUN-B90012 ---------------------End---------------------------
     #CHI-C80042 add start -----
     #回寫最近入庫日 ima73
     LET l_sql = "SELECT ima29 FROM ",cl_get_target_table(l_plant_new,'ima_file'),
                 " WHERE ima01='",l_rvv.rvv31,"'"
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql
     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql
     PREPARE ima_p3 FROM l_sql
     IF SQLCA.SQLCODE THEN
       IF g_bgerr THEN
          CALL s_errmsg("ima01",l_rvv.rvv31,"",SQLCA.sqlcode,1)
       ELSE
          CALL cl_err3("","","","",SQLCA.sqlcode,"","",1)
       END IF
     END IF
     DECLARE ima_c3 CURSOR FOR ima_p3
     OPEN ima_c3
     FETCH ima_c3 INTO l_ima29
     #異動日期需大於原來的異動日期才可
     #必須判斷null,否則新料不會update
     IF (l_rvu.rvu03 > l_ima29 OR l_ima29 IS NULL) THEN
        LET l_sql = "UPDATE ",cl_get_target_table(l_plant_new,'ima_file'),
                    " SET ima73 = ? , ima29 = ? WHERE ima01 = ?  "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql
        CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql
        PREPARE upd_ima3 FROM l_sql
        EXECUTE upd_ima3 USING l_rvu.rvu03,l_rvu.rvu03,l_rvv.rvv31
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
           IF g_bgerr THEN
              CALL s_errmsg('ima01',l_rvv.rvv31,'upd ima',STATUS,1)
           ELSE
              CALL cl_err('upd ima:',STATUS,1)
           END IF
           LET g_success='N'
        END IF
     END IF
     #CHI-C80042 add end   -----

END FUNCTION
 
#讀取其送貨客戶資料
FUNCTION p820_oea911(l_i)
   DEFINE l_i LIKE type_file.num5    #No.FUN-680137 SMALLINT
      CASE l_i
        WHEN 1    LET p_oea911= g_oea.oea911
        WHEN 2    LET p_oea911= g_oea.oea912
        WHEN 3    LET p_oea911= g_oea.oea913
        WHEN 4    LET p_oea911= g_oea.oea914
        WHEN 5    LET p_oea911= g_oea.oea915
        WHEN 6    LET p_oea911= g_oea.oea916
      END CASE
  RETURN p_oea911
END FUNCTION
 
FUNCTION p820_ima(p_part,p_plant)
 DEFINE p_part  LIKE ima_file.ima01
 DEFINE l_ima02 LIKE ima_file.ima02
 DEFINE l_ima25 LIKE ima_file.ima25
# DEFINE l_qoh   LIKE ima_file.ima262 #FUN-A20044
 DEFINE l_qoh   LIKE type_file.num15_3 #FUN-A20044
 DEFINE l_ima86 LIKE ima_file.ima86
 DEFINE l_ima39 LIKE ima_file.ima39
 DEFINE l_ima35 LIKE ima_file.ima35
 DEFINE l_ima36 LIKE ima_file.ima36
#DEFINE l_sql1  LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(600)   #CHI-940042 mark
 DEFINE l_sql1  STRING                 #CHI-940042        
 DEFINE p_plant LIKE type_file.chr21   #No.FUN-680137 VARCHAR(21)
 DEFINE l_msg   LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(50)
 DEFINE p_dbs   LIKE azp_file.azp03    #FUN-980092 add
 DEFINE p_dbs_tra   LIKE azw_file.azw05    #FUN-980092 add
 DEFINE l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk LIKE type_file.num15_3 #FUN-A20044
     #--FUN-980092 ----GP5.2 Modify #改抓Transaction DB
     LET g_plant_new = p_plant
     #CALL s_getdbs()             #FUN-A50102
     #LET p_dbs = g_dbs_new       #FUN-A50102
     #CALL s_gettrandbs()         #FUN-A50102
     #LET p_dbs_tra = g_dbs_tra   #FUN-A50102
 
     #抓取料件相關資料
   #  LET l_sql1 = "SELECT ima02,ima25,ima261+ima262,ima86,ima39,", #FUN-A20044
     LET l_sql1 = "SELECT ima02,ima25,0,ima86,ima39,", #FUN-A20044
                  "       ima35,ima36 ",
                  #" FROM ",p_dbs CLIPPED,"ima_file ",
                  " FROM ",cl_get_target_table(g_plant_new,'ima_file'), #FUN-A50102
                  " WHERE ima01='",p_part,"' " 
     CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1              #FUN-A50102									
     CALL cl_parse_qry_sql(l_sql1,g_plant_new) RETURNING l_sql1  #FUN-A50102	             
     PREPARE ima_pre1 FROM l_sql1
     IF SQLCA.SQLCODE THEN 
        CALL s_errmsg('ima01',p_part,'ima_pre',SQLCA.SQLCODE,0) #No.FUN-710046
     END IF
     DECLARE ima_cs CURSOR FOR ima_pre1
     OPEN ima_cs
     FETCH ima_cs INTO l_ima02,l_ima25,l_qoh,l_ima86,l_ima39,l_ima35,l_ima36
     CALL s_getstock(p_part,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk #FUN-A20044
     LET l_qoh = l_unavl_stk + l_avl_stk
     IF SQLCA.SQLCODE <> 0 THEN
        LET l_msg = p_dbs,":",p_part
        CALL s_errmsg('','',l_msg,'axm-297',1)          #No.FUN-710046
        CALL s_errmsg('','','sel ima:',SQLCA.SQLCODE,1) #No.FUN-710046
        LET g_success='N'
     END IF
     CLOSE ima_cs
     RETURN l_ima02,l_ima25,l_qoh,l_ima86,l_ima39,l_ima35,l_ima36
END FUNCTION
 
FUNCTION p820_imd(p_imd01,p_plant)#FUN-980092 add
  DEFINE p_imd01   LIKE imd_file.imd01,
         l_imd11   LIKE imd_file.imd11,
         p_dbs     LIKE type_file.chr21,  #No.FUN-680137 VARCHAR(21)
        #l_sql     LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(400)   #CHI-940042 mark
         l_sql     STRING                 #CHI-940042 
  DEFINE p_plant   LIKE azp_file.azp01    #FUN-980092 add
  DEFINE p_dbs_tra LIKE azw_file.azw05    #FUN-980092 add
 
     #-- FUN-980092 ----GP5.2 Modify #改抓Transaction DB
     LET g_plant_new = p_plant
     #CALL s_getdbs()           #FUN-A50102
     #LET p_dbs = g_dbs_new     #FUN-A50102
     #CALL s_gettrandbs()       #FUN-A50102
     #LET p_dbs_tra = g_dbs_tra #FUN-A50102
 
   LET g_errno=''
   #LET l_sql="SELECT imd10,imd11,imd12,imd13,imd14,imd15  FROM ",p_dbs CLIPPED,"imd_file",  #MOD-6C0086 modify
   LET l_sql="SELECT imd10,imd11,imd12,imd13,imd14,imd15  FROM ",cl_get_target_table(g_plant_new,'imd_file'), #FUN-A50102
             " WHERE imd01 = '",p_imd01,"'",
             "   AND imd10 = 'S' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
   PREPARE imd_pre FROM l_sql
   DECLARE imd_cs CURSOR FOR imd_pre
   OPEN imd_cs
   FETCH imd_cs INTO g_imd10,g_imd11,g_imd12,g_imd13,g_imd14,g_imd15
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg4020'
        WHEN g_imd11 ='N'         LET g_errno = 'mfg6080'    #TQC-690057 modify l_imd11->g_imd11
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF NOT cl_null(g_errno) THEN
      CALL s_errmsg('','',p_dbs,g_errno,1) #No.FUN-710046
      LET g_success = 'N' 
   END IF
   CLOSE imd_cs
END FUNCTION
 
#FUNCTION p820_log(p_part,p_ware,p_loca,p_lot,p_qty,p_sta,p_plant,i,p_type)  #FUN-C80001
FUNCTION p820_log(p_part,p_ware,p_loca,p_lot,p_qty,p_sta,p_plant,i,p_type,p_qty1)
  DEFINE p_part      LIKE ima_file.ima01,       #料號
         p_ware      LIKE ogb_file.ogb09,       #倉
         p_loca      LIKE ogb_file.ogb091,      #儲
         p_lot       LIKE ogb_file.ogb092,      #批
         p_qty       LIKE ogb_file.ogb12 ,      #異動數量
         l_img       RECORD LIKE img_file.*,
         l_imgg      RECORD LIKE imgg_file.*,   #FUN-560043
         p_plant     LIKE type_file.chr21,      #No.FUN-680137 VARCHAR(21)
         p_sta       LIKE type_file.chr1,       #1.出貨單 2.驗收單 3.入庫單 #No.FUN-680137
         p_type      LIKE type_file.chr1,       #FUN-980010
         p_qty1      LIKE ogb_file.ogb12 ,      #參考數量  #FUN-C80001
         l_flag      LIKE type_file.chr1,       #No.FUN-680137 VARCHAR(1)
         l_img09     LIKE img_file.img09,       #庫存單位
         l_img10     LIKE img_file.img10,       #庫存數量
         l_img26     LIKE img_file.img26,
         l_ima39     LIKE ima_file.ima39,
         l_ima86     LIKE ima_file.ima86,
         l_ima25     LIKE ima_file.ima25,
         l_ima35     LIKE ima_file.ima35,
         l_ima36     LIKE ima_file.ima36,
       #  l_qoh       LIKE ima_file.ima262, #FUN-A20044
         l_qoh       LIKE type_file.num15_3, #FUN-A20044
         l_ima02     LIKE ima_file.ima02,
        #l_sql1      LIKE type_file.chr1000, #No.FUN-680137 VARCHAR(600)                   #CHI-940042 mark
        #l_sql2      LIKE type_file.chr1000, #No.FUN-680137 VARCHAR(1600)                  #CHI-940042 mark
        #l_sql3      LIKE type_file.chr1000, #NO.FUN-620024  #No.FUN-680137 VARCHAR(1600)  #CHI-940042 mark
         l_msg       LIKE type_file.chr1000,#No.FUN-680137 VARCHAR(50)
         l_chr       LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
         l_n,i       LIKE type_file.num5,    #No.FUN-680137 SMALLINT
         l_i,l_j     LIKE type_file.num5,    #FUN-560043  #No.FUN-680137 SMALLINT
        #l_sql4      LIKE type_file.chr1000, #FUN-560043  #No.FUN-680137 VARCHAR(600)   #CHI-940042 mark
         l_n2        LIKE type_file.num5,    #FUN-560043  #No.FUN-680137 SMALLINT
        #l_sql5      LIKE type_file.chr1000, #FUN-560043  #No.FUN-680137 VARCHAR(1600)  #CHI-940042 mark
        #l_sql6      LIKE type_file.chr1000, #FUN-560043  #No.FUN-680137 VARCHAR(1600)  #CHI-940042 mark
         l_sql1,l_sql2,l_sql3,l_sql4,l_sql5,l_sql6 STRING,#CHI-940042 
         l_imgg10    LIKE imgg_file.imgg10   #FUN-560043
  DEFINE p_img10     LIKE img_file.img10     #NO.FUN-620024
  DEFINE l_k         LIKE type_file.num5     #NO.FUN-620024 #No.FUN-680137 SMALLINT
  DEFINE p_unit      LIKE ima_file.ima25     #NO.FUN-620024                     
  DEFINE p_unit2     LIKE ima_file.ima25     #NO.FUN-620024
  DEFINE l_sw        LIKE type_file.num5     #No.TQC-660122 #No.FUN-680137 SMALLINT
  DEFINE l_azp03     LIKE azp_file.azp03     #No.TQC-660122
  DEFINE l_azp01     LIKE azp_file.azp01     #No.FUN-980059
  DEFINE l_plant     LIKE azp_file.azp01    #FUN-980010 add
  DEFINE l_legal     LIKE azw_file.azw02    #FUN-980010 add
  DEFINE p_dbs_tra LIKE azw_file.azw05    #FUN-980092 add
  DEFINE p_dbs     LIKE azp_file.azp03    #FUN-980092 add
  DEFINE l_ccz28       LIKE ccz_file.ccz28  #MOD-CC0289 add
  DEFINE l_sql         STRING                  #FUN-D20062
 
     #--Begin FUN-980092 add----GP5.2 Modify #改抓Transaction DB
     LET g_plant_new = p_plant
     CALL s_getdbs()
     LET p_dbs = g_dbs_new
     CALL s_gettrandbs()
     LET p_dbs_tra = g_dbs_tra
 
  IF p_part[1,4]='MISC' THEN RETURN END IF  #No.8743
  IF p_loca IS NULL THEN LET p_loca=' ' END IF
  IF p_lot  IS NULL THEN LET p_lot =' ' END IF
 
  IF p_type = 'S'
  THEN LET l_plant  = sp_plant
       LET l_legal  = sp_legal
  ELSE LET l_plant  = gp_plant
       LET l_legal  = gp_legal
  END IF
 
  CALL p820_ima(p_part,p_plant) 
     RETURNING l_ima02,l_ima25,l_qoh,l_ima86,l_ima39,l_ima35,l_ima36
     LET l_sql1 = "SELECT COUNT(*) ",
                  #" FROM ",p_dbs_tra CLIPPED,"img_file ", #FUN-980092 add
                  " FROM ",cl_get_target_table(p_plant,'img_file'), #FUN-A50102
                  " WHERE img01='",p_part,"' ",
                  "   AND img02='",p_ware,"'",
                  "   AND img03='",p_loca,"'",
                  "   AND img04='",p_lot,"'"     
     CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,p_plant) RETURNING l_sql1 #FUN-980092
     PREPARE img_pre1 FROM l_sql1
     IF SQLCA.SQLCODE THEN 
        LET g_showmsg = p_part,"/",p_ware,"/",p_loca,"/",p_lot      #No.FUN-710046
        CALL s_errmsg('img01,img02,img03,img04',g_showmsg,'img_pre',SQLCA.SQLCODE,0)  #No.FUN-710046
     END IF
     DECLARE img_cs CURSOR FOR img_pre1
     OPEN img_cs
     FETCH img_cs INTO l_n
 
  IF l_n = 0 THEN
     LET l_img.img01 = p_part
     LET l_img.img02 = p_ware
     LET l_img.img03 = p_loca
     LET l_img.img04 = p_lot
     LET l_img.img05 = g_ogb.ogb01
     LET l_img.img06 = g_ogb.ogb03
     LET l_img.img09 = l_ima25
     LET l_img.img10 = 0  
     LET l_img.img13 = null   #No.7304
     LET l_img.img17 = g_today
     LET l_img.img18 = g_lastdat
     LET l_img.img20 = 1
     LET l_img.img21 = 1
     LET l_img.img22 = g_imd10
     LET l_img.img23 = g_imd11
     LET l_img.img24 = g_imd12
     LET l_img.img25 = g_imd13
     LET l_img.img27 = g_imd14
     LET l_img.img28 = g_imd15
     #LET l_sql2="INSERT INTO ",p_dbs_tra CLIPPED,"img_file",  #FUN-980092 add
     LET l_sql2="INSERT INTO ",cl_get_target_table(p_plant,'img_file'), #FUN-A50102
       "(img01,img02,img03,img04,img05,img06,",
       " img09,img10,img13,img17,img18,", 
       " img20,img21,img22,img23,img24,", 
       " img25,img27,img28,imgplant,imglegal)",   #TQC-690057 add img27,img28 #FUN-980010
       " VALUES( ?,?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?, ?,?)"  #TQC-690057 #FUN-980010
     CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql(l_sql2,p_plant) RETURNING l_sql2 #FUN-980092
     PREPARE ins_img FROM l_sql2
     IF cl_null(l_img.img02)  THEN LET l_img.img02 = ' ' END IF
     IF cl_null(l_img.img03)  THEN LET l_img.img03 = ' ' END IF
     IF cl_null(l_img.img03)  THEN LET l_img.img03 = ' ' END IF
     EXECUTE ins_img USING l_img.img01,l_img.img02,l_img.img03,l_img.img04,
                           l_img.img05,l_img.img06,
                           l_img.img09,l_img.img10,l_img.img13,l_img.img17,
                           l_img.img18,
                           l_img.img20,l_img.img21,l_img.img22,l_img.img23,
                           l_img.img24,l_img.img25,l_img.img27,l_img.img28, #TQC-690057
                           l_plant,l_legal   #FUN-980010
     IF SQLCA.sqlcode<>0 THEN
        LET g_showmsg = l_img.img01,"/",l_img.img02,"/",l_img.img03,"/",l_img.img04   #No.FUN-710046
        CALL s_errmsg('img01,img02,img03,img04',g_showmsg,'ins img:',SQLCA.sqlcode,1) #No.FUN-710046
        LET g_success = 'N'
     END IF
 #-CHI-A10031-add
  ELSE
    IF i = 0 THEN
      SELECT img10 INTO l_img10
        FROM img_file
       WHERE img01 = p_part AND img02 = p_ware 
         AND img03 = p_loca AND img04 = p_lot  
      IF cl_null(l_img10)  THEN LET l_img10 = 0 END IF
      LET l_img10 = l_img10 + p_qty
      LET l_sql2="UPDATE img_file",
                 "   SET img10 = ? ",
                 " WHERE img01 = ? AND img02 = ? ",
                 "   AND img03 = ? AND img04 = ? " 
      PREPARE upd_img FROM l_sql2
      EXECUTE upd_img USING l_img10,p_part,p_ware,p_loca,p_lot
       IF SQLCA.sqlcode<>0 THEN
          LET g_showmsg = p_part,"/",p_ware,"/",p_loca,"/",p_lot 
          CALL s_errmsg('img01,img02,img03,img04',g_showmsg,'upd img:',SQLCA.sqlcode,1) 
          LET g_success = 'N'
       END IF
    END IF 
 #-CHI-A10031-end
   #FUN-D20062 -- add start --
    IF g_pod.pod08 = 'Y' THEN
       LET l_sql = "SELECT img18 FROM img_file ",
                   " WHERE img01='",p_part,"' ",
                   "   AND img02='",p_ware,"'",
                   "   AND img03='",p_loca,"'",
                   "   AND img04='",p_lot,"'"
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql
       PREPARE img18_pre FROM l_sql
       IF SQLCA.SQLCODE THEN
          IF g_bgerr THEN
             LET  g_showmsg=p_part,"/",p_ware,"/",p_loca,"/",p_lot
             CALL s_errmsg('img01,img02,img03,img04',g_showmsg,'img18_pre',SQLCA.SQLCODE,1)
          ELSE
            CALL cl_err('img18_pre',SQLCA.SQLCODE,1)
          END IF
       END IF

       DECLARE img18_cs CURSOR FOR img18_pre

       OPEN img18_cs
       FETCH img18_cs INTO l_img.img18
       IF SQLCA.SQLCODE <> 0 THEN
          IF g_bgerr THEN
             LET  g_showmsg=p_part,"/",p_ware,"/",p_loca,"/",p_lot
             CALL s_errmsg('img01,img02,img03,img04',g_showmsg,'img18_cs',SQLCA.sqlcode,1)
          ELSE
             CALL cl_err('img18_cs',SQLCA.sqlcode,1)
          END IF
          LET g_success='N'
       END IF
       CLOSE img18_cs
      
       LET l_sql= "UPDATE ",cl_get_target_table(p_plant,'img_file'),
                  " SET img18 = '",l_img.img18,"' ",
                  " WHERE img01='",p_part,"' ",
                  "   AND img02='",p_ware,"'",
                  "   AND img03='",p_loca,"'",
                  "   AND img04='",p_lot,"'"
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql
       CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
       PREPARE upd_img18 FROM l_sql
       EXECUTE upd_img18
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
          IF g_bgerr THEN
             LET  g_showmsg=p_part,"/",p_ware,"/",p_loca,"/",p_lot
             CALL s_errmsg('img01,img02,img03,img04',g_showmsg,'upd img18',SQLCA.sqlcode,1)
          ELSE
             CALL cl_err('upd img18:',STATUS,1)
          END IF
          LET g_success='N'
       END IF
    END IF
   #FUN-D20062 -- add end --
  END IF     
       LET l_sql3 = "SELECT img10 ",
                    #" FROM ",p_dbs_tra CLIPPED,"img_file ", #FUN-980092 add
                    " FROM ",cl_get_target_table(p_plant,'img_file'), #FUN-A50102
                    " WHERE img01='",p_part,"' ",
                    "   AND img02='",p_ware,"'",
                    "   AND img03='",p_loca,"'",
                    "   AND img04='",p_lot,"'"
       CALL cl_replace_sqldb(l_sql3) RETURNING l_sql3              #FUN-A50102
       CALL cl_parse_qry_sql(l_sql3,p_plant) RETURNING l_sql3      #FUN-980092
       PREPARE img_pre2 FROM l_sql3
       IF SQLCA.SQLCODE THEN 
          LET g_showmsg = p_part,"/",p_ware,"/",p_loca,"/",p_lot   #No.FUN-710046
          CALL s_errmsg('img01,img02,img03,img04',g_showmsg,'img_pre',SQLCA.SQLCODE,0)  #No.FUN-710046
       END IF
       DECLARE img_cs1 CURSOR FOR img_pre2   #MOD-A60145 img_pre1-->img_pre2
       OPEN img_cs1
       FETCH img_cs1 INTO p_img10
       IF SQLCA.SQLCODE <> 0 THEN                                                  
          LET g_success='N'                                                        
          RETURN                                                                   
       END IF                                                                      
       CLOSE img_cs1
 
  IF g_ima906 = '2' OR g_ima906 = '3' THEN
     IF g_ima906 = '2' THEN 
        LET l_k = 1
     ELSE
        LET l_k = 2
     END IF
     FOR l_i = l_k TO 2
        LET l_sql4 = ''
        LET l_n2 = 0 
        LET l_sql4 = "SELECT COUNT(*) ",
                     #" FROM ",p_dbs_tra CLIPPED,"imgg_file ", #FUN-980092 add
                     " FROM ",cl_get_target_table(p_plant,'imgg_file'), #FUN-A50102
                     " WHERE imgg01='",p_part,"' ",
                     "   AND imgg02='",p_ware,"'",
                     "   AND imgg03='",p_loca,"'",
                     "   AND imgg04='",p_lot,"'"
        IF l_i = 1 THEN
           LET l_sql4 = l_sql4,"   AND imgg09='",g_ogb.ogb910,"'"
        ELSE
           LET l_sql4 = l_sql4,"   AND imgg09='",g_ogb.ogb913,"'"
        END IF
        CALL cl_replace_sqldb(l_sql4) RETURNING l_sql4              #FUN-A50102   
        CALL cl_parse_qry_sql(l_sql4,p_plant) RETURNING l_sql4 #FUN-980092
        PREPARE imgg_pre FROM l_sql4
        IF SQLCA.SQLCODE THEN
           LET g_showmsg = p_part,"/",p_ware,"/",p_loca,"/",p_lot   #No.FUN-710046
           CALL s_errmsg('imgg01,imgg02,imgg03,imgg04',g_showmsg,'imgg_pre',SQLCA.SQLCODE,0)  #No.FUN-710046
        END IF
        DECLARE imgg_cs CURSOR FOR imgg_pre
        OPEN imgg_cs
        FETCH imgg_cs INTO l_n2
        IF l_n2 = 0 THEN
           LET l_imgg.imgg01 = p_part
           LET l_imgg.imgg02 = p_ware
           LET l_imgg.imgg03 = p_loca
           LET l_imgg.imgg04 = p_lot
           LET l_imgg.imgg05 = g_ogb.ogb01
           LET l_imgg.imgg06 = g_ogb.ogb03
           IF l_i = 1 THEN      #FUN-670007
              LET l_imgg.imgg09 = g_ogb.ogb910
           ELSE
              LET l_imgg.imgg09 = g_ogb.ogb913
           END IF
           LET l_imgg.imgg10 = 0     
           LET l_imgg.imgg17 = g_today
           LET l_imgg.imgg18 = g_lastdat
           IF p_dbs = l_dbs_new THEN     #FUN-980092 add
              LET l_azp03 = s_madd_img_catstr(l_azp.azp03)
              LET l_azp01 = s_madd_img_catstr(l_azp.azp01)  #No.FUN-980059
              CALL s_umfchk1(l_imgg.imgg01,l_imgg.imgg09,l_ima25,p_plant)  #No.FUN-980059  #FUN-980092 add
              RETURNING l_sw,l_imgg.imgg21
           ELSE 
              LET l_azp03 = s_madd_img_catstr(s_azp.azp03)
              CALL s_umfchk1(l_imgg.imgg01,l_imgg.imgg09,l_ima25,p_plant)  #No.FUN-980059  #FUN-980092 add
              RETURNING l_sw,l_imgg.imgg21
           END IF
           IF l_sw = 1 THEN
              CALL s_errmsg('','','','mfg3075',0)  #No.FUN-710046
              LET l_imgg.imgg21 = 1
           END IF
           LET l_imgg.imgg22 = 'S'
           LET l_imgg.imgg23 = 'Y'
           LET l_imgg.imgg24 = 'N'
           LET l_imgg.imgg25 = 'N'
           IF p_dbs   = l_dbs_new THEN   #FUN-980092 add
              CALL s_umfchk1(l_imgg.imgg01,l_imgg.imgg09,l_img.img09,p_plant)  #No.FUN-980059  #FUN-980092 add
              RETURNING l_sw,l_imgg.imgg211
           ELSE 
              CALL s_umfchk1(l_imgg.imgg01,l_imgg.imgg09,l_img.img09,p_plant)  #No.FUN-980059  #FUN-980092 add
              RETURNING l_sw,l_imgg.imgg211
           END IF
           IF l_sw = 1 THEN
              CALL s_errmsg('','','','mfg3075',0) #No.FUN-710046
              LET l_imgg.imgg211 = 1
           END IF
           IF cl_null(l_imgg.imgg02)  THEN LET l_imgg.imgg02 = ' ' END IF
           IF cl_null(l_imgg.imgg03)  THEN LET l_imgg.imgg03 = ' ' END IF
           IF cl_null(l_imgg.imgg04)  THEN LET l_imgg.imgg04 = ' ' END IF
           #LET l_sql5="INSERT INTO ",p_dbs_tra CLIPPED,"imgg_file", #FUN-980092 add
           LET l_sql5="INSERT INTO ",cl_get_target_table(p_plant,'imgg_file'), #FUN-A50102
             "(imgg01,imgg02,imgg03,imgg04,imgg05,",
             " imgg06,imgg09,imgg10,imgg17,imgg18,", 
             " imgg21,imgg22,imgg23,imgg24,imgg25,",  
             " imgg211,imggplant,imgglegal)", #FUN-980010 
             " VALUES(","'",l_imgg.imgg01,"',","'",l_imgg.imgg02,"',","'",l_imgg.imgg03,"',","'",l_imgg.imgg04,"',",
                        "'",l_imgg.imgg05,"',",l_imgg.imgg06,",","'",l_imgg.imgg09,"',",l_imgg.imgg10,",",
                        "'",l_imgg.imgg17,"',","'",l_imgg.imgg18,"',",l_imgg.imgg21,",","'",l_imgg.imgg22,"',",
                        "'",l_imgg.imgg23,"',","'",l_imgg.imgg24,"',","'",l_imgg.imgg25,"',",l_imgg.imgg211,",",
                        "'",l_plant,"',","'",l_legal,"'",")"   #FUN-980010   #FUN-B90012
           CALL cl_replace_sqldb(l_sql5) RETURNING l_sql5              #FUN-A50102									
	       CALL cl_parse_qry_sql(l_sql5,p_plant) RETURNING l_sql5      #FUN-A50102
           PREPARE ins_imgg FROM l_sql5
           EXECUTE ins_imgg  
              IF SQLCA.sqlcode<>0 THEN
                 LET g_showmsg = l_imgg.imgg01,"/",l_imgg.imgg02,"/",l_imgg.imgg03,"/",l_imgg.imgg04,"/",l_imgg.imgg09 #No.FUN-710046
                 CALL s_errmsg('imgg01,imgg02,imgg03,imgg04,imgg09',g_showmsg,'ins imgg:',SQLCA.sqlcode,1)  #No.FUN-710046
                 LET g_success = 'N'
              END IF
       #-CHI-A10031-add
        ELSE
           IF i = 0 THEN
             LET l_sql2 = "SELECT imgg10 ",
                          "  FROM imgg_file ",
                          " WHERE imgg01='",p_part,"' ",
                          "   AND imgg02='",p_ware,"'",
                          "   AND imgg03='",p_loca,"'",
                          "   AND imgg04='",p_lot,"'"
             IF l_i = 1 THEN
                LET l_sql2 = l_sql2,"   AND imgg09='",g_ogb.ogb910,"'"
             ELSE
                LET l_sql2 = l_sql2,"   AND imgg09='",g_ogb.ogb913,"'"
             END IF   
             PREPARE imgg10_pre FROM l_sql4
             IF SQLCA.SQLCODE THEN
                LET g_showmsg = p_part,"/",p_ware,"/",p_loca,"/",p_lot 
                CALL s_errmsg('imgg01,imgg02,imgg03,imgg04',g_showmsg,'imgg10_pre',SQLCA.SQLCODE,0)  
             END IF
             DECLARE imgg10_cs CURSOR FOR imgg10_pre
             OPEN imgg10_cs
             FETCH imgg10_cs INTO l_imgg10
             IF cl_null(l_imgg10)  THEN LET l_imgg10 = 0 END IF
             LET l_imgg10 = l_imgg10 + p_qty
             #FUN-C80001---begin
             IF l_i = 1 THEN  
                LET l_imgg10 = l_imgg10 + p_qty     
             ELSE
                LET l_imgg10 = l_imgg10 + p_qty1
             END IF 
             #FUN-C80001---end
             LET l_sql2="UPDATE imgg_file",
                        "   SET imgg10 = ? ",
                        " WHERE imgg01 = ? AND imgg02 = ? ",
                        "   AND imgg03 = ? AND imgg04 = ? ",
                        "   AND imgg09 = ? " 
             PREPARE upd_imgg FROM l_sql2
             IF l_i = 1 THEN
                EXECUTE upd_imgg USING l_img10,p_part,p_ware,p_loca,p_lot,g_ogb.ogb910
             ELSE
                EXECUTE upd_imgg USING l_img10,p_part,p_ware,p_loca,p_lot,g_ogb.ogb913
             END IF   
             IF SQLCA.sqlcode<>0 THEN
                IF l_i = 1 THEN
                   LET g_showmsg = p_part,"/",p_ware,"/",p_loca,"/",p_lot,"/",g_ogb.ogb910 
                ELSE
                   LET g_showmsg = p_part,"/",p_ware,"/",p_loca,"/",p_lot,"/",g_ogb.ogb913 
                END IF   
                CALL s_errmsg('imgg01,imgg02,imgg03,imgg04,imgg09',g_showmsg,'upd img:',SQLCA.sqlcode,1) 
                LET g_success = 'N'
             END IF
           END IF 
       #-CHI-A10031-end
        END IF    
     END FOR
  END IF
   IF i = 0 THEN  RETURN END IF          #CHI-A10031
 
   LET g_tlf.tlf01=p_part               #異動料件編號
   #----來源----
   IF p_sta = '1' OR p_sta='2' THEN
      IF p_sta = '1' THEN
         LET g_tlf.tlf02=50             #'Stock'
         LET g_tlf.tlf021=p_ware        #倉庫
         LET g_tlf.tlf022=p_loca         #儲位
         LET g_tlf.tlf023=p_lot         #批號
      ELSE
         LET g_tlf.tlf02=10
         LET g_tlf.tlf021=' '           #倉庫
         LET g_tlf.tlf022=' '           #儲位
         LET g_tlf.tlf023=' '           #批號
      END IF
      LET g_tlf.tlf020=l_ogb.ogb08
      LET g_tlf.tlf024=''              #異動後數量
      LET g_tlf.tlf025=l_ima25         #庫存單位(ima_file or img_file)
   ELSE
      LET g_tlf.tlf02=20
      LET g_tlf.tlf021=' '
      LET g_tlf.tlf022=' '
      LET g_tlf.tlf023=' '
      LET g_tlf.tlf024=' '
      LET g_tlf.tlf025=' '
   END IF
   CASE p_sta
     WHEN '1'  #出貨單
          IF i = 0 THEN
             LET g_tlf.tlf026=g_ogb.ogb01      #異動單號 (來源站)
             LET g_tlf.tlf027=g_ogb.ogb03      #異動項次
          ELSE
            LET g_tlf.tlf026=l_ogb.ogb01       #異動單號
            LET g_tlf.tlf027=l_ogb.ogb03       #異動項次
          END IF
     WHEN '2'  #收貨單
          LET g_tlf.tlf026=l_rvb.rvb04       #異動單號 no.6178
          LET g_tlf.tlf027=l_rvb.rvb03       #異動項次 no.6178
     WHEN '3'  #入庫單
          LET g_tlf.tlf026=l_rvv.rvv04       #異動單號 no.6178
          LET g_tlf.tlf027=l_rvv.rvv05       #異動項次 no.6178
   END CASE
   #---目的----
   IF p_sta = '3' OR p_sta = '2' THEN
      IF p_sta='3' THEN
         LET g_tlf.tlf03=50
         LET g_tlf.tlf035=l_ima25
      ELSE
         LET g_tlf.tlf03=20
         LET g_tlf.tlf035=''
      END IF
      LET g_tlf.tlf031=p_ware
      LET g_tlf.tlf032=p_loca
      LET g_tlf.tlf033=p_lot
      LET g_tlf.tlf034=''
   ELSE  
      LET g_tlf.tlf03=724
      LET g_tlf.tlf030=' '
      LET g_tlf.tlf031=' '            #倉庫
      LET g_tlf.tlf032=' '            #儲位
      LET g_tlf.tlf033=' '            #批號
      LET g_tlf.tlf034=' '            #異動後庫存數量
      LET g_tlf.tlf035=' '            #庫存單位(ima_file or img_file)
   END IF
   CASE p_sta
     WHEN '1'  #出貨單
          IF i = 0 THEN                         #NO.FUN-620024 #MOD-880139 cancel mark 
             LET g_tlf.tlf036=g_ogb.ogb31       #NO.FUN-620024
             LET g_tlf.tlf037=g_ogb.ogb32       #NO.FUN-620024
          ELSE                                  #NO.FUN-620024
             LET g_tlf.tlf036=l_ogb.ogb31       #異動單號 no.6178
             LET g_tlf.tlf037=l_ogb.ogb32       #異動項次 no.6178
          END IF                                #NO.FUN-620024
     WHEN '2'  #收貨單
          LET g_tlf.tlf036=l_rvb.rvb01       #異動單號
          LET g_tlf.tlf037=l_rvb.rvb02       #異動項次
     WHEN '3'  #入庫單
          LET g_tlf.tlf036=l_rvv.rvv01       #異動單號
          LET g_tlf.tlf037=l_rvv.rvv02       #異動項次
   END CASE
   #-->異動數量
   LET g_tlf.tlf04= ' '                #工作站
   LET g_tlf.tlf05= ' '                #作業序號
   LET g_tlf.tlf06=g_oga.oga02         #發料日期 no.6178
   LET g_tlf.tlf07=g_today             #異動資料產生日期  
   LET g_tlf.tlf08=TIME                #異動資料產生時:分:秒
   LET g_tlf.tlf09=g_user              #產生人
   #FUN-C80001---begin
   IF g_ima906 = '2' THEN
      LET g_tlf.tlf10=p_qty + p_qty1*l_ogb.ogb914
   ELSE 
      LET g_tlf.tlf10=p_qty               #異動數量
   END IF #FUN-C80001
   CASE p_sta
     WHEN '1'  #出貨單
           LET g_tlf.tlf11=g_ogb.ogb05         #MOD-4B0148
           LET g_tlf.tlf12=g_ogb.ogb15_fac     #MOD-4B0148   #No.TQC-750014 modify
           IF i = 0 THEN                         
              LET g_tlf.tlf12=g_ogb.ogb15_fac
           ELSE
              LET g_tlf.tlf12=l_ogb.ogb15_fac
           END IF
     WHEN '2'  #收貨單
           LET g_tlf.tlf11=g_ogb.ogb05         #MOD-4B0148
           LET g_tlf.tlf12=g_pmn.pmn09         #MOD-4B0148   #No.TQC-750014 modify  #MOD-810179 modify
     WHEN '3'  #入庫單
           LET g_tlf.tlf11=l_rvv.rvv35         #MOD-4B0148
           LET g_tlf.tlf12=l_rvv.rvv35_fac     #MOD-4B0148
   END CASE
 
   CASE p_sta
        WHEN '1' LET g_tlf.tlf13='axmt620'
        WHEN '2' LET g_tlf.tlf13='apmt1101'
        WHEN '3' LET g_tlf.tlf13='apmt150'
   END CASE
   LET g_tlf.tlf14=' '              #異動原因
 
   LET g_tlf.tlf17=' '              #非庫存性料件編號
   LET g_tlf.tlf18=l_qoh
   CASE p_sta
        WHEN '1' AND i = 1       LET g_tlf.tlf19=g_oea.oea03  #FUN-670007
        WHEN '1' AND i != p_last LET g_tlf.tlf19=p_oea911 
        WHEN '1' AND i  = p_last CALL p820_oea911(i-1) RETURNING g_tlf.tlf19
        WHEN '2' LET g_tlf.tlf19=p_pmm09
        WHEN '3' LET g_tlf.tlf19=p_pmm09
   END CASE
   LET g_tlf.tlf20= ' '     
 
   CASE p_sta
     WHEN '1'  #出貨單
           IF i = 0 THEN                         
              LET g_tlf.tlf60=g_ogb.ogb05_fac
           ELSE
              LET g_tlf.tlf60=l_ogb.ogb05_fac
           END IF
     WHEN '2'  #收貨單
           CALL s_umfchkm(l_ogb.ogb04,g_pmn.pmn07,l_ima25,p_plant)
                RETURNING l_flag,l_ogb.ogb05_fac
           IF l_flag THEN LET l_ogb.ogb05_fac=1 END IF 
           LET g_tlf.tlf60=l_ogb.ogb05_fac     #MOD-4B0148  #MOD-810179 modify g_->l_
     WHEN '3'  #入庫單
           CALL s_umfchkm(l_ogb.ogb04,g_pmn.pmn07,l_ima25,p_plant)
                RETURNING l_flag,l_ogb.ogb05_fac
           IF l_flag THEN LET l_ogb.ogb05_fac=1 END IF 
           LET g_tlf.tlf60=l_ogb.ogb05_fac     #MOD-4B0148  #MOD-810179
   END CASE
   
   IF p_sta = '4' THEN    #代送銷退單
 
      LET g_tlf.tlf02 = 731
      LET g_tlf.tlf020 = ' '
      LET g_tlf.tlf021 = ' '
      LET g_tlf.tlf022 = ' '
      LET g_tlf.tlf023 = ' '
      LET g_tlf.tlf024 = 0  
      LET g_tlf.tlf025 = ' '
    
      LET g_tlf.tlf026 = l_oha.oha01       #異動單號
      LET g_tlf.tlf027 = l_ohb.ohb03       #異動項次 
    
      LET g_tlf.tlf03 = 50 
      LET g_tlf.tlf030 = l_ohb.ohb08
      LET g_tlf.tlf031 = p_ware
      LET g_tlf.tlf032 = p_loca
      LET g_tlf.tlf033 = p_lot
      LET g_tlf.tlf034 = p_img10
      LET g_tlf.tlf035 = l_ima25           #庫存單位(ima_file or img_file)
     
      LET g_tlf.tlf036 = l_oha.oha01       #異動單號
      LET g_tlf.tlf037 = l_ohb.ohb03       #異動項次
 
      LET g_tlf.tlf11 = l_ohb.ohb05        
      LET g_tlf.tlf12 = l_ohb.ohb15_fac    #No.TQC-750014 modify
    
      LET g_tlf.tlf13 = 'aomt800'
      LET g_tlf.tlf19 = l_oha.oha04
      LET g_tlf.tlf60 = l_ohb.ohb05_fac
   END IF
 
 
   LET g_tlf.tlf62=l_ogb.ogb31    #參考單號(訂單)   
   LET g_tlf.tlf63=l_ogb.ogb32    #訂單項次
   CASE WHEN  g_tlf.tlf02=50 
              LET g_tlf.tlf902=g_tlf.tlf021
              LET g_tlf.tlf903=g_tlf.tlf022
              LET g_tlf.tlf904=g_tlf.tlf023
              LET g_tlf.tlf905=g_tlf.tlf026
              LET g_tlf.tlf906=g_tlf.tlf027
              LET g_tlf.tlf907=-1
        WHEN  g_tlf.tlf03=50 
              LET g_tlf.tlf902=g_tlf.tlf031
              LET g_tlf.tlf903=g_tlf.tlf032
              LET g_tlf.tlf904=g_tlf.tlf033
              LET g_tlf.tlf905=g_tlf.tlf036
              LET g_tlf.tlf906=g_tlf.tlf037
              LET g_tlf.tlf907=1
        OTHERWISE
              LET g_tlf.tlf902=' '
              LET g_tlf.tlf903=' '
              LET g_tlf.tlf904=' '
              LET g_tlf.tlf905=' '
              LET g_tlf.tlf906=' '
              LET g_tlf.tlf907=0
   END CASE
   LET g_tlf.tlf99 = g_flow99  #No.7993
   IF g_tlf.tlf902 IS NULL THEN LET g_tlf.tlf902 = ' ' END IF
   IF g_tlf.tlf903 IS NULL THEN LET g_tlf.tlf903 = ' ' END IF
   IF g_tlf.tlf904 IS NULL THEN LET g_tlf.tlf904 = ' ' END IF
   LET g_tlf.tlf61 = s_get_doc_no(g_tlf.tlf905)   #FUN-560043
   CASE p_sta
     WHEN '1'  #出貨單
          LET g_tlf.tlf930 = l_ogb.ogb930
     WHEN '2'  #收貨單
          LET g_tlf.tlf930 = l_rvb.rvb930   
     WHEN '3'  #入庫單
          LET g_tlf.tlf930 = l_rvv.rvv930 
   END CASE
 
   IF (g_tlf.tlf02=50 OR g_tlf.tlf03=50) THEN
      IF NOT s_tlfidle(p_plant,g_tlf.*) THEN        #更新呆滯日期
         CALL cl_err('upd ima902:','9050',1)
         LET g_success='N'
      END IF
   END IF
     #TQC-D20047--add--str--
     LET l_sql2 = "SELECT aza115 FROM ",cl_get_target_table(p_plant,'aza_file')," WHERE aza01 = '0' "
     PREPARE aza115_pr4 FROM l_sql3
     EXECUTE aza115_pr4 INTO g_aza.aza115   
     #TQC-D20047--add--end--
    #FUN-CB0087--add--str--
    IF g_aza.aza115 ='Y' THEN
       IF cl_null(g_tlf.tlf14) THEN  #TQC-D20067 mark  #TQC-D40064 remark
         #CALL s_reason_code(g_tlf.tlf036,g_tlf.tlf026,'',g_tlf.tlf01,g_tlf.tlf031,'','') RETURNING g_tlf.tlf14           #TQC-D20042 mark
          CALL s_reason_code1(g_tlf.tlf036,g_tlf.tlf026,'',g_tlf.tlf01,g_tlf.tlf031,'','',p_plant) RETURNING g_tlf.tlf14  #TQC-D20042
          IF cl_null(g_tlf.tlf14) THEN
             #CALL cl_err(g_tlf.tlf14,'aim-425',1)
             LET g_showmsg = p_plant,"/",g_tlf.tlf036                  #TQC-D20047       
             CALL s_errmsg('tlf036',g_showmsg,'up tlf14:','aim-425',1) #TQC-D20047
             LET g_success="N"
             RETURN
          END IF
       END IF  #TQC-D20067 mark  #TQC-D40064 remark
    END IF
    #FUN-CB0087--add--end-- 
#MOD-CC0289 add begin---------------------------------------------- 
    #依參考成本參數檔(ccz_file)中ccz28的值更新tlfcost的值  
    #當ccz28='1' OR '2'時,tlfcost=' '
    #當ccz28='3'時       ,tlfcost=批號 tlf904(tlf023/tlf033)
    #當ccz28='4'時       ,tlfcost=專案號 tlf20
    #當ccz28='5'時       ,tlfcost=倉庫
    SELECT ccz28 INTO l_ccz28 FROM ccz_file WHERE ccz00='0'
    CASE 
       WHEN l_ccz28='1' OR l_ccz28='2'
          LET g_tlf.tlfcost=' '
       WHEN l_ccz28='3'   #批號
          IF g_tlf.tlf904 IS NULL THEN LET g_tlf.tlf904=' ' END IF
          LET g_tlf.tlfcost=g_tlf.tlf904
       WHEN l_ccz28='4'   #專案編號
          IF g_tlf.tlf20 IS NULL THEN LET g_tlf.tlf20=' ' END IF
          LET g_tlf.tlfcost=g_tlf.tlf20
       WHEN l_ccz28='5'   #倉庫
          IF g_tlf.tlf901 IS NULL THEN LET g_tlf.tlf901=' ' END IF 
          LET g_tlf.tlfcost=g_tlf.tlf901                         
    END CASE
#MOD-CC0289 add end----------------------------------------------      

   #No.FUN-CC0157(S)
   CASE
      WHEN g_tlf.tlf13 MATCHES 'axmt*'
           CALL s_tlf920('1',g_tlf.tlf905) RETURNING g_tlf.tlf920
      WHEN g_tlf.tlf13 MATCHES 'aomt*' 
           CALL s_tlf920('2',g_tlf.tlf905) RETURNING g_tlf.tlf920
    END CASE
   #No.FUN-CC0157(E)

    #LET l_sql2="INSERT INTO ",p_dbs_tra CLIPPED,"tlf_file",#FUN-980092 add
    LET l_sql2="INSERT INTO ",cl_get_target_table(p_plant,'tlf_file'), #FUN-A50102
      "(tlf01,tlf020,tlf02,tlf021,tlf022,",
      " tlf023,tlf024,tlf025,tlf026,tlf027,",
      " tlf03,tlf031,tlf032,tlf033,tlf034,",
      " tlf035,tlf036,tlf037,tlf04,tlf05,",
      " tlf06,tlf07,tlf08,tlf09,tlf10,",
      " tlf11,tlf12,tlf13,tlf14,tlf15,",
      " tlf16,tlf17,tlf18,tlf19,tlf20,",
      " tlf60,tlf61,tlf62,tlf63,tlf99, ",
      " tlf902,tlf903,tlf904,tlf905,tlf906,",
      " tlf907,tlf930,tlfplant,tlflegal,tlfcost,tlf920)",  #MOD-CC0289 add tlfcost #FUN-980010 #CHI-9B0008  #TQC-9C0120 mod #FUN-CC0157 add tlf920
      " VALUES( ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
      "         ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
      "         ?,?,?,?,?, ?,?,?,? ,?,?) "   #MOD-CC0289 add tlfcost  #FUN-980010 #CHI-9B0008 #FUN-CC0157 
    CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2              #FUN-A50102									
	CALL cl_parse_qry_sql(l_sql2,p_plant) RETURNING l_sql2      #FUN-A50102
    PREPARE ins_tlf FROM l_sql2
    EXECUTE ins_tlf USING 
       g_tlf.tlf01,g_tlf.tlf020,g_tlf.tlf02,g_tlf.tlf021,g_tlf.tlf022,
       g_tlf.tlf023,g_tlf.tlf024,g_tlf.tlf025,g_tlf.tlf026,g_tlf.tlf027,
       g_tlf.tlf03,g_tlf.tlf031,g_tlf.tlf032,g_tlf.tlf033,g_tlf.tlf034,
       g_tlf.tlf035,g_tlf.tlf036,g_tlf.tlf037,g_tlf.tlf04,g_tlf.tlf05,
       g_tlf.tlf06,g_tlf.tlf07,g_tlf.tlf08,g_tlf.tlf09,g_tlf.tlf10,
       g_tlf.tlf11,g_tlf.tlf12,g_tlf.tlf13,g_tlf.tlf14,g_tlf.tlf15,
       g_tlf.tlf16,g_tlf.tlf17,g_tlf.tlf18,g_tlf.tlf19,g_tlf.tlf20,
       g_tlf.tlf60,g_tlf.tlf61,g_tlf.tlf62,g_tlf.tlf63,g_tlf.tlf99, #No.7993
       g_tlf.tlf902,g_tlf.tlf903,g_tlf.tlf904,g_tlf.tlf905,g_tlf.tlf906,
       g_tlf.tlf907,g_tlf.tlf930,l_plant,l_legal,g_tlf.tlfcost,g_tlf.tlf920   #FUN-980010   #CHI-9B0008  #FUN-CC0157 add tlf920
       IF SQLCA.sqlcode<>0 THEN  #MOD-CC0289 add tlfcost
          LET g_showmsg = g_tlf.tlf01,"/",g_tlf.tlf06  #No.FUN-710046
          CALL s_errmsg('tlf01,tlf06',g_showmsg,'ins tlf:',SQLCA.sqlcode,1)  #No.FUN-710046
          LET g_success = 'N'
       END IF
     #FUN-BC0062 ----------------Begin---------------
      #計算異動加權平均成本
       IF NOT s_tlf_mvcost(p_plant) THEN
          LET g_showmsg = g_tlf.tlf01,"/",g_tlf.tlf06
          CALL s_errmsg('tlf01,tlf06',g_showmsg,'ins cfa:',SQLCA.sqlcode,1)
          LET g_success = 'N'
       END IF
     #FUN-BC0062 ----------------End-----------------
  IF g_ima906 = '2' OR g_ima906 = '3' THEN
     FOR l_j = 1 TO 2 
         IF l_j = 1 AND g_ima906 = '3' THEN
            CONTINUE FOR
         END IF
      LET g_tlff.tlff01=p_part               #異動料件編號
      #----來源----
      IF p_sta = '1' OR p_sta='2' THEN
         IF p_sta = '1' THEN
            LET g_tlff.tlff02=50             #'Stock'
            LET g_tlff.tlff021=p_ware        #倉庫
            LET g_tlff.tlff022=p_loca        #儲位
            LET g_tlff.tlff023=p_lot         #批號
         ELSE
            LET g_tlff.tlff02=10
            LET g_tlff.tlff021=' '           #倉庫
            LET g_tlff.tlff022=' '           #儲位
            LET g_tlff.tlff023=' '           #批號
         END IF
         LET g_tlff.tlff020=l_ogb.ogb08
         LET g_tlff.tlff024=''              #異動後數量
         IF l_j = 1 THEN 
            LET g_tlff.tlff025=g_ogb.ogb910
         ELSE
            LET g_tlff.tlff025=g_ogb.ogb913
         END IF
      ELSE
         LET g_tlff.tlff02=20
         LET g_tlff.tlff021=' '
         LET g_tlff.tlff022=' '
         LET g_tlff.tlff023=' '
         LET g_tlff.tlff024=' '
         LET g_tlff.tlff025=' '
      END IF
      CASE p_sta
        WHEN '1'  #出貨單
        #    IF i = 1 THEN                          #FUN-670007  #FUN-B90012
             IF i = 0 THEN                          #FUN-B90012
                LET g_tlff.tlff026=g_ogb.ogb01      #異動單號 (來源站)
                LET g_tlff.tlff027=g_ogb.ogb03      #異動項次
             ELSE
               LET g_tlff.tlff026=l_ogb.ogb01       #異動單號
               LET g_tlff.tlff027=l_ogb.ogb03       #異動項次
             END IF
        WHEN '2'  #收貨單
             LET g_tlff.tlff026=l_rvb.rvb04       #異動單號
             LET g_tlff.tlff027=l_rvb.rvb03       #異動項次 
        WHEN '3'  #入庫單
             LET g_tlff.tlff026=l_rvv.rvv04       #異動單號
             LET g_tlff.tlff027=l_rvv.rvv05       #異動項次
      END CASE
      #---目的----
      IF p_sta = '3' OR p_sta = '2' THEN
         IF p_sta='3' THEN
            LET g_tlff.tlff03=50
            IF l_j = 1 THEN
               LET g_tlff.tlff035=g_ogb.ogb910
            ELSE
               LET g_tlff.tlff035=g_ogb.ogb913
            END IF
         ELSE
            LET g_tlff.tlff03=20
            LET g_tlff.tlff035=''
         END IF
         LET g_tlff.tlff031=p_ware
         LET g_tlff.tlff032=p_loca
         LET g_tlff.tlff033=p_lot
         LET g_tlff.tlff034=''
      ELSE  
         LET g_tlff.tlff03=724
         LET g_tlff.tlff030=' '
         LET g_tlff.tlff031=' '            #倉庫
         LET g_tlff.tlff032=' '            #儲位
         LET g_tlff.tlff033=' '            #批號
         LET g_tlff.tlff034=' '            #異動後庫存數量
         LET g_tlff.tlff035=' '            
      END IF
      CASE p_sta
        WHEN '1'  #出貨單
        #    IF i = 1 THEN                           #NO.FUN-670007  #FUN-B90012
             IF i = 0 THEN                           #FUN-B90012
                LET g_tlff.tlff036=g_ogb.ogb31       #NO.FUN-620024
                LET g_tlff.tlff037=g_ogb.ogb32       #NO.FUN-620024
             ELSE                                    #NO.FUN-620024
                LET g_tlff.tlff036=l_ogb.ogb31       #異動單號 
                LET g_tlff.tlff037=l_ogb.ogb32       #異動項次 
             END IF                                  #NO.FUN-620024
        WHEN '2'  #收貨單
             LET g_tlff.tlff036=l_rvb.rvb01       #異動單號
             LET g_tlff.tlff037=l_rvb.rvb02       #異動項次
        WHEN '3'  #入庫單
             LET g_tlff.tlff036=l_rvv.rvv01       #異動單號
             LET g_tlff.tlff037=l_rvv.rvv02       #異動項次
      END CASE
      #-->異動數量
      LET g_tlff.tlff04= ' '                #工作站
      LET g_tlff.tlff05= ' '                #作業序號
      LET g_tlff.tlff06=g_oga.oga02         #發料日期 
      LET g_tlff.tlff07=g_today             #異動資料產生日期  
      LET g_tlff.tlff08=TIME                #異動資料產生時:分:秒
      LET g_tlff.tlff09=g_user              #產生人
      IF l_j = 1 THEN
         #LET g_tlff.tlff10=g_ogb.ogb912        #異動數量 #FUN-C80001
         LET g_tlff.tlff10= p_qty   #FUN-C80001
      ELSE 
         #LET g_tlff.tlff10=g_ogb.ogb915        #異動數量 #FUN-C80001
         LET g_tlff.tlff10= p_qty1  #FUN-C80001
      END IF 
      CASE p_sta
        WHEN '1'  #出貨單
             IF l_j = 1 THEN
                LET g_tlff.tlff11=g_ogb.ogb910      
                LET g_tlff.tlff12=g_ogb.ogb911     
                LET g_tlff.tlff219 = 2              #NO.FUN-620024
                LET g_tlff.tlff220 = g_ogb.ogb910   #NO.FUN-620024
             ELSE
                LET g_tlff.tlff11=g_ogb.ogb913      
                LET g_tlff.tlff12=g_ogb.ogb914     
                LET g_tlff.tlff219 = 1              #NO.FUN-620024
                LET g_tlff.tlff220 = g_ogb.ogb913   #NO.FUN-620024
             END IF
        WHEN '2'  #收貨單
             IF l_j = 1 THEN
                LET g_tlff.tlff11=g_ogb.ogb910         
                LET g_tlff.tlff12=g_ogb.ogb911     
                LET g_tlff.tlff219 = 2              #NO.FUN-620024
                LET g_tlff.tlff220 = g_ogb.ogb910   #NO.FUN-620024
             ELSE
                LET g_tlff.tlff11=g_ogb.ogb913         
                LET g_tlff.tlff12=g_ogb.ogb914     
                LET g_tlff.tlff219 = 1              #NO.FUN-620024
                LET g_tlff.tlff220 = g_ogb.ogb913   #NO.FUN-620024
             END IF
        WHEN '3'  #入庫單
             IF l_j = 1 THEN
                LET g_tlff.tlff11=g_ogb.ogb910         
                LET g_tlff.tlff12=g_ogb.ogb911     
                LET g_tlff.tlff219 = 2              #NO.FUN-620024
                LET g_tlff.tlff220 = g_ogb.ogb910   #NO.FUN-620024
             ELSE
                LET g_tlff.tlff11=g_ogb.ogb913         
                LET g_tlff.tlff12=g_ogb.ogb914     
                LET g_tlff.tlff219 = 1              #NO.FUN-620024
                LET g_tlff.tlff220 = g_ogb.ogb913   #NO.FUN-620024
             END IF
      END CASE
 
      CASE p_sta
           WHEN '1' LET g_tlff.tlff13='axmt620'
           WHEN '2' LET g_tlff.tlff13='apmt1101'
           WHEN '3' LET g_tlff.tlff13='apmt150'
      END CASE
      LET g_tlff.tlff14=' '              #異動原因
 
      LET g_tlff.tlff17=' '              #非庫存性料件編號
      IF l_j = 1 THEN
         SELECT imgg10 INTO l_imgg10 FROM imgg_file 
                WHERE imgg01= p_part AND imgg02 = p_ware AND imgg03 = p_loca AND
                      imgg04 = p_lot AND imgg09 = g_ogb.ogb910  
      ELSE
         SELECT imgg10 INTO l_imgg10 FROM imgg_file 
                WHERE imgg01= p_part AND imgg02 = p_ware AND imgg03 = p_loca AND
                      imgg04 = p_lot AND imgg09 = g_ogb.ogb913  
      END IF
      CASE p_sta
        WHEN '1'  #出貨單
             IF l_j = 1 THEN 
                #LET l_imgg10 = l_imgg10 - g_ogb.ogb912  #FUN-C80001
                LET l_imgg10 = l_imgg10 - p_qty  #FUN-C80001 
             ELSE
                #LET l_imgg10 = l_imgg10 - g_ogb.ogb915  #FUN-C80001 
                LET l_imgg10 = l_imgg10 - p_qty1  #FUN-C80001 
             END IF
        WHEN '2'  #收貨單
             IF l_j = 1 THEN
                #LET l_imgg10 = l_imgg10 + g_ogb.ogb912  #FUN-C80001
                LET l_imgg10 = l_imgg10 + p_qty  #FUN-C80001    
             ELSE
                #LET l_imgg10 = l_imgg10 + g_ogb.ogb915  #FUN-C80001 
                LET l_imgg10 = l_imgg10 + p_qty1  #FUN-C80001      
             END IF
        WHEN '3'  #入庫單
             IF l_j = 1 THEN
                #LET l_imgg10 = l_imgg10 + g_ogb.ogb912  #FUN-C80001
                LET l_imgg10 = l_imgg10 + p_qty  #FUN-C80001     
             ELSE
                #LET l_imgg10 = l_imgg10 + g_ogb.ogb915  #FUN-C80001 
                LET l_imgg10 = l_imgg10 + p_qty1  #FUN-C80001    
             END IF   
      END CASE
      LET g_tlff.tlff18=l_imgg10
      CASE p_sta
           WHEN '1' AND i = 1       LET g_tlff.tlff19=g_oea.oea03  #FUN-670007
           WHEN '1' AND i != p_last LET g_tlff.tlff19=p_oea911 
           WHEN '1' AND i  = p_last CALL p820_oea911(i) RETURNING g_tlff.tlff19  #FUN-670007
           WHEN '2' LET g_tlff.tlff19=p_pmm09
           WHEN '3' LET g_tlff.tlff19=p_pmm09
      END CASE
      LET g_tlff.tlff20= ' '     
 
      CASE p_sta
        WHEN '1'  #出貨單
             LET g_tlff.tlff60=1
        WHEN '2'  #收貨單
             LET g_tlff.tlff60=1
        WHEN '3'  #入庫單
             LET g_tlff.tlff60=1
      END CASE
 
      IF p_sta = '4' THEN    #代送銷退單
         
         LET g_tlff.tlff02 = 731            #來源狀況 
         LET g_tlff.tlff021 =''             #倉庫
         LET g_tlff.tlff022 =''             #儲位
         LET g_tlff.tlff023 =''             #批號
         LET g_tlff.tlff020 = ''            #營運中心編號
         LET g_tlff.tlff024 = 0             #異動后庫存數量
 
         IF l_j = 1 THEN
            LET g_tlff.tlff025 = l_ohb.ohb910   #異動后庫存數量單位
         ELSE
            LET g_tlff.tlff025 = l_ohb.ohb913
         END IF
 
         LET g_tlff.tlff026 = l_oha.oha01       #異動單號
         LET g_tlff.tlff027 = l_ohb.ohb03       #異動項次 
    
         LET g_tlff.tlff03 = 50                 #目的狀況
         LET g_tlff.tlff030 = ''                #營運中心編號
         LET g_tlff.tlff031 = p_ware            #倉庫
         LET g_tlff.tlff032 = p_loca            #儲位
         LET g_tlff.tlff033 = p_lot             #批號
         LET g_tlff.tlff034 = l_qoh             #異動后庫存數量
 
         IF l_j = 1 THEN
            LET g_tlff.tlff035 = l_ohb.ohb910   #異動后庫存數量單
         ELSE
            LET g_tlff.tlff035 = l_ohb.ohb913
         END IF           
 
         LET g_tlff.tlff036 = l_oha.oha01       #異動單號
         LET g_tlff.tlff037 = l_ohb.ohb03       #異動項次
 
         IF l_j = 1 THEN
            LET g_tlff.tlff10=l_ohb.ohb912      #異動數量
            LET g_tlff.tlff11=l_ohb.ohb910      #異動數量單位
            LET g_tlff.tlff12=l_ohb.ohb911      #異動數量單位與異動目的數量單位轉換率
            LET g_tlff.tlff219 = 2              #第二單位
            LET g_tlff.tlff220 = l_ohb.ohb910   #單位
         ELSE
            LET g_tlff.tlff10=l_ohb.ohb915      #異動數量
            LET g_tlff.tlff11=l_ohb.ohb913
            LET g_tlff.tlff12=l_ohb.ohb914
            LET g_tlff.tlff219 = 1              #第一單位 
            LET g_tlff.tlff220 = l_ohb.ohb913 
         END IF
    
         LET g_tlff.tlff13 = 'aomt800'          #異動指令編號
         LET g_tlff.tlff19 = l_oha.oha04        #客戶編號
 
         IF l_j = 1 THEN
            LET g_tlff.tlff60 = l_ohb.ohb911    #異動數據單位對庫存單位之換算率 
         ELSE
            LET g_tlff.tlff60 = l_ohb.ohb914
         END IF
 
         IF l_j = 1 THEN 
            LET l_imgg10 = l_imgg10 - l_ohb.ohb912      
         ELSE
            LET l_imgg10 = l_imgg10 - l_ohb.ohb915      
         END IF
         LET g_tlff.tlff18=l_imgg10
      END IF 
 
 
      LET g_tlff.tlff62=l_ogb.ogb31    #參考單號(訂單)   
      LET g_tlff.tlff63=l_ogb.ogb32    #訂單項次
      CASE WHEN  g_tlff.tlff02=50 
                 LET g_tlff.tlff902=g_tlff.tlff021
                 LET g_tlff.tlff903=g_tlff.tlff022
                 LET g_tlff.tlff904=g_tlff.tlff023
                 LET g_tlff.tlff905=g_tlff.tlff026
                 LET g_tlff.tlff906=g_tlff.tlff027
                LET g_tlff.tlff907=-1
           WHEN  g_tlff.tlff03=50 
                 LET g_tlff.tlff902=g_tlff.tlff031
                 LET g_tlff.tlff903=g_tlff.tlff032
                 LET g_tlff.tlff904=g_tlff.tlff033
                 LET g_tlff.tlff905=g_tlff.tlff036
                 LET g_tlff.tlff906=g_tlff.tlff037
                 LET g_tlff.tlff907=1
           OTHERWISE
                 LET g_tlff.tlff902=' '
                 LET g_tlff.tlff903=' '
                 LET g_tlff.tlff904=' '
                 LET g_tlff.tlff905=' '
                 LET g_tlff.tlff906=0    #NO.FUN-620024
                 LET g_tlff.tlff907=0
      END CASE
      LET g_tlff.tlff99 = g_flow99  #No.7993
      IF g_tlff.tlff902 IS NULL THEN LET g_tlff.tlff902 = ' ' END IF
      IF g_tlff.tlff903 IS NULL THEN LET g_tlff.tlff903 = ' ' END IF
      IF g_tlff.tlff904 IS NULL THEN LET g_tlff.tlff904 = ' ' END IF
      LET g_tlff.tlff61 = s_get_doc_no(g_tlff.tlff905)
      CASE p_sta
        WHEN '1'  #出貨單
             LET g_tlff.tlff930 = l_ogb.ogb930
        WHEN '2'  #收貨單
             LET g_tlff.tlff930 = l_rvb.rvb930   
        WHEN '3'  #入庫單
             LET g_tlff.tlff930 = l_rvv.rvv930 
      END CASE
 
      IF g_tlff.tlff10 IS NULL OR g_tlff.tlff10 = 0 OR                             
         g_tlff.tlff11 IS NULL  THEN                                               
           CONTINUE FOR                                                            
      END IF                                                                       
      IF l_j = 1 THEN                                                              
         LET p_unit = g_tlff.tlff11                                                
      ELSE                                                                         
         LET p_unit2 = g_tlff.tlff11                                               
      END IF                                                                       
 
      IF cl_null(g_tlff.tlff012) THEN LET g_tlff.tlff012 = ' ' END IF   #FUN-B90012
      IF cl_null(g_tlff.tlff013) THEN LET g_tlff.tlff013 = 0   END IF   #FUN-B90012
       #LET l_sql6="INSERT INTO ",p_dbs_tra CLIPPED,"tlff_file", #FUN-980092 add
       LET l_sql6="INSERT INTO ",cl_get_target_table(p_plant,'tlff_file'), #FUN-A50102
                  "(tlff01,tlff020,tlff02,tlff021,tlff022,",
                  " tlff023,tlff024,tlff025,tlff026,tlff027,",
                  " tlff03,tlff031,tlff032,tlff033,tlff034,",
                  " tlff035,tlff036,tlff037,tlff04,tlff05,",
                  " tlff06,tlff07,tlff08,tlff09,tlff10,",
                  " tlff11,tlff12,tlff13,tlff14,tlff15,",
                  " tlff16,tlff17,tlff18,tlff19,tlff20,",
                  " tlff60,tlff61,tlff62,tlff63,tlff99, ",
                  " tlff902,tlff903,tlff904,tlff905,tlff906,", #NO.FUN-620024
                  " tlff907,tlff219,tlff220,tlff930,tlffplant,",         #FUN-980092 #FUN-980010  #CHI-9B0008
                  " tlfflegal,tlff012,tlff013 )",                        #FUN-980010 #FUN-B90012 add tlff012,tlff013
                  " VALUES( ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
                  "         ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
                  "         ?,?,?,?,?, ?,?,?,?,?, ?,?,?) "   #NO.FUN-620024 #FUN-980010 #CHI-9B0008  #FUN-B90012 add ?,?
       CALL cl_replace_sqldb(l_sql6) RETURNING l_sql6              #FUN-A50102									
	   CALL cl_parse_qry_sql(l_sql6,p_plant) RETURNING l_sql6 #FUN-A50102
       PREPARE ins_tlff FROM l_sql6
       EXECUTE ins_tlff USING 
          g_tlff.tlff01,g_tlff.tlff020,g_tlff.tlff02,g_tlff.tlff021,g_tlff.tlff022,
          g_tlff.tlff023,g_tlff.tlff024,g_tlff.tlff025,g_tlff.tlff026,g_tlff.tlff027,
          g_tlff.tlff03,g_tlff.tlff031,g_tlff.tlff032,g_tlff.tlff033,g_tlff.tlff034,
          g_tlff.tlff035,g_tlff.tlff036,g_tlff.tlff037,g_tlff.tlff04,g_tlff.tlff05,
          g_tlff.tlff06,g_tlff.tlff07,g_tlff.tlff08,g_tlff.tlff09,g_tlff.tlff10,
          g_tlff.tlff11,g_tlff.tlff12,g_tlff.tlff13,g_tlff.tlff14,g_tlff.tlff15,
          g_tlff.tlff16,g_tlff.tlff17,g_tlff.tlff18,g_tlff.tlff19,g_tlff.tlff20,
          g_tlff.tlff60,g_tlff.tlff61,g_tlff.tlff62,g_tlff.tlff63,g_tlff.tlff99, #No.7993
          g_tlff.tlff902,g_tlff.tlff903,g_tlff.tlff904,g_tlff.tlff905,g_tlff.tlff906,
          g_tlff.tlff907,g_tlff.tlff219,g_tlff.tlff220,g_tlff.tlff930,l_plant, #NO.FUN-620024  #FUN-980010   #CHI-9B0008 add tlff930
          l_legal,g_tlff.tlff012,g_tlff.tlff013                                #FUN-980010     #FUN-B90012 add tlff012,tlff013 
       IF SQLCA.sqlcode<>0 THEN
          LET g_showmsg = g_tlff.tlff01,"/",g_tlff.tlff06     #No.FUN-710046
          CALL s_errmsg('tlff01,tlff06',g_showmsg,'ins tlff:',SQLCA.sqlcode,1)   #No.FUN-710046
          LET g_success = 'N'
       END IF
     END FOR
     IF g_tlff.tlff907 <> 0 THEN                           #NO.FUN-620024
        CALL s_tlff3(p_unit,p_unit2,p_plant)               #NO.FUN-620024
     END IF                                                #NO.FUN-620024
  END IF
 
END FUNCTION

FUNCTION p820_chkoeo(p_oeo01,p_oeo03,p_oeo04)
  DEFINE p_oeo01 LIKE oeo_file.oeo01
  DEFINE p_oeo03 LIKE oeo_file.oeo03
  DEFINE p_oeo04 LIKE oeo_file.oeo04
 #DEFINE l_sql   LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(500)   #CHI-940042 mark
  DEFINE l_sql   STRING                 #CHI-940042 
 
  #LET l_sql=" SELECT COUNT(*) FROM ",l_dbs_new,"oeo_file ",
  LET l_sql=" SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new,'oeo_file'), #FUN-A50102
            "  WHERE oeo01 = '",p_oeo01,"'",
            "    AND oeo03 = '",p_oeo03,"'",
            "    AND oeo04 = '",p_oeo04,"'",
            "    AND oeo08 = '2' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
  PREPARE chkoeo_pre FROM l_sql
  DECLARE chkoeo_cs CURSOR FOR chkoeo_pre
  OPEN chkoeo_cs 
  FETCH chkoeo_cs INTO g_cnt
  IF g_cnt > 0 THEN RETURN 1 ELSE RETURN 0 END IF
END FUNCTION 
 
#No.7993 取得多角序號
FUNCTION p820_flow99()
     IF cl_null(g_oga.oga99) THEN
        CALL s_flowauno('oga',g_oea.oea904,g_oga.oga02)
             RETURNING g_sw,g_flow99
        IF g_sw THEN
           CALL s_errmsg('','','','tri-011',1) #No.FUN-710046
           LET g_success = 'N' RETURN
        END IF
        UPDATE oga_file SET oga99 = g_flow99 WHERE oga01 = g_oga.oga01
        IF SQLCA.SQLCODE THEN
           CALL s_errmsg('oga01',g_oga.oga01,'upd oga99',SQLCA.SQLCODE,1)               #No.FUN-710046
           LET g_success = 'N' RETURN
        END IF
        #更新INVOICE ofa99
        IF NOT cl_null(g_oga.oga27) AND g_oax.oax04='Y' THEN  #NO.FUN-670007
           UPDATE ofa_file SET ofa99= g_flow99 WHERE ofa01 = g_oga.oga27
           IF SQLCA.SQLCODE THEN
              CALL s_errmsg('ofa01',g_oga.oga27,'upd ofa99',SQLCA.SQLCODE,1)               #No.FUN-710046
              LET g_success = 'N' RETURN
           END IF
        END IF
#NO.FUN-670007 mark 在axmt850確認時己處理出通單拋轉
        #馬上檢查是否有搶號
        LET g_cnt = 0 
        SELECT COUNT(*) INTO g_cnt FROM oga_file 
         WHERE oga99 = g_flow99 AND oga09 = '4'
        IF g_cnt > 1 THEN
           CALL s_errmsg('','','','tri-011',1)  #No.FUN-710046
           LET g_success = 'N' RETURN
        END IF
     END IF
END FUNCTION 
 
#因為各單據的xxx99欄位在資料庫非Unique,
#所以為了安全還是給它檢查一下
FUNCTION p820_chk99()
 #DEFINE l_sql LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(500)   #CHI-940042 mark
  DEFINE l_sql STRING                 #CHI-940042 
 
     #LET l_sql = " SELECT COUNT(*) FROM ",s_dbs_tra CLIPPED,"rva_file ",  #FUN-980092 add
     LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(s_plant_new,'rva_file'), #FUN-A50102
                 "  WHERE rva99 ='",g_flow99,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,s_plant_new) RETURNING l_sql #FUN-980092
     PREPARE rvacnt_pre FROM l_sql
     DECLARE rvacnt_cs CURSOR FOR rvacnt_pre
     OPEN rvacnt_cs 
     FETCH rvacnt_cs INTO g_cnt                                #收貨單
     IF g_cnt > 0 THEN
        LET g_msg = s_dbs_tra CLIPPED,'rva99 duplicate'       #FUN-670007   #FUN-980092 add
        CALL s_errmsg('','',g_msg,'tri-011',1) #No.FUN-710046
        LET g_success = 'N'
     END IF
 
     #LET l_sql = " SELECT COUNT(*) FROM ",s_dbs_tra CLIPPED,"rvu_file ",  #FUN-980092 add
     LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(s_plant_new,'rvu_file'), #FUN-A50102
                 "  WHERE rvu99 ='",g_flow99,"'",
                 "    AND rvu00 = '1' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,s_plant_new) RETURNING l_sql #FUN-980092
     PREPARE rvucnt_pre FROM l_sql
     DECLARE rvucnt_cs CURSOR FOR rvucnt_pre
     OPEN rvucnt_cs 
     FETCH rvucnt_cs INTO g_cnt                                #入庫單
     IF g_cnt > 0 THEN
        LET g_msg = s_dbs_tra CLIPPED,'rvu99 duplicate'  #FUN-670007   #FUN-980092 add
        CALL s_errmsg('','',g_msg,'tri-011',1) #No.FUN-710046
        LET g_success = 'N'
     END IF
 
     #LET l_sql = " SELECT COUNT(*) FROM ",l_dbs_tra CLIPPED,"oga_file ",  #FUN-980092 add
     LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new,'oga_file'), #FUN-A50102 
                 "  WHERE oga99 ='",g_flow99,"'",
                 "    AND oga09 = '4' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
     PREPARE ogacnt_pre FROM l_sql
     DECLARE ogacnt_cs CURSOR FOR ogacnt_pre
     OPEN ogacnt_cs 
     FETCH ogacnt_cs INTO g_cnt                                #出貨單
     IF g_cnt > 0 THEN
        LET g_msg = l_dbs_tra CLIPPED,'oga99 duplicate'   #FUN-980092 add
        CALL s_errmsg('','',g_msg,'tri-011',1) #No.FUN-710046
        LET g_success = 'N'
     END IF
END FUNCTION
 
FUNCTION p820_ind_icd_idd_to_idb()
  DEFINE l_idd RECORD LIKE idd_file.*
  DEFINE l_idb RECORD LIKE idb_file.*
 
  LET g_success = 'Y'
 
  DECLARE p820_idd_to_idb_cs CURSOR FOR
    SELECT * FROM idd_file WHERE idd100 = g_oga.oga011
 
  FOREACH p820_idd_to_idb_cs INTO l_idd.*
     IF STATUS THEN
        CALL cl_err('p820_idd_to_idb_cs:',STATUS,0)
        LET g_success = 'N'
        EXIT FOREACH
     END IF
 
     INITIALIZE l_idb.* TO NULL
     LET l_idb.idb01 = l_idd.idd01
     LET l_idb.idb02 = l_idd.idd02
     LET l_idb.idb03 = l_idd.idd03
     LET l_idb.idb04 = l_idd.idd04
     LET l_idb.idb05 = l_idd.idd05
     LET l_idb.idb06 = l_idd.idd06
     LET l_idb.idb07 = g_oga.oga01
     LET l_idb.idb08 = l_idd.idd11
     LET l_idb.idb09 = g_oga.oga02
     LET l_idb.idb10 = l_idd.idd29
     LET l_idb.idb11 = l_idd.idd13
     LET l_idb.idb12 = l_idd.idd07
     LET l_idb.idb13 = l_idd.idd15
     LET l_idb.idb14 = l_idd.idd16
     LET l_idb.idb15 = l_idd.idd17
     LET l_idb.idb16 = l_idd.idd18
     LET l_idb.idb17 = l_idd.idd19
     LET l_idb.idb18 = l_idd.idd20
     LET l_idb.idb19 = l_idd.idd21
     LET l_idb.idb20 = l_idd.idd22
     LET l_idb.idb21 = l_idd.idd23
     LET l_idb.idb22 = ''
     LET l_idb.idb23 = ''
     LET l_idb.idb24 = ''
     LET l_idb.idb25 = l_idd.idd25
 
     LET l_idb.idbplant = g_plant   #FUN-980010
     LET l_idb.idblegal = g_legal   #FUN-980010
 
     INSERT INTO idb_file VALUES(l_idb.*)
     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
        CALL cl_err('ins idb:',SQLCA.SQLCODE,0)
        LET g_success = 'N'
        EXIT FOREACH
     END IF
  END FOREACH
END FUNCTION
 
FUNCTION p820_imgs(p_ware,p_loca,p_lot,p_date,p_rvbs,p_i)  #FUN-C80001
   DEFINE p_rvbs   RECORD LIKE rvbs_file.*
   DEFINE p_ware   LIKE imgs_file.imgs02
   DEFINE p_loca   LIKE imgs_file.imgs03
   DEFINE p_lot    LIKE imgs_file.imgs04
   DEFINE p_date   LIKE tlfs_file.tlfs111
   DEFINE p_i      LIKE type_file.num5      #FUN-C80001
   DEFINE l_imgs   RECORD LIKE imgs_file.*
   DEFINE l_tlfs   RECORD LIKE tlfs_file.*
   DEFINE l_ima25  LIKE ima_file.ima25
  #DEFINE l_sql1   LIKE type_file.chr1000   #CHI-940042 mark
  #DEFINE l_sql2   LIKE type_file.chr1000   #CHI-940042 mark
   DEFINE l_sql1,l_sql2 STRING              #CHI-940042 
   DEFINE l_n      LIKE type_file.num5
   DEFINE l_plant  LIKE type_file.chr21    #FUN-C80001

   #FUN-C80001---begin
   IF p_rvbs.rvbs00 = 'axmt820' THEN
      LET l_plant = l_plant_new
   ELSE
      LET l_plant = s_plant_new
   END IF 
   #FUN-C80001---end
 
   LET l_sql1 = "SELECT COUNT(*) ",
                #"  FROM ",l_dbs_tra CLIPPED,"imgs_file ",  #FUN-980092 add
                "  FROM ",cl_get_target_table(l_plant,'imgs_file'), #FUN-A50102 #FUN-C80001
                " WHERE imgs01='",p_rvbs.rvbs021,"' ",
                "   AND imgs02='",p_ware,"'",
                "   AND imgs03='",p_loca,"'",
                "   AND imgs04='",p_lot,"'",
                "   AND imgs05='",p_rvbs.rvbs03,"'",
                "   AND imgs06='",p_rvbs.rvbs04,"'",
                "   AND imgs11='",p_rvbs.rvbs08,"'"
  
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,l_plant) RETURNING l_sql1 #FUN-980092 #FUN-C80001
   PREPARE imgs_pre1 FROM l_sql1
   IF SQLCA.SQLCODE THEN
      IF g_bgerr THEN
         LET  g_showmsg=p_rvbs.rvbs021,"/",p_ware,"/",p_loca,"/",p_lot,"/",p_rvbs.rvbs03,"/",p_rvbs.rvbs04           
         CALL s_errmsg('imgs01,imgs02,imgs03,imgs04,imgs05,imgs06',g_showmsg,'imgs_pre',SQLCA.SQLCODE,1)
      ELSE
        CALL cl_err('imgs_pre',SQLCA.SQLCODE,1)
      END IF
   END IF
  
   DECLARE imgs_cs CURSOR FOR imgs_pre1
  
   OPEN imgs_cs
   FETCH imgs_cs INTO l_n
  
   IF l_n = 0 THEN
      LET l_imgs.imgs01 = p_rvbs.rvbs021
      LET l_imgs.imgs02 = p_ware
      LET l_imgs.imgs03 = p_loca
      LET l_imgs.imgs04 = p_lot
      LET l_imgs.imgs05 = p_rvbs.rvbs03
      LET l_imgs.imgs06 = p_rvbs.rvbs04
      LET l_imgs.imgs07 = l_ima25
      LET l_imgs.imgs08 = 0
      LET l_imgs.imgs09 = p_rvbs.rvbs05
      LET l_imgs.imgs10 = p_rvbs.rvbs07
      LET l_imgs.imgs11 = p_rvbs.rvbs08
  
      #LET l_sql2 = "INSERT INTO ",l_dbs_tra CLIPPED,"imgs_file",  #FUN-980092 add
      LET l_sql2 = "INSERT INTO ",cl_get_target_table(l_plant,'imgs_file'), #FUN-A50102  #FUN-C80001
                   "(imgs01,imgs02,imgs03,imgs04,imgs05,imgs06,",
                   " imgs07,imgs08,imgs09,imgs10,imgs11,",
                   " imgsplant,imgslegal ) ",   #FUN-980010
                   " VALUES( ?,?,?,?,?,?, ?,?,?,?,?, ?,?)"  #FUN-980010
  
 	  CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
      CALL cl_parse_qry_sql(l_sql2,l_plant) RETURNING l_sql2 #FUN-A50102 #FUN-C80001
      PREPARE ins_imgs FROM l_sql2
  
      EXECUTE ins_imgs USING l_imgs.imgs01,l_imgs.imgs02,l_imgs.imgs03,
                             l_imgs.imgs04,l_imgs.imgs05,l_imgs.imgs06,
                             l_imgs.imgs07,l_imgs.imgs08,l_imgs.imgs09,
                             l_imgs.imgs10,l_imgs.imgs11,
                             gp_plant,gp_legal   #FUN-980010
      IF SQLCA.sqlcode<>0 THEN
         LET g_msg = l_dbs_new CLIPPED,'ins imgs'
         IF g_bgerr THEN
            LET g_showmsg=p_rvbs.rvbs021,"/",p_ware,"/",p_loca,"/",p_lot,"/",p_rvbs.rvbs03,"/",p_rvbs.rvbs04           
            CALL s_errmsg('imgs01,imgs02,imgs03,imgs04,imgs05,imgs06',g_showmsg,'imgs_ins',SQLCA.SQLCODE,1)
         ELSE
            CALL cl_err("imgs_ins",SQLCA.sqlcode,1)
         END IF
         LET g_success = 'N'
      END IF
   #FUN-C80001---begin
   ELSE
      IF p_i = 0 THEN 
         LET l_sql2 = "UPDATE ", cl_get_target_table(l_plant,'imgs_file'),
                      "  SET imgs08 = imgs08 + ",p_rvbs.rvbs06, 
                      " WHERE imgs01='",p_rvbs.rvbs021,"' ",
                      "   AND imgs02='",p_ware,"'",
                      "   AND imgs03='",p_loca,"'",
                      "   AND imgs04='",p_lot,"'",
                      "   AND imgs05='",p_rvbs.rvbs03,"'",
                      "   AND imgs06='",p_rvbs.rvbs04,"'",
                      "   AND imgs11='",p_rvbs.rvbs08,"'"
                      
 	     CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2       
         CALL cl_parse_qry_sql(l_sql2,l_plant) RETURNING l_sql2 
         PREPARE upd_imgs FROM l_sql2

         EXECUTE upd_imgs

         IF SQLCA.sqlcode<>0 THEN
            LET g_msg = l_dbs_new CLIPPED,'upd imgs'
            IF g_bgerr THEN
               LET g_showmsg=p_rvbs.rvbs021,"/",p_ware,"/",p_loca,"/",p_lot,"/",p_rvbs.rvbs03,"/",p_rvbs.rvbs04           
               CALL s_errmsg('imgs01,imgs02,imgs03,imgs04,imgs05,imgs06',g_showmsg,'imgs_upd',SQLCA.SQLCODE,1)
            ELSE
              CALL cl_err("imgs_upd",SQLCA.sqlcode,1)
            END IF
            LET g_success = 'N'
         END IF
      END IF 
   #FUN-C80001---end
   END IF  
 
   LET l_tlfs.tlfs01=p_rvbs.rvbs021       #異動料件編號
   LET l_tlfs.tlfs02=p_ware                #倉庫
   LET l_tlfs.tlfs03=p_loca                #儲位
   LET l_tlfs.tlfs04=p_lot                 #批號
   LET l_tlfs.tlfs05=p_rvbs.rvbs03         #序號
   LET l_tlfs.tlfs06=p_rvbs.rvbs04         #外部批號
  #MOD-C30663 str------
  #LET l_tlfs.tlfs07=l_ima25
   SELECT img09 INTO l_tlfs.tlfs07 FROM img_file
    WHERE img01 = l_tlfs.tlfs01 AND img02 = l_tlfs.tlfs02
      AND img03 = l_tlfs.tlfs03 AND img04 = l_tlfs.tlfs04
  #MOD-C30663 end------
   LET l_tlfs.tlfs08=p_rvbs.rvbs00
 
   CASE l_tlfs.tlfs08
      WHEN "apmt300"    #收貨單
         LET l_tlfs.tlfs09=0
      WHEN "apmt740"    #入庫單
         LET l_tlfs.tlfs09=1
      WHEN "axmt820"   #出貨單
         LET l_tlfs.tlfs09=-1
   END CASE
 
   LET l_tlfs.tlfs10=p_rvbs.rvbs01
   LET l_tlfs.tlfs11=p_rvbs.rvbs02
   LET l_tlfs.tlfs111=p_date
   LET l_tlfs.tlfs12=g_today
   LET l_tlfs.tlfs13=p_rvbs.rvbs06
   LET l_tlfs.tlfs14=p_rvbs.rvbs07
   LET l_tlfs.tlfs15=p_rvbs.rvbs08
 
   #LET l_sql2 = "INSERT INTO ",l_dbs_tra CLIPPED,"tlfs_file",  #FUN-980092 add
   LET l_sql2 = "INSERT INTO ",cl_get_target_table(l_plant,'tlfs_file'), #FUN-A50102 #FUN-C80001
                "(tlfs01,tlfs02,tlfs03,tlfs04,tlfs05,tlfs06,tlfs07,",
                " tlfs08,tlfs09,tlfs10,tlfs11,tlfs12,tlfs13,tlfs14,",
                " tlfs15,tlfs111,tlfsplant,tlfslegal)",             #FUN-980010
                " VALUES( ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?)"  #FUN-980010
 
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql(l_sql2,l_plant) RETURNING l_sql2 #FUN-A50102 #FUN-C80001
   PREPARE ins_tlfs FROM l_sql2
 
   EXECUTE ins_tlfs USING l_tlfs.tlfs01,l_tlfs.tlfs02,l_tlfs.tlfs03,
                          l_tlfs.tlfs04,l_tlfs.tlfs05,l_tlfs.tlfs06,
                          l_tlfs.tlfs07,l_tlfs.tlfs08,l_tlfs.tlfs09,
                          l_tlfs.tlfs10,l_tlfs.tlfs11,l_tlfs.tlfs12,
                          l_tlfs.tlfs13,l_tlfs.tlfs14,l_tlfs.tlfs15,
                          l_tlfs.tlfs111,
                          gp_plant,gp_legal   #FUN-980010
 
   IF SQLCA.sqlcode<>0 THEN
      IF g_bgerr THEN
        LET g_showmsg=l_tlfs.tlfs01,"/",l_tlfs.tlfs12
        CALL s_errmsg('tlfs01,tlfs06',g_showmsg,'ins tlfs:',SQLCA.sqlcode,1)
      ELSE
        CALL cl_err('ins tlfs:',SQLCA.sqlcode,1) 
      END IF
      LET g_success = 'N'
   END IF
   
END FUNCTION
#No:FUN-9C0071--------精簡程式----- 
