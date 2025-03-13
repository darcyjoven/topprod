# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: asft700.4gl
# Descriptions...: 生產日報維護作業
# Date & Author..: 99/05/18 By Carol
# Modify.........: No.7242 03/07/17 By Carol:1.Call q_sfb24() 傳參數'2345'
#                                              改為 '234567' 這樣部份完工的工單才會顯示
#                                            2.q_sfb24()SQL add sfb08>sf09的check
# Modify.........: No:7829 03/08/18 Carol 單據程式中呼叫單據自動編號時,
#                                         應該是要包覆在 BEGIN WORK 中(transaction)
#                                         才會達到lock 的功能
# Modify.........: No:7842,8454 03/08/19 By Mandy 在PQC檢驗後,如原拒收,後特採,則可以可報工量應加進來
# Modify.........: No.MOD-490371 04/09/22 By Yuna Controlp 未加display
# Modify.........: MOD-490433 04/09/24 ching 重算shb17
# Modify.........: No.MOD-4A0307 04/10/25 By Mandy AFTER INSERT IF INT_FLAG THEN ......�面用CANCEL INSERT END IF
# Modify.........: No.MOD-4A0252 04/10/26 By Smapmin 下製程開窗
# Modify.........: No.MOD-4A0248 04/10/28 By Yuna QBE開窗開不出來
# Modify.........: No.FUN-4B0011 04/11/02 By Carol 新增 I,T,Q類 單身資料轉 EXCEL功能(包含假雙檔)
# Modify.........: No.FUN-4C0035 04/12/08 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.MOD-530479 05/03/28 By Carol 報工時間輸入時，應檢查必需大於開工時間。
# Modify.........: No.MOD-530497 05/04/01 By Carol 良品量大於WIP量,以WIP量代入
# Modify.........: No.FUN-550067 05/05/31 By Trisy 單據編號加大
# Modify.........: No.FUN-560164 05/10/05 By pengu  於查詢時，料號增加可查詢的功能
# Modify.........: NO.FUN-560053 05/10/22 BY Yiting 指出目前尚未進行check-in,checkin-hold,checkout-hold動作
# Modify.........: No.FUN-5B0113 05/11/22 By Claire 修改單身後單頭的資料更改者及最近修改日應update
# Modify.........: No.TQC-5C0060 05/12/12 By kim show()時,不執行check-in訊息
# Modify.........: No.TQC-630068 06/03/07 By Sarah 指定單據編號、執行功能
# Modify.........: No.MOD-640104 06/04/11 By Carol 製程中委外,應修改報工單委外未入庫ok前應不可報工
# Modify.........: No.MOD-640327 06/04/11 By Carol 已做Check In後報工,不應出現(asf-082)的警告訊息(未做Check IN),但仍可報工
# Modify.........: No.MOD-640122 06/04/11 By Carol 將報廢量回寫工單單頭的報廢數量
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.TQC-660067 06/06/14 By Sarah p_flow功能補強
# Modify.........: No.FUN-560052 06/06/22 By kim 生產日報當站報廢數量與缺點數量要與作勾機
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-670087 06/07/20 By Pengu 製程報工時應把良品轉出不得為零的限制拿掉
# Modify.........: No.FUN-680033 06/08/16 By kim GP3.5 成本改善-工單轉出改以asft703的功能畫面來維護
# Modify.........: No.FUN-680121 06/09/19 By huchenghao 類型轉換
# Modify.........: No.FUN-690022 06/09/22 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/10 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-6A0164 06/11/22 By jamie 1.FUNCTION _fetch() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.MOD-690007 06/12/06 By pengu 無法由狀態頁查詢資料
# Modify.........: No.CHI-710049 07/02/02 By rainy INSERT INTO shb_file 的的 BEGIN WORK 與t700_upd_ecm的BEGIN WORK 應合併
# Modify.........: No.TQC-6C0206 07/03/06 By pengu 製程委外入庫後若需做PQC時,若未做PQC時在AFTER FIELD sfb111會照成無窮迴圈
# Modify.........: No.TQC-720063 07/03/21 By Judy 錄入時,開窗字段"移轉單號"錄入任何值不報錯
# Modify.........: No.FUN-730075 07/03/30 By kim 行業別架構
# Modify.........: No.MOD-750010 07/05/03 By kim 先將生產日報維護存檔後按功能鍵工單轉出維護也沒有反應
# Modify.........: No.CHI-750006 07/05/08 By kim 工單轉出和轉入量不相等時提示之
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-760108 07/06/20 By xufeng 本站的轉出單位和下一站的轉入單位不同時，寫入下一站的良品轉入數量沒有考慮轉換單位
# Modify.........: NO.MOD-7B0117 07/11/13 BY Yiting 投入工時反推開工時間時，算出來為Null的話，不清掉預設值
# Modify.........: No.CHI-7B0023/CHI-7B0039 07/11/16 By kim 移除GP5.0行業別功能的所有程式段
# Modify.........: No.FUN-810017 08/01/14 By jan 增加服飾作業
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.MOD-830105 08/03/19 By Pengu 判斷若報工單是最後一站時則在刪除時判斷是否有FQC單
# Modify.........: No.MOD-830125 08/03/24 By Pengu 報工時未考慮轉入單位與轉出單位的轉換率
# Modify.........: No.FUN-830088 08/04/01 By hongmei sgdslk01-->sgd14 將行業別字段修改為一般行業字段
# Modify.........: No.FUN-840042 08/04/16 by TSD.Wind 自訂欄位功能修改 
# Modify.........: No.MOD-840122 08/04/19 By Pengu 更新工單報廢數量sfb12未考慮轉換率
# Modify.........: No.MOD-840414 08/04/28 By Pengu 製程委外若未產生採購單時則允許內製
# Modify.........: No.MOD-860029 08/06/03 By claire 製程委外若未產生採購單時則允許內製
# Modify.........: No.CHI-840069 08/06/09 By Sherry 轉出應判斷足套數
# Modify.........: No.TQC-810076 08/07/16 By lutingting 工單第二站的轉出單位與轉入單位不同的情況下，在生產日報維護作業中，AFTER FIELD shb111中判斷良品轉出數量與在制量的時候，良品轉出數量沒有進行單位換算便進行比較 
# Modify.........: No.MOD-870196 08/07/16 By kim 當重工轉出(shb113)數量大於0時則下製成欄位(shb12)強制要輸入
# Modify.........: No.FUN-870092 08/08/31 By Mandy 平行加工
# Modify.........: No.TQC-890064 08/09/30 By Mandy 平行加工測試BUG(1)與APS整合時,asft700的shb09一律改成資源編號
# Modify.........: No.TQC-890064 08/09/30 By Mandy 平行加工測試BUG(2)asft700的資源編號抓取來源是依sma917定義,而決定撈取工作站(ecm06) or機器(ecm05)
# Modify.........: No.TQC-890064 08/09/30 By Mandy 平行加工測試BUG(3)asft700若非平行加工的工作站,資源編號欄位帶出後,則不允許修改
# Modify.........: No.TQC-8A0013 08/10/07 By Mandy 當整體參數設定為"工作站"時,asft700報工時,資源編號應帶"工作站"的資料
# Modify.........: No.MOD-8C0205 08/12/22 By claire 刪除時不可存在有PQC單據
# Modify.........: No.MOD-910198 09/01/16 By sherry 未生成委外采購單時，增加提示
# Modify.........: No.FUN-910076 09/02/02 By jan 增加'投入機時'欄位
# Modify.........: No.MOD-920089 09/02/06 By claire 若本站沒有重工轉出不需check上站有無重工轉入
# Modify.........: No.FUN-910053 09/02/12 By jan sma74-->ima153
# Modify.........: No.MOD-920276 09/02/20 By chenyu 制程委外的工單，不可以直接錄入，需要按右邊按鈕"委外包工輸入"錄入
# Modify.........: No.MOD-930068 09/03/06 By shiwuying 報工單問題
# Modify.........: No.FUN-930105 09/03/16 By lilingyu 工藝移轉增加功能
# Modify.........: No.FUN-940113 09/04/22 By lilingyu modify FUN-930105 some bug
# Modify.........: No.MOD-940360 09/04/27 By sherry 已存在的報工資料須先清除再重新產生  
# Modify.........: No.TQC-960363 09/06/25 By sherry 新增時，修改作業編號手key時會報錯
# Modify.........: No.TQC-960031 09/07/08 By lilingyu Bonus欄位輸入負數沒有控管
# Modify.........: No.MOD-960352 09/06/30 By mike 檢核asf-828錯誤訊息時，應排除已作廢的FQC單 
# Modify.........: No.TQC-970251 09/07/24 By lilingyu 新增狀態下,進入單別選擇界面,無"重新查詢"按鈕
# Modify.........: No.FUN-980008 09/08/14 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-980228 09/08/20 By sherry “作業編號”欄位錄入沒有輪到或者是已經報工的作業編號，沒有控管！
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-990032 09/09/09 By sherry 還原TQC-980228的改法
# Modify.........: No.MOD-990238 09/10/09 By lilingyu 當生產轉移量>FQC量的時候,而這些多出來的量是分開的生產報工單轉移的,就可以刪除
# Modify.........: No.FUN-9B0045 09/11/06 BY liuxqa substring 
# Modify.........: No:MOD-990028 09/11/12 By sabrina 工單應卡成會結案,不是工單狀態的結案
# Modify.........: No:MOD-9B0151 09/11/25 By lilingyu 產品工藝資料中如果有2筆作業編號,但工序不一樣的資料,生產報工時,作業編號開窗選擇了其中一道工序后,仍然會跳出窗口繼續選擇
# Modify.........: No:MOD-9C0196 09/12/23 By baofei 增加報錯信息
# Modify.........: No:MOD-9C0197 09/12/23 By baofei 增加報錯信息 
# Modify.........: No.FUN-9C0072 10/01/11 By vealxu 精簡程式碼
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造 
#                                                 成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No.TQC-A50102 10/05/25 By houlia 傳參錯誤，調整為傳“asf”
# Modify.........: No:MOD-A50114 10/05/24 By Sarah 若該製程有check-in的程序,應該以check-in的日期、時間預設開工日期、時間
# Modify.........: No:CHI-A50025 10/05/25 By Summer 當連續新增時，則在第二次的新增時,則單據別、線班別、工作站、機台編號、作業編號欄位均預設上一筆新增的資料
# Modify.........: No:FUN-A50066 10/06/10 By jan 平行工艺功能 新增shb012
# Modify.........: No:FUN-A60087 10/06/25 By jan 平行工艺功能修正 
# Modify.........: No:FUN-A60095 10/07/09 By jan 平行工藝調整 
# Modify.........: No:MOD-A70110 10/07/14 By Smapmin 由入庫單傳入的狀況下,輸入完資料後要能停留在畫面上
# Modify.........: No:FUN-A70143 10/07/29 By jan 平行工藝調整,(組成用量/底數賦值調整) 
# Modify.........: No:TQC-A80085 10/08/17 By destiny 从委外报工录入时在作业编号检查段依然会要求从委外报工录入或从入库单点转报工单录入
# Modify.........: No:FUN-A80102 10/08/18 By kim GP5.25號機管理
# Modify.........: No:MOD-A80233 10/08/30 By Summer 將shb021的default取消換成shb031欄位的default值
# Modify.........: No:TQC-A90153 10/09/29 By destiny 录入时不参照4fd设定的顺序
# Modify.........: No:FUN-A80060 10/09/28 By jan GP5.25工單間合拼
# Modify.........: No:MOD-AA0015 10/10/06 By sabrina 刪除時應檢核報工日是否小於關帳日
# Modify.........: No.FUN-AA0059 10/10/26 By chenying 料號開窗控管 
# Modify.........: No.FUN-AB0049 10/11/11 By zhangll 倉庫營運中心權限修改
# Modify.........: No.TQC-AB0331 10/12/09 By vealxu 問題1：前提：asft700中一個工單存在多筆資料，且其中一筆是委外入庫產生的時候
#                                                          當刪除這筆委外入庫單後，無法點擊查詢按鈕
#                                                   問題2：點擊新增，日報表資料二裡面委外入庫單號，以及項次自動出現，錄入制程段號開窗時抓不到數據
#                                                   問題3：刪除移轉單號，提示asf-723有PQC資料錯誤
#                                                   問題4：asft700委外入庫單開窗，應只能打開工藝委外入庫單
# Modify.........: NO.TQC-AC0294 10/12/20 By liweie sfu01開窗/檢查要排除smy73='Y'的單據
# Modify.........: NO.TQC-AC0277 10/12/21 By 本製程有委外時,判斷若可委外量>0,則可以手動輸入
# Modify.........: No:MOD-940266 10/12/25 By sabrina 在單身下查詢條件,查出來得筆數有問題
# Modify.........: No:MOD-AC0336 10/12/28 By jan 重抓製程料號
# Modify.........: No.FUN-B10056 11/02/15 By vealxu 修改制程段號的管控
# Modify.........: No.TQC-B20083 11/02/17 By jan 1.報工單檢查邏輯錯誤
# .............................................. 2.計算該站可報工量齊套數應再考慮該站的轉換率,目前沒有考慮
# Modify.........: No.FUN-B20097 11/03/04 By lixh1 加強轉出製程段號的控卡,至少不能轉給下游以後的製程段
# Modify.........: No.FUN-B30035 11/03/11 By jan FUN-B20097 程式調整
# Modify.........: No.TQC-B30125 11/03/16 By destiny 向sfu_file插值时，sfu01没有赋值 
# Modify.........: No.TQC-B30126 11/03/16 By destiny 转FQC单时，qc单单身的检验量没有自动带出值来
# Modify.........: No.FUN-B30096 11/03/29 By lixh1   製程段號開窗增加同"作業編號"開窗裡的"WIP數量"
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:TQC-B30192 11/04/01 By destiny 报工完后串查按钮没有隐藏               
# Modify.........: No:TQC-B30194 11/04/01 By destiny 如果该工单需FQC检验则不勾选生成FQC时会提示   
# Modify.........: No:FUN-B20079 11/04/02 By shenyang 修改製成段號 工作單號製成序的邏輯
# Modify.........: No.FUN-B40029 11/04/13 By xianghui 修改substr
# Modify.........: No.TQC-B40197 11/04/25 By destiny sfu15,sfumksg没有赋值
# Modify.........: No.TQC-B40207 11/04/26 By destiny 删除时信息一直停留在update ecm_file
# Modify.........: No.FUN-A80128 11/04/29 By Mandy 因asft620 新增EasyFlow整合功能影響INSERT INTO sfu_file
# Modify.........: No.FUN-B50046 11/05/10 By Abby GP5.25 APS追版 str----------
# Modify.........: No:FUN-960106 09/07/03 By Duke 鎖定設備相關設定
# Modify.........: No:FUN-980080 09/08/20 By Mandy APS多機台鎖定功能調整
# Modify.........: No:FUN-990094 09/10/05 By Mandy (1)回報鎖定設備未完成量調整
#                                                  (2)刪除生產日報後,良品轉出量(vne311)應減少才對
# Modify.........: No.FUN-B50046 11/05/10 By Abby GP5.25 APS追版 end----------
# Modify.........: No.FUN-A70095 11/05/31 By lixh1 增加修改,確認,取消確認,作廢,取消作廢四个action
# Modify.........: No.TQC-B60127 11/06/16 By lixh1 asf-995 提示信息確認后回asft730界面
# Modify.........: No.TQC-B60129 11/06/17 By lixh1 如果工單是需要進行'FQC'在生成入庫單時如果沒有先生成'FQC'單應給出提示
# Modify.........: No.TQC-B60219 11/06/21 By lixh1 當單據是通過“委外報工錄入”按鈕進行操作的,“員工編號”欄位保存時沒有校驗控管
# Modify.........: No.TQC-B60232 11/06/21 By zhangll 增加smyapr取值
# Modify.........: No:FUN-B70074 11/07/26 By fengrui 添加行業別表的新增於刪除
# Modify.........: No:MOD-B70227 11/08/18 By Vampire 請調整g_sma.sma541 ='Y'才將shb121設成"TRUE"
# Modify.........: No.MOD-B70226 11/08/22 By Carrier 返工转出量>0时,制程段无条件显示出来了,没有考虑sma541的参数
# Modify.........: No:MOD-B80026 11/08/22 By Carrier 删除资料时,报ecm_file 100的错误,修改_r()中TRANSACTION的内容
# Modify.........: No:MOD-B90104 11/09/16 By johung 開放ACTION 轉FQC/入庫單、FQC單維護、入庫單維護
# Modify.........: No:MOD-B90209 11/09/26 By johung mark 沒使用到的變數 g_shbconf
# Modify.........: No:TQC-BA0003 11/10/06 By jason 修正快速輸入的幾項問題
# Modify.........: No:CHI-B90015 11/10/31 By johung 生產料號為聯產品，asms270設定使用聯產品且認定聯產品的時機為2:完工入庫
#                                                   轉入庫單時聯產品應給Y
# Modify.........: No:MOD-BB0116 11/11/12 By johung 轉入庫單時預設帶工單的倉儲
# Modify.........: No.FUN-BB0086 11/12/08 By tanxc 增加數量欄位小數取位
# Modify.........: No.FUN-BB0085 11/12/13 By xianghui 增加數量欄位小數取位
# Modify.........: No.MOD-C10055 12/01/06 By bart 修改NEXT FIELD錯誤
# Modify.........: No:TQC-BB0197 11/11/30 By destiny 工时计算错误                             
# Modify.........: No:TQC-BC0182 11/12/31 By destiny 审核时应检查该工单下该作业编号是否有转出量
# Modify.........: No.FUN-BC0104 12/01/11 By xianghui 增加是否依QC結果判定產生入庫單

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:TQC-C20008 12/02/02 By zhangll 審核時增加可報工量的控管
# Modify.........: No:TQC-BB0221 12/02/13 By Carrier 报工单审核时,可以点"工单转出"的BUTTON,呼叫asft703
# Modify.........: No:MOD-C20006 12/02/16 By Elise 增加sfb27、sfb271,產生入庫單後，作入庫單維護時，單身的sfv41/sfv42應該要分別等於工單的sfb27/sfb271
# Modify.........: No:TQC-C20245 12/02/20 by destiny 删除时需要点击2次才能删除
# Modify.........: No:TQC-C20248 12/02/21 By lixh1 回寫入庫單號
# Modify.........: No.TQC-C20240 12/02/21 By xianghui choice3勾選時choice1不需要必須勾選
# Modify.........: No.TQC-C20334 12/02/21 By destiny emc03 改为ecm03                  
# Modify.........: No.TQC-C20361 12/02/22 By lixh1 重新啟動asf-133提示信息
# Modify.........: No.TQC-C20465 12/02/24 By lixh1 INSERT INTO sfv_file 時如果倉儲批為null則給' '
# Modify.........: No:TQC-C10122 12/02/28 By lilingyu 開窗選擇作業編號可以過，但是手工錄入無法通過
# Modify.........: No:TQC-C60154 12/06/19 By lixh1 TQC-BC0182沒有撈取sfb93直接使用
# Modify.........: No:FUN-C30085 12/07/05 By nanbing CR改串GR
# Modify.........: No:MOD-C70046 12/07/19 By ck2yuan 在取消確認需控卡shb32不可小於關帳日期
# Modify.........: No:MOD-C60147 12/07/19 By ck2yuan mark TQC-C10122,修正TQC-C10122修改方向
# Modify.........: No:MOD-C60239 12/07/19 By ck2yuan shb05編碼方式改為一般的輸入格式
# Modify.........: No:MOD-C80032 12/08/06 By Elise 已確認不可再確認，應出現"此單據已確認"
# Modify.........: No:CHI-C50054 12/08/13 By ck2yuan 委外報工時,不勾稽wip量勾稽入庫量,並開放分批報工與良品轉出數量修改
# Modify.........: No:CHI-C60008 12/08/15 By ck2yuan 將 t701_update img,ima,tlf部分移至確認與取消確認段
# Modify.........: No:MOD-C80257 12/09/20 By Elise 第二輪轉的FQC單，其"送驗量qcf22"和"檢驗量qcg11"為負值
# Modify.........: No:MOD-C90057 12/09/20 By Elise after field shb02增加asf-904控卡
# Modify.........: No:MOD-C90059 12/09/20 By Elise 轉FQC單action要依這張移轉單的數量轉FQC
# Modify.........: No:MOD-CA0066 12/10/26 By suncx 如果該站都是不需發料料件（即應付數量為0），則在轉出時不需判斷最小發料數量
# Modify.........: No:CHI-C90043 12/11/05 By bart 產生fqc單時，判斷fqc是否存在時要排除作廢資料
# Modify.........: No.FUN-CB0014 12/11/13 By fengrui 增加資料清單
# Modify.........: No:MOD-CB0088 12/11/23 By Elise 報工單作廢後再點選"轉生產日報",應排除作廢單據
# Modify.........: No.TQC-CB0084 12/11/26 By fengrui 資料清單添加制程段
# Modify.........: No:MOD-CA0149 12/12/17 By Elise 排除作廢單據
# Modify.........: No:MOD-CB0209 12/12/17 By Elise 最後一站轉出時，轉出數量若大於最小發料套數show錯誤訊息
# Modify.........: No.FUN-CB0087 12/12/20 By fengrui 倉庫單據理由碼改善
# Modify.........: No.FUN-C30163 12/12/28 By pauline CALL q_ecm(時增加參數
# Modify.........: No.MOD-CB0170 13/01/07 By Elise 工單合併功能只限於sfd09=2才檢核
# Modify.........: No:CHI-B70003 13/01/21 By Alberti 在刪除報工單資料時，三階段結案狀態為3時，則不允許刪除
# Modify.........: No.TQC-D10084 13/01/28 By xujing  資料清單頁簽不可點擊單身按鈕
# Modify.........: No:CHI-D20010 13/02/21 By yangtt 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:CHI-BA0035 13/03/06 By Alberti 判斷良品轉出量應考慮每站的bonus
#                                                   轉入庫單時帶入的入庫量應加上bonus
# Modify.........: No:MOD-D20173 13/03/07 By bart 標準工時/標準機時除以生產數量sfb08
# Modify.........: No:MOD-D30233 13/03/27 By bart 將t700_chk_input移回來
# Modify.........: No:DEV-D30045 13/03/29 By TSD.JIE 
#                  1.條碼產生時機點相關程式-增加"條碼查詢"
#                  2.條碼產生時機點相關程式-增加"條碼列印"
#                  3.條碼產生時機點相關程式-增加"條碼產生"
#                  3.調整確認自動產生barcode
#                  4.調整取消確認自動作廢barcode
# Modify.........: No:FUN-D40030 13/04/08 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No.DEV-D30043 13/04/17 By TSD.JIE 調整條碼自動編號(s_gen_barcode2)與條碼手動編號(s_diy_barcode)產生先後順序
# Modify.........: No.DEV-D40015 13/04/18 By Nina 調整取消確認時條碼作廢的檢核與Transaction
# Modify.........: No.FUN-D40092 13/04/25 By lixiang 對庫存的異動移到審核函數t700_sub中
# Modify.........: No.MOD-D60073 13/06/08 By suncx 報工單檢查齊料套數調用s_minp_routing不適合，應調用s_minp()函數
# Modify.........: No.MOD-D60240 13/06/28 By suncx 管控責任工藝段和工藝序只能錄入當站或當站以前的
# Modify.........: No:TQC-DB0074 13/11/28 By wangrr 當轉入庫單時刪除只產生單頭的無效入庫單資料,且在轉出成功后顯示提示信息

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_argv1         LIKE shb_file.shb14,     #No.FUN-680121 VARCHAR(16), #TQC-630068
    g_argv2         STRING,                  #TQC-630068
    g_argv3         LIKE rvv_file.rvv01,     #TQC-630068 從g_argv1->g_argv3
    g_argv4         LIKE rvv_file.rvv02,     #TQC-630068 從g_argv2->g_argv4
    g_argv5         LIKE type_file.chr1,     #No.FUN-680121 VARCHAR(1), #TQC-630068 從g_argv3->g_argv5
    g_argv6         LIKE shb_file.shb05,     #FUN-A80060
    g_shb           RECORD LIKE shb_file.*,
    g_shb_t         RECORD LIKE shb_file.*,
    g_shb_o         RECORD LIKE shb_file.*,
    g_rvv           RECORD LIKE rvv_file.*,
    g_ecm           RECORD LIKE ecm_file.*,
    g_h1,g_h2,g_m1,g_m2,g_sum_m1,g_sum_m2    LIKE type_file.num5,    #No.FUN-680121 SMALLINT,              #
    b_shc           RECORD LIKE shc_file.*,
    g_sfb           RECORD LIKE sfb_file.*,
    m_shd           RECORD LIKE shd_file.*,
    g_ima02         LIKE ima_file.ima02,
    g_ima021        LIKE ima_file.ima021,
    g_shc           DYNAMIC ARRAY OF RECORD    #程式變數(Prinram Variables)
                    shc03     LIKE shc_file.shc03,
                    shc04     LIKE shc_file.shc04,
                    qce03     LIKE qce_file.qce03,
                    shc05     LIKE shc_file.shc05,
                    shc012    LIKE shc_file.shc012,   #FUN-A60095
                    shc06     LIKE shc_file.shc06,
                    ecm04     LIKE ecm_file.ecm04
                    END RECORD,
    g_shc_t         RECORD
                    shc03     LIKE shc_file.shc03,
                    shc04     LIKE shc_file.shc04,
                    qce03     LIKE qce_file.qce03,
                    shc05     LIKE shc_file.shc05,
                    shc012    LIKE shc_file.shc012,   #FUN-A60095
                    shc06     LIKE shc_file.shc06,
                    ecm04     LIKE ecm_file.ecm04
                    END RECORD,
     g_shb01_t      LIKE shb_file.shb01,   #FUN-B50178    
     g_wc,g_wc2,g_wc3    string,  #No.FUN-580092 HCN
     g_sql               string,  #No.FUN-580092 HCN
     g_wip_qty       LIKE shb_file.shb111,   #MOD-530497
    g_pmn46         LIKE pmn_file.pmn46,
    g_ecm04         LIKE ecm_file.ecm04,
    g_ecm05         LIKE ecm_file.ecm05,
    g_ecm58         LIKE ecm_file.ecm58,
   #g_shbconf,g_sw  LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(1),   #MOD-B90209 mark
    g_sw            LIKE type_file.chr1,    #MOD-B90209
    g_t1            LIKE oay_file.oayslip,  #No.FUN-550067  #No.FUN-680121 VARCHAR(05)
    g_t2            LIKE oay_file.oayslip,  #NO.FUN-930105
    g_buf           LIKE type_file.chr1000, #No.FUN-680121 VARCHAR(20)
    l_cmd           LIKE type_file.chr1000, #No.FUN-680121 VARCHAR(300)
    l_wc            LIKE type_file.chr1000, #No.FUN-680121 VARCHAR(300)
#   issue_qty2      LIKE ima_file.ima26,    #No.FUN-680121 DEC(15,3),
    issue_qty2      LIKE type_file.num15_3, ###GP5.2  #NO.FUN-A20044
    g_rec_b         LIKE type_file.num5,    #單身筆數  #No.FUN-680121 SMALLINT
    g_cmd           LIKE type_file.chr1000, #No.FUN-680121 VARCHAR(100)
    l_ac            LIKE type_file.num5     #目前處理的ARRAY CNT  #No.FUN-680121 SMALLINT

#FUN-CB0014---add---str---
DEFINE g_shb_l DYNAMIC ARRAY OF RECORD
            shb01   LIKE shb_file.shb01,
            shb04   LIKE shb_file.shb04,
            gen02   LIKE gen_file.gen02,
            shb05   LIKE shb_file.shb05,
            shb081  LIKE shb_file.shb081,
            shb082  LIKE shb_file.shb082, 
            shb012  LIKE shb_file.shb012, #TQC-CB0084 add
            ecu014  LIKE ecu_file.ecu014, #TQC-CB0084 add
            shb06   LIKE shb_file.shb06,
            shbconf LIKE shb_file.shbconf,
            shb10   LIKE shb_file.shb10,
            ima02   LIKE ima_file.ima02,
            ima021  LIKE ima_file.ima021,
            shb111  LIKE shb_file.shb111,
            shb34   LIKE shb_file.shb34,
            shb21   LIKE shb_file.shb21,
            shb22   LIKE shb_file.shb22
               END RECORD
DEFINE l_ac2    LIKE type_file.num5
DEFINE g_rec_b2 LIKE type_file.num5  
DEFINE g_action_flag   STRING
DEFINE w        ui.Window
DEFINE f        ui.Form
DEFINE page     om.DomNode
#FUN-CB0014---add---end---
DEFINE g_forupd_sql STRING                       #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5  #No.FUN-680121 SMALLINT
 
 
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680121 INTEGER
DEFINE   g_cnt2          LIKE type_file.num10   #FUN-960106 ADD 
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-680121 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000  #No.FUN-680121 VARCHAR(72)
 
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-680121 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-680121 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-680121 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5    #No.FUN-680121 SMALLINT
DEFINE   g_min_set      LIKE sfb_file.sfb08    #CHI-840069
DEFINE   g_re_dis_vne06 LIKE type_file.num20   #FUN-990094 add
DEFINE   g_shb_bak      RECORD LIKE shb_file.*     
DEFINE   g_gen02        LIKE gen_file.gen02
DEFINE   gg_ima02        LIKE ima_file.ima02
DEFINE   gg_ima021       LIKE ima_file.ima021
DEFINE   g_wip          LIKE shb_file.shb111
DEFINE   g_pqc          LIKE shb_file.shb111
DEFINE   g_tot_pqc      LIKE shb_file.shb111
DEFINE   g_ecm53        LIKE ecm_file.ecm53
DEFINE   g_ecm54        LIKE ecm_file.ecm54 
DEFINE   g_shb21        LIKE shb_file.shb21                                                                                         
DEFINE   g_shb22        LIKE shb_file.shb22                                                                                         
DEFINE   g_wh1          LIKE img_file.img02                                                                                         
DEFINE   g_wh2          LIKE img_file.img03                                                                                         
DEFINE   g_wh3          LIKE img_file.img04  
DEFINE   g_emp          LIKE gen_file.gen01
#DEFINE   g_shb06        LIKE shb_file.shb06    #MOD-9B0151  #FUN-A80102 mark
#DEFINE   g_chr          LIKE type_file.chr1    #MOD-9B0151  #FUN-A80102 mark
#CHI-A50025 add --start--
DEFINE   g_sheet        LIKE oay_file.oayslip  #單別 (沿用)
DEFINE   g_shb08        LIKE shb_file.shb08    #線班別 (沿用)
DEFINE   g_shb07        LIKE shb_file.shb07    #工作站 (沿用)
DEFINE   g_shb09        LIKE shb_file.shb09    #機台編號 (沿用)
DEFINE   g_shb081       LIKE shb_file.shb081   #作業編號 (沿用)
#CHI-A50025 add --end--
DEFINE   g_pmn012       LIKE pmn_file.pmn012   #FUN-A50066
DEFINE   g_chr          LIKE shb_file.shbconf  #FUN-A70095
DEFINE   g_chr1         LIKE shb_file.shbacti  #FUN-A70095
DEFINE   g_void         LIKE type_file.chr1    #FUN-A70095 
DEFINE   g_yy           LIKE type_file.num5    #FUN-A70095
DEFINE   g_mm           LIKE type_file.num5    #FUN-A70095
 
MAIN
    DEFINE      p_row,p_col  LIKE type_file.num5    #No.FUN-680121 SMALLINT #No.FUN-6A0090
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
       #FIELD ORDER FORM                   #整個畫面會依照p_per所設定的欄位順序(忽略4gl寫的順序)  #FUN-730075   #No.TQC-A90153
 
    DEFER INTERRUPT
 
    #可接收委外入庫單號與項次
    LET g_argv1=ARG_VAL(1)
    LET g_argv2=ARG_VAL(2)
    LET g_argv3=ARG_VAL(3)
    LET g_argv4=ARG_VAL(4)   #TQC-630068
    LET g_argv5=ARG_VAL(5)   #TQC-630068
    LET g_argv6=ARG_VAL(6)   #FUN-A80060
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("ASF")) THEN
       EXIT PROGRAM
    END IF
 
    LET p_row = 1
    LET p_col = 10
    OPEN WINDOW t700_w AT p_row,p_col WITH FORM "asf/42f/asft700"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
    CALL cl_ui_init()
    CALL t700_def_form()   #TQC-890064 add

    #DEV-D30045--add--begin
    IF g_aza.aza131 = 'N' THEN
       CALL cl_set_act_visible("barcode_gen,barcode_query,barcode_output", FALSE)
    END IF
    #DEV-D30045--add--end
 
    #start TQC-630068
     # 先以g_argv2判斷直接執行哪種功能：
     IF NOT cl_null(g_argv1) OR NOT cl_null(g_argv6) THEN #FUN-A80060
        CASE g_argv2
           WHEN "query"
              LET g_action_choice = "query"
              IF cl_chk_act_auth() THEN
                 CALL t700_q()
              END IF
           WHEN "insert"
              LET g_action_choice = "insert"
              IF cl_chk_act_auth() THEN
                  CALL t700_a('','')        #NO.FUN-940113
              END IF
           OTHERWISE          #TQC-660067 add
              CALL t700_q()   #TQC-660067 add 
        END CASE
     END IF
 
    CALL t700()
 
    CLOSE WINDOW t700_w                         #結束畫面
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
 
END MAIN
 
FUNCTION t700()
  DEFINE l_za05        LIKE type_file.chr1000 #No.FUN-680121 VARCHAR(40)
 
    LET g_wc2 =' 1=1'
    LET g_wc3 =' 1=1'
 
    LET g_forupd_sql = "SELECT * FROM shb_file WHERE shb01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t700_cl CURSOR FROM g_forupd_sql
 
    IF cl_null(g_argv3) AND cl_null(g_argv4) THEN   #TQC-630068
       CALL t700_menu()
    ELSE
       LET g_action_choice="insert"
       IF NOT cl_chk_act_auth() THEN RETURN END IF
       MESSAGE ""
       CLEAR FORM
       CALL g_shc.clear()
       SELECT COUNT(*) INTO g_cnt FROM shb_file #check是否已產生報工單
        WHERE shb14 = g_argv3 AND shb15 =g_argv4   #TQC-630068
          AND shbconf != 'X'   #MOD-CB0088 add
       IF g_cnt > 0 THEN #已存在的報工資料須先清除再重新產生
          CALL t700_q()
          CALL cl_err('','asf-116',1)                                                                                               
       ELSE
          SELECT rvv_file.* INTO g_rvv.* FROM rvv_file,rvu_file
           WHERE rvu01=g_argv3 AND rvuconf = 'Y'
             AND rvu01 = rvv01 AND rvv02=g_argv4
          IF STATUS THEN
             CALL cl_err('sel rvv','asf-700',1)
          ELSE
             LET g_argv5='a'   #TQC-630068
             SELECT pmn46,pmn012    #FUN-A50066
               INTO g_pmn46,g_pmn012 FROM pmn_file,rvb_file  #讀取製程序號 #FUN-A50066
              WHERE rvb01=g_rvv.rvv04 AND rvb02=g_rvv.rvv05
                AND rvb04=pmn01 AND rvb03=pmn02
             IF STATUS THEN
                LET g_pmn46=NULL 
                LET g_pmn012=NULL  #FUN-A50066
             ELSE
                SELECT ecm04,ecm05,ecm58
                  INTO g_ecm04,g_ecm05,g_ecm58
                  FROM ecm_file
                 WHERE ecm01=g_rvv.rvv18 AND ecm03=g_pmn46
                   AND ecm012=g_pmn012   #FUN-A50066
                 IF STATUS THEN
                    LET g_ecm04=NULL
                    LET g_ecm05=NULL
                 END IF
             END IF
          END IF
          CALL t700_a('','')        #NO.FUN-940113
          #-----MOD-A70110---------
          #MOD-B90104 remove fqc2,trans_fqc,trans_store
          CALL cl_set_act_visible("insert,query,delete,detail,
                                   fast_input,
                                   input_sub_report,
                                   direct_st_in,shift_working_hours,
                                   wo_routing_qt_status,wo_tr_o,wo_tr_o_qry",FALSE)
          CALL t700_menu()  
          #-----END MOD-A70110-----
       END IF
    END IF
 
END FUNCTION
 
FUNCTION t700_cs()
DEFINE lc_qbe_sn    LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
DEFINE l_buf        LIKE type_file.chr1000    #No.FUN-680121 VARCHAR(600)
DEFINE l_length,l_i LIKE type_file.num5       #No.FUN-680121 SMALLINT
 
  IF cl_null(g_argv1) AND cl_null(g_argv3) AND cl_null(g_argv6) THEN   #TQC-630068 #FUN-A80060
     CLEAR FORM                     #清除畫面
     CALL g_shc.clear()
     CALL cl_set_head_visible("","YES")           #NO.FUN-6B0031 
     INITIALIZE g_shb.* TO NULL                   #No.FUN-750051
     CONSTRUCT BY NAME g_wc ON shb01,shb04,shb05,shb012,shb081,shb082,shb06,shbconf,shb10,  #No.FUN-A50066   #FUN-A70095
                               shbuser,shbgrup,shbmodu,shbdate,                     #No.MOD-690007 add
                               shb08,shb07,shb09,shb02,shb021,shb03,shb031,
                               shb032,shb111,shb115,shb112,shb113,shb12,shb121,     #FUN-A50066 
                               shb114,shb17,shb31,shb26,shb30,shb27,shb21,shb22,  #FUN-910076 add shb033   #FUN-930105 add shb21 shb22  #FUN-A80102
                               shb28,shb29,shb14,shb15,shb13,shb033,shb32,    #FUN-A80102   #FUN-A70095 add shb32
                               shbud01,shbud02,shbud03,shbud04,shbud05,
                               shbud06,shbud07,shbud08,shbud09,shbud10,
                               shbud11,shbud12,shbud13,shbud14,shbud15
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
        ON ACTION controlp
           CASE WHEN INFIELD(shb01) #查詢單据
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form     ="q_shb"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO shb01
                     NEXT FIELD shb01
                WHEN INFIELD(shb04)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form     ="q_gen"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO shb04
                     NEXT FIELD shb04
                WHEN INFIELD(shb07)
                     CALL q_eca(TRUE,TRUE,g_shb.shb07) RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO shb07
                     NEXT FIELD shb07
                WHEN INFIELD(shb09)                 #機械編號
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form     = "q_eci"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO shb09
                     NEXT FIELD shb09
                WHEN INFIELD(shb05)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form ="q_sfb2402"
                     LET g_qryparam.construct = "Y"
                     LET g_qryparam.default1 = g_shb.shb05
                     LET g_qryparam.arg1     = 234567
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO shb05
                     NEXT FIELD shb05
                #No.FUN-A50066  --Begin
                WHEN INFIELD(shb012)   #工艺段号
#FUN-B30096 -------------------Begin-----------------------
               #     CALL cl_init_qry_var()
               #     LET g_qryparam.state    = "c"
               #   # LET g_qryparam.form     = "q_ecu012_1"     #FUN-B10056 mark
               #     LET g_qryparam.form     = "q_ecb012_1"     #FUN-B10056
               #     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     CALL q_ecm03(TRUE,TRUE,g_shb.shb05,'','','') RETURNING g_qryparam.multiret
#FUN-B30096 -------------------End-------------------------
                     DISPLAY g_qryparam.multiret TO shb012
                     NEXT FIELD shb012
                #No.FUN-A50066  --End 
                WHEN INFIELD(shb08)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form     = "q_ecg"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO shb08
                     NEXT FIELD shb08
                WHEN INFIELD(shb10)
#FUN-AA0059---------mod------------str-----------------                
#                     CALL cl_init_qry_var()
#                     LET g_qryparam.state    = "c"
#                     LET g_qryparam.form     = "q_ima"
#                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                     DISPLAY g_qryparam.multiret TO shb10
                     NEXT FIELD shb10
                WHEN INFIELD(shb081)
                     CALL q_ecm02(TRUE,TRUE,g_shb.shb05,'') RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO shb081
                     NEXT FIELD shb081
                WHEN INFIELD(shb12)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form     = "q_ecm3"  #MOD-4A0252
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO shb12
                     NEXT FIELD shb12
                #No.FUN-A50066  --Begin
                WHEN INFIELD(shb121)  #重工轉出下製程段
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                   # LET g_qryparam.form     = "q_ecu012_1"      #FUN-B10056 mark
                      LET g_qryparam.form    = "q_ecb012_1"      #FUN-B10056     
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO shb121
                     NEXT FIELD shb121
                #No.FUN-A50066  --End 
                WHEN INFIELD(shb14)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                   # LET g_qryparam.form     = "q_rvv1"    #TQC-AB0331
                     LET g_qryparam.form     = "q_rvv4"    #TQC-AB0331
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO shb14
                     NEXT FIELD shb14
                
                 WHEN INFIELD(shb21)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form     = "q_shb21"
                     ##組合拆解的完工入庫單不顯示出來!                                                                                    #TQC-AC0294         
                    #LET g_qryparam.where = " substr(shb21,1,",g_doc_len,") NOT IN (SELECT smy71 FROM smy_file WHERE smy71 IS NOT NULL) " #TQC-AC0294         
                     LET g_qryparam.where = " shb21[1,",g_doc_len,"] NOT IN (SELECT smy71 FROM smy_file WHERE smy71 IS NOT NULL) "   #FUN-B40029
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO shb21
                     NEXT FIELD shb21
                  WHEN INFIELD(shb22)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form     = "q_shb22"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO shb22
                     NEXT FIELD shb22     
                  #FUN-A80102(S)
                  WHEN INFIELD(shb27)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form     = "q_pmc18"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO shb27
                     NEXT FIELD shb27     
                  WHEN INFIELD(shb28)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state= "c"
                     LET g_qryparam.form = "q_pmm9"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO shb28
                     NEXT FIELD shb28
                  WHEN INFIELD(shb29)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state= "c"
                     LET g_qryparam.form = "q_rva05"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO shb29
                     NEXT FIELD shb29
                  #FUN-A80102(E)
            END CASE
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE CONSTRUCT
 
                 ON ACTION qbe_select
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
     END CONSTRUCT
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond('shbuser', 'shbgrup') #FUN-980030
 
     IF INT_FLAG THEN RETURN END IF
 
     CONSTRUCT g_wc3 ON shc03,shc04,shc05,shc012,shc06   #FUN-A60095
          FROM s_shc[1].shc03,s_shc[1].shc04,s_shc[1].shc05,
               s_shc[1].shc012, s_shc[1].shc06           #FUN-A60095
 
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
        ON ACTION controlp
           CASE WHEN INFIELD(shc04)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form     = "q_qce"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO shc04
                     NEXT FIELD shc04
                #FUN-A60095--begin--add--------- 
                WHEN INFIELD(shc012)   #工艺段号
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                   # LET g_qryparam.form     = "q_ecu012_1"     #FUN-B10056 mark
                     LET g_qryparam.form     = "q_ecb012_1"     #FUN-B10056
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO shc012
                     NEXT FIELD shc012
                #FUN-A60095--end--add----------- 
                WHEN INFIELD(shc06)
                    #CALL q_ecm(TRUE,TRUE,g_shb.shb05,'')  #FUN-C30163 mark
                     CALL q_ecm(TRUE,TRUE,g_shb.shb05,'','','','','')  #FUN-C30163 add
                          RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO shc06
                     NEXT FIELD shc06
           END CASE
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE CONSTRUCT
 
        ON ACTION qbe_save
		       CALL cl_qbe_save()
     END CONSTRUCT
     IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
        LET g_wc3 = g_wc3 CLIPPED
     ELSE
        IF NOT cl_null(g_argv3) THEN
           LET g_wc ="shb14='",g_argv3,"' AND shb15=",g_argv4 CLIPPED
        END IF
        IF NOT cl_null(g_argv1) THEN
           IF cl_null(g_wc) THEN
              LET g_wc = " shb01='",g_argv1,"'"
           ELSE
              LET g_wc = g_wc," AND shb01='",g_argv1,"'"
           END IF
        END IF
        #FUN-A80060--begin--add------------
        IF NOT cl_null(g_argv6) THEN
           IF cl_null(g_wc) THEN
              LET g_wc=" shb05='",g_argv6,"'"
           ELSE
              LET g_wc=g_wc," AND shb05='",g_argv6,"'"
           END IF
        END IF
        #FUN-A80060--end--add---------------
        LET g_wc3 = " 1=1"
     END IF
 
     IF g_wc3 = " 1=1"  THEN
        LET g_sql = "SELECT shb01 FROM shb_file",
                    " WHERE (shb16 IS NULL OR shb16=' ') AND ", g_wc CLIPPED,
                    " ORDER BY shb01"
     ELSE
        LET g_sql = "SELECT UNIQUE shb01 ",
                    "  FROM shb_file, shc_file ",
                    " WHERE shb01 = shc01 ",
                    "   AND (shb16 IS NULL OR shb16=' ') AND ", g_wc CLIPPED,
                    "   AND ", g_wc3 CLIPPED,
                    " ORDER BY shb01"
     END IF
 
    PREPARE t700_prepare FROM g_sql
    DECLARE t700_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t700_prepare
    DECLARE t700_fill_cs CURSOR FOR t700_prepare    #FUN-CB0014 add
 
   #No.MOD-940266--start--modify
   #LET g_sql="SELECT COUNT(*) FROM shb_file WHERE (shb16 IS NULL OR shb16=' ') AND ",g_wc CLIPPED
    IF g_wc3 = " 1=1" THEN
       LET g_sql="SELECT COUNT(*) FROM shb_file WHERE (shb16 IS NULL OR shb16=' ') AND ",g_wc CLIPPED
    ELSE
       LET g_sql="SELECT COUNT(DISTINCT shb01) FROM shb_file,shc_file WHERE ",
                 "shb01=shc01 AND (shb16 IS NULL OR shb16=' ') AND ",g_wc CLIPPED," AND ",g_wc3 CLIPPED
    END IF  
   #No.MOD-940266--end--modify
    PREPARE t700_precount FROM g_sql
    DECLARE t700_count CURSOR FOR t700_precount
 
 
END FUNCTION
 
FUNCTION t700_menu()
DEFINE l_cnt       LIKE type_file.num10   #No.FUN-680121 INTEGER #FUN-680033
DEFINE l_shbacti   LIKE shb_file.shbacti  #NO.FUN-930105
DEFINE l_str       STRING                 #NO.FUN-930105
DEFINE l_ecm03     LIKE ecm_file.ecm03    #NO.FUN-940113
 
   WHILE TRUE
      IF cl_null(g_action_flag) OR g_action_flag = "page_main" THEN   #FUN-CB0014 add
         CALL t700_bp("G")
      #FUN-CB0014---add---str---
      ELSE                           
         CALL t700_list_fill()
         CALL t700_bp3("G")
         IF NOT cl_null(g_action_choice) AND l_ac2>0 THEN #將清單的資料回傳到主畫面
            SELECT shb_file.* INTO g_shb.*
              FROM shb_file
             WHERE shb01=g_shb_l[l_ac2].shb01
         END IF
         IF g_action_choice!= "" THEN
            LET g_action_flag = "page_main"
            LET l_ac2 = ARR_CURR()
            LET g_jump = l_ac2
            LET mi_no_ask = TRUE
            IF g_rec_b2 >0 THEN
               CALL t700_fetch('/')
            END IF
            CALL cl_set_comp_visible("info,page_list", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("info,page_list", TRUE)
          END IF               
      END IF  
      #FUN-CB0014---add---str--
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
                  CALL t700_a('','')        #NO.FUN-940113
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t700_q()
            END IF
#FUN-A70095 --------Begin------------
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t700_u('','')
            END IF
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t700_confirm()
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t700_unconfirm()
            END IF     
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL t700_x()   #CHI-D20010
               CALL t700_x(1)  #CHI-D20010
               IF g_shb.shbconf = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_shb.shbconf,"","","",g_void,"")
            END IF
         #CHI-D20010---begin
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t700_x(2)
               IF g_shb.shbconf = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_shb.shbconf,"","","",g_void,"")
            END IF
         #CHI-D20010---end
#FUN-A70095 --------End--------------
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t700_r()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t700_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               LET l_wc=' shb01= "',g_shb.shb01,'" '
              #LET l_cmd ='asfr732 '," '",g_today CLIPPED,"' ''",  #FUN-C30085 mark
               LET l_cmd ='asfg732 '," '",g_today CLIPPED,"' ''",  #FUN-C30085 add
                           " '",g_lang CLIPPED,"' 'Y' '' '1' ",
                           " '",l_wc CLIPPED,"' "
               CALL cl_cmdrun(l_cmd)
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
        WHEN "fast_input"
             LET g_shb_bak.* = g_shb.* 
             CALL t700_a('','F')       
        
        WHEN "fqc2"
             IF cl_chk_act_auth() THEN 
                IF cl_null(g_shb.shb01) THEN 
                   CALL cl_err('','anm-803',1)                   
                ELSE
         #FUN-A70095 -----------Begin------------
                   IF g_shb.shbconf <> 'Y' THEN
                      IF g_shb.shbconf = 'N' THEN
                         CALL cl_err(g_shb.shb01,'asf-218',0)
                      END IF
                      IF g_shb.shbconf = 'X' THEN
                         CALL cl_err(g_shb.shb01,'asf-149',0)
                      END IF
                   ELSE
         #FUN-A70095 -----------End--------------
                      SELECT shbacti INTO l_shbacti FROM shb_file 
                       WHERE shb01 = g_shb.shb01
                      IF l_shbacti = 'N' OR cl_null(l_shbacti) THEN 
                         CALL cl_err('','mfg0301',1)                     
                      ELSE
                         #FUN-A50066-begin--modify---------------------
                      	  #SELECT MAX(ecm03) INTO l_ecm03 FROM ecm_file 
                      	  # WHERE ecm01 = g_shb.shb05
                         #   AND ecm012= g_shb.shb012   #No.FUN-A50066
                      	  #IF g_shb.shb06 = l_ecm03 THEN  
                         IF NOT s_schdat_chk_ecm03(g_shb.shb05,g_shb.shb012,g_shb.shb06) THEN
                      	  #FUN-A50066--end--modify----------------------
                            CALL t700_1()
                            CALL t700_show()                                                       
                         ELSE                                #FUN-940113 
                            CALL cl_err('','asf-110',1)  	  #FUN-940113 
                         END IF    
                      END IF  	     	  
                   END IF     #FUN-A70095
                END IF     
             END IF          
        WHEN "trans_fqc"
              IF cl_chk_act_auth() THEN 
                IF cl_null(g_shb.shb01) THEN 
                   CALL cl_err('','anm-803',1)                   
                ELSE 
                 IF NOT cl_null(g_shb.shb22) THEN 
                    LET l_str= "aqct410 '",g_shb.shb22,"'"
                    CALL cl_cmdrun_wait(l_str)
                 END IF 
                END IF   
              END IF    
        WHEN "trans_store"
             IF cl_chk_act_auth() THEN
              IF cl_null(g_shb.shb01) THEN 
                   CALL cl_err('','anm-803',1)                   
              ELSE
               IF NOT cl_null(g_shb.shb21) THEN                 
                   LET l_cnt=0
                   SELECT COUNT(*) INTO l_cnt FROM sfb_file
                    WHERE sfb01=g_shb.shb05
                      AND sfb02<> '11'
                   IF l_cnt>0 THEN
                        LET l_str= "asft620 '",g_shb.shb21,"'"
                   END IF                   
                   CALL cl_cmdrun_wait(l_str)
               END IF
              END IF  
            END IF   
            
         WHEN "input_sub_report"
            IF cl_chk_act_auth()
               THEN
               MESSAGE ""
               CLEAR FORM
               CALL g_shc.clear()
               IF NOT t700_i2() THEN
                  CALL t700_a('','')        #NO.FUN-940113
               END IF
               LET g_argv1=''
               LET g_argv2=''
               LET g_argv3=''
               LET g_argv4=''   #TQC-630068
               LET g_argv5=''   #TQC-630068
               LET g_argv6=''   #FUN-A80060
            END IF
         WHEN "direct_st_in"
            IF  g_shb.shb114 > 0 AND
               NOT cl_null(g_shb.shb114) THEN
               IF g_shb.shbconf = 'X' THEN              #FUN-A70095
                  CALL cl_err(g_shb.shb01,'asf-149',0)  #FUN-A70095
               ELSE       #FUN-A70095 
                  CALL t701(g_shb.shb01) 
               END IF     #FUN-A70095  
            END IF
         WHEN "shift_working_hours"
            IF cl_chk_act_auth() THEN
               LET g_cmd="asft710 '",g_shb.shb03,"' '",g_shb.shb04,"'"
               CALL cl_cmdrun_wait(g_cmd)  #FUN-660216 add
            END IF
         WHEN "wo_routing_qt_status"
            IF cl_chk_act_auth() THEN
               LET g_cmd = "aecq700 '",g_shb.shb05,"'"
               CALL cl_cmdrun(g_cmd)
            END IF
         WHEN "wo_tr_o"
            IF cl_chk_act_auth() AND g_shb.shb17 > 0 AND
               NOT cl_null(g_shb.shb17) THEN
         #FUN-A70095 -----------Begin------------
               #No.TQC-BB0221  --Begin
               #IF g_shb.shbconf <> 'N' THEN
               #   IF g_shb.shbconf = 'Y' THEN
               #      CALL cl_err(g_shb.shb01,'asf-215',0)
               #   END IF
               IF g_shb.shbconf = 'X' THEN
                  CALL cl_err(g_shb.shb01,'asf-149',0)
               #  END IF
               ELSE
               #No.TQC-BB0221  --End  
         #FUN-A70095 -----------End--------------
                  LET l_cnt=0
                  SELECT COUNT(*) INTO l_cnt FROM shj_file
                                            WHERE shj01=g_shb.shb01
                  IF l_cnt>0 OR g_shb.shbconf = 'Y' THEN   #No.TQC-BB0221  add shbconf='Y'
                     #No.TQC-BB0221  --Begin
                     IF g_shb.shbconf = 'Y' THEN
                        LET g_cmd = "asft703 '",g_shb.shb01,"' 'query'"
                     ELSE
                        LET g_cmd = "asft703 '",g_shb.shb01,"'"
                     END IF
                     #No.TQC-BB0221  --End
                     CALL cl_cmdrun_wait(g_cmd)
                  ELSE
                     IF cl_confirm("asf-096") THEN
                     LET g_cmd = "asft703 '",g_shb.shb01,"' 'insert'"
                     CALL cl_cmdrun_wait(g_cmd)
                     END IF
                  END IF
               END IF     #FUN-A70095
            END IF
         WHEN "wo_tr_o_qry"
            IF cl_chk_act_auth() AND g_shb.shb17 > 0 AND
               NOT cl_null(g_shb.shb17) THEN
               CALL t702(g_shb.shb01,g_ecm.ecm58,g_shb.shb17)
            END IF
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              #CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_shc),'','') #FUN-CB0014 mark
              #FUN-CB0014---add---str---
              LET w = ui.Window.getCurrent()  
              LET f = w.getForm()              
              IF cl_null(g_action_flag) OR g_action_flag = "page_main" THEN
                 LET page = f.FindNode("Page","page_main")
                 CALL cl_export_to_excel(page,base.TypeInfo.create(g_shc),'','')
              END IF
              IF g_action_flag = "page_list" THEN
                 LET page = f.FindNode("Page","page_list")
                    CALL cl_export_to_excel(page,base.TypeInfo.create(g_shb_l),'','')
              END IF
              #FUN-CB0014---add---end---
            END IF
 
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_shb.shb01 IS NOT NULL THEN
                 LET g_doc.column1 = "shb01"
                 LET g_doc.value1 = g_shb.shb01
                 CALL cl_doc()
               END IF
         END IF

         #DEV-D30045--add--begin
         WHEN "barcode_gen"     #條碼產生
             IF cl_chk_act_auth() THEN
                CALL t700_barcode_gen(g_shb.shb01,'Y')
             END IF

         WHEN "barcode_query"   #條碼查詢
             IF cl_chk_act_auth() THEN
                LET g_msg = "abaq100 '",g_shb.shb01,"' "
                CALL cl_cmdrun_wait(g_msg)
             END IF

         WHEN "barcode_output"  #條碼列印
             IF cl_chk_act_auth() THEN
                CALL t700_barcode_out()
             END IF
         #DEV-D30045--add--end
      END CASE
   END WHILE
 
END FUNCTION

#FUN-A70095 ----------------------Begin-----------------------------
FUNCTION t700_confirm() 
   DEFINE l_cnt       LIKE type_file.num10
   DEFINE l_shb01     LIKE shb_file.shb01 
   DEFINE l_flag      LIKE type_file.num5
   DEFINE l_n         LIKE type_file.num5  #TQC-BC0182
   DEFINE l_ecm65     LIKE ecm_file.ecm65  #TQC-BC0182
   DEFINE l_sfb93     LIKE sfb_file.sfb93  #TQC-BC0182
   #TQC-BC0182--begin
   LET l_n = 0
   SELECT sfb93 INTO l_sfb93 FROM sfb_file     #TQC-C60154
    WHERE sfb01 = g_shb.shb05                  #TQC-C60154
   IF g_sma.sma541 = 'Y' AND l_sfb93 = 'Y' THEN
      SELECT COUNT(*) INTO l_n FROM sfa_file
       WHERE sfa01=g_shb.shb05
         AND sfa012=g_shb.shb012
         AND sfa013=g_shb.shb06
   ELSE
      SELECT COUNT(*) INTO l_n FROM sfa_file
       WHERE sfa01=g_shb.shb05
         AND sfa08=g_shb.shb081
   END IF
   IF l_n > 0 THEN
       CALL t700_shb111_a()
       IF g_success='N' THEN RETURN END IF
   ELSE
      IF g_sma.sma541='Y' AND l_sfb93 = 'Y' THEN
         SELECT ecm65 INTO l_ecm65 FROM ecm_file WHERE ecm01=g_shb.shb05
            AND ecm03=g_shb.shb06 AND ecm012=g_shb.shb012
         IF g_shb.shb111 > l_ecm65 THEN
            CALL cl_err('','asf-139',1)
            RETURN
         END IF
      END IF
   END IF
   #TQC-BC0182--end

  #MOD-C80032-程式搬移-S-
   LET g_success = 'Y'
   CALL t700sub_y_chk(g_shb.shb01,TRUE)
  #MOD-C80032-程式搬移-E-

  #MOD-C80032---mark---S
  #IF t700_accept_qty('c') THEN RETURN END IF  #TQC-C20008 add  
  #LET g_success = 'Y'
  #CALL t700sub_y_chk(g_shb.shb01,TRUE)
  #MOD-C80032---mark---E

   IF g_success = 'Y' THEN
      BEGIN WORK

  #MOD-C80032-程式搬移-S-
   IF cl_null(g_shb.shb14) THEN                     #CHI-C50054 add
      IF t700_accept_qty('c') THEN RETURN END IF
   ELSE                                             #CHI-C50054 add
      IF t700_chk_rvv17() THEN RETURN END IF        #CHI-C50054 add
   END IF
  #MOD-C80032-程式搬移-E-

      IF NOT cl_confirm('axm-108') THEN
         LET g_success='N'
      ELSE
         CALL t700sub_confirm(g_shb.shb01,'')
      END IF
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM shb_file
       WHERE shb23=g_shb.shb23
         AND shb24=g_shb.shb24
         AND (shb23 IS NOT NULL AND shb23 <> ' ')
         AND (shb24 IS NOT NULL AND shb23 <> ' ')
      IF l_cnt > 0 THEN
         IF NOT cl_confirm('asf-214') THEN
            LET g_success = 'N'
         ELSE
            DECLARE shb_curs1 CURSOR FOR  SELECT shb01 FROM shb_file
                                           WHERE shb23 = g_shb.shb23
                                             AND shb24 = g_shb.shb24
                                             AND shb01 <> g_shb.shb01  
            FOREACH shb_curs1 INTO l_shb01
               SELECT shb32 INTO g_shb.shb32 FROM shb_file
                WHERE shb01 = g_shb.shb01 
               CALL t700sub_y_chk(l_shb01,TRUE)
               IF g_success = 'Y' THEN 
                  CALL t700sub_confirm(l_shb01,g_shb.shb32)
               ELSE
                  EXIT FOREACH
               END IF
               IF g_success = 'N' THEN EXIT FOREACH END IF
            END FOREACH
         END IF
      END IF
      IF g_success = 'Y' THEN  #for 號機管理
         IF g_sma.sma1431='Y' THEN
           #CALL t700sub_shb081(g_shb.*,g_ecm.*,g_shb_t.*) RETURNING l_flag,g_shb.*,g_ecm.*       #MOD-C60147 mark
            CALL t700sub_shb081(g_shb.*,g_ecm.*,g_shb_t.*,'N') RETURNING l_flag,g_shb.*,g_ecm.*   #MOD-C60147 add
            CALL t700sub_auto_report(g_shb.*,g_ecm.*)
         END IF
      END IF
     
     #IF g_success='Y' THEN                       #CHI-C60008 add #FUN-D40092 mark
     #   CALL t700sub_t701update(g_shb.*,'a')     #CHI-C60008 add #FUN-D40092 mark
     #END IF                                      #CHI-C60008 add #FUN-D40092 mark

      IF g_success='Y' THEN
         COMMIT WORK
      ELSE
         ROLLBACK WORK
      END IF
   END IF
   CALL t700_show()

   #DEV-D30045--add--begin
   #自動產生barcode
   IF g_success='Y' AND g_aza.aza131 = 'Y' THEN
      CALL t700_barcode_gen(g_shb.shb01,'N')
   END IF
   #DEV-D30045--add--end

END FUNCTION  

FUNCTION t700_unconfirm()
   DEFINE l_cnt       LIKE type_file.num10
   DEFINE l_shb01     LIKE shb_file.shb01    
   DEFINE l_flag      LIKE type_file.num5 
   LET g_success = 'Y'
   CALL t700sub_y_chk(g_shb.shb01,FALSE)

   IF g_sma.sma53 IS NOT NULL AND g_shb.shb32 <= g_sma.sma53 THEN  #MOD-C70046 add
      CALL cl_err('shb32','axr-164',0)                             #MOD-C70046 add
      LET g_success='N'                                            #MOD-C70046 add
   END IF                                                          #MOD-C70046 add

   IF g_success = 'Y' THEN
      BEGIN WORK
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM shb_file
       WHERE shb23=g_shb.shb23
         AND shb24=g_shb.shb24
         AND (shb23 IS NOT NULL AND shb23 <> ' ')
         AND (shb24 IS NOT NULL AND shb23 <> ' ')
      IF l_cnt > 0 THEN
         IF NOT cl_confirm('asf-217') THEN
            LET g_success = 'N'
         ELSE
            DECLARE shb_un_curs1 CURSOR FOR  SELECT shb01 FROM shb_file
                                              WHERE shb23 = g_shb.shb23
                                                AND shb24 = g_shb.shb24
            FOREACH shb_un_curs1 INTO l_shb01
               CALL t700sub_y_chk(l_shb01,FALSE)
               IF g_success = 'Y' THEN
                  CALL t700sub_unconfirm(l_shb01)
               ELSE
                  EXIT FOREACH
               END IF
               IF g_success = 'N' THEN EXIT FOREACH END IF
            END FOREACH
         END IF
      ELSE
         IF NOT cl_confirm('axm-109') THEN
            LET g_success='N'
         ELSE
            CALL t700sub_unconfirm(g_shb.shb01)
         END IF
      END IF 
     #IF g_success='Y' THEN                       #CHI-C60008 add #FUN-D40092 mark
     #   CALL t700sub_t701update(g_shb.*,'u')     #CHI-C60008 add #FUN-D40092 mark
     #END IF                                      #CHI-C60008 add #FUN-D40092 mark

     #DEV-D30045--add--begin
     #自動作廢barcode
      IF g_success='Y' AND g_aza.aza131 = 'Y' THEN
         CALL t700_barcode_z(g_shb.shb01)
      END IF
     #DEV-D30045--add--end

      IF g_success='Y' THEN
         COMMIT WORK
      ELSE
         ROLLBACK WORK
      END IF
   END IF 
   CALL t700_show()

END FUNCTION
#FUN-A70095 ------------------------End-----------------------------

FUNCTION t700_a(l_flag,l_flag1)           
  DEFINE l_flag     LIKE type_file.chr1    
  DEFINE l_flag1    LIKE type_file.chr1    
  DEFINE l_count    LIKE type_file.num5    
  DEFINE l_sum      LIKE type_file.num5     #CHI-C50054 add 
  DEFINE li_result  LIKE type_file.num5     #No.FUN-550067  #No.FUN-680121 SMALLINT
  DEFINE l_shb031   LIKE shb_file.shb031    #No.FUN-680121 VARCHAR(8) #MOD-A80233 mod shb021->shb031
  DEFINE l_factor   LIKE ecm_file.ecm59     #No.FUN-680121 DEC(16,8)
  DEFINE l_factor1  LIKE ecm_file.ecm59   
  DEFINE l_shi05    LIKE shi_file.shi05
  DEFINE l_shj12    LIKE shj_file.shj12 #CHI-750006
  DEFINE l_ima55    LIKE ima_file.ima55
  DEFINE l_ecm58    LIKE ecm_file.ecm58
  DEFINE l_i        LIKE type_file.num5
  DEFINE l_pmc03    LIKE pmc_file.pmc03  #FUN-A80102
  DEFINE l_cnt      LIKE type_file.num5  #FUN-A80060
  DEFINE l_sfd05    LIKE sfd_file.sfd05  #FUN-A80060
  DEFINE l_sfd01    LIKE sfd_file.sfd01  #FUN-A80060
  DEFINE l_shb24    LIKE shb_file.shb24  #FUN-A80060
  DEFINE l_sfb08    LIKE sfb_file.sfb08  #MOD-D20173
 
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_shc.clear()
    INITIALIZE g_shb.* TO NULL       

    #CHI-A50025 add --start--
    IF g_sheet IS NULL THEN
       LET g_shb.shb01 = NULL
       LET g_shb.shb08 = NULL
       LET g_shb.shb07 = NULL
       LET g_shb.shb09 = NULL
       LET g_shb.shb081 = NULL
    ELSE
       LET g_shb.shb01 = g_sheet
       LET g_shb.shb08 = g_shb08
       LET g_shb.shb07 = g_shb07
       LET g_shb.shb09 = g_shb09
      #LET g_shb.shb081 = g_shb081    #FUN-B20079 
       IF g_sma.sma541='N' THEN LET g_shb.shb081 = g_shb081 END IF  #FUN-B20079 jan
    END IF
    #CHI-A50025 add --end--

    LET g_shb_o.* = g_shb.*
    LET g_shb_t.* = g_shb.*
    LET g_shb.shbconf = 'N'   #FUN-A70095
    IF l_flag1 = 'F' THEN 
       LET g_shb.* = g_shb_bak.*       
       #TQC-BA0003(S) #入庫項次若為0則清空
       IF g_shb.shb15=0 AND g_shb.shb14 IS NULL THEN
          LET g_shb.shb15 = NULL
       END IF
       #TQC-BA0003(E)
       LET g_shb.shb05 = NULL   
       LET g_shb.shb21 = NULL
       LET g_shb.shb22 = NULL 
       LET g_shb.shb111 = ''
       LET g_shb.shb031 = ''
       LET g_shb.shb032 = ''       
       LET g_shb.shb033 = ''       
       LET g_shb.shbacti = 'Y'
       LET g_shb.shbmodu = NULL
       LET g_shb.shbdate = NULL 
       LET g_shb.shbinp = g_today
       LET g_shb.shbconf = 'N'   #TQC-BA0003
       IF g_aza.aza41 = '1' THEN 
          LET l_count = '3'
       ELSE
   	      IF g_aza.aza41 = '2' THEN 
   	         LET l_count = '4'
   	      ELSE 
   	  	     LET l_count = '5'
   	      END IF 
       END IF               
        LET g_shb.shb01 = g_shb.shb01[1,l_count]                      #FUN-9B0045 mod  
    END IF 
       
    CALL cl_opmsg('a')
    WHILE TRUE
      IF l_flag1 IS NULL OR l_flag1='F' THEN           #NO.FUN-940113 #TQC-BA0003     
        LET g_shb.shb02   = g_today
        LET g_shb.shb03   = g_today
        LET g_shb.shb111  = 0
        LET g_shb.shb113  = 0
        LET g_shb.shb115  = 0
        LET g_shb.shb112  = 0
        LET g_shb.shb114  = 0
        LET g_shb.shb17   = 0
        IF g_sma.sma541 = 'N' THEN #FUN-A60095
           LET g_shb.shb012  = ' ' #FUN-A60095
        END IF                     #FUN-A60095
        LET l_shb031 = TIME               #MOD-A80233 mod shb021->shb031
        LET g_shb.shb031  = l_shb031[1,5] #MOD-A80233 mod shb021->shb031
        LET g_shb.shbinp  = g_today
        LET g_shb.shbacti = 'Y'
        LET g_shb.shbuser = g_user
        LET g_shb.shboriu = g_user #FUN-980030
        LET g_shb.shborig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_shb.shbgrup = g_grup
        LET g_shb.shbmodu = ''
        LET g_shb.shbdate = ''
        LET g_shb.shbplant = g_plant #FUN-980008 add
        LET g_shb.shblegal = g_legal #FUN-980008 add
        LET g_shb.shb04 = g_user
        IF NOT cl_null(g_argv3) THEN    #委外轉入   #TQC-630068
           LET g_shb.shb05 = g_rvv.rvv18
           LET g_shb.shb012= g_pmn012   #No.FUN-A50066
           LET g_shb.shb06 = g_pmn46
           LET g_shb.shb081= g_ecm04
           LET g_shb.shb082= g_ecm05
           LET g_shb.shb012= g_pmn012   #FUN-A50066
           LET g_shb.shb14 = g_argv3
           LET g_shb.shb15 = g_argv4
           CALL t700_sfb() RETURNING g_i

           CALL s_umfchk(g_shb.shb10,g_rvv.rvv35,g_ecm58) RETURNING g_sw,l_factor
           IF cl_null(l_factor) THEN LET l_factor=1 END IF
          #CHI-C50054 str add-----
           SELECT shb111+shb112+shb113+shb114 INTO l_sum
             FROM shb_file
            WHERE shb14=g_shb.shb14
              AND shb15=g_shb.shb15
          #CHI-C50054 end add-----
           LET g_shb.shb111= g_rvv.rvv17 *l_factor - l_sum      #CHI-C50054 add -l_sum
           #No.FUN-BB0086--add--begin--
           SELECT ecm58 INTO g_shb.shb34 FROM ecm_file 
            WHERE ecm01=g_shb.shb05 
             #AND emc03=g_shb.shb06     #TQC-C20334
              AND ecm03=g_shb.shb06     #TQC-C20334
              AND ecm012=g_shb.shb012
           LET g_shb.shb111 = s_digqty(g_shb.shb111,g_shb.shb34)
           #No.FUN-BB0086--add--end--

           DISPLAY BY NAME g_shb.shb05,g_shb.shb06,g_shb.shb111,
                           g_shb.shb14,g_shb.shb15
           DISPLAY BY NAME g_shb.shb012            #No.FUN-A50066
           #FUN-A80102(S)
           LET g_shb.shb28 = g_rvv.rvv36
           LET g_shb.shb29 = g_rvv.rvv04
           SELECT pmm09,pmc03 INTO g_shb.shb27,l_pmc03 
             FROM pmm_file LEFT OUTER JOIN pmc_file ON (pmm09=pmc01)
            WHERE pmm01=g_shb.shb28
           DISPLAY BY NAME g_shb.shb27,g_shb.shb28,g_shb.shb29
           DISPLAY l_pmc03 TO FORMONLY.pmc03
           #FUN-A80102(E)
           CALL t700_shb081_relation() RETURNING g_i
           CALL t700_accept_qty('d') RETURNING g_i
           IF g_shb.shb111 > g_wip_qty THEN
              IF cl_confirm('asf-047') THEN
                 LET g_shb.shb115 = g_shb.shb115 + (g_shb.shb111 - g_wip_qty)
                 LET g_shb.shb111 = g_wip_qty
              ELSE
                 LET g_shb.shb111 = g_wip_qty
              END IF
              DISPLAY BY NAME g_shb.shb05,g_shb.shb06,g_shb.shb111,
                              g_shb.shb14,g_shb.shb15
              CALL t700_accept_qty('d') RETURNING g_i
           END IF
        END IF
        DISPLAY BY NAME g_shb.shbuser,g_shb.shbgrup,g_shb.shbmodu,g_shb.shbdate,g_shb.shbconf  #FUN-A70095 add shbconf                
    END IF 	          #NO.FUN-940113            
         
         #FUN-A80102(S)
         LET g_shb.shb30 ='N'  
         IF g_sma.sma1435='N' THEN
            LET g_shb.shb021 = "00:00"
            LET g_shb.shb031 = "00:00"
         END IF
         #FUN-A80102(E)
         CALL t700_i("a",l_flag1)                   #NO.FUN-940113   
        IF INT_FLAG THEN
           LET INT_FLAG=0 CALL cl_err('',9001,0)
           INITIALIZE g_shb.* TO NULL
           CLEAR FORM
           CALL g_shc.clear()
           EXIT WHILE
        END IF
        IF g_shb.shb01 IS NULL THEN CONTINUE WHILE END IF
        IF cl_null(g_shb.shb14) THEN        #CHI-C50054 add 
           IF t700_accept_qty('c') THEN EXIT WHILE END IF
       #CHI-C50054 str add-----
        ELSE  
           IF t700_chk_rvv17() THEN EXIT WHILE END IF
        END IF
       #CHI-C50054 end add-----

         #FUN-A80102(S)
         IF g_sma.sma1435='N' THEN
            #MOD-D20173---begin
            #LET g_shb.shb032 = (g_shb.shb111+g_shb.shb112+g_shb.shb113+g_shb.shb114+g_shb.shb115) * g_ecm.ecm14 / 60
            #LET g_shb.shb033 = (g_shb.shb111+g_shb.shb112+g_shb.shb113+g_shb.shb114+g_shb.shb115) * g_ecm.ecm16 / 60
            SELECT sfb08 INTO l_sfb08 FROM sfb_file WHERE sfb01 = g_shb.shb05  
            IF cl_null(l_sfb08) THEN LET l_sfb08 = 1 END IF 
            LET g_shb.shb032 = (g_shb.shb111+g_shb.shb112+g_shb.shb113+g_shb.shb114+g_shb.shb115) * g_ecm.ecm14 / l_sfb08 / 60  
            LET g_shb.shb033 = (g_shb.shb111+g_shb.shb112+g_shb.shb113+g_shb.shb114+g_shb.shb115) * g_ecm.ecm16 / l_sfb08 / 60 
            #MOD-D20173---end 
            DISPLAY BY NAME g_shb.shb032,g_shb.shb033
         END IF
         #FUN-A80102(E)

        BEGIN WORK     #NO:7829
        LET g_success = 'Y'       #CHI-710049 add
        CALL s_auto_assign_no("asf",g_shb.shb01,g_shb.shb03,"9","shb_file","shb01","","","")
        RETURNING li_result,g_shb.shb01
        IF (NOT li_result) THEN
           LET g_success = 'N'       #CHI-710049 add
           CONTINUE WHILE
        END IF
	DISPLAY BY NAME g_shb.shb01
        IF g_shb.shb012 IS NULL THEN LET g_shb.shb012 = ' ' END IF     #FUN-A60095
        IF g_shb.shb06 IS NULL  THEN LET g_shb.shb06 = 0 END IF        #FUN-A60095
        IF cl_null(g_shb.shb26) THEN LET g_shb.shb26 ='N' END IF       #FUN-A80102
        IF cl_null(g_shb.shb30) THEN LET g_shb.shb30 ='N' END IF       #FUN-A80102
        IF cl_null(g_shb.shb31) THEN LET g_shb.shb31 ='N' END IF       #FUN-A80102
        IF cl_null(g_shb.shbconf) THEN LET g_shb.shbconf = 'N' END IF  #FUN-A70095  
        IF g_shb.shb121 IS NULL THEN LET g_shb.shb121 = ' ' END IF     #MOD-B70227 add
        INSERT INTO shb_file VALUES (g_shb.*)

        #CHI-A50025 add --start--
        CALL s_get_doc_no(g_shb.shb01) RETURNING g_sheet
        LET g_shb08 = g_shb.shb08
        LET g_shb07 = g_shb.shb07
        LET g_shb09 = g_shb.shb09
        LET g_shb081 = g_shb.shb081
        #CHI-A50025 add --end--

        IF STATUS THEN
           CALL cl_err(g_shb.shb01,STATUS,1)
           LET g_success = 'N'#CHI-710049 add
           EXIT WHILE
        END IF
 
        CALL cl_flow_notify(g_shb.shb01,'I')
#FUN-A70095 ------------------Begin-----------------        
    #   #FUN-A80102(S)
    #   IF g_sma.sma1431='Y' THEN
    #      CALL t700sub_auto_report(g_shb.*,g_ecm.*)
    #   END IF
    #   #FUN-A80102(E)
#FUN-A70095 ------------------End-------------------
        #FUN-A80060--begin--add---------
        LET l_cnt=0
        SELECT count(*) INTO l_cnt FROM sfd_file
         WHERE sfd03=g_shb.shb05 AND sfd07=g_shb.shb012 AND sfdconf='Y' AND sfd09='2'   #MOD-CB0170 add sfd09
        IF l_cnt > 0 THEN
           SELECT sfd05,sfd01 INTO l_sfd05,l_sfd01 FROM sfd_file,sfb_file WHERE sfb01=g_shb.shb05 AND sfb85=sfd01 AND sfd03=sfb01
           SELECT MAX(shb24)+1 INTO l_shb24 FROM shb_file WHERE shb05=g_shb.shb05
           IF cl_null(l_shb24) THEN LET l_shb24=1 END IF
           UPDATE shb_file SET shb23=l_sfd01,shb24=l_shb24 WHERE shb01=g_shb.shb01
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
              CALL cl_err('',SQLCA.sqlcode,1)
              LET g_success='N'
              EXIT WHILE
           END IF
           CALL t700sub_auto_Combined_Wo(g_shb.*,l_sfd05,l_shb24)
        END IF
        #FUN-A80060--end--add-----------
        SELECT shb01 INTO g_shb.shb01 FROM shb_file WHERE shb01 = g_shb.shb01
        LET g_shb_t.* = g_shb.*
        LET g_shb_bak.* = g_shb.*                 #NO.FUN-940113
          
        IF g_success = 'Y' THEN  #CHI-710049 add
#FUN-A70095 --------------------Begin-------------------------
        #  LET g_success='Y'
        #  CALL t700sub_upd_ecm('a',g_shb.*)    # Update 製程追蹤檔  #FUN-A80102
        #     RETURNING g_shb.*   #FUN-A80102
        #  IF g_success='N' THEN
        #     CLEAR FORM
        #     CALL g_shc.clear()
        #     ROLLBACK WORK
        #     EXIT WHILE
        #  ELSE
        #     IF g_shb.shb112 > 0 THEN    #表示有報廢數量
        #        SELECT ima55 INTO l_ima55 FROM ima_file 
        #         WHERE ima01= g_shb.shb10
 
        #        SELECT ecm58 INTO l_ecm58 FROM ecm_file
        #         WHERE ecm01=g_shb.shb05
        #           AND ecm03=g_shb.shb06
        #           AND ecm012=g_shb.shb012   #No.FUN-A50066
 
        #        CALL s_umfchk(g_shb.shb10,l_ecm58,l_ima55)                                                   
        #                 RETURNING l_i,l_factor
 
        #        IF l_i = '1' THEN                                                                                             
        #           LET l_factor = 1
        #        END IF
        #        UPDATE sfb_file SET sfb12 = sfb12 + (g_shb.shb112 * l_factor)
        #         WHERE sfb01 = g_shb.shb05 
        #        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN 
        #           CALL cl_err(g_shb.shb05,'asf-861',1)
        #           ROLLBACK WORK
        #           CLEAR FORM
        #           CALL g_shc.clear()
        #        ELSE
        #           COMMIT WORK
        #        END IF
        #     ELSE
        #        COMMIT WORK
        #     END IF
        #  END IF
           COMMIT WORK    #FUN-A70095
#FUN-A70095 --------------------End------------------------
        ELSE              #CHI-710049 add
           ROLLBACK WORK  #CHI-710049 add
           CLEAR FORM
        END IF            #CHI-710049 add
        IF g_success='Y' THEN  #FUN-A80060
           IF g_shb.shb114 > 0 THEN CALL t701(g_shb.shb01) END IF 
           CALL g_shc.clear()
           LET g_rec_b = 0
           IF g_shb.shb17 > 0 THEN
             LET g_cmd = "asft703 '",g_shb.shb01,"' 'insert'"
             CALL cl_cmdrun_wait(g_cmd)
             SELECT SUM(shj12) INTO l_shj12 FROM shj_file
                                           WHERE shj01=g_shb.shb01
             IF SQLCA.sqlcode OR (cl_null(l_shj12)) THEN
                LET l_shj12=0
             END IF
             IF l_shj12<>g_shb.shb17 THEN #轉入總和不等於轉出,show提示
                CALL cl_err('','asf-098',1)
             END IF
           END IF
           #FUN-990094--add---str---
           IF g_re_dis_vne06 >=1 THEN
               CALL s_dis_vne06(g_shb.shb05,g_shb.shb05,g_shb.shb06,g_ecm.ecm04,g_re_dis_vne06)
           END IF
           #FUN-990094--add---end---
           CALL t700_b() #輸入單身-shc
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
#FUN-A70095 ---------------------Begin----------------------

FUNCTION t700_u(l_flag,l_flag1)

   DEFINE   l_flag   LIKE type_file.chr1
   DEFINE   l_flag1  LIKE type_file.chr1

   IF s_shut(0) THEN RETURN END IF
                
   IF g_shb.shb01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_shb.*  FROM shb_file WHERE shb01 = g_shb.shb01
   IF g_shb.shbconf = 'Y' THEN
      CALL cl_err('','asf-146',0)
      RETURN
   END IF
   IF g_shb.shbconf = 'X' THEN
      CALL cl_err('','asf-147',0)
      RETURN
   END IF
   LET g_shb_o.* = g_shb.*
   LET g_shb01_t = g_shb.shb01
   MESSAGE ""
   CALL cl_opmsg('u')
   BEGIN WORK
   OPEN t700_cl USING g_shb.shb01
   IF STATUS THEN
      CALL cl_err("OPEN t700_cl:", STATUS, 1)
      CLOSE t700_cl
      ROLLBACK WORK
      RETURN
   END IF    
   FETCH t700_cl INTO g_shb.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err('lock shb:',SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t700_cl
      ROLLBACK WORK
      RETURN
   END IF
   LET g_shb.shbmodu = g_user
   LET g_shb.shbdate = g_today
   CALL t700_show()
   WHILE TRUE
      CALL t700_i("u",l_flag1)                      # 欄位更改
      IF INT_FLAG THEN
          LET INT_FLAG = 0
          LET g_shb.*=g_shb_t.*
          CALL t700_show()
          CALL cl_err('',9001,0)
          EXIT WHILE
      END IF
      UPDATE shb_file SET shb_file.* = g_shb.*    # 更新DB
          WHERE shb01 = g_shb01_t
      IF SQLCA.sqlcode THEN
          CALL cl_err3("upd","shb_file",g_shb01_t,'',SQLCA.sqlcode,"","",1)
          CONTINUE WHILE
      END IF
      EXIT WHILE
  END WHILE
  CLOSE t700_cl
  COMMIT WORK
END FUNCTION

#FUN-A70095 ---------------------End------------------------
 
 
 FUNCTION t700_i(p_cmd,l_flag1)                      #NO.FUN-940113   
  DEFINE l_flag1         LIKE type_file.chr1         #NO.FUN-940113 
  DEFINE li_result       LIKE type_file.num5          #No.FUN-550067  #No.FUN-680121 SMALLINT
  DEFINE p_cmd           LIKE type_file.chr1                 #a:輸入 u:更改  #No.FUN-680121 VARCHAR(1)
  DEFINE l_flag          LIKE type_file.chr1                 #判斷必要欄位是否有輸入  #No.FUN-680121 VARCHAR(1)
  DEFINE l_cnt           LIKE type_file.num5     #No.FUN-680121 SMALLINT
  DEFINE l_n             LIKE type_file.num5     #FUN-B20079
  DEFINE l_chk_time1     LIKE type_file.num10    #No.FUN-680121 INTEGER
  DEFINE l_chk_time2     LIKE type_file.num10    #No.FUN-680121 INTEGER
  DEFINE l_ecm04         LIKE ecm_file.ecm04
  DEFINE l_ecm45         LIKE ecm_file.ecm45
  DEFINE l_shb02         LIKE shb_file.shb02
  DEFINE l_shb021        LIKE shb_file.shb021
  DEFINE l_shb031        LIKE shb_file.shb031
  DEFINE l_day,l_min,l_hh,l_mm LIKE type_file.num5    #No.FUN-680121 SMALLINT
  DEFINE A,b1,b2,c1,c2,c3      LIKE type_file.num5    #No.FUN-680121 SMALLINT
  DEFINE g_c1,g_c11,g_c12      LIKE type_file.num5    #No.FUN-680121 SMALLINT
  DEFINE l_close,l_open        LIKE type_file.dat     #No.FUN-680121 DATE
  DEFINE l_sma126              LIKE sma_file.sma126
  DEFINE l_sma127              LIKE sma_file.sma127
  DEFINE l_shb111              LIKE shb_file.shb111
  DEFINE l_shb112              LIKE shb_file.shb112
  DEFINE l_shb111_0            LIKE shb_file.shb111
  DEFINE l_sgl08               LIKE sgl_file.sgl08
  DEFINE l_sgl08_min           LIKE sgl_file.sgl08
  DEFINE l_sgl09_max           LIKE sgl_file.sgl09
  DEFINE l_ecmslk01            LIKE ecm_file.ecmslk01
  DEFINE l_skr06_min           LIKE skr_file.skr06
  DEFINE l_sgd                 RECORD LIKE sgd_file.*
  DEFINE l_sgl11_aver          LIKE sgl_file.sgl11
  DEFINE l_shb032	       LIKE shb_file.shb032
  DEFINE l_ima153              LIKE ima_file.ima153   #FUN-910053 
  DEFINE l_sha041              LIKE sha_file.sha041   #MOD-A50114 add 
  DEFINE l_sfb93               LIKE sfb_file.sfb93    #FUN-A50066
  DEFINE l_ecm65               LIKE ecm_file.ecm65    #FUN-A50066
  DEFINE l_sfb919              LIKE sfb_file.sfb919   #FUN-A80102
  DEFINE l_vmn08               LIKE vmn_file.vmn08     #FUN-960106 ADD
  DEFINE l_vmn081              LIKE vmn_file.vmn081    #FUN-960106 ADD
  DEFINE l_ecm05               LIKE ecm_file.ecm05     #FUN-960106 ADD
  DEFINE l_ecm06               LIKE ecm_file.ecm06     #FUN-960106 ADD
  DEFINE l_shb06               LIKE shb_file.shb06     #TQC-C10122
  DEFINE l_sfb81               LIKE sfb_file.sfb81     #MOD-C90057 add 
  IF l_flag1 IS NULL THEN     #NO.FUN-940113   
    DISPLAY BY NAME g_shb.shb01,g_shb.shb04,g_shb.shb05,g_shb.shb081,
                    g_shb.shb012,g_shb.shb121,          #No.FUN-A50066
                    g_shb.shb08,g_shb.shb07,g_shb.shb09,g_shb.shb03,
                    g_shb.shb031,g_shb.shb02,g_shb.shb021,g_shb.shb032,g_shb.shb033, #FUN-910076
                    g_shb.shb111,g_shb.shb115,g_shb.shb112,g_shb.shb113,
                    g_shb.shb12,g_shb.shb114,g_shb.shb17,g_shb.shb30   #FUN-A80102
  ELSE
    DISPLAY BY NAME g_shb.shb01,g_shb.shb04,g_shb.shb05,g_shb.shb081,
                    g_shb.shb012,g_shb.shb121,          #No.FUN-A50066
                    g_shb.shb06,g_shb.shb10,g_shb.shb08,g_shb.shb07,
                    g_shb.shb09,g_shb.shb02,g_shb.shb021,g_shb.shb03,g_shb.shb031,
                    g_shb.shb032,g_shb.shb033,g_shb.shb111,g_shb.shb115,g_shb.shb112,
                    g_shb.shb113,g_shb.shb12,g_shb.shb114,g_shb.shb17,g_shb.shb14,g_shb.shb15,
                    g_shb.shbud01,g_shb.shbud02,g_shb.shbud03,g_shb.shbud04,g_shb.shbud05,
                    g_shb.shbud06,g_shb.shbud07,g_shb.shbud08,g_shb.shbud09,g_shb.shbud10,
                    g_shb.shbud11,g_shb.shbud12,g_shb.shbud13,g_shb.shbud14,g_shb.shbud15,
                    g_shb.shb30  #FUN-A80102
    DISPLAY g_gen02,gg_ima02,gg_ima021,g_wip,g_pqc,g_tot_pqc,g_ecm53,g_ecm54
         TO FORMONLY.gen02,FORMONLY.ima02,FORMONLY.ima021,FORMONLY.wip,
            FORMONLY.pqc,FORMONLY.tot_pqc,ecm53,ecm54 
  END IF
        
    CALL cl_set_head_visible("","YES")        #NO.FUN-6B0031 
    INPUT BY NAME g_shb.shb01,g_shb.shb04,g_shb.shb05,g_shb.shb012,  #No.FUN-A50066
                  g_shb.shb081, g_shb.shboriu,g_shb.shborig,
                  g_shb.shb082,g_shb.shb06,g_shb.shb10,g_shb.shb08,
                  g_shb.shb07,g_shb.shb09,g_shb.shb02,g_shb.shb021,
                  g_shb.shb03,g_shb.shb031,g_shb.shb032,g_shb.shb033,g_shb.shb111, #FUN-910076 add shb033
                 #g_shb.shb115,g_shb.shb112,g_shb.shb113,g_shb.shb12,g_shb.shb121, #FUN-A50066
                  g_shb.shb115,g_shb.shb112,g_shb.shb113,g_shb.shb121,g_shb.shb12,     #TQC-A90153
                  g_shb.shb114,g_shb.shb17,g_shb.shb34,g_shb.shb31,g_shb.shb26,      #No.FUN-BB0086   #FUN-A60102
                  g_shb.shbud01,g_shb.shbud02,g_shb.shbud03,g_shb.shbud04,
                  g_shb.shbud05,g_shb.shbud06,g_shb.shbud07,g_shb.shbud08,
                  g_shb.shbud09,g_shb.shbud10,g_shb.shbud11,g_shb.shbud12,
                  g_shb.shbud13,g_shb.shbud14,g_shb.shbud15 
        WITHOUT DEFAULTS
 
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
           #LET g_shb06 = NULL    #MOD-9B0151  #FUN-A80102 mark
           #LET g_chr   = 'N'     #MOD-9B0151  #FUN-A80102 mark
            CALL t700_set_entry(p_cmd)
            CALL t700_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
                                 
            CALL cl_set_docno_format("shb01")
           #CALL cl_set_docno_format("shb05")   #MOD-C60239 mark
            #FUN-A50066--begin--add-----------
            IF NOT cl_null(g_shb.shb05) THEN 
               SELECT sfb93 INTO l_sfb93 FROM sfb_file
                WHERE sfb01=g_shb.shb05
            END IF
            #FUN-A50066--end--add-------------
           #No.FUN-BB0086--add--begin--
           SELECT ecm58 INTO g_shb.shb34 FROM ecm_file 
            WHERE ecm01=g_shb.shb05 
             #AND emc03=g_shb.shb06     #TQC-C20334
              AND ecm03=g_shb.shb06     #TQC-C20334
              AND ecm012=g_shb.shb012
           DISPLAY BY NAME g_shb.shb34
           #No.FUN-BB0086--add--end--
 
 
        AFTER FIELD shb01
         IF NOT cl_null(g_shb.shb01) AND (g_shb.shb01 !=g_shb_t.shb01 OR g_shb_t.shb01 IS NULL) THEN  #TQC-720063
            CALL s_check_no("asf",g_shb.shb01,g_shb_t.shb01,"9","shb_file","shb01","")
            RETURNING li_result,g_shb.shb01
            DISPLAY BY NAME g_shb.shb01
            IF (NOT li_result) THEN
               LET g_shb.shb01=g_shb_o.shb01
               NEXT FIELD shb01
            END IF
         END IF
 
        AFTER FIELD shb04
            IF NOT cl_null(g_shb.shb04) THEN
               CALL t700_shb04('d')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,1)
                  NEXT FIELD shb04
               END IF
            END IF
 
       AFTER FIELD shb115
           #No.FUN-BB0086--add--begin--
           SELECT ecm58 INTO g_shb.shb34 FROM ecm_file
            WHERE ecm01=g_shb.shb05
             #AND emc03=g_shb.shb06     #TQC-C20334
              AND ecm03=g_shb.shb06     #TQC-C20334
              AND ecm012=g_shb.shb012
           LET g_shb.shb115 = s_digqty(g_shb.shb115,g_shb.shb34)
           DISPLAY BY NAME g_shb.shb115
           #No.FUN-BB0086--add--end--
          IF NOT cl_null(g_shb.shb115) THEN 
             IF g_shb.shb115 < 0 THEN
                CALL cl_err('','alm-061',0)
                NEXT FIELD shb115
             END IF 
          END IF     
 
        AFTER FIELD shb07
            IF NOT cl_null(g_shb.shb07) THEN
               SELECT COUNT(*) INTO g_cnt FROM eca_file
               WHERE eca01 = g_shb.shb07
               IF g_cnt = 0 THEN
                  CALL cl_err(g_shb.shb07,'aec-802',0)
                  LET g_shb.shb07 = g_shb_t.shb07
                  DISPLAY BY NAME g_shb.shb07
                  NEXT FIELD shb07
               END IF
            END IF
 
        AFTER FIELD shb09
            IF NOT cl_null(g_shb.shb09) THEN
                #串APS且平行加工='Y'
                IF g_sma.sma901 = 'Y' THEN 
                #FUN-960106 MARK --STR-------------------------------
                #   IF g_ecm.ecm61 = 'Y' THEN 
                #       SELECT COUNT(*) INTO g_cnt FROM vlj_file
                #        WHERE vlj01 = g_shb.shb05
                #          AND vlj02 = g_sma.sma917
                #          AND vlj03 = g_shb.shb06
                #          AND vlj06 = g_shb.shb09
                #       IF g_cnt=0 THEN
                #           #平行加工維護內無此資源編號
                #           CALL cl_err(g_shb.shb09,'aps-019',1) 
                #           NEXT FIELD shb09
                #       END IF
                #   ELSE
                #       IF cl_null(g_shb.shb012) THEN LET g_shb.shb012=' ' END IF #FUN-A60095
                #       IF g_sma.sma917 = 0 THEN 
                #           #工作站
                #           SELECT COUNT(*) INTO g_cnt FROM ecm_file
                #            WHERE ecm01 = g_shb.shb05
                #              AND ecm03 = g_shb.shb06
                #              AND ecm06 = g_shb.shb09
                #              AND ecm012= g_shb.shb012   #No.FUN-A50066
                #           IF g_cnt=0 THEN
                #               #無此工作站
                #               CALL cl_err(g_shb.shb09,'aec-100',1) 
                #               NEXT FIELD shb09
                #           END IF
                #       ELSE
                #           #機器編號
                #           SELECT COUNT(*) INTO g_cnt FROM ecm_file
                #            WHERE ecm01 = g_shb.shb05
                #              AND ecm03 = g_shb.shb06
                #              AND ecm05 = g_shb.shb09
                #              AND ecm012= g_shb.shb012   #No.FUN-A50066
                #           IF g_cnt=0 THEN
                #               #無此機器編號,請重新輸入
                #               CALL cl_err(g_shb.shb09,'mfg4010',1) 
                #               NEXT FIELD shb09
                #           END IF
                #       END IF
                #   END IF
                #FUN-960106 MARK --END--------------------------------
                #FUN-960106 ADD --STR---------------------------------
                 IF g_ecm.ecm61 = 'Y' THEN
                     SELECT COUNT(*) INTO g_cnt FROM vne_file
                      WHERE vne01 = g_shb.shb05
                        AND vne02 = g_shb.shb05
                        AND vne03 = g_shb.shb06
                        AND vne05 = g_shb.shb09
                     IF g_cnt=0 THEN
                         #鎖定設備維護內無此資源編號
                         CALL cl_err(g_shb.shb09,'aps-772',1)
                         NEXT FIELD shb09
                     END IF
                 ELSE
                     #FUN-980080---add---str---
                     SELECT   ecm05,  ecm06
                       INTO l_ecm05,l_ecm06
                       FROM ecm_file
                      WHERE ecm01 = g_shb.shb05
                        AND ecm03 = g_shb.shb06
                     SELECT   vmn08,  vmn081  #資源群組編號(vmn08機器/vmn081工作站)
                       INTO l_vmn08,l_vmn081
                       FROM vmn_file
                      WHERE vmn01 = g_shb.shb10
                        AND vmn02 = g_shb.shb05
                        AND vmn03 = g_shb.shb06
                     IF g_sma.sma917 = 0 THEN
                         #工作站
                         IF NOT cl_null(l_vmn081) THEN
                             SELECT COUNT(*) INTO l_cnt
                               FROM vmp_file
                              WHERE vmp01 = l_vmn081
                                AND vmp02 = g_shb.shb09
                             IF l_cnt = 0 THEN
                                 #請輸入這個資源群組下的資源!
                                 CALL cl_err(l_vmn081,'aps-801',1)
                                 NEXT FIELD shb09
                             END IF
                         ELSE
                            IF (g_shb.shb09 <> l_ecm06)  THEN
                               #無此工作站,請重新輸入
                               CALL cl_err(g_shb.shb09,'aec-100',1)
                               NEXT FIELD shb09
                            END IF
                         END IF
                     ELSE
                         #機器編號
                         IF NOT cl_null(l_vmn08) THEN
                             SELECT COUNT(*) INTO l_cnt
                               FROM vme_file
                              WHERE vme01= l_vmn08
                                AND vme02 = g_shb.shb09
                             IF l_cnt = 0 THEN
                                 #請輸入這個資源群組下的資源!
                                 CALL cl_err(l_vmn08,'aps-801',1)
                                 NEXT FIELD shb09
                             END IF
                         ELSE
                            IF (g_shb.shb09 <> l_ecm05)  THEN
                               #無此機器編號,請重新輸入
                               CALL cl_err(g_shb.shb09,'mfg4010',1)
                               NEXT FIELD shb09
                            END IF
                         END IF
                     END IF
                     #FUN-980080---add---end---
                    #FUN-980080----mark--str---
                    #IF g_sma.sma917 = 0 THEN
                    #    #工作站
                    #    SELECT COUNT(*) INTO g_cnt FROM vmn_file,vmp_file
                    #     WHERE vmn01 = g_shb.shb10
                    #       AND vmn02 = g_shb.shb05
                    #       AND vmn03 = g_shb.shb06
                    #       AND vmn081 = vmp01
                    #    SELECT COUNT(*) INTO g_cnt2 FROM vmn_file,vmp_file
                    #     WHERE vmn01 = g_shb.shb10
                    #       AND vmn02 = g_shb.shb05
                    #       AND vmn03 = g_shb.shb06
                    #       AND vmn081 = vmp01
                    #       AND vmp02 = g_shb.shb09
                    #    IF g_cnt>0 AND g_cnt2=0 THEN
                    #        #無此工作站,請重新輸入
                    #        CALL cl_err(g_shb.shb09,'aec-100',1)
                    #        NEXT FIELD shb09
                    #    END IF
                    #ELSE
                    #    #機器編號
                    #    SELECT COUNT(*) INTO g_cnt FROM vmn_file,vme_file
                    #     WHERE vmn01 = g_shb.shb10
                    #       AND vmn02 = g_shb.shb05
                    #       AND vmn03 = g_shb.shb06
                    #       AND vmn081 = vme01
                    #    SELECT COUNT(*) INTO g_cnt2 FROM vmn_file,vme_file
                    #     WHERE vmn01 = g_shb.shb10
                    #       AND vmn02 = g_shb.shb05
                    #       AND vmn03 = g_shb.shb06
                    #       AND vmn081 = vme01
                    #       AND vme02 = g_shb.shb09
                    #    IF g_cnt>0 AND g_cnt2=0 THEN
                    #        #無此機器編號,請重新輸入
                    #        CALL cl_err(g_shb.shb09,'mfg4010',1)
                    #        NEXT FIELD shb09
                    #    END IF
                    #END IF
                    #IF g_cnt = 0 THEN
                    #   SELECT ecm05,ecm06 INTO l_ecm05, l_ecm06
                    #     FROM ecm_file
                    #    WHERE ecm01 = g_shb.shb05
                    #      AND ecm03 = g_shb.shb06
                    #    IF g_sma.sma917 = 0 THEN
                    #       IF (g_shb.shb09 <> l_ecm06)  THEN
                    #          CALL cl_err(g_shb.shb09,'aec-100',1)
                    #          NEXT FIELD shb09
                    #       END IF
                    #    ELSE
                    #       IF (g_shb.shb09 <> l_ecm05)  THEN
                    #          CALL cl_err(g_shb.shb09,'mfg4010',1)
                    #          NEXT FIELD shb09
                    #       END IF
                    #    END IF
                    #END IF
                    #FUN-980080----mark--end---
                 END IF
                #FUN-960106 ADD --END---------------------------------
                ELSE
                    SELECT COUNT(*) INTO g_cnt FROM eci_file
                     WHERE eci01=g_shb.shb09
                    IF g_cnt=0 THEN
                       CALL cl_err(g_shb.shb09,'aec-011',0) NEXT FIELD shb09
                    END IF
                END IF
            END IF
 
        AFTER FIELD shb05
            IF NOT cl_null(g_shb.shb05) THEN
               SELECT sfb05 INTO g_shb.shb10 FROM sfb_file
                WHERE sfb01=g_shb.shb05
                  AND ((sfb04 IN ('4','5','6','7','8') AND sfb39='1') OR          #No:MOD-990028 add '8'
                      (sfb04 IN ('2','3','4','5','6','7','8') AND sfb39='2'))     #No:MOD-990028 add '8'
                  AND (sfb28 < '2' OR sfb28 IS NULL)
                  AND sfb87!='X'
               IF STATUS THEN   #資料不存在
                  CALL cl_err(g_shb.shb05,'asf-018',0)
                  LET g_shb.shb05 = g_shb_t.shb05
                  DISPLAY BY NAME g_shb.shb05
                  NEXT FIELD shb05
               ELSE
                  DISPLAY BY NAME g_shb.shb10
                  CALL t700_shb10('d')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_shb.shb10,g_errno,0)
                     LET g_shb.shb10 = g_shb_t.shb10
                     DISPLAY BY NAME g_shb.shb10
                     NEXT FIELD shb05
                  END IF
               END IF
               SELECT COUNT(*) INTO l_cnt FROM sfb_file
                WHERE sfb01=g_shb.shb05 AND sfb02='7' AND sfb87!='X'
               IF l_cnt > 0 THEN
                  CALL cl_err(g_shb.shb05,'asf-817',1)
                  NEXT FIELD shb05
               END IF
 
               SELECT COUNT(*) INTO l_cnt FROM shm_file  #此工單走run card NO.3566
                WHERE shm012 = g_shb.shb05
               IF l_cnt > 0 THEN
                  CALL cl_err(g_shb.shb05,'asf-927',1)
                  NEXT FIELD shb05
               END IF
               SELECT sfb93 INTO l_sfb93 FROM sfb_file WHERE sfb01=g_shb.shb05  #FUN-A50066
               #FUN-A80102(S)
               IF g_sma.sma1421='Y' THEN
                  LET l_sfb919 = ''
                  SELECT sfb919 INTO l_sfb919 FROM sfb_file WHERE sfb01=g_shb.shb05
                  DISPLAY l_sfb919 TO FORMONLY.sfb919
               END IF
               #FUN-A80102(E)
               #FUN-A80060--begin--add------------
               LET l_cnt=0
               SELECT count(*) INTO l_cnt FROM sfb_file,sfd_file
                WHERE sfb01=g_shb.shb05
                  AND sfb85=sfd01
                  AND sfdconf<>'Y'
               IF l_cnt > 0 then
                  CALL cl_err('','asf-166',0)
                  NEXT FIELD shb05   #MOD-C10055
               END IF
               #FUN-A80060--end--add-----------
               IF g_aza.aza115='Y' AND g_shb.shb05 <> g_shb_t.shb05 AND NOT t700_chk_azf() THEN NEXT FIELD shb05 END IF  #FUN-CB0087 add
            END IF
           #No.FUN-BB0086--add--begin--
           SELECT ecm58 INTO g_shb.shb34 FROM ecm_file
            WHERE ecm01=g_shb.shb05
             #AND emc03=g_shb.shb06     #TQC-C20334
              AND ecm03=g_shb.shb06     #TQC-C20334
              AND ecm012=g_shb.shb012
           LET g_shb.shb111 = s_digqty(g_shb.shb111,g_shb.shb34)
           LET g_shb.shb112 = s_digqty(g_shb.shb112,g_shb.shb34)
           LET g_shb.shb114 = s_digqty(g_shb.shb114,g_shb.shb34)
           DISPLAY BY NAME g_shb.shb34,g_shb.shb111,g_shb.shb112,g_shb.shb114
           #No.FUN-BB0086--add--end--
            
#FUN-A50066--begin--add-------------
       AFTER FIELD shb012
           IF NOT cl_null(g_shb.shb012) THEN
              LET l_cnt = 0
              SELECT COUNT(*) INTO l_cnt FROM ecm_file
               WHERE ecm01=g_shb.shb05
                 AND ecm012=g_shb.shb012
              IF l_cnt = 0 THEN  
                 CALL cl_err('','abm-214',1)
                 NEXT FIELD shb012
              END IF
              CALL t700_shb012('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('sel ecu:',g_errno,0)
                  LET g_shb.shb012=g_shb_t.shb012
                  NEXT FIELD shb012
               END IF
       #FUN-B20079--add--begin
              IF cl_null(g_shb.shb081) THEN
                 CALL t700_shb082('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('sel ecm:',g_errno,0)
                    LET g_shb.shb012=g_shb_t.shb012
                    NEXT FIELD shb012
                 END IF
              ELSE
                 IF cl_null(g_shb.shb06) THEN
                    CALL t700_ecm03()
                 END IF
                 CALL t700_chk_ecm()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('sel ecm:',g_errno,0)
                    LET g_shb.shb012=g_shb_t.shb012
                    NEXT FIELD shb012
                 END IF
              END IF
       #FUN-B20079--add--end
              #FUN-A80102(S)
              #平行工藝時,可以輸入製程序,但不能輸作業編號,故這裡要做一次在作業編號處理的事情
              IF p_cmd = 'a' AND NOT cl_null(g_shb.shb081) THEN #FUN-A80060
                 CALL t700_shb081_relation() RETURNING g_i
              END IF
              #FUN-A80102(E)
       #FUN-B20079--mark(S)
       #      CALL t700_shb082('a')
       #       IF NOT cl_null(g_errno) THEN
       #          CALL cl_err('sel ecu:',g_errno,0)
       #          LET g_shb.shb012=g_shb_t.shb012
       #       END IF
       #FUN-B20079--mark(E)
               #TQC-AC0277--begin-add---
               IF g_shb.shb012 IS NOT NULL AND NOT cl_null(g_shb.shb06) THEN
                  IF NOT t700_subqty() THEN
                     CALL cl_err(g_shb.shb081,'asf-160',1)
                     LET INT_FLAG = TRUE
                     EXIT INPUT
                END IF
               END IF
               #TQC-AC0277--end--add-----
           END IF
           #No.FUN-BB0086--add--begin--
           SELECT ecm58 INTO g_shb.shb34 FROM ecm_file
            WHERE ecm01=g_shb.shb05
             #AND emc03=g_shb.shb06     #TQC-C20334
              AND ecm03=g_shb.shb06     #TQC-C20334
              AND ecm012=g_shb.shb012
           LET g_shb.shb111 = s_digqty(g_shb.shb111,g_shb.shb34)
           LET g_shb.shb112 = s_digqty(g_shb.shb112,g_shb.shb34)
           LET g_shb.shb114 = s_digqty(g_shb.shb114,g_shb.shb34)
           DISPLAY BY NAME g_shb.shb34,g_shb.shb111,g_shb.shb112,g_shb.shb114
           #No.FUN-BB0086--add--end--           
        
        AFTER FIELD shb06
           IF NOT cl_null(g_shb.shb06) THEN
              IF cl_null(g_shb.shb012) THEN LET g_shb.shb012=' ' END IF #FUN-A60095
              LET l_cnt = 0
              SELECT 	COUNT(*) INTO l_cnt FROM ecm_file
               WHERE ecm01=g_shb.shb05
                 AND ecm012=g_shb.shb012
                 AND ecm03=g_shb.shb06
              IF l_cnt = 0 THEN  
                 CALL cl_err('','abm-215',1)
                 NEXT FIELD shb06
              END IF
              IF cl_null(g_shb.shb081) THEN     #FUN-B20079
                 CALL t700_shb082('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('sel ecu:',g_errno,0)
                    LET g_shb.shb012=g_shb_t.shb012
                    NEXT FIELD shb06
                 END IF
        #FUN-B20079--add--begin
              ELSE
                 CALL t700_chk_ecm()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('sel ecm:',g_errno,0)
                    LET g_shb.shb06=g_shb_t.shb06
                    NEXT FIELD shb06
                 END IF
              END IF
        #FUN-B20079--add--end
              #FUN-A80102(S)
              #平行工藝時,可以輸入製程序,但不能輸作業編號,故這裡要做一次在作業編號處理的事情
              IF p_cmd = 'a' AND NOT cl_null(g_shb.shb081) THEN  #FUN-A80060
                 CALL t700_shb081_relation() RETURNING g_i
              END IF
              #FUN-A80102(E)
              #TQC-AC0277--begin-add---
              IF g_shb.shb012 IS NOT NULL AND NOT cl_null(g_shb.shb06) THEN
                 IF NOT t700_subqty() THEN
                    CALL cl_err(g_shb.shb081,'asf-160',1)
                    LET INT_FLAG = TRUE
                    EXIT INPUT
               END IF
              END IF
              #TQC-AC0277--end--add-----
           END IF
#FUN-A50066--end--add----------------------------
           #No.FUN-BB0086--add--begin--
           SELECT ecm58 INTO g_shb.shb34 FROM ecm_file
            WHERE ecm01=g_shb.shb05
             #AND emc03=g_shb.shb06     #TQC-C20334
              AND ecm03=g_shb.shb06     #TQC-C20334
              AND ecm012=g_shb.shb012
           LET g_shb.shb111 = s_digqty(g_shb.shb111,g_shb.shb34)
           LET g_shb.shb112 = s_digqty(g_shb.shb112,g_shb.shb34)
           LET g_shb.shb114 = s_digqty(g_shb.shb114,g_shb.shb34)
           DISPLAY BY NAME g_shb.shb34,g_shb.shb111,g_shb.shb112,g_shb.shb114
           #No.FUN-BB0086--add--end--
              
 
#-----------由委外入庫轉入時,作業編號不可異動
        AFTER FIELD shb081
            IF NOT cl_null(g_shb.shb081) THEN
       #FUN-B20079--add--begin
               LET l_cnt = 0
               IF g_shb.shb012 IS NOT NULL THEN
                  SELECT COUNT(*) INTO l_cnt FROM ecm_file
                   WHERE ecm01=g_shb.shb05 AND ecm012=g_shb.shb012
                     AND ecm04=g_shb.shb081
               ELSE
                  SELECT COUNT(*) INTO l_cnt FROM ecm_file
                   WHERE ecm01=g_shb.shb05 AND ecm04=g_shb.shb081
               END IF
               IF l_cnt = 0 THEN CALL cl_err('','aec-015',1) NEXT FIELD shb081 END IF
               CALL t700_shb081()

#MOD-C60147 str mark-----
##TQC-C10122 --begin--
#             IF NOT cl_null(g_shb.shb06) THEN
#                DECLARE t700_shb06_cus CURSOR FOR
#                SELECT ecm03 FROM ecm_file
#                 WHERE ecm01 = g_shb.shb05
#                   AND ecm04 = g_shb.shb081
#                   AND ecm012= g_shb.shb012
#                FOREACH t700_shb06_cus INTO l_shb06
#                   LET g_shb.shb06 = l_shb06
#                   EXIT FOREACH
#                END FOREACH
#             END IF
##TQC-C10122 --end--
#MOD-C60147 end mark-----


       #FUN-B20079--add--end
               IF t700_shb081_relation() THEN NEXT FIELD shb081 END IF
               SELECT sma126 INTO l_sma126 FROM sma_file
               IF l_sma126 = 'Y' THEN
                  CALL t700_shb111() RETURNING l_shb111,l_sgl08_min           
                  IF l_shb111 <= 0 THEN
                     LET l_shb111 = 0
                  END IF
                  LET g_shb.shb111 = l_shb111
                  DISPLAY BY NAME g_shb.shb111
                  CALL t700_shb112() RETURNING l_shb112,l_sgl09_max
                  IF l_shb112 <= 0 THEN
                     LET l_shb112 = 0
                  END IF
                  LET g_shb.shb112 = l_shb112
                  DISPLAY BY NAME g_shb.shb112
               END IF
              #此站為製程外包
              #IF g_ecm.ecm52 = 'Y' THEN                                  #No.TQC-A80085 
              #IF g_ecm.ecm52 = 'Y' AND cl_null(g_shb.shb14) THEN         #No.TQC-A80085 #TQC-AC0277
               IF NOT t700_subqty() THEN                                  #TQC-AC0277
                  CALL cl_err(g_shb.shb081,'asf-160',1)
                  LET INT_FLAG = TRUE
                  EXIT INPUT
               END IF
               CALL t700_accept_qty('d') RETURNING g_i
               IF g_sma.sma897='N' THEN
                  IF cl_null(g_shb.shb012) THEN LET g_shb.shb012 = ' ' END IF #FUN-A60095
                  SELECT COUNT(*) INTO g_cnt FROM shb_file
                   WHERE shb05 = g_shb.shb05 AND shb06 = g_shb.shb06
                     AND shb012 = g_shb.shb012  #FUN-A60095
                  IF g_cnt > 0 THEN
                     CALL cl_err('','asf-900',0)
                     NEXT FIELD shb081
                  END IF
               END IF
            END IF
       #str MOD-A50114 add
       #若該製程有check-in的程序,應該以check-in的日期、時間預設開工日期、時間
        BEFORE FIELD shb02
           IF g_ecm.ecm54='Y' THEN
              LET l_sha041=''
              IF cl_null(g_shb.shb012) THEN LET g_shb.shb012=' ' END IF #FUN-A60095
              SELECT sha04,sha041 INTO g_shb.shb02,l_sha041
                FROM sha_file
               WHERE sha01=g_shb.shb05
                 AND sha02=g_shb.shb06
                 AND sha012=g_shb.shb012   #No.FUN-A50066
                 AND (sha08 IS NULL OR sha08=' ')
              LET g_shb.shb021=l_sha041[1,5]
              DISPLAY BY NAME g_shb.shb02,g_shb.shb021
           END IF
       #end MOD-A50114 add

        AFTER FIELD shb02
            IF NOT cl_null(g_shb.shb02) THEN
	       IF g_shb.shb02 IS NULL THEN
                  LET g_shb.shb02 = g_shb.shb02
                  DISPLAY BY NAME g_shb.shb02
               END IF
               IF g_shb.shb02 > g_shb.shb03 THEN
                  CALL cl_err(g_shb.shb02,'asf-916',1)
                  NEXT FIELD shb02
               END IF
              #MOD-C90057---S---
               SELECT sfb81 INTO l_sfb81 FROM sfb_file
                WHERE sfb01 = g_shb.shb05
               IF g_shb.shb02 < l_sfb81 THEN
                  CALL cl_err('','asf-904',1)
                  NEXT FIELD shb02
               END IF
              #MOD-C90057---E---
            END IF
 
        AFTER FIELD shb08
             IF NOT cl_null(g_shb.shb08) THEN     #MOD-530497-3	
               SELECT count(*) INTO g_cnt FROM ecg_file
                WHERE ecg01 = g_shb.shb08
               IF g_cnt = 0  THEN
                  CALL cl_err(g_shb.shb08,'aec-001',1)
                  LET g_shb.shb08 = g_shb_t.shb08
                  DISPLAY BY NAME g_shb.shb08
                  NEXT FIELD shb08
               END IF
            END IF
 
        AFTER FIELD shb021
            IF NOT cl_null(g_shb.shb021) THEN
               LET g_h1=g_shb.shb021[1,2]
               LET g_m1=g_shb.shb021[4,5]
               LET g_h2=g_shb.shb031[1,2]
               LET g_m2=g_shb.shb031[4,5]
               IF cl_null(g_h1) OR cl_null(g_m1) OR g_h1>24 OR g_m1>=60 THEN
                  CALL cl_err(g_shb.shb021,'asf-807',0)
                  NEXT FIELD shb021
               END IF
               LET g_sum_m1=g_h1*60+g_m1
               LET g_sum_m2=g_h2*60+g_m2
               #TQC-BB0197--begin
              # LET l_chk_time1 = g_shb.shb02 * 365 * 24 * 60 + g_sum_m1
              # LET l_chk_time2 = g_shb.shb03 * 365 * 24 * 60 + g_sum_m2
              # IF cl_null(l_chk_time2) THEN  LET l_chk_time2 = 0 END IF
              # IF l_chk_time1 > l_chk_time2  THEN
               LET l_chk_time1 = (g_shb.shb03-g_shb.shb02)* 24 * 60 + g_sum_m2-g_sum_m1
               IF l_chk_time1<0 THEN
               #TQC-BB0197--end
                  CALL cl_err(g_shb.shb021,'asf-917',1)
                  NEXT FIELD shb021
               END IF
               LET g_shb.shb032=(g_shb.shb03-g_shb.shb02)*24*60+(g_sum_m2-g_sum_m1)
               LET g_shb.shb033=g_shb.shb032     #FUN-910076
               DISPLAY BY NAME g_shb.shb032
               DISPLAY BY NAME g_shb.shb033      #FUN-910076
			
            END IF
 
        AFTER FIELD shb03
            IF NOT cl_null(g_shb.shb03) THEN
               SELECT sfb81,sfb37 INTO l_open,l_close
                 FROM sfb_file WHERE sfb01=g_shb.shb05 AND sfb87!='X'
               IF NOT cl_null(g_shb.shb02) AND NOT cl_null(g_shb.shb021) THEN  #TQC-BB0197
                  IF g_shb.shb03 < l_open OR g_shb.shb03 > l_close THEN
                     CALL cl_err('','asf-904',0)
                     NEXT FIELD shb03
                  END IF
               END IF #TQC-BB0197
               IF g_shb.shb02 > g_shb.shb03 THEN
                  CALL cl_err(g_shb.shb03,'asf-916',1)
                  NEXT FIELD shb03
               END IF
#bugno:5206 add check 成會關帳日期...................................
               IF g_shb.shb03 <= g_sma.sma53 THEN
                  CALL cl_err('','axm-164',0)
                  NEXT FIELD shb03
               END IF
            END IF
        AFTER FIELD shb031
            IF NOT cl_null(g_shb.shb031) THEN
	       IF g_shb.shb031 IS NULL THEN
                  LET g_shb.shb031 = g_shb.shb031
                  DISPLAY BY NAME g_shb.shb031
               END IF
               LET g_h1=g_shb.shb021[1,2]
               LET g_m1=g_shb.shb021[4,5]
               LET g_h2=g_shb.shb031[1,2]
               LET g_m2=g_shb.shb031[4,5]
               IF cl_null(g_h2) OR cl_null(g_m2) OR g_h2>24 OR g_m2>=60
                  THEN
                  CALL cl_err(g_shb.shb031,'asf-807',0)
                  NEXT FIELD shb031
               END IF
               LET g_sum_m1=g_h1*60+g_m1
               LET g_sum_m2=g_h2*60+g_m2
               #TQC-BB0197--begin
              #LET l_chk_time1 = g_shb.shb02 * 365 * 24 * 60 + g_sum_m1
              #LET l_chk_time2 = g_shb.shb03 * 365 * 24 * 60 + g_sum_m2
              #IF cl_null(l_chk_time1) THEN  LET l_chk_time1 = 0 END IF
              #IF l_chk_time1 > l_chk_time2  THEN
               LET l_chk_time1 = (g_shb.shb03-g_shb.shb02)* 24 * 60 + g_sum_m2-g_sum_m1
               IF l_chk_time1<0 THEN
               ##TQC-BB0197--end   
                  CALL cl_err(g_shb.shb031,'asf-917',1)
                  NEXT FIELD shb031
               END IF
               LET g_shb.shb032=(g_shb.shb03-g_shb.shb02)*24*60+(g_sum_m2-g_sum_m1)
               LET g_shb.shb033=g_shb.shb032    #FUN-910076
               DISPLAY BY NAME g_shb.shb032
               DISPLAY BY NAME g_shb.shb033     #FUN-910076 
            END IF
 
        BEFORE FIELD shb032
            IF g_shb.shb032 = 0   THEN
               LET g_shb.shb032 = (g_shb.shb03-g_shb.shb02) * 8 +
                                  (g_shb.shb031-g_shb.shb021)
               LET g_shb.shb033 = g_shb.shb032     #FUN-910076
               DISPLAY BY NAME g_shb.shb032
               DISPLAY BY NAME g_shb.shb033        #FUN-910076
            END IF
	    IF g_shb.shb03 IS NULL OR g_shb.shb032 = 0 THEN
               LET g_shb.shb032 = g_shb_t.shb032
               LET g_shb.shb033 = g_shb.shb032     #FUN-910076
               DISPLAY By NAME g_shb.shb032
               DISPLAY BY NAME g_shb.shb033        #FUN-910076
            END IF
 
        AFTER FIELD shb032
            IF NOT cl_null(g_shb.shb032) THEN
               IF g_shb.shb032 < 0 THEN
                  CALL cl_err(g_shb.shb032,'asf-807',1)
                  NEXT FIELD shb032
               END IF
 
               LET l_day = g_shb.shb032 / 1440       # 算出天數
               LET l_min = g_shb.shb032 MOD 1440     # 算出分鐘數
               LET l_shb031 = (g_shb.shb031[1,2]*60 + g_shb.shb031[4,5]) MOD 1440
               LET l_shb02 = g_shb.shb03 - l_day
               IF l_shb031 < l_min THEN              #有跨天的情況
                 LET l_shb02 = l_shb02 - 1
                 LET l_shb021 = (l_shb031 - l_min) + 1440
               ELSE
                 LET l_shb021 = l_shb031 - l_min
               END IF
               LET l_hh = l_shb021 / 60              #算時
               LET l_mm = l_shb021 MOD 60            #算分
 
               IF NOT cl_null(l_shb02) THEN    #no.MOD-7B0117
                   LET g_shb.shb02 = l_shb02  
               END IF                          #no.MOD-7B0117   
               IF NOT cl_null(l_hh) AND NOT cl_null(l_mm) THEN    #no.MOD-7B0117
                   LET g_shb.shb021 = l_hh USING '&&', ':', l_mm USING '&&'
               END IF                                             #no.MOD-7B0117
               DISPLAY BY NAME g_shb.shb02
               DISPLAY BY NAME g_shb.shb021
               SELECT sma126 INTO l_sma126 FROM sma_file
               IF l_sma126 = 'Y' THEN
                  IF cl_null(g_shb.shb012) THEN LET g_shb.shb012=' ' END IF #FUN-A60095
                  SELECT SUM(sgl11/(sgl08+sgl09)) INTO l_sgl11_aver
                    FROM sgl_file,sgk_file
                   WHERE sgl01 = sgk01
                     AND sgl04 = g_shb.shb05
                     AND sgl06 = g_shb.shb06
                     AND sgl012= g_shb.shb012   #FUN-A50066
                     AND sgk07 = 'Y'
                     AND sgkacti = 'Y'
                  IF cl_null(l_sgl11_aver) THEN LET l_sgl11_aver = 0 END IF
                  LET l_shb032=(g_shb.shb111+g_shb.shb112)*l_sgl11_aver
                  IF g_shb.shb032 != l_shb032 THEN
                     IF cl_confirm('asf-114') THEN
                        LET g_shb.shb032 = l_shb032
                        DISPLAY BY NAME g_shb.shb032
                     END IF
                  END IF
               END IF
            END IF
 
 
        AFTER FIELD shb033
            IF NOT cl_null(g_shb.shb033) THEN
               IF g_shb.shb033 < 0 THEN
                  CALL cl_err(g_shb.shb033,'asf-807',1)
                  NEXT FIELD shb033
               END IF
            END IF
 
        BEFORE FIELD shb111
            CALL t700_accept_qty('d') RETURNING g_i
 
#-------由委外入庫轉入時,數量不可異動
        AFTER FIELD shb111
           #No.FUN-BB0086--add--begin--
           SELECT ecm58 INTO g_shb.shb34 FROM ecm_file
            WHERE ecm01=g_shb.shb05
             #AND emc03=g_shb.shb06     #TQC-C20334
              AND ecm03=g_shb.shb06     #TQC-C20334
              AND ecm012=g_shb.shb012
           LET g_shb.shb111 = s_digqty(g_shb.shb111,g_shb.shb34)
           DISPLAY BY NAME g_shb.shb111
           #No.FUN-BB0086--add--end--
            IF NOT cl_null(g_shb.shb111) THEN
               IF g_shb.shb111 < 0  THEN
                  NEXT FIELD shb111
               END IF
               ## 檢查可報工數量
               IF cl_null(g_shb.shb14) THEN        #CHI-C50054 add
                  IF t700_accept_qty('c') THEN NEXT FIELD shb111 END IF
              #CHI-C50054 str add-----
               ELSE
                  IF t700_chk_rvv17() THEN NEXT FIELD shb111 END IF
               END IF
              #CHI-C50054 end add-----
              #IF g_shb.shb111*g_ecm.ecm59 > g_wip_qty THEN #TQC-810076  #No.FUN-A50066
               IF g_shb.shb111 > g_wip_qty THEN             #No.FUN-A50066 ecm59 -> no use
                  IF cl_confirm('asf-047') THEN
                     LET g_shb.shb115 = g_shb.shb115 + (g_shb.shb111 - g_shb.shb115)
                     LET g_shb.shb111 = g_wip_qty
                  ELSE
                     LET g_shb.shb111 = g_wip_qty
                  END IF
                  LET g_shb.shb111 = s_digqty(g_shb.shb111,g_shb.shb34)   #No.FUN-BB0086
                  DISPLAY BY NAME g_shb.shb05,g_shb.shb06,g_shb.shb111,
                                  g_shb.shb14,g_shb.shb15
                  IF t700_accept_qty('c') THEN NEXT FIELD shb111 END IF
               END IF
               #FUN-A50066--begin--add-------------
               LET g_cnt = 0
               IF g_sma.sma541 = 'Y' AND l_sfb93 = 'Y' THEN  
                  SELECT COUNT(*) INTO g_cnt FROM sfa_file
                   WHERE sfa01=g_shb.shb05
                     AND sfa012=g_shb.shb012
                     AND sfa013=g_shb.shb06
               ELSE
               #FUN-A50066--end--add--------------
                  SELECT COUNT(*) INTO g_cnt FROM sfa_file
                   WHERE sfa01=g_shb.shb05
                     AND sfa08=g_shb.shb081
               END IF  #FUN-A50066
               IF g_cnt > 0 THEN
               #FUN-A50066--begin--add--------------------
                    CALL t700_shb111_a()
                    IF g_success='N' THEN NEXT FIELD shb111 END IF
               ELSE
                  IF g_sma.sma541='Y' AND l_sfb93 = 'Y' THEN
                     SELECT ecm65 INTO l_ecm65 FROM ecm_file WHERE ecm01=g_shb.shb05
                        AND ecm03=g_shb.shb06 AND ecm012=g_shb.shb012
                     IF g_shb.shb111 > l_ecm65 THEN
                        CALL cl_err('','asf-139',1)
                        NEXT FIELD shb111
                     END IF
                  END IF
               END IF
               #FUN-A50066--end--add-----------------
                 #FUN-A50066--behin--mark--------------------
                 #CALL s_get_ima153(g_shb.shb10) RETURNING l_ima153  #FUN-910053  
                 #CALL s_minp(g_shb.shb05,g_sma.sma73,l_ima153,g_shb.shb081) #FUN-910053
                 #RETURNING g_cnt,g_min_set
                 #IF g_cnt !=0  THEN
                 #   CALL cl_err(g_shb.shb05,'asf-549',1)
                 #   NEXT FIELD shb111
                 #END IF
                 #IF g_shb.shb111 > g_min_set THEN
                 #   CALL cl_err(g_shb.shb05,'asf-670',1)
                 #   NEXT FIELD shb111
                 #END IF
                 #FUN-A50066--end--mark----------------------
            END IF
            SELECT sma126 INTO l_sma126 FROM sma_file
            IF l_sma126 = 'Y' THEN
               CALL t700_shb111() RETURNING l_shb111,l_sgl08_min
               IF g_shb.shb111 > l_sgl08_min - l_shb111 THEN
                  CALL cl_err('','asf-111',0)
                  NEXT FIELD shb111
               END IF
            END IF
 
             IF s_industry('slk') THEN
                SELECT sma127 INTO l_sma127 FROM sma_file
                IF l_sma127 = 'Y'THEN
             #check本工單，工序是否需要裁片管理
                  IF cl_null(g_shb.shb012) THEN LET g_shb.shb012=' ' END IF #FUN-A60095
                  SELECT ecmslk01 INTO l_ecmslk01 FROM ecm_file
                  WHERE ecm01 = g_shb.shb05
                    AND ecm03 = g_shb.shb06
                    AND ecm012 = g_shb.shb012  #FUN-A50066
                  IF l_ecmslk01 = 'Y' THEN
                     SELECT MIN(skr06) INTO l_skr06_min 
                       FROM skr_file
                     WHERE skr01 = g_shb.shb05
                       AND skr02 = g_shb.shb06
                     SELECT SUM(shb111) INTO l_shb111_0 FROM shb_file
                     WHERE shb05 = g_shb.shb05
                       AND shb06 = g_shb.shb06
                       AND shb012= g_shb.shb012  #FUN-A50066
                     IF l_shb111_0 IS NULL THEN LET l_shb111_0 = 0 END IF
                     IF g_shb.shb111 > l_skr06_min - l_shb111_0 THEN
                        CALL cl_err('','asf-112',0)
                        NEXT FIELD shb111
                     END IF   
                  END IF
                END IF  
             END IF
 
        AFTER FIELD shb112
           #No.FUN-BB0086--add--begin--
           SELECT ecm58 INTO g_shb.shb34 FROM ecm_file
            WHERE ecm01=g_shb.shb05
             #AND emc03=g_shb.shb06     #TQC-C20334
              AND ecm03=g_shb.shb06     #TQC-C20334
              AND ecm012=g_shb.shb012
           LET g_shb.shb112 = s_digqty(g_shb.shb112,g_shb.shb34)
           DISPLAY BY NAME g_shb.shb112
           #No.FUN-BB0086--add--end--
            IF NOT cl_null(g_shb.shb112) THEN
               IF g_shb.shb112 < 0  THEN
                  NEXT FIELD shb112
               END IF
               ## 檢查可報工數量
               IF cl_null(g_shb.shb14) THEN        #CHI-C50054 add
                  IF t700_accept_qty('c') THEN NEXT FIELD shb112 END IF
              #CHI-C50054 str add-----
               ELSE
                  IF t700_chk_rvv17() THEN NEXT FIELD shb112 END IF
               END IF
              #CHI-C50054 end add-----
               SELECT sma126 INTO l_sma126 FROM sma_file
               IF l_sma126 = 'Y' THEN
                  CALL t700_shb112() RETURNING l_shb112,l_sgl09_max
                  IF g_shb.shb112 > l_sgl09_max - l_shb112 THEN
                     CALL cl_err('','asf-113',0)
                     NEXT FIELD shb112
                  END IF
               END IF
            END IF
 
        BEFORE FIELD shb113
            CALL t700_set_entry(p_cmd)
 
        AFTER FIELD shb113
           #No.FUN-BB0086--add--begin--
           SELECT ecm58 INTO g_shb.shb34 FROM ecm_file
            WHERE ecm01=g_shb.shb05
             #AND emc03=g_shb.shb06     #TQC-C20334
              AND ecm03=g_shb.shb06     #TQC-C20334
              AND ecm012=g_shb.shb012
           LET g_shb.shb113 = s_digqty(g_shb.shb113,g_shb.shb34)
           DISPLAY BY NAME g_shb.shb113
           #No.FUN-BB0086--add--end--
            IF NOT cl_null(g_shb.shb113) THEN
               IF g_shb.shb113 < 0  THEN
                  NEXT FIELD shb113
               END IF
               IF g_shb.shb113 = 0  THEN
                  IF g_sma.sma541 = 'Y' THEN      #MOD-B70226
                     LET g_shb.shb121=''   #FUN-A50066
                  END IF                          #MOD-B70226
                  LET g_shb.shb12 =''
                  DISPLAY BY NAME g_shb.shb12,g_shb.shb121  #FUN-A50066 
               END IF
               ## 檢查可報工數量
               IF cl_null(g_shb.shb14) THEN        #CHI-C50054 add
                  IF t700_accept_qty('c') THEN NEXT FIELD shb113 END IF
              #CHI-C50054 str add-----
               ELSE
                  IF t700_chk_rvv17() THEN NEXT FIELD shb113 END IF
               END IF
              #CHI-C50054 end add-----
            END IF
             CALL t700_set_no_entry(p_cmd)  #MOD-490191
 
        AFTER FIELD shb114
           #No.FUN-BB0086--add--begin--
           SELECT ecm58 INTO g_shb.shb34 FROM ecm_file
            WHERE ecm01=g_shb.shb05
             #AND emc03=g_shb.shb06     #TQC-C20334
              AND ecm03=g_shb.shb06     #TQC-C20334
              AND ecm012=g_shb.shb012
           LET g_shb.shb114 = s_digqty(g_shb.shb114,g_shb.shb34)
           DISPLAY BY NAME g_shb.shb114
           #No.FUN-BB0086--add--end--
            IF NOT cl_null(g_shb.shb114) THEN
               IF g_shb.shb114 < 0  THEN
                  NEXT FIELD shb114
               END IF
               IF g_shb.shb114 = 0 THEN
                  LET l_cnt = 0
                  SELECT COUNT(*) INTO l_cnt FROM shd_file
                   WHERE shd01=g_shb.shb01
                  IF l_cnt > 0  THEN
                     CALL cl_err('sel-shd','asf-671',1)
                     LET g_shb.shb114 = g_shb_t.shb114
                     DISPLAY BY NAME g_shb.shb114
                     NEXT FIELD shb114
                  END IF
               END IF
               ## 檢查可報工數量
               IF cl_null(g_shb.shb14) THEN        #CHI-C50054 add
                  IF t700_accept_qty('c') THEN NEXT FIELD shb114 END IF
              #CHI-C50054 str add-----
               ELSE
                  IF t700_chk_rvv17() THEN NEXT FIELD shb114 END IF
               END IF
              #CHI-C50054 end add-----
            END IF
 
        AFTER FIELD shb17
           #No.FUN-BB0086--add--begin--
           SELECT ecm58 INTO g_shb.shb34 FROM ecm_file
            WHERE ecm01=g_shb.shb05
             #AND emc03=g_shb.shb06     #TQC-C20334
              AND ecm03=g_shb.shb06     #TQC-C20334
              AND ecm012=g_shb.shb012
           LET g_shb.shb17 = s_digqty(g_shb.shb17,g_shb.shb34)
           DISPLAY BY NAME g_shb.shb17
           #No.FUN-BB0086--add--end--
            IF NOT cl_null(g_shb.shb17) THEN
               IF g_shb.shb17 < 0  THEN
                  NEXT FIELD shb17
               END IF
               ## 檢查可報工數量
               IF cl_null(g_shb.shb14) THEN        #CHI-C50054 add
                  IF t700_accept_qty('c') THEN NEXT FIELD shb17 END IF
              #CHI-C50054 str add-----
               ELSE
                  IF t700_chk_rvv17() THEN NEXT FIELD shb17 END IF
               END IF
              #CHI-C50054 end add-----
            END IF
 
        AFTER FIELD shb12
#           shb113 重工轉出數量=0不輸入下製
#FUN-A50066--begin--modify---------------------------
#           IF NOT cl_null(g_shb.shb12) THEN
#              IF g_shb.shb12=g_shb.shb06 THEN
#                 CALL cl_err(g_shb.shb12,'aec-086',0)
#                 NEXT FIELD shb12
#              END IF
#              ## 檢查是否有此下製程
#              SELECT count(*) INTO g_cnt FROM ecm_file
#               WHERE ecm01 = g_shb.shb05
#                 AND ecm03 = g_shb.shb12
#                #AMD ecm012 = g_shb.shb121  #FUN-A50066
#              IF g_cnt = 0  THEN
#                 CALL cl_err(g_shb.shb12,'aec-085',0)
#                 LET g_shb.shb12 = g_shb_t.shb12
#                 DISPLAY BY NAME g_shb.shb12
#                 NEXT FIELD shb12
#              END IF
#           END IF
            CALL t700_chk_shb12()
            IF g_success = 'N' THEN NEXT FIELD shb012 END IF
#FUN-A50066--end--modify---------------------------------

#FUN-A50066--begin--add----------------------------------
         AFTER FIELD shb121 
            CALL t700_chk_shb12() 
#FUN-B20097 ------------------Begin----------------------
            IF g_success = 'Y' THEN
               CALL t700_chk_shb121()
            END IF
#FUN-B20097 ------------------End------------------------
            IF g_success = 'N' THEN NEXT FIELD shb012 END IF
#FUN-A50066--end--add------------------------------------
 
        AFTER FIELD shbud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shbud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shbud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shbud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shbud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shbud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shbud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shbud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shbud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shbud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shbud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shbud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shbud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shbud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shbud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER INPUT
           LET g_shb.shbuser = s_get_data_owner("shb_file") #FUN-C10039
           LET g_shb.shbgrup = s_get_data_group("shb_file") #FUN-C10039
           IF INT_FLAG THEN EXIT INPUT END IF
           IF cl_null(g_shb.shb111) THEN LET g_shb.shb111 = 0 END IF
           IF cl_null(g_shb.shb112) THEN LET g_shb.shb112 = 0 END IF
           IF cl_null(g_shb.shb113) THEN LET g_shb.shb113 = 0 END IF
           IF cl_null(g_shb.shb114) THEN LET g_shb.shb114 = 0 END IF
           IF cl_null(g_shb.shb115) THEN LET g_shb.shb115 = 0 END IF
           IF cl_null(g_shb.shb17)  THEN LET g_shb.shb17 = 0 END IF
           IF g_shb.shb113 = 0  THEN  # 重工轉出數量=0不輸入下製程
              LET g_shb.shb12=''
              IF g_sma.sma541 = 'Y' THEN   #MOD-B70226
                 LET g_shb.shb121=''     #FUN-A50066
              END IF                       #MOD-B70226
              DISPLAY BY NAME g_shb.shb12,g_shb.shb121  #FUN-A50066
           ELSE
## ---下製程不可等於本製程---
             #FUN-A50066--begin--modify--------------
             #IF g_shb.shb12=g_shb.shb06 THEN
             #   CALL cl_err(g_shb.shb12,'aec-086',0)
             #   NEXT FIELD shb12
             #END IF
              CALL t700_chk_shb12()
#FUN-B20097 ------------------Begin-------------------
              IF g_success = 'Y' THEN
                 CALL t700_chk_shb121()
              END IF
#FUN-B20097 ------------------End---------------------
              IF g_success='N' THEN NEXT FIELD shb12 END IF
             #FUN-A50066--end--modify---------------- 
           END IF
         #TQC-B60219 -------------Begin---------------
           IF NOT cl_null(g_shb.shb04) THEN
              CALL t700_shb04('d')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,1)
                 NEXT FIELD shb04
              END IF
           END IF
         #TQC-B60219 -------------End-----------------   
          #CHI-C50054 str mark-----
          #IF t700_accept_qty('c') THEN 
          #   IF cl_null(g_shb.shb14) THEN
          #      NEXT FIELD shb111 
          #   ELSE
          #      NEXT FIELD shb115
          #   END IF    
          #END IF
          #CHI-C50054 str mark-----
          #CHI-C50054 str add------
           IF cl_null(g_shb.shb14) THEN
              IF t700_accept_qty('c') THEN NEXT FIELD shb111 END IF
           ELSE
              IF t700_chk_rvv17() THEN NEXT FIELD shb115 END IF
           END IF
          #CHI-C50054 end add------
          #MOD-CB0209 add---S
           #IF t700_chk_input(g_shb.shb01,g_shb.shb05,g_shb.shb111,g_shb.shb112,g_shb.shb114,g_shb.shb17) THEN  #MOD-D30233
           IF t700_chk_input() THEN  #MOD-D30233
              NEXT FIELD shb111 
           END IF   
          #MOD-CB0209 add---E

        ON ACTION controlp
           CASE WHEN INFIELD(shb01) #查詢單据
                     LET g_t1 = s_get_doc_no(g_shb.shb01)     #No.FUN-550067
                     CALL q_smy(FALSE,TRUE,g_t1,'ASF','9') RETURNING g_t1  #TQC-970251
                     LET g_shb.shb01=g_t1     #No.FUN-550067
                     DISPLAY BY NAME g_shb.shb01
                     NEXT FIELD shb01
                WHEN INFIELD(shb04)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form     ="q_gen"
                     LET g_qryparam.default1 = g_shb.shb04
                     CALL cl_create_qry() RETURNING g_shb.shb04
                     DISPLAY BY NAME g_shb.shb04
                     NEXT FIELD shb04
                WHEN INFIELD(shb07)
                     CALL q_eca(FALSE,TRUE,g_shb.shb07) RETURNING g_shb.shb07
                      DISPLAY BY NAME g_shb.shb07    #No.MOD-490371
                     NEXT FIELD shb07
                WHEN INFIELD(shb09)                 #機械編號
                     IF g_sma.sma901 = 'Y' THEN    #串APS
                        #FUN-960106 MARK --STR-----------------------------
                        #IF g_ecm.ecm61 = 'Y' THEN #行加工='Y'
                        #    CALL cl_init_qry_var()
                        #    LET g_qryparam.form     = "q_vlj02"
                        #    LET g_qryparam.default1 = g_shb.shb09
                        #    LET g_qryparam.arg1     = g_shb.shb05
                        #    LET g_qryparam.arg2     = g_sma.sma917
                        #    LET g_qryparam.arg3     = g_shb.shb06
                        #    CALL cl_create_qry() RETURNING g_shb.shb09
                        #    DISPLAY BY NAME g_shb.shb09
                        #    NEXT FIELD shb09
                        #ELSE
                        #    IF g_sma.sma917 = 0 THEN 
                        #        #工作站
                        #        CALL cl_init_qry_var()
                        #        LET g_qryparam.form     = "q_ecm06"
                        #        LET g_qryparam.default1 = g_shb.shb09
                        #        LET g_qryparam.arg1     = g_shb.shb05
                        #        LET g_qryparam.arg2     = g_shb.shb06
                        #        CALL cl_create_qry() RETURNING g_shb.shb09
                        #        DISPLAY BY NAME g_shb.shb09
                        #        NEXT FIELD shb09
                        #    ELSE
                        #        #機器編號
                        #        CALL cl_init_qry_var()
                        #        LET g_qryparam.form     = "q_ecm05"
                        #        LET g_qryparam.default1 = g_shb.shb09
                        #        LET g_qryparam.arg1     = g_shb.shb05
                        #        LET g_qryparam.arg2     = g_shb.shb06
                        #        CALL cl_create_qry() RETURNING g_shb.shb09
                        #        DISPLAY BY NAME g_shb.shb09
                        #        NEXT FIELD shb09
                        #    END IF
                        #END IF
                        #FUN-960106 MARK --END-----------------------------
                        #FUN-960106 ADD --STR------------------------------
                         IF g_ecm.ecm61 = 'Y' THEN #鎖定設備='Y'
                             CALL cl_init_qry_var()
                             IF g_sma.sma917 = 0 THEN
                                LET g_qryparam.form     = "q_vne02"
                             ELSE
                                LET g_qryparam.form     = "q_vne01"
                             END IF
                             LET g_qryparam.arg1     = g_shb.shb05
                             LET g_qryparam.arg2     = g_shb.shb05
                             LET g_qryparam.arg3     = g_shb.shb06
                             CALL cl_create_qry() RETURNING g_shb.shb09
                             DISPLAY BY NAME g_shb.shb09
                             NEXT FIELD shb09
                         ELSE
                             LET l_vmn08 = NULL
                             LET l_vmn081 =  NULL
                             SELECT vmn08,vmn081 INTO l_vmn08,l_vmn081
                               FROM vmn_file
                             WHERE vmn01=g_shb.shb10 and vmn02=g_shb.shb05 and vmn03=g_shb.shb06
                             IF NOT cl_null(l_vmn08) OR NOT cl_null(l_vmn081) THEN
                                IF g_sma.sma917 = 0 THEN
                                  #工作站
                                   CALL cl_init_qry_var()
                                   LET g_qryparam.form     = "q_vmp02"
                                   LET g_qryparam.arg1     = l_vmn081
                                   CALL cl_create_qry() RETURNING g_shb.shb09
                                   DISPLAY BY NAME g_shb.shb09
                                   NEXT FIELD shb09
                               ELSE
                                   #機器編號
                                   CALL cl_init_qry_var()
                                   LET g_qryparam.form     = "q_vme02"
                                   LET g_qryparam.arg1     = l_vmn08
                                   CALL cl_create_qry() RETURNING g_shb.shb09
                                   DISPLAY BY NAME g_shb.shb09
                                   NEXT FIELD shb09
                               END IF
                             END IF
                         END IF
                        #FUN-960106 ADD --END------------------------------
                     ELSE
                         CALL cl_init_qry_var()
                         LET g_qryparam.form     = "q_eci"
                         LET g_qryparam.default1 = g_shb.shb09
                         CALL cl_create_qry() RETURNING g_shb.shb09
                         DISPLAY BY NAME g_shb.shb09
                         NEXT FIELD shb09
                    END IF 
                WHEN INFIELD(shb05)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_sfb2402"
                     LET g_qryparam.construct = "Y"
                     LET g_qryparam.default1 = g_shb.shb05
                     LET g_qryparam.arg1     = 234567
                     CALL cl_create_qry() RETURNING g_shb.shb05
                     DISPLAY BY NAME g_shb.shb05
                     NEXT FIELD shb05
                WHEN INFIELD(shb08)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form     = "q_ecg"
                     LET g_qryparam.default1 = g_shb.shb08
                     CALL cl_create_qry() RETURNING g_shb.shb08
                     DISPLAY BY NAME g_shb.shb08
                     NEXT FIELD shb08
                WHEN INFIELD(shb081)
                     IF cl_null(g_shb.shb012) THEN LET g_shb.shb012=' ' END IF #FUN-A60095
                     CALL q_ecm02( FALSE,FALSE,g_shb.shb05,'') RETURNING g_shb.shb081,g_shb.shb06
                     SELECT ecm03,ecm05,ecm45,ecm06                          #TQC-8A0013 add ecm06
                       INTO g_shb.shb06,g_shb.shb09,g_shb.shb082,g_shb.shb07 #TQC-8A0013 add shb07
                       FROM ecm_file
                      WHERE ecm01=g_shb.shb05 AND ecm04=g_shb.shb081
                        AND ecm03=g_shb.shb06
                        AND ecm012=g_shb.shb012 #FUN-A50066
                     IF STATUS THEN  #資料資料不存在
                        CALL cl_err(g_shb.shb081,g_errno,0)
                        LET g_shb.shb081 = g_shb_t.shb081
                        LET g_shb.shb06 = g_shb_t.shb06  #FUN-A80102
                        DISPLAY BY NAME g_shb.shb081,g_shb.shb06  #FUN-A80102
                        NEXT FIELD shb081
                     END IF
                     IF g_sma.sma901 = 'Y' AND g_sma.sma917 = 0 THEN 
                         #工作站
                         LET g_shb.shb09 = g_shb.shb07
                         DISPLAY BY NAME g_shb.shb09
                     END IF
                     DISPLAY BY NAME g_shb.shb09,g_shb.shb081,g_shb.shb082
                    #LET g_chr   = 'Y'          #MOD-9B0151  #FUN-A80102 mark
                    #LET g_shb06 = g_shb.shb06  #MOD-9B0151  #FUN-A80102 mark
                     DISPLAY BY NAME g_shb.shb06  #FUN-A80102
                     NEXT FIELD shb081
                #FUN-A50066--begin--add------------
                WHEN INFIELD(shb121)
                     CALL cl_init_qry_var()
                   # LET g_qryparam.form     = "q_shb121"      #FUN-B10056 mark
                     LET g_qryparam.form     = "q_sgx012_2"    #FUN-B10056  
                     LET g_qryparam.default1 = g_shb.shb121
                     LET g_qryparam.default2 = g_shb.shb12
                     LET g_qryparam.arg1     = g_shb.shb05
                     CALL cl_create_qry() RETURNING g_shb.shb121,g_shb.shb12
                     DISPLAY BY NAME g_shb.shb121,g_shb.shb12
                     NEXT FIELD shb121
                #FUN-A50066--end--add------------
                WHEN INFIELD(shb12)
                     #FUN-A50066--begin--add-----------
                     IF g_sma.sma541='Y' AND l_sfb93='Y' THEN
                        CALL cl_init_qry_var()
                      # LET g_qryparam.form     = "q_shb121"       #FUN-B10056 mrk
                        LET g_qryparam.form     = "q_sgx012_2"     #FUN-B10056
                        LET g_qryparam.default1 = g_shb.shb121
                        LET g_qryparam.default2 = g_shb.shb12
                        LET g_qryparam.arg1     = g_shb.shb05
                        CALL cl_create_qry() RETURNING g_shb.shb121,g_shb.shb12
                        DISPLAY BY NAME g_shb.shb121,g_shb.shb12
                        NEXT FIELD shb12
                    ELSE
                    #FUN-A50066--end--add----------
                      #CALL q_ecm(FALSE,FALSE,g_shb.shb05,'') RETURNING g_msg,g_shb.shb12  #FUN-C30163 mark
                       CALL q_ecm(FALSE,FALSE,g_shb.shb05,'','','','','') RETURNING g_msg,g_shb.shb12   #FUN-C30163 add
                       DISPLAY BY NAME g_shb.shb12
                    END IF
                #FUN-A50066--begin--add-----------------
                WHEN INFIELD(shb012) OR INFIELD(shb06)
#FUN-B30096 -------------------Begin----------------------------- CALL cl_init_qry_var()
                #    LET g_qryparam.form     = "q_shb012"
                #    LET g_qryparam.default1 = g_shb.shb012
                #    LET g_qryparam.default2 = g_shb.shb06
                #    LET g_qryparam.default3 = g_shb.shb081
                #    LET g_qryparam.arg1     = g_shb.shb05
                #    CALL cl_create_qry() RETURNING g_shb.shb012,g_shb.shb06,g_shb.shb081
                     CALL q_ecm03(FALSE,FALSE,g_shb.shb05,g_shb.shb012,g_shb.shb06,g_shb.shb081)
                          RETURNING g_shb.shb012,g_shb.shb06,g_shb.shb081
#FUN-B30096 -------------------End-------------------------------
                     DISPLAY BY NAME g_shb.shb012,g_shb.shb06,g_shb.shb081
                    NEXT FIELD CURRENT
                #FUN-A50066--end--add---------------------
                WHEN INFIELD(shb114)
                     IF g_shb.shb114 > 0  THEN
                        CALL t701(g_shb.shb01)     
                        NEXT FIELD shb114
                     END IF
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
 
    END INPUT
 
END FUNCTION
#FUN-B20097 --------------------------Begin---------------------------
FUNCTION t700_chk_shb121()
DEFINE l_sfb93   LIKE sfb_file.sfb93
  LET l_sfb93 = ''
  SELECT sfb93 INTO l_sfb93 FROM sfb_file WHERE sfb01=g_shb.shb05
  IF g_sma.sma541 ='Y' AND l_sfb93='Y' THEN
     IF NOT cl_null(g_shb.shb121) AND NOT cl_null(g_shb.shb12) THEN
       #FUN-B30035--begin--mark----
       #IF (g_shb.shb06 < g_shb.shb12) THEN
       #   CALL cl_err('','asf-273',0)
       #   LET g_success='N'
       #   RETURN 
       #END IF
       #FUN-B30035--end--mark---
        CALL t700_chk_ecm015(g_shb.shb012,g_shb.shb121)
        IF g_success='N' THEN
           CALL cl_err('','asf-274',0)
           RETURN
        END IF
       #FUN-B30035--begin--add----
        IF g_shb.shb012=g_shb.shb121 THEN
           IF (g_shb.shb06 <= g_shb.shb12) THEN
              CALL cl_err('','asf-273',0)
              LET g_success='N'
              RETURN
           END IF
        END IF
       #FUN-B30035--end--add----
     END IF
  END IF
END FUNCTION
FUNCTION t700_chk_ecm015(p_ecm012,p_shb121)
DEFINE p_ecm012      LIKE ecm_file.ecm012      
DEFINE p_shb121      LIKE shb_file.shb121
DEFINE l_ecm012      LIKE ecm_file.ecm012
DEFINE l_ecm015      LIKE ecm_file.ecm015
DEFINE l_flag        LIKE type_file.num5
   
  SELECT DISTINCT ecm012,ecm015 INTO l_ecm012,l_ecm015 FROM ecm_file
   WHERE ecm01 = g_shb.shb05 
     AND ecm012 = p_ecm012
   IF (l_ecm015 IS NULL OR cl_null(l_ecm015)) THEN
      RETURN    
   END IF
   IF (p_shb121 = l_ecm015) THEN
      CALL cl_err('','asf-274',0) 
      LET g_success='N'
      RETURN
   ELSE
      CALL t700_chk_ecm015(l_ecm015,p_shb121) 
   END IF
END FUNCTION
#FUN-B20097 --------------------------End-----------------------------
 
#TQC-AC0277--begin--add----
FUNCTION t700_subqty()
DEFINE l_flag   LIKE type_file.num5
DEFINE l_subqty LIKE type_file.num15_3

  IF g_ecm.ecm52 = 'Y' AND cl_null(g_shb.shb14) THEN      
     IF g_shb.shb012 IS NULL THEN LET g_shb.shb012=' ' END IF
     CALL s_sub_available_qty(g_shb.shb05,g_shb.shb012,g_shb.shb06)
     RETURNING l_flag,l_subqty
     IF l_flag = FALSE OR l_subqty <= 0 THEN
        RETURN FALSE
     END IF
  END IF
  RETURN TRUE

END FUNCTION
#TQC-AC0277--end--add-------

FUNCTION t700_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
 
     IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
        CALL cl_set_comp_entry("shb01,shb07",TRUE)
     END IF
 
     IF NOT cl_null(g_argv3) OR ( NOT g_before_input_done ) THEN   #TQC-630068
        CALL cl_set_comp_entry("shb05,shb081,shb111",TRUE)
     END IF
 
     IF INFIELD(shb113) OR (NOT g_before_input_done) THEN
        #MOD-B70226  --begin
        #CALL cl_set_comp_entry("shb12,shb121",TRUE)  #FUN-A50066
        IF g_sma.sma541 = 'Y' THEN
           CALL cl_set_comp_entry("shb121",TRUE)
        END IF
        CALL cl_set_comp_entry("shb12",TRUE)  #FUN-A50066
        #MOD-B70226  --End
     END IF
    #CALL cl_set_comp_entry("shb09",TRUE) #TQC-890064 add #FUN-980080 mark
     CALL cl_set_comp_entry("shb012,shb081,shb06",FALSE) #FUN-A50066
 
END FUNCTION
 
FUNCTION t700_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
 
     IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
        CALL cl_set_comp_entry("shb01",FALSE)
     END IF
     IF p_cmd = 'u' OR ( NOT g_before_input_done ) THEN
        CALL cl_set_comp_entry("shb07",FALSE)
     END IF
 
     IF NOT cl_null(g_argv3) THEN   #TQC-630068
       #CALL cl_set_comp_entry("shb05,shb081,shb111",FALSE)  #CHI-C50054 mark
        CALL cl_set_comp_entry("shb05,shb081",FALSE)         #CHI-C50054 add
     END IF
 
     IF INFIELD(shb113) OR (NOT g_before_input_done) THEN
        IF g_shb.shb113 = 0 THEN
           #MOD-B70226  --begin
           #CALL cl_set_comp_entry("shb12,shb121",FALSE)     #FUN-A50066
           IF g_sma.sma541 = 'Y' THEN
              CALL cl_set_comp_entry("shb121",FALSE)
           END IF
           CALL cl_set_comp_entry("shb12",FALSE)     #FUN-A50066
           #MOD-B70226  --End
        END IF
        IF g_shb.shb113 > 0 THEN
           #MOD-B70227 --- modify --- start ---
           #CALL cl_set_comp_entry("shb12,shb121",TRUE)     #FUN-A50066
           #CALL cl_set_comp_required("shb12,shb121",TRUE)  #FUN-A50066
           IF g_sma.sma541 = 'Y' THEN
              CALL cl_set_comp_entry("shb121",TRUE)
              CALL cl_set_comp_required("shb121",TRUE)
           END IF
           CALL cl_set_comp_entry("shb12",TRUE)
           CALL cl_set_comp_required("shb12",TRUE)
           #MOD-B70227 --- modify ---  end  ---
        ELSE
           #MOD-B70226  --begin
           #CALL cl_set_comp_required("shb12,shb121",FALSE) #FUN-A50066
           IF g_sma.sma541 = 'Y' THEN
              CALL cl_set_comp_required("shb121",FALSE) #FUN-A50066
           END IF
           CALL cl_set_comp_required("shb12",FALSE) #FUN-A50066
           #MOD-B70226  --end
        END IF
     END IF
     #FUN-A50066--begin--add------------------
     IF g_sma.sma541='Y' THEN
        CALL cl_set_comp_entry("shb012,shb06,shb081",TRUE)   #FUN-B20079
     ELSE                                            
        CALL cl_set_comp_entry("shb081",TRUE)         #FUN-B20079
     END IF
     #FUN-A50066--end--add--------------------
 
END FUNCTION
#FUN-B20079--add--begin
FUNCTION t700_shb081()
  DEFINE l_vmn08    LIKE vmn_file.vmn08   #FUN-980080 add
  DEFINE l_vmn081   LIKE vmn_file.vmn081  #FUN-980080 add

   IF NOT cl_null(g_shb.shb06) THEN
      CALL t700_chk_ecm()
      IF NOT cl_null(g_errno) THEN
         CALL t700_ecm03()
      END IF
   ELSE
      CALL t700_ecm03()
   END IF
  #FUN-980080 add---str----
   IF g_sma.sma901 = 'Y' THEN  #是否與 APS 系統串聯 
      CALL cl_set_comp_required("shb09",TRUE)
      IF g_ecm.ecm61 = 'N' THEN    #鎖定設備='Y'
          SELECT   vmn08,  vmn081  #資源群組編號(vmn08機器/vmn081工作站)
            INTO l_vmn08,l_vmn081
            FROM vmn_file
           WHERE vmn01 = g_shb.shb10
             AND vmn02 = g_shb.shb05
             AND vmn03 = g_shb.shb06 
          IF g_sma.sma917 = 0 THEN
              #工作站
              IF cl_null(l_vmn081) THEN
                  CALL cl_set_comp_entry("shb09",FALSE)
                  LET g_shb.shb09 = g_shb.shb07
                  DISPLAY BY NAME g_shb.shb09
              ELSE
                  CALL cl_set_comp_entry("shb09",TRUE)
                  LET g_shb.shb09 = NULL
                  DISPLAY BY NAME g_shb.shb09
              END IF
          ELSE
              #機器編號
              IF cl_null(l_vmn08) THEN
                  CALL cl_set_comp_entry("shb09",FALSE)
              ELSE
                  CALL cl_set_comp_entry("shb09",TRUE)
                  LET g_shb.shb09 = NULL
                  DISPLAY BY NAME g_shb.shb09
              END IF
          END IF
      ELSE
          CALL cl_set_comp_entry("shb09",TRUE) 
      END IF
   ELSE
      CALL cl_set_comp_required("shb09",FALSE)
   END IF
  #FUN-980080 add---end----
END FUNCTION

FUNCTION t700_chk_ecm()
DEFINE l_cnt       LIKE type_file.num10
   LET g_errno=''
   IF g_sma.sma541 = 'N' THEN LET g_shb.shb012=' ' END IF
   IF NOT cl_null(g_shb.shb05) AND NOT cl_null(g_shb.shb06) AND
      g_shb.shb012 IS NOT NULL AND NOT cl_null(g_shb.shb081) THEN
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM ecm_file
       WHERE ecm01=g_shb.shb05
         AND ecm012=g_shb.shb012
         AND ecm03=g_shb.shb06
         AND ecm04=g_shb.shb081
      IF l_cnt = 0 THEN
         LET g_errno='aec-049'
      END IF
    END IF
END FUNCTION

FUNCTION t700_ecm03()
     IF NOT cl_null(g_shb.shb012) AND NOT cl_null(g_shb.shb05) AND NOT cl_null(g_shb.shb081) THEN #FUN-B20079 jan
        SELECT MIN(ecm03) INTO g_shb.shb06 FROM ecm_file
         WHERE ecm01=g_shb.shb05
           AND ecm012=g_shb.shb012
           AND ecm04=g_shb.shb081  #FUN-B20079 
         ORDER BY ecm03
         DISPLAY BY NAME g_shb.shb06
     END IF
    
END FUNCTION
#FUN-B20079--add--end 
FUNCTION t700_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t700_cs()
    IF INT_FLAG THEN 
       LET INT_FLAG = 0 
       INITIALIZE g_shb.* TO NULL 
       RETURN 
    END IF
    MESSAGE " SEARCHING ! "
    OPEN t700_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_shb.* TO NULL
    ELSE
        OPEN t700_count
        FETCH t700_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t700_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION t700_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式  #No.FUN-680121 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數  #No.FUN-680121 INTEGER
 
    CASE p_flag
         WHEN 'N' FETCH NEXT     t700_cs INTO g_shb.shb01
         WHEN 'P' FETCH PREVIOUS t700_cs INTO g_shb.shb01
         WHEN 'F' FETCH FIRST    t700_cs INTO g_shb.shb01
         WHEN 'L' FETCH LAST     t700_cs INTO g_shb.shb01
         WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
                  PROMPT g_msg CLIPPED || ': ' FOR g_jump   --改g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump t700_cs INTO g_shb.shb01 --改g_jump
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        INITIALIZE g_shb.* TO NULL
        CALL cl_err(g_shb.shb01,SQLCA.sqlcode,0)
        INITIALIZE g_shb.* TO NULL              #No.FUN-6A0164 
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
 
    SELECT * INTO g_shb.* FROM shb_file WHERE shb01 = g_shb.shb01
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_shb.shb01,SQLCA.sqlcode,0)
       INITIALIZE g_shb.* TO NULL
    ELSE
       LET g_data_owner = g_shb.shbuser      #FUN-4C0035
       LET g_data_group = g_shb.shbgrup      #FUN-4C0035
       LET g_data_plant = g_shb.shbplant #FUN-980030
       CALL t700_show()
    END IF
 
END FUNCTION
 
FUNCTION t700_show()
   DEFINE l_sfb919 LIKE sfb_file.sfb919   #FUN-A80102
   DEFINE l_pmc03  LIKE pmc_file.pmc03    #FUN-A80102
   
   SELECT * INTO g_shb.* FROM shb_file WHERE shb01 = g_shb.shb01   #FUN-A70095
   LET g_shb_t.* = g_shb.*                #保存單頭舊值
   DISPLAY BY NAME g_shb.shboriu,g_shb.shborig,
       g_shb.shb01, g_shb.shb02,g_shb.shb021,g_shb.shb03,g_shb.shb031,
       g_shb.shb032,g_shb.shb05,g_shb.shb07,g_shb.shb08,g_shb.shb081,
       g_shb.shb082,g_shb.shb06,g_shb.shb13,
       g_shb.shb09, g_shb.shb10,g_shb.shb111,g_shb.shb112,g_shb.shb113,
       g_shb.shb114,g_shb.shb12,g_shb.shb04,g_shb.shb081,g_shb.shb115,
       g_shb.shb14,g_shb.shb15,g_shb.shb17,g_shb.shb033,        #FUN-910076
       g_shb.shb31,g_shb.shb26,g_shb.shb30,g_shb.shb27,g_shb.shb28,g_shb.shb29,  #FUN-A80102
       g_shb.shbuser,g_shb.shbgrup,g_shb.shbmodu,g_shb.shbdate,
       g_shb.shb21,g_shb.shb22,g_shb.shb012,g_shb.shb121,       #FUN-930105  add #FUN-A50066
       g_shb.shbud01,g_shb.shbud02,g_shb.shbud03,g_shb.shbud04,
       g_shb.shbud05,g_shb.shbud06,g_shb.shbud07,g_shb.shbud08,
       g_shb.shbud09,g_shb.shbud10,g_shb.shbud11,g_shb.shbud12,
       g_shb.shbud13,g_shb.shbud14,g_shb.shbud15 
      ,g_shb.shbconf,g_shb.shb32     #FUN-A70095
   #FUN-A80102(S)
   IF g_sma.sma1421='Y' AND g_shb.shb05 IS NOT NULL THEN
      LET l_sfb919 = ''
      SELECT sfb919 INTO l_sfb919 FROM sfb_file WHERE sfb01=g_shb.shb05
      DISPLAY l_sfb919 TO FORMONLY.sfb919       
   END IF
   SELECT pmc03 INTO l_pmc03 
     FROM pmc_file WHERE pmc01 = g_shb.shb27
   DISPLAY l_pmc03 TO FORMONLY.pmc03
   DISPLAY BY NAME g_shb.shb26,g_shb.shb27,g_shb.shb28,
                   g_shb.shb29,g_shb.shb30,g_shb.shb31
   #FUN-A80102(E)
   CALL t700_shb04('d')
   CALL t700_shb10('d')
   CALL t700_shb012('d')    #FUN-A50066
   CALL t700_accept_qty('s') RETURNING g_i #TQC-5C0060 
   CALL t700_b_fill(g_wc3)

#FUN-A70095 --------Begin-----------
   IF g_shb.shbconf = 'X' THEN
      LET g_void = 'Y'
   ELSE
      LET g_void = 'N'
   END IF
#FUN-A70095 --------End-------------

 
   CALL cl_set_field_pic(g_shb.shbconf,"","","",g_void,"")   #FUN-A70095
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#FUN-A80060--begin--add----------
FUNCTION t700_r()
DEFINE l_cnt   LIKE type_file.num5
DEFINE l_shb01 LIKE shb_file.shb01

    LET l_cnt=0  
   #MOD-AA0015---add---start---
    IF g_shb.shb03 <= g_sma.sma53 THEN
       CALL cl_err('','asf-142',0)
       RETURN
    END IF
   #MOD-AA0015---add---end---
    SELECT count(*) INTO l_cnt FROM shb_file
     WHERE shb23=g_shb.shb23 AND shb24=g_shb.shb24
       AND (shb23 IS NOT NULL AND shb23 <> ' ')
       AND (shb24 IS NOT NULL AND shb24 <> 0)
    IF l_cnt > 1 THEN
       IF NOT cl_confirm('asf-165') THEN 
          RETURN 
       ELSE
          LET g_success='Y'
          BEGIN WORK
          DECLARE shb_curs CURSOR FOR
             SELECT shb01 FROM shb_file
              WHERE shb23=g_shb.shb23 AND shb24=g_shb.shb24
          FOREACH shb_curs INTO l_shb01
            CALL t700_r1(l_shb01,TRUE,'N')
            IF g_success='N' THEN EXIT FOREACH END IF
          END FOREACH
          #No.MOD-B80026  --Begin
          #IF g_success='N' THEN ROLLBACK WORK ELSE COMMIT WORK END IF
          IF g_success='N' THEN
             ROLLBACK WORK
             RETURN
          END IF
          #No.MOD-B80026  --End
       END IF
    ELSE
       LET g_success='Y'                     #TQC-B40207
       CALL t700_r1(g_shb.shb01,FALSE,'Y')
    END IF
    
    IF g_success='Y'  THEN
       CLEAR FORM
       CALL g_shc.clear()
       INITIALIZE g_shb.* TO NULL
       OPEN t700_count
       IF STATUS THEN #hrh
          CLOSE t700_count
          ROLLBACK WORK   #No.MOD-B80026
          RETURN
       END IF
       FETCH t700_count INTO g_row_count
       #No.MOD-B80026  --Begin
       #IF STATUS OR g_row_count=0 OR cl_null(g_row_count) THEN #hrh
       #   CLOSE t700_count
       #   RETURN
       #END IF
       IF STATUS THEN
          CLOSE t700_count
          ROLLBACK WORK
          RETURN
       END IF
       #No.MOD-B80026  --End
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t700_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t700_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL t700_fetch('/')
       END IF
       MESSAGE "Delete OK !"
       COMMIT WORK    #No.MOD-B80026
    #No.MOD-B80026  --Begin
    ELSE
       ROLLBACK WORK
    #No.MOD-B80026  --End
    END IF
 
END FUNCTION
#FUN-A80060--end--add-------------

#FUN-A80060-begin--modify--修改_r()函數的寫法
FUNCTION t700_r1(p_shb01,p_inTransaction,p_ask_post) 
  DEFINE l_chr,l_sure LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(1),
         l_ecm03      LIKE ecm_file.ecm03,
         l_sum1       LIKE ecm_file.ecm311,
         l_sum2       LIKE sfb_file.sfb09,
         l_cnt        LIKE type_file.num5,      #No.MOD-830105 add
         l_shc        RECORD LIKE shc_file.*
   DEFINE l_ima55     LIKE ima_file.ima55
   DEFINE l_ecm58     LIKE ecm_file.ecm58
   DEFINE l_i         LIKE type_file.num5
   DEFINE l_factor    LIKE ima_file.ima55_fac
 
  DEFINE l_shb111     LIKE shb_file.shb111    #MOD-990238 
  DEFINE l_qcf091     LIKE qcf_file.qcf091    #MOD-990238 
  DEFINE l_diff       LIKE qcf_file.qcf091    #MOD-990238  
  DEFINE l_ecm62      LIKE ecm_file.ecm62     #FUN-A50066
  DEFINE l_ecm63      LIKE ecm_file.ecm63     #FUN-A50066
  DEFINE p_inTransaction LIKE type_file.num5                                                                                      
  DEFINE p_ask_post      LIKE type_file.chr1
  DEFINE p_shb01         LIKE shb_file.shb01
  DEFINE l_shb           RECORD LIKE shb_file.*
  DEFINE l_qcm091        LIKE qcm_file.qcm091    #TQC-AB0331
  DEFINE l_shb012     LIKE shb_file.shb012       #TQC-AB0331
  DEFINE l_shb06      LIKE shb_file.shb06        #TQC-AB0331
  DEFINE l_outqty     LIKE shb_file.shb111       #TQC-AB0331
  
    IF s_shut(0) THEN LET g_success='N' RETURN END IF
    IF p_shb01 IS NULL THEN CALL cl_err('',-400,0) LET g_success='N' RETURN END IF
    SELECT * INTO l_shb.* FROM shb_file WHERE shb01=p_shb01
    
#FUN-A70095 ------------Begin----------------
#   LET l_cnt=0 
#   SELECT COUNT(*) INTO l_cnt FROM shd_file
#    WHERE shd01=l_shb.shb01
#   IF l_cnt>0 THEN
#      CALL cl_err('','asf-725',0)
#      LET g_success='N'
#      RETURN
#   END IF
#   LET l_cnt = 0 
    IF l_shb.shbconf = 'Y' THEN
       CALL cl_err(l_shb.shb01,'asf-215',0)
       RETURN
    END IF
    IF l_shb.shbconf = 'X' THEN
       CALL cl_err(l_shb.shb01,'asf-149',0)
       RETURN
    END IF
    CALL t700_shd_shj_chk(p_shb01)
    IF g_success = 'N' THEN
       RETURN 
    END IF
#FUN-A70095 ------------End------------------
   #CHI-B70003 --- modify --- start ---
    LET l_cnt = 0
    SELECT COUNT(*) INTO l_cnt
      FROM sfb_file,shb_file
     WHERE sfb01 = shb05 AND sfb28 = '3'
       AND shb01 = p_shb01 
    IF l_cnt > 0 THEN
       CALL cl_err('','asf1020',0)
       RETURN
    END IF
   #CHI-B70003 --- modify ---  end  ---
#TQC-AB0331 -----------mod start------------------
#   SELECT COUNT(*) INTO l_cnt FROM qcm_file
#    WHERE qcm02=l_shb.shb05  
#      AND qcm05>l_shb.shb06
#      AND qcm012=l_shb.shb012  #FUN-A50066
#      AND qcm14 <> 'X'
#   IF l_cnt>0 THEN
#      CALL cl_err('','asf-723',0)
#      LET g_success='N'
#      RETURN
#   END IF
#FUN-A70095 ----------------------------------Begin-----------------------------
#   IF g_shb.shb012 IS NULL THEN LET g_shb.shb012=' ' END IF
#   CALL s_schdat_next_ecm03(g_shb.shb05,g_shb.shb012,g_shb.shb06) #取得下一站的製程段製程序
#   RETURNING l_shb012,l_shb06
#   SELECT SUM(qcm091) INTO l_qcm091 FROM qcm_file
#    WHERE qcm02 = g_shb.shb05
#      AND qcm05 = l_shb06
#      AND qcm012 = l_shb012
#      AND qcm14 <> 'X'
#   IF cl_null(l_qcm091) THEN LET l_qcm091 = 0 END IF
#   SELECT (ecm311+ecm312+ecm313+ecm314+ecm316) INTO l_outqty FROM ecm_file
#    WHERE ecm01 = g_shb.shb05
#      AND ecm03 = g_shb.shb06
#      AND ecm012= g_shb.shb012
#   SELECT (shb111+shb112+shb113+shb114+shb17) INTO l_shb111 FROM shb_file
#    WHERE shb01=g_shb.shb01
#   IF (l_outqty-l_shb111) < l_qcm091 THEN
#      CALL cl_err('','asf-723',0)
#      RETURN
#   END IF
#FUN-A70095 ----------------------------------End---------------------------------
#TQC-AB0331 ----------mod end-----------------

#FUN-A70095 -------------Begin----------------
#   LET l_cnt=0 
#   SELECT COUNT(*) INTO l_cnt FROM shj_file 
#    WHERE shj01=l_shb.shb01
#   IF l_cnt>0 THEN
#      CALL cl_err('','asf-769',1)
#      LET g_success='N'
#      RETURN
#   END IF
#FUN-A70095 -------------End-----------------

   #FUN-A50066--begin--modify-----------
   #SELECT MAX(ecm03) INTO l_ecm03 FROM ecm_file
   # WHERE ecm01 = g_shb.shb05
   #IF l_ecm03 = g_shb.shb06 THEN   #最終站

#FUN-A70095 --------------------------Begin-----------------------------
#   IF NOT s_schdat_chk_ecm03(l_shb.shb05,l_shb.shb012,l_shb.shb06) THEN    #最終站
#  #FUN-A50066--end--add--------------------
#    #若是最終站時則判斷是否有對應的FQC單
#     LET l_cnt = 0
#     SELECT COUNT(*) INTO l_cnt FROM qcf_file 
#                       WHERE qcf02 = l_shb.shb05
#                         AND (qcf09 = '1' OR qcf09 = '3')
#                         AND qcfacti = 'Y'
#                         AND qcf14 !='X' #MOD-960352     
#     IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
#     SELECT SUM(qcf091) INTO l_qcf091 FROM qcf_file
#      WHERE qcf02 = l_shb.shb05
#        AND (qcf09 = '1' OR qcf09 = '3')
#        AND qcfacti = 'Y'
#        AND qcf14 !='X'     
#     SELECT SUM(shb111) INTO l_shb111 FROM shb_file
#      WHERE shb05 = l_shb.shb05  
#       #AND shb06 = l_ecm03      #FUN-A50066
#        AND shb06 = l_shb.shb06  #FUN-A50066
#        AND shb012= l_shb.shb012 #FUN-A50066
#     LET l_diff = l_shb111 - l_qcf091
#     IF l_cnt > 0 AND l_shb.shb111 > l_diff THEN
#        CALL cl_err('','asf-828',1)
#        LET g_success='N'
#        RETURN
#     END IF
#     #讀取最終站良品轉出量+Bonus Qty & 完工入庫量
#     SELECT (ecm311+ecm315),sfb09 INTO l_sum1,l_sum2
#       FROM ecm_file,sfb_file
#      WHERE ecm01 = l_shb.shb05
#        AND ecm03 = l_shb.shb06
#        AND ecm01 = sfb01
#        AND ecm012= l_shb.shb012  #FUN-A50066
#      IF cl_null(l_sum1) THEN LET l_sum1 = 0  END IF
#      IF cl_null(l_sum2) THEN LET l_sum2 = 0  END IF
#      #當站報工量+bonus Qty須<=終站總良品轉出量+Bonus Qty-已入庫量
#      IF (l_shb.shb111+l_shb.shb115) > (l_sum1 - l_sum2) THEN
#         CALL cl_err('','asf-681',0)
#         LET g_success='N'
#         RETURN
#      END IF
#   END IF
#FUN-A70095 --------------------------End---------------------------
  # LET g_argv3=l_shb.shb14    #TQC-AB0331 mark
  # LET g_argv4=l_shb.shb15    #TQC-AB0331 mark
    LET g_argv5='r'
    
    IF p_ask_post='Y' THEN    
       IF NOT cl_delh(20,16) THEN LET g_success='N' RETURN END IF
    END IF
    INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
    LET g_doc.column1 = "shb01"         #No.FUN-9B0098 10/02/24
    LET g_doc.value1 = l_shb.shb01      #No.FUN-9B0098 10/02/24
    CALL cl_del_doc()                                                              #No.FUN-9B0098 10/02/24
    IF NOT p_inTransaction THEN
       BEGIN WORK
    END IF
    
    OPEN t700_cl USING l_shb.shb01
    IF STATUS THEN
       CALL cl_err("OPEN t700_cl:", STATUS, 1)
       CLOSE t700_cl
       LET g_success='N'
       IF NOT p_inTransaction THEN ROLLBACK WORK END IF
       RETURN
    END IF
 
    FETCH t700_cl INTO l_shb.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(l_shb.shb01,SQLCA.sqlcode,0)
       CLOSE t700_cl
       LET g_success='N'
       IF NOT p_inTransaction THEN ROLLBACK WORK END IF
       RETURN
    END IF
 
   #CALL t700_show()  #FUN-A80060
 
    IF g_argv5 != 'r' THEN   #TQC-630068
      #IF p_ask_post='Y' THEN                           #TQC-C20245--mark
      #    IF NOT cl_delh(20,16) THEN RETURN  END IF    #TQC-C20245--mark
      #END IF                                           #TQC-C20245--mark  
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "shb01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = l_shb.shb01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                                                  #No.FUN-9B0098 10/02/24
    ELSE
#......委外入庫重新確認且報工資料己存在
      #IF g_shbconf = 'Y' THEN         #MOD-B90209 mark
         #IF NOT cl_delh(20,16) THEN   #TQC-C20245--mark              
            #LET g_shbconf='N'         #MOD-B90209 mark
         #   RETURN                    #TQC-C20245--mark
         #END IF                       #TQC-C20245--mark
          INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
          LET g_doc.column1 = "shb01"         #No.FUN-9B0098 10/02/24
          LET g_doc.value1 = l_shb.shb01      #No.FUN-9B0098 10/02/24
          CALL cl_del_doc()                                  #No.FUN-9B0098 10/02/24
      #END IF                          #MOD-B90209 mark
    END IF
 
 
#FUN-A70095 -----------------Begin---------------------------
#    MESSAGE "update sfb_file"
#    SELECT ima55 INTO l_ima55 FROM ima_file 
#     WHERE ima01= l_shb.shb10
#
#    SELECT ecm58 INTO l_ecm58 FROM ecm_file
#     WHERE ecm01=l_shb.shb05
#       AND ecm03=l_shb.shb06
#
#    CALL s_umfchk(l_shb.shb10,l_ecm58,l_ima55)                                                   
#             RETURNING l_i,l_factor
#
#    IF l_i = '1' THEN                                                                                             
#       LET l_factor = 1
#    END IF
#    UPDATE sfb_file SET sfb12 = sfb12 - (l_shb.shb112 * l_factor) 
#     WHERE sfb01 = l_shb.shb05 
#    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
#       CALL cl_err(l_shb.shb05,'asf-861',1)
#       LET g_success='N'
#       IF NOT p_inTransaction THEN ROLLBACK WORK END IF
#       RETURN
#    END IF
#FUN-A70095 -----------------End------------------------------

    DELETE FROM shb_file WHERE shb01 = l_shb.shb01
    IF STATUS THEN
       CALL cl_err('del shb',STATUS,0) 
       LET g_success='N'
       IF NOT p_inTransaction THEN ROLLBACK WORK END IF
       RETURN
    END IF
    IF SQLCA.SQLERRD[3]=0 THEN
       CALL cl_err('No shb deleted',SQLCA.SQLCODE,0) 
       LET g_success='N'
       IF NOT p_inTransaction THEN ROLLBACK WORK END IF
       RETURN
    END IF
 
    DELETE FROM shc_file WHERE shc01 = l_shb.shb01
    IF STATUS THEN
       CALL cl_err('del shc',STATUS,0) 
       LET g_success='N'
       IF NOT p_inTransaction THEN ROLLBACK WORK END IF
       RETURN
    END IF

 
   #CALL t700sub_upd_ecm('r',l_shb.*)    # Update 製程追蹤檔  #FUN-A80102  #FUN-A70095
   #   RETURNING l_shb.*  #FUN-A80102    #FUN-A70095
    IF g_success='N'  THEN
       IF NOT p_inTransaction THEN ROLLBACK WORK END IF  
    ELSE
       IF NOT p_inTransaction THEN COMMIT WORK END IF 
       CALL cl_flow_notify(l_shb.shb01,'D')
    END IF
 
    CLOSE t700_cl
 
END FUNCTION
#FUN-A80060--end--modify--------
 
FUNCTION t700_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680121 SMALLINT
    l_n,l_cnt       LIKE type_file.num5,                #檢查重複用  #No.FUN-680121 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否  #No.FUN-680121 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態  #No.FUN-680121 VARCHAR(1)
    l_b3            LIKE type_file.num5,                #No.FUN-680121 SMALLINT,
    no1             LIKE type_file.num10,               #No.FUN-680121 INTEGER,
    l_allow_insert  LIKE type_file.num5,                #可新增否  #No.FUN-680121 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否  #No.FUN-680121 SMALLINT
DEFINE l_sfb93      LIKE sfb_file.sfb93                 #FUN-A60095
 
    LET g_action_choice = ""
    IF g_shb.shb01 IS NULL THEN RETURN END IF
    SELECT * INTO g_shb.* FROM shb_file WHERE shb01=g_shb.shb01

#FUN-A70095 ------------Begin----------------
    IF g_shb.shbconf = 'Y' THEN
       CALL cl_err(g_shb.shb01,'asf-228',0)
       RETURN
    END IF
    IF g_shb.shbconf = 'X' THEN
       CALL cl_err(g_shb.shb01,'asf-229',0)
       RETURN
    END IF
#FUN-A70095 ------------End------------------
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT * FROM shc_file",
                       " WHERE shc01 = ? AND shc03 = ?  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t700_bcl CURSOR FROM g_forupd_sql       # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    IF g_rec_b=0 THEN CALL g_shc.clear() END IF
 
    INPUT ARRAY g_shc WITHOUT DEFAULTS FROM s_shc.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b!=0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK
 
            OPEN t700_cl USING g_shb.shb01
            IF STATUS THEN
               CALL cl_err("OPEN t700_cl:", STATUS, 1)
               CLOSE t700_cl
               ROLLBACK WORK
               RETURN
            ELSE
               FETCH t700_cl INTO g_shb.*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_shb.shb01,SQLCA.sqlcode,0)
                  CLOSE t700_cl
                  ROLLBACK WORK
                  RETURN
               END IF
            END IF
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_shc_t.* = g_shc[l_ac].*  #BACKUP
 
                OPEN t700_bcl USING g_shb.shb01,g_shc_t.shc03
 
                IF STATUS THEN
                   CALL cl_err("OPEN t700_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH t700_bcl INTO b_shc.*
                   IF SQLCA.sqlcode THEN
                      CALL cl_err('lock shc',SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   ELSE
                      CALL t700_b_move_to()
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            INITIALIZE g_shc_t.* TO NULL
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_shc[l_ac].* TO NULL      #900423
            LET b_shc.shc01=g_shb.shb01
            LET g_shc[l_ac].shc012=' ' #FUN-A60095
            LET g_shc[l_ac].shc05=0
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD shc03
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT #MOD-4A0307
            END IF
 
            CALL t700_b_move_back(p_cmd)
            CALL t700_b_else()
            LET b_shc.shcoriu = g_user      #No.FUN-980030 10/01/04
            LET b_shc.shcorig = g_grup      #No.FUN-980030 10/01/04
            IF b_shc.shc012 IS NULL THEN LET b_shc.shc012 = ' ' END IF  #FUN-A60095
            INSERT INTO shc_file VALUES(b_shc.*)
            IF SQLCA.sqlcode THEN
               CALL cl_err('ins shc',SQLCA.sqlcode,0)
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
            END IF
 
        BEFORE FIELD shc03                            #default 序號
            IF cl_null(g_shc[l_ac].shc03) THEN
               SELECT MAX(shc03)+1 INTO g_shc[l_ac].shc03
                  FROM shc_file WHERE shc01 = g_shb.shb01
               IF g_shc[l_ac].shc03 IS NULL THEN
                  LET g_shc[l_ac].shc03=1
               END IF
            END IF
 
        AFTER FIELD shc03                        #check 序號是否重複
            IF NOT cl_null(g_shc[l_ac].shc03) THEN
               IF g_shc[l_ac].shc03 != g_shc_t.shc03 OR
                  g_shc_t.shc03 IS NULL THEN
                   SELECT count(*) INTO l_n FROM shc_file
                    WHERE shc01 = g_shb.shb01 AND shc03 = g_shc[l_ac].shc03
                   IF l_n > 0 THEN
                      LET g_shc[l_ac].shc03 = g_shc_t.shc03
                      CALL cl_err('',-239,0) NEXT FIELD shc03
                   END IF
               END IF
            END IF
 
        AFTER FIELD shc04
            IF NOT cl_null(g_shc[l_ac].shc04) THEN
               CALL t700_shc04('d')
               IF NOT cl_null(g_errno)   THEN
                  CALL cl_err('sel qce:',g_errno,0) NEXT FIELD shc04
                  LET g_shc[l_ac].shc04=g_shc_t.shc04
                  DISPLAY BY NAME g_shc[l_ac].shc04
                  NEXT FIELD shc04
               END IF
            END IF
 
        AFTER FIELD shc05
            IF Not cl_null(g_shc[l_ac].shc05) THEN #No.FUN-810017 add Not
               IF g_shc[l_ac].shc05 <=0  THEN
                  NEXT FIELD shc05
               END IF
            END IF

#FUN-A60095--begin--add----------------- 
        AFTER FIELD shc012
           IF NOT cl_null(g_shc[l_ac].shc012) THEN
              LET l_cnt = 0 
              SELECT COUNT(*) INTO l_cnt FROM ecm_file
               WHERE ecm01=g_shb.shb05
                 AND ecm012=g_shc[l_ac].shc012
              IF l_cnt = 0  THEN
                 CALL cl_err(g_shc[l_ac].shc012,'abm-214',1)
                 NEXT FIELD shc012
              END IF
              CALL t700_shc06()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 NEXT FIELD shc012
              END IF
           END IF
#FUN-A60095--end--add---------------------

        AFTER FIELD shc06  
            IF NOT cl_null(g_shc[l_ac].shc06) THEN
#FUN-A60095--begin--modify---------------
#              SELECT ecm04 INTO g_shc[l_ac].ecm04 FROM ecm_file
#               WHERE ecm01=g_shb.shb05 AND ecm03 = g_shc[l_ac].shc06
#                 AND ecm012=g_shb.shb012  #FUN-A50066
#              IF STATUS THEN
#                 CALL cl_err('sel ecm',STATUS,0)
#                 LET g_shc[l_ac].shc06=g_shc_t.shc06
#                 NEXT FIELD shc06
#              END IF
               CALL t700_shc06()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD shc06
               END IF
#FUN-A60095--end--modify--------------------
               DISPLAY BY NAME g_shc[l_ac].ecm04
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_shc_t.shc03 > 0 AND g_shc_t.shc03 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM shc_file
                 WHERE shc01 = g_shb.shb01 AND shc03 = g_shc_t.shc03
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_shc_t.shc03,SQLCA.sqlcode,0)
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
		COMMIT WORK
                LET g_rec_b=g_rec_b-1
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_shc[l_ac].* = g_shc_t.*
               CLOSE t700_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_shc[l_ac].shc03,-263,1)
               LET g_shc[l_ac].* = g_shc_t.*
            ELSE
               CALL t700_b_move_back(p_cmd)
               CALL t700_b_else()
               UPDATE shc_file SET * = b_shc.*
                  WHERE shc01=g_shb.shb01 AND shc03=g_shc_t.shc03
               IF SQLCA.sqlcode THEN
                  CALL cl_err('upd shc',SQLCA.sqlcode,0)
                  LET g_shc[l_ac].* = g_shc_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac      #FUN-D40030 Mark    
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_shc[l_ac].* = g_shc_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_shc.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE t700_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac      #FUN-D40030 Add
            CLOSE t700_bcl
            COMMIT WORK
           #CALL g_shc.deleteElement(g_rec_b+1)    #FUN-D40030 Mark  
      ON ACTION controls                                                                                    
       CALL cl_set_head_visible("","AUTO")                                                          
 
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(shc03) AND l_ac > 1 THEN
                LET g_shc[l_ac].shc03=g_shc[l_ac-1].shc03
                LET g_shc[l_ac].shc04=g_shc[l_ac-1].shc04
                LET g_shc[l_ac].qce03=g_shc[l_ac-1].qce03
                LET g_shc[l_ac].shc05=g_shc[l_ac-1].shc05
                LET g_shc[l_ac].shc06=g_shc[l_ac-1].shc06
                LET g_shc[l_ac].shc012=g_shc[l_ac-1].shc012  #FUN-A60095
                NEXT FIELD shc03
            END IF
 
        ON ACTION controlp
           CASE WHEN INFIELD(shc04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form     = "q_qce"
                   LET g_qryparam.default1 = g_shc[l_ac].shc04
                   CALL cl_create_qry() RETURNING g_shc[l_ac].shc04
                    DISPLAY BY NAME g_shc[l_ac].shc04       #No.MOD-490371
                   NEXT FIELD shc04
           #FUN-A60095--begin--add-----------------
                WHEN INFIELD(shc012)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form     = "q_shb012"
                   LET g_qryparam.default1 = g_shc[l_ac].shc012
                   LET g_qryparam.default2 = g_shc[l_ac].shc06
                   LET g_qryparam.default3 = g_shc[l_ac].ecm04
                   LET g_qryparam.arg1 = g_shb.shb05
                   CALL cl_create_qry() RETURNING g_shc[l_ac].shc012,g_shc[l_ac].shc06,g_shc[l_ac].ecm04
                   IF cl_null(g_shc[l_ac].shc012) THEN LET g_shc[l_ac].shc012 = ' ' END IF     #FUN-B10056 
                   DISPLAY BY NAME g_shc[l_ac].shc012,g_shc[l_ac].shc06,g_shc[l_ac].ecm04
                   NEXT FIELD shc012
           #FUN-A60095--end--add-------------------
                WHEN INFIELD(shc06)
                  SELECT sfb93 INTO l_sfb93 FROM sfb_file WHERE sfb01=g_shb.shb05
                  IF g_sma.sma541='Y' AND l_sfb93='Y' THEN
                     CALL cl_init_qry_var()
                     LET g_qryparam.form     = "q_shb012"
                     LET g_qryparam.default1 = g_shc[l_ac].shc012
                     LET g_qryparam.default2 = g_shc[l_ac].shc06
                     LET g_qryparam.default3 = g_shc[l_ac].ecm04
                     LET g_qryparam.arg1 = g_shb.shb05
                     CALL cl_create_qry() RETURNING g_shc[l_ac].shc012,g_shc[l_ac].shc06,g_shc[l_ac].ecm04
                     DISPLAY BY NAME g_shc[l_ac].shc012,g_shc[l_ac].shc06,g_shc[l_ac].ecm04
                     NEXT FIELD shc06
                  ELSE
                  #FUN-A60095--end--add-------------------
		    #CALL q_ecm(FALSE,FALSE,g_shb.shb05,'')   #FUN-C30163 mark
                     CALL q_ecm(FALSE,FALSE,g_shb.shb05,'','','','','')   #FUN-C30163 add
			  RETURNING g_shc[l_ac].ecm04,g_shc[l_ac].shc06
                     DISPLAY BY NAME g_shc[l_ac].ecm04,g_shc[l_ac].shc06
                     NEXT FIELD shc06
                  END IF
           END CASE
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
    END INPUT
 
     LET g_shb.shbmodu = g_user
     LET g_shb.shbdate = g_today
     UPDATE shb_file SET shbmodu = g_shb.shbmodu,shbdate = g_shb.shbdate
      WHERE shb01 = g_shb.shb01
     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
        CALL cl_err('upd shb',SQLCA.SQLCODE,1)
     END IF
     DISPLAY BY NAME g_shb.shbmodu,g_shb.shbdate
 
    SELECT COUNT(*) INTO g_cnt FROM shc_file WHERE shc01=g_shb.shb01
 
    CLOSE t700_bcl
    COMMIT WORK
    IF NOT t700_chk_shb112() THEN
       CALL cl_err('','asf-710',1)
    END IF
END FUNCTION
 
FUNCTION t700_b_move_to()
   LET g_shc[l_ac].shc03 = b_shc.shc03
   LET g_shc[l_ac].shc04 = b_shc.shc04
   LET g_shc[l_ac].shc05 = b_shc.shc05
   LET g_shc[l_ac].shc06 = b_shc.shc06
   LET g_shc[l_ac].shc012 = b_shc.shc012  #FUN-A60095
   CALL t700_shc04('d')
 
END FUNCTION
 
FUNCTION t700_b_move_back(p_cmd)
   DEFINE    p_cmd     LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
 
   LET b_shc.shc01 = g_shb.shb01
   LET b_shc.shc03 = g_shc[l_ac].shc03
   LET b_shc.shc04 = g_shc[l_ac].shc04
   LET b_shc.shc05 = g_shc[l_ac].shc05
   LET b_shc.shc06 = g_shc[l_ac].shc06
   LET b_shc.shc012 = g_shc[l_ac].shc012   #FUN-A60095
   LET b_shc.shc07=' '
   IF p_cmd = 'a'   THEN
      LET b_shc.shcacti='Y'
      LET b_shc.shcuser=g_user
      LET b_shc.shcgrup=g_grup
      LET b_shc.shcmodu=' '
      LET b_shc.shcdate=g_today
   ELSE
      LET b_shc.shcmodu=g_user
      LET b_shc.shcdate=g_today
   END IF
 
   LET b_shc.shcplant = g_plant #FUN-980008 add
   LET b_shc.shclegal = g_legal #FUN-980008 add
 
END FUNCTION
 
FUNCTION t700_b_else()
   IF g_shc[l_ac].shc03 IS NULL THEN LET g_shc[l_ac].shc03 =0   END IF
   IF g_shc[l_ac].shc04 IS NULL THEN LET g_shc[l_ac].shc04 =' ' END IF
END FUNCTION
 
FUNCTION t700_b_askkey()
DEFINE l_wc2           LIKE type_file.chr1000 #No.FUN-680121 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON shc03,shc04,shc05,shc012,shc06
            FROM s_shc[1].shc03, s_shc[1].shc04, s_shc[1].shc05,  #FUN-A60095
                 s_shc[1].shc012,s_shc[1].shc06    #FUN-A60095
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL t700_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t700_b_fill(p_wc2)              #BODY FILL UP
    DEFINE p_wc2           LIKE type_file.chr1000 #No.FUN-680121 VARCHAR(300)
 
       LET g_sql = "SELECT shc03,shc04,qce03,shc05,shc012,shc06,ecm04 ", #FUN-A60095
                   " FROM  shc_file, OUTER qce_file,OUTER ecm_file ",
                   " WHERE shc01 ='",g_shb.shb01,"' ",
                        "   AND shc_file.shc04= qce_file.qce01 ",
                   "   AND ecm_file.ecm01='",g_shb.shb05,"' ",
                   "   AND ecm_file.ecm03=shc_file.shc06",
                   "   AND ecm_file.ecm012=shc_file.shc012",  #FUN-A50066
                   "   AND ",p_wc2 CLIPPED,
                   " ORDER BY shc03"
 
    PREPARE t700_pb FROM g_sql
    DECLARE shc_curs CURSOR FOR t700_pb
 
    CALL g_shc.clear()
 
    LET g_cnt = 1
 
    FOREACH shc_curs INTO g_shc[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_shc.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
 
END FUNCTION
 
FUNCTION t700_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_shc TO s_shc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         CALL cl_show_fld_cont()         #TQC-B30192
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

      #FUN-CB0014---add---str---
      ON ACTION page_list
         LET g_action_flag = "page_list"  
         EXIT DISPLAY
      #FUN-CB0014---add---end--- 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION controls                                                                                    
       CALL cl_set_head_visible("","AUTO")                                                          
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
#FUN-A70095 ----------Begin------------
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
#FUN-A70095 ----------End--------------
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION first
         CALL t700_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL t700_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL t700_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL t700_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL t700_fetch('L')
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
         CALL t700_def_form()   #TQC-890064 add
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
#FUN-A70095 ----------------Begin--------------------
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY  
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #CHI-D20010---begin
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #CHI-D20010---end
#FUN-A70095 ----------------End----------------------
#@    ON ACTION 委外報工輸入
      ON ACTION input_sub_report
         LET g_action_choice="input_sub_report"
         EXIT DISPLAY
#@    ON ACTION 當站入庫
      ON ACTION direct_st_in
         LET g_action_choice="direct_st_in"
         EXIT DISPLAY
#@    ON ACTION 轉稼工時維護
      ON ACTION shift_working_hours
         LET g_action_choice="shift_working_hours"
         EXIT DISPLAY
#@    ON ACTION 工單製程數量狀態查詢
      ON ACTION wo_routing_qt_status
         LET g_action_choice="wo_routing_qt_status"
         EXIT DISPLAY
#@    ON ACTION 工單轉出維護
      ON ACTION wo_tr_o
         LET g_action_choice="wo_tr_o"
         EXIT DISPLAY
#@    ON ACTION 工單轉出查詢
      ON ACTION wo_tr_o_qry
         LET g_action_choice="wo_tr_o_qry"
         EXIT DISPLAY
 
      ON ACTION fast_input
         LET g_action_choice = "fast_input"
         EXIT DISPLAY 
 
      ON ACTION fqc2
         LET g_action_choice = "fqc2"
         EXIT DISPLAY 
         
      ON ACTION trans_fqc
         LET g_action_choice = "trans_fqc"   
         EXIT DISPLAY 
         
      ON ACTION trans_store
         LET g_action_choice = "trans_store"
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
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      ON ACTION related_document                #No.FUN-6A0164  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY

      #DEV-D30045--add--begin
      ON ACTION barcode_gen
         LET g_action_choice="barcode_gen"
         EXIT DISPLAY

      ON ACTION barcode_query
         LET g_action_choice="barcode_query"
         EXIT DISPLAY

      ON ACTION barcode_output
         LET g_action_choice="barcode_output"
         EXIT DISPLAY
      #DEV-D30045--add--end
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)    
END FUNCTION

#FUN-A70095 ------------------Begin--------------------

#FUNCTION t700_x()       #CHI-D20010
FUNCTION t700_x(p_type)  #CHI-D20010
   DEFINE l_sfb04   LIKE sfb_file.sfb04
   DEFINE l_flag    LIKE type_file.chr1  #CHI-D20010
   DEFINE p_type    LIKE type_file.chr1  #CHI-D20010

   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_shb.* FROM shb_file WHERE shb01=g_shb.shb01
   IF cl_null(g_shb.shb01) THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT sfb04 INTO l_sfb04 FROM sfb_file WHERE sfb01 = g_shb.shb05
   IF l_sfb04 = '8' THEN
      CALL cl_err(l_sfb04,'aec-078',0)  #已結案 !!
      RETURN
   END IF
#-->已確認不可作廢 
   IF g_shb.shbconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   #CHI-D20010---begin
   IF p_type = 1 THEN
      IF g_shb.shbconf ='X' THEN RETURN END IF
   ELSE
      IF g_shb.shbconf <>'X' THEN RETURN END IF
   END IF
   #CHI-D20010---end

#-->已有當站下線和工單轉入資料不可以作廢
   LET g_success = 'Y' 
   CALL t700_shd_shj_chk(g_shb.shb01)
   IF g_success = 'N' THEN
      RETURN
   END IF
   IF NOT t700_chk_sma() THEN RETURN END IF
   BEGIN WORK
   LET g_success='Y'

   OPEN t700_cl USING g_shb.shb01
   IF STATUS THEN
      CALL cl_err("OPEN t700_cl:", STATUS, 1)
      CLOSE t700_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t700_cl INTO g_shb.* #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_shb.shb01,SQLCA.sqlcode,0) #資料被他人LOCK
      CLOSE t700_cl
      ROLLBACK WORK
      RETURN
   END IF
   IF g_shb.shbconf = 'X' THEN  LET l_flag = 'X' ELSE LET l_flag = 'N' END IF #CHI-D20010
  #IF cl_void(0,0,g_shb.shbconf) THEN #CHI-D20010
   IF cl_void(0,0,l_flag) THEN #CHI-D20010
      LET g_chr = g_shb.shbconf
      LET g_chr1 = g_shb.shbacti
     #IF g_shb.shbconf = 'N' THEN  #CHI-D20010
      IF p_type = 1 THEN           #CHI-D20010
         LET g_shb.shbconf = 'X'
         LET g_shb.shbacti = 'N'
      ELSE
         LET g_shb.shbconf = 'N'
         LET g_shb.shbacti = 'Y'
      END IF
      UPDATE shb_file
          SET shbconf = g_shb.shbconf,
              shbacti = g_shb.shbacti,
              shbmodu = g_user,
              shbdate = g_today
          WHERE shb01 = g_shb.shb01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err3("upd","shb_file",g_shb.shb01,"",SQLCA.sqlcode,"","",0)
          LET g_shb.shbconf = g_chr
          LET g_shb.shbacti = g_chr1
      END IF
      DISPLAY BY NAME g_shb.shbconf
   END IF
   CLOSE t700_cl
   COMMIT WORK
   CALL cl_flow_notify(g_shb.shb01,'V')
END FUNCTION
FUNCTION t700_chk_sma()
    IF g_sma.sma53 IS NOT NULL AND g_shb.shb03 <= g_sma.sma53 THEN
        CALL cl_err('','mfg9999',0)
        RETURN FALSE
    END IF
    CALL s_yp(g_shb.shb03) RETURNING g_yy,g_mm
    IF g_yy > g_sma.sma51 THEN # 與目前會計年度,期間比較
        CALL cl_err(g_yy,'mfg6090',0)
        RETURN FALSE
    ELSE
        IF g_yy=g_sma.sma51 AND g_mm > g_sma.sma52 THEN
            CALL cl_err(g_mm,'mfg6091',0)
            RETURN FALSE
        END IF
    END IF
    RETURN TRUE
END FUNCTION

#FUN-A70095 ------------------End----------------------
 
FUNCTION t700_shb04(p_cmd)  #員工編號
    DEFINE l_gen02    LIKE gen_file.gen02,
           l_genacti  LIKE gen_file.genacti,
           p_cmd      LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT gen02,genacti INTO l_gen02,l_genacti
      FROM gen_file WHERE gen01 = g_shb.shb04
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-038'
                            LET l_gen02 = NULL
         WHEN l_genacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF cl_null(g_errno) OR p_cmd = 'd'  THEN
       DISPLAY l_gen02  TO FORMONLY.gen02
       LET g_gen02 = l_gen02               #NO.FUN-940113
    END IF
END FUNCTION
 
FUNCTION t700_shb10(p_cmd)  #產品編號
    DEFINE l_ima02    LIKE ima_file.ima02,
           l_ima021   LIKE ima_file.ima021,
           l_imaacti  LIKE ima_file.imaacti,
           p_cmd      LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT ima02,ima021,imaacti INTO l_ima02,l_ima021,l_imaacti
      FROM ima_file WHERE ima01 = g_shb.shb10
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3006'
                            LET l_ima02 = NULL
                            LET l_ima021 = NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
         WHEN l_imaacti MATCHES '[PH]'  LET g_errno = '9038'  #No.FUN-690022 add
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF cl_null(g_errno) OR p_cmd = 'd'
    THEN LET g_ima02  = l_ima02
         LET g_ima021 = l_ima021
         DISPLAY g_ima02  TO FORMONLY.ima02
         DISPLAY g_ima021 TO FORMONLY.ima021
         LET gg_ima02 = g_ima02         #NO.FUN-940113 
         LET gg_ima021 = g_ima021       #NO.FUN-940113
    END IF
END FUNCTION
 
FUNCTION t700_shc04(p_cmd)  #缺點碼
    DEFINE l_qce03    LIKE qce_file.qce03,
           l_qceacti  LIKE qce_file.qceacti,
           p_cmd      LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT qce03,qceacti INTO l_qce03,l_qceacti
      FROM qce_file WHERE qce01 = g_shc[l_ac].shc04
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aqc-023'
                            LET l_qce03 = NULL
         WHEN l_qceacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       LET g_shc[l_ac].qce03 = l_qce03
       DISPLAY BY NAME g_shc[l_ac].qce03
    END IF
END FUNCTION
 
## 檢查可報工數量
#FUN-A50066--begin--mark-------------------------------------------
#FUNCTION t700_accept_qty(p_cmd)
#DEFINE p_cmd      LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(1)
#       l_wip_qty  LIKE shb_file.shb111,
#       l_pqc_qty  LIKE qcm_file.qcm091,   #良品數
#       l_sum_qty  LIKE qcm_file.qcm091
 
##      WIP量=總投入量(a+b)-總轉出量(f+g)-報廢量(d)-入庫量(e)
##           -委外加工量(h)+委外完工量(i)
##      WIP量指目前在該站的在製量，
##      若系統參數定義要做Check-In時，WIP量尚可區
##      分為等待上線數量與上線處理數量。
##      上線處理數量=Check-In量(c)-總轉出量(f+g)-報廢量(d)-入庫量(e)
##                 -委外加工量(h)+委外完工量(i)
##      等待上線數量=線投入量(a+b)-Check-In量(c)
 
##      若該站允許做製程委外，則
##      可委外加工量=WIP量-委外加工量(h)
##      委外在外量=委外加工量(h)-委外完工量(i)
 
##      某站若要報工則其可報工數=WIP量(a+b-f-g-d-e-h+i)，
##      若要做Check-In則可報工數=c-f-g-d-e-h+i。
 
#       SELECT * INTO g_ecm.* FROM ecm_file
#        WHERE ecm01=g_shb.shb05 AND ecm03=g_shb.shb06
#          AND ecm012=g_shb.shb012 #FUN-A50066
#       IF STATUS THEN  #資料資料不存在
#          CALL cl_err('sel ecm_file',STATUS,0)
#          RETURN -1
#       END IF
# 
#       IF cl_null(g_shb.shb14) AND cl_null(g_shb.shb15) THEN
#          IF g_ecm.ecm54='Y' THEN   #check in 否
#             LET l_wip_qty =  g_ecm.ecm291                #check in
#                            - g_ecm.ecm311*g_ecm.ecm59    #良品轉出
#                            - g_ecm.ecm312*g_ecm.ecm59    #重工轉出
#                            - g_ecm.ecm313*g_ecm.ecm59    #當站報廢
#                            - g_ecm.ecm314*g_ecm.ecm59    #當站下線
#                            - g_ecm.ecm316*g_ecm.ecm59    #工單轉出
#                           - g_ecm.ecm321                #委外加工量
#                           + g_ecm.ecm322                #委外完工量
#          ELSE
#             LET l_wip_qty =  g_ecm.ecm301                #良品轉入量
#                            + g_ecm.ecm302                #重工轉入量
#                            + g_ecm.ecm303                #工單轉入
#                            - g_ecm.ecm311*g_ecm.ecm59    #良品轉出
#                            - g_ecm.ecm312*g_ecm.ecm59    #重工轉出
#                            - g_ecm.ecm313*g_ecm.ecm59    #當站報廢
#                            - g_ecm.ecm314*g_ecm.ecm59    #當站下線
#                            - g_ecm.ecm316*g_ecm.ecm59    #工單轉出
#                            - g_ecm.ecm321                #委外加工量
#                            + g_ecm.ecm322                #委外完工量
#          END IF
#       ELSE
#          LET l_wip_qty = g_ecm.ecm321 - g_ecm.ecm322   #bugno:5440
#       END IF
#       IF cl_null(l_wip_qty) THEN LET l_wip_qty=0 END IF
# 
#       LET l_sum_qty=(g_shb.shb111+g_shb.shb113+g_shb.shb112+g_shb.shb114+g_shb.shb17)*g_ecm.ecm59
# 
#       IF l_sum_qty>l_wip_qty AND p_cmd<>'d' AND p_cmd<>'s' THEN #TQC-5C0060
#          LET g_msg="WIP:",l_wip_qty USING "<<<<.<<" CLIPPED
#          CALL cl_err(g_msg,'asf-801',0)
#          DISPLAY l_wip_qty,l_pqc_qty,g_ecm.ecm53,g_ecm.ecm54
#               TO FORMONLY.wip,FORMONLY.pqc,ecm53,ecm54
#          LET g_wip = l_wip_qty         #NO.FUN-940113  
#          LET g_pqc = l_pqc_qty          #NO.FUN-940113   
#          LET g_ecm53 = g_ecm.ecm53       #NO.FUN-940113
#          LET g_ecm54 = g_ecm.ecm54         #NO.FUN-940113
#          RETURN -1
#       END IF
# 
##      若該站製程追蹤檔中定義本站需要做PQC檢查，
##      則可報工數量尚需滿足以下條件:
##          可報工數量<=SUM(PQC Accept數量)-當站下線量(e)-良品轉出量(f)
#       DISPLAY '' TO FORMONLY.tot_pqc
#       IF g_ecm.ecm53='Y' THEN   #PQC
#          SELECT SUM(qcm091) INTO l_pqc_qty FROM qcm_file
#           WHERE qcm02=g_shb.shb05   #工單編號
#             AND qcm05=g_shb.shb06   #製程序號
#             AND qcm14='Y'  #確認
#             AND (qcm09='1' OR qcm09='3')  #判定結果(1.Accept  3.特採) #No:7842,8454
#          IF cl_null(l_pqc_qty) THEN LET l_pqc_qty=0 END IF
#          DISPLAY l_pqc_qty TO FORMONLY.tot_pqc
#          LET g_tot_pqc = l_pqc_qty          #NO.FUN-940113
# 
#          IF cl_null(g_ecm.ecm311) THEN LET g_ecm.ecm311=0 END IF
#          IF cl_null(g_ecm.ecm312) THEN LET g_ecm.ecm312=0 END IF
#          IF cl_null(g_ecm.ecm313) THEN LET g_ecm.ecm313=0 END IF
#          IF cl_null(g_ecm.ecm314) THEN LET g_ecm.ecm314=0 END IF
#          IF cl_null(g_ecm.ecm302) THEN LET g_ecm.ecm302=0 END IF
#          IF cl_null(g_ecm.ecm303) THEN LET g_ecm.ecm303=0 END IF
#          IF cl_null(g_ecm.ecm316) THEN LET g_ecm.ecm316=0 END IF
# 
#          LET l_pqc_qty=l_pqc_qty - g_ecm.ecm311*g_ecm.ecm59    #良品轉出
#                                  - g_ecm.ecm312*g_ecm.ecm59    #重工轉出
#                                  - g_ecm.ecm314*g_ecm.ecm59    #當站下線
#                                  - g_ecm.ecm316*g_ecm.ecm59    #工單轉出
#                                  + g_ecm.ecm302
# 
#          IF l_sum_qty-g_shb.shb112>l_pqc_qty AND p_cmd<>'d'
#             THEN
#             LET g_msg="WIP:",l_wip_qty USING "<<<<.<<" CLIPPED,
#                       "  PQC:",l_pqc_qty USING "<<<<.<<" CLIPPED
#             CALL cl_err(g_msg,'asf-802',0)
#             DISPLAY l_wip_qty,l_pqc_qty,g_ecm.ecm53,g_ecm.ecm54
#                  TO FORMONLY.wip,FORMONLY.pqc,ecm53,ecm54
#             LET g_wip = l_wip_qty           #NO.FUN-940113     
#             LET g_pqc = l_pqc_qty            #NO.FUN-940113
#             LET g_ecm54 = g_ecm.ecm54         #NO.FUN-940113
#             LET g_ecm53 = g_ecm.ecm53
#             RETURN -1
#          END IF
#       END IF
#       DISPLAY l_wip_qty,l_pqc_qty,g_ecm.ecm53,g_ecm.ecm54
#            TO FORMONLY.wip,FORMONLY.pqc,ecm53,ecm54
#        LET g_wip = l_wip_qty           #NO.FUN-940113    
#        LET g_pqc = l_pqc_qty            #NO.FUN-940113
#        LET g_ecm53 = g_ecm.ecm53        #NO.FUN-940113
#        LET g_ecm54 = g_ecm.ecm54         #NO.FUN-940113
#        LET g_wip_qty = l_wip_qty    #MOD-530497
# 
#       RETURN 0
#END FUNCTION
#FUN-A50066--end--mark-----------------------------------

#FUN-A50066--begin--add-----------------------------
FUNCTION t700_accept_qty(p_cmd)
DEFINE l_flag     LIKE type_file.num5
DEFINE p_cmd      LIKE type_file.chr1

   CALL t700sub_accept_qty(p_cmd,g_shb.*) RETURNING l_flag,g_wip,g_pqc,g_ecm53,g_ecm54,g_tot_pqc #FUN-A80060
   DISPLAY g_wip,g_pqc,g_ecm53,g_ecm54,g_tot_pqc
            TO FORMONLY.wip,FORMONLY.pqc,ecm53,ecm54, FORMONLY.tot_pqc
   RETURN l_flag
END FUNCTION
#FUN-A50066--end--add--------------------------------------------

FUNCTION t700_i2()
 
    INPUT BY NAME
        g_shb.shb14,g_shb.shb15
 
        ON ACTION controlp
           CASE      #No.TQC-760108    add
               WHEN INFIELD(shb14)    #No.TQC-760108 add
                  CALL cl_init_qry_var()
                # LET g_qryparam.form ="q_rvv1"     #TQC-AB0331 mark
                  LET g_qryparam.form ="q_rvv4"     #TQC-AB0331
                  LET g_qryparam.default1 = g_shb.shb14
                  LET g_qryparam.default2 = g_shb.shb15
                  CALL cl_create_qry() RETURNING g_shb.shb14,g_shb.shb15
                  DISPLAY BY NAME g_shb.shb14,g_shb.shb15
                  NEXT FIELD shb14
               WHEN INFIELD(shb15)
                  IF NOT cl_null(g_shb.shb14) THEN
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_rvv11"
                     LET g_qryparam.default1 = g_shb.shb14
                     LET g_qryparam.default2 = g_shb.shb15
                     LET g_qryparam.arg1= g_shb.shb14
                     CALL cl_create_qry() RETURNING g_shb.shb15
                     DISPLAY BY NAME g_shb.shb14,g_shb.shb15
                     NEXT FIELD shb15
                  ELSE
                     CALL cl_init_qry_var()
                   # LET g_qryparam.form ="q_rvv1"       #TQC-AB0331 mark
                     LET g_qryparam.form ="q_rvv4"       #TQC-AB0331
                     LET g_qryparam.default1 = g_shb.shb14
                     LET g_qryparam.default2 = g_shb.shb15
                     CALL cl_create_qry() RETURNING g_shb.shb14,g_shb.shb15
                     DISPLAY BY NAME g_shb.shb14,g_shb.shb15
                     NEXT FIELD shb14
                  END IF
           END CASE
 
        AFTER INPUT
           IF INT_FLAG THEN
              LET INT_FLAG=0 CALL cl_err('',9001,0)
              INITIALIZE g_shb.* TO NULL
              CLEAR FORM
              CALL g_shc.clear()
              RETURN -1
           END IF
        
           IF cl_null(g_shb.shb14) THEN NEXT FIELD shb14 END IF
        
          #CHI-C50054 str mark-----
          #SELECT COUNT(*) INTO g_cnt FROM shb_file      #check是否已產生報工單
          # WHERE shb14 = g_shb.shb14 AND shb15 = g_shb.shb15
          #IF g_cnt > 0 THEN        #已存在的報工資料須先清除再重新產生
          #   CALL cl_err('','asf-815',0)
          #   NEXT FIELD shb14
          #END IF
          #CHI-C50054 end mark-----
        
           #NO.3525 add check 入庫單要是已確認的才可報工
           SELECT rvv_file.* INTO g_rvv.* FROM rvv_file,rvu_file
            WHERE rvu01=g_shb.shb14 AND rvuconf = 'Y'
              AND rvv02=g_shb.shb15 AND rvu01 = rvv01
           IF STATUS THEN CALL cl_err('sel rvv','asf-700',0) NEXT FIELD shb14 END IF
        
           LET g_argv3=g_shb.shb14
           LET g_argv4=g_shb.shb15
           LET g_argv5='a'
        
           SELECT pmn46,pmn012
             INTO g_pmn46,g_pmn012
             FROM pmn_file,rvb_file  #讀取製程序號 #FUN-A50066
            WHERE rvb01=g_rvv.rvv04 AND rvb02=g_rvv.rvv05
              AND rvb04=pmn01 AND rvb03=pmn02
           IF STATUS THEN CALL cl_err('sel pmn',STATUS,0) NEXT FIELD shb14 END IF
        
           SELECT ecm04,ecm05,ecm58 INTO g_ecm04,g_ecm05,g_ecm58 FROM ecm_file
            WHERE ecm01 = g_rvv.rvv18 AND ecm03=g_pmn46
              AND ecm012 = g_pmn012  #FUN-A50066 #FUN-A60087
           IF STATUS THEN CALL cl_err('sel ecm',STATUS,0) NEXT FIELD shb14 END IF
     

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
     END INPUT
 
     RETURN 0
 
END FUNCTION
 
FUNCTION t700_ck_pmn(p_shb05,p_shb06)
  DEFINE  
          p_shb05    LIKE shb_file.shb05,
          p_shb06    LIKE shb_file.shb06,
          l_pmn01    LIKE pmn_file.pmn01,
          l_pmn02    LIKE pmn_file.pmn02,
          l_cnt      LIKE type_file.num5    #No.FUN-680121 SMALLINT
 
 #先檢查是否有對應的採購單
  LET l_cnt = 0
  SELECT COUNT(*) INTO l_cnt FROM pmn_file,pmm_file
         WHERE pmn41 = p_shb05
           AND pmn43 = p_shb06
           AND pmn011= 'SUB' 
           AND pmn01 = pmm01
           AND pmmacti = 'Y'
 
  IF l_cnt = 0 THEN
     IF NOT cl_confirm('apm-077') THEN
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     END IF
  END IF
  IF l_cnt > 0 THEN       #No.MOD-860029 add
 #先檢查是否有對應的採購單
  LET l_cnt = 0
  SELECT COUNT(*) INTO l_cnt FROM pmn_file,pmm_file
         WHERE pmn41 = p_shb05
           AND pmn43 = p_shb06
           AND pmn011= 'SUB' 
           AND pmn01 = pmm01
           AND pmmacti = 'Y'
  IF l_cnt > 0 THEN       #No.MOD-840414 add
    #讀取委外工單的已發出採購單資料
       DECLARE t700_ck_pmn_cl CURSOR FOR
         SELECT pmn01,pmn02 FROM pmn_file,pmm_file
          WHERE pmn41 = p_shb05
            AND pmn43 = p_shb06
            AND pmn011= 'SUB'
            AND pmn16 NOT IN ('6','7','8','9')
            AND pmn01 = pmm01
            AND pmm25 = '2'
   
    #check 製程委外應要有入庫資料才可以報工
       LET g_errno = ''
       LET l_cnt = 0
       LET g_success = 'N'    #表示沒有入庫資料
   
      #讀取委外工單的採購單資料
       FOREACH t700_ck_pmn_cl INTO l_pmn01,l_pmn02
         IF STATUS THEN 
            LET g_errno = STATUS
            EXIT FOREACH
         END IF
   
        #check採購單是否有入庫資料
         SELECT COUNT(*) INTO l_cnt FROM rvv_file,rvu_file
          WHERE rvv36 = l_pmn01
            AND rvv37 = l_pmn02
            AND rvv01 = rvu01 
            AND rvuconf = 'Y'
         IF l_cnt > 0 THEN 
            LET g_success = 'Y'
         END IF
       END FOREACH 
   
       IF cl_null(g_errno) THEN
          IF g_success = 'N' THEN         #表沒有入庫ok的資料
             LET g_errno = 'asf-860' 
          END IF
       END IF
   END IF                        #No.MOD-840414 add
   END IF                        #No.MOD-860029 add
END FUNCTION
 

FUNCTION t700_sfb()
  #.........委外產生時,讀取工單資料&ecm_file,且資料不可異動...............
   LET g_shb.shb05 = g_rvv.rvv18
   SELECT sfb05 INTO g_shb.shb10 FROM sfb_file
    WHERE sfb01=g_shb.shb05
      AND ((sfb04 IN ('4','5','6','7','8') AND sfb39='1') OR
           (sfb04 IN ('2','3','4','5','6','7','8') AND sfb39='2'))
      AND (sfb28 < '2' OR sfb28 IS NULL)
   IF STATUS THEN   #資料不存在
      CALL cl_err(g_shb.shb05,STATUS,0)
      RETURN -1
   ELSE
      DISPLAY BY NAME g_shb.shb10
      CALL t700_shb10('d')
      IF NOT cl_null(g_errno) THEN
        CALL cl_err(g_shb.shb10,g_errno,0)
        LET g_shb.shb10 = g_shb_t.shb10
        DISPLAY BY NAME g_shb.shb10
        RETURN -1
      END IF
   END IF
   RETURN 0
END FUNCTION

#FUN-A80102(S)
FUNCTION t700_shb081_relation()
   DEFINE l_flag LIKE type_file.num5

  #CALL t700sub_shb081(g_shb.*,g_ecm.*,g_shb_t.*) RETURNING l_flag,g_shb.*,g_ecm.*      #MOD-C60147 mark
   CALL t700sub_shb081(g_shb.*,g_ecm.*,g_shb_t.*,'Y') RETURNING l_flag,g_shb.*,g_ecm.*  #MOD-C60147 add
   IF g_sma.sma901 = 'Y' THEN 
      CALL cl_set_comp_required("shb09",TRUE)
      IF g_ecm.ecm61 <> 'Y' THEN
          CALL cl_set_comp_entry("shb09",FALSE)
      ELSE
          CALL cl_set_comp_entry("shb09",TRUE)
      END IF
   ELSE
      CALL cl_set_comp_required("shb09",FALSE)
   END IF
   DISPLAY BY NAME g_shb.shb081,g_shb.shb06
   DISPLAY BY NAME g_shb.shb09
   DISPLAY BY NAME g_shb.shb02 ,g_shb.shb021
   DISPLAY BY NAME g_shb.shb26 ,g_shb.shb31   #FUN-A80102
   DISPLAY BY NAME g_shb.shb082,g_shb.shb07
   RETURN l_flag
END FUNCTION
#FUN-A80102(E)

FUNCTION t700_shb111()
DEFINE l_sma126              LIKE sma_file.sma126
DEFINE l_shb111              LIKE shb_file.shb111
DEFINE l_sgl08               LIKE sgl_file.sgl08
DEFINE l_sgl08_min           LIKE sgl_file.sgl08
DEFINE l_sgd                 RECORD LIKE sgd_file.*
 
         IF cl_null(g_shb.shb012) THEN LET g_shb.shb012=' ' END IF #FUN-A60095
         DECLARE sgd_cs CURSOR FOR 
         SELECT * FROM sgd_file
          WHERE sgd00 = g_shb.shb05
            AND sgd03 = g_shb.shb06
            AND sgd012= g_shb.shb012 #FUN-A50066
            AND sgd14 = 'Y'          #No.FUN-830088
         LET l_sgl08_min = 0
         FOREACH sgd_cs INTO l_sgd.*
#抓取飛票報工資料單頭，單身檔，抓出各單元的報工合計量，
#并得到所有單元中的最小報工量
         SELECT SUM(sgl08) INTO l_sgl08 
           FROM sgl_file,sgk_file
           WHERE sgl01 = sgk01
             AND sgl04 = l_sgd.sgd00
             AND sgl06 = l_sgd.sgd03
             AND sgl07 = l_sgd.sgd05
             AND sgl012= l_sgd.sgd012 #FUN-A50066
             AND sgk07 = 'Y'
             AND sgkacti = 'Y'
         IF l_sgl08 IS NULL THEN  LET l_sgl08 = 0 END IF
         IF l_sgl08 = 0 THEN
            LET l_sgl08_min = 0
            EXIT FOREACH
         ELSE
            IF l_sgl08_min = 0 THEN
               LET l_sgl08_min = l_sgl08
            ELSE
               IF l_sgl08 < l_sgl08_min THEN
                  LET l_sgl08_min = l_sgl08
               END IF
            END IF
          END IF
          END FOREACH
#再抓取本工單，工序在生產日報中已經報工的數量
          SELECT SUM(shb111) INTO l_shb111 FROM shb_file
           WHERE shb05 = g_shb.shb05
             AND shb06 = g_shb.shb06
             AND shb012= g_shb.shb012  #FUN-A50066
          IF cl_null(l_shb111) THEN
             LET l_shb111 = 0 
          END IF
          RETURN l_shb111,l_sgl08_min
END FUNCTION
 
FUNCTION t700_shb112()
DEFINE l_sma126              LIKE sma_file.sma126
DEFINE l_shb112              LIKE shb_file.shb112
DEFINE l_sgl09               LIKE sgl_file.sgl09
DEFINE l_sgl09_max           LIKE sgl_file.sgl09
DEFINE l_sgd                 RECORD LIKE sgd_file.*
 
        IF cl_null(g_shb.shb012) THEN LET g_shb.shb012=' ' END IF #FUN-A60095
         DECLARE sgd_cs1 CURSOR FOR 
         SELECT * FROM sgd_file
          WHERE sgd00 = g_shb.shb05
            AND sgd03 = g_shb.shb06
            AND sgd012= g_shb.shb012 #FUN-A50066
            AND sgd14 = 'Y'         #No.FUN-830088
         LET l_sgl09_max = 0
         FOREACH sgd_cs1 INTO l_sgd.*
#抓取飛票報工資料單頭，單身檔，抓出各單元的報工合計量，
#并得到所有單元中的最小報工量
         SELECT SUM(sgl09) INTO l_sgl09 
           FROM sgl_file,sgk_file
           WHERE sgl01 = sgk01
             AND sgl04 = l_sgd.sgd00
             AND sgl06 = l_sgd.sgd03
             AND sgl07 = l_sgd.sgd05
             AND sgl012= l_sgd.sgd012 #FUN-A50066
             AND sgk07 = 'Y'
             AND sgkacti = 'Y'
         IF l_sgl09 IS NULL THEN  LET l_sgl09 = 0 END IF
         IF l_sgl09 = 0 THEN
            LET l_sgl09_max = 0
            EXIT FOREACH
         ELSE
            IF l_sgl09_max = 0 THEN
               LET l_sgl09_max = l_sgl09
            ELSE
               IF l_sgl09 > l_sgl09_max THEN
                  LET l_sgl09_max = l_sgl09
               END IF
            END IF
          END IF
          END FOREACH
#再抓取本工單，工序在生產日報中已經報工的數量
          SELECT SUM(shb112) INTO l_shb112 FROM shb_file
           WHERE shb05 = g_shb.shb05
             AND shb06 = g_shb.shb06
             AND shb012= g_shb.shb012  #FUN-A50066
          IF cl_null(l_shb112) THEN LET l_shb112 = 0 END IF
          RETURN l_shb112,l_sgl09_max
END FUNCTION         
 
FUNCTION t700_chk_shb112()
DEFINE l_shc05 LIKE shc_file.shc05
   LET l_shc05=0
   SELECT SUM(shc05) INTO l_shc05 FROM shc_file 
                                 WHERE shc01=g_shb.shb01
                                   AND shc05 IS NOT NULL
   IF cl_null(l_shc05) OR SQLCA.sqlcode THEN
      LET l_shc05=0
   END IF
   RETURN (g_shb.shb112=l_shc05)
END FUNCTION
FUNCTION t700_def_form()
    #與APS整合時,asft700的shb09一律改成資源編號
     IF g_sma.sma901 = 'Y' THEN 
        #將機台編號(shb09)改show"資源編號"
        CALL cl_get_feldname('vlj06',g_lang) RETURNING g_msg
        CALL cl_set_comp_att_text("shb09",g_msg CLIPPED)
        CALL cl_set_comp_required("shb09",TRUE)
     ELSE
        CALL cl_get_feldname('shb09',g_lang) RETURNING g_msg
        CALL cl_set_comp_att_text("shb09",g_msg CLIPPED)
        CALL cl_set_comp_required("shb09",FALSE)
     END IF
     #FUN-A80102(S)
     IF g_sma.sma1435='N' THEN
        CALL cl_set_comp_entry("shb02,shb021,shb03,shb031,shb032,shb033",FALSE)
     END IF
     #FUN-A80102(E)
     CALL cl_set_comp_visible('shb012,ecu014,shb121,shc012,shb012_l,ecu014_l',g_sma.sma541='Y')  #FUN-A50066 #TQC-CB0084 
     #FUN-A80102(S)
     IF g_sma.sma1421 ='N' OR cl_null(g_sma.sma1421) THEN 
        CALL cl_set_comp_visible('sfb919',FALSE)
     END IF 
     IF g_sma.sma1431 ='N' OR cl_null(g_sma.sma1431) THEN 
        CALL cl_set_comp_visible('shb31,shb26,shb30',FALSE)
     END IF 
     #FUN-A80102(E)
END FUNCTION
 
FUNCTION t700_1()
   DEFINE tm            RECORD
                choice1 LIKE type_file.chr1,  
                shb21   LIKE shb_file.shb21,
                shb22   LIKE shb_file.shb22,
                dt1     LIKE type_file.dat,   
                emp     LIKE gen_file.gen01,
                gen02   LIKE gen_file.gen02,
                choice2 LIKE type_file.chr1,  
                choice3 LIKE type_file.chr1,    #FUN-BC0104
                dt2     LIKE type_file.dat,    
                wh1     LIKE img_file.img02,
                wh2     LIKE img_file.img03,
                wh3     LIKE img_file.img04
                        END RECORD
   DEFINE l_sfb        RECORD LIKE sfb_file.*,
          l_shb        RECORD LIKE shb_file.*,
          l_sfu        RECORD LIKE sfu_file.*,     
          l_cnt        LIKE type_file.num10,  
          l_gen02      LIKE gen_file.gen02,
          l_qcs091     LIKE qcs_file.qcs091,
          li_result    LIKE type_file.num5,   
          l_imd02      LIKE imd_file.imd02,
          l_sfv03      LIKE sfv_file.sfv03
   DEFINE l_gaz03      LIKE gaz_file.gaz03
   DEFINE l_qc_cnt     LIKE type_file.num10
   DEFINE l_aza41      LIKE type_file.chr18
   DEFINE l_count      LIKE type_file.num5
   DEFINE l_smy67      LIKE smy_file.smy67
   DEFINE l_smy68      LIKE smy_file.smy68
   DEFINE l_smyacti    LIKE smy_file.smyacti
   DEFINE l_smysys     LIKE smy_file.smysys
   DEFINE l_smyslip    LIKE smy_file.smyslip
   DEFINE l_smykind    LIKE smy_file.smykind
   DEFINE l_sfb94      LIKE sfb_file.sfb94 
   DEFINE l_shb111     LIKE shb_file.shb111 
   DEFINE l_shb115     LIKE shb_file.shb115    #MOD-C80257 add
   DEFINE l_flag       LIKE type_file.chr1
   DEFINE l_qcf22      LIKE qcf_file.qcf22 
   DEFINE g_qcf22      LIKE qcf_file.qcf22 
   DEFINE l_ecm311     LIKE ecm_file.ecm311
   DEFINE l_minus      LIKE ecm_file.ecm311
   DEFINE l_sfb09      LIKE sfb_file.sfb09 
   DEFINE g_sfv09      LIKE sfv_file.sfv09
   DEFINE l_c          LIKE type_file.num5  #TQC-B30194
   DEFINE l_t          LIKE type_file.num5  #TQC-B60129 
   #MOD-BB0116 -- begin --
   DEFINE l_sfb30      LIKE sfb_file.sfb30   #工單預計完工入庫倉庫
   DEFINE l_sfb31      LIKE sfb_file.sfb31   #工單預計完工入庫儲位
   #MOD-BB0116 -- end --
#  DEFINE l_shb21      LIKE shb_file.shb21   #FUN-BC0104  #TQC-C20248
   DEFINE l_msg        STRING                #TQC-C20248
   DEFINE l_ecm315     LIKE ecm_file.ecm35   #MOD-C80257 add
   DEFINE l_totQty     LIKE sfv_file.sfv09   #MOD-C80257 add 

   OPEN WINDOW t700_1_w AT 2,2 WITH FORM "asf/42f/asft700_1"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("asft700_1")

   #FUN-BC0104-add-str--
   SELECT qcz14 INTO g_qcz.qcz14 FROM qcz_file
   IF g_qcz.qcz14 = 'Y' THEN
      CALL cl_set_comp_visible("choice3",TRUE)
   ELSE
      CALL cl_set_comp_visible("choice3",FALSE)
   END IF
   #FUN-BC0104-add-end--   
 
   LET tm.choice1 = 'Y'
   LET tm.choice2 = 'Y'
   LET tm.choice3 = 'N'           #FUN-BC0104
   LET tm.dt1     = g_today
   LET tm.dt2     = g_today
   LET tm.emp     = g_user
   LET tm.shb21   = NULL  
   LET tm.shb22   = NULL
   IF g_aza.aza41 = '1' THEN 
      LET l_count = '3'
   ELSE
      IF g_aza.aza41 = '2' THEN 
         LET l_count = '4'
      ELSE 
         LET l_count = '5'
      END IF 
   END IF 
 
   LET l_aza41 = g_shb.shb01[1,l_count]                        #No.FUN-9B0045 mod
   SELECT smy67,smy68 INTO l_smy67,l_smy68 FROM smy_file
   WHERE smyslip = l_aza41

   IF cl_null(l_smy67) THEN
      CALL cl_err('','asf-151',1)
   END IF    
   LET tm.shb21 = l_smy67,'-'
   LET tm.shb22 = l_smy68,'-' 
   
   #MOD-BB0116 -- begin --
   SELECT sfb30,sfb31 INTO l_sfb30,l_sfb31 FROM sfb_file
    WHERE sfb01 = g_shb.shb05
   IF NOT cl_null(l_sfb30) THEN
      LET tm.wh1 = l_sfb30
   END IF
   IF NOT cl_null(l_sfb31) THEN
      LET tm.wh2 = l_sfb31
   END IF
   #MOD-BB0116 -- end --

   WHILE TRUE   
      
      DISPLAY BY NAME tm.shb21,tm.shb22 
      
      INPUT BY NAME tm.choice1,tm.shb22,tm.dt1,tm.emp,tm.choice2,tm.choice3,   #FUN-BC0104
                   tm.shb21,tm.dt2,tm.wh1,tm.wh2,tm.wh3 
                   WITHOUT DEFAULTS
      BEFORE INPUT 
         CALL cl_set_docno_format("shb21")
         CALL cl_set_docno_format("shb22")
             
         
       ON CHANGE choice1         
             CALL cl_set_comp_required("shb22",tm.choice1='Y')    
             IF tm.choice1 = 'N' THEN 
                LET tm.shb22 = NULL
                LET tm.dt1   = NULL
                LET tm.emp   = NULL
                #TQC-B30194--begin
                SELECT sfb94 INTO l_sfb94 FROM sfb_file WHERE sfb01=g_shb.shb05
                SELECT COUNT(*) INTO l_c FROM qcf_file WHERE qcf02=g_shb.shb05
                IF l_sfb94='Y' AND l_c=0 THEN 
                   CALL cl_err('','asf-606',1)
                END IF 
                #TQC-B30194--end
             ELSE
             	 LET tm.dt1 = g_today
             	 LET tm.emp = g_user   
             END IF 
             DISPLAY BY NAME tm.shb22,tm.dt1,tm.emp
     
       ON CHANGE choice2
          CALL cl_set_comp_required("shb21,dt2",tm.choice2='Y') 
          IF tm.choice2 = 'N' THEN 
             LET tm.shb21 = NULL
             LET tm.dt2   = NULL
             LET tm.wh1   = NULL
             LET tm.wh2   = NULL
             LET tm.wh3   = NULL
          ELSE
             LET tm.dt2 = g_today                
             LET tm.choice3 = 'N'      #FUN-BC0104
             CALL cl_set_comp_entry("wh1,wh2,wh3",TRUE)               #FUN-BC0104
          END IF 
          DISPLAY BY NAME tm.shb21,tm.dt2,tm.wh1,tm.wh2,tm.wh3,tm.choice3    #FUN-BC0104 add chice3

       #FUN-BC0104-add-str--
       ON CHANGE choice3
          CALL cl_set_comp_entry("wh1,wh2,wh3",tm.choice3='N')
          IF tm.choice3 = 'Y' THEN
             LET tm.choice2 = 'N'
            #LET tm.choice1 = 'Y'     #TQC-C20240
          END IF
         #DISPLAY BY NAME tm.choice1,tm.choice2
          DISPLAY BY NAME tm.choice2
       #FUN-BC0104-add-end--
               
       AFTER FIELD shb22
         IF NOT cl_null(tm.shb22) THEN
             LET g_t1 = s_get_doc_no(tm.shb22)
             CALL s_check_no("asf",g_t1,"","B","shb_file","shb22","")
                   RETURNING li_result,tm.shb22
             IF (NOT li_result) THEN
               NEXT FIELD shb22
             END IF
             SELECT smysys,smy68,smyacti,smykind INTO l_smysys,l_smy68,l_smyacti,l_smykind
               FROM smy_file
              WHERE smyslip = l_aza41          
             
           CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0014'  #無此單別
             WHEN l_smykind != '9'     LET g_errno = 'afa-095'  #單據性質不符,請重新輸入 !!
             WHEN l_smysys <> 'asf'    LET g_errno = 'asm-700'  #系統別不符,請重新輸入!!
             WHEN l_smyacti='N'        LET g_errno = '9028'
             OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
           END CASE      
           IF NOT cl_null(g_errno) THEN 
              CALL cl_err('',g_errno,0)
              NEXT FIELD shb22   
           ELSE
           	 DISPLAY BY NAME tm.shb22           	    
           END IF              
         END IF
       
       AFTER FIELD emp
          IF NOT cl_null(tm.emp) THEN
             LET l_gen02=''
             SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=tm.emp
             DISPLAY l_gen02 TO FORMONLY.gen02
             IF SQLCA.sqlcode THEN
                CALL cl_err('',100,0)
                NEXT FIELD emp
             END IF
          ELSE
             LET l_gen02=''
             DISPLAY l_gen02 TO FORMONLY.gen02
          END IF
     
       AFTER FIELD shb21
          IF NOT cl_null(tm.shb21) THEN
             LET g_t2 = s_get_doc_no(tm.shb21)
            #CALL s_check_no("asf",g_t2,'',"A","shb_file","shb21","") #FUN-A80128 mark
             CALL s_check_no("asf",g_t2,'',"A","sfu_file","sfu01","") #FUN-A80128 add
                    RETURNING li_result,tm.shb21
             IF (NOT li_result) THEN
                NEXT FIELD shb21
             END IF
             #TQC-AC0294-----start------------
             CALL t700_shb21()
             IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 NEXT FIELD shb21
             END IF
             #TQC-AC0294-----end--------------              
             
             SELECT smysys,smy67,smyacti,smykind INTO l_smysys,l_smy67,l_smyacti,l_smykind
               FROM smy_file
              WHERE smyslip = l_aza41
          
           CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0014'  #無此單別     
             WHEN l_smykind != '9'     LET g_errno = 'afa-095'  #單據性質不符,請重新輸入 !!       
             WHEN l_smysys <> 'asf'    LET g_errno = 'asm-700'  #系統別不符,請重新輸入!!
             WHEN l_smyacti='N'        LET g_errno = '9028'
             OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
           END CASE      
           IF NOT cl_null(g_errno) THEN 
              CALL cl_err('',g_errno,0)
              NEXT FIELD shb21 
           ELSE
           	 DISPLAY BY NAME tm.shb21                  
           END IF              
          END IF
 
       AFTER FIELD wh1
          IF tm.wh1 IS NOT NULL THEN
             SELECT imd02 INTO l_imd02 FROM imd_file WHERE imd01 = tm.wh1
             IF STATUS THEN
                CALL cl_err('sel imd',STATUS,0)
                NEXT FIELD wh1
             END IF
             #Add No.FUN-AB0049
             IF NOT s_chk_ware(tm.wh1) THEN  #检查仓库是否属于当前门店
                NEXT FIELD wh1
             END IF
             #End Add No.FUN-AB0049
          END IF
     
 
       AFTER INPUT 
         IF NOT INT_FLAG THEN             
     	   IF NOT cl_null(tm.emp) THEN
             LET l_gen02=''
             SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=tm.emp
             DISPLAY l_gen02 TO FORMONLY.gen02
             IF SQLCA.sqlcode THEN
                CALL cl_err('',100,0)
                NEXT FIELD emp
             END IF
          ELSE
             LET l_gen02=''
             DISPLAY l_gen02 TO FORMONLY.gen02
          END IF  
         END IF 
       
       ON ACTION controlp
          CASE
             WHEN INFIELD(shb22)                 
                  LET g_t1 = s_get_doc_no(tm.shb22)                   
                   CALL q_smy(FALSE,FALSE,g_t1,'ASF','B') RETURNING g_t1   #NO.FUN-940113 recuva
                  LET tm.shb22 = g_t1,'-'                            #NO.FUN-940113 add '-' 
                  DISPLAY BY NAME tm.shb22
                  NEXT FIELD shb22           
               WHEN INFIELD(emp)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gen"
                  CALL cl_create_qry() RETURNING tm.emp
                  DISPLAY BY NAME tm.emp
                  NEXT FIELD emp
               WHEN INFIELD(shb21)                
                  LET g_t2 = s_get_doc_no(tm.shb21)
                  LET g_sql = " (smy73 <> 'Y' OR smy73 is null)"  #TQC-AC0294 add
                  CALL smy_qry_set_par_where(g_sql)               #TQC-AC0294 add                  
                  CALL q_smy( FALSE,TRUE,g_t2,'ASF','A') RETURNING g_t2 #NO.FUN-940113 recuva
                  LET tm.shb21=g_t2,'-'                       #NO.FUN-940113 add '-'
                  DISPLAY BY NAME tm.shb21
                  NEXT FIELD shb21                  
               WHEN INFIELD(wh1)
                 #Mod No.FUN-AB0049
                 #CALL cl_init_qry_var()
                 #LET g_qryparam.form ="q_imd"
                 #LET g_qryparam.arg1 = 'SW'        #倉庫類別
                 #CALL cl_create_qry() RETURNING tm.wh1
                  CALL q_imd_1(FALSE,TRUE,"","",g_plant,"","")  #只能开当前门店的
                       RETURNING tm.wh1
                 #End Mod No.FUN-AB0049
                  DISPLAY BY NAME tm.wh1
                  NEXT FIELD wh1
               OTHERWISE EXIT CASE
          END CASE
     
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
     
       ON ACTION about         
          CALL cl_about()     
     
       ON ACTION help          
          CALL cl_show_help()  
     
       ON ACTION controlg      
          CALL cl_cmdask()     
     
     END INPUT
     
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        LET g_success='N'
        CLOSE WINDOW t700_1_w
        RETURN   
     END IF
     
     BEGIN WORK 
     LET g_success = 'Y'      
     LET l_flag = 'Y'
      
     IF tm.choice1='Y' THEN
        SELECT COUNT(*) INTO l_qc_cnt FROM shb_file  
         WHERE shb01 = g_shb.shb01
           AND shb22 IS NOT NULL 
           AND (SELECT qcf14 FROM qcf_file  #CHI-C90043
                 WHERE qcf01=shb22) <> 'X'  #CHI-C90043
        IF l_qc_cnt > 0 THEN        
           CALL cl_err('','asf-131',1)               
           LET g_success = 'N'        
           CONTINUE WHILE              
        END IF
        IF g_success = 'Y' THEN 
           DECLARE t700_w2_cur CURSOR FOR SELECT shb_file.*,sfb94 FROM shb_file,sfb_file
             WHERE shb01 = g_shb.shb01 
               AND sfb01 = g_shb.shb05
           FOREACH t700_w2_cur INTO l_shb.*,l_sfb94      
              #IF g_success='N' THEN     #TQC-DB0074 mark
              #TQC-DB0074--add--str--
              IF STATUS THEN             
                 CALL cl_err('',STATUS,0)
                 LET g_success = 'N'
                 LET l_flag = 'N'
              #TQC-DB0074--add--end
                 EXIT FOREACH
              END IF
              IF l_shb.shb111 <= 0 THEN 
                 CALL cl_err('','asf-991',0)
                 LET g_success = 'N'
                 LET l_flag = 'N'
                 EXIT FOREACH 
              END IF 
                
           SELECT ecm311 INTO l_ecm311 FROM ecm_file
            WHERE ecm01 = g_shb.shb05
              AND ecm03 = g_shb.shb06
              AND ecm012= g_shb.shb012   #FUN-A50066
           SELECT SUM(qcf22) INTO l_qcf22 FROM qcf_file
            WHERE qcf01 IS NOT NULL
              AND qcf02 = g_shb.shb05
              AND qcf14 = 'Y'
              AND qcf18 = '1'
    
           IF cl_null(l_shb.shb111) THEN 
              LET l_shb.shb111 = 0 
           END IF 
           IF cl_null(l_ecm311) THEN 
              LET l_ecm311 = 0 
           END IF 
           IF cl_null(l_qcf22) THEN 
              LET l_qcf22 = 0 
           END IF 
           LET l_minus = l_ecm311 - l_qcf22
           IF l_shb.shb111 < l_minus THEN 
              LET g_qcf22=l_shb.shb111
           ELSE
                LET g_qcf22 = l_minus 
           END IF 	 
           IF g_qcf22 <= 0 THEN 
              CALL cl_err('','asf-993',0)
              LET g_success = 'N'
              LET l_flag = 'N'
              EXIT FOREACH 
           END IF                       
           LET g_t1 = s_get_doc_no(tm.shb22)          
           #IF (l_sfb94 = 'Y') AND cl_null(l_shb.shb22) THEN  #CHI-C90043
           IF (l_sfb94 = 'Y') THEN  #CHI-C90043
              SELECT COUNT(*) INTO l_cnt FROM shm_file  #此工單走run card
               WHERE shm012 = l_shb.shb05                         
              IF l_cnt > 0  THEN 
                 CALL cl_err('',"asf-990",1)  
                 LET g_success ='N'
                 EXIT FOREACH
              END IF 
 
               CALL s_auto_assign_no("asf",g_t1,tm.dt1,"B","shb_file","shb22","","","")                      
                     RETURNING li_result,tm.shb22                                 
               IF (NOT li_result) THEN
                  CALL cl_err('shb22',"sub-143",1)                       
                  LET g_success ='N'
                  EXIT FOREACH
               END IF
               LET g_shb22 = tm.shb22
               LET g_emp = tm.emp
               CALL t700_w4(l_shb.*)   
            ELSE
            	  IF cl_null(l_sfb94) OR l_sfb94 = 'N' THEN 
                  CALL cl_err('','asf-995',1)
                  IF tm.choice2 = 'N' THEN   #TQC-B60127 
                     LET g_success = 'N'     #TQC-B60127
                   END IF                    #TQC-B60127  
              END IF 
           END IF
        END FOREACH
     END IF
     IF l_flag = 'N' THEN 
        CONTINUE WHILE 
     END IF 
END IF       
#TQC-B60129 ------------------------------Begin----------------------------------
     IF tm.choice1 = 'N' AND tm.choice2 = 'Y' THEN
        CALL s_showmsg_init()
        DECLARE t300_w2_cur_1 CURSOR FOR SELECT shb_file.*,sfb94 FROM shb_file,sfb_file
          WHERE shb01 = g_shb.shb01
            AND sfb01 = g_shb.shb05
        FOREACH t300_w2_cur_1 INTO l_shb.*,l_sfb94
           IF g_success='N' THEN
              EXIT FOREACH
           END IF
           IF l_sfb94 = 'Y' THEN
              LET l_t = 0
              SELECT COUNT(*) INTO l_t FROM qcf_file
               WHERE qcf01 IS NOT NULL
                 AND qcf02 = l_shb.shb05
                 AND qcf14 = 'Y'
               # AND qcf18 = '2'   #FUN-A70095
                 AND qcf18 = '1'   #FUN-A70095
              IF l_t=0 THEN
                 CALL s_errmsg('shb05',l_shb.shb05,'','asr-055',1)
                 LET g_success='N'
              END IF
           END IF
        END FOREACH
        CALL s_showmsg()
     END IF
#TQC-B60129 ------------------------------End-------------------------------------
      IF (tm.choice2='Y') AND (g_success='Y') THEN   ##如果FQC單有產生失敗,則入庫單就不操作執行
          SELECT COUNT(*) INTO l_qc_cnt FROM shb_file
           WHERE shb01 = g_shb.shb01
             AND shb21 IS NOT NULL 
         IF l_qc_cnt > 0 THEN 
            CALL cl_err('','asf-132',1)
            LET g_success = 'N'  
            IF tm.choice1 = 'Y' THEN 
               LET g_shb.shb22 = NULL
               UPDATE shb_file SET shb22 = NULL WHERE shb01 = g_shb.shb01  
            END IF 
            CONTINUE WHILE 
        ELSE          
         IF cl_null(tm.wh2) THEN                     
            LET tm.wh2=' '
         END IF
         IF cl_null(tm.wh3) THEN
            LET tm.wh3=' '
         END IF
        #SELECT shb111 INTO l_shb111 FROM shb_file                    #MOD-C80257 mark
         SELECT shb111,shb115 INTO l_shb111,l_shb115 FROM shb_file    #MOD-C80257
          WHERE shb01 = g_shb.shb01        
         IF cl_null(l_shb111) THEN LET l_shb111 = 0 END IF      #MOD-C80257 add
         IF cl_null(l_shb115) THEN LET l_shb115 = 0 END IF      #MOD-C80257 add
        #IF l_shb111 <= 0 THEN             #MOD-C80257 mark
         IF l_shb111+l_shb115 <= 0 THEN    #MOD-C80257
            CALL cl_err('','asf-992',0)
            LET g_success = 'N' 
            CONTINUE WHILE 
         END IF  
         
         SELECT sfb09 INTO l_sfb09 FROM sfb_file
          WHERE sfb01 = g_shb.shb05
        #SELECT ecm311 INTO l_ecm311 FROM ecm_file                   #CHI-BA0035 mark 
         SELECT ecm311,ecm315 INTO l_ecm311,l_ecm315 FROM ecm_file   #CHI-BA0035
          WHERE ecm01 = g_shb.shb05
            AND ecm03 = g_shb.shb06   
            AND ecm012= g_shb.shb012   #FUN-A50066                                      
         IF cl_null(l_sfb09) THEN LET l_sfb09 = 0 END IF 
         IF cl_null(l_ecm311) THEN LET l_ecm311 = 0 END IF 
        #IF cl_null(l_shb111) THEN LET l_shb111 = 0 END IF   #MOD-C80257 mark 
        
       
        #MOD-C80257 mark---S--- 
        #LET l_minus = l_ecm311 - l_sfb09 
        #IF l_shb111 < l_minus THEN 
        #   LET g_sfv09 = l_shb111
        #ELSE
        #   LET g_sfv09 = l_minus 
        #END IF    
        #MOD-C80257 mark---E---
        #MOD-C80257 add---S---
         LET l_totQty = l_ecm311 + l_ecm315   
         LET l_minus = l_totQty - l_sfb09
         IF l_shb111+l_shb115 < l_minus THEN  
            LET g_sfv09 = l_shb111+l_shb115  
         ELSE
            LET g_sfv09 = l_minus
         END IF
        #MOD-C80257 add---E---
         IF g_sfv09 <= 0 THEN 
            CALL cl_err('','asf-994',0)
            LET g_success = 'N' 
            CONTINUE WHILE          
         END IF           
         LET l_cnt=0
          SELECT COUNT(*) INTO l_cnt FROM shb_file,sfb_file
           WHERE shb01 = g_shb.shb01
             AND sfb01 = g_shb.shb05   
              
         IF l_cnt>0 THEN  #產生入庫單頭
            INITIALIZE l_sfu.* TO NULL
            LET g_t2 = s_get_doc_no(tm.shb21)    
      #     CALL s_auto_assign_no("apm",g_t2,tm.dt2,"A","sfu_file","sfu01","","","")  #TQC-A50102 
            CALL s_auto_assign_no("asf",g_t2,tm.dt2,"A","sfu_file","sfu01","","","")  #TQC-A50102
               RETURNING li_result,tm.shb21        
            IF (NOT li_result) THEN
               LET g_success='N'
               CALL cl_err('sfu01',"sub-143",1)
            END IF
 
            LET l_sfu.sfu00='1'    #工單完工入庫
            LET l_sfu.sfu01=tm.shb21     
            LET l_sfu.sfu02=tm.dt2
            LET l_sfu.sfu14=tm.dt2     
            LET l_sfu.sfu04=g_grup
            LET l_sfu.sfupost='N'
            LET l_sfu.sfuconf='N'       
            LET l_sfu.sfuuser=g_user
            LET l_sfu.sfugrup=g_grup
            LET l_sfu.sfumodu=''
            LET l_sfu.sfudate=g_today
            LET l_sfu.sfuplant = g_plant #FUN-980008 add
            LET l_sfu.sfulegal = g_legal #FUN-980008 add
            LET l_sfu.sfuoriu = g_user      #No.FUN-980030 10/01/04
            LET l_sfu.sfuorig = g_grup      #No.FUN-980030 10/01/04
            #TQC-B40197--begin
            IF cl_null(l_sfu.sfu15) THEN
               LET l_sfu.sfu15 = '0'
            END IF
            #TQC-B60232 add
            SELECT smyapr INTO l_sfu.sfumksg FROM smy_file
             WHERE smyslip = g_t2
            #TQC-B60232 add--end
            IF cl_null(l_sfu.sfumksg) THEN
               LET l_sfu.sfumksg = 'N'
            END IF
            #TQC-B40197--end 
            #FUN-A80128---add---str--
            LET l_sfu.sfu15   = '0'
            LET l_sfu.sfu16   = g_user
           #LET l_sfu.sfumksg =  g_smy.smyapr   #TQC-B60232
            #FUN-A80128---add---end--
            INSERT INTO sfu_file VALUES (l_sfu.*)
            IF SQLCA.sqlcode THEN
               CALL cl_err('ins sfu',SQLCA.sqlcode,1)
               LET g_success='N'
            END IF
         END IF
 
         LET l_sfv03=1
          SELECT shb_file.*,sfb94 INTO l_shb.*,l_sfb94 FROM shb_file,sfb_file
            WHERE shb01 = g_shb.shb01
              AND sfb01 = g_shb.shb05 
             IF (l_sfb94 = 'N') AND cl_null(l_shb.shb21) THEN   
                LET g_shb21  = tm.shb21
                LET g_wh1    = tm.wh1
                LET g_wh2    = tm.wh2
                LET g_wh3    = tm.wh3
               #CALL t700_w3(l_shb.*,l_sfv03,l_shb.shb111)                 #MOD-C80257 mark       
                CALL t700_w3(l_shb.*,l_sfv03,l_shb.shb111+l_shb.shb115)    #MOD-C80257
                UPDATE shb_file SET shb21 = tm.shb21
                 WHERE shb01 = l_shb.shb01
                 LET g_shb.shb21 = tm.shb21 
               IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                  CALL cl_err('upd shb21',SQLCA.sqlcode,1)  
                  LET g_success='N'
               END IF
            END IF
 
              IF (l_sfb94 = 'Y') AND (NOT cl_null(l_shb.shb22) AND cl_null(l_shb.shb21)) THEN 
                LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM qcf_file 
                WHERE qcf01=l_shb.shb22
                  AND qcf14='Y'
                  AND (qcf09='1' OR qcf09='3')
               IF l_cnt>0 THEN
                  LET l_qcs091=0
                  SELECT qcf091 INTO l_qcs091 FROM qcf_file 
                   WHERE qcf01=l_shb.shb22
                   LET g_shb21 = tm.shb21    #TQC-B30125
                   CALL t700_w3(l_shb.*,l_sfv03,l_qcs091)
                   UPDATE shb_file set shb21=tm.shb21
                   WHERE shb01=l_shb.shb01
                     LET g_shb.shb21 = tm.shb21
                  IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                     CALL cl_err('upd shb21',SQLCA.sqlcode,1)
                     LET g_success='N'
                  END IF
               ELSE
                  CALL cl_err('','asf-152',1)  #MOD-9C0197
               END IF
            END IF
            #TQC-DB0074--add--str--
            #刪除只有單頭沒有單身的無效入庫單資料
            IF g_success='Y' THEN
               SELECT COUNT(*) INTO l_cnt FROM sfu_file WHERE sfu01=tm.shb21
               IF l_cnt>0 THEN
                  LET l_cnt=0
                  SELECT COUNT(*) INTO l_cnt FROM sfv_file WHERE sfv01=tm.shb21
                  IF l_cnt=0 THEN
                     DELETE FROM sfu_file WHERE sfu01=tm.shb21
                     LET g_success='N'
                  END IF
               END IF
            END IF               
            #TQC-DB0074--add--end 
         END IF
      END IF 
  
  #FUN-BC0104----add----str----
  IF (tm.choice3 = 'Y') AND (g_success = 'Y') THEN 
    #LET g_msg = "aqcp107 '2' '",tm.shb21,"' '' '",tm.dt2,"' '' '' '",g_shb.shb05,"' '",g_shb.shb10,"' '' 'Y'"     #TQC-C20248
    #TQC-C20248 --------Begin--------
     LET l_msg = "&",g_shb.shb01 
     LET g_msg = "aqcp107 '2' '",tm.shb21,"' '' '",tm.dt2,"' '' '' '",g_shb.shb05,"' '",g_shb.shb10,"' '",l_msg ,"' 'Y'" 
     CALL cl_cmdrun_wait(g_msg)  
    #TQC-C20248 --------End----------
  END IF
#TQC-C20248 -----------Begin------------
# SELECT DISTINCT sfv01 INTO l_shb21 FROM sfv_file
#  WHERE sfv11 = g_shb.shb05 AND sfv17 = g_shb.shb22
# UPDATE shb_file set shb21=l_shb21
#  WHERE shb01=g_shb.shb01
# LET g_shb.shb21 = l_shb21
# IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#    CALL cl_err('upd shb21',SQLCA.sqlcode,1)
#    LET g_success='N'
# END IF  
#TQC-C20248 -----------End-------------
  #FUN-BC0104----add----end---- 

  IF g_success = 'Y' THEN 
    IF tm.choice1 = 'Y' OR tm.choice2 = 'Y' OR tm.choice3 ='Y' THEN      #FUN-BC0104 add choice3   #TQC-C20361 remark 
  # IF (tm.choice1 = 'Y' OR tm.choice2 = 'Y') AND tm.choice3 ='N' THEN   #TQC-C20248 add choice3   #TQC-C20361 mark
      IF cl_confirm("asf-133") THEN 
        LET g_success = 'Y'
      ELSE
      	 SELECT COUNT(*) INTO l_qc_cnt FROM shb_file  
          WHERE shb01 = g_shb.shb01
            AND shb22 IS NOT NULL 
           IF l_qc_cnt > 0  AND tm.choice1 = 'Y' THEN   
              LET g_shb.shb22 = ''
           END IF  
         SELECT COUNT(*) INTO l_qc_cnt FROM shb_file
          WHERE shb01 = g_shb.shb01
            AND shb21 IS NOT NULL            	
          IF l_qc_cnt > 0 AND tm.choice2 = 'Y' THEN 
             LET g_shb.shb21 = ''
          END IF 
               
          LET g_success  = 'N'        
      END IF       	   
   END IF   
  END IF     
      CLOSE WINDOW t700_1_w
      EXIT WHILE
   END WHILE
   
   CLOSE t700_cl
   IF g_success != 'Y' THEN 
      ROLLBACK WORK
      CALL cl_err('','9052',0)
   ELSE   
      COMMIT WORK
      CALL cl_err('','asr-026',0) #TQC-DB0074
    END IF    
 
END FUNCTION
 
FUNCTION t700_w3(l_shb,l_sfv03,l_sfv09)      
   DEFINE l_shb RECORD    LIKE shb_file.*,
          l_sfv RECORD    LIKE sfv_file.*,
          l_sfv03         LIKE sfv_file.sfv03,
          l_sfv09         LIKE sfv_file.sfv09,
          l_ima906        LIKE ima_file.ima906,
          l_ima907        LIKE ima_file.ima907,
          l_factor        LIKE ima_file.ima31_fac,  
          l_flag          LIKE type_file.num5,
          l_ima25         LIKE ima_file.ima25,
          l_ima35         LIKE ima_file.ima35,
          l_ima36         LIKE ima_file.ima36,
          l_sfb98         LIKE sfb_file.sfb98
   DEFINE l_ecm311        LIKE ecm_file.ecm311
   DEFINE l_sfb09         LIKE sfb_file.sfb09
   DEFINE l_minus         LIKE sfb_file.sfb09 
   DEFINE l_sfvi   RECORD LIKE sfvi_file.*          #FUN-B70074
   #CHI-B90015 -- begin --
   DEFINE l_ima903        LIKE ima_file.ima903
   DEFINE l_cnt           LIKE type_file.num5
   #CHI-B90015 -- end --
   DEFINE l_sfv08         LIKE sfv_file.sfv08   #No.FUN-BB0086
   #MOD-C20006 ---add---str---
   DEFINE l_sfb27         LIKE sfb_file.sfb27,
          l_sfb271        LIKE sfb_file.sfb271
   #MOD-C20006 ---add---end--- 
   DEFINE l_ecm315        LIKE ecm_file.ecm315  #MOD-C80257 add
   DEFINE l_totQty        LIKE sfv_file.sfv09   #MOD-C80257 add
   DEFINE l_sfu04         LIKE sfu_file.sfu04   #FUN-CB0087 add
   DEFINE l_sfu16         LIKE sfu_file.sfu16   #FUN-CB0087 add
 
  #SELECT ima25,ima906,ima907,ima35,ima36 INTO l_ima25,l_ima906,l_ima907,l_ima35,l_ima36    #CHI-B90015 mark
   SELECT ima25,ima906,ima907,ima35,ima36,ima903                                            #CHI-B90015
     INTO l_ima25,l_ima906,l_ima907,l_ima35,l_ima36,l_ima903                                #CHI-B90015
     FROM ima_file
    WHERE ima01 = l_shb.shb10 
   
  #SELECT sfb98 INTO l_sfb98 FROM sfb_file                                 #MOD-C20006 mark
   SELECT sfb98,sfb27,sfb271 INTO l_sfb98,l_sfb27,l_sfb271 FROM sfb_file   #MOD-C20006
    WHERE sfb01 = g_shb.shb05  
 
    SELECT sfb09 INTO l_sfb09 FROM sfb_file
     WHERE sfb01 = g_shb.shb05
   #SELECT ecm311 INTO l_ecm311 FROM ecm_file                   #CHI-BA0035 mark
    SELECT ecm311,ecm315 INTO l_ecm311,l_ecm315 FROM ecm_file   #CHI-BA0035
     WHERE ecm01 = g_shb.shb05
       AND ecm03 = g_shb.shb06  
       AND ecm012= g_shb.shb012  #FUN-A50066                                       
   IF cl_null(l_sfb09) THEN LET l_sfb09 = 0 END IF 
   IF cl_null(l_ecm311) THEN LET l_ecm311 = 0 END IF 
   IF cl_null(l_ecm315) THEN LET l_ecm315 = 0 END IF   #CHI-BA0035 add
   IF cl_null(l_sfv09) THEN LET l_sfv09 = 0 END IF    
   
   LET l_sfv.sfv01=g_shb21        
   LET l_sfv.sfv03=l_sfv03
   LET l_sfv.sfv04=l_shb.shb10 

   #MOD-C20006 ---add---str---
   LET l_sfv.sfv41 = l_sfb27
   LET l_sfv.sfv42 = l_sfb271
   #MOD-C20006 ---add---str---
    
   IF NOT cl_null(g_wh1) THEN     
     LET l_sfv.sfv05 = g_wh1           
   ELSE
   	 LET l_sfv.sfv05 = l_ima35
   END IF 	  
   IF NOT cl_null(g_wh2) THEN 
      LET l_sfv.sfv06 = g_wh2          
   ELSE
   	  LET l_sfv.sfv06 = l_ima36
   END IF 	   
   LET l_sfv.sfv07=g_wh3          
   LET l_sfv.sfv08=l_ima25
  #MOD-C80257---mark---S---
  #LET l_minus = l_ecm311 - l_sfb09 
  #IF l_sfv09 < l_minus THEN 
  #   LET l_sfv.sfv09 = l_sfv09
  #ELSE
  #   LET l_sfv.sfv09 = l_minus 
  #END IF   
  #MOD-C80257---mark---E---
  #MOD-C80257 add---S
   LET l_totQty = l_ecm311 + l_ecm315  
   LET l_minus = l_totQty - l_sfb09
   IF l_sfv09 < l_minus THEN
      LET l_sfv.sfv09 = l_sfv09  
   ELSE
      LET l_sfv.sfv09 = l_minus
   END IF
  #MOD-C80257 add---E
   #No.FUN-BB0086--add--start--
   SELECT sfv08 INTO l_sfv08 FROM sfv_file WHERE sfv01=l_sfv.sfv01 AND sfv03=l_sfv.sfv03
   LET l_sfv.sfv09 = s_digqty(l_sfv.sfv09,l_sfv08)
   #No.FUN-BB0086--add--start--
   LET l_sfv.sfv930=l_sfb98 
   LET l_sfv.sfv16='N'   
   LET l_sfv.sfv11=l_shb.shb05   #(工單生產 此欄是 工單編號)     
   LET l_sfv.sfv17=l_shb.shb22   #(工單生產 此欄是 FQC單號)     
   LET l_sfv.sfvplant = g_plant #FUN-980008 add
   LET l_sfv.sfvlegal = g_legal #FUN-980008 add
 
   CASE
      WHEN l_ima906='1'
         LET l_sfv.sfv30=l_ima25          
         LET l_sfv.sfv31=1
        #LET l_sfv.sfv32=l_shb.shb111   #CHI-BA0035 mark
         LET l_sfv.sfv32 = l_sfv.sfv09  #CHI-BA0035
         LET l_sfv.sfv33=''
         LET l_sfv.sfv34=''
         LET l_sfv.sfv35=''
      WHEN l_ima906 MATCHES '[2,3]'
         LET l_sfv.sfv30=l_ima25          
         LET l_sfv.sfv31=1
        #LET l_sfv.sfv32=l_shb.shb111   #CHI-BA0035 mark
         LET l_sfv.sfv32 = l_sfv.sfv09  #CHI-BA0035
         LET l_sfv.sfv33=l_ima907
         CALL s_umfchk(l_sfv.sfv04,l_ima907,l_sfv.sfv08) RETURNING l_flag,l_factor
         IF l_flag=1 THEN
           LET l_factor=1
         END IF
         LET l_sfv.sfv34=l_factor
         LET l_sfv.sfv35=0
   END CASE
   LET l_sfv.sfv32 = s_digqty(l_sfv.sfv32,l_sfv.sfv30)   #No.FUN-BB0086
   #CHI-B90015 -- begin --
   IF l_ima903 = 'Y' AND g_sma.sma104 = 'Y' AND g_sma.sma105 = '2' THEN
      SELECT COUNT(*) INTO l_cnt FROM bmm_file
       WHERE bmm01 = l_shb.shb10
      IF l_cnt > 0 THEN
         LET l_sfv.sfv16 = 'Y'
      END IF
   END IF
   #CHI-B90015 -- end --

   #TQC-C20465 ---------Begin--------
   IF cl_null(l_sfv.sfv05) THEN LET l_sfv.sfv05 = ' ' END IF
   IF cl_null(l_sfv.sfv06) THEN LET l_sfv.sfv06 = ' ' END IF
   IF cl_null(l_sfv.sfv07) THEN LET l_sfv.sfv07 = ' ' END IF
   #TQC-C20465 ---------End----------

   #FUN-CB0087---add---str---
   IF g_aza.aza115 = 'Y' THEN
      SELECT sfu04,sfu16 INTO l_sfu04,l_sfu16 FROM sfu_file WHERE sfu01 = l_sfv.sfv01
      CALL s_reason_code(l_sfv.sfv01,l_sfv.sfv11,'',l_sfv.sfv04,l_sfv.sfv05,l_sfu16,l_sfu04) RETURNING l_sfv.sfv44
      IF cl_null(l_sfv.sfv44) THEN
         CALL cl_err('','aim-425',1)
         LET g_success='N'
      END IF
   END IF
   #FUN-CB0087---add---end--
   INSERT INTO sfv_file VALUES (l_sfv.*)
   IF SQLCA.sqlcode THEN
      CALL cl_err('ins sfv',SQLCA.sqlcode,1)
      LET g_success='N'
#FUN-B70074--add--insert--
   ELSE
      IF NOT s_industry('std') THEN
         INITIALIZE l_sfvi.* TO NULL
         LET l_sfvi.sfvi01 = l_sfv.sfv01
         LET l_sfvi.sfvi03 = l_sfv.sfv03
         IF NOT s_ins_sfvi(l_sfvi.*,l_sfv.sfvplant) THEN
            LET g_success = 'N'  
         END IF
      END IF 
#FUN-B70074--add--insert--
   END IF
END FUNCTION
 
FUNCTION t700_w4(l_shb) #工單生產報工產生FQC(aqct410)
DEFINE l_shb       RECORD LIKE shb_file.*,
       l_qcf       RECORD LIKE qcf_file.*,
       l_ima55     LIKE ima_file.ima55,
       l_ima102    LIKE ima_file.ima102,
       l_ima100    LIKE ima_file.ima100,
       l_ima906    LIKE ima_file.ima906,
       l_ima907    LIKE ima_file.ima907,
       l_factor    LIKE ima_file.ima31_fac, 
       l_flag      LIKE type_file.num5      
DEFINE l_ecm311    LIKE ecm_file.ecm311
DEFINE l_minus     LIKE ecm_file.ecm311
DEFINE l_qcf22     LIKE qcf_file.qcf22
DEFINE l_ecm315    LIKE ecm_file.ecm315   #MOD-C80257 add
DEFINE l_totQty    LIKE qcf_file.qcf22    #MOD-C80257 add
 
    INITIALIZE l_qcf.* TO NULL
    SELECT ima102,ima100,ima906,ima907,ima55 INTO l_ima102,l_ima100,l_ima906,l_ima907,l_ima55
      FROM ima_file
     WHERE ima01=l_shb.shb10   
     
   #SELECT ecm311 INTO l_ecm311 FROM ecm_file                   #CHI-BA0035 mark
    SELECT ecm311,ecm315 INTO l_ecm311,l_ecm315 FROM ecm_file   #CHI-BA0035
     WHERE ecm01 = g_shb.shb05
       AND ecm03 = g_shb.shb06
       AND ecm012= g_shb.shb012  #FUN-A50066
    SELECT SUM(qcf22) INTO l_qcf22 FROM qcf_file
     WHERE qcf01 IS NOT NULL
       AND qcf02 = g_shb.shb05
       AND qcf14 = 'Y'
       AND qcf18 = '1'
    
    IF cl_null(l_shb.shb111) THEN 
       LET l_shb.shb111 = 0 
    END IF 
    IF cl_null(l_ecm311) THEN 
       LET l_ecm311 = 0 
    END IF 
    IF cl_null(l_ecm315) THEN LET l_ecm315 = 0 END IF   #MOD-C90059 add
    IF cl_null(l_qcf22) THEN 
       LET l_qcf22 = 0 
    END IF          
     
    LET l_qcf.qcf22=0
    LET l_qcf.qcf06=0
    LET l_qcf.qcf00='1'
    LET l_qcf.qcfuser=g_user
    LET l_qcf.qcfgrup=g_grup
    LET l_qcf.qcfdate=g_today
    LET l_qcf.qcfacti='Y'              #資料有效
    LET l_qcf.qcf041=TIME              #資料有效
    LET l_qcf.qcf04=g_today            #資料有效
    LET l_qcf.qcf05=1                 
    LET l_qcf.qcf14='N'
    LET l_qcf.qcf15=''
    LET l_qcf.qcf091=0
    LET l_qcf.qcf13 = g_emp
    LET l_qcf.qcf18 = '1'
    LET l_qcf.qcf03 = ' '
    LET l_qcf.qcf01=g_shb22             
    LET l_qcf.qcf02=l_shb.shb05      
    LET l_qcf.qcf05=1
    LET l_qcf.qcf021=l_shb.shb10                 
    LET l_qcf.qcf21=l_ima100
    LET l_qcf.qcf17=l_ima102
   #MOD-C80257 mark---S---
   #LET l_minus = l_ecm311 - l_qcf22
   #IF l_shb.shb111 < l_minus THEN 
   #    LET l_qcf.qcf22=l_shb.shb111
   #ELSE
   #    LET l_qcf.qcf22 = l_minus 
   #END IF 	    
   #MOD-C80257 mark---E---
   #MOD-C80257 add---S---
    IF cl_null(l_shb.shb115) THEN LET l_shb.shb115 = 0 END IF   #MOD-C90059 add
   #LET l_totQty = l_ecm311 + l_ecm315                   #MOD-C90059 mark 
    LET l_totQty = l_shb.shb111 + l_shb.shb115           #MOD-C90059
    LET l_minus = l_ecm311 + l_ecm315- l_qcf22           #MOD-C90059
    IF l_totQty < l_minus THEN
       LET l_qcf.qcf22 = l_totQty 
    ELSE
       LET l_qcf.qcf22 = l_minus
    END IF 
   #MOD-C80257 add---E---
    LET l_qcf.qcf06=t700_t410_defqty(1,0,l_qcf.*)   
    LET l_qcf.qcfspc = '0'
    LET l_qcf.qcfplant = g_plant #FUN-980008 add
    LET l_qcf.qcflegal = g_legal #FUN-980008 add
    
   CASE
      WHEN l_ima906="1"
            LET l_qcf.qcf30=l_ima55      
            LET l_qcf.qcf31=1 
           #LET l_qcf.qcf32=l_shb.shb111   #MOD-C90059 mark
            LET l_qcf.qcf32 = l_qcf.qcf22  #MOD-C90059 
            LET l_qcf.qcf33=''
            LET l_qcf.qcf34=''
            LET l_qcf.qcf35=''
      WHEN l_ima906 MATCHES '[2,3]'
            LET l_qcf.qcf30=l_ima55       
            LET l_qcf.qcf31=1
           #LET l_qcf.qcf32=l_shb.shb111   #MOD-C90059 mark 
            LET l_qcf.qcf32 = l_qcf.qcf22  #MOD-C90059
            LET l_qcf.qcf33=l_ima907
            CALL s_umfchk(l_shb.shb10,l_ima907,l_ima55) RETURNING l_flag,l_factor                              
            IF l_flag=1 THEN
              LET l_factor=1
            END IF
            LET l_qcf.qcf34=l_factor
            LET l_qcf.qcf091= l_qcf.qcf22
            LET l_qcf.qcf35 = l_qcf.qcf22 / l_factor
            LET l_qcf.qcf36 = l_qcf.qcf30
            LET l_qcf.qcf37 = l_qcf.qcf31
            LET l_qcf.qcf38 = l_qcf.qcf22 / l_qcf.qcf37
            LET l_qcf.qcf39 = l_qcf.qcf33
            LET l_qcf.qcf40 = l_qcf.qcf34
            LET l_qcf.qcf41 = l_qcf.qcf35
   END CASE 
   LET l_qcf.qcforiu = g_user      #No.FUN-980030 10/01/04
   LET l_qcf.qcforig = g_grup      #No.FUN-980030 10/01/04
   #FUN-BB0085-add-str--
   LET l_qcf.qcf06 = s_digqty(l_qcf.qcf06,l_ima55)
   LET l_qcf.qcf091= s_digqty(l_qcf.qcf091,l_ima55)
   LET l_qcf.qcf22 = s_digqty(l_qcf.qcf22,l_ima55)  
   LET l_qcf.qcf32 = s_digqty(l_qcf.qcf32,l_qcf.qcf30)
   LET l_qcf.qcf35 = s_digqty(l_qcf.qcf35,l_qcf.qcf33)
   LET l_qcf.qcf38 = s_digqty(l_qcf.qcf38,l_qcf.qcf36)
   LET l_qcf.qcf41 = s_digqty(l_qcf.qcf41,l_qcf.qcf39)
   #FUN-BB0085-add-end--
   INSERT INTO qcf_file VALUES (l_qcf.*)
   IF SQLCA.sqlcode THEN
      CALL cl_err('ins qcf',STATUS,1)
      LET g_success='N'
   END IF
   IF g_success='Y' THEN
         CALL t700_t410_g_b(l_qcf.*)
      UPDATE shb_file SET shb22 = l_qcf.qcf01
       WHERE shb01 = l_shb.shb01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err('upd shb22',SQLCA.sqlcode,1)    
         LET g_success='N'
      ELSE
      	 LET g_shb.shb22 = l_qcf.qcf01
      	 DISPLAY BY NAME g_shb.shb22     
      END IF
   END IF  
END FUNCTION
 
FUNCTION t700_t410_defqty(l_def,l_rate,l_qcf)
   DEFINE l_def     LIKE type_file.num5,    #   1:單頭入 2.單身入 
          l_rate    LIKE qcd_file.qcd04,
          l_qcb04   LIKE qcb_file.qcb04
   DEFINE l_pmh09   LIKE pmh_file.pmh09,
          l_pmh15   LIKE pmh_file.pmh15,
          l_pmh16   LIKE pmh_file.pmh16,
          l_qca03   LIKE qca_file.qca03,
          l_qca04   LIKE qca_file.qca04,
          l_qca05   LIKE qca_file.qca05,
          l_qca06   LIKE qca_file.qca06
   DEFINE l_qcf     RECORD LIKE qcf_file.*
 
   SELECT ima100,ima101,ima102
     INTO l_pmh09,l_pmh15,l_pmh16
     FROM ima_file
    WHERE ima01 = l_qcf.qcf021
 
   IF STATUS THEN
      LET l_pmh09 = ''
      LET l_pmh15 = ''
      LET l_pmh16 = ''
      RETURN 0
   END IF
 
   IF l_pmh09 IS NULL OR l_pmh09 = ' ' THEN
      RETURN 0
   END IF
 
   IF l_pmh15 IS NULL OR l_pmh15 = ' ' THEN
      RETURN 0
   END IF
 
   IF l_pmh16 IS NULL OR l_pmh16 = ' ' THEN
      RETURN 0
   END IF
 
   IF l_pmh15 = '1' THEN
     IF l_def = '1' THEN
         SELECT qca03,qca04,qca05,qca06
           INTO l_qca03,l_qca04,l_qca05,l_qca06
           FROM qca_file
         #WHERE l_qcf22 BETWEEN qca01 AND qca02               #TQC-B30126
          WHERE l_qcf.qcf22 BETWEEN qca01 AND qca02           #TQC-B30126 
            AND qca07 = l_qcf.qcf17
         IF STATUS THEN
            RETURN 0
         END IF
      ELSE
         SELECT qcb04 INTO l_qcb04 FROM qcb_file,qca_file
         #WHERE (l_qcf22 BETWEEN qca01 AND qca02)             #TQC-B30126    
          WHERE (l_qcf.qcf22 BETWEEN qca01 AND qca02)         #TQC-B30126
            AND qcb02 = l_rate
            AND qca03 = qcb03
            AND qca07 = l_qcf.qcf17
            AND qcb01 = l_qcf.qcf21
         IF NOT cl_null(l_qcb04) THEN
            SELECT UNIQUE qca03,qca04,qca05,qca06  
              INTO l_qca03,l_qca04,l_qca05,l_qca06
              FROM qca_file
             WHERE qca03 = l_qcb04
               AND qca07 = l_qcf.qcf17
            IF STATUS THEN
               LET l_qca03 = 0
               LET l_qca04 = 0
               LET l_qca05 = 0
               LET l_qca06 = 0
            END IF
          END IF
      END IF
   END IF
 
   IF l_pmh15='2' THEN
      IF l_def = '1' THEN
         SELECT qch03,qch04,qch05,qch06
           INTO l_qca03,l_qca04,l_qca05,l_qca06
           FROM qch_file
         #WHERE l_qcf22 BETWEEN qch01 AND qch02         #TQC-B30126 
          WHERE l_qcf.qcf22 BETWEEN qch01 AND qch02     #TQC-B30126 
            AND qch07 = l_qcf.qcf17
         IF STATUS THEN
            RETURN 0
         END IF
      ELSE
         SELECT qcb04 INTO l_qcb04 FROM qcb_file,qch_file
         #WHERE (l_qcf22 BETWEEN qch01 AND qch02)      #TQC-B30126    
          WHERE (l_qcf.qcf22 BETWEEN qch01 AND qch02)      #TQC-B30126    
            AND qcb02 = l_rate
            AND qch03 = qcb03
            AND qch07 = l_qcf.qcf17
            AND qcb01 = l_qcf.qcf21
      
        IF NOT cl_null(l_qcb04) THEN
            SELECT UNIQUE qch03,qch04,qch05,qch06       
              INTO l_qca03,l_qca04,l_qca05,l_qca06
              FROM qch_file
             WHERE qch03 = l_qcb04
               AND qch07 = l_qcf.qcf17
            IF STATUS THEN
               LET l_qca03 = 0
               LET l_qca04 = 0
               LET l_qca05 = 0
               LET l_qca06 = 0
            END IF
          END IF
      END IF
   END IF
 
   CASE l_pmh09
      WHEN 'N'
         RETURN l_qca04
      WHEN 'T'
         RETURN l_qca05
      WHEN 'R'
         RETURN l_qca06
      OTHERWISE
         RETURN 0
   END CASE
END FUNCTION
 
FUNCTION t700_t410_g_b(l_qcf)
   DEFINE l_qcf    RECORD LIKE qcf_file.*
   DEFINE l_cnt    LIKE type_file.num5              
   DEFINE l_yn     LIKE type_file.num5             
   DEFINE l_qcd    RECORD LIKE qcd_file.*
   DEFINE l_qcg11  LIKE qcg_file.qcg11
   DEFINE seq      LIKE type_file.num5              
   DEFINE l_ac_num,l_re_num  LIKE type_file.num5    
 
   LET seq=1
 
   SELECT COUNT(*) INTO l_cnt FROM qcg_file
    WHERE qcg01 = l_qcf.qcf01
 
   IF l_cnt = 0 THEN     
      SELECT COUNT(*) INTO l_yn FROM qcd_file
       WHERE qcd01=l_qcf.qcf021
         AND qcd08 IN ('2','9')            
      IF l_yn > 0 THEN  #--- 料件檢驗項目
         DECLARE qcd_cur2 CURSOR FOR SELECT * FROM qcd_file
                                     WHERE qcd01 = l_qcf.qcf021
                                       AND qcd08 IN ('2','9')            
                                     ORDER BY qcd02
 
         FOREACH qcd_cur2 INTO l_qcd.*
            IF l_qcd.qcd05='1' THEN
               #-------- Ac,Re 數量賦予
               CALL s_newaql(l_qcf.qcf021,' ',l_qcd.qcd04,l_qcf.qcf22,' ','1')  
                        RETURNING l_ac_num,l_re_num
               CALL t700_t410_defqty(2,l_qcd.qcd04,l_qcf.*)
                    RETURNING l_qcg11
            ELSE
               LET l_ac_num=0 LET l_re_num=1
               SELECT qcj05 INTO l_qcg11
                 FROM qcj_file
                WHERE (l_qcf.qcf22 BETWEEN qcj01 AND qcj02)
                  AND qcj03 = l_qcd.qcd04
               IF STATUS THEN
                  LET l_qcg11 = 0
               END IF
            END IF
 
            IF l_qcg11 > l_qcf.qcf22 THEN
               LET l_qcg11 = l_qcf.qcf22
            END IF
 
            IF cl_null(l_qcg11) THEN
               LET l_qcg11 = 0
            END IF
 
            INSERT INTO qcg_file (qcg01,qcg03,qcg04,qcg05,qcg06,qcg07, 
                                  qcg08,qcg09,qcg10,qcg11,qcg12,qcg131,qcg132,
                                  qcgplant,qcglegal) #FUN-980008 add
                 VALUES(l_qcf.qcf01,seq,l_qcd.qcd02,l_qcd.qcd03,l_qcd.qcd04,
                        0,'1',l_ac_num,l_re_num,l_qcg11,l_qcd.qcd05,
                        l_qcd.qcd061,l_qcd.qcd062,
                        g_plant,g_legal) #FUN-980008 add
            LET seq=seq+1
         END FOREACH
      ELSE            #--- 材料類別檢驗項目
         DECLARE qck_cur2 CURSOR FOR SELECT qck_file.*
                                      FROM qck_file,ima_file
                                     WHERE qck01 = ima109
                                       AND ima01 = l_qcf.qcf021
                                       AND qck08 IN ('2','9')             
                                     ORDER BY qck02
 
         FOREACH qck_cur2 INTO l_qcd.*
            IF l_qcd.qcd05='1' THEN
               #-------- Ac,Re 數量賦予
               CALL s_newaql(l_qcf.qcf021,' ',l_qcd.qcd04,l_qcf.qcf22,' ','1')  
                    RETURNING l_ac_num,l_re_num
               CALL t700_t410_defqty(2,l_qcd.qcd04,l_qcf.*)
                    RETURNING l_qcg11
            ELSE
               LET l_ac_num=0 LET l_re_num=1
               SELECT qcj05 INTO l_qcg11
                 FROM qcj_file
                WHERE (l_qcf.qcf22 BETWEEN qcj01 AND qcj02)
                  AND qcj03=l_qcd.qcd04
               IF STATUS THEN LET l_qcg11=0 END IF
            END IF
 
            IF l_qcg11 > l_qcf.qcf22 THEN
               LET l_qcg11 = l_qcf.qcf22
            END IF
 
            IF cl_null(l_qcg11) THEN
               LET l_qcg11 = 0
            END IF
 
            INSERT INTO qcg_file (qcg01,qcg03,qcg04,qcg05,qcg06,qcg07, 
                                  qcg08,qcg09,qcg10,qcg11,qcg12,qcg131,qcg132,
                                  qcgplant,qcglegal) #FUN-980008 add
                 VALUES(l_qcf.qcf01,seq,l_qcd.qcd02,l_qcd.qcd03,l_qcd.qcd04,
                        0,'1',l_ac_num,l_re_num,l_qcg11,l_qcd.qcd05,
                        l_qcd.qcd061,l_qcd.qcd062,
                        g_plant,g_legal) #FUN-980008 add
 
            LET seq = seq+1
         END FOREACH
      END IF
   END IF
 
END FUNCTION

#FUN-A50066--begin--add--------

FUNCTION t700_chk_shb12()
DEFINE l_sfb93   LIKE sfb_file.sfb93

  LET l_sfb93 = ''
  SELECT sfb93 INTO l_sfb93 FROM sfb_file WHERE sfb01=g_shb.shb05
  LET g_success='Y'
  IF g_sma.sma541 ='Y' AND l_sfb93='Y' THEN
     IF NOT cl_null(g_shb.shb121) AND NOT cl_null(g_shb.shb12) THEN
        IF g_shb.shb121=g_shb.shb012 AND  
           g_shb.shb12=g_shb.shb06 THEN
           CALL cl_err(g_shb.shb12,'aec-086',0)
           LET g_success='N' RETURN
        END IF
        ## 檢查是否有此下製程
        SELECT count(*) INTO g_cnt FROM ecm_file
         WHERE ecm01 = g_shb.shb05
           AND ecm03 = g_shb.shb12
           AND ecm012 = g_shb.shb121
        IF g_cnt = 0  THEN
           CALL cl_err(g_shb.shb12,'aec-085',0)
           LET g_shb.shb12 = g_shb_t.shb12
           DISPLAY BY NAME g_shb.shb12
           LET g_success='N' RETURN
        END IF
     END IF
 ELSE
    IF NOT cl_null(g_shb.shb12) THEN
       IF g_shb.shb12=g_shb.shb06 THEN
           CALL cl_err(g_shb.shb12,'aec-086',0)
           LET g_success='N' RETURN
        END IF
        ## 檢查是否有此下製程
        SELECT count(*) INTO g_cnt FROM ecm_file
         WHERE ecm01 = g_shb.shb05
           AND ecm03 = g_shb.shb12
           AND ecm012 =' '  
        IF g_cnt = 0  THEN
           CALL cl_err(g_shb.shb12,'aec-085',0)
           LET g_shb.shb12 = g_shb_t.shb12
           DISPLAY BY NAME g_shb.shb12
           LET g_success='N' RETURN
        END IF
    END IF
END IF
END FUNCTION

FUNCTION t700_shb012(p_cmd)  
    DEFINE l_ecu014    LIKE ecu_file.ecu014,
           l_ecuacti   LIKE ecu_file.ecuacti,
           l_sfb06     LIKE sfb_file.sfb06,
           p_cmd       LIKE type_file.chr1   
    DEFINE l_flag      LIKE type_file.num5   #MOD-AC0336
    DEFINE l_sfb05     LIKE sfb_file.sfb05  #MOD-AC0336   
 
    LET g_errno = ' '
    SELECT sfb06 INTO l_sfb06 FROM sfb_file WHERE sfb01=g_shb.shb05
    CALL s_schdat_sel_ima571(g_shb.shb05) RETURNING l_flag,l_sfb05  #MOD-AC0336
    LET l_ecu014=''  LET l_ecuacti=''
   #FUN-B10056 ----------mod   start-------- 
   #SELECT ecu014,ecuacti INTO l_ecu014,l_ecuacti
   # #FROM ecu_file WHERE ecu01 = g_shb.shb10  #MOD-AC0336 
   #  FROM ecu_file WHERE ecu01 = l_sfb05      #MOD-AC0336
   #   AND ecu012=g_shb.shb012 AND ecu02=l_sfb06
   #                
   #
   #CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'abm-214'
   #                        LET l_ecu014 = NULL
   #     WHEN l_ecuacti='N' LET g_errno = '9028'
   #     OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   #END CASE
    IF NOT s_schdat_ecm012(g_shb.shb05,g_shb.shb012) THEN
       LET g_errno = 'abm-214'
       LET l_ecu014 = NULL
    END IF 
   #FUN-B10056 ----------mod end---------------
    
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       CALL s_schdat_ecm014(g_shb.shb05,g_shb.shb012) RETURNING l_ecu014    #FUN-B10056
       DISPLAY l_ecu014 TO FORMONLY.ecu014
    END IF

END FUNCTION

FUNCTION t700_shb082(p_cmd)  
   DEFINE l_ecu014      LIKE ecu_file.ecu014,
          l_ecuacti     LIKE ecu_file.ecuacti,
          l_sfb06       LIKE sfb_file.sfb06,
          p_cmd         LIKE type_file.chr1
   IF NOT cl_null(g_shb.shb012) AND NOT cl_null(g_shb.shb06) THEN
      SELECT ecm04,ecm45
        INTO g_shb.shb081,g_shb.shb082 FROM ecm_file
       WHERE ecm01=g_shb.shb05
         AND ecm03=g_shb.shb06
         AND ecm012=g_shb.shb012
       CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aec-099'
                                      LET g_shb.shb081 = NULL
                                      LET g_shb.shb082 = NULL
            OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
       END CASE
       IF cl_null(g_errno) OR p_cmd = 'd' THEN
          DISPLAY BY NAME g_shb.shb081
          DISPLAY BY NAME g_shb.shb082
       END IF
   END IF
END FUNCTION


FUNCTION t700_shc06()
    LET g_errno = ''
    IF NOT cl_null(g_shc[l_ac].shc06) AND g_shc[l_ac].shc012 IS NOT NULL THEN
       SELECT ecm04 INTO g_shc[l_ac].ecm04 FROM ecm_file
        WHERE ecm01=g_shb.shb05 AND ecm03 = g_shc[l_ac].shc06
          AND ecm012=g_shc[l_ac].shc012  #FUN-A50066
       IF SQLCA.SQLCODE THEN
          LET g_errno = SQLCA.SQLCODE USING '-------'
          RETURN
       END IF
      #MOD-D60240 add begin-------------------
       IF g_sma.sma541 = 'N' THEN
          IF g_shc[l_ac].shc06 > g_shb.shb06 THEN
             LET g_errno = 'asf1052'
             RETURN       
          END IF 
       ELSE
          IF g_shc[l_ac].shc012 = g_shb.shb012 THEN
             IF g_shc[l_ac].shc06 > g_shb.shb06 THEN
                LET g_errno = 'asf1052'
                RETURN       
             END IF 
          ELSE  
             IF NOT t700_shc012(g_shb.shb012) THEN 
                LET g_errno = 'asf1053'
                RETURN
             END IF 
          END IF 
       END IF 
      #MOD-D60240 add end---------------------
    END IF
END FUNCTION

#MOD-D60240 add begin-------------------
FUNCTION t700_shc012(p_ecm012)
DEFINE p_ecm012 LIKE ecm_file.ecm012
DEFINE l_ecm011 LIKE ecm_file.ecm011
DEFINE l_flag   BOOLEAN
   SELECT UNIQUE ecm011 INTO l_ecm011 FROM ecm_file
    WHERE ecm01=g_shb.shb05 AND ecm012=p_ecm012
   IF cl_null(l_ecm011) THEN 
      RETURN 0 
   ELSE 
      IF l_ecm011 = g_shc[l_ac].shc012 THEN
         RETURN 1 
      ELSE
         CALL t700_shc012(l_ecm011) RETURNING l_flag
      END IF 
   END IF 
   RETURN l_flag
END FUNCTION
#MOD-D60240 add end--------------------- 

FUNCTION t700_shb111_a()
DEFINE l_ima153     LIKE ima_file.ima153
DEFINE l_ecm62      LIKE ecm_file.ecm62  #TQC-B20083
DEFINE l_ecm63      LIKE ecm_file.ecm63  #TQC-B20083
DEFINE l_ecm315     LIKE ecm_file.ecm315   #CHI-BA0035 add
DEFINE l_n          LIKE type_file.num5  #MOD-CA0066 add 
DEFINE l_sfb93      LIKE sfb_file.sfb93  #MOD-CA0066 add 

    LET g_success = 'Y'
    IF cl_null(g_shb.shb012) THEN LET g_shb.shb012=' ' END IF #FUN-A60095
    CALL s_get_ima153(g_shb.shb10) RETURNING l_ima153 
   #CALL s_minp(g_shb.shb05,g_sma.sma73,l_ima153,g_shb.shb081,g_shb.shb012,g_shb.shb06)  #TQC-B20083
   #CALL s_minp_routing(g_shb.shb05,g_sma.sma73,l_ima153,g_shb.shb081,g_shb.shb012,g_shb.shb06)  #TQC-B20083  #MOD-D60073 mark
    CALL s_minp(g_shb.shb05,'Y',l_ima153,g_shb.shb081,g_shb.shb012,g_shb.shb06,'')  #MOD-D60073 add
    RETURNING g_cnt,g_min_set
    IF g_cnt !=0  THEN
       CALL cl_err(g_shb.shb05,'asf-549',1)
       LET g_success='N' RETURN
    END IF
    #TQC-B20083(S)
    SELECT ecm62,ecm63 INTO l_ecm62,l_ecm63 FROM ecm_file
     WHERE ecm01=g_shb.shb05 AND ecm03=g_shb.shb06
       AND ecm012=g_shb.shb012
    IF cl_null(l_ecm62) OR l_ecm62=0 THEN
       LET l_ecm62=1
    END IF
    IF cl_null(l_ecm63) OR l_ecm63=0 THEN
       LET l_ecm63=1
    END IF
    #CHI-BA0035 -- begin --
    SELECT SUM(ecm315) INTO l_ecm315 FROM ecm_file
     WHERE ecm01 = g_shb.shb05
    IF cl_null(l_ecm315) OR l_ecm315 = 0 THEN
       LET l_ecm315 = 0
    END IF 
    #CHI-BA0035 -- end --
    #MOD-CA0066 add begin----------------
    LET l_n = 0
    SELECT sfb93 INTO l_sfb93 FROM sfb_file     
     WHERE sfb01 = g_shb.shb05
    IF g_sma.sma541 = 'Y' AND l_sfb93 = 'Y' THEN
       SELECT COUNT(*) INTO l_n FROM sfa_file
        WHERE sfa01=g_shb.shb05
          AND sfa012=g_shb.shb012
          AND sfa013=g_shb.shb06
          AND sfa05>0
    ELSE
       SELECT COUNT(*) INTO l_n FROM sfa_file
        WHERE sfa01=g_shb.shb05
          AND sfa08=g_shb.shb081
          AND sfa05>0
    END IF
    #MOD-CA0066 add end-----------------
    #TQC-B20083(E)
   #IF g_shb.shb111 > g_min_set THEN   #TQC-B20083
   #IF g_shb.shb111 > g_min_set*l_ecm62/l_ecm63 THEN #TQC-B20083  #MOD-CA0066 mark
   #IF g_shb.shb111 > g_min_set*l_ecm62/l_ecm63 AND l_n>0 THEN    #MOD-CA0066 add l_n>0    #CHI-BA0035 mark
    IF g_shb.shb111 > (g_min_set*l_ecm62/l_ecm63) + l_ecm315 AND l_n>0 THEN                #CHI-BA0035
       CALL cl_err(g_shb.shb05,'asf-670',1)
       LET g_success='N' RETURN
    END IF
END FUNCTION

#FUN-A50066--end--add--------
#NO.FUN-9C0072 精簡程式碼

#TQC-AC0294-------start------------
FUNCTION t700_shb21()      
   DEFINE l_smy73   LIKE smy_file.smy73
 
   LET g_errno = ' '
   IF cl_null(g_t2) THEN RETURN END IF
    
   SELECT smy73 INTO l_smy73 FROM smy_file
    WHERE smyslip = g_t2
   IF l_smy73 = 'Y' THEN
      LET g_errno = 'asf-876'
   END IF

END FUNCTION
#TQC-AC0294--------end----------------

#FUN-A70095 -------------Begin-------------
FUNCTION t700_shd_shj_chk(p_shb01)
DEFINE l_cnt   LIKE type_file.num5
DEFINE p_shb01 LIKE shb_file.shb01
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt FROM shd_file
    WHERE shd01=p_shb01
   IF l_cnt>0 THEN
      CALL cl_err('','asf-225',0)
      LET g_success='N'
      RETURN
   END IF
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt FROM shj_file
    WHERE shj01=p_shb01
   IF l_cnt>0 THEN
      CALL cl_err('','asf-226',0)
      LET g_success='N'
      RETURN
   END IF
END FUNCTION
#FUN-A70095 -------------End---------------
#FUN-B50046
#CHI-C50054 str add-----
FUNCTION t700_chk_rvv17()
DEFINE l_sum      LIKE type_file.num5
DEFINE l_factor   LIKE type_file.num5
DEFINE l_rvv17    LIKE rvv_file.rvv17
DEFINE l_rvv35    LIKE rvv_file.rvv35
DEFINE l_ecm58    LIKE ecm_file.ecm58

   SELECT ecm58 INTO l_ecm58                
     FROM ecm_file
    WHERE ecm01=g_shb.shb05
      AND ecm03=g_shb.shb06

   SELECT shb111+shb112+shb113+shb114 INTO l_sum
     FROM shb_file
    WHERE shb14=g_shb.shb14
      AND shb15=g_shb.shb15
      AND shb01<>g_shb.shb01
      AND shbconf<>'X'         #MOD-CA0149 add

   SELECT rvv17,rvv35 INTO l_rvv17,l_rvv35
     FROM rvv_file
    WHERE rvv01=g_shb.shb14
      AND rvv02=g_shb.shb15

   CALL s_umfchk(g_shb.shb10,l_rvv35,l_ecm58) RETURNING g_sw,l_factor
   IF cl_null(l_factor) THEN LET l_factor=1 END IF
   LET l_rvv17 = l_rvv17 * l_factor
   LET l_sum = l_sum + g_shb.shb111 + g_shb.shb112 + g_shb.shb113 + g_shb.shb114 + g_shb.shb17
   IF l_sum > l_rvv17 THEN
      CALL cl_err('','asf-859',1)
      RETURN -1
   END IF
   RETURN 0
END FUNCTION
#CHI-C50054 end add-----

#FUN-CB0014---add---str---
FUNCTION t700_list_fill()
  DEFINE l_shb01         LIKE shb_file.shb01 
  DEFINE l_i             LIKE type_file.num10

    CALL g_shb_l.clear()
    LET l_i = 1
    FOREACH t700_fill_cs INTO l_shb01
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach item_cur',SQLCA.sqlcode,1)
          CONTINUE FOREACH
       END IF
       SELECT shb01,shb04,gen02,shb05,shb081,shb082,shb012,'',shb06,shbconf, #TQC-CB0084 add shb012,''
              shb10,ima02,ima021,shb111,shb34,shb21,shb22
         INTO g_shb_l[l_i].*
         FROM shb_file
              LEFT OUTER JOIN gen_file ON shb04 = gen01
              LEFT OUTER JOIN ima_file ON shb10 = ima01
        WHERE shb01=l_shb01
       #TQC-CB0084 add str
       IF g_sma.sma541 ='Y' THEN  
          CALL s_schdat_ecm014(g_shb_l[l_i].shb05,g_shb_l[l_i].shb012) RETURNING g_shb_l[l_i].ecu014 
       END IF 
       #TQC-CB0084 add end
       LET l_i = l_i + 1
       IF l_i > g_max_rec THEN
          IF g_action_choice ="query"  THEN  
            CALL cl_err( '', 9035, 0 )
          END IF                             
          EXIT FOREACH
       END IF
    END FOREACH
    LET g_rec_b2 = l_i - 1
    DISPLAY ARRAY g_shb_l TO s_shb_l.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
       BEFORE DISPLAY
          EXIT DISPLAY
    END DISPLAY

END FUNCTION

FUNCTION t700_bp3(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
 
   IF p_ud <> "G"  THEN
      RETURN
   END IF
 
   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_shb_l TO s_shb_l.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
       BEFORE DISPLAY
         CALL fgl_set_arr_curr(g_curs_index) 
         CALL cl_navigator_setting( g_curs_index, g_row_count )
  
       BEFORE ROW
         LET l_ac2 = ARR_CURR()
         LET g_curs_index = l_ac2
         CALL cl_show_fld_cont()
     ON ACTION page_main
         LET g_action_flag = "page_main"
         LET l_ac2 = ARR_CURR()
         LET g_jump = l_ac2
         LET mi_no_ask = TRUE
         IF g_rec_b2 > 0 THEN
             CALL t700_fetch('/')
         END IF
         CALL cl_set_comp_visible("info,page_list", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("info,page_list", TRUE)
         EXIT DISPLAY

      ON ACTION ACCEPT
         LET g_action_flag = "page_main"
         LET l_ac2 = ARR_CURR()
         LET g_jump = l_ac2
         LET mi_no_ask = TRUE
         CALL t700_fetch('/')
         CALL cl_set_comp_visible("info,page_list", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("info,page_list", TRUE) 
         EXIT DISPLAY 

      ON ACTION controls                                                                                    
       CALL cl_set_head_visible("","AUTO")                                                          
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
#FUN-A70095 ----------Begin------------
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
#FUN-A70095 ----------End--------------
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION first
         CALL t700_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL t700_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL t700_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL t700_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL t700_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST

#TQC-D10084---mark---str--- 
#     ON ACTION detail
#        LET g_action_choice="detail"
#        LET l_ac = 1
#        EXIT DISPLAY
#TQC-D10084---mark---end---
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CALL t700_def_form()   #TQC-890064 add
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
#FUN-A70095 ----------------Begin--------------------
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY  
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #CHI-D20010---begin
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #CHI-D20010---end
#FUN-A70095 ----------------End----------------------
#@    ON ACTION 委外報工輸入
      ON ACTION input_sub_report
         LET g_action_choice="input_sub_report"
         EXIT DISPLAY
#@    ON ACTION 當站入庫
      ON ACTION direct_st_in
         LET g_action_choice="direct_st_in"
         EXIT DISPLAY
#@    ON ACTION 轉稼工時維護
      ON ACTION shift_working_hours
         LET g_action_choice="shift_working_hours"
         EXIT DISPLAY
#@    ON ACTION 工單製程數量狀態查詢
      ON ACTION wo_routing_qt_status
         LET g_action_choice="wo_routing_qt_status"
         EXIT DISPLAY
#@    ON ACTION 工單轉出維護
      ON ACTION wo_tr_o
         LET g_action_choice="wo_tr_o"
         EXIT DISPLAY
#@    ON ACTION 工單轉出查詢
      ON ACTION wo_tr_o_qry
         LET g_action_choice="wo_tr_o_qry"
         EXIT DISPLAY
 
      ON ACTION fast_input
         LET g_action_choice = "fast_input"
         EXIT DISPLAY 
 
      ON ACTION fqc2
         LET g_action_choice = "fqc2"
         EXIT DISPLAY 
         
      ON ACTION trans_fqc
         LET g_action_choice = "trans_fqc"   
         EXIT DISPLAY 
         
      ON ACTION trans_store
         LET g_action_choice = "trans_store"
         EXIT DISPLAY    
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      ON ACTION related_document                #No.FUN-6A0164  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY

      #DEV-D30045--add--begin
      ON ACTION barcode_gen
         LET g_action_choice="barcode_gen"
         EXIT DISPLAY

      ON ACTION barcode_query
         LET g_action_choice="barcode_query"
         EXIT DISPLAY

      ON ACTION barcode_output
         LET g_action_choice="barcode_output"
         EXIT DISPLAY
      #DEV-D30045--add--end
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)    
END FUNCTION

#FUN-CB0014---add---end---

#FUN-CB0087--add--str--
FUNCTION t700_chk_azf()
DEFINE l_flag        LIKE type_file.chr1
DEFINE l_where       STRING
DEFINE l_sql         STRING
DEFINE l_n           LIKE type_file.num5
DEFINE l_shd  RECORD LIKE shd_file.*

   SELECT COUNT(*) INTO l_n FROM shd_file WHERE shd01=g_shb.shb01
   IF l_n = 0 THEN RETURN TRUE END IF
   IF g_aza.aza115='Y' THEN
      DECLARE shd_chk_cs CURSOR FOR  SELECT * FROM shd_file
                                     WHERE shd01=g_shb.shb01 
                                       AND trim(shd18) IS NOT NULL
      FOREACH shd_chk_cs INTO l_shd.*
         CALL s_get_where(g_shb.shb01,g_shb.shb05,'',l_shd.shd06,l_shd.shd03,g_shb.shb04,'') RETURNING l_flag,l_where
         IF l_flag THEN
            LET l_n = 0
            LET l_sql = " SELECT COUNT(*) FROM ggc_file WHERE ggc08='",l_shd.shd18,"' AND ",l_where
            PREPARE ggc08_pre1 FROM l_sql
            EXECUTE ggc08_pre1 INTO l_n
            IF l_n < 1 THEN
               CALL cl_err('','aim-425',1)
               RETURN FALSE
            END IF
         END IF
      END FOREACH
   END IF
   RETURN TRUE

END FUNCTION 
#FUN-CB0087--add--end--
#MOD-D30233---begin
FUNCTION t700_chk_input()
   DEFINE l_bonus_2   LIKE shb_file.shb115,
          l_ecm311_2  LIKE ecm_file.ecm311,
          l_sum_qty_2 LIKE qcm_file.qcm091, 
          l_sum_qty_3 LIKE qcm_file.qcm091,
          l_ima153    LIKE ima_file.ima153,
          l_min_set   LIKE sfb_file.sfb08,
          l_wip_qty_2 LIKE shb_file.shb111,  
          l_cnt       LIKE type_file.num5

       IF g_sma.sma541 = 'Y' THEN RETURN 0 END IF   #MOD-D30233
       LET l_cnt=0  LET l_min_set=0
       CALL s_get_ima153(g_shb.shb10) RETURNING l_ima153
     # CALL s_minp_routing(g_shb.shb05,g_sma.sma73,0,g_shb.shb081,g_shb.shb012,g_shb.shb06)   #MOD-D60073 mark
       CALL s_minp(g_shb.shb05,'Y',l_ima153,g_shb.shb081,g_shb.shb012,g_shb.shb06,'') #MOD-D60073 add 
            RETURNING l_cnt,l_min_set

      #最後站(已確認)良品轉出
       SELECT SUM(ecm311) INTO l_ecm311_2 FROM ecm_file
        WHERE ecm01 = g_shb.shb05
          AND ecm03 IN (SELECT MAX(ecm03) FROM ecm_file
                         WHERE ecm01 = g_shb.shb05)
       IF cl_null(l_ecm311_2) THEN LET l_ecm311_2 = 0 END IF   #MOD-D30233
      #全部(已確認)當站轉出(不考慮重工轉出shb113)
       SELECT SUM(ecm313+ecm314+ecm316) INTO l_sum_qty_2 FROM ecm_file
        WHERE ecm01 = g_shb.shb05
       IF cl_null(l_sum_qty_2) THEN LET l_sum_qty_2 = 0 END IF  #MOD-D30233
      #Bonus (不包含最後一站)
       SELECT SUM(ecm315) INTO l_bonus_2 FROM ecm_file
        WHERE ecm01  = g_shb.shb05
          AND ecm03 !=(SELECT MAX(ecm03) FROM ecm_file
                        WHERE ecm01 =g_shb.shb05)
       IF cl_null(l_bonus_2) THEN LET l_bonus_2 = 0 END IF  #MOD-D30233
      #本次轉出數量
       LET l_wip_qty_2 = g_shb.shb111 +g_shb.shb112 +g_shb.shb114 +g_shb.shb17

       LET l_sum_qty_3 = l_min_set -(l_ecm311_2 +l_sum_qty_2 -l_bonus_2)
       IF l_wip_qty_2 > l_sum_qty_3 THEN
          CALL cl_err('','aws-721',1)
          LET g_success='N'
          RETURN -1
       END IF
       RETURN 0
END FUNCTION
#MOD-D30233---end


#DEV-D30045--add--begin
FUNCTION t700_barcode_out()
   DEFINE l_cmd       STRING

   IF g_shb.shb01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   LET g_msg = ' ibb03="',g_shb.shb01 CLIPPED,'"'
   LET l_cmd = "abar100",
               " '",g_today CLIPPED,"' ''",
               " '",g_lang CLIPPED,"' 'Y' '' '1'",
               " '' '' '' '' ",
               " '",g_msg CLIPPED,"' ",
               " ' ' 'D' '",s_gen_barcode_ibd07(),"'"
   CALL cl_cmdrun_wait(l_cmd)
END FUNCTION


FUNCTION t700_barcode_gen(p_shb01,p_ask)
   DEFINE p_shb01   LIKE shb_file.shb01
   DEFINE p_ask     LIKE type_file.chr1
   DEFINE l_shb     RECORD LIKE shb_file.*
   DEFINE l_inb03   LIKE inb_file.inb03
   DEFINE l_inb04   LIKE inb_file.inb04
   DEFINE l_inb09   LIKE inb_file.inb09
   DEFINE l_ima930  LIKE ima_file.ima930
   DEFINE l_ima932  LIKE ima_file.ima932
   DEFINE l_ima918  LIKE ima_file.ima918
   DEFINE l_ima919  LIKE ima_file.ima919
   DEFINE l_ima921  LIKE ima_file.ima921
   DEFINE l_ima922  LIKE ima_file.ima922
   DEFINE l_ima931  LIKE ima_file.ima931
   DEFINE l_count   LIKE type_file.num5
   DEFINE l_n       LIKE type_file.num5
   DEFINE l_sql     STRING

   IF cl_null(p_shb01) THEN
      CALL cl_err('',-400,0)
      LET g_success = 'N'
      RETURN
   END IF

   SELECT * INTO l_shb.* FROM shb_file WHERE shb01 = p_shb01

   #檢查是否符合產生時機點
   IF NOT s_gen_barcode_chktype('D',l_shb.shb01,'','') THEN
      RETURN
   END IF

   IF l_shb.shbacti = 'N' THEN
      CALL cl_err('',9027,0)
      LET g_success = 'N'
      RETURN
   END IF

   IF l_shb.shb14 = 'N' THEN
      CALL cl_err('','sfb-999',0)
      LET g_success = 'N'
      RETURN
   END IF

   IF l_shb.shb14 = 'X' THEN
      CALL cl_err('','sfb-998',0)
      LET g_success = 'N'
      RETURN
   END IF

   IF NOT s_tlfb_chk(l_shb.shb01) THEN
      LET g_success = 'N'
      RETURN
   END IF

   IF p_ask = 'Y' THEN
      IF NOT cl_confirm('azz1276') THEN
         LET g_success='N'
         RETURN
      END IF
   END IF

   LET g_success = 'Y'
   CALL s_showmsg_init()
   BEGIN WORK

   OPEN t700_cl USING l_shb.shb01
   IF STATUS THEN
      CALL cl_err("OPEN t700_cl:", STATUS, 1)
      LET g_success = 'N'
      CLOSE t700_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t700_cl INTO l_shb.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(l_shb.shb01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      LET g_success = 'N'
      CLOSE t700_cl
      ROLLBACK WORK
      RETURN
   END IF

   #DEV-D30043--mark--begin
   #IF NOT s_diy_barcode(l_shb.shb01,'','','D') THEN
   #   LET g_success = 'N'
   #END IF
   #
   #IF g_success = 'Y' THEN
   #   CALL s_gen_barcode2('D',l_shb.shb01,'','')
   #END IF
   #DEV-D30043--mark--end

   #DEV-D30043--add--begin
   IF g_success = 'Y' THEN
      CALL s_gen_barcode2('D',l_shb.shb01,'','')
   END IF

   IF g_success = 'Y' THEN
      IF NOT s_diy_barcode(l_shb.shb01,'','','D') THEN
         LET g_success = 'N'
      END IF
   END IF
   #DEV-D30043--add--end

   CALL s_showmsg()
   IF g_success='Y' THEN
      COMMIT WORK
      CALL cl_msgany(0,0,'aba-001')
   ELSE
      ROLLBACK WORK
      #CALL cl_msgany(0,0,'aba-002')    #DEV-D40015--mark
      CALL cl_err('','aba-002',0)       #DEV-D40015--mod
   END IF
END FUNCTION

FUNCTION t700_barcode_z(p_shb01)
   DEFINE p_shb01   LIKE shb_file.shb01
   DEFINE l_shb     RECORD LIKE shb_file.*
   DEFINE l_inb03   LIKE inb_file.inb03
   DEFINE l_inb04   LIKE inb_file.inb04
   DEFINE l_inb09   LIKE inb_file.inb09
   DEFINE l_ima930  LIKE ima_file.ima930
   DEFINE l_ima932  LIKE ima_file.ima932
   DEFINE l_ima918  LIKE ima_file.ima918
   DEFINE l_ima919  LIKE ima_file.ima919
   DEFINE l_ima921  LIKE ima_file.ima921
   DEFINE l_ima922  LIKE ima_file.ima922
   DEFINE l_ima931  LIKE ima_file.ima931
   DEFINE l_count   LIKE type_file.num5
   DEFINE l_n       LIKE type_file.num5
   DEFINE l_sql     STRING

   IF cl_null(p_shb01) THEN
      CALL cl_err('',-400,0)
      LET g_success = 'N'
      RETURN
   END IF
   SELECT * INTO l_shb.* FROM shb_file WHERE shb01 =p_shb01

   #檢查是否符合產生時機點
   IF NOT s_gen_barcode_chktype('D',l_shb.shb01,'','') THEN
      LET g_success  = 'Y'       #DEV-D40015 add
      RETURN
   END IF

   IF g_shb.shbacti = 'N' THEN
      CALL cl_err('',9027,0)
      LET g_success = 'N'
      RETURN
   END IF

   IF NOT s_tlfb_chk2(l_shb.shb01) THEN
      LET g_success = 'N'
      RETURN
   END IF

  #LET g_success = 'Y'           #DEV-D40015 mark
  #BEGIN WORK                    #DEV-D40015 mark

   OPEN t700_cl USING l_shb.shb01
   IF STATUS THEN
      CALL cl_err("OPEN t700_cl:", STATUS, 1)
      LET g_success = 'N'
      CLOSE t700_cl
     #ROLLBACK WORK              #DEV-D40015 mark
      RETURN
   END IF
   FETCH t700_cl INTO l_shb.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(l_shb.shb01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      LET g_success = 'N'
      CLOSE t700_cl
     #ROLLBACK WORK              #DEV-D40015 mark
      RETURN
   END IF

   IF g_success='Y' THEN
      CALL s_barcode_x2('D',l_shb.shb01,'','')
   END IF

   IF g_success='Y' THEN
     #COMMIT WORK                #DEV-D40015 mark   
      CALL cl_msgany(0,0,'aba-178')
   ELSE
     #ROLLBACK WORK              #DEV-D40015 mark 
      CALL cl_msgany(0,0,'aba-179')
   END IF
END FUNCTION
#DEV-D30045--add--end
