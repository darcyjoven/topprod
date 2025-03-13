# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: axmt650.4gl
# Descriptions...: 出貨單維護作業 (無訂單出貨)
# Date & Author..: 95/08/16 By Danny
# Modify.........: 95/08/29 By Danny (其他資料選項加收款客戶)
                   # 增加自動確認&立即列印功能
# Modify.........: 01/06/18 by linda No.+182 將欄位控制與axmt620一致
# Modify.........: No:7829 03/08/18 Carol 單據程式中呼叫單據自動編號時,
#                                         應該是要包覆在 BEGIN WORK 中(transaction)
#                                         才會達到lock 的功能
# Modify.........: No.8741 03/11/28 Melody add l_flag判斷for axcp500 (多倉出貨)
# Modify.........: No.MOD-4700410 4/07/19 By Wiky  修改INSERT INTO...
# Modify.........: No.MOD-480191 4/08/06 By Wiky call q_gec少傳參數LET g_qryparam.arg1 = '2'
# Modify.........: No.MOD-480196 4/08/06 By Wiky axmt650修改列印選單,因無法on action無法轉換中文,用menu "pop"方式 show
# Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.MOD-4A0252 04/10/19 By Smapmin 增加出貨單號開窗功能
# Modify.........: No.MOD-4B0070 04/11/09 By Carrier modify occ31
# Modify.........: No.FUN-4B0038 04/11/15 By pengu ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4B0050 04/11/23 By Mandy 匯率加開窗功能
# Modify.........: No.MOD-4B0275 04/11/27 By Danny CALL q_coc2
# Modify.........: No.MOD-4B0287 04/12/06 By Carol BEFORE DISPLAY 中多了 action:gen_entry_sheet 會造成確認有問題
# Modify.........: No.FUN-4C0006 04/12/03 By Carol 單價/金額欄位放大(20),位數改為dec(20,6)
# Modify.........: No.FUN-4C0057 04/12/09 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.FUN-4C0076 04/12/15 By pengu  匯率幣別欄位修改，與aoos010的aza17做判斷，
                                                    #如果二個幣別相同時，匯率強制為 1
# Modify.........: No.MOD-510171 05/03/02 By Carrier 內銷時可以KEY手冊編號
# Modify.........: NO.FUN-530031 05/03/22 By Carol 單價/金額欄位所用的變數型態應為 dec(20,6),匯率 dec(20,10)
# Modify.........: No.FUN-550052 05/05/25 By Will 單據編號放大
# Modify.........: No.FUN-550011 05/05/31 By kim GP2.0功能 庫存單據不同期要check庫存是否為負
# Modify.........: No.FUN-560036 05/06/13 By Carrier 雙單位內容修改
# Modify.........: No.FUN-570111 05/07/27 By Elva    判斷該單據所屬月份改為判斷該單據所屬期別
# Modify.........: No.MOD-560095 05/08/04 By Nicola 修改多倉儲出庫問題
# Modify.........: No.MOD-570286 05/08/04 By Nicola 按"多倉儲批庫存明細",進入畫面t6506_w,按了確認/放棄鍵無法離開
# Modify.........: NO.MOD-580083 05/08/10 By Rosayu 文件地址裡頭的麥頭編號無法正常開窗因程式少了給 g_qryparam.arg1
# Modify.........: No.FUN-560235 05/06/30 By kim 新增單身料號時,會帶出品名及規格,要和axmt620若遇非MISC料號,不可修改品名
# Modify.........: No.MOD-590122 05/09/09 By Carrier set_origin_field修改
# Modify.........: NO.MOD-590068 05/10/22 By yiting 業務輸入不會帶出部門
# Modify.........: NO.TQC-5A0098 05/10/26 By Niocla 單據性質取位修改
# Modify.........: NO.MOD-5B0276 05/11/21 By kim 1.g_no 要改為16碼,否則列印會抓不到資料
                                                #2.出貨通知單列印和出貨單列印弄顛倒了
                                                #3.帳單號碼如果有值的話,執行"扣帳還原"時要立刻提示不可做"扣帳還原",不能讓他繼續做下面的動作
# Modify.........: NO.FUN-5B0124 05/11/23 BY Nicola 列印時，不出現出貨通知單的選項
# Modify.........: No.MOD-5B0123 05/11/30 By Nicola 隱藏無權限按鈕功能修改
# Modify.........: No.TQC-5C0014 05/12/07 By Carrier 單位一時報沒有轉換率,set_required時去除單位換算率
# Modify.........: No.FUN-610006 06/01/07 By Smapmin 雙單位畫面調整
# Modify.........: No.FUN-610076 06/01/20 By Nicola 計價單位功能改善
# Modify.........: No.FUN-610090 06/02/07 By Nicola 拆併箱功能修改
# Modify.........: No.MOD-620052 06/02/21 By pengu "其他資料" action會打不開WINDOW
# Modify.........: No.TQC-630066 06/03/07 By Kevin 流程訊息通知功能修改
# Modify.........: No.TQC-620156 06/03/10 By kim GP3.0過帳錯誤統整顯示功能新增
# Modify.........: No.TQC-630107 06/03/10 By Alexstar 單身筆數限制
# Modify.........: No.TQC-620115 06/03/28 By pengu 收款客戶移移至主畫面上
# Modify.........: No.FUN-650007 06/05/04 By Sarah 將"LET g_prog = ls_tmp","ls_tmp"mark掉
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能monster代
# Modify.........: No.TQC-610089 06/05/16 By Pengu Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-630015 06/05/25 By yiting s_rdate2改呼叫s_rdatem
# Modify.........: No.FUN-650141 06/06/13 By Sarah 新增段預設oga65=N
# Modify.........: No.TQC-660088 06/06/21 By Claire 流程訊息通知功能修改
# Modify.........: No.FUN-660167 06/06/23 By cl cl_err --> cl_err3
# Modify.........: No.MOD-660131 06/07/04 By Pengu 在程式段 AFTER DELETE 重計單頭的合計金額(oga50)
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-670063 06/07/21 By kim GP3.5 利潤中心
# Modify.........: No.FUN-670047 06/08/28 By Elva 新增多套帳功能
# Modify.........: No.FUN-680022 06/08/29 By Tracy s_rdatem()增加一個參數 
# Modify.........: No.FUN-660073 06/08/28 By Nicola 原因碼外顯可維護
# Modify.........: No.FUN-680137 06/09/15 By bnlent 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0094 06/10/30 By yjkhero l_time轉g_time
# Modify.........: No.CHI-6A0004 06/11/01 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6B0044 06/11/13 By kim GP3.5 台虹保稅客製功能回收修改
# Modify.........: No.FUN-6A0092 06/11/13 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.MOD-6B0061 06/11/16 By claire 取消訂單相關查詢action
# Modify.........: No.FUN-6A0020 06/11/21 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0117 06/11/21 By day 欄位加控管 
# Modify.........: No.TQC-6B0124 06/12/19 By pengu 參數勾選不使用多單位但使用計價單位時，計價單位與計價數量會異常
# Modify.........: No.TQC-680074 06/12/27 By Smapmin 為因應s_rdatem.4gl程式內對於dbname的處理,故LET g_dbs2=g_dbs,'.'
# Modify.........: No.FUN-6C0083 07/01/08 By Nicola 錯誤訊息彙整
# Modify.........: No.TQC-710035 07/01/10 By jamie oop_file ooq_file no use mark相關程式段
# Modify.........: No.FUN-710046 07/01/31 By bnlent 錯誤訊息彙整
# Modify.........: No.CHI-6B0027 07/02/14 By jamie oaz101改為nouse 相關程式移除
# Modify.........: No.FUN-720014 07/03/02 By rainy 客戶地址改為5欄255
# Modify.........: No.MOD-720127 07/03/05 By pengu 修改單身輸入完數量後直接確認離開單身,單身金額沒有更新到
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730018 07/03/26 By kim 行業別架構
# Modify.........: No.MOD-730121 07/03/28 By pengu 新增單身倉儲批欄位開窗查詢
# Modify.........: No.FUN-730057 07/04/04 By hongmei 會計科目加帳套
# Modify.........: No.FUN-6C0072 07/04/09 By claire 新增單身多倉儲批欄位開窗查詢
# Modify.........: No.MOD-740317 07/04/23 By Carol 按庫存扣帳/還原成功重新顯示狀況圖形
# Modify.........: No.TQC-740232 07/04/23 By Carrier 單身新增時,ogb1005/ogb1012賦初值'1','N'
# Modify.........: No.TQC-740308 07/04/26 By Rayven 查詢時“收款客戶編碼”畫面顯示為空，但檔案里是有值的
# Modify.........: No.TQC-740206 07/04/26 By kim 單身單價未受aooi050的單價小數位數限制,以致與axrt300金額不同 
# Modify.........: NO.MOD-740479 07/04/26 By claire 母子單位時，單位一數量可為0，但不可小於0
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-770039 07/07/06 By Rayven 單身錄入時,無多倉位出貨,第一次錄入庫位時,會報錯:((100)XX無此筆資料,或任何上下筆資料,或其他相關主檔資料 !XX 從img_file選擇失敗,光標第二次跳到欄位時可過
# Modify.........: No.CHI-770019 07/07/26 By Carrier 多單位:參考單位時,交易單位不寫入tlff
# Modify.........: No.MOD-780067 07/08/09 By claire 匯率基準日取結關日,當空白時取單據日
# Modify.........: No.TQC-750014 07/08/14 By pengu 庫存轉換率異常
# Modify.........: No.FUN-730025 07/09/03 By xufeng 增加多倉儲庫存明細查詢按鈕
# Modify.........: No.TQC-780095 07/09/03 By Melody Primary key
# Modify.........: No.MOD-790009 07/09/04 By claire axr-164訊息調整為mfg6090
# Modify.........: NO.TQC-790100 07/09/17 By Joe 修正Primary Key後, 程式判斷錯誤訊息時必須改變做法
# Modify.........: No.MOD-7A0178 07/10/30 By claire 庫存過帳及庫存還原,圖示(ogamksg)未及時更新
# Modify.........: No.CHI-7B0023/CHI-7B0039 07/11/14 By kim 移除GP5.0行業別功能的所有程式段
# Modify.........: No.TQC-810019 08/01/07 By chenl  根據客戶編號自動帶出科目別
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.CHI-820004 08/02/18 By claire 庫存扣帳還原時,應將寄銷庫存異動作業的已轉出貨碼(tus09)更新為'N'
# Modify.........: No.FUN-810045 08/03/03 By rainy 專案管理相關修改:專案table gja_file改為pja_file
# Modify.........: No.FUN-7B0018 08/03/07 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-810036 08/01/16 By Nicola 序號管理
# Modify.........: No.FUN-830120 08/03/25 By hellen 修改行業別INSERT/DEL
# Modify.........: No.FUN-810045 08/03/25 By rainy 項目管理，單身新增專案代號ogb41/WBS代號ogb42/活動代號ogb43
# Modify.........: No.CHI-840009 08/04/10 By claire oaz71='2'時,批號不需帶入條件
# Modify.........: No.FUN-840042 08/04/11 By TSD.zeak 自訂欄位功能修改 
# Modify.........: NO.MOD-840220 08/04/20 By Yiting NEXT FIELD ogb1004造成無法存檔，畫面上無此欄位
# Modify.........: No.MOD-850016 08/05/05 By claire 增加批號開窗
# Modify.........: No.MOD-850147 08/05/14 By Smapmin 預設計價單位與計價數量
# Modify.........: No.FUN-850120 08/05/23 By rainy 多單位補批序號處理
# Modify.........: NO.MOD-860078 08/06/06 By Yiting ON IDLE 處理
# Modify.........: NO.CHI-860008 08/06/11 By yiting s_del_rvbs
# Modify.........: No.MOD-860122 08/06/12 By Nicola 重新過單
# Modify.........: No.FUN-860045 08/06/12 By Nicola 批/序號傳入值修改及開窗詢問使用者是否回寫單身數量
# Modify.........: No.FUN-850027 08/06/19 By douzh WBS編碼錄入時要求時尾階并且為成本對象的WBS編碼
# Modify.........: No.MOD-860254 08/06/27 By Sarah 新增段預設oga07=N
# Modify.........: No.CHI-860005 08/06/27 By xiaofeizhu 使用參考單位且參考數量為0時，也需寫入tlff_file
# Modify.........: No.MOD-870164 08/07/14 By Smapmin 文件地址中的結關日期,無顯示也無法維護
# Modify.........: NO.MOD-890049 08/09/03 By claire 給初值,否則造成使用沒有權限的action也沒有顯示錯誤訊息
# Modify.........: No.FUN-880129 08/09/05 By xiaofeizhu s_del_rvbs的傳入參數(出/入庫，單據編號，單據項次，專案編號)，改為(出/入庫，單據編號，單據項次，檢驗順序)
# Modify.........: No.MOD-8A0126 08/10/16 By chenyu 出貨單審核時的信用檢查應該考慮當前筆的金額
# Modify.........: No.MOD-8A0145 08/10/16 By Smapmin 修改變數型態
# Modify.........: No.MOD-8A0137 08/10/17 By chenl  若計價單位與銷售單位相同，則計價數量直接由銷售數量賦值，不必通過轉換取得，以避免尾數。
# Modify.........: No.MOD-8A0134 08/10/21 By chenyu 1.使用計價單位，但不使用雙單位的時候，默認的ima908帶不出來
#                                                   2.單身單位欄位增加開窗
# Modify.........: No.FUN-8A0086 08/10/21 By lutingting完善錯誤訊息匯總
# Modify.........: No.MOD-8A0264 08/10/30 By chenl  若參數"多庫位出貨"未勾選,則庫存數量的取值應移到倉庫欄位處判斷,而不應該在庫位欄位判斷. 
# Modify.........: No.MOD-8B0161 08/11/15 By Smapmin ogc17 不可空白
# Modify.........: No.MOD-8B0216 08/11/21 By Smapmin 多倉出貨時,應出貨數量未顯示
# Modify.........: No.MOD-8A0208 08/10/23 By chenyu OPEN coursor失敗時，有的地方不需要ROLLBACK WORK，直接LET g_success = 'N'即可
# Modify.........: No.FUN-8C0084 08/12/22 By jan s_upimg相關改以 料倉儲批為參數傳入 ,不使用 rowid
# Modify.........: No.MOD-910067 09/01/08 By chenyu 單身有數據，單頭稅率改變后，單身金額沒有重算
# Modify.........: No.MOD-910173 09/01/15 By Smapmin 必須輸入有效且可用的倉庫
# Modify.........: No.FUN-920166 09/02/20 By alex g_dbs2改為使用s_dbstring
# Modify.........: No.MOD-920298 09/02/24 By Smapmin 回寫最近出庫日(ima74),應依照出貨日期
# Modify.........: No.FUN-930104 09/03/23 By dxfwo   理由碼的分類改善
# Modify.........: No.MOD-930314 09/04/02 By Smapmin tlf020應該是營運中心編號
# Modify.........: No.MOD-940094 09/04/08 By Dido 開放不可用倉出貨
# Modify.........: No.MOD-940188 09/04/14 By Dido oga31 請帶預設值-occ44
# Modify.........: No.MOD-940187 09/04/14 By Smapmin 將單身理由碼寫入tlf14
# Modify.........: NO.MOD-940265 09/04/21 By lutingting 文件地址里頭的地址碼無法正常開窗因程式少了給 g_qryparam.arg1
# Modify.........: No.MOD-940249 09/04/21 By lutingting 新增使用多單位時,單身多倉儲明細開窗
# Modify.........: No.MOD-940275 09/04/21 By Dido 合併處理 MOD-860197 問題
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.TQC-950134 09/05/22 By Carrier rowid定義規範化
# Modify.........: No.CHI-940031 09/06/03 by ve007 單身價格依據價格條件取價
# Modify.........: No.FUN-870007 09/08/13 By Zhangyajun 流通零售功能修改
# Modify.........: No.FUN-980010 09/08/31 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980020 09/09/01 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960038 09/09/04 By chenmoyan 專案加上'結案'的判斷
# Modify.........: No.CHI-960022 09/10/15 By chenmoyan 預設單位一數量時，加上判斷，單位一數量為空或為1時，才預設
# Modify.........: No.CHI-960052 09/10/15 By chenmoyan 使用多單位，料件是單一單位或參考單位時，單位一的轉換率錯誤
# Modify.........: No:MOD-9A0140 09/10/22 By Smapmin 修正CHI-940031
# Modify.........: No.TQC-9A0132 09/10/26 By liuxqa 修改OUTER语法。
# Modify.........: No.FUN-9C0083 09/12/16 By mike 取价call s_fetch_price_new()
# Modify.........: No.FUN-9C0120 09/12/21 By mike 通过价格条件管控未取到价格时单价栏位是否可以人工输入
# Modify.........: No:FUN-9C0071 10/01/12 By huangrh 精簡程式
# Modify.........: No:CHI-A10016 10/01/18 By Dido 調整 s_lotout transcation 架構 
# Modify.........: No:MOD-A10106 10/01/18 By sabrina 右邊文件地址中交運方式無法開窗 
# Modify.........: No:MOD-A20043 10/02/06 By Smapmin 確認時,mfg3075的錯誤訊息增加顯示項次
# Modify.........: No:CHI-A10002 10/02/23 By sabrina 確認時,無倉儲批的錯誤訊息請加上料號,當單身筆數很多時,會查不出是哪一筆的問題
# Modify.........: No:MOD-A20102 10/02/24 By Smapmin oaz71='2'時,批號不需帶入條件
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:CHI-9C0024 10/03/02 By Smapmin 多倉儲的畫面,數量移到倉儲批後面
# Modify.........: No:MOD-A20117 10/03/02 By Smapmin 使用多單位且多倉儲出貨時,無法update imgs_file
# Modify.........: No:CHI-9A0022 10/03/20 By chenmoyan給s_lotout加一個參數:歸屬單號
# Modify.........: No:TQC-A40032 10/04/07 By houlia  庫存過帳action顯示
# Modify.........: No:MOD-A40121 10/04/21 By Smapmin 沒有使用計價單位時,畫面不可呈現計價數量
# Modify.........: No:MOD-A50013 10/05/10 By Smapmin 增加料倉儲批有效日期的控管
# Modify.........: No:CHI-A50002 10/05/13 By Summer 增加科目別開窗 
# Modify.........: No.FUN-A50054 10/06/01 By chenmoyan 增加服饰版二维功能 
# Modify.........: No:FUN-A50103 10/06/03 By Nicola 訂單多帳期 1.取消訂單/尾款分期立帳欄位 2.增加訂單多帳期維護
# Modify.........: No:CHI-A50004 10/06/24 By Summer 在確認/取消確認/過帳/取消過帳時,將lock資料的動作往前移至FUNCTION的一開始
# Modify.........: No:FUN-A60035 10/07/05 By chenls 單身顯示
# Modify.........: No:MOD-A70140 10/07/23 By Smapmin 修改完單位一後,金額未重新計算
# Modify.........: No:MOD-A70108 10/07/23 By Smapmin 修改完單位一後,未重新計算計價數量
# Modify.........: No:FUN-A60035 10/07/27 By chenls 服飾版二維功能mark
# Modify.........: No:MOD-A80086 10/08/11 By Carrier 单身录入时按"退出",重新进到单身做新增时,没有走INSERT逻辑
# Modify.........: No:MOD-A90145 10/09/28 By Smapmin 切換語言別後都會呼叫過帳段
# Modify.........: No:TQC-AA0034 10/10/09 By lilingyu 单身无法输入,报错-391
# Modify.........: No:FUN-A90049 10/10/09 By huangtao 異動tlf_file或img_file時做料號管控
# Modify.........: No.FUN-AA0059 10/10/27 By huangtao 修改料號的管控
# Modify.........: No.FUN-AA0059 10/10/28 By chenying 料號開窗控管 
# Modify.........: No.FUN-AA0062 10/10/29 By yinhy 倉庫權限使用修改 
# Modify.........: No:MOD-AB0034 10/11/03 By Smapmin 料件改變,單位與倉儲未重新default
# Modify.........: No:MOD-AB0033 10/11/03 By Smapmin 無訂單出貨單的倉庫無控管單別的倉庫限定
# Modify.........: No:MOD-AB0124 10/11/12 By lilingyu 客戶編號欄位,查詢時多選,無法正確顯示值
# Modify.........: No.FUN-AB0061 10/11/17 By shenyang 出貨單加基礎單價字段ogb37
# Modify.........: No.FUN-AB0061 10/11/17 By shenyang 在CALL s_fetch_price_new的地方返回參數中加上基礎單價
# Modify.........: No:FUN-AA0048 10/11/24 By Carrier GP5.2架构下仓库权限修改
# Modify.........: No.FUN-AB0096 10/11/25 By vealxu 因新增ogb50,ohb71的not null欄位,所導致其他作業無法insert into資料的問題修正
# Modify.........: No:CHI-AC0002 10/12/13 By Summer 增加分錄底稿二ACTION
# Modify.........: No.FUN-AC0055 10/12/21 By wangxin oga57,ogb50欄位預設值修正
# Modify.........: No:FUN-B10004 11/01/04 By Mandy 確認段拆出至axmt650_sub.4gl
# Modify.........: No:FUN-B10016 11/01/07 By Lilan 與CRM整合
# Modify.........: No:MOD-AC0412 11/01/18 By Smapmin 新增時,單身ogb11沒有重抓 
# Modify.........: No:MOD-B20123 11/02/23 By Summer 修正MOD-AB0034
# Modify.........: No:FUN-B30170 11/04/11 By suncx 單身增加批序號明細頁簽
# Modify.........: No:FUN-950062 11/05/12 By lixiang 單頭增加錄入日期oga69,記錄單據輸入的日期
#                                                    原oga02(出貨日期),作"庫存扣帳"時會先跳到oga02輸入,以記錄實際出貨扣帳日期
# Modify.........: No:FUN-B40056 11/05/13 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B60225 11/06/22 By huangtao 倉庫控管有誤
# Modify.........: No.FUN-B50026 11/07/05 By zhangll 單號控管改善
# Modify.........: No:FUN-B70087 11/07/21 By zhangll 增加oah07控管，s_unitprice_entry增加传参
# Modify.........: No:MOD-B70278 11/07/29 By yinhy GP5.3編譯不過
# Modify.........: No:MOD-B80206 11/08/22 By johung 修改取價參數
# Modify.........: No:MOD-B80301 11/09/02 By johung 修正查詢時送貨客戶開窗選多筆未接收全部回傳值的問題
#                                                       業務人員oga14輸入錯誤NEXT FIELD到送貨客戶oga04的問題
# Modify.........: No:TQC-B80227 11/09/08 By guoch 查询时资料建立者和资料建立部门无法输入的bug
# Modify.........: No:TQC-B90236 11/10/28 By zhuhao s_lotout_del程式段Mark，改為s_lot_del，傳入參數不變
#                                                   _r()中，使用FOR迴圈執行s_del_rvbs程式段Mark，改為s_lot_del，傳入參數同上，但第三個參數(項次)傳""
#                                                   BEFORE DELETE中s_del_rvbs程式段Mark，改為s_lot_del，傳入參數同第1點
#                                                   原執行s_lotou程式段，改為s_mod_lot，傳入參數不變，於最後多傳入-1
# Modify.........: No:FUN-B80178 11/11/18 By jason axmt650.4gl -> axmt650.src.4gl 新增ICD相關功能
# Modify.........: No:FUN-BA0019 11/11/21 By jason ICD多倉儲批功能
# Modify.........: No:FUN-910088 11/12/14 By chenjing 增加數量欄位小數取位
# Modify.........: No:FUN-C10038 12/01/12 By jason 修改錯誤之ogc12 > ogg12  
# Modify.........: No:FUN-BC0071 12/02/08 By huangtao 增加取價參數
# Modify.........: No.FUN-BC0109 12/02/13 By jason for ICD Datecode回寫多筆時即以","做分隔
# Modify.........: No:TQC-BB0164 12/02/13 By destiny 修改出货日期后应更改汇率
# Modify.........: No:TQC-C20185 12/02/15 By zhangll 增加ogaslk02 not null型栏位赋值
# Modify.........: No:MOD-BB0021 12/02/16 By bart 單頭修改稅別重新計算單身金額時，小數未取位錯誤
# Modify.........: No:MOD-B90173 12/02/20 By Vampire 外部參數少tm.d
# Modify.........: No:MOD-BB0010 12/02/20 By Vampire AFTER FIELD ogb912的判斷裡，加上不是MISC*的判斷
# Modify.........: No:FUN-BB0167 12/02/22 By suncx 新增無訂單出貨的客戶簽收功能
# Modify.........: No:FUN-C30235 12/03/20 By bart 單身備品比率及SPARE數要隱藏
# Modify.........: No:FUN-C30289 12/04/03 By bart 1.所有程式的備品比率、Spare Part、TapeReel隱藏 2.增加End User欄位
# Modify.........: No:CHI-C30106 12/04/06 By Elise 批序號維護
# Modify.........: No.FUN-C30300 12/04/09 By bart  倉儲批開窗需顯示參考單位數量
# Modify.........: No:FUN-C30302 12/04/13 By bart 修改 s_icdout 回傳值
# Modify.........: No.FUN-C40089 12/05/02 By bart 判斷銷售價格條件(axmi060)的oah08,若oah08為Y則單價欄位可輸入0;若oah08為N則單價欄位不可輸入0
# Modify.........: No:FUN-BC0088 12/05/10 By Vampire 判斷MISC料可輸入單價
# Modify.........: No:TQC-C50131 12/05/15 By zhuhao 錯誤訊息代碼mfg3075將相關資訊一並顯示
# Modify.........: No.FUN-C50074 12/05/18 By bart 更改錯誤訊息代碼
# Modify.........: No:FUN-C50114 12/05/25 By Sarah ICD行業別問題修改
#                  1.輸入完刻號/BIN資料後,詢問是否回寫數量,卻沒有回寫單頭的金額欄位
#                  2.多倉儲批出貨(ogb17='Y'),當出貨的料件是CP時,進入多倉儲畫面後再做「刻號/BIN明細維護」,回寫數量有問題
#                    當出貨的料號為CP,ogg20='1'時才能按「刻號/BIN明細維護」,數量不同時要回寫l_qty到ogg12跟ogg16,
#                    同時連同倉儲批的ogg20='2'的數量一併回寫(當沒有ogg20='2'的資料時自動新增)
#                  3.當多倉儲批數量被刻號/BIN數量回寫後,會與主維護畫面的數量不一樣,程式會詢問axm-170但沒將數量回寫到ogb_file
#                  4.手動輸入EndUser欄位時,應檢查輸入值要存在aici003的碼類別=R的碼別代碼
# Modify.........: No.CHI-C30002 12/05/28 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:TQC-C60028 12/06/04 By bart 只要是ICD行業 倉儲批開窗改用q_idc
# Modify.........: No.FUN-C50097 12/06/09 By SunLM 當oaz92=Y(立賬走開票流程)且大陸版時,判斷參數oaz94='Y'(出貨多次簽收)時，
#                                                  增加多次簽收功能,新增ogb50,51欄位
# Modify.........: No:FUN-C50097 12/06/27 By SunLM 因前期分析不足,修改時間過長,為避免影響他人作業,暫時mark掉,待其他同仁完成后,再恢復
# Modify.........: No:FUN-C30085 12/07/04 By nanbing CR改串GR
# Modify.........: No.FUN-C50136 12/07/05 By xianghui 修改信用管控
# Modify.........: No.TQC-C60227 12/07/09 By zhuhao 開窗欄位錯誤
# Modify.........: No:MOD-C60172 12/07/10 By Elise oga14,oga15,oga21,oga23,oga25回傳應為g_qryparam.multiret
# Modify.........: No:TQC-C70206 12/07/27 By SunLM將FUN-C50097中，非多次多次簽收功能過單到正式區，既與oaz94無關的參數。
# Modify.........: No:FUN-C80030 12/08/13 By xujing 添加批序號依參數sma95隱藏
# Modify.........: No:CHI-B90032 12/10/19 By Nina axmt6002的oga32為noentry，改為exit input
# Modify.........: No:FUN-CA0084 12/10/19 By xuxz 若此出货单已存在于axmt670里面，则报错，不可扣帐还原
# Modify.........: No.CHI-C70017 12/10/29 By bart 關帳日管控
# Modify.........: No:FUN-CB0014 12/11/08 By xianghui 增加資料清單
# Modify.........: No.CHI-CB0008 12/11/05 By Lori 1.單頭的稅「率」改變，不詢問直接自動更新單身。
#                                                 2.單頭的「稅率」不變，但「是否含稅」改變，才需要顯示詢問視窗。
#                                                 3.單身若進入單價後，單價無任何異動時，亦不能更新後面的金額。
# Modify.........: No:FUN-C80107 12/11/28 By suncx 新增可按倉庫進行負庫存判斷
# Modify.........: No.CHI-C80041 12/12/05 By bart 取消單頭資料控制
# Modify.........: No.TQC-D10084 13/01/28 By xianghui 資料清單頁簽下隱藏一部分ACTION
# Modify.........: No.MOD-CA0074 13/01/29 By Elise 調整開放收款條件oga32可維護
# Modify.........: No.MOD-C90205 13/01/30 By jt_chen 將oga04開窗調整為q_occ4
# Modify.........: No.MOD-CC0247 13/01/31 By jt_chen 調整t650_n_cur1 cursor增加 AND ogaconf<>'X'判斷,排除作廢的簽收單
# Modify.........: No.MOD-CA0220 13/02/01 By jt_chen s_lotout中參數g_img09沒有抓到值,img09重抓,轉換率需一併重抓
# Modify.........: No.MOD-CB0033 13/02/01 By jt_chen 調整在AFTER FIELD ogb13後增加DISPLAY觸發ON ROW CHANGE
# Modify.........: No:FUN-D20025 13/02/21 By chenying 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No.CHI-CC0014 13/02/22 By huangtao 增加對設限倉庫的控管
# Modify.........: No.MOD-D30017 13/03/07 By Elise 無訂單出貨單目前單身無檢驗碼也不走QC,檢驗碼ogb19可以預設為N
# Modify.........: No:FUN-D30024 13/03/12 By fengrui 負庫存依據imd23判斷
# Modify.........: No:CHI-B60094 13/03/22 By Elise s_cusqry加傳參數
# Modify.........: No:FUN-D30034 13/04/16 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:TQC-D40078 13/04/28 By xujing 負庫存函数添加营运中心参数 
# Modify.........: No:TQC-D40060 13/04/26 By zhangweib 點擊查詢 再進入單身任意欄位 此時點擊【退出】
#                                                      會報錯'找不到光標或說明.' 修改_cs(函數退出時對INT_FLAG的複製 
# Modify.........: No.2021112601 21/11/26 By jc 增加自动审核扣账
# Modify.........: No.2022032401 22/03/24 By jc SCM抛转单据限定日期后不可修改

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/axmt650.global"  #FUN-B10004 add

#FUN-B30170 add begin--------------------------
DEFINE g_rvbs   DYNAMIC ARRAY OF RECORD        #批序號明細單身變量
                  rvbs02  LIKE rvbs_file.rvbs02,
                  rvbs021 LIKE rvbs_file.rvbs021,
                  ima02a  LIKE ima_file.ima02,
                  ima021a LIKE ima_file.ima021,
                  rvbs022 LIKE rvbs_file.rvbs022,
                  rvbs04  LIKE rvbs_file.rvbs04,
                  rvbs03  LIKE rvbs_file.rvbs03,
                  rvbs05  LIKE rvbs_file.rvbs05,
                  rvbs06  LIKE rvbs_file.rvbs06,
                  rvbs07  LIKE rvbs_file.rvbs07,
                  rvbs08  LIKE rvbs_file.rvbs08,
                  rvbs13  LIKE rvbs_file.rvbs13
                END RECORD
DEFINE g_rec_b1           LIKE type_file.num5,   #單身二筆數 ##FUN-B30170
       l_ac1              LIKE type_file.num5    #目前處理的ARRAY CNT  #FUN-B30170
DEFINE l_tmoga01 LIKE oga_file.oga01   #FUN-BB0167
DEFINE g_oah08   LIKE oah_file.oah08   #FUN-C40089
#FUN-B30170 add -end---------------------------
#FUN-CB0014---add---str--
DEFINE g_oga_l   DYNAMIC ARRAY OF RECORD        
                  oga00   LIKE oga_file.oga00,
                  oga08   LIKE oga_file.oga08,
                  oga01   LIKE oga_file.oga01,
                  oga02   LIKE oga_file.oga02,
                  oga03   LIKE oga_file.oga03,
                  oga032  LIKE oga_file.oga032,
                  oga04   LIKE oga_file.oga04,
                  occ02   LIKE occ_file.occ02,
                  oga14   LIKE oga_file.oga14,
                  gen02   LIKE gen_file.gen02,
                  oga15   LIKE oga_file.oga15,
                  gem02   LIKE gem_file.gem02,
                  ogaconf LIKE oga_file.ogaconf,
                  ogapost LIKE oga_file.ogapost
                END RECORD
DEFINE g_rec_b2           LIKE type_file.num5,  
       l_ac2              LIKE type_file.num5,
       g_action_flag      STRING
DEFINE w        ui.Window
DEFINE f        ui.Form
DEFINE page     om.DomNode
#FUN-CB0014---add---end--
#FUN-B10004---mark---str---
##模組變數(Module Variables)
#DEFINE
#    g_oga   RECORD LIKE oga_file.*,
#    g_oga_t RECORD LIKE oga_file.*,
#    g_oga_o RECORD LIKE oga_file.*,
#    b_ogb   RECORD LIKE ogb_file.*,
#    g_ima86  LIKE ima_file.ima86,
#    g_ogb           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
#                    ogb03     LIKE ogb_file.ogb03,
#                    ogb04     LIKE ogb_file.ogb04,
#                    ogb06     LIKE ogb_file.ogb06,
#                    ima021    LIKE ima_file.ima021,
#                    ogb092    LIKE ogb_file.ogb092,
#                    ogb1001   LIKE ogb_file.ogb1001,   #No.FUN-660073
#                    ogb17     LIKE ogb_file.ogb17,
#                    ogb09     LIKE ogb_file.ogb09,
#                    ogb091    LIKE ogb_file.ogb091,
#                    ogb05     LIKE ogb_file.ogb05,
#                    ogb12     LIKE ogb_file.ogb12,
#                    ogb913    LIKE ogb_file.ogb913,
#                    ogb914    LIKE ogb_file.ogb914,
#                    ogb915    LIKE ogb_file.ogb915,
#                    ogb910    LIKE ogb_file.ogb910,
#                    ogb911    LIKE ogb_file.ogb911,
#                    ogb912    LIKE ogb_file.ogb912,
#                    ogb916    LIKE ogb_file.ogb916,
#                    ogb917    LIKE ogb_file.ogb917,
#                    ogb41     LIKE ogb_file.ogb41,
#                    ogb42     LIKE ogb_file.ogb42,
#                    ogb43     LIKE ogb_file.ogb43,
#                    ogb37     LIKE ogb_file.ogb37,#FUN-AB0061 
#                    ogb13     LIKE ogb_file.ogb13,
#                    ogb14     LIKE ogb_file.ogb14,
#                    ogb14t    LIKE ogb_file.ogb14t,
#                    ogb930    LIKE ogb_file.ogb930, #FUN-670063
#                    gem02c    LIKE gem_file.gem02 , #FUN-670063
#                    ogb908    LIKE ogb_file.ogb908,  #no.A050
#                    ogbud01 LIKE ogb_file.ogbud01,
#                    ogbud02 LIKE ogb_file.ogbud02,
#                    ogbud03 LIKE ogb_file.ogbud03,
#                    ogbud04 LIKE ogb_file.ogbud04,
#                    ogbud05 LIKE ogb_file.ogbud05,
#                    ogbud06 LIKE ogb_file.ogbud06,
#                    ogbud07 LIKE ogb_file.ogbud07,
#                    ogbud08 LIKE ogb_file.ogbud08,
#                    ogbud09 LIKE ogb_file.ogbud09,
#                    ogbud10 LIKE ogb_file.ogbud10,
#                    ogbud11 LIKE ogb_file.ogbud11,
#                    ogbud12 LIKE ogb_file.ogbud12,
#                    ogbud13 LIKE ogb_file.ogbud13,
#                    ogbud14 LIKE ogb_file.ogbud14,
#                    ogbud15 LIKE ogb_file.ogbud15
#                    END RECORD,
#    g_ogb_t         RECORD
#                    ogb03     LIKE ogb_file.ogb03,
#                    ogb04     LIKE ogb_file.ogb04,
#                    ogb06     LIKE ogb_file.ogb06,
#                    ima021    LIKE ima_file.ima021,
#                    ogb092    LIKE ogb_file.ogb092,
#                    ogb1001   LIKE ogb_file.ogb1001,   #No.FUN-660073
#                    ogb17     LIKE ogb_file.ogb17,
#                    ogb09     LIKE ogb_file.ogb09,
#                    ogb091    LIKE ogb_file.ogb091,
#                    ogb05     LIKE ogb_file.ogb05,
#                    ogb12     LIKE ogb_file.ogb12,
#                    ogb913    LIKE ogb_file.ogb913,
#                    ogb914    LIKE ogb_file.ogb914,
#                    ogb915    LIKE ogb_file.ogb915,
#                    ogb910    LIKE ogb_file.ogb910,
#                    ogb911    LIKE ogb_file.ogb911,
#                    ogb912    LIKE ogb_file.ogb912,
#                    ogb916    LIKE ogb_file.ogb916,
#                    ogb917    LIKE ogb_file.ogb917,
#                    ogb41     LIKE ogb_file.ogb41,
#                    ogb42     LIKE ogb_file.ogb42,
#                    ogb43     LIKE ogb_file.ogb43,
#                    ogb37     LIKE ogb_file.ogb37, #FUN-AB0061 
#                    ogb13     LIKE ogb_file.ogb13,
#                    ogb14     LIKE ogb_file.ogb14,
#                    ogb14t    LIKE ogb_file.ogb14t,
#                    ogb930    LIKE ogb_file.ogb930, #FUN-670063
#                    gem02c    LIKE gem_file.gem02 , #FUN-670063
#                    ogb908    LIKE ogb_file.ogb908,  #no.A050
#                    ogbud01 LIKE ogb_file.ogbud01,
#                    ogbud02 LIKE ogb_file.ogbud02,
#                    ogbud03 LIKE ogb_file.ogbud03,
#                    ogbud04 LIKE ogb_file.ogbud04,
#                    ogbud05 LIKE ogb_file.ogbud05,
#                    ogbud06 LIKE ogb_file.ogbud06,
#                    ogbud07 LIKE ogb_file.ogbud07,
#                    ogbud08 LIKE ogb_file.ogbud08,
#                    ogbud09 LIKE ogb_file.ogbud09,
#                    ogbud10 LIKE ogb_file.ogbud10,
#                    ogbud11 LIKE ogb_file.ogbud11,
#                    ogbud12 LIKE ogb_file.ogbud12,
#                    ogbud13 LIKE ogb_file.ogbud13,
#                    ogbud14 LIKE ogb_file.ogbud14,
#                    ogbud15 LIKE ogb_file.ogbud15
#                    END RECORD,
#    g_imgg10_1          LIKE imgg_file.imgg10,
#    g_imgg10_2          LIKE imgg_file.imgg10,
#    g_yes               LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(01)
#    g_change            LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(01)
#    g_ima25             LIKE ima_file.ima25,
#    g_ima31             LIKE ima_file.ima31,
#    g_ima905            LIKE ima_file.ima905,
#    g_ima906            LIKE ima_file.ima906,
#    g_ima907            LIKE ima_file.ima907,
#    g_ima908            LIKE ima_file.ima908,
#    g_img09             LIKE img_file.img09,
#    g_img10             LIKE img_file.img10,
#    g_imgg00            LIKE imgg_file.imgg00,
#    g_imgg10            LIKE imgg_file.imgg10,
#    g_sw                LIKE type_file.num5,    #No.FUN-680137 SMALLINT
#    g_factor            LIKE img_file.img21,
#    g_tot               LIKE img_file.img10,
#    g_qty               LIKE img_file.img10,
#    g_flag              LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
#    g_oea   RECORD LIKE oea_file.*,
#    g_oeb   RECORD LIKE oeb_file.*,
#    g_wc,g_wc2,g_sql    string,  #No.FUN-580092 HCN
#    g_t1                LIKE oay_file.oayslip,           #No.FUN-550052  #No.FUN-680137 VARCHAR(5)
#    g_buf,g_buf1        LIKE type_file.chr1000, #No.FUN-680137 VARCHAR(30)
#    tot1            LIKE ogc_file.ogc16,
#    exT             LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(01),
#    g_chr           LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
#    g_no            LIKE oga_file.oga01,   #MOD-5B0276
#    g_rec_b         LIKE type_file.num5,                #單身筆數  #No.FUN-680137 SMALLINT
#    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT  #No.FUN-680137 SMALLINT
# 
#DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
#DEFINE g_before_input_done  LIKE type_file.num5    #No.FUN-680137 SMALLINT
# 
#DEFINE g_cnt           LIKE type_file.num10   #No.FUN-680137 INTEGER
#DEFINE g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-680137 SMALLINT
#DEFINE g_msg           LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(72)
#DEFINE g_row_count     LIKE type_file.num10   #No.FUN-680137 INTEGER
#DEFINE g_curs_index    LIKE type_file.num10   #No.FUN-680137 INTEGER
#DEFINE g_jump          LIKE type_file.num10   #No.FUN-680137 INTEGER
#DEFINE mi_no_ask       LIKE type_file.num5    #No.FUN-680137 SMALLINT
#DEFINE g_imm01         LIKE imm_file.imm01      #No.FUN-610090
#DEFINE g_unit_arr      DYNAMIC ARRAY OF RECORD  #No.FUN-610090
#                          unit   LIKE ima_file.ima25,
#                          fac    LIKE img_file.img21,
#                          qty    LIKE img_file.img10
#                       END RECORD
#DEFINE g_argv1  LIKE oga_file.oga01  #No.FUN-680137 VARCHAR(16)    #No.TQC-630066
#DEFINE g_argv2  STRING              #No.TQC-630066
#DEFINE g_dbs2          LIKE type_file.chr30    #TQC-680074
#DEFINE g_bookno1       LIKE aza_file.aza81     #No.FUN-730057                                                                
#DEFINE g_bookno2       LIKE aza_file.aza82     #No.FUN-730057                                                                
#DEFINE g_exdate        LIKE oga_file.oga021    #MOD-780067 add
#DEFINE b_ogbi          RECORD LIKE ogbi_file.* #No.FUN-7B0018
#DEFINE g_ima918  LIKE ima_file.ima918  #No.FUN-810036
#DEFINE g_ima921  LIKE ima_file.ima921  #No.FUN-810036
#DEFINE l_r       LIKE type_file.chr1   #No.FUN-860045
#DEFINE g_plant2  LIKE type_file.chr10  #FUN-980020
#FUN-B10004---mark---end---
  
MAIN
   OPTIONS                                #改變一些系統預設值
       INPUT NO WRAP,
       FIELD ORDER FORM                   #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序)  #FUN-730018
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log

#FUN-B80178 --START--
    LET g_prog='axmt650'
#FUN-B80178 --END--
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_argv1=ARG_VAL(1)           #No.TQC-630066
   LET g_argv2=ARG_VAL(2)           #No.TQC-630066
   LET g_bgjob=ARG_VAL(3)    #2021112601 add
 
   CALL cl_used(g_prog,g_time,1) RETURNING  g_time #No.MOD-580088  HCN 20050818 #NO.FUN-6A0094
 
   LET g_plant2 = g_plant                    #FUN-980020
   LET g_dbs2 = s_dbstring(g_dbs CLIPPED)    #FUN-920166
 
   LET g_forupd_sql = "SELECT * FROM oga_file WHERE oga01 = ?  FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t650_cl CURSOR FROM g_forupd_sql
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN     #2021112601 add
   OPEN WINDOW t650_w WITH FORM "axm/42f/axmt650"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()

  #FUN-C80030---add---str---
   CALL cl_set_act_visible("qry_lot,modi_lot",g_sma.sma95="Y")  #FUN-C80030 add
   CALL cl_set_comp_visible("Page2",g_sma.sma95="Y")            #FUN-C80030 add
  #FUN-C80030---add---end---
   CALL cl_set_comp_visible("ogbiicd02,ogbiicd04",FALSE)           #FUN-C30235  #FUN-C30289
   #FUN-C30289---begin
   CALL cl_set_comp_visible("ogbiicd07",FALSE)
   #FUN-C30289---end
   END IF     #2021112601 add
#FUN-A60035 ---MARK BEGIN
#  #FUN-A50054---Begin add
#  IF s_industry("slk") THEN
#     CALL cl_set_act_visible("style_detail",TRUE)
#  ELSE 
#  	  CALL cl_set_act_visible("style_detail",FALSE)
#  END IF 
#  #FUN-A50054---End	
#FUN-A60035 ---MARK END


   SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN     #2021112601 add
   CALL t650_def_form()
   END IF     #2021112601 add
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL t650_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL t650_a()
            END IF
         #2021112601 add----begin----
         WHEN "M"
            SELECT * INTO g_oga.* FROM oga_file WHERE oga01 = g_argv1
            LET g_success = 'Y'
            IF g_oga.ogaconf = 'N' THEN 
            	CALL t650sub_y(g_oga.oga01)
            END IF 
            IF g_success = 'Y' THEN 
            	CALL t650sub_s('1',g_oga.oga01)
            END IF 
         #2021112601 add----end----
         OTHERWISE            #TQC-660088
               CALL t650_q()  #TQC-660088
      END CASE
   END IF
 
   WHILE TRUE
      LET g_action_choice = ''
      CALL t650_menu()
      IF g_action_choice = 'exit' THEN
         EXIT WHILE
      END IF
   END WHILE
 
   CLOSE WINDOW t650_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #NO.FUN-6A0094
 
END MAIN
 
FUNCTION t650_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
 
    CLEAR FORM                             #清除畫面
    CALL g_ogb.clear()
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092

    #FUN-B10016 add str ---------
     IF g_aza.aza123 MATCHES "[Yy]" THEN
        CALL cl_set_comp_entry("oga70",TRUE)       #開放oga70可查詢
     END IF
    #FUN-B10016 add end ---------
 
    IF NOT cl_null(g_argv1) THEN   
        LET g_wc = " oga01 = '",g_argv1,"'"
        LET g_wc2= " 1=1 "
    ELSE
    WHILE TRUE
   INITIALIZE g_oga.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
        oga00,oga08,oga01,oga69,oga02,              #No.FUN-950062 add oga69
        oga03,oga032,oga04,oga18,                   #No.TQC-620115 add oga18
        oga021,oga70,oga14,oga15,oga903,            #FUN-B10016 add:oga70 
        ogaconf,oga30,ogapost,
        oga25,oga23,oga24,oga21,oga211,oga212,oga213,
        oga13,oga05,oga10,oga65,oga72,              #FUN-BB0167 add oga65,oga72
        oga50,ogauser,ogagrup,ogamodu,ogadate, 
        ogaud01,ogaud02,ogaud03,ogaud04,ogaud05,
        ogaud06,ogaud07,ogaud08,ogaud09,ogaud10,
        ogaud11,ogaud12,ogaud13,ogaud14,ogaud15,
        ogaoriu,ogaorig                             #TQC-B80227 add
 
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
        ON ACTION controlp
           CASE
              WHEN INFIELD(oga01) #查詢單据
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_oga9"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oga01
                   NEXT FIELD oga01
              WHEN INFIELD(oga03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_occ"
#MOD-AB0124 --begin--
#                  CALL cl_create_qry() RETURNING g_oga.oga03
#                  DISPLAY BY NAME g_oga.oga03        #No.MOD-490371
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oga03  
#MOD-AB0124 --end--
                   NEXT FIELD oga03
              WHEN INFIELD(oga18)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_occ"
                  #CALL cl_create_qry() RETURNING g_oga.oga18               #TQC-C60227 mark
                  #DISPLAY BY NAME g_oga.oga18                              #TQC-C60227 mark
                   CALL cl_create_qry() RETURNING g_qryparam.multiret       #TQC-C60227
                   DISPLAY g_qryparam.multiret TO oga18                     #TQC-C60227
                   NEXT FIELD oga18
              WHEN INFIELD(oga04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                  #LET g_qryparam.form ="q_occ"                         #MOD-C90205 mark
                   LET g_qryparam.form ="q_occ4"                        #MOD-C90205 add
#                  CALL cl_create_qry() RETURNING g_oga.oga04           #MOD-B80301 mark
#                  DISPLAY BY NAME g_oga.oga04   #No.MOD-490371         #MOD-B80301 mark
                   CALL cl_create_qry() RETURNING g_qryparam.multiret   #MOD-B80301
                   DISPLAY g_qryparam.multiret TO oga04                 #MOD-B80301
                   NEXT FIELD oga04
              WHEN INFIELD(oga13)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_ool"
                  #CHI-A50002 mark --start--
                   #LET g_qryparam.default1 = g_oga.oga13
                   #CALL cl_create_qry() RETURNING g_oga.oga13
                   #DISPLAY BY NAME g_oga.oga13
                  #CHI-A50002 mark --end--
                  #CHI-A50002 add --start--
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oga13
                  #CHI-A50002 add --end--
                   NEXT FIELD oga13
              WHEN INFIELD(oga14)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_gen"
                   LET g_qryparam.default1 = g_oga.oga14
                  #MOD-C60172----S----
                  #CALL cl_create_qry() RETURNING g_oga.oga14
                  #DISPLAY BY NAME g_oga.oga14 
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oga14
                  #MOD-C60172----E----
                   NEXT FIELD oga14
              WHEN INFIELD(oga15)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_gem"
                   LET g_qryparam.default1 = g_oga.oga15
                  #MOD-C60172----S----
                  #CALL cl_create_qry() RETURNING g_oga.oga15
                  #DISPLAY BY NAME g_oga.oga15
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oga15
                  #MOD-C60172----E----
                   NEXT FIELD oga15
              WHEN INFIELD(oga21)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_gec"
                    LET g_qryparam.arg1 = '2'  #No.MOD-480191
                   LET g_qryparam.default1 = g_oga.oga21
                  #MOD-C60172----S----
                  #CALL cl_create_qry() RETURNING g_oga.oga21
                  #DISPLAY BY NAME g_oga.oga21 
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oga21 
                  #MOD-C60172----E----
                   NEXT FIELD oga21
              WHEN INFIELD(oga23)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_azi"
                   LET g_qryparam.default1 = g_oga.oga23
                  #MOD-C60172----S----
                  #CALL cl_create_qry() RETURNING g_oga.oga23
                  #DISPLAY BY NAME g_oga.oga23 
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oga23 
                  #MOD-C60172----E----
                   NEXT FIELD oga23
              WHEN INFIELD(oga25)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_oab"
                   LET g_qryparam.default1 = g_oga.oga25 
                  #MOD-C60172----S----
                  #CALL cl_create_qry() RETURNING g_oga.oga25
                  #DISPLAY BY NAME g_oga.oga25 
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oga25 
                  #MOD-C60172----E----
                   NEXT FIELD oga25
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
 
      EXIT WHILE
    END WHILE
    #FUN-C30289---begin
    IF cl_null(g_wc) THEN
       LET g_wc = '1=1'
    END IF 
    #FUN-C30289---end
 
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ogauser', 'ogagrup')
 
    LET g_wc = g_wc clipped," AND oga09 = '3'"    #單據別為無訂單出貨
    CONSTRUCT g_wc2 ON ogb03, ogb04, ogb06, ogb092,ogb1001,ogb17,        #CHI-6B0027 mod  #No.FUN-660073
                       ogb09, ogb091,ogb05, ogb12, ogb913,ogb914,
                       ogb915,ogb910,ogb911,ogb912,ogb916,ogb917,
                       ogb41,ogb42,ogb43,                          #FUN-810045 add
                       ogb37,ogb13, ogb14, ogb14t,ogb930,ogb908  #no.A050 #FUN-670063#FUN-AB0061
                       ,ogbud01,ogbud02,ogbud03,ogbud04,ogbud05
                       ,ogbud06,ogbud07,ogbud08,ogbud09,ogbud10
                       ,ogbud11,ogbud12,ogbud13,ogbud14,ogbud15
                       ,ogbiicd07  #FUN-C30289
            FROM s_ogb[1].ogb03, s_ogb[1].ogb04, s_ogb[1].ogb06,
                 s_ogb[1].ogb092,s_ogb[1].ogb1001,s_ogb[1].ogb17,                 #CHI-6B0027 mod  #No.FUN-660073
                 s_ogb[1].ogb09, s_ogb[1].ogb091,s_ogb[1].ogb05,
                 s_ogb[1].ogb12, s_ogb[1].ogb913,s_ogb[1].ogb914,
                 s_ogb[1].ogb915,s_ogb[1].ogb910,s_ogb[1].ogb911,
                 s_ogb[1].ogb912,s_ogb[1].ogb916,s_ogb[1].ogb917,
                 s_ogb[1].ogb41, s_ogb[1].ogb42, s_ogb[1].ogb43,   #FUN-810045 add
                 s_ogb[1].ogb37,s_ogb[1].ogb13, s_ogb[1].ogb14, s_ogb[1].ogb14t,#FUN-AB0061
                 s_ogb[1].ogb930,s_ogb[1].ogb908  #no.A050 #FUN-670063
                 ,s_ogb[1].ogbud01,s_ogb[1].ogbud02,s_ogb[1].ogbud03,s_ogb[1].ogbud04,s_ogb[1].ogbud05
                 ,s_ogb[1].ogbud06,s_ogb[1].ogbud07,s_ogb[1].ogbud08,s_ogb[1].ogbud09,s_ogb[1].ogbud10
                 ,s_ogb[1].ogbud11,s_ogb[1].ogbud12,s_ogb[1].ogbud13,s_ogb[1].ogbud14,s_ogb[1].ogbud15
                 ,s_ogb[1].ogbiicd07   #FUN-C30289
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
        ON ACTION controlp
           CASE
              WHEN INFIELD(ogb04)
#FUN-AA0059---------mod------------str-----------------
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.state = "c"
#                  LET g_qryparam.form ="q_ima"
#                  LET g_qryparam.default1 = g_ogb[1].ogb04
#                  CALL cl_create_qry() RETURNING g_ogb[1].ogb04
                   CALL q_sel_ima(TRUE, "q_ima","",g_ogb[1].ogb04,"","","","","",'')  
                 #   RETURNING g_ogb[1].ogb04                            #TQC-C60227 mark
#FUN-AA0059---------mod------------end------------------
                 #  DISPLAY BY NAME g_ogb[1].ogb04     #No.MOD-490371    #TQC-C60227 mark
                    RETURNING g_qryparam.multiret                        #TQC-C60227
                   DISPLAY g_qryparam.multiret TO ogb04                  #TQC-C60227
                   NEXT FIELD ogb04
              WHEN INFIELD(ogb05)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_ogb051"
                   LET g_qryparam.default1 = g_ogb[1].ogb05
                  #CALL cl_create_qry() RETURNING g_ogb[1].ogb05         #TQC-C60227 mark
                    DISPLAY BY NAME g_ogb[1].ogb05                       #TQC-C60227 mark
                   CALL cl_create_qry() RETURNING g_qryparam.multiret    #TQC-C60227
                 DISPLAY g_qryparam.multiret TO ogb05                    #TQC-C60227
                   NEXT FIELD ogb05
              WHEN INFIELD(ogb908)
                 CALL q_coc2(TRUE,TRUE,g_ogb[1].ogb908,'',g_oga.oga02,'0',
                             '',g_ogb[1].ogb04)
                #RETURNING g_ogb[1].ogb908                               #TQC-C60227 mark
                #DISPLAY BY NAME g_ogb[1].ogb908                         #TQC-C60227 mark
                 RETURNING g_qryparam.multiret                           #TQC-C60227
                   DISPLAY g_qryparam.multiret TO ogb908                 #TQC-C60227
                 NEXT FIELD ogb908
 
              WHEN INFIELD(ogb1001)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_azf01a" #No.FUN-930104 
                 LET g_qryparam.arg1 ="1"        #No.FUN-930104
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ogb1001
                 NEXT FIELD ogb1001
 
               WHEN INFIELD(ogb09) 
#No.FUN-AA0062  --Begin 
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.form     = "q_imd"
#                   LET g_qryparam.state    = "c"
#                   LET g_qryparam.arg1     = 'SW'        #倉庫類別 
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   CALL q_imd_1(TRUE,TRUE,g_ogb[1].ogb09,"","","","") RETURNING g_qryparam.multiret
#No.FUN-AA0062  --End
                   DISPLAY g_qryparam.multiret TO ogb09
                   NEXT FIELD ogb09
#No.FUN-AA0062  --Begin
              WHEN INFIELD(ogb091)
                   CALL q_ime_1(TRUE,TRUE,g_ogb[1].ogb091,g_ogb[1].ogb09,"","","","","") RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ogb091
                   NEXT FIELD ogb091
#No.FUN-AA0062  --End
              WHEN INFIELD(ogb913)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_gfe"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ogb913
                 NEXT FIELD ogb913
 
              WHEN INFIELD(ogb910)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_gfe"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ogb910
                 NEXT FIELD ogb910
 
              WHEN INFIELD(ogb916)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_gfe"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ogb916
                 NEXT FIELD ogb916
              WHEN INFIELD(ogb41)  #專案代號
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_pja2"
                LET g_qryparam.state = "c"   #多選
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ogb41
                NEXT FIELD ogb41
              WHEN INFIELD(ogb42)  #WBS
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_pjb4"
                LET g_qryparam.state = "c"   #多選
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ogb42
                NEXT FIELD ogb42
              WHEN INFIELD(ogb43)  #活動
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_pjk3"
                LET g_qryparam.state = "c"   #多選
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ogb43
                NEXT FIELD ogb43
              WHEN INFIELD(ogb930)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_gem4"
                 LET g_qryparam.state = "c"   #多選
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ogb930
                 NEXT FIELD ogb930
              #FUN-C30289---begin
              WHEN INFIELD(ogbiicd07)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_icd3"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ogbiicd07
                  NEXT FIELD ogbiicd07
              #FUN-C30289---end                                    
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
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    END IF #No.TQC-630066
 
   #IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF       #No.TQC-D40060   Mark
    IF INT_FLAG THEN RETURN END IF                      #No.TQC-D40060   Add
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT  oga01 FROM oga_file",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY 1"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE oga_file. oga01 ",
                   "  FROM oga_file, ogb_file",
                   " WHERE oga01 = ogb01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY 1"
    END IF
 
    PREPARE t650_prepare FROM g_sql
    DECLARE t650_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t650_prepare
    DECLARE t650_fill_cs CURSOR FOR t650_prepare       #FUN-CB0014   
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM oga_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT oga01) FROM oga_file,ogb_file WHERE ",
                  "ogb01=oga01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE t650_precount FROM g_sql
    DECLARE t650_count CURSOR FOR t650_precount
END FUNCTION
 
FUNCTION t650_menu()
DEFINE l_wc     LIKE type_file.chr1000       #No.TQC-610089 add  #No.FUN-680137 VARCHAR(200)
   DEFINE l_yy,l_mm     LIKE type_file.num5  #CHI-C70017
#DEFINE l_oia07     LIKE oia_file.oia07       #FUN-C50136
   WHILE TRUE
      #CALL t650_bp("G")  #FUN_CB0014
      #FUN-CB0014---add-str--- 
      CASE
         WHEN (g_action_flag IS NULL) OR (g_action_flag = "main")
            CALL t650_bp("G")
         WHEN (g_action_flag = "info_list")
            CALL t650_list_fill()
            CALL t650_bp1("G")
            IF NOT cl_null(g_action_choice) AND l_ac2>0 THEN #將清單的資料回傳到主畫面
               SELECT oga_file.*
                 INTO g_oga.*
                 FROM oga_file
                WHERE oga01=g_oga_l[l_ac2].oga01
            END IF
            IF g_action_choice!= "" THEN
               LET g_action_flag = 'main'
               LET l_ac2 = ARR_CURR()
               LET g_jump = l_ac2
               LET mi_no_ask = TRUE
               IF g_rec_b2 >0 THEN
                   CALL t650_fetch('/')
               END IF
               CALL cl_set_comp_visible("page_in", FALSE)
               CALL cl_set_comp_visible("info", FALSE)
               CALL ui.interface.refresh()
               CALL cl_set_comp_visible("page_in", TRUE)
               CALL cl_set_comp_visible("info", TRUE)
             END IF               
      END CASE
      #FUN-CB0014---add---str--       
      CASE g_action_choice
 
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t650_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t650_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t650_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t650_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t650_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
             IF cl_chk_act_auth() AND NOT cl_null(g_oga.oga01) THEN
                LET g_no=g_oga.oga01
 
                        LET l_wc='oga01="',g_no,'"'
                       # LET g_msg = "axmr600",#FUN-C30085 mark
                        LET g_msg = "axmg600",  #FUN-C30085 add
                                     " '",g_today CLIPPED,"' ''",
                                     " '",g_lang CLIPPED,"' 'Y' '' '1'",
                                     #" '",l_wc CLIPPED,"' "                            #MOD-B90173 mark
                                     " '",l_wc CLIPPED,"' '1' 'Y' 'Y' 'Y' 'Y' 'Y' "     #MOD-B90173 add
                        CALL cl_cmdrun(g_msg)
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "address"
            IF cl_chk_act_auth() THEN
               CALL t650_1()
            END IF
         WHEN "other_data"
            IF cl_chk_act_auth() THEN
               CALL t650_2()
            END IF
         WHEN "entry_sheet"
            IF cl_chk_act_auth() THEN
              #CALL t650_3()    #CHI-AC0002 mark
               CALL t650_3('0') #CHI-AC0002
            END IF
         #CHI-AC0002 add --start--
         WHEN "entry_sheet2"
            IF cl_chk_act_auth() THEN
               CALL t650_3('1')
            END IF
         #CHI-AC0002 add --end--
         WHEN "gen_entry"
            CALL t650_v()
         WHEN "query_delivery"
            CALL s_shpqry(g_oga.oga01)
         WHEN "order_query"
            CALL s_ordqry(g_oga.oga16)
         WHEN "query_customer"
#           IF g_oaz.oaz96 = 'Y' THEN                         #FUN-C50136
#              LET g_msg = 'axmq274 ',g_oga.oga03             #FUN-C50136
#              CALL cl_cmdrun(g_msg)                          #FUN-C50136
#           ELSE                                              #FUN-C50136
              CALL s_cusqry(g_oga.oga03,'')  #CHI-B60094 add ''
#           END IF                                            #FUN-C50136
         WHEN "memo"
            IF cl_chk_act_auth() THEN
               CALL t650_m()
            END IF
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
              #CALL t650_y()                                       #FUN-B10004 mark
               CALL t650sub_y(g_oga.oga01)                         #FUN-B10004 add
               CALL t650sub_refresh(g_oga.oga01) RETURNING g_oga.* #FUN-B10004 add
               CALL t650_show()                                    #FUN-B10004 add
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t650_z()
            END IF
         WHEN "deduct_inventory"
            IF cl_chk_act_auth() THEN
              #CALL t650_s('2')                                    #FUN-B10004 mark
               CALL t650sub_s('2',g_oga.oga01)                     #FUN-B10004 add
               CALL t650sub_refresh(g_oga.oga01) RETURNING g_oga.* #FUN-B10004 add
               CALL t650_show()                                    #FUN-B10004 add
              #FUN-B10004---mark---str---
              #IF g_oga.ogaconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
              #CALL cl_set_field_pic(g_oga.ogaconf,"",g_oga.ogapost,"",g_chr,"")
              #FUN-B10004---mark---end---
            END IF
         WHEN "undo_deduct"
            IF cl_chk_act_auth() THEN
               IF g_oga.ogapost='N' THEN
                  CALL cl_err('','axm-206',0)
               ELSE
                 IF NOT cl_null(g_oga.oga10) THEN
                    CALL cl_err('','axm-302',1)
                    CONTINUE WHILE
                 END IF
                 #CHI-C70017---begin
                 IF g_oaz.oaz03 = 'Y' AND
                    g_sma.sma53 IS NOT NULL AND g_oga.oga02 <= g_sma.sma53 THEN
                    CALL cl_err('','mfg9999',0) 
                    CONTINUE WHILE
                 END IF
                 CALL s_yp(g_oga.oga02) RETURNING l_yy,l_mm
                 IF ((l_yy*12+l_mm) > (g_sma.sma51*12+g_sma.sma52)) THEN
                    CALL cl_err('','mfg6090',0)
                    CONTINUE WHILE
                 END IF
                 #CHI-C70017---end
                 #FUN-CA0084--add--str
                 LET g_errno =''
                 CALL t650_axmt670()
                 IF NOT cl_null(g_errno) THEN 
                    CALL cl_err('',g_errno,1)
                    CONTINUE WHILE
                 END IF  
                 #FUN-CA0084--add--end
                 LET g_msg="axmp650 '",g_oga.oga01,"'" CLIPPED
                 CALL cl_cmdrun_wait(g_msg)
#                #FUN-C50136--add--str--
#                IF g_oaz.oaz96 ='Y' THEN 
#                   CALL s_ccc_oia07('E',g_oga.oga03) RETURNING l_oia07
#                   IF l_oia07 = '1' THEN 
#                      CALL s_ccc_rback(g_oga.oga03,'E',g_oga.oga01,0,'')
#                   END IF
#                END IF
#                #FUN-C50136--add--end--  
               END IF
               SELECT ogapost INTO g_oga.ogapost FROM oga_file
               WHERE oga01=g_oga.oga01
               DISPLAY BY NAME g_oga.ogapost
               IF g_oga.ogaconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF  #MOD-7A0178
               CALL cl_set_field_pic(g_oga.ogaconf,"",g_oga.ogapost,"",g_chr,"")
            END IF
         WHEN "ar_carry"
            IF cl_chk_act_auth() THEN
              #CALL t650_gui()                                     #FUN-B10004 mark
               #FUN-CA0084--add--str
               SELECT oaz92,oaz93 INTO g_oaz.oaz92,g_oaz.oaz93 FROM oaz_file
               IF g_oaz.oaz92 = 'Y' AND g_aza.aza26 = '2' THEN
                  CALL cl_err('','axm-535',1)
                  CONTINUE WHILE
               END IF
               #FUN-CA0084--add--end
               CALL t650sub_gui()                                  #FUN-B10004 add
               CALL t650sub_refresh(g_oga.oga01) RETURNING g_oga.* #FUN-B10004 add
               CALL t650_show()                                    #FUN-B10004 add
            END IF
         WHEN "mntn_ar"
            IF NOT cl_null(g_oga.oga10) THEN   #<--MODIFY:2590--
               LET g_msg="axrt300 '",g_oga.oga10,"'"," '12'"
               CALL cl_cmdrun_wait(g_msg)
               SELECT * INTO g_oga.* FROM oga_file
               WHERE oga01=g_oga.oga01
               DISPLAY BY NAME g_oga.oga10
            END IF                             #<------------
          WHEN "release_ov_lmt_credit"
             IF cl_chk_act_auth() THEN
                CALL t650_c()
             END IF
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL t650_x()    #FUN-D20025
               CALL t650_x(1)   #FUN-D20025
            END IF
         #FUN-D20025--add--str--
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t650_x(2)
            END IF
         #FUN-D20025--add--end--
#FUN-BB0167 add begin----------------------------
         WHEN "gen_on_check_note"
            IF cl_chk_act_auth() THEN
               IF g_oga.oga55 = 'S' THEN
                  CALL cl_err('','apm-228',0)
               ELSE
                  CALL t650_gen_check_note()
               END IF
            END IF
#FUN-BB0167 add end------------------------------
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
             #CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ogb),'','')  #FUN-CB0014
               #FUN-CB0014---add---str---
               LET w = ui.Window.getCurrent()
               LET f = w.getForm()
               IF cl_null(g_action_flag) OR g_action_flag = "main" THEN
                  LET page = f.FindNode("Page","page_m")
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_ogb),'','')
               END IF
               IF g_action_flag = "info_list" THEN
                  LET page = f.FindNode("Page","page_in")
                     CALL cl_export_to_excel(page,base.TypeInfo.create(g_oga_l),'','')
               END IF
               #FUN-CB0014---add---end---
            END IF
 
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_oga.oga01 IS NOT NULL THEN
                 LET g_doc.column1 = "oga01"
                 LET g_doc.value1 = g_oga.oga01
                 CALL cl_doc()
               END IF
         END IF
 
         WHEN "qry_mntn_inv_detail"
            IF g_sma.sma115 = 'Y' THEN
               CALL t650_b_ogg_1()
            ELSE
               CALL t650_b_ogc_1()
            END IF
        WHEN "qry_lot"
           SELECT ima918,ima921 INTO g_ima918,g_ima921 
             FROM ima_file
            WHERE ima01 = g_ogb[l_ac].ogb04
              AND imaacti = "Y"

           #MOD-CA0220 -- add start --
           SELECT img09 INTO g_img09 FROM img_file
            WHERE img01=g_ogb[l_ac].ogb04
              AND img02=g_ogb[l_ac].ogb09
              AND img03=g_ogb[l_ac].ogb091
              AND img04=g_ogb[l_ac].ogb092
           LET b_ogb.ogb05_fac = 1
           CALL s_umfchk(g_ogb[l_ac].ogb04,g_ogb[l_ac].ogb05,g_img09)
                RETURNING g_cnt,b_ogb.ogb05_fac
           IF g_cnt=1 THEN LET b_ogb.ogb05_fac = 1 END IF
           #MOD-CA0220 -- add end --
           
           IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
              CALL t650_b_move_back()
              CALL t650_b_else()
              LET g_success = 'Y'              #CHI-A10016
              BEGIN WORK                       #CHI-A10016
             #CALL s_lotout(g_prog,g_oga.oga01,g_ogb[l_ac].ogb03,0,             #TQC-B90236 mark
              CALL s_mod_lot(g_prog,g_oga.oga01,g_ogb[l_ac].ogb03,0,             #TQC-B90236 add
                            g_ogb[l_ac].ogb04,g_ogb[l_ac].ogb09,
                            g_ogb[l_ac].ogb091,g_ogb[l_ac].ogb092,
                            g_ogb[l_ac].ogb05,g_img09,b_ogb.ogb05_fac,
                            g_ogb[l_ac].ogb12,'','QRY',-1)#CHI-9A0022 add ''    #TQC-B90236 add '-1'
                  RETURNING l_r,g_qty
             #-CHI-A10016-add-
              IF g_success = "Y" THEN
                 COMMIT WORK
              ELSE
                 ROLLBACK WORK    
              END IF
             #-CHI-A10016-end-
           END IF
           
#FUN-A60035 ---MARK BEGIN
#       #FUN-A50054 --Begin
#       WHEN "style_detail"
#          IF l_ac>0 THEN
#             IF g_sma.sma120='Y' THEN
#             CALL s_detail(g_prog,g_oga.oga01,g_ogb[l_ac].ogb03,g_ogb[l_ac].ogb04,'Y')
#             RETURNING g_ogb[l_ac].ogb12
#             END IF
#          END IF
#       #FUN-A50054 --End
#FUN-A60035 ---MARK END
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION t650_a()
    DEFINE l_oap	RECORD LIKE oap_file.*
    DEFINE li_result    LIKE type_file.num5                    #No.FUN-550052  #No.FUN-680137 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_ogb.clear()
    INITIALIZE g_oga.* TO NULL
    LET g_oga_o.* = g_oga.*
    LET g_oga_t.* = g_oga.*                #保存單頭舊值  #FUN-B50026 add
    CALL cl_opmsg('a')
    WHILE TRUE
        IF NOT cl_null(g_argv1) AND (g_argv2 = "insert") THEN
           LET g_oga.oga01 = g_argv1
        END IF     
        LET g_oga.oga00  ='1'
        LET g_oga.oga06  = g_oaz.oaz41
        LET g_oga.oga07  ='N'     #MOD-860254 add
        LET g_oga.oga08  ='1'
        LET g_oga.oga69  =g_today  #No.FUN-950062
        LET g_oga.oga02  =g_today
        LET g_oga.oga14  =g_user
        LET g_oga.oga15  =g_grup
        LET g_oga.oga161 =0
        LET g_oga.oga162 =100
        LET g_oga.oga163 =0
        LET g_oga.oga20  ='Y'
        LET g_oga.oga211 =0
        LET g_oga.oga50  =0
        LET g_oga.oga52  =0
        LET g_oga.oga53  =0
        LET g_oga.oga54  =0
        LET g_oga.oga903 = 'N'    #No.B325 add    #No.B325 add
        LET g_oga.ogaconf='N'
        LET g_oga.oga30  ='N'
        LET g_oga.oga65  ='N'   #FUN-650141 add
        LET g_oga.ogapost='N'
        LET g_oga.ogaprsw=0
        LET g_oga.ogauser=g_user
        LET g_oga.ogaoriu = g_user #FUN-980030
        LET g_oga.ogaorig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_oga.ogagrup=g_grup
        LET g_oga.ogadate=g_today
        LET g_oga.ogaplant = g_plant #FUN-980010 add
        LET g_oga.ogalegal = g_legal #FUN-980010 add
        CALL t650_i("a")                #輸入單頭
        IF INT_FLAG THEN
           INITIALIZE g_oga.* TO NULL
           LET INT_FLAG=0 CALL cl_err('',9001,0)
           ROLLBACK WORK EXIT WHILE
        END IF
        IF g_oga.oga01 IS NULL THEN CONTINUE WHILE END IF
 
        BEGIN WORK     #No:7829
        CALL s_auto_assign_no("axm",g_oga.oga01,g_oga.oga02,"50","oga_file","oga01","","","")
          RETURNING li_result,g_oga.oga01
        IF (NOT li_result) THEN
           ROLLBACK WORK
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_oga.oga01
 
        LET g_oga.oga09 = '3'
 
   IF cl_null(g_oga.oga85) THEN
      LET g_oga.oga85=' '
   END IF
   IF cl_null(g_oga.oga94) THEN
      LET g_oga.oga94='N'
   END IF
   #FUN-AC0055 add ---------------------begin-----------------------
   IF cl_null(g_oga.oga57) THEN
      LET g_oga.oga57 = '1'  
   END IF
   #FUN-AC0055 add ----------------------end------------------------ 
        #TQC-C20185 add
        IF cl_null(g_oga.ogaslk02) THEN
           LET g_oga.ogaslk02 = '1'
        END IF
        #TQC-C20185 add--end
        INSERT INTO oga_file VALUES (g_oga.*)
        IF STATUS OR SQLCA.SQLCODE THEN
           CALL cl_err3("ins","oga_file",g_oga.oga01,"",SQLCA.SQLCODE,"","insert oga_file",1)  #No.FUN-660167
           ROLLBACK WORK     #No:7829
           CONTINUE WHILE
        END IF
 
        COMMIT WORK     #No:7829
 
        CALL cl_flow_notify(g_oga.oga01,'I')
 
        SELECT oga01 INTO g_oga.oga01 FROM oga_file WHERE oga01 = g_oga.oga01
 
        CALL s_addr(g_oga.oga01,g_oga.oga04,g_oga.oga044)
             RETURNING l_oap.oap041,l_oap.oap042,l_oap.oap043,l_oap.oap044,l_oap.oap045  #FUN-720014 add oap044/045
        LET g_msg=l_oap.oap041 CLIPPED,' ',l_oap.oap042 CLIPPED,' ',
                  l_oap.oap043 CLIPPED,' ',
                  l_oap.oap044 CLIPPED,' ',l_oap.oap045 CLIPPED  #FUN-720014 add
        DISPLAY g_msg TO addr
        LET g_oga_t.* = g_oga.*
 
        CALL g_ogb.clear()
        LET g_rec_b = 0
 
 
        CALL t650_b()                 #由訂單自動產生單身
        IF g_oga.oga09 ='3' AND g_oga.oga07 = 'Y' THEN
           IF cl_confirm('anm-229') THEN CALL t650_v() END IF
        END IF
 
        # 新增自動確認功能 Modify by WUPN 96-05-06 ----------
        LET g_t1=s_get_doc_no(g_oga.oga01)      #No.FUN-550052
        SELECT * INTO g_oay.* FROM oay_file WHERE oayslip=g_t1
        IF STATUS THEN CALL cl_err('sel oay_file',STATUS,0) END IF
        IF g_oay.oayconf='Y' THEN #單據需自動確認
          #CALL t650_y()                                       #FUN-B10004 mark
           CALL t650sub_y(g_oga.oga01)                         #FUN-B10004 add
           CALL t650sub_refresh(g_oga.oga01) RETURNING g_oga.* #FUN-B10004 add
           CALL t650_show()                                    #FUN-B10004 add
        END IF
 
        IF g_oay.oayprnt='Y' THEN CALL t650_out() END IF   #單據需立即列印
 
        EXIT WHILE
 
    END WHILE

   #CHI-AC0002 add --start--
   CALL cl_set_act_visible("entry_sheet2",TRUE)
   IF g_aza.aza63 = 'N' THEN
      CALL cl_set_act_visible("entry_sheet2",FALSE)
   END IF
   #CHI-AC0002 add --end--
 
END FUNCTION
 
FUNCTION t650_u()
    DEFINE l_oap	RECORD LIKE oap_file.*
    IF s_shut(0) THEN RETURN END IF
    SELECT * INTO g_oga.* FROM oga_file WHERE oga01 = g_oga.oga01
    IF g_oga.oga01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_oga.ogaconf = 'Y' THEN CALL cl_err('','axm-101',0) RETURN END IF
    IF g_oga.ogaconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF #No.+182
    IF g_oga.oga54 != 0 THEN CALL cl_err('','axm-160',0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_oga_o.* = g_oga.*
 
    BEGIN WORK
 
    OPEN t650_cl USING g_oga.oga01
    IF STATUS THEN
       CALL cl_err("OPEN t650_cl:", STATUS, 1)
       CLOSE t650_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH t650_cl INTO g_oga.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_oga.oga01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t650_cl ROLLBACK WORK RETURN
    END IF
 
    CALL t650_show()
    WHILE TRUE
        LET g_oga.ogamodu=g_user
        LET g_oga.ogadate=g_today
        CALL t650_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_oga.*=g_oga_t.*
            CALL t650_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        UPDATE oga_file SET * = g_oga.* WHERE oga01 = g_oga_t.oga01
        IF STATUS OR SQLCA.SQLCODE THEN
           CALL cl_err(g_oga.oga01,SQLCA.SQLCODE,0)
           CONTINUE WHILE
        END IF
        IF g_oga.oga01 != g_oga_t.oga01 THEN CALL t650_chkkey() END IF
        CALL s_addr(g_oga.oga01,g_oga.oga04,g_oga.oga044)
             RETURNING l_oap.oap041,l_oap.oap042,l_oap.oap043,l_oap.oap044,l_oap.oap045  #FUN-720014 add 044/045
        LET g_msg=l_oap.oap041 CLIPPED,' ',l_oap.oap042 CLIPPED,' ',
                  l_oap.oap043 CLIPPED,' ',
                  l_oap.oap044 CLIPPED,' ',l_oap.oap045 CLIPPED   #FUN-720014
        DISPLAY g_msg TO addr
        EXIT WHILE
    END WHILE
    CLOSE t650_cl
    COMMIT WORK
    CALL cl_flow_notify(g_oga.oga01,'U')
 
# 新增自動確認功能 Modify by WUPN 96-10-15 ----------
    LET g_t1=s_get_doc_no(g_oga.oga01)        #No.FUN-550052
    SELECT * INTO g_oay.* FROM oay_file WHERE oayslip=g_t1
    IF STATUS THEN CALL cl_err('sel oay_file',STATUS,0) RETURN END IF
    IF g_oay.oayconf='N' #單據不需自動確認
       THEN RETURN
    ELSE 
       #CALL t650_y()                                       #FUN-B10004 mark
        CALL t650sub_y(g_oga.oga01)                         #FUN-B10004 add
        CALL t650sub_refresh(g_oga.oga01) RETURNING g_oga.* #FUN-B10004 add
        CALL t650_show()                                    #FUN-B10004 add
    END IF
    IF g_oay.oayprnt='Y' THEN CALL t650_out() END IF   #單據需立即列印
 
END FUNCTION
 
FUNCTION t650_chkkey()
           UPDATE ogb_file SET ogb01=g_oga.oga01 WHERE ogb01=g_oga_t.oga01
           IF STATUS OR SQLCA.SQLCODE THEN
              CALL cl_err3("upd","ogb_file",g_oga_t.oga01,"",SQLCA.SQLCODE,"","upd ogb01",1)  #No.FUN-660167
              LET g_oga.*=g_oga_t.* CALL t650_show() ROLLBACK WORK RETURN
           END IF
           UPDATE ogc_file SET ogc01=g_oga.oga01 WHERE ogc01=g_oga_t.oga01
           IF STATUS OR SQLCA.SQLCODE THEN
              CALL cl_err3("upd","ogc_file",g_oga_t.oga01,"",SQLCA.SQLCODE,"","upd ogc01",1)  #No.FUN-660167
              LET g_oga.*=g_oga_t.* CALL t650_show() ROLLBACK WORK RETURN
           END IF
           UPDATE oao_file SET oao01=g_oga.oga01 WHERE oao01=g_oga_t.oga01
           IF STATUS OR SQLCA.SQLCODE THEN
              CALL cl_err3("upd","oao_file",g_oga_t.oga01,"",SQLCA.SQLCODE,"","upd oao01",1)  #No.FUN-660167
              LET g_oga.*=g_oga_t.* CALL t650_show() ROLLBACK WORK RETURN
           END IF
           UPDATE oap_file SET oap01=g_oga.oga01 WHERE oap01=g_oga_t.oga01
           IF STATUS OR SQLCA.SQLCODE THEN
              CALL cl_err3("upd","oap_file",g_oga_t.oga01,"",SQLCA.SQLCODE,"","upd oap01",1)  #No.FUN-660167
              LET g_oga.*=g_oga_t.* CALL t650_show() ROLLBACK WORK RETURN
           END IF
END FUNCTION
 
#處理INPUT
FUNCTION t650_i(p_cmd)
  DEFINE p_cmd           LIKE type_file.chr1                  #a:輸入 u:更改  #No.FUN-680137 VARCHAR(1)
  DEFINE l_flag          LIKE type_file.chr1                 #判斷必要欄位是否有輸入  #No.FUN-680137 VARCHAR(1)
  DEFINE l_n1            LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE l_occ           RECORD LIKE occ_file.*
  DEFINE l_oap           RECORD LIKE oap_file.*
  DEFINE l_yy,l_mm       LIKE type_file.num10   #No.FUN-680137 INTEGER
  DEFINE l_gem02         LIKE gem_file.gem02
  DEFINE l_gen02         LIKE gen_file.gen02
  DEFINE l_gen03         LIKE gen_file.gen03
  DEFINE li_result       LIKE type_file.num5    #No.FUN-550052  #No.FUN-680137 SMALLINT
  DEFINE l_oga15         LIKE oga_file.oga15  #MOD-590068
#FUN-BB0167 add begin--------------------------
  DEFINE l_occ20         LIKE occ_file.occ20
  DEFINE l_occ21         LIKE occ_file.occ21
  DEFINE l_occ22         LIKE occ_file.occ22
  DEFINE l_occ44         LIKE occ_file.occ44
  DEFINE l_oat05         LIKE oat_file.oat05
  DEFINE l_oma11         LIKE oma_file.oma11
#FUN-BB0167 add end----------------------------

    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
    INPUT BY NAME g_oga.ogaoriu,g_oga.ogaorig,
        g_oga.oga00 ,g_oga.oga08 ,g_oga.oga01,g_oga.oga69,g_oga.oga02,    #No.FUN-950062  add g_oga.oga69
        g_oga.oga03 ,g_oga.oga032,g_oga.oga04,g_oga.oga18,      #No.TQC-620115 add oga18
        g_oga.oga021,g_oga.oga14 ,g_oga.oga15,g_oga.oga903,
        g_oga.ogaconf,g_oga.oga30,g_oga.ogapost,
        g_oga.oga25,g_oga.oga23,g_oga.oga24,g_oga.oga21,
        g_oga.oga211,g_oga.oga212,g_oga.oga213,
        g_oga.oga13,g_oga.oga05,g_oga.oga10,
        g_oga.oga65,g_oga.oga72,g_oga.oga50,                 #FUN-BB0167 add g_oga.oga65,g_oga.oga72
        g_oga.ogauser,g_oga.ogagrup,g_oga.ogamodu,g_oga.ogadate, 
        g_oga.ogaud01,g_oga.ogaud02,g_oga.ogaud03,g_oga.ogaud04,
        g_oga.ogaud05,g_oga.ogaud06,g_oga.ogaud07,g_oga.ogaud08,
        g_oga.ogaud09,g_oga.ogaud10,g_oga.ogaud11,g_oga.ogaud12,
        g_oga.ogaud13,g_oga.ogaud14,g_oga.ogaud15 
           WITHOUT DEFAULTS
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL t650_set_entry(p_cmd)
           CALL t650_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
           CALL cl_set_docno_format("oga01")      #No.FUN-550052
 
        AFTER FIELD oga00
           IF NOT cl_null(g_oga.oga00) THEN
              IF g_oga.oga00 NOT MATCHES '[1]' THEN NEXT FIELD oga00 END IF
           END IF
 
        AFTER FIELD oga08
           IF NOT cl_null(g_oga.oga08) THEN
              IF g_oga.oga08 NOT MATCHES '[123]' THEN NEXT FIELD oga08 END IF
              IF g_oga.oga08='1' THEN
                 LET exT=g_oaz.oaz52
              ELSE
                 LET exT=g_oaz.oaz70
              END IF
           END IF
 
        AFTER FIELD oga01
           IF NOT cl_null(g_oga.oga01) THEN
              CALL s_check_no("axm",g_oga.oga01,g_oga_t.oga01,"50","oga_file","oga01","")
                RETURNING li_result,g_oga.oga01
              DISPLAY BY NAME g_oga.oga01
              IF (NOT li_result) THEN
                 NEXT FIELD oga01
              END IF
           END IF

        #start FUN-950062 add
        AFTER FIELD oga69
           IF NOT cl_null(g_oga.oga69) THEN
              IF NOT t600_chk_oga69() THEN
                 NEXT FIELD CURRENT
              END IF
           ELSE
              CALL cl_err('','-1124',0)
              NEXT FIELD oga69
           END IF
        #end FUN-950062 add
 
        AFTER FIELD oga02
          IF NOT cl_null(g_oga.oga02) THEN
             IF g_oga.oga02 <= g_oaz.oaz09 THEN
                CALL cl_err('','axm-164',0) NEXT FIELD oga02
             END IF
             IF g_oaz.oaz03 = 'Y' AND
                g_sma.sma53 IS NOT NULL AND g_oga.oga02 <= g_sma.sma53 THEN
                CALL cl_err('','mfg9999',0) NEXT FIELD oga02
             END IF
             CALL s_yp(g_oga.oga02) RETURNING l_yy,l_mm
             IF ((l_yy*12+l_mm) > (g_sma.sma51*12+g_sma.sma52)) THEN
                CALL cl_err('','mfg6090',0)
                NEXT FIELD oga02
             END IF
             CALL s_get_bookno(YEAR(g_oga.oga02)) RETURNING g_flag,g_bookno1,g_bookno2                                                         
               IF g_flag =  '1' THEN  #抓不到帳別                                                                                                
                  CALL cl_err(g_oga.oga02,'aoo-081',1)                                                                                           
               END IF             
              #TQC-BB0164--begin
              IF cl_null(g_oga.oga021) THEN
                 IF g_aza.aza17 != g_oga.oga23 THEN
                    IF p_cmd='u' AND g_oga_o.oga02 != g_oga.oga02 THEN
                       IF cl_confirm('apm-701') THEN
                          LET g_exdate = g_oga.oga02     #出貨日期
                          CALL s_curr3(g_oga.oga23,g_exdate,exT) RETURNING g_oga.oga24
                          DISPLAY BY NAME g_oga.oga24
                       END IF
                    END IF
                 END IF
              END IF
              #TQC-BB0164--end`                                                                                                               
          END IF
 
        AFTER FIELD oga021
          IF NOT cl_null(g_oga.oga021) THEN
             IF g_oga.oga021 <= g_oaz.oaz09 THEN
                CALL cl_err('','axm-164',0) NEXT FIELD oga021
             END IF
             #TQC-BB0164--begin
             IF g_aza.aza17 != g_oga.oga23 THEN
                IF p_cmd='u' AND g_oga_o.oga021 != g_oga.oga021 THEN
                   IF cl_confirm('apm-701') THEN
                      LET g_exdate = g_oga.oga021     #出貨日期
                      CALL s_curr3(g_oga.oga23,g_exdate,exT) RETURNING g_oga.oga24
                      DISPLAY BY NAME g_oga.oga24
                   END IF
                END IF
             END IF
             #TQC-BB0164--end
          END IF
 
        AFTER FIELD oga13
          IF NOT cl_null(g_oga.oga13) THEN
             SELECT * FROM ool_file WHERE ool01=g_oga.oga13
             IF STATUS THEN CALL cl_err('',STATUS,0) NEXT FIELD oga13 END IF
          END IF
        BEFORE FIELD oga18
           IF cl_null(g_oga.oga18) THEN
              LET g_oga.oga18 = g_oga.oga03
           END IF
           SELECT occ02 INTO g_buf FROM occ_file
            WHERE occ01=g_oga.oga18
           IF STATUS THEN
              LET g_buf =''
           END IF
           DISPLAY g_buf TO FORMONLY.oga18_ds
 
        AFTER FIELD oga18
           IF NOT cl_null(g_oga.oga18) THEN
              SELECT * FROM occ_file
               WHERE occ01 = g_oga.oga18
              IF STATUS THEN
                 CALL cl_err3("sel","occ_file",g_oga.oga18,"",STATUS,"","select occ",1)  #No.FUN-660167
                 NEXT FIELD oga18
              END IF
              SELECT occ02 INTO g_buf FROM occ_file
               WHERE occ01 = g_oga.oga18
                 AND occacti = 'Y'
              IF STATUS THEN
                 LET g_buf =''
              END IF
              DISPLAY g_buf TO FORMONLY.oga18_ds
           END IF
 
        BEFORE FIELD oga03
          CALL t650_set_no_entry(p_cmd)
 
        AFTER FIELD oga03
          IF NOT cl_null(g_oga.oga03) THEN
             SELECT * INTO l_occ.* FROM occ_file
              WHERE occ01=g_oga.oga03
                AND occacti='Y'
             IF SQLCA.sqlcode THEN
                CALL cl_err3("sel","l_occ.*",g_oga.oga03,"",STATUS,"","select occ",1)  #No.FUN-660167
                NEXT FIELD oga03
             END IF
 
             IF cl_null(g_oga.oga04) THEN
                LET g_oga.oga04 = l_occ.occ09
                SELECT occ02 INTO g_buf FROM occ_file WHERE occ01=g_oga.oga04
                DISPLAY BY NAME g_oga.oga04
                DISPLAY g_buf TO occ02
             END IF
             IF cl_null(g_oga.oga18) THEN
                LET g_oga.oga18 = l_occ.occ07
             END IF
             IF cl_null(g_oga.oga13) THEN
                LET g_oga.oga13 = l_occ.occ67
             END IF 
             IF cl_null(g_oga.oga31) THEN 
                LET g_oga.oga31 = l_occ.occ44
             END IF
 
             IF g_oga_o.oga03 <> g_oga.oga03 OR p_cmd = 'a' THEN
                 LET g_oga.oga05 = l_occ.occ08
                 LET g_oga.oga14 = l_occ.occ04
                 LET g_oga.oga21 = l_occ.occ41
                 LET g_oga.oga23 = l_occ.occ42
                 LET g_oga.oga25 = l_occ.occ43
                 LET g_oga.oga31 = l_occ.occ44  #MOD-940188
                 LET g_oga.oga32 = l_occ.occ45
             END IF
 
              IF NOT cl_null(g_oga.oga021) THEN
                 LET g_exdate = g_oga.oga021    #結關日期
              ELSE
                 LET g_exdate = g_oga.oga02     #出貨日期
              END IF 
              CALL s_curr3(g_oga.oga23,g_exdate,exT) RETURNING g_oga.oga24
 
             SELECT gec04,gec05,gec07 INTO g_oga.oga211,g_oga.oga212,g_oga.oga213
               FROM gec_file WHERE gec01=g_oga.oga21
                               AND gec011='2'  #銷項

             #CHI-CB0008 mark begin---
             #IF p_cmd = 'u' AND
             #  ((g_oga.oga213 != g_oga_t.oga213 OR g_oga_t.oga213 IS NULL)
             #  OR (g_oga.oga211 != g_oga_t.oga211 OR g_oga_t.oga211 IS NULL)) THEN
             #   CALL t650_upd_oga50()
             #END IF
             #CHI-CB0008 mark end-----

             #CHI-CB0008 add begin---
             IF p_cmd = 'u' THEN
                IF g_oga.oga211 != g_oga_t.oga211 OR g_oga_t.oga211 IS NULL THEN
                   CALL t650_upd_oga50('N')
                END IF
                IF (g_oga.oga211 = g_oga_t.oga211 AND g_oga.oga213 != g_oga_t.oga213) OR g_oga_t.oga213 IS NULL THEN
                   CALL t650_upd_oga50('Y')
                END IF
             END IF
             #CHI-CB0008 add end-----
 
             IF g_oga_o.oga03 <> g_oga.oga03 OR p_cmd = 'a' THEN  #MOD-590068
                 SELECT gen02,gen03 INTO l_gen02,l_gen03
                   FROM gen_file WHERE gen01 = l_occ.occ04
 
                 IF SQLCA.sqlcode THEN LET l_gen03 = ' ' END IF
                 LET g_oga.oga15 = l_gen03
                 SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=g_oga.oga15
                 DISPLAY l_gen02 TO FORMONLY.gen02
                 DISPLAY l_gem02 TO FORMONLY.gem02
                 DISPLAY BY NAME g_oga.oga05,g_oga.oga14,g_oga.oga21,g_oga.oga23,
                                 g_oga.oga25,g_oga.oga15
             END IF  #MOD-590068
 
             CALL t650_show()
 
             IF g_oga.oga03[1,4] != 'MISC' THEN
                LET g_oga.oga032 = l_occ.occ02 DISPLAY BY NAME g_oga.oga032
             END IF
          END IF
          CALL t650_set_no_entry(p_cmd)
 
        BEFORE FIELD oga04
          IF cl_null(g_oga.oga04) THEN LET g_oga.oga04 = g_oga.oga03 END IF
          DISPLAY BY NAME g_oga.oga03
 
        AFTER FIELD oga04
          IF NOT cl_null(g_oga.oga04) THEN
             SELECT occ02 INTO g_buf FROM occ_file
              WHERE occ01=g_oga.oga04
                AND occacti='Y'  #No.+182 add
             IF STATUS THEN
                CALL cl_err3("sel","occ_file",g_oga.oga04,"",STATUS,"","select occ",1)  #No.FUN-660167
                NEXT FIELD oga04
             END IF
             DISPLAY g_buf TO occ02
          END IF
 
        AFTER FIELD oga14
          IF NOT cl_null(g_oga.oga14) THEN
             SELECT gen02,gen03 INTO g_buf,l_oga15  #MOD-590068
               FROM gen_file WHERE gen01=g_oga.oga14
             IF STATUS THEN
                CALL cl_err3("sel","gen_file",g_oga.oga14,"",STATUS,"","select gen",1)  #No.FUN-660167
#               NEXT FIELD oga04   #MOD-B80301 mark
                NEXT FIELD oga14   #MOD-B80301
             END IF
             DISPLAY g_buf TO gen02
             IF g_oga_o.oga14 <> g_oga.oga14 OR p_cmd ='a' THEN
                 LET g_oga.oga15 = l_oga15
                 DISPLAY BY NAME g_oga.oga15
                 LET g_buf = ''
                 SELECT gem02 INTO g_buf FROM gem_file
                  WHERE gem01=g_oga.oga15
                    AND gemacti='Y'   #NO:6950
                 IF STATUS THEN
                    CALL cl_err3("sel","gem_file",g_oga.oga15,"",STATUS,"","select gem",1)  #No.FUN-660167
                    NEXT FIELD oga15
                 END IF
                 DISPLAY g_buf TO gem02
              END IF
           END IF
 
        AFTER FIELD oga15
          IF NOT cl_null(g_oga.oga15) THEN
             SELECT gem02 INTO g_buf FROM gem_file
              WHERE gem01=g_oga.oga15
                AND gemacti='Y'   #NO:6950
             IF STATUS THEN
                CALL cl_err3("sel","gem_file",g_oga.oga15,"",STATUS,"","select gem",1)  #No.FUN-660167
                NEXT FIELD oga15
             END IF
             DISPLAY g_buf TO gem02
          END IF
 
	BEFORE FIELD oga23
          CALL t650_set_entry(p_cmd)
 
        AFTER FIELD oga23
          IF NOT cl_null(g_oga.oga23) THEN
             SELECT azi02,azi03,azi04 INTO g_buf,t_azi03,t_azi04   #No.CHI-6A0004
               FROM azi_file WHERE azi01=g_oga.oga23
             IF STATUS THEN
                CALL cl_err3("sel","azi_file",g_oga.oga23,"",STATUS,"","select azi",1)  #No.FUN-660167
                NEXT FIELD oga23
             END IF
             IF g_oga.oga08='1' THEN
                LET exT=g_oaz.oaz52
             ELSE
                LET exT=g_oaz.oaz70
             END IF
              IF NOT cl_null(g_oga.oga021) THEN
                 LET g_exdate = g_oga.oga021    #結關日期
              ELSE
                 LET g_exdate = g_oga.oga02     #出貨日期
              END IF 
              CALL s_curr3(g_oga.oga23,g_exdate,exT) RETURNING g_oga.oga24
             IF cl_null(g_oga.oga24) THEN LET g_oga.oga24=0 END IF
             DISPLAY BY NAME g_oga.oga24
          END IF
          CALL t650_set_no_entry(p_cmd)
 
        AFTER FIELD oga25
          IF NOT cl_null(g_oga.oga25) THEN
             SELECT oab02 INTO g_buf FROM oab_file WHERE oab01=g_oga.oga25
             IF STATUS THEN
                CALL cl_err3("sel","oab_file",g_oga.oga25,"",STATUS,"","select oab",1)  #No.FUN-660167
                NEXT FIELD oga25
             END IF
             DISPLAY g_buf TO oab02
          END IF
 
        AFTER FIELD oga21
          IF NOT cl_null(g_oga.oga21) THEN
             SELECT gec04,gec05,gec07
               INTO g_oga.oga211,g_oga.oga212,g_oga.oga213
               FROM gec_file WHERE gec01=g_oga.oga21
                               AND gec011='2'  #銷項
             IF STATUS THEN
                CALL cl_err3("sel","gec_file",g_oga.oga21,"",STATUS,"","select gec",1)  #No.FUN-660167
                NEXT FIELD oga21
             END IF
             DISPLAY BY NAME g_oga.oga211, g_oga.oga212, g_oga.oga213

             #CHI-CB0008 mark begin---
             #IF p_cmd = 'u' AND
             #  ((g_oga.oga213 != g_oga_t.oga213 OR g_oga_t.oga213 IS NULL)
             #  OR (g_oga.oga211 != g_oga_t.oga211 OR g_oga_t.oga211 IS NULL)) THEN
             #   CALL t650_upd_oga50()
             #END IF
             #CHI-CB0008 mark end-----

             #CHI-CB0008 add begin---
             IF p_cmd = 'u' THEN
                IF g_oga.oga211 != g_oga_t.oga211 OR g_oga_t.oga211 IS NULL THEN
                   CALL t650_upd_oga50('N')
                END IF
                IF (g_oga.oga211 = g_oga_t.oga211 AND g_oga.oga213 != g_oga_t.oga213) OR g_oga_t.oga213 IS NULL THEN
                   CALL t650_upd_oga50('Y')
                END IF
             END IF
             #CHI-CB0008 add end-----
          END IF
 

#FUN-BB0167 add begin------------------------------------
        AFTER FIELD oga65
           IF cl_null(g_oga.oga72) THEN
              IF g_oga.oga65 = 'Y' THEN
                 #抓取客戶主檔中客戶的區域、國家、地區及慣用價格條件
                 SELECT occ20,occ21,occ22,occ44
                   INTO l_occ20,l_occ21,l_occ22,l_occ44
                   FROM occ_file WHERE occ01 = g_oga.oga04
                 IF cl_null(l_occ20) THEN  LET l_occ20 =' ' END IF
                 IF cl_null(l_occ21) THEN  LET l_occ21 =' ' END IF
                 IF cl_null(l_occ22) THEN  LET l_occ22 =' ' END IF

                 #通過抓取到的區域、國家、地區及慣用價格條件抓取交貨運輸天數
                 SELECT oat05 INTO l_oat05 FROM oat_file
                  WHERE oat01 = l_occ20 AND oat02 = l_occ21
                    AND oat03 = l_occ22 AND oat04 = l_occ44
                 IF l_oat05 = 0 THEN
                    SELECT oat05 INTO l_oat05 FROM oat_file
                     WHERE oat01 = l_occ20 AND oat02 = l_occ21
                       AND oat03 = ' ' AND oat04 = l_occ44
                    IF l_oat05 = 0 THEN
                       SELECT oat05 INTO l_oat05 FROM oat_file
                        WHERE oat01 = l_occ20 AND oat02 = ' '
                          AND oat03 = ' ' AND oat04 = l_occ44
                    END IF
                 END IF
                 LET l_oma11 = g_oga.oga02 + l_oat05
                 LET g_oga.oga72 = l_oma11  ##预计签收日
                 DISPLAY g_oga.oga72 TO oga72
              ELSE
                 LET g_oga.oga72 = NULL
                 DISPLAY g_oga.oga72 TO oga72
              END IF
           END IF
           IF g_oga.oga65 = 'N' THEN LET g_oga.oga72 = NULL END IF
           DISPLAY BY NAME g_oga.oga72

        AFTER FIELD oga72
           IF g_oga.oga65 = 'Y' THEN
              IF cl_null(g_oga.oga72) THEN
                 CALL cl_err('','aim-927',0)
                 NEXT FIELD oga72
              END IF
           END IF
#FUN-BB0167 add end--------------------------------------
        AFTER FIELD ogaud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ogaud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ogaud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ogaud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ogaud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ogaud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ogaud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ogaud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ogaud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ogaud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ogaud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ogaud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ogaud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ogaud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ogaud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        ON KEY(F1) NEXT FIELD oga08
        ON KEY(F2) NEXT FIELD oga03
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(oga01) #查詢單据
                   LET g_t1=s_get_doc_no(g_oga.oga01)       #No.FUN-550052
                   CALL q_oay( FALSE,FALSE,g_t1,'50','AXM') RETURNING g_t1  #TQC-670008 remark
                   LET g_oga.oga01=g_t1                     #No.FUN-550052
                   DISPLAY BY NAME g_oga.oga01
                   NEXT FIELD oga01
              WHEN INFIELD(oga03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_occ"
                   LET g_qryparam.default1 = g_oga.oga03
                   CALL cl_create_qry() RETURNING g_oga.oga03
                   DISPLAY BY NAME g_oga.oga03
                   NEXT FIELD oga03
              WHEN INFIELD(oga04)
                   CALL cl_init_qry_var()
                  #LET g_qryparam.form ="q_occ"   #MOD-C90205 mark
                   LET g_qryparam.form ="q_occ4"  #MOD-C90205 add
                   LET g_qryparam.default1 = g_oga.oga04
                   CALL cl_create_qry() RETURNING g_oga.oga04
                   DISPLAY BY NAME g_oga.oga04
                   NEXT FIELD oga04
              WHEN INFIELD(oga13)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_ool"
                   LET g_qryparam.default1 = g_oga.oga13
                   CALL cl_create_qry() RETURNING g_oga.oga13
                   DISPLAY BY NAME g_oga.oga13
                   NEXT FIELD oga13
              WHEN INFIELD(oga14)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gen"
                   LET g_qryparam.default1 = g_oga.oga14
                   CALL cl_create_qry() RETURNING g_oga.oga14
                   DISPLAY BY NAME g_oga.oga14
                   NEXT FIELD oga14
              WHEN INFIELD(oga15)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gem"
                   LET g_qryparam.default1 = g_oga.oga15
                   CALL cl_create_qry() RETURNING g_oga.oga15
                   DISPLAY BY NAME g_oga.oga15
                   NEXT FIELD oga15
              WHEN INFIELD(oga21)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gec"
                   LET g_qryparam.default1 = g_oga.oga21
                    LET g_qryparam.arg1 = '2'  #No.MOD-480191
                   CALL cl_create_qry() RETURNING g_oga.oga21
                   DISPLAY BY NAME g_oga.oga21
                   NEXT FIELD oga21
              WHEN INFIELD(oga23)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_azi"
                   LET g_qryparam.default1 = g_oga.oga23
                   CALL cl_create_qry() RETURNING g_oga.oga23
                   DISPLAY BY NAME g_oga.oga23
                   NEXT FIELD oga23
              WHEN INFIELD(oga24)
                   CALL s_rate(g_oga.oga23,g_oga.oga24) RETURNING g_oga.oga24
                   DISPLAY BY NAME g_oga.oga24
                   NEXT FIELD oga24
              WHEN INFIELD(oga25)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_oab"
                   LET g_qryparam.default1 = g_oga.oga25
                   CALL cl_create_qry() RETURNING g_oga.oga25
                   DISPLAY BY NAME g_oga.oga25
                   NEXT FIELD oga25
              WHEN INFIELD(oga18)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_occ"
                   LET g_qryparam.default1 = g_oga.oga18
                   CALL cl_create_qry() RETURNING g_oga.oga18
                   DISPLAY BY NAME g_oga.oga18
                   NEXT FIELD oga18
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
 
 
    END INPUT
 
END FUNCTION

#start FUN-950062 add
FUNCTION t600_chk_oga69()
   DEFINE l_yy,l_mm       LIKE type_file.num5
   IF NOT cl_null(g_oga.oga69) THEN
      IF g_oga.oga69 <= g_oaz.oaz09 THEN
         CALL cl_err('','axm-164',0) RETURN FALSE
      END IF
            IF g_oaz.oaz03 = 'Y' AND
               g_sma.sma53 IS NOT NULL AND g_oga.oga69 <= g_sma.sma53 THEN
               CALL cl_err('','mfg9999',0) RETURN FALSE
            END IF
      CALL s_yp(g_oga.oga69) RETURNING l_yy,l_mm
      IF ((l_yy*12+l_mm) > (g_sma.sma51*12+g_sma.sma52)) THEN
         CALL cl_err('','mfg6090',0)
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION
#end FUN-950062 add
 
FUNCTION t650_upd_oga50(p_chkwind)            #CHI-CB0008 add p_chkwind
  DEFINE p_chkwind     LIKE type_file.chr1    #CHI-CB0008 add
  DEFINE l_cnt         LIKE type_file.num5
  DEFINE l_ogb03       LIKE ogb_file.ogb03
  DEFINE l_ogb13       LIKE ogb_file.ogb13
  DEFINE l_ogb917      LIKE ogb_file.ogb917
  DEFINE l_ogb14       LIKE ogb_file.ogb14
  DEFINE l_ogb14t      LIKE ogb_file.ogb14t
  DEFINE l_conu        LIKE type_file.chr1    #CHI-CB0008 add

  #No:MOD-BB0021 add
   SELECT azi03,azi04 INTO t_azi03,t_azi04 FROM azi_file WHERE azi01 = g_oga.oga23 
   IF STATUS THEN
      CALL cl_err3("sel","azi_file",g_oga.oga23,"",STATUS,"","select azi",1) 
      RETURN    
   END IF
  #No:MOD-BB0021 end
   SELECT COUNT(*) INTO l_cnt from ogb_file 
    WHERE ogb01 = g_oga.oga01
   IF l_cnt > 0 THEN
      ##稅別改變，是否跟新單身金額       #CHI-CB0008 mark
      #IF cl_confirm('axm-936') THEN     #CHI-CB0008 mark
      #CHI-CB0008 add begin---
      LET l_conu = NULL
      IF p_chkwind = 'N' THEN
         LET l_conu = 'Y'
      END IF
      IF p_chkwind = 'Y' THEN
         IF cl_confirm('axm-936') THEN
            LET l_conu = 'Y'
         END IF
      END IF
      IF l_conu = 'Y' THEN
      #CHI-CB0008 add end-----
         DECLARE oga21_cs CURSOR FOR
          SELECT ogb03,ogb13,ogb917 FROM ogb_file
           WHERE ogb01 = g_oga.oga01
         FOREACH oga21_cs INTO l_ogb03,l_ogb13,l_ogb917
            IF g_oga.oga213 = 'N' THEN
               LET l_ogb14 =l_ogb917*l_ogb13
               LET l_ogb14t=l_ogb14*(1+g_oga.oga211/100)
               CALL cl_digcut(l_ogb14,t_azi04) RETURNING l_ogb14     #No:MOD-BB0021 modify
               CALL cl_digcut(l_ogb14t,t_azi04) RETURNING l_ogb14t   #No:MOD-BB0021 modify
            ELSE
               LET l_ogb14t=l_ogb917*l_ogb13
               LET l_ogb14 =l_ogb14t/(1+g_oga.oga211/100)
               CALL cl_digcut(l_ogb14t,t_azi04) RETURNING l_ogb14t   #No:MOD-BB0021 modify
               CALL cl_digcut(l_ogb14,t_azi04) RETURNING l_ogb14     #No:MOD-BB0021 modify
            END IF
            UPDATE ogb_file SET ogb14 = l_ogb14,
                                ogb14t= l_ogb14t
             WHERE ogb01 = g_oga.oga01 AND ogb03 = l_ogb03
            IF SQLCA.SQLCODE THEN
               CALL cl_err3("upd","ogb_file",g_oga.oga01,l_ogb03,STATUS,"","upd ogb14,ogb14t:",1)
               EXIT FOREACH
            END IF
         END FOREACH
         CALL t650_b_fill(' 1=1')
         SELECT SUM(ogb14) INTO g_oga.oga50 FROM ogb_file
          WHERE ogb01 = g_oga.oga01
         CALL cl_digcut(g_oga.oga50,t_azi04) RETURNING g_oga.oga50    #No:MOD-BB0021 modify
         IF cl_null(g_oga.oga50) THEN LET g_oga.oga50 = 0 END IF
         DISPLAY BY NAME g_oga.oga50
      END IF
   END IF
END FUNCTION
 
FUNCTION t650_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry(",oga00,oga01",TRUE)
    END IF
 
    IF INFIELD(oga23) OR ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("oga24",TRUE)
    END IF
 
    IF INFIELD(oga03) OR ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("oga032",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t650_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("oga01,oga00",FALSE)
    END IF
 
    IF INFIELD(oga23) OR ( NOT g_before_input_done ) THEN
       IF g_oga.oga23 = g_aza.aza17 THEN
          LET g_oga.oga24=1
          DISPLAY BY NAME g_oga.oga24                     #FUN-4C0076
          CALL cl_set_comp_entry("oga24",FALSE)
       END IF
    END IF
 
    IF INFIELD(oga03) OR ( NOT g_before_input_done ) THEN
       IF g_oga.oga03[1,4] != 'MISC' THEN
          CALL cl_set_comp_entry("oga032",FALSE)
       END IF
    END IF

END FUNCTION
 
FUNCTION t650_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_oga.* TO NULL               #No.FUN-6A0020
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t650_cs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       INITIALIZE g_oga.* TO NULL
       RETURN
    END IF
 
    MESSAGE " SEARCHING ! "
    OPEN t650_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_oga.* TO NULL
    ELSE
       OPEN t650_count
       FETCH t650_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL t650_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION t650_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式  #No.FUN-680137 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t650_cs INTO g_oga.oga01
        WHEN 'P' FETCH PREVIOUS t650_cs INTO g_oga.oga01
        WHEN 'F' FETCH FIRST    t650_cs INTO g_oga.oga01
        WHEN 'L' FETCH LAST     t650_cs INTO g_oga.oga01
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
            FETCH ABSOLUTE g_jump t650_cs INTO g_oga.oga01
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_oga.oga01,SQLCA.sqlcode,0)
        INITIALIZE g_oga.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_oga.* FROM oga_file WHERE oga01 = g_oga.oga01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","oga_file",g_oga.oga01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
        INITIALIZE g_oga.* TO NULL
        RETURN
    END IF
    LET g_data_owner = g_oga.ogauser      #FUN-4C0057 add
    LET g_data_group = g_oga.ogagrup      #FUN-4C0057 add
    LET g_data_plant = g_oga.ogaplant #FUN-980030
    CALL s_get_bookno(YEAR(g_oga.oga02)) RETURNING g_flag,g_bookno1,g_bookno2                                                         
      IF g_flag =  '1' THEN  #抓不到帳別                                                                                                
         CALL cl_err(g_oga.oga02,'aoo-081',1)                                                                                           
      END IF                                                                                                                            
    CALL t650_show()
 
END FUNCTION
 
FUNCTION t650_show()
    DEFINE l_oap RECORD LIKE oap_file.*
    LET g_oga_t.* = g_oga.*                #保存單頭舊值
    DISPLAY BY NAME g_oga.ogaoriu,g_oga.ogaorig,
        g_oga.oga00,g_oga.oga08,g_oga.oga01,g_oga.oga69,g_oga.oga02,g_oga.oga021,  #No.FUN-950062 add g_oga.oga69
        g_oga.oga70,                                                   #FUN-B10016 add
        g_oga.oga10,g_oga.oga65,g_oga.oga72,   #FUN-BB0167 add by suncx g_oga.oga65,g_oga.oga72
        g_oga.oga03,g_oga.oga032,g_oga.oga04,g_oga.oga18,  #No.TQC-740308 add oga18
        g_oga.oga14,g_oga.oga15,g_oga.oga23,g_oga.oga24,g_oga.oga50,
        g_oga.oga21,g_oga.oga211,g_oga.oga212,g_oga.oga213,
        g_oga.oga25,g_oga.oga05,g_oga.oga13,
        g_oga.ogaconf,g_oga.oga30,g_oga.ogapost,
        g_oga.ogauser,g_oga.ogagrup,g_oga.ogamodu,g_oga.ogadate,
        g_oga.oga903,   #No.B325 add
        g_oga.ogaud01,g_oga.ogaud02,g_oga.ogaud03,g_oga.ogaud04,
        g_oga.ogaud05,g_oga.ogaud06,g_oga.ogaud07,g_oga.ogaud08,
        g_oga.ogaud09,g_oga.ogaud10,g_oga.ogaud11,g_oga.ogaud12,
        g_oga.ogaud13,g_oga.ogaud14,g_oga.ogaud15 
    #CKP
    IF g_oga.ogaconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    CALL cl_set_field_pic(g_oga.ogaconf,"",g_oga.ogapost,"",g_chr,"")
 
    IF g_oga.oga08='1' THEN
       LET exT=g_oaz.oaz52
    ELSE
       LET exT=g_oaz.oaz70
    END IF
 
    LET g_buf = s_get_doc_no(g_oga.oga01)          #No.FUN-550052
 
    SELECT oaydesc INTO g_buf FROM oay_file WHERE oayslip=g_buf
    DISPLAY g_buf TO oaydesc
    LET g_buf = NULL
 
    CALL t650_show2()
    CALL t650_show3()  #FUN-BB0167
 
    CALL s_addr(g_oga.oga01,g_oga.oga04,g_oga.oga044)
         RETURNING l_oap.oap041,l_oap.oap042,l_oap.oap043,l_oap.oap044,l_oap.oap045   #FUN-720014 add oap044/045
    LET g_msg=l_oap.oap041 CLIPPED,' ',l_oap.oap042 CLIPPED,' ',
              l_oap.oap043 CLIPPED,' ',
              l_oap.oap044 CLIPPED,' ',l_oap.oap045 CLIPPED,' '  #FUN-720014 add
    DISPLAY g_msg TO addr
 
    CALL t650_show_oao()
    CALL t650_b_fill(g_wc2)
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
    #CHI-AC0002 add --start--
    CALL cl_set_act_visible("entry_sheet2",TRUE)
    IF g_aza.aza63 = 'N' THEN
       CALL cl_set_act_visible("entry_sheet2",FALSE)
    END IF
    #CHI-AC0002 add --end--

   #FUN-B10016 add str ---------
    IF g_aza.aza123 MATCHES "[Yy]" THEN
       CALL cl_set_comp_visible("oga70",TRUE)
       CALL cl_set_comp_entry("oga70",FALSE)
    END IF
   #FUN-B10016 add end ---------
END FUNCTION
 
FUNCTION t650_show_oao()
    DEFINE i,j LIKE type_file.num5    #No.FUN-680137 SMALLINT
    DEFINE l_oao06	LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(60)
 
    DECLARE t650_show_c CURSOR FOR
        SELECT oao03,oao04,oao06 FROM oao_file
         WHERE oao01=g_oga.oga01 ORDER BY 1,2
 
    LET g_msg=''
 
    FOREACH t650_show_c INTO i,j,l_oao06
       IF STATUS THEN EXIT FOREACH END IF
       LET g_msg=g_msg CLIPPED,' ',l_oao06
    END FOREACH
 
    MESSAGE g_msg CLIPPED
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
END FUNCTION
 
FUNCTION t650_show2()
    SELECT azi03,azi04 INTO t_azi03,t_azi04   #No.CHI-6A0004
                     FROM azi_file WHERE azi01=g_oga.oga23
    SELECT occ02 INTO g_buf FROM occ_file WHERE occ01=g_oga.oga04
                 DISPLAY g_buf TO occ02 LET g_buf = NULL
    SELECT occ02 INTO g_buf FROM occ_file WHERE occ01=g_oga.oga18
                 DISPLAY g_buf TO oga18_ds LET g_buf = NULL
    SELECT gen02 INTO g_buf FROM gen_file WHERE gen01=g_oga.oga14
                 DISPLAY g_buf TO gen02 LET g_buf = NULL
    SELECT gem02 INTO g_buf FROM gem_file WHERE gem01=g_oga.oga15
                 DISPLAY g_buf TO gem02 LET g_buf = NULL
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
    SELECT oab02 INTO g_buf FROM oab_file WHERE oab01=g_oga.oga25
                 DISPLAY g_buf TO oab02 LET g_buf = NULL
END FUNCTION
 
FUNCTION t650_r()
    DEFINE l_chr,l_sure LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
    DEFINE l_flag       LIKE type_file.chr1    #No.FUN-7B0018
    DEFINE l_n,l_i      LIKE type_file.num5    #No.FUN-680137 SMALLINT  #FUN-810045 l_i
    DEFINE l_oga70      LIKE oga_file.oga70    #FUN.B10016 add
    DEFINE l_oga01      LIKE oga_file.oga01    #FUN-B10016 add

    IF s_shut(0) THEN RETURN END IF
    SELECT * INTO g_oga.* FROM oga_file WHERE oga01 = g_oga.oga01
    IF g_oga.oga01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_oga.ogaconf = 'Y' THEN CALL cl_err('','axm-101',0) RETURN END IF
    IF g_oga.ogaconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF #No.+182
    IF g_oga.oga54 != 0 THEN CALL cl_err('','axm-160',0) RETURN END IF

#FUN-BB0167 add begin-----------------------------
    IF g_oga.oga65='Y' THEN
       SELECT COUNT(*) INTO l_n FROM oga_file
        WHERE oga011 = g_oga.oga01 AND oga09 IN ('8','9')
       IF l_n > 0 THEN
          CALL cl_err(g_oga.oga01,'axm-703',0)
          RETURN FALSE
       END IF
    END IF
#FUN-BB0167 add end ------------------------------

    LET l_oga70 = g_oga.oga70                   #FUN-B10016 add
    LET l_oga01 = g_oga.oga01                   #FUN-B10016 add
 
    BEGIN WORK
 
    OPEN t650_cl USING g_oga.oga01
    IF STATUS THEN
       CALL cl_err("OPEN t650_cl:", STATUS, 1)
       CLOSE t650_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH t650_cl INTO g_oga.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_oga.oga01,SQLCA.sqlcode,0)
       CLOSE t650_cl ROLLBACK WORK RETURN
    END IF
 
    CALL t650_show()
 
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "oga01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_oga.oga01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
        MESSAGE "Delete oga,ogb,ogc,oao,oap!"
        DELETE FROM oga_file WHERE oga01 = g_oga.oga01
        IF SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err3("del","oga_file",g_oga.oga01,"",'',"","No oga deleted",1)  #No.FUN-660167
           ROLLBACK WORK
           RETURN
        END IF
 
        DELETE FROM ogb_file WHERE ogb01 = g_oga.oga01
#FUN-A60035 ---MARK BEGIN
#       #FUN-A50054---Begin add
#       IF s_industry('slk') THEN
#          DELETE FROM ata_file WHERE ata00=g_prog AND ata01=g_oga.oga01 
#       END IF 
#       #FUN-A50054---End
#FUN-A60035 ---MARK END        
        DELETE FROM ogc_file WHERE ogc01 = g_oga.oga01
        DELETE FROM rvbs_file WHERE rvbs01=g_oga.oga01   #MOD-A20117
        DELETE FROM ogg_file WHERE ogg01 = g_oga.oga01  #No.FUN-560063
        DELETE FROM oao_file WHERE oao01 = g_oga.oga01
        DELETE FROM oap_file WHERE oap01 = g_oga.oga01
        DELETE FROM ogd_file WHERE ogd01 = g_oga.oga01   #No.+182 add
        UPDATE tus_file SET tus12 = 'N'  WHERE tus01 = g_oga.oga16  #CHI-820004 add
 
        #96/02/13 by danny  刪除分錄底稿單頭、單身檔
        DELETE FROM npp_file
         WHERE nppsys = 'AR' AND npp00=1 AND npp01 = g_oga.oga01 AND npp011=1
        DELETE FROM npq_file
         WHERE npqsys = 'AR' AND npq00=1 AND npq01 = g_oga.oga01 AND npq011=1
        DELETE FROM tic_file WHERE tic04 = g_oga.oga01  #FUN-B40056

        LET g_msg=TIME
 
        INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980010 add azoplant,azolegal
                     VALUES ('axmt650',g_user,g_today,g_msg,g_oga.oga01,'delete',g_plant,g_legal) #FUN-980010 add g_plant,g_legal
        FOR l_i = 1 TO g_rec_b 
           #IF NOT s_del_rvbs("1",g_oga.oga01,g_ogb[l_i].ogb03,0)  THEN                    #FUN-880129  #TQC-B90236
            IF NOT s_lot_del(g_prog,g_oga.oga01,'',0,g_ogb[l_i].ogb04,'DEL') THEN   #No.FUN-880129   #TQC-B90236
              ROLLBACK WORK
              RETURN FALSE
            END IF
        END FOR

       #FUN-B10016 add str ---------
       #若有與CRM整合,需回饋CRM單據狀態,表CRM可再重發出貨單
        IF NOT cl_null(l_oga70) AND g_aza.aza123 MATCHES "[Yy]" THEN
          CALL aws_crmcli('x','restatus','1',l_oga01,'2') RETURNING g_crmStatus,g_crmdesc
          IF g_crmStatus <> 0 THEN
             CALL cl_err(g_crmdesc,'!',1)
             ROLLBACK WORK
             RETURN 
          END IF
        END IF
       #FUN-B10016 add end ---------
 
        CLEAR FORM
 
        CALL g_ogb.clear()
    	INITIALIZE g_oga.* TO NULL
        OPEN t650_count
        #FUN-B50064-add-start--
        IF STATUS THEN
           CLOSE t650_cs
           CLOSE t650_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50064-add-end-- 
        FETCH t650_count INTO g_row_count
        #FUN-B50064-add-start--
        IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
           CLOSE t650_cs
           CLOSE t650_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50064-add-end-- 
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN t650_cs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL t650_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET mi_no_ask = TRUE
           CALL t650_fetch('/')
        END IF
 
        MESSAGE ""
 
    END IF
 
    CLOSE t650_cl
    COMMIT WORK
    CALL cl_flow_notify(g_oga.oga01,'D')
 
END FUNCTION
 
FUNCTION t650_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680137 SMALLINT
    l_row,l_col     LIKE type_file.num5,     #No.FUN-680137 SMALLINT  #分段輸入之行,列數
    l_n,l_cnt       LIKE type_file.num5,                #檢查重複用  #No.FUN-680137 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否  #No.FUN-680137 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態  #No.FUN-680137 VARCHAR(1)
    l_b2            LIKE cob_file.cob08,   #No.FUN-680137 VARCHAR(30)
    l_misc          LIKE ogb_file.ogb05,   #No.FUN-680137 VARCHAR(04)
    l_ima35         LIKE ima_file.ima35, #MOD-5B0276
    l_ima36         LIKE ima_file.ima36, #MOD-5B0276
    l_coc04         LIKE coc_file.coc04,   #No.MOD-4B0275
    l_coc10         LIKE coc_file.coc10,   #No.MOD-4B0275
    l_imaacti       LIKE ima_file.imaacti,
    l_qty           LIKE ogb_file.ogb12,
    l_allow_insert  LIKE type_file.num5,                #可新增否  #No.FUN-680137 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否  #No.FUN-680137 SMALLINT
    DEFINE l_pjb25    LIKE pjb_file.pjb25  #FUN-810045
    DEFINE l_pjb09    LIKE pjb_file.pjb09  #No.FUN-850027 
    DEFINE l_pjb11    LIKE pjb_file.pjb11  #No.FUN-850027
    DEFINE l_ogb1004  LIKE ogb_file.ogb1004 #FUN-9C0083
    DEFINE l_azf09    LIKE azf_file.azf09  #No.FUN-930104
    DEFINE l_bno      LIKE rvbs_file.rvbs08#No.CHI-9A0022
#FUN-A60035 ---MARK BEGIN
##FUN-A50054 --Begin
#   DEFINE l_ata02    LIKE ata_file.ata02
#   DEFINE l_ata04    LIKE ata_file.ata04
#   DEFINE l_ata03_t  LIKE ata_file.ata03
#   DEFINE l_ata04_t  LIKE ata_file.ata04
#   DEFINE l_sql      LIKE type_file.chr1000
#   DEFINE l_ps       LIKE type_file.chr1
#   DEFINE l_ata08    LIKE ata_file.ata08
#   DEFINE l_str      STRING
#   DEFINE l_str1     STRING
#   DEFINE l_count    LIKE type_file.num5
#   DEFINE l_ata      RECORD LIKE ata_file.*
##FUN-A50054 --End
#FUN-A60035 ---MARK END
    DEFINE l_ima151   LIKE ima_file.ima151     #NO.FUN-a60035 ADD
    DEFINE l_ogb04_t  LIKE ogb_file.ogb04   #MOD-AB0034
    DEFINE l_imaicd12 LIKE imaicd_file.imaicd12   #FUN-B80178
    DEFINE l_c        LIKE type_file.num5   #CHI-C30106---add    
    DEFINE l_msg      STRING                #TQC-C50131 -- add
    DEFINE l_flag    LIKE type_file.chr1   #FUN-C80107 add
#2022032401 add----begin----
DEFINE l_tc_zsa02   LIKE type_file.chr1,
       l_tc_zsa03   LIKE type_file.chr10
#2022032401 add----end----
    LET g_action_choice = ""
    SELECT * INTO g_oga.* FROM oga_file WHERE oga01 = g_oga.oga01
    IF g_oga.oga01 IS NULL THEN RETURN END IF
    IF g_oga.ogaconf = 'Y' THEN CALL cl_err('','axm-101',0) RETURN END IF
    IF g_oga.ogaconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF #No.+182
    IF g_oga.oga53 > 0 AND g_oga.oga53 = g_oga.oga54 THEN
       CALL cl_err('','axm-160',0) RETURN
    END IF

    #2022032401 add----begin----
    IF g_oga.ogaud01[1,2] = 'DO' THEN 
    	LET l_tc_zsa02 = ''
    	LET l_tc_zsa03 = ''
    	SELECT tc_zsa02,tc_zsa03 INTO l_tc_zsa02,l_tc_zsa03 FROM tc_zsa_file
    	IF l_tc_zsa02 = 'Y' AND NOT cl_null(l_tc_zsa03) AND g_today >= l_tc_zsa03 THEN 
    		CALL cl_err('','cpm-066',0)
    		RETURN 
    	END IF 
    END IF 
    #2022032401 add----end----

    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT * FROM ogb_file ",
                       " WHERE ogb01= ? AND ogb03= ?  FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t650_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_ogb WITHOUT DEFAULTS FROM s_ogb.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            LET g_before_input_done = FALSE
            LET g_before_input_done = TRUE
 
        BEFORE ROW
           #LET p_cmd = ''
            LET p_cmd = 'a'   #FUN-A50054
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK
 
            OPEN t650_cl USING g_oga.oga01
            IF STATUS THEN
               CALL cl_err("OPEN t650_cl:", STATUS, 1)
               CLOSE t650_cl
               ROLLBACK WORK
               RETURN
            END IF
 
            FETCH t650_cl INTO g_oga.*
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_oga.oga01,SQLCA.sqlcode,0)
               CLOSE t650_cl ROLLBACK WORK RETURN
            END IF
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_ogb_t.* = g_ogb[l_ac].*  #BACKUP
                LET l_ogb04_t = g_ogb[l_ac].ogb04 #MOD-B20123 add
                 
               #FUN-A60035 ---MARK BEGIN
               ##FUN-A50054---Begin add
               #IF s_industry("slk") THEN
               #   DECLARE t650_ata1 SCROLL CURSOR FOR
               #    SELECT ata02,ata03,ata04 FROM ata_file 
               #     WHERE ata00=g_prog
               #       AND ata01=g_oga.oga01
               #       AND ata02=g_ogb_t.ogb03
               #   FOREACH t650_ata1 INTO l_ata02,g_ogb_t.ogb03,l_ata04
               #    OPEN t650_bcl USING g_oga.oga01,g_ogb_t.ogb03
               #      IF STATUS THEN
               #         CALL cl_err("OPEN t650_bcl:", STATUS, 1)
               #         LET l_lock_sw = "Y"
               #      ELSE
               #         FETCH t650_bcl INTO b_ogb.*
               #         IF SQLCA.sqlcode THEN
               #            CALL cl_err('lock ogb',SQLCA.sqlcode,1)
               #            LET l_lock_sw = "Y"
               #         ELSE
               #            OPEN t650_bcl_ind USING g_oga.oga01,g_ogb_t.ogb03
               #            IF SQLCA.sqlcode THEN
               #               CALL cl_err('lock ogbi',SQLCA.sqlcode,1)
               #               LET l_lock_sw = "Y"
               #            ELSE
               #               FETCH t650_bcl_ind INTO b_ogbi.*
               #               IF SQLCA.sqlcode THEN
               #                  CALL cl_err('lock ogbi',SQLCA.sqlcode,1)
               #                  LET l_lock_sw = "Y"
               #               END IF
               #            END IF
               #         END IF
               #      END IF
               #   END FOREACH
               #   LET b_ogb.ogb03 = l_ata02
               #   LET b_ogb.ogb04 = l_ata04
               #   LET g_ogb_t.ogb03 = b_ogb.ogb03
               #   LET g_ogb_t.ogb04 = b_ogb.ogb04
               #   LET g_ogb[l_ac].gem02c=s_costcenter_desc(g_ogb[l_ac].ogb930) #FUN-670063                    
               #   LET g_ogb_t.* = g_ogb[l_ac].*
               #ELSE 
               ##FUN-A50054---End	   
               #FUN-A60035 ---MARK END 
                   OPEN t650_bcl USING g_oga.oga01,g_ogb_t.ogb03
                   IF STATUS THEN
                      CALL cl_err("OPEN t650_bcl:", STATUS, 1)
                      LET l_lock_sw = "Y"
                   ELSE
                      FETCH t650_bcl INTO b_ogb.*
                      IF SQLCA.sqlcode THEN
                         CALL cl_err('lock ogb',SQLCA.sqlcode,1)
                         LET l_lock_sw = "Y"
                      ELSE
                               CALL t650_b_move_to()
                               LET g_ogb[l_ac].gem02c=s_costcenter_desc(g_ogb[l_ac].ogb930) #FUN-670063
                      END IF
                   END IF
                #END IF     #FUN-A60035 ---MARK
                LET g_before_input_done = FALSE
                CALL t650_set_entry_b('')
                CALL t650_set_no_entry_b('')
                LET g_change='N'
                LET g_yes   ='N'
                CALL t650_set_no_required('u')
                CALL t650_set_required('u')
                LET g_before_input_done = TRUE
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            IF g_ogb[l_ac].ogb09 IS NULL THEN LET g_ogb[l_ac].ogb09=' ' END IF
            IF g_ogb[l_ac].ogb091 IS NULL THEN LET g_ogb[l_ac].ogb091=' ' END IF
            IF g_ogb[l_ac].ogb092 IS NULL THEN LET g_ogb[l_ac].ogb092=' ' END IF
            IF g_sma.sma115 = 'Y' THEN
               CALL s_chk_va_setting(g_ogb[l_ac].ogb04)
                    RETURNING g_flag,g_ima906,g_ima907
               IF g_flag=1 THEN
                  NEXT FIELD ogb04
               END IF
 
               CALL s_chk_va_setting1(g_ogb[l_ac].ogb04)
                    RETURNING g_flag,g_ima908
               IF g_flag=1 THEN
                  NEXT FIELD ogb04
               END IF
               CALL t650_du_data_to_correct()
               CALL t650_set_origin_field()
            END IF
            IF cl_null(g_ogb[l_ac].ogb916) THEN
               LET g_ogb[l_ac].ogb916 = g_ogb[l_ac].ogb05
               LET g_ogb[l_ac].ogb917 = g_ogb[l_ac].ogb12
            END IF
 
            CALL t650_b_move_back()
            CALL t650_b_else()
            #IF 有專案且要做預算控管，check料件， if 沒做批號管理也沒做序號管理，則要寫入rvbs_file
              LET g_success = 'Y'
              IF s_chk_rvbs(g_ogb[l_ac].ogb41,g_ogb[l_ac].ogb04) THEN
                 CALL t650_rvbs()
              END IF
              IF g_success = 'N' THEN
                 CANCEL INSERT
                 NEXT FIELD ogb03
              END IF
 
            IF cl_null(b_ogb.ogb44) THEN
               LET b_ogb.ogb44='1'
            END IF
            IF cl_null(b_ogb.ogb47) THEN
               LET b_ogb.ogb47=0
            END IF

           #FUN-A60035 ---MARK BEGIN 
           ##FUN-A50054 --Begin
           #IF s_industry("slk") THEN
           #   LET l_sql = " SELECT ata03,ata04,ata08 FROM ata_file ",
           #              "  WHERE ata00 = '",g_prog,"'",
           #              "    AND ata01 = '",g_oga.oga01,"'",
           #              "    AND ata02 = '",g_ogb[l_ac].ogb03,"'"
           #  DECLARE t400_ata_curs SCROLL CURSOR FROM l_sql
           #  FOREACH t400_ata_curs INTO b_ogb.ogb03,b_ogb.ogb04,b_ogb.ogb12
           #     LET b_ogb.ogb14 = g_ogb[l_ac].ogb14 * b_ogb.ogb12 / g_ogb[l_ac].ogb12
           #     LET b_ogb.ogb14t= g_ogb[l_ac].ogb14t* b_ogb.ogb12 / g_ogb[l_ac].ogb12
           #     LET b_ogb.ogb917= g_ogb[l_ac].ogb917 * b_ogb.ogb12 / g_ogb[l_ac].ogb12
           #     CALL cl_digcut(b_ogb.ogb14,t_azi04)  RETURNING b_ogb.ogb14
           #     CALL cl_digcut(b_ogb.ogb14t,t_azi04) RETURNING b_ogb.ogb14t
           #     INSERT INTO ogb_file VALUES(b_ogb.*)
           #     IF SQLCA.sqlcode THEN
           #        CALL cl_err3("ins","ogb_file",b_ogb.ogb01,"",SQLCA.sqlcode,"","ins ogb",1)  #No.FUN-660167
           #        CANCEL INSERT
           #        SELECT ima918,ima921 INTO g_ima918,g_ima921 
           #          FROM ima_file
           #         WHERE ima01 = g_ogb[l_ac].ogb04
           #           AND imaacti = "Y"
           #        
           #        IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
           #           IF NOT s_lotout_del(g_prog,g_oga.oga01,g_ogb[l_ac].ogb03,0,g_ogb[l_ac].ogb04,'DEL') THEN   #No.FUN-860045
           #              CALL cl_err3("del","rvbs_file",g_oga.oga01,g_ogb_t.ogb03,
           #                            SQLCA.sqlcode,"","",1)
           #              ROLLBACK WORK      #CHI-A10016 
           #              CANCEL INSERT      #CHI-A10016
           #           END IF
           #        END IF
           #     ELSE
           #        IF NOT s_industry('std') THEN
           #           LET b_ogbi.ogbi01 = b_ogb.ogb01
           #           LET b_ogbi.ogbi03 = b_ogb.ogb03
           #           IF NOT s_ins_ogbi(b_ogbi.*,b_ogb.ogbplant) THEN
           #              CANCEL INSERT               #No.FUN-830120
           #           END IF
           #        END IF
           #        MESSAGE 'INSERT O.K'
           #        CALL t650_mlog('A')
           #        DISPLAY g_rec_b TO FORMONLY.cn2
           #        CALL t650_bu()
           # #       COMMIT WORK   
           #        IF g_sma.sma115 = 'Y' THEN
           #           CALL t650_b_ogg()
           #        ELSE
           #           CALL t650_b_ogc()
           #        END IF
           #     END IF
           #   END FOREACH
           #   LET g_rec_b=g_rec_b+1
           #   COMMIT WORK
           # ELSE      
           ##FUN-A50054 --End
           #FUN-A60035 ---MARK END

#FUN-AC0055 mark ---------------------begin-----------------------
##TQC-AA0034 --begin--
#                IF cl_null(b_ogb.ogb50) THEN
#                   LET b_ogb.ogb50 = '0'
#                END IF 
##TQC-AA0034 --end--
#FUN-AC0055 mark ----------------------end------------------------
#FUN-AB0061 -----------add start---------------- 
                 IF cl_null(b_ogb.ogb37) OR b_ogb.ogb37=0 THEN           
                    LET b_ogb.ogb37=b_ogb.ogb13                         
                 END IF    
#FUN-AC0055 mark ---------------------begin-----------------------                                                                         
##FUN-AB0061 -----------add end----------------  
##FUN-AB0096 ----------add start--------------
#                 IF cl_null(b_ogb.ogb50) THEN
#                    LET b_ogb.ogb50 = '1'
#                 END IF
##FUN-AB0096 ----------add end------------------- 
#FUN-AC0055 mark ----------------------end------------------------
                 #FUN-C50097---begin TQC-C70206 
                 IF cl_null(b_ogb.ogb50) THEN
                    LET b_ogb.ogb50 = 0
                 END IF  
                 IF cl_null(b_ogb.ogb51) THEN
                    LET b_ogb.ogb51 = 0
                 END IF  
                 IF cl_null(b_ogb.ogb52) THEN
                    LET b_ogb.ogb52 = 0
                 END IF 
                 IF cl_null(b_ogb.ogb53) THEN
                    LET b_ogb.ogb53 = 0
                 END IF  
                 IF cl_null(b_ogb.ogb54) THEN
                    LET b_ogb.ogb54 = 0
                 END IF  
                 IF cl_null(b_ogb.ogb55) THEN
                    LET b_ogb.ogb55 = 0
                 END IF                  
                 #FUN-C50097---end
                 INSERT INTO ogb_file VALUES(b_ogb.*)
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("ins","ogb_file",b_ogb.ogb01,"",SQLCA.sqlcode,"","ins ogb",1)  #No.FUN-660167
                    CANCEL INSERT
                    SELECT ima918,ima921 INTO g_ima918,g_ima921 
                      FROM ima_file
                     WHERE ima01 = g_ogb[l_ac].ogb04
                       AND imaacti = "Y"
                    
                    IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                      #IF NOT s_lotout_del(g_prog,g_oga.oga01,g_ogb[l_ac].ogb03,0,g_ogb[l_ac].ogb04,'DEL') THEN   #No.FUN-860045  #TQC-B90236
                       IF NOT s_lot_del(g_prog,g_oga.oga01,g_ogb[l_ac].ogb03,0,g_ogb[l_ac].ogb04,'DEL') THEN   #No.FUN-860045   #TQC-B90236 
                          CALL cl_err3("del","rvbs_file",g_oga.oga01,g_ogb_t.ogb03,
                                        SQLCA.sqlcode,"","",1)
                          ROLLBACK WORK      #CHI-A10016 
                          CANCEL INSERT      #CHI-A10016
                       END IF
                    END IF
                 ELSE
                    MESSAGE 'INSERT O.K'
                    CALL t650_mlog('A')
                    LET g_rec_b=g_rec_b+1
                    DISPLAY g_rec_b TO FORMONLY.cn2
                    CALL t650_bu()
                    COMMIT WORK
                    IF g_sma.sma115 = 'Y' THEN
                       CALL t650_b_ogg()
                    ELSE
                       CALL t650_b_ogc()
                    END IF
                 END IF
             #END IF  #FUN-A50045        #FUN-A60035 ---MARK
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_ogb[l_ac].* TO NULL      #900423
            LET b_ogb.ogb01=g_oga.oga01
            LET g_ogb[l_ac].ogb12=0
            LET g_ogb[l_ac].ogb37=0  #FUN-AB0061
            LET g_ogb[l_ac].ogb13=0
            LET g_ogb[l_ac].ogb17='N' #No.FUN-560063
            LET g_ogb[l_ac].ogb14=0
            LET g_ogb[l_ac].ogb14t=0
            LET g_ogb[l_ac].ogbiicd02=0     #FUN-B80178
            LET g_ogb[l_ac].ogbiicd03='0'   #FUN-B80178            
            LET b_ogb.ogb05_fac=1
            LET b_ogb.ogb15_fac=1
            LET b_ogb.ogb16=0
            LET b_ogb.ogb17='N'
            LET b_ogb.ogb18=0
            LET b_ogb.ogb19='N'      #MOD-D30017 add
            LET b_ogb.ogb60=0
            LET b_ogb.ogb63=0
            LET b_ogb.ogb64=0
            LET b_ogb.ogb1005 = '1'  #No.TQC-740232
            LET b_ogb.ogb1012 = 'N'  #No.TQC-740232
            LET b_ogb.ogb11 = ''     #MOD-AC0412
            LET g_ogb[l_ac].ogb930=s_costcenter(g_oga.oga15) #FUN-670063
            LET g_ogb[l_ac].gem02c=s_costcenter_desc(g_ogb[l_ac].ogb930) #FUN-670063
            LET g_ogb_t.* = g_ogb[l_ac].*             #新輸入資料
            LET g_before_input_done = FALSE
            CALL t650_set_entry_b('')
            CALL t650_set_no_entry_b('')
            LET g_change='Y'
            LET g_yes   ='N'
            CALL t650_set_no_required('u')
            CALL t650_set_required('u')
            LET g_before_input_done = TRUE
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD ogb03
 
        BEFORE FIELD ogb03                            #default 序號
            IF g_ogb[l_ac].ogb03 IS NULL OR g_ogb[l_ac].ogb03 = 0 THEN
            #FUN-A60035 ---MARK BEGIN 
            ##FUN-A50054 --Begin
            #  IF s_industry("slk") THEN
            #     SELECT MAX(ata02)+1 INTO g_ogb[l_ac].ogb03
            #       FROM ata_file WHERE ata00 = g_prog
            #        AND ata01 = g_oga.oga01
            #  ELSE
            ##FUN-A50054 --End
            #FUN-A60035 ---MARK END
                  SELECT max(ogb03)+1 INTO g_ogb[l_ac].ogb03
                     FROM ogb_file WHERE ogb01 = g_oga.oga01
            #   END IF  #FUN-A50054 add by dxfwo    #FUN-A60035 ---MARK 
                  IF g_ogb[l_ac].ogb03 IS NULL THEN
                     LET g_ogb[l_ac].ogb03 = 1
                  END IF
#              END IF  #FUN-A50054 add   
            END IF
 
        AFTER FIELD ogb03                        #check 序號是否重複
            IF NOT cl_null(g_ogb[l_ac].ogb03) THEN
               IF g_ogb[l_ac].ogb03 != g_ogb_t.ogb03 AND g_ogb_t.ogb17='Y' THEN
                  LET g_ogb[l_ac].ogb03 = g_ogb_t.ogb03
                  CALL cl_err('','axm-168',0) NEXT FIELD ogb03
               END IF
               IF g_ogb[l_ac].ogb03 != g_ogb_t.ogb03 OR
                  g_ogb_t.ogb03 IS NULL THEN
                 #FUN-A60035 ---MARK BEGIN
                 ##FUN-A50054 --Begin
                 #IF s_industry("slk") THEN
                 #   SELECT COUNT(*) INTO l_n FROM ata_file
                 #    WHERE ata00 = g_prog
                 #      AND ata01 = g_oga.oga01
                 #      AND ata02 = g_ogb[l_ac].ogb03
                 #ELSE
                 ##FUN-A50054 --End
                 #FUN-A60035 ---MARK END
                     SELECT count(*) INTO l_n FROM ogb_file
                      WHERE ogb01 = g_oga.oga01 AND ogb03 = g_ogb[l_ac].ogb03
                 # END IF  #FUN-A50054    #FUN-A60035 ---MARK
                   IF l_n > 0 THEN
                      LET g_ogb[l_ac].ogb03 = g_ogb_t.ogb03
                      CALL cl_err('',-239,0) NEXT FIELD ogb03
                   END IF
               END IF
            END IF
 
        BEFORE FIELD ogb04
           CALL t650_set_entry_b(p_cmd)
           CALL t650_set_no_required(p_cmd)
          #LET l_ogb04_t = g_ogb[l_ac].ogb04   #MOD-AB0034 #MOD-B20123 mark
 
        AFTER FIELD ogb04
       #FUN-A60035 ---MARK BEGIN
       ##FUN-A50054---Begin
       #IF s_industry("slk") THEN
       #   IF p_cmd='a' OR (p_cmd='u' AND g_ogb[l_ac].ogb04 != g_ogb_t.ogb04) THEN
       #      SELECT COUNT(*)                      
       #        INTO l_count
       #        FROM ata_file
       #        WHERE ata00 = g_prog
       #          AND ata01 = g_oga.oga01
       #          AND ata05 = g_ogb[l_ac].ogb04
       #      IF l_count>0  THEN
       #         CALL cl_err('','aim1100',0)
       #         NEXT FIELD ogb04
       #      END IF
       #   END IF
       #END IF 
       ##FUN-A50054---end
       #FUN-A60035 ---MARK END
           CALL t650_set_ogb06_no_entry() #FUN-560235
           IF NOT cl_null(g_ogb[l_ac].ogb04) THEN
#FUN-AA0059 ---------------------start----------------------------
              IF NOT s_chk_item_no(g_ogb[l_ac].ogb04,"") THEN
                 CALL cl_err('',g_errno,1)
                 LET g_ogb[l_ac].ogb04= g_ogb_t.ogb04
                 NEXT FIELD ogb04
              END IF
#FUN-AA0059 ---------------------end-------------------------------
              SELECT ima02,ima021,ima31,ima35,ima36,imaacti     #No.+084
                INTO g_buf,g_buf1,l_b2,l_ima35,l_ima36,l_imaacti
                FROM ima_file WHERE ima01=g_ogb[l_ac].ogb04
              IF STATUS AND g_ogb[l_ac].ogb04[1,4] != 'MISC' THEN #NO:6808
                 LET g_ogb[l_ac].ogb06=NULL #FUN-560235
                 DISPLAY g_ogb[l_ac].ogb06 TO ogb06 #FUN-560235
                 CALL cl_err3("sel","ima_file",g_ogb[l_ac].ogb04,"",STATUS,"","sel ima",1)  #No.FUN-660167
                 NEXT FIELD ogb04
              END IF
             #FUN-A60035 ---MARK BEGIN
             ##FUN-A50054---Begin add
             #IF s_industry("slk") THEN
             #   SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01= g_ogb[l_ac].ogb04  #NO.FUN-60035 add
             #   IF g_sma.sma120='Y' AND l_ima151='Y' THEN
             #      CALL cl_set_comp_entry("ogb12",FALSE)
             #   IF g_sma.sma120='Y' THEN      
             #      CALL s_detail(g_prog,g_oga.oga01,g_ogb[l_ac].ogb03,g_ogb[l_ac].ogb04,'N') #FUN-A50054
             #           RETURNING g_ogb[l_ac].ogb12
             #      DISPLAY BY NAME g_ogb[l_ac].ogb12
             #   END IF
             #   END IF 
             #ELSE 
             #	 CALL cl_set_comp_entry("ogb12",TRUE)  
             #END IF         
             ##FUN-A50054---End    
             #FUN-A60035 ---MARK END 
              LET l_misc=g_ogb[l_ac].ogb04[1,4]
              IF g_ogb[l_ac].ogb04[1,4]='MISC' THEN  #NO:6808
                   SELECT COUNT(*) INTO l_n FROM ima_file
                    WHERE ima01=l_misc
                      AND ima01='MISC'
                   IF l_n=0 THEN
                      CALL cl_err('','aim-806',0)
                      NEXT FIELD ogb04
                   END IF
                   CALL t650_set_ogb06_entry() #FUN-560235
              END IF
              IF l_imaacti = 'N' THEN
                 CALL cl_err(l_imaacti,'9028',0)
                 NEXT FIELD ogb04
              END IF
              #IF cl_null(g_ogb[l_ac].ogb05) THEN   #MOD-AB0034
             #IF (g_ogb[l_ac].ogb04<>l_ogb04_t) OR cl_null(g_ogb[l_ac].ogb05) THEN   #MOD-AB0034 #MOD-B20123 mark 
              IF p_cmd='a' OR (p_cmd='u' AND (g_ogb[l_ac].ogb04<>l_ogb04_t)) OR cl_null(g_ogb[l_ac].ogb05) THEN   #MOD-B20123
                 LET g_ogb[l_ac].ogb05=l_b2
              END IF
              #IF cl_null(g_ogb[l_ac].ogb09) THEN   #MOD-AB0034
             #IF (g_ogb[l_ac].ogb04<>l_ogb04_t) OR cl_null(g_ogb[l_ac].ogb09) THEN   #MOD-AB0034 #MOD-B20123 mark 
              IF p_cmd='a' OR (p_cmd='u' AND (g_ogb[l_ac].ogb04<>l_ogb04_t)) OR cl_null(g_ogb[l_ac].ogb09) THEN   #MOD-B20123
                 LET g_ogb[l_ac].ogb09=l_ima35
              END IF
              #IF cl_null(g_ogb[l_ac].ogb091) THEN   #MOD-AB0034
             #IF (g_ogb[l_ac].ogb04<>l_ogb04_t) OR cl_null(g_ogb[l_ac].ogb091) THEN   #MOD-AB0034 #MOD-B20123 mark 
              IF p_cmd='a' OR (p_cmd='u' AND (g_ogb[l_ac].ogb04<>l_ogb04_t)) OR cl_null(g_ogb[l_ac].ogb091) THEN   #MOD-B20123 
                 LET g_ogb[l_ac].ogb091=l_ima36
              END IF
              #IF (g_ogb[l_ac].ogb04<>g_ogb_t.ogb04) OR g_ogb[l_ac].ogb06 IS NULL THEN #NO:6808   #MOD-AB0034
             #IF (g_ogb[l_ac].ogb04<>l_ogb04_t) OR cl_null(g_ogb[l_ac].ogb06) THEN    #MOD-AB0034 #MOD-B20123 mark 
              IF p_cmd='a' OR (p_cmd='u' AND (g_ogb[l_ac].ogb04<>l_ogb04_t)) OR cl_null(g_ogb[l_ac].ogb06) THEN    #MOD-B20123 
                  LET g_ogb[l_ac].ogb06 = g_buf
                  LET g_ogb[l_ac].ima021= g_buf1
              END IF
              LET g_buf = NULL
              LET g_buf1 = NULL
              SELECT obk03 INTO g_buf FROM obk_file
                     WHERE obk01 = g_ogb[l_ac].ogb04 AND obk02 = g_oga.oga03
              IF cl_null(b_ogb.ogb11) THEN LET b_ogb.ogb11 = g_buf END IF
              DISPLAY BY NAME g_ogb[l_ac].ogb05,g_ogb[l_ac].ogb06, #FUN-560235
                              g_ogb[l_ac].ima021, g_ogb[l_ac].ogb09, #FUN-560235
                              g_ogb[l_ac].ogb091 #FUN-560235
              IF g_sma.sma115 = 'Y' THEN
                 CALL s_chk_va_setting(g_ogb[l_ac].ogb04)
                      RETURNING g_flag,g_ima906,g_ima907
                 IF g_flag=1 THEN
                    NEXT FIELD ogb04
                 END IF
                 CALL s_chk_va_setting1(g_ogb[l_ac].ogb04)
                      RETURNING g_flag,g_ima908
                 IF g_flag=1 THEN
                    NEXT FIELD ogb04
                 END IF
                 IF g_ima906 = '3' THEN
                    LET g_ogb[l_ac].ogb913=g_ima907
                 END IF
              END IF
              IF g_sma.sma116 MATCHES '[23]' THEN    #No.FUN-610076
                 #使用計價單位但是不使用多單位的時候，g_ima908值為NULL
                 IF cl_null(g_ima908) THEN
                    SELECT ima908 INTO g_ima908 FROM ima_file
                     WHERE ima01 = g_ogb[l_ac].ogb04
                 END IF
                 IF cl_null(g_ogb[l_ac].ogb916) THEN
                    LET g_ogb[l_ac].ogb916=g_ima908
                 END IF
              END IF
              LET g_ima31 = l_b2
              SELECT ima25 INTO g_ima25 FROM ima_file
               WHERE ima01=g_ogb[l_ac].ogb04
                 CALL t650_du_default(p_cmd)
           END IF
           CALL t650_set_no_entry_b(p_cmd)
           CALL t650_set_required(p_cmd)
           LET l_ogb04_t = g_ogb[l_ac].ogb04   #MOD-AB0034
 
        AFTER FIELD ogb41
          IF NOT cl_null(g_ogb[l_ac].ogb41) THEN
             SELECT COUNT(*) INTO g_cnt FROM pja_file
              WHERE pja01 = g_ogb[l_ac].ogb41
                AND pjaacti = 'Y'
                AND pjaclose='N'             #FUN-960038
             IF g_cnt = 0 THEN
                CALL cl_err(g_ogb[l_ac].ogb41,'asf-984',0)
                NEXT FIELD ogb41
             END IF
          ELSE
             NEXT FIELD ogb13    #NO.MOD-840220
          END IF
 
        BEFORE FIELD ogb42
          IF cl_null(g_ogb[l_ac].ogb41) THEN
             NEXT FIELD ogb41
          END IF
 
        AFTER FIELD ogb42
          IF NOT cl_null(g_ogb[l_ac].ogb42) THEN
             SELECT COUNT(*) INTO g_cnt FROM pjb_file
              WHERE pjb01 = g_ogb[l_ac].ogb41
                AND pjb02 = g_ogb[l_ac].ogb42
                AND pjbacti = 'Y'
             IF g_cnt = 0 THEN
                CALL cl_err(g_ogb[l_ac].ogb42,'apj-051',0)
                LET g_ogb[l_ac].ogb42 = g_ogb_t.ogb42
                NEXT FIELD ogb42
             ELSE
                SELECT pjb09,pjb11 INTO l_pjb09,l_pjb11 
                 FROM pjb_file WHERE pjb01 = g_ogb[l_ac].ogb41
                  AND pjb02 = g_ogb[l_ac].ogb42
                  AND pjbacti = 'Y'            
                IF l_pjb09 != 'Y' OR l_pjb11 != 'Y' THEN
                   CALL cl_err(g_ogb[l_ac].ogb42,'apj-090',0)
                   LET g_ogb[l_ac].ogb42 = g_ogb_t.ogb42
                   NEXT FIELD ogb42
                END IF
             END IF
             SELECT pjb25 INTO l_pjb25 FROM pjb_file
              WHERE pjb02 = g_ogb[l_ac].ogb42
             IF l_pjb25 = 'Y' THEN
                NEXT FIELD ogb43
             ELSE
                LET g_ogb[l_ac].ogb43 = ' '
                DISPLAY BY NAME g_ogb[l_ac].ogb43
                NEXT FIELD ogb43
             END IF
          END IF
 
        BEFORE FIELD ogb43
          IF cl_null(g_ogb[l_ac].ogb42) THEN
             NEXT FIELD ogb42
          ELSE
             SELECT pjb25 INTO l_pjb25 FROM pjb_file
              WHERE pjb02 = g_ogb[l_ac].ogb42
             IF l_pjb25 = 'N' THEN  #WBS不做活動時，活動帶空白，跳開不輸入
                LET g_ogb[l_ac].ogb43 = ' '
                DISPLAY BY NAME g_ogb[l_ac].ogb43
                NEXT FIELD ogb13       #NO.MOD-840220
             END IF
          END IF
 
        AFTER FIELD ogb43     #活動
          IF NOT cl_null(g_ogb[l_ac].ogb43) THEN
             SELECT COUNT(*) INTO g_cnt FROM pjk_file
              WHERE pjk02 = g_ogb[l_ac].ogb43
                AND pjk11 = g_ogb[l_ac].ogb42
                AND pjkacti = 'Y'
             IF g_cnt = 0 THEN
                CALL cl_err(g_ogb[l_ac].ogb43,'apj-049',0)
                NEXT FIELD ogb43
             END IF
          END IF
 
        AFTER FIELD ogb092
           IF cl_null(g_ogb[l_ac].ogb092) THEN
              LET g_ogb[l_ac].ogb092 = ' '
           END IF
           #-----MOD-A50013---------
           IF cl_null(g_ogb[l_ac].ogb091) THEN
              LET g_ogb[l_ac].ogb091 = ' '
           END IF
           LET g_cnt = 0 
           SELECT COUNT(*) INTO g_cnt FROM img_file
            WHERE img01 = g_ogb[l_ac].ogb04   #料號
              AND img02 = g_ogb[l_ac].ogb09   #倉庫
              AND img03 = g_ogb[l_ac].ogb091  #儲位
              AND img04 = g_ogb[l_ac].ogb092  #批號
              AND img18 < g_oga.oga02  
           IF g_cnt > 0 THEN
              CALL cl_err('','aim-400',0) 
              NEXT FIELD ogb09
           END IF
           #-----END MOD-A50013-----

        AFTER FIELD ogb1001
           IF NOT cl_null(g_ogb[l_ac].ogb1001) THEN
              SELECT COUNT(*) INTO l_n FROM azf_file
               WHERE azf01 = g_ogb[l_ac].ogb1001
                 AND azfacti ='Y'
                 AND azf02 ='2'
              IF l_n = 0 THEN
                 CALL cl_err(g_ogb[l_ac].ogb1001,'mfg3088',1)
                 NEXT FIELD ogb1001
              END IF
               SELECT azf09 INTO l_azf09 FROM azf_file
                WHERE azf01 = g_ogb[l_ac].ogb1001
                  AND azf02 = '2'  
                  IF l_azf09 != '1' THEN 
                    CALL cl_err('','aoo-400',1)
                    NEXT FIELD ogb1001
                  END IF   
           END IF
 
        AFTER FIELD ogb05
           IF NOT cl_null(g_ogb[l_ac].ogb05) THEN
              SELECT COUNT(*) INTO g_cnt FROM gfe_file
               WHERE gfe01=g_ogb[l_ac].ogb05
              IF g_cnt = 0 THEN
                 CALL cl_err(g_ogb[l_ac].ogb05,'mfg3377',0)
                 NEXT FIELD ogb05
	          END IF
           END IF
 
        AFTER FIELD ogb17
            IF NOT cl_null(g_ogb[l_ac].ogb17) THEN
               IF g_ogb[l_ac].ogb17 = 'Y' THEN
                   LET g_ogb[l_ac].ogb09  = ' '
                   LET g_ogb[l_ac].ogb091 = ' '
                   LET g_ogb[l_ac].ogb092 = ' '

                   #-----MOD-A20117---------
                   DELETE FROM rvbs_file 
                     WHERE rvbs01 = g_oga.oga01
                       AND rvbs02 = g_ogb[l_ac].ogb03
                       AND rvbs13 = 0
                   #-----END MOD-A20117-----
               ELSE
                   DELETE FROM ogc_file
                    WHERE ogc01 = g_oga.oga01
                      AND ogc03 = g_ogb[l_ac].ogb03

                   #-----MOD-A20117---------
                   DELETE FROM rvbs_file 
                     WHERE rvbs01 = g_oga.oga01
                       AND rvbs02 = g_ogb[l_ac].ogb03
                       AND rvbs13 <> 0
                   #-----END MOD-A20117-----
                   
                   #FUN-BA0019 --START--
                   DELETE FROM ogg_file
                     WHERE ogg01 = g_oga.oga01
                       AND ogg03 = g_ogb[l_ac].ogb03                   
               END IF
            END IF
 
        AFTER FIELD ogb13
          IF NOT cl_null(g_oga.oga213) THEN
             IF g_ogb[l_ac].ogb13 < 0 THEN
                CALL cl_err(g_ogb[l_ac].ogb13,'aom-557',0)
                NEXT FIELD ogb13
             END IF
             #FUN-C40089---begin
             SELECT oah08 INTO g_oah08 FROM oah_file WHERE oah01=g_oga.oga31
             IF cl_null(g_oah08) THEN
                LET g_oah08 = 'Y'
             END IF
             IF g_oah08 = 'N' AND g_ogb[l_ac].ogb13 = 0 THEN																											
                CALL cl_err(g_ogb[l_ac].ogb13,'axm-627',0)	  #FUN-C50074																										
                NEXT FIELD ogb13																											
             END IF																											
             #FUN-C40089---end
             SELECT azi03,azi04 INTO t_azi03,t_azi04 FROM azi_file
              WHERE azi01=g_oga.oga23
             LET g_ogb[l_ac].ogb13=cl_digcut(g_ogb[l_ac].ogb13,t_azi03)
             DISPLAY BY NAME g_ogb[l_ac].ogb13
            #FUN-AB0061 Begin---
             IF cl_null(g_ogb[l_ac].ogb37) OR g_ogb[l_ac].ogb37 = 0 THEN
                LET g_ogb[l_ac].ogb37 = g_ogb[l_ac].ogb13
             END IF
            #FUN-AB0061 End-----
             IF cl_null(g_ogb[l_ac].ogb916) THEN
                LET g_ogb[l_ac].ogb916=g_ogb[l_ac].ogb05
                LET g_ogb[l_ac].ogb917=g_ogb[l_ac].ogb12
             END IF
             IF (g_ogb[l_ac].ogb13 <> g_ogb_t.ogb13) OR cl_null(g_ogb_t.ogb13) THEN     #CHI-CB0008 add
                IF g_oga.oga213 = 'N' THEN
                   LET g_ogb[l_ac].ogb14 =g_ogb[l_ac].ogb917*g_ogb[l_ac].ogb13
                   LET g_ogb[l_ac].ogb14t=g_ogb[l_ac].ogb14*(1+g_oga.oga211/100)
                   CALL cl_digcut(g_ogb[l_ac].ogb14,t_azi04)   #No.CHI-6A0004
                        RETURNING g_ogb[l_ac].ogb14
                   CALL cl_digcut(g_ogb[l_ac].ogb14t,t_azi04)  #No.CHI-6A0004 
                        RETURNING g_ogb[l_ac].ogb14t
                ELSE
                   LET g_ogb[l_ac].ogb14t=g_ogb[l_ac].ogb917*g_ogb[l_ac].ogb13
                   LET g_ogb[l_ac].ogb14 =g_ogb[l_ac].ogb14t/(1+g_oga.oga211/100)
                   CALL cl_digcut(g_ogb[l_ac].ogb14t,t_azi04)  #No.CHI-6A0004 
                        RETURNING g_ogb[l_ac].ogb14t
                   CALL cl_digcut(g_ogb[l_ac].ogb14,t_azi04)  #No.CHI-6A0004 
                        RETURNING g_ogb[l_ac].ogb14
                END IF
                DISPLAY BY NAME g_ogb[l_ac].ogb14   #MOD-CB0033 add
                DISPLAY BY NAME g_ogb[l_ac].ogb14t  #MOD-CB0033 add
             END IF                                          #CHI-CB0008 add
          END IF
 
       AFTER FIELD ogb09
           IF g_ogb[l_ac].ogb09 IS NULL THEN LET g_ogb[l_ac].ogb09=' ' END IF
           IF g_oaz.oaz103 <> 'Y' THEN 
              IF NOT cl_null(g_ogb[l_ac].ogb09) AND
                 g_ogb[l_ac].ogb17 = 'N' AND
                 g_ogb[l_ac].ogb04 NOT MATCHES 'MISC*' THEN
 #TQC-B60225 ------------------STA
 #               LET g_ogb[l_ac].ogb091 =' '
 #               LET g_ogb[l_ac].ogb092 =' '
 #               SELECT img09,img10 INTO g_img09,g_img10 FROM img_file
 #                WHERE img01=g_ogb[l_ac].ogb04
 #                  AND img02=g_ogb[l_ac].ogb09
 #                  AND img03=g_ogb[l_ac].ogb091
 #                  AND img04=g_ogb[l_ac].ogb092
 #               IF SQLCA.sqlcode THEN
 #                  CALL cl_err3("sel","img_file",g_ogb[l_ac].ogb04,g_ogb[l_ac].ogb09,SQLCA.sqlcode,"","select img",1) 
 #                  NEXT FIELD ogb09
 #               END IF
                 SELECT COUNT(*) INTO g_cnt FROM img_file
                  WHERE img01=g_ogb[l_ac].ogb04
                    AND img02=g_ogb[l_ac].ogb09
                 IF g_cnt = 0 THEN
                    CALL cl_err3("sel","img_file",g_ogb[l_ac].ogb04,g_ogb[l_ac].ogb09,SQLCA.sqlcode,"","select img",1)
                    NEXT FIELD ogb09
                 END IF
 #TQC-B60225 ------------------END
              END IF
           END IF
           #CHI-CC0014 ------------sta
          #IF g_ogb[l_ac].ogb091 IS NOT NULL AND NOT cl_null(g_ogb[l_ac].ogb09) THEN
           IF NOT cl_null(g_ogb[l_ac].ogb09) THEN
              IF NOT s_chksmz(g_ogb[l_ac].ogb04, g_oga.oga01,
                           g_ogb[l_ac].ogb09, g_ogb[l_ac].ogb091) THEN
                 NEXT FIELD ogb09
              END IF
           END IF
           #CHI-CC0014 ------------end
          IF NOT cl_null(g_ogb[l_ac].ogb09) THEN
              #No.FUN-AA0062  --Begin
              IF NOT s_chk_ware(g_ogb[l_ac].ogb09) THEN
                 NEXT FIELD ogb09
              END IF
              #No.FUN-AA0062  --End
             LET g_cnt=0
             SELECT count(*) INTO g_cnt  FROM imd_file
              WHERE imd01=g_ogb[l_ac].ogb09
                 AND imdacti='Y'
             IF g_cnt=0 THEN
                CALL cl_err(g_ogb[l_ac].ogb09,'axm-993',0)
                NEXT FIELD ogb09
             END IF
          END IF
 
       AFTER FIELD ogb091
        #No.+021 010329 by plum 調整和axmt620一樣,在過帳才去check有無庫存,有無
        #                       此料/倉/儲/批
        #------------------------------------ 檢查料號預設倉儲及單別預設倉儲
        IF g_ogb[l_ac].ogb091 IS NULL THEN LET g_ogb[l_ac].ogb091=' ' END IF
        IF g_ogb[l_ac].ogb092 IS NULL THEN LET g_ogb[l_ac].ogb092=' ' END IF #No.TQC-770039
        #IF NOT cl_null(g_ogb[l_ac].ogb091) THEN   #MOD-AB0033
        IF g_ogb[l_ac].ogb091 IS NOT NULL AND NOT cl_null(g_ogb[l_ac].ogb09) THEN     #MOD-AB0033
           IF NOT s_chksmz(g_ogb[l_ac].ogb04, g_oga.oga01,
                           g_ogb[l_ac].ogb09, g_ogb[l_ac].ogb091) THEN
              NEXT FIELD ogb09
           END IF
         END IF
         IF NOT cl_null(g_ogb[l_ac].ogb09) AND
            g_ogb[l_ac].ogb17 = 'N' AND
            g_ogb[l_ac].ogb04 NOT MATCHES 'MISC*' THEN
            SELECT img09,img10 INTO g_img09,g_img10 FROM img_file
             WHERE img01=g_ogb[l_ac].ogb04
               AND img02=g_ogb[l_ac].ogb09
               AND img03=g_ogb[l_ac].ogb091
               AND img04=g_ogb[l_ac].ogb092
            IF SQLCA.sqlcode THEN
              #FUN-C80107 modify begin---------------------------------121024
              #CALL cl_err3("sel","img_file",g_ogb[l_ac].ogb04,g_ogb[l_ac].ogb092,SQLCA.sqlcode,"","select img",1)  #No.FUN-660167
              #NEXT FIELD ogb092
               LET l_flag = NULL
              #CALL s_inv_shrt_by_warehouse(g_sma.sma894[2,2],g_ogb[l_ac].ogb09) RETURNING l_flag  #FUN-D30024 mark
               CALL s_inv_shrt_by_warehouse(g_ogb[l_ac].ogb09,g_plant) RETURNING l_flag                    #FUN-D30024 add  #TQC-D40078 g_plant
               IF l_flag = 'N' OR l_flag IS NULL THEN
                  CALL cl_err3("sel","img_file",g_ogb[l_ac].ogb04,g_ogb[l_ac].ogb09,SQLCA.sqlcode,"","select img",1)
                  NEXT FIELD ogb092
               ELSE
                  IF g_sma.sma892[3,3] = 'Y' THEN
                     IF NOT cl_confirm('mfg1401') THEN NEXT FIELD ogb092 END IF
                  END IF
                  CALL s_add_img(g_ogb[l_ac].ogb04,g_ogb[l_ac].ogb09,
                                 g_ogb[l_ac].ogb091,g_ogb[l_ac].ogb092,
                                 g_oga.oga01,g_ogb[l_ac].ogb03,g_oga.oga02)
                  IF g_errno='N' THEN
                     NEXT FIELD ogb092
                  END IF
               END IF
              #FUN-C80107 modify end-----------------------------------
            END IF
         END IF
 
        AFTER FIELD ogb908
            IF NOT cl_null(g_ogb[l_ac].ogb908) THEN
               SELECT coc10 INTO l_coc10 FROM coc_file
                WHERE coc03 = g_ogb[l_ac].ogb908
               IF STATUS THEN
                  CALL cl_err3("sel","coc_file",g_ogb[l_ac].ogb908,"",'aco-062',"","",1)  #No.FUN-660167
                  NEXT FIELD ogb908
               END IF
               SELECT COUNT(*) INTO l_cnt FROM coc_file,cod_file,coa_file
                WHERE coc01 = cod01 AND cod03 = coa03
                  AND coa05 = l_coc10
                  AND coa01 = g_ogb[l_ac].ogb04
                  AND coc03 = g_ogb[l_ac].ogb908
               IF l_cnt = 0 THEN
                  CALL cl_err(g_ogb[l_ac].ogb908,'aco-073',0)
                  NEXT FIELD ogb908
               END IF
            END IF
 
        AFTER FIELD ogb12
           IF g_ogb_t.ogb12 IS NULL AND g_ogb[l_ac].ogb12 IS NOT NULL OR
              g_ogb_t.ogb12 IS NOT NULL AND g_ogb[l_ac].ogb12 IS NULL OR
              g_ogb_t.ogb12 <> g_ogb[l_ac].ogb12 THEN
              LET g_change='Y'
           END IF
            IF NOT cl_null(g_ogb[l_ac].ogb12) THEN
               IF g_ogb[l_ac].ogb12 <= 0 THEN
                  CALL cl_err('','mfg9243',0)
                  NEXT FIELD ogb12
               END IF
              IF cl_null(g_ogb[l_ac].ogb916) THEN
                 LET g_ogb[l_ac].ogb916=g_ogb[l_ac].ogb05
                 LET g_ogb[l_ac].ogb917=g_ogb[l_ac].ogb12
              END IF
              IF g_ogb[l_ac].ogb12 > g_img10 THEN
                 LET l_flag = NULL    #FUN-C80107 add
                #CALL s_inv_shrt_by_warehouse(g_sma.sma894[2,2],g_ogb[l_ac].ogb09) RETURNING l_flag   #FUN-C80107 add #FUN-D30024 mark
                 CALL s_inv_shrt_by_warehouse(g_ogb[l_ac].ogb09,g_plant) RETURNING l_flag                     #FUN-D30024 add #TQC-D40078 g_plant
                #IF g_sma.sma894[2,2]='N' OR g_sma.sma894[2,2] IS NULL THEN   #FUN-C80107 mark
                 IF l_flag = 'N' OR l_flag IS NULL THEN           #FUN-C80107 add
                    CALL cl_err(g_ogb[l_ac].ogb12,'axm-280',1)
                    NEXT FIELD ogb12
                 ELSE
                    IF NOT cl_confirm('mfg3469') THEN
                       NEXT FIELD ogb12
                    END IF
                 END IF
              END IF
           END IF
           IF g_change='Y' THEN
              CALL t650_set_ogb917()
           END IF
           IF g_oga.oga213 = 'N' THEN
              LET g_ogb[l_ac].ogb14 =g_ogb[l_ac].ogb917*g_ogb[l_ac].ogb13
              LET g_ogb[l_ac].ogb14t=g_ogb[l_ac].ogb14*(1+g_oga.oga211/100)
              CALL cl_digcut(g_ogb[l_ac].ogb14,t_azi04)     #No:MOD-BB0021 modify
                   RETURNING g_ogb[l_ac].ogb14
              CALL cl_digcut(g_ogb[l_ac].ogb14t,t_azi04)    #No:MOD-BB0021 modify
                   RETURNING g_ogb[l_ac].ogb14t
           ELSE
              LET g_ogb[l_ac].ogb14t=g_ogb[l_ac].ogb917*g_ogb[l_ac].ogb13
              LET g_ogb[l_ac].ogb14 =g_ogb[l_ac].ogb14t/(1+g_oga.oga211/100)
              CALL cl_digcut(g_ogb[l_ac].ogb14t,t_azi04)    #No:MOD-BB0021 modify
                   RETURNING g_ogb[l_ac].ogb14t
              CALL cl_digcut(g_ogb[l_ac].ogb14,t_azi04)     #No:MOD-BB0021 modify
                   RETURNING g_ogb[l_ac].ogb14
           END IF
           SELECT ima918,ima921 INTO g_ima918,g_ima921 
             FROM ima_file
            WHERE ima01 = g_ogb[l_ac].ogb04
              AND imaacti = "Y"
           
           #MOD-CA0220 -- add start --
           SELECT img09 INTO g_img09 FROM img_file
            WHERE img01=g_ogb[l_ac].ogb04
              AND img02=g_ogb[l_ac].ogb09
              AND img03=g_ogb[l_ac].ogb091
              AND img04=g_ogb[l_ac].ogb092
           LET b_ogb.ogb05_fac = 1
           CALL s_umfchk(g_ogb[l_ac].ogb04,g_ogb[l_ac].ogb05,g_img09)
                RETURNING g_cnt,b_ogb.ogb05_fac
           IF g_cnt=1 THEN LET b_ogb.ogb05_fac = 1 END IF
           #MOD-CA0220 -- add end --

           IF (g_ima918 = "Y" OR g_ima921 = "Y") AND 
              (cl_null(g_ogb_t.ogb12) OR (g_ogb[l_ac].ogb12<>g_ogb_t.ogb12 )) THEN
              IF g_ogb[l_ac].ogb17 = 'N' THEN    #MOD-A20117
                 CALL t650_b_move_back()
                 CALL t650_b_else()
                 #CHI-9A0022 --Begin
                 IF cl_null(g_ogb[l_ac].ogb41) THEN
                    LET l_bno = ''
                 ELSE
                    LET l_bno = g_ogb[l_ac].ogb41
                 END IF
                 #CHI-9A0022 --End
                #CALL s_lotout(g_prog,g_oga.oga01,g_ogb[l_ac].ogb03,0,         #TQC-B90236 mark
                 CALL s_mod_lot(g_prog,g_oga.oga01,g_ogb[l_ac].ogb03,0,         #TQC-B90236 add  
                               g_ogb[l_ac].ogb04,g_ogb[l_ac].ogb09,
                               g_ogb[l_ac].ogb091,g_ogb[l_ac].ogb092,
                               g_ogb[l_ac].ogb05,g_img09,b_ogb.ogb05_fac,
                               g_ogb[l_ac].ogb12,l_bno,'MOD',-1)#CHI-9A0022 add l_bno    #TQC-B90236 add '-1'

                     RETURNING l_r,g_qty
                 IF l_r = "Y" THEN
                    LET g_ogb[l_ac].ogb12 = g_qty
                 END IF
              END IF   #MOD-A20117
           END IF
            SELECT ogb1004 INTO l_ogb1004 FROM ogb_file
             WHERE ogb01=g_oga.oga01 AND ogb03=g_ogb_t.ogb03
#           CALL s_fetch_price_new(g_oga.oga03,g_ogb[l_ac].ogb04,g_ogb[l_ac].ogb05,g_oga.oga02,g_oga.oga00,   #MOD-B80206 mark
            CALL s_fetch_price_new(g_oga.oga03,g_ogb[l_ac].ogb04,'',g_ogb[l_ac].ogb05,g_oga.oga02,'2',           #MOD-B80206  #FUN-BC0071
                                   g_plant,g_oga.oga23,g_oga.oga31,g_oga.oga32,g_oga.oga01,g_ogb[l_ac].ogb03,
                                   g_ogb[l_ac].ogb12,l_ogb1004,p_cmd)
              #  RETURNING g_ogb[l_ac].ogb13  # No.FUN-AB0061
                  RETURNING g_ogb[l_ac].ogb13,g_ogb[l_ac].ogb37 # No.FUN-AB0061   
          #FUN-B70087 mod
          #IF g_ogb[l_ac].ogb13=0 THEN CALL s_unitprice_entry(g_oga.oga03,g_oga.oga31,g_plant) END IF #FUN-9C0120
           #FUN-BC0088 ----- add start --------
           IF g_ogb[l_ac].ogb04[1,4] = 'MISC' THEN
              CALL s_unitprice_entry(g_oga.oga03,g_oga.oga31,g_plant,'M')
           ELSE
           #FUN-BC0088 ----- add end --------
              IF g_ogb[l_ac].ogb13=0 THEN
                 CALL s_unitprice_entry(g_oga.oga03,g_oga.oga31,g_plant,'N')
              ELSE
                 CALL s_unitprice_entry(g_oga.oga03,g_oga.oga31,g_plant,'Y')
              END IF
           END IF #FUN-BC0088 add
          #FUN-B70087 mod--end
 
        BEFORE FIELD ogb913
           CALL t650_set_no_required(p_cmd)
 
        AFTER FIELD ogb913  #第二單位
           IF cl_null(g_ogb[l_ac].ogb04) THEN NEXT FIELD ogb04 END IF
           IF g_ogb[l_ac].ogb17 = 'N' THEN
              IF cl_null(g_ogb[l_ac].ogb091) THEN LET g_ogb[l_ac].ogb091 = ' ' END IF
              IF cl_null(g_ogb[l_ac].ogb092) THEN LET g_ogb[l_ac].ogb092 = ' ' END IF
              IF g_ogb[l_ac].ogb09 IS NULL OR g_ogb[l_ac].ogb091 IS NULL OR
                 g_ogb[l_ac].ogb092 IS NULL THEN
                 NEXT FIELD ogb092
              END IF
           END IF
           IF g_ogb_t.ogb913 IS NULL AND g_ogb[l_ac].ogb913 IS NOT NULL OR
              g_ogb_t.ogb913 IS NOT NULL AND g_ogb[l_ac].ogb913 IS NULL OR
              g_ogb_t.ogb913 <> g_ogb[l_ac].ogb913 THEN
              LET g_change='Y'
           END IF
           IF NOT cl_null(g_ogb[l_ac].ogb913) THEN
              SELECT gfe02 INTO g_buf FROM gfe_file
               WHERE gfe01=g_ogb[l_ac].ogb913
                 AND gfeacti='Y'
              IF STATUS THEN
                 CALL cl_err3("sel","gfe_file",g_ogb[l_ac].ogb913,"",STATUS,"","gfe",1)  #No.FUN-660167
                 NEXT FIELD ogb913
              END IF
              CALL s_du_umfchk(g_ogb[l_ac].ogb04,'','','',
                               g_ima31,g_ogb[l_ac].ogb913,g_ima906)
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_ogb[l_ac].ogb913,g_errno,0)
                 NEXT FIELD ogb913
              END IF
              IF cl_null(g_ogb_t.ogb913) OR g_ogb_t.ogb913 <> g_ogb[l_ac].ogb913 THEN
                 LET g_ogb[l_ac].ogb914 = g_factor
              END IF
              IF g_ogb[l_ac].ogb17='N' AND
                 g_ogb[l_ac].ogb04 NOT MATCHES 'MISC*' THEN
                 CALL s_chk_imgg(g_ogb[l_ac].ogb04,g_ogb[l_ac].ogb09,
                                 g_ogb[l_ac].ogb091,g_ogb[l_ac].ogb092,
                                 g_ogb[l_ac].ogb913) RETURNING g_flag
                 IF g_flag = 1 THEN
                   #FUN-C80107 modify begin---------------------------------121024
                   #CALL cl_err('sel imgg',SQLCA.sqlcode,0)
                   #NEXT FIELD ogb092
                    LET l_flag = NULL
                   #CALL s_inv_shrt_by_warehouse(g_sma.sma894[2,2],g_ogb[l_ac].ogb09) RETURNING l_flag #FUN-D30024 mark
                    CALL s_inv_shrt_by_warehouse(g_ogb[l_ac].ogb09,g_plant) RETURNING l_flag                   #FUN-D30024 add #TQC-D40078 g_plant
                    IF l_flag = 'N' OR l_flag IS NULL THEN
                       CALL cl_err('sel imgg',SQLCA.sqlcode,0)
                       NEXT FIELD ogb092
                    ELSE
                       IF g_sma.sma892[3,3] = 'Y' THEN
                          IF NOT cl_confirm('aim-995') THEN
                             NEXT FIELD ogb092
                          END IF
                       END IF
                       CALL s_add_imgg(g_ogb[l_ac].ogb04,g_ogb[l_ac].ogb09,
                                       g_ogb[l_ac].ogb091,g_ogb[l_ac].ogb092,
                                       g_ogb[l_ac].ogb913,g_ogb[l_ac].ogb914,
                                       g_oga.oga01,
                                       g_ogb[l_ac].ogb03,0) RETURNING g_flag
                       IF g_flag = 1 THEN
                          NEXT FIELD ogb092
                       END IF
                    END IF
                   #FUN-C80107 modify end-----------------------------------
                 END IF
                 SELECT imgg10 INTO g_imgg10_2 FROM imgg_file
                  WHERE imgg01=g_ogb[l_ac].ogb04
                    AND imgg02=g_ogb[l_ac].ogb09
                    AND imgg03=g_ogb[l_ac].ogb091
                    AND imgg04=g_ogb[l_ac].ogb092
                    AND imgg09=g_ogb[l_ac].ogb913
                 IF cl_null(g_imgg10_2) THEN LET g_imgg10_2=0 END IF
              END IF
           END IF
           IF g_change='Y' THEN
              CALL t650_set_ogb917()
           END IF
           CALL t650_set_required(p_cmd)
           CALL cl_show_fld_cont()     #FUN-550037(smin)
 
        BEFORE FIELD ogb914  #第二轉換率
           IF cl_null(g_ogb[l_ac].ogb04) THEN NEXT FIELD ogb04 END IF
           IF g_ogb[l_ac].ogb17 = 'N' THEN
              IF g_ogb[l_ac].ogb09 IS NULL OR g_ogb[l_ac].ogb091 IS NULL OR
                 g_ogb[l_ac].ogb092 IS NULL THEN
                 NEXT FIELD ogb092
              END IF
           END IF
           IF NOT cl_null(g_ogb[l_ac].ogb913) THEN
              IF g_ogb[l_ac].ogb17='N' AND g_ima906 = '3' AND
                 g_ogb[l_ac].ogb04 NOT MATCHES 'MISC*' THEN
                 CALL s_chk_imgg(g_ogb[l_ac].ogb04,g_ogb[l_ac].ogb09,
                                 g_ogb[l_ac].ogb091,g_ogb[l_ac].ogb092,
                                 g_ogb[l_ac].ogb913) RETURNING g_flag
                 IF g_flag = 1 THEN
                   #FUN-C80107 modify begin---------------------------------121024
                   #CALL cl_err('sel imgg',SQLCA.sqlcode,0)
                   #NEXT FIELD ogb092
                    LET l_flag = NULL
                   #CALL s_inv_shrt_by_warehouse(g_sma.sma894[2,2],g_ogb[l_ac].ogb09) RETURNING l_flag #FUN-D30024 mark
                    CALL s_inv_shrt_by_warehouse(g_ogb[l_ac].ogb09,g_plant) RETURNING l_flag                   #FUN-D30024 add  #TQC-D40078 g_plant
                    IF l_flag = 'N' OR l_flag IS NULL THEN
                       CALL cl_err('sel imgg',SQLCA.sqlcode,0)
                       NEXT FIELD ogb092
                    ELSE
                       IF g_sma.sma892[3,3] = 'Y' THEN
                          IF NOT cl_confirm('aim-995') THEN
                             NEXT FIELD ogb092
                          END IF
                       END IF
                       CALL s_add_imgg(g_ogb[l_ac].ogb04,g_ogb[l_ac].ogb09,
                                       g_ogb[l_ac].ogb091,g_ogb[l_ac].ogb092,
                                       g_ogb[l_ac].ogb913,g_ogb[l_ac].ogb914,
                                       g_oga.oga01,
                                       g_ogb[l_ac].ogb03,0) RETURNING g_flag
                       IF g_flag = 1 THEN
                          NEXT FIELD ogb092
                       END IF
                    END IF
                   #FUN-C80107 modify end-----------------------------------
                 END IF
                 SELECT imgg10 INTO g_imgg10_2 FROM imgg_file
                  WHERE imgg01=g_ogb[l_ac].ogb04
                    AND imgg02=g_ogb[l_ac].ogb09
                    AND imgg03=g_ogb[l_ac].ogb091
                    AND imgg04=g_ogb[l_ac].ogb092
                    AND imgg09=g_ogb[l_ac].ogb913
                 IF cl_null(g_imgg10_2) THEN LET g_imgg10_2=0 END IF
              END IF
           END IF
 
        AFTER FIELD ogb914  #第二轉換率
           IF g_ogb_t.ogb914 IS NULL AND g_ogb[l_ac].ogb914 IS NOT NULL OR
              g_ogb_t.ogb914 IS NOT NULL AND g_ogb[l_ac].ogb914 IS NULL OR
              g_ogb_t.ogb914 <> g_ogb[l_ac].ogb914 THEN
              LET g_change='Y'
           END IF
           IF NOT cl_null(g_ogb[l_ac].ogb914) THEN
              IF g_ogb[l_ac].ogb914=0 THEN
                 NEXT FIELD ogb914
              END IF
           END IF
 
        BEFORE FIELD ogb915
           IF cl_null(g_ogb[l_ac].ogb04) THEN NEXT FIELD ogb04 END IF
           IF g_ogb[l_ac].ogb17 = 'N' THEN
              IF g_ogb[l_ac].ogb09 IS NULL OR g_ogb[l_ac].ogb091 IS NULL OR
                 g_ogb[l_ac].ogb092 IS NULL THEN
                 NEXT FIELD ogb092
              END IF
           END IF
           IF NOT cl_null(g_ogb[l_ac].ogb913) THEN
              IF g_ogb[l_ac].ogb17='N' AND g_ima906 = '3' AND
                 g_ogb[l_ac].ogb04 NOT MATCHES 'MISC*' THEN
                 CALL s_chk_imgg(g_ogb[l_ac].ogb04,g_ogb[l_ac].ogb09,
                                 g_ogb[l_ac].ogb091,g_ogb[l_ac].ogb092,
                                 g_ogb[l_ac].ogb913) RETURNING g_flag
                 IF g_flag = 1 THEN
                   #FUN-C80107 modify begin---------------------------------121024
                   #CALL cl_err('sel imgg',SQLCA.sqlcode,0)
                   #NEXT FIELD ogb092
                    LET l_flag = NULL
                   #CALL s_inv_shrt_by_warehouse(g_sma.sma894[2,2],g_ogb[l_ac].ogb09) RETURNING l_flag #FUN-D30024 mark
                    CALL s_inv_shrt_by_warehouse(g_ogb[l_ac].ogb09,g_plant) RETURNING l_flag                   #FUN-D30024 add  #TQC-D40078 g_plant
                    IF l_flag = 'N' OR l_flag IS NULL THEN
                       CALL cl_err('sel imgg',SQLCA.sqlcode,0)
                       NEXT FIELD ogb092
                    ELSE
                       IF g_sma.sma892[3,3] = 'Y' THEN
                          IF NOT cl_confirm('aim-995') THEN
                             NEXT FIELD ogb092
                          END IF
                       END IF
                       CALL s_add_imgg(g_ogb[l_ac].ogb04,g_ogb[l_ac].ogb09,
                                       g_ogb[l_ac].ogb091,g_ogb[l_ac].ogb092,
                                       g_ogb[l_ac].ogb913,g_ogb[l_ac].ogb914,
                                       g_oga.oga01,
                                       g_ogb[l_ac].ogb03,0) RETURNING g_flag
                       IF g_flag = 1 THEN
                          NEXT FIELD ogb092
                       END IF
                    END IF
                   #FUN-C80107 modify end-----------------------------------
                 END IF
                 SELECT imgg10 INTO g_imgg10_2 FROM imgg_file
                  WHERE imgg01=g_ogb[l_ac].ogb04
                    AND imgg02=g_ogb[l_ac].ogb09
                    AND imgg03=g_ogb[l_ac].ogb091
                    AND imgg04=g_ogb[l_ac].ogb092
                    AND imgg09=g_ogb[l_ac].ogb913
                 IF cl_null(g_imgg10_2) THEN LET g_imgg10_2=0 END IF
              END IF
           END IF
 
        AFTER FIELD ogb915  #第二數量
           IF g_ogb_t.ogb915 IS NULL AND g_ogb[l_ac].ogb915 IS NOT NULL OR
              g_ogb_t.ogb915 IS NOT NULL AND g_ogb[l_ac].ogb915 IS NULL OR
              g_ogb_t.ogb915 <> g_ogb[l_ac].ogb915 THEN
              LET g_change='Y'
           END IF
           IF NOT cl_null(g_ogb[l_ac].ogb915) THEN
              IF g_ogb[l_ac].ogb915 < 0 THEN
                 CALL cl_err('','aim-391',0)  #
                 NEXT FIELD ogb915
              END IF
              IF p_cmd = 'a' THEN
                 IF g_ima906='3' THEN
                    LET g_tot=g_ogb[l_ac].ogb915*g_ogb[l_ac].ogb914
                    IF cl_null(g_ogb[l_ac].ogb912) OR g_ogb[l_ac].ogb912=0 THEN #CHI-960022
                       LET g_ogb[l_ac].ogb912=g_tot*g_ogb[l_ac].ogb911
                       DISPLAY BY NAME g_ogb[l_ac].ogb912                       #CHI-960022
                    END IF                                                      #CHI-960022
                 END IF
              END IF
              IF g_sma.sma117 = 'N' THEN
                 IF g_ogb[l_ac].ogb915 > g_imgg10_2 THEN
                    LET l_flag = NULL    #FUN-C80107 add
                   #CALL s_inv_shrt_by_warehouse(g_sma.sma894[2,2],g_ogb[l_ac].ogb09) RETURNING l_flag #FUN-C80107 add #FUN-D30024 mark
                    CALL s_inv_shrt_by_warehouse(g_ogb[l_ac].ogb09,g_plant) RETURNING l_flag                   #FUN-D30024 add  #TQC-D40078 g_plant
                   #IF g_sma.sma894[2,2]='N' OR g_sma.sma894[2,2] IS NULL THEN   #FUN-C80107 mark
                    IF l_flag = 'N' OR l_flag IS NULL THEN           #FUN-C80107 add
                       CALL cl_err(g_ogb[l_ac].ogb915,'mfg1303',1)
                       NEXT FIELD ogb915
                    ELSE
                       IF NOT cl_confirm('mfg3469') THEN
                          NEXT FIELD ogb915
                       ELSE
                          LET g_yes = 'Y'
                       END IF
                    END IF
                 END IF
              END IF
           END IF
           SELECT ima918,ima921 INTO g_ima918,g_ima921 
             FROM ima_file
            WHERE ima01 = g_ogb[l_ac].ogb04
              AND imaacti = "Y"
           
           #MOD-CA0220 -- add start --
           SELECT img09 INTO g_img09 FROM img_file
            WHERE img01=g_ogb[l_ac].ogb04
              AND img02=g_ogb[l_ac].ogb09
              AND img03=g_ogb[l_ac].ogb091
              AND img04=g_ogb[l_ac].ogb092
           LET b_ogb.ogb05_fac = 1
           CALL s_umfchk(g_ogb[l_ac].ogb04,g_ogb[l_ac].ogb05,g_img09)
                RETURNING g_cnt,b_ogb.ogb05_fac
           IF g_cnt=1 THEN LET b_ogb.ogb05_fac = 1 END IF
           #MOD-CA0220 -- add end --

           IF (g_ima918 = "Y" OR g_ima921 = "Y") AND 
              (cl_null(g_ogb_t.ogb917) OR (g_ogb[l_ac].ogb917<>g_ogb_t.ogb917 )) THEN
              IF g_ogb[l_ac].ogb17 = 'N' THEN    #MOD-A20117
                 CALL t650_b_move_back()
                 CALL t650_b_else()
                 #CHI-9A0022 --Begin
                 IF cl_null(g_ogb[l_ac].ogb41) THEN
                    LET l_bno = ''
                 ELSE
                    LET l_bno = g_ogb[l_ac].ogb41
                 END IF
                 #CHI-9A0022 --End
                #CALL s_lotout(g_prog,g_oga.oga01,g_ogb[l_ac].ogb03,0,       #TQC-B90236 mark
                 CALL s_mod_lot(g_prog,g_oga.oga01,g_ogb[l_ac].ogb03,0,       #TQC-B90236 add
                               g_ogb[l_ac].ogb04,g_ogb[l_ac].ogb09,
                               g_ogb[l_ac].ogb091,g_ogb[l_ac].ogb092,
                               g_ogb[l_ac].ogb05,g_img09,b_ogb.ogb05_fac,
                               g_ogb[l_ac].ogb12,l_bno,'MOD',-1)#CHI-9A0022 add l_bno    #TQC-B90236 add '-1'
                     RETURNING l_r,g_qty
                 IF l_r = "Y" THEN
                    LET g_ogb[l_ac].ogb12 = g_qty
                 END IF
              END IF   #MOD-A20117
           END IF
           IF g_change='Y' THEN
              CALL t650_set_ogb917()
           END IF
           CALL cl_show_fld_cont()     #FUN-550037(smin)
 
        BEFORE FIELD ogb910
           CALL t650_set_no_required('')
 
        AFTER FIELD ogb910  #第一單位
           IF cl_null(g_ogb[l_ac].ogb04) THEN NEXT FIELD ogb04 END IF
           IF g_ogb[l_ac].ogb17 = 'N' THEN
              IF cl_null(g_ogb[l_ac].ogb091) THEN LET g_ogb[l_ac].ogb091 = ' ' END IF
              IF cl_null(g_ogb[l_ac].ogb092) THEN LET g_ogb[l_ac].ogb092 = ' ' END IF
              IF g_ogb[l_ac].ogb09 IS NULL OR g_ogb[l_ac].ogb091 IS NULL OR
                 g_ogb[l_ac].ogb092 IS NULL THEN
                 NEXT FIELD ogb092
              END IF
           END IF
           IF g_ogb_t.ogb910 IS NULL AND g_ogb[l_ac].ogb910 IS NOT NULL OR
              g_ogb_t.ogb910 IS NOT NULL AND g_ogb[l_ac].ogb910 IS NULL OR
              g_ogb_t.ogb910 <> g_ogb[l_ac].ogb910 THEN
              LET g_change='Y'
           END IF
           IF NOT cl_null(g_ogb[l_ac].ogb910) THEN
              SELECT gfe02 INTO g_buf FROM gfe_file
               WHERE gfe01=g_ogb[l_ac].ogb910
                 AND gfeacti='Y'
              IF STATUS THEN
                 CALL cl_err3("sel","gfe_file",g_ogb[l_ac].ogb910,"",STATUS,"","gfe",1)  #No.FUN-660167
                 NEXT FIELD ogb910
              END IF
              CALL t650_set_origin_field()   #MOD-A70108
              CALL s_du_umfchk(g_ogb[l_ac].ogb04,'','','',
                               g_ogb[l_ac].ogb05,g_ogb[l_ac].ogb910,'1')
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_ogb[l_ac].ogb910,g_errno,0)
                 NEXT FIELD ogb910
              END IF
              IF cl_null(g_ogb_t.ogb910) OR g_ogb_t.ogb910 <> g_ogb[l_ac].ogb910 THEN
                 LET g_ogb[l_ac].ogb911 = g_factor
              END IF
              IF g_ogb[l_ac].ogb17='N' AND
                 g_ogb[l_ac].ogb04 NOT MATCHES 'MISC*' THEN
                 SELECT ima906 INTO g_ima906 FROM ima_file
                  WHERE ima01=g_ogb[l_ac].ogb04
                 IF g_ima906 = '2' THEN
                    CALL s_chk_imgg(g_ogb[l_ac].ogb04,g_ogb[l_ac].ogb09,
                                    g_ogb[l_ac].ogb091,g_ogb[l_ac].ogb092,
                                    g_ogb[l_ac].ogb910) RETURNING g_flag
                    IF g_flag = 1 THEN
                      #FUN-C80107 modify begin---------------------------------121024
                      #CALL cl_err('sel imgg',SQLCA.sqlcode,0)
                      #NEXT FIELD ogb092
                       LET l_flag = NULL
                      #CALL s_inv_shrt_by_warehouse(g_sma.sma894[2,2],g_ogb[l_ac].ogb09) RETURNING l_flag #FUN-D30024 mark
                       CALL s_inv_shrt_by_warehouse(g_ogb[l_ac].ogb09,g_plant) RETURNING l_flag                   #FUN-D30024 add  #TQC-D40078 g_plant
                       IF l_flag = 'N' OR l_flag IS NULL THEN
                          CALL cl_err('sel imgg',SQLCA.sqlcode,0)
                          NEXT FIELD ogb092
                       ELSE
                          IF g_sma.sma892[3,3] = 'Y' THEN
                             IF NOT cl_confirm('aim-995') THEN
                                NEXT FIELD ogb092
                             END IF
                          END IF
                          CALL s_add_imgg(g_ogb[l_ac].ogb04,g_ogb[l_ac].ogb09,
                                          g_ogb[l_ac].ogb091,g_ogb[l_ac].ogb092,
                                          g_ogb[l_ac].ogb910,g_ogb[l_ac].ogb911,
                                          g_oga.oga01,
                                          g_ogb[l_ac].ogb03,0) RETURNING g_flag
                          IF g_flag = 1 THEN
                             NEXT FIELD ogb092
                          END IF
                       END IF
                      #FUN-C80107 modify end-----------------------------------
                    END IF
                 END IF
                 IF g_ima906 = '2' THEN
                    SELECT imgg10 INTO g_imgg10_1 FROM imgg_file
                     WHERE imgg01=g_ogb[l_ac].ogb04
                       AND imgg02=g_ogb[l_ac].ogb09
                       AND imgg03=g_ogb[l_ac].ogb091
                       AND imgg04=g_ogb[l_ac].ogb092
                       AND imgg09=g_ogb[l_ac].ogb910
                 ELSE
                    SELECT img10 INTO g_imgg10_1 FROM img_file
                     WHERE img01=g_ogb[l_ac].ogb04
                       AND img02=g_ogb[l_ac].ogb09
                       AND img03=g_ogb[l_ac].ogb091
                       AND img04=g_ogb[l_ac].ogb092
                 END IF
                 IF cl_null(g_imgg10_1) THEN LET g_imgg10_1=0 END IF
              END IF
           END IF
           #-----MOD-A70108---------
           IF g_change='Y' THEN
              CALL t650_set_ogb917()
           END IF
           #-----END MOD-A70108-----
           CALL t650_set_required('')
           CALL cl_show_fld_cont()     #FUN-550037(smin)
 
        AFTER FIELD ogb911  #第一轉換率
           IF g_ogb_t.ogb911 IS NULL AND g_ogb[l_ac].ogb911 IS NOT NULL OR
              g_ogb_t.ogb911 IS NOT NULL AND g_ogb[l_ac].ogb911 IS NULL OR
              g_ogb_t.ogb911 <> g_ogb[l_ac].ogb911 THEN
              LET g_change='Y'
           END IF
           IF NOT cl_null(g_ogb[l_ac].ogb911) THEN
              IF g_ogb[l_ac].ogb911=0 THEN
                 NEXT FIELD ogb911
              END IF
           END IF
 
        AFTER FIELD ogb912  #第一數量
           IF g_ogb_t.ogb912 IS NULL AND g_ogb[l_ac].ogb912 IS NOT NULL OR
              g_ogb_t.ogb912 IS NOT NULL AND g_ogb[l_ac].ogb912 IS NULL OR
              g_ogb_t.ogb912 <> g_ogb[l_ac].ogb912 THEN
              LET g_change='Y'
           END IF
           IF NOT cl_null(g_ogb[l_ac].ogb912) THEN
              IF g_ogb[l_ac].ogb912 <= 0 THEN     #No.MOD-5B0113
                 IF g_ima906 != '2' OR                              #NO.MOD-740479
                   (g_ima906='2' AND g_ogb[l_ac].ogb912 < 0 )THEN   #NO.MOD-740479
                    CALL cl_err('','aim-391',0)  #
                    NEXT FIELD ogb912
                 END IF                           #NO.MOD-740479
              END IF
              #IF g_ogb[l_ac].ogb17 = 'N' AND g_sma.sma117 = "N" THEN  #No.FUN-610090                      #MOD-BB0010 mark
              IF g_ogb[l_ac].ogb17 = 'N' AND g_sma.sma117 = "N" AND g_ogb[l_ac].ogb04[1,4] !='MISC' THEN   #MOD-BB0010 add
                 IF g_ima906 = '2' THEN
                    IF g_ogb[l_ac].ogb912 > g_imgg10_1 THEN
                       LET l_flag = NULL    #FUN-C80107 add
                      #CALL s_inv_shrt_by_warehouse(g_sma.sma894[2,2],g_ogb[l_ac].ogb09) RETURNING l_flag  #FUN-C80107 add #FUN-D30024 mark
                       CALL s_inv_shrt_by_warehouse(g_ogb[l_ac].ogb09,g_plant) RETURNING l_flag                    #FUN-D30024 add #TQC-D40078 g_plant
                     # IF g_sma.sma894[2,2]='N' OR g_sma.sma894[2,2] IS NULL THEN   #FUN-C80107 mark
                       IF l_flag = 'N' OR l_flag IS NULL THEN           #FUN-C80107 add
                          CALL cl_err(g_ogb[l_ac].ogb912,'mfg1303',1)
                          NEXT FIELD ogb912
                       ELSE
                          IF NOT cl_confirm('mfg3469') THEN
                             NEXT FIELD ogb912
                          ELSE
                             LET g_yes = 'Y'
                          END IF
                       END IF
                    END IF
                 ELSE
                    SELECT img09 INTO g_img09 FROM img_file
                     WHERE img01=g_ogb[l_ac].ogb04
                       AND img02=g_ogb[l_ac].ogb09
                       AND img03=g_ogb[l_ac].ogb091
                       AND img04=g_ogb[l_ac].ogb092
                    IF SQLCA.sqlcode THEN
                      #FUN-C80107 modify begin-----------------------------------121024
                      #CALL cl_err3("sel","img_file",g_ogb[l_ac].ogb04,g_ogb[l_ac].ogb092,SQLCA.sqlcode,"","select img",1)  #No.FUN-660167
                      #NEXT FIELD ogb092
                       LET l_flag = NULL
                      #CALL s_inv_shrt_by_warehouse(g_sma.sma894[2,2],g_ogb[l_ac].ogb09) RETURNING l_flag #FUN-D30024 mark
                       CALL s_inv_shrt_by_warehouse(g_ogb[l_ac].ogb09,g_plant) RETURNING l_flag                   #FUN-D30024 add  #TQC-D40078 g_plant
                       IF l_flag = 'N' OR l_flag IS NULL THEN
                          CALL cl_err3("sel","img_file",g_ogb[l_ac].ogb04,g_ogb[l_ac].ogb09,SQLCA.sqlcode,"","select img",1)
                          NEXT FIELD ogb092
                       ELSE
                          IF g_sma.sma892[3,3] = 'Y' THEN
                             IF NOT cl_confirm('mfg1401') THEN NEXT FIELD ogb092 END IF
                          END IF
                          CALL s_add_img(g_ogb[l_ac].ogb04,g_ogb[l_ac].ogb09,
                                         g_ogb[l_ac].ogb091,g_ogb[l_ac].ogb092,
                                         g_oga.oga01,g_ogb[l_ac].ogb03,g_oga.oga02)
                          IF g_errno='N' THEN
                             NEXT FIELD ogb092
                          END IF
                       END IF
                      #FUN-C80107 modify end-----------------------------------
                    END IF
                    LET g_factor = 1
                    CALL s_umfchk(g_ogb[l_ac].ogb04,g_ogb[l_ac].ogb910,g_img09)
                         RETURNING g_cnt,g_factor
                    IF g_cnt = 1 THEN
                      #CALL cl_err('ogb910/img09','mfg3075',1)    #TQC-C50131
                      #TQC-C50131 -- add -- begin
                       CALL cl_err('','mfg3075',1)
                       CALL cl_getmsg('asf-176',g_lang) RETURNING l_msg
                       LET l_msg = l_msg CLIPPED,"(",g_ogb[l_ac].ogb04,")"
                       CALL cl_msgany(10,20,l_msg)
                      #TQC-C50131 -- add -- end
                       NEXT FIELD ogb910
                    END IF
                    IF g_ogb[l_ac].ogb912*g_factor > g_imgg10_1 THEN
                       LET l_flag = NULL    #FUN-C80107 add
                      #CALL s_inv_shrt_by_warehouse(g_sma.sma894[2,2],g_ogb[l_ac].ogb09) RETURNING l_flag  #FUN-C80107 add #FUN-D30024 mark
                       CALL s_inv_shrt_by_warehouse(g_ogb[l_ac].ogb09,g_plant) RETURNING l_flag                    #FUN-D30024 add  #TQC-D40078 g_plant
                      #IF g_sma.sma894[2,2]='N' OR g_sma.sma894[2,2] IS NULL THEN   #FUN-C80107 mark
                       IF l_flag = 'N' OR l_flag IS NULL THEN           #FUN-C80107 add
                          CALL cl_err(g_ogb[l_ac].ogb912,'mfg1303',1)
                          NEXT FIELD ogb912
                       ELSE
                          IF NOT cl_confirm('mfg3469') THEN
                             NEXT FIELD ogb912
                          ELSE
                             LET g_yes = 'Y'
                          END IF
                       END IF
                    END IF
                 END IF
              END IF
           END IF
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           CALL t650_set_origin_field()   #MOD-850147
           #-----MOD-A70108---------
           IF g_change='Y' THEN
              CALL t650_set_ogb917()
           END IF
           #-----END MOD-A70108-----
 
       BEFORE FIELD ogb916
          CALL t650_set_no_required(p_cmd)
 
       AFTER FIELD ogb916  #計價單位
          IF cl_null(g_ogb[l_ac].ogb04) THEN NEXT FIELD ogb04 END IF
          IF NOT cl_null(g_ogb[l_ac].ogb916) THEN
             SELECT gfe02 INTO g_buf FROM gfe_file
              WHERE gfe01=g_ogb[l_ac].ogb916
                AND gfeacti='Y'
             IF STATUS THEN
                CALL cl_err3("sel","gfe_file",g_ogb[l_ac].ogb916,"",STATUS,"","gfe",1)  #No.FUN-660167
                NEXT FIELD ogb916
             END IF
             CALL s_du_umfchk(g_ogb[l_ac].ogb04,'','','',
                              g_ima25,g_ogb[l_ac].ogb916,'1')
                  RETURNING g_errno,g_factor
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_ogb[l_ac].ogb916,g_errno,0)
                NEXT FIELD ogb916
             END IF
          END IF
          CALL t650_set_required(p_cmd)
 
       BEFORE FIELD ogb917
          IF g_change='Y' THEN
             CALL t650_set_ogb917()
          END IF
 
       AFTER FIELD ogb917  #計價數量
          IF NOT cl_null(g_ogb[l_ac].ogb917) THEN
             IF g_ogb[l_ac].ogb917 < 0 THEN
                CALL cl_err('','aim-391',0)  #
                NEXT FIELD ogb917
             END IF
          END IF
 
        
        AFTER FIELD ogb930
           IF NOT s_costcenter_chk(g_ogb[l_ac].ogb930) THEN
              LET g_ogb[l_ac].ogb930=g_ogb_t.ogb930
              LET g_ogb[l_ac].gem02c=g_ogb_t.gem02c
              DISPLAY BY NAME g_ogb[l_ac].ogb930,g_ogb[l_ac].gem02c
              NEXT FIELD ogb930
           ELSE
              LET g_ogb[l_ac].gem02c=s_costcenter_desc(g_ogb[l_ac].ogb930)
              DISPLAY BY NAME g_ogb[l_ac].gem02c
           END IF
 
        AFTER FIELD ogbud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ogbud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ogbud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ogbud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ogbud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ogbud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ogbud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ogbud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ogbud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ogbud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ogbud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ogbud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ogbud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ogbud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ogbud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_ogb_t.ogb03 > 0 AND g_ogb_t.ogb03 IS NOT NULL THEN
#FUN-A60035 ---MARK BEGIN
##FUN-A60035 ---add begin
#              IF s_industry("slk") THEN
#                  DECLARE t650_ata1_d SCROLL CURSOR FOR
#                   SELECT ata03 FROM ata_file
#                    WHERE ata00=g_prog
#                      AND ata01=g_oga.oga01
#                      AND ata02=g_ogb_t.ogb03 
#                  FOREACH t650_ata1_d INTO g_ogb[l_ac].ogb03 
#                     # 立帳數量>0 不可刪除
#                     SELECT SUM(omb12) INTO l_qty FROM oma_file,omb_file
#                      WHERE omb31 = g_oga.oga01
#                        AND omb32 = g_ogb[l_ac].ogb03
#                        AND omb01 = oma01
#                        AND omavoid = 'N'
#                     IF l_qty>0 THEN #AR立帳數量>0
#                        CALL cl_err('','axm-302',0)
#                        CANCEL DELETE
#                     END IF
#                  END FOREACH
#                  LET g_ogb[l_ac].ogb03 = g_ogb_t.ogb03
#               ELSE
##FUN-A60035 ---add end
#FUN-A60035 ---MARK END
                   # 立帳數量>0 不可刪除
                   SELECT SUM(omb12) INTO l_qty FROM oma_file,omb_file
                    WHERE omb31 = g_oga.oga01
                      AND omb32 = g_ogb[l_ac].ogb03
                      AND omb01 = oma01
                      AND omavoid = 'N'
                   IF l_qty>0 THEN #AR立帳數量>0
                      CALL cl_err('','axm-302',0)
                      CANCEL DELETE
                   END IF
#                END IF     #FUN-A60035 ---add    #FUN-A60035 ---MARK
 
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
 
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
	       #FUN-810045 begin
                IF s_chk_rvbs(g_ogb[l_ac].ogb41,g_ogb[l_ac].ogb04) THEN
                 #IF NOT s_del_rvbs("1",g_oga.oga01,g_ogb[l_ac].ogb03,0)  THEN             #FUN-880129  #TQC-B90236
                  IF NOT s_lot_del(g_prog,g_oga.oga01,g_ogb[l_ac].ogb03,0,g_ogb[l_ac].ogb04,'DEL') THEN   #No.FUN-880129   #TQC-B90236
                    ROLLBACK WORK
                    CANCEL DELETE
                  END IF
               END IF
              #FUN-A60035 ---MARK BEGIN
              ##FUN-A50054 --Begin
              #IF s_industry("slk") THEN
              #   DELETE FROM ogb_file 
              #    WHERE ogb01 = g_oga.oga01 
              #      AND ogb03 IN
              #  (SELECT ata03 FROM ata_file 
              #    WHERE ata00 = g_prog
              #      AND ata02 = g_ogb_t.ogb03
              #      AND ata01 = g_oga.oga01)
              #   IF SQLCA.sqlcode THEN
              #      CALL cl_err3("del","ogb_file",g_oga.oga01,g_ogb_t.ogb03,SQLCA.sqlcode,"","",1)
              #   ELSE
              #      DELETE FROM ogbi_file 
              #       WHERE ogbi01 = g_oga.oga01 
              #         AND ogbi03 IN
              #     (SELECT ata03 FROM ata_file 
              #       WHERE ata00 = g_prog
              #         AND ata02 = g_ogb_t.ogb03
              #         AND ata01 = g_oga.oga01)
              #      
              #      IF SQLCA.sqlcode THEN
              #         CALL cl_err3("del","ogbi_file",g_oga.oga01,g_ogb_t.ogb03,SQLCA.sqlcode,"","",1)
              #      ELSE
              #         DELETE FROM ata_file 
              #          WHERE ata00 = g_prog
              #            AND ata02 = g_ogb_t.ogb03
              #            AND ata01 = g_oga.oga01
              #         IF SQLCA.sqlcode THEN
              #            CALL cl_err3("del","ata_file",g_oga.oga01,g_ogb_t.ogb03,SQLCA.sqlcode,"","",1)
              #         END IF
              #      END IF
              #   END IF
              #ELSE
              ##FUN-A50054 --End
              #FUN-A60035 ---MARK END
                  DELETE FROM ogb_file
                   WHERE ogb01 = g_oga.oga01 AND ogb03 = g_ogb_t.ogb03
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("del","ogb_file",g_ogb_t.ogb03,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
                     ROLLBACK WORK
                     CANCEL DELETE
                  ELSE
                  END IF
               #END IF  #FUN-A50054 add  #FUN-A60035 ---MARK
                DELETE FROM ogc_file
                 WHERE ogc01 = g_oga.oga01
                   AND ogc03 = g_ogb_t.ogb03
 
                DELETE FROM ogg_file
                 WHERE ogg01 = g_oga.oga01
                   AND ogg03 = g_ogb_t.ogb03
 
                SELECT ima918,ima921 INTO g_ima918,g_ima921 
                  FROM ima_file
                 WHERE ima01 = g_ogb[l_ac].ogb04
                   AND imaacti = "Y"
                
                IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                  #IF NOT s_lotout_del(g_prog,g_oga.oga01,g_ogb[l_ac].ogb03,0,g_ogb[l_ac].ogb04,'DEL') THEN   #No.FUN-860045   #TQC-B90236
                   IF NOT s_lot_del(g_prog,g_oga.oga01,g_ogb[l_ac].ogb03,0,g_ogb[l_ac].ogb04,'DEL') THEN   #No.FUN-860045   #TQC-B90236
                      CALL cl_err3("del","rvbs_file",g_oga.oga01,g_ogb_t.ogb03,
                                    SQLCA.sqlcode,"","",1)
                       ROLLBACK WORK
                       CANCEL DELETE
                   END IF
                END IF
                CALL t650_mlog('R')
                COMMIT WORK
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        AFTER DELETE
          CALL t650_bu()
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_ogb[l_ac].* = g_ogb_t.*
               CLOSE t650_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_ogb[l_ac].ogb03,-263,1)
               LET g_ogb[l_ac].* = g_ogb_t.*
            ELSE
               IF g_ogb[l_ac].ogb09 IS NULL THEN LET g_ogb[l_ac].ogb09=' ' END IF
               IF g_ogb[l_ac].ogb091 IS NULL THEN LET g_ogb[l_ac].ogb091=' ' END IF
               IF g_ogb[l_ac].ogb092 IS NULL THEN LET g_ogb[l_ac].ogb092=' ' END IF
               IF g_sma.sma115= 'Y' THEN
                  IF NOT cl_null(g_ogb[l_ac].ogb04) THEN
                     SELECT ima25,ima31 INTO g_ima25,g_ima31
                       FROM ima_file WHERE ima01=g_ogb[l_ac].ogb04
                  END IF
 
                  CALL s_chk_va_setting(g_ogb[l_ac].ogb04)
                       RETURNING g_flag,g_ima906,g_ima907
                  IF g_flag=1 THEN
                     NEXT FIELD ogb04
                  END IF
 
                  CALL s_chk_va_setting1(g_ogb[l_ac].ogb04)
                       RETURNING g_flag,g_ima908
                  IF g_flag=1 THEN
                     NEXT FIELD ogb04
                  END IF
 
                  CALL t650_du_data_to_correct()
                  CALL t650_set_origin_field()
               END IF
               IF cl_null(g_ogb[l_ac].ogb916) THEN
                  LET g_ogb[l_ac].ogb916 = g_ogb[l_ac].ogb05
                  LET g_ogb[l_ac].ogb917 = g_ogb[l_ac].ogb12
               END IF
                #IF 有專案且要做預算控管
                # check料件， if料件沒做批號管理也沒做序號管理，則要寫入rvbs_file
                LET g_success = 'Y'
                IF s_chk_rvbs(g_ogb[l_ac].ogb41,g_ogb[l_ac].ogb04) THEN
                   CALL t650_rvbs()
                END IF
                IF g_success = 'N' THEN
                   NEXT FIELD ogb03
                END IF
               CALL t650_b_move_back()
               CALL t650_b_else()

#FUN-A60035 ---MARK BEGIN               
##FUN-A50054 --Begin
#  IF s_industry("slk") THEN
#     DELETE FROM ogb_file WHERE ogb01=g_oga.oga01
#        AND ogb03 NOT IN
#     ( SELECT ata03 FROM ata_file
#       WHERE ata00=g_prog
#         AND ata01=g_oga.oga01)
#     DELETE FROM ogbi_file WHERE ogbi01=g_oga.oga01
#        AND ogbi03 NOT IN
#     ( SELECT ata03 FROM ata_file
#       WHERE ata00=g_prog
#         AND ata01=g_oga.oga01)
#     DELETE FROM ogb_file WHERE ogb01=g_oga.oga01
#        AND ogb03 IN
#     ( SELECT ata03 FROM ata_file
#       WHERE ata00=g_prog
#         AND ata02=g_ogb[l_ac].ogb03
#         AND ata01=g_oga.oga01)
#     DELETE FROM ogbi_file
#      WHERE ogbi01=g_oga.oga01
#        AND ogbi03 IN
#     ( SELECT ata03 FROM ata_file
#       WHERE ata00=g_prog
#         AND ata02=g_ogb[l_ac].ogb03
#         AND ata01=g_oga.oga01)
#     LET l_sql = " SELECT * FROM ata_file ",
#                 "  WHERE ata00 = '",g_prog,"'",
#                 "    AND ata01 = '",g_oga.oga01,"'",
#                 "    AND ata02 = '",g_ogb_t.ogb03,"'"
#     DECLARE t400_ata_curs1 SCROLL CURSOR FROM l_sql
##FUN-A60035 ---add begin
#     IF g_ogb[l_ac].ogb04 <> g_ogb_t.ogb04 THEN     #料號更改時首先更新ata_file
#     FOREACH t400_ata_curs1 INTO l_ata.*
#        LET l_ata.ata04 = cl_replace_str(l_ata.ata04,l_ata.ata05,g_ogb[l_ac].ogb04)
#        UPDATE ata_file SET ata04 = l_ata.ata04,
#                            ata05 = g_ogb[l_ac].ogb04
#         WHERE ata00 = g_prog AND ata01 = g_oga.oga01
#           AND ata02 = g_ogb_t.ogb03
#           AND ata03 = l_ata.ata03
#         IF SQLCA.sqlcode THEN
#            CALL cl_err3("upd","ogb_file",g_oga.oga01,g_ogb_t.ogb03,SQLCA.sqlcode,"","upd ogb",1)
#         END IF
#     END FOREACH
#     END IF
##FUN-A60035 ---add end
#     FOREACH t400_ata_curs1 INTO l_ata.*
#         LET b_ogb.ogb03 = l_ata.ata03
#         LET b_ogb.ogb12 = l_ata.ata08
#         LET b_ogb.ogb04 = l_ata.ata04
#         INSERT INTO ogb_file VALUES(b_ogb.*)
#         IF SQLCA.sqlcode THEN
#            CALL cl_err3("ins","ogb_file",g_oga.oga01,g_ogb_t.ogb03,SQLCA.sqlcode,"","upd ogb",1)  #No.FUN-650108
#            RETURN FALSE
#         ELSE
#            LET b_ogbi.ogbi01 = b_ogb.ogb01
#            LET b_ogbi.ogbi03 = b_ogb.ogb03
#            IF NOT s_ins_ogbi(b_ogbi.*,b_ogb.ogbplant) THEN #FUN-A50054
#               RETURN FALSE
#            END IF
#         END IF
#     END FOREACH
#  ELSE
##FUN-A50054 --End
#FUN-A60035 ---MARK END
               UPDATE ogb_file SET * = b_ogb.*
                WHERE ogb01=g_oga.oga01 AND ogb03=g_ogb_t.ogb03
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","ogb_file",g_oga.oga01,g_ogb_t.ogb03,SQLCA.sqlcode,"","upd ogb",1)  #No.FUN-660167
                  LET g_ogb[l_ac].* = g_ogb_t.*
                  LET g_success = 'N'   #FUN-B80178
               ELSE
               #FUN-B80178 --START--
               END IF 
               
               IF g_success = 'Y' THEN
               #FUN-B80178 --END--               
                  MESSAGE 'UPDATE O.K'
                  CALL t650_mlog('U')
                  CALL t650_bu()
                  COMMIT WORK
                  IF g_ogb[l_ac].ogb12 != g_ogb_t.ogb12 OR
                     g_ogb[l_ac].ogb17 != g_ogb_t.ogb17 THEN
                     IF g_sma.sma115 = 'Y' THEN
                        CALL t650_b_ogg()
                     ELSE
                        CALL t650_b_ogc()
                     END IF
                  END IF
               END IF
            END IF
#   END IF  #FUN-A50054 add         #FUN-A60035 ---MARK
 
        AFTER ROW
            SELECT COUNT(*) INTO g_cnt FROM ogb_file WHERE ogb01=g_oga.oga01
            IF (g_oga.oga08='1' AND g_cnt > g_oaz.oaz691) OR
               (g_oga.oga08 MATCHES '[23]' AND g_cnt > g_oaz.oaz692) THEN
               CALL cl_err('','axm-156',0)
               NEXT FIELD ogb03
            END IF
 
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac      #FUN-D30034 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'a' AND l_ac <= g_ogb.getLength() THEN  #CHI-C30106 add
                 SELECT ima918,ima921 INTO g_ima918,g_ima921 
                   FROM ima_file
                  WHERE ima01 = g_ogb[l_ac].ogb04
                    AND imaacti = "Y"
               
                 IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                   #IF NOT s_lotout_del(g_prog,g_oga.oga01,g_ogb[l_ac].ogb03,0,g_ogb[l_ac].ogb04,'DEL') THEN   #No.FUN-860045  #TQC-B90236
                    IF NOT s_lot_del(g_prog,g_oga.oga01,g_ogb[l_ac].ogb03,0,g_ogb[l_ac].ogb04,'DEL') THEN   #No.FUN-860045  #TQC-B90236
                       CALL cl_err3("del","rvbs_file",g_oga.oga01,g_ogb_t.ogb03,
                                     SQLCA.sqlcode,"","",1)
                    END IF
                 END IF
               END IF   #CHI-C30106 add
               IF p_cmd = 'u' THEN
                  LET g_ogb[l_ac].* = g_ogb_t.*
               ELSE
                  INITIALIZE g_ogb[l_ac].* TO NULL  #FUN-A50054
                  CALL g_ogb.deleteElement(l_ac)   #No.MOD-A80086
                  #FUN-D30034--add--str--
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
                  #FUN-D30034--add--end--
               END IF
               CLOSE t650_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac      #FUN-D30034 Add    
            CLOSE t650_bcl
            COMMIT WORK

       #CHI-C30106---add---S---
        AFTER INPUT
        LET g_cnt = 0
        SELECT COUNT(*) INTO g_cnt FROM ogb_file WHERE ogb01=g_oga.oga01
          FOR l_c=1 TO g_cnt
             SELECT ima918,ima921 INTO g_ima918,g_ima921
               FROM ima_file
              WHERE ima01 = g_ogb[l_c].ogb04
                AND imaacti = "Y"

             IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
             UPDATE rvbs_file SET rvbs021=g_ogb[l_c].ogb04
              WHERE rvbs00=g_prog
                AND rvbs01=g_oga.oga01
                AND rvbs02=g_ogb[l_c].ogb03
             END IF
          END FOR
       #CHI-C30106---add---E---
 
        ON ACTION controls                             #No.FUN-6A0092
           CALL cl_set_head_visible("","AUTO")         #No.FUN-6A0092
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(ogb03) AND l_ac > 1 THEN
                LET g_ogb[l_ac].* = g_ogb[l_ac-1].*
                LET g_ogb[l_ac].ogb03 = NULL
                NEXT FIELD ogb03
            END IF
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(ogb04)
#FUN-AA0059---------mod------------str----------------- 
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form ="q_ima"
#                  LET g_qryparam.default1 = g_ogb[l_ac].ogb04
#                  CALL cl_create_qry() RETURNING g_ogb[l_ac].ogb04
                   CALL q_sel_ima(FALSE, "q_ima","",g_ogb[l_ac].ogb04,"","","","","",'' ) 
                    RETURNING g_ogb[l_ac].ogb04  
#FUN-AA0059---------mod------------end-----------------
                   DISPLAY BY NAME g_ogb[l_ac].ogb04
                   NEXT FIELD ogb04
              WHEN INFIELD(ogb05)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gfe"
                   LET g_qryparam.default1 = g_ogb[l_ac].ogb05
                   CALL cl_create_qry() RETURNING g_ogb[l_ac].ogb05
                   DISPLAY BY NAME g_ogb[l_ac].ogb05
                   NEXT FIELD ogb05
 
              WHEN INFIELD(ogb09)    
                 #FUN-C30300---begin
                 LET g_ima906 = NULL
                 SELECT ima906 INTO g_ima906 FROM ima_file
                  WHERE ima01 = g_ogb[l_ac].ogb04
                 #IF s_industry("icd") AND g_ima906='3' THEN  #TQC-C60028
                 IF s_industry("icd") THEN  #TQC-C60028
                    CALL q_idc(FALSE,TRUE,g_ogb[l_ac].ogb04,'','','')
                    RETURNING g_ogb[l_ac].ogb09,g_ogb[l_ac].ogb091,g_ogb[l_ac].ogb092
                 ELSE
                 #FUN-C30300---end
                    #CALL q_img4(FALSE,TRUE,g_ogb[l_ac].ogb04,g_ogb[l_ac].ogb09,g_ogb[l_ac].ogb091,g_ogb[l_ac].ogb092,'A')  #FUN-AA0062 mark
                    CALL q_img4(FALSE,TRUE,g_ogb[l_ac].ogb04,'','','','A')                                                   #FUN-AA0062 add
                              RETURNING g_ogb[l_ac].ogb09,g_ogb[l_ac].ogb091, 
                                        g_ogb[l_ac].ogb092
                 END IF #FUN-C30300
                  IF INT_FLAG THEN
                      LET INT_FLAG = 0
                  END IF
                  DISPLAY BY NAME g_ogb[l_ac].ogb09
                  DISPLAY BY NAME g_ogb[l_ac].ogb091
                  DISPLAY BY NAME g_ogb[l_ac].ogb092
                  NEXT FIELD ogb09
 
              WHEN INFIELD(ogb41) #專案代號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_pja2"
                 CALL cl_create_qry() RETURNING g_ogb[l_ac].ogb41
                 DISPLAY BY NAME g_ogb[l_ac].ogb41
                 NEXT FIELD ogb41
              WHEN INFIELD(ogb42)  #WBS
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_pjb4"
                 LET g_qryparam.arg1 = g_ogb[l_ac].ogb41
                 CALL cl_create_qry() RETURNING g_ogb[l_ac].ogb42
                 DISPLAY BY NAME g_ogb[l_ac].ogb42
                 NEXT FIELD ogb42
              WHEN INFIELD(ogb43)  #活動
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_pjk3"
                 LET g_qryparam.arg1 = g_ogb[l_ac].ogb42
                 CALL cl_create_qry() RETURNING g_ogb[l_ac].ogb43
                 DISPLAY BY NAME g_ogb[l_ac].ogb43
                 NEXT FIELD ogb43
 
              WHEN INFIELD(ogb091)
                 #FUN-C30300---begin
                 LET g_ima906 = NULL
                 SELECT ima906 INTO g_ima906 FROM ima_file
                  WHERE ima01 = g_ogb[l_ac].ogb04
                 #IF s_industry("icd") AND g_ima906='3' THEN  #TQC-C60028
                 IF s_industry("icd") THEN  #TQC-C60028
                    CALL q_idc(FALSE,TRUE,g_ogb[l_ac].ogb04,g_ogb[l_ac].ogb09,'','')
                    RETURNING g_ogb[l_ac].ogb09,g_ogb[l_ac].ogb091,g_ogb[l_ac].ogb092
                 ELSE
                 #FUN-C30300---end
                   #CALL q_img4(FALSE,TRUE,g_ogb[l_ac].ogb04,g_ogb[l_ac].ogb09,g_ogb[l_ac].ogb091,g_ogb[l_ac].ogb092,'A')  #FUN-AA0062 mark
                   CALL q_img4(FALSE,TRUE,g_ogb[l_ac].ogb04,g_ogb[l_ac].ogb09,'','','A')                                   #FUN-AA0062 add
                            RETURNING g_ogb[l_ac].ogb09,g_ogb[l_ac].ogb091,
                                      g_ogb[l_ac].ogb092
                 END IF  #FUN-C30300
                   IF INT_FLAG THEN
                       LET INT_FLAG = 0
                   END IF
                   DISPLAY BY NAME g_ogb[l_ac].ogb09
                   DISPLAY BY NAME g_ogb[l_ac].ogb091
                   DISPLAY BY NAME g_ogb[l_ac].ogb092
                   NEXT FIELD ogb091
              WHEN INFIELD(ogb092)
                 #FUN-C30300---begin
                 LET g_ima906 = NULL
                 SELECT ima906 INTO g_ima906 FROM ima_file
                  WHERE ima01 = g_ogb[l_ac].ogb04
                 #IF s_industry("icd") AND g_ima906='3' THEN  #TQC-C60028
                 IF s_industry("icd") THEN  #TQC-C60028
                    CALL q_idc(FALSE,TRUE,g_ogb[l_ac].ogb04,g_ogb[l_ac].ogb09,g_ogb[l_ac].ogb091,'')
                    RETURNING g_ogb[l_ac].ogb09,g_ogb[l_ac].ogb091,g_ogb[l_ac].ogb092
                 ELSE
                 #FUN-C30300---end
                   #CALL q_img4(FALSE,TRUE,g_ogb[l_ac].ogb04,g_ogb[l_ac].ogb09,g_ogb[l_ac].ogb091,g_ogb[l_ac].ogb092,'A') #FUN-AA0062 mark
                   CALL q_img4(FALSE,TRUE,g_ogb[l_ac].ogb04,g_ogb[l_ac].ogb09,g_ogb[l_ac].ogb091,'','A')                  #FUN-AA0062 add
                            RETURNING g_ogb[l_ac].ogb09,g_ogb[l_ac].ogb091,
                                      g_ogb[l_ac].ogb092
                 END IF  #FUN-C30300
                   IF INT_FLAG THEN
                       LET INT_FLAG = 0
                   END IF
                   DISPLAY BY NAME g_ogb[l_ac].ogb09
                   DISPLAY BY NAME g_ogb[l_ac].ogb091
                   DISPLAY BY NAME g_ogb[l_ac].ogb092
                   NEXT FIELD ogb091
 
              WHEN INFIELD(ogb1001)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azf01a"  #No.FUN-930104
                 LET g_qryparam.arg1 ="1"         #No.FUN-930104
                 CALL cl_create_qry() RETURNING g_ogb[l_ac].ogb1001
                 DISPLAY BY NAME g_ogb[l_ac].ogb1001
                 NEXT FIELD ogb1001
 
              WHEN INFIELD(ogb908)
                 CALL q_coc2(FALSE,FALSE,g_ogb[l_ac].ogb908,'',g_oga.oga02,'0',
                             '',g_ogb[l_ac].ogb04)
                 RETURNING g_ogb[l_ac].ogb908,l_coc04
                 NEXT FIELD ogb908
 
              WHEN INFIELD(ogb910) #單位
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gfe"
                  LET g_qryparam.default1 = g_ogb[l_ac].ogb910
                  CALL cl_create_qry() RETURNING g_ogb[l_ac].ogb910
                  DISPLAY BY NAME g_ogb[l_ac].ogb910
                  NEXT FIELD ogb910
              WHEN INFIELD(ogb913) #單位
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gfe"
                  LET g_qryparam.default1 = g_ogb[l_ac].ogb913
                  CALL cl_create_qry() RETURNING g_ogb[l_ac].ogb913
                  DISPLAY BY NAME g_ogb[l_ac].ogb913
                  NEXT FIELD ogb913
              WHEN INFIELD(ogb916) #單位
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gfe"
                  LET g_qryparam.default1 = g_ogb[l_ac].ogb916
                  CALL cl_create_qry() RETURNING g_ogb[l_ac].ogb916
                  DISPLAY BY NAME g_ogb[l_ac].ogb916
                  NEXT FIELD ogb916
              WHEN INFIELD(ogb930)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gem4"
                 CALL cl_create_qry() RETURNING g_ogb[l_ac].ogb930
                 DISPLAY BY NAME g_ogb[l_ac].ogb930
                 NEXT FIELD ogb930
              #FUN-C30289---begin
              WHEN INFIELD(ogbiicd07)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "i"
                 LET g_qryparam.form ="q_icd3"
                 CALL cl_create_qry() RETURNING g_ogb[l_ac].ogbiicd07
                 DISPLAY BY NAME g_ogb[l_ac].ogbiicd07
                 NEXT FIELD ogbiicd07                 
              #FUN-C30289---end  
           END CASE
 
        ON ACTION qry_product_inventory
           LET g_msg='axmq450 ',g_ogb[l_ac].ogb04
           CALL cl_cmdrun_wait(g_msg)  #FUN-660216 add
 
        ON ACTION modi_lot
           SELECT ima918,ima921 INTO g_ima918,g_ima921 
             FROM ima_file
            WHERE ima01 = g_ogb[l_ac].ogb04
              AND imaacti = "Y"
           
           #MOD-CA0220 -- add start --
           SELECT img09 INTO g_img09 FROM img_file
            WHERE img01=g_ogb[l_ac].ogb04
              AND img02=g_ogb[l_ac].ogb09
              AND img03=g_ogb[l_ac].ogb091
              AND img04=g_ogb[l_ac].ogb092
           LET b_ogb.ogb05_fac = 1
           CALL s_umfchk(g_ogb[l_ac].ogb04,g_ogb[l_ac].ogb05,g_img09)
                RETURNING g_cnt,b_ogb.ogb05_fac
           IF g_cnt=1 THEN LET b_ogb.ogb05_fac = 1 END IF
           #MOD-CA0220 -- add end --

           IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
              IF g_ogb[l_ac].ogb17 = 'N' THEN    #MOD-A20117
                 CALL t650_b_move_back()
                 CALL t650_b_else()
                 #CHI-9A0022 --Begin
                 IF cl_null(g_ogb[l_ac].ogb41) THEN
                    LET l_bno = ''
                 ELSE
                    LET l_bno = g_ogb[l_ac].ogb41
                 END IF
                 #CHI-9A0022 --End
                #CALL s_lotout(g_prog,g_oga.oga01,g_ogb[l_ac].ogb03,0,        #TQC-B90236 mark
                 CALL s_mod_lot(g_prog,g_oga.oga01,g_ogb[l_ac].ogb03,0,        #TQC-B90236 add
                               g_ogb[l_ac].ogb04,g_ogb[l_ac].ogb09,
                               g_ogb[l_ac].ogb091,g_ogb[l_ac].ogb092,
                               g_ogb[l_ac].ogb05,g_img09,b_ogb.ogb05_fac,
                               g_ogb[l_ac].ogb12,l_bno,'MOD',-1)#CHI-9A0022 add l_bno  #TQC-B90236 add '-1'
                     RETURNING l_r,g_qty
                 IF l_r = "Y" THEN
                    LET g_ogb[l_ac].ogb12 = g_qty
                 END IF
              END IF   #MOD-A20117
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
 
        ON ACTION mntn_other_data CALL t650_b_more()
 
        ON ACTION mntn_inv_detail
           IF g_sma.sma115 = 'Y' THEN
              CALL t650_b_ogg()
           ELSE
              CALL t650_b_ogc()
           END IF
 
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
    UPDATE oga_file SET ogamodu = g_user,ogadate = g_today
     WHERE oga01 = g_oga.oga01
 
    LET g_oga.oga50 = NULL
    SELECT SUM(ogb14) INTO g_oga.oga50 FROM ogb_file WHERE ogb01 = g_oga.oga01
    IF cl_null(g_oga.oga50) THEN LET g_oga.oga50 = 0 END IF
    DISPLAY BY NAME g_oga.oga50
 
    CLOSE t650_bcl
    COMMIT WORK
    CALL t650_delHeader()     #CHI-C30002 add
 
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t650_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_oga.oga01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM oga_file ",
                  "  WHERE oga01 LIKE '",l_slip,"%' ",
                  "    AND oga01 > '",g_oga.oga01,"'"
      PREPARE t650_pb1 FROM l_sql 
      EXECUTE t650_pb1 INTO l_cnt
      
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
         IF cl_chk_act_auth() THEN
           #CALL t650_x()   #FUN-D20025
            CALL t650_x(1)  #FUN-D20025
         END IF
      END IF 
      
      IF l_cho = 3 THEN 
         DELETE FROM rvbs_file WHERE rvbs01=g_oga.oga01   
         DELETE FROM oao_file WHERE oao01 = g_oga.oga01
         DELETE FROM oap_file WHERE oap01 = g_oga.oga01
         DELETE FROM ogd_file WHERE ogd01 = g_oga.oga01 
         DELETE FROM npp_file
          WHERE nppsys = 'AR' AND npp00=1 AND npp01 = g_oga.oga01 AND npp011=1
         DELETE FROM npq_file
          WHERE npqsys = 'AR' AND npq00=1 AND npq01 = g_oga.oga01 AND npq011=1
        DELETE FROM tic_file WHERE tic04 = g_oga.oga01 
      #CHI-C80041---end 
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM  oga_file WHERE oga01 = g_oga.oga01
         INITIALIZE g_oga.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

FUNCTION t650_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
 
    IF p_cmd = 's' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("ogb092,ogb09,ogb091,ogb908",TRUE)       #CHI-6B0027 mod
    END IF
 
    IF cl_null(p_cmd) OR p_cmd != 's' THEN
       IF INFIELD(ogb04) OR (NOT g_before_input_done) THEN
          CALL cl_set_comp_entry("ogb06",TRUE)
       END IF
    END IF
    CALL cl_set_comp_entry("ogb913,ogb915,ogb916,ogb917",TRUE)
 
END FUNCTION
 
FUNCTION t650_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
 
    IF p_cmd = 's' AND ( NOT g_before_input_done ) THEN
       IF g_oaz.oaz104='N' THEN
          CALL cl_set_comp_entry("ogb092",FALSE)
       END IF
 
       IF g_oaz.oaz102='N' THEN
          CALL cl_set_comp_entry("ogb09",FALSE)
       END IF
       IF g_oaz.oaz103='N' THEN
          CALL cl_set_comp_entry("ogb091",FALSE)
       END IF
       IF g_aza.aza27 != 'Y' THEN
          CALL cl_set_comp_entry("ogb908",FALSE)
       END IF
 
    END IF
 
    IF cl_null(p_cmd) OR p_cmd != 's' THEN
       IF INFIELD(ogb04) OR ( NOT g_before_input_done ) THEN
          IF g_ogb[l_ac].ogb04[1,4] !='MISC' THEN
             CALL cl_set_comp_entry("ogb06",FALSE)
          END IF
       END IF
    END IF
 
   IF g_ima906 = '1' THEN
      CALL cl_set_comp_entry("ogb913,ogb914,ogb915",FALSE)
   END IF
   IF g_ima906 = '2' THEN
      CALL cl_set_comp_entry("ogb911,ogb914",FALSE)
   END IF
   #參考單位，每個料件只有一個，所以不開放讓用戶輸入
   IF g_ima906 = '3' THEN
      CALL cl_set_comp_entry("ogb913",FALSE)
   END IF
   IF g_sma.sma116 MATCHES '[01]' THEN    #No.FUN-610076
      CALL cl_set_comp_entry("ogb916,ogb917",FALSE)
   END IF
   CALL cl_set_comp_entry("ogb50,ogb51",FALSE) #FUN-C50097  
END FUNCTION
 
FUNCTION t650_set_required(p_cmd)
DEFINE p_cmd LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
 #兩組雙單位資料不是一定要全部輸入,但是參考單位的時候要全輸入
 IF g_ima906 = '3' THEN
    CALL cl_set_comp_required("ogb913,ogb915,ogb910,ogb912",TRUE)
 END IF
 #單位不同,轉換率,數量必KEY
 IF NOT cl_null(g_ogb[l_ac].ogb910) THEN
    CALL cl_set_comp_required("ogb912",TRUE)
 END IF
 IF NOT cl_null(g_ogb[l_ac].ogb913) THEN
    CALL cl_set_comp_required("ogb915",TRUE)
 END IF
 IF g_sma.sma116 MATCHES '[23]' THEN   #MOD-A40121
    IF NOT cl_null(g_ogb[l_ac].ogb916) THEN
       CALL cl_set_comp_required("ogb917",TRUE)
    END IF
 END IF   #MOD-A40121
 
END FUNCTION
 
FUNCTION t650_set_no_required(p_cmd)
DEFINE p_cmd LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
 
 CALL cl_set_comp_required("ogb913,ogb914,ogb915,ogb910,ogb911,ogb912,ogb916,ogb917",FALSE)
 
END FUNCTION
 
FUNCTION t650_b_move_to()
   LET g_ogb[l_ac].ogb03 = b_ogb.ogb03  LET g_ogb[l_ac].ogb04 = b_ogb.ogb04
   LET g_ogb[l_ac].ogb06 = b_ogb.ogb06  LET g_ogb[l_ac].ogb05 = b_ogb.ogb05
   LET g_ogb[l_ac].ogb12 = b_ogb.ogb12  LET g_ogb[l_ac].ogb13 = b_ogb.ogb13
   LET g_ogb[l_ac].ogb37 = b_ogb.ogb37 #FUN-AB0061
   LET g_ogb[l_ac].ogb14 = b_ogb.ogb14  LET g_ogb[l_ac].ogb14t = b_ogb.ogb14t
   LET g_ogb[l_ac].ogb09 = b_ogb.ogb09                                       #CHI-6B0027 mod   
   LET g_ogb[l_ac].ogb091= b_ogb.ogb091 LET g_ogb[l_ac].ogb092= b_ogb.ogb092
   LET g_ogb[l_ac].ogb17 = b_ogb.ogb17
   LET g_ogb[l_ac].ogb908 = b_ogb.ogb908 #no.A050
   LET g_ogb[l_ac].ogb913 = b_ogb.ogb913
   LET g_ogb[l_ac].ogb914 = b_ogb.ogb914
   LET g_ogb[l_ac].ogb915 = b_ogb.ogb915
   LET g_ogb[l_ac].ogb910 = b_ogb.ogb910
   LET g_ogb[l_ac].ogb911 = b_ogb.ogb911
   LET g_ogb[l_ac].ogb912 = b_ogb.ogb912
   LET g_ogb[l_ac].ogb916 = b_ogb.ogb916
   LET g_ogb[l_ac].ogb917 = b_ogb.ogb917
   LET g_ogb[l_ac].ogb50 = b_ogb.ogb50  #FUN-C50097
   LET g_ogb[l_ac].ogb51 = b_ogb.ogb51  #FUN-C50097
   LET g_ogb[l_ac].ogb41 = b_ogb.ogb41
   LET g_ogb[l_ac].ogb42 = b_ogb.ogb42
   LET g_ogb[l_ac].ogb43 = b_ogb.ogb43
   LET g_ogb[l_ac].ogb930 = b_ogb.ogb930 #FUN-670063
   LET g_ogb[l_ac].ogb1001 = b_ogb.ogb1001 #CHI-7B0023
   LET g_ogb[l_ac].ogbud01 = b_ogb.ogbud01
   LET g_ogb[l_ac].ogbud02 = b_ogb.ogbud02
   LET g_ogb[l_ac].ogbud03 = b_ogb.ogbud03
   LET g_ogb[l_ac].ogbud04 = b_ogb.ogbud04
   LET g_ogb[l_ac].ogbud05 = b_ogb.ogbud05
   LET g_ogb[l_ac].ogbud06 = b_ogb.ogbud06
   LET g_ogb[l_ac].ogbud07 = b_ogb.ogbud07
   LET g_ogb[l_ac].ogbud08 = b_ogb.ogbud08
   LET g_ogb[l_ac].ogbud09 = b_ogb.ogbud09
   LET g_ogb[l_ac].ogbud10 = b_ogb.ogbud10
   LET g_ogb[l_ac].ogbud11 = b_ogb.ogbud11
   LET g_ogb[l_ac].ogbud12 = b_ogb.ogbud12
   LET g_ogb[l_ac].ogbud13 = b_ogb.ogbud13
   LET g_ogb[l_ac].ogbud14 = b_ogb.ogbud14
   LET g_ogb[l_ac].ogbud15 = b_ogb.ogbud15
END FUNCTION
 
FUNCTION t650_b_move_back()
   LET b_ogb.ogb03 = g_ogb[l_ac].ogb03  LET b_ogb.ogb04 = g_ogb[l_ac].ogb04
   LET b_ogb.ogb06 = g_ogb[l_ac].ogb06  LET b_ogb.ogb05 = g_ogb[l_ac].ogb05
   LET b_ogb.ogb12 = g_ogb[l_ac].ogb12  LET b_ogb.ogb13 = g_ogb[l_ac].ogb13
   LET b_ogb.ogb37 = g_ogb[l_ac].ogb37   #FUN-AB0061
   LET b_ogb.ogb14 = g_ogb[l_ac].ogb14  LET b_ogb.ogb14t = g_ogb[l_ac].ogb14t
   LET b_ogb.ogb08 =  g_plant            LET b_ogb.ogb09 = g_ogb[l_ac].ogb09  #CHI-6B0027 mod   #MOD-930314
   LET b_ogb.ogb091= g_ogb[l_ac].ogb091 LET b_ogb.ogb092= g_ogb[l_ac].ogb092
   LET b_ogb.ogb17 = g_ogb[l_ac].ogb17
   LET b_ogb.ogb908 = g_ogb[l_ac].ogb908 #no.A050
   LET b_ogb.ogb913 = g_ogb[l_ac].ogb913
   LET b_ogb.ogb914 = g_ogb[l_ac].ogb914
   LET b_ogb.ogb915 = g_ogb[l_ac].ogb915
   LET b_ogb.ogb910 = g_ogb[l_ac].ogb910
   LET b_ogb.ogb911 = g_ogb[l_ac].ogb911
   LET b_ogb.ogb912 = g_ogb[l_ac].ogb912
   LET b_ogb.ogb916 = g_ogb[l_ac].ogb916
   LET b_ogb.ogb917 = g_ogb[l_ac].ogb917
   LET b_ogb.ogb51  = g_ogb[l_ac].ogb51   #FUN-C50097
   LET b_ogb.ogb50  = g_ogb[l_ac].ogb50   #FUN-C50097
   LET b_ogb.ogb41  = g_ogb[l_ac].ogb41 
   LET b_ogb.ogb42  = g_ogb[l_ac].ogb42 
   LET b_ogb.ogb43  = g_ogb[l_ac].ogb43 
   LET b_ogb.ogb930 = g_ogb[l_ac].ogb930  #FUN-670063
   LET b_ogb.ogb1001 = g_ogb[l_ac].ogb1001     #No.FUN-660073
   LET b_ogb.ogbud01 = g_ogb[l_ac].ogbud01
   LET b_ogb.ogbud02 = g_ogb[l_ac].ogbud02
   LET b_ogb.ogbud03 = g_ogb[l_ac].ogbud03
   LET b_ogb.ogbud04 = g_ogb[l_ac].ogbud04
   LET b_ogb.ogbud05 = g_ogb[l_ac].ogbud05
   LET b_ogb.ogbud06 = g_ogb[l_ac].ogbud06
   LET b_ogb.ogbud07 = g_ogb[l_ac].ogbud07
   LET b_ogb.ogbud08 = g_ogb[l_ac].ogbud08
   LET b_ogb.ogbud09 = g_ogb[l_ac].ogbud09
   LET b_ogb.ogbud10 = g_ogb[l_ac].ogbud10
   LET b_ogb.ogbud11 = g_ogb[l_ac].ogbud11
   LET b_ogb.ogbud12 = g_ogb[l_ac].ogbud12
   LET b_ogb.ogbud13 = g_ogb[l_ac].ogbud13
   LET b_ogb.ogbud14 = g_ogb[l_ac].ogbud14
   LET b_ogb.ogbud15 = g_ogb[l_ac].ogbud15
END FUNCTION
 
FUNCTION t650_b_else()
   DEFINE l_img21   LIKE img_file.img21,  #FUN-4C0006
          l_ogb15   LIKE ogb_file.ogb15
   DEFINE l_msg     STRING                #TQC-C50131 -- add
   IF cl_null(b_ogb.ogb916) OR cl_null(b_ogb.ogb917) THEN
      LET b_ogb.ogb916=b_ogb.ogb05
      LET b_ogb.ogb917=b_ogb.ogb12
   END IF
 
   IF g_oga.oga213 = 'N' THEN
      LET b_ogb.ogb14 =b_ogb.ogb917*b_ogb.ogb13
      LET b_ogb.ogb14t=b_ogb.ogb14*(1+g_oga.oga211/100)
   ELSE
      LET b_ogb.ogb14t=b_ogb.ogb917*b_ogb.ogb13
      LET b_ogb.ogb14 =b_ogb.ogb14t/(1+g_oga.oga211/100)
   END IF
 
   CALL cl_digcut(b_ogb.ogb14,t_azi04) RETURNING b_ogb.ogb14  #No.CHI-6A0004 
   CALL cl_digcut(b_ogb.ogb14t,t_azi04)RETURNING b_ogb.ogb14t  #No.CHI-6A0004 
   IF b_ogb.ogb09  IS NULL THEN LET b_ogb.ogb09  = ' ' END IF
   IF b_ogb.ogb091 IS NULL THEN LET b_ogb.ogb091 = ' ' END IF
   IF b_ogb.ogb092 IS NULL THEN LET b_ogb.ogb092 = ' ' END IF
   SELECT img09,img21 INTO l_ogb15,l_img21 FROM img_file
    WHERE img01 = b_ogb.ogb04 AND img02 = b_ogb.ogb09
      AND img03 = b_ogb.ogb091 AND img04 = b_ogb.ogb092
 
   IF b_ogb.ogb15!=l_ogb15 OR b_ogb.ogb15_fac=1 THEN
      LET b_ogb.ogb15 = l_ogb15
   END IF
 
   IF STATUS=0 THEN
      IF b_ogb.ogb05 = b_ogb.ogb15 THEN
          LET b_ogb.ogb15_fac =1
      ELSE
          #檢查該發料單位與主檔之單位是否可以轉換
          CALL s_umfchk(b_ogb.ogb04,b_ogb.ogb05,b_ogb.ogb15)
                    RETURNING g_cnt,b_ogb.ogb15_fac
          IF g_cnt = 1 THEN
             CALL cl_err('','mfg3075',1)
            #TQC-C50131 -- add -- begin
             CALL cl_getmsg('asf-176',g_lang) RETURNING l_msg
             LET l_msg = l_msg CLIPPED,"(",b_ogb.ogb04,")"
             CALL cl_msgany(10,20,l_msg)
            #TQC-C50131 -- add -- end
          END IF
      END IF
   END IF
   IF cl_null(b_ogb.ogb15) THEN LET b_ogb.ogb15  = b_ogb.ogb05 END IF
   IF cl_null(b_ogb.ogb15_fac) THEN LET b_ogb.ogb15_fac = 1 END IF
   LET b_ogb.ogb16 = b_ogb.ogb12 * b_ogb.ogb15_fac
   IF cl_null(b_ogb.ogb60) THEN LET b_ogb.ogb60 = 0 END IF
   IF cl_null(b_ogb.ogb63) THEN LET b_ogb.ogb63 = 0 END IF
   IF cl_null(b_ogb.ogb64) THEN LET b_ogb.ogb64 = 0 END IF
   LET b_ogb.ogb1014='N' #保稅放行否 #FUN-6B0044
   LET b_ogb.ogbplant = g_plant #FUN-980010 add
   LET b_ogb.ogblegal = g_legal #FUN-980010 add
END FUNCTION
 
FUNCTION t650_b_ogc_1()			# 庫存異動明細(ogc_file)輸入
  DEFINE r_ogc      RECORD LIKE ogc_file.*
  DEFINE l_ogc	    DYNAMIC ARRAY OF RECORD
                        #ogc12     LIKE ogc_file.ogc12,   #CHI-9C0024
                        ogc09     LIKE ogc_file.ogc09,
                        ogc091    LIKE ogc_file.ogc091,
                        ogc092    LIKE ogc_file.ogc092,
                        ogc12     LIKE ogc_file.ogc12,   #CHI-9C0024
                        ogc13     LIKE ogc_file.ogc13,   #FUN-C50097                        
                        img10     LIKE img_file.img10, #MOD-530713
                        ogc15     LIKE ogc_file.ogc15,
                        ogc15_fac LIKE ogc_file.ogc15_fac,
                        ogc16     LIKE ogc_file.ogc16,
                        ogc18     LIKE ogc_file.ogc18   #MOD-910173
                      END RECORD
  DEFINE l_n          LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE l_ogc12_t    LIKE ogc_file.ogc12
  DEFINE l_ogc16_t    LIKE ogc_file.ogc16
  DEFINE l_img21      LIKE img_file.img21
  DEFINE i,k,s,l_i    LIKE type_file.num5,    #No.FUN-680137 SMALLINT
         l_allow_insert   LIKE type_file.num5,                #可新增否  #No.FUN-680137 SMALLINT
         l_allow_delete   LIKE type_file.num5                 #可刪除否  #No.FUN-680137 SMALLINT
 
   OPEN WINDOW t6006_w WITH FORM "axm/42f/axmt6006"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("axmt6006")
   CALL cl_set_comp_visible("ogc13",FALSE) #FUN-C50097
   DECLARE t6006_c_1 CURSOR FOR
           #SELECT ogc12,ogc09,ogc091,ogc092,img10,ogc15,ogc15_fac,ogc16,ogc18   #MOD-910173加上ogc18   #CHI-9C0024 move ogc12
           SELECT ogc09,ogc091,ogc092,ogc12,ogc13,img10,ogc15,ogc15_fac,ogc16,ogc18   #MOD-910173加上ogc18   #CHI-9C0024 move ogc12
             FROM ogc_file LEFT OUTER JOIN img_file ON ogc09 = img02 AND ogc091 = img03 AND ogc092 = img04   #No.TQC-9A0132 mod
            WHERE ogc01 = g_oga.oga01 AND ogc03 = g_ogb[l_ac].ogb03
              AND img_file.img01=g_ogb[l_ac].ogb04 #FUN-C50097 ADD OGC13 
 
   CALL l_ogc.clear()
   LET i = 1
   LET l_i = 1
   FOREACH t6006_c_1 INTO l_ogc[i].*
      IF STATUS THEN CALL cl_err('foreach ogc',STATUS,0) EXIT FOREACH END IF
      LET i = i + 1
   END FOREACH
   CALL l_ogc.deleteElement(i)
   LET l_i=(i-1)
 
   SELECT SUM(ogc12),SUM(ogc16) INTO l_ogc12_t,l_ogc16_t FROM ogc_file
    WHERE ogc01 = g_oga.oga01 AND ogc03 = g_ogb[l_ac].ogb03
 
   DISPLAY l_i TO cn2
   DISPLAY l_ogc12_t TO ogc12t
   DISPLAY l_ogc16_t TO ogc16t
   DISPLAY g_ogb[l_ac].ogb12 TO ogb12t   #No.MOD-590206
   CALL cl_set_act_visible("cancel", FALSE)
 
   IF g_action_choice="qry_mntn_inv_detail" THEN
      DISPLAY ARRAY l_ogc TO s_ogc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)    #No.TQC-640123
      #-----MOD-A20117---------
      BEFORE ROW
        LET i=ARR_CURR()
        CALL cl_show_fld_cont()

      ON ACTION qry_lot
         LET g_ima918 = ''   
         LET g_ima921 = ''   
         SELECT ima918,ima921 INTO g_ima918,g_ima921
           FROM ima_file
          WHERE ima01 = g_ogb[l_ac].ogb04
            AND imaacti = "Y"
      
         IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
           #CALL s_lotout(g_prog,g_oga.oga01,g_ogb[l_ac].ogb03,l_ogc[i].ogc18,     #TQC-B90236 mark
            CALL s_mod_lot(g_prog,g_oga.oga01,g_ogb[l_ac].ogb03,l_ogc[i].ogc18,     #TQC-B90236 add
                          g_ogb[l_ac].ogb04,l_ogc[i].ogc09,
                          l_ogc[i].ogc091,l_ogc[i].ogc092,
                          g_ogb[l_ac].ogb05,l_ogc[i].ogc15,l_ogc[i].ogc15_fac,
                          l_ogc[i].ogc12,'','QRY',-1)#CHI-9A0022 add ''     #TQC-B90236 add '-1'
                RETURNING l_r,g_qty
            IF l_r = "Y" THEN
               LET l_ogc[i].ogc12 = g_qty
               LET l_ogc[i].ogc12 = s_digqty(l_ogc[i].ogc12,g_ogb[l_ac].ogb05)   #FUN-910088--add--
            END IF
         END IF
      #-----END MOD-A20117-----
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE DISPLAY
 
        ON ACTION about         
           CALL cl_about()      
 
        ON ACTION help          
           CALL cl_show_help()  
 
        ON ACTION controlg      
           CALL cl_cmdask()     
      END DISPLAY 
   END IF
   CLOSE WINDOW t6006_w
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
 
END FUNCTION
 
FUNCTION t600_mlog(p_cmd)	# Transaction Modify Log (存入 oem_file)
   DEFINE p_cmd		LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
   DEFINE l_oem05       LIKE type_file.chr8    #No.FUN-680137 VARCHAR(8)
   DEFINE l_oem		RECORD LIKE oem_file.*
   IF g_oga.oga06 IS NULL THEN RETURN END IF
   INITIALIZE l_oem.* TO NULL
   LET l_oem.oem01=g_oga.oga01
   LET l_oem.oem03=b_ogb.ogb03
   LET l_oem.oem04=g_today
   LET l_oem05 = TIME
   LET l_oem.oem05=l_oem05
   LET l_oem.oem06=g_user
   LET l_oem.oem07=p_cmd
   LET l_oem.oem08=g_oga.oga06
   LET l_oem.oemplant = g_plant #FUN-980010 add
   LET l_oem.oemlegal = g_legal #FUN-980010 add
   IF p_cmd='A' THEN
      LET l_oem.oem10o=NULL LET l_oem.oem11o=NULL
      LET l_oem.oem12o=NULL LET l_oem.oem13o=NULL LET l_oem.oem15o=NULL
      LET l_oem.oem12n=b_ogb.ogb12
   END IF
   IF p_cmd='R' THEN
      LET l_oem.oem10o=g_ogb_t.ogb04
      LET l_oem.oem11o=g_ogb_t.ogb092
      LET l_oem.oem12o=g_ogb_t.ogb12
      LET l_oem.oem10n=NULL LET l_oem.oem11n=NULL
      LET l_oem.oem12n=NULL LET l_oem.oem13n=NULL LET l_oem.oem15n=NULL
   END IF
   IF p_cmd='U' THEN
      IF g_ogb_t.ogb04 != b_ogb.ogb04 THEN
         LET l_oem.oem10o=g_ogb_t.ogb04 LET l_oem.oem10n=b_ogb.ogb04
      END IF
      IF g_ogb_t.ogb092 != b_ogb.ogb092 THEN
         LET l_oem.oem11o=g_ogb_t.ogb092 LET l_oem.oem11n=b_ogb.ogb092
      END IF
      IF g_ogb_t.ogb12 != b_ogb.ogb12 THEN
         LET l_oem.oem12o=g_ogb_t.ogb12 LET l_oem.oem12n=b_ogb.ogb12
      END IF
      IF cl_null(l_oem.oem10n) AND cl_null(l_oem.oem11n) AND
         cl_null(l_oem.oem12n) AND cl_null(l_oem.oem13n) AND
         cl_null(l_oem.oem15n) THEN RETURN
      END IF
      IF l_oem.oem12n=0 THEN LET l_oem.oem12n=NULL END IF
      IF l_oem.oem13n=0 THEN LET l_oem.oem13n=NULL END IF
   END IF
   INSERT INTO oem_file VALUES (l_oem.*)
END FUNCTION
 
FUNCTION t650_b_ogc()			# 庫存異動明細(ogc_file)輸入
  DEFINE r_ogc            RECORD LIKE ogc_file.*
  DEFINE l_ogc            DYNAMIC ARRAY OF RECORD
         #ogc12            LIKE ogc_file.ogc12,   #CHI-9C0024
         ogc09            LIKE ogc_file.ogc09,
         ogc091           LIKE ogc_file.ogc091,
         ogc092           LIKE ogc_file.ogc092,
         ogc12            LIKE ogc_file.ogc12,   #CHI-9C0024
         ogc13            LIKE ogc_file.ogc13,   #FUN-C50097
         img10            LIKE img_file.img10,   #No.FUN-680137 INTEGER   #MOD-8A0145
         ogc15            LIKE ogc_file.ogc15,
         ogc15_fac        LIKE ogc_file.ogc15_fac,
         ogc16            LIKE ogc_file.ogc16,
         ogc18            LIKE ogc_file.ogc18   #MOD-8B0161
                          END RECORD
  DEFINE l_ogc12_t        LIKE ogc_file.ogc12
  DEFINE l_ogc16_t        LIKE ogc_file.ogc16
  DEFINE l_img21          LIKE img_file.img21
  DEFINE i,j,s,l_i,k      LIKE type_file.num5,    #No.FUN-680137 SMALLINT
         l_allow_insert   LIKE type_file.num5,                #可新增否  #No.FUN-680137 SMALLINT
         l_allow_delete   LIKE type_file.num5                 #可刪除否  #No.FUN-680137 SMALLINT
  DEFINE l_ogc18          LIKE ogc_file.ogc18   #MOD-8B0161
  DEFINE l_bno            LIKE rvbs_file.rvbs08 #CHI-9A0022 
  DEFINE l_msg            STRING                #TQC-C50131 -- add
  DEFINE l_flag           LIKE type_file.chr1   #FUN-C80107 add 121024
   IF g_ogb[l_ac].ogb17 IS NULL THEN RETURN END IF
   IF g_ogb[l_ac].ogb17 = 'N' THEN RETURN END IF
 
   SELECT COUNT(*) INTO i FROM ogc_file
    WHERE ogc01 = g_oga.oga01 AND ogc03 = g_ogb[l_ac].ogb03
 
   IF i = 0 AND g_oaz.oaz71='1' THEN
      LET r_ogc.ogc01 = g_oga.oga01
      LET r_ogc.ogc03 = g_ogb[l_ac].ogb03
      LET r_ogc.ogc12 = b_ogb.ogb12
      LET r_ogc.ogc09 = g_ogb[l_ac].ogb09
      LET r_ogc.ogc091 = g_ogb[l_ac].ogb091
      LET r_ogc.ogc092 = g_ogb[l_ac].ogb092
      LET r_ogc.ogc15 = b_ogb.ogb15
      LET r_ogc.ogc15_fac = b_ogb.ogb15_fac
      LET r_ogc.ogc16 = b_ogb.ogb16
      LET r_ogc.ogc17 = g_ogb[l_ac].ogb04   #MOD-8B0161
      LET r_ogc.ogc18 = 1   #MOD-8B0161
      LET r_ogc.ogcplant = g_plant #FUN-980010 add
      LET r_ogc.ogclegal = g_legal #FUN-980010 add
      LET r_ogc.ogc13 = 0 #FUN-C50097
           IF cl_null(r_ogc.ogc01) THEN LET r_ogc.ogc01=' ' END IF
           IF cl_null(r_ogc.ogc03) THEN LET r_ogc.ogc03=0 END IF
           IF cl_null(r_ogc.ogc09) THEN LET r_ogc.ogc09=' ' END IF
           IF cl_null(r_ogc.ogc091) THEN LET r_ogc.ogc091=' ' END IF
           IF cl_null(r_ogc.ogc092) THEN LET r_ogc.ogc092=' ' END IF
           IF cl_null(r_ogc.ogc17) THEN LET r_ogc.ogc17=' ' END IF
      INSERT INTO ogc_file VALUES (r_ogc.*)
   END IF
 
   IF i = 0 AND g_oaz.oaz71='2' THEN
      DECLARE t6506_c2 CURSOR FOR
         SELECT '','',img02,img03,img04,0,img09,0,0,'','' FROM img_file   #MOD-A20117 add '',''
          WHERE img01 = g_ogb[l_ac].ogb04    #CHI-840009 mark AND img04 = g_ogb[l_ac].ogb092
            AND img10 > 0 AND (img18 > g_oga.oga02 OR img18 IS NULL)
 
      LET l_ogc18 = 0    #MOD-8B0161
      FOREACH t6506_c2 INTO r_ogc.*
         IF STATUS THEN EXIT FOREACH END IF
         LET r_ogc.ogc01 = g_oga.oga01
         LET r_ogc.ogc03 = g_ogb[l_ac].ogb03
         LET r_ogc.ogc17 = g_ogb[l_ac].ogb04   #MOD-8B0161
         LET l_ogc18 = l_ogc18 + 1   #MOD-8B0161
         LET r_ogc.ogc18 = l_ogc18    #MOD-8B0161
         LET r_ogc.ogcplant = g_plant #FUN-980010 add
         LET r_ogc.ogclegal = g_legal #FUN-980010 add
         LET r_ogc.ogc13 = 0 #FUN-C50097
           IF cl_null(r_ogc.ogc01) THEN LET r_ogc.ogc01=' ' END IF
           IF cl_null(r_ogc.ogc03) THEN LET r_ogc.ogc03=0 END IF
           IF cl_null(r_ogc.ogc09) THEN LET r_ogc.ogc09=' ' END IF
           IF cl_null(r_ogc.ogc091) THEN LET r_ogc.ogc091=' ' END IF
           IF cl_null(r_ogc.ogc092) THEN LET r_ogc.ogc092=' ' END IF
           IF cl_null(r_ogc.ogc17) THEN LET r_ogc.ogc17=' ' END IF
         INSERT INTO ogc_file VALUES (r_ogc.*)
      END FOREACH
   END IF
 
 
   OPEN WINDOW t6506_w AT 04,02 WITH FORM "axm/42f/axmt6006"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("axmt6006")
   CALL cl_set_comp_visible("ogc13",FALSE) #FUN-C50097 
 
   DECLARE t6506_c CURSOR FOR
        #SELECT ogc12,ogc09,ogc091,ogc092,img10,ogc15,ogc15_fac,ogc16,ogc18   #MOD-8B0161   #CHI-9C0024 move ogc12
        SELECT ogc09,ogc091,ogc092,ogc12,ogc13,img10,ogc15,ogc15_fac,ogc16,ogc18   #MOD-8B0161   #CHI-9C0024 move ogc12
          FROM ogc_file LEFT OUTER JOIN img_file ON ogc09 = img02 AND ogc091 = img03 AND ogc092 = img04  #No.TQC-9A0132 mod
         WHERE ogc01 = g_oga.oga01 AND ogc03 = g_ogb[l_ac].ogb03
           AND img01=g_ogb[l_ac].ogb04  #FUN-C50097 ADD OGC13 
 
   CALL l_ogc.clear()
 
   LET i = 1
   FOREACH t6506_c INTO l_ogc[i].*
      IF STATUS THEN
         CALL cl_err('foreach ogc',STATUS,0)  
         EXIT FOREACH
      END IF
      LET i = i + 1
   END FOREACH
   CALL l_ogc.deleteElement(i)
   LET l_i=i-1
   DISPLAY l_i TO cn2
 
   SELECT SUM(ogc12),SUM(ogc16) INTO l_ogc12_t,l_ogc16_t FROM ogc_file
    WHERE ogc01 = g_oga.oga01 AND ogc03 = g_ogb[l_ac].ogb03
   DISPLAY l_ogc12_t TO ogc12t
   DISPLAY l_ogc16_t TO ogc16t
   DISPLAY g_ogb[l_ac].ogb12 TO ogb12t   #MOD-8B0216
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY l_ogc WITHOUT DEFAULTS FROM s_ogc.*
         ATTRIBUTE(COUNT=l_i,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
     BEFORE INPUT
         IF l_i != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
     BEFORE ROW
        LET i=ARR_CURR()
        IF cl_null(l_ogc[i].ogc18) OR l_ogc[i].ogc18 = 0 THEN
           SELECT MAX(ogc18)+1 INTO l_ogc[i].ogc18
             FROM ogc_file 
            WHERE ogc01 = g_oga.oga01
              AND ogc03 = g_ogb[l_ac].ogb03
        END IF
        IF cl_null(l_ogc[i].ogc09) THEN
           LET l_ogc[i].ogc09 = g_ogb[l_ac].ogb09
        END IF
        IF cl_null(l_ogc[i].ogc091) THEN
           LET l_ogc[i].ogc091= g_ogb[l_ac].ogb091
        END IF
        IF cl_null(l_ogc[i].ogc092) THEN
           LET l_ogc[i].ogc092= g_ogb[l_ac].ogb092
        END IF
        NEXT FIELD ogc12
 
     AFTER FIELD ogc09
        IF NOT cl_null(l_ogc[i].ogc09) THEN
           LET g_cnt=0
           SELECT count(*) INTO g_cnt  FROM imd_file
            WHERE imd01=l_ogc[i].ogc09
               AND imdacti='Y'
           IF g_cnt=0 THEN
              CALL cl_err(l_ogc[i].ogc09,'axm-993',0)
              NEXT FIELD ogc09
           END IF
           #No.FUN-AA0062  --Begin
           IF NOT s_chk_ware(l_ogc[i].ogc09) THEN
              NEXT FIELD ogc09
           END IF
           #No.FUN-AA0062  --End
        END IF
     #-----MOD-A20117---------
      AFTER FIELD ogc12
         LET l_ogc[i].ogc12 = s_digqty(l_ogc[i].ogc12,g_ogb[l_ac].ogb05)  #FUN-910088--add--
         LET l_ogc[i].ogc16 = l_ogc[i].ogc12 * l_ogc[i].ogc15_fac
         LET l_ogc[i].ogc16 = s_digqty(l_ogc[i].ogc16,l_ogc[i].ogc15)    #FUN-910088--add--
         DISPLAY l_ogc[i].ogc12 TO s_ogc[j].ogc12    #FUN-910088--add--
         DISPLAY l_ogc[i].ogc16 TO s_ogc[j].ogc16

         LET g_ima918 = ''   
         LET g_ima921 = ''   
         SELECT ima918,ima921 INTO g_ima918,g_ima921
           FROM ima_file
          WHERE ima01 = g_ogb[l_ac].ogb04
            AND imaacti = "Y"

         IF (g_ima918 = "Y" OR g_ima921 = "Y") AND (l_ogc[i].ogc12<>0) THEN
            SELECT img09 INTO l_ogc[i].ogc15
              FROM img_file
             WHERE img01 = g_ogb[l_ac].ogb04
               AND img02 = l_ogc[i].ogc09
               AND img03 = l_ogc[i].ogc091
               AND img04 = l_ogc[i].ogc092
             
            LET l_ogc[i].ogc16 = s_digqty(l_ogc[i].ogc16,l_ogc[i].ogc15)    #FUN-910088--add--
            DISPLAY l_ogc[i].ogc15 TO s_ogc[j].ogc15
            DISPLAY l_ogc[i].ogc16 TO s_ogc[j].ogc16                         #FUN-910088--add--

            IF NOT cl_null(l_ogc[i].ogc15) THEN 
               CALL s_umfchk(g_ogb[l_ac].ogb04,g_ogb[l_ac].ogb05,l_ogc[i].ogc15)
                   RETURNING g_cnt,l_ogc[i].ogc15_fac
               IF g_cnt=1 THEN
                  CALL cl_err('','mfg3075',1)
                 #TQC-C50131 -- add -- begin
                  CALL cl_getmsg('asf-176',g_lang) RETURNING l_msg
                  LET l_msg = l_msg CLIPPED,"(",g_ogb[l_ac].ogb04,")"
                  CALL cl_msgany(10,20,l_msg)
                 #TQC-C50131 -- add -- end
                  NEXT FIELD ogc092 
               END IF
            END IF

            IF cl_null(l_ogc[i].ogc15_fac) THEN
               LET l_ogc[i].ogc15_fac = 1
            END IF

            #CHI-9A0022 --Begin
            IF cl_null(g_ogb[l_ac].ogb41) THEN
               LET l_bno = ''
            ELSE
               LET l_bno = g_ogb[l_ac].ogb41
            END IF
            #CHI-9A0022 --End
           #CALL s_lotout(g_prog,g_oga.oga01,g_ogb[l_ac].ogb03,l_ogc[i].ogc18,      #TQC-B90236 mark
            CALL s_mod_lot(g_prog,g_oga.oga01,g_ogb[l_ac].ogb03,l_ogc[i].ogc18,      #TQC-B90236 add
                          g_ogb[l_ac].ogb04,l_ogc[i].ogc09,
                          l_ogc[i].ogc091,l_ogc[i].ogc092,
                          g_ogb[l_ac].ogb05,l_ogc[i].ogc15,l_ogc[i].ogc15_fac,
                          l_ogc[i].ogc12,l_bno,'MOD',-1)#CHI-9A0022 add l_bno        #TQC-B90236 add '-1'
                RETURNING l_r,g_qty
            IF l_r = "Y" THEN
               LET l_ogc[i].ogc12 = g_qty
               LET l_ogc[i].ogc12 = s_digqty(l_ogc[i].ogc12,g_ogb[l_ac].ogb05)   #FUN-910088--add--
            END IF
         END IF
     #-----END MOD-A20117-----
 
     AFTER ROW
        IF l_ogc[i].ogc12 IS NOT NULL AND l_ogc[i].ogc12 != 0 THEN
           IF l_ogc[i].ogc09 IS NULL THEN LET l_ogc[i].ogc09 = ' ' END IF
           IF l_ogc[i].ogc091 IS NULL THEN LET l_ogc[i].ogc091 = ' ' END IF
           IF l_ogc[i].ogc092 IS NULL THEN LET l_ogc[i].ogc092 = ' ' END IF
           SELECT img10,img09,img21 INTO l_ogc[i].img10,l_ogc[i].ogc15,l_img21
             FROM img_file
            WHERE img01 = g_ogb[l_ac].ogb04 AND img02 = l_ogc[i].ogc09
              AND img03 = l_ogc[i].ogc091   AND img04 = l_ogc[i].ogc092
           IF STATUS THEN
             #FUN-C80107 modify begin-----------------------------------121024
             #CALL cl_err3("sel","img_file",g_ogb[l_ac].ogb04,"",STATUS,"","sel img",1)  #No.FUN-660167
             #NEXT FIELD ogc09
              LET l_flag = NULL
             #CALL s_inv_shrt_by_warehouse(g_sma.sma894[2,2],l_ogc[i].ogc09) RETURNING l_flag #FUN-D30024 mark
              CALL s_inv_shrt_by_warehouse(l_ogc[i].ogc09,g_plant) RETURNING l_flag                   #FUN-D30024 add #TQC-D40078 g_plant
              IF l_flag = 'N' OR l_flag IS NULL THEN 
                 CALL cl_err3("sel","img_file",g_ogb[l_ac].ogb04,"",STATUS,"","sel img",1)
                 NEXT FIELD ogc09
              ELSE
                 IF g_sma.sma892[3,3] = 'Y' THEN
                    IF NOT cl_confirm('mfg1401') THEN NEXT FIELD ogc09 END IF
                 END IF
                 CALL s_add_img(g_ogb[l_ac].ogb04,l_ogc[i].ogc09,
                                l_ogc[i].ogc091,l_ogc[i].ogc092,
                                g_oga.oga01,g_ogb[l_ac].ogb03,g_oga.oga02)
                 IF g_errno='N' THEN
                    NEXT FIELD ogc09
                 END IF
              END IF
             #FUN-C80107 modify end-----------------------------------
           END IF
           DISPLAY l_ogc[i].img10 TO s_ogc[j].img10
           DISPLAY l_ogc[i].ogc15 TO s_ogc[j].ogc15
           CALL s_umfchk(g_ogb[l_ac].ogb04,g_ogb[l_ac].ogb05,l_ogc[i].ogc15)
                         RETURNING g_cnt,l_ogc[i].ogc15_fac
           IF g_cnt=1 THEN 
              CALL cl_err('','mfg3075',1) 
             #TQC-C50131 -- add -- begin
              CALL cl_getmsg('asf-176',g_lang) RETURNING l_msg
              LET l_msg = l_msg CLIPPED,"(",g_ogb[l_ac].ogb04,")"
              CALL cl_msgany(10,20,l_msg)
             #TQC-C50131 -- add -- end
              NEXT FIELD ogc092 
           END IF
           IF cl_null(l_ogc[i].ogc15_fac) THEN LET l_ogc[i].ogc15_fac=1 END IF
           LET l_ogc[i].ogc16 = l_ogc[i].ogc12 * l_ogc[i].ogc15_fac
           LET l_ogc[i].ogc16 = s_digqty(l_ogc[i].ogc16,l_ogc[i].ogc15)     #FUN-910088--add--
           DISPLAY l_ogc[i].ogc16 TO s_ogc[j].ogc16
        END IF
 
        IF l_ogc[i].ogc12 IS NOT NULL AND l_ogc[i].ogc12 <> 0 THEN
           FOR k = 1 TO l_ogc.getLength()
              IF k=i THEN CONTINUE FOR END IF
              IF l_ogc[k].ogc09 = l_ogc[i].ogc09 AND
                 l_ogc[k].ogc091= l_ogc[i].ogc091 AND
                 l_ogc[k].ogc092= l_ogc[i].ogc092 THEN
                 INITIALIZE l_ogc[i].* TO NULL DISPLAY l_ogc[i].* TO s_ogc[j].*
                 CALL cl_err('',-239,0) EXIT FOR
              END IF
           END FOR
        END IF
 
        LET l_ogc12_t = 0
        LET l_ogc16_t = 0
        FOR k = 1 TO l_ogc.getLength()
           IF l_ogc[k].ogc12 IS NOT NULL AND l_ogc[k].ogc12 <> 0 THEN
              LET l_ogc12_t = l_ogc12_t + l_ogc[k].ogc12
              LET l_ogc16_t = l_ogc16_t + l_ogc[k].ogc16 #/ l_ogc[k].ogc15_fac
           END IF
        END FOR
        DISPLAY l_ogc12_t TO ogc12t
        DISPLAY l_ogc16_t TO ogc16t
 
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           EXIT INPUT
        END IF
 
     AFTER INPUT
        IF l_ogc12_t != g_ogb[l_ac].ogb12 THEN
           IF cl_confirm('axm-170') THEN
              EXIT INPUT
           ELSE
              NEXT FIELD ogc09
           END IF
        END IF

     #-----MOD-A20117---------
     ON ACTION modi_lot
        LET g_ima918 = ''   
        LET g_ima921 = ''   
        SELECT ima918,ima921 INTO g_ima918,g_ima921
          FROM ima_file
         WHERE ima01 = g_ogb[l_ac].ogb04
           AND imaacti = "Y"

        IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
           SELECT img09 INTO l_ogc[i].ogc15
             FROM img_file
            WHERE img01 = g_ogb[l_ac].ogb04
              AND img02 = l_ogc[i].ogc09
              AND img03 = l_ogc[i].ogc091
              AND img04 = l_ogc[i].ogc092
           
           DISPLAY l_ogc[i].ogc15 TO s_ogc[j].ogc15
           LET l_ogc[i].ogc16 = s_digqty(l_ogc[i].ogc16,l_ogc[i].ogc15)    #FUN-910088--add--
           DISPLAY l_ogc[i].ogc16 TO s_ogc[j].ogc16                        #FUN-910088--add--

           IF NOT cl_null(l_ogc[i].ogc15) THEN 
              CALL s_umfchk(g_ogb[l_ac].ogb04,g_ogb[l_ac].ogb05,l_ogc[i].ogc15)
                  RETURNING g_cnt,l_ogc[i].ogc15_fac
              IF g_cnt=1 THEN
                 CALL cl_err('','mfg3075',1)
                #TQC-C50131 -- add -- begin
                 CALL cl_getmsg('asf-176',g_lang) RETURNING l_msg
                 LET l_msg = l_msg CLIPPED,"(",g_ogb[l_ac].ogb04,")"
                 CALL cl_msgany(10,20,l_msg)
                #TQC-C50131 -- add -- end
                 NEXT FIELD ogc092 
              END IF
           END IF

           IF cl_null(l_ogc[i].ogc15_fac) THEN
              LET l_ogc[i].ogc15_fac = 1
           END IF

           #CHI-9A0022 --Begin
           IF cl_null(g_ogb[l_ac].ogb41) THEN
              LET l_bno = ''
           ELSE
              LET l_bno = g_ogb[l_ac].ogb41
           END IF
           #CHI-9A0022 --End
          #CALL s_lotout(g_prog,g_oga.oga01,g_ogb[l_ac].ogb03,l_ogc[i].ogc18,      #TQC-B90236 mark
           CALL s_mod_lot(g_prog,g_oga.oga01,g_ogb[l_ac].ogb03,l_ogc[i].ogc18,      #TQC-B90236 add
                         g_ogb[l_ac].ogb04,l_ogc[i].ogc09,
                         l_ogc[i].ogc091,l_ogc[i].ogc092,
                         g_ogb[l_ac].ogb05,l_ogc[i].ogc15,l_ogc[i].ogc15_fac,
                         l_ogc[i].ogc12,l_bno,'MOD',-1)#CHI-9A0022 add l_bno      #TQC-B90236 add '-1'
               RETURNING l_r,g_qty
           IF l_r = "Y" THEN
              LET l_ogc[i].ogc12 = g_qty
              LET l_ogc[i].ogc12 = s_digqty(l_ogc[i].ogc12,g_ogb[l_ac].ogb05)    #FUN-910088--add--
           END IF
        END IF
     #-----END MOD-A20117-----
 
      ON ACTION controlp
            CASE
                WHEN INFIELD(ogc09)
                   #FUN-C30300---begin
                   LET g_ima906 = NULL
                   SELECT ima906 INTO g_ima906 FROM ima_file
                    WHERE ima01 = g_ogb[l_ac].ogb04
                   #IF s_industry("icd") AND g_ima906='3' THEN  #TQC-C60028
                   IF s_industry("icd") THEN  #TQC-C60028
                      CALL q_idc(FALSE,TRUE,g_ogb[l_ac].ogb04,l_ogc[i].ogc09,l_ogc[i].ogc091,l_ogc[i].ogc092)
                      RETURNING l_ogc[i].ogc09,l_ogc[i].ogc091,l_ogc[i].ogc092
                   ELSE
                   #FUN-C30300---end
                      #No.FUN-AA0062  --Begin
                      #CALL q_img4(FALSE,FALSE,g_ogb[l_ac].ogb04,' ',' ',' ','A')
                      CALL q_img4(FALSE,TRUE,g_ogb[l_ac].ogb04,l_ogc[i].ogc09,l_ogc[i].ogc091,l_ogc[i].ogc092,'A')
                               RETURNING l_ogc[i].ogc09,l_ogc[i].ogc091,
                                         l_ogc[i].ogc092
                   END IF  #FUN-C30300                      
                   IF INT_FLAG THEN
                     LET INT_FLAG = 0
                   END IF 
                   #No.FUN-AA0062  --End
                   DISPLAY BY NAME l_ogc[i].ogc09,l_ogc[i].ogc091,l_ogc[i].ogc092         #No.MOD-490371
                   NEXT FIELD ogc09
#No.FUN-AA0062  --Begin
#                WHEN INFIELD(ogc091)
#                     CALL cl_init_qry_var()
#                     LET g_qryparam.form = "q_ime"
#                     LET g_qryparam.default1 = l_ogc[i].ogc091
#                     LET g_qryparam.arg1     = l_ogc[i].ogc09 #倉庫編號
#                     LET g_qryparam.arg2     = 'SW'           #倉庫類別 
#                     CALL cl_create_qry() RETURNING l_ogc[i].ogc091
#                     DISPLAY BY NAME l_ogc[i].ogc091       
#                     NEXT FIELD ogc091
                WHEN INFIELD(ogc091)
                   #FUN-C30300---begin
                   LET g_ima906 = NULL
                   SELECT ima906 INTO g_ima906 FROM ima_file
                    WHERE ima01 = g_ogb[l_ac].ogb04
                   #IF s_industry("icd") AND g_ima906='3' THEN  #TQC-C60028
                   IF s_industry("icd") THEN  #TQC-C60028
                      CALL q_idc(FALSE,TRUE,g_ogb[l_ac].ogb04,l_ogc[i].ogc09,l_ogc[i].ogc091,l_ogc[i].ogc092)
                      RETURNING l_ogc[i].ogc09,l_ogc[i].ogc091,l_ogc[i].ogc092
                   ELSE
                   #FUN-C30300---end
                      CALL q_img4(FALSE,TRUE,g_ogb[l_ac].ogb04,l_ogc[i].ogc09,l_ogc[i].ogc091,l_ogc[i].ogc092,'A')                                                   
                               RETURNING l_ogc[i].ogc09,l_ogc[i].ogc091,                                                               
                                         l_ogc[i].ogc092  
                   END IF #FUN-C30300   
                   IF INT_FLAG THEN
                     LET INT_FLAG = 0
                   END IF   
                   DISPLAY BY NAME l_ogc[l_ac].ogc09
                   DISPLAY BY NAME l_ogc[l_ac].ogc091
                   DISPLAY BY NAME l_ogc[l_ac].ogc092
                   NEXT FIELD ogc091 
                WHEN INFIELD(ogc092)
                   #FUN-C30300---begin
                   LET g_ima906 = NULL
                   SELECT ima906 INTO g_ima906 FROM ima_file
                    WHERE ima01 = g_ogb[l_ac].ogb04
                   #IF s_industry("icd") AND g_ima906='3' THEN  #TQC-C60028
                   IF s_industry("icd") THEN  #TQC-C60028
                      CALL q_idc(FALSE,TRUE,g_ogb[l_ac].ogb04,l_ogc[i].ogc09,l_ogc[i].ogc091,l_ogc[i].ogc092)
                      RETURNING l_ogc[i].ogc09,l_ogc[i].ogc091,l_ogc[i].ogc092
                   ELSE
                   #FUN-C30300---end
                      CALL q_img4(FALSE,TRUE,g_ogb[l_ac].ogb04,l_ogc[i].ogc09,l_ogc[i].ogc091,l_ogc[i].ogc092,'A')                                                   
                               RETURNING l_ogc[i].ogc09,l_ogc[i].ogc091,                                                               
                                         l_ogc[i].ogc092  
                   END IF    #FUN-C30300  
                   IF INT_FLAG THEN
                     LET INT_FLAG = 0
                   END IF   
                   DISPLAY BY NAME l_ogc[l_ac].ogc09
                   DISPLAY BY NAME l_ogc[l_ac].ogc091
                   DISPLAY BY NAME l_ogc[l_ac].ogc092
                   NEXT FIELD ogc092    
#No.FUN-AA0062  --Begin                
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
      CALL cl_err('',9001,0)
      LET INT_FLAG = 0
      CLOSE WINDOW t6506_w
      RETURN
   END IF
 
   CLOSE WINDOW t6506_w
 
   LET g_success ='Y'
 
   BEGIN WORK
 
   DELETE FROM ogc_file
    WHERE ogc01 = g_oga.oga01
      AND ogc03 = g_ogb[l_ac].ogb03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("del","ogc_file",g_oga.oga01,g_ogb[l_ac].ogb03,SQLCA.sqlcode,"","del_ogc",1)  #No.FUN-660167
      ROLLBACK WORK RETURN
   END IF
   FOR i = 1 TO l_ogc.getLength()
       IF l_ogc[i].ogc12 IS NULL OR l_ogc[i].ogc12=0 THEN 
          #-----MOD-A20117---------
         #IF s_lotout_del(g_prog,g_oga.oga01,g_ogb[l_ac].ogb03,l_ogc[i].ogc18,g_ogb[l_ac].ogb04,'DEL') THEN   #TQC-B90236
          IF s_lot_del(g_prog,g_oga.oga01,g_ogb[l_ac].ogb03,l_ogc[i].ogc18,g_ogb[l_ac].ogb04,'DEL') THEN   #TQC-B90236
             CONTINUE FOR
          END IF
          #-----END MOD-A20117-----
       END IF
           IF cl_null(l_ogc[i].ogc09) THEN LET l_ogc[i].ogc09=' ' END IF
           IF cl_null(l_ogc[i].ogc091) THEN LET l_ogc[i].ogc091=' ' END IF
           IF cl_null(l_ogc[i].ogc092) THEN LET l_ogc[i].ogc092=' ' END IF
       INSERT INTO ogc_file(ogc01,ogc03,ogc09,ogc091,ogc092,
                             ogc12,ogc15,ogc15_fac,ogc16,ogc17,ogc18,ogcplant,ogclegal,ogc13)  #No.MOD-470041   #MOD-8B0161 #FUN-980010 add ogcplant,ogclegal
                     VALUES(g_oga.oga01,g_ogb[l_ac].ogb03,
	      	            l_ogc[i].ogc09, l_ogc[i].ogc091,
                            l_ogc[i].ogc092,l_ogc[i].ogc12,
	      	            l_ogc[i].ogc15, l_ogc[i].ogc15_fac,
                            l_ogc[i].ogc16,g_ogb[l_ac].ogb04,l_ogc[i].ogc18,g_plant,g_legal,l_ogc[i].ogc13)   #MOD-8B0161 #FUN-980010 g_plant,g_legal #FUN-C50097 ,l_ogc[i].ogc13
       IF SQLCA.sqlcode THEN
          CALL cl_err3("ins","ogc_file",g_oga.oga01,g_ogb[l_ac].ogb03,SQLCA.sqlcode,"","INS-ogc",1)  #No.FUN-660167
          LET g_success = 'N' EXIT FOR
       END IF
    END FOR
 
    IF g_success='Y' THEN
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
 
END FUNCTION
 
FUNCTION t650_b_ogg_1()			# 庫存異動明細(ogg_file)輸入
  DEFINE ls_tmp           STRING
  DEFINE r_ogg            RECORD LIKE ogg_file.*
  DEFINE r_ogc            RECORD LIKE ogc_file.*
  DEFINE l_ogg            DYNAMIC ARRAY OF RECORD
         ogg20            LIKE ogg_file.ogg20,    #MOD-940275 add
         #ogg12            LIKE ogg_file.ogg12,   #CHI-9C0024
         ogg09            LIKE ogg_file.ogg09,
         ogg091           LIKE ogg_file.ogg091,
         ogg092           LIKE ogg_file.ogg092,
         ogg12            LIKE ogg_file.ogg12,   #CHI-9C0024
         ogg13            LIKE ogg_file.ogg13,    #FUN-C50097         
         ogg10            LIKE ogg_file.ogg10,
         img10            LIKE type_file.num10,   #No.FUN-680137 INTEGER
         ogg15            LIKE ogg_file.ogg15,
         ogg15_fac        LIKE ogg_file.ogg15_fac,
         ogg16            LIKE ogg_file.ogg16,
         ogg18            LIKE ogg_file.ogg18   #MOD-910173
                          END RECORD
  DEFINE l_ogg12_t1       LIKE ogg_file.ogg12
  DEFINE l_ogg16_t1       LIKE ogg_file.ogg16
  DEFINE l_ogg12_t2       LIKE ogg_file.ogg12
  DEFINE l_ogg16_t2       LIKE ogg_file.ogg16
  DEFINE l_img21          LIKE img_file.img21
  DEFINE l_ima906         LIKE ima_file.ima906
  DEFINE l_img09          LIKE img_file.img09
  DEFINE i,j,s,l_i,k      LIKE type_file.num5,    #No.FUN-680137 SMALLINT
         l_allow_insert   LIKE type_file.num5,                #可新增否  #No.FUN-680137 SMALLINT
         l_allow_delete   LIKE type_file.num5                 #可刪除否  #No.FUN-680137 SMALLINT
  DEFINE l_msg            STRING
  DEFINE l_msg1           STRING
  DEFINE l_msg2           STRING
  DEFINE l_cnt            LIKE type_file.num5     #No:FUN-BA0019
 
   IF g_ogb[l_ac].ogb17 IS NULL THEN RETURN END IF
   IF g_ogb[l_ac].ogb17 = 'N' THEN RETURN END IF
 
   SELECT COUNT(*) INTO i FROM ogg_file
    WHERE ogg01 = g_oga.oga01 AND ogg03 = g_ogb[l_ac].ogb03
 
   OPEN WINDOW t6006_w AT 04,02 WITH FORM "axm/42f/axmt600e"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("axmt600e")
   CALL cl_set_comp_visible("ogg13",FALSE)  #FUN-C50097
   IF g_sma.sma122 = '1' THEN
      CALL cl_getmsg('asm-303',g_lang) RETURNING l_msg1
      CALL cl_getmsg('asm-302',g_lang) RETURNING l_msg2
      LET l_msg = '1:',l_msg1 CLIPPED,',2:',l_msg2 CLIPPED
      CALL cl_set_combo_items('ogg20','1,2',l_msg)
   END IF
 
   IF g_sma.sma122 ='2' THEN
      CALL cl_getmsg('asm-326',g_lang) RETURNING l_msg1
      CALL cl_getmsg('asm-304',g_lang) RETURNING l_msg2
      LET l_msg = '1:',l_msg1 CLIPPED,',2:',l_msg2 CLIPPED
      CALL cl_set_combo_items('ogg20','1,2',l_msg)
   END IF
 
   DECLARE t6006_ogg_c_1 CURSOR FOR
    #SELECT ogg20,ogg12,ogg09,ogg091,ogg092,ogg10,0,ogg15,ogg15_fac,ogg16,ogg18     #FUN-8A0030 Add ''   #No.FUN-8B0021 #MOD-940275 move ogg20   #CHI-9C0024 move ogg12
    #SELECT ogg20,ogg09,ogg091,ogg092,ogc12,ogg10,0,ogg15,ogg15_fac,ogg16,ogg18     #FUN-8A0030 Add ''   #No.FUN-8B0021 #MOD-940275 move ogg20   #CHI-9C0024 move ogg12 #FUN-C10038 mark
    SELECT ogg20,ogg09,ogg091,ogg092,ogg12,ogg13,ogg10,0,ogg15,ogg15_fac,ogg16,ogg18      #FUN-C10038   
      FROM ogg_file #FUN-C50097 ADD OGG13 
     WHERE ogg01 = g_oga.oga01 AND ogg03 = g_ogb[l_ac].ogb03
     ORDER BY ogg20    #MOD-940275 add
 
   CALL l_ogg.clear()
 
   LET i = 1
   FOREACH t6006_ogg_c_1 INTO l_ogg[i].*
      IF STATUS THEN
         CALL cl_err('foreach ogg',STATUS,0) 
         EXIT FOREACH
      END IF
      IF l_ima906 = '1' THEN
         SELECT img10 INTO l_ogg[i].img10 FROM img_file
          WHERE img01=g_ogb[l_ac].ogb04 AND img02=l_ogg[i].ogg09
            AND img03=l_ogg[i].ogg091   AND img04=l_ogg[i].ogg092
      END IF
      IF l_ima906 = '2' THEN
         SELECT imgg10 INTO l_ogg[i].img10 FROM imgg_file
          WHERE imgg01=g_ogb[l_ac].ogb04 AND imgg02=l_ogg[i].ogg09
            AND imgg03=l_ogg[i].ogg091   AND imgg04=l_ogg[i].ogg092
            AND imgg09=l_ogg[i].ogg10
      END IF
      IF l_ima906 = '3' THEN
         IF l_ogg[i].ogg20 = '2' THEN
            SELECT imgg10 INTO l_ogg[i].img10 FROM imgg_file
             WHERE imgg01=g_ogb[l_ac].ogb04 AND imgg02=l_ogg[i].ogg09
               AND imgg03=l_ogg[i].ogg091   AND imgg04=l_ogg[i].ogg092
               AND imgg09=l_ogg[i].ogg10
         ELSE
            SELECT img10 INTO l_ogg[i].img10 FROM img_file
             WHERE img01=g_ogb[l_ac].ogb04 AND img02=l_ogg[i].ogg09
               AND img03=l_ogg[i].ogg091   AND img04=l_ogg[i].ogg092
         END IF
      END IF
      IF cl_null(l_ogg[i].img10) THEN LET l_ogg[i].img10 = 0 END IF
      LET i = i + 1
   END FOREACH
   CALL l_ogg.deleteElement(i)
   LET l_i=i-1
   DISPLAY l_i TO cn2
 
   SELECT SUM(ogg12),SUM(ogg16) INTO l_ogg12_t1,l_ogg16_t1 FROM ogg_file
    WHERE ogg01 = g_oga.oga01 AND ogg03 = g_ogb[l_ac].ogb03
      AND ogg20 = '1'
   SELECT SUM(ogg12),SUM(ogg16) INTO l_ogg12_t2,l_ogg16_t2 FROM ogg_file
    WHERE ogg01 = g_oga.oga01 AND ogg03 = g_ogb[l_ac].ogb03
      AND ogg20 = '2'

   DISPLAY l_ogg12_t1 TO ogg12t_1
   DISPLAY l_ogg16_t1 TO ogg16t_1
   DISPLAY l_ogg12_t2 TO ogg12t_2
   DISPLAY l_ogg16_t2 TO ogg16t_2
   DISPLAY g_ogb[l_ac].ogb912 TO ogb12t_1   #No.MOD-590206
   DISPLAY g_ogb[l_ac].ogb915 TO ogb12t_2   #No.MOD-590206
 
   CALL cl_set_act_visible("cancel", FALSE)
   LET i=ARR_CURR()   #MOD-A20117
   IF g_action_choice="qry_mntn_inv_detail" THEN
      DISPLAY ARRAY l_ogg TO s_ogg.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)       #No.FUN-640123

        #-----MOD-A20117---------
        BEFORE ROW 
          LET i = ARR_CURR()
        #-----END MOD-A20117----- 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE DISPLAY
 
        ON ACTION about         
           CALL cl_about()      
 
        ON ACTION help          
           CALL cl_show_help()  
 
        ON ACTION controlg      
           CALL cl_cmdask()     

      #-----MOD-A20117---------
      ON ACTION qry_lot
        LET g_ima918 = ''
        LET g_ima921 = ''
        SELECT ima918,ima921 INTO g_ima918,g_ima921
          FROM ima_file
         WHERE ima01 = g_ogb[l_ac].ogb04
           AND imaacti = "Y"
      
        IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
          #CALL s_lotout(g_prog,g_oga.oga01,g_ogb[l_ac].ogb03,l_ogg[i].ogg18,      #TQC-B90236 mark
           CALL s_mod_lot(g_prog,g_oga.oga01,g_ogb[l_ac].ogb03,l_ogg[i].ogg18,      #TQC-B90236 add
                         g_ogb[l_ac].ogb04,l_ogg[i].ogg09,
                         l_ogg[i].ogg091,l_ogg[i].ogg092,
                         l_ogg[i].ogg10,l_ogg[i].ogg15,l_ogg[i].ogg15_fac,
                         l_ogg[i].ogg12,'','QRY',-1)#CHI-9A0022 add ''              #TQC-B90236 add '-1'
               RETURNING l_r,g_qty
           IF l_r = "Y" THEN
              LET l_ogg[i].ogg12 = g_qty
              LET l_ogg[i].ogg12 = s_digqty(l_ogg[i].ogg12,l_ogg[i].ogg10)   #FUN-910088--add--
           END IF
        END IF
      #-----END MOD-A20117----- 
      END DISPLAY 
   END IF
   CLOSE WINDOW t6006_w
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
END FUNCTION
 
FUNCTION t650_b_ogg()			# 庫存異動明細(ogg_file)輸入
  DEFINE r_ogg            RECORD LIKE ogg_file.*
  DEFINE r_ogc            RECORD LIKE ogc_file.*
  DEFINE l_ogg            DYNAMIC ARRAY OF RECORD
         ogg20            LIKE ogg_file.ogg20,       #MOD-940275 add
         #ogg12            LIKE ogg_file.ogg12,      #CHI-9C0024
         ogg09            LIKE ogg_file.ogg09,
         ogg091           LIKE ogg_file.ogg091,
         ogg092           LIKE ogg_file.ogg092,
         ogg12            LIKE ogg_file.ogg12,       #CHI-9C0024
         ogg13            LIKE ogg_file.ogg13,    #FUN-C50097
         ogg10            LIKE ogg_file.ogg10,
         img10            LIKE type_file.num10,      #No.FUN-680137 INTEGER
         ogg15            LIKE ogg_file.ogg15,
         ogg15_fac        LIKE ogg_file.ogg15_fac,
         ogg16            LIKE ogg_file.ogg16,
         ogg18            LIKE ogg_file.ogg18        #MOD-910173
                          END RECORD
  DEFINE l_ogg12_t1       LIKE ogg_file.ogg12
  DEFINE l_ogg16_t1       LIKE ogg_file.ogg16
  DEFINE l_ogg12_t2       LIKE ogg_file.ogg12
  DEFINE l_ogg16_t2       LIKE ogg_file.ogg16
  DEFINE l_img21          LIKE img_file.img21
  DEFINE l_ima906         LIKE ima_file.ima906
  DEFINE l_img09          LIKE img_file.img09
  DEFINE i,j,s,l_i,k      LIKE type_file.num5,       #No.FUN-680137 SMALLINT
         l_allow_insert   LIKE type_file.num5,       #可新增否  #No.FUN-680137 SMALLINT
         l_allow_delete   LIKE type_file.num5        #可刪除否  #No.FUN-680137 SMALLINT
  DEFINE l_ogg18          LIKE ogg_file.ogg18        #MOD-910173
  DEFINE l_pmd            LIKE type_file.chr1
  DEFINE l_msg            STRING
  DEFINE l_msg1           STRING
  DEFINE l_msg2           STRING
  DEFINE l_msg3           STRING                     #TQC-C50131 -- add
  DEFINE l_bno            LIKE rvbs_file.rvbs08      #CHI-9A0022 
  DEFINE l_cnt            LIKE type_file.num5        #FUN-BA0019  
  DEFINE l_flag           LIKE type_file.chr1        #FUN910088--add--
  DEFINE l_flag1          LIKE type_file.chr1   #FUN-C80107 add 121024

   IF g_ogb[l_ac].ogb17 IS NULL THEN RETURN END IF
   IF g_ogb[l_ac].ogb17 = 'N' THEN RETURN END IF
 
   SELECT COUNT(*) INTO i FROM ogg_file
    WHERE ogg01 = g_oga.oga01 AND ogg03 = g_ogb[l_ac].ogb03
 
   LET l_ogg18 = 0   #MOD-910173
   SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01=g_ogb[l_ac].ogb04
   LET r_ogg.ogg17 = g_ogb[l_ac].ogb04   #FUN-BA0019 ogb17已改為not null
   IF i = 0 AND g_oaz.oaz71='1' THEN
      LET r_ogg.ogg01 = g_oga.oga01
      LET r_ogg.ogg03 = g_ogb[l_ac].ogb03
      LET r_ogg.ogg09 = g_ogb[l_ac].ogb09
      LET r_ogg.ogg091 = g_ogb[l_ac].ogb091
      LET r_ogg.ogg092 = g_ogb[l_ac].ogb092
      LET r_ogg.oggplant = g_plant #FUN-980010 add
      LET r_ogg.ogglegal = g_legal #FUN-980010 add
      LET r_ogg.ogg13 = 0  #FUN-C50097 ADD
      IF l_ima906 = '1' THEN
         SELECT img09 INTO r_ogg.ogg15 FROM img_file
          WHERE img01=g_ogb[l_ac].ogb04
            AND img02=g_ogb[l_ac].ogb09
            AND img03=g_ogb[l_ac].ogb091
            AND img04=g_ogb[l_ac].ogb092
         LET r_ogg.ogg10 = g_ogb[l_ac].ogb910
         LET r_ogg.ogg12 = g_ogb[l_ac].ogb912
         CALL s_umfchk(g_ogb[l_ac].ogb04,r_ogg.ogg10,r_ogg.ogg15)
              RETURNING g_cnt,r_ogg.ogg15_fac
         IF g_cnt=1 THEN LET r_ogg.ogg15_fac=1 END IF
         LET r_ogg.ogg16=g_ogb[l_ac].ogb912*r_ogg.ogg15_fac
         LET r_ogg.ogg16 = s_digqty(r_ogg.ogg16,r_ogg.ogg15)   #FUN-910088--add--
         LET r_ogg.ogg20=1
         LET l_ogg18 = l_ogg18 + 1    #MOD-910173
         LET r_ogg.ogg18 = l_ogg18    #MOD-910173
         IF cl_null(r_ogg.ogg13) THEN 
            LET r_ogg.ogg13 = 0  #FUN-C50097 ADD
         END IF         
         INSERT INTO ogg_file VALUES (r_ogg.*)
      END IF
      IF l_ima906 ='2' THEN
         IF NOT cl_null(g_ogb[l_ac].ogb910) THEN
            LET r_ogg.ogg10=g_ogb[l_ac].ogb910
            LET r_ogg.ogg12=g_ogb[l_ac].ogb912
            LET r_ogg.ogg15=g_ogb[l_ac].ogb910
            LET r_ogg.ogg15_fac=1
            LET r_ogg.ogg16=g_ogb[l_ac].ogb912
            LET r_ogg.ogg20=1
            LET l_ogg18 = l_ogg18 + 1    #MOD-910173
            LET r_ogg.ogg18 = l_ogg18    #MOD-910173
            IF cl_null(r_ogg.ogg13) THEN 
               LET r_ogg.ogg13 = 0  #FUN-C50097 ADD
            END IF            
            INSERT INTO ogg_file VALUES (r_ogg.*)
         END IF
         IF NOT cl_null(g_ogb[l_ac].ogb913) THEN
            LET r_ogg.ogg10=g_ogb[l_ac].ogb913
            LET r_ogg.ogg12=g_ogb[l_ac].ogb915
            LET r_ogg.ogg15=g_ogb[l_ac].ogb913
            LET r_ogg.ogg15_fac=1
            LET r_ogg.ogg16=g_ogb[l_ac].ogb915
            LET r_ogg.ogg20=2
            LET l_ogg18 = l_ogg18 + 1    #MOD-910173
            LET r_ogg.ogg18 = l_ogg18    #MOD-910173
            IF cl_null(r_ogg.ogg13) THEN 
               LET r_ogg.ogg13 = 0  #FUN-C50097 ADD
            END IF            
            INSERT INTO ogg_file VALUES (r_ogg.*)
         END IF
      END IF
      IF l_ima906 ='3' THEN
         SELECT img09 INTO r_ogg.ogg15 FROM img_file
          WHERE img01=g_ogb[l_ac].ogb04
            AND img02=g_ogb[l_ac].ogb09
            AND img03=g_ogb[l_ac].ogb091
            AND img04=g_ogb[l_ac].ogb092
         LET r_ogg.ogg10 = g_ogb[l_ac].ogb910
         LET r_ogg.ogg12 = g_ogb[l_ac].ogb912
         CALL s_umfchk(g_ogb[l_ac].ogb04,r_ogg.ogg10,r_ogg.ogg15)
              RETURNING g_cnt,r_ogg.ogg15_fac
         IF g_cnt=1 THEN LET r_ogg.ogg15_fac=1 END IF
         LET r_ogg.ogg16=g_ogb[l_ac].ogb912*r_ogg.ogg15_fac
         LET r_ogg.ogg16 = s_digqty(r_ogg.ogg16,r_ogg.ogg15)   #FUN-910088--add--
         LET r_ogg.ogg20=1
         LET l_ogg18 = l_ogg18 + 1    #MOD-910173
         LET r_ogg.ogg18 = l_ogg18    #MOD-910173
         IF cl_null(r_ogg.ogg13) THEN 
            LET r_ogg.ogg13 = 0  #FUN-C50097 ADD
         END IF         
         INSERT INTO ogg_file VALUES (r_ogg.*)
         LET r_ogg.ogg10=g_ogb[l_ac].ogb913
         LET r_ogg.ogg12=g_ogb[l_ac].ogb915
         LET r_ogg.ogg15=g_ogb[l_ac].ogb913
         LET r_ogg.ogg15_fac=1
         LET r_ogg.ogg16=g_ogb[l_ac].ogb915
         LET r_ogg.ogg20=2
         LET l_ogg18 = l_ogg18 + 1    #MOD-910173
         LET r_ogg.ogg18 = l_ogg18    #MOD-910173
         IF cl_null(r_ogg.ogg13) THEN 
            LET r_ogg.ogg13 = 0  #FUN-C50097 ADD
         END IF         
         INSERT INTO ogg_file VALUES (r_ogg.*)
      END IF
   END IF
 
   IF i = 0 AND g_oaz.oaz71='2' THEN
      IF l_ima906 = '1' THEN
         DECLARE t6506_c2_1 CURSOR FOR
          SELECT '','',img02,img03,img04,'',0,img09,0,0 FROM img_file
           WHERE img01 = g_ogb[l_ac].ogb04   #CHI-840009 mark AND img04 = g_ogb[l_ac].ogb092
             AND img10 > 0 AND (img18 > g_oga.oga02 OR img18 IS NULL)
 
         FOREACH t6506_c2_1 INTO r_ogg.*
            IF STATUS THEN EXIT FOREACH END IF
            LET r_ogg.ogg01 = g_oga.oga01
            LET r_ogg.ogg03 = g_ogb[l_ac].ogb03
            LET r_ogg.ogg10 = g_ogb[l_ac].ogb910
            LET r_ogg.ogg12 = s_digqty(r_ogg.ogg12,r_ogg.ogg10)   #FUN-910088--add--
            LET r_ogg.ogg20 = 1
            LET l_ogg18 = l_ogg18 + 1    #MOD-910173
            LET r_ogg.ogg18 = l_ogg18    #MOD-910173
            CALL s_umfchk(g_ogb[l_ac].ogb04,r_ogg.ogg10,r_ogg.ogg15)
                 RETURNING g_cnt,r_ogg.ogg15_fac
            IF g_cnt=1 THEN LET r_ogg.ogg15_fac=1 END IF
            LET r_ogg.oggplant = g_plant #FUN-980010 add
            LET r_ogg.ogglegal = g_legal #FUN-980010 add
            IF cl_null(r_ogg.ogg13) THEN 
               LET r_ogg.ogg13 = 0  #FUN-C50097 ADD
            END IF            
            INSERT INTO ogg_file VALUES (r_ogg.*)
         END FOREACH
      END IF
      IF l_ima906 = '2' THEN
         DECLARE t6506_c2_2_1 CURSOR FOR
          SELECT '','',imgg02,imgg03,imgg04,imgg09,0,imgg09,0,0 FROM imgg_file
           WHERE imgg01 = g_ogb[l_ac].ogb04 #MOD-A20102 mark AND imgg04 = g_ogb[l_ac].ogb092
             AND imgg09 = g_ogb[l_ac].ogb910
             AND imgg10 > 0 AND (imgg18 > g_oga.oga02 OR imgg18 IS NULL)
         FOREACH t6506_c2_2_1 INTO r_ogg.*
            IF STATUS THEN EXIT FOREACH END IF
            LET r_ogg.ogg01 = g_oga.oga01
            LET r_ogg.ogg03 = g_ogb[l_ac].ogb03
            LET r_ogg.ogg15_fac = 1
            LET r_ogg.ogg20 = 1
            LET l_ogg18 = l_ogg18 + 1    #MOD-910173
            LET r_ogg.ogg18 = l_ogg18    #MOD-910173
            LET r_ogg.oggplant = g_plant #FUN-980010 add
            LET r_ogg.ogglegal = g_legal #FUN-980010 add
            IF cl_null(r_ogg.ogg13) THEN 
               LET r_ogg.ogg13 = 0  #FUN-C50097 ADD
            END IF            
            INSERT INTO ogg_file VALUES (r_ogg.*)
         END FOREACH
         DECLARE t6506_c2_2_2 CURSOR FOR
          SELECT '','',imgg02,imgg03,imgg04,imgg09,0,imgg09,0,0 FROM imgg_file
           WHERE imgg01 = g_ogb[l_ac].ogb04 #MOD-A20102 mark AND imgg04 = g_ogb[l_ac].ogb092
             AND imgg09 = g_ogb[l_ac].ogb913
             AND imgg10 > 0 AND (imgg18 > g_oga.oga02 OR imgg18 IS NULL)
         FOREACH t6506_c2_2_2 INTO r_ogg.*
            IF STATUS THEN EXIT FOREACH END IF
            LET r_ogg.ogg01 = g_oga.oga01
            LET r_ogg.ogg03 = g_ogb[l_ac].ogb03
            LET r_ogg.ogg15_fac = 1
            LET r_ogg.ogg20 = 2
            LET l_ogg18 = l_ogg18 + 1    #MOD-910173
            LET r_ogg.ogg18 = l_ogg18    #MOD-910173
            LET r_ogg.oggplant = g_plant #FUN-980010 add
            LET r_ogg.ogglegal = g_legal #FUN-980010 add
            IF cl_null(r_ogg.ogg13) THEN 
              LET r_ogg.ogg13 = 0  #FUN-C50097 ADD
            END IF            
            INSERT INTO ogg_file VALUES (r_ogg.*)
         END FOREACH
      END IF
      IF l_ima906 = '3' THEN
         DECLARE t6506_c2_3_1 CURSOR FOR
          SELECT '','',img02,img03,img04,'',0,img09,0,0 FROM img_file
           WHERE img01 = g_ogb[l_ac].ogb04 #MOD-A20102 mark AND img04 = g_ogb[l_ac].ogb092
             AND img10 > 0 AND (img18 > g_oga.oga02 OR img18 IS NULL)
         FOREACH t6506_c2_3_1 INTO r_ogg.*
            IF STATUS THEN EXIT FOREACH END IF
            LET r_ogg.ogg01 = g_oga.oga01
            LET r_ogg.ogg03 = g_ogb[l_ac].ogb03
            LET r_ogg.ogg10 = g_ogb[l_ac].ogb910
            LET r_ogg.ogg12 = s_digqty(r_ogg.ogg12,r_ogg.ogg10)   #FUN-910088--add--
            CALL s_umfchk(g_ogb[l_ac].ogb04,r_ogg.ogg10,r_ogg.ogg15)
                 RETURNING g_cnt,r_ogg.ogg15_fac
            IF g_cnt=1 THEN LET r_ogg.ogg15_fac=1 END IF
            LET r_ogg.ogg20 = 1
            LET l_ogg18 = l_ogg18 + 1    #MOD-910173
            LET r_ogg.ogg18 = l_ogg18    #MOD-910173
            LET r_ogg.oggplant = g_plant #FUN-980010 add
            LET r_ogg.ogglegal = g_legal #FUN-980010 add
            IF cl_null(r_ogg.ogg13) THEN 
              LET r_ogg.ogg13 = 0  #FUN-C50097 ADD
            END IF            
            INSERT INTO ogg_file VALUES (r_ogg.*)
         END FOREACH
         DECLARE t6506_c2_3_2 CURSOR FOR
          SELECT '','',imgg02,imgg03,imgg04,imgg09,0,imgg09,0,0 FROM imgg_file
           WHERE imgg01 = g_ogb[l_ac].ogb04 #MOD-A20102 mark AND imgg04 = g_ogb[l_ac].ogb092
             AND imgg09 = g_ogb[l_ac].ogb913
             AND imgg10 > 0 AND (imgg18 > g_oga.oga02 OR imgg18 IS NULL)
         FOREACH t6506_c2_3_2 INTO r_ogg.*
            IF STATUS THEN EXIT FOREACH END IF
            LET r_ogg.ogg01 = g_oga.oga01
            LET r_ogg.ogg03 = g_ogb[l_ac].ogb03
            LET r_ogg.ogg15_fac = 1
            LET r_ogg.ogg20 = 2
            LET l_ogg18 = l_ogg18 + 1    #MOD-910173
            LET r_ogg.ogg18 = l_ogg18    #MOD-910173
            LET r_ogg.oggplant = g_plant #FUN-980010 add
            LET r_ogg.ogglegal = g_legal #FUN-980010 add
            IF cl_null(r_ogg.ogg13) THEN 
               LET r_ogg.ogg13 = 0  #FUN-C50097 ADD
            END IF            
            INSERT INTO ogg_file VALUES (r_ogg.*)
         END FOREACH
      END IF
   END IF
 
 
   OPEN WINDOW t6506_w AT 04,02 WITH FORM "axm/42f/axmt600e"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("axmt600e")
   CALL cl_set_comp_visible("ogg13",FALSE) #FUN-C50097 ADD
   IF g_sma.sma122 = '1' THEN
      CALL cl_getmsg('asm-303',g_lang) RETURNING l_msg1
      CALL cl_getmsg('asm-302',g_lang) RETURNING l_msg2
      LET l_msg = '1:',l_msg1 CLIPPED,',2:',l_msg2 CLIPPED
      CALL cl_set_combo_items('ogg20','1,2',l_msg)
   END IF
 
   IF g_sma.sma122 ='2' THEN
      CALL cl_getmsg('asm-326',g_lang) RETURNING l_msg1
      CALL cl_getmsg('asm-304',g_lang) RETURNING l_msg2
      LET l_msg = '1:',l_msg1 CLIPPED,',2:',l_msg2 CLIPPED
      CALL cl_set_combo_items('ogg20','1,2',l_msg)
   END IF
 
   DECLARE t6506_ogg_c CURSOR FOR
    #SELECT ogg20,ogg12,ogg09,ogg091,ogg092,ogg10,0,ogg15,ogg15_fac,ogg16,ogg18   #No.FUN-8B0021   #FUN-8A0030 Add '' #MOD-940275 move ogg20   #CHI-9C0024 move ogg12
    SELECT ogg20,ogg09,ogg091,ogg092,ogg12,ogg13,ogg10,0,ogg15,ogg15_fac,ogg16,ogg18   #No.FUN-8B0021   #FUN-8A0030 Add '' #MOD-940275 move ogg20   #CHI-9C0024 move ogg12 
      FROM ogg_file #FUN-C50097 ADD OGG13 ogg13,
     WHERE ogg01 = g_oga.oga01 AND ogg03 = g_ogb[l_ac].ogb03
     ORDER BY ogg20      #MOD-940275 add
 
   CALL l_ogg.clear()
 
   SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01=g_ogb[l_ac].ogb04 #MOD-940275
 
   LET i = 1
   FOREACH t6506_ogg_c INTO l_ogg[i].*
      IF STATUS THEN
         CALL cl_err('foreach ogg',STATUS,0)   
         EXIT FOREACH
      END IF
      IF l_ima906 = '1' THEN
         SELECT img10 INTO l_ogg[i].img10 FROM img_file
          WHERE img01=g_ogb[l_ac].ogb04 AND img02=l_ogg[i].ogg09
            AND img03=l_ogg[i].ogg091   AND img04=l_ogg[i].ogg092
      END IF
      IF l_ima906 = '2' THEN
         SELECT imgg10 INTO l_ogg[i].img10 FROM imgg_file
          WHERE imgg01=g_ogb[l_ac].ogb04 AND imgg02=l_ogg[i].ogg09
            AND imgg03=l_ogg[i].ogg091   AND imgg04=l_ogg[i].ogg092
            AND imgg09=l_ogg[i].ogg10
      END IF
      IF l_ima906 = '3' THEN
         IF l_ogg[i].ogg20 = '2' THEN
            SELECT imgg10 INTO l_ogg[i].img10 FROM imgg_file
             WHERE imgg01=g_ogb[l_ac].ogb04 AND imgg02=l_ogg[i].ogg09
               AND imgg03=l_ogg[i].ogg091   AND imgg04=l_ogg[i].ogg092
               AND imgg09=l_ogg[i].ogg10
         ELSE
            SELECT img10 INTO l_ogg[i].img10 FROM img_file
             WHERE img01=g_ogb[l_ac].ogb04 AND img02=l_ogg[i].ogg09
               AND img03=l_ogg[i].ogg091   AND img04=l_ogg[i].ogg092
         END IF
      END IF
      IF cl_null(l_ogg[i].img10) THEN LET l_ogg[i].img10 = 0 END IF
      LET i = i + 1
   END FOREACH
   CALL l_ogg.deleteElement(i)
   LET l_i=i-1
   DISPLAY l_i TO cn2
 
   SELECT SUM(ogg12),SUM(ogg16) INTO l_ogg12_t1,l_ogg16_t1 FROM ogg_file
    WHERE ogg01 = g_oga.oga01 AND ogg03 = g_ogb[l_ac].ogb03
      AND ogg20 = '1'
   SELECT SUM(ogg12),SUM(ogg16) INTO l_ogg12_t2,l_ogg16_t2 FROM ogg_file
    WHERE ogg01 = g_oga.oga01 AND ogg03 = g_ogb[l_ac].ogb03
      AND ogg20 = '2'
   DISPLAY l_ogg12_t1 TO ogg12t_1
   DISPLAY l_ogg16_t1 TO ogg16t_1
   DISPLAY l_ogg12_t2 TO ogg12t_2
   DISPLAY l_ogg16_t2 TO ogg16t_2
   DISPLAY g_ogb[l_ac].ogb912 TO ogb12t_1   #MOD-940275
   DISPLAY g_ogb[l_ac].ogb915 TO ogb12t_2   #MOD-940275
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY l_ogg WITHOUT DEFAULTS FROM s_ogg.*
         ATTRIBUTE(COUNT=l_i,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
     BEFORE INPUT
 
     BEFORE ROW
        LET i=ARR_CURR()
        LET l_pmd = ''
        IF l_i < i THEN       
           LET l_ogg[i].ogg20 = '1'
           LET l_ogg[i].ogg10 = g_ogb[l_ac].ogb910
           LET l_pmd = 'a'
           DISPLAY l_ogg[i].ogg10 TO ogg10
           DISPLAY l_ogg[i].ogg20 TO ogg20
        ELSE
           IF cl_null(l_ogg[i].ogg18) OR l_ogg[i].ogg18 = 0 THEN  
              SELECT MAX(ogg18)+1 INTO l_ogg[i].ogg18  
                FROM ogg_file
               WHERE ogg01 = g_oga.oga01
                 AND ogg03 = g_ogb[l_ac].ogb03
           END IF
           IF cl_null(l_ogg[i].ogg09) THEN
              LET l_ogg[i].ogg09 = g_ogb[l_ac].ogb09
           END IF
           IF cl_null(l_ogg[i].ogg091) THEN
              LET l_ogg[i].ogg091= g_ogb[l_ac].ogb091
           END IF
           IF cl_null(l_ogg[i].ogg092) THEN
              LET l_ogg[i].ogg092= g_ogb[l_ac].ogb092
           END IF
           NEXT FIELD ogg12
        END IF               #MOD-940275 add 
 
     #FUN-BA0019 --START--   
     BEFORE DELETE 
     #FUN-BA0019 --END--  
     
     AFTER INSERT 
       IF INT_FLAG THEN
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          CANCEL INSERT
       END IF
       LET l_i = l_i + 1 
 
     AFTER FIELD ogg20
        IF l_pmd = 'a' THEN 
           IF l_ogg[i].ogg20 = '2' THEN
              LET l_ogg[i].ogg10 = g_ogb[l_ac].ogb913
           ELSE
              LET l_ogg[i].ogg10 = g_ogb[l_ac].ogb910
           END IF
           DISPLAY l_ogg[i].ogg10 TO ogg10
   #FUN-910088--add--start--
           IF NOT cl_null(l_ogg[i].ogg12) THEN
              CALL t650_ogg12_check(l_ogg[i].*,i,j) RETURNING l_flag,l_bno
              IF NOT l_flag THEN
                 NEXT FIELD ogg092
              END IF
           END IF
   #FUN-910088--add--end--
        END IF

     #-----MOD-A20117---------
     AFTER FIELD ogg12
   #FUN-910088--add--start--
        CALL t650_ogg12_check(l_ogg[i].*,i,j) RETURNING l_flag,l_bno
        IF NOT l_flag THEN NEXT FIELD ogg092 END IF
  #FUN-910088--add--end--
  #FUN-910088--mark--start--
  #    LET g_ima918 = ''
  #    LET g_ima921 = ''
  #    SELECT ima918,ima921 INTO g_ima918,g_ima921
  #      FROM ima_file
  #     WHERE ima01 = g_ogb[l_ac].ogb04
  #       AND imaacti = "Y"
  # 
  #    IF (g_ima918 = "Y" OR g_ima921 = "Y") AND (l_ogg[i].ogg12<>0) THEN
  #       SELECT img09 INTO l_ogg[i].ogg15
  #         FROM img_file
  #        WHERE img01 = g_ogb[l_ac].ogb04
  #          AND img02 = l_ogg[i].ogg09
  #          AND img03 = l_ogg[i].ogg091
  #          AND img04 = l_ogg[i].ogg092
  # 
  #       DISPLAY l_ogg[i].ogg15 TO s_ogg[j].ogg15
  # 
  #       IF NOT cl_null(l_ogg[i].ogg15) THEN
  #          CALL s_umfchk(g_ogb[l_ac].ogb04,l_ogg[i].ogg10,l_ogg[i].ogg15)   #
  #              RETURNING g_cnt,l_ogg[i].ogg15_fac
  #          IF g_cnt=1 THEN
  #             CALL cl_err('','mfg3075',1)
  #             NEXT FIELD ogg092
  #          END IF
  #       END IF
  # 
  #       IF cl_null(l_ogg[i].ogg15_fac) THEN
  #          LET l_ogg[i].ogg15_fac = 1
  #       END IF
  # 
  #       #CHI-9A0022 --Begin
  #       IF cl_null(g_ogb[l_ac].ogb41) THEN
  #          LET l_bno = ''
  #       ELSE
  #          LET l_bno = g_ogb[l_ac].ogb41
  #       END IF
  #       #CHI-9A0022 --End
  #       CALL s_lotout(g_prog,g_oga.oga01,g_ogb[l_ac].ogb03,l_ogg[i].ogg18,
  #                     g_ogb[l_ac].ogb04,l_ogg[i].ogg09,
  #                     l_ogg[i].ogg091,l_ogg[i].ogg092,
  #                     l_ogg[i].ogg10,l_ogg[i].ogg15,l_ogg[i].ogg15_fac,
  #                     l_ogg[i].ogg12,l_bno,'MOD')#CHI-9A0022 add l_bno
  #           RETURNING l_r,g_qty
  #       IF l_r = "Y" THEN
  #          LET l_ogg[i].ogg12 = g_qty
  #       END IF
  #    END IF
  # #-----END MOD-A20117-----
  #FUN-910088--mark--end--

     AFTER FIELD ogg09
        IF NOT cl_null(l_ogg[i].ogg09) THEN
           LET g_cnt=0
           SELECT count(*) INTO g_cnt  FROM imd_file
            WHERE imd01=l_ogg[i].ogg09
               AND imdacti='Y'
           IF g_cnt=0 THEN
              CALL cl_err(l_ogg[i].ogg09,'axm-993',0)
              NEXT FIELD ogg09
           END IF
           #No.FUN-AA0062  --Begin
           IF NOT s_chk_ware(l_ogg[i].ogg09) THEN
              NEXT FIELD ogg09
           END IF
           #No.FUN-AA0062  --End
        END IF
 
     AFTER ROW
        IF l_ogg[i].ogg12 IS NOT NULL AND l_ogg[i].ogg12 != 0 THEN
           IF l_ogg[i].ogg09 IS NULL THEN LET l_ogg[i].ogg09 = ' ' END IF
           IF l_ogg[i].ogg091 IS NULL THEN LET l_ogg[i].ogg091 = ' ' END IF
           IF l_ogg[i].ogg092 IS NULL THEN LET l_ogg[i].ogg092 = ' ' END IF
           IF l_ima906 = '1' THEN
              SELECT img10,img09,img21
                INTO l_ogg[i].img10,l_ogg[i].ogg15,l_img21
                FROM img_file
               WHERE img01 = g_ogb[l_ac].ogb04 AND img02 = l_ogg[i].ogg09
                 AND img03 = l_ogg[i].ogg091   AND img04 = l_ogg[i].ogg092
              IF STATUS THEN
                #FUN-C80107 modify begin---------------------------------121024
                #CALL cl_err3("sel","img_file",g_ogb[l_ac].ogb04,"",STATUS,"","sel img",1)  #No.FUN-660167
                #NEXT FIELD ogg09
                 LET l_flag1 = NULL
                #CALL s_inv_shrt_by_warehouse(g_sma.sma894[2,2],l_ogg[i].ogg09) RETURNING l_flag1 #FUN-D30024 mark
                 CALL s_inv_shrt_by_warehouse(l_ogg[i].ogg09,g_plant) RETURNING l_flag1                   #FUN-D30024 add #TQC-D40078 g_plant
                 IF l_flag1 = 'N' OR l_flag1 IS NULL THEN
                    CALL cl_err3("sel","img_file",g_ogb[l_ac].ogb04,"",STATUS,"","sel img",1)
                    NEXT FIELD ogg09
                 ELSE
                    IF g_sma.sma892[3,3] = 'Y' THEN
                       IF NOT cl_confirm('mfg1401') THEN NEXT FIELD ogg09 END IF
                    END IF
                    CALL s_add_img(g_ogb[l_ac].ogb04,l_ogg[i].ogg09,
                                   l_ogg[i].ogg091,l_ogg[i].ogg092,
                                   g_oga.oga01,g_ogb[l_ac].ogb03,g_oga.oga02)
                    IF g_errno='N' THEN
                       NEXT FIELD ogg09
                    END IF
                 END IF
                #FUN-C80107 modify end-----------------------------------
              END IF
              CALL s_umfchk(g_ogb[l_ac].ogb04,l_ogg[i].ogg10,l_ogg[i].ogg15)
                            RETURNING g_cnt,l_ogg[i].ogg15_fac
              IF g_cnt=1 THEN 
                 CALL cl_err('','mfg3075',1) 
                #TQC-C50131 -- add -- begin
                 CALL cl_getmsg('asf-176',g_lang) RETURNING l_msg3
                 LET l_msg3 = l_msg3 CLIPPED,"(",g_ogb[l_ac].ogb04,")"
                 CALL cl_msgany(10,20,l_msg3)
                #TQC-C50131 -- add -- end
                 NEXT FIELD ogg092 
              END IF
              IF cl_null(l_ogg[i].ogg15_fac) THEN LET l_ogg[i].ogg15_fac=1 END IF
           END IF
           IF l_ima906 = '2' THEN
              SELECT imgg10,imgg09,imgg21
                INTO l_ogg[i].img10,l_ogg[i].ogg15,l_img21
                FROM imgg_file
               WHERE imgg01 = g_ogb[l_ac].ogb04 AND imgg02 = l_ogg[i].ogg09
                 AND imgg03 = l_ogg[i].ogg091   AND imgg04 = l_ogg[i].ogg092
                 AND imgg09 = l_ogg[i].ogg10
              IF STATUS THEN
                 #FUN-C80107 modify begin-----------------------------------121024
                 #CALL cl_err3("sel","imgg_file",g_ogb[l_ac].ogb04,"",STATUS,"","sel imgg",1)  #No.FUN-660167
                 #NEXT FIELD ogg09
                 LET l_flag1 = NULL
                #CALL s_inv_shrt_by_warehouse(g_sma.sma894[2,2],l_ogg[i].ogg09) RETURNING l_flag1 #FUN-D30024 mark
                 CALL s_inv_shrt_by_warehouse(l_ogg[i].ogg09,g_plant) RETURNING l_flag1                   #FUN-D30024 add  #TQC-D40078 g_plant
                 IF l_flag1 = 'N' OR l_flag1 IS NULL THEN
                    CALL cl_err3("sel","imgg_file",g_ogb[l_ac].ogb04,"",STATUS,"","sel imgg",1)
                    NEXT FIELD ogg09
                 ELSE
                    IF g_sma.sma892[3,3] = 'Y' THEN
                        IF NOT cl_confirm('aim-995') THEN
                            NEXT FIELD ogg09
                        END IF
                    END IF
                    CALL s_add_imgg(g_ogb[l_ac].ogb04,l_ogg[i].ogg09,
                                    l_ogg[i].ogg091,l_ogg[i].ogg092,
                                    l_ogg[i].ogg10,l_ogg[i].ogg15_fac,
                                    g_oga.oga01,
                                    g_ogb[l_ac].ogb03,0) RETURNING g_flag
                    IF g_flag = 1 THEN
                        NEXT FIELD ogg09
                    END IF
                 END IF
                #FUN-C80107 modify end-----------------------------------
              END IF
              LET l_ogg[i].ogg15_fac = 1
           END IF
           IF l_ima906 = '3' THEN
              #IF l_ogg[i].ogg20 = '1' THEN #FUN-C80107 mark
                 SELECT img10,img09,img21
                   INTO l_ogg[i].img10,l_ogg[i].ogg15,l_img21
                   FROM img_file
                  WHERE img01 = g_ogb[l_ac].ogb04 AND img02 = l_ogg[i].ogg09
                    AND img03 = l_ogg[i].ogg091   AND img04 = l_ogg[i].ogg092
                 IF STATUS THEN
                   #FUN-C80107 modify begin---------------------------------121024
                   #CALL cl_err3("sel","img_file",g_ogb[l_ac].ogb04,"",STATUS,"","sel img",1)  #No.FUN-660167
                   #NEXT FIELD ogg09
                    LET l_flag = NULL   
                   #CALL s_inv_shrt_by_warehouse(g_sma.sma894[2,2],l_ogg[i].ogg09) RETURNING l_flag #FUN-D30024 mark
                    CALL s_inv_shrt_by_warehouse(l_ogg[i].ogg09,g_plant) RETURNING l_flag                   #FUN-D30024 add #TQC-D40078 g_plant
                    IF l_flag = 'N' OR l_flag IS NULL THEN
                       CALL cl_err3("sel","img_file",g_ogb[l_ac].ogb04,"",STATUS,"","sel img",1)
                       NEXT FIELD ogg09
                    ELSE
                       IF g_sma.sma892[3,3] = 'Y' THEN
                          IF NOT cl_confirm('mfg1401') THEN NEXT FIELD ogg09 END IF
                       END IF
                       CALL s_add_img(g_ogb[l_ac].ogb04,l_ogg[i].ogg09,
                                      l_ogg[i].ogg091,l_ogg[i].ogg092,
                                      g_oga.oga01,g_ogb[l_ac].ogb03,g_oga.oga02)
                       IF g_errno='N' THEN
                          NEXT FIELD ogg09
                       END IF
                    END IF
                   #FUN-C80107 modify end-----------------------------------
                 END IF
                 CALL s_umfchk(g_ogb[l_ac].ogb04,l_ogg[i].ogg10,l_ogg[i].ogg15)
                               RETURNING g_cnt,l_ogg[i].ogg15_fac
                 IF g_cnt=1 THEN 
                    CALL cl_err('','mfg3075',1) 
                   #TQC-C50131 -- add -- begin
                    CALL cl_getmsg('asf-176',g_lang) RETURNING l_msg3
                    LET l_msg3 = l_msg3 CLIPPED,"(",g_ogb[l_ac].ogb04,")"
                    CALL cl_msgany(10,20,l_msg3)
                   #TQC-C50131 -- add -- end
                    NEXT FIELD ogg092 
                 END IF
                 IF cl_null(l_ogg[i].ogg15_fac) THEN LET l_ogg[i].ogg15_fac=1 END IF
              #END IF   #FUN-C80107 mark
              IF l_ogg[i].ogg20 = '2' THEN
                 SELECT imgg10,imgg09,imgg21
                   INTO l_ogg[i].img10,l_ogg[i].ogg15,l_img21
                   FROM imgg_file
                  WHERE imgg01 = g_ogb[l_ac].ogb04 AND imgg02 = l_ogg[i].ogg09
                    AND imgg03 = l_ogg[i].ogg091   AND imgg04 = l_ogg[i].ogg092
                    AND imgg09 = l_ogg[i].ogg10
                 IF STATUS THEN
                    #FUN-C80107 modify begin-----------------------------------121024
                    #CALL cl_err3("sel","imgg_file",g_ogb[l_ac].ogb04,"",STATUS,"","sel imgg",1)  #No.FUN-660167
                    #NEXT FIELD ogg09
                    LET l_flag = NULL
                   #CALL s_inv_shrt_by_warehouse(g_sma.sma894[2,2],l_ogg[i].ogg09) RETURNING l_flag #FUN-D30024 mark
                    CALL s_inv_shrt_by_warehouse(l_ogg[i].ogg09,g_plant) RETURNING l_flag                   #FUN-D30024 add #TQC-D40078 g_plant
                    IF l_flag = 'N' OR l_flag IS NULL THEN
                        CALL cl_err3("sel","imgg_file",g_ogb[l_ac].ogb04,"",STATUS,"","sel imgg",1)
                        NEXT FIELD ogg09
                    ELSE
                        IF g_sma.sma892[3,3] = 'Y' THEN
                            IF NOT cl_confirm('aim-995') THEN
                                NEXT FIELD ogg09
                            END IF
                        END IF
                        CALL s_add_imgg(g_ogb[l_ac].ogb04,l_ogg[i].ogg09,
                                        l_ogg[i].ogg091,l_ogg[i].ogg092,
                                        l_ogg[i].ogg10,l_ogg[i].ogg15_fac,
                                        g_oga.oga01,
                                        g_ogb[l_ac].ogb03,0) RETURNING g_flag
                        IF g_flag = 1 THEN
                            NEXT FIELD ogg09
                        END IF
                    END IF
                    #FUN-C80107 modify end-----------------------------------
                 END IF
                 LET l_ogg[i].ogg15_fac = 1
              END IF
           END IF
           DISPLAY l_ogg[i].img10 TO img10
           DISPLAY l_ogg[i].ogg15 TO ogg15
           LET l_ogg[i].ogg16 = l_ogg[i].ogg12 * l_ogg[i].ogg15_fac
           LET l_ogg[i].ogg16 = s_digqty(l_ogg[i].ogg16,l_ogg[i].ogg15)   #FUN-910088--add--
           DISPLAY l_ogg[i].ogg16 TO s_ogg[j].ogg16
        END IF
 
        IF l_ogg[i].ogg12 IS NOT NULL AND l_ogg[i].ogg12 <> 0 THEN
           FOR k = 1 TO l_ogg.getLength()
              IF k=i THEN CONTINUE FOR END IF
              IF l_ogg[k].ogg09 = l_ogg[i].ogg09  AND
                 l_ogg[k].ogg091= l_ogg[i].ogg091 AND
                 l_ogg[k].ogg092= l_ogg[i].ogg092 AND
                 l_ogg[k].ogg20 = l_ogg[i].ogg20  AND
                 (l_ima906='1' OR l_ima906='3' AND l_ogg[i].ogg20=1) THEN
                 INITIALIZE l_ogg[i].* TO NULL
                 DISPLAY l_ogg[i].* TO s_ogg[j].*
                 CALL cl_err('',-239,0)
                 EXIT FOR
              END IF
              IF l_ogg[k].ogg09 = l_ogg[i].ogg09  AND
                 l_ogg[k].ogg091= l_ogg[i].ogg091 AND
                 l_ogg[k].ogg092= l_ogg[i].ogg092 AND
                 l_ogg[k].ogg10 = l_ogg[i].ogg10  AND
                 (l_ima906='2' OR l_ima906='3' AND l_ogg[i].ogg20=2) THEN
                 INITIALIZE l_ogg[i].* TO NULL
                 DISPLAY l_ogg[i].* TO s_ogg[j].*
                 CALL cl_err('',-239,0)
                 EXIT FOR
              END IF
           END FOR
        END IF
 
        LET l_ogg12_t1 = 0
        LET l_ogg16_t1 = 0
        LET l_ogg12_t2 = 0
        LET l_ogg16_t2 = 0

        FOR k = 1 TO l_ogg.getLength()
           IF l_ogg[k].ogg12 IS NOT NULL AND l_ogg[k].ogg12 <> 0 THEN
              IF l_ogg[k].ogg20 = '1' THEN
                 LET l_ogg12_t1 = l_ogg12_t1 + l_ogg[k].ogg12
                 LET l_ogg16_t1 = l_ogg16_t1 + l_ogg[k].ogg16
              END IF
              IF l_ogg[k].ogg20 = '2' THEN
                 LET l_ogg12_t2 = l_ogg12_t2 + l_ogg[k].ogg12
                 LET l_ogg16_t2 = l_ogg16_t2 + l_ogg[k].ogg16
              END IF
           END IF
        END FOR
        DISPLAY l_ogg12_t1 TO ogg12t_1
        DISPLAY l_ogg16_t1 TO ogg16t_1
        DISPLAY l_ogg12_t2 TO ogg12t_2
        DISPLAY l_ogg16_t2 TO ogg16t_2
 
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           EXIT INPUT
        END IF
 
     AFTER INPUT
        IF l_ogg12_t1 != g_ogb[l_ac].ogb912 OR l_ogg12_t2 != g_ogb[l_ac].ogb915 THEN
           IF cl_confirm('axm-170') THEN
              EXIT INPUT
           ELSE
              NEXT FIELD ogg09
           END IF
        END IF

      #-----MOD-A20117---------
      ON ACTION modi_lot        
         LET g_ima918 = ''   
         LET g_ima921 = ''   
         SELECT ima918,ima921 INTO g_ima918,g_ima921
           FROM ima_file
          WHERE ima01 = g_ogb[l_ac].ogb04
            AND imaacti = "Y"
      
         IF (g_ima918 = "Y" OR g_ima921 = "Y") AND (l_ogg[i].ogg12<>0) THEN
            SELECT img09 INTO l_ogg[i].ogg15
              FROM img_file
             WHERE img01 = g_ogb[l_ac].ogb04
               AND img02 = l_ogg[i].ogg09
               AND img03 = l_ogg[i].ogg091
               AND img04 = l_ogg[i].ogg092
            
            LET l_ogg[i].ogg16 = s_digqty(l_ogg[i].ogg16,l_ogg[i].ogg15)   #FUN-910088--add--
            DISPLAY l_ogg[i].ogg15 TO s_ogg[j].ogg15
      
            IF NOT cl_null(l_ogg[i].ogg15) THEN 
               CALL s_umfchk(g_ogb[l_ac].ogb04,l_ogg[i].ogg10,l_ogg[i].ogg15) 
                   RETURNING g_cnt,l_ogg[i].ogg15_fac
               IF g_cnt=1 THEN
                  CALL cl_err('','mfg3075',1)
                 #TQC-C50131 -- add -- begin
                  CALL cl_getmsg('asf-176',g_lang) RETURNING l_msg3
                  LET l_msg3 = l_msg3 CLIPPED,"(",g_ogb[l_ac].ogb04,")"
                  CALL cl_msgany(10,20,l_msg3)
                 #TQC-C50131 -- add -- end
                  NEXT FIELD ogg092 
               END IF
            END IF
      
            IF cl_null(l_ogg[i].ogg15_fac) THEN
               LET l_ogg[i].ogg15_fac = 1
            END IF
      
            #CHI-9A0022 --Begin
            IF cl_null(g_ogb[l_ac].ogb41) THEN
               LET l_bno = ''
            ELSE
               LET l_bno = g_ogb[l_ac].ogb41
            END IF
            #CHI-9A0022 --End
           #CALL s_lotout(g_prog,g_oga.oga01,g_ogb[l_ac].ogb03,l_ogg[i].ogg18,     #TQC-B90236 mark
            CALL s_mod_lot(g_prog,g_oga.oga01,g_ogb[l_ac].ogb03,l_ogg[i].ogg18,     #TQC-B90236 add
                          g_ogb[l_ac].ogb04,l_ogg[i].ogg09,
                          l_ogg[i].ogg091,l_ogg[i].ogg092,
                          l_ogg[i].ogg10,l_ogg[i].ogg15,l_ogg[i].ogg15_fac, 
                          l_ogg[i].ogg12,l_bno,'MOD',-1)#CHI-9A0022 add l_bno       #TQC-B90236 add '-1'
                RETURNING l_r,g_qty
            IF l_r = "Y" THEN
               LET l_ogg[i].ogg12 = g_qty
               LET l_ogg[i].ogg12 = s_digqty(l_ogg[i].ogg12,l_ogg[i].ogg10)   #FUN-910088--add--
            END IF
         END IF
      #-----END MOD-A20117-----
     
     
      ON ACTION controlp                                                                                                            
            CASE                                                                                                                    
                WHEN INFIELD(ogg09) 
                   #FUN-C30300---begin
                   LET g_ima906 = NULL
                   SELECT ima906 INTO g_ima906 FROM ima_file
                    WHERE ima01 = g_ogb[l_ac].ogb04
                   #IF s_industry("icd") AND g_ima906='3' THEN  #TQC-C60028
                   IF s_industry("icd") THEN  #TQC-C60028
                      CALL q_idc(FALSE,TRUE,g_ogb[l_ac].ogb04,l_ogg[i].ogg09,l_ogg[i].ogg091,l_ogg[i].ogg092)
                      RETURNING l_ogg[i].ogg09,l_ogg[i].ogg091,l_ogg[i].ogg092
                   ELSE
                   #FUN-C30300---end 
                      #No.FUN-AA0062  --Begin                                                                                               
                      #CALL q_img4(FALSE,FALSE,g_ogb[l_ac].ogb04,' ',' ',' ','A')    
                      CALL q_img4(FALSE,TRUE,g_ogb[l_ac].ogb04,l_ogg[i].ogg09,l_ogg[i].ogg091,l_ogg[i].ogg092,'A')                                                   
                               RETURNING l_ogg[i].ogg09,l_ogg[i].ogg091,                                                               
                                         l_ogg[i].ogg092  
                   END IF  #FUN-C30300
                   IF INT_FLAG THEN
                     LET INT_FLAG = 0
                   END IF   
                    #No.FUN-AA0062  --End                                                                                     
                   DISPLAY BY NAME l_ogg[i].ogg09,l_ogg[i].ogg091,l_ogg[i].ogg092                                                 
                   NEXT FIELD ogg09 
#No.FUN-AA0062  --Begin  
                WHEN INFIELD(ogg091)                                                                                                
#                     CALL cl_init_qry_var()                                                                                         
#                     LET g_qryparam.form = "q_ime"                                                                                  
#                     LET g_qryparam.default1 = l_ogg[i].ogg091                                                                      
#                     LET g_qryparam.arg1     = l_ogg[i].ogg09 #倉庫編號                                                             
#                     LET g_qryparam.arg2     = 'SW'           #倉庫類別                                                             
#                     CALL cl_create_qry() RETURNING l_ogg[i].ogg091                                                                 
#                     DISPLAY BY NAME l_ogg[i].ogg091                                                                                
#                     NEXT FIELD ogg091                                                                                              
                                      #FUN-C30300---begin
                   LET g_ima906 = NULL
                   SELECT ima906 INTO g_ima906 FROM ima_file
                    WHERE ima01 = g_ogb[l_ac].ogb04
                   #IF s_industry("icd") AND g_ima906='3' THEN  #TQC-C60028
                   IF s_industry("icd") THEN  #TQC-C60028
                      CALL q_idc(FALSE,TRUE,g_ogb[l_ac].ogb04,l_ogg[i].ogg09,l_ogg[i].ogg091,l_ogg[i].ogg092)
                      RETURNING l_ogg[i].ogg09,l_ogg[i].ogg091,l_ogg[i].ogg092
                   ELSE
                   #FUN-C30300---end
                      CALL q_img4(FALSE,TRUE,g_ogb[l_ac].ogb04,l_ogg[i].ogg09,l_ogg[i].ogg091,l_ogg[i].ogg092,'A')                                                   
                               RETURNING l_ogg[i].ogg09,l_ogg[i].ogg091,                                                               
                                         l_ogg[i].ogg092 
                   END IF  #FUN-C30300
                      IF INT_FLAG THEN
                        LET INT_FLAG = 0
                      END IF   
                      DISPLAY BY NAME l_ogg[l_ac].ogg09
                      DISPLAY BY NAME l_ogg[l_ac].ogg091
                      DISPLAY BY NAME l_ogg[l_ac].ogg092
                      NEXT FIELD ogg091
                   
                WHEN INFIELD(ogg092)
                   #FUN-C30300---begin
                   LET g_ima906 = NULL
                   SELECT ima906 INTO g_ima906 FROM ima_file
                    WHERE ima01 = g_ogb[l_ac].ogb04
                   #IF s_industry("icd") AND g_ima906='3' THEN  #TQC-C60028
                   IF s_industry("icd") THEN  #TQC-C60028
                      CALL q_idc(FALSE,TRUE,g_ogb[l_ac].ogb04,l_ogg[i].ogg09,l_ogg[i].ogg091,l_ogg[i].ogg092)
                      RETURNING l_ogg[i].ogg09,l_ogg[i].ogg091,l_ogg[i].ogg092
                   ELSE
                   #FUN-C30300---end
                      CALL q_img4(FALSE,TRUE,g_ogb[l_ac].ogb04,l_ogg[i].ogg09,l_ogg[i].ogg091,l_ogg[i].ogg092,'A')                                                   
                               RETURNING l_ogg[i].ogg09,l_ogg[i].ogg091,                                                               
                                         l_ogg[i].ogg092  
                   END IF   #FUN-C30300  
                   IF INT_FLAG THEN
                     LET INT_FLAG = 0
                   END IF   
                   DISPLAY BY NAME l_ogg[l_ac].ogg09
                   DISPLAY BY NAME l_ogg[l_ac].ogg091
                   DISPLAY BY NAME l_ogg[l_ac].ogg092
                   NEXT FIELD ogg092
 #No.FUN-AA0062  --End                                                                                                              
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
      CALL cl_err('',9001,0)
      LET INT_FLAG = 0
      CLOSE WINDOW t6506_w
      RETURN
   END IF
 
   CLOSE WINDOW t6506_w
 
   LET g_success ='Y'
 
   BEGIN WORK
 
   DELETE FROM ogg_file
    WHERE ogg01 = g_oga.oga01
      AND ogg03 = g_ogb[l_ac].ogb03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("del","ogg_file",g_oga.oga01,g_ogb[l_ac].ogb03,SQLCA.sqlcode,"","del_ogg",1)  #No.FUN-660167
      ROLLBACK WORK RETURN
   END IF
   DELETE FROM ogc_file
    WHERE ogc01 = g_oga.oga01
      AND ogc03 = g_ogb[l_ac].ogb03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("del","ogc_file",g_oga.oga01,g_ogb[l_ac].ogb03,SQLCA.sqlcode,"","del_ogc",1)  #No.FUN-660167
      ROLLBACK WORK RETURN
   END IF
   FOR i = 1 TO l_ogg.getLength()
       IF l_ogg[i].ogg12 IS NULL OR l_ogg[i].ogg12=0 THEN 
          #-----MOD-A20117---------
         #IF s_lotout_del(g_prog,g_oga.oga01,g_ogb[l_ac].ogb03,l_ogg[i].ogg18,g_ogb[l_ac].ogb04,'DEL') THEN  #TQC-B90236
          IF s_lot_del(g_prog,g_oga.oga01,g_ogb[l_ac].ogb03,l_ogg[i].ogg18,g_ogb[l_ac].ogb04,'DEL') THEN  #TQC-B90236
             CONTINUE FOR
          END IF
          #-----END MOD-A20117-----
       END IF
       INSERT INTO ogg_file(ogg01,ogg03,ogg09,ogg091,ogg092,ogg10,
                            ogg12,ogg15,ogg15_fac,ogg16,ogg20,ogg18,oggplant,ogglegal,ogg13)   #MOD-910173 增加ogg18 #FUN-980010 add oggplant,ogglegal ,ogg13
                     VALUES(g_oga.oga01,g_ogb[l_ac].ogb03,
	      	            l_ogg[i].ogg09, l_ogg[i].ogg091,
                            l_ogg[i].ogg092,l_ogg[i].ogg10,
                            l_ogg[i].ogg12, l_ogg[i].ogg15,
                            l_ogg[i].ogg15_fac,l_ogg[i].ogg16,  #add ogg13 FUN-C50097 ,l_ogg[i].ogg13
                            l_ogg[i].ogg20,l_ogg[i].ogg18,g_plant,g_legal,l_ogg[i].ogg13)   #MOD-910173 #FUN-980010 add g_plant,g_legal
       IF SQLCA.sqlcode THEN
          CALL cl_err3("ins","ogg_file",g_oga.oga01,g_ogb[l_ac].ogb03,SQLCA.sqlcode,"","INS-ogg",1)  #No.FUN-660167
          LET g_success = 'N' EXIT FOR
       END IF
       INITIALIZE r_ogc.* TO NULL
       LET r_ogc.ogc01 =g_oga.oga01
       LET r_ogc.ogc03 =g_ogb[l_ac].ogb03
       LET r_ogc.ogc09 =l_ogg[i].ogg09
       LET r_ogc.ogc091=l_ogg[i].ogg091
       LET r_ogc.ogc092=l_ogg[i].ogg092
       LET r_ogc.ogc18 =l_ogg[i].ogg18   #MOD-910173
       LET r_ogc.ogc13 = 0   #FUN-C50097
       SELECT img09 INTO l_img09 FROM img_file
        WHERE img01=g_ogb[l_ac].ogb04
          AND img02=r_ogc.ogc09
          AND img03=r_ogc.ogc091
          AND img04=r_ogc.ogc092
       IF l_ima906 = '1' THEN
          LET g_factor = 1
          LET r_ogc.ogc12=l_ogg[i].ogg12#*g_factor
          LET r_ogc.ogc12 = s_digqty(r_ogc.ogc12,g_ogb[l_ac].ogb05)   #FUN-910088--add--
          LET r_ogc.ogc15=l_img09
          LET r_ogc.ogc15_fac=l_ogg[i].ogg15_fac
          LET r_ogc.ogc16=r_ogc.ogc12*r_ogc.ogc15_fac
          LET r_ogc.ogc16 = s_digqty(r_ogc.ogc16,r_ogc.ogc15)   #FUN-910088--add--
          LET r_ogc.ogc17=g_ogb[l_ac].ogb04   #FUN-BA0019
           IF cl_null(r_ogc.ogc01) THEN LET r_ogc.ogc01=' ' END IF
           IF cl_null(r_ogc.ogc03) THEN LET r_ogc.ogc03=0 END IF
           IF cl_null(r_ogc.ogc09) THEN LET r_ogc.ogc09=' ' END IF
           IF cl_null(r_ogc.ogc091) THEN LET r_ogc.ogc091=' ' END IF
           IF cl_null(r_ogc.ogc092) THEN LET r_ogc.ogc092=' ' END IF
           IF cl_null(r_ogc.ogc17) THEN LET r_ogc.ogc17=' ' END IF
          LET r_ogc.ogc18 = l_ogg[i].ogg18   #MOD-910173
          LET r_ogc.ogcplant = g_plant #FUN-980010 add
          LET r_ogc.ogclegal = g_legal #FUN-980010 add
          INSERT INTO ogc_file VALUES(r_ogc.*)
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","ogc_file",r_ogc.ogc01,"",SQLCA.sqlcode,"","insert ogc",1)  #No.FUN-660167
             LET g_success = 'N' EXIT FOR
          END IF
       END IF
       IF l_ima906 = '2' THEN
          LET g_factor = 1
          CALL s_umfchk(g_ogb[l_ac].ogb04,l_ogg[i].ogg10,g_ogb[l_ac].ogb05)
                        RETURNING g_cnt,g_factor
          IF g_cnt=1 THEN LET g_factor = 1 END IF
          LET r_ogc.ogc12=l_ogg[i].ogg12*g_factor
          LET r_ogc.ogc12 = s_digqty(r_ogc.ogc12,g_ogb[l_ac].ogb05)     #FUN-910088--add--
          LET g_factor = 1
          CALL s_umfchk(g_ogb[l_ac].ogb04,l_ogg[i].ogg10,l_img09)
                        RETURNING g_cnt,g_factor
          IF g_cnt=1 THEN LET g_factor = 1 END IF
          LET r_ogc.ogc15=l_img09
          LET r_ogc.ogc15_fac = 1
          LET r_ogc.ogc16=l_ogg[i].ogg12*g_factor
          LET r_ogc.ogc16 = s_digqty(r_ogc.ogc16,r_ogc.ogc15)   #FUN-910088--add--
          LET r_ogc.ogc17=g_ogb[l_ac].ogb04   #FUN-BA0019
           IF cl_null(r_ogc.ogc01) THEN LET r_ogc.ogc01=' ' END IF
           IF cl_null(r_ogc.ogc03) THEN LET r_ogc.ogc03=0 END IF
           IF cl_null(r_ogc.ogc09) THEN LET r_ogc.ogc09=' ' END IF
           IF cl_null(r_ogc.ogc091) THEN LET r_ogc.ogc091=' ' END IF
           IF cl_null(r_ogc.ogc092) THEN LET r_ogc.ogc092=' ' END IF
           IF cl_null(r_ogc.ogc17) THEN LET r_ogc.ogc17=' ' END IF
          LET r_ogc.ogc18 = l_ogg[i].ogg18   #MOD-910173
          LET r_ogc.ogcplant = g_plant #FUN-980010 add
          LET r_ogc.ogclegal = g_legal #FUN-980010 add
          INSERT INTO ogc_file VALUES(r_ogc.*)
          IF SQLCA.sqlcode THEN
             IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
                UPDATE ogc_file SET ogc12=ogc12+r_ogc.ogc12,
                                    ogc16=ogc16+r_ogc.ogc16
                 WHERE ogc01 =g_oga.oga01
                   AND ogc03 =g_ogb[l_ac].ogb03
                   AND ogc09 =l_ogg[i].ogg09
                   AND ogc091=l_ogg[i].ogg091
                   AND ogc092=l_ogg[i].ogg092
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","ogc_file",g_oga.oga01,g_ogb[l_ac].ogb03,SQLCA.sqlcode,"","update ogc",1)  #No.FUN-660167
                   LET g_success = 'N' EXIT FOR
                END IF
             ELSE
                CALL cl_err('insert ogc',SQLCA.sqlcode,0)
                LET g_success = 'N' EXIT FOR
             END IF
          END IF
       END IF
       IF l_ima906 = '3' THEN
          IF l_ogg[i].ogg20 = '1' THEN
             LET g_factor = 1
             LET r_ogc.ogc12=l_ogg[i].ogg12#*g_factor
             LET r_ogc.ogc12 = s_digqty(r_ogc.ogc12,g_ogb[l_ac].ogb05)   #FUN-910088--add--
             LET r_ogc.ogc15=l_img09
             LET r_ogc.ogc15_fac=l_ogg[i].ogg15_fac
             LET r_ogc.ogc16=r_ogc.ogc12*r_ogc.ogc15_fac
             LET r_ogc.ogc16 = s_digqty(r_ogc.ogc16,r_ogc.ogc15)   #FUN-910088--add--
             LET r_ogc.ogc17=g_ogb[l_ac].ogb04   #FUN-BA0019
           IF cl_null(r_ogc.ogc01) THEN LET r_ogc.ogc01=' ' END IF
           IF cl_null(r_ogc.ogc03) THEN LET r_ogc.ogc03=0 END IF
           IF cl_null(r_ogc.ogc09) THEN LET r_ogc.ogc09=' ' END IF
           IF cl_null(r_ogc.ogc091) THEN LET r_ogc.ogc091=' ' END IF
           IF cl_null(r_ogc.ogc092) THEN LET r_ogc.ogc092=' ' END IF
           IF cl_null(r_ogc.ogc17) THEN LET r_ogc.ogc17=' ' END IF
          LET r_ogc.ogc18 = l_ogg[i].ogg18   #MOD-910173
          LET r_ogc.ogcplant = g_plant #FUN-980010 add
          LET r_ogc.ogclegal = g_legal #FUN-980010 add
             INSERT INTO ogc_file VALUES(r_ogc.*)
             IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","ogc_file",r_ogc.ogc01,"",SQLCA.sqlcode,"","insert ogc",1)  #No.FUN-660167
                LET g_success = 'N' EXIT FOR
             END IF
          END IF
       END IF
    END FOR
 
    IF g_success='Y' THEN
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
 
END FUNCTION
 
FUNCTION t650_mlog(p_cmd)			# Transaction Modify Log (存入 oem_file)
 DEFINE p_cmd      LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
 DEFINE l_oem05    LIKE type_file.chr8    #No.FUN-680137 VARCHAR(8)
 DEFINE l_oem      RECORD LIKE oem_file.*
 
   IF g_oga.oga06 IS NULL THEN RETURN END IF
   INITIALIZE l_oem.* TO NULL
   LET l_oem.oem01=g_oga.oga01
   LET l_oem.oem03=b_ogb.ogb03
   LET l_oem.oem04=g_today
   LET l_oem05 = TIME
   LET l_oem.oem05=l_oem05
   LET l_oem.oem06=g_user
   LET l_oem.oem07=p_cmd
   LET l_oem.oem08=g_oga.oga06
   LET l_oem.oemplant = g_plant #FUN-980010 add
   LET l_oem.oemlegal = g_legal #FUN-980010 add
   IF p_cmd='A' THEN
      LET l_oem.oem10o=NULL LET l_oem.oem11o=NULL
      LET l_oem.oem12o=NULL LET l_oem.oem13o=NULL LET l_oem.oem15o=NULL
      LET l_oem.oem12n=b_ogb.ogb12
   END IF
   IF p_cmd='R' THEN
      LET l_oem.oem10o=g_ogb_t.ogb04
      LET l_oem.oem11o=g_ogb_t.ogb092
      LET l_oem.oem12o=g_ogb_t.ogb12
      LET l_oem.oem10n=NULL LET l_oem.oem11n=NULL
      LET l_oem.oem12n=NULL LET l_oem.oem13n=NULL LET l_oem.oem15n=NULL
   END IF
   IF p_cmd='U' THEN
      IF g_ogb_t.ogb04 != b_ogb.ogb04 THEN
         LET l_oem.oem10o=g_ogb_t.ogb04 LET l_oem.oem10n=b_ogb.ogb04
      END IF
      IF g_ogb_t.ogb092 != b_ogb.ogb092 THEN
         LET l_oem.oem11o=g_ogb_t.ogb092 LET l_oem.oem11n=b_ogb.ogb092
      END IF
      IF g_ogb_t.ogb12 != b_ogb.ogb12 THEN
         LET l_oem.oem12o=g_ogb_t.ogb12 LET l_oem.oem12n=b_ogb.ogb12
      END IF
      IF cl_null(l_oem.oem10n) AND cl_null(l_oem.oem11n) AND
         cl_null(l_oem.oem12n) AND cl_null(l_oem.oem13n) AND
         cl_null(l_oem.oem15n) THEN RETURN
      END IF
      IF l_oem.oem12n=0 THEN LET l_oem.oem12n=NULL END IF
      IF l_oem.oem13n=0 THEN LET l_oem.oem13n=NULL END IF
   END IF
   INSERT INTO oem_file VALUES (l_oem.*)
END FUNCTION
 
FUNCTION t650_bu()
   DEFINE l_oea61   LIKE oea_file.oea61    #No:FUN-A50103
   DEFINE l_oea1008 LIKE oea_file.oea1008  #No:FUN-A50103
   DEFINE l_oea261  LIKE oea_file.oea261   #No:FUN-A50103
   DEFINE l_oea262  LIKE oea_file.oea262   #No:FUN-A50103
   DEFINE l_oea263  LIKE oea_file.oea263   #No:FUN-A50103
 
   LET g_oga.oga50 = NULL
   SELECT SUM(ogb14) INTO g_oga.oga50 FROM ogb_file WHERE ogb01 = g_oga.oga01
   IF cl_null(g_oga.oga50) THEN LET g_oga.oga50 = 0 END IF
 
   DISPLAY BY NAME g_oga.oga50

#FUN-A60035 ---begin  #還原FUN-A50103修改 
#  #-----No:FUN-A50103-----
#  SELECT oea61,oea1008,oea261,oea262,oea263
#    INTO l_oea61,l_oea1008,l_oea261,l_oea262,l_oea263
#    FROM oea_file
#   WHERE oea01 = g_oga.oga16
#  IF g_oga.oga213 = 'Y' THEN
#     LET g_oga.oga52 = g_oga.oga50 * l_oea261 / l_oea1008
#     LET g_oga.oga53 = g_oga.oga50 * (l_oea262+l_oea263) / l_oea1008
#  ELSE
#     LET g_oga.oga52 = g_oga.oga50 * l_oea261 / l_oea61
#     LET g_oga.oga53 = g_oga.oga50 * (l_oea262+l_oea263) / l_oea61
#  END IF

  LET g_oga.oga52 = g_oga.oga50 * g_oga.oga161/100
  LET g_oga.oga53 = g_oga.oga50 * (g_oga.oga162+g_oga.oga163)/100
#   #-----No:FUN-A50103 END-----
#FUN-A60035 ---end   #還原FUN-A50103修改

   UPDATE oga_file SET oga50=g_oga.oga50,
                       oga52=g_oga.oga52,
                       oga53=g_oga.oga53
    WHERE oga01 = g_oga.oga01
   IF SQLCA.sqlcode OR SQLCA.SQLerrd[3] = 0 THEN
      CALL cl_err3("upd","oga_file",g_oga.oga01,"",SQLCA.SQLCODE,"","_bu()upd oga",1)  #No.FUN-660167
   END IF
 
END FUNCTION
 
FUNCTION t650_delall()
    IF g_cnt = 0 THEN 			# 未輸入單身資料, 則取消單頭資料
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED
       DELETE FROM oga_file WHERE oga01 = g_oga.oga01
    END IF
END FUNCTION
 
FUNCTION t650_b_askkey()
DEFINE l_wc2           LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON ogb03,ogb04,ogb06,ogb05,
                       ogb12,ogb13,ogb14,ogb14t,ogb09,ogb091,ogb092,       #CHI-6B0027 mod  
                       ogb908 #no.A050
            FROM s_ogb[1].ogb03,
                 s_ogb[1].ogb04, s_ogb[1].ogb06,s_ogb[1].ogb05,
                 s_ogb[1].ogb12, s_ogb[1].ogb13,s_ogb[1].ogb14,
                 s_ogb[1].ogb14t,s_ogb[1].ogb09,                #CHI-6B0027 mod 
                 s_ogb[1].ogb091,s_ogb[1].ogb092,
                 s_ogb[1].ogb908 #no.A050
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
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL t650_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t650_b_fill(p_wc2)              #BODY FILL UP
   DEFINE p_wc2           LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(200)
#FUN-A60035 ---MARK BEGIN
#  DEFINE l_sum14         LIKE ogb_file.ogb14  #FUN-A50054 add
#  DEFINE l_sum14t        LIKE ogb_file.ogb14t #FUN-A50054 add
#  #FUN-A60035 ---add begin
#  DEFINE l_ogb03  DYNAMIC ARRAY OF RECORD
#         ogb03    LIKE ogb_file.ogb03
#         END RECORD
#  DEFINE l_i      LIKE type_file.num5
#  DEFINE l_go     LIKE type_file.chr1
#  #FUN-A60035 ---add end
#FUN-A60035 ---MARK END
 
    IF cl_null(p_wc2) THEN
        LET p_wc2 = ' 1=1 '
    END IF
    LET g_sql =
        "SELECT ogb03,ogb04,ogb06,ima021,ogb092,ogb1001,ogb17,",        #CHI-6B0027 mod  #No.FUN-660073
        "       ogb09,ogb091,ogb05,ogb12,ogb913,ogb914,ogb915,",
        "       ogb910,ogb911,ogb912,ogb916,ogb917,ogb50,ogb51,ogb41,ogb42,ogb43,ogb37,ogb13,ogb14,",  #FUN-810045 add ogb41/42/43#FUN-AB0061 #add ogb50,51 FUN-C50097 ,ogb50,ogb51
        "       ogb14t,ogb930,'',ogb908,  ", #no.A050 add ogb908 #FUN-670063
        "       ogbud01,ogbud02,ogbud03,ogbud04,ogbud05,",
        "       ogbud06,ogbud07,ogbud08,ogbud09,ogbud10,",
        "       ogbud11,ogbud12,ogbud13,ogbud14,ogbud15",
        "       ,'','','','','','' ",   #FUN-B80178   #FUN-C30289     
        "  FROM ogb_file LEFT OUTER JOIN ima_file ON ogb04 = ima01 ",   #No.TQC-9A0132 mod
        " WHERE ogb01 ='",g_oga.oga01,"'",  #單頭
        "   AND ",p_wc2 CLIPPED,                     #單身
        " ORDER BY ogb03"
 
    PREPARE t650_pb FROM g_sql
    DECLARE ogb_curs                       #CURSOR
        CURSOR FOR t650_pb
 
    CALL g_ogb.clear()
 
    LET g_cnt = 1
    FOREACH ogb_curs INTO g_ogb[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
#FUN-A60035 ---MARK BEGIN
##FUN-A50054---Begin
#       IF s_industry("slk") THEN 
#          SELECT ata02,ata05 INTO g_ogb[g_cnt].ogb03,g_ogb[g_cnt].ogb04
#           FROM ata_file
#          WHERE ata00 = g_prog
#            AND ata01 = g_oga.oga01
#            AND ata03 = g_ogb[g_cnt].ogb03

#         LET l_ogb03[l_ogb03.getLength() + 1] = g_ogb[g_cnt].ogb03   #FUN-A60035 add
#         SELECT SUM(ata08) INTO g_ogb[g_cnt].ogb12 from ata_file
#          WHERE ata00 = g_prog
#            AND ata01 = g_oga.oga01
#            AND ata02 = g_ogb[g_cnt].ogb03
#         SELECT SUM(ogb14),SUM(ogb14t) INTO l_sum14,l_sum14t
#           FROM  ogb_file WHERE ogb01 = g_oga.oga01
#            AND  ogb03 IN  (SELECT ata03 FROM ata_file WHERE ata00 = g_prog
#            AND  ata01 = g_oga.oga01
#            AND  ata02 =  g_ogb[g_cnt].ogb03 )
#         LET g_ogb[g_cnt].ogb14=l_sum14
#         LET g_ogb[g_cnt].ogb14t=l_sum14t               
#         IF g_cnt > 1 THEN
#         #FUN-A60035 mark begin
#         #   IF g_ogb[g_cnt].ogb03 = g_ogb[g_cnt-1].ogb03 THEN
#         #      CONTINUE FOREACH
#         #   END IF
#         #FUN-A60035 mark end
#         #FUN-A60035 ---add begin
#             LET l_go = 'N'
#             FOR l_i = 1 TO l_ogb03.getLength()-1
#                IF g_ogb[g_cnt].ogb03 = l_ogb03[l_i].ogb03 THEN
#                   LET l_go = 'Y'
#                   EXIT FOR
#                END IF
#             END FOR
#             IF l_go = 'Y' THEN
#                CONTINUE FOREACH
#             END IF
#         #FUN-A60035 ---add end
#         END IF
#       END IF      
##FUN-A50054---End     
#FUN-A60035 ---MARK END
        LET g_ogb[g_cnt].gem02c=s_costcenter_desc(g_ogb[g_cnt].ogb930) #FUN-670063
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_ogb.deleteElement(g_cnt)
 
    LET g_rec_b=g_cnt - 1
 
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
    #FUN-B30170 add begin-------------------------
    LET g_sql = " SELECT rvbs02,rvbs021,ima02,ima021,rvbs022,rvbs04,rvbs03,rvbs05,rvbs06,rvbs07,rvbs08,rvbs13",
                "   FROM rvbs_file LEFT JOIN ima_file ON rvbs021 = ima01",
                "  WHERE rvbs00 = '",g_prog,"' AND rvbs01 = '",g_oga.oga01,"'"
    PREPARE sel_rvbs_pre FROM g_sql
    DECLARE rvbs_curs CURSOR FOR sel_rvbs_pre
    
    CALL g_rvbs.clear()
    
    LET g_cnt = 1
    FOREACH rvbs_curs INTO g_rvbs[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_rvbs.deleteElement(g_cnt)
    LET g_rec_b1 = g_cnt - 1
    #FUN-B30170 add -end--------------------------
END FUNCTION
 
FUNCTION t650_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)    
   #FUN-B30170 add -begin-------------------------
   DIALOG ATTRIBUTE(UNBUFFERED)
      DISPLAY ARRAY g_ogb TO s_ogb.* ATTRIBUTE(COUNT=g_rec_b)
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont() 
      END DISPLAY
      
      DISPLAY ARRAY g_rvbs TO s_rvbs.* ATTRIBUTE(COUNT=g_rec_b1)
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )

         BEFORE ROW
            LET l_ac1 = ARR_CURR()
            CALL cl_show_fld_cont()

         AFTER DISPLAY
            CONTINUE DIALOG   #因為外層是DIALOG
      END DISPLAY
      
      BEFORE DIALOG
         LET g_chr='@'
 
         LET g_action_choice = "entry_sheet"
         CALL cl_chk_act_auth_nomsg()   #MOD-5B0123
         IF NOT cl_chk_act_auth() THEN
            CALL cl_set_act_visible("entry_sheet",FALSE)
         END IF
         #CHI-AC0002 add --start--
         IF g_aza.aza63 = 'N' THEN
            CALL cl_set_act_visible("entry_sheet2",FALSE)
         END IF
         #CHI-AC0002 add --end--
         CALL cl_chk_act_auth_showmsg()   #MOD-890049
 
         LET g_action_choice = "deduct_inventory"
         CALL cl_chk_act_auth_nomsg()   #MOD-5B0123
         IF NOT cl_chk_act_auth() THEN
            CALL cl_set_act_visible("deduct_inventory",FALSE)
         END IF
#TQC-A40032  ---start
         IF cl_chk_act_auth() THEN
            CALL cl_set_act_visible("deduct_inventory",TRUE)
         END IF
#TQC-A40032 ---end
         CALL cl_chk_act_auth_showmsg()   #MOD-890049
         LET g_action_choice = " "   #MOD-A90145

      ON ACTION info_list                 #FUN-CB0014
         LET g_action_flag="info_list"    #FUN-CB0014
         EXIT DIALOG                      #FUN-CB0014
         
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DIALOG
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DIALOG
 
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DIALOG
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CALL t650_def_form()   #FUN-610006
         #CKP
         IF g_oga.ogaconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
         CALL cl_set_field_pic(g_oga.ogaconf,"",g_oga.ogapost,"",g_chr,"")
         EXIT DIALOG
 
      ON ACTION first
         CALL t650_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL t650_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL t650_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL t650_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL t650_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DIALOG
 
      ON ACTION output
         LET g_action_choice="output"
         EXIT DIALOG
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
#@    ON ACTION 文件地址
      ON ACTION address
         LET g_action_choice="address"
         EXIT DIALOG
 
#@    ON ACTION 其他資料
      ON ACTION other_data
         LET g_action_choice="other_data"
         EXIT DIALOG
 
#@    ON ACTION 分錄底稿
      ON ACTION entry_sheet
         LET g_action_choice="entry_sheet"
         EXIT DIALOG

      #CHI-AC0002 add --start--
#@    ON ACTION 分錄底稿二
      ON ACTION entry_sheet2
         LET g_action_choice="entry_sheet2"
         EXIT DIALOG
      #CHI-AC0002 add --end--
 
#@    ON ACTION 會計分錄產生
      ON ACTION gen_entry
         LET g_action_choice="gen_entry"
         EXIT DIALOG

#FUN-BB0167 add begin-------------------
#@    ON ACTION 轉出貨簽收
      ON ACTION gen_on_check_note
         LET g_action_choice="gen_on_check_note"
         EXIT DIALOG
#FUN-BB0167 add end---------------------
 
#@    ON ACTION 出貨相關查詢
      ON ACTION query_delivery
         LET g_action_choice="query_delivery"
         EXIT DIALOG
 
#@    ON ACTION 客戶相關查詢
      ON ACTION query_customer
         LET g_action_choice="query_customer"
         EXIT DIALOG
 
#@    ON ACTION 備註
      ON ACTION memo
         LET g_action_choice="memo"
         EXIT DIALOG
 
#@    ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DIALOG
 
#@    ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DIALOG
 
#@    ON ACTION 庫存過帳
      ON ACTION deduct_inventory
         LET g_action_choice="deduct_inventory"
         EXIT DIALOG
 
#@    ON ACTION 扣帳還原
      ON ACTION undo_deduct
         LET g_action_choice="undo_deduct"
         EXIT DIALOG
 
#@    ON ACTION 轉應收發票
      ON ACTION ar_carry
         LET g_action_choice="ar_carry"
         EXIT DIALOG
 
#@    ON ACTION 應收維護
      ON ACTION mntn_ar
         LET g_action_choice="mntn_ar"
         EXIT DIALOG
 
#@    ON ACTION 信用超限放行
      ON ACTION release_ov_lmt_credit
         LET g_action_choice="release_ov_lmt_credit"
         EXIT DIALOG
 
#@    ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DIALOG
#FUN-D20025--add--str--
#@    ON ACTION 取消作廢
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DIALOG
#FUN-D20025--add--str--
 
      ON ACTION qry_mntn_inv_detail
         LET g_action_choice="qry_mntn_inv_detail"
         EXIT DIALOG
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DIALOG
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel       #FUN-4B0038
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
 
      ON ACTION related_document                #No.FUN-6A0020  相關文件
         LET g_action_choice="related_document"          
         EXIT DIALOG
 
      ON ACTION qry_lot
         LET g_action_choice="qry_lot"
         EXIT DIALOG
      &include "qry_string.4gl"
   END DIALOG
   #FUN-B30170 add --end--------------------------
#FUN-B30170 mark begin-----------------------   
#   DISPLAY ARRAY g_ogb TO s_ogb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
# 
#      BEFORE DISPLAY
#         CALL cl_navigator_setting( g_curs_index, g_row_count )
#         LET g_chr='@'
# 
#         LET g_action_choice = "entry_sheet"
#         CALL cl_chk_act_auth_nomsg()   #MOD-5B0123
#         IF NOT cl_chk_act_auth() THEN
#            CALL cl_set_act_visible("entry_sheet",FALSE)
#         END IF
#         #CHI-AC0002 add --start--
#         IF g_aza.aza63 = 'N' THEN
#            CALL cl_set_act_visible("entry_sheet2",FALSE)
#         END IF
#         #CHI-AC0002 add --end--
#         CALL cl_chk_act_auth_showmsg()   #MOD-890049
# 
#         LET g_action_choice = "deduct_inventory"
#         CALL cl_chk_act_auth_nomsg()   #MOD-5B0123
#         IF NOT cl_chk_act_auth() THEN
#            CALL cl_set_act_visible("deduct_inventory",FALSE)
#         END IF
##TQC-A40032  ---start
#         IF cl_chk_act_auth() THEN
#            CALL cl_set_act_visible("deduct_inventory",TRUE)
#         END IF
##TQC-A40032 ---end
#         CALL cl_chk_act_auth_showmsg()   #MOD-890049
#         LET g_action_choice = " "   #MOD-A90145
# 
#      BEFORE ROW
#         LET l_ac = ARR_CURR()
#         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
# 
#      ON ACTION insert
#         LET g_action_choice="insert"
#         EXIT DISPLAY
# 
#      ON ACTION query
#         LET g_action_choice="query"
#         EXIT DISPLAY
# 
#      ON ACTION delete
#         LET g_action_choice="delete"
#         EXIT DISPLAY
# 
#      ON ACTION modify
#         LET g_action_choice="modify"
#         EXIT DISPLAY
# 
#      ON ACTION locale
#         CALL cl_dynamic_locale()
#         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#         CALL t650_def_form()   #FUN-610006
#         #CKP
#         IF g_oga.ogaconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
#         CALL cl_set_field_pic(g_oga.ogaconf,"",g_oga.ogapost,"",g_chr,"")
#         EXIT DISPLAY
# 
#      ON ACTION first
#         CALL t650_fetch('F')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)  ######add in 040505
#           END IF
#           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
# 
#      ON ACTION previous
#         CALL t650_fetch('P')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)  ######add in 040505
#           END IF
#	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
# 
#      ON ACTION jump
#         CALL t650_fetch('/')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)  ######add in 040505
#           END IF
#	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
# 
#      ON ACTION next
#         CALL t650_fetch('N')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)  ######add in 040505
#           END IF
#	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
# 
#      ON ACTION last
#         CALL t650_fetch('L')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)  ######add in 040505
#           END IF
#	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
# 
#      ON ACTION detail
#         LET g_action_choice="detail"
#         LET l_ac = 1
#         EXIT DISPLAY
# 
#      ON ACTION output
#         LET g_action_choice="output"
#         EXIT DISPLAY
# 
#      ON ACTION help
#         LET g_action_choice="help"
#         EXIT DISPLAY
# 
#      ON ACTION exit
#         LET g_action_choice="exit"
#         EXIT DISPLAY
# 
#      ON ACTION controlg
#         LET g_action_choice="controlg"
#         EXIT DISPLAY
#      ON ACTION controls                             #No.FUN-6A0092
#         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
# 
##@    ON ACTION 文件地址
#      ON ACTION address
#         LET g_action_choice="address"
#         EXIT DISPLAY
# 
##@    ON ACTION 其他資料
#      ON ACTION other_data
#         LET g_action_choice="other_data"
#         EXIT DISPLAY
# 
##@    ON ACTION 分錄底稿
#      ON ACTION entry_sheet
#         LET g_action_choice="entry_sheet"
#         EXIT DISPLAY
#
#      #CHI-AC0002 add --start--
##@    ON ACTION 分錄底稿二
#      ON ACTION entry_sheet2
#         LET g_action_choice="entry_sheet2"
#         EXIT DISPLAY
#      #CHI-AC0002 add --end--
# 
##@    ON ACTION 會計分錄產生
#      ON ACTION gen_entry
#         LET g_action_choice="gen_entry"
#         EXIT DISPLAY
# 
##@    ON ACTION 出貨相關查詢
#      ON ACTION query_delivery
#         LET g_action_choice="query_delivery"
#         EXIT DISPLAY
# 
##@    ON ACTION 客戶相關查詢
#      ON ACTION query_customer
#         LET g_action_choice="query_customer"
#         EXIT DISPLAY
# 
##@    ON ACTION 備註
#      ON ACTION memo
#         LET g_action_choice="memo"
#         EXIT DISPLAY
# 
##@    ON ACTION 確認
#      ON ACTION confirm
#         LET g_action_choice="confirm"
#         EXIT DISPLAY
# 
##@    ON ACTION 取消確認
#      ON ACTION undo_confirm
#         LET g_action_choice="undo_confirm"
#         EXIT DISPLAY
# 
##@    ON ACTION 庫存過帳
#      ON ACTION deduct_inventory
#         LET g_action_choice="deduct_inventory"
#         EXIT DISPLAY
# 
##@    ON ACTION 扣帳還原
#      ON ACTION undo_deduct
#         LET g_action_choice="undo_deduct"
#         EXIT DISPLAY
# 
##@    ON ACTION 轉應收發票
#      ON ACTION ar_carry
#         LET g_action_choice="ar_carry"
#         EXIT DISPLAY
# 
##@    ON ACTION 應收維護
#      ON ACTION mntn_ar
#         LET g_action_choice="mntn_ar"
#         EXIT DISPLAY
# 
##@    ON ACTION 信用超限放行
#      ON ACTION release_ov_lmt_credit
#         LET g_action_choice="release_ov_lmt_credit"
#         EXIT DISPLAY
# 
##@    ON ACTION 作廢
#      ON ACTION void
#         LET g_action_choice="void"
#         EXIT DISPLAY
# 
#      ON ACTION qry_mntn_inv_detail
#         LET g_action_choice="qry_mntn_inv_detail"
#         EXIT DISPLAY
# 
#      ON ACTION accept
#         LET g_action_choice="detail"
#         LET l_ac = ARR_CURR()
#         EXIT DISPLAY
# 
#      ON ACTION cancel
#         LET INT_FLAG=FALSE 		#MOD-570244	mars
#         LET g_action_choice="exit"
#         EXIT DISPLAY
# 
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE DISPLAY
# 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
# 
#      ON ACTION exporttoexcel       #FUN-4B0038
#         LET g_action_choice = 'exporttoexcel'
#         EXIT DISPLAY
# 
#      ON ACTION related_document                #No.FUN-6A0020  相關文件
#         LET g_action_choice="related_document"          
#         EXIT DISPLAY
# 
#      ON ACTION qry_lot
#         LET g_action_choice="qry_lot"
#         EXIT DISPLAY
#          
##FUN-A60035 ---MARK BEGIN
##     #FUN-A50054 --Begin
##     ON ACTION style_detail
##        LET g_action_choice = 'style_detail'
##        EXIT DISPLAY
##     #FUN-A50054 --End  
##FUN-A60035 ---MARK END        
# 
#      AFTER DISPLAY
#         CONTINUE DISPLAY
# 
#      &include "qry_string.4gl"
#   END DISPLAY
#FUN-B30170 mark -end-----------------------   
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t650_out()
DEFINE l_wc     LIKE type_file.chr1000       #No.TQC-610089 add  #No.FUN-680137 VARCHAR(200)
    DEFINE l_no	LIKE oga_file.oga01 #MOD-5B0276
    IF g_oga.oga01 IS NULL THEN RETURN END IF
    LET l_no=g_oga.oga01
 
          LET l_wc='oga01="',l_no,'"'
         # LET g_msg = "axmr600", #FUN-C30085 mark
          LET g_msg = "axmg600",  #FUN-C30085 add
                       " '",g_today CLIPPED,"' ''",
                       " '",g_lang CLIPPED,"' 'Y' '' '1'",
                       #" '",l_wc CLIPPED,"' "                            #MOD-B90173 mark
                       " '",l_wc CLIPPED,"' '1' 'Y' 'Y' 'Y' 'Y' 'Y' "     #MOD-B90173 add
          CALL cl_cmdrun(g_msg)
 
END FUNCTION
 
FUNCTION t650_1()
   DEFINE  l_oap   RECORD LIKE oap_file.*
 
    BEGIN WORK
 
    OPEN t650_cl USING g_oga.oga01
    IF STATUS THEN
       CALL cl_err("OPEN t650_cl:", STATUS, 1)
       CLOSE t650_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH t650_cl INTO g_oga.*    # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_oga.oga01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t650_cl ROLLBACK WORK RETURN
    END IF
 
    IF g_oga.oga01 IS NULL THEN RETURN END IF
 
    OPEN WINDOW t6001_w AT 5,7 WITH FORM "axm/42f/axmt6001"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("axmt6001")
 
    CALL s_addr(g_oga.oga01,g_oga.oga04,g_oga.oga044)
         RETURNING l_oap.oap041,l_oap.oap042,l_oap.oap043,l_oap.oap044,l_oap.oap045   #FUN-720014 add 044/045
 
    LET g_buf=NULL
    SELECT oac02 INTO g_buf FROM oac_file WHERE oac01=g_oga.oga41
                            DISPLAY g_buf TO oac02 LET g_buf=NULL
    SELECT oac02 INTO g_buf FROM oac_file WHERE oac01=g_oga.oga42
                            DISPLAY g_buf TO oac02_2 LET g_buf=NULL
    SELECT oah02 INTO g_buf FROM oah_file WHERE oah01=g_oga.oga31
                            DISPLAY g_buf TO oah02 LET g_buf=NULL
    SELECT oag02 INTO g_buf FROM oag_file WHERE oag01=g_oga.oga32
                            DISPLAY g_buf TO oag02 LET g_buf=NULL
    SELECT ged02 INTO g_buf FROM ged_file WHERE ged01=g_oga.oga43            #MOD-A10106 add
                            DISPLAY g_buf TO oga43_desc LET g_buf=NULL       #MOD-A10106 add

 
    LET g_action_choice="modify"
    IF NOT cl_chk_act_auth() THEN
       DISPLAY BY NAME g_oga.oga044,l_oap.oap041,l_oap.oap042,l_oap.oap043,
                  g_oga.oga41,g_oga.oga42,g_oga.oga43,g_oga.oga44,
                  g_oga.oga31,g_oga.oga32,g_oga.oga33,
                  g_oga.oga47,g_oga.oga48,g_oga.oga021,   #MOD-870164增加oga021
                  g_oga.oga35,g_oga.oga36,g_oga.oga37,g_oga.oga38,g_oga.oga39
            LET INT_FLAG = 0  ######add for prompt bug
       PROMPT ">" FOR CHAR g_chr
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
       END PROMPT
       CLOSE WINDOW t6001_w
       RETURN
    END IF
 
    INPUT BY NAME g_oga.oga044,l_oap.oap041,l_oap.oap042,l_oap.oap043,
                  g_oga.oga41,g_oga.oga42,g_oga.oga43,g_oga.oga44,
                  g_oga.oga31,g_oga.oga32,g_oga.oga33,
                  g_oga.oga47,g_oga.oga48,g_oga.oga021,   #MOD-870164增加oga021 
                  g_oga.oga35,g_oga.oga36,g_oga.oga37,g_oga.oga38,g_oga.oga39
          WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t650_set_entry_1()
         CALL t650_set_no_entry_1()
         LET g_before_input_done = TRUE
 
      BEFORE FIELD oga044
         CALL t650_set_entry_1()
 
      AFTER FIELD oga044
         IF NOT cl_null(g_oga.oga044) THEN
            IF g_oga.oga044[1,4] !='MISC' THEN
               SELECT ocd221,ocd222,ocd223
                 INTO l_oap.oap041,l_oap.oap042,l_oap.oap043 FROM ocd_file
                WHERE ocd01=g_oga.oga04
                  AND ocd02=g_oga.oga044
               IF STATUS THEN
                  CALL cl_err3("sel","ocd_file",g_oga.oga04,g_oga.oga044,STATUS,"","",1)  #No.FUN-660167
                  NEXT FIELD oga044
               END IF
             END IF
             DISPLAY BY NAME l_oap.oap041
             DISPLAY BY NAME l_oap.oap042
             DISPLAY BY NAME l_oap.oap043
         END IF
         IF g_oga.oga044[1,4] ='MISC' THEN
            LET g_chr='Y'
         END IF
         CALL t650_set_no_entry_1()

     #MOD-A10106---add---start---
      AFTER FIELD oga43
         IF NOT cl_null(g_oga.oga43) THEN
            SELECT ged02 INTO g_buf FROM ged_file WHERE ged01 = g_oga.oga43 
            IF STATUS THEN
               CALL cl_err3("sel","ged_file",g_oga.oga43,"",SQLCA.sqlcode,"","",1)  
               NEXT FIELD oga43
            END IF
            DISPLAY g_buf TO oga43_desc 
         END IF
     #MOD-A10106---add---end---
 
      AFTER FIELD oga41
         IF NOT cl_null(g_oga.oga41) THEN
            SELECT oac02 INTO g_buf FROM oac_file
             WHERE oac01=g_oga.oga41
            IF STATUS THEN
               CALL cl_err3("sel","oac_file",g_oga.oga41,"",STATUS,"","sel oac",1)  #No.FUN-660167
               NEXT FIELD oga41
            END IF
            DISPLAY g_buf TO oac02
         END IF
 
      AFTER FIELD oga42
         IF NOT cl_null(g_oga.oga42) THEN
            SELECT oac02 INTO g_buf FROM oac_file WHERE oac01=g_oga.oga42
            IF STATUS THEN
               CALL cl_err3("sel","oac_file",g_oga.oga42,"",STATUS,"","sel oac",1)  #No.FUN-660167
               NEXT FIELD oga42
            END IF
            DISPLAY g_buf TO oac02_2
         END IF
 
      AFTER FIELD oga44
         IF NOT cl_null(g_oga.oga44) THEN
            SELECT ocf02 INTO g_buf FROM ocf_file
             WHERE ocf01=g_oga.oga04 AND ocf02=g_oga.oga44
            IF STATUS THEN
               CALL cl_err3("sel","ocf_file",g_oga.oga44,"",STATUS,"","sel ocf",1)  #No.FUN-660167
               NEXT FIELD oga44
            END IF
         END IF
 
      AFTER FIELD oga31
         IF NOT cl_null(g_oga.oga31) THEN
            SELECT oah02 INTO g_buf FROM oah_file
             WHERE oah01=g_oga.oga31
            IF STATUS THEN
               CALL cl_err3("sel","oah_file",g_oga.oga31,"",STATUS,"","sel oah",1)  #No.FUN-660167
               NEXT FIELD oga31
            END IF
            DISPLAY g_buf TO oah02
         END IF
 
      AFTER FIELD oga32
         IF NOT cl_null(g_oga.oga32) THEN
            SELECT oag02 INTO g_buf FROM oag_file
             WHERE oag01=g_oga.oga32
            IF STATUS THEN
               CALL cl_err3("sel","oag_file",g_oga.oga32,"",STATUS,"","sel oag",1)  #No.FUN-660167
            END IF
            DISPLAY g_buf TO oag02
         END IF
 
      AFTER FIELD oga021
        IF NOT cl_null(g_oga.oga021) THEN
           IF g_oga.oga021 <= g_oaz.oaz09 THEN
              CALL cl_err('','axm-164',0) NEXT FIELD oga021
           END IF
        END IF
 
      ON KEY(F1) NEXT FIELD oga044
      ON KEY(F2) NEXT FIELD oga43
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(oga044)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_ocd"
                 LET g_qryparam.default1 = g_oga.oga044
                 LET g_qryparam.arg1 = g_oga.oga04   #No.MOD-940265 
                 CALL cl_create_qry() RETURNING g_oga.oga044
                 DISPLAY BY NAME g_oga.oga044 NEXT FIELD oga044
            WHEN INFIELD(oga41)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_oac"
                 LET g_qryparam.default1 = g_oga.oga41
                 CALL cl_create_qry() RETURNING g_oga.oga41
                 DISPLAY BY NAME g_oga.oga41 NEXT FIELD oga41
            WHEN INFIELD(oga42)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_oac"
                 LET g_qryparam.default1 = g_oga.oga42
                 CALL cl_create_qry() RETURNING g_oga.oga42
                 DISPLAY BY NAME g_oga.oga42 NEXT FIELD oga42
            WHEN INFIELD(oga44)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_ocf"
                 LET g_qryparam.default1 = g_oga.oga44
                  LET g_qryparam.arg1 = g_oga.oga04  # MOD-580083 Add
                 CALL cl_create_qry() RETURNING g_oga.oga44
                 DISPLAY BY NAME g_oga.oga44 NEXT FIELD oga44
            WHEN INFIELD(oga31)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_oah"
                 LET g_qryparam.default1 = g_oga.oga31
                 CALL cl_create_qry() RETURNING g_oga.oga31
                 DISPLAY BY NAME g_oga.oga31 NEXT FIELD oga31
            WHEN INFIELD(oga32)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_oag"
                 LET g_qryparam.default1 = g_oga.oga32
                 CALL cl_create_qry() RETURNING g_oga.oga32
                 DISPLAY BY NAME g_oga.oga32 NEXT FIELD oga32
          #MOD-A10106---add---start---
            WHEN INFIELD(oga43)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_ged"
                 LET g_qryparam.default1 = g_oga.oga43
                 CALL cl_create_qry() RETURNING g_oga.oga43
                 DISPLAY BY NAME g_oga.oga43
                 NEXT FIELD oga43
          #MOD-A10106---add---end---
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
       LET INT_FLAG=0
       CLOSE WINDOW t6001_w
       RETURN
    END IF
 
    CLOSE WINDOW t6001_w
 
    LET g_msg=l_oap.oap041 CLIPPED,' ',l_oap.oap042 CLIPPED,' ',
              l_oap.oap043 CLIPPED
 
    DISPLAY g_msg TO addr
    DELETE FROM oap_file WHERE oap01=g_oga.oga01
    LET l_oap.oap01 = g_oga.oga01
    IF g_oga.oga044[1,4] ='MISC' THEN
       INSERT INTO oap_file VALUES(l_oap.*)
       IF STATUS OR SQLCA.SQLCODE THEN
          CALL cl_err3("ins","oap_file",l_oap.oap01,"",SQLCA.SQLCODE,"","INS-oap",1)  #No.FUN-660167
       END IF
    END IF
    UPDATE oga_file SET * = g_oga.* WHERE oga01 = g_oga.oga01
    IF SQLCA.SQLCODE THEN
        CALL cl_err3("upd","oga_file",g_oga.oga01,"",SQLCA.SQLCODE,"","update oga",1)  #No.FUN-660167
        ROLLBACK WORK
    ELSE
        COMMIT WORK
    END IF
 
    DISPLAY BY NAME g_oga.oga021     #MOD-870164
END FUNCTION
 
FUNCTION t650_set_entry_1()
 
    IF INFIELD(oga044) OR ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("oap041,oap042,oap043",TRUE)
    END IF

    CALL cl_set_comp_entry("oga32",TRUE) #MOD-CA0074 add
 
END FUNCTION
 
FUNCTION t650_set_no_entry_1()
 
    IF INFIELD(oga044) OR ( NOT g_before_input_done ) THEN
       IF g_oga.oga044[1,4] !='MISC' THEN
          CALL cl_set_comp_entry("oap041,oap042,oap043",FALSE)
       END IF
    END IF
 
END FUNCTION
 
FUNCTION t650_2()
  DEFINE l_date1,l_date2 LIKE type_file.dat     #No.FUN-680137 DATE
 
    BEGIN WORK
 
    OPEN t650_cl USING g_oga.oga01
    IF STATUS THEN
       CALL cl_err("OPEN t650_cl:", STATUS, 1)
       CLOSE t650_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH t650_cl INTO g_oga.*    # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_oga.oga01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t650_cl ROLLBACK WORK RETURN
    END IF
 
    IF g_oga.oga01 IS NULL THEN RETURN END IF
 
    OPEN WINDOW t6002_w AT 06,11 WITH FORM "axm/42f/axmt6002"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("axmt6002")
 
    LET g_action_choice="modify"
    IF NOT cl_chk_act_auth() THEN
       DISPLAY BY NAME g_oga.oga161,g_oga.oga162,g_oga.oga163,
                  g_oga.oga26,g_oga.oga32,g_oga.oga11 ,g_oga.oga12,
                  g_oga.oga19,g_oga.oga46,g_oga.oga13,g_oga.oga07,
                  g_oga.oga20  #,g_oga.oga18       #No.MOD-620052 mark
            LET INT_FLAG = 0  ######add for prompt bug
       PROMPT ">" FOR CHAR g_chr
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
       END PROMPT
       CLOSE WINDOW t6002_w
       RETURN
    END IF
 
    INPUT BY NAME g_oga.oga161,g_oga.oga162,g_oga.oga163,
                  g_oga.oga26,g_oga.oga32,g_oga.oga11 ,g_oga.oga12,
                  g_oga.oga19,g_oga.oga46,g_oga.oga13,g_oga.oga07,
                  g_oga.oga20  #,g_oga.oga18     #No.MOD-620052 mark
          WITHOUT DEFAULTS
 
        AFTER FIELD oga13
           IF NOT cl_null(g_oga.oga13) THEN
              SELECT * FROM ool_file WHERE ool01=g_oga.oga13
              IF STATUS THEN CALL cl_err('',STATUS,0) NEXT FIELD oga13 END IF
           END IF
 
        AFTER FIELD oga26   #銷售分類
           IF NOT cl_null(g_oga.oga26) THEN
              SELECT * FROM oab_file WHERE oab01=g_oga.oga26
              IF SQLCA.sqlcode THEN CALL cl_err(g_oga.oga26,SQLCA.sqlcode,0) NEXT FIELD oga26 END IF
           END IF
 
        AFTER FIELD oga46   #項目編號
           IF NOT cl_null(g_oga.oga46) THEN
              SELECT * FROM pja_file WHERE pja01=g_oga.oga46 AND pjaacti = 'Y'    #FUN-810045
                 AND pjaclose='N'             #FUN-960038
              IF SQLCA.sqlcode THEN CALL cl_err(g_oga.oga46,SQLCA.sqlcode,0) NEXT FIELD oga46 END IF
           END IF
 
         BEFORE FIELD oga11
           IF NOT cl_null(g_oga.oga32) THEN
              SELECT oag02 INTO g_buf FROM oag_file WHERE oag01=g_oga.oga32
              IF STATUS THEN
                 #CHI-B90032 --- start ---
                 #CALL cl_err3("sel","oag_file",g_oga.oga32,"",STATUS,"","select oag",1)  #No.FUN-660167
                 #NEXT FIELD oga32
                 CALL cl_err('','axm1048',1)
                 EXIT INPUT
                 #CHI-B90032 ---  end ---
              END IF
              CALL s_rdatem(g_oga.oga03,g_oga.oga32,g_oga.oga02,g_oga.oga02,
                            g_oga.oga02,g_plant2) #FUN-980020
                   RETURNING l_date1,l_date2
              IF cl_null(g_oga.oga11) THEN LET g_oga.oga11=l_date1 END IF
              IF cl_null(g_oga.oga12) THEN LET g_oga.oga12=l_date2 END IF
              DISPLAY BY NAME g_oga.oga11,g_oga.oga12
           END IF
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(oga26)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_oab"
                  LET g_qryparam.default1 = g_oga.oga26
                  CALL cl_create_qry() RETURNING g_oga.oga26
                  DISPLAY BY NAME g_oga.oga26
                  NEXT FIELD oga26
             WHEN INFIELD(oga32)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_oag"
                  LET g_qryparam.default1 = g_oga.oga32
                  CALL cl_create_qry() RETURNING g_oga.oga32
                  DISPLAY BY NAME g_oga.oga32 NEXT FIELD oga32
             WHEN INFIELD(oga13)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_ool"
                  LET g_qryparam.default1 = g_oga.oga13
                  CALL cl_create_qry() RETURNING g_oga.oga13
                  DISPLAY BY NAME g_oga.oga13
                  NEXT FIELD oga13
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
       LET INT_FLAG=0
       CLOSE WINDOW t6002_w
       RETURN
    END IF
 
    CLOSE WINDOW t6002_w
 
    UPDATE oga_file SET * = g_oga.* WHERE oga01 = g_oga.oga01
    IF SQLCA.SQLCODE THEN
       CALL cl_err3("upd","oga_file",g_oga.oga01,"",SQLCA.SQLCODE,"","update oga",1)  #No.FUN-660167
       ROLLBACK WORK
    ELSE
       COMMIT WORK
    END IF
 
END FUNCTION
 
FUNCTION t650_3(p_npptype) #CHI-AC0002 add p_npptype
    DEFINE p_npptype LIKE npp_file.npptype #CHI-AC0002 add

    IF g_oga.oga01 IS NULL THEN RETURN END IF
    IF g_oga.oga09 ='1' THEN RETURN END IF
    IF g_oga.oga07='N' OR cl_null(g_oga.oga07) THEN
                       CALL cl_err('','axm-166',0) RETURN END IF
    LET g_action_choice="modify"
    IF NOT cl_chk_act_auth() THEN
       LET g_chr='D'
    ELSE
       LET g_chr='U'
    END IF
 
    IF p_npptype = '0' THEN #CHI-AC0002 add
       CALL s_fsgl('AR',1,g_oga.oga01,0,g_oaz.oaz02b,1,g_oga.ogaconf,'0',g_oaz.oaz02p) #FUN-670047
    #CHI-AC0002 add --start--
    ELSE
       CALL s_fsgl('AR',1,g_oga.oga01,0,g_oaz.oaz02b,1,g_oga.ogaconf,'1',g_ooz.ooz02p)
    END IF
    #CHI-AC0002 add --end--
 
END FUNCTION
 
FUNCTION t650_v()
   DEFINE l_wc    LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(100)
   DEFINE l_oga01 LIKE oga_file.oga01
   DEFINE only_one LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
   IF g_oga.oga09 ='1' THEN RETURN END IF
   IF g_oga.oga07='N' OR cl_null(g_oga.oga07) THEN
      CALL cl_err('','axm-259',0)
      RETURN
   END IF
 
   OPEN WINDOW t6009_w AT 10,11 WITH FORM "axm/42f/axmt6009"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("axmt6009")
 
 
   LET only_one = '1'
   INPUT BY NAME only_one WITHOUT DEFAULTS
     AFTER FIELD only_one
      IF only_one IS NULL THEN NEXT FIELD only_one END IF
      IF only_one NOT MATCHES "[12]" THEN NEXT FIELD only_one END IF
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
      CLOSE WINDOW t6009_w
      RETURN
   END IF
 
   IF only_one = '1' THEN
      LET l_wc = " oga01 = '",g_oga.oga01,"' "
   ELSE
      CONSTRUCT BY NAME l_wc ON oga00,oga08,oga01,oga02,oga14,oga15
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
         LET INT_FLAG=0
         CLOSE WINDOW t6009_w
         RETURN
      END IF
   END IF
 
   CLOSE WINDOW t6009_w
 
   MESSAGE "WORKING !"
   LET g_sql = "SELECT oga01,oga20 FROM oga_file WHERE ",l_wc CLIPPED
   PREPARE t650_v_p FROM g_sql
   DECLARE t650_v_c CURSOR WITH HOLD FOR t650_v_p
   FOREACH t650_v_c INTO l_oga01,g_chr
      IF STATUS THEN EXIT FOREACH END IF
      IF g_chr = 'N' THEN CONTINUE FOREACH END IF
     #CHI-AC0002 mod --start--
     #CALL s_t600_gl(l_oga01)
      CALL s_t600_gl(l_oga01,'0')
      IF g_aza.aza63 = 'Y' THEN
         CALL s_t600_gl(l_oga01,'1')
      END IF
     #CHI-AC0002 mod --end-- 
   END FOREACH
 
END FUNCTION
 
FUNCTION t650_b_more()
  DEFINE l_ima25   LIKE ima_file.ima25 #MOD-5B0276
  DEFINE l_ima906  LIKE ima_file.ima906  #No.FUN-560063
 
    OPEN WINDOW t6005_w AT 14,10 WITH FORM "axm/42f/axmt6005"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("axmt6005")
 
    SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01=g_ogb[l_ac].ogb04
    LET b_ogb.ogb05 = g_ogb[l_ac].ogb05
    LET b_ogb.ogb12 = g_ogb[l_ac].ogb12
    LET b_ogb.ogb913 = g_ogb[l_ac].ogb913
    LET b_ogb.ogb914 = g_ogb[l_ac].ogb914
    LET b_ogb.ogb915 = g_ogb[l_ac].ogb915
    LET b_ogb.ogb910 = g_ogb[l_ac].ogb910
    LET b_ogb.ogb911 = g_ogb[l_ac].ogb911
    LET b_ogb.ogb912 = g_ogb[l_ac].ogb912
    LET b_ogb.ogb916 = g_ogb[l_ac].ogb916
    LET b_ogb.ogb917 = g_ogb[l_ac].ogb917
    CALL cl_set_comp_entry("ogb914,ogb911",FALSE)
    IF g_sma.sma115 = 'Y' THEN
       CALL cl_set_comp_visible("ogb05,ogb12,ogb05_fac",FALSE)
       CALL cl_set_comp_att_text("ogb05",' ')
       CALL cl_set_comp_att_text("ogb05_fac",' ')
       CALL cl_set_comp_att_text("ogb12",' ')
    ELSE
       CALL cl_set_comp_visible("ogb913,ogb914,ogb915",FALSE)
       CALL cl_set_comp_visible("ogb910,ogb911,ogb912",FALSE)
       CALL cl_set_comp_att_text("ogb913",' ')
       CALL cl_set_comp_att_text("ogb914",' ')
       CALL cl_set_comp_att_text("ogb915",' ')
       CALL cl_set_comp_att_text("ogb911",' ')
       CALL cl_set_comp_att_text("ogb912",' ')
       CALL cl_set_comp_att_text("ogb913",' ')
    END IF
    IF g_sma.sma122 ='1' THEN
       CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ogb913",g_msg CLIPPED)
       CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ogb915",g_msg CLIPPED)
       CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ogb910",g_msg CLIPPED)
       CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ogb912",g_msg CLIPPED)
    END IF
    IF g_sma.sma122 ='2' THEN
       CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ogb913",g_msg CLIPPED)
       CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ogb915",g_msg CLIPPED)
       CALL cl_getmsg('asm-326',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ogb910",g_msg CLIPPED)
       CALL cl_getmsg('asm-327',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ogb912",g_msg CLIPPED)
    END IF
 
    SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01 = g_ogb[l_ac].ogb04
    IF STATUS THEN LET l_ima25=NULL END IF
 
    INPUT BY NAME b_ogb.ogb18,b_ogb.ogb11,b_ogb.ogb07,b_ogb.ogb05, b_ogb.ogb12,
                  l_ima25,b_ogb.ogb05_fac, b_ogb.ogb913,b_ogb.ogb914,b_ogb.ogb915,
                  b_ogb.ogb910,b_ogb.ogb911,b_ogb.ogb912,b_ogb.ogb15, b_ogb.ogb15_fac,
                  b_ogb.ogb16
                  WITHOUT DEFAULTS
 
        BEFORE FIELD ogb15_fac
           CALL t650_set_origin_field()
 
        AFTER FIELD ogb15_fac
           LET b_ogb.ogb16 = b_ogb.ogb12 * b_ogb.ogb15_fac
           DISPLAY BY NAME b_ogb.ogb16
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
    IF INT_FLAG THEN LET INT_FLAG=0 END IF
 
    CLOSE WINDOW t6005_w                 #結束畫面
 
END FUNCTION
 
FUNCTION t650_m()
   IF g_oga.oga01 IS NULL THEN RETURN END IF
 
   LET g_action_choice="modify"
   IF NOT cl_chk_act_auth() THEN
      LET g_chr='d'
   ELSE
      LET g_chr='u'
   END IF
 
   CALL s_axm_memo(g_oga.oga01,0,g_chr)
 
END FUNCTION
 

#FUN-B10004---mark---str---
#FUNCTION t650_y() 			# when g_oga.ogaconf='N' (Turn to 'Y')
#   DEFINE l_yy,l_mm,l_n   LIKE type_file.num5    #No.FUN-680137 SMALLINT
#   DEFINE g_start,g_end		LIKE oga_file.oga01 #MOD-5B0276
#   DEFINE l_cnt   LIKE type_file.num5    #No.FUN-680137 SMALLINT
#   DEFINE l_ogb09         LIKE ogb_file.ogb09       #No.FUN-AA0048
# 
#  #CHI-A50004 程式搬移 --start--
#   BEGIN WORK
# 
#   OPEN t650_cl USING g_oga.oga01
#   IF STATUS THEN
#      CALL cl_err("OPEN t650_cl:", STATUS, 1)
#      CLOSE t650_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
# 
#   FETCH t650_cl INTO g_oga.*
#   IF SQLCA.sqlcode THEN
#      CALL cl_err(g_oga.oga01,SQLCA.sqlcode,0)
#      CLOSE t650_cl ROLLBACK WORK RETURN
#   END IF
#  #CHI-A50004 程式搬移 --end--
#
##---BUGNO:7379---無單身資料不可確認
#   LET l_cnt=0
#   SELECT COUNT(*) INTO l_cnt
#     FROM ogb_file
#    WHERE ogb01=g_oga.oga01
#   IF l_cnt=0 OR l_cnt IS NULL THEN
#      CALL cl_err('','mfg-009',0)
#      ROLLBACK WORK #CHI-A50004 add
#      RETURN
#   END IF
# 
#   SELECT * INTO g_oga.* FROM oga_file WHERE oga01 = g_oga.oga01
#   IF g_oga.ogaconf='Y' THEN ROLLBACK WORK RETURN END IF #CHI-A50004 add ROLLBACK WORK
#   IF g_oga.ogaconf = 'X' THEN CALL cl_err('',9024,0) ROLLBACK WORK RETURN END IF #CHI-A50004 add ROLLBACK WORK
#   #Modify:3031 ---若現行年月大於出貨單/銷退單之年月--不允許確認-----
#   CALL s_yp(g_oga.oga02) RETURNING l_yy,l_mm
#   IF (l_yy > g_sma.sma51) OR (l_yy = g_sma.sma51 AND l_mm > g_sma.sma52) THEN
#       CALL cl_err('','mfg6090',0)  #MOD-790009
#       ROLLBACK WORK #CHI-A50004 add
#       RETURN
#   END IF
#   IF g_oaz.oaz03 = 'Y' AND
#      g_sma.sma53 IS NOT NULL AND g_oga.oga02 <= g_sma.sma53 THEN
#      CALL cl_err('','mfg9999',0) ROLLBACK WORK RETURN #CHI-A50004 add ROLLBACK WORK
#   END IF
#
#   #No.FUN-AA0048  --Begin
#   IF NOT s_chk_ware(g_oga.oga66) THEN
#      ROLLBACK WORK
#      RETURN
#   END IF
#   IF NOT s_chk_ware(g_oga.oga910) THEN
#      ROLLBACK WORK
#      RETURN
#   END IF
#   DECLARE t650_ware_cs0 CURSOR FOR
#    SELECT ogb09 FROM ogb_file
#     WHERE ogb01 = g_oga.oga01
#   FOREACH t650_ware_cs0 INTO l_ogb09
#       IF NOT s_chk_ware(l_ogb09) THEN
#          ROLLBACK WORK
#          RETURN
#       END IF
#   END FOREACH
#   DECLARE t650_ware_cs1 CURSOR FOR
#    SELECT ogg09 FROM ogg_file
#     WHERE ogg01 = g_oga.oga01
#   FOREACH t650_ware_cs1 INTO l_ogb09
#       IF NOT s_chk_ware(l_ogb09) THEN
#          ROLLBACK WORK
#          RETURN
#       END IF
#   END FOREACH
#   DECLARE t650_ware_cs2 CURSOR FOR
#    SELECT ogc09 FROM ogc_file
#     WHERE ogc01 = g_oga.oga01
#   FOREACH t650_ware_cs2 INTO l_ogb09
#       IF NOT s_chk_ware(l_ogb09) THEN
#          ROLLBACK WORK
#          RETURN
#       END IF
#   END FOREACH
#   #No.FUN-AA0048  --End  
#
#
#
#
#
#   IF NOT cl_confirm('axm-108') THEN ROLLBACK WORK RETURN END IF #CHI-A50004 add ROLLBACK WORK
# 
#  #CHI-A50004 程式搬移至FUNCTION一開始 mark --start--
#  #BEGIN WORK
#  # 
#  #OPEN t650_cl USING g_oga.oga01
#  #IF STATUS THEN
#  #   CALL cl_err("OPEN t650_cl:", STATUS, 1)
#  #   CLOSE t650_cl
#  #   ROLLBACK WORK
#  #   RETURN
#  #END IF
#  #
#  #FETCH t650_cl INTO g_oga.*
#  #IF SQLCA.sqlcode THEN
#  #   CALL cl_err(g_oga.oga01,SQLCA.sqlcode,0)
#  #   CLOSE t650_cl ROLLBACK WORK RETURN
#  #END IF
#  #CHI-A50004 程式搬移至FUNCTION一開始 mark --end--
#   LET g_success = 'Y'
#   #若須拋轉總帳, 檢查分錄底稿平衡正確否
#   IF g_oga.oga07 = 'Y' THEN
#      CALL s_chknpq(g_oga.oga01,'AR',1,'0',g_bookno1)  #-->NO:0151#FUN-670047   #No.FUN-730057
#   END IF
#   CALL t650_y1()
#   IF g_success = 'Y' THEN
#      LET g_oga.ogaconf='Y'
#      COMMIT WORK
#      CALL cl_flow_notify(g_oga.oga01,'Y')
#      DISPLAY BY NAME g_oga.ogaconf
#      IF g_oga.oga09 ='1' OR g_oga.oga20='N' THEN RETURN END IF
#      IF g_oaz.oaz61 MATCHES "[12]" THEN CALL t650_s(g_oaz.oaz61) END IF
#   ELSE
#      LET g_oga.ogaconf='N'
#      ROLLBACK WORK
#   END IF
#    #CKP
#    IF g_oga.ogaconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
#    CALL cl_set_field_pic(g_oga.ogaconf,"",g_oga.ogapost,"",g_chr,"")
#END FUNCTION
#FUN-B10004---mark---end---
 
FUNCTION t650_z() 			# when g_oga.ogaconf='Y' (Turn to 'N')
#DEFINE l_oia07   LIKE oia_file.oia07    #FUN-C50136
DEFINE l_yy,l_mm,l_n   LIKE type_file.num5  #CHI-C70017
  #CHI-A50004 程式搬移 --start--
   BEGIN WORK
 
   OPEN t650_cl USING g_oga.oga01
   IF STATUS THEN
      CALL cl_err("OPEN t650_cl:", STATUS, 1)
      CLOSE t650_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t650_cl INTO g_oga.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_oga.oga01,SQLCA.sqlcode,0)
      CLOSE t650_cl ROLLBACK WORK RETURN
   END IF
  #CHI-A50004 程式搬移 --end--
#CHI-C70017---begin
   IF g_oaz.oaz03 = 'Y' AND
      g_sma.sma53 IS NOT NULL AND g_oga.oga02 <= g_sma.sma53 THEN
      CALL cl_err('','mfg9999',0) 
      ROLLBACK WORK
   END IF
   CALL s_yp(g_oga.oga02) RETURNING l_yy,l_mm
   IF (l_yy > g_sma.sma51) OR (l_yy = g_sma.sma51 AND l_mm > g_sma.sma52) THEN
       CALL cl_err('','mfg6090',0)  
       ROLLBACK WORK
       RETURN
   END IF
#CHI-C70017---end
   SELECT * INTO g_oga.* FROM oga_file WHERE oga01 = g_oga.oga01
   IF g_oga.ogaconf='N' THEN ROLLBACK WORK RETURN END IF #CHI-A50004 add ROLLBACK WORK
   IF g_oga.ogaconf = 'X' THEN CALL cl_err('',9024,0) ROLLBACK WORK RETURN END IF #No.+182 add #CHI-A50004 add ROLLBACK WORK
   IF g_oga.ogapost='Y' THEN CALL cl_err('ogapost=Y:','axm-208',0) ROLLBACK WORK RETURN END IF #CHI-A50004 add ROLLBACK WORK
   IF g_oaz.oaz03 = 'Y' AND
        g_sma.sma53 IS NOT NULL AND g_oga.oga02 <= g_sma.sma53 THEN
        CALL cl_err('','mfg9999',0) ROLLBACK WORK RETURN #CHI-A50004 add ROLLBACK WORK
   END IF
 
   IF NOT cl_confirm('axm-109') THEN ROLLBACK WORK RETURN END IF #CHI-A50004 add ROLLBACK WORK
 
  #CHI-A50004 程式搬移至FUNCTION一開始 mark --start--
  #BEGIN WORK
  # 
  #OPEN t650_cl USING g_oga.oga01
  #IF STATUS THEN
  #   CALL cl_err("OPEN t650_cl:", STATUS, 1)
  #   CLOSE t650_cl
  #   ROLLBACK WORK
  #   RETURN
  #END IF
  #FETCH t650_cl INTO g_oga.*
  #IF SQLCA.sqlcode THEN
  #   CALL cl_err(g_oga.oga01,SQLCA.sqlcode,0)
  #   CLOSE t650_cl ROLLBACK WORK RETURN
  #END IF
  #CHI-A50004 程式搬移至FUNCTION一開始 mark --end--
   LET g_success = 'Y'
 
   CALL t650_z1()

#  #FUN-C50136--add--str--
#  IF g_oaz.oaz96 ='Y' THEN
#     CALL s_ccc_oia07('E',g_oga.oga03) RETURNING l_oia07
#     IF l_oia07 ='0' THEN 
#        CALL s_ccc_rback(g_oga.oga03,'E',g_oga.oga01,0,'')
#     END IF
#  END IF
#  #FUN-C50136--add--end-- 

   IF g_success = 'Y' THEN
      LET g_oga.ogaconf='N'
      COMMIT WORK
      DISPLAY BY NAME g_oga.ogaconf
      LET g_oga.oga903='N'            #No.B325 add
      DISPLAY BY NAME g_oga.oga903    #No.B325 add
   ELSE
      LET g_oga.ogaconf='Y'
      ROLLBACK WORK
   END IF
    #CKP
    IF g_oga.ogaconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    CALL cl_set_field_pic(g_oga.ogaconf,"",g_oga.ogapost,"",g_chr,"")
 
END FUNCTION
 
#FUN-B10004---mark---str---
#FUNCTION t650_y1()
#   DEFINE l_slip   LIKE oay_file.oayslip
#   DEFINE l_oay13  LIKE oay_file.oay13
#   DEFINE l_oay14  LIKE oay_file.oay14
#   DEFINE l_ogb14t LIKE ogb_file.ogb14t
#   DEFINE l_rvbs06 LIKE rvbs_file.rvbs06   #No.FUN-860045
# 
#   UPDATE oga_file SET ogaconf = 'Y' WHERE oga01 = g_oga.oga01
#   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
#      CALL cl_err3("upd","oga_file",g_oga.oga01,"",SQLCA.SQLCODE,"","upd ogaconf",1)  #No.FUN-660167
#      LET g_success = 'N' RETURN
#   END IF
#   LET l_slip = s_get_doc_no(g_oga.oga01)     #No.FUN-550052
#   SELECT oay13,oay14 INTO l_oay13,l_oay14 FROM oay_file WHERE oayslip = l_slip
#   IF l_oay13 = 'Y' THEN
#      SELECT SUM(ogb14t) INTO l_ogb14t FROM ogb_file WHERE ogb01 = g_oga.oga01
#      IF cl_null(l_ogb14t) THEN LET l_ogb14t = 0 END IF
#      LET l_ogb14t = l_ogb14t * g_oga.oga24
#      IF l_ogb14t > l_oay14 THEN
#         CALL cl_err(l_oay14,'axm-700',1) LET g_success='N' RETURN
#      END IF
#   END IF
#   CALL t650_hu1() IF g_success = 'N' THEN RETURN END IF	#信用查核
#   CALL t650_hu2() IF g_success = 'N' THEN RETURN END IF	#最近交易
#   DECLARE t650_y1_c CURSOR FOR SELECT * FROM ogb_file WHERE ogb01=g_oga.oga01
#   FOREACH t650_y1_c INTO b_ogb.*
#      SELECT ima918,ima921 INTO g_ima918,g_ima921 
#        FROM ima_file
#       WHERE ima01 = b_ogb.ogb04
#         AND imaacti = "Y"
#      
#      IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
#         SELECT SUM(rvbs06) INTO l_rvbs06
#           FROM rvbs_file
#          WHERE rvbs00 = g_prog
#            AND rvbs01 = b_ogb.ogb01
#            AND rvbs02 = b_ogb.ogb03
#            AND rvbs09 = -1
#            #AND rvbs13 = 0   #MOD-A20117
#            
#         IF cl_null(l_rvbs06) THEN
#            LET l_rvbs06 = 0
#         END IF
#            
#         IF (b_ogb.ogb12 * b_ogb.ogb05_fac) <> l_rvbs06 THEN
#            LET g_success = "N"
#            CALL cl_err(b_ogb.ogb04,"aim-011",1)
#            CONTINUE FOREACH
#         END IF
#      END IF
# 
#      IF b_ogb.ogb04[1,4] != 'MISC' THEN   #No.+182 add
#         IF g_sma.sma115 = 'Y' THEN
#            CALL t650_chk_imgg()
#            IF g_success='N' THEN RETURN END IF
#         ELSE
#            CALL t650_chk_img()
#            IF g_success='N' THEN RETURN END IF
#         END IF
#         IF b_ogb.ogb17='N' THEN     ##不為多倉儲出貨
#         CALL t650_chk_ogb15_fac() IF g_success='N' THEN RETURN END IF  
#         END IF 
#      END IF   #No.+182 add
#   END FOREACH
#END FUNCTION
#FUN-B10004---mark---end---
 
FUNCTION t650_z1()
   UPDATE oga_file SET ogaconf = 'N' ,oga903='N' WHERE oga01 = g_oga.oga01
END FUNCTION
 
#FUN-B10004---mark---str---
#FUNCTION t650_hu1()		#客戶信用查核
#   MESSAGE "hu1!"
#   IF g_oga.oga903= 'Y' THEN RETURN END IF    #該單據信用已放行 No.B325 ADD
#   IF g_oaz.oaz142 MATCHES "[12]" THEN
#      CALL s_ccc(g_oga.oga03,'1',g_oga.oga01)	# Customer Credit Check 客戶信用查核  #No.MOD-8A0126 add
#      IF g_errno = 'N' THEN
#        IF g_oaz.oaz142 = "1"
#            THEN CALL cl_err('ccc','axm-104',1)
#                 IF NOT cl_confirm('axm-105') THEN LET g_success = 'N' RETURN
#                 END IF
#            ELSE CALL cl_err('ccc','axm-106',0)
#                 LET g_success = 'N' RETURN
#         END IF
#      END IF
#   END IF
#END FUNCTION
# 
#FUNCTION t650_hu2()		#最近交易日
#   DEFINE l_occ RECORD LIKE occ_file.*
#   MESSAGE "hu2!"
#   SELECT * INTO l_occ.* FROM occ_file WHERE occ01=g_oga.oga03
#   IF STATUS THEN CALL cl_err('s ccc',STATUS,1) LET g_success='N' RETURN END IF
#   IF l_occ.occ16 IS NULL THEN LET l_occ.occ16=g_oga.oga02 END IF
#   IF l_occ.occ173 IS NULL OR l_occ.occ173 < g_oga.oga02 THEN
#      LET l_occ.occ173=g_oga.oga02
#   END IF
#   UPDATE occ_file SET * = l_occ.* WHERE occ01=g_oga.oga03
#   IF STATUS THEN CALL cl_err('u ccc',STATUS,1) LET g_success='N' RETURN END IF
#END FUNCTION
# 
#FUNCTION t650_chk_img()
# DEFINE l_ogc  RECORD LIKE ogc_file.*,
#        l_img18       LIKE img_file.img18,   #MOD-A50013
#        l_oga02       LIKE oga_file.oga02    #MOD-A50013
##FUN-A90049 -------------start------------------------------------   
#    IF s_joint_venture( b_ogb.ogb04 ,g_plant) OR NOT s_internal_item( b_ogb.ogb04,g_plant ) THEN
#        RETURN
#    END IF
##FUN-A90049 --------------end-------------------------------------
#   #-----MOD-A50013---------
#   LET l_oga02 = NULL
#   SELECT oga02 INTO l_oga02 FROM oga_file
#     WHERE oga01 = b_ogb.ogb01
#   #-----END MOD-A50013-----
#
#   LET g_cnt=0
#   IF b_ogb.ogb17='Y' THEN   #多倉儲
#      DECLARE chk_ogc CURSOR FOR
#         SELECT *
#           FROM ogc_file
#          WHERE ogc01 = b_ogb.ogb01
#            AND ogc03 = b_ogb.ogb03
#      FOREACH chk_ogc INTO l_ogc.*
#         IF SQLCA.SQLCODE <>0 THEN EXIT FOREACH END IF
#         LET g_cnt=0
#         SELECT COUNT(*) INTO g_cnt FROM img_file
#             WHERE img01=b_ogb.ogb04 AND img02=l_ogc.ogc09
#               AND img03 = l_ogc.ogc091
#               AND img04 = l_ogc.ogc092
#         IF g_cnt=0 THEN
#           #CALL cl_err('part+lot:','axm-244',0)       #CHI-A10002 mark
#            CALL cl_err(b_ogb.ogb04,'axm-244',0)       #CHI-A10002 add
#            LET g_success = 'N'
#            EXIT FOREACH
#         END IF
#         #-----MOD-A50013---------
#         LET l_img18 = NULL
#         SELECT img18 INTO l_img18 FROM img_file
#             WHERE img01=b_ogb.ogb04 AND img02=l_ogc.ogc09
#               AND img03 = l_ogc.ogc091
#               AND img04 = l_ogc.ogc092
#         IF l_img18 < l_oga02 THEN
#            CALL cl_err(b_ogb.ogb04,'aim-400',1) 
#            LET g_success = 'N'
#            EXIT FOREACH
#         END IF 
#         #-----END MOD-A50013-----
#      END FOREACH
#   ELSE
#      SELECT COUNT(*) INTO g_cnt FROM img_file
#          WHERE img01=b_ogb.ogb04 AND img02=b_ogb.ogb09
#            AND img03 = b_ogb.ogb091
#            AND img04 = b_ogb.ogb092
#      IF g_cnt=0 THEN
#        #CALL cl_err('part+lot:','axm-244',0) LET g_success = 'N' RETURN    #CHI-A10002 mark
#         CALL cl_err(b_ogb.ogb04,'axm-244',0) LET g_success = 'N' RETURN    #CHI-A10002 add
#      END IF
#      #-----MOD-A50013---------
#      LET l_img18 = NULL
#      SELECT img18 INTO l_img18 FROM img_file
#          WHERE img01=b_ogb.ogb04 AND img02=b_ogb.ogb09
#            AND img03 = b_ogb.ogb091
#            AND img04 = b_ogb.ogb092
#      IF l_img18 < l_oga02 THEN
#         CALL cl_err(b_ogb.ogb04,'aim-400',1) 
#         LET g_success = 'N'
#         RETURN
#      END IF 
#      #-----END MOD-A50013-----
#   END IF
#END FUNCTION
# 
#FUNCTION t650_chk_imgg()
# DEFINE l_ogg     RECORD LIKE ogg_file.*
# DEFINE l_ima906  LIKE ima_file.ima906
#   LET g_cnt=0
#   SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01=b_ogb.ogb04
#   IF b_ogb.ogb17='Y' THEN   #多倉儲
#      DECLARE chk_ogg CURSOR FOR
#         SELECT *
#           FROM ogg_file
#          WHERE ogg01 = b_ogb.ogb01
#            AND ogg03 = b_ogb.ogb03
#      FOREACH chk_ogg INTO l_ogg.*
#         IF SQLCA.SQLCODE <>0 THEN EXIT FOREACH END IF
#         LET g_cnt=0
#         IF l_ima906 = '1' THEN
#            SELECT COUNT(*) INTO g_cnt FROM img_file
#             WHERE img01=b_ogb.ogb04 AND img02=l_ogg.ogg09
#               AND img03 = l_ogg.ogg091
#               AND img04 = l_ogg.ogg092
#            IF g_cnt=0 THEN
#              #CALL cl_err('part+lot:','axm-244',0)   #CHI-A10002 mark
#               CALL cl_err(b_ogb.ogb04,'axm-244',0)   #CHI-A10002 add
#               LET g_success = 'N'
#               EXIT FOREACH
#            END IF
#         END IF
#         IF l_ima906 = '2' THEN
#            SELECT COUNT(*) INTO g_cnt FROM imgg_file
#             WHERE imgg01=b_ogb.ogb04   AND imgg02=l_ogg.ogg09
#               AND imgg03=l_ogg.ogg091  AND imgg04=l_ogg.ogg092
#               AND imgg09=l_ogg.ogg10
#            IF g_cnt=0 THEN
#              #CALL cl_err('part+lot:','axm-244',0)    #CHI-A10002 mark
#               CALL cl_err(b_ogb.ogb04,'axm-244',0)    #CHI-A10002 add
#               LET g_success = 'N'
#               EXIT FOREACH
#            END IF
#         END IF
#         IF l_ima906 = '3' THEN
#            IF l_ogg.ogg20 = '1' THEN
#               SELECT COUNT(*) INTO g_cnt FROM img_file
#                WHERE img01=b_ogb.ogb04 AND img02=l_ogg.ogg09
#                  AND img03 = l_ogg.ogg091
#                  AND img04 = l_ogg.ogg092
#               IF g_cnt=0 THEN
#                 #CALL cl_err('part+lot:','axm-244',0)    #CHI-A10002 mark
#                  CALL cl_err(b_ogb.ogb04,'axm-244',0)    #CHI-A10002 add
#                  LET g_success = 'N'
#                 EXIT FOREACH
#               END IF
#            END IF
#            IF l_ogg.ogg20 = '2' THEN
#               SELECT COUNT(*) INTO g_cnt FROM imgg_file
#                WHERE imgg01=b_ogb.ogb04   AND imgg02=l_ogg.ogg09
#                  AND imgg03=l_ogg.ogg091  AND imgg04=l_ogg.ogg092
#                  AND imgg09=l_ogg.ogg10
#               IF g_cnt=0 THEN
#                 #CALL cl_err('part+lot:','axm-244',0)   #CHI-A10002 mark
#                  CALL cl_err(b_ogb.ogb04,'axm-244',0)   #CHI-A10002 add
#                  LET g_success = 'N'
#                  EXIT FOREACH
#               END IF
#            END IF
#         END IF
#      END FOREACH
#   ELSE
#      IF l_ima906 = '1' THEN
#         SELECT COUNT(*) INTO g_cnt FROM img_file
#          WHERE img01=b_ogb.ogb04 AND img02=b_ogb.ogb09
#            AND img03 = b_ogb.ogb091
#            AND img04 = b_ogb.ogb092
#         IF g_cnt=0 THEN
#           #CALL cl_err('part+lot:','axm-244',0) LET g_success = 'N' RETURN   #CHI-A10002 mark
#            CALL cl_err(b_ogb.ogb04,'axm-244',0) LET g_success = 'N' RETURN   #CHI-A10002 add
#         END IF
#      END IF
#      IF l_ima906 = '2' THEN
#         IF NOT cl_null(b_ogb.ogb910) THEN
#            SELECT COUNT(*) INTO g_cnt FROM imgg_file
#             WHERE imgg01 = b_ogb.ogb04  AND imgg02 = b_ogb.ogb09
#               AND imgg03 = b_ogb.ogb091 AND imgg04 = b_ogb.ogb092
#               AND imgg09 = b_ogb.ogb910
#            IF g_cnt=0 THEN
#              #CALL cl_err('part+lot:','axm-244',0) LET g_success = 'N' RETURN  #CHI-A10002 mark
#               CALL cl_err(b_ogb.ogb04,'axm-244',0) LET g_success = 'N' RETURN  #CHI-A10002 add
#            END IF
#         END IF
#         IF NOT cl_null(b_ogb.ogb913) THEN
#            SELECT COUNT(*) INTO g_cnt FROM imgg_file
#             WHERE imgg01 = b_ogb.ogb04  AND imgg02 = b_ogb.ogb09
#               AND imgg03 = b_ogb.ogb091 AND imgg04 = b_ogb.ogb092
#               AND imgg09 = b_ogb.ogb913
#            IF g_cnt=0 THEN
#              #CALL cl_err('part+lot:','axm-244',0) LET g_success = 'N' RETURN     #CHI-A10002 mark
#               CALL cl_err(b_ogb.ogb04,'axm-244',0) LET g_success = 'N' RETURN     #CHI-A10002 add
#            END IF
#         END IF
#      END IF
#   END IF
#END FUNCTION
# 
#FUNCTION t650_s(p_cmd) 			# when g_oga.ogapost='N' (Turn to 'Y')
#   DEFINE p_cmd         LIKE type_file.chr1  		# 1.不詢問 2.要詢問  #No.FUN-680137 VARCHAR(1)
#   DEFINE b_ogb         RECORD LIKE ogb_file.*  #No.FUN-610090
# 
#  #CHI-A50004 程式搬移 --start-- 
#   BEGIN WORK
# 
#   OPEN t650_cl USING g_oga.oga01
#   IF STATUS THEN
#      CALL cl_err("OPEN t650_cl:", STATUS, 1)
#      CLOSE t650_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
# 
#   FETCH t650_cl INTO g_oga.*
#   IF SQLCA.sqlcode THEN
#      CALL cl_err(g_oga.oga01,SQLCA.sqlcode,0)
#      CLOSE t650_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
#  #CHI-A50004 程式搬移 --end--
#
#   IF s_shut(0) THEN ROLLBACK WORK RETURN END IF #CHI-A50004 add ROLLBACK WORK
# 
#   SELECT * INTO g_oga.* FROM oga_file WHERE oga01 = g_oga.oga01
# 
#   IF g_oga.oga01 IS NULL THEN CALL cl_err('',-400,0) ROLLBACK WORK RETURN END IF #CHI-A50004 add ROLLBACK WORK
# 
#   IF g_oga.ogaconf='X' THEN CALL cl_err('conf=X',9024,0) ROLLBACK WORK RETURN END IF #No.+182 #CHI-A50004 add ROLLBACK WORK
# 
#   IF g_oga.ogaconf='N' THEN CALL cl_err('conf=N','axm-154',0) ROLLBACK WORK RETURN END IF #CHI-A50004 add ROLLBACK WORK
# 
#   IF g_oga.ogapost='Y' THEN ROLLBACK WORK RETURN END IF #CHI-A50004 add ROLLBACK WORK
# 
#   IF g_oaz.oaz03 = 'Y' AND
#      g_sma.sma53 IS NOT NULL AND g_oga.oga02 <= g_sma.sma53 THEN
#      CALL cl_err('','mfg9999',0)
#      ROLLBACK WORK #CHI-A50004 add
#      RETURN
#   END IF
# 
#   IF p_cmd='2' THEN
#      IF NOT cl_confirm('axm-152') THEN
#         ROLLBACK WORK #CHI-A50004 add
#         RETURN
#      END IF
#   END IF
# 
#  #CHI-A50004 程式搬移至FUNCTION一開始 mark --start--
#  #BEGIN WORK
#  #
#  #OPEN t650_cl USING g_oga.oga01
#  #IF STATUS THEN
#  #   CALL cl_err("OPEN t650_cl:", STATUS, 1)
#  #   CLOSE t650_cl
#  #   ROLLBACK WORK
#  #   RETURN
#  #END IF
#  #
#  #FETCH t650_cl INTO g_oga.*
#  #IF SQLCA.sqlcode THEN
#  #   CALL cl_err(g_oga.oga01,SQLCA.sqlcode,0)
#  #   CLOSE t650_cl
#  #   ROLLBACK WORK
#  #   RETURN
#  #END IF
#  #CHI-A50004 程式搬移至FUNCTION一開始 mark --end--
# 
#   LET g_success = 'Y'
#   UPDATE oga_file SET ogapost='Y' WHERE oga01=g_oga.oga01
# 
#   CALL t650_s1()
# 
#   IF sqlca.sqlcode THEN LET g_success='N' END IF
# 
#   IF g_success = 'Y' THEN
#      LET g_oga.ogapost='Y'
#      COMMIT WORK
#      CALL cl_flow_notify(g_oga.oga01,'S')
#      DISPLAY BY NAME g_oga.ogapost
#   ELSE
#      LET g_oga.ogapost='N'
#      ROLLBACK WORK
#   END IF
# 
#   IF g_success = 'Y' AND g_oaz.oaz62='Y' AND g_oga.oga08='1' THEN
#      CALL t650_gui()
#   END IF
# 
#   IF g_oga.ogapost = "N" THEN
#      DECLARE t650_s1_c2 CURSOR FOR SELECT * FROM ogb_file
#        WHERE ogb01 = g_oga.oga01
# 
#      LET g_imm01 = ""
#      LET g_success = "Y"
# 
#      CALL s_showmsg_init()   #No.FUN-6C0083 
# 
#      BEGIN WORK
# 
#      FOREACH t650_s1_c2 INTO b_ogb.*
#         IF STATUS THEN
#            LET g_success = 'N'                #No.FUN-8A0086
#            EXIT FOREACH
#         END IF
# 
#         IF g_sma.sma115 = 'Y' THEN
#            IF g_ima906 = '2' THEN  #子母單位
#               LET g_unit_arr[1].unit= b_ogb.ogb910
#               LET g_unit_arr[1].fac = b_ogb.ogb911
#               LET g_unit_arr[1].qty = b_ogb.ogb912
#               LET g_unit_arr[2].unit= b_ogb.ogb913
#               LET g_unit_arr[2].fac = b_ogb.ogb914
#               LET g_unit_arr[2].qty = b_ogb.ogb915
#               CALL s_dismantle(g_oga.oga01,b_ogb.ogb03,g_oga.oga02,
#                                b_ogb.ogb04,b_ogb.ogb09,b_ogb.ogb091,
#                                b_ogb.ogb092,g_unit_arr,g_imm01)
#                      RETURNING g_imm01
#                  IF g_success='N' THEN 
#                     LET g_totsuccess='N'
#                     LET g_success="Y"
#                     CONTINUE FOREACH   #No.FUN-6C0083
#                  END IF
#            END IF
#         END IF
#      END FOREACH
# 
#      IF g_totsuccess="N" THEN    #TQC-620156
#         LET g_success="N"
#      END IF
#      CALL s_showmsg()   #No.FUN-6C0083
# 
#      IF g_success = "Y" AND NOT cl_null(g_imm01) THEN
#         COMMIT WORK
#         LET g_msg="aimt324 '",g_imm01,"'"
#         CALL cl_cmdrun_wait(g_msg)
#      ELSE
#         ROLLBACK WORK
#      END IF
#   END IF
#   CALL cl_set_field_pic(g_oga.ogaconf,"",g_oga.ogapost,"",g_chr,"")
# 
#   MESSAGE ''
# 
#END FUNCTION
# 
#FUNCTION t650_gui()
#   IF g_oga.ogapost='N' THEN CALL cl_err('post=N','axm-206',0) RETURN END IF
#   LET g_msg="axrp310 ",
#             " '",g_oga.oga01,"'",
#             " '",g_oga.oga02,"'",
#             " '",g_oga.oga05,"' '",g_oga.oga212,"'"
#   CALL cl_cmdrun_wait(g_msg)  #FUN-660216 add
# 
#   SELECT * INTO g_oga.* FROM oga_file WHERE oga01=g_oga.oga01
#   DISPLAY BY NAME g_oga.oga24,g_oga.oga10
# 
#   LET g_buf=NULL
#   SELECT oma10 INTO g_buf FROM oma_file WHERE oma01=g_oga.oga10
#   DISPLAY g_buf TO oma10
#   LET g_buf=NULL
# 
#END FUNCTION
# 
#FUNCTION t650_s1()
#  DEFINE l_ogc  RECORD LIKE ogc_file.*
#  DEFINE l_flag LIKE type_file.chr1    #No:8741  #No.FUN-680137 VARCHAR(1)
#  DEFINE l_ima25  LIKE ima_file.ima25
#  DEFINE l_ima71  LIKE ima_file.ima71
#  DEFINE l_fac1,l_fac2 LIKE ogb_file.ogb15_fac
#  DEFINE l_cnt    LIKE type_file.num5    #No.FUN-680137 SMALLINT
#  DEFINE l_occ31  LIKE occ_file.occ31
#  DEFINE l_adq06  LIKE adq_file.adq06
#  DEFINE l_adq07  LIKE adq_file.adq07
#  DEFINE l_desc   LIKE type_file.chr1    #No.FUN-680137 VARCHAR(01)
#  DEFINE i        LIKE type_file.num5    #No.FUN-680137 SMALLINT
#  DEFINE l_ima906 LIKE ima_file.ima96
#  DEFINE l_ogg    RECORD LIKE ogg_file.*
# 
#  CALL s_showmsg_init()   #No.FUN-6C0083 
#  
#  DECLARE t650_s1_c CURSOR FOR
#   SELECT * FROM ogb_file WHERE ogb01=g_oga.oga01
# 
#  FOREACH t650_s1_c INTO b_ogb.*
#      IF STATUS THEN EXIT FOREACH END IF
#      MESSAGE '_s1() read no:',b_ogb.ogb03 USING '#####&','--> parts: ',
#               b_ogb.ogb04
# 
#      IF cl_null(b_ogb.ogb04) THEN CONTINUE FOREACH END IF
#      IF g_oaz.oaz03 = 'N' THEN CONTINUE FOREACH END IF
#      IF b_ogb.ogb04[1,4]='MISC' THEN CONTINUE FOREACH END IF
#      
#      
#      IF b_ogb.ogb17='Y' THEN     ##多倉儲出貨
#          SELECT SUM(ogc12) INTO tot1 FROM ogc_file WHERE ogc01=g_oga.oga01   #No.MOD-560095
#                                                     AND ogc03=b_ogb.ogb03
#          IF tot1 != b_ogb.ogb12  OR  cl_null(tot1) THEN #NO:3667   #No.MOD-560095
#                        		#多倉儲合計數量與產品項次不符
#            LET g_showmsg = g_oga.oga01,"/",b_ogb.ogb03
#            CALL s_errmsg('ogc01,ogc03',g_showmsg,'ogc12!=ogb12:','axm-172',1)
#            LET g_success='N' CONTINUE FOREACH
#         END IF
#         LET l_flag=''  #No:8741
#         DECLARE t650_s1_ogc_c CURSOR FOR  SELECT * FROM ogc_file
#           WHERE ogc01=g_oga.oga01 AND ogc03=b_ogb.ogb03
#         FOREACH t650_s1_ogc_c INTO l_ogc.*
#            IF SQLCA.SQLCODE THEN
#               LET g_showmsg =g_oga.oga01,"/",b_ogb.ogb03
#               CALL s_errmsg('ogc01,ogc03',g_showmsg,'Foreach s1_ogc:',SQLCA.SQLCODE,1)
#               LET g_success='N' EXIT FOREACH
#            END IF
#            MESSAGE '_s1() read ogc02:',b_ogb.ogb03,'-',l_ogc.ogc091
#            CALL t650_update(l_ogc.ogc09,l_ogc.ogc091,l_ogc.ogc092,
#                            l_ogc.ogc12,b_ogb.ogb05,l_ogc.ogc15_fac,l_ogc.ogc16,l_flag) #No:8741
#            LET l_flag='Y'  #No:8741
#            IF g_success='N' THEN 
#               LET g_totsuccess="N"
#               LET g_success="Y"
#               CONTINUE FOREACH   #No.FUN-6C0083
#            END IF
#         END FOREACH
#      ELSE
#         CALL t650_chk_ogb15_fac() IF g_success='N' THEN RETURN END IF   #No.TQC-750014 add
#         CALL t650_update(b_ogb.ogb09,b_ogb.ogb091,b_ogb.ogb092,
#                          b_ogb.ogb12,b_ogb.ogb05,b_ogb.ogb15_fac,b_ogb.ogb16,'')
#         IF g_success = 'N' THEN 
#            LET g_totsuccess="N"
#            LET g_success="Y"
#            CONTINUE FOREACH   #No.FUN-6C0083
#         END IF
#      END IF
#      IF g_sma.sma115 = 'Y' THEN
#         SELECT ima906 INTO l_ima906 FROM ima_file
#          WHERE ima01=b_ogb.ogb04
#         IF b_ogb.ogb17='Y' THEN     ##多倉儲出貨
#            DECLARE t650_s1_ogg_c CURSOR FOR  SELECT * FROM ogg_file
#              WHERE ogg01=g_oga.oga01 AND ogg03=b_ogb.ogb03
#              ORDER BY ogg20 DESC
#            FOREACH t650_s1_ogg_c INTO l_ogg.*
#               IF SQLCA.SQLCODE THEN
#                  CALL s_errmsg('','','Foreach s1_ogg:',SQLCA.SQLCODE,1)
#                  LET g_success='N' EXIT FOREACH
#               END IF
#               MESSAGE '_s1() read ogg02:',b_ogb.ogb03,'-',l_ogg.ogg091
#
#               #-----MOD-A20117---------
#               IF l_ima906 = '1' THEN
#                  CALL s_upimg_imgs(b_ogb.ogb04,l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,-1,g_oga.oga01,b_ogb.ogb03,l_ogg.ogg10,'2')  
#               END IF
#               #-----END MOD-A20117-----
#               IF l_ima906 = '2' THEN
#                  IF NOT cl_null(l_ogg.ogg10) THEN
#                     CALL t650_upd_imgg('1',b_ogb.ogb04,l_ogg.ogg09,
#                                        l_ogg.ogg091,l_ogg.ogg092,
#                                        l_ogg.ogg10,1,l_ogg.ogg12,-1,'1')
#                     IF g_success = 'N' THEN 
#                        LET g_totsuccess="N"
#                        LET g_success="Y"
#                        CONTINUE FOREACH   #No.FUN-6C0083
#                     END IF
#                     CALL s_upimg_imgs(b_ogb.ogb04,l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,-1,g_oga.oga01,b_ogb.ogb03,l_ogg.ogg10,'2')   #MOD-A20117  
#                     IF NOT cl_null(l_ogg.ogg12) AND l_ogg.ogg12 <> 0 THEN
#                        CALL t650_tlff(l_ogg.ogg20,b_ogb.ogb04,l_ogg.ogg09,l_ogg.ogg091,
#                                       l_ogg.ogg092,l_ogg.ogg10,1,l_ogg.ogg12)
#                        IF g_success = 'N' THEN 
#                           LET g_totsuccess="N"
#                           LET g_success="Y"
#                           CONTINUE FOREACH   #No.FUN-6C0083
#                        END IF
#                     END IF
#                  END IF
#               END IF
#               IF l_ima906 = '3' THEN
#                  IF l_ogg.ogg20 = '2' THEN
#                     CALL t650_upd_imgg('2',b_ogb.ogb04,l_ogg.ogg09,
#                                        l_ogg.ogg091,l_ogg.ogg092,
#                                        l_ogg.ogg10,1,l_ogg.ogg12,-1,'2')
#                     IF g_success = 'N' THEN RETURN END IF
#                     CALL s_upimg_imgs(b_ogb.ogb04,l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,-1,g_oga.oga01,b_ogb.ogb03,l_ogg.ogg10,'2')   #MOD-A20117  
#                     IF NOT cl_null(l_ogg.ogg12) AND l_ogg.ogg12 <> 0 THEN
#                        CALL t650_tlff(l_ogg.ogg20,b_ogb.ogb04,l_ogg.ogg09,l_ogg.ogg091,
#                                       l_ogg.ogg092,l_ogg.ogg10,1,l_ogg.ogg12)
#                        IF g_success = 'N' THEN 
#                           LET g_totsuccess="N"
#                           LET g_success="Y"
#                           CONTINUE FOREACH   #No.FUN-6C0083
#                        END IF
#                     END IF
#                   END IF
#               END IF
#               IF g_success='N' THEN RETURN END IF
#            END FOREACH
#         ELSE
#            IF l_ima906 = '2' THEN
#               IF NOT cl_null(b_ogb.ogb913) THEN
#                  CALL t650_upd_imgg('1',b_ogb.ogb04,b_ogb.ogb09,b_ogb.ogb091,
#                                     b_ogb.ogb092,b_ogb.ogb913,b_ogb.ogb914,
#                                     b_ogb.ogb915,-1,'2')
#                  IF g_success='N' THEN 
#                     LET g_totsuccess="N"
#                     LET g_success="Y"
#                     CONTINUE FOREACH   #No.FUN-6C0083
#                  END IF
#                  IF NOT cl_null(b_ogb.ogb915) THEN                                         #CHI-860005
#                     CALL t650_tlff('2',b_ogb.ogb04,b_ogb.ogb09,b_ogb.ogb091,b_ogb.ogb092,
#                                    b_ogb.ogb913,b_ogb.ogb914,b_ogb.ogb915)
#                     IF g_success='N' THEN 
#                        LET g_totsuccess="N"
#                        LET g_success="Y"
#                        CONTINUE FOREACH   #No.FUN-6C0083
#                     END IF
#                  END IF
#               END IF
#               IF NOT cl_null(b_ogb.ogb910) THEN
#                  CALL t650_upd_imgg('1',b_ogb.ogb04,b_ogb.ogb09,b_ogb.ogb091,
#                                     b_ogb.ogb092,b_ogb.ogb910,b_ogb.ogb911,
#                                     b_ogb.ogb912,-1,'1')
#                  IF g_success='N' THEN 
#                     LET g_totsuccess="N"
#                     LET g_success="Y"
#                     CONTINUE FOREACH   #No.FUN-6C0083
#                  END IF
#                  IF NOT cl_null(b_ogb.ogb912) THEN                                       #CHI-860005     
#                     CALL t650_tlff('1',b_ogb.ogb04,b_ogb.ogb09,b_ogb.ogb091,b_ogb.ogb092,
#                                    b_ogb.ogb910,b_ogb.ogb911,b_ogb.ogb912)
#                     IF g_success='N' THEN 
#                        LET g_totsuccess="N"
#                        LET g_success="Y"
#                        CONTINUE FOREACH   #No.FUN-6C0083
#                     END IF
#                  END IF
#               END IF
#            END IF
#            IF l_ima906 = '3' THEN
#               IF NOT cl_null(b_ogb.ogb913) THEN
#                  CALL t650_upd_imgg('2',b_ogb.ogb04,b_ogb.ogb09,b_ogb.ogb091,
#                                     b_ogb.ogb092,b_ogb.ogb913,b_ogb.ogb914,
#                                     b_ogb.ogb915,-1,'2')
#                  IF g_success='N' THEN 
#                     LET g_totsuccess="N"
#                     LET g_success="Y"
#                     CONTINUE FOREACH   #No.FUN-6C0083
#                  END IF
#                  IF NOT cl_null(b_ogb.ogb915) THEN                                       #CHI-860005
#                     CALL t650_tlff('2',b_ogb.ogb04,b_ogb.ogb09,b_ogb.ogb091,b_ogb.ogb092,
#                                    b_ogb.ogb913,b_ogb.ogb914,b_ogb.ogb915)
#                     IF g_success='N' THEN 
#                        LET g_totsuccess="N"
#                        LET g_success="Y"
#                        CONTINUE FOREACH   #No.FUN-6C0083
#                     END IF
#                  END IF
#               END IF
#            END IF
#         END IF
#      END IF
#      IF g_success='N' THEN RETURN END IF
#      SELECT occ31 INTO l_occ31 FROM occ_file WHERE occ01=g_oga.oga03
#      IF cl_null(l_occ31) THEN LET l_occ31='N' END IF
#       IF l_occ31 = 'N' THEN CONTINUE FOREACH END IF    #occ31=.w&s:^2z'_  NO.MOD-4B0070
#      SELECT ima25,ima71 INTO l_ima25,l_ima71
#        FROM ima_file WHERE ima01=b_ogb.ogb04
#      IF cl_null(l_ima71) THEN LET l_ima71=0 END IF
#      SELECT COUNT(*) INTO i FROM adq_file
#       WHERE adq01=g_oga.oga03  AND adq02=b_ogb.ogb04
#         AND adq03=b_ogb.ogb092 AND adq04=g_oga.oga02
#      IF i=0 THEN
#         LET l_fac1=1
#         IF b_ogb.ogb05 <> l_ima25 THEN
#            CALL s_umfchk(b_ogb.ogb04,b_ogb.ogb05,l_ima25)
#                 RETURNING l_cnt,l_fac1
#            IF l_cnt = '1'  THEN
#               CALL s_errmsg('','',b_ogb.ogb04,'abm-731',1)
#               LET l_fac1=1
#            END IF
#         END IF
#         INSERT INTO adq_file(adq01,adq02,adq03,adq04,adq05,
#                              adq06,adq07,adq08,adq09,adq10)
#         VALUES(g_oga.oga03,b_ogb.ogb04,b_ogb.ogb092,g_oga.oga02,g_oga.oga01,
#                b_ogb.ogb05,b_ogb.ogb12,l_fac1,b_ogb.ogb12*l_fac1,'1')
#         IF SQLCA.sqlcode THEN
#            CALL s_errmsg('','','insert adq_file',SQLCA.sqlcode,1)
#            LET g_success ='N'
#            CONTINUE FOREACH
#         END IF
#      ELSE
#         SELECT UNIQUE adq06 INTO l_adq06 FROM adq_file
#          WHERE adq01=g_oga.oga03  AND adq02=b_ogb.ogb04
#            AND adq03=b_ogb.ogb092 AND adq04=g_oga.oga02
#         #&],0key-H*:-l&],&P$@KEY-H*:%u/`+O/d$@-S-l)l3f&l
#         IF SQLCA.sqlcode THEN
#            LET g_showmsg = g_oga.oga03,"/",b_ogb.ogb04,"/",b_ogb.ogb092,"/",g_oga.oga02
#            CALL s_errmsg('adq01,adq02,adq03,adq04',g_showmsg,'select adq06',SQLCA.sqlcode,1)
#            LET g_success ='N'
#            CONTINUE FOREACH
#         END IF
#         LET l_fac1=1
#         IF b_ogb.ogb05 <> l_adq06 THEN
#            CALL s_umfchk(b_ogb.ogb04,b_ogb.ogb05,l_adq06)
#                 RETURNING l_cnt,l_fac1
#            IF l_cnt = '1'  THEN
#               CALL s_errmsg('','',b_ogb.ogb04,'abm-731',0)
#               LET l_fac1=1
#            END IF
#         END IF
#         SELECT adq07 INTO l_adq07 FROM adq_file
#          WHERE adq01=g_oga.oga03  AND adq02=b_ogb.ogb04
#            AND adq03=b_ogb.ogb092 AND adq04=g_oga.oga02
#         IF cl_null(l_adq07) THEN LET l_adq07=0 END IF
#         IF l_adq07+b_ogb.ogb12*l_fac1<0 THEN
#            LET l_desc='2'
#         ELSE
#            LET l_desc='1'
#         END IF
#         IF l_adq07+b_ogb.ogb12*l_fac1=0 THEN
#            DELETE FROM adq_file
#             WHERE adq01=g_oga.oga03  AND adq02=b_ogb.ogb04
#               AND adq03=b_ogb.ogb092 AND adq04=g_oga.oga02
#            IF SQLCA.sqlcode THEN
#               LET g_showmsg = g_oga.oga03,"/",b_ogb.ogb04,"/",b_ogb.ogb092,"/",g_oga.oga02 
#               CALL s_errmsg('adq01,adq02,adq03,adq04',g_showmsg,'delete adq_file',SQLCA.sqlcode,1)
#               LET g_success='N'
#               CONTINUE FOREACH
#            END IF
#         ELSE
#            LET l_fac2=1
#            IF l_adq06 <> l_ima25 THEN
#               CALL s_umfchk(b_ogb.ogb04,l_adq06,l_ima25)
#                    RETURNING l_cnt,l_fac2
#               IF l_cnt = '1'  THEN
#                  CALL cl_err(b_ogb.ogb04,'abm-731',1)
#                  LET l_fac2=1
#               END IF
#            END IF
#            UPDATE adq_file SET adq07=adq07+b_ogb.ogb12*l_fac1,
#                                adq09=adq09+b_ogb.ogb12*l_fac1*l_fac2,
#                                adq10=l_desc
#             WHERE adq01=g_oga.oga03  AND adq02=b_ogb.ogb04
#               AND adq03=b_ogb.ogb092 AND adq04=g_oga.oga02
#            IF SQLCA.sqlcode THEN
#               LET g_showmsg = g_oga.oga03,"/",b_ogb.ogb04,"/",b_ogb.ogb092,"/",g_oga.oga02
#               CALL s_errmsg('adq01,adq02,adq03,adq04',g_showmsg,'update adq_file',SQLCA.sqlcode,1)
#               LET g_success='N'
#               CONTINUE FOREACH
#            END IF
#         END IF
#      END IF
#      LET l_fac1=1
#      IF b_ogb.ogb05 <> l_ima25 THEN
#         CALL s_umfchk(b_ogb.ogb04,b_ogb.ogb05,l_ima25)
#              RETURNING l_cnt,l_fac1
#         IF l_cnt = '1'  THEN
#            CALL s_errmsg('','',b_ogb.ogb04,'abm-731',1)
#            LET l_fac1=1
#         END IF
#      END IF
#      SELECT COUNT(*) INTO i FROM adp_file
#       WHERE adp01=g_oga.oga03  AND adp02=b_ogb.ogb04
#         AND adp03=b_ogb.ogb092
#      IF i=0 THEN
#         INSERT INTO adp_file(adp01,adp02,adp03,adp04,adp05,adp06,adp07)
#         VALUES(g_oga.oga03,b_ogb.ogb04,b_ogb.ogb092,l_ima25,
#                b_ogb.ogb12*l_fac1,l_ima71+g_oga.oga02,g_oga.oga02)
#         IF SQLCA.sqlcode THEN
#            CALL s_errmsg('','','insert adp_file',SQLCA.sqlcode,1)
#            LET g_success='N'
#            CONTINUE FOREACH
#         END IF
#      ELSE
#         UPDATE adp_file SET adp05=adp05+b_ogb.ogb12*l_fac1
#          WHERE adp01=g_oga.oga03  AND adp02=b_ogb.ogb04
#            AND adp03=b_ogb.ogb092
#         IF SQLCA.sqlcode THEN
#            LET g_showmsg = g_oga.oga03,"/",b_ogb.ogb04,"/",b_ogb.ogb04
#            CALL s_errmsg('adp01,adp02,adp03',g_showmsg,'update adq_file',SQLCA.sqlcode,1)
#            LET g_success='N'
#            CONTINUE FOREACH
#         END IF
#      END IF
# 
#      IF g_success='N' THEN RETURN END IF
# 
#  END FOREACH
#  
#  IF g_totsuccess="N" THEN
#     LET g_success="N"
#  END IF
#  CALL s_showmsg()   #No.FUN-6C0083
# 
#END FUNCTION
# 
#FUNCTION t650_update(p_ware,p_loca,p_lot,p_qty,p_uom,p_factor,p_qty2,p_flag) #No:8741
#  DEFINE p_ware   LIKE ogb_file.ogb09,       ##倉庫
#         p_loca   LIKE ogb_file.ogb091,      ##儲位
#         p_lot    LIKE ogb_file.ogb092,      ##批號
#         p_qty    LIKE ogc_file.ogc12,       ##銷售數量(銷售單位)
#         p_qty2   LIKE ogc_file.ogc16,       ##銷售數量(img 單位)
#         p_uom    LIKE ima_file.ima31,            ##銷售單位
#         p_factor LIKE ogb_file.ogb15_fac,  ##轉換率
#         p_flag   LIKE type_file.chr1,     #No:8741  #No.FUN-680137 VARCHAR(1)
#         l_qty    LIKE ogc_file.ogc12,
#         l_ima01  LIKE ima_file.ima01,
#         l_ima25  LIKE ima_file.ima01,
#         l_img RECORD
#               l_img01   LIKE img_file.img01,   #No.FUN-680137 INT    #No.TQC-940183  #No.TQC-950134
#               img10   LIKE img_file.img10,
#               img16   LIKE img_file.img16,
#               img23   LIKE img_file.img23,
#               img24   LIKE img_file.img24,
#               img09   LIKE img_file.img09,
#               img21   LIKE img_file.img21,
#               img18   LIKE img_file.img18   #MOD-A50013
#               END RECORD,
#         l_cnt  LIKE type_file.num5,   #No.FUN-680137 SMALLINT
#         l_oga02 LIKE oga_file.oga02   #MOD-A50013
# 
#    IF cl_null(p_ware) THEN LET p_ware=' ' END IF
#    IF cl_null(p_loca) THEN LET p_loca=' ' END IF
#    IF cl_null(p_lot)  THEN LET p_lot=' ' END IF
#    IF cl_null(p_qty)  THEN LET p_qty=0 END IF
#    IF cl_null(p_qty2) THEN LET p_qty2=0 END IF
# 
#    IF p_uom IS NULL THEN
#       CALL cl_err('p_uom null:','axm-186',1) LET g_success = 'N' RETURN
#    END IF
# 
#    LET g_forupd_sql = "SELECT img01,img10,img16,img23,img24,img09,img21,img18 ",   #MOD-A50013 add img18
#                       " FROM img_file ",
#                       "   WHERE img01= ?  AND img02 = ? AND img03= ? ",
#                       "   AND img04= ?  FOR UPDATE "
#    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
#    DECLARE img_lock CURSOR FROM g_forupd_sql
# 
#    OPEN img_lock USING b_ogb.ogb04,p_ware,p_loca,p_lot
#    IF STATUS THEN
#       CALL cl_err("OPEN img_lock:", STATUS, 1)
#       CLOSE img_lock
#       LET g_success='N' RETURN
#       RETURN
#    END IF
# 
#    FETCH img_lock INTO l_img.*
#    IF STATUS THEN
#       CALL cl_err('lock img fail',STATUS,1)
#       CLOSE img_lock
#       LET g_success='N' RETURN
#    END IF
#
#    #-----MOD-A50013---------
#    LET l_oga02 = NULL
#    SELECT oga02 INTO l_oga02 FROM oga_file 
#      WHERE oga01 = b_ogb.ogb01
#    IF l_img.img18 < l_oga02 THEN
#       CALL cl_err(b_ogb.ogb04,'aim-400',1)  
#       LET g_success='N' RETURN
#    END IF
#    #-----END MOD-A50013-----
# 
#    IF cl_null(l_img.img10) THEN LET l_img.img10=0 END IF
# 
#    LET l_qty= l_img.img10 - p_qty2
#    IF NOT s_stkminus(b_ogb.ogb04,p_ware,p_loca,p_lot,
#                      p_qty,b_ogb.ogb15_fac,g_oga.oga02,g_sma.sma894[2,2]) THEN
#       LET g_success='N'
#       RETURN
#    END IF
# 
#    CALL s_upimg(b_ogb.ogb04,p_ware,p_loca,p_lot,-1,p_qty2,g_today, #FUN-8C0084
#          '','','','',b_ogb.ogb01,b_ogb.ogb03,'','','','','','','','','','','','')  #No.FUN-810036
#    IF g_success='N' THEN
#       CALL cl_err('s_upimg()','9050',0) RETURN
#    END IF
# 
# 
#    LET g_forupd_sql = "SELECT ima25,ima86 FROM ima_file ",
#                       " WHERE ima01= ?  FOR UPDATE"
#    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
#    DECLARE ima_lock CURSOR FROM g_forupd_sql
# 
#    OPEN ima_lock USING b_ogb.ogb04
#    IF STATUS THEN
#       CALL cl_err("OPEN ima_lock:", STATUS, 1)
#       LET g_success='N'
#       CLOSE ima_lock
#       RETURN
#    END IF
# 
#    FETCH ima_lock INTO l_ima25,g_ima86
#    IF STATUS THEN
#       CALL cl_err('lock ima fail',STATUS,1)
#       LET g_success='N'
#       CLOSE ima_lock
#       RETURN
#    END IF
# 
#   #料件編號 是否可用倉儲 是否為MRP可用倉儲 發料量
#    Call s_udima(b_ogb.ogb04,l_img.img23,l_img.img24,p_qty2*l_img.img21,
#                 g_oga.oga02,-1)  RETURNING l_cnt   #MOD-920298
#         #最近一次發料日期 表發料
#    IF l_cnt THEN
#       CALL cl_err('Update Faile',SQLCA.SQLCODE,1)
#       LET g_success='N' RETURN
#    END IF
# 
#    IF g_success='Y' THEN
#       CALL t650_tlf(p_ware,p_loca,p_lot,l_ima25,p_qty,l_qty,p_uom,p_factor,p_flag) #No:8741
#    END IF
# 
#END FUNCTION
# 
#FUNCTION t650_tlf(p_ware,p_loca,p_lot,p_unit,p_qty,p_img10,p_uom,p_factor,p_flag) #No:8741
#   DEFINE
#      p_ware  LIKE ogb_file.ogb09,       ##倉庫
#      p_loca  LIKE ogb_file.ogb091,      ##儲位
#      p_lot   LIKE ogb_file.ogb092,      ##批號
#      p_qty   LIKE tlf_file.tlf10,       #No.FUN-680137 DECIMAL (11,3)   ##銷售數量(銷售單位)
#      p_uom   LIKE ima_file.ima31,       ##銷售單位
#      p_factor LIKE ogb_file.ogb15_fac,  ##轉換率
#      p_unit  LIKE ima_file.ima25,       ##單位
#      p_img10    LIKE img_file.img10,   #異動後數量
#      l_sfb02    LIKE sfb_file.sfb02,
#      l_sfb03    LIKE sfb_file.sfb03,
#      l_sfb04    LIKE sfb_file.sfb04,
#      l_sfb22    LIKE sfb_file.sfb22,
#      l_sfb27    LIKE sfb_file.sfb27,
#      l_sta      LIKE type_file.num5,    #No.FUN-680137 SMALLINT
#      g_cnt      LIKE type_file.num5,    #No.FUN-680137 SMALLINT
#      p_flag     LIKE type_file.chr1      #No.8741  #No.FUN-680137 VARCHAR(1)
# 
#   #----來源----
#   LET g_tlf.tlf01=b_ogb.ogb04         #異動料件編號
#   LET g_tlf.tlf02=50                  #'Stock'
#   LET g_tlf.tlf020=b_ogb.ogb08
#   LET g_tlf.tlf021=p_ware             #倉庫
#   LET g_tlf.tlf022=p_loca             #儲位
#   LET g_tlf.tlf023=p_lot              #批號
#   LET g_tlf.tlf024=p_img10            #異動後數量
#   LET g_tlf.tlf025=p_unit             #庫存單位(ima_file or img_file)
#   LET g_tlf.tlf026=b_ogb.ogb01        #出貨單號
#   LET g_tlf.tlf027=b_ogb.ogb03        #出貨項次
#   #---目的----
#   LET g_tlf.tlf03=724
#   LET g_tlf.tlf030=' '
#   LET g_tlf.tlf031=' '                #倉庫
#   LET g_tlf.tlf032=' '                #儲位
#   LET g_tlf.tlf033=' '                #批號
#   LET g_tlf.tlf034=' '                #異動後庫存數量
#   LET g_tlf.tlf035=' '                #庫存單位(ima_file or img_file)
#   LET g_tlf.tlf036=b_ogb.ogb01        #出貨單號
#   LET g_tlf.tlf037=b_ogb.ogb03        #出貨項次
#   #-->異動數量
#   LET g_tlf.tlf04= ' '             #工作站
#   LET g_tlf.tlf05= ' '             #作業序號
#   LET g_tlf.tlf06=g_oga.oga02      #發料日期
#   LET g_tlf.tlf07=g_today          #異動資料產生日期
#   LET g_tlf.tlf08=TIME             #異動資料產生時:分:秒
#   LET g_tlf.tlf09=g_user           #產生人
#   LET g_tlf.tlf10=p_qty            #異動數量
#   LET g_tlf.tlf11=p_uom			#發料單位
#   LET g_tlf.tlf12 =p_factor        #發料/庫存 換算率
#   LET g_tlf.tlf13='axmt650'
#   LET g_tlf.tlf14=b_ogb.ogb1001     #異動原因   #MOD-940187   
# 
#   LET g_tlf.tlf17=' '              #非庫存性料件編號
# 
#   CALL s_imaQOH(b_ogb.ogb04) RETURNING g_tlf.tlf18
# 
#   LET g_tlf.tlf19=g_oga.oga04
#   LET g_tlf.tlf20 = ' '
#   LET g_tlf.tlf61= g_ima86
#   LET g_tlf.tlf62= ' '
#   LET g_tlf.tlf63= ' '
#   LET g_tlf.tlf66= p_flag  #No:8741
#   LET g_tlf.tlf930=b_ogb.ogb930 #FUN-670063
#   CALL s_tlf(1,0)
# 
#END FUNCTION
# 
#FUNCTION t650_upd_imgg(p_imgg00,p_imgg01,p_imgg02,p_imgg03,p_imgg04,
#                       p_imgg09,p_imgg211,p_imgg10,p_type,p_no)
#  DEFINE p_imgg00   LIKE imgg_file.imgg00,
#         p_imgg01   LIKE imgg_file.imgg01,
#         p_imgg02   LIKE imgg_file.imgg02,
#         p_imgg03   LIKE imgg_file.imgg03,
#         p_imgg04   LIKE imgg_file.imgg04,
#         p_imgg09   LIKE imgg_file.imgg09,
#         p_imgg211  LIKE imgg_file.imgg211,
#         p_no       LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(01)
#         l_ima25    LIKE ima_file.ima25,
#         l_ima906   LIKE ima_file.ima906,
#         l_imgg21   LIKE imgg_file.imgg21,
#         p_imgg10   LIKE imgg_file.imgg10,
#         l_imgg01    LIKE imgg_file.imgg01,   #No.FUN-680137 INT # saki 20070821 rowid chr18 -> num10 
#         p_type     LIKE type_file.num10   #No.FUN-680137 INTEGER
# 
#    LET g_forupd_sql =
#        "SELECT imgg01 FROM imgg_file ",
#        "   WHERE imgg01= ?  AND imgg02= ? AND imgg03= ? AND imgg04= ? ",
#        "   AND imgg09= ? FOR UPDATE "
# 
#    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
#    DECLARE imgg_lock CURSOR FROM g_forupd_sql
# 
#    OPEN imgg_lock USING p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09
#    IF STATUS THEN
#       CALL cl_err("OPEN imgg_lock:", STATUS, 1)
#       LET g_success='N'
#       CLOSE imgg_lock
#       RETURN
#    END IF
#    FETCH imgg_lock INTO l_imgg01
#    IF STATUS THEN
#       CALL cl_err('lock imgg fail',STATUS,1)
#       LET g_success='N'
#       CLOSE imgg_lock
#       RETURN
#    END IF
#    SELECT ima25,ima906 INTO l_ima25,l_ima906
#      FROM ima_file WHERE ima01=p_imgg01
#    IF SQLCA.sqlcode OR l_ima25 IS NULL THEN
#       CALL cl_err3("sel","ima_file",p_imgg01,"",SQLCA.sqlcode,"","ima25 null",1)  #No.FUN-660167
#       LET g_success = 'N' RETURN
#    END IF
# 
#    CALL s_umfchk(p_imgg01,p_imgg09,l_ima25)
#          RETURNING g_cnt,l_imgg21
#    IF g_cnt = 1 AND NOT (l_ima906='3' AND p_no='2') THEN
#       #CALL cl_err('','mfg3075',0)   #MOD-A20043  
#       CALL cl_err(b_ogb.ogb03,'mfg3075',0)   #MOD-A20043  
#       LET g_success = 'N' RETURN
#    END IF
# 
#    CALL s_upimgg(p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,p_type,p_imgg10,g_oga.oga02, #FUN-8C0084
#          '','','','','','','','','','',l_imgg21,'','','','','','','',p_imgg211)
#    IF g_success='N' THEN RETURN END IF
# 
#END FUNCTION
# 
#FUNCTION t650_tlff(p_flag,p_item,p_ware,p_loc,p_lot,p_unit,p_fac,p_qty)
#DEFINE
#   p_flag     LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
#   p_item     LIKE ima_file.ima01,
#   p_ware     LIKE img_file.img02,
#   p_loc      LIKE img_file.img03,
#   p_lot      LIKE img_file.img04,
#   p_unit     LIKE img_file.img09,
#   p_fac      LIKE img_file.img21,
#   p_qty      LIKE img_file.img10,
#   p_lineno   LIKE ogb_file.ogb03,
#   l_imgg10   LIKE imgg_file.imgg10
# 
#   INITIALIZE g_tlff.* TO NULL
#   SELECT imgg10 INTO l_imgg10 FROM imgg_file
#    WHERE imgg01=p_item  AND imgg02=p_ware
#      AND imgg03=p_loc   AND imgg04=p_lot
#      AND imgg09=p_unit
#   IF cl_null(l_imgg10) THEN LET l_imgg10=0 END IF
# 
#   #----來源----
#   LET g_tlff.tlff01=p_item              #異動料件編號
#   LET g_tlff.tlff02=50                  #'Stock'
#   LET g_tlff.tlff020=b_ogb.ogb08
#   LET g_tlff.tlff021=p_ware             #倉庫
#   LET g_tlff.tlff022=p_loc              #儲位
#   LET g_tlff.tlff023=p_lot              #批號
#   LET g_tlff.tlff024=l_imgg10           #異動後數量
#   LET g_tlff.tlff025=p_unit             #庫存單位(ima_file or img_file)
#   LET g_tlff.tlff026=g_oga.oga01        #出貨單號
#   LET g_tlff.tlff027=b_ogb.ogb03        #出貨項次
#   #---目的----
#   LET g_tlff.tlff03=724
#   LET g_tlff.tlff030=' '
#   LET g_tlff.tlff031=' '                #倉庫
#   LET g_tlff.tlff032=' '                #儲位
#   LET g_tlff.tlff033=' '                #批號
#   LET g_tlff.tlff034=' '                #異動後庫存數量
#   LET g_tlff.tlff035=' '                #庫存單位(ima_file or img_file)
#   LET g_tlff.tlff036=g_oga.oga01        #訂單單號
#   LET g_tlff.tlff037=b_ogb.ogb03        #訂單項次
# 
#   #-->異動數量
#   LET g_tlff.tlff04= ' '             #工作站
#   LET g_tlff.tlff05= ' '             #作業序號
#   LET g_tlff.tlff06=g_oga.oga02      #發料日期
#   LET g_tlff.tlff07=g_today          #異動資料產生日期
#   LET g_tlff.tlff08=TIME             #異動資料產生時:分:秒
#   LET g_tlff.tlff09=g_user           #產生人
#   LET g_tlff.tlff10=p_qty            #異動數量
#   LET g_tlff.tlff11=p_unit           #發料單位
#   LET g_tlff.tlff12=p_fac            #發料/庫存 換算率
#   LET g_tlff.tlff13='axmt650'
#   LET g_tlff.tlff14=' '              #異動原因
# 
#   LET g_tlff.tlff17=' '              #非庫存性料件編號
#   CALL s_imaQOH(b_ogb.ogb04)
#        RETURNING g_tlff.tlff18
#   LET g_tlff.tlff19 =g_oga.oga04
#   LET g_tlff.tlff20 =' '
#   LET g_tlff.tlff61= g_ima86
#   LET g_tlff.tlff62=' '
#   LET g_tlff.tlff63=' '
#   LET g_tlff.tlff66=p_flag         #for axcp500多倉出貨處理   #No:8741
#   LET g_tlff.tlff930=b_ogb.ogb930  #FUN-670063
#   IF cl_null(b_ogb.ogb915) OR b_ogb.ogb915=0 THEN
#      CALL s_tlff(p_flag,NULL)
#   ELSE
#      CALL s_tlff(p_flag,b_ogb.ogb913)
#   END IF
#END FUNCTION
#FUN-B10004---mark---end---
 
 
#FUNCTION t650_x()        #FUN-D20025
FUNCTION t650_x(p_type)   #FUN-D20025
   DEFINE p_type    LIKE type_file.num5     #FUN-D20025
   DEFINE l_flag    LIKE type_file.chr1     #FUN-D20025
   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_oga.* FROM oga_file WHERE oga01=g_oga.oga01
   IF g_oga.oga01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_oga.ogaconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF

   #FUN-D20025--add--str--
   IF p_type = 1 THEN 
      IF g_oga.ogaconf='X' THEN RETURN END IF
   ELSE
      IF g_oga.ogaconf<>'X' THEN RETURN END IF
   END IF
   #FUN-D20025--add--end--
 
   BEGIN WORK
 
   OPEN t650_cl USING g_oga.oga01
   IF STATUS THEN
      CALL cl_err("OPEN t650_cl:", STATUS, 1)
      CLOSE t650_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t650_cl INTO g_oga.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_oga.oga01,SQLCA.sqlcode,0)
      CLOSE t650_cl ROLLBACK WORK RETURN
   END IF
 
   LET g_success='Y'
 
  #IF cl_void(0,0,g_oga.ogaconf) THEN       #FUN-D20025
   IF p_type = 1 THEN LET l_flag = 'N' ELSE LET l_flag = 'X' END IF  #FUN-D20025
   IF cl_void(0,0,l_flag) THEN         #FUN-D20025
       LET g_chr = g_oga.ogaconf
      #IF g_oga.ogaconf = 'N' THEN     #FUN-D20025
       IF p_type = 1 THEN              #FUN-D20025
           LET g_oga.ogaconf = 'X'
           UPDATE tus_file SET tus12 = 'N'  WHERE tus01 = g_oga.oga16  #CHI-820004 add
       ELSE
           LET g_oga.ogaconf = 'N'
           LET g_cnt = 0
           SELECT COUNT(*) INTO g_cnt FROM tus_file 
            WHERE tus01 = g_oga.oga16 AND tus12='Y'
           IF g_cnt > 0  THEN 
              CALL cl_err(g_oga.oga16,'atm-600',1)
              LET g_success = 'N'
           END IF 
           UPDATE tus_file SET tus12 = 'Y'  WHERE tus01 = g_oga.oga16  
       END IF
   END IF
   LET g_oga.ogamodu = g_user
   LET g_oga.ogadate = g_today
       UPDATE oga_file
          SET ogaconf = g_oga.ogaconf,
              ogamodu = g_user,
              ogadate = g_today
        WHERE oga01 = g_oga.oga01
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
       CALL cl_err3("upd","oga_file",g_oga.oga01,"",SQLCA.SQLCODE,"","upd ogaconf",1)  #No.FUN-660167
       LET g_success='N'
   END IF
 
  #FUN-B10016 add str ---------
   IF g_success='Y' THEN
     #若有與CRM整合,需回饋CRM單據狀態,表CRM可再重發出貨單
      IF NOT cl_null(g_oga.oga70) AND g_aza.aza123 MATCHES "[Yy]" THEN
         CALL aws_crmcli('x','restatus','2',g_oga.oga01,'2') RETURNING g_crmStatus,g_crmdesc
         IF g_crmStatus <> 0 THEN
            CALL cl_err(g_crmdesc,'!',1)
            LET g_success = 'N'
         END IF
      END IF
   END IF
  #FUN-B10016 add end ---------

   IF g_success='Y' THEN
      COMMIT WORK
 
      CALL cl_flow_notify(g_oga.oga01,'V')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT ogaconf INTO g_oga.ogaconf FROM oga_file WHERE oga01 = g_oga.oga01
   DISPLAY BY NAME g_oga.ogaconf,g_oga.ogamodu,g_oga.ogadate
    #CKP
    IF g_oga.ogaconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    CALL cl_set_field_pic(g_oga.ogaconf,"",g_oga.ogapost,"",g_chr,"")
 
END FUNCTION
 
#No.B325 010411 by linda
FUNCTION t650_c()
    IF s_shut(0) THEN RETURN END IF
    SELECT * INTO g_oga.* FROM oga_file WHERE oga01 = g_oga.oga01
    IF g_oga.oga01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_oga.ogaconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
    IF g_oga.oga54 != 0 THEN CALL cl_err('','axm-160',0) RETURN END IF
    MESSAGE ""
 
    BEGIN WORK
 
    OPEN t650_cl USING g_oga.oga01
    IF STATUS THEN
       CALL cl_err("OPEN t650_cl:", STATUS, 1)
       CLOSE t650_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t650_cl INTO g_oga.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_oga.oga01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t650_cl ROLLBACK WORK RETURN
    END IF
 
    UPDATE oga_file SET oga903='Y' WHERE oga01 = g_oga.oga01
 
    LET g_oga.oga903='Y'
 
    CLOSE t650_cl
    COMMIT WORK
    DISPLAY BY NAME g_oga.oga903
 
END FUNCTION
 
 
#用于default 雙單位/轉換率/數量
FUNCTION t650_du_default(p_cmd)
  DEFINE    l_item   LIKE img_file.img01,     #料號
            l_ware   LIKE img_file.img02,     #倉庫
            l_loc    LIKE img_file.img03,     #儲
            l_lot    LIKE img_file.img04,     #批
            l_ima25  LIKE ima_file.ima25,     #ima單位
            l_ima31  LIKE ima_file.ima31,     #ima單位
            l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_ima908 LIKE ima_file.ima907,
            l_img09  LIKE img_file.img09,     #img單位
            l_unit2  LIKE img_file.img09,     #第二單位
            l_fac2   LIKE img_file.img21,     #第二轉換率
            l_qty2   LIKE img_file.img10,     #第二數量
            l_unit1  LIKE img_file.img09,     #第一單位
            l_fac1   LIKE img_file.img21,     #第一轉換率
            l_qty1   LIKE img_file.img10,     #第一數量
            l_unit3  LIKE img_file.img09,     #第一單位
            l_qty3   LIKE img_file.img10,     #第一數量
            p_cmd    LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
            l_factor LIKE ima_file.ima31_fac  #No.FUN-680137 DECIMAL(16,8)
 
    LET l_item = g_ogb[l_ac].ogb04
    LET l_ware = g_ogb[l_ac].ogb09
    LET l_loc  = g_ogb[l_ac].ogb091
    LET l_lot  = g_ogb[l_ac].ogb092
 
    SELECT ima25,ima31,ima906,ima907,ima908                 #No.TQC-6B0124 add ima908
           INTO l_ima25,l_ima31,l_ima906,l_ima907,l_ima908  #No.TQC-6B0124 add ima908
      FROM ima_file WHERE ima01 = l_item
 
    IF g_sma.sma115 = 'Y' THEN       #No.TQC-6B0124 add
       IF l_ima906 = '1' THEN  #不使用雙單位
          LET l_unit2 = NULL
          LET l_fac2  = NULL
          LET l_qty2  = NULL
       ELSE
          LET l_unit2 = l_ima907
          CALL s_du_umfchk(l_item,'','','',l_ima31,l_ima907,l_ima906)
               RETURNING g_errno,l_factor
          LET l_fac2 = l_factor
          LET l_qty2  = 0
       END IF
       LET l_unit1 = l_ima31
       LET l_fac1  = 1
       LET l_qty1  = 0
    END IF              #No.TQC-6B0124 add
   
    IF g_sma.sma116 MATCHES '[01]' THEN    #No.FUN-610076
       LET l_unit3 = NULL
       LET l_qty3  = NULL
    ELSE
       LET l_unit3 = l_ima908
       LET l_qty3  = 0
    END IF
 
    IF p_cmd = 'a' THEN
       LET g_ogb[l_ac].ogb913=l_unit2
       LET g_ogb[l_ac].ogb914=l_fac2
       LET g_ogb[l_ac].ogb915=l_qty2
       LET g_ogb[l_ac].ogb910=l_unit1
       LET g_ogb[l_ac].ogb911=l_fac1
       LET g_ogb[l_ac].ogb912=l_qty1
       LET g_ogb[l_ac].ogb916=l_unit3
       LET g_ogb[l_ac].ogb917=l_qty3
    END IF
END FUNCTION
 
#對原來數量/換算率/單位的賦值
FUNCTION t650_set_origin_field()
  DEFINE    l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_img09  LIKE img_file.img09,     #img單位
            l_ima25  LIKE ima_file.ima25,
            l_ima31  LIKE ima_file.ima31,
            l_tot    LIKE img_file.img10,
            l_fac2   LIKE ogb_file.ogb914,
            l_qty2   LIKE ogb_file.ogb915,
            l_fac1   LIKE ogb_file.ogb911,
            l_qty1   LIKE ogb_file.ogb912,
            l_factor LIKE ima_file.ima31_fac  #No.FUN-680137 DECIMAL(16,8)
 
    IF g_sma.sma115='N' THEN RETURN END IF
    SELECT ima25,ima31 INTO l_ima25,l_ima31 FROM ima_file WHERE ima01=g_ogb[l_ac].ogb04
    IF SQLCA.sqlcode = 100 THEN
       IF g_ogb[l_ac].ogb04 MATCHES 'MISC*' THEN
          SELECT ima25,ima31 INTO l_ima25,l_ima31
            FROM ima_file WHERE ima01='MISC'
       END IF
    END IF
    IF cl_null(l_ima31) THEN LET l_ima31=l_ima25 END IF
 
    LET l_fac2=g_ogb[l_ac].ogb914
    LET l_qty2=g_ogb[l_ac].ogb915
    LET l_fac1=g_ogb[l_ac].ogb911
    LET l_qty1=g_ogb[l_ac].ogb912
 
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
 
    IF g_sma.sma115 = 'Y' THEN
       CASE g_ima906
          WHEN '1' LET g_ogb[l_ac].ogb05=g_ogb[l_ac].ogb910
                   LET g_ogb[l_ac].ogb12=l_qty1
          WHEN '2' LET l_tot=l_fac1*l_qty1+l_fac2*l_qty2
                   LET g_ogb[l_ac].ogb05=l_ima31
                   LET g_ogb[l_ac].ogb12=l_tot
          WHEN '3' LET g_ogb[l_ac].ogb05=g_ogb[l_ac].ogb910
                   LET g_ogb[l_ac].ogb12=l_qty1
                   IF l_qty2 <> 0 THEN
                      LET g_ogb[l_ac].ogb914=l_qty1/l_qty2
                   ELSE
                      LET g_ogb[l_ac].ogb914=0
                   END IF
       END CASE
    END IF
    LET g_factor = 1
    CALL s_umfchk(g_ogb[l_ac].ogb04,g_ogb[l_ac].ogb05,l_ima25)
          RETURNING g_cnt,g_factor
    IF g_cnt = 1 THEN
       LET g_factor = 1
    END IF
    LET b_ogb.ogb05_fac = g_factor

    #-----MOD-A70140---------
    IF g_sma.sma116 ='0' OR g_sma.sma116 ='1' THEN
       LET g_ogb[l_ac].ogb916 = g_ogb[l_ac].ogb05
       LET g_ogb[l_ac].ogb917 = g_ogb[l_ac].ogb12
    END IF
    #-----END MOD-A70140-----
 
END FUNCTION
 
#兩組雙單位資料不是一定要全部KEY,如果沒有KEY單位,則把換算率/數量清空
FUNCTION t650_du_data_to_correct()
 
   IF cl_null(g_ogb[l_ac].ogb913) THEN
      LET g_ogb[l_ac].ogb914 = NULL
      LET g_ogb[l_ac].ogb915 = NULL
   END IF
 
   IF cl_null(g_ogb[l_ac].ogb910) THEN
      LET g_ogb[l_ac].ogb911 = NULL
      LET g_ogb[l_ac].ogb912 = NULL
   END IF
 
   DISPLAY BY NAME g_ogb[l_ac].ogb913
   DISPLAY BY NAME g_ogb[l_ac].ogb914
   DISPLAY BY NAME g_ogb[l_ac].ogb915
   DISPLAY BY NAME g_ogb[l_ac].ogb910
   DISPLAY BY NAME g_ogb[l_ac].ogb911
   DISPLAY BY NAME g_ogb[l_ac].ogb912
END FUNCTION
 
FUNCTION t650_set_ogb917()
  DEFINE    l_item   LIKE img_file.img01,     #料號
            l_ima25  LIKE ima_file.ima25,     #ima單位
            l_ima31  LIKE ima_file.ima31,     #ima單位
            l_ima906 LIKE ima_file.ima906,
            l_fac2   LIKE img_file.img21,     #第二轉換率
            l_qty2   LIKE img_file.img10,     #第二數量
            l_fac1   LIKE img_file.img21,     #第一轉換率
            l_qty1   LIKE img_file.img10,     #第一數量
            l_tot    LIKE img_file.img10,     #計價數量
            l_factor LIKE ima_file.ima31_fac  #No.FUN-680137 DECIMAL(16,8)
 
    SELECT ima25,ima31,ima906 INTO l_ima25,l_ima31,l_ima906
      FROM ima_file WHERE ima01=g_ogb[l_ac].ogb04
    IF SQLCA.sqlcode = 100 THEN
       IF g_ogb[l_ac].ogb04 MATCHES 'MISC*' THEN
          SELECT ima25,ima31,ima906 INTO l_ima25,l_ima31,l_ima906
            FROM ima_file WHERE ima01='MISC'
       END IF
    END IF
    IF cl_null(l_ima31) THEN LET l_ima31=l_ima25 END IF
 
    LET l_fac2=g_ogb[l_ac].ogb914
    LET l_qty2=g_ogb[l_ac].ogb915
    IF g_sma.sma115 = 'Y' THEN
       LET l_fac1=g_ogb[l_ac].ogb911
       LET l_qty1=g_ogb[l_ac].ogb912
    ELSE
       LET l_fac1=1
       LET l_qty1=g_ogb[l_ac].ogb12
       CALL s_umfchk(g_ogb[l_ac].ogb04,g_ogb[l_ac].ogb05,l_ima31)
             RETURNING g_cnt,l_fac1
       IF g_cnt = 1 THEN
          LET l_fac1 = 1
       END IF
    END IF
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
 
    IF g_sma.sma115 = 'Y' THEN
       CASE l_ima906
          WHEN '1' LET l_tot=l_qty1*l_fac1
          WHEN '2' LET l_tot=l_qty1*l_fac1+l_qty2*l_fac2
          WHEN '3' LET l_tot=l_qty1*l_fac1
       END CASE
    ELSE  #不使用雙單位
       LET l_tot=l_qty1*l_fac1
    END IF
    IF cl_null(l_tot) THEN LET l_tot = 0 END IF
    LET l_factor = 1
    IF g_sma.sma115 = 'Y' THEN
       CALL s_umfchk(g_ogb[l_ac].ogb04,g_ogb[l_ac].ogb05,g_ogb[l_ac].ogb916)
             RETURNING g_cnt,l_factor
    ELSE
    CALL s_umfchk(g_ogb[l_ac].ogb04,l_ima31,g_ogb[l_ac].ogb916)
          RETURNING g_cnt,l_factor
    END IF                              #No.CHI-960052
    IF g_cnt = 1 THEN
       LET l_factor = 1
    END IF
    LET l_tot = l_tot * l_factor
 
    LET g_ogb[l_ac].ogb917 = l_tot
    IF g_ogb[l_ac].ogb05 = g_ogb[l_ac].ogb916 AND g_sma.sma115 = 'N' THEN 
       LET g_ogb[l_ac].ogb917 = g_ogb[l_ac].ogb12
    END IF 

    CALL t650_ogb14()   #MOD-A70140
END FUNCTION
 
FUNCTION t650_set_ogb06_entry()
 CALL cl_set_comp_entry("ogb06",TRUE)
#FUN-A60035 ---MARK BEGIN
##FUN-A50054---Begin
#IF s_industry("slk") THEN
#   CALL cl_set_comp_required("ogb12",TRUE)
#END IF 
##FUN-A50054---End
#FUN-A60035 ---MARK END
END FUNCTION
 
FUNCTION t650_set_ogb06_no_entry()
 CALL cl_set_comp_entry("ogb06",FALSE)
#FUN-A60035 ---MARK BEGIN
##FUN-A50054---Begin
#IF s_industry("slk") THEN
#   CALL cl_set_comp_required("ogb12",FALSE)
#END IF 
##FUN-A50054---End   
#FUN-A60035 ---MARK END
END FUNCTION
 
FUNCTION t650_def_form()
    CALL cl_set_comp_visible("ogb911,ogb914",FALSE)
    IF g_sma.sma115 ='N' THEN
       CALL cl_set_comp_visible("ogb913,ogb914,ogb915",FALSE)
       CALL cl_set_comp_visible("ogb910,ogb911,ogb912",FALSE)
    ELSE
       CALL cl_set_comp_visible("ogb05,ogb12",FALSE)
    END IF
    IF g_sma.sma116 MATCHES '[01]' THEN    #No.FUN-610076
       CALL cl_set_comp_visible("ogb916,ogb917",FALSE)
    END IF
    CALL cl_set_comp_visible("ogb41,ogb42,ogb43",g_aza.aza08='Y')  #FUN-810045 add
    IF g_sma.sma122 ='1' THEN
       CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ogb913",g_msg CLIPPED)
       CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ogb915",g_msg CLIPPED)
       CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ogb910",g_msg CLIPPED)
       CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ogb912",g_msg CLIPPED)
    END IF
    IF g_sma.sma122 ='2' THEN
       CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ogb913",g_msg CLIPPED)
       CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ogb915",g_msg CLIPPED)
       CALL cl_getmsg('asm-326',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ogb910",g_msg CLIPPED)
       CALL cl_getmsg('asm-327',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ogb912",g_msg CLIPPED)
    END IF
    CALL cl_set_comp_visible("ogb930,gem02c",g_aaz.aaz90='Y') #FUN-670063

   #FUN-B10016 add str ---------
    IF g_aza.aza123 MATCHES "[Yy]" THEN
       CALL cl_set_comp_visible("oga70",TRUE)
       CALL cl_set_comp_entry("oga70",FALSE)
       CALL cl_getmsg('aim-707',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("oga70",g_msg CLIPPED)
    ELSE
       CALL cl_set_comp_visible("oga70",FALSE)
    END IF
   #FUN-B10016 add end ---------
   #FUN-C50097 ADD BEGIN
    CALL cl_set_comp_visible("ogb50,ogb51",FALSE)
    IF g_aza.aza26 = '2'  AND g_oaz.oaz94 ='Y' THEN 
       IF g_sma.sma115='N' THEN
          CALL cl_set_comp_visible("ogb50,ogb51",TRUE) #FUN-C50097
       END IF 
    END IF   
   #FUN-C50097 ADD END       
END FUNCTION
 
#FUN-B10004---mark---str---
#FUNCTION t650_chk_ogb15_fac()
#DEFINE l_ogb15_fac   LIKE ogb_file.ogb15_fac
#DEFINE l_ogb15       LIKE ogb_file.ogb15
#DEFINE l_cnt         LIKE type_file.num5
# 
#  SELECT img09 INTO l_ogb15 FROM img_file
#        WHERE img01 = b_ogb.ogb04 AND img02 = b_ogb.ogb09
#          AND img03 = b_ogb.ogb091 AND img04 = b_ogb.ogb092
# 
#  CALL s_umfchk(b_ogb.ogb04,b_ogb.ogb05,l_ogb15)
#            RETURNING l_cnt,l_ogb15_fac
#  IF l_cnt = 1 THEN
#     #CALL cl_err('','mfg3075',1)   #MOD-A20043
#     CALL cl_err(b_ogb.ogb03,'mfg3075',1)   #MOD-A20043
#     LET g_success='N'   
#     RETURN
#  END IF
#  IF l_ogb15 != b_ogb.ogb15 OR 
#     l_ogb15_fac != b_ogb.ogb15_fac THEN
#     LET b_ogb.ogb15_fac = l_ogb15_fac
#     LET b_ogb.ogb15 = l_ogb15
#     LET b_ogb.ogb16 = b_ogb.ogb12 * l_ogb15_fac
#     
#     UPDATE ogb_file SET ogb15_fac=b_ogb.ogb15_fac,
#                         ogb16 =b_ogb.ogb16,
#                         ogb15 =b_ogb.ogb15
#           WHERE ogb01=g_oga.oga01
#             AND ogb03=b_ogb.ogb03
#     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#        CALL cl_err3("upd","ogb15_fac",g_oga.oga01,b_ogb.ogb03,SQLCA.sqlcode,"","",1) 
#        LET g_success='N'   
#        RETURN
#     END IF
#  END IF
#  RETURN
#END FUNCTION
#FUN-B10004---mark---str---

FUNCTION t650_rvbs()
   DEFINE b_rvbs  RECORD  LIKE rvbs_file.*
   DEFINE l_ima25         LIKE ima_file.ima25
   DEFINE l_fac           LIKE ogb_file.ogb05_fac
  
  
  #抓取庫存單位換算率，寫到rvbs_file一律以庫存單位計量
   SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01= g_ogb[l_ac].ogb04
   IF g_ogb[l_ac].ogb05=l_ima25 THEN
      LET l_fac = 1
   ELSE
      CALL s_umfchk(g_ogb[l_ac].ogb04,g_ogb[l_ac].ogb05,l_ima25)
           RETURNING g_cnt,l_fac
   END IF
   IF cl_null(l_fac) OR l_fac = 0  THEN
     #### ----庫存/料號無法轉換 -------###
     CALL cl_err('ogb05/ima25: ','abm-731',1)
     LET g_success ='N'
     RETURN
   END IF
   LET b_rvbs.rvbs00 = g_prog
   LET b_rvbs.rvbs01 = g_oga.oga01
   LET b_rvbs.rvbs02 = g_ogb[l_ac].ogb03
   LET b_rvbs.rvbs021 = g_ogb[l_ac].ogb04  #料號
   LET b_rvbs.rvbs06 = g_ogb[l_ac].ogb12 * l_fac  #數量*庫存單位換算率
   LET b_rvbs.rvbs08 = g_ogb[l_ac].ogb41
   LET b_rvbs.rvbs09 = -1
   CALL s_ins_rvbs("1",b_rvbs.*)
END FUNCTION
 
FUNCTION t650_b_get_price()
   DEFINE l_oah03       LIKE type_file.chr1                    #單價取價方式
   DEFINE l_ima131      LIKE ima_file.ima03                    #Product Type
   DEFINE l_ogb13       LIKE ogb_file.ogb13

   LET l_ogb13 = 0   #MOD-9A0140
   
   SELECT oah03 INTO l_oah03 FROM oah_file WHERE oah01 = g_oga.oga31
 
      CASE WHEN l_oah03 = '0'   #MOD-9A0140
           WHEN l_oah03 = '1'
                IF g_oga.oga213='Y' THEN   #含稅否
                   SELECT ima128 INTO l_ogb13 FROM ima_file 
                    WHERE ima01=g_ogb[l_ac].ogb04
                ELSE 
                   SELECT ima127 INTO l_ogb13 FROM ima_file 
                    WHERE ima01=g_ogb[l_ac].ogb04
                END IF
                #->將單價除上匯率
                LET l_ogb13=l_ogb13/g_oga.oga24
           WHEN l_oah03 = '2'
                IF cl_null(g_ogb[l_ac].ogb916) THEN
                   LET g_ogb[l_ac].ogb916=g_ogb[l_ac].ogb05
                END IF
                SELECT ima131 INTO l_ima131 FROM ima_file 
                 WHERE ima01=g_ogb[l_ac].ogb04
                DECLARE p311_b_get_price_c1 CURSOR FOR
                   SELECT obg21,
                          obg01,obg02,obg03,obg04,obg05,
                          obg06,obg07,obg08,obg09,obg10
                     FROM obg_file
                    WHERE (obg01 = l_ima131          OR obg01 = '*')
                      AND (obg02 = g_ogb[l_ac].ogb04 OR obg02 = '*')
                      AND (obg03 = g_ogb[l_ac].ogb916              )
                      AND (obg04 = g_oga.oga25       OR obg04 = '*')
                      AND (obg05 = g_oga.oga31       OR obg05 = '*')
                      AND (obg06 = g_oga.oga03       OR obg06 = '*')
                      AND (obg09 = g_oga.oga23                     )
                      AND (obg10 = g_oga.oga21       OR obg10 = '*')
                    ORDER BY 2 DESC,3 DESC,4 DESC,5 DESC,6 DESC,7 DESC,
                             8 DESC,9 DESC,10 DESC
                FOREACH p311_b_get_price_c1 INTO l_ogb13
                  IF STATUS THEN
                  CALL s_errmsg('','','',STATUS,1)   
                  END IF
                  EXIT FOREACH
                END FOREACH
           WHEN l_oah03 = '3'
              SELECT obk08 INTO l_ogb13 FROM obk_file
               WHERE obk01 = g_ogb[l_ac].ogb04 AND obk02 = g_oga.oga03
                 AND obk05 = g_oga.oga23
           WHEN l_oah03 = '4'
              CALL s_price(g_oga.oga02,g_oga.oga31,g_oga.oga23,g_oga.oga32,
                           g_oga.oga03,g_ogb[l_ac].ogb04,g_ogb[l_ac].ogb05,g_ogb[l_ac].ogb12,l_oah03)
              RETURNING l_ogb13
      END CASE
      IF cl_null(l_ogb13) THEN LET l_ogb13 = 0 END IF
 
      RETURN l_ogb13
END FUNCTION       

#-----MOD-A70140---------
FUNCTION t650_ogb14()   
   SELECT azi04 INTO t_azi04 FROM azi_file
    WHERE azi01=g_oga.oga23
   IF g_oga.oga213 = 'N' THEN
      LET g_ogb[l_ac].ogb14 =g_ogb[l_ac].ogb917*g_ogb[l_ac].ogb13
      LET g_ogb[l_ac].ogb14t=g_ogb[l_ac].ogb14*(1+g_oga.oga211/100)
      CALL cl_digcut(g_ogb[l_ac].ogb14,t_azi04)   
           RETURNING g_ogb[l_ac].ogb14
      CALL cl_digcut(g_ogb[l_ac].ogb14t,t_azi04) 
           RETURNING g_ogb[l_ac].ogb14t
   ELSE
      LET g_ogb[l_ac].ogb14t=g_ogb[l_ac].ogb917*g_ogb[l_ac].ogb13
      LET g_ogb[l_ac].ogb14 =g_ogb[l_ac].ogb14t/(1+g_oga.oga211/100)
      CALL cl_digcut(g_ogb[l_ac].ogb14t,t_azi04)  
           RETURNING g_ogb[l_ac].ogb14t
      CALL cl_digcut(g_ogb[l_ac].ogb14,t_azi04)  
           RETURNING g_ogb[l_ac].ogb14
   END IF
END FUNCTION 
#-----END MOD-A70140-----


#No:FUN-9C0071--------精簡程式-----

#FUN-910088--add--start--
FUNCTION t650_ogg12_check(p_ogg,i,j)
DEFINE p_ogg              RECORD
         ogg20            LIKE ogg_file.ogg20,
         ogg09            LIKE ogg_file.ogg09,
         ogg091           LIKE ogg_file.ogg091,
         ogg092           LIKE ogg_file.ogg092,
         ogg12            LIKE ogg_file.ogg12,
         ogg13            LIKE ogg_file.ogg13, #FUN-C50097
         ogg10            LIKE ogg_file.ogg10,
         img10            LIKE type_file.num10,
         ogg15            LIKE ogg_file.ogg15,
         ogg15_fac        LIKE ogg_file.ogg15_fac,
         ogg16            LIKE ogg_file.ogg16,
         ogg18            LIKE ogg_file.ogg18
                          END RECORD
DEFINE l_ogg            DYNAMIC ARRAY OF RECORD
         ogg20            LIKE ogg_file.ogg20,
         ogg09            LIKE ogg_file.ogg09,
         ogg091           LIKE ogg_file.ogg091,
         ogg092           LIKE ogg_file.ogg092,
         ogg12            LIKE ogg_file.ogg12,
         ogg13            LIKE ogg_file.ogg13, #FUN-C50097
         ogg10            LIKE ogg_file.ogg10,
         img10            LIKE type_file.num10,
         ogg15            LIKE ogg_file.ogg15,
         ogg15_fac        LIKE ogg_file.ogg15_fac,
         ogg16            LIKE ogg_file.ogg16,
         ogg18            LIKE ogg_file.ogg18
                          END RECORD
DEFINE l_bno      LIKE rvbs_file.rvbs08,
       i,j        LIKE type_file.chr1
DEFINE l_msg      STRING                #TQC-C50131 -- add
   LET l_ogg[i].* = p_ogg.*
   IF NOT cl_null(l_ogg[i].ogg12) AND NOT cl_null(l_ogg[i].ogg10) THEN
      LET l_ogg[i].ogg12 = s_digqty(l_ogg[i].ogg12,l_ogg[i].ogg10)
      DISPLAY BY NAME l_ogg[i].ogg12
   END IF
   LET g_ima918 = ''
   LET g_ima921 = ''
   SELECT ima918,ima921 INTO g_ima918,g_ima921
     FROM ima_file
    WHERE ima01 = g_ogb[l_ac].ogb04
      AND imaacti = "Y"

   IF (g_ima918 = "Y" OR g_ima921 = "Y") AND (l_ogg[i].ogg12<>0) THEN
      SELECT img09 INTO l_ogg[i].ogg15
        FROM img_file
       WHERE img01 = g_ogb[l_ac].ogb04
         AND img02 = l_ogg[i].ogg09
         AND img03 = l_ogg[i].ogg091
         AND img04 = l_ogg[i].ogg092

      LET l_ogg[i].ogg16 = s_digqty(l_ogg[i].ogg16,l_ogg[i].ogg15)
      DISPLAY l_ogg[i].ogg15 TO s_ogg[j].ogg15
      DISPLAY l_ogg[i].ogg16 TO s_ogg[j].ogg16

      IF NOT cl_null(l_ogg[i].ogg15) THEN
         CALL s_umfchk(g_ogb[l_ac].ogb04,l_ogg[i].ogg10,l_ogg[i].ogg15)   
             RETURNING g_cnt,l_ogg[i].ogg15_fac
         IF g_cnt=1 THEN
            CALL cl_err('','mfg3075',1)
           #TQC-C50131 -- add -- begin
            CALL cl_getmsg('asf-176',g_lang) RETURNING l_msg
            LET l_msg = l_msg CLIPPED,"(",g_ogb[l_ac].ogb04,")"
            CALL cl_msgany(10,20,l_msg)
           #TQC-C50131 -- add -- end
            RETURN FALSE,l_bno
         END IF
      END IF

      IF cl_null(l_ogg[i].ogg15_fac) THEN
         LET l_ogg[i].ogg15_fac = 1
      END IF

      IF cl_null(g_ogb[l_ac].ogb41) THEN
         LET l_bno = ''
      ELSE
         LET l_bno = g_ogb[l_ac].ogb41
      END IF
      CALL s_mod_lot(g_prog,g_oga.oga01,g_ogb[l_ac].ogb03,l_ogg[i].ogg18,       
                    g_ogb[l_ac].ogb04,l_ogg[i].ogg09,
                    l_ogg[i].ogg091,l_ogg[i].ogg092,
                    l_ogg[i].ogg10,l_ogg[i].ogg15,l_ogg[i].ogg15_fac,
                    l_ogg[i].ogg12,l_bno,'MOD',-1)
          RETURNING l_r,g_qty
      IF l_r = "Y" THEN
         LET l_ogg[i].ogg12 = g_qty
         LET l_ogg[i].ogg12 = s_digqty(l_ogg[i].ogg12,l_ogg[i].ogg10)  
      END IF
   END IF
   RETURN TRUE,l_bno
END FUNCTION
#FUN-910088--add--end--

#FUN-BB0167 add begin 新增無訂單出貨客戶簽收功能---------------------------
FUNCTION t650_gen_check_note()
DEFINE l_oga     RECORD LIKE oga_file.*,
       l_ogb     RECORD LIKE ogb_file.*,
       li_result LIKE type_file.num5,    #No.FUN-680137 SMALLINT
       l_cnt     LIKE type_file.num5,    #No.FUN-680137 SMALLINT
       tm        RECORD
                 oga01 LIKE oay_file.oayslip,  #No.FUN-680137 VARCHAR(5)
                 oga02 LIKE oea_file.oea02
                 END RECORD,
       l_t1      LIKE type_file.chr5
DEFINE l_rvbs    RECORD LIKE rvbs_file.* 
DEFINE i         LIKE type_file.num5 

DEFINE l_ogc     RECORD LIKE ogc_file.*  

   IF g_oga.oga65!='Y' THEN
       #此單據未做客戶出貨簽收!
       CALL cl_err(g_oga.oga01,'axm-720',1)
       RETURN
   END IF
   IF g_oga.ogaconf != 'Y' OR g_oga.ogapost != 'Y' THEN
      CALL cl_err(g_oga.oga01,'axm-922',1)   #出貨單需確認且過帳才可執行轉出貨簽
      RETURN
   END IF

   IF NOT cl_confirm('axm-420') THEN
      RETURN
   END IF

   LET g_success = 'Y'

   SELECT COUNT(*) INTO l_cnt FROM ogb_file
    WHERE ogb01 = g_oga.oga01
      AND ogb12 <> 0

   IF l_cnt = 0 THEN
      RETURN
   END IF

   SELECT COUNT(*) INTO l_cnt FROM ogb_file,oga_file
    WHERE oga01 = ogb01
      AND oga01 = g_oga.oga01
      AND ogb03 NOT IN (SELECT ogb03 FROM ogb_file,oga_file
                         WHERE oga01 = ogb01
                           AND oga011 = g_oga.oga01
                           AND oga09 ='8')

   IF l_cnt = 0 THEN
      CALL cl_err(g_oga.oga01,'axm-425',1)
      RETURN
   END IF

   LET tm.oga01= NULL
   LET tm.oga02= g_today

   OPEN WINDOW t6272_w AT 2,39 WITH FORM "axm/42f/axmt6272"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_locale("axmt6272")

   INPUT BY NAME tm.oga01,tm.oga02 WITHOUT DEFAULTS

      AFTER FIELD oga01
         IF NOT cl_null(tm.oga01) THEN
            CALL s_check_no("axm",tm.oga01,"","58","oga_file","oga01","")
                 RETURNING li_result,tm.oga01
            IF (NOT li_result) THEN
               NEXT FIELD oga01
            END IF
         END IF

      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF

      ON ACTION controlp
         CASE
            WHEN INFIELD(oga01)
                LET l_t1=s_get_doc_no(tm.oga01)       
                CALL q_oay(FALSE,TRUE,l_t1,'58','axm') RETURNING l_t1      
                LET tm.oga01 = l_t1            
                DISPLAY BY NAME tm.oga01
                NEXT FIELD oga01
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
      LET INT_FLAG=0
      LET g_success = 'N'
      CLOSE WINDOW t6272_w
      RETURN
   END IF

   CLOSE WINDOW t6272_w

   LET l_oga.* = g_oga.*

   BEGIN WORK

   CALL s_auto_assign_no("axm",tm.oga01,tm.oga02,"","oga_file","oga01","","","")
     RETURNING li_result,l_oga.oga01

   IF (NOT li_result) THEN
      LET g_success = 'N'
   END IF

   IF cl_null(l_oga.oga01) THEN
      LET g_success='N'
      RETURN
   END IF

   LET l_oga.oga02  = tm.oga02
   LET l_oga.oga011 = g_oga.oga01
   LET l_oga.oga09  = '8'
   LET l_oga.ogaconf= 'N'
   LET l_oga.ogapost= 'N'
   LET l_oga.ogaprsw= 0
   LET l_oga.oga55  = '0'
   LET l_oga.oga57  = '1'           
   LET l_oga.oga65  = 'N'

   LET l_tmoga01 = tm.oga01   
   LET l_tmoga01 = l_tmoga01[1,g_doc_len]   
   SELECT oayapr INTO l_oga.ogamksg FROM oay_file
    WHERE oayslip = l_tmoga01     #抓取單據是否做簽核，因tm.oga01會多"_"所以用substr取前三碼  #FUN-9B0039 mod
   LET l_oga.oga85=' '  
   LET l_oga.oga94='N' 

   LET l_oga.ogaplant = g_plant
   LET l_oga.ogalegal = g_legal

   LET l_oga.ogaoriu = g_user     
   LET l_oga.ogaorig = g_grup     
   IF cl_null(l_oga.oga909) THEN LET l_oga.oga909 = 'N' END IF 
   INSERT INTO oga_file VALUES (l_oga.*)
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err('ins oga',SQLCA.SQLCODE,1)
      LET g_success='N'
   END IF

   DECLARE t600_ins_ogb_c1 CURSOR FOR
    SELECT * FROM ogb_file
     WHERE ogb01= g_oga.oga01
       AND (ogb12 <> 0 OR ogb1005 ='2')
   CALL s_showmsg_init()                    
   FOREACH t600_ins_ogb_c1 INTO l_ogb.*
       IF STATUS THEN
          CALL s_errmsg('','',"t600_ins_ogb_cl foreach:",SQLCA.sqlcode,1)  
          EXIT FOREACH
       END IF
     IF g_success = "N" THEN
        LET g_totsuccess = "N"
        LET g_success = "Y"
     END IF

       LET l_ogb.ogb01 = l_oga.oga01

       SELECT COUNT(*) INTO l_cnt FROM ogb_file,oga_file
        WHERE oga01 = ogb01
          AND oga09 = '8'
          AND oga011 = g_oga.oga01
          AND ogb03 = l_ogb.ogb03

       IF l_cnt > 0 THEN
          CALL s_errmsg('','',b_ogb.ogb04,"axm-421",1) #No.FUN-710046
          LET g_success = 'N'
       END IF

       LET l_ogb.ogb09 = g_oga.oga66
       LET l_ogb.ogb091= g_oga.oga67
       IF g_oaz.oaz23 = 'N' THEN     #多倉儲出貨
          LET l_ogb.ogb17 = 'N'
       END IF

       LET l_ogb.ogb44='1' 
       LET l_ogb.ogb47=0   

       LET l_ogb.ogbplant = g_plant
       LET l_ogb.ogblegal = g_legal
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

       INSERT INTO ogb_file VALUES(l_ogb.*)
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
          CALL s_errmsg('','',"ins ogb",SQLCA.sqlcode,1)   
          LET g_success='N'
       END IF
       LET g_ima918 = ''   
       LET g_ima921 = ''   
       SELECT ima918,ima921 INTO g_ima918,g_ima921
         FROM ima_file
        WHERE ima01 = l_ogb.ogb04
          AND imaacti = "Y"

       IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
          DECLARE t600_g_rvbs_1 CURSOR FOR SELECT * FROM rvbs_file
                                         WHERE rvbs01 = l_oga.oga011
                                           AND rvbs02 = l_ogb.ogb03
          LET i = 1   
          FOREACH t600_g_rvbs_1 INTO l_rvbs.*
             IF STATUS THEN
                CALL cl_err('rvbs',STATUS,1)
             END IF
             LET l_rvbs.rvbs00 = 'axmt628'
             LET l_rvbs.rvbs01 = l_oga.oga01
             LET l_rvbs.rvbs022 = i   
             LEt l_rvbs.rvbs13 = 0   

             INSERT INTO rvbs_file VALUES(l_rvbs.*)
             IF STATUS OR SQLCA.SQLCODE THEN
                CALL cl_err3("ins","rvbs_file","","",SQLCA.sqlcode,"","ins rvbs",1)
             END IF
             LET i = i + 1   
          END FOREACH
       END IF
       IF l_ogb.ogb17='Y' AND g_oaz.oaz23 = 'Y' THEN     ##多倉儲出貨
          DECLARE t600_ins_ogc_c1 CURSOR FOR
           SELECT * FROM ogc_file
            WHERE ogc01= g_oga.oga01
              AND ogc03= l_ogb.ogb03
          FOREACH t600_ins_ogc_c1 INTO l_ogc.*
             IF STATUS THEN
                CALL s_errmsg('','',"t600_ins_ogc_cl foreach:",SQLCA.sqlcode,1)
                EXIT FOREACH
             END IF
             IF g_success = "N" THEN
                LET g_totsuccess = "N"
                LET g_success = "Y"
             END IF

             LET l_ogc.ogc01 = l_oga.oga01
             LET l_ogc.ogc09 = g_oga.oga66
             LET l_ogc.ogc091= g_oga.oga67
             IF cl_null(l_ogc.ogc13) THEN LET l_ogc.ogc13 = 0 END IF #FUN-C50097
             INSERT INTO ogc_file VALUES(l_ogc.*)
             IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                CALL s_errmsg('','',"ins ogc",SQLCA.sqlcode,1)
                LET g_success='N'
             END IF

             LET g_ima918 = ''
             LET g_ima921 = ''
             SELECT ima918,ima921 INTO g_ima918,g_ima921
               FROM ima_file
              WHERE ima01 = l_ogc.ogc17
                AND imaacti = "Y"

             IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                DECLARE t600_g_rvbs_4 CURSOR FOR SELECT * FROM rvbs_file
                                               WHERE rvbs01 = l_oga.oga011
                                                 AND rvbs02 = l_ogb.ogb03
                                                 AND rvbs13 = l_ogc.ogc18
                LET i = 1
                FOREACH t600_g_rvbs_4 INTO l_rvbs.*
                   IF STATUS THEN
                      CALL cl_err('rvbs',STATUS,1)
                   END IF
                   LET l_rvbs.rvbs00 = 'axmt628'
                   LET l_rvbs.rvbs01 = l_oga.oga01
                   LET l_rvbs.rvbs022 = i

                   INSERT INTO rvbs_file VALUES(l_rvbs.*)
                   IF STATUS OR SQLCA.SQLCODE THEN
                      CALL cl_err3("ins","rvbs_file","","",SQLCA.sqlcode,"","ins rvbs",1)
                   END IF
                   LET i = i + 1
                END FOREACH
             END IF
          END FOREACH
       END IF
   END FOREACH
     IF g_totsuccess="N" THEN
        LET g_success="N"
     END IF
     CALL s_showmsg()
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF

   IF g_success = 'Y' THEN
      CALL t650_qry_on_check_note()
   END IF

END FUNCTION

FUNCTION t650_qry_on_check_note()
   DEFINE l_str   STRING
   DEFINE l_oga01 LIKE oga_file.oga01
   DEFINE l_flag  LIKE type_file.num5   

   IF g_oga.oga65 <> 'Y' THEN
       #此單據未做客戶出貨簽收!
       CALL cl_err(g_oga.oga01,'axm-720',1)
       RETURN
   END IF

   DECLARE t600_qry_on_check_cur CURSOR FOR
    SELECT oga01 FROM oga_file
     WHERE oga011 = g_oga.oga01
       AND oga09 = '8'
     ORDER BY oga01

   LET l_flag = 0
   LET l_str="oga01 IN ("

   FOREACH t600_qry_on_check_cur INTO l_oga01
      IF STATUS THEN
         EXIT FOREACH
      END IF

      IF l_flag = 0 THEN
         LET l_str=l_str CLIPPED,'"',l_oga01,'"'
      ELSE
         LET l_str=l_str CLIPPED,',"',l_oga01,'"'
      END IF

      LET l_flag = l_flag + 1
   END FOREACH

   IF l_flag = 0 THEN
      LET l_str=" 0=1"
   ELSE
      LET l_str=l_str CLIPPED,")"
   END IF
   CASE g_sma.sma124
      WHEN 'std'
         LET g_sql="axmt628 '' '",l_str CLIPPED,"'"
      WHEN 'icd'
         LET g_sql="axmt628_icd '' '",l_str CLIPPED,"'"
      WHEN 'slk'
         LET g_sql="axmt628_slk '' '",l_str CLIPPED,"'"
   END CASE
   CALL cl_cmdrun_wait(g_sql)

END FUNCTION

FUNCTION t650_show3()
DEFINE l_oga01a,l_oga01b  LIKE oga_file.oga01

   IF g_oga.oga65<>'Y'  THEN RETURN END IF

   DECLARE t650_n_cur1 CURSOR FOR
    SELECT oga01 FROM oga_file
     WHERE oga011=g_oga.oga01 AND oga09='8'
      AND ogaconf <> 'X'   #MOD-CC0247 add
     ORDER BY oga01

   OPEN t650_n_cur1
   FETCH t650_n_cur1 INTO l_oga01a
   CLOSE t650_n_cur1

   DECLARE t650_n_cur2 CURSOR FOR
    SELECT oga01 FROM oga_file
     WHERE oga011=g_oga.oga01 AND oga09='9'
     ORDER BY oga01

   OPEN t650_n_cur2
   FETCH t650_n_cur2 INTO l_oga01b
   CLOSE t650_n_cur2

   DISPLAY l_oga01a TO FORMONLY.oga01a
   DISPLAY l_oga01b TO FORMONLY.oga01b

END FUNCTION
#FUN-BB0167 add end------------------------------------------
#FUN-CA0084--add--str
FUNCTION t650_axmt670()
   DEFINE l_n1      LIKE type_file.num5
   LET l_n1 = 0
   SELECT COUNT(*) INTO l_n1 FROM omf_file WHERE omf11=g_oga.oga01
   IF l_n1>0 THEN
      LET g_errno = 'axm-544'
   END IF
END FUNCTION
#FUN-CA0084--add--end

#FUN-CB0014---add---str---
FUNCTION t650_bp1(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)    

      DISPLAY ARRAY g_oga_l TO s_oga_l.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
         BEFORE DISPLAY
            LET g_chr='@'
            LET g_action_choice = "entry_sheet"
            CALL cl_chk_act_auth_nomsg()   
            IF NOT cl_chk_act_auth() THEN
               CALL cl_set_act_visible("entry_sheet",FALSE)
            END IF
            IF g_aza.aza63 = 'N' THEN
               CALL cl_set_act_visible("entry_sheet2",FALSE)
            END IF
            CALL cl_chk_act_auth_showmsg()  
            LET g_action_choice = "deduct_inventory"
            CALL cl_chk_act_auth_nomsg()   
            IF NOT cl_chk_act_auth() THEN
               CALL cl_set_act_visible("deduct_inventory",FALSE)
            END IF
            IF cl_chk_act_auth() THEN
               CALL cl_set_act_visible("deduct_inventory",TRUE)
            END IF
            CALL cl_chk_act_auth_showmsg()   
            LET g_action_choice = " "  

            CALL cl_navigator_setting( g_curs_index, g_row_count )
            CALL fgl_set_arr_curr(g_curs_index)
         
         BEFORE ROW
            LET l_ac2 = ARR_CURR()
            LET g_curs_index = l_ac2
            CALL cl_show_fld_cont()
            
      ON ACTION main
         LET g_action_flag = 'main'
         LET l_ac2 = ARR_CURR()
         LET g_jump = l_ac2
         LET mi_no_ask = TRUE
         IF g_rec_b2 >0 THEN
             CALL t650_fetch('/')
         END IF
         CALL cl_set_comp_visible("page_in", FALSE)
         CALL cl_set_comp_visible("info", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page_in", TRUE)
         CALL cl_set_comp_visible("info", TRUE)
         EXIT DISPLAY

      ON ACTION ACCEPT
         LET g_action_flag = 'main'
         LET l_ac2 = ARR_CURR()
         LET g_jump = l_ac2
         LET mi_no_ask = TRUE
         CALL t650_fetch('/')
         CALL cl_set_comp_visible("info", FALSE)
         CALL cl_set_comp_visible("info", TRUE)
         CALL cl_set_comp_visible("page_in", FALSE) 
         CALL ui.interface.refresh()                 
         CALL cl_set_comp_visible("page_in", TRUE)    
         EXIT DISPLAY
         
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
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                  
         CALL t650_def_form()   
         IF g_oga.ogaconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
         CALL cl_set_field_pic(g_oga.ogaconf,"",g_oga.ogapost,"",g_chr,"")
         EXIT DISPLAY
 
      ON ACTION first
         CALL t650_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b2 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)  
         END IF
	     CONTINUE DISPLAY 
 
      ON ACTION previous
         CALL t650_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b2 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)  
         END IF
	     CONTINUE DISPLAY 
 
      ON ACTION jump
         CALL t650_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b2 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)  
         END IF
	     CONTINUE DISPLAY 
 
      ON ACTION next
         CALL t650_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b2 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)  
         END IF
	     CONTINUE DISPLAY              
 
      ON ACTION last
         CALL t650_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b2 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)  
         END IF
	     CONTINUE DISPLAY                  
 
      #TQC-D10084--mark--str--
      #ON ACTION detail
      #   LET g_action_choice="detail"
      #   LET l_ac = 1
      #   EXIT DISPLAY
      #TQC-D10084--mark--end--
 
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION controls                           
         CALL cl_set_head_visible("","AUTO")       
 
#@    ON ACTION 文件地址
      ON ACTION address
         LET g_action_choice="address"
         EXIT DISPLAY
 
#@    ON ACTION 其他資料
      ON ACTION other_data
         LET g_action_choice="other_data"
         EXIT DISPLAY
 
#@    ON ACTION 分錄底稿
      ON ACTION entry_sheet
         LET g_action_choice="entry_sheet"
         EXIT DISPLAY

#@    ON ACTION 分錄底稿二
      ON ACTION entry_sheet2
         LET g_action_choice="entry_sheet2"
         EXIT DISPLAY
 
#@    ON ACTION 會計分錄產生
      ON ACTION gen_entry
         LET g_action_choice="gen_entry"
         EXIT DISPLAY

#@    ON ACTION 轉出貨簽收
      ON ACTION gen_on_check_note
         LET g_action_choice="gen_on_check_note"
         EXIT DISPLAY
 
#@    ON ACTION 出貨相關查詢
      ON ACTION query_delivery
         LET g_action_choice="query_delivery"
         EXIT DISPLAY
 
#@    ON ACTION 客戶相關查詢
      ON ACTION query_customer
         LET g_action_choice="query_customer"
         EXIT DISPLAY
 
#@    ON ACTION 備註
      ON ACTION memo
         LET g_action_choice="memo"
         EXIT DISPLAY
 
#@    ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
 
#@    ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
 
#@    ON ACTION 庫存過帳
      ON ACTION deduct_inventory
         LET g_action_choice="deduct_inventory"
         EXIT DISPLAY
 
#@    ON ACTION 扣帳還原
      ON ACTION undo_deduct
         LET g_action_choice="undo_deduct"
         EXIT DISPLAY
 
#@    ON ACTION 轉應收發票
      ON ACTION ar_carry
         LET g_action_choice="ar_carry"
         EXIT DISPLAY
 
#@    ON ACTION 應收維護
      ON ACTION mntn_ar
         LET g_action_choice="mntn_ar"
         EXIT DISPLAY
 
#@    ON ACTION 信用超限放行
      ON ACTION release_ov_lmt_credit
         LET g_action_choice="release_ov_lmt_credit"
         EXIT DISPLAY
 
#@    ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
 
      ON ACTION qry_mntn_inv_detail
         LET g_action_choice="qry_mntn_inv_detail"
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
 
      ON ACTION exporttoexcel    
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document                
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      ON ACTION qry_lot
         LET g_action_choice="qry_lot"
         EXIT DISPLAY
      &include "qry_string.4gl"
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t650_list_fill()
  DEFINE l_oga01         LIKE oga_file.oga01
  DEFINE l_i             LIKE type_file.num10
  DEFINE l_slip          LIKE aba_file.aba00 

    CALL g_oga_l.clear()
    LET l_i = 1
    FOREACH t650_fill_cs INTO l_oga01
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach item_cur',SQLCA.sqlcode,1)
          CONTINUE FOREACH
       END IF
       SELECT oga00,oga08,oga01,oga02,oga03,oga032,oga04,occ02,
              oga14,gen02,oga15,gem02,ogaconf,ogapost
         INTO g_oga_l[l_i].*
         FROM oga_file
              LEFT OUTER JOIN occ_file ON oga04 = occ01
              LEFT OUTER JOIN gen_file ON oga14 = gen01
              LEFT OUTER JOIN gem_file ON oga15 = gem01
        WHERE oga01=l_oga01      
       LET l_i = l_i + 1
       IF l_i > g_max_rec THEN
          IF g_action_choice ="query"  THEN  
            CALL cl_err( '', 9035, 0 )
          END IF                             
          EXIT FOREACH
       END IF
    END FOREACH
    LET g_rec_b2 = l_i - 1
    DISPLAY ARRAY g_oga_l TO s_oga_l.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
       BEFORE DISPLAY
          EXIT DISPLAY
    END DISPLAY

END FUNCTION 
#FUN-CB0014---add---end---
