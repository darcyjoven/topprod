# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: abmi720.4gl
# Descriptions...: ECN資料維護作業
# Date & Author..: 97/08/21 By Roger
# Modify.........: 03/03/11 By Carol For bugno:6845
# Modify.........: No:7827 03/08/18 By Mandy ECN確認, update bmb_file 時應以ECN單頭生效日做為舊料的失效日
# Modify.........: No:7836 03/08/19 By Mandy ECN輸入時應check底數不可不輸入,可default 1
# Modify.........: No:7840 03/08/19 By Mandy ECN '取代'時, ECN單號應僅記錄於新料即可
# Modify.........: No:7857 03/08/20 By Mandy  呼叫自動取單號時應在 Transction中
# Modify.........: No:7826 03/08/27 By Mandy 單身 ^Y 的細項 gui 畫面, 料換算率輸入(修)後, 再按mouse 到工程圖號欄其料換算率的修改後值, 會恢復.並建議, 增加庫存單位顯示
# Modify.........: No:7958 03/08/27 By Mandy abmi710b.per欄位插件位置bmy13應同abmi600的bmb13為NOENTRY
# Modify.........: No:9810 04/07/30 By ching 已phase料件應不可輸入bom單身
# Modify.........: No:9806 04/07/30 By ching 增加"工單展開選項"可修改,並defualt
# Modify.......... No.MOD-490449 04/09/24 By ching add ima147 處理
# Modify.........: No.MOD-4A0031 04/10/04 By Nicola Select 語法錯誤
# Modify.........: No.MOD-4A0044 04/10/05 By ching 明細資料於'a' OR 'u' 皆可INPUT
# Modify.........: No.MOD-4A0063 04/10/05 By Mandy q_ime 的參數傳的有誤
# Modify.........: No.FUN-4A0038 04/10/11 By Carol 查尋時, ECN單號要開窗
# Modify.........: No.FUN-4A0038 04/10/12 By Mandy 變異主件料號應開bom之主件,而不是開料件資料
# Modify.........: No.FUN-4A0079 04/10/13 By Mandy 單身變異之元件料號開窗,只能show 次元件的料號
# Modify.........: No.MOD-4A0213 04/10/14 By Mandy q_imd 的參數傳的有誤
# Modify.........: No.MOD-430879 04/10/26 By Mandy 維護完備註後要能立即show在單頭上
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.MOD-4B0191 04/11/19 By Mandy 插件位置是否勾稽是由參數設定(aimi100)來決定, 'Y'則不match不可離開
# Modify.........: No.FUN-4C0054 04/12/09 By Mandy Q,U,R 加入權限控管處理
# Modify.........: No.MOD-510100 05/01/13 By ching add ins bmz
# Modify.........: No.MOD-530014 05/03/22 By kim   新增料件時 ,  abmi600 中1. 料件單位 2.損耗率 會不見
# Modify.........: No.MOD-530305 05/04/04 By kim   數點Bug&邏輯修正
# Modify.........: No.FUN-540045 05/04/22 By pengu TIPTOP & EasyFlow整合程式修改
# Modify.........: No.FUN-550040 05/05/13 By Echo  新增 TIPTOP 與 EasyFlow 整合
# Modify.........: No.FUN-550014 05/05/17 By Mandy 因特性BOM功能,增加bmy29,bmy30
# Modify.........: No.FUN-550032 05/05/20 By wujie 單據編號加大
# Modify.........: No.MOD-560007 05/06/02 By Echo  重新定義整合FUN名稱
# Modify.........: No.FUN-560021 05/06/07 By kim   配方BOM,視情況 隱藏/顯示 "特性代碼"欄位
# Modify.........: No.FUN-540011 05/06/14 By pengu 列印時,請多加ECN變更影響請購/採購/收貨一覽表功能,可直接列印
# Modify.........: No.FUN-560115 05/06/21 By kim 主件範圍增加開窗的功能
# Modify.........: No.FUN-560219 05/06/24 By Mandy 1.sma118設定不使用特性BOM功能時請將'bmy29','bmy30'隱藏
# Modify.........: No.FUN-560227 05/06/27 By kim 將組成用量/底數/QPA全部alter成 DEC(16,8)
# Modify.........: No.FUN-570110 05/07/14 By jackie 修正建檔程式key值是否可更改
# Modify.........: No.FUN-580161 05/08/24 By yiting 以 EF 為 backend engine, 由TIPTOP 處理前端簽核動作
# Modify.........: No.MOD-610013 06/01/05 By Claire sub-143(6) 造成無窮迴路
# Modify.........: No.FUN-610051 06/01/09 By Cliare 單身輸入畫面,增加放棄action
# Modify.........: No.TQC-610068 06/01/20 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.TQC-630070 06/03/07 By Dido 流程訊息通知功能
# Modify.........: No.FUN-630044 06/03/16 By Alexstar 新增「申請人」欄位
# Modify.........: No.TQC-630177 06/03/17 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-640241 06/04/25 By Echo 自動執行確認功能
# Modify.........: No.MOD-650040 06/05/09 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-650090 06/05/30 By kim bmy03='4',於新料bmy27 輸入時  add abm-728 warning
# Modify.........: No.FUN-650090 06/06/13 By douzh cl_err---->clerr3
# Modify.........: No.TQC-660072 06/06/15 By Dido 補充TQC-630070
# Modify.........: No.TQC-670008 06/07/05 By kim 將 g_sys 變數改成寫死系統別(要大寫)
# Modify.........: No.MOD-660086 06/07/05 By Sarah 查詢一筆未確認的單號後按新增再放棄,再按作廢,之前查詢的那筆會被作廢掉
# Modify.........: No.MOD-670095 06/07/25 By Pengu 1.單據未確認成功,而單身卻已經ECN變更成功,是錯誤的
                                 #                 2.單身使用預設上筆資料功能時,應要再做合理性檢查~~
# Modify.........: No.MOD-680068 06/08/22 By claire axm-108 LET g_succes ='N'
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-690022 06/09/14 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0002 06/10/20 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.CHI-6A0007 06/11/03 By rainy  遇多元件時要先詢問是否要更新
# Modify.........: No.CHI-6A0036 06/11/14 By rainy  判斷停產時，要再一併判斷生效日(ima1401)
# Modify.........: No.FUN-6B0033 06/11/14 By hellen 新增單頭折疊功能
# Modify.........: No.MOD-6C0019 06/12/06 By pengu 單身異動別為"2:新增元件"，BOM項次不可輸入
# Modify.........: No.MOD-690056 06/12/07 By claire 不可強迫給值 LET g_succes ='N' 會造成程式邏輯不流暢
# Modify.........: No.MOD-6A0082 06/12/07 By claire 作業編號無法開啟qry
# Modify.........: No.MOD-6A0109 06/12/12 By carol 設變時應考慮最大生失效日期的檢查
# Modify.........: No.TQC-6C0061 06/12/13 By Sarah 單身的變異別為3.修改時，如果變動的料號設為有輸入插件位置的話，會在輸入完相關的資料後當出
# Modify.........: No.TQC-6C0083 06/12/15 By Sarah 當單身的變異別輸入的是2.新元件新增生效時,執行確認程式會當出
# Modify.........: No.MOD-710092 07/01/22 By pengu 1.新增時bmy20不可為NULL
# Modify.........: No.TQC-720003 07/02/08 By pengu 修改確認段的transacion寫法
# Modify.........: No.TQC-720042 07/02/26 By jamie DEFINE有誤 chr1->num10
# Modify.........: No.CHI-710048 07/02/27 By rainy 取代料順序移到變異元件之後
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740009 07/04/03 By pengu 確認時應該UPDATE bmamodu,bmadate兩個欄位
# Modify.........: No.MOD-740184 07/04/23 By rainy 有指定項次時不訊問是否變更同料號其他項次
# Modify.........: No.TQC-740283 07/04/24 By Echo 由 ERP 簽核時，在最後一關選擇同意後，無執行確認段 
# Modify.........: No.MOD-740186 07/04/25 By kim 為何我有指定ECR單號,為何在打單身時可以打並非在ECR指定的主件編號呢?
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-750147 07/05/24 By jamie 單身異動別選'4'取代, 在輸入變異元件料號時會有(100)訊息(事實上是開窗挑選出來存在的料號), 但仍可繼續輸入
# Modify.........: No.MOD-760037 07/06/15 By pengu 單身打相同的主件和元件料號但BOM項次不一樣時,會出現abm-806錯誤訊息
# Modify.........: No.CHI-790004 07/09/03 By kim 新增段PK值不可為NULL
# Modify.........: No.MOD-790002 07/09/03 By Joe 程式段INSERT時,增加欄位(PK)預設值
# Modify.........: No.MOD-790129 07/10/08 By Pengu 確認時會出現insert bmz 不能為null值的錯誤
# Modify.........: No.MOD-790089 07/10/08 By Pengu 主件組成用量與底數不可小於零
# Modify.........: No.TQC-7B0079 07/11/14 By Rayven 工程變更單無法審核，提示插入數據庫錯誤！
# Modify.........: No.MOD-7B0213 07/11/26 By Pengu CALL cl_confirm('abm-023')之前應先判斷g_action_choice = "confirm"
# Modify.........: No.MOD-780260 07/11/26 By Pengu 輸入主件編號時應判斷是否存在bmb_file中
# Modify.........: No.FUN-810014 08/01/09 By arman 修改為服飾版
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-820027 08/03/03 By xiaofeizhu 資料中心功能
# Modify.........: No.MOD-830180 08/04/24 By claire 選取單位後,回傳值為空
# Modify.........: No.MOD-810191 08/03/24 By Pengu 若不指定項次遇到不同作業編號但相同料號的元件應考慮作業編號
# Modify.........: No.MOD-830242 08/03/31 By judy 去掉特性代碼后的空格
# Modify.........: NO.FUN-840018 08/04/07 BY yiting 增加一個頁面放置清單資料
# Modify.........: NO.FUN-840033 08/04/17 BY Yiting 存在相同主件+元件資料且未確認單據時，沒有控管
# Modify.........: No.MOD-840284 08/04/20 By Pengu 按確認未有反應也沒有show錯誤訊息
# Modify.........: No.FUN-840138 08/04/21 By xiaofeizhu 資料中心功能增加bmy14的管控
# Modify.........: NO.MOD-840420 08/04/24 by yiting 確認時要先檢查是否有其它單據有相同的主件+元件資料未確認
# Modify.........: NO.MOD-840426 08/04/28 BY yiting 單身加上代買料否欄位 
# Modify.........: NO.MOD-840436 08/04/28 BY arman 增加"特性代碼"控制輸入 
# Modify.........: NO.FUN-850017 08/04/28 BY arman 若變更的主件料號bmy14為款式,bmb02料則回寫bmy33中, 若不是款式料，則不需要
                                                  #若bmy14不為款式料，則在insert bmb_file時,增加bmb33(款式BOM項次)的處理
# Modify.........: No.MOD-860126 08/06/18 By claire 單身維護"新元件明細"修改損耗率沒寫入資料
# Modify.........: NO.MOD-860323 08/06/28 BY claire m_ac變數定義調整
# Modify.........: No.MOD-840645 08/07/10 By Pengu 開放在新增元件時可以指定BOM項次的功能
# Modify.........: No.MOD-840100 08/07/13 By Pengu 維護多插件位置"裡的 擷取原插件位置功能無反應
# Modify.........: No.FUN-870127 08/07/24 By arman 服飾版
#                                         BY ve007 解決單身筆數變更，某些欄位不能錄入的問題
# Modify.........: No.FUN-880021 08/08/14 By sherry 增加單頭action "維護多插件位置資料"
# Modify.........: No.CHI-880031 08/09/09 By xiaofeizhu 查出資料后,應該停在第一筆資料上,不必預設是看資料清單,有需要瀏覽,再行點選
# Modify.........: No.CHI-890025 08/09/19 By claire 單身before input控制欄位開關應放在before row
# Modify.........: No.FUN-870117 08/10/17 by ve007 解決下階料的新增問題
# Modify.........: 08/10/28 FUN-8A0127 by ve007 舊元件失效更新固定屬性檔的問題
# Modify.........: 08/10/29 FUN-8A0128 by ve007 過單
# Modify.........: No.MOD-8B0109 08/11/14 By Pengu ECN做就原件修改時，取替代特性應帶原BOM的值
# Modify.........: No.MOD-8C0026 08/12/03 By claire 單據確認不會出現核的圖案
# Modify.........: No.CHI-8C0049 08/12/26 By claire 變更後的元件不可以主件相同
# Modify.........: No.MOD-910180 09/01/16 By jan解決輸完組成用量后,會開窗要求輸入插件位置, 但插件位置輸完后,組成用量卻又被清空的問題
# Modify.........: No.MOD-910205 09/01/17 By claire 修改元件時,若沒維護插件位置,變更後不會回寫bmt_file
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING   
# Modify.........: No.MOD-920076 09/02/05 By claire bmy11,bmy25,bmy26,bmy21,bmy23需給值
# Modify.........: No.TQC-920056 09/02/20 By xiaofeizhu p_level的定義類型改為數值型，單身的產生功能加上特性代碼(bma06,bmb29)，bmy14管控的修改
# Modify.........: No.MOD-940135 09/04/10 By Dido i720_s2()中bmd_file不需要新增
# Modify.........: No.MOD-940143 09/04/10 By Dido 產品結構項次(bmy04) + 主件編號(bmy14) 不可重複
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.MOD-950076 09/05/11 By chenyu 組成用量會變成0
# Modify.........: No.MOD-930307 09/05/25 By Pengu INSERT INTO bmd_file時未給 bmdacti default值
# Modify.........: No.MOD-940061 09/05/25 By Pengu ima105是"是否為軟體物件", 對到bmb_file 應為bmb27
# Modify.........: No.MOD-920358 09/05/25 By Pengu 在新增bmb_file時bmb10_fac2都是預設1，應要算bmb10與ima86的轉換率
# Modify.........: No.MOD-950243 09/05/25 By mike 在變異的主件欄位(AFTER FIELD bmy14)之后檢查主件是否存在bma_file中且須是有效(bmaacti='Y')的，
# Modify.........: No.CHI-960004 09/07/26 By jan 變異碼 欄位 加選項5：替代                                                若不存在或是無效的請show錯誤訊息
# Modify.........: No.FUN-980001 09/08/06 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-980075 09/09/09 By mike ECN變易方式選擇4.取代時，應控管變異元件料號不可與新元件料號相同                   
# Modify.........: NO.FUN-990069 09/10/12 By baofei 增加子公司可新增資料的檢查  
# Modify.........: No:CHI-960045 09/11/27 By sabrina 單身的備註欄位也開放可維護
# Modify.........: No:FUN-9C0077 09/12/16 By baofei 程序精簡
# Modify.........: No:TQC-9C0129 09/12/17 By lilingyu AFTER FIELD bmy03處判斷條件漏寫
# Modify.........: No:FUN-950045 10/01/05 By jan 撈取或檢查bmr_file時，多加bmr_file.確認碼='Y'的條件
# Modify.........: No:MOD-A10114 10/01/18 By Pengu 做替代時，ECN變更單單身組成用量應代表是替代量
# Modify.........: No:CHI-920021 10/01/26 By shiwuying 單身變異時，自動帶出原值
# Modify.........: No.CHI-9C0054 10/02/25 By vealxu 新增申請部門欄位
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-A30027 10/03/08 by destiny 录入ece单号时只能录审核过的资料
# Modify.........: No:CHI-A30011 10/03/18 By Sarah 改變4.取代時bmy06/bmy07兩欄位的給值
# Modify.........: No:MOD-A30171 10/03/29 By Summer 還原MOD-740186,因為ECR單號是memo用,不應該拿來勾稽
# Modify.........: No:MOD-A30170 10/03/30 By Summer bmx05開窗改成q_bmr1
# Modify.........: No:MOD-A40058 10/04/13 By Sarah 當變更別為4時bmy06與bmy07不卡必輸
# Modify.........: No:MOD-A40123 10/04/21 By Sarah 將i720_set_no_entry_b()段MOD-A40058增加程式mark
# Modify.........: No:CHI-A50018 10/05/17 By Summer 修改維護多插件位置抓bmt_file的where條件
# Modify.........: No:MOD-A50172 10/05/25 By Sarah 產生action裡的主件開窗改成q_bma41
# Modify.........: No:FUN-A60031 10/06/24 By destiny 增加平行工艺逻辑
# Modify.........: No:CHI-A60028 10/06/25 By Summer 增加欄位bmy35,ECN變更單確認時,將bmy35寫入bmb14裡    
# Modify.........: No:FUN-A60083 10/07/05 By destiny 修改平行工艺逻辑
# Modify.........: No:MOD-A70152 10/07/20 By Sarah bmy08不應拿ima562來當預設值
# Modify.........: No:CHI-A70013 10/07/27 By Summer 進入單身後右邊增加ACTION mntn_desc(維護說明資料)
# Modify.........: No:FUN-A70125 10/07/28 By lilingyu 平行工藝
# Modify.........: No:MOD-A80105 10/08/13 By sabrina 單身元件有做異動時要重帶"工單開立展開選項"、"發料單位"……等欄位 
# Modify.........: No.FUN-950057 10/08/25 By vealxu gew03 = '1'時,確認時自動拋轉
# Modify.........: No:MOD-A80227 10/08/27 By sabrina 在i720_b_more()裡修改完後若按"放棄"時，值並沒有恢復 
# Modify.........: No:MOD-A90151 10/09/23 By Summer FUNCTION i720_g_b()在INSERT INTO bmy_file前,需增加i720_b_more()段bmy變數的給值
# Modify.........: No:MOD-A90160 10/09/27 By sabrina (1)bmb23的預設值應該100 
#                                                    (2)bmy16應該在新增狀態才給值
# Modify.........: No:CHI-A80054 10/09/28 By Summer 加上abm-205訊息的檢查
# Modify.........: No:MOD-A90179 10/09/28 By sabrina 按"整批產生"、"整批取消"時，畫面的值應一致
# Modify.........: No.FUN-AA0059 10/10/25 By vealxu 全系統料號開窗及判斷控卡原則修
# Modify.........: No.FUN-AA0059 10/10/26 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.MOD-AB0029 10/11/03 By zhangll 修正sql错误导致未更新abmi600
# Modify.........: No.FUN-AB0058 10/11/15 By yinhy 倉庫權限使用控管修改
# Modify.........: No:MOD-A50119 10/11/23 By sabrina  1.單身產生的主件開窗查詢應要能多選
#                                                     2.單身產生的整批產生與整批取消沒作用
# Modify.........: No:MOD-AC0029 10/12/03 By sabrina 當bmy03='4'時，bmy16只顯示"0"和"1"的選項
# Modify.........: No:TQC-AC0175 10/12/14 By jan 調整程式顯示名稱
# Modify.........: No.TQC-AC0171 10/12/15 By vealxu 1.abmi710/720的ECR開窗，應該過濾﹧檢查bmr50='1'的資料
#                                                   2.abmi711/721的ECR開窗，應該過濾﹧檢查bmr50='2'的資料
#                                                   3.當變更別='舊元件修改'，輸完單身元件料號後，bmy35沒自動帶出舊值
#                                                   4.輸完單身後跳出abmi710b的視窗，委外代買(bmy34)的欄位應該要拿掉
#                                                   5.列印"本張單據列印"，BOM類別沒印出值
# Modify.........: No:TQC-AC0300 10/12/20 By zhangll 修改固定損耗量,损耗批量
# Modify.........: No.FUN-AC0075 11/01/06 By vealxu brb081,brb082確認時沒有更新
# Modify.........: No:MOD-B30705 11/03/30 By sabrina 當bmy03='5'時，bmy16應顯示全部
# Modify.........: No:MOD-B50058 11/05/10 By vampire 若組成用量為null時，則給值"1"
# Modify.........: No.FUN-B50062 11/05/16 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.......... No:MOD-B60018 11/06/02 By sabrina i720sub_s3()少回傳bmb.bmb10_fac2
# Modify.........: No:FUN-A80017 11/07/05 By Mandy PLM GP5.1追版至GP5.25-----str-----
# Modify.........: No:FUN-A80017 10/08/06 By Mandy PLM的程式aws_create_ecn_data.4gl 會呼叫共用此程式的確認段之相關調整
# Modify.........: No:TQC-AA0004 10/10/12 By Mandy 補強PLM的程式aws_create_ecn_data.4gl 會呼叫共用此程式的確認段()之當變異別為:"3.舊元件修改"=>產生插件位置bmt_file有誤
# Modify.........: No:FUN-AB0038 10/11/10 By Mandy (1)CreateECNData=>產生的ECN無法做自動確認
#                                                  (2)是否與PLM整合(aza121)='Y'時,若由abmi720修正BOM,應同由PLM拋ECN做BOM修正的邏輯一致
# Modify.........: No:FUN-AC0060 10/12/21 By Mandy PLM-資料中心:將原abmi720.4gl確認段拆解至abmi720sub_sub.4gl中
#                                                  g_argv3改成g_argv3_str
# Modify.........: No:FUN-A80017 11/07/05 By Mandy PLM GP5.1追版至GP5.25-----end-----
# Modify.........: No:MOD-B70091 11/07/12 By Vampire 增加 DISPLAY BY NAME g_bmy[l_ac].bmy34, g_bmy[l_ac].bmy35
# Modify.........: No:TQC-B70052 11/07/13 By lilingyu 消耗件否欄位bmy15後的邏輯前後矛盾
# Modify.........: No:MOD-B70105 11/07/13 By houlia 取消組成用量負數控管
# Modify.........: No:MOD-B40254 11/07/17 By Vampire 單身抓出來的主件底數和bom不一致
# Modify.........: No:FUN-B70022 11/07/21 By Abby mark多餘程式段(for EF) 
# Modify.........: No:MOD-B70207 11/07/22 By Vampire 還原 TQC-B70052 的修改
# Modify.........: No.FUN-B80100 11/08/10 By fengrui  程式撰寫規範修正
# Modify.........: No:FUN-B80071 11/08/19 By Abby 調整EF自動確認功能
# Modify.........: No:MOD-B90120 11/09/16 By johung mark BEFORE FIELD bmy04
# Modify.........: No:MOD-B90142 11/09/22 By johung 開啟abmi710b的預設值存入舊值
# Modify.........: No:TQC-BA0108 11/10/18 By houlia 單身抓取的組成用量跟bom的不一致
# Modify.........: No:MOD-BC0045 11/12/08 By ck2yuan 調整維護插件位置的檢核
# Modify.........: No:FUN-BB0086 11/12/08 By tanxc 增加數量欄位小數取位
# Modify.........: No:MOD-BC0191 12/01/12 By ck2yuan 調整 選取或取消 顯示Y/N之錯誤
# Modify.........: No:CHI-C10033 12/01/16 By ck2yuan AFTER FIELD bmy05 當變異別為1,3帶出特性 變異別為5則不給bmy06,bmy07預設值
#                                                    AFTER FIELD bmy35 當變異別為4 不給bmy06預設值
# Modify.........: No:FUN-C20011 12/02/04 By Abby EF功能調整-客戶不以整張單身資料送簽問題
# Modify.........: No:MOD-C20093 12/02/09 By ck2yuan 在i720_b_more()增加計算bmy_fac2
# Modify.........: No:FUN-C20048 12/02/10 By tanxc 增加數量欄位小數取位
# Modify.........: No:TQC-C20144 12/02/14 By zhangll 組成用量底數修改狀態變1調整
# Modify.........: No:MOD-C20195 12/02/28 By Elise 變異別為替代時，被替代料與替代料不應相同
# Modify.........: No:MOD-C20154 12/03/03 By ck2yuan 在確認段檢查新增元件是否有維護元件明細資料,給bmy21預設值 N
# Modify.........: No:CHI-C10023 12/03/08 By ck2yuan 依變異別,修改插件數量判斷
# Modify.........: No.MOD-C30639 12/03/13 By xianghui 變異別為1/3時，特性(bmy35)應帶bmb14
# Modify.........: No.MOD-C30692 12/03/14 By tanxc 將EXIT INPUT mark 使其擷取之後仍可繼續維護  
# Modify.........: No.TQC-C40119 12/04/16 By fengrui 調整插件位置錄入開窗時機
# Modify.........: No:MOD-C40150 12/04/19 By ck2yuan 當bmy03='5'時，bmy16應顯示選項只有2,5 不然會有abm-037錯誤
# Modify.........: No.CHI-C30002 12/05/15 By yuhuabao 離開單身時若單身無資料則提示是否刪除單頭
# Modify.........: No:MOD-C50226 12/05/29 By suncx 當變異碼為3：舊元件更改時，則bmy20的值應該給bmb19
# Modify.........: No:FUN-C30035 12/06/13 By bart 增加7.規格替代 9.配方替代
# Modify.........: No:MOD-B90281 12/06/18 By ck2yuan 判斷單身資料是否重複時sql有問題
# Modify.........: No:TQC-C60180 12/06/27 By lixh1 原來對bmy35的判斷改為判斷bmy03 
# Modify.........: No:FUN-C30085 12/07/05 By nanbing CR改串GR
# Modify.........: No:CHI-C30066 12/07/12 By bart 除新增元件外，有指定項次且不可維護元件編號
# Modify.........: No:TQC-C80066 12/08/10 By chenjing 當bmy03='1’時，bmy16,bmy35,bmy30不可以輸
# Modify.........: No:TQC-C80065 12/08/13 By chenjing 修改錄入特性代碼以後報錯信息
# Modify.........: No:CHI-C20060 12/09/18 By bart 類別增加替代變更，變更替代量，替代只能打替代量，回寫abmi604
# Modify.........: No:CHI-C80063 12/10/25 By bart 增加"查詢新元件明細資料"
# Modify.........: No:FUN-BB0075 12/11/05 By bart 1.變異別6.替代變更時，打完主件+元件+替代料，自動帶入bmd07給bmy06
#                                                 2.增加欄位"替代失效日期" ，變異別=6時才可輸入，bmy36有值時，bmy06,bmy07不可異動
# Modify.........: No:MOD-CB0068 12/11/23 By Elise 將q_bmb6開窗多回傳項次，並帶入bmy04
# Modify.........: No:MOD-CB0044 12/11/23 By Elise 調整sql語法
# Modify.........: No.CHI-C80041 12/11/26 By bart 取消單頭資料時刪除相關table
# Modify.........: No:MOD-CB0238 12/11/30 By Elise 修正更改項次(組成用量不同)，不會更新的問題
# Modify.........: No:FUN-D10093 13/01/23 By Abby  1.PLM BOM項次一致問題:單身新增欄位-PLM BOM項次[bmy36]/PLM KEY[bmy37]欄位
#                                                    (1)當aoos010欄位"是否與PLM整合[aza121=Y]"打勾時,才show出此欄位
#                                                    (2)此欄位NO ENTRY,僅能DISPLAY
#                                                  2.當和PLM整合時,自已打ECN單做元件修改,失效需將PLM BOM項次/PLM KEY 由BOM(abmi600)的bmb36/bmb37 default帶入bmy361/bmy37 
# Modify.........: No:CHI-CA0035 13/01/28 By Elise 調整參數避免串查錯誤,g_argv1:固定參數 g_argv2:單號 g_argv3:執行功能
# Modify.........: No:MOD-D10278 13/01/30 By bart bmy21 bmy23給預設值
# Modify.........: No:CHI-B40031 13/02/01 By Alberti (1)特性代碼改為開窗型態
#                                                    (2)單身的元件在輸入時會依特性代碼不同而顯示不同的元件資料
# Modify.........: No:CHI-D20010 13/02/19 By yangtt 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:MOD-D10188 13/02/21 By fengmy 串查畫面打不開
# Modify.........: No:FUN-D40030 13/04/07 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:TQC-D40025 13/04/12 By xumm 修改FUN-D40030遗留问题
# Modify.........: No:MOD-D40076 13/04/12 By bart 新增替代時，預帶組成用量與底數為1。
# Modify.........: No.FUN-D40103 13/05/07 By fengrui 添加庫位有效性檢查

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../../sub/4gl/s_data_center.global"   #No.FUN-820027
#FUN-AC0060---add----str---
GLOBALS "../4gl/abmi720.global"                               
#FUN-AC0060---add----end---
 
#FUN-AC0060--mark---str----
#挪至abmi720.global內
#DEFINE
#    g_bmx   RECORD LIKE bmx_file.*,
#    g_bmx_t RECORD LIKE bmx_file.*,
#    g_bmx_o RECORD LIKE bmx_file.*,
#    g_bmx01     LIKE bmx_file.bmx01,     
#    g_level     LIKE type_file.num5,      #No.FUN-680096 SMALLINT,
#    b_bmy   RECORD LIKE bmy_file.*,
#    #CHI-A70013 add --start--
#    b_bmf   RECORD LIKE bmf_file.*,
#    g_bmf_t        RECORD    #程式變數(Prinram Variables)
#                        bmf03    LIKE bmf_file.bmf03,
#                        bmf04    LIKE bmf_file.bmf04
#                   END RECORD,
#   #CHI-A70013 add --end--
#   g_bmy   DYNAMIC ARRAY OF RECORD    #程式變數(Prinram Variables)
#       		bmy02	LIKE bmy_file.bmy02,
#       		bmy03	LIKE bmy_file.bmy03,
#       		bmy19	LIKE bmy_file.bmy19,
#       		bmy04	LIKE bmy_file.bmy04,
#       		bmy14	LIKE bmy_file.bmy14,
#       		ima02d	LIKE ima_file.ima02,
#       		ima021d	LIKE ima_file.ima021,
#       		bmy011  LIKE bmy_file.bmy011,   #No.FUN-A60031
#       		bmy012  LIKE bmy_file.bmy012,   #No.FUN-A60031
#       		bmy013  LIKE bmy_file.bmy013,   #No.FUN-A60031
#       		bmy171  LIKE bmy_file.bmy171,  #bugno:6845 add
#       		bmy17	LIKE bmy_file.bmy17,
#       		bmy29	LIKE bmy_file.bmy29, #FUN-550014 add bmy29
#       		bmy05	LIKE bmy_file.bmy05,
#       		ima02	LIKE ima_file.ima02,
#       		ima021	LIKE ima_file.ima021,
#       		bmy27	LIKE bmy_file.bmy27,   #bugno:6845 add
#       		ima02n	LIKE ima_file.ima02,   #bugno:6845 add
#       		ima021n	LIKE ima_file.ima021,  #bugno:6845 add
#       		bmy16	LIKE bmy_file.bmy16,
#       		bmy35	LIKE bmy_file.bmy35, #CHI-A60028 add
#       		bmy30	LIKE bmy_file.bmy30, #FUN-550014 add bmy30
#       		bmy06	LIKE bmy_file.bmy06,
#       		bmy07	LIKE bmy_file.bmy07,
#                       bmy34   LIKE bmy_file.bmy34,  #no.MOD-840426 
#       		bmy22	LIKE bmy_file.bmy22
#                   END RECORD,
#   g_bmy_t         RECORD
#       		bmy02	LIKE bmy_file.bmy02,
#       		bmy03	LIKE bmy_file.bmy03,
#       		bmy19	LIKE bmy_file.bmy19,
#       		bmy04	LIKE bmy_file.bmy04,
#       		bmy14	LIKE bmy_file.bmy14,
#       		ima02d	LIKE ima_file.ima02,
#       		ima021d	LIKE ima_file.ima021,
#       		bmy011  LIKE bmy_file.bmy011,   #No.FUN-A60031
#       		bmy012  LIKE bmy_file.bmy012,   #No.FUN-A60031
#       		bmy013  LIKE bmy_file.bmy013,   #No.FUN-A60031			
#       		bmy171  LIKE bmy_file.bmy171,  #bugno:6845 add
#       		bmy17	LIKE bmy_file.bmy17,
#       		bmy29	LIKE bmy_file.bmy29, #FUN-550014 add bmy29
#       		bmy05	LIKE bmy_file.bmy05,
#       		ima02	LIKE ima_file.ima02,
#       		ima021	LIKE ima_file.ima021,
#       		bmy27	LIKE bmy_file.bmy27,   #bugno:6845 add
#       		ima02n	LIKE ima_file.ima02,   #bugno:6845 add
#       		ima021n	LIKE ima_file.ima021,   #bugno:6845 add
#       		bmy16	LIKE bmy_file.bmy16,
#       		bmy35	LIKE bmy_file.bmy35, #CHI-A60028 add
#       		bmy30	LIKE bmy_file.bmy30, #FUN-550014 add bmy30
#       		bmy06	LIKE bmy_file.bmy06,
#       		bmy07	LIKE bmy_file.bmy07,
#                       bmy34   LIKE bmy_file.bmy34,  #no.MOD-840426 
#       		bmy22	LIKE bmy_file.bmy22
#                   END RECORD,
#   g_bmw           DYNAMIC ARRAY OF RECORD    #程式變數(Prinram Variables)
#       		bmw04	LIKE bmw_file.bmw04,
#       		bmw05	LIKE bmw_file.bmw05
#                   END RECORD,
#   g_bmw_t         RECORD    #程式變數(Prinram Variables)
#       		bmw04	LIKE bmw_file.bmw04,
#       		bmw05	LIKE bmw_file.bmw05
#                   END RECORD,
#   g_ima           DYNAMIC ARRAY OF RECORD    #程式變數(Prinram Variables)
#       		choice  LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(01),
#       		ima01	LIKE ima_file.ima01,
#       		ima02	LIKE ima_file.ima02,
#       		ima021	LIKE ima_file.ima021,
#       		bma05	LIKE bma_file.bma05
#                   END RECORD,
#   b_bmb           DYNAMIC ARRAY OF RECORD    #程式變數(Prinram Variables)
#       		bmb01	LIKE bmb_file.bmb01,
#       		bmb29 LIKE bmb_file.bmb29                #TQC-920056 Add 
#                   END RECORD,
#   #CHI-A70013 add --start--
#   g_bmf           DYNAMIC ARRAY OF RECORD    #程式變數(Prinram Variables)
#                       bmf03    LIKE bmf_file.bmf03,
#                       bmf04    LIKE bmf_file.bmf04
#                   END RECORD,
#   #CHI-A70013 add --end--
#   b_bmw	    RECORD LIKE bmw_file.*,
#   b_bmt	    RECORD LIKE bmt_file.*,      #No.FUN-870127
#   g_last_seq      LIKE type_file.num10,  #No.FUN-680096 INTEGER,               #
#   g_bmb           RECORD LIKE bmb_file.*,
#   g_bmy05_t       LIKE bmy_file.bmy05,
#   g_bmd           RECORD LIKE bmd_file.*,
#   g_bma01         LIKE bma_file.bma01,
#   g_bma05         LIKE bma_file.bma05,
#   g_bma06         LIKE bma_file.bma06,       #TQC-920056
#   g_wc,g_wc3,g_sql  string,  #No.FUN-580092 HCN
#   g_t1            LIKE oay_file.oayslip, #No.FUN-550032  #No.FUN-680096 VARCHAR(1)
#   g_sw            LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1),
#   g_ima107	    LIKE ima_file.ima107,  #No.FUN-680096 VARCHAR(1),
#   g_flag	    LIKE ima_file.ima107,  #MOD-910205 add
#   g_ima147	    LIKE ima_file.ima147,  #No.FUN-680096 VARCHAR(1),  #MOD-490449
#   g_buf           LIKE type_file.chr20,  #No.FUN-680096 VARCHAR(20)
#   g_rec_d         LIKE type_file.num5,   #No.FUN-680096 SMALLINT, #單身筆數
#   g_rec_b         LIKE type_file.num5,   #單身筆數    #No.FUN-680096 SMALLIN
#   g_void          LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1),
#   g_approve       LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1),
#   g_confirm       LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1),
#   g_rec_t         LIKE type_file.num5,   #No.FUN-680096 SMALLINT,   #單身筆數(插件位置)
#   g_rec_e         LIKE type_file.num5,   #單身筆數  #CHI-A70013 add
#   l_ac            LIKE type_file.num5,   #目前處理的ARRAY CNT   #No.FUN-680096 SMALLINT
#   l_sl            LIKE type_file.chr1,   #No.FUN-680096 SMALLINT,  #目前處理的SCREEN LINE
#   g_argv1         LIKE bmx_file.bmx01,   #ECN No.
#   g_argv2         STRING,                #TQC-630070      #執行功能
#   g_before_input_done  LIKE type_file.num5,     #No.FUN-680096 SMALLINT
#   tm              RECORD
#            wc     LIKE type_file.chr1000,#No.FUN-680096 VARCHAR(600),
#            a      LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(01),
#            c      LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(01),
#            bmy05  LIKE bmy_file.bmy05,
#            bmy06  LIKE bmy_file.bmy06,
#            bmy07  LIKE bmy_file.bmy07,
#            bmy27  LIKE bmy_file.bmy27
#                   END RECORD
#DEFINE g_forupd_sql STRING                 #SELECT ... FOR UPDATE SQL
#DEFINE g_laststage  LIKE type_file.chr1    #No.FUN-680096 VARCHAR(1)    #FUN-580161
#DEFINE   g_chr           LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)
#DEFINE   g_chr2          LIKE type_file.chr1     #FUN-580161        #No.FUN-680096 VARCHAR(1)
#DEFINE   g_chr3          LIKE type_file.chr1     #FUN-580161        #No.FUN-680096 VARCHAR(1)
#DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680096 INTEGER
#DEFINE   g_cnt1          LIKE type_file.num20_6  #NO.FUN-870127
#DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose    #No.FUN-680096 SMALLINT
#DEFINE   g_msg           LIKE type_file.chr1000  #No.FUN-680096 VARCHAR(120)   #TQC-630177
#DEFINE   g_row_count    LIKE type_file.num10     #No.FUN-680096 INTEGER
#DEFINE   g_curs_index   LIKE type_file.num10     #No.FUN-680096 INTEGER
#DEFINE   g_jump         LIKE type_file.num10     #No.FUN-680096 INTEGER
#DEFINE   g_no_ask      LIKE type_file.num5      #No.FUN-680096 SMALLINT
#DEFINE g_bmx_l        DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)                                                        
#         bmx01        LIKE bmx_file.bmx01,                                                                                          
#         bmx07        LIKE bmx_file.bmx07,                                                                                          
#         bmx10        LIKE bmx_file.bmx10,                                                                                          
#         bmx13        LIKE bmx_file.bmx13,     #No.CHI-9C0054 add
#         bmx05        LIKE bmx_file.bmx05,                                                                                          
#         bmg03        LIKE bmg_file.bmg03,                                                                                          
#         bmx11        LIKE bmx_file.bmx11                                                                                           
#                      END RECORD                                                                                                    
#DEFINE  g_bmxx        DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)                                                        
#          sel         LIKE type_file.chr1,                                                                                          
#          bmx01       LIKE bmx_file.bmx01                                                                                           
#                      END RECORD                                                                                                    
#DEFINE g_gev04        LIKE gev_file.gev04                                                                                           
#DEFINE l_ac1          LIKE type_file.num10                                                                                          
#DEFINE g_rec_b1       LIKE type_file.num10                                                                                          
#DEFINE g_bp_flag      LIKE type_file.chr10                                                                                          
#DEFINE g_flag2        LIKE type_file.chr1                                                                                           
#DEFINE g_gew06        LIKE gew_file.gew06                                                                                           
#DEFINE g_gew07        LIKE gew_file.gew07  
#DEFINE g_chk1         LIKE type_file.chr1     #No.FUN-870117                                                                                         
#DEFINE l_bma06        LIKE bma_file.bma06     #TQC-920056
#DEFINE g_argv3        LIKE type_file.chr1     #No.FUN-A60031
#DEFINE g_brb          RECORD LIKE brb_file.*  #No.FUN-A60008
#DEFINE g_bra014       LIKE bra_file.bra014    #No.FUN-A60008
#DEFINE cb             ui.ComboBox             #No.FUN-A60083
#DEFINE g_ecb06        LIKE ecb_file.ecb06     #No.FUN-A60083
#FUN-AC0060--mark---end----
DEFINE b_bmy10_t      LIKE bmy_file.bmy10       #No.FUN-BB0086

MAIN
DEFINE   p_sma124      LIKE sma_file.sma124         #No.FUN-810014
DEFINE   l_argv5       STRING                       #FUN-B80071
    IF FGL_GETENV("FGLGUI") <> "0" THEN
       OPTIONS                                #改變一些系統預設值
           INPUT NO WRAP
       DEFER INTERRUPT
    END IF
 
    LET g_argv1_str = ARG_VAL(1)   # ECN No.                                                     #CHI-CA0035 mod g_argv1->g_argv1_str
    LET g_argv2 = ARG_VAL(2)       #執行功能   #TQC-630070 #FUN-AC0060 mark                      #CHI-CA0035 remark 
   #LET g_argv2_str = ARG_VAL(2)   #執行功能   #TQC-630070 #FUN-AC0060 g_argv2 改成 g_argv2_str  #CHI-CA0035 mark
    LET g_argv3_str = ARG_VAL(3)   #No.FUN-A60031 #FUN-AC0060(110705)
    LET l_argv5 = ARG_VAL(5)       #FUN-B80071
   #TQC-AC0175--begin--add----
   IF NOT cl_null(g_argv1_str) THEN #FUN-AC0060(110705)  #CHI-CA0035 mod g_argv3->g_argv1
      IF g_argv1_str = '2' THEN #FUN-AC0060(110705)      #CHI-CA0035 mod g_argv3->g_argv1
         LET g_prog='abmi721'
      ELSE
         LET g_prog='abmi720'
      END IF
   END IF
   #TQC-AC0175--end--add-----

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
   #No.FUN-A60031--begin
   IF g_prog='abmi720' THEN 
      LET g_argv1_str='1' #FUN-AC0060(110705)  #CHI-CA0035 mod g_argv3->g_argv1
   END IF 
   IF g_prog='abmi721' THEN 
   	 LET g_argv1_str='2' #FUN-AC0060(110705)  #CHI-CA0035 mod g_argv3->g_argv1
   END IF 
   IF cl_null(g_argv1_str) THEN #FUN-AC0060(110705)  #CHI-CA0035 mod g_argv3->g_argv1
      LET g_argv1_str='1' #FUN-AC0060(110705)  #CHI-CA0035 mod g_argv3->g_argv1 
   END IF 
   IF g_argv1_str='2' THEN #FUN-AC0060(110705)  #CHI-CA0035 mod g_argv3->g_argv1
      CALL cl_set_comp_entry("bmy16",FALSE)
   END IF 
   #No.FUN-A60031--end 
    LET g_forupd_sql =
       "SELECT * FROM bmx_file WHERE bmx01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i720_cl CURSOR FROM g_forupd_sql
 
    CALL s_decl_bmb()
    IF fgl_getenv('EASYFLOW') = "1" THEN
          LET g_argv2 = aws_efapp_wsk(1)   #參數:key-1  #CHI-CA0035 mod g_argv1->g_argv2
  
       #FUN-B80071 add str---
       #因從EASYFLOW進行自動確認時,參數位置非標準,故增加此判斷邏輯
       #argv1='',argv2='',argv3='1',argv4='AAA-11082302',argv5='efconfirm'
           IF NOT cl_null(g_argv3_str) THEN  #CHI-CA0035 mod g_argv2->g_argv3
              IF g_argv3_str <> 'efconfirm' THEN  #CHI-CA0035 mod g_argv2->g_argv3
                 LET g_argv3_str = l_argv5   #CHI-CA0035 mod g_argv2->g_argv3
    END IF
           ELSE
              LET g_argv3_str = l_argv5      #CHI-CA0035 mod g_argv2->g_argv3
           END IF   
       #FUN-B80071 add end---
    END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
    #IF g_bgjob='N' OR cl_null(g_bgjob) AND cl_null(g_argv3_str) THEN  #NO.FUN-840033 #FUN-AC0060 g_argv2 改成 g_argv2_str  #CHI-CA0035 mod g_argv2->g_argv3
    IF g_bgjob='N' OR cl_null(g_bgjob) THEN     #MOD-D10188 
 
       OPEN WINDOW i720_w WITH FORM "abm/42f/abmi720"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
       CALL cl_ui_init()
    END IF

    IF g_argv3_str <> 'abmp701' OR cl_null(g_argv3_str) THEN   #CHI-CA0035 add
       CALL cl_set_comp_visible("bmy361,bmy37",g_aza.aza121='Y') #FUN-D10093 add #當aoos010欄位"是否與PLM整合[aza121=Y]"打勾時,才show出bmy361/bmy37欄位
    END IF   #CHI-CA0035 add
    #No.FUN-A60031--begin
    IF g_argv1_str='2' THEN #FUN-AC0060(110705)  #CHI-CA0035 mod g_argv3->g_argv1
       IF g_sma.sma542='N' THEN 
          CALL cl_err('','abm-213',1)
          CLOSE WINDOW i720_w         #TQC-AC0175    
          CALL  cl_used(g_prog,g_time,2) RETURNING g_time           
       END IF         
    END IF 
    IF g_argv3_str <> 'abmp701' OR cl_null(g_argv3_str) THEN   #CHI-CA0035 add
       IF g_argv1_str='2' THEN #FUN-AC0060(110705)  #CHI-CA0035 mod g_argv3->g_argv1
          CALL cl_set_comp_visible('bmy011,bmy012,bmy013',TRUE)
       ELSE 
          CALL cl_set_comp_visible('bmy011,bmy012,bmy013',FALSE)
       END IF     
    END IF   #CHI-CA0035 add
    #No.FUN-A60083--begin
    IF g_argv1_str='2' THEN #FUN-AC0060(110705)  #CHI-CA0035 mod g_argv3->g_argv1
       LET cb = ui.ComboBox.forName("bmy03")
       CALL cb.removeItem('4')
       CALL cb.removeItem('5')
    END IF     
    #No.FUN-A60083--end 
    #No.FUN-A60031--end 
    #CHI-C20060---begin  
    IF g_prog='abmi721' THEN 
       LET cb = ui.ComboBox.forName("bmy03")
       CALL cb.removeItem('6')
    END IF  
    #CHI-C20060---end
    #如果由表單追蹤區觸發程式, 此參數指定為何種資料匣
    #當為 EasyFlow 簽核時, 加入 EasyFlow 簽核 toolbar icon
    CALL aws_efapp_toolbar()    #FUN-580161
 
    # 先以g_argv3_str判斷直接執行哪種功能：#FUN-AC0060 g_argv2 改成 g_argv2_str  #CHI-CA0035 mod g_argv2->g_argv3
    IF NOT cl_null(g_argv2) THEN           #CHI-CA0035 mod g_argv1->g_argv2 
       CASE g_argv3_str                    #FUN-AC0060 g_argv2 改成 g_argv2_str  #CHI-CA0035 mod g_argv2->g_argv3
          WHEN "query"
             LET g_action_choice = "query"
             IF cl_chk_act_auth() THEN
                CALL i720_q()
             END IF
          WHEN "insert"
             LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL i720_a()
            END IF
         WHEN "efconfirm"
            CALL i720_q()
           #CALL i720_y_chk()          #CALL 原確認的 check 段     #FUN-AC0060 mark
            CALL i720sub_y_chk(g_bmx.bmx01)                        #FUN-AC0060 add
            IF g_success = "Y" THEN
              #CALL i720_y_upd()       #CALL 原確認的 update 段    #FUN-AC0060 mark
               CALL i720sub_y_upd(g_bmx.bmx01,'Y')                 #FUN-AC0060 add
               CALL i720sub_refresh(g_bmx.bmx01) RETURNING g_bmx.* #FUN-AC0060 add
               CALL i720_show()                                    #FUN-AC0060 add
            END IF
            CALL cl_used(g_prog,g_time,2) RETURNING g_time 
            EXIT PROGRAM
         WHEN "abmp701"
            LET g_bmx.bmx01 = g_argv2  #CHI-CA0035 mod g_argv1->g_argv2
            LET g_action_choice = "confirm" 
            CLOSE WINDOW SCREEN
           #CALL i720_y_chk()          #CALL 原確認的 check 段     #FUN-AC0060 mark
            CALL i720sub_y_chk(g_bmx.bmx01)                        #FUN-AC0060 add
            IF g_success = "Y" THEN
              #CALL i720_y_upd()       #CALL 原確認的 update 段    #FUN-AC0060 mark
               CALL i720sub_y_upd(g_bmx.bmx01,'Y')                 #FUN-AC0060 add
               CALL i720sub_refresh(g_bmx.bmx01) RETURNING g_bmx.* #FUN-AC0060 add
              #CALL i720_show()                                    #FUN-AC0060 add  #CHI-CA0035 mark
            END IF
            CALL cl_used(g_prog,g_time,2) RETURNING g_time 
            EXIT PROGRAM
         #FUN-A80017------ str----
         WHEN "aws_create_ecn_data"
            LET g_bmx.bmx01 = g_argv2  #CHI-CA0035 mod g_argv1->g_argv2
            LET g_action_choice = "confirm" 
           #CLOSE WINDOW SCREEN        #FUN-AB0038 mark
           #CALL i720_y_chk()          #CALL 原確認的 check 段     #FUN-AC0060 mark
            CALL i720sub_y_chk(g_bmx.bmx01)                        #FUN-AC0060 add
            IF g_success = "Y" THEN
              #CALL i720_y_upd()       #CALL 原確認的 update 段    #FUN-AC0060 mark
               CALL i720sub_y_upd(g_bmx.bmx01,'Y')                 #FUN-AC0060 add
               CALL i720sub_refresh(g_bmx.bmx01) RETURNING g_bmx.* #FUN-AC0060 add
               CALL i720_show()                                    #FUN-AC0060 add
            END IF
            EXIT PROGRAM
         #FUN-A80017------ end----
         OTHERWISE          #TQC-660072
            CALL i720_q()   #TQC-660072
       END CASE
    END IF

   #FUN-B70022 mark str--- 
   #IF NOT cl_null(g_argv2) THEN  #CHI-CA0035 mod g_argv1->g_argv2
   #    CALL i720_q()
   #END IF
   #FUN-B70022 mark end---
 
    #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
    #CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail,#FUN-B80071 mark
    #      query,locale, void, confirm, undo_confirm,easyflow_approval")  #FUN-B80071 mark
	 CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail,query,locale, void, undo_void, confirm, undo_confirm,easyflow_approval,carry,mntn_insert_loc,memo")  #FUN-B80071  #CHI-D20010 add undo_void
          RETURNING g_laststage
 
    IF NOT s_industry('slk') THEN
       CALL cl_set_comp_visible("bmy29,bmy30",g_sma.sma118='Y') #FUN-560115 #add bmy30
    ELSE
       CALL cl_set_comp_visible("bmy29",g_sma.sma118='Y') #FUN-560115 #add bmy30
    END IF
    IF s_industry('slk') THEN
        CALL i720_set_bmy30()
    END IF
 
    CALL i720()
    CLOSE WINDOW i720_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
END MAIN
 
FUNCTION i720()
  DEFINE l_za05    LIKE za_file.za05
 
    LET g_wc3=' 1=1'

 
    CALL i720_menu()
END FUNCTION
 
FUNCTION i720_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
    CALL g_bmy.clear()
    CALL g_bmw.clear()
    CALL g_ima.clear()
    IF NOT cl_null(g_argv2) THEN   #CHI-CA0035 mod g_argv1->g_argv2
       LET g_wc = " bmx01 = '",g_argv2,"' AND bmx50= '",g_argv1_str,"' "  #FUN-580161  #No.FUN-A60031 add bmx50#FUN-AC0060(110705)  #CHI-CA0035 mod g_argv1->g_argv2,g_argv3->g_argv1
       LET g_wc3= ' 1=1'
     ELSE
       CALL cl_set_head_visible("","YES")   #No.FUN-6B0033
 
   INITIALIZE g_bmx.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON
                bmx01,bmx02,bmx07,bmx10,bmx13 ,bmx11,bmx05,#FUN-630044  #FUN-820027 add bmx11  #CHI-9C0054  add bmx13
                bmx04,bmxmksg,bmx09,bmxuser,bmxgrup,bmxmodu,
                bmxdate,bmxacti  #FUN-540045
 
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
        ON ACTION controlp
          CASE WHEN INFIELD(bmx01) #查詢單据
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_bmx1"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO bmx01
                    NEXT FIELD bmx01
               WHEN INFIELD(bmx05) #查詢ECR
                    CALL cl_init_qry_var()
                   #LET g_qryparam.form = "q_bmr"    #MOD-A30170 mark
                   #TQC-AC0171 --------add start-----
                    IF g_argv1_str = '1' THEN #FUN-AC0060(110705)  #CHI-CA0035 mod g_argv3->g_argv1
                       LET g_qryparam.where = " bmr50 = '1' "
                    ELSE
                       LET g_qryparam.where = " bmr50 = '2' "
                    END IF
                   #TQC-AC0171 --------add end---------
                    LET g_qryparam.form = "q_bmr1"   #MOD-A30170 
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO bmx05
                    NEXT FIELD bmx05
               WHEN INFIELD(bmx10) #申請人
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO bmx10
                 NEXT FIELD bmx10
 
               #No.CHI-9C0054 ---start---
               WHEN INFIELD(bmx13) #申請部門 
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO bmx13
                 NEXT FIELD bmx13
               #No.CHI-9C0054 ---end---

               WHEN INFIELD(bmx11)                                                                                                  
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.form  = "q_azp"                                                                                    
                  LET g_qryparam.state = "c"                                                                                        
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  DISPLAY g_qryparam.multiret TO bmx11                                                                              
                  NEXT FIELD bmx11                                                                                                  
 
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
       CONSTRUCT g_wc3 ON bmy02,bmy03,bmy19,bmy04,bmy14,bmy011,bmy012,bmy013,bmy171,bmy17,bmy29,bmy05,bmy27, #FUN-550014 add bmy29  #CHI-710048 bmy27在bmy05之後 #No.FUN-A60031  add bmy011,bmy012,bmy013
                          bmy16,bmy35,bmy30,bmy06,bmy07,ta_bmy01,ta_bmy02,ta_bmy03,ta_bmy04,ta_bmy05,bmy34,bmy36,bmy361,bmy37,bmy22 #ta_bmy03,ta_bmy04 add by huanglf161018 #ta_bmy02 add by huanglf160927  #FUN-550014 add bmy30  #no.MOD-840426 add bmy34 #CHI-A60028 add bmy35 #FUN-BB0075  #FUN-D10093 add bmy361,bmy37 #add ta_bmy01 by chenkun160815
            FROM s_bmy[1].bmy02,s_bmy[1].bmy03,s_bmy[1].bmy19,                                                                 
                 s_bmy[1].bmy04,s_bmy[1].bmy14,s_bmy[1].bmy011,s_bmy[1].bmy012,s_bmy[1].bmy013,  #No.FUN-A60031  add bmy011,bmy012,bmy013
                 s_bmy[1].bmy171,s_bmy[1].bmy17,s_bmy[1].bmy29, #FUN-550014 add bmy29
                 s_bmy[1].bmy05,s_bmy[1].bmy27,s_bmy[1].bmy16,s_bmy[1].bmy35,s_bmy[1].bmy30,s_bmy[1].bmy06,  #FUN-550014 add bmy30 #CHI-A60028 add bmy35
                 s_bmy[1].bmy07,s_bmy[1].ta_bmy01,s_bmy[1].ta_bmy02,s_bmy[1].ta_bmy03,s_bmy[1].ta_bmy04,s_bmy[1].ta_bmy05,s_bmy[1].bmy34,s_bmy[1].bmy36,s_bmy[1].bmy361,s_bmy[1].bmy37,s_bmy[1].bmy22  #add by huanglf160927 #no.MOD-840426 add bmy34 #FUN-BB0075  #FUN-D10093 add bmy361,bmy37
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
        ON ACTION controlp
           CASE WHEN INFIELD(bmy05)
#FUN-AA0059 --Begin--
                  #   CALL cl_init_qry_var()
                  #   LET g_qryparam.form = "q_ima"
                  #   LET g_qryparam.state = "c"
                  #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                     CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                     DISPLAY g_qryparam.multiret TO bmy05
                     NEXT FIELD bmy05
                #No.FUN-A60031--begin     
                WHEN INFIELD(bmy011)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_bmy011"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO bmy011
                     NEXT FIELD bmy011   
                WHEN INFIELD(bmy012)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_bmy012"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO bmy012
                     NEXT FIELD bmy012           
                WHEN INFIELD(bmy013)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_bmy013"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO bmy013
                     NEXT FIELD bmy013    
                #No.FUN-A60031--end                                                      
                WHEN INFIELD(bmy27)
#FUN-AA0059 --Begin--
                  #   CALL cl_init_qry_var()
                  #   LET g_qryparam.form = "q_ima"
                  #   LET g_qryparam.state = "c"
                  #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                     CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                     DISPLAY g_qryparam.multiret TO bmy27
                     NEXT FIELD bmy27
               #CHI-B40031 --- modify --- start ---
                 WHEN INFIELD(bmy29)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_bmz05"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO bmy29
                     NEXT FIELD bmy29
                #CHI-B40031 --- modify ---  end  --      
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
    END IF

    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('bmxuser', 'bmxgrup')
 
    IF g_wc3 = " 1=1" THEN
              LET g_sql = "SELECT bmx01 FROM bmx_file",
                          " WHERE ", g_wc CLIPPED,
                          "   AND bmx06='2' ",   #No.B244 add
                          " AND bmx50= '",g_argv1_str,"' ", #No.FUN-A60031 #FUN-AC0060(110705)  #CHI-CA0035 mod g_argv3->g_argv1
                          " ORDER BY 1"
    ELSE
             #LET g_sql = "SELECT bmx01 ",            #MOD-CB0044 mark
              LET g_sql = "SELECT UNIQUE bmx01 ",     #MOD-CB0044
                          "  FROM bmx_file, bmy_file",
                          " WHERE bmx01 = bmy01",
                          "   AND bmx06='2' ",   #No.B244 add
                          " AND bmx50= '",g_argv1_str,"' ", #No.FUN-A60031 #FUN-AC0060(110705)  #CHI-CA0035 mod g_argv3->g_argv1
                          "   AND ", g_wc CLIPPED, " AND ",g_wc3 CLIPPED,
                          " ORDER BY 1"
    END IF
 
    PREPARE i720_prepare FROM g_sql
    DECLARE i720_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i720_prepare
 
    DECLARE i720_list_cur CURSOR FOR i720_prepare                                                                                   
 
    IF g_wc3 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM bmx_file WHERE ",g_wc CLIPPED,
                  " AND bmx50= '",g_argv1_str,"' ", #No.FUN-A60031 #FUN-AC0060(110705)  #CHI-CA0035 mod g_argv3->g_argv1
                  "   AND bmx06='2' "    #No.B244 add
 
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT bmx01) FROM bmx_file,bmy_file WHERE ",
                  "bmy01=bmx01 AND ",g_wc CLIPPED," AND ",g_wc3 CLIPPED,
                  " AND bmx50= '",g_argv1_str,"' ", #No.FUN-A60031 #FUN-AC0060(110705)  #CHI-CA0035 mod g_argv3->g_argv1
                  "   AND bmx06='2' "    #No.B244 add
    END IF
    PREPARE i720_precount FROM g_sql
    DECLARE i720_count CURSOR FOR i720_precount
END FUNCTION
 
 
FUNCTION i720_menu()
DEFINE l_creator    LIKE type_file.chr1    #No.FUN-680096 VARCHAR(1)  #FUN-580161
DEFINE l_flowuser   LIKE type_file.chr1    #No.FUN-680096 VARCHAR(1)  # 是否有指定加簽人員   #FUN-580161
DEFINE l_cmd        LIKE type_file.chr1000 #No.FUN-820027
 
   LET l_flowuser="N"                    #TQC-740283
 
   WHILE TRUE
      IF cl_null(g_bp_flag) OR g_bp_flag <> 'list' THEN                                                                             
         CALL i720_bp("G")                                                                                                          
      ELSE                                                                                                                          
         CALL i720_bp1("G")                                                                                                         
      END IF                                                                                                                        
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i720_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i720_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i720_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i720_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i720_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i720_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "mntn_insert_loc"
           IF cl_chk_act_auth() THEN
              LET g_flag = 'Y'   #MOD-910205 add
              CALL i720_t()
           END IF
         WHEN "carry"                                                                                                               
            IF cl_chk_act_auth() THEN                                                                                               
               CALL ui.Interface.refresh()                                                                                          
               CALL i720_carry()                                                                                                    
               ERROR ""                                                                                                             
            END IF                                                                                                                  
                                                                                                                                    
         WHEN "download"                                                                                                            
            IF cl_chk_act_auth() THEN                                                                                               
               CALL i720_download()                                                                                                 
            END IF                                                                                                                  
                                                                                                                                    
         WHEN "qry_carry_history"                                                                                                   
            IF cl_chk_act_auth() THEN  
               IF NOT cl_null(g_bmx.bmx01) THEN                                                                                             
                  IF NOT cl_null(g_bmx.bmx11) THEN                                                                                     
                     SELECT gev04 INTO g_gev04 FROM gev_file                                                                           
                     WHERE gev01 = '3' AND gev02 = g_bmx.bmx11                                                                        
                  ELSE      #歷史資料,即沒有bmx11的值                                                                                  
                     SELECT gev04 INTO g_gev04 FROM gev_file                                                                           
                     WHERE gev01 = '3' AND gev02 = g_plant                                                                            
                  END IF                                                                                                               
                  IF NOT cl_null(g_gev04) THEN                                                                                         
                     LET l_cmd='aooq604 "',g_gev04,'" "3" "',g_prog,'" "',g_bmx.bmx01,'"'                                              
                     CALL cl_cmdrun(l_cmd)                                                                                             
                  END IF 
               ELSE
                  CALL cl_err('',-400,0)                                                                                                              
               END IF   
            END IF      
       #@WHEN "備註"
         WHEN "memo"
            #FUN-B80071 add str---
             IF g_bmx.bmx09 matches '[Ss]' THEN     
                CALL cl_err('','apm-030',0)
             ELSE
            #FUN-B80071 add end---
            CALL s_abm_memo(g_bmx.bmx01,'u')
             CALL i720_show() #MOD-430879
             END IF  #FUN-B80071 add
       #@WHEN "作廢"
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL i720_x()   #CHI-D20010
               CALL i720_x(1)   #CHI-D20010 

               CALL i720_field_pic()
            END IF
       #CHI-D20010---begin
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
             # CALL i720_x()    #CHI-D20010
               CALL i720_x(2)   #CHI-D20010
               CALL i720_field_pic()
            END IF
         #CHI-D20010---end
       #@WHEN "確認"
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL s_showmsg_init()      #No.MOD-840284 add
              #CALL i720_y_chk()          #CALL 原確認的 check 段      #FUN-AC0060 mark
               CALL i720sub_y_chk(g_bmx.bmx01)                         #FUN-AC0060 add
               IF g_success = "Y" THEN
                  #CALL i720_y_upd()      #CALL 原確認的 update 段     #FUN-AC0060 mark
                   CALL i720sub_y_upd(g_bmx.bmx01,'Y')                 #FUN-AC0060 add
                   CALL i720sub_refresh(g_bmx.bmx01) RETURNING g_bmx.* #FUN-AC0060 add
                   CALL i720_show()                                    #FUN-AC0060 add
               END IF
               CALL s_showmsg()           #No.MOD-840284 add

               CALL i720_field_pic()
            END IF
 
       #@WHEN "簽核狀況"
         WHEN "approval_status"
            IF cl_chk_act_auth() THEN        #DISPLAY ONLY
               IF aws_condition2() THEN                #FUN-550040
                    CALL aws_efstat2()                  #MOD-560007
               END IF
            END IF
 
         WHEN "easyflow_approval"     #FUN-550040
            IF cl_chk_act_auth() THEN
              #FUN-C20011 add str---
               SELECT * INTO g_bmx.* FROM bmx_file
                WHERE bmx01 = g_bmx.bmx01
               CALL i720_show()
               CALL i720_b_fill(' 1=1')
              #FUN-C20011 add end---
               CALL i720_ef()
               CALL i720_show()  #FUN-C20011 add
            END IF
 
         #@WHEN "准"
         WHEN "agree"
              IF g_laststage = "Y" AND l_flowuser = "N" THEN #最後一關
                #CALL i720_y_upd()      #CALL 原確認的 update 段     #FUN-AC0060 mark
                 CALL i720sub_y_upd(g_bmx.bmx01,'Y')                 #FUN-AC0060 add
                 CALL i720sub_refresh(g_bmx.bmx01) RETURNING g_bmx.* #FUN-AC0060 add
                 CALL i720_show()                                    #FUN-AC0060 add
              ELSE
                 LET g_success = "Y"
                 IF NOT aws_efapp_formapproval() THEN
                    LET g_success = "N"
                 END IF
              END IF
              IF g_success = 'Y' THEN
                    IF cl_confirm('aws-081') THEN
                       IF aws_efapp_getnextforminfo() THEN
                          LET l_flowuser = 'N'
                          LET g_argv2 = aws_efapp_wsk(1)   #參數:key-1  #CHI-CA0035 mod g_argv1->g_argv2
                          IF NOT cl_null(g_argv2) THEN     #CHI-CA0035 mod g_argv1->g_argv2
                                CALL i720_q()
                                #設定簽核功能及哪些 action 在簽核狀態時是不可被>
                                #CALL aws_efapp_flowaction("insert, modify,	    #FUN-B80071 mark
                                #delete, reproduce, detail, query, locale,	    #FUN-B80071 mark
                                #void,confirm, undo_confirm,easyflow_approval")	#FUN-B80071 mark
								 CALL aws_efapp_flowaction("insert, modify,delete, reproduce, detail, query, locale,void,undo_void, confirm, undo_confirm,easyflow_approval,carry,mntn_insert_loc,memo")  #FUN-B80071  #CHI-D20010 add undo_void
                                      RETURNING g_laststage
ELSE
                              EXIT WHILE
                          END IF
                        ELSE
                              EXIT WHILE
                        END IF
                    ELSE
                       EXIT WHILE
                    END IF
              END IF
 
         #@WHEN "不准"
         WHEN "deny"
             IF (l_creator := aws_efapp_backflow()) IS NOT NULL THEN  #FUN-58012
                IF aws_efapp_formapproval() THEN
                   IF l_creator = "Y" THEN
                      LET g_bmx.bmx09 = 'R'
                      DISPLAY BY NAME g_bmx.bmx09
                   END IF
                   IF cl_confirm('aws-081') THEN
                      IF aws_efapp_getnextforminfo() THEN
                          LET l_flowuser = 'N'
                          LET g_argv2 = aws_efapp_wsk(1)   #參數:key-1  #CHI-CA0035 mod g_argv1->g_argv2
                          IF NOT cl_null(g_argv2) THEN     #CHI-CA0035 mod g_argv1->g_argv2
                                CALL i720_q()
                                #設定簽核功能及哪些 action 在簽核狀態時是不可被>
                                #CALL aws_efapp_flowaction("insert, modify,	   #FUN-B80071 mark
                                #delete,reproduce, detail, query, locale,void, #FUN-B80071 mark
                                #confirm, undo_confirm,easyflow_approval")	   #FUN-B80071 mark	
								 CALL aws_efapp_flowaction("insert, modify,delete,reproduce, detail, query, locale,void,undo_void,confirm, undo_confirm,easyflow_approval,carry,mntn_insert_loc,memo")  #FUN-B80071  #CHI-D20010 add undo_void
                                      RETURNING g_laststage
                          ELSE
                                EXIT WHILE
                          END IF
                      ELSE
                            EXIT WHILE
                      END IF
                   ELSE
                      EXIT WHILE
                   END IF
                END IF
              END IF
 
         #@WHEN "加簽"
         WHEN "modify_flow"
              IF aws_efapp_flowuser() THEN   #選擇欲加簽人員
                 LET l_flowuser = 'Y'
              ELSE
                 LET l_flowuser = 'N'
              END IF
 
         #@WHEN "撤簽"
         WHEN "withdraw"
              IF cl_confirm("aws-080") THEN
                 IF aws_efapp_formapproval() THEN
                    EXIT WHILE
                 END IF
              END IF
 
         #@WHEN "抽單"
         WHEN "org_withdraw"
              IF cl_confirm("aws-079") THEN
                 IF aws_efapp_formapproval() THEN
                    EXIT WHILE
                 END IF
              END IF
 
        #@WHEN "簽核意見"
         WHEN "phrase"
              CALL aws_efapp_phrase()
 
 
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bmy),'','')
            END IF
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               IF g_bmx.bmx01 IS NOT NULL THEN
                 LET g_doc.column1 = "bmx01"
                 LET g_doc.value1 = g_bmx.bmx01
                 CALL cl_doc()
               END IF
           END IF
         #CHI-C80063---begin
         WHEN "qry_item_detail"
            IF l_ac > 0 THEN 
               CALL i720_b_more1()
            END IF 
         #CHI-C80063---end
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i720_a()
    DEFINE li_result  LIKE type_file.num5     #No.FUN-550032   #No.FUN-680096  SMALLINT
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_bmy.clear()
    CALL g_bmw.clear()
    CALL g_ima.clear()
    INITIALIZE g_bmx.* TO NULL
    LET g_bmx_o.* = g_bmx.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_bmx.bmx02  =TODAY
        LET g_bmx.bmx07  =TODAY   #No.B245 add
        LET g_bmx.bmx04  ='N'
        LET g_bmx.bmx06  ='2'     #No.B244 by linda add
        LET g_bmx.bmx11=g_plant   #No.FUN-820027
        LET g_bmx.bmxuser=g_user
        LET g_bmx.bmxoriu = g_user #FUN-980030
        LET g_bmx.bmxorig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_bmx.bmxgrup=g_grup
        LET g_bmx.bmxdate=g_today
        LET g_bmx.bmxacti='Y'
        LET g_bmx.bmx09='0'   #--FUN-540045
        LET g_bmx.bmx50=g_argv1_str  #No.FUN-A60031 #FUN-AC0060(110705)  #CHI-CA0035 mod g_argv3->g_argv1
        LET g_bmx.bmx10=g_user     
        IF NOT s_dc_ud_flag('3',g_bmx.bmx11,g_plant,'a') THEN                                                                           
           CALL cl_err(g_bmx.bmx11,'aoo-078',1)                                                                                         
           RETURN                                                                                                                       
        END IF       
        CALL i720_bmx10('d')
        IF NOT cl_null(g_errno) THEN
           LET g_bmx.bmx10 = ''
        END IF
 
        IF NOT cl_null(g_argv2) AND (g_argv3_str = "insert") THEN #FUN-AC0060 g_argv2 改成 g_argv2_str #CHI-CA0035 mod g_argv1->g_argv2,g_argv2->g_argv3
           LET g_bmx.bmx01 = g_argv2  #CHI-CA0035 mod g_argv1->g_argv2
        END IF
 
        LET g_bmx.bmxplant = g_plant 
        LET g_bmx.bmxlegal = g_legal 
 
        CALL i720_i("a")                #輸入單頭
        IF INT_FLAG THEN
           INITIALIZE g_bmx.* TO NULL
           LET g_bmx01 = NULL   #MOD-660086 add
           LET INT_FLAG=0 CALL cl_err('',9001,0) ROLLBACK WORK EXIT WHILE
        END IF
        IF g_bmx.bmx01 IS NULL THEN CONTINUE WHILE END IF
        BEGIN WORK #No:7857
        CALL s_auto_assign_no("abm",g_bmx.bmx01,g_bmx.bmx02,"1","bmx_file","bmx01","","","")
        RETURNING li_result,g_bmx.bmx01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_bmx.bmx01

        IF cl_null(g_bmx.bmx07) THEN
           LET g_bmx.bmx07=g_bmx.bmx02
           DISPLAY BY NAME g_bmx.bmx07
        END IF
        INSERT INTO bmx_file VALUES (g_bmx.*)
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err('ins bmx: ',SQLCA.SQLCODE,1)   #No.FUN-B80100---上移一行調整至回滾事務前---
           ROLLBACK WORK #No:7857
           CONTINUE WHILE
        ELSE
           COMMIT WORK #No:7857
           CALL cl_flow_notify(g_bmx.bmx01,'I')
        END IF
        SELECT bmx01 INTO g_bmx01 FROM bmx_file WHERE bmx01 = g_bmx.bmx01
        LET g_bmx_t.* = g_bmx.*
        CALL g_bmy.clear()
        LET g_rec_b = 0
        CALL i720_b()                 #輸入單身

       #FUN-B80071 add str----
        IF NOT cl_null(g_bmx.bmx01) AND g_smy.smydmy4='Y' AND g_smy.smyapr <> 'Y' THEN  #確認
           LET g_action_choice = "insert"

           CALL i720sub_y_chk(g_bmx.bmx01)             
           IF g_success = "Y" THEN
              CALL i720sub_y_upd(g_bmx.bmx01,'Y')               
              CALL i720sub_refresh(g_bmx.bmx01) RETURNING g_bmx.* 
              CALL i720_show()
           END IF
        END IF
       #FUN-B80071 add end----

        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i720_u()
    IF s_shut(0) THEN RETURN END IF
    SELECT * INTO g_bmx.* FROM bmx_file WHERE bmx01 = g_bmx01
    IF NOT s_dc_ud_flag('3',g_bmx.bmx11,g_plant,'u') THEN                                                                           
       CALL cl_err(g_bmx.bmx11,'aoo-045',1)                                                                                         
       RETURN                                                                                                                       
    END IF                                                                                                                          
    IF g_bmx.bmx01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_bmx.bmx04 = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF g_bmx.bmx04 = 'Y' THEN CALL cl_err('','mfg0175',0) RETURN END IF
    IF g_bmx.bmx09 matches '[Ss]' THEN          #FUN-550040
         CALL cl_err('','apm-030',0)
         RETURN
    END IF
 
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_bmx_o.* = g_bmx.*
    BEGIN WORK
 
    OPEN i720_cl USING g_bmx01
    IF STATUS THEN
       CALL cl_err("OPEN i720_cl:", STATUS, 1)
       CLOSE i720_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i720_cl INTO g_bmx.*          # 鎖住將被更改或取消的資料
    IF STATUS THEN
        CALL cl_err('lock bmx:',SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE i720_cl ROLLBACK WORK RETURN
    END IF
    CALL i720_show()
    WHILE TRUE
        LET g_bmx.bmxmodu=g_user
        LET g_bmx.bmxdate=g_today
           CALL i720_i("u")
 
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_bmx.*=g_bmx_t.*
            CALL i720_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        LET g_bmx.bmx09 = '0'        #FUN-550040
        UPDATE bmx_file SET * = g_bmx.* WHERE bmx01 = g_bmx01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err('upd bmx: ',SQLCA.SQLCODE,0)
           CONTINUE WHILE
        END IF
 
        CALL i720_list_fill()                                                                                                       
 
        EXIT WHILE
    END WHILE
    CLOSE i720_cl
    DISPLAY BY NAME g_bmx.bmx09
    CALL i720_field_pic()
 
    COMMIT WORK
    CALL cl_flow_notify(g_bmx.bmx01,'U')
END FUNCTION
 
FUNCTION i720_i(p_cmd)
  DEFINE p_cmd      LIKE type_file.chr1     #a:輸入 u:更改        #No.FUN-680096 VARCHAR(1)
  DEFINE l_flag     LIKE type_file.chr1     #判斷必要欄位是否有輸入   #No.FUN-680096 VARCHAR(1)
  DEFINE li_result  LIKE type_file.num5     #No.FUN-680096 SMALLINT
  DEFINE l_cnt      LIKE type_file.num5     #MOD-6A0109 add
  DEFINE l_n        LIKE type_file.num5     #MOD-6A0109 add
  DEFINE l_gem02    LIKE gem_file.gem02     #CHI-9C0054 add
 
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0033
    LET l_gem02 = NULL                    #No.CHI-9C0054  
    INPUT BY NAME g_bmx.bmxoriu,g_bmx.bmxorig,
        g_bmx.bmx01,g_bmx.bmx02,g_bmx.bmx07, g_bmx.bmx10,g_bmx.bmx13,#FUN-630044   #CHI-9C0054 add bmx13
        g_bmx.bmx05,g_bmx.bmx04,g_bmx.bmxmksg,g_bmx.bmx09,g_bmx.bmx11,  #--FUN-540045   #FUN-820027 add g_bmx.bmx11
        g_bmx.bmxuser,g_bmx.bmxgrup,g_bmx.bmxmodu,g_bmx.bmxdate,g_bmx.bmxacti
           WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i720_set_entry(p_cmd)
            CALL i720_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
            CALL cl_set_docno_format("bmx01")
            CALL cl_set_docno_format("bmx05")
 
        AFTER FIELD bmx01
            IF NOT cl_null(g_bmx.bmx01) THEN
 
            CALL s_field_chk(g_bmx.bmx01,'3',g_plant,'bmx01') RETURNING g_flag2                                                     
            IF g_flag2 = '0' THEN                                                                                                   
               CALL cl_err(g_bmx.bmx01,'aoo-043',1)                                                                                 
               LET g_bmx.bmx01 = g_bmx_o.bmx01                                                                                      
               DISPLAY BY NAME g_bmx.bmx01                                                                                          
               NEXT FIELD bmx01                                                                                                     
            END IF                                                                                                                  
 
            CALL s_check_no("abm",g_bmx.bmx01,g_bmx_t.bmx01,"1","bmx_file","bmx01","")
            RETURNING li_result,g_bmx.bmx01
            IF(NOT li_result) THEN
               LET g_bmx.bmx01=g_bmx_o.bmx01
               DISPLAY BY NAME g_bmx.bmx01
                IF p_cmd='u' THEN
                   EXIT INPUT
                ELSE
                   NEXT FIELD bmx01
                END IF
            END IF
                     LET g_bmx.bmxmksg=g_smy.smyapr
                     DISPLAY BY NAME g_bmx.bmxmksg

            END IF
        AFTER FIELD bmx02
            IF cl_null(g_bmx.bmx07) THEN
               LET g_bmx.bmx07=g_bmx.bmx02
            END IF
        AFTER FIELD bmx05
            IF NOT cl_null(g_bmx.bmx05) THEN
               LET g_cnt=0
               IF g_argv1_str = '1' THEN                         #TQC-AC0171 #FUN-AC0060(110705)  #CHI-CA0035 mod g_argv3->g_argv1
                  SELECT COUNT(*) INTO g_cnt FROM bmr_file
                   WHERE bmr01=g_bmx.bmx05
                     AND bmrconf='Y'   #FUN-950045
                     AND bmr50 = '1'  #TQC-AC0171
              #TQC-AC0171 -----add start-----------------
               ELSE
                  SELECT COUNT(*) INTO g_cnt FROM bmr_file
                   WHERE bmr01=g_bmx.bmx05
                     AND bmrconf='Y'
                     AND bmr50 = '2'   
               END IF 
              #TQC-AC0171 -----add end----------------- 
               IF g_cnt=0 THEN
                  CALL cl_err(g_bmx.bmx05,'mfg0044',0)
                  NEXT FIELD bmx05
               END IF
            END IF
 
        AFTER FIELD bmx07
            IF NOT cl_null(g_bmx.bmx07) THEN
                SELECT COUNT(*) INTO g_cnt FROM bma_file
                 WHERE (bma05 IS NULL OR bma05 >g_bmx.bmx07)
                   AND bma01 IN (SELECT bmy14 FROM bmy_file WHERE bmy01=g_bmx.bmx01)
                IF g_cnt >0 THEN
                   LET g_bmx.bmx07 = g_bmx_t.bmx07
                   DISPLAY BY NAME g_bmx.bmx07
                   CALL cl_err(g_bmx.bmx07,'abm-005',0)
                   NEXT FIELD bmx07
                END IF
                #單身有值時須檢查是否單身設變己有其他的ECN單同時存在
                #單據已確認,但生效日尚未到者,則不可異動日期
                IF g_rec_b > 0 THEN 
                   LET g_success = 'Y'
                   FOR l_n = 1 TO g_rec_b
                       LET l_cnt = 0
                       SELECT COUNT(*) INTO l_cnt FROM bmb_file
                        WHERE bmb01 = g_bmy[l_n].bmy14
                          AND bmb03 = g_bmy[l_n].bmy05
                          AND (bmb04 > g_bmx.bmx07 AND bmb04 IS NOT NULL)
                          AND bmb05 IS NULL
                       IF l_cnt > 0 THEN
                          CALL cl_err(g_bmy[l_n].bmy05,'abm-729','1')
                          LET g_success = 'N'
                       END IF
                   END FOR 
                   IF g_success = 'N' THEN 
                      NEXT FIELD bmx07
                   END IF
                END IF 
            END IF
        AFTER FIELD bmx10
            IF NOT cl_null(g_bmx.bmx10) THEN
               CALL i720_bmx10('a')
               IF NOT cl_null(g_errno) THEN
                  LET g_bmx.bmx10 = g_bmx_t.bmx10
                  CALL cl_err(g_bmx.bmx10,g_errno,0)
                  DISPLAY BY NAME g_bmx.bmx10 #
                  NEXT FIELD bmx10
               END IF
            ELSE
               DISPLAY '' TO FORMONLY.gen02
            END IF
 
        #No.CHI-9C0054 ---start---
        AFTER FIELD bmx13
            IF NOT cl_null(g_bmx.bmx13) THEN
               CALL i720_bmx13('a')
               IF NOT cl_null(g_errno) THEN
                  LET g_bmx.bmx13 = g_bmx_t.bmx13
                  CALL cl_err(g_bmx.bmx13,g_errno,0)
                  DISPLAY BY NAME g_bmx.bmx10
                  NEXT FIELD bmx13
               END IF 
            ELSE
               DISPLAY '' TO FORMONLY.gem02
            END IF
        #No.CHI-9C0054 ---end---

        ON ACTION CONTROLP
          CASE WHEN INFIELD(bmx01) #查詢單据

                    LET g_t1=s_get_doc_no(g_bmx.bmx01)
                    CALL q_smy(FALSE,FALSE,g_t1,'ABM','1') RETURNING g_t1 #TQC-670008

                    LET g_bmx.bmx01 = g_t1
                    DISPLAY BY NAME g_bmx.bmx01
                    NEXT FIELD bmx01
               WHEN INFIELD(bmx05) #查詢ECR
                    CALL cl_init_qry_var()
                   #LET g_qryparam.form = "q_bmr"        #No.TQC-A30027
                    LET g_qryparam.form = "q_bmr1"       #No.TQC-A30027
                   #TQC-AC0171 --------add start-----
                    IF g_argv1_str = '1' THEN #FUN-AC0060(110705)  #CHI-CA0035 mod g_argv3->g_argv1
                       LET g_qryparam.where = " bmr50 = '1' "
                    ELSE
                       LET g_qryparam.where = " bmr50 = '2' "
                    END IF
                   #TQC-AC0171 --------add end---------
                    LET g_qryparam.default1 = g_bmx.bmx05
                    CALL cl_create_qry() RETURNING g_bmx.bmx05
                    DISPLAY BY NAME g_bmx.bmx05
                    NEXT FIELD bmx05
               WHEN INFIELD(bmx10)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gen"
                    LET g_qryparam.default1 = g_bmx.bmx10
                    CALL cl_create_qry() RETURNING g_bmx.bmx10
                    DISPLAY BY NAME g_bmx.bmx10
                    NEXT FIELD bmx10
           
               #No.CHI-9C0054 ---start---
               WHEN INFIELD(bmx13)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gem"
                    LET g_qryparam.default1 = g_bmx.bmx13
                    CALL cl_create_qry() RETURNING g_bmx.bmx13
                    DISPLAY BY NAME g_bmx.bmx13
                    NEXT FIELD bmx13
               #No.CHI-9C0054 ---end---

          END CASE
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 

 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
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
END FUNCTION
 
FUNCTION i720_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    INITIALIZE g_bmx.* TO NULL                   #FUN-6A0002
    LET g_bmx01 = NULL                       #FUN-6A0002
 
    CALL cl_msg("")                              #FUN-640241
 
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i720_cs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0 
       INITIALIZE g_bmx.* TO NULL 
       LET g_bmx01 = NULL   #MOD-660086 add
       RETURN 
    END IF
    CALL cl_msg(" SEARCHING ! ")                              #FUN-640241
 
    OPEN i720_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_bmx.* TO NULL
    ELSE
       OPEN i720_count
       FETCH i720_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL i720_list_fill()                                 #No.FUN-820027                                                        
       LET g_bp_flag = NULL                                  #CHI-880031
       CALL i720_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    CALL cl_msg("")                              #FUN-640241
 
END FUNCTION
 
FUNCTION i720_list_fill()                                                                                                           
  DEFINE l_bmx01         LIKE bmx_file.bmx01                                                                                        
  DEFINE l_i             LIKE type_file.num10                                                                                       
                                                                                                                                    
    CALL g_bmx_l.clear()                                                                                                            
    LET l_i = 1                                                                                                                     
    FOREACH i720_list_cur INTO l_bmx01                                                                                      
       IF SQLCA.sqlcode THEN                                                                                                        
          CALL cl_err('foreach list_cur',SQLCA.sqlcode,1)                                                                           
          CONTINUE FOREACH                                                                                                          
       END IF                                                                                                                       
       SELECT bmx01,bmx07,bmx10,bmx13,bmx05,'',bmx11        #No.CHI-9C0054 add                                                                           
         INTO g_bmx_l[l_i].*                                                                                                        
         FROM bmx_file                                                                                               
        WHERE bmx01=l_bmx01    
       SELECT bmg03                                                                                   
         INTO g_bmx_l[l_i].bmg03                                                                                                        
         FROM bmg_file                                                                                                     
        WHERE bmg01=l_bmx01                                                                                   
       LET l_i = l_i + 1                                                                                                            
       IF l_i > g_max_rec THEN                                                                                                      
          CALL cl_err( '', 9035, 0 )                                                                                                
          EXIT FOREACH                                                                                                              
       END IF                                                                                                                       
    END FOREACH
    LET g_rec_b1 = l_i - 1                                                                                                          
    IF g_bgjob='N' OR cl_null(g_bgjob) THEN  #FUN-B80071 add
       DISPLAY ARRAY g_bmx_l TO s_bmx_1.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)                                                         
          BEFORE DISPLAY                                                                                                               
             EXIT DISPLAY                                                                                                              
       END DISPLAY                                          
    END IF  #FUN-B80071 add                                                                           
                                                                                                                                    
END FUNCTION                                                                                                                        
 
FUNCTION i720_fetch(p_flag)
DEFINE
    p_flag  LIKE type_file.chr1     #處理方式    #No.FUN-680096 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i720_cs INTO g_bmx01,g_bmx.bmx01
        WHEN 'P' FETCH PREVIOUS i720_cs INTO g_bmx01,g_bmx.bmx01
        WHEN 'F' FETCH FIRST    i720_cs INTO g_bmx01,g_bmx.bmx01
        WHEN 'L' FETCH LAST     i720_cs INTO g_bmx01,g_bmx.bmx01
        WHEN '/'
            IF (NOT g_no_ask) THEN
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
            LET g_no_ask = FALSE
            FETCH ABSOLUTE g_jump i720_cs INTO g_bmx01,g_bmx.bmx01
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bmx.bmx01,SQLCA.sqlcode,0)
        INITIALIZE g_bmx.* TO NULL  #TQC-6B0105
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
 
    SELECT * INTO g_bmx.* FROM bmx_file WHERE bmx01 = g_bmx01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","bmx_file",g_bmx.bmx01,"",SQLCA.sqlcode,"","",1) # TQC-660046
        INITIALIZE g_bmx.* TO NULL
        LET g_bmx01 = NULL
        RETURN
    ELSE
        LET g_data_owner = g_bmx.bmxuser      #FUN-4C0054
        LET g_data_group = g_bmx.bmxgrup      #FUN-4C0054
        LET g_data_plant = g_bmx.bmxplant #FUN-980030
    END IF
    CALL i720_show()
END FUNCTION
 
FUNCTION i720_show()
    DEFINE l_bmg	RECORD LIKE bmg_file.*
 
    LET g_bmx_t.* = g_bmx.*                #保存單頭舊值
    DISPLAY BY NAME g_bmx.bmxoriu,g_bmx.bmxorig,
        g_bmx.bmx01,g_bmx.bmx02,g_bmx.bmx07,g_bmx.bmx10,g_bmx.bmx13, #FUN-630044  #CHI-9C0054  add bmx13
        g_bmx.bmx05,g_bmx.bmx04,g_bmx.bmxmksg,g_bmx.bmx09,g_bmx.bmx11, #FUN-540045  #FUN-820027 add g_bmx.bmx11
        g_bmx.bmxuser,g_bmx.bmxgrup,g_bmx.bmxmodu,g_bmx.bmxdate,g_bmx.bmxacti
    DECLARE i720_show_c CURSOR FOR
       SELECT * FROM bmg_file WHERE bmg01=g_bmx.bmx01 ORDER BY 2
    LET g_msg=NULL
    FOREACH i720_show_c INTO l_bmg.*
       LET g_msg=g_msg CLIPPED,l_bmg.bmg03
    END FOREACH
    DISPLAY g_msg TO bmg03_display

    CALL i720_field_pic()   #FUN-540045
    CALL i720_bmx10('d')                      #FUN-630044  
    CALL i720_bmx13('d')                      #CHI-9C0054
    CALL i720_b_fill(g_wc3) #No:8245
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i720_r()
    DEFINE l_chr,l_sure  LIKE type_file.chr1    #No.FUN-680096 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    SELECT * INTO g_bmx.* FROM bmx_file WHERE bmx01 = g_bmx01
    IF NOT s_dc_ud_flag('3',g_bmx.bmx11,g_plant,'r') THEN                                                                           
       CALL cl_err(g_bmx.bmx11,'aoo-044',1)                                                                                         
       RETURN                                                                                                                       
    END IF                                                                                                                          
    IF g_bmx.bmx01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_bmx.bmx04 = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF g_bmx.bmx04 = 'Y' THEN CALL cl_err('','mfg0175',0) RETURN END IF
    IF g_bmx.bmx09 matches '[Ss1]' THEN          #FUN-550040
         CALL cl_err('','mfg3557',0)
         RETURN
    END IF
 
    BEGIN WORK
 
    OPEN i720_cl USING g_bmx01
    IF STATUS THEN
       CALL cl_err("OPEN i720_cl:", STATUS, 1)
       CLOSE i720_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i720_cl INTO g_bmx.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_bmx.bmx01,SQLCA.sqlcode,0) ROLLBACK WORK RETURN
    END IF
    CALL i720_show()
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "bmx01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_bmx.bmx01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
        MESSAGE "Delete bmx,bmy,bmg!"
        DELETE FROM bmx_file WHERE bmx01 = g_bmx.bmx01
           IF STATUS THEN
              CALL cl_err3("del","bmx_file",g_bmx.bmx01,"",STATUS,"","del bmx",1) # TQC-660046
               ROLLBACK WORK RETURN    
           END IF
           IF SQLCA.SQLERRD[3]=0 THEN
              CALL cl_err('No bmx deleted',SQLCA.SQLCODE,0) ROLLBACK WORK RETURN
           END IF
        DELETE FROM bmy_file WHERE bmy01 = g_bmx.bmx01
           IF STATUS THEN
              CALL cl_err3("del","bmy_file",g_bmx.bmx01,"",STATUS,"","del bmy",1) # TQC-660046
              ROLLBACK WORK RETURN
           END IF
        IF g_argv1_str='1' THEN     #No.FUN-A60031 #FUN-AC0060(110705)  #CHI-CA0035 mod g_argv3->g_argv1
           DELETE FROM bmg_file WHERE bmg01 = g_bmx.bmx01
              IF STATUS THEN
                 CALL cl_err3("del","bmg_file",g_bmx.bmx01,"",STATUS,"","del bmg",1) # TQC-660046
                 ROLLBACK WORK RETURN
              END IF
           DELETE FROM bmw_file WHERE bmw01 = g_bmx.bmx01
              IF STATUS THEN
                 CALL cl_err3("del","bmw_file",g_bmx.bmx01,"",STATUS,"","del bmw",1)# TQC-660046
                 ROLLBACK WORK RETURN
              END IF
           LET g_msg=TIME
           INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)    #FUN-980001 add plant & legal 
              VALUES ('abmi720',g_user,g_today,g_msg,g_bmx.bmx01,'delete',g_plant,g_legal)#FUN-980001 add plant & legal 
        END IF       #No.FUN-A60031
        CLEAR FORM
        CALL g_bmy.clear()
        CALL g_bmw.clear()
        CALL g_ima.clear()
    	INITIALIZE g_bmx.* TO NULL
        OPEN i720_count
        #FUN-B50062-add-start--
        IF STATUS THEN
           CLOSE i720_cs  
           CLOSE i720_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50062-add-end--
        FETCH i720_count INTO g_row_count
        #FUN-B50062-add-start--
        IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
           CLOSE i720_cs  
           CLOSE i720_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50062-add-end--
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN i720_cs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL i720_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET g_no_ask = TRUE
           CALL i720_fetch('/')
        END IF
        MESSAGE ""
    END IF
    CLOSE i720_cl
    COMMIT WORK
    CALL cl_flow_notify(g_bmx.bmx01,'D')
END FUNCTION
 
FUNCTION i720_b()
DEFINE
    l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT        #No.FUN-680096 SMALLINT
    l_row,l_col     LIKE type_file.num5,     #No.FUN-680096 SMALLINT,  #分段輸入之行,列數
    l_n,l_cnt       LIKE type_file.num5,     #檢查重複用    #No.FUN-680096 SMALLINT
    p_cmd           LIKE type_file.chr1,     #處理狀態      #No.FUN-680096 VARCHAR(1)
    l_b2      	    LIKE type_file.chr50,    #No.FUN-680096 VARCHAR(30),
    l_ima35,l_ima36 LIKE ima_file.ima35,     #No.FUN-680096 VARCHAR(10),
    l_bmb06         LIKE bmb_file.bmb06,
    l_bmb07         LIKE bmb_file.bmb07,
    l_bmb16         LIKE bmb_file.bmb16,     #No.MOD-8B0109 add
    l_flag          LIKE type_file.num10,    #No.FUN-680096 INTEGER,
    l_lock_sw       LIKE type_file.chr1,     #單身鎖住否    #No.FUN-680096 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,     #可新增否      #No.FUN-680096 SMALLINT
    l_allow_delete  LIKE type_file.num5,     #可刪除否      #No.FUN-680096 SMALLINT
     l_chkinsitm    LIKE type_file.num5,     #No.FUN-680096 SMALLINT,  #MOD-530305 5 是否檢查成功
    l_bmx09         LIKE bmx_file.bmx09
DEFINE l_bmr07      LIKE bmr_file.bmr07      #MOD-740186  #MOD-A30171 mark
DEFINE l_ima151     LIKE ima_file.ima151     #NO.FUN-810014
DEFINE r_ima151     LIKE ima_file.ima151     #NO.FUN-810014
DEFINE l_bmb31      LIKE bmb_file.bmb31      #No.FUN-870127
DEFINE l_errno      LIKE type_file.chr10     #No.MOD-840645 add
DEFINE l_n1         LIKE type_file.num5      #No.FUN-A60008 
DEFINE comb_value      STRING                   #MOD-AC0029 add
DEFINE comb_item       STRING                   #MOD-AC0029 add
DEFINE l_bmb14      LIKE bmb_file.bmb14         #TQC-AC0171 add
DEFINE l_bmbud02   LIKE bmb_file.bmbud02
DEFINE l_bmbud06   LIKE bmb_file.bmbud06   #add by huanglf160927
DEFINE l_bmbud03   LIKE bmb_file.bmbud03   #add by huanglf161018
DEFINE l_bmbud04   LIKE bmb_file.bmbud04   #add by huanglf161018
    LET g_action_choice = ""
    SELECT * INTO g_bmx.* FROM bmx_file WHERE bmx01 = g_bmx01
    IF NOT s_dc_ud_flag('3',g_bmx.bmx11,g_plant,'u') THEN                                                                           
       CALL cl_err(g_bmx.bmx11,'aoo-045',1)                                                                                         
       RETURN                                                                                                                       
    END IF                                                                                                                          
    LET l_bmx09 = g_bmx.bmx09                #FUN-550040
    IF cl_null(g_bmx.bmx01) THEN RETURN END IF
    IF g_bmx.bmx04 = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF g_bmx.bmx04 = 'Y' THEN CALL cl_err('','mfg0175',0) RETURN END IF
    IF g_bmx.bmx09 matches '[Ss]' THEN       #FUN-550040
         CALL cl_err('','apm-030',0)
         RETURN
    END IF
 
    CALL cl_opmsg('b')
    #No.FUN-A60083--begin
    IF g_argv1_str='2' THEN  #FUN-AC0060(110705)  #CHI-CA0035 mod g_argv3->g_argv1
      CALL cl_set_comp_visible('bmy16',FALSE) 
    END IF 
    #No.FUN-A60083--end
    LET g_forupd_sql =
     "  SELECT * FROM bmy_file ",
     "    WHERE bmy01= ? ",
     "     AND bmy02= ? ",
     "  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i720_bcl CURSOR FROM g_forupd_sql
    LET l_ac_t = 0
      LET l_allow_insert = cl_detail_input_auth("insert")
      LET l_allow_delete = cl_detail_input_auth("delete")
 
      INPUT ARRAY g_bmy WITHOUT DEFAULTS FROM s_bmy.*
            ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF

 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
            #CHI-C30066---begin
            IF g_bmy[l_ac].bmy03 <> '2' THEN
               IF NOT cl_null(g_bmy[l_ac].bmy04) THEN
                  CALL cl_set_comp_entry("bmy05",FALSE)
               ELSE
                  CALL cl_set_comp_entry("bmy05",TRUE)
               END IF 
            ELSE 
               CALL cl_set_comp_entry("bmy05",TRUE)
            END IF 
            #CHI-C30066---end
            #CHI-C20060---begin
            IF g_bmy[l_ac].bmy03 = '6' THEN
               CALL cl_set_comp_entry("bmy16,bmy35,bmy30",FALSE)
               CALL cl_set_comp_required("bmy06,bmy07",TRUE)
               CALL cl_set_comp_entry("bmy36",TRUE)  #FUN-BB0075
            ELSE
               CALL cl_set_comp_entry("bmy16,bmy35,bmy30",TRUE)
               CALL cl_set_comp_required("bmy06,bmy07",FALSE)
               CALL cl_set_comp_entry("bmy36",FALSE)  #FUN-BB0075
            END IF  
            #CHI-C20060---end
            #FUN-BB0075---begin
            IF cl_null(g_bmy[l_ac].bmy36) THEN
               CALL cl_set_comp_entry("bmy06,bmy07",TRUE)
            ELSE
               CALL cl_set_comp_entry("bmy06,bmy07",FALSE)
            END IF 
            #FUN-BB0075---end
	    BEGIN WORK
            OPEN i720_cl USING g_bmx01
            IF STATUS THEN
               CALL cl_err("OPEN i720_cl:", STATUS, 1)
               CLOSE i720_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH i720_cl INTO g_bmx.*  # 鎖住將被更改或取消的資料
            IF STATUS THEN
               CALL cl_err('lock bmx:',SQLCA.sqlcode,0)     # 資料被他人LOCK
               CLOSE i720_cl
               ROLLBACK WORK
               RETURN
            END IF
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_bmy_t.* = g_bmy[l_ac].*  #BACKUP
                OPEN i720_bcl USING g_bmx.bmx01,g_bmy_t.bmy02
                IF STATUS THEN
                    CALL cl_err("OPEN i720_bcl:", STATUS, 1)
                ELSE
                    FETCH i720_bcl INTO b_bmy.*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err('lock bmy',SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    ELSE
                        CALL i720_b_move_to()
                        CALL i720_bmy27(g_bmy[l_ac].bmy05) RETURNING g_bmy[l_ac].ima02, g_bmy[l_ac].ima021
                        CALL i720_bmy27(g_bmy[l_ac].bmy14) RETURNING g_bmy[l_ac].ima02d, g_bmy[l_ac].ima021d
                        IF NOT cl_null(g_bmy[l_ac].bmy27) THEN
                           CALL i720_bmy27(g_bmy[l_ac].bmy27) RETURNING g_bmy[l_ac].ima02n, g_bmy[l_ac].ima021n
                        END IF
 
                        SELECT ima107,ima147 INTO g_ima107,g_ima147
                           FROM ima_file #MOD-490449
                         WHERE ima01=g_bmy[l_ac].bmy05 AND imaacti = 'Y'
                        IF g_bmy[l_ac].bmy03 = '4' THEN
                          SELECT ima107,ima147 INTO g_ima107,g_ima147
                            FROM ima_file
                           WHERE ima01=g_bmy[l_ac].bmy27 AND imaacti = 'Y'
                        END IF
                    END IF
                END IF
                LET g_bmy_t.* = g_bmy[l_ac].*      #BACKUP
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
            LET g_before_input_done = FALSE
            CALL i720_set_entry_b(p_cmd)
            CALL i720_set_no_entry_b(p_cmd)
            LET g_before_input_done = TRUE
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            CALL i720_b_move_back()
            IF b_bmy.bmy33 IS NULL THEN
              LET b_bmy.bmy33 = '0'
            END IF
            LET b_bmy.bmy33 = 0       #NO.FUN-840033 add
            #No.FUN-A60031--begin
            IF cl_null(b_bmy.bmy012) THEN 
               LET b_bmy.bmy012=' '
            END IF 
            IF cl_null(b_bmy.bmy013) THEN 
               LET b_bmy.bmy013=0
            END IF             
            #No.FUN-A60031--end 
            LET b_bmy.bmyplant = g_plant 
            LET b_bmy.bmylegal = g_legal 
 
            INSERT INTO bmy_file VALUES(b_bmy.*)
            IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","bmy_file",b_bmy.bmy01,b_bmy.bmy02,SQLCA.sqlcode,"","ins bmy",1) # TQC-660046
               ROLLBACK WORK
               CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
                LET l_bmx09 = '0'          #FUN-550040
                IF g_bmy[l_ac].bmy03 MATCHES '[23456]' THEN                  #MOD-910205 #CHI-960004 add 5 #CHI-C20060
                   LET g_flag = g_ima107   #MOD-910205 add
                   CALL i720_t()
                END IF
                COMMIT WORK   #TQC-6C0083 add
            END IF
 
        BEFORE INSERT
            LET p_cmd = 'a'
            LET l_n = ARR_COUNT()
            INITIALIZE g_bmy[l_ac].* TO NULL          #900423
            INITIALIZE b_bmy.* TO NULL
            IF g_sma.sma118 != 'Y' THEN
                LET g_bmy[l_ac].bmy30 = ' '
            ELSE
                LET g_bmy[l_ac].bmy30 = '1'
            END IF
            #No.FUN-A60031--begin
            IF g_argv1_str='1' THEN #FUN-AC0060(110705)  #CHI-CA0035 mod g_argv3->g_argv1
               LET g_bmy[l_ac].bmy011=' '
               LET g_bmy[l_ac].bmy012=' '
               LET g_bmy[l_ac].bmy013=0
            END IF 
            #No.FUN-A60031--end 
            #No.FUN-A60083--begin
            IF g_argv1_str='2' THEN #FUN-AC0060(110705)  #CHI-CA0035 mod g_argv3->g_argv1
               LET g_bmy[l_ac].bmy16='0' 
            END IF 
            #No.FUN-A60083--end            
            LET g_bmy[l_ac].bmy29 = ' '
            LET g_bmy[l_ac].bmy34 = 'N'  #No.CHI-920021 Add
            LET b_bmy.bmy01=g_bmx.bmx01
            LET g_bmy[l_ac].bmy07 = '1'   #MOD-910180  
            INITIALIZE g_bmy_t.* TO NULL
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD bmy02
 
        BEFORE FIELD bmy02                            #default 序號
            IF cl_null(g_bmy[l_ac].bmy02) OR g_bmy[l_ac].bmy02 = 0 THEN
                SELECT max(bmy02)+1 INTO g_bmy[l_ac].bmy02
                   FROM bmy_file WHERE bmy01 = g_bmx.bmx01
                IF g_bmy[l_ac].bmy02 IS NULL THEN
                    LET g_bmy[l_ac].bmy02 = 1
                END IF
            END IF
 
        AFTER FIELD bmy02                        #check 序號是否重複
            IF NOT cl_null(g_bmy[l_ac].bmy02) THEN
                IF g_bmy[l_ac].bmy02 != g_bmy_t.bmy02 OR
                   cl_null(g_bmy_t.bmy02) THEN
                    SELECT count(*) INTO l_n FROM bmy_file
                        WHERE bmy01 = g_bmx.bmx01 AND bmy02 = g_bmy[l_ac].bmy02
                    IF l_n > 0 THEN
                        LET g_bmy[l_ac].bmy02 = g_bmy_t.bmy02
                        CALL cl_err('',-239,0) NEXT FIELD bmy02
                    END IF
                END IF
            END IF
        BEFORE FIELD bmy03
            CALL i720_set_entry_b(p_cmd)
 
        AFTER FIELD bmy03
           IF NOT cl_null(g_bmy[l_ac].bmy03) THEN
               IF g_bmy[l_ac].bmy03 NOT MATCHES '[123456]'THEN  #CHI-960004 add 5 #CHI-C20060
                   NEXT FIELD bmy03
               END IF
 
              #IF g_bmy[l_ac].bmy03 != '4' THEN  #TQC-9C0129
               IF g_bmy[l_ac].bmy03 != '4' AND (g_bmy[l_ac].bmy03 IS NULL OR g_bmy_t.bmy03 != g_bmy[l_ac].bmy03) THEN  #TQC-9C0129
                  LET g_bmy[l_ac].bmy27 = ''
                  LET g_bmy[l_ac].ima02n = ''
                  DISPLAY g_bmy[l_ac].bmy27  TO bmy27
                  DISPLAY g_bmy[l_ac].ima02n TO ima02n
               END IF
              IF g_bmy[l_ac].bmy03 MATCHES '[2456]' THEN  #CHI-960004 add 5 #CHI-C20060
                 LET g_bmy[l_ac].bmy34 ='N'
              END IF             
              #No.FUN-A60083--begin
             #IF g_bmy[l_ac].bmy03='2' THEN 
              IF g_bmy[l_ac].bmy03='2' AND (g_bmy[l_ac].bmy03 IS NULL OR g_bmy_t.bmy03 != g_bmy[l_ac].bmy03) THEN  #TQC-C20144 mod
                 LET g_bmy[l_ac].bmy06=1
                 LET g_bmy[l_ac].bmy07=1
                 DISPLAY BY NAME g_bmy[l_ac].bmy06
                 DISPLAY BY NAME g_bmy[l_ac].bmy07
              END IF 
              #No.FUN-A60083--end
           END IF
           CALL i720_set_no_entry_b(p_cmd)
 
#MOD-B90120 -- mark begin --
       #BEFORE FIELD bmy04
       #   IF g_bmy[l_ac].bmy03 = '2' THEN
       #      IF NOT cl_null(g_bmy[l_ac].bmy14) AND g_cnt>0 THEN
       #         CALL cl_err('','mfg-015',0)
       #      END IF
       #   END IF
#MOD-B90120 -- mark end --
 
        AFTER FIELD bmy04
         IF s_industry('slk') THEN
          IF g_bmy[l_ac].bmy03 MATCHES "[13456]" THEN    #No.FUN-870127  by ve007  #CHI-960004 add 5 #CHI-C20060
            IF g_bmy[l_ac].bmy04 IS NULL THEN
                   CALL cl_err('','abm-622',0)
                   NEXT FIELD bmy04
            END IF
          END IF
         END IF
          IF NOT cl_null(g_bmy[l_ac].bmy04) THEN
             IF g_bmy[l_ac].bmy03 = '2' THEN
                CALL i720_chk_bmb() RETURNING l_errno
                IF NOT cl_null(l_errno) THEN
                   CALL cl_err('',l_errno,1)
                   NEXT FIELD bmy04
                END IF
             END IF
             #FUN-D10093 add----str----
             IF g_aza.aza121='Y' THEN
                 CALL i720_get_plm()
             END IF
             #FUN-D10093 add----end----
          END IF
          #CHI-C30066---begin
          IF g_bmy[l_ac].bmy03 <> '2' THEN
             IF NOT cl_null(g_bmy[l_ac].bmy04) THEN
                CALL cl_set_comp_entry("bmy05",FALSE)
             ELSE
                CALL cl_set_comp_entry("bmy05",TRUE)
             END IF 
          ELSE 
             CALL cl_set_comp_entry("bmy05",TRUE)
          END IF 
          #CHI-C30066---end
          
        AFTER FIELD bmy06    #組成用量不可小于零
#MOD-B70105  ---begin
      #   IF NOT cl_null(g_bmy[l_ac].bmy06) THEN
      #       IF g_bmy[l_ac].bmy06 <= 0 THEN
      #           CALL cl_err(g_bmy[l_ac].bmy06,'mfg2614',0)
      #           LET g_bmy[l_ac].bmy06 = g_bmy_t.bmy06
      #           DISPLAY BY NAME g_bmy[l_ac].bmy06
      #           NEXT FIELD bmy06
      #       END IF
      #   ELSE                                  #MOD-B50058 add
      #      LET g_bmy[l_ac].bmy06 = 1          #MOD-B50058 add
      #   END IF
#MOD-B70105  --end
          #TQC-C40119--mark--str--
          #LET g_bmy_t.bmy06 = g_bmy[l_ac].bmy06
          #  IF g_ima147 ='Y'   THEN 
          #     LET g_flag = g_ima107   #MOD-910205 add
          #     CALL i720_t() 
          #  END IF    
          #TQC-C40119--mark--end--

       #No.FUN-A60083--begin
        BEFORE FIELD bmy07 
           IF g_bmy[l_ac].bmy03='2' THEN 
              IF cl_null(g_bmy[l_ac].bmy07) THEN #TQC-C20144 add
                 LET g_bmy[l_ac].bmy07=1
              END IF    #TQC-C20144 add
           END IF 
        #No.FUN-A60083--end           

        AFTER FIELD bmy07    #底數不可小于等于零
            IF NOT cl_null(g_bmy[l_ac].bmy07) THEN
                IF g_bmy[l_ac].bmy07 <= 0 THEN
                   CALL cl_err(g_bmy[l_ac].bmy07,'mfg2615',0)
                   LET g_bmy[l_ac].bmy07 = g_bmy_t.bmy07
                   DISPLAY BY NAME g_bmy[l_ac].bmy07
                   NEXT FIELD bmy07
                END IF
                LET g_bmy_t.bmy07 = g_bmy[l_ac].bmy07
            ELSE
               IF g_bmy[l_ac].bmy03 != '4' THEN   #MOD-A40058 add 
               LET g_bmy[l_ac].bmy07 = 1
               END IF   #MOD-A40058 add     
            END IF
            #TQC-C40119--add--str--
            IF g_ima147 ='Y'   THEN 
               LET g_flag = g_ima107   #MOD-910205 add
               CALL i720_t() 
            END IF    
            #TQC-C40119--add--end--
        AFTER FIELD bmy30
           IF NOT cl_null(g_bmy[l_ac].bmy30) THEN
             SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01 = g_bmy[l_ac].bmy14 
             SELECT ima151 INTO r_ima151 FROM ima_file WHERE ima01 = g_bmy[l_ac].bmy05
              IF l_ima151 <>'Y' OR r_ima151 <> 'Y' THEN 
                  IF g_bmy[l_ac].bmy30 ='4' THEN
                       CALL cl_err('','abm-000',0) #FUN-870127
                       NEXT FIELD bmy30
                  END IF
              END IF
           END IF
        AFTER FIELD bmy14
           IF NOT cl_null(g_bmy[l_ac].bmy14) THEN
              #FUN-AA0059 ---------------------------------add start-----------------------
               IF NOT s_chk_item_no(g_bmy[l_ac].bmy14,'') THEN
                  CALL cl_err('',g_errno,1)
                  LET g_bmy[l_ac].bmy14 = g_bmy_t.bmy14
                  DISPLAY BY NAME g_bmy[l_ac].bmy14
                  NEXT FIELD bmy14
               END IF 
              #FUN-AA0059 ------------------------------add end---------------------------
               CALL s_field_chk(g_bmy[l_ac].bmy14,'3',g_plant,'bmz02') RETURNING g_flag2                                                  
               IF g_flag2 = '0' THEN                                                                                                
                  CALL cl_err(g_bmy[l_ac].bmy14,'aoo-043',1)                                                                              
                  LET g_bmy[l_ac].bmy14 = g_bmy_t.bmy14                                                                                   
                  DISPLAY BY NAME g_bmy[l_ac].bmy14                                                                                       
                  NEXT FIELD bmy14                                                                                                  
               END IF
               #str MOD-A30171 mark                                                                                                               
               #IF NOT cl_null(g_bmx.bmx05) THEN
               #   SELECT bmr07 INTO l_bmr07 FROM bmr_file
               #                            WHERE bmr01=g_bmx.bmx05
               #                              AND bmrconf = 'Y'  #FUN-950045
               #   IF g_bmy[l_ac].bmy14<>l_bmr07 THEN
               #      CALL cl_err('','abm-024',1)
               #      NEXT FIELD bmy14
               #   END IF
               #END IF 
               #end MOD-A30171 mark
               #No.FUN-A60008--begin 
               IF g_argv1_str='1' THEN #FUN-AC0060(110705)  #CHI-CA0035 mod g_argv3->g_argv1
                  IF g_sma.sma542='Y' THEN 
                     SELECT COUNT(*) INTO l_n1 FROM bra_file WHERE bra01=g_bmy[l_ac].bmy14 
                     IF l_n1>0 THEN 
                        CALL cl_err('','abm-225',1)
                        NEXT FIELD bmy14
                     END IF 
                  END IF 
               END IF 
               #No.FUN-A60008--end                  
               IF NOT cl_null(g_bmy[l_ac].bmy05)    THEN
                  IF g_bmy[l_ac].bmy03 MATCHES '[13456]' THEN   #CHI-960004 add 5 #CHI-C20060
                     LET l_cnt = 0
                     IF g_argv1_str='1' THEN  #No.FUN-A60008 #FUN-AC0060(110705)  #CHI-CA0035 mod g_argv3->g_argv1
                     IF NOT cl_null(g_bmy[l_ac].bmy04) THEN
                        SELECT COUNT(*) INTO l_cnt FROM bmb_file
                         WHERE bmb01 = g_bmy[l_ac].bmy14
                           AND bmb02 = g_bmy[l_ac].bmy04
                           AND bmb03 = g_bmy[l_ac].bmy05
                           AND (bmb04 <= g_bmx.bmx07 OR bmb04 IS NULL)
                           AND (bmb05 >  g_bmx.bmx07 OR bmb05 IS NULL)
                     ELSE
                        SELECT COUNT(*) INTO l_cnt FROM bmb_file
                         WHERE bmb01 = g_bmy[l_ac].bmy14
                           AND bmb03 = g_bmy[l_ac].bmy05
                           AND (bmb04 <= g_bmx.bmx07 OR bmb04 IS NULL)
                           AND (bmb05 >  g_bmx.bmx07 OR bmb05 IS NULL)
                     END IF
                     IF  l_cnt = 0 THEN
                         CALL cl_err('sel bmb','mfg2631',0) 
                         NEXT FIELD bmy14
                     END IF
                     END IF  #No.FUN-A60008
                     #No.FUN-A60008--begin
                     IF g_argv1_str='2' THEN #FUN-AC0060(110705)  #CHI-CA0035 mod g_argv3->g_argv1
                     IF NOT cl_null(g_bmy[l_ac].bmy04) THEN
                        SELECT COUNT(*) INTO l_cnt FROM brb_file
                         WHERE brb01 = g_bmy[l_ac].bmy14
                           AND brb02 = g_bmy[l_ac].bmy04
                           AND brb03 = g_bmy[l_ac].bmy05
                           AND (brb04 <= g_bmx.bmx07 OR brb04 IS NULL)
                           AND (brb05 >  g_bmx.bmx07 OR brb05 IS NULL)
                     ELSE
                        SELECT COUNT(*) INTO l_cnt FROM brb_file
                         WHERE brb01 = g_bmy[l_ac].bmy14
                           AND brb03 = g_bmy[l_ac].bmy05
                           AND (brb04 <= g_bmx.bmx07 OR brb04 IS NULL)
                           AND (brb05 >  g_bmx.bmx07 OR brb05 IS NULL)
                     END IF
                     IF  l_cnt = 0 THEN
                         CALL cl_err('sel brb','mfg2631',0) 
                         NEXT FIELD bmy14
                     END IF
                     END IF 
                     #No.FUN-A60008--end                     
                   END IF
                   IF g_bmy[l_ac].bmy03 = '2' THEN
                      LET l_cnt = 0
                      IF g_argv1_str='1' THEN #No.FUN-A60008 #FUN-AC0060(110705) #CHI-CA0035 mod g_argv3->g_argv1
                      SELECT count(*) INTO l_cnt FROM bmb_file
                       WHERE bmb01 = g_bmy[l_ac].bmy14
                         AND bmb03 = g_bmy[l_ac].bmy05
                         AND (bmb04 <= g_bmx.bmx07 OR bmb04 IS NULL)
                         AND (bmb05 >  g_bmx.bmx07 OR bmb05 IS NULL)
                      IF l_cnt > 0 THEN
                         IF NOT cl_confirm('abm-728') THEN
                            NEXT FIELD bmy14
                         END IF
                      END IF
                      END IF  #No.FUN-A60008
                      #No.FUN-A60008--begin
                      IF g_argv1_str='2' THEN #FUN-AC0060(110705)  #CHI-CA0035 mod g_argv3->g_argv1
                         SELECT count(*) INTO l_cnt FROM brb_file
                          WHERE brb01 = g_bmy[l_ac].bmy14
                            AND brb03 = g_bmy[l_ac].bmy05
                            AND (brb04 <= g_bmx.bmx07 OR brb04 IS NULL)
                            AND (brb05 >  g_bmx.bmx07 OR brb05 IS NULL)
                         IF l_cnt > 0 THEN
                            IF NOT cl_confirm('abm-728') THEN
                               NEXT FIELD bmy14
                            END IF
                         END IF
                      END IF  
                      #No.FUN-A60008--end                      
                   END IF
               END IF
               CALL i720_bmy27(g_bmy[l_ac].bmy14) RETURNING g_bmy[l_ac].ima02d,g_bmy[l_ac].ima021d
               DISPLAY BY NAME g_bmy[l_ac].ima02d
               DISPLAY BY NAME g_bmy[l_ac].ima021d
               IF NOT cl_null(g_errno) THEN
                   CALL cl_err('sel ima',g_errno,0)
                   NEXT FIELD bmy14
               ELSE
                   SELECT ima05 INTO g_bmy[l_ac].bmy171 FROM ima_file
                    WHERE ima01 = g_bmy[l_ac].bmy14
               END IF
               DISPLAY BY NAME g_bmy[l_ac].bmy171
               IF g_argv1_str='1' THEN #FUN-AC0060(110705)  #CHI-CA0035 mod g_argv3->g_argv1
                  SELECT COUNT(*) INTO g_cnt FROM bma_file
                   WHERE bma01 = g_bmy[l_ac].bmy14
                     AND (bma05 IS NULL OR bma05 >g_bmx.bmx07)
                     AND bma06 = g_bmy[l_ac].bmy29                                #TQC-920056
               ELSE 
               	  SELECT COUNT(*) INTO g_cnt FROM bra_file
                  WHERE bra01 = g_bmy[l_ac].bmy14
                    AND (bra05 IS NULL OR bra05 >g_bmx.bmx07)
                    AND bra06 = g_bmy[l_ac].bmy29
               END IF    
               IF g_cnt> 0 THEN
                  CALL cl_err(g_bmy[l_ac].bmy14,'abm-005',0)
                  NEXT FIELD bmy14
               END IF
               IF g_argv1_str='1' THEN  #No.FUN-A60008 #FUN-AC0060(110705)  #CHI-CA0035 mod g_argv3->g_argv1
                  SELECT COUNT(*) INTO g_cnt FROM bma_file
                    WHERE bma01=g_bmy[l_ac].bmy14 AND bmaacti='Y'
               #No.FUN-A60008--begin     
               ELSE 
                 	SELECT COUNT(*) INTO g_cnt FROM bra_file
                   WHERE bra01=g_bmy[l_ac].bmy14 AND braacti='Y'
               END IF 
               #No.FUN-A60008--end 
                  IF g_cnt =0 THEN
                     CALL cl_err(g_bmy[l_ac].bmy14,'abm-742',0)
                     NEXT FIELD bmy14
                  END IF
               IF g_bmy[l_ac].bmy03 = '2' THEN
                  IF NOT cl_null(g_bmy[l_ac].bmy04) THEN
                     LET g_cnt=0
                     IF cl_null(g_bmy[l_ac].bmy29) THEN LET g_bmy[l_ac].bmy29 = ' ' END IF   #No.MOD-840645 add
                     IF g_argv1_str='1' THEN  #No.FUN-A60008 #FUN-AC0060(110705)  #CHI-CA0035 mod g_argv3->g_argv1
                        SELECT COUNT(*) INTO g_cnt FROM bmb_file
                         WHERE bmb01 = g_bmy[l_ac].bmy14
                           AND bmb02 = g_bmy[l_ac].bmy04
                           AND bmb29 = g_bmy[l_ac].bmy29       #No.MOD-840645 add
                           AND (bmb04 <= g_bmx.bmx07 OR bmb04 IS NULL)
                           AND (bmb05 >  g_bmx.bmx07 OR bmb05 IS NULL)
                     ELSE 
                     	 #No.FUN-A60008--begin
                        SELECT COUNT(*) INTO g_cnt FROM brb_file
                         WHERE brb01 = g_bmy[l_ac].bmy14
                           AND brb02 = g_bmy[l_ac].bmy04
                           AND brb29 = g_bmy[l_ac].bmy29      
                           AND (brb04 <= g_bmx.bmx07 OR brb04 IS NULL)
                           AND (brb05 >  g_bmx.bmx07 OR brb05 IS NULL)                     	
                     END IF 
                     #No.FUN-A60008--end  
                     IF g_cnt> 0 THEN
                        CALL cl_err(g_bmy[l_ac].bmy04,'<input type="text" mfg-015>',0)
                        NEXT FIELD bmy04
                     END IF
                     CALL i720_chk_bmb() RETURNING l_errno
                     IF NOT cl_null(l_errno) THEN
                        CALL cl_err('',l_errno,1)
                        NEXT FIELD bmy04
                     END IF
                   END IF
               END IF
               IF cl_null(g_bmy_t.bmy14) OR g_bmy_t.bmy14 != g_bmy[l_ac].bmy14 THEN #CHI-960004
                  IF NOT cl_null(g_bmy[l_ac].bmy04)    THEN
                     SELECT COUNT(*) INTO g_cnt FROM bmy_file
                      WHERE bmy01=g_bmx.bmx01 AND bmy04=g_bmy[l_ac].bmy04
                        AND bmy14=g_bmy[l_ac].bmy14
                     IF g_cnt > 0 THEN
                        CALL cl_err(g_bmy[l_ac].bmy14,'aim-401',0)
                        NEXT FIELD bmy14
                     END IF
                  END IF
               END IF    #CHI-960004
               IF g_sma.sma118 !='Y' THEN #FUN-550014 add if 判斷
                   IF g_bmy[l_ac].bmy03 <> '2' THEN   #No.B409 add
                     IF NOT cl_null(g_bmy[l_ac].bmy04) THEN
                        CALL i720_bmy14()
                        IF NOT cl_null(g_errno) THEN
                           CALL cl_err('bmy04+bmy14+bmy29:',g_errno,0)  NEXT FIELD bmy04
                        END IF
                     END IF
                   END IF    #No.B409 add
               END IF
               CALL i720_chkinsitm() RETURNING l_chkinsitm
               IF NOT l_chkinsitm THEN
                 NEXT FIELD bmy14
               END IF
               IF g_bmy[l_ac].bmy03 = '4' THEN
                   LET l_cnt = 0
                   SELECT count(*) INTO l_cnt FROM bmb_file
                    WHERE bmb01 = g_bmy[l_ac].bmy14
                      AND bmb03 = g_bmy[l_ac].bmy27
                      AND (bmb04 <= g_bmx.bmx07 OR bmb04 IS NULL)
                      AND (bmb05 >  g_bmx.bmx07 OR bmb05 IS NULL)
                   IF l_cnt > 0 THEN
                      IF NOT cl_confirm('abm-728') THEN
                         NEXT FIELD bmy27
                      END IF
                   END IF
               END IF
               LET l_cnt=0         
               IF g_argv1_str='1' THEN  #No.FUN-A60008  #FUN-AC0060(110705) #CHI-CA0035 mod g_argv3->g_argv1                                                                                        
                  SELECT COUNT(*) INTO l_cnt FROM bma_file                                                                             
                  WHERE bma01  = g_bmy[l_ac].bmy14     
               ELSE 
                   SELECT COUNT(*) INTO l_cnt FROM bra_file                                                                             
                  WHERE bra01  = g_bmy[l_ac].bmy14     
               END IF                                                                            
               IF l_cnt = 0 THEN                                                                                                    
                  CALL cl_err(g_bmy[l_ac].bmy14,'abm-748',0)                                                                        
                  NEXT FIELD bmy14                                                                                                  
               END IF                                                                                                               
               LET l_cnt=0       
               IF g_argv1_str='1' THEN  #No.FUN-A60008      #FUN-AC0060(110705)  #CHI-CA0035 mod g_argv3->g_argv1                                                                                              
                  SELECT COUNT(*) INTO l_cnt FROM bma_file                                                                             
                   WHERE bmaacti='Y'
               ELSE  
               	  SELECT COUNT(*) INTO l_cnt FROM bra_file                                                                             
                   WHERE braacti='Y'
               END IF                                                                                                     
               IF l_cnt=0 THEN                                                                                                      
                  CALL cl_err(g_bmy[l_ac].bmy14,'abm-201',0)                                                                        
                  NEXT FIELD bmy14                                                                                                  
               END IF    
               #FUN-BB0075---begin
               IF g_bmy[l_ac].bmy03 = '6' THEN 
                  IF NOT cl_null(g_bmy[l_ac].bmy05) AND NOT cl_null(g_bmy[l_ac].bmy27) THEN
                     SELECT bmd07 INTO g_bmy[l_ac].bmy06
                       FROM bmd_file
                      WHERE bmd08 = g_bmy[l_ac].bmy14
                        AND bmd01 = g_bmy[l_ac].bmy05
                        AND bmd04 = g_bmy[l_ac].bmy27
                        AND bmd02 = '2'

                     DISPLAY BY NAME g_bmy[l_ac].bmy06
                  END IF 
               END IF 
               #FUN-BB0075---end        
               #FUN-D10093 add----str----
               IF g_aza.aza121='Y' THEN
                   CALL i720_get_plm()
               END IF
               #FUN-D10093 add----end----      
            END IF
         #No.FUN-A60008--begin   
         AFTER FIELD bmy011 
            IF NOT cl_null(g_bmy[l_ac].bmy011) THEN 
               SELECT COUNT(*) INTO l_n FROM bra_file WHERE bra01=g_bmy[l_ac].bmy14 
                  AND bra011=g_bmy[l_ac].bmy011
                  AND braacti='Y' AND bra10='2' 
               IF l_n=0 THEN 
                  CALL cl_err('','abm-226',1)
                  NEXT FIELD bmy011
               END IF 
            END IF 
         AFTER FIELD bmy012 
            IF NOT cl_null(g_bmy[l_ac].bmy012) THEN 
               SELECT COUNT(*) INTO l_n FROM bra_file WHERE bra01=g_bmy[l_ac].bmy14 
                  AND bra011=g_bmy[l_ac].bmy011
                  AND bra012=g_bmy[l_ac].bmy012
                  AND braacti='Y' AND bra10='2' 
               IF l_n=0 THEN 
                  CALL cl_err('','abm-227',1)
                  NEXT FIELD bmy012
               END IF 
            END IF 
            IF cl_null(g_bmy[l_ac].bmy012) THEN 
               LET g_bmy[l_ac].bmy012=' '
            END IF 
         AFTER FIELD bmy013 
            IF NOT cl_null(g_bmy[l_ac].bmy013) THEN 
               SELECT COUNT(*) INTO l_n FROM bra_file WHERE bra01=g_bmy[l_ac].bmy14 
                  AND bra011=g_bmy[l_ac].bmy011
                  AND bra012=g_bmy[l_ac].bmy012
                  AND bra013=g_bmy[l_ac].bmy013
                  AND braacti='Y' AND bra10='2' 
               IF l_n=0 THEN 
                  CALL cl_err('','abm-228',1)
                  NEXT FIELD bmy013
               END IF 
            END IF       
            IF cl_null(g_bmy[l_ac].bmy013) THEN 
               LET g_bmy[l_ac].bmy013=0
            END IF                 
         #No.FUN-A60008--end    
        AFTER FIELD bmy29
           IF cl_null(g_bmy[l_ac].bmy29) THEN
               LET g_bmy[l_ac].bmy29=' '
           END IF
           SELECT COUNT(*) INTO g_cnt FROM bma_file
              WHERE bma01=g_bmy[l_ac].bmy14 AND bmaacti='Y'
                AND bma06=g_bmy[l_ac].bmy29
              IF g_cnt =0 THEN
              #  CALL cl_err(g_bmy[l_ac].bmy14,'abm-742',0)     #TQC-C80065
                 CALL cl_err(g_bmy[l_ac].bmy14,'abm-751',0)     #TQC-C80065
                 NEXT FIELD bmy29
              END IF
           IF g_bmy[l_ac].bmy03 <> '2' THEN   #No.B409 add
             IF NOT cl_null(g_bmy[l_ac].bmy04) THEN
                CALL i720_bmy14()
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('bmy04+bmy14+bmy29:',g_errno,0)  NEXT FIELD bmy04
                END IF
             END IF
           END IF    #No.B409 add
        AFTER FIELD bmy05
           IF NOT cl_null(g_bmy[l_ac].bmy05) THEN

           
              #FUN-AA0059 ----------------------------add start--------------------
               IF NOT s_chk_item_no(g_bmy[l_ac].bmy05,'') THEN
                  CALL cl_err('',g_errno,1)
                  NEXT FIELD bmy05
               END IF 
              #FUN-AA0059 --------------------------------add end-------------------- 
               IF g_bmy[l_ac].bmy03 != '1' THEN
                  SELECT COUNT(*) INTO g_cnt
                    FROM ima_file
                   WHERE ima01=g_bmy[l_ac].bmy05
                     AND (ima140='N'
                     OR (ima140='Y' AND ima1401 > g_bmx.bmx07))  #FUN-6A0036
                  IF g_cnt=0        THEN
                      CALL cl_err('','aim-809',0)
                     NEXT FIELD bmy05
                  END IF
                 IF g_bmy[l_ac].bmy05 = g_bmy[l_ac].bmy14 THEN 
                    CALL cl_err('sel bmb','mfg2633',0) NEXT FIELD bmy05
                 END IF
                 #str----add by chenkun160815
                  SELECT bmbud02 INTO g_bmy[l_ac].ta_bmy01 FROM bma_file,bmb_file 
                  WHERE bma01 = bmb01 AND bmb01 = g_bmy[l_ac].bmy14 AND bmb03 = g_bmy[l_ac].bmy05
                  DISPLAY BY NAME g_bmy[l_ac].ta_bmy01
                 #end----add by chenkun160815

                 #str----add by huanglf160927
                  SELECT bmbud06 INTO g_bmy[l_ac].ta_bmy02 FROM bma_file,bmb_file 
                  WHERE bma01 = bmb01 AND bmb01 = g_bmy[l_ac].bmy14 AND bmb03 = g_bmy[l_ac].bmy05
                  DISPLAY BY NAME g_bmy[l_ac].ta_bmy02
                 #str----end by huanglf160927

                 #str---add by huanglf161018        
                  SELECT bmbud03 INTO g_bmy[l_ac].ta_bmy03 FROM bma_file,bmb_file 
                  WHERE bma01 = bmb01 AND bmb01 = g_bmy[l_ac].bmy14 AND bmb03 = g_bmy[l_ac].bmy05
                  DISPLAY BY NAME g_bmy[l_ac].ta_bmy03

                  SELECT bmbud04 INTO g_bmy[l_ac].ta_bmy04 FROM bma_file,bmb_file 
                  WHERE bma01 = bmb01 AND bmb01 = g_bmy[l_ac].bmy14 AND bmb03 = g_bmy[l_ac].bmy05
                  DISPLAY BY NAME g_bmy[l_ac].ta_bmy04
                 #str---end by huanglf161018
               END IF
               IF g_bmy[l_ac].bmy03 MATCHES '[13]'  THEN 
                  IF g_argv1_str='1' THEN #FUN-AC0060(110705)  #CHI-CA0035 mod g_argv3->g_argv1
                     SELECT bmb31 INTO l_bmb31 FROM bmb_file
                       WHERE bmb01 = g_bmy[l_ac].bmy14
                         AND bmb03 = g_bmy[l_ac].bmy05
                         AND (bmb04 <= g_bmx.bmx07 OR bmb04 IS NULL)
                         AND (bmb05 >  g_bmx.bmx07 OR bmb05 IS NULL)
                  ELSE 
                  	 SELECT brb31 INTO l_bmb31 FROM brb_file
                     WHERE brb01 = g_bmy[l_ac].bmy14
                       AND brb011=g_bmy[l_ac].bmy011
                       AND brb012=g_bmy[l_ac].bmy012
                       AND brb013=g_bmy[l_ac].bmy013
                       AND brb03 = g_bmy[l_ac].bmy05
                       AND (brb04 <= g_bmx.bmx07 OR brb04 IS NULL)
                       AND (brb05 >  g_bmx.bmx07 OR brb05 IS NULL)
                  END IF 
                  LET g_bmy[l_ac].bmy34 = l_bmb31
               END IF          
               DISPLAY BY NAME g_bmy[l_ac].bmy34            #MOD-B70091 add

               IF g_bmy[l_ac].bmy03 MATCHES '[13456]' THEN   #bugno:6845 modify #CHI-960004 5 #CHI-C20060
                  LET l_cnt = 0
                  IF NOT cl_null(g_bmy[l_ac].bmy04) THEN
                     IF g_argv1_str='1' THEN #FUN-AC0060(110705)  #CHI-CA0035 mod g_argv3->g_argv1
                        SELECT COUNT(*) INTO l_cnt FROM bmb_file
                         WHERE bmb01 = g_bmy[l_ac].bmy14
                           AND bmb02 = g_bmy[l_ac].bmy04
                           AND bmb03 = g_bmy[l_ac].bmy05
                           AND (bmb04 <= g_bmx.bmx07 OR bmb04 IS NULL)
                           AND (bmb05 >  g_bmx.bmx07 OR bmb05 IS NULL)
                     ELSE 
                     	  SELECT COUNT(*) INTO l_cnt FROM brb_file
                         WHERE brb01 = g_bmy[l_ac].bmy14
                           AND brb011=g_bmy[l_ac].bmy011
                           AND brb012=g_bmy[l_ac].bmy012
                           AND brb013=g_bmy[l_ac].bmy013
                           AND brb02 = g_bmy[l_ac].bmy04
                           AND brb03 = g_bmy[l_ac].bmy05
                           AND (brb04 <= g_bmx.bmx07 OR brb04 IS NULL)
                           AND (brb05 >  g_bmx.bmx07 OR brb05 IS NULL)
                     END IF 
                  ELSE
                  	 IF g_argv1_str='1' THEN #FUN-AC0060(110705)  #CHI-CA0035 mod g_argv3->g_argv1
                        SELECT COUNT(*) INTO l_cnt FROM bmb_file
                         WHERE bmb01 = g_bmy[l_ac].bmy14
                           AND bmb03 = g_bmy[l_ac].bmy05
                           AND (bmb04 <= g_bmx.bmx07 OR bmb04 IS NULL)
                           AND (bmb05 >  g_bmx.bmx07 OR bmb05 IS NULL)
                     ELSE 
                     	  SELECT COUNT(*) INTO l_cnt FROM brb_file
                         WHERE brb01 = g_bmy[l_ac].bmy14
                           AND brb011=g_bmy[l_ac].bmy011
                           AND brb012=g_bmy[l_ac].bmy012
                           AND brb013=g_bmy[l_ac].bmy013
                           AND brb03 = g_bmy[l_ac].bmy05
                           AND (brb04 <= g_bmx.bmx07 OR brb04 IS NULL)
                           AND (brb05 >  g_bmx.bmx07 OR brb05 IS NULL)
                     END IF 
                  END IF
                  IF  l_cnt = 0 THEN
                      #CALL cl_err('sel bmb','mfg2631',0) NEXT FIELD bmy05  #No.FUN-A60083
                      CALL cl_err('','mfg2631',0) NEXT FIELD bmy05  #No.FUN-A60083
                  END IF
                END IF
                IF g_bmy[l_ac].bmy03 = '2' THEN
                   LET l_cnt = 0
                   IF g_argv1_str='1' THEN #FUN-AC0060(110705)  #CHI-CA0035 mod g_argv3->g_argv1
                      SELECT count(*) INTO l_cnt FROM bmb_file
                       WHERE bmb01 = g_bmy[l_ac].bmy14
                         AND bmb03 = g_bmy[l_ac].bmy05
                         AND (bmb04 <= g_bmx.bmx07 OR bmb04 IS NULL)
                         AND (bmb05 >  g_bmx.bmx07 OR bmb05 IS NULL)
                   ELSE 
                      SELECT COUNT(*) INTO l_cnt FROM brb_file
                       WHERE brb01 = g_bmy[l_ac].bmy14
                         AND brb011=g_bmy[l_ac].bmy011
                         AND brb012=g_bmy[l_ac].bmy012
                         AND brb013=g_bmy[l_ac].bmy013
                         AND brb03 = g_bmy[l_ac].bmy05
                         AND (brb04 <= g_bmx.bmx07 OR brb04 IS NULL)
                         AND (brb05 >  g_bmx.bmx07 OR brb05 IS NULL)                   	
                   END IF 
                   IF l_cnt > 0 THEN
                      IF NOT cl_confirm('abm-728') THEN
                         NEXT FIELD bmy05
                      END IF
                   END IF
                ELSE 
                   #檢查單身所輸入的設變料件是否己有存在ECN的單據且
                   #單據已確認,但生效日尚未到者,則不可再key單
                   LET l_cnt = 0
                   IF g_argv1_str='1' THEN #FUN-AC0060(110705)  #CHI-CA0035 mod g_argv3->g_argv1
                   SELECT COUNT(*) INTO l_cnt FROM bmb_file
                    WHERE bmb01 = g_bmy[l_ac].bmy14
                      AND bmb03 = g_bmy[l_ac].bmy05
                      AND (bmb04 > g_bmx.bmx07 AND bmb04 IS NOT NULL)
                      AND bmb05 IS NULL
                   ELSE 
                   	  SELECT COUNT(*) INTO l_cnt FROM brb_file
                       WHERE brb01 = g_bmy[l_ac].bmy14
                         AND brb03 = g_bmy[l_ac].bmy05
                         AND brb011=g_bmy[l_ac].bmy011
                         AND brb012=g_bmy[l_ac].bmy012
                         AND brb013=g_bmy[l_ac].bmy013
                         AND (brb04 > g_bmx.bmx07 AND brb04 IS NOT NULL)
                         AND brb05 IS NULL   
                   END IF 
                   IF l_cnt > 0 THEN
                      CALL cl_err(g_bmy[l_ac].bmy05,'abm-729','1')
                      NEXT FIELD bmy05
                   END IF
                END IF
               #IF p_cmd = 'a' AND g_bmy[l_ac].bmy03 MATCHES '[13456]' THEN  #CHI-960004 add 5 #CHI-C20060  #MOD-CB0238 mark
                IF g_bmy[l_ac].bmy03 MATCHES '[13456]' THEN                  #MOD-CB0238
                   IF g_bmy[l_ac].bmy03 MATCHES '[1346]' THEN    #CHI-960004 add 5    #No:MOD-A10114 del 5 #CHI-C20060
                       IF cl_null(g_bmy[l_ac].bmy04) THEN
                          IF g_argv1_str='1' THEN #FUN-AC0060(110705)  #CHI-CA0035 mod g_argv3->g_argv1
                             SELECT bmb06,bmb07,bmb16,bmb14 INTO l_bmb06,l_bmb07,l_bmb16,l_bmb14 FROM bmb_file     #No.MOD-8B0109 modify    #TQC-AC0171 add bmb14
                              WHERE bmb01 = g_bmy[l_ac].bmy14
                                AND bmb03 = g_bmy[l_ac].bmy05
                                AND bmb04 = (SELECT MAX(bmb04) FROM bmb_file
                                              WHERE bmb01 = g_bmy[l_ac].bmy14
                                                AND bmb03 = g_bmy[l_ac].bmy05)
                                AND (bmb04 <= g_bmx.bmx07 OR bmb04 IS NULL)
                                AND (bmb05 >  g_bmx.bmx07 OR bmb05 IS NULL)
                          ELSE 
                          	 SELECT brb06,brb07,brb16,brb14 INTO l_bmb06,l_bmb07,l_bmb16,l_bmb14 FROM brb_file   #TQC-AC0171 add brb14   
                              WHERE brb01 = g_bmy[l_ac].bmy14
                                AND brb03 = g_bmy[l_ac].bmy05
                                AND brb011=g_bmy[l_ac].bmy011
                                AND brb012=g_bmy[l_ac].bmy012
                                AND brb013=g_bmy[l_ac].bmy013
                                AND brb04 = (SELECT MAX(brb04) FROM brb_file
                                              WHERE brb01 = g_bmy[l_ac].bmy14
                                                AND brb03 = g_bmy[l_ac].bmy05)
                                AND (brb04 <= g_bmx.bmx07 OR brb04 IS NULL)
                                AND (brb05 >  g_bmx.bmx07 OR brb05 IS NULL)
                          END IF 
                       ELSE
                       	  IF g_argv1_str='1' THEN #FUN-AC0060(110705)  #CHI-CA0035 mod g_argv3->g_argv1
                             SELECT bmb06,bmb07,bmb16,bmb14,bmbud02 INTO l_bmb06,l_bmb07,l_bmb16,l_bmb14,l_bmbud02,l_bmbud06 FROM bmb_file     #No.MOD-8B0109 modify  #TQC-AC0171 add bmb14
                              WHERE bmb01 = g_bmy[l_ac].bmy14  #str----add by huanglf160817  #add by huanglf160927
                                AND bmb03 = g_bmy[l_ac].bmy05
                                AND bmb02 = g_bmy[l_ac].bmy04
                                AND (bmb04 <= g_bmx.bmx07 OR bmb04 IS NULL)
                                AND (bmb05 >  g_bmx.bmx07 OR bmb05 IS NULL)
                           ELSE 
                           	  SELECT brb06,brb07,brb16,bmb14 INTO l_bmb06,l_bmb07,l_bmb16,l_bmb14 FROM brb_file    #TQC-AC0171 add bmb14   
                              WHERE brb01 = g_bmy[l_ac].bmy14
                                AND brb03 = g_bmy[l_ac].bmy05
                                AND brb011=g_bmy[l_ac].bmy011
                                AND brb012=g_bmy[l_ac].bmy012
                                AND brb013=g_bmy[l_ac].bmy013
                                AND brb02=g_bmy[l_ac].bmy04
                                AND brb04 = (SELECT MAX(brb04) FROM brb_file
                                              WHERE brb01 = g_bmy[l_ac].bmy14
                                                AND brb03 = g_bmy[l_ac].bmy05)
                                AND (brb04 <= g_bmx.bmx07 OR brb04 IS NULL)
                                AND (brb05 >  g_bmx.bmx07 OR brb05 IS NULL)
                           END IF 
                       END IF
                      #IF cl_null(g_bmy[l_ac].bmy06) THEN    #TQC-BA0108
                      #IF p_cmd = 'a' THEN    #TQC-BA0108    #MOD-CB0238 mark
                       LET g_bmy[l_ac].bmy06 = l_bmb06
                      #END IF  #MOD-CB0238 mark
                      #MOD-B40254 --- modify --- start ---
                      #IF cl_null(g_bmy[l_ac].bmy07) THEN
                      #IF p_cmd = 'a' THEN  #MOD-CB0238 mark
                       LET g_bmy[l_ac].bmy07 = l_bmb07
                      #END IF               #MOD-CB0238 mark
                      #MOD-B40254 --- modify --- end ---
                       IF g_bmy[l_ac].bmy03 MATCHES '[13]' THEN  #CHI-960004
                          LET g_bmy[l_ac].bmy16 = l_bmb16   #No.MOD-8B0109 add
                       END IF   #CHI-960004
                       #TQC-AC0171 ------------add start------------
                      #IF g_bmy[l_ac].bmy03 MATCHES '[3]' THEN        #CHI-C10033 mark
                       IF g_bmy[l_ac].bmy03 MATCHES '[13]' THEN       #CHI-C10033 add
                          LET g_bmy[l_ac].bmy35 = l_bmb14
                          LET g_bmy[l_ac].ta_bmy01 = l_bmbud02 #str---add by huanglf160817
                          LET g_bmy[l_ac].ta_bmy02 = l_bmbud06 #add by huanglf160927
                          LET g_bmy[l_ac].ta_bmy03 = l_bmbud03 #add by huanglf161018
                          LET g_bmy[l_ac].ta_bmy04 = l_bmbud04 #add by huanglf161018
                       END IF
                       #TQC-AC0171 -----------add end---------------
                       DISPLAY BY NAME g_bmy[l_ac].bmy35         #MOD-B70091 add 
                      #str MOD-A40058 add
                      #當變更別為4時bmy06與bmy07不給預設值
                       IF g_bmy[l_ac].bmy03 = '4'  THEN
                          LET g_bmy[l_ac].bmy06 = '' 
                          LET g_bmy[l_ac].bmy07 = '' 
                       END IF    
                      #end MOD-A40058 add
                   ELSE
                       IF g_bmy[l_ac].bmy03 = '2'  THEN      #CHI-C10033 add
                          LET g_bmy[l_ac].bmy06 = 1
                          LET g_bmy[l_ac].bmy07 = 1
                       END IF                                #CHI-C10033 add
                       IF g_bmy[l_ac].bmy03 = '5'  THEN      #CHI-C10033 add
                          #LET g_bmy[l_ac].bmy06 = ''         #CHI-C10033 add  #MOD-D40076
                          #LET g_bmy[l_ac].bmy07 = ''         #CHI-C10033 add  #MOD-D40076
                          LET g_bmy[l_ac].bmy06 = 1  #MOD-D40076
                          LET g_bmy[l_ac].bmy07 = 1  #MOD-D40076
                       END IF                                #CHI-C10033 add
                   END IF
                   DISPLAY g_bmy[l_ac].bmy06 TO bmy06
                   DISPLAY g_bmy[l_ac].bmy07 TO bmy07
                   DISPLAY g_bmy[l_ac].bmy16 TO bmy16    #No.MOD-8B0109 add
                   DISPLAY g_bmy[l_ac].ta_bmy01 TO ta_bmy01 #str-----add by huanglf160817
                   DISPLAY g_bmy[l_ac].ta_bmy02 TO ta_bmy02 #add by huanglf160927
                   DISPLAY g_bmy[l_ac].ta_bmy03 TO ta_bmy03 #add by huanglf161018
                   DISPLAY g_bmy[l_ac].ta_bmy04 TO ta_bmy04 #add by huanglf161018
                   DISPLAY g_bmy[l_ac].ta_bmy05 TO ta_bmy05   #tianry add  170214
                END IF
 
               CALL i720_bmy27(g_bmy[l_ac].bmy05) RETURNING g_bmy[l_ac].ima02,g_bmy[l_ac].ima021
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0) NEXT FIELD bmy05
               ELSE
                  DISPLAY g_bmy[l_ac].ima02 TO ima02
               END IF
                SELECT ima107,ima147 INTO g_ima107,g_ima147 FROM ima_file #MOD-490449
                WHERE ima01=g_bmy[l_ac].bmy05 AND imaacti = 'Y'
               IF STATUS THEN
                  CALL cl_err3("sel","ima_file",g_bmy[l_ac].bmy05,"",STATUS,"","sel ima",1) # TQC-660046
                  NEXT FIELD bmy05
               END IF
 
               IF g_bmy[l_ac].bmy03 = '4' THEN
                 SELECT ima107,ima147 INTO g_ima107,g_ima147 FROM ima_file
                  WHERE ima01=g_bmy[l_ac].bmy05 AND imaacti = 'Y'   #TQC-750147 mod
                 IF STATUS THEN
                    CALL cl_err3("sel","ima_file",g_bmy[l_ac].bmy27,"",STATUS,"","sel ima",1) # TQC-660046
                 END IF
               END IF
               #--
               CALL i720_chkinsitm() RETURNING l_chkinsitm
               IF NOT l_chkinsitm THEN
                 NEXT FIELD bmy05
               END IF
               #FUN-BB0075---begin
               IF g_bmy[l_ac].bmy03 = '6' THEN 
                  IF NOT cl_null(g_bmy[l_ac].bmy14) AND NOT cl_null(g_bmy[l_ac].bmy27) THEN
                     SELECT bmd07 INTO g_bmy[l_ac].bmy06
                       FROM bmd_file
                      WHERE bmd08 = g_bmy[l_ac].bmy14
                        AND bmd01 = g_bmy[l_ac].bmy05
                        AND bmd04 = g_bmy[l_ac].bmy27
                        AND bmd02 = '2'

                     DISPLAY BY NAME g_bmy[l_ac].bmy06
                  END IF 
               END IF 
               #FUN-BB0075---end  
               #FUN-D10093 add----str----
               IF g_aza.aza121='Y' THEN
                   CALL i720_get_plm()
               END IF
               #FUN-D10093 add----end----
           END IF
 
        BEFORE FIELD bmy16
          IF g_bmy[l_ac].bmy03 MATCHES '[123]' THEN
            #MOD-AC0029---add---start---
             LET comb_value = '0,1,2,5,7,9'  #FUN-C30035 add 7,9
             CALL cl_getmsg('abm-076',g_lang) RETURNING comb_item
             CALL cl_set_combo_items('bmy16',comb_value,comb_item)
            #MOD-AC0029---add---end---
             IF cl_null(g_bmy[l_ac].bmy16) THEN
                IF g_bmy[l_ac].bmy03 = '2' THEN
                   LET g_bmy[l_ac].bmy16 = '0'
                ELSE
                   SELECT bmb16 INTO g_bmy[l_ac].bmy16 
                     FROM bmb_file
                    WHERE bmb01=g_bmy[l_ac].bmy14
                      AND bmb02=g_bmy[l_ac].bmy04
                      AND bmb29=g_bmy[l_ac].bmy29 
                      AND (bmb04 IS NULL OR bmb04<=g_bmx.bmx07)
                      AND (bmb05 IS NULL OR bmb05 >g_bmx.bmx07)
                END IF
                DISPLAY g_bmy[l_ac].bmy16 TO bmy16
             END IF
         #MOD-AC0029---add---start---
          ELSE
            #MOD-B30705---add---start---
             IF g_bmy[l_ac].bmy03 = '5' THEN
               #LET comb_value = '0,1,2,5'      #MOD-C40150 mark
                LET comb_value = '2,5'          #MOD-C40150 add
               #CALL cl_getmsg('abm-076',g_lang) RETURNING comb_item   #MOD-C40150 mark
                CALL cl_getmsg('abm-078',g_lang) RETURNING comb_item   #MOD-C40150 add
                CALL cl_set_combo_items('bmy16',comb_value,comb_item)
             ELSE
            #MOD-B30705---add---end---
              #LET comb_value = '0,1'                             #TQC-B70052     #MOD-B70207 remove # #MOD-C40150 mark
              #LET comb_value = '0,1,2,5'                         #TQC-B70052     #MOD-B70207 mark
               LET g_bmy[l_ac].bmy16 = '1'  #MOD-D10278
               DISPLAY g_bmy[l_ac].bmy16 TO bmy16 #MOD-D10278
               LET comb_value = '1'                               #MOD-C40150 add
               CALL cl_getmsg('abm-077',g_lang) RETURNING comb_item
               CALL cl_set_combo_items('bmy16',comb_value,comb_item)
             END IF           #MOD-B30705 add
         #MOD-AC0029---add---end---
          END IF
        
        AFTER FIELD bmy16
           IF NOT cl_null(g_bmy[l_ac].bmy16) THEN #CHI-A60028 add
              IF g_bmy[l_ac].bmy16 NOT MATCHES '[0124579]' THEN  #FUN-C30035 add 79
                  LET g_bmy[l_ac].bmy16 = g_bmy_t.bmy16 #CHI-A60028 add
                  DISPLAY BY NAME g_bmy[l_ac].bmy16     #CHI-A60028 add
                  NEXT FIELD bmy16
              END IF
              #CHI-A60028 add --start--
              IF NOT cl_null(g_bmy[l_ac].bmy35) THEN
                 IF g_bmy[l_ac].bmy35 = '2' THEN
                    LET g_bmy[l_ac].bmy16 = '0'
                 END IF
              END IF
              LET g_bmy_t.bmy16 = g_bmy[l_ac].bmy16
              #CHI-A60028 add --end--
           END IF #CHI-A60028 add
           #CHI-960004--begin--add--
           IF g_bmy[l_ac].bmy03 = '5' THEN
              IF g_bmy[l_ac].bmy16 NOT MATCHES '[25]' THEN 
                 CALL cl_err('','abm-037',1)
                 NEXT FIELD bmy16
              END IF
           END IF

        #CHI-A60028 add --start--
           AFTER FIELD bmy35
              IF NOT cl_null(g_bmy[l_ac].bmy35) THEN
                 IF g_bmy[l_ac].bmy35 NOT MATCHES'[0123]' THEN
                     LET g_bmy[l_ac].bmy35 = g_bmy_t.bmy35
                     DISPLAY BY NAME g_bmy[l_ac].bmy35
                     NEXT FIELD bmy35
                 END IF
                 IF g_bmy[l_ac].bmy35 = '2' THEN
                    LET g_bmy[l_ac].bmy16 = '0'
                 END IF
                 IF cl_null(g_bmy[l_ac].bmy06) OR g_bmy[l_ac].bmy06=0 THEN
                    IF g_bmy[l_ac].bmy35 = '2' THEN
                       LET g_bmy[l_ac].bmy06 = -1
                    ELSE
                       LET g_bmy[l_ac].bmy06 = 1
                    END IF
                 #  IF g_bmy[l_ac].bmy35 MATCHES'[45]' THEN    #CHI-C10033 add   #TQC-C60180 mark
                    IF g_bmy[l_ac].bmy03 MATCHES'[45]' THEN    #TQC-C60180  
                       LET g_bmy[l_ac].bmy06 =''               #CHI-C10033 add
                    END IF                                     #CHI-C10033 add
                 ELSE
                   IF g_bmy[l_ac].bmy35 = '2' AND g_bmy[l_ac].bmy06 > 0 THEN
                      LET g_bmy[l_ac].bmy06=g_bmy[l_ac].bmy06 * (-1)
                   END IF
                   IF g_bmy[l_ac].bmy35 <> '2' AND g_bmy[l_ac].bmy06 < 0 THEN
                      LET g_bmy[l_ac].bmy06=g_bmy[l_ac].bmy06 * (-1)
                   END IF
                 END IF
              END IF
        #CHI-A60028 add --end--

        AFTER FIELD bmy27
           IF NOT cl_null(g_bmy[l_ac].bmy27) THEN
              #FUN-AA0059 -------------------------------add start--------------------------
               IF NOT s_chk_item_no(g_bmy[l_ac].bmy27,'') THEN
                  CALL cl_err('',g_errno,1)
                  NEXT FIELD bmy27
               END IF 
              #FUN-AA0059 -------------------------------add end--------------------------- 
               CALL i720_bmy27(g_bmy[l_ac].bmy27) RETURNING g_bmy[l_ac].ima02n,g_bmy[l_ac].ima021n
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD bmy27
               END IF
               DISPLAY BY NAME g_bmy[l_ac].ima02n
               DISPLAY BY NAME g_bmy[l_ac].ima021n
 
               IF g_bmy[l_ac].bmy03 != '1' THEN
                  SELECT COUNT(*) INTO g_cnt
                    FROM ima_file
                   WHERE ima01=g_bmy[l_ac].bmy27
                     AND (ima140='N'
                     OR (ima140='Y' AND ima1401 > g_bmx.bmx07))  #FUN-6A0036
                  IF g_cnt=0        THEN
                     CALL cl_err('','aim-809',0)
                     NEXT FIELD bmy27
                  END IF
                 IF g_bmy[l_ac].bmy05 = g_bmy[l_ac].bmy14 THEN 
                    #CALL cl_err('sel bmb','mfg2633',0) NEXT FIELD bmy27
                    CALL cl_err('','mfg2633',0) NEXT FIELD bmy27   #No.FUN-A60083
                 END IF
               END IF
 
               IF g_bmy[l_ac].bmy03 = '5' THEN
                 #MOD-C20195---add---str---
                  IF g_bmy[l_ac].bmy05 = g_bmy[l_ac].bmy27 THEN
                     CALL cl_err('bmy05=bmy27','mfg2626',0)
                     NEXT FIELD bmy05
                  END IF
                 #MOD-C20195---add---end---
                  #檢查替代料是否一存在于bmd_file
                  LET l_cnt = 0
                  SELECT COUNT(*) INTO l_cnt FROM bmd_file
                   WHERE bmd08 = g_bmy[l_ac].bmy14
                     AND bmd01 = g_bmy[l_ac].bmy05
                     AND bmd04 = g_bmy[l_ac].bmy27
                     AND bmd02 = '2'
                  IF l_cnt > 0 THEN
                     CALL cl_err('','abm-034',1)
                     NEXT FIELD bmy27
                  END IF
               END IF
               #CHI-C20060---begin
               IF g_bmy[l_ac].bmy03 = '6' THEN
                  LET l_cnt = 0
                  SELECT COUNT(*) INTO l_cnt FROM bmd_file
                   WHERE bmd08 = g_bmy[l_ac].bmy14
                     AND bmd01 = g_bmy[l_ac].bmy05
                     AND bmd04 = g_bmy[l_ac].bmy27
                     AND bmd02 = '2'
                  IF l_cnt = 0 THEN 
                     CALL cl_err('','abm-127',1)
                     NEXT FIELD bmy27
                  END IF 
               END IF 
               #CHI-C20060---end
               #CHI-A80054 add --start--
               #合理性的檢查,元件A不應同時有相同的替代料及取代料皆為B的狀況
               LET l_cnt = 0
               CASE g_bmy[l_ac].bmy03 
                  WHEN '4'
                     SELECT COUNT(*) INTO l_cnt FROM bmd_file
                      WHERE bmd01 = g_bmy[l_ac].bmy05 
                        AND bmd08 = g_bmy[l_ac].bmy14 
                        AND bmd04 = g_bmy[l_ac].bmy27
                        AND bmd02 = '2'
                        AND bmdacti = 'Y' 
                  WHEN '5'
                     SELECT COUNT(*) INTO l_cnt FROM bmd_file
                      WHERE bmd01 = g_bmy[l_ac].bmy05 
                        AND bmd08 = g_bmy[l_ac].bmy14 
                        AND bmd04 = g_bmy[l_ac].bmy27
                        AND bmd02 = '1'
                        AND bmdacti = 'Y' 
               END CASE 
               IF l_cnt > 0 THEN
                  CALL cl_err_msg("","abm-205",g_bmy[l_ac].bmy05 CLIPPED|| "|" || g_bmy[l_ac].bmy27 CLIPPED,10)
                  NEXT FIELD bmy27
               END IF 
               #CHI-A80054 add --end--
               #FUN-BB0075---begin
               IF g_bmy[l_ac].bmy03 = '6' THEN 
                  IF NOT cl_null(g_bmy[l_ac].bmy05) AND NOT cl_null(g_bmy[l_ac].bmy14) THEN
                     SELECT bmd07 INTO g_bmy[l_ac].bmy06
                       FROM bmd_file
                      WHERE bmd08 = g_bmy[l_ac].bmy14
                        AND bmd01 = g_bmy[l_ac].bmy05
                        AND bmd04 = g_bmy[l_ac].bmy27
                        AND bmd02 = '2'

                     DISPLAY BY NAME g_bmy[l_ac].bmy06
                  END IF 
               END IF 
               #FUN-BB0075---end  
           END IF
           IF g_bmy[l_ac].bmy03 = '4' THEN
               IF cl_null(g_bmy[l_ac].bmy27) THEN
                   #此欄位不可空白, 請輸入資料!
                   CALL cl_err('','aap-099',0)
                   NEXT FIELD bmy27
               END IF
               LET l_cnt = 0
               SELECT count(*) INTO l_cnt FROM bmb_file
                WHERE bmb01 = g_bmy[l_ac].bmy14
                  AND bmb03 = g_bmy[l_ac].bmy27
                  AND (bmb04 <= g_bmx.bmx07 OR bmb04 IS NULL)
                  AND (bmb05 >  g_bmx.bmx07 OR bmb05 IS NULL)
               IF l_cnt > 0 THEN
                  IF NOT cl_confirm('abm-728') THEN
                     NEXT FIELD bmy05
                  END IF
               END IF
               IF g_bmy[l_ac].bmy05 = g_bmy[l_ac].bmy27 THEN                                                                        
                  CALL cl_err('','abm-619',0)                                                                                       
                  NEXT FIELD bmy27                                                                                                  
               END IF                                                                                                               
            END IF

        #FUN-BB0075---begin
        AFTER FIELD bmy36
            CALL i720_set_no_entry_b(p_cmd)
        #FUN-BB0075---end
 
        BEFORE DELETE                            #是否取消單身
            IF g_bmy_t.bmy02 > 0 AND g_bmy_t.bmy02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM bmy_file
                    WHERE bmy01 = g_bmx.bmx01
                      AND bmy02 = g_bmy_t.bmy02
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","bmy_file",g_bmx.bmx01,g_bmy_t.bmy02,SQLCA.sqlcode,"","del bmy",1) # TQC-660046
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                DELETE FROM bmw_file
                    WHERE bmw01 = g_bmx.bmx01
                      AND bmw02 = g_bmy_t.bmy02
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","bmw_file",g_bmx.bmx01,g_bmy_t.bmy02,SQLCA.sqlcode,"","del bmw",1) # TQC-660046
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
	            	COMMIT WORK
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                LET l_bmx09 = '0'          #FUN-550040
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_bmy[l_ac].* = g_bmy_t.*
               CLOSE i720_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CALL i720_b_move_back()
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_bmy[l_ac].bmy02,-263,1)
                LET g_bmy[l_ac].* = g_bmy_t.*
            ELSE
                UPDATE bmy_file SET * = b_bmy.*
                   WHERE bmy01=g_bmx.bmx01 AND bmy02=g_bmy_t.bmy02
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","bmy_file",g_bmx.bmx01,g_bmy_t.bmy02,SQLCA.sqlcode,"","del bmy",1) # TQC-660046
                   LET g_bmy[l_ac].* = g_bmy_t.*
                   DISPLAY g_bmy[l_ac].* TO s_bmy[l_sl].*
                ELSE
                   MESSAGE 'UPDATE O.K'
                   IF g_bmy[l_ac].bmy03 MATCHES '[23456]' AND   #MOD-910205 add if #CHI-960004 add 5 #CHI-C20060
                      g_bmy[l_ac].bmy06 <> g_bmy_t.bmy06 THEN
                      LET g_flag = g_ima107   #MOD-910205 add
                      CALL i720_t()
                   END IF
	             	   COMMIT WORK
                   LET l_bmx09 = '0'          #FUN-550040
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D40030
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_bmy[l_ac].* = g_bmy_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_bmy.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i720_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D40030
            CLOSE i720_bcl
            COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(bmy02) AND l_ac > 1 THEN
                LET g_bmy[l_ac].* = g_bmy[l_ac-1].*
                LET g_bmy[l_ac].bmy02 = NULL
                DISPLAY g_bmy[l_ac].* TO s_bmy[l_sl].*
                NEXT FIELD bmy02
            END IF
 
        ON ACTION gen_detail
        #產生單身
           CALL i720_g()
           IF g_rec_b = 0 THEN
              ROLLBACK WORK
              NEXT FIELD bmy02
           ELSE
              COMMIT WORK
              LET l_ac_t = l_ac
              EXIT INPUT
           END IF
 
        ON ACTION CONTROLP
           CASE
                WHEN INFIELD(bmy05)
                     IF g_bmy[l_ac].bmy03 MATCHES '[13456]' AND NOT cl_null(g_bmy[l_ac].bmy14) THEN #CHI-960004 add 5 #CHI-C20060
                         CALL cl_init_qry_var()
                         IF g_argv1_str='1' THEN #FUN-AC0060(110705)  #CHI-CA0035 mod g_argv3->g_argv1
                            LET g_qryparam.form = "q_bmb6"
                            LET g_qryparam.default1 = g_bmy[l_ac].bmy05
                            LET g_qryparam.arg1     = g_bmx.bmx07
                            LET g_qryparam.arg2     = g_bmy[l_ac].bmy14
                            LET g_qryparam.arg3     = g_bmy[l_ac].bmy29               #CHI-B40031 add
                         ELSE 
                            LET g_qryparam.form = "q_brb_2"
                            LET g_qryparam.default1 = g_bmy[l_ac].bmy05
                            LET g_qryparam.arg1     = g_bmy[l_ac].bmy14
                            LET g_qryparam.arg2     = g_bmy[l_ac].bmy011
                            LET g_qryparam.arg3     = g_bmy[l_ac].bmy012
                            LET g_qryparam.arg4     = g_bmy[l_ac].bmy013
                         END IF 
                         CALL cl_create_qry() RETURNING g_bmy[l_ac].bmy05,g_bmy[l_ac].bmy04   #MOD-CB0068 add bmy04
                     ELSE
#FUN-AA0059 --Begin--
                     #    CALL cl_init_qry_var()
                     #    LET g_qryparam.form = "q_ima"
                     #    LET g_qryparam.default1 = g_bmy[l_ac].bmy05
                     #    CALL cl_create_qry() RETURNING g_bmy[l_ac].bmy05
                         CALL q_sel_ima(FALSE, "q_ima", "", g_bmy[l_ac].bmy05, "", "", "", "" ,"",'' )  RETURNING g_bmy[l_ac].bmy05 
#FUN-AA0059 --End--
                     END IF
                     DISPLAY g_bmy[l_ac].bmy05 TO bmy05
                     NEXT FIELD bmy05
                WHEN INFIELD(bmy27)
#FUN-AA0059 --Begin--
                   #   CALL cl_init_qry_var()
                   #   LET g_qryparam.form = "q_ima"
                   #   LET g_qryparam.default1 = g_bmy[l_ac].bmy27
                   #   CALL cl_create_qry() RETURNING g_bmy[l_ac].bmy27
                      CALL q_sel_ima(FALSE, "q_ima", "", g_bmy[l_ac].bmy27, "", "", "", "" ,"",'' )  RETURNING g_bmy[l_ac].bmy27
#FUN-AA0059 --End--
                      DISPLAY g_bmy[l_ac].bmy27 TO bmy27
                      NEXT FIELD bmy27
                WHEN INFIELD(bmy14)
                      CALL cl_init_qry_var()
                      IF g_argv1_str='1' THEN #FUN-AC0060(110705)  #CHI-CA0035 mod g_argv3->g_argv1
                         #LET g_qryparam.form = "q_bmb5"
                         LET g_qryparam.form = "q_bmb_1"
                         LET g_qryparam.default1 = g_bmy[l_ac].bmy14
                         LET g_qryparam.arg1 = g_bmx.bmx07 #  MOD-840436
                      ELSE 
                      	 LET g_qryparam.form = "q_brb_1"
                         LET g_qryparam.default1 = g_bmy[l_ac].bmy14
                         LET g_qryparam.arg1 = g_bmx.bmx07 #  MOD-840436
                      END IF 
                      #str MOD-A30171 mark
                      #IF NOT cl_null(g_bmx.bmx05) THEN
                      #   SELECT bmr07 INTO l_bmr07 FROM bmr_file
                      #                            WHERE bmr01=g_bmx.bmx05 
                      #                              AND bmrconf='Y'  #FUN-950045
                      #   LET g_qryparam.where=" bmb01='",l_bmr07,"' AND ima01='",l_bmr07,"'"
                      #END IF
                      #end MOD-A30171 mark
                      CALL cl_create_qry() RETURNING g_bmy[l_ac].bmy14
                      NEXT FIELD bmy14
                 #No.FUN-A60008--begin
                 WHEN INFIELD(bmy011)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_bra1"
                 LET g_qryparam.arg1=g_bmy[l_ac].bmy14
                 LET g_qryparam.default1 = g_bmy[l_ac].bmy011
                 CALL cl_create_qry() RETURNING g_bmy[l_ac].bmy011
                 DISPLAY BY NAME g_bmy[l_ac].bmy011    
                 NEXT FIELD bmy011
                 WHEN INFIELD(bmy012)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_bra2"
                 LET g_qryparam.arg1=g_bmy[l_ac].bmy14
                 LET g_qryparam.arg2=g_bmy[l_ac].bmy011
                 LET g_qryparam.default1 = g_bmy[l_ac].bmy012
                 CALL cl_create_qry() RETURNING g_bmy[l_ac].bmy012
                 IF cl_null(g_bmy[l_ac].bmy012) THEN 
                    LET g_bmy[l_ac].bmy012=' '
                 END IF 
                 DISPLAY BY NAME g_bmy[l_ac].bmy012       
                 NEXT FIELD bmy012
                 WHEN INFIELD(bmy013)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_bra3"
                 LET g_qryparam.arg1=g_bmy[l_ac].bmy14
                 LET g_qryparam.arg2=g_bmy[l_ac].bmy011
                 LET g_qryparam.arg3=g_bmy[l_ac].bmy012
                 LET g_qryparam.default1 = g_bmy[l_ac].bmy013
                 CALL cl_create_qry() RETURNING g_bmy[l_ac].bmy013
                 DISPLAY BY NAME g_bmy[l_ac].bmy013       
                 NEXT FIELD bmy013                  
                 #No.FUN-A60008--end
                 #CHI-B40031 --- modify --- start ---
                 WHEN INFIELD(bmy29)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_bmz05"
                     LET g_qryparam.default1 = g_bmy[l_ac].bmy29
                     LET g_qryparam.arg1 = g_bmy[l_ac].bmy14
                     CALL cl_create_qry() RETURNING g_bmy[l_ac].bmy29
                     NEXT FIELD bmy29
                 #CHI-B40031 --- modify ---  end  ---
           END CASE
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
 
        ON ACTION mntn_item_detail
           CALL i720_b_more(p_cmd) #No:7826
 
        ON ACTION mntn_insert_loc
           LET g_flag = 'Y'   #MOD-910205 add
           CALL i720_t()

        #CHI-A70013 add --start--
        ON ACTION mntn_desc
           CALL i720_e()
        #CHI-A70013 add --end--
 
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
      UPDATE bmx_file SET bmxmodu = g_user,bmxdate = g_today,bmx09 = l_bmx09
       WHERE bmx01 = g_bmx01
      LET g_bmx.bmx09 = l_bmx09
      DISPLAY BY NAME g_bmx.bmx09
      CALL i720_field_pic()
 
    CLOSE i720_bcl
    COMMIT WORK

    #TQC-D40025----add---str
    IF g_action_choice = 'detail' THEN 
       RETURN
    END IF
    #TQC-D40025----add---end
 
    SELECT COUNT(*) INTO g_cnt FROM bmy_file WHERE bmy01=g_bmx.bmx01
    IF g_cnt>0 THEN
       CALL i720_out()       #列印報表
    ELSE
#      CALL i720_delall()    #單身無資料,單據刪除 #CHI-C30002 mark
       CALL i720_delHeader()  #CHI-C30002 add
    END IF
END FUNCTION

#CHI-C30002 ------ add ------ begin
FUNCTION i720_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_bmx.bmx01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM bmx_file ",
                  "  WHERE bmx01 LIKE '",l_slip,"%' ",
                  "    AND bmx01 > '",g_bmx.bmx01,"'"
      PREPARE i720_pb1 FROM l_sql 
      EXECUTE i720_pb1 INTO l_cnt      
      
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() AND l_cnt = 0 THEN
         CALL cl_getmsg('aec-130',g_lang) RETURNING g_msg
         LET l_num = 3
      ELSE
         CALL cl_getmsg('aec-131',g_lang) RETURNING g_msg
         LET l_num = 2
      END IF 
      LET g_action_choice = l_action_choice
      PROMPT g_msg CLIPPED,': ' FOR l_cho
         ON IDLE g_idle_seconds
            CALL cl_on_idle()

         ON ACTION about     
            CALL cl_about()

         ON ACTION help         
            CALL cl_show_help()

         ON ACTION controlg   
            CALL cl_cmdask() 
      END PROMPT
      IF l_cho > l_num THEN LET l_cho = 1 END IF 
      IF l_cho = 2 THEN 
        #CALL i720_x()  #CHI-D20010
         CALL i720_x(1)  #CHI-D20010
         CALL i720_field_pic()
      END IF 
      
      IF l_cho = 3 THEN 
         DELETE FROM bmg_file WHERE bmg01 = g_bmx.bmx01 
         DELETE FROM bmw_file WHERE bmw01 = g_bmx.bmx01     
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM bmx_file WHERE bmx01=g_bmx.bmx01
         CLEAR FORM
         CALL g_bmy.clear()
         CALL g_bmw.clear()
         CALL g_ima.clear()
         INITIALIZE g_bmx.* TO NULL
      END IF
   END IF
         
END FUNCTION
#CHI-C30002 ------ add ------ end
 
FUNCTION i720_chk_bmb()
   DEFINE l_errno     LIKE type_file.chr10
   DEFINE l_cnt       LIKE type_file.num5
 
   LET l_errno = NULL
   LET l_cnt = 0
   IF cl_null(g_bmy[l_ac].bmy04) THEN RETURN l_errno END IF
   IF cl_null(g_bmy[l_ac].bmy14) THEN RETURN l_errno END IF
   IF cl_null(g_bmy[l_ac].bmy29) THEN LET g_bmy[l_ac].bmy29 = ' ' END IF
  #chk項次是否存在正式BOM中
   SELECT count(*) INTO l_cnt FROM bmb_file
    WHERE bmb01 = g_bmy[l_ac].bmy14
      AND bmb02 = g_bmy[l_ac].bmy04
      AND bmb29 = g_bmy[l_ac].bmy29
      AND (bmb04 <= g_bmx.bmx07 OR bmb04 IS NULL)
      AND (bmb05 >  g_bmx.bmx07 OR bmb05 IS NULL)
   IF l_cnt > 0 THEN 
      LET l_errno = 'mfg-015'
      RETURN l_errno
   END IF
  #chk項次是否存其它ECN變更單中 
   SELECT COUNT(*) INTO l_cnt FROM bmy_file,bmx_file 
    WHERE bmy03 = '2'
      AND bmy04 = g_bmy[l_ac].bmy04
      AND bmy14 = g_bmy[l_ac].bmy14
      AND ((bmy01 != g_bmx.bmx01) OR
           (bmy01 = g_bmx.bmx01 AND bmy02 != g_bmy[l_ac].bmy02))
      AND bmy01 = bmx01
      AND bmx04 != 'Y'
      AND bmxacti = 'Y'
   IF l_cnt > 0 THEN 
      LET l_errno = 'abm-386'
      RETURN l_errno
   END IF
   RETURN l_errno
END FUNCTION
FUNCTION i720_bmy03(p_chr)
   DEFINE p_chr	LIKE type_file.chr1    #No.FUN-680096 VARCHAR(1)
   DEFINE l_buf	LIKE type_file.chr4    #No.FUN-680096 VARCHAR(4)
 
   CASE p_chr
        WHEN '1' LET l_buf=g_x[01]
        WHEN '2' LET l_buf=g_x[02]
        WHEN '3' LET l_buf=g_x[03]
        WHEN '4' LET l_buf=g_x[04]
   END CASE
   RETURN l_buf
 
END FUNCTION
 
FUNCTION i720_bmy14()
   DEFINE l_bmy05  LIKE bmy_file.bmy05
   DEFINE l_bmy06  LIKE bmy_file.bmy06
   DEFINE l_bmy07  LIKE bmy_file.bmy07
   DEFINE l_bmy16  LIKE bmy_file.bmy16
   DEFINE l_bmy30  LIKE bmy_file.bmy30 #FUN-550014
   SELECT bmb03,bmb06,bmb07,bmb16,bmb30 INTO l_bmy05,l_bmy06,l_bmy07,l_bmy16,l_bmy30 #FUN-550014 add bmy30
     FROM bmb_file
    WHERE bmb01=g_bmy[l_ac].bmy14
      AND bmb02=g_bmy[l_ac].bmy04
      AND bmb29=g_bmy[l_ac].bmy29  #FUN-550014 add bmy29
      AND (bmb04 IS NULL OR bmb04<=g_bmx.bmx07)
      AND (bmb05 IS NULL OR bmb05 >g_bmx.bmx07)
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg9047'
                                  LET l_bmy05 = NULL  LET l_bmy06 = NULL
                                  LET l_bmy07 = NULL
                                  LET l_bmy16 = NULL
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_bmy[l_ac].bmy05) THEN
      LET g_bmy[l_ac].bmy05 = l_bmy05
      DISPLAY g_bmy[l_ac].bmy05 TO s_bmy[l_ac].bmy05
   END IF
   IF cl_null(g_bmy[l_ac].bmy06) THEN
      IF g_bmy[l_ac].bmy03 != '4' THEN   #MOD-A40058 add
         LET g_bmy[l_ac].bmy06 = l_bmy06
         DISPLAY g_bmy[l_ac].bmy06 TO s_bmy[l_ac].bmy06
      END IF   #MOD-A40058 add  
   END IF
   IF cl_null(g_bmy[l_ac].bmy07) THEN
      IF g_bmy[l_ac].bmy03 != '4' THEN   #MOD-A40058 add 
         LET g_bmy[l_ac].bmy07 = l_bmy07
         DISPLAY g_bmy[l_ac].bmy07 TO s_bmy[l_ac].bmy07
      END IF   #MOD-A40058 add  
   END IF
  IF g_bmy[l_ac].bmy03 MATCHES '[13]' THEN  #CHI-960004
     IF cl_null(g_bmy[l_ac].bmy16) THEN
        LET g_bmy[l_ac].bmy16 = l_bmy16
        DISPLAY g_bmy[l_ac].bmy16 TO s_bmy[l_ac].bmy16
     END IF
  END IF  #CHI-960004
   LET g_bmy[l_ac].bmy30 = l_bmy30
 
END FUNCTION
 
#CHI-C30002 ------- mark ------- begin 
#FUNCTION i720_delall()
#  CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#  ERROR g_msg CLIPPED
#  DELETE FROM bmx_file WHERE bmx01=g_bmx.bmx01
#  IF SQLCA.SQLCODE THEN
#     CALL cl_err3("del","bmx_file",g_bmx.bmx01,"",SQLCA.sqlcode,"","del bmx: ",1) # TQC-660046
#  ELSE
#     CLEAR FORM
#     CALL g_bmy.clear()
#     CALL g_bmw.clear()
#     CALL g_ima.clear()
#  END IF
#END FUNCTION
#CHI-C30002 ------- mark ------- end
 
FUNCTION i720_b_move_to()
   LET g_bmy[l_ac].bmy02 = b_bmy.bmy02
   LET g_bmy[l_ac].bmy03 = b_bmy.bmy03
   LET g_bmy[l_ac].bmy04 = b_bmy.bmy04
   LET g_bmy[l_ac].bmy14 = b_bmy.bmy14
   LET g_bmy[l_ac].bmy17 = b_bmy.bmy17
   LET g_bmy[l_ac].bmy05 = b_bmy.bmy05
   LET g_bmy[l_ac].bmy06 = b_bmy.bmy06
   LET g_bmy[l_ac].bmy07 = b_bmy.bmy07
   LET g_bmy[l_ac].bmy16 = b_bmy.bmy16
   LET g_bmy[l_ac].bmy35 = b_bmy.bmy35 #CHI-A60028 add
   LET g_bmy[l_ac].bmy19 = b_bmy.bmy19
   LET g_bmy[l_ac].bmy27 = b_bmy.bmy27
   LET g_bmy[l_ac].bmy171 = b_bmy.bmy171
   #No.FUN-A60031--begin
   LET g_bmy[l_ac].bmy011 = b_bmy.bmy011
   LET g_bmy[l_ac].bmy012 = b_bmy.bmy012
   LET g_bmy[l_ac].bmy013 = b_bmy.bmy013
   #No.FUN-A60031--end 
   LET g_bmy[l_ac].bmy36 = b_bmy.bmy36  #FUN-BB0075
   LET g_bmy[l_ac].ta_bmy01 =b_bmy.ta_bmy01 #add by guanyao160912
   LET g_bmy[l_ac].ta_bmy02 =b_bmy.ta_bmy02 #add by huanglf160927
   LET g_bmy[l_ac].ta_bmy03 =b_bmy.ta_bmy03 #add by huanglf161018
   LET g_bmy[l_ac].ta_bmy04 =b_bmy.ta_bmy04 #add by huanglf161018
   LET g_bmy[l_ac].ta_bmy05 =b_bmy.ta_bmy05   #tianry add 170214
  

END FUNCTION
FUNCTION i720_b_move_back()
   LET b_bmy.bmy02 = g_bmy[l_ac].bmy02
   LET b_bmy.bmy03 = g_bmy[l_ac].bmy03
   LET b_bmy.bmy04 = g_bmy[l_ac].bmy04
   LET b_bmy.bmy14 = g_bmy[l_ac].bmy14
   LET b_bmy.bmy17 = g_bmy[l_ac].bmy17
   LET b_bmy.bmy05 = g_bmy[l_ac].bmy05
   LET b_bmy.bmy06 = g_bmy[l_ac].bmy06
   LET b_bmy.bmy07 = g_bmy[l_ac].bmy07
   LET b_bmy.bmy16 = g_bmy[l_ac].bmy16
   LET b_bmy.bmy35 = g_bmy[l_ac].bmy35 #CHI-A60028 add
   LET b_bmy.bmy19 = g_bmy[l_ac].bmy19
   LET b_bmy.bmy27 = g_bmy[l_ac].bmy27
   LET b_bmy.bmy171 = g_bmy[l_ac].bmy171
   LET b_bmy.bmy22 = g_bmy[l_ac].bmy22  #No:CHI-960045 add
   LET b_bmy.bmy361 = g_bmy[l_ac].bmy361  #No:FUN-D10093 add
   LET b_bmy.bmy37 = g_bmy[l_ac].bmy37    #No:FUN-D10093 add
   #No.FUN-A60031--begin
   LET b_bmy.bmy011 = g_bmy[l_ac].bmy011
   LET b_bmy.bmy012 = g_bmy[l_ac].bmy012
   LET b_bmy.bmy013 = g_bmy[l_ac].bmy013
   #No.FUN-A60031--end 
   LET b_bmy.bmy36 = g_bmy[l_ac].bmy36  #FUN-BB0075
   IF b_bmy.bmy03 MATCHES '[2345]' THEN  #CHI-960004 add 5
       CALL i720_b_more('u')
   END IF
   LET b_bmy.bmy29 = g_bmy[l_ac].bmy29                       #FUN-550014 add
   LET b_bmy.bmy30 = g_bmy[l_ac].bmy30                       #FUN-550014 add
   IF cl_null(b_bmy.bmy29) THEN LET b_bmy.bmy29 = ' ' END IF #FUN-550014 add
   IF cl_null(b_bmy.bmy30) THEN LET b_bmy.bmy30 = ' ' END IF #FUN-550014 add
   LET b_bmy.bmy34 = g_bmy[l_ac].bmy34  #no.MOD-840426
   LET b_bmy.ta_bmy01 = g_bmy[l_ac].ta_bmy01 #add by guanyao160912
   LET b_bmy.ta_bmy02 = g_bmy[l_ac].ta_bmy02 #add by huanglf160927
   LET b_bmy.ta_bmy03 = g_bmy[l_ac].ta_bmy03 #add by huanglf161018
   LET b_bmy.ta_bmy04 = g_bmy[l_ac].ta_bmy04 #add by huanglf161018
   
   LET  b_bmy.ta_bmy05=g_bmy[l_ac].ta_bmy05  #tianry add 170214
END FUNCTION
 
FUNCTION i720_b_more(p_cmd)
   DEFINE p_cmd	    LIKE type_file.chr1       #No.FUN-680096 VARCHAR(1)
   DEFINE l_ima25   LIKE ima_file.ima25
   DEFINE l_ima86   LIKE ima_file.ima86
   DEFINE l_ima110  LIKE ima_file.ima110  #No.9806
   DEFINE b_bmy_t   RECORD LIKE bmy_file.*
   DEFINE b_bmy_o   RECORD LIKE bmy_file.*     #MOD-A80227 add
   DEFINE l_item    LIKE ima_file.ima01
   DEFINE l_m       LIKE type_file.num5      #No.FUN-850017
   DEFINE l_bmy13   LIKE ze_file.ze03       #NO.FUN-850017
   DEFINE l_ima04       LIKE ima_file.ima04
   DEFINE l_ima70       LIKE ima_file.ima70
   DEFINE l_ima562      LIKE ima_file.ima562
   DEFINE l_ima136      LIKE ima_file.ima136
   DEFINE l_ima137      LIKE ima_file.ima137
   DEFINE l_bmb         RECORD LIKE bmb_file.* #No.CHI-920021
   DEFINE l_ima910      LIKE ima_file.ima910   #No.CHI-920021
   #DEFINE l_ima70       LIKE ima_file.ima70   #tianry add 170214   


   IF g_bmy[l_ac].bmy03 = '1' THEN
      CALL cl_err('','abm-014',1)
      RETURN
   END IF
 
   OPEN WINDOW i720_b_more_w WITH FORM "abm/42f/abmi710b"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("abmi710b")
   IF g_argv1_str='2' THEN #FUN-AC0060(110705)  #CHI-CA0035 mod g_argv3->g_argv1
      CALL cl_set_comp_visible('bmy09',FALSE)
   END IF 
   LET b_bmy_t.*=b_bmy.*
   LET b_bmy_o.*=b_bmy.*             #MOD-A80227 add
    IF s_industry('slk') THEN                                                                                                       
        SELECT  ze03  INTO l_bmy13 FROM ze_file WHERE ze01 = 'abmi600' AND ze02 = g_lang                                                    
        CALL cl_set_comp_att_text("bmy13",l_bmy13)                                                                                  
    END IF      
   IF g_bmy[l_ac].bmy03 = '4' THEN   #tianry add ima70 
      SELECT ima25,ima86,ima110,ima70 INTO l_ima25,l_ima86,l_ima110,l_ima70 FROM ima_file
       WHERE ima01=g_bmy[l_ac].bmy27
   ELSE
      SELECT ima25,ima86,ima110,ima70 INTO l_ima25,l_ima86,l_ima110,l_ima70 FROM ima_file
       WHERE ima01=g_bmy[l_ac].bmy05
   END IF
   DISPLAY l_ima25 TO FORMONLY.ima25 #No:7826
   CALL i720_up_bmy13() #No:7958
    
#tianry add 消耗性料件默认赋值为料件属性
    LET b_bmy.bmy21=l_ima70
    IF p_cmd='u' OR p_cmd='a'  THEN  #MOD-4A0044
       IF cl_null(b_bmy.bmy21) THEN         #MOD-C20154 add
          LET b_bmy.bmy21 = 'N'             #MOD-C20154 add
       END IF                               #MOD-C20154 add
       IF g_bmy[l_ac].bmy03 = '4' THEN
          LET l_item = g_bmy[l_ac].bmy27
       ELSE
          LET l_item = g_bmy[l_ac].bmy05
       END IF
      #IF g_bmy[l_ac].bmy03 MATCHES '[2345]' AND cl_null(b_bmy.bmy10) THEN  #CHI-960004 add 5      #MOD-A80105 mark
       IF (g_bmy[l_ac].bmy03 = '2' AND (g_bmy[l_ac].bmy05 != g_bmy_t.bmy05 OR g_bmy_t.bmy05 IS NULL)) OR             #MOD-A80105 add
          (g_bmy[l_ac].bmy03 MATCHES '[345]' AND (g_bmy[l_ac].bmy27 != g_bmy_t.bmy27 OR g_bmy_t.bmy27 IS NULL)) THEN  #MOD-A80105 add
         #No.CHI-920021 -BEGIN-----
          IF NOT cl_null(g_bmy[l_ac].bmy04) THEN
             SELECT * INTO l_bmb.* FROM bmb_file
              WHERE bmb01 = g_bmy[l_ac].bmy14
                AND bmb02 = g_bmy[l_ac].bmy04
          ELSE
             SELECT * INTO l_bmb.* FROM bmb_file
              WHERE bmb01 = g_bmy[l_ac].bmy14
                AND bmb03 = g_bmy[l_ac].bmy05
                AND bmb29 = g_bmy[l_ac].bmy29
                AND (bmb05 > g_bmx.bmx07 OR bmb05 IS NULL)
           END IF
           IF NOT cl_null(l_bmb.bmb18) THEN
              LET b_bmy.bmy18=l_bmb.bmb18
              LET b_bmy_t.bmy18=l_bmb.bmb18
           ELSE
              LET b_bmy.bmy18=0
              LET b_bmy_t.bmy18=0
           END IF
           IF NOT cl_null(l_bmb.bmb08) THEN
              LET b_bmy.bmy08=l_bmb.bmb08
              LET b_bmy_t.bmy08=l_bmb.bmb08
              LET b_bmy_o.bmy08 = l_bmb.bmb08   #MOD-B90142 add
           ELSE
              LET b_bmy.bmy08=0
              LET b_bmy_t.bmy08=0
              LET b_bmy_o.bmy08 = 0             #MOD-B90142 add
           END IF
           #Add No:TQC-AC0300
           #MOD-D10278---begin    
           IF NOT cl_null(l_bmb.bmb15) THEN
              LET b_bmy.bmy21 = l_ima70   #l_bmb.bmb15
              LET b_bmy_t.bmy21 = l_ima70   #l_bmb.bmb15
              LET b_bmy_o.bmy21 = l_ima70   #l_bmb.bmb15
           ELSE
              LET b_bmy.bmy21 = l_ima70   #'N' #tianry add 
              LET b_bmy_t.bmy21 = l_ima70   #'N'
              LET b_bmy_o.bmy21 = l_ima70   #'N'
           END IF 
           IF NOT cl_null(l_bmb.bmb28) THEN
              LET b_bmy.bmy23 = l_bmb.bmb28
              LET b_bmy_t.bmy23 = l_bmb.bmb28
              LET b_bmy_o.bmy23 = l_bmb.bmb28
           ELSE
              LET b_bmy.bmy23 = 0
              LET b_bmy_t.bmy23 = 0
              LET b_bmy_o.bmy23 = 0
           END IF 
           #MOD-D10278---end
           IF NOT cl_null(l_bmb.bmb081) THEN
              LET b_bmy.bmy081=l_bmb.bmb081
              LET b_bmy_t.bmy081=l_bmb.bmb081
           ELSE
              LET b_bmy.bmy081=0
              LET b_bmy_t.bmy081=0
           END IF
           IF NOT cl_null(l_bmb.bmb082) THEN
              LET b_bmy.bmy082=l_bmb.bmb082
              LET b_bmy_t.bmy082=l_bmb.bmb082
           ELSE
              LET b_bmy.bmy082=1
              LET b_bmy_t.bmy082=1
           END IF
           #End Add No:TQC-AC0300
           IF NOT cl_null(l_bmb.bmb09) THEN
              LET b_bmy.bmy09=l_bmb.bmb09
              LET b_bmy_t.bmy09=l_bmb.bmb09
           ELSE
              LET b_bmy.bmy09=''
              LET b_bmy_t.bmy09=''
           END IF
          #LET b_bmy.bmy18=0
          #LET b_bmy_t.bmy18=0
          #LET b_bmy.bmy08=0
          #LET b_bmy_t.bmy08=0
          #LET b_bmy.bmy09=''
          #LET b_bmy_t.bmy09=''
          #No.CHI-920021 -END-------
            LET b_bmy.bmy21=  l_ima70  #'N'  #MOD-530305  4
            LET b_bmy_t.bmy21=l_ima70   #'N'   #MOD-530305  4
           SELECT ima63,ima63_fac,ima25,ima86                     #MOD-C20093 add ima86
             INTO b_bmy.bmy10,b_bmy.bmy10_fac,l_ima25,l_ima86     #MOD-C20093 add l_ima86
             FROM ima_file WHERE ima01=l_item
           CALL s_umfchk(l_item,b_bmy.bmy10,l_ima25)
                 RETURNING g_sw_chr1,b_bmy.bmy10_fac  #發料/庫存單位  #FUN-AC0060 g_sw 改成g_sw_chr1
           IF g_sw_chr1 THEN LET b_bmy.bmy10_fac = 1 END IF           #FUN-AC0060 g_sw 改成g_sw_chr1

          #MOD-C20093 str add-----
           CALL s_umfchk(l_item,b_bmy.bmy10,l_ima86)
                RETURNING g_sw_chr1,b_bmy.bmy10_fac2  #發料/成本單位
           IF g_sw_chr1 THEN LET b_bmy.bmy10_fac2 = 1 END IF
          #MOD-C20093 end add-----

           IF cl_null(b_bmy.bmy10_fac) THEN LET b_bmy.bmy10_fac = 1 END IF
           LET b_bmy_t.bmy10     = b_bmy.bmy10
           LET b_bmy_t.bmy10_fac = b_bmy.bmy10_fac
#MOD-B90142 -- begin --
           LET b_bmy_o.bmy10     = b_bmy.bmy10
           LET b_bmy_o.bmy10_fac = b_bmy.bmy10_fac
#MOD-B90142 -- end --
           IF cl_null(l_ima110) THEN LET l_ima110 = '1' END IF   # No.MOD-710092 add
           IF g_bmy[l_ac].bmy03 <> '3' THEN       #MOD-C50226 ADD
              LET b_bmy.bmy20 = l_ima110  #No.9806 
           ELSE                                  #MOD-C50226 ADD
              LET b_bmy.bmy20 = l_bmb.bmb19      #MOD-C50226 ADD
           END IF                                #MOD-C50226 ADD
           LET b_bmy_t.bmy20     = b_bmy.bmy20
           LET b_bmy_o.bmy20 = b_bmy.bmy20      #MOD-B90142 add
           DISPLAY BY NAME b_bmy.bmy10_fac
       END IF
      DISPLAY BY NAME b_bmy.bmy10_fac
       IF b_bmy.bmy03 MATCHES '[245]' THEN        #CHI-960004 add 5
          SELECT ima04,ima136,ima137,ima70,ima562
            INTO l_ima04,l_ima136,l_ima137,l_ima70,l_ima562
            FROM ima_file WHERE ima01=l_item
          LET b_bmy.bmy11 = l_ima04 
          LET b_bmy.bmy25 = l_ima136    
          LET b_bmy.bmy26 = l_ima137  
          LET b_bmy.bmy21 = l_ima70    
         #LET b_bmy.bmy08 = l_ima562   #MOD-A70152 mark
          IF cl_null(b_bmy.bmy23) THEN LET b_bmy.bmy23=0 END IF 
             LET b_bmy.bmy23 = 0     
          END IF       
 
     DISPLAY BY NAME
           b_bmy.bmy25, b_bmy.bmy26, b_bmy.bmy13, b_bmy.bmy18,
	   b_bmy.bmy08, b_bmy.bmy081,b_bmy.bmy082,b_bmy.bmy11, b_bmy.bmy20, #No.9806 add bmy20  #Mod No:TQC-AC0300 add bmy081,bmy082
           b_bmy.bmy22, b_bmy.bmy09, b_bmy.bmy10,
	   b_bmy.bmy10_fac,b_bmy.bmy21,b_bmy.bmy23
           #b_bmy.bmy34   #no.MOD-840426  #CHI-C80063
        CALL cl_set_head_visible("","YES")   #No.FUN-6B0033
        INPUT BY NAME
           b_bmy.bmy25, b_bmy.bmy26, b_bmy.bmy13, b_bmy.bmy18,
          #Mod No:TQC-AC0300
	  #b_bmy.bmy08, b_bmy.bmy11, b_bmy.bmy20, #No.9806 add bmy20
          #b_bmy.bmy22, b_bmy.bmy09, b_bmy.bmy10,
	  #b_bmy.bmy10_fac,b_bmy.bmy21,b_bmy.bmy23
	   b_bmy.bmy08, b_bmy.bmy081,b_bmy.bmy082,
           b_bmy.bmy09, b_bmy.bmy10,
	   b_bmy.bmy10_fac,b_bmy.bmy21,b_bmy.bmy23,
           b_bmy.bmy11, b_bmy.bmy20, b_bmy.bmy22
          #End Mod No:TQC-AC0300
	   WITHOUT DEFAULTS
 
        AFTER FIELD bmy08    #損耗率
            IF b_bmy.bmy08 < 0 OR b_bmy.bmy08 > 100
             THEN CALL cl_err(b_bmy.bmy08,'mfg4063',0)
                  LET b_bmy.bmy08 = b_bmy_t.bmy08
                  DISPLAY BY NAME b_bmy.bmy08
                  NEXT FIELD bmy08
            END IF
        #Add No:TQC-AC0300
        AFTER FIELD bmy081   #固定損耗量
           IF NOT i720_bmy081_check(b_bmy_t.bmy081) THEN NEXT FIELD bmy081 END IF   #No.FUN-BB0086
            #No.FUN-BB0086--mark--start--
            #IF b_bmy.bmy081 < 0 THEN
            #   CALL cl_err(b_bmy.bmy081,'aec-020',0)
            #   LET b_bmy.bmy081 = b_bmy_t.bmy081
            #   DISPLAY BY NAME b_bmy.bmy081
            #   NEXT FIELD bmy081
            #END IF
            #No.FUN-BB0086--mark--end--

        AFTER FIELD bmy082   #损耗批量
            IF b_bmy.bmy082 <= 0 THEN
               CALL cl_err(b_bmy.bmy082,'alm-808',0)
               LET b_bmy.bmy082 = b_bmy_t.bmy082
               DISPLAY BY NAME b_bmy.bmy082
               NEXT FIELD bmy082
            END IF
        #End Add No:TQC-AC0300
        AFTER FIELD bmy25   #倉庫
            IF NOT cl_null(b_bmy.bmy25) THEN
               SELECT * FROM imd_file
                WHERE imd01=b_bmy.bmy25
                  AND imdacti='Y'
               IF SQLCA.SQLCODE THEN
                  CALL cl_err3("sel","imd_file",b_bmy.bmy25,"","mfg1100","","",1) # TQC-660046
                  NEXT FIELD bmy25
               END IF
               #No.FUN-AB0058  --Begin
               IF NOT s_chk_ware(b_bmy.bmy25) THEN 
                  NEXT FIELD bmy25
               END IF
               #No.FUN-AB0058  --End
             END IF
	IF NOT s_imechk(b_bmy.bmy25,b_bmy.bmy26) THEN NEXT FIELD bmy26 END IF  #FUN-D40103 add
 
        AFTER FIELD bmy26   #發料儲位
	#FUN-D40103--mark--str--
        #    IF NOT cl_null(b_bmy.bmy26) THEN
        #       SELECT * FROM ime_file
        #        WHERE ime01=b_bmy.bmy25
        #          AND ime02=b_bmy.bmy26
        #       IF SQLCA.SQLCODE THEN
        #           CALL cl_err3("sel","imd_file",b_bmy.bmy25,b_bmy.bmy26,"mfg1100","","",1) # TQC-660046
        #           NEXT FIELD bmy26
        #       END IF
        #    END IF
	#FUN-D40103--mark--end--
 	IF cl_null(b_bmy.bmy26) THEN LET b_bmy.bmy26 = ' ' END IF              #FUN-D40103 add
            IF NOT s_imechk(b_bmy.bmy25,b_bmy.bmy26) THEN NEXT FIELD bmy26 END IF  #FUN-D40103 add

        AFTER FIELD bmy09   #作業編號
            IF NOT cl_null(b_bmy.bmy09) THEN
               SELECT * FROM ecd_file
                WHERE ecd01=b_bmy.bmy09
               IF SQLCA.SQLCODE THEN
                  CALL cl_err3("sel","ecd_file",b_bmy.bmy09,"","100","","",1) # TQC-660046
                  NEXT FIELD bmy09
               END IF
            END IF

        #No.FUN-BB0086--add--start---    
        BEFORE FIELD bmy10
           IF p_cmd = 'u' THEN 
              LET b_bmy10_t = b_bmy.bmy10
           END IF 
        #No.FUN-BB0086--add--end---
        
        AFTER FIELD bmy10   #發料單位
             IF cl_null(b_bmy.bmy10) THEN
                  LET b_bmy.bmy10 = b_bmy_t.bmy10
                  DISPLAY BY NAME b_bmy.bmy10
             ELSE
                  SELECT * FROM gfe_file
                   WHERE gfe01=b_bmy.bmy10
                  IF STATUS THEN
                     CALL cl_err3("sel","gfe_file",b_bmy.bmy10,"",STATUS,"","sel gfe",1) # TQC-660046
                     LET b_bmy.bmy10 = b_bmy_t.bmy10
                     DISPLAY BY NAME b_bmy.bmy10
                     NEXT FIELD bmy10
                  END IF
                     IF g_bmy[l_ac].bmy03 = '4' THEN
                        LET l_item = g_bmy[l_ac].bmy27
                     ELSE
                        LET l_item = g_bmy[l_ac].bmy05
                     END IF
                     SELECT ima25,ima86 INTO l_ima25,l_ima86
                       FROM ima_file
                      WHERE ima01=l_item #No:7826
                     DISPLAY l_ima25 TO FORMONLY.ima25 #No:7826
                     IF b_bmy.bmy10 != b_bmy_t.bmy10 THEN  #No:7826
                        IF b_bmy.bmy10 != l_ima25 THEN
                           CALL s_umfchk(l_item,b_bmy.bmy10,l_ima25)
                             RETURNING g_sw_chr1,b_bmy.bmy10_fac  #發料/庫存單位 #FUN-AC0060 g_sw 改成g_sw_chr1
                             IF g_sw_chr1 THEN                                   #FUN-AC0060 g_sw 改成g_sw_chr1
                               CALL cl_err(b_bmy.bmy10,'mfg2721',0)
                               LET b_bmy.bmy10 = b_bmy_t.bmy10
                               DISPLAY BY NAME b_bmy.bmy10
                               NEXT FIELD bmy10
                            END IF
                        ELSE
                            LET b_bmy.bmy10_fac  = 1
                        END  IF
                     END IF
                     DISPLAY BY NAME b_bmy.bmy10_fac
                     IF b_bmy.bmy10 != l_ima86  #發料/成本單位
                        THEN
                        CALL s_umfchk(l_item,b_bmy.bmy10,l_ima86)
                          RETURNING g_sw_chr1,b_bmy.bmy10_fac2  #FUN-AC0060 g_sw 改成g_sw_chr1
                          IF g_sw_chr1 THEN                     #FUN-AC0060 g_sw 改成g_sw_chr1
                            CALL cl_err(g_bmy[l_ac].bmy05,'mfg2722',0)
                            LET b_bmy.bmy10 = b_bmy_t.bmy10
                            DISPLAY BY NAME b_bmy.bmy10
                            NEXT FIELD bmy10
                          END IF
                     ELSE
                        LET b_bmy.bmy10_fac2 = 1
                     END IF
                    #No.FUN-BB0086--add--start---
                    IF NOT cl_null(b_bmy.bmy081) AND b_bmy.bmy081 <> 0 THEN   #No.FUN-C20048 add 
                       IF NOT i720_bmy081_check(b_bmy_t.bmy081) THEN 
                          LET b_bmy_t.bmy10 = b_bmy.bmy10
                          LET b_bmy10_t = b_bmy.bmy10
                          NEXT FIELD bmy081 
                       END IF 
                    END IF   #No.FUN-C20048 add
                    LET b_bmy10_t = b_bmy.bmy10
                    #No.FUN-BB0086--add--end---
                END IF
          LET b_bmy_t.bmy10 = b_bmy.bmy10
 
          AFTER FIELD bmy13                                                                                                         
           IF s_industry('slk') THEN                                                                                                
            IF  NOT cl_null(b_bmy.bmy13) THEN                                                                                 
               SELECT COUNT(*) INTO l_m FROM bol_file WHERE bol01= b_bmy.bmy13 AND bolacti = 'Y'                                                    
                IF l_m <=0 THEN                                                                                                     
                   CALL cl_err('','abm-643',0)                                                                                      
                   NEXT FIELD bmy13                                                                                                 
                END IF                                                                                                              
             END IF                                                                                                                 
           END IF                                                                                                                   
        AFTER FIELD bmy20
            IF b_bmy.bmy20 NOT MATCHES '[1234]' THEN
                  NEXT FIELD bmy20
            END IF
 
 
        ON ACTION CONTROLP
          CASE
            WHEN INFIELD(bmy25) #倉庫
#No.FUN-AB0058  --Begin
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = "q_imd"
#                 LET g_qryparam.default1 = b_bmy.bmy25
#                  LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
#                 CALL cl_create_qry() RETURNING b_bmy.bmy25
                 CALL q_imd_1(FALSE,TRUE,b_bmy.bmy25,"","","","") RETURNING b_bmy.bmy25
#No.FUN-AB0058  --End
                 DISPLAY BY NAME b_bmy.bmy25
                 NEXT FIELD bmy25
            WHEN INFIELD(bmy26) #發料儲位
#No.FUN-AB0058  --Begin
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = "q_ime"
#                 LET g_qryparam.default1 = b_bmy.bmy26
#                  LET g_qryparam.arg1     = b_bmy.bmy25 #倉庫編號 #MOD-4A0063
#                  LET g_qryparam.arg2     = 'SW'        #倉庫類別 #MOD-4A0063
#                 CALL cl_create_qry() RETURNING b_bmy.bmy26
                 CALL q_ime_1(FALSE,TRUE,b_bmy.bmy26,b_bmy.bmy25,"","","","","") RETURNING b_bmy.bmy26
#No.FUN-AB0058  --End
                 DISPLAY BY NAME b_bmy.bmy26
                 NEXT FIELD bmy26
            WHEN INFIELD(bmy09) #作業編號
                 CALL cl_init_qry_var()

                 CALL q_ecd( FALSE, TRUE,b_bmy.bmy09) RETURNING b_bmy.bmy09
                 DISPLAY BY NAME b_bmy.bmy09
            WHEN INFIELD(bmy10) #單位檔
                 CALL cl_init_qry_var()           #MOD-830180 add
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.default1 = b_bmy.bmy10
                 CALL cl_create_qry() RETURNING b_bmy.bmy10
                 DISPLAY BY NAME b_bmy.bmy10
                 NEXT FIELD bmy10
            WHEN INFIELD(bmy13) #單位檔                                                                                          
                 CALL cl_init_qry_var()                                                                                            
                 LET g_qryparam.form = "q_bmb13"                                                                                   
                 LET g_qryparam.default1 = b_bmy.bmy13                                                                       
                 CALL cl_create_qry() RETURNING b_bmy.bmy13                                                                  
                 DISPLAY b_bmy.bmy13 TO bmy13                                                                                
                 NEXT FIELD bmy13                                                                                                  
            OTHERWISE EXIT CASE
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
    ELSE
      DISPLAY BY NAME
           b_bmy.bmy25, b_bmy.bmy26, b_bmy.bmy13, b_bmy.bmy18,
	   b_bmy.bmy08, b_bmy.bmy081,b_bmy.bmy082,b_bmy.bmy11, b_bmy.bmy22, b_bmy.bmy09, b_bmy.bmy10,  #Mod No:TQC-AC0300 add bmy081,bmy082
	   b_bmy.bmy10_fac,b_bmy.bmy21,b_bmy.bmy23
       #b_bmy.bmy34  #no.MOD-840426  #CHI-C80063
            LET INT_FLAG = 0  ######add for prompt bug
      PROMPT '>' FOR CHAR g_chr
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
      END PROMPT
   END IF
   IF INT_FLAG THEN 
     #LET b_bmy.*=b_bmy_t.*      #MOD-A80227 mark 
      LET b_bmy.*=b_bmy_o.*      #MOD-A80227 add 
      LET INT_FLAG=0 
    # END IF #MOD-860126 mark
   ELSE
      IF p_cmd = 'u' THEN 
         BEGIN WORK
         UPDATE bmy_file SET * = b_bmy.*
          WHERE bmy01=g_bmx.bmx01
            AND bmy02=g_bmy_t.bmy02
         IF SQLCA.sqlcode THEN
            CALL cl_err('upd bmy',SQLCA.sqlcode,0)
            LET b_bmy.*=b_bmy_t.*
            ROLLBACK WORK
         ELSE
            COMMIT WORK
            MESSAGE 'UPDATE O.K'
         END IF
      END IF
   END IF
   CLOSE WINDOW i720_b_more_w
   LET g_bmy[l_ac].bmy22 = b_bmy.bmy22
   DISPLAY g_bmy[l_ac].bmy22 TO s_bmy[l_sl].bmy22
END FUNCTION
 
FUNCTION i720_b_askkey()
DEFINE l_wc2  LIKE type_file.chr1000   #No.FUN-680096 VARCHAR(200)
    CONSTRUCT l_wc2 ON bmy02,bmy03,bmy19,bmy04,bmy14,bmy011,bmy012,bmy013,bmy171,bmy17,bmy29,bmy05,bmy27, #FUN-550014 add bmy29  #CHI-710048 bmy27在bmy05後 #No.FUN-A60031 add bmy011,bmy012,bmy013 
                       bmy16,bmy35,bmy30,bmy06,bmy07,bmy34,bmy36,bmy361,bmy37,bmy22  #FUN-550014 add bmy30  #no.MOD-840426 #CHI-A60028 add bmy35 #FUN-BB0075  #FUN-D10093 add bmy361,bmy37
         FROM s_bmy[1].bmy02,s_bmy[1].bmy03,s_bmy[1].bmy19,
              s_bmy[1].bmy04,s_bmy[1].bmy14,s_bmy[1].bmy011,s_bmy[1].bmy012,s_bmy[1].bmy013,  #No.FUN-A60031 add bmy011,bmy012,bmy013 
              s_bmy[1].bmy171,s_bmy[1].bmy17,s_bmy[1].bmy29, #FUN-550014 add bmy29
              s_bmy[1].bmy05,s_bmy[1].bmy27,s_bmy[1].bmy16,s_bmy[1].bmy35,s_bmy[1].bmy30,s_bmy[1].bmy06,     #FUN-550014 add bmy30 #CHI-A60028 add bmy35
              s_bmy[1].bmy07,s_bmy[1].bmy34,s_bmy[1].bmy36,s_bmy[1].bmy361,s_bmy[1].bmy37,s_bmy[1].bmy22   #no.MOD-840426 #FUN-BB0075  #FUN-D10093 add bmy361,bmy37
 
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
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i720_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i720_b_fill(p_wc3)              #BODY FILL UP
DEFINE p_wc3    LIKE type_file.chr1000   #No.FUN-680096 VARCHAR(200)
 
    LET g_sql =
        "SELECT bmy02,bmy03,bmy19,bmy04,bmy14,'','',bmy011,bmy012,bmy013,bmy171,bmy17,bmy29,", #FUN-550014 add bmy29  #No.FUN-A60031 add bmy011,bmy012,bmy013
        "bmy05,ima02,ima021,bmy27,'','',bmy16,bmy35,bmy30,bmy06,bmy07,ta_bmy01,ta_bmy02,ta_bmy03,ta_bmy04,ta_bmy05,bmy34,bmy36,bmy361,bmy37,bmy22 ", #FUN-550014 add bmy30  #no.MOD-840426 add bmy34 #CHI-A60028 add bmy35 #FUN-BB0075 #FUN-D10093 add bmy361,bmy37   #add ta_bmy01 by chenkun160815
        " FROM bmy_file, OUTER ima_file ",             
        " WHERE bmy01 ='",g_bmx.bmx01,"'",  #單頭 #add by huanglf160927 ta_bmy03,ta_bmy04#add by huanglf161018
        "   AND bmy_file.bmy05 = ima_file.ima01 AND ",p_wc3 CLIPPED,
        " ORDER BY bmy02"
 
 
    PREPARE i720_pb FROM g_sql
    DECLARE bmy_curs CURSOR FOR i720_pb
 
    CALL g_bmy.clear()
    LET g_cnt = 1
    FOREACH bmy_curs INTO g_bmy[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        
        LET l_ac = g_cnt   #No.FUN-880021
        
        CALL i720_bmy27(g_bmy[g_cnt].bmy14) RETURNING g_bmy[g_cnt].ima02d, g_bmy[g_cnt].ima021d
        IF NOT cl_null(g_bmy[g_cnt].bmy27) THEN
           CALL i720_bmy27(g_bmy[g_cnt].bmy27) RETURNING g_bmy[g_cnt].ima02n, g_bmy[g_cnt].ima021n
        END IF
        LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_bmy.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
 
FUNCTION i720_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1      #No.FUN-680096 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bmy TO s_bmy.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
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
         CALL i720_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL i720_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL i720_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL i720_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL i720_fetch('L')
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
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
         CALL i720_field_pic()
 
      ON ACTION carry                                                                                                               
         LET g_action_choice = "carry"                                                                                              
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
      ON ACTION download                                                                                                            
         LET g_action_choice = "download"                                                                                           
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
      ON ACTION qry_carry_history                                                                                                   
         LET g_action_choice = "qry_carry_history"                                                                                  
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
      ON ACTION ecnre_list                                                                                                          
         LET g_bp_flag = 'list'                                                                                                     
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
 
      ON ACTION mntn_insert_loc
         LET g_action_choice ="mntn_insert_loc"
         EXIT DISPLAY
      
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
    #@ON ACTION 備註
      ON ACTION memo
         LET g_action_choice="memo"
         EXIT DISPLAY
    #@ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
    #CHI-D20010---begin
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
    #CHI-D20010---end
    #@ON ACTION easyflow送簽
      ON ACTION easyflow_approval         #FUN-550040
         LET g_action_choice = "easyflow_approval"
         EXIT DISPLAY
 
    #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
    #@ON ACTION 簽核狀況
      ON ACTION approval_status          #FUN-550040
         LET g_action_choice="approval_status"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION agree
         LET g_action_choice = 'agree'
         EXIT DISPLAY
 
      ON ACTION deny
         LET g_action_choice = 'deny'
         EXIT DISPLAY
 
      ON ACTION modify_flow
         LET g_action_choice = 'modify_flow'
         EXIT DISPLAY
 
      ON ACTION withdraw
         LET g_action_choice = 'withdraw'
         EXIT DISPLAY
 
      ON ACTION org_withdraw
         LET g_action_choice = 'org_withdraw'
         EXIT DISPLAY
 
      ON ACTION phrase
         LET g_action_choice = 'phrase'
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION related_document                #No.FUN-6A0002  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY    

      #CHI-C80063---begin
      ON ACTION qry_item_detail
         LET g_action_choice="qry_item_detail"          
         EXIT DISPLAY 
      #CHI-C80063---end 
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i720_bp1(p_ud)                                                                                                             
   DEFINE   p_ud   LIKE type_file.chr1                                                                                              
                                                                                                                                    
   IF p_ud <> "G" OR g_action_choice = "detail" THEN                                                                                
      RETURN                                                                                                                        
   END IF                                                                                                                           
                                                                                                                                    
   LET g_action_choice = " "                                                                                                        
                                                                                                                                    
   DISPLAY ARRAY g_bmy TO s_bmy.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)                                                               
      BEFORE DISPLAY                                                                                                                
         EXIT DISPLAY                                                                                                               
   END DISPLAY                                                                                                                      
                                                                                                                                    
   CALL cl_set_act_visible("accept,cancel", FALSE)                                                                                  
                                                                                                                                    
   DISPLAY ARRAY g_bmx_l TO s_bmx_l.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
                                                                                                                                    
      BEFORE DISPLAY                                                                                                                
         CALL cl_navigator_setting( g_curs_index, g_row_count )                                                                     
                                                                                                                                    
      BEFORE ROW                                                                                                                    
         LET l_ac1 = ARR_CURR()                                                                                                     
         CALL cl_show_fld_cont()                                                                                                    
                                                                                                                                    
      ON ACTION main
         LET g_bp_flag = 'main'
         LET l_ac1 = ARR_CURR()
         LET g_jump = l_ac1
         LET g_no_ask = TRUE
         IF g_rec_b1 >0 THEN
             CALL i720_fetch('/')
         END IF
         CALL cl_set_comp_visible("page69", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page69", TRUE)
         EXIT DISPLAY
      ON ACTION CONTROLS                                                                                                            
         CALL cl_set_head_visible("","AUTO")                                                                                        
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
      ON ACTION invalid                                                                                                             
         LET g_action_choice="invalid"                                                                                              
         EXIT DISPLAY                                                                                                               
      ON ACTION first                                                                                                               
         CALL i720_fetch('F')                                                                                                       
         CALL cl_navigator_setting(g_curs_index, g_row_count)                                                                       
         IF g_rec_b1 != 0 THEN                                                                                                      
            CALL fgl_set_arr_curr(1)                                                                                                
         END IF                                                                                                                     
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
      ON ACTION previous                                                                                                            
         CALL i720_fetch('P')                                                                                                       
         CALL cl_navigator_setting(g_curs_index, g_row_count)                                                                       
         IF g_rec_b1 != 0 THEN                                                                                                      
            CALL fgl_set_arr_curr(1)                                                                                                
         END IF                                                                                                                     
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
      ON ACTION jump                                                                                                                
         CALL i720_fetch('/')                                                                                                       
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN                                                                                                      
            CALL fgl_set_arr_curr(1)                                                                                                
         END IF                                                                                                                     
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
      ON ACTION next                                                                                                                
         CALL i720_fetch('N')                                                                                                       
         CALL cl_navigator_setting(g_curs_index, g_row_count)                                                                       
         IF g_rec_b1 != 0 THEN                                                                                                      
            CALL fgl_set_arr_curr(1)                                                                                                
         END IF                                                                                                                     
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
      ON ACTION last                                                                                                                
         CALL i720_fetch('L')                                                                                                       
         CALL cl_navigator_setting(g_curs_index, g_row_count)                                                                       
         IF g_rec_b1 != 0 THEN                                                                                                      
            CALL fgl_set_arr_curr(1)                                                                                                
         END IF                                                                                                                     
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
         CALL cl_show_fld_cont()
                                                                                                                                    
      ON ACTION exit                                                                                                                
         LET g_action_choice="exit"                                                                                                 
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
      ON ACTION controlg                                                                                                            
         LET g_action_choice="controlg"                                                                                             
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
      ON ACTION accept                                                                                                              
         LET l_ac1 = ARR_CURR()                                                                                                     
         LET g_jump = l_ac1                                                                                                         
         LET g_no_ask = TRUE                                                                                                       
         LET g_bp_flag = NULL                                                                                                       
         CALL i720_fetch('/')                                                                                                       
         CALL cl_set_comp_visible("page3", FALSE)                                                                                   
         CALL cl_set_comp_visible("info", FALSE)                                                                                    
         CALL ui.interface.refresh()                                                                                                
         CALL cl_set_comp_visible("page3", TRUE)                                                                                    
         CALL cl_set_comp_visible("info", TRUE)                                                                                     
         EXIT DISPLAY
                                                                                                                                    
      ON ACTION cancel                                                                                                              
         LET INT_FLAG=FALSE                                                                                                         
         LET g_action_choice="exit"                                                                                                 
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
      ON IDLE g_idle_seconds                                                                                                        
         CALL cl_on_idle()                                                                                                          
         CONTINUE DISPLAY                                                                                                           
                                                                                                                                    
      ON ACTION about                                                                                                               
         CALL cl_about()   
         
      ON ACTION mntn_insert_loc
         LET g_action_choice ="mntn_insert_loc"
         EXIT DISPLAY
                                                                                                                                    
      ON ACTION carry                                                                                                               
         LET g_action_choice = "carry"                                                                                              
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
      ON ACTION download                                                                                                            
         LET g_action_choice = "download"                                                                                           
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
      ON ACTION qry_carry_history
         LET g_action_choice = "qry_carry_history"                                                                                  
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
    #@ON ACTION 備注                                                                                                                
      ON ACTION memo                                                                                                                
         LET g_action_choice="memo"                                                                                                 
         EXIT DISPLAY                                                                                                               
    #@ON ACTION 作廢                                                                                                                
      ON ACTION void                                                                                                                
         LET g_action_choice="void"                                                                                                 
         EXIT DISPLAY                                                                                                               
    #CHI-D20010---begin
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
    #CHI-D20010---end
    #@ON ACTION easyflow送簽                                                                                                        
      ON ACTION easyflow_approval         #FUN-550040                                                                               
         LET g_action_choice = "easyflow_approval"
         EXIT DISPLAY                                                                                                               
    #@ON ACTION 確認                                                                                                                
      ON ACTION confirm                                                                                                             
         LET g_action_choice="confirm"                                                                                              
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
    #@ON ACTION 簽核狀況                                                                                                            
      ON ACTION approval_status                                                                                                     
         LET g_action_choice="approval_status"                                                                                      
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
      ON ACTION agree                                                                                                               
         LET g_action_choice = 'agree'                                                                                              
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
      ON ACTION deny                                                                                                                
         LET g_action_choice = 'deny'                                                                                               
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
      ON ACTION modify_flow                                                                                                         
         LET g_action_choice = 'modify_flow'                                                                                        
         EXIT DISPLAY
                                                                                                                                    
      ON ACTION withdraw                                                                                                            
         LET g_action_choice = 'withdraw'                                                                                           
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
      ON ACTION org_withdraw                                                                                                        
         LET g_action_choice = 'org_withdraw'                                                                                       
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
      ON ACTION phrase                                                                                                              
         LET g_action_choice = 'phrase'                                                                                             
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
      ON ACTION related_document                                                                                                    
        LET g_action_choice="related_document"                                                                                      
        EXIT DISPLAY                                                                                                                
                                                                                                                                    
      ON ACTION exporttoexcel                                                                                                       
         LET g_action_choice = 'exporttoexcel'                                                                                      
         EXIT DISPLAY

      #CHI-C80063---begin
      ON ACTION qry_item_detail
         LET g_action_choice="qry_item_detail"          
         EXIT DISPLAY 
      #CHI-C80063---end 
         
      AFTER DISPLAY                                                                                                                 
         CONTINUE DISPLAY                                                                                                           
                                                                                                                                    
      &include "qry_string.4gl"                                                                                                     
   END DISPLAY                                                                                                                      
   CALL cl_set_act_visible("accept,cancel", TRUE)                                                                                   
END FUNCTION                                                                                                                        
 
FUNCTION i720_bmy27(p_no)
DEFINE
    p_cmd      LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(1)
    p_no       LIKE ima_file.ima01,
    l_ima02    LIKE ima_file.ima02,
    l_ima021   LIKE ima_file.ima021,
    l_imaacti  LIKE ima_file.imaacti
 
    LET g_errno = ''
    SELECT ima02,ima021,imaacti INTO l_ima02,l_ima021,l_imaacti FROM ima_file
     WHERE ima01 = p_no
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno   = 'mfg0002'
                                   LET l_ima02   = NULL
                                   LET l_ima021  = NULL
                                   LET l_imaacti = NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    RETURN l_ima02 ,l_ima021
END FUNCTION
 
FUNCTION i720_out()
   DEFINE l_no  LIKE bmx_file.bmx01	        #No.FUN-550032
   IF g_bmx.bmx01 IS NULL THEN RETURN END IF
   LET l_no=g_bmx.bmx01
 
   MENU ""
      ON ACTION transaction_doc_print
 
         LET g_msg = 'bmx01 = "',g_bmx.bmx01,'"'
        # LET g_msg = "abmr720 '",g_today,"' '",g_user,"' '",g_lang,"' ", #FUN-C30085 mark
         LET g_msg = "abmg720 '",g_today,"' '",g_user,"' '",g_lang,"' ", #FUN-C30085 add  
                     " 'Y' ' ' '1' ", 
                     " '",g_msg,"' "
                    ," '1'"        #TQC-AC0171 add
         CALL cl_cmdrun(g_msg)
 
      ON ACTION list_of_effective_wo       #MODNO.B794

          LET g_msg = 'bmx01 = "',g_bmx.bmx01,'"'     
          LET g_msg = "abmr730 '",g_today,"' '",g_user,"' '",g_lang,"' ",
                      " 'Y' ' ' '1' ", 
                      " '",g_msg,"' "
         CALL cl_cmdrun(g_msg)
 
      ON ACTION list_of_effective_po

        LET g_msg="abmr731 '",g_today,"' '",g_user,"' '",g_lang,"' ",
                  " 'Y' ' ' '1' '",l_no,"' "
        LET g_msg = 'bmx01 = "',g_bmx.bmx01,'"'
        LET g_msg = "abmr731 '",g_today,"' '",g_user,"' '",g_lang,"' ",
                    " 'Y' ' ' '1' ", 
                    " '",g_msg,"' "
         CALL cl_cmdrun(g_msg)
 
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT MENU
 
      ON ACTION exit
         EXIT MENU
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE MENU
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
       -- for Windows close event trapped
       ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
           LET g_action_choice = "exit"
           EXIT MENU
 
   END MENU
END FUNCTION
 
##FUN-AC0060---mark---str---
#FUNCTION i720_firm1()
# DEFINE l_cnt LIKE type_file.num5     #No.FUN-680096 SMALLINT
#   IF s_shut(0) THEN RETURN END IF
#   SELECT * INTO g_bmx.* FROM bmx_file WHERE bmx01 = g_bmx01
#   IF cl_null(g_bmx.bmx01) THEN CALL cl_err('',-400,0) RETURN END IF
#   IF g_bmx.bmx04='X'      THEN CALL cl_err('','9024',0) RETURN END IF
#   IF g_bmx.bmx04='Y'      THEN RETURN END IF
#   IF g_bmx.bmxmksg='Y'   THEN
#       IF g_bmx.bmx09 != '1' THEN CALL cl_err('','aws-078',1) RETURN END IF
#   END IF
#   IF g_bmx.bmxacti='N' THEN CALL cl_err('','mfg0301',1) RETURN END IF
# 
#   IF cl_null(g_bmx.bmx07) THEN
#      CALL cl_err(g_bmx.bmx07,'mfg-006',0)
#      RETURN
#   END IF
# 
#   LET l_cnt =0
#   SELECT COUNT(*) INTO l_cnt FROM bmy_file
#    WHERE bmy01=g_bmx.bmx01
# 
#   IF l_cnt=0 OR cl_null(l_cnt) THEN
#      CALL cl_err('','mfg-008',0)
#      RETURN
#   END IF
# 
#   IF NOT cl_confirm('mfg0176') THEN RETURN END IF
#   BEGIN WORK
#   LET g_success = 'Y'
# 
#   OPEN i720_cl USING g_bmx01
#   IF STATUS THEN
#      CALL cl_err("OPEN i720_cl:", STATUS, 1)
#      CLOSE i720_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
#   FETCH i720_cl INTO g_bmx.*          # 鎖住將被更改或取消的資料
#   IF STATUS THEN
#      CALL cl_err('lock bmx:',SQLCA.sqlcode,0)     # 資料被他人LOCK
#      CLOSE i720_cl ROLLBACK WORK RETURN
#   END IF
# 
# 
#     UPDATE bmx_file SET bmx04='Y',bmx09='1' WHERE bmx01=g_bmx.bmx01
# 
# 
# 
#   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#      CALL cl_err('upd bmx04:',SQLCA.SQLCODE,0)
#      LET g_success='N'
#   END IF
# 
#   CALL i720_y()
#    CALL i720_y2()  #MOD-510100
#   IF g_success = 'Y' THEN
#      LET g_bmx.bmx04='Y'
#      COMMIT WORK
#      CALL cl_flow_notify(g_bmx.bmx01,'Y')
#   ELSE
#      LET g_bmx.bmx04='N'
#      ROLLBACK WORK
#   END IF
#  SELECT bmx04,bmx09 INTO g_bmx.bmx04,g_bmx.bmx09 FROM bmx_file   #FUN-540045
#      WHERE bmx01=g_bmx.bmx01
#  DISPLAY BY NAME g_bmx.bmx04,g_bmx.bmx09  #FUN-540045
# 
#   MESSAGE ''
#END FUNCTION
# 
#FUNCTION i720_y()
#DEFINE l_str            STRING                  #FUN-640241
#DEFINE l_cnt      LIKE  type_file.num5          #CHI-6A0007 
#DEFINE l_sql      STRING                        #CHI-6A0007
#DEFINE l_chr      LIKE type_file.chr5           #No.FUN-870127  by ve007
#DEFINE l_ima86    LIKE ima_file.ima86           #No.MOD-920358 add
#DEFINE l_item     LIKE ima_file.ima01           #No.MOD-920358 add
# 
#     IF s_industry('slk') THEN 
#         CALL i720_chk_mutli() RETURNING l_chr
#         IF l_chr=0 THEN 
#           CALL cl_err('','abm-035',1)
#           LET g_success = 'N'
#           RETURN 
#         END IF 
#     END IF 
#     LET g_last_seq=NULL
#     DECLARE i720_y_c2 CURSOR FOR
#             SELECT * FROM bmy_file WHERE bmy01=g_bmx.bmx01
#     FOREACH i720_y_c2 INTO b_bmy.*
#        IF cl_null(b_bmy.bmy05) THEN CONTINUE FOREACH END IF
#        
#        #No.FUN-AB0058  --Begin
#        IF NOT cl_null(b_bmy.bmy25) THEN
#           IF NOT s_chk_ware(b_bmy.bmy25) THEN  #检查仓库是否属于当前门店
#              LET g_success='N'
#              RETURN
#           END IF
#        END IF
#        #No.FUN-AB0058  --End 
#         
#        IF b_bmy.bmy03 = '4' THEN
#           LET l_item = b_bmy.bmy27
#        ELSE
#           LET l_item = b_bmy.bmy05
#        END IF
#        
#        SELECT ima86 INTO l_ima86
#          FROM ima_file
#         WHERE ima01=l_item
# 
#        IF cl_null(b_bmy.bmy10_fac2) THEN
#           IF b_bmy.bmy10 != l_ima86  #發料/成本單位
#              THEN
#              CALL s_umfchk(l_item,b_bmy.bmy10,l_ima86)
#                RETURNING g_sw,b_bmy.bmy10_fac2
#                IF g_sw THEN
#                  CALL cl_err(b_bmy.bmy05,'mfg2722',0)
#                END IF
#           ELSE
#              LET b_bmy.bmy10_fac2 = 1
#           END IF
#        END IF
#        IF g_argv3_str='1' THEN  #No.FUN-A60008
#        UPDATE bma_file SET bmamodu=g_user,
#                            bmadate=g_today
#         WHERE bma01=b_bmy.bmy14
#           AND bma06=b_bmy.bmy29
#        #No.FUN-A60008--begin   
#        ELSE 
#        	 UPDATE bra_file SET bramodu=g_user,
#                               bradate=g_today
#            WHERE bra01=b_bmy.bmy14
#              AND bra011= b_bmy.bmy011
#              AND bra012= b_bmy.bmy012
#              AND bra013= b_bmy.bmy013
#              AND bra06=b_bmy.bmy29
#        END IF 
#        #No.FUN-A60008--end 
#        IF SQLCA.sqlcode THEN
#           CALL cl_err3("upd","bma_file",g_user,g_today,SQLCA.sqlcode,"","upd bma:",1) # TQC-660046
#           LET g_success='N'
#           RETURN
#        END IF
# 
#        LET l_str = b_bmy.bmy02,' ',b_bmy.bmy05
#        CALL cl_msg(l_str)
# 
#       IF g_action_choice CLIPPED = "confirm" THEN      #按「確認」時 #No.MOD-7B0213 add
#          IF cl_null(b_bmy.bmy04) OR b_bmy.bmy04 = ' ' THEN
#             LET l_cnt = 0
#             IF g_argv3_str='1' THEN  #No.FUN-A60008
#                SELECT COUNT(*) INTO l_cnt  FROM bmb_file
#                 WHERE bmb01 = b_bmy.bmy14  AND bmb03 = b_bmy.bmy05
#                   AND (bmb05 IS NULL OR bmb05 > g_bmx.bmx07)
#             #No.FUN-A60008--begin
#             ELSE
#               	SELECT COUNT(*) INTO l_cnt  FROM brb_file
#                 WHERE brb01 = b_bmy.bmy14  AND brb03 = b_bmy.bmy05
#                   AND brb011= b_bmy.bmy011 AND brb012= b_bmy.bmy012
#                   AND brb013= b_bmy.bmy013
#                   AND (brb05 IS NULL OR brb05 > g_bmx.bmx07)
#             END IF 	    
#             #No.FUN-A60008--end    
#             IF l_cnt > 1 THEN
#                 CALL cl_getmsg('abm-023',g_lang) RETURNING g_msg
#                 IF g_argv2 = 'abmp701' THEN
#                     LET g_msg=g_bmx.bmx01 CLIPPED,' : ',g_msg CLIPPED
#                 ELSE
#                     LET g_msg=g_msg CLIPPED
#                 END IF
#                 LET INT_FLAG = 0 
#
#             END IF 
#          END IF   #MOD-740184
#        END IF     #No.MOD-7B0213 add
# 
#        IF b_bmy.bmy03 MATCHES '[1345]' THEN #CHI-960004 add 5
#           CALL i720_s()  #No.FUN-A60008
#           #IF NOT cl_null(b_bmy.bmy04) THEN             
#           #    LET l_sql ="SELECT bmb_file.*  FROM bmb_file ",
#           #               " WHERE bmb01 ='", b_bmy.bmy14 CLIPPED, "'"
#           #    IF g_sma.sma118='Y' THEN
#           #      LET l_sql=l_sql,"   AND bmb29 ='", b_bmy.bmy29 , "'" #MOD-830242
#           #    END IF
#           #
#           #    LET l_sql=l_sql,"   AND bmb02 =",  b_bmy.bmy04,
#           #               "   AND bmb03 ='", b_bmy.bmy05 CLIPPED, "'",
#           #               "   AND (bmb05 >'", g_bmx.bmx07 CLIPPED ,"' OR bmb05 IS NULL)", #MOD-6A0109 add ,
#           #               "   AND bmb04 = (SELECT MAX(bmb04) FROM bmb_file ",
#           #                              " WHERE bmb01 = '",b_bmy.bmy14 CLIPPED,"' ",
#           #                              "   AND bmb02 = ",b_bmy.bmy04 CLIPPED,
#           #                              "   AND bmb03 = '",b_bmy.bmy05 CLIPPED,"' ",
#           #                              "   AND (bmb04 <= '",g_bmx.bmx07 CLIPPED,"' OR bmb04 IS NULL) ", 
#           #                              "   AND (bmb05 >  '",g_bmx.bmx07 CLIPPED,"' OR bmb05 IS NULL)) "
#           #
#           #ELSE
#           #
#           #    LET l_sql ="SELECT bmb_file.*  FROM bmb_file ",
#           #               " WHERE bmb01 ='", b_bmy.bmy14 CLIPPED, "'"
#           #    IF g_sma.sma118='Y' THEN
#           #       LET l_sql=l_sql,"   AND bmb29 ='", b_bmy.bmy29 , "'"  #MOD-830242
#           #    END IF
#           #
#           #    LET l_sql=l_sql,"   AND bmb03 ='", b_bmy.bmy05 CLIPPED, "'",
#           #               "   AND (bmb05 >'", g_bmx.bmx07 CLIPPED ,"' OR bmb05 IS NULL)"
#           #END IF
#           #
#           #PREPARE i720_bmb_pre FROM l_sql
#           #DECLARE i720_bmb_c2 CURSOR FOR i720_bmb_pre
#           #FOREACH i720_bmb_c2 INTO g_bmb.* 
#           #  IF STATUS THEN	# 當bmy04 is null時,可能讀出一筆以上
#           #     CALL cl_err('sel bmb:',STATUS,1) LET g_success='N' RETURN
#           #  END IF
#           #  LET g_last_seq=g_bmb.bmb02
#           #  CASE
#           #       WHEN b_bmy.bmy03='1' CALL i720_s1()	# 失效
#           #       WHEN b_bmy.bmy03='3' CALL i720_s3()	# 修改
#           #       WHEN b_bmy.bmy03='4' CALL i720_s4()	# 取代
#           #       WHEN b_bmy.bmy03='5' CALL i720_s4()	# 替代   #CHI-960004
#           #  END CASE
#           #  IF g_success='N' THEN RETURN END IF
#           #  UPDATE ima_file SET ima05 = b_bmy.bmy17 WHERE ima01=b_bmy.bmy14
#           #END FOREACH 
#        ELSE
#           CALL i720_s2()   # 新增
#           IF g_success='N' THEN RETURN END IF
#           UPDATE ima_file SET ima05 = b_bmy.bmy17 WHERE ima01=b_bmy.bmy14
#        END IF
#        
#     END FOREACH
#END FUNCTION
# 
#FUNCTION i720_y2()
#     DEFINE l_bmz RECORD LIKE bmz_file.*
#     DECLARE i720_y_c3 CURSOR FOR
#             SELECT bmy01,bmy14,bmy17,bmy171,bmy29,bmy011,bmy012 FROM bmy_file   #No.MOD-790129 add bmy29 #CHI-A60028 add (bug:bmy011,bmy012)
#              WHERE bmy01=g_bmx.bmx01
#             GROUP BY bmy01,bmy14,bmy17,bmy171,bmy29,bmy011,bmy012   #NO.FUN-840033 #CHI-A60028 add (bug:bmy011,bmy012)
#     FOREACH i720_y_c3 INTO l_bmz.bmz01,l_bmz.bmz02,l_bmz.bmz03,l_bmz.bmz04,l_bmz.bmz05,l_bmz.bmz011,l_bmz.bmz012    #No.MOD-790129 add bmz05 #CHI-A60028 add (bug:bmz011.bmz012)
#         IF STATUS THEN
#            CALL cl_err('y_c2 err',STATUS,1) LET g_success='N' RETURN
#         END IF
#         IF cl_null(l_bmz.bmz05) THEN
#            LET l_bmz.bmz05 = ' '
#         END IF
# 
#         LET l_bmz.bmzplant = g_plant 
#         LET l_bmz.bmzlegal = g_legal 
# 
#         DISPLAY l_bmz.*
##FUN-A70125 --begin--
#         IF cl_null(l_bmz.bmz012) THEN
#            LET l_bmz.bmz012 = ' ' 
#         END IF 
#         IF cl_null(l_bmz.bmz013) THEN
#            LET l_bmz.bmz013 = 0 
#         END IF 
##FUN-A70125 --end--
#         INSERT INTO bmz_file VALUES (l_bmz.*)
#         IF STATUS AND NOT cl_sql_dup_value(SQLCA.SQLCODE) THEN #TQC-790102
#         LET g_showmsg = l_bmz.bmz01,' ins bmz err:'                    
#         CALL s_errmsg('bmz01','',g_showmsg,STATUS,1)
#         LET g_success='N' RETURN
#         END IF
#     END FOREACH
#END FUNCTION
#
#FUNCTION i720_y_chk()
#DEFINE l_cnt       LIKE type_file.num5     #No.FUN-680096
#DEFINE l_str       LIKE type_file.chr4     #No.FUN-680096 VARCHAR(04)
#DEFINE l_pml04     LIKE pml_file.pml04
#DEFINE l_imaacti   LIKE ima_file.imaacti
#DEFINE l_ima140    LIKE ima_file.ima140
# 
#   LET g_success = 'Y'
#   IF s_shut(0) THEN RETURN END IF
#   SELECT bmx01 INTO g_bmx01 FROM bmx_file WHERE bmx01 = g_bmx.bmx01
#   SELECT * INTO g_bmx.* FROM bmx_file WHERE bmx01 = g_bmx01
#   IF cl_null(g_bmx.bmx01) THEN CALL cl_err('',-400,0) RETURN END IF
# 
#   IF g_bmx.bmx04='X'      THEN
#      LET g_showmsg = g_bmx.bmx01                    
#      CALL s_errmsg('bmx01','',g_showmsg,'9024',1)
#      CALL cl_err('','9024',0)
#      LET g_success = 'N'
#      RETURN
#   END IF
#   IF g_bmx.bmx04='Y'      THEN
#      LET g_showmsg = g_bmx.bmx01                    
#      CALL s_errmsg('bmx01','',g_showmsg,'9023',1)
#      LET g_success = 'N'
#      RETURN
#   END IF
#   IF g_bmx.bmxacti= 'N' THEN
#      LET g_showmsg = g_bmx.bmx01                    
#      CALL s_errmsg('bmx01','',g_showmsg,'mfg0301',1)
#       LET g_success = 'N'
#   END IF
# 
#   CALL i720_y_chk_bmy()
#   IF g_success = 'N' THEN
#       RETURN
#   END IF
#
# 
#   LET l_cnt =0
#   SELECT COUNT(*) INTO l_cnt FROM bmy_file
#    WHERE bmy01=g_bmx.bmx01
#   IF l_cnt=0 OR cl_null(l_cnt) THEN
#      LET g_showmsg = g_bmx.bmx01                    
#      CALL s_errmsg('bmx01','',g_showmsg,'mfg-008',1)
#      LET g_success = 'N'
#      RETURN
#   END IF
#
#END FUNCTION
# 
#FUNCTION i720_y_upd()
#DEFINE l_gew03    LIKE gew_file.gew03   #FUN-950057                             
#DEFINE l_i        LIKE type_file.num10  #FUN-950057                             
#DEFINE l_sql      STRING                #FUN-950057
# 
#   LET g_success = 'Y'
#    IF NOT s_dc_ud_flag('3',g_bmx.bmx11,g_plant,'u') THEN                                                                           
#      LET g_showmsg = g_bmx.bmx01                    
#      CALL s_errmsg('bmx11',g_bmx.bmx11,g_showmsg,'aoo-045',1)
#      RETURN                                                                                                                       
#    END IF                                                                                                                          
#   IF g_action_choice CLIPPED = "confirm"       #按「確認」時
#   THEN
#       IF g_bmx.bmxmksg='Y' THEN
#             IF g_bmx.bmx09 != '1' THEN
#                 LET g_showmsg = g_bmx.bmx09                    
#                 CALL s_errmsg('bmx09',g_bmx.bmx09,g_showmsg,'aws-078',1)
#                 LET g_success = 'N'
#                 RETURN
#             END IF
#       END IF
#       IF g_bmx.bmx04 = 'Y' THEN RETURN END IF
#      IF g_argv2 <> 'abmp701' THEN            #no.FUN-840033 add
#            IF NOT cl_confirm('axm-108') THEN 
#               LET g_success = "N" #MOD-680068 add
#               RETURN
#            END IF
#      END IF                                  #no.FUN-840033 add
#   END IF
# 
#   BEGIN WORK  #No.TQC-720003 add
# 
#   OPEN i720_cl USING g_bmx01
#   IF STATUS THEN
#      LET g_success = 'N'
#      LET g_showmsg = g_bmx.bmx01,' OPEN i720_cl:'                    
#      CALL s_errmsg('bmx01','',g_showmsg,STATUS,1)
#      CLOSE i720_cl
#      ROLLBACK WORK    #No.TQC-720003 add
#      RETURN
#   END IF
#   FETCH i720_cl INTO g_bmx.*               # 對DB鎖定
#   IF SQLCA.sqlcode THEN
#      LET g_success = 'N'
#      LET g_showmsg = g_bmx.bmx01,' i720_cl fetch:'                    
#      CALL s_errmsg('bmx01','',g_showmsg,SQLCA.SQLCODE,1)
#      CLOSE i720_cl
#      ROLLBACK WORK    #No.TQC-720003 add
#      RETURN
#   END IF
# 
#   UPDATE bmx_file SET bmx04='Y',bmx09='1' WHERE bmx01=g_bmx.bmx01
#   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#       LET g_showmsg = g_bmx.bmx01,' update bmx04,bmx09:'                    
#       CALL s_errmsg('bmx01','',g_showmsg,SQLCA.SQLCODE,1)
#       LET g_success='N'
#       ROLLBACK WORK  #No.TQC-720003 add
#       RETURN         #No.TQC-720003 add
#   END IF
# 
#    CALL i720_y()      #No.TQC-720003 add
#    CALL i720_y2()     #No.TQC-720003 add
#   IF g_success = 'Y' THEN
#      IF g_bmx.bmxmksg = 'Y' THEN
#         CASE aws_efapp_formapproval()
#              WHEN 0  #呼叫 EasyFlow 簽核失敗
#                   LET g_bmx.bmx04="N"
#                    LET g_success = "N"
#                   ROLLBACK WORK    #No.TQC-720003 add
#                   RETURN
#              WHEN 2  #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
#                   LET g_bmx.bmx04="N"
#                   ROLLBACK WORK    #No.TQC-720003 add
#                   RETURN
#         END CASE
#      END IF
#      IF g_success='Y' THEN
#         LET g_bmx.bmx09='1'
#         LET g_bmx.bmx04='Y'
#         COMMIT WORK    #No.TQC-720003 add
#         CALL cl_flow_notify(g_bmx.bmx01,'Y')
#         LET g_showmsg = g_bmx.bmx01                    
#         CALL s_errmsg('bmx01','',g_showmsg,'abm-983',0)
#         DISPLAY BY NAME g_bmx.bmx09
#         DISPLAY BY NAME g_bmx.bmx04
#      ELSE
#         LET g_bmx.bmx04='N'
#         LET g_success = 'N'
#         LET g_showmsg = g_bmx.bmx01                    
#         CALL s_errmsg('bmx01','',g_showmsg,'abm-984',0)
#         ROLLBACK WORK    #No.TQC-720003 add
#      END IF
#   ELSE
#      LET g_bmx.bmx04='N'
#      LET g_success = 'N'
#      ROLLBACK WORK    #No.TQC-720003 add
#   END IF
# 
#   SELECT * INTO g_bmx.* FROM bmx_file WHERE bmx01 = g_bmx.bmx01
#   IF g_bmx.bmx04='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
#   IF g_bmx.bmx09='1' OR
#      g_bmx.bmx09='2' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
#   IF g_bmx.bmx09='6' THEN LET g_chr3='Y' ELSE LET g_chr3='N' END IF
#   IF g_argv2 <> 'abmp701' THEN      #NO.FUN-840033 add
#       CALL cl_set_field_pic(g_bmx.bmx04,g_chr2,"",g_chr3,g_chr,g_bmx.bmxacti)
#   END IF                            #NO.FUN-840033 add
#
##FUN-950057 ------------------add start-------------------------------------
#   SELECT gev04 INTO g_gev04 FROM gev_file                                      
#    WHERE gev01 = '3' AND gev02 = g_plant                                       
#      AND gev03 = 'Y'
#   IF NOT cl_null(g_gev04) THEN                                                 
#       SELECT DISTINCT gew03 INTO l_gew03 FROM gew_file                           
#        WHERE gew01 = g_gev04 AND gew02 = '3'                                   
#       IF l_gew03 = '1' THEN  #自动抛转
#       #開窗選擇拋轉的db清單
#          LET l_sql = "SELECT COUNT(*) FROM &bmx_file WHERE bmx01='",g_bmx.bmx01,"'"
#          CALL s_dc_sel_db1(g_gev04,'3',l_sql)                                 
#           IF INT_FLAG THEN                                                     
#              LET INT_FLAG=0                                                    
#              RETURN                                                            
#           END IF                                                               
#                                                                                
#           CALL g_bmxx.clear()                                                  
#           LET g_bmxx[1].sel = 'Y'                                              
#           LET g_bmxx[1].bmx01 = g_bmx.bmx01                                    
#           FOR l_i = 1 TO g_azp1.getLength()                                    
#               LET g_azp[l_i].sel   = g_azp1[l_i].sel                           
#               LET g_azp[l_i].azp01 = g_azp1[l_i].azp01                         
#               LET g_azp[l_i].azp02 = g_azp1[l_i].azp02                         
#               LET g_azp[l_i].azp03 = g_azp1[l_i].azp03                         
#           END FOR                                                              
#                                                                                
#           CALL s_showmsg_init()                                                
#           CALL s_abmi710_carry_bmx(g_bmxx,g_azp,g_gev04,'0')                   
#           CALL s_showmsg()                                                     
#       END IF                                                                   
#   END IF
##FUN-950057 ------------------------add end---------------------  
#END FUNCTION
#
##No.FUN-A60008--begin
#FUNCTION i720_s()
#DEFINE l_sql    STRING 
#
#    IF g_argv3_str='1' THEN 
#       IF NOT cl_null(b_bmy.bmy04) THEN             
#           LET l_sql ="SELECT bmb_file.*  FROM bmb_file ",
#                      " WHERE bmb01 ='", b_bmy.bmy14 CLIPPED, "'"
#           IF g_sma.sma118='Y' THEN
#             LET l_sql=l_sql,"   AND bmb29 ='", b_bmy.bmy29 , "'" #MOD-830242
#           END IF       
#           LET l_sql=l_sql,"   AND bmb02 =",  b_bmy.bmy04,
#                      "   AND bmb03 ='", b_bmy.bmy05 CLIPPED, "'",
#                      "   AND (bmb05 >'", g_bmx.bmx07 CLIPPED ,"' OR bmb05 IS NULL)", #MOD-6A0109 add ,
#                      "   AND bmb04 = (SELECT MAX(bmb04) FROM bmb_file ",
#                                    #---> Mod No.MOD-AB0029
#                                    #" WHERE bmb01 = '",b_bmy.bmy14 CLIPPED,"' ",
#                                    #"   AND bmb02 = ",b_bmy.bmy04 CLIPPED,
#                                     " WHERE bmb01 = '",b_bmy.bmy14 CLIPPED,"' "
#                                     IF g_sma.sma118='Y' THEN
#                                        LET l_sql=l_sql,"   AND bmb29 ='", b_bmy.bmy29 , "'" #MOD-830242
#                                     END IF
#                                     LET l_sql=l_sql,"   AND bmb02 = ",b_bmy.bmy04 CLIPPED,
#                                    #---> End Mod No.MOD-AB0029
#                                     "   AND bmb03 = '",b_bmy.bmy05 CLIPPED,"' ",
#                                     "   AND (bmb04 <= '",g_bmx.bmx07 CLIPPED,"' OR bmb04 IS NULL) ", 
#                                     "   AND (bmb05 >  '",g_bmx.bmx07 CLIPPED,"' OR bmb05 IS NULL)) "
#       
#       ELSE       
#           LET l_sql ="SELECT bmb_file.*  FROM bmb_file ",
#                      " WHERE bmb01 ='", b_bmy.bmy14 CLIPPED, "'"
#           IF g_sma.sma118='Y' THEN
#              LET l_sql=l_sql,"   AND bmb29 ='", b_bmy.bmy29 , "'"  #MOD-830242
#           END IF
#       
#           LET l_sql=l_sql,"   AND bmb03 ='", b_bmy.bmy05 CLIPPED, "'",
#                      "   AND (bmb05 >'", g_bmx.bmx07 CLIPPED ,"' OR bmb05 IS NULL)"
#       END IF
#       
#       PREPARE i720_bmb_pre FROM l_sql
#       DECLARE i720_bmb_c2 CURSOR FOR i720_bmb_pre
#       FOREACH i720_bmb_c2 INTO g_bmb.* 
#         IF STATUS THEN	# 當bmy04 is null時,可能讀出一筆以上
#            CALL cl_err('sel bmb:',STATUS,1) LET g_success='N' RETURN
#         END IF
#         LET g_last_seq=g_bmb.bmb02
#         CASE
#              WHEN b_bmy.bmy03='1' CALL i720_s1()	# 失效
#              WHEN b_bmy.bmy03='3' CALL i720_s3()	# 修改
#              WHEN b_bmy.bmy03='4' CALL i720_s4()	# 取代
#              WHEN b_bmy.bmy03='5' CALL i720_s4()	# 替代   #CHI-960004
#         END CASE
#         IF g_success='N' THEN RETURN END IF
#         UPDATE ima_file SET ima05 = b_bmy.bmy17 WHERE ima01=b_bmy.bmy14
#       END FOREACH 
#    ELSE 
#       IF NOT cl_null(b_bmy.bmy04) THEN             
#           LET l_sql ="SELECT brb_file.*  FROM brb_file ",
#                      " WHERE brb01 ='", b_bmy.bmy14 CLIPPED, "' ",
#                      " AND brb011='", b_bmy.bmy011 CLIPPED, "' ",
#                      " AND brb012='", b_bmy.bmy012 CLIPPED, "' ",
#                      " AND brb013='", b_bmy.bmy013 CLIPPED, "' "
#           IF g_sma.sma118='Y' THEN
#             LET l_sql=l_sql,"   AND brb29 ='", b_bmy.bmy29 , "'" #MOD-830242
#           END IF       
#           LET l_sql=l_sql,"   AND brb02 =",  b_bmy.bmy04,
#                      "   AND brb03 ='", b_bmy.bmy05 CLIPPED, "'",
#                      "   AND (brb05 >'", g_bmx.bmx07 CLIPPED ,"' OR brb05 IS NULL)", #MOD-6A0109 add ,
#                      "   AND brb04 = (SELECT MAX(brb04) FROM brb_file ",
#                                     " WHERE brb01 = '",b_bmy.bmy14 CLIPPED,"' ",
#                                     " AND brb011='", b_bmy.bmy011 CLIPPED, "' ",
#                                     " AND brb012='", b_bmy.bmy012 CLIPPED, "' ",
#                                     " AND brb013='", b_bmy.bmy013 CLIPPED, "' ",
#                                     "   AND brb02 = ",b_bmy.bmy04 CLIPPED,
#                                     "   AND brb03 = '",b_bmy.bmy05 CLIPPED,"' ",
#                                     "   AND (brb04 <= '",g_bmx.bmx07 CLIPPED,"' OR brb04 IS NULL) ", 
#                                     "   AND (brb05 >  '",g_bmx.bmx07 CLIPPED,"' OR brb05 IS NULL)) "
#       
#       ELSE       
#           LET l_sql ="SELECT brb_file.*  FROM brb_file ",
#                      " WHERE brb01 ='", b_bmy.bmy14 CLIPPED, "'",
#                      " AND brb011='", b_bmy.bmy011 CLIPPED, "' ",
#                      " AND brb012='", b_bmy.bmy012 CLIPPED, "' ",
#                      " AND brb013='", b_bmy.bmy013 CLIPPED, "' "
#           IF g_sma.sma118='Y' THEN
#              LET l_sql=l_sql,"   AND brb29 ='", b_bmy.bmy29 , "'"  #MOD-830242
#           END IF
#       
#           LET l_sql=l_sql,"   AND brb03 ='", b_bmy.bmy05 CLIPPED, "'",
#                      "   AND (brb05 >'", g_bmx.bmx07 CLIPPED ,"' OR brb05 IS NULL)"
#       END IF
#       
#       PREPARE i720_brb_pre FROM l_sql
#       DECLARE i720_brb_c2 CURSOR FOR i720_brb_pre
#       FOREACH i720_brb_c2 INTO g_brb.* 
#         IF STATUS THEN	# 當bmy04 is null時,可能讀出一筆以上
#            CALL cl_err('sel brb:',STATUS,1) LET g_success='N' RETURN
#         END IF
#         LET g_last_seq=g_brb.brb02
#         CASE
#              WHEN b_bmy.bmy03='1' CALL i720_s1()	# 失效
#              WHEN b_bmy.bmy03='3' CALL i720_s3()	# 修改
#         END CASE
#         IF g_success='N' THEN RETURN END IF
#         UPDATE ima_file SET ima05 = b_bmy.bmy17 WHERE ima01=b_bmy.bmy14
#       END FOREACH     	
#    END IF 
#END FUNCTION 
##No.FUN-A60008--end  
#  
#FUNCTION i720_s1()
#DEFINE   l_bmb06   LIKE bmb_file.bmb06
#
#   #No.FUN-A60008--begin
#   SELECT bra014 INTO g_bra014 FROM bra_file 
#    WHERE bra01 =b_bmy.bmy14 AND bra011=b_bmy.bmy011
#     AND bra012=b_bmy.bmy012 AND bra013=b_bmy.bmy013 
#    #No.FUN-A60008--end    
#   IF g_argv3_str='1' THEN  #No.FUN-A60008
#      UPDATE bmb_file SET bmb05=g_bmx.bmx07,
#                          bmb24=g_bmx.bmx01,
#                          bmb30=b_bmy.bmy30,      #NO.FUN-810014
#                          bmbmodu=g_user,
#                          bmbdate=g_today
#       WHERE bmb01 = g_bmb.bmb01 AND bmb02=g_bmb.bmb02 AND bmb03=g_bmb.bmb03 AND bmb04=g_bmb.bmb04 AND bmb29=g_bmb.bmb29      
#    #No.FUN-A60008--begin
#    END IF 
#    IF g_argv3_str='2' THEN 
#    	 UPDATE brb_file SET brb05=g_bmx.bmx07,
#                           brb24=g_bmx.bmx01,
#                           brb30=b_bmy.bmy30,      
#                           brbmodu=g_user,
#                           brbdate=g_today
#       WHERE brb01 = g_brb.brb01 AND brb011=g_brb.brb011
#         AND brb012=g_brb.brb012 AND brb013=g_brb.brb013
#         AND brb02=g_brb.brb02 AND brb03=g_brb.brb03 
#         AND brb04=g_brb.brb04 
#         AND brb29=g_brb.brb29     
#          
#      IF g_bra014='Y' THEN 
#         SELECT ecb06 INTO g_ecb06 FROM ecb_file 
#         WHERE ecb01=g_brb.brb01 AND ecb02=g_brb.brb011
#          AND ecb012=g_brb.brb012 AND ecb03=g_brb.brb013        
#         SELECT bmb06 INTO l_bmb06 FROM bmb_file 
#          WHERE bmb01=g_brb.brb01 AND bmb03=g_brb.brb03
#            AND bmb29=g_brb.brb29 AND bmb09=g_ecb06
#         IF l_bmb06 >g_brb.brb06 THEN 
#           UPDATE bmb_file SET bmb06  = l_bmb06-g_brb.brb06,
#                               bmb24  = g_bmx.bmx01,
#                               bmbmodu= g_user,
#                               bmbdate= g_today
#            WHERE bmb01 = g_brb.brb01 AND bmb09=g_brb.brb09 AND bmb03=g_brb.brb03 
#              AND bmb29=g_brb.brb29           
#         ELSE  
#           UPDATE bmb_file SET bmb05  = g_bmx.bmx07,
#                               bmb24  = g_bmx.bmx01,
#                               bmbmodu= g_user,
#                               bmbdate= g_today
#            WHERE bmb01 = g_brb.brb01 AND bmb09=g_brb.brb09 AND bmb03=g_brb.brb03 
#              AND bmb29=g_brb.brb29
##              AND bmb04=g_brb.brb04 
#         END IF 
#       END IF          
#    END IF    
#    #No.FUN-A60008--end    
#   IF SQLCA.sqlcode THEN
#      LET g_showmsg = g_bmx.bmx01,' update bmb_file:'                    
#      CALL s_errmsg('bmx01','',g_showmsg,SQLCA.SQLCODE,1)
#      LET g_success='N'
#   END IF
#   IF SQLCA.SQLERRD[3]=0 THEN
#      LET g_showmsg = g_bmx.bmx01,' update bmb_file:'                    
#      CALL s_errmsg('bmx01','',g_showmsg,'aap-161',1)
#      LET g_success='N'
#   END IF
#   IF g_argv3_str='1' THEN  #No.FUN-A60008
#       UPDATE bmv_file SET bmv06 = g_bmx.bmx07    
#        WHERE bmv01 = b_bmy.bmy14
#          AND bmv02 = b_bmy.bmy05
#          AND bmv03 = b_bmy.bmy29
#       IF SQLCA.sqlcode THEN
#          LET g_showmsg = g_bmx.bmx01,' update bmv_file:'                    
#          CALL s_errmsg('bmx01','',g_showmsg,SQLCA.SQLCODE,1)
#          LET g_success='N'
#       END IF
#   END IF 
#   LET g_bmy05_t=b_bmy.bmy05
# 
#END FUNCTION
# 
#FUNCTION i720_s2()
#   DEFINE l_bmt		RECORD LIKE bmt_file.*
#   DEFINE l_ima151      LIKE ima_file.ima151   #No.FUN-850017
#   DEFINE l_ecb06       LIKE ecb_file.ecb06
#   DEFINE l_brb06       LIKE brb_file.brb06 
#   DEFINE l_bmc		RECORD LIKE bmc_file.* #CHI-A70013 add
#    
#   #No.FUN-A60008--begin
#   SELECT bra014 INTO g_bra014 FROM bra_file 
#    WHERE bra01 =b_bmy.bmy14 AND bra011=b_bmy.bmy011
#     AND bra012=b_bmy.bmy012 AND bra013=b_bmy.bmy013 
#    #No.FUN-A60008--end   
#    
#   INITIALIZE g_bmb.* TO NULL
#   LET g_bmb.bmb01 =b_bmy.bmy14
#   LET g_bmb.bmb02 =b_bmy.bmy04
#   LET g_bmb.bmb29 =b_bmy.bmy29 #FUN-550014 add
#   LET g_bmb.bmb30 =b_bmy.bmy30 #FUN-550014 add
#   LET g_bmb.bmb33 =b_bmy.bmy33 #FUN-810014 add
#   IF g_bmb.bmb02 IS NULL THEN      #No.MOD-840645 del mark
#      SELECT MAX(bmb02) INTO g_bmb.bmb02 FROM bmb_file WHERE bmb01=g_bmb.bmb01
#                                                         AND bmb29 = g_bmb.bmb29  #FUN-550014 add
#      IF g_bmb.bmb02 IS NULL THEN LET g_bmb.bmb02 = 0 END IF
#      LET g_bmb.bmb02=g_bmb.bmb02+g_sma.sma19
#   END IF                           #No.MOD-840645 del mark
#
#   LET g_bmb.bmb03 =b_bmy.bmy05
#   LET g_bmb.bmb04 =g_bmx.bmx07
#   LET g_bmb.bmb06 =b_bmy.bmy06
#   LET g_bmb.bmb07 =b_bmy.bmy07
#   LET g_bmb.bmb16 =b_bmy.bmy16
#   LET g_bmb.bmb24 =g_bmx.bmx01
#   LET g_bmb.bmb25 =b_bmy.bmy25
#   LET g_bmb.bmb26 =b_bmy.bmy26
#   LET g_bmb.bmb13 =b_bmy.bmy13
#   LET g_bmb.bmb18 =b_bmy.bmy18
#   LET g_bmb.bmb08 =b_bmy.bmy08
#   LET g_bmb.bmb081=b_bmy.bmy081  #Add No:TQC-AC0300
#   LET g_bmb.bmb082=b_bmy.bmy082  #Add No:TQC-AC0300
#   LET g_bmb.bmb11 =b_bmy.bmy11
#   LET g_bmb.bmb09 =b_bmy.bmy09
#   LET g_bmb.bmb10 =b_bmy.bmy10
#   LET g_bmb.bmb10_fac =b_bmy.bmy10_fac
#   SELECT ima105 INTO g_bmb.bmb27 FROM ima_file    #No.MOD-940061 add
#    WHERE ima01=g_bmb.bmb03
#   LET g_bmb.bmb31 =b_bmy.bmy34  #no.MOD-840426
#   LET g_bmb.bmb10_fac2=b_bmy.bmy10_fac2
#  #LET g_bmb.bmb14 =0 #CHI-A60028 mark
#   LET g_bmb.bmb14 =b_bmy.bmy35 #CHI-A60028 add
#   LET g_bmb.bmb15 =b_bmy.bmy21   #bugno:6845 add
#   LET g_bmb.bmb17 ='N'
#   LET g_bmb.bmb19 ='1'
#   IF NOT cl_null(b_bmy.bmy20) THEN LET g_bmb.bmb19 =b_bmy.bmy20 END IF  # No.MOD-710092 modify
#  #LET g_bmb.bmb23 =0        #MOD-A90160 mark   
#   LET g_bmb.bmb23 = 100     #MOD-A90160 add 
#   LET g_bmb.bmb28 =b_bmy.bmy23   #bugno:6845 add
#   IF cl_null(g_bmb.bmb28) THEN
#      LET g_bmb.bmb28 =0
#   END IF
# 
#   IF cl_null(g_bmb.bmb02)  THEN
#      LET g_bmb.bmb02=' '
#   END IF
#   IF cl_null(g_bmb.bmb08) THEN
#      LET g_bmb.bmb08 = 0
#   END IF
#   #Add No:TQC-AC0300
#   IF cl_null(g_bmb.bmb081) THEN
#      LET g_bmb.bmb081 = 0
#   END IF
#   IF cl_null(g_bmb.bmb082) THEN
#      LET g_bmb.bmb082 = 1
#   END IF
#   #End Add No:TQC-AC0300
#   LET g_bmb.bmb33 = 0   #no.FUN-840033 add
#   LET g_bmb.bmb31 = b_bmy.bmy34  #no.MOD-840478
# 
#    SELECT ima151 INTO l_ima151  FROM ima_file,bmy_file  WHERE bmy14 = ima01 AND bmy14 = b_bmy.bmy14
#                                                           AND bmy01 = g_bmx.bmx01 AND bmy02 = b_bmy.bmy02
#
#   IF g_argv3_str='1' THEN  #No.FUN-A60008
#      IF l_ima151 = 'Y' THEN
#         UPDATE bmy_file SET bmy33= g_bmb.bmb02
#                       WHERE bmy01 = g_bmx.bmx01
#                         AND bmy02 = b_bmy.bmy02
#                         AND bmy14 = b_bmy.bmy14
#        IF SQLCA.sqlcode THEN
#         LET g_showmsg = g_bmx.bmx01,' update bmy_file:'                    
#         CALL s_errmsg('bmy33','',g_showmsg,SQLCA.SQLCODE,1)
#         LET g_success='N'
#        END IF
#       ELSE
#        LET g_bmb.bmb33 = b_bmy.bmy33
#       END IF
#
#      INSERT INTO bmb_file VALUES(g_bmb.*)
#      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#         LET g_showmsg = g_bmx.bmx01,' insert bmb_file:'                  
#         CALL s_errmsg('bmx01','',g_showmsg,SQLCA.SQLCODE,1)
#         LET g_success='N'
#      END IF
#
#      IF g_sma.sma845='Y'   #低階碼可否部份重計
#         THEN
#         CALL s_uima146(g_bmb.bmb03)
#         CALL cl_msg("")                              #FUN-640241
#      END IF
#      
#      DECLARE i720_s2_c2 CURSOR FOR
#           SELECT * FROM bmw_file
#            WHERE bmw01=g_bmx.bmx01 AND bmw02=b_bmy.bmy02
#      FOREACH i720_s2_c2 INTO b_bmw.*
#         LET l_bmt.bmt01=g_bmb.bmb01
#         LET l_bmt.bmt02=g_bmb.bmb02
#         LET l_bmt.bmt03=g_bmb.bmb03
#         LET l_bmt.bmt04=g_bmb.bmb04
#         LET l_bmt.bmt05=b_bmw.bmw03
#         LET l_bmt.bmt06=b_bmw.bmw04
#         LET l_bmt.bmt07=b_bmw.bmw05
#         LET l_bmt.bmt08=g_bmb.bmb29 #FUN-550014 add
#         IF cl_null(l_bmt.bmt02) THEN
#            LET l_bmt.bmt02=0
#         END IF
#         INSERT INTO bmt_file VALUES(l_bmt.*)
#         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#            LET g_showmsg = l_bmt.bmt01,' insert bmt_file:'                  
#            CALL s_errmsg('bmt01','',g_showmsg,SQLCA.SQLCODE,1)
#            LET g_success='N'
#         END IF
#      END FOREACH
#      
#      CALL i720_up_bmb13()
#      #CHI-A70013 add --start--
#      #----- 說明檔(bmc_file)複製 ------------
#      SELECT COUNT(*) INTO g_cnt FROM bmf_file
#       WHERE bmf01=g_bmx.bmx01 AND bmf02=b_bmy.bmy02
#      IF g_cnt>0 THEN 	# 有輸入才更新
#         DECLARE i720_s2_c3 CURSOR FOR
#          SELECT * FROM bmf_file
#           WHERE bmf01=g_bmx.bmx01 AND bmf02=b_bmy.bmy02
#         FOREACH i720_s2_c3 INTO b_bmf.*
#             LET l_bmc.bmc01=g_bmb.bmb01
#             LET l_bmc.bmc02=g_bmb.bmb02
#             LET l_bmc.bmc021=g_bmb.bmb03
#             LET l_bmc.bmc03=g_bmb.bmb04
#             LET l_bmc.bmc04=b_bmf.bmf03
#             LET l_bmc.bmc05=b_bmf.bmf04
#             LET l_bmc.bmc06=g_bmb.bmb29 
#             INSERT INTO bmc_file VALUES(l_bmc.*)
#             IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#                LET g_showmsg = l_bmc.bmc01,'ins bmc:'
#                CALL s_errmsg('bmc01',l_bmc.bmc01,g_showmsg,SQLCA.sqlcode,1)
#                LET g_success='N'
#             END IF
#         END FOREACH
#      END IF
#      #CHI-A70013 add --end--
#   #No.FUN-A60008--begin
#   ELSE
#      INITIALIZE g_brb.* TO NULL
#      LET g_brb.brb01 =b_bmy.bmy14
#      LET g_brb.brb011 =b_bmy.bmy011
#      LET g_brb.brb012 =b_bmy.bmy012
#      LET g_brb.brb013 =b_bmy.bmy013
#      LET g_brb.brb02 =b_bmy.bmy04
#      LET g_brb.brb29 =b_bmy.bmy29
#      LET g_brb.brb30 =b_bmy.bmy30
#      LET g_brb.brb33 =b_bmy.bmy33 
#      IF g_brb.brb02 IS NULL THEN      
#         SELECT MAX(brb02) INTO g_brb.brb02 FROM brb_file 
#         WHERE brb01=g_brb.brb01 AND brb29 = g_brb.brb29  
#           AND brb011=g_brb.brb011 AND brb012=g_brb.brb012
#           AND brb013=g_brb.brb013
#         IF g_brb.brb02 IS NULL THEN LET g_brb.brb02 = 0 END IF
#         LET g_brb.brb02=g_brb.brb02+g_sma.sma19
#      END IF                          
#      LET g_brb.brb03 =b_bmy.bmy05
#      LET g_brb.brb04 =g_bmx.bmx07
#      LET g_brb.brb06 =b_bmy.bmy06
#      LET g_brb.brb07 =b_bmy.bmy07
#      LET g_brb.brb16 =b_bmy.bmy16
#      LET g_brb.brb24 =g_bmx.bmx01
#      LET g_brb.brb25 =b_bmy.bmy25
#      LET g_brb.brb26 =b_bmy.bmy26
#      LET g_brb.brb13 =b_bmy.bmy13
#      LET g_brb.brb18 =b_bmy.bmy18
#      LET g_brb.brb08 =b_bmy.bmy08
#      LET g_brb.brb081 = b_bmy.bmy081    #FUN-AC0075
#      LET g_brb.brb082 = b_bmy.bmy082    #FUN-AC0075
#      LET g_brb.brb11 =b_bmy.bmy11
#      SELECT ecb06 INTO l_ecb06 FROM ecb_file 
#      WHERE ecb01=g_brb.brb01 AND ecb02=g_brb.brb011
#       AND ecb012=g_brb.brb012 AND ecb03=g_brb.brb013        
#      LET g_brb.brb09 =l_ecb06
#      LET g_brb.brb10 =b_bmy.bmy10
#      LET g_brb.brb10_fac =b_bmy.bmy10_fac
#      SELECT ima105 INTO g_brb.brb27 FROM ima_file   
#       WHERE ima01=g_brb.brb03
#      LET g_brb.brb31 =b_bmy.bmy34 
#      LET g_brb.brb10_fac2=b_bmy.bmy10_fac2
#     #LET g_brb.brb14 =0 #CHI-A60028 mark
#      LET g_brb.brb14 =b_bmy.bmy35 #CHI-A60028 add
#      LET g_brb.brb15 =b_bmy.bmy21   
#      LET g_brb.brb17 ='N'
#      LET g_brb.brb19 ='1'
#      IF NOT cl_null(b_bmy.bmy20) THEN LET g_brb.brb19 =b_bmy.bmy20 END IF 
#     #LET g_brb.brb23 =0       #MOD-A90160 mark 
#      LET g_brb.brb23 =100     #MOD-A90160 add 
#      LET g_brb.brb28 =b_bmy.bmy23  
#      IF cl_null(g_brb.brb28) THEN
#         LET g_brb.brb28 =0
#      END IF
#      
#      IF cl_null(g_brb.brb02)  THEN
#         LET g_brb.brb02=' '
#      END IF
#      IF cl_null(g_brb.brb08) THEN
#         LET g_brb.brb08 = 0
#      END IF
#      LET g_brb.brb33 = 0  
#      LET g_brb.brb31 = b_bmy.bmy34  
#      IF g_bra014='Y' THEN 
#         INITIALIZE g_bmb.* TO NULL
#         LET g_bmb.bmb01 =b_bmy.bmy14 LET g_bmb.bmb29 =b_bmy.bmy29 
#         LET g_bmb.bmb30 =b_bmy.bmy30 LET g_bmb.bmb03 =b_bmy.bmy05
#         LET g_bmb.bmb04 =g_bmx.bmx07 LET g_bmb.bmb06 =b_bmy.bmy06
#         LET g_bmb.bmb07 =b_bmy.bmy07 LET g_bmb.bmb16 =b_bmy.bmy16
#         LET g_bmb.bmb24 =g_bmx.bmx01 LET g_bmb.bmb25 =b_bmy.bmy25
#         LET g_bmb.bmb26 =b_bmy.bmy26 LET g_bmb.bmb13 =b_bmy.bmy13
#         LET g_bmb.bmb18 =b_bmy.bmy18 LET g_bmb.bmb08 =b_bmy.bmy08
#         LET g_bmb.bmb081=b_bmy.bmy081 LET g_bmb.bmb082=b_bmy.bmy082  #Add No:TQC-AC0300
#         LET g_bmb.bmb11 =b_bmy.bmy11 LET g_bmb.bmb09 =g_brb.brb09
#         LET g_bmb.bmb10 =b_bmy.bmy10 LET g_bmb.bmb10_fac =b_bmy.bmy10_fac
#         LET g_bmb.bmb31 =b_bmy.bmy34 LET g_bmb.bmb27=g_brb.brb27 
#         LET g_bmb.bmb10_fac2=b_bmy.bmy10_fac2
#         LET g_bmb.bmb14 =b_bmy.bmy35 LET g_bmb.bmb15 =b_bmy.bmy21  
#         LET g_bmb.bmb17 ='N' 
#         LET g_bmb.bmb19 ='1'
#         SELECT MAX(bmb02) INTO g_bmb.bmb02 FROM bmb_file 
#         WHERE bmb01=g_bmb.bmb01 AND bmb29=g_bmb.bmb29 
#         IF cl_null(g_bmb.bmb02) THEN
#            LET g_bmb.bmb02 = 0
#         END IF
#         LET g_bmb.bmb02=g_bmb.bmb02+g_sma.sma19                 
#         IF NOT cl_null(b_bmy.bmy20) THEN LET g_bmb.bmb19 =b_bmy.bmy20 END IF  
#        #LET g_bmb.bmb23 =0        #MOD-A90160 mark   
#         LET g_bmb.bmb23 = 100     #MOD-A90160 add 
#         LET g_bmb.bmb28 =b_bmy.bmy23  
#         IF cl_null(g_bmb.bmb28) THEN
#            LET g_bmb.bmb28 =0
#         END IF
#         IF cl_null(g_bmb.bmb08) THEN
#            LET g_bmb.bmb08 = 0
#         END IF
#         #Add No:TQC-AC0300
#         IF cl_null(g_bmb.bmb081) THEN
#            LET g_bmb.bmb081 = 0
#         END IF
#         IF cl_null(g_bmb.bmb082) THEN
#            LET g_bmb.bmb082 = 1
#         END IF
#         #End Add No:TQC-AC0300
#         LET g_bmb.bmb33 = 0                  
#         LET g_bmb.bmb31 = b_bmy.bmy34 
#         LET g_bmb.bmbdate = g_today 
#         SELECT SUM(brb06) INTO l_brb06 FROM brb_file,bra_file  
#          WHERE bra01=brb01 AND bra011=brb011 AND bra012=brb012 
#            AND bra013=brb013 AND bra06=brb29 AND bra10='2' 
#            AND brb01=g_brb.brb01 AND brb011=g_brb.brb011 
#            AND brb09=l_ecb06 AND brb29=g_brb.brb29 AND brb03=g_brb.brb03
#         IF cl_null(l_brb06) THEN 
#            LET l_brb06=0
#         END IF    
#         LET g_bmb.bmb06=l_brb06+b_bmy.bmy06
#         INSERT INTO bmb_file VALUES(g_bmb.*)
#         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#            LET g_showmsg = g_bmx.bmx01,'ins brb:'
#            CALL s_errmsg('brb01',g_bmb.bmb01,g_showmsg,SQLCA.sqlcode,1)
#            LET g_success='N'
#         END IF            
#      END IF             
##FUN-A70125 --begin--
#      IF cl_null(g_brb.brb012) THEN
#         LET g_brb.brb012 = ' ' 
#      END IF 
#      IF cl_null(g_brb.brb013) THEN
#         LET g_brb.brb013 = 0 
#      END IF 
##FUN-A70125 --end--
#      INSERT INTO brb_file VALUES(g_brb.*)
#      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#         LET g_showmsg = g_bmx.bmx01,' insert brb_file:'                  
#         CALL s_errmsg('bmx01','',g_showmsg,SQLCA.SQLCODE,1)
#         LET g_success='N'
#      END IF      
#   END IF 
#   #No.FUN-A60008--end 
#END FUNCTION
# 
#FUNCTION i720_s3()
#   DEFINE l_bmt		RECORD LIKE bmt_file.*
#   DEFINE l_ima151      LIKE ima_file.ima151   #No.FUN-850017
#   DEFINE l_cnt         LIKE type_file.num5  #CHI-A50018 add
#   DEFINE l_brb06       LIKE brb_file.brb06  
#   DEFINE l_bmc		RECORD LIKE bmc_file.* #CHI-A70013 add
#
#   #No.FUN-A60008--begin
#   SELECT bra014 INTO g_bra014 FROM bra_file 
#    WHERE bra01 =b_bmy.bmy14 AND bra011=b_bmy.bmy011
#     AND bra012=b_bmy.bmy012 AND bra013=b_bmy.bmy013 
#    #No.FUN-A60008--end   
#    
#   #LET g_bmb.bmb04 =g_bmx.bmx07 #No.FUN-A60008 
#   LET g_bmb.bmb05 =NULL
#   LET g_bmb.bmb06 =b_bmy.bmy06
#   LET g_bmb.bmb07 =b_bmy.bmy07
#   LET g_bmb.bmb16 =b_bmy.bmy16
#   LET g_bmb.bmb14 =b_bmy.bmy35 #CHI-A60028 add
#   LET g_bmb.bmb24 =g_bmx.bmx01
#   IF NOT cl_null(b_bmy.bmy25) THEN LET g_bmb.bmb25 =b_bmy.bmy25 END IF
#   IF NOT cl_null(b_bmy.bmy26) THEN LET g_bmb.bmb26 =b_bmy.bmy26 END IF
#   IF NOT cl_null(b_bmy.bmy13) THEN LET g_bmb.bmb13 =b_bmy.bmy13 END IF
#   IF NOT cl_null(b_bmy.bmy18) THEN LET g_bmb.bmb18 =b_bmy.bmy18 END IF
#   IF NOT cl_null(b_bmy.bmy08) THEN LET g_bmb.bmb08 =b_bmy.bmy08 END IF
#   IF NOT cl_null(b_bmy.bmy081) THEN LET g_bmb.bmb081 =b_bmy.bmy081 END IF  #Add No:TQC-AC0300
#   IF NOT cl_null(b_bmy.bmy082) THEN LET g_bmb.bmb082 =b_bmy.bmy082 END IF  #Add No:TQC-AC0300
#   IF NOT cl_null(b_bmy.bmy11) THEN LET g_bmb.bmb11 =b_bmy.bmy11 END IF
#   IF NOT cl_null(b_bmy.bmy20) THEN LET g_bmb.bmb19 =b_bmy.bmy20 END IF
#   IF NOT cl_null(b_bmy.bmy09) THEN LET g_bmb.bmb09 =b_bmy.bmy09 END IF
#   IF NOT cl_null(b_bmy.bmy10) THEN LET g_bmb.bmb10 =b_bmy.bmy10 END IF
#   IF NOT cl_null(b_bmy.bmy10_fac) THEN
#      LET g_bmb.bmb10_fac =b_bmy.bmy10_fac
#   END IF
#  #MOD-B60018---add---start---
#   IF NOT cl_null(b_bmy.bmy10_fac2) THEN
#      LET g_bmb.bmb10_fac2 =b_bmy.bmy10_fac2
#   END IF
#  #MOD-B60018---add---end---
#   IF NOT cl_null(b_bmy.bmy21) THEN LET g_bmb.bmb15 =b_bmy.bmy21 END IF
#   IF NOT cl_null(b_bmy.bmy23) THEN LET g_bmb.bmb28 =b_bmy.bmy23 END IF
#   LET g_bmb.bmbmodu = g_user
#   LET g_bmb.bmbdate = g_today
#   IF g_argv3_str='1' THEN  #No.FUN-A60008
#      UPDATE bmb_file SET bmb05=g_bmx.bmx07,
#                          bmb30=b_bmy.bmy30                        #NO.FUN-810014
#      WHERE bmb01 = g_bmb.bmb01 AND bmb02=g_bmb.bmb02 AND bmb03=g_bmb.bmb03 
#      AND bmb04=g_bmb.bmb04 
#      AND bmb29=g_bmb.bmb29  #失效日 #No:7827
#   END IF 
#   #No.FUN-A60008--begin 
#   IF g_argv3_str='2' THEN 
#      UPDATE brb_file SET brb05=g_bmx.bmx07,
#                          brb30=b_bmy.bmy30                        
#      WHERE brb01 = g_brb.brb01 AND brb02=g_brb.brb02 
#      AND brb011 = g_brb.brb011 AND brb012 = g_brb.brb012
#      AND brb013 = g_brb.brb013 AND brb03=g_brb.brb03 
#      AND brb04=g_brb.brb04 
#      AND brb29=g_brb.brb29   	
#   END IF 	
#   #No.FUN-A60008--end  
#   IF SQLCA.SQLCODE THEN
#      LET g_showmsg = g_bmx.bmx01,' update bmb05,bmb30:'                  
#      CALL s_errmsg('bmb01','',g_showmsg,SQLCA.SQLCODE,1)
#      LET g_success='N'
#   END IF
#   LET g_bmb.bmb29 =b_bmy.bmy29 #FUN-550014 add
#   LET g_bmb.bmb30 =b_bmy.bmy30 #FUN-550014 add
#   SELECT MAX(bmb02) INTO g_bmb.bmb02
#     FROM bmb_file WHERE bmb01 = g_bmb.bmb01
#                     AND bmb29 = g_bmb.bmb29  #FUN-550014 add
#   IF cl_null(g_bmb.bmb02) THEN LET g_bmb.bmb02 = 0 END IF
#   LET g_bmb.bmb02 = g_bmb.bmb02 + g_sma.sma19
#   IF cl_null(g_bmb.bmb28) THEN LET g_bmb.bmb28 =0 END IF
#   IF cl_null(g_bmb.bmb02)  THEN
#      LET g_bmb.bmb02=' '
#   END IF
#   IF cl_null(g_bmb.bmb08) THEN
#      LET g_bmb.bmb08 = 0
#   END IF
#   #Add No:TQC-AC0300
#   IF cl_null(g_bmb.bmb081) THEN
#      LET g_bmb.bmb081 = 0
#   END IF
#   IF cl_null(g_bmb.bmb082) THEN
#      LET g_bmb.bmb082 = 1
#   END IF
#   #End Add No:TQC-AC0300
#   LET g_bmb.bmb33 = 0            #no.FUN-840033
#   LET g_bmb.bmb31 = b_bmy.bmy34  #no.MOD-840426 add
# 
#    SELECT ima151 INTO l_ima151  FROM ima_file,bmy_file  WHERE bmy14 = ima01 AND bmy14 = b_bmy.bmy14
#                                                           AND bmy01 = g_bmx.bmx01 AND bmy02 = b_bmy.bmy02 
#   IF g_argv3_str='1' THEN  #No.FUN-A60008
#    IF l_ima151 = 'Y' THEN
#      UPDATE bmy_file SET bmy33= g_bmb.bmb02
#                    WHERE bmy01 = g_bmx.bmx01
#                      AND bmy02 = b_bmy.bmy02
#                      AND bmy14 = b_bmy.bmy14
#     IF SQLCA.sqlcode THEN
#      LET g_showmsg = g_bmx.bmx01,' update bmy_file:'                    
#      CALL s_errmsg('bmy33','',g_showmsg,SQLCA.SQLCODE,1)
#      LET g_success='N'
#     END IF
#    ELSE
#     LET g_bmb.bmb33 = b_bmy.bmy33
#    END IF
#    
#   LET g_bmb.bmb04 =g_bmx.bmx07  #No.FUN-A60008 
#   INSERT INTO bmb_file VALUES (g_bmb.*)
#   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#      LET g_showmsg = g_bmb.bmb01,' insert bmb_file:'                  
#      CALL s_errmsg('bmb01','',g_showmsg,SQLCA.SQLCODE,1)
#      LET g_success='N'
#   END IF
#
#   IF g_sma.sma845='Y'   #低階碼可否部份重計
#      THEN
#      CALL s_uima146(g_bmb.bmb03)
#      CALL cl_msg("")                              #FUN-640241
#   END IF
# 
#   SELECT COUNT(*) INTO g_cnt FROM bmw_file
#         WHERE bmw01=g_bmx.bmx01 AND bmw02=b_bmy.bmy02
#   IF g_cnt=0 THEN
#   INITIALIZE l_bmt.* TO NULL
#   #CHI-A50018 mark --start--
#   #DECLARE i720_s3_c3 CURSOR FOR
#   #     SELECT * FROM bmt_file
#   #      WHERE bmt01=g_bmb.bmb01 AND bmt02=b_bmy.bmy04
#   #        AND bmt03=g_bmb.bmb03         # AND bmt04=g_bmb.bmb04
#   #        AND bmt08=g_bmb.bmb29
#   #CHI-A50018 mark --end--
#   #CHI-A50018 add --start--
#   DECLARE i720_s3_c3 CURSOR FOR
#      SELECT * FROM bmt_file
#       WHERE bmt01=b_bmy.bmy14
#         AND bmt03=b_bmy.bmy05
#         AND bmt04 IN (SELECT MAX(bmt04) FROM bmt_file
#                        WHERE bmt01=b_bmy.bmy14
#                          AND bmt03=b_bmy.bmy05
#                      )
#     LET l_cnt=0
#   #CHI-A50018 add --end--
#   FOREACH i720_s3_c3 INTO b_bmt.*
#      #CHI-A50018 add
#      LET l_cnt=l_cnt+1
#      IF l_cnt=1 THEN
#         LET g_sql=cl_getmsg('abm-040',g_lang)
#         IF NOT cl_prompt(0,0,g_sql) THEN EXIT FOREACH END IF
#      END IF
#      #CHI-A50018
#      LET l_bmt.bmt01=g_bmb.bmb01
#      LET l_bmt.bmt02=g_bmb.bmb02
#      LET l_bmt.bmt03=g_bmb.bmb03
#      LET l_bmt.bmt04=g_today
#      LET l_bmt.bmt05=b_bmt.bmt05
#      LET l_bmt.bmt06=b_bmt.bmt06
#      LET l_bmt.bmt07=b_bmt.bmt07
#      LET l_bmt.bmt08=g_bmb.bmb29 
#      INSERT INTO bmt_file VALUES(l_bmt.*)
#      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#         LET g_showmsg = l_bmt.bmt01,' insert bmt_file:'                  
#         CALL s_errmsg('bmt01','',g_showmsg,SQLCA.SQLCODE,1)
#         LET g_success='N'
#      END IF
#   END FOREACH
#   INITIALIZE l_bmt.* TO NULL
#   ELSE
#   DECLARE i720_s3_c2 CURSOR FOR
#        SELECT * FROM bmw_file
#         WHERE bmw01=g_bmx.bmx01 AND bmw02=b_bmy.bmy02
#   FOREACH i720_s3_c2 INTO b_bmw.*
#      LET l_bmt.bmt01=g_bmb.bmb01
#      LET l_bmt.bmt02=g_bmb.bmb02
#      LET l_bmt.bmt03=g_bmb.bmb03
#      LET l_bmt.bmt04=g_bmb.bmb04
#      LET l_bmt.bmt05=b_bmw.bmw03
#      LET l_bmt.bmt06=b_bmw.bmw04
#      LET l_bmt.bmt07=b_bmw.bmw05
#      LET l_bmt.bmt08=g_bmb.bmb29 #FUN-550014 add
#      IF cl_null(l_bmt.bmt02) THEN
#         LET l_bmt.bmt02=0
#      END IF
#      INSERT INTO bmt_file VALUES(l_bmt.*)
#      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#         LET g_showmsg = l_bmt.bmt01,' insert bmt_file:'                  
#         CALL s_errmsg('bmt01','',g_showmsg,SQLCA.SQLCODE,1)
#         LET g_success='N'
#      END IF
#   END FOREACH
#   CALL i720_up_bmb13()
#   END IF    #No.FUN-870127 
#    #CHI-A70013 add --start--
#    #----- 說明檔(bmc_file)複製 ------------
#      SELECT COUNT(*) INTO g_cnt FROM bmf_file
#       WHERE bmf01=g_bmx.bmx01 AND bmf02=b_bmy.bmy02
#      IF g_cnt=0 THEN RETURN END IF	# 有輸入才更新
#
#      DECLARE i720_s3_c4 CURSOR FOR
#       SELECT * FROM bmf_file
#        WHERE bmf01=g_bmx.bmx01 AND bmf02=b_bmy.bmy02
#
#      FOREACH i720_s3_c4 INTO b_bmf.*
#         LET l_bmc.bmc01=g_bmb.bmb01
#         LET l_bmc.bmc02=g_bmb.bmb02
#         LET l_bmc.bmc021=g_bmb.bmb03
#         LET l_bmc.bmc03=g_bmb.bmb04
#         LET l_bmc.bmc04=b_bmf.bmf03
#         LET l_bmc.bmc05=b_bmf.bmf04
#         LET l_bmc.bmc06=g_bmb.bmb29
# 
#         INSERT INTO bmc_file VALUES(l_bmc.*)
#         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#            LET g_showmsg = l_bmc.bmc01,' ins bmc:'
#            CALL s_errmsg('bmc01',l_bmc.bmc01,g_showmsg,SQLCA.SQLCODE,1)
#            LET g_success='N'
#         END IF
#      END FOREACH
#    #CHI-A70013 add --end--
#   #No.FUN-A60008--begin
#   ELSE 
#   	  LET g_brb.brb011 =b_bmy.bmy011
#   	  LET g_brb.brb012 =b_bmy.bmy012
#   	  LET g_brb.brb013 =b_bmy.bmy013
#      LET g_brb.brb04 =g_bmx.bmx07
#      LET g_brb.brb05 =NULL
#      LET g_brb.brb06 =b_bmy.bmy06
#      LET g_brb.brb07 =b_bmy.bmy07
#      LET g_brb.brb16 =b_bmy.bmy16
#      LET g_brb.brb14 =b_bmy.bmy35 #CHI-A60028 add
#      LET g_brb.brb24 =g_bmx.bmx01
#      IF cl_null(g_brb.brb09) THEN 
#         SELECT ecb06 INTO g_brb.brb09 FROM ecb_file 
#          WHERE ecb01=g_brb.brb01 AND ecb02=g_brb.brb011
#          AND ecb012=g_brb.brb012 AND ecb03=g_brb.brb013
#      END IF 
#      IF NOT cl_null(b_bmy.bmy25) THEN LET g_brb.brb25 =b_bmy.bmy25 END IF
#      IF NOT cl_null(b_bmy.bmy26) THEN LET g_brb.brb26 =b_bmy.bmy26 END IF
#      IF NOT cl_null(b_bmy.bmy13) THEN LET g_brb.brb13 =b_bmy.bmy13 END IF
#      IF NOT cl_null(b_bmy.bmy18) THEN LET g_brb.brb18 =b_bmy.bmy18 END IF
#      IF NOT cl_null(b_bmy.bmy08) THEN LET g_brb.brb08 =b_bmy.bmy08 END IF
#      IF NOT cl_null(b_bmy.bmy081) THEN LET g_brb.brb081 = b_bmy.bmy081 END IF    #FUN-AC0075
#      IF NOT cl_null(b_bmy.bmy082) THEN LET g_brb.brb082 = b_bmy.bmy082 END IF    #FUN-AC0075
#      IF NOT cl_null(b_bmy.bmy11) THEN LET g_brb.brb11 =b_bmy.bmy11 END IF
#      IF NOT cl_null(b_bmy.bmy20) THEN LET g_brb.brb19 =b_bmy.bmy20 END IF
#      IF NOT cl_null(b_bmy.bmy10) THEN LET g_brb.brb10 =b_bmy.bmy10 END IF
#      IF NOT cl_null(b_bmy.bmy10_fac) THEN
#         LET g_brb.brb10_fac =b_bmy.bmy10_fac
#      END IF
#      IF NOT cl_null(b_bmy.bmy21) THEN LET g_brb.brb15 =b_bmy.bmy21 END IF
#      IF NOT cl_null(b_bmy.bmy23) THEN LET g_brb.brb28 =b_bmy.bmy23 END IF
#      LET g_brb.brbmodu = g_user
#      LET g_brb.brbdate = g_today  
#      LET g_brb.brb29 =b_bmy.bmy29 
#      LET g_brb.brb30 =b_bmy.bmy30 
#      SELECT MAX(brb02) INTO g_brb.brb02
#        FROM brb_file WHERE brb01 = g_brb.brb01
#                         AND brb011 = g_brb.brb011 
#                         AND brb012 = g_brb.brb012 
#                         AND brb013 = g_brb.brb013
#                         AND brb29 = g_brb.brb29  
#      IF cl_null(g_brb.brb02) THEN LET g_brb.brb02 = 0 END IF
#      LET g_brb.brb02 = g_brb.brb02 + g_sma.sma19
#      IF cl_null(g_brb.brb28) THEN LET g_brb.brb28 =0 END IF
#      IF cl_null(g_brb.brb02)  THEN
#         LET g_brb.brb02=' '
#      END IF
#      IF cl_null(g_brb.brb08) THEN
#         LET g_brb.brb08 = 0
#      END IF
#      LET g_brb.brb33 = 0        
#      LET g_brb.brb31 = b_bmy.bmy34  
##FUN-A70125 --begin--
#      IF cl_null(g_brb.brb012) THEN
#         LET g_brb.brb012 = ' '
#      END IF
#      IF cl_null(g_brb.brb013) THEN
#         LET g_brb.brb013 = 0
#      END IF
##FUN-A70125 --end--
#      INSERT INTO brb_file VALUES (g_brb.*)
#      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#         LET g_showmsg = g_brb.brb01,' insert brb_file:'                  
#         CALL s_errmsg('brb01','',g_showmsg,SQLCA.SQLCODE,1)
#         LET g_success='N'
#      END IF   	
#      IF g_bra014='Y' THEN 
#         DELETE FROM bmb_file WHERE bmb01=g_brb.brb01 
#                                AND bmb03=g_brb.brb03 
#                                AND bmb09=g_brb.brb09
#                                AND bmb29=g_brb.brb29
#         SELECT SUM(brb06) INTO l_brb06 FROM brb_file  
#          WHERE brb01=g_brb.brb01 AND brb011=g_brb.brb011 
#            AND (brb012 !=g_brb.brb012 OR brb013 !=g_brb.brb013 )
#            AND brb09 =g_brb.brb09 AND brb29 =g_brb.brb29 
#            AND brb03=g_brb.brb03 
#         IF cl_null(l_brb06) THEN LET l_brb06=0 END IF 
#         LET g_bmb.bmb01=g_brb.brb01   LET g_bmb.bmb03=g_brb.brb03
#         LET g_bmb.bmb04 =g_bmx.bmx07  LET g_bmb.bmb29 =b_bmy.bmy29 
#         LET g_bmb.bmb30 =b_bmy.bmy30  LET g_bmb.bmb05 =NULL
#         SELECT MAX(bmb02) INTO g_bmb.bmb02 FROM bmb_file
#          WHERE bmb01 = g_bmb.bmb01
#            AND bmb29 = g_bmb.bmb29 
#         IF cl_null(g_bmb.bmb02) THEN LET g_bmb.bmb02 = 0 END IF
#         LET g_bmb.bmb02 = g_bmb.bmb02 + g_sma.sma19
#         IF cl_null(g_bmb.bmb08) THEN
#            LET g_bmb.bmb08 = 0
#         END IF
#         LET g_bmb.bmb33 = 0               
#         IF cl_null(b_bmy.bmy06) THEN 
#            LET b_bmy.bmy06=g_brb.brb06
#         END IF 
#         LET g_bmb.bmb06 =b_bmy.bmy06+l_brb06
#         LET g_bmb.bmb09=g_brb.brb09
#         LET g_bmb.bmb07=g_brb.brb07 LET g_bmb.bmb08=g_brb.brb08 
#         LET g_bmb.bmb081=g_brb.brb081 LET g_bmb.bmb082=g_brb.brb082 
#         LET g_bmb.bmb09=g_brb.brb09 LET g_bmb.bmb10=g_brb.brb10
#         LET g_bmb.bmb10_fac=g_brb.brb10_fac LET g_bmb.bmb10_fac2=g_brb.brb10_fac2
#         LET g_bmb.bmb11=g_brb.brb11 LET g_bmb.bmb13=g_brb.brb13
#         LET g_bmb.bmb14=g_brb.brb14 LET g_bmb.bmb15=g_brb.brb15
#         LET g_bmb.bmb16=g_brb.brb16 LET g_bmb.bmb17=g_brb.brb17
#         LET g_bmb.bmb18=g_brb.brb18 LET g_bmb.bmb19=g_brb.brb19
#         LET g_bmb.bmb20=g_brb.brb20 LET g_bmb.bmb21=g_brb.brb21
#         LET g_bmb.bmb22=g_brb.brb22 LET g_bmb.bmb23=g_brb.brb23
#         LET g_bmb.bmb25=g_brb.brb25 LET g_bmb.bmb26=g_brb.brb26
#         LET g_bmb.bmb27=g_brb.brb27 LET g_bmb.bmb28=g_brb.brb28
#         LET g_bmb.bmb31=g_brb.brb31 
#         LET g_bmb.bmb24 =g_bmx.bmx01 
#         LET g_bmb.bmbmodu = g_user
#         LET g_bmb.bmbdate = g_today     
#         IF NOT cl_null(b_bmy.bmy07) THEN LET g_bmb.bmb07 =b_bmy.bmy07 END IF
#         IF NOT cl_null(b_bmy.bmy16) THEN LET g_bmb.bmb16 =b_bmy.bmy16 END IF
#         IF NOT cl_null(b_bmy.bmy35) THEN LET g_bmb.bmb14 =b_bmy.bmy35 END IF  
#         IF NOT cl_null(b_bmy.bmy25) THEN LET g_bmb.bmb25 =b_bmy.bmy25 END IF
#         IF NOT cl_null(b_bmy.bmy26) THEN LET g_bmb.bmb26 =b_bmy.bmy26 END IF
#         IF NOT cl_null(b_bmy.bmy13) THEN LET g_bmb.bmb13 =b_bmy.bmy13 END IF
#         IF NOT cl_null(b_bmy.bmy18) THEN LET g_bmb.bmb18 =b_bmy.bmy18 END IF
#         IF NOT cl_null(b_bmy.bmy08) THEN LET g_bmb.bmb08 =b_bmy.bmy08 END IF
#         IF NOT cl_null(b_bmy.bmy081) THEN LET g_bmb.bmb081 =b_bmy.bmy081 END IF  #Add No:TQC-AC0300
#         IF NOT cl_null(b_bmy.bmy082) THEN LET g_bmb.bmb082 =b_bmy.bmy082 END IF  #Add No:TQC-AC0300
#         IF NOT cl_null(b_bmy.bmy11) THEN LET g_bmb.bmb11 =b_bmy.bmy11 END IF
#         IF NOT cl_null(b_bmy.bmy20) THEN LET g_bmb.bmb19 =b_bmy.bmy20 END IF
#         IF NOT cl_null(b_bmy.bmy10) THEN LET g_bmb.bmb10 =b_bmy.bmy10 END IF
#         IF NOT cl_null(b_bmy.bmy10_fac) THEN
#            LET g_bmb.bmb10_fac =b_bmy.bmy10_fac
#         END IF
#         IF NOT cl_null(b_bmy.bmy10_fac2) THEN
#            LET g_bmb.bmb10_fac2 =b_bmy.bmy10_fac2
#         END IF
#         IF NOT cl_null(b_bmy.bmy21) THEN LET g_bmb.bmb15 =b_bmy.bmy21 END IF 
#         IF NOT cl_null(b_bmy.bmy23) THEN LET g_bmb.bmb28 =b_bmy.bmy23 END IF
#         IF cl_null(g_bmb.bmb28) THEN LET g_bmb.bmb28 =0 END IF
#         IF NOT cl_null(b_bmy.bmy34) THEN LET g_bmb.bmb31 =b_bmy.bmy34 END IF 
#         #Add No:TQC-AC0300
#         IF cl_null(g_bmb.bmb081) THEN
#            LET g_bmb.bmb081 = 0
#         END IF
#         IF cl_null(g_bmb.bmb082) THEN
#            LET g_bmb.bmb082 = 1
#         END IF
#         #End Add No:TQC-AC0300
#       
#         INSERT INTO bmb_file VALUES (g_bmb.*)
#         IF SQLCA.SQLERRD[3]=0 OR STATUS THEN
#            LET g_showmsg = g_bmb.bmb01,' ins bmb:'
#            CALL s_errmsg('bmb01',g_bmb.bmb01,g_showmsg,STATUS,1)
#            LET g_success='N'
#         END IF                                   
#      END IF 
#      #No.FUN-A60083--end       
#   END IF 	
#   #No.FUN-A60008--end  
#END FUNCTION
# 
#FUNCTION i720_up_bmb13()
# DEFINE l_bmt06   LIKE bmt_file.bmt06,
#        s_bmb13   LIKE bmb_file.bmb13,
#        l_i       LIKE type_file.num5     #No.FUN-680096  SMALLINT
# 
#    LET s_bmb13=' '
#    LET l_i = 0
#    DECLARE up_bmb13_cs CURSOR FOR
#     SELECT bmt06 FROM bmt_file
#      WHERE bmt01=g_bmb.bmb01 AND bmt02=g_bmb.bmb02
#        AND bmt03=g_bmb.bmb03 AND bmt04=g_bmb.bmb04
#        AND bmt08=g_bmb.bmb29 #FUN-550014 add
#    FOREACH up_bmb13_cs INTO l_bmt06
#     IF SQLCA.sqlcode THEN
#        LET g_showmsg = g_bmb.bmb01,' FOREACH up_bmb13_cs'                  
#        CALL s_errmsg('bmb01','',g_showmsg,SQLCA.SQLCODE,1)
#        EXIT FOREACH
#     END IF
#     IF l_i = 0 THEN
#        LET s_bmb13=l_bmt06
#     ELSE
#        LET s_bmb13= s_bmb13 CLIPPED , ',', l_bmt06
#     END IF
#     LET l_i = l_i + 1
#    END FOREACH
#    UPDATE bmb_file SET bmb13 = s_bmb13
#     WHERE bmb01=g_bmb.bmb01 AND bmb02=g_bmb.bmb02
#       AND bmb03=g_bmb.bmb03 AND bmb04=g_bmb.bmb04
#       AND bmb29=g_bmb.bmb29 #FUN-550014 add
#    IF SQLCA.sqlcode THEN
#       LET g_showmsg = g_bmb.bmb01,' update bmb13'                  
#       CALL s_errmsg('bmb01','',g_showmsg,SQLCA.SQLCODE,1)
#    END IF
#END FUNCTION
# 
#FUNCTION i720_s4()      #bugno:6845 add
#   DEFINE l_bmt		RECORD LIKE bmt_file.*
#   DEFINE l_ima151      LIKE ima_file.ima151   #NO.FUN-850017
#   DEFINE l_bmb06       LIKE bmb_file.bmb06    #No:MOD-A10114 add
#   DEFINE l_bmb07       LIKE bmb_file.bmb07    #No:MOD-A10114 add
#   DEFINE l_cnt         LIKE type_file.num5    #CHI-A50018 add
#   DEFINE l_bmc		RECORD LIKE bmc_file.* #CHI-A70013 add
#
##舊料做失效
#   UPDATE bmb_file SET bmb05=g_bmx.bmx07,
#                     # bmb24=g_bmx.bmx01,#No:7840
#                       bmb30=b_bmy.bmy30,             #NO.FUN-810014
#                       bmbmodu=g_user,
#                       bmbdate=g_today
#    WHERE bmb01 = g_bmb.bmb01 AND bmb02=g_bmb.bmb02 AND bmb03=g_bmb.bmb03 AND bmb04=g_bmb.bmb04 AND bmb29=g_bmb.bmb29
#   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
#      LET g_showmsg = g_bmx.bmx01,' update bmb_file:'                  
#      CALL s_errmsg('bmb01','',g_showmsg,SQLCA.SQLCODE,1)
#      LET g_success='N'
#   END IF
#   LET g_bmy05_t=b_bmy.bmy05
# 
#  #-----------------No:MOD-A10114 add
#   LET l_bmb06 = 1
#   LET l_bmb07 = 1
#   SELECT bmb06,bmb07 INTO l_bmb06,l_bmb07 FROM bmb_file WHERE bmb01=g_bmb.bmb01
#                                                           AND bmb29 = g_bmb.bmb29
#   IF cl_null(l_bmb06) THEN LET l_bmb06 = 1 END IF 
#   IF cl_null(l_bmb07) THEN LET l_bmb07 = 1 END IF 
#  #-----------------No:MOD-A10114 end
##新增新料,取替代default '1'
#   INITIALIZE g_bmb.* TO NULL
#   LET g_bmb.bmb01 =b_bmy.bmy14
# 
#   LET g_bmb.bmb29 = b_bmy.bmy29  #FUN-550014 add
#   LET g_bmb.bmb30 = b_bmy.bmy30  #FUN-550014 add
#   SELECT MAX(bmb02) INTO g_bmb.bmb02 FROM bmb_file WHERE bmb01=g_bmb.bmb01
#                                                      AND bmb29 = g_bmb.bmb29  #FUN-550014 add
#   IF g_bmb.bmb02 IS NULL THEN LET g_bmb.bmb02 = 0 END IF
#   LET g_bmb.bmb02=g_bmb.bmb02+g_sma.sma19
#   IF cl_null(g_bmb.bmb02) THEN
#      LET g_bmb.bmb02 = g_last_seq
#   END IF
# 
#   IF b_bmy.bmy03 ='5' THEN
#      LET g_bmb.bmb03 =b_bmy.bmy05
#   ELSE
#      LET g_bmb.bmb03 =b_bmy.bmy27
#   END IF
#   LET g_bmb.bmb04 =g_bmx.bmx07
#  #--------------No:MOD-A10114 modify
#   IF b_bmy.bmy03 = '5' THEN
#      LET g_bmb.bmb06 =l_bmb06
#      LET g_bmb.bmb07 =l_bmb07
#   ELSE
#     #str CHI-A30011 mod
#     #LET g_bmb.bmb06 =b_bmy.bmy06
#     #LET g_bmb.bmb07 =b_bmy.bmy07
#      IF NOT cl_null(b_bmy.bmy06) THEN
#         LET g_bmb.bmb06 =b_bmy.bmy06 
#      ELSE 
#         LET g_bmb.bmb06 =l_bmb06
#      END IF
#      IF NOT cl_null(b_bmy.bmy07) THEN
#         LET g_bmb.bmb07 =b_bmy.bmy07 
#      ELSE 
#         LET g_bmb.bmb07 =l_bmb07
#      END IF
#     #end CHI-A30011 mod
#   END IF
#  #--------------No:MOD-A10114 end
#   LET g_bmb.bmb06 =b_bmy.bmy06
#   LET g_bmb.bmb07 =b_bmy.bmy07
#   LET g_bmb.bmb16 =b_bmy.bmy16
#   LET g_bmb.bmb24 =g_bmx.bmx01
#   LET g_bmb.bmb25 =b_bmy.bmy25
#   LET g_bmb.bmb26 =b_bmy.bmy26
#   LET g_bmb.bmb13 =b_bmy.bmy13
#   LET g_bmb.bmb18 =b_bmy.bmy18
#   LET g_bmb.bmb08 =b_bmy.bmy08
#   LET g_bmb.bmb081=b_bmy.bmy081  #Add No:TQC-AC0300
#   LET g_bmb.bmb082=b_bmy.bmy082  #Add No:TQC-AC0300
#   LET g_bmb.bmb11 =b_bmy.bmy11
#   LET g_bmb.bmb09 =b_bmy.bmy09
#   LET g_bmb.bmb10 =b_bmy.bmy10
#   LET g_bmb.bmb10_fac =b_bmy.bmy10_fac
#   SELECT ima105 INTO g_bmb.bmb27 FROM ima_file    #No.MOD-940061 add
#    WHERE ima01=g_bmb.bmb03
#   LET g_bmb.bmb10_fac2=b_bmy.bmy10_fac2
#  #LET g_bmb.bmb14 =0 #CHI-A60028 mark
#   LET g_bmb.bmb14 =b_bmy.bmy35 #CHI-A60028 add
#   LET g_bmb.bmb15 = b_bmy.bmy21        #bugno:6845 add
#   LET g_bmb.bmb17 ='N'
#   LET g_bmb.bmb19 ='1'
#   IF NOT cl_null(b_bmy.bmy20) THEN LET g_bmb.bmb19 =b_bmy.bmy20 END IF  #No.MOD-710092 modify
#   LET g_bmb.bmb28 = b_bmy.bmy23        #bugno:6845 add
#   IF cl_null(g_bmb.bmb28) THEN
#      LET g_bmb.bmb28 =0
#   END IF
# 
#   IF cl_null(g_bmb.bmb02)  THEN
#      LET g_bmb.bmb02=' '
#   END IF
#   IF cl_null(g_bmb.bmb08) THEN
#      LET g_bmb.bmb08 = 0
#   END IF
#   #Add No:TQC-AC0300
#   IF cl_null(g_bmb.bmb081) THEN
#      LET g_bmb.bmb081 = 0
#   END IF
#   IF cl_null(g_bmb.bmb082) THEN
#      LET g_bmb.bmb082 = 1
#   END IF
#   #End Add No:TQC-AC0300
#   IF cl_null(g_bmb.bmb15) THEN
#      SELECT ima70 INTO g_bmb.bmb15 FROM ima_file
#       WHERE ima01 = g_bmb.bmb03 
#   END IF
#   LET g_bmb.bmb33 = 0              #NO.FUN-840033 add
#   LET g_bmb.bmb31 = b_bmy.bmy34    #no.MOD-840478
#    SELECT ima151 INTO l_ima151  FROM ima_file,bmy_file  WHERE bmy14 = ima01 AND bmy14 = b_bmy.bmy14
#                                                           AND bmy01 = g_bmx.bmx01 AND bmy02 = b_bmy.bmy02
#
#    IF l_ima151 = 'Y' THEN
#      UPDATE bmy_file SET bmy33= g_bmb.bmb02
#                    WHERE bmy01 = g_bmx.bmx01
#                      AND bmy02 = b_bmy.bmy02
#                      AND bmy14 = b_bmy.bmy14
#     IF SQLCA.sqlcode THEN
#      LET g_showmsg = g_bmx.bmx01,' update bmy_file:'                    
#      CALL s_errmsg('bmy33','',g_showmsg,SQLCA.SQLCODE,1)
#      LET g_success='N'
#     END IF
#    ELSE
#     LET g_bmb.bmb33 = b_bmy.bmy33
#    END IF
# 
#   INSERT INTO bmb_file VALUES(g_bmb.*)
#   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#      LET g_showmsg = g_bmb.bmb01,' insert into bmb_file:'                  
#      CALL s_errmsg('bmb01','',g_showmsg,SQLCA.SQLCODE,1)
#      LET g_success='N'
#   END IF
# 
#   IF g_sma.sma845='Y' THEN  #低階碼可否部份重計
#      CALL s_uima146(g_bmb.bmb03)
#      CALL cl_msg("")                              #FUN-640241
#   END IF
# 
#   DECLARE i720_s4_c2 CURSOR FOR
#        SELECT * FROM bmw_file
#         WHERE bmw01=g_bmx.bmx01 AND bmw02=b_bmy.bmy02
#   FOREACH i720_s4_c2 INTO b_bmw.*
#      LET l_bmt.bmt01=g_bmb.bmb01
#      LET l_bmt.bmt02=g_bmb.bmb02
#      LET l_bmt.bmt03=g_bmb.bmb03
#      LET l_bmt.bmt04=g_bmb.bmb04
#      LET l_bmt.bmt05=b_bmw.bmw03
#      LET l_bmt.bmt06=b_bmw.bmw04
#      LET l_bmt.bmt07=b_bmw.bmw05
#      LET l_bmt.bmt08=g_bmb.bmb29 #FUN-550014
#      IF cl_null(l_bmt.bmt02) THEN
#         LET l_bmt.bmt02=0
#      END IF
#      INSERT INTO bmt_file VALUES(l_bmt.*)
#      IF STATUS THEN
#         LET g_showmsg = l_bmt.bmt01,' s4_ins bmt:'                  
#         CALL s_errmsg('bmt01','',g_showmsg,SQLCA.SQLCODE,1)
#         LET g_success='N'
#      END IF
#      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#         LET g_showmsg = l_bmt.bmt01,' s4_ins bmt:'                  
#         CALL s_errmsg('bmt01','',g_showmsg,SQLCA.SQLCODE,1)
#         LET g_success='N'
#      END IF
#   END FOREACH
#
#   #CHI-A50018 add --start--
#   LET g_cnt=0
#   SELECT COUNT(*) INTO g_cnt FROM bmw_file
#     WHERE bmw01=g_bmx.bmx01 AND bmw02=b_bmy.bmy02
#   IF g_cnt=0 THEN
#     DECLARE i720_s4_c21 CURSOR FOR
#      SELECT * FROM bmt_file
#       WHERE bmt01=b_bmy.bmy14
#         AND bmt03=b_bmy.bmy05
#         AND bmt04 IN (SELECT MAX(bmt04) FROM bmt_file
#                        WHERE bmt01=b_bmy.bmy14
#                          AND bmt03=b_bmy.bmy05
#                      )
#     LET l_cnt=0
#     FOREACH i720_s4_c21 INTO l_bmt.*
#        LET l_cnt=l_cnt+1
#        IF l_cnt=1 THEN
#           LET g_sql=cl_getmsg('abm-040',g_lang)
#           IF NOT cl_prompt(0,0,g_sql) THEN EXIT FOREACH END IF
#        END IF
#        DISPLAY g_bmb.bmb02
#        DISPLAY l_bmt.bmt02
#        LET l_bmt.bmt02=g_bmb.bmb02
#        DISPLAY g_bmb.bmb02
#        DISPLAY l_bmt.bmt02
#        LET l_bmt.bmt03=g_bmb.bmb03
#        LET l_bmt.bmt04=g_bmb.bmb04
#        INSERT INTO bmt_file VALUES(l_bmt.*)
#        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#           LET g_showmsg = l_bmt.bmt01,' s4_c21 ins bmt:'
#           CALL s_errmsg('bmt01',l_bmt.bmt01,g_showmsg,SQLCA.SQLCODE,1)
#           LET g_success='N'
#        END IF
#     END FOREACH
#   END IF
#   #CHI-A50018 add --end--
#
##----- 取代�替代產品結構明細資料檔(bmd_file)複製 add in 03/03/10 ------------
#   IF NOT cl_null(g_bmy05_t) AND b_bmy.bmy16 <> '0' THEN
#      INITIALIZE g_bmd.* TO NULL
#      IF b_bmy.bmy03 = '4' THEN   #CHI-960004
#         LET g_bmd.bmd01=b_bmy.bmy27 #CHI-960004
#         LET g_bmd.bmd02='1'
#         LET g_bmd.bmd07 = 1      #No:MOD-A10114 add
#      END IF                      #CHI-960004
#      IF b_bmy.bmy03 = '5' THEN   #CHI-960004
#         LET g_bmd.bmd01=b_bmy.bmy05 #CHI-960004
#         LET g_bmd.bmd02='2'      #CHI-960004
#         LET g_bmd.bmd07 = b_bmy.bmy06 / b_bmy.bmy07   #No:MOD-A10114 add
#      END IF                      #CHI-960004
#      IF b_bmy.bmy03 = '5' THEN
#         SELECT max(bmd03)+1 INTO g_bmd.bmd03
#           FROM bmd_file
#          WHERE bmd01 = b_bmy.bmy05
#            AND bmd02 = '2'
#            AND bmd08 = b_bmy.bmy14
#         IF cl_null(g_bmd.bmd03) THEN
#            LET g_bmd.bmd03=1
#         END IF
#       ELSE
#         LET g_bmd.bmd03 = 1
#       END IF
#      IF b_bmy.bmy03 = '4' THEN      #CHI-960004
#         LET g_bmd.bmd04=g_bmy05_t
#      ELSE                           #CHI-960004
#         LET g_bmd.bmd04=b_bmy.bmy27 #CHI-960004
#      END IF                         #CHI-960004
#      LET g_bmd.bmd05=g_bmx.bmx07
#     #LET g_bmd.bmd07=1              #No:MOD-A10114 mark
#      LET g_bmd.bmd08=b_bmy.bmy14
#      LET g_bmd.bmduser = g_user
#      LET g_bmd.bmdgrup = g_grup
#      LET g_bmd.bmddate = g_today
#      LET g_bmd.bmdacti = 'Y'
#      LET g_bmd.bmdoriu = g_user      #No.FUN-980030 10/01/04
#      LET g_bmd.bmdorig = g_grup      #No.FUN-980030 10/01/04
#      INSERT INTO bmd_file VALUES(g_bmd.*)
#      IF SQLCA.SQLCODE THEN
#         LET g_showmsg = g_bmd.bmd01,' s4_ins bmd_file:'                  
#         CALL s_errmsg('bmd01','',g_showmsg,SQLCA.SQLCODE,1)
#         LET g_success='N'
#      END IF
#      LET g_bmy05_t=NULL
#   END IF
#   CALL i720_up_bmb13()
#
#   #CHI-A70013 add --start--
#   #----- 說明檔(bmc_file)複製 ------------
#   SELECT COUNT(*) INTO g_cnt FROM bmf_file
#    WHERE bmf01=g_bmx.bmx01 AND bmf02=b_bmy.bmy02
#   IF g_cnt>0 THEN 	# 有輸入才更新
#      DECLARE i720_s4_c3 CURSOR FOR
#       SELECT * FROM bmf_file
#        WHERE bmf01=g_bmx.bmx01 AND bmf02=b_bmy.bmy02
#
#      FOREACH i720_s4_c3 INTO b_bmf.*
#          LET l_bmc.bmc01=g_bmb.bmb01
#          LET l_bmc.bmc02=g_bmb.bmb02
#          LET l_bmc.bmc021=g_bmb.bmb03
#          LET l_bmc.bmc03=g_bmb.bmb04
#          LET l_bmc.bmc04=b_bmf.bmf03
#          LET l_bmc.bmc05=b_bmf.bmf04
#          LET l_bmc.bmc06=g_bmb.bmb29
#          INSERT INTO bmc_file VALUES(l_bmc.*)
#          IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#             LET g_showmsg = l_bmt.bmt01,' s4_ins bmc:'
#             CALL s_errmsg('bmc01',l_bmc.bmc01,g_showmsg,SQLCA.SQLCODE,1)
#             LET g_success='N'
#          END IF
#      END FOREACH
#   END IF
#   #CHI-A70013 add --end--
#
#END FUNCTION
#FUN-AC0060--mark---end---
 
FUNCTION i720_t()
   DEFINE i	LIKE type_file.num5          #No.FUN-680096 SMALLINT
   DEFINE l_s_bmw05       LIKE bmw_file.bmw05  #NO.FUN-870127
   DEFINE l_n    LIKE type_file.num5    #No.FUN-880021
   
  IF g_flag = 'Y'  THEN         #MOD-910205 add
 
  #FUN-B80071 add str---
   IF g_bmx.bmx09 matches '[Ss]' THEN      
      CALL cl_err('','apm-030',0)
      RETURN
   END IF
  #FUN-B80071 add end---
    SELECT COUNT(*) INTO l_n FROM bmx_file,bmy_file
     WHERE bmx01 = bmy01 
       AND bmx01 = g_bmx.bmx01 
     
   IF l_n = 0  THEN 
     IF g_bmx.bmx04 = 'Y'  THEN  
       CALL cl_err('','abm-520',0)
       RETURN  
     ELSE 
     	 LET l_ac = 1
     END IF 	  
   END IF   
   
   OPEN WINDOW i720_t_w WITH FORM "abm/42f/abmi710c"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("abmi710c")
 
   IF STATUS THEN CALL cl_err('open win:',STATUS,1) RETURN END IF
   CALL i720_t_fill()
   LET g_success='Y'
   
   IF g_bmx.bmx04 <> 'Y' THEN
      CALL i720_t_i()
   ELSE 
   	 CALL cl_err('','abm-521',0) 
   	 DISPLAY ARRAY g_bmw TO s_bmw.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
   	 
   	  BEFORE DISPLAY
        CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
        CALL cl_show_fld_cont() 
      
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
         
      ON ACTION cancel
         LET INT_FLAG=FALSE 	
         LET g_action_choice="exit"
         EXIT DISPLAY   
         
     END DISPLAY   
   END IF
  ELSE 
     CALL i720_t_fill()  
     RETURN      #No.MOD-950076 add
  END IF   
   
   DELETE FROM bmw_file
         WHERE bmw01=g_bmx.bmx01 AND bmw02=g_bmy[l_ac].bmy02
   IF SQLCA.SQLCODE THEN
      CALL cl_err3("del","bmw_file",g_bmx.bmx01,g_bmy[l_ac].bmy02,SQLCA.SQLCODE,"","del bmw: ",1)# TQC-660046
      LET g_success='N'
   END IF
       LET l_s_bmw05 =0  #No.FUN-870127
       FOR i=1 TO g_bmw.getLength()  #MOD-490449
          IF g_bmw[i].bmw04 IS NULL OR g_bmw[i].bmw05 IS NULL OR
             g_bmw[i].bmw05 = 0 THEN CONTINUE FOR
          END IF
          LET b_bmw.bmw01=g_bmx.bmx01
          LET b_bmw.bmw02=g_bmy[l_ac].bmy02
          LET b_bmw.bmw03=i
          LET b_bmw.bmw04=g_bmw[i].bmw04
          LET b_bmw.bmw05=g_bmw[i].bmw05
 
          LET b_bmw.bmwplant = g_plant 
          LET b_bmw.bmwlegal = g_legal 
 
          LET l_s_bmw05 = l_s_bmw05+ g_bmw[i].bmw05      #NO.FUN-870127
          INSERT INTO bmw_file VALUES(b_bmw.*)
       END FOR
       IF s_industry('slk') THEN    #No:MOD-A10114 add
          UPDATE bmy_file SET bmy06 = l_s_bmw05 * g_bmy[l_ac].bmy07    # by ve007
                        WHERE bmy01 = g_bmx.bmx01
                          AND bmy02 = g_bmy[l_ac].bmy02
          IF SQLCA.SQLCODE  THEN
             CALL cl_err3("upd","bmy_file",g_bmx.bmx01,"",SQLCA.sqlcode,"","",1) 
          END IF
          LET g_bmy[l_ac].bmy06 = l_s_bmw05  *  g_bmy[l_ac].bmy07    # by ve007
          DISPLAY BY NAME g_bmy[l_ac].bmy06
       END IF     #No:MOD-A10114 add
       LET g_bmy_t.bmy06 = g_bmy[l_ac].bmy06  #TQC-C40119 add
 
   CLOSE WINDOW i720_t_w
END FUNCTION
 
FUNCTION i720_t_i()
   DEFINE l_n		  LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          m_ac_t          LIKE type_file.num5,    #MOD-860323 modify chr1,    #No.FUN-680096 SMALLINT,     #未取消的ARRAY CNT
          l_lock_sw       LIKE type_file.chr1,    #單身鎖住否    #No.FUN-680096 VARCHAR(1)
          m_ac,m_sl	  LIKE type_file.num5,    #MOD-860323 modify chr1,    #No.FUN-680096 SMALLINT,
          l_allow_insert  LIKE type_file.num5,    #可新增否      #No.FUN-680096 SMALLINT
          l_allow_delete  LIKE type_file.num5     #可刪除否      #No.FUN-680096 SMALLINT
    DEFINE l_exit_while   LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)      #MOD-4B0191
    DEFINE l_amt          LIKE bmw_file.bmw05     #CHI-C10023 add
 
      LET l_allow_insert = cl_detail_input_auth("insert")
      LET l_allow_delete = cl_detail_input_auth("delete")
  SELECT ima147 INTO g_ima147 FROM ima_file WHERE ima01=g_bmy[l_ac].bmy05 AND imaacti = 'Y'   #MOD-BC0045 add 
  WHILE TRUE #MOD-4B0191 ADD (WHILE.....END WHILE)
 
      INPUT ARRAY g_bmw WITHOUT DEFAULTS FROM s_bmw.*
            ATTRIBUTE(COUNT=g_rec_t,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
         BEFORE INPUT
             CALL fgl_set_arr_curr(m_ac)
             LET g_success = 'Y'    #No.FUN-880021
             
         BEFORE ROW
            LET l_exit_while = 'Y'          #MOD-4B0191
            LET m_ac=ARR_CURR()
            LET g_bmw_t.* = g_bmw[m_ac].*  #BACKUP
            IF g_bmw[m_ac].bmw04 IS NULL THEN
               LET g_bmw[m_ac].bmw05 = NULL
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
 
         AFTER ROW
             LET m_ac = ARR_CURR()
             LET m_ac_t = m_ac
           #-------MOD-BC0045 mark -------
           # IF INT_FLAG THEN
           #    CALL cl_err('',9001,0)
           #    LET INT_FLAG = 0
           #    LET g_bmw[m_ac].* = g_bmw_t.*
           #    EXIT INPUT
           # END IF
           #-------MOD-BC0045 mark -------
             CALL i720_t_cnt()
             LET g_bmw_t.* = g_bmw[m_ac].*
 
         AFTER INPUT
           #-------MOD-BC0045 mark -------
           #IF INT_FLAG THEN
           #    CALL cl_err('',9001,0)
           #    LET INT_FLAG = 0
           #    EXIT INPUT
           #END IF
           #-------MOD-BC0045 mark -------
            CALL i720_t_cnt()
           IF g_cnt1>0  THEN     #MOD-BC0045 add
           #CHI-C10023 str -----
           # IF g_ima147='Y' AND   #MOD-490449
           #    g_cnt1<>g_bmy[l_ac].bmy06/g_bmy[l_ac].bmy07 THEN #No.FUN-870127  
            IF g_ima147='Y' THEN
               IF g_bmy[l_ac].bmy03<>5 AND NOT (cl_null(g_bmy[l_ac].bmy06) OR cl_null(g_bmy[l_ac].bmy07)) THEN
                  LET l_amt = g_bmy[l_ac].bmy06/g_bmy[l_ac].bmy07
               ELSE
                  SELECT bmb06/bmb07 INTO l_amt FROM bmb_file
                   WHERE bmb01=g_bmy[l_ac].bmy14 AND bmb03=g_bmy[l_ac].bmy05
               END IF

               IF g_cnt1<>l_amt THEN
           #CHI-C10023 end add-----
                  LET l_exit_while = 'N'      #MOD-4B0191
                  CALL cl_err('','abm-010',1) #MOD-4B0191
                  NEXT FIELD bmw04
               END IF                        #CHI-C10023 add
            END IF
          END IF                #MOD-BC0045 add
 
         ON ACTION get_org_ins_loc
            CALL i720_g_bmw()
            CALL i720_t_cnt()
            EXIT INPUT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
 
         ON ACTION controls                      #No.FUN-6B0033
            CALL cl_set_head_visible("","AUTO")  #No.FUN-6B0033
 
      END INPUT
 
      #IF INT_FLAG THEN                                                                                           #MOD-BC0045 mark
      IF INT_FLAG AND (g_bmw.getLength()=0 OR (g_ima147='Y' AND g_cnt1=g_bmy[l_ac].bmy06/g_bmy[l_ac].bmy07))THEN  #MOD-BC0045 add
          LET INT_FLAG=0
          LET g_success='N'
          EXIT WHILE #MOD-4B0191
      END IF
   IF l_exit_while = 'N' THEN
       CONTINUE WHILE
   END IF
   EXIT WHILE
 END WHILE
END FUNCTION
 
FUNCTION i720_t_cnt()
   DEFINE i    LIKE type_file.num10    #TQC-720042 mod #No.FUN-680096  INTEGER
   DEFINE j    LIKE type_file.num5     #TQC-6C0061 add
 
   LET g_cnt1= 0   #NO.FUN-870127
   LET j = g_bmw.getLength()             
   IF cl_null(j) THEN LET j = 0 END IF
   IF j > 0 THEN  
      FOR i=1 TO g_bmw.getLength()
         IF g_bmw[i].bmw04 IS NULL OR g_bmw[i].bmw05 IS NULL OR
            g_bmw[i].bmw05 = 0 THEN CONTINUE FOR
         END IF
         LET g_cnt1 = g_cnt1 + g_bmw[i].bmw05  #No.FUN-870127
      END FOR
   END IF          #TQC-6C0061 add
   DISPLAY g_cnt1 TO tot  #No.FUN-870127
END FUNCTION
 
FUNCTION i720_g_bmw()
   DEFINE l_bmy		RECORD LIKE bmy_file.*
   DEFINE l_bmb		RECORD LIKE bmb_file.*
   DEFINE l_bmt		RECORD LIKE bmt_file.*
 
   CALL g_bmw.clear()
   INITIALIZE l_bmy.* TO NULL     #No.MOD-840100 add
   IF g_bmy[l_ac].bmy03='2'			# 找出之前一筆的失效資料
      THEN SELECT * INTO l_bmy.* FROM bmy_file
            WHERE bmy01 = g_bmx.bmx01
              AND bmy02 = (SELECT MAX(bmy02) FROM bmy_file
                           WHERE bmy01=g_bmx.bmx01
                             AND bmy02<g_bmy[l_ac].bmy02)
              AND bmy03 IN ('0','1')
      ELSE SELECT * INTO l_bmy.* FROM bmy_file
            WHERE bmy01 = g_bmx.bmx01
              AND bmy02 = g_bmy[l_ac].bmy02
   END IF
   IF cl_null(l_bmy.bmy05) THEN LET l_bmy.bmy05 = g_bmy[l_ac].bmy05 END IF  #No.MOD-840100 add
   IF l_bmy.bmy04 IS NOT NULL
      THEN SELECT * INTO l_bmb.* FROM bmb_file
            WHERE bmb01 = g_bmy[l_ac].bmy14
              AND bmb29 = g_bmy[l_ac].bmy29  #FUN-550014 add
              AND bmb02 = l_bmy.bmy04
              AND bmb03 = l_bmy.bmy05
              AND bmb04 = (SELECT MAX(bmb04) FROM bmb_file
                            WHERE bmb01 = g_bmy[l_ac].bmy14
                              AND bmb29 = g_bmy[l_ac].bmy29  #FUN-550014 add
                              AND bmb02 = l_bmy.bmy04
                              AND bmb03 = l_bmy.bmy05)
      ELSE SELECT * INTO l_bmb.* FROM bmb_file
            WHERE bmb01 = g_bmy[l_ac].bmy14
              AND bmb29 = g_bmy[l_ac].bmy29  #FUN-550014 add
              AND bmb03 = l_bmy.bmy05
              AND bmb04 = (SELECT MAX(bmb04) FROM bmb_file
                            WHERE bmb01 = g_bmy[l_ac].bmy14
                              AND bmb29 = g_bmy[l_ac].bmy29  #FUN-550014 add
                              AND bmb03 = l_bmy.bmy05)
   END IF
   DECLARE i720_g_bmw_c CURSOR FOR
           SELECT bmt06,bmt07 FROM bmt_file
             WHERE bmt01=l_bmb.bmb01
               AND bmt02=l_bmb.bmb02
               AND bmt03=l_bmb.bmb03
               AND bmt04=l_bmb.bmb04
               AND bmt08=l_bmb.bmb29   #FUN-550014 add
             ORDER BY bmt06
   LET g_rec_t=1
   FOREACH i720_g_bmw_c INTO g_bmw[g_rec_t].*
     IF STATUS THEN CALL cl_err('for bmb:',STATUS,1) EXIT FOREACH END IF
     LET g_rec_t=g_rec_t+1
   END FOREACH
   LET g_rec_t=g_rec_t - 1
   CALL i720_t_i()
END FUNCTION
 
FUNCTION i720_t_fill()
   CALL g_bmw.clear()
   DECLARE i720_t_c CURSOR FOR
        SELECT bmw04,bmw05 FROM bmw_file
         WHERE bmw01=g_bmx.bmx01 AND bmw02=g_bmy[l_ac].bmy02
         ORDER BY bmw04
   LET g_rec_t=1
   FOREACH i720_t_c INTO g_bmw[g_rec_t].*
     LET g_rec_t=g_rec_t+1
   END FOREACH
   IF g_rec_t = 1 AND
      NOT (cl_null(g_bmy[l_ac].bmy04) AND cl_null(g_bmy[l_ac].bmy14))THEN
      DECLARE i720_t_c2 CURSOR FOR
        SELECT bmt06,bmt07 FROM bmt_file
         WHERE bmt01 = g_bmy[l_ac].bmy14
           AND bmt02 = g_bmy[l_ac].bmy04
           AND bmt08 = g_bmy[l_ac].bmy29  #FUN-550014 add
           #FUN-AC0060---add---str---
           #PLM:抓生效日期最大的
           AND bmt04 IN (
                         SELECT MAX(bmt04) 
                           FROM bmt_file
                          WHERE bmt01 = g_bmy[l_ac].bmy14
                            AND bmt02 = g_bmy[l_ac].bmy04
                            AND bmt08 = g_bmy[l_ac].bmy29 )
           #FUN-AC0060---add---end---
         ORDER BY bmt04
      FOREACH i720_t_c2 INTO g_bmw[g_rec_t].*
        LET g_rec_t=g_rec_t+1
      END FOREACH
   END IF
   LET g_rec_t = g_rec_t - 1
   CALL i720_t_cnt()
END FUNCTION

#CHI-A70013 add --start--
FUNCTION i720_e()
   DEFINE i	     LIKE type_file.num5
   DEFINE l_bmf03    LIKE bmf_file.bmf03
   DEFINE ls_tmp     STRING
 
   OPEN WINDOW i720_e_w WITH FORM "abm/42f/abmi710e"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("abmi710e")
 
   IF STATUS THEN CALL cl_err('open win:',STATUS,1) RETURN END IF

   CALL i720_e_fill()

   LET g_success='Y'
   CALL i720_e_i()

   CLOSE WINDOW i720_e_w

END FUNCTION

FUNCTION i720_e_i()
   DEFINE l_n              LIKE type_file.num5
   DEFINE i,s              LIKE type_file.num5,
          p_cmd            LIKE type_file.chr1,     #處理狀態
          l_allow_insert   LIKE type_file.num5,     #可新增否
          l_allow_delete   LIKE type_file.num5      #可刪除否

   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
   IF g_rec_e <> 0 THEN
        LET i = 1
   END IF

   INPUT ARRAY g_bmf WITHOUT DEFAULTS FROM s_bmf.*
          ATTRIBUTE(COUNT=g_rec_e,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

         BEFORE INPUT
              IF g_rec_e != 0 THEN
                 CALL fgl_set_arr_curr(i)
             END IF

          BEFORE ROW 
            LET p_cmd = ''
            LET i=ARR_CURR()
            IF g_rec_e >= i THEN
                LET p_cmd='u'
                LET g_bmf_t.* = g_bmf[i].*
            END IF
            CALL cl_show_fld_cont()

         BEFORE INSERT
            LET p_cmd='a'
            LET l_n = ARR_COUNT()
            INITIALIZE g_bmf[i].* TO NULL
            LET g_bmf_t.* = g_bmf[i].*         #新輸入資料
            CALL cl_show_fld_cont() 
            NEXT FIELD bmf03

         AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
                CANCEL INSERT
            END IF
            LET b_bmf.bmf01=g_bmx.bmx01
            LET b_bmf.bmf02=g_bmy[l_ac].bmy02
            LET b_bmf.bmf03=g_bmf[i].bmf03
            LET b_bmf.bmf04=g_bmf[i].bmf04
            LET b_bmf.bmfplant = g_plant    
            LET b_bmf.bmflegal = g_legal
            IF cl_null(g_bmf_t.bmf03) THEN
               INSERT INTO bmf_file VALUES(b_bmf.*)
               IF SQLCA.SQLCODE OR STATUS THEN
                  CALL cl_err3("ins","bmf_file",b_bmf.bmf01,"",SQLCA.SQLCODE,"","ins bmf:",1)
                  LET g_success='N'
                   CANCEL INSERT 
               ELSE
                   LET g_rec_e=g_rec_e+1
                  MESSAGE 'Insert ok!'
               END IF
            END IF

         BEFORE FIELD  bmf03
            IF g_bmf[i].bmf03 IS NULL THEN
               SELECT MAX(bmf03) + 1
                 INTO g_bmf[i].bmf03
                 FROM bmf_file
                WHERE bmf01=g_bmx.bmx01
                  AND bmf02=g_bmy[l_ac].bmy02
               IF cl_null(g_bmf[i].bmf03) THEN LET g_bmf[i].bmf03=1 END IF
            END IF

         AFTER FIELD bmf03
            IF NOT cl_null(g_bmf[i].bmf03) THEN
               IF g_bmf[i].bmf03 != g_bmf_t.bmf03 OR cl_null(g_bmf_t.bmf03) THEN
                  SELECT COUNT(*) INTO g_cnt FROM bmf_file
                   WHERE bmf01 = g_bmx.bmx01
                     AND bmf02=g_bmy[l_ac].bmy02
                     AND bmf03 = g_bmf[i].bmf03
                  IF g_cnt > 0 THEN
                     CALL cl_err('',-239,0)
                     NEXT FIELD bmf03
                  END IF
               END IF
            END IF

         BEFORE DELETE
            IF g_bmf_t.bmf03 > 0 AND g_bmf_t.bmf03 IS NOT NULL THEN
               DELETE FROM bmf_file
                WHERE bmf01=g_bmx.bmx01
                  AND bmf02=g_bmy[l_ac].bmy02
                  AND bmf03=g_bmf[i].bmf03
               IF SQLCA.SQLCODE OR STATUS THEN
                  CALL cl_err3("del","bmf_file",g_bmx.bmx01,g_bmy[l_ac].bmy02,SQLCA.SQLCODE,"","del bmf: ",1)
                  CANCEL DELETE
               ELSE
                   LET g_rec_e=g_rec_e-1
                  MESSAGE 'Delete ok!'
               END IF
            END IF

        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_bmf[i].* = g_bmf_t.*
               EXIT INPUT
            END IF

            LET b_bmf.bmf01=g_bmx.bmx01
            LET b_bmf.bmf02=g_bmy[l_ac].bmy02
            LET b_bmf.bmf03=g_bmf[i].bmf03
            LET b_bmf.bmf04=g_bmf[i].bmf04
            UPDATE bmf_file SET * = b_bmf.*
             WHERE bmf01=g_bmx.bmx01
               AND bmf02=g_bmy[l_ac].bmy02
               AND bmf03=g_bmf_t.bmf03

            IF SQLCA.SQLCODE OR STATUS THEN
               CALL cl_err3("upd","bmf_file",g_bmx.bmx01,g_bmf_t.bmf03,SQLCA.SQLCODE,"","upd bmf: ",1)
                LET g_bmf[i].* = g_bmf_t.* 
               LET g_success='N'
            END IF

         AFTER ROW
             LET i = ARR_CURR()
             IF INT_FLAG THEN
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
                 IF p_cmd = 'u' THEN 
                    LET g_bmf[i].* = g_bmf_t.*
                END IF
                EXIT INPUT
             END IF

         AFTER INPUT
            IF INT_FLAG THEN
               LET INT_FLAG=0
               EXIT INPUT
            END IF

         ON ACTION get_orginal_data
            CALL i720_g_bmf()
            #EXIT INPUT    #MOD-C30692 mark

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about
            CALL cl_about()
 
         ON ACTION help 
            CALL cl_show_help()
 
         ON ACTION controlg
            CALL cl_cmdask()
 
         ON ACTION controls                                                                       
            CALL cl_set_head_visible("","AUTO")

   END INPUT

   IF INT_FLAG THEN
      LET INT_FLAG=0
      LET g_success='N'
   END IF

END FUNCTION

FUNCTION i720_g_bmf()
   DEFINE l_bmy		RECORD LIKE bmy_file.*
   DEFINE l_bmb		RECORD LIKE bmb_file.*
   DEFINE l_bmt		RECORD LIKE bmt_file.*

   DELETE FROM bmf_file WHERE bmf01=g_bmx.bmx01 AND bmf02=g_bmy[l_ac].bmy02
   CALL g_bmf.clear()

   SELECT * INTO l_bmy.* FROM bmy_file
    WHERE bmy01 = g_bmx.bmx01
      AND bmy02 = g_bmy[l_ac].bmy02

   IF NOT cl_null(l_bmy.bmy04) THEN
      SELECT * INTO l_bmb.* FROM bmb_file
       WHERE bmb01 = l_bmy.bmy14
         AND bmb02 = l_bmy.bmy04
         AND bmb03 = l_bmy.bmy05
         AND bmb04 = (SELECT MAX(bmb04) FROM bmb_file
                       WHERE bmb01 = l_bmu.bmy14 
                         AND bmb02 = l_bmy.bmy04
                         AND bmb03 = l_bmy.bmy05)
   ELSE
      SELECT * INTO l_bmb.* FROM bmb_file
       WHERE bmb01 = l_bmy.bmy14
         AND bmb03 = l_bmy.bmy05
         AND bmb04 = (SELECT MAX(bmb04) FROM bmb_file
                       WHERE bmb01 = l_bmy.bmy14
                         AND bmb03 = l_bmy.bmy05)
   END IF

   DECLARE i720_g_bmf_c CURSOR FOR
    SELECT bmc04,bmc05 FROM bmc_file
      WHERE bmc01 = l_bmb.bmb01
        AND bmc02 = l_bmb.bmb02
        AND bmc021= l_bmb.bmb03
        AND bmc03 = l_bmb.bmb04
      ORDER BY bmc04

   LET g_rec_e=1
   FOREACH i720_g_bmf_c INTO g_bmf[g_rec_e].*
     IF STATUS THEN
        CALL cl_err('for bmb:',STATUS,1)
        EXIT FOREACH
     END IF

     LET b_bmf.bmf01=g_bmx.bmx01
     LET b_bmf.bmf02=g_bmy[l_ac].bmy02

     SELECT MAX(bmf03) + 1 INTO b_bmf.bmf03 FROM bmf_file
      WHERE bmf01=g_bmx.bmx01 AND bmf02=g_bmy[l_ac].bmy02
     IF cl_null(b_bmf.bmf03) THEN LET b_bmf.bmf03=1 END IF

     LET b_bmf.bmf04=g_bmf[g_rec_e].bmf04
     LET b_bmf.bmfplant = g_plant    
     LET b_bmf.bmflegal = g_legal
     INSERT INTO bmf_file VALUES(b_bmf.*)
     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
        CALL cl_err3("ins","bmf_file",b_bmf.bmf01,b_bmf.bmf02,SQLCA.SQLCODE,"","ins bmf: ",1)
        LET g_success='N'
        EXIT FOREACH
     END IF

      LET g_rec_e=g_rec_e+1

      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF

   END FOREACH
   LET g_rec_e=g_rec_e - 1
   CALL i720_e_fill()

END FUNCTION

FUNCTION i720_e_fill()
   CALL g_bmf.clear()

   DECLARE i720_e_c CURSOR FOR
        SELECT bmf03,bmf04 FROM bmf_file
         WHERE bmf01=g_bmx.bmx01 AND bmf02=g_bmy[l_ac].bmy02
         ORDER BY bmf03

   LET g_rec_e=1
   FOREACH i720_e_c INTO g_bmf[g_rec_e].*
     LET g_rec_e=g_rec_e+1

     IF g_rec_e > g_max_rec THEN
        CALL cl_err( '', 9035, 0 )
        EXIT FOREACH
     END IF

   END FOREACH
   CALL g_bmf.deleteElement(g_rec_e)
   LET g_rec_e=g_rec_e - 1

END FUNCTION
#CHI-A70013 add --end--
 
#FUNCTION i720_x()   #CHI-D20010
FUNCTION i720_x(p_type)    #CHI-D20010
   DEFINE l_ima02   LIKE ima_file.ima02
   DEFINE l_flag    LIKE type_file.chr1  #CHI-D20010
   DEFINE p_type    LIKE type_file.chr1  #CHI-D20010
 
   IF s_shut(0) THEN RETURN END IF
 
   SELECT * INTO g_bmx.* FROM bmx_file WHERE bmx01 = g_bmx01       #MOD-660086 add
    IF NOT s_dc_ud_flag('3',g_bmx.bmx11,g_plant,'u') THEN                                                                           
       CALL cl_err(g_bmx.bmx11,'aoo-045',1)                                                                                         
       RETURN                                                                                                                       
    END IF                                                                                                                          
   IF cl_null(g_bmx.bmx01) THEN CALL cl_err('',-400,0) RETURN END IF   #MOD-660086 add
 
   IF g_bmx.bmx09 MATCHES '[Ss1]' THEN      #FUN-550040
      CALL cl_err('','mfg3557',0)
      RETURN
   END IF

   #CHI-D20010---begin
   IF p_type = 1 THEN
      IF g_bmx.bmx04 ='X' THEN RETURN END IF
   ELSE
      IF g_bmx.bmx04 <>'X' THEN RETURN END IF
   END IF
   #CHI-D20010---end
 
   BEGIN WORK
   LET g_success='Y'
 
   OPEN i720_cl USING g_bmx01
   IF STATUS THEN
      CALL cl_err("OPEN i720_cl:", STATUS, 1)
      CLOSE i720_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i720_cl INTO g_bmx.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_bmx.bmx01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE i720_cl ROLLBACK WORK RETURN
   END IF
   IF cl_null(g_bmx.bmx01) THEN CALL cl_err('',-400,0) RETURN END IF
   #-->確認不可作廢
   IF g_bmx.bmx04 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_bmx.bmx04 = 'X' THEN  LET l_flag = 'X' ELSE LET l_flag = 'N' END IF #CHI-D20010
   
  #IF cl_void(0,0,g_bmx.bmx04)   THEN   #CHI-D20010
   IF cl_void(0,0,l_flag)   THEN        #CHI-D20010
        LET g_chr=g_bmx.bmx04
       #IF g_bmx.bmx04 ='N' THEN   #CHI-D20010
        IF p_type = 1 THEN         #CHI-D20010
            LET g_bmx.bmx04='X'
            LET g_bmx.bmx09='9'  #--FUN-540045
        ELSE
            LET g_bmx.bmx04='N'
            LET g_bmx.bmx09='0'  #--FUN-540045
        END IF
        UPDATE bmx_file
            SET bmx04=g_bmx.bmx04,
                bmx09=g_bmx.bmx09, #--FUN-540045
                bmxmodu=g_user,
                bmxdate=g_today
            WHERE bmx01  =g_bmx.bmx01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","bmx_file",g_bmx.bmx04,"",SQLCA.sqlcode,"","",1) # TQC-660046
            LET g_bmx.bmx04=g_chr
        END IF
        DISPLAY BY NAME g_bmx.bmx04,g_bmx.bmx09,
                        g_bmx.bmxmodu,g_bmx.bmxdate #--FUN-540045
 
        CALL i720_list_fill()                                                                                                       
   END IF
    CLOSE i720_cl
    COMMIT WORK
    CALL cl_flow_notify(g_bmx.bmx01,'V')
END FUNCTION
 
FUNCTION i720_g()
 DEFINE     p_cmd   LIKE type_file.chr1      #No.FUN-680096 VARCHAR(1)
 DEFINE     l_code  LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(1),
            l_cnt   LIKE type_file.num5,     #No.FUN-680096 SMALLINT
            l_msg   LIKE type_file.chr1000   #No.FUN-680096 VARCHAR(80)
 DEFINE     l_bmb   RECORD
            bma01   LIKE bma_file.bma01,
            bmb03   LIKE bmb_file.bmb03,
            bma05   LIKE bma_file.bma05
            END RECORD
 DEFINE     l_ima02   LIKE ima_file.ima02,
            l_ima02n1 LIKE ima_file.ima02,
            l_ima021n1 LIKE ima_file.ima021,
            l_ima02n2  LIKE ima_file.ima02,
            l_ima021n2 LIKE ima_file.ima021
 
   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_bmx.* FROM bmx_file WHERE bmx01 = g_bmx01
   IF cl_null(g_bmx.bmx01) THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_bmx.bmx04 = 'Y'    THEN CALL cl_err('','mfg0175',0) RETURN END IF
   IF g_bmx.bmx04 = 'X'    THEN CALL cl_err('','9024',0) RETURN END IF
 
   OPEN WINDOW i720_g_w WITH FORM "abm/42f/abmi720g"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_locale("abmi720g")

   CALL cl_set_head_visible("group01,group02","YES")    #No.FUN-6B0033
   WHILE TRUE
    INPUT BY NAME tm.a,tm.bmy05,tm.bmy27,tm.bmy06,tm.bmy07,tm.c
 
       AFTER FIELD a
          IF tm.a NOT MATCHES '[134]' OR cl_null(tm.a) THEN
             NEXT FIELD a
          END IF
          #1:失效 3:修改 4:取代
          LET tm.c = '0'
          IF tm.a != '4' THEN   #MOD-A40058 add  
             #當變更別為4時bmy06與bmy07不給預設值
             LET tm.bmy06 = 1
             LET tm.bmy07 = 1
          END IF                #MOD-A40058 add 
          DISPLAY tm.c      TO FORMONLY.c
          DISPLAY tm.bmy06  TO FORMONLY.bmy06
          DISPLAY tm.bmy07  TO FORMONLY.bmy07
 
       AFTER FIELD bmy05
          IF cl_null(tm.bmy05) THEN NEXT FIELD bmy05 END IF
          #FUN-AA0059 --------------------------------add start------------------
          IF NOT s_chk_item_no(tm.bmy05,'') THEN
             CALL cl_err('',g_errno,1)
             NEXT FIELD bmy05
          END IF 
          #FUN-AA0059 --------------------------------add end---------------------  
          SELECT ima02,ima021 INTO l_ima02n1,l_ima021n1 FROM ima_file
           WHERE ima01=tm.bmy05 AND imaacti='Y'
          IF STATUS THEN
            CALL cl_err3("sel","ima_file",tm.bmy05,"",STATUS,"","sel ima",1)# TQC-660046
          NEXT FIELD bmy05
          END IF
          DISPLAY l_ima02n1 TO FORMONLY.ima02n1
          DISPLAY l_ima021n1 TO FORMONLY.ima021n1
 
       BEFORE FIELD bmy27
          IF tm.a != '4' THEN NEXT FIELD bmy06  END IF
 
       AFTER FIELD bmy27
          IF cl_null(tm.bmy27) THEN NEXT FIELD bmy27 END IF
          #FUN-AA0059 -----------------------------add start--------------------------
          IF NOT s_chk_item_no(tm.bmy27,'') THEN
             CALL cl_err('',g_errno,1)
             NEXT FIELD bmy27
          END IF 
          #FUN-AA0059 ----------------------------add end-----------------------------
          SELECT ima02,ima021 INTO l_ima02n2,l_ima021n2 FROM ima_file
           WHERE ima01=tm.bmy27 AND imaacti='Y'
          IF STATUS THEN
            CALL cl_err3("sel","ima_file",tm.bmy27,"",STATUS,"","sel ima",1)# TQC-660046           
            NEXT FIELD bmy27
          END IF
          DISPLAY tm.c      TO FORMONLY.c
          DISPLAY l_ima02n2 TO FORMONLY.ima02n2
          DISPLAY l_ima021n2 TO FORMONLY.ima021n2
 
       AFTER FIELD bmy06
         #IF tm.a MATCHES '[34]' AND (tm.bmy06 IS NULL OR tm.bmy06=0) THEN  #MOD-A40058 mark
          IF tm.a MATCHES '[3]' AND (tm.bmy06 IS NULL OR tm.bmy06=0) THEN   #MOD-A40058 
             NEXT FIELD bmy06
          END IF
 
       AFTER FIELD c
          IF cl_null(tm.c) THEN NEXT FIELD c END IF
          IF tm.c NOT MATCHES '[0125]' THEN NEXT FIELD c END IF
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON ACTION CONTROLP
          CASE WHEN INFIELD(bmy05)
#FUN-AA0059 --Begin--
                  #  CALL cl_init_qry_var()
                  #  LET g_qryparam.form = "q_ima"
                  #  LET g_qryparam.default1 = tm.bmy05
                  #  CALL cl_create_qry() RETURNING tm.bmy05
                    CALL q_sel_ima(FALSE, "q_ima", "",tm.bmy05, "", "", "", "" ,"",'' )  RETURNING tm.bmy05
#FUN-AA0059 --End--
                    DISPLAY BY NAME tm.bmy05
                    NEXT FIELD bmy05
               WHEN INFIELD(bmy27)
#FUN-AA0059 --Begin--
                 #   CALL cl_init_qry_var()
                 #   LET g_qryparam.form = "q_ima"
                 #   LET g_qryparam.default1 = tm.bmy27
                 #   CALL cl_create_qry() RETURNING tm.bmy27
                    CALL q_sel_ima(FALSE, "q_ima", "",tm.bmy27, "", "", "", "" ,"",'' )  RETURNING tm.bmy27
#FUN-AA0059 --End--
                    DISPLAY BY NAME tm.bmy27
                    NEXT FIELD bmy27
               OTHERWISE EXIT CASE
               EXIT CASE
          END CASE

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
  
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
    END INPUT
    EXIT WHILE
   END WHILE
   IF INT_FLAG THEN
      LET INT_FLAG=0
      CLOSE WINDOW i720_g_w
      RETURN
   END IF
   IF cl_null(tm.a) OR cl_null(tm.bmy05) THEN
      CLOSE WINDOW i720_g_w
      RETURN
   END IF
 
   WHILE TRUE
     CALL cl_set_head_visible("group01,group02","YES")    #No.FUN-6B0033
     CONSTRUCT tm.wc ON ima01 FROM FORMONLY.ima01a
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
 
     ON ACTION CONTROLP
        IF INFIELD(ima01a) THEN
           CALL cl_init_qry_var()
           LET g_qryparam.form = "q_bma41" #MOD-A50172 mod q_bma4->q_bma41
           LET g_qryparam.state = "c"         #MOD-A50119 取消mark
           LET g_qryparam.arg1 = tm.bmy05  #MOD-A50172 add
           CALL cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO ima01a
           NEXT FIELD ima01a
        END IF
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
     END CONSTRUCT
     IF INT_FLAG THEN EXIT WHILE END IF
     IF tm.wc=' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
     EXIT WHILE
   END WHILE
 
   IF INT_FLAG THEN
      LET INT_FLAG=0
      CLOSE WINDOW i720_g_w
      RETURN
   END IF
 
   LET g_sql="SELECT UNIQUE bma01,bmb03,bma05,bma06 FROM bmb_file,bma_file,ima_file ",       #TQC-920056 Add bma06
             " WHERE bma01=bmb01 AND bmb01 = ima01 ",
             " AND (bmb04 IS NULL OR bmb04<='",g_bmx.bmx07,"') ",
             " AND (bmb05 IS NULL OR bmb05 >'",g_bmx.bmx07,"') ",
             " AND (bma05 IS NOT NULL AND bma05 <='",g_bmx.bmx07 CLIPPED,"') ",
             " AND bma01 IN (SELECT UNIQUE bmb01 FROM bmb_file",
             "                WHERE bmb03 ='",tm.bmy05,"'",
             "                AND (bmb04 IS NULL OR bmb04<='",g_bmx.bmx07,"') ",
             "                AND (bmb05 IS NULL OR bmb05 >'",g_bmx.bmx07,"'))",
             " AND bmb29 = bma06 ",         #MOD-A90179 add
             " AND ",tm.wc CLIPPED
   PREPARE i720_g_p FROM g_sql
   DECLARE i720_g_c CURSOR WITH HOLD FOR i720_g_p
 
   CALL g_ima.clear()
   CALL b_bmb.clear()
   LET g_cnt = 0
   FOREACH i720_g_c INTO l_bmb.*,l_bma06                                                     #TQC-920056 Add l_bma06
     IF SQLCA.sqlcode THEN EXIT FOREACH END IF
     LET g_success = 'Y'
     LET g_level=0
     LET g_bma01 = l_bmb.bma01
     LET g_bma05 = l_bmb.bma05
     LET g_bma06 = l_bma06                                                                   #TQC-920056 
     IF l_bmb.bmb03=tm.bmy05  THEN
        LET g_bma01 = l_bmb.bma01
        CALL i720_g_val(g_bma01,l_bmb.bma01,l_bmb.bma05,g_bma06)                             #TQC-920056 Add g_bma06                   
        CONTINUE FOREACH
     END IF
     CALL i720_bom(g_level,l_bmb.bmb03)
   END FOREACH
   CALL i720_g_b()
   CLOSE WINDOW i720_g_w
   CALL i720_b_fill(' 1=1')
   CALL i720_b()
END FUNCTION
 
FUNCTION i720_g_val(p_bma01,p_bmb01,p_bmb05,p_bma06)                                          #TQC-920056 Add p_bma06
   DEFINE p_bma01  LIKE bma_file.bma01,
          p_bmb01  LIKE bmb_file.bmb01,
          p_bmb05  LIKE bmb_file.bmb05,
          p_bma06  LIKE bma_file.bma06                                                        #TQC-920056 Add  
 
        IF i720_chk_bmb01(p_bmb01) THEN
           LET g_cnt = g_cnt + 1
           LET g_ima[g_cnt].choice = 'N'
           LET g_ima[g_cnt].ima01  = p_bma01
           SELECT ima02,ima021 INTO g_ima[g_cnt].ima02,g_ima[g_cnt].ima021 FROM ima_file
            WHERE ima01 = g_ima[g_cnt].ima01
           SELECT bma05 INTO g_ima[g_cnt].bma05 FROM bma_file
            WHERE bma01 = p_bma01
           LET b_bmb[g_cnt].bmb01 = p_bmb01
           LET b_bmb[g_cnt].bmb29 = p_bma06                                                 #TQC-920056
        END IF
END FUNCTION
 
FUNCTION i720_chk_bmb01(p_bmb01)
 DEFINE p_bmb01   LIKE bmb_file.bmb01,
        i,l_dup   LIKE type_file.num5    #TQC-720042 mod #No.FUN-680096 SMALLINT
 
      #CHECK 是否有重覆的資料產生
       LET l_dup = 1
       FOR i = 1 TO g_cnt
           IF b_bmb[i].bmb01 = p_bmb01 THEN
              LET l_dup = 0
              EXIT FOR
           END IF
       END FOR
       RETURN l_dup
 
END FUNCTION
 
FUNCTION i720_bom(p_level,p_key)
   DEFINE p_level	LIKE type_file.num10,                                  #TQC-920056
          p_key		LIKE bma_file.bma01,   #主件料件編號
          l_ac,i	LIKE type_file.num5,   #No.FUN-680096 SMALLINT
          arrno         LIKE type_file.num5,   #No.FUN-680096 SMALLINT,  #BUFFER SIZE (可存筆數)
          b_seq		LIKE type_file.num10,  #No.FUN-680096 INTEGER,#當BUFFER滿時,重新讀單身之起始序號
          l_chr,l_cnt   LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1),
          l_fac         LIKE csa_file.csa0301, #No.FUN-680096 DEC(13,5),
          l_ima06 LIKE ima_file.ima06,      #分群碼
          sr DYNAMIC ARRAY OF RECORD           #每階存放資料
              bma01 LIKE bma_file.bma01,    #下階主件料件
              bmb01 LIKE bmb_file.bmb01,    #主件元件料件
              bmb03 LIKE bmb_file.bmb03,    #元件料號
              bma05 LIKE bma_file.bma05     #發放日期
          END RECORD,
          l_cmd     LIKE type_file.chr1000  #No.FUN-680096 VARCHAR(1000)
 
    IF p_level > 20 THEN
       CALL cl_err('','mfg2733',1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time 
       EXIT PROGRAM
    END IF
    LET p_level = p_level + 1
    IF p_level = 1 THEN
        INITIALIZE sr[1].* TO NULL
        LET sr[1].bmb03 = p_key
    END IF
    LET arrno = 600
 
    WHILE TRUE
       LET l_cmd="SELECT bma01,bmb01,bmb03,bma05 ",
                  " FROM bmb_file,OUTER bma_file ",
                 " WHERE bmb01='",p_key CLIPPED,"' ",
                   " AND bmb_file.bmb03 = bma_file.bma01 ",
                   " AND (bmb04 <='",g_bmx.bmx07,"' OR bmb04 IS NULL)",
                   " AND (bmb05 > '",g_bmx.bmx07,"' OR bmb05 IS NULL)"
 
        #---->排列方式
        LET l_cmd=l_cmd CLIPPED, " ORDER BY bma01,bmb03"
        PREPARE i720_bom_precur FROM l_cmd
        IF SQLCA.sqlcode THEN
           CALL cl_err('i720_bom_pre:',SQLCA.sqlcode,1)
           RETURN
        END IF
        DECLARE i720_bom_cur CURSOR FOR i720_bom_precur
        IF SQLCA.sqlcode THEN
           CALL cl_err('i720_bom_cur:',SQLCA.sqlcode,1)
           RETURN
        END IF
 
        LET l_ac = 1
        FOREACH i720_bom_cur INTO sr[l_ac].*	# 先將BOM單身存入BUFFER
            IF l_ac = arrno THEN EXIT FOREACH END IF
            LET l_ac = l_ac + 1			# 但BUFFER不宜太大
         END FOREACH
         FOR i = 1 TO l_ac-1			# 讀BUFFER傳給REPORT
             LET l_fac = 1
            #與多階展開不同之處理在此:
            #尾階在展開時, 其展開之
             IF NOT cl_null(sr[i].bma01) THEN   #若為主件(有BOM單頭)
                LET g_bma01 = sr[i].bmb03       #記錄主件資料
                CALL i720_bom(p_level,sr[i].bmb03)
             ELSE
                IF sr[i].bmb03 = tm.bmy05 THEN
                   CALL i720_g_val(sr[i].bmb01,sr[i].bmb01,g_bma05,g_bma06)                         #TQC-920056 Add g_bma06
                END IF
             END IF
        END FOR
        IF l_ac < arrno THEN                    # BOM單身已讀完
            EXIT WHILE
        END IF
    END WHILE
END FUNCTION
 
FUNCTION i720_g_b()
  DEFINE l_bmy         RECORD LIKE bmy_file.*
  DEFINE l_bmb01       LIKE bmb_file.bmb01,
         l_bmb02       LIKE bmb_file.bmb02,
         l_bmb06       LIKE bmb_file.bmb06,
         l_bmb07       LIKE bmb_file.bmb07,
         l_bmy02       LIKE bmy_file.bmy02,
         l_bmy171      LIKE bmy_file.bmy171,
         l_cnt         LIKE type_file.num5,    #No.FUN-680096 SMALLINT
         l_n           LIKE type_file.num5,    #No.FUN-680096 SMALLINT
         l_sl2         LIKE type_file.num5,    #No.FUN-680096 SMALLINT,
         i             LIKE type_file.num5,    #No.FUN-680096 SMALLINT
         l_ok          LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(01),
         l_exit        LIKE type_file.chr1     #No.FUN-680096 VARCHAR(01)
  DEFINE l_bmb31       LIKE bmb_file.bmb31
  DEFINE l_bmb29       LIKE bmb_file.bmb29     #TQC-920056
  #MOD-A90151 add --start--
  DEFINE l_item     LIKE ima_file.ima01     
  DEFINE l_bmb      RECORD LIKE bmb_file.*  
  DEFINE l_bmy13    LIKE ze_file.ze03       
  DEFINE l_ima25    LIKE ima_file.ima25     
  DEFINE l_ima86    LIKE ima_file.ima86     
  DEFINE l_ima110   LIKE ima_file.ima110    
  DEFINE l_ima04    LIKE ima_file.ima04
  DEFINE l_ima70    LIKE ima_file.ima70
  DEFINE l_ima562   LIKE ima_file.ima562
  DEFINE l_ima136   LIKE ima_file.ima136
  DEFINE l_ima137   LIKE ima_file.ima137
  DEFINE l_bmw04    LIKE bmw_file.bmw04
  DEFINE l_i        LIKE type_file.num5
  #MOD-A90151 add --end--
  DEFINE l_bmb14    LIKE bmb_file.bmb14      #MOD-C30639
 
   WHILE TRUE
     IF g_cnt = 0 THEN
        CALL cl_err('','abm-011',1)
        RETURN
     ELSE
        CALL cl_getmsg('abm-012',g_lang) RETURNING g_msg
     END IF

     DISPLAY ARRAY g_ima TO s_ima.*  #顯示並進行選擇 ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
            ON ACTION CONTROLR
               CALL cl_show_req_fields()
 
            ON ACTION CONTROLG
                CALL cl_cmdask()
 
            ON ACTION select_cancel  #選擇或取消
                LET l_ac = ARR_CURR()
                LET l_sl = SCR_LINE()
                IF NOT cl_null(g_ima[l_ac].ima01) THEN
                   IF g_ima[l_ac].choice ='N' THEN
                      LET g_ima[l_ac].choice ='Y'
                   ELSE
                      LET g_ima[l_ac].choice ='N'
                   END IF
                   LET l_n  = ARR_COUNT()
                  #DISPLAY g_ima[l_ac].choice TO s_ima[l_ac].choice     #MOD-BC0191 mark
                   DISPLAY g_ima[l_ac].choice TO s_ima[l_sl].choice     #MOD-BC0191 add
                END IF
 
 
            ON ACTION select_all_yes              #整批產生
                LET l_ok='Y'
                LET l_ac = ARR_CURR()
                LET l_sl = SCR_LINE()
                LET l_sl2=l_ac-l_sl+1
                LET l_n  = ARR_COUNT()    #No:MOD-A50119 add
                LET l_sl=0
                FOR l_ac = 1 TO l_n           #將所有的設為選擇
                    IF l_ac=l_sl2 THEN
                        LET l_sl=1
                    ELSE
                        IF l_ac > l_sl2 THEN
                           LET l_sl=l_sl+1
                        END IF
                    END IF
                    LET g_ima[l_ac].choice=l_ok
                   #IF l_sl <= 6 AND l_sl > 0 THEN                           #MOD-A90179 mark 
                       DISPLAY g_ima[l_ac].choice TO s_ima[l_ac].choice
                   #END IF                                                   #MOD-A90179 mark    
                END FOR
 
            ON ACTION select_all_no           #整批取消
                LET l_ok='N'
                LET l_ac = ARR_CURR()
                LET l_sl = SCR_LINE()
                LET l_sl2=l_ac-l_sl+1
                LET l_sl=0
                LET l_n  = ARR_COUNT()    #No:MOD-A50119 add
                FOR l_ac = 1 TO l_n           #將所有的設為選擇
                    IF l_ac=l_sl2 THEN
                        LET l_sl=1
                    ELSE
                        IF l_ac > l_sl2 THEN
                           LET l_sl=l_sl+1
                        END IF
                    END IF
                    LET g_ima[l_ac].choice=l_ok
                   #IF l_sl <= 6 AND l_sl > 0 THEN                              #MOD-A90179 mark   
                       DISPLAY g_ima[l_ac].choice TO s_ima[l_ac].choice
                   #END IF                                                      #MOD-A90179 mark   
                END FOR
 
           ON ACTION accept
              LET g_action_choice="detail"
              LET l_ac = ARR_CURR()
              EXIT DISPLAY
 
           ON ACTION cancel
              LET g_action_choice="exit"
              EXIT DISPLAY
 
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
        END DISPLAY
        CALL cl_set_act_visible("accept,cancel", TRUE)
        IF INT_FLAG THEN EXIT WHILE END IF #使用者中斷
        IF l_exit='N' THEN
            CONTINUE WHILE
        END IF
        IF l_cnt < 1 THEN                               #已選筆數超過 0筆
            EXIT WHILE
        END IF
        IF cl_sure(0,0) THEN EXIT WHILE END IF
   END WHILE
   IF INT_FLAG THEN
      LET INT_FLAG=0
      RETURN
   END IF
 
   CALL cl_wait()
   CALL g_bmy.clear()
   LET l_cnt = 0
   SELECT MAX(bmy02) INTO l_bmy02 FROM bmy_file WHERE bmy01 = g_bmx.bmx01
   IF cl_null(l_bmy02) THEN LET l_bmy02 = 0 END IF
 
   ##因有時同一筆主件會存在兩筆以上相同的元件，
   ##因此必須用Declare的方式
   LET g_sql = " SELECT bmb01,bmb02,bmb06,bmb07,ima05,bmb29 ",                              #TQC-920056 Add bmb29 
               "   FROM bmb_file,ima_file ",
               "  WHERE bmb01 =  ? ",
               "    AND bmb29 =  ? ",                                                       #TQC-920056
               "    AND bmb03 = '",tm.bmy05 CLIPPED,"'",
               "    AND bmb01 = ima01 ",
               "    AND (bmb04 <='",g_today,"' OR bmb04 IS NULL)",
               "    AND (bmb05 > '",g_today,"' OR bmb05 IS NULL)"
   PREPARE bmb_pre1 FROM g_sql
   DECLARE bmb_cs1 CURSOR FOR bmb_pre1
   FOR i = 1 TO 600
       IF g_ima[i].choice = 'Y' AND NOT cl_null(g_ima[i].ima01) THEN
 
       FOREACH bmb_cs1 USING b_bmb[i].bmb01,b_bmb[i].bmb29                                  #TQC-920056 Add b_bmb[i].bmb29 
                        INTO l_bmb01,l_bmb02,l_bmb06,l_bmb07,l_bmy171,l_bmb29               #TQC-920056 Add l_bmb29
           INITIALIZE l_bmy.* TO NULL
           LET l_bmy.bmy01 = g_bmx.bmx01
           LET l_bmy02 = l_bmy02 + 1
           LET l_bmy.bmy02 = l_bmy02
           LET l_bmy.bmy03 = tm.a
           LET l_bmy.bmy04 = l_bmb02
           LET l_bmy.bmy05 = tm.bmy05
           IF l_bmy.bmy03 != '4' THEN   #MOD-A40058 add   
              IF cl_null(tm.bmy06) THEN
                 LET l_bmy.bmy06 = l_bmb06
              ELSE
                 LET l_bmy.bmy06 = tm.bmy06
              END IF
              IF cl_null(tm.bmy07) THEN
                 LET l_bmy.bmy07 = l_bmb07
              ELSE
                 LET l_bmy.bmy07 = tm.bmy07
              END IF
           END IF   #MOD-A40058 add   
           LET l_bmy.bmy14 = l_bmb01
           LET l_bmy.bmy16 = tm.c
           LET l_bmy.bmy171= l_bmy171
           LET l_bmy.bmy27 = tm.bmy27
           LET l_bmy.bmy29 = l_bmb29                                                       #TQC-920056  
           IF cl_null(l_bmy.bmy29) THEN LET l_bmy.bmy29 = ' ' END IF #FUN-550014 add
           IF cl_null(l_bmy.bmy30) THEN LET l_bmy.bmy30 = ' ' END IF #FUN-550014 add
           LET l_bmy.bmy33 = 0                   #NO.FUN-840033
           #IF g_bmy[l_ac].bmy03 MATCHES '[13]'  THEN #MOD-A90151 mark
            IF l_bmy.bmy03 MATCHES '[13]'  THEN  #MOD-A90151
               SELECT bmb31,bmb14 INTO l_bmb31,l_bmb14 FROM bmb_file       #MOD-C30639 add bmb14
                  WHERE bmb01 = l_bmy.bmy14
                    AND bmb03 = l_bmy.bmy05
                    AND (bmb04 <= g_bmx.bmx07 OR bmb04 IS NULL)
                    AND (bmb05 >  g_bmx.bmx07 OR bmb05 IS NULL)
               LET l_bmy.bmy34 = l_bmb31
               LET l_bmy.bmy35 = l_bmb14               #MOD-C30639
            ELSE                  
            	  LET l_bmy.bmy34 = 'N'   
            END IF                         
 
           LET l_bmy.bmyplant = g_plant 
           LET l_bmy.bmylegal = g_legal 
           #No.FUN-A60031--begin
           IF cl_null(l_bmy.bmy012) THEN 
              LET l_bmy.bmy012=' '
           END IF 
           IF cl_null(l_bmy.bmy013) THEN 
              LET l_bmy.bmy013=0
           END IF             
           #No.FUN-A60031--end  
           #MOD-A90151 add --start--
           IF l_bmy.bmy03 = '4' THEN
              SELECT ima25,ima86,ima110 INTO l_ima25,l_ima86,l_ima110 FROM ima_file
               WHERE ima01=l_bmy.bmy27
           ELSE
              SELECT ima25,ima86,ima110 INTO l_ima25,l_ima86,l_ima110 FROM ima_file
               WHERE ima01=l_bmy.bmy05
           END IF

           LET l_bmy13=' '
           LET l_i = 0
           DECLARE bmy13_cs CURSOR FOR
            SELECT bmw04 FROM bmw_file
             WHERE bmw01=g_bmx.bmx01
               AND bmw02=l_bmy.bmy02
           FOREACH bmy13_cs INTO l_bmw04
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
           IF l_i = 0 THEN
               LET l_bmy13=l_bmw04
            ELSE
               LET l_bmy13= l_bmy13 CLIPPED , ',', l_bmw04
            END IF
            LET l_i = l_i + 1
           END FOREACH
           LET l_bmy.bmy13 = l_bmy13

           IF l_bmy.bmy03 = '4' THEN
              LET l_item = l_bmy.bmy27
           ELSE
              LET l_item = l_bmy.bmy05
           END IF
           IF l_bmy.bmy03 MATCHES '[2345]' THEN
              IF NOT cl_null(l_bmy.bmy04) THEN
                 SELECT * INTO l_bmb.* FROM bmb_file
                  WHERE bmb01 = l_bmy.bmy14
                    AND bmb02 = l_bmy.bmy04
              ELSE
                 SELECT * INTO l_bmb.* FROM bmb_file
                  WHERE bmb01 = l_bmy.bmy14
                    AND bmb03 = l_bmy.bmy05
                    AND bmb29 = l_bmy.bmy29
                    AND (bmb05 > g_bmx.bmx07 OR bmb05 IS NULL)
              END IF
              IF NOT cl_null(l_bmb.bmb18) THEN
                 LET l_bmy.bmy18=l_bmb.bmb18
              ELSE
                 LET l_bmy.bmy18=0
              END IF
              IF NOT cl_null(l_bmb.bmb08) THEN
                 LET l_bmy.bmy08=l_bmb.bmb08
              ELSE
                 LET l_bmy.bmy08=0
              END IF
              #Add No:TQC-AC0300
              IF NOT cl_null(l_bmb.bmb081) THEN
                 LET l_bmy.bmy081=l_bmb.bmb081
              ELSE
                 LET l_bmy.bmy081=0
              END IF
              IF NOT cl_null(l_bmb.bmb082) THEN
                 LET l_bmy.bmy082=l_bmb.bmb082
              ELSE
                 LET l_bmy.bmy082=1
              END IF
              #End Add No:TQC-AC0300
              IF NOT cl_null(l_bmb.bmb09) THEN
                 LET l_bmy.bmy09=l_bmb.bmb09
              ELSE
                 LET l_bmy.bmy09=''
              END IF
              LET l_bmy.bmy21='N'
              SELECT ima63,ima63_fac,ima25
                INTO l_bmy.bmy10,l_bmy.bmy10_fac,l_ima25
                FROM ima_file WHERE ima01=l_item
              CALL s_umfchk(l_item,l_bmy.bmy10,l_ima25)
                  RETURNING g_sw_chr1,l_bmy.bmy10_fac  #發料/庫存單位  #FUN-AC0060 g_sw 改成g_sw_chr1
              IF g_sw_chr1 THEN LET l_bmy.bmy10_fac = 1 END IF         #FUN-AC0060 g_sw 改成g_sw_chr1
              IF cl_null(l_bmy.bmy10_fac) THEN LET l_bmy.bmy10_fac = 1 END IF
              IF cl_null(l_ima110) THEN LET l_ima110 = '1' END IF
              LET l_bmy.bmy20 = l_ima110
           END IF
           IF l_bmy.bmy03 MATCHES '[245]' THEN
              SELECT ima04,ima136,ima137,ima70,ima562
                INTO l_ima04,l_ima136,l_ima137,l_ima70,l_ima562
                FROM ima_file WHERE ima01=l_item
              LET l_bmy.bmy11 = l_ima04 
              LET l_bmy.bmy25 = l_ima136    
              LET l_bmy.bmy26 = l_ima137  
              LET l_bmy.bmy21 = l_ima70    
              IF cl_null(l_bmy.bmy23) THEN LET l_bmy.bmy23=0 END IF 
              LET l_bmy.bmy23 = 0     
           END IF       
           #MOD-A90151 add --end--
           INSERT INTO bmy_file VALUES (l_bmy.*)
           IF SQLCA.SQLCODE THEN
              CALL cl_err3("ins","bmy_file",l_bmy.bmy01,l_bmy.bmy02,SQLCA.SQLCODE,"","ins bmy",1) # TQC-660046
              EXIT FOR
           END IF
       END FOREACH
       END IF
    END FOR
    ERROR ''
END FUNCTION
 
FUNCTION i720_up_bmy13()
 DEFINE l_bmw04   LIKE bmw_file.bmw04,
        l_bmy13   LIKE bmy_file.bmy13,
        l_i       LIKE type_file.num5          #No.FUN-680096 SMALLINT
 
    LET l_bmy13=' '
    LET l_i = 0
    DECLARE up_bmy13_cs CURSOR FOR
     SELECT bmw04 FROM bmw_file
      WHERE bmw01=g_bmx.bmx01
        AND bmw02=g_bmy[l_ac].bmy02
    FOREACH up_bmy13_cs INTO l_bmw04
     IF SQLCA.sqlcode THEN
        CALL cl_err('foreach:',SQLCA.sqlcode,1)
        EXIT FOREACH
     END IF
     IF l_i = 0 THEN
        LET l_bmy13=l_bmw04
     ELSE
        LET l_bmy13= l_bmy13 CLIPPED , ',', l_bmw04
     END IF
     LET l_i = l_i + 1
    END FOREACH
    LET b_bmy.bmy13 = l_bmy13
END FUNCTION
 
FUNCTION i720_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("bmy16,bmy06,bmy07,bmy27,bmy34",TRUE)  #no.MOD-840478 mod
    END IF
    CALL cl_set_comp_entry("bmy06,bmy07,bmy29,bmy30,bmy16,bmy27,bmy34,bmy35",TRUE) #FUN-550014 add bmy29,bmy30 #CHI-960004 add bmy16,bmy27  #TQC-C80066 add bmy06,bmy07,bmy34,bmy35
 
    IF INFIELD(bmy03) THEN
       CALL cl_set_comp_required("bmy06,bmy07",FALSE)   #MOD-A40058 add
    END IF
 
END FUNCTION
 
FUNCTION i720_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
    IF INFIELD(bmy03) OR (NOT g_before_input_done) THEN   #TQC-C80066 add ( NOT g_before_input_done )
       IF l_ac>0 THEN                                     #TQC-C80066--add
          IF g_bmy[l_ac].bmy03 ='1' THEN
             CALL cl_set_comp_entry("bmy06,bmy07,bmy27,bmy34,bmy16,bmy35,bmy30",FALSE)  #no.MOD-840478 #CHI-960004 mod #TQC-C80066--add bmy16,bmy35,bmy30 
#         ELSE                                                           #TQC-C80066--mark--
#           CALL cl_set_comp_entry("bmy06,bmy07,bmy27,bmy34",TRUE)       #CHI-960004 mod  #TQC-C80066--mark--
          END IF
          IF g_bmy[l_ac].bmy03 NOT MATCHES '[456]' THEN  #CHI-960004 #CHI-C20060
             CALL cl_set_comp_entry("bmy27",FALSE)
          END IF
        #str MOD-A40123 mark
        ##str MOD-A40058 add
        # IF g_bmy[l_ac].bmy03 != '4' THEN
        #	  CALL cl_set_comp_entry("bmy06,bmy07",FALSE)
        # END IF
        ##end MOD-A40058 add
        #end MOD-A40123 mark
       END IF                                              #TQC-C80066--add
    END IF
    IF g_sma.sma118 !='Y' THEN
        CALL cl_set_comp_entry("bmy29",FALSE)        #NO.FUN-810014
    END IF
     IF NOT cl_null(g_bmy[l_ac].bmy03) THEN
       #MOD-AC0029---mark---start---
       #IF g_bmy[l_ac].bmy03 = '4' THEN
       #   CALL cl_set_comp_entry("bmy16",FALSE)
       #   IF p_cmd = 'a' THEN                 #MOD-A90160 add              
       #      LET g_bmy[l_ac].bmy16 = '1' 
       #   END IF                              #MOD-A90160 add    
       #END IF
       #MOD-AC0029---mark---end---
        IF g_bmy[l_ac].bmy03 MATCHES '[456]' THEN  #CHI-C20060
           CALL cl_set_comp_required("bmy27",TRUE)
        ELSE
           CALL cl_set_comp_required("bmy27",FALSE)
           CALL cl_set_comp_entry("bmy27",FALSE)
        END IF
        #CHI-C20060---begin
        IF g_bmy[l_ac].bmy03 = '6' THEN
           CALL cl_set_comp_entry("bmy16,bmy35,bmy30",FALSE)
           CALL cl_set_comp_required("bmy06,bmy07",TRUE)
           CALL cl_set_comp_entry("bmy36",TRUE)  #FUN-BB0075
        ELSE
           CALL cl_set_comp_entry("bmy16,bmy35,bmy30",TRUE)
           CALL cl_set_comp_required("bmy06,bmy07",FALSE)
           CALL cl_set_comp_entry("bmy36",FALSE)  #FUN-BB0075
        END IF  
        #CHI-C20060---end
     END IF
     #FUN-BB0075---begin
     IF l_ac > 0 THEN 
        IF cl_null(g_bmy[l_ac].bmy36) THEN
           CALL cl_set_comp_entry("bmy06,bmy07",TRUE)
        ELSE
           CALL cl_set_comp_entry("bmy06,bmy07",FALSE)
        END IF 
     END IF 
     #FUN-BB0075---end
 
END FUNCTION
 
 
FUNCTION i720_chkinsitm()
 DEFINE l_count LIKE type_file.chr1,   #No.FUN-680096 SMALLINT, #檢查是否存在二次同一主件,同一元件 #MOD-530305 5
        l_sql   STRING    #MOD-530305 5
 DEFINE l_count_bmy LIKE type_file.num5  #NO.FUN-840033
 
   IF (g_bmy[l_ac].bmy05 IS NULL) OR (g_bmy[l_ac].bmy14 IS NULL) THEN
      RETURN TRUE
   END IF
   #避免若修改狀態,僅修改了項次,也會造成 err msg,所以加入此判斷
   IF (g_bmy[l_ac].bmy05=g_bmy_t.bmy05) AND
      (g_bmy[l_ac].bmy14=g_bmy_t.bmy14) THEN
      RETURN TRUE
   END IF
   #--同一張ECN單身允許多筆相同 主件+元件 ---
  #MOD-B90281---add---start---
   IF cl_null(g_bmy[l_ac].bmy04) THEN
      LET l_sql="SELECT COUNT(*) FROM bmy_file WHERE ",
                "bmy14='",g_bmy[l_ac].bmy14,"' AND bmy05='",g_bmy[l_ac].bmy05,
                "' AND bmy01='",g_bmx.bmx01,"' AND bmy02<>",g_bmy[l_ac].bmy02
   ELSE
  #MOD-B90281---add---end---
      LET l_sql="SELECT COUNT(*) FROM bmy_file WHERE ",
                "bmy14='",g_bmy[l_ac].bmy14,"' AND bmy05='",g_bmy[l_ac].bmy05,
                "' AND bmy04=",g_bmy[l_ac].bmy04,      #No.MOD-760037 add
                "' AND bmy01='",g_bmx.bmx01,"' AND bmy02<>",g_bmy[l_ac].bmy02
   END IF          #MOD-B90281 add
   PREPARE i720_chkinsitm_sql FROM l_sql
   DECLARE i720_chkinsitm_cur CURSOR FOR i720_chkinsitm_sql
   OPEN i720_chkinsitm_cur
   FETCH i720_chkinsitm_cur INTO l_count
   CLOSE i720_chkinsitm_cur
   
   IF cl_null(g_bmy[l_ac].bmy04) THEN 
       LET l_sql="SELECT COUNT(*) FROM bmx_file,bmy_file ",
                 " WHERE bmx01 = bmy01 ",
                 "   AND bmx01 <> '",g_bmx.bmx01,"'",             #單號
                 "   AND bmy14='",g_bmy[l_ac].bmy14,"' ",   #主件編號
                 "   AND bmy05='",g_bmy[l_ac].bmy05,"'",        #元件編號
                 "   AND bmx07 <= '",g_bmx.bmx07,"'",       #生效日
                 "   AND bmx04 = 'N'"                       #確認碼 
   ELSE
       LET l_sql="SELECT COUNT(*) FROM bmx_file,bmy_file ",
                 " WHERE bmx01 = bmy01",
                 "   AND bmx01 <> '",g_bmx.bmx01,"'",             #單號
                 "   AND bmy14='",g_bmy[l_ac].bmy14,"' ",   #主件編號
                 "   AND bmy05='",g_bmy[l_ac].bmy05,"'",        #元件編號
                 "   AND bmx07 <= '",g_bmx.bmx07,"'",       #生效日
                #"   AND bmy04=",g_bmy[l_ac].bmy04,"'",     #BOM項次    #MOD-B90281 mark
                 "   AND bmy04='",g_bmy[l_ac].bmy04,"'",    #BOM項次    #MOD-B90281 add
                 "   AND bmx04 = 'N'"                       #確認碼 
   END IF
 
   PREPARE i720_chkinsitm_1 FROM l_sql
   DECLARE i720_chkinsitm_cur1 CURSOR FOR i720_chkinsitm_1
   OPEN i720_chkinsitm_cur1
   FETCH i720_chkinsitm_cur1 INTO l_count_bmy
   CLOSE i720_chkinsitm_cur1
   CASE
       WHEN l_count > 0 
           CALL cl_err('chk ins itm','abm-806',0)
           RETURN FALSE
       WHEN l_count_bmy > 0 
           CALL cl_err('chk ins itm','abm-821',0)
           RETURN FALSE
       OTHERWISE
           RETURN TRUE
   END CASE
 
END FUNCTION
FUNCTION i720_ef()
 
    #CALL i720_y_chk()          #CALL 原確認的 check 段   #FUN-580161 #FUN-AC0060 mark
     CALL i720sub_y_chk(g_bmx.bmx01)                                  #FUN-AC0060 add
     IF g_success = "N" THEN
         RETURN
     END IF
 
     CALL aws_condition()      #判斷送簽資料
     IF g_success = 'N' THEN
         RETURN
     END IF
##########
# CALL aws_efcli2()
# 傳入參數: (1)單頭資料, (2-6)單身資料
# 回傳值  : 0 開單失敗; 1 開單成功
##########
  IF aws_efcli2(base.TypeInfo.create(g_bmx),base.TypeInfo.create(g_bmy),'','','','') THEN
     LET g_success='Y'
     LET g_bmx.bmx09='S'
     DISPLAY BY NAME g_bmx.bmx09
  ELSE
     LET g_success='N'
  END IF
 
END FUNCTION
 
FUNCTION i720_field_pic()
     LET g_void=NULL
     LET g_approve=NULL
     LET g_confirm=NULL
     IF g_bmx.bmx04 MATCHES '[Yy]' THEN
        IF g_bmx.bmx09 MATCHES '[SsRrWw]' THEN
           LET g_confirm='Y'
           LET g_approve='N'
           LET g_void='N'
        END IF
        IF g_bmx.bmx09 MATCHES '[1]' THEN
           LET g_confirm='Y'
           LET g_approve='Y'
           LET g_void='N'
        END IF
     ELSE
        IF g_bmx.bmx04 ='X' THEN
           IF g_bmx.bmx09 MATCHES '[9]' THEN
              LET g_confirm='N'
              LET g_approve='N'
              LET g_void='Y'
           END IF
        ELSE
           LET g_confirm='N'
           LET g_approve='N'
           LET g_void='N'
        END IF
     END IF
         IF g_argv3_str <>'abmp701' OR cl_null(g_argv3_str) THEN   #CHI-CA0035 add
            CALL cl_set_field_pic(g_confirm,g_approve,"","",g_void,"g_bmx.bmxacti")
         END IF   #CHI-CA0035 add

END FUNCTION
FUNCTION i720_set_entry(p_cmd)
 
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("bmx01",TRUE)
  END IF
 
END FUNCTION
 
 
FUNCTION i720_set_no_entry(p_cmd)
 
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("bmx01",FALSE)
   END IF
 
END FUNCTION
FUNCTION i720_bmx10(p_cmd)
DEFINE p_cmd      LIKE type_file.chr1,       #No.FUN-680096 VARCHAR(1)
       l_gen02    LIKE gen_file.gen02,
       l_gen03    LIKE gen_file.gen03,       #No:7381
       l_genacti  LIKE gen_file.genacti
 
    LET g_errno = ' '
    SELECT gen02,gen03,genacti INTO l_gen02,l_gen03,l_genacti    #No:7381
      FROM gen_file
     WHERE gen01 = g_bmx.bmx10
    CASE
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg1312'
                                LET l_gen02 = NULL
                                LET l_genacti = NULL
       WHEN l_genacti = 'N'  LET g_errno = '9028'
       OTHERWISE             LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    #No.CHI-9C0054 ---start---
    IF p_cmd != 'd' THEN               
       IF cl_null(g_bmx.bmx13) THEN
          LET g_bmx.bmx13 = l_gen03      
       END IF  
    END IF                     
    #No.CHI-9C0054 ---end---
    IF cl_null(g_errno) OR p_cmd = 'd'
    THEN DISPLAY l_gen02 TO FORMONLY.gen02
    END IF
END FUNCTION

#No.CHI-9C0054 ---start---
FUNCTION i720_bmx13(p_cmd)
   DEFINE p_cmd       LIKE type_file.chr1
   DEFINE l_gem02     LIKE gem_file.gem02
   DEFINE l_gemacti   LIKE gem_file.gemacti

   LET g_errno = ' '
   SELECT gem02,gemacti INTO l_gem02,l_gemacti  
     FROM gem_file
    WHERE gem01 = g_bmx.bmx13
   CASE 
      WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-039'
                               LET l_gem02 = NULL
                               LET l_gemacti = NULL
      WHEN l_gemacti = 'N' LET g_errno = '9028'
      OTHERWISE            LET g_errno = SQLCA.SQLCODE USING '------'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_gem02 TO FORMONLY.gem02
   END IF 

END FUNCTION
#No.CHI-9C0054 ---end---

FUNCTION i720_set_bmy30()
  DEFINE lcbo_target ui.ComboBox
 
  LET lcbo_target = ui.ComboBox.ForName("bmy30")
  CALL lcbo_target.RemoveItem("2")
  CALL lcbo_target.RemoveItem("3")
 
END FUNCTION
 
FUNCTION i720_carry()                                                                                                               
   DEFINE l_i       LIKE type_file.num10                                                                                            
   DEFINE l_j       LIKE type_file.num10                                                                                            
   DEFINE l_gew03   LIKE gew_file.gew03  #FUN-950057 
   DEFINE 
          #l_sql     LIKE type_file.chr1000
          l_sql       STRING      #NO.FUN-910082
 
   IF cl_null(g_bmx.bmx01) THEN 
      CALL cl_err('',-400,0)
      RETURN 
   END IF
   IF g_bmx.bmx04 <> 'Y' THEN                                                                                                     
      CALL cl_err(g_bmx.bmx01,'aoo-092',3)                                                                                          
      RETURN                                                                                                                        
   END IF
                                                                                                                                    
   LET g_gev04 = NULL  
 
   #是否為資料中心的拋轉DB                                                                                                          
   SELECT gev04 INTO g_gev04 FROM gev_file                                                                                          
    WHERE gev01 = '3' AND gev02 = g_plant                                                                                           
      AND gev03 = 'Y'                                                                                                               
   IF SQLCA.sqlcode THEN                                                                                                            
      CALL cl_err(g_gev04,'aoo-036',1)                                                                                              
      RETURN                                                                                                                        
   END IF
                                                                                                             
                                                                                                                      
   IF cl_null(g_gev04) THEN RETURN END IF                                                                                           
                                                                                                                                    
#FUN-950057 ----------------------add start-------------------
   SELECT DISTINCT gew03 INTO l_gew03 FROM gew_file 
    WHERE gew01 = g_gev04 AND gew02 = '3' 
   IF NOT cl_null(l_gew03) THEN
      IF l_gew03 = '2' THEN                                                     
          IF NOT cl_confirm('anm-929') THEN RETURN END IF  #询问是否执行抛转    
      END IF
#FUN-950057 ----------------------add end--------------------
                                                                                                   
 
   #開窗選擇拋轉的db清單                                                                                                            
   LET l_sql = "SELECT COUNT(*) FROM &bmx_file WHERE bmx01='",g_bmx.bmx01,"'"                                                       
   CALL s_dc_sel_db1(g_gev04,'3',l_sql)                                                                                             
   IF INT_FLAG THEN                                                                                                                 
      LET INT_FLAG=0                                                                                                                
      RETURN                                                                                                                        
   END IF
                                                                                                                                    
   CALL g_bmxx.clear()                                                                                                              
                                                                                                                        
   LET g_bmxx[1].sel = 'Y'                                                                                                          
   LET g_bmxx[1].bmx01 = g_bmx.bmx01 
   FOR l_i = 1 TO g_azp1.getLength()                                                                                                
       LET g_azp[l_i].sel   = g_azp1[l_i].sel                                                                                       
       LET g_azp[l_i].azp01 = g_azp1[l_i].azp01                                                                                     
       LET g_azp[l_i].azp02 = g_azp1[l_i].azp02                                                                                     
       LET g_azp[l_i].azp03 = g_azp1[l_i].azp03                                                                                     
   END FOR
                                                                                                                                   
   CALL s_showmsg_init()                                                                                                            
   CALL s_abmi710_carry_bmx(g_bmxx,g_azp,g_gev04,'0')                                       
   CALL s_showmsg()                                                                                                                 
 END IF       #FUN-950057 add
                                                                                                                                    
END FUNCTION                                                                                                                        
 
FUNCTION i720_download()                                                                                                            
  DEFINE l_path       LIKE ze_file.ze03                                                                                             
  DEFINE l_i          LIKE type_file.num10                                                                                          
  DEFINE l_j          LIKE type_file.num10                                                                                          
 
   IF cl_null(g_bmx.bmx01) THEN 
      CALL cl_err('',-400,0)
      RETURN 
   END IF                                                                                                                                    
   CALL g_bmxx.clear()                                                                                                              
   FOR l_i = 1 TO g_bmx_l.getLength()                                                                                               
       LET g_bmxx[l_i].sel   = 'Y'                                                                                                  
       LET g_bmxx[l_i].bmx01 = g_bmx_l[l_i].bmx01                                                                                   
   END FOR                                                                                                                          
   CALL s_abmi710_download(g_bmxx)                                                #FUN-820027暫時MARK                               
                                                                                                                                    
END FUNCTION
                                                                                                                                    
#No.FUN-BB0086---start---add---
FUNCTION i720_bmy081_check(b_bmy81_t)
   DEFINE b_bmy81_t	LIKE bmy_file.bmy081
   IF NOT cl_null(b_bmy.bmy081) AND NOT cl_null(b_bmy.bmy10) THEN
      IF cl_null(b_bmy81_t) OR cl_null(b_bmy10_t) OR b_bmy81_t != b_bmy.bmy081 OR b_bmy10_t != b_bmy.bmy10 THEN
         LET b_bmy.bmy081=s_digqty(b_bmy.bmy081, b_bmy.bmy10)
         DISPLAY BY NAME b_bmy.bmy081
      END IF
   END IF

   IF b_bmy.bmy081 < 0 THEN
      CALL cl_err(b_bmy.bmy081,'aec-020',0)
      LET b_bmy.bmy081 = b_bmy81_t
      DISPLAY BY NAME b_bmy.bmy081
      RETURN FALSE 
   END IF
   RETURN TRUE
END FUNCTION
#No.FUN-BB0086---end---add---

#FUN-AC0060--mark---str---                                                                                                                                   
##確認時檢查單據中所有的主件+元件是否有未確認的單據存在資料庫且生效日在本張單據之前
#FUNCTION i720_y_chk_bmy()  
#DEFINE i,j      LIKE type_file.num5
#DEFINE l_count  LIKE type_file.num5
#DEFINE l_flag   LIKE type_file.chr1
#DEFINE l_sql    STRING
#DEFINE l_n      LIKE type_file.num5    #NO.FUN-870117
#DEFINE l_bmy05  LIKE bmy_file.bmy05    #No.FUN-870117
#DEFINE l_bmy13  LIKE bmy_file.bmy13    #No.FUN-870117
#DEFINE l_bma    RECORD LIKE bma_file.* #No.FUN-870117
#DEFINE l_bmy    RECORD LIKE bmy_file.* #No.FUN-870117 
# 
#   LET l_flag= 'N'
#   LET g_chk1 = 'N'
#   SELECT  COUNT(*) INTO l_n FROM  bmy_file a,ima_file
#   WHERE  a.bmy01 = g_bmx.bmx01 AND  a.bmy03 = '2' 
#   AND  exists (SELECT * FROM  bma_file WHERE  a.bmy05 = bma01)
#   AND  ima01 = a.bmy05 AND ima151!= 'Y'
#   AND exists (SELECT * FROM bmy_file WHERE bmy14 = a.bmy05 AND bmy01 =g_bmx.bmx01)   #NO.FUN-8A0128
#   IF l_n >0 THEN
#      IF cl_confirm('abm-150')  THEN 
#         LET g_chk1 = 'Y'
#         DECLARE i720_del_bmy01 CURSOR FOR 
#             SELECT  bmy05,bmy13 FROM  bmy_file a,ima_file
#              WHERE  a.bmy01 = g_bmx.bmx01 AND  a.bmy03 = '2' 
#                AND  exists (SELECT * FROM  bma_file WHERE  a.bmy05 = bma01)
#                AND  ima01 = a.bmy05 AND ima151!= 'Y'
#                 AND exists (SELECT * FROM bmy_file WHERE bmy14 = a.bmy05 AND bmy01 =g_bmx.bmx01)  #NO.FUN-8A0128
#         FOREACH i720_del_bmy01 INTO l_bmy05,l_bmy13        
#           DELETE FROM bmb_file WHERE bmb01 = l_bmy05 AND bmb29 = l_bmy13  
#           DELETE FROM bmt_file WHERE bmt01 = l_bmy05 AND bmt08 = l_bmy13
#           DELETE FROM bmd_file WHERE bmd01 = l_bmy05
#           IF SQLCA.sqlcode THEN 
#              LET g_success = 'N'
#              RETURN
#           END IF 
#         END FOREACH
#      END IF 
#   END IF 
#   SELECT  COUNT(*) INTO l_n FROM  bmy_file 
#   WHERE    NOT   exists (SELECT * FROM  bma_file WHERE  bmy05 = bma01)
#   AND bmy05 in (select bmy14 from bmy_file where bmy01 = g_bmx.bmx01 and bmy03 = '2') 
#   AND bmy01 = g_bmx.bmx01 AND  bmy03 = '2'
#    IF l_n >0 THEN
#         DECLARE i720_del_bmy02 CURSOR FOR 
#             SELECT  * FROM  bmy_file 
#              WHERE  bmy01 = g_bmx.bmx01 AND  bmy03 = '2' 
#                AND  NOT exists (SELECT * FROM  bma_file WHERE  bmy05 = bma01)
#                AND bmy05 in (select bmy14 from bmy_file where bmy01 = g_bmx.bmx01 and bmy03 = '2')
#         FOREACH i720_del_bmy02 INTO l_bmy.*       
#           LET l_bma.bma01 = l_bmy.bmy05
#           LET l_bma.bma06 = l_bmy.bmy13
#           LET l_bma.bma10 = '2' 
#           LET l_bma.bma05 = g_today
#           LET l_bma.bma04 =' '
#           LET l_bma.bma08 = ' '
#           LET l_bma.bmaacti = 'Y'
#           LET l_bma.bmauser =g_user
#           LET l_bma.bmagrup =g_grup
#           LET l_bma.bmaoriu = g_user      #No.FUN-980030 10/01/04
#           LET l_bma.bmaorig = g_grup      #No.FUN-980030 10/01/04
#           INSERT INTO bma_file VALUES (l_bma.*)
#           IF SQLCA.sqlcode THEN 
#              LET g_success = 'N'
#              RETURN
#           END IF 
#         END FOREACH
#   END IF 
#   FOR i = 1 TO g_bmy.getLength()                                                                                               
#       IF cl_null(g_bmy[i].bmy04) THEN 
#           LET l_sql="SELECT COUNT(*) FROM bmx_file,bmy_file ",
#                     " WHERE bmx01 = bmy01 ",
#                     "   AND bmx01 <> '",g_bmx.bmx01,"'",             #單號
#                     "   AND bmy14='",g_bmy[i].bmy14,"' ",   #主件編號
#                     "   AND bmy05='",g_bmy[i].bmy05,"'",        #元件編號
#                     "   AND bmx07 < '",g_bmx.bmx07,"'",       #生效日
#                     "   AND bmx04 = 'N'"                       #確認碼 
#       ELSE
#           LET l_sql="SELECT COUNT(*) FROM bmx_file,bmy_file ",
#                     " WHERE bmx01 = bmy01",
#                     "   AND bmx01 <> '",g_bmx.bmx01,"'",             #單號
#                     "   AND bmy14='",g_bmy[i].bmy14,"' ",   #主件編號
#                     "   AND bmy05='",g_bmy[i].bmy05,"'",        #元件編號
#                     "   AND bmx07 < '",g_bmx.bmx07,"'",       #生效日
#                     "   AND bmy04=",g_bmy[i].bmy04,"'",     #BOM項次
#                     "   AND bmx04 = 'N'"                       #確認碼 
#       END IF
#       PREPARE i720_chk_bmy_p FROM l_sql
#       DECLARE i720_chk_bmy_c CURSOR FOR i720_chk_bmy_p
#       LET l_flag= 'N'
#       OPEN i720_chk_bmy_c 
#       FETCH i720_chk_bmy_c INTO l_count
#       CLOSE i720_chk_bmy_c
#       CASE
#           WHEN l_count > 0 
#               LET g_showmsg = g_bmy[i].bmy14,'/',g_bmy[i].bmy05                    
#               CALL s_errmsg('bmy14,bmy05','',g_showmsg,'abm-821',1)
#               LET l_flag = 'Y'
#               LET g_success = 'N'
#               EXIT FOR
#               OTHERWISE
#               CONTINUE FOR
#       END CASE
#       IF l_flag = 'Y' THEN
#           EXIT FOR
#       END IF
#   END FOR
#END FUNCTION
 
 
#FUNCTION i720_chk_mutli()
#DEFINE l_chr LIKE type_file.chr1
#DEFINE l_n   LIKE type_file.num5
#DEFINE l_bmy14 LIKE bmy_file.bmy14 
# 
#   LET l_chr = 1
#   DECLARE i720_mutil CURSOR FOR SELECT bmy14 
#        FROM bmx_file,bmy_file,imx_file WHERE bmy01 = bmx01 AND bmx01=g_bmx.bmx01 GROUP BY bmy14
#   FOREACH i720_mutil   INTO l_bmy14
#      SELECT COUNT(*) INTO l_n FROM bmy_file,bmx_file WHERE bmy14 IN
#        (SELECT imx000 FROM imx_file
#          WHERE imx00 = l_bmy14) AND bmx04 ='N' AND bmy01 =bmx01       
#   IF l_n >0 THEN 
#      LET l_chr=0 
#      RETURN l_chr
#   END IF 
#   END FOREACH 
#   RETURN l_chr
#END FUNCTION             
#FUN-AC0060--mark---end---                                                                                                                                   

#No:FUN-9C0077
#CHI-C80063---begin
FUNCTION i720_b_more1()
   DEFINE l_bmy RECORD LIKE bmy_file.*
   OPEN WINDOW i720_b_more_w WITH FORM "abm/42f/abmi710b"
    ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("abmi710b")

   SELECT * INTO l_bmy.*
   FROM bmy_file
   WHERE bmy01 = g_bmx.bmx01
     AND bmy02 = g_bmy[l_ac].bmy02
   
   DISPLAY BY NAME
           l_bmy.bmy25, l_bmy.bmy26, l_bmy.bmy13, l_bmy.bmy18,
	       l_bmy.bmy08, l_bmy.bmy081,l_bmy.bmy082,l_bmy.bmy11, l_bmy.bmy20,
           l_bmy.bmy22, l_bmy.bmy09, l_bmy.bmy10,
	       l_bmy.bmy10_fac,l_bmy.bmy21,l_bmy.bmy23 

   MENU ""
      ON ACTION exit
         EXIT MENU
      ON ACTION cancel
         EXIT MENU
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE MENU
      ON ACTION about        
         CALL cl_about()    
      ON ACTION help         
         CALL cl_show_help()
      ON ACTION controlg      
         CALL cl_cmdask()    
      ON ACTION close   
         EXIT MENU
 
     END MENU
   CLOSE WINDOW i720_b_more_w
END FUNCTION 
#CHI-C80063---end

#FUN-D10093---add----str---
FUNCTION i720_get_plm()
   DEFINE l_bmb36   LIKE bmb_file.bmb36
   DEFINE l_bmb37   LIKE bmb_file.bmb37

   LET l_bmb36 = ''
   LET l_bmb37 = ''
   #Default PLM BOM項次(bmy361),PLM KEY(bmy37)
   IF g_bmy[l_ac].bmy03 MATCHES '[134]' THEN #1:舊元件失效 3:舊元件修改 4:取代
       IF cl_null(g_bmy[l_ac].bmy04) THEN #BOM項次
          IF NOT cl_null(g_bmy[l_ac].bmy14) AND NOT cl_null(g_bmy[l_ac].bmy05) THEN
              SELECT bmb36,bmb37 INTO l_bmb36,l_bmb37 FROM bmb_file
               WHERE bmb01 = g_bmy[l_ac].bmy14 #主件編號
                 AND bmb03 = g_bmy[l_ac].bmy05 #元件編號
                 AND bmb04 = (SELECT MAX(bmb04) FROM bmb_file
                               WHERE bmb01 = g_bmy[l_ac].bmy14
                                 AND bmb03 = g_bmy[l_ac].bmy05)
                 AND (bmb04 <= g_bmx.bmx07 OR bmb04 IS NULL)
                 AND (bmb05 >  g_bmx.bmx07 OR bmb05 IS NULL)
          END IF
       ELSE
          IF NOT cl_null(g_bmy[l_ac].bmy14) AND NOT cl_null(g_bmy[l_ac].bmy05) AND NOT cl_null(g_bmy[l_ac].bmy04) THEN
              SELECT bmb36,bmb37 INTO l_bmb36,l_bmb37 FROM bmb_file
               WHERE bmb01 = g_bmy[l_ac].bmy14 #主件編號
                 AND bmb03 = g_bmy[l_ac].bmy05 #元件編號
                 AND bmb02 = g_bmy[l_ac].bmy04 #BOM項次
                 AND (bmb04 <= g_bmx.bmx07 OR bmb04 IS NULL)
                 AND (bmb05 >  g_bmx.bmx07 OR bmb05 IS NULL)
          END IF
       END IF
       LET g_bmy[l_ac].bmy361 = l_bmb36
       LET g_bmy[l_ac].bmy37 = l_bmb37
       DISPLAY g_bmy[l_ac].bmy361 TO s_bmy[l_sl].bmy361
       DISPLAY g_bmy[l_ac].bmy37 TO s_bmy[l_sl].bmy37
   END IF
END FUNCTION
#FUN-D10093---add----end---
