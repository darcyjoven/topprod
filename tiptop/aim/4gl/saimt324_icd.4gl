# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aimt324.4gl
# Descriptions...: 庫存直接調撥作業
# Date & Author..: 95/04/25 by Nick
# Modify.........: 單階調撥 By Melody    新增'是否立即列印'功能
# Modify.......... 97/06/20 By Melody  調撥作業改為 insert 兩筆至 tlf_file
#                                      且來源目的碼分別為 50:99, 99:50
# Modify.........: 97/07/24 By Melody CHECK sma894 是否庫存可扣至負數
# Modify.........: No:7698 03/08/06 By Mandy 在修改撥出倉庫時未重算撥入的換算率,撥入量,導致庫存錯誤!
# Modify.........: No:MOD-490218 04/09/13 by yiting ima02,ima021定義方式使用like
# Modify.........: No.MOD-490371 04/09/22 By Yuna Controlp 未加display
# Modify.........: No.FUN-4A0052 04/10/06 By Yuna 單據編號開窗
# Modify.........: No.MOD-4A0054 04/10/07 By Nicola 當撥入倉庫為新的料+倉時,於撥入倉欄時,使用 [往下鍵]會跳開 insert img動作!
# Modify.........: No.FUN-4B0002 04/11/02 By Mandy 新增Array轉Excel檔功能
# Modify.........: No:MOD-4B0071 04/11/19 By Smapmin 新增撥入倉庫與撥出倉庫開窗功能
# Modify.........: No:MOD-4B0249 04/11/26 By Mandy 用上下筆游標,到下一筆(此筆是沒資料的沒新增)又往上移時會出縣mfg1401 message
# Modify.........: No:FUN-4C0053 04/12/08 By Mandy Q,U,R 加入權限控管處理
# Modify.........: No:MOD-530705 05/03/29 By kim 倉庫間直接調撥應可進行非成本倉間之調撥
# Modify.........: No.FUN-540025 05/04/12 By Carrier 雙單位內容修改
# Modify.........: No:FUN-550011 05/05/24 By kim GP2.0功能 庫存單據不同期要check庫存是否為負
# Modify.........: No.FUN-550082 05/05/30 By vivien 單據編號格式放大
# Modify.........: No:MOD-550074 在修改狀態變更了撥出倉/儲/批,撥入倉/儲/批則撥入量及單位轉換率沒有重新給值,導致庫存錯誤!
# Modify.........: No:FUN-560183 05/06/22 By kim 移除ima86成本單位
# Modify.........: No:MOD-570028 05/07/12 By pengu 進行過帳時，考慮單位換算率
# Modify.........: No:FUN-570235 05/07/27 By kim 單據刪除時 應考慮到RMA 之 rmd34 欄位
# Modify.........: No:MOD-590118 05/09/09 By Carrier 修改set_origin_field
# Modify.........: No:MOD-570329 05/10/05 By pengu 1.撥出倉庫ENTER不能過,需開窗選才能過
# Modify.........: No:FUN-5A0077 05/10/18 By Sarah t324_chk_in(): select img09 無資料時秀適當錯誤訊息
# Modify.........: No:MOD-580291 05/10/05 By Claire 由發料單直接產生調撥單,並不會add_img 導致 "lock img2..." 錯誤
# Modify.........: No:FUN-5A0066 05/10/24 By Sarah 增加進入單身後"查詢倉庫"功能
# Modify.........: No:MOD-5B0237 05/11/23 By Nicola 新的倉儲時會出現 add img 的詢問視窗,但是沒出現 add imgg 的視窗
# Modify.........: No:FUN-5A0029 05/12/02 By Sarah 修改單身後單頭的資料更改者,最近修改日應update
# Modify.........: No.TQC-5C0031 05/12/07 By Carrier set_required時去除單位換算率
# Modify.........: No.MOD-5C0022 05/12/09 By kim 理由碼放大至40
# Modify.........: No:MOD-5B0300 05/12/13 By Sarah t324_chk_in()有錯時一律NEXT FIELD imn17,使其check img
# Modify.........: No:FUN-5C0077 05/12/23 By yoyo單身增加欄位imn29
# Modify.........: No:FUN-610006 06/01/07 By Smapmin 雙單位畫面調整
# Modify.........: No:FUN-610090 06/02/06 By Nicola 拆併箱功能修改
# Modify.........: No:MOD-630025 06/03/06 By Claire 成本倉與非成本倉間不得調撥
# Modify.........: No:TQC-630052 06/03/07 By Claire 流程訊息通知傳參數
# Modify.........: No:TQC-610072 06/03/08 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: NO:TQC-620156 06/03/14 By kim GP3.0過帳錯誤統整顯示功能新增
# Modify.........: No:MOD-610114 06/03/24 By Pengu 單身撥入批號打完後程式會跳到NEXT FIELD imn44，
                                         #         會照成無法計算到單位二數量imn45
# Modify.........: No:MOD-640079 06/04/09 By Carol 未過帳不可執行過帳還原,並顯示錯誤訊息 
# Modify.........: No:MOD-640226 06/04/10 By kim 撥出/撥入單位 分別與庫存單位有換算率 ,但是撥出與撥入沒有換算率 ,造成數量遺失
# Modify.........: NO.FUN-640266 06/04/26 BY yiting 更改cl_err
# Modify.........: No:MOD-650040 06/05/09 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No:TQC-650101 06/05/22 By Ray 增加料件多屬性功能
# Modify.........: No:FUN-660029 06/06/12 By kim GP3.1 增加確認碼欄位與處理
# Modify.........: No:FUN-660078 06/06/14 By rainy aim系統中，用char定義的變數，改為用LIK
# Modify.........: No:TQC-660100 06/06/21 By Rayven 多屬性功能改進:查詢時不顯示多屬性內容
# Modify.........: NO:FUN-660156 06/06/23 By Tracy cl_err -> cl_err3 
# Modify.........: NO:MOD-670009 06/07/04 By Claire 成本倉與非成本倉間不可調撥  
# Modify.........: No:TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No:FUN-670093 06/07/20 By kim GP3.5 利潤中心
# Modify.........: No:FUN-680010 06/08/24 by Joe SPC整合專案-自動新增 QC 單據
# Modify.........: No.TQC-690006 06/09/05 By day 撥入倉單位帶出有誤
# Modify.........: No:MOD-690044 06/09/08 By pengu 身輸入一個不存在的料號時會顯示錯誤訊息,但是仍可移至下個欄位上
# Modify.........: No:FUN-690026 06/09/19 By Carrier 欄位型態用LIKE定義
# Modify.........: No:FUN-680046 06/09/27 By jamie 新增action"相關文件"
# Modify.........: No:FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No:FUN-6B0030 06/11/10 By bnlent  單頭折疊功能修改
# Modify.........: No:MOD-6A0069 06/12/13 By pengu 由工單產生調撥時，當使用新的WIP倉過帳時會有問題
# Modify.........: No:CHI-6A0015 06/12/19 By rainy 輸入料號後，帶出預設倉庫/儲位
# Modify.........: No:FUN-6C0083 07/01/08 By Nicola 錯誤訊息彙整
# Modify.........: No:FUN-710025 07/01/29 By bnlent 錯誤訊息彙整
# Modify.........: No:MOD-720096 07/03/02 By pengu t324_upd_imgg()中若程式有err因該LET g_success='N'就好
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No:FUN-730061 07/03/28 By kim 行業別架構
# Modify.........: No:MOD-740302 07/04/23 By rainy 過帳還原時，如未過帳應先show提示訊息
# Modify.........: No:MOD-740286 07/04/23 By kim 自動產生單身時,檢驗碼沒給值
# Modify.........: No.MOD-740276 07/04/23 By kim 沒有走到 批號欄位 時的img_file檢控，無提示新的倉儲批
# Modify.........: No:FUN-740016 07/05/06 By Nicola 借出管理
# Modify.........: No:TQC-750018 07/05/07 By rainy 更改狀態無更改料號時，不重帶倉庫儲位
# Modify.........: No:CHI-770019 07/07/25 By Carrier 多單位:參考單位時,交易單位不寫入tlff
# Modify.........: No:TQC-780035 07/08/08 By wujie   新增第二筆單身到料號欄位時,若不填內容,鼠標點到第一行,再點回第二行,第二行新增有異常現象,
#                                                    不會根據料號帶出后面預設值,確定保存不報錯,但是重新查詢該筆資料,卻只有第二筆單身,無第一筆.
# Modify.........: NO.CHI-780041 07/08/27 by yiting 1.如果是借貨出貨來源帶出的調撥單時，不再問是否要產生
#                                                   2.如果是借貨出貨來源帶出的調撥單，不詢問mfg1401,這段處理移到出貨扣帳段
# Modify.........: No:TQC-7A0047 07/10/16 By Judy 未過帳時，點擊"過帳還原"應有報錯信息
# Modify.........: No:CHI-7B0023/CHI-7B0039 07/11/14 By kim 移除GP5.0行業別功能的所有程式段
# Modify.........: No:MOD-7C0084 07/12/17 By Pengu 拆併箱所產生的調撥單其調撥日期不應為NULL
# Modify.........: No:FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No:FUN-810036 08/01/16 By Nicola 序號管理
# Modify.........: No:MOD-830095 08/03/20 By Pengu 在AFTER FIELD imn17判斷若撥出單位為NULL則在重新抓值
# Modify.........: No:FUN-840042 08/04/11 By TSD.Wind 自定欄位功能修改
# Modify.........: No:FUN-850120 08/05/23 By rainy 多單位補批序號處理
# Modify.........: No:TQC-860018 08/06/09 By Smapmin 增加on idle控管
# Modify.........: NO.CHI-860008 08/06/11 BY yiting s_del_rvbs
# Modify.........: No:FUN-860045 08/06/12 By Nicola 批/序號傳入值修改及開窗詢問使用者是否回寫單身數量
# Modify.........: No.CHI-860005 08/06/27 By xiaofeizhu 使用參考單位且參考數量為0時，也需寫入tlff_file
# Modify.........: No:CHI-870036 08/08/12 By xiaofeizhu 過帳還原時判斷，如果請調撥單號存在於oga70，則顯示訊息aim1008且不可過帳還原
# Modify.........: No:FUN-880129 08/09/05 By xiaofeizhu s_del_rvbs的傳入參數(出/入庫，單據編號，單據項次，專案編號)，改為(出/入庫，單據編號，單據項次，檢驗順序)
# Modify.........: No:MOD-890243 08/09/25 By claire s_add_imgg應有值接回傳值
# Modify.........: No:FUN-840012 08/10/08 By kim mBarcode 功能修改
# Modify.........: No:MOD-8A0110 08/10/14 By claire 參數設定多單位,料件為單一單位,進入單身按產生鍵時,不會產生
# Modify.........: No:MOD-8C0194 08/12/20 By Smapmin 借貨出貨單過帳所產生的調撥單,要能立即顯示正確的圖示
# Modify.........: No:FUN-8C0084 08/12/22 By jan s_upimg相關改以 料倉儲批為參數傳入 ,不使用 ROWID 
# Modify.........: No:MOD-8C0189 08/12/18 By claire 調整語法,以免於ifx區會執行錯誤
# Modify.........: No:FUN-920207 09/03/05 By jan aimt324.4gl-->aimt324.src.4gl
# Modify.........: No:FUN-920186 09/03/18 By lala 理由碼imn28必須為庫存調撥 
# Modify.........: No.TQC-930155 09/03/30 By Sunyanchun Lock img_file,imgg_file時，若報錯,不要rollback ，要放g_success ='N' 
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.TQC-950134 09/05/22 By Carrier rowid定義規範化
# Modify.........: No.FUN-960065 09/06/29 By mike 調整呼叫q_img4()的程序段， 
# Modify.........: No:FUN-870100 09/08/03 By Cockroach 零售超市移植
# Modify.........: No:FUN-970124 09/08/03 By mike 09/07/31 請在查詢時加上撥出儲位與撥入儲位的開窗功能，查詢的qry為q_ime             
# Modify.........: No:FUN-980004 09/08/25 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No:FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-960022 09/10/15 By chenmoyan 預設單位一數量時，加上判斷，單位一數量為空或為1時，才預設
# Modify.........: No.CHI-960052 09/10/15 By chenmoyan 使用多單位，料件是單一單位或參考單位時，單位一的轉換率錯誤
# Modify.........: No:TQC-9A0113 09/10/23 By liuxqa 修改ROWID替换，OUTER替换。
# Modify.........: No:FUN-930064 09/11/05 By jan 新增時,單身可以依BOM以及工單自動展開
# Modify.........: No:CHI-980019 09/11/05 By jan 虛擬料件不可做任何單據
# Modify.........: No:TQC-9B0031 09/11/09 By jan GP5.2考虑集团架构栏位
# Modify.........: No:TQC-9B0037 09/11/11 By jan s_errmsg 修改傳入參數
# Modify.........: No:TQC-9B0120 09/11/18 By Carrier 增加过帐提示信息
# Modify.........: No:MOD-970165 09/11/26 By sabrina 整體參數使用多單未但料件基本檔設定單一單位時，單位一的換算率會錯誤
# Modify.........: No:MOD-970033 09/11/26 By sabrina 撥入時更新料件的最新入庫日日期傳錯
# Modify.........: No:TQC-9C0013 09/12/04 By lilingyu 單身撥入倉庫欄位,輸入新增的倉庫彈出的信息有誤
# Modify.........: No:MOD-9C0380 09/12/23 By sherry 審核的時候增加判斷撥出撥入倉庫不可以為空
# Modify.........: No:MOD-9C0113 09/12/25 By Pengu 調整sel imgg的錯誤訊息
# Modify.........: No:MOD-A10059 10/01/13 By Pengu 依BOM產單身時應考慮QPA
# Modify.........: No:MOD-A10060 10/01/13 By Pengu 自動產生單身時不應限制倉庫一定是要store倉
# Modify.........: No.FUN-9C0072 10/01/15 By vealxu 精簡程式碼
# Modify.........: No:CHI-A10016 10/01/18 By Dido 調整 s_lotout transcation 架構 
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:CHI-9A0022 10/03/20 By chenmoyan給s_lotout加一個參數:歸屬單號
# Modify.........: No.FUN-A40023 10/03/22 By dxfwo ima26x改善
# Modify.........: No:CHI-A30004 10/03/18 By Sarah 增加"查詢倉庫儲位"功能
# Modify.........: No:MOD-A20099 10/03/30 By Summer 過帳段CALL s_icdpost()若回傳有錯,應為CONTINUE FOREACH,直接RETURN會造成交易前半段資料沒ROLLBACK
# Modify.........: No:MOD-A20083 10/04/07 By Summer 單身輸入時,撥出倉及撥入倉開窗應能開store倉與wip倉
# Modify/........: No:MOD-A40161 10/04/27 By Sarah 將t324_r()裡UPDATE rmd34的段落往前移到t324_fetch()前
# Modify.........: No:MOD-A40173 10/04/29 By Sarah 先依g_user到aooi040抓取所屬部門,抓不到時再預設g_grup
# Modify.........: No:MOD-A50162 10/05/24 By Carrier 审核判断的单身笔数的TABLE错误
# Modify.........: No:TQC-A60063 10/06/17 By lilingyu 單頭輸入完後報錯:無法將NULL值插入到imm_file
# Modify.........: No:MOD-A70117 10/07/15 By Sarah 多單位自動產生單身時,imn20/imn21/imn22值寫入有誤
# Modify.........: No:MOD-A70068 10/07/29 By Smapmin 倉庫間調撥庫存扣帳未考慮"備置"，導致已備置訂單庫存不足無法出貨
# Modify.........: No:MOD-A80004 10/08/02 By sabrina 將g_imm.imm14的值帶入tlf19
# Modify.........: No:MOD-A80088 10/08/12 By Smapmin 重新調整單位二/單位一欄位是否可輸入的判斷
#                                                    重新調整隱藏單據單位的計算
# Modify.........: No:MOD-AA0041 10/10/08 By sabrina 取消確認的同時時，不可以過帳
# Modify.........: No:MOD-AA0103 10/10/18 By sabrina (1)修改MOD-AA0041的錯誤
#                                                    (2)close t324_cl太早將cursor關掉了   
# Modify.........: No:FUN-AA0007 10/10/19 By jan 若輸入的批號之idc17='Y',則控卡不能輸入
# Modify.........: No.FUN-AA0049 10/10/28 by destiny  增加倉庫的權限控管
# Modify.........: No.FUN-AA0059 10/10/29 By huangtao 修改料號AFTER FIELD的管控
# Modify.........: No.FUN-AA0059 10/10/29 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()
# Modify.........: No.FUN-AB0025 10/11/10 By huangtao 取消料號控管
# Modify.........: No.FUN-AB0066 10/11/15 By lilingyu 審核段增加倉庫權限的控管
# Modify.........: No:MOD-AB0161 10/11/17 By sabrina aqct700單子作廢時不可刪除
# Modify.........: No:TQC-AB0223 10/12/02 By huangtao LET g_imm.imm12=''
# Modify.........: No:TQC-AC0218 10/12/17 by jan 由其他程式呼叫本程式時不應該有呼叫外掛程式的感覺
# Modify.........: No:TQC-AC0333 10/12/22 By zhangll 修正倉庫開窗問題
# Modify.........: No:TQC-B10060 11/01/11 By lilingyu 狀態page,部分欄位不可下查詢條件
# Modify.........: No:MOD-B10114 11/01/17 By sabrina 當撥出為可用倉而撥入為不可用倉時，不該控卡ima262
# Modify.........: No:FUN-A60034 11/03/07 By Mandy EasyFlow整合功能
# Modify.........: No:FUN-B30170 11/04/01 By suncx 單身增加批序號明細頁簽
# Modify.........: No:FUN-AC0074 11/05/03 By jan 若單據已備置，則不可取消確認
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B30187 11/06/28 By jason ICD功能修改，增加母批、DATECODE欄位
# Modify.........: No:FUN-B70061 11/07/20 By jason 維護刻號/BIN回寫母批DATECODE
# Modify.........: No.FUN-B30053 11/08/18 By xianghui 輸入單身時應該依據單據別中設定的QC欄位的值為預設值
# Modify.........: No.FUN-B80119 11/09/14 By fengrui  增加調用s_icdpost的p_plant參數
# Modify.........: No.FUN-B90035 11/09/20 By lixh1 所有入庫程式加入可以依料號設置"批號(倉儲批的批)是否為必要輸入欄位"的選項
# Modify.........: No:MOD-BA0129 11/10/18 By johung l_factor給值前要先給預設值
# Modify.........: No:TQC-B90236 11/10/26 By zhuhao s_lotout_del/s_lotin_del/s_del_rvbs程式段Mark，改為s_lot_del，傳入參數不變
#                                                   s_lotout程式段，改為s_mod_lot，傳入參數不變，於最後多傳入-1
# Modify.........: No.FUN-BA0051 11/12/13 By jason 一批號多DATECODE功能
# Modify.........: No.FUN-BC0036 11/12/16 By jason 由aimt324拆過來,與aict324共用
# Modify.........: No:MOD-C10046 12/01/06 By ck2yuan 1.修改單身項次時,先判斷若有rvbs_file的資料時,要先update rvbs_file的項次
#                                                    2.單身新增刪除後重新show
# Modify.........: No.FUN-C20002 12/02/03 By fanbj 券產品的倉庫調整說明
# Modify.........: No.FUN-BC0109 12/02/08 By jason for ICD Datecode回寫多筆時即以","做分隔
# Modify.........: No:FUN-C20025 12/02/08 By Abby EF功能調整-客戶不以整張單身資料送簽問題
# Modify.........: No:MOD-C30001 12/03/01 By Elise s_udima，日期改傳過帳當下日期
# Modify.........: No:MOD-C30526 12/03/12 By bart 1.若撥入倉儲批錯誤應要能夠回到倉庫的欄位
#                                                 2.調撥單要能夠維護撥入批號,不需要控卡一定要同批.
# Modify.........: No:FUN-C30140 12/03/13 By Mandy 簽核時,自動確認失敗,原因:參數定義錯誤
# Modify.........: No:MOD-C30517 12/03/15 By bart 刻號BIN數量不一致時顯示訊息
# Modify.........: No:CHI-C30106 12/04/06 By Elise 批序號維護
# Modify.........: No:FUN-C30302 12/04/13 By bart 修改 s_icdout 回傳值
# Modify.........: No:MOD-C50048 12/05/09 By suncx 過賬時檢查倉庫使用權限
# Modify.........: No.CHI-C30002 12/05/18 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:CHI-C50010 12/06/01 By ck2yuan 調撥時,有效日期應拿原本調撥前的有效日期
# Modify.........: No:TQC-C60005 12/06/01 By bart 單身新增時,請將撥出倉儲批預設帶到撥入倉儲批
# Modify.........: No:FUN-C30085 12/06/20 By lixiang 串CR報表改GR報表
# Modify.........: No:TQC-C60014 12/06/25 By bart aict324單身數量不可輸入，由倉儲批帶數量
# Modify.........: No:FUN-C80030 12/08/10 By fengrui 添加批序號依參數sma95隱藏
# Modify.........: No.FUN-C70087 12/07/24 By bart 整批寫入img_file
# Modify.........: No.TQC-C90027 12/09/06 By qiull 無資料時，點擊批序號按鈕導致程序down出，數組越界問題
# Modify.........: No.FUN-C80107 12/09/18 By suncx 增可按倉庫進行負庫存判斷 
# Modify.........: No.TQC-C90089 12/09/21 By chenjing 修改t324_s()中數組出界問題
# Modify.........: No.CHI-C90036 12/09/25 By bart 在調撥扣帳時，檢查若需要勾稽 QC數量，且 QC 合格量不一致時，詢問 User 是否要依 QC合格量視為調撥量？
# Modify.........: No:MOD-C80134 12/09/27 By jt_chen 借貨出貨產生的調撥單應不能修改,修正MOD-AA0041沒有增加是否為借貨出貨單IF g_argv2!='A' THEN的判斷
# Modify.........: No:TQC-CA0028 12/10/11 By bart 離開程式前要drop temp table
# Modify.........: No:MOD-C90125 12/10/11 By Elise AFTER INSERT後給予至imn09、imn20
# Modify.........: No.MOD-CA0009 12/10/12 By Elise 倉庫有效日期不應控卡
# Modify.........: No:FUN-C90049 12/10/19 By Lori 預設成本倉與非成本倉改從s_get_defstore取
# Modify.........: No:CHI-C70017 12/10/29 By bart 關帳日管控
# Modify.........: No.FUN-CB0087 12/12/06 By qiull 庫存單據理由碼改善
# Modify.........: No:MOD-CC0139 12/12/17 By zhangll 過帳時同img處理方式，imgg若不存在也應增加
# Modify.........: No:MOD-CB0122 13/01/11 By Elise 修正調撥時有效日期問題
# Modify.........: No:MOD-CB0118 13/01/11 By Elise 修正使用多單位料為單一單位時,imn40/42/51 未給正確值
# Modify.........: No:MOD-CB0015 13/01/11 By Elise 選完單別直接按確定需控卡會計期間
# Modify.........: No:FUN-CC0095 13/01/16 By bart 修改整批寫入img_file
# Modify.........: No:FUN-D10081 13/01/18 By qiull 增加資料清單
# Modify.........: No:CHI-C80041 13/01/25 By bart 刪除單頭
# Modify.........: No:MOD-D10182 13/01/25 By bart 清空imn09
# Modify.........: No:TQC-D10084 13/01/29 By qiull 資料清單頁簽不可點擊單身按鈕
# Modify.........: No:CHI-D20008 13/02/06 By bart 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:MOD-D20038 13/02/18 By bart 批號為空時會因為在倉庫儲位欄位卡住導致不能修改
# Modify.........: No:FUN-D20060 13/02/22 By minpp 仓库设卡控
# Modify.........: No:MOD-D20164 13/03/04 By Alberti 若單身倉儲有值,則不重新撈值  
# Modify.........: No:FUN-BC0062 13/02/28 By lixh1 當成本計算方式ccz28選擇'6'，過帳還原時控制不可過帳還原
# Modify.........: No:MOD-C80182 13/03/12 By Alberti 在aimt324_g畫面時,也需控卡成本倉與非成本倉間不可調撥
# Modify.........: No:CHI-C80007 13/03/13 By Alberti 調撥時,先拿撥出倉的呆滯日期,等撥入在s_tlf再依單別決定是否更新呆滯日期 
# Modify.........: No:FUN-D30024 13/03/13 By lixh1 負庫存依據imd23判斷
# Modify.........: No.DEV-D30026 13/03/18 By Nina GP5.3 追版:DEV-CB0005、DEV-CB0021、DEV-CC0001、DEV-D10001、DEV-D10007為GP5.25 的單號
# Modify.........: No.DEV-D30037 13/03/21 By TSD.JIE 有用smyb01="2:條碼單據"的控卡的改為用單身任一筆(MIN(項次)判斷即可)料件是否為包號管理(ima931)='Y'
# Modify.........: No.DEV-D30059 13/04/01 By Nina 批序號相關程式,當料件使用條碼時(ima930 = 'Y'),輸入資料時,
#                                                 不要自動開批序號的Key In畫面(s_mod_lot)
# Modify.........: No.TQC-D40005 13/04/02 By fengrui 控卡“當成本計算方式ccz28選擇'6'，過帳還原時控制不可過帳還原”后,無需再彈窗詢問過帳還原否
# Modify.........: No:FUN-D40030 13/04/07 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:DEV-D30046 13/04/10 By TSD.sophy 將saimt324.4gl的過帳段移至saimt324_sub.4gl
# Modify.........: No.DEV-D40013 13/04/15 By Nina 過單用
# Modify.........: No.FUN-D40053 13/04/15 By bart 增加過帳日欄位
# Modify.........: No.FUN-D40103 13/05/07 By fengrui 添加庫位有效性檢查 
# Modify.........: No.TQC-D50116 13/05/27 By fengrui 修改儲位檢查報錯信息
# Modify.........: No.TQC-D50124 13/05/28 By lixiang 修正FUN-D40103部份邏輯控管
# Modify.........: No:TQC-D40078 13/04/28 By xujing 負庫存函数添加营运中心参数 
# Modify.........: No:TQC-DB0075 13/11/27 By wangrr 點擊"查詢"再"退出",會報錯"-404:找不到光標或說明"

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
DEFINE
    g_imm   RECORD      LIKE imm_file.*,
    g_imm_t RECORD      LIKE imm_file.*,
    g_imm_o RECORD      LIKE imm_file.*,
    b_imn   RECORD      LIKE imn_file.*,
    b_imni  RECORD      LIKE imni_file.*,   #FUN-B30187
    g_yy,g_mm           LIKE type_file.num5,   #No.FUN-690026 SMALLINT
    g_imn02_o           LIKE imn_file.imn02,   #MOD-C10046 add
    g_imn03_t           LIKE imn_file.imn03,
    t_imn04             LIKE imn_file.imn04,
    t_imn05             LIKE imn_file.imn05,
    t_imn15             LIKE imn_file.imn15,
    t_imn16             LIKE imn_file.imn16,
    t_imf04             LIKE imf_file.imf04,
    t_imf05             LIKE imf_file.imf05,
    g_imn               DYNAMIC ARRAY OF RECORD    #程式變數(Prinram Variables)
                        imn02     LIKE imn_file.imn02,
                        imn03     LIKE imn_file.imn03,
                        att00     LIKE imx_file.imx00,
                        att01     LIKE imx_file.imx01,  #No.FUN-690026 VARCHAR(10)
                        att01_c   LIKE imx_file.imx01,  #NoFUN-690026 VARCHAR(10)
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
                        imn29     LIKE imn_file.imn29,  #No:FUN-5C0077
                        ima02     LIKE ima_file.ima02,  #No:MOD-490218
                        ima021    LIKE ima_file.ima021, #No:MOD-490218
                        #imn28     LIKE imn_file.imn28, #FUN-CB0087 mark
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
                        imn43     LIKE imn_file.imn43,
                        imn44     LIKE imn_file.imn44,
                        imn45     LIKE imn_file.imn45,
                        imn40     LIKE imn_file.imn40,
                        imn41     LIKE imn_file.imn41,
                        imn42     LIKE imn_file.imn42,
                        imn10     LIKE imn_file.imn10,
                        imn22     LIKE imn_file.imn22,
                        imn21     LIKE imn_file.imn21,
                        imn52     LIKE imn_file.imn52,
                        imn51     LIKE imn_file.imn51,
                        imn28     LIKE imn_file.imn28,   #FUN-CB0087
                        azf03     LIKE azf_file.azf03,   #FUN-CB0087
                        imnud01 LIKE imn_file.imnud01,
                        imnud02 LIKE imn_file.imnud02,
                        imnud03 LIKE imn_file.imnud03,
                        imnud04 LIKE imn_file.imnud04,
                        imnud05 LIKE imn_file.imnud05,
                        imnud06 LIKE imn_file.imnud06,
                        imnud07 LIKE imn_file.imnud07,
                        imnud08 LIKE imn_file.imnud08,
                        imnud09 LIKE imn_file.imnud09,
                        imnud10 LIKE imn_file.imnud10,
                        imnud11 LIKE imn_file.imnud11,
                        imnud12 LIKE imn_file.imnud12,
                        imnud13 LIKE imn_file.imnud13,
                        imnud14 LIKE imn_file.imnud14,
                        imnud15 LIKE imn_file.imnud15
                        ,imniicd028 LIKE imni_file.imniicd028   #FUN-B30187
                        ,imniicd029 LIKE imni_file.imniicd029   #FUN-B30187
                        END RECORD,
    g_imn_t             RECORD
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
                        imn29     LIKE imn_file.imn29,  #No:FUN-5C0077
                        ima02     LIKE ima_file.ima02,  #No:MOD-490218
                        ima021    LIKE ima_file.ima021, #No:MOD-490218
                        #imn28     LIKE imn_file.imn28, #FUN-CB0087 mark
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
                        imn43     LIKE imn_file.imn43,
                        imn44     LIKE imn_file.imn44,
                        imn45     LIKE imn_file.imn45,
                        imn40     LIKE imn_file.imn40,
                        imn41     LIKE imn_file.imn41,
                        imn42     LIKE imn_file.imn42,
                        imn10     LIKE imn_file.imn10,
                        imn22     LIKE imn_file.imn22,
                        imn21     LIKE imn_file.imn21,
                        imn52     LIKE imn_file.imn52,
                        imn51     LIKE imn_file.imn51,
                        imn28     LIKE imn_file.imn28,   #FUN-CB0087
                        azf03     LIKE azf_file.azf03,   #FUN-CB0087
                        imnud01 LIKE imn_file.imnud01,
                        imnud02 LIKE imn_file.imnud02,
                        imnud03 LIKE imn_file.imnud03,
                        imnud04 LIKE imn_file.imnud04,
                        imnud05 LIKE imn_file.imnud05,
                        imnud06 LIKE imn_file.imnud06,
                        imnud07 LIKE imn_file.imnud07,
                        imnud08 LIKE imn_file.imnud08,
                        imnud09 LIKE imn_file.imnud09,
                        imnud10 LIKE imn_file.imnud10,
                        imnud11 LIKE imn_file.imnud11,
                        imnud12 LIKE imn_file.imnud12,
                        imnud13 LIKE imn_file.imnud13,
                        imnud14 LIKE imn_file.imnud14,
                        imnud15 LIKE imn_file.imnud15
                        ,imniicd028 LIKE imni_file.imniicd028   #FUN-B30187
                        ,imniicd029 LIKE imni_file.imniicd029   #FUN-B30187
                        END RECORD,
    g_img09_s           LIKE img_file.img09,
    g_img09_t           LIKE img_file.img09,
    g_img10_s           LIKE img_file.img10,
    g_img10_t           LIKE img_file.img10,
    g_ima906            LIKE ima_file.ima906,
    g_ima907            LIKE ima_file.ima907,
    g_imgg00            LIKE imgg_file.imgg00,
    g_imgg10            LIKE imgg_file.imgg10,
    g_sw                LIKE type_file.num5,   #No.FUN-690026 SMALLINT
    g_factor            LIKE img_file.img21,
    g_tot               LIKE img_file.img10,
    g_qty               LIKE img_file.img10,
    g_flag              LIKE type_file.chr1,   #No.FUN-690026 VARCHAR(1)
    g_flag1             LIKE type_file.chr1,   #MOD-D20164  VARCHAR(1)
    g_wc,g_wc2,g_sql    string,                #No:FUN-580092 HCN
    h_qty               LIKE ima_file.ima271,
    g_wip               LIKE type_file.chr1,   #MOD-630025  #No.FUN-690026 VARCHAR(1)
    g_t1                LIKE smy_file.smyslip, #No.FUN-550082 #No.FUN-690026 VARCHAR(5)
    g_buf               LIKE gem_file.gem02,   #MOD-5C0022 20->40 #No.FUN-690026 VARCHAR(40)
    sn1,sn2             LIKE type_file.num5,   #No.FUN-690026 SMALLINT
    l_code              LIKE type_file.num5,   #No.FUN-690026 SMALLINT
    g_rec_b             LIKE type_file.num5,   #單身筆數  #No.FUN-690026 SMALLINT
    g_void              LIKE type_file.chr1,   #No.FUN-690026 VARCHAR(1)
    g_chr2              LIKE type_file.chr1,   #No.FUN-A60034 add
    l_ac                LIKE type_file.num5,   #目前處理的ARRAY CNT  #No.FUN-690026 SMALLINT
    g_debit,g_credit    LIKE img_file.img26,
    g_ima25,g_ima25_2   LIKE ima_file.ima25,
    g_img10,g_img10_2   LIKE img_file.img10,
    g_argv1             LIKE imm_file.imm01,   #單號   #No.FUN-550082 #No.FUN-690026 VARCHAR(16)
    g_argv2             LIKE type_file.chr1,   #No:FUN-740016
    g_cmd               LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(100)
DEFINE g_argv3              STRING                 # 指定執行的功能   #TQC-630052
DEFINE g_forupd_sql         STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_chr                LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE g_cnt                LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_i                  LIKE type_file.num5    #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_msg                LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_msg1               LIKE type_file.chr1000 #CHI-A30004 add
DEFINE g_row_count          LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index         LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump               LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_no_ask            LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE l_qcs091             LIKE qcs_file.qcs091     #No.FUN-5C0077
DEFINE g_imm01              LIKE imm_file.imm01      #No.FUN-610090
DEFINE g_unit_arr           DYNAMIC ARRAY OF RECORD  #No:FUN-610090
                               unit   LIKE ima_file.ima25,
                               fac    LIKE img_file.img21,
                               qty    LIKE img_file.img10
                            END RECORD
DEFINE arr_detail           DYNAMIC ARRAY OF RECORD
                            imx00     LIKE imx_file.imx00,
                            imx       ARRAY[10] OF LIKE imx_file.imx01
                            END RECORD
DEFINE lr_agc               DYNAMIC ARRAY OF RECORD LIKE agc_file.*
DEFINE lg_smy62             LIKE smy_file.smy62   #在smy_file中定義的與當前單別關聯的組別
DEFINE lg_group             LIKE smy_file.smy62   #當前單身中采用的組別
DEFINE g_ima918  LIKE ima_file.ima918  #No:FUN-810036
DEFINE g_ima921  LIKE ima_file.ima921  #No:FUN-810036
DEFINE g_ima930  LIKE ima_file.ima930  #No:DEV-D30059 add
DEFINE l_r       LIKE type_file.chr1   #No:FUN-860045
DEFINE g_count   LIKE type_file.num5   #No:CHI-870036
DEFINE g_imm10   LIKE imm_file.imm10   #FUN-BC0036 資料來源


DEFINE g_dies    LIKE ida_file.ida17   #FUN-920207

DEFINE g_argv4              STRING     #No:DEV-D30026

DEFINE  
    tm  RECORD                                                                                                                      
          part   LIKE ima_file.ima01,                                                                                               
          ima910 LIKE ima_file.ima910,    
          qty    LIKE sfb_file.sfb08,                                                                                               
          idate  LIKE type_file.dat,     
          a      LIKE type_file.chr1     
        END RECORD,                                                                                                                 
    g_ima44      LIKE ima_file.ima44,                                                                                               
    g_ccc        LIKE type_file.num5,    
    g_pmk13      LIKE pmk_file.pmk13,    
    l_imn04      LIKE imn_file.imn04,
    l_imn05      LIKE imn_file.imn05,
    l_imn15      LIKE imn_file.imn15,
    l_imn16      LIKE imn_file.imn16,
    l_imn28      LIKE imn_file.imn28

DEFINE                                                                                                                              
    tm1  RECORD                                                                                                                     
         bdate   LIKE type_file.dat,                                                                                                
         sudate  LIKE type_file.dat                                                                                                
         END RECORD                                                                                                                 
DEFINE g_seq     LIKE type_file.num5                                                                                                
DEFINE p_cmd     LIKE type_file.chr1
DEFINE l_sw      LIKE type_file.chr1
DEFINE g_laststage  LIKE type_file.chr1  #FUN-A60034 add
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
DEFINE g_rec_b1            LIKE type_file.num5,   #單身二筆數 ##FUN-B30170
       l_ac1               LIKE type_file.num5    #目前處理的ARRAY CNT  #FUN-B30170
#FUN-B30170 add -end---------------------------
DEFINE g_argv0             LIKE type_file.chr1   #FUN-BC0036
#DEFINE l_img_table      STRING             #FUN-C70087  #FUN-CC0095
#DEFINE l_imgg_table     STRING             #FUN-C70087  #FUN-CC0095
#DEFINE g_sma894     LIKE type_file.chr1    #FUN-C80107  #FUN-D30024
DEFINE g_imd23       LIKE imd_file.imd23    #FUN-D30024
#FUN-D10081---add---str---
DEFINE g_imm_l DYNAMIC ARRAY OF RECORD
               imm01   LIKE imm_file.imm01,
               imm02   LIKE imm_file.imm02,
               imm14   LIKE imm_file.imm14,
               gem02   LIKE gem_file.gem02,
               imm16   LIKE imm_file.imm16,
               gen02   LIKE gen_file.gen02,
               imm09   LIKE imm_file.imm09,
               immmksg LIKE imm_file.immmksg,
               imm15   LIKE imm_file.imm15,
               immconf LIKE imm_file.immconf,
               imm03   LIKE imm_file.imm03
               END RECORD,
        l_ac4      LIKE type_file.num5,
        g_rec_b4   LIKE type_file.num5,
        g_action_flag  STRING
DEFINE   w     ui.Window
DEFINE   f     ui.Form
DEFINE   page  om.DomNode
#FUN-D10081---add---end---

#MAIN   #FUN-BC0036 mark
FUNCTION t324(p_argv0,p_argv1,p_argv2,p_argv3)   #FUN-BC0036 
#FUN-BC0036 --START--
DEFINE p_argv0 LIKE type_file.chr1   #入口程式判別 1.aimt324 2.aict324 
DEFINE p_argv1 LIKE imm_file.imm01   
#FUN-C30140--mod---str---
#DEFINE p_argv2 LIKE type_file.chr1   #Action ID
#DEFINE p_argv3 STRING                #借出管理flag 
 DEFINE p_argv2 STRING                #Action ID	
 DEFINE p_argv3 LIKE type_file.chr1   #借出管理flag 
#FUN-C30140--mod---end---

   WHENEVER ERROR CALL cl_err_msg_log
#FUN-BC0036 --END--

#FUN-BC0036 --START mark--
#   IF FGL_GETENV("FGLGUI") <> "0" THEN   #No:FUN-840012
#      OPTIONS                                #改變一些系統預設值
#          INPUT NO WRAP   ,                  #輸入的方式: 不打轉
#          FIELD ORDER FORM                   #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序)  #FUN-730061
#      DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
#   END IF
#
#&ifdef ICD
#   LET g_prog = "aimt324_icd"    #FUN-920207
#&endif
#
#
#   LET g_argv1=ARG_VAL(1)
#  #FUN-A60034---mod---str---
#  #LET g_argv2=ARG_VAL(2)   #No:FUN-740016
#  #LET g_argv3=ARG_VAL(3)   #TQC-630052
#   LET g_argv3=ARG_VAL(2)   #Action ID
#   LET g_argv2=ARG_VAL(3)   #借出管理flag
#  #FUN-A60034---mod---end---
#
#   IF (NOT cl_user()) THEN
#      EXIT PROGRAM
#   END IF
# 
#   WHENEVER ERROR CALL cl_err_msg_log
# 
#   IF (NOT cl_setup("AIM")) THEN
#      EXIT PROGRAM
#   END IF
#FUN-BC0036 --END mark--

   LET g_argv0=p_argv0   #FUN-BC0036
   LET g_argv1=p_argv1   #FUN-BC0036
  #FUN-C30140---mod---str---
  #LET g_argv2=p_argv2   #FUN-BC0036
  #LET g_argv3=p_argv3   #FUN-BC0036  
   LET g_argv3=p_argv2   #Action ID
   LET g_argv2=p_argv3   #借出管理
  #FUN-C30140---mod---end---
   LET g_argv4=ARG_VAL(4)   #程式代號 #DEV-D30026 add

   LET g_wc2=' 1=1'

   #FUN-A60034--add--str---
   IF fgl_getenv('EASYFLOW') = "1" THEN    #判斷是否為簽核模式
      LET g_argv1 = aws_efapp_wsk(1)       #取得單號
   END IF                                 
   #FUN-A60034--add--end---

   LET g_forupd_sql = "SELECT * FROM imm_file WHERE imm01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t324_cl CURSOR FROM g_forupd_sql

   #CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0074 #FUN-BC0036 移至入口

   INITIALIZE g_imm.* TO NULL
   INITIALIZE g_imm_t.* TO NULL
   INITIALIZE g_imm_o.* TO NULL

   #CALL s_padd_img_create() RETURNING l_img_table   #FUN-C70087  #FUN-CC0095
   #CALL s_padd_imgg_create() RETURNING l_imgg_table #FUN-C70087  #FUN-CC0095
   
   LET g_imm10 = '1'   #FUN-BC0036
   #FUN-BC0036 --START--   
   IF g_argv0 = '2' THEN
      LET g_imm10 = '5' #刻號/BIN調整單  
   END IF       

   IF g_bgjob='N' OR cl_null(g_bgjob) THEN   
      #FUN-BC0036 --START--
      IF g_argv0 = '2' THEN         
         OPEN WINDOW t324_w WITH FORM "aic/42f/aict324"
           ATTRIBUTE (STYLE = g_win_style CLIPPED)     
      ELSE
         OPEN WINDOW t324_w WITH FORM "aim/42f/aimt324"
           ATTRIBUTE (STYLE = g_win_style CLIPPED)
      END IF
      #FUN-BC0036 --END--    
      CALL cl_ui_init()
      CALL t324_def_form()
   END IF
 

   #FUN-A60034---add---str--
   CALL aws_efapp_toolbar()    #建立簽核模式時的 toolbar icon 
   #FUN-A60034---add---end--
    LET g_flag1 = 'N'      #MOD-D20164
    #初始化界面的樣式(沒有任何默認屬性組)                                                                                           
    LET lg_smy62 = ''                                                                                                               
    LET lg_group = ''                                                                                                               
    CALL t324_refresh_detail()                                                                                                      

    IF NOT cl_null(g_argv1) THEN
       CASE g_argv3
          WHEN "query"
             LET g_action_choice = "query"
             IF cl_chk_act_auth() THEN
                CALL t324_q()
             END IF
          WHEN "insert"
             LET g_action_choice = "insert"
             IF cl_chk_act_auth() THEN
                CALL t324_a()
             END IF
          #FUN-A60034--add---str---
          WHEN "efconfirm"
             LET g_action_choice = "efconfirm"
             CALL t324_q()
            #CALL t324_y_chk()                   #CALL 原確認的 check 段 
             CALL t324sub_y_chk(g_imm.imm01)     #CALL 原確認的 check 段 
             IF g_success = 'Y' THEN
                #CALL t324_y_upd()                               #CALL 原確認的 update 段 
                 CALL t324sub_y_upd(g_imm.imm01,g_action_choice) #CALL 原確認的 update 段 
             END IF
             #CALL s_padd_img_drop(l_img_table)    #TQC-CA0028  #FUN-CC0095
             #CALL s_padd_imgg_drop(l_imgg_table)  #TQC-CA0028  #FUN-CC0095
             CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-BC0036
             EXIT PROGRAM
          #FUN-A60034--add---end---

          OTHERWISE 
             CALL t324_q()
             IF g_argv2='A' THEN
                #CALL t324_s()   #DEV-30046 --mark
                CALL t324sub_s(g_imm.imm01,g_argv2,g_argv4)   #DEV-D30046 --add
             END IF
             IF g_argv2="M" THEN
              #CALL t324_y_chk()                                                           #FUN-A60034 mark
               CALL t324sub_y_chk(g_imm.imm01)     #CALL 原確認的 check 段                 #FUN-A60034 add
               IF g_success = "Y" THEN
                 #CALL t324_y_upd()                                                        #FUN-A60034 mark
                  CALL t324sub_y_upd(g_imm.imm01,g_action_choice) #CALL 原確認的 update 段 #FUN-A60034 add
                  CALL t324sub_refresh(g_imm.imm01) RETURNING g_imm.*                      #FUN-A60034 add
                  CALL t324_show()                                                         #FUN-A60034 add
               END IF
               IF g_success = "Y" THEN
                  #CALL t324_s()  #DEV-D30046 --mark 
                  CALL t324sub_s(g_imm.imm01,g_argv2,g_argv4)   #DEV-D30046 --add
               END IF
               #CALL s_padd_img_drop(l_img_table)    #TQC-CA0028  #FUN-CC0095
               #CALL s_padd_imgg_drop(l_imgg_table)  #TQC-CA0028  #FUN-CC0095
               CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-BC0036
               EXIT PROGRAM
             END IF
       END CASE
    END IF
    IF g_azw.azw04 <> '2' THEN
       CALL cl_set_comp_visible('immplant,immplant_desc',FALSE)
    END IF

   #FUN-A60034---add---str---
   ##傳入簽核模式時不應執行的 action 清單
   CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, confirm, undo_confirm,easyflow_approval,post,undo_post,ebo_transfer,aic_s_icdout")  
         RETURNING g_laststage
   #FUN-A60034---add---end---

   CALL t324_menu()

   CLOSE WINDOW t324_w                    #結束畫面
   #CALL s_padd_img_drop(l_img_table)    #FUN-C70087  #FUN-CC0095
   #CALL s_padd_imgg_drop(l_imgg_table)  #FUN-C70087  #FUN-CC0095
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
#END MAIN  #FUN-BC0036 mark
END FUNCTION   #FUN-BC0036

FUNCTION t324_cs()
   DEFINE lc_qbe_sn LIKE gbm_file.gbm01    #No:FUN-580031  HCN
   DEFINE l_imn03   LIKE imn_file.imn03

   IF cl_null(g_argv1) THEN
      CLEAR FORM                             #清除畫面
      CALL g_imn.clear()
      CALL cl_set_head_visible("","YES")   #No.FUN-6B0030

      CONSTRUCT BY NAME g_wc ON imm01,imm02,imm09,imm14,
                                imm16,immmksg,imm15,  #FUN-A60034 add
                                immplant,immconf,immspc,imm03, #FUN-660029 #FUN-670093 #FUN-680010 #FUN-870100
                                immuser,immgrup,
                                immoriu,immorig,    #TQC-B10060 add
                                immmodu,immdate,
                                immud01,immud02,immud03,immud04,immud05,
                                immud06,immud07,immud08,immud09,immud10,
                                immud11,immud12,immud13,immud14,immud15,
                                imm17  #FUN-D40053

         BEFORE CONSTRUCT
            INITIALIZE g_imm.* TO NULL
                  CALL cl_qbe_init()
 
         ON ACTION controlp
            CASE WHEN INFIELD(imm01) #查詢單据
                CALL cl_init_qry_var()
                LET g_qryparam.state= "c"
                LET g_qryparam.form = "q_imm103"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret to imm01
                NEXT FIELD imm01
               WHEN INFIELD(imm14)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gem"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_imm.imm14
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imm14
                  NEXT FIELD imm14
               #FUN-A60034 add str ----             
                WHEN INFIELD(imm16) #申請人員
                   CALL cl_init_qry_var() 
                   LET g_qryparam.form = "q_gen" 
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret 
                   DISPLAY g_qryparam.multiret TO imm16
                   NEXT FIELD imm16
               #FUN-A60034 add end ---- 
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

      IF INT_FLAG THEN RETURN END IF

      CONSTRUCT g_wc2 ON imn02,imn03,imn29,imn28,imn04,imn05,imn06,imn09,imn9301,   #NO.FUN-5C0077  #FUN-670093
                         imn33,imn34,imn35,imn30,imn31,imn32,
                         imn15,imn16,imn17,imn20,imn9302,  #FUN-670093
                         imn43,imn44,imn45,imn40,imn41,imn42,
                         imn10,imn22,imn21,
                         imn52,imn51
                         ,imnud01,imnud02,imnud03,imnud04,imnud05
                         ,imnud06,imnud07,imnud08,imnud09,imnud10
                         ,imnud11,imnud12,imnud13,imnud14,imnud15
                         ,imniicd028,imniicd029   #FUN-B30187
           FROM s_imn[1].imn02,s_imn[1].imn03,s_imn[1].imn29,s_imn[1].imn28,s_imn[1].imn04,   #No.FUN-5C0077
                s_imn[1].imn05,s_imn[1].imn06,s_imn[1].imn09,s_imn[1].imn9301,  #FUN-670093
                s_imn[1].imn33,s_imn[1].imn34,s_imn[1].imn35,
                s_imn[1].imn30,s_imn[1].imn31,s_imn[1].imn32,
                s_imn[1].imn15,s_imn[1].imn16,s_imn[1].imn17,
                s_imn[1].imn20,s_imn[1].imn9302,  #FUN-670093
                s_imn[1].imn43,s_imn[1].imn44,s_imn[1].imn45,
                s_imn[1].imn40,s_imn[1].imn41,s_imn[1].imn42,
                s_imn[1].imn10,s_imn[1].imn22,
                s_imn[1].imn21,
                s_imn[1].imn52,s_imn[1].imn51
                ,s_imn[1].imnud01,s_imn[1].imnud02,s_imn[1].imnud03,s_imn[1].imnud04,s_imn[1].imnud05
                ,s_imn[1].imnud06,s_imn[1].imnud07,s_imn[1].imnud08,s_imn[1].imnud09,s_imn[1].imnud10
                ,s_imn[1].imnud11,s_imn[1].imnud12,s_imn[1].imnud13,s_imn[1].imnud14,s_imn[1].imnud15
                ,s_imn[1].imniicd028,s_imn[1].imniicd029   #FUN-B30187

         BEFORE CONSTRUCT
            CALL g_imn.clear()
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
         ON ACTION controlp
            CASE WHEN INFIELD(imn03)
#FUN-AA0059 --Begin--
                #    CALL cl_init_qry_var()
                #    LET g_qryparam.form ="q_ima"
                #    LET g_qryparam.state = "c"
                #    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                    DISPLAY g_qryparam.multiret TO imn03
                    NEXT FIELD imn03

              WHEN INFIELD(imn28) #理由
                   CALL cl_init_qry_var()
                   LET g_qryparam.form     = "q_azf01a"         #FUN-920186
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.default1 = g_imn[1].imn28
                   LET g_qryparam.arg1     = "6"             #FUN-920186
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO imn28
                   NEXT FIELD imn28
               WHEN INFIELD(imn04)
                    #No.FUN-AA0049--begin
                    #CALL cl_init_qry_var()
                    #LET g_qryparam.form     = "q_imn3"
                    #LET g_qryparam.state    = "c"
                    #CALL cl_create_qry() RETURNING g_qryparam.multiret
                    CALL q_imd_1(TRUE,TRUE,"","","","","") RETURNING g_qryparam.multiret 
                    #No.FUN-AA0049--end
                    DISPLAY g_qryparam.multiret TO imn04
                    NEXT FIELD imn04
               WHEN INFIELD(imn05)                                                                                                  
                    #No.FUN-AA0049--begin                                                                                              
                    #CALL cl_init_qry_var()                                                                                          
                    #LET g_qryparam.form     = "q_ime"                                                                               
                    #LET g_qryparam.state    = "c"                                                                                   
                    #CALL cl_create_qry() RETURNING g_qryparam.multiret    
                    CALL q_ime_1(TRUE,TRUE,"","","",g_plant,"","","") RETURNING g_qryparam.multiret  
                    #No.FUN-AA0049--end                                                                 
                    DISPLAY g_qryparam.multiret TO imn05                                                                            
                    NEXT FIELD imn05                                                                                                
               WHEN INFIELD(imn16)                                                                                                  
                    #No.FUN-AA0049--begin                                                                                             
                    #CALL cl_init_qry_var()                                                                                          
                    #LET g_qryparam.form     = "q_ime"                                                                               
                    #LET g_qryparam.state    = "c"                                                                                   
                    #CALL cl_create_qry() RETURNING g_qryparam.multiret    
                    CALL q_ime_1(TRUE,TRUE,"","","",g_plant,"","","") RETURNING g_qryparam.multiret
                    #No.FUN-AA0049--end                                                            
                    DISPLAY g_qryparam.multiret TO imn16                                                                            
                    NEXT FIELD imn16                                                                                                
               WHEN INFIELD(imn15)
                    #No.FUN-AA0049--begin
                    #CALL cl_init_qry_var()
                    #LET g_qryparam.form     = "q_imn4"
                    #LET g_qryparam.state    = "c"
                    #CALL cl_create_qry() RETURNING g_qryparam.multiret
                    CALL q_imd_1(TRUE,TRUE,"","","","","") RETURNING g_qryparam.multiret 
                    #No.FUN-AA0049--end
                    DISPLAY g_qryparam.multiret TO imn15
                    NEXT FIELD imn15
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
               #FUN-B30187 --START--
                WHEN INFIELD(imniicd029 )
                   CALL q_slot(TRUE,TRUE,g_imn[1].imniicd029,g_imn[1].imn06,'')                         
                       RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO imniicd029
                   NEXT FIELD imniicd029
                #FUN-B30187 --END--  
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
         #LET INT_FLAG = 0 #TQC-DB0075 mark
         RETURN
      END IF
   ELSE
      LET g_wc=" imm01='",g_argv1,"'"
      LET g_wc2=" 1=1"
   END IF

   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('immuser', 'immgrup')

   IF g_wc2 = " 1=1" THEN               # 若單身未輸入條件
      LET g_sql = "SELECT imm01 FROM imm_file",
                  #" WHERE imm10 = '1'",              #FUN-BC0036 mark
                  " WHERE imm10 = '", g_imm10 ,"'",   #FUN-BC0036                  
                  " AND immplant IN ",g_auth,      #No.FUN-870100 
                  " AND ", g_wc CLIPPED,
                  " ORDER BY imm01"
   ELSE                  # 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE  imm01 ",
                  "  FROM imm_file, imn_file",
                  " WHERE imm01 = imn01",
                  #"   AND imm10 = '1'  ",            #FUN-BC0036 mark
                  "   AND imm10 = '", g_imm10 ,"'",   #FUN-BC0036
                  "   AND immplant=imnplant",    #No.FUN-870100
                  "   AND immplant IN ",g_auth,      #No.FUN-870100
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY imm01"
      #FUN-B30187 --START--
      IF g_wc2.getindexof('imni',1)>0 THEN
         LET g_sql = "SELECT UNIQUE imm01 ",
                     "  FROM imm_file, imn_file,imni_file",
                     " WHERE imm01 = imn01",
                     "   AND imn01 = imni01  ",
                     "   AND imn02 = imni02  ",
                     #"   AND imm10 = '1'  ",            #FUN-BC0036 mark
                     "   AND imm10 = '", g_imm10 ,"'",   #FUN-BC0036
                     "   AND immplant=imnplant",    
                     "   AND immplant IN ",g_auth,   
                     "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                     " ORDER BY imm01"
      END IF                      
      #FUN-B30187 --END--
   END IF

   PREPARE t324_prepare FROM g_sql
   DECLARE t324_cs SCROLL CURSOR WITH HOLD FOR t324_prepare
   DECLARE t324_fill_cs CURSOR WITH HOLD FOR t324_prepare   #FUN-D10081 add

   IF g_wc2 = " 1=1" THEN        # 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM imm_file ",
                #"WHERE imm10 = '1'",              #FUN-BC0036 mark
                "WHERE imm10 = '", g_imm10 ,"'",   #FUN-BC0036
                "AND immplant IN ",g_auth,      #No.FUN-870100
                " AND ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT imm01) FROM imm_file,imn_file ",
                #" WHERE imm10 = '1' ",             #FUN-BC0036 mark 
                " WHERE imm10 = '", g_imm10 ,"'",   #FUN-BC0036
                " AND immplant=imnplant",    #No.FUN-870100
                " AND immplant IN ",g_auth,      #No.FUN-870100
                " AND imm01=imn01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
      #FUN-B30187 --START--
      IF g_wc2.getindexof('imni',1)>0 THEN
         LET g_sql="SELECT COUNT(DISTINCT imm01) FROM imm_file,imn_file,imni_file ",
                   #" WHERE imm10 = '1' ",             #FUN-BC0036 mark
                   " WHERE imm10 = '", g_imm10 ,"'",   #FUN-BC0036
                   " AND imn01 = imni01  ",
                   " AND imn02 = imni02  ",
                   " AND immplant=imnplant",    
                   " AND immplant IN ",g_auth,      
                   " AND imm01=imn01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
      END IF 
      #FUN-B30187 --END--
   END IF

   PREPARE t324_precount FROM g_sql
   DECLARE t324_count CURSOR FOR t324_precount

END FUNCTION

FUNCTION t324_menu()
DEFINE l_creator    LIKE type_file.chr1      #FUN-A60034 add
DEFINE l_flowuser   LIKE type_file.chr1      #FUN-A60034 add
DEFINE l_imn RECORD LIKE imn_file.*    #FUN-920207
DEFINE l_r          LIKE type_file.chr1  #FUN-C30302
DEFINE l_qty        LIKE type_file.num15_3  #FUN-C30302
DEFINE l_ima906     LIKE ima_file.ima906 #FUN-C30302
   
   LET l_flowuser = "N"                         #FUN-A60034 add

   WHILE TRUE
      IF cl_null(g_action_flag) OR g_action_flag = "page_main" THEN      #FUN-D10081 add
         CALL t324_bp("G")
      #FUN-D10081---add---str---
      ELSE 
         CALL t324_list_fill()
         CALL t324_bp2("G")
         IF NOT cl_null(g_action_choice) AND l_ac4>0 THEN #將清單的資料回傳到主畫面
            SELECT imm_file.* INTO g_imm.*
              FROM imm_file
             WHERE imm01 = g_imm_l[l_ac4].imm01
         END IF 
         IF g_action_choice!= "" THEN
            LET g_action_flag = "page_main"
            LET l_ac4 = ARR_CURR()
            LET g_jump = l_ac4
            LET g_no_ask = TRUE
            IF g_rec_b4 >0 THEN
               CALL t324_fetch('/')
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
               CALL t324_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t324_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t324_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t324_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t324_b()
               CALL t324_show()   #MOD-C10046 ad
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t324_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "post"
            IF cl_chk_act_auth() THEN
               #CALL t324_s()   #DEV-D30046 --mark
               #DEV-D30046 --add--begin
               CALL t324sub_s(g_imm.imm01,g_argv2,g_argv4)
               CALL t324sub_refresh(g_imm.imm01) RETURNING g_imm.*                      #FUN-A6
               CALL t324_show()                                                         #FUN-A6
               #DEV-D30046 --add--end
               IF g_imm.immconf='X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_imm.immconf,"",g_imm.imm03,"",g_void,"")
            END IF
         WHEN "undo_post"
            IF cl_chk_act_auth() THEN
               LET g_success = 'Y'              #No.TQC-9B0120
               IF g_imm.imm03 = 'N' THEN
                  CALL cl_err('','aim-206',0)
                  LET g_success = 'N'           #No.TQC-9B0120
               END IF
               LET g_count = 0 
               SELECT COUNT(*) INTO g_count 
                 FROM oga_file
                WHERE oga70 = g_imm.imm01  
            #FUN-BC0062 ---------Begin--------
            #當成本計算方式ccz28選擇'6'，過帳還原時控制不可過帳還原
               SELECT ccz_file.* INTO g_ccz.* FROM ccz_file WHERE ccz00='0'
               #IF g_ccz.ccz28  = '6' THEN                     #TQC-D40005 mark
               IF g_ccz.ccz28  = '6' AND g_success = 'Y' THEN  #TQC-D40005 add
                  CALL cl_err('','apm-936',1)
                  LET g_success = 'N' 
               END IF
            #FUN-BC0062 ---------End----------
               #IF g_imm.immconf = 'Y' AND g_imm.imm03 = 'Y' THEN #FUN-660029 #TQC-7A0047 #TQC-D40005 mark
               IF g_imm.immconf = 'Y' AND g_imm.imm03 = 'Y' AND g_success = 'Y' THEN      #TQC-D40005 add
                 #---NO.CHI-780041 start---非借貨出貨單來源之調撥單才可以過帳還原
                  IF g_argv2='A' OR g_count <> 0 THEN                 #CHI-870036 Add "OR g_count <> 0"
                     CALL cl_err('','aim1008',1)
                     LET g_success = 'N'           #No.TQC-9B0120
                  ELSE  
                     IF g_imm.imm03 = 'N' THEN
                        CALL cl_err('','aim-206',0)
                        LET g_success = 'N'           #No.TQC-9B0120
                     END IF                           #No.TQC-9B0120
                     #CHI-C70017---begin
                     IF g_success = 'Y' THEN 
                        #IF g_sma.sma53 IS NOT NULL AND g_imm.imm02 <= g_sma.sma53 THEN  #FUN-D40053
                        IF g_sma.sma53 IS NOT NULL AND g_imm.imm17 <= g_sma.sma53 THEN  #FUN-D40053
                           CALL cl_err('','mfg9999',0)
                           LET g_success = 'N'
                        END IF
                        #CALL s_yp(g_imm.imm02) RETURNING g_yy,g_mm  #FUN-D40053
                        CALL s_yp(g_imm.imm17) RETURNING g_yy,g_mm  #FUN-D40053
                        IF g_yy > g_sma.sma51 THEN     # 與目前會計年度,期間比較
                           CALL cl_err(g_yy,'mfg6090',0)
                           LET g_success = 'N'
                        ELSE
                           IF g_yy=g_sma.sma51 AND g_mm > g_sma.sma52 THEN
                              CALL cl_err(g_mm,'mfg6091',0)
                              LET g_success = 'N' 
                           END IF
                        END IF
                     END IF 
                     #CHI-C70017---end
                     #IF g_bgjob='N' OR cl_null(g_bgjob) THEN                     #TQC-D40005 mark
                     IF g_bgjob='N' OR cl_null(g_bgjob) AND g_success = 'Y' THEN  #TQC-D40005 add              
                        IF NOT cl_confirm('asf-663') THEN                   
                           LET g_success = 'N'                              
                        END IF                                              
                     END IF                                                 
                     IF g_success = 'Y' THEN          #No.TQC-9B0120
                       #LET g_msg="aimp378 '",g_imm.imm01,"'"       #TQC-AC0218
                        LET g_msg="aimp378 '",g_imm.imm01,"' 'Y' "  #TQC-AC0218
                        CALL cl_cmdrun_wait(g_msg)
                        SELECT imm03 INTO g_imm.imm03 FROM imm_file
                        WHERE imm01=g_imm.imm01
                        DISPLAY g_imm.imm03 TO imm03
                        IF g_imm.immconf='X' THEN
                           LET g_void = 'Y'
                        ELSE
                           LET g_void = 'N'
                        END IF
                        CALL cl_set_field_pic(g_imm.immconf,"",g_imm.imm03,"",g_void,"")
                      END IF   #MOD-740302 
                  END IF       #NO.CHI-780041  add
               ELSE 
                  CASE g_imm.immconf #FUN-660029
                      WHEN 'N'     CALL cl_err(g_imm.imm01,'aim-206',1) 
                      WHEN 'X'     CALL cl_err(g_imm.imm01,'9024',1) 
                      OTHERWISE
                  END CASE
               END IF
            END IF
         WHEN "void"
            IF cl_chk_act_auth() THEN
               #CALL t324_x()  #CHI-D20008
               CALL t324_x(1)  #CHI-D20008
                IF g_imm.immconf = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_imm.immconf,"",g_imm.imm03,"",g_void,"") #FUN-660029
            END IF
         #CHI-D20008---begin   
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               #CALL t324_x()  #CHI-D20008
               CALL t324_x(2)  #CHI-D20008
                IF g_imm.immconf = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_imm.immconf,"",g_imm.imm03,"",g_void,"") #FUN-660029
            END IF
         #CHI-D20008---end
        WHEN "aic_s_icdqry_in"  
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_imm.imm01) THEN
                  CALL s_icdqry(1,g_imm.imm01,'',g_imm.imm03,'')
               END IF
            END IF

         WHEN "aic_s_icdqry_out"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_imm.imm01) THEN
                  CALL s_icdqry(-1,g_imm.imm01,'',g_imm.imm03,'')
               END IF
            END IF

         WHEN "aic_s_icdout"
            IF cl_chk_act_auth() THEN
               #FUN-A60034  add str ---              
               IF g_imm.imm15 matches '[Ss]' THEN
                   CALL cl_err('','apm-030',0) #送簽中, 不可修改資料!
               ELSE
               #FUN-A60034  add end ---              
                   IF NOT cl_null(g_imm.imm01) AND g_imm.imm03 = 'N' AND
                      g_imm.immconf = 'N' AND   #FUN-BC0036 
                      NOT cl_null(l_ac) AND l_ac <> 0 THEN
                      SELECT * INTO l_imn.* FROM imn_file
                       WHERE imn01 = g_imm.imm01
                         AND imn02 = g_imn[l_ac].imn02
                      LET g_dies = 0 
                      CALL s_icdout(l_imn.imn03,l_imn.imn04,l_imn.imn05,
                                     l_imn.imn06,l_imn.imn09,l_imn.imn10,
                                     #g_imm.imm01,l_imn.imn02,g_imm.imm02,'Y', #FUN-D40053
                                     g_imm.imm01,l_imn.imn02,g_imm.imm17,'Y',  #FUN-D40053
                                     l_imn.imn15,l_imn.imn16,l_imn.imn17,
                                     l_imn.imn20)
                           RETURNING g_dies,l_r,l_qty   #FUN-C30302
                     #FUN-C30302---begin
                     IF l_r = 'Y' THEN
                         LET l_qty = s_digqty(l_qty,l_imn.imn09) 
                         LET g_imn[l_ac].imn10 = l_qty
                         LET g_imn[l_ac].imn22 = l_qty
                         LET g_imn[l_ac].imn32 = l_qty
                         LET g_imn[l_ac].imn42 = l_qty

                         UPDATE imn_file set imn10 = g_imn[l_ac].imn10,
                                             imn22 = g_imn[l_ac].imn22,
                                             imn32 = g_imn[l_ac].imn32,
                                             imn42 = g_imn[l_ac].imn42
                          WHERE imn01=g_imm.imm01 AND imn02=g_imn[l_ac].imn02
                         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                            LET g_imn[l_ac].imn10 = b_imn.imn10
                            LET g_imn[l_ac].imn22 = b_imn.imn22
                            LET g_imn[l_ac].imn32 = b_imn.imn32
                            LET g_imn[l_ac].imn42 = b_imn.imn42
                            LET g_success  = 'N'  
                         ELSE
                            LET b_imn.imn10 = g_imn[l_ac].imn10
                            LET b_imn.imn22 = g_imn[l_ac].imn22
                            LET b_imn.imn32 = g_imn[l_ac].imn32
                            LET b_imn.imn42 = g_imn[l_ac].imn42
                         END IF
                         DISPLAY BY NAME g_imn[l_ac].imn10, g_imn[l_ac].imn32,
                                         g_imn[l_ac].imn42, g_imn[l_ac].imn22
                                         
                         SELECT ima906 INTO l_ima906
                         FROM ima_file WHERE ima01 = g_imn[l_ac].imn03

                         IF l_ima906 = '1' THEN
                            LET g_imn[l_ac].imn35 = l_qty
                            LET g_imn[l_ac].imn45 = l_qty
                            
                            UPDATE imn_file set imn35 = g_imn[l_ac].imn35,
                                                imn45 = g_imn[l_ac].imn45
                             WHERE imn01=g_imm.imm01 AND imn02=g_imn[l_ac].imn02
                            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                               LET g_imn[l_ac].imn35 = b_imn.imn35
                               LET g_imn[l_ac].imn45 = b_imn.imn45
                               LET g_success  = 'N'  
                            ELSE
                               LET b_imn.imn35 = g_imn[l_ac].imn35
                               LET b_imn.imn45 = g_imn[l_ac].imn45
                            END IF
                            DISPLAY BY NAME g_imn[l_ac].imn35,g_imn[l_ac].imn45
                         END IF 
                     END IF 
                     #FUN-C30302---end
                      CALL t324_upd_dies()  
                   END IF
               END IF #FUN-A60034 add
            END IF
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
              #CALL t324_y_chk()                                                           #FUN-A60034 mark
               CALL t324sub_y_chk(g_imm.imm01)     #CALL 原確認的 check 段                 #FUN-A60034 add
               IF g_success = "Y" THEN
                 #CALL t324_y_upd()                                                        #FUN-A60034 mark
                  CALL t324sub_y_upd(g_imm.imm01,g_action_choice) #CALL 原確認的 update 段 #FUN-A60034 add
                  CALL t324sub_refresh(g_imm.imm01) RETURNING g_imm.*                      #FUN-A60034 add
                  CALL t324_show()                                                         #FUN-A60034 add
               END IF
            END IF

         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t324_z()
            END IF
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
               CALL t324_spc()
            END IF 

         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               IF g_imm.imm01 IS NOT NULL THEN
                  LET g_doc.column1 = "imm01"
                  LET g_doc.value1 = g_imm.imm01
                  CALL cl_doc()
               END IF
            END IF
 
        WHEN "qry_lot"
           IF l_ac > 0 THEN                   #TQC-C90027  add
              SELECT ima918,ima921 INTO g_ima918,g_ima921 
                FROM ima_file
               WHERE ima01 = g_imn[l_ac].imn03
                 AND imaacti = "Y"
           
              IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                 LET g_success = 'Y'              #CHI-A10016
                 BEGIN WORK                       #CHI-A10016
                 #CALL s_lotout(g_prog,g_imm.imm01,g_imn[l_ac].imn02,0,    #TQC-B90236 mark
                 CALL s_mod_lot(g_prog,g_imm.imm01,g_imn[l_ac].imn02,0,    #TQC-B90236 add
                                g_imn[l_ac].imn03,g_imn[l_ac].imn04,
                                g_imn[l_ac].imn05,g_imn[l_ac].imn06,
                                g_imn[l_ac].imn09,g_imn[l_ac].imn09,1,
                                g_imn[l_ac].imn10,'','QRY',-1) #FUN-9A0022 add ''   #TQC-B90236 add '-1'
                      RETURNING l_r,g_qty 
                 #-CHI-A10016-add-
                 IF g_success = "Y" THEN
                    COMMIT WORK
                 ELSE
                    ROLLBACK WORK    
                 END IF
                 #-CHI-A10016-end-
             END IF
           END IF                             #TQC-C90027  add
         #FUN-A60034---add----str---
         WHEN "approval_status"               #簽核狀況
           IF cl_chk_act_auth() THEN          #DISPLAY ONLY
              IF aws_condition2() THEN        
                 CALL aws_efstat2()    
              END IF
           END IF
         
         WHEN "easyflow_approval"             #EasyFlow送簽
           IF cl_chk_act_auth() THEN
             #FUN-C20025 add str---
              SELECT * INTO g_imm.* FROM imm_file
               WHERE imm01 = g_imm.imm01
              CALL t324_show()
              CALL t324_b_fill(' 1=1')
             #FUN-C20025 add end---
              CALL t324_ef()
              CALL t324_show()  #FUN-C20025 add
           END IF
         #@WHEN "准"
         WHEN "agree"
              IF g_laststage = "Y" AND l_flowuser = "N" THEN  #最後一關並且沒有加簽人員
                #CALL t324_y_upd()                               #CALL 原確認的 update 段 #FUN-A60034 mark
                 CALL t324sub_y_upd(g_imm.imm01,g_action_choice) #CALL 原確認的 update 段 #FUN-A60034 add
                 CALL t324sub_refresh(g_imm.imm01) RETURNING g_imm.*  
                 CALL t324_show() 
              ELSE
                 LET g_success = "Y"
                 IF NOT aws_efapp_formapproval() THEN #執行 EF 簽核
                    LET g_success = "N"
                 END IF
              END IF
              IF g_success = 'Y' THEN
                 IF cl_confirm('aws-081') THEN    #詢問是否繼續下一筆資料的簽核
                    IF aws_efapp_getnextforminfo() THEN #取得下一筆簽核單號
                       LET l_flowuser = 'N'
                       LET g_argv1 = aws_efapp_wsk(1)   #取得單號
                       IF NOT cl_null(g_argv1) THEN     #自動 query 帶出資料
                             CALL t324_q()
                             #傳入簽核模式時不應執行的 action 清單
                             CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, confirm, undo_confirm,easyflow_approval,post,undo_post,ebo_transfer,aic_s_icdout")  
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
             IF (l_creator := aws_efapp_backflow()) IS NOT NULL THEN #退回關卡
                IF aws_efapp_formapproval() THEN   #執行 EF 簽核
                   IF l_creator = "Y" THEN         #當退回填表人時
                      LET g_imm.imm15 = 'R'        #顯示狀態碼為 'R' 送簽退回
                      DISPLAY BY NAME g_imm.imm15
                   END IF
                   IF cl_confirm('aws-081') THEN #詢問是否繼續下一筆資料的簽核
                      IF aws_efapp_getnextforminfo() THEN   #取得下一筆簽核單號
                          LET l_flowuser = 'N'
                          LET g_argv1 = aws_efapp_wsk(1)    #取得單號
                          IF NOT cl_null(g_argv1) THEN      #自動 query 帶出資料
                                CALL t324_q()
                                #傳入簽核模式時不應執行的 action 清單
                                CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, confirm, undo_confirm,easyflow_approval,post,undo_post,ebo_transfer,aic_s_icdout")  
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
         #FUN-A60034---add----end---

      END CASE
   END WHILE
END FUNCTION

FUNCTION t324_g()
   DEFINE a   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)

   OPEN WINDOW t324g_w WITH FORM "aim/42f/aimt324g"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN

   CALL cl_ui_locale("aimt324g")
 
   INPUT BY NAME a WITHOUT DEFAULTS

      AFTER FIELD a
         IF a IS NULL THEN
            NEXT FIELD a
         END IF

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
      CLOSE WINDOW t324g_w
      RETURN
   END IF

   IF a = '1' THEN
      CALL t324_g1()
   END IF

   CLOSE WINDOW t324g_w

   CALL t324_b_fill(' 1=1')

END FUNCTION

FUNCTION t324_g1()
   DEFINE l_wc,l_sql   LIKE type_file.chr1000     #No.FUN-690026 VARCHAR(400)
   DEFINE t_img02      LIKE imn_file.imn15        #FUN-660078
   DEFINE t_img03      LIKE imn_file.imn16        #FUN-660078
   DEFINE t_img04      LIKE imn_file.imn17        #FUN-660078
   DEFINE l_img        RECORD LIKE img_file.*
   DEFINE l_imn9301    LIKE imn_file.imn9301      #FUN-670093
   DEFINE l_date       LIKE type_file.dat         #CHI-C50010 add
   DEFINE l_img37      LIKE img_file.img37        #CHI-C80007 add 

   OPEN WINDOW t324g_w AT 5,5 WITH FORM "aim/42f/aimt324g"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN

   CALL cl_ui_locale("aimt324g")

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

   IF INT_FLAG THEN
      LET INT_FLAG=0
      CLOSE WINDOW t324g_w
      RETURN
   END IF

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

   IF INT_FLAG THEN
      LET INT_FLAG=0
      CLOSE WINDOW t324g_w
      RETURN
   END IF

   LET l_sql="SELECT * FROM img_file WHERE ",l_wc CLIPPED,
             " AND img10 > 0",
             " ORDER BY img01,img02,img03,img04"

   PREPARE t324_g1_p FROM l_sql

   DECLARE t324_g1_c CURSOR FOR t324_g1_p

   INITIALIZE b_imn.* TO NULL

   SELECT MAX(imn02) INTO b_imn.imn02 FROM imn_file
    WHERE imn01=g_imm.imm01

   IF cl_null(b_imn.imn02) THEN LET b_imn.imn02=0 END IF
   LET l_imn9301=s_costcenter(g_imm.imm14) #FUN-670093
   FOREACH t324_g1_c INTO l_img.*
      IF STATUS THEN EXIT FOREACH END IF

      LET b_imn.imn01 = g_imm.imm01
      LET b_imn.imn02 = b_imn.imn02 + 1
      LET b_imn.imn03 = l_img.img01
      LET b_imn.imn04 = l_img.img02
      LET b_imn.imn05 = l_img.img03
      LET b_imn.imn06 = l_img.img04
      LET b_imn.imn09 = l_img.img09
      LET b_imn.imn10 = l_img.img10

      IF t_img02 IS NULL THEN
         LET b_imn.imn15 = l_img.img02
      ELSE
         LET b_imn.imn15 = t_img02
      END IF

      IF t_img03 IS NULL THEN
         LET b_imn.imn16 = l_img.img03
      ELSE
         LET b_imn.imn16 = t_img03
      END IF

      IF t_img04 IS NULL THEN
         LET b_imn.imn17 = l_img.img04
      ELSE
         LET b_imn.imn17 = t_img04
      END IF
      LET b_imn.imn9301=l_imn9301 #FUN-670093
      LET b_imn.imn9302=l_imn9301 #FUN-670093
      CALL t324_b_move_to()

      LET b_imn.imn20=NULL
      LET b_imn.imn21=NULL

      SELECT img09,img21 INTO b_imn.imn20,b_imn.imn21
       FROM img_file WHERE img01=b_imn.imn03 AND img02=b_imn.imn15
                       AND img03=b_imn.imn16 AND img04=b_imn.imn17

      IF STATUS=100 THEN
         IF g_imn[l_ac].imn05 IS NULL THEN LET g_imn[l_ac].imn05 =' ' END IF   #MOD-CB0122 add
         IF g_imn[l_ac].imn06 IS NULL THEN LET g_imn[l_ac].imn06 =' ' END IF   #MOD-CB0122 add
         #CHI-C50010 str add-----
         #SELECT img18 INTO l_date FROM img_file                #CHI-C80007 mark
          SELECT img18,img37 INTO l_date,l_img37 FROM img_file  #CHI-C80007 add img37
           WHERE img01 = g_imn[l_ac].imn03
             AND img02 = g_imn[l_ac].imn04
             AND img03 = g_imn[l_ac].imn05
             AND img04 = g_imn[l_ac].imn06
         #MOD-CB0122 add---S 
          IF STATUS=100 THEN       
             CALL cl_err('','mfg6101',1)
             CONTINUE FOREACH
          ELSE
         #MOD-CB0122 add---E
             CALL s_date_record(l_date,'Y')
          END IF             #MOD-CB0122 add
         #CHI-C50010 end add-----
          CALL s_idledate_record(l_img37)  #CHI-C80007 add
          CALL s_add_img(g_imn[l_ac].imn03,g_imn[l_ac].imn15,
                         g_imn[l_ac].imn16,g_imn[l_ac].imn17,
                         g_imm.imm01      ,g_imn[l_ac].imn02,
                         #g_imm.imm02)  #FUN-D40053
                         g_imm.imm17)  #FUN-D40053
          SELECT img09,img21 INTO b_imn.imn20,b_imn.imn21
          FROM img_file WHERE img01=b_imn.imn03 AND img02=b_imn.imn15
                          AND img03=b_imn.imn16 AND img04=b_imn.imn17
      END IF

      LET b_imn.imn21 = b_imn.imn21 / l_img.img21
      LET b_imn.imn22 = b_imn.imn10 * b_imn.imn21
      LET b_imn.imn27 = 'N'

      IF cl_null(b_imn.imn29) THEN
         LET b_imn.imn29='N'
      END IF
      #FUN-BC0036 --START--
      IF g_argv0 = '2' THEN
         LET b_imn.imn15 = b_imn.imn04
         LET b_imn.imn16 = b_imn.imn05
         LET b_imn.imn17 = b_imn.imn06
         LET b_imn.imn20 = b_imn.imn09
      END IF 
      #FUN-BC0036 --END--
      LET b_imn.imnplant = g_plant #FUN-980004 add
      LET b_imn.imnlegal = g_legal #FUN-980004 add
      INSERT INTO imn_file VALUES (b_imn.*)
          #FUN-B30187 --START--         
          LET b_imni.imni01 = b_imn.imn01
          LET b_imni.imni02 = b_imn.imn02
          LET b_imni.imnilegal = b_imn.imnlegal
          LET b_imni.imniplant = b_imn.imnplant
          IF NOT s_ins_imni(b_imni.*,b_imn.imnplant) THEN                
          END IF 
          #FUN-B30187 --END--                     

      LET g_cmd='Insert seq no:',b_imn.imn02,' status:',SQLCA.SQLCODE #FUN-840012
      CALL cl_msg(g_cmd) #FUN-840012
   END FOREACH

   CLOSE WINDOW t324g_w

   CALL t324_b_fill(' 1=1')

END FUNCTION

FUNCTION t324_g2()
    DEFINE l_wc,l_sql LIKE type_file.chr1000      #No.FUN-690026 VARCHAR(400)
    DEFINE t_imgg02   LIKE imn_file.imn15         #FUN-660078
    DEFINE t_imgg03   LIKE imn_file.imn16         #FUN-660078
    DEFINE t_imgg04   LIKE imn_file.imn17         #FUN-660078
    DEFINE l_imgg     RECORD LIKE imgg_file.*
    DEFINE l_img09    LIKE img_file.img09
    DEFINE l_imn9301  LIKE imn_file.imn9301       #FUN-670093
    DEFINE l_img      RECORD LIKE img_file.*    
    DEFINE l_imgg01   LIKE imgg_file.imgg01     
    DEFINE t_img02    LIKE imn_file.imn15        
    DEFINE t_img03    LIKE imn_file.imn16       
    DEFINE t_img04    LIKE imn_file.imn17     
    DEFINE l_date     LIKE type_file.dat         #CHI-C50010 add
    DEFINE l_img37    LIKE img_file.img37        #CHI-C80007 add
    
    OPEN WINDOW t324g_w AT 5,5 WITH FORM "aim/42f/aimt324g2"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN

    CALL cl_ui_locale("aimt324g2")

    CONSTRUCT BY NAME l_wc ON imgg01,imgg02,imgg03,imgg04,imgg09
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()

       AFTER FIELD imgg01 
#FUN-AB0025 ----------------------mark------------------------------------
#FUN-AA0059 ---------------------start----------------------------
#         IF NOT cl_null(l_imgg01) THEN
#            IF NOT s_chk_item_no(l_imgg01,"") THEN
#               CALL cl_err('',g_errno,1)
#               NEXT FIELD imgg01
#            END IF
#         END IF
#FUN-AA0059 ---------------------end-------------------------------
#FUN-AB0025 --------------------mark---------------------------------------
         LET l_imgg01 = GET_FLDBUF(imgg01)
         SELECT ima906 INTO g_ima906 FROM ima_file 
          WHERE ima01=l_imgg01

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
    IF INT_FLAG THEN
       LET INT_FLAG=0
       CLOSE WINDOW t324g_w
       RETURN
    END IF

    INPUT BY NAME t_imgg02,t_imgg03,t_imgg04
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
       CLOSE WINDOW t324g_w
       RETURN
    END IF

    IF g_ima906 = '1' THEN  
       LET l_wc=cl_replace_str(l_wc, "imgg", "img")
       LET l_sql="SELECT * FROM img_file WHERE ",l_wc CLIPPED,
                 " AND img10 > 0",
                 " ORDER BY img01,img02,img03,img04"
    ELSE 
    LET l_sql="SELECT * FROM imgg_file WHERE ",l_wc CLIPPED,
              " AND imgg10 > 0",
              " ORDER BY imgg01,imgg02,imgg03,imgg04,imgg09"
    END IF   #MOD-8A0110
    PREPARE t324_g2_p FROM l_sql
    DECLARE t324_g2_c CURSOR FOR t324_g2_p
    INITIALIZE b_imn.* TO NULL

    SELECT MAX(imn02) INTO b_imn.imn02 FROM imn_file
     WHERE imn01=g_imm.imm01 
    IF cl_null(b_imn.imn02) THEN LET b_imn.imn02=0 END IF
    LET l_imn9301=s_costcenter(g_imm.imm14) #FUN-670093
    IF g_ima906 = '1' THEN  
    FOREACH t324_g2_c INTO l_img.*
       IF STATUS THEN EXIT FOREACH END IF
       LET b_imn.imn01 = g_imm.imm01
       LET b_imn.imn02 = b_imn.imn02 + 1
       LET b_imn.imn9301=l_imn9301 #FUN-670093
       LET b_imn.imn9302=l_imn9301 #FUN-670093
       LET b_imn.imn03 = l_img.img01
       LET b_imn.imn04 = l_img.img02
       LET b_imn.imn05 = l_img.img03
       LET b_imn.imn06 = l_img.img04
       #Unit 1
       LET b_imn.imn30 = l_img.img09
       LET b_imn.imn31 = 1
       LET b_imn.imn32 = l_img.img10
       #Unit 2
       LET b_imn.imn33 = NULL
       LET b_imn.imn34 = NULL
       LET b_imn.imn35 = NULL
       LET b_imn.imn09 = l_img.img09
       LET b_imn.imn10 = l_img.img10
#---------------------destination-------------------------
       IF t_imgg02 IS NULL
          THEN LET b_imn.imn15 = l_img.img02
          ELSE LET b_imn.imn15 = t_imgg02
       END IF
       IF t_imgg03 IS NULL
          THEN LET b_imn.imn16 = l_img.img03
          ELSE LET b_imn.imn16 = t_imgg03
       END IF
       IF t_imgg04 IS NULL
          THEN LET b_imn.imn17 = l_img.img04
          ELSE LET b_imn.imn17 = t_imgg04
       END IF

       SELECT img09 INTO l_img09 FROM img_file
        WHERE img01=b_imn.imn03 AND img02=b_imn.imn15
          AND img03=b_imn.imn16 AND img04=b_imn.imn17
       IF STATUS=100 THEN
          IF g_imn[l_ac].imn05 IS NULL THEN LET g_imn[l_ac].imn05 =' ' END IF   #MOD-CB0122 add
          IF g_imn[l_ac].imn06 IS NULL THEN LET g_imn[l_ac].imn06 =' ' END IF   #MOD-CB0122 add
         #CHI-C50010 str add-----
         #SELECT img18 INTO l_date FROM img_file                #CHI-C80007 mark 
          SELECT img18,img37 INTO l_date,l_img37 FROM img_file  #CHI-C80007 add img37
           WHERE img01 = g_imn[l_ac].imn03
             AND img02 = g_imn[l_ac].imn04
             AND img03 = g_imn[l_ac].imn05
             AND img04 = g_imn[l_ac].imn06
         #MOD-CB0122 add---S
          IF STATUS=100 THEN
             CALL cl_err('','mfg6101',1)
             CONTINUE FOREACH
          ELSE
         #MOD-CB0122 add---E
             CALL s_date_record(l_date,'Y')
          END IF    #MOD-CB0122 add
         #CHI-C50010 end add-----
          CALL s_idledate_record(l_img37)  #CHI-C80007 add
          CALL s_add_img(g_imn[l_ac].imn03,g_imn[l_ac].imn15,
                         g_imn[l_ac].imn16,g_imn[l_ac].imn17,
                         g_imm.imm01      ,g_imn[l_ac].imn02,
                         #g_imm.imm02)  #FUN-D40053
                         g_imm.imm17)  #FUN-D40053
          SELECT img09 INTO l_img09 FROM img_file
           WHERE img01=b_imn.imn03 AND img02=b_imn.imn15
             AND img03=b_imn.imn16 AND img04=b_imn.imn17
       END IF
 
       SELECT img09,img21 INTO b_imn.imn20,b_imn.imn21
        FROM img_file WHERE img01=b_imn.imn03 AND img02=b_imn.imn15
                        AND img03=b_imn.imn16 AND img04=b_imn.imn17
      #str MOD-A70117 add
       IF cl_null(b_imn.imn20) THEN
          SELECT ima25 INTO b_imn.imn20 FROM ima_file
           WHERE ima01 = b_imn.imn03
       END IF
       CALL s_umfchk(b_imn.imn03,b_imn.imn09,b_imn.imn20)
            RETURNING g_cnt,b_imn.imn21
      #end MOD-A70117 add

       LET b_imn.imn40 = l_img.img09
       LET b_imn.imn41 = 1
       LET b_imn.imn42 = l_img.img10
       LET b_imn.imn51 = 1
       LET b_imn.imn43 = NULL
       LET b_imn.imn44 = NULL
       LET b_imn.imn45 = NULL
       LET b_imn.imn52 = NULL
      #LET b_imn.imn20 = l_img.img09              #MOD-A70117 mark
      #LET b_imn.imn22 = l_img.img10              #MOD-A70117 mark
      #LET b_imn.imn21 = 1                        #MOD-A70117 mark
       LET b_imn.imn22 = b_imn.imn10*b_imn.imn21  #MOD-A70117
       LET b_imn.imn27 = 'N'

       IF cl_null(b_imn.imn29) THEN
          LET b_imn.imn29='N'
       END IF
       #FUN-BC0036 --START--
       IF g_argv0 = '2' THEN
          LET b_imn.imn15 = b_imn.imn04
          LET b_imn.imn16 = b_imn.imn05
          LET b_imn.imn17 = b_imn.imn06
          LET b_imn.imn20 = b_imn.imn09
       END IF 
       #FUN-BC0036 --END--

       CALL t324_b_move_to()
       lET b_imn.imnplant = g_plant #FUN-980004 add
       LET b_imn.imnlegal = g_legal #FUN-980004 add

       INSERT INTO imn_file VALUES (b_imn.*)
       #FUN-B30187 --START--         
       LET b_imni.imni01 = b_imn.imn01
       LET b_imni.imni02 = b_imn.imn02
       LET b_imni.imnilegal = b_imn.imnlegal
       LET b_imni.imniplant = b_imn.imnplant
       IF NOT s_ins_imni(b_imni.*,b_imn.imnplant) THEN                
       END IF 
       #FUN-B30187 --END--                     
       LET g_buf ='Insert seq no:',b_imn.imn02,' status:',SQLCA.SQLCODE   #No:FUN-850020
       CALL cl_msg(g_buf)   #No:FUN-850020
    END FOREACH
    ELSE 
    FOREACH t324_g2_c INTO l_imgg.*
       IF STATUS THEN EXIT FOREACH END IF
       LET b_imn.imn01 = g_imm.imm01
       LET b_imn.imn02 = b_imn.imn02 + 1
       LET b_imn.imn9301=l_imn9301 #FUN-670093
       LET b_imn.imn9302=l_imn9301 #FUN-670093
#---------------------source-----------------------------
       LET b_imn.imn03 = l_imgg.imgg01
       LET b_imn.imn04 = l_imgg.imgg02
       LET b_imn.imn05 = l_imgg.imgg03
       LET b_imn.imn06 = l_imgg.imgg04
       #Unit 1
       LET b_imn.imn30 = l_imgg.imgg09
       LET b_imn.imn31 = 1
       LET b_imn.imn32 = l_imgg.imgg10
       #Unit 2
       LET b_imn.imn33 = NULL
       LET b_imn.imn34 = NULL
       LET b_imn.imn35 = NULL
       LET b_imn.imn09 = l_imgg.imgg09
       LET b_imn.imn10 = l_imgg.imgg10
#---------------------destination-------------------------
       IF t_imgg02 IS NULL
          THEN LET b_imn.imn15 = l_imgg.imgg02
          ELSE LET b_imn.imn15 = t_imgg02
       END IF
       IF t_imgg03 IS NULL
          THEN LET b_imn.imn16 = l_imgg.imgg03
          ELSE LET b_imn.imn16 = t_imgg03
       END IF
       IF t_imgg04 IS NULL
          THEN LET b_imn.imn17 = l_imgg.imgg04
          ELSE LET b_imn.imn17 = t_imgg04
       END IF

       SELECT img09 INTO l_img09 FROM img_file
        WHERE img01=b_imn.imn03 AND img02=b_imn.imn15
          AND img03=b_imn.imn16 AND img04=b_imn.imn17
       IF STATUS=100 THEN
          IF g_imn[l_ac].imn05 IS NULL THEN LET g_imn[l_ac].imn05 =' ' END IF   #MOD-CB0122 add
          IF g_imn[l_ac].imn06 IS NULL THEN LET g_imn[l_ac].imn06 =' ' END IF   #MOD-CB0122 add
         #CHI-C50010 str add-----
         #SELECT img18 INTO l_date FROM img_file                #CHI-C80007 mark
          SELECT img18,img37 INTO l_date,l_img37 FROM img_file  #CHI-C80007 add img37 
           WHERE img01 = g_imn[l_ac].imn03
             AND img02 = g_imn[l_ac].imn04
             AND img03 = g_imn[l_ac].imn05
             AND img04 = g_imn[l_ac].imn06
         #MOD-CB0122 add---S
          IF STATUS=100 THEN
             CALL cl_err('','mfg6101',1)
             CONTINUE FOREACH
          ELSE
         #MOD-CB0122 add---E
             CALL s_date_record(l_date,'Y')
          END IF    #MOD-CB0122 add
         #CHI-C50010 end add-----
          CALL s_idledate_record(l_img37)  #CHI-C80007 add
          CALL s_add_img(g_imn[l_ac].imn03,g_imn[l_ac].imn15,
                         g_imn[l_ac].imn16,g_imn[l_ac].imn17,
                         g_imm.imm01      ,g_imn[l_ac].imn02,
                         #g_imm.imm02)  #FUN-D40053
                         g_imm.imm17)  #FUN-D40053
          SELECT img09 INTO l_img09 FROM img_file
           WHERE img01=b_imn.imn03 AND img02=b_imn.imn15
             AND img03=b_imn.imn16 AND img04=b_imn.imn17
       END IF
 
       CALL s_chk_imgg(b_imn.imn03,b_imn.imn15,b_imn.imn16,b_imn.imn17,l_imgg.imgg09)
            RETURNING g_flag
       IF g_flag = 1 THEN
          LET g_factor = 1
          IF l_img09 <> l_imgg.imgg09 THEN
             CALL s_umfchk(b_imn.imn03,l_imgg.imgg09,l_img09)
                  RETURNING g_sw,g_factor
             IF g_cnt = 1 AND l_imgg.imgg00 <> '2' THEN
                LET g_msg=b_imn.imn03,' ',l_imgg.imgg09,' ',l_img09
                CALL cl_err(g_msg CLIPPED,'mfg3075',0)
                CONTINUE FOREACH
             END IF
          END IF
          CALL s_add_imgg(b_imn.imn03,b_imn.imn15,b_imn.imn16,b_imn.imn17,
                          l_imgg.imgg09,g_factor,g_imm.imm01,b_imn.imn02,0)
              RETURNING g_flag   #MOD-890243 add
          IF g_flag = 1 THEN
             CALL cl_err('add_imgg',SQLCA.sqlcode,1)
             CONTINUE FOREACH
          END IF
       END IF
       SELECT img09,img21 INTO b_imn.imn20,b_imn.imn21
        FROM img_file WHERE img01=b_imn.imn03 AND img02=b_imn.imn15
                        AND img03=b_imn.imn16 AND img04=b_imn.imn17
      #str MOD-A70117 add
       IF cl_null(b_imn.imn20) THEN
          SELECT ima25 INTO b_imn.imn20 FROM ima_file
           WHERE ima01 = b_imn.imn03
       END IF
       CALL s_umfchk(b_imn.imn03,b_imn.imn09,b_imn.imn20)
            RETURNING g_cnt,b_imn.imn21
      #end MOD-A70117 add
 
       LET b_imn.imn40 = l_imgg.imgg09
       LET b_imn.imn41 = g_factor
       LET b_imn.imn42 = l_imgg.imgg10
       LET b_imn.imn51 = 1
       LET b_imn.imn43 = NULL
       LET b_imn.imn44 = NULL
       LET b_imn.imn45 = NULL
       LET b_imn.imn52 = NULL
      #LET b_imn.imn20 = l_imgg.imgg09            #MOD-A70117 mark
      #LET b_imn.imn22 = l_imgg.imgg10            #MOD-A70117 mark
      #LET b_imn.imn21 = 1                        #MOD-A70117 mark
       LET b_imn.imn22 = b_imn.imn10*b_imn.imn21  #MOD-A70117
       LET b_imn.imn27 = 'N'

       IF cl_null(b_imn.imn29) THEN
          LET b_imn.imn29='N'
       END IF
       
       #FUN-BC0036 --START--
       IF g_argv0 = '2' THEN
          LET b_imn.imn15 = b_imn.imn04
          LET b_imn.imn16 = b_imn.imn05
          LET b_imn.imn17 = b_imn.imn06
          LET b_imn.imn20 = b_imn.imn09
       END IF 
       #FUN-BC0036 --END--

       CALL t324_b_move_to()
       LET b_imn.imnplant = g_plant #FUN-980004 add
       LET b_imn.imnlegal = g_legal #FUN-980004 add

       INSERT INTO imn_file VALUES (b_imn.*)
       #FUN-B30187 --START--         
       LET b_imni.imni01 = b_imn.imn01
       LET b_imni.imni02 = b_imn.imn02
       LET b_imni.imnilegal = b_imn.imnlegal
       LET b_imni.imniplant = b_imn.imnplant
       IF NOT s_ins_imni(b_imni.*,b_imn.imnplant) THEN                
       END IF 
       #FUN-B30187 --END--                     
       LET g_cmd='Insert seq no:',b_imn.imn02,' status:',SQLCA.SQLCODE #FUN-840012
       CALL cl_msg(g_cmd) #FUN-840012
    END FOREACH
    END IF   #MOD-8A0110
    CLOSE WINDOW t324g_w
    CALL t324_b_fill(' 1=1')
END FUNCTION

FUNCTION t324_a()
   DEFINE li_result  LIKE type_file.num5          #No.FUN-550082  #No.FUN-690026 SMALLINT

   IF s_shut(0) THEN RETURN END IF
   CALL cl_msg("")
   CLEAR FORM
   CALL g_imn.clear()
   INITIALIZE g_imm.* TO NULL
   LET g_imm_o.* = g_imm.*
   #FUN-A60034--add---str--
   LET g_imm.imm15 = '0'         #開立
   LET g_imm.immmksg = "N"               

   LET g_imm.imm16 = g_user
   CALL t324_imm16('d')
   #FUN-A60034--add---end--
   CALL cl_opmsg('a')

   WHILE TRUE
      LET g_imm.imm02  =g_today
      LET g_imm.imm17  =g_today  #FUN-D40053
      LET g_imm.imm03  = 'N'
      LET g_imm.immconf= 'N' #FUN-660029
      LET g_imm.immspc = '0' #FUN-680010
      #LET g_imm.imm10  = '1'      #FUN-BC0036 mark
      LET g_imm.imm10  = g_imm10   #FUN-BC0036
     #str MOD-A40173 mod
     #LET g_imm.imm14  = g_grup #FUN-670093
      LET g_imm.imm14  = ''
      SELECT gen03 INTO g_imm.imm14 FROM gen_file WHERE gen01=g_user
      IF cl_null(g_imm.imm14) THEN
         LET g_imm.imm14  = g_grup
      END IF
     #end MOD-A40173 mod
      LET g_imm.immuser=g_user
      LET g_imm.immoriu = g_user #FUN-980030
      LET g_imm.immorig = g_grup #FUN-980030
      LET g_data_plant = g_plant #FUN-980030
      LET g_imm.immgrup=g_grup
      LET g_imm.immdate=g_today
      LET g_imm.immplant = g_plant  #FUN-870100
      DISPLAY BY NAME g_imm.imm02,g_imm.imm03,g_imm.imm14,g_imm.immplant,g_imm.immconf,g_imm.immspc,  #FUN-660029 #FUN-670093 #FUN-680010 #FUN-870100
                      g_imm.immuser,g_imm.immgrup,g_imm.immdate  #FUN-660029
      BEGIN WORK

      CALL t324_i("a")                #輸入單頭

      IF INT_FLAG THEN
         INITIALIZE g_imm.* TO NULL
         LET INT_FLAG=0
         CALL cl_err('',9001,0)
         ROLLBACK WORK
         RETURN
      END IF

      IF g_imm.imm01 IS NULL THEN
         CONTINUE WHILE
      END IF

      CALL s_auto_assign_no("aim",g_imm.imm01,g_imm.imm02,"","imm_file","imm01",
                "","","")
           RETURNING li_result,g_imm.imm01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_imm.imm01

      LET g_imm.immlegal = g_legal   #TQC-A60063
      LET g_imm.imm12=''                        #TQC-AB0223  add
      LET g_imm.immacti = 'Y' #FUN-A60034 add
      INSERT INTO imm_file VALUES (g_imm.*)
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("ins","imm_file",g_imm.imm01,"",SQLCA.sqlcode,"",
                      "ins imm",1)   #NO.FUN-640266 #No.FUN-660156
         ROLLBACK WORK
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_imm.imm01,'I')
      END IF

      SELECT imm01 INTO g_imm.imm01 FROM imm_file     #No.TQC-9A0113
       WHERE imm01 = g_imm.imm01 
      LET g_imm_t.* = g_imm.*

      CALL aimt324_g()       #FUN-930064 

      SELECT COUNT(*) INTO g_i FROM imn_file
       WHERE imn01 = g_imm.imm01 

      IF g_i > 0 THEN
         IF g_smy.smyprint = 'Y' THEN
            IF cl_confirm('mfg9392') THEN
               CALL t324_out()
            END IF
         END IF

        #FUN-A60034---mod---str---
        #IF g_smy.smydmy4 = 'Y' THEN
         IF g_smy.smydmy4 ='Y' AND g_smy.smyapr <> 'Y'THEN  #單據需自動確認且不需簽核 
            LET g_action_choice = "insert"                
        #FUN-A60034---mod---end---
           #CALL t324_y_chk()                                                           #FUN-A60034 mark
            CALL t324sub_y_chk(g_imm.imm01)     #CALL 原確認的 check 段                 #FUN-A60034 add
            IF g_success='Y' THEN
              #CALL t324_y_upd()                                                        #FUN-A60034 mark
               CALL t324sub_y_upd(g_imm.imm01,g_action_choice) #CALL 原確認的 update 段 #FUN-A60034 add
               CALL t324sub_refresh(g_imm.imm01) RETURNING g_imm.*                      #FUN-A60034 add
               CALL t324_show()                                                         #FUN-A60034 add
            END IF
         END IF
      END IF

      EXIT WHILE
   END WHILE

END FUNCTION

FUNCTION t324_u()

    IF s_shut(0) THEN RETURN END IF

    IF cl_null(g_imm.imm01) THEN CALL cl_err('',-400,0) RETURN END IF

    SELECT * INTO g_imm.* FROM imm_file WHERE imm01=g_imm.imm01 

    IF g_imm.immconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF #FUN-660029

    IF g_imm.immconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF #FUN-660029
    #FUN-A60034  add str ---              
    IF g_imm.imm15 matches '[Ss]' THEN
         CALL cl_err('','apm-030',0) #送簽中, 不可修改資料!
         RETURN
    END IF
    IF g_imm.immconf='Y' AND g_imm.imm15 = "1" AND g_imm.immmksg = "Y"  THEN
       CALL cl_err('','mfg3168',0) #此張單據已核准, 不允許更改或取消
       RETURN
    END IF
    #FUN-A60034  add end ---    

    CALL cl_msg("")
    CALL cl_opmsg('u')
    LET g_imm_o.* = g_imm.*
    BEGIN WORK

    OPEN t324_cl USING g_imm.imm01      #NO.TQC-9A0113   
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_imm.imm01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE t324_cl
       ROLLBACK WORK
       RETURN
    ELSE
       FETCH t324_cl INTO g_imm.*                   # 鎖住將被更改或取消的資料
       IF SQLCA.sqlcode THEN
          CALL cl_err(g_imm.imm01,SQLCA.sqlcode,0)  # 資料被他人LOCK
          CLOSE t324_cl
          ROLLBACK WORK
          RETURN
       END IF
    END IF

    CALL t324_show()

    WHILE TRUE
        LET g_imm.immmodu=g_user
        LET g_imm.immdate=g_today

        CALL t324_i("u")                      #欄位更改

        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_imm.*=g_imm_t.*
            CALL t324_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        LET g_imm.imm15 = 0 #FUN-A60034 add
        UPDATE imm_file SET * = g_imm.* WHERE imm01 = g_imm_o.imm01    #No.TQC-9A0113
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err3("upd","imm_file",g_imm_t.imm01,"",SQLCA.sqlcode,"",
                        "upd imm:",1)  #No:FUN-660156
           CONTINUE WHILE
        END IF

        IF g_imm.imm01 != g_imm_t.imm01 THEN CALL t324_chkkey() END IF
        EXIT WHILE
    END WHILE

    CLOSE t324_cl
    COMMIT WORK
    CALL t324_show()                             # 顯示最新資料   #FUN-A60034 add
    CALL cl_flow_notify(g_imm.imm01,'U')

END FUNCTION

FUNCTION t324_chkkey()

   UPDATE imn_file SET imn01=g_imm.imm01
    WHERE imn01=g_imm_t.imm01 
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err3("upd","imn_file",g_imm_t.imm01,"",SQLCA.sqlcode,"","upd imn01",1)   #NO.FUN-640266 #No.FUN-660156
      LET g_imm.* = g_imm_t.*
      CALL t324_show()
      ROLLBACK WORK
      RETURN
   #FUN-B30187 --START--
   ELSE 
      UPDATE imni_file SET imni01=g_imm.imm01
       WHERE imni01=g_imm_t.imm01 
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("upd","imni_file",g_imm_t.imm01,"",SQLCA.sqlcode,"","upd imni01",1) 
         LET g_imm.* = g_imm_t.*
         CALL t324_show()
         ROLLBACK WORK
         RETURN
      END IF 
   #FUN-B30187 --END--
   END IF

END FUNCTION

FUNCTION t324_i(p_cmd)
   DEFINE p_cmd           LIKE type_file.chr1    #a:輸入 u:更改  #No.FUN-690026 VARCHAR(1)
   DEFINE l_flag          LIKE type_file.chr1    #判斷必要欄位是否有輸入  #No.FUN-690026 VARCHAR(1)
   DEFINE li_result       LIKE type_file.num5    #No.FUN-550082  #No.FUN-690026 SMALLINT

   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   INPUT BY NAME g_imm.immoriu,g_imm.immorig,g_imm.imm01,g_imm.imm02,g_imm.imm09,g_imm.imm14,
                 g_imm.imm16,g_imm.immmksg,g_imm.imm15, #FUN-A60034 add
                 g_imm.immplant,g_imm.immconf,g_imm.immspc, #g_imm.imm03, mark by FUN-660029 #FUN-670093 #FUN-680010 #FUN-870100
                 g_imm.immuser,g_imm.immgrup,g_imm.immmodu,g_imm.immdate,
                 g_imm.immud01,g_imm.immud02,g_imm.immud03,g_imm.immud04,
                 g_imm.immud05,g_imm.immud06,g_imm.immud07,g_imm.immud08,
                 g_imm.immud09,g_imm.immud10,g_imm.immud11,g_imm.immud12,
                 g_imm.immud13,g_imm.immud14,g_imm.immud15,
                 g_imm.imm17  #FUN-D40053
           WITHOUT DEFAULTS

       BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL t324_set_entry(p_cmd)
          CALL t324_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
          CALL cl_set_docno_format("imm01")
          LET g_imm.immplant = g_plant
          DISPLAY BY NAME g_imm.immplant
          CALL t324_immplant('a')

       AFTER FIELD imm01
          IF NOT cl_null(g_imm.imm01) THEN
             LET g_t1 = s_get_doc_no(g_imm.imm01)
             #得到該單別對應的屬性群組                                                                                               
             IF ( g_sma.sma120 = 'Y' )AND( g_sma.sma907 = 'Y' ) THEN                                                                 
                #讀取smy_file中指定作業對應的默認屬性群組                                                                            
                SELECT smy62 INTO lg_smy62 FROM smy_file WHERE smyslip = g_t1                                                        
                #刷新界面顯示                                                                                                        
                CALL t324_refresh_detail()                                                                                           
             ELSE                                                                                                                    
                LET lg_smy62 = ''                                                                                                    
             END IF                                                                                                                  
               CALL s_check_no("aim",g_imm.imm01,g_imm_t.imm01,"4","imm_file","imm01","")
                   RETURNING li_result,g_imm.imm01
               DISPLAY BY NAME g_imm.imm01
               IF (NOT li_result) THEN
                  NEXT FIELD imm01
               END IF
             #FUN-A60034 add str ---
             IF g_imm_t.imm01 IS NULL OR
                (g_imm.imm01 != g_imm_t.imm01 ) THEN
                LET g_imm.immmksg = g_smy.smyapr
                LET g_imm.imm15 = '0'
                DISPLAY BY NAME g_imm.immmksg   #簽核否
                DISPLAY BY NAME g_imm.imm15     #簽核狀況
             END IF 
             #FUN-A60034 add end ---
          ELSE                                                                                                                       
             IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN                                                                       
                LET lg_smy62 = ''                                                                                                    
                CALL t324_refresh_detail()                                                                                           
             END IF                                                                                                                  
          END IF

       AFTER FIELD imm02
          IF NOT cl_null(g_imm.imm02) THEN
             IF g_sma.sma53 IS NOT NULL AND g_imm.imm02 <= g_sma.sma53 THEN
                CALL cl_err('','mfg9999',0)
                NEXT FIELD imm02
             END IF
             CALL s_yp(g_imm.imm02) RETURNING g_yy,g_mm
             IF (g_yy*12+g_mm)>(g_sma.sma51*12+g_sma.sma52)THEN #不可大於現行年月
                CALL cl_err('','mfg6091',0)
                NEXT FIELD imm02
             END IF
          END IF
       #FUN-D40053---begin
       AFTER FIELD imm17
          IF NOT cl_null(g_imm.imm17) THEN
             IF g_sma.sma53 IS NOT NULL AND g_imm.imm17 <= g_sma.sma53 THEN
                CALL cl_err('','mfg9999',0)
                NEXT FIELD imm17
             END IF
             CALL s_yp(g_imm.imm17) RETURNING g_yy,g_mm
             IF (g_yy*12+g_mm)>(g_sma.sma51*12+g_sma.sma52)THEN #不可大於現行年月
                CALL cl_err('','mfg6091',0)
                NEXT FIELD imm17
             END IF
          END IF
       #FUN-D40053---end
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
              IF NOT t324_imn28_chk() THEN
                 LET g_imm.imm14 = g_imm_t.imm14
                 NEXT FIELD imm14
              END IF
              #FUN-CB0087---add---end---
           END IF

       #FUN-A60034 add str ------
        AFTER FIELD imm16  #申請人
            IF NOT cl_null(g_imm.imm16) THEN
               CALL t324_imm16('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_imm.imm16,g_errno,0)
                  LET g_imm.imm16 = g_imm_t.imm16
                  DISPLAY BY NAME g_imm.imm16
                  NEXT FIELD imm16
               END IF
               #FUN-CB0087---add---str---
               IF NOT t324_imn28_chk() THEN
                  LET g_imm.imm16 = g_imm_t.imm16
                  NEXT FIELD imm16
               END IF
               #FUN-CB0087---add---end---
            END IF
            LET g_imm_o.imm16 = g_imm.imm16
       #FUN-A60034 add end ---

       AFTER FIELD immud01
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

       AFTER FIELD immud02
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

       AFTER FIELD immud03
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD immud04
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD immud05
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD immud06
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD immud07
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD immud08
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD immud09
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD immud10
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD immud11
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD immud12
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD immud13
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD immud14
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD immud15
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

      #MOD-CB0015---add---S
       AFTER INPUT
          IF INT_FLAG THEN EXIT INPUT END IF
          IF p_cmd ='a' OR p_cmd='u' THEN
             #CALL s_yp(g_imm.imm02) RETURNING g_yy,g_mm  #FUN-D40053
             CALL s_yp(g_imm.imm17) RETURNING g_yy,g_mm  #FUN-D40053
             IF g_yy > g_sma.sma51 THEN     # 與目前會計年度,期間比較
                CALL cl_err(g_yy,'mfg6090',0)
                #NEXT FIELD imm02  #FUN-D40053
                NEXT FIELD imm17  #FUN-D40053
             ELSE
                IF g_yy=g_sma.sma51 AND g_mm > g_sma.sma52 THEN
                   CALL cl_err(g_mm,'mfg6091',0)
                    #NEXT FIELD imm02  #FUN-D40053
                    NEXT FIELD imm17  #FUN-D40053
                END IF
             END IF
          END IF
      #MOD-CB0015---add---E

       ON ACTION controlp
         CASE WHEN INFIELD(imm01) #查詢單据
                   LET  g_t1=s_get_doc_no(g_imm.imm01)       #No.FUN-550082
                   CALL q_smy(FALSE,FALSE,g_t1,'AIM','4') RETURNING g_t1   #TQC-670008
                   LET  g_imm.imm01=g_t1                     #No.FUN-550082
                   DISPLAY BY NAME g_imm.imm01
                   NEXT FIELD imm01
              WHEN INFIELD(imm14)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gem"
                   LET g_qryparam.default1 = g_imm.imm14
                   CALL cl_create_qry() RETURNING g_imm.imm14
                   DISPLAY BY NAME g_imm.imm14
                   NEXT FIELD imm14
              #FUN-A60034---add----str---
              WHEN INFIELD(imm16)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gen"
                   LET g_qryparam.default1 = g_imm.imm16
                   CALL cl_create_qry() RETURNING g_imm.imm16
                   DISPLAY BY NAME g_imm.imm16
                   NEXT FIELD imm16
              #FUN-A60034---add----end---
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

FUNCTION t324_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)

    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("imm01",TRUE)
    END IF

END FUNCTION

FUNCTION t324_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)

    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("imm01",FALSE)
    END IF

END FUNCTION

FUNCTION t324_set_entry_b()

  #-----MOD-A80088---------
  #CALL cl_set_comp_entry("imn33,imn35",TRUE) #MOD-640226   
  CALL cl_set_comp_entry("imn33,imn35,imn30",TRUE) 
  #-----END MOD-A80088-----

END FUNCTION

FUNCTION t324_set_no_entry_b()
   
    #-----MOD-A80088--------- 
    #IF g_ima906 = '1' THEN
    #  CALL cl_set_comp_entry("imn33,imn34,imn35",FALSE) #MOD-640226
    #END IF
    #IF g_ima906 = '2' THEN
    #   CALL cl_set_comp_entry("imn31,imn34",FALSE) #MOD-640226
    #END IF
    ##參考單位，每個料件只有一個，所以不開放讓用戶輸入
    #IF g_ima906 = '3' THEN
    #   CALL cl_set_comp_entry("imn33",FALSE) #MOD-640226
    #END IF

    IF g_ima906 = '1' THEN 
       CALL cl_set_comp_entry("imn33,imn35,imn30",FALSE) 
    END IF
    IF g_ima906 = '3' THEN 
       CALL cl_set_comp_entry("imn33,imn30",FALSE) 
    END IF
    #-----END MOD-A80088-----
    #TQC-C60014---begin
    IF g_argv0 = '2' THEN
       CALL cl_set_comp_entry("imn32,imn35",FALSE)
    END IF 
    #TQC-C60014---end
END FUNCTION

FUNCTION t324_set_required()
 
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
 
FUNCTION t324_set_no_required()
 
  CALL cl_set_comp_required("imn33,imn34,imn35,imn30,imn31,imn32,imn43,imn44,imn45,imn40,imn41,imn42",FALSE)
 
END FUNCTION

FUNCTION t324_q()

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_msg("")
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt

    IF g_sma.sma120 = 'Y'  THEN                                                                                                     
       LET lg_smy62 = ''                                                                                                            
       LET lg_group = ''                                                                                                            
       CALL t324_refresh_detail()                                                                                                   
    END IF                                                                                                                          

    CALL t324_cs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       INITIALIZE g_imm.* TO NULL
       RETURN
    END IF
    CALL cl_msg(" SEARCHING ! ")
    OPEN t324_cs               # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_imm.* TO NULL
    ELSE
        OPEN t324_count
        FETCH t324_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t324_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    CALL cl_msg("")
END FUNCTION

FUNCTION t324_fetch(p_flag)
DEFINE
       p_flag   LIKE type_file.chr1    #處理方式  #No.FUN-690026 VARCHAR(1)
DEFINE l_slip   LIKE smy_file.smyslip  #No.FUN-690026 VARCHAR(10)               #No:TQC-650101

    CASE p_flag
        WHEN 'N' FETCH NEXT     t324_cs INTO g_imm.imm01   #NO.TQC-9A0113
        WHEN 'P' FETCH PREVIOUS t324_cs INTO g_imm.imm01
        WHEN 'F' FETCH FIRST    t324_cs INTO g_imm.imm01
        WHEN 'L' FETCH LAST     t324_cs INTO g_imm.imm01
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
            FETCH ABSOLUTE g_jump t324_cs INTO g_imm.imm01
            LET g_no_ask = FALSE
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
       CALL cl_err3("sel","imm_file",g_imm.imm01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660156
       INITIALIZE g_imm.* TO NULL
       RETURN
    ELSE
        LET g_data_owner = g_imm.immuser #FUN-4C0053
        LET g_data_group = g_imm.immgrup #FUN-4C0053
        LET g_data_plant = g_imm.immplant #FUN-980030
    END IF
    #在使用Q查詢的情況下得到當前對應的屬性組smy62                                                                                    
    IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN                                                                                
       LET l_slip = g_imm.imm01[1,g_doc_len]                                                                                         
       SELECT smy62 INTO lg_smy62 FROM smy_file                                                                                      
          WHERE smyslip = l_slip                                                                                                     
    END IF
    CALL t324_show()
END FUNCTION

FUNCTION t324_immplant(p_cmd)
DEFINE  p_cmd        LIKE type_file.chr1
DEFINE  l_immplant_desc LIKE gem_file.gem02

  SELECT azp02 INTO l_immplant_desc FROM azp_file WHERE azp01 = g_plant 

  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     DISPLAY l_immplant_desc TO FORMONLY.immplant_desc
  END IF

END FUNCTION

FUNCTION t324_show()

   LET g_imm_t.* = g_imm.*                #保存單頭舊值   

   DISPLAY BY NAME g_imm.immoriu,g_imm.immorig,
       g_imm.imm01,g_imm.imm02,g_imm.imm09,g_imm.imm14,
       g_imm.imm16,g_imm.immmksg,g_imm.imm15, #FUN-A60034 add
       g_imm.immplant,g_imm.immconf,g_imm.immspc,g_imm.imm03, #FUN-660029 add g_imm.immconf #FUN-670093 #FUN-680010 #FUN-870100
       g_imm.immuser,g_imm.immgrup,g_imm.immmodu,g_imm.immdate,
       g_imm.immud01,g_imm.immud02,g_imm.immud03,g_imm.immud04,
       g_imm.immud05,g_imm.immud06,g_imm.immud07,g_imm.immud08,
       g_imm.immud09,g_imm.immud10,g_imm.immud11,g_imm.immud12,
       g_imm.immud13,g_imm.immud14,g_imm.immud15,g_imm.imm17  #FUN-D40053

   LET  g_buf =s_get_doc_no(g_imm.imm01)     #No.FUN-550082

   DISPLAY s_costcenter_desc(g_imm.imm14) TO FORMONLY.gem02 #FUN-670093

   IF g_imm.immconf = 'X' THEN #FUN-660029
      LET g_void = 'Y'
   ELSE
      LET g_void = 'N'
   END IF

   CALL t324_immplant('d')     #No.FUN-870100

  #CALL cl_set_field_pic(g_imm.immconf,"",g_imm.imm03,"",g_void,"") #FUN-660029 #FUN-A60034 mark
   #FUN-A60034--add---str--
   IF g_imm.imm15 = '1' THEN
       LET g_chr2 = 'Y'
   ELSE
       LET g_chr2 = 'N'
   END IF
   CALL cl_set_field_pic(g_imm.immconf,g_chr2,g_imm.imm03,"",g_void,"") #FUN-660029 #FUN-A60034 mark

   CALL t324_imm16('d')                                 
   #FUN-A60034--add---end--

   CALL t324_b_fill(g_wc2)

   CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

END FUNCTION

FUNCTION t324_r()
    DEFINE l_chr,l_sure LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
    DEFINE l_i          LIKE type_file.num5    #no.CHI-860008 add

    IF s_shut(0) THEN RETURN END IF
    IF g_imm.imm01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_imm.* FROM imm_file WHERE imm01=g_imm.imm01 
    IF g_imm.immconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF #FUN-660029
    IF g_imm.immconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF #FUN-660029
    #FUN-A60034  add str ---              
    IF g_imm.imm15 matches '[Ss]' THEN
         CALL cl_err('','aws-200',0) #送簽中,不可刪除資料
         RETURN
    END IF
    #FUN-A60034  add end ---              

    BEGIN WORK

    OPEN t324_cl USING g_imm.imm01    
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_imm.imm01,SQLCA.sqlcode,0)
       ROLLBACK WORK
       RETURN
    ELSE
       FETCH t324_cl INTO g_imm.*
       IF SQLCA.sqlcode THEN
          CALL cl_err(g_imm.imm01,SQLCA.sqlcode,0)
          ROLLBACK WORK
          RETURN
       END IF
    END IF
    CALL t324_show()
    IF cl_delh(20,16) THEN
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "imm01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_imm.imm01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
       IF NOT t324_icd_del_chk('') THEN
          ROLLBACK WORK
          RETURN
       END IF
       CALL cl_msg("Delete imm,imn!")
       DELETE FROM imm_file WHERE imm01 = g_imm.imm01
       IF SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err3("del","imm_file",g_imm.imm01,"",SQLCA.sqlcode,
                       "No imm deleted","",1)   #NO.FUN-640266 #No.FUN-660156
          ROLLBACK WORK RETURN
       END IF
       DELETE FROM imn_file WHERE imn01 = g_imm.imm01 
       #FUN-B30187 --START--
       IF NOT s_del_imni(g_imm.imm01,'','') THEN
          #不作處理        
       END IF
       #FUN-B30187 --END--
       FOR l_i = 1 TO g_rec_b
         #IF NOT s_del_rvbs('1',g_imm.imm01,g_imn[l_i].imn02,0)  THEN        #FUN-880129   #TQC-B90236 mark
          IF NOT s_lot_del(g_prog,g_imm.imm01,'',0,g_imn[l_i].imn03,'DEL') THEN     #TQC-B90236 add         
             ROLLBACK WORK
             RETURN  
          END IF
         #IF NOT s_del_rvbs('2',g_imm.imm01,g_imn[l_i].imn02,0)  THEN        #FUN-880129   #TQC-B90236 mark
          IF NOT s_lot_del(g_prog,g_imm.imm01,'',0,g_imn[l_i].imn03,'DEL') THEN     #TQC-B90236 add
             ROLLBACK WORK
             RETURN  
          END IF
       END FOR
       UPDATE rmd_file SET rmd34=NULL WHERE rmd34=g_imm.imm01   #MOD-A40161 #從後面往前移

       LET g_msg=TIME
       INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980004 add azoplant,azolegal
       VALUES ('aimt324',g_user,g_today,g_msg,g_imm.imm01,'delete',g_plant,g_legal) #FUN-980004 add g_plant,g_legal
       CLEAR FORM
       CALL g_imn.clear()
       INITIALIZE g_imm.* TO NULL
       CALL g_imn.clear()
       CALL cl_msg("")
       OPEN t324_count
       #FUN-B50062-add-start--
       IF STATUS THEN
          CLOSE t324_cs
          CLOSE t324_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       FETCH t324_count INTO g_row_count
       #FUN-B50062-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t324_cs
          CLOSE t324_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t324_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t324_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE
          CALL t324_fetch('/')
       END IF
    END IF
    CLOSE t324_cl
   #UPDATE rmd_file SET rmd34=NULL WHERE rmd34=g_imm.imm01  #FUN-570235  #MOD-A40161 mark 往前移
    COMMIT WORK
    CALL cl_flow_notify(g_imm.imm01,'D')
 
END FUNCTION

FUNCTION t324_b()
DEFINE
    l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT  #No.FUN-690026 SMALLINT
    l_n,l_cnt       LIKE type_file.num5,     #檢查重複用  #No.FUN-690026 SMALLINT
    l_lock_sw       LIKE type_file.chr1,     #單身鎖住否  #No.FUN-690026 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,     #處理狀態    #No.FUN-690026 VARCHAR(1)
    l_img10         LIKE img_file.img10,
    l_ima02         LIKE ima_file.ima02,
    l_imaag         LIKE ima_file.imaag,
    l_azf09         LIKE azf_file.azf09,     #FUN-920186
    l_allow_insert  LIKE type_file.num5,     #可新增否    #No.FUN-690026 SMALLINT
    l_allow_delete  LIKE type_file.num5      #可刪除否    #No.FUN-690026 SMALLINT
DEFINE l_warehouse  LIKE type_file.chr1      #FUN-5A0066  #No.FUN-690026 VARCHAR(1)
DEFINE li_i         LIKE type_file.num5                                                                                                       #No.FUN-690026 SMALLINT
DEFINE l_count      LIKE type_file.num5                                                                                                       #No.FUN-690026 SMALLINT
DEFINE l_temp       LIKE ima_file.ima01                                                                                        
DEFINE l_check_res  LIKE type_file.num5      #No.FUN-690026 SMALLINT
DEFINE l_factor     LIKE imn_file.imn41      
DEFINE l_ima906     LIKE ima_file.ima906
DEFINE l_img09      LIKE img_file.img09
DEFINE l_imd20      LIKE imd_file.imd20      #No.FUN-870100
DEFINE l_imd20_1    LIKE imd_file.imd20      #No.FUN-870100
DEFINE l_imm01      LIKE imm_file.imm01      #FUN-B30053
DEFINE l_smy57      LIKE smy_file.smy57      #FUN-B30053
DEFINE l_ima159     LIKE ima_file.ima159     #FUN-B90035
DEFINE l_c          LIKE type_file.num5     #CHI-C30106 add
DEFINE l_date       LIKE type_file.dat       #CHI-C50010 add
DEFINE l_img37      LIKE img_file.img37      #CHI-C80007 add

DEFINE l_act        LIKE type_file.chr1      #判斷u/a是否成功
#DEFINE l_imaicd08   LIKE imaicd_file.imaicd08  #刻號明細維護 #FUN-BA0051 mark
DEFINE l_r          LIKE type_file.chr1  #FUN-C30302
DEFINE l_qty        LIKE type_file.num15_3  #FUN-C30302

   #FUN-C20002--start add------------------------
   DEFINE   l_ima154     LIKE ima_file.ima154
   DEFINE   l_rcj03      LIKE rcj_file.rcj03 
   DEFINE   l_rtz07      LIKE rtz_file.rtz07 
   DEFINE   l_rtz08      LIKE rtz_file.rtz08 
   #FUN-C20002--end add--------------------------
  DEFINE   l_where      STRING,                 #FUN-CB0087
           l_sql        STRING,                 #FUN-CB0087
           l_flag       LIKE type_file.chr1,    #FUN-CB0087
           l_store      STRING                  #FUN-CB0087
   
    LET g_action_choice = ""
    IF cl_null(g_imm.imm01) THEN RETURN END IF

    SELECT * INTO g_imm.* FROM imm_file WHERE imm01=g_imm.imm01 
    IF g_imm.immconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF #FUN-660029
    IF g_imm.immconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF #FUN-660029

    #FUN-A60034  add str ---              
    IF g_imm.imm15 matches '[Ss]' THEN
         CALL cl_err('','apm-030',0) #送簽中, 不可修改資料!
         RETURN
    END IF
    IF g_imm.immconf='Y' AND g_imm.imm15 = "1" AND g_imm.immmksg = "Y"  THEN
       CALL cl_err('','mfg3168',0) #此張單據已核准, 不允許更改或取消
       RETURN
    END IF
    #FUN-A60034  add end ---    
 
    CALL cl_opmsg('b')
    LET g_forupd_sql = "SELECT * FROM imn_file ",
                       " WHERE imn01= ? AND imn02= ?  AND imnplant= ?  FOR UPDATE "    #No.FUN-870100
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t324_bcl CURSOR FROM g_forupd_sql

    #FUN-B30187 --START--
    LET g_forupd_sql = " SELECT * FROM imni_file ",
                        " WHERE imni01 = ? ",
                        " AND imni02 = ? ",
                        " AND imniplant = ? ",
                        " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t324_bcl_ind CURSOR FROM g_forupd_sql
    #FUN-B30187 --END--

    LET l_ac_t = 0

    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

    INPUT ARRAY g_imn WITHOUT DEFAULTS FROM s_imn.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)

        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF

        BEFORE ROW
            LET l_act = NULL   #FUN-920207
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
            LET l_warehouse = ''  #FUN-5A0066
            #CALL cl_set_comp_entry("imn40,imn41,imn42,imn43,imn44,imn45",   #MOD-A80088
            #                        FALSE) #MOD-640226   #MOD-A80088
            BEGIN WORK

            OPEN t324_cl USING g_imm.imm01  
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_imm.imm01,SQLCA.sqlcode,0)     # 資料被他人LOCK
               CLOSE t324_cl
               ROLLBACK WORK
               RETURN
            ELSE
               FETCH t324_cl INTO g_imm.*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_imm.imm01,SQLCA.sqlcode,0)     # 資料被他人LOCK
                  CLOSE t324_cl
                  ROLLBACK WORK
                  RETURN
               END IF
            END IF
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_imn_t.* = g_imn[l_ac].*  #BACKUP
                LET g_imn02_o = g_imn[l_ac].imn02  #MOD-C10046 add
                OPEN t324_bcl USING g_imm.imm01,g_imn_t.imn02,g_imm.immplant  #表示更改狀態 #FUN-870100
                FETCH t324_bcl INTO b_imn.*
                IF SQLCA.sqlcode THEN
                   CALL cl_err('lock imn',SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                ELSE
                   #FUN-B30187 --START--
                   OPEN t324_bcl_ind USING g_imm.imm01,g_imn_t.imn02,g_imm.immplant                   
                   FETCH t324_bcl_ind INTO b_imni.*
                   IF SQLCA.sqlcode THEN
                      CALL cl_err('lock imni',SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   END IF
                   #FUN-B30187 --END--
#FUN-B90035 -----------------Begin------------------
                   CALL t324_set_no_required_1()
                   CALL t324_set_required_1(p_cmd)
                   CALL t324_set_entry_imn()        
                   CALL t324_set_no_entry_imn()    
#FUN-B90035 -----------------End--------------------
                   CALL t324_b_move_to()
                   LET g_imn[l_ac].gem02b=s_costcenter_desc(g_imn[l_ac].imn9301) #FUN-670093
                   LET g_imn[l_ac].gem02c=s_costcenter_desc(g_imn[l_ac].imn9302) #FUN-670093
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF

        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_imn[l_ac].* TO NULL      #900423
           INITIALIZE arr_detail[l_ac].* TO NULL #No:TQC-650101
           INITIALIZE g_imn_t.* TO NULL
           LET b_imn.imn01=g_imm.imm01
           LET g_imn[l_ac].imn04 = l_imn04
           LET g_imn[l_ac].imn05 = l_imn05
           LET g_imn[l_ac].imn15 = l_imn15
           LET g_imn[l_ac].imn16 = l_imn16
           LET g_imn[l_ac].imn28 = l_imn28
           LET g_imn[l_ac].imn21=1
          #LET g_imn[l_ac].imn29='N'   #No.FUN-5C0077    #FUN-B30053 mark
           IF g_sma.sma115 = 'Y' THEN
              LET g_imn[l_ac].imn51=1
              LET g_imn[l_ac].imn52=1
           END IF
           #FUN-B30053-add-str--
           LET l_imm01 = s_get_doc_no(g_imm.imm01)
           SELECT smy57 INTO l_smy57 FROM smy_file WHERE smyslip = l_imm01 AND smyacti = 'Y'
           IF cl_null(l_smy57[2,2]) THEN
              LET l_smy57[2,2] = 'N'
           END IF
           LET g_imn[l_ac].imn29=l_smy57[2,2]
           #FUN-B30053-add-end--
           LET g_imn[l_ac].imn9301=s_costcenter(g_imm.imm14) #FUN-670093
           LET g_imn[l_ac].imn9302=g_imn[l_ac].imn9301 #FUN-670093
           LET g_imn[l_ac].gem02b=s_costcenter_desc(g_imn[l_ac].imn9301) #FUN-670093
           LET g_imn[l_ac].gem02c=s_costcenter_desc(g_imn[l_ac].imn9302) #FUN-670093
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           LET g_imn02_o = g_imn[l_ac].imn02  #MOD-C10046 add
           NEXT FIELD imn02

        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF

           #FUN-BA0051 --START mark--
           #若料號做刻號管理(imaicd08='Y'),則撥出/入單位一定要相同
           #若料號做刻號管理(imaicd08='Y'),則撥入單位一定與撥入img_file單位同
           #LET l_imaicd08 = NULL
           #SELECT imaicd08 INTO l_imaicd08 FROM imaicd_file
           # WHERE imaicd00 = g_imn[l_ac].imn03
           #IF NOT cl_null(l_imaicd08) AND l_imaicd08 = 'Y' THEN
           #FUN-BA0051 --END mark--
           IF s_icdbin(g_imn[l_ac].imn03) THEN   #FUN-BA0051
              #chk撥出/入庫單位是否相同
              IF g_imn[l_ac].imn09 <> g_imn[l_ac].imn20 THEN
                 CALL cl_err(g_imn[l_ac].imn03,'aic-912',1)
                 CALL g_imn.deleteElement(l_ac)
                 CANCEL INSERT
              END IF
              #FUN-BC0036 --START--
              IF g_argv0 = '2' THEN
                 LET g_imn[l_ac].imn15 = g_imn[l_ac].imn04 
                 LET g_imn[l_ac].imn16 = g_imn[l_ac].imn05 
                 LET g_imn[l_ac].imn17 = g_imn[l_ac].imn06 
                 LET g_imn[l_ac].imn20 = g_imn[l_ac].imn09 
              END IF 
              #FUN-BC0036 --END--
              #chk撥入單位是否與撥入img_file單位同
              LET g_cnt = 0
              SELECT COUNT(*) INTO g_cnt FROM img_file
               WHERE img01 = g_imn[l_ac].imn03
                 AND img02 = g_imn[l_ac].imn15
                 AND img03 = g_imn[l_ac].imn16
                 AND img04 = g_imn[l_ac].imn17
                 AND img09 = g_imn[l_ac].imn20
              IF g_cnt = 0 THEN
                 CALL cl_err(g_imn[l_ac].imn03,'aic-913',1)
                 CALL g_imn.deleteElement(l_ac)
                 CANCEL INSERT
              END IF
           END IF
           IF g_sma.sma115 = 'Y' THEN
              CALL s_chk_va_setting(g_imn[l_ac].imn03)
                   RETURNING g_flag,g_ima906,g_ima907
              IF g_flag=1 THEN
                 NEXT FIELD imn03
              END IF
              CALL t324_du_data_to_correct()
           END IF
 
           #----------source--------------
           SELECT img09 INTO g_img09_s FROM img_file
            WHERE img01=g_imn[l_ac].imn03
              AND img02=g_imn[l_ac].imn04
              AND img03=g_imn[l_ac].imn05
              AND img04=g_imn[l_ac].imn06
           IF cl_null(g_img09_s) THEN
              CALL cl_err(g_imn[l_ac].imn04,'mfg6069',0)
              NEXT FIELD imn04
          #MOD-C90125---S---
           ELSE
              IF cl_null(g_imn[l_ac].imn09) THEN
                 LET g_imn[l_ac].imn09 = g_img09_s
                 DISPLAY BY NAME g_imn[l_ac].imn09
              END IF
          #MOD-C90125---E---
           END IF
 
           #----------destination---------
           SELECT img09 INTO g_img09_t FROM img_file
            WHERE img01=g_imn[l_ac].imn03
              AND img02=g_imn[l_ac].imn15
              AND img03=g_imn[l_ac].imn16
              AND img04=g_imn[l_ac].imn17
           IF cl_null(g_img09_t) THEN
              CALL cl_err(g_imn[l_ac].imn15,'mfg6069',0)
              NEXT FIELD imn15
          #MOD-C90125---S---
           ELSE
              IF cl_null(g_imn[l_ac].imn20) THEN
                 LET g_imn[l_ac].imn20 = g_img09_t
                 DISPLAY BY NAME g_imn[l_ac].imn20
              END IF
          #MOD-C90125---E---
           END IF
 
           IF g_sma.sma115 = 'Y' THEN
              IF t324_qty_issue() THEN
                 NEXT FIELD imn30
              END IF
              CALL t324_set_origin_field()
           END IF
           IF (NOT cl_null(g_imn[l_ac].imn03)) 
              AND (NOT cl_null(g_imn[l_ac].imn15))
              THEN #MOD-4B0249(多包此IF 判斷)
              SELECT * FROM img_file
               WHERE img01=g_imn[l_ac].imn03
                 AND img02=g_imn[l_ac].imn15
                 AND img03=g_imn[l_ac].imn16
                 AND img04=g_imn[l_ac].imn17
              IF STATUS=100 THEN
                 IF NOT cl_confirm('mfg1401') THEN
                    NEXT FIELD imn15
                 END IF
                 IF g_imn[l_ac].imn05 IS NULL THEN LET g_imn[l_ac].imn05 =' ' END IF   #MOD-CB0122 add
                 IF g_imn[l_ac].imn06 IS NULL THEN LET g_imn[l_ac].imn06 =' ' END IF   #MOD-CB0122 add
                #CHI-C50010 str add-----
                #SELECT img18 INTO l_date FROM img_file                #CHI-C80007 mark
                 SELECT img18,img37 INTO l_date,l_img37 FROM img_file  #CHI-C80007 add img37
                  WHERE img01 = g_imn[l_ac].imn03
                    AND img02 = g_imn[l_ac].imn04
                    AND img03 = g_imn[l_ac].imn05
                    AND img04 = g_imn[l_ac].imn06
                #MOD-CB0122 add---S
                 IF STATUS=100 THEN
                    CALL cl_err('','mfg6101',1)
                    NEXT FIELD imn15
                 ELSE
                #MOD-CB0122 add---E
                    CALL s_date_record(l_date,'Y')
                 END IF    #MOD-CB0122 add
                #CHI-C50010 end add-----
                 CALL s_idledate_record(l_img37)  #CHI-C80007 add
                 CALL s_add_img(g_imn[l_ac].imn03,g_imn[l_ac].imn15,
                                g_imn[l_ac].imn16,g_imn[l_ac].imn17,
                                #g_imm.imm01,g_imn[l_ac].imn02,g_imm.imm02)  #FUN-D40053
                                g_imm.imm01,g_imn[l_ac].imn02,g_imm.imm17)  #FUN-D40053
                 IF g_errno='N' THEN
                     NEXT FIELD imn15 
                 END IF
              END IF
           END IF

           CALL t324_b_move_back()

          #料號為參考單位，單一單位，且狀態為其他段生產料號(imaicd03=3,4)時
          #將單位一的資料給單位二 
           CALL t324_set_value()  #FUN-920207
           LET g_success = "Y"   #FUN-B30187
           
           INSERT INTO imn_file VALUES(b_imn.*)
           
           #FUN-B30187 --START--
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","imn_file",b_imn.imn01,"",SQLCA.sqlcode,
                           "","ins imn",0)  #No.FUN-660156
              LET g_success = "N"      
           ELSE
              LET b_imni.imni01 = b_imn.imn01
              LET b_imni.imni02 = b_imn.imn02
              IF NOT s_ins_imni(b_imni.*,b_imn.imnplant) THEN                     
                 LET g_success='N'
              END IF
           END IF 
           #FUN-B30187 --END--
           
           IF g_success = "N" THEN   #FUN-B30187              
              CANCEL INSERT
              SELECT ima918,ima921 INTO g_ima918,g_ima921 
                FROM ima_file
               WHERE ima01 = g_imn[l_ac].imn03
                 AND imaacti = "Y"
              
              IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                #IF NOT s_lotout_del(g_prog,g_imm.imm01,g_imn[l_ac].imn02,0,g_imn[l_ac].imn03,'DEL') THEN   #No:FUN-860045   #TQC-B90236 mark
                 IF NOT s_lot_del(g_prog,g_imm.imm01,g_imn[l_ac].imn02,0,g_imn[l_ac].imn03,'DEL') THEN   #No:FUN-860045   #TQC-B90236 add
                    CALL cl_err3("del","rvbs_file",g_imm.imm01,g_imn_t.imn02,
                                  SQLCA.sqlcode,"","",1)
                    ROLLBACK WORK      #CHI-A10016 
                    CANCEL INSERT      #CHI-A10016
                 END IF
                #IF NOT s_lotin_del(g_prog,g_imm.imm01,g_imn[l_ac].imn02,0,g_imn[l_ac].imn03,'DEL') THEN   #No:FUN-860045   #TQC-B90236 mark
                 IF NOT s_lot_del(g_prog,g_imm.imm01,g_imn[l_ac].imn02,0,g_imn[l_ac].imn03,'DEL') THEN   #No:FUN-860045   #TQC-B90236 add
                    CALL cl_err3("del","rvbs_file",g_imm.imm01,g_imn_t.imn02,
                                  SQLCA.sqlcode,"","",1)
                 END IF
              END IF
           ELSE
              CALL cl_msg('INSERT O.K')
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
              LET l_act = 'a'    #FUN-920207
           END IF

        BEFORE FIELD imn02                            #default 序號
           IF g_imn[l_ac].imn02 IS NULL OR g_imn[l_ac].imn02 = 0 THEN
              SELECT max(imn02)+1 INTO g_imn[l_ac].imn02
                FROM imn_file WHERE imn01 = g_imm.imm01
              IF g_imn[l_ac].imn02 IS NULL THEN
                 LET g_imn[l_ac].imn02 = 1
              END IF
           END IF
           IF p_cmd = 'u' THEN
              SELECT ima02 INTO l_ima02 FROM ima_file
               WHERE ima01 = g_imn[l_ac].imn03
              IF SQLCA.sqlcode THEN LET l_ima02 = ' ' END IF
              ERROR l_ima02
           END IF

        AFTER FIELD imn02                        #check 序號是否重複
           IF p_cmd = 'u' AND NOT cl_null(g_imn[l_ac].imn02) THEN 
               IF g_imn_t.imn02 <> g_imn[l_ac].imn02 THEN
                  CALL t324_chk_icd()
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     LET g_imn[l_ac].imn02 = g_imn_t.imn02
                     NEXT FIELD imn02
                  END IF
                END IF
            END IF
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

            #MOD-C10046 ----- start -----
            SELECT ima918,ima921 INTO g_ima918,g_ima921
            FROM ima_file
            WHERE ima01 = g_imn[l_ac].imn03  AND imaacti = "Y"

            IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                  IF g_imn[l_ac].imn02 != g_imn02_o THEN
                     LET l_cnt = 0
                     SELECT COUNT(*) INTO l_cnt FROM rvbs_file
                      WHERE rvbs01 = g_imm.imm01 AND rvbs02 = g_imn02_o
                     IF l_cnt > 0 THEN
                        UPDATE rvbs_file SET rvbs02 =  g_imn[l_ac].imn02
                         WHERE rvbs01 = g_imm.imm01 AND rvbs02 = g_imn02_o
                        IF SQLCA.sqlcode THEN
                           CALL cl_err3("upd","rvbs_file",g_imn[l_ac].imn02,"",SQLCA.sqlcode,"","",1)
                        ELSE
                           LET g_imn02_o = g_imn[l_ac].imn02
                        END IF
                     END IF
                  END IF
            END IF
            #MOD-C10046 -----  end  -----
 
        BEFORE FIELD imn03
           IF g_sma.sma60 = 'Y' THEN # 若須分段輸入
              CALL s_inp5(9,14,g_imn[l_ac].imn03)
                RETURNING g_imn[l_ac].imn03
              DISPLAY BY NAME g_imn[l_ac].imn03
              IF INT_FLAG THEN 
                 LET INT_FLAG = 0
              END IF
           END IF
           CALL t324_set_entry_b()
           CALL t324_set_no_required()
           CALL t324_set_no_required_1()   #FUN-B90035
           CALL t324_set_entry_imn()       #FUN-B90035
           
        AFTER FIELD imn03  #PART
#FUN-AA0059 ---------------------start----------------------------
           IF NOT cl_null(g_imn[l_ac].imn03) THEN
              IF NOT s_chk_item_no(g_imn[l_ac].imn03,"") THEN
                 CALL cl_err('',g_errno,1)
                 LET g_imn[l_ac].imn03= g_imn_t.imn03
                 NEXT FIELD imn03
              END IF
           END IF
#FUN-AA0059 ---------------------end-------------------------------
           IF NOT s_chkima08(g_imn[l_ac].imn03) THEN                                                                                
              NEXT FIELD CURRENT                                                                                                    
           END IF                                                                                                                   
           IF p_cmd = 'u' AND NOT cl_null(g_imn[l_ac].imn03) THEN 
                IF g_imn_t.imn03 <> g_imn[l_ac].imn03 THEN
                   CALL t324_chk_icd()
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err('',g_errno,0)
                      LET g_imn[l_ac].imn03 = g_imn_t.imn03
                      NEXT FIELD imn03
                   END IF
                 END IF
           END IF
           #FUN-AA0007--begin--add---------
           IF NOT s_icdout_holdlot(g_imn[l_ac].imn03,g_imn[l_ac].imn04,
                                   g_imn[l_ac].imn05,g_imn[l_ac].imn06) THEN
              NEXT FIELD imn03
           END IF
           #FUN-AA0007--end--add----------
           #AFTER FIELD 處理邏輯修改為使用下面的函數來進行判斷，請參考相關代碼                                                        
           CALL t324_check_imn03('imn03',l_ac) RETURNING l_check_res,g_imn[l_ac].ima02,g_imn[l_ac].ima021
           IF NOT l_check_res THEN NEXT FIELD imn03 END IF
           SELECT imaag INTO l_imaag FROM ima_file
            WHERE ima01 = g_imn[l_ac].imn03
           IF NOT cl_null(l_imaag) AND l_imaag <> '@CHILD' THEN
              LET g_imn[l_ac].ima02 = NULL
              LET g_imn[l_ac].ima021 = NULL
              DISPLAY BY NAME g_imn[l_ac].*
              CALL cl_err(g_imn[l_ac].imn03,'aim1004',0)
              NEXT FIELD imn03
           END IF
           #DEV-D30037--mark--begin
           ##No:DEV-D30026--add--begin
           #CALL t324_chk_smyb(g_imn[l_ac].imn03)
           # IF NOT cl_null(g_errno) THEN
           #    CALL cl_err(g_imn[l_ac].imn03,g_errno,1)
           #    NEXT FIELD imn03
           # END IF
           ##No:DEV-D30026--add--end
           #DEV-D30037--mark--end
#FUN-B90035 ------------Begin--------------
           CALL t324_set_no_required_1()
           CALL t324_set_required_1(p_cmd)
           CALL t324_set_no_entry_imn() 
#FUN-B90035 ------------End----------------
       
      BEFORE FIELD att00
            #根據子料件找到母料件及各個屬性
            SELECT imx00,imx01,imx02,imx03,imx04,imx05,
                   imx06,imx07,imx08,imx09,imx10 
            INTO g_imn[l_ac].att00, g_imn[l_ac].att01, g_imn[l_ac].att02,
                 g_imn[l_ac].att03, g_imn[l_ac].att04, g_imn[l_ac].att05,
                 g_imn[l_ac].att06, g_imn[l_ac].att07, g_imn[l_ac].att08,
                 g_imn[l_ac].att09, g_imn[l_ac].att10
            FROM imx_file
            WHERE imx000 = g_imn[l_ac].imn04
            #賦值所有屬性
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
            #顯示所有屬性
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
                               

      #FUN-640013 Add,以下是為料件多屬性機制新增的20個屬性欄位的AFTER FIELD代碼
      #下面是十個輸入型屬性欄位的判斷語句
      AFTER FIELD att00
          #檢查att00里面輸入的母料件是否是符合對應屬性組的母料件
          SELECT COUNT(ima01) INTO l_count FROM ima_file 
            WHERE ima01 = g_imn[l_ac].att00 AND imaag = lg_smy62
          IF l_count = 0 THEN
             CALL cl_err_msg('','aim-909',lg_smy62,0)
             NEXT FIELD att00          
          END IF
          IF p_cmd = 'u' THEN
             CALL cl_set_comp_entry("att01,att01_c,att02,att02_c,att03,att03_c,att04,att04_c,att05,att05_c,att06,att06_c,att07,att07_c,att08,att08_c,att09,att09_c,att10,att10_c",TRUE)
          END IF

          #如果設置為不允許新增
             CALL t324_check_imn03('imx00',l_ac) RETURNING
               l_check_res,g_imn[l_ac].ima02,g_imn[l_ac].ima021 
             IF NOT l_check_res THEN NEXT FIELD att00 END IF
      
      AFTER FIELD att01
          CALL t324_check_att0x(g_imn[l_ac].att01,1,l_ac) RETURNING
               l_check_res,g_imn[l_ac].ima02,g_imn[l_ac].ima021 
          IF NOT l_check_res THEN NEXT FIELD att01 END IF              
      AFTER FIELD att02
          CALL t324_check_att0x(g_imn[l_ac].att02,2,l_ac) RETURNING
               l_check_res,g_imn[l_ac].ima02,g_imn[l_ac].ima021 
          IF NOT l_check_res THEN NEXT FIELD att02 END IF
      AFTER FIELD att03
          CALL t324_check_att0x(g_imn[l_ac].att03,3,l_ac) RETURNING
               l_check_res,g_imn[l_ac].ima02,g_imn[l_ac].ima021 
          IF NOT l_check_res THEN NEXT FIELD att03 END IF
      AFTER FIELD att04
          CALL t324_check_att0x(g_imn[l_ac].att04,4,l_ac) RETURNING
               l_check_res,g_imn[l_ac].ima02,g_imn[l_ac].ima021 
          IF NOT l_check_res THEN NEXT FIELD att04 END IF
      AFTER FIELD att05
          CALL t324_check_att0x(g_imn[l_ac].att05,5,l_ac) RETURNING
               l_check_res,g_imn[l_ac].ima02,g_imn[l_ac].ima021 
          IF NOT l_check_res THEN NEXT FIELD att05 END IF          
      AFTER FIELD att06
          CALL t324_check_att0x(g_imn[l_ac].att06,6,l_ac) RETURNING
               l_check_res,g_imn[l_ac].ima02,g_imn[l_ac].ima021 
          IF NOT l_check_res THEN NEXT FIELD att06 END IF
      AFTER FIELD att07
          CALL t324_check_att0x(g_imn[l_ac].att07,7,l_ac) RETURNING
               l_check_res,g_imn[l_ac].ima02,g_imn[l_ac].ima021 
          IF NOT l_check_res THEN NEXT FIELD att07 END IF
      AFTER FIELD att08
          CALL t324_check_att0x(g_imn[l_ac].att08,8,l_ac) RETURNING
               l_check_res,g_imn[l_ac].ima02,g_imn[l_ac].ima021 
          IF NOT l_check_res THEN NEXT FIELD att08 END IF
      AFTER FIELD att09
          CALL t324_check_att0x(g_imn[l_ac].att09,9,l_ac) RETURNING
               l_check_res,g_imn[l_ac].ima02,g_imn[l_ac].ima021 
          IF NOT l_check_res THEN NEXT FIELD att09 END IF
      AFTER FIELD att10
          CALL t324_check_att0x(g_imn[l_ac].att10,10,l_ac) RETURNING
               l_check_res,g_imn[l_ac].ima02,g_imn[l_ac].ima021 
          IF NOT l_check_res THEN NEXT FIELD att10 END IF
      #下面是十個輸入型屬性欄位的判斷語句
      AFTER FIELD att01_c
          CALL t324_check_att0x_c(g_imn[l_ac].att01_c,1,l_ac) RETURNING
               l_check_res,g_imn[l_ac].ima02,g_imn[l_ac].ima021 
          IF NOT l_check_res THEN NEXT FIELD att01_c END IF      
      AFTER FIELD att02_c
          CALL t324_check_att0x_c(g_imn[l_ac].att02_c,2,l_ac) RETURNING
               l_check_res,g_imn[l_ac].ima02,g_imn[l_ac].ima021 
          IF NOT l_check_res THEN NEXT FIELD att02_c END IF
      AFTER FIELD att03_c
          CALL t324_check_att0x_c(g_imn[l_ac].att03_c,3,l_ac) RETURNING
               l_check_res,g_imn[l_ac].ima02,g_imn[l_ac].ima021 
          IF NOT l_check_res THEN NEXT FIELD att03_c END IF
      AFTER FIELD att04_c
          CALL t324_check_att0x_c(g_imn[l_ac].att04_c,4,l_ac) RETURNING
               l_check_res,g_imn[l_ac].ima02,g_imn[l_ac].ima021 
          IF NOT l_check_res THEN NEXT FIELD att04_c END IF
      AFTER FIELD att05_c
          CALL t324_check_att0x_c(g_imn[l_ac].att05_c,5,l_ac) RETURNING
               l_check_res,g_imn[l_ac].ima02,g_imn[l_ac].ima021 
          IF NOT l_check_res THEN NEXT FIELD att05_c END IF
      AFTER FIELD att06_c
          CALL t324_check_att0x_c(g_imn[l_ac].att06_c,6,l_ac) RETURNING
               l_check_res,g_imn[l_ac].ima02,g_imn[l_ac].ima021 
          IF NOT l_check_res THEN NEXT FIELD att06_c END IF
      AFTER FIELD att07_c
          CALL t324_check_att0x_c(g_imn[l_ac].att07_c,7,l_ac) RETURNING
               l_check_res,g_imn[l_ac].ima02,g_imn[l_ac].ima021 
          IF NOT l_check_res THEN NEXT FIELD att07_c END IF
      AFTER FIELD att08_c
          CALL t324_check_att0x_c(g_imn[l_ac].att08_c,8,l_ac) RETURNING
               l_check_res,g_imn[l_ac].ima02,g_imn[l_ac].ima021 
          IF NOT l_check_res THEN NEXT FIELD att08_c END IF
      AFTER FIELD att09_c
          CALL t324_check_att0x_c(g_imn[l_ac].att09_c,9,l_ac) RETURNING
               l_check_res,g_imn[l_ac].ima02,g_imn[l_ac].ima021 
          IF NOT l_check_res THEN NEXT FIELD att09_c END IF
      AFTER FIELD att10_c
          CALL t324_check_att0x_c(g_imn[l_ac].att10_c,10,l_ac) RETURNING
               l_check_res,g_imn[l_ac].ima02,g_imn[l_ac].ima021 
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
             CALL s_reason_code(g_imm.imm01,'','',g_imn[l_ac].imn03,l_store,g_imm.imm16,g_imm.imm14) RETURNING g_imn[l_ac].imn28
             CALL t324_azf03()
             DISPLAY BY NAME g_imn[l_ac].imn28
          END IF
       #FUN-CB0087--add--end
        AFTER FIELD imn28
           IF NOT g_imn[l_ac].imn28 IS NULL THEN
             #FUN-CB0087---add---str
             IF g_aza.aza115 = 'Y' THEN
                IF NOT t324_imn28_chk1() THEN
                   NEXT FIELD imn28
                ELSE
                   CALL t324_azf03()
                END IF
             ELSE
             #FUN-CB0087---add---end
               SELECT azf09 INTO l_azf09 FROM azf_file
                WHERE azf01=g_imn[l_ac].imn28 AND azf02='2'
               IF l_azf09 != '6' THEN
                  CALL cl_err('','aoo-405',0)
                  NEXT FIELD imn28
               END IF
              SELECT azf03 INTO g_buf FROM azf_file
               WHERE azf01=g_imn[l_ac].imn28 AND azf02='2' #6818
              IF STATUS THEN
                 CALL cl_err3("sel","azf_file",g_imn[l_ac].imn28,"",
                               SQLCA.sqlcode,"","select azf",1)   #NO.FUN-640266 #No.FUN-660156
                 NEXT FIELD imn28
              END IF
             END IF                       #FUN-CB0087--add
              CALL cl_msg(g_buf)
              DISPLAY g_buf TO g_imn[l_ac].azf03    #FUN-CB0087--add
           END IF

        BEFORE FIELD imn04         #FUN-5A0066
          LET l_warehouse = '1'    #FUN-5A0066

        AFTER FIELD imn04  #倉庫
           IF p_cmd = 'u' AND NOT cl_null(g_imn[l_ac].imn04) THEN 
              IF g_imn_t.imn04 <> g_imn[l_ac].imn04 THEN
                 CALL t324_chk_icd()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    LET g_imn[l_ac].imn04 = g_imn_t.imn04
                    NEXT FIELD imn04
                 END IF
               END IF
           END IF
           #FUN-AA0007--begin--add---------
           IF NOT s_icdout_holdlot(g_imn[l_ac].imn03,g_imn[l_ac].imn04,
                                   g_imn[l_ac].imn05,g_imn[l_ac].imn06) THEN
                    #NEXT FIELD imn04   #MOD-C30526  mark
                    NEXT FIELD imn05    #MOD-C30526
           END IF
           #FUN-AA0007--end--add----------
           IF NOT cl_null(g_imn[l_ac].imn04) THEN
              #FUN-D20060---add--str
              IF NOT s_chksmz(g_imn[l_ac].imn03, g_imm.imm01,
                           g_imn[l_ac].imn04, g_imn[l_ac].imn05) THEN
                 NEXT FIELD imn04
              END IF
              #FUN-D20060---add---end
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
              #FUN-C20002--end add----------------------------------
 
              #No.FUN-AA0049--begin
              IF NOT s_chk_ware(g_imn[l_ac].imn04) THEN
                    NEXT FIELD imn04
              END IF 
              #No.FUN-AA0049--end                    
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
              CALL t324_chk_jce(g_wip,g_imn[l_ac].imn04,g_imn[l_ac].imn15)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_imn[l_ac].imn04,g_errno,1)
                    NEXT FIELD imn04
              END IF
              LET sn1=0 LET sn2=0
              #IF p_cmd = 'u' THEN   #MOD-D20038
              IF p_cmd = 'u' AND g_imn[l_ac].imn04 <> g_imn_t.imn04 THEN  #MOD-D20038
                 CALL t324_chk_out() RETURNING g_i
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
              #TQC-C60005---begin
              LET g_imn[l_ac].imn15 = g_imn[l_ac].imn04
              LET g_imn[l_ac].imn16 = g_imn[l_ac].imn05
              LET g_imn[l_ac].imn17 = g_imn[l_ac].imn06
              #TQC-C60005---end
           END IF
           LET g_imn_t.imn04=g_imn[l_ac].imn04  #No.FUN-540025
           #FUN-BC0036 --START--
           IF g_argv0 = '2' THEN
              LET g_imn[l_ac].imn15=g_imn[l_ac].imn04              
              DISPLAY BY NAME g_imn[l_ac].imn15
           #TQC-C60014---begin
              IF g_imn[l_ac].imn04 IS NOT NULL AND
                 g_imn[l_ac].imn05 IS NOT NULL AND
                 g_imn[l_ac].imn06 IS NOT NULL THEN
                 SELECT img10,img09 INTO g_imn[l_ac].imn32,g_imn[l_ac].imn30
                   FROM img_file
                  WHERE img01 = g_imn[l_ac].imn03
                    AND img02 = g_imn[l_ac].imn04
                    AND img03 = g_imn[l_ac].imn05
                    AND img04 = g_imn[l_ac].imn06
                 SELECT imgg10,imgg09 INTO g_imn[l_ac].imn35,g_imn[l_ac].imn33
                   FROM imgg_file
                  WHERE imgg01 = g_imn[l_ac].imn03
                    AND imgg02 = g_imn[l_ac].imn04
                    AND imgg03 = g_imn[l_ac].imn05
                    AND imgg04 = g_imn[l_ac].imn06
                  LET g_imn[l_ac].imn42 = g_imn[l_ac].imn32
                  LET g_imn[l_ac].imn45 = g_imn[l_ac].imn35
                  LET g_imn[l_ac].imn10 = g_imn[l_ac].imn32
                  LET g_imn[l_ac].imn09 = g_imn[l_ac].imn30
                  LET g_imn[l_ac].imn20 = g_imn[l_ac].imn30
                  LET g_imn[l_ac].imn40 = g_imn[l_ac].imn30
                  LET g_imn[l_ac].imn43 = g_imn[l_ac].imn33
                  
                  DISPLAY BY NAME g_imn[l_ac].imn32
                  DISPLAY BY NAME g_imn[l_ac].imn35
                  DISPLAY BY NAME g_imn[l_ac].imn42
                  DISPLAY BY NAME g_imn[l_ac].imn45
                  DISPLAY BY NAME g_imn[l_ac].imn30
                  DISPLAY BY NAME g_imn[l_ac].imn33
                  DISPLAY BY NAME g_imn[l_ac].imn43
              END IF 
           #TQC-C60014---end
           END IF   
           #FUN-BC0036 --END--
	#IF NOT s_imechk(g_imn[l_ac].imn04,g_imn[l_ac].imn05) THEN NEXT FIELD imn05 END IF   #FUN-D40103 #TQC-D50124 mark

        AFTER FIELD imn05  #儲位
           IF cl_null(g_imn[l_ac].imn05) THEN
              LET g_imn[l_ac].imn05=' '
           END IF
 #IF NOT s_imechk(g_imn[l_ac].imn04,g_imn[l_ac].imn05) THEN NEXT FIELD imn05 END IF   #FUN-D40103 #TQC-D50124 mark
          IF p_cmd = 'u' THEN 
              IF g_imn_t.imn05 IS NULL THEN LET g_imn_t.imn05 = ' ' END IF
              IF g_imn_t.imn05 <> g_imn[l_ac].imn05 THEN
                 CALL t324_chk_icd()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    LET g_imn[l_ac].imn05 = g_imn_t.imn05
                    #NEXT FIELD imn05   #MOD-C30526  mark
                    NEXT FIELD imn06    #MOD-C30526
                 END IF
               END IF
           END IF
           #FUN-AA0007--begin--add---------
           IF NOT s_icdout_holdlot(g_imn[l_ac].imn03,g_imn[l_ac].imn04,
                                   g_imn[l_ac].imn05,g_imn[l_ac].imn06) THEN
              #NEXT FIELD imn05   #MOD-C30526  mark
              NEXT FIELD imn06    #MOD-C30526
           END IF
           #FUN-AA0007--end--add----------
           #------------------------------------ 檢查料號預設倉儲及單別預設倉儲

           #--------------------------------------------檢查儲位是否為全形空白
           IF g_imn[l_ac].imn05 ='　' THEN
              LET g_imn[l_ac].imn05 =' '
           END IF
           IF NOT cl_null(g_imn[l_ac].imn04) THEN  #FUN-D20060  
              IF NOT s_chksmz(g_imn[l_ac].imn03, g_imm.imm01,
                              g_imn[l_ac].imn04, g_imn[l_ac].imn05) THEN
                 NEXT FIELD imn04
              END IF
           END IF                                  #FUN-D20060          
            #---->需存在倉庫/儲位檔中
            IF g_imn[l_ac].imn05 IS NOT NULL THEN
               IF sn1=1 AND g_imn[l_ac].imn05!=t_imn05
               THEN CALL cl_err(g_imn[l_ac].imn05,'mfg6081',0)
                       LET t_imn05=g_imn[l_ac].imn05
                          #NEXT FIELD imn05   #MOD-C30526  mark
                          NEXT FIELD imn06    #MOD-C30526
               ELSE IF sn2=2 AND g_imn[l_ac].imn05!=t_imn05
                    THEN CALL cl_err(g_imn[l_ac].imn05,'mfg6086',0)
                         LET t_imn05=g_imn[l_ac].imn05
                         #NEXT FIELD imn05   #MOD-C30526  mark
                         NEXT FIELD imn06    #MOD-C30526
                    END IF
               END IF
               LET sn1=0 LET sn2=0
              #TQC-C60005---begin
              LET g_imn[l_ac].imn15 = g_imn[l_ac].imn04
              LET g_imn[l_ac].imn16 = g_imn[l_ac].imn05
              LET g_imn[l_ac].imn17 = g_imn[l_ac].imn06
              #TQC-C60005---end
           END IF
           IF g_imn[l_ac].imn05 IS NULL THEN LET g_imn[l_ac].imn05=' ' END IF

           #IF p_cmd = 'u' THEN  #MOD-D20038
           IF p_cmd = 'u' AND g_imn[l_ac].imn05 <> g_imn_t.imn05 THEN  #MOD-D20038
              CALL t324_chk_out() RETURNING g_i
              IF g_i THEN
                    #NEXT FIELD imn05   #MOD-C30526  mark
                    NEXT FIELD imn06    #MOD-C30526
              END IF
           END IF
           LET g_imn_t.imn05=g_imn[l_ac].imn05  #No.FUN-540025
#FUN-B90035 ---------------Begin------------------
           IF NOT cl_null(g_imn[l_ac].imn03) THEN
              SELECT ima159 INTO l_ima159 FROM ima_file
               WHERE ima01 = g_imn[l_ac].imn03
              IF l_ima159 = '2' THEN
                 CASE t324_b_imn06_inschk(p_cmd)
                    WHEN "imn04"  NEXT FIELD imn04
                    #WHEN "imn06"  NEXT FIELD imn05   #MOD-C30526  mark
                    WHEN "imn06"  NEXT FIELD imn04   #MOD-C30526
                 END CASE
              END IF
           END IF
#FUN-B90035 ---------------End--------------------
           #FUN-BC0036 --START--
           IF g_argv0 = '2' THEN
              LET g_imn[l_ac].imn16=g_imn[l_ac].imn05
              DISPLAY BY NAME g_imn[l_ac].imn16
           #TQC-C60014---begin
              IF g_imn[l_ac].imn04 IS NOT NULL AND
                 g_imn[l_ac].imn05 IS NOT NULL AND
                 g_imn[l_ac].imn06 IS NOT NULL THEN
                 SELECT img10,img09 INTO g_imn[l_ac].imn32,g_imn[l_ac].imn30
                   FROM img_file
                  WHERE img01 = g_imn[l_ac].imn03
                    AND img02 = g_imn[l_ac].imn04
                    AND img03 = g_imn[l_ac].imn05
                    AND img04 = g_imn[l_ac].imn06
                 SELECT imgg10,imgg09 INTO g_imn[l_ac].imn35,g_imn[l_ac].imn33
                   FROM imgg_file
                  WHERE imgg01 = g_imn[l_ac].imn03
                    AND imgg02 = g_imn[l_ac].imn04
                    AND imgg03 = g_imn[l_ac].imn05
                    AND imgg04 = g_imn[l_ac].imn06
                  LET g_imn[l_ac].imn42 = g_imn[l_ac].imn32
                  LET g_imn[l_ac].imn45 = g_imn[l_ac].imn35
                  LET g_imn[l_ac].imn10 = g_imn[l_ac].imn32
                  LET g_imn[l_ac].imn09 = g_imn[l_ac].imn30
                  LET g_imn[l_ac].imn20 = g_imn[l_ac].imn30
                  LET g_imn[l_ac].imn40 = g_imn[l_ac].imn30
                  LET g_imn[l_ac].imn43 = g_imn[l_ac].imn33
                  
                  DISPLAY BY NAME g_imn[l_ac].imn32
                  DISPLAY BY NAME g_imn[l_ac].imn35
                  DISPLAY BY NAME g_imn[l_ac].imn42
                  DISPLAY BY NAME g_imn[l_ac].imn45
                  DISPLAY BY NAME g_imn[l_ac].imn30
                  DISPLAY BY NAME g_imn[l_ac].imn33
                  DISPLAY BY NAME g_imn[l_ac].imn43
              END IF 
           #TQC-C60014---end
           END IF   
           #FUN-BC0036 --END--

        AFTER FIELD imn06  #批號

#FUN-B90035 ---------------Begin-------------
            CASE t324_b_imn06_inschk(p_cmd)
               WHEN "imn04"  NEXT FIELD imn04
               #WHEN "imn06"  NEXT FIELD imn06   #MOD-C30526  mark
               WHEN "imn06"  NEXT FIELD imn04    #MOD-C30526
            END CASE
#FUN-B90035 ---------------End---------------
	 #IF NOT s_imechk(g_imn[l_ac].imn04,g_imn[l_ac].imn05) THEN NEXT FIELD imn05 END IF   #FUN-D40103 #TQC-D50124 mark
           #FUN-BC0036 --START--
           IF g_argv0 = '2' THEN
              LET g_imn[l_ac].imn17=g_imn[l_ac].imn06
              DISPLAY BY NAME g_imn[l_ac].imn17  
           #TQC-C60014---begin
              IF g_imn[l_ac].imn04 IS NOT NULL AND
                 g_imn[l_ac].imn05 IS NOT NULL AND
                 g_imn[l_ac].imn06 IS NOT NULL THEN
                 SELECT img10,img09 INTO g_imn[l_ac].imn32,g_imn[l_ac].imn30
                   FROM img_file
                  WHERE img01 = g_imn[l_ac].imn03
                    AND img02 = g_imn[l_ac].imn04
                    AND img03 = g_imn[l_ac].imn05
                    AND img04 = g_imn[l_ac].imn06
                 SELECT imgg10,imgg09 INTO g_imn[l_ac].imn35,g_imn[l_ac].imn33
                   FROM imgg_file
                  WHERE imgg01 = g_imn[l_ac].imn03
                    AND imgg02 = g_imn[l_ac].imn04
                    AND imgg03 = g_imn[l_ac].imn05
                    AND imgg04 = g_imn[l_ac].imn06
                  LET g_imn[l_ac].imn42 = g_imn[l_ac].imn32
                  LET g_imn[l_ac].imn45 = g_imn[l_ac].imn35
                  LET g_imn[l_ac].imn10 = g_imn[l_ac].imn32
                  LET g_imn[l_ac].imn09 = g_imn[l_ac].imn30
                  LET g_imn[l_ac].imn20 = g_imn[l_ac].imn30
                  LET g_imn[l_ac].imn40 = g_imn[l_ac].imn30
                  LET g_imn[l_ac].imn43 = g_imn[l_ac].imn33
                  
                  DISPLAY BY NAME g_imn[l_ac].imn32
                  DISPLAY BY NAME g_imn[l_ac].imn35
                  DISPLAY BY NAME g_imn[l_ac].imn42
                  DISPLAY BY NAME g_imn[l_ac].imn45
                  DISPLAY BY NAME g_imn[l_ac].imn30
                  DISPLAY BY NAME g_imn[l_ac].imn33
                  DISPLAY BY NAME g_imn[l_ac].imn43
              END IF 
           #TQC-C60014---end        
           END IF   
           #FUN-BC0036 --END--
           #TQC-C60005---begin
           LET g_imn[l_ac].imn15 = g_imn[l_ac].imn04
           LET g_imn[l_ac].imn16 = g_imn[l_ac].imn05
           LET g_imn[l_ac].imn17 = g_imn[l_ac].imn06
           #TQC-C60005---end
#FUN-B90035 -------------------Begin----------------
#            IF cl_null(g_imn[l_ac].imn06) THEN
#               LET g_imn[l_ac].imn06=' '
#            END IF
#&ifdef ICD
#            IF p_cmd = 'u' THEN 
#              IF g_imn_t.imn06 IS NULL THEN LET g_imn_t.imn06 = ' ' END IF
#              IF g_imn_t.imn06 <> g_imn[l_ac].imn06 THEN
#                 CALL t324_chk_icd()
#                 IF NOT cl_null(g_errno) THEN
#                    CALL cl_err('',g_errno,0)
#                    LET g_imn[l_ac].imn06 = g_imn_t.imn06
#                    NEXT FIELD imn06
#                 END IF
#               END IF
#            END IF
#           #FUN-AA0007--begin--add---------
#           IF NOT s_icdout_holdlot(g_imn[l_ac].imn03,g_imn[l_ac].imn04,
#                                   g_imn[l_ac].imn05,g_imn[l_ac].imn06) THEN
#              NEXT FIELD imn06
#           END IF
#           #FUN-AA0007--end--add----------
#&endif
#            SELECT img09,img10  INTO g_img09_s,g_img10_s FROM img_file
#             WHERE img01=g_imn[l_ac].imn03 AND
#                   img02=g_imn[l_ac].imn04 AND
#                   img03=g_imn[l_ac].imn05 AND
#                   img04=g_imn[l_ac].imn06
#            IF SQLCA.sqlcode THEN
#                LET l_img10 = 0
#                CALL cl_err3("sel","img_file",g_imn[l_ac].imn03,"",
#                             "mfg6101","","",1)   #No.FUN-660156
#                NEXT FIELD imn04
#            END IF
#            LET g_imn[l_ac].imn09=g_img09_s
#            DISPLAY BY NAME g_imn[l_ac].imn09
#            LET l_img10=g_img10_s
#            #-->有效日期
#            IF NOT s_actimg(g_imn[l_ac].imn03,g_imn[l_ac].imn04,
#                            g_imn[l_ac].imn05,g_imn[l_ac].imn06)
#            THEN CALL cl_err('inactive','mfg6117',1) #BugNo:4895
#                 NEXT FIELD imn04
#            END IF
#
#            IF p_cmd = 'u' THEN
#               CALL t324_chk_out() RETURNING g_i
#               IF g_i THEN
#                   NEXT FIELD imn06
#               END IF
#            END IF
#            IF g_sma.sma115 = 'Y' THEN
#               IF g_imn_t.imn03 IS NULL OR g_imn[l_ac].imn03 <> g_imn_t.imn03 OR
#                  g_imn_t.imn04 IS NULL OR g_imn[l_ac].imn04 <> g_imn_t.imn04 OR
#                  g_imn_t.imn05 IS NULL OR g_imn[l_ac].imn05 <> g_imn_t.imn05 OR
#                  g_imn_t.imn06 IS NULL OR g_imn[l_ac].imn06 <> g_imn_t.imn06 THEN
#                  CALL t324_du_default(p_cmd,g_imn[l_ac].imn03,g_imn[l_ac].imn04,
#                                      g_imn[l_ac].imn05,g_imn[l_ac].imn06)
#                       RETURNING g_imn[l_ac].imn33,g_imn[l_ac].imn34,g_imn[l_ac].imn35,
#                                 g_imn[l_ac].imn30,g_imn[l_ac].imn31,g_imn[l_ac].imn32
#                  DISPLAY BY NAME g_imn[l_ac].imn33
#                  DISPLAY BY NAME g_imn[l_ac].imn34
#                  DISPLAY BY NAME g_imn[l_ac].imn35
#                  DISPLAY BY NAME g_imn[l_ac].imn30
#                  DISPLAY BY NAME g_imn[l_ac].imn31
#                  DISPLAY BY NAME g_imn[l_ac].imn32
#               END IF
#            END IF
#            LET g_imn_t.imn06=g_imn[l_ac].imn06
#&ifdef ICD            
#            CALL t324_def_imniicd029()   #FUN-B30187
#&endif            
#FUN-B90035 -------------------End---------------------

        BEFORE FIELD imn33
           CALL t324_set_no_required()
 
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
                              STATUS,"","gfe:",1)   #No.FUN-660156
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
                 DISPLAY BY NAME g_imn[l_ac].imn34
              END IF
              CALL s_chk_imgg(g_imn[l_ac].imn03,g_imn[l_ac].imn04,
                              g_imn[l_ac].imn05,g_imn[l_ac].imn06,
                              g_imn[l_ac].imn33) RETURNING g_flag
              IF g_flag = 1 THEN
                #FUN-C80107 modify begin---------------------------------------121024
                #CALL cl_err('sel imgg:',STATUS,0)   #No:MOD-9C0113 modify
                #NEXT FIELD imn33
                #INITIALIZE g_sma894 TO NULL    #FUN-D30024
                #CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_imn[l_ac].imn04) RETURNING g_sma894  #FUN-D30024
                #IF g_sma894 = 'N' OR g_sma894 IS NULL THEN   #FUN-D30024
                #FUN-D30024 -------Begin---------
                 INITIALIZE g_imd23 TO NULL
                 CALL s_inv_shrt_by_warehouse(g_imn[l_ac].imn04,g_plant) RETURNING g_imd23                    #FUN-D30024  #TQC-D40078 g_plant
                 IF g_imd23 = 'N' OR g_imd23 IS NULL THEN
                #FUN-D30024 -------End-----------
                    CALL cl_err('sel imgg:',STATUS,0)
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
           END IF
           CALL t324_set_required()
           LET g_imn_t.imn33=g_imn[l_ac].imn33
           CALL t324_set_target() #MOD-640226

        BEFORE FIELD imn34  #第二轉換率
           IF cl_null(g_imn[l_ac].imn03) THEN NEXT FIELD imn03 END IF
           IF g_imn[l_ac].imn04 IS NULL OR g_imn[l_ac].imn05 IS NULL OR
              g_imn[l_ac].imn06 IS NULL THEN
              NEXT FIELD imn04
           END IF
           IF NOT cl_null(g_imn[l_ac].imn33) AND g_ima906 = '3' THEN
              CALL s_chk_imgg(g_imn[l_ac].imn03,g_imn[l_ac].imn04,
                              g_imn[l_ac].imn05,g_imn[l_ac].imn06,
                              g_imn[l_ac].imn33) RETURNING g_flag
              IF g_flag = 1 THEN
                #FUN-C80107 modify begin-----------------------------------------121024
                #CALL cl_err('sel imgg:',STATUS,0)   #No:MOD-9C0113 modify
                #NEXT FIELD imn04
              #FUN-D30024 ---------Begin----------
              #  INITIALIZE g_sma894 TO NULL
              #  CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_imn[l_ac].imn04) RETURNING g_sma894   #FUN-D30024
              #  IF g_sma894 = 'N' OR g_sma894 IS NULL THEN
                 INITIALIZE g_imd23 TO NULL
                 CALL s_inv_shrt_by_warehouse(g_imn[l_ac].imn04,g_plant) RETURNING g_imd23              #FUN-D30024  #TQC-D40078 g_plant
                 IF g_imd23 = 'N' OR g_imd23 IS NULL THEN
              #FUN-D30024 ---------End------------
                    CALL cl_err('sel imgg:',STATUS,0)
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

        AFTER FIELD imn34  #第二轉換率
           IF NOT cl_null(g_imn[l_ac].imn34) THEN
              IF g_imn[l_ac].imn34=0 THEN
                 NEXT FIELD imn34
              END IF
           END IF
           CALL t324_set_target() #MOD-640226

        BEFORE FIELD imn35
           IF cl_null(g_imn[l_ac].imn03) THEN NEXT FIELD imn03 END IF
           IF g_imn[l_ac].imn04 IS NULL OR g_imn[l_ac].imn05 IS NULL OR
              g_imn[l_ac].imn06 IS NULL THEN
              NEXT FIELD imn04
           END IF
           IF NOT cl_null(g_imn[l_ac].imn33) AND g_ima906 = '3' THEN
              CALL s_chk_imgg(g_imn[l_ac].imn03,g_imn[l_ac].imn04,
                              g_imn[l_ac].imn05,g_imn[l_ac].imn06,
                              g_imn[l_ac].imn33) RETURNING g_flag
              IF g_flag = 1 THEN
                #FUN-C80107 modify begin-----------------------------------------121024
                #CALL cl_err('sel imgg:',STATUS,0)   #No:MOD-9C0113 modify
                #NEXT FIELD imn04
                #FUN-D30024 -----------Begin-----------
                #INITIALIZE g_sma894 TO NULL
                #CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_imn[l_ac].imn04) RETURNING g_sma894  #FUN-D30024
                #IF g_sma894 = 'N' OR g_sma894 IS NULL THEN
                 INITIALIZE g_imd23 TO NULL
                 CALL s_inv_shrt_by_warehouse(g_imn[l_ac].imn04,g_plant) RETURNING g_imd23  #FUN-D30024 #TQC-D40078 g_plant
                 IF g_imd23 = 'N' OR g_imd23 IS NULL THEN
                #FUN-D30024 -----------End-------------
                    CALL cl_err('sel imgg:',STATUS,0)
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
           IF NOT cl_null(g_imn[l_ac].imn35) THEN
              IF g_imn[l_ac].imn35 < 0 THEN
                 CALL cl_err('','aim-391',0)  #
                 NEXT FIELD imn35
              END IF
              IF p_cmd = 'a' THEN
                 IF g_ima906='3' THEN
                    LET g_tot=g_imn[l_ac].imn35*g_imn[l_ac].imn34
                    IF cl_null(g_imn[l_ac].imn32) OR g_imn[l_ac].imn32=0 THEN #CHI-960022
                       LET g_imn[l_ac].imn32=g_tot*g_imn[l_ac].imn31
                       DISPLAY BY NAME g_imn[l_ac].imn32
                    END IF                                                    #CHI-960022 
                 END IF
              END IF
           END IF
              SELECT ima918,ima921,ima930 INTO g_ima918,g_ima921,g_ima930 #DEV-D30059 add ima930 
                FROM ima_file
               WHERE ima01 = g_imn[l_ac].imn03
                 AND imaacti = "Y"
              
              IF cl_null(g_ima918) THEN LET g_ima918 = 'N' END IF  #DEV-D30059 add
              IF cl_null(g_ima921) THEN LET g_ima921 = 'N' END IF  #DEV-D30059 add
              IF cl_null(g_ima930) THEN LET g_ima930 = 'N' END IF  #DEV-D30059 add

              IF (g_ima918 = "Y" OR g_ima921 = "Y") AND
                 (cl_null(g_imn_t.imn35) OR (g_imn[l_ac].imn35<>g_imn_t.imn35 )) THEN
                #CALL s_lotout(g_prog,g_imm.imm01,g_imn[l_ac].imn02,0,     #TQC-B90236 mark
                 IF g_ima930 = 'N' THEN                                        #DEV-D30059
                    CALL s_mod_lot(g_prog,g_imm.imm01,g_imn[l_ac].imn02,0,     #TQC-B90236 add
                                  g_imn[l_ac].imn03,g_imn[l_ac].imn04,
                                  g_imn[l_ac].imn05,g_imn[l_ac].imn06,
                                  g_imn[l_ac].imn09,g_imn[l_ac].imn09,1,
                                  g_imn[l_ac].imn10,'','MOD',-1) #CHI-9A0022 add ''  #TQC-B90236 add '-1'
                        RETURNING l_r,g_qty 
                 END IF                                                        #DEV-D30059
                 IF l_r = "Y" THEN
                    LET g_imn[l_ac].imn10 = g_qty
                 END IF
              
                 LET g_imn[l_ac].imn22 = g_imn[l_ac].imn10 * g_imn[l_ac].imn21
              
                 DISPLAY BY NAME g_imn[l_ac].imn10,g_imn[l_ac].imn22
              
                 CALL t324_ins_rvbs()   #No:FUN-860045
              END IF
           CALL t324_set_target() #MOD-640226
 
           BEFORE FIELD imn30
              CALL t324_set_no_required()
 
        AFTER FIELD imn30  #第一單位
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
                 CALL cl_err3("sel","gfe_file",g_imn[l_ac].imn30,"",SQLCA.sqlcode,
                              "","gfe:",1)  #No:FUN-660156
                 NEXT FIELD imn30
              END IF
              CALL t324_set_origin_field()   #MOD-A80088
              CALL s_du_umfchk(g_imn[l_ac].imn03,'','','',
                               g_imn[l_ac].imn09,g_imn[l_ac].imn30,'1')
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_imn[l_ac].imn30,g_errno,0)
                 NEXT FIELD imn30
              END IF
              IF cl_null(g_imn_t.imn30) OR g_imn_t.imn30 <> g_imn[l_ac].imn30 THEN
                 LET g_imn[l_ac].imn31 = g_factor
                 DISPLAY BY NAME g_imn[l_ac].imn31
              END IF
              IF g_ima906 = '2' THEN
                 CALL s_chk_imgg(g_imn[l_ac].imn03,g_imn[l_ac].imn04,
                                 g_imn[l_ac].imn05,g_imn[l_ac].imn06,
                                 g_imn[l_ac].imn30) RETURNING g_flag
                 IF g_flag = 1 THEN
                   #FUN-C80107 modify begin-----------------------------------------121024
                   #CALL cl_err('sel imgg:',STATUS,0)   #No:MOD-9C0113 modify
                   #NEXT FIELD imn30
                  #FUN-D30024 ------------Begin--------------
                  # INITIALIZE g_sma894 TO NULL
                  # CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_imn[l_ac].imn04) RETURNING g_sma894  #FUN-D30024
                  # IF g_sma894 = 'N' OR g_sma894 IS NULL THEN
                    INITIALIZE g_imd23 TO NULL
                    CALL s_inv_shrt_by_warehouse(g_imn[l_ac].imn04,g_plant) RETURNING g_imd23    #FUN-D30024   #TQC-D40078 g_plant
                    IF g_imd23 = 'N' OR g_imd23 IS NULL THEN
                  #FUN-D30024 ------------End----------------
                       CALL cl_err('sel imgg:',STATUS,0)
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
              END IF
           END IF
           CALL t324_set_required()
           LET g_imn_t.imn30=g_imn[l_ac].imn30
           CALL t324_set_target() #MOD-640226

        AFTER FIELD imn31  #第一轉換率
           IF NOT cl_null(g_imn[l_ac].imn31) THEN
              IF g_imn[l_ac].imn31=0 THEN
                 NEXT FIELD imn31
              END IF
              CALL t324_set_target() #MOD-640226
           END IF
           CALL t324_set_target() #MOD-640226

        AFTER FIELD imn32  #第一數量
           IF NOT cl_null(g_imn[l_ac].imn32) THEN
              IF g_imn[l_ac].imn32 < 0 THEN
                 CALL cl_err('','aim-391',0)  #
                 NEXT FIELD imn32
              END IF
           END IF
           CALL t324_set_target() #MOD-640226           
           

       AFTER FIELD imn10  #調撥數量
           IF NOT cl_null(g_imn[l_ac].imn10) THEN
              IF g_imn[l_ac].imn10 <= 0 THEN
                 CALL cl_err('','mfg9105',0)
                 NEXT FIELD imn10
              END IF
              IF p_cmd = 'u' THEN
                 LET g_imn[l_ac].imn22 = g_imn[l_ac].imn10 * g_imn[l_ac].imn21
                 DISPLAY BY NAME g_imn[l_ac].imn22
              END IF
              IF g_imn[l_ac].imn10 > l_img10 THEN
                #IF g_sma.sma894[4,4]='N' OR g_sma.sma894[4,4] IS NULL THEN                                #FUN-C80107 mark
              #FUN-D30024 --------Begin---------
                #INITIALIZE g_sma894 TO NULL                                                               #FUN-C80107
                #CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_imn[l_ac].imn04) RETURNING g_sma894      #FUN-C80107 #FUN-D30024
                #IF g_sma894 = 'N' THEN                                                                    #FUN-C80107
                 INITIALIZE g_imd23 TO NULL
                 CALL s_inv_shrt_by_warehouse(g_imn[l_ac].imn04,g_plant) RETURNING g_imd23                        #FUN-D30024 #TQC-D40078 g_plant
                 IF g_imd23 = 'N' OR g_imd23 IS NULL THEN
              #FUN-D30024 --------End------------
                    CALL cl_err(l_img10,'mfg3471',0)
                    NEXT FIELD imn10
                 ELSE
                   IF NOT cl_confirm('mfg3469') THEN
                       NEXT FIELD imn10
                    END IF
                 END IF
              END IF
              LET g_imn[l_ac].imn22=g_imn[l_ac].imn10*g_imn[l_ac].imn21
              DISPLAY BY NAME g_imn[l_ac].imn22
              SELECT ima918,ima921,ima930 INTO g_ima918,g_ima921,g_ima930 #DEV-D30059 add ima930 
                FROM ima_file
               WHERE ima01 = g_imn[l_ac].imn03
                 AND imaacti = "Y"

              IF cl_null(g_ima930) THEN LET g_ima930 = 'N' END IF  #DEV-D30059 add
              
              IF (g_ima918 = "Y" OR g_ima921 = "Y") AND
                 (cl_null(g_imn_t.imn10) OR (g_imn[l_ac].imn10<>g_imn_t.imn10 )) THEN
                #CALL s_lotout(g_prog,g_imm.imm01,g_imn[l_ac].imn02,0,     #TQC-B90236 mark
                 IF g_ima930 = 'N' THEN                                        #DEV-D30059
                    CALL s_mod_lot(g_prog,g_imm.imm01,g_imn[l_ac].imn02,0,     #TQC-B90236 add
                                  g_imn[l_ac].imn03,g_imn[l_ac].imn04,
                                  g_imn[l_ac].imn05,g_imn[l_ac].imn06,
                                  g_imn[l_ac].imn09,g_imn[l_ac].imn09,1,
                                  g_imn[l_ac].imn10,'','MOD',-1)#CHI-9A0022 add ''   #TQC-B90236 add '-1'
                        RETURNING l_r,g_qty 
                 END IF                                                        #DEV-D30059
                 IF l_r = "Y" THEN
                    LET g_imn[l_ac].imn10 = g_qty
                 END IF
              
                 LET g_imn[l_ac].imn22 = g_imn[l_ac].imn10 * g_imn[l_ac].imn21
              
                 DISPLAY BY NAME g_imn[l_ac].imn10,g_imn[l_ac].imn22
              
                 CALL t324_ins_rvbs()   #No:FUN-860045
              END IF
           END IF

        BEFORE FIELD imn15         #FUN-5A0066
           LET l_warehouse = '2'   #FUN-5A0066

#------目的倉庫------------------------------------------------
        AFTER FIELD imn15  #倉庫
         IF p_cmd = 'u' AND NOT cl_null(g_imn[l_ac].imn15) THEN 
              IF g_imn_t.imn15 <> g_imn[l_ac].imn15 THEN
                 CALL t324_chk_icd()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    LET g_imn[l_ac].imn15 = g_imn_t.imn15
                    NEXT FIELD imn15
                 END IF
               END IF
           END IF
 
            IF NOT cl_null(g_imn[l_ac].imn15) THEN
               #FUN-D20060---add---str
               IF NOT s_chksmz(g_imn[l_ac].imn03, g_imm.imm01,
                               g_imn[l_ac].imn15, g_imn[l_ac].imn16) THEN
                  NEXT FIELD imn15
               END IF
               #FUN-D20060---add---end
               #FUN-C20002--start add------------------------
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

                     CALL s_get_defstore(g_plant,g_imn[l_ac].imn03) RETURNING l_rtz07,l_rtz08

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
               #FUN-C20002--end add--------------------------

               #No.FUN-AA0049--begin
               IF NOT s_chk_ware(g_imn[l_ac].imn15) THEN
                  NEXT FIELD imn15
               END IF 
               #No.FUN-AA0049--end              
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
               CALL s_swyn(g_imn[l_ac].imn15) RETURNING sn1,sn2
               IF sn1=1 AND g_imn[l_ac].imn15!=t_imn15 THEN
                  CALL cl_err(g_imn[l_ac].imn15,'mfg6080',1)
                  LET t_imn15=g_imn[l_ac].imn15
                  NEXT FIELD imn15
               ELSE
                  IF sn2=2 AND g_imn[l_ac].imn15!=t_imn15 THEN
                     CALL cl_err(g_imn[l_ac].imn15,'mfg6085',0)
                     LET t_imn15=g_imn[l_ac].imn15
                  NEXT FIELD imn15
                  END IF
               END IF
              CALL t324_chk_jce(g_wip,g_imn[l_ac].imn04,g_imn[l_ac].imn15)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_imn[l_ac].imn15,g_errno,1)
                  NEXT FIELD imn15
              END IF

              #IF p_cmd = 'u' THEN  #MOD-D20038
              IF p_cmd = 'u' AND g_imn[l_ac].imn15 <> g_imn_t.imn15 THEN  #MOD-D20038
                 CALL t324_chk_in() RETURNING g_i
                 IF g_i THEN
                    NEXT FIELD imn17   #MOD-5B0300
                 END IF
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
           LET g_imn_t.imn15=g_imn[l_ac].imn15  #No.FUN-540025
	#IF NOT s_imechk(g_imn[l_ac].imn15,g_imn[l_ac].imn16) THEN NEXT FIELD imn16 END IF  #FUN-D40103 add #TQC-D50124 mark 
           NEXT FIELD imn16

        AFTER FIELD imn16  #儲位
           #BugNo:5626 控管是否為全型空白
           IF g_imn[l_ac].imn16 = '　' THEN #全型空白
              LET g_imn[l_ac].imn16 = ' '
           END IF
           IF cl_null(g_imn[l_ac].imn16) THEN
              LET g_imn[l_ac].imn16 = ' '
           END IF
	#IF NOT s_imechk(g_imn[l_ac].imn15,g_imn[l_ac].imn16) THEN NEXT FIELD imn16 END IF  #FUN-D40103 add #TQC-D50124 mark 
          
           IF p_cmd = 'u' THEN 
              IF g_imn_t.imn16 <> g_imn[l_ac].imn16 THEN
                 IF cl_null(g_imn_t.imn16) THEN LET g_imn_t.imn16 = ' ' END IF
                 CALL t324_chk_icd()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    LET g_imn[l_ac].imn16 = g_imn_t.imn16
                    #NEXT FIELD imn16   #MOD-C30526 mark
                    NEXT FIELD imn17    #MOD-C30526
                 END IF
               END IF
           END IF
            #------>chk-1
            IF NOT s_imfchk(g_imn[l_ac].imn03,g_imn[l_ac].imn15,
                            g_imn[l_ac].imn16)
               THEN CALL cl_err(g_imn[l_ac].imn16,'mfg6095',0)
                    #NEXT FIELD imn16   #MOD-C30526 mark
                    NEXT FIELD imn17    #MOD-C30526
            END IF
            CALL s_hqty(g_imn[l_ac].imn03,g_imn[l_ac].imn15,
                        g_imn[l_ac].imn16)
                    RETURNING g_cnt,t_imf04,t_imf05
                LET h_qty=t_imf04
            CALL  s_lwyn(g_imn[l_ac].imn15,g_imn[l_ac].imn16)
                          RETURNING sn1,sn2
                           IF sn1=1 AND g_imn[l_ac].imn16!=t_imn16
                  THEN CALL cl_err(g_imn[l_ac].imn16,'mfg6081',0)
                       LET t_imn16=g_imn[l_ac].imn16
                       #NEXT FIELD imn16   #MOD-C30526 mark
                       NEXT FIELD imn17    #MOD-C30526
                  ELSE IF sn2=2 AND g_imn[l_ac].imn16!=t_imn16
                          THEN CALL cl_err(g_imn[l_ac].imn16,'mfg6086',0)
                               LET t_imn16=g_imn[l_ac].imn16
                               #NEXT FIELD imn16   #MOD-C30526 mark
                               NEXT FIELD imn17    #MOD-C30526
                       END IF
               END IF
                        LET sn1=0 LET sn2=0
            IF cl_null(g_imn[l_ac].imn16) THEN LET g_imn[l_ac].imn16=' ' END IF
            #FUN-D20060---add---str
             IF NOT cl_null(g_imn[l_ac].imn15) THEN
                IF NOT s_chksmz(g_imn[l_ac].imn03, g_imm.imm01,
                                g_imn[l_ac].imn15, g_imn[l_ac].imn16) THEN
                   NEXT FIELD imn15
                END IF
             END IF
            #FUN-D20060---add---end
            #MOD-550074 原本被MARK掉,復原
           #IF p_cmd = 'u' THEN  #MOD-D20038
           IF p_cmd = 'u' AND g_imn[l_ac].imn16 <> g_imn_t.imn16 THEN  #MOD-D20038
              CALL t324_chk_in() RETURNING g_i
              IF g_i THEN
                 NEXT FIELD imn17   #MOD-5B0300
              END IF
           END IF
           LET g_imn_t.imn16=g_imn[l_ac].imn16  #No.FUN-540025
           NEXT FIELD imn17
#FUN-B90035 ---------------Begin----------------
           IF NOT cl_null(g_imn[l_ac].imn03) THEN
              SELECT ima159 INTO l_ima159 FROM ima_file
               WHERE ima01 = g_imn[l_ac].imn03
              IF l_ima159 = '2' THEN
                 CASE t324_b_imn17_inschk(p_cmd)
                    WHEN "imn04" NEXT FIELD imn04
                    WHEN "imn15" NEXT FIELD imn15
                    #WHEN "imn17" NEXT FIELD imn16   #MOD-C30526 mark
                    WHEN "imn17" NEXT FIELD imn15    #MOD-C30526
                 END CASE
              END IF
           END IF
#FUN-B90035 ---------------End------------------

        AFTER FIELD imn17

#FUN-B90035 ---------------Begin---------------
            CASE t324_b_imn17_inschk(p_cmd)
               WHEN "imn04" NEXT FIELD imn04 
               WHEN "imn15" NEXT FIELD imn15
               #WHEN "imn17" NEXT FIELD imn17   #MOD-C30526 mark
               WHEN "imn17" NEXT FIELD imn15    #MOD-C30526
            END CASE
#FUN-B90035 ---------------End-----------------
	 #IF NOT s_imechk(g_imn[l_ac].imn15,g_imn[l_ac].imn16) THEN NEXT FIELD imn16 END IF  #FUN-D40103 add #TQC-D50124 mark 
#FUN-B90035 -------------------Begin---------------
#           IF cl_null(g_imn[l_ac].imn15) THEN
#              CALL cl_err('','aim-145',1)
#              NEXT FIELD imn15
#           END IF
#           #BugNo:5626 控管是否為全型空白
#           IF g_imn[l_ac].imn17 = '　' THEN #全型空白
#               LET g_imn[l_ac].imn17 = ' '
#           END IF
#           IF cl_null(g_imn[l_ac].imn17) THEN
#              LET g_imn[l_ac].imn17 = ' '
#           END IF
#&ifdef ICD
#           IF p_cmd = 'u' THEN 
#              IF cl_null(g_imn_t.imn17) THEN LET g_imn_t.imn17 = ' ' END IF
#              IF g_imn_t.imn17 <> g_imn[l_ac].imn17 THEN
#                 CALL t324_chk_icd()
#                 IF NOT cl_null(g_errno) THEN
#                    CALL cl_err('',g_errno,0)
#                    LET g_imn[l_ac].imn17 = g_imn_t.imn17
#                    NEXT FIELD imn17
#                 END IF
#               END IF
#           END IF
#&endif
#           IF g_imn[l_ac].imn04=g_imn[l_ac].imn15 AND
#              g_imn[l_ac].imn05=g_imn[l_ac].imn16 THEN
#              IF ( g_imn[l_ac].imn06=g_imn[l_ac].imn17) OR
#                 ( g_imn[l_ac].imn06 IS NULL AND g_imn[l_ac].imn17 IS NULL) THEN
#                  CALL cl_err('','mfg6103',0)
#                  NEXT FIELD imn17
#              END IF
#           END IF
#            IF cl_null(g_imn[l_ac].imn05) THEN LET g_imn[l_ac].imn05 =' ' END IF
#            IF cl_null(g_imn[l_ac].imn06) THEN LET g_imn[l_ac].imn06 =' ' END IF
#
#            IF cl_null(g_imn[l_ac].imn09) THEN
#               SELECT img09 INTO g_imn[l_ac].imn09 FROM img_file
#                WHERE img01=g_imn[l_ac].imn03 AND
#                      img02=g_imn[l_ac].imn04 AND
#                      img03=g_imn[l_ac].imn05 AND
#                      img04=g_imn[l_ac].imn06
#               IF SQLCA.sqlcode THEN
#                   CALL cl_err3("sel","img_file",g_imn[l_ac].imn03,"",
#                                "mfg6101","","",1)  
#                   NEXT FIELD imn04
#               END IF
#            END IF
#           SELECT *
#             FROM img_file WHERE img01=g_imn[l_ac].imn03 AND
#                                 img02=g_imn[l_ac].imn15 AND
#                                 img03=g_imn[l_ac].imn16 AND
#                                 img04=g_imn[l_ac].imn17
#           IF SQLCA.sqlcode THEN
#              IF g_sma.sma892[3,3] = 'Y' THEN
#                 IF NOT cl_confirm('mfg1401') THEN NEXT FIELD imn15 END IF
#              END IF
#                 CALL s_add_img(g_imn[l_ac].imn03,g_imn[l_ac].imn15,
#                                g_imn[l_ac].imn16,g_imn[l_ac].imn17,
#                                g_imm.imm01      ,g_imn[l_ac].imn02,
#                                g_imm.imm02)
#              IF g_errno='N' THEN
#                  NEXT FIELD imn17
#              END IF
#              SELECT img09  INTO g_imn[l_ac].imn20
#                FROM img_file WHERE img01=g_imn[l_ac].imn03 AND
#                                    img02=g_imn[l_ac].imn15 AND
#                                    img03=g_imn[l_ac].imn16 AND
#                                    img04=g_imn[l_ac].imn17
#              DISPLAY BY NAME g_imn[l_ac].imn20
#              CALL s_umfchk(g_imn[l_ac].imn03,g_imn[l_ac].imn09,g_imn[l_ac].imn20)
#                            RETURNING g_cnt,g_imn[l_ac].imn21
#              IF g_cnt = 1 THEN
#                  CALL cl_err('','mfg3075',1)
#                  NEXT FIELD imn17
#              END IF
#           ELSE
#                 SELECT img09  INTO g_imn[l_ac].imn20
#                   FROM img_file WHERE img01=g_imn[l_ac].imn03 AND
#                                       img02=g_imn[l_ac].imn15 AND
#                                       img03=g_imn[l_ac].imn16 AND
#                                       img04=g_imn[l_ac].imn17
#              CALL s_umfchk(g_imn[l_ac].imn03,
#                            g_imn[l_ac].imn09,g_imn[l_ac].imn20)
#                       RETURNING g_cnt,g_imn[l_ac].imn21
#                       DISPLAY BY NAME g_imn[l_ac].imn20
#                       DISPLAY BY NAME g_imn[l_ac].imn21
#              IF g_cnt = 1 THEN
#                 CALL cl_err('','mfg3075',1)
#                 NEXT FIELD imn17
#              END IF
#           END IF
#           IF g_imn[l_ac].imn04 = g_imn[l_ac].imn15 AND
#              g_imn[l_ac].imn05 = g_imn[l_ac].imn16 AND
#              g_imn[l_ac].imn06 = g_imn[l_ac].imn17
#           THEN CALL cl_err('','mfg9090',1)
#                NEXT FIELD imn15
#           END IF
#           IF NOT s_actimg(g_imn[l_ac].imn03,g_imn[l_ac].imn15,
#                           g_imn[l_ac].imn16,g_imn[l_ac].imn17)
#           THEN CALL cl_err('inactive','mfg6117',0)
#                NEXT FIELD imn15
#           END IF
#           LET g_imn[l_ac].imn22=g_imn[l_ac].imn10*g_imn[l_ac].imn21
#           DISPLAY BY NAME g_imn[l_ac].imn22
#           SELECT img09,img10  INTO g_img09_t,g_img10_t FROM img_file
#            WHERE img01=g_imn[l_ac].imn03 AND
#                  img02=g_imn[l_ac].imn15 AND
#                  img03=g_imn[l_ac].imn16 AND
#                  img04=g_imn[l_ac].imn17
#           IF SQLCA.sqlcode THEN
#              LET l_img10 = 0
#              CALL cl_err3("sel","img_file",g_imn[l_ac].imn03,g_imn[l_ac].imn15,
#                           "mfg6101","","",1)  #No:FUN-660156
#              NEXT FIELD imn15
#           END IF
#           LET g_imn_t.imn17=g_imn[l_ac].imn17
#           IF p_cmd = 'u' THEN
#              CALL t324_chk_in() RETURNING g_i
#              IF g_i THEN
#                  NEXT FIELD imn17
#              END IF
#           END IF
#          IF NOT t324_set_imn40() THEN
#             NEXT FIELD imn15
#          END IF
#
#          IF NOT t324_set_imn43() THEN
#             NEXT FIELD imn15
#          END IF
#          SELECT ima906 INTO l_ima906 FROM ima_file 
#                  WHERE ima01 = g_imn[l_ac].imn03
#          IF g_sma.sma115 = 'Y' AND l_ima906 != '2' THEN
#             SELECT img09 INTO l_img09 FROM img_file 
#                  WHERE img01 = g_imn[l_ac].imn03
#                    AND img02 = g_imn[l_ac].imn15
#                    AND img03 = g_imn[l_ac].imn16
#                    AND img04 = g_imn[l_ac].imn17
#            
#             IF NOT cl_null(l_img09) AND g_imn[l_ac].imn40 != l_img09 THEN 
#                CALL s_umfchk(g_imn[l_ac].imn03,g_imn[l_ac].imn40,l_img09)
#                     RETURNING l_cnt,l_factor
#                
#                IF l_cnt = 1 THEN LET l_factor = 1 END IF
#                LET g_imn[l_ac].imn41 = l_factor
#             END IF
#          END IF
#FUN-B90035 -------------------End--------------------

        AFTER FIELD imn20
            CALL s_umfchk(g_imn[l_ac].imn03,
                          g_imn[l_ac].imn09,g_imn[l_ac].imn20)
                 RETURNING g_cnt,g_imn[l_ac].imn21
            IF g_cnt = 1 THEN
               CALL cl_err('','mfg3075',1)
               NEXT FIELD imn20
            END IF
            LET g_imn[l_ac].imn22=g_imn[l_ac].imn10*g_imn[l_ac].imn21
            DISPLAY BY NAME g_imn[l_ac].imn21
            DISPLAY BY NAME g_imn[l_ac].imn22
            
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
        AFTER FIELD imnud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD imnud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD imnud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD imnud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD imnud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD imnud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD imnud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD imnud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD imnud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD imnud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD imnud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD imnud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD imnud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD imnud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD imnud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

        BEFORE DELETE                            #是否取消單身
           IF g_imn_t.imn02 > 0 AND g_imn_t.imn02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
               IF NOT t324_icd_del_chk(g_imn_t.imn02) THEN
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
              DELETE FROM imn_file
                  WHERE imn01 = g_imm.imm01 AND imn02 = g_imn_t.imn02 
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","imn_file",g_imm.imm01,g_imn_t.imn02,
                               SQLCA.sqlcode,"","",1)  #No:FUN-660156
                  ROLLBACK WORK
                  CANCEL DELETE
               #FUN-B30187 -START--
               ELSE
                  IF NOT s_del_imni(g_imm.imm01,g_imn_t.imn02,'') THEN      
                     ROLLBACK WORK
                     CANCEL DELETE
                  END IF
               #FUN-B30187 -END--
              END IF
              SELECT ima918,ima921 INTO g_ima918,g_ima921 
                FROM ima_file
               WHERE ima01 = g_imn[l_ac].imn03
                 AND imaacti = "Y"
              
              IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                #IF NOT s_lotout_del(g_prog,g_imm.imm01,g_imn[l_ac].imn02,0,g_imn[l_ac].imn03,'DEL') THEN   #No:FUN-860045 #TQC-B90236 mark
                 IF NOT s_lot_del(g_prog,g_imm.imm01,g_imn[l_ac].imn02,0,g_imn[l_ac].imn03,'DEL') THEN   #No:FUN-860045 #TQC-B90236 add
                    CALL cl_err3("del","rvbs_file",g_imm.imm01,g_imn_t.imn02,
                                  SQLCA.sqlcode,"","",1)
                     ROLLBACK WORK
                     CANCEL DELETE
                 END IF
                #IF NOT s_lotin_del(g_prog,g_imm.imm01,g_imn[l_ac].imn02,0,g_imn[l_ac].imn03,'DEL') THEN   #No:FUN-860045  #TQC-B90236 mark
                 IF NOT s_lot_del(g_prog,g_imm.imm01,g_imn[l_ac].imn02,0,g_imn[l_ac].imn03,'DEL') THEN   #No:FUN-860045  #TQC-B90236 add
                    CALL cl_err3("del","rvbs_file",g_imm.imm01,g_imn_t.imn02,
                                  SQLCA.sqlcode,"","",1)
                     ROLLBACK WORK
                     CANCEL DELETE
                 END IF
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
              COMMIT WORK
           END IF

        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_imn[l_ac].* = g_imn_t.*
               CLOSE t324_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            #FUN-CB0087---add---str---
            IF g_aza.aza115 = 'Y' THEN
               IF NOT t324_imn28_chk1() THEN
                  NEXT FIELD imn28
               END IF
            END IF
            #FUN-CB0087---add---end---

            #FUN-BA0051 --START mark--
            ##若料號做刻號管理（imaicd08=Y）,則撥出/入單位一定要相同
            ##若料號做刻號管理（imaicd08=Y），則撥入單位一定要、與撥入ima_file單位同
            #LET l_imaicd08 = NULL
            #SELECT imaicd08 INTO l_imaicd08 FROM imaicd_file
            # WHERE imaicd00 = g_imn[l_ac].imn03
            #IF NOT cl_null(l_imaicd08) AND l_imaicd08 = 'Y' THEN
            #FUN-BA0051 --END mark--
            IF s_icdbin(g_imn[l_ac].imn03) THEN   #FUN-BA0051
               #chk撥出/入單位是否相同
               IF g_imn[l_ac].imn09 <> g_imn[l_ac].imn20 THEN
                  CALL cl_err(g_imn[l_ac].imn03,'aic-912',1)
                  NEXT FIELD imn03
               END IF
               #FUN-BC0036 --START--
               IF g_argv0 = '2' THEN
                 LET g_imn[l_ac].imn20 = g_imn[l_ac].imn09 
               END IF 
               #FUN-BC0036 --END--
               #chk撥入單位是否與撥入img_file單位同
               LET g_cnt = 0
               SELECT COUNT(*) INTO g_cnt FROM img_file
                WHERE img01 = g_imn[l_ac].imn03
                  AND img02 = g_imn[l_ac].imn15
                  AND img03 = g_imn[l_ac].imn16
                  AND img04 = g_imn[l_ac].imn17
                  AND img09 = g_imn[l_ac].imn20
               IF g_cnt = 0 THEN
                  CALL cl_err(g_imn[l_ac].imn03,'aic-913',1)
                  NEXT FIELD imn15
               END IF
            END IF

            IF g_imn_t.imn05 IS NULL THEN LET g_imn_t.imn05 = ' ' END IF
            IF g_imn_t.imn06 IS NULL THEN LET g_imn_t.imn06 = ' ' END IF
            IF g_imn_t.imn16 IS NULL THEN LET g_imn_t.imn16 = ' ' END IF
            IF g_imn_t.imn17 IS NULL THEN LET g_imn_t.imn17 = ' ' END IF
            IF g_imn[l_ac].imn05 IS NULL THEN LET g_imn[l_ac].imn05 = ' ' END IF
            IF g_imn[l_ac].imn06 IS NULL THEN LET g_imn[l_ac].imn06 = ' ' END IF
            IF g_imn[l_ac].imn16 IS NULL THEN LET g_imn[l_ac].imn16 = ' ' END IF
            IF g_imn[l_ac].imn17 IS NULL THEN LET g_imn[l_ac].imn17 = ' ' END IF
            IF g_imn_t.imn02 <> g_imn[l_ac].imn02 OR   #項次
               g_imn_t.imn03 <> g_imn[l_ac].imn03 OR   #料號
               g_imn_t.imn04 <> g_imn[l_ac].imn04 OR   #出倉
               g_imn_t.imn05 <> g_imn[l_ac].imn05 OR   #出庫
               g_imn_t.imn06 <> g_imn[l_ac].imn06 OR   #出批
               g_imn_t.imn09 <> g_imn[l_ac].imn09 OR   #出單位
               g_imn_t.imn15 <> g_imn[l_ac].imn15 OR   #入倉
               g_imn_t.imn16 <> g_imn[l_ac].imn16 OR   #入庫
               g_imn_t.imn17 <> g_imn[l_ac].imn17 OR   #入批
               g_imn_t.imn20 <> g_imn[l_ac].imn20 THEN #入單位
               CALL t324_chk_icd()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD imn03
               END IF
            END IF
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
                  CALL t324_du_data_to_correct()
               END IF

                IF NOT cl_null(g_imn[l_ac].imn03) THEN #MOD-4B0249(多包此IF 判斷)
                  SELECT * FROM img_file
                   WHERE img01=g_imn[l_ac].imn03
                     AND img02=g_imn[l_ac].imn15
                     AND img03=g_imn[l_ac].imn16
                     AND img04=g_imn[l_ac].imn17
                  IF STATUS=100 THEN
                     IF g_sma.sma892[3,3] = 'Y' THEN
                        IF NOT cl_confirm('mfg1401') THEN
                           NEXT FIELD imn15
                        END IF
                     END IF
                     IF g_imn[l_ac].imn05 IS NULL THEN LET g_imn[l_ac].imn05 =' ' END IF   #MOD-CB0122 add
                     IF g_imn[l_ac].imn06 IS NULL THEN LET g_imn[l_ac].imn06 =' ' END IF   #MOD-CB0122 add
                    #CHI-C50010 str add-----
                    #SELECT img18 INTO l_date FROM img_file                #CHI-C80007 mark
                     SELECT img18,img37 INTO l_date,l_img37 FROM img_file  #CHI-C80007 add img37  
                      WHERE img01 = g_imn[l_ac].imn03
                        AND img02 = g_imn[l_ac].imn04
                        AND img03 = g_imn[l_ac].imn05
                        AND img04 = g_imn[l_ac].imn06
                    #MOD-CB0122 add---S
                     IF STATUS=100 THEN
                        CALL cl_err('','mfg6101',1)
                        NEXT FIELD imn17
                     ELSE
                    #MOD-CB0122 add---E
                        CALL s_date_record(l_date,'Y')
                     END IF     #MOD-CB0122 add
                    #CHI-C50010 end add-----
                     CALL s_idledate_record(l_img37)  #CHI-C80007 add
                     CALL s_add_img(g_imn[l_ac].imn03,g_imn[l_ac].imn15,
                                    g_imn[l_ac].imn16,g_imn[l_ac].imn17,
                                    #g_imm.imm01,g_imn[l_ac].imn02,g_imm.imm02)  #FUN-D40053
                                    g_imm.imm01,g_imn[l_ac].imn02,g_imm.imm17)  #FUN-D40053
                     IF g_errno='N' THEN
                         NEXT FIELD imn17
                     END IF
                  END IF
                END IF #MOD-4B0249

               IF g_sma.sma115 = 'Y' THEN
                  IF t324_qty_issue() THEN
                     NEXT FIELD imn30
                  END IF
                  CALL t324_set_origin_field()
               END IF
 
               CALL t324_b_move_back()

               #料號為參考單位，單一單位，狀態為其他段生產料號（imaicd04=3,4）時，
               #將單位一的資料給單位二
               CALL t324_set_value()  #FUN-920207

               LET g_success = 'Y'   #FUN-B30187
               UPDATE imn_file SET * = b_imn.*
                  WHERE imn01=g_imm.imm01 AND imn02=g_imn_t.imn02 
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","imn_file",g_imm.imm01,g_imn_t.imn02,
                                SQLCA.sqlcode,"","upd imn",1)   #NO.FUN-640266 #No:FUN-660156
                  LET g_imn[l_ac].* = g_imn_t.*
               #FUN-B30187 --START--
                  LET g_success = 'N'
               ELSE
                  UPDATE imni_file SET * = b_imni.*
                   WHERE imni01=g_imm.imm01 AND imni02=g_imn_t.imn02
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('upd imni',SQLCA.sqlcode,0)
                     LET g_imn[l_ac].* = g_imn_t.*
                     LET g_success = 'N'                     
                  END IF
               END IF
               
               IF g_success = 'Y' THEN
                  CALL cl_msg('UPDATE O.K')
                  COMMIT WORK
                  LET l_act = 'u'   #FUN-920207
               END IF 
               #FUN-B30187 --END--
            END IF

        AFTER ROW
           LET l_ac = ARR_CURR()         # 新增
          #LET l_ac_t = l_ac             #FUN-D40030 Mark

           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'a' AND l_ac <= g_imn.getLength() THEN  #CHI-C30106---add
                SELECT ima918,ima921 INTO g_ima918,g_ima921 
                  FROM ima_file
                 WHERE ima01 = g_imn[l_ac].imn03
                   AND imaacti = "Y"
               
                IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                  #IF NOT s_lotout_del(g_prog,g_imm.imm01,g_imn[l_ac].imn02,0,g_imn[l_ac].imn03,'DEL') THEN   #No:FUN-860045  #TQC-B90236 mark
                   IF NOT s_lot_del(g_prog,g_imm.imm01,g_imn[l_ac].imn02,0,g_imn[l_ac].imn03,'DEL') THEN   #No:FUN-860045  #TQC-B90236 add
                      CALL cl_err3("del","rvbs_file",g_imm.imm01,g_imn_t.imn02,
                                    SQLCA.sqlcode,"","",1)
                   END IF
                  #IF NOT s_lotin_del(g_prog,g_imm.imm01,g_imn[l_ac].imn02,0,g_imn[l_ac].imn03,'DEL') THEN   #No:FUN-860045   #TQC-B90236 mark
                   IF NOT s_lot_del(g_prog,g_imm.imm01,g_imn[l_ac].imn02,0,g_imn[l_ac].imn03,'DEL') THEN   #No:FUN-860045   #TQC-B90236 add
                      CALL cl_err3("del","rvbs_file",g_imm.imm01,g_imn_t.imn02,
                                    SQLCA.sqlcode,"","",1)
                   END IF
                END IF
                #FUN-D40030--add--str--
                CALL g_imn.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
                #FUN-D40030--add--end--
              END IF  #CHI-C30106---add
              IF p_cmd='u' THEN
                 LET g_imn[l_ac].* = g_imn_t.*
              END IF
              CLOSE t324_bcl
              ROLLBACK WORK
              EXIT INPUT
           ELSE
           END IF
           #FUN-CB0087---add---str---
           IF g_aza.aza115 = 'Y' THEN
              IF NOT t324_imn28_chk1() THEN
                 NEXT FIELD imn28
              END IF
           END IF
           #FUN-CB0087---add---end---
           LET l_ac_t = l_ac             #FUN-D40030 Add
           CLOSE t324_bcl
           COMMIT WORK
           IF NOT cl_null(l_act) AND l_act MATCHES '[au]' THEN
              #FUN-BA0051 --START mark--           
              #LET l_imaicd08 = NULL                                           
              #SELECT l_imaicd08 INTO l_imaicd08 FROM imaicd_file                  
              # WHERE imaicd00 = g_imn[l_ac].imn03                                 
              #IF NOT cl_null(l_imaicd08) AND l_imaicd08 = 'Y' THEN 
              #FUN-BA0051 --END mark--
              IF s_icdbin(g_imn[l_ac].imn03) THEN   #FUN-BA0051 
                 IF cl_confirm('aic-311') THEN
                    LET g_dies = 0 
                    CALL s_icdout(g_imn[l_ac].imn03,g_imn[l_ac].imn04,
                                   g_imn[l_ac].imn05,g_imn[l_ac].imn06,
                                   g_imn[l_ac].imn09,g_imn[l_ac].imn10,
                                   g_imm.imm01,g_imn[l_ac].imn02,
                                   #g_imm.imm02,'Y',  #FUN-D40053
                                   g_imm.imm17,'Y',  #FUN-D40053
                                   g_imn[l_ac].imn15,g_imn[l_ac].imn16,
                                   g_imn[l_ac].imn17,g_imn[l_ac].imn20)
                     RETURNING g_dies,l_r,l_qty   #FUN-C30302
                     #FUN-C30302---begin
                     IF l_r = 'Y' THEN
                         LET l_qty = s_digqty(l_qty,g_imn[l_ac].imn09) 
                         LET g_imn[l_ac].imn10 = l_qty
                         LET g_imn[l_ac].imn22 = l_qty
                         LET g_imn[l_ac].imn32 = l_qty
                         LET g_imn[l_ac].imn42 = l_qty

                         UPDATE imn_file set imn10 = g_imn[l_ac].imn10,
                                             imn22 = g_imn[l_ac].imn22,
                                             imn32 = g_imn[l_ac].imn32,
                                             imn42 = g_imn[l_ac].imn42
                          WHERE imn01=g_imm.imm01 AND imn02=g_imn[l_ac].imn02
                         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                            LET g_imn[l_ac].imn10 = b_imn.imn10
                            LET g_imn[l_ac].imn22 = b_imn.imn22
                            LET g_imn[l_ac].imn32 = b_imn.imn32
                            LET g_imn[l_ac].imn42 = b_imn.imn42
                            LET g_success  = 'N'  
                         ELSE
                            LET b_imn.imn10 = g_imn[l_ac].imn10
                            LET b_imn.imn22 = g_imn[l_ac].imn22
                            LET b_imn.imn32 = g_imn[l_ac].imn32
                            LET b_imn.imn42 = g_imn[l_ac].imn42
                         END IF
                         DISPLAY BY NAME g_imn[l_ac].imn10, g_imn[l_ac].imn32,
                                         g_imn[l_ac].imn42, g_imn[l_ac].imn22
                                         
                         SELECT ima906 INTO l_ima906
                         FROM ima_file WHERE ima01 = g_imn[l_ac].imn03

                         IF l_ima906 = '1' THEN
                            LET g_imn[l_ac].imn35 = l_qty
                            LET g_imn[l_ac].imn45 = l_qty
                            
                            UPDATE imn_file set imn35 = g_imn[l_ac].imn35,
                                                imn45 = g_imn[l_ac].imn45
                             WHERE imn01=g_imm.imm01 AND imn02=g_imn[l_ac].imn02
                            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                               LET g_imn[l_ac].imn35 = b_imn.imn35
                               LET g_imn[l_ac].imn45 = b_imn.imn45
                               LET g_success  = 'N'  
                            ELSE
                               LET b_imn.imn35 = g_imn[l_ac].imn35
                               LET b_imn.imn45 = g_imn[l_ac].imn45
                            END IF
                            DISPLAY BY NAME g_imn[l_ac].imn35,g_imn[l_ac].imn45
                         END IF 
                     END IF 
                     #FUN-C30302---end
                    CALL t324_upd_dies() 
                 END IF
              END IF
           END IF

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

        ON ACTION regen_detail
           IF NOT cl_confirm('aim-148') THEN                                                                                              
              EXIT INPUT                                                                                                    
           END IF 
           CALL t324_del()
           CALL aimt324_g() 
           CALL t324_b_fill(" 1=1")
           EXIT INPUT

        ON ACTION gen_detail
           IF g_sma.sma115= 'N' THEN
              CALL t324_g1()
           ELSE
              CALL t324_g2()
           END IF
           EXIT INPUT

        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(imn02) AND l_ac > 1 THEN
              LET g_imn[l_ac].* = g_imn[l_ac-1].*
              LET g_imn[l_ac].imn02 = NULL
              NEXT FIELD imn02
           END IF

        ON ACTION controlp
           CASE
               WHEN INFIELD(att00)                                                                                                     
                  #可以新增子料件,開窗是單純的選取母料件                                                                               
#FUN-AA0059 --Begin--
                #  CALL cl_init_qry_var()                                                                                               
                #  LET g_qryparam.form ="q_ima_p"                                                                                       
                #  LET g_qryparam.arg1 = lg_group                                                                                       
                #  CALL cl_create_qry() RETURNING g_imn[l_ac].att00                                                                     
                  CALL q_sel_ima(FALSE, "q_ima_p", "", "", lg_group, "", "", "" ,"",'' )  RETURNING g_imn[l_ac].att00
#FUN-AA0059 --End--
                  DISPLAY BY NAME g_imn[l_ac].att00        #No:MOD-490371                                                              
                  NEXT FIELD att00

               WHEN INFIELD(imn03)
#FUN-AA0059 --Begin--
                 #    CALL cl_init_qry_var()
                 #    LET g_qryparam.form ="q_ima"
                 #    LET g_qryparam.default1 = g_imn[l_ac].imn03
                 #    CALL cl_create_qry() RETURNING g_imn[l_ac].imn03
                      CALL q_sel_ima(FALSE, "q_ima", "", g_imn[l_ac].imn03, "", "", "", "" ,"",'' )  RETURNING g_imn[l_ac].imn03
#FUN-AA0059 --End--
                      DISPLAY BY NAME g_imn[l_ac].imn03  #No:MOD-490371
                     NEXT FIELD imn03
                WHEN INFIELD(imn04) OR INFIELD(imn05) OR INFIELD(imn06)
                   CALL q_img4(FALSE,TRUE,g_imn[l_ac].imn03,g_imn[l_ac].imn04, #FUN-960065   
                                   g_imn[l_ac].imn05,g_imn[l_ac].imn06,'A')
                      RETURNING    g_imn[l_ac].imn04,
                                   g_imn[l_ac].imn05,g_imn[l_ac].imn06
                   DISPLAY g_imn[l_ac].imn04 TO imn04
                   DISPLAY g_imn[l_ac].imn05 TO imn05
                   DISPLAY g_imn[l_ac].imn06 TO imn06                 
                   
                   CALL t324_def_imniicd029()   #FUN-B30187
                   #FUN-BC0036 --START--
                   IF g_argv0 = '2' THEN
                      LET g_imn[l_ac].imn15=g_imn[l_ac].imn04
                      LET g_imn[l_ac].imn16=g_imn[l_ac].imn05
                      LET g_imn[l_ac].imn17=g_imn[l_ac].imn06
                      DISPLAY BY NAME g_imn[l_ac].imn15
                      DISPLAY BY NAME g_imn[l_ac].imn16
                      DISPLAY BY NAME g_imn[l_ac].imn17                      
                   END IF   
                   #FUN-BC0036 --END--
                   IF cl_null(g_imn[l_ac].imn05) THEN LET g_imn[l_ac].imn05 = ' ' END IF
                   IF cl_null(g_imn[l_ac].imn06) THEN LET g_imn[l_ac].imn06 = ' ' END IF
                   IF INFIELD(imn04) THEN NEXT FIELD imn04 END IF
                   IF INFIELD(imn05) THEN NEXT FIELD imn05 END IF
                   IF INFIELD(imn06) THEN NEXT FIELD imn06 END IF
                WHEN INFIELD(imn15) OR INFIELD(imn16) OR INFIELD(imn17)
                   CALL q_img4(FALSE,FALSE,g_imn[l_ac].imn03,g_imn[l_ac].imn15,
                                   g_imn[l_ac].imn16,g_imn[l_ac].imn17,'A')
                      RETURNING    g_imn[l_ac].imn15,
                                   g_imn[l_ac].imn16,g_imn[l_ac].imn17
                   DISPLAY g_imn[l_ac].imn15 TO imn15
                   DISPLAY g_imn[l_ac].imn16 TO imn16
                   DISPLAY g_imn[l_ac].imn17 TO imn17
                   IF cl_null(g_imn[l_ac].imn16) THEN LET g_imn[l_ac].imn16 = ' ' END IF
                   IF cl_null(g_imn[l_ac].imn17) THEN LET g_imn[l_ac].imn17 = ' ' END IF
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
                   CALL s_get_where(g_imm.imm01,'','',g_imn[l_ac].imn03,l_store,g_imm.imm16,g_imm.imm14) RETURNING l_flag,l_where
                   IF l_flag AND g_aza.aza115 = 'Y' THEN
                      CALL cl_init_qry_var()
                      LET g_qryparam.form     ="q_ggc08"
                      LET g_qryparam.where = l_where
                      LET g_qryparam.default1 = g_imn[l_ac].imn28
                   ELSE
                   #FUN-CB0087---add---end---
                    CALL cl_init_qry_var()
                    LET g_qryparam.form     = "q_azf01a"         #FUN-920186
                    LET g_qryparam.default1 = g_imn[l_ac].imn28
                    LET g_qryparam.arg1     = "6"             #FUN-920186
                   END IF                                    #FUN-CB0087--add
                    CALL cl_create_qry() RETURNING g_imn[l_ac].imn28
                    CALL t324_azf03()                        #FUN-CB0087--add
                     DISPLAY BY NAME g_imn[l_ac].imn28   #No:MOD-490371
                    NEXT FIELD imn28
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

      ON ACTION q_imd    #查詢倉庫
         CALL cl_init_qry_var()
         LET g_qryparam.form ="q_imd"
         CASE l_warehouse
            WHEN "1"
                 LET g_qryparam.default1 = g_imn[l_ac].imn04
                 LET g_qryparam.arg1 = 'SW'        #倉庫類別
                 CALL cl_create_qry() RETURNING g_imn[l_ac].imn04
                 NEXT FIELD imn04
            WHEN "2"
                 LET g_qryparam.default1 = g_imn[l_ac].imn15
                 LET g_qryparam.arg1 = 'SW'        #倉庫類別
                 CALL cl_create_qry() RETURNING g_imn[l_ac].imn15
                 NEXT FIELD imn15
            OTHERWISE
                 LET g_qryparam.arg1 = 'SW'        #倉庫類別
                 CALL cl_create_qry() RETURNING g_msg
         END CASE

     #str CHI-A30004 add
      ON ACTION q_ime    #查詢倉庫儲位
         CALL cl_init_qry_var()
         LET g_qryparam.form ="q_ime1"
         CASE l_warehouse
            WHEN "1"
                 LET g_qryparam.arg1     = 'SW'        #倉庫類別
                 LET g_qryparam.default1 = g_imn[l_ac].imn04
                 LET g_qryparam.default2 = g_imn[l_ac].imn05
                 CALL cl_create_qry() RETURNING g_imn[l_ac].imn04,g_imn[l_ac].imn05
                 NEXT FIELD imn04
            WHEN "2"
                 LET g_qryparam.arg1     = 'SW'        #倉庫類別
                 LET g_qryparam.default1 = g_imn[l_ac].imn15
                 LET g_qryparam.default2 = g_imn[l_ac].imn16
                 CALL cl_create_qry() RETURNING g_imn[l_ac].imn15,g_imn[l_ac].imn16
                 NEXT FIELD imn15
            OTHERWISE
                 LET g_qryparam.arg1 = 'SW'        #倉庫類別
                 CALL cl_create_qry() RETURNING g_msg,g_msg1
         END CASE
     #end CHI-A30004 add

      ON ACTION mntn_reason #理由
                   CALL cl_cmdrun("aooi301")
      ON ACTION mntn_stock #建立倉庫別
                   LET g_cmd = 'aimi200 x'
                   CALL cl_cmdrun(g_cmd)
      ON ACTION mntn_loc  #建立儲位別
                   LET g_cmd = "aimi201 '",g_imn[l_ac].imn16,"'" #BugNo:6598
                   CALL cl_cmdrun(g_cmd)

      ON ACTION qry_tro_imf #預設倉庫/ 儲位
                CASE
                   WHEN INFIELD(imn04)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form     = "q_imf"
                        LET g_qryparam.default1 = g_imn[l_ac].imn04
                        LET g_qryparam.default2 = g_imn[l_ac].imn05
                        LET g_qryparam.arg1     = g_imn[l_ac].imn03
                        LET g_qryparam.arg2     = "A"
                        CALL cl_create_qry() RETURNING g_imn[l_ac].imn04,g_imn[l_ac].imn05
                        NEXT FIELD imn04
                   WHEN INFIELD(imn15)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form     = "q_imf"
                        LET g_qryparam.default1 = g_imn[l_ac].imn15
                        LET g_qryparam.default2 = g_imn[l_ac].imn16
                        LET g_qryparam.arg1     = g_imn[l_ac].imn03
                        LET g_qryparam.arg2     = "A"
                        CALL cl_create_qry() RETURNING g_imn[l_ac].imn15,g_imn[l_ac].imn16
                        NEXT FIELD imn15
                END CASE

        ON ACTION modi_lot
           SELECT ima918,ima921 INTO g_ima918,g_ima921 
             FROM ima_file
            WHERE ima01 = g_imn[l_ac].imn03
              AND imaacti = "Y"
           
           IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
            #MOD-C10046 ----- start -----
                  IF g_imn[l_ac].imn02 != g_imn02_o THEN
                     LET l_cnt = 0
                     SELECT COUNT(*) INTO l_cnt FROM rvbs_file
                      WHERE rvbs01 = g_imm.imm01 AND rvbs02 = g_imn02_o
                     IF l_cnt > 0 THEN
                        UPDATE rvbs_file SET rvbs02 =  g_imn[l_ac].imn02
                         WHERE rvbs01 = g_imm.imm01 AND rvbs02 = g_imn02_o
                        IF SQLCA.sqlcode THEN
                           CALL cl_err3("upd","rvbs_file",g_imn[l_ac].imn02,"",SQLCA.sqlcode,"","",1)
                        ELSE
                           LET g_imn02_o = g_imn[l_ac].imn02
                        END IF
                     END IF
                  END IF
            #MOD-C10046 -----  end  -----
             #CALL s_lotout(g_prog,g_imm.imm01,g_imn[l_ac].imn02,0,     #TQC-B90236 mark
              CALL s_mod_lot(g_prog,g_imm.imm01,g_imn[l_ac].imn02,0,     #TQC-B90236 add
                            g_imn[l_ac].imn03,g_imn[l_ac].imn04,
                            g_imn[l_ac].imn05,g_imn[l_ac].imn06,
                            g_imn[l_ac].imn09,g_imn[l_ac].imn09,1,
                            g_imn[l_ac].imn10,'','MOD',-1)#CHI-9A0022 add ''   #TQC-B90236 add '-1'
                     RETURNING l_r,g_qty 
              IF l_r = "Y" THEN
                 LET g_imn[l_ac].imn10 = g_qty
              END IF
              
              CALL t324_ins_rvbs()   #No:FUN-860045
           END IF

         ON ACTION aic_s_icdqry_in    #單據刻號/BIN入庫查詢作業
            IF NOT cl_null(g_imn[l_ac].imn02) THEN
               CALL s_icdqry(1,g_imm.imm01,g_imn[l_ac].imn02,g_imm.imm03,
                           g_imn[l_ac].imn03)
            END IF

          ON ACTION aic_s_icdqry_out  #單據刻號/BIN出庫查詢作業
             IF NOT cl_null(g_imn[l_ac].imn02) THEN
                CALL s_icdqry(-1,g_imm.imm01,g_imn[l_ac].imn02,g_imm.imm03,
                            g_imn[l_ac].imn03)
             END IF
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
    LET g_imm.imm15 = '0' #FUN-A60034 add
    UPDATE imm_file 
       SET immmodu=g_imm.immmodu,
           immdate=g_imm.immdate,
           imm15=g_imm.imm15 #FUN-A60034 add
     #WHERE imm01=g_imm.imm01 AND imm10='1'      #FUN-BC0036 mark
     WHERE imm01=g_imm.imm01 AND imm10=g_imm10   #FUN-BC0036 
    DISPLAY BY NAME g_imm.immmodu,g_imm.immdate,g_imm.imm15 #FUN-A60034 add imm15

    SELECT COUNT(*) INTO g_cnt FROM imn_file WHERE imn01=g_imm.imm01 

    CLOSE t324_bcl
    COMMIT WORK
#   CALL i000_delall() #No.FUN-870100   #CHI-C30002 mark
    CALL t324_delHeader()     #CHI-C30002 add
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION t324_delHeader()
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
      PREPARE t324_pb1 FROM l_sql 
      EXECUTE t324_pb1 INTO l_cnt      
      
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
         #CALL t324_x() #CHI-D20008
         CALL t324_x(1) #CHI-D20008
         IF g_imm.immconf = 'X' THEN
            LET g_void = 'Y'
         ELSE
            LET g_void = 'N'
         END IF
         CALL cl_set_field_pic(g_imm.immconf,"",g_imm.imm03,"",g_void,"")
      END IF 
      
      IF l_cho = 3 THEN     
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM imm_file WHERE imm01 = g_imm.imm01
         INITIALIZE g_imm.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#FUN-B90035 ---------------------Begin------------------------
FUNCTION t324_b_imn06_inschk(p_cmd)
DEFINE l_ima159    LIKE ima_file.ima159
DEFINE l_img10     LIKE img_file.img10
DEFINE p_cmd       LIKE type_file.chr1
   IF cl_null(g_imn[l_ac].imn06) THEN
      LET g_imn[l_ac].imn06=' '
   END IF
   LET l_ima159 = ''
   SELECT ima159 INTO l_ima159 FROM ima_file
    WHERE ima01 = g_imn[l_ac].imn03
   IF l_ima159 = '1' THEN
      IF cl_null(g_imn[l_ac].imn06) THEN
         CALL cl_err(g_imn[l_ac].imn06,'aim-034',1)
         RETURN "imn06"
      END IF
   END IF
   #FUN-C30302---begin mark
   #IF s_industry('icd') THEN
   #   IF g_imn[l_ac].imn17 <>  g_imn[l_ac].imn06 THEN
   #      CALL cl_err(g_imn[l_ac].imn17,'aim-035',1)
   #      RETURN "imn06"
   #   END IF
   #END IF  
   #FUN-C30302---end
   IF p_cmd = 'u' THEN 
     IF g_imn_t.imn06 IS NULL THEN LET g_imn_t.imn06 = ' ' END IF
     IF g_imn_t.imn06 <> g_imn[l_ac].imn06 THEN
        CALL t324_chk_icd()
        IF NOT cl_null(g_errno) THEN
           CALL cl_err('',g_errno,0)
           LET g_imn[l_ac].imn06 = g_imn_t.imn06
           RETURN "imn06"
        END IF
      END IF
   END IF
   IF NOT s_icdout_holdlot(g_imn[l_ac].imn03,g_imn[l_ac].imn04,
                           g_imn[l_ac].imn05,g_imn[l_ac].imn06) THEN
      RETURN "imn06"
   END IF
   SELECT img09,img10  INTO g_img09_s,g_img10_s FROM img_file
    WHERE img01=g_imn[l_ac].imn03 AND
          img02=g_imn[l_ac].imn04 AND
          img03=g_imn[l_ac].imn05 AND
          img04=g_imn[l_ac].imn06
   IF SQLCA.sqlcode THEN
       LET l_img10 = 0
      #CALL cl_err3("sel","img_file",g_imn[l_ac].imn03,"",  #FUN-C80107 mark 121024
      #              "mfg6101","","",1)                     #FUN-C80107 mark 121024
      #RETURN "imn04"                                       #FUN-C80107 mark 121024
       #FUN-C80107 add begin--------------------------------------------121024
#FUN-D30024 ------------Begin------------
      #INITIALIZE g_sma894 TO NULL
      #CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_imn[l_ac].imn04) RETURNING g_sma894 #FUN-D30024
      #IF g_sma894 = 'N' OR g_sma894 IS NULL THEN
       INITIALIZE g_imd23 TO NULL
       CALL s_inv_shrt_by_warehouse(g_imn[l_ac].imn04,g_plant) RETURNING g_imd23                   #FUN-D30024 #TQC-D40078 g_plant
       IF g_imd23 = 'N' OR g_imd23 IS NULL THEN
#FUN-D30024 ------------End--------------
          CALL cl_err3("sel","img_file",g_imn[l_ac].imn03,"",
                       "mfg6101","","",1)
          RETURN "imn04"
       ELSE
          IF g_sma.sma892[3,3] = 'Y' THEN
             IF NOT cl_confirm('mfg1401') THEN RETURN "imn04" END IF
          END IF
          CALL s_add_img(g_imn[l_ac].imn03,g_imn[l_ac].imn04,
                         g_imn[l_ac].imn05,g_imn[l_ac].imn06,
                         g_imm.imm01      ,g_imn[l_ac].imn02,
                         #g_imm.imm02)  #FUN-D40053
                         g_imm.imm17)  #FUN-D40053
          IF g_errno='N' THEN
             RETURN "imn04"
          END IF
          SELECT img09,img10  INTO g_img09_s,g_img10_s FROM img_file
           WHERE img01=g_imn[l_ac].imn03 AND
                 img02=g_imn[l_ac].imn04 AND
                 img03=g_imn[l_ac].imn05 AND
                 img04=g_imn[l_ac].imn06
       END IF
       #FUN-C80107 add end----------------------------------------------
   END IF
   LET g_imn[l_ac].imn09=g_img09_s
   DISPLAY BY NAME g_imn[l_ac].imn09
   LET l_img10=g_img10_s
  #MOD-CA0009---mark---S
  ##-->有效日期
  #IF NOT s_actimg(g_imn[l_ac].imn03,g_imn[l_ac].imn04,
  #                g_imn[l_ac].imn05,g_imn[l_ac].imn06)
  #THEN CALL cl_err('inactive','mfg6117',1) 
  #     RETURN "imn04"
  #END IF
  #MOD-CA0009---mark---E
   IF p_cmd = 'u' THEN
      CALL t324_chk_out() RETURNING g_i
      IF g_i THEN
         RETURN "imn06"
      END IF
   END IF
   IF g_sma.sma115 = 'Y' THEN
      IF g_imn_t.imn03 IS NULL OR g_imn[l_ac].imn03 <> g_imn_t.imn03 OR
         g_imn_t.imn04 IS NULL OR g_imn[l_ac].imn04 <> g_imn_t.imn04 OR
         g_imn_t.imn05 IS NULL OR g_imn[l_ac].imn05 <> g_imn_t.imn05 OR
         g_imn_t.imn06 IS NULL OR g_imn[l_ac].imn06 <> g_imn_t.imn06 THEN
         CALL t324_du_default(p_cmd,g_imn[l_ac].imn03,g_imn[l_ac].imn04,
                             g_imn[l_ac].imn05,g_imn[l_ac].imn06)
              RETURNING g_imn[l_ac].imn33,g_imn[l_ac].imn34,g_imn[l_ac].imn35,
                        g_imn[l_ac].imn30,g_imn[l_ac].imn31,g_imn[l_ac].imn32
         DISPLAY BY NAME g_imn[l_ac].imn33
         DISPLAY BY NAME g_imn[l_ac].imn34
         DISPLAY BY NAME g_imn[l_ac].imn35
         DISPLAY BY NAME g_imn[l_ac].imn30
         DISPLAY BY NAME g_imn[l_ac].imn31
         DISPLAY BY NAME g_imn[l_ac].imn32
      END IF
   END IF
   LET g_imn_t.imn06=g_imn[l_ac].imn06
   CALL t324_def_imniicd029()   
   RETURN NULL
END FUNCTION

FUNCTION t324_b_imn17_inschk(p_cmd)
DEFINE l_ima159     LIKE ima_file.ima159 
DEFINE p_cmd        LIKE type_file.chr1
DEFINE l_factor     LIKE imn_file.imn41 
DEFINE l_ima906     LIKE ima_file.ima906
DEFINE l_cnt        LIKE type_file.num5
DEFINE l_img10      LIKE img_file.img10
DEFINE l_img09      LIKE img_file.img09
DEFINE l_date       LIKE type_file.dat         #CHI-C50010 add
DEFINE l_img37      LIKE img_file.img37        #CHI-C80007 add

   IF cl_null(g_imn[l_ac].imn15) THEN
      CALL cl_err('','aim-145',1)
       RETURN "imn15"
   END IF
   #BugNo:5626 控管是否為全型空白
   IF g_imn[l_ac].imn17 = '　' THEN #全型空白
       LET g_imn[l_ac].imn17 = ' '
   END IF
   IF cl_null(g_imn[l_ac].imn17) THEN
      LET g_imn[l_ac].imn17 = ' '
   END IF
   IF p_cmd = 'u' THEN 
      IF cl_null(g_imn_t.imn17) THEN LET g_imn_t.imn17 = ' ' END IF
      IF g_imn_t.imn17 <> g_imn[l_ac].imn17 THEN
         CALL t324_chk_icd()
         IF NOT cl_null(g_errno) THEN
            CALL cl_err('',g_errno,0)
            LET g_imn[l_ac].imn17 = g_imn_t.imn17
            RETURN "imn17"
         END IF
       END IF
   END IF
   IF g_imn[l_ac].imn04=g_imn[l_ac].imn15 AND
      g_imn[l_ac].imn05=g_imn[l_ac].imn16 THEN
      IF ( g_imn[l_ac].imn06=g_imn[l_ac].imn17) OR
         ( g_imn[l_ac].imn06 IS NULL AND g_imn[l_ac].imn17 IS NULL) THEN
          CALL cl_err('','mfg6103',0)
          RETURN "imn17"
      END IF
   END IF
   IF cl_null(g_imn[l_ac].imn05) THEN LET g_imn[l_ac].imn05 =' ' END IF
   IF cl_null(g_imn[l_ac].imn06) THEN LET g_imn[l_ac].imn06 =' ' END IF
   LET l_ima159 = ''
   SELECT ima159 INTO l_ima159 FROM ima_file
    WHERE ima01 = g_imn[l_ac].imn03 
   IF l_ima159 = '1' THEN
      IF cl_null(g_imn[l_ac].imn17) THEN
         CALL cl_err(g_imn[l_ac].imn17,'aim-034',1)
         RETURN "imn17" 
      END IF      
   END IF
   #MOD-C30526---begin mark
   #IF s_industry('icd') THEN
   #   IF g_imn[l_ac].imn17 <>  g_imn[l_ac].imn06 THEN
   #      CALL cl_err(g_imn[l_ac].imn17,'aim-035',1)
   #       RETURN "imn17"
   #   END IF
   #END IF
   #MOD-C30526---end
   IF cl_null(g_imn[l_ac].imn09) THEN
      SELECT img09 INTO g_imn[l_ac].imn09 FROM img_file
       WHERE img01=g_imn[l_ac].imn03 AND
             img02=g_imn[l_ac].imn04 AND
             img03=g_imn[l_ac].imn05 AND
             img04=g_imn[l_ac].imn06
      IF SQLCA.sqlcode THEN
          #CALL cl_err3("sel","img_file",g_imn[l_ac].imn03,"",  #FUN-C80107 mark 121024
          #             "mfg6101","","",1)                      #FUN-C80107 mark 121024
          #RETURN "imn04"                                       #FUN-C80107 mark 121024
          #FUN-C80107 add begin--------------------------------------------121024
      #FUN-D30024 --------Begin---------
      #   INITIALIZE g_sma894 TO NULL
      #   CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_imn[l_ac].imn04) RETURNING g_sma894  #FUN-D30024
      #   IF g_sma894 = 'N' OR g_sma894 IS NULL THEN
          INITIALIZE g_imd23 TO NULL
          CALL s_inv_shrt_by_warehouse(g_imn[l_ac].imn04,g_plant) RETURNING g_imd23    #FUN-D30024  #TQC-D40078 g_plant
          IF g_imd23 = 'N' OR g_imd23 IS NULL THEN
      #FUN-D30024 --------End-----------
             CALL cl_err3("sel","img_file",g_imn[l_ac].imn03,"",
                       "mfg6101","","",1)
             RETURN "imn04"
          ELSE
             IF g_sma.sma892[3,3] = 'Y' THEN
                IF NOT cl_confirm('mfg1401') THEN RETURN "imn04" END IF
             END IF
             CALL s_add_img(g_imn[l_ac].imn03,g_imn[l_ac].imn04,
                            g_imn[l_ac].imn05,g_imn[l_ac].imn06,
                            g_imm.imm01      ,g_imn[l_ac].imn02,
                            #g_imm.imm02)  #FUN-D40053
                            g_imm.imm17)  #FUN-D40053
             IF g_errno='N' THEN
                RETURN "imn04"
             END IF
             SELECT img09 INTO g_imn[l_ac].imn09 FROM img_file
              WHERE img01=g_imn[l_ac].imn03 AND
                    img02=g_imn[l_ac].imn04 AND
                    img03=g_imn[l_ac].imn05 AND
                    img04=g_imn[l_ac].imn06
          END IF
          #FUN-C80107 add end----------------------------------------------
      END IF
   END IF
   SELECT *
     FROM img_file WHERE img01=g_imn[l_ac].imn03 AND
                         img02=g_imn[l_ac].imn15 AND
                         img03=g_imn[l_ac].imn16 AND
                         img04=g_imn[l_ac].imn17
   IF SQLCA.sqlcode THEN
      IF g_sma.sma892[3,3] = 'Y' THEN
         IF NOT cl_confirm('mfg1401') THEN RETURN "imn15" END IF
      END IF
      IF g_imn[l_ac].imn05 IS NULL THEN LET g_imn[l_ac].imn05 =' ' END IF   #MOD-CB0122 add
      IF g_imn[l_ac].imn06 IS NULL THEN LET g_imn[l_ac].imn06 =' ' END IF   #MOD-CB0122 add
        #CHI-C50010 str add-----
        #SELECT img18 INTO l_date FROM img_file                #CHI-C80007 mark
         SELECT img18,img37 INTO l_date,l_img37 FROM img_file  #CHI-C80007 add img37
          WHERE img01 = g_imn[l_ac].imn03
            AND img02 = g_imn[l_ac].imn04
            AND img03 = g_imn[l_ac].imn05
            AND img04 = g_imn[l_ac].imn06
        #MOD-CB0122 add---S
         IF STATUS=100 THEN
            CALL cl_err('','mfg6101',1)
            RETURN "imn17"                       
         ELSE 
        #MOD-CB0122 add---E
            CALL s_date_record(l_date,'Y')
         END IF     #MOD-CB0122 add
        #CHI-C50010 end add-----
         CALL s_idledate_record(l_img37)  #CHI-C80007 add
         CALL s_add_img(g_imn[l_ac].imn03,g_imn[l_ac].imn15,
                        g_imn[l_ac].imn16,g_imn[l_ac].imn17,
                        g_imm.imm01      ,g_imn[l_ac].imn02,
                        #g_imm.imm02)  #FUN-D40053
                        g_imm.imm17)  #FUN-D40053
      IF g_errno='N' THEN
          RETURN "imn17"
      END IF
      SELECT img09 INTO g_imn[l_ac].imn20
        FROM img_file WHERE img01=g_imn[l_ac].imn03 AND
                            img02=g_imn[l_ac].imn15 AND
                            img03=g_imn[l_ac].imn16 AND
                            img04=g_imn[l_ac].imn17
      DISPLAY BY NAME g_imn[l_ac].imn20
      CALL s_umfchk(g_imn[l_ac].imn03,g_imn[l_ac].imn09,g_imn[l_ac].imn20)
                    RETURNING g_cnt,g_imn[l_ac].imn21
      IF g_cnt = 1 THEN
          CALL cl_err('','mfg3075',1)
          RETURN "imn17"
      END IF
   ELSE
      SELECT img09  INTO g_imn[l_ac].imn20
        FROM img_file WHERE img01=g_imn[l_ac].imn03 AND
                            img02=g_imn[l_ac].imn15 AND
                            img03=g_imn[l_ac].imn16 AND
                            img04=g_imn[l_ac].imn17
      CALL s_umfchk(g_imn[l_ac].imn03,
                    g_imn[l_ac].imn09,g_imn[l_ac].imn20)
               RETURNING g_cnt,g_imn[l_ac].imn21
               DISPLAY BY NAME g_imn[l_ac].imn20
               DISPLAY BY NAME g_imn[l_ac].imn21
      IF g_cnt = 1 THEN
         CALL cl_err('','mfg3075',1)
         RETURN "imn17"
      END IF
   END IF 
   IF g_imn[l_ac].imn04 = g_imn[l_ac].imn15 AND
      g_imn[l_ac].imn05 = g_imn[l_ac].imn16 AND
      g_imn[l_ac].imn06 = g_imn[l_ac].imn17
   THEN CALL cl_err('','mfg9090',1)
         RETURN "imn15"
   END IF
  #MOD-CA0009---mark---S
  #IF NOT s_actimg(g_imn[l_ac].imn03,g_imn[l_ac].imn15,
  #                g_imn[l_ac].imn16,g_imn[l_ac].imn17)
  #THEN CALL cl_err('inactive','mfg6117',0)
  #      RETURN "imn15"
  #END IF
  #MOD-CA0009---mark---E
   LET g_imn[l_ac].imn22=g_imn[l_ac].imn10*g_imn[l_ac].imn21
   DISPLAY BY NAME g_imn[l_ac].imn22
   SELECT img09,img10  INTO g_img09_t,g_img10_t FROM img_file
    WHERE img01=g_imn[l_ac].imn03 AND
          img02=g_imn[l_ac].imn15 AND
          img03=g_imn[l_ac].imn16 AND
          img04=g_imn[l_ac].imn17
   IF SQLCA.sqlcode THEN
      LET l_img10 = 0
      #CALL cl_err3("sel","img_file",g_imn[l_ac].imn03,g_imn[l_ac].imn15,  #FUN-C80107 mark 121024
      #             "mfg6101","","",1)  #No:FUN-660156  #FUN-C80107 mark 121024
      #RETURN "imn15"                                   #FUN-C80107 mark 121024
      #FUN-C80107 add begin--------------------------------------------121024
      IF g_sma.sma892[3,3] = 'Y' THEN
         IF NOT cl_confirm('mfg1401') THEN
            RETURN "imn15"
         END IF
      END IF
      CALL s_add_img(g_imn[l_ac].imn03,g_imn[l_ac].imn15,
                     g_imn[l_ac].imn16,g_imn[l_ac].imn17,
                     g_imm.imm01      ,g_imn[l_ac].imn02,
                     #g_imm.imm02)  #FUN-D40053
                     g_imm.imm17)  #FUN-D40053
      IF g_errno='N' THEN
         RETURN "imn15"
      END IF
      SELECT img09,img10  INTO g_img09_t,g_img10_t FROM img_file
       WHERE img01=g_imn[l_ac].imn03 AND
             img02=g_imn[l_ac].imn15 AND
             img03=g_imn[l_ac].imn16 AND
             img04=g_imn[l_ac].imn17
      #FUN-C80107 add end----------------------------------------------
   END IF
   LET g_imn_t.imn17=g_imn[l_ac].imn17
   IF p_cmd = 'u' THEN
      CALL t324_chk_in() RETURNING g_i
      IF g_i THEN
          RETURN "imn17"
      END IF
   END IF
   IF NOT t324_set_imn40() THEN
      RETURN "imn15"
   END IF

   IF NOT t324_set_imn43() THEN
      RETURN "imn15"
   END IF
   SELECT ima906 INTO l_ima906 FROM ima_file 
           WHERE ima01 = g_imn[l_ac].imn03
   IF g_sma.sma115 = 'Y' AND l_ima906 != '2' THEN
      SELECT img09 INTO l_img09 FROM img_file 
           WHERE img01 = g_imn[l_ac].imn03
             AND img02 = g_imn[l_ac].imn15
             AND img03 = g_imn[l_ac].imn16
             AND img04 = g_imn[l_ac].imn17
    
      LET l_factor = 1   #MOD-BA0129 add
      IF NOT cl_null(l_img09) AND g_imn[l_ac].imn40 != l_img09 THEN 
         CALL s_umfchk(g_imn[l_ac].imn03,g_imn[l_ac].imn40,l_img09)
              RETURNING l_cnt,l_factor
         
         IF l_cnt = 1 THEN LET l_factor = 1 END IF
         LET g_imn[l_ac].imn41 = l_factor
      END IF
      IF l_ima906='3' THEN
         LET g_imn[l_ac].imn40 = g_imn[l_ac].imn20
         LET g_imn[l_ac].imn42 = g_imn[l_ac].imn32 * l_factor
      END IF
     #MOD-CB0118 str add---
      IF l_ima906='1' AND g_sma.sma115 = 'Y'THEN
         LET g_imn[l_ac].imn40 = g_imn[l_ac].imn20
         LET g_imn[l_ac].imn42 = g_imn[l_ac].imn32 * l_factor
         LET g_imn[l_ac].imn51 = l_factor
      END IF
     #MOD-CB0118 end add-----
   END IF
   RETURN NULL
END FUNCTION

FUNCTION t324_set_no_required_1()
   CALL cl_set_comp_required("imn06,imn17",FALSE)
END FUNCTION

FUNCTION t324_set_required_1(p_cmd)
DEFINE  l_ima159  LIKE ima_file.ima159  
DEFINE  p_cmd     LIKE type_file.chr1
   IF p_cmd='u' OR INFIELD(imn03) THEN
      IF NOT cl_null(g_imn[l_ac].imn03) THEN
         SELECT ima159 INTO l_ima159 FROM ima_file
          WHERE ima01  = g_imn[l_ac].imn03
         IF l_ima159 = '1' THEN
            CALL cl_set_comp_required("imn06,imn17",TRUE)
         END IF
      END IF
   END IF
END FUNCTION

FUNCTION t324_set_no_entry_imn()
DEFINE l_ima159    LIKE ima_file.ima159
   IF l_ac > 0 THEN
      IF NOT cl_null(g_imn[l_ac].imn03) THEN
         SELECT ima159 INTO l_ima159 FROM ima_file
          WHERE ima01  = g_imn[l_ac].imn03
         IF l_ima159 = '2' THEN
            LET g_imn[l_ac].imn06 = ' '
            LET g_imn[l_ac].imn17 = ' '
            CALL cl_set_comp_entry("imn06,imn17",FALSE)
         ELSE
            CALL cl_set_comp_entry("imn06,imn17",TRUE)
         END IF
      END IF
      #FUN-BC0036 --START--
      IF g_argv0 = '2' THEN   
         CALL cl_set_comp_entry("imn15,imn16,imn17",FALSE)         
      END IF  
      #FUN-BC0036 --END-- 
   END IF
END FUNCTION

FUNCTION t324_set_entry_imn()
   CALL cl_set_comp_entry("imn06,imn17",TRUE)
END FUNCTION
#FUN-B90035 ---------------------End--------------------------
 
FUNCTION t324_b_move_to()
        LET g_imn[l_ac].imn02=b_imn.imn02
        LET g_imn[l_ac].imn03=b_imn.imn03
        LET g_imn[l_ac].imn29=b_imn.imn29    #No.FUN-5C0077
        LET g_imn[l_ac].imn28=b_imn.imn28
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
        LET b_imn.imnplant=g_imm.immplant  #FUN-870100
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
        LET g_imn[l_ac].imnud01 = b_imn.imnud01
        LET g_imn[l_ac].imnud02 = b_imn.imnud02
        LET g_imn[l_ac].imnud03 = b_imn.imnud03
        LET g_imn[l_ac].imnud04 = b_imn.imnud04
        LET g_imn[l_ac].imnud05 = b_imn.imnud05
        LET g_imn[l_ac].imnud06 = b_imn.imnud06
        LET g_imn[l_ac].imnud07 = b_imn.imnud07
        LET g_imn[l_ac].imnud08 = b_imn.imnud08
        LET g_imn[l_ac].imnud09 = b_imn.imnud09
        LET g_imn[l_ac].imnud10 = b_imn.imnud10
        LET g_imn[l_ac].imnud11 = b_imn.imnud11
        LET g_imn[l_ac].imnud12 = b_imn.imnud12
        LET g_imn[l_ac].imnud13 = b_imn.imnud13
        LET g_imn[l_ac].imnud14 = b_imn.imnud14
        LET g_imn[l_ac].imnud15 = b_imn.imnud15
        LET g_imn[l_ac].imniicd028 = b_imni.imniicd028 #FUN-B30187
        LET g_imn[l_ac].imniicd029 = b_imni.imniicd029 #FUN-B30187
END FUNCTION
 
FUNCTION t324_b_move_back()
        LET b_imn.imn02=g_imn[l_ac].imn02
        LET b_imn.imn03=g_imn[l_ac].imn03
        LET b_imn.imn29=g_imn[l_ac].imn29   #No.FUN-5C0077
        LET b_imn.imn28=g_imn[l_ac].imn28
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
        LET b_imn.imn26=''
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
        LET b_imn.imnplant = g_plant #FUN-980004 add
        LET b_imn.imnlegal = g_legal #FUN-980004 add
        LET b_imn.imn9301=g_imn[l_ac].imn9301 #FUN-670093
        LET b_imn.imn9302=g_imn[l_ac].imn9302 #FUN-670093
        LET b_imn.imnud01 = g_imn[l_ac].imnud01
        LET b_imn.imnud02 = g_imn[l_ac].imnud02
        LET b_imn.imnud03 = g_imn[l_ac].imnud03
        LET b_imn.imnud04 = g_imn[l_ac].imnud04
        LET b_imn.imnud05 = g_imn[l_ac].imnud05
        LET b_imn.imnud06 = g_imn[l_ac].imnud06
        LET b_imn.imnud07 = g_imn[l_ac].imnud07
        LET b_imn.imnud08 = g_imn[l_ac].imnud08
        LET b_imn.imnud09 = g_imn[l_ac].imnud09
        LET b_imn.imnud10 = g_imn[l_ac].imnud10
        LET b_imn.imnud11 = g_imn[l_ac].imnud11
        LET b_imn.imnud12 = g_imn[l_ac].imnud12
        LET b_imn.imnud13 = g_imn[l_ac].imnud13
        LET b_imn.imnud14 = g_imn[l_ac].imnud14
        LET b_imn.imnud15 = g_imn[l_ac].imnud15
        LET b_imni.imniicd028 = g_imn[l_ac].imniicd028 #FUN-B30187
        LET b_imni.imniicd029 = g_imn[l_ac].imniicd029 #FUN-B30187

END FUNCTION
 
FUNCTION t324_b_askkey()
DEFINE l_wc2           LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(200)

    CONSTRUCT l_wc2 ON imn03,imn29,imn28,imn04,imn05,imn17,imn09,imn10,   #No.FUN-5C0077
                       imn33,imn34,imn35,imn30,imn31,imn32,
                       imn15,imn16,imn17,imn20,
                       imn43,imn44,imn45,imn40,imn41,imn42,
                       imn22,imn21,
                       imn52,imn51,
                       imnud01,imnud02,imnud03,imnud04,imnud05,imnud06,imnud07,  #FUN-840042 add imnud01-15
                       imnud08,imnud09,imnud10,imnud11,imnud12,imnud13,imnud14,
                       imnud15

            FROM s_imn[1].imn02,s_imn[1].imn03,s_imn[1].imn29,s_imn[1].imn28,s_imn[1].imn04,     #No.FUN-5C0077
                 s_imn[1].imn05,s_imn[1].imn09,s_imn[1].imn10,
                 s_imn[1].imn33,s_imn[1].imn34,s_imn[1].imn35,
                 s_imn[1].imn30,s_imn[1].imn31,s_imn[1].imn32,
                 s_imn[1].imn15,s_imn[1].imn16,s_imn[1].imn17,
                 s_imn[1].imn20,
                 s_imn[1].imn43,s_imn[1].imn44,s_imn[1].imn45,
                 s_imn[1].imn40,s_imn[1].imn41,s_imn[1].imn42,
                 s_imn[1].imn22,s_imn[1].imn21,
                 s_imn[1].imn52,s_imn[1].imn51
                 ,s_imn[1].imnud01,s_imn[1].imnud02,s_imn[1].imnud03
                 ,s_imn[1].imnud04,s_imn[1].imnud05,s_imn[1].imnud06
                 ,s_imn[1].imnud07,s_imn[1].imnud08,s_imn[1].imnud09
                 ,s_imn[1].imnud10,s_imn[1].imnud11,s_imn[1].imnud12
                 ,s_imn[1].imnud13,s_imn[1].imnud14,s_imn[1].imnud15
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
    CALL t324_b_fill(l_wc2)
END FUNCTION

FUNCTION t324_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2           LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(200)

    IF cl_null(p_wc2) THEN
       LET p_wc2 = " 1=1"
    END IF  
    LET g_sql =
        "SELECT imn02,imn03,'','','','','','','','','','','','','','','','','','','','','',", #TQC-650101
        #"       imn29,ima02,ima021,imn28,imn04,imn05,imn06,imn09,imn9301,'',",    #No.FUN-5C0077 #FUN-670093   #FUN-CB0087 mark
        "       imn29,ima02,ima021,imn04,imn05,imn06,imn09,imn9301,'',",             #FUN-CB0087 add
        "       imn33,imn34,imn35,imn30,imn31,imn32,",
        "       imn15,imn16,imn17,imn20,imn9302,'',",  #FUN-670093
        "       imn43,imn44,imn45,imn40,imn41,imn42,",
        "       imn10,imn22,imn21, ",
        "       imn52,imn51,imn28,azf03,  ",                               #FUN-CB0087 add>imn28,azf03
        "       imnud01,imnud02,imnud03,imnud04,imnud05,imnud06,imnud07,",  #FUN-840042 add imnud01-15
        "       imnud08,imnud09,imnud10,imnud11,imnud12,imnud13,imnud14,",
        "       imnud15",
        "       ,'',''",   #FUN-B30187
        " FROM imn_file LEFT OUTER JOIN ima_file ON imn_file.imn03 = ima_file.ima01 ",   #No.TQC-9A0113
        "               LEFT OUTER JOIN azf_file ON imn_file.imn28 = azf_file.azf01 AND azf02 = '2' ",   #FUN-CB0087 add
        " WHERE imn01 ='",g_imm.imm01,"'",  #單頭
        "    AND ",p_wc2 CLIPPED,                     #單身
        " ORDER BY imn02"

    #FUN-B30187 --START--
    LET g_sql =
        "SELECT imn02,imn03,'','','','','','','','','','','','','','','','','','','','','',", 
        #"       imn29,ima02,ima021,imn28,imn04,imn05,imn06,imn09,imn9301,'',",                     #FUN-CB0087 mark
        "       imn29,ima02,ima021,imn04,imn05,imn06,imn09,imn9301,'',",                   #FUN-CB0087 add
        "       imn33,imn34,imn35,imn30,imn31,imn32,",
        "       imn15,imn16,imn17,imn20,imn9302,'',",  
        "       imn43,imn44,imn45,imn40,imn41,imn42,",
        "       imn10,imn22,imn21, ",
        "       imn52,imn51,imn28,azf03,  ",                               #FUN-CB0087 add>imn28,azf03
        "       imnud01,imnud02,imnud03,imnud04,imnud05,imnud06,imnud07,", 
        "       imnud08,imnud09,imnud10,imnud11,imnud12,imnud13,imnud14,",
        "       imnud15,",
        "       imniicd028,imniicd029",
        " FROM imn_file LEFT OUTER JOIN ima_file ON imn_file.imn03 = ima_file.ima01 ",
        "               LEFT OUTER JOIN imni_file ON (imn01 = imni01 AND imn02 = imni02) ",   
        "               LEFT OUTER JOIN azf_file ON imn_file.imn28 = azf_file.azf01 AND azf02 = '2' ",   #FUN-CB0087 add
        " WHERE imn01 ='",g_imm.imm01,"'",  #單頭
        "    AND ",p_wc2 CLIPPED,                     #單身
        " ORDER BY imn02"
    #FUN-B30187 --END--

    PREPARE t324_pb FROM g_sql
    DECLARE imn_curs CURSOR FOR t324_pb

    CALL g_imn.clear()

    LET g_cnt = 1
    FOREACH imn_curs INTO g_imn[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN                                                                           
           #得到該料件對應的父料件和所有屬性                                                                                        
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
    CALL t324_refresh_detail()  #No:TQC-650101

    #FUN-B30170 add begin-------------------------
    LET g_sql = " SELECT rvbs02,rvbs021,ima02,ima021,rvbs022,rvbs04,rvbs03,rvbs05,rvbs06,rvbs07,rvbs08",
                "   FROM rvbs_file LEFT JOIN ima_file ON rvbs021 = ima01",
                "  WHERE rvbs00 = '",g_prog,"' AND rvbs01 = '",g_imm.imm01,"'",
                "    AND rvbs09 = -1"
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

FUNCTION t324_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)

#FUN-B30170 mark begin---------------------------
#   DISPLAY ARRAY g_imn TO s_imn.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
#
#      BEFORE DISPLAY
#         CALL cl_navigator_setting( g_curs_index, g_row_count )
#
#      BEFORE ROW
#         LET l_ac = ARR_CURR()
#         CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
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
#         CALL t324_fetch('F')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#         IF g_rec_b != 0 THEN
#            CALL fgl_set_arr_curr(1)  ######add in 040505
#         END IF
#         ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
# 
#      ON ACTION previous
#         CALL t324_fetch('P')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#         IF g_rec_b != 0 THEN
#            CALL fgl_set_arr_curr(1)  ######add in 040505
#         END IF
#         ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
# 
#      ON ACTION jump
#         CALL t324_fetch('/')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#         IF g_rec_b != 0 THEN
#            CALL fgl_set_arr_curr(1)  ######add in 040505
#         END IF
#         ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
#
#      ON ACTION next
#         CALL t324_fetch('N')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#         IF g_rec_b != 0 THEN
#            CALL fgl_set_arr_curr(1)  ######add in 040505
#         END IF
#         ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
# 
#      ON ACTION last
#         CALL t324_fetch('L')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#         IF g_rec_b != 0 THEN
#            CALL fgl_set_arr_curr(1)  ######add in 040505
#         END IF
#         ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
#
#      ON ACTION detail
#         LET g_action_choice="detail"
#         LET l_ac = 1
#         EXIT DISPLAY
#
#      ON ACTION output
#         LET g_action_choice="output"
#         EXIT DISPLAY
#      ON ACTION help
#         LET g_action_choice="help"
#         EXIT DISPLAY
#
#      ON ACTION locale
#         CALL cl_dynamic_locale()
#         CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
#         CALL t324_def_form()   #FUN-610006
#         IF g_imm.immconf = 'X' THEN #FUN-660029
#            LET g_void = 'Y'
#         ELSE
#            LET g_void = 'N'
#         END IF
#         CALL cl_set_field_pic(g_imm.immconf,"",g_imm.imm03,"",g_void,"") #FUN-660029
#
#      ON ACTION exit
#         LET g_action_choice="exit"
#         EXIT DISPLAY
#
#      ON ACTION controlg
#         LET g_action_choice="controlg"
#         EXIT DISPLAY
#   #@ ON ACTION 確認
#      ON ACTION confirm
#         LET g_action_choice="confirm"
#         EXIT DISPLAY
#   #@ ON ACTION 取消確認
#      ON ACTION undo_confirm
#         LET g_action_choice="undo_confirm"
#         EXIT DISPLAY
#   #@ ON ACTION 過帳
#      ON ACTION post
#         LET g_action_choice="post"
#         EXIT DISPLAY
#   #@ ON ACTION 過帳還原
#      ON ACTION undo_post
#         LET g_action_choice="undo_post"
#         EXIT DISPLAY
#   #@ ON ACTION 作廢
#      ON ACTION void
#         LET g_action_choice="void"
#         EXIT DISPLAY
#
#&ifdef ICD
#      ON ACTION aic_s_icdqry_in
#         LET g_action_choice="aic_s_icdqry_in"
#         EXIT DISPLAY
#
#      ON ACTION aic_s_icdqry_out
#         LET g_action_choice="aic_s_icdqry_out"
#         EXIT DISPLAY
#
#      ON ACTION aic_s_icdout
#         LET g_action_choice="aic_s_icdout"
#         EXIT DISPLAY
#&endif
#      ON ACTION accept
#         LET g_action_choice="detail"
#         LET l_ac = ARR_CURR()
#         EXIT DISPLAY
# 
#      ON ACTION cancel
#             LET INT_FLAG=FALSE         #MOD-570244 mars
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
#      #FUN-A60034---add----str---
#      ON ACTION approval_status #簽核狀況
#         LET g_action_choice="approval_status"
#         EXIT DISPLAY
#
#      ON ACTION easyflow_approval #easyflow送簽
#         LET g_action_choice = "easyflow_approval"
#         EXIT DISPLAY
#
#      ON ACTION agree
#         LET g_action_choice = 'agree'
#         EXIT DISPLAY
#
#      ON ACTION deny
#         LET g_action_choice = 'deny'
#         EXIT DISPLAY
#
#      ON ACTION modify_flow
#         LET g_action_choice = 'modify_flow'
#         EXIT DISPLAY
#
#      ON ACTION withdraw
#         LET g_action_choice = 'withdraw'
#         EXIT DISPLAY
#
#      ON ACTION org_withdraw
#         LET g_action_choice = 'org_withdraw'
#         EXIT DISPLAY
#
#      ON ACTION phrase
#         LET g_action_choice = 'phrase'
#         EXIT DISPLAY
#      #FUN-A60034---add----end---
#
#      AFTER DISPLAY
#         CONTINUE DISPLAY
#
#    #@ON ACTION 拋轉至SPC
#      ON ACTION trans_spc                     
#         LET g_action_choice="trans_spc"
#         EXIT DISPLAY
#
#      ON ACTION related_document                #No:FUN-680046  相關文件
#         LET g_action_choice="related_document"          
#         EXIT DISPLAY     
#      ON ACTION controls                                                                                                             
#         CALL cl_set_head_visible("","AUTO")                                                                                        
#
#      ON ACTION qry_lot
#         LET g_action_choice="qry_lot"
#         EXIT DISPLAY
#
#      &include "qry_string.4gl"
#   END DISPLAY
#FUN-B30170 mark -end----------------------------

   #FUN-B30170 add begin-------------------------
   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_imn TO s_imn.* ATTRIBUTE(COUNT=g_rec_b)
   
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
   
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()                   #No:FUN-550037 hmf      
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
         CALL t324_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DIALOG                    #No:FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL t324_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DIALOG                    #No:FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL t324_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DIALOG                    #No:FUN-530067 HCN TEST

      ON ACTION next
         CALL t324_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DIALOG                    #No:FUN-530067 HCN TEST
 
      ON ACTION last
         CALL t324_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DIALOG                    #No:FUN-530067 HCN TEST

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
         CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
         CALL t324_def_form()   #FUN-610006
         IF g_imm.immconf = 'X' THEN #FUN-660029
            LET g_void = 'Y'
         ELSE
            LET g_void = 'N'
         END IF
         CALL cl_set_field_pic(g_imm.immconf,"",g_imm.imm03,"",g_void,"") #FUN-660029

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG 

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG 
   #@ ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DIALOG 
   #@ ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DIALOG 
   #@ ON ACTION 過帳
      ON ACTION post
         LET g_action_choice="post"
         EXIT DIALOG 
   #@ ON ACTION 過帳還原
      ON ACTION undo_post
         LET g_action_choice="undo_post"
         EXIT DIALOG 
   #@ ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DIALOG 
      #CHI-D20008---begin
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DIALOG 
      #CHI-D20008---end   
      ON ACTION aic_s_icdqry_in
         LET g_action_choice="aic_s_icdqry_in"
         EXIT DIALOG 

      ON ACTION aic_s_icdqry_out
         LET g_action_choice="aic_s_icdqry_out"
         EXIT DIALOG 

      ON ACTION aic_s_icdout
         LET g_action_choice="aic_s_icdout"
         EXIT DIALOG 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DIALOG 
 
      ON ACTION cancel
             LET INT_FLAG=FALSE         #MOD-570244 mars
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

      #FUN-A60034---add----str---
      ON ACTION approval_status #簽核狀況
         LET g_action_choice="approval_status"
         EXIT DIALOG 

      ON ACTION easyflow_approval #easyflow送簽
         LET g_action_choice = "easyflow_approval"
         EXIT DIALOG 

      ON ACTION agree
         LET g_action_choice = 'agree'
         EXIT DIALOG 

      ON ACTION deny
         LET g_action_choice = 'deny'
         EXIT DIALOG 

      ON ACTION modify_flow
         LET g_action_choice = 'modify_flow'
         EXIT DIALOG 

      ON ACTION withdraw
         LET g_action_choice = 'withdraw'
         EXIT DIALOG 

      ON ACTION org_withdraw
         LET g_action_choice = 'org_withdraw'
         EXIT DIALOG 

      ON ACTION phrase
         LET g_action_choice = 'phrase'
         EXIT DIALOG 
      #FUN-A60034---add----end---

    #@ON ACTION 拋轉至SPC
      ON ACTION trans_spc                     
         LET g_action_choice="trans_spc"
         EXIT DIALOG 

      ON ACTION related_document                #No:FUN-680046  相關文件
         LET g_action_choice="related_document"          
         EXIT DIALOG      
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        

      ON ACTION qry_lot
         LET g_action_choice="qry_lot"
         EXIT DIALOG 

      &include "qry_string.4gl"
   END DIALOG
   #FUN-B30170 add -end--------------------------
   CALL cl_set_act_visible("accept,cancel", TRUE)
   display 'i324_bp ok'
   CALL cl_set_act_visible("accept,cancel", TRUE)

END FUNCTION

FUNCTION t324_out()
   DEFINE l_wc,l_wc2   LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(100)
          l_prog       LIKE zz_file.zz01,
          l_prtway     LIKE zz_file.zz22
 
   IF g_imm.imm01 IS NULL THEN RETURN END IF

    LET g_msg = 'imm01="',g_imm.imm01,'" '
   #LET g_msg = "aimr512 '",g_today,"' '",g_user,"' '",g_lang,"' ",    #FUN-C30085 mark
    LET g_msg = "aimg512 '",g_today,"' '",g_user,"' '",g_lang,"' ",    #FUN-C30085 add
                " 'Y' ' ' '1' ", 
                " '",g_msg CLIPPED,"' '1' "  ##MOD-8C0189 add CLIPPED 

   CALL cl_cmdrun(g_msg)

END FUNCTION

#DEV-D30046 移至saimt324_sub.4gl --mark--begin
#FUNCTION t324_s()
#   DEFINE l_cnt    LIKE type_file.num10   #No.FUN-690026 INTEGER
#   DEFINE l_sql    LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(4000)
#   DEFINE l_imn10  LIKE imn_file.imn10
#   DEFINE l_imn29  LIKE imn_file.imn29
#   DEFINE l_imn03  LIKE imn_file.imn03
#   DEFINE l_qcs01  LIKE qcs_file.qcs01
#   DEFINE l_qcs02  LIKE qcs_file.qcs02
#   DEFINE l_imd11  LIKE imd_file.imd11   #MOD-A70068
#   DEFINE l_imd11_1 LIKE imd_file.imd11   #MOD-B10114 add
#&ifdef ICD
#  DEFINE l_flag    LIKE type_file.num5    #FUN-920207
#&endif
#   DEFINE l_result LIKE type_file.chr1   #MOD-C50048 add
#   DEFINE l_date   LIKE type_file.dat    #CHI-C50010 add
#   DEFINE l_img37     LIKE img_file.img37     #CHI-C80007 add
#   DEFINE l_cnt_img   LIKE type_file.num5     #FUN-C70087
#   DEFINE l_cnt_imgg  LIKE type_file.num5     #FUN-C70087
#   DEFINE l_sel    LIKE type_file.num5   #CHI-C90036
#   DEFINE l_t1     LIKE smy_file.smyslip #No:DEV-D30026
#   DEFINE l_smyb01 LIKE smyb_file.smyb01 #No:DEV-D30026
#   DEFINE l_ima906 LIKE ima_file.ima906  #MOD-CC0139 add
#   
#   IF s_shut(0) THEN RETURN END IF
#
#   SELECT * INTO g_imm.* FROM imm_file
#    WHERE imm01 = g_imm.imm01 
#
#   #DEV-D30037--mark--begin
#   ##No:DEV-D30026  Add str---------
#   # LET l_t1 = s_get_doc_no(g_imm.imm01)
#   # SELECT smyb01 INTO l_smyb01 FROM smyb_file
#   #  WHERE smybslip = l_t1
#   # IF cl_null(l_smyb01) THEN
#   #     LET l_smyb01 = '1'
#   # END IF
#   ##No:DEV-D30026  Add end--------- 
#   #DEV-D30037--mark--end
#
#   #DEV-D30037--add--begin
#   CALL t324_chk_smyb2(g_imm.imm01)
#      RETURNING l_smyb01
#   #DEV-D30037--add--end
#
#   IF g_imm.immconf = 'N' THEN #FUN-660029
#      CALL cl_err('','aba-100',0)
#      RETURN
#   END IF
#
#   IF g_imm.imm03 = 'Y' THEN
#      CALL cl_err('','asf-812',0) #FUN-660029
#      RETURN
#   END IF
#
#   IF g_imm.immconf = 'X' THEN #FUN-660029
#      CALL cl_err('',9024,0)
#      RETURN
#   END IF
#
#   IF g_imm.imm01 IS NULL THEN
#      CALL cl_err('',-400,0)
#      RETURN
#   END IF
#
#            
#   IF g_sma.sma53 IS NOT NULL AND g_imm.imm02 <= g_sma.sma53 THEN
#      CALL cl_err('','mfg9999',0)
#      RETURN
#   END IF
#
#   CALL s_yp(g_imm.imm02) RETURNING g_yy,g_mm
#   IF g_yy > g_sma.sma51 THEN     # 與目前會計年度,期間比較
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
#
#   SELECT COUNT(*) INTO l_cnt
#     FROM imn_file
#    WHERE imn01 = g_imm.imm01 
#
#   IF l_cnt = 0 OR l_cnt IS NULL THEN
#      CALL cl_err('','mfg-009',0)
#      RETURN
#   END IF
#
#  #No:DEV-D30026  Add str--------
#   IF l_smyb01 = '2' AND cl_null(g_argv4) THEN
#      CALL cl_err('','aba-043',0)
#      RETURN
#   END IF
#  #No:DEV-D30026  Add end--------
#
#   IF g_argv2!='A' THEN  #no.CHI-780041 
#      IF g_bgjob='N' OR cl_null(g_bgjob) THEN   #No:FUN-840012
#         IF NOT cl_confirm('mfg0176') THEN
#            RETURN
#         END IF
#      END IF
#   END IF                #NO.CHI-780041
#
#   LET l_sql = "SELECT imn10,imn29,imn03,imn01,imn02 FROM imn_file",
#               " WHERE imn01= '",g_imm.imm01,"'"
#   PREPARE t324_curs1 FROM l_sql
#
#   DECLARE t324_pre1 CURSOR FOR t324_curs1
#
#   FOREACH t324_pre1 INTO l_imn10,l_imn29,l_imn03,l_qcs01,l_qcs02
#      IF l_imn29='Y' THEN
#         LET l_qcs091=0
#         SELECT SUM(qcs091) INTO l_qcs091 FROM qcs_file
#          WHERE qcs01 = l_qcs01
#            AND qcs02 = l_qcs02
#            AND qcs14 = 'Y'
#
#         IF cl_null(l_qcs091) THEN
#            LET l_qcs091 = 0
#         END IF
#
#         IF l_qcs091 < l_imn10 THEN
#            #CHI-C90036---begin
#            CALL cl_getmsg('aim1013',g_lang) RETURNING g_msg
#            LET INT_FLAG = 0  
#            PROMPT g_msg CLIPPED,': ' FOR l_sel
#            
#               ON IDLE g_idle_seconds
#                  CALL cl_on_idle()
# 
#               ON ACTION about         
#                  CALL cl_about()      
# 
#               ON ACTION help          
#                  CALL cl_show_help()  
# 
#               ON ACTION controlg      
#                  CALL cl_cmdask()     
# 
#            END PROMPT
#            IF INT_FLAG THEN
#               LET INT_FLAG = 0
#               RETURN
#            END IF
#            IF l_sel <> 1 AND l_sel <> 2 THEN
#               RETURN
#            END IF 
#            #CALL cl_err(l_imn03,'aim1003',1)
#            #RETURN
#            #CHI-C90036---end
#         END IF
#      END IF
#   END FOREACH
#
#   DECLARE t324_s1_c CURSOR FOR
#     SELECT * FROM imn_file WHERE imn01=g_imm.imm01 
#  #MOD-AA0041---mark---start---
#  #IF g_bgjob='N' OR cl_null(g_bgjob) THEN                                      
#  #   IF NOT cl_confirm('mfg0176') THEN RETURN END IF                           
#  #END IF                                                                       
#  #MOD-AA0041---mark---end---
#   BEGIN WORK
#
#   OPEN t324_cl USING g_imm.imm01
#   IF SQLCA.sqlcode THEN
#      CALL cl_err(g_imm.imm01,SQLCA.sqlcode,0)     # 資料被他人LOCK
#      CLOSE t324_cl
#      ROLLBACK WORK
#      RETURN
#   ELSE
#      FETCH t324_cl INTO g_imm.*          # 鎖住將被更改或取消的資料
#      IF SQLCA.sqlcode THEN
#         CALL cl_err(g_imm.imm01,SQLCA.sqlcode,0)     # 資料被他人LOCK
#         CLOSE t324_cl
#         ROLLBACK WORK
#         RETURN
#      END IF
#   END IF
#  IF g_argv2!='A' THEN   #MOD-C80134 add
#    #MOD-AA0041---add---start---
#     IF g_bgjob='N' OR cl_null(g_bgjob) THEN                                      
#       #MOD-AA0103---modify---start---
#       #IF NOT cl_confirm('mfg0176') THEN RETURN END IF
#        IF NOT cl_confirm('mfg0176') THEN 
#           CLOSE t324_cl
#           ROLLBACK WORK
#           RETURN 
#        END IF
#       #MOD-AA0103---modify---end---
#     END IF                                                                       
#    #MOD-AA0041---add---end---
#  END IF   #MOD-C80134 add
#  #CHI-C90036---begin
#   IF l_sel = 1 THEN 
#      UPDATE imn_file
#         SET imn10 = l_qcs091,imn22 = l_qcs091
#       WHERE imn01 = l_qcs01
#         AND imn02 = l_qcs02
#
#      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#         CALL cl_err(g_imm.imm01,SQLCA.sqlcode,1)
#         RETURN
#      END IF
#   END IF 
#   IF l_sel = 2 THEN 
#      UPDATE imn_file
#         SET imn10 = 0,imn22 = 0
#       WHERE imn01 = l_qcs01
#         AND imn02 = l_qcs02
#
#      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#         CALL cl_err(g_imm.imm01,SQLCA.sqlcode,1)
#         RETURN
#      END IF
#   END IF 
#   #CHI-C90036---end         
#   #FUN-C70087---begin
#   CALL s_padd_img_init()  #FUN-CC0095
#   CALL s_padd_imgg_init()  #FUN-CC0095
#   
#   DECLARE t325_y1_c3 CURSOR FOR SELECT * FROM imn_file
#     WHERE imn01 = g_imm.imm01 
#
#   FOREACH t325_y1_c3 INTO b_imn.*
#      IF STATUS THEN EXIT FOREACH END IF
#      LET l_cnt_img = 0
#      SELECT COUNT(*) INTO l_cnt_img
#        FROM img_file
#       WHERE img01 = b_imn.imn03
#         AND img02 = b_imn.imn15
#         AND img03 = b_imn.imn16
#         AND img04 = b_imn.imn17
#       IF l_cnt_img = 0 THEN
#          #CALL s_padd_img_data(b_imn.imn03,b_imn.imn15,b_imn.imn16,b_imn.imn17,g_imm.imm01,b_imn.imn02,g_imm.imm02,l_img_table)  #FUN-CC0095
#          CALL s_padd_img_data1(b_imn.imn03,b_imn.imn15,b_imn.imn16,b_imn.imn17,g_imm.imm01,b_imn.imn02,g_imm.imm02)  #FUN-CC0095
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
#          #CALL s_padd_imgg_data(b_imn.imn03,b_imn.imn15,b_imn.imn16,b_imn.imn17,b_imn.imn43,g_imm.imm01,b_imn.imn02,l_imgg_table)  #FUN-CC0095
#          CALL s_padd_imgg_data1(b_imn.imn03,b_imn.imn15,b_imn.imn16,b_imn.imn17,b_imn.imn43,g_imm.imm01,b_imn.imn02)  #FUN-CC0095
#       END IF 
#   END FOREACH 
#   #FUN-CC0095---begin mark
#   #LET g_sql = " SELECT COUNT(*) ",
#   #            " FROM ",l_img_table CLIPPED #,g_cr_db_str
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
#            #IF NOT s_padd_img_show(l_img_table) THEN  #FUN-CC0095
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
#         #CALL s_padd_img_del(l_img_table) #FUN-CC0095
#         #CALL s_padd_imgg_del(l_imgg_table) #FUN-CC0095
#         LET g_success = 'N'
#         RETURN
#      END IF
#   END IF
#   #CALL s_padd_img_del(l_img_table) #FUN-CC0095
#   #CALL s_padd_imgg_del(l_imgg_table) #FUN-CC0095
#   #FUN-C70087---end
#  
#   LET g_success = 'Y'
#   
#   CALL s_showmsg_init()   #No:FUN-6C0083 
#
#   FOREACH t324_s1_c INTO b_imn.*
#      IF STATUS THEN EXIT FOREACH END IF
#
#      LET g_cmd= 's_ read parts:',b_imn.imn03
#      CALL cl_msg(g_cmd)
#      
#      #-----MOD-A70068---------
#     #撥入倉
#      LET l_imd11 = ''
#      SELECT imd11 INTO l_imd11 FROM imd_file 
#       WHERE imd01 = b_imn.imn15
#     #MOD-B10114---modify---start---
#     #IF l_imd11 = 'N' OR l_imd11 IS NULL THEN   
#     #撥出倉
#      LET l_imd11_1 = ''
#      SELECT imd11 INTO l_imd11_1 FROM imd_file 
#       WHERE imd01 = b_imn.imn04
#      IF l_imd11_1 = 'Y' AND (l_imd11 = 'N' OR l_imd11 IS NULL) THEN 
#     #MOD-B10114---modify---end---
#         CALL t324_chk_avl_stk(b_imn.*)     
#         IF g_success='N' THEN
#            LET g_totsuccess="N"
#            CONTINUE FOREACH   
#         END IF    
#      END IF   
#      #-----END MOD-A70068-----
#
#      #MOD-C50048 add begin-------------------
#      #撥出倉庫過賬權限檢查
#      CALL s_incchk(b_imn.imn04,b_imn.imn05,g_user) RETURNING l_result
#      IF NOT l_result THEN
#         LET g_success = 'N'
#         LET g_showmsg = b_imn.imn03,"/",b_imn.imn04,"/",b_imn.imn05,"/",g_user
#         CALL s_errmsg("imn03/imn04/imn05/inc03",g_showmsg,'','asf-888',1)
#         CONTINUE FOREACH
#      END IF
#
#      #撥入倉庫過賬權限檢查
#      CALL s_incchk(b_imn.imn15,b_imn.imn16,g_user) RETURNING l_result
#      IF NOT l_result THEN
#         LET g_success = 'N'
#         LET g_showmsg = b_imn.imn03,"/",b_imn.imn15,"/",b_imn.imn16,"/",g_user
#         CALL s_errmsg("imn03/imn15/imn16/inc03",g_showmsg,'','asf-888',1)
#         CONTINUE FOREACH
#      END IF
#      #MOD-C50048 add end---------------------
#
#      IF cl_null(b_imn.imn04) THEN CONTINUE FOREACH END IF
#      
#&ifdef ICD
#      CALL s_icdpost(-1,b_imn.imn03,b_imn.imn04,b_imn.imn05,          
#                         b_imn.imn06,b_imn.imn09,b_imn.imn10,
#                         b_imn.imn01,b_imn.imn02,g_imm.imm02,'Y',
#                         '','',b_imni.imniicd029,b_imni.imniicd028,'') #FUN-B30187  #FUN-B80119--傳入p_plant參數''---
#           RETURNING l_flag                                            
#      IF l_flag = 0 THEN                                               
#        #str MOD-A20099 mod
#        #LET g_success = 'N'
#        #RETURN
#         LET g_totsuccess="N"
#         CONTINUE FOREACH
#        #end MOD-A20099 mod
#      END IF
#          
#      CALL s_icdpost(1,b_imn.imn03,b_imn.imn15,b_imn.imn16,          
#                        b_imn.imn17,b_imn.imn20,b_imn.imn22,
#                        b_imn.imn01,b_imn.imn02,g_imm.imm02,'Y',
#                        '','',b_imni.imniicd029,b_imni.imniicd028,'') #FUN-B30187  #FUN-B80119--傳入p_plant參數''---
#                  
#           RETURNING l_flag                                            
#      IF l_flag = 0 THEN
#        #str MOD-A20099 mod
#        #LET g_success = 'N'
#        #RETURN
#         LET g_totsuccess="N"
#         CONTINUE FOREACH
#       #end MOD-A20099 mod
#      END IF 
#&endif
#      
#      SELECT *
#        FROM img_file WHERE img01=b_imn.imn03 AND
#                            img02=b_imn.imn15 AND
#                            img03=b_imn.imn16 AND
#                            img04=b_imn.imn17
#      IF SQLCA.sqlcode THEN
#         IF b_imn.imn05 IS NULL THEN LET b_imn.imn05 =' ' END IF   #MOD-CB0122 add
#         IF b_imn.imn06 IS NULL THEN LET b_imn.imn06 =' ' END IF   #MOD-CB0122 add
#           #CHI-C50010 str add-----
#           #SELECT img18 INTO l_date FROM img_file                #CHI-C80007 mark
#            SELECT img18,img37 INTO l_date,l_img37 FROM img_file  #CHI-C80007 add img37
#          #TQC-C90089---add----
#          #  WHERE img01 = g_imn[l_ac].imn03
#          #    AND img02 = g_imn[l_ac].imn04
#          #    AND img03 = g_imn[l_ac].imn05
#          #    AND img04 = g_imn[l_ac].imn06
#             WHERE img01 = b_imn.imn03
#               AND img02 = b_imn.imn04
#               AND img03 = b_imn.imn05
#               AND img04 = b_imn.imn06
#          #TQC-C90089---add---
#          #MOD-CB0122 add---S
#           IF STATUS=100 THEN
#              CALL cl_err('','mfg6101',1)  
#              LET g_success ='N'
#              CONTINUE FOREACH
#           ELSE
#          #MOD-CB0122 add---E
#              CALL s_date_record(l_date,'Y')
#           END IF    #MOD-CB0122 add
#           #CHI-C50010 end add-----
#            CALL s_idledate_record(l_img37)  #CHI-C80007 add
#            CALL s_add_img(b_imn.imn03,b_imn.imn15,
#                           b_imn.imn16,b_imn.imn17,
#                           g_imm.imm01      ,b_imn.imn02,
#                           g_imm.imm02)
#      END IF
#      #MOD-CC0139 add
#      #不做sma892[3,3]提示的处理，前FUN-C70087单号已增加
#      IF g_sma.sma115 = 'Y' THEN
#         LET l_ima906=''
#         SELECT ima906 INTO l_ima906 FROM ima_file
#          WHERE ima01 = b_imn.imn03
#         #母子单位 单位一  --begin
#         IF l_ima906 = '2' THEN
#            CALL s_chk_imgg(b_imn.imn03,b_imn.imn15,
#                            b_imn.imn16,b_imn.imn17,
#                            b_imn.imn40) RETURNING g_flag
#            IF g_flag = 1 THEN
#               CALL s_add_imgg(b_imn.imn03,b_imn.imn15,
#                               b_imn.imn16,b_imn.imn17,
#                               b_imn.imn40,b_imn.imn41,
#                               g_imm.imm01,b_imn.imn02,0)
#                    RETURNING g_flag
#               IF g_flag = 1 THEN
#                  LET g_totsuccess="N"
#                  CONTINUE FOREACH
#               END IF
#            END IF
#         END IF
#         #母子单位 单位一  --end
#         #母子单位&参考单位 单位二  --begin
#         IF l_ima906 MATCHES '[23]' THEN
#            CALL s_chk_imgg(b_imn.imn03,b_imn.imn15,
#                            b_imn.imn16,b_imn.imn17,
#                            b_imn.imn43) RETURNING g_flag
#            IF g_flag = 1 THEN
#               CALL s_add_imgg(b_imn.imn03,b_imn.imn15,
#                               b_imn.imn16,b_imn.imn17,
#                               b_imn.imn43,b_imn.imn44,
#                               g_imm.imm01,b_imn.imn02,0)
#                    RETURNING g_flag
#               IF g_flag = 1 THEN
#                  LET g_totsuccess="N"
#                  CONTINUE FOREACH
#               END IF
#            END IF
#         END IF
#         #母子单位&参考单位 单位二  --end
#      END IF
#      #MOD-CC0139 add--end
#
#    #FUN-D30024 -----------Begin---------
#    # IF NOT s_stkminus(b_imn.imn03,b_imn.imn04,b_imn.imn05,b_imn.imn06,
#    #                   b_imn.imn10,1,g_imm.imm02,g_sma.sma894[4,4]) THEN
#      IF NOT s_stkminus(b_imn.imn03,b_imn.imn04,b_imn.imn05,b_imn.imn06,
#                        b_imn.imn10,1,g_imm.imm02) THEN
#    #FUN-D30024 -----------End-----------
#         LET g_totsuccess="N"
#         CONTINUE FOREACH   #No:FUN-6C0083
#      END IF
#
#      #-->撥出更新
#      IF t324_t(b_imn.*) THEN
#         LET g_totsuccess="N"
#         CONTINUE FOREACH   #No:FUN-6C0083
#      END IF
#
#      IF g_sma.sma115 = 'Y' THEN
#         CALL t324_upd_s(b_imn.*)
#      END IF
#
#      IF g_success = 'N' THEN
#         LET g_totsuccess="N"
#         LET g_success="Y"
#         CONTINUE FOREACH   #No:FUN-6C0083
#      END IF
#
#      #-->撥入更新
#      IF t324_t2(b_imn.*) THEN
#         LET g_totsuccess="N"
#         CONTINUE FOREACH   #No:FUN-6C0083
#      END IF
#
#      IF g_sma.sma115 = 'Y' THEN
#         CALL t324_upd_t(b_imn.*)
#      END IF
#
#      #FUN-AC0074--behin--add---
#      CALL s_updsie_sie(b_imn.imn01,b_imn.imn02,'4')
#      #FUN-AC0074--end--add-----
#
#      IF g_success = 'N' THEN 
#         LET g_totsuccess="N"
#         LET g_success="Y"
#         CONTINUE FOREACH   #No:FUN-6C0083
#      END IF
# 
#   END FOREACH
#
#   IF g_totsuccess="N" THEN
#      LET g_success="N"
#   END IF
#   CALL s_showmsg()   #No:FUN-6C0083
#  
#   UPDATE imm_file SET imm03 = 'Y',
#                       imm04 = 'Y'
#    WHERE imm01 = g_imm.imm01 
#
#   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#      CALL s_errmsg('imm01',g_imm.imm01,'up imm_file',SQLCA.sqlcode,1)
#      LET g_success = 'N'
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
#
#   DISPLAY BY NAME g_imm.imm03
#
#   IF g_imm.imm03 = "N" THEN
#      DECLARE t324_s1_c2 CURSOR FOR SELECT * FROM imn_file
#        WHERE imn01 = g_imm.imm01 
#
#      LET g_imm01 = ""
#      LET g_success = "Y"
#
#      CALL s_showmsg_init()   #No:FUN-6C0083 
#
#      BEGIN WORK
#
#      FOREACH t324_s1_c2 INTO b_imn.*
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
#               CALL s_dismantle(g_imm.imm01,b_imn.imn02,g_imm.imm02,
#                                b_imn.imn03,b_imn.imn04,b_imn.imn05,
#                                b_imn.imn06,g_unit_arr,g_imm01)
#                      RETURNING g_imm01
#               IF g_success='N' THEN 
#                  LET g_totsuccess='N'
#                  LET g_success="Y"
#                  CONTINUE FOREACH   #No:FUN-6C0083
#               END IF
#            END IF
#         END IF
#      END FOREACH
#
#      IF g_totsuccess="N" THEN
#         LET g_success="N"
#      END IF
#      CALL s_showmsg()   #No:FUN-6C0083
#
#      IF g_success = "Y" AND NOT cl_null(g_imm01) THEN
#         COMMIT WORK
#         LET g_msg="aimt324 '",g_imm01,"'"
#         CALL cl_cmdrun_wait(g_msg)
#      ELSE
#         ROLLBACK WORK
#      END IF
#   END IF
#   IF g_imm.immconf='X' THEN
#      LET g_void = 'Y'
#   ELSE
#      LET g_void = 'N'
#   END IF
#   CALL cl_set_field_pic(g_imm.immconf,"",g_imm.imm03,"",g_void,"")   
#
#
#END FUNCTION
#
#FUNCTION t324_upd_s(p_imn)
#   DEFINE p_imn     RECORD LIKE imn_file.*
#   DEFINE l_ima25   LIKE ima_file.ima25,
#          u_type    LIKE type_file.num5    #No.FUN-690026 SMALLINT
#
#   SELECT ima906,ima907,ima25 INTO g_ima906,g_ima907,l_ima25 FROM ima_file
#    WHERE ima01 = p_imn.imn03
#   IF SQLCA.sqlcode THEN
#      LET g_success='N'
#      RETURN
#   END IF
#
#   IF g_ima906 = '1' OR cl_null(g_ima906) THEN
#      RETURN
#   END IF
#
#   IF g_ima906 = '2' THEN  #子母單位
#      IF NOT cl_null(p_imn.imn33) THEN
#         CALL t324_upd_imgg('1',p_imn.imn03,p_imn.imn04,p_imn.imn05,p_imn.imn06,p_imn.imn33,p_imn.imn34,p_imn.imn35,-1,'2')
#         IF g_success='N' THEN RETURN END IF
#         IF NOT cl_null(p_imn.imn35) THEN                                #CHI-860005
#            CALL t324_tlff_1('2',p_imn.*,-1)
#            IF g_success='N' THEN RETURN END IF
#         END IF
#      END IF
#      IF NOT cl_null(p_imn.imn30) THEN
#         CALL t324_upd_imgg('1',p_imn.imn03,p_imn.imn04,p_imn.imn05,p_imn.imn06,p_imn.imn30,p_imn.imn31,p_imn.imn32,-1,'1')
#         IF g_success='N' THEN RETURN END IF
#          IF NOT cl_null(p_imn.imn32) THEN                               #CHI-860005   
#            CALL t324_tlff_2('1',p_imn.*,-1)
#            IF g_success='N' THEN RETURN END IF
#         END IF
#      END IF
#   END IF
#
#   IF g_ima906 = '3' THEN  #參考單位
#      IF NOT cl_null(p_imn.imn33) THEN
#         CALL t324_upd_imgg('2',p_imn.imn03,p_imn.imn04,p_imn.imn05,p_imn.imn06,p_imn.imn33,p_imn.imn34,p_imn.imn35,-1,'2')
#         IF g_success = 'N' THEN RETURN END IF
#         IF NOT cl_null(p_imn.imn35) THEN                                #CHI-860005
#            CALL t324_tlff_1('2',p_imn.*,-1)
#            IF g_success='N' THEN RETURN END IF
#         END IF
#      END IF
#   END IF
#
#END FUNCTION
#
#FUNCTION t324_upd_t(p_imn)
#   DEFINE p_imn     RECORD LIKE imn_file.*
#   DEFINE l_ima25   LIKE ima_file.ima25,
#          u_type    LIKE type_file.num5      #No.FUN-690026 SMALLINT
#
#   SELECT ima906,ima907,ima25 INTO g_ima906,g_ima907,l_ima25 FROM ima_file
#    WHERE ima01 = p_imn.imn03
#   IF SQLCA.sqlcode THEN
#      LET g_success='N' RETURN
#   END IF
#   IF g_ima906 = '1' OR cl_null(g_ima906) THEN RETURN END IF
#
#   IF g_ima906 = '2' THEN  #子母單位
#      IF NOT cl_null(p_imn.imn43) THEN
#         CALL t324_upd_imgg('1',p_imn.imn03,p_imn.imn15,p_imn.imn16,p_imn.imn17,p_imn.imn43,p_imn.imn44,p_imn.imn45,+1,'2')
#         IF g_success='N' THEN RETURN END IF
#         IF NOT cl_null(p_imn.imn45) THEN                                  #CHI-860005
#            CALL t324_tlff_1('2',p_imn.*,+1)
#            IF g_success='N' THEN RETURN END IF
#         END IF
#      END IF
#      IF NOT cl_null(p_imn.imn40) THEN
#         CALL t324_upd_imgg('1',p_imn.imn03,p_imn.imn15,p_imn.imn16,p_imn.imn17,p_imn.imn40,p_imn.imn41,p_imn.imn42,+1,'1')
#         IF g_success='N' THEN RETURN END IF
#         IF NOT cl_null(p_imn.imn42) THEN                                  #CHI-860005
#            CALL t324_tlff_2('1',p_imn.*,+1)
#            IF g_success='N' THEN RETURN END IF
#         END IF
#      END IF
#   END IF
#   IF g_ima906 = '3' THEN  #參考單位
#      IF NOT cl_null(p_imn.imn43) THEN
#         CALL t324_upd_imgg('2',p_imn.imn03,p_imn.imn15,p_imn.imn16,p_imn.imn17,p_imn.imn43,p_imn.imn44,p_imn.imn45,+1,'2')
#         IF g_success = 'N' THEN RETURN END IF
#         IF NOT cl_null(p_imn.imn45) THEN                                  #CHI-860005
#            CALL t324_tlff_1('2',p_imn.*,+1)
#            IF g_success='N' THEN RETURN END IF
#         END IF
#      END IF
#   END IF
#
#END FUNCTION
#
#FUNCTION t324_upd_imgg(p_imgg00,p_imgg01,p_imgg02,p_imgg03,p_imgg04,
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
#        " WHERE imgg01= ? AND imgg02= ? AND imgg03= ? AND imgg04= ? ",
#        "   AND imgg09= ? FOR UPDATE "
#    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
#
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
#       CALL cl_err3("sel","ima_file",p_imgg01,"",SQLCA.sqlcode,"",
#                    "ima25 null",1)   #No:FUN-660156 
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
#    CALL s_upimgg(p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,p_type,p_imgg10,g_imm.imm02,  #FUN-8C0084
#          '','','','','','','','','','',l_imgg21,'','','','','','','',p_imgg211)
#    IF g_success='N' THEN RETURN END IF
# 
#END FUNCTION
#
#FUNCTION t324_tlff_1(p_flag,p_imn,p_type)
#DEFINE
#   p_imn      RECORD LIKE imn_file.*,
#   p_flag     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#   p_type     LIKE type_file.num5,    #No.FUN-690026 SMALLINT
#   l_imgg10_s LIKE imgg_file.imgg10,
#   l_imgg10_t LIKE imgg_file.imgg10
#
#    IF p_imn.imn33 IS NULL THEN
#       CALL cl_err('p_imn33 null:','asf-031',1) LET g_success = 'N' RETURN
#    END IF
#
#    IF p_imn.imn43 IS NULL THEN
#       CALL cl_err('p_imn43 null:','asf-031',1) LET g_success = 'N' RETURN
#    END IF
#
# 
#    INITIALIZE g_tlff.* TO NULL
#    SELECT imgg10 INTO l_imgg10_s FROM imgg_file
#     WHERE imgg01=p_imn.imn03  AND imgg02=p_imn.imn04
#       AND imgg03=p_imn.imn05  AND imgg04=p_imn.imn06
#       AND imgg09=p_imn.imn33
#    IF cl_null(l_imgg10_s) THEN LET l_imgg10_s=0 END IF
# 
#    SELECT imgg10 INTO l_imgg10_t FROM imgg_file
#     WHERE imgg01=p_imn.imn03  AND imgg02=p_imn.imn15
#       AND imgg03=p_imn.imn16  AND imgg04=p_imn.imn17
#       AND imgg09=p_imn.imn43
#    IF cl_null(l_imgg10_t) THEN LET l_imgg10_t=0 END IF
#
#    LET g_tlff.tlff01=p_imn.imn03               #異動料件編號
#    #----來源----
#    LET g_tlff.tlff02=50                          #來源為倉庫(撥出)
#    LET g_tlff.tlff020=g_plant                    #工廠別
#    LET g_tlff.tlff021=p_imn.imn04              #倉庫別
#    LET g_tlff.tlff022=p_imn.imn05              #儲位別
#    LET g_tlff.tlff023=p_imn.imn06              #批號
#    LET g_tlff.tlff024=l_imgg10_s#-p_imn.imn35     #異動後庫存數量
#    LET g_tlff.tlff025=p_imn.imn33                #庫存單位(ima_file or img_file)
#    LET g_tlff.tlff026=p_imn.imn01                #調撥單號
#    LET g_tlff.tlff027=p_imn.imn02                #項次
##----目的----
#    LET g_tlff.tlff03=50                          #資料目的為(撥入)
#    LET g_tlff.tlff030=g_plant                    #工廠別
#    LET g_tlff.tlff031=p_imn.imn15                #倉庫別
#    LET g_tlff.tlff032=p_imn.imn16                #儲位別
#    LET g_tlff.tlff033=p_imn.imn17              #批號
#    LET g_tlff.tlff034=l_imgg10_t#+p_imn.imn44     #異動後庫存量
#    LET g_tlff.tlff035=p_imn.imn43              #庫存單位(ima_file or img_file)
#    LET g_tlff.tlff036=p_imn.imn01                #參考號碼
#    LET g_tlff.tlff037=p_imn.imn02                #項次
#
#    #---- 97/06/20 調撥作業來源目的碼
#    IF p_type=-1 THEN #-- 出
#       LET g_tlff.tlff02=50
#       LET g_tlff.tlff03=99
#       LET g_tlff.tlff030=' '
#       LET g_tlff.tlff031=' '
#       LET g_tlff.tlff032=' '
#       LET g_tlff.tlff033=' '
#       LET g_tlff.tlff034=0
#       LET g_tlff.tlff035=' '
#       LET g_tlff.tlff036=' '
#       LET g_tlff.tlff037=0
#       LET g_tlff.tlff10=p_imn.imn35                 #調撥數量
#       LET g_tlff.tlff11=p_imn.imn33                 #撥出單位
#       LET g_tlff.tlff12=p_imn.imn34                 #撥出/撥入庫存轉換率
#       LET g_tlff.tlff930=p_imn.imn9301   #FUN-670093
#    ELSE               #-- 入
#       LET g_tlff.tlff02=99
#       LET g_tlff.tlff03=50
#       LET g_tlff.tlff020=' '
#       LET g_tlff.tlff021=' '
#       LET g_tlff.tlff022=' '
#       LET g_tlff.tlff023=' '
#       LET g_tlff.tlff024=0
#       LET g_tlff.tlff025=' '
#       LET g_tlff.tlff026=' '
#       LET g_tlff.tlff027=0
#       LET g_tlff.tlff10=p_imn.imn45                 #調撥數量
#       LET g_tlff.tlff11=p_imn.imn43                 #撥入單位
#       LET g_tlff.tlff12=p_imn.imn44                 #撥入/撥出庫存轉換率
#       LET g_tlff.tlff930=p_imn.imn9302   #FUN-670093
#    END IF
#
##--->異動數量
#    LET g_tlff.tlff04=' '                         #工作站
#    LET g_tlff.tlff05=' '                         #作業序號
#    LET g_tlff.tlff06=g_imm.imm02                 #發料日期
#    LET g_tlff.tlff07=g_today                     #異動資料產生日期
#    LET g_tlff.tlff08=TIME                        #異動資料產生時:分:秒
#    LET g_tlff.tlff09=g_user                      #產生人
#    LET g_tlff.tlff13='aimt324'                   #異動命令代號
#    LET g_tlff.tlff14=p_imn.imn28                 #異動原因
#    LET g_tlff.tlff15=g_debit                     #借方會計科目
#    LET g_tlff.tlff16=g_credit                    #貸方會計科目
#    LET g_tlff.tlff17=g_imm.imm09                 #remark
#   #LET g_tlff.tlff19= ' '                        #異動廠商/客戶編號    #MOD-A80004 mark
#    LET g_tlff.tlff19= g_imm.imm14                #異動廠商/客戶編號    #MOD-A80004 add
#    LET g_tlff.tlff20= ' '                        #project no.
#    IF p_type=-1 THEN
#       IF cl_null(p_imn.imn35) OR p_imn.imn35 = 0 THEN
#          CALL s_tlff(p_flag,NULL)
#       ELSE
#          CALL s_tlff(p_flag,p_imn.imn33)
#       END IF
#    ELSE
#       IF cl_null(p_imn.imn45) OR p_imn.imn45 = 0 THEN
#          CALL s_tlff(p_flag,NULL)
#       ELSE
#          CALL s_tlff(p_flag,p_imn.imn43)
#       END IF
#    END IF
#END FUNCTION
#
#FUNCTION t324_tlff_2(p_flag,p_imn,p_type)
#DEFINE
#   p_imn      RECORD LIKE imn_file.*,
#   p_flag     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#   p_type     LIKE type_file.num5,    #No.FUN-690026 SMALLINT
#   l_imgg10_s LIKE imgg_file.imgg10,
#   l_imgg10_t LIKE imgg_file.imgg10
#
#    IF p_imn.imn30 IS NULL THEN
#       CALL cl_err('p_imn30 null:','asf-031',1) LET g_success = 'N' RETURN
#    END IF
#
#    IF p_imn.imn40 IS NULL THEN
#       CALL cl_err('p_imn40 null:','asf-031',1) LET g_success = 'N' RETURN
#    END IF
# 
#    INITIALIZE g_tlff.* TO NULL
#    SELECT imgg10 INTO l_imgg10_s FROM imgg_file
#     WHERE imgg01=p_imn.imn03  AND imgg02=p_imn.imn04
#       AND imgg03=p_imn.imn05  AND imgg04=p_imn.imn06
#       AND imgg09=p_imn.imn30
#    IF cl_null(l_imgg10_s) THEN LET l_imgg10_s=0 END IF
# 
#    SELECT imgg10 INTO l_imgg10_t FROM imgg_file
#     WHERE imgg01=p_imn.imn03  AND imgg02=p_imn.imn15
#       AND imgg03=p_imn.imn16  AND imgg04=p_imn.imn17
#       AND imgg09=p_imn.imn40
#    IF cl_null(l_imgg10_t) THEN LET l_imgg10_t=0 END IF
#
#    LET g_tlff.tlff01=p_imn.imn03               #異動料件編號
#    #----來源----
#    LET g_tlff.tlff02=50                                #來源為倉庫(撥出)
#    LET g_tlff.tlff020=g_plant                    #工廠別
#    LET g_tlff.tlff021=p_imn.imn04              #倉庫別
#    LET g_tlff.tlff022=p_imn.imn05              #儲位別
#    LET g_tlff.tlff023=p_imn.imn06              #批號
#    LET g_tlff.tlff024=l_imgg10_s#-p_imn.imn31     #異動後庫存數量
#    LET g_tlff.tlff025=p_imn.imn30                #庫存單位(ima_file or img_file)
#    LET g_tlff.tlff026=p_imn.imn01                #調撥單號
#    LET g_tlff.tlff027=p_imn.imn02                #項次
##----目的----
#    LET g_tlff.tlff03=50                                #資料目的為(撥入)
#    LET g_tlff.tlff030=g_plant                    #工廠別
#    LET g_tlff.tlff031=p_imn.imn15                #倉庫別
#    LET g_tlff.tlff032=p_imn.imn16                #儲位別
#    LET g_tlff.tlff033=p_imn.imn17              #批號
#    LET g_tlff.tlff034=l_imgg10_t#+p_imn.imn41     #異動後庫存量
#    LET g_tlff.tlff035=p_imn.imn40              #庫存單位(ima_file or img_file)
#    LET g_tlff.tlff036=p_imn.imn01                #參考號碼
#    LET g_tlff.tlff037=p_imn.imn02                #項次
#
#    #---- 97/06/20 調撥作業來源目的碼
#    IF p_type=-1 THEN #-- 出
#       LET g_tlff.tlff02=50
#       LET g_tlff.tlff03=99
#       LET g_tlff.tlff030=' '
#       LET g_tlff.tlff031=' '
#       LET g_tlff.tlff032=' '
#       LET g_tlff.tlff033=' '
#       LET g_tlff.tlff034=0
#       LET g_tlff.tlff035=' '
#       LET g_tlff.tlff036=' '
#       LET g_tlff.tlff037=0
#       LET g_tlff.tlff10=p_imn.imn32                 #調撥數量
#       LET g_tlff.tlff11=p_imn.imn30                 #撥出單位
#       LET g_tlff.tlff12=p_imn.imn31                 #撥出/撥入庫存轉換率
#       LET g_tlff.tlff930=p_imn.imn9301   #FUN-670093
#    ELSE               #-- 入
#       LET g_tlff.tlff02=99
#       LET g_tlff.tlff03=50
#       LET g_tlff.tlff020=' '
#       LET g_tlff.tlff021=' '
#       LET g_tlff.tlff022=' '
#       LET g_tlff.tlff023=' '
#       LET g_tlff.tlff024=0
#       LET g_tlff.tlff025=' '
#       LET g_tlff.tlff026=' '
#       LET g_tlff.tlff027=0
#       LET g_tlff.tlff10=p_imn.imn42                 #調撥數量
#       LET g_tlff.tlff11=p_imn.imn40                 #撥入單位
#       LET g_tlff.tlff12=p_imn.imn41                 #撥入/撥出庫存轉換率
#       LET g_tlff.tlff930=p_imn.imn9302   #FUN-670093
#    END IF
#
##--->異動數量
#    LET g_tlff.tlff04=' '                         #工作站
#    LET g_tlff.tlff05=' '                         #作業序號
#    LET g_tlff.tlff06=g_imm.imm02                 #發料日期
#    LET g_tlff.tlff07=g_today                     #異動資料產生日期
#    LET g_tlff.tlff08=TIME                        #異動資料產生時:分:秒
#    LET g_tlff.tlff09=g_user                      #產生人
#    LET g_tlff.tlff13='aimt324'                   #異動命令代號
#    LET g_tlff.tlff14=p_imn.imn28                 #異動原因
#    LET g_tlff.tlff15=g_debit                     #借方會計科目
#    LET g_tlff.tlff16=g_credit                    #貸方會計科目
#    LET g_tlff.tlff17=g_imm.imm09                 #remark
#   #LET g_tlff.tlff19= ' '                        #異動廠商/客戶編號    #MOD-A80004 mark
#    LET g_tlff.tlff19= g_imm.imm14                #異動廠商/客戶編號    #MOD-A80004 add
#    LET g_tlff.tlff20= ' '                        #project no.
#    IF p_type=-1 THEN
#       IF cl_null(p_imn.imn35) OR p_imn.imn35 = 0 THEN
#          CALL s_tlff(p_flag,NULL)
#       ELSE
#          CALL s_tlff(p_flag,p_imn.imn33)
#       END IF
#    ELSE
#       IF cl_null(p_imn.imn45) OR p_imn.imn45 = 0 THEN
#          CALL s_tlff(p_flag,NULL)
#       ELSE
#          CALL s_tlff(p_flag,p_imn.imn43)
#       END IF
#    END IF
#END FUNCTION
#
##-->撥出更新
#FUNCTION t324_t(p_imn)
#DEFINE p_imn   RECORD LIKE imn_file.*,
#       l_img   RECORD
#               img16      LIKE img_file.img16,
#               img23      LIKE img_file.img23,
#               img24      LIKE img_file.img24,
#               img09      LIKE img_file.img09,
#               img21      LIKE img_file.img21
#               END RECORD,
#       l_qty   LIKE img_file.img10,
#       l_factor  LIKE ima_file.ima31_fac  #MOD-A70117 add
#
#    CALL cl_msg("update img_file ...")
#    IF cl_null(p_imn.imn05) THEN LET p_imn.imn05=' ' END IF
#    IF cl_null(p_imn.imn06) THEN LET p_imn.imn06=' ' END IF
#
#    LET g_forupd_sql =
#        "SELECT img16,img23,img24,img09,img21,img26,img10 FROM img_file ",
#        " WHERE img01= ? AND img02=  ? AND img03= ? AND img04=  ? FOR UPDATE "
#    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
#
#    DECLARE img_lock CURSOR FROM g_forupd_sql
# 
#    OPEN img_lock USING p_imn.imn03,p_imn.imn04,p_imn.imn05,p_imn.imn06
#    IF SQLCA.sqlcode THEN
#       CALL cl_err("img_lock fail:", STATUS, 1)   #NO.TQC-93015
#       LET g_success = 'N'
#       RETURN 1
#    ELSE
#       FETCH img_lock INTO l_img.*,g_debit,g_img10
#       IF SQLCA.sqlcode THEN
#          CALL cl_err("sel img_file", STATUS, 1)   #NO.TQC-930155
#          LET g_success = 'N'
#          RETURN 1
#       END IF
#    END IF
#
#   #str MOD-A70117 add
#    CALL s_umfchk(p_imn.imn03,p_imn.imn09,l_img.img09) RETURNING g_cnt,l_factor
#    IF g_cnt = 1 THEN
#       CALL cl_err('','mfg3075',1)
#       LET g_success = 'N'
#       RETURN 1
#    END IF
#    LET l_qty = p_imn.imn10 * l_factor
#   #end MOD-A70117 add
#
##-->更新倉庫庫存明細資料
#   #CALL s_upimg(p_imn.imn03,p_imn.imn04,p_imn.imn05,p_imn.imn06,-1,p_imn.imn10,g_imm.imm02,  #FUN-8C0084  #MOD-A70117 mark
#    CALL s_upimg(p_imn.imn03,p_imn.imn04,p_imn.imn05,p_imn.imn06,-1,l_qty,g_imm.imm02,  #FUN-8C0084        #MOD-A70117
#        '','','','',p_imn.imn01,p_imn.imn02,'','','','','','','','','','','','')   #No:FUN-860045
#
#    IF g_success = 'N' THEN RETURN 1 END IF
#
##-->若庫存異動後其庫存量小於等於零時將該筆資料刪除
#    CALL s_delimg(p_imn.imn03,p_imn.imn04,p_imn.imn05,p_imn.imn06) #FUN-8C0084
# 
##-->更新庫存主檔之庫存數量 (單位為主檔之庫存單位)
#    CALL cl_msg("update ima_file ...")
#
#    LET g_forupd_sql = "SELECT ima25 FROM ima_file WHERE ima01= ?  FOR UPDATE "  
#    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
#    DECLARE ima_lock CURSOR FROM g_forupd_sql
#
#    OPEN ima_lock USING p_imn.imn03
#    IF STATUS THEN
#       CALL cl_err('lock ima fail',STATUS,1)
#        LET g_success='N' RETURN  1
#    END IF
#
#    FETCH ima_lock INTO g_ima25  #,g_ima86 #FUN-560183
#    IF STATUS THEN
#       CALL cl_err('lock ima fail',STATUS,1)
#        LET g_success='N' RETURN  1
#    END IF
#
##-->料件庫存單位數量
#    LET l_qty=p_imn.imn10 * l_img.img21
#    IF cl_null(l_qty)  THEN RETURN 1 END IF
#
#    IF s_udima(p_imn.imn03,             #料件編號
#                           l_img.img23,             #是否可用倉儲
#                           l_img.img24,             #是否為MRP可用倉儲
#                           l_qty,                   #調撥數量(換算為料件庫存單位)
#                          #l_img.img16,             #最近一次撥出日期    #MOD-C30001 mark
#                           g_imm.imm02,                                  #MOD-C30001
#                           -1)                      #表撥出
#     THEN RETURN 1
#        END IF
#    IF g_success = 'N' THEN RETURN 1 END IF
#
##-->將已鎖住之資料釋放出來
#    CLOSE img_lock
# 
#        RETURN 0
#END FUNCTION
# 
#FUNCTION t324_t2(p_imn)
#DEFINE
#    p_imn      RECORD LIKE imn_file.*,
#    l_img      RECORD
#               img16      LIKE img_file.img16,
#               img23      LIKE img_file.img23,
#               img24      LIKE img_file.img24,
#               img09      LIKE img_file.img09,
#               img21      LIKE img_file.img21,
#               img19      LIKE img_file.img19,
#               img27      LIKE img_file.img27,
#               img28      LIKE img_file.img28,
#               img35      LIKE img_file.img35,
#               img36      LIKE img_file.img36
#               END RECORD,
#    l_factor   LIKE ima_file.ima31_fac,  #No.FUN-690026 DECIMAL(16,8)
#    l_qty      LIKE img_file.img10
#
#    LET g_forupd_sql =
#        "SELECT img15,img23,img24,img09,img21,img19,img27,",         #MOD-970033 img16 modify img15
#               "img28,img35,img36,img26,img10 FROM img_file ",
#        " WHERE img01= ? AND img02= ? AND img03= ? AND img04= ? ",
#        " FOR UPDATE "
#    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
#    DECLARE img2_lock CURSOR FROM g_forupd_sql
#
#    OPEN img2_lock USING p_imn.imn03,p_imn.imn15,p_imn.imn16,p_imn.imn17
#    IF SQLCA.sqlcode THEN
#       CALL cl_err('lock img2 fail',STATUS,1)
#       LET g_success = 'N' RETURN 1
#    END IF
#
#    FETCH img2_lock INTO l_img.*,g_credit,g_img10_2
#    IF SQLCA.sqlcode THEN
#       CALL cl_err('lock img2 fail',STATUS,1)
#       LET g_success = 'N' RETURN 1
#    END IF
#
##-->更新庫存主檔之庫存數量 (單位為主檔之庫存單位)
#    CALL cl_msg("update ima2_file ...")
#    LET g_forupd_sql = "SELECT ima25 FROM ima_file WHERE ima01= ? FOR UPDATE "
#    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
#    DECLARE ima2_lock CURSOR FROM g_forupd_sql
#
#    OPEN ima2_lock USING p_imn.imn03
#    IF SQLCA.sqlcode THEN
#       CALL cl_err('lock ima fail',STATUS,1)
#        LET g_success='N' RETURN  1
#    END IF
#    FETCH ima2_lock INTO g_ima25_2  #,g_ima86_2 #FUN-560183
#    IF SQLCA.sqlcode THEN
#       CALL cl_err('lock ima fail',STATUS,1)
#        LET g_success='N' RETURN  1
#    END IF
#
#    CALL s_umfchk(p_imn.imn03,p_imn.imn09,l_img.img09) RETURNING g_cnt,l_factor
#    IF g_cnt = 1 THEN
#       CALL cl_err('','mfg3075',1)
#       LET g_success = 'N'
#       RETURN 1
#    END IF
#    LET l_qty = p_imn.imn10 * l_factor
#
#     CALL s_upimg(p_imn.imn03,p_imn.imn15,p_imn.imn16,p_imn.imn17,+1,l_qty,g_imm.imm02,      #FUN-8C0084
#        p_imn.imn03,p_imn.imn15,p_imn.imn16,p_imn.imn17,
#        p_imn.imn01,p_imn.imn02,l_img.img09,l_qty,      l_img.img09,
#        1,  l_img.img21,1,
#        g_credit,l_img.img35,l_img.img27,l_img.img28,l_img.img19,
#        l_img.img36)
#
#    IF g_success = 'N' THEN RETURN 1 END IF
#
##-->更新庫存主檔之庫存數量 (單位為主檔之庫存單位)
#    LET l_qty = p_imn.imn22 * l_img.img21
#    IF s_udima(p_imn.imn03,            #料件編號
#                           l_img.img23,            #是否可用倉儲
#                           l_img.img24,            #是否為MRP可用倉儲
#                           l_qty,                  #發料數量(換算為料件庫存單位)
#                          #l_img.img16,            #最近一次發料日期   #MOD-C30001 mark
#                           g_imm.imm02,                                #MOD-C30001
#                           +1)                     #表收料
#         THEN RETURN  1 END IF
#    IF g_success = 'N' THEN RETURN 1 END IF
##-->產生異動記錄檔
#    #---- 97/06/20 insert 兩筆至 tlf_file 一出一入
#    CALL t324_log_2(1,0,'1',p_imn.*) #RETURN 0
#    CALL t324_log_2(1,0,'0',p_imn.*) RETURN 0
#END FUNCTION
#
##處理異動記錄
#FUNCTION t324_log_2(p_stdc,p_reason,p_code,p_imn)
#DEFINE
#    p_stdc          LIKE type_file.num5,      #是否需取得標準成本  #No.FUN-690026 SMALLINT
#    p_reason        LIKE type_file.num5,      #是否需取得異動原因  #No.FUN-690026 SMALLINT
#    p_code          LIKE type_file.chr1,      #出/入庫  #No.FUN-690026 VARCHAR(1)
#    p_imn           RECORD LIKE imn_file.*
#DEFINE
#    l_img09         LIKE img_file.img09,
#    l_factor        LIKE ima_file.ima31_fac,  #No.FUN-690026 DECIMAL(16,8)
#    l_qty           LIKE img_file.img10
#
#    LET l_qty=0
#    SELECT img09 INTO l_img09 FROM img_file
#       WHERE img01=p_imn.imn03 AND img02=p_imn.imn15
#         AND img03=p_imn.imn16 AND img04=p_imn.imn17
#    CALL s_umfchk(p_imn.imn03,p_imn.imn09,l_img09) RETURNING g_cnt,l_factor
#    IF g_cnt = 1 THEN
#       CALL cl_err('','mfg3075',1)
#       LET g_success = 'N'
#       RETURN 1
#    END IF
#    LET l_qty = p_imn.imn10 * l_factor
#
#
##----來源----
#    LET g_tlf.tlf01=p_imn.imn03                 #異動料件編號
#    LET g_tlf.tlf02=50                          #來源為倉庫(撥出)
#    LET g_tlf.tlf020=g_plant                    #工廠別
#    LET g_tlf.tlf021=p_imn.imn04                #倉庫別
#    LET g_tlf.tlf022=p_imn.imn05                #儲位別
#    LET g_tlf.tlf023=p_imn.imn06                #批號
#    LET g_tlf.tlf024=g_img10 - p_imn.imn10      #異動後庫存數量
#    LET g_tlf.tlf025=p_imn.imn09                #庫存單位(ima_file or img_file)
#    LET g_tlf.tlf026=p_imn.imn01                #調撥單號
#    LET g_tlf.tlf027=p_imn.imn02                #項次
##----目的----
#    LET g_tlf.tlf03=50                          #資料目的為(撥入)
#    LET g_tlf.tlf030=g_plant                    #工廠別
#    LET g_tlf.tlf031=p_imn.imn15                #倉庫別
#    LET g_tlf.tlf032=p_imn.imn16                #儲位別
#    LET g_tlf.tlf033=p_imn.imn17                #批號
#     LET g_tlf.tlf034=g_img10_2 + l_qty          #異動後庫存量    #-No:MOD-57002
#    LET g_tlf.tlf035=p_imn.imn20                #庫存單位(ima_file or img_file)
#    LET g_tlf.tlf036=p_imn.imn01                #參考號碼
#    LET g_tlf.tlf037=p_imn.imn02                #項次
#
#    #---- 97/06/20 調撥作業來源目的碼
#    IF p_code='1' THEN #-- 出
#       LET g_tlf.tlf02=50
#       LET g_tlf.tlf03=99
#       LET g_tlf.tlf030=' '
#       LET g_tlf.tlf031=' '
#       LET g_tlf.tlf032=' '
#       LET g_tlf.tlf033=' '
#       LET g_tlf.tlf034=0
#       LET g_tlf.tlf035=' '
#       LET g_tlf.tlf036=' '
#       LET g_tlf.tlf037=0
#       LET g_tlf.tlf10=p_imn.imn10                 #調撥數量
#       LET g_tlf.tlf11=p_imn.imn09                 #撥出單位
#       LET g_tlf.tlf12=1                           #撥出/撥入庫存轉換率
#       LET g_tlf.tlf930=p_imn.imn9301  #FUN-670093
#    ELSE               #-- 入
#       LET g_tlf.tlf02=99
#       LET g_tlf.tlf03=50
#       LET g_tlf.tlf020=' '
#       LET g_tlf.tlf021=' '
#       LET g_tlf.tlf022=' '
#       LET g_tlf.tlf023=' '
#       LET g_tlf.tlf024=0
#       LET g_tlf.tlf025=' '
#       LET g_tlf.tlf026=' '
#       LET g_tlf.tlf027=0
#       LET g_tlf.tlf10=p_imn.imn22                 #調撥數量
#       LET g_tlf.tlf11=p_imn.imn20                 #撥入單位
#       LET g_tlf.tlf12=1                           #撥入/撥出庫存轉換率
#       LET g_tlf.tlf930=p_imn.imn9302  #FUN-670093
#    END IF
#
##--->異動數量
#    LET g_tlf.tlf04=' '                         #工作站
#    LET g_tlf.tlf05=' '                         #作業序號
#    LET g_tlf.tlf06=g_imm.imm02                 #發料日期
#    LET g_tlf.tlf07=g_today                     #異動資料產生日期
#    LET g_tlf.tlf08=TIME                        #異動資料產生時:分:秒
#    LET g_tlf.tlf09=g_user                      #產生人
#    LET g_tlf.tlf13='aimt324'                   #異動命令代號
#    LET g_tlf.tlf14=p_imn.imn28                 #異動原因
#    LET g_tlf.tlf15=g_debit                     #借方會計科目
#    LET g_tlf.tlf16=g_credit                    #貸方會計科目
#    LET g_tlf.tlf17=g_imm.imm09                 #remark
#    CALL s_imaQOH(p_imn.imn03)
#         RETURNING g_tlf.tlf18                  #異動後總庫存量
#   #LET g_tlf.tlf19= ' '                        #異動廠商/客戶編號      #MOD-A80004 mark
#    LET g_tlf.tlf19= g_imm.imm14                #異動廠商/客戶編號      #MOD-A80004 add
#    LET g_tlf.tlf20= ' '                        #project no.
#    CALL s_tlf(p_stdc,p_reason)
#END FUNCTION
#DEV-D30046 移至saimt324_sub.4gl --mark--end

#FUNCTION t324_x()  #CHI-D20008
FUNCTION t324_x(p_type)  #CHI-D20008
   DEFINE p_type    LIKE type_file.num5  #CHI-D20008 
   DEFINE l_flag    LIKE type_file.chr1  #CHI-D20008 
   
   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_imm.* FROM imm_file WHERE imm01=g_imm.imm01 
   IF g_imm.imm01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_imm.immconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF #FUN-660029
   #FUN-A60034  add str ---              
   IF g_imm.imm15 matches '[Ss]' THEN
        CALL cl_err('','apm-030',0) #送簽中, 不可修改資料!
        RETURN
   END IF
   IF g_imm.immconf='Y' AND g_imm.imm15 = "1" AND g_imm.immmksg = "Y"  THEN
      CALL cl_err('','mfg3168',0) #此張單據已核准, 不允許更改或取消
      RETURN
   END IF
   #FUN-A60034  add end ---  
   #CHI-D20008---begin 
   IF p_type = 1 THEN 
      IF g_imm.immconf='X' THEN RETURN END IF
   ELSE
      IF g_imm.immconf<>'X' THEN RETURN END IF
   END IF 
   #CHI-D20008---end
   BEGIN WORK

   OPEN t324_cl USING g_imm.imm01   
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_imm.imm01,SQLCA.sqlcode,0)
      CLOSE t324_cl
      ROLLBACK WORK
      RETURN
   ELSE
      FETCH t324_cl INTO g_imm.*
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_imm.imm01,SQLCA.sqlcode,0)
         CLOSE t324_cl
         ROLLBACK WORK
         RETURN
      END IF
   END IF
   #IF cl_void(0,0,g_imm.immconf) THEN #FUN-660029  #CHI-D20008
   IF p_type = 1 THEN LET l_flag = 'N' ELSE LET l_flag = 'X' END IF  #CHI-D20008
   IF cl_void(0,0,l_flag) THEN  #CHI-D20008
       IF NOT t324_icd_del_chk('') THEN
          ROLLBACK WORK
          RETURN
       END IF
        LET g_chr=g_imm.immconf
        #IF g_imm.immconf = 'N' THEN #CHI-D20008
        IF p_type = 1 THEN  #CHI-D20008
            LET g_imm.immconf = 'X'
            LET g_imm.imm15   = '9' #FUN-A60034 add
        ELSE
            LET g_imm.immconf = 'N'
            LET g_imm.imm15   = '0' #FUN-A60034 add
        END IF
       UPDATE imm_file
           SET immconf = g_imm.immconf, #FUN-660029
               imm15   = g_imm.imm15,   #FUN-A60034 add
               immmodu = g_user,
               immdate = g_today
           WHERE imm01 = g_imm.imm01 
       IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","imm_file",g_imm.imm01,"",SQLCA.sqlcode,"",
                         "upd imm03",1) #FUN-660029 #No:FUN-660156
           LET g_imm.immconf = g_chr #FUN-660029
       END IF
       DISPLAY BY NAME g_imm.immconf #FUN-660029
       DISPLAY BY NAME g_imm.imm15   #FUN-A60034 add
   END IF
   CLOSE t324_cl
   COMMIT WORK
   CALL cl_flow_notify(g_imm.imm01,'V')
END FUNCTION
#check 撥出:料/倉/儲/批
#(1)數量是否大於0
#(2)是否有效
#(3)重算撥出/入的換算率 及撥入數量
FUNCTION t324_chk_out()
  DEFINE l_img10 LIKE img_file.img10

     IF cl_null(g_imn[l_ac].imn05) THEN
        LET g_imn[l_ac].imn05 = ' '
     END IF
 
     IF cl_null(g_imn[l_ac].imn06) THEN
        LET g_imn[l_ac].imn06 = ' '
     END IF

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
        #CALL cl_err(g_imn[l_ac].imn06,'mfg6101',1)  #FUN-C80107 mark 121024
        #RETURN 1                                    #FUN-C80107 mark 121024
        #FUN-C80107 add begin--------------------------------------------121024
    #FUN-D30024 --------Begin--------
    #   INITIALIZE g_sma894 TO NULL
    #   CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_imn[l_ac].imn04) RETURNING g_sma894   #FUN-D30024
    #   IF g_sma894 = 'N' OR g_sma894 IS NULL THEN
        INITIALIZE g_imd23 TO NULL 
        CALL s_inv_shrt_by_warehouse(g_imn[l_ac].imn04,g_plant) RETURNING g_imd23                     #FUN-D30024 #TQC-D40078 g_plant
        IF g_imd23 =  'N' OR g_imd23 IS NULL THEN
    #FUN-D30024 --------End----------
           CALL cl_err(g_imn[l_ac].imn06,'mfg6101',1)
           RETURN 1
        ELSE
           IF g_sma.sma892[3,3] = 'Y' THEN
              IF NOT cl_confirm('mfg1401') THEN RETURN 1 END IF
           END IF
           CALL s_add_img(g_imn[l_ac].imn03,g_imn[l_ac].imn04,
                          g_imn[l_ac].imn05,g_imn[l_ac].imn06,
                          g_imm.imm01      ,g_imn[l_ac].imn02,
                          #g_imm.imm02)  #FUN-D40053
                          g_imm.imm17)  #FUN-D40053
           IF g_errno='N' THEN
              RETURN 1
           END IF
           SELECT img09,img10 INTO g_imn[l_ac].imn09,l_img10
             FROM img_file
            WHERE img01=g_imn[l_ac].imn03
              AND img02=g_imn[l_ac].imn04
              AND img03=g_imn[l_ac].imn05
              AND img04=g_imn[l_ac].imn06
        END IF
       #FUN-C80107 add end----------------------------------------------
    END IF
    IF l_img10 <=0 THEN
        #庫存不足是否許調撥出庫='N'
       #IF g_sma.sma894[4,4]='N' OR g_sma.sma894[4,4] IS NULL THEN                                #FUN-C80107 mark
    #FUN-D30024----------Begin----------
       #INITIALIZE g_sma894 TO NULL                                                               #FUN-C80107
       #CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_imn[l_ac].imn04) RETURNING g_sma894      #FUN-C80107  #FUN-D30024
       #IF g_sma894 = 'N' THEN                                                                    #FUN-C80107
        INITIALIZE g_imd23 TO NULL 
        CALL s_inv_shrt_by_warehouse(g_imn[l_ac].imn04,g_plant) RETURNING g_imd23                         #FUN-D30024 #TQC-D40078 g_plant
        IF g_imd23 = 'N' OR g_imd23 IS NULL THEN
    #FUN-D30024----------End------------
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
    IF g_imn[l_ac].imn09 <> g_imn_t.imn09 THEN
        #撥出:倉/儲/批的單位已變了,請注意撥出數量是否正確
        CALL cl_err('','aim-324',0)
    END IF
    RETURN 0
END FUNCTION

#check 撥入:料/倉/儲/批
#(1)是否有效
#(2)重算撥出/入的換算率 及撥入數量
FUNCTION t324_chk_in()

    IF cl_null(g_imn[l_ac].imn16) THEN
       LET g_imn[l_ac].imn16 = ' '
    END IF

    IF cl_null(g_imn[l_ac].imn17) THEN
       LET g_imn[l_ac].imn17 = ' '
    END IF

    SELECT img09 INTO g_imn[l_ac].imn20
      FROM img_file
     WHERE img01=g_imn[l_ac].imn03
       AND img02=g_imn[l_ac].imn15
       AND img03=g_imn[l_ac].imn16
       AND img04=g_imn[l_ac].imn17
    IF SQLCA.sqlcode THEN
       #CALL cl_err3("sel","img_file",'',"",SQLCA.sqlcode,"", #TQC-9C0013 #FUN-C80107 mark 121024
       #             "mfg6077",1) #No:FUN-660156   #FUN-C80107 mark 121024
       #RETURN 1                            #FUN-C80107 mark 121024
       #FUN-C80107 add begin--------------------------------------------121024
       IF g_sma.sma892[3,3] = 'Y' THEN
          IF NOT cl_confirm('mfg1401') THEN
             RETURN 1
          END IF
       END IF
       CALL s_add_img(g_imn[l_ac].imn03,g_imn[l_ac].imn15,
                      g_imn[l_ac].imn16,g_imn[l_ac].imn17,
                      g_imm.imm01      ,g_imn[l_ac].imn02,
                      #g_imm.imm02)  #FUN-D40053
                      g_imm.imm17)  #FUN-D40053
       IF g_errno='N' THEN
          RETURN 1
       END IF
       SELECT img09 INTO g_imn[l_ac].imn20
         FROM img_file
        WHERE img01=g_imn[l_ac].imn03
          AND img02=g_imn[l_ac].imn15
          AND img03=g_imn[l_ac].imn16
          AND img04=g_imn[l_ac].imn17
       #FUN-C80107 add end----------------------------------------------
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
    RETURN 0
END FUNCTION

#用于default 雙單位/轉換率/數量
FUNCTION t324_du_default(p_cmd,p_item,p_ware,p_loc,p_lot)
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

#對原來數量/換算率/單位的賦值
FUNCTION t324_set_origin_field()
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
          #-----MOD-A80088---------
          #WHEN '1' LET g_imn[l_ac].imn09=l_img09_s
          #         LET g_imn[l_ac].imn10=l_qty2*l_fac2
          #         LET g_imn[l_ac].imn20=l_img09_t
          #         LET g_imn[l_ac].imn22=l_qty4*l_fac4
          #WHEN '2' LET l_tot=l_qty1*l_fac1+l_qty2*l_fac2
          #         LET g_imn[l_ac].imn09=l_img09_s
          #         LET g_imn[l_ac].imn10=l_tot
          #         LET l_tot=l_qty3*l_fac3+l_qty4*l_fac4
          #         LET g_imn[l_ac].imn20=l_img09_t
          #         LET g_imn[l_ac].imn22=l_tot
          #WHEN '3' LET g_imn[l_ac].imn09=l_img09_s
          #         LET g_imn[l_ac].imn10=l_qty2*l_fac2
          #         LET g_imn[l_ac].imn20=l_img09_t
          #         LET g_imn[l_ac].imn22=l_qty4*l_fac4
          #         IF l_qty1 <> 0 THEN
          #            LET g_imn[l_ac].imn34=l_qty2/l_qty1
          #         ELSE
          #            LET g_imn[l_ac].imn34=0
          #         END IF
          #         IF l_qty3 <> 0 THEN
          #            LET g_imn[l_ac].imn44=l_qty4/l_qty3
          #         ELSE
          #            LET g_imn[l_ac].imn44=0
          #         END IF
          WHEN '1' LET g_imn[l_ac].imn09=g_imn[l_ac].imn30
                   LET g_imn[l_ac].imn10=g_imn[l_ac].imn32
                   LET g_imn[l_ac].imn20=g_imn[l_ac].imn40
                   LET g_imn[l_ac].imn22=g_imn[l_ac].imn42
          WHEN '2' LET l_tot=l_qty1*l_fac1+l_qty2*l_fac2
                   LET g_imn[l_ac].imn09=l_img09_s
                   LET g_imn[l_ac].imn10=l_tot
                   LET l_tot=l_qty3*l_fac3+l_qty4*l_fac4
                   LET g_imn[l_ac].imn20=l_img09_t
                   LET g_imn[l_ac].imn22=l_tot
          WHEN '3' LET g_imn[l_ac].imn09=g_imn[l_ac].imn30
                   LET g_imn[l_ac].imn10=g_imn[l_ac].imn32
                   LET g_imn[l_ac].imn20=g_imn[l_ac].imn40
                   LET g_imn[l_ac].imn22=g_imn[l_ac].imn42
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
          #-----END MOD-A80088-----
       END CASE
    END IF

    IF g_imn[l_ac].imn09 <> g_imn[l_ac].imn20 THEN
       CALL s_umfchk(g_imn[l_ac].imn03,g_imn[l_ac].imn09,g_imn[l_ac].imn20)
            RETURNING g_cnt,g_imn[l_ac].imn21
    ELSE
       LET g_imn[l_ac].imn21 = 1
    END IF

END FUNCTION

#以img09單位來計算雙單位所確定的數量
FUNCTION t324_tot_by_img09(p_item,p_fac2,p_qty2,p_fac1,p_qty1)
  DEFINE p_item    LIKE ima_file.ima01
  DEFINE p_fac2    LIKE img_file.img21
  DEFINE p_qty2    LIKE img_file.img10
  DEFINE p_fac1    LIKE img_file.img21
  DEFINE p_qty1    LIKE img_file.img10
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
FUNCTION t324_check_inventory_qty()
  DEFINE l_img10    LIKE img_file.img10
  DEFINE l_tot      LIKE img_file.img10
  DEFINE l_flag     LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)

    LET l_flag = '1'
    SELECT img10 INTO l_img10 FROM img_file
     WHERE img01 = g_imn[l_ac].imn03
       AND img02 = g_imn[l_ac].imn04
       AND img03 = g_imn[l_ac].imn05
       AND img04 = g_imn[l_ac].imn06

    CALL t324_tot_by_img09(g_imn[l_ac].imn03,g_imn[l_ac].imn34,g_imn[l_ac].imn35,
                           g_imn[l_ac].imn31,g_imn[l_ac].imn32)
         RETURNING l_tot
    IF l_img10 < l_tot THEN
       LET l_flag = '0'
    END IF
    RETURN l_flag
END FUNCTION

#檢查發料/報廢動作是否可以進行下去
FUNCTION t324_qty_issue()

    CALL t324_check_inventory_qty()  RETURNING g_flag
    IF g_flag = '0' THEN
      #IF g_sma.sma894[4,4]='N' OR g_sma.sma894[4,4] IS NULL THEN                                #FUN-C80107 mark
    #FUN-D30024 -------Begin----------
      #INITIALIZE g_sma894 TO NULL                                                               #FUN-C80107
      #CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_imn[l_ac].imn04) RETURNING g_sma894      #FUN-C80107 #FUN-D30024
      #IF g_sma894 = 'N' THEN                                                                    #FUN-C80107
       INITIALIZE g_imd23 TO NULL
       CALL s_inv_shrt_by_warehouse(g_imn[l_ac].imn04,g_plant) RETURNING g_imd23                         #FUN-D30024 #TQC-D40078 g_plant
       IF g_imd23 = 'N' OR g_imd23 IS NULL THEN
    #FUN-D30024 -------End------------
          CALL cl_err(g_imn[l_ac].imn03,'mfg1303',1)
          RETURN 1
       ELSE
          IF NOT cl_confirm('mfg3469') THEN
             RETURN 1
          END IF
      END IF
    END IF
 
    RETURN 0

END FUNCTION

#兩組雙單位資料不是一定要全部KEY,如果沒有KEY單位,則把換算率/數量清空
FUNCTION t324_du_data_to_correct()

   IF cl_null(g_imn[l_ac].imn33) THEN
      LET g_imn[l_ac].imn34 = NULL
      LET g_imn[l_ac].imn35 = NULL
   END IF
 
   IF cl_null(g_imn[l_ac].imn30) THEN
      LET g_imn[l_ac].imn31 = NULL
      LET g_imn[l_ac].imn32 = NULL
   END IF

   IF cl_null(g_imn[l_ac].imn43) THEN
      LET g_imn[l_ac].imn44 = NULL
      LET g_imn[l_ac].imn45 = NULL
   END IF
 
   IF cl_null(g_imn[l_ac].imn40) THEN
      LET g_imn[l_ac].imn41 = NULL
      LET g_imn[l_ac].imn42 = NULL
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

FUNCTION t324_def_form()
   CALL cl_set_comp_required("imn28",g_aza.aza115='Y')         #FUN-CB0087 add
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
    CALL cl_set_comp_entry("imn20,imn40,imn43",FALSE) #MOD-640226
    IF g_aaz.aaz90='Y' THEN
       CALL cl_set_comp_required("imm14",TRUE)
    END IF
    CALL cl_set_comp_visible("imn9301,gem02b,imn9302,gem02c",g_aaz.aaz90='Y')  #FUN-670093

    IF g_aza.aza64 matches '[ Nn]' THEN
       CALL cl_set_comp_visible("immspc",FALSE)
       CALL cl_set_act_visible("trans_spc",FALSE)
    END IF 

   CALL cl_set_act_visible("qry_lot,modi_lot",g_sma.sma95="Y")  #FUN-C80030 add
   CALL cl_set_comp_visible("Page2",g_sma.sma95="Y")            #FUN-C80030 add

END FUNCTION

FUNCTION t324_chk_jce(p_wip,p_wh1,p_wh2)
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

FUNCTION t324_set_target()
  DEFINE l_img09      LIKE img_file.img09      
  DEFINE l_ima906     LIKE ima_file.ima906      
  DEFINE l_ima01      LIKE ima_file.ima01      
  DEFINE l_factor     LIKE imn_file.imn41      
  DEFINE l_cnt        LIKE type_file.num5   
  LET g_imn[l_ac].imn40 = g_imn[l_ac].imn30 
  LET g_imn[l_ac].imn41 = g_imn[l_ac].imn31 
  LET g_imn[l_ac].imn42 = g_imn[l_ac].imn32 
  LET g_imn[l_ac].imn43 = g_imn[l_ac].imn33 
  LET g_imn[l_ac].imn44 = g_imn[l_ac].imn34 
  LET g_imn[l_ac].imn45 = g_imn[l_ac].imn35
  LET g_imn[l_ac].imn51 = 1 
  LET g_imn[l_ac].imn52 = 1
  SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01 = g_imn[l_ac].imn03
  IF g_sma.sma115 = 'Y' AND l_ima906 != '2' THEN
     SELECT img09 INTO l_img09 FROM img_file 
          WHERE img01 = g_imn[l_ac].imn03
            AND img02 = g_imn[l_ac].imn15
            AND img03 = g_imn[l_ac].imn16
            AND img04 = g_imn[l_ac].imn17
    
     IF NOT cl_null(l_img09) AND g_imn[l_ac].imn40 != l_img09 THEN 
        CALL s_umfchk(g_imn[l_ac].imn03,g_imn[l_ac].imn40,l_img09)
             RETURNING l_cnt,l_factor
        
        IF l_cnt = 1 THEN LET l_factor = 1 END IF
        LET g_imn[l_ac].imn41 = l_factor
     END IF
  END IF
  DISPLAY BY NAME g_imn[l_ac].imn40,
                  g_imn[l_ac].imn41,
                  g_imn[l_ac].imn42,
                  g_imn[l_ac].imn43,
                  g_imn[l_ac].imn44,
                  g_imn[l_ac].imn45,
                  g_imn[l_ac].imn51,
                  g_imn[l_ac].imn52 
END FUNCTION

FUNCTION t324_set_imn40()
   IF cl_null(g_imn[l_ac].imn40) THEN
      RETURN TRUE
   END IF
   IF g_ima906 = '2' THEN
      CALL s_chk_imgg(g_imn[l_ac].imn03,g_imn[l_ac].imn15,
                      g_imn[l_ac].imn16,g_imn[l_ac].imn17,
                      g_imn[l_ac].imn40) RETURNING g_flag
      IF g_flag = 1 THEN
         IF g_sma.sma892[3,3] = 'Y' THEN
            IF NOT cl_confirm('aim-995') THEN 
               RETURN FALSE
            END IF
         END IF
         CALL s_add_imgg(g_imn[l_ac].imn03,g_imn[l_ac].imn15,
                         g_imn[l_ac].imn16,g_imn[l_ac].imn17,
                         g_imn[l_ac].imn40,g_imn[l_ac].imn41,
                         g_imm.imm01,g_imn[l_ac].imn02,0)
              RETURNING g_flag
         IF g_flag = 1 THEN
               RETURN FALSE
         END IF
      END IF
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t324_set_imn43()
   IF cl_null(g_imn[l_ac].imn43) THEN
      RETURN TRUE
   END IF
   CALL s_chk_imgg(g_imn[l_ac].imn03,g_imn[l_ac].imn15,
                   g_imn[l_ac].imn16,g_imn[l_ac].imn17,
                   g_imn[l_ac].imn43) RETURNING g_flag
   IF g_flag = 1 THEN
      IF g_sma.sma892[3,3] = 'Y' THEN
         IF NOT cl_confirm('aim-995') THEN 
            RETURN FALSE
         END IF
      END IF
      CALL s_add_imgg(g_imn[l_ac].imn03,g_imn[l_ac].imn15,
                      g_imn[l_ac].imn16,g_imn[l_ac].imn17,
                      g_imn[l_ac].imn43,g_imn[l_ac].imn44,
                      g_imm.imm01,g_imn[l_ac].imn02,0)
           RETURNING g_flag
      IF g_flag = 1 THEN
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t324_refresh_detail()
  DEFINE l_compare          LIKE smy_file.smy62    
  DEFINE li_col_count       LIKE type_file.num5    #No.FUN-690026 SMALLINT
  DEFINE li_i, li_j         LIKE type_file.num5    #No.FUN-690026 SMALLINT
  DEFINE lc_agb03           LIKE agb_file.agb03
  DEFINE lr_agd             RECORD LIKE agd_file.*
  DEFINE lc_index           STRING
  DEFINE ls_combo_vals      STRING
  DEFINE ls_combo_txts      STRING
  DEFINE ls_sql             STRING
  DEFINE ls_show,ls_hide    STRING
  DEFINE l_gae04            LIKE gae_file.gae04
   
  #判斷是否進行料件多屬性新機制管理以及是否傳入了屬性群組
  IF ( g_sma.sma120 = 'Y' )AND( g_sma.sma907 = 'Y' )AND(NOT cl_null(lg_smy62)) THEN
     #首先判斷有無單身記錄，如果單身根本沒有東東，則按照默認的lg_smy62來決定
     #顯示什么組別的信息，如果有單身，則進行下面的邏輯判斷
     IF g_imn.getLength() = 0 THEN
        LET lg_group = lg_smy62
     ELSE   
       #讀取當前單身所有的料件資料，如果它們都屬于多屬性子料件，并且擁有一致的
       #屬性群組，則以該屬性群組作為顯示單身明細屬性的依據，如果有不統一的狀況
       #則返回一個NULL，下面將不顯示任明細屬性列
       FOR li_i = 1 TO g_imn.getLength()
         #如果某一個料件沒有對應的母料件(已經在前面的b_fill中取出來放在imx00中了)
         #則不進行下面判斷直接退出了
         IF  cl_null(g_imn[li_i].att00) THEN
            LET lg_group = ''
            EXIT FOR
         END IF
         SELECT imaag INTO l_compare FROM ima_file WHERE ima01 = g_imn[li_i].att00
         #第一次是賦值
         IF cl_null(lg_group) THEN 
            LET lg_group = l_compare
         #以后是比較   
         ELSE 
           #如果在單身料件屬于不同的屬性組則直接退出（不顯示這些東東)
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

     #到這里時lg_group中存放的已經是應該顯示的組別了，該變量是一個全局變量
     #在單身INPUT或開窗時都會用到，因為refresh函數被執行的時機較早，所以能保証在需要的時候有值
     SELECT COUNT(*) INTO li_col_count FROM agb_file WHERE agb01 = lg_group

     #走到這個分支說明是采用新機制，那么使用att00父料件編號代替imn03子料件編號來顯示
     #得到當前語言別下imn03的欄位標題
     SELECT gae04 INTO l_gae04 FROM gae_file 
       WHERE gae01 = g_prog AND gae02 = 'imn03' AND gae03 = g_lang
     CALL cl_set_comp_att_text("att00",l_gae04)
     
     #為了提高效率，把需要顯示和隱藏的欄位都放到各自的變量里，然后在結尾的地方一次性顯示或隱藏
     IF NOT cl_null(lg_group) THEN
        LET ls_hide = 'imn03,ima02'
        LET ls_show = 'att00'
     ELSE
        LET ls_hide = 'att00'
        LET ls_show = 'imn03,ima02'
     END IF

     #顯現該有的欄位,置換欄位格式
     CALL lr_agc.clear()  #因為這個過程可能會被執行多次，作為一個公共變量，每次執行之前必須要初始化
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
             
             #這里需要判別g_sma.sma908,如果是允許新增子料件則要把這些屬性設置成為REQUIRED的,否則要設成NOENTRY
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
#        IF NOT t324_check_imn03(.....)  THEN NEXT FIELD XXX END IF        
FUNCTION t324_check_imn03(p_field,p_ac)
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
  l_misc                      LIKE type_file.chr4,    #VAR CHAR -> CHAR #No.FUN-690026 VARCHAR(04)
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

   #FUN-C20002--start add---------------------------
   DEFINE l_ima154             LIKE ima_file.ima154
   DEFINE l_rcj03              LIKE rcj_file.rcj03
   DEFINE l_rtz07              LIKE rtz_file.rtz07
   DEFINE l_rtz08              LIKE rtz_file.rtz08
   #FUN-C20002--end add----------------------------
  
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
        CALL t324_set_no_entry_b()
        #FUN-540049  --begin
        CALL t324_set_required()
        #FUN-540049  --end

        RETURN TRUE,g_imn[l_ac].ima02,g_imn[l_ac].ima021 
     END IF  #注意這里沒有錯，所以返回TRUE
     
     #取出當前母料件包含的明細屬性的個數
     SELECT COUNT(*) INTO l_cnt FROM agb_file WHERE agb01 = 
        (SELECT imaag FROM ima_file WHERE ima01 = ls_pid)
     IF l_cnt = 0 THEN
        #MOD-640107 Add ,所有要返回TRUE的分支都要加這兩句話,原來下面的會被
        #注釋掉
        CALL t324_set_no_entry_b()
        #FUN-540049  --begin
        CALL t324_set_required()
        #FUN-540049  --end
         
         RETURN TRUE,g_imn[l_ac].ima02,g_imn[l_ac].ima021  
     END IF
     
     FOR li_i = 1 TO l_cnt
         #如果有任何一個明細屬性應該輸而沒有輸的則退出
         IF cl_null(arr_detail[p_ac].imx[li_i]) THEN 
            #MOD-640107 Add ,所有要返回TRUE的分支都要加這兩句話,原來下面的會被
            #注釋掉
            CALL t324_set_no_entry_b()
            #FUN-540049  --begin
            CALL t324_set_required()
            #FUN-540049  --end
            
            RETURN TRUE,g_imn[l_ac].ima02,g_imn[l_ac].ima021 
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
        RETURN FALSE,g_imn[l_ac].ima02,g_imn[l_ac].ima021                                                                                                                   
     END IF
     
     #調用cl_copy_ima將新生成的子料件插入到數據庫中
     IF cl_copy_ima(ls_pid,ls_value,ls_spec,l_param_list) = TRUE THEN
        #如果向其中成功插入記錄則同步插入屬性記錄到imx_file中去
        LET ls_value_fld = ls_value 
#       #如果向imx_file中插入記錄失敗則也應將ima_file中已經建立的紀錄刪除以保証兩邊
#       #記錄的完全同步
        IF SQLCA.sqlcode THEN
           RETURN FALSE,g_imn[l_ac].ima02,g_imn[l_ac].ima021 
        END IF
     END IF 
     #把生成的子料件賦給imn03，否則下面的檢查就沒有意義了
     LET g_imn[p_ac].imn03 = ls_value
  ELSE 
    IF ( p_field <> 'imn03' )AND( p_field <> 'imx00' ) THEN 
       RETURN FALSE,g_imn[l_ac].ima02,g_imn[l_ac].ima021 
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
        CALL cl_itemno_multi_att("imn03",g_imn[l_ac].imn03,"","1","3") RETURNING l_multi,g_imn[l_ac].imn03,g_imn[l_ac].ima02
        DISPLAY g_imn[l_ac].imn03 TO imn03                                                                               
        DISPLAY g_imn[l_ac].ima02 TO ima02                                                                               
     END IF
     SELECT ima02,ima021 INTO g_imn[l_ac].ima02,g_imn[l_ac].ima021 #CHI-6A0015 remark
        FROM ima_file
       WHERE ima01=g_imn[l_ac].imn03 AND imaacti = 'Y'  #genero add
     IF STATUS THEN
        CALL cl_err3("sel","ima_file",g_imn[l_ac].imn03,"",SQLCA.sqlcode,"",
                     "sel ima",1)   #NO.FUN-640266 #No:FUN-660156
        RETURN FALSE,g_imn[l_ac].ima02,g_imn[l_ac].ima021    #No:MOD-690044 add                                                                                                               
     END IF
       
     IF (cl_null(g_imn_t.imn03) OR g_imn_t.imn03 <> g_imn[l_ac].imn03 ) AND g_flag1 <> 'Y' THEN   #MOD-D20164 add  g_flag1 , ()
        #FUN-C20002--start add---------------------------------------------
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

              CALL s_get_defstore(g_plant,g_imn[l_ac].imn03) RETURNING l_rtz07,l_rtz08
        
              IF l_rcj03 = '1' THEN
                 LET g_imn[l_ac].imn04 = l_rtz07
              ELSE 
                 LET g_imn[l_ac].imn04 = l_rtz08
              END IF 
           END IF   
        ELSE   
        #FUN-C20002--end add----------------------------------------------- 
       LET g_imn[l_ac].imn06 = NULL
       SELECT ima35,ima36                                 
         INTO g_imn[l_ac].imn04,g_imn[l_ac].imn05   
          FROM ima_file
         WHERE ima01=g_imn[l_ac].imn03 AND imaacti = 'Y'  #genero add
       END IF    #FUN-C20002 add
#FUN-AB0066 --begin--  
#         #No.FUN-AA0049--begin
#         IF NOT s_chk_ware(g_imn[l_ac].imn04) THEN
#            LET g_imn[l_ac].imn04=' '
#            LET g_imn[l_ac].imn05=' '
#         END IF 
#         #No.FUN-AA0049--end                  
#FUN-AB0066 --end--         
     END IF
     DISPLAY BY NAME g_imn[l_ac].ima02
     DISPLAY BY NAME g_imn[l_ac].ima021
     IF g_sma.sma115 = 'Y' THEN
        CALL s_chk_va_setting(g_imn[l_ac].imn03)
             RETURNING g_flag,g_ima906,g_ima907
        IF g_flag=1 THEN
           RETURN FALSE,g_imn[l_ac].ima02,g_imn[l_ac].ima021 
        END IF
        IF g_ima906 = '3' THEN
             LET g_imn[l_ac].imn33=g_ima907
             LET g_imn[l_ac].imn43=g_ima907
             DISPLAY BY NAME g_imn[l_ac].imn33
             DISPLAY BY NAME g_imn[l_ac].imn43
        END IF
      END IF
      CALL t324_set_no_entry_b()
      CALL t324_set_required()
      LET g_imn_t.imn03=g_imn[l_ac].imn03
      RETURN TRUE,g_imn[l_ac].ima02,g_imn[l_ac].ima021
   ELSE
      IF ( p_field = 'imn03' )OR( p_field = 'imx00' ) THEN
         CALL t324_set_no_entry_b()                                                                                                    
         CALL t324_set_required()
         RETURN TRUE,g_imn[l_ac].ima02,g_imn[l_ac].ima021
      ELSE
         RETURN FALSE,g_imn[l_ac].ima02,g_imn[l_ac].ima021
      END IF
   END IF
END FUNCTION
         
#用于att01~att10這十個輸入型屬性欄位的AFTER FIELD事件的判斷函數
#傳入參數:p_value 要比較的欄位內容,p_index當前欄位的索引號(從1~10表示att01~att10)
#         p_row是當前行索引,傳入INPUT ARRAY中使用的l_ac即可
#與t324_check_imn03相同,如果檢查過程中如果發現錯誤,則報錯并返回一個FALSE
#而AFTER FIELD的時候檢測到這個返回值則會做NEXT FIELD
FUNCTION t324_check_att0x(p_value,p_index,p_row)
DEFINE
  p_value         LIKE imx_file.imx01,
  p_index         LIKE type_file.num5,    #No.FUN-690026 SMALLINT
  p_row           LIKE type_file.num5,    #No.FUN-690026 SMALLINT
  li_min_num      LIKE agc_file.agc05,
  li_max_num      LIKE agc_file.agc06,
  l_index         STRING,
  l_check_res     LIKE type_file.num5,    #No.FUN-690026 SMALLINT
  l_b2            LIKE ima_file.ima31,    #No.FUN-690026 VARCHAR(30)
  l_imaacti       LIKE ima_file.imaacti,
  l_ima130        LIKE ima_file.ima130,   #FUN-660078
  l_ima131        LIKE ima_file.ima131,   #FUN-660078
  l_ima25         LIKE ima_file.ima25 
  
  #這個欄位一旦進入了就不能忽略，因為要保証在輸入其他欄位之前必須要生成imn03料件編號
  IF cl_null(p_value) THEN 
     RETURN FALSE,g_imn[l_ac].ima02,g_imn[l_ac].ima021 
  END IF

  #這里使用到了一個用于存放當前屬性組包含的所有屬性信息的全局數組lr_agc
  #該數組會由t324_refresh_detail()函數在較早的時候填充
  
  #判斷長度與定義的使用位數是否相等
  IF LENGTH(p_value CLIPPED) <> lr_agc[p_index].agc03 THEN
     CALL cl_err_msg("","aim-911",lr_agc[p_index].agc03,1)
     RETURN FALSE,g_imn[l_ac].ima02,g_imn[l_ac].ima021 
  END IF
  #比較大小是否在合理范圍之內
  LET li_min_num = lr_agc[p_index].agc05
  LET li_max_num = lr_agc[p_index].agc06
  IF (lr_agc[p_index].agc05 IS NOT NULL) AND
     (p_value < li_min_num) THEN
     CALL cl_err_msg("","lib-232",lr_agc[p_index].agc05 || "|" || lr_agc[p_index].agc06,1)
     RETURN FALSE,g_imn[l_ac].ima02,g_imn[l_ac].ima021 
  END IF
  IF (lr_agc[p_index].agc06 IS NOT NULL) AND
     (p_value > li_max_num) THEN
     CALL cl_err_msg("","lib-232",lr_agc[p_index].agc05 || "|" || lr_agc[p_index].agc06,1)
     RETURN FALSE,g_imn[l_ac].ima02,g_imn[l_ac].ima021 
  END IF
  #通過了欄位檢查則可以下面的合成子料件代碼以及相應的檢核操作了
  LET arr_detail[p_row].imx[p_index] = p_value
  LET l_index = p_index USING '&&'
  CALL t324_check_imn03('imx' || l_index ,p_row) 
    RETURNING l_check_res,g_imn[l_ac].ima02,g_imn[l_ac].ima021 
    RETURN l_check_res,g_imn[l_ac].ima02,g_imn[l_ac].ima021 
END FUNCTION

#用于att01_c~att10_c這十個選擇型屬性欄位的AFTER FIELD事件的判斷函數
#傳入參數:p_value 要比較的欄位內容,p_index當前欄位的索引號(從1~10表示att01~att10)
#         p_row是當前行索引,傳入INPUT ARRAY中使用的l_ac即可
#與t324_check_imn03相同,如果檢查過程中如果發現錯誤,則報錯并返回一個FALSE
#而AFTER FIELD的時候檢測到這個返回值則會做NEXT FIELD
FUNCTION t324_check_att0x_c(p_value,p_index,p_row)
DEFINE
  p_value         LIKE imx_file.imx01,
  p_index         LIKE type_file.num5,    #No.FUN-690026 SMALLINT
  p_row           LIKE type_file.num5,    #No.FUN-690026 SMALLINT
  l_index         STRING,
  l_check_res     LIKE type_file.num5,    #No.FUN-690026 SMALLINT
  l_b2            LIKE ima_file.ima31,    #No.FUN-690026 VARCHAR(30)
  l_imaacti       LIKE ima_file.imaacti,
  l_ima130        LIKE ima_file.ima130,   #FUN-660078
  l_ima131        LIKE ima_file.ima131,   #FUN-660078
  l_ima25         LIKE ima_file.ima25


  #這個欄位一旦進入了就不能忽略，因為要保証在輸入其他欄位之前必須要生成imn03料件編號
  IF cl_null(p_value) THEN 
     RETURN FALSE,g_imn[l_ac].ima02,g_imn[l_ac].ima021 
  END IF       
  #下拉框選擇項相當簡單，不需要進行范圍和長度的判斷，因為肯定是符合要求的了  
  LET arr_detail[p_row].imx[p_index] = p_value
  LET l_index = p_index USING '&&'
  CALL t324_check_imn03('imx'||l_index,p_row)
  RETURNING l_check_res,g_imn[l_ac].ima02,g_imn[l_ac].ima021 
  RETURN l_check_res,g_imn[l_ac].ima02,g_imn[l_ac].ima021 
END FUNCTION         

#FUN-A60034---mark---str---
#FUNCTION t324_y_chk()
#   DEFINE l_cnt      LIKE type_file.num10   #No.FUN-690026 INTEGER
#   DEFINE b_imn      RECORD LIKE imn_file.*   #No:FUN-860045
#   DEFINE l_rvbs06   LIKE rvbs_file.rvbs06   #No:FUN-860045
#   DEFINE l_n        LIKE type_file.num10   #No.MOD-9C0380
#
#   LET g_success = 'Y'
#   IF cl_null(g_imm.imm01) THEN 
#      CALL cl_err('',-400,0) 
#      LET g_success = 'N'
#      RETURN 
#   END IF
#   
#   SELECT * INTO g_imm.* FROM imm_file WHERE imm01 = g_imm.imm01 
#
##FUN-AB0066 --begin--
#   IF NOT s_chk_ware(g_imm.imm08) THEN 
#      LET g_success = 'N'
#      RETURN 
#   END IF 
##FUN-AB0066 --end--
#   
#   IF g_imm.immconf='Y' THEN
#      LET g_success = 'N'           
#      CALL cl_err('','9023',0)      
#      RETURN
#   END IF
#
#   IF g_imm.immconf = 'X' THEN
#      LET g_success = 'N'   
#      CALL cl_err(' ','9024',0)
#      RETURN
#   END IF
#
#   SELECT COUNT(*) INTO l_cnt FROM imn_file  #No.MOD-A50162
#    WHERE imn01= g_imm.imm01                 #No.MOD-A50162
#   IF l_cnt = 0 THEN
#      LET g_success = 'N'   
#      CALL cl_err('','mfg-009',0)
#      RETURN
#   END IF
#
#   SELECT COUNT(*) INTO l_n FROM imn_file
#    WHERE imn01=g_imm.imm01
#      AND (imn04 IS NULL OR imn15 IS NULL)
#   IF l_n>0 THEN
#      CALL cl_err('','aim-149',1)
#      LET g_success = 'N'
#      RETURN
#   END IF
#
#   DECLARE t324_y_chk_c CURSOR FOR SELECT * FROM imn_file
#                                   WHERE imn01=g_imm.imm01
#
#   FOREACH t324_y_chk_c INTO b_imn.*
#
##FUN-AB0066 --begin--
#     IF NOT s_chk_ware(b_imn.imn04) THEN 
#        LET g_success = 'N'
#        RETURN 
#     END IF 
#     IF NOT s_chk_ware(b_imn.imn15) THEN 
#        LET g_success = 'N'
#        RETURN 
#     END IF    
##FUN-AB0066 --end--
#
#      SELECT ima918,ima921 INTO g_ima918,g_ima921 
#        FROM ima_file
#       WHERE ima01 = b_imn.imn03
#         AND imaacti = "Y"
#      
#      IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
#         SELECT SUM(rvbs06) INTO l_rvbs06
#           FROM rvbs_file
#          WHERE rvbs00 = g_prog
#            AND rvbs01 = b_imn.imn01
#            AND rvbs02 = b_imn.imn02
#            AND rvbs09 = -1
#            AND rvbs13 = 0
#            
#         IF cl_null(l_rvbs06) THEN
#            LET l_rvbs06 = 0
#         END IF
#            
#         IF b_imn.imn10 <> l_rvbs06 THEN
#            LET g_success = "N"
#            CALL cl_err(b_imn.imn03,"aim-011",1)
#            CONTINUE FOREACH
#         END IF
#      END IF
#   END FOREACH
#
#   IF g_success = 'N' THEN RETURN END IF
#
#END FUNCTION
#
#FUNCTION t324_y_upd()
#   IF g_bgjob='N' OR cl_null(g_bgjob) THEN   #No:FUN-840012
#      IF NOT cl_confirm('axm-108') THEN RETURN END IF
#   END IF
#   LET g_success = 'Y'
#   BEGIN WORK
#
#   OPEN t324_cl USING g_imm.imm01
#   IF STATUS THEN
#      CALL cl_err("OPEN t324_cl:", STATUS, 1)
#      CLOSE t324_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
#   FETCH t324_cl INTO g_imm.*          # 鎖住將被更改或取消的資料
#   IF SQLCA.sqlcode THEN
#       CALL cl_err(g_imm.imm01,SQLCA.sqlcode,0)     # 資料被他人LOCK
#       CLOSE t324_cl 
#       ROLLBACK WORK 
#       RETURN
#   END IF
#   CLOSE t324_cl
#   UPDATE imm_file SET immconf = 'Y' WHERE imm01 = g_imm.imm01 
#   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
#      CALL cl_err3("upd","imm_file",g_imm.imm01,"",SQLCA.sqlcode,"",
#                   "upd ummconf",1)  #No:FUN-660156
#      LET g_success = 'N'
#   END IF
#
#   IF g_success='Y' THEN
#      COMMIT WORK
#      LET g_imm.immconf='Y'
#      CALL cl_flow_notify(g_imm.imm01,'Y')
#   ELSE
#      ROLLBACK WORK
#      LET g_imm.immconf='N'
#   END IF
#   DISPLAY BY NAME g_imm.immconf
#   IF g_imm.immconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
#   CALL cl_set_field_pic(g_imm.immconf,"",g_imm.imm03,"",g_chr,"")
#END FUNCTION
#FUN-A60034---mark---end---

FUNCTION t324_z()
   DEFINE l_cnt     LIKE type_file.num5      #FUN-680010  #No.FUN-690026 SMALLINT

   IF cl_null(g_imm.imm01) THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_imm.* FROM imm_file WHERE imm01 = g_imm.imm01 
  #IF g_imm.immconf='N' THEN RETURN END IF                           #FUN-A60034 mark
   IF g_imm.immconf='N' THEN CALL cl_err('','9025',1) RETURN END IF  #FUN-A60034 add #此筆資料尚未確認, 不可取消確認
   IF g_imm.immconf = 'X' THEN CALL cl_err(' ','9024',0) RETURN END IF

   #-->已有QC單則不可取消確認
   SELECT COUNT(*) INTO l_cnt FROM qcs_file
    WHERE qcs01 = g_imm.imm01 AND qcs00='C'  
      AND qcs14 <> 'X'         #MOD-AB0161 add
   IF l_cnt > 0 THEN
      CALL cl_err(' ','aqc-118',0)
      RETURN
   END IF

   IF g_imm.imm03='Y' THEN
      CALL cl_err('imm03=Y:','afa-101',0)
      RETURN
   END IF

   #FUN-AC0074--begin--add----
    LET l_cnt = 0
    SELECT COUNT(*) INTO l_cnt
      FROM sie_file
     WHERE sie05=g_imm.imm01
    IF l_cnt > 0 THEN
       CALL cl_err('','axm-248',0)
       RETURN
    END IF
    #FUN-AC0074--end--add----

  #IF NOT cl_confirm('axm-109') THEN RETURN END IF    #MOD-AA0041 mark
   BEGIN WORK

   OPEN t324_cl USING g_imm.imm01  
   IF STATUS THEN
      CALL cl_err("OPEN t324_cl:", STATUS, 1)
      CLOSE t324_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t324_cl INTO g_imm.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_imm.imm01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t324_cl 
      ROLLBACK WORK 
      RETURN
   END IF
  #MOD-AA0103---modify---start---
  #IF NOT cl_confirm('axm-109') THEN RETURN END IF    #MOD-AA0041 add 
  #CLOSE t324_cl
   IF NOT cl_confirm('axm-109') THEN 
      CLOSE t324_cl 
      ROLLBACK WORK 
      RETURN 
   END IF    
  #MOD-AA0103---modify---end---
   LET g_success = 'Y'
   UPDATE imm_file 
      SET immconf = 'N',
          imm15 = '0'  #FUN-A60034 add
    WHERE imm01 = g_imm.imm01 
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
      LET g_success = 'N' 
   END IF
   IF g_success = 'Y' THEN
      LET g_imm.immconf='N'
      LET g_imm.imm15='0'                       #FUN-A60034 add
      COMMIT WORK
      DISPLAY BY NAME g_imm.immconf,g_imm.imm15 #FUN-A60034 add imm15
   ELSE
      LET g_imm.immconf='Y'
      LET g_imm.imm15='1' #FUN-A60034 add
      ROLLBACK WORK
   END IF
   CLOSE t324_cl          #MOD-AA0103 add
   IF g_imm.immconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_imm.immconf,"",g_imm.imm03,"",g_chr,"")
END FUNCTION

FUNCTION t324_spc()
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
   IF g_imm.imm03 matches '[Yy]' THEN    #判斷是否已過帳
      CALL cl_err('imm03','aim-318',0)
      LET g_success='N'
      RETURN
   END IF

   #CALL aws_spccli_check('單號','SPC拋轉碼','確認碼','有效碼')
   CALL aws_spccli_check(g_imm.imm01,g_imm.immspc,g_imm.immconf,'')
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
   LET l_sql  = "SELECT imn02 FROM imn_file                   WHERE imn01 = '",g_imm.imm01,"' AND imn29='Y'"
   PREPARE t324_imn_p FROM l_sql
   DECLARE t324_imn_c CURSOR WITH HOLD FOR t324_imn_p
   FOREACH t324_imn_c INTO l_imn02
       display l_cmd
       LET l_cmd = l_qc_prog CLIPPED," '",g_imm.imm01,"' '",l_imn02,"' '1' 'SPC' 'C'"
       CALL aws_spccli_qc(l_qc_prog,l_cmd)
   END FOREACH 

   #判斷產生的 QC 單筆數是否正確
   SELECT COUNT(*) INTO l_cnt FROM qcs_file WHERE qcs01 = g_imm.imm01
   IF l_cnt <> l_qc_cnt THEN
      CALL t324_qcs_del()
      LET g_success='N'
      RETURN
   END IF
 
   LET l_sql  = "SELECT *  FROM qcs_file WHERE qcs01 = '",g_imm.imm01,"'"
   PREPARE t324_qc_p FROM l_sql
   DECLARE t324_qc_c CURSOR WITH HOLD FOR t324_qc_p
   LET l_cnt = 1
   FOREACH t324_qc_c INTO l_qcs[l_cnt].*
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
      CALL t324_qcs_del()
   END IF

   UPDATE imm_file set immspc = g_imm.immspc WHERE imm01 = g_imm.imm01 
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","imm_file",g_imm.imm01,"",STATUS,"","upd immspc",1)
      IF g_imm.immspc = '1' THEN
          CALL t324_qcs_del()
      END IF
      LET g_success = 'N'
   END IF
   DISPLAY BY NAME g_imm.immspc
  
END FUNCTION 

#CHI-C30002 -------- mark -------- begin
#FUNCTION i000_delall()

#  SELECT COUNT(*) INTO g_cnt FROM imn_file
#   WHERE imn01 = g_imm.imm01 

#  IF g_cnt = 0 THEN
#     CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#     ERROR g_msg CLIPPED
#     DELETE FROM imm_file WHERE imm01 = g_imm.imm01
#     CLEAR FORM
#     INITIALIZE g_imm.* TO NULL
#     CALL g_imn.clear()
#  END IF

#END FUNCTION
#CHI-C30002 -------- mark -------- end

FUNCTION t324_qcs_del()

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

      DELETE FROM qcu_file WHERE qcu01 = g_imm.imm01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","qcu_file",g_imm.imm01,"",SQLCA.sqlcode,"","DEL qcu_file err!",0)
      END IF

      DELETE FROM qcv_file WHERE qcv01 = g_imm.imm01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","qcv_file",g_imm.imm01,"",SQLCA.sqlcode,"","DEL qcv_file err!",0)
      END IF

END FUNCTION 

FUNCTION t324_ins_rvbs()
   DEFINE l_rvbs   RECORD LIKE rvbs_file.*

   DELETE FROM rvbs_file WHERE rvbs00 = g_prog
                           AND rvbs01 = g_imm.imm01
                           AND rvbs02 = g_imn[l_ac].imn02
                           AND rvbs13 = 0
                           AND rvbs09 = 1
   
   DECLARE t324_g_rvbs CURSOR FOR SELECT * FROM rvbs_file
                                   WHERE rvbs00 = g_prog
                                     AND rvbs01 = g_imm.imm01
                                     AND rvbs02 = g_imn[l_ac].imn02
                                     AND rvbs13 = 0
                                     AND rvbs09 = -1
             
   FOREACH t324_g_rvbs INTO l_rvbs.*
      IF STATUS THEN                          
         CALL cl_err('rvbs',STATUS,1)
      END IF
   
      LET l_rvbs.rvbs09 = 1
      LET l_rvbs.rvbsplant = g_plant #FUN-980004 add
      LET l_rvbs.rvbslegal = g_legal #FUN-980004 add

      INSERT INTO rvbs_file VALUES(l_rvbs.*)
      IF STATUS OR SQLCA.SQLCODE THEN
         CALL cl_err3("ins","rvbs_file","","",SQLCA.sqlcode,"","ins rvbs",1) 
         LET g_success='N'
      END IF
   
   END FOREACH

END FUNCTION
FUNCTION t324_icd_del_chk(p_imn02)
   DEFINE p_imn02   LIKE imn_file.imn02,
          l_cntout  LIKE type_file.num5,
          l_cntin   LIKE type_file.num5,
          l_flag    LIKE type_file.num5

   LET l_flag = 1
   LET l_cntin = 0
   LET l_cntout = 0
   IF cl_null(p_imn02) THEN
      SELECT COUNT(*) INTO l_cntout FROM idb_file
       WHERE idb07 = g_imm.imm01

      SELECT COUNT(*) INTO l_cntin FROM ida_file
       WHERE ida07 = g_imm.imm01
   ELSE 
      SELECT COUNT(*) INTO l_cntout FROM idb_file
       WHERE idb07 = g_imm.imm01
         AND idb08 = p_imn02

      SELECT COUNT(*) INTO l_cntin FROM ida_file
       WHERE ida07 = g_imm.imm01
         AND ida08 = p_imn02
   END IF

   IF l_cntin = 0 AND l_cntout = 0 THEN RETURN l_flag END IF #沒有刻號/BIN資料

   IF NOT cl_confirm('aic-112') THEN    #放棄刪除
      LET l_flag = 0
      RETURN l_flag
   END IF

   CASE
       WHEN l_cntout > 0 AND l_cntin = 0    #只有出庫資料
            IF cl_null(p_imn02) THEN
               CALL s_icdinout_del(-1,g_imm.imm01,'','') RETURNING l_flag       #FUN-B80119--傳入p_plant參數''---
            ELSE
               CALL s_icdinout_del(-1,g_imm.imm01,p_imn02,'') RETURNING l_flag  #FUN-B80119--傳入p_plant參數''---
            END IF
       WHEN l_cntout = 0 AND l_cntin > 0    #只有入庫資料
            IF cl_null(p_imn02) THEN
               CALL s_icdinout_del(1,g_imm.imm01,'','') RETURNING l_flag        #FUN-B80119--傳入p_plant參數''---
            ELSE
               CALL s_icdinout_del(1,g_imm.imm01,p_imn02,'') RETURNING l_flag   #FUN-B80119--傳入p_plant參數''---
            END IF
       WHEN l_cntout > 0 AND l_cntin > 0    #出入庫資料
            IF cl_null(p_imn02) THEN
               CALL s_icdinout_del(-1,g_imm.imm01,'','') RETURNING l_flag        #FUN-B80119--傳入p_plant參數''---
               IF l_flag THEN 
                  CALL s_icdinout_del(1,g_imm.imm01,'','') RETURNING l_flag      #FUN-B80119--傳入p_plant參數''---
               END IF
            ELSE
               CALL s_icdinout_del(-1,g_imm.imm01,p_imn02,'') RETURNING l_flag   #FUN-B80119--傳入p_plant參數''---
               IF l_flag THEN
                  CALL s_icdinout_del(1,g_imm.imm01,p_imn02,'') RETURNING l_flag #FUN-B80119--傳入p_plant參數''---
               END IF
            END IF
   END CASE
   RETURN l_flag
END FUNCTION

#檢查是否有ida/idb存在
FUNCTION t324_chk_icd()                                                         
    LET g_errno = ' '

    #檢查出庫
    LET g_cnt = 0                                                               
    SELECT COUNT(*) INTO g_cnt FROM idb_file                      
     WHERE idb07 = g_imm.imm01                                   
       AND idb08 = g_imn_t.imn02                                 

    IF g_cnt > 0 THEN                                                           
       LET g_errno = 'aic-113'                                                  
       RETURN
    END IF                                                                      
                                                                                
    #檢查入庫
    LET g_cnt = 0                                                               
    SELECT COUNT(*) INTO g_cnt FROM ida_file                       
     WHERE ida07 = g_imm.imm01                                    
       AND ida08 = g_imn_t.imn02                                 

    IF g_cnt > 0 THEN                                                           
       LET g_errno = 'aic-113'                                                  
    ELSE                                                                        
       LET g_errno = SQLCA.SQLCODE USING '-------'                              
    END IF                                                                      
END FUNCTION      
#料號位參考單位，單一單位，狀態為其他生產料號（imaicd04=3,4）時，
#將單位一的資料給單位二
FUNCTION t324_set_value()
   DEFINE l_ima906    LIKE ima_file.ima906,
          l_imaicd04  LIKE imaicd_file.imaicd04
   IF g_sma.sma115 = 'Y' THEN
      LET l_ima906 = NULL
      LET l_imaicd04 = NULL
      SELECT ima906,imaicd04 INTO l_ima906,l_imaicd04 FROM ima_file,imaicd_file
       WHERE ima01 = g_imn[l_ac].imn03 
         AND ima01 = imaicd00
      IF NOT cl_null(l_ima906) AND l_ima906 MATCHES '[13]' THEN
         IF l_imaicd04 MATCHES '[34]' THEN
            LET g_imn[l_ac].imn33 = g_imn[l_ac].imn30  #單位
            LET g_imn[l_ac].imn35 = g_imn[l_ac].imn32  #數量
            LET g_imn[l_ac].imn34 = g_imn[l_ac].imn32/g_imn[l_ac].imn35

            LET g_imn[l_ac].imn43 = g_imn[l_ac].imn40  #單位
            LET g_imn[l_ac].imn45 = g_imn[l_ac].imn42  #數量
            LET g_imn[l_ac].imn44 = g_imn[l_ac].imn42/g_imn[l_ac].imn45

            LET b_imn.imn33= g_imn[l_ac].imn33
            LET b_imn.imn34= g_imn[l_ac].imn34
            LET b_imn.imn35= g_imn[l_ac].imn35

            LET b_imn.imn43= g_imn[l_ac].imn43
            LET b_imn.imn44= g_imn[l_ac].imn44
            LET b_imn.imn45= g_imn[l_ac].imn45

            DISPLAY BY NAME g_imn[l_ac].imn33,
                            g_imn[l_ac].imn34,
                            g_imn[l_ac].imn35,
                            g_imn[l_ac].imn43,
                            g_imn[l_ac].imn44,
                            g_imn[l_ac].imn45
         END IF
      END IF
   END IF
END FUNCTION

#更改die數
#當料號為wafer段時，imaicd04=1,用dice數量加總給原將單據的第二單位數量
#當料號為wafer段時，imaicd04=2,用pass bin = 'Y'數量加總給原將單據的第二單位數量
FUNCTION t324_upd_dies()
   DEFINE l_ima906    LIKE ima_file.ima906,
          l_imaicd04  LIKE imaicd_file.imaicd04
          #l_imaicd08  LIKE imaicd_file.imaicd08   #FUN-B30187 #FUN-BA0051 mark
   DEFINE l_idbsum    LIKE type_file.num10         #MOD-C30517       
          
   BEGIN WORK            #FUN-B30187
   LET g_success = 'Y'   #FUN-B30187
   
   IF g_sma.sma115 = 'Y' THEN
      LET l_ima906 = NULL
      LET l_imaicd04 = NULL
      SELECT ima906,imaicd04 INTO l_ima906,l_imaicd04   #FUN-B30187 加imaicd08 #FUN-BA0051 mark imaicd08
       FROM ima_file,imaicd_file
       WHERE ima01 = g_imn[l_ac].imn03 
         AND ima01 = imaicd00
      IF NOT cl_null(l_ima906) AND l_ima906 MATCHES '[13]' THEN
         IF l_imaicd04 MATCHES '[12]' THEN
            LET g_imn[l_ac].imn35 = g_dies      #數量       
            LET g_imn[l_ac].imn34 = g_imn[l_ac].imn32/g_imn[l_ac].imn35

            LET g_imn[l_ac].imn45 = g_dies      #數量       
            LET g_imn[l_ac].imn44 = g_imn[l_ac].imn42/g_imn[l_ac].imn45

            #BEGIN WORK   #FUN-B30187 mark
            UPDATE imn_file set imn34 = g_imn[l_ac].imn34,
                                imn35 = g_imn[l_ac].imn35,
                                imn44 = g_imn[l_ac].imn44,
                                imn45 = g_imn[l_ac].imn45 
             WHERE imn01=g_imm.imm01 AND imn02=g_imn[l_ac].imn02
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               LET g_imn[l_ac].imn34 = b_imn.imn34
               LET g_imn[l_ac].imn35 = b_imn.imn35
               LET g_imn[l_ac].imn44 = b_imn.imn44
               LET g_imn[l_ac].imn45 = b_imn.imn45
               LET g_success  = 'N'   #FUN-B30187
               #ROLLBACK WORK         #FUN-B30187 mark
            ELSE
               LET b_imn.imn34 = g_imn[l_ac].imn34
               LET b_imn.imn35 = g_imn[l_ac].imn35
               LET b_imn.imn44 = g_imn[l_ac].imn44
               LET b_imn.imn45 = g_imn[l_ac].imn45
               #COMMIT WORK           #FUN-B30187 mark
            END IF
            DISPLAY BY NAME g_imn[l_ac].imn34, g_imn[l_ac].imn35,
                            g_imn[l_ac].imn44, g_imn[l_ac].imn45
         END IF
      END IF
   END IF
   #FUN-BA0051 --START mark--
   ##FUN-B70061 --START--
   #IF cl_null(l_imaicd08) THEN
   #    SELECT imaicd08 INTO l_imaicd08 FROM imaicd_file 
   #     WHERE imaicd00 = g_imn[l_ac].imn03
   #END IF
   ##FUN-B70061 --END--
   # 
   ##FUN-B30187 --START--    
   # IF l_imaicd08 = 'Y' THEN
   #FUN-BA0051 --END mark--
    IF s_icdbin(g_imn[l_ac].imn03) THEN   #FUN-BA0051 
       LET g_sql = "SELECT idb14 FROM idb_file",   #FUN-BC0109 del idb15
                   " WHERE idb07 = '", g_imm.imm01, "'",
                    " AND idb08 =", g_imn[l_ac].imn02      
       DECLARE t324_upd_dia_c CURSOR FROM g_sql            
       OPEN t324_upd_dia_c                                       
       FETCH t324_upd_dia_c INTO g_imn[l_ac].imniicd029   #FUN-BC0109 del ,g_imn[l_ac].imniicd028
       
       #串接Date Code值
       CALL s_icdfun_datecode('1',g_imm.imm01,g_imn[l_ac].imn02) 
                                RETURNING g_imn[l_ac].imniicd028   #FUN-BC0109 
       
       
       UPDATE imni_file set imniicd029 = g_imn[l_ac].imniicd029,
        imniicd028 = g_imn[l_ac].imniicd028
        WHERE imni01=g_imm.imm01 AND imni02=g_imn[l_ac].imn02 
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          LET g_imn[l_ac].imniicd029 = b_imni.imniicd029
          LET g_imn[l_ac].imniicd028 = b_imni.imniicd028
          LET g_success  = 'N'
       ELSE
          LET b_imni.imniicd029 = g_imn[l_ac].imniicd029
          LET b_imni.imniicd028 = g_imn[l_ac].imniicd028
          LET g_success  = 'Y'
       END IF 
       DISPLAY BY NAME g_imn[l_ac].imniicd029, g_imn[l_ac].imniicd028       
    END IF
    
    IF g_success = 'Y' THEN
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
    #FUN-B30187 --END-- 
    #MOD-C30517---begin
    LET l_idbsum = 0
    SELECT SUM(idb11) INTO l_idbsum FROM idb_file 
     WHERE idb01 = g_imn[l_ac].imn03
     AND   idb02 = g_imn[l_ac].imn04
     AND   idb03 = g_imn[l_ac].imn05
     AND   idb04 = g_imn[l_ac].imn06
     AND   idb07 = g_imm.imm01
     AND   idb08 = g_imn[l_ac].imn02
     IF l_idbsum <> g_imn[l_ac].imn10 THEN 
        CALL cl_err(g_imn[l_ac].imn03,'aim-042',1)
     END IF 
    #MOD-C30517---end
END FUNCTION

FUNCTION aimt324_g()    #####依BOM或工單自動展開單身
DEFINE  l_chr       LIKE type_file.chr1 
DEFINE  l_cnt       LIKE type_file.num5
DEFINE  l_azf09     LIKE azf_file.azf09  #TQC-9B0031

    OPEN WINDOW aimt324_w WITH FORM "aim/42f/aimt324_g"                                                           
             ATTRIBUTE (STYLE = g_win_style CLIPPED) 
                                                                                                                                    
    CALL cl_ui_locale("aimt324_g")                                                                                             
    LET l_chr='1' 

    LET l_imn04 = NULL
    LET l_imn05 = NULL
    LET l_imn16 = NULL
    LET l_imn15 = NULL
    LET l_imn28 = NULL
    INPUT l_chr,l_imn04,l_imn05,l_imn15,l_imn16,l_imn28                                                                             
        WITHOUT DEFAULTS FROM FORMONLY.a,FORMONLY.imn04,FORMONLY.imn05,                                                             
                              FORMONLY.imn15,FORMONLY.imn16,FORMONLY.imn28
    #FUN-BC0036 --START--
    BEFORE INPUT
       IF g_argv0 = '2' THEN
          LET l_chr='1'
          EXIT INPUT 
       END IF
    #FUN-BC0036 --END--   
    AFTER FIELD a                                                                                                             
       IF l_chr NOT MATCHES '[123]' THEN 
          NEXT FIELD a                                                                                                         
       END IF                                                                                                                  
                                                                                                                                    
    AFTER FIELD imn04 
       IF NOT cl_null(l_imn04) THEN  
          LET g_flag1 = 'Y'           #MOD-D20164   
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
          #FUN-D20060---add---str
          IF NOT s_chksmz(' ', g_imm.imm01,
                          l_imn04, l_imn05) THEN
              NEXT FIELD imn04
          END IF
          #FUN-D20060---add--end                                                                                                    
	IF NOT t324_imechk(l_imn04,l_imn05) THEN NEXT FIELD imn05 END IF  #FUN-D40103 add
       END IF
    AFTER FIELD imn05 
	 IF cl_null(l_imn05) THEN LET l_imn05 = ' ' END IF                 #FUN-D40103 add
       IF NOT t324_imechk(l_imn04,l_imn05) THEN NEXT FIELD imn05 END IF  #FUN-D40103 add
       IF NOT cl_null(l_imn05) THEN                                                                                          
	 #FUN-D40103--mark--str--
         # SELECT COUNT(*) INTO l_cnt FROM ime_file WHERE ime01= l_imn04
         #                                            AND ime02= l_imn05
         #                                            AND ime05='Y'                                                               
         # IF l_cnt=0 OR (SQLCA.sqlcode) THEN                                                                                     
         ##    CALL cl_err3("sel","ime_file",l_imn05,"","100","","sel ime",1)                                                  
         #    NEXT FIELD imn05                                                                                                    
         # END IF                     
	 #FUN-D40103--mark--end--
          ##FUN-D20060---add---str
          IF NOT cl_null(l_imn04) THEN
             IF NOT s_chksmz(' ', g_imm.imm01,
                             l_imn04, l_imn05) THEN
                 NEXT FIELD imn04
             END IF
          END IF
          #FUN-D20060---add--end                                                                                             
       END IF 
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
          ##FUN-D20060---add---str
          IF NOT s_chksmz(' ', g_imm.imm01,
                          l_imn15, l_imn16) THEN
             NEXT FIELD imn15
           END IF
          #FUN-D20060---add--end                                                                                                                    
	IF NOT t324_imechk(l_imn15,l_imn16) THEN NEXT FIELD imn16 END IF  #FUN-D40103 add
       END IF                                                                                                                       
    AFTER FIELD imn16                                                                                                               
	IF cl_null(l_imn16) THEN LET l_imn16 = ' ' END IF                 #FUN-D40103 add
       IF NOT t324_imechk(l_imn15,l_imn16) THEN NEXT FIELD imn16 END IF  #FUN-D40103 add
       IF NOT cl_null(l_imn16) THEN                                                                                                 
	 #FUN-D40103--mark--str--
         # SELECT COUNT(*) INTO l_cnt FROM ime_file WHERE ime01= l_imn15                                                             
         #                                            AND ime02= l_imn16                                                             
         #                                            AND ime05='Y'                                                                  
         # IF l_cnt=0 OR (SQLCA.sqlcode) THEN                                                                                        
         #    CALL cl_err3("sel","ime_file",l_imn16,"","100","","sel ime",1)                                                         
         #    NEXT FIELD imn16                                                                                                      
         # END IF             
	 #FUN-D40103--mark--end--
          ##FUN-D20060---add---str
          IF NOT cl_null(l_imn15) THEN
             IF NOT s_chksmz(' ', g_imm.imm01,
                             l_imn15, l_imn16) THEN
                 NEXT FIELD imn15
             END IF
          END IF
          #FUN-D20060---add--end                                                                                                       
       END IF   

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
 
    ON ACTION CONTROLR                                                                                                        
       CALL cl_show_req_fields()                                                                                              
                                                                                                                                 
    ON ACTION CONTROLG                                                                                                        
       CALL cl_cmdask()                                                                                                       
                                                                                                                                    
    AFTER INPUT                                                                                                               
       IF INT_FLAG THEN                         # 若按了DEL鍵                                                                 
          LET INT_FLAG = 0 
          LET l_chr = '1'                       #MOD-C80182 add   
          EXIT INPUT                                                                                                          
       END IF     

      #MOD-C80182 str add-----
       IF NOT cl_null(l_imn04) AND NOT cl_null(l_imn15) THEN
          CALL t324_chk_jce(g_wip,l_imn04,l_imn15)
          IF NOT cl_null(g_errno) THEN
             CALL cl_err('',g_errno,1)
             NEXT FIELD imn04
          END IF
       END IF
      #MOD-C80182 end add-----       
                                                                                                                                    
       ON IDLE g_idle_seconds                                                                                                    
          CALL cl_on_idle()                                                                                                      
          CONTINUE INPUT                                                                                                         
                                              
       ON ACTION controlp                                                                                                           
          CASE                                                                                                                      
             WHEN INFIELD(imn04)    #撥出倉庫別 
                #No.FUN-AA0049--begin
                #CALL cl_init_qry_var()  
                #LET g_qryparam.form ="q_imd"  
                #LET g_qryparam.default1 = l_imn04 
                #LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-A20083 add W
                #CALL cl_create_qry() RETURNING l_imn04 
                CALL q_imd_1(FALSE,TRUE,l_imn04,"","","","") RETURNING l_imn04
                #No.FUN-AA0049--end
                NEXT FIELD imn04  
             WHEN INFIELD(imn05)   #撥出儲位
                #No.FUN-AA0049--begin
                #CALL cl_init_qry_var()                                                                                              
                #LET g_qryparam.form ="q_ime"                                                                                        
                #LET g_qryparam.default1 = l_imn05
                #LET g_qryparam.arg1     = l_imn04 #倉庫編號                                                                     
                #LET g_qryparam.arg2     = 'SW'        #倉庫類別 #MOD-A20083 add W                                                               
                #CALL cl_create_qry() RETURNING l_imn05                
                CALL q_ime_1(FALSE,TRUE,l_imn05,l_imn04,"",g_plant,"","","") RETURNING l_imn05 
                #No.FUN-AA0049--end 
                NEXT FIELD imn05 
             WHEN INFIELD(imn15)   #撥入倉庫別
                #No.FUN-AA0049--begin
                #CALL cl_init_qry_var()                                                                                              
                #LET g_qryparam.form ="q_imd"                                                                                        
                #LET g_qryparam.default1 = l_imn15                                                                                   
                #LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-A20083 add W                                                                     
                #CALL cl_create_qry() RETURNING l_imn15                              
               #CALL q_imd_1(FALSE,TRUE,l_imn04,"","","","") RETURNING l_imn04
                CALL q_imd_1(FALSE,TRUE,l_imn04,"","","","") RETURNING l_imn15  #Mod No:TQC-AC0333
                #No.FUN-AA0049--end                                                
                NEXT FIELD imn15                                                                                                    
             WHEN INFIELD(imn16)   #撥出儲位
                #No.FUN-AA0049--begin                                                                                        
                #CALL cl_init_qry_var()                                                                                              
                #LET g_qryparam.form ="q_ime"                                                                                        
                #LET g_qryparam.default1 = l_imn15                                                                                   
                #LET g_qryparam.arg1     = l_imn16 #倉庫編號                                                                         
                #LET g_qryparam.arg2     = 'SW'        #倉庫類別 #MOD-A20083 add W                                                               
                #CALL cl_create_qry() RETURNING l_imn16  
                CALL q_ime_1(FALSE,TRUE,l_imn16,l_imn15,"",g_plant,"","","") RETURNING l_imn16 
                #No.FUN-AA0049--end                                                                             
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
    CLOSE WINDOW aimt324_w                 #結束畫面 
    IF cl_null(l_chr) THEN                                                                                                    
       LET l_chr = '1'                                                                                                        
    END IF                                                                                                                    
    LET g_rec_b = 0                                                                                                           
    CASE                                                                                                                      
      WHEN l_chr = '1'                                                                                                        
           CALL g_imn.clear()                                                                                                 
           CALL t324_b()                                                                                                      
      WHEN l_chr = '2'                                                                                                        
           CALL t324_wo(g_imm.imm01)                                                                                         
           COMMIT WORK                                                                                                        
           LET g_wc2=NULL                                                                                                     
           CALL t324_b_fill(g_wc2)                                                                                            
           LET g_action_choice="detail"                                                                                       
           IF cl_chk_act_auth() THEN                                                                                          
              CALL t324_b()                                                                                                   
           ELSE                                                                                                               
              RETURN                                                                                                          
           END IF                                                                                                             
      WHEN l_chr='3'                                                                                                          
           CALL t324_bom(g_imm.imm01)                                                                                             
           LET g_wc2=NULL
           CALL t324_b_fill(g_wc2)                                                                                            
           LET g_action_choice="detail"             
           IF cl_chk_act_auth() THEN                                                                                          
              CALL t324_b()                                                                                                   
           ELSE                                                                                                               
              RETURN                                                                                                          
           END IF                                                                                                             
      OTHERWISE EXIT CASE                                                                                                     
      END CASE                                                                                                                  
      LET g_imm_t.* = g_imm.*                # 保存上筆資料                                                                     
      LET g_imm_o.* = g_imm.*                # 保存上筆資料                                                                     
END FUNCTION

FUNCTION t324_bom(p_argv1)
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
    OPEN WINDOW aimt324_g1_w AT 6,30 WITH FORM "aim/42f/aimt324_g1"                                                                          
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
                                                                                                                                    
    CALL cl_ui_locale("aimt324_g1")                                                                                                    
                                                                                                                                    
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
    IF INT_FLAG THEN LET INT_FLAG=0 CLOSE WINDOW aimt324_g1_w RETURN END IF                                                               
    CALL aimt324_init()                                                                                                                
    CALL aimt324_bom()                                                                                                                 
    CLOSE WINDOW aimt324_g1_w                                                                                                             
    EXIT WHILE                                                                                                                      
END WHILE    
END FUNCTION

FUNCTION aimt324_init()
    LET b_imn.imn06 = ' ' 
    LET b_imn.imn29 = 'N'
    LET b_imn.imn51 = 1
    LET b_imn.imn52 = 1
    LET b_imn.imn9301=s_costcenter(g_imm.imm14)
    LET b_imn.imn9302=b_imn.imn9301 
END FUNCTION 

###展BOM
FUNCTION aimt324_bom()
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
    CALL aimt324_bom2(0,tm.part,l_ima910,tm.qty,1)
    IF g_ccc=0 THEN                                                                                                              
       LET g_errno='asf-014'                                                                                                    
    END IF    #有BOM但無有效者                                                                                                   
                                                                                                                                    
    MESSAGE ""                                                                                                                      
    RETURN                                                                                                                          
END FUNCTION

FUNCTION aimt324_bom2(p_level,p_key,p_key2,p_total,p_QPA) 
                                                                                                                                    
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
DEFINE  l_imm01      LIKE imm_file.imm01   #FUN-B30053
DEFINE  l_smy57      LIKE smy_file.smy57   #FUN-B30053
DEFINE  l_store      STRING                #FUN-CB0087 add
                                                                                                                                    
    LET p_level = p_level + 1                                                                                                       
    LET arrno = 500                                                                                                                 
        LET l_cmd=" SELECT 0,bmb03,bmb16,bmb06/bmb07,bmb08,bmb10,bmb10_fac,",                                                       
                 #"     ima08,ima02,ima05,ima44,ima25,ima44_fac,ima49,ima491,ima24,bma01 ", #TQC-9B0031 add ima24  
                  "     ima08,ima02,ima05,ima44,ima25,ima44_fac,ima49,ima491,'',bma01 ", #TQC-9B0031 add ima24  #FUN-B30053 ima24-->''
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
                    CALL aimt324_bom2(p_level,sr[l_i].bmb03,l_ima910[l_i], 
                        p_total*sr[l_i].bmb06,l_ActualQPA)                                                                          
                END IF                                                                                                              
            END IF                                                                                                                  
                                                                                                                                    
                                                                                                                                    
            IF sr[l_i].ima08='M' OR                                                                                                 
               sr[l_i].ima08='S' THEN     ###為 M PART 由人決定                                                                     
               IF tm.a='Y' THEN                                                                                                     
                  IF sr[l_i].bma01 IS NOT NULL THEN 
                     CALL aimt324_bom2(p_level,sr[l_i].bmb03,l_ima910[l_i],   
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
#FUN-AB0066 --begin--
#                  #No.FUN-AA0049--begin
#                  IF NOT s_chk_ware(b_imn.imn04) THEN
#                     LET b_imn.imn04=' '
#                     LET b_imn.imn15=' '
#                  END IF 
#                  #No.FUN-AA0049--end                      
#FUN-AB0066 --end--                  
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
                    CALL t324_du_default(p_cmd,b_imn.imn03,b_imn.imn04,                                           
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
                        CALL t324_du_default(p_cmd,b_imn.imn03,b_imn.imn04,                                           
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
                  #FUN-BC0036 --START--
                  IF g_argv0 = '2' THEN
                     LET b_imn.imn15 = b_imn.imn04
                     LET b_imn.imn16 = b_imn.imn05
                     LET b_imn.imn17 = b_imn.imn06
                     LET b_imn.imn20 = b_imn.imn09
                  END IF 
                  #FUN-BC0036 --END--
                  LET b_imn.imn20 = b_imn.imn09 #TQC-9B0031
                  LET b_imn.imnplant = g_plant #TQC-9B0031
                  LET b_imn.imnlegal = g_legal #TQC-9B0031
                  IF cl_null(b_imn.imn05) THEN LET b_imn.imn05 = ' ' END IF  #TQC-9B0031
                  IF cl_null(b_imn.imn06) THEN LET b_imn.imn06 = ' ' END IF  #TQC-9B0031
                  IF cl_null(b_imn.imn16) THEN LET b_imn.imn16 = ' ' END IF  #TQC-9B0031
                  IF cl_null(b_imn.imn17) THEN LET b_imn.imn17 = ' ' END IF  #TQC-9B0031
                  #FUN-CB0087---add---str---
                  IF g_aza.aza115 = 'Y' THEN
                     IF cl_null(b_imn.imn28) THEN
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
                        LET b_imn.imn28 = s_reason_code(b_imn.imn01,'','',b_imn.imn03,l_store,g_imm.imm16,g_imm.imm14)
                     END IF
                  END IF
                  #FUN-CB0087---add---end---
                  INSERT INTO imn_file VALUES(b_imn.*)
                  IF SQLCA.SQLCODE THEN                                                                                             
                     ERROR 'ALC2: Insert Failed because of ',SQLCA.SQLCODE
                  #FUN-B30187 --START--
                  ELSE          
                     LET b_imni.imni01 = b_imn.imn01
                     LET b_imni.imni02 = b_imn.imn02
                     LET b_imni.imnilegal = b_imn.imnlegal
                     LET b_imni.imniplant = b_imn.imnplant
                     IF NOT s_ins_imni(b_imni.*,b_imn.imnplant) THEN                
                     END IF 
                  #FUN-B30187 --END--                     
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

FUNCTION t324_wo(p_argv1)
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
       OPEN WINDOW aimt324_wo_g          #條件畫面                                                                   
              WITH FORM "aim/42f/aimt324_wo"                                                                                        
          ATTRIBUTE (STYLE = g_win_style CLIPPED)                                                                                   
       CALL cl_ui_locale("aimt324_wo")                                                                                              
    END IF                                                                                                                          
    CALL t324_wo_tm()                                                                                                               
    IF INT_FLAG THEN                                                                                                                
       CLOSE WINDOW aimt324_wo_g                                                                                                    
       EXIT WHILE                                                                                                                   
    END IF                                                                                                                          
    #-->無符合條件資料                                                                                                              
    IF l_sw = 'N' THEN                                                                                                              
       CALL cl_err(g_imm.imm01,'mfg2601',0)                                                                                         
        CONTINUE WHILE                                                                                                              
    END IF
    CALL cl_wait()                                                                                                                  
    CALL aimt324_wo_g()                                                                                                             
    #-->無符合條件資料                                                                                                              
    IF l_sw = 'N' THEN                                                                                                              
       CALL cl_err(g_imm.imm01,'mfg2601',0)                                                                                         
       CONTINUE WHILE                                                                                                               
    END IF                                                                                                                          
    ERROR ""                                                                                                                        
    EXIT WHILE                                                                                                                      
 END WHILE                                                                                                                          
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF                                                                                 
    CLOSE WINDOW aimt324_wo_g    
END FUNCTION

FUNCTION t324_wo_tm()
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
                                                                                                                                    
    PREPARE p324_predate  FROM l_sql                                                                                                
    DECLARE p324_curdate CURSOR FOR p324_predate                                                                                    
    LET l_sw = 'Y'                                                                                                                  
    FOREACH p324_curdate INTO l_wobdate,l_woedate                                                                                   
        IF SQLCA.sqlcode THEN                                                                                                       
           CALL cl_err('p324_curdate',SQLCA.sqlcode,0)                                                                              
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

FUNCTION aimt324_wo_g()
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
    LET l_sql = "SELECT UNIQUE sfa03,sfa26,sfb25,sfb98,sfa12,'',sum(sfa05) ", #TQC-9B0031 add sfa12,sfa05,ima24  #FUN-B30053 ima24-->''
                "  FROM sfa_file,sfb_file,ima_file",                                                                                
                " WHERE sfa01 = sfb01 ",                                                                                            
                "   AND sfb04 != '8' ",                                                                                             
                "  AND sfb02 != '2'  AND sfb02 != '11' AND sfb87!='X' ",                                                            
                "  AND sfa065 = 0 ",                                                                                                
                "   AND sfa03 = ima01 AND ", g_wc CLIPPED,                                                                          
               #" GROUP BY sfa03,sfa26,sfb25,sfb98,sfa12,ima24", #TQC-9B0031                                                                               
                " GROUP BY sfa03,sfa26,sfb25,sfb98,sfa12",  #FUN-B30053 del ima24
                " ORDER BY sfa03,sfa26,sfb25,sfb98"   #TQC-9B0031                                                                                              
    PREPARE t324_wo_prepare FROM l_sql                                                                                              
    DECLARE t324_wo_cs
        CURSOR WITH HOLD FOR t324_wo_prepare                                                                                        
    #-->單身預設值                                                                                                                  
    CALL aimt324_init()
    SELECT max(imn02)+1 INTO g_seq FROM imn_file WHERE imn01 = g_imm.imm01                                                          
    IF g_seq IS NULL OR g_seq = ' ' OR g_seq = 0  THEN                                                                              
       LET g_seq = 1                                                                                                                
    END IF                                                                                                                          
    LET l_sw = 'N'                                                                                                                  
    LET g_success = 'Y'                                                                                                             
    BEGIN WORK                                                                                                                      
    CALL s_showmsg_init()                                                                                                           
    FOREACH t324_wo_cs INTO l_sfa03,l_sfa26,l_sfb25,l_sfb98,l_sfa12,l_ima24,l_sfa05  #TQC-9B0031                                                                         
       IF SQLCA.sqlcode THEN                                                                                                        
         LET g_success = 'N'                                                                                                        
         IF g_bgerr THEN                                                                                                            
             CALL s_errmsg("sfa03",l_sfa03,"t324_wo_cs",SQLCA.sqlcode,1)  #TQC-9B0037                                                                    
         ELSE                                                                                                                       
            CALL cl_err('t324_wo_cs',SQLCA.sqlcode,0)    #TQC-9B0037
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
       CALL aimt324_wo_ins_imn(l_sfa03,l_sfa26,l_sfb25,l_sfb98,l_sfa12,l_ima24,l_sfa05) #TQC-9B0031                                                                     
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

FUNCTION aimt324_wo_ins_imn(p_sfa03,p_sfa26,p_sfb25,p_sfb98,p_sfa12,p_ima24,p_sfa05) #TQC-9B0031                                                                       
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
DEFINE l_store  STRING                #FUN-CB0087 add

   INITIALIZE b_imn.* TO NULL    #TQC-9B0031
   LET b_imn.imn01 = g_imm.imm01 #TQC-9B0031
   LET b_imn.imn03 = p_sfa03
   SELECT ima35,ima36 INTO b_imn.imn04,b_imn.imn05   #撥出倉儲                                                                 
     FROM ima_file                    
    WHERE ima01 = p_sfa03
    
#FUN-AB0066 --begin--    
#   #No.FUN-AA0049--begin
#   IF NOT s_chk_ware(g_imn[l_ac].imn04) THEN
#      LET b_imn.imn04=' '
#      LET b_imn.imn05=' '
#   END IF 
#   #No.FUN-AA0049--end       
#FUN-AB0066 --end--

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
          CALL t324_du_default(p_cmd,b_imn.imn03,b_imn.imn04,
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
    #FUN-BC0036 --START--
    IF g_argv0 = '2' THEN
       LET b_imn.imn15 = b_imn.imn04
       LET b_imn.imn16 = b_imn.imn05
       LET b_imn.imn17 = b_imn.imn06
       LET b_imn.imn20 = b_imn.imn09
    END IF 
    #FUN-BC0036 --END--
    LET b_imn.imnplant = g_plant #TQC-9B0031
    LET b_imn.imnlegal = g_legal #TQC-9B0031
    IF cl_null(b_imn.imn05) THEN LET b_imn.imn05 = ' ' END IF  #TQC-9B0031
    IF cl_null(b_imn.imn06) THEN LET b_imn.imn06 = ' ' END IF  #TQC-9B0031
    IF cl_null(b_imn.imn16) THEN LET b_imn.imn16 = ' ' END IF  #TQC-9B0031
    IF cl_null(b_imn.imn17) THEN LET b_imn.imn17 = ' ' END IF  #TQC-9B0031
    #FUN-CB0087---add---str---
    IF g_aza.aza115 = 'Y' THEN
       IF cl_null(b_imn.imn28) THEN
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
          LET b_imn.imn28 = s_reason_code(b_imn.imn01,'','',b_imn.imn03,l_store,g_imm.imm16,g_imm.imm14)
       END IF
    END IF
    #FUN-CB0087---add---end---
    INSERT INTO imn_file VALUES(b_imn.*)                     
    IF SQLCA.SQLCODE THEN                                     
       CALL cl_err('insert',SQLCA.sqlcode,0)                  #TQC-9B0037
    ELSE 
       #FUN-B30187 --START--         
       LET b_imni.imni01 = b_imn.imn01
       LET b_imni.imni02 = b_imn.imn02
       LET b_imni.imnilegal = b_imn.imnlegal
       LET b_imni.imniplant = b_imn.imnplant
       IF NOT s_ins_imni(b_imni.*,b_imn.imnplant) THEN                
       END IF 
       #FUN-B30187 --END--                     
    END IF
    LET g_seq = g_seq+1
END FUNCTION

FUNCTION t324_del()
   DELETE FROM imn_file WHERE imn01 = g_imm.imm01
   #FUN-B30187 --START--
    IF NOT s_del_imni(g_imm.imm01,'','') THEN
       #不作處理        
    END IF
    #FUN-B30187 --END--
END FUNCTION
#No.FUN-9C0072 精簡程式碼

#-----MOD-A70068---------
#DEV-D30046 移至saimt324_sub.4gl --mark--begin
#FUNCTION t324_chk_avl_stk(p_imn)   
#  DEFINE l_avl_stk,l_avl_stk_mpsmrp,l_unavl_stk  LIKE type_file.num15_3
#  DEFINE l_oeb12   LIKE oeb_file.oeb12
#  DEFINE l_qoh     LIKE oeb_file.oeb12 
#  DEFINE p_imn     RECORD LIKE imn_file.*   
#  DEFINE l_ima25   LIKE ima_file.ima25
#
#      
#     CALL s_getstock(p_imn.imn03,g_plant)RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk   
#     SELECT SUM(oeb905*oeb05_fac)
#      INTO l_oeb12
#      FROM oeb_file,oea_file   
#     WHERE oeb04=p_imn.imn03
#       AND oeb19= 'Y'
#       AND oeb70= 'N'  
#       AND oea01 = oeb01 AND oeaconf !='X' 
#    IF l_oeb12 IS NULL THEN
#        LET l_oeb12 = 0
#    END IF
#    LET l_qoh = l_avl_stk - l_oeb12
#    SELECT ima25 INTO l_ima25 FROM ima_file
#      WHERE ima01 = b_imn.imn03
#    CALL s_umfchk(b_imn.imn03,p_imn.imn09,l_ima25)
#         RETURNING g_sw,g_factor
#   #IF l_qoh < p_imn.imn10*g_factor AND g_sma.sma894[4,4]='N' THEN                      #FUN-C80107 mark 
#   #FUN-D30024 -------Begin---------
#   #INITIALIZE g_sma894 TO NULL                                                         #FUN-C80107
#   #CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],p_imn.imn04) RETURNING g_sma894      #FUN-C80107 #FUN-D30024 
#   #IF l_qoh < p_imn.imn10*g_factor AND g_sma894 = 'N' THEN                             #FUN-C80107
#    INITIALIZE g_imd23 TO NULL 
#    CALL s_inv_shrt_by_warehouse(p_imn.imn04) RETURNING g_imd23                        #FUN-D30024
#    IF l_qoh < p_imn.imn10*g_factor AND g_imd23 = 'N' THEN
#   #FUN-D30024 -------End-----------
#       LET g_msg = 'Line#',p_imn.imn02 USING '<<<',' ',
#                    p_imn.imn03 CLIPPED,'-> QOH < 0 '
#       CALL cl_err(g_msg,'mfg-075',1)   
#       LET g_success='N' RETURN
#    END IF 
#
#END FUNCTION
#DEV-D30046 移至saimt324_sub.4gl --mark--end
#-----END MOD-A70068-----

#FUN-A60034---add----str---
FUNCTION t324_ef()

    #CALL t324_y_chk()                   #CALL 原確認的 check 段 #FUN-A60034 mark #CALL原確認的check段後,再執行送簽
     CALL t324sub_y_chk(g_imm.imm01)     #CALL 原確認的 check 段 #FUN-A60034 add
     IF g_success = "N" THEN
         RETURN
     END IF

     CALL aws_condition() #判斷送簽資料
     IF g_success = 'N' THEN
         RETURN
     END IF
##########
# CALL aws_efcli2()
# 傳入參數: (1)單頭資料, (2-6)單身資料
# 回傳值  : 0 開單失敗; 1 開單成功
##########

   IF aws_efcli2(base.TypeInfo.create(g_imm),base.TypeInfo.create(g_imn),'','','','')
   THEN
       LET g_success='Y'
       LET g_imm.imm15='S'
       DISPLAY BY NAME g_imm.imm15
   ELSE
       LET g_success='N'
   END IF
END FUNCTION
#FUN-A60034---add----end---

#FUN-A60034 add str ------
FUNCTION t324_imm16(p_cmd)  #申請人編號
 DEFINE   p_cmd      LIKE type_file.chr1,          
          l_gen02    LIKE gen_file.gen02,
          l_genacti  LIKE gen_file.genacti

    LET g_errno = ' '

    SELECT gen02,genacti INTO l_gen02,l_genacti
      FROM gen_file
     WHERE gen01 = g_imm.imm16
    CASE
        WHEN SQLCA.SQLCODE = 100 LET g_errno ='mfg1312'
                                 LET l_gen02 = NULL
                                 LET l_genacti = NULL
        WHEN l_genacti = 'N' LET g_errno = '9028'
        OTHERWISE            LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE

   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_gen02 TO FORMONLY.gen02
   END IF
END FUNCTION
#FUN-A60034 add end -----

#FUN-B30187 --START--
FUNCTION t324_def_imniicd029()
DEFINE l_idc10    LIKE idc_file.idc10,
       l_idc11    LIKE idc_file.idc11
DEFINE l_flag     LIKE type_file.num10

   CALL s_icdfun_def_slot(g_imn[l_ac].imn03,g_imn[l_ac].imn04,g_imn[l_ac].imn05,
                          g_imn[l_ac].imn06) RETURNING l_flag,l_idc10,l_idc11   
   IF l_flag = 1 THEN 
      LET g_imn[l_ac].imniicd029 = l_idc10
      LET g_imn[l_ac].imniicd028 = l_idc11      
      DISPLAY BY NAME g_imn[l_ac].imniicd029,g_imn[l_ac].imniicd028
   END IF 
END FUNCTION
#FUN-B30187 --END--
#FUN-CB0087---add---str---
FUNCTION t324_imn28_chk()
DEFINE l_flag       LIKE type_file.chr1,
       l_sql        STRING,
       l_where      STRING,
       l_n          LIKE type_file.num5,
       l_i          LIKE type_file.num5,
       l_store      STRING,
       l_azf03         LIKE azf_file.azf03,
       l_azf09         LIKE azf_file.azf09
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
         CALL s_get_where(g_imm.imm01,'','',g_imn[l_i].imn03,l_store,g_imm.imm16,g_imm.imm14) RETURNING l_flag,l_where
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
            SELECT azf03,azf09 INTO l_azf03,l_azf09 FROM azf_file   
            WHERE azf01 = g_imn[l_i].imn28 AND azf02 = '2'

            CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3088'
                                           LET l_azf03 = ''
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
 
FUNCTION t324_imn28_chk1()
DEFINE  l_flag          LIKE type_file.chr1,
        l_n             LIKE type_file.num5,
        l_where         STRING,
        l_sql           STRING,
        l_store         STRING,
        l_azf03         LIKE azf_file.azf03,
        l_azf09         LIKE azf_file.azf09
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
         CALL s_get_where(g_imm.imm01,'','',g_imn[l_ac].imn03,l_store,g_imm.imm16,g_imm.imm14) RETURNING l_flag,l_where
      END IF
      IF g_aza.aza115='Y' AND l_flag THEN
         LET l_sql = " SELECT COUNT(*) FROM ggc_file WHERE ggc08='",g_imn[l_ac].imn28,"' AND ",l_where
         PREPARE ggc08_pre FROM l_sql
         EXECUTE ggc08_pre INTO l_n
         IF l_n < 1 THEN
            CALL cl_err('','aim-425',0)
            RETURN FALSE
         END IF
      ELSE
         #SELECT COUNT(*) INTO l_n FROM azf_file WHERE azf01 = g_imn[l_ac].imn28 AND azf02 = '2'
         #IF l_n < 1 THEN
         #   CALL cl_err('','aim-425',0)
         LET g_errno = ''
         SELECT azf03,azf09 INTO l_azf03,l_azf09 FROM azf_file   
         WHERE azf01 = g_imn[l_ac].imn28 AND azf02 = '2'

         CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3088'
                                        LET l_azf03 = ''
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

FUNCTION t324_azf03()

   SELECT azf03 INTO g_imn[l_ac].azf03
     FROM azf_file
    WHERE azf01 = g_imn[l_ac].imn28
      AND azf02 = '2'
   DISPLAY BY NAME g_imn[l_ac].azf03
END FUNCTION
#FUN-CB0087---add---end---

#FUN-D10081---add---str---
FUNCTION t324_list_fill()
  DEFINE l_imm01         LIKE imm_file.imm01
  DEFINE l_i             LIKE type_file.num10

    CALL g_imm_l.clear()
    LET l_i = 1
    FOREACH t324_fill_cs INTO l_imm01
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach item_cur',SQLCA.sqlcode,1)
          CONTINUE FOREACH
       END IF
       SELECT imm01,imm02,imm14,gem02,imm16,gen02,imm09,
              immmksg,imm15,immconf,imm03
         INTO g_imm_l[l_i].*
         FROM imm_file
              LEFT OUTER JOIN gem_file ON gem01 = imm14
              LEFT OUTER JOIN gen_file ON gen01 = imm16
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

FUNCTION t324_bp2(p_ud)
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
         LET g_no_ask = TRUE
         IF g_rec_b4 > 0 THEN
             CALL t324_fetch('/')
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
         LET g_no_ask = TRUE
         CALL t324_fetch('/')  
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
         CALL t324_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY                   
 
      ON ACTION previous
         CALL t324_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY                   
 
      ON ACTION jump
         CALL t324_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY                   

      ON ACTION next
         CALL t324_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY                    
 
      ON ACTION last
         CALL t324_fetch('L')
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
         CALL t324_def_form()   
         IF g_imm.immconf = 'X' THEN 
            LET g_void = 'Y'
         ELSE
            LET g_void = 'N'
         END IF
         CALL cl_set_field_pic(g_imm.immconf,"",g_imm.imm03,"",g_void,"") 

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY 
   #@ ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY 
   #@ ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
   #@ ON ACTION 過帳
      ON ACTION post
         LET g_action_choice="post"
         EXIT DISPLAY
   #@ ON ACTION 過帳還原
      ON ACTION undo_post
         LET g_action_choice="undo_post"
         EXIT DISPLAY 
   #@ ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY 
      #CHI-D20008---begin
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY 
      #CHI-D20008---end 
      ON ACTION aic_s_icdqry_in
         LET g_action_choice="aic_s_icdqry_in"
         EXIT DISPLAY

      ON ACTION aic_s_icdqry_out
         LET g_action_choice="aic_s_icdqry_out"
         EXIT DISPLAY 

      ON ACTION aic_s_icdout
         LET g_action_choice="aic_s_icdout"
         EXIT DISPLAY 
 
      ON ACTION CANCEL
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

      ON ACTION approval_status #簽核狀況
         LET g_action_choice="approval_status"
         EXIT DISPLAY

      ON ACTION easyflow_approval #easyflow送簽
         LET g_action_choice = "easyflow_approval"
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

    #@ON ACTION 拋轉至SPC
      ON ACTION trans_spc                     
         LET g_action_choice="trans_spc"
         EXIT DISPLAY 

      ON ACTION related_document                
         LET g_action_choice="related_document"          
         EXIT DISPLAY    
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        

      ON ACTION qry_lot
         LET g_action_choice="qry_lot"
         EXIT DISPLAY

      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
      
END FUNCTION 
#FUN-D10081---add---end

#No:DEV-D30026--add--begin
FUNCTION t324_chk_smyb(p_ima01)
  DEFINE p_ima01    LIKE ima_file.ima01
  DEFINE l_smyb01   LIKE smyb_file.smyb01
  DEFINE l_ima930   LIKE ima_file.ima930
  DEFINE l_ima932   LIKE ima_file.ima932

  LET g_errno = ''
  IF g_aza.aza131 <> 'Y' OR
     cl_null(g_imm.imm01) OR cl_null(p_ima01) THEN
     RETURN
  END IF

  LET g_t1 = s_get_doc_no(g_imm.imm01)
  LET l_smyb01 = ''
  SELECT smyb01 INTO l_smyb01
    FROM smyb_file
   WHERE smybslip = g_t1

  IF cl_null(l_smyb01) THEN
      LET l_smyb01 = '1' #1:非條碼單據
  END IF

  LET l_ima930 = ''
  LET l_ima932 = ''
  SELECT ima930,ima932
    INTO l_ima930,l_ima932
    FROM ima_file
   WHERE ima01 = p_ima01 
  IF cl_null(l_ima930) THEN LET l_ima930 = 'N' END IF

  CASE
     WHEN l_smyb01 = '1' #1:非條碼單據
        IF l_ima930 = 'Y' THEN
           #當前單別不允許輸入使用條碼料件！
           LET g_errno = 'aba-036'
        END IF

     WHEN l_smyb01 = '2'
        IF l_ima930 = 'N' THEN                    
           #當前單別只允許輸入使用條碼料件(ima930='Y')!
           LET g_errno = 'aba-095'
        END IF
  END CASE
END FUNCTION
#No:DEV-D30026--add--end

#DEV-D30037--add--begin
#DEV-D30046 移至saimt324_sub.4gl --mark--begin
#FUNCTION t324_chk_smyb2(p_imm01)
#   DEFINE p_imm01    LIKE imm_file.imm01
#   DEFINE l_ima01    LIKE ima_file.ima01
#   DEFINE l_ima931   LIKE ima_file.ima931
#   DEFINE l_smyb01   LIKE smyb_file.smyb01
#   
#   LET l_smyb01 = '1'
#   IF g_aza.aza131 = 'N' OR cl_null(g_aza.aza131) THEN
#      RETURN l_smyb01
#   END IF
#
#   #找出第一筆資料
#   LET l_ima01 = ''
#   SELECT imn03 INTO l_ima01
#     FROM imn_file
#    WHERE imn01 = p_imm01
#      AND imn02 = (SELECT MIN(imn02) FROM imn_file
#                    WHERE imn01 = p_imm01)
#   
#   LET l_ima931 = ''
#   SELECT ima931
#     INTO l_ima931
#     FROM ima_file
#    WHERE ima01 = l_ima01
#   IF cl_null(l_ima931) THEN LET l_ima931 = 'N' END IF
#   
#   IF l_ima931 = 'Y' THEN
#      LET l_smyb01 = '2'
#   END IF
#   
#   RETURN l_smyb01
#
#END FUNCTION
#DEV-D30046 移至saimt324_sub.4gl --mark--end
#DEV-D30037--add--end

#DEV-D40013 --add
	#FUN-D40103--add--str--
FUNCTION t324_imechk(p_ime01,p_ime02)
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
         LET l_err = p_ime02                              #TQC-D50116 add
         IF cl_null(l_err) THEN LET l_err = "' '" END IF  #TQC-D50116 add
         CALL cl_err_msg("","aim-507",p_ime01 || "|" || l_err ,0)  #TQC-D50116
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION
#FUN-D40103--add--end--
