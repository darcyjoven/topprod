# Prog. Version..: '5.30.06-13.04.22(00009)'     #
#
# Pattern name...: aimt325.4gl
# Descriptions...: 兩階段倉庫調撥作業
# Date & Author..: 97/11/25 by Roger
# Modify.........: 針對No.B037之需求, 撥入確認時回寫imn26,imn24,imn25
#                  撥入確認還原時則將欄位清空  010323 by linda
# Modify.........: 010510 Kammy 增加"C.出至境外倉複製" 之功能
# Modify.........: #No:6891 03/07/15 By mandy 在輸入調撥數量時針對單筆會卡庫存,
                   #但同時輸入多筆相同的資料時,總數量超過時並未卡關...會有負庫存
# Modify.........: No:7698 03/08/06 By Mandy 在修改撥出倉庫時未重算撥入的換算率,撥入量,導致庫存錯誤!
# Modify.........: No:7857 03/08/20 By Mandy  呼叫自動取單號時應在 Transction中
# Modify.........: No.MOD-490218 04/09/13 by yiting ima02,ima021定義方式使用like
# Modify.........: No.MOD-490371 04/09/22 By Yuna Controlp 未加display
# Modify.........: No.MOD-4A0248 04/10/27 By Yuna QBE開窗開不出來
# Modify.........: No.FUN-4B0002 04/11/02 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.MOD-4B0020 04/11/02 By Yuna 撥入單號開窗
# Modify.........: No.FUN-4C0053 04/12/08 By Mandy Q,U,R 加入權限控管處理
# Modify.........: No.MOD-530179 05/03/22 By Mandy 將DEFINE 用DEC()方式的改成用LIKE方式
# Modify.........: No.MOD-530721 05/03/28 By kim 在 after 撥入倉庫、儲位時，不可檢查  t324_check_in()
# Modify.........: No.FUN-550011 05/05/24 By kim GP2.0功能 庫存單據不同期要check庫存是否為負
# Modify.........: No.FUN-550029 05/05/30 By vivien 單據編號格式放大
# Modify.........: NO.FUN-560060 05/06/17 By jackie 單據編號修改
# Modify.........: NO.FUN-540059 05/06/19 By wujie  單據編號修改
# Modify.........: No.FUN-560183 05/06/22 By kim 移除ima86成本單位
# Modify.........: No.FUN-570249 05/08/03 By Carrier 多單位內容修改
# Modify.........: No.MOD-590118 05/09/09 By Carrier 修改set_origin_field
# Modify.........: No.MOD-590303 05/09/20 By kim 出至境外倉複製功能的倉儲批開窗錯誤
# Modify.........: No.MOD-590302 05/09/20 By kim 出至境外倉複製按取消,單身會被清空
# Modify.........: NO.MOD-590041 05/10/17 By Rosayu 錯誤訊息改成popup window
# Modify.........: NO.FUN-5B0088 05/11/23 By Sarah g_argv1='_'時,若imm03='Y,imm04='N'只可進入單身維護imn16,imn17,imn18,不可新增,刪除
# Modify.........: No.FUN-5A0029 05/12/02 By Sarah 修改單身後單頭的資料更改者,最近修改日應update
# Modify.........: No.TQC-5C0031 05/12/07 By Carrier set_required時去除單位換算率
# Modify.........: No.TQC-5C0071 05/12/14 By kim 宣告變數改用LIKE
# Modify.........: No.MOD-550089 05/12/20 By Pengu 成本倉與非成本倉間不得調撥
# Modify.........: No.FUN-5C0077 05/12/27 By yoyo 增加imn29的欄位
# Modify.........: No.FUN-580031 06/01/06 By saki 查詢條件紀錄
# Modify.........: No.MOD-610048 06/01/11 By Claire imd10 !='W' display erro message
# Modify.........: No.FUN-610090 06/02/06 By Nicola 拆併箱功能修改
# Modify.........: No.TQC-620058 06/02/16 By pengu ms290已設定為非雙單位,但aimt325仍然出現單位一的欄位劃面
# Modify.........: No.TQC-630052 06/03/07 By Claire 流程訊息通知傳參數
# Modify.........: No.TQC-610072 06/03/08 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: NO.TQC-620156 06/03/14 By kim GP3.0過帳錯誤統整顯示功能新增
# Modify.........: NO.TQC-630186 06/03/20 By Claire 不修改TQC-630052問題,因aimt326串同支程式會造成無法查詢
# Modify.........: No.MOD-630085 06/03/22 By Claire query後並未顯示撥入人員
# Modify.........: No.MOD-610096 06/03/24 By pengu 撥出確認時,會將數量先撥製在製倉(imm08),批號儲位空白,但沒考慮到轉換率
# Modify.........: NO.FUN-640266 06/04/26 BY yiting 更改cl_err
# Modify.........: No.MOD-650040 06/05/09 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: NO.TQC-650115 06/05/24 By yoyo 多屬性調整
# Modify.........: NO.FUN-660029 06/06/13 By kim GP3.1 增加確認碼欄位與處理
# Modify.........: No.FUN-660078 06/06/14 By rainy aim系統中，用char定義的變數，改為用LIK
# Modify.........: No.FUN-660008 06/06/15 By Claire smy51在途倉使用取消
# Modify.........: No.TQC-660100 06/06/21 By Rayven 多屬性功能改進:查詢時不顯示多屬性內容
# Modify.........: NO.FUN-660156 06/06/23 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-660085 06/07/03 By Joe 若單身倉庫欄位已有值，則倉庫開窗查詢時，重新查詢時不會顯示該料號所有的倉儲。
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-670093 06/07/20 By kim GP3.5 利潤中心
# Modify.........: No.FUN-680006 06/08/03 By kim GP3.5 利潤中心
# Modify.........: No.FUN-680010 06/08/26 by Joe SPC整合專案-自動新增 QC 單據
# Modify.........: No.FUN-690026 06/09/15 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690022 06/09/15 By jamie 判斷imaacti
# Modify.........: No.FUN-680046 06/10/11 By jamie 1.FUNCTION t325()_q 一開始應清空g_imm.*值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/10 By bnlent  單頭折疊功能修改
# Modify.........: No.MOD-690150 06/12/07 By Claire 倉庫兩階段調撥應傳報表參收為22
# Modify.........: No.TQC-6A0034 06/12/07 By Claire display 和 retrun 值不同 
# Modify.........: No.TQC-6C0070 06/12/14 By Sarah aimt326單身要可以QBE查詢
# Modify.........: No.CHI-6A0015 06/12/19 By rainy 輸入料號後要帶出預設倉庫/儲位
# Modify.........: No.MOD-6C0114 06/12/27 By kim 已有QC資料仍可作廢
# Modify.........: No.FUN-6C0083 07/01/08 By Nicola 錯誤訊息彙整
# Modify.........: No.TQC-710032 07/01/15 By Smapmin 雙單位畫面調整
# Modify.........: No.MOD-710112 07/01/17 By Carol 不控管日期輸入不可小於現行年月
# Modify.........: No.FUN-710025 07/01/29 By bnlent 錯誤訊息彙整
# Modify.........: No.MOD-710044 07/03/05 By pengu  aimt326進單身修改撥入單單身的倉儲批資料後,會將撥入的母子數量清為0
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740245 07/04/23 By rainy 撥入確認日期不可小於單頭的撥入日期
# Modify.........: No.MOD-740197 07/04/23 By Carol t325c_i()中變數應使用l_imm* 
# Modify.........: No.MOD-740447 07/05/03 By pengu 無法撥出確認
# Modify.........: No.TQC-750018 07/05/07 By rainy 更改狀態無更改料號時，不重帶倉庫儲位
# Modify.........: No.TQC-750012 07/05/07 By Carol 倉儲批欄位增加檢查撥出/入資料庫存資料不可相同
# Modify.........: No.TQC-750041 07/05/11 By sherry “撥出審核、撥出審核還原”報錯信息維護錯誤。
# Modify.........: No.MOD-750088 07/05/28 By pengu 若撥出(4月)與撥入確認(5月)跨月時，當執行「撥入確認還原」會無法還原
# Modify.........: No.TQC-760153 07/06/18 By chenl 增加傳入參數imn28理由碼。
# Modify.........: No.CHI-770019 07/07/25 By Carrier 多單位:參考單位時,交易單位不寫入tlff
# Modify.........: No.TQC-790177 07/09/29 By Carrier 去掉全型字符
# Modify.........: No.TQC-7A0063 07/10/18 By Judy "撥入審核"時,報"單據編號重復"
# Modify.........: No.TQC-7B0076 07/11/14 By lumxa   目前的撥入單號在after field里面生成，但 after field之后到點確定提交會有一段時間差，這個時候如果其他用戶也進行撥入維護，撥入單號還是會重復生成。
#                                                    處理辦法，參照標准程序，一般程序新增記錄的時候都是在insert語句之前生成新單號的，所以這里也可將生成單號的部分從after field拿出來，放到update imm_file之前，并且在生成單號之后再去 check一下是否重復，這樣應該不會有因時間差而造成的單號重復了。
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.MOD-830197 08/04/19 By Pengu 調整TQC-750018修改地方
# Modify.........: No.TQC-860018 08/06/09 By Smapmin 增加on idle控管
# Modify.........: No.CHI-860005 08/06/27 By xiaofeizhu 使用參考單位且參考數量為0時，也需寫入tlff_file
# Modify.........: No.MOD-890237 08/09/24 By wujie 單身錄入時撥入的倉庫的母單位和子單位為空白，應與撥出倉庫的單位相同。
# Modify.........: No.MOD-8A0098 08/10/21 By wujie  設定單別綁定屬性群組時，修改多屬性料件欄位，開窗返回的還是未修改的老料號
# Modify.........: No.FUN-8C0084 08/12/22 By jan s_upimg相關改以 料倉儲批為參數傳入 ,不使用 ROWID
# Modify.........: No.MOD-8C0293 08/12/31 By wujie  撥入日期應該小于等于會計年度期別，大于關帳日期
# Modify.........: No.FUN-920186 09/03/18 By lala  理由碼imn28必須為庫存調撥
# Modify.........: No.TQC-930155 09/03/30 By Sunyanchun Lock img_file,imgg_file時，若報錯,不要rollback ，要放g_success ='N'
# Modify.........: No.FUN-870100 09/08/04 By Cockroach 零售超市移植
# Modify.........: No.FUN-980004 09/08/25 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-960022 09/10/15 By chenmoyan 預設單位一數量時，加上判斷，單位一數量為空或為1時，才預設
# Modify.........: No.CHI-960052 09/10/15 By chenmoyan 使用多單位，料件是單一單位或參考單位時，單位一的轉換率錯誤
# Modify.........: No:CHI-980019 09/11/05 By jan 虛擬料件不可做任何單據
# Modify.........: No.FUN-9C0072 10/01/15 By vealxu 精簡程式碼
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:MOD-A30247 10/03/31 By Sarah 1.當沒有輸入儲位、批號時,撥出、入倉庫不可與在途倉一樣
#                                                  2.在寫入imn_file前重新帶出imn09與imn20
# Modify.........: No:FUN-8C0131 10/04/07 by dxfwo  過帳還原時的呆滯日期異動
# Modify.........: No:CHI-A30005 10/04/14 by Summer 新增ACTION查詢倉庫(q_imd)與ACTION查詢倉庫儲位(q_ime)
# Modify.........: No:MOD-A10089 10/08/03 By Pengu 取消單身自動default上一筆資料的功能
# Modify.........: No:MOD-AA0086 10/10/14 By Carrier 批序号功能
# Modify.........: No.FUN-AA0049 10/10/21 by destiny  增加倉庫的權限控管
# Modify.........: No.FUN-A40022 10/10/25 By jan 1.當料件為批號控管,則批號必須輸入(ICD行業) 2.撥出批號=撥入批號(IC行業)
# Modify.........: No.FUN-AA0059 10/10/29 By huangtao 修改料號AFTER FIELD的管控
# Modify.........: No.FUN-AA0059 10/10/29 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.TQC-AB0016 10/11/03 by destiny  q_imd_1参数传错,导致开窗无值
# Modify.........: No.FUN-AB0066 10/11/15 By lilingyu 審核段增加倉庫權限的控管
# Modify.........: No.TQC-AC0201 10/12/15 By vealxu 按"撥入維護"會出現權限檢查錯誤的訊息 
# Modify.........: No.MOD-AC0191 10/12/18 by jan q_imd_1 參數傳錯:w-->W
# Modify.........: No:TQC-B10060 11/01/11 By lilingyu 狀態page,部分欄位不可下查詢條件
# Modify.........: No.FUN-A60034 11/03/08 By Mandy 因aimt324 新增EasyFlow整合功能影響INSERT INTO imm_file
# Modify.........: No:FUN-A70104 11/03/08 By Mandy [EF簽核] aimt324影響程式簽核欄位default
# Modify.........: No:FUN-B30170 11/04/08 By suncx 單身增加批序號明細頁簽
# Modify.........: No:FUN-AC0074 11/05/09 By jan 增加調撥備置處理
# Modify.........: No.TQC-B50032 11/05/18 By destiny 审核时不存在的部门可以通过 
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B70074 11/07/20 By xianghui 添加行業別表的新增於刪除
# Modify.........: No.FUN-B80070 11/08/08 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外 
# Modify.........: No.FUN-B30053 11/08/18 By xianghui 輸入單身時應該依據單據別中設定的QC欄位的值為預設值
# Modify.........: No.FUN-B50096 11/08/19 By lixh1 所有入庫程式應該要加入可以依料號設置"批號(倉儲批的批)是否為必要輸入欄位"的選項
# Modify.........: No.TQC-B90236 11/10/26 By zhuhao s_lotout_del程式段Mark，改為s_lot_del，傳入參數不變
#                                                   _r()中，使用FOR迴圈執行s_del_rvbs程式段Mark，改為s_lot_del，傳入參數同上，但第三個參數(項次)傳""
#                                                   原執行s_lotou程式段，改為s_mod_lot，傳入參數不變，於最後多傳入-1
#                                                   原執行s_lotin程式段，改為s_mod_lot，於第6,7,8個參數傳入倉儲批，最後多傳入1，其餘傳入參數不變
# Modify.........: No:FUN-BB0086 12/01/16 By tanxc 增加數量欄位小數取位 

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:MOD-C10152 12/02/03 By ck2yuan 呼叫t325_du_defualt　改用g_imn_o去判斷是否有異動
# Modify.........: No:MOD-C10156 12/02/03 By ck2yuan 若單身同時有母子單位與非母子單位  應在BEFORE ROW控卡哪些欄位為requied
# Modify.........: No:FUN-C20002 12/02/06 by fanbj 券產品倉庫調整
# Modify.........: No:MOD-C30573 12/03/12 By chenjing 調整撥入批號與撥出批號重複時NEXT FIELD到 imn15
# Modify.........: No:CHI-C30106 12/04/05 By Elise 批序號維護
# Modify.........: No.FUN-C30300 12/04/09 By bart  倉儲批開窗需顯示參考單位數量
# Modify.........: No.TQC-C50158 12/05/18 By fengrui 過賬時檢查倉庫使用權限,撥出確認時添加開窗
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.TQC-C50236 12/05/29 By fengrui 確認還原時,不應影響 最近入庫日、最近出庫日、最近異動日、最近盤點日
# Modify.........: No:CHI-C50010 12/06/01 By ck2yuan 調撥時,有效日期應拿原本調撥前的有效日期
# Modify.........: No:TQC-C60028 12/06/04 By bart 只要是ICD行業 倉儲批開窗改用q_idc
# Modify.........: No:FUN-C30085 12/06/20 By lixiang 串CR報表改GR報表
# Modify.........: No.CHI-C50041 12/07/13 By bart 新增時call自動產生
# Modify.........: No.FUN-C70087 12/07/31 By bart 整批寫入img_file
# Modify.........: No:FUN-C80107 12/09/18 By suncx 增可按倉庫進行負庫存判斷
# Modify.........: No.MOD-CA0009 12/10/12 By Elise 倉庫有效日期不應控卡
# Modify.........: No:FUN-C90049 12/10/18 By Lori 預設成本倉與非成本倉改從s_get_defstore取
# Modify.........: No.CHI-CA0040 12/10/24 By bart 撥入確認時，增加QC單的檢查
# Modify.........: No.FUN-CB0087 12/12/06 By qiull 庫存單據理由碼改善
# Modify.........: No.CHI-C80041 12/12/14 By bart 取消單頭資料控制
# Modify.........: No:FUN-CC0095 13/01/16 By bart 修改整批寫入img_file
# Modify.........: No:FUN-D10081 13/01/17 By qiull 增加資料清單
# Modify.........: No:MOD-D10182 13/01/25 By bart 清空imn09
# Modify.........: No:TQC-D10084 13/01/28 By qiull 資料清單頁簽不可點擊單身按鈕
# Modify.........: No:CHI-D20010 13/02/20 By yangtt 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:TQC-D20042 13/02/22 By qiull 撥出審核時增加理由碼控管
# Modify.........: No.FUN-D20060 13/02/22 By yangtt 設限倉庫/儲位控卡
# Modify.........: No:FUN-BC0062 13/02/28 By fengrui 當成本計算方式ccz28選擇'6'，過帳還原時控制不可過帳還原
# Modify.........: No:FUN-D30024 13/03/12 By qiull 負庫存依據imd23判斷
# Modify.........: No:CHI-C80007 13/03/14 By Alberti 調撥時,先拿撥出倉的呆滯日期,等撥入在s_tlf再依單別決定是否更新呆滯日期
# Modify.........: No:FUN-D20059 13/03/26 By chenjing 統一確認和取消確認時確認人員和確認日期的寫法
# Modify.........: No:MOD-D30256 13/06/29 By bart aimt326欄位輸入控制
# Modify.........: No.DEV-D30040 13/04/01 By Nina 批序號相關程式,當料件使用條碼時(ima930 = 'Y'),確認時,
#                                                 若未輸入批序號資料則不需控卡單據數量與批/序號總數量是否相符 
#                                                 ex:單據數量與批/序號總數量不符，請檢查資料！(aim-011)
# Modify.........: No.DEV-D30059 13/04/01 By Nina 批序號相關程式,當料件使用條碼時(ima930 = 'Y'),輸入資料時,
#                                                 不要自動開批序號的Key In畫面(s_mod_lot)
# Modify.........: No:DEV-D30046 13/04/09 By TSD.sophy 搬移撥出確認、撥入確認、撥出確認還原、撥入確認還原等程式段至aimt325_sub.4gl
# Modify.........: No:FUN-D30033 13/04/12 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No.DEV-D40013 13/04/12 By Nina 過單用
# Modify.........: No.TQC-D40026 13/04/15 By fengrui 還原FUN-BC0062修改
# Modify.........: No.FUN-D40103 13/05/07 By fengrui 添加庫位有效性檢查 
# Modify.........: No.TQC-D50124 13/05/28 By lixiang 修正FUN-D40103部份邏輯控管
# Modify.........: No:TQC-D40078 13/04/28 By xujing 負庫存函数添加营运中心参数 
# Modify.........: No.TQC-DB0039 13/11/19 By wangrr 設置默認值imn24='N'
# Modify.........: No:TQC-DB0075 13/11/27 By wangrr 點擊"查詢"再"退出",會報錯"-404:找不到光標或說明",單身倉庫儲位增加開窗

DATABASE ds
 
GLOBALS "../../config/top.global"
#FUN-CC0095---begin
GLOBALS
   DEFINE g_padd_img       DYNAMIC ARRAY OF RECORD
                     img01 LIKE img_file.img01,
                     img02 LIKE img_file.img02,
                     img03 LIKE img_file.img03,
                     img04 LIKE img_file.img04,
                     img05 LIKE img_file.img05,
                     img06 LIKE img_file.img06,
                     img09 LIKE img_file.img09,
                     img13 LIKE img_file.img13,
                     img14 LIKE img_file.img14,
                     img17 LIKE img_file.img17,
                     img18 LIKE img_file.img18,
                     img19 LIKE img_file.img19,
                     img21 LIKE img_file.img21,
                     img26 LIKE img_file.img26,
                     img27 LIKE img_file.img27,
                     img28 LIKE img_file.img28,
                     img35 LIKE img_file.img35,
                     img36 LIKE img_file.img36,
                     img37 LIKE img_file.img37
                           END RECORD

   DEFINE g_padd_imgg      DYNAMIC ARRAY OF RECORD
                    imgg00 LIKE imgg_file.imgg00,
                    imgg01 LIKE imgg_file.imgg01,
                    imgg02 LIKE imgg_file.imgg02,
                    imgg03 LIKE imgg_file.imgg03,
                    imgg04 LIKE imgg_file.imgg04,
                    imgg05 LIKE imgg_file.imgg05,
                    imgg06 LIKE imgg_file.imgg06,
                    imgg09 LIKE imgg_file.imgg09,
                    imgg10 LIKE imgg_file.imgg10,
                    imgg20 LIKE imgg_file.imgg20,
                    imgg21 LIKE imgg_file.imgg21,
                    imgg211 LIKE imgg_file.imgg211,
                    imggplant LIKE imgg_file.imggplant,
                    imgglegal LIKE imgg_file.imgglegal
                            END RECORD
END GLOBALS
#FUN-CC0095---end
#模組變數(Module Variables)
DEFINE
    g_imm   RECORD  LIKE imm_file.*,
    g_imm_t RECORD  LIKE imm_file.*,
    g_imm_o RECORD  LIKE imm_file.*,
    b_imn           RECORD LIKE imn_file.*,
    g_yy,g_mm       LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    g_imn03_t       LIKE imn_file.imn03,
    t_imn04         LIKE imn_file.imn04,
    t_imn05         LIKE imn_file.imn05,
    t_imn15         LIKE imn_file.imn15,
    t_imn16         LIKE imn_file.imn16,
    t_imf04         LIKE imf_file.imf04,
    t_imf05         LIKE imf_file.imf05,
    g_imn           DYNAMIC ARRAY OF RECORD    #程式變數(Prinram Variables)
	            imn02     LIKE imn_file.imn02,
                    imn03     LIKE imn_file.imn03,
                    att00     LIKE imx_file.imx00,                              
                    att01     LIKE imx_file.imx01,  #No.FUN-690026 VARCHAR(10)
                    att01_c   LIKE imx_file.imx01,  #No.FUN-690026 VARCHAR(10)
                    att02     LIKE imx_file.imx02,  #No.FUN-690026 VARCHAR(10)
                    att02_c   LIKE imx_file.imx02,  #No.FUN-690026 VARCHAR(10)
                    att03     LIKE imx_file.imx03,  #No.FUN-690026 VARCHAR(10)
                    att03_c   LIKE imx_file.imx03,  #No.FUN-690026 VARCHAR(10)
                    att04     LIKE imx_file.imx04,  #No.FUN-690026 VARCHAR(10)
                    att04_c   LIKE imx_file.imx04,  #No.FUN-690026 VARCHAR(10)
                    att05     LIKE imx_file.imx05,  #No.FUN-690026 VARCHAR(10)
                    att05_c   LIKE imx_file.imx05,  #No.FUN-690026 VARCHAR(10)
                    att06     LIKE imx_file.imx06,  #No.FUN-690026 VARCHAR(10)
                    att06_c   LIKE imx_file.imx06,  #No.FUN-690026 VARCHAR(10)
                    att07     LIKE imx_file.imx07,  #No.FUN-690026 VARCHAR(10)
                    att07_c   LIKE imx_file.imx07,  #No.FUN-690026 VARCHAR(10)
                    att08     LIKE imx_file.imx08,  #No.FUN-690026 VARCHAR(10)
                    att08_c   LIKE imx_file.imx08,  #No.FUN-690026 VARCHAR(10)
                    att09     LIKE imx_file.imx09,  #No.FUN-690026 VARCHAR(10)
                    att09_c   LIKE imx_file.imx09,  #No.FUN-690026 VARCHAR(10)
                    att10     LIKE imx_file.imx10,  #No.FUN-690026 VARCHAR(10)
                    att10_c   LIKE imx_file.imx10,  #No.FUN-690026 VARCHAR(10)
                    imn29     LIKE imn_file.imn29,  #No.FUN-5C0077
                    ima02     LIKE ima_file.ima02,  #No.MOD-490218
                    ima021    LIKE ima_file.ima021, #No.MOD-490218
                    #imn28     LIKE imn_file.imn28,  #FUN-CB0087 mark
                    imn04     LIKE imn_file.imn04,
                    imn05     LIKE imn_file.imn05,
                    imn06     LIKE imn_file.imn06,
                    imn09     LIKE imn_file.imn09,
                    imn9301   LIKE imn_file.imn9301, #FUN-670093
                    gem02b    LIKE gem_file.gem02,   #FUN-670093
                    imn33     LIKE imn_file.imn33,
                    imn34     LIKE imn_file.imn34,
                    imn35     LIKE imn_file.imn35,
                    imn30     LIKE imn_file.imn30,
                    imn31     LIKE imn_file.imn31,
                    imn32     LIKE imn_file.imn32,
                    imn15     LIKE imn_file.imn15,
                    imn16     LIKE imn_file.imn16,
                    imn17     LIKE imn_file.imn17,
                    imn20     LIKE imn_file.imn20,
                    imn9302   LIKE imn_file.imn9302, #FUN-670093
                    gem02c    LIKE gem_file.gem02,   #FUN-670093
                    imn10     LIKE imn_file.imn10,
                    imn22     LIKE imn_file.imn22,
                    imn21     LIKE imn_file.imn21,
                    imn43     LIKE imn_file.imn43,
                    imn44     LIKE imn_file.imn44,
                    imn45     LIKE imn_file.imn45,
                    imn40     LIKE imn_file.imn40,
                    imn41     LIKE imn_file.imn41,
                    imn42     LIKE imn_file.imn42,
                    imn52     LIKE imn_file.imn52,
                    imn51     LIKE imn_file.imn51,
                    imn28     LIKE imn_file.imn28,  #FUN-CB0087
                    azf03     LIKE azf_file.azf03,  #FUN-CB0087
                    imn26     LIKE imn_file.imn26
                    END RECORD,
    g_imn_t   RECORD
	            imn02     LIKE imn_file.imn02,
                    imn03     LIKE imn_file.imn03,
                    att00     LIKE imx_file.imx00,                              
                    att01     LIKE imx_file.imx01,  #No.FUN-690026 VARCHAR(10)
                    att01_c   LIKE imx_file.imx01,  #No.FUN-690026 VARCHAR(10)
                    att02     LIKE imx_file.imx02,  #No.FUN-690026 VARCHAR(10)
                    att02_c   LIKE imx_file.imx02,  #No.FUN-690026 VARCHAR(10)
                    att03     LIKE imx_file.imx03,  #No.FUN-690026 VARCHAR(10)
                    att03_c   LIKE imx_file.imx03,  #No.FUN-690026 VARCHAR(10)
                    att04     LIKE imx_file.imx04,  #No.FUN-690026 VARCHAR(10)
                    att04_c   LIKE imx_file.imx04,  #No.FUN-690026 VARCHAR(10)
                    att05     LIKE imx_file.imx05,  #No.FUN-690026 VARCHAR(10)
                    att05_c   LIKE imx_file.imx05,  #No.FUN-690026 VARCHAR(10)
                    att06     LIKE imx_file.imx06,  #No.FUN-690026 VARCHAR(10)
                    att06_c   LIKE imx_file.imx06,  #No.FUN-690026 VARCHAR(10)
                    att07     LIKE imx_file.imx07,  #No.FUN-690026 VARCHAR(10)
                    att07_c   LIKE imx_file.imx07,  #No.FUN-690026 VARCHAR(10)
                    att08     LIKE imx_file.imx08,  #No.FUN-690026 VARCHAR(10)
                    att08_c   LIKE imx_file.imx08,  #No.FUN-690026 VARCHAR(10)
                    att09     LIKE imx_file.imx09,  #No.FUN-690026 VARCHAR(10)
                    att09_c   LIKE imx_file.imx09,  #No.FUN-690026 VARCHAR(10)
                    att10     LIKE imx_file.imx10,  #No.FUN-690026 VARCHAR(10)
                    att10_c   LIKE imx_file.imx10,  #No.FUN-690026 VARCHAR(10)
                    imn29     LIKE imn_file.imn29,  #No.FUN-5C0077
                    ima02     LIKE ima_file.ima02,  #No.MOD-490218
                    ima021    LIKE ima_file.ima021, #No.MOD-490218
                    #imn28     LIKE imn_file.imn28,  #FUN-CB0087 mark
                    imn04     LIKE imn_file.imn04,
                    imn05     LIKE imn_file.imn05,
                    imn06     LIKE imn_file.imn06,
                    imn09     LIKE imn_file.imn09,
                    imn9301   LIKE imn_file.imn9301, #FUN-670093
                    gem02b    LIKE gem_file.gem02,   #FUN-670093
                    imn33     LIKE imn_file.imn33,
                    imn34     LIKE imn_file.imn34,
                    imn35     LIKE imn_file.imn35,
                    imn30     LIKE imn_file.imn30,
                    imn31     LIKE imn_file.imn31,
                    imn32     LIKE imn_file.imn32,
                    imn15     LIKE imn_file.imn15,
                    imn16     LIKE imn_file.imn16,
                    imn17     LIKE imn_file.imn17,
                    imn20     LIKE imn_file.imn20,
                    imn9302   LIKE imn_file.imn9302, #FUN-670093
                    gem02c    LIKE gem_file.gem02,   #FUN-670093
                    imn10     LIKE imn_file.imn10,
                    imn22     LIKE imn_file.imn22,
                    imn21     LIKE imn_file.imn21,
                    imn43     LIKE imn_file.imn43,
                    imn44     LIKE imn_file.imn44,
                    imn45     LIKE imn_file.imn45,
                    imn40     LIKE imn_file.imn40,
                    imn41     LIKE imn_file.imn41,
                    imn42     LIKE imn_file.imn42,
                    imn52     LIKE imn_file.imn52,
                    imn51     LIKE imn_file.imn51,
                    imn28     LIKE imn_file.imn28,  #FUN-CB0087
                    azf03     LIKE azf_file.azf03,  #FUN-CB0087
                    imn26     LIKE imn_file.imn26
                    END RECORD,
    #MOD-C10152 str add---------------------------
    g_imn_o   RECORD
                    imn02     LIKE imn_file.imn02,
                    imn03     LIKE imn_file.imn03,
                    att00     LIKE imx_file.imx00,
                    att01     LIKE imx_file.imx01,
                    att01_c   LIKE imx_file.imx01,
                    att02     LIKE imx_file.imx02,
                    att02_c   LIKE imx_file.imx02,
                    att03     LIKE imx_file.imx03,
                    att03_c   LIKE imx_file.imx03,
                    att04     LIKE imx_file.imx04,
                    att04_c   LIKE imx_file.imx04,
                    att05     LIKE imx_file.imx05,
                    att05_c   LIKE imx_file.imx05,
                    att06     LIKE imx_file.imx06,
                    att06_c   LIKE imx_file.imx06,
                    att07     LIKE imx_file.imx07,
                    att07_c   LIKE imx_file.imx07,
                    att08     LIKE imx_file.imx08,
                    att08_c   LIKE imx_file.imx08,
                    att09     LIKE imx_file.imx09,
                    att09_c   LIKE imx_file.imx09,
                    att10     LIKE imx_file.imx10,
                    att10_c   LIKE imx_file.imx10,
                    imn29     LIKE imn_file.imn29,
                    ima02     LIKE ima_file.ima02,
                    ima021    LIKE ima_file.ima021,
                    #imn28     LIKE imn_file.imn28,  #FUN-CB0087 mark
                    imn04     LIKE imn_file.imn04,
                    imn05     LIKE imn_file.imn05,
                    imn06     LIKE imn_file.imn06,
                    imn09     LIKE imn_file.imn09,
                    imn9301   LIKE imn_file.imn9301,
                    gem02b    LIKE gem_file.gem02,
                    imn33     LIKE imn_file.imn33,
                    imn34     LIKE imn_file.imn34,
                    imn35     LIKE imn_file.imn35,
                    imn30     LIKE imn_file.imn30,
                    imn31     LIKE imn_file.imn31,
                    imn32     LIKE imn_file.imn32,
                    imn15     LIKE imn_file.imn15,
                    imn16     LIKE imn_file.imn16,
                    imn17     LIKE imn_file.imn17,
                    imn20     LIKE imn_file.imn20,
                    imn9302   LIKE imn_file.imn9302,
                    gem02c    LIKE gem_file.gem02,
                    imn10     LIKE imn_file.imn10,
                    imn22     LIKE imn_file.imn22,
                    imn21     LIKE imn_file.imn21,
                    imn43     LIKE imn_file.imn43,
                    imn44     LIKE imn_file.imn44,
                    imn45     LIKE imn_file.imn45,
                    imn40     LIKE imn_file.imn40,
                    imn41     LIKE imn_file.imn41,
                    imn42     LIKE imn_file.imn42,
                    imn52     LIKE imn_file.imn52,
                    imn51     LIKE imn_file.imn51,
                    imn28     LIKE imn_file.imn28,  #FUN-CB0087
                    azf03     LIKE azf_file.azf03,  #FUN-CB0087
                    imn26     LIKE imn_file.imn26
                    END RECORD,
    #MOD-C10152 end add---------------------------
    g_yes               LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
    g_img09_s           LIKE img_file.img09,
    g_img09_t           LIKE img_file.img09,
    g_img10_s           LIKE img_file.img10,
    g_img10_t           LIKE img_file.img10,
    g_imgg10_1          LIKE img_file.img10,
    g_imgg10_2          LIKE img_file.img10,
    g_ima906            LIKE ima_file.ima906,
    g_ima907            LIKE ima_file.ima907,
    g_imgg00            LIKE imgg_file.imgg00,
    g_imgg10            LIKE imgg_file.imgg10,
    g_sw                LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    g_factor            LIKE img_file.img21,
    g_tot               LIKE img_file.img10,
    g_qty               LIKE img_file.img10,
    g_flag              LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
    g_wc,g_wc2,g_sql    string,                 #No.FUN-570249  #No.FUN-580092 HCN
    h_qty               LIKE ima_file.ima271,
    g_wip               LIKE type_file.chr1,    #MOD-550089 add  #No.FUN-690026 VARCHAR(1)
    g_t1                LIKE smy_file.smyslip,  #No.FUN-550029 #No.FUN-690026 VARCHAR(5)
    g_buf               LIKE gem_file.gem02,    #No.FUN-690026 VARCHAR(20)
    sn1,sn2             LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    l_code              LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    g_rec_b             LIKE type_file.num5,                #單身筆數  #No.FUN-690026 SMALLINT
    l_ac                LIKE type_file.num5,                #目前處理的ARRAY CNT  #No.FUN-690026 SMALLINT
    g_debit,g_credit    LIKE img_file.img26,
    g_ima25,g_ima25_2   LIKE ima_file.ima25,
    g_img10,g_img10_2   LIKE img_file.img10,
    g_argv1		LIKE imm_file.imm01  #單號 或 '_' 或 '_XXXX'  #No.FUN-550029 #No.FUN-690026 VARCHAR(16)	  
                       			     #傳入單號
                       			     #傳入'_'    表示挑選庫別撥入確認
                       			     #傳入'_XXXX'表示'XXXX'庫撥入確認
DEFINE
    l_imm         RECORD LIKE imm_file.*,
    l_img         RECORD
                      t_img02 LIKE img_file.img02,
                      t_img03 LIKE img_file.img03,
                      t_img04 LIKE img_file.img04
                  END RECORD,
    l_imm_t       RECORD LIKE imm_file.*,
    l_imm_o       RECORD LIKE imm_file.*
 
DEFINE p_row,p_col          LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_forupd_sql         STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_cnt                LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_i                  LIKE type_file.num5    #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_msg                LIKE type_file.chr1000 #TQC-610072  #No.FUN-690026 VARCHAR(120)
DEFINE g_row_count          LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index         LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump               LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE mi_no_ask            LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_imm01              LIKE imm_file.imm01    #No.FUN-610090
DEFINE g_unit_arr           DYNAMIC ARRAY OF RECORD#No.FUN-610090
                               unit   LIKE ima_file.ima25,
                               fac    LIKE img_file.img21,
                               qty    LIKE img_file.img10
                            END RECORD
DEFINE arr_detail    DYNAMIC ARRAY OF RECORD                                  
       imx00         LIKE imx_file.imx00,                                        
       imx           ARRAY[10] OF LIKE imx_file.imx01                            
       END RECORD                                                             
DEFINE lr_agc        DYNAMIC ARRAY OF RECORD LIKE agc_file.*                  
DEFINE lg_smy62      LIKE smy_file.smy62  
DEFINE lg_group      LIKE smy_file.smy62  
DEFINE l_check       LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
DEFINE l_imaag       LIKE ima_file.imaag
DEFINE g_ima918      LIKE ima_file.ima918  #No.MOD-AA0086
DEFINE g_ima921      LIKE ima_file.ima921  #No.MOD-AA0086
DEFINE g_ima930      LIKE ima_file.ima930  #DEV-D30059 add

DEFINE l_r           LIKE type_file.chr1   #No.MOD-AA0086
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
                  rvbs08  LIKE rvbs_file.rvbs08
                END RECORD,
       g_rvbs_t RECORD
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
                  rvbs08  LIKE rvbs_file.rvbs08
                END RECORD
DEFINE g_rec_b1           LIKE type_file.num5,   #單身二筆數 ##FUN-B30170
       l_ac1              LIKE type_file.num5    #目前處理的ARRAY CNT  #FUN-B30170
#FUN-B30170 add -end---------------------------
DEFINE g_imn30_t  LIKE imn_file.imn30   #No.FUN-BB0086
DEFINE g_imn33_t  LIKE imn_file.imn33   #No.FUN-BB0086
#CHI-C50041---begin
DEFINE 
    tm  RECORD                                                                                                                      
          part   LIKE ima_file.ima01,                                                                                               
          ima910 LIKE ima_file.ima910,    
          qty    LIKE sfb_file.sfb08,                                                                                               
          idate  LIKE type_file.dat,     
          a      LIKE type_file.chr1     
        END RECORD, 
    tm1  RECORD                                                                                                                     
         bdate   LIKE type_file.dat,                                                                                                
         sudate  LIKE type_file.dat                                                                                                
         END RECORD,
    l_imn04      LIKE imn_file.imn04,
    l_imn05      LIKE imn_file.imn05,
    l_imn15      LIKE imn_file.imn15,
    l_imn16      LIKE imn_file.imn16,
    l_imn28      LIKE imn_file.imn28,
    g_ccc        LIKE type_file.num5, 
    g_ima44      LIKE ima_file.ima44,
    l_sw      LIKE type_file.chr1,
    g_seq     LIKE type_file.num5 
#CHI-C50041---end
#DEFINE l_img_table      STRING             #FUN-C70087  #FUN-CC0095
#DEFINE l_imgg_table     STRING             #FUN-C70087  #FUN-CC0095
DEFINE g_flag1    LIKE type_file.chr1   #FUN-C80107 add
#FUN-D10081---add---str---
DEFINE g_imm_l DYNAMIC ARRAY OF RECORD
               imm01   LIKE imm_file.imm01,
               imm02   LIKE imm_file.imm02,
               imm08   LIKE imm_file.imm08,
               imm14   LIKE imm_file.imm14,
               gem02   LIKE gem_file.gem02,
               imm09   LIKE imm_file.imm09,
               imm11   LIKE imm_file.imm11,
               imm12   LIKE imm_file.imm12,
               imm13   LIKE imm_file.imm13,
               gen02   LIKE gen_file.gen02,
               imm04   LIKE imm_file.imm04,
               imm03   LIKE imm_file.imm03
               END RECORD,
        l_ac4      LIKE type_file.num5,
        g_rec_b4   LIKE type_file.num5,
        g_action_flag  STRING
DEFINE   w     ui.Window
DEFINE   f     ui.Form
DEFINE   page  om.DomNode
#FUN-D10081---add---end---

MAIN
 
   OPTIONS                                #改變一些系統預設值
       INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   LET g_argv1=ARG_VAL(1)
   IF g_argv1[1]='_' THEN
      LET g_prog="aimt326"
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   #CALL s_padd_img_create() RETURNING l_img_table   #FUN-C70087  #FUN-CC0095
   #CALL s_padd_imgg_create() RETURNING l_imgg_table #FUN-C70087  #FUN-CC0095
   
   LET g_wc2=' 1=1'
 
   LET g_forupd_sql = "SELECT * FROM imm_file WHERE imm01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t325_cl CURSOR FROM g_forupd_sql
 
     CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074
   INITIALIZE g_imm.* TO NULL
   INITIALIZE g_imm_t.* TO NULL
   INITIALIZE g_imm_o.* TO NULL
 
   LET p_row = 2 LET p_col = 2
 
   OPEN WINDOW t325_w AT p_row,p_col WITH FORM "aim/42f/aimt325"
   ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   #2004/06/02共用程式時呼叫
   CALL cl_set_locale_frm_name("aimt325")
   CALL cl_ui_init()
 
   CALL t325_mu_ui()
 
   LET lg_smy62 = ''                                                           
   LET lg_group = ''                                                           
   CALL t325_refresh_detail() 
 
   CALL cl_set_comp_required("imn28",g_aza.aza115='Y')      #FUN-CB0087--add--
    IF g_azw.azw04 <> '2' THEN
       CALL cl_set_comp_visible('immplant,immplant_desc',FALSE)
    END IF
 
   CALL t325_menu()
   CLOSE WINDOW t325_w                    #結束畫面
   #CALL s_padd_img_drop(l_img_table)   #FUN-C70087 #FUN-CC0095
   #CALL s_padd_imgg_drop(l_imgg_table) #FUN-C70087 #FUN-CC0095
   CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074
END MAIN
 
FUNCTION t325_cs()
   DEFINE   lc_qbe_sn   LIKE gbm_file.gbm01   #No.FUN-580031
    CLEAR FORM                             #清除畫面
    CALL g_imn.clear()
     IF cl_null(g_argv1) THEN
      CALL cl_set_head_visible("","YES")   #No.FUN-6B0030

       CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
                           imm01,imm02,imm09,imm14,imm08,imm04,imm03,
                           immplant,immspc,immuser,immgrup,
                           immoriu,immorig,                         #TQC-B10060 add
                           immmodu,immdate #FUN-670093 #FUN-680010 #FUN-870100
 
        BEFORE CONSTRUCT
               INITIALIZE g_imm.* TO NULL
           CALL cl_qbe_init()                     #No.FUN-580031
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(imm01) #查詢單据
                   CALL cl_init_qry_var()
                   LET g_qryparam.state= "c"
                   LET g_qryparam.form = "q_imm106"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO imm01
                   NEXT FIELD imm01
              WHEN INFIELD(imm08) #查詢在途倉
                   #No.FUN-AA0049--begin
                   #CALL cl_init_qry_var()
                   #LET g_qryparam.form  ="q_imd"
                   #LET g_qryparam.state ="c"
                   #LET g_qryparam.arg1  ="W"
                   #CALL cl_create_qry() RETURNING g_qryparam.multiret
                  #CALL q_imd_1(TRUE,TRUE,"",'w',"","","") RETURNING g_qryparam.multiret  #No.TQC-AB0016   
                   CALL q_imd_1(TRUE,TRUE,"",'W',"","","") RETURNING g_qryparam.multiret  #No.TQC-AB0016
                   #No.FUN-AA0049--end
                   DISPLAY g_qryparam.multiret TO imm08
                   NEXT FIELD imm08
              WHEN INFIELD(imm14)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gem"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_imm.imm14
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO imm14
                 NEXT FIELD imm14
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
 
 
       ON ACTION qbe_select
          CALL cl_qbe_list() RETURNING lc_qbe_sn
          CALL cl_qbe_display_condition(lc_qbe_sn)
       END CONSTRUCT
    ELSE
       CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
           imm01,imm02,imm09,imm14,imm08,imm11,imm12,imm13,imm04,imm03,immplant,immuser,immgrup,immmodu,immdate #FUN-670093 #FUN-870100
 
        BEFORE CONSTRUCT
           CALL g_imn.clear()
           CALL cl_qbe_init()                     #No.FUN-580031
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(imm01) #查詢單据
                   CALL cl_init_qry_var()
                   LET g_qryparam.state= "c"
                   LET g_qryparam.form = "q_imm106"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO imm01
                   NEXT FIELD imm01
              WHEN INFIELD(imm11) #撥入單號
                   CALL cl_init_qry_var()
                   LET g_qryparam.state= "c"
                   LET g_qryparam.form = "q_imm108"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO imm11
                   NEXT FIELD imm11
              WHEN INFIELD(imm08) #查詢在途倉
                   #No.FUN-AA0049--begin
                   #CALL cl_init_qry_var()
                   #LET g_qryparam.form  ="q_imd"
                   #LET g_qryparam.state ="c"
                   #LET g_qryparam.arg1  ="W"
                   #CALL cl_create_qry() RETURNING g_qryparam.multiret
                  #CALL q_imd_1(TRUE,TRUE,"",'w',"","","") RETURNING g_qryparam.multiret          #No.TQC-AB0016
                   CALL q_imd_1(TRUE,TRUE,"",'W',"","","") RETURNING g_qryparam.multiret          #No.TQC-AB0016
                   #No.FUN-AA0049--end
                   DISPLAY g_qryparam.multiret TO imm08
                   NEXT FIELD imm08
              WHEN INFIELD(imm13) #撥入人員
                   CALL cl_init_qry_var()
                   LET g_qryparam.form  ="q_gen"
                   LET g_qryparam.state ="c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO imm13
                   NEXT FIELD imm13
              WHEN INFIELD(imm14)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gem"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_imm.imm14
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO imm14
                 NEXT FIELD imm14
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
 
 
       ON ACTION qbe_select
          CALL cl_qbe_list() RETURNING lc_qbe_sn
          CALL cl_qbe_display_condition(lc_qbe_sn)
       END CONSTRUCT
       LET g_wc2 = " 1=1"
    END IF
    IF INT_FLAG THEN RETURN END IF
 
       CONSTRUCT g_wc2 ON imn02,imn03,imn29,imn28,imn04,imn05,imn06,imn09,imn9301,  #No.FUN-5C0077 #FUN-670093
                          imn33,imn34,imn35,imn30,imn31,imn32,
                          imn15,imn16,imn17,imn20,imn9302,imn10,imn22,imn21, #FUN-670093
                          imn43,imn44,imn45,imn40,imn41,imn42,
                          imn52,imn51,imn26
            FROM s_imn[1].imn02,s_imn[1].imn03,s_imn[1].imn29,s_imn[1].imn28,   #No.FUN-5C0077
                 s_imn[1].imn04,s_imn[1].imn05,s_imn[1].imn06,
                 s_imn[1].imn09,s_imn[1].imn9301,s_imn[1].imn33,s_imn[1].imn34, #FUN-670093
                 s_imn[1].imn35,s_imn[1].imn30,s_imn[1].imn31,
                 s_imn[1].imn32,s_imn[1].imn15,s_imn[1].imn16,
                 s_imn[1].imn17,s_imn[1].imn20,s_imn[1].imn9302,s_imn[1].imn10, #FUN-670093
                 s_imn[1].imn22,s_imn[1].imn21,s_imn[1].imn43,
                 s_imn[1].imn44,s_imn[1].imn45,s_imn[1].imn40,
                 s_imn[1].imn41,s_imn[1].imn42,s_imn[1].imn52,
                 s_imn[1].imn51,s_imn[1].imn26
       BEFORE CONSTRUCT
          CALL cl_qbe_display_condition(lc_qbe_sn)
        ON ACTION controlp
           CASE
              WHEN INFIELD(imn03)
#FUN-AA0059 --Begin--
                #   CALL cl_init_qry_var()
                #   LET g_qryparam.form     ="q_ima"
                #   LET g_qryparam.state ="c"
                #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                   DISPLAY g_qryparam.multiret TO imn03
                   NEXT FIELD imn03
              WHEN INFIELD(imn28) #理由
                   CALL cl_init_qry_var()
                   LET g_qryparam.form     = "q_azf01a"    #FUN-920186
                   LET g_qryparam.state ="c"
                   LET g_qryparam.arg1  = "6"             #FUN-920186
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO imn28
                   NEXT FIELD imn28
              #TQC-DB0075--add--str--
              WHEN INFIELD(imn04)
                   CALL q_imd_1(TRUE,TRUE,"","","","","") RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO imn04
                   NEXT FIELD imn04
              WHEN INFIELD(imn05)
                   CALL q_ime_1(TRUE,TRUE,"","","",g_plant,"","","") RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO imn05
                   NEXT FIELD imn05
              WHEN INFIELD(imn15)
                   CALL q_imd_1(TRUE,TRUE,"","","","","") RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO imn15
                   NEXT FIELD imn15
              WHEN INFIELD(imn16)
                   CALL q_ime_1(TRUE,TRUE,"","","",g_plant,"","","") RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO imn16
                   NEXT FIELD imn16
              #TQC-DB0075--add--end
              WHEN INFIELD(imn33)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gfe"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO inm33
                   NEXT FIELD inm33
              WHEN INFIELD(imn30)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gfe"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO imn30
                   NEXT FIELD imn30
              WHEN INFIELD(imn43)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gfe"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO inm43
                   NEXT FIELD inm43
              WHEN INFIELD(imn40)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gfe"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO imn40
                   NEXT FIELD imn40
              WHEN INFIELD(imn9301)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_gem4"
                 LET g_qryparam.state = "c"   #多選
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO imn9301
                 NEXT FIELD imn9301
              WHEN INFIELD(imn9302)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_gem4"
                 LET g_qryparam.state = "c"   #多選
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO imn9302
                 NEXT FIELD imn9302
              OTHERWISE
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
 
       IF INT_FLAG THEN
         #LET INT_FLAG=0 #TQC-DB0075 mark
          RETURN 
       END IF
 
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('immuser', 'immgrup')
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT  imm01 FROM imm_file",
                   " WHERE imm10 = '2'",
                   " AND immplant IN ",g_auth,      #No.FUN-870100           
                   " AND ", g_wc CLIPPED,
                   " ORDER BY imm01"
    ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE imm_file. imm01 ",
                   "  FROM imm_file, imn_file",
                   " WHERE imm01 = imn01",
                   "   AND imm10 = '2'  ",
                   "   AND immplant=imnplant",        #No.FUN-870100
                   "   AND immplant IN ",g_auth,      #No.FUN-870100
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY imm01"
    END IF
 
    PREPARE t325_prepare FROM g_sql
    DECLARE t325_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t325_prepare
    DECLARE t325_fill_cs CURSOR WITH HOLD FOR t325_prepare   #FUN-D10081 add
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM imm_file ",
                  "WHERE imm10 = '2'",
                  " AND immplant IN ",g_auth,      #No.FUN-870100
                  " AND ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT imm01) FROM imm_file,imn_file ",
                  " WHERE imm10 = '2'",
                  " AND immplant IN ",g_auth,      #No.FUN-870100
                  " AND immplant=imnplant",        #No.FUN-870100
                  " AND imm01=imn01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE t325_precount FROM g_sql
    DECLARE t325_count CURSOR FOR t325_precount
END FUNCTION
 
FUNCTION t325_menu()
   WHILE TRUE
      IF cl_null(g_action_flag) OR g_action_flag = "page_main" THEN      #FUN-D10081 add
         CALL t325_bp("G")
      #FUN-D10081---add---str---
      ELSE 
         CALL t325_list_fill()
         CALL t325_bp2("G")
         IF NOT cl_null(g_action_choice) AND l_ac4>0 THEN #將清單的資料回傳到主畫面
            SELECT imm_file.* INTO g_imm.*
              FROM imm_file
             WHERE imm01 = g_imm_l[l_ac4].imm01
         END IF 
         IF g_action_choice!= "" THEN
            LET g_action_flag = "page_main"
            LET l_ac4 = ARR_CURR()
            LET g_jump = l_ac4
            LET mi_no_ask = TRUE
            IF g_rec_b4 >0 THEN
               CALL t325_fetch('/')
            END IF
            CALL cl_set_comp_visible("page_list", FALSE)
            CALL cl_set_comp_visible("page_main", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page_list", TRUE)
            CALL cl_set_comp_visible("page_main", TRUE)
         END IF
      END IF
      #FUN-D10081---add---end---
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t325_a()
             END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t325_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t325_r()
            END IF 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t325_u()
            END IF  
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t325_b()
            ELSE
               LET g_action_choice = NULL
            END IF 
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t325_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
       #@WHEN "出至境外倉複製"
         WHEN "copy_offshore_wh"
            CALL aimt325c()
            IF g_success='Y' THEN
               CALL t325_q()
            END IF
            LET g_argv1=''
       #@WHEN "撥出確認"
         WHEN "conf_transfer_out"
          # IF cl_smuchk(g_imm.imm01,'Y') THEN   #TQC-AC0201 mark
            IF cl_chk_act_auth() THEN            #TQC-AC0201 
               #CALL t325_y()  #DEV-D30046 --mark
               #DEV-D30046 --add--begin 
               CALL t325sub_y(g_imm.imm01,FALSE,'Y')
               CALL t325sub_refresh(g_imm.imm01) RETURNING g_imm.*
               CALL t325_show()
               #DEV-D30046 --add--end 
            END IF
       #@WHEN "撥出確認還原"
         WHEN "undo_transfer_out"
          # IF cl_smuchk(g_imm.imm01,'W') THEN   #TQC-AC0201 mark
            IF cl_chk_act_auth() THEN            #TQC-AC0201
               #CALL t325_w()  #DEV-D30046 --mark
               #DEV-D30046 --add--begin 
               CALL t325sub_w(g_imm.imm01,FALSE,'Y')
               CALL t325sub_refresh(g_imm.imm01) RETURNING g_imm.*
               CALL t325_show()
               #DEV-D30046 --add--end 
            END IF
       #@WHEN "撥入維護"
         WHEN "transfer_in_maintain"
           #IF cl_smuchk(g_imm.imm01,'T') THEN     #TQC-AC0201 mark
            IF cl_chk_act_auth() THEN            #TQC-AC0201
               CALL t325_t()
            END IF
       #@WHEN "撥入確認"
         WHEN "conf_transfer_in"
           #IF cl_smuchk(g_imm.imm01,'S') THEN     #TQC-AC0201 mark
            IF cl_chk_act_auth() THEN            #TQC-AC0201
               #CALL t325_s()  #DEV-D30046 --mark
               #DEV-D30046 --add--begin 
               CALL t325sub_s(g_imm.imm01,FALSE,'Y')
               CALL t325sub_refresh(g_imm.imm01) RETURNING g_imm.*
               CALL t325_show()
               #DEV-D30046 --add--end 
            END IF
       #@WHEN "撥入確認還原"
         WHEN "undo_transfer_in"
          # IF cl_smuchk(g_imm.imm01,'Z') THEN     #TQC-AC0201 mark
            IF cl_chk_act_auth() THEN            #TQC-AC0201
               #CALL t325_z()  #DEV-D30046 --mark
               #DEV-D30046 --add--begin 
               CALL t325sub_z(g_imm.imm01,FALSE,'Y')
               CALL t325sub_refresh(g_imm.imm01) RETURNING g_imm.*
               CALL t325_show()
               #DEV-D30046 --add--end 
            END IF
       #@WHEN "作廢"
         WHEN "void"
          # IF cl_smuchk(g_imm.imm01,'X') THEN     #TQC-AC0201 mark
            IF cl_chk_act_auth() THEN            #TQC-AC0201
              #CALL t325_x()    #CHI-D20010
               CALL t325_x(1)   #CHI-D20010
            END IF

       #CHI-D20010---begin
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
             # CALL t325_x()     #CHI-D20010
               CALL t325_x(2)    #CHI-D20010
            END IF
       #CHI-D20010---end

         WHEN "exporttoexcel" #FUN-4B0002
            LET w = ui.Window.getCurrent()   #FUN-D10081 add
            LET f = w.getForm()              #FUN-D10081 add
            IF cl_null(g_action_flag) OR g_action_flag = "page_main" THEN   #FUN-D10081 add
               IF cl_chk_act_auth() THEN
                  LET page = f.FindNode("Page","page_main")                 #FUN-D10081 add
                 #CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_imn),'','')   #FUN-D10081 mark
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_imn),'','')   #FUN-D10081 add
               END IF
            #FUN-D10081---add---str---
            END IF 
            IF g_action_flag = "page_list" THEN
               LET page = f.FindNode("Page","page_list")
               IF cl_chk_act_auth() THEN
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_imm_l),'','')
               END IF
            END IF
            #FUN-D10081---add---end---            
 
         WHEN "trans_spc"         
            IF cl_chk_act_auth() THEN
               CALL t325_spc()
            END IF 

         #No.MOD-AA0086  --Begin 
         WHEN "qry_lot"
            SELECT ima918,ima921 INTO g_ima918,g_ima921
              FROM ima_file
             WHERE ima01 = g_imn[l_ac].imn03
               AND imaacti = "Y"
            IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
               LET g_success = 'Y'
               BEGIN WORK
               IF g_prog = 'aimt325' THEN
                 #CALL s_lotout(g_prog,g_imm.imm01,g_imn[l_ac].imn02,0,             #TQC-B90236 mark
                  CALL s_mod_lot(g_prog,g_imm.imm01,g_imn[l_ac].imn02,0,             #TQC-B90236 add
                                g_imn[l_ac].imn03,g_imn[l_ac].imn04,
                                g_imn[l_ac].imn05,g_imn[l_ac].imn06,
                                g_imn[l_ac].imn09,g_imn[l_ac].imn09,1,
                                g_imn[l_ac].imn10,'','QRY',-1)                      #TQC-B90236 add '-1'
                      RETURNING l_r,g_qty
               ELSE
#No.TQC-B90236----mark-----begin---------
#                 CALL s_lotin( g_prog,g_imm.imm01,g_imn[l_ac].imn02,0,
#                               g_imn[l_ac].imn03,
#                               g_imn[l_ac].imn09,g_imn[l_ac].imn09,1,
#                               g_imn[l_ac].imn10,'','QRY')
#No.TQC-B90236----mark-----end-----------
#No.TQC-B90236----add------begin---------
                  CALL s_mod_lot(g_prog,g_imm.imm01,g_imn[l_ac].imn02,0,    
                                g_imn[l_ac].imn03,g_imn[l_ac].imn04,
                                g_imn[l_ac].imn05,g_imn[l_ac].imn06,
                                g_imn[l_ac].imn09,g_imn[l_ac].imn09,1,
                                g_imn[l_ac].imn10,'','QRY',1)  
#No.TQC-B90236----add------end-----------
                      RETURNING l_r,g_qty
               END IF
               IF g_success = "Y" THEN
                  COMMIT WORK
               ELSE
                  ROLLBACK WORK
               END IF
            END IF
         #No.MOD-AA0086  --End   

         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               IF g_imm.imm01 IS NOT NULL THEN
                 LET g_doc.column1 = "imm01"
                 LET g_doc.value1 = g_imm.imm01
                 CALL cl_doc()
               END IF
           END IF
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION t325_g()
    DEFINE a           LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    LET p_row = 2 LET p_col = 5
    OPEN WINDOW t325g_w AT p_row,p_col WITH FORM "aim/42f/aimt325g"
         ATTRIBUTE (STYLE = g_win_style)
 
    CALL cl_ui_locale("aimt325g")
 
 
    INPUT BY NAME a WITHOUT DEFAULTS
       AFTER FIELD a
          IF a IS NULL THEN NEXT FIELD a END IF
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
    IF INT_FLAG THEN LET INT_FLAG=0 CLOSE WINDOW t325g_w RETURN END IF
 
    IF a = '1' THEN CALL t325_g1() END IF
    CLOSE WINDOW t325g_w
 
    CALL t325_b_fill(' 1=1')
 
END FUNCTION
 
FUNCTION t325_g1()
    DEFINE l_wc,l_sql                LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(400)
    DEFINE t_img02                   LIKE img_file.img02,   #TQC-5C0071
           t_img03                   LIKE img_file.img03,   #TQC-5C0071
           t_img04                   LIKE img_file.img04    #TQC-5C0071
    DEFINE l_img                     RECORD LIKE img_file.*
    DEFINE l_prog_tmp                STRING
    DEFINE l_imn9301                 LIKE imn_file.imn9301  #FUN-670093
    DEFINE l_imni                    RECORD LIKE imni_file.*   #FUN-B70074
    DEFINE l_flag                    LIKE type_file.chr1       #FUN-B70074  
    DEFINE l_date                    LIKE type_file.dat        #CHI-C50010 add
    DEFINE l_img37                   LIKE img_file.img37       #CHI-C80007 add
    
    LET p_row = 2 LET p_col = 5
    OPEN WINDOW t325g_w AT p_row,p_col WITH FORM "aim/42f/aimt325g"
         ATTRIBUTE (STYLE = g_win_style)
 
    CALL cl_ui_locale("aimt325g")
 
    CONSTRUCT BY NAME l_wc ON img01,img02,img03,img04
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
    IF INT_FLAG THEN LET INT_FLAG=0 CLOSE WINDOW t325g_w RETURN END IF
    INPUT BY NAME t_img02,t_img03,t_img04
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
    IF INT_FLAG THEN LET INT_FLAG=0 CLOSE WINDOW t325g_w RETURN END IF
    LET l_sql="SELECT * FROM img_file WHERE ",l_wc CLIPPED,
              " AND img10 > 0",
              " ORDER BY img01,img02,img03,img04"
    PREPARE t325_g1_p FROM l_sql
    DECLARE t325_g1_c CURSOR FOR t325_g1_p
    INITIALIZE b_imn.* TO NULL
    SELECT MAX(imn02) INTO b_imn.imn02 FROM imn_file WHERE imn01=g_imm.imm01 
    IF b_imn.imn02 IS NULL THEN LET b_imn.imn02=0 END IF
    LET l_imn9301=s_costcenter(g_imm.imm14) #FUN-670093
    FOREACH t325_g1_c INTO l_img.*
       IF STATUS THEN EXIT FOREACH END IF
       LET b_imn.imn01 = g_imm.imm01
       LET b_imn.imn02 = b_imn.imn02 + 1
       LET b_imn.imn03 = l_img.img01
       LET b_imn.imn04 = l_img.img02
       LET b_imn.imn05 = l_img.img03
       LET b_imn.imn06 = l_img.img04
       LET b_imn.imn09 = l_img.img09
       LET b_imn.imn10 = l_img.img10
       LET b_imn.imn9301=l_imn9301 #FUN-670093
       LET b_imn.imn9302=l_imn9301 #FUN-670093
 
       IF t_img02 IS NULL
          THEN LET b_imn.imn15 = l_img.img02
          ELSE LET b_imn.imn15 = t_img02
       END IF
       IF t_img03 IS NULL
          THEN LET b_imn.imn16 = l_img.img03
          ELSE LET b_imn.imn16 = t_img03
       END IF
       IF t_img04 IS NULL
          THEN LET b_imn.imn17 = l_img.img04
          ELSE LET b_imn.imn17 = t_img04
       END IF
       CALL t325_b_move_to()
       LET b_imn.imn20=NULL LET b_imn.imn21=NULL
       SELECT img09,img21 INTO b_imn.imn20,b_imn.imn21
	FROM img_file WHERE img01=b_imn.imn03 AND img02=b_imn.imn15
			AND img03=b_imn.imn16 AND img04=b_imn.imn17
       IF SQLCA.sqlcode THEN
         #CHI-C50010 str add-----
         #SELECT img18 INTO l_date FROM img_file                #CHI-C80007 mark
          SELECT img18,img37 INTO l_date,l_img37 FROM img_file  #CHI-C80007 add img37
           WHERE img01 = g_imn[l_ac].imn03
             AND img02 = g_imn[l_ac].imn04
             AND img03 = g_imn[l_ac].imn05
             AND img04 = g_imn[l_ac].imn06
          CALL s_date_record(l_date,'Y')
         #CHI-C50010 end add-----
          CALL s_idledate_record(l_img37)  #CHI-C80007 add
          CALL s_add_img(g_imn[l_ac].imn03,g_imn[l_ac].imn15,
                         g_imn[l_ac].imn16,g_imn[l_ac].imn17,
                         g_imm.imm01      ,g_imn[l_ac].imn02,
                         g_imm.imm02)
          SELECT img09,img21 INTO b_imn.imn20,b_imn.imn21
	   FROM img_file WHERE img01=b_imn.imn03 AND img02=b_imn.imn15
			   AND img03=b_imn.imn16 AND img04=b_imn.imn17
       END IF
       LET b_imn.imn21 = b_imn.imn21 / l_img.img21
       LET b_imn.imn22 = b_imn.imn10 * b_imn.imn21
       LET b_imn.imn22 = s_digqty(b_imn.imn22,b_imn.imn20)   #No.FUN-BB0086
       LET b_imn.imn27 = 'N'
       LET b_imn.imnplant = g_plant #FUN-980004 add
       LET b_imn.imnlegal = g_legal #FUN-980004 add
       LET b_imn.imn12 ='N' #TQC-DB0039
       LET b_imn.imn24 ='N' #TQC-DB0039 
       INSERT INTO imn_file VALUES (b_imn.*)
       MESSAGE 'Insert seq no:',b_imn.imn02,' status:',SQLCA.SQLCODE
       #FUN-B70074-add-str--
       IF NOT s_industry('std') THEN
          INITIALIZE l_imni.* TO NULL
          LET l_imni.imni01 = b_imn.imn01
          LET l_imni.imni02 = b_imn.imn02
          LET l_flag = s_ins_imni(l_imni.*,b_imn.imnplant)
       END IF
       #FUN-B70074-add-end--
       #CHECK在途倉
       SELECT img09,img21 INTO b_imn.imn20,b_imn.imn21
        FROM img_file WHERE img01=b_imn.imn03 AND img02=b_imm.imm08
                        AND img03=' ' AND img04=' '
       IF SQLCA.sqlcode THEN
         #CHI-C50010 str add-----
         #SELECT img18 INTO l_date FROM img_file                #CHI-C80007 mark
          SELECT img18,img37 INTO l_date,l_img37 FROM img_file  #CHI-C80007 add img37
           WHERE img01 = g_imn[l_ac].imn03
             AND img02 = g_imn[l_ac].imn04
             AND img03 = g_imn[l_ac].imn05
             AND img04 = g_imn[l_ac].imn06
          CALL s_date_record(l_date,'Y')
         #CHI-C50010 end add-----
          CALL s_idledate_record(l_img37)  #CHI-C80007 add
          CALL s_add_img(g_imn[l_ac].imn03,g_imm.imm08,' ',' ',
                         g_imm.imm01,g_imn[l_ac].imn02,g_imm.imm02)
       END IF
    END FOREACH
    CLOSE WINDOW t325g_w
 
    CALL t325_b_fill(' 1=1')
END FUNCTION
 
FUNCTION t325_a()
    DEFINE  li_result   LIKE type_file.num5     #No.FUN-550029  #No.FUN-690026 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_imn.clear()
    INITIALIZE g_imm.* TO NULL
    LET g_imm_o.* = g_imm.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_imm.imm02  =g_today
        LET g_imm.imm04  = 'N'
        LET g_imm.imm03  = 'N'
        LET g_imm.immspc = '0' #FUN-680010
        LET g_imm.immconf= 'N' #FUN-660029
        LET g_imm.imm10  = '2'
        LET g_imm.imm11  = ''
        LET g_imm.imm12  = ''
        LET g_imm.imm13  = ''
        LET g_imm.immuser=g_user
        LET g_imm.immoriu = g_user #FUN-980030
        LET g_imm.immorig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_imm.immgrup=g_grup
        LET g_imm.immdate=g_today
        LET g_imm.imm14=g_grup #FUN-670093
        LET g_imm.immplant = g_plant #FUN-980004 add
        LET g_imm.immlegal = g_legal #FUN-980004 add
        CALL t325_i("a")                #輸入單頭
        IF INT_FLAG THEN
           INITIALIZE g_imm.* TO NULL
           LET INT_FLAG=0 CALL cl_err('',9001,0) ROLLBACK WORK RETURN
        END IF
        IF cl_null(g_imm.imm01) THEN CONTINUE WHILE END IF
        BEGIN WORK
        CALL s_auto_assign_no("aim",g_imm.imm01,g_imm.imm02,"4","imm_file","imm01",
                  "","","")
             RETURNING li_result,g_imm.imm01
        IF (NOT li_result) THEN
             CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_imm.imm01
        #FUN-A60034--add---str---
        #FUN-A70104--mod---str---
        LET g_imm.immmksg = 'N'  #是否簽核
        LET g_imm.imm15 = '0'    #簽核狀況
        LET g_imm.imm16 = g_user #申請人
        #FUN-A70104--mod---end---
        #FUN-A60034--add---end---
        INSERT INTO imm_file VALUES (g_imm.*)
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
        #   ROLLBACK WORK        #FUN-B80070---回滾放在報錯後---
           CALL cl_err3("ins","imm_file",g_imm.imm01,"",SQLCA.sqlcode,"",
                        "ins imm",1)   #NO.FUN-640266  #No.FUN-660156
           ROLLBACK WORK          #FUN-B80070--add--
           CONTINUE WHILE
        ELSE
           COMMIT WORK #No:7857
           CALL cl_flow_notify(g_imm.imm01,'I')
        END IF
        SELECT imm01 INTO g_imm.imm01 FROM imm_file WHERE imm01 = g_imm.imm01 
        LET g_imm_t.* = g_imm.*
        CALL g_imn.clear()
        LET g_rec_b = 0
        #CALL t325_b()     #輸入單身   #CHI-C50041
        CALL aimt325_g()  #CHI-C50041
        SELECT COUNT(*) INTO g_i FROM imn_file WHERE imn01=g_imm.imm01 
        IF g_i>0 THEN
           IF g_smy.smyprint='Y' THEN
              IF cl_confirm('mfg9392') THEN CALL t325_out() END IF
           END IF
           IF g_smy.smydmy4='Y' THEN 
              #CALL t325_y() #DEV-D30046 --mark
              #DEV-D30046 --add--begin 
              CALL t325sub_y(g_imm.imm01,FALSE,'Y')
              CALL t325sub_refresh(g_imm.imm01) RETURNING g_imm.*
              CALL t325_show()
              #DEV-D30046 --add--end 
           END IF
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t325_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_imm.imm01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_imm.* FROM imm_file WHERE imm01=g_imm.imm01 
    IF g_imm.imm03 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
    IF g_imm.imm04 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
    IF g_imm.imm04 = 'X' THEN CALL cl_err('',9024,0) RETURN END IF #NO:7419-3
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_imm_o.* = g_imm.*
    BEGIN WORK
 
    OPEN t325_cl USING g_imm.imm01
    IF STATUS THEN
       CALL cl_err("OPEN t325_cl:", STATUS, 1)
       CLOSE t325_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t325_cl INTO g_imm.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imm.imm01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t325_cl ROLLBACK WORK RETURN
    END IF
    CALL t325_show()
    WHILE TRUE
        LET g_imm.immmodu=g_user
        LET g_imm.immdate=g_today
        CALL t325_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_imm.*=g_imm_t.*
            CALL t325_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        UPDATE imm_file SET * = g_imm.* WHERE imm01 = g_imm_o.imm01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err3("upd","imm_file",g_imm_t.imm01,"",SQLCA.sqlcode,"",
                        "upd imm",1)   #NO.FUN-640266
           CONTINUE WHILE
        END IF
        IF g_imm.imm01 != g_imm_t.imm01 THEN CALL t325_chkkey() END IF
        EXIT WHILE
    END WHILE
    CLOSE t325_cl
    COMMIT WORK
    CALL cl_flow_notify(g_imm.imm01,'U')
END FUNCTION
 
FUNCTION t325_chkkey()
      UPDATE imn_file SET imn01=g_imm.imm01 WHERE imn01=g_imm_t.imm01 
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","imn_file",g_imm_t.imm01,"",SQLCA.sqlcode,"",
                      "upd imn01",1)   #NO.FUN-640266 #No.FUN-660156
         LET g_imm.*=g_imm_t.* CALL t325_show() ROLLBACK WORK RETURN
      END IF
END FUNCTION
 
FUNCTION t325_i(p_cmd)
  DEFINE p_cmd           LIKE type_file.chr1    #a:輸入 u:更改  #No.FUN-690026 VARCHAR(1)
  DEFINE l_flag          LIKE type_file.chr1    #判斷必要欄位是否有輸入  #No.FUN-690026 VARCHAR(1)
  DEFINE li_result       LIKE type_file.num5    #No.FUN-550029  #No.FUN-690026 SMALLINT
  CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    INPUT BY NAME g_imm.immoriu,g_imm.immorig,
             g_imm.imm01,g_imm.imm02,g_imm.imm09,g_imm.imm14,g_imm.imm08, #FUN-670093
             g_imm.imm04,g_imm.imm03,g_imm.immplant,g_imm.immspc,g_imm.immuser,g_imm.immgrup, #FUN-680010 
             g_imm.immmodu,g_imm.immdate
             WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t325_set_entry(p_cmd)
            CALL t325_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
            CALL cl_set_docno_format("imm01")
            CALL cl_set_docno_format("imm11")
            LET g_imm.immplant = g_plant 
            DISPLAY BY NAME g_imm.immplant
            CALL t324_immplant('a')
 
        AFTER FIELD imm01
            IF NOT cl_null(g_imm.imm01) THEN
               LET g_t1 = s_get_doc_no(g_imm.imm01)                             
               IF ( g_sma.sma120 = 'Y' )AND( g_sma.sma907 = 'Y' ) THEN          
                  SELECT smy62 INTO lg_smy62 FROM smy_file WHERE smyslip = g_t1 
                  CALL t325_refresh_detail()                                    
               ELSE                                                             
                  LET lg_smy62 = ''                                             
               END IF                
                 CALL s_check_no("aim",g_imm.imm01,g_imm_t.imm01,"4","imm_file","imm01","")  #No.FUN-560060
                     RETURNING li_result,g_imm.imm01
                 DISPLAY BY NAME g_imm.imm01
                 IF (NOT li_result) THEN
                    IF p_cmd = 'a' THEN
                        NEXT FIELD imm01
                    END IF
                 END IF
           ELSE 
              IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN                
                  LET lg_smy62 = ''                                             
                  CALL t325_refresh_detail()                                    
              END IF          
           END IF
 
        AFTER FIELD imm02
	   IF NOT cl_null(g_imm.imm02) THEN
	      IF g_sma.sma53 IS NOT NULL AND g_imm.imm02 <= g_sma.sma53 THEN
	         CALL cl_err('','mfg9999',0) NEXT FIELD imm02
	      END IF
              CALL s_yp(g_imm.imm02) RETURNING g_yy,g_mm
              IF (g_yy*12+g_mm)>(g_sma.sma51*12+g_sma.sma52)THEN #不可大於現行年月
                 CALL cl_err('','mfg6091',0) NEXT FIELD imm02
              END IF
           END IF
 
        AFTER FIELD imm08
           IF NOT cl_null(g_imm.imm08) THEN
              CALL t325_imm08(g_imm.imm08)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('sel imd:',g_errno,1) NEXT FIELD imm08
              END IF
              CALL t325_chk_imm08()
              IF p_cmd = 'u' THEN
                 CALL t325_chk_jce(g_wip,g_imn[l_ac].imn04,g_imn[l_ac].imn15)
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_imm.imm08,g_errno,1)
                    NEXT FIELD imm08
                 END IF
              END IF
              #No.FUN-AA0049--begin
              IF NOT s_chk_ware(g_imm.imm08) THEN
                 NEXT FIELD g_imm.imm08
              END IF 
              #No.FUN-AA0049--end           
           END IF
        AFTER FIELD imm14
            IF NOT cl_null(g_imm.imm14) THEN
               SELECT gem02 INTO g_buf FROM gem_file
                WHERE gem01=g_imm.imm14
                  AND gemacti='Y'
               IF STATUS THEN
                  CALL cl_err3("sel","gem_file",g_imm.imm14,"",SQLCA.sqlcode,"",
                               "select gem",1)
                  NEXT FIELD imm14
               END IF
               DISPLAY g_buf TO gem02
               #FUN-CB0087---add---str---
               IF NOT t325_imn28_chk() THEN
                  LET g_imm.imm14 = g_imm_t.imm14
                  NEXT FIELD imm14
               END IF
               #FUN-CB0087---end---str---
            END IF
 
        AFTER INPUT
           LET g_imm.immuser = s_get_data_owner("imm_file") #FUN-C10039
           LET g_imm.immgrup = s_get_data_group("imm_file") #FUN-C10039
           IF INT_FLAG THEN EXIT INPUT END IF
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(imm01) #查詢單据
                   LET g_t1=s_get_doc_no(g_imm.imm01)    #No.FUN-550029
                   CALL q_smy(FALSE,TRUE,g_t1,'AIM','4') RETURNING g_t1                     #TQC-670008
                   LET g_imm.imm01=g_t1                  #No.FUN-550029
                   DISPLAY BY NAME g_imm.imm01
                   NEXT FIELD imm01
              WHEN INFIELD(imm08) #查詢在途倉
                   #No.FUN-AA0049--begin
                   #CALL cl_init_qry_var()
                   #LET g_qryparam.form     ="q_imd"
                   #LET g_qryparam.default1 = g_imm.imm08
                   #LET g_qryparam.arg1     = "W"
                   #CALL cl_create_qry() RETURNING g_imm.imm08
                  #CALL q_imd_1(FALSE,TRUE,g_imm.imm08,'w',"","","") RETURNING g_imm.imm08  #No.TQC-AB0016
                   CALL q_imd_1(FALSE,TRUE,g_imm.imm08,'W',"","","") RETURNING g_imm.imm08  #No.TQC-AB0016 #MOD-AC0191 w->W
                   #No.FUN-AA0049--end
                   DISPLAY BY NAME g_imm.imm08
                   NEXT FIELD imm08
              WHEN INFIELD(imm14)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gem"
                   LET g_qryparam.default1 = g_imm.imm14
                   CALL cl_create_qry() RETURNING g_imm.imm14
                   DISPLAY BY NAME g_imm.imm14
                   NEXT FIELD imm14
              OTHERWISE EXIT CASE
           END CASE
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
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
 
FUNCTION t325_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("imm01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t325_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("imm01",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION t325_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_imm.* TO NULL             #No.FUN-680046
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
 
    IF g_sma.sma120 = 'Y'  THEN                                                                                                     
       LET lg_smy62 = ''                                                                                                            
       LET lg_group = ''                                                                                                            
       CALL t325_refresh_detail()                                                                                                   
    END IF                                                                                                                          
 
    CALL t325_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 INITIALIZE g_imm.* TO NULL RETURN END IF
    MESSAGE " SEARCHING ! "
    OPEN t325_cs               # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_imm.* TO NULL
    ELSE
        OPEN t325_count
        FETCH t325_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t325_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION t325_fetch(p_flag)
DEFINE
    p_flag      LIKE type_file.chr1       #處理方式  #No.FUN-690026 VARCHAR(1)
DEFINE l_slip   LIKE smy_file.smyslip     #NO.TQC-650115 #No.FUN-690026 VARCHAR(10)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t325_cs INTO g_imm.imm01
        WHEN 'P' FETCH PREVIOUS t325_cs INTO g_imm.imm01
        WHEN 'F' FETCH FIRST    t325_cs INTO g_imm.imm01
        WHEN 'L' FETCH LAST     t325_cs INTO g_imm.imm01
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
            FETCH ABSOLUTE g_jump t325_cs INTO g_imm.imm01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imm.imm01,SQLCA.sqlcode,0)
        INITIALIZE g_imm.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_imm.* FROM imm_file WHERE imm01 = g_imm.imm01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","imm_file",g_imm.imm01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
       INITIALIZE g_imm.* TO NULL
        RETURN
    ELSE
        LET g_data_owner = g_imm.immuser #FUN-4C0053
        LET g_data_group = g_imm.immgrup #FUN-4C0053
        LET g_data_plant = g_imm.immplant #FUN-980030
    END IF
    IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN                           
       LET l_slip = g_imm.imm01[1,g_doc_len]                                    
       SELECT smy62 INTO lg_smy62 FROM smy_file                                 
          WHERE smyslip = l_slip                                                
    END IF                
    CALL t325_show()
 
END FUNCTION
 
FUNCTION t324_immplant(p_cmd)
DEFINE  p_cmd        LIKE type_file.chr1
DEFINE  l_immplant_desc LIKE gem_file.gem02
 
  SELECT azp02 INTO l_immplant_desc FROM azp_file WHERE azp01 = g_plant 
 
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     DISPLAY l_immplant_desc TO FORMONLY.immplant_desc
  END IF
 
END FUNCTION
 
 
FUNCTION t325_show()
    LET g_imm_t.* = g_imm.*                #保存單頭舊值
    DISPLAY BY NAME g_imm.immoriu,g_imm.immorig,
	g_imm.imm01,g_imm.imm02,g_imm.imm08,g_imm.imm09,g_imm.imm14,  #FUN-670093
        g_imm.imm04,g_imm.imm03,g_imm.immplant,g_imm.immspc,   #FUN-680010 #FUN-870100
        g_imm.imm11,g_imm.imm12,g_imm.imm13,    #bugno:6810 add
	g_imm.immuser,g_imm.immgrup,g_imm.immmodu,g_imm.immdate
    CALL t325_chk_imm08()
 
    CALL t325_imm13('d')   #MOD-630085
    DISPLAY s_costcenter_desc(g_imm.imm14) TO FORMONLY.gem02 #FUN-670093
    LET g_buf = s_get_doc_no(g_imm.imm01)     #No.FUN-550029
    CALL t325_b_fill(' 1=1')

    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t325_r()
    DEFINE l_chr,l_sure LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
    DEFINE l_flag LIKE type_file.chr1          #FUN-B70074
 
    IF s_shut(0) THEN RETURN END IF
    IF g_imm.imm01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_imm.* FROM imm_file WHERE imm01=g_imm.imm01 
    IF g_imm.imm03 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
    IF g_imm.imm04 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
    IF g_imm.imm04 = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
 
    BEGIN WORK
 
    OPEN t325_cl USING g_imm.imm01
    IF STATUS THEN
       CALL cl_err("OPEN t325_cl:", STATUS, 1)
       CLOSE t325_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t325_cl INTO g_imm.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_imm.imm01,SQLCA.sqlcode,0)
       CLOSE t325_cl
       ROLLBACK WORK
       RETURN
    END IF
    CALL t325_show()
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "imm01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_imm.imm01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
       MESSAGE "Delete imm,imn!"
       DELETE FROM imm_file WHERE imm01 = g_imm.imm01 
       IF SQLCA.SQLERRD[3]=0
          THEN 
               CALL cl_err3("del","imm_file",g_imm.imm01,"",SQLCA.sqlcode,"",
                            "No imm deleted",1)   #NO.FUN-640266 #No.FUN-660156
               ROLLBACK WORK RETURN
       END IF
       DELETE FROM imn_file WHERE imn01 = g_imm.imm01
       #FUN-B70074-add-str--
       IF NOT s_industry('std') THEN
          LET l_flag = s_del_imni(g_imm.imm01,'','') 
       END IF
       #FUN-B70074-add-end--
       #No.MOD-AA0086  --Begin
       DELETE FROM imn_file WHERE imn01 = g_imm.imm01
       #FUN-B70074-add-str--
       IF NOT s_industry('std') THEN
          LET l_flag = s_del_imni(g_imm.imm01,'','') 
       END IF
       #FUN-B70074-add-end--
       FOR g_i = 1 TO g_rec_b
          #IF NOT s_del_rvbs('1',g_imm.imm01,g_imn[g_i].imn02,0)  THEN        #FUN-880129   #TQC-B90236 mark
           IF NOT s_lot_del(g_prog,g_imm.imm01,'',0,g_imn[g_i].imn03,'DEL') THEN    #TQC-B90236 add
              ROLLBACK WORK
              RETURN
           END IF
       END FOR
       #No.MOD-AA0086  --End  
       LET g_msg=TIME
       INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980004 add azoplant,azolegal
       VALUES ('aimt325',g_user,g_today,g_msg,g_imm.imm01,'delete',g_plant,g_legal) #FUN-980004 add g_plant,g_legal
       CLEAR FORM
       CALL g_imn.clear()
       INITIALIZE g_imm.* TO NULL
       MESSAGE ""
       OPEN t325_count
       #FUN-B50062-add-start--
       IF STATUS THEN
          CLOSE t325_cs
          CLOSE t325_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       FETCH t325_count INTO g_row_count
       #FUN-B50062-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t325_cs
          CLOSE t325_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t325_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t325_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL t325_fetch('/')
       END IF
    END IF
    CLOSE t325_cl
    COMMIT WORK
    CALL cl_flow_notify(g_imm.imm01,'D')
END FUNCTION
 
FUNCTION t325_b()
DEFINE
    l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT  #No.FUN-690026 SMALLINT
    l_n,l_cnt       LIKE type_file.num5,   #檢查重複用  #No.FUN-690026 SMALLINT
    l_lock_sw       LIKE type_file.chr1,   #單身鎖住否  #No.FUN-690026 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,   #處理狀態    #No.FUN-690026 VARCHAR(1)
    l_img10         LIKE img_file.img10,
    l_ima02         LIKE ima_file.ima02,
    l_imn10         LIKE imn_file.imn10,   #No:6891
    l_allow_insert  LIKE type_file.num5,   #可新增否  #No.FUN-690026 SMALLINT
    l_allow_delete  LIKE type_file.num5    #可刪除否  #No.FUN-690026 SMALLINT
DEFINE li_i         LIKE type_file.num5                                                        #No.FUN-690026 SMALLINT
DEFINE l_count      LIKE type_file.num5                                                        #No.FUN-690026 SMALLINT
DEFINE l_temp       LIKE ima_file.ima01                                         
DEFINE l_check_res  LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE l_imd20      LIKE imd_file.imd20      #No.FUN-870100
DEFINE l_imd20_1    LIKE imd_file.imd20      #No.FUN-870100
#DEFINE l_imaicd13   LIKE imaicd_file.imaicd13   #FUN-A40022   #FUN-B50096
DEFINE l_ima159     LIKE ima_file.ima159         #FUN-B50096  
DEFINE l_imni       RECORD LIKE imni_file.*            #FUN-B70074 
DEFINE l_smy57      LIKE smy_file.smy57      #FUN-B30053
DEFINE l_imm01      LIKE imm_file.imm01      #FUN-B30053
DEFINE l_tf         LIKE type_file.chr1      #No.FUN-BB0086
DEFINE l_case       STRING                   #No.FUN-BB0086
   #FUN-C20002--start add----------------------------------
   DEFINE l_ima154    LIKE ima_file.ima154
   DEFINE l_rcj03     LIKE rcj_file.rcj03
   DEFINE l_rtz07     LIKE rtz_file.rtz07
   DEFINE l_rtz08     LIKE rtz_file.rtz08  
   #FUN-C20002--end add------------------------------------ 
DEFINE l_c          LIKE type_file.num5     #CHI-C30106 add
DEFINE l_flag       LIKE type_file.chr1     #FUN-CB0087
DEFINE l_sql        STRING                  #FUN-CB0087
DEFINE l_where      STRING                  #FUN-CB0087
DEFINE l_store      STRING                  #FUN-CB0087

    LET g_action_choice = ""
    IF g_imm.imm01 IS NULL THEN RETURN END IF
    SELECT * INTO g_imm.* FROM imm_file WHERE imm01=g_imm.imm01 
    IF g_imm.imm03 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
     IF (g_prog<>"aimt326") THEN
        IF g_imm.imm04 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
     END IF
    IF g_imm.imm04 = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT * FROM imn_file ",
                       " WHERE imn01= ? AND imn02= ? AND imnplant= ? FOR UPDATE "    #FUN-870100
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t325_bcl CURSOR FROM g_forupd_sql
 
    LET l_ac_t = 0
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    IF (g_prog="aimt326") AND (g_imm.imm03 = 'N') AND (g_imm.imm04='Y') THEN
       LET l_allow_insert = FALSE
       LET l_allow_delete = FALSE
    END IF
 
    INPUT ARRAY g_imn WITHOUT DEFAULTS FROM s_imn.*
          ATTRIBUTE(COUNT=g_rec_b, MAXCOUNT=g_max_rec, UNBUFFERED,
                    INSERT ROW=l_allow_insert, DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
           #No.FUN-BB0086--add--begin--
           LET g_imn30_t = NULL 
           LET g_imn33_t = NULL 
           #No.FUN-BB0086--add--end--
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK
 
            OPEN t325_cl USING g_imm.imm01
            IF STATUS THEN
               CALL cl_err("OPEN t325_cl:", STATUS, 1)
               CLOSE t325_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t325_cl INTO g_imm.*
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_imm.imm01,SQLCA.sqlcode,0)
               CLOSE t325_cl
               ROLLBACK WORK
               RETURN
            END IF
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_imn_t.* = g_imn[l_ac].*
               LET g_imn_o.* = g_imn[l_ac].*    #MOD-C10152 add
               #No.FUN-BB0086--add--begin--
               LET g_imn30_t = g_imn[l_ac].imn30
               LET g_imn33_t = g_imn[l_ac].imn33
               #No.FUN-BB0086--add--end--
               OPEN t325_bcl USING g_imm.imm01,g_imn_t.imn02,g_imm.immplant #FUN-870100
               IF STATUS THEN
                  CALL cl_err("OPEN t325_bcl:", STATUS, 1)
                  CLOSE t325_bcl
                  ROLLBACK WORK
                  RETURN
               ELSE
                  FETCH t325_bcl INTO b_imn.*
                  IF SQLCA.sqlcode THEN
                      CALL cl_err('lock imn',SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                  END IF
                  CALL t325_b_move_to()
                  CALL t325_imn03('d')
                  LET g_imn[l_ac].gem02b=s_costcenter_desc(g_imn[l_ac].imn9301) #FUN-670093
                  LET g_imn[l_ac].gem02c=s_costcenter_desc(g_imn[l_ac].imn9302) #FUN-670093
               END IF
               #FUN-A40022--begin--add-----
             # IF s_industry('icd') THEN           #FUN-B50096
               CALL t325_set_no_required_1()
               CALL t325_set_required_1(p_cmd)
               CALL t325_set_entry_imn()           #FUN-B50096
               CALL t325_set_no_entry_imn()        #FUN-B50096
             # END IF    #FUN-B50096
               #FUN-A40022--end--add-------
               #No.FUN-570249  --begin
               LET g_yes   ='N'
               SELECT ima906 INTO g_ima906 FROM ima_file WHERE ima01=g_imn[l_ac].imn03   #MOD-C10156 add
               CALL t325_set_no_required()     #MOD-C10156 add
               CALL t325_set_required()        #MOD-C10156 add
               CALL t325_set_entry_b()
               CALL t325_set_no_entry_b()
               CALL cl_show_fld_cont()     #FUN-550037(smin)
               
               CALL t325_set_no_entry_imn()  #MOD-D30256
               IF g_prog="aimt326" THEN
               #MOD-D30256---begin
               #   CALL cl_set_comp_entry("imn02,imn03,imn28,imn04,imn05,imn06,imn09,imn33,imn34,imn35,imn30,imn31,
               #                           imn32,imn20,imn10,imn22,imn21,imn43,imn44,imn45,imn40,imn41,imn42,imn52,
               #                           imn51,imn26",TRUE) 
               #END IF
               #IF (g_prog="aimt326") AND (g_imm.imm03 = 'N') AND (g_imm.imm04='Y') THEN
               #MOD-D30256---end
                  CALL cl_set_comp_entry("imn02,imn03,imn28,imn04,imn05,imn06,imn09,imn33,imn34,imn35,imn30,imn31,
                                          imn32,imn20,imn10,imn22,imn21,imn43,imn44,imn45,imn40,imn41,imn42,imn52,
                                          imn51,imn26",FALSE)
               END IF
               #CALL t325_set_no_entry_imn()        #FUN-B50096  #MOD-D30256 往上移
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
 
            IF g_sma.sma115 = 'Y' THEN
               CALL s_chk_va_setting(g_imn[l_ac].imn03)
                    RETURNING g_flag,g_ima906,g_ima907
               IF g_flag=1 THEN
                  NEXT FIELD imn03
               END IF
               CALL t325_du_data_to_correct()
               CALL t325_set_origin_field()
            END IF
            CALL t325_b_move_back()
 
           #str MOD-A30247 add
           #在寫入imn_file前重新帶出imn09與imn20
            IF cl_null(g_imn[l_ac].imn09) THEN
               SELECT img09 INTO g_imn[l_ac].imn09
                 FROM img_file WHERE img01=g_imn[l_ac].imn03 AND
                                     img02=g_imn[l_ac].imn04 AND
                                     img03=g_imn[l_ac].imn05 AND
                                     img04=g_imn[l_ac].imn06
               DISPLAY BY NAME g_imn[l_ac].imn09
            END IF
            IF cl_null(g_imn[l_ac].imn20) THEN
               SELECT img09  INTO g_imn[l_ac].imn20
                 FROM img_file WHERE img01=g_imn[l_ac].imn03 AND
                                     img02=g_imn[l_ac].imn15 AND
                                     img03=g_imn[l_ac].imn16 AND
                                     img04=g_imn[l_ac].imn17
               DISPLAY BY NAME g_imn[l_ac].imn20
            END IF
           #end MOD-A30247 add

            INSERT INTO imn_file VALUES(b_imn.*)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","imn_file",b_imn.imn01,"",SQLCA.sqlcode,
                            "","ins imn",1)   #NO.FUN-640266 #No.FUN-660156
               CANCEL INSERT
               #No.MOD-AA0086  --Begin
               SELECT ima918,ima921 INTO g_ima918,g_ima921
                 FROM ima_file
                WHERE ima01 = g_imn[l_ac].imn03
                  AND imaacti = "Y"

               IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                 #IF NOT s_lotout_del(g_prog,g_imm.imm01,g_imn[l_ac].imn02,0,g_imn[l_ac].imn03,'DEL') THEN    #TQC-B90236 mark
                  IF NOT s_lot_del(g_prog,g_imm.imm01,g_imn[l_ac].imn02,0,g_imn[l_ac].imn03,'DEL') THEN    #TQC-B90236 add
                     CALL cl_err3("del","rvbs_file",g_imm.imm01,g_imn[l_ac].imn02,SQLCA.sqlcode,"","",1)
                     ROLLBACK WORK      #CHI-A10016
                     CANCEL INSERT      #CHI-A10016
                  END IF
               END IF
               #No.MOD-AA0086  --End  
            ELSE
               #FUN-B70074-add-str--
               IF NOT s_industry('std') THEN
                  INITIALIZE l_imni.* TO NULL
                  LET l_imni.imni01 = b_imn.imn01
                  LET l_imni.imni02 = b_imn.imn02
                  IF NOT s_ins_imni(l_imni.*,b_imn.imnplant) THEN
                     CANCEL INSERT
                  END IF               
               END IF
               #FUN-B70074--add-end--
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_imn[l_ac].* TO NULL      #900423
            INITIALIZE arr_detail[l_ac].* TO NULL  #No.TQC-650115
           #-----------------No:MOD-A10089 mark
           #IF l_ac>1 THEN
           #   LET g_imn[l_ac].imn03 =g_imn[l_ac-1].imn03
           #   LET g_imn[l_ac].imn04 =g_imn[l_ac-1].imn04
           #   LET g_imn[l_ac].imn05 =g_imn[l_ac-1].imn05
           #   LET g_imn[l_ac].imn06 =g_imn[l_ac-1].imn06
           #   LET g_imn[l_ac].imn15 =g_imn[l_ac-1].imn15
           #   LET g_imn[l_ac].imn16 =g_imn[l_ac-1].imn16
           #   LET g_imn[l_ac].imn17 =g_imn[l_ac-1].imn17
           #END IF
           #-----------------No:MOD-A10089 end
            #CHI-C50041---begin
            LET g_imn[l_ac].imn04 = l_imn04
            LET g_imn[l_ac].imn05 = l_imn05
            LET g_imn[l_ac].imn15 = l_imn15
            LET g_imn[l_ac].imn16 = l_imn16
            LET g_imn[l_ac].imn28 = l_imn28
            #CHI-C50041---end
            INITIALIZE g_imn_t.* TO NULL
            LET b_imn.imn01=g_imm.imm01
            LET g_imn[l_ac].imn10=0
            LET g_imn[l_ac].imn22=0
            LET g_imn[l_ac].imn21=1
           #LET g_imn[l_ac].imn29='N'   #No.FUN-5C0077   #FUN-B30053 mark
            #FUN-B30053-add-str--
            LET l_imm01 = s_get_doc_no(g_imm.imm01)
            SELECT smy57 INTO l_smy57 FROM smy_file WHERE smyslip = l_imm01 AND smyacti = 'Y'
            IF cl_null(l_smy57[2,2]) THEN
               LET l_smy57[2,2] = 'N'
            END IF
            LET g_imn[l_ac].imn29 = l_smy57[2,2]
            #FUN-B30053-add-end--
            LET g_yes   ='N'
            LET g_imn[l_ac].imn35=0
            LET g_imn[l_ac].imn32=0
            LET g_imn[l_ac].imn45=0
            LET g_imn[l_ac].imn42=0
            LET g_imn[l_ac].imn51=1
            LET g_imn[l_ac].imn52=1
            LET g_imn[l_ac].imn9301=s_costcenter(g_imm.imm14) #FUN-670093
            LET g_imn[l_ac].imn9302=g_imn[l_ac].imn9301 #FUN-670093
            LET g_imn[l_ac].gem02b=s_costcenter_desc(g_imn[l_ac].imn9301) #FUN-670093
            LET g_imn[l_ac].gem02c=s_costcenter_desc(g_imn[l_ac].imn9302) #FUN-670093
            CALL t325_set_entry_b()
            CALL t325_set_no_entry_b()
            CALL cl_show_fld_cont()     #FUN-550037(smin)
 
	BEFORE FIELD imn02                            #default 序號
            IF cl_null(g_imn[l_ac].imn02) OR g_imn[l_ac].imn02 = 0 THEN
               SELECT max(imn02)+1 INTO g_imn[l_ac].imn02 FROM imn_file
                WHERE imn01 = g_imm.imm01 
               IF g_imn[l_ac].imn02 IS NULL THEN
                  LET g_imn[l_ac].imn02 = 1
               END IF
            END IF
 
        AFTER FIELD imn02                        #check 序號是否重複
            IF NOT cl_null(g_imn[l_ac].imn02) THEN
               IF g_imn[l_ac].imn02 != g_imn_t.imn02 OR
                  g_imn_t.imn02 IS NULL THEN
                   SELECT count(*) INTO l_n FROM imn_file
                    WHERE imn01 = g_imm.imm01 AND imn02 = g_imn[l_ac].imn02 
                   IF l_n > 0 THEN
                      LET g_imn[l_ac].imn02 = g_imn_t.imn02
                      CALL cl_err('',-239,0) NEXT FIELD imn02
                   END IF
               END IF
            END IF
        BEFORE FIELD imn03
	    IF g_sma.sma60 = 'Y' THEN    #若須分段輸入
	       CALL s_inp5(9,14,g_imn[l_ac].imn03)
                    RETURNING g_imn[l_ac].imn03
                    DISPLAY BY NAME g_imn[l_ac].imn03
	       DISPLAY BY NAME g_imn[l_ac].imn03
               IF INT_FLAG THEN LET INT_FLAG = 0 END IF
      	    END IF
            CALL t325_set_entry_b()
            CALL t325_set_no_required()
            CALL t325_set_entry_imn()           #FUN-B50096
 
        AFTER FIELD imn03  #PART
#FUN-AA0059 ---------------------start----------------------------
           IF NOT cl_null(g_imn[l_ac].imn03) THEN
              IF NOT s_chk_item_no(g_imn[l_ac].imn03,"") THEN
                 CALL cl_err('',g_errno,1)
                 NEXT FIELD imn03
              END IF
           END IF 
#FUN-AA0059 ---------------------end-------------------------------
           IF NOT s_chkima08(g_imn[l_ac].imn03) THEN
              NEXT FIELD CURRENT 
           END IF
           CALL t325_check_imn03('imn03',l_ac) RETURNING l_check_res
           IF NOT l_check_res THEN NEXT FIELD imn03 END IF     
           SELECT imaag INTO l_imaag FROM ima_file                          
            WHERE ima01 = g_imn[l_ac].imn03 
           IF NOT cl_null(l_imaag) AND l_imaag <> '@CHILD' THEN             
              CALL cl_err(g_imn[l_ac].imn03,'aim1004',0) 
              NEXT FIELD imn03                                              
           END IF  
           #FUN-A40022--begin--add-----
         # IF s_industry('icd') THEN        #FUN-B50096
           CALL t325_set_no_required_1()
           CALL t325_set_required_1(p_cmd)
           CALL t325_set_no_entry_imn() #FUN-B50096
         # END IF                           #FUN-B50096
           #FUN-A400222--end--add-------
           LET g_imn_o.imn03=g_imn[l_ac].imn03 #MOD-C10152 add
           
        BEFORE FIELD att00    
            SELECT imx00,imx01,imx02,imx03,imx04,imx05,                         
                   imx06,imx07,imx08,imx09,imx10                                
            INTO g_imn[l_ac].att00, g_imn[l_ac].att01, g_imn[l_ac].att02,       
                 g_imn[l_ac].att03, g_imn[l_ac].att04, g_imn[l_ac].att05,       
                 g_imn[l_ac].att06, g_imn[l_ac].att07, g_imn[l_ac].att08,       
                 g_imn[l_ac].att09, g_imn[l_ac].att10                           
            FROM imx_file                                                       
            WHERE imx000 = g_imn[l_ac].imn04                                    
            LET g_imn[l_ac].att01 = g_imn[l_ac].att01_c                         
            LET g_imn[l_ac].att02 = g_imn[l_ac].att02_c                         
            LET g_imn[l_ac].att03_c = g_imn[l_ac].att03                         
            LET g_imn[l_ac].att04_c = g_imn[l_ac].att04                         
            LET g_imn[l_ac].att05_c = g_imn[l_ac].att05                         
            LET g_imn[l_ac].att06_c = g_imn[l_ac].att06                         
            LET g_imn[l_ac].att07_c = g_imn[l_ac].att07                         
            LET g_imn[l_ac].att08_c = g_imn[l_ac].att08                         
            LET g_imn[l_ac].att09_c = g_imn[l_ac].att09                         
            LET g_imn[l_ac].att10_c = g_imn[l_ac].att10                         
            DISPLAY BY NAME                                                     
              g_imn[l_ac].att01, g_imn[l_ac].att01_c,                           
              g_imn[l_ac].att02, g_imn[l_ac].att02_c,    
              g_imn[l_ac].att03, g_imn[l_ac].att03_c,                           
              g_imn[l_ac].att04, g_imn[l_ac].att04_c,                           
              g_imn[l_ac].att05, g_imn[l_ac].att05_c,                           
              g_imn[l_ac].att06, g_imn[l_ac].att06_c,                           
              g_imn[l_ac].att07, g_imn[l_ac].att07_c,                           
              g_imn[l_ac].att08, g_imn[l_ac].att08_c,                           
              g_imn[l_ac].att09, g_imn[l_ac].att09_c,                           
              g_imn[l_ac].att10, g_imn[l_ac].att10_c  
 
      AFTER FIELD att00                                                         
          SELECT COUNT(ima01) INTO l_count FROM ima_file                        
            WHERE ima01 = g_imn[l_ac].att00 AND imaag = lg_smy62                
          IF l_count = 0 THEN                                                   
             CALL cl_err_msg('','aim-909',lg_smy62,0)                           
             NEXT FIELD att00                                                   
          END IF                                                                
                                                                                
             CALL t325_check_imn03('imx00',l_ac) RETURNING                      
               l_check_res                 
             IF NOT l_check_res THEN NEXT FIELD att00 END IF                    
                                                                                
      AFTER FIELD att01                                                         
          CALL t325_check_att0x(g_imn[l_ac].att01,1,l_ac) RETURNING             
               l_check_res                 
          IF NOT l_check_res THEN NEXT FIELD att01 END IF                       
      AFTER FIELD att02                                                         
          CALL t325_check_att0x(g_imn[l_ac].att02,2,l_ac) RETURNING             
               l_check_res
          IF NOT l_check_res THEN NEXT FIELD att02 END IF                       
      AFTER FIELD att03                                                         
          CALL t325_check_att0x(g_imn[l_ac].att03,3,l_ac) RETURNING             
               l_check_res
          IF NOT l_check_res THEN NEXT FIELD att03 END IF                       
      AFTER FIELD att04                                                         
          CALL t325_check_att0x(g_imn[l_ac].att04,4,l_ac) RETURNING             
               l_check_res
          IF NOT l_check_res THEN NEXT FIELD att04 END IF                       
      AFTER FIELD att05                                                         
          CALL t325_check_att0x(g_imn[l_ac].att05,5,l_ac) RETURNING             
               l_check_res
          IF NOT l_check_res THEN NEXT FIELD att05 END IF                       
      AFTER FIELD att06                                                         
          CALL t325_check_att0x(g_imn[l_ac].att06,6,l_ac) RETURNING             
               l_check_res
          IF NOT l_check_res THEN NEXT FIELD att06 END IF                       
      AFTER FIELD att07                                                         
          CALL t325_check_att0x(g_imn[l_ac].att07,7,l_ac) RETURNING             
               l_check_res
          IF NOT l_check_res THEN NEXT FIELD att07 END IF                       
      AFTER FIELD att08              
          CALL t325_check_att0x(g_imn[l_ac].att08,8,l_ac) RETURNING             
               l_check_res
          IF NOT l_check_res THEN NEXT FIELD att08 END IF                       
      AFTER FIELD att09                                                         
          CALL t325_check_att0x(g_imn[l_ac].att09,9,l_ac) RETURNING             
               l_check_res
          IF NOT l_check_res THEN NEXT FIELD att09 END IF                       
      AFTER FIELD att10                                                         
          CALL t325_check_att0x(g_imn[l_ac].att10,10,l_ac) RETURNING            
               l_check_res
          IF NOT l_check_res THEN NEXT FIELD att10 END IF                       
 
      AFTER FIELD att01_c                                                       
          CALL t325_check_att0x_c(g_imn[l_ac].att01_c,1,l_ac) RETURNING         
               l_check_res
          IF NOT l_check_res THEN NEXT FIELD att01_c END IF                     
      AFTER FIELD att02_c                                                       
          CALL t325_check_att0x_c(g_imn[l_ac].att02_c,2,l_ac) RETURNING         
               l_check_res
          IF NOT l_check_res THEN NEXT FIELD att02_c END IF                     
      AFTER FIELD att03_c                                                       
          CALL t325_check_att0x_c(g_imn[l_ac].att03_c,3,l_ac) RETURNING         
               l_check_res
          IF NOT l_check_res THEN NEXT FIELD att03_c END IF                     
      AFTER FIELD att04_c                                                       
          CALL t325_check_att0x_c(g_imn[l_ac].att04_c,4,l_ac) RETURNING         
               l_check_res
          IF NOT l_check_res THEN NEXT FIELD att04_c END IF                     
      AFTER FIELD att05_c                                                       
          CALL t325_check_att0x_c(g_imn[l_ac].att05_c,5,l_ac) RETURNING         
               l_check_res
          IF NOT l_check_res THEN NEXT FIELD att05_c END IF                     
      AFTER FIELD att06_c                                                       
          CALL t325_check_att0x_c(g_imn[l_ac].att06_c,6,l_ac) RETURNING         
               l_check_res
          IF NOT l_check_res THEN NEXT FIELD att06_c END IF                     
      AFTER FIELD att07_c                                                       
          CALL t325_check_att0x_c(g_imn[l_ac].att07_c,7,l_ac) RETURNING         
               l_check_res
          IF NOT l_check_res THEN NEXT FIELD att07_c END IF                     
      AFTER FIELD att08_c                                                       
          CALL t325_check_att0x_c(g_imn[l_ac].att08_c,8,l_ac) RETURNING         
               l_check_res
          IF NOT l_check_res THEN NEXT FIELD att08_c END IF                     
      AFTER FIELD att09_c                                                       
          CALL t325_check_att0x_c(g_imn[l_ac].att09_c,9,l_ac) RETURNING         
               l_check_res
          IF NOT l_check_res THEN NEXT FIELD att09_c END IF                     
      AFTER FIELD att10_c                                                       
          CALL t325_check_att0x_c(g_imn[l_ac].att10_c,10,l_ac) RETURNING        
               l_check_res
          IF NOT l_check_res THEN NEXT FIELD att10_c END IF                     
 
        #FUN-CB0087--add--str
        BEFORE FIELD imn28
           IF g_aza.aza115 = 'Y' AND cl_null(g_imn[l_ac].imn28) THEN
              LET l_store = ''
              IF NOT cl_null(g_imn[l_ac].imn04) THEN
                 LET l_store = l_store,g_imn[l_ac].imn04
              END IF
              IF NOT cl_null(g_imn[l_ac].imn15) THEN
                 IF NOT cl_null(l_store) THEN
                    LET l_store = l_store,"','",g_imn[l_ac].imn15
                 ELSE
                    LET l_store = l_store,g_imn[l_ac].imn15
                 END IF
              END IF
              CALL s_reason_code(g_imm.imm01,'','',g_imn[l_ac].imn03,l_store,'',g_imm.imm14) RETURNING g_imn[l_ac].imn28
              CALL t325_azf03()
              DISPLAY BY NAME g_imn[l_ac].imn28
           END IF
        #FUN-CB0087--add--end
        AFTER FIELD imn28
            IF NOT cl_null(g_imn[l_ac].imn28) THEN
               LET g_buf = t325_imn28()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('select azf',g_errno,0) NEXT FIELD imn28
                  NEXT FIELD imn28
               END IF
               MESSAGE g_buf
               DISPLAY g_buf TO g_imn[l_ac].azf03       #FUN-CB0087 add
            END IF
 
        AFTER FIELD imn04  #倉庫
           IF NOT cl_null(g_imn[l_ac].imn04) THEN
              #FUN-C20002--start add-----------------------------
              IF g_azw.azw04 = '2' THEN
                 SELECT ima154 INTO l_ima154
                   FROM ima_file
                  WHERE ima01 = g_imn[l_ac].imn03
                 IF l_ima154 = 'Y' AND g_imn[l_ac].imn03[1,4] <> 'MISC' THEN
                    SELECT rcj03 INTO l_rcj03
                      FROM rcj_file
                     WHERE rcj00 = '0' 
                   
                    #FUN-C90049 mark begin---
                    #SELECT rtz07,rtz08 INTO l_rtz07,l_rtz08
                    #  FROM rtz_file
                    # WHERE rtz01 = g_plant
                    #FUN-C90049 mark end-----

                    CALL s_get_defstore(g_plant,g_imn[l_ac].imn03) RETURNING l_rtz07,l_rtz08   #FUN-C90049 add
                    
                    IF l_rcj03 = '1' THEN
                       IF g_imn[l_ac].imn04 <> l_rtz07 THEN
                          CALL cl_err('','aim1142',0)
                          LET g_imn[l_ac].imn04 = g_imn_t.imn04
                          NEXT FIELD imn04
                       END IF  
                    ELSE
                       IF g_imn[l_ac].imn04 <> l_rtz08 THEN
                          CALL cl_err('','aim1143',0)
                          LET g_imn[l_ac].imn04 = g_imn_t.imn04
                          NEXT FIELD imn04
                       END IF
                    END IF 
                 END IF 
              END IF 
              #FUN-C20002--end add-------------------------------
              #No.FUN-AA0049--begin
              IF NOT s_chk_ware(g_imn[l_ac].imn04) THEN
                 NEXT FIELD imn04
              END IF 
              #No.FUN-AA0049--end                
              #FUN-D20060----add---str--
              IF NOT s_chksmz(g_imn[l_ac].imn03, g_imm.imm01,
                              g_imn[l_ac].imn04, g_imn[l_ac].imn05) THEN
                 NEXT FIELD imn04
              END IF
              #FUN-D20060----add---end--
              IF NOT s_stkchk(g_imn[l_ac].imn04,'A') THEN
                 CALL cl_err(g_imn[l_ac].imn04,'mfg6076',0)
                 NEXT FIELD imn04
              END IF
              CALL  s_swyn(g_imn[l_ac].imn04) RETURNING sn1,sn2
    	      IF sn1=1 AND g_imn[l_ac].imn04!=t_imn04
              THEN CALL cl_err(g_imn[l_ac].imn04,'mfg6080',0)
                   LET t_imn04=g_imn[l_ac].imn04
                   NEXT FIELD imn04
              ELSE IF sn2=2 AND g_imn[l_ac].imn04!=t_imn04
                   THEN CALL cl_err(g_imn[l_ac].imn04,'mfg6085',0)
                        LET t_imn04=g_imn[l_ac].imn04
                        NEXT FIELD imn04
                   END IF
              END IF
             #str MOD-A30247 add
             #當沒有輸入儲位、批號時,撥出倉庫不可與在途倉一樣
              IF p_cmd = 'u' AND
                 g_imn[l_ac].imn05=' ' AND g_imn[l_ac].imn06=' ' AND 
                 g_imn[l_ac].imn04=g_imm.imm08 THEN
                 CALL cl_err(g_imn[l_ac].imn04,'aim1010',1)
                 NEXT FIELD imn04
              END IF
             #end MOD-A30247 add
              CALL t325_chk_jce(g_wip,g_imn[l_ac].imn04,g_imn[l_ac].imn15)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_imn[l_ac].imn04,g_errno,1)
                 NEXT FIELD imn04
              END IF
 
              LET sn1=0 LET sn2=0
              IF p_cmd = 'u' THEN
                 CALL t325_chk_out() RETURNING g_i
                 IF g_i THEN
                     NEXT FIELD imn04
                 END IF
              END IF
              IF NOT cl_null(g_imn[l_ac].imn15) THEN
                 SELECT imd20 INTO l_imd20 FROM imd_file WHERE imd01=g_imn[l_ac].imn04 AND imd11='Y' AND imdacti='Y'
                 SELECT imd20 INTO l_imd20_1 FROM imd_file WHERE imd01=g_imn[l_ac].imn15 AND imd11='Y' AND imdacti='Y'
                 IF l_imd20<>l_imd20_1 THEN
                    CALL cl_err('','aim-943',0)
                    LET g_imn[l_ac].imn04=g_imn_t.imn04
                    DISPLAY BY NAME g_imn[l_ac].imn04
                    NEXT FIELD imn04
                 END IF
              END IF
           END IF
            CALL t325_chk_whl()
            IF NOT cl_null(g_errno) THEN 
               CALL cl_err('imn04',g_errno,1)
               NEXT FIELD imn04
            END IF
#TQC-750012-end
           LET g_imn_o.imn04=g_imn[l_ac].imn04 #MOD-C10152 add
#IF NOT cl_null(g_imn[l_ac].imn04) THEN                           #FUN-D40103 add #TQC-D50124 mark
          #IF NOT s_imechk(g_imn[l_ac].imn04,g_imn[l_ac].imn05) THEN NEXT FIELD imn05 END IF  #FUN-D40103 add #TQC-D50124 mark
          #END IF    #TQC-D50124 mark
 
        AFTER FIELD imn05  #儲位
           IF g_imn[l_ac].imn05 IS NULL THEN LET g_imn[l_ac].imn05=' ' END IF
           #------------------------------------ 檢查料號預設倉儲及單別預設倉儲
           IF g_imn[l_ac].imn04 IS NOT NULL THEN  #FUN-D20060 add
              IF NOT s_chksmz(g_imn[l_ac].imn03, g_imm.imm01,
                              g_imn[l_ac].imn04, g_imn[l_ac].imn05) THEN
                 NEXT FIELD imn04
              END IF
           END IF  #FUN-D20060 add
            #---->需存在倉庫/儲位檔中
            IF g_imn[l_ac].imn05 IS NOT NULL THEN
	        IF sn1=1 AND g_imn[l_ac].imn05!=t_imn05
               THEN CALL cl_err(g_imn[l_ac].imn05,'mfg6081',0)
                       LET t_imn05=g_imn[l_ac].imn05
                       NEXT FIELD imn05
               ELSE IF sn2=2 AND g_imn[l_ac].imn05!=t_imn05
                    THEN CALL cl_err(g_imn[l_ac].imn05,'mfg6086',0)
                         LET t_imn05=g_imn[l_ac].imn05
                    NEXT FIELD imn05
                    END IF
               END IF
               LET sn1=0 LET sn2=0
           END IF
           IF g_imn[l_ac].imn05 IS NULL THEN LET g_imn[l_ac].imn05=' ' END IF
	#IF NOT s_imechk(g_imn[l_ac].imn04,g_imn[l_ac].imn05) THEN NEXT FIELD imn05 END IF  #FUN-D40103 add #TQC-D50124 mark
           IF p_cmd = 'u' THEN
              CALL t325_chk_out() RETURNING g_i
              IF g_i THEN
                  NEXT FIELD imn04
              END IF
           END IF
           CALL t325_chk_whl()
           IF NOT cl_null(g_errno) THEN 
              CALL cl_err('imn05',g_errno,1)
           #  NEXT FIELD imn05         #MOD-C30573--mark--
              NEXT FIELD imn04         #MOD-C30573--add--
           END IF
           #FUN-B50096 -----------Begin---------------
           IF NOT cl_null(g_imn[l_ac].imn03) THEN
              SELECT ima159 INTO l_ima159 FROM ima_file
               WHERE ima01 = g_imn[l_ac].imn03
              IF l_ima159 = '2' THEN
                 CASE t325_b_imn05_inschk()
                    WHEN "imn04"  NEXT FIELD imn04
                    WHEN "imn06"  NEXT FIELD imn05
                 END CASE
              END IF
           END IF
           #FUN-B50096 -----------End----------------
           LET g_imn_o.imn05=g_imn[l_ac].imn05 #MOD-C10152 add

        AFTER FIELD imn06  #批號

        #FUN-B50096 ----------Begin-------------
            CASE t325_b_imn05_inschk()
               WHEN "imn04"  NEXT FIELD imn04
               WHEN "imn06"  NEXT FIELD imn06
            END CASE
        #FUN-B50096 ----------End---------------
            LET g_imn_o.imn06=g_imn[l_ac].imn06 #MOD-C10152 add
#FUN-B50096 --------------------Begin-----------------------
#           IF g_imn[l_ac].imn06 IS NULL THEN LET g_imn[l_ac].imn06=' ' END IF
#           #FUN-A40022--begin--add----
#           IF s_industry('icd') THEN
#              LET l_imaicd13 = ''
#              SELECT imaicd13 INTO l_imaicd13
#                FROM imaicd_file WHERE imaicd00 = g_imn[l_ac].imn03
#              IF l_imaicd13 = 'Y' THEN
#                 IF cl_null(g_imn[l_ac].imn06) THEN
#                    CALL cl_err(g_imn[l_ac].imn06,'aim-034',1)
#                    NEXT FIELD CURRENT
#                 END IF
#              END IF
#              IF g_imn[l_ac].imn17 <>  g_imn[l_ac].imn06 THEN
#                 CALL cl_err(g_imn[l_ac].imn17,'aim-035',1)
#                 NEXT FIELD imn06
#              END IF
#           END IF
#           #FUN-A40022--end--add--------
#          #str MOD-A30247 add
#          #當沒有輸入儲位、批號時,撥出倉庫不可與在途倉一樣
#           IF g_imn[l_ac].imn05=' ' AND g_imn[l_ac].imn06=' ' AND 
#              g_imn[l_ac].imn04=g_imm.imm08 THEN
#              CALL cl_err(g_imn[l_ac].imn04,'aim1010',1)
#              NEXT FIELD imn04
#           END IF
#          #end MOD-A30247 add
#           CALL t325_chk_whl()
#           IF NOT cl_null(g_errno) THEN 
#              CALL cl_err('imn06',g_errno,1)
#              NEXT FIELD imn06
#           END IF
#           SELECT img09,img10  INTO g_imn[l_ac].imn09,l_img10
#             FROM img_file WHERE img01=g_imn[l_ac].imn03 AND
#                                 img02=g_imn[l_ac].imn04 AND
#                                 img03=g_imn[l_ac].imn05 AND
#                                 img04=g_imn[l_ac].imn06
#
#
#           IF SQLCA.sqlcode THEN
#              LET l_img10 = 0
#              CALL cl_err(g_imn[l_ac].imn06,'mfg6101',0)
#              NEXT FIELD imn04
#           END IF
#           DISPLAY BY NAME g_imn[l_ac].imn09
#           #-->有效日期
#           IF NOT s_actimg(g_imn[l_ac].imn03,g_imn[l_ac].imn04,
#                           g_imn[l_ac].imn05,g_imn[l_ac].imn06)
#           THEN CALL cl_err('inactive','mfg6117',0)
#                NEXT FIELD imn04
#           END IF
#
#           IF p_cmd = 'u' THEN
#              CALL t325_chk_out() RETURNING g_i
#              IF g_i THEN
#                 NEXT FIELD imn04
#              END IF
#           END IF
#          LET g_img09_s=g_imn[l_ac].imn09
#          LET g_img10_s=l_img10
#          IF g_sma.sma115 = 'Y' THEN
#             IF g_imn_t.imn03 IS NULL OR g_imn[l_ac].imn03 <> g_imn_t.imn03 OR
#                g_imn_t.imn04 IS NULL OR g_imn[l_ac].imn04 <> g_imn_t.imn04 OR
#                g_imn_t.imn05 IS NULL OR g_imn[l_ac].imn05 <> g_imn_t.imn05 OR
#                g_imn_t.imn06 IS NULL OR g_imn[l_ac].imn06 <> g_imn_t.imn06 THEN
#                CALL t325_du_default(p_cmd,g_imn[l_ac].imn03,g_imn[l_ac].imn04,
#                                    g_imn[l_ac].imn05,g_imn[l_ac].imn06)
#                     RETURNING g_imn[l_ac].imn33,g_imn[l_ac].imn34,
#                               g_imn[l_ac].imn35,g_imn[l_ac].imn30,
#                               g_imn[l_ac].imn31,g_imn[l_ac].imn32
#             END IF
#          END IF
#FUN-B50096 --------------------End------------------------
 
        AFTER FIELD imn10  #調撥數量
           #No.FUN-BB0086--add--begin--
           LET g_imn[l_ac].imn10 = s_digqty(g_imn[l_ac].imn10,g_imn[l_ac].imn09)
           DISPLAY BY NAME g_imn[l_ac].imn10
           #No.FUN-BB0086--add--end--
            IF NOT cl_null(g_imn[l_ac].imn10) THEN
               IF g_imn[l_ac].imn10 <= 0 THEN
                  CALL cl_err('','mfg9105',0)
                   NEXT FIELD imn10
               END IF
               IF p_cmd = 'u' THEN
                  LET g_imn[l_ac].imn22 = g_imn[l_ac].imn10 * g_imn[l_ac].imn21
                  LET g_imn[l_ac].imn22 = s_digqty(g_imn[l_ac].imn22,g_imn[l_ac].imn20)   #No.FUN-BB0086
                  DISPLAY BY NAME g_imn[l_ac].imn22
               END IF
 
               SELECT SUM(imn10) INTO l_imn10
                 FROM imn_file
                WHERE imn01 = g_imm.imm01
                  AND imn02 <> g_imn[l_ac].imn02
                  AND imn03 = g_imn[l_ac].imn03
                  AND imn04 = g_imn[l_ac].imn04
                  AND imn05 = g_imn[l_ac].imn05
                  AND imn06 = g_imn[l_ac].imn06
 
               IF cl_null(l_imn10) THEN
                   LET l_imn10 = 0
               END IF
               IF l_imn10+g_imn[l_ac].imn10 > l_img10 THEN
                 #IF g_sma.sma894[4,4]='N' OR g_sma.sma894[4,4] IS NULL THEN  #FUN-C80107 mark
                  LET g_flag1 = NULL    #FUN-C80107 add
                  #CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_imn[l_ac].imn04) RETURNING g_flag1   #FUN-C80107 add #FUN-D30024--mark
                  CALL s_inv_shrt_by_warehouse(g_imn[l_ac].imn04,g_plant) RETURNING g_flag1    #FUN-D30024--add #TQC-D40078 g_plant
                  IF g_flag1 = 'N' OR g_flag1 IS NULL THEN           #FUN-C80107 add
                      #l_img10為庫存數量,而此次調撥總數量大於庫存數量!
                      CALL cl_err(l_img10,'aim-309',0) #No:6891
                      NEXT FIELD imn10
                  ELSE
                     IF NOT cl_confirm('mfg3469') THEN
                        NEXT FIELD imn10
                     END IF
                  END IF
               END IF

               #No.MOD-AA0086  --Begin
               LET g_ima918 = ''   #DEV-D30059 add
               LET g_ima921 = ''   #DEV-D30059 add
               LET g_ima930 = ''   #DEV-D30059 add
               SELECT ima918,ima921,ima930 INTO g_ima918,g_ima921,g_ima930 #DEV-D30059 add ima930
                 FROM ima_file
                WHERE ima01 = g_imn[l_ac].imn03
                  AND imaacti = "Y"

               IF cl_null(g_ima930) THEN LET g_ima930 = 'N' END IF  #DEV-D30059 add

               IF (g_ima918 = "Y" OR g_ima921 = "Y") AND
                  (cl_null(g_imn_t.imn10) OR (g_imn[l_ac].imn10<>g_imn_t.imn10 )) THEN
                  IF g_prog = 'aimt325' THEN
                    #CALL s_lotout(g_prog,g_imm.imm01,g_imn[l_ac].imn02,0,         #TQC-B90236 mark
                     IF g_ima930 = 'N' THEN                                        #DEV-D30059
                        CALL s_mod_lot(g_prog,g_imm.imm01,g_imn[l_ac].imn02,0,     #TQC-B90236 add
                                      g_imn[l_ac].imn03,g_imn[l_ac].imn04,
                                      g_imn[l_ac].imn05,g_imn[l_ac].imn06,
                                      g_imn[l_ac].imn09,g_imn[l_ac].imn09,1,
                                      g_imn[l_ac].imn10,'','MOD',-1)               #TQC-B90236 add '-1'
                            RETURNING l_r,g_qty
                     END IF                                                        #DEV-D30059
                     IF l_r = "Y" THEN
                        LET g_imn[l_ac].imn10 = g_qty
                        LET g_imn[l_ac].imn10 = s_digqty(g_imn[l_ac].imn10,g_imn[l_ac].imn09)   #No.FUN-BB0086
                     END IF
                     DISPLAY BY NAME g_imn[l_ac].imn10
                  END IF
               END IF
               #No.MOD-AA0086  --End  

               LET g_imn[l_ac].imn22=g_imn[l_ac].imn10*g_imn[l_ac].imn21 #0525
               LET g_imn[l_ac].imn22 = s_digqty(g_imn[l_ac].imn22,g_imn[l_ac].imn20)   #No.FUN-BB0086
               DISPLAY BY NAME g_imn[l_ac].imn22
            END IF
 
        BEFORE FIELD imn33
           CALL t325_set_no_required()
 
        AFTER FIELD imn33  #第二單位
           IF cl_null(g_imn[l_ac].imn03) THEN NEXT FIELD imn03 END IF
           IF g_imn[l_ac].imn04 IS NULL OR g_imn[l_ac].imn05 IS NULL OR
              g_imn[l_ac].imn06 IS NULL THEN
              NEXT FIELD imn04
           END IF
           IF NOT cl_null(g_imn[l_ac].imn33) THEN
              SELECT gfe02 INTO g_buf FROM gfe_file
               WHERE gfe01=g_imn[l_ac].imn33
                 AND gfeacti='Y'
              IF STATUS THEN
                 CALL cl_err3("sel","gfe_file",g_imn[l_ac].imn33,"",
                               SQLCA.sqlcode,"","gfe:",1)  #No.FUN-660156
                 NEXT FIELD imn33
              END IF
              CALL s_du_umfchk(g_imn[l_ac].imn03,'','','',
                               g_img09_s,g_imn[l_ac].imn33,g_ima906)
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_imn[l_ac].imn33,g_errno,0)
                 NEXT FIELD imn33
              END IF
              IF cl_null(g_imn_t.imn33) OR g_imn_t.imn33 <> g_imn[l_ac].imn33 THEN
                 LET g_imn[l_ac].imn34 = g_factor
              END IF
              CALL s_chk_imgg(g_imn[l_ac].imn03,g_imn[l_ac].imn04,
                              g_imn[l_ac].imn05,g_imn[l_ac].imn06,
                              g_imn[l_ac].imn33) RETURNING g_flag
              IF g_flag = 1 THEN
                #FUN-C80107 modify begin---------------------------------------121024
                #CALL cl_err(g_imn[l_ac].imn33,'asm-301',0)
                #NEXT FIELD imn33
                 INITIALIZE g_flag1 TO NULL
                 #CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_imn[l_ac].imn04) RETURNING g_flag1  #FUN-D30024--mark
                 CALL s_inv_shrt_by_warehouse(g_imn[l_ac].imn04,g_plant) RETURNING g_flag1  #FUN-D30024--add #TQC-D40078 g_plant
                 IF g_flag1 = 'N' OR g_flag1 IS NULL THEN
                    CALL cl_err(g_imn[l_ac].imn33,'asm-301',0)
                    NEXT FIELD imn33
                 ELSE
                    IF g_sma.sma892[3,3] = 'Y' THEN
                       IF g_bgjob='N' OR cl_null(g_bgjob) THEN
                          IF NOT cl_confirm('aim-995') THEN
                             NEXT FIELD imn33
                          END IF
                       END IF
                    END IF
                    CALL s_add_imgg(g_imn[l_ac].imn03,g_imn[l_ac].imn04,
                                    g_imn[l_ac].imn05,g_imn[l_ac].imn06,
                                    g_imn[l_ac].imn33,g_imn[l_ac].imn34,
                                    g_imm.imm01,g_imn[l_ac].imn02,0)
                          RETURNING g_flag
                    IF g_flag = 1 THEN
                       NEXT FIELD imn33
                    END IF
                 END IF
                #FUN-C80107 modify end-----------------------------------------
              END IF
              #No.FUN-BB0086--add--begin--
              IF NOT i325_imn35_check(p_cmd) THEN 
                 LET g_imn33_t = g_imn[l_ac].imn33
                 NEXT FIELD imn35
              END IF 
              LET g_imn33_t = g_imn[l_ac].imn33
              #No.FUN-BB0086--add--end--
           END IF
           CALL t325_set_required()
 
        BEFORE FIELD imn35
           IF cl_null(g_imn[l_ac].imn03) THEN NEXT FIELD imn03 END IF
           IF g_imn[l_ac].imn04 IS NULL OR g_imn[l_ac].imn05 IS NULL OR
              g_imn[l_ac].imn06 IS NULL THEN
              NEXT FIELD imn04
           END IF
           IF NOT cl_null(g_imn[l_ac].imn33) AND g_ima906 = '3' THEN
              CALL s_du_umfchk(g_imn[l_ac].imn03,'','','',
                               g_img09_s,g_imn[l_ac].imn33,g_ima906)
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_imn[l_ac].imn33,g_errno,0)
                 NEXT FIELD imn04
              END IF
              IF cl_null(g_imn_t.imn33) OR g_imn_t.imn33 <> g_imn[l_ac].imn33 THEN
                 LET g_imn[l_ac].imn34 = g_factor
              END IF
              CALL s_chk_imgg(g_imn[l_ac].imn03,g_imn[l_ac].imn04,
                              g_imn[l_ac].imn05,g_imn[l_ac].imn06,
                              g_imn[l_ac].imn33) RETURNING g_flag
              IF g_flag = 1 THEN
                #FUN-C80107 modify begin-----------------------------------------121024
                #CALL cl_err(g_imn[l_ac].imn33,'asm-301',0)
                #NEXT FIELD imn04
                 INITIALIZE g_flag1 TO NULL
                 #CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_imn[l_ac].imn04) RETURNING g_flag1 #FUN-D30024--mark
                 CALL s_inv_shrt_by_warehouse(g_imn[l_ac].imn04,g_plant) RETURNING g_flag1 #FUN-D30024--add #TQC-D40078 g_plant
                 IF g_flag1 = 'N' OR g_flag1 IS NULL THEN
                    CALL cl_err(g_imn[l_ac].imn33,'asm-301',0)
                    NEXT FIELD imn04
                 ELSE
                    IF g_sma.sma892[3,3] = 'Y' THEN
                       IF g_bgjob='N' OR cl_null(g_bgjob) THEN
                          IF NOT cl_confirm('aim-995') THEN
                             NEXT FIELD imn04
                          END IF
                       END IF
                    END IF
                    CALL s_add_imgg(g_imn[l_ac].imn03,g_imn[l_ac].imn04,
                                    g_imn[l_ac].imn05,g_imn[l_ac].imn06,
                                    g_imn[l_ac].imn33,g_imn[l_ac].imn34,
                                    g_imm.imm01,g_imn[l_ac].imn02,0)
                          RETURNING g_flag
                    IF g_flag = 1 THEN
                       NEXT FIELD imn04
                    END IF
                 END IF
                #FUN-C80107 modify end-----------------------------------------
              END IF
           END IF
 
        AFTER FIELD imn35  #第二數量
           IF NOT i325_imn35_check(p_cmd) THEN NEXT FIELD imn35 END IF   #No.FUN-BB0086
           #No.FUN-BB0086--mark--begin--
           #IF NOT cl_null(g_imn[l_ac].imn35) THEN
           #   IF g_imn[l_ac].imn35 < 0 THEN
           #      CALL cl_err('','aim-391',0)  #
           #      NEXT FIELD imn35
           #   END IF
           #   IF p_cmd = 'a' THEN
           #      IF g_ima906='3' THEN
           #         LET g_tot=g_imn[l_ac].imn35*g_imn[l_ac].imn34
           #         IF cl_null(g_imn[l_ac].imn32) OR g_imn[l_ac].imn32=0 THEN#CHI-960022
           #            LET g_imn[l_ac].imn32=g_tot*g_imn[l_ac].imn31
           #            DISPLAY BY NAME g_imn[l_ac].imn32                     #CHI-960022
           #         END IF                                                   #CHI-960022
           #      END IF
           #   END IF
           #   IF g_ima906 MATCHES '[23]' THEN
           #      SELECT imgg10 INTO g_imgg10_2 FROM imgg_file
           #       WHERE imgg01=g_imn[l_ac].imn03
           #         AND imgg02=g_imn[l_ac].imn04
           #         AND imgg03=g_imn[l_ac].imn05
           #         AND imgg04=g_imn[l_ac].imn06
           #         AND imgg09=g_imn[l_ac].imn33
           #   END IF
           #   IF NOT cl_null(g_imn[l_ac].imn33) THEN
           #      IF g_sma.sma117 = 'N' THEN
           #         IF g_imn[l_ac].imn35 > g_imgg10_2 THEN
           #            IF g_sma.sma894[4,4]='N' OR g_sma.sma894[4,4] IS NULL THEN
           #               CALL cl_err(g_imn[l_ac].imn35,'mfg1303',1)
           #               NEXT FIELD imn35
           #            ELSE
           #               IF NOT cl_confirm('mfg3469') THEN
           #                  NEXT FIELD imn35
           #               ELSE
           #                  LET g_yes = 'Y'
           #               END IF
           #            END IF
           #         END IF
           #      END IF
           #   END IF
           #END IF
           #No.FUN-BB0086--mark--end--
 
        BEFORE FIELD imn30
           CALL t325_set_no_required()
 
        AFTER FIELD imn30  #第一單位
           #No.FUN-BB0086--add--begin--
           LET l_tf = ""
           LET l_case = ""
           #No.FUN-BB0086--add--end--
           IF cl_null(g_imn[l_ac].imn03) THEN NEXT FIELD imn03 END IF
           IF g_imn[l_ac].imn04 IS NULL OR g_imn[l_ac].imn05 IS NULL OR
              g_imn[l_ac].imn06 IS NULL THEN
              NEXT FIELD imn04
           END IF
           IF NOT cl_null(g_imn[l_ac].imn30) THEN
              SELECT gfe02 INTO g_buf FROM gfe_file
               WHERE gfe01=g_imn[l_ac].imn30
                 AND gfeacti='Y'
              IF STATUS THEN
                 CALL cl_err3("sel","gfe_file",g_imn[l_ac].imn30,"",
                               SQLCA.sqlcode,"","gfe:",1)  #No.FUN-660156
                 NEXT FIELD imn30
              END IF
              CALL s_du_umfchk(g_imn[l_ac].imn03,'','','',
                               g_imn[l_ac].imn09,g_imn[l_ac].imn30,'1')
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_imn[l_ac].imn30,g_errno,0)
                 NEXT FIELD imn30
              END IF
              IF cl_null(g_imn_t.imn30) OR g_imn_t.imn30 <> g_imn[l_ac].imn30 THEN
                 LET g_imn[l_ac].imn31 = g_factor
              END IF
              IF g_ima906 = '2' THEN
                 CALL s_chk_imgg(g_imn[l_ac].imn03,g_imn[l_ac].imn04,
                                 g_imn[l_ac].imn05,g_imn[l_ac].imn06,
                                 g_imn[l_ac].imn30) RETURNING g_flag
                 IF g_flag = 1 THEN
                   #FUN-C80107 modify begin-----------------------------------------121024
                   #CALL cl_err(g_imn[l_ac].imn30,'asm-301',0)
                   #NEXT FIELD imn30
                    INITIALIZE g_flag1 TO NULL
                    #CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_imn[l_ac].imn04) RETURNING g_flag1  #FUN-D30024--mark
                    CALL s_inv_shrt_by_warehouse(g_imn[l_ac].imn04,g_plant) RETURNING g_flag1  #FUN-D30024--add #TQC-D40078 g_plant
                    IF g_flag1 = 'N' OR g_flag1 IS NULL THEN
                       CALL cl_err(g_imn[l_ac].imn30,'asm-301',0)
                       NEXT FIELD imn30
                    ELSE
                       IF g_sma.sma892[3,3] = 'Y' THEN
                          IF g_bgjob='N' OR cl_null(g_bgjob) THEN
                             IF NOT cl_confirm('aim-995') THEN
                                NEXT FIELD imn30
                             END IF
                          END IF
                       END IF
                       CALL s_add_imgg(g_imn[l_ac].imn03,g_imn[l_ac].imn04,
                                       g_imn[l_ac].imn05,g_imn[l_ac].imn06,
                                       g_imn[l_ac].imn30,g_imn[l_ac].imn31,
                                       g_imm.imm01,g_imn[l_ac].imn02,0)
                             RETURNING g_flag
                       IF g_flag = 1 THEN
                          NEXT FIELD imn30
                       END IF
                    END IF
                   #FUN-C80107 modify end-----------------------------------------
                 END IF
                 SELECT imgg10 INTO g_imgg10_1 FROM imgg_file
                  WHERE imgg01=g_imn[l_ac].imn03
                    AND imgg02=g_imn[l_ac].imn04
                    AND imgg03=g_imn[l_ac].imn05
                    AND imgg04=g_imn[l_ac].imn06
                    AND imgg09=g_imn[l_ac].imn30
              ELSE
                 SELECT img10 INTO g_imgg10_1 FROM img_file
                  WHERE img01=g_imn[l_ac].imn03
                    AND img02=g_imn[l_ac].imn04
                    AND img03=g_imn[l_ac].imn05
                    AND img04=g_imn[l_ac].imn06
              END IF
              #No.FUN-BB0086--add--begin--  
              IF NOT cl_null(g_imn[l_ac].imn32) AND g_imn[l_ac].imn32 <> 0 THEN
                 CALL i325_imn32_check(p_cmd) RETURNING l_tf,l_case
              END IF  
              LET g_imn30_t = g_imn[l_ac].imn30
              IF NOT l_tf THEN 
                 CASE l_case 
                    WHEN "imn32" NEXT FIELD imn32
                    WHEN "imn35" NEXT FIELD imn35
                    OTHERWISE EXIT CASE 
                 END CASE 
              END IF 
              #No.FUN-BB0086--add--end--
           END IF
           CALL t325_set_required()
 
        AFTER FIELD imn32  #第一數量
           #No.FUN-BB0086--add--begin--
           LET l_tf = ""
           LET l_case = ""
           CALL i325_imn32_check(p_cmd) RETURNING l_tf,l_case
           IF NOT l_tf THEN 
              CASE l_case 
                 WHEN "imn32" NEXT FIELD imn32
                 WHEN "imn35" NEXT FIELD imn35
                 OTHERWISE EXIT CASE 
              END CASE 
           END IF 
           #No.FUN-BB0086--add--end--
           #No.FUN-BB0086--mark--begin--
           #IF NOT cl_null(g_imn[l_ac].imn32) THEN
           #   IF g_imn[l_ac].imn32 < 0 THEN
           #      CALL cl_err('','aim-391',0)  #
           #      NEXT FIELD imn32
           #   END IF
           #   IF NOT cl_null(g_imn[l_ac].imn30) THEN
           #      IF g_ima906 = '2' THEN
           #         IF g_sma.sma117 = 'N' THEN
           #            IF g_imn[l_ac].imn32 > g_imgg10_1 THEN
           #               IF g_sma.sma894[4,4]='N' OR g_sma.sma894[4,4] IS NULL THEN
           #                  CALL cl_err(g_imn[l_ac].imn32,'mfg1303',1)
           #                  NEXT FIELD imn32
           #               ELSE
           #                  IF NOT cl_confirm('mfg3469') THEN
           #                     NEXT FIELD imn32
           #                  ELSE
           #                     LET g_yes = 'Y'
           #                  END IF
           #               END IF
           #            END IF
           #         END IF
           #      ELSE
           #         IF g_imn[l_ac].imn32 * g_imn[l_ac].imn31 > g_imgg10_1 THEN
           #            IF g_sma.sma894[4,4]='N' OR g_sma.sma894[4,4] IS NULL THEN
           #               CALL cl_err(g_imn[l_ac].imn32,'mfg1303',1)
           #               NEXT FIELD imn32
           #            ELSE
           #               IF NOT cl_confirm('mfg3469') THEN
           #                  NEXT FIELD imn32
           #               ELSE
           #                  LET g_yes = 'Y'
           #               END IF
           #            END IF
           #         END IF
           #      END IF
           #   END IF
           #END IF
           ##No.MOD-AA0086  --Begin
           #SELECT ima918,ima921 INTO g_ima918,g_ima921
           #  FROM ima_file
           # WHERE ima01 = g_imn[l_ac].imn03
           #   AND imaacti = "Y"
           #
           #IF (g_ima918 = "Y" OR g_ima921 = "Y") AND
           #   (p_cmd = 'a' OR g_imn[l_ac].imn35<>g_imn_t.imn35 OR g_imn[l_ac].imn32 <> g_imn_t.imn32 ) THEN
           #   IF g_prog = 'aimt325' THEN
           #     #CALL s_lotout(g_prog,g_imm.imm01,g_imn[l_ac].imn02,0,             #TQC-B90236 mark
           #      CALL s_mod_lot(g_prog,g_imm.imm01,g_imn[l_ac].imn02,0,             #TQC-B90236 add
           #                    g_imn[l_ac].imn03,g_imn[l_ac].imn04,
           #                    g_imn[l_ac].imn05,g_imn[l_ac].imn06,
           #                    g_imn[l_ac].imn09,g_imn[l_ac].imn09,1,
           #                    g_imn[l_ac].imn10,'','MOD',-1) #CHI-9A0022 add ''     #TQC-B90236 add '-1'
           #          RETURNING l_r,g_qty
           #      IF l_r = "Y" THEN
           #         LET g_imn[l_ac].imn10 = g_qty
           #      END IF
           #      LET g_imn[l_ac].imn22 = g_imn[l_ac].imn10 * g_imn[l_ac].imn21
           #      LET g_imn[l_ac].imn22 = s_digqty(g_imn[l_ac].imn22,g_imn[l_ac].imn20)   #No.FUN-BB0086
           #      DISPLAY BY NAME g_imn[l_ac].imn22
           #   END IF
           #END IF
           ##No.MOD-AA0086  --End  
           #
           #CALL t325_du_data_to_correct()
           #CALL t325_set_origin_field()
           #IF g_imn[l_ac].imn10 <= 0 THEN
           #   CALL cl_err('','mfg9105',0)
           #   IF g_ima906 MATCHES '[23]' THEN
           #      NEXT FIELD imn35
           #   ELSE
           #      NEXT FIELD imn32
           #   END IF
           #END IF
           #IF cl_null(g_imn[l_ac].imn09) THEN
           #   CALL cl_err('set origin',SQLCA.sqlcode,1)
           #   IF g_ima906 MATCHES '[23]' THEN
           #      NEXT FIELD imn35
           #   ELSE
           #      NEXT FIELD imn32
           #   END IF
           #END IF
           #IF t325_qty_issue() THEN
           #   IF g_ima906 MATCHES '[23]' THEN
           #      NEXT FIELD imn35
           #   ELSE
           #      NEXT FIELD imn32
           #   END IF
           #END IF
           #No.FUN-BB0086--mark--end--
            LET g_imn_o.imn15=g_imn[l_ac].imn15 #MOD-C10152 add 
 
#------目的倉庫------------------------------------------------
        AFTER FIELD imn15  #倉庫
            IF NOT cl_null(g_imn[l_ac].imn15) THEN
               #FUN-C20002--start add-----------------------------
               IF g_azw.azw04 = '2' THEN
                 SELECT ima154 INTO l_ima154
                   FROM ima_file
                  WHERE ima01 = g_imn[l_ac].imn03
                 IF l_ima154 = 'Y' AND g_imn[l_ac].imn03[1,4] <> 'MISC' THEN
                    SELECT rcj03 INTO l_rcj03
                      FROM rcj_file
                     WHERE rcj00 = '0'

                    #FUN-C90049 mark begin---
                    #SELECT rtz07,rtz08 INTO l_rtz07,l_rtz08
                    # FROM rtz_file
                    #WHERE rtz01 = g_plant
                    #FUN-C90049 mark end-----
                  
                    CALL s_get_defstore(g_plant,g_imn[l_ac].imn03) RETURNING l_rtz07,l_rtz08   #FUN-C90049 add
                   
                    IF l_rcj03 = '1' THEN
                       IF g_imn[l_ac].imn15 <> l_rtz07 THEN
                          CALL cl_err('','aim1142',0)
                          LET g_imn[l_ac].imn15 = g_imn_t.imn15
                          NEXT FIELD imn15
                       END IF
                    ELSE
                       IF g_imn[l_ac].imn15 <> l_rtz08 THEN
                          CALL cl_err('','aim1143',0)
                          LET g_imn[l_ac].imn15 = g_imn_t.imn15
                          NEXT FIELD imn15
                       END IF
                    END IF
                 END IF
              END IF
              #FUN-C20002--end add-------------------------------     
               #No.FUN-AA0049--begin
               IF NOT s_chk_ware(g_imn[l_ac].imn15) THEN
                  NEXT FIELD imn15
               END IF 
               #No.FUN-AA0049--end             
               #FUN-D20060----add---str--
               IF NOT s_chksmz(g_imn[l_ac].imn03, g_imm.imm01,
                               g_imn[l_ac].imn15, g_imn[l_ac].imn16) THEN
                  NEXT FIELD imn15
               END IF
               #FUN-D20060----add---end--
               #------>check-1
               IF NOT s_imfchk1(g_imn[l_ac].imn03,g_imn[l_ac].imn15)
                  THEN CALL cl_err(g_imn[l_ac].imn15,'mfg9036',0)
                       NEXT FIELD imn15
               END IF
               #------>check-2
               CALL  s_stkchk(g_imn[l_ac].imn15,'A') RETURNING l_code
               IF NOT l_code THEN
                  CALL cl_err(g_imn[l_ac].imn15,'mfg1100',1)
                  NEXT FIELD imn15
               END IF
               CALL  s_swyn(g_imn[l_ac].imn15) RETURNING sn1,sn2
	           	IF sn1=1 AND g_imn[l_ac].imn15!=t_imn15
                  THEN CALL cl_err(g_imn[l_ac].imn15,'mfg6080',1)
                       LET t_imn15=g_imn[l_ac].imn15
                       NEXT FIELD imn15
                   ELSE IF sn2=2 AND g_imn[l_ac].imn15!=t_imn15
                          THEN CALL cl_err(g_imn[l_ac].imn15,'mfg6085',0)
                               LET t_imn15=g_imn[l_ac].imn15
                               NEXT FIELD imn15
                        END IF
               END IF
              #str MOD-A30247 add
              #當沒有輸入儲位、批號時,撥入倉庫不可與在途倉一樣
               IF p_cmd = 'u' AND
                  g_imn[l_ac].imn16=' ' AND g_imn[l_ac].imn17=' ' AND 
                  g_imn[l_ac].imn15=g_imm.imm08 THEN
                  CALL cl_err(g_imn[l_ac].imn15,'aim1010',1)
                  NEXT FIELD imn15
               END IF
              #end MOD-A30247 add
               CALL t325_chk_jce(g_wip,g_imn[l_ac].imn04,g_imn[l_ac].imn15)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_imn[l_ac].imn15,g_errno,1)
                  NEXT FIELD imn15
               END IF
 
               IF NOT cl_null(g_imn[l_ac].imn04) THEN
                  SELECT imd20 INTO l_imd20 FROM imd_file WHERE imd01=g_imn[l_ac].imn04 AND imd11='Y' AND imdacti='Y'
                  SELECT imd20 INTO l_imd20_1 FROM imd_file WHERE imd01=g_imn[l_ac].imn15 AND imd11='Y' AND imdacti='Y'
                  IF l_imd20<>l_imd20_1 THEN
                     CALL cl_err('','aim-943',0)
                     LET g_imn[l_ac].imn15=g_imn_t.imn15
                     DISPLAY BY NAME g_imn[l_ac].imn15
                     NEXT FIELD imn15
                  END IF
               END IF
            END IF
            CALL t325_chk_whl()
            IF NOT cl_null(g_errno) THEN 
               CALL cl_err('imn15',g_errno,1)
               NEXT FIELD imn15
            END IF
	 #IF NOT s_imechk(g_imn[l_ac].imn15,g_imn[l_ac].imn16) THEN NEXT FIELD imn16 END IF  #FUN-D40103 add #TQC-D50124 mark

            
        AFTER FIELD imn16  #儲位
           #BugNo:5626 控管是否為全型空白
           IF g_imn[l_ac].imn16 = '　' THEN #全型空白
              LET g_imn[l_ac].imn16 = ' '
           END IF
	#IF NOT s_imechk(g_imn[l_ac].imn15,g_imn[l_ac].imn16) THEN NEXT FIELD imn16 END IF  #FUN-D40103 add #TQC-D50124 mark
           #FUN-D20060----add---str--
           IF NOT cl_null(g_imn[l_ac].imn15) THEN
               IF NOT s_chksmz(g_imn[l_ac].imn03, g_imm.imm01,
                               g_imn[l_ac].imn15, g_imn[l_ac].imn16) THEN
                  NEXT FIELD imn15
               END IF
           END IF
           #FUN-D20060----add---end--
            #------>chk-1
            IF NOT s_imfchk(g_imn[l_ac].imn03,g_imn[l_ac].imn15,g_imn[l_ac].imn16)
               THEN CALL cl_err(g_imn[l_ac].imn16,'mfg6095',0)
                    NEXT FIELD imn16
            END IF
            CALL s_hqty(g_imn[l_ac].imn03,g_imn[l_ac].imn15,
                        g_imn[l_ac].imn16)
                 RETURNING g_cnt,t_imf04,t_imf05
            LET h_qty=t_imf04
            CALL s_lwyn(g_imn[l_ac].imn15,g_imn[l_ac].imn16)
                 RETURNING sn1,sn2
            IF sn1=1 AND g_imn[l_ac].imn16!=t_imn16 THEN
               CALL cl_err(g_imn[l_ac].imn16,'mfg6081',0)
               LET t_imn16=g_imn[l_ac].imn16
               NEXT FIELD imn16
            ELSE
               IF sn2=2 AND g_imn[l_ac].imn16!=t_imn16 THEN
                  CALL cl_err(g_imn[l_ac].imn16,'mfg6086',0)
                  LET t_imn16=g_imn[l_ac].imn16
                  NEXT FIELD imn16
               END IF
            END IF
            LET sn1=0 LET sn2=0
            IF g_imn[l_ac].imn16 IS NULL THEN LET g_imn[l_ac].imn16=' ' END IF
 
            CALL t325_chk_whl()
            IF NOT cl_null(g_errno) THEN 
               CALL cl_err('imn16',g_errno,1)
           #   NEXT FIELD imn16            #MOD-C30573--mark--
               NEXT FIELD imn15            #MOD-C30573--add--
            END IF
        #FUN-B50096 --------------Begin--------------
            IF NOT cl_null(g_imn[l_ac].imn03) THEN
               SELECT ima159 INTO l_ima159 FROM ima_file
                WHERE ima01 = g_imn[l_ac].imn03
               IF l_ima159 = '2' THEN
                  CASE t325_b_imn16_inschk()
                     WHEN "imn15" NEXT FIELD imn15
                     WHEN "imn17" NEXT FIELD imn16
                  END CASE
               END IF
            END IF
        #FUN-B50096 --------------End----------------
           LET g_imn_o.imn16=g_imn[l_ac].imn16 #MOD-C10152 add

        #FUN-A40022--begin--add-----
        BEFORE FIELD imn17
         IF s_industry('icd') THEN
            IF cl_null(g_imn[l_ac].imn17) THEN 
               LET g_imn[l_ac].imn17 = g_imn[l_ac].imn06
            END IF
         END IF
        #FUN-A40022--end--add------
 
        AFTER FIELD imn17

        #FUN-B50096 -------Begin----------------
            CASE t325_b_imn16_inschk()
               WHEN "imn15" NEXT FIELD imn15
               WHEN "imn17" NEXT FIELD imn17
            END CASE
        #FUN-B50096 -------End------------------
            LET g_imn_o.imn17=g_imn[l_ac].imn17 #MOD-C10152 add

#FUN-B50096 ---------------Begin--------------
#           IF g_imn[l_ac].imn17 = '　' THEN #全型空白
#              LET g_imn[l_ac].imn17 = ' '
#           END IF
#           IF g_imn[l_ac].imn17 IS NULL THEN
#              LET g_imn[l_ac].imn17 = ' '
#           END IF
#
#           CALL t325_chk_whl()
#           IF NOT cl_null(g_errno) THEN 
#              CALL cl_err('imn16',g_errno,1)
#              NEXT FIELD imn17
#           END IF
#
#           IF g_imn[l_ac].imn04 = g_imn[l_ac].imn15 AND
#              g_imn[l_ac].imn05 = g_imn[l_ac].imn16 AND
#              g_imn[l_ac].imn06 = g_imn[l_ac].imn17 THEN
#              CALL cl_err('','mfg9090',1)
#              NEXT FIELD imn15
#           END IF
#           #FUN-A40022--begin--add----
#           IF s_industry('icd') THEN
#              LET l_imaicd13 = ''
#              SELECT imaicd13 INTO l_imaicd13
#                FROM imaicd_file WHERE imaicd00 = g_imn[l_ac].imn03
#              IF l_imaicd13 = 'Y' THEN
#                 IF cl_null(g_imn[l_ac].imn17) THEN
#                    CALL cl_err(g_imn[l_ac].imn17,'aim-034',1)
#                    NEXT FIELD CURRENT
#                 END IF
#              END IF
#              IF g_imn[l_ac].imn17 <>  g_imn[l_ac].imn06 THEN
#                 CALL cl_err(g_imn[l_ac].imn17,'aim-035',1)
#                 NEXT FIELD imn17
#              END IF
#           END IF
#           #FUN-A40022--end--add--------
#           SELECT img09  INTO g_imn[l_ac].imn20
#             FROM img_file WHERE img01=g_imn[l_ac].imn03 AND
#                                 img02=g_imn[l_ac].imn15 AND
#                                 img03=g_imn[l_ac].imn16 AND
#                                 img04=g_imn[l_ac].imn17
#           IF SQLCA.sqlcode THEN
#               IF NOT cl_confirm('mfg1401') THEN NEXT FIELD imn15 END IF
#                  CALL s_add_img(g_imn[l_ac].imn03,g_imn[l_ac].imn15,
#                                 g_imn[l_ac].imn16,g_imn[l_ac].imn17,
#                                 g_imm.imm01      ,g_imn[l_ac].imn02,
#                                 g_imm.imm02)
#               IF g_errno='N' THEN NEXT FIELD imn17 END IF
#               SELECT img09  INTO g_imn[l_ac].imn20
#                 FROM img_file WHERE img01=g_imn[l_ac].imn03 AND
#                                     img02=g_imn[l_ac].imn15 AND
#                                     img03=g_imn[l_ac].imn16 AND
#                                     img04=g_imn[l_ac].imn17
#           END IF
#           CALL s_umfchk(g_imn[l_ac].imn03,
#                         g_imn[l_ac].imn09,g_imn[l_ac].imn20)
#               RETURNING g_cnt,g_imn[l_ac].imn21
#               DISPLAY BY NAME g_imn[l_ac].imn21
#           IF g_cnt = 1 THEN
#              CALL cl_err('','mfg3075',1)
#              NEXT FIELD imn17
#           END IF
#          #str MOD-A30247 add
#          #當沒有輸入儲位、批號時,撥入倉庫不可與在途倉一樣
#           IF g_imn[l_ac].imn16=' ' AND g_imn[l_ac].imn17=' ' AND 
#              g_imn[l_ac].imn15=g_imm.imm08 THEN
#              CALL cl_err(g_imn[l_ac].imn15,'aim1010',1)
#              NEXT FIELD imn15
#           END IF
#          #end MOD-A30247 add
#           LET g_img09_t=g_imn[l_ac].imn20  #No.FUN-570249
#
#          #CHECK 在途倉是否存在img_file ,沒有的話可for在途倉新增img_file
#           SELECT img09  INTO g_imn[l_ac].imn20
#             FROM img_file WHERE img01=g_imn[l_ac].imn03 AND
#                                 img02=g_imm.imm08 AND
#                                 img03=' ' AND
#                                 img04=' '
#           IF SQLCA.sqlcode THEN
#               IF NOT cl_confirm('mfg1402') THEN NEXT FIELD imn17 END IF
#               CALL s_add_img(g_imn[l_ac].imn03,g_imm.imm08,' ',' ',
#                              g_imm.imm01,g_imn[l_ac].imn02,g_imm.imm02)
#               IF g_errno='N' THEN NEXT FIELD imn17 END IF
#           END IF
#
#           IF p_cmd = 'u' THEN
#              CALL t324_chk_in() RETURNING g_i
#              IF g_i THEN
#                  NEXT FIELD imn15
#              END IF
#           END IF
#           DISPLAY BY NAME g_imn[l_ac].imn20
#           IF g_sma.sma115 = 'Y' THEN
#              IF g_imn_t.imn03 IS NULL OR g_imn[l_ac].imn03 <> g_imn_t.imn03 OR
#                 g_imn_t.imn15 IS NULL OR g_imn[l_ac].imn15 <> g_imn_t.imn15 OR
#                 g_imn_t.imn16 IS NULL OR g_imn[l_ac].imn16 <> g_imn_t.imn16 OR
#                 g_imn_t.imn17 IS NULL OR g_imn[l_ac].imn17 <> g_imn_t.imn17 THEN
#                 IF g_argv1[1] != '_' OR cl_null(g_argv1[1]) THEN     #No.MOD-890237
#                    CALL t325_du_default(p_cmd,g_imn[l_ac].imn03,g_imn[l_ac].imn15,
#                                        g_imn[l_ac].imn16,g_imn[l_ac].imn17)
#                         RETURNING g_imn[l_ac].imn43,g_imn[l_ac].imn44,
#                                   g_imn[l_ac].imn45,g_imn[l_ac].imn40,
#                                   g_imn[l_ac].imn41,g_imn[l_ac].imn42
#                 END IF
#              END IF
#           END IF
#FUN-B50096 ---------------End-------------------
 
        BEFORE FIELD imn43
           CALL t325_set_no_required()
 
        AFTER FIELD imn43  #第二單位
           IF cl_null(g_imn[l_ac].imn03) THEN NEXT FIELD imn03 END IF
           IF g_imn[l_ac].imn15 IS NULL OR g_imn[l_ac].imn16 IS NULL OR
              g_imn[l_ac].imn17 IS NULL THEN
              NEXT FIELD imn15
           END IF
           IF NOT cl_null(g_imn[l_ac].imn43) THEN
              SELECT gfe02 INTO g_buf FROM gfe_file
               WHERE gfe01=g_imn[l_ac].imn43
                 AND gfeacti='Y'
              IF STATUS THEN
                 CALL cl_err3("sel","gfe_file",g_imn[l_ac].imn43,"",
                               SQLCA.sqlcode,"","gfe:",1)  #No.FUN-660156
                 NEXT FIELD imn43
              END IF
              CALL s_du_umfchk(g_imn[l_ac].imn03,'','','',
                               g_img09_t,g_imn[l_ac].imn43,g_ima906)
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_imn[l_ac].imn43,g_errno,0)
                 NEXT FIELD imn43
              END IF
              IF cl_null(g_imn_t.imn43) OR g_imn_t.imn43 <> g_imn[l_ac].imn43 THEN
                 LET g_imn[l_ac].imn44 = g_factor
              END IF
              CALL s_umfchk(g_imn[l_ac].imn03,g_imn[l_ac].imn33,g_imn[l_ac].imn43)
                   RETURNING g_flag,g_factor
              IF g_flag = 1 THEN
                 LET g_msg=g_imn[l_ac].imn03,' ',g_imn[l_ac].imn33,' ',g_imn[l_ac].imn43
                 CALL cl_err(g_msg CLIPPED,'mfg3075',1)
                 NEXT FIELD imn43
              ELSE
                 LET g_imn[l_ac].imn52=g_factor
              END IF
              CALL s_chk_imgg(g_imn[l_ac].imn03,g_imn[l_ac].imn15,
                              g_imn[l_ac].imn16,g_imn[l_ac].imn17,
                              g_imn[l_ac].imn43) RETURNING g_flag
              IF g_flag = 1 THEN
                 IF g_sma.sma892[3,3] = 'Y' THEN
                    IF NOT cl_confirm('aim-995') THEN NEXT FIELD imn43 END IF
                 END IF
                 CALL s_add_imgg(g_imn[l_ac].imn03,g_imn[l_ac].imn15,
                                 g_imn[l_ac].imn16,g_imn[l_ac].imn17,
                                 g_imn[l_ac].imn43,g_imn[l_ac].imn44,
                                 g_imm.imm01,g_imn[l_ac].imn02,0)
                      RETURNING g_flag
                 IF g_flag = 1 THEN
                    NEXT FIELD imn43
                 END IF
              END IF
              CALL s_chk_imgg(g_imn[l_ac].imn03,g_imm.imm08,' ',' ',
                              g_imn[l_ac].imn43) RETURNING g_flag
              IF g_flag = 1 THEN
                 IF g_sma.sma892[3,3] = 'Y' THEN
                    IF NOT cl_confirm('aim-995') THEN NEXT FIELD imn43 END IF
                 END IF
                 CALL s_add_imgg(g_imn[l_ac].imn03,g_imm.imm08,' ',' ',
                                 g_imn[l_ac].imn43,g_imn[l_ac].imn44,
                                 g_imm.imm01,g_imn[l_ac].imn02,0)
                      RETURNING g_flag
                 IF g_flag = 1 THEN
                    NEXT FIELD imn43
                 END IF
              END IF
              LET g_imn[l_ac].imn45=g_imn[l_ac].imn35*g_imn[l_ac].imn52
              LET g_imn[l_ac].imn45=s_digqty(g_imn[l_ac].imn45,g_imn[l_ac].imn43)   #No.FUN-BB0086
           END IF
           CALL t325_set_required()
           LET g_imn_t.imn43=g_imn[l_ac].imn43
 
        BEFORE FIELD imn40  #第一單位
           IF cl_null(g_imn[l_ac].imn03) THEN NEXT FIELD imn03 END IF
           IF g_imn[l_ac].imn15 IS NULL OR g_imn[l_ac].imn16 IS NULL OR
              g_imn[l_ac].imn17 IS NULL THEN
              NEXT FIELD imn15
           END IF
           IF NOT cl_null(g_imn[l_ac].imn43) AND g_ima906 = '3' THEN
              CALL s_du_umfchk(g_imn[l_ac].imn03,'','','',
                               g_img09_t,g_imn[l_ac].imn43,g_ima906)
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_imn[l_ac].imn43,g_errno,0)
                 NEXT FIELD imn15
              END IF
              IF cl_null(g_imn_t.imn43) OR g_imn_t.imn43 <> g_imn[l_ac].imn43 THEN
                 LET g_imn[l_ac].imn44 = g_factor
              END IF
              CALL s_umfchk(g_imn[l_ac].imn03,g_imn[l_ac].imn33,g_imn[l_ac].imn43)
                   RETURNING g_flag,g_factor
              IF g_flag = 1 THEN
                 LET g_msg=g_imn[l_ac].imn03,' ',g_imn[l_ac].imn33,' ',g_imn[l_ac].imn43
                 CALL cl_err(g_msg CLIPPED,'mfg3075',1)
                 LET g_factor=1
              ELSE
                 LET g_imn[l_ac].imn52=g_factor
              END IF
              CALL s_chk_imgg(g_imn[l_ac].imn03,g_imn[l_ac].imn15,
                              g_imn[l_ac].imn16,g_imn[l_ac].imn17,
                              g_imn[l_ac].imn43) RETURNING g_flag
              IF g_flag = 1 THEN
                 IF g_sma.sma892[3,3] = 'Y' THEN
                    IF NOT cl_confirm('aim-995') THEN NEXT FIELD imn15 END IF
                 END IF
                 CALL s_add_imgg(g_imn[l_ac].imn03,g_imn[l_ac].imn15,
                                 g_imn[l_ac].imn16,g_imn[l_ac].imn17,
                                 g_imn[l_ac].imn43,g_imn[l_ac].imn44,
                                 g_imm.imm01,g_imn[l_ac].imn02,0)
                      RETURNING g_flag
                 IF g_flag = 1 THEN
                    NEXT FIELD imn15
                 END IF
              END IF
              CALL s_chk_imgg(g_imn[l_ac].imn03,g_imm.imm08,' ',' ',
                              g_imn[l_ac].imn43) RETURNING g_flag
              IF g_flag = 1 THEN
                 IF g_sma.sma892[3,3] = 'Y' THEN
                    IF NOT cl_confirm('aim-995') THEN NEXT FIELD imn43 END IF
                 END IF
                 CALL s_add_imgg(g_imn[l_ac].imn03,g_imm.imm08,' ',' ',
                                 g_imn[l_ac].imn43,g_imn[l_ac].imn44,
                                 g_imm.imm01,g_imn[l_ac].imn02,0)
                      RETURNING g_flag
                 IF g_flag = 1 THEN
                    NEXT FIELD imn15
                 END IF
              END IF
              LET g_imn[l_ac].imn45=g_imn[l_ac].imn35*g_imn[l_ac].imn52
              LET g_imn[l_ac].imn45=s_digqty(g_imn[l_ac].imn45,g_imn[l_ac].imn43)   #No.FUN-BB0086
              IF p_cmd = 'a' THEN
                 LET g_tot=g_imn[l_ac].imn45*g_imn[l_ac].imn44
                 IF cl_null(g_imn[l_ac].imn42) OR g_imn[l_ac].imn42=0 THEN
                    LET g_imn[l_ac].imn42=g_tot*g_imn[l_ac].imn41
                    LET g_imn[l_ac].imn42 = s_digqty(g_imn[l_ac].imn42,g_imn[l_ac].imn40)   #No.FUN-BB0086
                 END IF
              END IF
           END IF
           CALL t325_set_no_required()
 
        AFTER FIELD imn40  #第一單位
           IF cl_null(g_imn[l_ac].imn03) THEN NEXT FIELD imn03 END IF
           IF g_imn[l_ac].imn15 IS NULL OR g_imn[l_ac].imn16 IS NULL OR
              g_imn[l_ac].imn17 IS NULL THEN
              NEXT FIELD imn15
           END IF
           IF NOT cl_null(g_imn[l_ac].imn40) THEN
              SELECT gfe02 INTO g_buf FROM gfe_file
               WHERE gfe01=g_imn[l_ac].imn40
                 AND gfeacti='Y'
              IF STATUS THEN
                 CALL cl_err3("sel","gfe_file",g_imn[l_ac].imn40,"",
                               SQLCA.sqlcode,"","gfe:",1)  #No.FUN-660156
                 NEXT FIELD imn40
              END IF
              CALL s_du_umfchk(g_imn[l_ac].imn03,'','','',
                               g_imn[l_ac].imn20,g_imn[l_ac].imn40,'1')
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_imn[l_ac].imn40,g_errno,0)
                 NEXT FIELD imn40
              END IF
              IF cl_null(g_imn_t.imn40) OR g_imn_t.imn40 <> g_imn[l_ac].imn40 THEN
                 LET g_imn[l_ac].imn41 = g_factor
              END IF
              CALL s_umfchk(g_imn[l_ac].imn03,g_imn[l_ac].imn30,g_imn[l_ac].imn40)
                   RETURNING g_flag,g_factor
              IF g_flag = 1 THEN
                 LET g_msg=g_imn[l_ac].imn03,' ',g_imn[l_ac].imn30,' ',g_imn[l_ac].imn40
                 CALL cl_err(g_msg CLIPPED,'mfg3075',1)
                 NEXT FIELD imn40
              ELSE
                 LET g_imn[l_ac].imn51=g_factor
              END IF
              IF g_ima906 = '2' THEN
                 CALL s_chk_imgg(g_imn[l_ac].imn03,g_imn[l_ac].imn15,
                                 g_imn[l_ac].imn16,g_imn[l_ac].imn17,
                                 g_imn[l_ac].imn40) RETURNING g_flag
                 IF g_flag = 1 THEN
                    IF g_sma.sma892[3,3] = 'Y' THEN
                       IF NOT cl_confirm('aim-995') THEN NEXT FIELD imn40 END IF
                    END IF
                    CALL s_add_imgg(g_imn[l_ac].imn03,g_imn[l_ac].imn15,
                                    g_imn[l_ac].imn16,g_imn[l_ac].imn17,
                                    g_imn[l_ac].imn40,g_imn[l_ac].imn41,
                                    g_imm.imm01,g_imn[l_ac].imn02,0)
                         RETURNING g_flag
                    IF g_flag = 1 THEN
                       NEXT FIELD imn40
                    END IF
                 END IF
                 CALL s_chk_imgg(g_imn[l_ac].imn03,g_imm.imm08,' ',' ',
                                 g_imn[l_ac].imn40) RETURNING g_flag
                 IF g_flag = 1 THEN
                    IF g_sma.sma892[3,3] = 'Y' THEN
                       IF NOT cl_confirm('aim-995') THEN NEXT FIELD imn43 END IF
                    END IF
                    CALL s_add_imgg(g_imn[l_ac].imn03,g_imm.imm08,' ',' ',
                                    g_imn[l_ac].imn40,g_imn[l_ac].imn41,
                                    g_imm.imm01,g_imn[l_ac].imn02,0)
                         RETURNING g_flag
                    IF g_flag = 1 THEN
                       NEXT FIELD imn40
                    END IF
                 END IF
              END IF
              LET g_imn[l_ac].imn42=g_imn[l_ac].imn32*g_imn[l_ac].imn51
              LET g_imn[l_ac].imn42=s_digqty(g_imn[l_ac].imn42,g_imn[l_ac].imn40)   #No.FUN-BB0086
           END IF
           CALL t325_set_required()
 
        
        AFTER FIELD imn9301 
           IF NOT s_costcenter_chk(g_imn[l_ac].imn9301) THEN
              LET g_imn[l_ac].imn9301=g_imn_t.imn9301
              LET g_imn[l_ac].gem02b=g_imn_t.gem02b
              DISPLAY BY NAME g_imn[l_ac].imn9301,g_imn[l_ac].gem02b
              NEXT FIELD imn9301
           ELSE
              LET g_imn[l_ac].gem02b=s_costcenter_desc(g_imn[l_ac].imn9301)
              DISPLAY BY NAME g_imn[l_ac].gem02b
           END IF
        AFTER FIELD imn9302 
           IF NOT s_costcenter_chk(g_imn[l_ac].imn9302) THEN
              LET g_imn[l_ac].imn9302=g_imn_t.imn9302
              LET g_imn[l_ac].gem02c=g_imn_t.gem02c
              DISPLAY BY NAME g_imn[l_ac].imn9302,g_imn[l_ac].gem02c
              NEXT FIELD imn9302
           ELSE
              LET g_imn[l_ac].gem02c=s_costcenter_desc(g_imn[l_ac].imn9302)
              DISPLAY BY NAME g_imn[l_ac].gem02c
           END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_imn_t.imn02 > 0 AND g_imn_t.imn02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM imn_file
                 WHERE imn01 = g_imm.imm01 AND imn02 = g_imn_t.imn02 
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","imn_file",g_imn_t.imn02,"",
                                 SQLCA.sqlcode,"","",1)  #No.FUN-660156
                   ROLLBACK WORK
                   CANCEL DELETE
                #FUN-B70074-add-str--
                ELSE
                   IF NOT s_industry('std') THEN
                      IF NOT s_del_imni(g_imm.imm01,g_imn_t.imn02,'') THEN 
                         ROLLBACK WORK
                         CANCEL DELETE
                      END IF 
                   END IF
                #FUN-B70074-add-end--
                END IF
                #No.MOD-AA0086  --Begin
                SELECT ima918,ima921 INTO g_ima918,g_ima921
                  FROM ima_file
                 WHERE ima01 = g_imn[l_ac].imn03
                   AND imaacti = "Y"

                IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                  #IF NOT s_lotout_del(g_prog,g_imm.imm01,g_imn[l_ac].imn02,0,g_imn[l_ac].imn03,'DEL') THEN   #No:FUN-860045    #TQC-B90236 mark
                   IF NOT s_lot_del(g_prog,g_imm.imm01,g_imn[l_ac].imn02,0,g_imn[l_ac].imn03,'DEL') THEN   #No:FUN-860045    #TQC-B90236 add
                      CALL cl_err3("del","rvbs_file",g_imm.imm01,g_imn_t.imn02,SQLCA.sqlcode,"","",1)
                      ROLLBACK WORK
                      CANCEL DELETE
                   END IF
                END IF
                #No.MOD-AA0086  --End  
                COMMIT WORK
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_imn[l_ac].* = g_imn_t.*
              CLOSE t325_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           #FUN-CB0087---add---str---
           IF g_aza.aza115 = 'Y' THEN
              IF NOT t325_imn28_chk1() THEN
                 NEXT FIELD imn28
              END IF
           END IF
           #FUN-CB0087---add---end---
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_imn[l_ac].imn02,-263,1)
              LET g_imn[l_ac].* = g_imn_t.*
           ELSE
              IF g_sma.sma115 = 'Y' THEN
                 CALL s_chk_va_setting(g_imn[l_ac].imn03)
                      RETURNING g_flag,g_ima906,g_ima907
                 IF g_flag=1 THEN
                    NEXT FIELD imn03
                 END IF
                 CALL t325_du_data_to_correct()
                 CALL t325_set_origin_field()
              END IF
              CALL t325_b_move_back()
 
              UPDATE imn_file SET * = b_imn.*
                 WHERE imn01=g_imm.imm01 AND imn02=g_imn_t.imn02 
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","imn_file",g_imm.imm01,g_imn_t.imn02,
                               SQLCA.sqlcode,"","upd imn",1)  #No.FUN-660156
                 LET g_imn[l_ac].* = g_imn_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
	         COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac      #FUN-D30033 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='a' AND l_ac <= g_imn.getLength() THEN   #CHI-C30106 add
                 #No.MOD-AA0086  --Begin
                 SELECT ima918,ima921 INTO g_ima918,g_ima921
                   FROM ima_file
                  WHERE ima01 = g_imn[l_ac].imn03
                    AND imaacti = "Y"
                 IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                   #IF NOT s_lotout_del(g_prog,g_imm.imm01,g_imn[l_ac].imn02,0,g_imn[l_ac].imn03,'DEL') THEN   #No:FUN-860045  #TQC-B90236 mark
                    IF NOT s_lot_del(g_prog,g_imm.imm01,g_imn[l_ac].imn02,0,g_imn[l_ac].imn03,'DEL') THEN   #No:FUN-860045  #TQC-B90236 add
                       CALL cl_err3("del","rvbs_file",g_imm.imm01,g_imn_t.imn02,SQLCA.sqlcode,"","",1)
                    END IF
                 END IF
               END IF  #CHI-C30106 add
               #No.MOD-AA0086  --End  
               IF p_cmd='u' THEN
                  LET g_imn[l_ac].* = g_imn_t.*
               #FUN-D30033--add--str--
               ELSE
                  CALL g_imn.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30033--add--end-- 
               END IF
               CLOSE t325_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac      #FUN-D30033 Add
            #FUN-CB0087---add---str---
            IF g_aza.aza115 = 'Y' THEN
               IF NOT t325_imn28_chk1() THEN
                  NEXT FIELD imn28
               END IF
            END IF
            #FUN-CB0087---add---end---
            CLOSE t325_bcl
            COMMIT WORK

        #No.MOD-AA0086  --Begin
        ON ACTION modi_lot
           SELECT ima918,ima921 INTO g_ima918,g_ima921
             FROM ima_file
            WHERE ima01 = g_imn[l_ac].imn03
              AND imaacti = "Y"
           IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
             #CALL s_lotout(g_prog,g_imm.imm01,g_imn[l_ac].imn02,0,                   #TQC-B90236 mark
              CALL s_mod_lot(g_prog,g_imm.imm01,g_imn[l_ac].imn02,0,                   #TQC-B90236 add
                            g_imn[l_ac].imn03,g_imn[l_ac].imn04,
                            g_imn[l_ac].imn05,g_imn[l_ac].imn06,
                            g_imn[l_ac].imn09,g_imn[l_ac].imn09,1,
                            g_imn[l_ac].imn10,'','MOD',-1)#CHI-9A0022 add ''          #TQC-B90236 add '-1'
                     RETURNING l_r,g_qty
              IF l_r = "Y" THEN
                 LET g_imn[l_ac].imn10 = g_qty
                 LET g_imn[l_ac].imn10 = s_digqty(g_imn[l_ac].imn10,g_imn[l_ac].imn09)   #No.FUN-BB0086
              END IF
           END IF
        #No.MOD-AA0086  --End  

        #CHI-C30106---add---S---
          AFTER INPUT
            LET g_cnt = 0
            SELECT COUNT(*) INTO g_cnt FROM imn_file WHERE imn01=g_imm.imm01
            FOR l_c = 1 TO g_cnt
              SELECT ima918,ima921 INTO g_ima918,g_ima921
                FROM ima_file
               WHERE ima01 = g_imn[l_c].imn03
                 AND imaacti = "Y"

              IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                UPDATE rvbs_file SET rvbs021 = g_imn[l_c].imn03
                 WHERE rvbs00= g_prog
                   AND rvbs01= g_imm.imm01
                   AND rvbs02= g_imn[l_c].imn02
              END IF
            END FOR
        #CHI-C30106---add---E---
#CHI-C50041---begin
        ON ACTION regen_detail
           IF NOT cl_confirm('aim-148') THEN                                                                                              
              EXIT INPUT                                                                                                    
           END IF 
           CALL t325_del()
           CALL aimt325_g() 
           CALL t325_b_fill(" 1=1")
           EXIT INPUT
#CHI-C50041---end  
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(imn02) AND l_ac > 1 THEN
               LET g_imn[l_ac].* = g_imn[l_ac-1].*
               LET g_imn[l_ac].imn02 = NULL
               NEXT FIELD imn02
            END IF
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(imn03)
#FUN-AA0059 --Begin--
                #   CALL cl_init_qry_var()
                #   LET g_qryparam.form     ="q_ima"
                #   LET g_qryparam.default1 = g_imn[l_ac].imn03
                #   CALL cl_create_qry() RETURNING g_imn[l_ac].imn03
                    CALL q_sel_ima(FALSE, "q_ima", "", g_imn[l_ac].imn03, "", "", "", "" ,"",'' )  RETURNING g_imn[l_ac].imn03
#FUN-AA0059 --End--
                    DISPLAY BY NAME g_imn[l_ac].imn03     #No.MOD-490371
                   NEXT FIELD imn03
              WHEN INFIELD(imn04) OR INFIELD(imn05) OR INFIELD(imn06)
                 #FUN-C30300---begin
                 LET g_ima906 = NULL
                 SELECT ima906 INTO g_ima906 FROM ima_file
                  WHERE ima01 = g_imn[l_ac].imn03
                 #IF s_industry("icd") AND g_ima906='3' THEN  #TQC-C60028
                 IF s_industry("icd") THEN  #TQC-C60028
                    CALL q_idc(FALSE,TRUE,g_imn[l_ac].imn03,g_imn[l_ac].imn04,g_imn[l_ac].imn05,g_imn[l_ac].imn06)
                    RETURNING g_imn[l_ac].imn04,g_imn[l_ac].imn05,g_imn[l_ac].imn06
                 ELSE
                 #FUN-C30300---end
                   CALL q_img4(FALSE,TRUE,g_imn[l_ac].imn03,g_imn[l_ac].imn04,g_imn[l_ac].imn05,g_imn[l_ac].imn06,'A')  ##NO.FUN-660085
                        RETURNING g_imn[l_ac].imn04,
                                  g_imn[l_ac].imn05,g_imn[l_ac].imn06
                 END IF #FUN-C30300
                   DISPLAY g_imn[l_ac].imn04 TO imn04
                   DISPLAY g_imn[l_ac].imn05 TO imn05
                   DISPLAY g_imn[l_ac].imn06 TO imn06
                   IF INFIELD(imn04) THEN NEXT FIELD imn04 END IF
                   IF INFIELD(imn05) THEN NEXT FIELD imn05 END IF
                   IF INFIELD(imn06) THEN NEXT FIELD imn06 END IF
              WHEN INFIELD(imn15) OR INFIELD(imn16) OR INFIELD(imn17)
                 #FUN-C30300---begin
                 LET g_ima906 = NULL
                 SELECT ima906 INTO g_ima906 FROM ima_file
                  WHERE ima01 = g_imn[l_ac].imn03
                 #IF s_industry("icd") AND g_ima906='3' THEN  #TQC-C60028
                 IF s_industry("icd") THEN  #TQC-C60028
                    CALL q_idc(FALSE,TRUE,g_imn[l_ac].imn03,g_imn[l_ac].imn15,g_imn[l_ac].imn16,g_imn[l_ac].imn17)
                    RETURNING g_imn[l_ac].imn15,g_imn[l_ac].imn16,g_imn[l_ac].imn17
                 ELSE
                 #FUN-C30300---end
                   CALL q_img4(FALSE,TRUE,g_imn[l_ac].imn03,g_imn[l_ac].imn15,g_imn[l_ac].imn16,g_imn[l_ac].imn17,'A')  ##NO.FUN-660085
                        RETURNING g_imn[l_ac].imn15,
                                  g_imn[l_ac].imn16,g_imn[l_ac].imn17
                 END IF #FUN-C30300
                   DISPLAY g_imn[l_ac].imn15 TO imn15
                   DISPLAY g_imn[l_ac].imn16 TO imn16
                   DISPLAY g_imn[l_ac].imn17 TO imn17
                   IF INFIELD(imn15) THEN NEXT FIELD imn15 END IF
                   IF INFIELD(imn16) THEN NEXT FIELD imn16 END IF
                   IF INFIELD(imn17) THEN NEXT FIELD imn17 END IF
               WHEN INFIELD(imn28) #理由
                  #FUN-CB0087---add---str---
                  LET l_store = ''
                  IF NOT cl_null(g_imn[l_ac].imn04) THEN
                     LET l_store = l_store,g_imn[l_ac].imn04
                  END IF
                  IF NOT cl_null(g_imn[l_ac].imn15) THEN
                     IF NOT cl_null(l_store) THEN
                        LET l_store = l_store,"','",g_imn[l_ac].imn15
                     ELSE
                        LET l_store = l_store,g_imn[l_ac].imn15
                     END IF
                  END IF
                  CALL s_get_where(g_imm.imm01,'','',g_imn[l_ac].imn03,l_store,'',g_imm.imm14) RETURNING l_flag,l_where
                  IF l_flag AND g_aza.aza115 = 'Y' THEN
                     CALL cl_init_qry_var()
                     LET g_qryparam.form     ="q_ggc08"
                     LET g_qryparam.where = l_where
                     LET g_qryparam.default1 = g_imn[l_ac].imn28
                  ELSE
                  #FUN-CB0087---add---end---
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_azf01a"    #FUN-920186
                  LET g_qryparam.default1 = g_imn[l_ac].imn28
                  LET g_qryparam.arg1     = "6"           #FUN-920186
                  END IF                                  #FUN-CB0087
                  CALL cl_create_qry() RETURNING g_imn[l_ac].imn28
                  DISPLAY g_imn[l_ac].imn28 TO imn28
                  CALL t325_azf03()                #FUN-CB0087
                  NEXT FIELD imn28                 #FUN-CB0087
              WHEN INFIELD(imn33) #單位
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gfe"
                   LET g_qryparam.default1 = g_imn[l_ac].imn33
                   CALL cl_create_qry() RETURNING g_imn[l_ac].imn33
                   NEXT FIELD imn33
              WHEN INFIELD(imn30) #單位
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gfe"
                   LET g_qryparam.default1 = g_imn[l_ac].imn30
                   CALL cl_create_qry() RETURNING g_imn[l_ac].imn30
                   NEXT FIELD imn30
              WHEN INFIELD(imn43) #單位
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gfe"
                   LET g_qryparam.default1 = g_imn[l_ac].imn43
                   CALL cl_create_qry() RETURNING g_imn[l_ac].imn43
                   NEXT FIELD imn43
              WHEN INFIELD(imn40) #單位
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gfe"
                   LET g_qryparam.default1 = g_imn[l_ac].imn40
                   CALL cl_create_qry() RETURNING g_imn[l_ac].imn40
                   NEXT FIELD imn40
               WHEN INFIELD(att00)                                              
#FUN-AA0059 --Begin--
                #  CALL cl_init_qry_var()                                        
                #  LET g_qryparam.form ="q_ima_p"                                
                #  LET g_qryparam.arg1 = lg_group                                
                #  CALL cl_create_qry() RETURNING g_imn[l_ac].att00              
                  CALL q_sel_ima(FALSE, "q_ima_p", "", "" , lg_group, "", "", "" ,"",'' )  RETURNING g_imn[l_ac].att00 
#FUN-AA0059 --End--
                  DISPLAY BY NAME g_imn[l_ac].att00        
                  LET g_imn[l_ac].imn03 =g_imn[l_ac].att00                      
                  LET g_imn[l_ac].att01 =null                                   
                  LET g_imn[l_ac].att01_c =null                                 
                  LET g_imn[l_ac].att02 =null                                   
                  LET g_imn[l_ac].att02_c =null                                 
                  LET g_imn[l_ac].att03 =null                                   
                  LET g_imn[l_ac].att03_c =null                                 
                  LET g_imn[l_ac].att04 =null                                   
                  LET g_imn[l_ac].att04_c =null                                 
                  LET g_imn[l_ac].att05 =null                                   
                  LET g_imn[l_ac].att05_c =null                                 
                  LET g_imn[l_ac].att06 =null                                   
                  LET g_imn[l_ac].att06_c =null                                 
                  LET g_imn[l_ac].att07 =null                                   
                  LET g_imn[l_ac].att07_c =null                                 
                  LET g_imn[l_ac].att08 =null                                   
                  LET g_imn[l_ac].att08_c =null                                 
                  LET g_imn[l_ac].att09 =null                                   
                  LET g_imn[l_ac].att09_c =null                                 
                  LET g_imn[l_ac].att10 =null                                   
                  LET g_imn[l_ac].att10_c =null                                 
                  NEXT FIELD att00  
               WHEN INFIELD(imn9301)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gem4"
                  CALL cl_create_qry() RETURNING g_imn[l_ac].imn9301
                  DISPLAY BY NAME g_imn[l_ac].imn9301
                  NEXT FIELD imn9301
               WHEN INFIELD(imn9302)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gem4"
                  CALL cl_create_qry() RETURNING g_imn[l_ac].imn9302
                  DISPLAY BY NAME g_imn[l_ac].imn9302
                  NEXT FIELD imn9302
           END CASE
 
        ON ACTION mntn_reason
                    CALL cl_cmdrun("aooi301")  #6818
 
        ON ACTION qry_tro_imf #預設倉庫/ 儲位
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     = "q_imf"
                 LET g_qryparam.default1 = g_imn[l_ac].imn04
                 LET g_qryparam.default2 = g_imn[l_ac].imn05
                 LET g_qryparam.arg1     = g_imn[l_ac].imn03
                 LET g_qryparam.arg2     = "A"
                 CALL cl_create_qry() RETURNING g_imn[l_ac].imn04,g_imn[l_ac].imn05
                 NEXT FIELD imn04
							
        ON ACTION qry_tri_imf #預設倉庫/ 儲位
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     = "q_imf"
                 LET g_qryparam.default1 = g_imn[l_ac].imn15
                 LET g_qryparam.default2 = g_imn[l_ac].imn16
                 LET g_qryparam.arg1     = g_imn[l_ac].imn03
                 LET g_qryparam.arg2     = "A"
                 CALL cl_create_qry() RETURNING g_imn[l_ac].imn15,g_imn[l_ac].imn16
                 NEXT FIELD imn15

        #CHI-A30005 add --start--
        ON ACTION q_imd    #查詢倉庫
           CALL cl_init_qry_var()
           LET g_qryparam.form ="q_imd"
           LET g_qryparam.default1 = g_imn[l_ac].imn15
           LET g_qryparam.arg1     = 'SW'        #倉庫類別 
           CALL cl_create_qry() RETURNING g_imn[l_ac].imn15
           NEXT FIELD imn15
        #CHI-A30005 add --end--

        #CHI-A30005 add --start--
        ON ACTION q_ime    #查詢倉庫儲位
           CALL cl_init_qry_var()
           LET g_qryparam.form ="q_ime1"
           LET g_qryparam.arg1     = 'SW'        #倉庫類別
           LET g_qryparam.default1 = g_imn[l_ac].imn15
           LET g_qryparam.default2 = g_imn[l_ac].imn16
           CALL cl_create_qry() RETURNING g_imn[l_ac].imn15,g_imn[l_ac].imn16
           NEXT FIELD imn15
        #CHI-A30005 add --end--

        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
 
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
 
    LET g_imm.immmodu = g_user
    LET g_imm.immdate = g_today
    UPDATE imm_file SET immmodu=g_imm.immmodu,immdate=g_imm.immdate
     WHERE imm01=g_imm.imm01 AND imm10='2' 
    DISPLAY BY NAME g_imm.immmodu,g_imm.immdate
 
    SELECT COUNT(*) INTO g_cnt FROM imn_file
     WHERE imn01=g_imm.imm01 
    CLOSE t325_bcl
    COMMIT WORK
#   CALL i000_delall() #No.FUN-870100 #CHI-C30002 mark
    CALL i000_delHeader()     #CHI-C30002 add
 
END FUNCTION

#FUN-B50096 ----------------Begin----------------
FUNCTION t325_b_imn05_inschk()
DEFINE l_ima159    LIKE ima_file.ima159
DEFINE l_img10     LIKE img_file.img10
DEFINE p_cmd       LIKE type_file.chr1
   IF g_imn[l_ac].imn06 IS NULL THEN LET g_imn[l_ac].imn06=' ' END IF
   LET l_ima159 = ''
   SELECT ima159 INTO l_ima159 FROM ima_file
    WHERE ima01 = g_imn[l_ac].imn03
   IF l_ima159 = '1' THEN
      IF cl_null(g_imn[l_ac].imn06) THEN
         CALL cl_err(g_imn[l_ac].imn06,'aim-034',1)
         RETURN "imn06"
      END IF
   END IF
   IF s_industry('icd') THEN
      IF g_imn[l_ac].imn17 <>  g_imn[l_ac].imn06 THEN
         CALL cl_err(g_imn[l_ac].imn17,'aim-035',1)
         RETURN "imn06"
      END IF
   END IF
   IF g_imn[l_ac].imn05=' ' AND g_imn[l_ac].imn06=' ' AND
      g_imn[l_ac].imn04=g_imm.imm08 THEN
      CALL cl_err(g_imn[l_ac].imn04,'aim1010',1)
      RETURN "imn04"
   END IF
   CALL t325_chk_whl()
   IF NOT cl_null(g_errno) THEN
      CALL cl_err('imn06',g_errno,1)
   #  RETURN "imn06"     #MOD-C30573--mark--
      RETURN "imn04"     #MOD-C30573--add--
   END IF
   SELECT img09,img10  INTO g_imn[l_ac].imn09,l_img10
     FROM img_file WHERE img01=g_imn[l_ac].imn03
                     AND img02=g_imn[l_ac].imn04
                     AND img03=g_imn[l_ac].imn05
                     AND img04=g_imn[l_ac].imn06


   IF SQLCA.sqlcode THEN
      LET l_img10 = 0
      #FUN-C80107 modify begin--------------------------------------------121024
      #CALL cl_err(g_imn[l_ac].imn06,'mfg6101',0)
      #RETURN "imn04"
      INITIALIZE g_flag1 TO NULL
      #CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_imn[l_ac].imn04) RETURNING g_flag1  #FUN-D30024--mark
      CALL s_inv_shrt_by_warehouse(g_imn[l_ac].imn04,g_plant) RETURNING g_flag1  #FUN-D30024--add #TQC-D40078 g_plant
      IF g_flag1 = 'N' OR g_flag1 IS NULL THEN
         CALL cl_err(g_imn[l_ac].imn06,'mfg6101',0)
         RETURN "imn04"
      ELSE
         IF g_sma.sma892[3,3] = 'Y' THEN
            IF NOT cl_confirm('mfg1401') THEN RETURN "imn04" END IF
         END IF
         CALL s_add_img(g_imn[l_ac].imn03,g_imn[l_ac].imn04,
                        g_imn[l_ac].imn05,g_imn[l_ac].imn06,
                        g_imm.imm01      ,g_imn[l_ac].imn02,
                        g_imm.imm02)
         IF g_errno='N' THEN
            RETURN "imn04"
         END IF
         SELECT img09,img10  INTO g_imn[l_ac].imn09,l_img10
           FROM img_file
          WHERE img01=g_imn[l_ac].imn03
            AND img02=g_imn[l_ac].imn04
            AND img03=g_imn[l_ac].imn05
            AND img04=g_imn[l_ac].imn06
      END IF
      #FUN-C80107 modify end----------------------------------------------
   END IF
   DISPLAY BY NAME g_imn[l_ac].imn09
  #MOD-CA0009---mark---S
  ##-->有效日期
  #IF NOT s_actimg(g_imn[l_ac].imn03,g_imn[l_ac].imn04,
  #                g_imn[l_ac].imn05,g_imn[l_ac].imn06)
  #THEN CALL cl_err('inactive','mfg6117',0)
  #   RETURN "imn04"
  #END IF
  #MOD-CA0009---mark---E
   IF p_cmd = 'u' THEN
      CALL t325_chk_out() RETURNING g_i
      IF g_i THEN
         RETURN "imn04"
      END IF
   END IF
   LET g_img09_s=g_imn[l_ac].imn09
   LET g_img10_s=l_img10
   IF g_sma.sma115 = 'Y' THEN
     #MOD-C10152 str-----------------
     #IF g_imn_t.imn03 IS NULL OR g_imn[l_ac].imn03 <> g_imn_t.imn03 OR
     #   g_imn_t.imn04 IS NULL OR g_imn[l_ac].imn04 <> g_imn_t.imn04 OR
     #   g_imn_t.imn05 IS NULL OR g_imn[l_ac].imn05 <> g_imn_t.imn05 OR
     #   g_imn_t.imn06 IS NULL OR g_imn[l_ac].imn06 <> g_imn_t.imn06 THEN

      IF g_imn_o.imn03 IS NULL OR g_imn[l_ac].imn03 <> g_imn_o.imn03 OR
         g_imn_o.imn04 IS NULL OR g_imn[l_ac].imn04 <> g_imn_o.imn04 OR
         g_imn_o.imn05 IS NULL OR g_imn[l_ac].imn05 <> g_imn_o.imn05 OR
         g_imn_o.imn06 IS NULL OR g_imn[l_ac].imn06 <> g_imn_o.imn06 THEN
         CALL t325_du_default(p_cmd,g_imn[l_ac].imn03,g_imn[l_ac].imn04,
                             g_imn[l_ac].imn05,g_imn[l_ac].imn06)
              RETURNING g_imn[l_ac].imn33,g_imn[l_ac].imn34,
                        g_imn[l_ac].imn35,g_imn[l_ac].imn30,
                        g_imn[l_ac].imn31,g_imn[l_ac].imn32
     #MOD-C10152 end-----------------
      END IF
   END IF
   RETURN NULL
END FUNCTION

FUNCTION t325_b_imn16_inschk()
DEFINE l_ima159    LIKE ima_file.ima159
DEFINE l_img10     LIKE img_file.img10
DEFINE p_cmd       LIKE type_file.chr1
DEFINE l_date      LIKE type_file.dat         #CHI-C50010 add
DEFINE l_img37     LIKE img_file.img37        #CHI-C80007 add

   IF g_imn[l_ac].imn17 = '　' THEN #全型空白
      LET g_imn[l_ac].imn17 = ' '
   END IF
   IF g_imn[l_ac].imn17 IS NULL THEN
      LET g_imn[l_ac].imn17 = ' '
   END IF

   CALL t325_chk_whl()
   IF NOT cl_null(g_errno) THEN
      CALL cl_err('imn16',g_errno,1)
  #   RETURN "imn17"      #MOD-C30573--mark
      RETURN "imn15"      #MOD-C30573--add
   END IF

   IF g_imn[l_ac].imn04 = g_imn[l_ac].imn15 AND
      g_imn[l_ac].imn05 = g_imn[l_ac].imn16 AND
      g_imn[l_ac].imn06 = g_imn[l_ac].imn17 THEN
      CALL cl_err('','mfg9090',1)
      RETURN "imn15"
   END IF
   LET l_ima159 = ''
   SELECT ima159 INTO l_ima159 FROM ima_file
    WHERE ima01 = g_imn[l_ac].imn03
   IF l_ima159 = '1' THEN
      IF cl_null(g_imn[l_ac].imn17) THEN
         CALL cl_err(g_imn[l_ac].imn17,'aim-034',1)
         RETURN "imn17"
      END IF
   END IF
   IF s_industry('icd') THEN
      IF g_imn[l_ac].imn17 <>  g_imn[l_ac].imn06 THEN
         CALL cl_err(g_imn[l_ac].imn17,'aim-035',1)
         RETURN "imn17"
      END IF
   END IF
   SELECT img09  INTO g_imn[l_ac].imn20
     FROM img_file WHERE img01=g_imn[l_ac].imn03 AND
                         img02=g_imn[l_ac].imn15 AND
                         img03=g_imn[l_ac].imn16 AND
                         img04=g_imn[l_ac].imn17
   IF SQLCA.sqlcode THEN
       IF NOT cl_confirm('mfg1401') THEN RETURN "imn15" END IF
         #CHI-C50010 str add-----
         #SELECT img18 INTO l_date FROM img_file                #CHI-C80007 mark 
          SELECT img18,img37 INTO l_date,l_img37 FROM img_file  #CHI-C80007 add img37
           WHERE img01 = g_imn[l_ac].imn03
             AND img02 = g_imn[l_ac].imn04
             AND img03 = g_imn[l_ac].imn05
             AND img04 = g_imn[l_ac].imn06
          CALL s_date_record(l_date,'Y')
         #CHI-C50010 end add-----
          CALL s_idledate_record(l_img37)  #CHI-C80007 add
          CALL s_add_img(g_imn[l_ac].imn03,g_imn[l_ac].imn15,
                         g_imn[l_ac].imn16,g_imn[l_ac].imn17,
                         g_imm.imm01      ,g_imn[l_ac].imn02,
                         g_imm.imm02)
       IF g_errno='N' THEN RETURN "imn17" END IF
       SELECT img09  INTO g_imn[l_ac].imn20
         FROM img_file WHERE img01=g_imn[l_ac].imn03 AND
                             img02=g_imn[l_ac].imn15 AND
                             img03=g_imn[l_ac].imn16 AND
                             img04=g_imn[l_ac].imn17
   END IF
   CALL s_umfchk(g_imn[l_ac].imn03,
                 g_imn[l_ac].imn09,g_imn[l_ac].imn20)
       RETURNING g_cnt,g_imn[l_ac].imn21
       DISPLAY BY NAME g_imn[l_ac].imn21
   IF g_cnt = 1 THEN
      CALL cl_err('','mfg3075',1)
      RETURN "imn17"
   END IF
  #當沒有輸入儲位、批號時,撥入倉庫不可與在途倉一樣
   IF g_imn[l_ac].imn16=' ' AND g_imn[l_ac].imn17=' ' AND
      g_imn[l_ac].imn15=g_imm.imm08 THEN
      CALL cl_err(g_imn[l_ac].imn15,'aim1010',1)
      RETURN "imn15"
   END IF
   LET g_img09_t=g_imn[l_ac].imn20
  #CHECK 在途倉是否存在img_file ,沒有的話可for在途倉新增img_file
   SELECT img09  INTO g_imn[l_ac].imn20
     FROM img_file WHERE img01=g_imn[l_ac].imn03
                     AND img02=g_imm.imm08
                     AND img03=' '
                     AND img04=' '
   IF SQLCA.sqlcode THEN
       IF NOT cl_confirm('mfg1402') THEN RETURN "imn17" END IF
      #CHI-C50010 str add-----
      #SELECT img18 INTO l_date FROM img_file                #CHI-C80007 mark 
       SELECT img18,img37 INTO l_date,l_img37 FROM img_file  #CHI-C80007 add img37
        WHERE img01 = g_imn[l_ac].imn03
          AND img02 = g_imn[l_ac].imn04
          AND img03 = g_imn[l_ac].imn05
          AND img04 = g_imn[l_ac].imn06
       CALL s_date_record(l_date,'Y')
      #CHI-C50010 end add-----
       CALL s_idledate_record(l_img37)  #CHI-C80007 add
       CALL s_add_img(g_imn[l_ac].imn03,g_imm.imm08,' ',' ',
                      g_imm.imm01,g_imn[l_ac].imn02,g_imm.imm02)
       IF g_errno='N' THEN RETURN "imn17" END IF
   END IF
   IF p_cmd = 'u' THEN
      CALL t324_chk_in() RETURNING g_i
      IF g_i THEN
         RETURN "imn15"
      END IF
   END IF
   DISPLAY BY NAME g_imn[l_ac].imn20
   IF g_sma.sma115 = 'Y' THEN
     #MOD-C10152 str-----------------
     #IF g_imn_t.imn03 IS NULL OR g_imn[l_ac].imn03 <> g_imn_t.imn03 OR
     #   g_imn_t.imn15 IS NULL OR g_imn[l_ac].imn15 <> g_imn_t.imn15 OR
     #   g_imn_t.imn16 IS NULL OR g_imn[l_ac].imn16 <> g_imn_t.imn16 OR
     #   g_imn_t.imn17 IS NULL OR g_imn[l_ac].imn17 <> g_imn_t.imn17 THEN

      IF g_imn_o.imn03 IS NULL OR g_imn[l_ac].imn03 <> g_imn_o.imn03 OR
         g_imn_o.imn15 IS NULL OR g_imn[l_ac].imn15 <> g_imn_o.imn15 OR
         g_imn_o.imn16 IS NULL OR g_imn[l_ac].imn16 <> g_imn_o.imn16 OR
         g_imn_o.imn17 IS NULL OR g_imn[l_ac].imn17 <> g_imn_o.imn17 THEN
     #MOD-C10152 end-----------------
         IF g_argv1[1] != '_' OR cl_null(g_argv1[1]) THEN     #No.MOD-890237
            CALL t325_du_default(p_cmd,g_imn[l_ac].imn03,g_imn[l_ac].imn15,
                                g_imn[l_ac].imn16,g_imn[l_ac].imn17)
                 RETURNING g_imn[l_ac].imn43,g_imn[l_ac].imn44,
                           g_imn[l_ac].imn45,g_imn[l_ac].imn40,
                           g_imn[l_ac].imn41,g_imn[l_ac].imn42
         END IF
      END IF
   END IF
   RETURN NULL
END FUNCTION
#FUN-B50096 ----------------End------------------
 
FUNCTION t325_chk_whl()
 
    IF cl_null(g_imn[l_ac].imn04) AND 
       cl_null(g_imn[l_ac].imn15) AND
       cl_null(g_imn[l_ac].imn05) AND 
       cl_null(g_imn[l_ac].imn16) AND
       cl_null(g_imn[l_ac].imn06) AND 
       cl_null(g_imn[l_ac].imn17) THEN
       RETURN
    END IF
 
    LET g_errno =''
    #撥出/入的倉儲批不可相同
     IF g_imn[l_ac].imn04=g_imn[l_ac].imn15 AND
        g_imn[l_ac].imn05=g_imn[l_ac].imn16 THEN
        IF g_imn[l_ac].imn06=g_imn[l_ac].imn17  THEN
           LET g_errno = 'mfg6103'
        END IF
     END IF
 
END FUNCTION
 
FUNCTION t325_chk_jce(p_wip,p_wh1,p_wh2)
  DEFINE p_wh1         LIKE imn_file.imn04,
         p_wh2         LIKE imn_file.imn04,
         p_wip         LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
         l_chk_cost1   LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
         l_chk_cost2   LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
 
  LET l_chk_cost1 = 'Y'
  LET l_chk_cost2 = 'Y'
  LET g_errno = ''
 
  IF NOT cl_null(p_wh1) THEN
    #不計成本倉庫 check
    SELECT COUNT(*) INTO g_cnt FROM jce_file
      WHERE jce02=p_wh1
    IF g_cnt>0 THEN
       LET l_chk_cost1 = 'N'
    END IF
  END IF
  IF NOT cl_null(p_wh2) THEN
    #不計成本倉庫 check
    SELECT COUNT(*) INTO g_cnt FROM jce_file
      WHERE jce02=p_wh2
    IF g_cnt>0 THEN
       LET l_chk_cost2 = 'N'
    END IF
  END IF
 
  IF cl_null(p_wh1) OR cl_null(p_wh2) THEN
     IF cl_null(p_wh1) THEN
        LET l_chk_cost1 = l_chk_cost2
     END IF
     IF cl_null(p_wh2) THEN
        LET l_chk_cost2 = l_chk_cost1
     END IF
  END IF
  #成本倉與非成本倉間不得調撥
  CASE WHEN g_wip != l_chk_cost1        LET g_errno = 'aim-131'
       WHEN g_wip != l_chk_cost2        LET g_errno = 'aim-132'
       WHEN l_chk_cost1 != l_chk_cost2  LET g_errno = 'aim-133'
       OTHERWISE                        LET g_errno = ''
  END CASE
 
END FUNCTION
 
 
FUNCTION t325_b_move_to()
    LET g_imn[l_ac].imn02=b_imn.imn02
    LET g_imn[l_ac].imn03=b_imn.imn03
    LET g_imn[l_ac].imn29=b_imn.imn29    #No.FUN-5C0077
    LET g_imn[l_ac].imn28=b_imn.imn28
    LET g_imn[l_ac].imn26=b_imn.imn26
    LET g_imn[l_ac].imn04=b_imn.imn04
    LET g_imn[l_ac].imn05=b_imn.imn05
    LET g_imn[l_ac].imn06=b_imn.imn06
    LET g_imn[l_ac].imn09=b_imn.imn09
    LET g_imn[l_ac].imn10=b_imn.imn10
    LET g_imn[l_ac].imn15=b_imn.imn15
    LET g_imn[l_ac].imn16=b_imn.imn16
    LET g_imn[l_ac].imn17=b_imn.imn17
    LET g_imn[l_ac].imn20=b_imn.imn20
    LET g_imn[l_ac].imn21=b_imn.imn21
    LET g_imn[l_ac].imn22=b_imn.imn22
    LET b_imn.imnplant=g_imm.immplant    #FUN-870100
    LET g_imn[l_ac].imn33=b_imn.imn33
    LET g_imn[l_ac].imn34=b_imn.imn34
    LET g_imn[l_ac].imn35=b_imn.imn35
    LET g_imn[l_ac].imn30=b_imn.imn30
    LET g_imn[l_ac].imn31=b_imn.imn31
    LET g_imn[l_ac].imn32=b_imn.imn32
    LET g_imn[l_ac].imn43=b_imn.imn43
    LET g_imn[l_ac].imn44=b_imn.imn44
    LET g_imn[l_ac].imn45=b_imn.imn45
    LET g_imn[l_ac].imn40=b_imn.imn40
    LET g_imn[l_ac].imn41=b_imn.imn41
    LET g_imn[l_ac].imn42=b_imn.imn42
    LET g_imn[l_ac].imn51=b_imn.imn51
    LET g_imn[l_ac].imn52=b_imn.imn52
    LET g_imn[l_ac].imn9301=b_imn.imn9301 #FUN-670093
    LET g_imn[l_ac].imn9302=b_imn.imn9302 #FUN-670093
END FUNCTION
 
FUNCTION t325_b_move_back()
    LET b_imn.imn02=g_imn[l_ac].imn02
    LET b_imn.imn03=g_imn[l_ac].imn03
    LET b_imn.imn29=g_imn[l_ac].imn29   #No.FUN-5C0077
    LET b_imn.imn28=g_imn[l_ac].imn28
    LET b_imn.imn26=g_imn[l_ac].imn26
    LET b_imn.imn04=g_imn[l_ac].imn04
    LET b_imn.imn05=g_imn[l_ac].imn05
    LET b_imn.imn06=g_imn[l_ac].imn06
    LET b_imn.imn09=g_imn[l_ac].imn09
    LET b_imn.imn10=g_imn[l_ac].imn10
    LET b_imn.imn15=g_imn[l_ac].imn15
    LET b_imn.imn16=g_imn[l_ac].imn16
    LET b_imn.imn17=g_imn[l_ac].imn17
    LET b_imn.imn20=g_imn[l_ac].imn20
    LET b_imn.imn21=g_imn[l_ac].imn21
    LET b_imn.imn22=g_imn[l_ac].imn22
    LET b_imn.imn14=''
#   LET b_imn.imn26=''     #FUN-D20059
    LET b_imn.imn33=g_imn[l_ac].imn33
    LET b_imn.imn34=g_imn[l_ac].imn34
    LET b_imn.imn35=g_imn[l_ac].imn35
    LET b_imn.imn30=g_imn[l_ac].imn30
    LET b_imn.imn31=g_imn[l_ac].imn31
    LET b_imn.imn32=g_imn[l_ac].imn32
    LET b_imn.imn43=g_imn[l_ac].imn43
    LET b_imn.imn44=g_imn[l_ac].imn44
    LET b_imn.imn45=g_imn[l_ac].imn45
    LET b_imn.imn40=g_imn[l_ac].imn40
    LET b_imn.imn41=g_imn[l_ac].imn41
    LET b_imn.imn42=g_imn[l_ac].imn42
    LET b_imn.imn51=g_imn[l_ac].imn51
    LET b_imn.imn52=g_imn[l_ac].imn52
    LET b_imn.imn9301=g_imn[l_ac].imn9301 #FUN-670093
    LET b_imn.imn9302=g_imn[l_ac].imn9302 #FUN-670093
    LET b_imn.imnplant = g_plant #FUN-980004 add
    LET b_imn.imnlegal = g_legal #FUN-980004 add
    LET b_imn.imn12='N' #TQC-DB0039
    LET b_imn.imn24='N' #TQC-DB0039
END FUNCTION
 
FUNCTION t325_b_askkey()
DEFINE l_wc2           LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON imn03,imn29,imn28,imn26,imn04,imn05,imn17,imn09,imn10,  #No.FUN-5C0077
                       imn15,imn16,imn17,imn20,imn21,imn22
         FROM s_imn[1].imn02,s_imn[1].imn03,s_imn[1].imn29,s_imn[1].imn28,    #No.FUN-5C0077
              s_imn[1].imn26,s_imn[1].imn04,
              s_imn[1].imn05,s_imn[1].imn09,s_imn[1].imn10,
              s_imn[1].imn15,s_imn[1].imn16,s_imn[1].imn17,
              s_imn[1].imn20,s_imn[1].imn21,s_imn[1].imn22
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
    CALL t325_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t325_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2           LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(200)
 
    LET g_sql =
        "SELECT imn02,imn03,'','','','','','','','','','','','','','','','','','','','','',imn29,ima02,ima021,imn04,imn05,imn06,imn09,",   #No.FUN-5C0077 #No.TQC-650115   #FUN-CB0087 去掉imn28
        "       imn9301,'',imn33,imn34,imn35,imn30, imn31,imn32,", #FUN-670093
        "       imn15,imn16,imn17,imn20,imn9302,'', imn10,imn22,imn21,", #FUN-670093
        "       imn43,imn44,imn45,imn40, imn41,imn42,imn52,imn51,imn28,azf03,",              #FUN-CB0087 add>imn28,azf03
        "       imn26",
        #" FROM imn_file, OUTER ima_file ",                                                                        #FUN-CB0087 mark
        "  FROM imn_file LEFT OUTER JOIN ima_file ON ima_file.ima01=imn_file.imn03 ",                              #FUN-CB0087 add
        "                LEFT OUTER JOIN azf_file ON azf_file.azf01=imn_file.imn28 AND azf_file.azf02 = '2' ",     #FUN-CB0087 add 
        " WHERE imn01 ='",g_imm.imm01,"'",          #單頭
        #"   AND imn_file.imn03 = ima_file.ima01 AND ",p_wc2 CLIPPED,  #單身                                       #FUN-CB0087 mark
        "   AND ",p_wc2 CLIPPED,                                                                                   #FUN-CB0087 add
        " ORDER BY imn02"
 
    PREPARE t325_pb FROM g_sql
    DECLARE imn_curs CURSOR FOR t325_pb
 
    CALL g_imn.clear()
 
    LET g_cnt = 1
    FOREACH imn_curs INTO g_imn[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN                       
           SELECT imx00,imx01,imx02,imx03,imx04,imx05,imx06,                    
                  imx07,imx08,imx09,imx10 INTO                                  
                  g_imn[g_cnt].att00,g_imn[g_cnt].att01,g_imn[g_cnt].att02,     
                  g_imn[g_cnt].att03,g_imn[g_cnt].att04,g_imn[g_cnt].att05,     
                  g_imn[g_cnt].att06,g_imn[g_cnt].att07,g_imn[g_cnt].att08,     
                  g_imn[g_cnt].att09,g_imn[g_cnt].att10                         
           FROM imx_file WHERE imx000 = g_imn[g_cnt].imn03                      
                                                                                
           LET g_imn[g_cnt].att01_c = g_imn[g_cnt].att01                        
           LET g_imn[g_cnt].att02_c = g_imn[g_cnt].att02                        
           LET g_imn[g_cnt].att03_c = g_imn[g_cnt].att03                        
           LET g_imn[g_cnt].att04_c = g_imn[g_cnt].att04                        
           LET g_imn[g_cnt].att05_c = g_imn[g_cnt].att05                        
           LET g_imn[g_cnt].att06_c = g_imn[g_cnt].att06                        
           LET g_imn[g_cnt].att07_c = g_imn[g_cnt].att07                        
           LET g_imn[g_cnt].att08_c = g_imn[g_cnt].att08                        
           LET g_imn[g_cnt].att09_c = g_imn[g_cnt].att09                        
           LET g_imn[g_cnt].att10_c = g_imn[g_cnt].att10                        
        END IF              
        LET g_imn[g_cnt].gem02b=s_costcenter_desc(g_imn[g_cnt].imn9301) #FUN-670093
        LET g_imn[g_cnt].gem02c=s_costcenter_desc(g_imn[g_cnt].imn9302) #FUN-670093
        LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_imn.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
 
    DISPLAY g_rec_b TO FORMONLY.cn2
    CALL t325_refresh_detail()  #No.TQC-650115
    #FUN-B30170 add begin-------------------------
    LET g_sql = " SELECT rvbs02,rvbs021,ima02,ima021,rvbs022,rvbs04,rvbs03,rvbs05,rvbs06,rvbs07,rvbs08",
                "   FROM rvbs_file LEFT JOIN ima_file ON rvbs021 = ima01",
                "  WHERE rvbs00 = '",g_prog,"' AND rvbs01 = '",g_imm.imm01,"'"
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
 
FUNCTION t325_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
#FUN-B30170 add begin-------------------------
   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_imn TO s_imn.* ATTRIBUTE(COUNT=g_rec_b)
 
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()

         AFTER DISPLAY
            CONTINUE DIALOG   #因為外層是DIALOG
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
         IF g_argv1[1]='_' THEN
            CALL cl_set_act_visible("insert,modify,delete,copy_offshore_wh,conf_transfer_out,undo_transfer_out,void",FALSE)
         ELSE
            CALL cl_set_act_visible("transfer_in_maintain,conf_transfer_in,undo_transfer_in",FALSE)
         END IF

      #FUN-D10081---add---str---
      ON ACTION page_list 
         LET g_action_flag="page_list"
         EXIT DIALOG
      #FUN-D10081---add---end---
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
      ON ACTION first
         CALL t325_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t325_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t325_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t325_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t325_fetch('L')
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
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CALL t325_mu_ui()   #TQC-710032
         EXIT DIALOG
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
    #@ON ACTION 出至境外倉複製
      ON ACTION copy_offshore_wh
         LET g_action_choice="copy_offshore_wh"
         EXIT DIALOG
    #@ON ACTION 撥出確認
      ON ACTION conf_transfer_out
         LET g_action_choice="conf_transfer_out"
         EXIT DIALOG
    #@ON ACTION 撥出確認還原
      ON ACTION undo_transfer_out
         LET g_action_choice="undo_transfer_out"
         EXIT DIALOG
    #@ON ACTION 撥入維護
      ON ACTION transfer_in_maintain
         LET g_action_choice="transfer_in_maintain"
         EXIT DIALOG
    #@ON ACTION 撥入確認
      ON ACTION conf_transfer_in
         LET g_action_choice="conf_transfer_in"
         EXIT DIALOG
    #@ON ACTION 撥入確認還原
      ON ACTION undo_transfer_in
         LET g_action_choice="undo_transfer_in"
         EXIT DIALOG
    #@ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DIALOG

      #CHI-D20010---begin
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DIALOG 
      #CHI-D20010---end      

      #No.MOD-AA0086  --Begin
      ON ACTION qry_lot
         LET g_action_choice="qry_lot"
         EXIT DIALOG
      #No.MOD-AA0086  --End  
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DIALOG
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON ACTION exporttoexcel #FUN-4B0002
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
    #@ON ACTION 拋轉至SPC
      ON ACTION trans_spc                     
         LET g_action_choice="trans_spc"
         EXIT DIALOG
     
      ON ACTION related_document                #No.FUN-680046  相關文件
         LET g_action_choice="related_document"          
         EXIT DIALOG    
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
    
      &include "qry_string.4gl"
   END DIALOG
#FUN-B30170 add -end--------------------------
#FUN-B30170 mark begin-----------------------------------
#   DISPLAY ARRAY g_imn TO s_imn.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
# 
#      BEFORE DISPLAY
#         CALL cl_navigator_setting( g_curs_index, g_row_count )
#         IF g_argv1[1]='_' THEN
#            CALL cl_set_act_visible("insert,modify,delete,copy_offshore_wh,conf_transfer_out,undo_transfer_out,void",FALSE)
#         ELSE
#            CALL cl_set_act_visible("transfer_in_maintain,conf_transfer_in,undo_transfer_in",FALSE)
#         END IF
# 
#      BEFORE ROW
#         LET l_ac = ARR_CURR()
#         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
# 
#      ON ACTION insert
#         LET g_action_choice="insert"
#         EXIT DISPLAY
#      ON ACTION query
#         LET g_action_choice="query"
#         EXIT DISPLAY
#      ON ACTION delete
#         LET g_action_choice="delete"
#         EXIT DISPLAY
#      ON ACTION modify
#         LET g_action_choice="modify"
#         EXIT DISPLAY
#      ON ACTION first
#         CALL t325_fetch('F')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#         IF g_rec_b != 0 THEN
#            CALL fgl_set_arr_curr(1)  ######add in 040505
#         END IF
#         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
# 
# 
#      ON ACTION previous
#         CALL t325_fetch('P')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#         IF g_rec_b != 0 THEN
#            CALL fgl_set_arr_curr(1)  ######add in 040505
#         END IF
#	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
# 
# 
#      ON ACTION jump
#         CALL t325_fetch('/')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#         IF g_rec_b != 0 THEN
#            CALL fgl_set_arr_curr(1)  ######add in 040505
#         END IF
#	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
# 
# 
#      ON ACTION next
#         CALL t325_fetch('N')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#         IF g_rec_b != 0 THEN
#            CALL fgl_set_arr_curr(1)  ######add in 040505
#         END IF
#	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
# 
# 
#      ON ACTION last
#         CALL t325_fetch('L')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#         IF g_rec_b != 0 THEN
#            CALL fgl_set_arr_curr(1)  ######add in 040505
#         END IF
#	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
# 
#      ON ACTION detail
#         LET g_action_choice="detail"
#         LET l_ac = 1
#         EXIT DISPLAY
#      ON ACTION output
#         LET g_action_choice="output"
#         EXIT DISPLAY
#      ON ACTION help
#         LET g_action_choice="help"
#         EXIT DISPLAY
# 
#      ON ACTION locale
#         CALL cl_dynamic_locale()
#         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#         CALL t325_mu_ui()   #TQC-710032
#         EXIT DISPLAY
# 
#      ON ACTION exit
#         LET g_action_choice="exit"
#         EXIT DISPLAY
# 
#      ON ACTION controlg
#         LET g_action_choice="controlg"
#         EXIT DISPLAY
#    #@ON ACTION 出至境外倉複製
#      ON ACTION copy_offshore_wh
#         LET g_action_choice="copy_offshore_wh"
#         EXIT DISPLAY
#    #@ON ACTION 撥出確認
#      ON ACTION conf_transfer_out
#         LET g_action_choice="conf_transfer_out"
#         EXIT DISPLAY
#    #@ON ACTION 撥出確認還原
#      ON ACTION undo_transfer_out
#         LET g_action_choice="undo_transfer_out"
#         EXIT DISPLAY
#    #@ON ACTION 撥入維護
#      ON ACTION transfer_in_maintain
#         LET g_action_choice="transfer_in_maintain"
#         EXIT DISPLAY
#    #@ON ACTION 撥入確認
#      ON ACTION conf_transfer_in
#         LET g_action_choice="conf_transfer_in"
#         EXIT DISPLAY
#    #@ON ACTION 撥入確認還原
#      ON ACTION undo_transfer_in
#         LET g_action_choice="undo_transfer_in"
#         EXIT DISPLAY
#    #@ON ACTION 作廢
#      ON ACTION void
#         LET g_action_choice="void"
#         EXIT DISPLAY
#      #No.MOD-AA0086  --Begin
#      ON ACTION qry_lot
#         LET g_action_choice="qry_lot"
#         EXIT DISPLAY
#      #No.MOD-AA0086  --End  
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
#      ON ACTION exporttoexcel #FUN-4B0002
#         LET g_action_choice = 'exporttoexcel'
#         EXIT DISPLAY
# 
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE DISPLAY
# 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
# 
#      AFTER DISPLAY
#         CONTINUE DISPLAY
# 
#    #@ON ACTION 拋轉至SPC
#      ON ACTION trans_spc                     
#         LET g_action_choice="trans_spc"
#         EXIT DISPLAY
#     
#      ON ACTION related_document                #No.FUN-680046  相關文件
#         LET g_action_choice="related_document"          
#         EXIT DISPLAY    
#     ON ACTION controls                                                                                                             
#         CALL cl_set_head_visible("","AUTO")                                                                                        
#    
#      &include "qry_string.4gl"
#    END DISPLAY
#FUN-B30170 mark -end------------------------------------
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t325_out()
    DEFINE l_wc,l_wc2   LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(100)
           l_prog       LIKE zz_file.zz01,
           l_prtway     LIKE zz_file.zz22
 
    IF cl_null(g_imm.imm01) THEN RETURN END IF
 
    LET g_msg = 'imm01="',g_imm.imm01,'" '
   #FUN-C30085--mark--begin---
   #IF cl_null(g_argv1) THEN
   #LET g_msg = "aimr512 '",g_today,"' '",g_user,"' '",g_lang,"' ",
   #            " 'Y' ' ' '1' ", 
   #            " '",g_msg,"' '2' '1'"   #MOD-690150 modify '1'
   #ELSE
   #LET g_msg = "aimr512 '",g_today,"' '",g_user,"' '",g_lang,"' ",
   #            " 'Y' ' ' '1' ", 
   #            " '",g_msg,"' '2' '2'"   #MOD-690150 modify '2'
   #END IF
   #FUN-C30085--mark--end---
   #FUN-C30085--add--begin---
    IF cl_null(g_argv1) THEN
       LET g_msg = "aimg512 '",g_today,"' '",g_user,"' '",g_lang,"' ",
                   " 'Y' ' ' '1' ",
                   " '",g_msg,"' '2' '1'"   #MOD-690150 modify '1'
    ELSE
       LET g_msg = "aimg512 '",g_today,"' '",g_user,"' '",g_lang,"' ",
                   " 'Y' ' ' '1' ",
                   " '",g_msg,"' '2' '2'"   #MOD-690150 modify '2'
    END IF
   #FUN-C30085--add--end---
    CALL cl_cmdrun(g_msg)
END FUNCTION
 
#DEV-D30046 搬移至aimt325_sub.4gl --mark--begin
#FUNCTION t325_y() #conf_transfer_out
#   DEFINE l_cnt       LIKE type_file.num10   #No.FUN-690026 INTEGER
#   DEFINE l_imm08_fac LIKE imn_file.imn21    #No.MOD-610096 add
#   DEFINE l_img09     LIKE img_file.img09    #No.MOD-610096 add
# 
#   DEFINE l_sql       LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(4000)
#   DEFINE l_imn10     LIKE imn_file.imn10
#   DEFINE l_imn29     LIKE imn_file.imn29
#   DEFINE l_imn03     LIKE imn_file.imn03
#   DEFINE l_qcs01     LIKE qcs_file.qcs01
#   DEFINE l_qcs02     LIKE qcs_file.qcs02
#   DEFINE l_qcs091    LIKE qcs_file.qcs091
#   DEFINE l_buf       LIKE gem_file.gem02     #TQC-B50032
#   DEFINE l_result    LIKE type_file.chr1     #TQC-C50158
#   DEFINE l_cnt_img   LIKE type_file.num5     #FUN-C70087
#   DEFINE l_cnt_imgg  LIKE type_file.num5     #FUN-C70087
#   DEFINE l_flag      LIKE type_file.chr1     #TQC-D20042
#   DEFINE l_where     STRING                  #TQC-D20042
#   DEFINE l_n         LIKE type_file.num5     #TQC-D20042
#   DEFINE l_store     STRING                  #TQC-D20042
#
#   IF s_shut(0) THEN RETURN END IF
# 
#   SELECT * INTO g_imm.* FROM imm_file WHERE imm01=g_imm.imm01 
#
##FUN-AB0066 --begin--
#   IF NOT s_chk_ware(g_imm.imm08) THEN 
#      RETURN 
#   END IF 
##FUN-AB0066 --end--
# 
#   IF g_imm.imm04 = 'Y' THEN CALL cl_err('','aim-002',0) RETURN END IF   #No.TQC-750041 
#   IF g_imm.imm04 = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
#   IF cl_null(g_imm.imm01) THEN CALL cl_err('',-400,0) RETURN END IF
#
#   IF NOT cl_confirm('aim-301') THEN RETURN END IF   #CHI-C50010 add
#
#
#   #TQC-B50032--begin
#   IF NOT cl_null(g_imm.imm14) THEN
#      SELECT gem02 INTO l_buf FROM gem_file
#       WHERE gem01=g_imm.imm14
#         AND gemacti='Y'   
#      IF STATUS THEN
#         CALL cl_err3("sel","gem_file",g_imm.imm14,"",SQLCA.sqlcode,"","select gem",1)
#         RETURN 
#      END IF
#   END IF
#   #TQC-B50032--end   
#   IF NOT cl_null(g_sma.sma53) AND g_imm.imm02 <= g_sma.sma53 THEN
#      CALL cl_err('','mfg9999',0) RETURN
#   END IF
# 
#   CALL s_yp(g_imm.imm02) RETURNING g_yy,g_mm
#   IF g_yy > g_sma.sma51 THEN               #與目前會計年度,期間比較
#      CALL cl_err(g_yy,'mfg6090',0)
#      RETURN
#   ELSE
#      IF g_yy=g_sma.sma51 AND g_mm > g_sma.sma52 THEN
#         CALL cl_err(g_mm,'mfg6091',0)
#         RETURN
#      END IF
#   END IF
# 
#   #No.+022 010328 by linda add 無單身不可確認
#   LET l_cnt=0
#   SELECT COUNT(*) INTO l_cnt FROM imn_file
#    WHERE imn01=g_imm.imm01 
#   IF l_cnt=0 OR l_cnt IS NULL THEN
#      CALL cl_err('','mfg-009',0)
#      RETURN
#   END IF
# 
#  #str MOD-A30247 add
#  #當沒有輸入儲位、批號時,撥出、入倉庫不可與在途倉一樣
#   DECLARE t325_y0_c CURSOR FOR
#      SELECT * FROM imn_file WHERE imn01=g_imm.imm01
#   FOREACH t325_y0_c INTO b_imn.*
#      IF STATUS THEN EXIT FOREACH END IF
#
#      IF (b_imn.imn05=' ' AND b_imn.imn06=' ' AND b_imn.imn04=g_imm.imm08) OR
#         (b_imn.imn16=' ' AND b_imn.imn17=' ' AND b_imn.imn15=g_imm.imm08) THEN
#         CALL cl_err(b_imn.imn04,'aim1010',1)
#         RETURN
#      END IF
#
##FUN-AB0066 --begin--
#     IF NOT s_chk_ware(b_imn.imn04) THEN 
#        RETURN 
#     END IF 
#     IF NOT s_chk_ware(b_imn.imn15) THEN 
#        RETURN 
#     END IF 
##FUN-AB0066 --end--
#      
#      #No.MOD-AA0086  --Begin
#      IF NOT t325_chk_qty() THEN
#         RETURN
#      END IF
#      #No.MOD-AA0086  --End  
#   END FOREACH
#  #end MOD-A30247 add
#
#   #FUN-C70087---begin
#   CALL s_padd_img_init()  #FUN-CC0095
#   CALL s_padd_imgg_init()  #FUN-CC0095
#   
#   DECLARE t325_y1_c3 CURSOR FOR SELECT * FROM imn_file
#     WHERE imn01 = g_imm.imm01 
#
#   FOREACH t325_y1_c3 INTO b_imn.*
#      IF STATUS THEN EXIT FOREACH END IF
#      LET l_cnt = 0
#      SELECT COUNT(*) INTO l_cnt
#        FROM img_file
#       WHERE img01 = b_imn.imn03
#         AND img02 = b_imn.imn15
#         AND img03 = b_imn.imn16
#         AND img04 = b_imn.imn17
#       IF l_cnt = 0 THEN
#          #CALL s_padd_img_data(b_imn.imn03,b_imn.imn15,b_imn.imn16,b_imn.imn17,g_imm.imm01,b_imn.imn02,g_imm.imm02,l_img_table) #FUN-CC0095
#          CALL s_padd_img_data1(b_imn.imn03,b_imn.imn15,b_imn.imn16,b_imn.imn17,g_imm.imm01,b_imn.imn02,g_imm.imm02) #FUN-CC0095
#       END IF
#
#       CALL s_chk_imgg(b_imn.imn03,b_imn.imn15,
#                       b_imn.imn16,b_imn.imn17,
#                       b_imn.imn40) RETURNING g_flag
#       IF g_flag = 1 THEN
#          #CALL s_padd_imgg_data(b_imn.imn03,b_imn.imn15,b_imn.imn16,b_imn.imn17,b_imn.imn40,g_imm.imm01,b_imn.imn02,l_imgg_table)  #FUN-CC0095
#          CALL s_padd_imgg_data1(b_imn.imn03,b_imn.imn15,b_imn.imn16,b_imn.imn17,b_imn.imn40,g_imm.imm01,b_imn.imn02)  #FUN-CC0095
#       END IF 
#       CALL s_chk_imgg(b_imn.imn03,b_imn.imn15,
#                       b_imn.imn16,b_imn.imn17,
#                       b_imn.imn43) RETURNING g_flag
#       IF g_flag = 1 THEN
#          #CALL s_padd_imgg_data(b_imn.imn03,b_imn.imn15,b_imn.imn16,b_imn.imn17,b_imn.imn43,g_imm.imm01,b_imn.imn02,l_imgg_table) #FUN-CC0095
#          CALL s_padd_imgg_data1(b_imn.imn03,b_imn.imn15,b_imn.imn16,b_imn.imn17,b_imn.imn43,g_imm.imm01,b_imn.imn02) #FUN-CC0095
#       END IF 
#   END FOREACH 
#   #FUN-CC0095---begin mark
#   #LET g_sql = " SELECT COUNT(*) ",
#   #            " FROM ",l_img_table CLIPPED  #,g_cr_db_str
#   #PREPARE cnt_img FROM g_sql
#   #LET l_cnt_img = 0
#   #EXECUTE cnt_img INTO l_cnt_img
#   #
#   #LET g_sql = " SELECT COUNT(*) ",
#   #            " FROM ",l_imgg_table CLIPPED #,g_cr_db_str
#   #PREPARE cnt_imgg FROM g_sql
#   #LET l_cnt_imgg = 0
#   #EXECUTE cnt_imgg INTO l_cnt_imgg
#   #FUN-CC0095---end   
#   LET l_cnt_img = g_padd_img.getLength()  #FUN-CC0095
#   LET l_cnt_imgg = g_padd_imgg.getLength()  #FUN-CC0095
#   
#   IF g_sma.sma892[3,3] = 'Y' AND (l_cnt_img > 0 OR l_cnt_imgg > 0) THEN
#      IF cl_confirm('mfg1401') THEN 
#         IF l_cnt_img > 0 THEN 
#            #IF NOT s_padd_img_show(l_img_table) THEN #FUN-CC0095
#            IF NOT s_padd_img_show1() THEN  #FUN-CC0095
#               #CALL s_padd_img_del(l_img_table) #FUN-CC0095
#               LET g_success = 'N' 
#               RETURN 
#            END IF 
#         END IF 
#         IF l_cnt_imgg > 0 THEN #FUN-CC0095 
#            #IF NOT s_padd_imgg_show(l_imgg_table) THEN  #FUN-CC0095
#            IF NOT s_padd_imgg_show1() THEN  #FUN-CC0095
#               #CALL s_padd_imgg_del(l_imgg_table) #FUN-CC0095
#               LET g_success = 'N'
#               RETURN 
#            END IF 
#         END IF #FUN-CC0095     
#      ELSE
#         #CALL s_padd_img_del(l_img_table)  #FUN-CC0095   
#         #CALL s_padd_imgg_del(l_imgg_table)  #FUN-CC0095   
#         LET g_success = 'N'
#         RETURN
#      END IF
#   END IF
#   #CALL s_padd_img_del(l_img_table)  #FUN-CC0095   
#   #CALL s_padd_imgg_del(l_imgg_table)  #FUN-CC0095   
#   #FUN-C70087---end
#  
#   LET l_sql="SELECT imn10,imn29,imn03,imn01,imn02 FROM imn_file",
#             " WHERE imn01= '",g_imm.imm01,"'"
#   PREPARE t324_curs1 FROM l_sql
#   DECLARE t324_pre1 CURSOR FOR t324_curs1
#   FOREACH t324_pre1 INTO l_imn10,l_imn29,l_imn03,l_qcs01,l_qcs02
#      IF l_imn29='Y' THEN
#         LET l_qcs091=0
#         SELECT SUM(qcs091) INTO l_qcs091 FROM qcs_file
#          WHERE qcs01=l_qcs01
#            AND qcs02=l_qcs02
#            AND qcs14='Y'
#         IF cl_null(l_qcs091) THEN LET l_qcs091=0 END IF
#         IF l_qcs091 < l_imn10 THEN
#            CALL cl_err(l_imn03,'aim1003',1)
#            RETURN
#         END IF
#      END IF
#   END FOREACH
# 
#  #IF NOT cl_confirm('aim-301') THEN RETURN END IF #CHI-C30106 mark
#  #IF NOT cl_confirm('aim-301') THEN RETURN END IF #TQC-C50158 add   #CHI-C50010 mark
# 
#   DECLARE t325_y1_c CURSOR FOR
#     SELECT * FROM imn_file WHERE imn01=g_imm.imm01 
# 
#   BEGIN WORK
# 
#   OPEN t325_cl USING g_imm.imm01
#   IF STATUS THEN
#      CALL cl_err("OPEN t325_cl:", STATUS, 1)
#      CLOSE t325_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
#   FETCH t325_cl INTO g_imm.*
#   IF SQLCA.sqlcode THEN
#      CALL cl_err("FETCH t325_cl:", STATUS, 1)
#      CLOSE t325_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
# 
#   LET g_success = 'Y'
# 
#   CALL s_showmsg_init()   #No.FUN-6C0083 
# 
#   FOREACH t325_y1_c INTO b_imn.*
#      IF STATUS THEN EXIT FOREACH END IF
#      #TQC-D20042---add---str---
#       IF g_aza.aza115 = 'Y' THEN
#          LET l_store = ''
#          IF NOT cl_null(b_imn.imn04) THEN
#             LET l_store = l_store,b_imn.imn04
#          END IF
#          IF NOT cl_null(b_imn.imn15) THEN
#             IF NOT cl_null(l_store) THEN
#                LET l_store = l_store,"','",b_imn.imn15
#             ELSE
#                LET l_store = l_store,b_imn.imn15
#             END IF
#          END IF
#          IF NOT cl_null(b_imn.imn28) THEN
#             LET l_n = 0
#             LET l_flag = FALSE
#             CALL s_get_where(g_imm.imm01,'','',b_imn.imn03,l_store,'',g_imm.imm14) RETURNING l_flag,l_where
#             IF g_aza.aza115='Y' AND l_flag THEN
#                LET l_sql = " SELECT COUNT(*) FROM ggc_file WHERE ggc08='",b_imn.imn28,"' AND ",l_where
#                PREPARE ggc08_pre5 FROM l_sql
#                EXECUTE ggc08_pre5 INTO l_n
#                IF l_n < 1 THEN
#                   LET g_success='N'
#                   CALL s_errmsg('imn28',b_imn.imn28,b_imn.imn28,'aim-425',1)
#                END IF
#             END IF
#          ELSE
#             LET g_success = 'N'
#             CALL s_errmsg('imn28',b_imn.imn28,b_imn.imn28,'aim-888',1)
#          END IF
#       END IF
#      #TQC-D20042---add---end---
#      #TQC-C50158--add--str--
#      #撥出倉庫過賬權限檢查
#      CALL s_incchk(b_imn.imn04,b_imn.imn05,g_user) RETURNING l_result
#      IF NOT l_result THEN  
#         LET g_success = 'N'
#         LET g_showmsg = b_imn.imn03,"/",b_imn.imn04,"/",b_imn.imn05,"/",g_user
#         CALL s_errmsg("imn03/imn04/imn05/inc03",g_showmsg,'','asf-888',1)
#         CONTINUE FOREACH
#      END IF 
#      #TQC-C50158--add--end--
#
#      IF cl_null(b_imn.imn04) THEN CONTINUE FOREACH END IF
#      MESSAGE 'Y:read parts==> ',b_imn.imn03
#
#      CALL s_t325_s(b_imn.imn03,b_imn.imn04,b_imn.imn05,b_imn.imn06,
#                    -1,b_imn.imn10,b_imn.imn09, b_imn.imn01,b_imn.imn02,
#                    g_imm.imm02,b_imn.imn28)   #No.B037       #No.TQC-760153 add imn28
#      IF g_success='N' THEN 
#         LET g_totsuccess="N"
#         LET g_success="Y"
#         CONTINUE FOREACH   #No.FUN-6C0083
#      END IF
#      SELECT img09 INTO l_img09 FROM img_file
#        WHERE img01=b_imn.imn03 AND img02=g_imm.imm08
#        AND img03 =' ' AND img04 = ' '
# 
#      CALL s_umfchk(b_imn.imn03,
#                         b_imn.imn09,l_img09)
#                    RETURNING l_cnt,l_imm08_fac
#           IF l_cnt = 1 THEN
#              LET l_imm08_fac = 1
#           END IF
#       LET b_imn.imn10 = b_imn.imn10 * l_imm08_fac
#       LET b_imn.imn10 = s_digqty(b_imn.imn10,b_imn.imn09)   #No.FUN-BB0086
# 
#      CALL s_t325_s(b_imn.imn03,g_imm.imm08,' '        ,' '        ,
#                    +1,b_imn.imn10,b_imn.imn09, b_imn.imn01,b_imn.imn02,
#                    g_imm.imm02,b_imn.imn28)   #No.B037     #No.TQC-760153 add imn28
#      IF g_success='N' THEN 
#         LET g_totsuccess="N"
#         LET g_success="Y"
#         CONTINUE FOREACH   #No.FUN-6C0083
#      END IF
#        IF g_sma.sma115='Y' THEN
#           CALL t325_upd_s(b_imn.imn04,b_imn.imn05,b_imn.imn06,
#                           b_imn.imn33,b_imn.imn34,b_imn.imn35,
#                           b_imn.imn30,b_imn.imn31,b_imn.imn32,
#                           b_imn.imn01,b_imn.imn02,1)
#           IF g_success='N' THEN
#              LET g_totsuccess="N"
#              LET g_success="Y"
#              CONTINUE FOREACH   #No.FUN-6C0083
#           END IF
#           CALL t325_upd_t(g_imm.imm08,' ',' ',
#                           b_imn.imn43,b_imn.imn44,b_imn.imn45,
#                           b_imn.imn40,b_imn.imn41,b_imn.imn42,
#                           b_imn.imn01,b_imn.imn02,1)
#           IF g_success='N' THEN
#              LET g_totsuccess="N"
#              LET g_success="Y"
#              CONTINUE FOREACH   #No.FUN-6C0083
#           END IF
#        END IF
#        #FUN-AC0074--behin--add---
#        CALL s_updsie_sie(b_imn.imn01,b_imn.imn02,'4')
#        IF g_success='N' THEN
#           LET g_totsuccess="N"
#           LET g_success="Y"
#           CONTINUE FOREACH
#        END IF
#        #FUN-AC0074--end--add-----
#   END FOREACH
# 
#   IF g_totsuccess="N" THEN
#      LET g_success="N"
#   END IF
#   CALL s_showmsg()   #No.FUN-6C0083
# 
#   IF g_success='Y' THEN
#      UPDATE imm_file SET imm04 = 'Y' WHERE imm01 = g_imm.imm01 
#      IF SQLCA.sqlcode THEN
#         CALL s_errmsg('imm01',g_imm.imm01,'up imm_file',SQLCA.sqlcode,1)
#         LET g_success = 'N'
#      END IF
#   END IF
# 
#   IF g_success = 'Y' THEN
#      COMMIT WORK
#      CALL cl_flow_notify(g_imm.imm01,'Y')
#      CALL cl_cmmsg(4)
#   ELSE
#      ROLLBACK WORK
#      CALL cl_rbmsg(4)
#   END IF
# 
#   SELECT imm04 INTO g_imm.imm04 FROM imm_file WHERE imm01 = g_imm.imm01 
#   DISPLAY BY NAME g_imm.imm04
# 
#   IF g_imm.imm04 = "N" THEN
#      DECLARE t325_y1_c2 CURSOR FOR SELECT * FROM imn_file
#        WHERE imn01 = g_imm.imm01 
# 
#      LET g_imm01 = ""
#      LET g_success = "Y"
# 
#      CALL s_showmsg_init()   #No.FUN-6C0083 
# 
#      BEGIN WORK
# 
#      FOREACH t325_y1_c2 INTO b_imn.*
#         IF STATUS THEN
#            EXIT FOREACH
#         END IF
# 
#         IF g_sma.sma115 = 'Y' THEN
#            IF g_ima906 = '2' THEN  #子母單位
#               LET g_unit_arr[1].unit= b_imn.imn30
#               LET g_unit_arr[1].fac = b_imn.imn31
#               LET g_unit_arr[1].qty = b_imn.imn32
#               LET g_unit_arr[2].unit= b_imn.imn33
#               LET g_unit_arr[2].fac = b_imn.imn34
#               LET g_unit_arr[2].qty = b_imn.imn35
#               CALL s_dismantle(g_imm.imm01,b_imn.imn02,g_imm.imm12,
#                                b_imn.imn03,b_imn.imn04,b_imn.imn05,
#                                b_imn.imn06,g_unit_arr,g_imm01)
#                      RETURNING g_imm01
#               IF g_success='N' THEN 
#                  LET g_totsuccess='N'
#                  LET g_success="Y"
#                  CONTINUE FOREACH   #No.FUN-6C0083
#               END IF
#            END IF
#         END IF
#      END FOREACH
# 
#      IF g_totsuccess="N" THEN
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
# 
#END FUNCTION
# 
#FUNCTION t325_s()
#   DEFINE li_result   LIKE type_file.num5     #No.FUN-550029  #No.FUN-690026 SMALLINT
#   DEFINE l_cnt       LIKE type_file.num10    #No.MOD-610096 add  #No.FUN-690026 INTEGER
#   DEFINE l_imm08_fac LIKE imn_file.imn21     #No.MOD-610096 add
#   DEFINE l_img09     LIKE img_file.img09     #No.MOD-610096 add
#   DEFINE l_t1        LIKE smy_file.smyslip   #TQC-7A0063 
#   DEFINE l_rvbs06    LIKE rvbs_file.rvbs06   #No.MOD-AA0086
#   DEFINE l_rvbs09    LIKE rvbs_file.rvbs09   #No.MOD-AA0086
#   DEFINE l_buf       LIKE gem_file.gem02     #TQC-B50032 
#   DEFINE l_result    LIKE type_file.chr1     #TQC-C50158
#   #CHI-CA0040---begin
#   DEFINE l_sql       STRING 
#   DEFINE l_imn10     LIKE imn_file.imn10
#   DEFINE l_imn29     LIKE imn_file.imn29
#   DEFINE l_imn03     LIKE imn_file.imn03
#   DEFINE l_qcs01     LIKE qcs_file.qcs01
#   DEFINE l_qcs02     LIKE qcs_file.qcs02
#   DEFINE l_qcs091    LIKE qcs_file.qcs091
#   #CHI-CA0040---end
#   DEFINE l_flag      LIKE type_file.chr1      #FUN-CB0087 add
#   DEFINE l_where     STRING                   #FUN-CB0087 add
#   DEFINE l_n         LIKE type_file.num5      #FUN-CB0087 add
#   DEFINE l_store     STRING                   #FUN-CB0087 add
#   
#   IF s_shut(0) THEN RETURN END IF
# 
#   SELECT * INTO g_imm.* FROM imm_file
#    WHERE imm01 = g_imm.imm01 
# 
#   IF cl_null(g_imm.imm01) THEN CALL cl_err('',-400,0) RETURN END IF
# 
#   IF g_imm.imm04 = 'N' THEN CALL cl_err('','aim-003',0) RETURN END IF     #No.TQC-750041
# 
#   IF g_imm.imm04 = 'X' THEN CALL cl_err('','9024',0) RETURN END IF    #no:6810 modify
# 
#   IF g_imm.imm03 = 'Y' THEN CALL cl_err('','aim-100',0) RETURN END IF #no:6810 modify
#
##FUN-AB0066 --begin--
#   IF NOT s_chk_ware(g_imm.imm08) THEN 
#      RETURN 
#   END IF 
##FUN-AB0066 --end--
# 
#   IF g_imm.imm12 > g_today THEN
#     CALL cl_err('','aim-504',0)
#     RETURN
#   END IF
#   #TQC-B50032--begin
#   IF NOT cl_null(g_imm.imm14) THEN
#      SELECT gem02 INTO l_buf FROM gem_file
#       WHERE gem01=g_imm.imm14
#         AND gemacti='Y'   
#      IF STATUS THEN
#         LET g_success = 'N'
#         CALL cl_err3("sel","gem_file",g_imm.imm14,"",SQLCA.sqlcode,"","select gem",1)
#         RETURN 
#      END IF
#   END IF
#   #TQC-B50032--end
#   IF cl_null(g_imm.imm11) OR cl_null(g_imm.imm12) OR cl_null(g_imm.imm13) THEN
#      CASE
#         WHEN cl_null(g_imm.imm11)
#            LET g_errno = 'aim-310'
#         WHEN cl_null(g_imm.imm12)
#            LET g_errno = 'aim-311'
#         WHEN cl_null(g_imm.imm13)
#            LET g_errno = 'aim-312'
#         OTHERWISE
#      END CASE
# 
#      CALL cl_err('',g_errno,1)
#      RETURN
#   END IF
# 
#   #檢查若#sma884=N,撥入單不可與撥出單相同(輸入撥入單後,再更改sma884就會有問題)
#   IF g_sma.sma884 = 'N' THEN
#      IF g_imm.imm01 = g_imm.imm11 THEN
#         CALL cl_err('','aim-314',0)
#         RETURN
#      ELSE
#         #檢查撥入單單據別是否正確
#         LET g_errno =''
#         LET l_t1 = s_get_doc_no(g_imm.imm11) #TQC-7A0063
#         CALL s_check_no("aim",l_t1,g_imm_t.imm11,"A","imm_file","imm11","")  #TQC-7A0063
#            RETURNING li_result,l_t1
#         DISPLAY BY NAME g_imm.imm11
#         IF (NOT li_result) THEN
#            RETURN
#         END IF
#      END IF
#   ELSE
#      #須檢查若#sma884='Y',且撥入單號<>撥出單號時,顯示訊息『#sma884='Y'撥入單號須等於撥出單號
#      #自動將『撥入單號』default 等於『撥出單號』
#      IF g_sma.sma884 = 'Y' THEN
#         IF g_imm.imm01 != g_imm.imm11 THEN
#            CALL cl_err('','aim-315',0)
#            LET g_imm.imm11 = g_imm.imm01
#            DISPLAY BY NAME g_imm.imm11
#            RETURN
#         ELSE
#           #檢查單據的合理性(單據不可重覆)
#            SELECT count(*) INTO g_cnt FROM imm_file
#             WHERE imm01 != g_imm.imm11 AND imm11 = g_imm.imm11 
#            IF g_cnt > 0 THEN   #資料重複
#               CALL cl_err(g_imm.imm11,-239,1)
#               RETURN
#            END IF
#         END IF
#      END IF
#   END IF
# 
# 
#   IF NOT cl_null(g_sma.sma53) AND g_imm.imm12 <= g_sma.sma53 THEN
#      CALL cl_err('','mfg9999',0)
#      RETURN
#   END IF
# 
#   CALL s_yp(g_imm.imm12) RETURNING g_yy,g_mm   #bugno:6810 modify imm02->imm12
# 
#   IF g_yy > g_sma.sma51 THEN                   #與目前會計年度,期間比較
#      CALL cl_err(g_yy,'mfg6090',0)
#      RETURN
#   ELSE
#      IF g_yy =g_sma.sma51 AND g_mm > g_sma.sma52 THEN    #No.MOD-8C0293
#         CALL cl_err(g_mm,'mfg6091',0)
#         RETURN
#      END IF
#   END IF
#
#   IF NOT cl_confirm('aim-301') THEN
#      RETURN
#   END IF
#
#   #CHI-CA0040---begin
#   LET l_sql="SELECT imn10,imn29,imn03,imn01,imn02 FROM imn_file",
#             " WHERE imn01= '",g_imm.imm01,"'"
#   PREPARE t324_curs2 FROM l_sql
#   DECLARE t324_pre2 CURSOR FOR t324_curs2
#   FOREACH t324_pre2 INTO l_imn10,l_imn29,l_imn03,l_qcs01,l_qcs02
#      IF l_imn29='Y' THEN
#         LET l_qcs091=0
#         SELECT SUM(qcs091) INTO l_qcs091 FROM qcs_file
#          WHERE qcs01=l_qcs01
#            AND qcs02=l_qcs02
#            AND qcs14='Y'
#         IF cl_null(l_qcs091) THEN LET l_qcs091=0 END IF
#         IF l_qcs091 < l_imn10 THEN
#            CALL cl_err(l_imn03,'aim1003',1)
#            RETURN
#         END IF
#      END IF
#   END FOREACH
#   #CHI-CA0040---end
# 
#   DECLARE t325_s1_c CURSOR FOR SELECT * FROM imn_file
#                                 WHERE imn01 = g_imm.imm01 
# 
#   BEGIN WORK
# 
#   OPEN t325_cl USING g_imm.imm01
#   IF STATUS THEN
#      CALL cl_err("OPEN t325_cl:", STATUS, 1)
#      CLOSE t325_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
# 
#   FETCH t325_cl INTO g_imm.*
#   IF SQLCA.sqlcode THEN
#      CALL cl_err(g_imm.imm01,SQLCA.sqlcode,0)
#      CLOSE t325_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
# 
# 
#   LET g_success = 'Y'
#   
#   CALL s_showmsg_init()   #No.FUN-6C0083 
# 
#   FOREACH t325_s1_c INTO b_imn.*
#       IF STATUS THEN EXIT FOREACH END IF
#       #FUN-CB0087---add---str---
#       IF g_aza.aza115 = 'Y' THEN
#          LET l_store = ''
#          IF NOT cl_null(b_imn.imn04) THEN
#             LET l_store = l_store,b_imn.imn04
#          END IF
#          IF NOT cl_null(b_imn.imn15) THEN
#             IF NOT cl_null(l_store) THEN
#                LET l_store = l_store,"','",b_imn.imn15
#             ELSE
#                LET l_store = l_store,b_imn.imn15
#             END IF
#          END IF
#          IF NOT cl_null(b_imn.imn28) THEN
#             LET l_n = 0
#             LET l_flag = FALSE
#             CALL s_get_where(g_imm.imm01,'','',b_imn.imn03,l_store,'',g_imm.imm14) RETURNING l_flag,l_where
#             IF g_aza.aza115='Y' AND l_flag THEN
#                LET l_sql = " SELECT COUNT(*) FROM ggc_file WHERE ggc08='",b_imn.imn28,"' AND ",l_where
#                PREPARE ggc08_pre4 FROM l_sql
#                EXECUTE ggc08_pre4 INTO l_n
#                IF l_n < 1 THEN
#                   LET g_success='N'
#                   CALL s_errmsg('imn28',b_imn.imn28,b_imn.imn28,'aim-425',1)
#                END IF
#             END IF
#          ELSE
#             LET g_success = 'N'
#             CALL s_errmsg('imn28',b_imn.imn28,b_imn.imn28,'aim-888',1)
#          END IF
#       END IF
#       #FUN-CB0087---add---end---
#       #TQC-C50158--add--str--
#       #撥入倉庫過賬權限檢查
#       CALL s_incchk(b_imn.imn15,b_imn.imn16,g_user) RETURNING l_result
#       IF NOT l_result THEN
#          LET g_success = 'N'
#          LET g_showmsg = b_imn.imn03,"/",b_imn.imn15,"/",b_imn.imn16,"/",g_user
#          CALL s_errmsg("imn03/imn15/imn16/inc03",g_showmsg,'','asf-888',1)
#          CONTINUE FOREACH
#       END IF
#       #TQC-C50158--add--end--
#       IF cl_null(b_imn.imn04) THEN CONTINUE FOREACH END IF
#       
#       MESSAGE '_s read parts:',b_imn.imn03
#       #No.MOD-AA0086  --Begin
#       #产生拨入的rvbs_file资料
#       CALL t325_ins_rvbs()
#       IF g_success='N' THEN
#          LET g_totsuccess="N"
#          LET g_success="Y"
#          CONTINUE FOREACH   #No.FUN-6C0083
#       END IF
#       #No.MOD-AA0086  --End  
#
##FUN-AB0066 --begin--
#       IF NOT s_chk_ware(b_imn.imn04) THEN 
#          LET g_totsuccess = 'N'
#          RETURN 
#       END IF 
#       
#       IF NOT s_chk_ware(b_imn.imn15) THEN 
#          LET g_totsuccess = 'N'
#          RETURN 
#       END IF 
##FUN-AB0066 --end--
#         SELECT img09 INTO l_img09 FROM img_file
#           WHERE img01=b_imn.imn03 AND img02=g_imm.imm08
#           AND img03 =' ' AND img04 = ' '
# 
#         CALL s_umfchk(b_imn.imn03,
#                          b_imn.imn09,l_img09)
#                       RETURNING l_cnt,l_imm08_fac
#              IF l_cnt = 1 THEN
#                 LET l_imm08_fac = 1
#              END IF
#          LET b_imn.imn10 = b_imn.imn10 * l_imm08_fac
#          LET b_imn.imn10 = s_digqty(b_imn.imn10,b_imn.imn09)   #No.FUN-BB0086
# 
#       CALL s_t325_s(b_imn.imn03,g_imm.imm08,' ',' ',
#                     -1,b_imn.imn10,b_imn.imn09,g_imm.imm11,b_imn.imn02,
#                     g_imm.imm12,b_imn.imn28)   #No.b037         #bugno:6810 modify    #No.TQC-760153 add imn28
#       IF g_success='N' THEN
#          LET g_totsuccess="N"
#          LET g_success="Y"
#          CONTINUE FOREACH   #No.FUN-6C0083
#       END IF
#       CALL s_t325_s(b_imn.imn03,b_imn.imn15,b_imn.imn16,b_imn.imn17,
#                     +1,b_imn.imn22,b_imn.imn20,g_imm.imm11,b_imn.imn02,
#                     g_imm.imm12,b_imn.imn28)   #No.b037         #bugno:6810 modify    #No.TQC-760153 add imn28
#       IF g_success='N' THEN 
#          LET g_totsuccess="N"
#          LET g_success="Y"
#          CONTINUE FOREACH   #No.FUN-6C0083
#       END IF
#      IF g_sma.sma115='Y' THEN
#         CALL t325_upd_s(g_imm.imm08,' ',' ',
#                         b_imn.imn43,b_imn.imn44,b_imn.imn45,
#                         b_imn.imn40,b_imn.imn41,b_imn.imn42,
#                         g_imm.imm11,b_imn.imn02,1)
#         IF g_success='N' THEN
#           LET g_totsuccess="N"
#           LET g_success="Y"
#           CONTINUE FOREACH   #No.FUN-6C0083
#         END IF
#         CALL t325_upd_t(b_imn.imn15,b_imn.imn16,b_imn.imn17,
#                         b_imn.imn43,b_imn.imn44,b_imn.imn45,
#                         b_imn.imn40,b_imn.imn41,b_imn.imn42,
#                         g_imm.imm11,b_imn.imn02,1)
#         IF g_success='N' THEN
#           LET g_totsuccess="N"
#           LET g_success="Y"
#           CONTINUE FOREACH   #No.FUN-6C0083
#         END IF
#      END IF
#       UPDATE imn_file
#         SET imn24='Y',
#             imn25=g_user,
#             imn26=g_today
#        WHERE imn01=b_imn.imn01
#          AND imn02=b_imn.imn02
# 
#       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#          LET g_showmsg = b_imn.imn01,"/",b_imn.imn02
#          CALL s_errmsg('imn01,imn02',g_showmsg,'upd imn',SQLCA.SQLCODE,1)
#          LET g_success='N'
#       END IF
#   END FOREACH
# 
#   IF g_totsuccess="N" THEN
#      LET g_success="N"
#   END IF
#   CALL s_showmsg()   #No.FUN-6C0083
# 
#   IF g_success='Y' THEN
#      UPDATE imm_file SET imm03 = 'Y'
#       WHERE imm01 = g_imm.imm01 
#      IF SQLCA.sqlcode THEN
#         CALL s_errmsg('imm01',g_imm.imm01,'up imm_file',SQLCA.sqlcode,1)
#         LET g_success = 'N'
#      END IF
#   END IF
# 
#   IF g_success = 'Y' THEN
#      COMMIT WORK
#      CALL cl_flow_notify(g_imm.imm01,'S')
#      CALL cl_cmmsg(4)
#   ELSE
#      ROLLBACK WORK
#      CALL cl_rbmsg(4)
#   END IF
# 
#   SELECT imm03 INTO g_imm.imm03 FROM imm_file WHERE imm01 = g_imm.imm01 
#   DISPLAY BY NAME g_imm.imm03
# 
#   IF g_success='Y' THEN
#      CALL t325_b_fill(' 1=1')
#   END IF
# 
#   IF g_imm.imm03 = "N" THEN
#      DECLARE t325_s1_c2 CURSOR FOR SELECT * FROM imn_file
#        WHERE imn01 = g_imm.imm01 
# 
#      LET g_imm01 = ""
#      LET g_success = "Y"
#      BEGIN WORK
# 
#      FOREACH t325_s1_c2 INTO b_imn.*
#         IF STATUS THEN
#            EXIT FOREACH
#         END IF
# 
#         IF g_sma.sma115 = 'Y' THEN
#            IF g_ima906 = '2' THEN  #子母單位
#               LET g_unit_arr[1].unit= b_imn.imn30
#               LET g_unit_arr[1].fac = b_imn.imn31
#               LET g_unit_arr[1].qty = b_imn.imn32
#               LET g_unit_arr[2].unit= b_imn.imn33
#               LET g_unit_arr[2].fac = b_imn.imn34
#               LET g_unit_arr[2].qty = b_imn.imn35
#               CALL s_dismantle(g_imm.imm01,b_imn.imn02,g_imm.imm12,
#                                b_imn.imn03,b_imn.imn04,b_imn.imn05,
#                                b_imn.imn06,g_unit_arr,g_imm01)
#                      RETURNING g_imm01
#            END IF
#         END IF
#      END FOREACH
# 
#      IF g_success = "Y" AND NOT cl_null(g_imm01) THEN
#         COMMIT WORK
#         LET g_msg="aimt324 '",g_imm01,"'"
#         CALL cl_cmdrun_wait(g_msg)
#      ELSE
#         ROLLBACK WORK
#      END IF
#   END IF
# 
#END FUNCTION
# 
#FUNCTION t325_w()  #撥出確認
#   DEFINE l_cnt       LIKE type_file.num10   #No.MOD-610096 add  #No.FUN-690026 INTEGER
#   DEFINE l_imm08_fac LIKE imn_file.imn21    #No.MOD-610096 add
#   DEFINE l_img09     LIKE img_file.img09    #No.MOD-610096 add
# 
# 
#   IF s_shut(0) THEN RETURN END IF
#   #TQC-D40026--mark--str--
#   ##FUN-BC0062 ---------Begin--------
#   ##當成本計算方式ccz28選擇'6'，過帳還原時控制不可過帳還原
#   #   SELECT ccz_file.* INTO g_ccz.* FROM ccz_file WHERE ccz00='0'
#   #   IF g_ccz.ccz28  = '6' AND g_imm.imm04 = 'Y' THEN
#   #      CALL cl_err('','apm-936',1)
#   #      RETURN
#   #   END IF
#   ##FUN-BC0062 ---------End----------
#   #TQC-D40026--mark--end--
#    SELECT * INTO g_imm.* FROM imm_file WHERE imm01=g_imm.imm01 
#   IF cl_null(g_imm.imm01) THEN CALL cl_err('',-400,0)   RETURN END IF
#   IF g_imm.imm03 = 'Y' THEN CALL cl_err('','aim-100',0) RETURN END IF
#   IF g_imm.imm04 = 'N' THEN CALL cl_err('','aim-003',0) RETURN END IF     #No.TQC-750041
#   IF g_imm.imm04 = 'X' THEN CALL cl_err('','9024',0)    RETURN END IF #no.6810 add
# 
# 
#   IF NOT cl_null(g_sma.sma53) AND g_imm.imm02 <= g_sma.sma53 THEN
#      CALL cl_err('','mfg9999',0)
#      RETURN
#   END IF
#   CALL s_yp(g_imm.imm02) RETURNING g_yy,g_mm # bugno:6810 modify
#   IF g_yy > g_sma.sma51 THEN                  # 與目前會計年度,期間比較
#      CALL cl_err(g_yy,'mfg6090',0) RETURN
#   ELSE IF g_yy = g_sma.sma51 AND g_mm > g_sma.sma52  THEN    #No.MOD-8C0293
#           CALL cl_err(g_mm,'mfg6091',0) RETURN
#        END IF
#   END IF
# 
#   IF NOT cl_confirm('aap-224') THEN RETURN END IF
# 
#   DECLARE t325_w1_c CURSOR FOR SELECT *
#                       FROM imn_file WHERE imn01=g_imm.imm01 
#   BEGIN WORK
# 
#    OPEN t325_cl USING g_imm.imm01
#    IF STATUS THEN
#       CALL cl_err("OPEN t325_cl:", STATUS, 1)
#       CLOSE t325_cl
#       ROLLBACK WORK
#       RETURN
#    END IF
#    FETCH t325_cl INTO g_imm.*
#    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_imm.imm01,SQLCA.sqlcode,0)
#       CLOSE t325_cl
#       ROLLBACK WORK
#       RETURN
#    END IF
#    LET g_success = 'Y'
#  
#    CALL s_showmsg_init()   #No.FUN-6C0083 
# 
#    FOREACH t325_w1_c INTO b_imn.*
#         IF STATUS THEN EXIT FOREACH END IF
#         IF cl_null(b_imn.imn04) THEN CONTINUE FOREACH END IF
#         MESSAGE '_w  read parts:',b_imn.imn03
# 
#         CALL t325_rev(b_imn.imn03,b_imn.imn04,b_imn.imn05,b_imn.imn06,
#                       +1,b_imn.imn10,b_imn.imn09,g_imm.imm01,b_imn.imn02,g_imm.imm02)
#         IF g_success='N' THEN 
#            LET g_totsuccess="N"
#            LET g_success="Y"
#            CONTINUE FOREACH   #No.FUN-6C0083
#         END IF
#         #No.MOD-AA0086  --Begin
#         CALL t325_del_tlfs(b_imn.imn04,b_imn.imn05,b_imn.imn06,-1,g_imm.imm01,g_imm.imm02)
#         IF g_success='N' THEN 
#            LET g_totsuccess="N"
#            LET g_success="Y"
#            CONTINUE FOREACH   #No.FUN-6C0083
#         END IF
#         #No.MOD-AA0086  --End  
#
#         SELECT img09 INTO l_img09 FROM img_file
#           WHERE img01=b_imn.imn03 AND img02=g_imm.imm08
#           AND img03 =' ' AND img04 = ' '
# 
#         CALL s_umfchk(b_imn.imn03,
#                          b_imn.imn09,l_img09)
#                       RETURNING l_cnt,l_imm08_fac
#              IF l_cnt = 1 THEN
#                 LET l_imm08_fac = 1
#              END IF
#          LET b_imn.imn10 = b_imn.imn10 * l_imm08_fac
#          LET b_imn.imn10 = s_digqty(b_imn.imn10,b_imn.imn09)   #No.FUN-BB0086
# 
#         CALL t325_rev(b_imn.imn03,g_imm.imm08,' '        ,' '        ,
#                       -1,b_imn.imn10,b_imn.imn09,g_imm.imm01,b_imn.imn02,g_imm.imm02)
#         IF g_success='N' THEN 
#            LET g_totsuccess="N"
#            LET g_success="Y"
#            CONTINUE FOREACH   #No.FUN-6C0083
#         END IF
#        IF g_sma.sma115='Y' THEN
#           CALL t325_upd_s(g_imm.imm08,' ',' ',
#                           b_imn.imn43,b_imn.imn44,b_imn.imn45,
#                           b_imn.imn40,b_imn.imn41,b_imn.imn42,
#                           g_imm.imm01,b_imn.imn02,2)
#           IF g_success='N' THEN 
#              LET g_totsuccess="N"
#              LET g_success="Y"
#              CONTINUE FOREACH   #No.FUN-6C0083
#           END IF
#           SELECT ima906 INTO g_ima906 FROM ima_file WHERE ima01=b_imn.imn03
#           IF g_ima906 MATCHES '[23]' THEN
#              DELETE FROM tlff_file
#               WHERE tlff902 =g_imm.imm08
#                 AND tlff903 =' '
#                 AND tlff904 =' '
#                 AND tlff905 =g_imm.imm01
#                 AND tlff906 =b_imn.imn02
#                 AND tlff907 =1
#              IF STATUS THEN
#                 CALL s_errmsg('tlff902',g_imm.imm08,'del tlf',STATUS,1)
#                 LET g_success = 'N' CONTINUE FOREACH
#              END IF
#              IF SQLCA.SQLERRD[3]=0 THEN
#                 CALL s_errmsg('','','del tlf','aap-161',1)
#                 LET g_success = 'N' CONTINUE FOREACH
#              END IF
#           END IF
#           CALL t325_upd_t(b_imn.imn04,b_imn.imn05,b_imn.imn06,
#                           b_imn.imn33,b_imn.imn34,b_imn.imn35,
#                           b_imn.imn30,b_imn.imn31,b_imn.imn32,
#                           g_imm.imm01,b_imn.imn02,2)
#           IF g_success='N' THEN 
#              LET g_totsuccess="N"
#              LET g_success="Y"
#              CONTINUE FOREACH   #No.FUN-6C0083
#           END IF
#           IF g_ima906 MATCHES '[23]' THEN
#              DELETE FROM tlff_file
#               WHERE tlff902 =b_imn.imn04
#                 AND tlff903 =b_imn.imn05
#                 AND tlff904 =b_imn.imn06
#                 AND tlff905 =g_imm.imm01
#                 AND tlff906 =b_imn.imn02
#                 AND tlff907 =-1
#              IF STATUS THEN
#                 LET g_showmsg = b_imn.imn04,"/",b_imn.imn05,"/",b_imn.imn06,"/",g_imm.imm01,"/",b_imn.imn02,"/",-1
#                 CALL s_errmsg('tlff902,tlff903,tlff904,tlff905,tlff906,tlff907',g_showmsg,'del tlf',STATUS,1)
#                 LET g_success = 'N' CONTINUE FOREACH
#              END IF
#              IF SQLCA.SQLERRD[3]=0 THEN
#                 CALL s_errmsg('','','del tlf','aap-161',1)
#                 LET g_success = 'N' CONTINUE FOREACH
#              END IF
#           END IF
#        END IF
#        #FUN-AC0074--begin--add-----
#        CALL s_updsie_unsie(b_imn.imn01,b_imn.imn02,'4')
#        IF g_success='N' THEN
#           LET g_totsuccess="N"
#           LET g_success="Y"
#           CONTINUE FOREACH
#        END IF
#        #FUN-AC0074--end--add----
#     END FOREACH
# 
#     IF g_totsuccess="N" THEN
#        LET g_success="N"
#     END IF
#     CALL s_showmsg()   #No.FUN-6C0083
# 
#     IF g_success = 'Y' THEN  #No.+052 010404 by plum
#        UPDATE imm_file
#           SET imm04 = 'N',
#               imm11 = '',       #bugno:6810 add
#               imm12 = NULL,     #bugno:6810 add
#               imm13 = ''        #bugno:6810 add
#         WHERE imm01 = g_imm.imm01
#        IF SQLCA.sqlcode THEN
#           CALL s_errmsg('imm01',g_imm.imm01,'up imm_file',SQLCA.sqlcode,1)
#           LET g_success = 'N'
#        END IF
#     END IF
#     IF g_success = 'Y'
#        THEN
#            COMMIT WORK
#            CALL cl_cmmsg(4)
#        ELSE
#            ROLLBACK WORK
#            CALL cl_rbmsg(4)
#     END IF
#   SELECT imm04,imm11,imm12,imm13
#     INTO g_imm.imm04,g_imm.imm11,g_imm.imm12,g_imm.imm13
#     FROM imm_file WHERE imm01 = g_imm.imm01
#   DISPLAY BY NAME g_imm.imm04,g_imm.imm11,g_imm.imm12,g_imm.imm13
#END FUNCTION
# 
##撥入確認還原
#FUNCTION t325_z()
#   DEFINE l_cnt       LIKE type_file.num10   #No.MOD-610096 add  #No.FUN-690026 INTEGER
#   DEFINE l_imm08_fac LIKE imn_file.imn21    #No.MOD-610096 add
#   DEFINE l_img09     LIKE img_file.img09    #No.MOD-610096 add
# 
# 
#   IF s_shut(0) THEN RETURN END IF
#   SELECT * INTO g_imm.* FROM imm_file WHERE imm01=g_imm.imm01 
#   IF cl_null(g_imm.imm01) THEN CALL cl_err('',-400,0)   RETURN END IF
#   IF g_imm.imm04 = 'N' THEN CALL cl_err('','aim-003',0) RETURN END IF #no.6810 add    #No.TQC-750041
#   IF g_imm.imm04 = 'X' THEN CALL cl_err('','9024',0)    RETURN END IF #no.6810 add
#   IF g_imm.imm03 = 'N' THEN CALL cl_err('','aim-307',0) RETURN END IF
# 
#   #TQC-D40026--mark--str--
#   #FUN-BC0062 ---------Begin--------
#   ##當成本計算方式ccz28選擇'6'，過帳還原時控制不可過帳還原 
#   #   SELECT ccz_file.* INTO g_ccz.* FROM ccz_file WHERE ccz00='0'
#   #   IF g_ccz.ccz28  = '6' THEN
#   #      CALL cl_err('','apm-936',1)
#   #      RETURN
#   #   END IF
#   ##FUN-BC0062 ---------End---------- 
#   #TQC-D40026--mark--end--
# 
#   IF NOT cl_null(g_sma.sma53) AND g_imm.imm12 <= g_sma.sma53 THEN
#           CALL cl_err('','mfg9999',0) RETURN
#   END IF
#   CALL s_yp(g_imm.imm12) RETURNING g_yy,g_mm
#   IF g_yy > g_sma.sma51  THEN      #與目前會計年度,期間比較
#       CALL cl_err(g_yy,'mfg6090',0) RETURN
#   ELSE IF g_yy = g_sma.sma51 AND g_mm > g_sma.sma52     #No.MOD-8C0293
#             THEN CALL cl_err(g_mm,'mfg6091',0) RETURN
#             END IF
#        END IF
#   IF NOT cl_confirm('aap-224') THEN RETURN END IF
#   DECLARE t325_z1_c CURSOR FOR SELECT *
#                       FROM imn_file WHERE imn01=g_imm.imm01 
#   BEGIN WORK
# 
#    OPEN t325_cl USING g_imm.imm01
#    IF STATUS THEN
#       CALL cl_err("OPEN t325_cl:", STATUS, 1)
#       CLOSE t325_cl
#       ROLLBACK WORK
#       RETURN
#    END IF
#    FETCH t325_cl INTO g_imm.*
#    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_imm.imm01,SQLCA.sqlcode,0)
#       CLOSE t325_cl
#       ROLLBACK WORK
#       RETURN
#    END IF
#    LET g_success = 'Y'
# 
#    CALL s_showmsg_init()   #No.FUN-6C0083 
# 
#    FOREACH t325_z1_c INTO b_imn.*
#         IF STATUS THEN EXIT FOREACH END IF
#         IF cl_null(b_imn.imn04) THEN CONTINUE FOREACH END IF
#
#         SELECT img09 INTO l_img09 FROM img_file
#           WHERE img01=b_imn.imn03 AND img02=g_imm.imm08
#           AND img03 =' ' AND img04 = ' '
# 
#         CALL s_umfchk(b_imn.imn03,
#                            b_imn.imn09,l_img09)
#                       RETURNING l_cnt,l_imm08_fac
#              IF l_cnt = 1 THEN
#                 LET l_imm08_fac = 1
#              END IF
#          LET b_imn.imn10 = b_imn.imn10 * l_imm08_fac
#          LET b_imn.imn10 = s_digqty(b_imn.imn10,b_imn.imn09)   #No.FUN-BB0086
# 
#         CALL t325_rev(b_imn.imn03,g_imm.imm08,' '        ,' '        ,
#                       +1,b_imn.imn10,b_imn.imn09,g_imm.imm11,b_imn.imn02,g_imm.imm12)
#         IF g_success='N' THEN 
#            LET g_totsuccess="N"
#            LET g_success="Y"
#            CONTINUE FOREACH   #No.FUN-6C0083
#         END IF
#         CALL t325_rev(b_imn.imn03,b_imn.imn15,b_imn.imn16,b_imn.imn17,
#                       -1,b_imn.imn22,b_imn.imn20,g_imm.imm11,b_imn.imn02,g_imm.imm12 )
#         IF g_success='N' THEN 
#            LET g_totsuccess="N"
#            LET g_success="Y"
#            CONTINUE FOREACH   #No.FUN-6C0083
#         END IF
#         #No.MOD-AA0086  --Begin
#         CALL t325_del_tlfs(b_imn.imn15,b_imn.imn16,b_imn.imn17,+1,g_imm.imm11,g_imm.imm12)
#         IF g_success='N' THEN 
#            LET g_totsuccess="N"
#            LET g_success="Y"
#            CONTINUE FOREACH   #No.FUN-6C0083
#         END IF
#
#         #delete 拨入方的rvbs_file资料
#         CALL t325_del_rvbs()
#         IF g_success='N' THEN 
#            LET g_totsuccess="N"
#            LET g_success="Y"
#            CONTINUE FOREACH   #No.FUN-6C0083
#         END IF
#         #No.MOD-AA0086  --End  
#        IF g_sma.sma115='Y' THEN
#           CALL t325_upd_s(b_imn.imn15,b_imn.imn16,b_imn.imn17,
#                           b_imn.imn43,b_imn.imn44,b_imn.imn45,
#                           b_imn.imn40,b_imn.imn41,b_imn.imn42,
#                           g_imm.imm11,b_imn.imn02,2)
#           IF g_success='N' THEN 
#              LET g_totsuccess="N"
#              LET g_success="Y"
#              CONTINUE FOREACH   #No.FUN-6C0083
#           END IF
#           SELECT ima906 INTO g_ima906 FROM ima_file WHERE ima01=b_imn.imn03
#           IF g_ima906 MATCHES '[23]' THEN
#              DELETE FROM tlff_file
#               WHERE tlff902 =b_imn.imn15
#                 AND tlff903 =b_imn.imn16
#                 AND tlff904 =b_imn.imn17
#                 AND tlff905 =g_imm.imm11
#                 AND tlff906 =b_imn.imn02
#                 AND tlff907 =1
#              IF STATUS THEN
#                 LET g_showmsg = b_imn.imn15,"/",b_imn.imn16,"/",b_imn.imn17,"/",g_imm.imm11,"/",b_imn.imn02,"/",1
#                 LET g_success = 'N' CONTINUE FOREACH
#              END IF
#              IF SQLCA.SQLERRD[3]=0 THEN
#                 CALL s_errmsg('','','del tlf','aap-161',1)
#                 LET g_success = 'N' CONTINUE FOREACH 
#              END IF
#           END IF
#           CALL t325_upd_t(g_imm.imm08,' ',' ',
#                           b_imn.imn43,b_imn.imn44,b_imn.imn45,
#                           b_imn.imn40,b_imn.imn41,b_imn.imn42,
#                           g_imm.imm11,b_imn.imn02,2)
#           IF g_success='N' THEN 
#              LET g_totsuccess="N"
#              LET g_success="Y"
#              CONTINUE FOREACH   #No.FUN-6C0083
#           END IF
#           IF g_ima906 MATCHES '[23]' THEN
#              DELETE FROM tlff_file
#               WHERE tlff902 =g_imm.imm08
#                 AND tlff903 =' '
#                 AND tlff904 =' '
#                 AND tlff905 =g_imm.imm11
#                 AND tlff906 =b_imn.imn02
#                 AND tlff907 =-1
#              IF STATUS THEN
#                 CALL s_errmsg('tlff902',g_imm.imm08,'del tlf',STATUS,1)
#                 LET g_success = 'N' 
#                 CONTINUE FOREACH
#              END IF
#              IF SQLCA.SQLERRD[3]=0 THEN
#                 CALL s_errmsg('','','del tlf','aap-161',1) 
#                 LET g_success = 'N' 
#                 CONTINUE FOREACH
#              END IF
#           END IF
#        END IF
#         UPDATE imn_file
#           SET imn24='N',
#         #FUN-D20059--str---
#         #     imn25='',
#         #     imn26=''
#               imn25=g_user,
#               imn26=g_today
#         #FUN-D20059--end---
#          WHERE imn01=b_imn.imn01
#            AND imn02=b_imn.imn02
#         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#            LET g_showmsg = b_imn.imn01,"/",b_imn.imn02
#            CALL s_errmsg('imn01,imn02',g_showmsg,'upd imn',SQLCA.SQLCODE,1)
#            LET g_success='N'
#         END IF
#     END FOREACH
# 
#     IF g_totsuccess="N" THEN
#        LET g_success="N"
#     END IF
#     CALL s_showmsg()   #No.FUN-6C0083
# 
#     IF g_success = 'Y' THEN
#        UPDATE imm_file SET imm03 = 'N' WHERE imm01 = g_imm.imm01 
#        IF SQLCA.sqlcode THEN
#           CALL s_errmsg('imm01',g_imm.imm01,'up imm_file',SQLCA.sqlcode,1)
#           LET g_success = 'N'
#        END IF
#     END IF
#     IF g_success = 'Y'
#        THEN
#            COMMIT WORK
#            CALL cl_cmmsg(4)
#        ELSE
#            ROLLBACK WORK
#            CALL cl_rbmsg(4)
#     END IF
#   SELECT imm03 INTO g_imm.imm03 FROM imm_file WHERE imm01 = g_imm.imm01 
#   DISPLAY BY NAME g_imm.imm03
# 
#   IF g_success='Y' THEN
#      CALL t325_b_fill(' 1=1')
#   END IF
# 
#END FUNCTION
#}
# 
#FUNCTION t325_rev(p_part,p_ware,p_loc,p_lot,p_type,p_qty,p_unit,p_no,p_item,p_date)
#    DEFINE #p_part,p_ware,p_loc,p_lot VARCHAR(20), #TQC-5C0071
#           p_part     LIKE img_file.img01, #TQC-5C0071
#           p_ware     LIKE img_file.img02, #TQC-5C0071
#           p_loc      LIKE img_file.img03, #TQC-5C0071
#           p_lot      LIKE img_file.img04, #TQC-5C0071
#           p_type     LIKE type_file.num5,  #-1.出 1.入  #No.FUN-690026 SMALLINT
#           p_unit     LIKE img_file.img09, #TQC-5C0071
#           p_qty      LIKE img_file.img10, #MOD-530179
#           p_no       LIKE imm_file.imm01,
#           p_item     LIKE imn_file.imn02,
#           p_date     LIKE imm_file.imm02,
#           l_date     LIKE imm_file.imm02,   #No.MOD-750088 add
#           l_img      RECORD LIKE img_file.*,
#           l_ima01    LIKE ima_file.ima01     #No.TQC-930155
#    DEFINE la_tlf     DYNAMIC ARRAY OF RECORD LIKE tlf_file.*  #NO.FUN-8C0131 
#    DEFINE l_sql      STRING                                   #NO.FUN-8C0131 
#    DEFINE l_i        LIKE type_file.num5                      #NO.FUN-8C0131
# 
#    INITIALIZE l_img.* TO NULL
#    LET g_forupd_sql = "SELECT img_file.* FROM img_file ",                                                                            
#                       " WHERE img01= ? AND img02=  ? ",                                                                            
#                       "   AND img03= ? AND img04=  ? FOR UPDATE "                                                                  
#    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
#    DECLARE img_lock CURSOR FROM g_forupd_sql                                                                                       
#    OPEN img_lock USING p_part,p_ware,p_loc,p_lot                                                                                   
#    IF STATUS THEN                                                                                                                  
#       CALL cl_err("img_lock fail:", STATUS, 1)                                                                                     
#       LET g_success = 'N'                                                                                                          
#       RETURN                                                                                                                       
#    END IF                                                                                                                          
#    FETCH img_lock INTO l_img.*                                                                                             
#    IF STATUS THEN                                                                                                                  
#       CALL cl_err("sel img_file fail:", STATUS, 1)                                                                                 
#       LET g_success = 'N'                                                                                                          
#       RETURN                                                                                                                       
#    END IF                                                                                                                          
# 
#    IF p_type='-1' THEN
#       IF g_prog = 'aimt326' THEN
#          LET l_date = g_imm.imm12
#       ELSE
#          LET l_date = g_imm.imm02
#       ENd IF
# 
#       IF NOT s_stkminus(p_part,p_ware,p_loc,p_lot,
#                        #b_imn.imn10,1,g_imm.imm02,g_sma.sma894[4,4]) THEN
#                        #b_imn.imn10,1,l_date,g_sma.sma894[4,4]) THEN    #FUN-D30024--mark
#                         b_imn.imn10,1,l_date) THEN                      #FUN-D30024--add
#          LET g_success='N'
#          RETURN
#       END IF
#    END IF
# 
#    CALL s_upimg(p_part,p_ware,p_loc,p_lot,p_type,p_qty,p_date,'','','','',       #FUN-8C0084
#               # '','','','','','','','','','','','','','')                       #No.MOD-AA0086
#                 p_no,p_item,'','','','','','','','','','','','')                 #No.MOD-AA0086
# 
#    IF g_success='N' THEN RETURN END IF #No.+052 010404 by plum
#    LET g_forupd_sql = "SELECT ima01 FROM ima_file WHERE ima01= ?  FOR UPDATE "   
#    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
#    DECLARE ima_lock CURSOR FROM g_forupd_sql
#    OPEN ima_lock USING l_img.img01          
#    IF STATUS THEN                            
#       CALL cl_err('lock ima fail',STATUS,1)   
#       LET g_success='N'              
#       RETURN                          
#    END IF                              
#    FETCH ima_lock INTO l_ima01          
#    IF STATUS THEN                        
#       CALL cl_err('sel ima_file fail',STATUS,1)
#       LET g_success='N'                    
#       RETURN                                
#    END IF                                    
#    #No.TQC-930155-------------end--------------
#    #TQC-C50236--mark--str--
#    #CALL s_udima(l_img.img01,l_img.img23,l_img.img24,p_qty*l_img.img21,
#    #             TODAY,p_type) RETURNING g_i
#    #IF g_success='N' THEN RETURN END IF #No.+052 010404 by plum
#    #TQC-C50236--mark--end--
#
#  ##NO.FUN-8C0131   add--begin   
#    LET l_sql =  " SELECT  * FROM tlf_file ", 
#                 "  WHERE  tlf902 = '",p_ware,"'",
#                 "    AND tlf903='",p_loc,"' AND tlf904='",p_lot,"'",
#                 "   AND tlf905 ='",p_no,"' AND tlf906 ='",p_item,"' AND tlf907 =",p_type*-1,""     
#    DECLARE t325_u_tlf_c CURSOR FROM l_sql
#    LET l_i = 0 
#    CALL la_tlf.clear()
#    FOREACH t325_u_tlf_c INTO g_tlf.*
#       LET l_i = l_i + 1
#       LET la_tlf[l_i].* = g_tlf.*
#    END FOREACH     
#
#  ##NO.FUN-8C0131   add--end  
#    DELETE FROM tlf_file
#           WHERE tlf902 =p_ware
#             AND tlf903 =p_loc
#             AND tlf904 =p_lot
#             AND tlf905 =p_no
#             AND tlf906 =p_item
#             AND tlf907 =p_type*-1
#    IF STATUS THEN
#       CALL cl_err3("del","tlf_file",p_ware,"",STATUS,"","del tlf",1)   #NO.FUN-640266 #No.FUN-660156
#       LET g_success = 'N' RETURN
#    END IF
#    IF SQLCA.SQLERRD[3]=0 THEN
#       CALL cl_err3("del","tlf_file",p_ware,"","aap-161","","del tlf",1)   #No.FUN-660156
#       LET g_success = 'N' RETURN
#    END IF
#  ##NO.FUN-8C0131   add--begin
#       FOR l_i = 1 TO la_tlf.getlength()
#          LET g_tlf.* = la_tlf[l_i].*
#          IF NOT s_untlf1('') THEN 
#             LET g_success='N' RETURN
#          END IF 
#       END FOR       
#  ##NO.FUN-8C0131   add--end 
#END FUNCTION
#DEV-D30046 搬移至aimt325_sub.4gl --mark--end
 
#=================================================#
# Descriptions...: 兩階段倉庫調撥作業copy功能     #
#                  將出至境外倉出貨單可轉成調撥單 #
# Date & Author..: 01/04/17 By Mandy              #
#=================================================#
FUNCTION aimt325c()
  DEFINE l_prog_tmp  STRING
  DEFINE li_result   LIKE type_file.num5                        #No.FUN-550029  #No.FUN-690026 SMALLINT
 
    INITIALIZE l_imm.* TO NULL
    INITIALIZE l_imm_t.* TO NULL
    INITIALIZE l_imm_o.* TO NULL
 
    LET p_row = 5 LET p_col = 11
    OPEN WINDOW t325c_w AT p_row,p_col              #顯示畫面
         WITH FORM "aim/42f/aimt325c"
         ATTRIBUTE (STYLE = g_win_style)
 
    CALL cl_ui_locale("aimt325c")
 
 
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    INITIALIZE l_imm.* TO NULL
    INITIALIZE l_img.* TO NULL
    LET l_imm_o.* = l_imm.*
    WHILE TRUE
        LET l_imm.imm02  =g_today
        LET l_imm.imm04  = 'N'
        LET l_imm.imm03  = 'N'
        LET l_imm.imm10  = '2'
        LET l_imm.immuser=g_user
        LET l_imm.immgrup=g_grup
        LET l_imm.immdate=g_today
        LET l_imm.imm14=g_grup #FUN-680006
        LET l_imm.immplant = g_plant #FUN-980004 add
        LET l_imm.immlegal = g_legal #FUN-980004 add
        LET g_success='Y'
        CALL t325c_i("a")                #輸入單頭
        IF INT_FLAG THEN
           INITIALIZE l_imm.* TO NULL
           INITIALIZE l_img.* TO NULL
           CLOSE WINDOW t325c_w
           LET INT_FLAG = 0
           LET g_success='N'
           RETURN        #MOD-590302
        END IF
        IF l_imm.imm01 IS NULL THEN CONTINUE WHILE END IF
        BEGIN WORK #No:7857
        CALL s_auto_assign_no("aim",l_imm.imm01,l_imm.imm02,"4","imm_file","imm01",
                  "","","")
             RETURNING li_result,l_imm.imm01
        IF (NOT li_result) THEN
             CONTINUE WHILE
        END IF
        DISPLAY BY NAME l_imm.imm01
        SELECT imm01 INTO l_imm.imm01 FROM imm_file WHERE imm01 = l_imm.imm01 
        LET l_imm_t.* = l_imm.*
        CALL t325c_b()   #給調撥作業單身值
        LET l_imm.immoriu = g_user      #No.FUN-980030 10/01/04
        LET l_imm.immorig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO imm_file VALUES (l_imm.*)
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("ins","imm_file",l_imm.imm01,"",SQLCA.sqlcode,"",
                         "ins imm",1)   #NO.FUN-640266 #No.FUN-660156
            CONTINUE WHILE
        ELSE
        END IF
      IF g_success='Y' THEN
         CALL cl_cmmsg(1)
         COMMIT WORK
      ELSE
         CALL cl_rbmsg(1)
         ROLLBACK WORK
      END IF
        EXIT WHILE
    END WHILE
    CLOSE WINDOW t325c_w
    LET g_argv1 = l_imm.imm01
END FUNCTION
 
FUNCTION t325c_i(p_cmd)
  DEFINE p_cmd           LIKE type_file.chr1    #a:輸入 u:更改  #No.FUN-690026 VARCHAR(1)
  DEFINE l_flag          LIKE type_file.chr1    #判斷必要欄位是否有輸入  #No.FUN-690026 VARCHAR(1)
  DEFINE l_n             LIKE type_file.num5    #No.FUN-690026 SMALLINT
  DEFINE l_oga           RECORD LIKE oga_file.*
  DEFINE li_result       LIKE type_file.num5    #No.FUN-550029  #No.FUN-690026 SMALLINT
 
    INPUT BY NAME
	l_imm.imm01,l_imm.imm02,l_imm.imm08,l_imm.imm09,
        l_img.t_img02,l_img.t_img03,l_img.t_img04
           WITHOUT DEFAULTS
 
    BEFORE INPUT
        CALL cl_set_docno_format("imm01")
 
        AFTER FIELD imm01
            IF NOT cl_null(l_imm.imm01) THEN
               CALL s_check_no("aim",l_imm.imm01,l_imm_t.imm01,"4","imm_file","imm01","")
                    RETURNING li_result,l_imm.imm01
               DISPLAY BY NAME l_imm.imm01   #TQC-6A0034 modify g_imm -> l_imm
               IF (NOT li_result) THEN
                    NEXT FIELD imm01
               END IF
           END IF
 
        AFTER FIELD imm02
	   IF NOT cl_null(l_imm.imm02) THEN   #MOD-740197 g_imm.imm02 -> l_imm.imm02
	      IF g_sma.sma53 IS NOT NULL AND l_imm.imm02 <= g_sma.sma53 THEN
	         CALL cl_err('','mfg9999',0) NEXT FIELD imm02
	      END IF
              CALL s_yp(l_imm.imm02) RETURNING g_yy,g_mm
              IF (g_yy*12+g_mm)>(g_sma.sma51*12+g_sma.sma52)THEN #不可大於現行年月
                 CALL cl_err('','mfg6091',0) NEXT FIELD imm02
              END IF
           END IF
 
        AFTER FIELD imm08
	        IF NOT cl_null(l_imm.imm08) THEN  #MOD-740197 g_imm.imm08 -> l_imm.imm08
              CALL t325_imm08(l_imm.imm08)   #MOD-740197 g_imm.imm08 -> l_imm.imm08
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('sel imd:',g_errno,1) NEXT FIELD imm08
              END IF
              #No.FUN-AA0049--begin
              IF NOT s_chk_ware(l_imm.imm08) THEN
                 NEXT FIELD imm08
              END IF 
              #No.FUN-AA0049--end              
           END IF
 
        AFTER FIELD imm09
	   IF NOT cl_null(l_imm.imm09) THEN
              SELECT COUNT(*) INTO l_n FROM imm_file WHERE imm09 = l_imm.imm09 
              IF l_n > 0 THEN
                 #此出貨單重覆撥出!
                 CALL cl_err(l_imm.imm09,'aim-327',0)
                 NEXT FIELD imm09
              END IF
              CALL t325c_imm09() #檢查出貨單號且出貨單號屬於'3'出至境外倉
              IF NOT cl_null(g_errno) THEN
                  CALL cl_err(l_imm.imm09,g_errno,0)
                  NEXT FIELD imm09
              END IF
           END IF
#------目的倉庫------------------------------------------------
        AFTER FIELD t_img02 #倉庫
         IF NOT cl_null(l_img.t_img02) THEN
            #No.FUN-AA0049--begin
            IF NOT s_chk_ware(l_img.t_img02) THEN
               NEXT FIELD t_img02
            END IF 
            #No.FUN-AA0049--end            
            CALL  s_stkchk(l_img.t_img02,'A') RETURNING l_code
            IF NOT l_code THEN
                #無此倉庫或性質不符!
                CALL cl_err(l_img.t_img02,'mfg1100',1)
                NEXT FIELD t_img02
            END IF
            #====>
            CALL  s_swyn(l_img.t_img02) RETURNING sn1,sn2
            IF sn1=1 AND l_img.t_img02 != t_imn15 THEN
                #====>警告! 您所輸入之倉庫為不可用倉
                CALL cl_err(l_img.t_img02,'mfg6080',1)
                LET t_imn15 = l_img.t_img02
                NEXT FIELD t_img02
            ELSE
                IF sn2=2 AND l_img.t_img02 != t_imn15 THEN
                    #====>警告! 您所輸入之倉庫為MPS/MRP不可用倉
                    CALL cl_err(l_img.t_img02,'mfg6085',0)
                    LET t_imn15 = l_img.t_img02
                    NEXT FIELD t_img02
                END IF
            END IF
         END IF
 
        AFTER FIELD t_img03  #儲位
         IF NOT cl_null(l_img.t_img03) THEN
            CALL s_lwyn(l_img.t_img02,l_img.t_img03)
                                   RETURNING sn1,sn2
            IF sn1=1 AND l_img.t_img03 != t_imn16 THEN
                #====>警告! 您所輸入之儲位為不可用倉儲位
                CALL cl_err(l_img.t_img03,'mfg6081',0)
                LET t_imn16 = l_img.t_img03
                NEXT FIELD t_img03
            ELSE
                IF sn2=2 AND l_img.t_img03 != t_imn16 THEN
                    #====>警告! 您所輸入之儲位為MPS/MRP不可用倉之儲位
                    CALL cl_err(l_img.t_img03,'mfg6086',0)
                    LET t_imn16 = l_img.t_img03
                    NEXT FIELD t_img03
                END IF
            END IF
            LET sn1=0 LET sn2=0
         END IF
 
        AFTER FIELD t_img04 #批號
            SELECT * INTO l_oga.* FROM oga_file
             WHERE oga01 = l_imm.imm09
               AND ogaconf = 'Y' #01/08/20 mandy
            IF cl_null(l_img.t_img02) THEN LET l_img.t_img02 = ' ' END IF
            IF cl_null(l_img.t_img03) THEN LET l_img.t_img03 = ' ' END IF
            IF cl_null(l_img.t_img04) THEN LET l_img.t_img04 = ' ' END IF
            IF (l_img.t_img02 = l_oga.oga910) AND
               (l_img.t_img03 = l_oga.oga911) THEN
               IF l_img.t_img03 IS NULL OR l_img.t_img03 = ' ' THEN
                  #轉出轉入之倉,儲,批不可一樣!
                  CALL cl_err('','mfg6103',0)
                  NEXT FIELD t_img02
               END IF
            END IF
            IF cl_null(l_img.t_img02) AND cl_null(l_img.t_img03) AND
                cl_null(l_img.t_img04) THEN
                #轉出轉入之倉,儲,批不可一樣!
                CALL cl_err('','mfg6103',0)
                NEXT FIELD t_img02
            END IF
 
        AFTER INPUT
           IF INT_FLAG THEN EXIT INPUT END IF
	   IF cl_null(l_imm.imm01) THEN
              DISPLAY BY NAME l_imm.imm01
              CALL cl_err('','9033',0) NEXT FIELD imm01
	   END IF
	   IF cl_null(l_imm.imm02) THEN
              DISPLAY BY NAME l_imm.imm02
              CALL cl_err('','9033',0) NEXT FIELD imm02
	   END IF
	   IF cl_null(l_imm.imm08) THEN
              DISPLAY BY NAME l_imm.imm08
              CALL cl_err('','9033',0) NEXT FIELD imm08
	   END IF
	   IF cl_null(l_imm.imm09) THEN
              DISPLAY BY NAME l_imm.imm09
              CALL cl_err('','9033',0) NEXT FIELD imm09
	   END IF
 
        ON ACTION controlp
           CASE WHEN INFIELD(imm01) #查詢單据
                     LET g_t1 = s_get_doc_no(l_imm.imm01)     #No.FUN-550029
                     CALL q_smy(FALSE,FALSE,g_t1,'AIM','4') RETURNING g_t1                     #TQC-670008
                     LET l_imm.imm01 = g_t1                   #No.FUN-550029
                     DISPLAY BY NAME l_imm.imm01
                     NEXT FIELD imm01
                WHEN INFIELD(imm08) #查詢在途倉
                     #No.FUN-AA0049--begin
                     #CALL cl_init_qry_var()
                     #LET g_qryparam.form     ="q_imd"
                     #LET g_qryparam.default1 = l_imm.imm08
                     #LET g_qryparam.arg1     = "W"
                     #CALL cl_create_qry() RETURNING l_imm.imm08
                    #CALL q_imd_1(FALSE,TRUE,l_imm.imm08,'w',"","","") RETURNING l_imm.imm08  #No.TQC-AB0016
                     CALL q_imd_1(FALSE,TRUE,l_imm.imm08,'W',"","","") RETURNING l_imm.imm08  #No.TQC-AB0016 #MOD-AC0191 w->W
                     #No.FUN-AA0049--end
                     DISPLAY BY NAME l_imm.imm08
                     NEXT FIELD imm08
                WHEN INFIELD(imm09) #查詢出至境外倉出貨單號
                     CALL cl_init_qry_var()
                     LET g_qryparam.form     = "q_oga"
                     LET g_qryparam.default1 = l_imm.imm09
                     CALL cl_create_qry() RETURNING l_imm.imm09
                     DISPLAY BY NAME l_imm.imm09
                     NEXT FIELD imm09
               WHEN INFIELD(t_img02) OR INFIELD(t_img03) OR INFIELD(t_img04)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form     = "q_img7"
                    CALL cl_create_qry() RETURNING l_img.t_img02,l_img.t_img03,l_img.t_img04
                    DISPLAY BY NAME l_img.t_img02,l_img.t_img03,l_img.t_img04
                    IF INFIELD(t_img02) THEN NEXT FIELD t_img02 END IF
                    IF INFIELD(t_img03) THEN NEXT FIELD t_img03 END IF
                    IF INFIELD(t_img04) THEN NEXT FIELD t_img04 END IF
                OTHERWISE EXIT CASE
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
 
FUNCTION t325_chk_imm08()
    LET g_wip = 'Y'
    #不計成本倉庫 check
    SELECT COUNT(*) INTO g_cnt FROM jce_file
     WHERE jce02=g_imm.imm08
    IF g_cnt>0 THEN
       LET g_wip = 'N'
    END IF
END FUNCTION
 
 
FUNCTION t325c_imm09() #檢查出貨單號且出貨單號屬於'3'出至境外倉
DEFINE
   l_ogaconf  LIKE oga_file.ogaconf,
   l_ogapost  LIKE oga_file.ogapost
 
   LET g_errno=''
   SELECT ogaconf,ogapost INTO l_ogaconf,l_ogapost FROM oga_file
    WHERE oga01 = l_imm.imm09
      AND oga00 = '3' #出至境外倉
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='100'
       WHEN l_ogaconf='N'       LET g_errno='9029'
       WHEN l_ogaconf='X'       LET g_errno='9024'    #此筆資料已作廢 mandy
       WHEN l_ogapost!='Y'      LET g_errno='aim-326' #未庫存扣帳!
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
END FUNCTION
 
FUNCTION t325c_b()
 DEFINE
    l_oga     RECORD LIKE oga_file.*,
    l_ogb     RECORD LIKE ogb_file.*,
    l_imn     RECORD LIKE imn_file.*,
    l_x       LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    l_imn9301 LIKE imn_file.imn9301   #FUN-670093
 DEFINE l_imni  RECORD LIKE imni_file.*    #FUN-B70074 
    SELECT * INTO l_oga.* FROM oga_file
     WHERE oga01 = l_imm.imm09
       AND ogaconf = 'Y'  #01/08/20 mandy
    DECLARE t325c_b CURSOR FOR
         SELECT * FROM ogb_file
             WHERE ogb01=l_imm.imm09
    LET l_x=0
    LET l_imn9301=s_costcenter(g_imm.imm14) #FUN-670093
    FOREACH t325c_b INTO l_ogb.*
        LET l_x = l_x + 1
        LET l_imn.imn01  = l_imm.imm01
        LET l_imn.imn02  = l_x
        LET l_imn.imn03  = l_ogb.ogb04
        LET l_imn.imn29  = 'N'    #No.FUN-5C0077
        LET l_imn.imn04  = l_oga.oga910
        LET l_imn.imn05  = l_oga.oga911
        LET l_imn.imn06  = ' '
        LET l_imn.imn09  = l_ogb.ogb05
        LET l_imn.imn10  = l_ogb.ogb12
        LET l_imn.imn12  = 'N'
        LET l_imn.imn24  = 'N' #TQC-DB0039
        LET l_imn.imn15  = l_img.t_img02
        LET l_imn.imn16  = l_img.t_img03
        LET l_imn.imn17  = l_img.t_img04
        LET l_imn.imn20  = l_ogb.ogb05
        LET l_imn.imn21  = 1
        LET l_imn.imn22  = l_imn.imn10 * l_imn.imn21
        LET l_imn.imn22 = s_digqty(l_imn.imn22,l_imn.imn20)   #No.FUN-BB0086
        LET l_imn.imn26  = ''
        LET l_imn.imn33  = l_ogb.ogb913
        LET l_imn.imn35  = l_ogb.ogb915
        LET b_imn.imn9301=l_imn9301 #FUN-670093
        LET b_imn.imn9302=l_imn9301 #FUN-670093   
#FUN-AB0066 --begin--
#        #No.FUN-AA0049--begin
#        IF NOT s_chk_ware(l_imn.imn04) THEN
#           LET l_imn.imn04=' '
#           LET l_imn.imn05=' '
#        END IF 
#        #No.FUN-AA0049--end             
#FUN-AB0066 --end--        
        SELECT img09 INTO g_img09_s FROM img_file
         WHERE img01=l_imn.imn03
           AND img02=l_imn.imn04
           AND img03=l_imn.imn05
           AND img04=l_imn.imn06
        LET g_factor=1
        CALL s_umfchk(l_imn.imn03,l_imn.imn33,g_img09_s)
             RETURNING g_sw,g_factor
        IF cl_null(g_factor) THEN LET g_factor=1 END IF
        LET l_imn.imn34  = g_factor
        LET l_imn.imn30  = l_ogb.ogb910
        LET l_imn.imn32  = l_ogb.ogb912
        LET g_factor=1
        CALL s_umfchk(l_imn.imn03,l_imn.imn30,g_img09_s)
             RETURNING g_sw,g_factor
        IF cl_null(g_factor) THEN LET g_factor=1 END IF
        LET l_imn.imn31  = g_factor
 
        LET l_imn.imn43  = l_ogb.ogb913
        LET l_imn.imn45  = l_ogb.ogb915
        SELECT img09 INTO g_img09_t FROM img_file
         WHERE img01=l_imn.imn03
           AND img02=l_imn.imn15
           AND img03=l_imn.imn16
           AND img04=l_imn.imn17
        LET g_factor=1
        CALL s_umfchk(l_imn.imn03,l_imn.imn43,g_img09_t)
             RETURNING g_sw,g_factor
        IF cl_null(g_factor) THEN LET g_factor=1 END IF
        LET l_imn.imn44  = g_factor
        LET l_imn.imn40  = l_ogb.ogb910
        LET l_imn.imn42  = l_ogb.ogb912
        LET g_factor=1
        CALL s_umfchk(l_imn.imn03,l_imn.imn40,g_img09_t)
             RETURNING g_sw,g_factor
        IF cl_null(g_factor) THEN LET g_factor=1 END IF
        LET l_imn.imn41  = g_factor
        LET l_imn.imn51  = 1
        LET l_imn.imn52  = 1
        IF cl_null(l_imn.imn33) THEN
           LET l_imn.imn34 = NULL
           LET l_imn.imn35 = NULL
           LET l_imn.imn52 = NULL
        END IF
 
        IF cl_null(l_imn.imn30) THEN
           LET l_imn.imn31 = NULL
           LET l_imn.imn32 = NULL
           LET l_imn.imn51 = NULL
        END IF
 
        IF cl_null(l_imn.imn43) THEN
           LET l_imn.imn44 = NULL
           LET l_imn.imn45 = NULL
           LET l_imn.imn52 = NULL
        END IF
 
        IF cl_null(l_imn.imn40) THEN
           LET l_imn.imn41 = NULL
           LET l_imn.imn42 = NULL
           LET l_imn.imn51 = NULL
        END IF
 
        #檢查料倉儲批是否存在於 img_file
        SELECT * FROM img_file
         WHERE img01 = l_imn.imn03 AND img02 = l_imn.imn15
           AND img03 = l_imn.imn16 AND img04 = l_imn.imn17
        IF STATUS = 100 THEN
           LET g_success='N'
           CALL cl_err3("sel","img_file",l_imn.imn03,"","aim-325","","sel img",1)   #NO.FUN-640266 #No.FUN-660156
           EXIT FOREACH
        END IF
        LET l_imn.imnplant = g_plant #FUN-980004 add
        LET l_imn.imnlegal = g_legal #FUN-980004 add
        LET l_imn.imn12='N' #TQC-DB0039
        LET l_imn.imn24='N' #TQC-DB0039
        INSERT INTO imn_file VALUES(l_imn.*)
        IF STATUS THEN
           LET g_success='N'
           CALL cl_err3("ins","imn_file",l_imn.imn01,"",SQLCA.sqlcode,"","ins imn",1)   #NO.FUN-640266 #No.FUN-660156
           EXIT FOREACH
        #FUN-B70074-add-str--
        ELSE 
           IF NOT s_industry('std') THEN
              INITIALIZE l_imni.* TO NULL
              LET l_imni.imni01 = l_imn.imn01
              LET l_imni.imni02 = l_imn.imn02
              IF NOT s_ins_imni(l_imni.*,l_imn.imnplant) THEN
                 LET g_success= 'N'
                 EXIT FOREACH 
              END IF            
           END IF
        #FUN-B70074-add-end--
        END IF
    END FOREACH
END FUNCTION
 
#FUNCTION t325_x()         #CHI-D20010
FUNCTION t325_x(p_type)    #CHI-D20010
   DEFINE l_cnt  LIKE type_file.num10 #MOD-6C0114
   DEFINE l_flag LIKE type_file.chr1  #CHI-D20010
   DEFINE p_type LIKE type_file.chr1  #CHI-D20010
   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_imm.* FROM imm_file WHERE imm01=g_imm.imm01 
   IF cl_null(g_imm.imm01) THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_imm.imm04 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_imm.immspc = '1' OR g_imm.immspc = '3' THEN CALL cl_err('','aqc-116',0) RETURN END IF  #FUN-680010
   #-->已有QC單則不可作廢
   SELECT COUNT(*) INTO l_cnt FROM qcs_file
    WHERE qcs01 = g_imm.imm01 AND qcs00='C'
   IF l_cnt > 0 THEN
      CALL cl_err(' ','aqc-118',0)
      RETURN
   END IF

   #CHI-D20010---begin
   IF p_type = 1 THEN
      IF g_imm.imm04 ='X' THEN RETURN END IF
   ELSE
      IF g_imm.imm04 <>'X' THEN RETURN END IF
   END IF
   #CHI-D20010---end

   BEGIN WORK
   IF g_imm.imm04 = 'X' THEN  LET l_flag = 'X' ELSE LET l_flag = 'N' END IF #CHI-D20010
  #IF cl_void(0,0,g_imm.imm04) THEN  #CHI-D20010
   IF cl_void(0,0,l_flag) THEN       #CHI-D20010
       #IF g_imm.imm04 ='N' THEN  #CHI-D20010
        IF p_type = 1 THEN        #CHI-D20010
            LET g_imm.imm04='X'
        ELSE
            LET g_imm.imm04='N'
        END IF
        UPDATE imm_file SET imm04 = g_imm.imm04,immmodu=g_user,immdate=TODAY
         WHERE imm01 = g_imm.imm01
        IF SQLCA.sqlcode THEN
           CALL cl_err3("upd","imm_file",g_imm.imm01,"",SQLCA.sqlcode,"","up imm04",1)   #NO.FUN-640266  #No.FUN-660156
           ROLLBACK WORK
        ELSE
            COMMIT WORK
            CALL cl_flow_notify(g_imm.imm01,'V')
        END IF
   END IF
   SELECT imm04 INTO g_imm.imm04 FROM imm_file WHERE imm01 = g_imm.imm01 
   DISPLAY BY NAME g_imm.imm04
END FUNCTION
 
FUNCTION t325_t()
  DEFINE p_cmd           LIKE type_file.chr1    #a:輸入 u:更改  #No.FUN-690026 VARCHAR(1)
  DEFINE l_errno         LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
  DEFINE l_flag          LIKE type_file.chr1    #判斷必要欄位是否有輸入  #No.FUN-690026 VARCHAR(1)
  DEFINE l_msg           LIKE type_file.chr1000 #加註說明 #No.FUN-690026 VARCHAR(30)
  DEFINE li_result       LIKE type_file.num5    #No.FUN-550029  #No.FUN-690026 SMALLINT
 
   IF cl_null(g_argv1)   THEN RETURN END IF                #aimt325 不可run
   IF g_imm.imm04 = 'X'  THEN
      CALL cl_err('','9024',0)     RETURN   END IF  #aimt326 不可run
   IF g_imm.imm04 = 'N'  THEN
      CALL cl_err('','aim-003',0)  RETURN   END IF  #aimt326 不可run      #No.TQC-750041
   IF g_imm.imm03 = 'Y'  THEN
      CALL cl_err('','9023',0)     RETURN   END IF  #aimt326 不可run
 
   LET g_imm_t.imm11 = g_imm.imm11
   LET g_imm_t.imm12 = g_imm.imm12
   LET g_imm_t.imm13 = g_imm.imm13
   IF cl_null(g_imm.imm12) THEN LET g_imm.imm12 = g_today END IF
   IF cl_null(g_imm.imm13) THEN LET g_imm.imm13 = g_user END IF
   CALL t325_imm13('d')
 
 WHILE TRUE
 
   INPUT BY NAME g_imm.imm11,g_imm.imm12,g_imm.imm13
                 WITHOUT DEFAULTS
 
        BEFORE FIELD imm11
            IF g_sma.sma884 = 'Y' THEN
               LET g_imm.imm11 = g_imm.imm01
               DISPLAY BY NAME g_imm.imm11
               NEXT FIELD imm12
            END IF
        AFTER FIELD imm11
            IF NOT cl_null(g_imm.imm11) THEN
               CALL s_check_no("aim",g_imm.imm11,g_imm_t.imm11,"A","imm_file","imm11","")
                    RETURNING li_result,g_imm.imm11
               DISPLAY BY NAME g_imm.imm11
               IF (NOT li_result) THEN
                    NEXT FIELD imm11
               END IF
               IF g_imm.imm11 != g_imm_t.imm11 OR cl_null(g_imm_t.imm11) THEN  #TQC-7B0076
                  SELECT count(*) INTO g_cnt FROM imm_file
                   WHERE imm11 = g_imm.imm11 
                  IF g_cnt > 0 THEN   #資料重複
                     CALL cl_err(g_imm.imm11,-239,0)
                     LET g_imm.imm11 = g_imm_t.imm11
                     DISPLAY BY NAME g_imm.imm11
                     NEXT FIELD imm11
     	      END IF
 
               END IF   #TQC-7B0076
 
               LET l_errno ='Y'
               IF ( g_imm.imm11 != g_imm_t.imm11 OR cl_null(g_imm_t.imm11)) AND
                  g_sma.sma884 = 'Y' THEN
                  SELECT count(*) INTO g_cnt FROM imm_file
                   WHERE imm01 != g_imm.imm11 AND imm11 = g_imm.imm11 
                  IF g_cnt > 0 THEN   #資料重複
                     CALL cl_err(g_imm.imm11,-239,1)
                     LET g_imm.imm11 = g_imm_t.imm11
                     DISPLAY BY NAME g_imm.imm11
                     LET l_errno='Y'
                  END IF
               END IF
 
            END IF
        BEFORE FIELD imm12
           IF cl_null(g_imm.imm12) THEN
              LET g_imm.imm12 = g_today
              DISPLAY BY NAME g_imm.imm12
           END IF
        AFTER FIELD imm12
           IF l_errno='N' THEN NEXT FIELD imm12 END IF
           IF NOT cl_null(g_imm.imm12) AND g_imm.imm12 < g_imm.imm02 THEN
              CALL cl_err('','aim-313',0)
              NEXT FIELD imm12
           END IF
           LET l_msg = "Clos:",g_sma.sma53 CLIPPED
	   IF g_sma.sma53 IS NOT NULL AND g_imm.imm12 <= g_sma.sma53 THEN
	      CALL cl_err(l_msg,'mfg9999',0) NEXT FIELD imm12
	   END IF
           LET l_msg = "Acct:",g_sma.sma51 USING "<<<<" CLIPPED,"/",g_sma.sma52 USING "<<<" CLIPPED
           CALL s_yp(g_imm.imm12) RETURNING g_yy,g_mm
           IF (g_yy*12+g_mm)>(g_sma.sma51*12+g_sma.sma52)THEN #不可大於現行年月
              CALL cl_err(l_msg,'mfg6091',0) NEXT FIELD imm12
           END IF
           IF g_imm.imm12 < (g_sma.sma51*12+g_sma.sma52)THEN #不可大於現行年月    #No.MOD-8C0293
              CALL cl_err(l_msg,'axm-164',0) NEXT FIELD imm12      #No.MOD-8C0293
           END IF
 
        BEFORE FIELD imm13
           IF cl_null(g_imm.imm13) THEN
              LET g_imm.imm13 = g_user
              DISPLAY BY NAME g_imm.imm13
           END IF
 
        AFTER FIELD imm13
	   IF cl_null(g_imm.imm13) THEN NEXT FIELD imm13 END IF
           CALL t325_imm13('a')
           IF NOT cl_null(g_errno) THEN
              CALL cl_err('sel gen02:',g_errno,1)
              NEXT FIELD imm13
           END IF
 
        AFTER INPUT
           IF INT_FLAG THEN EXIT INPUT END IF
 
        ON ACTION CONTROLP
          CASE WHEN INFIELD(imm11) #查詢單据
                    LET g_t1 = s_get_doc_no(g_imm.imm11)     #No.FUN-550029
                    CALL q_smy(FALSE,FALSE,g_t1,'AIM','A') RETURNING g_t1  #TQC-670008
                    LET g_imm.imm11 = g_t1                   #No.FUN-550029
                    DISPLAY BY NAME g_imm.imm11
                    NEXT FIELD imm11
               WHEN INFIELD(imm13) #查詢在途倉
                    CALL cl_init_qry_var()
                    LET g_qryparam.form     = "q_gen"
                    LET g_qryparam.default1 = g_imm.imm13
                    CALL cl_create_qry() RETURNING g_imm.imm13
                    DISPLAY BY NAME g_imm.imm13
                    NEXT FIELD imm13
               OTHERWISE EXIT CASE
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
    IF INT_FLAG  THEN
       LET INT_FLAG = 0
       LET g_imm.imm11 = g_imm_t.imm11
       LET g_imm.imm12 = g_imm_t.imm12
       LET g_imm.imm13 = g_imm_t.imm13
       DISPLAY BY NAME g_imm.imm11,g_imm.imm12,g_imm.imm13
       CALL t325_imm13('d')
       EXIT WHILE
       RETURN
    END IF
   BEGIN WORK
   IF g_imm.imm11 != g_imm_t.imm11 OR cl_null(g_imm_t.imm11) THEN
       IF g_smy.smyauno='Y'  THEN
          CALL s_auto_assign_no("aim",g_imm.imm11,g_imm.imm12,"4","imm_file","imm11",
                                 "","","")
           RETURNING li_result,g_imm.imm11
           IF (NOT li_result) THEN
               CONTINUE WHILE
           END IF
       END IF
  END IF
       DISPLAY BY NAME g_imm.imm11
 
    IF cl_confirm('apj-000') THEN EXIT WHILE END IF
 
 END WHILE
    UPDATE imm_file SET imm11 = g_imm.imm11,     #modify database
                        imm12 = g_imm.imm12,
                        imm13 = g_imm.imm13
     WHERE imm01 = g_imm.imm01
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
    #   ROLLBACK WORK    #TQC-7B0076              #FUN-B80070---回滾放在報錯後---
       CALL cl_err3("upd","imm_file",g_imm.imm01,"",SQLCA.sqlcode,"","upd imm",1)   #NO.FUN-640266 #No.FUN-660156
       ROLLBACK WORK     #FUN-B80070--add--
    ELSE
       COMMIT WORK     #TQC-7B0076
       DISPLAY BY NAME g_imm.imm11,g_imm.imm12,g_imm.imm13
       CALL t325_imm13('d')
    END IF
END FUNCTION
 
FUNCTION t325_imm08(p_imm08)  #在途倉
    DEFINE p_imm08   LIKE imm_file.imm08,
           l_imd10   LIKE imd_file.imd10,   #MOD-610048
           l_imdacti LIKE imd_file.imdacti
 
    LET g_errno = ''
   LET l_imd10 = '' #MOD-610048
    SELECT imdacti,imd10 INTO l_imdacti,l_imd10
      FROM imd_file WHERE imd01=p_imm08
    IF SQLCA.sqlcode=0 AND l_imd10 <> 'W' AND l_imdacti='Y' THEN
       LET g_errno='asf-724'
       RETURN
    END IF
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1100'
                                   LET l_imdacti = ''
         WHEN l_imdacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION t325_imm13(p_cmd)         #人員代號
    DEFINE p_cmd     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           l_genacti LIKE gen_file.genacti,
           l_gen02   LIKE gen_file.gen02
 
    LET g_errno = ''
    SELECT gen02,genacti INTO l_gen02,l_genacti FROM gen_file
     WHERE gen01 = g_imm.imm13
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1312'
                                   LET l_gen02 = ''
                                   LET l_genacti = ''
         WHEN l_genacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_gen02   TO FORMONLY.gen02
    END IF
END FUNCTION
FUNCTION t325_imn03(p_cmd)         #料件代號
    DEFINE p_cmd     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           l_imaacti LIKE ima_file.imaacti,
           l_ima02   LIKE ima_file.ima02,
           l_ima021  LIKE ima_file.ima021
    DEFINE l_ima35   LIKE ima_file.ima35,   #CHI-6A0015
           l_ima36   LIKE ima_file.ima36    #CHI-6A0015
    #FUN-C20002--start add-----------------------------
    DEFINE l_ima154  LIKE ima_file.ima154
    DEFINE l_rcj03   LIKE rcj_file.rcj03
    DEFINE l_rtz07   LIKE rtz_file.rtz07
    DEFINE l_rtz08   LIKE rtz_file.rtz08
    #FUN-C20002--end add-------------------------------  

 
    LET g_errno = ''
    SELECT ima02,ima021,ima35,ima36,imaacti                          #CHI-6A0015 add ima35/36
      INTO l_ima02,l_ima021,l_ima35,l_ima36,l_imaacti FROM ima_file  #CHI-6A0015 add ima35/36
     WHERE ima01 = g_imn[l_ac].imn03
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'asf-471'
                                   LET l_ima02 = ''
                                   LET l_ima021= ''
                                   LET l_ima35 = ''      #CHI-6A0015
                                   LET l_ima36 = ''      #CHI-6A0015
                                   LET l_imaacti = ''
         WHEN l_imaacti='N'        LET g_errno = '9028'
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE

#FUN-AB0066 --begin--    
#    #No.FUN-AA0049--begin
#    IF NOT s_chk_ware(l_ima35) THEN
#       LET l_ima35=' '
#       LET l_ima36=' '
#    END IF 
#    #No.FUN-AA0049--end         
#FUN-AB0066 --end--    

    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       LET g_imn[l_ac].ima02= l_ima02
       LET g_imn[l_ac].ima021=l_ima021
 
       IF cl_null(g_imn_t.imn03) OR g_imn_t.imn03 <> g_imn[l_ac].imn03 THEN   #TQC-750018
         #FUN-C20002--start add--------------------------------
         IF g_azw.azw04 = '2' THEN
            SELECT ima154 INTO l_ima154
              FROM ima_file
             WHERE ima01 = g_imn[l_ac].imn03
            IF l_ima154 = 'Y' AND g_imn[l_ac].imn03[1,4] <> 'MISC' THEN
               SELECT rcj03 INTO l_rcj03
                 FROM rcj_file
                WHERE rcj00 = '0'

               #FUN-C90049 mark begin---
               #SELECT rtz07,rtz08 INTO l_rtz07,l_rtz08
               #  FROM rtz_file
               # WHERE rtz01 = g_plant
               #FUN-C90049 mark end-----
               
               CALL s_get_defstore(g_plant,g_imn[l_ac].imn03) RETURNING l_rtz07,l_rtz08    #FUN-C90049 add

               IF l_rcj03 = '1' THEN
                  LET g_imn[l_ac].imn04 = l_rtz07
               ELSE
                  LET g_imn[l_ac].imn04 = l_rtz08
               END IF      
            END IF 
         ELSE 
         #FUN-C20002--end add---------------------------------- 
         LET g_imn[l_ac].imn04 =l_ima35    #CHI-6A0015 add
         END IF                  #FUN-C20002 add
         LET g_imn[l_ac].imn05 =l_ima36    #CHI-6A0015 add
         LET g_imn[l_ac].imn06 = ' '      #TQC-750018
       END IF                              #TQC-750018
       DISPLAY BY NAME g_imn[l_ac].ima02
       DISPLAY BY NAME g_imn[l_ac].ima021
       DISPLAY BY NAME g_imn[l_ac].imn04  #CHI-6A0015 add
       DISPLAY BY NAME g_imn[l_ac].imn05  #CHI-6A0015 add
    END IF
END FUNCTION
 
FUNCTION t325_imn28()     #理由碼
    DEFINE p_cmd     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           l_azfacti LIKE azf_file.azfacti,
           l_azf03   LIKE azf_file.azf03,
           l_azf09   LIKE azf_file.azf09,     #FUN-920186
           l_azf09_mark   LIKE azf_file.azf09     #FUN-920186
    DEFINE l_flag    LIKE type_file.chr1,     #FUN-CB0087
           l_n       LIKE type_file.num5,     #FUN-CB0087
           l_sql     STRING,                  #FUN-CB0087
           l_where   STRING,                  #FUN-CB0087
           l_store   STRING                   #FUN-CB0087
 
    LET g_errno = ''
    
    #FUN-CB0087---add---str---
    LET l_n = 0
    LET l_store = ''
    IF NOT cl_null(g_imn[l_ac].imn04) THEN
       LET l_store = l_store,g_imn[l_ac].imn04
    END IF
    IF NOT cl_null(g_imn[l_ac].imn15) THEN
       IF NOT cl_null(l_store) THEN
          LET l_store = l_store,"','",g_imn[l_ac].imn15
       ELSE
          LET l_store = l_store,g_imn[l_ac].imn15
       END IF
    END IF
    CALL s_get_where(g_imm.imm01,'','',g_imn[l_ac].imn03,l_store,'',g_imm.imm14) RETURNING l_flag,l_where
    IF g_aza.aza115='Y' AND l_flag THEN
       LET l_sql = " SELECT COUNT(*) FROM ggc_file WHERE ggc08='",g_imn[l_ac].imn28,"' AND ",l_where
       PREPARE ggc08_pre FROM l_sql
       EXECUTE ggc08_pre INTO l_n
       IF l_n < 1 THEN
          LET g_errno = 'aim-425'
       ELSE
          SELECT azf03 INTO l_azf03 FROM azf_file WHERE azf01=g_imn[l_ac].imn28 AND azf02='2'
       END IF
    ELSE
    #FUN-CB0087---add---end---
    SELECT azf03,azf09,azfacti INTO l_azf03,l_azf09,l_azfacti FROM azf_file   #FUN-920186
     WHERE azf01 = g_imn[l_ac].imn28 AND azf02 = '2' 
     
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3088'
                                   LET l_azf03 = ''
                                   LET l_azfacti = ''
         WHEN l_azfacti='N'        LET g_errno = '9028'
         WHEN l_azf09 != '6'       LET g_errno = 'aoo-405'      #FUN-920186
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    END IF                         #FUN-CB0087---add---
    RETURN l_azf03
END FUNCTION
 
#check 撥出:料/倉/儲/批
#(1)數量是否大於0
#(2)是否有效
#(3)重算撥出/入的換算率 及撥入數量
FUNCTION t325_chk_out()
  DEFINE l_img10 LIKE img_file.img10
  #IF NOT cl_confirm('aim-301') THEN RETURN END IF   #CHI-C30106   #CHI-C50010 mark
    SELECT img09,img10
      INTO g_imn[l_ac].imn09,l_img10
      FROM img_file
     WHERE img01=g_imn[l_ac].imn03
       AND img02=g_imn[l_ac].imn04
       AND img03=g_imn[l_ac].imn05
       AND img04=g_imn[l_ac].imn06
    IF SQLCA.sqlcode THEN
        LET l_img10 = 0
        #在庫存明細資料查無該筆, 請重新輸入!!
        #FUN-C80107 modify begin----------------------------------------------121024
        #CALL cl_err3("sel","img_file",g_imn[l_ac].imn06,"","mfg6101","","",1) #No.FUN-660156
        #RETURN 1
        INITIALIZE g_flag1 TO NULL
        #CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_imn[l_ac].imn04) RETURNING g_flag1 #FUN-D30024--mark
        CALL s_inv_shrt_by_warehouse(g_imn[l_ac].imn04,g_plant) RETURNING g_flag1 #FUN-D30024--add #TQC-D40078 g_plant
        IF g_flag1 = 'N' OR g_flag1 IS NULL THEN
           CALL cl_err3("sel","img_file",g_imn[l_ac].imn06,"","mfg6101","","",1)
           RETURN 1
        ELSE
           IF g_sma.sma892[3,3] = 'Y' THEN
              IF NOT cl_confirm('mfg1401') THEN RETURN 1 END IF
           END IF
           CALL s_add_img(g_imn[l_ac].imn03,g_imn[l_ac].imn04,
                          g_imn[l_ac].imn05,g_imn[l_ac].imn06,
                          g_imm.imm01      ,g_imn[l_ac].imn02,
                          g_imm.imm02)
           IF g_errno='N' THEN
              RETURN 1
           END IF
           SELECT img09,img10
             INTO g_imn[l_ac].imn09,l_img10
             FROM img_file
            WHERE img01=g_imn[l_ac].imn03
              AND img02=g_imn[l_ac].imn04
              AND img03=g_imn[l_ac].imn05
              AND img04=g_imn[l_ac].imn06
        END IF
        #FUN-C80107 modify end----------------------------------------------
    END IF
    IF l_img10 <=0 THEN
        #庫存不足是否許調撥出庫='N'
       #IF g_sma.sma894[4,4]='N' OR g_sma.sma894[4,4] IS NULL THEN  #FUN-C80107 mark
        LET g_flag1 = NULL    #FUN-C80107 add
        #CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_imn[l_ac].imn04) RETURNING g_flag1   #FUN-C80107 add #FUN-D30024--mark
        CALL s_inv_shrt_by_warehouse(g_imn[l_ac].imn04,g_plant) RETURNING g_flag1      #FUN-D30024--add #TQC-D40078 g_plant
        IF g_flag1 = 'N' OR g_flag1 IS NULL THEN   #FUN-C80107 add
            #目前已無庫存量無法執行調撥動作
            CALL cl_err(l_img10,'mfg3471',1)
            RETURN 1
        END IF
    END IF
   #MOD-CA0009---mark---S
   ##-->有效日期
   #IF NOT s_actimg(g_imn[l_ac].imn03,g_imn[l_ac].imn04,
   #                g_imn[l_ac].imn05,g_imn[l_ac].imn06) THEN
   #    CALL cl_err('inactive','mfg6117',1)
   #    RETURN 1
   #END IF
   #MOD-CA0009---mark---E
    CALL s_umfchk(g_imn[l_ac].imn03,g_imn[l_ac].imn09,g_imn[l_ac].imn20)
             RETURNING g_cnt,g_imn[l_ac].imn21
    IF g_cnt = 1 THEN
        CALL cl_err('','mfg3075',1)
        RETURN 1
    END IF
    LET g_imn[l_ac].imn22=g_imn[l_ac].imn10*g_imn[l_ac].imn21
    LET g_imn[l_ac].imn22 = s_digqty(g_imn[l_ac].imn22,g_imn[l_ac].imn20)   #No.FUN-BB0086
    IF g_imn[l_ac].imn09 <> g_imn_t.imn09 THEN
        #撥出:倉/儲/批的單位已變了,請注意撥出數量是否正確
        CALL cl_err('','aim-324',0)
    END IF
    RETURN 0
END FUNCTION
 
#No:7698
#check 撥入:料/倉/儲/批
#(1)是否有效
#(2)重算撥出/入的換算率 及撥入數量
FUNCTION t324_chk_in()
    SELECT img09  INTO g_imn[l_ac].imn20
      FROM img_file
     WHERE img01=g_imn[l_ac].imn03
       AND img02=g_imn[l_ac].imn15
       AND img03=g_imn[l_ac].imn16
       AND img04=g_imn[l_ac].imn17
    IF SQLCA.sqlcode THEN
        RETURN 1
    END IF
   #MOD-CA0009---mark---S
   #IF NOT s_actimg(g_imn[l_ac].imn03,g_imn[l_ac].imn15,
   #                g_imn[l_ac].imn16,g_imn[l_ac].imn17) THEN
   #    CALL cl_err('inactive','mfg6117',1)
   #    RETURN 1
   #END IF
   #MOD-CA0009---mark---E
    CALL s_umfchk(g_imn[l_ac].imn03,g_imn[l_ac].imn09,g_imn[l_ac].imn20)
                  RETURNING g_cnt,g_imn[l_ac].imn21
    IF g_cnt = 1 THEN
        CALL cl_err('','mfg3075',1)
        RETURN 1
    END IF
    LET g_imn[l_ac].imn22=g_imn[l_ac].imn10*g_imn[l_ac].imn21
    LET g_imn[l_ac].imn22 = s_digqty(g_imn[l_ac].imn22,g_imn[l_ac].imn20)   #No.FUN-BB0086
    RETURN 0
END FUNCTION
 
FUNCTION t325_mu_ui()
 
    CALL cl_set_comp_visible("imn31,imn34,imn41,imn44",FALSE)
    IF g_sma.sma115 ='N' THEN
       CALL cl_set_comp_visible("imn33,imn34,imn35,imn43,imn44,imn45,imn52",FALSE)
       CALL cl_set_comp_visible("imn30,imn31,imn32,imn40,imn41,imn42,imn51",FALSE)
    ELSE
       CALL cl_set_comp_visible("imn09,imn10,imn20,imn21,imn22",FALSE)
    END IF
    IF g_sma.sma122 ='1' THEN
       CALL cl_getmsg('asm-331',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn33",g_msg CLIPPED)
       CALL cl_getmsg('asm-332',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn35",g_msg CLIPPED)
       CALL cl_getmsg('asm-333',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn30",g_msg CLIPPED)
       CALL cl_getmsg('asm-334',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn32",g_msg CLIPPED)
       CALL cl_getmsg('asm-335',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn43",g_msg CLIPPED)
       CALL cl_getmsg('asm-336',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn45",g_msg CLIPPED)
       CALL cl_getmsg('asm-337',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn40",g_msg CLIPPED)
       CALL cl_getmsg('asm-338',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn42",g_msg CLIPPED)
       CALL cl_getmsg('asm-347',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn52",g_msg CLIPPED)
       CALL cl_getmsg('asm-348',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn51",g_msg CLIPPED)
    END IF
    IF g_sma.sma122 ='2' THEN
       CALL cl_getmsg('asm-339',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn33",g_msg CLIPPED)
       CALL cl_getmsg('asm-340',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn35",g_msg CLIPPED)
       CALL cl_getmsg('asm-341',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn30",g_msg CLIPPED)
       CALL cl_getmsg('asm-342',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn32",g_msg CLIPPED)
       CALL cl_getmsg('asm-343',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn43",g_msg CLIPPED)
       CALL cl_getmsg('asm-344',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn45",g_msg CLIPPED)
       CALL cl_getmsg('asm-345',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn40",g_msg CLIPPED)
       CALL cl_getmsg('asm-346',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn42",g_msg CLIPPED)
       CALL cl_getmsg('asm-349',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn52",g_msg CLIPPED)
       CALL cl_getmsg('asm-350',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn51",g_msg CLIPPED)
    END IF
    IF g_aaz.aaz90='Y' THEN
       CALL cl_set_comp_required("imm14",TRUE)
    END IF
 
    CALL cl_set_comp_visible("imn9301,gem02b,imn9302,gem02c",g_aaz.aaz90='Y')  #FUN-670093
 
    IF g_aza.aza64 matches '[ Nn]' THEN
       CALL cl_set_comp_visible("immspc",FALSE)
       CALL cl_set_act_visible("trans_spc",FALSE)
    END IF 
 
END FUNCTION
 
#以img09單位來計算雙單位所確定的數量
FUNCTION t325_tot_by_img09(p_item,p_fac2,p_qty2,p_fac1,p_qty1)
  DEFINE p_item    LIKE ima_file.ima01
  DEFINE p_fac2    LIKE inb_file.inb903
  DEFINE p_qty2    LIKE inb_file.inb904
  DEFINE p_fac1    LIKE inb_file.inb903
  DEFINE p_qty1    LIKE inb_file.inb904
  DEFINE l_ima906  LIKE ima_file.ima906
  DEFINE l_ima907  LIKE ima_file.ima907
  DEFINE l_tot     LIKE img_file.img10
 
    SELECT ima906,ima907 INTO l_ima906,l_ima907
      FROM ima_file WHERE ima01 = p_item
 
    IF cl_null(p_fac2) THEN LET p_fac2 = 1 END IF
    IF cl_null(p_qty2) THEN LET p_qty2 = 0 END IF
    IF cl_null(p_fac1) THEN LET p_fac1 = 1 END IF
    IF cl_null(p_qty1) THEN LET p_qty1 = 0 END IF
    IF g_sma.sma115 = 'Y' THEN
       CASE l_ima906
          WHEN '1' LET l_tot=p_qty1*p_fac1
          WHEN '2' LET l_tot=p_qty1*p_fac1+p_qty2*p_fac2
          WHEN '3' LET l_tot=p_qty1*p_fac1
       END CASE
    ELSE  #不使用雙單位
       LET l_tot=p_qty1*p_fac1
    END IF
    IF cl_null(l_tot) THEN LET l_tot = 0 END IF
    RETURN l_tot
 
END FUNCTION
 
#計算庫存總量是否滿足所輸入數量
FUNCTION t325_check_inventory_qty()
  DEFINE l_img10    LIKE img_file.img10
  DEFINE l_imn10    LIKE imn_file.imn10
  DEFINE l_tot      LIKE img_file.img10
  DEFINE l_flag     LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    LET l_flag = '1'
    SELECT SUM(imn10) INTO l_imn10
      FROM imn_file
     WHERE imn01 = g_imm.imm01
       AND imn02 <> g_imn[l_ac].imn02
       AND imn03 = g_imn[l_ac].imn03
       AND imn04 = g_imn[l_ac].imn04
       AND imn05 = g_imn[l_ac].imn05
       AND imn06 = g_imn[l_ac].imn06
    IF cl_null(l_imn10) THEN
       LET l_imn10 = 0
    END IF
 
    SELECT img10 INTO l_img10 FROM img_file
     WHERE img01 = g_imn[l_ac].imn03
       AND img02 = g_imn[l_ac].imn04
       AND img03 = g_imn[l_ac].imn05
       AND img04 = g_imn[l_ac].imn06
 
    CALL t325_tot_by_img09(g_imn[l_ac].imn03,g_imn[l_ac].imn34,
                           g_imn[l_ac].imn35,g_imn[l_ac].imn31,
                           g_imn[l_ac].imn32)
         RETURNING l_tot
    IF l_img10 < l_tot + l_imn10 THEN
       LET l_flag = '0'
    END IF
    RETURN l_flag
END FUNCTION
 
#檢查發料/報廢動作是否可以進行下去
FUNCTION t325_qty_issue()
 
    CALL t325_check_inventory_qty()  RETURNING g_flag
    IF g_flag = '0' THEN
      #IF g_sma.sma894[4,4]='N' OR g_sma.sma894[4,4] IS NULL THEN  #FUN-C80107 mark
       LET g_flag1 = NULL    #FUN-C80107 add
       #CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_imn[l_ac].imn04) RETURNING g_flag1   #FUN-C80107 add #FUN-D30024--mark
       CALL s_inv_shrt_by_warehouse(g_imn[l_ac].imn04,g_plant) RETURNING g_flag1       #FUN-D30024--add #TQC-D40078 g_plant
       IF g_flag1 = 'N' OR g_flag1 IS NULL THEN   #FUN-C80107 add
          CALL cl_err(g_imn[l_ac].imn03,'mfg1303',1)
          RETURN 1
       ELSE
          IF g_yes = 'N' THEN
             IF NOT cl_confirm('mfg3469') THEN
                RETURN 1
             END IF
          END IF
      END IF
    END IF
 
    RETURN 0
 
END FUNCTION
 
#兩組雙單位資料不是一定要全部KEY,如果沒有KEY單位,則把換算率/數量清空
FUNCTION t325_du_data_to_correct()
 
   IF cl_null(g_imn[l_ac].imn33) THEN
      LET g_imn[l_ac].imn34 = NULL
      LET g_imn[l_ac].imn35 = NULL
      LET g_imn[l_ac].imn52 = NULL
   END IF
 
   IF cl_null(g_imn[l_ac].imn30) THEN
      LET g_imn[l_ac].imn31 = NULL
      LET g_imn[l_ac].imn32 = NULL
      LET g_imn[l_ac].imn51 = NULL
   END IF
 
   IF cl_null(g_imn[l_ac].imn43) THEN
      LET g_imn[l_ac].imn44 = NULL
      LET g_imn[l_ac].imn45 = NULL
      LET g_imn[l_ac].imn52 = NULL
   END IF
 
   IF cl_null(g_imn[l_ac].imn40) THEN
      LET g_imn[l_ac].imn41 = NULL
      LET g_imn[l_ac].imn42 = NULL
      LET g_imn[l_ac].imn51 = NULL
   END IF
 
   DISPLAY BY NAME g_imn[l_ac].imn33
   DISPLAY BY NAME g_imn[l_ac].imn34
   DISPLAY BY NAME g_imn[l_ac].imn35
   DISPLAY BY NAME g_imn[l_ac].imn30
   DISPLAY BY NAME g_imn[l_ac].imn31
   DISPLAY BY NAME g_imn[l_ac].imn32
   DISPLAY BY NAME g_imn[l_ac].imn43
   DISPLAY BY NAME g_imn[l_ac].imn44
   DISPLAY BY NAME g_imn[l_ac].imn45
   DISPLAY BY NAME g_imn[l_ac].imn40
   DISPLAY BY NAME g_imn[l_ac].imn41
   DISPLAY BY NAME g_imn[l_ac].imn42
END FUNCTION
 
#DEV-D30046 搬移至aimt325_sub.4gl --mark--begin
#FUNCTION t325_upd_s(p_ware,p_loc,p_lot,p_unit2,p_fac2,p_qty2,
#                    p_unit1,p_fac1,p_qty1,p_no,p_seq,p_type)  #撥出
#  DEFINE l_ima25   LIKE ima_file.ima25,
#         p_ware    LIKE img_file.img02,
#         p_loc     LIKE img_file.img03,
#         p_lot     LIKE img_file.img04,
#         p_unit2   LIKE img_file.img09,
#         p_fac2    LIKE img_file.img21,
#         p_qty2    LIKE img_file.img10,
#         p_unit1   LIKE img_file.img09,
#         p_fac1    LIKE img_file.img21,
#         p_qty1    LIKE img_file.img10,
#         p_no      LIKE imn_file.imn01,
#         p_seq     LIKE imn_file.imn02,
#         p_type    LIKE type_file.num5    #No.FUN-690026 SMALLINT
# 
#   SELECT ima906,ima907,ima25 INTO g_ima906,g_ima907,l_ima25 FROM ima_file
#    WHERE ima01 = b_imn.imn03
#   IF SQLCA.sqlcode THEN
#      LET g_success='N' RETURN
#   END IF
#   IF g_ima906 = '1' OR cl_null(g_ima906) THEN
#      RETURN
#   END IF
# 
#   IF g_ima906 = '2' THEN  #子母單位
#      IF NOT cl_null(p_qty2) THEN                            #CHI-860005
#         CALL t325_upd_imgg('1',b_imn.imn03,p_ware,p_loc,p_lot,p_unit2,p_fac2,p_qty2,-1,'2')
#         IF g_success='N' THEN RETURN END IF
#         IF p_type=1 THEN
#            CALL t325_tlff_1('2',b_imn.*,-1,p_ware,p_loc,p_lot,p_unit2,p_fac2,p_qty2,p_unit2,p_qty2,p_no,p_seq)
#            IF g_success='N' THEN RETURN END IF
#         END IF
#      END IF
#      IF NOT cl_null(p_qty1) THEN                            #CHI-860005
#         CALL t325_upd_imgg('1',b_imn.imn03,p_ware,p_loc,p_lot,p_unit1,p_fac1,p_qty1,-1,'1')
#         IF g_success='N' THEN RETURN END IF
#         IF p_type=1 THEN
#            CALL t325_tlff_1('1',b_imn.*,-1,p_ware,p_loc,p_lot,p_unit1,p_fac1,p_qty1,p_unit2,p_qty2,p_no,p_seq)
#            IF g_success='N' THEN RETURN END IF
#         END IF
#      END IF
#   END IF
#   IF g_ima906 = '3' THEN  #參考單位
#      IF NOT cl_null(p_qty2) THEN                            #CHI-860005
#         CALL t325_upd_imgg('2',b_imn.imn03,p_ware,p_loc,p_lot,p_unit2,p_fac2,p_qty2,-1,'2')
#         IF g_success = 'N' THEN RETURN END IF
#         IF p_type=1 THEN
#            CALL t325_tlff_1('2',b_imn.*,-1,p_ware,p_loc,p_lot,p_unit2,p_fac2,p_qty2,p_unit2,p_qty2,p_no,p_seq)
#            IF g_success='N' THEN RETURN END IF
#         END IF
#      END IF
#   END IF
# 
#END FUNCTION
# 
#FUNCTION t325_upd_t(p_ware,p_loc,p_lot,p_unit2,p_fac2,p_qty2,
#                    p_unit1,p_fac1,p_qty1,p_no,p_seq,p_type)  #撥入
#  DEFINE l_ima25   LIKE ima_file.ima25,
#         p_ware    LIKE img_file.img02,
#         p_loc     LIKE img_file.img03,
#         p_lot     LIKE img_file.img04,
#         p_unit2   LIKE img_file.img09,
#         p_fac2    LIKE img_file.img21,
#         p_qty2    LIKE img_file.img10,
#         p_unit1   LIKE img_file.img09,
#         p_fac1    LIKE img_file.img21,
#         p_qty1    LIKE img_file.img10,
#         p_no      LIKE imn_file.imn01,
#         p_seq     LIKE imn_file.imn02,
#         p_type    LIKE type_file.num5    #No.FUN-690026 SMALLINT
# 
#   SELECT ima906,ima907,ima25 INTO g_ima906,g_ima907,l_ima25 FROM ima_file
#    WHERE ima01 = b_imn.imn03
#   IF SQLCA.sqlcode THEN
#      LET g_success='N' RETURN
#   END IF
#   IF g_ima906 = '1' OR cl_null(g_ima906) THEN RETURN END IF
# 
#   IF g_ima906 = '2' THEN  #子母單位
#      IF NOT cl_null(p_qty2) THEN                        #CHI-860005
#         CALL t325_upd_imgg('1',b_imn.imn03,p_ware,p_loc,p_lot,p_unit2,p_fac2,p_qty2,+1,'2')
#         IF g_success='N' THEN RETURN END IF
#         IF p_type=1 THEN
#            CALL t325_tlff_2('2',b_imn.*,+1,p_ware,p_loc,p_lot,p_unit2,p_fac2,p_qty2,p_unit2,p_qty2,p_no,p_seq)
#            IF g_success='N' THEN RETURN END IF
#         END IF
#      END IF
#      IF NOT cl_null(p_qty1) THEN                        #CHI-860005
#         CALL t325_upd_imgg('1',b_imn.imn03,p_ware,p_loc,p_lot,p_unit1,p_fac1,p_qty1,+1,'1')
#         IF g_success='N' THEN RETURN END IF
#         IF p_type=1 THEN
#            CALL t325_tlff_2('1',b_imn.*,+1,p_ware,p_loc,p_lot,p_unit1,p_fac1,p_qty1,p_unit2,p_qty2,p_no,p_seq)
#            IF g_success='N' THEN RETURN END IF
#         END IF
#      END IF
#   END IF
#   IF g_ima906 = '3' THEN  #參考單位
#      IF NOT cl_null(p_qty2) THEN                        #CHI-860005
#         CALL t325_upd_imgg('2',b_imn.imn03,p_ware,p_loc,p_lot,p_unit2,p_fac2,p_qty2,+1,'2')
#         IF g_success = 'N' THEN RETURN END IF
#         IF p_type=1 THEN
#            CALL t325_tlff_2('2',b_imn.*,+1,p_ware,p_loc,p_lot,p_unit2,p_fac2,p_qty2,p_unit2,p_qty2,p_no,p_seq)
#            IF g_success='N' THEN RETURN END IF
#         END IF
#      END IF
#   END IF
# 
#END FUNCTION
# 
#FUNCTION t325_upd_imgg(p_imgg00,p_imgg01,p_imgg02,p_imgg03,p_imgg04,
#                       p_imgg09,p_imgg211,p_imgg10,p_type,p_no)
#  DEFINE p_imgg00   LIKE imgg_file.imgg00,
#         p_imgg01   LIKE imgg_file.imgg01,
#         p_imgg02   LIKE imgg_file.imgg02,
#         p_imgg03   LIKE imgg_file.imgg03,
#         p_imgg04   LIKE imgg_file.imgg04,
#         p_imgg09   LIKE imgg_file.imgg09,
#         p_imgg211  LIKE imgg_file.imgg211,
#         p_imgg10   LIKE imgg_file.imgg10,
#         p_no       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#         l_ima25    LIKE ima_file.ima25,
#         l_ima906   LIKE ima_file.ima906,
#         l_imgg21   LIKE imgg_file.imgg21,
#         p_type     LIKE type_file.num10    #No.FUN-690026 INTEGER
# 
#    LET g_forupd_sql =
#        "SELECT imgg01,imgg02,imgg03,imgg04,imgg09 FROM imgg_file ",
#        "   WHERE imgg01= ? AND imgg02= ? AND imgg03= ? AND imgg04= ? ",
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
#    FETCH imgg_lock INTO p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09
#    IF STATUS THEN
#       CALL cl_err('lock imgg fail',STATUS,1)
#       LET g_success='N'
#       CLOSE imgg_lock
#       RETURN
#    END IF
# 
#    SELECT ima25,ima906 INTO l_ima25,l_ima906
#      FROM ima_file WHERE ima01=p_imgg01
#    IF SQLCA.sqlcode OR l_ima25 IS NULL THEN
#       CALL cl_err3("sel","ima_file",p_imgg01,"",SQLCA.sqlcode,"","ima25 null",1) #No.FUN-660156
#       LET g_success = 'N' RETURN
#    END IF
# 
#    CALL s_umfchk(p_imgg01,p_imgg09,l_ima25)
#          RETURNING g_cnt,l_imgg21
#    IF g_cnt = 1 AND NOT (l_ima906='3' AND p_no='2') THEN
#       CALL cl_err('','mfg3075',0)
#       LET g_success = 'N' RETURN
#    END IF
# 
#    CALL s_upimgg(p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,p_type,p_imgg10,g_imm.imm02,#FUN-8C0083
#          '','','','','','','','',p_imgg09,'',l_imgg21,'','','','','','','',p_imgg211) #FUN-8C0083 ''-->p_imgg09
#    IF g_success='N' THEN RETURN END IF
# 
#END FUNCTION
# 
#FUNCTION t325_tlff_1(p_flag,p_imn,p_type,p_ware,p_loc,p_lot,p_unit,
#                     p_fac,p_qty,p_unit2,p_qty2,p_no,p_seq)
#DEFINE
#   p_imn      RECORD LIKE imn_file.*,
#   p_flag     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#   p_type     LIKE type_file.num5,    #No.FUN-690026 SMALLINT
#   p_ware     LIKE img_file.img02,
#   p_loc      LIKE img_file.img03,
#   p_lot      LIKE img_file.img04,
#   p_unit     LIKE img_file.img09,
#   p_fac      LIKE img_file.img21,
#   p_qty      LIKE img_file.img10,
#   p_unit2    LIKE img_file.img09,
#   p_qty2     LIKE img_file.img10,
#   p_no       LIKE imn_file.imn01,
#   p_seq      LIKE imn_file.imn02,
#   l_imgg10   LIKE imgg_file.imgg10
# 
#    IF p_unit IS NULL THEN
#       CALL cl_err('unit null:','asf-031',1) LET g_success = 'N' RETURN
#    END IF
# 
#    INITIALIZE g_tlff.* TO NULL
#    SELECT imgg10 INTO l_imgg10 FROM imgg_file
#     WHERE imgg01=p_imn.imn03  AND imgg02=p_ware
#       AND imgg03=p_loc        AND imgg04=p_lot
#       AND imgg09=p_unit
#    IF cl_null(l_imgg10) THEN LET l_imgg10=0 END IF
# 
#    LET g_tlff.tlff01=p_imn.imn03 	        #異動料件編號
#    #----來源----
#    LET g_tlff.tlff02 =50
#    LET g_tlff.tlff020=g_plant                  #工廠別
#    LET g_tlff.tlff021=p_ware        	        #倉庫別
#    LET g_tlff.tlff022=p_loc                    #儲位別
#    LET g_tlff.tlff023=p_lot               	#批號
#    LET g_tlff.tlff024=l_imgg10                 #異動後庫存數量
#    LET g_tlff.tlff025=p_unit                   #庫存單位(ima_file or img_file)
#    LET g_tlff.tlff026=p_no                     #調撥單號
#    LET g_tlff.tlff027=p_seq                    #項次
#    LET g_tlff.tlff03=99         	 	
#    LET g_tlff.tlff030=' '
#    LET g_tlff.tlff031=' '
#    LET g_tlff.tlff032=' '
#    LET g_tlff.tlff033=' '          	
#    LET g_tlff.tlff034=0
#    LET g_tlff.tlff035=' '
#    LET g_tlff.tlff036=' '
#    LET g_tlff.tlff037=0
# 
##--->異動數量
#    LET g_tlff.tlff04=' '                       #工作站
#    LET g_tlff.tlff05=' '                       #作業序號
#    LET g_tlff.tlff06=g_imm.imm02               #發料日期
#    LET g_tlff.tlff07=g_today                   #異動資料產生日期
#    LET g_tlff.tlff08=TIME                      #異動資料產生時:分:秒
#    LET g_tlff.tlff09=g_user                    #產生人
#    LET g_tlff.tlff10=p_qty                     #調撥數量
#    LET g_tlff.tlff11=p_unit                    #撥入單位
#    LET g_tlff.tlff12=p_fac                     #撥入/撥出庫存轉換率
#    LET g_tlff.tlff13='aimt325'                 #異動命令代號
#    LET g_tlff.tlff14=' '                       #異動原因
#    LET g_tlff.tlff15=' '                       #借方會計科目
#    LET g_tlff.tlff16=' '                       #貸方會計科目
#    LET g_tlff.tlff17=' '                       #remark
#    CALL s_imaQOH(p_imn.imn03)
#         RETURNING g_tlff.tlff18
#    LET g_tlff.tlff19= ' '                      #異動廠商/客戶編號
#    LET g_tlff.tlff20= ' '                      #project no.
#    LET g_tlff.tlff61= ' '                      #
#    LET g_tlff.tlff930=p_imn.imn9301            #FUN-670093
#    IF cl_null(p_qty2) OR p_qty2 = 0 THEN
#       CALL s_tlff(p_flag,NULL)
#    ELSE
#       CALL s_tlff(p_flag,p_unit2)
#    END IF
#END FUNCTION
# 
#FUNCTION t325_tlff_2(p_flag,p_imn,p_type,p_ware,p_loc,p_lot,p_unit,
#                     p_fac,p_qty,p_unit2,p_qty2,p_no,p_seq)
#DEFINE
#   p_imn      RECORD LIKE imn_file.*,
#   p_flag     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#   p_type     LIKE type_file.num5,    #No.FUN-690026 SMALLINT
#   p_ware     LIKE img_file.img02,
#   p_loc      LIKE img_file.img03,
#   p_lot      LIKE img_file.img04,
#   p_unit     LIKE img_file.img09,
#   p_fac      LIKE img_file.img21,
#   p_qty      LIKE img_file.img10,
#   p_unit2    LIKE img_file.img09,
#   p_qty2     LIKE img_file.img10,
#   p_no       LIKE imn_file.imn01,
#   p_seq      LIKE imn_file.imn02,
#   l_imgg10   LIKE imgg_file.imgg10
# 
#    IF p_unit IS NULL THEN
#       CALL cl_err('unit null:','asf-031',1) LET g_success = 'N' RETURN
#    END IF
# 
#    INITIALIZE g_tlff.* TO NULL
#    SELECT imgg10 INTO l_imgg10 FROM imgg_file   #撥出
#     WHERE imgg01=p_imn.imn03  AND imgg02=p_ware
#       AND imgg03=p_loc        AND imgg04=p_lot
#       AND imgg09=p_unit
#    IF cl_null(l_imgg10) THEN LET l_imgg10=0 END IF
# 
#    LET g_tlff.tlff01=p_imn.imn03 	        #異動料件編號
#    LET g_tlff.tlff02=99         	 	#來源為倉庫(撥出)
#    LET g_tlff.tlff03=50         	        #資料目的為(撥入)
#    LET g_tlff.tlff030=g_plant                  #工廠別
#    LET g_tlff.tlff031=p_ware                   #倉庫別
#    LET g_tlff.tlff032=p_loc                    #儲位別
#    LET g_tlff.tlff033=p_lot        	        #批號
#    LET g_tlff.tlff034=l_imgg10                 #異動後庫存量
#    LET g_tlff.tlff035=p_unit                  	#庫存單位(ima_file or img_file)
#    LET g_tlff.tlff036=p_no                     #參考號碼
#    LET g_tlff.tlff037=p_seq                    #項次
# 
##--->異動數量
#    LET g_tlff.tlff04=' '                       #工作站
#    LET g_tlff.tlff05=' '                       #作業序號
#    LET g_tlff.tlff06=g_imm.imm02               #發料日期
#    LET g_tlff.tlff07=g_today                   #異動資料產生日期
#    LET g_tlff.tlff08=TIME                      #異動資料產生時:分:秒
#    LET g_tlff.tlff09=g_user                    #產生人
#    LET g_tlff.tlff10=p_qty                     #調撥數量
#    LET g_tlff.tlff11=p_unit                    #撥入單位
#    LET g_tlff.tlff12=p_fac                     #撥入/撥出庫存轉換率
#    LET g_tlff.tlff13='aimt325'                 #異動命令代號
#    LET g_tlff.tlff14=' '                       #異動原因
#    LET g_tlff.tlff15=' '                       #借方會計科目
#    LET g_tlff.tlff16=' '                       #貸方會計科目
#    LET g_tlff.tlff17=' '                       #remark
#    CALL s_imaQOH(p_imn.imn03)
#         RETURNING g_tlff.tlff18
#    LET g_tlff.tlff19= ' '                      #異動廠商/客戶編號
#    LET g_tlff.tlff20= ' '                      #project no.
#    LET g_tlff.tlff61= ' '                      #
#    LET g_tlff.tlff930=p_imn.imn9302            #FUN-670093
#    IF cl_null(p_qty2) OR p_qty2 = 0 THEN
#       CALL s_tlff(p_flag,NULL)
#    ELSE
#       CALL s_tlff(p_flag,p_unit2)
#    END IF
#END FUNCTION
#DEV-D30046 搬移至aimt325_sub.4gl --mark--end
 
#對原來數量/換算率/單位的賦值
FUNCTION t325_set_origin_field()
  DEFINE    p_flag      LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
            l_ima906    LIKE ima_file.ima906,
            l_ima907    LIKE ima_file.ima907,
            l_tot       LIKE img_file.img10,
            l_img09_s   LIKE img_file.img09,
            l_img09_t   LIKE img_file.img09,
            l_fac1      LIKE img_file.img21,
            l_fac2      LIKE img_file.img21,
            l_fac3      LIKE img_file.img21,
            l_fac4      LIKE img_file.img21,
            l_qty1      LIKE img_file.img10,
            l_qty2      LIKE img_file.img10,
            l_qty3      LIKE img_file.img10,
            l_qty4      LIKE img_file.img10
 
   IF g_sma.sma115='N' THEN RETURN END IF
   LET l_qty1=g_imn[l_ac].imn35
   LET l_qty2=g_imn[l_ac].imn32
   LET l_qty3=g_imn[l_ac].imn45
   LET l_qty4=g_imn[l_ac].imn42
   LET l_fac1=g_imn[l_ac].imn34
   LET l_fac2=g_imn[l_ac].imn31
   LET l_fac3=g_imn[l_ac].imn44
   LET l_fac4=g_imn[l_ac].imn41
 
   IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
   IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
   IF cl_null(l_qty3) THEN LET l_qty3=0 END IF
   IF cl_null(l_qty4) THEN LET l_qty4=0 END IF
   IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
   IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
   IF cl_null(l_fac3) THEN LET l_fac3=1 END IF
   IF cl_null(l_fac4) THEN LET l_fac4=1 END IF
 
    #source
    SELECT img09 INTO l_img09_s FROM img_file
     WHERE img01 = g_imn[l_ac].imn03
       AND img02 = g_imn[l_ac].imn04
       AND img03 = g_imn[l_ac].imn05
       AND img04 = g_imn[l_ac].imn06
 
    #destination
    SELECT img09 INTO l_img09_t FROM img_file
     WHERE img01 = g_imn[l_ac].imn03
       AND img02 = g_imn[l_ac].imn15
       AND img03 = g_imn[l_ac].imn16
       AND img04 = g_imn[l_ac].imn17
 
    IF g_sma.sma115 = 'Y' THEN
       CASE g_ima906
          WHEN '1' LET g_imn[l_ac].imn09=l_img09_s
                   LET g_imn[l_ac].imn10=l_qty2*l_fac2
                   
                   LET g_imn[l_ac].imn20=l_img09_t
                   LET g_imn[l_ac].imn22=l_qty4*l_fac4
                   
          WHEN '2' LET l_tot=l_qty1*l_fac1+l_qty2*l_fac2
                   LET g_imn[l_ac].imn09=l_img09_s
                   LET g_imn[l_ac].imn10=l_tot

                   LET l_tot=l_qty3*l_fac3+l_qty4*l_fac4
                   LET g_imn[l_ac].imn20=l_img09_t
                   LET g_imn[l_ac].imn22=l_tot
          WHEN '3' LET g_imn[l_ac].imn09=l_img09_s
                   LET g_imn[l_ac].imn10=l_qty2*l_fac2
                   LET g_imn[l_ac].imn20=l_img09_t
                   LET g_imn[l_ac].imn22=l_qty4*l_fac4
                   IF l_qty1 <> 0 THEN
                      LET g_imn[l_ac].imn34=l_qty2/l_qty1
                   ELSE
                      LET g_imn[l_ac].imn34=0
                   END IF
                   IF l_qty3 <> 0 THEN
                      LET g_imn[l_ac].imn44=l_qty4/l_qty3
                   ELSE
                      LET g_imn[l_ac].imn44=0
                   END IF
       END CASE
       LET g_imn[l_ac].imn10 = s_digqty(g_imn[l_ac].imn10,g_imn[l_ac].imn09)   #No.FUN-BB0086
       LET g_imn[l_ac].imn22 = s_digqty(g_imn[l_ac].imn22,g_imn[l_ac].imn20)   #No.FUN-BB0086
    END IF
 
    IF g_imn[l_ac].imn09 <> g_imn[l_ac].imn20 THEN
       CALL s_umfchk(g_imn[l_ac].imn03,g_imn[l_ac].imn09,g_imn[l_ac].imn20)
            RETURNING g_cnt,g_imn[l_ac].imn21
    ELSE
       LET g_imn[l_ac].imn21 = 1
    END IF
 
END FUNCTION
 
FUNCTION t325_set_entry_b()
 
    CALL cl_set_comp_entry("imn33,imn35,imn43",TRUE)
 
END FUNCTION
 
FUNCTION t325_set_no_entry_b()
 
    IF g_ima906 = '1' THEN
       CALL cl_set_comp_entry("imn33,imn35,imn43",FALSE)
    END IF
    #參考單位，每個料件只有一個，所以不開放讓用戶輸入
    IF g_ima906 = '3' THEN
       CALL cl_set_comp_entry("imn33,imn43",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION t325_set_required()
 
  #兩組雙單位資料不是一定要全部輸入,但是參考單位的時候要全輸入
  IF g_ima906 = '3' THEN
     CALL cl_set_comp_required("imn33,imn35,imn30,imn32,imn43,imn45,imn40,imn42",TRUE)
  END IF
  #單位不空,轉換率,數量必KEY,KEY了來源,目的必KEY
  IF NOT cl_null(g_imn[l_ac].imn33) THEN
     CALL cl_set_comp_required("imn35,imn43,imn45",TRUE)
  END IF
  IF NOT cl_null(g_imn[l_ac].imn30) THEN
     CALL cl_set_comp_required("imn32,imn40,imn42",TRUE)
  END IF
  IF NOT cl_null(g_imn[l_ac].imn43) THEN
     CALL cl_set_comp_required("imn45,imn33,imn35",TRUE)
  END IF
  IF NOT cl_null(g_imn[l_ac].imn40) THEN
     CALL cl_set_comp_required("imn42,imn30,imn32",TRUE)
  END IF
 
END FUNCTION
 
FUNCTION t325_set_no_required()
 
  CALL cl_set_comp_required("imn33,imn34,imn35,imn30,imn31,imn32,imn43,imn44,imn45,imn40,imn41,imn42",FALSE)
 
END FUNCTION
 
#用于default 雙單位/轉換率/數量
FUNCTION t325_du_default(p_cmd,p_item,p_ware,p_loc,p_lot)
  DEFINE    p_item   LIKE img_file.img01,     #料號
            p_ware   LIKE img_file.img02,     #倉庫
            p_loc    LIKE img_file.img03,     #儲
            p_lot    LIKE img_file.img04,     #批
            l_ima25  LIKE ima_file.ima25,     #ima單位
            l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_img09  LIKE img_file.img09,     #img單位
            l_unit2  LIKE img_file.img09,     #第二單位
            l_fac2   LIKE img_file.img21,     #第二轉換率
            l_qty2   LIKE img_file.img10,     #第二數量
            l_unit1  LIKE img_file.img09,     #第一單位
            l_fac1   LIKE img_file.img21,     #第一轉換率
            l_qty1   LIKE img_file.img10,     #第一數量
            p_cmd    LIKE type_file.chr1,     #No.FUN-690026 VARCHAR(1)
            l_factor LIKE ima_file.ima31_fac  #No.FUN-690026 DECIMAL(16,8)
 
    SELECT ima25,ima906,ima907 INTO l_ima25,l_ima906,l_ima907
      FROM ima_file WHERE ima01 = p_item
 
    SELECT img09 INTO l_img09 FROM img_file
     WHERE img01 = p_item
       AND img02 = p_ware
       AND img03 = p_loc
       AND img04 = p_lot
    IF cl_null(l_img09) THEN LET l_img09 = l_ima25 END IF
 
    IF l_ima906 = '1' THEN  #不使用雙單位
       LET l_unit2 = NULL
       LET l_fac2  = NULL
       LET l_qty2  = NULL
    ELSE
       LET l_unit2 = l_ima907
       CALL s_du_umfchk(p_item,'','','',l_img09,l_ima907,l_ima906)
            RETURNING g_errno,l_factor
       LET l_fac2 = l_factor
       LET l_qty2 = 0
    END IF
    LET l_unit1 = l_img09
    LET l_fac1  = 1
    LET l_qty1  = 0
 
    RETURN l_unit2,l_fac2,l_qty2,l_unit1,l_fac1,l_qty1
END FUNCTION
 
 
FUNCTION t325_refresh_detail()                                                  
  DEFINE l_compare          LIKE smy_file.smy62                                 
  DEFINE li_col_count       LIKE type_file.num5                                                #No.FUN-690026 SMALLINT
  DEFINE li_i, li_j         LIKE type_file.num5                                                #No.FUN-690026 SMALLINT
  DEFINE lc_agb03           LIKE agb_file.agb03                                 
  DEFINE lr_agd             RECORD LIKE agd_file.*                              
  DEFINE lc_index           STRING                                              
  DEFINE ls_combo_vals      STRING                                              
  DEFINE ls_combo_txts      STRING                                              
  DEFINE ls_sql             STRING                                              
  DEFINE ls_show,ls_hide    STRING                                              
  DEFINE l_gae04            LIKE gae_file.gae04                                 
                                                                                
  IF ( g_sma.sma120 = 'Y' )AND( g_sma.sma907 = 'Y' )AND(NOT cl_null(lg_smy62)) THEN
     IF g_imn.getLength() = 0 THEN                                              
        LET lg_group = lg_smy62                                                 
     ELSE                           
       FOR li_i = 1 TO g_imn.getLength()                                        
         IF  cl_null(g_imn[li_i].att00) THEN                                    
            LET lg_group = ''                                                   
            EXIT FOR                                                            
         END IF                                                                 
         SELECT imaag INTO l_compare FROM ima_file WHERE ima01 = g_imn[li_i].att00
         IF cl_null(lg_group) THEN                                              
            LET lg_group = l_compare                                            
         ELSE                                                                   
           IF l_compare <> lg_group THEN                                        
              LET lg_group = ''                                                 
              EXIT FOR                                                          
           END IF                                                               
         END IF                                                                 
         IF lg_group <> lg_smy62 THEN                                           
            LET lg_group = ''                                                   
            EXIT FOR                                                            
         END IF    
       END FOR                                                                  
     END IF               
 
     SELECT COUNT(*) INTO li_col_count FROM agb_file WHERE agb01 = lg_group 
     SELECT gae04 INTO l_gae04 FROM gae_file                                    
       WHERE gae01 = 'aimt325' AND gae02 = 'imn03' AND gae03 = g_lang              
     CALL cl_set_comp_att_text("att00",l_gae04)     
     IF NOT cl_null(lg_group) THEN                                              
        LET ls_hide = 'imn03,ima02'                                             
        LET ls_show = 'att00'                                                   
     ELSE                                                                       
        LET ls_hide = 'att00'                                                   
        LET ls_show = 'imn03,ima02'                                             
     END IF                
     CALL lr_agc.clear() 
     FOR li_i = 1 TO li_col_count                                               
         SELECT agb03 INTO lc_agb03 FROM agb_file                               
           WHERE agb01 = lg_group AND agb02 = li_i                              
                                                                                
         LET lc_agb03 = lc_agb03 CLIPPED                                        
         SELECT * INTO lr_agc[li_i].* FROM agc_file                             
           WHERE agc01 = lc_agb03                                               
                                                                                
         LET lc_index = li_i USING '&&'                                         
                                                                                
         CASE lr_agc[li_i].agc04                                                
           WHEN '1'                                                             
             LET ls_show = ls_show || ",att" || lc_index                        
             LET ls_hide = ls_hide || ",att" || lc_index || "_c"                
             CALL cl_set_comp_att_text("att" || lc_index,lr_agc[li_i].agc02)    
                                                                                
                CALL cl_chg_comp_att("formonly.att" || lc_index,"NOT NULL|REQUIRED|SCROLL","1|1|1")
           WHEN '2'
             LET ls_show = ls_show || ",att" || lc_index || "_c"
             LET ls_hide = ls_hide || ",att" || lc_index 
             CALL cl_set_comp_att_text("att" || lc_index || "_c",lr_agc[li_i].agc02)
             LET ls_sql = "SELECT * FROM agd_file WHERE agd01 = '",lr_agc[li_i].agc01,"'"
             DECLARE agd_curs CURSOR FROM ls_sql
             LET ls_combo_vals = ""
             LET ls_combo_txts = ""
             FOREACH agd_curs INTO lr_agd.*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                IF ls_combo_vals IS NULL THEN
                   LET ls_combo_vals = lr_agd.agd02 CLIPPED
                ELSE
                   LET ls_combo_vals = ls_combo_vals,",",lr_agd.agd02 CLIPPED
                END IF
                IF ls_combo_txts IS NULL THEN
                   LET ls_combo_txts = lr_agd.agd02 CLIPPED,":",lr_agd.agd03 CLIPPED
                ELSE
                   LET ls_combo_txts = ls_combo_txts,",",lr_agd.agd02 CLIPPED,":",lr_agd.agd03 CLIPPED
                END IF
             END FOREACH
             CALL cl_set_combo_items("formonly.att" || lc_index || "_c",ls_combo_vals,ls_combo_txts)
             #這里需要判別g_sma.sma908,如果是允許新增子料件則要把這些屬性設置成為REQUIRED的,否則要設成NOENTRY
                CALL cl_chg_comp_att("formonly.att" || lc_index || "_c","NOT NULL|REQUIRED|SCROLL","1|1|1")
          WHEN '3'
             LET ls_show = ls_show || ",att" || lc_index
             LET ls_hide = ls_hide || ",att" || lc_index || "_c"
             CALL cl_set_comp_att_text("att" || lc_index,lr_agc[li_i].agc02)
             #這里需要判別g_sma.sma908,如果是允許新增子料件則要把這些屬性設置成為REQUIRED的,否則要設成NOENTRY
                CALL cl_chg_comp_att("formonly.att" || lc_index,"NOT NULL|REQUIRED|SCROLL","1|1|1")
       END CASE
     END FOR       
    
  ELSE
    #否則什么也不做(不顯示任何屬性列)
    LET li_i = 1
    #為了提高效率，把需要顯示和隱藏的欄位都放到各自的變量里，然后在結尾的地方一次性顯示或隱藏
    LET ls_hide = 'att00'
    LET ls_show = 'imn03'
  END IF
  
  #下面開始隱藏其他明細屬性欄位(從li_i開始)
  FOR li_j = li_i TO 10
      LET lc_index = li_j USING '&&'
      #注意att0x和att0x_c都要隱藏，別忘了_c的
      LET ls_hide = ls_hide || ",att" || lc_index || ",att" || lc_index || "_c"
  END FOR
 
  #這樣只用調兩次公共函數就可以解決問題了，效率應該會高一些
  CALL cl_set_comp_visible(ls_show, TRUE)
  CALL cl_set_comp_visible(ls_hide, FALSE)
 
END FUNCTION
 
#--------------------在修改下面的代碼前請讀一下注釋先，謝了! -----------------------
 
#下面代碼是從單身INPUT ARRAY語句中的AFTER FIELD段中拷貝來的，因為在多屬性新模式下原來的oea04料件編號
#欄位是要被隱藏起來，并由新增加的imx00（母料件編號）+各個明細屬性欄位來取代，所以原來的AFTER FIELD
#代碼是不會被執行到，需要執行的判斷應該放新增加的几個欄位的AFTER FIELD中來進行，因為要用多次嘛，所以
#單獨用一個FUNCTION來放，順便把imn03的AFTER FIELD也移過來，免得將來維護的時候遺漏了
#下標g_imn[l_ac]都被改成g_imn[p_ac]，請注意
 
#本函數返回TRUE/FALSE,表示檢核過程是否通過，一般說來，在使用過程中應該是如下方式□
#    AFTER FIELD XXX
#        IF NOT t325_check_imn03(.....)  THEN NEXT FIELD XXX END IF        
FUNCTION t325_check_imn03(p_field,p_ac)
DEFINE
  p_field                     STRING,    #當前是在哪個欄位中觸發了AFTER FIELD事件
  p_ac                        LIKE type_file.num5,    #g_imn數組中的當前記錄下標  #No.FUN-690026 SMALLINT
                              
  l_ps                        LIKE sma_file.sma46,
  l_str_tok                   base.stringTokenizer,
  l_tmp, ls_sql               STRING,
  l_param_list                STRING,
  l_cnt, li_i                 LIKE type_file.num5,    #No.FUN-690026 SMALLINT
  ls_value                    STRING,
  ls_pid,ls_value_fld         LIKE ima_file.ima01,
  ls_name, ls_spec            STRING, 
  lc_agb03                    LIKE agb_file.agb03,
  lc_agd03                    LIKE agd_file.agd03,
  ls_pname                    LIKE ima_file.ima02,
  l_misc                      LIKE type_file.chr4,    #No.FUN-690026 VARCHAR(04)
  l_n                         LIKE type_file.num5,    #No.FUN-690026 SMALLINT
  g_value                     LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(1000)
  l_b2                        LIKE ima_file.ima31,
  l_ima130                    LIKE ima_file.ima130,
  l_ima131                    LIKE ima_file.ima131,
  l_ima25                     LIKE ima_file.ima25,
  l_imaacti                   LIKE ima_file.imaacti,
  l_qty                       LIKE type_file.num10,   #No.FUN-690026 INTEGER
  l_multi                     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
  p_cmd                       STRING
 
  
  #如果當前欄位是新增欄位（母料件編號以及十個明細屬性欄位）的時候，如果全部輸了值則合成出一個
  #新的子料件編號并把值填入到已經隱藏起來的imn03中（如果imxXX能夠顯示，imn03一定是隱藏的）
  #下面就可以直接沿用imn03的檢核邏輯了
  #如果不是，則看看是不是imn03自己觸發了，如果還不是則什么也不做(無聊)，返回一個FALSE
  IF ( p_field = 'imx00' )OR( p_field = 'imx01' )OR( p_field = 'imx02' )OR
     ( p_field = 'imx03' )OR( p_field = 'imx04' )OR( p_field = 'imx05' )OR
     ( p_field = 'imx06' )OR( p_field = 'imx07' )OR( p_field = 'imx08' )OR
     ( p_field = 'imx09' )OR( p_field = 'imx10' ) THEN
     
     #首先判斷需要的欄位是否全部完成了輸入（只有母料件編號+被顯示出來的所有明細屬性
     #全部被輸入完成了才進行后續的操作
     LET ls_pid = g_imn[p_ac].att00   # ls_pid 父料件編號
     LET ls_value = g_imn[p_ac].att00   # ls_value 子料件編號
     IF cl_null(ls_pid) THEN 
        #MOD-640107 Add ,所有要返回TRUE的分支都要加這兩句話,原來下面的會被
        #注釋掉
        CALL t325_set_no_entry_b()
        CALL t325_set_required()
 
        RETURN TRUE 
     END IF  #注意這里沒有錯，所以返回TRUE
     
     #取出當前母料件包含的明細屬性的個數
     SELECT COUNT(*) INTO l_cnt FROM agb_file WHERE agb01 = 
        (SELECT imaag FROM ima_file WHERE ima01 = ls_pid)
     IF l_cnt = 0 THEN
        #MOD-640107 Add ,所有要返回TRUE的分支都要加這兩句話,原來下面的會被
        #注釋掉
        CALL t325_set_no_entry_b()
        CALL t325_set_required()
         
         RETURN TRUE  
     END IF
     
     FOR li_i = 1 TO l_cnt
         #如果有任何一個明細屬性應該輸而沒有輸的則退出
         IF cl_null(arr_detail[p_ac].imx[li_i]) THEN 
            #MOD-640107 Add ,所有要返回TRUE的分支都要加這兩句話,原來下面的會被
            #注釋掉
            CALL t325_set_no_entry_b()
            CALL t325_set_required()
            
            RETURN TRUE 
         END IF  
     END FOR
 
     #得到系統定義的標准分隔符sma46
     SELECT sma46 INTO l_ps FROM sma_file    
     
     #合成子料件的名稱
     SELECT ima02 INTO ls_pname FROM ima_file   # ls_name 父料件名稱
       WHERE ima01 = ls_pid
     LET ls_spec = ls_pname  # ls_spec 子料件名稱
     #方法□循環在agd_file中找有沒有對應記錄，如果有，就用該記錄的名稱來
     #替換初始名稱，如果找不到則就用原來的名稱
     FOR li_i = 1 TO l_cnt  
         LET lc_agd03 = ""
         LET ls_value = ls_value.trim(), l_ps, arr_detail[p_ac].imx[li_i]
         SELECT agd03 INTO lc_agd03 FROM agd_file
          WHERE agd01 = lr_agc[li_i].agc01 AND agd02 = arr_detail[p_ac].imx[li_i]
         IF cl_null(lc_agd03) THEN
            LET ls_spec = ls_spec.trim(),l_ps,arr_detail[p_ac].imx[li_i]
         ELSE
            LET ls_spec = ls_spec.trim(),l_ps,lc_agd03
         END IF
     END FOR     
     
     #解析ls_value生成要傳給cl_copy_bom的那個l_param_list
     LET l_str_tok = base.StringTokenizer.create(ls_value,l_ps)
     LET l_tmp = l_str_tok.nextToken()   #先把第一個部分--名稱去掉
 
     LET ls_sql = "SELECT agb03 FROM agb_file,ima_file WHERE ",
                  "ima01 = '",ls_pid CLIPPED,"' AND agb01 = imaag ",
                  "ORDER BY agb02"  
     DECLARE param_curs CURSOR FROM ls_sql
     FOREACH param_curs INTO lc_agb03
       #l_str_tok中的Tokens數量應該和param_curs中的記錄數量完全一致
       IF cl_null(l_param_list) THEN
          LET l_param_list = '#',lc_agb03,'#|',l_str_tok.nextToken()
       ELSE
          LET l_param_list = l_param_list,'|#',lc_agb03,'#|',l_str_tok.nextToken()
       END IF
     END FOREACH     
 
     #出貨單不允許新增ima_file里面沒有的子料件，故在此檢查一下                                                                   
     LET g_value =ls_value
     SELECT count(*) INTO l_n FROM ima_file
      WHERE ima01 = g_value
     IF l_n =0 THEN                                                                                                              
        CALL cl_err(ls_value,'atm-523',0)                                                                                        
        RETURN FALSE                                                                                                                   
     END IF
     
     #調用cl_copy_ima將新生成的子料件插入到數據庫中
     IF cl_copy_ima(ls_pid,ls_value,ls_spec,l_param_list) = TRUE THEN
        #如果向其中成功插入記錄則同步插入屬性記錄到imx_file中去
        LET ls_value_fld = ls_value 
#       #如果向imx_file中插入記錄失敗則也應將ima_file中已經建立的紀錄刪除以保証兩邊
#       #記錄的完全同步
        IF SQLCA.sqlcode THEN
           RETURN FALSE 
        END IF
     END IF 
     #把生成的子料件賦給imn03，否則下面的檢查就沒有意義了
     LET g_imn[p_ac].imn03 = ls_value
  ELSE 
    IF ( p_field <> 'imn03' )AND( p_field <> 'imx00' ) THEN 
       RETURN FALSE 
    END IF
  END IF
  
  #到這里已經完成了以前在cl_itemno_multi_att()中做的所有准備工作，在系統資料庫
  #中已經有了對應的子料件的名稱，下面可以按照imn03進行判斷了
  
  #--------重要 !!!!!!!!!!!-------------------------
  #下面的代碼都是從原INPUT ARRAY中的AFTER FIELD imn03段拷貝來的，唯一做的修改
  #是將原來的NEXT FIELD 語句都改成了RETURN FALSE, xxx,xxx ... ，因為NEXE FIELD
  #語句要交給調用方來做，這里只需要返回一個FALSE告訴它有錯誤就可以了，同時一起
  #返回的還有一些CHECK過程中要從ima_file中取得的欄位信息，其他的比如判斷邏輯和
  #錯誤提示都沒有改，如果你需要在里面添加代碼請注意上面的那個要點就可以了     
            IF NOT cl_null(g_imn[l_ac].imn03) THEN
               IF g_sma.sma120 = 'Y' THEN                                                                                          
                  LET l_multi = '4'
                  CALL cl_itemno_multi_att("imn03",g_imn[l_ac].imn03,"","1","3") RETURNING l_check,g_imn[l_ac].imn03,g_imn[l_ac].ima02
                  DISPLAY g_imn[l_ac].imn03 TO imn03                                                                               
                  DISPLAY g_imn[l_ac].ima02 TO ima02                                                                               
               END IF
               CALL t325_imn03('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('sel ima:',STATUS,0)
                  RETURN FALSE 
               END IF
              IF g_sma.sma115 = 'Y' THEN
                 CALL s_chk_va_setting(g_imn[l_ac].imn03)
                      RETURNING g_flag,g_ima906,g_ima907
                 IF g_flag=1 THEN
                    RETURN FALSE 
                 END IF
                 IF g_ima906 = '3' THEN
                    LET g_imn[l_ac].imn33=g_ima907
                    LET g_imn[l_ac].imn43=g_ima907
                 END IF
              END IF
            CALL t325_set_no_entry_b()
            CALL t325_set_required()
            RETURN TRUE  
           ELSE
            IF ( p_field = 'imn03' )OR( p_field = 'imx00' ) THEN
               CALL t325_set_no_entry_b()                                                                                                    
               CALL t325_set_required()
               RETURN TRUE
            ELSE
               RETURN FALSE
            END IF
   END IF
END FUNCTION
         
#用于att01~att10這十個輸入型屬性欄位的AFTER FIELD事件的判斷函數
#傳入參數:p_value 要比較的欄位內容,p_index當前欄位的索引號(從1~10表示att01~att10)
#         p_row是當前行索引,傳入INPUT ARRAY中使用的l_ac即可
#與t325_check_imn03相同,如果檢查過程中如果發現錯誤,則報錯并返回一個FALSE
#而AFTER FIELD的時候檢測到這個返回值則會做NEXT FIELD
FUNCTION t325_check_att0x(p_value,p_index,p_row)
DEFINE
  p_value         LIKE imx_file.imx01,
  p_index         LIKE type_file.num5,    #No.FUN-690026 SMALLINT
  p_row           LIKE type_file.num5,    #No.FUN-690026 SMALLINT
  li_min_num      LIKE agc_file.agc05,
  li_max_num      LIKE agc_file.agc06,
  l_index         STRING,
  l_check_res     LIKE type_file.num5,    #No.FUN-690026 SMALLINT
  l_imaacti       LIKE ima_file.imaacti,
  l_ima130        LIKE ima_file.ima130,   #FUN-660078
  l_ima131        LIKE ima_file.ima131,   #FUN-660078
  l_ima25         LIKE ima_file.ima25 
  
  #這個欄位一旦進入了就不能忽略，因為要保証在輸入其他欄位之前必須要生成imn03料件編號
  IF cl_null(p_value) THEN 
     RETURN FALSE 
  END IF
 
  #這里使用到了一個用于存放當前屬性組包含的所有屬性信息的全局數組lr_agc
  #該數組會由t325_refresh_detail()函數在較早的時候填充
  
  #判斷長度與定義的使用位數是否相等
  IF LENGTH(p_value CLIPPED) <> lr_agc[p_index].agc03 THEN
     CALL cl_err_msg("","aim-911",lr_agc[p_index].agc03,1)
     RETURN FALSE 
  END IF
  #比較大小是否在合理范圍之內
  LET li_min_num = lr_agc[p_index].agc05
  LET li_max_num = lr_agc[p_index].agc06
  IF (lr_agc[p_index].agc05 IS NOT NULL) AND
     (p_value < li_min_num) THEN
     CALL cl_err_msg("","lib-232",lr_agc[p_index].agc05 || "|" || lr_agc[p_index].agc06,1)
     RETURN FALSE
  END IF
  IF (lr_agc[p_index].agc06 IS NOT NULL) AND
     (p_value > li_max_num) THEN
     CALL cl_err_msg("","lib-232",lr_agc[p_index].agc05 || "|" || lr_agc[p_index].agc06,1)
     RETURN FALSE 
  END IF
  #通過了欄位檢查則可以下面的合成子料件代碼以及相應的檢核操作了
  LET arr_detail[p_row].imx[p_index] = p_value
  LET l_index = p_index USING '&&'
  CALL t325_check_imn03('imx' || l_index ,p_row) 
    RETURNING l_check_res 
    RETURN l_check_res 
END FUNCTION
 
#用于att01_c~att10_c這十個選擇型屬性欄位的AFTER FIELD事件的判斷函數
#傳入參數:p_value 要比較的欄位內容,p_index當前欄位的索引號(從1~10表示att01~att10)
#         p_row是當前行索引,傳入INPUT ARRAY中使用的l_ac即可
#與t325_check_imn03相同,如果檢查過程中如果發現錯誤,則報錯并返回一個FALSE
#而AFTER FIELD的時候檢測到這個返回值則會做NEXT FIELD
FUNCTION t325_check_att0x_c(p_value,p_index,p_row)
DEFINE
  p_value  LIKE imx_file.imx01,
  p_index  LIKE type_file.num5,    #No.FUN-690026 SMALLINT
  p_row    LIKE type_file.num5,    #No.FUN-690026 SMALLINT
  l_index  STRING,
 
  l_check_res     LIKE type_file.num5,    #No.FUN-690026 SMALLINT
  l_imaacti       LIKE ima_file.imaacti,
  l_ima130        LIKE ima_file.ima130,   #FUN-660078
  l_ima131        LIKE ima_file.ima131,   #FUN-660078
  l_ima25         LIKE ima_file.ima25
 
 
  #這個欄位一旦進入了就不能忽略，因為要保証在輸入其他欄位之前必須要生成imn03料件編號
  IF cl_null(p_value) THEN 
     RETURN FALSE
  END IF       
  #下拉框選擇項相當簡單，不需要進行范圍和長度的判斷，因為肯定是符合要求的了  
  LET arr_detail[p_row].imx[p_index] = p_value
  LET l_index = p_index USING '&&'
  CALL t325_check_imn03('imx'||l_index,p_row)
  RETURNING l_check_res 
  RETURN l_check_res
END FUNCTION         
    
FUNCTION t325_spc()
DEFINE l_gaz03        LIKE gaz_file.gaz03
DEFINE l_cnt          LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE l_qc_cnt       LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE l_imn02        LIKE imn_file.imn02    ## 項次
DEFINE l_qcs          DYNAMIC ARRAY OF RECORD LIKE qcs_file.*
DEFINE l_qc_prog      LIKE zz_file.zz01      #No.FUN-690026 VARCHAR(10)
DEFINE l_i            LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE l_cmd          STRING
DEFINE l_sql          STRING
DEFINE l_err          STRING
 
   LET g_success = 'Y'
 
   #檢查資料是否可拋轉至 SPC
   IF g_imm.imm04 matches '[Yy]' THEN    #判斷是否已過帳
      CALL cl_err('imm04','aim-318',0)
      LET g_success='N'
      RETURN
   END IF
 
   #CALL aws_spccli_check('單號','SPC拋轉碼','確認碼','有效碼')
   CALL aws_spccli_check(g_imm.imm01,g_imm.immspc,'','')
   IF g_success = 'N' THEN
      RETURN
   END IF
 
   LET l_qc_prog = "aqct700"               #設定QC單的程式代號
 
   #若在 QC 單已有此單號相關資料，則取消拋轉至 SPC
   SELECT COUNT(*) INTO l_cnt FROM qcs_file WHERE qcs01 = g_imm.imm01  
   IF l_cnt > 0 THEN
      CALL cl_get_progname(l_qc_prog,g_lang) RETURNING l_gaz03
      CALL cl_err_msg(g_imm.imm01,'aqc-115', l_gaz03 CLIPPED || "|" || l_qc_prog CLIPPED,'1')
      LET g_success='N'
      RETURN
   END IF
  
   #需要 QC 檢驗的筆數
   SELECT COUNT(*) INTO l_qc_cnt FROM imn_file 
    WHERE imn01 = g_imm.imm01 AND imn29 = 'Y' 
   IF l_qc_cnt = 0 THEN 
      CALL cl_err(g_imm.imm01,l_err,0) 
      LET g_success='N'
      RETURN
   END IF
 
   #需檢驗的資料，自動新增資料至 QC 單 ,功能參數為「SPC」
   LET l_sql  = "SELECT imn02 FROM imn_file 
                  WHERE imn01 = '",g_imm.imm01,
                "  AND imn29='Y'"
   PREPARE t325_imn_p FROM l_sql
   DECLARE t325_imn_c CURSOR WITH HOLD FOR t325_imn_p
   FOREACH t325_imn_c INTO l_imn02
       display l_cmd
       LET l_cmd = l_qc_prog CLIPPED," '",g_imm.imm01,"' '",l_imn02,"' '1' 'SPC' 'C'"
       CALL aws_spccli_qc(l_qc_prog,l_cmd)
   END FOREACH 
 
   #判斷產生的 QC 單筆數是否正確
   SELECT COUNT(*) INTO l_cnt FROM qcs_file WHERE qcs01 = g_imm.imm01
   IF l_cnt <> l_qc_cnt THEN
      CALL t325_qcs_del()
      LET g_success='N'
      RETURN
   END IF
 
   LET l_sql  = "SELECT *  FROM qcs_file WHERE qcs01 = '",g_imm.imm01,"'"
   PREPARE t325_qc_p FROM l_sql
   DECLARE t325_qc_c CURSOR WITH HOLD FOR t325_qc_p
   LET l_cnt = 1
   FOREACH t325_qc_c INTO l_qcs[l_cnt].*
       LET l_cnt = l_cnt + 1 
   END FOREACH
   CALL l_qcs.deleteElement(l_cnt)
 
   # CALL aws_spccli() 
   #功能: 傳送此單號所有的 QC 單至 SPC 端
   # 傳入參數: (1) QC 程式代號, (2) QC 單頭資料,
   # 回傳值  : 0 傳送失敗; 1 傳送成功
   IF aws_spccli(l_qc_prog,base.TypeInfo.create(l_qcs),"insert") THEN
      LET g_imm.immspc = '1'
   ELSE
      LET g_imm.immspc = '2'
      CALL t325_qcs_del()
   END IF
 
   UPDATE imm_file set immspc = g_imm.immspc WHERE imm01 = g_imm.imm01 
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","imm_file",g_imm.imm01,"",STATUS,"","upd immspc",1)
      IF g_imm.immspc = '1' THEN
          CALL t325_qcs_del()
      END IF
      LET g_success = 'N'
   END IF
   DISPLAY BY NAME g_imm.immspc
  
END FUNCTION 
 
FUNCTION t325_qcs_del()
 
      DELETE FROM qcs_file WHERE qcs01 = g_imm.imm01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","qcs_file",g_imm.imm01,"",SQLCA.sqlcode,"","DEL qcs_file err!",0)
      END IF
 
      DELETE FROM qct_file WHERE qct01 = g_imm.imm01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","qct_file",g_imm.imm01,"",SQLCA.sqlcode,"","DEL qct_file err!",0)
      END IF
 
      DELETE FROM qctt_file WHERE qctt01 = g_imm.imm01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","qctt_file",g_imm.imm01,"",SQLCA.sqlcode,"","DEL qcstt_file err!",0)
      END IF
 
      DELETE FROM qcv_file WHERE qcv01 = g_imm.imm01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","qcv_file",g_imm.imm01,"",SQLCA.sqlcode,"","DEL qcv_file err!",0)
      END IF
 
END FUNCTION 
 

#CHI-C30002 -------- add -------- begin
FUNCTION i000_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_imm.imm01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM imm_file ",
                  "  WHERE imm01 LIKE '",l_slip,"%' ",
                  "    AND imm01 > '",g_imm.imm01,"'"
      PREPARE t325_pb1 FROM l_sql 
      EXECUTE t325_pb1 INTO l_cnt 
      
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
        #CALL t325_x()   #CHI-D20010
         CALL t325_x(1)  #CHI-D20010
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  CHI-C80041
         DELETE FROM  imm_file WHERE imm01 = g_imm.imm01
         INITIALIZE g_imm.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION i000_delall()
#
#  SELECT COUNT(*) INTO g_cnt FROM imn_file
#   WHERE imn01 = g_imm.imm01 
#
#  IF g_cnt = 0 THEN
#     CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#     ERROR g_msg CLIPPED
#     DELETE FROM imm_file WHERE imm01 = g_imm.imm01
#     CLEAR FORM
#     INITIALIZE g_imm.* TO NULL
#     CALL g_imn.clear()
#  END IF
#
#END FUNCTION
#CHI-C30002 -------- mark -------- end
#No.FUN-9C0072 精簡程式碼

#FUN-A40022--begin--add----                                                                                                         
FUNCTION t325_set_required_1(p_cmd)                                                                                             
#DEFINE l_imaicd13 LIKE imaicd_file.imaicd13  #FUN-B50096                                                                                       
DEFINE l_ima159   LIKE ima_file.ima159        #FUN-B50096
DEFINE p_cmd      LIKE type_file.chr1                                                                                               
                                                                                                                                    
   IF p_cmd='u' OR INFIELD(imn03) THEN                                                                                              
      IF NOT cl_null(g_imn[l_ac].imn03) THEN                                                                                        
#FUN-B50096 -------------------Begin------------------
#        SELECT imaicd13 INTO l_imaicd13 FROM imaicd_file                                                                           
#         WHERE imaicd00 = g_imn[l_ac].imn03                                                                                        
#        IF l_imaicd13 = 'Y' THEN                                                                                                   
         SELECT ima159 INTO l_ima159 FROM ima_file
          WHERE ima01  = g_imn[l_ac].imn03
         IF l_ima159 = '1' THEN
#FUN-B50096 -------------------End--------------------
            CALL cl_set_comp_required("imn06,imn17",TRUE)                                                                                 
         END IF                                                                                                                     
      END IF                                                                                                                        
   END IF                                                                                                                           
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION t325_set_no_required_1()                                                                                               
     CALL cl_set_comp_required("imn06,imn17",FALSE)                                                                                       
END FUNCTION
#FUN-A40022--end--add----------

#FUN-B50096 ----------------Begin-----------------
FUNCTION t325_set_no_entry_imn()
   DEFINE l_ima159    LIKE ima_file.ima159
   IF l_ac > 0 THEN
      IF NOT cl_null(g_imn[l_ac].imn03) THEN
         SELECT ima159 INTO l_ima159 FROM ima_file
          WHERE ima01  = g_imn[l_ac].imn03
         IF l_ima159 = '2' THEN
            CALL cl_set_comp_entry("imn06,imn17",FALSE)
         ELSE
            CALL cl_set_comp_entry("imn06,imn17",TRUE)
         END IF
      END IF
   END IF
END FUNCTION

FUNCTION t325_set_entry_imn()
   CALL cl_set_comp_entry("imn06,imn17",TRUE)
END FUNCTION
#FUN-B50096 ----------------End-------------------

#No.MOD-AA0086  --Begin
#DEV-D30046 搬移至aimt325_sub.4gl --mark--begin
#FUNCTION t325_ins_rvbs()
#   DEFINE l_rvbs       RECORD LIKE rvbs_file.*
#   DEFINE l_ima918     LIKE ima_file.ima918
#   DEFINE l_ima921     LIKE ima_file.ima921
#
#   SELECT ima918,ima921 INTO l_ima918,l_ima921
#     FROM ima_file
#    WHERE ima01 = b_imn.imn03
#      AND imaacti = "Y"
#
#   IF cl_null(l_ima918) THEN
#      LET l_ima918='N'
#   END IF
#
#   IF cl_null(l_ima921) THEN
#      LET l_ima921='N'
#   END IF
#
#   IF l_ima918 = "N" AND l_ima921 = "N" THEN
#      RETURN
#   END IF
#
#   DELETE FROM rvbs_file WHERE rvbs00 = g_prog
#                           AND rvbs01 = g_imm.imm11
#                           AND rvbs02 = b_imn.imn02
#                           AND rvbs13 = 0
#                           AND rvbs09 = 1
#
#   DECLARE t325_g_rvbs CURSOR FOR SELECT * FROM rvbs_file
#                                   WHERE rvbs00 = 'aimt325'
#                                     AND rvbs01 = g_imm.imm01
#                                     AND rvbs02 = b_imn.imn02
#                                     AND rvbs13 = 0
#                                     AND rvbs09 = -1
#
#   FOREACH t325_g_rvbs INTO l_rvbs.*
#      IF STATUS THEN                    
#         CALL cl_err('rvbs',STATUS,1)
#      END IF
#
#      LET l_rvbs.rvbs00 = g_prog
#      LET l_rvbs.rvbs01 = g_imm.imm11
#      LET l_rvbs.rvbs09 = 1
#      LET l_rvbs.rvbsplant = g_plant #FUN-980004 add
#      LET l_rvbs.rvbslegal = g_legal #FUN-980004 add
#
#      INSERT INTO rvbs_file VALUES(l_rvbs.*)
#      IF STATUS OR SQLCA.SQLCODE THEN
#         CALL cl_err3("ins","rvbs_file","","",SQLCA.sqlcode,"","ins rvbs",1)
#         LET g_success='N'
#      END IF
#
#   END FOREACH
#
#END FUNCTION
#
#FUNCTION t325_del_tlfs(p_ware,p_loc,p_lot,p_type,p_no,p_date)
#   DEFINE p_ware       LIKE img_file.img02
#   DEFINE p_loc        LIKE img_file.img03
#   DEFINE p_lot        LIKE img_file.img04
#   DEFINE p_type       LIKE type_file.num5
#   DEFINE p_no         LIKE imm_file.imm01
#   DEFINE p_date       LIKE type_file.dat
#   DEFINE l_ima918     LIKE ima_file.ima918
#   DEFINE l_ima921     LIKE ima_file.ima921
#
#   SELECT ima918,ima921 INTO l_ima918,l_ima921
#     FROM ima_file
#    WHERE ima01 = b_imn.imn03
#      AND imaacti = "Y"
#
#   IF cl_null(l_ima918) THEN
#      LET l_ima918='N'
#   END IF
#
#   IF cl_null(l_ima921) THEN
#      LET l_ima921='N'
#   END IF
#
#   IF l_ima918 = "N" AND l_ima921 = "N" THEN
#      RETURN
#   END IF
#
#   IF g_bgjob = 'N' THEN
#      MESSAGE "d_tlfs!"
#   END IF
#
#   CALL ui.Interface.refresh()
#
#   DELETE FROM tlfs_file
#    WHERE tlfs01 = b_imn.imn03
#      AND tlfs02 = p_ware
#      AND tlfs03 = p_loc 
#      AND tlfs04 = p_lot 
#      AND tlfs09 = p_type
#      AND tlfs10 = p_no
#      AND tlfs11 = b_imn.imn02
#      AND tlfs111= p_date
#
#   IF STATUS THEN
#      IF g_bgerr THEN
#         LET g_showmsg = b_imn.imn03,'/',g_imm.imm02
#         CALL s_errmsg('tlfs01,tlfs111',g_showmsg,'del tlfs:',STATUS,1)
#      ELSE
#         CALL cl_err3("del","tlfs_file",g_imm.imm01,"",STATUS,"","del tlfs",1)
#      END IF
#      LET g_success='N'
#      RETURN
#   END IF
#
#   IF SQLCA.SQLERRD[3]=0 THEN  
#      IF g_bgerr THEN
#         LET g_showmsg = b_imn.imn03,'/',p_date
#         CALL s_errmsg('tlfs01,tlfs111',g_showmsg,'del tlfs:','mfg0177',1)
#      ELSE
#         CALL cl_err3("del","tlfs_file",g_imm.imm01,"","mfg0177","","del tlfs",1)
#      END IF
#      LET g_success='N'
#      RETURN
#   END IF
#END FUNCTION
#
#FUNCTION t325_chk_qty()
#   DEFINE l_rvbs06    LIKE rvbs_file.rvbs06
#   DEFINE l_rvbs09    LIKE rvbs_file.rvbs09
#   DEFINE l_rvbs01    LIKE rvbs_file.rvbs01
#
#   LET g_ima918 = ''   #DEV-D30040 add
#   LET g_ima921 = ''   #DEV-D30040 add
#   LET g_ima930 = ''   #DEV-D30040 add
#   SELECT ima918,ima921,ima930 INTO g_ima918,g_ima921,g_ima930 #DEV-D30040 add ima930,g_ima930
#     FROM ima_file
#    WHERE ima01 = b_imn.imn03
#      AND imaacti = "Y"
#
#   IF cl_null(g_ima930) THEN LET g_ima930 = 'N' END IF  #DEV-D30040 add
#
#   IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
#      IF g_prog = 'aimt325' THEN
#         LET l_rvbs09 = -1
#         LET l_rvbs01 = g_imm.imm01
#      ELSE
#         LET l_rvbs09 = 1
#         LET l_rvbs01 = g_imm.imm11
#      END IF
#      SELECT SUM(rvbs06) INTO l_rvbs06
#        FROM rvbs_file
#       WHERE rvbs00 = g_prog
#         AND rvbs01 = l_rvbs01
#         AND rvbs02 = b_imn.imn02
#         AND rvbs09 = l_rvbs09
#         AND rvbs13 = 0
#
#      IF cl_null(l_rvbs06) THEN
#         LET l_rvbs06 = 0
#      END IF
#
#      IF (g_ima930 = 'Y' and l_rvbs06 <> 0) OR g_ima930 = 'N' THEN  #DEV-D30040
#         IF b_imn.imn10 <> l_rvbs06 THEN
#            CALL cl_err(b_imn.imn03,"aim-011",1)
#            RETURN FALSE
#         END IF
#      END IF                                                        #DEV-D30040
#   END IF
#   RETURN TRUE
#END FUNCTION
#
#FUNCTION t325_del_rvbs()
#   DEFINE l_ima918     LIKE ima_file.ima918
#   DEFINE l_ima921     LIKE ima_file.ima921
#
#   SELECT ima918,ima921 INTO l_ima918,l_ima921
#     FROM ima_file
#    WHERE ima01 = b_imn.imn03
#      AND imaacti = "Y"
#
#   IF cl_null(l_ima918) THEN
#      LET l_ima918='N'
#   END IF
#
#   IF cl_null(l_ima921) THEN
#      LET l_ima921='N'
#   END IF
#
#   IF l_ima918 = "N" AND l_ima921 = "N" THEN
#      RETURN
#   END IF
#
#   IF g_bgjob = 'N' THEN
#      MESSAGE "d_rvbs!"
#   END IF
#
#   CALL ui.Interface.refresh()
#
#   DELETE FROM rvbs_file WHERE rvbs00 = g_prog
#                           AND rvbs01 = g_imm.imm11
#                           AND rvbs02 = b_imn.imn02
#                           AND rvbs13 = 0
#                           AND rvbs09 = 1
#   IF STATUS THEN   
#      IF g_bgerr THEN
#         LET g_showmsg = g_imm.imm11,'/',b_imn.imn02
#         CALL s_errmsg('rvbs01,rvbs02',g_showmsg,'del rvbs:',STATUS,1)
#      ELSE
#         CALL cl_err3("del","rvbs_file",g_imm.imm11,b_imn.imn02,STATUS,"","del rvbs",1)
#      END IF
#      LET g_success='N'
#      RETURN
#   END IF
#
#   IF SQLCA.SQLERRD[3]=0 THEN
#      IF g_bgerr THEN
#         LET g_showmsg = g_imm.imm11,'/',b_imn.imn02
#         CALL s_errmsg('rvbs01,rvbs02',g_showmsg,'del rvbs:',STATUS,1)
#      ELSE
#         CALL cl_err3("del","rvbs_file",g_imm.imm11,b_imn.imn02,STATUS,"","del rvbs",1)
#      END IF
#      LET g_success='N'
#      RETURN
#   END IF
#END FUNCTION
##No.MOD-AA0086  --End
#DEV-D30046 搬移至aimt325_sub.4gl --mark--end

#No.FUN-BB0086---add---begin---
FUNCTION i325_imn32_check(p_cmd)
   DEFINE p_cmd  LIKE type_file.chr1
   IF NOT cl_null(g_imn[l_ac].imn32) AND NOT cl_null(g_imn[l_ac].imn30) THEN
      IF cl_null(g_imn_t.imn32) OR cl_null(g_imn30_t) OR g_imn_t.imn32 != g_imn[l_ac].imn32 OR g_imn30_t != g_imn[l_ac].imn30 THEN
         LET g_imn[l_ac].imn32=s_digqty(g_imn[l_ac].imn32,g_imn[l_ac].imn30)
         DISPLAY BY NAME g_imn[l_ac].imn32
      END IF
   END IF

   IF NOT cl_null(g_imn[l_ac].imn32) THEN
      IF g_imn[l_ac].imn32 < 0 THEN
         CALL cl_err('','aim-391',0)  #
         RETURN FALSE,'imn32'
      END IF
      IF NOT cl_null(g_imn[l_ac].imn30) THEN
         IF g_ima906 = '2' THEN
            IF g_sma.sma117 = 'N' THEN
               IF g_imn[l_ac].imn32 > g_imgg10_1 THEN
                 #IF g_sma.sma894[4,4]='N' OR g_sma.sma894[4,4] IS NULL THEN  #FUN-C80107 mark
                  LET g_flag1 = NULL    #FUN-C80107 add
                  #CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_imn[l_ac].imn04) RETURNING g_flag1   #FUN-C80107 add #FUN-D30024--mark
                  CALL s_inv_shrt_by_warehouse(g_imn[l_ac].imn04,g_plant) RETURNING g_flag1    #FUN-D30024--add  #TQC-D40078 g_plant
                  IF g_flag1 = 'N' OR g_flag1 IS NULL THEN   #FUN-C80107 add
                     CALL cl_err(g_imn[l_ac].imn32,'mfg1303',1)
                     RETURN FALSE,'imn32'
                  ELSE
                     IF NOT cl_confirm('mfg3469') THEN
                        RETURN FALSE,'imn32'
                     ELSE
                        LET g_yes = 'Y'
                     END IF
                  END IF
               END IF
            END IF
         ELSE
            IF g_imn[l_ac].imn32 * g_imn[l_ac].imn31 > g_imgg10_1 THEN
              #IF g_sma.sma894[4,4]='N' OR g_sma.sma894[4,4] IS NULL THEN   #FUN-C80107 mark
               LET g_flag1 = NULL    #FUN-C80107 add
               #CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_imn[l_ac].imn04) RETURNING g_flag1   #FUN-C80107 add #FUN-D30024--mark
               CALL s_inv_shrt_by_warehouse(g_imn[l_ac].imn04,g_plant) RETURNING g_flag1         #FUN-D30024--add #TQC-D40078 g_plant
               IF g_flag1 = 'N' OR g_flag1 IS NULL THEN   #FUN-C80107 add
                  CALL cl_err(g_imn[l_ac].imn32,'mfg1303',1)
                  RETURN FALSE,'imn32'
               ELSE
                  IF NOT cl_confirm('mfg3469') THEN
                     RETURN FALSE,'imn32'
                  ELSE
                     LET g_yes = 'Y'
                  END IF
               END IF
            END IF
         END IF
      END IF
   END IF
   #No.MOD-AA0086  --Begin
   LET g_ima918 = ''   #DEV-D30059 add
   LET g_ima921 = ''   #DEV-D30059 add
   LET g_ima930 = ''   #DEV-D30059 add
   SELECT ima918,ima921,ima930 INTO g_ima918,g_ima921,g_ima930 #DEV-D30059 add ima930
     FROM ima_file
    WHERE ima01 = g_imn[l_ac].imn03
      AND imaacti = "Y"
 
   IF cl_null(g_ima930) THEN LET g_ima930 = 'N' END IF  #DEV-D30059 add

   IF (g_ima918 = "Y" OR g_ima921 = "Y") AND
      (p_cmd = 'a' OR g_imn[l_ac].imn35<>g_imn_t.imn35 OR g_imn[l_ac].imn32 <> g_imn_t.imn32 ) THEN
      IF g_prog = 'aimt325' THEN
        #CALL s_lotout(g_prog,g_imm.imm01,g_imn[l_ac].imn02,0,              #TQC-B90236 mark
         IF g_ima930 = 'N' THEN                                             #DEV-D30059
            CALL s_mod_lot(g_prog,g_imm.imm01,g_imn[l_ac].imn02,0,          #TQC-B90236 add
                          g_imn[l_ac].imn03,g_imn[l_ac].imn04,
                          g_imn[l_ac].imn05,g_imn[l_ac].imn06,
                          g_imn[l_ac].imn09,g_imn[l_ac].imn09,1,
                          g_imn[l_ac].imn10,'','MOD',-1) #CHI-9A0022 add '' #TQC-B90236 add '-1'
                RETURNING l_r,g_qty
         END IF                                                          #DEV-D30059
         IF l_r = "Y" THEN
            LET g_imn[l_ac].imn10 = g_qty
            LET g_imn[l_ac].imn10 = s_digqty(g_imn[l_ac].imn10,g_imn[l_ac].imn09)   #No.FUN-BB0086
         END IF
         LET g_imn[l_ac].imn22 = g_imn[l_ac].imn10 * g_imn[l_ac].imn21
         LET g_imn[l_ac].imn22 = s_digqty(g_imn[l_ac].imn22,g_imn[l_ac].imn20)   #No.FUN-BB0086
         DISPLAY BY NAME g_imn[l_ac].imn22
      END IF
   END IF
   #No.MOD-AA0086  --End  
 
   CALL t325_du_data_to_correct()
   CALL t325_set_origin_field()
   IF g_imn[l_ac].imn10 <= 0 THEN
      CALL cl_err('','mfg9105',0)
      IF g_ima906 MATCHES '[23]' THEN
         RETURN FALSE,'imn35'
      ELSE
         RETURN FALSE,'imn32'
      END IF
   END IF
   IF cl_null(g_imn[l_ac].imn09) THEN
      CALL cl_err('set origin',SQLCA.sqlcode,1)
      IF g_ima906 MATCHES '[23]' THEN
         RETURN FALSE,'imn35'
      ELSE
         RETURN FALSE,'imn32'
      END IF
   END IF
   IF t325_qty_issue() THEN
      IF g_ima906 MATCHES '[23]' THEN
         RETURN FALSE,'imn35'
      ELSE
         RETURN FALSE,'imn32'
      END IF
   END IF
   RETURN TRUE,''
END FUNCTION

FUNCTION i325_imn35_check(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
   IF NOT cl_null(g_imn[l_ac].imn35) AND NOT cl_null(g_imn[l_ac].imn33) THEN
      IF cl_null(g_imn_t.imn35) OR cl_null(g_imn33_t) OR g_imn_t.imn35 != g_imn[l_ac].imn35 OR g_imn33_t != g_imn[l_ac].imn33 THEN
         LET g_imn[l_ac].imn35=s_digqty(g_imn[l_ac].imn35,g_imn[l_ac].imn33)
         DISPLAY BY NAME g_imn[l_ac].imn35
      END IF
   END IF

   IF NOT cl_null(g_imn[l_ac].imn35) THEN
      IF g_imn[l_ac].imn35 < 0 THEN
         CALL cl_err('','aim-391',0)  #
         RETURN FALSE 
      END IF
      IF p_cmd = 'a' THEN
         IF g_ima906='3' THEN
            LET g_tot=g_imn[l_ac].imn35*g_imn[l_ac].imn34
            IF cl_null(g_imn[l_ac].imn32) OR g_imn[l_ac].imn32=0 THEN#CHI-960022
               LET g_imn[l_ac].imn32=g_tot*g_imn[l_ac].imn31
               DISPLAY BY NAME g_imn[l_ac].imn32                     #CHI-960022
            END IF                                                   #CHI-960022
         END IF
      END IF
      IF g_ima906 MATCHES '[23]' THEN
         SELECT imgg10 INTO g_imgg10_2 FROM imgg_file
          WHERE imgg01=g_imn[l_ac].imn03
            AND imgg02=g_imn[l_ac].imn04
            AND imgg03=g_imn[l_ac].imn05
            AND imgg04=g_imn[l_ac].imn06
            AND imgg09=g_imn[l_ac].imn33
      END IF
      IF NOT cl_null(g_imn[l_ac].imn33) THEN
         IF g_sma.sma117 = 'N' THEN
            IF g_imn[l_ac].imn35 > g_imgg10_2 THEN
              #IF g_sma.sma894[4,4]='N' OR g_sma.sma894[4,4] IS NULL THEN   #FUN-C80107 mark
               LET g_flag1 = NULL    #FUN-C80107 add
               #CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_imn[l_ac].imn04) RETURNING g_flag1   #FUN-C80107 add #FUN-D30024--mark
               CALL s_inv_shrt_by_warehouse(g_imn[l_ac].imn04,g_plant) RETURNING g_flag1             #FUN-D30024--add #TQC-D40078 g_plant
               IF g_flag1 = 'N' OR g_flag1 IS NULL THEN   #FUN-C80107 add
                  CALL cl_err(g_imn[l_ac].imn35,'mfg1303',1)
                  RETURN FALSE 
               ELSE
                  IF NOT cl_confirm('mfg3469') THEN
                     RETURN FALSE 
                  ELSE
                     LET g_yes = 'Y'
                  END IF
               END IF
            END IF
         END IF
      END IF
   END IF
   RETURN TRUE
END FUNCTION
#No.FUN-BB0086---add---end---
#CHI-C50041---begin
FUNCTION aimt325_g()    #####依BOM或工單自動展開單身
DEFINE  l_chr       LIKE type_file.chr1 
DEFINE  l_cnt       LIKE type_file.num5
DEFINE  l_azf09     LIKE azf_file.azf09  #TQC-9B0031

    OPEN WINDOW aimt325_w WITH FORM "aim/42f/aimt325_g"                                                           
             ATTRIBUTE (STYLE = g_win_style CLIPPED) 
                                                                                                                                    
    CALL cl_ui_locale("aimt325_g")                                                                                             
    LET l_chr='1' 

    LET l_imn04 = NULL
    LET l_imn05 = NULL
    LET l_imn15 = NULL
    LET l_imn16 = NULL
    LET l_imn28 = NULL
    INPUT l_chr,l_imn04,l_imn05,l_imn15,l_imn16,l_imn28                                                                             
        WITHOUT DEFAULTS FROM FORMONLY.a,FORMONLY.imn04,FORMONLY.imn05,                                                             
                              FORMONLY.imn15,FORMONLY.imn16,FORMONLY.imn28                                                                                                                                
    AFTER FIELD a                                                                                                             
       IF l_chr NOT MATCHES '[123]' THEN 
          NEXT FIELD a                                                                                                         
       END IF                                                                                                                  
                                                                                                                                    
    AFTER FIELD imn04 
       IF NOT cl_null(l_imn04) THEN     
          #No.FUN-AA0049--begin
          IF NOT s_chk_ware(l_imn04) THEN
             NEXT FIELD imn04
          END IF 
          #No.FUN-AA0049--end                                                                                            
          SELECT imd02 FROM imd_file                                                                                             
           WHERE imd01=l_imn04                                                                                               
             AND imdacti = 'Y'                                                                                                   
          IF STATUS THEN                                                                                                         
             CALL cl_err3("sel","imd_file",l_imn04,"",STATUS,"","sel imd",1)                                                 
             NEXT FIELD imn04 
          END IF                                                                                                                 
	IF NOT t325_imechk(l_imn04,l_imn05) THEN NEXT FIELD imn05 END IF   #FUN-D40103 add
       END IF
    AFTER FIELD imn05 
#FUN-D40103--mark--str--
#       IF NOT cl_null(l_imn05) THEN                                                                                          
#          SELECT COUNT(*) INTO l_cnt FROM ime_file WHERE ime01= l_imn04
#                                                     AND ime02= l_imn05
#                                                     AND ime05='Y'                                                               
#          IF l_cnt=0 OR (SQLCA.sqlcode) THEN                                                                                     
#             CALL cl_err3("sel","ime_file",l_imn05,"","100","","sel ime",1)                                                  
#             NEXT FIELD imn05                                                                                                    
#          END IF                                                                                                                 
#       END IF 
#FUN-D40103--mark--end--
       IF cl_null(l_imn05) THEN LET l_imn05 = ' ' END IF                  #FUN-D40103 add
       IF NOT t325_imechk(l_imn04,l_imn05) THEN NEXT FIELD imn05 END IF   #FUN-D40103 add

    AFTER FIELD imn15                                                                                                               
       IF NOT cl_null(l_imn15) THEN 
          #No.FUN-AA0049--begin
          IF NOT s_chk_ware(l_imn15) THEN
             NEXT FIELD imn15
          END IF 
          #No.FUN-AA0049--end                                                                                                                    
          SELECT imd02 FROM imd_file                                                                                                
           WHERE imd01=l_imn15                                                                                                      
             AND imdacti = 'Y'                                                                                                      
          IF STATUS THEN                                                                                                            
             CALL cl_err3("sel","imd_file",l_imn15,"",STATUS,"","sel imd",1)                                                        
             NEXT FIELD imn15                                                                                                       
          END IF                                                                                                                    
	IF NOT t325_imechk(l_imn15,l_imn16) THEN NEXT FIELD imn16 END IF   #FUN-D40103 add
       END IF                                                                                                                       
    AFTER FIELD imn16                                                                                                 
	#FUN-D40103--mark--str--
      #   IF NOT cl_null(l_imn16) THEN                                                                                                 
      #    SELECT COUNT(*) INTO l_cnt FROM ime_file WHERE ime01= l_imn15                                                             
      #                                               AND ime02= l_imn16                                                             
      #                                               AND ime05='Y'                                                                  
      #    IF l_cnt=0 OR (SQLCA.sqlcode) THEN                                                                                        
      #       CALL cl_err3("sel","ime_file",l_imn16,"","100","","sel ime",1)                                                         
      #       NEXT FIELD imn16                                                                                                      
      #    END IF                                                                                                                    
      # END IF   
#FUN-D40103--mark--end--
       IF cl_null(l_imn16) THEN LET l_imn16 = ' ' END IF                  #FUN-D40103 add
       IF NOT t325_imechk(l_imn15,l_imn16) THEN NEXT FIELD imn16 END IF   #FUN-D40103 add

    AFTER FIELD imn28                                                                                                           
       IF NOT l_imn28 IS NULL THEN              
          SELECT azf09 INTO l_azf09 FROM azf_file
           WHERE azf01=l_imn28 AND azf02='2'
          IF l_azf09 != '6' THEN
             CALL cl_err('','aoo-405',0)
             NEXT FIELD imn28
          END IF
          SELECT azf03 INTO g_buf FROM azf_file                                                                                 
           WHERE azf01=l_imn28 AND azf02='2'
          IF STATUS THEN                                                                                                        
             CALL cl_err3("sel","azf_file",l_imn28,"",SQLCA.sqlcode,"","select azf",1)                                                                  
             NEXT FIELD imn28                                                                                                   
          END IF     
          CALL cl_msg(g_buf)                                                                                                    
       END IF  
 
    ON ACTION CONTROLZ                                                                                                        
       CALL cl_show_req_fields()                                                                                              
                                                                                                                                 
    ON ACTION CONTROLG                                                                                                        
       CALL cl_cmdask()                                                                                                       
                                                                                                                                    
    AFTER INPUT                                                                                                               
       IF INT_FLAG THEN                         # 若按了DEL鍵                                                                 
          LET INT_FLAG = 0 
          EXIT INPUT                                                                                                          
       END IF                                                                                                                 
                                                                                                                                    
       ON IDLE g_idle_seconds                                                                                                    
          CALL cl_on_idle()                                                                                                      
          CONTINUE INPUT                                                                                                         
                                              
       ON ACTION controlp                                                                                                           
          CASE                                                                                                                      
             WHEN INFIELD(imn04)    #撥出倉庫別 
                CALL q_imd_1(FALSE,TRUE,l_imn04,"","","","") RETURNING l_imn04
                NEXT FIELD imn04  
             WHEN INFIELD(imn05)   #撥出儲位              
                CALL q_ime_1(FALSE,TRUE,l_imn05,l_imn04,"",g_plant,"","","") RETURNING l_imn05 
                NEXT FIELD imn05 
             WHEN INFIELD(imn15)   #撥入倉庫別
                CALL q_imd_1(FALSE,TRUE,l_imn04,"","","","") RETURNING l_imn15  #Mod No:TQC-AC0333                                               
                NEXT FIELD imn15                                                                                                    
             WHEN INFIELD(imn16)   #撥出儲位
                CALL q_ime_1(FALSE,TRUE,l_imn16,l_imn15,"",g_plant,"","","") RETURNING l_imn16                                                                             
                NEXT FIELD imn16     
             WHEN INFIELD(imn28) #理由                                                                                            
                CALL cl_init_qry_var()                                                                                          
                LET g_qryparam.form     = "q_azf01a" #TQC-9B0031
                LET g_qryparam.default1 = l_imn28                                                                     
                LET g_qryparam.arg1     = "6" #TQC-9B0031  
                CALL cl_create_qry() RETURNING l_imn28                                                                
                DISPLAY BY NAME l_imn28 
                NEXT FIELD imn28  
          END CASE                                                                                    
       ON ACTION about        
          CALL cl_about()     
                                                                                                                                    
       ON ACTION help         
          CALL cl_show_help() 
                                                                                                                                    
                                                                                                                                    
    END INPUT                                                                                                                 
    IF INT_FLAG THEN                                                                                                          
       LET INT_FLAG=0                                                                                                         
       LET l_chr = '1'                                                                                                        
    END IF                                                                                                                    
    CLOSE WINDOW aimt325_w                 #結束畫面 
    IF cl_null(l_chr) THEN                                                                                                    
       LET l_chr = '1'                                                                                                        
    END IF                                                                                                                    
    LET g_rec_b = 0                                                                                                           
    CASE                                                                                                                      
      WHEN l_chr = '1'                                                                                                        
           CALL g_imn.clear()                                                                                                 
           CALL t325_b()                                                                                                      
      WHEN l_chr = '2'                                                                                                        
           CALL t325_wo(g_imm.imm01)                                                                                         
           COMMIT WORK                                                                                                        
           LET g_wc2=' 1=1'                                                                                                     
           CALL t325_b_fill(g_wc2)                                                                                            
           LET g_action_choice="detail"                                                                                       
           IF cl_chk_act_auth() THEN                                                                                          
              CALL t325_b()                                                                                                   
           ELSE                                                                                                               
              RETURN                                                                                                          
           END IF                                                                                                             
      WHEN l_chr='3'                                                                                                          
           CALL t325_bom(g_imm.imm01)                                                                                             
           LET g_wc2=' 1=1'
           CALL t325_b_fill(g_wc2)                                                                                            
           LET g_action_choice="detail"             
           IF cl_chk_act_auth() THEN                                                                                          
              CALL t325_b()                                                                                                   
           ELSE                                                                                                               
              RETURN                                                                                                          
           END IF                                                                                                             
      OTHERWISE EXIT CASE                                                                                                     
      END CASE                                                                                                                  
      LET g_imm_t.* = g_imm.*                # 保存上筆資料                                                                     
      LET g_imm_o.* = g_imm.*                # 保存上筆資料                                                                     
END FUNCTION
#BOM開始
FUNCTION t325_bom(p_argv1)
  DEFINE l_time  LIKE type_file.chr18  
  DEFINE l_sql   LIKE type_file.chr1000
  DEFINE l_n1    LIKE type_file.num5
  DEFINE p_argv1 LIKE imn_file.imn01 

   WHENEVER ERROR CONTINUE                                                                                                          
    IF p_argv1 IS NULL OR p_argv1 = ' ' THEN                                                                                        
       CALL cl_err(p_argv1,'mfg3527',0)                                                                                             
       RETURN                                                                                                                       
    END IF                                                                                                                          
    INITIALIZE tm.* TO NULL 
    LET g_ccc=0                                                                                                                     
    LET b_imn.imn01  = p_argv1                                                                                                      
    LET tm.qty=0                                                                                                                    
    LET tm.idate=g_today                                                                                                            
    LET tm.a='N'                                                                                                                    

  WHILE TRUE                                                                                                                          
    #-->條件畫面輸入                                                                                                                
    OPEN WINDOW aimt325_g1_w AT 6,30 WITH FORM "aim/42f/aimt325_g1"                                                                          
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
                                                                                                                                    
    CALL cl_ui_locale("aimt325_g1")                                                                                                    
                                                                                                                                    
    CALL cl_set_comp_visible("ima910",g_sma.sma118='Y')   
                                                                                                                                    
    INPUT BY NAME tm.* WITHOUT DEFAULTS                                                                                             
       AFTER FIELD part                                                                                                             
          IF NOT chk_part() THEN NEXT FIELD part END IF                                                                             
       AFTER FIELD ima910                                                                                                           
          IF cl_null(tm.ima910) THEN                                                                                                
             LET tm.ima910 = ' '                                                                                                    
          ELSE                                                                                                                      
             SELECT COUNT(*) INTO g_cnt FROM bma_file                                                                               
              WHERE bma01=tm.part AND bma06=tm.ima910                                                                               
             IF g_cnt = 0 THEN                                                                                                      
                CALL cl_err('','abm-618',0)                                                                                         
                NEXT FIELD ima910                                                                                                   
             END IF                                                                                                                 
          END IF                                                                                                                    
       AFTER FIELD qty                                                                                                              
          IF cl_null(tm.qty) OR tm.qty<=0 THEN NEXT FIELD qty END IF                                                                
       AFTER FIELD idate                                                                                                            
          IF cl_null(tm.idate) OR tm.idate < g_today                                                                                
             THEN NEXT FIELD idate END IF                                                                                           
       AFTER FIELD a                                                                                                                
          IF cl_null(tm.a) OR tm.a NOT matches '[YN]' THEN NEXT FIELD a END IF                                                      
       ON IDLE g_idle_seconds                                                                                                       
          CALL cl_on_idle()                                                                                                         
          CONTINUE INPUT                                                                                                            
       ON ACTION controlp                                                                                                           
          CASE                                                                                                                      
             WHEN INFIELD(part)                                                                                                     
                CALL cl_init_qry_var()                                                                                              
                LET g_qryparam.form = "q_bma"                                                                                       
                LET g_qryparam.default1 = tm.part                                                                                   
                CALL cl_create_qry() RETURNING tm.part                                                                              
                DISPLAY tm.part TO FORMONLY.part                                                                                    
                NEXT FIELD part                                                                                                     
                                                                                                                                    
             OTHERWISE EXIT CASE                                                                                                    
          END CASE                                                                                                                  
                                                                                                                                    
       ON ACTION about      
          CALL cl_about()   
                                                                                                                                    
       ON ACTION help        
          CALL cl_show_help()
                                                                                                                                    
       ON ACTION controlg   
          CALL cl_cmdask()  
                                                                                                                                    
       BEFORE INPUT                                                                                                                 
           CALL cl_qbe_init()                                                                                                       
       ON ACTION qbe_select                                                                                                         
          CALL cl_qbe_select()                                                                                                      
                                                                                                                                    
       ON ACTION qbe_save                                                                                                           
          CALL cl_qbe_save()                                                                                                        
                                                                                                                                    
    END INPUT                                                                                                                       
    IF INT_FLAG THEN LET INT_FLAG=0 CLOSE WINDOW aimt325_g1_w RETURN END IF                                                               
    CALL aimt325_init()                                                                                                                
    CALL aimt325_bom()                                                                                                                 
    CLOSE WINDOW aimt325_g1_w                                                                                                             
    EXIT WHILE                                                                                                                      
  END WHILE    
END FUNCTION
###展BOM
FUNCTION aimt325_bom()
   DEFINE l_ima562     LIKE ima_file.ima562,                                                                                        
          l_ima910     LIKE ima_file.ima910, 
          l_ima55      LIKE ima_file.ima55,                                                                                         
          l_ima86      LIKE ima_file.ima86,                                                                                         
          l_ima86_fac  LIKE ima_file.ima86_fac                                                                                      
                                                                                                                                    
    SELECT ima562,ima55,ima86,ima86_fac,ima910 INTO 
           l_ima562,l_ima55,l_ima86,l_ima86_fac,l_ima910
      FROM ima_file                                                                                                               
     WHERE ima01=tm.part AND imaacti='Y'                                                                                         
    IF SQLCA.sqlcode THEN RETURN END IF                                                                                             
    IF l_ima562 IS NULL THEN LET l_ima562=0 END IF                                                                                  
    IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF 
    IF tm.ima910 != ' ' THEN                                                                                                        
       LET l_ima910 = tm.ima910                                                                                                     
    END IF                                                                                                                          
    CALL aimt325_bom2(0,tm.part,l_ima910,tm.qty,1)
    IF g_ccc=0 THEN                                                                                                              
       LET g_errno='asf-014'                                                                                                    
    END IF    #有BOM但無有效者                                                                                                   
                                                                                                                                    
    MESSAGE ""                                                                                                                      
    RETURN                                                                                                                          
END FUNCTION

FUNCTION aimt325_bom2(p_level,p_key,p_key2,p_total,p_QPA)                                                                                                                           
DEFINE                                                                                                                              
    p_level      LIKE type_file.num5,         #level code    
    p_total      LIKE sfb_file.sfb08,      
#    p_QPA        LIKE ima_file.ima26,     
#    l_QPA        LIKE ima_file.ima26,    
    p_QPA        LIKE type_file.num15_3,     #No.FUN-A40023
    l_QPA        LIKE type_file.num15_3,     #No.FUN-A40023
    l_total      LIKE sfb_file.sfb08,         #原發數量     
    l_total2     LIKE sfb_file.sfb08,         #應發數量    
    p_key        LIKE bma_file.bma01,         #assembly part number                                                                 
    p_key2       LIKE bma_file.bma06,       
    l_ac,l_i,l_x LIKE type_file.num5,       
    arrno        LIKE type_file.num5,   
    b_seq,l_double LIKE type_file.num10, 
    l_ima45      LIKE ima_file.ima45,                                                                                               
    l_ima46      LIKE ima_file.ima46,                                                                                               
    p_cmd        LIKE type_file.chr1,
    sr DYNAMIC ARRAY OF RECORD  #array for storage                                                                                  
           bmb02 LIKE bmb_file.bmb02, #項次                                                                                            
           bmb03 LIKE bmb_file.bmb03, #料號                                                                                            
           bmb16 LIKE bmb_file.bmb16, #取替代碼                                                                                        
           bmb06 LIKE bmb_file.bmb06, #QPA
           bmb08 LIKE bmb_file.bmb08, #損耗率                                                                                          
           bmb10 LIKE bmb_file.bmb10, #發料單位                                                                                        
           bmb10_fac LIKE bmb_file.bmb10_fac, #換算率                                                                                  
           ima08 LIKE ima_file.ima08, #來源碼                                                                                          
           ima02 LIKE ima_file.ima02, #品名規格                                                                                        
           ima05 LIKE ima_file.ima05, #版本                                                                                            
           ima44 LIKE ima_file.ima44, #采購單位                                                                                        
           ima25 LIKE ima_file.ima25, #庫存單位                                                                                        
           ima44_fac LIKE ima_file.ima44_fac,  #采購單位/庫存單位 換算率                                                               
           ima49 LIKE ima_file.ima49,  #到廠前置期                                                                                    
           ima491 LIKE ima_file.ima491, #入庫前置期                                                                                    
           ima24  LIKE ima_file.ima24,  #TQC-9B0031
           bma01 LIKE bma_file.bma01  #項次                                                                                            
       END RECORD,                                                                                                                     
    l_ima08     LIKE ima_file.ima08,        #source code                                                                            
#    l_ima26     LIKE ima_file.ima26,       #No.FUN-A40023  #QOH                                                                                    
    l_chr       LIKE type_file.chr1,    
    l_ActualQPA LIKE bmb_file.bmb06,   
    l_cnt,l_c   LIKE type_file.num5,   
    l_cmd       LIKE type_file.chr1000,   
    l_status    LIKE type_file.num5,      
    l_factor    LIKE ima_file.ima31_fac   
DEFINE  l_ima908     LIKE ima_file.ima908 
DEFINE  l_ima44      LIKE ima_file.ima44                                                                                            
DEFINE  l_ima906     LIKE ima_file.ima906                                                                                           
DEFINE  l_ima907     LIKE ima_file.ima907                                                                                           
DEFINE  l_ima910     DYNAMIC ARRAY OF LIKE ima_file.ima910      
DEFINE  l_imm01      LIKE imm_file.imm01  #FUN-B30053
DEFINE  l_smy57      LIKE smy_file.smy57  #FUN-B30053
DEFINE  l_store      STRING               #FUN-CB0087 add
                                                                                                                                    
    LET p_level = p_level + 1                                                                                                       
    LET arrno = 500                                                                                                                 
        LET l_cmd=" SELECT 0,bmb03,bmb16,bmb06/bmb07,bmb08,bmb10,bmb10_fac,",                                                       
                 #"     ima08,ima02,ima05,ima44,ima25,ima44_fac,ima49,ima491,ima24,bma01 ", #TQC-9B0031 add ima24  
                  "     ima08,ima02,ima05,ima44,ima25,ima44_fac,ima49,ima491,'',bma01 ", #TQC-9B0031 add ima24     #FUN-B30053 將ima24改成''
                  "   FROM bmb_file ",
                  "   LEFT OUTER JOIN ima_file ON ima01=bmb03 ",
                  "   LEFT OUTER JOIN bma_file ON bma01=bmb03 AND bma06=bmb29 ",                                                              
                  "  WHERE bmb01='",p_key,"' AND bmb02 > ?",                                                                        
                  "    AND bmb29='",p_key2,"'",                                                                                   
                  "    AND (bmb04 <='",tm.idate,"' OR bmb04 IS NULL) ",                                                             
                  "    AND (bmb05 >'",tm.idate,"' OR bmb05 IS NULL)",                                                               
                  " ORDER BY 1" 
        PREPARE bom_p FROM l_cmd                                                                                                    
        DECLARE bom_cs CURSOR FOR bom_p                                                                                             
        IF SQLCA.sqlcode THEN CALL cl_err('P1:',SQLCA.sqlcode,1) RETURN  END IF                                                     
                                                                                                                                    
    LET b_seq=0                                                                                                                     
    WHILE TRUE                                                                                                                      
        LET l_ac = 1                                                                                                                
        FOREACH bom_cs USING b_seq INTO sr[l_ac].*                                                                                  
            MESSAGE p_key CLIPPED,'-',sr[l_ac].bmb03 CLIPPED                                                                        
            #若換算率有問題, 則設為1                                                                                                
            IF sr[l_ac].bmb10_fac IS NULL OR sr[l_ac].bmb10_fac=0 THEN                                                              
                LET sr[l_ac].bmb10_fac=1                                                                                            
            END IF                                                                                                                  
            IF cl_null(sr[l_ac].bmb16) THEN    #若未定義, 則給予'正常'                                                              
                LET sr[l_ac].bmb16='0'                                                                                              
            ELSE                                                                                                                    
               IF sr[l_ac].bmb16='2' THEN LET sr[l_ac].bmb16='1' END IF                                                             
            END IF                                                                                                                  
            #FUN-B30053-add-str--
            LET l_imm01 = s_get_doc_no(g_imm.imm01)
            SELECT smy57 INTO l_smy57
             FROM  smy_file WHERE smyslip = l_imm01 AND smyacti = 'Y'
            IF cl_null(l_smy57[2,2]) THEN
               LET l_smy57[2,2] = 'N'
            END IF
            LET sr[l_ac].ima24 = l_smy57[2,2]
            #FUN-B30053-add-end--            
            LET l_ima910[l_ac]=''                                                                                                   
            SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03
            IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF                                                           
            LET l_ac = l_ac + 1    #check limitation                                                                                
            IF l_ac > arrno THEN EXIT FOREACH END IF                                                                                
        END FOREACH                                                                                                                 
        LET l_x=l_ac-1                                                                                                              
                                                                                                                                    
        #insert into allocation file                                                                                                
        FOR l_i = 1 TO l_x                                                                                                          
                                                                                                                                    
            #inflate yield                                                                                                          
            IF g_sma.sma71='N' THEN LET sr[l_i].bmb08=0 END IF                                                                      
                                                                                                                                    
            #Actual QPA                                                                                                             
            LET l_ActualQPA=(sr[l_i].bmb06+sr[l_i].bmb08/100)*p_QPA                                                                 
            LET l_QPA=sr[l_i].bmb06 * p_QPA                                                                                         
            LET l_total=sr[l_i].bmb06*p_total*((100+sr[l_i].bmb08))/100  #量                                                        

            IF sr[l_i].ima08='X' THEN       ###為 X PART 由參數決定                                                                 
                IF sr[l_i].bma01 IS NOT NULL THEN                                                                                   
                    CALL aimt325_bom2(p_level,sr[l_i].bmb03,l_ima910[l_i], 
                        p_total*sr[l_i].bmb06,l_ActualQPA)                                                                          
                END IF                                                                                                              
            END IF                                                                                                                  
                                                                                                                                    
                                                                                                                                    
            IF sr[l_i].ima08='M' OR                                                                                                 
               sr[l_i].ima08='S' THEN     ###為 M PART 由人決定                                                                     
               IF tm.a='Y' THEN                                                                                                     
                  IF sr[l_i].bma01 IS NOT NULL THEN 
                     CALL aimt325_bom2(p_level,sr[l_i].bmb03,l_ima910[l_i],   
                          p_total*sr[l_i].bmb06,l_ActualQPA)                                                                        
                  ELSE                                                                                                              
                      CONTINUE FOR                                                                                                  
                  END IF                                                                                                            
               ELSE                                                                                                                 
                  CONTINUE FOR                                                                                                      
               END IF                                                                                                               
            END IF                                                                                                                  
            IF NOT(sr[l_i].ima08='X' OR sr[l_i].ima08='M' OR                                                                        
                   sr[l_i].ima08='S')   THEN                                                                                            
              LET g_ccc=g_ccc+1                                                                                                     
              LET b_imn.imn03=sr[l_i].bmb03
              LET b_imn.imn04 = l_imn04 
              LET b_imn.imn05 = l_imn05 
              LET b_imn.imn28 = l_imn28
              LET b_imn.imn16 = l_imn16
              LET b_imn.imn15 = l_imn15                                                                                        
              LET b_imn.imn10 = l_total          #No:MOD-A10059 add
              IF cl_null(b_imn.imn16) AND cl_null(b_imn.imn15) THEN  #若畫面倉儲為空則取料件主倉儲
                 SELECT ima35,ima36 INTO b_imn.imn04,b_imn.imn05 
                   FROM ima_file
                  WHERE ima01 = b_imn.imn03  
                
              END IF 
              LET b_imn.imn08=sr[l_i].ima25                                                                                        
              LET b_imn.imn06 = ' '
              LET b_imn.imn09 = ''   #MOD-D10182
              SELECT img09 INTO b_imn.imn09 FROM imn_file
               WHERE img01 = b_imn.imn03
                 AND img02 = b_imn.imn04
                 AND img03 = b_imn.imn05
                 AND img04 = b_imn.imn06 
              IF cl_null(b_imn.imn09) THEN
                 SELECT ima25 INTO b_imn.imn09 FROM ima_file
                  WHERE ima01 = b_imn.imn03
              END IF 
                                                                                                                                    
             ### 寫進 pml_file                                                                                                      
               SELECT COUNT(*) INTO l_cnt FROM imn_file                                                                             
                WHERE imn01=b_imn.imn01 AND imn03=b_imn.imn03                                                                       
               IF l_cnt > 0 THEN   #   數量相加                                                                            
                  SELECT ima25,ima44,ima906,ima907                                                                                  
                    INTO g_ima25,g_ima44,g_ima906,g_ima907 
                    FROM ima_file WHERE ima01=g_pml.pml04                                                                           
                  IF SQLCA.sqlcode =100 THEN                                                                                        
                     IF b_imn.imn03 MATCHES 'MISC*' THEN                                                                            
                        SELECT ima25,ima44,ima906,ima907                                                                            
                          INTO g_ima25,g_ima44,g_ima906,g_ima907                                                                    
                          FROM ima_file WHERE ima01='MISC'                                                                          
                     END IF                                                                                                         
                  END IF                                                                                                            
                  IF cl_null(g_ima44) THEN LET g_ima44 = g_ima25 END IF                                                             

                 IF g_sma.sma115 = 'Y' AND g_ima906 MATCHES'[23]' THEN                                                                                                                                    
                    CALL t325_du_default(p_cmd,b_imn.imn03,b_imn.imn04,                                           
                                          b_imn.imn05,b_imn.imn06)                                                  
                           RETURNING b_imn.imn33,b_imn.imn34,b_imn.imn35,                                     
                                     b_imn.imn30,b_imn.imn31,b_imn.imn32 
                 END IF 
                  UPDATE imn_file SET imn32=imn32+b_imn.imn32,
                                      imn35=imn35+b_imn.imn35 
                   WHERE imn01=b_imn.imn01 AND imn03=b_imn.imn03                                                                    
               ELSE                                                                                                                 
                  SELECT MAX(imn02) INTO b_imn.imn02 FROM imn_file
                   WHERE imn01 = b_imn.imn01
                  IF cl_null(b_imn.imn02) THEN
                     LET b_imn.imn02 = 0
                  END IF 
                  LET b_imn.imn02=b_imn.imn02+1                                                                                     
                  IF g_sma.sma115 = 'Y' THEN                                                                                        
                     SELECT ima44,ima906,ima907 INTO l_ima44,l_ima906,l_ima907                                                      
                       FROM ima_file                                                                                                
                      WHERE ima01=b_imn.imn03  
                     LET l_factor = 1                                                                                               
                     IF l_ima906 MATCHES'[23]' THEN
                        CALL t325_du_default(p_cmd,b_imn.imn03,b_imn.imn04,                                           
                                             b_imn.imn05,b_imn.imn06)                                                  
                              RETURNING b_imn.imn33,b_imn.imn34,b_imn.imn35,                                     
                                        b_imn.imn30,b_imn.imn31,b_imn.imn32 
                     END IF  
                  END IF                                                                                                            
                  LET b_imn.imn21 = 1
                  LET b_imn.imn27 = 'N' 
                  LET b_imn.imn29 = sr[l_i].ima24 #TQC-9B0031
                  IF NOT cl_null(l_imn04) THEN                                                                                                    
                     LET b_imn.imn04 = l_imn04                                                                                                    
                  END IF                                                                                                                          
                  IF NOT cl_null(l_imn05) THEN                                                                                                    
                     LET b_imn.imn05 = l_imn05                                                                                                    
                  END IF                                                                                                                          
                  IF NOT cl_null(l_imn15) THEN                                                                                                    
                     LET b_imn.imn15 = l_imn15                                                                                                    
                  END IF                                                                                                                          
                  IF NOT cl_null(l_imn16) THEN                                                                                                    
                     LET b_imn.imn16 = l_imn16                                                                                                    
                  END IF                                                                                                                          
                  IF NOT cl_null(l_imn28) THEN                                                                                                    
                     LET b_imn.imn28 = l_imn28                                                                                                    
                  END IF 
                  LET b_imn.imn22 = b_imn.imn10

                  LET b_imn.imn20 = b_imn.imn09 #TQC-9B0031
                  LET b_imn.imnplant = g_plant #TQC-9B0031
                  LET b_imn.imnlegal = g_legal #TQC-9B0031
                  IF cl_null(b_imn.imn05) THEN LET b_imn.imn05 = ' ' END IF  #TQC-9B0031
                  IF cl_null(b_imn.imn06) THEN LET b_imn.imn06 = ' ' END IF  #TQC-9B0031
                  IF cl_null(b_imn.imn16) THEN LET b_imn.imn16 = ' ' END IF  #TQC-9B0031
                  IF cl_null(b_imn.imn17) THEN LET b_imn.imn17 = ' ' END IF  #TQC-9B0031
                  #FUN-CB0087---add---str---
                  IF g_aza.aza115 = 'Y' AND cl_null(b_imn.imn28) THEN
                     LET l_store = ''
                     IF NOT cl_null(b_imn.imn04) THEN
                        LET l_store = l_store,b_imn.imn04
                     END IF
                     IF NOT cl_null(b_imn.imn15) THEN
                        IF NOT cl_null(l_store) THEN
                           LET l_store = l_store,"','",b_imn.imn15
                        ELSE
                           LET l_store = l_store,b_imn.imn15
                        END IF
                     END IF
                     LET b_imn.imn28 = s_reason_code(b_imn.imn01,'','',b_imn.imn03,l_store,'',g_imm.imm14)
                  END IF
                  #FUN-CB0087---add---end---
                  LET b_imn.imn12='N' #TQC-DB0039
                  LET b_imn.imn24='N' #TQC-DB0039
                  INSERT INTO imn_file VALUES(b_imn.*)
                  IF SQLCA.SQLCODE THEN                                                                                             
                     ERROR 'ALC2: Insert Failed because of ',SQLCA.SQLCODE                    
                  END IF                                                                                                            
               END IF                                                                                                               
            END IF                                                                                                                  
        END FOR
        IF l_x < arrno OR l_ac=1 THEN 
            EXIT WHILE                                                                                                              
        ELSE                                                                                                                        
            LET b_seq = sr[l_x].bmb02                                                                                               
        END IF                                                                                                                      
    END WHILE                                                                                                                       
    # 避免 'X' PART 重復計算                                                                                                        
    IF p_level >1 THEN                                                                                                              
       RETURN                                                                                                                       
     END IF 
END FUNCTION 
#BOM結束

FUNCTION aimt325_init()
    LET b_imn.imn06 = ' ' 
    LET b_imn.imn29 = 'N'
    LET b_imn.imn51 = 1
    LET b_imn.imn52 = 1
    LET b_imn.imn9301=s_costcenter(g_imm.imm14)
    LET b_imn.imn9302=b_imn.imn9301 
END FUNCTION 

FUNCTION chk_part()                                                                                                                 
  DEFINE  l_ima08    LIKE ima_file.ima08,                                                                                           
          l_imaacti  LIKE ima_file.imaacti,                                                                                         
          l_cnt      LIKE type_file.num5,      #No.FUN-680136 SMALLINT                                                              
          l_err      LIKE type_file.num5       #No.FUN-680136 SMALLINT                                                              
                                                                                                                                    
         LET l_err=1                                                                                                                
        #檢查該料件是否存在                                                                                                         
         SELECT ima08,imaacti INTO l_ima08,l_imaacti FROM ima_file                                                                  
          WHERE ima01=tm.part                                                                                                       
             CASE                                                                                                                   
               WHEN l_ima08 NOT MATCHES '[MS]'  #MOD-5B0321 add                                                                     
                     CALL cl_err(tm.part,'apm-025',2) #MOD-560115                                                                   
                    LET l_err=0                                                                                                     
               WHEN l_imaacti = 'N'                                                                                                 
                    CALL cl_err(tm.part,'mfg0301',2)                                                                                
                    LET l_err=0                                                                                                     
               WHEN SQLCA.SQLCODE = 100                                                                                             
                    CALL cl_err(tm.part,'mfg0002',2)                                                                                
                    LET l_err=0                                                                                                     
               WHEN SQLCA.SQLCODE != 0
                    CALL cl_err(tm.part,sqlca.sqlcode,2)                                                                            
                    LET l_err=0                                                                                                     
            END CASE                                                                                                                
         IF l_err THEN                                                                                                              
            #檢查該料件是否有產品結構                                                                                               
            SELECT COUNT(*) INTO l_cnt FROM bmb_file WHERE bmb01=tm.part                                                            
            IF SQLCA.SQLCODE THEN                                                                                                   
                CALL cl_err(tm.part,sqlca.sqlcode,2)                                                                                
                LET l_err=0                                                                                                         
            END IF                                                                                                                  
            IF l_cnt=0 OR cl_null(l_cnt) THEN                                                                                       
                CALL cl_err(tm.part,'mfg2602',2)                                                                                    
                LET l_err=0                                                                                                         
            END IF                                                                                                                  
         END IF                                                                                                                     
    RETURN l_err                                                                                                                    
END FUNCTION    
#WO開始
FUNCTION t325_wo(p_argv1)
   DEFINE l_time   LIKE type_file.chr8
   DEFINE l_sql    LIKE type_file.chr1000
   DEFINE p_argv1  LIKE imm_file.imm01

   WHENEVER ERROR CONTINUE 
   IF p_argv1 IS NULL OR p_argv1 = ' ' THEN
      CALL cl_err(p_argv1,'mfg3527',0)
      RETURN
   END IF 
   LET l_sw = 'Y'
WHILE TRUE
   #--條件畫面輸入
    IF l_sw != 'N' THEN                                                                                                             
       OPEN WINDOW aimt325_wo_g          #條件畫面                                                                   
              WITH FORM "aim/42f/aimt325_wo"                                                                                        
          ATTRIBUTE (STYLE = g_win_style CLIPPED)                                                                                   
       CALL cl_ui_locale("aimt325_wo")                                                                                              
    END IF                                                                                                                          
    CALL t325_wo_tm()                                                                                                               
    IF INT_FLAG THEN                                                                                                                
       CLOSE WINDOW aimt325_wo_g                                                                                                    
       EXIT WHILE                                                                                                                   
    END IF                                                                                                                          
    #-->無符合條件資料                                                                                                              
    IF l_sw = 'N' THEN                                                                                                              
       CALL cl_err(g_imm.imm01,'mfg2601',0)                                                                                         
        CONTINUE WHILE                                                                                                              
    END IF
    CALL cl_wait()                                                                                                                  
    CALL aimt325_wo_g()                                                                                                             
    #-->無符合條件資料                                                                                                              
    IF l_sw = 'N' THEN                                                                                                              
       CALL cl_err(g_imm.imm01,'mfg2601',0)                                                                                         
       CONTINUE WHILE                                                                                                               
    END IF                                                                                                                          
    ERROR ""                                                                                                                        
    EXIT WHILE                                                                                                                      
 END WHILE                                                                                                                          
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF                                                                                 
    CLOSE WINDOW aimt325_wo_g    
END FUNCTION

FUNCTION t325_wo_tm()
 DEFINE  l_cnt       LIKE type_file.num5,                                                                                           
         l_wobdate   LIKE type_file.dat,                                                                                            
         l_woedate   LIKE type_file.dat,                                                                                            
         l_sql       LIKE type_file.chr1000,                                                                                        
         l_where     LIKE type_file.chr1000,                                                                                        
         l_n         LIKE type_file.num5
    CONSTRUCT BY NAME g_wc ON sfb01,sfb13,ima06,ima08                                                                               
    BEFORE  CONSTRUCT                                                                                                               
       CALL cl_qbe_init()                                                                                                           
    ON ACTION CONTROLP                                                                                                              
            CASE                                                                                                                    
               WHEN INFIELD(sfb01)                                                                                                  
                    CALL cl_init_qry_var()                                                                                          
                    LET g_qryparam.form = "q_sfb"                                                                                   
                    LET g_qryparam.state = 'c'                                                                                      
                    CALL cl_create_qry() RETURNING g_qryparam.multiret                                                              
                    DISPLAY g_qryparam.multiret TO sfb01                                                                            
                    NEXT FIELD sfb01                                                                                                
               OTHERWISE EXIT CASE                                                                                                  
             END CASE                                                                                                               
    ON IDLE g_idle_seconds                                                                                                          
        CALL cl_on_idle()                                                                                                           
        CONTINUE CONSTRUCT                                                                                                          
                                                                                                                                    
    ON ACTION about                                                                                                                 
       CALL cl_about()                                                                                                              
                                                                                                                                    
    ON ACTION controlg                                                                                                              
       CALL cl_cmdask()

    ON ACTION help                                                                                                                  
       CALL cl_show_help()                                                                                                          
                                                                                                                                    
    END CONSTRUCT                                                                                                                   
    IF INT_FLAG THEN RETURN END IF                                                                                                  
    CALL cl_wait()                                                                                                                  
    #-->讀取工單最早開工日期/最晚開工日期                                                                                           
    LET l_sql = "SELECT min(sfb13),max(sfb13) ",                                                                                    
                "  FROM sfb_file,ima_file,sfa_file ",                                                                               
                " WHERE sfb01 = sfa01 ",                                                                                            
                "   AND sfa03 = ima01 ",                                                                                            
                "   AND sfb87!='X' AND ", g_wc CLIPPED                                                                              
                                                                                                                                    
    PREPARE p325_predate  FROM l_sql                                                                                                
    DECLARE p325_curdate CURSOR FOR p325_predate                                                                                    
    LET l_sw = 'Y'                                                                                                                  
    FOREACH p325_curdate INTO l_wobdate,l_woedate                                                                                   
        IF SQLCA.sqlcode THEN                                                                                                       
           CALL cl_err('p325_curdate',SQLCA.sqlcode,0)                                                                              
           EXIT FOREACH                                                                                                             
        END IF 
        IF (l_wobdate IS NULL OR l_wobdate = ' ') AND                                                                               
           (l_woedate IS NULL OR l_woedate = ' ')                                                                                   
        THEN LET l_sw = 'N'                                                                                                         
             EXIT FOREACH                                                                                                           
        END IF                                                                                                                      
    END FOREACH                                                                                                                     
    IF l_sw = 'N' THEN RETURN END IF                                                                                                
    ERROR ""                                                                                                                        
   INITIALIZE tm1.* TO NULL                      # Default condition                                                                
   LET tm1.sudate = l_woedate                                                                                                       
   INPUT BY NAME tm1.sudate
                 WITHOUT DEFAULTS HELP 1                                                                                            
      AFTER FIELD sudate    #工單範圍中最晚開工日期前一天                                                                           
         IF tm1.sudate IS NULL OR tm1.sudate = ' ' THEN                                                                             
            NEXT FIELD sudate                                                                                                       
         END IF                                                                                                                     
                                                                                                                                    
        ON KEY(CONTROL-G)                                                                                                           
            CALL cl_cmdask()                                                                                                        
                                                                                                                                    
        ON IDLE g_idle_seconds                                                                                                      
          CALL cl_on_idle()                                                                                                         
          CONTINUE INPUT                                                                                                            
                                                                                                                                    
        AFTER INPUT                                                                                                                 
          IF INT_FLAG THEN EXIT INPUT END IF                                                                                        
          IF tm1.sudate IS NULL AND tm1.sudate = ' '                                                                                
          THEN NEXT FIELD sudate                                                                                                    
          END IF                                                                                                                    
          IF INT_FLAG THEN EXIT INPUT END IF                                                                                        
   END INPUT                                                                                                                        
   IF INT_FLAG THEN RETURN END IF 
END FUNCTION 

FUNCTION aimt325_wo_g()
  DEFINE  l_sql      LIKE type_file.chr1000,                                                                                        
          l_sfa03    LIKE sfa_file.sfa03,                                                                                           
          l_sfa26    LIKE sfa_file.sfa26,                                                                                           
          l_sfb25    LIKE sfb_file.sfb25,                                                                                           
          l_sfb98    LIKE sfb_file.sfb98,                                                                                           
#          l_ima262   LIKE ima_file.ima262, #No.FUN-A40023                                                                                         
          l_ima27    LIKE ima_file.ima27,                                                                                           
          l_ima45    LIKE ima_file.ima45,                                                                                           
          l_ima46    LIKE ima_file.ima46                                                                                            
  DEFINE  l_sfa12    LIKE sfa_file.sfa12  #TQC-9B0031
  DEFINE  l_sfa05    LIKE sfa_file.sfa05  #TQC-9B0031
  DEFINE  l_ima24    LIKE ima_file.ima24  #TQC-9B0031
  DEFINE  l_imm01    LIKE imm_file.imm01  #FUN-B30053
  DEFINE  l_smy57    LIKE smy_file.smy57  #FUN-B30053
                                                                                                                                    
    #-->料件/替代碼/本次需求量                                                                                                      
   #LET l_sql = "SELECT UNIQUE sfa03,sfa26,sfb25,sfb98,sfa12,ima24,sum(sfa05) ", #TQC-9B0031 add sfa12,sfa05,ima24                                                                          
    LET l_sql = "SELECT UNIQUE sfa03,sfa26,sfb25,sfb98,sfa12,'',sum(sfa05) ", #TQC-9B0031 add sfa12,sfa05,ima24   #FUN-B30053 ima24-->''
                "  FROM sfa_file,sfb_file,ima_file",                                                                                
                " WHERE sfa01 = sfb01 ",                                                                                            
                "   AND sfb04 != '8' ",                                                                                             
                "  AND sfb02 != '2'  AND sfb02 != '11' AND sfb87!='X' ",                                                            
                "  AND sfa065 = 0 ",                                                                                                
                "   AND sfa03 = ima01 AND ", g_wc CLIPPED,                                                                          
               #" GROUP BY sfa03,sfa26,sfb25,sfb98,sfa12,ima24", #TQC-9B0031                                                                               
                " GROUP BY sfa03,sfa26,sfb25,sfb98,sfa12", #TQC-9B0031      #FUN-B30053  去掉ima24
                " ORDER BY sfa03,sfa26,sfb25,sfb98"   #TQC-9B0031                                                                                              
    PREPARE t325_wo_prepare FROM l_sql                                                                                              
    DECLARE t325_wo_cs
        CURSOR WITH HOLD FOR t325_wo_prepare                                                                                        
    #-->單身預設值                                                                                                                  
    CALL aimt325_init()
    SELECT max(imn02)+1 INTO g_seq FROM imn_file WHERE imn01 = g_imm.imm01                                                          
    IF g_seq IS NULL OR g_seq = ' ' OR g_seq = 0  THEN                                                                              
       LET g_seq = 1                                                                                                                
    END IF                                                                                                                          
    LET l_sw = 'N'                                                                                                                  
    LET g_success = 'Y'                                                                                                             
    BEGIN WORK                                                                                                                      
    CALL s_showmsg_init()                                                                                                           
    FOREACH t325_wo_cs INTO l_sfa03,l_sfa26,l_sfb25,l_sfb98,l_sfa12,l_ima24,l_sfa05  #TQC-9B0031                                                                         
       IF SQLCA.sqlcode THEN                                                                                                        
         LET g_success = 'N'                                                                                                        
         IF g_bgerr THEN                                                                                                            
             CALL s_errmsg("sfa03",l_sfa03,"t325_wo_cs",SQLCA.sqlcode,1)  #TQC-9B0037                                                                    
         ELSE                                                                                                                       
            CALL cl_err('t325_wo_cs',SQLCA.sqlcode,0)    #TQC-9B0037
         END IF                                                                                                                     
         EXIT FOREACH                                                                                                               
       END IF                                                                                                                       
       #FUN-B30053-add-str--
       LET l_imm01 = s_get_doc_no(g_imm.imm01)
       SELECT smy57 INTO l_smy57
        FROM  smy_file WHERE smyslip = l_imm01 AND smyacti = 'Y'
       IF cl_null(l_smy57[2,2]) THEN
          LET l_smy57[2,2] = 'N'
       END IF
       LET l_ima24 = l_smy57[2,2]
       #FUN-B30053-add-end--
       LET l_sw = 'Y'                                                                                                               
       #--->產生單身檔 
       CALL aimt325_wo_ins_imn(l_sfa03,l_sfa26,l_sfb25,l_sfb98,l_sfa12,l_ima24,l_sfa05) #TQC-9B0031                                                                     
       IF g_success = 'N' THEN EXIT FOREACH END IF                                                                                  
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

END FUNCTION

FUNCTION aimt325_wo_ins_imn(p_sfa03,p_sfa26,p_sfb25,p_sfb98,p_sfa12,p_ima24,p_sfa05) #TQC-9B0031                                                                       
DEFINE p_sfa03  LIKE sfa_file.sfa03                                                                                                 
DEFINE p_sfa26  LIKE sfa_file.sfa26                                                                                                 
DEFINE p_sfb25  LIKE sfb_file.sfb25                                                                                                 
DEFINE p_sfb98  LIKE sfb_file.sfb98
DEFINE l_ima44  LIKE ima_file.ima44
DEFINE l_ima906 LIKE ima_file.ima906
DEFINE l_ima907 LIKE ima_file.ima907
DEFINE p_sfa12  LIKE sfa_file.sfa12   #TQC-9B0031
DEFINE p_sfa05  LIKE sfa_file.sfa05   #TQC-9B0031
DEFINE p_ima24  LIKE ima_file.ima24   #TQC-9B0031
DEFINE p_cmd    LIKE type_file.chr1
DEFINE l_store  STRING                #FUN-CB0087 add

   INITIALIZE b_imn.* TO NULL    #TQC-9B0031
   LET b_imn.imn01 = g_imm.imm01 #TQC-9B0031
   LET b_imn.imn03 = p_sfa03
   SELECT ima35,ima36 INTO b_imn.imn04,b_imn.imn05   #撥出倉儲                                                                 
     FROM ima_file                    
    WHERE ima01 = p_sfa03
    
   LET b_imn.imn06 = ' '   
   LET b_imn.imn09 = p_sfa12
   LET b_imn.imn20 = b_imn.imn09
   LET b_imn.imn10 = p_sfa05 
   LET b_imn.imn22 = p_sfa05
   LET b_imn.imn29 = p_ima24
   SELECT MAX(imn02) INTO b_imn.imn02 FROM imn_file
    WHERE imn01 = b_imn.imn01
   IF cl_null(b_imn.imn02) THEN
      LET b_imn.imn02 = 0
   END IF 
   LET b_imn.imn02=b_imn.imn02+1                             
   IF g_sma.sma115 = 'Y' THEN                                 
      SELECT ima44,ima906,ima907 INTO l_ima44,l_ima906,l_ima907
        FROM ima_file                                    
       WHERE ima01=b_imn.imn03                            
       IF l_ima906 MATCHES'[23]' THEN                       
          CALL t325_du_default(p_cmd,b_imn.imn03,b_imn.imn04,
                               b_imn.imn05,b_imn.imn06)      
               RETURNING b_imn.imn33,b_imn.imn34,b_imn.imn35, 
                         b_imn.imn30,b_imn.imn31,b_imn.imn32   
       END IF                                            
    END IF                                                
    LET b_imn.imn21 = 1
    LET b_imn.imn27 = 'N'                                                                                             
    IF NOT cl_null(l_imn04) THEN
       LET b_imn.imn04 = l_imn04
    END IF 
    IF NOT cl_null(l_imn05) THEN
       LET b_imn.imn05 = l_imn05
    END IF 
    IF NOT cl_null(l_imn15) THEN
       LET b_imn.imn15 = l_imn15
    END IF 
    IF NOT cl_null(l_imn16) THEN
       LET b_imn.imn16 = l_imn16
    END IF
    IF NOT cl_null(l_imn28) THEN
       LET b_imn.imn28 = l_imn28
    END IF 
    LET b_imn.imnplant = g_plant #TQC-9B0031
    LET b_imn.imnlegal = g_legal #TQC-9B0031
    IF cl_null(b_imn.imn05) THEN LET b_imn.imn05 = ' ' END IF  #TQC-9B0031
    IF cl_null(b_imn.imn06) THEN LET b_imn.imn06 = ' ' END IF  #TQC-9B0031
    IF cl_null(b_imn.imn16) THEN LET b_imn.imn16 = ' ' END IF  #TQC-9B0031
    IF cl_null(b_imn.imn17) THEN LET b_imn.imn17 = ' ' END IF  #TQC-9B0031
    #FUN-CB0087---add---str---
    IF g_aza.aza115 = 'Y' AND cl_null(b_imn.imn28) THEN
       LET l_store = ''
       IF NOT cl_null(b_imn.imn04) THEN
          LET l_store = l_store,b_imn.imn04
       END IF
       IF NOT cl_null(b_imn.imn15) THEN
          IF NOT cl_null(l_store) THEN
             LET l_store = l_store,"','",b_imn.imn15
          ELSE
             LET l_store = l_store,b_imn.imn15
          END IF
       END IF
       LET b_imn.imn28 = s_reason_code(b_imn.imn01,'','',b_imn.imn03,l_store,'',g_imm.imm14)
    END IF
    #FUN-CB0087---add---end---
    LET b_imn.imn12='N' #TQC-DB0039
    LET b_imn.imn24='N' #TQC-DB0039
    INSERT INTO imn_file VALUES(b_imn.*)                     
    IF SQLCA.SQLCODE THEN                                     
       CALL cl_err('insert',SQLCA.sqlcode,0)                  #TQC-9B0037     
    END IF
    LET g_seq = g_seq+1
END FUNCTION
#WO結束
FUNCTION t325_del()
   DELETE FROM imn_file WHERE imn01 = g_imm.imm01                
END FUNCTION
#CHI-C50041---end
#FUN-CB0087---add---str---
FUNCTION t325_imn28_chk()
DEFINE l_flag       LIKE type_file.chr1,
       l_sql        STRING,
       l_where      STRING,
       l_n          LIKE type_file.num5,
       l_i          LIKE type_file.num5,
       l_store      STRING,
       l_azf03         LIKE azf_file.azf03,
       l_azf09         LIKE azf_file.azf09,
       l_azfacti       LIKE azf_file.azfacti
   IF g_aza.aza115 = 'Y' THEN
      FOR l_i=1 TO g_imn.getlength()
         LET l_store = ''
         IF NOT cl_null(g_imn[l_i].imn04) THEN
            LET l_store = l_store,g_imn[l_i].imn04
         END IF
         IF NOT cl_null(g_imn[l_i].imn15) THEN
            IF NOT cl_null(l_store) THEN
               LET l_store = l_store,"','",g_imn[l_i].imn15
            ELSE
               LET l_store = l_store,g_imn[l_i].imn15
            END IF
         END IF
         CALL s_get_where(g_imm.imm01,'','',g_imn[l_i].imn03,l_store,'',g_imm.imm14) RETURNING l_flag,l_where
         IF l_flag THEN
            LET l_n=0
            LET l_sql = " SELECT COUNT(*) FROM ggc_file WHERE ggc08='",g_imn[l_i].imn28,"' AND ",l_where
            PREPARE ggc08_pre3 FROM l_sql
            EXECUTE ggc08_pre3 INTO l_n
            IF l_n < 1 THEN
               CALL cl_err('','aim-425',0)
               RETURN FALSE
            END IF
         ELSE
            LET g_errno = ''
            LET l_azf03 = ''
            LET l_azf09 = ''
            LET l_azfacti = ''
            SELECT azf03,azf09,azfacti INTO l_azf03,l_azf09,l_azfacti FROM azf_file 
            WHERE azf01 = g_imn[l_i].imn28 AND azf02 = '2'

            CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3088'
                                           LET l_azf03 = ''
                                           LET l_azfacti = ''
                 WHEN l_azfacti='N'        LET g_errno = '9028'
                 WHEN l_azf09 != '6'       LET g_errno = 'aoo-405'    
                 OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
            END CASE
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_imn[l_i].imn28,g_errno,0)
               RETURN FALSE
            END IF
         END IF
      END FOR
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t325_imn28_chk1()
DEFINE  l_flag          LIKE type_file.chr1,
        l_n             LIKE type_file.num5,
        l_where         STRING,
        l_sql           STRING,
        l_store         STRING,
        l_azf03         LIKE azf_file.azf03,
        l_azf09         LIKE azf_file.azf09,
        l_azfacti       LIKE azf_file.azfacti
   LET l_store = ''
   IF NOT cl_null(g_imn[l_ac].imn04) THEN
      LET l_store = l_store,g_imn[l_ac].imn04
   END IF
   IF NOT cl_null(g_imn[l_ac].imn15) THEN
      IF NOT cl_null(l_store) THEN
         LET l_store = l_store,"','",g_imn[l_ac].imn15
      ELSE
         LET l_store = l_store,g_imn[l_ac].imn15
      END IF
   END IF
   IF NOT cl_null(g_imn[l_ac].imn28) THEN
      LET l_n = 0
      LET l_flag = FALSE
      IF g_aza.aza115='Y' THEN
         CALL s_get_where(g_imm.imm01,'','',g_imn[l_ac].imn03,l_store,'',g_imm.imm14) RETURNING l_flag,l_where
      END IF
      IF g_aza.aza115='Y' AND l_flag THEN
         LET l_sql = " SELECT COUNT(*) FROM ggc_file WHERE ggc08='",g_imn[l_ac].imn28,"' AND ",l_where
         PREPARE ggc08_pre2 FROM l_sql
         EXECUTE ggc08_pre2 INTO l_n
         IF l_n < 1 THEN
            CALL cl_err('','aim-425',0)
            RETURN FALSE
         END IF
      ELSE
         #SELECT COUNT(*) INTO l_n FROM azf_file WHERE azf01 = g_imn[l_ac].imn28 AND azf02 = '2'
         #IF l_n < 1 THEN
         #   CALL cl_err('','aim-425',0)
         LET g_errno = ''
         SELECT azf03,azf09,azfacti INTO l_azf03,l_azf09,l_azfacti FROM azf_file   
         WHERE azf01 = g_imn[l_ac].imn28 AND azf02 = '2'

         CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3088'
                                        LET l_azf03 = ''
                                        LET l_azfacti = ''
              WHEN l_azfacti='N'        LET g_errno = '9028'
              WHEN l_azf09 != '6'       LET g_errno = 'aoo-405'     
              OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
         END CASE
         IF NOT cl_null(g_errno) THEN
            CALL cl_err(g_imn[l_ac].imn28,g_errno,0)
            RETURN FALSE
         END IF
      END IF
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t325_azf03()
   SELECT azf03 INTO g_imn[l_ac].azf03
     FROM azf_file
    WHERE azf01 = g_imn[l_ac].imn28
      AND azf02 = '2'
   DISPLAY BY NAME g_imn[l_ac].azf03
END FUNCTION
#FUN-CB0087---add---end---

#FUN-D10081---add---str---
FUNCTION t325_list_fill()
  DEFINE l_imm01         LIKE imm_file.imm01
  DEFINE l_i             LIKE type_file.num10

    CALL g_imm_l.clear()
    LET l_i = 1
    FOREACH t325_fill_cs INTO l_imm01
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach item_cur',SQLCA.sqlcode,1)
          CONTINUE FOREACH
       END IF
       SELECT imm01,imm02,imm08,imm14,gem02,imm09,imm11,imm12,
              imm13,gen02,imm04,imm03
         INTO g_imm_l[l_i].*
         FROM imm_file
              LEFT OUTER JOIN gem_file ON gem01 = imm14
              LEFT OUTER JOIN gen_file ON gen01 = imm13
        WHERE imm01=l_imm01
       LET l_i = l_i + 1
       IF l_i > g_max_rec THEN
          IF g_action_choice ="query"  THEN
            CALL cl_err( '', 9035, 0 )
          END IF
          EXIT FOREACH
       END IF
    END FOREACH
    LET g_rec_b4 = l_i - 1
    DISPLAY ARRAY g_imm_l TO s_imm_l.* ATTRIBUTE(COUNT=g_rec_b4,UNBUFFERED)
       BEFORE DISPLAY
          EXIT DISPLAY
    END DISPLAY
    
END FUNCTION

FUNCTION t325_bp2(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1  
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DISPLAY ARRAY g_imm_l TO s_imm_l.* ATTRIBUTE(COUNT=g_rec_b4,UNBUFFERED)
      BEFORE DISPLAY
          CALL fgl_set_arr_curr(g_curs_index)
          CALL cl_navigator_setting( g_curs_index, g_row_count )
       BEFORE ROW
          LET l_ac4 = ARR_CURR()
          LET g_curs_index = l_ac4
          CALL cl_show_fld_cont()

      ON ACTION page_main
         LET g_action_flag = "page_main"
         LET l_ac4 = ARR_CURR()
         LET g_jump = l_ac4
         LET mi_no_ask = TRUE
         IF g_rec_b4 > 0 THEN
             CALL t325_fetch('/')
         END IF
         CALL cl_set_comp_visible("page_list", FALSE)
         CALL cl_set_comp_visible("page_main", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page_list", TRUE)
         CALL cl_set_comp_visible("page_main", TRUE)          
         EXIT DISPLAY

      ON ACTION ACCEPT
         LET g_action_flag = "page_main"
         LET l_ac4 = ARR_CURR()
         LET g_jump = l_ac4
         LET mi_no_ask = TRUE
         CALL t325_fetch('/')  
         CALL cl_set_comp_visible("page_list", FALSE)
         CALL cl_set_comp_visible("page_list", TRUE)
         CALL cl_set_comp_visible("page_main", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page_main", TRUE)    
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
      ON ACTION first
         CALL t325_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)    
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)   
         END IF
         ACCEPT DISPLAY                    
 
 
      ON ACTION previous
         CALL t325_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)    
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)   
         END IF
	 ACCEPT DISPLAY                    
 
 
      ON ACTION jump
         CALL t325_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)    
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)   
         END IF
	 ACCEPT DISPLAY                  
 
 
      ON ACTION next
         CALL t325_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY                    
 
 
      ON ACTION last
         CALL t325_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)    
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)   
         END IF
	 ACCEPT DISPLAY                   
 
      #TQC-D10084---mark---str---
      #ON ACTION detail
      #   LET g_action_choice="detail"
      #   LET l_ac = 1
      #   EXIT DISPLAY
      #TQC-D10084---mark---end---
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   
         CALL t325_mu_ui()   
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
    #@ON ACTION 出至境外倉複製
      ON ACTION copy_offshore_wh
         LET g_action_choice="copy_offshore_wh"
         EXIT DISPLAY
    #@ON ACTION 撥出確認
      ON ACTION conf_transfer_out
         LET g_action_choice="conf_transfer_out"
         EXIT DISPLAY
    #@ON ACTION 撥出確認還原
      ON ACTION undo_transfer_out
         LET g_action_choice="undo_transfer_out"
         EXIT DISPLAY
    #@ON ACTION 撥入維護
      ON ACTION transfer_in_maintain
         LET g_action_choice="transfer_in_maintain"
         EXIT DISPLAY
    #@ON ACTION 撥入確認
      ON ACTION conf_transfer_in
         LET g_action_choice="conf_transfer_in"
         EXIT DISPLAY
    #@ON ACTION 撥入確認還原
      ON ACTION undo_transfer_in
         LET g_action_choice="undo_transfer_in"
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
     
      ON ACTION qry_lot
         LET g_action_choice="qry_lot"
         EXIT DISPLAY 
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		 
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel  
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about          
         CALL cl_about()       
 
    #@ON ACTION 拋轉至SPC
      ON ACTION trans_spc                     
         LET g_action_choice="trans_spc"
         EXIT DISPLAY
     
      ON ACTION related_document                 
         LET g_action_choice="related_document"          
         EXIT DISPLAY    
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
    
      &include "qry_string.4gl"
   END DISPLAY

   CALL cl_set_act_visible("accept,cancel", TRUE)

END FUNCTION
#FUN-D10081---add---end
#DEV-D40013 --add
	#FUN-D40103--add--str--
FUNCTION t325_imechk(p_ime01,p_ime02)
   DEFINE p_ime01         LIKE ime_file.ime01
   DEFINE p_ime02         LIKE ime_file.ime02
   DEFINE l_n             LIKE type_file.num5
   DEFINE l_imeacti       LIKE ime_file.imeacti
   DEFINE l_err           LIKE ime_file.ime02   #TQC-D50116 add

   IF p_ime02 IS NOT NULL AND p_ime02 != ' ' THEN
      SELECT COUNT(*) INTO l_n FROM ime_file
       WHERE ime01= p_ime01 AND ime02= p_ime02
         AND ime05='Y'
      IF l_n=0  THEN
         CALL cl_err(p_ime02,"mfg1101",0)
         RETURN FALSE
      END IF
   END IF
   IF p_ime02 IS NOT NULL THEN
      SELECT imeacti INTO l_imeacti FROM ime_file
       WHERE ime01= p_ime01 AND ime02= p_ime02
         AND ime05='Y'
      IF l_imeacti = 'N' THEN
         LET l_err = p_ime02                             #TQC-D50116 add 
         IF cl_null(l_err) THEN LET l_err= "' '" END IF  #TQC-D50116 add
         CALL cl_err_msg("","aim-507",p_ime01 || "|" || l_err ,0)  #TQC-D50116 
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION
#FUN-D40103--add--end--
