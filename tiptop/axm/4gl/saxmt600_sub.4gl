# Prog. Version..: '5.30.06-13.04.24(00010)'     #
#
# Program name...: saxmt600_sub.4gl
# Description....: 提供saxmt600.4gl使用的sub routine
# Date & Author..: 07/03/05 by kim (FUN-730012)
# Modify.........: No.MOD-6C0118 07/01/29 By Claire 多角出貨時要考慮參數一單到底(oaz105)的勾選,一律改取多序號
# Modify.........: No.TQC-730022 07/03/20 by rainy 流程自動化by GP5.0
# Modify.........: No.FUN-730018 07/03/20 by kim 流程自動化by GP5.0
# Modify.........: No.FUN-730057 07/03/30 By Carrier 會計科目加帳套
# Modify.........: No.TQC-730006 07/04/04 By Claire update obk_file 加入條件obk05
# Modify.........: NO.TQC-740089 07/04/16 by yiting 回傳l_oea904
# Modify.........: NO.CHI-740016 07/04/18 by kim upd()段的檢查移到chk段
# Modify.........: No.FUN-740016 07/04/20 By Nicola 借出管理
# Modify.........: No.TQC-740152 07/04/20 By rainy GP5.0整合測試
# Modify.........: No.MOD-740331 07/04/23 By Nicola 錯誤訊息修改
# Modify.........: NO.TQC-740216 設定invoice來源為出貨單時，會check有無invoice資料
#                                把這段判斷移到扣帳段處理
# Modify.........: No.TQC-740354 07/05/14 By kim 扣帳時,在輸入出貨日期的畫面按取消,仍然會過帳
# Modify.........: No.FUN-740034 07/05/14 By kim 確認過帳不使用rowid,改用單號
# Modify.........: NO.TQC-740112 07/05/15 BY yiting 參數設定(axms070) 設定 ""確認不自動拋轉""  按過帳時 ,請提示
# Modify.........: NO.TQC-750122 07/05/23 BY rainy 單頭出貨類別為:3:出至境外倉的單據,在做確認時,若選擇要產生境外倉出貨訂單,則產生的訂單單身欄位[oeb906]檢驗碼無default
# Modify.........: No.CHI-770019 07/07/26 By Carrier 多單位:參考單位時,交易單位不寫入tlff
# Modify.........: No.MOD-770127 07/08/06 By pengu 調整回寫出通單之出貨單號欄位出通單時機點
# Modify.........: No.MOD-780068 07/08/09 By claire 匯率基準日取結關日,當空白時取單據日
# Modify.........: No.TQC-750014 07/08/14 By pengu 庫存轉換率異常
# Modify.........: No.MOD-780094 07/08/16 By claire 出至境外倉產生境外倉出貨訂單時, 客戶簽收否的欄位要重新取客戶主檔的設定
# Modify.........: No.MOD-780163 07/08/21 By kim 增加 message "此張出貨單,訂金尚未收款,不可確認!"
# Modify.........: No.CHI-780041 07/08/27 BY yiting sma123改為取oaz79
# Modify.........: No.FUN-790001 07/09/03 BY jamie PK問題
# Modify.........: No.MOD-790009 07/09/04 By claire axr-164訊息調整為mfg6090
# Modify.........: No.MOD-790136 07/09/27 By Pengu 當作出貨簽收且母單位數量為0時，不應寫tlff
# Modify.........: No.MOD-790150 07/09/28 By claire 當簽收管理時有銷退單並未產生
# Modify.........: No.CHI-7A0015 07/10/11 By Pengu 調貨出貨所產生的銷退單其tlf異動命令錯誤
# Modify.........: No.MOD-7A0055 07/10/11 By Pengu 調貨出貨單所產生的銷退單tlff異動資料，會將料號寫入客戶廠商欄位
# Modify.........: No.MOD-7A0084 07/10/16 By claire tuq_file 條件少了tuq05,tuq051造成 select 會有-284的錯誤
# Modify.........: No.FUN-7A0038 07/10/22 By Carrier 調貨出貨扣帳時,oga1012/oga1014/oha1015賦值為銷退單/N/Y
# Modify.........: No.MOD-7A0177 07/10/29 By claire 簽收單扣帳時會回寫簽收日期至原出貨單是不合理的
# Modify.........: No.TQC-7A0114 07/10/30 By Sarah 追單(FUN-630102)
# Modify.........: No.MOD-7A0100 07/11/01 By Pengu Insert imgg_file用SQLCA.SQLERRD[3]判斷是否成功
# Modify.........: No.MOD-7B0198 07/11/22 By Pengu 調貨出貨產生的銷退單其帳戶客戶簡稱(oha032)均未帶出
# Modify.........: No.MOD-7B0208 07/11/23 By claire 加上條件
# Modify.........: No.TQC-7B0159 07/12/04 By judy 修改錯誤提示信息
# Modify.........: No.TQC-7C0011 07/12/04 By judy 資料已審核，點"審核"無提示信息
# Modify.........: No.TQC-7C0070 07/12/07 By chenl  修正會計年度判斷。
# Modify.........: No.TQC-7C0083 07/12/07 By chenl 當前數據庫為多角貿易流程中設定的中斷站時，不執行自動拋轉
# Modify.........: No.TQC-7C0100 07/12/08 By Unicorn單身筆數大于參數設定值時不允許審核
# Modify.........: No.TQC-7C0114 07/12/08 By xufeng 抓不到調貨客戶對應的產品定價，應該不可以生成銷退單
# Modify.........: No.CHI-7B0041 07/12/09 By claire 調整TQC-7C0083為多角貿易流程中設定的中斷站時，不執行自動拋轉及還原拋轉
# Modify.........: No.TQC-7C0146 07/12/18 By claire 中斷點的單據,扣帳時要寫入多角序號,取消扣帳還原多角序號
# Modify.........: No.TQC-7C0154 07/12/20 By xufeng 修正TQC-7C0114的問題
# Modify.........: No.FUN-7C0017 07/12/21 By bnlent 增加行業別規範化修改
# Modify.........: No.MOD-810239 08/01/29 By claire 多角出貨單及一般出貨單的訊息應區分
# Modify.........: No.FUN-810045 08/03/01 By rainy  項目管理,專案相關欄位代入tlf
# Modify.........: No.FUN-7B0018 08/03/07 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-7B0014 08/03/13 By bnlent 新增ICD行業功能
# Modify.........: No.MOD-830155 08/03/19 By lumx   t600sub_y_chk()中使用的變量l_argv0，使用的局部變量，使得在t600sub_chk_oeb()中sql sun(ogb12)查詢時傳入的值為空。
#                                                   導致客戶在做出貨通知單時，出出貨通知單數量可以大于訂單數量。
# Modify.........: No.MOD-820037 08/03/20 By claire (1)合併出貨時,單身有多筆資料時不可用fetch的語法
#                                                   (2)分批出貨時,有多筆收貨單應以收貨單FirtIn FirstOout的分式取得
# Modify.........: No.FUN-830078 08/03/24 By bnlent 報錯訊息修改 
# Modify.........: No.CHI-830030 08/03/25 By claire 出通單雖勾選檢驗"Y" 若沒有做OQC 僅顯示警告訊息
# Modify.........: No.MOD-830222 08/03/27 By claire 分批出貨時,有多筆收貨單時,以收貨單做FIFO,應加再上採購單項次
# Modify.........: No.FUN-840187 08/04/24 By Nicola 從採購單產生單身時，開窗讓使用者輸入批/序號資料
# Modify.........: No.MOD-840691 08/04/30 By claire 出至境外倉的出貨單,確認時,倉儲欄位一定要控卡
# Modify.........: NO.MOD-850026 08/05/05 BY claire sql多了一個ogb_file
# Modify.........: No.MOD-850179 08/05/19 By Smapimn 修改已出貨未稅金額回寫方式
# Modify.........: No.FUN-850120 08/05/22 By rainy 修改批序號無法"確認"的問題
# Modify.........: No.MOD-850236 08/05/27 By Smapmin 修正MOD-850179
# Modify.........: No.MOD-850221 08/05/28 By Smapmin 改由抓取單身訂單編號來判斷訂金是否已立帳
# Modify.........: No.MOD-850309 08/05/30 By Smapmin 修改t600_chk_ima262()接收的變數
# Modify.........: No.FUN-850100 08/05/19 By Nicola 批/序號管理第二階段
# Modify.........: No.FUN-840164 08/06/03 By xiaofeizhu 出通單無需做OQC卡關，判斷為出通單的話，不做OQC卡關 
# Modify.........: NO.MOD-860078 08/06/06 BY Yiting ON IDLE 處理
# Modify.........: No.FUN-860045 08/06/12 By Nicola 批/序號傳入值修改及開窗詢問使用者是否回寫單身數量
# Modify.........: No.MOD-860190 08/06/17 By Smapmin 借貨流程於出貨單過帳時產生的調撥單,調撥日期應為出貨日期
# Modify.........: No.CHI-860005 08/06/27 By xiaofeizhu 使用參考單位且參考數量為0時，也需寫入tlff_file
# Modify.........: No.MOD-860304 08/06/30 By Smapmin 錯誤訊息無法顯示
# Modify.........: No.FUN-820060 08/07/15 By lutingting 調整調貨出貨時取單價的方式
# Modify.........: No.MOD-870201 08/07/16 By Smapmin 延續MOD-860190
# Modify.........: No.MOD-870120 08/07/16 By Sarah 寫入tlf_file時,應將單身理由碼寫入tlf14
# Modify.........: No.MOD-870252 08/07/21 By chenl   修正tlf19取值來源為oga03/oha03
# Modify.........: No.FUN-870136 08/08/11 By xiaofeizhu 借貨出貨單在寫入調撥單時，單頭備注欄位(imm09)存入出貨單號(oga01)
# Modify.........: No.MOD-880260 08/08/29 By wujie   審核時出通單的通知日期可以大于會計年度
# Modify.........: No.MOD-870278 08/09/03 By claire 出通單拋轉還原要以參數設定為主
# Modify.........: No.MOD-890023 08/09/04 By chenyu ICD功能修改
# Modify.........: No.FUN-870131 08/09/16 By Nicola 多倉儲批出貨批/序號功能
# Modify.........: No.MOD-890123 08/09/25 By Smapmin 過帳時,產生的調撥單若不能過帳,整個動作應該要ROLLBACK
# Modify.........: No.MOD-890252 08/09/29 By claire 加入多角出通單做信用查核
# Modify.........: No.MOD-890274 08/10/06 By Smapmin 增加使用多單位時,庫存是否足夠的控管
# Modify.........: No.FUN-840012 08/10/13 By kim mBarcode 功能修改
# Modify.........: No.MOD-8A0126 08/10/16 By chenyu 出貨單在審核時對信用的檢查應該要考慮當前筆的金額
# Modify.........: No.FUN-8A0086 08/10/21 By lutingting完善錯誤信息匯總
# Modify.........: No.MOD-8B0077 08/11/15 By Smapmin 防止重複過帳的問題
# Modify.........: No.MOD-8B0106 08/11/30 By Smapmin 修正MOD-890274
# Modify.........: No.MOD-8A0208 08/11/25 By chenyu OPEN coursor出錯，有的地方不需要ROLLBACK WORK，直接LET g_success = 'N'即可
# Modify.........: No.CHI-8B0048 08/11/28 By claire  多角出貨單庫存扣帳時,若拋轉axmp900失敗,則不允許扣帳成功
# Modify.........: No.TQC-8C0027 08/12/15 By Nicola 償價數量更新修改
# Modify.........: No.MOD-8C0110 08/12/15 By Smapmin 因過單互卡,故booking該支程式以利過單.
# Modify.........: No.MOD-8C0139 08/12/15 By Smapmin t600sub_chk_imgg()主要是在check多單位的庫存數量,單一單位不需check.
# Modify.........: No.FUN-8C0084 08/12/22 By jan s_upimg相關改以 料倉儲批為參數傳入 ,不使用 ROWID
# Modify.........: No.MOD-920142 09/02/12 By Smapmin 產生調撥單時,針對資料所有者等資訊也要一併產生
# Modify.........: No.MOD-920298 09/02/24 By Smapmin 回寫最近出庫日(ima74)/最近入庫日(ima73),應依照出貨日期/銷退日期
# Modify.........: No.FUN-920207 09/03/05 By jan icd業時cmdrun aimt324_icd
# Modify.........: No.FUN-930038 09/03/06 By kim 借貨單的刻號/BIN資料過帳時要拋轉至調撥單，調撥單刪除時要拋轉回借貨單
# Modify.........: No.FUN-930108 09/03/18 By zhaijie過賬時增加s_incchk檢查使用者是否有相應倉,儲的過賬權限
# Modify.........: No.MOD-930199 09/04/06 By smapmin 確認時檢查單身是否有數量為0的
# Modify.........: No.MOD-940150 09/04/13 By Dido 增加訂單單號提示
# Modify.........: No.TQC-930155 09/04/14 By dongbg  事務檢查
# Modify.........: No.MOD-940300 09/04/23 By Dido oeb16 給予預設值 oeb15
# Modify.........: No.MOD-940273 09/04/20 By Smapmin 按ctrl+s後再按庫存過帳,會過帳失敗,因為出貨日期沒有抓到
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.TQC-950020 09/05/13 By mike 跨庫的SQL語句一律使用s_dbstring()的寫法  
# Modify.........: No.TQC-950134 09/05/22 By Carrier rowid定義規範化
# Modify.........: No.MOD-950143 09/05/27 By Smapmin 產生調撥單單身時,單位與數量要依照倉庫的單位來換算
# Modify.........: No.FUN-970005 09/07/01 By mike 確認時,若單身倉儲批不存在時,警告訊息應含料件資料..不然若單身料件有幾十筆時        
#                                                 很難查出問題料號是哪一筆    
# Modify.........: No.FUN-970093 09/07/28 By Dido 調整 axm-151 訊息,增加訂單單號
# Modify.........: No.CHI-970064 09/07/29 By mike 出至境外倉出貨單  自動產生 境外倉出貨訂單時,                                      
#                                                 沒有將 客戶訂單 (oea10) 傳過去    t600sub_ins_oea()                               
# Modify.........: No.FUN-870007 09/08/03 By Zhangyajun 流通零售功能修改
# Modify.........: No.MOD-980090 09/08/17 By Dido axm-245 訊息應再檢核倉庫別poy11,以符合訊息說明
# Modify.........: No.TQC-980155 09/08/20 By sherry 點"審核"功能鈕,審核未成功,系統無任何提示信息
# Modify.........: No.MOD-980177 09/08/22 By Smapmin 針對obk_file的異動,新增時檢驗否相關欄位來自於ima_file,修改時不異動
# Modify.........: No.MOD-970237 09/08/22 By Smapmin 借貨出貨流程,過帳時未回寫備置量
# Modify.........: No.CHI-970074 09/08/24 By mike 出至境外倉出貨單確認時自動產生境外倉出貨訂單時,都要將檢驗碼default為'N'.                            
# Modify.........: No.FUN-980010 09/08/25 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.MOD-980195 09/08/25 By mike 第916行PREPARE oea03_pre FROM l_sql之前應增加CALL cl_replace_sqldb(l_sql) RETURNIN
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980093 09/09/22 By TSD.sar2436  GP5.2 跨資料庫語法修改
# Modify.........: No:MOD-990092 09/10/21 By mike 增加订单项次     
# Modify.........: No:MOD-9A0146 09/10/22 By Dido 若為簽核時給予 gi_ccc_logerr初始值  
# Modify.........: No:CHI-970003 09/10/27 By Smapmin 將出貨扣帳限定非MRP倉的條件拿掉
# Modify.........: No:CHI-970040 09/11/02 By Smapmin 產生客戶簽收驗退時,未同步產生rvbs_file/tlfs_file的資料
# Modify.........: No:MOD-9B0077 09/11/13 By Smapmin 出至境外倉,img37要default為扣帳日期
# Modify.........: No:MOD-9B0149 09/11/24 By Smapmin 客戶簽收單不需再控管是否存在包裝單
# Modify.........: No:CHI-9B0034 09/11/26 By Smapmin 境外倉出通/出貨單也應做信用查核
# Modify.........: No:MOD-9B0183 09/11/26 By Smapmin 輸入出至境外倉倉/儲時,要控管ima39的參數.
# Modify.........: No:MOD-9B0189 09/11/30 By Smapmin 新增imgg_file時,imgg00沒有給值
# Modify.........: No:MOD-9B0185 09/11/30 By Smapmin 產生境外倉出貨訂單時,轉入項次未DEFAULT
# Modify.........: No:MOD-9B0195 09/11/30 By Smapmin 還原MOD-8A0126的修改
# Modify.........: No:MOD-9C0055 09/12/04 By Smapmin 變數初始化
# Modify.........: No:CHI-9C0009 09/12/04 By Dido 銷售正拋應可扣庫存
# Modify.........: No:FUN-9C0083 09/12/16 By mike 取价call s_fetch_price_new() 
# Modify.........: No:FUN-9C0120 09/12/21 By mike 通过价格条件管控未取到价格时单价栏位是否可以人工输入
# Modify.........: No:MOD-9C0330 09/12/25 By Smapmin 欄位名稱打錯
# Modify.........: No:MOD-9C0439 09/12/30 By Smapmin 自動拆併箱的調撥單沒有產生出來
# Modify.........: No.CHI-9C0027 09/12/22 By chenmoyan 销售正抛时与g_sma.sma894[2,2]='N'定义会有冲突
# Modify.........: No:CHI-9C0060 10/01/04 By Smapmin INSERT INTO obk_file時,obk11 default 為'N'
# Modify.........: No:CHI-9C0037 10/01/14 By Dido 多角銷售正拋庫存扣帳應可先寫入tlf_file 
# Modify.........: No.FUN-9C0073 10/01/18 By chenls 程序精簡
# Modify.........: No:MOD-A10122 10/01/20 By Smapmin 確認段回寫已出貨數量時,未考慮借貨出貨單據
# Modify.........: No:MOD-A10123 10/02/03 By Smapmin oeb1006若為空時,default 100
# Modify.........: No.FUN-A20022 10/02/05 By Cockroach 審核時更新會員積分相關
# Modify.........: No:MOD-A10163 10/02/22 By Smapmin 產生客戶簽退單時,rvbs022/rvbs13重給default值
# Modify.........: No:CHI-880006 10/02/25 By Smapmin OQC的數量先抓取出通單,若出通單沒有資料才依出貨單抓取
# Modify.........: No:MOD-A20117 10/03/02 By Smapmin 使用多單位且多倉儲出貨時,無法update imgs_file
# Modify.........: No:FUN-A30063 10/03/19 By Cockroach ADD ogacont
# Modify.........: No.FUN-A20044 10/03/20 By jiachenchao 刪除字段ima26*
# Modify.........: No:FUN-970017 10/04/06 By Lilan (1)EasyFlow 自動執行確認功能
#                                                  (2)串EasyFlow時,若要自動確認,則不能在確認的時候開窗
#                                                   =>將CALL t600sub_on_check此段挪至t600sub_y_chk()  
# Modify.........: No.TQC-A50093 10/05/20 By houlia 出貨單選擇簽收時，彈出的對話框“Delivery to Offshore W/H”中倉庫開窗資料調整
# Modify.........: No:CHI-A40029 10/06/04 By Summer 針對出貨單之img_file的控管一律移到過帳段
# Modify.........: No:MOD-A60070 10/06/10 By Sarah INSERT INTO imm_file前記得要將imm12清為NULL
# Modify.........: No:MOD-A50076 10/06/15 By Smapmin 修改出貨簽收流程update oeb23/oeb24的時機點
# Modify.........: No:CHI-A50004 10/06/24 By Summer 在確認/取消確認/過帳/取消過帳時,將lock資料的動作往前移至FUNCTION的一開始
# Modify.........: No:FUN-A50103 10/06/03 By Nicola 訂單多帳期 
# Modify.........: No:MOD-A60196 10/06/30 By liuxqa s_fetch_price_new(參數傳錯。
# Modify.........: No.FUN-A50102 10/07/01 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A60056 10/07/09 By lutingting GP5.2財務串前段問題整批調整
# Modify.........: No:FUN-A70118 10/07/28 By shiwuying 增加lsm07交易門店字段
# Modify.........: No:MOD-A70150 10/07/29 By Smapmin 借貨出貨產生調撥單時,沒有考慮多倉儲出貨的狀況
# Modify.........: No:MOD-A70068 10/07/29 By Smapmin 借貨出貨單庫存扣帳未考慮"備置"，導致"已備置"訂單庫存不足無法出貨
# Modify.........: No:MOD-A70017 10/07/29 By Smapmin 變數定義錯誤
# Modify.........: No:MOD-A60153 10/07/30 By Smapmin 把出貨單拋轉的動作移至過帳後
# Modify.........: No:MOD-A60150 10/07/30 By Smapmin 借貨償價不需控管是否存在包裝單
# Modify.........: No:CHI-A30017 10/08/02 By Summer 調整axm-924的控管，只有是axmt628(出貨簽收)時，才須做此控管，其餘皆不用
# Modify.........: No:MOD-A80026 10/08/13 By Smapmin 還原MOD-980090的修改
# Modify.........: No:FUN-A70130 10/08/16 By huangtao 修改q_oay參數    
# Modify.........: No:MOD-A90149 10/09/28 By Smapmin 銷售正拋登打來源站的出貨單時,不控卡庫存足不足.
# Modify.........: No:FUN-AA0048 10/10/20 By Carrier GP5.2架构下仓库权限修改
# Modify.........: No.FUN-A40022 10/10/25 By jan 當料件為批號控管,批號為空時不可審核
# Modify.........: No:FUN-AB0011 10/11/08 By huangtao 從庫存抓取資料前做料號控管
# Modify.........: No:MOD-AB0078 10/11/09 By lilingyu 當出貨時,使用至境外倉庫,系統會自動產生一張對應的境外倉出貨訂單,訂單上的收款客戶消失了
# Modify.........: No:MOD-A90190 10/11/09 By Smapmin mark多餘的程式段
# Modify.........: No:MOD-A90084 10/11/09 By Smapmin 當出貨單單頭有打出通單號時,出貨單項次就當做是出通單項次.
#                                                    再由出通單+項次抓OQC的數量.
# Modify.........: No:FUN-AB0059 10/11/15 By huangtao modify the bug of FUN-AB0011
# Modify.........: No.FUN-AB0061 10/11/16 By vealxu 訂單、出貨單、銷退單加基礎單價字段(oeb37,ogb37,ohb37)
# Modify.........: No.FUN-AB0061 10/11/16 By shenyang 在CALL s_fetch_price_new的地方返回參數中加上基礎單價
# Modify.........: No.FUN-AB0061 10/11/17 By chenying 銷退單加基礎單價字段ohb37
# Modify.........: No.FUN-AB0061 10/11/17 By shenyang 出貨單加基礎單價字段ogb37
# Modify.........: No.FUN-AB0096 10/11/26 By vealxu 因新增ogb50,ohb71的not null欄位,所導致其他作業無法insert into資料的問題修正
# Modify.........: No:TQC-AB0381 10/11/30 By wangxin 修改未稅額l_oma54于oea261比較
# Modify.........: No:TQC-AB0375 10/12/02 By huangtao 
# Modify.........: No:MOD-AC0023 10/12/10 By Smapmin 借貨出貨產生調撥單時,沒有考慮多單位非多倉儲出貨的狀況
# Modify.........: No:TQC-AC0184 10/12/14 By chenying 非寄銷訂單，確認時，不應做此判斷'axm-530(001 此客戶未設定預設寄銷倉庫、儲位，請執行"寄銷客戶對應倉庫維護作業(axmi226)"維護!)"
# Modify.........: No.FUN-AC0055 10/12/21 By suncx 取消預設ohb71值，新增oha55欄位預設值
# Modify.........: No:TQC-AC0144 10/12/23 By suncx 調貨出貨時產生銷退單的折扣率抓取BUG調整
# Modify.........: No.FUN-AC0055 10/12/23 By wangxin oga57欄位預設值修正
# Modify.........: No:MOD-AB0151 10/12/24 By Summer 修改訂單待出貨數量的算法
# Modify.........: No:MOD-AC0257 10/12/24 By Smapmin 修正MOD-AB0151
# Modify.........: No:CHI-AC0034 11/01/06 By Summer 1.出貨簽收流程/出至境外倉產生的tlf,料號有錯
#                                                   2.axmt628確認時控卡替代數量合計 
# Modify.........: No:TQC-B10066 11/01/11 By shiwuying 物返金額可以為0
# Modify.........: No:MOD-B10110 11/01/18 By Summer 借貨出貨流程的過帳也要考慮是否做OQC
# Modify.........: No:MOD-B10141 11/01/19 By Smapmin 扣帳時,MISC料不用檢查換算率
# Modify.........: No:MOD-B10154 11/01/20 By shiwuying 会员卡积分计算调整
# Modify.........: No:MOD-B10172 11/01/21 By Summer 客戶簽收單確認(過帳)時，若銷售單位<>庫存單位會異常
# Modify.........: No.MOD-AC0060 11/01/25 By Smapmin 借貨出貨流程,料號做批序號管理時,要一併處理調撥單的rvbs_file資料
# Modify.........: No.TQC-B20053 11/02/18 By huangtao 確認時檢查單身項次對應的所有單價是否小於價格策略的最低價
# Modify.........: No:FUN-A60034 11/03/08 By Mandy(1)EasyFlow整合功能外序參數的接收順序交換為：ARG_VAL(1)-->imm01調撥單號； ARG_VAL(2)-->Action ID ； ARG_VAL(3) -->借出管理flag
#                                                 (2)因aimt324 新增EasyFlow整合功能影響INSERT INTO imm_file
# Modify.........: No:FUN-A70104 11/03/08 By Mandy [EF簽核] aimt324影響程式簽核欄位default
# Modify.........: No:MOD-B30292 11/03/14 By Summer 修改oaz74該訊息控卡的地方改為WIP倉 
# Modify.........: No:MOD-B30464 11/03/15 By Summer 還原CHI-8B0048的修改 
# Modify.........: No:TQC-B30120 11/03/17 By lilingyu 按下確認action時,按該訂單的稅別是否含稅來增加判斷
# Modify.........: No:MOD-B30620 11/03/22 By Summer 產品對應銷售單位的價格資料允許自定價,但未維護自定價資料,修改錯誤訊息 
# Modify.........: No:MOD-B30430 11/03/29 By Summer 過帳段只要有RETURN的地方,都要把locking cursor close掉
# Modify.........: No:MOD-B30651 11/03/30 by Summer 修改判別有效天數
# Modify.........: No:CHI-B30093 11/03/31 BY lilingyu 出貨簽收批號管控
# Modify.........: No:MOD-B30665 11/03/31 by Summer 出通單在確認時不應控管關帳日期
# Modify.........: No:MOD-B30697 11/03/31 By Summer 確認時,先檢核若oga07為Y時,oga13不可為空
# Modify.........: No:FUN-B20060 11/04/07 By zhangll 增加oeb72赋值
# Modify.........: No:TQC-B40069 11/04/11 By lilingyu 產生境外倉出貨訂單時,報-391的錯誤
# Modify.........: No:MOD-B40148 11/04/19 By Summer 在aimq231產品數量並不會個別扣數量，而是在各倉庫中扣除"總數量"，造成儲貨數量異常
# Modify.........: No:FUN-AC0074 11/05/03 By jan 更新訂單備置寫法
# Modify.........: No:FUN-B40098 10/05/18 By shiwuying 扣率代銷時產生一筆非成本倉的雜發單和成本倉的入庫單
# Modify.........: No:MOD-B50180 11/05/20 By zhangll 多角出貨通知單應根據參數控管批序號管理
# Modify.........: No:TQC-B50052 11/05/26 By jan 訂單超交檢查報錯
# Modify.........: No:TQC-B50099 11/05/30 By yinhy 出貨簽收批號管控修改
# Modify.........: No:MOD-B50047 11/06/07 By Summer 在過帳輸入出貨日期時增加判斷出貨日期不可小於訂單日期
# Modify.........: No:CHI-B60054 11/06/08 By yinhy MARK掉CHI-B30093和TQC-B50099單號更改內容
# Modify.........: No:MOD-B50204 11/06/10 By Summer 借貨出貨流程需增加寫入rvbs09 = 1 的rvbs_file
# Modify.........: No.FUN-B30187 11/06/29 By jason ICD功能修改，增加母批、DATECODE欄位 
# Modify.........: No:MOD-B40260 11/07/19 By JoHung 輸入儲位時要檢核其合理性
# Modify.........: No:MOD-B50094 11/07/19 By JoHung 借貨償價流程,倉庫控管是不可用倉
# Modify.........: No:CHI-B60085 11/07/19 By JoHung 出至境外倉時，單身庫別需相同，境外倉庫別也需與單身庫別相同
#                                                   同為計算成本倉或同為不計算成本倉(jce_file)
# Modify.........: No:MOD-B70197 11/07/20 By Summer 請將信用查核移到更新oga55狀態後 
# Modify.........: No:FUN-B70074 11/07/20 By fengrui(imni_file By xianghui) 添加行業別表的新增於刪除
# Modify.........: No:FUN-B70087 11/07/21 By zhangll 增加oah07控管，s_unitprice_entry增加传参
# Modify.........: No:FUN-B40066 11/07/25 By jason 當單身勾選多倉儲批出貨時，刻號﹧BIN應該by ogc_file 維護
# Modify.........: No.TQC-B80005 11/08/03 By jason s_icdpost函數傳入參數
# Modify.........: No:MOD-B80054 11/08/04 By johung s_add_img參數ogb09、ogb091、ogb092改用ogc09、ogc091、ogc092
#                                                   t600_s1_c 若ogb09、ogb091、ogb092為NULL時，則給一個空白
# Modify.........: No.FUN-B50096 11/08/19 By lixh1 所有入庫程式應該要加入可以依料號設置"批號(倉儲批的批)是否為必要輸入欄位"的選項
# Modify.........: No:MOD-B80197 11/09/02 By johung 出至境外倉 倉庫類別應為W，修改相關控卡
#                                                   修正控卡倉庫須為WIP倉的錯誤訊息代碼
# Modify.........: No:MOD-B80265 11/09/02 By johung 出至境外倉，AFTER FEILD cware應控卡倉庫類別為W
# Modify.........: No:MOD-B70130 11/09/07 By Summer 驗退單上的日期改為跟簽收單上的簽收日期一樣 
# Modify.........: No.FUN-B80119 11/09/14 By fengrui  增加調用s_icdpost的p_plant參數
# Modify.........: No.MOD-BB0058 11/11/11 By suncx 審核時報錯任然過賬，導致錯誤
# Modify.........: No:TQC-BA0136 11/11/14 By jason 多倉儲批且走客戶簽收過帳和過帳還原會有問題
# Modify.........: No.FUN-BA0051 11/11/14 By jason 一批號多DATECODE功能
# Modify.........: No:FUN-B40081 11/11/14 By jason 新增多倉儲出貨處理
# Modify.........: No:FUN-B90104 11/11/15 By huangrh GP5.3服飾版本開發----修改oeaslk的賦值
# Modify.........: No:MOD-BB0335 11/12/03 By Vampire 單身料號若為MISC時，不用檢驗庫存數量
# Modify.........: No:FUN-BA0069 11/12/07 By yangxf 修改過帳/過帳還原時更新會員銷售及積分,加入積分款別
# Modify.........: No:FUN-BB0084 11/12/08 By lixh1 增加數量欄位小數取位
# Modify.........: No.FUN-BC0064 11/12/28 By xumm 增加確認按鈕的相關邏輯
# Modify.........: No.TQC-B90236 12/01/12 By zhuhao 更改rvbs09的值
# Modify.........: No.FUN-C10040 12/01/16 By xumm 增加確認按鈕和取消確認按鈕的相關邏輯
# Modify.........: No.FUN-910088 12/01/17 By chenjing 增加數量欄位小數取位
# Modify.........: No.FUN-B80189 12/02/01 By baogc  添加邏輯：如果料號經營方式是扣率代銷或者成本代銷入成本倉，檢查非成本倉的庫存
# Modify.........: No.FUN-BC0071 12/02/08 By huangtao 出貨確認時，檢查換贈資料
# Modify.........: No.FUN-C20006 12/02/09 By xjll   修改服飾業g_azw.azw04='2' 相關邏輯
# Modify.........: No:FUN-BB0167 12/02/22 By suncx 無訂單出貨簽收功能
# Modify.........: No:TQC-C20407 12/02/23 By huangtao 修改確認時檢查券贈品的bug
# Modify.........: No:MOD-B90118 12/02/24 By bart 借貨出貨單,單身未輸入倉庫,依舊可做庫存過帳
# Modify.........: No:FUN-C10051 12/02/24 By nanbing 455行增加判斷條件
# Modify.........: No:TQC-C20501 12/02/27 By xumm 去掉单身数量与lqw_file的检查
# Modify.........: No:TQC-C20502 12/02/28 By SunLM 庫存不足,修正過帳失敗,且無錯誤提示
# Modify.........: No:CHI-B40056 12/02/29 By Summer tup08,tup09是No Use不使用的欄位,調整為tup11,tup12 
# Modify.........: No:MOD-BA0009 12/02/29 By Summer 出貨類別為'3:出至境外倉"，且勾選"多倉儲批時"會有兩個問題：
#                                                   1.產生至境外倉的批號目前使用ogb092，應該改用ogc092才對(for 所有行業)
#                                                   2.無法產生ICD行業的庫存資料(for ICD only)
# Modify.........: No:MOD-BB0043 12/03/01 By Summer 比較時要增加乘於庫存單位轉換率 
# Modify.........: No:MOD-BC0089 12/03/01 By Summer 修正CHI-B60054的bug 
# Modify.........: No:MOD-BC0207 12/03/01 By Summer 1.控卡參考單位時,不可輸入批序號 2.庫存扣帳時抓單據數量 
# Modify.........: No:TQC-C30062 12/03/03 By bart 出貨通知單不應該有idd_file
# Modify.........: No:TQC-C30097 12/03/05 By huangtao 訂單轉出貨的時，判斷是否為訂單轉入的贈品積分，不是去更新儲值卡金額
# Modify.........: No:TQC-C30129 12/03/07 By huangtao 訂單轉出貨的時，不用去更新券狀態
# Modify.........: No:TQC-C30085 12/03/08 By pauline 新增ogh_file時若ogh09為null時預設給0 
# Modify.........: No:MOD-C30216 12/02/10 By xumeimei出货单扣帐会写lpj_file表的相关数据
# Modify.........: No:FUN-BB0081 12/03/14 By Sakura 成品替代增加多單位替代功能
# Modify.........: No:CHI-C30064 12/03/14 By Sakura 程式有用到"aim-011"訊息的地方，改用料倉儲批抓庫存單位(img09)換算
# Modify.........: No:MOD-C30250 12/03/15 By yuhuabao 修改過帳時抓不到單別時不報錯
# Modify.........: No:MOD-BB0051 12/03/16 By Vampire 過帳時,使用多單位,要能check imgg
# Modify.........: No:MOD-BB0265 12/03/16 By Vampire 出至境外倉出貨單確認時產生境外倉出貨訂單oea1008/oea261/oea262/oea263未給值
# Modify.........: No.MOD-C10147 12/03/16 By Vampire 多倉儲出貨寫入tlf時tlf66應該要給Y
# Modify.........: No.TQC-C20023 12/03/16 By Vampire 出貨單類別為3出至境外倉出貨單,在確認時不控卡axm-135
# Modify.........: No:MOD-C10103 12/03/16 By jt_chen 修改axmt629的倉儲異動,還原失敗的問題
# Modify.........: No:TQC-C30283 12/03/22 By lujh 在出貨單審核的時候要判斷如果單頭開開票性質是商戶開票的話單身商戶編號必須輸入
# Modify.........: No:MOD-C30819 12/03/22 by Vampire 出貨類別B：借貨償價,訊息內容應顯示該倉庫要選擇不可用倉
# Modify.........: No:MOD-C40017 12/04/03 By Summer axm-916錯誤訊息寫法錯誤 
# Modify.........: No:CHI-C30118 12/04/06 By Sakura 參考來源單號CHI-C30106,批序號維護修改
# Modify.........: No:MOD-C40114 12/04/17 By Vampire 一張訂單單身有兩筆以上的項次,轉出貨單扣帳時,oea62只會回寫最後一筆項次的金額
# Modify.........: No:FUN-C30289 12/04/19 By bart 多倉儲批有問題
# Modify.........: No:TQC-C40244 12/04/26 By Elise MOD-C10147修改會影響成本axcp500的計算,還原修改
# Modify.........: No.FUN-C40089 12/05/02 By bart 判斷銷售價格條件(axmi060)的oah08,若oah08為Y則單價欄位可輸入0;若oah08為N則單價欄位不可輸入0
# Modify.........: No:MOD-C50020 12/05/08 By Elise mfg3075錯誤訊息增加傳入料號
# Modify.........: No:FUN-BC0088 12/05/10 By Vampire 判斷MISC料可輸入單價
# Modify.........: No:TQC-C50097 12/05/11 By zhuhao 多單位時傳參出錯
# Modify.........: No:FUN-C50047 12/05/14 By pauline 寫入實際交易稅別明細檔. 時不論金額是否為>0,皆全部寫入ogh_file.
# Modify.........: No:TQC-C50149 12/05/17 By zhuhao 出貨通知單僅作通知作業可不用輸入倉儲批,不受批號控管方式影響.
# Modify.........: No.FUN-C50074 12/05/18 By bart 更改錯誤訊息代碼
# Modify.........: No.TQC-C50163 12/05/18 By wuxj 
# Modify.........: No.MOD-C50142 12/05/18 By Elise 判斷取不到單別就RETURN不繼續執行
# Modify.........: No:FUN-C40072 12/05/29 By Sakura 多角出貨也需處理客戶出貨簽收
# Modify.........: No:FUN-C50097 12/06/04 By SunLM 當oaz92=Y(立賬走開票流程)且大陸版時,判斷參數oaz94='Y'(出貨多次簽收)時，增加多次簽收功能
# Modify.........: No:TQC-C60157 12/06/19 By Sarah ICD行業別,當多倉儲出貨時,應檢查ogc_file的倉儲批而非ogb_file的倉儲批
# Modify.........: No.CHI-C30107 12/06/21 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C50097 12/06/27 By SunLM 因前期分析不足,修改時間過長,為避免影響他人作業,暫時mark掉,待其他同仁完成后,再恢復
# Modify.........: No:MOD-C30792 12/06/27 By Vampire 增加判斷是判斷開啟交談畫面axrp310
# Modify.........: No:MOD-C50014 12/06/27 By Vampire 驗退單單頭金額欄位(oga50,oga1006,oga1007,oga1008)請重新計算後回寫
# Modify.........: No:MOD-C50194 12/06/27 By Vampire 按下確定檢查axm-424有錯就不能繼續扣帳動作
# Modify.........: No.FUN-C50136 12/07/09 By xianghui 修改信用管控處理方式
# Modify.........: No:MOD-C40149 12/07/10 By Summer 修正CHI-C30064,多倉儲出貨此控卡會有問題 
# Modify.........: No:MOD-C50088 12/07/10 By Elise 修正MOD-C40149,需排除參考單位的批序號數量控卡
# Modify.........: No:MOD-C70078 12/07/10 By Elise 替代同一顆料,不同倉庫出時,調整將數量sum起來寫入ogc_file
# Modify.........: No:CHI-B80001 12/07/10 By Summer 確認後直接扣帳,會沒有卡到信用查核 
# Modify.........: No:MOD-C70014 12/07/10 By Elise 過帳段的transaction,應包在判斷傳入參數的判斷句內
# Modify.........: No:FUN-C70045 12/07/12 By yangxf 单据类型调整
# Modify.........: No:MOD-C70145 12/07/12 By Carrier oaz23=’N’+出货多仓储+签收功能时，出货单过帐，发现批号被合并
# Modify.........: No.FUN-C70098 12/07/31 By xjll  服飾流通二維，不可審核數量為零的母單身資料
# Modify.........: No:TQC-C70206 12/07/27 By SunLM將FUN-C50097中，非多次多次簽收功能過單到正式區，既與oaz94無關的參數。
# Modify.........: No:TQC-C60211 12/08/08 By zhuhao 審核時重新判斷部門編號
# Modify.........: No:CHI-C80060 12/08/27 By pauline 令oeb72預設值為null
# Modify.........: No:TQC-C70056 12/09/04 By zhuhao g_prog=axmt628時oga011對應的才是出貨單號
# Modify.........: No:FUN-C80001 12/09/18 By bart 雙單位轉換率有問題
# Modify.........: No:MOD-C90135 12/09/20 By SunLM 更新訂單待出貨數量的邏輯判斷,防止超過訂單允許的最大數量
# Modify.........: No.MOD-C80069 12/09/26 By Vampire 將更新oga902 移到更新oga55狀態
# Modify.........: No:MOD-C80250 12/10/11 By Elise 調整aim-034控卡
# Modify.........: No.MOD-CA0048 12/10/15 By Vampire 判斷非簽收驗退時改抓單據上料倉儲批的img18,imgg18
# Modify.........: No:FUN-C90105 12/10/16 By xuxz 添加ooz33的判斷
# Modify.........: No:TQC-CA0046 12/10/17 By dongsz 傳入參數應為價格條件oga31
# Modify.........: No:MOD-CA0131 12/10/19 By SunLM t600sub_gui中有cl_cmdrun_wait,不能包含在事物中,将其拿到事物外面
# Modify.........: No:FUN-C90049 12/10/19 By Lori 預設成本倉與非成本倉改從s_get_defstore取
# Modify.........: No.CHI-C20014 12/10/30 By wangwei 同張出通單對應到不同出貨單時,回寫待出貨量時錯誤,會只抓到最新一筆的出貨數量
# Modify.........: No:FUN-C90102 12/10/31 By pauline 將lsn_file檔案類別改為B.基本資料,將lsnplant用lsnstore取代
#                                                    將lsm_file檔案類別改為B.基本資料,將lsmplant用lsmstore取代
# Modify.........: No:TQC-C70056 12/11/12 By xuxz TQC-C70056 g_prog=axmt628時oga011對應的才是出貨單號 這個修改內容還原
# Modify.........: No:FUN-CA0152 12/11/13 By xumm 更改检查券数量与出货单数量是否一致逻辑
# Modify.........: No:MOD-CB0050 12/11/12 By SunLM 走開票流程時，對于原因碼為贈品（aooi313列入銷售費用為Y）的項次，
# Modify.........:                                 出貨過賬不應產生至發票倉，axmt670也不能針對此項次開票。
# Modify.........: No.MOD-CB0083 12/11/13 By SunLM "2"類型的出貨單以及"2/3"類型的銷退單不能開立發票,同時不更新發票倉庫存
# Modify.........: No:FUN-C80107 12/11/28 By suncx 新增可按倉庫進行負庫存判斷
# Modify.........: No.CHI-C30104 12/12/06 By pauline 當單據為借貨出貨單時,增加判斷出貨倉是否與借出客戶倉戶同為成本倉/非成本倉
# Modify.........: No.CHI-C90032 12/12/13 By pauline 扣帳時業務額度邏輯修改
# Modify.........: No:MOD-CA0203 12/12/17 By Elise 扣帳自動產生的單據給予核准狀態
# Modify.........: No:FUN-CB0087 12/12/20 By qiull 庫存單據理由碼改善; 12/12/25 By fengrui 審核添加非空檢查
# Modify.........: No.FUN-D10063 13/01/17 By Nina 只要程式有UPDATE ima_file 的任何一個欄位時,多加imadate=g_today
# Modify.........: No.FUN-D10040 13/01/18 By xumm 是否开立发票改用lpx38判断
# Modify.........: No:MOD-CB0064 13/01/29 By Elise (1) 判斷g_argv0='4'跟'6'隱藏"應收發票Action",確認時自動產生應收也不須呼叫axrp310
#                                                  (2) 由簽收單串回出貨單判斷是否為多角單據(oga09='4'),隱藏"應收發票Action",確認時自動產生應收也不須呼叫axrp310
# Modify.........: No:MOD-CB0214 13/01/31 By Elise 將出貨與簽收流程條件分開
# Modify.........: No:MOD-CC0260 13/01/31 By jt_chen 參數設定立即確認時,檢查單身是否有需要檢驗的料,調整為事後扣帳
# Modify.........: No.MOD-CC0080 13/01/31 By jt_chen 調整出貨單走簽收流程，單身與簽收倉庫需一致
# Modify.........: No:MOD-CB0111 13/02/01 By jt_chen 修正:因FUN-630102將adq改為tuq,adp改為tup、FUN-650108已經將ATM合併至AXM
# Modify.........: No:MOD-CB0237 13/02/04 By jt_chen icd出至境外倉,出貨單庫存過帳未INSERT ida_file 導致出現無倉儲批明細錯誤
# Modify.........: No:MOD-D20054 13/02/07 By bart tlf13='axmt820'的程式段Mark
# Modify.........: No.TQC-D10067 13/02/17 By SunLM  大陆版axmp230也能产生发票仓库存
# Modify.........: No.MOD-CC0232 13/02/17 By SunLM  在出貨單中審核時判斷出貨數量時排除折扣單的資料
# Modify.........: No:MOD-D10273 13/02/26 By Elise 修改錯誤訊息的顯示方式，同時顯示ogb04與ogb12
# Modify.........: No:FUN-D30007 13/03/04 By pauline 異動lpj_file時同步異動lpjpos欄位
# Modify.........: No:MOD-D10185 13/03/12 By jt_chen MISC無庫存資料，故不應該產生調撥單。扣帳還原 axmp650 也須調整
# Modify.........: No:FUN-D30024 13/03/12 By fengrui 負庫存依據imd23判斷
# Modify.........: No:TQC-D30038 13/03/14 By Elise 修正MOD-C80069
# Modify.........: No:TQC-D30044 13/03/19 By fengrui 負庫存依據imd23判斷
# Modify.........: No.DEV-D30026 13/03/19 By Nina GP5.3 追版:DEV-CC0001為GP5.25 的單號
# Modify.........: No.TQC-D30060 13/03/22 By chenjing 庫存扣帳還遠時bug修改
# Modify.........: No:CHI-C10016 13/03/22 By Elise 當有待驗收入時,在確認段增加控卡出貨單金額oga50與分錄金額一致
# Modify.........: No:CHI-BB0057 13/03/25 By Vampire oaz23='N'時，ogb17 預設 'N'
# Modify.........: No:FUN-D30084 13/03/25 By Elise 多角出通應可拋轉多角出貨
# Modify.........: No:FUN-D30085 13/03/25 By jt_chen 調整一般/多角皆為出通單不控卡，出貨單控卡
# Modify.........: No.DEV-D30040 13/04/01 By Nina 批序號相關程式,當料件使用條碼時(ima930 = 'Y'),確認時,
#                                                 若未輸入批序號資料則不需控卡單據數量與批/序號總數量是否相符 
#                                                 ex:單據數量與批/序號總數量不符，請檢查資料！(aim-011)
# Modify.........: No.DEV-D30059 13/04/01 By Nina 批序號相關程式,當料件使用條碼時(ima930 = 'Y'),輸入資料時,
#                                                 不要自動開批序號的Key In畫面(s_mod_lot)
# Modify.........: No.DEV-D40013 13/04/15 By Nina 過單用
# Modify.........: No:CHI-A90012 13/04/17 By Smapmin 修改錯誤訊息
# Modify.........: No.DEV-D40015 13/04/19 By Nina 若aimi100[條碼使用否]=Y且有勾選製造批號/製造序號，需控卡不可直接確認or過帳
# Modify.........: No.DEV-D40016 13/04/22 By Mandy 將出通掃描的條碼資料(ibj_file)拋至(tlfb_file)及異動imgb_file
# Modify.........: No.DEV-D40018 13/04/22 By Mandy 出貨作業時,當出通單號(oga011) 沒有值時才做有無掃瞄記錄的判斷
# Modify.........: No.DEV-D40019 13/04/24 By Nina  將DEV-D40015控卡移至跳出詢問是否確認視窗前
# Modify.........: No.FUN-D40103 13/05/21 By lixh1 增加儲位有效性檢查
# Modify.........: No.TQC-D50126 13/06/06 By lixh1 修改欄位跳轉順序
# Modify.........: No:TQC-D40078 13/04/28 By xujing 負庫存函数添加营运中心参数 
# Modify.........: No.TQC-D50131 13/05/31 By lujh 設置拆并箱時，出貨時按設置拆并箱
# Modify.........: No.MOD-D70161 13/07/24 By SunLM 当p_input_oga02为false时，才检查出货日期是否小于关账日期
# Modify.........: NO:MOD-D70030 13/07/25 By SunLM 出货单过帐时更新oeb24,在签退单过帐时再次更新
# Modify.........: No.2021113001 21/11/30 By jc 出货通知单审核自动同步SCM


DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE   g_bookno1       LIKE aza_file.aza81          #No.FUN-730057
DEFINE   g_bookno2       LIKE aza_file.aza82          #No.FUN-730057
DEFINE   g_flag          LIKE type_file.chr1          #No.FUN-730057
DEFINE   g_flag2         LIKE type_file.chr1          #FUN-C80107 add
DEFINE   g_exdate       LIKE oga_file.oga021  #MOD-780068 add
DEFINE p_success1    LIKE type_file.chr1     #No.TQC-7C0114
DEFINE   g_ina         RECORD LIKE ina_file.*  #No.FUN-7C0017
DEFINE   g_ica         RECORD LIKE ica_file.*  #No.FUN-7B0014
DEFINE   g_inb         RECORD LIKE inb_file.*  #No.FUN-7B0014
DEFINE   g_msg         LIKE type_file.chr1000  #No.FUN-7B0014
DEFINE   g_msg1        LIKE type_file.chr1000  #No.FUN-7B0014
DEFINE   g_msg2        LIKE type_file.chr1000  #No.FUN-7B0014
DEFINE   g_msg3        LIKE type_file.chr1000  #No.FUN-7B0014
DEFINE   g_cnt         LIKE type_file.num5     #No.FUN-7B0014
DEFINE g_ima918  LIKE ima_file.ima918  #No.FUN-810036
DEFINE g_ima921  LIKE ima_file.ima921  #No.FUN-810036
DEFINE g_ima930  LIKE ima_file.ima930  #DEV-D30040 add
DEFINE g_ima906  LIKE ima_file.ima906  #MOD-C50088
DEFINE g_forupd_sql    STRING
DEFINE g_rxx04_point LIKE rxx_file.rxx04         #抵現積分              #FUN-BA0069 add
DEFINE g_oah08         LIKE oah_file.oah08     #FUN-C40089 
#DEFINE g_act           LIKE type_file.chr1     #FUN-C50136
DEFINE g_inTransaction         LIKE type_file.chr1  #MOD-CA0131 add
 
#kim 注意 : 此sub routine中請勿宣告任何global或modual變數,若有需要,請用傳遞參數的方式來解決,
#因為此處的所有FUN應該可提供外部程式獨立呼叫
 
#{
#作用:出貨單確認前的檢查
#p_oga01:本筆出貨單的單號
#p_action_choice:執行"確認"的按鈕的名稱,若外部呼叫可傳NULL #CHI-C30118 add
#回傳值:無
#注意:以g_success的值來判斷檢查結果是否成功,IF g_success='Y' THEN 檢查成功 ; IF g_success='N' THEN 檢查有錯誤
#}

FUNCTION t600sub_y_chk(p_oga01,p_action_choice) #CHI-C30118 add p_action_choice
 DEFINE p_action_choice STRING #CHI-C30118 add
 DEFINE p_oga01 LIKE oga_file.oga01
 DEFINE l_argv0 LIKE ogb_file.ogb09
 DEFINE l_ogb09       LIKE ogb_file.ogb09,  #No.9736
        l_cnt         LIKE type_file.num5,    #No.FUN-680137 SMALLINT
        l_yy,l_mm     LIKE type_file.num5,    #No.FUN-680137 SMALLINT
        l_oea161      LIKE oea_file.oea161,
        l_oea162      LIKE oea_file.oea162,
        l_oea163      LIKE oea_file.oea163
 DEFINE l_sql     STRING
 DEFINE l_ogb19   LIKE ogb_file.ogb19,
        l_ogb11   LIKE ogb_file.ogb11,
        l_ogb12   LIKE ogb_file.ogb12,
        l_qcs01   LIKE qcs_file.qcs01,
        l_qcs02   LIKE qcs_file.qcs02,
        l_oga09   LIKE oga_file.oga09,
        l_qcs091c LIKE qcs_file.qcs091
 DEFINE l_ogb910      LIKE ogb_file.ogb910,
        l_ogb912      LIKE ogb_file.ogb912,
        l_x1,l_x2     LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
        l_msg,l_msg1,l_msg2,l_msg3  STRING    #No.TQC-7C0114
 DEFINE l_ogb1005     LIKE ogb_file.ogb1005     #No.FUN-610064
 DEFINE l_oma55   LIKE oma_file.oma55  #FUN-650105
 DEFINE l_oma54t  LIKE oma_file.oma54t #FUN-650105
 DEFINE l_oma54   LIKE oma_file.oma54  #TQC-AB0381 add
 DEFINE l_oga     RECORD LIKE oga_file.*
 DEFINE l_ogb1007     LIKE ogb_file.ogb1007,
        l_ogb1010     LIKE ogb_file.ogb1010,
        l_ogb14       LIKE ogb_file.ogb14,
        l_ogb14t      LIKE ogb_file.ogb14t,
        l_n           LIKE type_file.num5,                    #No.FUN-680137 SMALLINT
        l_max         LIKE tqw_file.tqw08,
        l_tqw08       LIKE tqw_file.tqw08,
        l_tqw081      LIKE tqw_file.tqw081,
        l_ogb31       LIKE ogb_file.ogb31,    #No.FUN-670008
        l_ogb32       LIKE ogb_file.ogb32,    #No.FUN-670008
        l_retn_amt    LIKE ohb_file.ohb14     #No.FUN-670008
 DEFINE l_ogb         RECORD LIKE ogb_file.*
 DEFINE l_ogc         RECORD LIKE ogc_file.*   #FUN-B40081
 DEFINE l_tmp         LIKE type_file.chr1000
 DEFINE l_flag        LIKE type_file.num5
 #DEFINE l_imaicd04    LIKE imaicd_file.imaicd04   #FUN-BA0051 mark
 #DEFINE l_imaicd08    LIKE imaicd_file.imaicd08   #FUN-BA0051 mark
 DEFINE l_rvbs06      LIKE rvbs_file.rvbs06
 DEFINE l_ogb14t_1    LIKE ogb_file.ogb14t   #No.FUN-870007
 DEFINE l_rxx04       LIKE rxx_file.rxx04    #No.FUN-870007
 DEFINE l_ogb47       LIKE ogb_file.ogb47    #No.FUN-870007
 DEFINE l_oea261      LIKE oea_file.oea261    #No:FUN-A50103
 DEFINE l_oea213      LIKE oea_file.oea213    #TQC-B30120  
#DEFINE l_imaicd13    LIKE imaicd_file.imaicd13  #FUN-A40022  #FUN-B50096
 DEFINE l_ima159      LIKE ima_file.ima159  #FUN-B50096
 DEFINE l_ogc12_t     LIKE ogc_file.ogc12   #CHI-AC0034 add
#TQC-B20053 -------------STA
 DEFINE l_ogb04       LIKE ogb_file.ogb04     
 DEFINE l_ogb05       LIKE ogb_file.ogb05     
 DEFINE l_ogb13       LIKE ogb_file.ogb13           
 DEFINE l_rtg01       LIKE rtg_file.rtg01
 DEFINE l_rtg07       LIKE rtg_file.rtg07
 DEFINE l_rtg08       LIKE rtg_file.rtg08            
 DEFINE l_rth06       LIKE rth_file.rth06
#TQC-B20053 -------------END 
 #FUN-BC0064------add-----str---
 DEFINE l_rxe04       LIKE rxe_file.rxe04
 DEFINE l_rxe05       LIKE rxe_file.rxe05
 DEFINE l_rxe08       LIKE rxe_file.rxe08
 DEFINE l_lqe01       LIKE lqe_file.lqe01
 DEFINE l_ogb03       LIKE ogb_file.ogb03
 DEFINE l_ima154      LIKE ima_file.ima154
 DEFINE g_sql         STRING             
 DEFINE l_ogb1001     LIKE ogb_file.ogb1001
 DEFINE l_lqw12       LIKE lqw_file.lqw12
 DEFINE l_lqw08_1_s   LIKE lqw_file.lqw08
 #FUN-BC0064------add-----end---
 DEFINE l_ogb04_1 LIKE ogb_file.ogb04   #FUN-BC0071 add
 DEFINE l_rxe02       LIKE rxe_file.rxe02  #TQC-C30129
 DEFINE l_ogb31_1       LIKE ogb_file.ogb31   #TQC-C30129
 DEFINE l_img09   LIKE img_file.img09 #CHI-C30064
 DEFINE l_ogb05_fac   LIKE ogb_file.ogb05_fac #CHI-C30064 add 
 DEFINE l_ogamksg     LIKE oga_file.ogamksg #CHI-C30118 add
 DEFINE l_oga55       LIKE oga_file.oga55   #CHI-C30118 add
 DEFINE l_ogg         RECORD LIKE ogg_file.*   #MOD-C40149 add
 DEFINE l_ogbslk03    LIKE ogbslk_file.ogbslk03   #FUN-C70098--add
 DEFINE l_ogbslk04    LIKE ogbslk_file.ogbslk04   #FUN-C70098--add
 DEFINE l_ogbslk12    LIKE ogbslk_file.ogbslk12   #FUN-C70098--add
 DEFINE l_gemacti     LIKE gem_file.gemacti       #TQC-C60211
 DEFINE l_n2          LIKE type_file.num5    #CHI-C30104 add
 DEFINE l_npq07f      LIKE npq_file.npq07f #CHI-C10016 add
 DEFINE l_oga50       LIKE oga_file.oga50  #CHI-C10016 add
 DEFINE l_oga07       LIKE oga_file.oga07  #CHI-C10016 add
 DEFINE l_ibd09       LIKE ibd_file.ibd09  #DEV-D40016 add
 DEFINE l_tc_ool02    LIKE tc_ool_file.tc_ool02  #add by huanglf161207
 define l_occud03     like occ_file.occud03 #darcy:2024/12/06 add
 
 WHENEVER ERROR CONTINUE                #忽略一切錯誤  #FUN-730012

 LET g_success = 'Y'
 
 IF cl_null(p_oga01) IS NULL THEN
    CALL cl_err('',-400,0)
    LET g_success = 'N'
    RETURN
 END IF
 SELECT * INTO l_oga.* FROM oga_file WHERE oga01 = p_oga01

 LET l_argv0=l_oga.oga09  #FUN-730012
 IF l_oga.oga01 IS NULL THEN
    CALL cl_err('',-400,0)
    LET g_success = 'N'   #FUN-580113
    RETURN
 END IF
 IF l_oga.ogaconf = 'X' THEN
    CALL cl_err('',9024,0)
    LET g_success = 'N'   #FUN-580113
    RETURN
 END IF
 IF l_oga.ogaconf = 'Y' THEN
    LET g_success = 'N'   #FUN-580113
    CALL cl_err('','axm-101',0)  #TQC-7C0011
    RETURN
 END IF
   
   #darcy:2024/12/06 add s---
   # - 如果客户被锁住不允许审核
   select occud03 into l_occud03 from occ_file where occ01 = l_oga.oga03
   if l_occud03 = 'Y' then
      let g_success = 'N'
      call cl_err(l_oga.oga03,'cxm-049',1)
      return 
   end if
   #darcy:2024/12/06 add e---

   # darcy:2025/11/26 add s---
   # 必须走签收检查
   if g_prog ='axmt620' then
      if cl_null(l_oga.oga65) or l_oga.oga65 != 'Y' then
         let g_success = 'N'
         call cl_err(l_oga.oga01,'cxm-0630',1)
         return
      end if
   end if
   # darcy:2025/11/26 add e---

 #DEV-D40019 add str-------
 #若aimi100[條碼使用否]=Y且有勾選製造批號/製造序號，需控卡不可直接確認or過帳
 IF g_aza.aza131 = 'Y' AND (g_prog = 'axmt610') THEN
   #確認是否有符合條件的料件
    LET l_cnt = 0
    SELECT COUNT(*) INTO l_cnt
      FROM ima_file
     WHERE ima01 IN (SELECT ogb04 FROM ogb_file WHERE ogb01 = l_oga.oga01) #料件
       AND ima930 = 'Y'                   #條碼使用否
       AND (ima921 = 'Y' OR ima918 = 'Y') #批號管理否='Y' OR 序號管理否='Y'
      
   #確認是否已有掃描紀錄
    IF l_cnt > 0 THEN
       IF cl_null(l_oga.oga011) AND l_oga.oga09 = '1' THEN #oga09='1':出貨通知單 #DEV-D40018 add if 判斷當出通單號(oga011) 沒有值時
           IF NOT s_chk_barcode_confirm('confirm','ibj',l_oga.oga01,'','') THEN
              LET g_success = 'N'
              RETURN
           END IF
       END IF #DEV-D40018 add
    END IF
 END IF
 #DEV-D40019 add end-------

#TQC-C60211 -- add -- begin
 SELECT gemacti INTO l_gemacti FROM gem_file
  WHERE gem01 = l_oga.oga15
 IF l_gemacti = 'N' THEN
    CALL cl_err(l_oga.oga15,'asf-472',0)
    LET g_success = 'N'
    RETURN
 END IF
#TQC-C60211 -- add -- end

#CHI-C30118---add---START
  IF p_action_choice CLIPPED = "confirm" OR
     g_action_choice CLIPPED = "insert" OR
     g_action_choice CLIPPED = "modify" THEN    #執行 "確認" 功能(非簽核模式呼叫)
     SELECT ogamksg,oga55 INTO l_ogamksg,l_oga55 FROM oga_file
      WHERE oga01=p_oga01
     IF l_ogamksg='Y'   THEN
        IF l_oga55 != '1' THEN
           CALL cl_err('','aws-078',1)
           LET g_success = 'N'
           ROLLBACK WORK
           RETURN
        END IF
     END IF
     IF g_bgjob='N' OR cl_null(g_bgjob) THEN
        IF NOT cl_confirm('axm-108') THEN
           LET g_success='N'
           ROLLBACK WORK
           RETURN
        END IF
     END IF
  END IF
#CHI-C30107 ------------------ add ---------------- begin
 SELECT * INTO l_oga.* FROM oga_file WHERE oga01 = p_oga01

 LET l_argv0=l_oga.oga09  
 IF l_oga.oga01 IS NULL THEN
    CALL cl_err('',-400,0)
    LET g_success = 'N'   
    RETURN
 END IF
 IF l_oga.ogaconf = 'X' THEN
    CALL cl_err('',9024,0)
    LET g_success = 'N'  
    RETURN
 END IF
 IF l_oga.ogaconf = 'Y' THEN
    LET g_success = 'N'   
    CALL cl_err('','axm-101',0)  
    RETURN
 END IF
#CHI-C30107 ------------------ add ---------------- end
#CHI-C30118---add---END   
 #FUN-C40089---begin
 SELECT oah08 INTO g_oah08 FROM oah_file WHERE oah01=l_oga.oga31
 IF cl_null(g_oah08) THEN
    LET g_oah08 = 'Y'
 END IF 
 IF g_oah08= 'N' THEN
    LET l_cnt = 0
    SELECT COUNT(*) INTO l_cnt FROM ogb_file
       WHERE ogb01=l_oga.oga01 AND ogb13=0
    IF l_cnt > 0 THEN
       CALL cl_err('','axm-627',1)    #FUN-C50074
       LET g_success = 'N'
       RETURN
    END IF
 END IF
 #FUN-C40089---end
 #FUN-CB0087--add--str--
 IF g_aza.aza115='Y' AND l_argv0 MATCHES '[245689A]' THEN
    IF l_argv0 MATCHES '[2456A]' THEN
       SELECT COUNT(*) INTO l_cnt FROM ogb_file WHERE trim(ogb1001) IS NULL AND ogb01=l_oga.oga01
    ELSE  # 8 9
       SELECT COUNT(*) INTO l_cnt FROM ogb_file WHERE trim(ogb65) IS NULL AND ogb01=l_oga.oga01 AND ogb52<>0
    END IF 
    IF l_cnt>=1 THEN
       CALL cl_err('','aim-888',1)
       LET g_success='N'
       RETURN
    END IF
 END IF 
 #FUN-CB0087--add--end--

#DEV-D40019 mark str-------
##DEV-D40015 add str-------
##若aimi100[條碼使用否]=Y且有勾選製造批號/製造序號，需控卡不可直接確認or過帳
#IF g_aza.aza131 = 'Y' AND (g_prog = 'axmt610') THEN
#  #確認是否有符合條件的料件
#   LET l_cnt = 0
#   SELECT COUNT(*) INTO l_cnt
#     FROM ima_file
#    WHERE ima01 IN (SELECT ogb04 FROM ogb_file WHERE ogb01 = l_oga.oga01) #料件
#      AND ima930 = 'Y'                   #條碼使用否
#      AND (ima921 = 'Y' OR ima918 = 'Y') #批號管理否='Y' OR 序號管理否='Y'
#     
#  #確認是否已有掃描紀錄
#   IF l_cnt > 0 THEN
#      IF cl_null(l_oga.oga011) AND l_oga.oga09 = '1' THEN #oga09='1':出貨通知單 #DEV-D40018 add if 判斷當出通單號(oga011) 沒有值時
#          IF NOT s_chk_barcode_confirm('confirm','ibj',l_oga.oga01,'','') THEN
#             LET g_success = 'N'
#             RETURN
#          END IF
#      END IF #DEV-D40018 add
#   END IF
#END IF
##DEV-D40015 add end-------
#DEV-D40019 mark end-------

#str----add by huanglf161207
#IF g_prog = 'axmt610' THEN
#    SELECT tc_ool02 INTO l_tc_ool02 FROM tc_ool_file WHERE tc_ool01 = l_oga.oga01
#    IF cl_null(l_tc_ool02) THEN
#       CALL cl_err('','cxm-031',1)
#       LET g_success = 'N'
#    END IF 
#END IF 
#str----end by huanglf161207
#mark by huanglf161207
 IF g_azw.azw04='2' THEN
   #TQC-C30283--add--str--
   IF l_oga.oga57 = '2' THEN 
      SELECT COUNT(*) INTO l_n FROM ogb_file WHERE ogb01 = l_oga.oga01 AND ogb49 IS NULL 
      IF l_n > 0 THEN 
         CALL cl_err('','axm-688',1)
         LET g_success='N'
         RETURN
      END IF 
   END IF 
   #TQC-C30283--add--end--
   IF l_oga.oga85='1' THEN
      SELECT SUM(ogb14t) INTO l_ogb14t_1 FROM ogb_file
       WHERE ogb01=l_oga.oga01
      IF SQLCA.sqlcode=100 THEN LET l_ogb14t_1=NULL END IF                                                                       
      IF cl_null(l_ogb14t_1) THEN LET l_ogb14t_1=0 END IF  
#FUN-AB0061 -----------mark start----------------    
#     SELECT SUM(ogb47) INTO l_ogb47 FROM ogb_file                                                                           
#      WHERE ogb01=l_oga.oga01
#     IF cl_null(l_ogb47) THEN LET l_ogb47=0 END IF
#FUN-AB0061 -----------mark end----------------
      SELECT azi04 INTO t_azi04 FROM azi_file
        WHERE azi01=l_oga.oga23                  
#FUN-AB0061 -----------mark start----------------                                                  
#     IF l_oga.oga213='N' THEN                                                                                                
#        LET l_ogb47=l_ogb47*(1+l_oga.oga211/100)                                                                             
#        CALL cl_digcut(l_ogb47,t_azi04) RETURNING l_ogb47                                                                   
#     END  IF                                                                                                                
#     LET l_ogb14t_1=l_ogb14t_1-l_ogb47          
#FUN-AB0061 -----------mark end----------------                                                                                 
      CALL cl_digcut(l_ogb14t_1,t_azi04) RETURNING l_ogb14t_1     
      SELECT SUM(rxx04) INTO l_rxx04 FROM rxx_file
       WHERE rxx00='02' AND rxx01=l_oga.oga01
         AND rxx03='1' 
      IF SQLCA.sqlcode THEN 
         CALL cl_err('sel SUM(RXX04)',STATUS,0)
         LET l_rxx04=NULL 
      END IF  
      IF cl_null(l_rxx04) THEN LET l_rxx04=0 END IF      
      IF l_rxx04<l_ogb14t_1 THEN
         CALL cl_err('','art-308',0)
         LET g_success='N'
         RETURN
      END IF 
   END IF
 END IF

#TQC-B20053 -------------STA
#單身中項次對應的所有單價不可以低於採購策略中的最低價 
 IF g_azw.azw04='2' THEN                             
    DECLARE ogb13_curs CURSOR FOR 
       SELECT ogb04,ogb05,ogb13 FROM ogb_file 
        WHERE ogb01 = l_oga.oga01   
    FOREACH ogb13_curs INTO l_ogb04,l_ogb05,l_ogb13
        SELECT rtz05 INTO l_rtg01 FROM rtz_file 
             WHERE rtz01 = g_plant
        IF NOT cl_null(l_rtg01) AND l_ogb04 <> 'MISCCARD' THEN #FUN-C10051 add "AND l_ogb04 <> 'MISCCARD'"
           SELECT rtg07,rtg08 INTO l_rtg07,l_rtg08 FROM rtg_file,rtf_file
                WHERE rtg01=rtf01 AND rtfconf='Y'
                  AND rtg01 = l_rtg01
                  AND rtg03 = l_ogb04 AND rtg04 = l_ogb05
           IF SQLCA.sqlcode=100 THEN  
 #             CALL s_errmsg('ogb03',l_ogb04,' ','art-273',1)
              CALL cl_err('','art-273',0)
              LET g_success='N'
 #             CONTINUE FOREACH
              RETURN
           END IF
           IF l_rtg08='Y' THEN 
              SELECT rth06 INTO l_rth06 FROM rth_file
               WHERE rth01=l_ogb04                                          
                 AND rth02=l_ogb05 
                 AND rthplant=g_plant
              IF SQLCA.sqlcode=100 THEN
 #                CALL s_errmsg('ogb03',l_ogb04,' ','art-273',1)
                 CALL cl_err('','art-671',0) #MOD-B30620 mod art-273->art-671
                 LET g_success='N'
 #                CONTINUE FOREACH
                 RETURN
              END IF
              IF l_ogb13 < l_rth06 THEN
 #                CALL s_errmsg('ogb03',l_ogb13,' ','art-300',1)
                 CALL cl_err('','art-300',0)
                 LET g_success='N'
 #                CONTINUE FOREACH
                 RETURN
              END IF
           ELSE
              IF l_ogb13 < l_rtg07 THEN
 #                CALL s_errmsg('ogb03',l_ogb13,' ','art-268',1)
                 CALL cl_err('','art-268',0)
                 LET g_success='N'
 #                CONTINUE FOREACH
                 RETURN
              END IF
           END IF
        END IF

    END FOREACH

 END IF
#TQC-B20053 -------------END

#FUN-BC0071 -----------STA
    SELECT COUNT(*) INTO l_n  FROM ogb_file 
     WHERE ogb01 = l_oga.oga01
       AND ogb1001 = g_oaz.oaz88
     IF l_n > 0 THEN
       DECLARE l_ogb04_cur CURSOR FOR
        SELECT ogb04 FROM ogb_file
         WHERE ogb01= l_oga.oga01
           AND ogb1001 = g_oaz.oaz88
       FOREACH  l_ogb04_cur INTO l_ogb04_1 
          SELECT COUNT(*) INTO l_n FROM lpx_file,lqe_file,lqw_file
           WHERE lpx32 = l_ogb04_1 AND lpx01 = lqe02         #TQC-C20407 mod
             AND lqw08 = lqe02 AND lqw00 = '02'
              AND lqw01= l_oga.oga01
              AND lqe01 BETWEEN lqw09 AND lqw10
              AND ((lqe17 NOT IN ('5','2') AND lqe13 = l_oga.ogaplant)
                 OR (lqe17 IN ('5','2') AND lqe13  <> l_oga.ogaplant))
           IF l_n > 0 THEN
              CALL s_errmsg("ogb04",l_ogb04_1,"",'alm1567',1)
              LET g_success = "N"
              CONTINUE FOREACH
           END IF
       END FOREACH
       IF g_success = "N" THEN
          RETURN
       END IF
     END IF
  

#FUN-BC0071 -----------END  


#FUN-BC0064-----add----str------
#產品編號的數量要於券張數一致
IF g_azw.azw04 = '2' THEN
   CALL s_showmsg_init()
      
   LET g_sql = " SELECT ogb03,ogb04,ogb12,ogb1001 FROM ogb_file ",
               "  WHERE ogb01 = '",p_oga01,"' "
   DECLARE t600_sel_ogb_cr CURSOR FROM g_sql
   FOREACH t600_sel_ogb_cr INTO l_ogb03,l_ogb04,l_ogb12,l_ogb1001
      SELECT ima154 INTO l_ima154
        FROM ima_file
       WHERE ima01 = l_ogb04
      IF l_ima154 = 'Y' THEN
        #TQC-C20501----mark---str---
        #IF l_ogb1001 = g_oaz.oaz88 THEN
        #   SELECT lqw08_1 INTO l_lqw08_1_s
        #     FROM s_gifts_tmp
        #    WHERE ima01 = l_ogb04 
        #   SELECT SUM(lqw12) INTO l_lqw12
        #     FROM lqw_file
        #    WHERE lqw00 = '02' 
        #      AND lqw08 = l_lqw08_1_s
        #      AND lqw01 = p_oga01
        #   IF cl_null(l_lqw12) THEN
        #      LET l_lqw12 = 0
        #   END IF
        #   IF l_ogb12 <> l_lqw12 THEN
        #      LET g_showmsg = l_ogb03,"/",l_ogb04
        #      CALL s_errmsg('ogb03,ogb04',g_showmsg,'','axm-686',1)
        #      LET g_success = 'N'
        #   END IF 
        #ELSE
        #TQC-C20501----mark---end---
        #IF l_ogb1001 <> g_oaz.oaz88 OR (cl_null(l_ogb1001) AND NOT cl_null(g_oaz.oaz88)) #TQC-C20501 add  #FUN-CA0152 mark
        #   OR (NOT cl_null(l_ogb1001) AND cl_null(g_oaz.oaz88))THEN                      #TQC-C20501 add  #FUN-CA0152 mark
        #FUN-CA0152---------add----str
         LET l_n = 0
         SELECT COUNT(*) INTO l_n
           FROM lqw_file
          WHERE lqw00 = '02'
            AND lqw01 = l_ogb04 
        IF l_n = 0 THEN
        #FUN-CA0152---------add----end
            SELECT SUM(rxe08) INTO l_rxe08
              FROM rxe_file
             WHERE rxe00 = '02'
               AND rxe01 = p_oga01
               AND rxe02 = l_ogb03
            IF cl_null(l_rxe08) THEN
               LET l_rxe08 = 0
            END IF
            IF l_ogb12 <> l_rxe08 THEN
               LET g_showmsg = l_ogb03,"/",l_ogb04
               CALL s_errmsg('ogb03,ogb04',g_showmsg,'','axm-686',1)
               LET g_success = 'N'
            END IF
         END IF
      END IF
   END FOREACH
   CALL s_showmsg()
   IF g_success = 'N' THEN
      RETURN
   END IF
   #檢查券起訖編號範圍內是否有包含非5.發放或2.退回狀態的券    
   CALL s_showmsg_init()
   LET g_sql = " SELECT rxe02,rxe04,rxe05 FROM rxe_file ",    #TQC-C30129 add rxe02
               "  WHERE rxe01 = '",p_oga01,"' ",
               "    AND rxe00 = '02' " 
   DECLARE t620_sel_rxe_cr CURSOR FROM g_sql
   FOREACH t620_sel_rxe_cr INTO l_rxe02,l_rxe04,l_rxe05      #TQC-C30129 add rxe02
#TQC-C30129 -------------STA
      SELECT ogb31 INTO l_ogb31_1 FROM ogb_file WHERE ogb01 = p_oga01 AND ogb03 =l_rxe02
      IF NOT cl_null(l_ogb31_1 ) THEN
         CONTINUE FOREACH
      END IF
#TQC-C30129 -------------END
      LET g_sql = "SELECT lqe01 FROM lqe_file ",
                  " WHERE lqe01 BETWEEN '",l_rxe04,"' AND '",l_rxe05,"'",
                  "   AND (lqe17 <> '5' OR lqe13 <> '",l_oga.ogaplant,"')",
                  "   AND (lqe17 <> '2' OR lqe09 <> '",l_oga.ogaplant,"')"
      PREPARE sel_lqe_pre FROM g_sql 
      DECLARE sel_lqe_cs CURSOR FOR sel_lqe_pre 
      FOREACH sel_lqe_cs INTO l_lqe01
         CALL s_errmsg('',l_lqe01,'','axm-685',1)
         LET g_success = 'N'
      END FOREACH  
   END FOREACH
   CALL s_showmsg()
   IF g_success = 'N' THEN
      RETURN
   END IF
END IF

#FUN-BC0064-----add----end------

#無單身資料不可確認
 LET l_cnt=0
 SELECT COUNT(*) INTO l_cnt
   FROM ogb_file
  WHERE ogb01=l_oga.oga01
 IF l_cnt=0 OR l_cnt IS NULL THEN
    CALL cl_err('','mfg-009',0)
    LET g_success = 'N'   #FUN-580113
    RETURN
 END IF

 #FUN-C70098----add----begin--------------
 IF s_industry("slk") AND g_azw.azw04 = '2' THEN
    DECLARE ogbslk04_curs CURSOR FOR
       SELECT ogbslk03,ogbslk04,ogbslk12 FROM ogbslk_file WHERE ogbslk01 = l_oga.oga01 
    CALL s_showmsg_init()
    FOREACH ogbslk04_curs INTO l_ogbslk03,l_ogbslk04,l_ogbslk12 
         IF cl_null(l_ogbslk12) OR l_ogbslk12 = 0 THEN
            CALL s_errmsg('', l_oga.oga01 ,l_ogbslk04 ,'axr-034',1)
            LET g_success = 'N'
         END IF
    END FOREACH
    CALL s_showmsg()
    IF g_success = 'N' THEN
       RETURN
    END IF
 END IF
 #FUN-C70098----add----end----------------
 IF (l_oga.oga08='1' AND l_cnt > g_oaz.oaz691) OR
    (l_oga.oga08 MATCHES '[23]' AND l_cnt > g_oaz.oaz692) THEN
    CALL cl_err('','axm-158',0)
    LET g_success = 'N'   #FUN-580113
    RETURN
 END IF
 #除了簽收單之外,單身不可有數量為0者, (在出貨單中審核時判斷出貨數量時排除折扣單的資料MOD-CC0232)
 LET l_cnt = 0 
 SELECT COUNT(*) INTO l_cnt FROM oga_file,ogb_file 
   WHERE oga01 = ogb01 
     AND oga01 = l_oga.oga01
     AND oeb1007 IS NULL #MOD-CC0232 add
     AND (ogb12 IS NULL OR 
          (oga09 = '8' AND ogb12 < 0) OR 
          (oga09 <> '8' AND ogb12 <= 0))
 IF l_cnt > 0 THEN
    CALL cl_err('','mfg3348',0)
    LET g_success = 'N'
    RETURN
 END IF

 #MOD-B30697 add --start--
 #oga07為Y時,oga13不可空白
 IF l_oga.oga07 = 'Y' AND cl_null(l_oga.oga13) THEN
    CALL cl_err('','axm-429',1)
    LET g_success = 'N'
    RETURN
 END IF
 #MOD-B30697 add --end--
 
   IF g_azw.azw04<>'2' THEN #No.FUN-870007
      IF l_oga.oga161>0 THEN
        DECLARE ogb_curs CURSOR FOR 
          SELECT ogb31 FROM ogb_file WHERE ogb01=l_oga.oga01
        FOREACH ogb_curs INTO l_ogb31 
           SELECT SUM(oma55) INTO l_oma55
             FROM oma_file
            WHERE oma16=l_ogb31   #MOD-850221   
              AND oma00='11'
              AND omaconf='Y'
           IF SQLCA.sqlcode OR cl_null(l_oma55) THEN
              LET l_oma55=0
           END IF
           SELECT SUM(oma54t) INTO l_oma54t
             FROM oma_file
            WHERE oma16=l_ogb31   #MOD-850221   
              AND oma00='11'
              AND omaconf='Y'
           IF SQLCA.sqlcode OR cl_null(l_oma54t) THEN
              LET l_oma54t=0
           END IF
           #TQC-AB0381 add ---------------begin----------------
           SELECT SUM(oma54) INTO l_oma54
             FROM oma_file
            WHERE oma16=l_ogb31   
              AND oma00='11'
              AND omaconf='Y'
           IF SQLCA.sqlcode OR cl_null(l_oma54) THEN
              LET l_oma54=0
           END IF
           #TQC-AB0381 add ----------------end----------------- 
           #-----No:FUN-A50103-----
           SELECT oea261,oea213 INTO l_oea261,l_oea213       #TQC-B30120 add oea213
             FROM oea_file
            WHERE oea01 = l_ogb31
           IF SQLCA.sqlcode OR cl_null(l_oea261) THEN
              LET l_oea261=0
           END IF

           IF l_oga.oga00 != '3' THEN #TQC-C20023 add
#TQC-B30120 --begin--
              CASE 
                WHEN (l_oea213 = 'Y')
                   IF l_oma54t <> l_oea261 THEN 
                      CALL cl_err('','axm-135',1)
                      LET g_success='N'
                      RETURN                   
                   END IF                      
                WHEN (l_oea213 = 'N')
                   IF l_oma54 <> l_oea261 THEN 
                      IF g_aza.aza26 != '2' OR g_ooz.ooz33 = 'Y' THEN #FUN-C90105 add
                         CALL cl_err('','axm-135',1)                
                         LET g_success='N'
                         RETURN                   
                      END IF #FUN-C90105 add
                   END IF                
               END CASE                            
#              #IF l_oma54t<>l_oea261 THEN #TQC-AB0381 mark
#              IF l_oma54<>l_oea261 THEN  #TQC-AB0381 add
#                CALL cl_err('','axm-135',1)
#                LET g_success='N'
#                RETURN
#              END IF
#              #-----No:FUN-A50103 END-----
#TQC-B30120    --end--

              IF (l_oma55<l_oma54t) OR (l_oma54t=0) THEN
                CALL cl_err('','axm-135',1) #MOD-780163
                LET g_success='N'
                RETURN
              END IF
           END IF #TQC-C20023 add
        END FOREACH   #MOD-850221
      END IF
   END IF  #No.FUN-870007

#Check 倉是否為可用倉
 DECLARE t600sub_ogb09_1 CURSOR FOR
 SELECT ogb09 FROM ogb_file
  WHERE ogb01=l_oga.oga01
 FOREACH t600sub_ogb09_1 INTO l_ogb09
    IF NOT cl_null(l_ogb09) THEN
       LET l_cnt=0
       #-----MOD-B50094---------
       #SELECT count(*) INTO l_cnt FROM imd_file
       # WHERE imd01=l_ogb09
       #   AND imd11='Y'
       #   AND imdacti='Y'
       IF l_oga.oga00 = 'B' THEN
          LET l_sql = "SELECT count(*) FROM imd_file ",
                      " WHERE imd01='",l_ogb09,"'",
                     # "   AND imd11='N'",
                      "   AND imdacti='Y'"
       ELSE
          LET l_sql = "SELECT count(*) FROM imd_file ",
                      " WHERE imd01='",l_ogb09,"'",
                      #"   AND imd11='Y'",
                      "   AND imdacti='Y'"
       END IF
       PREPARE t600_imd_c2 FROM l_sql
       EXECUTE t600_imd_c2 INTO l_cnt
       #-----END MOD-B50094-----
       IF l_cnt=0 THEN
          #MOD-C30819 ----- add start -----
          IF l_oga.oga00 = 'B' THEN
             CALL cl_err(l_ogb09,'axm_612',0)
          ELSE
          #MOD-C30819 -----  add end  -----
             CALL cl_err(l_ogb09,'axm-993',0)
          END IF #MOD-C30819 add
          LET g_success = 'N'   #FUN-580113
          RETURN
       END IF
       #No.FUN-AA0048  --Begin
       IF NOT s_chk_ware(l_ogb09) THEN
          LET g_success = 'N'   #FUN-580113
          RETURN
       END IF
       #No.FUN-AA0048  --End  
    ELSE
       CONTINUE FOREACH
    END IF
 END FOREACH

 #No.FUN-AA0048  --Begin
 IF NOT s_chk_ware(l_oga.oga66) THEN
    LET g_success = 'N'
    RETURN
 END IF
 IF NOT s_chk_ware(l_oga.oga910) THEN
    LET g_success = 'N'
    RETURN
 END IF
 DECLARE t600sub_ware_cs1 CURSOR FOR
  SELECT ogg09 FROM ogg_file
   WHERE ogg01 = l_oga.oga01
 FOREACH t600sub_ware_cs1 INTO l_ogb09
     IF NOT s_chk_ware(l_ogb09) THEN
        LET g_success = 'N'
        RETURN
     END IF
 END FOREACH
 DECLARE t600sub_ware_cs2 CURSOR FOR
  SELECT ogc09 FROM ogc_file
   WHERE ogc01 = l_oga.oga01
 FOREACH t600sub_ware_cs2 INTO l_ogb09
     IF NOT s_chk_ware(l_ogb09) THEN
        LET g_success = 'N'
        RETURN
     END IF
 END FOREACH
 #No.FUN-AA0048  --End  
 
   DECLARE t600sub_ogbrvbs CURSOR FOR
   SELECT * FROM ogb_file
    WHERE ogb01=l_oga.oga01

   #MOD-C40149 add --start--
   LET l_sql= " SELECT * FROM ogc_file WHERE ogc01='",l_oga.oga01,"' AND ogc03=?" 
   PREPARE t600_chk_pre1 FROM l_sql
   DECLARE t600_chk_cs1 CURSOR FOR t600_chk_pre1 

   LET l_sql= " SELECT * FROM ogg_file WHERE ogg01='",l_oga.oga01,"' AND ogg03=?" 
   PREPARE t600_chk_pre2 FROM l_sql
   DECLARE t600_chk_cs2 CURSOR FOR t600_chk_pre2 
   #MOD-C40149 add --end--
 
   FOREACH t600sub_ogbrvbs INTO l_ogb.*
      #FUN-A40022--begin-----
#FUN-B50096 -------------Begin--------------
   #  IF s_industry('icd') THEN
   #     LET l_imaicd13=''                                                                                                    
   #     SELECT imaicd13 INTO l_imaicd13                                                                                      
   #       FROM imaicd_file                                                                                                   
   #      WHERE imaicd00 = l_ogb.ogb04                                                                                  
   #     IF l_imaicd13 = 'Y' AND cl_null(l_ogb.ogb092) THEN                                                             
     #CHI-C30104 add START
     #非多倉儲時 axmt640 確認時, 檢查 ogb09 倉庫別, 與 axms100 中的 oaz78(借出客戶倉庫), 是否同屬於成本倉, 或是非成本倉.
     #若不同, 則顯示錯誤訊息, 並取消確認的動作
      LET l_n = 0
      LET l_n2 = 0
      IF l_oga.oga09 = 'A' AND NOT cl_null(g_oaz.oaz78) THEN  #借貨出貨單
         SELECT COUNT(*) INTO l_n FROM jce_file WHERE jce02 = g_oaz.oaz78
         IF cl_null(l_n2) THEN LET l_n2 = 0 END IF
         IF l_ogb.ogb17 = 'N' THEN
            SELECT COUNT(*) INTO l_n2 FROM jce_file WHERE jce02 = l_ogb.ogb09
           #出貨倉為非成本倉
            IF l_n > 0 THEN
               IF l_n2 = 0 OR cl_null(l_n2) THEN
                  LET g_success = 'N'
                  CALL cl_err(l_ogb.ogb09,'axm-569',1)  #出貨倉庫為非成本倉但借出客戶倉庫為成本倉
                  RETURN
               END IF
           #出貨倉為成本倉
            ELSE
               IF l_n2 > 0 THEN
                  LET g_success = 'N'
                  CALL cl_err(l_ogb.ogb09,'axm-570',1)  #出貨倉庫為成本倉但借出客戶倉庫為非成本倉
                  RETURN
               END IF
            END IF
         END IF
        #多倉儲 axmt640 按確認時, 去檢查 ogc12 > 0 的 ogc09 倉庫別(有多筆資料), 與 axms100 中的 oaz78(借出客戶倉庫), 是否同屬於成本倉, 或是非成本倉.
        #若不同, 則顯示錯誤訊息, 並取消確認的動作.
         IF l_ogb.ogb17 = 'Y' THEN
            FOREACH t600_chk_cs1 USING l_ogb.ogb03 INTO l_ogc.*
               LET l_n2 = 0
               SELECT COUNT(*) INTO l_n2 FROM jce_file WHERE jce02 = l_ogc.ogc09
               IF cl_null(l_n2) THEN LET l_n2 = 0 END IF
               IF l_n = 0 AND l_n2 > 0 THEN   #出貨倉庫為成本倉但借出客戶倉庫為非成本倉
                  LET g_success = 'N'
                  CALL cl_err(l_ogc.ogc09,'axm-570',1)
                  RETURN
               END IF
               IF l_n > 0 AND l_n2 = 0 THEN   #出貨倉庫為非成本倉但借出客戶倉庫為成本倉
                  LET g_success = 'N'
                  CALL cl_err(l_ogc.ogc09,'axm-569',1)
                  RETURN
               END IF
            END FOREACH
         END IF
      END IF
     #CHI-C30104 add END
      LET l_ima159 = ''
      SELECT ima159 INTO l_ima159 FROM ima_file
       WHERE ima01 = l_ogb.ogb04
      #IF l_ima159 = '1' AND cl_null(l_ogb.ogb092) THEN   #FUN-B40081 mark
      IF l_ima159 = '1' AND cl_null(l_ogb.ogb092) AND l_ogb.ogb17!='Y' 
         AND g_prog[1,7] <> 'axmt610'    #FUN-B40081    #TQC-C50149 g_prog
         AND l_oga.oga09 <>'8' THEN  #MOD-C80250 add
#FUN-B50096 -------------End----------------
            LET g_success = 'N'
            CALL cl_err(l_ogb.ogb04,'aim-034',1)                                                                        
            RETURN
   #     END IF       #FUN-B50096
      END IF
      #FUN-A40022--end--add----------
      LET g_ima918 = ''   #MOD-9C0055
      LET g_ima921 = ''   #MOD-9C0055
      LET g_ima906 = ''   #MOD-C50088 
      SELECT ima918,ima921,ima906,ima930  #MOD-C50088 add ima906  #DEV-D30040 add ima930
        INTO g_ima918,g_ima921,g_ima906,g_ima930 
        FROM ima_file
       WHERE ima01 = l_ogb.ogb04
         AND imaacti = "Y"

      IF cl_null(g_ima930) THEN LET g_ima930 = 'N' END IF  #DEV-D30040 add
      
     #IF NOT (l_oga.oga09='1' AND g_oaz.oaz81='N') THEN  ##FUN-850120  #出通單要判斷參數            #MOD-B50180
      IF NOT (l_oga.oga09 MATCHES '[15]' AND g_oaz.oaz81='N') THEN  ##FUN-850120  #出通單要判斷參數 #MOD-B50180 mod
         IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
            #MOD-C40149 add --start--
            IF l_ogb.ogb17='Y' THEN   #多倉儲出貨
               IF g_sma.sma115 = 'Y' THEN
                  FOREACH t600_chk_cs2 USING l_ogb.ogb03 INTO l_ogg.*
                     IF STATUS THEN
                        CALL cl_err('t600_chk_cs2:',STATUS,0)
                        LET g_success = 'N'
                        RETURN
                     END IF
                     IF g_ima906 = '3' AND l_ogg.ogg20 = '2' THEN  #MOD-C50088 add
                     ELSE                                          #MOD-C50088 add
                        SELECT SUM(rvbs06) INTO l_rvbs06
                          FROM rvbs_file
                         WHERE rvbs00 = g_prog
                           AND rvbs01 = l_ogb.ogb01
                           AND rvbs02 = l_ogb.ogb03 
                           AND rvbs13 = l_ogg.ogg18 
                           AND rvbs09 = -1 

                        IF cl_null(l_rvbs06) THEN
                           LET l_rvbs06 = 0
                        END IF
                        
                        CALL s_umfchk(l_ogb.ogb04,l_ogg.ogg10,l_ogb.ogb05) #FUN-C80001
                           RETURNING l_flag,l_ogg.ogg15_fac  #FUN-C80001
                        
                        IF (g_ima930 = 'Y' and l_rvbs06 <> 0) OR g_ima930 = 'N' THEN  #DEV-D30040
                           IF (l_ogg.ogg12 * l_ogg.ogg15_fac) <> l_rvbs06 THEN 
                              LET g_success = "N"
                              CALL cl_err(l_ogb.ogb04,"aim-011",1)
                              RETURN
                           END IF
                        END IF                                                        #DEV-D30040
                     END IF          #MOD-C50088 add
                  END FOREACH 
               ELSE
                  FOREACH t600_chk_cs1 USING l_ogb.ogb03 INTO l_ogc.*
                     IF STATUS THEN
                        CALL cl_err('t600_chk_cs1:',STATUS,0)
                        LET g_success = 'N'
                        RETURN
                     END IF

                     SELECT SUM(rvbs06) INTO l_rvbs06
                       FROM rvbs_file
                      WHERE rvbs00 = g_prog
                        AND rvbs01 = l_ogb.ogb01
                        AND rvbs02 = l_ogb.ogb03 
                        AND rvbs13 = l_ogc.ogc18 
                        AND rvbs09 = -1 

                     IF cl_null(l_rvbs06) THEN
                        LET l_rvbs06 = 0
                     END IF

                     IF (g_ima930 = 'Y' and l_rvbs06 <> 0) OR g_ima930 = 'N' THEN  #DEV-D30040
                        IF (l_ogc.ogc12 * l_ogc.ogc15_fac) <> l_rvbs06 THEN 
                           LET g_success = "N"
                           CALL cl_err(l_ogb.ogb04,"aim-011",1)
                           RETURN
                        END IF
                     END IF                                                        #DEV-D30040
                  END FOREACH 
               END IF
            ELSE
            #MOD-C40149 add --end--
               SELECT SUM(rvbs06) INTO l_rvbs06
                 FROM rvbs_file
                WHERE rvbs00 = g_prog
                  AND rvbs01 = l_ogb.ogb01
                  AND rvbs02 = l_ogb.ogb03    #FUN-850120
                  AND rvbs09 = -1
         
               IF cl_null(l_rvbs06) THEN
                  LET l_rvbs06 = 0
               END IF
              #CHI-C30064---Start---add
               SELECT img09 INTO l_img09 FROM img_file
                WHERE img01= l_ogb.ogb04 AND img02= l_ogb.ogb09
                  AND img03= l_ogb.ogb091 AND img04= l_ogb.ogb092
               CALL s_umfchk(l_ogb.ogb04,l_ogb.ogb05,l_img09) RETURNING g_cnt,l_ogb05_fac
               IF g_cnt = '1' THEN
                  LET  l_ogb05_fac = 1
               END IF                         
              #CHI-C30064---End---add            
              #IF (l_ogb.ogb12 * l_ogb.ogb05_fac) <> l_rvbs06 THEN   #No.FUN-860045
               IF (g_ima930 = 'Y' and l_rvbs06 <> 0) OR g_ima930 = 'N' THEN  #DEV-D30040
                  IF (l_ogb.ogb12 * l_ogb05_fac) <> l_rvbs06 THEN #CHI-C30064
                     LET g_success = "N"
                     CALL cl_err(l_ogb.ogb04,"aim-011",1)
                     RETURN
                  END IF
               END IF                                                        #DEV-D30040
            END IF #MOD-C40149 add
         END IF
      END IF    ##FUN-850120

      #CHI-AC0034 add --start--
      #IF g_prog = "axmt628" OR g_prog= "axmt629" THEN   #FUN-B40066 mark
      IF g_prog[1,7] = "axmt628" OR g_prog[1,7] = "axmt629" THEN    #FUN-B40066   
         IF l_ogb.ogb17='Y' AND g_oaz.oaz23 = 'Y' THEN     ##多倉儲出貨
            SELECT SUM(ogc12) INTO l_ogc12_t FROM ogc_file
             WHERE ogc01 = l_oga.oga01 AND ogc03 = l_ogb.ogb03
            IF l_ogc12_t != l_ogb.ogb12 THEN
               LET g_success = "N"
               CALL cl_err(l_ogb.ogb12,"axm-185",1)
               RETURN
            END IF
         END IF
      END IF
      #CHI-AC0034 add --end--

   END FOREACH
 
 #若現行年月大於出貨單/銷退單之年月--不允許確認
 IF l_argv0 NOT MATCHES '[15]' THEN    #No.MOD-880260   
 CALL s_yp(l_oga.oga02) RETURNING l_yy,l_mm #No.TQC-7C0070
 IF (l_yy > g_sma.sma51) OR (l_yy = g_sma.sma51 AND l_mm > g_sma.sma52) THEN
     CALL cl_err('','mfg6090',0)  #MOD-790009
     LET g_success = 'N'   #FUN-580113
     RETURN
 END IF
 END IF                                #No.MOD-880260 
 
 IF NOT (l_argv0 = '1' OR l_argv0 = '5')  THEN   #不是出通單 #MOD-B30665 add
    IF g_oaz.oaz03 = 'Y' AND
       g_sma.sma53 IS NOT NULL AND l_oga.oga02 <= g_sma.sma53 THEN
       CALL cl_err('','mfg9999',0)
       LET g_success = 'N'   #FUN-580113
       RETURN
    END IF
 END IF #MOD-B30665 add
 #No.7992  多角貿易單據
 IF l_oga.oga909 = 'Y' THEN
    IF l_oga.oga905= 'Y' THEN   #拋轉否
       CALL cl_err(l_oga.oga905,'axm-307',0)
       LET g_success = 'N'   #FUN-580113
       RETURN
    END IF
 
 
    IF l_oga.oga906 <>'Y' THEN     #是否為來源出貨單
       CALL cl_err(l_oga.oga906,'axm-402',0)         #No.MOD-660080 modify
       LET g_success = 'N'   #FUN-580113
       RETURN
    END IF
 END IF
 #若採訂單匯率立帳則幣別匯率相同才可併單
 IF NOT t600sub_oea18_chk(0,l_oga.*,NULL,FALSE) THEN
    LET g_success = 'N'   #FUN-580113
    RETURN
 ELSE
    SELECT oga24 INTO l_oga.oga24 FROM oga_file WHERE oga01=g_oga.oga01 #FUN-730012 add oga24的值可能被異動,必須重抓
 END IF
 # 為防立應收不對,加上若單頭有輸入訂單號碼時,
 #                       check 訂單的訂金,出貨比率有沒有一致
  IF NOT cl_null(l_oga.oga16) THEN
     SELECT oea161,oea162,oea163 INTO l_oea161,l_oea162,l_oea163 FROM oea_file
      WHERE oea01=l_oga.oga16
     IF cl_null(l_oea161) THEN LET l_oea161=0   END IF
     IF cl_null(l_oea162) THEN LET l_oea162=100 END IF #MODNO:5230
     IF cl_null(l_oea163) THEN LET l_oea163=0   END IF
     IF l_oea161 != l_oga.oga161 OR l_oea162 !=l_oga.oga162 OR
        l_oea163 != l_oga.oga163 THEN
        CALL cl_err(l_oga.oga16,'mfg-010',1)
        LET g_success = 'N'   #FUN-580113
        RETURN
     END IF
  END IF
 
  IF g_sma.sma115= 'Y' THEN   #TQC-620100
     LET l_x1 = "Y"
     LET l_x2 = "Y"
     LET l_sql="SELECT ogb910,ogb912 FROM ogb_file ",     #No.FUN-610064
               " WHERE ogb01='",l_oga.oga01,"'",
               "   AND ogb1005='1' "
     PREPARE pre_ogb3 FROM l_sql
     DECLARE ogb_curs3 CURSOR FOR pre_ogb3
     FOREACH ogb_curs3 INTO l_ogb910,l_ogb912
        IF cl_null(l_ogb910) THEN LET l_x1 = "N" END IF
        IF cl_null(l_ogb912) THEN LET l_x2 = "N" END IF
     END FOREACH
     IF l_x1 = "N" THEN
        #出貨單位欄位不可空白
        CALL cl_getmsg('asm-303',g_lang) RETURNING l_msg1
        CALL cl_getmsg('mfg0037',g_lang) RETURNING l_msg2
        LET l_msg = l_msg1 CLIPPED,l_msg2
     END IF
     IF l_x2 = "N" THEN
        #出貨數量欄位不可空白
        CALL cl_getmsg('asm-307',g_lang) RETURNING l_msg1
        CALL cl_getmsg('mfg0037',g_lang) RETURNING l_msg2
        LET l_msg = l_msg CLIPPED,l_msg1 CLIPPED,l_msg2
     END IF
     IF NOT cl_null(l_msg) THEN
        CALL cl_msgany(10,20,l_msg)
        LET g_success = 'N'
        RETURN
     END IF
  END IF
 
  #CHI-C10016 add -- start --
  IF g_prog[1,7] = "axmt620" THEN
     SELECT oga50,oga07 INTO l_oga50,l_oga07 FROM oga_file WHERE oga01 = p_oga01
     IF l_oga07 = 'Y' THEN
        SELECT SUM(ABS(npq07f)) INTO l_npq07f FROM npq_file
         WHERE npq01 = p_oga01
           AND npqsys= 'AR' AND npq011 = 1
           AND npqtype= '0'   
           AND npq00 = '1'
           AND (npq06 = '2' AND npq07f > 0 OR npq06 = '1' AND npq07f < 0 )
        IF cl_null(l_npq07f) THEN LET l_npq07f=0 END IF   
               
        IF l_npq07f !=(l_oga50) THEN
           CALL s_errmsg("npq07f",l_npq07f,"","axm1188",1)   #CHI-A90012 axm1113-->axm1188
           LET g_success = 'N'
        END IF
     END IF
  END IF
  #CHI-C10016 add -- end --
 
  IF s_industry('icd') THEN
     # 檢查單身的倉儲批組合不可為空白，沒有指定倉儲批，不可確認
     # 檢查有做刻號管理的料號，其idb與出貨量需match
     DECLARE t600_chk_icdout_s CURSOR FOR
       SELECT * FROM ogb_file WHERE ogb01 = p_oga01      #No.MOD-890023 add

     #FUN-B40081 --START--
     LET l_sql= " SELECT * FROM ogc_file WHERE ogc01='",p_oga01,"' AND ogc03=?" 
     PREPARE t600_icdchk_pre1 FROM l_sql
     DECLARE t600_icdchk_cs1 CURSOR FOR t600_icdchk_pre1 
     #FUN-B40081 --END--
     
     FOREACH t600_chk_icdout_s INTO l_ogb.*
        IF STATUS THEN
           CALL cl_err('t600_chk_icdout_s:',STATUS,0)
           LET g_success = 'N'
           RETURN
        END IF
        IF l_argv0 = '2' THEN
           CALL t600sub_ind_icd_chk_omb(l_ogb.ogb04,l_ogb.ogb31,l_ogb.ogb32)
           IF NOT cl_null(g_errno) THEN
              CALL cl_err('',g_errno,0)
              LET g_success = 'N'
              RETURN
           END IF
        END IF
 
        IF l_argv0 = '1' OR l_argv0 = '5' THEN   #FUN-D30085 add OR l_argv0 = '5'
           CONTINUE FOREACH
        END IF
 
        
        LET l_tmp = l_ogb.ogb09 CLIPPED,l_ogb.ogb091 CLIPPED,
                    l_ogb.ogb092 CLIPPED
       #IF cl_null(l_tmp) THEN                          #TQC-C60157 mark
        IF cl_null(l_tmp) AND l_ogb.ogb17 != 'Y' THEN   #TQC-C60157
           IF NOT(l_argv0 = '1' AND  #Add
              l_ogb.ogb04[1,4] = 'MISC') THEN
              CALL cl_getmsg('aic-304',g_lang) RETURNING g_msg1   #No.FUN-830078
              CALL cl_getmsg('aic-315',g_lang) RETURNING g_msg2   #No.FUN-830078
              LET g_msg3 = g_msg1 CLIPPED,' ',l_ogb.ogb03,' ',g_msg2 CLIPPED
              CALL cl_msgany(6,12,g_msg3)
              LET g_success = 'N'
              RETURN
           END IF
        ELSE
           #FUN-BA0051 --START mark--
           #LET l_imaicd04 = NULL  LET l_imaicd08 = NULL
           #SELECT imaicd04,imaicd08
           #  INTO l_imaicd04,l_imaicd08
           #  FROM imaicd_file
           # WHERE imaicd00 = l_ogb.ogb04
           #
           #IF l_imaicd08 = 'Y' THEN
           #FUN-BA0051 --END mark--
           IF s_icdbin(l_ogb.ogb04) THEN   #FUN-BA0051
              #FUN-B40081 --START--
              IF l_ogb.ogb17='Y' THEN   #多倉儲出貨應以多倉儲裡的資料確認
                 FOREACH t600_icdchk_cs1 USING l_ogb.ogb03 INTO l_ogc.*
                    IF STATUS THEN
                       CALL cl_err('t600_icdchk_cs1:',STATUS,0)
                       LET g_success = 'N'
                       RETURN
                    END IF
                
                    IF l_argv0 = '1' THEN   
                       CALL s_icdchk(2,l_ogc.ogc17,
                                        l_ogc.ogc09,
                                        l_ogc.ogc091,
                                        l_ogc.ogc092,
                                        l_ogc.ogc12,
                                        l_oga.oga01,l_ogc.ogc03,
                                        l_oga.oga02,g_plant)    
                            RETURNING l_flag
                    ELSE
                       CALL s_icdchk(-1,l_ogc.ogc17,
                                         l_ogc.ogc09,
                                         l_ogc.ogc091,
                                         l_ogc.ogc092,
                                         l_ogc.ogc12,
                                         l_oga.oga01,l_ogc.ogc03,
                                         l_oga.oga02,g_plant)              
                            RETURNING l_flag
                    END IF
                    IF l_flag = 0 THEN
                       CALL cl_err(l_ogb.ogb03,'aic-056',1) 
                       LET g_success = 'N'
                       RETURN
                    END IF
                 END FOREACH    
              ELSE 
              #FUN-B40081 --END--
                 IF l_argv0 = '1' THEN
                    CALL s_icdchk(2,l_ogb.ogb04,
                                     l_ogb.ogb09,
                                     l_ogb.ogb091,
                                     l_ogb.ogb092,
                                     l_ogb.ogb12,
                                     l_oga.oga01,l_ogb.ogb03,
                                     l_oga.oga02,'')  #FUN-B80119   傳入p_plant參數''   -
                         RETURNING l_flag
                 ELSE
                    CALL s_icdchk(-1,l_ogb.ogb04,
                                      l_ogb.ogb09,
                                      l_ogb.ogb091,
                                      l_ogb.ogb092,
                                      l_ogb.ogb12,
                                      l_oga.oga01,l_ogb.ogb03,
                                      l_oga.oga02,'')  #FUN-B80119   傳入p_plant參數''   -
                         RETURNING l_flag
                 END IF
                 IF l_flag = 0 THEN
                    CALL cl_err(l_ogb.ogb03,'aic-056',1)  #No.FUN-830078
                    LET g_success = 'N'
                    RETURN
                 END IF
              END IF #FUN-B40081   
           END IF
        END IF
     END FOREACH
  END IF
 
  #IF g_success = 'Y' THEN #MOD-C80069 mark
    #MOD-B70197 mark --start--
    #CALL t600sub_hu1(l_oga.*)   #信用查核
    #IF g_success = 'N' THEN
    #   LET g_success = 'N'   #FUN-580113
    #END IF
    #MOD-B70197 mark --end--
 
  #MOD-C80069 mark start -----
  #   IF g_success='Y' THEN
  #      UPDATE oga_file SET oga902 = ' ' WHERE oga01=l_oga.oga01
  #      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
  #         LET g_success = 'N'
  #      END IF
  #   ELSE
  #      UPDATE oga_file SET oga902 =g_oaz.oaz11 WHERE oga01=l_oga.oga01
  #      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
  #          LET g_success = 'N'
  #      END IF
  #   END IF
  #END IF
  #MOD-C80069 mark end   -----
 
   LET l_sql = " SELECT oga09,ogb12,ogb19,ogb11,ogb01,ogb03 FROM oga_file,ogb_file ",
               "  WHERE oga01 = ogb01 ",
               "    AND ogb01 = '",l_oga.oga01,"'"
   PREPARE t600sub_pre2  FROM l_sql
   DECLARE t600sub_curs2 CURSOR FOR t600sub_pre2
   FOREACH t600sub_curs2 INTO l_oga09,l_ogb12,l_ogb19,l_ogb11,l_qcs01,l_qcs02
     IF l_ogb19 = 'Y' AND l_oga09<>"1" THEN                                               #No.FUN-840164
       #-----CHI-880006---------
       #確認段不做OQC的判斷
       #LET l_qcs091c = 0
       #SELECT SUM(qcs091) INTO l_qcs091c
       #  FROM qcs_file
       # WHERE qcs01 = l_qcs01
       #   AND qcs02 = l_qcs02
       #   AND qcs14 = 'Y'
       #
       #IF l_qcs091c IS NULL THEN
       #   LET l_qcs091c =0
       #END IF
       #IF l_argv0<>"8" OR cl_null(l_argv0) THEN #CHI-690055                               
       #   IF l_ogb12 > l_qcs091c THEN
       #      IF g_bgjob='N' OR cl_null(g_bgjob) THEN  #FUN-840012                                                                           
       #         IF NOT cl_confirm('mfg3561') THEN   #CHI-830030 
       #            LET g_success = 'N'                
       #            RETURN                                                                                                                              
       #         END IF                              #CHI-830030 
       #      END IF
       #   END IF
       #END IF
       #------END CHI-880006-----
     END IF
   END FOREACH
 
  #以下的程式由upd()段移過來
      #IF g_prog <> 'atmt248' AND g_prog <> 'axmt628' THEN  #No.MOD-670123  #No.TQC-6C0085 add axmt628 #FUN-B40066 mark
      IF g_prog <> 'atmt248' AND g_prog[1,7] <> 'axmt628' THEN   #FUN-B40066
         DECLARE l_ogb_conf CURSOR FOR                #No.FUN-670008
         #SELECT ogb31,ogb32,ogb1010,ogb14,ogb14t     #No.FUN-670008
          SELECT ogb31,ogb32,ogb1010,ogb14,ogb14t,ogb1005 #TQC-B10066
            FROM ogb_file
           WHERE ogb01=l_oga.oga01
             AND ogb1005='2'
 
          FOREACH l_ogb_conf INTO l_ogb31,l_ogb32,l_ogb1010,l_ogb14,l_ogb14t,l_ogb1005  #No.FUN-670008 #TQC-B10066
             IF l_ogb1010 ='Y' THEN
                SELECT oeb14t INTO l_tqw08 FROM oeb_file
                 WHERE oeb01 =l_ogb31
                   AND oeb03 =l_ogb32
                SELECT SUM(ogb14t) INTO l_tqw081 FROM ogb_file,oga_file
                 WHERE ogb31 = l_ogb31
                   AND ogb32 = l_ogb32
                   AND oga01 = ogb01
                   AND ogapost = 'Y'
                   AND ogaconf !='X' #CHI-6B0036
                SELECT SUM(ohb14t) INTO l_retn_amt FROM ohb_file,oha_file
                 WHERE ohb33 =l_ogb31
                   AND ohb34 =l_ogb32
                   AND oha01 =ohb01
                   AND ohapost ='Y'
             ELSE
                SELECT oeb14 INTO l_tqw08 FROM oeb_file
                 WHERE oeb01 =l_ogb31
                   AND oeb03 =l_ogb32
                SELECT SUM(ogb14) INTO l_tqw081 FROM ogb_file,oga_file
                 WHERE ogb31 = l_ogb31
                   AND ogb32 = l_ogb32
                   AND oga01 = ogb01
                   AND ogapost = 'Y'
                   AND ogaconf !='X'  #CHI-6B0036
                SELECT SUM(ohb14) INTO l_retn_amt FROM ohb_file,oha_file
                 WHERE ohb33 =l_ogb31
                   AND ohb34 =l_ogb32
                   AND oha01 =ohb01
                   AND ohapost ='Y'
             END IF
             IF cl_null(l_tqw081) THEN
                LET l_tqw081 =0
             END IF
             IF cl_null(l_retn_amt) THEN
                LET l_retn_amt =0
             END IF
             LET l_tqw081 =l_tqw081-l_retn_amt
 
             LET l_max =l_tqw08 -l_tqw081
 
             IF l_ogb1010 ='Y' THEN
                IF l_max >= 0 THEN
                  #IF l_ogb14t >l_max OR l_ogb14t <= 0 THEN                       #TQC-B10066
                   IF l_ogb14t >l_max OR (l_ogb1005 = '1' AND l_ogb14t <= 0) THEN #TQC-B10066
                      LET l_msg =l_ogb32,l_ogb14t     #No.FUN-670008
                      CALL cl_err(l_msg,'atm-526',1)  #No.FUn-670008
                      LET g_success='N'
                      ROLLBACK WORK
                      RETURN
                   END IF
                ELSE
                  #IF l_ogb14t <l_max OR l_ogb14t <= 0 THEN                       #TQC-B10066
                   IF l_ogb14t <l_max OR (l_ogb1005 = '1' AND l_ogb14t <= 0) THEN #TQC-B10066
                      LET l_msg =l_ogb32,l_ogb14t     #No.FUN-670008
                      CALL cl_err(l_msg,'atm-527',1)  #No.FUN-670008
                      LET g_success='N'
                      ROLLBACK WORK
                      RETURN
                   END IF
                END IF
             ELSE
                IF l_max >= 0 THEN
                  #IF l_ogb14 >l_max OR l_ogb14 <= 0 THEN                       #TQC-B10066
                   IF l_ogb14 >l_max OR (l_ogb1005 = '1' AND l_ogb14 <= 0) THEN #TQC-B10066
                      LET l_msg =l_ogb32,l_ogb14     #No.FUN-670008
                      CALL cl_err(l_msg,'atm-526',1) #No.FUN-670008
                      LET g_success='N'
                      ROLLBACK WORK
                      RETURN
                   END IF
                ELSE
                  #IF l_ogb14 <l_max OR l_ogb14 <= 0 THEN                       #TQC-B10066
                   IF l_ogb14 <l_max OR (l_ogb1005 = '1' AND l_ogb14 <= 0) THEN #TQC-B10066
                      LET l_msg =l_ogb32,l_ogb14t     #No.FUN-670008
                      CALL cl_err(l_msg,'atm-527',1)  #No.FUN-670008
                      LET g_success='N'
                      ROLLBACK WORK
                      RETURN
                   END IF
                END IF
             END IF
          END FOREACH
      END IF   #No.MOD-670123

     #FUN-970017---add----str---
      IF g_action_choice <> 'efconfirm' THEN
        #IF l_argv0 = '2' AND l_oga.oga65='Y' AND g_success = 'Y' THEN           #FUN-C40072 mark
         IF l_argv0 MATCHES '[24]' AND l_oga.oga65='Y' AND g_success = 'Y' THEN  #FUN-C40072 add 4:三角貿易出貨單
            CALL t600sub_on_check(l_oga.*)
                 RETURNING l_oga.*  #FUN-730012 有部分的l_oga有異動,此處必須回傳
         END IF
      END IF
     #FUN-970017---add----end--- 

END FUNCTION
 
#{
#函數用途:檢查程序-若採訂單匯率立帳則幣別匯率相同才可併單
#參數:
#     p_ogb03:ogb03
#     l_oga:出貨單頭
#     p_ogb31:ogb31
#     p_fieldchk:欄位檢查時呼叫此函數傳TRUE,確認時呼叫此函數傳FALSE
#回傳值:TRUE-檢查無誤; FALSE- 檢查有誤
#注意:oga24的值可能被異動,呼叫此FUN後必須重抓
#}
FUNCTION t600sub_oea18_chk(p_ogb03,l_oga,p_ogb31,p_fieldchk)
   DEFINE p_ogb03   LIKE ogb_file.ogb03
   DEFINE l_oga     RECORD LIKE oga_file.* #FUN-730012
   DEFINE p_fieldchk LIKE type_file.num5   #FUN-730012
   DEFINE l_oea     RECORD LIKE oea_file.* #FUN-730012
   DEFINE p_ogb31   LIKE ogb_file.ogb31
   DEFINE l_oea18   LIKE oea_file.oea18,
          l_oea23   LIKE oea_file.oea23,
          l_oea24   LIKE oea_file.oea24,
          l_oea01   LIKE oea_file.oea01,
          o_oea18   LIKE oea_file.oea18,
          o_oea23   LIKE oea_file.oea23,
          o_oea24   LIKE oea_file.oea24,
          l_ogb03   LIKE ogb_file.ogb03,
          l_cnt     LIKE type_file.num5     #No.FUN-680137 SMALLINT
 
   IF p_fieldchk THEN
      SELECT * INTO l_oea.* FROM oea_file
       WHERE oea01=p_ogb31
      IF STATUS THEN
         CALL cl_err3("sel","oea_file",p_ogb31,"",SQLCA.sqlcode,"","sel oea",1)  #No.FUN-670008
         RETURN FALSE
      END IF
 
      IF l_oea.oea044 != l_oga.oga044 THEN
	#CALL cl_err('axm-916',STATUS,0) #MOD-C40017 mark
         CALL cl_err('','axm-916',0)     #MOD-C40017
         RETURN FALSE
      END IF
   END IF
 
   LET l_cnt=0
   IF cl_null(p_ogb03) THEN LET p_ogb03 =0 END IF
   DECLARE oea18_chk CURSOR FOR
       SELECT oea01,oea23,oea24,oea18 ,ogb03
         FROM oea_file,ogb_file
        WHERE oea01=ogb31
          AND ogb01=l_oga.oga01
   FOREACH oea18_chk INTO l_oea01,l_oea23,l_oea24,l_oea18,l_ogb03
        IF SQLCA.SQLCODE <> 0 THEN EXIT FOREACH END IF
        IF cl_null(l_oea18) THEN LET l_oea18='N' END IF
        IF p_ogb03 <> 0 AND l_ogb03=p_ogb03 THEN
           CONTINUE FOREACH
        END IF
        LET l_cnt = l_cnt+1
        IF l_cnt=1 THEN
           LET o_oea18=l_oea18
           LET o_oea23=l_oea23
           LET o_oea24=l_oea24
           IF l_oea18='Y' THEN
              LET l_oga.oga24 = l_oea24
              UPDATE oga_file
                 SET oga24 = l_oga.oga24
                WHERE oga01 = l_oga.oga01
              DISPLAY BY NAME l_oga.oga24
           END IF
        END IF
        IF l_oea18 <> o_oea18 OR
           (l_oea18='Y' AND (l_oea23 <> o_oea23 OR l_oea24 <>o_oea24)) THEN
            CALL cl_err(l_oea01,'axm-608',1)
            RETURN FALSE #FUN-730012
        END IF
   END FOREACH
   IF p_fieldchk THEN
      IF cl_null(l_oea.oea18) THEN LET l_oea.oea18='N' END IF
      #若是訂單匯率立帳, 則帶該訂單之匯率
      IF l_cnt=0 AND l_oea.oea18='Y' THEN
         LET l_oga.oga24 = l_oea.oea24
         UPDATE oga_file SET oga24 = l_oga.oga24
           WHERE oga01 = l_oga.oga01
         DISPLAY BY NAME l_oga.oga24
      END IF
      IF l_cnt > 0 AND (l_oea.oea18 <>l_oea18 OR
        (l_oea.oea18='Y' AND (l_oea23<> l_oea.oea23 OR
         l_oea24<> l_oea.oea24) )) THEN
         CALL cl_err('','axm-608',0)
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION
 
#{
#客戶信用查核
#l_oga:出貨單頭
#回傳值: 無
#}
FUNCTION t600sub_hu1(l_oga)		#客戶信用查核
   DEFINE l_oga     RECORD LIKE oga_file.*
   DEFINE l_oea908  LIKE oea_file.oea908     #信用放行有效日期
   DEFINE l_oga903  LIKE oga_file.oga903
   DEFINE l_azp03   LIKE azp_file.azp03
   DEFINE l_oga03   LIKE oga_file.oga03     #No.TQC-640123
   DEFINE l_poy04   LIKE poy_file.poy04     #FUN-670007
   DEFINE l_argv0   LIKE oga_file.oga09     #FUN-730012
   DEFINE l_sql     STRING
   DEFINE li_result LIKE type_file.num5
   DEFINE l_poz     RECORD LIKE poz_file.*
   DEFINE l_oea99   LIKE oea_file.oea99
   DEFINE l_flow    LIKE oea_file.oea904
   DEFINE p_dbs_tra LIKE azw_file.azw05    #FUN-980093 add
   DEFINE p_plant_new LIKE azp_file.azp01  #FUN-980093 add
#  DEFINE l_oia07   LIKE oia_file.oia07    #FUN-C50136
   CALL cl_msg("hu1!")
   IF l_oga.oga903= 'Y' THEN RETURN END IF    #該單據信用已放行
   LET l_argv0=l_oga.oga09  #FUN-730012
#  #FUN-C50136----add----str--
#  IF g_oaz.oaz96 = 'Y' THEN
#     CASE
#        WHEN l_argv0 MATCHES '[15]'
#              CALL s_ccc_oia07('C',l_oga.oga03) RETURNING l_oia07
#        WHEN l_argv0 MATCHES '[24]' 
#              CALL s_ccc_oia07('D',l_oga.oga03) RETURNING l_oia07
#        WHEN l_argv0 MATCHES '[8]'
#              CALL s_ccc_oia07('F',l_oga.oga03) RETURNING l_oia07
#     END CASE
#     IF l_oia07 = 0 THEN
#        IF g_act !='C' THEN
#            RETURN
#        END IF
#     END IF
#     IF l_oia07 = 1 THEN
#        IF g_act !='S' THEN
#            RETURN
#        END IF
#     END IF
#  END IF
#  #FUN-C50136----add----end--
   #-->若為出貨時判斷, 若出貨日期<=訂單之信用放行日(oea908)則不做信用查核
   IF l_argv0 MATCHES '[2468]' AND NOT cl_null(l_oga.oga16) THEN #No.7992  #No.FUN-630061
      LET l_oea908=''
      SELECT oea908 INTO l_oea908 FROM oea_file WHERE oea01=l_oga.oga16
      IF SQLCA.SQLCODE =0 AND l_oea908 IS NOT NULL AND
         l_oga.oga02 <= l_oea908 THEN
         RETURN
      END IF
   END IF
   #逆拋則要抓來源廠的客戶名稱(多角貿易) No.7992
   LET l_oga03 = l_oga.oga03     #No.TQC-640123
   IF l_oga.oga909 = 'Y' AND (l_oga.oga09 = '4' OR l_oga.oga09 = '5') THEN   #MOD-890252
      CALL t600sub_chkpoz(l_oga.*,NULL) RETURNING li_result,l_poz.*,l_oea99,l_flow  #FUN-730012  kim:因為進去t600sub_chkpoz後,ogb31會再抓一次(確認段不會沒有單身資料),所以p_ogb31傳任何值都可
      IF NOT li_result THEN LET g_success = 'N' RETURN END IF  #FUN-730012
     IF l_poz.poz00 = '1' THEN       #MOD-890252 add  
      IF l_poz.poz011 = '2' THEN
#poz05在3.5x版己經移到poy04處理---
         SELECT poy04 INTO l_poy04                  
           FROM poy_file
          WHERE poy01 = l_poz.poz01
            AND poy02 = '0'   #起始站
         SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01 = l_poy04
 
      LET g_plant_new = l_poy04
      LET p_plant_new = g_plant_new
      CALL s_gettrandbs()
      LET p_dbs_tra = g_dbs_tra
 
         LET l_azp03 = s_dbstring(l_azp03 CLIPPED)  
         #LET l_sql = " SELECT oea03 FROM ",p_dbs_tra,"oea_file ", #No.TQC-640123 #FUN-980093 add
         LET l_sql = " SELECT oea03 FROM ",cl_get_target_table(p_plant_new,'oea_file'), #FUN-A50102
                     "  WHERE oea99 = '",l_oea99,"'"      #MOD-6C0118
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql #MOD-980195   
         CALL cl_parse_qry_sql(l_sql,p_plant_new) RETURNING l_sql #FUN-980093
         PREPARE oea03_pre FROM l_sql #No.TQC-640123
         DECLARE oea03_cs CURSOR FOR oea03_pre
         OPEN oea03_cs
         IF STATUS THEN
            CALL cl_err('open oea03',STATUS,1)
            LET g_success = 'N'
         END IF
         FETCH oea03_cs INTO l_oga03   #No.TQC-640123
         IF STATUS THEN
            CALL cl_err('fetch oea03',STATUS,1)
            LET g_success = 'N'
         END IF
      END IF
    END IF   #MOD-890252 add
   END IF
   #no.6145(end)No.7992
   IF (l_argv0 MATCHES '[15]'  AND g_oaz.oaz132 MATCHES "[12]") OR    #No.7992
      (l_argv0 MATCHES '[246]' AND g_oaz.oaz142 MATCHES "[123]") THEN #No.7992 #No.FUN-630061
      LET g_errno = 'Y'
      IF l_oga.ogamksg = 'Y' THEN
         CALL s_ccc_logerr()  
      END IF
      IF l_oga.oga00 MATCHES '[13467]' THEN #出至境外也要作credit check   #CHI-9B0034
#        #FUN-C50136--add--str--
#        IF g_oaz.oaz96 = 'Y' THEN 
#           CASE
#              WHEN l_argv0 MATCHES '[15]'
#                    CALL s_ccc_oia(l_oga.oga03,'C',l_oga.oga01,0,'')
#              WHEN l_argv0 MATCHES '[24]'
#                    CALL s_ccc_oia(l_oga.oga03,'D',l_oga.oga01,0,'')
#           END CASE
#        ELSE
#           #FUN-C50136---add---end----
            IF l_oga.oga09 MATCHES '[15]' THEN                           #No.7992
               CALL s_ccc(l_oga03,'1',l_oga.oga01)  #No.TQC-640123
            ELSE
               # Customer Credit Check 客戶信核
               CALL s_ccc(l_oga03,'1','')           #No.TQC-640123       #No.7992  #No:MOD-8A0126 mark   #MOD-9B0195 取消mark
            END IF
#        END IF   #FUN-C50136
      END IF
      IF g_errno = 'N' THEN
        IF (l_argv0 MATCHES '[15]' AND g_oaz.oaz132 = "1") OR         #No.7992
           (l_argv0 MATCHES '[246]' AND g_oaz.oaz142 = "1")           #No.7992  #No.FUN-630061
           THEN CALL cl_err('ccc','axm-104',1)
                IF g_bgjob='N' OR cl_null(g_bgjob) THEN  #FUN-840012
                   IF NOT cl_confirm('axm-105') THEN LET g_success = 'N' RETURN
                   END IF
                END IF
           ELSE CALL cl_err('ccc','axm-106',0)
                LET g_success = 'N' RETURN
         END IF
      END IF
   END IF
#  #FUN-C50136----add----str----
#  IF l_argv0 = '8' THEN
#     IF g_oaz.oaz96 ='Y' THEN  
#        CALL s_ccc_oia(l_oga.oga03,'F',l_oga.oga01,0,'')
#     END IF
#  END IF
#  #FUN-C50136----add----end----
END FUNCTION
 
#{
#檢查多角流程代碼資料
#l_oga:出貨單頭
#p_ogb31:第一筆單身資料的訂單單號,當新增第一筆單身資料的時候會用到
#回傳值:
#       TRUE   - 程序正常無誤完成 ; FALSE  - 程序有錯誤
#       l_poz  : poz_file (供後續三角流程所使用)
#
#}
FUNCTION t600sub_chkpoz(l_oga,p_ogb31)
DEFINE l_oga    RECORD LIKE oga_file.*
DEFINE p_ogb31  LIKE ogb_file.ogb31  #FUN-730012
DEFINE l_oea01  LIKE oea_file.oea01
DEFINE l_oea99  LIKE oea_file.oea99  #MOD-6C0118
DEFINE l_sql   STRING  #NO.TQC-630166
DEFINE l_poz    RECORD LIKE poz_file.*  #FUN-730012
DEFINE l_oea904 LIKE oea_file.oea904    #FUN-730012
DEFINE l_cnt    LIKE type_file.num5
DEFINE l_argv0 LIKE ogb_file.ogb09
 
   LET l_argv0=l_oga.oga09  #FUN-730012
   IF cl_null(l_oga.oga16) THEN     #modi in 00/02/24 by kammy
      LET l_cnt=0
      SELECT COUNT(*) INTO l_cnt FROM ogb_file
       WHERE ogb01=l_oga.oga01
 
      #kim:當新增第一筆單身資料的時候會發生l_cnt=0的狀況,
      #AFTER FIELD ogb31和ogb16 會來呼叫此函數,
      #確認和過帳段因為會先檢查無單身資料不可確認,所以l_cnt=0的狀況不會發生在確認和過帳段
 
      IF l_cnt=0 THEN
         LET l_oea01 = p_ogb31
        #MOD-6C0118-begin-add
          SELECT oea99 INTO l_oea99 FROM oea_file  #TQC-730012 modify #MOD-850026 mark ogb_file
           WHERE oea01 = p_ogb31
        #MOD-6C0118-end-add
      ELSE
        #只讀取第一筆訂單之資料
        LET l_sql= " SELECT oea01,oea99 FROM oea_file,ogb_file ",  #MOD-6C0118 add oea99
                   "  WHERE oea01 = ogb31 ",
                   "    AND ogb01 = '",l_oga.oga01,"'",
                   "    AND oeaconf = 'Y' ",  #01/08/16 mandy
                   "  ORDER BY ogb03"  #No.MOD-570362
        PREPARE oea_pre FROM l_sql
        DECLARE oea_f CURSOR FOR oea_pre
        OPEN oea_f
        IF SQLCA.sqlcode THEN
           RETURN FALSE,l_poz.*,l_oea99,l_oea904
        END IF
        FETCH oea_f INTO l_oea01,l_oea99  #MOD-6C0118 add oea99
        IF SQLCA.sqlcode THEN
           RETURN FALSE,l_poz.*,l_oea99,l_oea904
        END IF
      END IF
   ELSE
      #讀取該出貨單之訂單
      SELECT oea01,oea99 INTO l_oea01,l_oea99  #MOD-6C0118 add oea99
        FROM oea_file
       WHERE oea01 = l_oga.oga16
         AND oeaconf = 'Y' #01/08/16 mandy
   END IF
   SELECT oea904 INTO l_oea904 FROM oea_file WHERE oea99 = l_oea99  #MOD-6C0118
   SELECT * INTO l_poz.* FROM poz_file WHERE poz01 = l_oea904
   IF STATUS THEN
      CALL cl_err('','axm-318',1)
      RETURN FALSE,l_poz.*,l_oea99,l_oea904
   END IF
   IF l_argv0 = '4' AND l_poz.poz00='2' THEN
      CALL cl_err(l_oea904,'tri-008',1)
      RETURN FALSE,l_poz.*,l_oea99,l_oea904
   END IF
   IF l_argv0 = '6' AND l_poz.poz00='1' THEN
      CALL cl_err(l_oea904,'tri-008',1)
      RETURN FALSE,l_poz.*,l_oea99,l_oea904
   END IF
   RETURN TRUE,l_poz.*,l_oea99,l_oea904   #NO.TQC-740089
END FUNCTION
 
###以上是確認前的檢查###
 
#{
#作用:lock cursor
#回傳值:無
#}
FUNCTION t600sub_lock_cl()
   LET g_forupd_sql = "SELECT * FROM oga_file WHERE oga01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t600sub_cl CURSOR FROM g_forupd_sql
END FUNCTION
 
#{
#函數作用:執行"確認"的資料更新
#函數參數:p_oga01-出貨單頭的單號
#         p_action_choice-執行"確認"的按鈕的名稱,若外部呼叫可傳NULL
#回傳值:無
#注意  :需用g_success='Y'來判斷此函數是否成功執行,g_success='N'來判斷執行失敗
#       做完確認,需重新讀取oga_file,本FUN不重新讀取
#}
FUNCTION t600sub_y_upd(p_oga01,p_action_choice)
   DEFINE p_oga01       LIKE oga_file.oga01
   DEFINE p_action_choice STRING
   DEFINE l_oea904      LIKE oea_file.oea904   #NO.FUN-670007
   DEFINE l_poz00       LIKE poz_file.poz00    #NO.FUN-6700007
   DEFINE l_chr         LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)  #NO.FUN-670007
   DEFINE l_oga     RECORD LIKE oga_file.*
   DEFINE l_argv0       LIKE ogb_file.ogb09
   DEFINE l_msg         LIKE type_file.chr1000
   DEFINE l_poz     RECORD LIKE poz_file.*
   DEFINE l_ogamksg     LIKE oga_file.ogamksg
   DEFINE l_oga55       LIKE oga_file.oga55
   DEFINE l_no1         LIKE ina_file.ina01
   DEFINE l_no2         LIKE ina_file.ina01
   DEFINE l_cnt         LIKE type_file.num5
   DEFINE l_ina01_out   LIKE ina_file.ina01     #雜發單號
   DEFINE l_ogb31       LIKE ogb_file.ogb31     #MOD-870278 add
   DEFINE l_t1          LIKE oay_file.oayslip   #FUN-970017 add
   DEFINE l_change_bgjob LIKE type_file.chr1    #FUN-970017 add 
   #2021113001 add----begin----
   DEFINE l_ret        RECORD
             success   LIKE type_file.chr1,
             code      LIKE type_file.chr10,
             msg       STRING
                       END RECORD
   #2021113001 add----end----
   
   WHENEVER ERROR CONTINUE                      #忽略一切錯誤  #FUN-730012
 
  #CHI-A50004 程式搬移 --start--
   BEGIN WORK
   CALL t600sub_lock_cl()
   OPEN t600sub_cl USING p_oga01
   IF STATUS THEN
      CALL cl_err("OPEN t600sub_cl:", STATUS, 1)
      CLOSE t600sub_cl
      LET g_success='N'
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t600sub_cl INTO l_oga.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(l_oga.oga01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE t600sub_cl
       LET g_success='N'
       ROLLBACK WORK
       RETURN
   END IF
  #CHI-A50004 程式搬移 --end--

  #FUN-970017---add----str----
   LET l_change_bgjob = 'N'
   IF p_action_choice CLIPPED = 'efconfirm' THEN  #由EasyFlow簽核,按下"准"
      LET l_t1=s_get_doc_no(p_oga01)
      SELECT * INTO g_oay.* FROM oay_file WHERE oayslip=l_t1
     #同時具有自動確認和簽核的功能時,運作應同背景模式,不能開啟交談視窗
      IF g_oay.oayconf = 'Y' AND g_oay.oayapr = 'Y' THEN
         IF cl_null(g_bgjob) AND g_bgjob = 'N' THEN
            LET l_change_bgjob = 'Y'
            LET g_bgjob = 'Y'
         END IF
      END IF
   END IF
  #FUN-970017---add----end----

   LET g_success = 'Y'
 
  #IF p_action_choice CLIPPED = "confirm" THEN   #按「確認」時 #FUN-970017 mark

#CHI-C30118---mark---START 移至y_chk最上方
###FUN-970017---add---str---
# IF p_action_choice CLIPPED = "confirm" OR
#    g_action_choice CLIPPED = "insert" OR
#    g_action_choice CLIPPED = "modify" THEN    #執行 "確認" 功能(非簽核模式呼叫)
##FUN-970017---add---end---
#    SELECT ogamksg,oga55 INTO l_ogamksg,l_oga55 FROM oga_file  #CHI-740016 #FUN-740034
#     WHERE oga01=p_oga01
#    IF l_ogamksg='Y'   THEN
#       IF l_oga55 != '1' THEN
#          CALL cl_err('','aws-078',1)
#          LET g_success = 'N'
#          ROLLBACK WORK #CHI-A50004 add  
#          RETURN
#       END IF
#    END IF
#
#    IF g_bgjob='N' OR cl_null(g_bgjob) THEN  #FUN-840012
#       IF NOT cl_confirm('axm-108') THEN
#          LET g_success='N'
#          ROLLBACK WORK #CHI-A50004 add
#          RETURN
#       END IF
#    END IF
# END IF
#CHI-C30118---mark---END
 
  #CHI-A50004 程式搬移至FUNCTION一開始 mark --start--
  #BEGIN WORK
  #CALL t600sub_lock_cl()
  #OPEN t600sub_cl USING p_oga01
  #IF STATUS THEN
  #   CALL cl_err("OPEN t600sub_cl:", STATUS, 1)
  #   CLOSE t600sub_cl
  #   LET g_success='N'
  #   ROLLBACK WORK
  #   RETURN
  #END IF
  # 
  #FETCH t600sub_cl INTO l_oga.*          # 鎖住將被更改或取消的資料
  #IF SQLCA.sqlcode THEN
  #    CALL cl_err(l_oga.oga01,SQLCA.sqlcode,0)     # 資料被他人LOCK
  #    CLOSE t600sub_cl
  #    LET g_success='N'
  #    ROLLBACK WORK
  #    RETURN
  #END IF
  #CHI-A50004 程式搬移至FUNCTION一開始 mark --end-- 
 
   LET l_argv0=l_oga.oga09  #FUN-730012
 #出貨單確認時再UPDATE oga011=本張出貨單號
  IF l_argv0 MATCHES '[246]' AND NOT cl_null(l_oga.oga011) THEN
     UPDATE oga_file SET oga011 = l_oga.oga01
      WHERE oga01 = l_oga.oga011
        AND oga09 IN ('1','5')
     IF STATUS OR SQLCA.SQLCODE THEN
        CALL cl_err('upd oga011:',SQLCA.SQLCODE,1)   #No.FUN-670092
        CALL cl_err3("upd","oga_file",l_oga.oga011,"",SQLCA.SQLCODE,"","upd oga011",1)  #No.FUN-670092
        LET g_success='N'
     END IF
  END IF
 
  #境外倉處理
  IF l_argv0='2' AND l_oga.oga00 MATCHES '[37]' THEN     #No.FUN-610064
     CALL t600sub_offshore(l_oga.*)
                         RETURNING l_oga.*  #FUN-730012 有部分的l_oga有異動,此處必須回傳
  END IF
  CALL s_get_bookno(YEAR(l_oga.oga02)) RETURNING g_flag,g_bookno1,g_bookno2
  IF g_flag =  '1' THEN  #抓不到帳別
     CALL cl_err(l_oga.oga02,'aoo-081',1)
  END IF
  #-->若須拋轉總帳, 檢查分錄底稿平衡正確否
  IF l_argv0 MATCHES '[2]' AND l_oga.oga07 = 'Y' THEN  #No.FUN-630061
     CALL s_chknpq(l_oga.oga01,'AR',1,'0',g_bookno1)  #No.FUN-730057
  END IF
  IF g_success = 'Y' THEN
     CALL t600sub_y1(l_oga.*)
     CALL t600sub_y2(l_oga.*)   #FUN-C10040 add
  END IF

 #FUN-970017 mark str---------------
 #IF l_argv0 = '2' AND l_oga.oga65='Y' AND g_success = 'Y' THEN
 #   CALL t600sub_on_check(l_oga.*)
 #        RETURNING l_oga.*               #FUN-730012 有部分的l_oga有異動,此處必須回傳
 #END IF
 #FUN-970017 mark end---------------

  IF g_success= 'Y' AND
    (NOT cl_null(p_action_choice)) THEN  #FUN-730012 外部呼叫時,不使用"確認後立即扣帳"功能
     IF l_argv0='2'  THEN  #No.FUN-630061
        IF g_oaz.oaz61 MATCHES "[12]"  THEN
           #MOD-CC0260 -- add start --
           LET l_cnt = 0
           SELECT count(*) INTO l_cnt FROM ogb_file
            WHERE ogb01 = l_oga.oga01
              AND ogb19 = 'Y'
           IF l_cnt > 0 THEN
              CALL cl_err('','axm0003',1)
           ELSE
           #MOD-CC0260 -- add end --
              CALL t600sub_refresh(l_oga.oga01) RETURNING l_oga.* #FUN-730012 add 因為前面有些oga_file的值有異動,必須重新更新比較保險
              IF g_bgjob='N' THEN #FUN-730012
                 CALL t600sub_s(g_oaz.oaz61,TRUE,p_oga01,TRUE)
              ELSE #FUN-730012
                 CALL t600sub_s(g_oaz.oaz61,TRUE,p_oga01,FALSE) #FUN-730012
              END IF
           END IF   #MOD-CC0260 add
        END IF
     END IF
     IF l_argv0 = '8' THEN  #No.FUN-630061
        CALL t600sub_refresh(l_oga.oga01) RETURNING l_oga.* #FUN-730012 add 因為前面有些oga_file的值有異動,必須重新更新比較保險
        IF g_bgjob='N' THEN #FUN-730012
          #CALL t600sub_s('1',TRUE,p_oga01,TRUE)  #FUN-C40072 mark
           CALL t600sub_s('1',FALSE,p_oga01,TRUE) #FUN-C40072 add p_inTransaction=FALSE要做COMMIT
        ELSE #FUN-730012
           CALL t600sub_s(g_oaz.oaz61,TRUE,p_oga01,FALSE) #FUN-730012
        END IF
     END IF
  END IF
  IF g_success = 'Y' THEN
     IF l_oga.ogamksg = 'Y' THEN #簽核模式
        CASE aws_efapp_formapproval()            #呼叫 EF 簽核功能
            WHEN 0  #呼叫 EasyFlow 簽核失敗
                 LET l_oga.ogaconf="N"
                 LET l_oga.ogaconu=''  #No.FUN-870007
                 LET l_oga.ogacond=''  #No.FUN-870007
                 LET l_oga.ogacont=''  #No.FUN-A30063 
                 LET g_success = "N"
                 ROLLBACK WORK
                 RETURN
            WHEN 2  #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
                 LET l_oga.ogaconf="N"
                 LET l_oga.ogaconu=''  #No.FUN-870007
                 LET l_oga.ogacond=''  #No.FUN-870007
                 LET l_oga.ogacont=''  #No.FUN-A30063
                 ROLLBACK WORK
                 RETURN
        END CASE
     END IF
  IF s_industry('icd') THEN
     #SELECT COUNT(*) INTO l_cnt FROM idb_file WHERE idb07 = p_oga01   #FUN-B40081 mark
     IF l_argv0 = '1' THEN   #FUN-B40081 mark AND l_cnt>0 
        CALL t600sub_ind_icd_post(l_oga.oga01,'1')
        IF g_success = 'N' THEN
           ROLLBACK WORK
           RETURN
        END IF
	# --- 變更出通單的倉庫為料號的主倉庫 ---
	# --- 變更出通單的idd_file的倉庫為料號的主倉庫 ---
	CALL t600sub_ind_icd_upd_ogb09(l_oga.oga01)
	IF g_success = 'N' THEN
	   ROLLBACK WORK
	   RETURN
	END IF
     END IF
  END IF
 
     LET l_oga.ogaconf='Y'           #執行成功, 確認碼顯示為 'Y' 已確認
     LET l_oga.oga55='1'             #執行成功, 狀態值顯示為 '1' 已核准
     UPDATE oga_file SET oga55 = l_oga.oga55 WHERE oga01=l_oga.oga01
     IF SQLCA.sqlerrd[3]=0 THEN
        LET g_success='N'
     END IF
     #MOD-B70197 add --start--
#    IF g_oaz.oaz96='Y' THEN LET g_act ='C' END IF    #FUN-C50136
     CALL t600sub_hu1(l_oga.*)   #信用查核
     IF g_success = 'N' THEN
        ROLLBACK WORK
        #RETURN #MOD-C80069 mark
     END IF
     #MOD-B70197 add --end--
 
     #MOD-C80069 add start -----
     IF g_success='Y' THEN
        UPDATE oga_file SET oga902 = ' ' WHERE oga01=l_oga.oga01
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
           LET g_success = 'N'
           ROLLBACK WORK   #TQC-D30038 add
        END IF
     ELSE
        UPDATE oga_file SET oga902 =g_oaz.oaz11 WHERE oga01=l_oga.oga01
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
            LET g_success = 'N'
        END IF
     END IF

     IF g_success = 'N' THEN
        RETURN
     END IF
     #MOD-C80069 add end   -----

     CALL t600sub_chstatus('Y',l_oga.*) RETURNING l_oga.*
     COMMIT WORK
     CALL cl_flow_notify(l_oga.oga01,'Y')
     #2021113001 add----begin----
     IF l_argv0 MATCHES '[15]' AND cl_getscmparameter() THEN
       INITIALIZE l_ret TO NULL
       CALL cjc_zmx_json_task('DO2',l_oga.oga01) RETURNING l_ret.*
       IF l_ret.success = 'Y' THEN

       ELSE
         IF cl_null(l_ret.msg) THEN
           LET l_ret.msg = "出货(通知)单(",l_oga.oga01 CLIPPED,")同步失败"
         END IF
         CALL cl_err(l_ret.msg,'!',1)
       END IF
     END IF
     #2021113001 add----end----
  ELSE
     LET l_oga.ogaconf='N'
     ROLLBACK WORK
  END IF
#------#MOD-CA0131 add begin
  #因為t600sub_gui中有cl_cmdrun_wait,不能包含在事物中
  IF g_inTransaction = 'Y' THEN
  	 CALL t600sub_refresh(l_oga.oga01) RETURNING l_oga.*
   	 CALL t600sub_gui(l_oga.*)
  END IF
#------#MOD-CA0131 add end  
  IF l_argv0 MATCHES '[246]' AND NOT cl_null(l_oga.oga011) THEN
     LET l_oga.oga011= l_oga.oga01  #FUN-730012 add
  END IF
 
#確認成功後，來源如為三角出通單，即自動拋轉出通單
  IF l_argv0 = '5' THEN
      #讀取三角貿易流程代碼資料
      IF NOT cl_null(l_oga.oga16) THEN  #MOD-870278 add
        SELECT oea904 INTO l_oea904
          FROM oea_file
         WHERE oea01 = l_oga.oga16
       ELSE 
        DECLARE t600_g_ogb1 CURSOR FOR SELECT ogb31 FROM ogb_file
                                  WHERE ogb01 = g_oga.oga01
 
        FOREACH t600_g_ogb1 INTO  l_ogb31
           SELECT oea904 INTO l_oea904 
             FROM oea_file
            WHERE oea01 = l_ogb31
             EXIT FOREACH
        END FOREACH
      END IF
        IF NOT cl_null(l_oea904) THEN
            SELECT * INTO l_poz.* FROM poz_file WHERE poz01 = l_oea904
            IF STATUS THEN
                CALL cl_err('','axm-318',1) RETURN
            END IF
            SELECT poz00 INTO l_poz00   #先得到流程為銷售或代採參數
              FROM poz_file
             WHERE poz01=l_oea904
            IF l_poz00 = '1' THEN
                LET l_chr = '4'   #銷售
            ELSE
                LET l_chr = '6'   #代採
            END IF
        END IF
  END IF

 #FUN-970017--add----str---
  IF l_change_bgjob = 'Y' THEN
      LET g_bgjob = 'N'
  END IF
 #FUN-970017--add----end---

END FUNCTION


#FUN-C10040------add------str-----
FUNCTION t600sub_y2(l_oga)
DEFINE l_sql              STRING
DEFINE l_oga              RECORD LIKE oga_file.*
DEFINE l_ogi04            LIKE ogi_file.ogi04
DEFINE l_ogi05            LIKE ogi_file.ogi05
DEFINE l_ogi06            LIKE ogi_file.ogi06
DEFINE l_ogi07            LIKE ogi_file.ogi07
DEFINE l_ogi08            LIKE ogi_file.ogi08
DEFINE l_ogi08t           LIKE ogi_file.ogi08t
DEFINE l_ogi09            LIKE ogi_file.ogi09
DEFINE l_cnt              LIKE type_file.num5
DEFINE l_rxy05_other      LIKE rxy_file.rxy05
DEFINE l_rxy05_other_a    LIKE rxy_file.rxy05
DEFINE l_rxy05_other_b    LIKE ogh_file.ogh09
DEFINE l_rxy05_1          LIKE rxy_file.rxy05
DEFINE l_rxy05_2          LIKE rxy_file.rxy05
DEFINE l_rxy05_09         LIKE rxy_file.rxy05
DEFINE l_ogi08t_t         LIKE ogi_file.ogi08
DEFINE l_rxy12            LIKE rxy_file.rxy12
DEFINE l_rxy05_04_1       LIKE rxy_file.rxy16
DEFINE l_rxy05_04         LIKE rxy_file.rxy16
DEFINE l_gec04            LIKE gec_file.gec04
DEFINE l_gec07            LIKE gec_file.gec07
DEFINE l_ogh              RECORD LIKE ogh_file.*
DEFINE l_ogh07t           LIKE ogh_file.ogh07t    #FUN-C50047 add

   IF g_azw.azw04 = '2' THEN
      SELECT rxy05 INTO l_rxy05_09    #积分抵现金额
        FROM rxy_file 
       WHERE rxy00 = '02'
         AND rxy01 = l_oga.oga01
         AND rxy03 = '09'
      IF cl_null(l_rxy05_09) THEN
         LET l_rxy05_09 = 0
      END IF
      LET l_sql = "     SELECT rxy12,(lrz02 * rxy16),gec04,gec07 FROM rxy_file",#已開發票的禮券付款
                  " INNER JOIN lrz_file",
                  "         ON lrz01 = rxy13", 
                  "        AND lrz03 = 'Y'",
                  " INNER JOIN lpx_file",
                  "         ON lpx01 = rxy12",
                  #"        AND lpx26 = '1'",    #FUN-D10040 mark
                  "        AND lpx38 = 'Y'",     #FUN-D10040 add
                  " INNER JOIN gec_file",
                  "         ON gec01 = lpx33",
                  "        AND gec011 = '2'",
                  "      WHERE rxy00 = '02'",
                  "        AND rxy01 = '",l_oga.oga01,"'",
                  "        AND rxy03 = '04'"
      PREPARE t620_sel_rxy FROM l_sql
      DECLARE t620_sel_rxy_cs CURSOR FOR t620_sel_rxy
      FOREACH t620_sel_rxy_cs INTO l_rxy12,l_rxy05_04_1,l_gec04,l_gec07
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF
         IF cl_null(l_rxy05_04_1) THEN
            LET l_rxy05_04_1 = 0
         END IF
         LET l_rxy05_04 = l_rxy05_04 + l_rxy05_04_1
      END FOREACH
      SELECT SUM(rxy05) INTO l_rxy05_1     #其余付款金额
        FROM rxy_file
       WHERE rxy00 = '02'
         AND rxy01 = l_oga.oga01
         AND rxy03 NOT IN ('04','09')
          SELECT SUM(lrz02 * rxy16) INTO l_rxy05_2
            FROM rxy_file
      INNER JOIN lrz_file
              ON lrz01 = rxy13
             AND lrz03 = 'Y'
      INNER JOIN lpx_file
              ON lpx01 = rxy12
             #AND lpx26 = '2'  #FUN-D10040 mark
             AND lpx38 = 'N'   #FUN-D10040 add
           WHERE rxy00 = '02'
             AND rxy01 = l_oga.oga01
             AND rxy03 = '04'
      IF cl_null(l_rxy05_1) THEN 
         LET l_rxy05_1 = 0
      END IF
      IF cl_null(l_rxy05_2) THEN
         LET l_rxy05_2 = 0
      END IF
      LET l_rxy05_other = l_rxy05_1 + l_rxy05_2
      IF cl_null(l_rxy05_other) THEN
         LET l_rxy05_other = 0
      END IF 
      SELECT COUNT(*) INTO l_cnt
        FROM ogh_file
       WHERE ogh01 = l_oga.oga01
      IF l_cnt > 0 THEN
         DELETE FROM ogh_file WHERE ogh01 = l_oga.oga01
      END IF
      LET l_ogh.ogh01 = l_oga.oga01
      LET l_ogh.ogh09 = ' '
      LET l_ogh.oghdate = g_today
      LET l_ogh.oghgrup = g_grup
      LET l_ogh.oghlegal = g_legal
      LET l_ogh.oghmodu = ' '
      LET l_ogh.oghorig = g_grup
      LET l_ogh.oghplant = g_plant
      LET l_ogh.oghuser = g_user
      LET l_sql = " SELECT ogi04,ogi05,ogi06,ogi07,SUM(ogi08),SUM(ogi08t),SUM(ogi09)",
                  "   FROM ogi_file",
                  "  WHERE ogi01 = '",l_oga.oga01,"'",
                  "    AND ogiplant = '",l_oga.ogaplant,"'",
                  "  GROUP BY ogi04,ogi05,ogi06,ogi07",
                  "  ORDER BY ogi05 asc,ogi06 desc"   
      PREPARE t620_sel_ogi FROM l_sql 
      DECLARE t620_sel_ogi_cs CURSOR FOR t620_sel_ogi
      FOREACH t620_sel_ogi_cs INTO l_ogi04,l_ogi05,l_ogi06,l_ogi07,l_ogi08,l_ogi08t,l_ogi09
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF
         #固定税额大于零则直接写入到实际交易税别明细档 
         IF l_ogi06 >0 THEN
            SELECT MAX(ogh02) + 1 INTO l_ogh.ogh02
              FROM ogh_file
             WHERE ogh01 = l_oga.oga01
            IF cl_null(l_ogh.ogh02) THEN
               LET l_ogh.ogh02 = 1
            END IF 
            LET l_ogh.ogh03 = l_ogi04
            LET l_ogh.ogh04 = l_ogi05
            LET l_ogh.ogh05 = l_ogi06
            LET l_ogh.ogh06 = l_ogi07
            LET l_ogh.ogh07 = 0
            LET l_ogh.ogh07t= 0 
            LET l_ogh.ogh08 = l_ogi09
           #TQC-C30085 add START
            IF cl_null(l_ogh.ogh09) THEN
               LET l_ogh.ogh09 = 0 
            END IF
           #TQC-C30085 add END
            INSERT INTO ogh_file VALUES(l_ogh.*)
            IF SQLCA.SQLCODE THEN
               CALL cl_err3("ins","ogh_file",l_oga.oga01,"",SQLCA.SQLCODE,"","",1)
               LET g_success = 'N'
               EXIT FOREACH
            END IF
         END IF
         #用其他款别付款(现金）
         IF l_rxy05_other > 0 THEN
            IF l_ogi06 > 0 THEN   #先扣除固定税额大于零的税额
               IF l_rxy05_other < l_ogi09 THEN
                  LET l_rxy05_other_a = 0          
               ELSE
                  LET l_rxy05_other_a = l_rxy05_other - l_ogi09     #剩余金额
               END IF
            END IF
         END IF
         IF l_rxy05_other > 0 AND cl_null(l_rxy05_other_a) THEN
            LET l_rxy05_other_a = l_rxy05_other                  #固定税额都为0
         END IF
         IF l_rxy05_other = 0 AND cl_null(l_rxy05_other_a) THEN
            LET l_rxy05_other_a = 0
         END IF
        #FUN-C50047 add START
         IF l_rxy05_other_a = 0 THEN
            LET l_ogh07t = 0 
         ELSE
            LET l_ogh07t = l_ogi08t
         END IF
        #FUN-C50047 add END
         IF l_rxy05_other_a > 0 THEN
            IF l_ogi05 = 0  AND l_ogi06 = 0 THEN                    #扣除税率为零，固定税额为零的金额
               IF l_rxy05_other_a < l_ogi08t THEN
                  LET l_rxy05_other_a = 0
                  LET l_ogh07t = l_rxy05_other_a                    #FUN-C50047 add   
               ELSE
                  LET l_rxy05_other_a = l_rxy05_other_a - l_ogi08t  #剩余金额
                  LET l_ogh07t = l_ogi08t                           #FUN-C50047 add  
                  LET l_rxy05_other_b = 0
               END IF
            END IF
            IF l_ogi05 > 0 THEN
              #FUN-C50047 add START
               IF l_ogi08t <  l_rxy05_other_a THEN       
                  LET l_rxy05_other_a = l_rxy05_other_a - l_ogi08t 
                  LET l_ogh07t = l_ogi08t 
               ELSE 
                  LET l_ogi08t = l_ogi08t - l_rxy05_other_a 
                  LET l_ogh07t = l_rxy05_other_a   
                  LET l_rxy05_other_a = 0
               END IF
              #FUN-C50047 add END
              #LET l_ogi08t = l_rxy05_other_a            #FUN-C50047 mark
               LET l_ogi08 = l_rxy05_other_a/(1+l_ogi05/100)
               CALL cl_digcut(l_ogi08,t_azi04) RETURNING l_ogi08
               LET l_ogi09 = l_rxy05_other_a - l_rxy05_other_a/(1+l_ogi05/100)
               CALL cl_digcut(l_ogi09,t_azi04) RETURNING l_ogi09
            END IF
         END IF
         IF l_rxy05_other_a = 0 THEN                               #计算留抵金额
            IF l_rxy05_09 > 0 THEN
               IF l_ogi08t > l_rxy05_09 THEN
                  LET l_rxy05_other_b =  l_ogi08t - l_rxy05_09 
               ELSE
                  LET l_rxy05_other_b = 0
               END IF
            END IF
            IF l_rxy05_04 > 0 THEN
               IF l_rxy05_other_b > l_rxy05_04 THEN
                  LET l_rxy05_other_b = l_rxy05_04
                  LET l_ogh.ogh09 = l_rxy05_other_b - l_rxy05_other_b/(1+l_ogi05/100)
                  CALL cl_digcut(l_ogh.ogh09,t_azi04) RETURNING l_ogh.ogh09
               ELSE
                  LET l_rxy05_other_b = l_rxy05_04 - l_rxy05_other_b  
                  LET l_ogh.ogh09 = l_rxy05_other_b - l_rxy05_other_b/(1+l_ogi05/100)
                  CALL cl_digcut(l_ogh.ogh09,t_azi04) RETURNING l_ogh.ogh09
               END IF
            END IF
         END IF
         IF l_rxy05_09 = 0 AND l_rxy05_other = 0 AND l_rxy05_04 <> 0 THEN
            LET l_rxy05_other_b = l_rxy05_04 - l_ogi08t
            LET l_ogh.ogh09 = l_rxy05_other_b - l_rxy05_other_b/(1+l_ogi05/100)
            CALL cl_digcut(l_ogh.ogh09,t_azi04) RETURNING l_ogh.ogh09
         END IF
        #FUN-C50047 add START
         IF l_ogi06 = 0 THEN 
            SELECT MAX(ogh02) + 1 INTO l_ogh.ogh02
              FROM ogh_file
             WHERE ogh01 = l_oga.oga01
            IF cl_null(l_ogh.ogh02) THEN
               LET l_ogh.ogh02 = 1
            END IF
            LET l_ogh.ogh03 = l_ogi04
            LET l_ogh.ogh04 = l_ogi05
            LET l_ogh.ogh05 = l_ogi06
            LET l_ogh.ogh06 = l_ogi07
            LET l_ogh.ogh07 = l_ogh07t / (1+ l_ogh.ogh04/100)  
            CALL cl_digcut(l_ogh.ogh07,t_azi04) RETURNING l_ogh.ogh07
            LET l_ogh.ogh07t= l_ogh07t  
            LET l_ogh.ogh08 = l_ogh.ogh07t - l_ogh.ogh07 
            IF cl_null(l_ogh.ogh09) THEN
               LET l_ogh.ogh09 = 0
            END IF
            INSERT INTO ogh_file VALUES(l_ogh.*)
            IF SQLCA.SQLCODE THEN
               CALL cl_err3("ins","ogh_file",l_oga.oga01,"",SQLCA.SQLCODE,"","",1)
               LET g_success = 'N'
               RETURN
            END IF         
         END IF
        #FUN-C50047 add END 
      END FOREACH
     #FUN-C50047 mark START
     #IF l_rxy05_other_a > 0 THEN   #有剩余金额的则写入到实际交易税别明细档
     #   SELECT MAX(ogh02) + 1 INTO l_ogh.ogh02
     #     FROM ogh_file
     #    WHERE ogh01 = l_oga.oga01
     #   IF cl_null(l_ogh.ogh02) THEN
     #      LET l_ogh.ogh02 = 1
     #   END IF
     #   LET l_ogh.ogh03 = l_ogi04
     #   LET l_ogh.ogh04 = l_ogi05
     #   LET l_ogh.ogh05 = l_ogi06
     #   LET l_ogh.ogh06 = l_ogi07
     #   LET l_ogh.ogh07 = l_ogi08
     #   LET l_ogh.ogh07t= l_ogi08t
     #   LET l_ogh.ogh08 = l_ogi09
     #  #TQC-C30085 add START
     #   IF cl_null(l_ogh.ogh09) THEN
     #      LET l_ogh.ogh09 = 0
     #   END IF
     #  #TQC-C30085 add END
     #   INSERT INTO ogh_file VALUES(l_ogh.*)
     #   IF SQLCA.SQLCODE THEN
     #      CALL cl_err3("ins","ogh_file",l_oga.oga01,"",SQLCA.SQLCODE,"","",1)
     #      LET g_success = 'N'
     #      RETURN
     #   END IF
     #END IF
     #IF l_rxy05_other_b > 0 OR (l_rxy05_09 <> 0 AND l_rxy05_other = 0 AND l_rxy05_04 = 0) THEN   #没有剩余金额的则计算留抵金额
     #   SELECT MAX(ogh02) + 1 INTO l_ogh.ogh02
     #     FROM ogh_file
     #    WHERE ogh01 = l_oga.oga01
     #   IF cl_null(l_ogh.ogh02) THEN
     #      LET l_ogh.ogh02 = 1
     #   END IF
     #   LET l_ogh.ogh03 = l_ogi04
     #   LET l_ogh.ogh04 = l_ogi05
     #   LET l_ogh.ogh05 = l_ogi06
     #   LET l_ogh.ogh06 = l_ogi07
     #   LET l_ogh.ogh07 = 0
     #   LET l_ogh.ogh07t= 0
     #   LET l_ogh.ogh08 = 0
     #  #TQC-C30085 add START
     #   IF cl_null(l_ogh.ogh09) THEN
     #      LET l_ogh.ogh09 = 0
     #   END IF
     #  #TQC-C30085 add END
     #   INSERT INTO ogh_file VALUES(l_ogh.*)
     #   IF SQLCA.SQLCODE THEN
     #      CALL cl_err3("ins","ogh_file",l_oga.oga01,"",SQLCA.SQLCODE,"","",1)
     #      LET g_success = 'N'
     #      RETURN
     #   END IF
     #END IF
     #FUN-C50047 mark END
   END IF
END FUNCTION
#FUN-C10040------add------end-----
 
FUNCTION t600sub_offshore(l_oga)
 DEFINE l_n    LIKE type_file.num5    #No.FUN-680137 SMALLINT
 DEFINE li_result   LIKE type_file.num5             #No.FUN-550052  #No.FUN-680137 SMALLINT
 DEFINE p_row,p_col LIKE type_file.num5
 DEFINE l_oga RECORD LIKE oga_file.*
 DEFINE tm     RECORD
               cware     LIKE img_file.img02, #MOD-5B0276
               cloc      LIKE img_file.img03, #MOD-5B0276
               a         LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
               oea01     LIKE oay_file.oayslip,  #No.FUN-680137 VARCHAR(5)  #No.FUN-580133
               oea02     LIKE oea_file.oea02,
               oeb15     LIKE oeb_file.oeb15
               END RECORD
 DEFINE l_t1 LIKE oay_file.oayslip
 DEFINE l_img26 LIKE img_file.img26   #MOD-9B0183
 DEFINE l_imd10 LIKE imd_file.imd10   #MOD-B80265 add
 
   LET tm.cware=l_oga.oga910
   LET tm.cloc =l_oga.oga911
   LET tm.a    = 'N'          #no.7175
   LET tm.oea02= null         #no.7175
   LET tm.oeb15= null         #no.7175
 
   LET p_row = 2 LET p_col = 39
 
   OPEN WINDOW t600a_w AT p_row,p_col WITH FORM "axm/42f/axmt600a"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("axmt600a")
 
   #當出貨類別=7,抓取寄銷倉庫設定,為default境外倉
  # IF l_oga.oga00 = "7" THEN                           #TQC-AB0375  mark
    IF l_oga.oga00 = "7" THEN                           #TQC-AC0184 add 
      SELECT tuo04,tuo05 INTO tm.cware,tm.cloc FROM tuo_file
       WHERE tuo01 = l_oga.oga03 AND tuo02 = l_oga.oga04
      #當出貨類別=7,若沒帶出預設倉庫/儲位,提示需到寄銷客戶對應倉庫維護(axmi226)
      IF cl_null(tm.cware) AND cl_null(tm.cloc) THEN
            CALL cl_err(l_oga.oga03,'axm-530',1)
            LET g_success = 'N'
  #         CLOSE WINDOW t600a_w                          #TQC-AB0375  mark
  #         RETURN l_oga.*                                #TQC-AB0375  mark
            CLOSE WINDOW t600a_w                          #TQC-AC0184  add 
            RETURN l_oga.*                                #TQC-AC0184  add 
      ELSE
         DISPLAY BY NAME tm.cware,tm.cloc
         DISPLAY BY NAME tm.a                            #TQC-AB0375  
  #TQC-AB0375 ----------------------mark----------------------------------
  #       IF cl_sure(21,21) THEN
  #          CLOSE WINDOW t600a_w
  #       ELSE
  #          LET g_success = 'N'
  #          CLOSE WINDOW t600a_w
  #          RETURN l_oga.*
  #       END IF
  #TQC-AB0375 ----------------------mark----------------------------------
      END IF 
  END IF #TAC-AC0184 add
  # ELSE                                                 #TQC-AB0375 mark
   INPUT BY NAME tm.cware,tm.cloc,tm.a,tm.oea01,tm.oea02,tm.oeb15  #no.7175 add
                 WITHOUT DEFAULTS
#TQC-AB0375 ------------------STA
      BEFORE INPUT
          IF l_oga.oga00 = "7" THEN
              CALL cl_set_comp_entry("a,oea01,oea02,oeb15",FALSE)
          END IF
#TQC-AB0375 ------------------END
             
 
      AFTER FIELD cware
         IF NOT cl_null(tm.cware) THEN  #No:8570 genero,per檔加not required
#           SELECT * FROM imd_file                    #MOD-B80265 mark
            SELECT imd10 INTO l_imd10 from imd_file   #MOD-B82065
             WHERE imd01 = tm.cware
               AND imdacti = 'Y' #MOD-4B0169
            IF STATUS <> 0 THEN
               CALL cl_err3("sel","imd_file",tm.cware,"","ams-004","","",1)  #No.FUN-670008
               NEXT FIELD cware
            END IF
 
            SELECT COUNT(*) INTO l_n FROM ogb_file
             WHERE ogb01 = l_oga.oga01
               AND ogb09 = tm.cware
            IF l_n > 0 THEN
               CALL cl_err('','axm-100',0)
               LET tm.cware=' '
               NEXT FIELD cware #No:8570
            END IF

#MOD-B80265 -- begin --
            IF NOT (l_imd10 MATCHES '[Ww]') THEN
               CALL cl_err(g_oaz.oaz74,'axm-666',0)
               NEXT FIELD cware
            END IF
#MOD-B80265 -- end --

#CHI-B60085 -- begin --
#           IF g_azw.azw04='2' THEN
#              LET l_n=0
#              SELECT COUNT(*) INTO l_n  FROM jce_file                                                                      
#               WHERE jce02=tm.cware                                                                                 
#              IF l_n !=0 THEN                                                                                              
#                 CALL cl_err(tm.cware,'art-452',0)                                                                             
#                 NEXT FIELD cware                                                                                             
#              END IF                                                                                                         
               #No.FUN-AA0048  --Begin
               #LET l_n =0                                                                                                  
               #SELECT COUNT(*) INTO l_n FROM imd_file                                                                           
               # WHERE imd01=tm.cware                                                                                       
               #   AND imd20=g_plant                                                                                      
               #IF l_n=0 THEN                                                                                                   
               #   CALL cl_err(tm.cware,'art-487',0)                                                                             
               #   NEXT FIELD cware                                                                                            
               #END IF                                                                                                         
               #No.FUN-AA0048  --End  
#           END IF
#CHI-B60085 -- end --
            #No.FUN-AA0048  --Begin
            IF NOT s_chk_ware(tm.cware) THEN
               NEXT FIELD cware
            END IF
            #No.FUN-AA0048  --End  
#CHI-B60085 -- begin --
            CALL t600sub_chk_jce(l_oga.oga01,0,tm.cware)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD cware
            END IF
#CHI-B60085 -- end --
         END IF
#FUN-D40103 -------Begin--------
         IF NOT s_imechk(tm.cware,tm.cloc) THEN
            NEXT FIELD cloc
         END IF
 #FUN-D40103 -------End---------- 

      AFTER FIELD cloc
         IF cl_null(tm.cloc) THEN   #FUN-630102 modify
            LET tm.cloc = ' '
         END IF
 
           #-----MOD-B40260---------
           #start FUN-630102 mark
           SELECT * FROM ime_file
            WHERE ime01 = tm.cware
              AND ime02 = tm.cloc
           #   AND ime04 = 'S'
           IF STATUS <> 0 THEN
              CALL cl_err('','mfg0095',0)
              NEXT FIELD cware
           END IF
           #end FUN-630102 mark
           #-----END MOD-B40260-----
 
         SELECT COUNT(*) INTO l_n FROM ogb_file
          WHERE ogb01  = l_oga.oga01
            AND ogb09 = tm.cware
            AND ogb091 = tm.cloc
         IF l_n > 0 THEN
            CALL cl_err('','axm-100',0)
            LET tm.cloc=' '
            NEXT FIELD cware
         END IF
    #FUN-D40103 -------Begin--------
         IF NOT s_imechk(tm.cware,tm.cloc) THEN
            NEXT FIELD cloc
         END IF
      #FUN-D40103 -------End----------

 
      ON CHANGE a
         IF tm.a = "Y" THEN
            CALL cl_set_comp_required("oea01,oea02,oeb15",TRUE)      
         ELSE
            CALL cl_set_comp_required("oea01,oea02,oeb15",FALSE)
         END IF
 
      AFTER FIELD a
         IF tm.a NOT MATCHES '[YN]' THEN
            NEXT FIELD a
         END IF
 
      BEFORE FIELD oea01
         IF tm.a = 'N' THEN
         ELSE
            LET tm.oea02= g_today
            LET tm.oeb15= g_today
            DISPLAY BY NAME tm.oea02
            DISPLAY BY NAME tm.oeb15
         END IF
 
      AFTER FIELD oea01
         IF NOT cl_null(tm.oea01) THEN
            CALL s_check_no("axm",tm.oea01,"","34","oea_file","oea01","")
                 RETURNING li_result,tm.oea01
            IF (NOT li_result) THEN
               NEXT FIELD oea01
            END IF
         END IF
 
      AFTER INPUT
         IF INT_FLAG THEN EXIT INPUT END IF
 #FUN-D40103 ------Begin-------
        #  #-----MOD-B40260---------
        #  IF cl_null(tm.cloc) THEN LET tm.cloc = ' ' END IF
        #  #start FUN-630102 mark
        #  SELECT * FROM ime_file
        #   WHERE ime01=tm.cware AND ime02=tm.cloc #AND ime04='S'
        #  IF STATUS <> 0 THEN
        #     CALL cl_err('','mfg0095',0)
        #     LET tm.cloc=' '
        #     NEXT FIELD cloc
        #  END IF
        #  #end FUN-630102 mark
        #  #-----END MOD-B40260-----
  #FUN-D40103 ------End---------
           #FUN-D40103 -------Begin--------
           IF NOT s_imechk(tm.cware,tm.cloc) THEN
              LET tm.cloc=' '
              NEXT FIELD cloc
           END IF
           #FUN-D40103 -------End----------

         SELECT COUNT(*) INTO l_n FROM ogb_file
          WHERE ogb01 = l_oga.oga01 AND ogb09 = tm.cware
         IF l_n > 0 THEN
            CALL cl_err('','axm-100',0)
            LET tm.cloc=' '
            NEXT FIELD cware
         END IF
         CALL s_locchk('',tm.cware,tm.cloc) RETURNING li_result,l_img26
         IF li_result = 0 THEN 
            NEXT FIELD cware
         END IF
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(cware)
                 #No.FUN-AA0048  --Begin
                 #CALL cl_init_qry_var()
                 #LET g_qryparam.form ="q_imd"
                 #LET g_qryparam.arg1     = 'S'        #倉庫類別 #MOD-4A0213
                 #LET g_qryparam.default1 = tm.cware
                 #CALL cl_create_qry() RETURNING tm.cware
#                CALL q_imd_1(FALSE,TRUE,tm.cware,'S',"","","") RETURNING tm.cware   #MOD-B80197 mark
                 CALL q_imd_1(FALSE,TRUE,tm.cware,'W',"","","") RETURNING tm.cware   #MOD-B80197
                 #No.FUN-AA0048  --End  
                 DISPLAY BY NAME tm.cware
            WHEN INFIELD(cloc)
                 #No.FUN-AA0048  --Begin
                 #CALL cl_init_qry_var()
                 #LET g_qryparam.form = "q_ime"
                 #LET g_qryparam.default1 = tm.cloc
                 #LET g_qryparam.arg1     = tm.cware #倉庫編號
                 #LET g_qryparam.arg2     = "S"      #倉庫類別
                 #CALL cl_create_qry() RETURNING tm.cloc
#                CALL q_ime_1(FALSE,TRUE,tm.cloc,tm.cware,"S","","","","") RETURNING tm.cloc    #MOD-B80197 mark
                 CALL q_ime_1(FALSE,TRUE,tm.cloc,tm.cware,"W","","","","") RETURNING tm.cloc    #MOD-B80197
                 #No.FUN-AA0048  --End  
                 DISPLAY BY NAME tm.cloc
            WHEN INFIELD(oea01)    #修改為hot code
                LET l_t1=s_get_doc_no(tm.oea01)       #No.FUN-550052
               # CALL q_oay(FALSE,TRUE,l_t1,'34',g_sys) RETURNING l_t1      #FUN-A70130  mark
                 CALL q_oay(FALSE,TRUE,l_t1,'34','axm') RETURNING l_t1      #FUN-A70130  
                LET tm.oea01 = l_t1            #No.FUN-550052
                DISPLAY BY NAME tm.oea01
                NEXT FIELD oea01
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
      LET g_success = 'N'
      CLOSE WINDOW t600a_w
      RETURN l_oga.*
   END IF
 
   CLOSE WINDOW t600a_w
#   END IF   #FUN-630072 add                             #TQC-AB0375   mark
   IF cl_null(tm.cloc) THEN   #FUN-630102 modify
      LET tm.cloc=' '
   END IF
 
   UPDATE oga_file SET oga910 = tm.cware,
                       oga911 = tm.cloc
    WHERE oga01 = l_oga.oga01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","oga_file",l_oga.oga01,"",SQLCA.sqlcode,"","upd ogaconf",1)  #No.FUN-670008
      LET g_success = 'N'
      RETURN l_oga.*
   END IF
 
   LET l_oga.oga910 = tm.cware
   LET l_oga.oga911 = tm.cloc
 
   #no.7175 自動產生境外倉訂單(已確認的單據)
   IF tm.a = 'Y' THEN
      CALL t600sub_ins_oea(tm.*,l_oga.*)
   END IF
   RETURN l_oga.* #FUN-730012 add 必須將有異動的值回傳回去
END FUNCTION

#CHI-B60085 -- begin --
FUNCTION t600sub_chk_jce(p_oga01,p_ac,p_ware)
   DEFINE p_oga01     LIKE oga_file.oga01
   DEFINE p_ac        LIKE type_file.num5
   DEFINE p_ware      LIKE ogb_file.ogb09
   DEFINE l_i,l_cnt   LIKE type_file.num5
  #DEFINE l_ogb       RECORD LIKE ogb_file.*                 #MOD-CC0080 mark
   DEFINE l_ogb09     DYNAMIC ARRAY OF LIKE ogb_file.ogb09   #MOD-CC0080
   DEFINE l_chk_cost1 LIKE type_file.chr1
   DEFINE l_chk_cost2 LIKE type_file.chr1
   DEFINE l_oga00     LIKE oga_file.oga00   #MOD-CC0080 add

   LET g_errno = ''
   LET l_chk_cost1 = 'Y'
  #LET l_chk_cost2 = 'Y'   #MOD-CC0080 mark
   
   SELECT oga00 INTO l_oga00 FROM oga_file WHERE oga01 = p_oga01   #MOD-CC0080 add

   SELECT COUNT(*) INTO l_cnt FROM jce_file
      WHERE jce02 = p_ware
   IF l_cnt > 0 THEN
      LET l_chk_cost1 = 'N'
   END IF

   DECLARE ogb_curs1 CURSOR FOR
      SELECT ogb09 FROM ogb_file   #MOD-CC0080 SELECT * FROM ogb_file -> SELECT ogb09 FROM ogb_file
         WHERE ogb01 = p_oga01

   LET l_i = 1
   FOREACH ogb_curs1 INTO l_ogb09[l_i]        #MOD-CC0080 l_ogb.* -> l_ogb09[l_i] 
      IF p_ac = l_i THEN
         CONTINUE FOREACH
      END IF
      LET l_chk_cost2 = 'Y'   #MOD-CC0080 add
      SELECT COUNT(*) INTO l_cnt FROM jce_file
         WHERE jce02 = l_ogb09[l_i]           #MOD-CC0080 l_ogb.ogb09  -> l_ogb09[l_i] 
      IF l_cnt > 0 THEN
         LET l_chk_cost2 = 'N'
      END IF
      IF l_chk_cost1 != l_chk_cost2 THEN
         IF p_ac > 0 THEN
            IF l_oga00 = '3' THEN   #MOD-CC0080 add
               LET g_errno = 'axm-670'
            #MOD-CC0080 -- add start --
            ELSE
               LET g_errno = 'axm-672'
            END IF
            #MOD-CC0080 -- add end --
         ELSE
            IF l_oga00 = '3' THEN   #MOD-CC0080 add
               LET g_errno = 'axm-671'
            #MOD-CC0080 -- add start --
            ELSE
               LET g_errno = 'axm-673'
            END IF
            #MOD-CC0080 -- add end --
         END IF
         EXIT FOREACH
      END IF
      LET l_i = l_i + 1
   END FOREACH
END FUNCTION
#CHI-B60085 -- end -- 

FUNCTION t600sub_ins_oea(tm,l_oga)
   DEFINE tm        RECORD
                      #cware     VARCHAR(20), #MOD-5B0276 mark
                      #cloc      VARCHAR(20), #MOD-5B0276 mark
                       cware     LIKE img_file.img02, #MOD-5B0276
                       cloc      LIKE img_file.img03, #MOD-5B0276
                       a         LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
                       oea01     LIKE oea_file.oea01,  #No.FUN-550070
                       oea02     LIKE oea_file.oea02,
                       oeb15     LIKE oeb_file.oeb15
                    END RECORD
   DEFINE l_oea     RECORD LIKE oea_file.*
   DEFINE l_oeb     RECORD LIKE oeb_file.*
   DEFINE l_oebi    RECORD LIKE oebi_file.*       #No.FUN-7C0017
   DEFINE l_obk11   LIKE obk_file.obk11           #TQC-6A0045 add
   DEFINE l_obk12   LIKE obk_file.obk12           #TQC-6A0045 add
   DEFINE l_obk13   LIKE obk_file.obk13           #TQC-6A0045 add
   DEFINE l_obk14   LIKE obk_file.obk14           #TQC-6A0045 add
   DEFINE i         LIKE type_file.num5    #No.FUN-680137 SMALLINT
   DEFINE g_conf    LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
   DEFINE li_result LIKE type_file.num5             #No.FUN-560110  #No.FUN-680137 SMALLINT
   DEFINE l_msg     LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(72)   #No.FUN-5B0067
   DEFINE l_oeb930  LIKE oeb_file.oeb930   #FUN-670063
   DEFINE l_oga     RECORD LIKE oga_file.*
   DEFINE l_conf    LIKE type_file.chr1
   DEFINE l_ogb     RECORD LIKE ogb_file.*
   DEFINE l_azi04   LIKE azi_file.azi04    #MOD-BB0265 add
 
   #新增單頭(oea_file)
   LET l_oea.oea00  = '4'                #境外倉訂單
   LET l_oea.oea01  = tm.oea01           #單別
   LET l_oea.oea02  = tm.oea02           #訂單日期
 
  #改成用s_auto_assign_no
 
   CALL s_auto_assign_no("axm",l_oea.oea01,l_oea.oea02,"","oea_file","oea01","","","")
               RETURNING li_result,l_oea.oea01
   IF (NOT li_result) THEN
      LET g_success = 'N'
      RETURN
   END IF
 
   LET l_oea.oea03  = l_oga.oga03       #帳款客戶
   LET l_oea.oea032 = l_oga.oga032       #帳款客戶
   LET l_oea.oea033 = l_oga.oga033       #帳款客戶統一編號
   LET l_oea.oea04  = l_oga.oga04        #送貨客戶編號
   LET l_oea.oea044 = l_oga.oga044       #送貨客戶地址碼
   LET l_oea.oea17  = l_oga.oga18        #MOD-AB0078
   LET l_oea.oea05  = l_oga.oga05        #發票別
   LET l_oea.oea06  = 0                  #修改版本
   LET l_oea.oea07  = l_oga.oga07        #出貨是否計入未開發票的銷貨待驗收入
   LET l_oea.oea08  = l_oga.oga08        #內外銷
   LET l_oea.oea09  = g_oaz.oaz201       #允超交率
   LET l_oea.oea10  = l_oga.oga16        #客戶訂單單號 #CHI-970064  
   LET l_oea.oea11  = '7'                #境外倉出貨單
   LET l_oea.oea12  = l_oga.oga01        #來源單號
   LET l_oea.oea14  = l_oga.oga14        #人員編號
   LET l_oea.oea15  = l_oga.oga15        #部門編號
   LET l_oea.oea161 = l_oga.oga161       #訂金應收比率
   LET l_oea.oea162 = l_oga.oga162       #出貨應收比率
   LET l_oea.oea163 = l_oga.oga163       #尾款應收比率
   LET l_oea.oea03  = l_oea.oea03        #收款客戶編號
   LET l_oea.oea18  = 'N'                #是否使用訂單匯率立帳
   LET l_oea.oea20  = 'Y'                #是否直接送貨至客戶
   LET l_oea.oea21  = l_oga.oga21        #稅別
   LET l_oea.oea211 = l_oga.oga211       #稅率
   LET l_oea.oea212 = l_oga.oga212       #聯數
   LET l_oea.oea213 = l_oga.oga213       #含稅否
   LET l_oea.oea23  = l_oga.oga23        #幣別
   LET l_oea.oea24  = l_oga.oga24        #匯率
   LET l_oea.oea25  = l_oga.oga25        #銷售分類一
   LET l_oea.oea26  = l_oga.oga26        #銷售分類二
   LET l_oea.oea31  = l_oga.oga31        #價格條件編號
   LET l_oea.oea32  = l_oga.oga32        #收款條件編號
   LET l_oea.oea33  = l_oga.oga33        #其它條件
   LET l_oea.oea34  = l_oga.oga34        #佣金率或佣金金額
   LET l_oea.oea35  = l_oga.oga35        #卸貨港
   LET l_oea.oea41  = l_oga.oga41        #起運點
   LET l_oea.oea42  = l_oga.oga42        #到達地
   LET l_oea.oea43  = l_oga.oga43        #交運方式
   LET l_oea.oea44  = l_oga.oga44        #麥頭編號
   LET l_oea.oea45  = l_oga.oga45        #聯絡人
   LET l_oea.oea46  = l_oga.oga46        #專案編號
   LET l_oea.oea49  = '0'                #狀況碼
   LET l_oea.oea50  = 'N'                #是否CSD展開
   LET l_oea.oea61  = l_oga.oga50        #訂單總未稅金額
   LET l_oea.oea62  = 0                  #已出貨未稅金額
   LET l_oea.oea63  = 0                  #被結案未稅金額
   LET l_oea.oea72  = null               #首次確認日
   LET l_oea.oea901 = 'N'                #三角貿易否
   LET l_oea.oea65  = 'N'
   SELECT occ65 INTO l_oea.oea65 FROM occ_file
    WHERE occ01 = l_oea.oea03
      AND occacti='Y'
   IF cl_null(l_oea.oea65) THEN LET l_oea.oea65='N' END IF
 
   SELECT oayapr,oaysign INTO l_oea.oeamksg,l_oea.oeasign
     FROM oay_file
    WHERE oayslip = tm.oea01
 
   IF cl_null(l_oea.oeamksg) THEN
      LET l_oea.oeamksg='N'
      LET l_oea.oeasign=' '
   END IF
 
   IF l_oea.oeamksg = 'Y' THEN
      LET l_oea.oea49 = '0' #送簽中
   ELSE
      LET l_oea.oea49 = '1' #已核准
   END IF
 
   LET l_oea.oeasmax = 0                 #己簽順序     #FUN-730012
   LET l_oea.oeasseq = 0                 #應簽順序     #FUN-730012
   LET l_oea.oeadays = 0                 #簽核完成天數 #FUN-730012
   LET l_oea.oeaconf = 'N'               #確認否
   LET l_oea.oeaprsw = 0                 #列印次數
   LET l_oea.oeauser = g_user            #資料所有者
   LET g_data_plant = g_plant #FUN-980030
   LET l_oea.oeagrup = g_grup            #資料所有部門
   LET l_oea.oeamodu = null              #資料修改者
   LET l_oea.oeadate = g_today           #資料最近修改日期
 
   LET l_oea.oeaplant = l_oga.ogaplant
   LET l_oea.oealegal = l_oga.ogalegal
   IF g_azw.azw04='2' THEN
      LET l_oea.oea83 = l_oga.oga83
      LET l_oea.oea84 = l_oga.oga84        
      LET l_oea.oea85 = l_oga.oga85                                                                                                 
      LET l_oea.oea86 = l_oga.oga86       
      LET l_oea.oea87 = l_oga.oga87                                                                                                
      LET l_oea.oea88 = l_oga.oga88                                                                                                 
      LET l_oea.oea89 = l_oga.oga89                                                                                                 
      LET l_oea.oea90 = l_oga.oga90   
      LET l_oea.oea91 = l_oga.oga91                                                                                                 
      LET l_oea.oea92 = l_oga.oga92                                                                                                 
      LET l_oea.oea93 = l_oga.oga93                                                                                                 
   ELSE
      LET l_oea.oea85=' '
   END IF
 
   LET l_oea.oeaplant = g_plant 
   LET l_oea.oealegal = g_legal 
 
   LET l_oea.oeaoriu = g_user      #No.FUN-980030 10/01/04
   LET l_oea.oeaorig = g_grup      #No.FUN-980030 10/01/04

#FUN-B90104---mark--begin---
##TQC-B40069 --begin--
#  IF cl_null(l_oea.oeaslk02) THEN
#    LET l_oea.oeaslk02 = 'N'
#  END IF 
##TQC-B40069 --end--
#FUN-B90104---mark--end---

   #MOD-BB0265 ----- start start -----
   LET l_oea.oea1008 = l_oga.oga51
   SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01=l_oga.oga23

   IF l_oea.oea261=0 OR cl_null(l_oea.oea261) THEN
      IF l_oea.oea213 = 'Y' THEN
         LET l_oea.oea261 = l_oea.oea1008 * l_oea.oea161/100
      ELSE
         LET l_oea.oea261 = l_oea.oea61 * l_oea.oea161/100
      END IF
   END IF
   CALL cl_digcut(l_oea.oea261,l_azi04)  RETURNING l_oea.oea261

   IF l_oea.oea262=0 OR cl_null(l_oea.oea262) THEN
      IF l_oea.oea213 = 'Y' THEN
         LET l_oea.oea262 = l_oea.oea1008 * l_oea.oea162/100
      ELSE
         LET l_oea.oea262 = l_oea.oea61 * l_oea.oea162/100
      END IF
   END IF
   CALL cl_digcut(l_oea.oea262,l_azi04)  RETURNING l_oea.oea262

   IF l_oea.oea213 = 'Y' THEN
      LET l_oea.oea263 = l_oea.oea1008 - l_oea.oea261 - l_oea.oea262
   ELSE
      LET l_oea.oea263 = l_oea.oea61 - l_oea.oea261 - l_oea.oea262
   END IF
   #MOD-BB0265 ----- end start -----

   INSERT INTO oea_file VALUES (l_oea.*)
   IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
      LET g_success='N'
      CALL cl_err3("ins","oea_file",l_oea.oea01,"",SQLCA.sqlcode,"","ins oea:",1)  #No.FUN-670008
      RETURN
   END IF
   LET l_oeb930=s_costcenter(l_oea.oea15) #FUN-670063
   #處理自動確認動作
   CALL t600sub_hu(l_oea.oea01,l_oea.oea02,l_oea.oea03) RETURNING l_conf   #No.TQC-640123
   IF l_conf = 'Y' THEN
      IF l_oea.oeamksg = 'Y' THEN
         LET l_oea.oea49 = '0' #送簽中
      ELSE
         LET l_oea.oea49 = '1' #已核准
      END IF
      LET l_oea.oea72   = g_today
      LET l_oea.oeaconf = 'Y'
      UPDATE oea_file SET oea49  = l_oea.oea49,
                          oea72  = l_oea.oea72,
                          oeaconf= l_oea.oeaconf
       WHERE oea01 = l_oea.oea01
      IF STATUS THEN
         CALL cl_err3("upd","oea_file",l_oea.oea01,"",SQLCA.sqlcode,"","upd oea:",1)  #No.FUN-670008
         LET g_success = 'N'
      END IF
   END IF
 
   #新增單身(oeb_file)
   DECLARE oeb_cs CURSOR FOR SELECT * FROM ogb_file
                              WHERE ogb01 = l_oga.oga01
 
   FOREACH oeb_cs INTO l_ogb.*
      LET l_oeb.oeb01    = l_oea.oea01
      LET l_oeb.oeb03    = l_ogb.ogb03
      LET l_oeb.oeb71    = l_ogb.ogb03   #MOD-9B0185
      LET l_oeb.oeb04    = l_ogb.ogb04
      LET l_oeb.oeb05    = l_ogb.ogb05
      LET l_oeb.oeb05_fac= l_ogb.ogb05_fac
      LET l_oeb.oeb06    = l_ogb.ogb06
      LET l_oeb.oeb07    = l_ogb.ogb07
      LET l_oeb.oeb08    = l_ogb.ogb08
      LET l_oeb.oeb09    = tm.cware
      LET l_oeb.oeb091   = tm.cloc
      LET l_oeb.oeb092   = ' '
      LET l_oeb.oeb11    = l_ogb.ogb11
      LET l_oeb.oeb12    = l_ogb.ogb12
      LET l_oeb.oeb13    = l_ogb.ogb13
      LET l_oeb.oeb14    = l_ogb.ogb14
      LET l_oeb.oeb14t   = l_ogb.ogb14t
      LET l_oeb.oeb15    = tm.oeb15              #約訂交貨日
      LET l_oeb.oeb16    = tm.oeb15              #排定交貨日 #MOD-940300 add
     #LET l_oeb.oeb72    = tm.oeb15              #产品结构指定有效日期 #FUN-B20060 add  #CHI-C80060 mark
      LEt l_oeb.oeb72    = NULL                  #CHI-C80060 add
      LET l_oeb.oeb17    = l_oeb.oeb13           #取出單價
      LET l_oeb.oeb19    = 'N'                   #備置否
      LET l_oeb.oeb23    = 0                     #待出貨數量
      LET l_oeb.oeb24    = 0                     #已出貨數量
      LET l_oeb.oeb25    = 0                     #已銷退數量
      LET l_oeb.oeb26    = 0                     #被結案數量
      LET l_oeb.oeb70    = 'N'                   #結案否
      LET l_oeb.oeb901   = 0                     #已包裝數
      LET l_oeb.oeb905   = 0                     #備置量 no.7182
      LET l_oeb.oeb910   = l_ogb.ogb910
      LET l_oeb.oeb911   = l_ogb.ogb911
      LET l_oeb.oeb912   = l_ogb.ogb912
      LET l_oeb.oeb913   = l_ogb.ogb913
      LET l_oeb.oeb914   = l_ogb.ogb914
      LET l_oeb.oeb915   = l_ogb.ogb915
      LET l_oeb.oeb916   = l_ogb.ogb916  #No.FUN-580133
      LET l_oeb.oeb917   = l_ogb.ogb917  #No.FUN-580133
      LET l_oeb.oeb1003  = '1'           #TQC-740152
      LET l_oeb.oeb930   = l_oeb930  #FUN-670063
     LET l_oeb.oeb906 = 'N'   
      LET l_oeb.oeb41 = l_ogb.ogb41
      LET l_oeb.oeb42 = l_ogb.ogb42
      LET l_oeb.oeb43 = l_ogb.ogb43
      LET l_oeb.oeb1001 = l_ogb.ogb1001
 
      LET l_oeb.oebplant = l_ogb.ogbplant
		LET l_oeb.oeblegal = l_ogb.ogblegal
      LET l_oeb.oeb44 = l_ogb.ogb44
      IF g_azw.azw04='2' THEN
         LET l_oeb.oeb45 = l_ogb.ogb45
         LET l_oeb.oeb46 = l_ogb.ogb46                                                                                              
         LET l_oeb.oeb47 = l_ogb.ogb47
      ELSE
         LET l_oeb.oeb47=0
      END IF
      LET l_oeb.oeb48 = '1'
 
      LET l_oeb.oebplant = g_plant 
      LET l_oeb.oeblegal = g_legal 
 
      IF cl_null(l_oeb.oeb1006) THEN LET l_oeb.oeb1006 = 100 END IF    #MOD-A10123
      IF cl_null(l_oeb.oeb37) OR l_oeb.oeb37 = 0 THEN LET l_oeb.oeb37 = l_oeb.oeb13  END IF    #FUN-AB0061 
      INSERT INTO oeb_file VALUES (l_oeb.*)
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
         LET g_success='N'
         CALL cl_err3("ins","oeb_file","","",SQLCA.sqlcode,"","ins oeb:",1)  #No.FUN-670008
         EXIT FOREACH
      ELSE
         IF NOT s_industry('std') THEN
            INITIALIZE l_oebi.* TO NULL
            LET l_oebi.oebi01 = l_oeb.oeb01
            LET l_oebi.oebi03 = l_oeb.oeb03
            IF NOT s_ins_oebi(l_oebi.*,'') THEN
               EXIT FOREACH
            END IF
         END IF
      END IF
 
      #處理自動確認動作
      IF l_oea.oeaconf = 'Y' AND g_oaz.oaz44 = 'Y' THEN
         LET l_obk11 = 'N' 
         UPDATE obk_file SET obk03 = l_oeb.oeb11,
                             obk04 = l_oea.oea02,
                             obk06 = l_oea.oea21,
                             obk07 = l_oeb.oeb05,
                             obk08 = l_oeb.oeb13,
                             obk09 = l_oeb.oeb12 
          WHERE obk01 = l_oeb.oeb04
            AND obk02 = l_oea.oea03  #No.TQC-640123
            AND obk05 = l_oea.oea23  #TQC-730006 add
         IF SQLCA.SQLERRD[3] = 0 THEN
           INSERT INTO obk_file (obk01,obk02,obk03,obk04,obk05,
                                 obk06,obk07,obk08,obk09,
                                 obk11,obkacti)  #CHI-9C0060
                         VALUES (l_oeb.oeb04,l_oea.oea03,l_oeb.oeb11,  #No.TQC-640123
                                 l_oea.oea02,l_oea.oea23,l_oea.oea21,
                                 l_oeb.oeb05,l_oeb.oeb13,l_oeb.oeb12,
                                 l_obk11,'Y') #TQC-6A0045 add   #CHI-9C0060
         END IF
      END IF
   END FOREACH
 
   LET l_msg = cl_getmsg('axm-034',g_lang)
   LET l_msg=l_msg CLIPPED,"(",l_oea.oea01,")"
   CALL cl_msgany(10,20,l_msg)
END FUNCTION
 
FUNCTION t600sub_hu(p_oea01,p_oea02,p_oea03)   #No.TQC-640123
   DEFINE p_oea01 LIKE oea_file.oea01
   DEFINE p_oea02 LIKE oea_file.oea02
   DEFINE p_oea03 LIKE oea_file.oea03  #No.TQC-640123
   DEFINE l_occ   RECORD LIKE occ_file.*
 
  CALL cl_msg("S/O Auto Confirm......")
 
   #出貨單也有信用查核，所以訂單的信用查核在此不做..
   #最近交易日
   SELECT * INTO l_occ.* FROM occ_file WHERE occ01=p_oea03  #No.TQC-640123
     IF STATUS THEN
        CALL cl_err3("sel","occ_file",p_oea03,"",SQLCA.sqlcode,"","s occ",1)  #No.FUN-670008
      LET g_success='N' RETURN 'N'
   END IF
   IF l_occ.occ16 IS NULL THEN LET l_occ.occ16=p_oea02 END IF
   IF l_occ.occ172 IS NULL OR l_occ.occ172 < p_oea02 THEN
      LET l_occ.occ172=p_oea02
   END IF
   UPDATE occ_file SET * = l_occ.* WHERE occ01=p_oea03   #No.TQC-640123
     IF STATUS THEN
        CALL cl_err3("upd","occ_file",p_oea03,"",SQLCA.sqlcode,"","u ccc",1)  #No.FUN-670008
      LET g_success='N' RETURN 'N'
   END IF
   CALL cl_msg("")
   RETURN 'Y'
END FUNCTION
 
FUNCTION t600sub_on_check(l_oga)
   DEFINE l_n    LIKE type_file.num5    #No.FUN-680137 SMALLINT
   DEFINE tm     RECORD
                 cware     LIKE img_file.img02, #MOD-5B0276
                 cloc      LIKE img_file.img03  #MOD-5B0276
                 END RECORD
   DEFINE l_imd  RECORD LIKE imd_file.* #FUN-650101
   DEFINE p_row,p_col LIKE type_file.num5
   DEFINE l_oga  RECORD LIKE oga_file.*
 
   LET tm.cware=l_oga.oga66
   LET tm.cloc =l_oga.oga67
   IF cl_null(tm.cware) THEN
      LET tm.cware=g_oaz.oaz74
      LET tm.cloc =g_oaz.oaz75
   END IF
 
   LET p_row = 2 LET p_col = 39
 
   OPEN WINDOW t6271_w AT p_row,p_col WITH FORM "axm/42f/axmt6271"   #CHI-690060
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("axmt6271")   #CHI-690060
 
   INPUT BY NAME tm.cware,tm.cloc WITHOUT DEFAULTS
      AFTER FIELD cware
         IF NOT cl_null(tm.cware) THEN  #No:8570 genero,per檔加not required
            SELECT * INTO l_imd.* FROM imd_file #FUN-650101
             WHERE imd01 = tm.cware
               AND imdacti = 'Y' #MOD-4B0169
            IF STATUS <> 0 THEN
               CALL cl_err3("sel","imd_file",tm.cware,"","ams-004","","",1)  #No.FUN-670008
               NEXT FIELD cware
            END IF
            #IF NOT (l_imd.imd11 MATCHES '[Yy]') THEN
            #   CALL cl_err(g_oaz.oaz74,'axm-993',0)
            #   NEXT FIELD cware
            #END IF
           #IF NOT (l_imd.imd10 MATCHES '[Ss]') THEN #MOD-B30292 mark
            IF NOT (l_imd.imd10 MATCHES '[Ww]') THEN #MOD-B30292
              #CALL cl_err(g_oaz.oaz74,'axm-065',0)  #MOD-B30292 mark
               CALL cl_err(g_oaz.oaz74,'axm-666',0)  #MOD-B30292
               NEXT FIELD cware
            END IF
            IF NOT (l_imd.imd12 MATCHES '[Nn]') THEN
               CALL cl_err(tm.cware,'axm-067',0)   #No.MOD-740331
               NEXT FIELD cware
            END IF
 
            SELECT COUNT(*) INTO l_n FROM ogb_file
             WHERE ogb01 = l_oga.oga01
               AND ogb09 = tm.cware
            IF l_n > 0 THEN
               CALL cl_err('','axm-419',0)
               LET tm.cware=' '
               NEXT FIELD cware #No:8570
            END IF
            IF g_azw.azw04='2' THEN                                                                                                 
               LET l_n=0                                                                                                            
               SELECT COUNT(*) INTO l_n  FROM jce_file                                                                              
                WHERE jce02=tm.cware                                                                                                
               IF l_n !=0 THEN                                                                                                      
                  CALL cl_err(tm.cware,'art-452',0)                                                                                 
                  NEXT FIELD cware                                                                                                  
               END IF                                                                                                               
               #No.FUN-AA0048  --Begin
               #LET l_n =0                                                                                                           
               #SELECT COUNT(*) INTO l_n FROM imd_file                                                                               
               # WHERE imd01=tm.cware                                                                                                
               #   AND imd20=g_plant                                                                                            
               #IF l_n=0 THEN                                                                                                        
               #   CALL cl_err(tm.cware,'art-487',0)                                                                                 
               #   NEXT FIELD cware                                                                                                  
               #END IF                                                                                                               
               #No.FUN-AA0048  --End  
            END IF
            #No.FUN-AA0048  --Begin
            IF NOT s_chk_ware(tm.cware) THEN
               NEXT FIELD cware
            END IF
            #No.FUN-AA0048  --End  
            #MOD-CC0080 -- add start --
            CALL t600sub_chk_jce(l_oga.oga01,0,tm.cware)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD cware
            END IF
            #MOD-CC0080 -- add end --
        #FUN-D40103 --------Begin--------
            IF NOT s_imechk(tm.cware,tm.cloc) THEN
            #  NEXT FIELD cware   #TQC-D50126 mark
               NEXT FIELD cloc    #TQC-D50126
            END IF
       #FUN-D40103 --------End----------
         END IF
 
      AFTER FIELD cloc
         IF cl_null(tm.cloc) THEN   #FUN-630102 modify
            LET tm.cloc = ' '
         END IF
 #FUN-D40103 ------Begin------
       ##-----MOD-B40260---------
       ##start FUN-630102 mark
       #SELECT * FROM ime_file
       # WHERE ime01 = tm.cware
       #   AND ime02 = tm.cloc
       ##   AND ime04 = 'S'
       #IF STATUS <> 0 THEN
       #   CALL cl_err('','mfg0095',0)
       #   NEXT FIELD cware
       #END IF
       ##end FUN-630102 mark
       ##-----END MOD-B40260-----
  #FUN-D40103 ------End-------- 

      #FUN-D40103 ------Begin------
         IF NOT s_imechk(tm.cware,tm.cloc) THEN
            NEXT FIELD cloc 
         END IF
      #FUN-D40103 ------End--------
 
         SELECT COUNT(*) INTO l_n FROM ogb_file
          WHERE ogb01  = l_oga.oga01
            AND ogb09 = tm.cware
            AND ogb091 = tm.cloc
         IF l_n > 0 THEN
            CALL cl_err('','axm-419',0)
            LET tm.cloc=' '
            NEXT FIELD cware
         END IF
 
      AFTER INPUT
         IF INT_FLAG THEN EXIT INPUT END IF

        #-----MOD-B40260---------
        
        IF cl_null(tm.cloc) THEN LET tm.cloc = ' ' END IF
      #FUN-D40103 ----Begin-----
       ##start FUN-630102 mark
       #SELECT * FROM ime_file
       # WHERE ime01=tm.cware AND ime02=tm.cloc #AND ime04='S'
       #IF STATUS <> 0 THEN
       #   CALL cl_err('','mfg0095',0)
       #   LET tm.cloc=' '
       #   NEXT FIELD cloc
       #END IF
       ##end FUN-630102 mark
         IF NOT s_imechk(tm.cware,tm.cloc) THEN
            LET tm.cloc=' '
            NEXT FIELD cloc
         END IF 
      #FUN-D40103 ----End-------

       
        #-----END MOD-B40260-----


         SELECT COUNT(*) INTO l_n FROM ogb_file
          WHERE ogb01 = l_oga.oga01 AND ogb09 = tm.cware
         IF l_n > 0 THEN
            CALL cl_err('','axm-419',0)
            LET tm.cloc=' '
            NEXT FIELD tm.cware
         END IF
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(cware)
                 #No.FUN-AA0048  --Begin
                 #CALL cl_init_qry_var()
#                #LET g_qryparam.form ="q_imd"    #TQC-A50093  modify
                 #LET g_qryparam.form ="q_imd_03"  #TQC-A50093 modify
                 #LET g_qryparam.arg1     = 'S'        #倉庫類別 #MOD-4A0213
                 #LET g_qryparam.default1 = tm.cware
                 #CALL cl_create_qry() RETURNING tm.cware
                 CALL q_imd_1(FALSE,TRUE,tm.cware,'W',"","","imd11='Y' AND imd12 = 'N'") RETURNING tm.cware #MOD-B30292 mod S->W
                 #No.FUN-AA0048  --End  
                 DISPLAY BY NAME tm.cware
            WHEN INFIELD(cloc)
                 #No.FUN-AA0048  --Begin
                 #CALL cl_init_qry_var()
                 #LET g_qryparam.form = "q_ime"
                 #LET g_qryparam.default1 = tm.cloc
                 #LET g_qryparam.arg1     = tm.cware #倉庫編號
                 #LET g_qryparam.arg2     = "S"      #倉庫類別
                 #CALL cl_create_qry() RETURNING tm.cloc
                 CALL q_ime_1(FALSE,TRUE,tm.cloc,tm.cware,"W","","","","") RETURNING tm.cloc #MOD-B30292 mod S->W
                 #No.FUN-AA0048  --End  
                 DISPLAY BY NAME tm.cloc
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
      LET g_success = 'N'
      CLOSE WINDOW t6271_w
      RETURN l_oga.*
   END IF
 
   CLOSE WINDOW t6271_w
 
   IF cl_null(tm.cloc) THEN   #FUN-630102 modify
      LET tm.cloc=' '
   END IF
 
   UPDATE oga_file SET oga66 = tm.cware,
                       oga67 = tm.cloc
    WHERE oga01 = l_oga.oga01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err('upd ogaconf',SQLCA.SQLCODE,1)
      LET g_success = 'N'
      RETURN l_oga.*
   END IF
 
   LET l_oga.oga910 = tm.cware
   LET l_oga.oga911 = tm.cloc
   RETURN l_oga.* #FUN-730012 add 因為此處有異動oga_file的資料,所以必須回傳回去
END FUNCTION
 
FUNCTION t600sub_y1(l_oga)
   DEFINE l_slip   LIKE oay_file.oayslip
   DEFINE l_oay13  LIKE oay_file.oay13
   DEFINE l_oay14  LIKE oay_file.oay14
   DEFINE l_ogb14t LIKE ogb_file.ogb14t
   DEFINE l_oga    RECORD LIKE oga_file.*
   DEFINE l_ogb    RECORD LIKE ogb_file.*
   DEFINE l_oea    RECORD LIKE oea_file.*
 
   LET g_time = TIME    #FUN-A30063 ADD
   UPDATE oga_file SET ogaconf='Y',
                       ogaconu=g_user,
                       ogacond=g_today,
                       ogacont=g_time    #FUN-A30063 ADD
    WHERE oga01=l_oga.oga01
 
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","oga_file",l_oga.oga01,"",SQLCA.sqlcode,"","upd ogaconf",1)  #No.FUN-670008
      LET g_success = 'N'
      RETURN
   END IF
#FUN-BA0069 mark begin ----
#  #No.FUN-A20022 ADD--------UPDATE almq618&almq770 ABOUT the oga95_point----------------------------------
#   IF NOT cl_null(l_oga.oga87) THEN
#     #MOD-B10154 Begin---
#      SELECT SUM(ogb14t) INTO l_ogb14t FROM ogb_file 
#       WHERE ogb01=l_oga.oga01
#         AND ogb1005='1'
#      IF cl_null(l_ogb14t) THEN LET l_ogb14t = 0 END IF
#     #UPDATE lpj_file SET lpj07=lpj07+1,
#     #                    lpj08=g_today,
#     #                    lpj12=lpj12+l_oga.oga95
#      UPDATE lpj_file SET lpj07=COALESCE(lpj07,0)+1,
#                          lpj08=g_today,
#                          lpj12=COALESCE(lpj12,0)+l_oga.oga95,
#                          lpj14=COALESCE(lpj14,0)+l_oga.oga95,
#                          lpj15=COALESCE(lpj15,0)+l_ogb14t
#     #MOD-B10154 End-----
#       WHERE lpj03=l_oga.oga87
#      IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
#         CALL cl_err3("upd","lpj_file",l_oga.oga87,"",SQLCA.sqlcode,"","upd lpj12",1)
#         LET g_success = 'N'
#         RETURN
#      ELSE 
#         MESSAGE 'UPDATE lpj_file OK'
#      END IF
#      
#      INSERT INTO lsm_file VALUES( l_oga.oga87,'7',           #7:Maintain Shipping Order:axmt620
#                                   l_oga.oga01,l_oga.oga95,
#                                   g_today,'',l_oga.ogaplant) #No.FUN-A70118 Add lsm08
#      IF STATUS OR SQLCA.SQLCODE THEN
#         CALL cl_err3("ins","lsm_file","","",SQLCA.sqlcode,"","ins lsm",1)
#         LET g_success = 'N'
#         RETURN
#      ELSE
#         MESSAGE 'UPDATE lsm_file OK'
#      END IF                             
#   END IF
#  #No.FUN-A20022 END--------------------------------------------------------------------------------------
#FUN-BA0069 mark end ------
   LET l_slip=s_get_doc_no(l_oga.oga01)       #No.FUN-550052
   SELECT oay13,oay14 INTO l_oay13,l_oay14 FROM oay_file WHERE oayslip = l_slip
   IF l_oay13 = 'Y' THEN
      SELECT SUM(ogb14t) INTO l_ogb14t FROM ogb_file WHERE ogb01 = l_oga.oga01
      IF cl_null(l_ogb14t) THEN LET l_ogb14t = 0 END IF
      LET l_ogb14t = l_ogb14t * l_oga.oga24
      IF l_ogb14t > l_oay14 THEN
         CALL cl_err(l_oay14,'axm-700',1)
         LET g_success='N'
         RETURN
      END IF
   END IF
   CALL t600sub_hu2(l_oga.*) IF g_success = 'N' THEN RETURN END IF	#最近交易
   DECLARE t600_y1_c CURSOR FOR SELECT * FROM ogb_file WHERE ogb01=l_oga.oga01
   FOREACH t600_y1_c INTO l_ogb.*
      IF NOT cl_null(l_oga.oga16)
         AND l_ogb.ogb31!=l_oga.oga16 THEN
         CALL cl_err(l_ogb.ogb31,'axm-140',1)
         LET g_success='N'
         RETURN
      ELSE
         SELECT * INTO l_oea.* FROM oea_file
          WHERE oea01=l_ogb.ogb31
         IF l_oea.oea08 != l_oga.oga08 THEN        #國內外不符
             CALL cl_err(l_ogb.ogb31,'axm-125',0)
             LET g_success='N'
         END IF
         IF l_oea.oea03 != l_oga.oga03 THEN        #客戶不符 #No.TQC-640123
             CALL cl_err(l_ogb.ogb31,'axm-138',0)
             LET g_success='N'
          END IF
         IF l_oea.oea23 != l_oga.oga23 THEN        #幣別不符
             CALL cl_err(l_ogb.ogb31,'axm-144',0)
             LET g_success='N'
          END IF
         IF l_oea.oea21 != l_oga.oga21 THEN        #稅別不符
             CALL cl_err(l_ogb.ogb31,'axm-142',0)
             LET g_success='N'
          END IF
          IF g_success='N' THEN RETURN END IF
      END IF
#-----------------------------------------------#
     #CHI-A40029 mark --start--
     # IF l_ogb.ogb04[1,4] != 'MISC' THEN
     #     IF l_oga.oga09 NOT MATCHES  '[159]' THEN #非出貨通知單 #No.7992  #No.FUN-630061
     #        CALL t600sub_chk_img(l_oga.*,l_ogb.*) IF g_success='N' THEN RETURN END IF
     #        IF l_ogb.ogb17 = 'N' THEN
     #            CALL t600sub_chk_ogb15_fac(l_oga.*,l_ogb.*) IF g_success='N' THEN RETURN END IF
     #        END IF
     #     END IF
     # END IF
     #CHI-A40029 mark --end--
      CALL t600sub_chk_oeb(l_ogb.*) IF g_success='N' THEN RETURN END IF
      CALL t600sub_bu1(l_oga.*,l_ogb.*)   #No.TQC-8C0027
      IF g_success='N' THEN RETURN END IF
   END FOREACH
END FUNCTION
 
FUNCTION t600sub_hu2(l_oga)		#最近交易日
   DEFINE l_oga RECORD LIKE oga_file.*
   DEFINE l_occ RECORD LIKE occ_file.*
   CALL cl_msg("hu2!")
   SELECT * INTO l_occ.* FROM occ_file WHERE occ01=l_oga.oga03    #No.TQC-640123
   IF STATUS THEN
      CALL cl_err3("sel","occ_file",l_oga.oga03,"",SQLCA.sqlcode,"","s ccc",1)  #No.FUN-670008
      LET g_success='N'
      RETURN
   END IF
   IF l_occ.occ16 IS NULL THEN LET l_occ.occ16=l_oga.oga02 END IF
   IF l_occ.occ173 IS NULL OR l_occ.occ173 < l_oga.oga02 THEN
      LET l_occ.occ173=l_oga.oga02
   END IF
   UPDATE occ_file SET * = l_occ.* WHERE occ01=l_oga.oga03  #No.TQC-640123
   IF STATUS THEN
      CALL cl_err3("upd","occ_file",l_oga.oga03,"",SQLCA.sqlcode,"","u ccc",1)  #No.FUN-670008
      LET g_success='N'
      RETURN
   END IF
END FUNCTION
 
FUNCTION t600sub_chk_img(l_oga,l_ogb)
   DEFINE l_oga    RECORD LIKE oga_file.*
   DEFINE l_ogb    RECORD LIKE ogb_file.*
   DEFINE l_ogc    RECORD LIKE ogc_file.*
   DEFINE l_img18  LIKE img_file.img18   #No.MOD-480401
   DEFINE l_item   LIKE ogc_file.ogc17   #FUN-5C0075
   DEFINE l_cnt    LIKE type_file.num5
   DEFINE l_poy11  LIKE poy_file.poy11	    	#MOD-980090
   DEFINE li_result LIKE type_file.num5     	#MOD-980090
   DEFINE l_poz     RECORD LIKE poz_file.*  	#MOD-980090
   DEFINE l_oea99   LIKE oea_file.oea99     	#MOD-980090
   DEFINE l_oea904  LIKE oea_file.oea904    	#MOD-980090
   DEFINE l_last         LIKE type_file.num5    #MOD-980090
   DEFINE l_last_plant   LIKE cre_file.cre08    #MOD-980090
 
   #判斷是否為多倉儲
   IF l_ogb.ogb17='Y' THEN   #多倉儲
      DECLARE chk_ogc CURSOR FOR
         SELECT *
           FROM ogc_file
          WHERE ogc01 = l_ogb.ogb01
            AND ogc03 = l_ogb.ogb03
      FOREACH chk_ogc INTO l_ogc.*
         IF SQLCA.SQLCODE <>0 THEN EXIT FOREACH END IF
         LET l_cnt=0
         IF g_oaz.oaz23 = 'Y' AND NOT cl_null(l_ogc.ogc17) THEN
            LET l_item = l_ogc.ogc17
         ELSE
            let l_item = l_ogb.ogb04
         END IF
#FUN-AB0011 ---------------------STA
         IF s_joint_venture( l_item,g_plant) OR NOT s_internal_item( l_item,g_plant ) THEN
            RETURN
         END IF
#FUN-AB0011 ---------------------END
         LET l_cnt=0
         SELECT COUNT(*) INTO l_cnt FROM img_file
             WHERE img01 = l_item AND img02=l_ogc.ogc09   #FUN-5C0075
               AND img03 = l_ogc.ogc091
               AND img04 = l_ogc.ogc092
         IF l_cnt=0 THEN
            CALL cl_err(l_item,'axm-244',1) #FUN-970005     
            LET g_success = 'N'
            EXIT FOREACH
         END IF
      END FOREACH
   ELSE
#FUN-AB0011 ---------------------STA
      IF s_joint_venture( l_ogb.ogb04,g_plant) OR NOT s_internal_item( l_ogb.ogb04,g_plant ) THEN
     #    LET g_success = 'N'                      #FUN-AB0059   mark
         RETURN
      END IF
#FUN-AB0011 ---------------------END
      SELECT img18 INTO l_img18 FROM img_file
          WHERE img01 = l_ogb.ogb04
            AND img02 = l_ogb.ogb09
            AND img03 = l_ogb.ogb091
            AND img04 = l_ogb.ogb092
#-----MOD-A80026---------
{
      IF STATUS THEN
         IF l_oga.oga09  MATCHES  '[45]' THEN #非多角出貨單
            CALL t600sub_chkpoz(l_oga.*,NULL) RETURNING li_result,l_poz.*,l_oea99,l_oea904 
            IF NOT li_result THEN RETURN END IF 
            LET l_poy11 = ''
            IF l_poz.poz011='1' THEN   #正拋
               SELECT poy11 INTO l_poy11 
                 FROM poy_file
                WHERE poy01 = l_poz.poz01
                  AND poy02 = '0'
            ELSE
               CALL s_mtrade_last_plant(l_poz.poz01) 
                              RETURNING l_last,l_last_plant    #記錄最後一筆之家數
               SELECT poy11 INTO l_poy11 
                 FROM poy_file
                WHERE poy01 = l_poz.poz01
                  AND poy02 = l_last
            END IF
            IF l_poy11 <> l_ogb.ogb09 THEN
               CALL cl_err(l_ogb.ogb04,'axm-245',1)  #FUN-970005
               LET g_success = 'N'  #TQC-980155
               RETURN               #TQC-980155 
            END IF
         ELSE
            CALL cl_err(l_ogb.ogb04,'axm-244',1)  #FUN-970005  
            LET g_success = 'N'  #TQC-980155
            RETURN               #TQC-980155   
         END IF
      END IF
}
      IF STATUS THEN
         CALL cl_err(l_ogb.ogb04,'axm-244',1)  
         LET g_success = 'N'  
         RETURN             
      END IF
#-----END MOD-A80026-----
      IF l_img18 < l_oga.oga02 THEN
         CALL cl_err(l_ogb.ogb04,'aim-400',1)   #須修改
         LET g_success='N'
         RETURN
      END IF
   END IF
END FUNCTION
 
FUNCTION t600sub_chk_oeb(l_ogb)
   DEFINE l_over LIKE oea_file.oea09
   DEFINE l_ogb  RECORD LIKE ogb_file.*
   DEFINE l_tot1 LIKE ogb_file.ogb12
   DEFINE l_tot2 LIKE oeb_file.oeb12
   DEFINE l_tot3 LIKE oeb_file.oeb12   #MOD-A50076
   DEFINE l_chr  LIKE type_file.chr1
   DEFINE l_buf  LIKE type_file.chr1000
   DEFINE l_argv0 LIKE oga_file.oga09   #MOD-830155
   DEFINE l_msg  STRING			#FUN-970093
 
   SELECT oga09 INTO l_argv0 FROM oga_file WHERE oga01 = l_ogb.ogb01 #MOD-830155
   IF NOT cl_null(l_ogb.ogb31) AND l_ogb.ogb31[1,4] !='MISC' THEN
      # l_argv0 : 1.出貨通知單 2.出貨單 3.無訂單通知單
 
      IF s_industry('icd') THEN
	SELECT SUM(ogb12) INTO l_tot1 FROM ogb_file, oga_file,ogbi_file
	 WHERE ogb31=l_ogb.ogb31 AND ogb32=l_ogb.ogb32
	   AND ogb04 = l_ogb.ogb04 #BugNo:4541
	   AND ogb01=oga01 AND ogaconf='Y' AND oga09=l_argv0
	   AND ogbiicd03 <> '2'
	   AND ogb01 = ogbi01
	   AND ogb03 = ogbi03
      ELSE
	SELECT SUM(ogb12) INTO l_tot1 FROM ogb_file, oga_file
	 WHERE ogb31=l_ogb.ogb31 AND ogb32=l_ogb.ogb32
	   AND ogb04 = l_ogb.ogb04 #BugNo:4541
	   AND ogb01=oga01 AND ogaconf='Y' AND oga09=l_argv0
      END IF
      IF cl_null(l_tot1) THEN LET l_tot1 = 0 END IF
      LET l_chr='N'
      SELECT (oeb12*((100+oea09)/100)+oeb25),oeb70,oeahold,oea09
           INTO l_tot2,l_chr,l_buf,l_over
           FROM oeb_file, oea_file
          WHERE oeb01 = l_ogb.ogb31 AND oeb03 = l_ogb.ogb32 AND oeb01=oea01
      IF cl_null(l_tot2) THEN LET l_tot2 = 0 END IF
      #-----MOD-A50076---------
      LET l_tot3 = 0 
      SELECT SUM(ogb12) INTO l_tot3 FROM ogb_file,oga_file
       WHERE oga01 = ogb01
         AND ogb31 = l_ogb.ogb31 
         AND ogb32 = l_ogb.ogb32
         AND oga09 = '9'
         AND ogaconf = 'Y'
         AND ogapost = 'Y'
      IF cl_null(l_tot3) THEN LET l_tot3 = 0 END IF
      #-----END MOD-A50076----- 
      IF l_chr='Y' THEN #此訂單已結案, 不可再出貨
         CALL cl_err(l_ogb.ogb32,'axm-150',1) LET g_success = 'N' RETURN
      END IF
      IF NOT cl_null(l_buf) THEN #此訂單已設定留置, 不可出貨
         LET l_msg = l_ogb.ogb31 ,' + ', l_ogb.ogb32
         CALL cl_err(l_msg,'axm-151',1) LET g_success = 'N' RETURN
      END IF
      #no.7168 檢查備品資料
      IF t600sub_chkoeo(l_ogb.ogb31,l_ogb.ogb32,l_ogb.ogb04) THEN
          SELECT oeo09 INTO l_tot2 FROM oeo_file
           WHERE oeo01 = l_ogb.ogb31 AND oeo03 = l_ogb.ogb32
             AND oeo04 = l_ogb.ogb04 AND oeo08 = '2'
          IF cl_null(l_tot2) THEN LET l_tot2 = 0  END IF
          LET l_tot2 = l_tot2 *((100+l_over)/100) #含超交率，備品無法考慮銷退量
      END IF
      #no.7168(end)
      #IF l_tot1 > l_tot2 THEN #確認合計數量或金額大於原數量或金額, 不可再確認   #MOD-A50076
      IF l_tot1 > l_tot2 + l_tot3 THEN #確認合計數量或金額大於原數量或金額, 不可再確認   #MOD-A50076
         CALL cl_err(l_ogb.ogb31||' l_tot1 > oeb24','axm-174',1) LET g_success = 'N' RETURN  #MOD-940150 add
      END IF
 
# 出貨通知單出貨數量>訂單數量 --> show warning **********
      IF l_ogb.ogb12 > l_tot2 THEN #
         CALL cl_err('ogb12>l_tot2','axm-294',1)
      END IF
   END IF
END FUNCTION
 
FUNCTION t600sub_bu1(l_oga,l_ogb)   #更新訂單待出貨單量及已出貨量
   DEFINE l_amount LIKE oeb_file.oeb13   #出貨金額
   DEFINE l_oga    RECORD LIKE oga_file.*   #No.TQC-8C0027
   DEFINE l_ogb    RECORD LIKE ogb_file.*
   DEFINE l_tot3   LIKE ogb_file.ogb12
   DEFINE l_tot2   LIKE ogb_file.ogb12
   DEFINE l_tot1   LIKE ogb_file.ogb12
   DEFINE l_tot4   LIKE ogb_file.ogb12   #No.FUN-740016
   DEFINE l_tot5   LIKE ogb_file.ogb12   #MOD-AB0151
   DEFINE l_tot6   LIKE ogb_file.ogb12   #MOD-AB0151
   DEFINE l_oga011 LIKE oga_file.oga011  #MOD-AB0151
   DEFINE l_chr    LIKE type_file.chr1
   DEFINE l_buf    LIKE type_file.chr1000
   DEFINE l_oga00  LIKE oga_file.oga00   #No.FUN-740016
   DEFINE l_oea12  LIKE oea_file.oea12   #No.FUN-740016
   DEFINE l_oeb71  LIKE oeb_file.oeb71   #No.FUN-740016
   DEFINE l_oeb04  LIKE oeb_file.oeb04      
   DEFINE l_oeb24  LIKE oeb_file.oeb24      
   DEFINE l_oeb13  LIKE oeb_file.oeb13      
   DEFINE l_oeb05  LIKE oeb_file.oeb05      
   DEFINE l_oeb916 LIKE oeb_file.oeb916     
   DEFINE l_cnt    LIKE type_file.num5      
   DEFINE l_factor LIKE ima_file.ima31_fac  
   DEFINE l_tot    LIKE img_file.img10      
   DEFINE l_oea23  LIKE oea_file.oea23
   DEFINE l_oea213 LIKE oea_file.oea213
   DEFINE l_oea211 LIKE oea_file.oea211
   DEFINE l_azi04  LIKE azi_file.azi04
   DEFINE l_amt    LIKE oea_file.oea62
   DEFINE l_oeb29  LIKE oeb_file.oeb29   #No.TQC-8C0027
   DEFINE l_msg  STRING			 #FUN-970093
   DEFINE l_oebslk23  LIKE oebslk_file.oebslk23  #FUN-B90104----add
   DEFINE l_oebslk24  LIKE oebslk_file.oebslk24  #FUN-B90104----add
   DEFINE l_oga01  LIKE oga_file.oga01   #CHI-C20014
   DEFINE l_oea09  LIKE oea_file.oea09  #MOD-C90135
   DEFINE l_oeb12  LIKE oeb_file.oeb12  #MOD-C90135
   DEFINE l_ogb14  LIKE ogb_file.ogb14   #CHI-C90032 add
   DEFINE l_ocn03   LIKE ocn_file.ocn03  #CHI-C90032 add
   DEFINE l_ocn04   LIKE ocn_file.ocn04  #CHI-C90032 add
   DEFINE l_oea61   LIKE oea_file.oea61  #CHI-C90032 add
   DEFINE l_tot1_t  LIKE ogb_file.ogb12   #MOD-D70030 add
    
   IF t600sub_chkoeo(l_ogb.ogb31,l_ogb.ogb32,l_ogb.ogb04) THEN
      RETURN
   END IF
 
   CALL cl_msg("bu1!")
 
   IF NOT cl_null(l_ogb.ogb31) AND l_ogb.ogb31[1,4] !='MISC' THEN
      IF s_industry('icd') THEN
      SELECT SUM(ogb12) INTO l_tot3 FROM ogb_file, oga_file,ogbi_file
          WHERE ogb31=l_ogb.ogb31 AND ogb32=l_ogb.ogb32 AND ogb01=oga01
            AND ogb04=l_ogb.ogb04 #BugNo:4541
	    AND ogb01 = ogbi01
	    AND ogb03 = ogbi03
	    AND ogbiicd03 != '2'   #排除Spare Part的量
            AND ((oga09 IN ('1','5') AND (oga011 IS NULL OR oga011=' ')
                                       AND ogaconf='Y')
              #-----MOD-AB0151---------
              #OR (oga09 IN ('1','5') AND oga011 IS NOT NULL AND oga011!=' '
              #              AND oga011 IN (SELECT oga01 FROM oga_file,ogb_file
              #                            WHERE ogb31=l_ogb.ogb31
              #                              AND ogb32=l_ogb.ogb32
              #                              AND ogb01=oga01 AND ogaconf='N'))
              #-----END MOD-AB0151-----
              #-----MOD-A50076---------
              #OR (oga09 IN ('2','4','6') AND ogaconf='Y' AND ogapost='N'))  #No.FUN-630061   
              OR (oga09 IN ('2','4','6') AND (oga011 IS NULL OR oga011=' ')   #MOD-AB0151 add AND (oga011 IS NULL OR oga011=' ')
                                         AND ogaconf='Y' AND ogapost='N')    
              OR (oga09 IN ('2','4','6') AND (oga011 IS NULL OR oga011=' ')   #MOD-AB0151 add AND (oga011 IS NULL OR oga011=' ')
                         AND ogaconf='Y' AND ogapost='Y' AND oga65='Y'
                         AND oga01 NOT IN(SELECT oga011 FROM oga_file,ogb_file
                                            WHERE ogb31=l_ogb.ogb31
                                              AND ogb32=l_ogb.ogb32
                                              AND ogb01=oga01
                                              AND ogaconf='Y'
                                              AND ogapost='Y'
                                              AND oga09='8')))  
              #-----END MOD-A50076-----
         #-----MOD-AB0151---------
         IF cl_null(l_tot3) THEN LET l_tot3 = 0 END IF
         SELECT SUM(ogb12) INTO l_tot5 FROM ogb_file, oga_file
           WHERE ogb31=l_ogb.ogb31 AND ogb32=l_ogb.ogb32 AND ogb01=oga01
             AND ogb04=l_ogb.ogb04 
             AND oga09 IN ('1','5') AND oga011 IS NOT NULL AND oga011!=' '
         IF cl_null(l_tot5) THEN LET l_tot5 = 0 END IF
         DECLARE t600_curs_1 CURSOR FOR 
           SELECT DISTINCT oga011 FROM ogb_file, oga_file
             WHERE ogb31=l_ogb.ogb31 AND ogb32=l_ogb.ogb32 AND ogb01=oga01
               AND ogb04=l_ogb.ogb04 
               AND oga09 IN ('1','5') AND oga011 IS NOT NULL AND oga011!=' '
         FOREACH t600_curs_1 INTO l_oga011
           SELECT SUM(ogb12) INTO l_tot6 FROM ogb_file, oga_file
             WHERE ogb31=l_ogb.ogb31 AND ogb32=l_ogb.ogb32 AND ogb01=oga01
               AND ogb04=l_ogb.ogb04 
               AND oga09 IN ('2','4','6') 
               AND oga01 = l_oga011 
               AND ((ogapost = 'Y' AND oga65='N')
                   OR ( oga65='Y' AND 
                        oga01 IN (SELECT oga011 FROM oga_file,ogb_file
                                       WHERE ogb31=l_ogb.ogb31
                                         AND ogb32=l_ogb.ogb32
                                         AND ogb01=oga01
                                         AND ogaconf='Y'
                                         AND ogapost='Y'
                                         AND oga09='8')))  
           IF cl_null(l_tot6) THEN LET l_tot6 = 0 END IF
           LET l_tot5 = l_tot5 - l_tot6 
           #LET l_tot3 = l_tot3 + l_tot5   #MOD-AC0257
         END FOREACH
         LET l_tot3 = l_tot3 + l_tot5   #MOD-AC0257
      #-----END MOD-AB0151-----
      ELSE
      SELECT SUM(ogb12) INTO l_tot3 FROM ogb_file, oga_file
          WHERE ogb31=l_ogb.ogb31 AND ogb32=l_ogb.ogb32 AND ogb01=oga01
            AND ogb04=l_ogb.ogb04 #BugNo:4541
            AND ((oga09 IN ('1','5') AND (oga011 IS NULL OR oga011=' ')
                                       AND ogaconf='Y')
              #-----MOD-AB0151---------
              #OR (oga09 IN ('1','5') AND oga011 IS NOT NULL AND oga011!=' '
              #              AND oga011 IN (SELECT oga01 FROM oga_file,ogb_file
              #                            WHERE ogb31=l_ogb.ogb31
              #                              AND ogb32=l_ogb.ogb32
              #                              AND ogb01=oga01 AND ogaconf='N'))
              #-----END MOD-AB0151-----
              #-----MOD-A50076---------
              #OR (oga09 IN ('2','4','6') AND ogaconf='Y' AND ogapost='N'))  #No.FUN-630061   
              OR (oga09 IN ('2','4','6') AND (oga011 IS NULL OR oga011=' ')   #MOD-AB0151 add AND (oga011 IS NULL OR oga011=' ')
                                         AND ogaconf='Y' AND ogapost='N')    
              OR (oga09 IN ('2','4','6') AND (oga011 IS NULL OR oga011=' ')   #MOD-AB0151 add AND (oga011 IS NULL OR oga011=' ')
                                         AND ogaconf='Y' AND ogapost='Y' AND oga65='Y'
                         AND oga01 NOT IN(SELECT oga011 FROM oga_file,ogb_file
                                            WHERE ogb31=l_ogb.ogb31
                                              AND ogb32=l_ogb.ogb32
                                              AND ogb01=oga01
                                              AND ogaconf='Y'
                                              AND ogapost='Y'
                                              AND oga09='8')))  
              #-----END MOD-A50076-----
         #-----MOD-AB0151---------
         IF cl_null(l_tot3) THEN LET l_tot3 = 0 END IF
         SELECT SUM(ogb12) INTO l_tot5 FROM ogb_file, oga_file
           WHERE ogb31=l_ogb.ogb31 AND ogb32=l_ogb.ogb32 AND ogb01=oga01
             AND ogb04=l_ogb.ogb04 
             AND oga09 IN ('1','5') AND oga011 IS NOT NULL AND oga011!=' '
         IF cl_null(l_tot5) THEN LET l_tot5 = 0 END IF
         DECLARE t600_curs CURSOR FOR
           SELECT DISTINCT oga01, oga011 FROM ogb_file, oga_file             #CHI-C20014 add oga01 
             WHERE ogb31=l_ogb.ogb31 AND ogb32=l_ogb.ogb32 AND ogb01=oga01
               AND ogb04=l_ogb.ogb04 
               AND oga09 IN ('1','5') AND oga011 IS NOT NULL AND oga011!=' '
         FOREACH t600_curs INTO l_oga01, l_oga011     #CHI-C20014 add oga01
           SELECT SUM(ogb12) INTO l_tot6 FROM ogb_file, oga_file
             WHERE ogb31=l_ogb.ogb31 AND ogb32=l_ogb.ogb32 AND ogb01=oga01
               AND ogb04=l_ogb.ogb04 
               AND oga09 IN ('2','4','6') 
               #AND oga01 = l_oga011     #CHI-C20014 mark   #將oga01放進where條件,所以抓取已出貨量時會只抓到一筆出貨單數量,會造成一張出通單但是有多筆出貨單時出貨數量抓取錯誤
               AND oga011 = l_oga01     #CHI-C20014 add 
               AND ((ogapost = 'Y' AND oga65='N')
                   OR ( oga65='Y' AND 
                        oga01 IN (SELECT oga011 FROM oga_file,ogb_file
                                       WHERE ogb31=l_ogb.ogb31
                                         AND ogb32=l_ogb.ogb32
                                         AND ogb01=oga01
                                         AND ogaconf='Y'
                                         AND ogapost='Y'
                                         AND oga09='8')))  
           IF cl_null(l_tot6) THEN LET l_tot6 = 0 END IF
           LET l_tot5 = l_tot5 - l_tot6 
           #LET l_tot3 = l_tot3 + l_tot5   #MOD-AC0257
         END FOREACH
         LET l_tot3 = l_tot3 + l_tot5   #MOD-AC0257
      #-----END MOD-AB0151-----
      END IF
#MOD-C90135 add begin-----------#更新訂單待出貨數量的邏輯判斷,防止超過訂單允許的最大數量
      SELECT oea09 INTO l_oea09 FROM oea_file
       WHERE oea01=l_ogb.ogb31
      IF cl_null(l_oea09) THEN LET l_oea09 = 0 END IF 
      SELECT oeb12 INTO l_oeb12 FROM oeb_file 
      WHERE oeb01 = l_ogb.ogb31
        AND oeb03 = l_ogb.ogb32
      IF cl_null(l_oeb12) THEN LET l_oea09 = 0 END IF
      IF l_tot3 >= (1+l_oea09/100)*l_oeb12 THEN 
      	 LET l_tot3 = (1+l_oea09/100)*l_oeb12
      END IF 	  	
#MOD-C90135 ADD end-------------      
      IF cl_null(l_tot3) THEN LET l_tot3 = 0 END IF
      #MOD-D70030 mark begin----------------- 
#      IF s_industry('icd') THEN
#	 SELECT SUM(ogb12) INTO l_tot1 FROM ogb_file,oga_file,ogbi_file
#	     WHERE ogb31=l_ogb.ogb31 AND ogb32=l_ogb.ogb32
#	       AND ogb01 = ogbi01
#	       AND ogb03 = ogbi03
#	       AND ogbiicd03 <> '2'  #排除Spare Part的量
#	       AND ogb04=l_ogb.ogb04 #BugNo:4541
#               #AND ogb01=oga01 AND oga09 IN ('2','4','6','A') #No.7992  #No.FUN-630061   #MOD-A10122 oga09 add 'A'   #MOD-A50076
#	      #AND ogb1005 = '1'   #No.FUN-610064                 #TQC-B10066
#               AND (ogb1005 = '1' OR (ogb1005='2' OR ogb03<9001)) #TQC-B10066
#               #-----MOD-A50076---------
#	       #AND ogaconf='Y' AND ogapost='Y'  
#               AND ogb01=oga01
#               AND ((oga09 IN ('2','4','6','A') AND ogaconf='Y' AND ogapost='Y') # AND oga65='N') #MOD-D70030 add
#                 OR (oga09='8' AND ogaconf='Y' AND ogapost='Y'))
#               #-----END MOD-A50076-----
#      ELSE
#	 SELECT SUM(ogb12) INTO l_tot1 FROM ogb_file,oga_file
#	     WHERE ogb31=l_ogb.ogb31 AND ogb32=l_ogb.ogb32
#	       AND ogb04=l_ogb.ogb04 #BugNo:4541
#               #AND ogb01=oga01 AND oga09 IN ('2','4','6','A') #No.7992  #No.FUN-630061   #MOD-A10122 oga09 add 'A'   #MOD-A50076
#	      #AND ogb1005 = '1'   #No.FUN-610064                 #TQC-B10066
#               AND (ogb1005 = '1' OR (ogb1005='2' OR ogb03<9001)) #TQC-B10066
#               #-----MOD-A50076---------
#	       #AND ogaconf='Y' AND ogapost='Y'  
#               AND ogb01=oga01
#               AND ((oga09 IN ('2','4','6','A') AND ogaconf='Y' AND ogapost='Y') # AND oga65='N') #MOD-D70030 add 
#                 OR (oga09='8' AND ogaconf='Y' AND ogapost='Y'))
#               #-----END MOD-A50076-----
#      END IF
      #MOD-D70030 mark end-----------------
      #MOD-D70030 add begin-----------------
      IF s_industry('icd') THEN
     	   SELECT SUM(ogb12) INTO l_tot1 FROM ogb_file,oga_file,ogbi_file
     	     WHERE ogb31=l_ogb.ogb31 AND ogb32=l_ogb.ogb32
     	       AND ogb01 = ogbi01
     	       AND ogb03 = ogbi03
     	       AND ogbiicd03 <> '2'  #排除Spare Part的量
     	       AND ogb04=l_ogb.ogb04 
             AND (ogb1005 = '1' OR (ogb1005='2' OR ogb03<9001))
                    AND ogb01=oga01
                    AND (oga09 IN ('2','4','6','A') AND ogaconf='Y' AND ogapost='Y')
         IF g_prog[1,7]='axmt628' THEN
        	   SELECT SUM(ogb52) INTO l_tot1_t FROM ogb_file,oga_file,ogbi_file
        	     WHERE ogb31=l_ogb.ogb31 AND ogb32=l_ogb.ogb32
        	       AND ogb01 = ogbi01
        	       AND ogb03 = ogbi03
        	       AND ogbiicd03 <> '2'  #排除Spare Part的量
        	       AND ogb04=l_ogb.ogb04 
                AND (ogb1005 = '1' OR (ogb1005='2' OR ogb03<9001))
                AND ogb01=oga01            
                AND oga09='8' AND ogaconf='Y' AND ogapost='Y'
         END IF                  
         IF cl_null(l_tot1) THEN LET l_tot1 = 0 END IF
         IF cl_null(l_tot1_t) THEN LET l_tot1_t = 0 END IF
         IF g_prog[1,7]='axmt628' THEN
            LET  l_tot1 = l_tot1 - l_tot1_t  #出货量 - 签退量 = 实际出货量
         END IF    
      ELSE
   	   SELECT SUM(ogb12) INTO l_tot1 FROM ogb_file,oga_file
   	     WHERE ogb31=l_ogb.ogb31 AND ogb32=l_ogb.ogb32
   	       AND ogb04=l_ogb.ogb04 
                  AND (ogb1005 = '1' OR (ogb1005='2' OR ogb03<9001))
                  AND ogb01=oga01
                  AND (oga09 IN ('2','4','6','A') AND ogaconf='Y' AND ogapost='Y') 
         IF g_prog[1,7]='axmt628' THEN
      	   SELECT SUM(ogb52) INTO l_tot1_t FROM ogb_file,oga_file
      	     WHERE ogb31=l_ogb.ogb31 AND ogb32=l_ogb.ogb32
      	       AND ogb04=l_ogb.ogb04 
                     AND (ogb1005 = '1' OR (ogb1005='2' OR ogb03<9001))
                     AND ogb01=oga01    
                     AND oga09='8' AND ogaconf='Y' AND ogapost='Y' 
         END IF
         IF cl_null(l_tot1) THEN LET l_tot1 = 0 END IF
         IF cl_null(l_tot1_t) THEN LET l_tot1_t = 0 END IF         
         IF g_prog[1,7]='axmt628' THEN
            LET  l_tot1 = l_tot1 - l_tot1_t  #出货量 - 签退量 = 实际出货量
         END IF                                        
      END IF      
      
      
      #MOD-D70030 add end-------------------
      IF cl_null(l_tot1) THEN LET l_tot1 = 0 END IF
      DISPLAY '已出貨數量為tot1=',l_tot1
      LET l_chr='N'
      SELECT (oeb12*((100+oea09)/100)+oeb25),oeb70,oeahold
           INTO l_tot2,l_chr,l_buf
           FROM oeb_file, oea_file
          WHERE oeb01 = l_ogb.ogb31 AND oeb03 = l_ogb.ogb32 AND oeb01=oea01
      IF cl_null(l_tot2) THEN LET l_tot2 = 0 END IF
      IF l_chr='Y' THEN
         CALL cl_err(l_ogb.ogb32,'axm-150',1) LET g_success = 'N' RETURN
      END IF
      IF NOT cl_null(l_buf) THEN
         LET l_msg = l_ogb.ogb31 ,' + ', l_ogb.ogb32
         CALL cl_err(l_msg,'axm-151',1) LET g_success = 'N' RETURN
      END IF
      IF l_tot1 > l_tot2 THEN
         CALL cl_err(l_ogb.ogb31||' l_tot1 > oeb24','axm-174',1) LET g_success = 'N' RETURN  #MOD-940150 add
      END IF
 
      SELECT SUM(ogb12),SUM(ogb14) INTO l_tot4, l_ogb14 FROM ogb_file,oga_file    #CHI-C90032 add ogb14
          WHERE ogb31=l_ogb.ogb31
            AND ogb32=l_ogb.ogb32
            AND ogb04=l_ogb.ogb04
            AND ogb01=oga01 AND oga00='B'
            AND ogaconf='Y'
            AND ogapost='Y'  
      IF cl_null(l_tot4) THEN LET l_tot4 = 0 END IF
      IF cl_null(l_ogb14) THEN LET l_ogb14 = 0 END IF   #CHI-C90032 add 

      UPDATE oeb_file SET oeb23=l_tot3,
                          oeb24=l_tot1,
                          oeb29=l_tot4   #No.FUN-740016
       WHERE oeb01 = l_ogb.ogb31
         AND oeb03 = l_ogb.ogb32
      IF STATUS THEN
         CALL cl_err3("upd","oeb_file",l_ogb.ogb31,l_ogb.ogb32,SQLCA.sqlcode,"","upd oeb24",1)  #No.FUN-670008
         LET g_success = 'N' RETURN
      END IF
      IF SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err('upd oeb24','axm-134',1) LET g_success = 'N' RETURN
      END IF
#FUN-B90104----add---begin---
#     IF s_industry("slk")  THEN    #FUN-C20006--mark
      IF s_industry("slk") AND g_azw.azw04='2' THEN    #FUN-C20006--add
         SELECT SUM(oeb23),SUM(oeb24) INTO l_oebslk23,l_oebslk24 FROM oeb_file,oebi_file
          WHERE oeb01=oebi01
            AND oeb03=oebi03
            AND oeb01=l_ogb.ogb31
            AND oebislk03 = (SELECT oebislk03 FROM oeb_file,oebi_file
                               WHERE oebi01=oeb01
                                 AND oebi03=oeb03
                                 AND oeb01=l_ogb.ogb31
                                 AND oeb03=l_ogb.ogb32)

         UPDATE oebslk_file SET oebslk23=l_oebslk23,
                                oebslk24=l_oebslk24
          WHERE oebslk01 = l_ogb.ogb31
            AND oebslk03 =(SELECT oebislk03 FROM oebi_file,oeb_file
                            WHERE oebi01=oeb01
                              AND oebi03=oeb03
                              AND oebi01=l_ogb.ogb31
                              AND oebi03=l_ogb.ogb32)
                             
         IF STATUS THEN
            CALL cl_err3("upd","oebslk_file",l_ogb.ogb31,l_ogb.ogb32,SQLCA.sqlcode,"","upd oebslk24",1)
            LET g_success = 'N' RETURN
         END IF
         IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err('upd oebslk24','axm-134',1) LET g_success = 'N' RETURN
         END IF
       
      END IF
#FUN-B90104----add---begin---

      #如為借貨償價出貨單
      IF l_oga.oga00 = "B" AND l_oga.ogapost="Y" THEN 
         #抓出原借貨訂單單號
         SELECT oea12,oeb71 INTO l_oea12,l_oeb71 FROM oea_file,oeb_file 
          WHERE oeb01 = l_ogb.ogb31
            AND oeb03 = l_ogb.ogb32
            AND oea01 = oeb01
        
         #抓出原償價數量
         SELECT oeb29 INTO l_oeb29 from oeb_file
          WHERE oeb01 = l_oea12 
            AND oeb03 = l_oeb71
        
         IF cl_null(l_oeb29) THEN
            LET l_oeb29 = 0
         END IF
        
         UPDATE oeb_file SET oeb29 = l_oeb29 + l_ogb.ogb12 
          WHERE oeb01 = l_oea12 
            AND oeb03 = l_oeb71
         IF STATUS THEN
            CALL cl_err3("upd","oeb_file",l_oea12,l_oeb71,SQLCA.sqlcode,"","upd oeb29",1)  #No.FUN-670008
            LET g_success = 'N' RETURN
         END IF
         IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err('upd oeb29','axm-134',1) LET g_success = 'N' RETURN
         END IF
        #CHI-C90032 add START
        #業務額度在借貨出貨庫存扣帳時不異動,
        #業務額度在借貨償價庫存扣帳時會將業務額度加回
        #其他項目,像是一般訂單出貨單必不會異動業務額度
         LET l_oea61 = l_oga.oga24*l_ogb14
         CALL cl_digcut(l_oea61,g_azi04) RETURNING l_oea61
         SELECT ocn03,ocn04 INTO l_ocn03,l_ocn04 FROM ocn_file
          WHERE ocn01 = l_oga.oga14

         LET l_ocn03 = l_ocn03-l_oea61
         LET l_ocn04 = l_ocn04+l_oea61

         UPDATE ocn_file SET ocn03 = l_ocn03,
                             ocn04 = l_ocn04
          WHERE ocn01 = l_oga.oga14
        #CHI-C90032 add END
      END IF
 
# update 出貨金額 (oea62) for prog:axmq420 ----------
      DECLARE t600_curs2 CURSOR FOR 
        SELECT oeb04,oeb24,oeb13,oeb05,oeb916 FROM oeb_file 
          WHERE oeb01 = l_ogb.ogb31
           #AND oeb03 = l_ogb.ogb32   #MOD-990092 #MOD-C40114 mark     
      LET l_amount = 0 
      FOREACH t600_curs2 INTO l_oeb04,l_oeb24,l_oeb13,l_oeb05,l_oeb916
         CALL s_umfchk(l_oeb04,l_oeb05,l_oeb916)
              RETURNING l_cnt,l_factor
         IF l_cnt = 1 THEN 
            LET l_factor = 1
         END IF
         LET l_tot = l_oeb24 * l_factor
         SELECT oea23,oea213,oea211 INTO l_oea23,l_oea213,l_oea211 
            FROM oea_file
           WHERE oea01=l_ogb.ogb31
         SELECT azi04 INTO l_azi04 FROM azi_file 
            WHERE azi01 = l_oea23
         IF l_oea213 = 'N' THEN
           LET l_amt = l_tot * l_oeb13                        
           CALL cl_digcut(l_amt,l_azi04) RETURNING l_amt      
         ELSE
           LET l_amt = l_tot * l_oeb13                        
           CALL cl_digcut(l_amt,l_azi04) RETURNING l_amt     
           LET l_amt = l_amt/ (1+l_oea211/100)
           CALL cl_digcut(l_amt,l_azi04)  RETURNING l_amt      
         END IF
         LET l_amount = l_amount + l_amt
      END FOREACH
      IF cl_null(l_amount) THEN LET l_amount=0 END IF
      UPDATE oea_file SET oea62=l_amount
       WHERE oea01=l_ogb.ogb31
      IF SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","oea_file",l_ogb.ogb31,"",SQLCA.sqlcode,"","upd oea62",1)  #No.FUN-670008
         LET g_success = 'N' RETURN
      END IF
   END IF
END FUNCTION
 
#檢查是否為備品資料 no.7168
FUNCTION t600sub_chkoeo(p_oeo01,p_oeo03,p_oeo04)
  DEFINE p_oeo01 LIKE oeo_file.oeo01
  DEFINE p_oeo03 LIKE oeo_file.oeo03
  DEFINE p_oeo04 LIKE oeo_file.oeo04
  DEFINE l_cnt   LIKE type_file.num5
 
  LET l_cnt=0
  SELECT COUNT(*) INTO l_cnt FROM oeo_file
   WHERE oeo01 = p_oeo01 AND oeo03 = p_oeo03
     AND oeo04 = p_oeo04 AND oeo08 = '2'
  IF l_cnt > 0 THEN RETURN 1 ELSE RETURN 0 END IF
END FUNCTION
 
#{
#參數:p_cmd - IF p_cmd='2' 則會跳出"是否執行扣帳的對話選項視窗",其他值則不會跳出
#     p_inTransaction - 呼叫此FUN時,程式是否處在Transction中,IF p_inTransaction=TRUE 則不做 Begin Work,IF p_inTransaction=FALSE 則會呼叫begin work,例如:確認段來呼叫此FUN則傳TRUE,獨立執行此FUN則傳FALSE
#     p_oga01 - 出貨單頭單號
#     p_Input_oga02 - IF TRUE 則Input oga02,IF FALSE 則不Input oga02(WHEN背景執行或外部呼叫時)
#注意 :考慮到會有外部程式來呼叫此扣帳函數,所以把原本裡面的CALL t600_chspic()移到外面作,
#      所以做完_s()後,有需要重秀圖檔的話,必須再呼叫一次t600_chspic()
#}
FUNCTION t600sub_s(p_cmd,p_inTransaction,p_oga01,p_Input_oga02)            # when l_oga.ogapost='N' (Turn to 'Y')
DEFINE p_cmd     LIKE type_file.chr1,         #1.不詢問 2.要詢問  #No.FUN-680137 VARCHAR(1)
       p_inTransaction LIKE type_file.num5,   #FUN-730012 #是否要做 begin work 的指標
       p_oga01 LIKE oga_file.oga01,
       p_Input_oga02 LIKE type_file.num5,
       l_success LIKE type_file.chr1,         #TQC-680018 add #存放g_success值
       l_occ57   LIKE occ_file.occ57
DEFINE l_sql     STRING  #NO.TQC-630166
DEFINE l_ogb19   LIKE ogb_file.ogb19,
       l_ogb11   LIKE ogb_file.ogb11,
       l_ogb12   LIKE ogb_file.ogb12,
       l_qcs01   LIKE qcs_file.qcs01,
       l_qcs02   LIKE qcs_file.qcs02,
       l_qcs091c LIKE qcs_file.qcs091
DEFINE l_ima01   LIKE ima_file.ima01,
       l_ima1012 LIKE ima_file.ima1012,
       l_ogb04   LIKE ogb_file.ogb04,
       l_ogb14   LIKE ogb_file.ogb14,
       l_ogb14t  LIKE ogb_file.ogb14t,
       l_ogb1004 LIKE ogb_file.ogb1004,
       l_tqz02   LIKE tqz_file.tqz02,
       l_sum007  LIKE tsa_file.tsa07,
       l_sum034  LIKE tsa_file.tsa07,
       l_item    LIKE tqy_file.tqy35,
       l_i       LIKE type_file.num5,    #No.FUN-680137 SMALLINT
       l_j       LIKE type_file.num5     #No.FUN-680137 SMALLINT
DEFINE l_oga30   LIKE oga_file.oga30
DEFINE l_oay11   LIKE oay_file.oay11     #No:7647 add
DEFINE l_ogb     RECORD LIKE ogb_file.*  #No.FUN-610090
DEFINE l_oea904  LIKE oea_file.oea904    #NO.FUN-670007
DEFINE l_poz00   LIKE poz_file.poz011    #NO.FUN-670007
DEFINE l_oga02   LIKE oga_file.oga02     #FUN-650009 add
DEFINE l_oga910  LIKE oga_file.oga910    #FUN-650101 #FUN-710037
DEFINE l_imd10   LIKE imd_file.imd10     #FUN-650101
DEFINE l_imd11   LIKE imd_file.imd11     #FUN-650101
DEFINE l_imd12   LIKE imd_file.imd12     #FUN-650101
DEFINE l_yy,l_mm LIKE type_file.num5     #FUN-650009 add
DEFINE l_occ1027 LIKE occ_file.occ1017    #No.TQC-640123
DEFINE li_result LIKE type_file.num5     #FUN-730012
DEFINE lj_result LIKE type_file.chr1     #No.FUN-930108 VARCHAR(1)s_incchk()返回值
DEFINE l_argv0   LIKE ogb_file.ogb09
DEFINE l_oga     RECORD LIKE oga_file.*
DEFINE l_t1      LIKE oay_file.oayslip
DEFINE l_poz     RECORD LIKE poz_file.*
DEFINE l_unit_arr      DYNAMIC ARRAY OF RECORD  #No.FUN-610090
                          unit   LIKE ima_file.ima25,
                          fac    LIKE img_file.img21,
                          qty    LIKE img_file.img10
                       END RECORD
DEFINE l_imm01   LIKE imm_file.imm01      #No.FUN-610090
DEFINE l_oea99   LIKE oea_file.oea99
DEFINE m_ogb32   LIKE ogb_file.ogb32      #MOD-830222 add
DEFINE l_oha     RECORD LIKE oha_file.*
DEFINE l_ima906  LIKE ima_file.ima906
DEFINE l_msg     LIKE type_file.chr1000
DEFINE l_flow    LIKE oea_file.oea904
DEFINE l_imm03   LIKE imm_file.imm03,  #No.FUN-740016
       l_ogb31   LIKE ogb_file.ogb31,   #CHI-880006
       l_ogb03   LIKE ogb_file.ogb03    #CHI-880006
DEFINE l_tot   LIKE oeb_file.oeb24
DEFINE l_ocn03   LIKE ocn_file.ocn03
DEFINE l_ocn04   LIKE ocn_file.ocn04
DEFINE l_cnt         LIKE type_file.num5   #MOD-8B0077
DEFINE l_flag        LIKE type_file.chr1   #MOD-940273
DEFINE l_oeb19       LIKE oeb_file.oeb19   #MOD-970237
DEFINE l_oeb905      LIKE oeb_file.oeb905  #MOD-970237
#DEFINE l_flag1  LIKE type_file.chr1        #No.CHI-9C0027 #TQC-D30044 mark
DEFINE l_agree       LIKE type_file.chr1   #FUN-970017 add #自動確認和簽核
DEFINE l_oeb24       LIKE oeb_file.oeb24   #FUN-AC0074
DEFINE l_oeb12       LIKE oeb_file.oeb12   #FUN-AC0074
DEFINE l_oeb01       LIKE oeb_file.oeb01   #FUN-AC0074
DEFINE l_oeb03       LIKE oeb_file.oeb03   #FUN-AC0074
DEFINE l_sie11       LIKE sie_file.sie11   #FUN-AC0074
DEFINE l_oeb25       LIKE oeb_file.oeb25   #TQC-B50052
DEFINE l_oea09       LIKE oea_file.oea09   #TQC-B50052
DEFINE l_oea02  LIKE oea_file.oea02        #MOD-B50047 add
DEFINE l_flag2       LIKE type_file.chr1   #FUN-B70074
DEFINE l_oebslk24    LIKE oebslk_file.oebslk24  #FUN-B90104----add
DEFINE l_ogb04_1     LIKE ogb_file.ogb04   #FUN-BC0071 add
DEFINE l_n           LIKE type_file.num5   #FUN-BC0071 add
DEFINE l_oga09  LIKE oga_file.oga09        #FUN-C40072 add
DEFINE l_ima930      LIKE ima_file.ima930  #DEV-D30026 add 
DEFINE l_ima931      LIKE ima_file.ima931  #DEV-D30026 add
define l_occud03     like occ_file.occud03 #darcy:2024/12/06 add
   WHENEVER ERROR CONTINUE                #忽略一切錯誤  #FUN-730012

  #CHI-A50004 程式搬移 --start--
   IF NOT p_inTransaction THEN   #FUN-730012
      BEGIN WORK
      LET g_success = 'Y'
      LET g_totsuccess = 'Y' #TQC-620156
   END IF

  #DEV-D40015 add str--------
  #若aimi100[條碼使用否]=Y且有勾選製造批號/製造序號，需控卡不可直接確認or過帳
   IF g_aza.aza131 = 'Y' AND g_prog = 'axmt620' THEN
     #確認是否有符合條件的料件
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt
        FROM ima_file
       WHERE ima01 IN (SELECT ogb04 FROM ogb_file WHERE ogb01 = l_oga.oga01) #料件
         AND ima930 = 'Y'                   #條碼使用否
         AND (ima921 = 'Y' OR ima918 = 'Y') #批號管理否='Y' OR 序號管理否='Y'
	
     #確認是否已有掃描紀錄
      IF l_cnt > 0 THEN
         IF NOT s_chk_barcode_confirm('post','tlfb',l_oga.oga01,'','') THEN
            ROLLBACK WORK
            LET g_success = 'N'
            RETURN
         END IF
      END IF
   END IF
  #DEV-D40015 add end--------

   CALL t600sub_lock_cl()
   OPEN t600sub_cl USING p_oga01 #CHI-A50004 mod l_oga.oga01->p_oga01
   IF STATUS THEN
      CALL cl_err("OPEN t600sub_cl:", STATUS, 1)
      IF NOT p_inTransaction THEN   #MOD-B30430 add
         CLOSE t600sub_cl
         ROLLBACK WORK #MOD-B30430 add
      END IF #MOD-B30430 add
      LET g_success = 'N'   #TQC-930155 add
      RETURN
   END IF
 
   FETCH t600sub_cl INTO l_oga.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(l_oga.oga01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       IF NOT p_inTransaction THEN   #MOD-B30430 add
          CLOSE t600sub_cl
          ROLLBACK WORK #MOD-B30430 add
       END IF #MOD-B30430 add
       LET g_success = 'N'   #TQC-930155 add
       RETURN
   END IF
  #CHI-A50004 程式搬移 --end--

   #darcy:2024/12/06 add s---
   # - 如果客户被锁住不允许审核
   select occud03 into l_occud03 from occ_file where occ01 = l_oga.oga03
   if l_occud03 = 'Y' then
      let g_success = 'N'
      call cl_err(l_oga.oga03,'cxm-049',1)
      return 
   end if
   #darcy:2024/12/06 add e---

  #MOD-B30430 mod --start--
  #IF s_shut(0) THEN LET g_success = 'N' RETURN END IF #CHI-A50004 add LET g_success = 'N'
   IF s_shut(0) THEN 
      IF NOT p_inTransaction THEN 
         CLOSE t600sub_cl
         ROLLBACK WORK 
      END IF 
      LET g_success = 'N' 
      RETURN 
   END IF 
  #MOD-B30430 mod --end--
   SELECT * INTO l_oga.* FROM oga_file WHERE oga01 = p_oga01
   LET l_oga.oga02 = g_today # add by wangxt170210
  #FUN-970017---add----str----
   LET l_agree = 'N'
   #同時具有自動確認和簽核的功能時的判斷
   LET l_t1=s_get_doc_no(l_oga.oga01)
   SELECT * INTO g_oay.* FROM oay_file WHERE oayslip=l_t1
   IF g_oay.oayconf = 'Y' AND g_oay.oayapr = 'Y' AND
      g_action_choice = 'efconfirm' THEN

      #(1)出貨單確認時,庫存扣帳方式若為'2:立刻扣帳(會詢問)',一律改為'1:立刻扣帳(不詢問)'
       IF p_cmd = '2' THEN
           LET p_cmd = '1'
       END IF

      #(2)不能 INPUT oga02
       LET p_Input_oga02 = FALSE

      #(3)出貨立刻扣帳,扣帳日期設為g_today
       LET l_agree = 'Y'
   END IF
  #FUN-970017---add----end----

   IF l_oga.oga00 = "A" THEN
      LET l_cnt = 0 
      SELECT COUNT(*) INTO l_cnt FROM imm_file
        WHERE imm09 = p_oga01
      IF l_cnt > 0 THEN
         CALL cl_err('post=Y','mfg0175',1)
         IF NOT p_inTransaction THEN #MOD-B30430 add 
            CLOSE t600sub_cl
            ROLLBACK WORK #MOD-B30430 add
         END IF #MOD-B30430 add
         LET g_success = 'N'  #TQC-930155 add
         RETURN
      END IF
   END IF
  #MOD-B30430 mod --start--
  #IF l_oga.oga01 IS NULL THEN CALL cl_err('',-400,0) LET g_success = 'N' RETURN END IF #CHI-A50004 add LET g_success = 'N'
   IF l_oga.oga01 IS NULL THEN 
      CALL cl_err('',-400,0) 
      IF NOT p_inTransaction THEN  
         CLOSE t600sub_cl
         ROLLBACK WORK 
      END IF 
      LET g_success = 'N' 
      RETURN 
   END IF 
  #MOD-B30430 mod --end--
   LET l_argv0=l_oga.oga09  #FUN-730012
   IF l_argv0 MATCHES '[15]' THEN       #No.7992
     #MOD-B30430 mod --start--
     #CALL cl_err('','axm-226',0) LET g_success = 'N' RETURN #CHI-A50004 add LET g_success = 'N'
      CALL cl_err('','axm-226',0) 
      IF NOT p_inTransaction THEN  
         CLOSE t600sub_cl
         ROLLBACK WORK 
      END IF 
      LET g_success = 'N' 
      RETURN
     #MOD-B30430 mod --end--
   END IF
  #MOD-B30430 mod --start--
  #IF l_oga.ogaconf='X' THEN CALL cl_err('conf=X',9024,0) LET g_success = 'N' RETURN END IF #CHI-A50004 add LET g_success = 'N'
  #IF l_oga.ogaconf='N' THEN CALL cl_err('conf=N','axm-154',0) LET g_success = 'N' RETURN END IF #CHI-A50004 add LET g_success = 'N'
  #IF l_oga.ogapost='Y' THEN CALL cl_err('post=Y','mfg0175',0) LET g_success = 'N' RETURN END IF #CHI-A50004 add LET g_success = 'N'
   IF l_oga.ogaconf='X' THEN 
      CALL cl_err('conf=X',9024,0) 
      IF NOT p_inTransaction THEN  
         CLOSE t600sub_cl
         ROLLBACK WORK 
      END IF 
      LET g_success = 'N' 
      RETURN 
   END IF 
   IF l_oga.ogaconf='N' THEN 
      CALL cl_err('conf=N','axm-154',0) 
      IF NOT p_inTransaction THEN  
         CLOSE t600sub_cl
         ROLLBACK WORK 
      END IF 
      LET g_success = 'N' 
      RETURN 
   END IF 
   IF l_oga.ogapost='Y' THEN 
      CALL cl_err('post=Y','mfg0175',0) 
      IF NOT p_inTransaction THEN  
         CLOSE t600sub_cl
         ROLLBACK WORK 
      END IF 
      LET g_success = 'N' 
      RETURN 
   END IF 
  #MOD-B30430 mod --end--


#FUN-BC0071 -----------STA
    SELECT COUNT(*) INTO l_n  FROM ogb_file
     WHERE ogb01 = l_oga.oga01
       AND ogb1001 = g_oaz.oaz88
     IF l_n > 0 THEN
       DECLARE l_ogb04_cur1 CURSOR FOR
        SELECT ogb04 FROM ogb_file
         WHERE ogb01= l_oga.oga01
           AND ogb1001 = g_oaz.oaz88
       FOREACH  l_ogb04_cur1 INTO l_ogb04_1
          SELECT COUNT(*) INTO l_n FROM lpx_file,lqe_file,lqw_file
           WHERE lpx32 = l_ogb04_1 AND lpx01 = lqe02     #TQC-C20407
             AND lqw08 = lqe02 AND lqw00 = '02'
              AND lqw01= l_oga.oga01
              AND lqe01 BETWEEN lqw09 AND lqw10
              AND ((lqe17 NOT IN ('5','2') AND lqe13 = l_oga.ogaplant)
                 OR (lqe17 IN ('5','2') AND lqe13  <> l_oga.ogaplant))
           IF l_n > 0 THEN
              CALL s_errmsg("ogb04",l_ogb04_1,"",'alm1567',1)
              LET g_success = "N"
              CONTINUE FOREACH
           END IF
       END FOREACH
       IF g_success = "N" THEN
          IF NOT p_inTransaction THEN
             CLOSE t600sub_cl
             ROLLBACK WORK
          END IF
          RETURN
       END IF
     END IF

#FUN-BC0071 -----------END
    
   IF p_Input_oga02 = FALSE THEN  #MOD-D70161 add
      IF g_oaz.oaz03 = 'Y' AND g_sma.sma53 IS NOT NULL AND
         l_oga.oga02 <= g_sma.sma53 THEN
        #MOD-B30430 mod --start--
        #CALL cl_err('','mfg9999',0) LET g_success = 'N' RETURN #CHI-A50004 add LET g_success = 'N'
         CALL cl_err('','mfg9999',0) 
         IF NOT p_inTransaction THEN  
            CLOSE t600sub_cl
            ROLLBACK WORK 
         END IF 
         LET g_success = 'N' 
         RETURN 
        #MOD-B30430 mod --end--
      END IF
   END IF  #MOD-D70161 add
   DECLARE ogb_s_c CURSOR FOR
      SELECT * FROM ogb_file WHERE ogb01 = l_oga.oga01
   CALL s_showmsg_init()
 
   FOREACH ogb_s_c INTO l_ogb.*
      IF cl_null(l_oga.oga99) THEN
         CALL s_incchk(l_ogb.ogb09,l_ogb.ogb091,g_user)
               RETURNING lj_result
         IF NOT lj_result THEN
            LET g_success = 'N'
            LET g_showmsg = l_ogb.ogb03,"/",l_ogb.ogb09,"/",l_ogb.ogb091,"/",g_user
            CALL s_errmsg('ogb03,ogb09,ogb091,inc03',g_showmsg,'','asf-888',1)
         END IF
       END IF
      #DEV-D30026---add---str---
      IF g_aza.aza131 = 'Y' THEN
          SELECT ima930,ima931 INTO l_ima930,l_ima931
            FROM ima_file
           WHERE ima01 = l_ogb.ogb04
          IF l_ima930 = 'Y' AND l_ima931 = 'Y' THEN
              LET l_cnt = 0
              SELECT COUNT(*) INTO l_cnt
                FROM box_file
               WHERE box01 IN (SELECT ogb01 FROM oga_file,ogb_file
                                WHERE ogb31 = l_ogb.ogb31
                                  AND ogb32 = l_ogb.ogb32
                                  AND oga01 = ogb01
                                  AND oga09 = '1')
                 AND box02 IN (SELECT ogb03 FROM oga_file,ogb_file
                                WHERE ogb31 = l_ogb.ogb31
                                  AND ogb32 = l_ogb.ogb32
                                  AND oga01 = ogb01
                                  AND oga09 = '1')
              IF l_cnt = 0 THEN
                  LET g_success = 'N'
                  LET g_showmsg = l_ogb.ogb03,"/",l_ogb.ogb31,"/",l_ogb.ogb32,"/",l_ogb.ogb04
                  #單身料件有使用條碼(ima930)='Y'且包號管理(ima931)='Y'時,需有做配貨單才能"庫存扣帳"!
                  CALL s_errmsg('ogb03,ogb31,ogb32,ogb04',g_showmsg,'','aba-129',1)
              END IF
          END IF
      END IF
      #DEV-D30026---add---end---
   END FOREACH
   CALL s_showmsg()
   IF g_success = 'N' THEN
      #MOD-B30430 add --start--
      IF NOT p_inTransaction THEN  
         CLOSE t600sub_cl
         ROLLBACK WORK 
      END IF 
      #MOD-B30430 add --end--
      RETURN
   END IF

   SELECT occ57 INTO l_occ57 FROM occ_file WHERE occ01 =l_oga.oga03   #No.TQC-640123
   IF SQLCA.sqlcode THEN LET l_occ57 = 'N' END IF
 
    IF l_argv0='4' OR l_argv0='6' THEN
       IF g_oax.oax04='Y' THEN   #NO.FUN-670007
          IF cl_null(l_oga.oga27) THEN  
             CALL cl_err('','axm-997',0)
             #MOD-B30430 add --start--
             IF NOT p_inTransaction THEN  
                CLOSE t600sub_cl
                ROLLBACK WORK 
             END IF 
             #MOD-B30430 add --end--
             LET g_success = 'N'   #FUN-580113
             RETURN
          ELSE
             SELECT * FROM ofa_file WHERE ofa01=l_oga.oga27 AND ofaconf='Y'    
             IF STATUS=100 THEN
                CALL cl_err3("sel","ofa_file",l_oga.oga27,"",SQLCA.sqlcode,"","sel ofa:",1)  #No.FUN-670008  
                #MOD-B30430 add --start--
                IF NOT p_inTransaction THEN  
                   CLOSE t600sub_cl
                   ROLLBACK WORK 
                END IF 
                #MOD-B30430 add --end--
                LET g_success = 'N'   #FUN-580113
                RETURN
             END IF
          END IF
       END IF
    END IF
 
   IF l_oga.oga00 = "A" THEN
      #-----MOD-A70068---------
      DECLARE ogb_c2 CURSOR FOR
        SELECT * FROM ogb_file WHERE ogb01 = l_oga.oga01
      FOREACH ogb_c2 INTO l_ogb.*       
         CALL t600_chk_avl_stk(l_ogb.*) 
         IF g_success='N' THEN
            #MOD-B30430 add --start--
            IF NOT p_inTransaction THEN  
               CLOSE t600sub_cl
               ROLLBACK WORK 
            END IF 
            #MOD-B30430 add --end--
            RETURN     
         END IF    
         #MOD-B10110 add --start--
         IF l_ogb.ogb19 = 'Y' THEN
            LET l_qcs091c = 0
            IF NOT cl_null(l_oga.oga011) THEN
               SELECT SUM(qcs091) INTO l_qcs091c
                 FROM qcs_file
                WHERE qcs01 = l_oga.oga011
                  AND qcs02 = l_ogb.ogb03
                  AND qcs14 = 'Y'
            END IF
            IF cl_null(l_qcs091c) OR l_qcs091c = 0 THEN
               SELECT SUM(qcs091) INTO l_qcs091c
                 FROM qcs_file
                WHERE qcs01 = l_ogb.ogb01
                  AND qcs02 = l_ogb.ogb03
                  AND qcs14 = 'Y'
            END IF

            IF l_qcs091c IS NULL THEN
               LET l_qcs091c =0
            END IF
            IF l_argv0<>"8" OR cl_null(l_argv0) THEN 
               IF l_ogb.ogb12 > l_qcs091c THEN
                  CALL cl_err(l_ogb.ogb11,'mfg3553',1) 
                  #MOD-B30430 add --start--
                  IF NOT p_inTransaction THEN  
                     CLOSE t600sub_cl
                     ROLLBACK WORK 
                  END IF 
                  #MOD-B30430 add --end--
                  LET g_success = 'N' 
                  RETURN
               END IF
            END IF
         END IF
         #MOD-B10110 add --end--
      END FOREACH   
      #-----END MOD-A70068-----
      #MOD-D10185 add start -----
      SELECT COUNT(*) INTO l_cnt FROM ogb_file WHERE ogb01 = l_oga.oga01 AND ogb04 NOT LIKE 'MISC%'
      IF l_cnt > 0 THEN
      #MOD-D10185 add end   -----
         CALL t600sub_imm(l_oga.oga01) RETURNING l_oga.oga70
         IF cl_null(l_oga.oga70) THEN
            CALL cl_err(l_oga.oga01,"axm-145",1)
            #MOD-B30430 add --start--
            IF NOT p_inTransaction THEN  
               CLOSE t600sub_cl
               ROLLBACK WORK 
            END IF 
            #MOD-B30430 add --end--
            LET g_success = 'N' #CHI-A50004 add
            RETURN
         END IF
    
         SELECT imm03 INTO l_imm03 FROM imm_file
          WHERE imm01 = l_oga.oga70
         IF l_imm03 = "Y" THEN
            LET l_oga.ogapost='Y'
            DECLARE ogb_c CURSOR FOR
              SELECT * FROM ogb_file WHERE ogb01 = l_oga.oga01
            FOREACH ogb_c INTO l_ogb.*
               SELECT oeb24 INTO l_tot FROM oeb_file 
                WHERE oeb01 = l_ogb.ogb31
                  AND oeb03 = l_ogb.ogb32
               LET l_tot = l_tot+l_ogb.ogb12
               
               UPDATE oeb_file SET oeb24=l_tot
                WHERE oeb01 = l_ogb.ogb31
                  AND oeb03 = l_ogb.ogb32
   #FUN-B90104----add---begin---
   #           IF s_industry("slk") THEN     #FUN-C20006--mark
               IF s_industry("slk") AND g_azw.azw04='2' THEN    #FUN-C20006--add
                  SELECT SUM(oeb24) INTO l_oebslk24 FROM oeb_file,oebi_file
                   WHERE oeb01=oebi01
                     AND oeb03=oebi03
                     AND oeb01=l_ogb.ogb31
                     AND oebislk03 = (SELECT oebislk03 FROM oeb_file,oebi_file
                                        WHERE oebi01=oeb01
                                          AND oebi03=oeb03
                                          AND oeb01=l_ogb.ogb31
                                          AND oeb03=l_ogb.ogb32)
   
                  UPDATE oebslk_file SET oebslk24=l_oebslk24
                   WHERE oebslk01 = l_ogb.ogb31
                     AND oebslk03 =(SELECT oebislk03 FROM oebi_file,oeb_file
                                     WHERE oebi01=oeb01
                                       AND oebi03=oeb03
                                       AND oebi01=l_ogb.ogb31
                                       AND oebi03=l_ogb.ogb32)
   
               END IF
   #FUN-B90104----add---begin---
              #CHI-C90032 MARK START 
              #SELECT ocn03,ocn04 INTO l_ocn03,l_ocn04 FROM ocn_file
              # WHERE ocn01 = l_oga.oga14
              #
              #LET l_ocn03 = l_ocn03-(l_oga.oga24*l_ogb.ogb14)
              #LET l_ocn04 = l_ocn04+(l_oga.oga24*l_ogb.ogb14)
              #
              #UPDATE ocn_file SET ocn03 = l_ocn03,
              #                    ocn04 = l_ocn04
              # WHERE ocn01 = l_oga.oga14
              #CHI-C90032 MARK END
               #更新已備置量 
              #FUN-AC0074--begin--modify---
              CALL s_updsie_sie(l_ogb.ogb01,l_ogb.ogb03,'2') 
              #SELECT oeb19,oeb905 INTO l_oeb19,l_oeb905 FROM oeb_file
              # WHERE oeb01=l_ogb.ogb31 AND oeb03=l_ogb.ogb32
              #IF l_oeb19 = 'Y' THEN
              #   IF l_oeb905 > l_ogb.ogb12 THEN 
              #      LET l_oeb905= l_oeb905 - l_ogb.ogb12
              #   ELSE
              #      LET l_oeb905 = 0 
              #   END IF
              #   UPDATE oeb_file SET oeb905 = l_oeb905
              #    WHERE oeb01 = l_ogb.ogb31
              #      AND oeb03 = l_ogb.ogb32
              #END IF
              #FUN-AC0074--end--modify----
            END FOREACH
           #FUN-AC0074--begin--add----
            DECLARE t600sub_sie_c1 CURSOR FOR
              SELECT DISTINCT ogb31,ogb32 FROM ogb_file,sie_file  #TQC-B50052 add sie_file
               WHERE ogb01=l_oga.oga01
                 AND ogb31=sie05 AND ogb32=sie15 AND sie11 > 0    #TQC-B50052
            FOREACH t600sub_sie_c1 INTO l_oeb01,l_oeb03
              SELECT oeb24,oeb12,oeb25,oea09 INTO l_oeb24,l_oeb12,l_oeb25,l_oea09 FROM oeb_file,oea_file #TQC-B50052
               WHERE oeb01=l_oeb01 AND oeb03=l_oeb03 AND oea01=oeb01  #TQC-B50052
              IF cl_null(l_oeb24) THEN LET l_oeb24 = 0 END IF
              IF cl_null(l_oeb12) THEN LET l_oeb12 = 0 END IF
              IF cl_null(l_oeb25) THEN LET l_oeb25 = 0 END IF   #TQC-B50052
              IF cl_null(l_oea09) THEN LET l_oea09 = 0 END IF   #TQC-B50052
              SELECT SUM(sie11) INTO l_sie11 FROM sie_file
               WHERE sie05=l_oeb01 AND sie15=l_oeb03
              IF cl_null(l_sie11) THEN LET l_sie11 = 0 END IF
              IF l_sie11 > 0 THEN  #TQC-B50052
                #IF l_oeb24+l_sie11 > l_oeb12 THEN   #TQC-B50052
                 IF l_oeb24+l_sie11 > (l_oeb12*((100+l_oea09)/100)+l_oeb25) THEN  #TQC-B50052
                    LET g_success = 'N'
                    CALL cl_err('','asf-881',1)
                    IF NOT p_inTransaction THEN  
                       CLOSE t600sub_cl
                       ROLLBACK WORK 
                    END IF 
                    RETURN
                 END IF
              END IF   #TQC-B50052 
            END FOREACH
           #FUN-AC0074--end--add------
         ELSE
            LET l_oga.ogapost='N'
            DELETE FROM imm_file WHERE imm01 = l_oga.oga70
            DELETE FROM imn_file WHERE imn01 = l_oga.oga70
            #FUN-B70074-add-str--
            IF NOT s_industry('std') THEN 
               LET l_flag2 = s_del_imni(l_oga.oga70,'','')
            END IF
            #FUN-B70074-add-end--
            DELETE FROM rvbs_file WHERE rvbs01 = l_oga.oga70   #MOD-AC0060
            LET l_oga.oga70 = ''
            IF l_imm03="A" THEN
               CALL cl_err ("","abm-020",1)
            END IF
         END IF
      #MOD-D10185 add start -----
      ELSE
         LET l_oga.ogapost='Y'
         DECLARE ogb_d CURSOR FOR SELECT * FROM ogb_file WHERE ogb01 = l_oga.oga01
         FOREACH ogb_d INTO l_ogb.*
            SELECT oeb24 INTO l_tot FROM oeb_file
             WHERE oeb01 = l_ogb.ogb31
               AND oeb03 = l_ogb.ogb32
            LET l_tot = l_tot+l_ogb.ogb12

            UPDATE oeb_file SET oeb24=l_tot
             WHERE oeb01 = l_ogb.ogb31
               AND oeb03 = l_ogb.ogb32
         END FOREACH
      END IF
     #MOD-D10185 add start ----
      UPDATE oga_file SET ogapost=l_oga.ogapost,
                          oga70 = l_oga.oga70
       WHERE oga01=l_oga.oga01
      #MOD-B30430 add --start--
      IF NOT p_inTransaction THEN  
         CLOSE t600sub_cl
         COMMIT WORK 
      END IF 
      #MOD-B30430 add --end--
      RETURN
   END IF
 
   IF l_occ57 = 'Y' AND l_oga.oga30 = 'N' AND l_oga.oga09 <> '8' AND l_oga.oga09 <> 'A' THEN   #MOD-9B0149   #MOD-A60150 add oga09 <> 'A'
      #若為出貨通知單製包裝單,則再check一次,避免先轉出貨單再製包裝單無法確認
      IF g_oaz.oaz67 = '1' AND NOT cl_null(l_oga.oga011)  THEN
         LET l_oga30='N'
         SELECT oga30 INTO l_oga30
           FROM oga_file
          WHERE oga01=l_oga.oga011 AND oga09 IN ('1','5')
         IF SQLCA.SQLCODE THEN
            LET l_oga30='N'
         END IF
         IF l_oga30='N' THEN
           #MOD-B30430 mod --start--
           #CALL cl_err(l_oga.oga01,'axm-234',0) LET g_success = 'N' RETURN #CHI-A50004 add LET g_success = 'N'
            CALL cl_err(l_oga.oga01,'axm-234',0)  
            IF NOT p_inTransaction THEN  
               CLOSE t600sub_cl
               ROLLBACK WORK 
            END IF 
            LET g_success = 'N' 
            RETURN 
           #MOD-B30430 mod --end--
         END IF
      ELSE
        #MOD-B30430 mod --start--
        #CALL cl_err(l_oga.oga01,'axm-234',0) LET g_success = 'N' RETURN #CHI-A50004 add LET g_success = 'N'
         CALL cl_err(l_oga.oga01,'axm-234',0) 
         IF NOT p_inTransaction THEN  
            CLOSE t600sub_cl
            ROLLBACK WORK 
         END IF 
         LET g_success = 'N' 
         RETURN 
        #MOD-B30430 mod --end--
      END IF
   END IF
 
   IF NOT cl_null(l_oga.oga910) THEN #FUN-710037
      SELECT imd10,imd11,imd12 INTO l_imd10,l_imd11,l_imd12
        FROM imd_file WHERE imd01=l_oga.oga910 #FUN-710037
      #IF NOT (l_imd11 MATCHES '[Yy]') THEN
      #   CALL cl_err(l_oga.oga910,'axm-993',0) #FUN-710037
         #MOD-B30430 add --start--
      #   IF NOT p_inTransaction THEN  
      #      CLOSE t600sub_cl
      #      ROLLBACK WORK 
      #   END IF 
         #MOD-B30430 add --end--
      #   LET g_success = 'N' #CHI-A50004 add
       #  RETURN
      #END IF
      CASE
         WHEN l_oga.oga00 MATCHES '[37]' #3.出至境外倉;7.寄銷訂單
#           IF NOT (l_imd10 MATCHES '[Ss]') THEN     #MOD-B80197 mark
            IF NOT (l_imd10 MATCHES '[Ww]') THEN     #MOD-B80197
#              CALL cl_err(l_oga.oga910,'axm-063',0) #FUN-710037        #MOD-B80197 mark
               CALL cl_err(l_oga.oga910,'axm-666',0) #MOD-B80197
               #MOD-B30430 add --start--
               IF NOT p_inTransaction THEN  
                  CLOSE t600sub_cl
                  ROLLBACK WORK 
               END IF 
               #MOD-B30430 add --end--
               LET g_success = 'N' #CHI-A50004 add
               RETURN
            END IF
         OTHERWISE
 
      END CASE
      #No.FUN-AA0048  --Begin
      IF NOT s_chk_ware(l_oga.oga910) THEN
         #MOD-B30430 add --start--
         IF NOT p_inTransaction THEN  
            CLOSE t600sub_cl
            ROLLBACK WORK 
         END IF 
         #MOD-B30430 add --end--
         LET g_success = 'N'
         RETURN
      END IF
      #No.FUN-AA0048  --End  
   END IF
 
   IF l_oga.oga909 ='Y' THEN
      CALL t600sub_chkpoz(l_oga.*,NULL) RETURNING li_result,l_poz.*,l_oea99,l_oea904 #FUN-730012 #FUN-730012  kim:因為進去t600sub_chkpoz後,ogb31會再抓一次(確認或過帳段不會沒有單身資料),所以p_ogb31傳任何值都可
     #MOD-B30430 mod --start--
     #IF NOT li_result THEN LET g_success = 'N' RETURN END IF #FUN-730012 #CHI-A50004 add LET g_success = 'N'
      IF NOT li_result THEN 
         IF NOT p_inTransaction THEN  
            CLOSE t600sub_cl
            ROLLBACK WORK 
         END IF 
         LET g_success = 'N' 
         RETURN 
      END IF 
     #MOD-B30430 mod --end--
      #-----MOD-A60153--------->把出貨單拋轉的動作移至過帳後
      ##若銷售多角且正拋，則直接拋轉不扣庫存帳 #CHI-9C0009 應可直接扣庫存帳
      #IF l_argv0 = '4' AND l_poz.poz011 = '1' THEN
      #   IF g_oax.oax07 = 'Y' THEN  #出貨單 #NO.FUN-670007
      #      CALL t600sub_muticarry(l_oga.*,l_poz.*)
      #   ELSE
      #      CALL cl_err('','axm1000',1)       #NO.TQC-740112
      #   END IF
      #END IF                                   #NO.FUN-670007
      #-----END MOD-A60153-----
   END IF
   #LET l_sql = " SELECT ogb12,ogb19,ogb11,ogb01,ogb03 FROM ogb_file ",   #CHI-880006
   LET l_sql = " SELECT ogb12,ogb19,ogb11,ogb01,ogb03,ogb31,ogb32 FROM ogb_file ",   #CHI-880006
               "  WHERE ogb01 = '",l_oga.oga01,"'"
   PREPARE t600_pre1 FROM l_sql
   DECLARE t600_curs1 CURSOR FOR t600_pre1
   #FOREACH t600_curs1 INTO l_ogb12,l_ogb19,l_ogb11,l_qcs01,l_qcs02   #CHI-880006
   FOREACH t600_curs1 INTO l_ogb12,l_ogb19,l_ogb11,l_qcs01,l_qcs02,l_ogb31,m_ogb32   #CHI-880006
      IF g_prog <> 'atmt232' THEN #TQC-640151(1)
         IF l_ogb19 = 'Y' THEN
            LET l_qcs091c = 0
            #-----CHI-880006---------
            IF NOT cl_null(l_oga.oga011) THEN
               #-----MOD-A90084---------
               #SELECT ogb03 INTO l_ogb03
               #  FROM ogb_file
               # WHERE ogb01=l_oga.oga011
               #   AND ogb31=l_ogb31
               #   AND ogb32=m_ogb32
               #SELECT SUM(qcs091) INTO l_qcs091c
               #  FROM qcs_file
               # WHERE qcs01 = l_oga.oga011
               #   AND qcs02 = l_ogb03
               #   AND qcs14 = 'Y'
               SELECT SUM(qcs091) INTO l_qcs091c
                 FROM qcs_file
                WHERE qcs01 = l_oga.oga011
                  AND qcs02 = l_qcs02 
                  AND qcs14 = 'Y'
               #-----END MOD-A90084-----
            END IF
            IF cl_null(l_qcs091c) OR l_qcs091c = 0 THEN
            #-----END CHI-880006-----
               SELECT SUM(qcs091) INTO l_qcs091c
                 FROM qcs_file
                WHERE qcs01 = l_qcs01
                  AND qcs02 = l_qcs02
                  AND qcs14 = 'Y'
            END IF   #CHI-880006
 
            IF l_qcs091c IS NULL THEN
               LET l_qcs091c =0
            END IF
            IF l_argv0<>"8" OR cl_null(l_argv0) THEN #CHI-690055
               IF l_ogb12 > l_qcs091c THEN
                  CALL cl_err(l_ogb11,'mfg3553',1)     #No.MOD-730004 alter mfg3558->mfg3553
                  #MOD-B30430 add --start--
                  IF NOT p_inTransaction THEN  
                     CLOSE t600sub_cl
                     ROLLBACK WORK 
                  END IF 
                  #MOD-B30430 add --end--
                  LET g_success = 'N'                  #No.MOD-730004
                  RETURN
               END IF
            END IF
         END IF
      END IF
   END FOREACH
 
   IF g_aza.aza50='Y' THEN
      SELECT occ1027 INTO l_occ1027 FROM occ_file
       WHERE occ01=l_oga.oga1004
             AND occ1004='1'   #核准的
      IF l_occ1027 ='Y' AND l_oga.oga00='6'  THEN
         CALL cl_err(l_oga.oga1006,'atm-255',1)
         #MOD-B30430 add --start--
         IF NOT p_inTransaction THEN  
            CLOSE t600sub_cl
            ROLLBACK WORK 
         END IF 
         #MOD-B30430 add --end--
         LET g_success='N' #FUN-730012
         RETURN
      END IF
   END IF
 
   IF g_bgjob='N' OR cl_null(g_bgjob) THEN  #FUN-840012
     #MOD-B30430 mod --start--
     #IF p_cmd='2' THEN IF NOT cl_confirm('axm-152') THEN LET g_success = 'N' RETURN END IF END IF #CHI-A50004 add LET g_success = 'N'
      IF p_cmd='2' THEN 
         IF NOT cl_confirm('axm-152') THEN 
            IF NOT p_inTransaction THEN  
               CLOSE t600sub_cl
               ROLLBACK WORK 
            END IF 
            LET g_success = 'N' 
            RETURN 
         END IF 
      END IF 
     #MOD-B30430 mod --end--
   END IF
  #CHI-A50004 程式搬移至FUNCTION一開始 mark --start--
  #IF NOT p_inTransaction THEN   #FUN-730012
  #   BEGIN WORK
  #   LET g_success = 'Y'
  #   LET g_totsuccess = 'Y' #TQC-620156
  #END IF
  #CHI-A50004 程式搬移至FUNCTION一開始 mark --end--

#FUN-BC0071 -----------------STA
#   CALL t600_upd_lqe(l_oga.*)            #TQC-C30097 mark
   IF g_success = 'Y' THEN
     CALL t600_ins_lsn(l_oga.*)
   END IF
   IF g_success = 'N' THEN
      IF NOT p_inTransaction THEN
         CLOSE t600sub_cl
         ROLLBACK WORK
      END IF
      RETURN
   END IF
#FUN-BC0071 -----------------END 

   LET l_flag = '0'    #MOD-940273
   IF p_Input_oga02 THEN
      INPUT l_oga02 WITHOUT DEFAULTS FROM oga02
 
         BEFORE INPUT
            LET l_flag = '1'   #MOD-940273
            LET l_oga02 = l_oga.oga02
            DISPLAY l_oga02 TO oga02
 
         AFTER FIELD oga02
            IF NOT cl_null(l_oga02) THEN
               #IF g_prog = 'axmt628'  THEN #CHI-A30017 add  #FUN-B40066 mark
               IF g_prog[1,7] = 'axmt628'  THEN   #FUN-B40066 
                  IF l_oga02 < l_oga.oga69 THEN
                     LET l_oga02=l_oga.oga02
                     CALL cl_err('','axm-924',1)   #出貨日期不可小於輸入日期!!!
                     DISPLAY l_oga02 TO oga02
                     NEXT FIELD oga02
                  END IF
               END IF #CHI-A30017 add
               IF l_oga02 <= g_oaz.oaz09 THEN
                  CALL cl_err('','axm-164',0) NEXT FIELD oga02
               END IF
               #MOD-B50047 add --start--
               DECLARE t600_oga02 CURSOR FOR
                  SELECT ogb31
                    FROM ogb_file
                   WHERE  ogb01=l_oga.oga01
               FOREACH t600_oga02 INTO l_ogb31
                  IF NOT cl_null(l_ogb31) THEN
                     SELECT oea02 INTO l_oea02 FROM oea_file
                      WHERE oea01=l_ogb31
                     IF l_oga02 < l_oea02 THEN
                        CALL cl_err('','axm-385',0) 
                        NEXT FIELD oga02
                     END IF
                  END IF
               END FOREACH
               #MOD-B50047 add --end--
	       IF g_oaz.oaz03 = 'Y' AND
	          g_sma.sma53 IS NOT NULL AND l_oga02 <= g_sma.sma53 THEN
	          CALL cl_err('','mfg9999',0) NEXT FIELD oga02
	       END IF
               CALL s_yp(l_oga02) RETURNING l_yy,l_mm
               IF l_argv0='1' OR l_argv0='5' THEN #No.9304
                  IF ((l_yy*12+l_mm) - (g_sma.sma51*12+g_sma.sma52) >1) THEN
                     CALL cl_err('','mfg6090',0)
                     NEXT FIELD oga02
                  END IF
               ELSE
                  IF ((l_yy*12+l_mm) > (g_sma.sma51*12+g_sma.sma52)) THEN
                      CALL cl_err('','mfg6090',0)
                      NEXT FIELD oga02
                  END IF
               END IF
            END IF
 
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
         IF NOT p_inTransaction THEN
            LET g_success='N'
            LET g_totsuccess='N'
            CLOSE t600sub_cl #MOD-B30430 add
            ROLLBACK WORK
         END IF
         RETURN
      END IF
   ##當不輸入扣帳日期時,預設今日為扣帳日(WHEN背景執行或外部呼叫時)
   ELSE
      IF l_oga.oga02 IS NULL OR l_oga.oga02=0 THEN
         LET l_oga.oga02=g_today
      END IF
      LET l_oga02 = l_oga.oga02

     #FUN-970017---add----str---
     #由EasyFlow按"准",出貨日期改為g_today
      IF l_agree = 'Y' THEN
         LET l_oga02 = g_today
      END IF
     #FUN-970017---add----end---
   END IF
 
  #CHI-A50004 程式搬移至FUNCTION一開始 mark --start--
  #CALL t600sub_lock_cl()
  #OPEN t600sub_cl USING l_oga.oga01
  #IF STATUS THEN
  #   CALL cl_err("OPEN t600sub_cl:", STATUS, 1)
  #   CLOSE t600sub_cl
  #   LET g_success = 'N'   #TQC-930155 add
  #   RETURN
  #END IF
  # 
  #FETCH t600sub_cl INTO l_oga.*          # 鎖住將被更改或取消的資料
  #IF SQLCA.sqlcode THEN
  #    CALL cl_err(l_oga.oga01,SQLCA.sqlcode,0)     # 資料被他人LOCK
  #    CLOSE t600sub_cl
  #    LET g_success = 'N'   #TQC-930155 add
  #    RETURN
  #END IF
  #CHI-A50004 程式搬移至FUNCTION一開始 mark --end--
   IF l_flag = '1' THEN   #MOD-940273
      LET l_oga.oga02=l_oga02   #FUN-650009 add
   END IF   #MOD-940273
   UPDATE oga_file SET oga02=l_oga.oga02 WHERE oga01=l_oga.oga01   #FUN-650009 add
   #當帳款無法產生,此筆出貨單不可過帳-----#
     UPDATE oga_file SET ogapost='Y' WHERE oga01=l_oga.oga01
   IF NOT cl_null(l_oga.oga011) AND l_oga.oga09 <> '8' THEN #通知單號  #MOD-7A0177 不回寫產簽收單的出貨單
      UPDATE oga_file SET oga02=l_oga.oga02,ogapost='Y' WHERE oga01=l_oga.oga011   #FUN-650009 add
   END IF
   LET l_oga.ogapost='Y'
   #判斷單身料件的料件主檔資料ima_file，如果該料件的ima1012為空,則更新
   #出貨日期oga02至ima1012,否則不更新.
   DECLARE t600_ima1012 CURSOR FOR
      SELECT ima01,ima1012
        FROM ogb_file,ima_file
       WHERE  ogb01=l_oga.oga01 AND ogb04=ima01
 
   FOREACH t600_ima1012 INTO l_ima01,l_ima1012
      IF STATUS THEN
         LET g_success = 'N'    #TQC-930155 add
         EXIT FOREACH
      END IF
      IF cl_null(l_ima1012) THEN
         UPDATE ima_file
            SET ima1012=l_oga.oga69,  #FUN-650009
                imadate=g_today       #FUN-D10063 add 
          WHERE ima01=l_ima01
      ELSE
         CONTINUE FOREACH
      END IF
   END FOREACH
   LET  p_success1='Y'                    #No.TQC-7C0114
   #TQC-D30044--mark--str--
   #LET l_flag1='N'
   #IF l_argv0='4' AND l_poz.poz00='1' AND l_poz.poz011='1'
   #               AND g_sma.sma894[2,2]='N' THEN
   #   LET g_sma.sma894[2,2] = 'Y'
   #   LET l_flag1='Y'
   #END IF
    CALL t600sub_s1(l_oga.*,p_cmd) RETURNING l_oha.* #FUN-9C0083  #TQC-D30060 remark
   #IF l_flag1='Y' THEN
   #   LET g_sma.sma894[2,2] = 'N'
   #END IF
   #IF sqlca.sqlcode THEN LET g_success='N' END IF
   #TQC-D30044--mark--str--
 
   IF s_industry('icd') THEN
       CALL t600sub_ind_icd_post(l_oga.oga01,'1')
   END IF
     
   #FUN-AC0074--begin--add----
   DECLARE t600sub_sie_c CURSOR FOR 
     SELECT DISTINCT ogb31,ogb32 FROM ogb_file,sie_file  #TQC-B50052 add sie_file
      WHERE ogb01=l_oga.oga01
        AND ogb31=sie05 AND ogb32=sie15 AND sie11 > 0    #TQC-B50052
   FOREACH t600sub_sie_c INTO l_oeb01,l_oeb03
      SELECT oeb24,oeb12,oeb25,oea09 INTO l_oeb24,l_oeb12,l_oeb25,l_oea09 FROM oeb_file,oea_file #TQC-B50052
       WHERE oeb01=l_oeb01 AND oeb03=l_oeb03 AND oea01=oeb01  #TQC-B50052
      IF cl_null(l_oeb24) THEN LET l_oeb24 = 0 END IF
      IF cl_null(l_oeb12) THEN LET l_oeb12 = 0 END IF
      IF cl_null(l_oeb25) THEN LET l_oeb25 = 0 END IF   #TQC-B50052
      IF cl_null(l_oea09) THEN LET l_oea09 = 0 END IF   #TQC-B50052
      SELECT SUM(sie11) INTO l_sie11 FROM sie_file
       WHERE sie05=l_oeb01 AND sie15=l_oeb03
      IF cl_null(l_sie11) THEN LET l_sie11 = 0 END IF
      IF l_sie11 > 0 THEN  #TQC-B50052
        #IF l_oeb24+l_sie11 > l_oeb12 THEN  #TQC-B50052
         IF l_oeb24+l_sie11 > (l_oeb12*((100+l_oea09)/100)+l_oeb25) THEN  #TQC-B50052
            LET g_success = 'N'
            LET g_showmsg = l_oeb01,"/",l_oeb03
            CALL cl_err(g_showmsg,'asf-881',1)
            EXIT FOREACH
         END IF
      END IF  #TQC-B50052
   END FOREACH
   ##FUN-AC0074--end--add------
    #需帶入流程序號
    IF (l_poz.poz19='Y' AND l_poz.poz18=g_plant) THEN
        LET l_sql= " SELECT oea99,ogb32 FROM oea_file,ogb_file ",  #MOD-830222 modify ogb31
                   "  WHERE oea01 = ogb31 ",
                   "    AND ogb01 = '",l_oga.oga01,"'",
                   "    AND oeaconf = 'Y' ",
                   "  ORDER BY ogb03"
        PREPARE oea_pre1 FROM l_sql
        DECLARE oea_f1 CURSOR FOR oea_pre1
        FOREACH oea_f1 INTO l_oea99,m_ogb32  #MOD-820037  #MOD-830222 modify
         IF STATUS THEN
            CALL cl_err('fetch oea99',STATUS,1)
            LET g_success = 'N'   #MOD-820037 add
         END IF
         EXIT FOREACH   #MOD-820037 add
        END FOREACH     #MOD-820037 add
        #考慮會有分批出貨中斷點問題,如此rva99會有多筆
         LET l_sql= " SELECT rva99 ",  
                    "   FROM rva_file,rvb_file,pmm_file ",
                    "  WHERE pmm01 = rvb04 ",
                    "    AND rvb01 = rva01 ",
                    "    AND rvb03 = '",m_ogb32,"' ",   #MOD-830222 add
                    "    AND pmm99 = '",l_oea99,"'",   
                    "   ORDER BY rva99 "
        PREPARE rva_pre1 FROM l_sql
        DECLARE rva_f1 CURSOR FOR rva_pre1
        FOREACH rva_f1 INTO l_oga.oga99
         IF STATUS THEN
            CALL cl_err('fetch rva99',STATUS,1)
            LET g_success = 'N'   
         END IF
         LET l_j = 0
         SELECT COUNT(*) INTO l_j FROM oga_file
          WHERE oga99 = l_oga.oga99
            AND (oga09 = '4' OR oga09 = '6' )
         IF l_j =  0 THEN
            EXIT FOREACH       #中斷後尚未有出貨單
         ELSE
            CONTINUE FOREACH   #中斷後已有出貨單
         END IF 
        END FOREACH  
         LET l_oga.oga905='Y'
         UPDATE oga_file
            SET oga99 =l_oga.oga99,
                oga905=l_oga.oga905
         WHERE oga01=l_oga.oga01
         IF STATUS OR sqlca.sqlerrd[3]=0 THEN
            CALL cl_err('update oga99',STATUS,1)
            LET g_success = 'N'
         END IF
    END IF

    CALL s_showmsg()  #MOD-C30250 add  清空錯誤信息前，先進行顯示
 
  #FUN-B40098 Begin---
   IF g_azw.azw04 = '2' AND g_success = 'Y' THEN
      CALL s_showmsg_init()
      CALL t620sub1_post('1',l_oga.oga01)
      CALL s_showmsg()
   END IF
  #FUN-B40098 End-----

   CALL t600sub_add_deduct(l_oga.oga01)    #FUN-BC0064  add
#  #FUN-C50136--add--str--
#  IF g_oaz.oaz96 ='Y' THEN 
#     LET g_act = 'S' 
#     CALL t600sub_hu1(l_oga.*)
#  END IF
#  #FUN-C50136--add--end--
   IF g_success = 'Y' AND p_success1='Y' THEN  #No.TQC-7C0114
      IF NOT p_inTransaction THEN   #CHI-B80001 add
         COMMIT WORK
      END IF                        #CHI-B80001 add
      CALL cl_flow_notify(l_oga.oga01,'S')
      DISPLAY BY NAME l_oga.ogapost
      #顯示代送信息
      IF l_oga.oga00 = '6' THEN
         CALL cl_err(l_oha.oha01,'atm-393',0)
         SELECT oga1012,oga1014 INTO l_oga.oga1012,l_oga.oga1014
           FROM oga_file
          WHERE oga01 = l_oga.oga01
         DISPLAY BY NAME l_oga.oga1012
         DISPLAY BY NAME l_oga.oga1014
      END IF
   ELSE
      IF NOT p_inTransaction THEN   #MOD-C70014 add 
         ROLLBACK WORK
      END IF                        #MOD-C70014 add
      LET l_oga.ogapost='N'
   END IF
   #-----MOD-A60153--------->把出貨單拋轉的動作移至過帳後
   IF l_argv0 = '4' AND l_poz.poz011 = '1' THEN
      IF g_oax.oax07 = 'Y' THEN  
         CALL t600sub_muticarry(l_oga.*,l_poz.*)
      ELSE
         CALL cl_err('','axm1000',1)     
      END IF
   END IF                                  
   #----- END MOD-A60153-----
  #MOD-B30430 mod --start--
  #IF l_argv0 = '4' AND l_poz.poz011 = '1' THEN    RETURN   END IF             #CHI-9C0009  
   IF l_argv0 = '4' AND l_poz.poz011 = '1' THEN   
      IF NOT p_inTransaction THEN  
         CLOSE t600sub_cl
         ROLLBACK WORK 
      END IF 
      RETURN   
   END IF    
  #MOD-B30430 mod --end--
   #在判斷拆併箱之前先存舊值,因拆併箱也用此變數
    LET l_success = g_success
 
#應收處理
   IF g_success ='Y' AND g_oaz.oaz63='Y' AND l_oha.oha09='1' THEN
      LET l_t1=l_oha.oha01
      LET l_t1=l_t1[1,g_doc_len]
      SELECT oay11 INTO l_oay11 FROM oay_file
       WHERE oayslip =l_t1
      IF l_oay11 ='Y' THEN
         CALL t600sub_ar(l_oha.*)   #銷退轉應收
      END IF
   END IF
   LET l_t1=s_get_doc_no(l_oga.oga01)       #No.FUN-550052
   SELECT oay11 INTO l_oay11 FROM oay_file WHERE oayslip=l_t1
 
 
   #IF g_success = 'Y' AND g_oaz.oaz62='Y' AND l_oga.oga08='1'              #MOD-C30792 mark
   IF g_success = 'Y' AND g_oaz.oaz62='Y' AND (l_oga.oga08='1'              #MOD-C30792 add
      OR (g_ooz.ooz64 = 'Y' AND l_oga.oga08 = '2' AND g_aza.aza26 = '0'))   #MOD-C30792 add
      AND l_oay11 = 'Y' AND l_oga.oga00 NOT MATCHES '[237]' THEN  #No:7664
     #FUN-970017 ----add--- if 判斷
     #當l_agree = 'Y'代表,走EasyFlow,同時具有自動確認和簽核的功能
     #所以當l_agree = 'N'時才能做交談畫面axrp310
      IF l_agree = 'N' THEN
         #CALL t600sub_gui(l_oga.*) #MOD-CA0131 add mark
#----------#MOD-CA0131 add begin #判断此时能否call cl_cmdrun_wait
         IF NOT p_inTransaction THEN
         	  CALL t600sub_gui(l_oga.*) #MOD-CA0131 add
         ELSE 
            LET g_inTransaction = 'Y'
         END IF
#----------# MOD-CA0131 add end          
      END IF
     #FUN-970017 ----end---
   END IF

#FUN-C40072---add---START
   #由簽收單串回出貨單判斷是否為多角
   LET l_oga09 = ' '
   SELECT oga09 INTO l_oga09 FROM oga_file
     WHERE oga01 = l_oga.oga011
#FUN-C40072---add-----END
 
   #No.7992 多角貿易自動拋轉
  #IF g_success = 'Y' AND l_argv0 MATCHES '[46]' THEN  #FUN-C40072 mark
   IF g_success = 'Y' AND l_argv0 MATCHES '[468]' THEN #FUN-C40072 add 8:客戶簽收單
    IF (l_poz.poz19='Y' AND l_poz.poz18=g_plant) THEN
        #設中斷點時,不執行拋轉作業
    ELSE
      CASE
         #WHEN l_argv0 = '4'                                                   #FUN-C40072 mark
         #WHEN l_argv0 MATCHES '[48]' AND l_oga.oga65 = 'N' AND l_oga09 = '4'  #FUN-C40072 add 8:客戶簽收單,l_oga09  #MOD-CB0214 mark
          WHEN (l_argv0 ='4' AND l_oga.oga65 = 'N') OR (l_argv0 ='8' AND l_oga.oga65 = 'N' AND l_oga09 = '4') #MOD-CB0214 add
             IF g_oax.oax07 = 'Y' THEN
                  CALL t600sub_muticarry(l_oga.*,l_poz.*)
                  #MOD-B30464 mark --start--
                  #SELECT oga905 INTO l_oga.oga905 FROM oga_file WHERE oga01 = p_oga01
                  #IF l_oga.oga905 <> 'Y' THEN
                  #   CALL t600_z('y')  #扣帳時,拋轉失敗要還原扣帳
                  #END IF 
                  #MOD-B30464 mark --end--
              ELSE
                  CALL cl_err('','axm1000',1)       #NO.TQC-740112
              END IF
          WHEN l_argv0 = '6'
              IF g_pod.pod05 = 'Y' THEN
                  CALL t600sub_muticarry(l_oga.*,l_poz.*)
                  #MOD-B30464 mark --start--
                  #SELECT oga905 INTO l_oga.oga905 FROM oga_file WHERE oga01 = p_oga01
                  #IF l_oga.oga905 <> 'Y' THEN
                  #   CALL t600_z('y')  #扣帳時,拋轉失敗要還原扣帳
                  #END IF 
                  #MOD-B30464 mark --end--
              ELSE
                  CALL cl_err('','axm1000',1)    #NO.TQC-740112
              END IF
      END CASE
    END IF  #CHI-7B0041- add
   END IF
 
   #DEV-D40016--add---str---
   IF g_success = 'Y' THEN
       IF g_aza.aza131 = 'Y' AND (l_oga.oga09 = '2' OR l_oga.oga09 = '3') THEN #2:一般出貨單 3:無訂單出貨單
           CALL s_ibj_ins_tlfb('abat163',l_oga.oga011,l_oga.oga01)
       END IF
   END IF
   #DEV-D40016--add---end---

   IF l_oga.ogapost = "N" THEN
 
      LET l_imm01 = ""
      LET g_success = "Y"
      LET g_totsuccess = "Y"   #MOD-9C0439
 
 
      BEGIN WORK
 
      IF g_sma.sma115 = 'Y' THEN
         DECLARE t600sub_s1_c2 CURSOR FOR SELECT * FROM ogb_file
           WHERE ogb01 = l_oga.oga01
         FOREACH t600sub_s1_c2 INTO l_ogb.*
            IF STATUS THEN
               EXIT FOREACH
            END IF
 
            SELECT ima906 INTO l_ima906 FROM ima_file  #FUN-730012
             WHERE ima01=l_ogb.ogb04                   #FUN-730012
            IF l_ima906 = '2' THEN  #子母單位          #FUN-730012
               LET l_unit_arr[1].unit= l_ogb.ogb910
               LET l_unit_arr[1].fac = l_ogb.ogb911
               LET l_unit_arr[1].qty = l_ogb.ogb912
               LET l_unit_arr[2].unit= l_ogb.ogb913
               LET l_unit_arr[2].fac = l_ogb.ogb914
               LET l_unit_arr[2].qty = l_ogb.ogb915
               CALL s_dismantle(l_oga.oga01,l_ogb.ogb03,l_oga.oga02,
                                l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,
                                l_ogb.ogb092,l_unit_arr,l_imm01)
                      RETURNING l_imm01
               IF g_success='N' THEN    #No.FUN-6C0083
                  LET g_totsuccess='N'
                  LET g_success="Y"
                  CONTINUE FOREACH
               END IF
            END IF
         END FOREACH
      END IF
 
      IF g_totsuccess="N" THEN    #TQC-620156
         LET g_success="N"
      END IF
 
      IF g_success = "Y" AND NOT cl_null(l_imm01) THEN
         COMMIT WORK
         LET l_msg="aimt324 '",l_imm01,"'"
         CALL cl_cmdrun_wait(l_msg)
      ELSE
         ROLLBACK WORK
      END IF
   END IF
   CALL s_showmsg()   #MOD-860304
 
   #在判斷拆併箱之後還原舊值,因拆併箱也用此變數
    LET g_success = l_success
 
END FUNCTION
 
FUNCTION t600sub_s1(l_oga,p_cmd) #FUN-9C0083
  DEFINE p_cmd LIKE type_file.chr1 #FUN-9C0083
  DEFINE l_ogc    RECORD LIKE ogc_file.*
  DEFINE l_ogc_1  RECORD LIKE ogc_file.*         #CHI-B30093  #CHI-B60054 mark CHI-B30093 内容  #FUN-C30289
  DEFINE l_oeb19  LIKE oeb_file.oeb19
  DEFINE l_oeb905 LIKE oeb_file.oeb905
  DEFINE l_flag   LIKE type_file.chr1     #No:8741  #No.FUN-680137 VARCHAR(1)
  DEFINE l_ogg    RECORD LIKE ogg_file.*
  DEFINE l_ima906 LIKE ima_file.ima906
  DEFINE l_ima25  LIKE ima_file.ima25
  DEFINE l_ima71  LIKE ima_file.ima71
  DEFINE l_fac1,l_fac2 LIKE ogb_file.ogb15_fac
  DEFINE l_cnt    LIKE type_file.num5                                                          #No.FUN-680137 SMALLINT
  DEFINE l_occ31  LIKE occ_file.occ31
  DEFINE l_tuq06  LIKE tuq_file.tuq06   #FUN-630102 modify adq->tuq
  DEFINE l_tuq07  LIKE tuq_file.tuq07   #FUN-630102 modify adq->tuq
  DEFINE l_desc   LIKE type_file.chr1    #No.FUN-680137 VARCHAR(01)
  DEFINE l_t      LIKE oay_file.oayslip  #No.FUN-680137 VARCHAR(05)   #No.FUN-610064
  DEFINE l_oha53  LIKE oha_file.oha53     #No.FUN-610064
  DEFINE l_oha50  LIKE oha_file.oha50     #No.FUN-670008
  DEFINE l_oayauno LIKE oay_file.oayauno     #No.FUN-610064
  DEFINE l_oay17  LIKE oay_file.oay17     #No.FUN-610064
  DEFINE l_oay18  LIKE oay_file.oay18     #No.FUN-610064
  DEFINE l_oay20  LIKE oay_file.oay20     #No.FUN-610064
  DEFINE li_result LIKE type_file.num5                 #No.FUN-610064  #No.FUN-680137 SMALLINT
  DEFINE p_success LIKE type_file.chr1    #No.FUN-680137 VARCHAR(01)     #No.FUN-610064
  DEFINE l_unit   LIKE ogb_file.ogb05     #No.FUN-610064
  DEFINE l_oha01  LIKE oha_file.oha01     #No.FUN-610064
  DEFINE l_occ02  LIKE occ_file.occ02     #No.FUN-610064
  DEFINE l_occ1006 LIKE occ_file.occ1006  #No.FUN-610064
  DEFINE l_occ1017 LIKE occ_file.occ1017  #No.FUN-610064
  DEFINE l_occ09   LIKE occ_file.occ09    #No.FUN-610064
  DEFINE l_occ1005 LIKE occ_file.occ1005  #No.FUN-610064
  DEFINE l_occ1022 LIKE occ_file.occ1022  #No.FUN-610064
  DEFINE l_occ07   LIKE occ_file.occ07    #No.TQC-640123
  DEFINE l_occ1024 LIKE occ_file.occ1024  #No.FUN-610064
  DEFINE l_ohb03   LIKE ohb_file.ohb03    #No.FUN-610064
  DEFINE l_ohb13   LIKE ohb_file.ohb13    #No.FUN-610064
  DEFINE l_ohb13t  LIKE ohb_file.ohb13    #No.FUN-610064
  DEFINE l_ohb14   LIKE ohb_file.ohb14    #No.FUN-610064
  DEFINE l_ohb14t  LIKE ohb_file.ohb14    #No.FUN-610064
  DEFINE l_ohb1001 LIKE ohb_file.ohb1001  #No.FUN-610064
  DEFINE l_qty     LIKE ogb_file.ogb12    #No.TQC-640123
  DEFINE l_oayapr  LIKE oay_file.oayapr   #FUN-710037
  DEFINE l_argv0   LIKE ogb_file.ogb09
  DEFINE l_oga     RECORD LIKE oga_file.*
  DEFINE l_ogb     RECORD LIKE ogb_file.*
  DEFINE l_ogb12   LIKE ogb_file.ogb12 ,
         l_ogb912  LIKE ogb_file.ogb912,
         l_ogb915  LIKE ogb_file.ogb915,
         l_ogb917  LIKE ogb_file.ogb917
  DEFINE l_msg     STRING
  DEFINE l_oha     RECORD LIKE oha_file.*
  DEFINE l_ohb     RECORD LIKE ohb_file.*
  DEFINE l_tot1    LIKE ogc_file.ogc12
  DEFINE l_msg3    STRING        #No.TQC-7C0114
  DEFINE l_oah03   LIKE type_file.chr1   #FUN-820060
  DEFINE l_ima131  LIKE type_file.chr20  #FUN-820060
  DEFINE l_img18   LIKE img_file.img18    #CHI-A40029 add
  #DEFINE l_item    LIKE tqy_file.tqy35    #CHI-A40029 add   #MOD-A70017
  DEFINE l_item    LIKE ogc_file.ogc17    #MOD-A70017
  DEFINE l_ogb12_t LIKE ogb_file.ogb12  #CHI-AC0034 add
  DEFINE l_oga01   LIKE oga_file.oga01  #CHI-AC0034 add
  DEFINE l_ogc12   LIKE ogc_file.ogc12  #CHI-AC0034 add
  DEFINE l_img09   LIKE img_file.img09  #CHI-AC0034 add
  DEFINE l_tup06   LIKE tup_file.tup06  #MOD-B30651 add
  DEFINE l_ohbi   RECORD LIKE ohbi_file.* #FUN-B70074 add
  DEFINE l_idb    RECORD LIKE idb_file.*  #FUN-B40066
  DEFINE l_ogbi   RECORD LIKE ogbi_file.* #FUN-B40066 
#####
#FUN-910088--add--start--
  DEFINE l_tup05_1 LIKE tup_file.tup05,
         l_tuq07_1 LIKE tuq_file.tuq07,
         l_tuq09_1 LIKE tuq_file.tuq09
#FUN-910088--add--end--
  DEFINE l_rtz08       LIKE rtz_file.rtz08 #FUN-B80189 Add
  DEFINE l_factor  LIKE type_file.num26_10     #FUN-C50097
  DEFINE l_ogb2  DYNAMIC ARRAY OF RECORD       #FUN-C50097
                 ogb01   LIKE ogb_file.ogb01,
                 ogb03   LIKE ogb_file.ogb03,
                 ogb12   LIKE ogb_file.ogb12
                              END RECORD,
         l_ac      LIKE type_file.num5,   #FUN-C50097
         l_ogb50   LIKE ogb_file.ogb50,    #FUN-C50097   TQC-C70206              
         l_ogg12   LIKE ogg_file.ogg12,     #FUN-C50097 
         l_ogb12_t1 LIKE ogb_file.ogb12,
         l_ogb12_t2 LIKE ogb_file.ogb12,
         l_tot2    LIKE ogc_file.ogc12
 #DEFINE l_oga01_1  LIKE oga_file.oga01     #TQC-C70056 add#TQC-C70056 mark by xuxz
   DEFINE l_cnt2         LIKE type_file.num5  #MOD-CB0050

   CALL s_showmsg_init()   #No.FUN-6C0083
   LET l_argv0=l_oga.oga09  #FUN-730012
   INITIALIZE l_oha.* TO NULL #FUN-730012
   
   #INITIALIZE l_ogc_1.* TO NULL                #CHI-B30093  #CHI-B60054 mark CHI-B30093 
   
#判斷單頭出貨類型是否為代送，如果是，則必須生成一筆代送商的銷退單
   IF l_oga.oga00 = '6' THEN
      INITIALIZE l_oha.* TO NULL
      LET l_oha53=0
      ##產生銷退單別
      LET l_t = l_oga.oga01[1,g_doc_len]
      SELECT oayauno,oay17,oay18,oay20,oayapr
        INTO l_oayauno,l_oay17,l_oay18,l_oay20,l_oayapr #FUN-710037
        FROM oay_file
       WHERE oayslip = l_t
      IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","oay_file",l_t,"","atm-394","","",1)  #No.FUN-670008
         LET g_success = 'N'
         RETURN l_oha.*
      END IF
      CALL s_auto_assign_no("axm",l_oay17,l_oga.oga02,"","oha_file","oha01","","","")
               RETURNING li_result,l_oha01
      IF (NOT li_result) THEN
         CALL cl_err('','mfg3326',1)
         LET g_success = 'N'
         RETURN l_oha.*
      END IF
      LET l_oha.oha01 = l_oha01
 
      ##帳款客戶簡稱
      SELECT occ1006,occ1005,occ07,occ09,occ1022,occ1024              #No.TQC-640123
        INTO l_occ1006,l_occ1005,l_occ07,l_occ09,l_occ1022,l_occ1024  #No.TQC-640123
        FROM occ_file
       WHERE occ01=l_oga.oga1004
#根據 l_occ07取得代送商帳款客戶簡稱
      SELECT occ02 into l_occ02 FROM occ_file WHERE occ01=l_oga.oga1004   #TQC-640123
 
#給銷退單單頭各欄位賦值:
      LET l_oha.oha01 = l_oha01                  #銷退單號
      LET l_oha.oha02 = l_oga.oga02              #銷退日期
      LET l_oha.oha03 = l_oga.oga1004            #客戶編號   #TQC-640123
      LET l_oha.oha032=l_occ02                   #帳款客戶簡稱 #TQC-640123 #No.MOD-7B0198
      LET l_oha.oha1009=l_occ1006                #渠道
      LET l_oha.oha04=l_occ09                  #退貨客戶
      LET l_oha.oha1011=l_occ1022                #發票客戶
      LET l_oha.oha1001=l_occ07                  #收款客戶  TQC-640123
      LET l_oha.oha1003=l_occ1024                #業績歸屬方
      LET l_oha.oha1010=l_occ1005                #客戶所屬方
      LET l_oha.oha1017='0'                      #導物流狀況碼
      LET l_oha.oha1005 = 'Y'                    #是否計算業績
      LET l_oha.oha05 ='1'                       #單據別
      LET l_oha.oha08 ='1'                       #內銷、外銷
      LET l_oha.oha09 ='1'                       #銷退處理方式
      LET l_oha.oha14 =l_oga.oga14               #人員編號
      LET l_oha.oha15 =l_oga.oga15               #部門編號
      LET l_oha.oha21 =l_oga.oga21               #稅種
      LET l_oha.oha211=l_oga.oga211              #稅率
      LET l_oha.oha212=l_oga.oga212              #聯數
      LET l_oha.oha213=l_oga.oga213              #含稅否
      LET l_oha.oha23 =l_oga.oga23               #幣種
      LET l_oha.oha24 =l_oga.oga24               #匯率
      LET l_oha.oha25 =l_oga.oga25               #銷售分類一
      LET l_oha.oha26 =l_oga.oga26               #銷售分類二
      LET l_oha.oha31 =l_oga.oga31               #價格條件
      LET l_oha.oha41 ='N'                       #三角貿易銷退單否
      LET l_oha.oha42 ='N'                       #是否入庫存
      LET l_oha.oha43 ='N'                       #起始三角貿易銷退單否
      LET l_oha.oha44 ='N'                       #拋轉否
      LET l_oha.oha1018 =l_oga.oga01             #代送出貨單號
      LET l_oha.oha50 =0                         #原幣銷退總稅前金額
      LET l_oha.oha53 =l_oha53                   #原幣銷退應開折讓稅前金額
      LET l_oha.oha54 =0                         #原幣銷退已開折讓稅前金額
      LET l_oha.oha55 ='1'                       #狀況碼
      LET l_oha.ohaconf ='Y'                     #審核否
      LET l_oha.ohapost ='Y'                     #庫存過賬否
      LET l_oha.ohauser =l_oga.ogauser           #資料所有者
      LET l_oha.ohagrup =l_oga.ogagrup           #資料所有部門
      LET l_oha.ohadate =g_today                 #最近更改日
      LET l_oha.oha1002 = l_oay20                #債權
      LET l_oha.oha1004 = l_oay18              #退貨原因碼
      LET l_oha.oha1006 = 0                    #折扣金額(未稅)
      LET l_oha.oha1007 = 0                    #折扣金額(含稅)
      LET l_oha.oha1008 = 0                    #銷退單總含稅金額
      LET l_oha.oha1015 = 'Y'                  #代送出貨自動生成否
 
      LET l_oha.ohaplant = l_oga.ogaplant
      LET l_oha.ohalegal = l_oga.ogalegal
      IF g_azw.azw04 = '2' THEN
         LET l_oha.oha85 = l_oga.oga85
         LET l_oha.oha86 = l_oga.oga86       
         LET l_oha.oha87 = l_oga.oga87                                                                                              
         LET l_oha.oha88 = l_oga.oga88 
         LET l_oha.oha89 = l_oga.oga89                                                                                              
         LET l_oha.oha90 = l_oga.oga90                                                                                              
         LET l_oha.oha91 = l_oga.oga91                                                                                              
         LET l_oha.oha92 = l_oga.oga92   
         LET l_oha.oha93 = l_oga.oga93                                                                                              
         LET l_oha.oha94 = l_oga.oga94                                                                                              
         LET l_oha.oha95 = l_oga.oga95                                                                                              
         LET l_oha.oha96 = l_oga.oga96                                                                                              
         LET l_oha.oha97 = l_oga.oga97                                                                                              
      ELSE
         LET l_oha.oha85=' '
         LET l_oha.oha94='N'
      END IF
 
      IF cl_null(l_oayapr) THEN
         LET l_oha.ohamksg='N'
      END IF
 
      LET l_oha.ohaplant = g_plant 
      LET l_oha.ohalegal = g_legal 
 
      LET l_oha.ohaoriu = g_user      #No.FUN-980030 10/01/04
      LET l_oha.ohaorig = g_grup      #No.FUN-980030 10/01/04
      IF cl_null(l_oha.oha57) THEN LET l_oha.oha57 = '1' END IF #FUN-AC0055 add
      INSERT INTO oha_file VALUES(l_oha.*)
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","oha_file",l_oha.oha01,"",SQLCA.sqlcode,"","",1)  #No.FUN-670008
         LET g_success = 'N'
         RETURN l_oha.*
      END IF
      #更新oga1012=銷退單,oga1014='N'
      UPDATE oga_file SET oga1012 = l_oha.oha01,oga1014='N'
       WHERE oga01 = l_oga.oga01
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","oga_file",l_oga.oga01,"",SQLCA.sqlcode,"","",1)
         LET g_success = 'N'
         RETURN l_oha.*
      END IF
 
   END IF
 #TQC-B10066 Begin---
 #DECLARE t600_s1_c CURSOR FOR SELECT * FROM ogb_file WHERE ogb01=l_oga.oga01 AND ogb1005 = '1' #No.FUN-610064
  DECLARE t600_s1_c CURSOR FOR
   SELECT * FROM ogb_file
    WHERE ogb01=l_oga.oga01
      AND (ogb1005 = '1' OR (ogb1005='2' AND ogb03<9001))
 #TQC-B10066 End-----
  FOREACH t600_s1_c INTO l_ogb.*
      IF STATUS THEN EXIT FOREACH END IF
#MOD-B80054 -- begin --
      IF cl_null(l_ogb.ogb09) THEN LET l_ogb.ogb09 = ' ' END IF
      IF cl_null(l_ogb.ogb091) THEN LET l_ogb.ogb091 = ' ' END IF
      IF cl_null(l_ogb.ogb092) THEN LET l_ogb.ogb092 = ' ' END IF
#MOD-B80054 -- end -- 

    #CHI-A40029 add --start--
      IF l_ogb.ogb04 NOT MATCHES 'MISC*' AND l_oga.oga09 MATCHES '[2468]' THEN
         IF l_ogb.ogb17='Y' THEN   #多倉儲
            DECLARE chk_ogc2 CURSOR FOR
               SELECT *
                 FROM ogc_file
                WHERE ogc01 = l_ogb.ogb01
                  AND ogc03 = l_ogb.ogb03
            FOREACH chk_ogc2 INTO l_ogc.*
               IF SQLCA.SQLCODE <>0 THEN EXIT FOREACH END IF
               LET l_cnt=0
               IF g_oaz.oaz23 = 'Y' AND NOT cl_null(l_ogc.ogc17) THEN
               LET l_item = l_ogc.ogc17
               ELSE
                  let l_item = l_ogb.ogb04
               END IF
               LET l_cnt=0
               SELECT COUNT(*) INTO l_cnt FROM img_file
                   WHERE img01 = l_item AND img02=l_ogc.ogc09
                     AND img03 = l_ogc.ogc091
                     AND img04 = l_ogc.ogc092
               IF l_cnt=0 THEN
#                 CALL s_add_img(l_item,l_ogb.ogb09,             #MOD-B80054 mark
#                                l_ogb.ogb091,l_ogb.ogb092,      #MOD-B80054 mark
                  CALL s_add_img(l_item,l_ogc.ogc09,             #MOD-B80054
                                 l_ogc.ogc091,l_ogc.ogc092,      #MOD-B80054
                                 l_oga.oga01,l_ogb.ogb03,l_oga.oga02)
                  IF g_errno='N' THEN
                     LET g_success = 'N'
                     RETURN l_oha.*
                  END IF
               END IF
            END FOREACH
         ELSE
#FUN-AB0011 ----------------STA
            IF s_joint_venture( l_ogb.ogb04,g_plant) OR NOT s_internal_item( l_ogb.ogb04,g_plant ) THEN  
            ELSE   
#FUN-AB0011 ----------------END
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM img_file
                WHERE img01=l_ogb.ogb04  AND img02=l_ogb.ogb09
                  AND img03=l_ogb.ogb091 AND img04=l_ogb.ogb092
               IF l_cnt = 0 THEN
                  CALL s_add_img(l_ogb.ogb04,l_ogb.ogb09,
                                 l_ogb.ogb091,l_ogb.ogb092,
                                 l_oga.oga01,l_ogb.ogb03,l_oga.oga02)
                  IF g_errno='N' THEN
                     LET g_success = 'N'
                     RETURN l_oha.*
                  END IF
               END IF
               SELECT img18 INTO l_img18 FROM img_file
                WHERE img01=l_ogb.ogb04  AND img02=l_ogb.ogb09
                  AND img03=l_ogb.ogb091 AND img04=l_ogb.ogb092
               IF l_img18 < l_oga.oga02 THEN
                  CALL cl_err(l_ogb.ogb04,'aim-400',1)  #須修改
                  LET g_success = 'N'
                  RETURN l_oha.*
               END IF
            END IF                                           #FUN-AB0011
         END IF
      END IF

      IF l_ogb.ogb04[1,4] != 'MISC' THEN
            #-----MOD-A90190---------
            #LET l_cnt=0
            #SELECT SUM(img10*img21) INTO l_qty FROM img_file
            # WHERE img01=l_ogb.ogb04 AND img02=l_ogb.ogb09
            #   AND img03=l_ogb.ogb091 AND img04=l_ogb.ogb092
            #IF l_cnt=0 THEN
            #   IF l_qty IS NULL THEN LET l_qty=0 END IF
            #   LET g_msg=NULL
            #   SELECT ze03 INTO g_msg FROM ze_file
            #    WHERE ze01='axm-246' AND ze02=p_lang
            #   ERROR g_msg CLIPPED,l_qty
            #END IF
            #-----END MOD-A90190-----
      END IF
      IF l_ogb.ogb04[1,4] != 'MISC' THEN #MOD-BB0335 add
         IF l_oga.oga09 <> '4' THEN    #MOD-A90149
            IF l_ogb.ogb17 = 'N' THEN
              #FUN-B80189 Add Begin ---
               #若料件的經營屬性為扣率代銷或者經營方式為成本代銷且代銷控制為2.非成本倉，則判斷營運中心非成本倉庫存
               IF l_ogb.ogb44 = '3' OR (l_ogb.ogb44 = '2' AND g_sma.sma146 = '2') THEN
                  LET l_qty = 0
                  LET l_rtz08 = NULL
                 #SELECT rtz08 INTO l_rtz08 FROM rtz_file WHERE rtz01 = l_ogb.ogbplant    #FUN-C90049 mark
                  CALL s_get_noncoststore(l_ogb.ogbplant,l_ogb.ogb04) RETURNING l_rtz08   #FUN-C90049 add
                  IF NOT cl_null(l_rtz08) THEN
                     SELECT SUM(img10*img21) INTO l_qty FROM img_file WHERE img01 = l_ogb.ogb04 AND img02 = l_rtz08
                     IF cl_null(l_qty) THEN LET l_qty = 0 END IF
                    #IF l_ogb.ogb12 > l_qty THEN                  #MOD-BB0043 mark
                     IF l_ogb.ogb12 *l_ogb.ogb05_fac > l_qty THEN #MOD-BB0043
                        LET g_flag2 = NULL    #FUN-C80107 add
                       #CALL s_inv_shrt_by_warehouse(g_sma.sma894[2,2],l_rtz08) RETURNING g_flag2   #FUN-C80107 add #FUN-D30024
                        CALL s_inv_shrt_by_warehouse(l_rtz08,g_plant) RETURNING g_flag2                     #FUN-D30024 add  #TQC-D40078 g_plant
                       #IF g_sma.sma894[2,2]='N' OR g_sma.sma894[2,2] IS NULL THEN   #FUN-C80107 mark
                        IF g_flag2 = 'N' OR g_flag2 IS NULL THEN           #FUN-C80107 add
                           CALL s_errmsg('',l_ogb.ogb12,'','axm-387',1)
                           LET g_success = 'N'
                           RETURN l_oha.*
                        ELSE
                           IF NOT cl_confirm('mfg3469') THEN
                              LET g_success = 'N'
                              RETURN l_oha.*
                           END IF
                        END IF
                     END IF
                  END IF
               ELSE 
               #反之則判斷營運中心成本倉庫存
                  LET l_qty = 0
                  SELECT SUM(img10*img21) INTO l_qty FROM img_file
                   WHERE img01=l_ogb.ogb04 AND img02=l_ogb.ogb09
                     AND img03=l_ogb.ogb091 AND img04=l_ogb.ogb092
                  IF l_qty IS NULL THEN LET l_qty=0 END IF
              #FUN-B80189 Add End -----
                 #IF l_ogb.ogb12 > l_qty THEN                  #MOD-BB0043 mark
                  IF l_ogb.ogb12 *l_ogb.ogb05_fac > l_qty THEN #MOD-BB0043
                     LET g_flag2 = NULL    #FUN-C80107 add
                    #CALL s_inv_shrt_by_warehouse(g_sma.sma894[2,2],l_ogb.ogb09) RETURNING g_flag2   #FUN-C80107 add #FUN-D30024
                     CALL s_inv_shrt_by_warehouse(l_ogb.ogb09,g_plant) RETURNING g_flag2   #FUN-D30024 add   #TQC-D40078 g_plant
                    #IF g_sma.sma894[2,2]='N' OR g_sma.sma894[2,2] IS NULL THEN   #FUN-C80107 mark
                     IF g_flag2 = 'N' OR g_flag2 IS NULL THEN           #FUN-C80107 add
                       #CALL cl_err(l_ogb.ogb12,'axm-280',1) #FUN-B80189 Mark
                       #CALL s_errmsg('',l_ogb.ogb12,'','axm-280',1) #FUN-B80189 Add #MOD-D10273 mark
                        LET g_showmsg = l_ogb.ogb04,"/",l_ogb.ogb12             #MOD-D10273
                        CALL s_errmsg('ogb04,ogb12',g_showmsg,'','axm-280',1)   #MOD-D10273
                        CALL s_showmsg() #TQC-C20502 add
                        LET g_success = 'N'
                        RETURN l_oha.*
                     ELSE
                        IF NOT cl_confirm('mfg3469') THEN
                           LET g_success = 'N'
                           RETURN l_oha.*
                        END IF
                     END IF
                  END IF
               END IF  #FUN-B80189 Add
            END IF
         END IF   #MOD-A90149
      END IF #MOD-BB0335 add
      IF l_ogb.ogb04[1,4] != 'MISC' THEN
          IF l_oga.oga09 NOT MATCHES  '[159]' THEN #非出貨通知單  
             CALL t600sub_chk_img(l_oga.*,l_ogb.*) IF g_success='N' THEN RETURN l_oha.* END IF
             #-----MOD-B10141---------
             IF l_ogb.ogb17 = 'N' THEN
                CALL t600sub_chk_ogb15_fac(l_oga.*,l_ogb.*) IF g_success='N' THEN RETURN l_oha.* END IF  
             END IF
             #-----END MOD-B10141-----
          END IF
      END IF
    #CHI-A40029 add --end--

      #-----MOD-B10141---------
      #IF l_ogb.ogb17 = 'N' THEN
      #   CALL t600sub_chk_ogb15_fac(l_oga.*,l_ogb.*) IF g_success='N' THEN RETURN l_oha.* END IF   #No.TQC-7C0114
      #END IF
      #-----END MOD-B10141-----

     LET l_ogb12_t = l_ogb.ogb12 #CHI-AC0034 add  #CHI-B30093 mark #CHI-B60054去掉mark
##CHI-B60054  --Begin #MARK掉CHI-B30093更改
#CHI-B30093 --begin--
#      SELECT SUM(ogc12) INTO l_ogb12_t FROM ogc_file
#       WHERE ogc01= l_ogb.ogb01
#         AND ogc03 =l_ogb.ogb03
#      IF cl_null(l_ogb12_t) THEN 
#         LET l_ogb12_t = 0 
#      END IF    
#CHI-B30093 --end--
##CHI-B60054  --End #MARK掉CHI-B30093更改


      #atmt629對于待驗倉庫的數量不應以單身的數量來做扣帳,因為如有驗退的數量
      #要把相應的量轉至驗退單上,所以此處就把它扣完,然后再后面處理驗退倉庫的量增加
      IF l_argv0 = '8' AND g_aza.aza26 != '2' THEN  #FUN-C50097 ADD !='2'
         SELECT ogb12,ogb912,ogb915,ogb917 INTO l_ogb12,l_ogb912,l_ogb915,l_ogb917
           FROM oga_file,ogb_file
          WHERE ogb01 = oga01
            AND oga01 = l_oga.oga011
           #AND oga09 = '2' AND oga65='Y'
           #AND (oga09 = '2' OR oga09 = '3') AND oga65='Y'  #FUN-BB0167   #FUN-C40072 mark
            AND (oga09 = '2' OR oga09 = '3' OR oga09 = '4') AND oga65='Y' #FUN-C40072 add
            AND ogb03 = l_ogb.ogb03
          IF cl_null(l_ogb12)  THEN LET l_ogb12  = 0 END IF
          IF cl_null(l_ogb912) THEN LET l_ogb912 = 0 END IF
          IF cl_null(l_ogb915) THEN LET l_ogb915 = 0 END IF
          IF cl_null(l_ogb917) THEN LET l_ogb917 = 0 END IF
          LET l_ogb.ogb12 = l_ogb12
          LET l_ogb.ogb912= l_ogb912
          LET l_ogb.ogb915= l_ogb915
          LET l_ogb.ogb917= l_ogb917
         #LET l_ogb.ogb16 = l_ogb.ogb12/l_ogb.ogb15_fac #MOD-B10172 mark
          LET l_ogb.ogb16 = l_ogb.ogb12*l_ogb.ogb15_fac #MOD-B10172
      END IF
#FUN-C50097 ADD BEG------
      IF l_argv0 = '8' AND g_aza.aza26 = '2' THEN #FUN-C50097 ADD 2
         #大陸版新增,此處暫不扣完,處理客戶簽退量
         IF g_oaz.oaz94 = 'Y' THEN
            IF l_ogb.ogb52 > 0 THEN #有签退量
               LET l_ogb.ogb12 = l_ogb.ogb12 + l_ogb.ogb52 #签退量+签收量
               LET l_ogb.ogb16 = l_ogb.ogb12*l_ogb.ogb15_fac
               IF g_sma.sma115 = 'Y' THEN 
                  SELECT ima906 INTO l_ima906 FROM ima_file
                   WHERE ima01=l_ogb.ogb04
                  IF l_ima906 = '2' THEN 
                  LET l_ogb.ogb912 =  (l_ogb.ogb12  mod l_ogb.ogb914)/l_ogb.ogb911    #从签收仓扣除子单位数量
                  LET l_ogb.ogb915 =  (l_ogb.ogb12   - l_ogb.ogb912*l_ogb.ogb911) / l_ogb.ogb914   #从签收仓扣除母单位数量
                  END IF 
                  IF l_ima906 = '3' THEN 
                     IF NOT cl_null(l_ogb.ogb911) THEN 
                        LET l_ogb.ogb912 = l_ogb.ogb12 / l_ogb.ogb911
                     END IF 
                     IF NOT cl_null(l_ogb.ogb914) THEN 
                        LET l_ogb.ogb915 = l_ogb.ogb12 / l_ogb.ogb914
                     END IF                  
                  END IF     
               END IF
               IF NOT cl_null(l_ogb.ogb916) THEN
                  CALL s_umfchk(l_ogb.ogb04,l_ogb.ogb05,l_ogb.ogb916)
                       RETURNING l_cnt,l_factor
                  IF l_cnt = 1 THEN
                     LET l_factor = 1               	  
                  END IF 
                  LET l_ogb.ogb917 = l_ogb.ogb12 * l_factor ##从签收仓扣除计价单位数量
               END IF               
            END IF 
         ELSE 
            SELECT ogb12,ogb912,ogb915,ogb917 INTO l_ogb12,l_ogb912,l_ogb915,l_ogb917
              FROM oga_file,ogb_file
             WHERE ogb01 = oga01
               AND oga01 = l_oga.oga011
              #AND oga09 = '2' AND oga65='Y'
              #AND (oga09 = '2' OR oga09 = '3') AND oga65='Y'  #FUN-BB0167   #FUN-C40072 mark
               AND (oga09 = '2' OR oga09 = '3' OR oga09 = '4') AND oga65='Y' #FUN-C40072 add
               AND ogb03 = l_ogb.ogb03
             IF cl_null(l_ogb12)  THEN LET l_ogb12  = 0 END IF
             IF cl_null(l_ogb912) THEN LET l_ogb912 = 0 END IF
             IF cl_null(l_ogb915) THEN LET l_ogb915 = 0 END IF
             IF cl_null(l_ogb917) THEN LET l_ogb917 = 0 END IF
             LET l_ogb.ogb12 = l_ogb12
             LET l_ogb.ogb912= l_ogb912
             LET l_ogb.ogb915= l_ogb915
             LET l_ogb.ogb917= l_ogb917
            #LET l_ogb.ogb16 = l_ogb.ogb12/l_ogb.ogb15_fac #MOD-B10172 mark
             LET l_ogb.ogb16 = l_ogb.ogb12*l_ogb.ogb15_fac #MOD-B10172
          END IF 
      END IF
#FUN-C50097 ADD END------  
      LET l_msg='_s1() read no:',l_ogb.ogb03 USING '#####&',
                             '--> parts: ', l_ogb.ogb04
      CALL cl_msg(l_msg)
      IF cl_null(l_ogb.ogb04) THEN CONTINUE FOREACH END IF
      CALL t600sub_bu1(l_oga.*,l_ogb.*)   #No.TQC-8C0027
      IF g_success = 'N' THEN RETURN l_oha.* END IF
      IF g_oaz.oaz03 = 'N' THEN CONTINUE FOREACH END IF
      IF l_ogb.ogb04[1,4]='MISC' THEN CONTINUE FOREACH END IF
#如為代送，同時生成一張銷退單
      IF l_oga.oga00 = '6' THEN
         INITIALIZE l_ohb.* TO NULL
         ##產生銷退單身
         SELECT MAX(ohb03)+1 INTO l_ohb03 FROM ohb_file
          WHERE ohb01 = l_oha01
         IF cl_null(l_ohb03) OR l_ohb03 = 0 THEN
            LET l_ohb03 = 1
         END IF
         #根據客戶+產品編號+單位+日期+定價類型取定價編號及單價
         IF g_sma.sma116 MATCHES '[23]' THEN
            LET l_unit =l_ogb.ogb916
         ELSE
            LET l_unit =l_ogb.ogb05
         END IF
             CALL s_fetch_price_new(l_oga.oga1004,l_ogb.ogb04,l_ogb.ogb48,l_unit,l_oga.oga02,l_oga.oga00,g_plant,   #FUN-BC0071
                                    #l_oga.oga32,l_ogb.ogb31,l_ogb.ogb32,l_oga.oga01,l_ogb.ogb03,l_ogb.ogb12,  #MOD-A60196 mark
                                    l_oga.oga23,l_oga.oga31,l_oga.oga32,l_oga.oga01,l_ogb.ogb03,l_ogb.ogb12,   #MOD-A60196 mod
                                    l_ogb.ogb1004,p_cmd)
                # RETURNING l_ohb13                 #FUN-AB0061 
                  RETURNING l_ohb13,l_ohb.ohb37     #FUN-AB0061
            #FUN-B70087 mod
            #IF l_ohb13=0 THEN CALL s_unitprice_entry(l_oga.oga1004,l_ogb.ogb31,g_plant) END IF #FUN-9C0120
            #FUN-BC0088 ----- add start ----
            IF l_ogb.ogb04[1,4] = 'MISC' THEN
            #  CALL s_unitprice_entry(l_oga.oga1004,l_ogb.ogb31,g_plant,'M')       #TQC-CA0046 mark
               CALL s_unitprice_entry(l_oga.oga1004,l_oga.oga31,g_plant,'M')       #TQC-CA0046 add
            ELSE
            #FUN-BC0088 ----- add end ----
               IF l_ohb13=0 THEN
            #     CALL s_unitprice_entry(l_oga.oga1004,l_ogb.ogb31,g_plant,'N')    #TQC-CA0046 mark
                  CALL s_unitprice_entry(l_oga.oga1004,l_oga.oga31,g_plant,'N')    #TQC-CA0046 add
               ELSE
            #     CALL s_unitprice_entry(l_oga.oga1004,l_ogb.ogb31,g_plant,'Y')    #TQC-CA0046 mark
                  CALL s_unitprice_entry(l_oga.oga1004,l_oga.oga31,g_plant,'Y')    #TQC-CA0046 add
               END IF
            END IF #FUN-BC0088 add
            #FUN-B70087 mod--end

         #TQC-AC0144 add ----begin----------------
         #根據客戶抓取對應的折扣率
         SELECT occ32 INTO l_ohb.ohb1003 FROM occ_file
          WHERE occ01 = l_oha.oha03
         IF cl_null(l_ohb.ohb1003) OR SQLCA.SQLCODE = 100 THEN
            LET l_ohb.ohb1003 = 100 
         END IF
         #TQC-AC0144 add -----end-----------------
         
         #根據單頭單價是否含稅 進行未稅、含稅金額的計算
         IF cl_null(l_ogb.ogb917) THEN
            LET l_qty = l_ogb.ogb12
         ELSE
            LET l_qty = l_ogb.ogb917
         END IF
 
         IF l_oga.oga213='N' THEN
            LET l_ohb14  = l_ohb13*l_qty*l_ogb.ogb1006/100
            LET l_ohb13t = l_ohb13*(1+l_oga.oga211/100)*l_ogb.ogb1006/100
            LET l_ohb14t = l_ohb13t*l_qty     #No.FUN-670008
         ELSE
            LET l_ohb14  = l_ohb13*l_qty*l_ogb.ogb1006/100
            LET l_ohb13  = l_ohb13*(1+l_oga.oga211/100)
            LET l_ohb14t = l_ohb13*l_ogb.ogb12*l_ogb.ogb1006/100
         END IF
 
         LET l_ohb.ohb01     = l_oha.oha01             #銷退單號
         LET l_ohb.ohb03     = l_ohb03                 #項次
         LET l_ohb.ohb04     = l_ogb.ogb04             #產品編號
         LET l_ohb.ohb05     = l_ogb.ogb05             #銷售單位
         LET l_ohb.ohb05_fac = l_ogb.ogb05_fac         #銷售/庫存單位換算率
         LET l_ohb.ohb910    = l_ogb.ogb910            #第一單位
         LET l_ohb.ohb911    = l_ogb.ogb911            #第一單位轉換率
         LET l_ohb.ohb912    = l_ogb.ogb912            #第一單位數量
         LET l_ohb.ohb913    = l_ogb.ogb913            #第二單位
         LET l_ohb.ohb914    = l_ogb.ogb914            #第二單位轉換率
         LET l_ohb.ohb915    = l_ogb.ogb915            #第二單位數量
         LET l_ohb.ohb916    = l_ogb.ogb916            #計價單位
         LET l_ohb.ohb917    = l_ogb.ogb917            #計價數量
         LET l_ohb.ohb06     = l_ogb.ogb06             #品名規格
         LET l_ohb.ohb07     = l_ogb.ogb07             #額外品名規格
         LET l_ohb.ohb08     = l_ogb.ogb08             #銷退入庫工廠
         LET l_ohb.ohb09     = l_ogb.ogb09             #銷退入庫倉庫
         LET l_ohb.ohb091    = l_ogb.ogb091            #銷退入庫庫位
         LET l_ohb.ohb092    = l_ogb.ogb092            #銷退入庫批號
   #
   IF l_ohb.ohb092=' ' THEN DISPLAY '空 ' END IF
   IF cl_null(l_ohb.ohb092) THEN DISPLAY 'null' END IF 
   #
         LET l_ohb.ohb11     = l_ogb.ogb11             #客戶產品編號
         LET l_ohb.ohb12     = l_ogb.ogb12             #銷退數量
         LET l_ohb.ohb13     = l_ohb13                 #原幣單價
         LET l_ohb.ohb14     = l_ohb14                 #原幣稅前金額
         LET l_ohb.ohb14t    = l_ohb14t                #原幣含稅金額
         LET l_ohb.ohb15     = l_ogb.ogb15             #庫存明細單位
         LET l_ohb.ohb15_fac = l_ogb.ogb15_fac         #銷售/庫存明細單位換算率
         LET l_ohb.ohb16     = l_ogb.ogb16             #數量
         LET l_ohb.ohb50     = l_oay18                 #退貨理由碼
         LET l_ohb.ohb60     = 0                       #已開折讓數量
         LET l_ohb.ohb1001   = l_ohb1001               #定價編號
         #LET l_ohb.ohb1003   = l_ogb.ogb1006           #定價編號     #TQC-AC0144 mark
         LET l_ohb.ohb1004   = 'N'                     #搭贈          #No.FUN-670008
         LET l_ohb.ohb1005   = l_ogb.ogb1005           #作業方式      #No.FUN-670008
 
         IF cl_null(l_ohb.ohb05_fac) THEN LET l_ohb.ohb05_fac=0 END IF
         IF cl_null(l_ohb.ohb12    ) THEN LET l_ohb.ohb12    =0 END IF
         IF cl_null(l_ohb.ohb13    ) THEN LET l_ohb.ohb13    =0 END IF
         IF cl_null(l_ohb.ohb14    ) THEN LET l_ohb.ohb14    =0 END IF
         IF cl_null(l_ohb.ohb14t   ) THEN LET l_ohb.ohb14t   =0 END IF
         IF cl_null(l_ohb.ohb15_fac) THEN LET l_ohb.ohb15_fac=0 END IF
         IF cl_null(l_ohb.ohb16    ) THEN LET l_ohb.ohb16    =0 END IF
         IF cl_null(l_ohb.ohb60    ) THEN LET l_ohb.ohb60    =0 END IF
         LET l_ohb.ohb930   = l_ogb.ogb930 #FUN-670063
 
         LET l_ohb.ohbplant = l_ogb.ogbplant
			LET l_ohb.ohblegal = l_ogb.ogblegal
         LET l_ohb.ohb64 = l_ogb.ogb44
         IF g_azw.azw04 = '2' THEN
            LET l_ohb.ohb65 = l_ogb.ogb45  
            LET l_ohb.ohb66 = l_ogb.ogb46  
            LET l_ohb.ohb67 = l_ogb.ogb47                                                                                           
            LET l_ohb.ohb68 = 'N'
         ELSE
            LET l_ohb.ohb64=' '
            LET l_ohb.ohb67=0
            LET l_ohb.ohb68='N'
         END IF
 
         LET l_ohb.ohbplant = g_plant 
         LET l_ohb.ohblegal = g_legal
         #FUN-AB0061----------add---------------str----------------
         IF cl_null(l_ohb.ohb37) OR l_ohb.ohb37 = 0 THEN
            LET l_ohb.ohb37 = l_ohb.ohb13
         END IF
         #FUN-AB0061----------add---------------end----------------  
         #FUN-AB0096 ----------add start--------------------------
         #IF cl_null(l_ohb.ohb71) THEN    #FUN-AC0055 mark
         #   LET l_ohb.ohb71 = '1'
         #END IF
         #FUN-AB0096 ------------add end--------------------------- 
         #FUN-CB0087---add---str---
         IF g_aza.aza115 = 'Y' THEN
            CALL s_reason_code(l_ohb.ohb01,l_ohb.ohb31,'',l_ohb.ohb04,l_ohb.ohb09,l_oha.oha14,l_oha.oha15) RETURNING l_ohb.ohb50
            IF cl_null(l_ohb.ohb50) THEN
               CALL cl_err('','aim-425',1)
               LET g_success = 'N'
               CONTINUE FOREACH 
            END IF
         END IF
         #FUN-CB0087---add---end---
         INSERT INTO ohb_file VALUES(l_ohb.*)
         IF SQLCA.sqlcode THEN
            CALL s_errmsg("ohb01",l_ohb.ohb01,"INS ohb_file",SQLCA.sqlcode,1)     #No.FUN-710046
            LET g_success = 'N'
            CONTINUE FOREACH        #No.FUN-710046
#FUN-B70074--add--insert--
         ELSE
            IF NOT s_industry('std') THEN
               INITIALIZE l_ohbi.* TO NULL
               LET l_ohbi.ohbi01 = l_ohb.ohb01
               LET l_ohbi.ohbi03 = l_ohb.ohb03
               IF NOT s_ins_ohbi(l_ohbi.*,l_ohb.ohbplant ) THEN
                  LET g_success = 'N'  
                  CONTINUE FOREACH 
               END IF
            END IF 
#FUN-B70074--add--insert--
         END IF
         CALL t600sub_update_7(l_oga.*,l_oha.*,l_ohb.*)   ##銷退單庫存過帳處理(img_file,tlf_file update)
         IF g_success='N' THEN
            CONTINUE FOREACH    #No.FUN-710046
         END IF
         IF g_sma.sma115 = 'Y' THEN
            SELECT ima906 INTO l_ima906 FROM ima_file
             WHERE ima01=l_ohb.ohb04
            IF l_ima906 = '2' THEN  #子母單位
               IF NOT cl_null(l_ohb.ohb913) THEN
                  CALL t600sub_upd_imgg('1',l_ohb.ohb04,l_ohb.ohb09,l_ohb.ohb091,
                      l_ohb.ohb092,l_ohb.ohb913,l_ohb.ohb914,l_ohb.ohb915,+1,'2',l_oga.*)
                  IF g_success='N' THEN RETURN l_oha.* END IF
                  IF NOT cl_null(l_ohb.ohb915) THEN                               #CHI-860005
                    CALL t600sub_upd_tlff_oh('2',l_ohb.ohb913,l_ohb.ohb914,l_ohb.ohb915,l_oha.*,l_ohb.*)
                    IF g_success='N' THEN RETURN l_oha.* END IF
                  END IF
               END IF
               IF NOT cl_null(l_ohb.ohb910) THEN
                  CALL t600sub_upd_imgg('1',l_ohb.ohb04,l_ohb.ohb09,l_ohb.ohb091,
                     l_ohb.ohb092,l_ohb.ohb910,l_ohb.ohb911,l_ohb.ohb912,+1,'1',l_oga.*)
                  IF g_success='N' THEN RETURN l_oha.* END IF
                  IF NOT cl_null(l_ohb.ohb912) THEN                                #CHI-860005
                     CALL t600sub_upd_tlff_oh('1',l_ohb.ohb910,l_ohb.ohb911,l_ohb.ohb912,l_oha.*,l_ohb.*)
                     IF g_success='N' THEN RETURN l_oha.* END IF
                  END IF
               END IF
            END IF
            IF l_ima906 = '3' THEN  #參考單位
               IF NOT cl_null(l_ohb.ohb913) THEN
                  CALL t600sub_upd_imgg('2',l_ohb.ohb04,l_ohb.ohb09,l_ohb.ohb091,
                      l_ohb.ohb092,l_ohb.ohb913,l_ohb.ohb914,l_ohb.ohb915,+1,'2',l_oga.*)
                  IF g_success='N' THEN RETURN l_oha.* END IF
                  IF NOT cl_null(l_ohb.ohb915) THEN                                #CHI-860005 
                     CALL t600sub_upd_tlff_oh('2',l_ohb.ohb913,l_ohb.ohb914,l_ohb.ohb915,l_oha.*,l_ohb.*)
                     IF g_success='N' THEN RETURN l_oha.* END IF
                  END IF
               END IF
            END IF
         END IF
 
         IF g_success='N' THEN
            RETURN l_oha.*
         END IF
 
         LET l_oha.oha50=l_oha.oha50+l_ohb.ohb14                                      #No.FUN-670008
         LET l_oha53=l_oha.oha50-l_oha.oha1006                                        #No.FUN-670008
         LET l_oha.oha1008 =l_oha.oha50*(l_oga.oga211+1100)/100                          #No.FUN-670008
         UPDATE oha_file SET oha53=l_oha53,oha50=l_oha.oha50,oha1008 =l_oha.oha1008   #No.FUN-670008
          WHERE oha01=l_oha.oha01
         IF SQLCA.SQLCODE THEN
            LET g_success='N'
            RETURN l_oha.*
         END IF
 
      END IF
 
      IF l_ogb.ogb17='Y' THEN     ##多倉儲出貨
       #TQC-C70056 mark--str-by xuxz
       ##TQC-C70056 -- add -- begin
       # IF g_prog[1,7] = "axmt628" THEN
       #    LET l_oga01_1 = l_oga.oga011
       # ELSE
       #    LET l_oga01_1 = l_oga.oga01
       # END IF
       # IF cl_null(l_oga01_1) THEN
       #    LET l_oga01_1 = ''
       # END IF
       ##TQC-C70056 -- add -- end
       #TQC-C70056 mark--end -by xuxz
         SELECT SUM(ogc12) INTO l_tot1 FROM ogc_file WHERE ogc01=l_oga.oga01           #TQC-C70056 mark#TQC-C70056 remark by xuxz
        #SELECT SUM(ogc12) INTO l_tot1 FROM ogc_file WHERE ogc01=l_oga01_1             #TQC-C70056 add#TQC-C70056 mark by xuxz
                                                     AND ogc03=l_ogb.ogb03
        #IF l_tot1 != l_ogb.ogb12 OR   		#多倉儲合計數量與產品項次不符 #CHI-AC0034 mark 
         IF l_tot1 != l_ogb12_t OR   		#多倉儲合計數量與產品項次不符 #CHI-AC0034
            cl_null(l_tot1) THEN
            LET l_msg = ''
            LET l_msg = cl_get_feldname('ogb03',g_lang)
            LET l_msg = l_msg CLIPPED,l_ogb.ogb03,'  ogc12!=ogb12:'
            CALL s_errmsg('','',l_msg,"axm-172",1)                #No.FUN-710046
            LET g_success='N' DISPLAY "1" EXIT FOREACH
         END IF
         #FUN-C50097 ADD BEGIN 120809 #判斷單身項次簽退量和多倉儲簽退量是否一致
         IF l_oga.oga09 = '8' AND g_aza.aza26='2' AND g_oaz.oaz94 = 'Y' THEN 
            SELECT SUM(ogc13) INTO l_tot2 FROM ogc_file WHERE ogc01=l_oga.oga01
                                                     AND ogc03=l_ogb.ogb03 
            IF l_tot2 != l_ogb.ogb52 OR   		#多倉儲合計數量與產品項次不符 #CHI-AC0034
               cl_null(l_tot2) THEN
               LET l_msg = ''
               LET l_msg = cl_get_feldname('ogb03',g_lang)
               LET l_msg = l_msg CLIPPED,l_ogb.ogb03,'  ogc13!=ogb52:'
               CALL s_errmsg('','',l_msg,"axm-172",1)                #No.FUN-710046
               LET g_success='N' DISPLAY "1" EXIT FOREACH
            END IF                                                                
         END IF 
         #FUN-C50097 ADD END   120809
#CHI-B60054  --Begin #MARK掉CHI-B30093更改
#CHI-B30093 --begin-         
#         IF l_argv0 !='8' THEN 
#            IF l_ogb12_t != l_ogb.ogb12 THEN 
#               LET l_msg = ''
#               LET l_msg = cl_get_feldname('ogb03',g_lang)
#               LET l_msg = l_msg CLIPPED,l_ogb.ogb03,'  ogc12!=ogb12:'
#               CALL s_errmsg('','',l_msg,"axm-172",1)               
#               LET g_success='N' DISPLAY "1" EXIT FOREACH                       
#            END IF 
#         END IF    
#CHI-B30093 --end--
#CHI-B60054  --End #MARK掉CHI-B30093更改
                     
         LET l_flag=''  #No:8741
         DECLARE t600_s1_ogc_c CURSOR FOR  SELECT * FROM ogc_file
            WHERE ogc01=l_oga.oga01 AND ogc03=l_ogb.ogb03
         FOREACH t600_s1_ogc_c INTO l_ogc.*
            IF SQLCA.SQLCODE THEN
               CALL s_errmsg('','',"Foreach s1_ogc:",SQLCA.sqlcode,1) #No.FUN-710046
               LET g_success='N' DISPLAY "2" EXIT FOREACH
            END IF
            LET l_msg='_s1() read ogc02:',l_ogb.ogb03,'-',l_ogc.ogc091
            CALL cl_msg(l_msg)
           #LET l_flag = 'Y'  #MOD-C10147 add  #TQC-C40244 mark
           #----------------No:CHI-A70023 add  
            LET l_cnt = 0 
            SELECT COUNT(*) INTO l_cnt FROM ogc_file WHERE ogc01= l_oga.oga01
                     AND ogc03 = l_ogb.ogb03 AND ogc17 != l_ogb.ogb04
            IF l_cnt != 0 THEN 
               LET l_flag = 'X'
            END IF
           #----------------No:CHI-A70023 end  
#CHI-B60054  --Begin #去掉MARK CHI-B30093
#CHI-B30093 --begin--
#-------FUN-C50097 ADD BEGIN-----
           IF l_oga.oga09 = '8' THEN
              IF g_aza.aza26='2' AND g_oaz.oaz94 = 'Y' THEN
                  SELECT SUM(ogc12) INTO l_ogc12
                    FROM ogc_file
                   WHERE ogc01 = l_oga.oga011
                     AND ogc03 = l_ogb.ogb03
                     AND ogc17 = l_ogc.ogc17  
                  #No.MOD-C70145  --Begin
                     AND ogc092= l_ogc.ogc092
                  #No.MOD-C70145  --End                      
                  IF l_ogc.ogc12 != l_ogc12 THEN
                     LET l_ogc.ogc12 = l_ogc.ogc12 + l_ogc.ogc13 #銷售數量 + 銷退數量 = 本次簽收倉,過帳異動數量
                     LET l_ogc.ogc16 = l_ogc.ogc12 * l_ogc.ogc15_fac
                     LET l_ogc.ogc16 = s_digqty(l_ogc.ogc16,l_ogc.ogc15)    #FUN-910088--add--
                  END IF                                    
              ELSE 
#           #CHI-AC0034 add --start--
#           #有驗退時,在途倉仍是出全部數量(含可入庫數量、驗退數量)
#           IF l_oga.oga09 = '8' THEN #MOD-B40148 add
                  SELECT SUM(ogc12) INTO l_ogc12
                    FROM ogc_file
                   WHERE ogc01 = l_oga.oga011
                     AND ogc03 = l_ogb.ogb03
                     AND ogc17 = l_ogc.ogc17
                  #No.MOD-C70145  --Begin
                     AND ogc092= l_ogc.ogc092
                  #No.MOD-C70145  --End     
                  IF l_ogc.ogc12 != l_ogc12 THEN
                     LET l_ogc.ogc12 = l_ogc12
                     LET l_ogc.ogc16 = l_ogc.ogc12 * l_ogc.ogc15_fac
                     LET l_ogc.ogc16 = s_digqty(l_ogc.ogc16,l_ogc.ogc15)    #FUN-910088--add--
                  END IF
#           END IF #MOD-B40148 add 
               END IF 
            END IF 
#-------FUN-C50097 ADD END---------           
#           #CHI-AC0034 add --end--
#CHI-B30093 --end--
#CHI-B60054  --End #去掉MARK CHI-B30093                                   	 
            IF g_oaz.oaz23 = 'Y' AND NOT cl_null(l_ogc.ogc17) THEN
               CALL t600sub_update(l_ogc.ogc09,l_ogc.ogc091,l_ogc.ogc092,
                             l_ogc.ogc12,l_ogb.ogb05,l_ogc.ogc15_fac,l_ogc.ogc16,l_flag,l_ogc.ogc17,l_oga.*,l_ogb.*) #No:8741
            ELSE
               CALL t600sub_update(l_ogc.ogc09,l_ogc.ogc091,l_ogc.ogc092,
                               l_ogc.ogc12,l_ogb.ogb05,l_ogc.ogc15_fac,l_ogc.ogc16,l_flag,l_ogb.ogb04,l_oga.*,l_ogb.*) #No:8741
            END IF
            LET l_flag='Y'  #No:8741 #MOD-C10147 mark  #TQC-C40244 remark
            IF g_success='N' THEN    #No.FUN-6C0083
               LET g_totsuccess="N"
               LET g_success="Y"
               CONTINUE FOREACH
            END IF
         END FOREACH
     #MOD-BB0051 mark add -----
     # ELSE
     ##    CALL t600_chk_ima262(l_ogb.*) #BUG-4A0232,MOD-520078   #MOD-850309 #FUN-A20044
     #    CALL t600_chk_avl_stk(l_ogb.*) #BUG-4A0232,MOD-520078   #MOD-850309 #FUN-A20044
     #    CALL t600sub_update(l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,
     #                     l_ogb.ogb12,l_ogb.ogb05,l_ogb.ogb15_fac,l_ogb.ogb16,'',l_ogb.ogb04,l_oga.*,l_ogb.*)  #No:8741  #FUN-5C0075 #FUN-730012
     #    IF g_success='N' THEN    #No.FUN-6C0083
     #       LET g_totsuccess="N"
     #       LET g_success="Y"
     #       CONTINUE FOREACH
     #    END IF
     # END IF
     #MOD-BB0051 mark add -----
         IF g_success='N' THEN RETURN l_oha.* END IF #MOD-4A0232
#--------#FUN-C50097 ADD BEGIN----------
#多倉儲出貨流程   #當爲大陸版,且立賬走開票流程,且不做發出商品管理
         IF g_success = 'Y' THEN
          IF g_aza.aza26='2' AND g_oaz.oaz92 = 'Y' AND g_oaz.oaz93 = 'Y' THEN 
             IF cl_null(g_oaz.oaz95) THEN 
                CALL cl_err('axms100/oaz95','axm-956',1)  #須修改
                LET g_success = 'N'
                RETURN l_oha.* 
             ELSE
#MOD-CB0050 add begin-------------------------------
                CALL t600sub_chk_ogb1001(l_ogb.ogb1001) RETURNING l_cnt2
                IF l_cnt2 > 0 THEN 
                   #走開票流程時，對于原因碼為贈品（aooi313列入銷售費用為Y）的項次，
                   #出貨過賬不應產生至發票倉，axmt670也不能針對此項次開票。
                ELSE 
#MOD-CB0050 add end--------------------------------- 
                   IF (g_prog[1,7] = 'axmt620' OR g_prog[1,7] = 'axmp230') AND l_oga.oga65='N' AND l_oga.oga00 != '2' THEN #MOD-CB0083 add oga00
                      #當走直接出貨時, #TQC-D10067 add g_prog[1,7] = 'axmp230' 
                      #更新發票倉庫存和產生tlf檔案
   #FUN-C50097 ADD 120726 
   #将多仓储批的存储批号更新到发票仓
                      DECLARE t600_sub_ogc_c42 CURSOR FOR          
                       SELECT SUM(ogc12),ogc17,ogc092 FROM ogc_file 
                         WHERE ogc01=l_oga.oga01 AND ogc03=l_ogb.ogb03  
                       GROUP BY ogc17,ogc092                                             
                      FOREACH t600_sub_ogc_c42 INTO l_ogc.ogc12,l_ogc.ogc17,l_ogc.ogc092  
                         IF SQLCA.SQLCODE THEN
                            CALL s_errmsg('','',"Foreach t600_sub_ogc_c42:",SQLCA.sqlcode,1)
                            LET g_success='N' RETURN 
                         END IF
                         LET l_msg='_s1() read ogc02:',l_ogb.ogb03,'-',l_ogc.ogc091
                         CALL cl_msg(l_msg)
                         LET l_flag='X'                
                         SELECT img09 INTO l_img09 FROM img_file
                          WHERE img01= l_ogb.ogb04  AND img02= g_oaz.oaz95            
                            AND img03= l_oga.oga03  AND img04= l_ogc.ogc092             
                         #FUN-C50097 ADD BEG
                         IF cl_null(l_img09) THEN 
                            SELECT DISTINCT img09 INTO l_img09 FROM img_file
                             WHERE img01= l_ogb.ogb04  AND img04= l_ogc.ogc092                               
                         END IF             
                         #FUN-C50097 ADD END  
                         CALL s_umfchk(l_ogb.ogb04,l_ogb.ogb05,l_img09) RETURNING g_cnt,l_ogc.ogc15_fac
                         LET l_ogc.ogc16=l_ogc.ogc12*l_ogc.ogc15_fac
                         LET l_ogc.ogc16 = s_digqty(l_ogc.ogc16,l_ogc.ogc15) 
                         CALL t600sub_consign(g_oaz.oaz95,l_oga.oga03,l_ogc.ogc092,l_ogc.ogc12,l_ogb.ogb05,l_ogc.ogc15_fac,
                         l_ogc.ogc16,l_flag,l_ogc.ogc17,l_oga.*,l_ogb.*) 
                         IF g_success='N' THEN 
                            LET g_totsuccess="N"
                            LET g_success="Y"
                            CONTINUE FOREACH
                         END IF
                      END FOREACH    
   #FUN-C50097 ADD 120726                          
   #                  CALL t600sub_consign(g_oaz.oaz95,l_oga.oga03,l_ogb.ogb092,l_ogb.ogb12,l_ogb.ogb05,l_ogb.ogb15_fac,l_ogb.ogb16,'',l_ogb.ogb04,l_oga.*,l_ogb.*)                                           
                      IF g_sma.sma115 = 'Y' THEN #双单位逻辑
                         CALL t600sub_consign_mu(g_oaz.oaz95,l_oga.oga03,l_ogb.ogb092,l_oga.*,l_ogb.*) 
                      END IF 
                      IF g_success='N' THEN 
                         LET g_totsuccess="N"
                         LET g_success="Y"
                         CONTINUE FOREACH
                      END IF
                   END IF
                   IF g_prog[1,7] = 'axmt628' AND l_oga.oga00 != '2' THEN #MOD-CB0083 add oga00 
                   #更新發票倉庫存和產生tlf檔案,走出貨簽收時候,去掉簽退數量
                      #IF l_ogb.ogb52 > 0 THEN #有签退量                 l_ogb.ogb12  - l_ogb.ogb52
                      #   LET l_ogb.ogb12 = l_ogb.ogb12 - l_ogb.ogb52 #(签退量+签收量) -  簽退量
                      SELECT ogb12 INTO l_ogb12_t1 FROM ogb_file #出货单数量
                       WHERE ogb01 = l_oga.oga011
                         AND ogb03 = l_ogb.ogb03
                      SELECT ogb12 INTO l_ogb12_t2 FROM ogb_file #签收单数量
                       WHERE ogb01 = l_oga.oga01
                         AND ogb03 = l_ogb.ogb03 
                      IF cl_null(l_ogb12_t1) THEN LET  l_ogb12_t1 = 0 END IF 
                      IF cl_null(l_ogb12_t2) THEN LET  l_ogb12_t2 = 0 END IF  
                      IF l_ogb12_t1 - l_ogb12_t2 > 0 THEN  #出货量大于签收量
                         LET l_ogb.ogb12 = l_ogb12_t2                   
                         LET l_ogb.ogb16 = l_ogb.ogb12*l_ogb.ogb15_fac
                          IF g_sma.sma115 = 'Y' THEN 
                             SELECT ima906 INTO l_ima906 FROM ima_file
                              WHERE ima01=l_ogb.ogb04
                             IF l_ima906 = '2' THEN 
                                LET l_ogb.ogb912 =  (l_ogb.ogb12  mod l_ogb.ogb914)/l_ogb.ogb911    #签退子单位数量
                                LET l_ogb.ogb915 =  (l_ogb.ogb12   - l_ogb.ogb912*l_ogb.ogb911) / l_ogb.ogb914   #签退母单位数量                          
                             END IF 
                             IF l_ima906 = '3' THEN 
                                IF NOT cl_null(l_ogb.ogb911) THEN 
                                   LET l_ogb.ogb912 = l_ogb.ogb12 / l_ogb.ogb911
                                END IF 
                                IF NOT cl_null(l_ogb.ogb914) THEN 
                                   LET l_ogb.ogb915 = l_ogb.ogb12 / l_ogb.ogb914
                                END IF                  
                             END IF     
                          END IF
                         IF NOT cl_null(l_ogb.ogb916) THEN
                            CALL s_umfchk(l_ogb.ogb04,l_ogb.ogb05,l_ogb.ogb916)
                                 RETURNING l_cnt,l_factor
                            IF l_cnt = 1 THEN
                               LET l_factor = 1               	  
                            END IF 
                            LET l_ogb.ogb917 = l_ogb.ogb12 * l_factor
                         END IF               
                      END IF
   #将多仓储批的存储批号更新到发票仓
                      DECLARE t600_sub_ogc_c43 CURSOR FOR          
                       SELECT SUM(ogc12),ogc17,ogc092 FROM ogc_file 
                         WHERE ogc01=l_oga.oga01 AND ogc03=l_ogb.ogb03  
                       GROUP BY ogc17,ogc092                                             
                      FOREACH t600_sub_ogc_c43 INTO l_ogc.ogc12,l_ogc.ogc17,l_ogc.ogc092  
                         IF SQLCA.SQLCODE THEN
                            CALL s_errmsg('','',"Foreach t600_sub_ogc_c43:",SQLCA.sqlcode,1)
                            LET g_success='N' RETURN 
                         END IF
                         LET l_msg='_s1() read ogc02:',l_ogb.ogb03,'-',l_ogc.ogc091
                         CALL cl_msg(l_msg)
                         LET l_flag='X'                
                         SELECT img09 INTO l_img09 FROM img_file
                          WHERE img01= l_ogb.ogb04  AND img02= g_oaz.oaz95            
                            AND img03= l_oga.oga03  AND img04= l_ogc.ogc092             
                         #FUN-C50097 ADD BEG
                         IF cl_null(l_img09) THEN 
                            SELECT DISTINCT img09 INTO l_img09 FROM img_file
                             WHERE img01= l_ogb.ogb04  AND img04= l_ogc.ogc092                               
                         END IF             
                         #FUN-C50097 ADD END  
                         CALL s_umfchk(l_ogb.ogb04,l_ogb.ogb05,l_img09) RETURNING g_cnt,l_ogc.ogc15_fac
                         LET l_ogc.ogc16=l_ogc.ogc12*l_ogc.ogc15_fac
                         LET l_ogc.ogc16 = s_digqty(l_ogc.ogc16,l_ogc.ogc15) 
                         CALL t600sub_consign(g_oaz.oaz95,l_oga.oga03,l_ogc.ogc092,l_ogc.ogc12,l_ogb.ogb05,
                         l_ogc.ogc15_fac,l_ogc.ogc16,l_flag,l_ogc.ogc17,l_oga.*,l_ogb.*) 
                         IF g_success='N' THEN 
                            LET g_totsuccess="N"
                            LET g_success="Y"
                            CONTINUE FOREACH
                         END IF
                      END FOREACH    
   #FUN-C50097 ADD 120726                   
                      #CALL t600sub_consign(g_oaz.oaz95,l_oga.oga03,l_ogb.ogb092,l_ogb.ogb12,l_ogb.ogb05,l_ogb.ogb15_fac,l_ogb.ogb16,'',l_ogb.ogb04,l_oga.*,l_ogb.*)                                           
                      IF g_sma.sma115 = 'Y' THEN #双单位逻辑
                         CALL t600sub_consign_mu(g_oaz.oaz95,l_oga.oga03,l_ogb.ogb092,l_oga.*,l_ogb.*)   
                      END IF
                      IF g_success='N' THEN 
                         LET g_totsuccess="N"
                         LET g_success="Y"
                         CONTINUE FOREACH
                      END IF                                          
                   END IF #axmt628
                END IF #MOD-CB0050 add   
             END IF
          END IF         
         END IF 
#---------FUN-C50097 ADD END---------                           
         IF g_sma.sma115 = 'Y' THEN
            SELECT ima906 INTO l_ima906 FROM ima_file
             WHERE ima01=l_ogb.ogb04
         #IF l_ogb.ogb17 = 'Y' THEN #MOD-BB0051 mark
            DECLARE t600_s1_ogg_c CURSOR FOR  SELECT * FROM ogg_file
              WHERE ogg01=l_oga.oga01 AND ogg03=l_ogb.ogb03
              ORDER BY ogg20 DESC
            FOREACH t600_s1_ogg_c INTO l_ogg.*
               IF SQLCA.SQLCODE THEN
                  CALL s_errmsg('','',"Foreach s1_ogg:",SQLCA.sqlcode,1)   #No.FUN-710046
                  LET g_success='N' DISPLAY "3" EXIT FOREACH
               END IF
               LET l_msg='_s1() read ogg02:',l_ogb.ogb03,'-',l_ogg.ogg091
               CALL cl_msg(l_msg)
#FUN-C50097 ADD BEG------120727
               IF l_oga.oga09 = '8' THEN
                  IF g_aza.aza26='2' AND g_oaz.oaz94 = 'Y' THEN
                      SELECT SUM(ogg12) INTO l_ogg12
                        FROM ogg_file
                       WHERE ogg01 = l_oga.oga011
                         AND ogg03 = l_ogb.ogb03
                         AND ogg17 = l_ogg.ogg17  
                         AND ogg092= l_ogg.ogg092                   
                      IF l_ogg.ogg12 != l_ogg12 THEN
                         LET l_ogg.ogg12 = l_ogg.ogg12 + l_ogg.ogg13 #銷售數量 + 銷退數量 = 本次簽收倉,過帳異動數量
                         LET l_ogg.ogg16 = l_ogg.ogg12 * l_ogg.ogg15_fac
                         LET l_ogg.ogg16 = s_digqty(l_ogg.ogg16,l_ogg.ogg15)    
                      END IF                                    
                  ELSE 
                      #有驗退時,在途倉仍是出全部數量(含可入庫數量、驗退數量)
                      SELECT SUM(ogg12) INTO l_ogg12
                        FROM ogg_file
                       WHERE ogg01 = l_oga.oga011
                         AND ogg03 = l_ogb.ogb03
                         AND ogg17 = l_ogg.ogg17
                         AND ogg092= l_ogg.ogg092
                      IF l_ogg.ogg12 != l_ogg12 THEN
                         LET l_ogg.ogg12 = l_ogg12
                         LET l_ogg.ogg16 = l_ogg.ogg12 * l_ogg.ogg15_fac
                         LET l_ogg.ogg16 = s_digqty(l_ogg.ogg16,l_ogg.ogg15) 
                      END IF
                  END IF 
               END IF               
#FUN-C50097 ADD END------120727               
               IF g_sma.sma117 = 'N' THEN 
                  IF g_oaz.oaz23 = 'Y' AND NOT cl_null(l_ogg.ogg17) THEN
                     IF l_ima906 <> '1' THEN    #MOD-8C0139
                        CALL t600sub_chk_imgg(l_ima906,l_ogg.ogg20,l_ogg.ogg17,
                                            l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,
                                            l_ogg.ogg15,l_ogg.ogg15_fac,l_ogg.ogg16,'','','','','')
                     END IF   #MOD-8C0139
                  ELSE
                     IF l_ima906 <> '1' THEN    #MOD-8C0139
                        CALL t600sub_chk_imgg(l_ima906,l_ogg.ogg20,l_ogb.ogb04,
                                            l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,
                                            l_ogg.ogg15,l_ogg.ogg15_fac,l_ogg.ogg16,'','','','','')
                     END IF   #MOD-8C0139
                  END IF
                  IF l_ima906 <> '1' THEN    #MOD-8C0139
                     IF g_success = 'N' THEN
                        LET g_totsuccess = 'N'
                        LET g_success = 'Y'
                        CONTINUE FOREACH
                     END IF
                  END IF   #MOD-8C0139
               END IF
               #-----MOD-A20117---------
               IF l_ima906 = '1' THEN
                  CALL s_upimg_imgs(
                      #l_ogb.ogb04,l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,-1,
                       l_ogg.ogg17,l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,-1,   #No:FUN-BB0081
                       l_oga.oga01,l_ogb.ogb03,l_ogg.ogg10,'2')   
               END IF
               #-----END MOD-A20117-----
               IF l_ima906 = '2' THEN
                  IF NOT cl_null(l_ogg.ogg10) THEN
                     CALL t600sub_upd_imgg(
                         #'1',l_ogb.ogb04,l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,
						  '1',l_ogg.ogg17,l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,   #No:FUN-BB0081
                                        l_ogg.ogg10,1,l_ogg.ogg12,-1,'1',l_oga.*)
                     IF g_success = 'N' THEN    #No.FUN-6C0083
                        LET g_totsuccess="N"
                        LET g_success="Y"
                        CONTINUE FOREACH
                     END IF
                     CALL s_upimg_imgs(
                         #l_ogb.ogb04,l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,-1,
                          l_ogg.ogg17,l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,-1,   #No:FUN-BB0081
                          l_oga.oga01,l_ogb.ogb03,l_ogg.ogg10,'2')   #MOD-A20117  
                     IF NOT cl_null(l_ogg.ogg12) AND l_ogg.ogg12 <> 0 THEN
                        CALL t600sub_tlff(
                            #l_ogg.ogg20,l_ogb.ogb04,l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,
                             l_ogg.ogg20,l_ogg.ogg17,l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,   #No:FUN-BB0081
                             l_ogg.ogg10,1,l_ogg.ogg12,l_oga.*,l_ogb.*,'1')   #No:FUN-BB0081
							 
                        IF g_success = 'N' THEN    #No.FUN-6C0083
                           LET g_totsuccess="N"
                           LET g_success="Y"
                           CONTINUE FOREACH
                        END IF
                     END IF
                  END IF
               END IF
               IF l_ima906 = '3' THEN
                  IF l_ogg.ogg20 = '2' THEN
                     CALL t600sub_upd_imgg(
                         #'2',l_ogb.ogb04,l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,
                          '2',l_ogg.ogg17,l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,   #No:FUN-BB0081
                          l_ogg.ogg10,1,l_ogg.ogg12,-1,'2',l_oga.*)
                     IF g_success = 'N' THEN
                        LET g_totsuccess="N"   #No.FUN-6C0083
                        LET g_success="Y"
                        CONTINUE FOREACH
                     END IF
                    #MOD-BC0207 mark --start--
                    #CALL s_upimg_imgs(l_ogb.ogb04,l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,-1,l_oga.oga01,l_ogb.ogb03,l_ogg.ogg10,'2')   #MOD-A20117  
                    #MOD-BC0207 mark --end--
                     IF NOT cl_null(l_ogg.ogg12) AND l_ogg.ogg12 <> 0 THEN
                        CALL t600sub_tlff(
                            #l_ogg.ogg20,l_ogb.ogb04,l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,
                             l_ogg.ogg20,l_ogg.ogg17,l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,   #No:FUN-BB0081
                             l_ogg.ogg10,1,l_ogg.ogg12,l_oga.*,l_ogb.*,'1')   #No:FUN-BB0081
                        IF g_success = 'N' THEN
                           LET g_totsuccess="N"   #No.FUN-6C0083
                           LET g_success="Y"
                           CONTINUE FOREACH
                        END IF
                     END IF
                     #MOD-BC0207 add --start--
                     IF l_ogg.ogg20 = '1' THEN
                       #CALL s_upimg_imgs(l_ogb.ogb04,l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,-1,l_oga.oga01,l_ogb.ogb03,l_ogg.ogg10,'2')   #TQC-C50097 mark
                        CALL s_upimg_imgs(l_ogg.ogg17,l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,-1,l_oga.oga01,l_ogb.ogb03,l_ogg.ogg10,'2')   #TQC-C50097 add
                     END IF
                     #MOD-BC0207 add --end--
                   END IF
               END IF
               IF g_success='N' THEN RETURN l_oha.* END IF
            END FOREACH
         #MOD-BB0051 ----- mark start -----
         #ELSE
         #   IF g_sma.sma117 = 'N' THEN 
         #      IF l_ima906 <> '1' THEN    #MOD-8C0139
         #         CALL t600sub_chk_imgg(l_ima906,'',l_ogb.ogb04,
         #                             l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,
         #                             '','','',l_ogb.ogb913,l_ogb.ogb915,l_ogb.ogb910,l_ogb.ogb911,l_ogb.ogb912)
         #         IF g_success = 'N' THEN
         #            LET g_totsuccess = 'N'
         #            LET g_success = 'Y'
         #            CONTINUE FOREACH
         #         END IF
         #      END IF   #MOD-8C0139
         #   END IF
         #   CALL t600sub_s_du(l_oga.*,l_ogb.*)
         #   IF g_success = 'N' THEN
         #      LET g_totsuccess="N"
         #      LET g_success="Y"
         #      CONTINUE FOREACH   #No.FUN-6C0083
         #   END IF
         #END IF
         #MOD-BB0051 ----- mark end -----
      #MOD-BB0051 ----- add start  -----
         END IF    #TQC-C50163 add 
      ELSE
         IF g_prog[1,7] != 'axmt628' THEN
            CALL t600_chk_avl_stk(l_ogb.*)
         END IF 
         CALL t600sub_update(l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,
                           l_ogb.ogb12,l_ogb.ogb05,l_ogb.ogb15_fac,l_ogb.ogb16,'',l_ogb.ogb04,l_oga.*,l_ogb.*)
         #FUN-C50097 ADD BEG---------
         IF g_success = 'Y' THEN 
            #當爲大陸版,且立賬走開票流程,且不做發出商品管理
            IF g_aza.aza26='2' AND g_oaz.oaz92 = 'Y' AND g_oaz.oaz93 = 'Y' THEN 
               IF cl_null(g_oaz.oaz95) THEN 
                  CALL cl_err('axms100/oaz95','axm-956',1)  #須修改
                  LET g_success = 'N'
                  RETURN l_oha.* 
               ELSE 
#MOD-CB0050 add begin-------------------------------
                  CALL t600sub_chk_ogb1001(l_ogb.ogb1001) RETURNING l_cnt2
                  IF l_cnt2 > 0 THEN 
                     #走開票流程時，對于原因碼為贈品（aooi313列入銷售費用為Y）的項次，
                     #出貨過賬不應產生至發票倉，axmt670也不能針對此項次開票。
                  ELSE 
#MOD-CB0050 add end--------------------------------- 
                     IF (g_prog[1,7] = 'axmt620' OR g_prog[1,7] = 'axmp230') AND l_oga.oga65='N' AND l_oga.oga00 != '2' THEN #MOD-CB0083 add oga00
                      #當走直接出貨時, #TQC-D10067 add g_prog[1,7] = 'axmp230' 
                     #更新發票倉庫存和產生tlf檔案
                        CALL t600sub_consign(g_oaz.oaz95,l_oga.oga03,l_ogb.ogb092,   
                                             l_ogb.ogb12,l_ogb.ogb05,l_ogb.ogb15_fac,l_ogb.ogb16,'',l_ogb.ogb04,l_oga.*,l_ogb.*)                                           
                        IF g_sma.sma115 = 'Y' THEN #双单位逻辑
                           CALL t600sub_consign_mu(g_oaz.oaz95,l_oga.oga03,l_ogb.ogb092,l_oga.*,l_ogb.*) 
                        END IF 
                        IF g_success='N' THEN 
                           LET g_totsuccess="N"
                           LET g_success="Y"
                           CONTINUE FOREACH
                        END IF
                     END IF 
                     IF g_prog[1,7] = 'axmt628' AND l_oga.oga00 != '2' THEN #MOD-CB0083 add oga00 
                     #更新發票倉庫存和產生tlf檔案,走出貨簽收時候,去掉簽退數量
                        #IF l_ogb.ogb52 > 0 THEN #有签退量                 l_ogb.ogb12  - l_ogb.ogb52
                        #   LET l_ogb.ogb12 = l_ogb.ogb12 - l_ogb.ogb52 #(签退量+签收量) -  簽退量
                        SELECT ogb12 INTO l_ogb12_t1 FROM ogb_file #出货单数量
                         WHERE ogb01 = l_oga.oga011
                           AND ogb03 = l_ogb.ogb03
                        SELECT ogb12 INTO l_ogb12_t2 FROM ogb_file #签收单数量
                         WHERE ogb01 = l_oga.oga01
                           AND ogb03 = l_ogb.ogb03 
                        IF cl_null(l_ogb12_t1) THEN LET  l_ogb12_t1 = 0 END IF 
                        IF cl_null(l_ogb12_t2) THEN LET  l_ogb12_t2 = 0 END IF  
                        IF l_ogb12_t1 - l_ogb12_t2 > 0 THEN  #出货量大于签收量
                           LET l_ogb.ogb12 = l_ogb12_t2                     
                           LET l_ogb.ogb16 = l_ogb.ogb12*l_ogb.ogb15_fac
                            IF g_sma.sma115 = 'Y' THEN 
                               SELECT ima906 INTO l_ima906 FROM ima_file
                                WHERE ima01=l_ogb.ogb04
                               IF l_ima906 = '2' THEN 
                                  LET l_ogb.ogb912 =  (l_ogb.ogb12  mod l_ogb.ogb914)/l_ogb.ogb911    #签收子单位数量
                                  LET l_ogb.ogb915 =  (l_ogb.ogb12   - l_ogb.ogb912*l_ogb.ogb911) / l_ogb.ogb914   #签收母单位数量                           
                               END IF 
                               IF l_ima906 = '3' THEN 
                                  IF NOT cl_null(l_ogb.ogb911) THEN 
                                     LET l_ogb.ogb912 = l_ogb.ogb12 / l_ogb.ogb911
                                  END IF 
                                  IF NOT cl_null(l_ogb.ogb914) THEN 
                                     LET l_ogb.ogb915 = l_ogb.ogb12 / l_ogb.ogb914
                                  END IF                  
                               END IF     
                            END IF
                           IF NOT cl_null(l_ogb.ogb916) THEN
                              CALL s_umfchk(l_ogb.ogb04,l_ogb.ogb05,l_ogb.ogb916)
                                   RETURNING l_cnt,l_factor
                              IF l_cnt = 1 THEN
                                 LET l_factor = 1               	  
                              END IF 
                              LET l_ogb.ogb917 = l_ogb.ogb12 * l_factor
                           END IF               
                        END IF
                        CALL t600sub_consign(g_oaz.oaz95,l_oga.oga03,l_ogb.ogb092,   
                                             l_ogb.ogb12,l_ogb.ogb05,l_ogb.ogb15_fac,l_ogb.ogb16,'',l_ogb.ogb04,l_oga.*,l_ogb.*)                                           
                        IF g_sma.sma115 = 'Y' THEN #双单位逻辑
                           CALL t600sub_consign_mu(g_oaz.oaz95,l_oga.oga03,l_ogb.ogb092,l_oga.*,l_ogb.*)   
                        END IF
                        IF g_success='N' THEN 
                           LET g_totsuccess="N"
                           LET g_success="Y"
                           CONTINUE FOREACH
                        END IF                                          
                     END IF #axmt628 
                  END IF #MOD-CB0050 add    
               END IF   
            END IF            
         END IF 
         #FUN-C50097 ADD END---------
         IF g_sma.sma115 = 'Y' THEN
            SELECT ima906 INTO l_ima906 FROM ima_file
             WHERE ima01 = l_ogb.ogb04

            IF g_sma.sma117 = 'N' THEN
               IF l_ima906 <> '1' THEN
                  CALL t600sub_chk_imgg(l_ima906,'',l_ogb.ogb04,
                                      l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,
                                      '','','',l_ogb.ogb913,l_ogb.ogb915,l_ogb.ogb910,l_ogb.ogb911,l_ogb.ogb912)
                  IF g_success = 'N' THEN
                     LET g_totsuccess = 'N'
                     LET g_success = 'Y'
                     CONTINUE FOREACH
                  END IF
               END IF
            END IF
            CALL t600sub_s_du(l_oga.*,l_ogb.*)
         END IF
         IF g_success = 'N' THEN
            LET g_totsuccess = "N"
            LET g_success = "Y"
            CONTINUE FOREACH
         END IF
        #END IF    #TQC-C50163 mark 
      #MOD-BB0051 ----- add end  -----
      END IF
      IF g_success='N' THEN RETURN l_oha.* END IF
      #更新已備置量 no.7182
     #FUN-AC0074--begin--modfiy----
     CALL s_updsie_sie(l_ogb.ogb01,l_ogb.ogb03,'2') 
     #SELECT oeb19,oeb905 INTO l_oeb19,l_oeb905 FROM oeb_file
     # WHERE oeb01=l_ogb.ogb31 AND oeb03=l_ogb.ogb32
     #IF l_oeb19 = 'Y' THEN
     #   IF l_oeb905 > l_ogb.ogb12 THEN
     #      LET l_oeb905= l_oeb905 - l_ogb.ogb12
     #   ELSE
     #      LET l_oeb905 = 0
     #   END IF
     #   UPDATE oeb_file SET oeb905 = l_oeb905
     #    WHERE oeb01 = l_ogb.ogb31
     #      AND oeb03 = l_ogb.ogb32
     #   IF STATUS THEN
     #      LET g_showmsg=l_ogb.ogb31,"/",l_ogb.ogb32               #No.FUN-710046
     #      CALL s_errmsg("obe01,obe03",g_showmsg,"UPD obe_file",SQLCA.sqlcode,1)  #No.FUN-710046
     #      LET g_success = 'N' DISPLAY "4"
     #      CONTINUE FOREACH         #No.FUN-710046
     #   END IF
     #END IF
     #FUN-AC0074--end--modify---
##處理境外倉庫存
      IF l_argv0='2' AND l_oga.oga00 MATCHES '[37]' THEN   #No.FUN-610064
        #CHI-AC0034 mark --start--
        #CALL t600sub_consign(l_oga.oga910,l_oga.oga911,l_ogb.ogb092,     #No.TQC-6B0174
        #                  l_ogb.ogb12,l_ogb.ogb05,l_ogb.ogb15_fac,l_ogb.ogb16,l_oga.*,l_ogb.*)  #No.FUN-630061
        #IF g_success = 'N' THEN
        #   LET g_totsuccess="N"
        #   LET g_success="Y"
        #   CONTINUE FOREACH   #No.FUN-6C0083
        #END IF
        #CHI-AC0034 mark --end--
         #CHI-AC0034 add --start--
         LET l_flag='' 
         IF l_ogb.ogb17='Y' AND g_oaz.oaz23 = 'Y' THEN     ##多倉儲出貨
           #DECLARE t600_s1_ogc_c2 CURSOR FOR  SELECT * FROM ogc_file
           #   WHERE ogc01=l_oga.oga01 AND ogc03=l_ogb.ogb03
            DECLARE t600_s1_ogc_c2 CURSOR FOR  SELECT SUM(ogc12),ogc17,ogc092 FROM ogc_file #MOD-BA0009 add ogc092
               WHERE ogc01=l_oga.oga01 AND ogc03=l_ogb.ogb03
               GROUP BY ogc17,ogc092 #MOD-BA0009 add ogc092
            FOREACH t600_s1_ogc_c2 INTO l_ogc.ogc12,l_ogc.ogc17,l_ogc.ogc092 #MOD-BA0009 add ogc092
               IF SQLCA.SQLCODE THEN
                  CALL s_errmsg('','',"Foreach s1_ogc:",SQLCA.sqlcode,1)
                  LET g_success='N' EXIT FOREACH
               END IF
              #LET l_msg='_s1() read ogc02:',l_ogb.ogb03,'-',l_ogc.ogc091
              #CALL cl_msg(l_msg)
               LET l_flag = 'X'
               SELECT img09 INTO l_img09 FROM img_file
                WHERE img01= l_ogb.ogb04  AND img02= l_oga.oga910
                  AND img03= l_oga.oga911 AND img04= l_ogb.ogb092 
               CALL s_umfchk(l_ogb.ogb04,l_ogb.ogb05,l_img09) RETURNING g_cnt,l_ogc.ogc15_fac
               LET l_ogc.ogc16=l_ogc.ogc12*l_ogc.ogc15_fac
               LET l_ogc.ogc16 = s_digqty(l_ogc.ogc16,l_ogc.ogc15)    #FUN-910088--add--
              #CALL t600sub_consign(l_oga.oga910,l_oga.oga911,l_ogb.ogb092,  #MOD-BA0009 mark 
               CALL t600sub_consign(l_oga.oga910,l_oga.oga911,l_ogc.ogc092,  #MOD-BA0009 
                             l_ogc.ogc12,l_ogb.ogb05,l_ogc.ogc15_fac,l_ogc.ogc16,l_flag,l_ogc.ogc17,l_oga.*,l_ogb.*)  
               IF g_success='N' THEN  
                  LET g_totsuccess="N"
                  LET g_success="Y"
                  CONTINUE FOREACH
               END IF
               #MOD-BA0009 add --start--
               IF s_industry('icd') THEN
                  LET l_cnt = 0
                  SELECT COUNT(*) INTO l_cnt FROM idb_file
                   WHERE idb07 = l_ogb.ogb01 AND idb08 = l_ogb.ogb03
                  IF l_cnt > 0 THEN
                     DECLARE t600sub_idb_c5 CURSOR FOR
                      SELECT * FROM idb_file
                       WHERE idb07 = l_ogb.ogb01 AND idb08 = l_ogb.ogb03 AND idb04 = l_ogc.ogc092
                     FOREACH t600sub_idb_c5 INTO l_idb.*
                        #出貨簽收單產生ida資料
                        IF NOT s_icdout_insicin(l_idb.*,l_oga.oga910,l_oga.oga911,l_ogc.ogc092) THEN
                           LET g_success='N'
                        END IF
                        IF g_success='N' THEN
                           LET g_totsuccess="N"
                           LET g_success="Y"
                           EXIT FOREACH
                        END IF
                     END FOREACH
                  END IF
                  SELECT ogbiicd028,ogbiicd029 INTO l_ogbi.ogbiicd02,l_ogbi.ogbiicd029
                    FROM ogbi_file WHERE ogbi01 = l_ogb.ogb01 AND ogbi03 = l_ogb.ogb03
                  CALL s_icdpost(1,l_ogb.ogb04,l_oga.oga910,l_oga.oga911,
                       l_ogc.ogc092,l_ogb.ogb05,l_ogb.ogb12,
                       l_oga.oga01,l_ogb.ogb03,l_oga.oga02,'Y',
                       '','',l_ogbi.ogbiicd029,l_ogbi.ogbiicd028,g_plant)
                       RETURNING l_flag
                  IF l_flag = 0 THEN
                     LET g_success = 'N'
                     RETURN l_oha.*
                  END IF
               END IF
               #MOD-BA0009 add --end--
            END FOREACH
         ELSE
            IF l_ogb.ogb17='Y' THEN 
               LET l_flag = 'Y'
            ELSE
               LET l_flag='' 
            END IF
            CALL t600sub_consign(l_oga.oga910,l_oga.oga911,l_ogb.ogb092,   
                          l_ogb.ogb12,l_ogb.ogb05,l_ogb.ogb15_fac,l_ogb.ogb16,l_flag,l_ogb.ogb04,l_oga.*,l_ogb.*)  
            IF g_success='N' THEN 
               LET g_totsuccess="N"
               LET g_success="Y"
               CONTINUE FOREACH
            END IF
            #TQC-BA0136(S) 這段從下面移上來            
            IF s_industry('icd') THEN
               #MOD-CB0237 -- add start --
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM idb_file
                   WHERE idb07 = l_ogb.ogb01 AND idb08 = l_ogb.ogb03
               IF l_cnt > 0 THEN
                  DECLARE t600sub_idb_c51 CURSOR FOR
                   SELECT * FROM idb_file
                    WHERE idb07 = l_ogb.ogb01 AND idb08 = l_ogb.ogb03
                   FOREACH t600sub_idb_c51 INTO l_idb.*
                      #出貨簽收單產生ida資料
                      IF NOT s_icdout_insicin(l_idb.*,l_oga.oga910,l_oga.oga911,l_idb.idb04) THEN
                         LET g_success='N'
                      END IF
                      IF g_success='N' THEN
                         LET g_totsuccess="N"
                         LET g_success="Y"
                         EXIT FOREACH
                      END IF
                   END FOREACH
               END IF
               #MOD-CB0237 -- add end --
               SELECT ogbiicd028,ogbiicd029 INTO l_ogbi.ogbiicd02,l_ogbi.ogbiicd029
                 FROM ogbi_file WHERE ogbi01 = l_ogb.ogb01 AND ogbi03 = l_ogb.ogb03
               CALL s_icdpost(1,l_ogb.ogb04,l_oga.oga910,l_oga.oga911,
                    l_ogb.ogb092,l_ogb.ogb05,l_ogb.ogb12,
                    l_oga.oga01,l_ogb.ogb03,l_oga.oga02,'Y',
                    '','',l_ogbi.ogbiicd029,l_ogbi.ogbiicd028,g_plant)
                    RETURNING l_flag
               IF l_flag = 0 THEN
                  LET g_success = 'N'
                  RETURN l_oha.*
               END IF
            END IF
            #TQC-BA0136(E)
         END IF
         #CHI-AC0034 add --end--
         IF g_sma.sma115 = 'Y' THEN  #No.FUN-630061
            CALL t600sub_consign_mu(l_oga.oga910,l_oga.oga911,l_ogb.ogb092,l_oga.*,l_ogb.*)     #No.TQC-6B0174
            IF g_success='N' THEN
               LET g_totsuccess="N"
               LET g_success="Y"
               CONTINUE FOREACH   #No.FUN-6C0083
            END IF
         END IF                      #No.FUN-630061
      END IF
     #IF l_argv0 = '2' AND l_oga.oga65='Y'  THEN           #FUN-C40072 mark
      IF l_argv0 MATCHES '[2,4]' AND l_oga.oga65='Y'  THEN #FUN-C40072 add
        #CHI-AC0034 mark --start--
        #CALL t600sub_consign(l_oga.oga66,l_oga.oga67,l_ogb.ogb092,     #No.TQC-6B0174
        #                  l_ogb.ogb12,l_ogb.ogb05,l_ogb.ogb15_fac,l_ogb.ogb16,l_oga.*,l_ogb.*)  #No.FUN-630061
        #IF g_success = 'N' THEN
        #   LET g_totsuccess="N"
        #   LET g_success="Y"
        #   CONTINUE FOREACH   #No.FUN-6C0083
        #END IF
        #CHI-AC0034 mark --end--
         #CHI-AC0034 add --start--
         LET l_flag='' 
         #No.MOD-C70145  --beg
         #IF l_ogb.ogb17='Y' AND g_oaz.oaz23 = 'Y' THEN     ##多倉儲出貨 #No.MOD-C70145  --mark
         IF l_ogb.ogb17='Y' THEN     ##多倉儲出貨 #No.MOD-C70145  --
         #No.MOD-C70145  --End          
           #DECLARE t600_s1_ogc_c3 CURSOR FOR  SELECT * FROM ogc_file
           #   WHERE ogc01=l_oga.oga01 AND ogc03=l_ogb.ogb03
            DECLARE t600_s1_ogc_c3 CURSOR FOR  
#CHI-B60054  --Begin #去掉CHI-B30093更改
#CHI-B30093 --begin--             
             SELECT SUM(ogc12),ogc17,ogc092 FROM ogc_file   #TQC-BA0136 add ogc092
              WHERE ogc01=l_oga.oga01 AND ogc03=l_ogb.ogb03
              GROUP BY ogc17,ogc092   #TQC-BA0136 add ogc092
            FOREACH t600_s1_ogc_c3 INTO l_ogc.ogc12,l_ogc.ogc17,l_ogc.ogc092  #TQC-BA0136 add ogc092
#             SELECT * FROM ogc_file
#              WHERE ogc01=l_oga.oga01 AND ogc03=l_ogb.ogb03
#            FOREACH t600_s1_ogc_c3 INTO l_ogc_1.*
#CHI-B30093 --end--            
#CHI-B60054  --End #去掉CHI-B30093更改

               IF SQLCA.SQLCODE THEN
                  CALL s_errmsg('','',"Foreach s1_ogc:",SQLCA.sqlcode,1)
                  LET g_success='N' EXIT FOREACH
               END IF
              #LET l_msg='_s1() read ogc02:',l_ogb.ogb03,'-',l_ogc.ogc091
              #CALL cl_msg(l_msg)
               LET l_flag='X' 
               SELECT img09 INTO l_img09 FROM img_file
                WHERE img01= l_ogb.ogb04  AND img02= l_oga.oga66
                  #AND img03= l_oga.oga67 AND img04= l_ogb.ogb092   #TQC-BA0136 mark
                  AND img03= l_oga.oga67 AND img04= l_ogc.ogc092  #TQC-BA0136 
#CHI-B60054  --Begin #去掉CHI-B30093更改
#CHI-B30093 --begin--            
               CALL s_umfchk(l_ogb.ogb04,l_ogb.ogb05,l_img09) RETURNING g_cnt,l_ogc.ogc15_fac
               LET l_ogc.ogc16=l_ogc.ogc12*l_ogc.ogc15_fac
               LET l_ogc.ogc16 = s_digqty(l_ogc.ogc16,l_ogc.ogc15)    #FUN-910088--add--
               #CALL t600sub_consign(l_oga.oga66,l_oga.oga67,l_ogb.ogb092,  #TQC-BA0136 mark 
               CALL t600sub_consign(l_oga.oga66,l_oga.oga67,l_ogc.ogc092,   #TQC-BA0136   
                             l_ogc.ogc12,l_ogb.ogb05,l_ogc.ogc15_fac,l_ogc.ogc16,l_flag,l_ogc.ogc17,l_oga.*,l_ogb.*)  
#               CALL s_umfchk(l_ogb.ogb04,l_ogb.ogb05,l_img09) RETURNING g_cnt,l_ogc_1.ogc15_fac
#               LET l_ogc_1.ogc16=l_ogc_1.ogc12*l_ogc_1.ogc15_fac
#
#               CALL t600sub_consign(l_oga.oga66,l_oga.oga67,l_ogc_1.ogc092,l_ogc_1.ogc12,
#                                    l_ogb.ogb05,l_ogc_1.ogc15_fac,l_ogc_1.ogc16,l_flag,
#                                    l_ogc_1.ogc17,l_oga.*,l_ogb.*)                              
#CHI-B30093 --end--                             
#CHI-B60054  --End #去掉CHI-B30093更改
               IF g_success='N' THEN  
                  LET g_totsuccess="N"
                  LET g_success="Y"
                  CONTINUE FOREACH
               END IF
               #FUN-B40066 --START--
               IF s_industry('icd') THEN
                  LET l_cnt = 0
                  SELECT COUNT(*) INTO l_cnt FROM idb_file
                   WHERE idb07 = l_ogb.ogb01 AND idb08 = l_ogb.ogb03
                  IF l_cnt > 0 THEN
                     DECLARE t600sub_idb_c1 CURSOR FOR
                      SELECT * FROM idb_file
                       WHERE idb07 = l_ogb.ogb01 AND idb08 = l_ogb.ogb03
                         AND idb04 = l_ogc.ogc092  #TQC-BA0136
                     FOREACH t600sub_idb_c1 INTO l_idb.* 
                        #出貨簽收單產生ida資料
                        IF NOT s_icdout_insicin(l_idb.*,l_oga.oga66,l_oga.oga67,l_idb.idb04) THEN   #TQC-BA0136 ogb092 -> l_idb.idb04
                           LET g_success='N'
                           EXIT FOREACH
                        END IF
                        IF g_success='N' THEN  
                           LET g_totsuccess="N"
                           LET g_success="Y"
                           EXIT FOREACH
                        END IF
                     END FOREACH
                  END IF
                  SELECT ogbiicd028,ogbiicd029 INTO l_ogbi.ogbiicd02,l_ogbi.ogbiicd029
                   FROM ogbi_file WHERE ogbi01 = l_ogb.ogb01 AND ogbi03 = l_ogb.ogb03
                  CALL s_icdpost(1,l_ogb.ogb04,l_oga.oga66,l_oga.oga67,
                       l_ogc.ogc092,l_ogb.ogb05,l_ogc.ogc12,   #TQC-BA0136 ogb092 -> ogc092  l_ogb.ogb12 ->l_ogc.ogc12
                       l_oga.oga01,l_ogb.ogb03,l_oga.oga02,'Y',
                       '','',l_ogbi.ogbiicd029,l_ogbi.ogbiicd028,'')  #FUN-B80119--傳入p_plant參數''---
                       RETURNING l_flag
                  IF l_flag = 0 THEN
                     LET g_success = 'N'                     
                     RETURN l_oha.*
                  END IF
               END IF    
               #FUN-B40066 --END--
            END FOREACH
         ELSE
            IF l_ogb.ogb17='Y' THEN 
               LET l_flag = 'Y'
#CHI-B60054  --Begin #去掉CHI-B30093更改
#CHI-B30093 --begin--      
#               DECLARE t600_ogc_tlf CURSOR FOR  
#                SELECT * FROM ogc_file
#                 WHERE ogc01=l_oga.oga01 
#                   AND ogc03=l_ogb.ogb03
#               FOREACH t600_ogc_tlf INTO l_ogc_1.*             
#                  CALL t600sub_consign(l_oga.oga66,l_oga.oga67,l_ogc_1.ogc092,l_ogc_1.ogc12, 
#                                      l_ogb.ogb05,l_ogc_1.ogc15_fac,l_ogc_1.ogc16,   
#                                      l_flag,l_ogb.ogb04,l_oga.*,l_ogb.*)                 
#                 IF g_success = 'N' THEN 
#                   EXIT FOREACH 
#                 END IF                      
#               END FOREACH                          
#CHI-B30093 --end--                   
#CHI-B60054  --End #去掉CHI-B30093更改
            ELSE
               LET l_flag=''                
            END IF               #CHI-B30093  #CHI-B60054 去掉CHI-B30093 mark
            CALL t600sub_consign(l_oga.oga66,l_oga.oga67,l_ogb.ogb092,   
                          l_ogb.ogb12,l_ogb.ogb05,l_ogb.ogb15_fac,l_ogb.ogb16,l_flag,l_ogb.ogb04,l_oga.*,l_ogb.*)  
            #END IF               #CHI-B30093 #CHI-B60054 mark CHI-B30093
            IF g_success='N' THEN 
               LET g_totsuccess="N"
               LET g_success="Y"
               CONTINUE FOREACH
            END IF
            #FUN-B40066 --START--
               IF s_industry('icd') THEN
                  LET l_cnt = 0
                  SELECT COUNT(*) INTO l_cnt FROM idb_file
                   WHERE idb07 = l_ogb.ogb01 AND idb08 = l_ogb.ogb03
                  IF l_cnt > 0 THEN
                     DECLARE t600sub_idb_c2 CURSOR FOR
                      SELECT * FROM idb_file
                       WHERE idb07 = l_ogb.ogb01 AND idb08 = l_ogb.ogb03
                     FOREACH t600sub_idb_c2 INTO l_idb.* 
                        #出貨簽收單產生ida資料
                        #IF NOT s_icdout_insicin(l_idb.*,l_oga.oga66,l_oga.oga67,l_ogb.ogb092) THEN   #FUN-C30289 
                        IF NOT s_icdout_insicin(l_idb.*,l_oga.oga66,l_oga.oga67,l_idb.idb04) THEN    #FUN-C30289
                           LET g_success='N'
                           EXIT FOREACH
                        END IF
                        IF g_success='N' THEN  
                           LET g_totsuccess="N"
                           LET g_success="Y"
                           EXIT FOREACH
                        END IF
                     END FOREACH
                  END IF
                  SELECT ogbiicd028,ogbiicd029 INTO l_ogbi.ogbiicd02,l_ogbi.ogbiicd029
                   FROM ogbi_file WHERE ogbi01 = l_ogb.ogb01 AND ogbi03 = l_ogb.ogb03
                  IF l_ogb.ogb17='N' THEN  #FUN-C30289
                     CALL s_icdpost(1,l_ogb.ogb04,l_oga.oga66,l_oga.oga67,
                          l_ogb.ogb092,l_ogb.ogb05,l_ogb.ogb12,
                          l_oga.oga01,l_ogb.ogb03,l_oga.oga02,'Y',
                          '','',l_ogbi.ogbiicd029,l_ogbi.ogbiicd028,'')  #FUN-B80119--傳入p_plant參數''---
                          RETURNING l_flag
                  #FUN-C30289---begin
                  ELSE
                     DECLARE t600_ogc_icdpost CURSOR FOR
                      SELECT * FROM ogc_file WHERE ogc01=l_oga.oga01 AND ogc03=l_ogb.ogb03
                     FOREACH t600_ogc_icdpost INTO l_ogc_1.*
                        CALL s_icdpost(1,l_ogc_1.ogc17,l_oga.oga66,l_oga.oga67,
                             l_ogc_1.ogc092,l_ogc_1.ogc15,l_ogc_1.ogc12,
                             l_oga.oga01,l_ogc_1.ogc03,l_oga.oga02,'Y',
                             '','',l_ogbi.ogbiicd029,l_ogbi.ogbiicd028,'') 
                        RETURNING l_flag
                     END FOREACH 
                  END IF 
                  #FUN-C30289---end
                  IF l_flag = 0 THEN
                     LET g_success = 'N'                     
                     RETURN l_oha.*
                  END IF
               END IF    
               #FUN-B40066 --END--
         END IF
         #CHI-AC0034 add --end--
         IF g_sma.sma115 = 'Y' THEN
           #如果多仓储批出货,则生成的签收仓,批号也应该带入,t600sub_consign_mu
            CALL t600sub_consign_mu(l_oga.oga66,l_oga.oga67,l_ogb.ogb092,l_oga.*,l_ogb.*)     #No.TQC-6B0174
            IF g_success = 'N' THEN
               LET g_totsuccess="N"
               LET g_success="Y"
               CONTINUE FOREACH   #No.FUN-6C0083
            END IF
         END IF
      END IF
      SELECT occ31 INTO l_occ31 FROM occ_file WHERE occ01=l_oga.oga03   #No.TQC-640123
      IF cl_null(l_occ31) THEN LET l_occ31='N' END IF
      IF l_oga.oga00 ='7' THEN LET l_occ31='Y' END IF   #FUN-690083 add
       IF l_occ31 = 'N' THEN CONTINUE FOREACH END IF  #NO.MOD-4B0070
      SELECT ima25,ima71 INTO l_ima25,l_ima71
        FROM ima_file WHERE ima01=l_ogb.ogb04
      IF cl_null(l_ima71) THEN LET l_ima71=0 END IF
      #MOD-B30651 add --start--
      IF l_ima71 = 0 THEN 
         LET l_tup06 = g_lastdat
      ELSE 
         LET l_tup06 = l_oga.oga02 + l_ima71
      END IF
      #MOD-B30651 add --end--
      #如為7.寄銷出貨，且客戶主檔中的客戶庫存管理flag(occ31)為Y時,
      #自動寫入客戶庫存記錄檔
      IF l_oga.oga00 ='7' THEN
      LET l_cnt=0
      SELECT COUNT(*) INTO l_cnt FROM tuq_file
       WHERE tuq01=l_oga.oga03  AND tuq02=l_ogb.ogb04              #No.TQC-640123
         AND tuq03=l_ogb.ogb092 AND tuq04=l_oga.oga02
         AND tuq11 ='2'
         AND tuq12 =l_oga.oga04
         AND tuq05 = l_oga.oga01  #MOD-7A0084
         AND tuq051= l_ogb.ogb03  #MOD-7A0084
      IF l_cnt=0 THEN
         LET l_fac1=1
         IF l_ogb.ogb05 <> l_ima25 THEN
            CALL s_umfchk(l_ogb.ogb04,l_ogb.ogb05,l_ima25)
                 RETURNING l_cnt,l_fac1
            IF l_cnt = '1'  THEN
               CALL s_errmsg('','',l_ogb.ogb04,"abm-731",0) #No.FUN-710046
               LET l_fac1=1
            END IF
         END IF
       #FUN-910088--add--start--
         LET l_tuq09_1 = l_ogb.ogb12*l_fac1
         LET l_tuq09_1 = s_digqty(l_tuq09_1,l_ima25)
       #FUN-910088--add--end--
         INSERT INTO tuq_file(tuq01,tuq02,tuq03,tuq04,tuq05,tuq051, #MOD-7A0084 modify tuq051
                              tuq06,tuq07,tuq08,tuq09,tuq10,tuq11,tuq12,
                              tuqplant,tuqlegal)  #FUN-980010 add plant & legal 
         VALUES(l_oga.oga03,l_ogb.ogb04,l_ogb.ogb092,l_oga.oga02,l_oga.oga01,l_ogb.ogb03,   #No.TQC-640123  #MOD-7A0084
             #  l_ogb.ogb05,l_ogb.ogb12,l_fac1,l_ogb.ogb12*l_fac1,'1','2',l_oga.oga04,      #FUN-910088--mark--
                l_ogb.ogb05,l_ogb.ogb12,l_fac1,l_tuq09_1,'1','2',l_oga.oga04,               #FUN-910088--add--
                g_plant,g_legal) 
         IF SQLCA.sqlcode THEN
            LET g_showmsg=l_oga.oga03,"/",l_ogb.ogb04,"/",l_ogb.ogb092,"/",l_oga.oga02,"/",l_oga.oga04  #No.FUN-710046
            CALL s_errmsg("tuq01,tuq02,tuq03,tuq04,tuq12",g_showmsg,"INS tuq_file",SQLCA.sqlcode,1)  #No.FUN-710046
            LET g_success ='N'
            DISPLAY "5"
            CONTINUE FOREACH       #No.FUN-710046
         END IF
      ELSE
         SELECT UNIQUE tuq06 INTO l_tuq06 FROM tuq_file
          WHERE tuq01=l_oga.oga03  AND tuq02=l_ogb.ogb04           #No.TQC-640123
            AND tuq03=l_ogb.ogb092 AND tuq04=l_oga.oga02
            AND tuq11 ='2'
            AND tuq12 =l_oga.oga04
            AND tuq05 = l_oga.oga01  #MOD-7A0084
            AND tuq051= l_ogb.ogb03  #MOD-7A0084
         IF SQLCA.sqlcode THEN
            LET g_showmsg=l_oga.oga03,"/",l_ogb.ogb04,"/",l_ogb.ogb092,"/",l_oga.oga02,"/",l_oga.oga04  #No.FUN-710046
            CALL s_errmsg("tuq01,tuq02,tuq03,tuq04,tuq12",g_showmsg,"SEL tuq_file",SQLCA.sqlcode,1)  #No.FUN-710046
            LET g_success ='N'
            DISPLAY "6"
            CONTINUE FOREACH       #No.FUN-710046
         END IF
         LET l_fac1=1
         IF l_ogb.ogb05 <> l_tuq06 THEN
            CALL s_umfchk(l_ogb.ogb04,l_ogb.ogb05,l_tuq06)
                 RETURNING l_cnt,l_fac1
            IF l_cnt = '1'  THEN
               CALL s_errmsg('','',l_ogb.ogb04,"abm-731",0)   #No.FUN-710046
               LET l_fac1=1
            END IF
         END IF
         SELECT tuq07 INTO l_tuq07 FROM tuq_file
          WHERE tuq01=l_oga.oga03  AND tuq02=l_ogb.ogb04    #No.TQC-640123
            AND tuq03=l_ogb.ogb092 AND tuq04=l_oga.oga02
            AND tuq11 ='2'
            AND tuq12 =l_oga.oga04
            AND tuq05 = l_oga.oga01  #MOD-7A0084
            AND tuq051= l_ogb.ogb03  #MOD-7A0084
         IF cl_null(l_tuq07) THEN LET l_tuq07=0 END IF
         IF l_tuq07+l_ogb.ogb12*l_fac1<0 THEN
            LET l_desc='2'
         ELSE
            LET l_desc='1'
         END IF
         IF l_tuq07+l_ogb.ogb12*l_fac1=0 THEN
            DELETE FROM tuq_file
             WHERE tuq01=l_oga.oga03  AND tuq02=l_ogb.ogb04          #No.TQC-640123
               AND tuq03=l_ogb.ogb092 AND tuq04=l_oga.oga02
               AND tuq11 ='2'
               AND tuq12 =l_oga.oga04
               AND tuq05 = l_oga.oga01  #MOD-7A0084
               AND tuq051= l_ogb.ogb03  #MOD-7A0084
            IF SQLCA.sqlcode THEN
               LET g_showmsg=l_oga.oga03,"/",l_ogb.ogb04,"/",l_ogb.ogb092,"/",l_oga.oga02,"/",l_oga.oga04  #No.FUN-710046
               CALL s_errmsg("tuq01,tuq02,tuq03,tuq04,tuq12",g_showmsg,"DEL tuq_file",SQLCA.sqlcode,1)  #No.FUN-710046
               LET g_success='N'
               DISPLAY "7"
               CONTINUE FOREACH    #No.FUN-710046
            END IF
         ELSE
            LET l_fac2=1
            IF l_tuq06 <> l_ima25 THEN
               CALL s_umfchk(l_ogb.ogb04,l_tuq06,l_ima25)
                    RETURNING l_cnt,l_fac2
               IF l_cnt = '1'  THEN
                  CALL cl_err(l_ogb.ogb04,'abm-731',1)
                  LET l_fac2=1
               END IF
            END IF
         #FUN-910088--add--start--
           LET l_tuq07_1 = l_ogb.ogb12*l_fac1
           LET l_tuq07_1 = s_digqty(l_tuq07_1,l_tuq06)
           LET l_tuq09_1 = l_ogb.ogb12*l_fac1*l_fac2
           LET l_tuq09_1 = s_digqty(l_tuq09_1,l_ima25)
           UPDATE tuq_file SET tuq07=tuq07+l_tuq07_1,              
                                tuq09=tuq09+l_tuq09_1,                
         #FUN-910088--add--end--
         #FUN-910088--mark--start--
         #  UPDATE tuq_file SET tuq07=tuq07+l_ogb.ogb12*l_fac1,
         #                      tuq09=tuq09+l_ogb.ogb12*l_fac1*l_fac2,
         #FUN-910088--mark--end--
                                tuq10=l_desc
             WHERE tuq01=l_oga.oga03  AND tuq02=l_ogb.ogb04    #No.TQC-640123
               AND tuq03=l_ogb.ogb092 AND tuq04=l_oga.oga02
               AND tuq11 ='2'
               AND tuq12 =l_oga.oga04
               AND tuq05 = l_oga.oga01  #MOD-7A0084
               AND tuq051= l_ogb.ogb03  #MOD-7A0084
            IF SQLCA.sqlcode THEN
               LET g_showmsg=l_oga.oga03,"/",l_ogb.ogb04,"/",l_ogb.ogb092,"/",l_oga.oga02,"/",l_oga.oga04  #No.FUN-710046
               CALL s_errmsg("tuq01,tuq02,tuq03,tuq04,tuq12",g_showmsg,"UPD tuq_file",SQLCA.sqlcode,1)  #No.FUN-710046
               LET g_success='N'
               DISPLAY "8"
               CONTINUE FOREACH         #No.FUN-710046
            END IF
         END IF
      END IF
      ELSE
         IF l_oga.oga00='6' THEN CONTINUE FOREACH END IF   #TQC-7A0114 add  #No.TQC-7C0114
         IF l_oga.oga09='8' THEN CONTINUE FOREACH END IF   #TQC-7A0114 add  #No.TQC-7C0114
         LET l_cnt=0
         SELECT COUNT(*) INTO l_cnt FROM tuq_file
          WHERE tuq01=l_oga.oga03  AND tuq02=l_ogb.ogb04              #No.TQC-640123
            AND tuq03=l_ogb.ogb092 AND tuq04=l_oga.oga02
            AND tuq11 ='1'
            AND tuq12 =l_oga.oga04
            AND tuq05 = l_oga.oga01  #MOD-7A0084
            AND tuq051= l_ogb.ogb03  #MOD-7A0084
         IF l_cnt=0 THEN
            LET l_fac1=1
            IF l_ogb.ogb05 <> l_ima25 THEN
               CALL s_umfchk(l_ogb.ogb04,l_ogb.ogb05,l_ima25)
                    RETURNING l_cnt,l_fac1
               IF l_cnt = '1'  THEN
                  CALL s_errmsg('','',l_ogb.ogb04,"abm-731",0)         #No.FUN-710046
                  LET l_fac1=1
               END IF
            END IF
          #FUN-910088--add--start--
            LET l_tuq09_1 = l_ogb.ogb12*l_fac1
            LET l_tuq09_1 = s_digqty(l_tuq09_1,l_ima25)
          #FUN-910088--add--end--
            INSERT INTO tuq_file(tuq01,tuq02,tuq03,tuq04,tuq05,tuq051,   #MOD-7A0084 modify tuq051
                                 tuq06,tuq07,tuq08,tuq09,tuq10,tuq11,tuq12,
                                 tuqplant,tuqlegal)  #FUN-980010 add plant & legal  
            VALUES(l_oga.oga03,l_ogb.ogb04,l_ogb.ogb092,l_oga.oga02,l_oga.oga01,l_ogb.ogb03,   #No.TQC-640123  #MOD-7A0084 modify
               #   l_ogb.ogb05,l_ogb.ogb12,l_fac1,l_ogb.ogb12*l_fac1,'1','1',l_oga.oga04,      #FUN-910088--mark--
                   l_ogb.ogb05,l_ogb.ogb12,l_fac1,l_tuq09_1,'1','1',l_oga.oga04,               #FUN-910088--add--
                   g_plant, g_legal) 
            IF SQLCA.sqlcode THEN
               LET g_showmsg=l_oga.oga03,"/",l_ogb.ogb04,"/",l_ogb.ogb092,"/",l_oga.oga02,"/",l_oga.oga04  #No.FUN-710046
               CALL s_errmsg("tuq01,tuq02,tuq03,tuq04,tuq12",g_showmsg,"INS tuq_file",SQLCA.sqlcode,1)  #No.FUN-710046
               LET g_success ='N'
               DISPLAY "5"
               CONTINUE FOREACH     #No.FUN-710046
            END IF
         ELSE
            SELECT UNIQUE tuq06 INTO l_tuq06 FROM tuq_file
             WHERE tuq01=l_oga.oga03  AND tuq02=l_ogb.ogb04           #No.TQC-640123
               AND tuq03=l_ogb.ogb092 AND tuq04=l_oga.oga02
               AND tuq11 ='1'
               AND tuq12 =l_oga.oga04
               AND tuq05 = l_oga.oga01  #MOD-7A0084
               AND tuq051= l_ogb.ogb03  #MOD-7A0084
            #&],0key-H*:-l&],&P$@KEY-H*:%u/`+O/d$@-S-l)l3f&l
            IF SQLCA.sqlcode THEN
               LET g_showmsg=l_oga.oga03,"/",l_ogb.ogb04,"/",l_ogb.ogb092,"/",l_oga.oga02,"/",l_oga.oga04  #No.FUN-710046
               CALL s_errmsg("tuq01,tuq02,tuq03,tuq04,tuq12",g_showmsg,"SEL tuq_file",SQLCA.sqlcode,1)  #No.FUN-710046
               LET g_success ='N'
               DISPLAY "6"
               CONTINUE FOREACH    #No.FUN-710046
            END IF
            LET l_fac1=1
            IF l_ogb.ogb05 <> l_tuq06 THEN
               CALL s_umfchk(l_ogb.ogb04,l_ogb.ogb05,l_tuq06)
                    RETURNING l_cnt,l_fac1
               IF l_cnt = '1'  THEN
                  CALL s_errmsg('','',l_ogb.ogb04,"abm-731",0) #No.FUN-710046
                  LET l_fac1=1
               END IF
            END IF
            SELECT tuq07 INTO l_tuq07 FROM tuq_file
             WHERE tuq01=l_oga.oga03  AND tuq02=l_ogb.ogb04    #No.TQC-640123
               AND tuq03=l_ogb.ogb092 AND tuq04=l_oga.oga02
               AND tuq11 ='1'
               AND tuq12 =l_oga.oga04
               AND tuq05 = l_oga.oga01  #MOD-7A0084
               AND tuq051= l_ogb.ogb03  #MOD-7A0084
            IF cl_null(l_tuq07) THEN LET l_tuq07=0 END IF
            IF l_tuq07+l_ogb.ogb12*l_fac1<0 THEN
               LET l_desc='2'
            ELSE
               LET l_desc='1'
            END IF
            IF l_tuq07+l_ogb.ogb12*l_fac1=0 THEN
               DELETE FROM tuq_file
                WHERE tuq01=l_oga.oga03  AND tuq02=l_ogb.ogb04          #No.TQC-640123
                  AND tuq03=l_ogb.ogb092 AND tuq04=l_oga.oga02
                  AND tuq11 ='1'
                  AND tuq12 =l_oga.oga04
                  AND tuq05 = l_oga.oga01  #MOD-7A0084
                  AND tuq051= l_ogb.ogb03  #MOD-7A0084
               IF SQLCA.sqlcode THEN
                  LET g_showmsg=l_oga.oga03,"/",l_ogb.ogb04,"/",l_ogb.ogb092,"/",l_oga.oga02,"/",l_oga.oga04  #No.FUN-710046
                  CALL s_errmsg("tuq01,tuq02,tuq03,tuq04,tuq12",g_showmsg,"DEL tuq_file",SQLCA.sqlcode,1)  #No.FUN-710046
                  LET g_success='N'
                  DISPLAY "7"
                  CONTINUE FOREACH    #No.FUN-710046
               END IF
            ELSE
               LET l_fac2=1
               IF l_tuq06 <> l_ima25 THEN
                  CALL s_umfchk(l_ogb.ogb04,l_tuq06,l_ima25)
                       RETURNING l_cnt,l_fac2
                  IF l_cnt = '1'  THEN
                     CALL s_errmsg('','',l_ogb.ogb04,"abm-731",0)  #No.FUN-710046
                     LET l_fac2=1
                  END IF
               END IF
            #FUN-910088--add--start--
               LET l_tuq07_1 = l_ogb.ogb12*l_fac1
               LET l_tuq07_1 = s_digqty(l_tuq07_1,l_tuq06)
               LET l_tuq09_1 = l_ogb.ogb12*l_fac1*l_fac2
               LET l_tuq09_1 = s_digqty(l_tuq09_1,l_ima25)
               UPDATE tuq_file SET tuq07=tuq07+l_tuq07_1,
                                   tuq09=tuq09+l_tuq09_1,
            #FUN-910088--add--end--
            #FUN-910088--mark--start
            #  UPDATE tuq_file SET tuq07=tuq07+l_ogb.ogb12*l_fac1,
            #                      tuq09=tuq09+l_ogb.ogb12*l_fac1*l_fac2,
            #FUN-910088--mark--end--
                                   tuq10=l_desc
                WHERE tuq01=l_oga.oga03  AND tuq02=l_ogb.ogb04    #No.TQC-640123
                  AND tuq03=l_ogb.ogb092 AND tuq04=l_oga.oga02
                  AND tuq11 ='1'
                  AND tuq12 =l_oga.oga04
                  AND tuq05 = l_oga.oga01  #MOD-7A0084
                  AND tuq051= l_ogb.ogb03  #MOD-7A0084
               IF SQLCA.sqlcode THEN
                  LET g_showmsg=l_oga.oga03,"/",l_ogb.ogb04,"/",l_ogb.ogb092,"/",l_oga.oga02,"/",l_oga.oga04  #No.FUN-710046
                  CALL s_errmsg("tuq01,tuq02,tuq03,tuq04,tuq12",g_showmsg,"UPD tuq_file",SQLCA.sqlcode,1)  #No.FUN-710046
                  LET g_success='N'
                  DISPLAY "8"
                  CONTINUE FOREACH         #No.FUN-710046
               END IF
            END IF
         END IF
      END IF
      LET l_fac1=1
      IF l_ogb.ogb05 <> l_ima25 THEN
         CALL s_umfchk(l_ogb.ogb04,l_ogb.ogb05,l_ima25)
              RETURNING l_cnt,l_fac1
         IF l_cnt = '1'  THEN
            CALL s_errmsg('','',l_ogb.ogb04,"abm-731",0)   #No.FUN-710046
            LET l_fac1=1
         END IF
      END IF
      IF l_oga.oga00 = '7' THEN
         LET l_cnt=0
         SELECT COUNT(*) INTO l_cnt FROM tup_file
          WHERE tup01=l_oga.oga03  AND tup02=l_ogb.ogb04      #No.TQC-640123
            AND tup03=l_ogb.ogb092
           #AND ((tup08='2' AND tup09=l_oga.oga04) OR   #FUN-690083 modify #CHI-B40056 mark
           #     (tup11='2' AND tup12=l_oga.oga04))     #FUN-690083 modify #CHI-B40056 mark
            AND tup11='2' AND tup12=l_oga.oga04                            #CHI-B40056
      IF cl_null(l_ogb.ogb092) THEN LET l_ogb.ogb092=' '  END IF  #FUN-790001 add
   #FUN-910088--add--start--
      LET l_tup05_1 = l_ogb.ogb12*l_fac1
      LET l_tup05_1 = s_digqty(l_tup05_1,l_ima25)
   #FUN-910088--add--end--
      IF l_cnt=0 THEN
        #INSERT INTO tup_file(tup01,tup02,tup03,tup04,tup05,tup06,tup07,tup08,tup09,tup11,tup12, #CHI-B40056 mark
         INSERT INTO tup_file(tup01,tup02,tup03,tup04,tup05,tup06,tup07,tup11,tup12,             #CHI-B40056
                              tupplant,tuplegal)  #FUN-980010 add plant & legal   #MOD-9C0330  
         VALUES(l_oga.oga03,l_ogb.ogb04,l_ogb.ogb092,l_ima25,   #No.TQC-640123
               #l_ogb.ogb12*l_fac1,l_ima71+l_oga.oga02,l_oga.oga02,'2',l_oga.oga04,'2',l_oga.oga04, #MOD-B30651 mark
               #l_ogb.ogb12*l_fac1,l_tup06,l_oga.oga02,'2',l_oga.oga04,'2',l_oga.oga04,             #MOD-B30651    #FUN-910088--mark--
               #l_tup05_1,l_tup06,l_oga.oga02,'2',l_oga.oga04,'2',l_oga.oga04,                      #FUN-910088--add-- #CHI-B40056 mark
                l_tup05_1,l_tup06,l_oga.oga02,'2',l_oga.oga04,                      #FUN-910088--add--                 #CHI-B40056
                g_plant,g_legal) 
         IF SQLCA.sqlcode THEN
            LET g_showmsg=l_oga.oga03,"/",l_ogb.ogb04,"/",l_ogb.ogb092               #No.FUN-710046
            CALL s_errmsg("tup01,tup02,tup03",g_showmsg,"UPD tup_file",SQLCA.sqlcode,1)  #No.FUN-710046
            LET g_success='N'
            DISPLAY "9"
            CONTINUE FOREACH  #No.FUN-710046
         END IF
      ELSE
      #  UPDATE tup_file SET tup05=tup05+l_ogb.ogb12*l_fac1         #FUN-910088--mark--
         UPDATE tup_file SET tup05=tup05+l_tup05_1                  #FUN-910088--add--
          WHERE tup01=l_oga.oga03  AND tup02=l_ogb.ogb04          #No.TQC-640123
            AND tup03=l_ogb.ogb092
           #AND ((tup08='2' AND tup09=l_oga.oga04) OR   #FUN-690083 modify #CHI-B40056 mark
           #     (tup11='2' AND tup12=l_oga.oga04))     #FUN-690083 modify #CHI-B40056 mark
            AND tup11='2' AND tup12=l_oga.oga04                            #CHI-B40056
         IF SQLCA.sqlcode THEN
            LET g_showmsg=l_oga.oga03,"/",l_ogb.ogb04,"/",l_ogb.ogb092               #No.FUN-710046
            CALL s_errmsg("tup01,tup02,tup03",g_showmsg,"UPD tup_file",SQLCA.sqlcode,1)  #No.FUN-710046
            LET g_success='N'
            DISPLAY "10"
            CONTINUE FOREACH        #No.FUN-710046
         END IF
      END IF
      ELSE
         IF l_oga.oga00='6' THEN CONTINUE FOREACH END IF   #No.TQC-7C0114
         IF l_oga.oga09='8' THEN CONTINUE FOREACH END IF     #No.TQC-7C0114
         LET l_cnt=0
         SELECT COUNT(*) INTO l_cnt FROM tup_file
          WHERE tup01=l_oga.oga03  AND tup02=l_ogb.ogb04      #No.TQC-640123
            AND tup03=l_ogb.ogb092
           #AND ((tup08='1' AND tup09=l_oga.oga04) OR   #FUN-690083 modify #CHI-B40056 mark
           #     (tup11='1' AND tup12=l_oga.oga04))     #FUN-690083 modify #CHI-B40056 mark
            AND tup11='1' AND tup12=l_oga.oga04                            #CHI-B40056
      IF cl_null(l_ogb.ogb092) THEN LET l_ogb.ogb092=' ' END IF  #FUN-790001 add
     #FUN-910088--add--start--
      LET l_tup05_1 = l_ogb.ogb12*l_fac1
      LET l_tup05_1 = s_digqty(l_tup05_1,l_ima25)
     #FUN-910088--add--end--
      IF l_cnt=0 THEN
        #INSERT INTO tup_file(tup01,tup02,tup03,tup04,tup05,tup06,tup07,tup08,tup09,tup11,tup12, #CHI-B40056 mark
         INSERT INTO tup_file(tup01,tup02,tup03,tup04,tup05,tup06,tup07,tup11,tup12,             #CHI-B40056
                              tupplant,tuplegal)  #FUN-980010 add plant & legal     #MOD-9C0330
         VALUES(l_oga.oga03,l_ogb.ogb04,l_ogb.ogb092,l_ima25,   #No.TQC-640123
               #l_ogb.ogb12*l_fac1,l_ima71+l_oga.oga02,l_oga.oga02,'1',l_oga.oga04,'1',l_oga.oga04, #MOD-B30651 mark
               #l_ogb.ogb12*l_fac1,l_tup06,l_oga.oga02,'1',l_oga.oga04,'1',l_oga.oga04,             #MOD-B30651   #FUN-910088--mark---
               #l_tup05_1,l_tup06,l_oga.oga02,'1',l_oga.oga04,'1',l_oga.oga04,                      #FUN-910088--add--end-- #CHI-B40056 mark
                l_tup05_1,l_tup06,l_oga.oga02,'1',l_oga.oga04,                      #FUN-910088--add--end--                 #CHI-B40056
                g_plant,g_legal) 
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","tup_file","","",SQLCA.sqlcode,"","insert tup_file",1)  #No.FUN-670008
            CALL s_errmsg("tup01",l_oga.oga03,"INS tup_file",SQLCA.sqlcode,1)  #No.FUN-710046
            LET g_success='N'
            DISPLAY "9"
            CONTINUE FOREACH                #No.FUN-710046
         END IF
      ELSE
     #   UPDATE tup_file SET tup05=tup05+l_ogb.ogb12*l_fac1        #FUN-910088--mark---
         UPDATE tup_file SET tup05=tup05+l_tup05_1                 #FUN-910088--add--end--
          WHERE tup01=l_oga.oga03  AND tup02=l_ogb.ogb04          #No.TQC-640123
            AND tup03=l_ogb.ogb092
           #AND ((tup08='1' AND tup09=l_oga.oga04) OR   #FUN-690083 modify #CHI-B40056 mark
           #     (tup11='1' AND tup12=l_oga.oga04))     #FUN-690083 modify #CHI-B40056 mark
            AND tup11='1' AND tup12=l_oga.oga04                            #CHI-B40056
         IF SQLCA.sqlcode THEN
            LET g_showmsg=l_oga.oga03,"/",l_ogb.ogb04,"/",l_ogb.ogb092               #No.FUN-710046
            CALL s_errmsg("tup01,tup02,tup03",g_showmsg,"UPD tup_file",SQLCA.sqlcode,1)  #No.FUN-710046
            LET g_success='N'
            DISPLAY "10"
            CONTINUE FOREACH       #No.FUN-710046
         END IF
      END IF
      END IF
      IF g_success='N' THEN RETURN l_oha.* END IF
  END FOREACH
  CALL t600_tqw081_update('1')
  IF g_success='N' THEN
     RETURN l_oha.*
  END IF
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF
   IF g_success = 'Y' AND l_argv0 = '8' THEN
      IF g_aza.aza26 != '2' THEN  #FUN-C50097 add
         CALL t600_gen_return_note(l_oga.*)   #MOD-790150 modify l_oga.*
 #FUN-C50097 add begin---------
      ELSE
      	  IF g_oaz.oaz94 = 'Y' THEN
      	     #詢問是否產生客戶簽退單#所呼叫函数需要重新撰写120601
      	     #大陆版多次签收段逻辑
      	     LET l_cnt = 0
      	     SELECT COUNT(*) INTO l_cnt FROM oga_file,ogb_file
      	      WHERE oga01 = ogb01 
      	        AND oga09 = '8' 
      	        AND ogaconf != 'X'
      	        AND ogb52 > 0
      	        AND oga01 = l_oga.oga01
      	     IF l_cnt > 0 THEN    
      	        CALL t600_gen_return_note2(l_oga.*)
      	        IF g_success='N' THEN
                   RETURN l_oha.*
                END IF   
      	     ELSE 
          	     #更新出货单,累计出货签收数量
                 #更新ogb50,ogb51累计签收量和累计签退量,此时无签退量,只更新签收数量即可              
                 DECLARE t600sub_upd_ogb50 CURSOR FOR SELECT ogb01,ogb03,ogb12 FROM ogb_file WHERE ogb01= l_oga.oga01
                 CALL l_ogb2.clear()
                 LET l_ac = 1
                 FOREACH  t600sub_upd_ogb50 INTO l_ogb2[l_ac].*
                    SELECT ogb50 INTO l_ogb50 FROM ogb_file
                     WHERE ogb01 =  l_oga.oga011
                       AND ogb03 = l_ogb2[l_ac].ogb03
                    IF cl_null(l_ogb50) THEN 
                       LET l_ogb50 = 0
                    END IF          
                    LET l_ogb50 = l_ogb50 + l_ogb2[l_ac].ogb12
                    IF cl_null(l_ogb50) OR l_ogb50 < 0 THEN 
                       LET l_ogb50 = 0
                    END IF 
                    UPDATE ogb_file SET ogb50 = l_ogb50
                                 WHERE  ogb01 = l_oga.oga011
                                   AND  ogb03 = l_ogb2[l_ac].ogb03           
                 END FOREACH                                         
          	     CALL l_ogb2.deleteElement(l_ac)
          	     LET  l_ac = 0	  
      	     END IF  
      	  ELSE 
      	     CALL t600_gen_return_note(l_oga.*) 
      	  END IF 	    
      END IF
#FUN-C50097 add end-----------
   END IF
  RETURN l_oha.*  #FUN-730012
END FUNCTION
 
FUNCTION t600sub_muticarry(l_oga,l_poz)
   DEFINE l_argv0 LIKE ogb_file.ogb09
   DEFINE l_msg LIKE type_file.chr1000
   DEFINE l_oga RECORD LIKE oga_file.*
   DEFINE l_poz RECORD LIKE poz_file.*
 
   LET l_argv0=l_oga.oga09  #FUN-730012
   IF l_poz.poz011='1' THEN   #正拋
      LET l_msg="axmp820 '",l_oga.oga01,"'"
   ELSE                       #逆拋
      #在逆拋必須先做庫存扣帳的動作
      LET l_msg="axmp900 '",l_oga.oga01,"' '",l_argv0,"'"
   END IF
   CALL cl_cmdrun_wait(l_msg CLIPPED)
   SELECT ogapost,oga99,oga905 INTO l_oga.ogapost,l_oga.oga99,l_oga.oga905
     FROM oga_file WHERE oga01=l_oga.oga01
   DISPLAY BY NAME l_oga.ogapost,l_oga.oga99,l_oga.oga905
END FUNCTION
 
FUNCTION t600sub_ar(l_oha)
   DEFINE l_oha RECORD LIKE oha_file.*
   DEFINE l_msg LIKE type_file.chr1000
 
   IF l_oha.ohaconf='N' THEN CALL cl_err('conf=N','aap-717',0) RETURN END IF
   IF l_oha.ohapost='N' THEN CALL cl_err('post=N','aim-206',0) RETURN END IF
   IF l_oha.oha10 IS NOT NULL THEN RETURN END IF
   IF cl_null(l_oha.oha09) OR l_oha.oha09 NOT MATCHES '[145]' THEN
      CALL cl_err(l_oha.oha09,'axr-063',0)
      RETURN
   END IF
   LET l_msg="axrp304 '",l_oha.oha01,"' '",l_oha.oha09,"' '",l_oha.ohaplant,"'"   #FUN-A60056
   CALL cl_cmdrun_wait(l_msg)
END FUNCTION
 
FUNCTION t600sub_gui(l_oga)
   DEFINE l_oga RECORD LIKE oga_file.*
   DEFINE l_oma10 LIKE oma_file.oma10
   DEFINE l_msg LIKE type_file.chr1000
 
   IF l_oga.oga09='4' THEN  RETURN END IF               #MOD-CB0064 add
   IF l_oga.oga65='Y' THEN  RETURN END IF               #FUN-630102 add
   IF l_oga.oga00 MATCHES '[237]' THEN  RETURN END IF   #FUN-630102 add
   IF l_oga.ogapost='N' THEN CALL cl_err('post=N','axm-206',0) RETURN END IF
   LET l_msg="axrp310 ",
             " '",l_oga.oga01,"'",
             " '",l_oga.oga02,"'",
             " '",l_oga.oga05,"' '",l_oga.oga212,"'"
   CALL cl_cmdrun_wait(l_msg)
   SELECT * INTO l_oga.* FROM oga_file WHERE oga01=l_oga.oga01
   DISPLAY BY NAME l_oga.oga24,l_oga.oga10
   LET l_oma10=NULL
   SELECT oma10 INTO l_oma10 FROM oma_file WHERE oma01=l_oga.oga10
   DISPLAY l_oma10 TO oma10
END FUNCTION
 
#銷退單過帳
FUNCTION t600sub_update_7(l_oga,l_oha,l_ohb)
   DEFINE l_qty    LIKE img_file.img10,
          l_ima01  LIKE ima_file.ima01,
          l_ima25  LIKE ima_file.ima01,
          p_img record like img_file.*,
          l_img RECORD
                img10   LIKE img_file.img10,
                img16   LIKE img_file.img16,
                img23   LIKE img_file.img23,
                img24   LIKE img_file.img24,
                img09   LIKE img_file.img09,
                img21   LIKE img_file.img21
                END RECORD,
          l_cnt  LIKE type_file.num5    #No.FUN-680137 SMALLINT
   DEFINE l_ima71  LIKE ima_file.ima71
   DEFINE l_fac1,l_fac2 LIKE ogb_file.ogb15_fac
   DEFINE l_occ31  LIKE occ_file.occ31
   DEFINE l_tuq06  LIKE tuq_file.tuq06
   DEFINE l_tup05  LIKE tup_file.tup05
   DEFINE l_tuq07  LIKE tuq_file.tuq07
   DEFINE l_desc   LIKE type_file.chr1    #No.FUN-680137 VARCHAR(01)
   DEFINE l_oha RECORD LIKE oha_file.*
   DEFINE l_ohb RECORD LIKE ohb_file.*
   DEFINE l_oga RECORD LIKE oga_file.*
   DEFINE l_ima86 LIKE ima_file.ima86    #FUN-730018
   DEFINE l_tup06 LIKE tup_file.tup06    #MOD-B30651 add
#FUN-910088--add--start--
   DEFINE l_tup05_1   LIKE tup_file.tup05,
          l_tuq07_1   LIKE tuq_file.tuq07,
          l_tuq09_1   LIKE tuq_file.tuq09
#FUN-910088--add--end--
   DEFINE l_msg   STRING                 #MOD-C50020
 
   IF l_ohb.ohb15 IS NULL THEN
      INITIALIZE p_img.* TO NULL
      LET p_img.img01=l_ohb.ohb04
      LET p_img.img02=l_ohb.ohb09
      LET p_img.img03=l_ohb.ohb091
      LET p_img.img04=l_ohb.ohb092
      LET p_img.img09=l_ohb.ohb05
      LET p_img.img10=0
      LET l_ohb.ohb15=l_ohb.ohb05
 
      SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01=p_img.img01
        IF SQLCA.sqlcode OR l_ima25 IS NULL THEN
           CALL cl_err('ima25 null',SQLCA.sqlcode,0)
           LET g_success = 'N'
           RETURN
        END IF
 
        CALL s_umfchk(p_img.img01,p_img.img09,l_ima25)
             RETURNING l_cnt,p_img.img21
        IF l_cnt = 1 THEN
           CALL cl_err('','mfg3075',0)
          #MOD-C50020---S---
           CALL cl_getmsg('asf-176',g_lang) RETURNING l_msg
           LET l_msg = l_msg CLIPPED,":",p_img.img01
           CALL cl_err(l_msg,'mfg3075',0)  #MOD-C50020 add l_msg
          #MOD-C50020---E---
           LET g_success = 'N'
           RETURN
        END IF
        SELECT ime05,ime06 into p_img.img23,p_img.img24 FROM ime_file
         WHERE ime01=p_img.img02 and ime02=p_img.img03
          AND imeacti = 'Y'     #FUN-D40103
        IF SQLCA.sqlcode THEN
           SELECT imd11,imd12 into p_img.img23,p_img.img24 FROM  imd_file
            WHERE imd01=p_img.img02
        END IF
        IF SQLCA.sqlcode OR l_ima25 IS NULL THEN
           CALL cl_err('imd23,imd24',SQLCA.sqlcode,0)
           LET g_success = 'N' RETURN
        END IF
 
      LET p_img.imgplant = g_plant 
      LET p_img.imglegal = g_legal 
 
      INSERT INTO img_file VALUES(p_img.*)
      IF STATUS THEN
         CALL cl_err3("ins","img_file","","","axm-186","","l_ohb.ohb15 null:",1)  #No.FUN-670008
         LET g_success = 'N' RETURN
      END IF
   END IF

   LET g_forupd_sql = "SELECT img10,img16,img23,img24,img09,img21",
                      " FROM img_file ",
                      "  WHERE img01= ?  AND img02= ? AND img03= ? ",
                      " AND img04= ?  FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE img_lock7 CURSOR FROM g_forupd_sql

   OPEN img_lock7 USING l_ohb.ohb04,l_ohb.ohb09,l_ohb.ohb091,l_ohb.ohb092
   IF STATUS THEN
      CALL cl_err('lock img fail',STATUS,1) LET g_success='N' RETURN
   END IF
 
   FETCH img_lock7 INTO l_img.*
   IF STATUS THEN
      CALL cl_err('lock img fail',STATUS,1) LET g_success='N' RETURN
   END IF
   IF cl_null(l_img.img10) THEN LET l_img.img10=0 END IF
   LET l_qty= l_img.img10 + l_ohb.ohb16
   CALL s_upimg(l_ohb.ohb04,l_ohb.ohb09,l_ohb.ohb091,l_ohb.ohb092,+1,l_ohb.ohb16,g_today,  #FUN-8C0084
          '','','','',l_ohb.ohb01,l_ohb.ohb03,'','','','','','','','','','','','')  #No.FUN-850100
   IF g_success='N' THEN
      CALL cl_err('s_upimg()','9050',0) RETURN
   END IF

   #Update ima_file
   LET g_forupd_sql ="SELECT ima25 FROM ima_file ", #FUN-730018
                     " WHERE ima01= ?  FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE ima_lock7 CURSOR FROM g_forupd_sql

   OPEN ima_lock7 USING l_ohb.ohb04
   IF STATUS THEN
      CALL cl_err('lock ima fail',STATUS,1) LET g_success='N' RETURN
   END IF

   FETCH ima_lock7 INTO l_ima25,l_ima86 #FUN-730018
   IF STATUS THEN
      CALL cl_err('lock ima fail',STATUS,1) LET g_success='N' RETURN
   END IF
   #料件編號 是否可用倉儲 是否為MRP可用倉儲 發料量
   Call s_udima(l_ohb.ohb04,l_img.img23,l_img.img24,l_ohb.ohb16*l_img.img21,
                #g_today,+1)  RETURNING l_cnt   #MOD-920298
                l_oha.oha02,+1)  RETURNING l_cnt   #MOD-920298
   #最近一次發料日期 表發料
   IF l_cnt THEN
      CALL cl_err('Update Faile',SQLCA.SQLCODE,2)
      LET g_success='N' RETURN
   END IF
   IF g_success='Y' THEN
      CALL t600sub_tlf_7(l_ima25,l_qty,l_oha.*,l_ohb.*,l_ima86)
   END IF
   #
   if l_ohb.ohb092=' ' then display '空 ' end if
   if cl_null(l_ohb.ohb092) then display 'null' end if
   #
   IF g_success = 'N' THEN RETURN END IF
  SELECT occ31 INTO l_occ31 FROM occ_file WHERE occ01=l_oha.oha03    #No.TQC-640123
  IF cl_null(l_occ31) THEN LET l_occ31='N' END IF
  IF l_occ31 = 'N' THEN RETURN END IF
   SELECT ima25,ima71 INTO l_ima25,l_ima71
     FROM ima_file WHERE ima01=l_ohb.ohb04
   IF cl_null(l_ima71) THEN LET l_ima71=0 END IF
   #MOD-B30651 add --start--
   IF l_ima71 = 0 THEN 
      LET l_tup06 = g_lastdat
   ELSE 
      LET l_tup06 = l_oha.oha02 + l_ima71
   END IF
   #MOD-B30651 add --end--
   IF l_oga.oga00 ='7' THEN
      LET l_cnt=0
      SELECT COUNT(*) INTO l_cnt FROM tuq_file
       WHERE tuq01=l_oha.oha03  AND tuq02=l_ohb.ohb04    #No.TQC-640123
         AND tuq03=l_ohb.ohb092 AND tuq04=l_oha.oha02
         AND tuq11 ='2'
         AND tuq12 =l_oha.oha04
         AND tuq05=l_oha.oha01  AND tuq051=l_ohb.ohb03 #MOD-CB0111 add
      IF l_cnt=0 THEN
         LET l_fac1=1
         IF l_ohb.ohb05 <> l_ima25 THEN
            CALL s_umfchk(l_ohb.ohb04,l_ohb.ohb05,l_ima25)
                 RETURNING l_cnt,l_fac1
            IF l_cnt = '1'  THEN
               CALL cl_err(l_ohb.ohb04,'abm-731',1)
               LET l_fac1=1
             END IF
         END IF
       #FUN-910088--add--start--
         LET l_tuq09_1 = l_ohb.ohb12*l_fac1*-1
         LET l_tuq09_1 = s_digqty(l_tuq09_1,l_ima25)
       #FUN-910088--add--end--
         INSERT INTO tuq_file(tuq01,tuq02,tuq03,tuq04,tuq05,tuq051,  #MOD-7A0084 modify
                              tuq06,tuq07,tuq08,tuq09,tuq10,tuq11,tuq12,
                              tuqplant,tuqlegal)   #FUN-980010 add plant & legal 
         VALUES(l_oha.oha03,l_ohb.ohb04,l_ohb.ohb092,l_oha.oha02,l_oha.oha01,l_ohb.ohb03,    #No.TQC-640123  #MOD_7A0084 modify
          #      l_ohb.ohb05,l_ohb.ohb12*-1,l_fac1,l_ohb.ohb12*l_fac1*-1,'2','2',l_oha.oha04,    #FUN-910088--mark--
                 l_ohb.ohb05,l_ohb.ohb12*-1,l_fac1,l_tuq09_1,'2','2',l_oha.oha04,             #FUN-910088--add
                 g_plant,g_legal)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","tuq_file","","",SQLCA.sqlcode,"","insert tuq_file",1)  #No.FUN-670008
            LET g_success ='N'
            RETURN
         END IF
      ELSE
         SELECT UNIQUE tuq06 INTO l_tuq06 FROM tuq_file
          WHERE tuq01=l_oha.oha03  AND tuq02=l_ohb.ohb04     #No.TQC-640123
            AND tuq03=l_ohb.ohb092 AND tuq04=l_oha.oha02
            AND tuq11 ='2'
            AND tuq12 =l_oha.oha04
            AND tuq05=l_oha.oha01  AND tuq051=l_ohb.ohb03 #MOD-CB0111 add
         IF SQLCA.sqlcode THEN
            CALL cl_err3("sel","tuq_file","","",SQLCA.sqlcode,"","select tuq06",1)  #No.FUN-670008
            LET g_success ='N'
            RETURN
         END IF
         LET l_fac1=1
         IF l_ohb.ohb05 <> l_tuq06 THEN
            CALL s_umfchk(l_ohb.ohb04,l_ohb.ohb05,l_tuq06)
                 RETURNING l_cnt,l_fac1
            IF l_cnt = '1'  THEN
               CALL cl_err(l_ohb.ohb04,'abm-731',1)
               LET l_fac1=1
            END IF
         END IF
         SELECT tuq07 INTO l_tuq07 FROM tuq_file
          WHERE tuq01=l_oha.oha03  AND tuq02=l_ohb.ohb04    #No.TQC-640123
            AND tuq03=l_ohb.ohb092 AND tuq04=l_oha.oha02
            AND tuq11 ='2'
            AND tuq12 =l_oha.oha04
            AND tuq05=l_oha.oha01  AND tuq051=l_ohb.ohb03 #MOD-CB0111 add
         IF cl_null(l_tuq07) THEN LET l_tuq07=0 END IF
         IF l_tuq07-l_ohb.ohb12*l_fac1<0 THEN
            LET l_desc='2'
         ELSE
            LET l_desc='1'
         END IF
         IF l_tuq07=l_ohb.ohb12*l_fac1 THEN
            DELETE FROM tuq_file
             WHERE tuq01=l_oha.oha03  AND tuq02=l_ohb.ohb04  #No.TQC-640123
               AND tuq03=l_ohb.ohb092 AND tuq04=l_oha.oha02
               AND tuq11 ='2'
               AND tuq12 =l_oha.oha04
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","tuq_file","","",SQLCA.sqlcode,"","delete tuq_file",1)  #No.FUN-670008
               LET g_success='N'
               RETURN
            END IF
         ELSE
            LET l_fac2=1
            IF l_tuq06 <> l_ima25 THEN
               CALL s_umfchk(l_ohb.ohb04,l_tuq06,l_ima25)
                    RETURNING l_cnt,l_fac2
               IF l_cnt = '1'  THEN
                  CALL cl_err(l_ohb.ohb04,'abm-731',1)
                  LET l_fac2=1
               END IF
            END IF
       #FUN-910088--add--start--
          LET l_tuq07_1 = l_ohb.ohb12*l_fac1
          LET l_tuq07_1 = s_digqty(l_tuq07_1,l_tuq06)
          LET l_tuq09_1 = l_ohb.ohb12*l_fac1*l_fac2
          LET l_tuq09_1 = s_digqty(l_tuq09_1,l_ima25)
          UPDATE tuq_file SET tuq07=tuq07-l_tuq07_1,
                              tuq09=tuq09-l_tuq09_1,
       #FUN-910088--add--end--
       #FUN-910088--mark--start-- 
       #     UPDATE tuq_file SET tuq07=tuq07-l_ohb.ohb12*l_fac1,
       #                         tuq09=tuq09-l_ohb.ohb12*l_fac1*l_fac2,
       #FUN-910088--mark--end--
                                tuq10=l_desc
             WHERE tuq01=l_oha.oha03  AND tuq02=l_ohb.ohb04      #No.RTQC-640123
               AND tuq03=l_ohb.ohb092 AND tuq04=l_oha.oha02
               AND tuq11 ='2'
               AND tuq12 =l_oha.oha04
               AND tuq05=l_oha.oha01  AND tuq051=l_ohb.ohb03 #MOD-CB0111 add
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","tuq_file","","",SQLCA.sqlcode,"","update tuq_file",1)  #No.FUN-670008
               LET g_success='N'
               RETURN
            END IF
         END IF
      END IF
   ELSE
       IF l_oga.oga00='6' THEN RETURN END IF   #No.TQC-7C0154
       IF l_oga.oga00='6' THEN RETURN END IF   #No.TQC-7C0154
      LET l_cnt=0
      SELECT COUNT(*) INTO l_cnt FROM tuq_file
       WHERE tuq01=l_oha.oha03  AND tuq02=l_ohb.ohb04    #No.TQC-640123
         AND tuq03=l_ohb.ohb092 AND tuq04=l_oha.oha02
         AND tuq11 ='1'
         AND tuq12 =l_oha.oha04
         AND tuq05=l_oha.oha01  AND tuq051=l_ohb.ohb03 #MOD-CB0111 add
      IF l_cnt=0 THEN
         LET l_fac1=1
         IF l_ohb.ohb05 <> l_ima25 THEN
            CALL s_umfchk(l_ohb.ohb04,l_ohb.ohb05,l_ima25)
                 RETURNING l_cnt,l_fac1
            IF l_cnt = '1'  THEN
               CALL cl_err(l_ohb.ohb04,'abm-731',1)
               LET l_fac1=1
             END IF
         END IF
       #FUN-910088--add--start--
         LET l_tuq09_1 = l_ohb.ohb12*l_fac1*-1
         LET l_tuq09_1 = s_digqty(l_tuq09_1,l_ima25)
       #FUN-910088--add--end--
         INSERT INTO tuq_file(tuq01,tuq02,tuq03,tuq04,tuq05,tuq051,  #MOD-7A0084 modify
                              tuq06,tuq07,tuq08,tuq09,tuq10,tuq11,tuq12,
                              tuqplant,tuqlegal)   #FUN-980010 add plant & legal 
         VALUES(l_oha.oha03,l_ohb.ohb04,l_ohb.ohb092,l_oha.oha02,l_oha.oha01,l_ohb.ohb03,     #No.TQC-640123  #MOD-7A0084 modify
              #   l_ohb.ohb05,l_ohb.ohb12*-1,l_fac1,l_ohb.ohb12*l_fac1*-1,'2','1',l_oha.oha04,    #FUN-910088--mark--
                  l_ohb.ohb05,l_ohb.ohb12*-1,l_fac1,l_tuq09_1,'2','1',l_oha.oha04,                #FUN-910088--add--
                 g_plant,g_legal) 
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","tuq_file","","",SQLCA.sqlcode,"","insert tuq_file",1)  #No.FUN-670008
            LET g_success ='N'
            RETURN
         END IF
      ELSE
         SELECT UNIQUE tuq06 INTO l_tuq06 FROM tuq_file
          WHERE tuq01=l_oha.oha03  AND tuq02=l_ohb.ohb04     #No.TQC-640123
            AND tuq03=l_ohb.ohb092 AND tuq04=l_oha.oha02
            AND tuq11 ='1'
            AND tuq12 =l_oha.oha04
            AND tuq05=l_oha.oha01  AND tuq051=l_ohb.ohb03 #MOD-CB0111 add
         IF SQLCA.sqlcode THEN
            CALL cl_err3("sel","tuq_file","","",SQLCA.sqlcode,"","select tuq06",1)  #No.FUN-670008
            LET g_success ='N'
            RETURN
         END IF
         LET l_fac1=1
         IF l_ohb.ohb05 <> l_tuq06 THEN
            CALL s_umfchk(l_ohb.ohb04,l_ohb.ohb05,l_tuq06)
                 RETURNING l_cnt,l_fac1
            IF l_cnt = '1'  THEN
               CALL cl_err(l_ohb.ohb04,'abm-731',1)
               LET l_fac1=1
            END IF
         END IF
         SELECT tuq07 INTO l_tuq07 FROM tuq_file
          WHERE tuq01=l_oha.oha03  AND tuq02=l_ohb.ohb04    #No.TQC-640123
            AND tuq03=l_ohb.ohb092 AND tuq04=l_oha.oha02
            AND tuq11 ='1'
            AND tuq12 =l_oha.oha04
            AND tuq05=l_oha.oha01  AND tuq051=l_ohb.ohb03 #MOD-CB0111 add
         IF cl_null(l_tuq07) THEN LET l_tuq07=0 END IF
         IF l_tuq07-l_ohb.ohb12*l_fac1<0 THEN
            LET l_desc='2'
         ELSE
            LET l_desc='1'
         END IF
         IF l_tuq07=l_ohb.ohb12*l_fac1 THEN
            DELETE FROM tuq_file
             WHERE tuq01=l_oha.oha03  AND tuq02=l_ohb.ohb04  #No.TQC-640123
               AND tuq03=l_ohb.ohb092 AND tuq04=l_oha.oha02
               AND tuq11 ='1'
               AND tuq12 =l_oha.oha04
               AND tuq05=l_oha.oha01  AND tuq051=l_ohb.ohb03 #MOD-CB0111 add
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","tuq_file","","",SQLCA.sqlcode,"","delete tuq_file",1)  #No.FUN-670008
               LET g_success='N'
               RETURN
            END IF
         ELSE
            LET l_fac2=1
            IF l_tuq06 <> l_ima25 THEN
               CALL s_umfchk(l_ohb.ohb04,l_tuq06,l_ima25)
                    RETURNING l_cnt,l_fac2
               IF l_cnt = '1'  THEN
                  CALL cl_err(l_ohb.ohb04,'abm-731',1)
                  LET l_fac2=1
               END IF
            END IF
        #FUN-910088--add--start--
            LET l_tuq07_1 = l_ohb.ohb12*l_fac1
            LET l_tuq07_1 = s_digqty(l_tuq07_1,l_tuq06)
            LET l_tuq09_1 = l_ohb.ohb12*l_fac1*l_fac2
            LET l_tuq09_1 = s_digqty(l_tuq09_1,l_ima25)
            UPDATE tuq_file SET tuq07=tuq07-l_tuq07_1,
                                tuq09=tuq09-l_tuq09_1,
       #FUN-910088--add--end--
       #FUN-910088--mark--start--
       #    UPDATE tuq_file SET tuq07=tuq07-l_ohb.ohb12*l_fac1,
       #                        tuq09=tuq09-l_ohb.ohb12*l_fac1*l_fac2,
       #FUN-910088-mark--end--
                                tuq10=l_desc
             WHERE tuq01=l_oha.oha03  AND tuq02=l_ohb.ohb04      #No.TQC-640123
               AND tuq03=l_ohb.ohb092 AND tuq04=l_oha.oha02
               AND tuq11 ='1'
               AND tuq12 =l_oha.oha04
               AND tuq05=l_oha.oha01  AND tuq051=l_ohb.ohb03 #MOD-CB0111 add
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","tuq_file","","",SQLCA.sqlcode,"","update tuq_file",1)  #No.FUN-670008
               LET g_success='N'
               RETURN
            END IF
         END IF
      END IF
   END IF
   LET l_fac1=1
   IF l_ohb.ohb05 <> l_ima25 THEN
      CALL s_umfchk(l_ohb.ohb04,l_ohb.ohb05,l_ima25)
           RETURNING l_cnt,l_fac1
      IF l_cnt = '1'  THEN
         CALL cl_err(l_ohb.ohb04,'abm-731',1)
         LET l_fac1=1
      END IF
   END IF
   IF l_oga.oga00 ='7' THEN
      LET l_cnt=0
      SELECT COUNT(*) INTO l_cnt FROM tup_file
       WHERE tup01=l_oha.oha03  AND tup02=l_ohb.ohb04    #No.TQC-640123
         AND tup03=l_ohb.ohb092
         AND ((tup08='2' AND tup09=l_oha.oha04) OR   #FUN-690083 modify
              (tup11='2' AND tup12=l_oha.oha04))     #FUN-690083 modify
      IF cl_null(l_ohb.ohb092) THEN LET l_ohb.ohb092=' ' END IF  #FUN-790001 add
      IF l_cnt=0 THEN
       #FUN-910088--add--start--
         LET l_tup05_1 = l_ohb.ohb12*l_fac1*-1
         LET l_tup05_1 = s_digqty(l_tup05_1,l_ima25)
       #FUN-910088--add--end--
         INSERT INTO tup_file(tup01,tup02,tup03,tup04,tup05,tup06,tup07,tup08,tup09,tup11,tup12,
                              tupplant,tuplegal)   #FUN-980010 add plant & legal    #MOD-9C0330
         VALUES(l_oha.oha03,l_ohb.ohb04,l_ohb.ohb092,l_ima25,   #No.TQC-640123
               #l_ohb.ohb12*l_fac1*-1,l_ima71+l_oha.oha02,l_oha.oha02,'2',l_oha.oha04,'2',l_oha.oha04, #MOD-B30651 mark
               #l_ohb.ohb12*l_fac1*-1,l_tup06,l_oha.oha02,'2',l_oha.oha04,'2',l_oha.oha04,             #MOD-B30651  #FUN-910088--mark--
                l_tup05_1,l_tup06,l_oha.oha02,'2',l_oha.oha04,'2',l_oha.oha04,                         #FUN-910088--add--
                g_plant,g_legal)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","tup_file","","",SQLCA.sqlcode,"","insert tup_file",1)  #No.FUN-670008
            LET g_success='N'
            RETURN
         END IF
      ELSE
       #FUN-910088--add--start--
         LET l_tup05_1 = l_ohb.ohb12*l_fac1   
         LET l_tup05_1 = s_digqty(l_tup05_1,l_ima25)
       #FUN-910088--add--end--
       # UPDATE tup_file SET tup05=tup05-l_ohb.ohb12*l_fac1        #FUN-910088--mark--
         UPDATE tup_file SET tup05=tup05-l_tup05_1                 #FUN-910088--add--
          WHERE tup01=l_oha.oha03  AND tup02=l_ohb.ohb04   #No.TQC-640123
            AND tup03=l_ohb.ohb092
            AND ((tup08='2' AND tup09=l_oha.oha04) OR   #FUN-690083 modify
                 (tup11='2' AND tup12=l_oha.oha04))     #FUN-690083 modify
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","tup_file","","",SQLCA.sqlcode,"","update tup_file",1)  #No.FUN-670008
            LET g_success='N'
            RETURN
         END IF
      END IF
   ELSE
       IF l_oga.oga00='6' THEN RETURN END IF   #No.TQC-7C0154
       IF l_oga.oga00='6' THEN RETURN END IF   #No.TQC-7C0154
      LET l_cnt=0
      SELECT COUNT(*) INTO l_cnt FROM tup_file
       WHERE tup01=l_oha.oha03  AND tup02=l_ohb.ohb04    #No.TQC-640123
         AND tup03=l_ohb.ohb092
         AND ((tup08='1' AND tup09=l_oha.oha04) OR   #FUN-690083 modify
              (tup11='1' AND tup12=l_oha.oha04))     #FUN-690083 modify
      IF cl_null(l_ohb.ohb092) THEN LET l_ohb.ohb092=' ' END IF   #FUN-790001 add
      IF l_cnt=0 THEN
      #FUN-910088--add--start--
         LET l_tup05_1 = l_ohb.ohb12*l_fac1*-1
         LET l_tup05_1 = s_digqty(l_tup05_1,l_ima25)
       #FUN-910088--add--end--
         INSERT INTO tup_file(tup01,tup02,tup03,tup04,tup05,tup06,tup07,tup08,tup09,tup11,tup12,
                              tupplant,tuplegal)   #FUN-980010 add plant & legal    #MOD-9C0330
         VALUES(l_oha.oha03,l_ohb.ohb04,l_ohb.ohb092,l_ima25,   #No.TQC-640123
               #l_ohb.ohb12*l_fac1*-1,l_ima71+l_oha.oha02,l_oha.oha02,'1',l_oha.oha04,'1',l_oha.oha04, #MOD-B30651 mark
              # l_ohb.ohb12*l_fac1*-1,l_tup06,l_oha.oha02,'1',l_oha.oha04,'1',l_oha.oha04,             #MOD-B30651   #FUN-910088--mark--
                l_tup05_1,l_tup06,l_oha.oha02,'1',l_oha.oha04,'1',l_oha.oha04,                         #FUN-910088--add--
                g_plant,g_legal)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","tup_file","","",SQLCA.sqlcode,"","insert tup_file",1)  #No.FUN-670008
            LET g_success='N'
            RETURN
         END IF
      ELSE
       #FUN-910088--add--start--
         LET l_tup05_1 = l_ohb.ohb12*l_fac1
         LET l_tup05_1 = s_digqty(l_tup05_1,l_ima25)
       #FUN-910088--add--end--
      #  UPDATE tup_file SET tup05=tup05-l_ohb.ohb12*l_fac1        #FUN-910088--mark--
         UPDATE tup_file SET tup05=tup05-l_tup05_1                 #FUN-910088--add--
          WHERE tup01=l_oha.oha03  AND tup02=l_ohb.ohb04   #No.TQC-640123
            AND tup03=l_ohb.ohb092
            AND ((tup08='1' AND tup09=l_oha.oha04) OR   #FUN-690083 modify
                 (tup11='1' AND tup12=l_oha.oha04))     #FUN-690083 modify
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","tup_file","","",SQLCA.sqlcode,"","update tup_file",1)  #No.FUN-670008
            LET g_success='N'
            RETURN
         END IF
      END IF
   END IF
END FUNCTION
 
#銷退過賬寫tlf
FUNCTION t600sub_tlf_7(p_unit,p_img10,l_oha,l_ohb,l_ima86)
   DEFINE p_unit     LIKE ima_file.ima25,       ##單位
          p_img10    LIKE img_file.img10,   #異動后數量
          l_sfb02    LIKE sfb_file.sfb02,
          l_sfb03    LIKE sfb_file.sfb03,
          l_sfb04    LIKE sfb_file.sfb04,
          l_sfb22    LIKE sfb_file.sfb22,
          l_sfb27    LIKE sfb_file.sfb27,
          l_sta      LIKE type_file.num5,    #No.FUN-680137 SMALLINT
          l_cnt      LIKE type_file.num5,    #No.FUN-680137 SMALLINT
          l_oha      RECORD LIKE oha_file.*,
          l_ohb      RECORD LIKE ohb_file.*,
          l_ima86    LIKE ima_file.ima86
 
   #----來源----
   LET g_tlf.tlf01=l_ohb.ohb04             #異動料件編號
   LET g_tlf.tlf02=731
   LET g_tlf.tlf020=' '
   LET g_tlf.tlf021=' '            #倉庫
   LET g_tlf.tlf022=' '            #儲位
   LET g_tlf.tlf023=' '            #批號
   LET g_tlf.tlf024=0              #異動后數量
   LET g_tlf.tlf025=' '            #庫存單位(ima_file or img_file)
   LET g_tlf.tlf026=l_oha.oha01    #銷退單號
   LET g_tlf.tlf027=l_ohb.ohb03    #銷退項次
   #---目的----
   LET g_tlf.tlf03=50
   LET g_tlf.tlf030=l_ohb.ohb08
   LET g_tlf.tlf031=l_ohb.ohb09    #倉庫
   LET g_tlf.tlf032=l_ohb.ohb091   #儲位
   LET g_tlf.tlf033=l_ohb.ohb092   #批號
   LET g_tlf.tlf034=p_img10        #異動后庫存數量
   LET g_tlf.tlf035=p_unit         #庫存單位(ima_file or img_file)
   LET g_tlf.tlf036=l_oha.oha01    #銷退單號
   LET g_tlf.tlf037=l_ohb.ohb03    #銷退項次
   #-->異動數量
   LET g_tlf.tlf04= ' '             #工作站
   LET g_tlf.tlf05= ' '             #作業序號
   LET g_tlf.tlf06=l_oha.oha02      #銷退日期
   LET g_tlf.tlf07=g_today          #異動資料產生日期
   LET g_tlf.tlf08=TIME             #異動資料產生時:分:秒
   LET g_tlf.tlf09=g_user           #產生人
   LET g_tlf.tlf10=l_ohb.ohb12      #異動數量
   LET g_tlf.tlf11=l_ohb.ohb05	    #發料單位
   LET g_tlf.tlf12 =l_ohb.ohb15_fac #發料/庫存 換算率
   LET g_tlf.tlf13='aomt800'
   LET g_tlf.tlf14=l_ohb.ohb50      #異動原因   #MOD-870120
 
   LET g_tlf.tlf17=' '              #非庫存性料件編號
   CALL s_imaQOH(l_ohb.ohb04)
        RETURNING g_tlf.tlf18
   LET g_tlf.tlf19=l_oha.oha03 #No.MOD-870252
   SELECT oga46 INTO g_tlf.tlf20 FROM oga_file WHERE oga01=l_ohb.ohb31
   LET g_tlf.tlf61= l_ima86 #FUN-730018
   LET g_tlf.tlf62=l_ohb.ohb33    #參考單號(訂單)
   LET g_tlf.tlf64=l_ohb.ohb52    #手冊編號 NO.A093
   LET g_tlf.tlf930=l_ohb.ohb930  #FUN-670063
   SELECT ogb41,ogb42,ogb43,ogb1001
     INTO g_tlf.tlf20,g_tlf.tlf41,g_tlf.tlf42,g_tlf.tlf43
     FROM ogb_file
    WHERE ogb01 = l_ohb.ohb31
      AND ogb03 = l_ohb.ohb32
   IF SQLCA.sqlcode THEN
     LET g_tlf.tlf20 = ' '
     LET g_tlf.tlf41 = ' '
     LET g_tlf.tlf42 = ' '
     LET g_tlf.tlf43 = ' '
   END IF
   CALL s_tlf(1,0)
END FUNCTION
 
FUNCTION t600sub_upd_tlff_oh(p_flag,p_unit,p_fac,p_qty,l_oha,l_ohb)
DEFINE
   p_flag     LIKE type_file.chr1,     #No.FUN-680137 VARCHAR(1)
   p_unit     LIKE img_file.img09,
   p_fac      LIKE img_file.img21,
   p_qty      LIKE img_file.img10,
   p_lineno   LIKE ogb_file.ogb03,
   l_imgg10   LIKE imgg_file.imgg10,
   l_ima25    LIKE ima_file.ima25,
   l_ima86    LIKE ima_file.ima86,
   l_oha      RECORD LIKE oha_file.*,
   l_ohb      RECORD LIKE ohb_file.*
 
   LET g_forupd_sql ="SELECT ima25,ima86 FROM ima_file ",
                     " WHERE ima01= ?  FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE ima_lock8 CURSOR FROM g_forupd_sql

   OPEN ima_lock8 USING l_ohb.ohb04
   IF STATUS THEN
      CALL cl_err('lock ima fail',STATUS,1) LET g_success='N' RETURN
   END IF
   FETCH ima_lock8 INTO l_ima25,l_ima86
   IF STATUS THEN
      CALL cl_err('lock ima fail',STATUS,1) LET g_success='N' RETURN
   END IF
 
   INITIALIZE g_tlff.* TO NULL
   SELECT imgg10 INTO l_imgg10 FROM imgg_file
    WHERE imgg01=l_ohb.ohb04 AND imgg02=l_ohb.ohb09
      AND imgg03=l_ohb.ohb091   AND imgg04=l_ohb.ohb092
      AND imgg09=p_unit
   IF cl_null(l_imgg10) THEN LET l_imgg10=0 END IF
 
   LET g_tlff.tlff01=l_ohb.ohb04         #異動料件編號
   LET g_tlff.tlff02=731                 #來源碼
   LET g_tlff.tlff020=' '
   LET g_tlff.tlff021=' '                #倉庫
   LET g_tlff.tlff022=' '                #儲位
   LET g_tlff.tlff023=' '                #批號
   LET g_tlff.tlff024=0                  #異動後數量
   LET g_tlff.tlff025=' '                #庫存單位(ima_file or img_file)
   LET g_tlff.tlff026=l_oha.oha01        #銷退單號
   LET g_tlff.tlff027=l_ohb.ohb03        #銷退項次
   #---目的----
   LET g_tlff.tlff03=50
   LET g_tlff.tlff030=l_ohb.ohb08
   LET g_tlff.tlff031=l_ohb.ohb09        #倉庫
   LET g_tlff.tlff032=l_ohb.ohb091       #儲位
   LET g_tlff.tlff033=l_ohb.ohb092       #批號
   LET g_tlff.tlff034=l_imgg10           #異動後庫存數量
   LET g_tlff.tlff035=p_unit             #庫存單位(ima_file or img_file)
   LET g_tlff.tlff036=l_ohb.ohb01        #銷退單號
   LET g_tlff.tlff037=l_ohb.ohb03        #銷退項次
 
   #-->異動數量
   LET g_tlff.tlff04= ' '             #工作站
   LET g_tlff.tlff05= ' '             #作業序號
   LET g_tlff.tlff06=l_oha.oha02      #發料日期
   LET g_tlff.tlff07=g_today          #異動資料產生日期
   LET g_tlff.tlff08=TIME             #異動資料產生時:分:秒
   LET g_tlff.tlff09=g_user           #產生人
   LET g_tlff.tlff10=p_qty            #異動數量
   LET g_tlff.tlff11=p_unit           #發料單位
   LET g_tlff.tlff12=p_fac            #發料/庫存 換算率
   LET g_tlff.tlff13='aomt800'
   LET g_tlff.tlff14=' '              #異動原因
 
   LET g_tlff.tlff17=' '              #非庫存性料件編號
   CALL s_imaQOH(l_ohb.ohb04)
        RETURNING g_tlff.tlff18
   LET g_tlff.tlff19=l_oha.oha04
   SELECT oga46 INTO g_tlff.tlff20 FROM oga_file WHERE oga01=l_ohb.ohb31
   LET g_tlff.tlff61= l_ima86 #FUN-730018
   LET g_tlff.tlff62=l_ohb.ohb32    #參考單號(訂單)
   LET g_tlff.tlff63=l_ohb.ohb33    #訂單項次
   LET g_tlff.tlff64=l_ohb.ohb52    #手冊編號 no.A050
   LET g_tlff.tlff66=p_flag         #for axcp500多倉出貨處理   #No:8741
   LET g_tlff.tlff930=l_ohb.ohb930  #FUN-670063
   IF cl_null(l_ohb.ohb915) OR l_ohb.ohb915=0 THEN
      CALL s_tlff(p_flag,NULL)
   ELSE
      CALL s_tlff(p_flag,l_ohb.ohb913)
   END IF
END FUNCTION
 
FUNCTION t600sub_upd_imgg(p_imgg00,p_imgg01,p_imgg02,p_imgg03,p_imgg04,
                       p_imgg09,p_imgg211,p_imgg10,p_type,p_no,l_oga)
  DEFINE p_imgg00   LIKE imgg_file.imgg00,
         p_imgg01   LIKE imgg_file.imgg01,
         p_imgg02   LIKE imgg_file.imgg02,
         p_imgg03   LIKE imgg_file.imgg03,
         p_imgg04   LIKE imgg_file.imgg04,
         p_imgg09   LIKE imgg_file.imgg09,
         p_imgg211  LIKE imgg_file.imgg211,
         p_no       LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(01)
         l_ima25    LIKE ima_file.ima25,
         l_ima906   LIKE ima_file.ima906,
         l_imgg21   LIKE imgg_file.imgg21,
         p_imgg10   LIKE imgg_file.imgg10,
         p_type     LIKE type_file.num10      #No.FUN-680137 INTEGER
   DEFINE l_cnt     LIKE type_file.num5
   DEFINE l_oga     RECORD LIKE oga_file.*
   DEFINE l_msg     STRING                 #MOD-C50020
   #TQC-D50131--add--str--
   DEFINE l_ogb     RECORD LIKE ogb_file.*   
   DEFINE l_imm01   LIKE imm_file.imm01      
   DEFINE l_unit_arr      DYNAMIC ARRAY OF RECORD    
                          unit   LIKE ima_file.ima25,
                          fac    LIKE img_file.img21,
                          qty    LIKE img_file.img10
                       END RECORD
   #TQC-D50131--add--end--
 
    LET g_forupd_sql =
        "SELECT imgg01,imgg02,imgg03,imgg04,imgg09 FROM imgg_file ",
        "  WHERE imgg01= ?  AND imgg02= ? AND imgg03= ? AND imgg04= ? ",
        "    AND imgg09= ? FOR UPDATE "   #FUN-560043
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE imgg_lock CURSOR FROM g_forupd_sql
 
    OPEN imgg_lock USING p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09   #FUN-560043
    IF STATUS THEN
       CALL cl_err("OPEN imgg_lock:", STATUS, 1)
       LET g_success='N'
       CLOSE imgg_lock
       RETURN
    END IF
    FETCH imgg_lock INTO p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09
    IF STATUS THEN
       CALL cl_err('lock imgg fail',STATUS,1)
       LET g_success='N'
       CLOSE imgg_lock
       RETURN
    END IF
    SELECT ima25,ima906 INTO l_ima25,l_ima906 FROM ima_file WHERE ima01=p_imgg01
    IF SQLCA.sqlcode OR l_ima25 IS NULL THEN
       CALL cl_err3("sel","ima_file",p_imgg01,"",SQLCA.sqlcode,"","ima25 null",1)  #No.FUN-670008
       LET g_success = 'N' RETURN
    END IF
 
    CALL s_umfchk(p_imgg01,p_imgg09,l_ima25)
          RETURNING l_cnt,l_imgg21
    IF l_cnt = 1 AND NOT (l_ima906='3' AND p_no ='2') THEN
       CALL cl_err('','mfg3075',0)
      #MOD-C50020---S---
       CALL cl_getmsg('asf-176',g_lang) RETURNING l_msg
       LET l_msg = l_msg CLIPPED,":",p_imgg01
       CALL cl_err(l_msg,'mfg3075',0)     #MOD-C50020 add l_msg
      #MOD-C50020---E---
       LET g_success = 'N' RETURN
    END IF
 
    #TQC-D50131--add--str--
    IF g_sma.sma115 = 'Y' THEN
       DECLARE t600sub_s1_c2_1 CURSOR FOR SELECT * FROM ogb_file
         WHERE ogb01 = l_oga.oga01
       FOREACH t600sub_s1_c2_1 INTO l_ogb.*
          IF STATUS THEN
             EXIT FOREACH
          END IF
 
          SELECT ima906 INTO l_ima906 FROM ima_file  
           WHERE ima01=l_ogb.ogb04                 
          IF l_ima906 = '2' THEN  #子母單位         
             LET l_unit_arr[1].unit= l_ogb.ogb910
             LET l_unit_arr[1].fac = l_ogb.ogb911
             LET l_unit_arr[1].qty = l_ogb.ogb912
             LET l_unit_arr[2].unit= l_ogb.ogb913
             LET l_unit_arr[2].fac = l_ogb.ogb914
             LET l_unit_arr[2].qty = l_ogb.ogb915
             CALL s_dismantle_1(l_oga.oga01,l_ogb.ogb03,l_oga.oga02,
                             l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,
                             l_ogb.ogb092,l_unit_arr,l_imm01)
                  RETURNING l_imm01
             IF g_success='N' THEN    
                LET g_totsuccess='N'
                LET g_success="Y"
                CONTINUE FOREACH
             END IF
          END IF
       END FOREACH
    END IF
    #TQC-D50131--add--end--

    CALL s_upimgg(p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,p_type,p_imgg10,l_oga.oga02, #FUN-8C0084
          '','','','','','','','','','',l_imgg21,'','','','','','','',p_imgg211)
    IF g_success='N' THEN RETURN END IF
 
END FUNCTION
 
FUNCTION t600sub_tlff(p_flag,p_item,p_ware,p_loc,p_lot,p_unit,p_fac,p_qty,l_oga,l_ogb,p_type)   #No:FUN-BB0081
DEFINE
   p_flag     LIKE type_file.chr1,     #No.FUN-680137 VARCHAR(1)
   p_item     LIKE ima_file.ima01,
   p_ware     LIKE img_file.img02,
   p_loc      LIKE img_file.img03,
   p_lot      LIKE img_file.img04,
   p_unit     LIKE img_file.img09,
   p_fac      LIKE img_file.img21,
   p_qty      LIKE img_file.img10,
   l_ogb      RECORD LIKE ogb_file.*,
   p_type     LIKE type_file.chr1,    #No:FUN-BB0081  1.多單位多倉儲出貨
   p_lineno   LIKE ogb_file.ogb03,
   l_imgg10   LIKE imgg_file.imgg10,
   l_ima86    LIKE ima_file.ima86,  #FUN-730018
   l_oga      RECORD LIKE oga_file.*
DEFINE l_argv0 LIKE ogb_file.ogb09 #FUN-C40072 add

   LET l_argv0=l_oga.oga09 #FUN-C40072 add
 
   INITIALIZE g_tlff.* TO NULL
   SELECT imgg10 INTO l_imgg10 FROM imgg_file
    WHERE imgg01=p_item  AND imgg02=p_ware
      AND imgg03=p_loc   AND imgg04=p_lot
      AND imgg09=p_unit
   IF cl_null(l_imgg10) THEN LET l_imgg10=0 END IF
   SELECT ima86 INTO l_ima86 FROM ima_file
                            WHERE ima01=p_item
   #----來源----
   LET g_tlff.tlff01=p_item              #異動料件編號
   LET g_tlff.tlff02=50                  #'Stock'
   LET g_tlff.tlff020=l_ogb.ogb08
   LET g_tlff.tlff021=p_ware             #倉庫
   LET g_tlff.tlff022=p_loc              #儲位
   LET g_tlff.tlff023=p_lot              #批號
   LET g_tlff.tlff024=l_imgg10           #異動後數量
   LET g_tlff.tlff025=p_unit             #庫存單位(ima_file or img_file)
   LET g_tlff.tlff026=l_ogb.ogb01        #出貨單號
   LET g_tlff.tlff027=l_ogb.ogb03        #出貨項次
   #---目的----
   LET g_tlff.tlff03=724
   LET g_tlff.tlff030=' '
   LET g_tlff.tlff031=' '                #倉庫
   LET g_tlff.tlff032=' '                #儲位
   LET g_tlff.tlff033=' '                #批號
   LET g_tlff.tlff034=' '                #異動後庫存數量
   LET g_tlff.tlff035=' '                #庫存單位(ima_file or img_file)
   LET g_tlff.tlff036=l_ogb.ogb31        #訂單單號
   LET g_tlff.tlff037=l_ogb.ogb32        #訂單項次
 
   #-->異動數量
   LET g_tlff.tlff04= ' '             #工作站
   LET g_tlff.tlff05= ' '             #作業序號
   LET g_tlff.tlff06=l_oga.oga02      #發料日期
   LET g_tlff.tlff07=g_today          #異動資料產生日期
   LET g_tlff.tlff08=TIME             #異動資料產生時:分:秒
   LET g_tlff.tlff09=g_user           #產生人
   LET g_tlff.tlff10=p_qty            #異動數量
   LET g_tlff.tlff11=p_unit           #發料單位
   LET g_tlff.tlff12=p_fac            #發料/庫存 換算率
#MOD-D20054---begin mark
##FUN-C40072---add---START
#   IF l_argv0 = '4' THEN
#      LET g_tlff.tlff13='axmt820'
#   ELSE
##FUN-C40072---add-----END
#MOD-D20054---end
      LET g_tlff.tlff13='axmt620'
#   END IF #FUN-C40072 add  #MOD-D20054
   LET g_tlff.tlff14=' '              #異動原因
 
   LET g_tlff.tlff17=' '              #非庫存性料件編號
   CALL s_imaQOH(l_ogb.ogb04)
        RETURNING g_tlff.tlff18
   LET g_tlff.tlff19=l_oga.oga04
   LET g_tlff.tlff20 = l_oga.oga46
   LET g_tlff.tlff61= l_ima86 #FUN-730018
   LET g_tlff.tlff62=l_ogb.ogb31    #參考單號(訂單)    #FUN-730012
   LET g_tlff.tlff63=l_ogb.ogb32    #訂單項次          #FUN-730012
   LET g_tlff.tlff64=l_ogb.ogb908   #手冊編號 no.A050  #FUN-730012
   LET g_tlff.tlff66=p_flag         #for axcp500多倉出貨處理   #No:8741
   LET g_tlff.tlff930=l_ogb.ogb930 #FUN-670063  #FUN-730012
   IF p_type = "1" THEN   #No:FUN-BB0081
      CALL s_tlff(p_flag,NULL)   #No:FUN-BB0081
   ELSE   #No:FUN-BB0081
      IF cl_null(l_ogb.ogb915) OR l_ogb.ogb915=0 THEN
         CALL s_tlff(p_flag,NULL)
      ELSE
         CALL s_tlff(p_flag,l_ogb.ogb913)
      END IF
   END IF   #No:FUN-BB0081
END FUNCTION
 
 
FUNCTION t600sub_update(p_ware,p_loca,p_lot,p_qty,p_uom,p_factor,p_qty2,p_flag,p_item,l_oga,l_ogb) #No:8741  #FUN-5C0075 #FUN-730012
  DEFINE l_oeb19   LIKE oeb_file.oeb19
#  DEFINE l_ima262  LIKE ima_file.ima262 #FUN-A20044
  DEFINE l_avl_stk  LIKE type_file.num15_3 #FUN-A20044
  DEFINE l_oeb12   LIKE oeb_file.oeb12
  DEFINE l_qoh     LIKE oeb_file.oeb12
  DEFINE p_flag    LIKE type_file.chr1                      #No:8741  #No.FUN-680137 VARCHAR(1)
  DEFINE p_ware    LIKE ogb_file.ogb09,       ##倉庫
         p_loca    LIKE ogb_file.ogb091,      ##儲位
         p_lot     LIKE ogb_file.ogb092,      ##批號
         p_qty     LIKE ogc_file.ogc12,       ##銷售數量(銷售單位)
         p_qty2    LIKE ogc_file.ogc16,       ##銷售數量(img 單位)
         p_uom     LIKE ima_file.ima31,       ##銷售單位
         p_factor  LIKE ogb_file.ogb15_fac,   ##轉換率
         p_item    LIKE ogc_file.ogc17,       #FUN-5C0075
         l_qty     LIKE ogc_file.ogc12,       ##異動後數量
         l_ima01   LIKE ima_file.ima01,
         l_ima25   LIKE ima_file.ima25,
         l_img     RECORD
                   img10   LIKE img_file.img10,
                   img16   LIKE img_file.img16,
                   img23   LIKE img_file.img23,
                   img24   LIKE img_file.img24,
                   img09   LIKE img_file.img09,
                   img18   LIKE img_file.img18,  #No.MOD-480401
                   img21   LIKE img_file.img21
                   END RECORD,
         l_cnt     LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE l_oga     RECORD LIKE oga_file.*,
         l_ogb     RECORD LIKE ogb_file.*
  DEFINE l_ima86   LIKE ima_file.ima86 #FUN-730018
  DEFINE l_msg     LIKE type_file.chr1000
 
    IF cl_null(p_ware) THEN LET p_ware=' ' END IF
    IF cl_null(p_loca) THEN LET p_loca=' ' END IF
    IF cl_null(p_lot)  THEN LET p_lot=' ' END IF
    IF cl_null(p_qty)  THEN LET p_qty=0 END IF
    IF cl_null(p_qty2) THEN LET p_qty2=0 END IF
#FUN-AB0011 -------------------------STA
 #  聯營及非企業料號不異動 img 及 tlf
    IF s_joint_venture( p_item,g_plant) OR NOT s_internal_item( p_item,g_plant ) THEN
       RETURN
    END IF
#FUN-AB0011 -------------------------END
    IF p_uom IS NULL THEN
       CALL cl_err('p_uom null:','axm-186',1) LET g_success = 'N' RETURN
    END IF
 
    LET g_forupd_sql ="SELECT img10,img16,img23,img24,img09,img18,img21 ", #No.MOD-480401
                       " FROM img_file ",
                      " WHERE img01= ?  AND img02= ? AND img03= ? ",
                      " AND img04= ?   FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE img_lock CURSOR FROM g_forupd_sql
 
    OPEN img_lock USING p_item,p_ware,p_loca,p_lot #FUN-5C0075
    IF STATUS THEN
       CALL cl_err("OPEN img_lock:", STATUS, 1)
       CLOSE img_lock
       LET g_success = 'N'  #No.MOD-8A0208 add
       RETURN
    END IF
 
    FETCH img_lock INTO l_img.*
    IF STATUS THEN
       CLOSE img_lock    #TQC-930155 add
       CALL cl_err('lock img fail',STATUS,1) LET g_success='N' RETURN
    END IF
 
    IF l_img.img18 < l_oga.oga02 THEN
       CALL cl_err(l_ogb.ogb04,'aim-400',1)   #須修改
       LET g_success='N' RETURN
    END IF
 
    IF cl_null(l_img.img10) THEN LET l_img.img10=0 END IF
    LET l_qty= l_img.img10 - p_qty2
 
    #--訂單備置為'N',須check(庫存量ima262-sum(備置量oeb12-oeb24))>出貨量
    IF NOT cl_null(l_ogb.ogb31) AND NOT cl_null(l_ogb.ogb32) THEN
       SELECT oeb19 INTO l_oeb19 FROM oeb_file
        WHERE oeb01=l_ogb.ogb31 AND oeb03 = l_ogb.ogb32
       IF STATUS THEN
          CALL cl_err3("sel","oeb_file",l_ogb.ogb31,l_ogb.ogb32,SQLCA.sqlcode,"","sel oeb:",1)  #No.FUN-670008
          LET g_success='N' RETURN
       END IF
 
       IF p_qty2 > l_img.img10 THEN
          LET g_flag2 = NULL    #FUN-C80107 add
         #CALL s_inv_shrt_by_warehouse(g_sma.sma894[2,2],p_ware) RETURNING g_flag2   #FUN-C80107 add #FUN-D30024
          CALL s_inv_shrt_by_warehouse(p_ware,g_plant) RETURNING g_flag2                     #FUN-D30024 add  #TQC-D40078 g_plant
         #IF g_sma.sma894[2,2]='N' THEN   #FUN-C80107 mark
          IF g_flag2 = 'N' OR g_flag2 IS NULL THEN           #FUN-C80107 add
             IF g_bgerr THEN
                CALL s_errmsg('ima01',p_item,l_msg,'mfg-026',1)
             ELSE
                CALL cl_err(l_msg,'mfg-026',1)
             END IF
             LET g_success='N' RETURN
          END IF
       END IF
        #MOD-4A0232(end)
    END IF
 
 
   #IF NOT s_stkminus(p_item,p_ware,p_loca,p_lot,p_qty,p_factor,l_oga.oga02,g_sma.sma894[2,2]) THEN  #FUN-5C0075 #FUN-D30024
    IF NOT s_stkminus(p_item,p_ware,p_loca,p_lot,p_qty,p_factor,l_oga.oga02) THEN                    #FUN-D30024 add
       LET g_success='N'
       RETURN
    END IF
 
    CALL s_upimg(p_item,p_ware,p_loca,p_lot,-1,p_qty2,g_today, #FUN-8C0084
          '','','','',l_ogb.ogb01,l_ogb.ogb03,'','','','','','','','','','','','')  #No.FUN-850100
    IF g_success='N' THEN
       CALL cl_err('s_upimg()','9050',0) RETURN
    END IF
 
    #Update ima_file
    LET g_forupd_sql = "SELECT ima25,ima86 FROM ima_file ",
                       " WHERE ima01= ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE ima_lock CURSOR FROM g_forupd_sql
 
    OPEN ima_lock USING p_item   #FUN-5C0075
    IF STATUS THEN
       CALL cl_err("OPEN ima_lock:", STATUS, 1)
       CLOSE ima_lock
       LET g_success = 'N'  #No.MOD-8A0208 add
       RETURN
    END IF
 
    FETCH ima_lock INTO l_ima25,l_ima86 #FUN-730018
    IF STATUS THEN
       CLOSE ima_lock   #TQC-930155 add
       CALL cl_err('lock ima fail',STATUS,1) LET g_success='N' RETURN
    END IF
 
   #料件編號 是否可用倉儲 是否為MRP可用倉儲 發料量
    Call s_udima(p_item,l_img.img23,l_img.img24,p_qty2,  #FUN-5C0075 
                 #g_today,-1)  RETURNING l_cnt   #MOD-920298
                 l_oga.oga02,-1)  RETURNING l_cnt   #MOD-920298
   #最近一次發料日期 表發料
    IF l_cnt THEN
       CALL cl_err('Update Faile',SQLCA.SQLCODE,1)
       LET g_success='N' RETURN
    END IF
    IF g_success='Y' THEN                                                      #CHI-9C0009 mark #CHI-9C0037 remark 
       CALL t600sub_tlf(p_ware,p_loca,p_lot,l_ima25,p_qty,l_qty,p_uom,p_factor,p_flag,p_item,l_ima86,l_oga.*,l_ogb.*) #No:8741  #FUN-5C0075
    END IF
END FUNCTION
 
FUNCTION t600sub_tlf(p_ware,p_loca,p_lot,p_unit,p_qty,p_img10,p_uom,p_factor,p_flag,p_item,l_ima86,l_oga,l_ogb) #No:8741  #FUN-5C0075
   DEFINE
      p_ware     LIKE ogb_file.ogb09,       ##倉庫
      p_loca     LIKE ogb_file.ogb091,      ##儲位
      p_lot      LIKE ogb_file.ogb092,      ##批號
      p_qty      LIKE ogc_file.ogc12,       ##銷售數量(銷售單位)
      p_uom      LIKE ima_file.ima31,       ##銷售單位
      p_factor   LIKE ogb_file.ogb15_fac,   ##轉換率
      p_unit     LIKE ima_file.ima25,       ##單位
      p_img10    LIKE img_file.img10,     ##異動後數量
      p_item     LIKE img_file.img01,     #FUN-5C0075
      l_sfb02    LIKE sfb_file.sfb02,
      l_sfb03    LIKE sfb_file.sfb03,
      l_sfb04    LIKE sfb_file.sfb04,
      l_sfb22    LIKE sfb_file.sfb22,
      l_sfb27    LIKE sfb_file.sfb27,
      l_sta      LIKE type_file.num5,    #No.FUN-680137 SMALLINT
      l_cnt      LIKE type_file.num5,    #No.FUN-680137 SMALLINT
      p_flag     LIKE type_file.chr1,     #No:8741  #No.FUN-680137 VARCHAR(1)
      l_ima86    LIKE ima_file.ima86,    #FUN-730018
      l_oga      RECORD LIKE oga_file.*,
      l_ogb      RECORD LIKE ogb_file.*
DEFINE l_argv0 LIKE ogb_file.ogb09 #FUN-C40072 add

   LET l_argv0=l_oga.oga09 #FUN-C40072 add
   #----來源----
   LET g_tlf.tlf01=p_item              #異動料件編號
   LET g_tlf.tlf02=50                  #'Stock'
   LET g_tlf.tlf020=l_ogb.ogb08
   LET g_tlf.tlf021=p_ware             #倉庫

#CHI-B60054  --Begin #MARK掉CHI-B30093更改
#CHI-B30093 --begin--
#   IF g_prog = 'axmt628' THEN 
#     LET g_tlf.tlf021 = l_ogb.ogb09
#   END IF 
#CHI-B30093 --end--  
#CHI-B60054  --End #MARK掉CHI-B30093更改
   
   LET g_tlf.tlf022=p_loca             #儲位
   LET g_tlf.tlf023=p_lot              #批號
   LET g_tlf.tlf024=p_img10            #異動後數量
   LET g_tlf.tlf025=p_unit             #庫存單位(ima_file or img_file)
   LET g_tlf.tlf026=l_ogb.ogb01        #出貨單號
   LET g_tlf.tlf027=l_ogb.ogb03        #出貨項次
   #---目的----
   LET g_tlf.tlf03=724
   LET g_tlf.tlf030=' '
   LET g_tlf.tlf031=' '                #倉庫
   LET g_tlf.tlf032=' '                #儲位
   LET g_tlf.tlf033=' '                #批號
   LET g_tlf.tlf034=' '                #異動後庫存數量
   LET g_tlf.tlf035=' '                #庫存單位(ima_file or img_file)
   LET g_tlf.tlf036=l_ogb.ogb31        #訂單單號
   LET g_tlf.tlf037=l_ogb.ogb32        #訂單項次
   #-->異動數量
   LET g_tlf.tlf04= ' '             #工作站
   LET g_tlf.tlf05= ' '             #作業序號
   LET g_tlf.tlf06=l_oga.oga02      #發料日期
   LET g_tlf.tlf07=g_today          #異動資料產生日期
   LET g_tlf.tlf08=TIME             #異動資料產生時:分:秒
   LET g_tlf.tlf09=g_user           #產生人
   LET g_tlf.tlf10=p_qty            #異動數量
   LET g_tlf.tlf11=p_uom			#發料單位
   LET g_tlf.tlf12 =p_factor        #發料/庫存 換算率
   IF cl_null(l_ogb.ogb31) THEN     #FUN-BB0167 add
      LET g_tlf.tlf13='axmt650'     #FUN-BB0167 add
   ELSE                             #FUN-BB0167 add
#MOD-D20054---begin mark
#   #FUN-C40072---add---START
#      IF l_argv0 = '4' THEN
#         LET g_tlf.tlf13='axmt820'
#      ELSE
#   #FUN-C40072---add-----END
#MOD-D20054---end
         LET g_tlf.tlf13='axmt620'
#      END IF #FUN-C40072 add  #MOD-D20054
   END IF                           #FUN-BB0167 add
   LET g_tlf.tlf14=l_ogb.ogb1001   #No.FUN-660073
 
   LET g_tlf.tlf17=' '              #非庫存性料件編號
   CALL s_imaQOH(l_ogb.ogb04)
        RETURNING g_tlf.tlf18
   LET g_tlf.tlf19=l_oga.oga03 #No.MOD-870252
   LET g_tlf.tlf20 = l_oga.oga46
   LET g_tlf.tlf61= l_ima86 #FUN-730018
   LET g_tlf.tlf62=l_ogb.ogb31    #參考單號(訂單)
   LET g_tlf.tlf63=l_ogb.ogb32    #訂單項次
   LET g_tlf.tlf64=l_ogb.ogb908   #手冊編號 no.A050
   LET g_tlf.tlf66=p_flag         #for axcp500多倉出貨處理   #No:8741
   LET g_tlf.tlf930=l_ogb.ogb930  #FUN-670063
   LET g_tlf.tlf20 = l_ogb.ogb41
   LET g_tlf.tlf41 = l_ogb.ogb42
   LET g_tlf.tlf42 = l_ogb.ogb43
   LET g_tlf.tlf43 = l_ogb.ogb1001
   CALL s_tlf(1,0)
END FUNCTION
 
#FUNCTION t600sub_consign(p_ware,p_loca,p_lot,p_qty,p_uom,p_factor,p_qty2,l_oga,l_ogb)  #No.FUN-630061 #CHI-AC0034 mark
FUNCTION t600sub_consign(p_ware,p_loca,p_lot,p_qty,p_uom,p_factor,p_qty2,p_flag,p_item,l_oga,l_ogb)  #CHI-AC0034
  DEFINE p_ware   LIKE ogb_file.ogb09,       ##倉庫
         l_ogb    RECORD LIKE ogb_file.*,    #No.FUN-630061
         p_loca   LIKE ogb_file.ogb091,      ##儲位
         p_lot    LIKE ogb_file.ogb092,      ##批號
         p_qty    LIKE ogc_file.ogc12,       ##銷售數量(銷售單位)
         p_qty2   LIKE ogc_file.ogc16,       ##銷售數量(img 單位)
         l_qty2   LIKE ogc_file.ogc16,       ##銷售數量(img 單位)
         p_uom    LIKE ima_file.ima31,       ##銷售單位
         p_factor LIKE ogb_file.ogb15_fac,   ##轉換率
         l_factor LIKE ogb_file.ogb15_fac,   ##轉換率
         l_qty    LIKE ogc_file.ogc12,       ##異動後數量
         l_cnt    LIKE type_file.num5,    #No.FUN-680137 SMALLINT
         l_ima01  LIKE ima_file.ima01,
         l_ima25  LIKE ima_file.ima25,
         p_img    RECORD LIKE img_file.*,
         l_img    RECORD
                  img10   LIKE img_file.img10,
                  img16   LIKE img_file.img16,
                  img23   LIKE img_file.img23,
                  img24   LIKE img_file.img24,
                  img09   LIKE img_file.img09,
                  img21   LIKE img_file.img21
                  END RECORD
   DEFINE l_oeb19   LIKE oeb_file.oeb19
#   DEFINE l_ima262  LIKE ima_file.ima262 #FUN-A20044
   DEFINE l_avl_stk  LIKE type_file.num15_3 #FUN-A20044
   DEFINE l_oeb12   LIKE oeb_file.oeb12
   DEFINE l_qoh     LIKE oeb_file.oeb12
   DEFINE l_ima71   LIKE type_file.num5    #No.FUN-680137 SMALLINT
   DEFINE l_ima86   LIKE ima_file.ima86  #FUN-730018
   DEFINE l_oga   RECORD LIKE oga_file.*
   DEFINE p_flag    LIKE type_file.chr1   #CHI-AC0034 add
   DEFINE p_item    LIKE ogc_file.ogc17   #CHI-AC0034 add
   DEFINE l_msg   STRING                 #MOD-C50020
 
    IF cl_null(p_ware) THEN LET p_ware=' ' END IF
    IF cl_null(p_loca) THEN LET p_loca=' ' END IF
    IF cl_null(p_lot)  THEN LET p_lot=' ' END IF
    IF cl_null(p_qty)  THEN LET p_qty=0 END IF
    IF cl_null(p_qty2) THEN LET p_qty2=0 END IF

    SELECT * INTO p_img.* FROM img_file
    #WHERE img01= l_ogb.ogb04 AND img02= p_ware  #No.FUN-630061 #CHI-AC0034 mark
     WHERE img01= p_item AND img02= p_ware  #CHI-AC0034
       AND img03= p_loca AND img04= p_lot
    IF STATUS <> 0 THEN            ## 新增一筆img_file
       INITIALIZE p_img.* TO NULL
      #LET p_img.img01=l_ogb.ogb04   #No.FUN-630061 #CHI-AC0034 mark
       LET p_img.img01=p_item        #CHI-AC0034
       LET p_img.img02=p_ware
       LET p_img.img03=p_loca
       LET p_img.img04=p_lot
       LET p_img.img05=l_ogb.ogb01  #No.FUN-630061
       LET p_img.img06=l_ogb.ogb03  #No.FUN-630061
       SELECT ima25 INTO p_img.img09 FROM ima_file WHERE ima01=p_img.img01
       LET p_img.img10=0
       LET p_img.img13=null   #No:7304
       LET p_img.img17=g_today
       IF g_prog[1,7] = 'axmt628' THEN #MOD-CA0048 add
          LET p_img.img18=MDY(12,31,9999)
       #MOD-CA0048 add start -----
       ELSE
          SELECT img18 INTO p_img.img18 FROM img_file
           WHERE img01 = l_ogb.ogb01 AND img02 = l_ogb.ogb09
             AND img03 = l_ogb.ogb091 AND img04 = l_ogb.ogb092
          IF STATUS THEN
             LET p_img.img18=MDY(12,31,9999)
          END IF
       END IF
       #MOD-CA0048 add end   -----
       LET p_img.img21=1
       LET p_img.img22='S'
       LET p_img.img37=l_oga.oga02   #MOD-9B0077
       SELECT imd10,imd11,imd12,imd13 INTO
              p_img.img22, p_img.img23, p_img.img24, p_img.img25
         FROM imd_file WHERE imd01=p_img.img02
       LET p_img.img30=0
       LET p_img.img31=0
       LET p_img.img32=0
       LET p_img.img33=0
       LET p_img.img34=1
       IF p_img.img02 IS NULL THEN LET p_img.img02 = ' ' END IF
       IF p_img.img03 IS NULL THEN LET p_img.img03 = ' ' END IF
       IF p_img.img04 IS NULL THEN LET p_img.img04 = ' ' END IF
 
       LET p_img.imgplant = g_plant 
       LET p_img.imglegal = g_legal 
 
       INSERT INTO img_file VALUES (p_img.*)
       IF STATUS OR SQLCA.SQLCODE THEN
          CALL cl_err3("ins","img_file","","",SQLCA.sqlcode,"","ins img:",1)  #No.FUN-670008
          LET g_success='N' RETURN
       END IF
    END IF
   #CALL s_umfchk(l_ogb.ogb04,p_uom,p_img.img09) RETURNING l_cnt,l_factor  #No.FUN-630061 #CHI-AC0034 mark
    CALL s_umfchk(p_item,p_uom,p_img.img09) RETURNING l_cnt,l_factor  #CHI-AC0034
    IF l_cnt = 1 THEN
       CALL cl_err('','mfg3075',0)
      #MOD-C50020---S---
       CALL cl_getmsg('asf-176',g_lang) RETURNING l_msg
       LET l_msg = l_msg CLIPPED,":",p_item
       CALL cl_err(l_msg,'mfg3075',0)   #MOD-C50020 add l_msg
      #MOD-C50020---E---
       LET g_success='N' RETURN
    END IF
    LET l_qty2=p_qty*l_factor
 
    LET g_forupd_sql = "SELECT img10,img16,img23,img24,img09,img21 ",
                       " FROM img_file ",
                       "  WHERE img01= ?  AND img02= ? AND img03= ? ",
                       " AND img04= ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE img_lock1 CURSOR FROM g_forupd_sql
 
   #OPEN img_lock1 USING l_ogb.ogb04,p_ware,p_loca,p_lot  #No.FUN-630061 #CHI-AC0034 mark
    OPEN img_lock1 USING p_item,p_ware,p_loca,p_lot  #CHI-AC0034
    IF STATUS THEN
       CALL cl_err("OPEN img_lock:", STATUS, 1)
       CLOSE img_lock1      #No.MOD-8A0208 add
       LET g_success = 'N'  #No.MOD-8A0208 add
       RETURN
    END IF
 
    FETCH img_lock1 INTO l_img.*
    IF STATUS THEN
       CLOSE img_lock1    #TQC-930155 add
       CALL cl_err('lock img fail',STATUS,1) LET g_success='N' RETURN
    END IF
    IF cl_null(l_img.img10) THEN LET l_img.img10=0 END IF
 
   #CALL s_upimg(l_ogb.ogb04,p_ware,p_loca,p_lot,1,l_qty2,g_today, #FUN-8C0084 #CHI-AC0034 mark
    CALL s_upimg(p_item,p_ware,p_loca,p_lot,1,l_qty2,g_today, #CHI-AC0034
          '','','','',l_ogb.ogb01,l_ogb.ogb03,'','','','','','','','','','','','')  #No.FUN-850100
    IF g_success='N' THEN
       CALL cl_err('s_upimg()',SQLCA.SQLCODE,1) RETURN
    END IF

    #Update ima_file
    LET g_forupd_sql = "SELECT ima25,ima86 FROM ima_file ",
                       " WHERE ima01= ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE ima_lock1 CURSOR FROM g_forupd_sql
 
   #OPEN ima_lock1 USING l_ogb.ogb04  #No.FUN-630061 #CHI-AC0034 mark
    OPEN ima_lock1 USING p_item  #CHI-AC0034
    IF STATUS THEN
       CALL cl_err("OPEN ima_lock:", STATUS, 1)
       CLOSE ima_lock1
       LET g_success='N'
       RETURN
    END IF
 
    FETCH ima_lock1 INTO l_ima25,l_ima86 #FUN-730018
    IF STATUS THEN
       CALL cl_err('lock ima fail',STATUS,1)
       CLOSE ima_lock1
       LET g_success='N'
       RETURN
    END IF
 
   #料件編號 是否可用倉儲 是否為MRP可用倉儲 發料量
   #Call s_udima(l_ogb.ogb04,l_img.img23,l_img.img24,l_qty2*l_img.img21,  #No.FUN-630061 #CHI-AC0034 mark
    Call s_udima(p_item,l_img.img23,l_img.img24,l_qty2*l_img.img21,  #CHI-AC0034
                 #g_today,1)  RETURNING l_cnt   #MOD-920298
                 l_oga.oga02,1)  RETURNING l_cnt   #MOD-920298
 
   #最近一次發料日期 表發料
    IF l_cnt THEN
       CALL cl_err('Update Faile',SQLCA.SQLCODE,1)
       LET g_success='N' RETURN
    END IF
 
    IF g_success='Y' THEN
      #CALL t600sub_contlf(p_ware,p_loca,p_lot,l_ima25,p_qty,l_qty2,p_uom,l_factor,l_oga.*,l_ogb.*,l_ima86)  #No.FUN-630061 #CHI-AC0034 mark
       CALL t600sub_contlf(p_ware,p_loca,p_lot,l_ima25,p_qty,l_qty2,p_uom,l_factor,p_flag,p_item,l_oga.*,l_ogb.*,l_ima86)  #CHI-AC0034
    END IF
 
END FUNCTION
 
#FUNCTION t600sub_contlf(p_ware,p_loca,p_lot,p_unit,p_qty,p_img10,p_uom,p_factor,l_oga,l_ogb,l_ima86)    #No.FUN-630061 #CHI-AC0034 mark
FUNCTION t600sub_contlf(p_ware,p_loca,p_lot,p_unit,p_qty,p_img10,p_uom,p_factor,p_flag,p_item,l_oga,l_ogb,l_ima86)    #CHI-AC0034
   DEFINE
      p_ware     LIKE ogb_file.ogb09,       ##倉庫
      l_ogb      RECORD LIKE ogb_file.*,    #No.FUN-630061
      p_loca     LIKE ogb_file.ogb091,      ##儲位
      p_lot      LIKE ogb_file.ogb092,      ##批號
      p_qty      LIKE ogc_file.ogc12,       ##銷售數量(銷售單位)
      p_uom      LIKE ima_file.ima31,       ##銷售單位
      p_factor   LIKE ogb_file.ogb15_fac,   ##轉換率
      p_unit     LIKE ima_file.ima25,       ##單位
      p_img10    LIKE img_file.img10,       #異動後數量
      l_sfb02    LIKE sfb_file.sfb02,
      l_sfb03    LIKE sfb_file.sfb03,
      l_sfb04    LIKE sfb_file.sfb04,
      l_sfb22    LIKE sfb_file.sfb22,
      l_sfb27    LIKE sfb_file.sfb27,
      l_sta      LIKE type_file.num5,    #No.FUN-680137 SMALLINT
      l_cnt      LIKE type_file.num5     #No.FUN-680137 SMALLINT
   DEFINE l_argv0 LIKE ogb_file.ogb09
   DEFINE l_ima86 LIKE ima_file.ima86 #FUN-730018
   DEFINE l_oga RECORD LIKE oga_file.*
   DEFINE p_item LIKE img_file.img01 #CHI-AC0034 add
   DEFINE p_flag LIKE type_file.chr1 #CHI-AC0034 add
   
   LET l_argv0=l_oga.oga09  #FUN-730012
   #----來源----
  #LET g_tlf.tlf01=l_ogb.ogb04         #異動料件編號  #No.FUN-630061 #CHI-AC0034 mark
   LET g_tlf.tlf01=p_item              #異動料件編號  #CHI-AC0034
   LET g_tlf.tlf02=724
   LET g_tlf.tlf020=' '
   LET g_tlf.tlf021=' '                #倉庫
   LET g_tlf.tlf022=' '                #儲位
   LET g_tlf.tlf023=' '                #批號
   LET g_tlf.tlf024=' '                #異動後庫存數量
   LET g_tlf.tlf025=' '                #庫存單位(ima_file or img_file)
   LET g_tlf.tlf026=l_ogb.ogb31        #出貨單號  #No.FUN-630061
   LET g_tlf.tlf027=l_ogb.ogb32        #出貨項次   #No.FUN-630061
   #---目的----
   LET g_tlf.tlf03=50                  #'Stock'
   LET g_tlf.tlf030=l_ogb.ogb08  #No.FUN-630061
   LET g_tlf.tlf031=p_ware             #倉庫
   LET g_tlf.tlf032=p_loca             #儲位
   LET g_tlf.tlf033=p_lot              #批號
   #LET g_tlf.tlf904 = p_lot             #CHI-B30093 #CHI-B60054 mark CHI-B30093
   LET g_tlf.tlf034=p_img10            #異動後數量
   LET g_tlf.tlf035=p_unit             #庫存單位(ima_file or img_file)
   LET g_tlf.tlf036=l_ogb.ogb01        #訂單單號  #No.FUN-630061
   LET g_tlf.tlf037=l_ogb.ogb03        #訂單項次   #No.FUN-630061
   #-->異動數量
   LET g_tlf.tlf04= ' '             #工作站
   LET g_tlf.tlf05= ' '             #作業序號
   LET g_tlf.tlf06=l_oga.oga02      #發料日期
   LET g_tlf.tlf07=g_today          #異動資料產生日期
   LET g_tlf.tlf08=TIME             #異動資料產生時:分:秒
   LET g_tlf.tlf09=g_user           #產生人
   LET g_tlf.tlf10=p_qty            #異動數量
   LET g_tlf.tlf11=p_uom	    #發料單位
   LET g_tlf.tlf12 =p_factor        #發料/庫存 換算率
   IF cl_null(l_ogb.ogb31) THEN     #FUN-BB0167 add
      LET g_tlf.tlf13='axmt650'     #FUN-BB0167 add
   ELSE                             #FUN-BB0167 add
#MOD-D20054---begin mark
#   #FUN-C40072---add---START
#      IF l_argv0 = '4' THEN
#         LET g_tlf.tlf13='axmt820'
#      ELSE
#   #FUN-C40072---add-----END
#MOD-D20054---end
         LET g_tlf.tlf13='axmt620'
#      END IF #FUN-C40072 add  #MOD-D20054
   END IF                           #FUN-BB0167 add
   LET g_tlf.tlf14=l_ogb.ogb1001    #異動原因   #MOD-870120
 
   LET g_tlf.tlf17='To Consign Warehouse'
  #IF l_argv0 = '2' AND l_oga.oga65 = 'Y' THEN #FUN-730012 #FUN-C40072 mark
   IF l_argv0 MATCHES '[2,4]' AND l_oga.oga65 = 'Y' THEN   #FUN-C40072 add
      LET g_tlf.tlf17='To On-Check Warehouse'
   END IF
   CALL s_imaQOH(l_ogb.ogb04)  #No.FUN-630061
        RETURNING g_tlf.tlf18
   LET g_tlf.tlf19=l_oga.oga03 #No.MOD-870252
   LET g_tlf.tlf20 = l_oga.oga46
   LET g_tlf.tlf61= l_ima86 #FUN-730018
   LET g_tlf.tlf62=l_ogb.ogb31    #參考單號(訂單)     #No.FUN-630061
   LET g_tlf.tlf63=l_ogb.ogb32    #訂單項次  #No.FUN-630061
   LET g_tlf.tlf64=l_ogb.ogb908   #手冊編號 no.A050  #No.FUN-630061
   LET g_tlf.tlf66=p_flag         #CHI-AC0034 add 
   LET g_tlf.tlf930=l_ogb.ogb930 #FUN-670063
   LET g_tlf.tlf20 = l_ogb.ogb41
   LET g_tlf.tlf41 = l_ogb.ogb42
   LET g_tlf.tlf42 = l_ogb.ogb43
   LET g_tlf.tlf43 = l_ogb.ogb1001

   IF g_prog[1,7] = 'axmt628' THEN   #FUN-B40066 add [1,7]
      #FUN-C50097 ADD BEG-------
      #产生发票仓tlf档案
      IF l_argv0 = '8' AND g_aza.aza26 = '2' THEN
         IF g_oaz.oaz92 = 'Y' AND g_oaz.oaz93 = 'Y' THEN
            LET g_tlf.tlf13='axmt628'
            LET g_tlf.tlf17='To Invoices Warehouse'
            LET g_tlf.tlf62=''    #參考單號(出貨簽收單) 
            LET g_tlf.tlf63=''    #出貨簽收單項次  
            LET g_tlf.tlf021= g_oaz.oaz95   #发票仓  
         END IF 
      END IF       
      #FUN-C50097 ADD END-------
      #LET g_prog = 'axmt629'  #FUN-B40066 mark
      #FUN-B40066 --START-- 
      IF s_industry('icd') THEN 
         LET g_prog = 'axmt629_icd'
      ELSE 
      LET g_prog = 'axmt629'
      END if 
      #FUN-B40066 --END--
      CALL s_tlf(1,0)
      #LET g_prog = 'axmt628'  #FUN-B40066 mark
      #FUN-B40066 --START-- 
      IF s_industry('icd') THEN 
         LET g_prog = 'axmt628_icd'
      ELSE 
      LET g_prog = 'axmt628'
      END if 
      #FUN-B40066 --END--      
   ELSE
      CALL s_tlf(1,0)
   END IF

END FUNCTION
 
FUNCTION t600sub_s_du(l_oga,l_ogb)
  DEFINE l_ima25   LIKE ima_file.ima25,
         u_type    LIKE type_file.num5,   #No.FUN-680137 SMALLINT
         l_ima906  LIKE ima_file.ima906,
         l_ima907  LIKE ima_file.ima907,
         l_oga     RECORD LIKE oga_file.*,
         l_ogb     RECORD LIKE ogb_file.*
 
   SELECT ima906,ima907,ima25
     INTO l_ima906,l_ima907,l_ima25
     FROM ima_file
    WHERE ima01 = l_ogb.ogb04
   IF SQLCA.sqlcode THEN
      LET g_success='N' RETURN
   END IF
   IF cl_null(l_ima906) OR l_ima906 = '1' THEN RETURN END IF
 
   IF l_ima906 = '2' THEN  #子母單位
      IF NOT cl_null(l_ogb.ogb913) THEN
         CALL t600sub_upd_imgg('1',l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,l_ogb.ogb913,l_ogb.ogb914,l_ogb.ogb915,-1,'2',l_oga.*)
         IF g_success='N' THEN RETURN END IF
         IF NOT cl_null(l_ogb.ogb915) THEN                                #CHI-960005
            CALL t600sub_tlff('2',l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,l_ogb.ogb913,l_ogb.ogb914,l_ogb.ogb915,l_oga.*,l_ogb.*,'2')   #No:FUN-BB0081
            IF g_success='N' THEN RETURN END IF
         END IF
      END IF
      IF NOT cl_null(l_ogb.ogb910) THEN
         CALL t600sub_upd_imgg('1',l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,l_ogb.ogb910,l_ogb.ogb911,l_ogb.ogb912,-1,'1',l_oga.*)
         IF g_success='N' THEN RETURN END IF
         IF NOT cl_null(l_ogb.ogb912) THEN                                #CHI-960005
            CALL t600sub_tlff('1',l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,l_ogb.ogb910,l_ogb.ogb911,l_ogb.ogb912,l_oga.*,l_ogb.*,'2')   #No:FUN-BB0081
            IF g_success='N' THEN RETURN END IF
         END IF
      END IF
   END IF
   IF l_ima906 = '3' THEN  #參考單位
      IF NOT cl_null(l_ogb.ogb913) THEN
         CALL t600sub_upd_imgg('2',l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,l_ogb.ogb913,l_ogb.ogb914,l_ogb.ogb915,-1,'2',l_oga.*)
         IF g_success='N' THEN RETURN END IF
         IF NOT cl_null(l_ogb.ogb915) THEN                                 #CHI-960005  
            CALL t600sub_tlff('2',l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,l_ogb.ogb913,l_ogb.ogb914,l_ogb.ogb915,l_oga.*,l_ogb.*,'2')   #No:FUN-BB0081
            IF g_success='N' THEN RETURN END IF
         END IF
      END IF
   END IF
 
END FUNCTION
 
FUNCTION t600_gen_return_note(l_oga)   #MOD-790150 modify l_oga
DEFINE l_oga     RECORD LIKE oga_file.*,
       l_ogb     RECORD LIKE ogb_file.*,
       l_ogbi    RECORD LIKE ogbi_file.*,#No.FUN-7C0017
       l_ogb12   LIKE ogb_file.ogb12,
       l_ogb915  LIKE ogb_file.ogb12,
       l_ogb912  LIKE ogb_file.ogb12,
       l_ogb917  LIKE ogb_file.ogb12,
       li_result LIKE type_file.num5,    #No.FUN-680137 SMALLINT
       l_cnt     LIKE type_file.num5,    #No.FUN-680137 SMALLINT
       tm        RECORD
                 oga01 LIKE oay_file.oayslip,  #No.FUN-680137 VARCHAR(5)
                 cware LIKE img_file.img02,
                 cloc  LIKE img_file.img03
                 END RECORD
DEFINE p_row,p_col LIKE type_file.num5
DEFINE l_t1      LIKE type_file.chr5
DEFINE p_oga01   LIKE oga_file.oga01    #MOD-790150
DEFINE l_rvbs     RECORD LIKE rvbs_file.*   #CHI-970040
DEFINE l_rvbs06a  LIKE rvbs_file.rvbs06     #CHI-970040
DEFINE l_rvbs06b  LIKE rvbs_file.rvbs06     #CHI-970040
DEFINE i          LIKE type_file.num5   #MOD-A10163
DEFINE l_msg      STRING                 #CHI-AC0034 add 
DEFINE l_tot1     LIKE ogc_file.ogc12    #CHI-AC0034 add
DEFINE l_flag     LIKE type_file.chr1    #CHI-AC0034 add
DEFINE l_ogc      RECORD LIKE ogc_file.* #CHI-AC0034 add
DEFINE l_ogc12    LIKE ogc_file.ogc12    #CHI-AC0034 add
DEFINE l_img09    LIKE img_file.img09    #CHI-AC0034 add
DEFINE l_idb      RECORD LIKE idb_file.*  #FUN-B40066
DEFINE l_ogg      RECORD LIKE ogg_file.*  #120725 FUN-C50097    

#DEFINE l_ogc_1    RECORD LIKE ogc_file.*     #CHI-B30093 #CHI-B60054 mark CHI-B30093
#DEFINE l_ogc12_1    LIKE ogc_file.ogc12   #TQC-B50099    #CHI-B60054 mark TQC-B50099
#DEFINE l_ogc09_1    LIKE ogc_file.ogc09   #TQC-B50099    #CHI-B60054 mark TQC-B50099
#DEFINE l_ogc091_1   LIKE ogc_file.ogc09   #TQC-B50099    #CHI-B60054 mark TQC-B50099 
   #檢查是否有驗退數量
   SELECT COUNT(*) INTO l_cnt
     FROM ogb_file b1,oga_file a1
    WHERE b1.ogb01 = l_oga.oga01
      AND a1.oga01 = b1.ogb01
      AND b1.ogb12 < (SELECT SUM(b2.ogb12) FROM oga_file a2,ogb_file b2
                       WHERE a2.oga01 = b2.ogb01
                        #AND a2.oga09 = '2'
                        #AND (a2.oga09 = '2' OR a2.oga09 = '3') #FUN-BB0167      #FUN-C40072 mark
                         AND (a2.oga09 = '2' OR a2.oga09 = '3' OR a2.oga09= '4') #FUN-C40072 add
                         AND a2.oga65 = 'Y'
                         AND a1.oga011 = a2.oga01
                         AND b1.ogb03 = b2.ogb03)
 
   IF l_cnt = 0 THEN RETURN END IF
 
   LET tm.oga01= NULL
   LET tm.cware=g_oaz.oaz76
   LET tm.cloc =g_oaz.oaz77
 
   LET p_row = 2 LET p_col = 39
 
   OPEN WINDOW t6281_w AT p_row,p_col WITH FORM "axm/42f/axmt6281"   #CHI-690060
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("axmt6281")   #CHI-690060
 
   INPUT BY NAME tm.oga01,tm.cware,tm.cloc WITHOUT DEFAULTS
 
      AFTER FIELD oga01
         IF NOT cl_null(tm.oga01) THEN
            CALL s_check_no("axm",tm.oga01,"","59","oga_file","oga01","")
                 RETURNING li_result,tm.oga01
            IF (NOT li_result) THEN
               NEXT FIELD oga01
            END IF
         END IF
 
      AFTER FIELD cware
         IF NOT cl_null(tm.cware) THEN
            SELECT * FROM imd_file
             WHERE imd01 = tm.cware
               AND imdacti = 'Y'
            IF STATUS <> 0 THEN
               CALL cl_err3("sel","imd_file",tm.cware,"","ams-004","","",1)  #No.FUN-670008
               NEXT FIELD cware
            END IF
 
            SELECT COUNT(*) INTO l_cnt FROM ogb_file
             WHERE ogb01 = l_oga.oga01
               AND ogb09 = tm.cware
            IF l_cnt > 0 THEN
               CALL cl_err('','axm-424',0)
               LET tm.cware=' '
               NEXT FIELD cware #No:8570
            END IF
            IF g_azw.azw04='2' THEN                                                                                                 
               LET l_cnt=0                                                                                                          
               SELECT COUNT(*) INTO l_cnt  FROM jce_file                                                                     
                WHERE jce02=tm.cware                                                                                                
               IF l_cnt !=0 THEN                                                                                             
                  CALL cl_err(tm.cware,'art-452',0)                                                                                 
                  NEXT FIELD cware                                                                                                  
               END IF                                                                                                               
               #No.FUN-AA0048  --Begin
               #LET l_cnt =0                                                                                                    
               #SELECT COUNT(*) INTO l_cnt FROM imd_file                                                                      
               # WHERE imd01=tm.cware                                                                                                
               #   AND imd20=g_plant                                                                                        
               #IF l_cnt=0 THEN                                                                                               
               #   CALL cl_err(tm.cware,'art-487',0)                                                                                 
               #   NEXT FIELD cware                                                                                                  
               #END IF                                                                                                               
               #No.FUN-AA0048  --End  
            END IF
            #No.FUN-AA0048  --Begin
            IF NOT s_chk_ware(tm.cware) THEN
               NEXT FIELD cware
            END IF
            #No.FUN-AA0048  --End  
         END IF
#FUN-D40103 -------Begin-------
         IF NOT s_imechk(tm.cware,tm.cloc) THEN
            NEXT FIELD cloc
         END IF
 #FUN-D40103 -------End---------
 
      AFTER FIELD cloc
         IF cl_null(tm.cloc) THEN   #FUN-630102 modify
            LET tm.cloc = ' '
         END IF
 #FUN-D40103 -------Begin------
       ##-----MOD-B40260---------
       ##start FUN-630102 mark
       #SELECT * FROM ime_file
       # WHERE ime01 = tm.cware
       #   AND ime02 = tm.cloc
       ##   AND ime04 = 'S'
       #IF STATUS <> 0 THEN
       #   CALL cl_err('','mfg0095',0)
       #   NEXT FIELD cloc
       #END IF
       ##end FUN-630102 mark
       ##-----END MOD-B40260-----
        IF NOT s_imechk(tm.cware,tm.cloc) THEN
           NEXT FIELD cloc
        END IF
  #FUN-D40103 -------End--------- 
 
         SELECT COUNT(*) INTO l_cnt FROM ogb_file
          WHERE ogb01  = l_oga.oga01
            AND ogb09 = tm.cware
            AND ogb091 = tm.cloc
         IF l_cnt > 0 THEN
            CALL cl_err('','axm-424',0)
            LET tm.cloc=' '
            NEXT FIELD cware
         END IF
 
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF

  #-----MOD-B40260---------
        IF cl_null(tm.cloc) THEN LET tm.cloc = ' ' END IF
     #FUN-D40103 -----Begin-----
      # #start FUN-630102 mark
      # SELECT * FROM ime_file
      #  WHERE ime01 = tm.cware
      #    AND ime02 = tm.cloc
      # #   AND ime04 = 'S'
      # IF STATUS <> 0 THEN
      #    CALL cl_err('','mfg0095',0)
      #    LET tm.cloc=' '
      #    NEXT FIELD cloc
      # END IF
      # #end FUN-630102 mark
        IF NOT s_imechk(tm.cware,tm.cloc) THEN
           LET tm.cloc=' '
           NEXT FIELD cloc
        END IF  
     #FUN-D40103 -----End-------
        #-----END MOD-B40260-----

         SELECT COUNT(*) INTO l_cnt FROM ogb_file
          WHERE ogb01 = l_oga.oga01 AND ogb09 = tm.cware
         IF l_cnt > 0 THEN
            CALL cl_err('','axm-424',0)
            LET tm.cloc=' '
            #NEXT FIELD tm.cware #MOD-C50194 mark
            NEXT FIELD cware     #MOD-C50194 add
         END IF
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(oga01)
                LET l_t1=s_get_doc_no(tm.oga01)       #No.FUN-550052
              # CALL q_oay(FALSE,TRUE,l_t1,'59',g_sys) RETURNING l_t1       #FUN-A70130 mark
                CALL q_oay(FALSE,TRUE,l_t1,'59','axm') RETURNING l_t1       #FUN-A70130
                LET tm.oga01 = l_t1            #No.FUN-550052
                DISPLAY BY NAME tm.oga01
                NEXT FIELD oga01
            WHEN INFIELD(cware)
                 #No.FUN-AA0048  --Begin
                 #CALL cl_init_qry_var()
                 #LET g_qryparam.form ="q_imd"
                 #LET g_qryparam.arg1     = 'S'        #倉庫類別 #MOD-4A0213
                 #LET g_qryparam.default1 = tm.cware
                 #CALL cl_create_qry() RETURNING tm.cware
                 CALL q_imd_1(FALSE,TRUE,tm.cware,'S',"","","") RETURNING tm.cware 
                 #No.FUN-AA0048  --End  
                 DISPLAY BY NAME tm.cware
            WHEN INFIELD(cloc)
                 #No.FUN-AA0048  --Begin
                 #CALL cl_init_qry_var()
                 #LET g_qryparam.form = "q_ime"
                 #LET g_qryparam.default1 = tm.cloc
                 #LET g_qryparam.arg1     = tm.cware #倉庫編號
                 #LET g_qryparam.arg2     = "S"      #倉庫類別
                 #CALL cl_create_qry() RETURNING tm.cloc
                 CALL q_ime_1(FALSE,TRUE,tm.cloc,tm.cware,"S","","","","") RETURNING tm.cloc 
                 #No.FUN-AA0048  --End  
                 DISPLAY BY NAME tm.cloc
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
      LET g_success = 'N'
      CLOSE WINDOW t6281_w
      RETURN
   END IF
 
   CLOSE WINDOW t6281_w
 
   LET p_oga01 = l_oga.oga01  #MOD-790150 #foreach單身key值用
 
   CALL s_auto_assign_no("axm",tm.oga01,g_today,"","oga_file","oga01","","","")
     RETURNING li_result,l_oga.oga01
 
   IF (NOT li_result) THEN
      LET g_success = 'N'
      RETURN
   END IF
 
   IF cl_null(l_oga.oga01) THEN
      LET g_success = 'N'
      RETURN
   END IF
 
   BEGIN WORK
 
  #LET l_oga.oga02  = g_today     #MOD-B70130 mark
   LET l_oga.oga02  = l_oga.oga02 #MOD-B70130
   LET l_oga.oga011 = l_oga.oga011
   LET l_oga.oga66  = tm.cware
   LET l_oga.oga67  = tm.cloc
   LET l_oga.oga09  = '9'
   LET l_oga.ogaconf= 'Y'
   LET l_oga.ogapost= 'Y'
   LET l_oga.ogaprsw= 0
   LET l_oga.oga55  = '0'
   LET l_oga.oga57  = '1'           #FUN-AC0055 add
   LET l_oga.oga56  = p_oga01 #FUN-C50097 ADD 簽收單號
   LET l_oga.oga65  = 'N'
 
   SELECT oayapr INTO l_oga.ogamksg FROM oay_file
    WHERE oayslip = tm.oga01
   LET l_oga.oga85=' ' #No.FUN-870007
   LET l_oga.oga94='N' #No.FUN-870007
 
   LET l_oga.ogaplant = g_plant 
   LET l_oga.ogalegal = g_legal 
 
   LET l_oga.ogaoriu = g_user      #No.FUN-980030 10/01/04
   LET l_oga.ogaorig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO oga_file VALUES (l_oga.*)
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err('ins oga',SQLCA.SQLCODE,1)
      LET g_success='N'
      RETURN
   END IF
 
   DECLARE t600_ins_ogb_c2 CURSOR FOR
    SELECT * FROM ogb_file
     WHERE ogb01= p_oga01              #MOD-790150 modify l_oga.oga01
   CALL s_showmsg_init()               #No.FUN-710046
   FOREACH t600_ins_ogb_c2 INTO l_ogb.*
      IF STATUS THEN
         CALL s_errmsg('','',"t600_ins_ogb_c1 foreach:",SQLCA.sqlcode,1)   #No.FUN-710046
         LET g_success = 'N'                   #No.FUN-8A0086
         EXIT FOREACH
      END IF
     IF g_success = "N" THEN
        LET g_totsuccess = "N"
        LET g_success = "Y"
     END IF
 
      SELECT SUM(ogb12),SUM(ogb912),SUM(ogb915),SUM(ogb917)
        INTO l_ogb12,l_ogb912,l_ogb915,l_ogb917
        FROM oga_file,ogb_file
       WHERE ogb01 = oga01
        #AND oga09 = '2'
        #AND (oga09 = '2' OR oga09 = '3')   #FUN-BB0167  #FUN-C40072 mark
         AND (oga09 = '2' OR oga09 = '3' OR oga09 = '4') #FUN-C40072 add
         AND oga65 = 'Y'
         AND oga01 = l_oga.oga011
         AND ogaconf = 'Y'
         AND ogapost = 'Y'
         AND ogb03 = l_ogb.ogb03
 
      IF l_ogb.ogb12 < l_ogb12 THEN
         LET l_ogb.ogb12 = l_ogb12 - l_ogb.ogb12
         LET l_ogb.ogb912= l_ogb912- l_ogb.ogb912
         LET l_ogb.ogb915= l_ogb915- l_ogb.ogb915
         LET l_ogb.ogb917= l_ogb917- l_ogb.ogb917
      ELSE
         CONTINUE FOREACH
      END IF
 
      LET l_ogb.ogb01 = l_oga.oga01
      LET l_ogb.ogb09 = tm.cware
      LET l_ogb.ogb091= tm.cloc
 
      SELECT COUNT(*) INTO l_cnt FROM ogb_file,oga_file
       WHERE oga01 = ogb01
         AND oga09 = '9'
         AND oga011 = l_oga.oga011
         AND ogb03 = l_ogb.ogb03
 
      IF l_cnt > 0 THEN
         CALL s_errmsg('','',l_ogb.ogb04,"axm-421",1)    #No.FUN-710046
         LET g_success = 'N'
         CONTINUE FOREACH
      END IF
 
      CALL t600_else(l_ogb.*) RETURNING l_ogb.*
      LET l_ogb.ogb44=' ' #No.FUN-870007
      LET l_ogb.ogb47=0   #No.FUN-870007
#FUN-AB0061 -----------add start----------------                          
      IF cl_null(l_ogb.ogb37) OR l_ogb.ogb37=0 THEN           
         LET l_ogb.ogb37=l_ogb.ogb13                         
      END IF                                                                             
#FUN-AB0061 -----------add end----------------   
      LET l_ogb.ogbplant = g_plant 
      LET l_ogb.ogblegal = g_legal 

#CHI-B60054  --Begin #MARK掉CHI-B30093更改
#CHI-B30093 --begin--
#      IF l_ogb.ogb17 = 'Y' THEN 
#         DECLARE t629_ogc_cs CURSOR FOR 
#          SELECT * FROM ogc_file WHERE ogc01 = p_oga01
#                                   AND ogc03 = l_ogb.ogb03
#         FOREACH t629_ogc_cs INTO l_ogc_1.*
#            LET l_ogc_1.ogc01 = l_ogb.ogb01 
#            LET l_ogc_1.ogc09 = l_ogb.ogb09
#            LET l_ogc_1.ogc091= l_ogb.ogb091
#            #No.TQC-B50099  --Begin
#            SELECT ogc09,ogc091 INTO l_ogc09_1,l_ogc091_1 FROM ogc_file, OUTER img_file
#             WHERE ogc01 = l_oga.oga011 
#               AND ogc03 = l_ogb.ogb03   
#               AND img01=l_ogb.ogb04
#               AND img02=ogc09
#               AND img03=ogc091
#               AND img04=ogc092
#               AND ogc092=l_ogc_1.ogc092
#                            
#            SELECT ogc12 INTO l_ogc12_1 FROM ogc_file
#             WHERE ogc01 = l_oga.oga011
#               AND ogc03 = l_ogb.ogb03
#               AND ogc09 = l_ogc09_1
#               AND ogc091= l_ogc091_1
#               AND ogc092= l_ogc_1.ogc092
#               AND ogc17 = l_ogb.ogb04
#            IF cl_null(l_ogc12_1) THEN LET l_ogc12_1 = 0 END IF
#            LET l_ogc_1.ogc12 = l_ogc12_1 - l_ogc_1.ogc12
#            IF l_ogc_1.ogc12 = 0 THEN
#               CONTINUE FOREACH
#            END IF
#            #No.TQC-B50099  --End
#            INSERT INTO ogc_file VALUES(l_ogc_1.*)
#            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#                CALL s_errmsg('','',"INS ogc",SQLCA.sqlcode,1)  
#                LET g_success='N'
#                EXIT FOREACH 
#            END IF 
#         END FOREACH                                    
#      END IF 
#CHI-B30093 --end--
#CHI-B60054  --End #MARK掉CHI-B30093更改
 
      INSERT INTO ogb_file VALUES(l_ogb.*)
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL s_errmsg('','',"INS ogb",SQLCA.sqlcode,1)  #No.FUN-710046
         LET g_success='N'
         CONTINUE FOREACH  #No.FUN-710046
      ELSE
         IF NOT s_industry('std') THEN
            INITIALIZE l_ogbi.* TO NULL
            LET l_ogbi.ogbi01 = l_ogb.ogb01
            LET l_ogbi.ogbi03 = l_ogb.ogb03
            IF NOT s_ins_ogbi(l_ogbi.*,'') THEN
               LET g_success = 'N'
               CONTINUE FOREACH
            END IF
         END IF
      END IF
      LET g_ima918 = ''   #MOD-9C0055
      LET g_ima921 = ''   #MOD-9C0055
      SELECT ima918,ima921 INTO g_ima918,g_ima921 
        FROM ima_file
       WHERE ima01 = l_ogb.ogb04
         AND imaacti = "Y"
      
      IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
        #DECLARE t600sub_g_rvbs CURSOR FOR SELECT * FROM rvbs_file #CHI-BB0057 mark
         #CHI-BB0057 add start -----
         DECLARE t600sub_g_rvbs CURSOR FOR SELECT rvbs03,rvbs04,rvbs05,rvbs08
                                             FROM rvbs_file
         #CHI-BB0057 add end   -----
                                        WHERE rvbs01 = l_oga.oga011
                                          AND rvbs02 = l_ogb.ogb03
                                     GROUP BY rvbs03,rvbs04,rvbs05,rvbs08 #CHI-BB0057 add
         
         LET i = 1   #MOD-A10163
         #FOREACH t600sub_g_rvbs INTO l_rvbs.* #CHI-BB0057 mark
         FOREACH t600sub_g_rvbs INTO l_rvbs.rvbs03,l_rvbs.rvbs04,l_rvbs.rvbs05,l_rvbs.rvbs08 #CHI-BB0057 add
            IF STATUS THEN
               CALL cl_err('rvbs',STATUS,1)
               LET g_success='N'
            END IF
            #-----MOD-A10163---------
            LET l_cnt = 0 
            SELECT COUNT(*) FROM rvbs_file
             WHERE rvbs00[1,7] = 'axmt629'   #FUN-B40066 add [1,7]            
               AND rvbs01 = l_oga.oga01
               AND rvbs02 = l_ogb.ogb03
               AND rvbs09 = '-1'
               AND rvbs13 = 0 
               AND rvbs03 = l_rvbs.rvbs03
               AND rvbs04 = l_rvbs.rvbs04
            IF l_cnt > 0 THEN
               CONTINUE FOREACH
            END IF
            #-----END MOD-A10163-----

            #CHI-BB0057 add start -----
              SELECT * INTO l_rvbs.*
                FROM rvbs_file
               WHERE rvbs01 = l_oga.oga011
                 AND rvbs02 = l_ogb.ogb03
                 AND rvbs03 = l_rvbs.rvbs03
                 AND rvbs04 = l_rvbs.rvbs04
                 AND rvbs05 = l_rvbs.rvbs05
                 AND rvbs08 = l_rvbs.rvbs08
            #CHI-BB0057 add end   -----

            #LET l_rvbs.rvbs00 = 'axmt629'   #FUN-B40066 mark
            #FUN-B40066 --START--
            IF s_industry('icd') THEN 
               LET l_rvbs.rvbs00 = 'axmt629_icd'
            ELSE
               LET l_rvbs.rvbs00 = 'axmt629' 
            END IF
            #FUN-B40066 --END--   
            LET l_rvbs.rvbs01 = l_oga.oga01

            #檢查銷退數必須 =出貨單上的數量-簽收單上的數量
            LET l_rvbs06a = 0

            SELECT SUM(rvbs06) INTO l_rvbs06a
              FROM rvbs_file
             WHERE rvbs01= l_oga.oga011
               AND rvbs02= l_ogb.ogb03
              #CHI-BB0057 mark start -----
              #AND rvbs13 = l_rvbs.rvbs13  
              #AND rvbs09 = -1    #TQC-B90236 modify 
              #CHI-BB0057 mark end   -----
               #-----MOD-A10163---------
               #AND rvbs022 = l_rvbs.rvbs022   
               AND rvbs03=l_rvbs.rvbs03
               AND rvbs04=l_rvbs.rvbs04
               #-----END MOD-A10163-----
            #CHI-BB0057 add start  -----
               AND rvbs05 = l_rvbs.rvbs05
               AND rvbs08 = l_rvbs.rvbs08
            GROUP BY rvbs03,rvbs04,rvbs05,rvbs08
            #CHI-BB0057 add end   -----
            
            IF cl_null(l_rvbs06a) THEN
               LET l_rvbs06a = 0
            END IF

            #已簽收數量
            LET l_rvbs06b = 0
            LET l_rvbs.rvbs13 = 0   #MOD-A10163 
            LET l_rvbs.rvbs022 = i  #MOD-A10163

            SELECT SUM(rvbs06) INTO l_rvbs06b
              FROM ogb_file,oga_file,rvbs_file
             WHERE ogb01 = oga01 AND oga09 IN ('8') 
               AND oga011 = l_oga.oga011
               AND ogb03 = l_ogb.ogb03
               AND oga01 = rvbs01
               AND ogb03 = rvbs02
              #CHI-BB0057 mark start -----
              #AND rvbs13 = l_rvbs.rvbs13  
              #AND rvbs09 = -1
              #CHI-BB0057 mark end   -----
               AND ogaconf != 'X' 
               #-----MOD-A10163---------
               #AND rvbs022 = l_rvbs.rvbs022   
               AND rvbs03=l_rvbs.rvbs03
               AND rvbs04=l_rvbs.rvbs04
               #-----END MOD-A10163-----
            #CHI-BB0057 add start  -----
               AND rvbs05 = l_rvbs.rvbs05
               AND rvbs08 = l_rvbs.rvbs08
            GROUP BY rvbs03,rvbs04,rvbs05,rvbs08
            #CHI-BB0057 add end   -----

            IF cl_null(l_rvbs06b) THEN
               LET l_rvbs06b = 0
            END IF

            LET l_rvbs.rvbs06 = l_rvbs06a - l_rvbs06b

            #CHI-BB0057 add start -----
            IF l_rvbs.rvbs06 <= 0 THEN
               CONTINUE FOREACH
            END IF
            #CHI-BB0057 add end   -----

            INSERT INTO rvbs_file VALUES(l_rvbs.*)
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL cl_err3("ins","rvbs_file","","",SQLCA.sqlcode,"","ins rvbs",1)  
               LET g_success='N'
            END IF
            LET i = i + 1 #MOD-A10163
         END FOREACH
      END IF
      #CHI-AC0034 add --start--
      #No.MOD-C70145  --beg
      #IF l_ogb.ogb17='Y' AND g_oaz.oaz23 = 'Y' THEN     ##多倉儲出貨 #No.MOD-C70145 mark
      IF l_ogb.ogb17='Y' THEN     ##多倉儲出貨
      #No.MOD-C70145  --End      
         DECLARE t600sub_ins_ogc_c CURSOR FOR
         #SELECT * FROM ogc_file             #MOD-C70078 mark
          SELECT ogc17,ogc092 FROM ogc_file  #MOD-C70078
           WHERE ogc01= p_oga01
             AND ogc03= l_ogb.ogb03
           GROUP BY ogc17,ogc092             #MOD-C70078
        #FOREACH t600sub_ins_ogc_c INTO l_ogc.*                   #MOD-C70078 mark
         FOREACH t600sub_ins_ogc_c INTO l_ogc.ogc17,l_ogc.ogc092  #MOD-C70078
            IF STATUS THEN
               CALL s_errmsg('','',"t600sub_ins_ogc_c foreach:",SQLCA.sqlcode,1) 
               LET g_success = 'N'   
               EXIT FOREACH
            END IF
            IF g_success = "N" THEN
               LET g_totsuccess = "N"
               LET g_success = "Y"
            END IF

           #MOD-C70078---S---
            SELECT * INTO l_ogc.* FROM ogc_file
             WHERE ogc01= p_oga01
               AND ogc03= l_ogb.ogb03
               AND ogc17= l_ogc.ogc17
               AND ogc092= l_ogc.ogc092

             #No.MOD-C70145  --Begin  出货替代时，可能会有逻辑被改变的问题
             #SELECT SUM(ogc12) INTO l_ogc.ogc12 FROM ogc_file 
             # WHERE ogc01= p_oga01
             #   AND ogc03= l_ogb.ogb03
             # GROUP BY ogc17,ogc092 
             #No.MOD-C70145  --End
           #MOD-C70078---E---

            SELECT SUM(ogc12) INTO l_ogc12
              FROM ogc_file
             WHERE ogc01 = l_oga.oga011
               AND ogc03 = l_ogb.ogb03
               AND ogc17 = l_ogc.ogc17
               AND ogc092= l_ogc.ogc092   #No.MOD-C70145
            IF l_ogc.ogc12 < l_ogc12 THEN
               LET l_ogc.ogc12 = l_ogc12 - l_ogc.ogc12
               LET l_ogc.ogc16 = l_ogc.ogc12 * l_ogc.ogc15_fac
               LET l_ogc.ogc16 = s_digqty(l_ogc.ogc16,l_ogc.ogc15)   #FUN-910088--add--
            ELSE
               CONTINUE FOREACH
            END IF

            LET l_ogc.ogc01 = l_oga.oga01
            LET l_ogc.ogc09 = tm.cware
            LET l_ogc.ogc091= tm.cloc

            INSERT INTO ogc_file VALUES(l_ogc.*)
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
               CALL s_errmsg('','',"ins ogc",SQLCA.sqlcode,1)  
               LET g_success='N'
               CONTINUE FOREACH
            END IF

            LET g_ima918 = ''   
            LET g_ima921 = ''  
            SELECT ima918,ima921 INTO g_ima918,g_ima921 
              FROM ima_file
             WHERE ima01 = l_ogc.ogc17
               AND imaacti = "Y"

            IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
               #DECLARE t600sub_g_rvbs_2 CURSOR FOR SELECT * FROM rvbs_file #CHI-BB0057 mark 
               #CHI-BB0057 add start -----
               DECLARE t600sub_g_rvbs_2 CURSOR FOR SELECT rvbs03,rvbs04,rvbs05,rvbs08,rvbs021
                                                   FROM rvbs_file
               #CHI-BB0057 add end   -----
                                              WHERE rvbs01 = l_oga.oga011                    
                                                AND rvbs02 = l_ogb.ogb03
                                           #CHI-BB0057 add start -----
                                                AND rvbs13 in (SELECT ogc18 FROM ogc_file
                                                                WHERE ogc01= l_oga.oga011
                                                                  AND ogc03= l_ogb.ogb03
                                                                  AND ogc17= l_ogc.ogc17
                                                                  AND ogc092= l_ogc.ogc092)
                                           GROUP BY rvbs03,rvbs04,rvbs05,rvbs08,rvbs021
                                           #CHI-BB0057 add start -----
                                               #AND rvbs13 = l_ogc.ogc18 #CHI-BB0057 mark
               LET i = 1
              #FOREACH t600sub_g_rvbs_2 INTO l_rvbs.* #CHI-BB0057 mark
               FOREACH t600sub_g_rvbs_2 INTO l_rvbs.rvbs03,l_rvbs.rvbs04,l_rvbs.rvbs05,l_rvbs.rvbs08,l_rvbs.rvbs021 #CHI-BB0057 add
                  IF STATUS THEN
                     CALL cl_err('rvbs',STATUS,1)
                     LET g_success='N'
                  END IF

                  LET l_cnt = 0 
                  SELECT COUNT(*) FROM rvbs_file
                   WHERE rvbs00[1,7] = 'axmt629'   #FUN-B40066 add [1,7]             
                     AND rvbs01 = l_oga.oga01
                     AND rvbs02 = l_ogb.ogb03
                     AND rvbs09 = '-1'
                     AND rvbs13 = 0 
                     AND rvbs03 = l_rvbs.rvbs03
                     AND rvbs04 = l_rvbs.rvbs04
                  IF l_cnt > 0 THEN
                     CONTINUE FOREACH
                  END IF

                #CHI-BB0057 add start -----
                  SELECT * INTO l_rvbs.*
                    FROM rvbs_file
                   WHERE rvbs01 = l_oga.oga011
                     AND rvbs02 = l_ogb.ogb03
                     AND rvbs03 = l_rvbs.rvbs03
                     AND rvbs04 = l_rvbs.rvbs04
                     AND rvbs05 = l_rvbs.rvbs05
                     AND rvbs08 = l_rvbs.rvbs08
                     AND rvbs021= l_rvbs.rvbs021

                  LET l_rvbs.rvbs13 = l_ogc.ogc18
                #CHI-BB0057 add start -----

                  #LET l_rvbs.rvbs00 = 'axmt629' #FUN-B40066 mark
                  #FUN-B40066 --START--
                  IF s_industry('icd') THEN
                     LET l_rvbs.rvbs00 = 'axmt629_icd'
                  ELSE    
                     LET l_rvbs.rvbs00 = 'axmt629' 
                  END IF   
                  #FUN-B40066 --END--
                  LET l_rvbs.rvbs01 = l_oga.oga01

                  #檢查銷退數必須 =出貨單上的數量-簽收單上的數量
                  LET l_rvbs06a = 0

                  SELECT SUM(rvbs06) INTO l_rvbs06a
                    FROM rvbs_file
                   WHERE rvbs01= l_oga.oga011
                     AND rvbs02= l_ogb.ogb03
                    #CHI-BB0057 mark start -----
                    #AND rvbs13 = l_rvbs.rvbs13   
                    #AND rvbs09 = -1   #TQC-B90236 modify 
                    #CHI-BB0057 mark end   -----
                     AND rvbs03=l_rvbs.rvbs03
                     AND rvbs04=l_rvbs.rvbs04
                     #CHI-BB0057 add start -----
                     AND rvbs05 = l_rvbs.rvbs05
                     AND rvbs08 = l_rvbs.rvbs08
                     AND rvbs021= l_rvbs.rvbs021
                     #CHI-BB0057 add end   -----
                  
                  IF cl_null(l_rvbs06a) THEN
                     LET l_rvbs06a = 0
                  END IF

                  #已簽收數量
                  LET l_rvbs06b = 0
                  LET l_rvbs.rvbs022 = i 

                  SELECT SUM(rvbs06) INTO l_rvbs06b
                    FROM ogb_file,oga_file,rvbs_file
                   WHERE ogb01 = oga01 AND oga09 IN ('8') 
                     AND oga011 = l_oga.oga011
                     AND ogb03 = l_ogb.ogb03
                     AND oga01 = rvbs01
                     AND ogb03 = rvbs02
                    #CHI-BB0057 mark start -----
                    #AND rvbs13 = l_rvbs.rvbs13  
                    #AND rvbs09 = -1
                    #CHI-BB0057 mark end   -----
                     AND ogaconf != 'X' 
                     AND rvbs03=l_rvbs.rvbs03
                     AND rvbs04=l_rvbs.rvbs04
                     #CHI-BB0057 add start -----
                     AND rvbs05 = l_rvbs.rvbs05
                     AND rvbs08 = l_rvbs.rvbs08
                     AND rvbs021= l_rvbs.rvbs021
                     #CHI-BB0057 add end   -----

                  IF cl_null(l_rvbs06b) THEN
                     LET l_rvbs06b = 0
                  END IF

                  LET l_rvbs.rvbs06 = l_rvbs06a - l_rvbs06b

                  #CHI-BB0057 add start -----
                  IF l_rvbs.rvbs06 <= 0 THEN
                     CONTINUE FOREACH
                  END IF
                  #CHI-BB0057 add end   -----

                  INSERT INTO rvbs_file VALUES(l_rvbs.*)
                  IF STATUS OR SQLCA.SQLCODE THEN
                     CALL cl_err3("ins","rvbs_file","","",SQLCA.sqlcode,"","ins rvbs",1)  
                     LET g_success='N'
                  END IF
                  LET i = i + 1 
               END FOREACH
            END IF
         END FOREACH
      END IF
      #CHI-AC0034 add --end--
   END FOREACH

   #MOD-C50014 add start -----
   SELECT azi03,azi04 INTO t_azi03,t_azi04
     FROM azi_file
    WHERE azi01 = l_oga.oga23

   SELECT SUM(ogb14),SUM(ogb14t) into l_oga.oga50,l_oga.oga1008
     FROM ogb_file
    WHERE ogb01 = l_oga.oga01 AND ogb1005 = '1'

   SELECT SUM(ogb14),SUM(ogb14t) into l_oga.oga1006,l_oga.oga1007
     FROM ogb_file
    WHERE ogb01 = l_oga.oga01 AND ogb1005 = '2'

   IF cl_null(l_oga.oga50) THEN
      LET l_oga.oga50 = 0
   ELSE
      CALL cl_numfor(l_oga.oga50,8,t_azi04) RETURNING l_oga.oga50
   END IF

   IF cl_null(l_oga.oga1006) THEN
      LET l_oga.oga1006 = 0
   ELSE
      CALL cl_numfor(l_oga.oga1006,8,t_azi04) RETURNING l_oga.oga1006
   END IF

   IF cl_null(l_oga.oga1008) THEN
      LET l_oga.oga1008 = 0
   ELSE
      CALL cl_numfor(l_oga.oga1008,8,t_azi04) RETURNING l_oga.oga1008
   END IF

   IF cl_null(l_oga.oga1007) THEN
      LET l_oga.oga1007 = 0
   ELSE
      CALL cl_numfor(l_oga.oga1007,8,t_azi04) RETURNING l_oga.oga1007
   END IF

    UPDATE oga_file SET oga50=l_oga.oga50,oga1008=l_oga.oga1008
                       ,oga1006=l_oga.oga1006,oga1007=l_oga.oga1007
                  WHERE oga01 = l_oga.oga01
   #MOD-C50014 add end   -----

     IF g_totsuccess="N" THEN
        LET g_success="N"
     END IF
   #要處理過帳
   DECLARE t600_post_cur1 CURSOR FOR
    SELECT * FROM ogb_file WHERE ogb01 = l_oga.oga01
 
   FOREACH t600_post_cur1 INTO l_ogb.*
      IF STATUS THEN
         CALL s_errmsg('','',"t600_post_cur1 foreach:",SQLCA.sqlcode,0)  #No.FUN-710046
         EXIT FOREACH
      END IF
     IF g_success = "N" THEN
        LET g_totsuccess = "N"
        LET g_success = "Y"
     END IF
      LET l_ogb.ogb01 = l_oga.oga01
 
     #CHI-AC0034 mark --start--
     #CALL t600sub_consign(l_oga.oga66,l_oga.oga67,l_ogb.ogb092,     #No.TQC-6B0174
     #                  l_ogb.ogb12,l_ogb.ogb05,l_ogb.ogb15_fac,l_ogb.ogb16,l_oga.*,l_ogb.*)
     #IF g_success = 'N' THEN
     #   RETURN
     #END IF
     #CHI-AC0034 mark --end--
      #CHI-AC0034 add --start--
      LET l_flag='' 
      #No.MOD-C70145  --beg
      #IF l_ogb.ogb17='Y' AND g_oaz.oaz23 = 'Y' THEN     ##多倉儲出貨 #No.MOD-C70145  --mark
      IF l_ogb.ogb17='Y' THEN
      #No.MOD-C70145  --End       
        #DECLARE t600_s1_ogc_c4 CURSOR FOR  SELECT * FROM ogc_file
        #   WHERE ogc01=l_oga.oga01 AND ogc03=l_ogb.ogb03
         DECLARE t600_s1_ogc_c4 CURSOR FOR  
#CHI-B60054  --Begin #MARK掉CHI-B30093更改
#CHI-B30093 --begin--         
          SELECT SUM(ogc12),ogc17,ogc092 FROM ogc_file  #MOD-C10103 add ogc092
#           SELECT * FROM ogc_file     
            WHERE ogc01=l_oga.oga01 AND ogc03=l_ogb.ogb03  #MOD-BC0089 remark
          GROUP BY ogc17,ogc092                                             #MOD-C10103 add ogc092
         FOREACH t600_s1_ogc_c4 INTO l_ogc.ogc12,l_ogc.ogc17,l_ogc.ogc092   #MOD-C10103 add ogc092 
#          FOREACH t600_s1_ogc_c4 INTO l_ogc.*   
#CHI-B30093 --end--
#CHI-B60054  --End #MARK掉CHI-B30093更改

            IF SQLCA.SQLCODE THEN
               CALL s_errmsg('','',"Foreach s1_ogc:",SQLCA.sqlcode,1)
               LET g_success='N' RETURN 
            END IF
            LET l_msg='_s1() read ogc02:',l_ogb.ogb03,'-',l_ogc.ogc091
            CALL cl_msg(l_msg)
            LET l_flag='X'    
#CHI-B60054  --Begin #MARK掉CHI-B30093更改
#CHI-B30093 --begin--               
            SELECT img09 INTO l_img09 FROM img_file
             WHERE img01= l_ogb.ogb04  AND img02= l_oga.oga66
            #No.MOD-C70145  --Begin
            #  AND img03= l_oga.oga67 AND img04= l_ogb.ogb092             
               AND img03= l_oga.oga67 AND img04= l_ogc.ogc092             
            #No.MOD-C70145  --End            
           CALL s_umfchk(l_ogb.ogb04,l_ogb.ogb05,l_img09) RETURNING g_cnt,l_ogc.ogc15_fac
            LET l_ogc.ogc16=l_ogc.ogc12*l_ogc.ogc15_fac
            LET l_ogc.ogc16 = s_digqty(l_ogc.ogc16,l_ogc.ogc15)    #FUN-910088--add--
           #CALL t600sub_consign(l_oga.oga66,l_oga.oga67,l_ogb.ogb092,    #MOD-C10103 mark  
            CALL t600sub_consign(l_oga.oga66,l_oga.oga67,l_ogc.ogc092,    #MOD-C10103 remark 
#CHI-B30093 --end--
#CHI-B60054  --End #MARK掉CHI-B30093更改
                          l_ogc.ogc12,l_ogb.ogb05,l_ogc.ogc15_fac,l_ogc.ogc16,l_flag,l_ogc.ogc17,l_oga.*,l_ogb.*)  
            IF g_success='N' THEN  
               LET g_totsuccess="N"
               LET g_success="Y"
               #RETURN    #MOD-BB0058 mark
            END IF
            #FUN-B40066 --START--
            IF s_industry('icd') THEN
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM idb_file
                WHERE idb07 = l_ogb.ogb01 AND idb08 = l_ogb.ogb03
               IF l_cnt > 0 THEN
                  DECLARE t600sub_idb_c3 CURSOR FOR
                   SELECT * FROM idb_file
                    WHERE idb07 = l_ogb.ogb01 AND idb08 = l_ogb.ogb03
                  FOREACH t600sub_idb_c3 INTO l_idb.* 
                     #出貨簽收單產生ida資料
                     IF NOT s_icdout_insicin(l_idb.*,l_oga.oga66,l_oga.oga67,l_idb.idb04) THEN  #TQC-BA0136  l_ogc.ogc092->l_idb.idb04
                        LET g_success='N'
                        EXIT FOREACH
                     END IF
                     IF g_success='N' THEN  
                        LET g_totsuccess="N"
                        LET g_success="Y"
                        EXIT FOREACH
                     END IF
                  END FOREACH
               END IF
               SELECT ogbiicd028,ogbiicd029 INTO l_ogbi.ogbiicd02,l_ogbi.ogbiicd029
                FROM ogbi_file WHERE ogbi01 = l_ogb.ogb01 AND ogbi03 = l_ogb.ogb03
               CALL s_icdpost(1,l_ogb.ogb04,l_oga.oga66,l_oga.oga67,
                    l_ogc.ogc092,l_ogb.ogb05,l_ogb.ogb12,
                    l_oga.oga01,l_ogb.ogb03,l_oga.oga02,'Y',
                    '','',l_ogbi.ogbiicd029,l_ogbi.ogbiicd028,'')  #FUN-B80119--傳入p_plant參數''---
                    RETURNING l_flag
               IF l_flag = 0 THEN
                  LET g_success = 'N'                     
                  RETURN
               END IF
            END IF    
            #FUN-B40066 --END--
         END FOREACH
      ELSE
         IF l_ogb.ogb17='Y' THEN 
            LET l_flag = 'Y'
#CHI-B60054  --Begin #mark CHI-B30093和TQC-B50099更改
            #No.TQC-B50099  --Begin #此處tlf需更新驗退倉庫
#CHI-B30093 --begin--
#            DECLARE t600_s1_ogc_c5 CURSOR FOR  
#             SELECT * FROM ogc_file      
#              WHERE ogc01=p_oga01 AND ogc03=l_ogb.ogb03
#            FOREACH t600_s1_ogc_c5 INTO l_ogc_1.*                                              
#                CALL t600sub_consign(l_ogc_1.ogc09,l_ogc.ogc091,l_ogc_1.ogc092,l_ogc_1.ogc12,
#                                     l_ogb.ogb05,l_ogc_1.ogc15_fac,l_ogc_1.ogc16,l_flag,
#                                     l_ogb.ogb04,l_oga.*,l_ogb.*)         
#            END FOREACH              
#CHI-B30093 --end--  
#CHI-B60054  --End #去掉CHI-B30093更改

#            DECLARE t600_s1_ogc_c6 CURSOR FOR  
#             SELECT * FROM ogc_file      
#              WHERE ogc01=l_oga.oga01 AND ogc03=l_ogb.ogb03
#            FOREACH t600_s1_ogc_c6 INTO l_ogc_1.*                                              
#                CALL t600sub_consign(l_oga.oga66,l_oga.oga67,l_ogb.ogb092,l_ogc_1.ogc12, 
#                                     l_ogb.ogb05,l_ogc_1.ogc15_fac,l_ogc_1.ogc16,l_flag,
#                                     l_ogb.ogb04,l_oga.*,l_ogb.*)         
#            END FOREACH  
            #No.TQC-B50099  --End        
#CHI-B60054  --End #mark CHI-B30093和TQC-B50099更改
         ELSE 
            LET l_flag='' 
         END IF           #CHI-B30093 #CHI-B60054 去掉mark CHI-B30093 
             CALL t600sub_consign(l_oga.oga66,l_oga.oga67,l_ogb.ogb092,   
                       l_ogb.ogb12,l_ogb.ogb05,l_ogb.ogb15_fac,l_ogb.ogb16,l_flag,l_ogb.ogb04,l_oga.*,l_ogb.*)  
         #END IF           #CHI-B30093 #CHI-B60054 mark CHI-B30093 
         IF g_success='N' THEN 
            LET g_totsuccess="N"
            LET g_success="Y"
            #RETURN   #MOD-BB0058 mark
         END IF
         #FUN-B40066 --START--
         IF s_industry('icd') THEN
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM idb_file
             WHERE idb07 = l_ogb.ogb01 AND idb08 = l_ogb.ogb03
            IF l_cnt > 0 THEN
               DECLARE t600sub_idb_c4 CURSOR FOR
                SELECT * FROM idb_file
                 WHERE idb07 = l_ogb.ogb01 AND idb08 = l_ogb.ogb03
               FOREACH t600sub_idb_c4 INTO l_idb.* 
                  #出貨簽收單產生ida資料
                  IF NOT s_icdout_insicin(l_idb.*,l_oga.oga66,l_oga.oga67,l_idb.idb04) THEN   #TQC-BA0136  l_ogc.ogc092 ->l_idb.idb04
                     LET g_success='N'
                     EXIT FOREACH
                  END IF
                  IF g_success='N' THEN  
                     LET g_totsuccess="N"
                     LET g_success="Y"
                     EXIT FOREACH
                  END IF
               END FOREACH
            END IF
            SELECT ogbiicd028,ogbiicd029 INTO l_ogbi.ogbiicd02,l_ogbi.ogbiicd029
             FROM ogbi_file WHERE ogbi01 = l_ogb.ogb01 AND ogbi03 = l_ogb.ogb03
            CALL s_icdpost(1,l_ogb.ogb04,l_oga.oga66,l_oga.oga67,
                 l_ogc.ogc092,l_ogb.ogb05,l_ogb.ogb12,
                 l_oga.oga01,l_ogb.ogb03,l_oga.oga02,'Y',
                 '','',l_ogbi.ogbiicd029,l_ogbi.ogbiicd028,'')  #FUN-B80119--傳入p_plant參數''---
                 RETURNING l_flag
            IF l_flag = 0 THEN
               LET g_success = 'N'                     
               RETURN
            END IF
         END IF    
         #FUN-B40066 --END--
      END IF
      #CHI-AC0034 add --end--
 
      IF g_sma.sma115 = 'Y' THEN
#FUN-C50097 ADD BEGIN
#此处要生成签退单ogg_file
         IF l_ogb.ogb17='Y' THEN     ##多倉儲出貨
            DECLARE t600sub_ins_ogg_c3 CURSOR FOR
             SELECT * FROM ogg_file
              WHERE ogg01= p_oga01
                AND ogg03= l_ogb.ogb03
            FOREACH t600sub_ins_ogg_c3 INTO l_ogg.*
               IF STATUS THEN
                  CALL s_errmsg('','',"t600sub_ins_ogg_c3 foreach:",SQLCA.sqlcode,1) 
                  LET g_success = 'N'   
                  EXIT FOREACH
               END IF
               IF g_success = "N" THEN
                  LET g_totsuccess = "N"
                  LET g_success = "Y"
               END IF

               IF l_ogg.ogg13 > 0 THEN 
                  LET l_ogg.ogg12 = l_ogg.ogg13 
                  LET l_ogg.ogg16 = l_ogg.ogg12 * l_ogg.ogg15_fac
                  LET l_ogg.ogg16 = s_digqty(l_ogg.ogg16,l_ogg.ogg15)   #FUN-910088--add--
               ELSE
                  CONTINUE FOREACH
               END IF
   
               LET l_ogg.ogg01 = l_oga.oga01
               LET l_ogg.ogg09 = tm.cware
               LET l_ogg.ogg091= tm.cloc
   
               INSERT INTO ogg_file VALUES(l_ogg.*)
               IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                  CALL s_errmsg('','',"ins ogg",SQLCA.sqlcode,1)  
                  LET g_success='N'
                  CONTINUE FOREACH
               END IF
            END FOREACH   
         END IF       
#FUN-C50097 ADD END      
         CALL t600sub_consign_mu(l_oga.oga66,l_oga.oga67,l_ogb.ogb092,l_oga.*,l_ogb.*)     #No.TQC-6B0174
         IF g_success = 'N' THEN
            RETURN
         END IF
      END IF
   END FOREACH
     IF g_totsuccess="N" THEN
        LET g_success="N"
     END IF
     IF g_success = 'Y' THEN
        COMMIT WORK
     ELSE
        ROLLBACK WORK
     END IF
END FUNCTION
 
FUNCTION t600sub_consign_mu(p_ware,p_loca,p_lot,l_oga,l_ogb)
  DEFINE l_ogb    RECORD LIKE ogb_file.*
  DEFINE p_ware   LIKE ogb_file.ogb09,       ##倉庫
         p_loca   LIKE ogb_file.ogb091,      ##儲位
         p_lot    LIKE ogb_file.ogb092,      ##批號
         l_qty2   LIKE img_file.img10,
         l_qty1   LIKE img_file.img10,
         l_ima906 LIKE ima_file.ima906,
         l_imgg   RECORD LIKE imgg_file.*,
         l_oga    RECORD LIKE oga_file.*
 
    IF cl_null(p_ware) THEN LET p_ware=' ' END IF
    IF cl_null(p_loca) THEN LET p_loca=' ' END IF
    IF cl_null(p_lot)  THEN LET p_lot =' ' END IF
    LET l_qty2=l_ogb.ogb915
    LET l_qty1=l_ogb.ogb912
    IF cl_null(l_qty1)  THEN LET l_qty1=0 END IF
    IF cl_null(l_qty2)  THEN LET l_qty2=0 END IF
 
    SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01=l_ogb.ogb04
    #FUN-C50097 ADD BEGIN----
    IF l_ogb.ogb17 ='Y' THEN #要将出货单的仓储批的批号带到签收单
       #FOREACH 母单位批号 数量
       DECLARE t600_sub_ogg_c1 CURSOR FOR  
        SELECT SUM(ogg16),ogg092 FROM ogg_file   
         WHERE ogg01=l_oga.oga01 
           AND ogg03=l_ogb.ogb03
           AND ogg20='2'
         GROUP BY ogg092   
       FOREACH t600_sub_ogg_c1 INTO l_qty2,p_lot  
          IF SQLCA.SQLCODE THEN
             CALL s_errmsg('','',"Foreach s1_ogg_c1:",SQLCA.sqlcode,1)
             LET g_success='N' EXIT FOREACH
          END IF       
          IF l_ima906 MATCHES '[23]' THEN
             IF NOT cl_null(l_ogb.ogb913) THEN
                SELECT * INTO l_imgg.* FROM imgg_file
                 WHERE imgg01= l_ogb.ogb04
                   AND imgg02= p_ware
                   AND imgg03= p_loca
                   AND imgg04= p_lot
                   AND imgg09= l_ogb.ogb913
                IF STATUS <> 0 THEN            ## 新增一筆img_file
                   CALL t600sub_set_imgg(l_ogb.ogb913,p_ware,p_loca,p_lot,l_ogb.*) RETURNING l_imgg.*
       
                   LET l_imgg.imggplant = g_plant 
                   LET l_imgg.imgglegal = g_legal 
       
                   INSERT INTO imgg_file VALUES (l_imgg.*)
                   IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                      CALL cl_err3("ins","imgg_file","","",SQLCA.sqlcode,"","ins img:",1)  #No.FUN-670008
                      LET g_success='N' RETURN
                   END IF
                END IF
                IF l_ima906 = '2' THEN
                   CALL t600sub_upd_imgg('1',l_imgg.imgg01,l_imgg.imgg02,l_imgg.imgg03,l_imgg.imgg04,
                                      l_ogb.ogb913,l_ogb.ogb914,l_qty2,+1,'2',l_oga.*)
                   IF g_success='N' THEN RETURN END IF
                   IF NOT cl_null(l_ogb.ogb915) THEN                                            #CHI-860005
                      CALL t600sub_contlff('2',l_imgg.imgg02,l_imgg.imgg03,l_imgg.imgg04,
                                         l_ogb.ogb913,l_ogb.ogb914,l_qty2,l_oga.*,l_ogb.*,'1')
                   END IF   #No.MOD-790136 add
                   IF g_success='N' THEN RETURN END IF
                ELSE
                   CALL t600sub_upd_imgg('2',l_imgg.imgg01,l_imgg.imgg02,l_imgg.imgg03,l_imgg.imgg04,
                                      l_ogb.ogb913,l_ogb.ogb914,l_qty2,+1,'2',l_oga.*)
                   IF g_success='N' THEN RETURN END IF
                   IF NOT cl_null(l_ogb.ogb915) THEN                                            #CHI-860005
                      CALL t600sub_contlff('2',l_imgg.imgg02,l_imgg.imgg03,l_imgg.imgg04,
                                         l_ogb.ogb913,l_ogb.ogb914,l_qty2,l_oga.*,l_ogb.*,'1')
                   END IF   #No.MOD-790136 add
                   IF g_success='N' THEN RETURN END IF
                END IF
             END IF
          END IF          
       END FOREACH 
       
       #FOREACH 子单位批号 数量
       DECLARE t600_sub_ogg_c2 CURSOR FOR  
        SELECT SUM(ogg16),ogg092 FROM ogg_file   
         WHERE ogg01=l_oga.oga01 
           AND ogg03=l_ogb.ogb03
           AND ogg20='1'
         GROUP BY ogg092   
       FOREACH t600_sub_ogg_c2 INTO l_qty1,p_lot  
          IF SQLCA.SQLCODE THEN
             CALL s_errmsg('','',"Foreach sub_ogg_c2:",SQLCA.sqlcode,1)
             LET g_success='N' EXIT FOREACH
          END IF 
          IF l_ima906 ='2' THEN
             IF NOT cl_null(l_ogb.ogb910) THEN
                SELECT * INTO l_imgg.* FROM imgg_file
                 WHERE imgg01= l_ogb.ogb04 AND imgg02= p_ware
                   AND imgg03= p_loca      AND imgg04= p_lot
                   AND imgg09= l_ogb.ogb910
                IF STATUS <> 0 THEN            ## 新增一筆img_file
                   CALL t600sub_set_imgg(l_ogb.ogb910,p_ware,p_loca,p_lot,l_ogb.*) RETURNING l_imgg.*
       
                   LET l_imgg.imggplant = g_plant 
                   LET l_imgg.imgglegal = g_legal 
       
                   INSERT INTO imgg_file VALUES (l_imgg.*)
                   IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                      CALL cl_err3("ins","imgg_file","","",SQLCA.sqlcode,"","ins img:",1)  #No.FUN-670008
                      LET g_success='N' RETURN
                   END IF
                END IF
                CALL t600sub_upd_imgg('1',l_imgg.imgg01,l_imgg.imgg02,l_imgg.imgg03,l_imgg.imgg04,
                                   l_ogb.ogb910,l_ogb.ogb911,l_qty1,+1,'1',l_oga.*)
                IF g_success='N' THEN RETURN END IF
                IF NOT cl_null(l_ogb.ogb912) THEN                                            #CHI-860005
                   CALL t600sub_contlff('1',l_imgg.imgg02,l_imgg.imgg03,l_imgg.imgg04,
                                      l_ogb.ogb910,l_ogb.ogb911,l_qty1,l_oga.*,l_ogb.*,'1')
                END IF   #No.MOD-790136 add
                IF g_success='N' THEN RETURN END IF
             END IF
          END IF                   
       END FOREACH 
    ELSE
#FUN-C50097 ADD END -----    	 
       IF l_ima906 MATCHES '[23]' THEN
          IF NOT cl_null(l_ogb.ogb913) THEN
             SELECT * INTO l_imgg.* FROM imgg_file
              WHERE imgg01= l_ogb.ogb04
                AND imgg02= p_ware
                AND imgg03= p_loca
                AND imgg04= p_lot
                AND imgg09= l_ogb.ogb913
             IF STATUS <> 0 THEN            ## 新增一筆img_file
                CALL t600sub_set_imgg(l_ogb.ogb913,p_ware,p_loca,p_lot,l_ogb.*) RETURNING l_imgg.*
    
                LET l_imgg.imggplant = g_plant 
                LET l_imgg.imgglegal = g_legal 
    
                INSERT INTO imgg_file VALUES (l_imgg.*)
                IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                   CALL cl_err3("ins","imgg_file","","",SQLCA.sqlcode,"","ins img:",1)  #No.FUN-670008
                   LET g_success='N' RETURN
                END IF
             END IF
             IF l_ima906 = '2' THEN
                CALL t600sub_upd_imgg('1',l_imgg.imgg01,l_imgg.imgg02,l_imgg.imgg03,l_imgg.imgg04,
                                   l_ogb.ogb913,l_ogb.ogb914,l_qty2,+1,'2',l_oga.*)
                IF g_success='N' THEN RETURN END IF
                IF NOT cl_null(l_ogb.ogb915) THEN                                            #CHI-860005
                   CALL t600sub_contlff('2',l_imgg.imgg02,l_imgg.imgg03,l_imgg.imgg04,
                                      l_ogb.ogb913,l_ogb.ogb914,l_ogb.ogb915,l_oga.*,l_ogb.*,'2')
                END IF   #No.MOD-790136 add
                IF g_success='N' THEN RETURN END IF
             ELSE
                CALL t600sub_upd_imgg('2',l_imgg.imgg01,l_imgg.imgg02,l_imgg.imgg03,l_imgg.imgg04,
                                   l_ogb.ogb913,l_ogb.ogb914,l_qty2,+1,'2',l_oga.*)
                IF g_success='N' THEN RETURN END IF
                IF NOT cl_null(l_ogb.ogb915) THEN                                            #CHI-860005
                   CALL t600sub_contlff('2',l_imgg.imgg02,l_imgg.imgg03,l_imgg.imgg04,
                                      l_ogb.ogb913,l_ogb.ogb914,l_ogb.ogb915,l_oga.*,l_ogb.*,'2')
                END IF   #No.MOD-790136 add
                IF g_success='N' THEN RETURN END IF
             END IF
          END IF
       END IF
       IF l_ima906 ='2' THEN
          IF NOT cl_null(l_ogb.ogb910) THEN
             SELECT * INTO l_imgg.* FROM imgg_file
              WHERE imgg01= l_ogb.ogb04 AND imgg02= p_ware
                AND imgg03= p_loca      AND imgg04= p_lot
                AND imgg09= l_ogb.ogb910
             IF STATUS <> 0 THEN            ## 新增一筆img_file
                CALL t600sub_set_imgg(l_ogb.ogb910,p_ware,p_loca,p_lot,l_ogb.*) RETURNING l_imgg.*
    
                LET l_imgg.imggplant = g_plant 
                LET l_imgg.imgglegal = g_legal 
    
                INSERT INTO imgg_file VALUES (l_imgg.*)
                IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                   CALL cl_err3("ins","imgg_file","","",SQLCA.sqlcode,"","ins img:",1)  #No.FUN-670008
                   LET g_success='N' RETURN
                END IF
             END IF
             CALL t600sub_upd_imgg('1',l_imgg.imgg01,l_imgg.imgg02,l_imgg.imgg03,l_imgg.imgg04,
                                l_ogb.ogb910,l_ogb.ogb911,l_qty1,+1,'1',l_oga.*)
             IF g_success='N' THEN RETURN END IF
             IF NOT cl_null(l_ogb.ogb912) THEN                                            #CHI-860005
                CALL t600sub_contlff('1',l_imgg.imgg02,l_imgg.imgg03,l_imgg.imgg04,
                                   l_ogb.ogb910,l_ogb.ogb911,l_ogb.ogb912,l_oga.*,l_ogb.*,'2')
             END IF   #No.MOD-790136 add
             IF g_success='N' THEN RETURN END IF
          END IF
       END IF
    END IF  #FUN-C50097 ADD    
 
END FUNCTION
 
FUNCTION t600sub_contlff(p_flag,p_ware,p_loc,p_lot,p_unit,p_fac,p_qty,l_oga,l_ogb,p_type) #No.FUN-630061
   DEFINE
      p_flag     LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
      l_ogb      RECORD LIKE ogb_file.*,    #No.FUN-630061
      p_ware     LIKE ogb_file.ogb09,       ##倉庫
      p_loc      LIKE ogb_file.ogb091,      ##儲位
      p_lot      LIKE ogb_file.ogb092,      ##批號
      p_unit     LIKE ima_file.ima25,
      p_fac      LIKE img_file.img21,
      p_qty      LIKE ogc_file.ogc12,       ##銷售數量(銷售單位)
      l_imgg10   LIKE img_file.img10,       #異動後數量
      l_sfb02    LIKE sfb_file.sfb02,
      l_sfb03    LIKE sfb_file.sfb03,
      l_sfb04    LIKE sfb_file.sfb04,
      l_sfb22    LIKE sfb_file.sfb22,
      l_sfb27    LIKE sfb_file.sfb27,
      l_sta      LIKE type_file.num5,    #No.FUN-680137 SMALLINT
      #g_cnt      LIKE type_file.num5,    #No.FUN-680137 SMALLINT
      l_ima86    LIKE ima_file.ima86,    #FUN-730018
      l_oga      RECORD LIKE oga_file.*
DEFINE l_argv0 LIKE ogb_file.ogb09 #FUN-C40072 add
DEFINE p_type     LIKE type_file.chr1  #FUN-C50097 ADD  #多仓储出货

   LET l_argv0=l_oga.oga09 #FUN-C40072 add
 
   SELECT imgg10 INTO l_imgg10 FROM imgg_file
    WHERE imgg01=l_ogb.ogb04  AND imgg02=p_ware
      AND imgg03=p_loc        AND imgg04=p_lot
      AND imgg09=p_unit
   IF cl_null(l_imgg10) THEN LET l_imgg10=0 END IF
   SELECT ima86 INTO l_ima86 FROM ima_file
                            WHERE ima01=l_ogb.ogb04
   #----來源----
   LET g_tlff.tlff01=l_ogb.ogb04         #異動料件編號
   LET g_tlff.tlff02=724
   LET g_tlff.tlff020=' '
   LET g_tlff.tlff021=' '                #倉庫
   LET g_tlff.tlff022=' '                #儲位
   LET g_tlff.tlff023=' '                #批號
   LET g_tlff.tlff024=' '                #異動後庫存數量
   LET g_tlff.tlff025=' '                #庫存單位(ima_file or img_file)
   LET g_tlff.tlff026=l_ogb.ogb31        #出貨單號
   LET g_tlff.tlff027=l_ogb.ogb32        #出貨項次
   #---目的----
   LET g_tlff.tlff03=50                  #'Stock'
   LET g_tlff.tlff030=l_ogb.ogb08
   LET g_tlff.tlff031=p_ware             #倉庫
   LET g_tlff.tlff032=p_loc              #儲位
   LET g_tlff.tlff033=p_lot              #批號
   LET g_tlff.tlff034=l_imgg10           #異動後數量
   LET g_tlff.tlff035=p_unit             #庫存單位(ima_file or img_file)
   LET g_tlff.tlff036=l_ogb.ogb01        #訂單單號
   LET g_tlff.tlff037=l_ogb.ogb03        #訂單項次
   #-->異動數量
   LET g_tlff.tlff04= ' '             #工作站
   LET g_tlff.tlff05= ' '             #作業序號
   LET g_tlff.tlff06=l_oga.oga02      #發料日期
   LET g_tlff.tlff07=g_today          #異動資料產生日期
   LET g_tlff.tlff08=TIME             #異動資料產生時:分:秒
   LET g_tlff.tlff09=g_user           #產生人
   LET g_tlff.tlff10=p_qty            #異動數量
   LET g_tlff.tlff11=p_unit           #發料單位
   LET g_tlff.tlff12 =p_fac           #發料/庫存 換算率
#MOD-D20054---begin mark
##FUN-C40072---add---START
#   IF l_argv0 = '4' THEN
#      LET g_tlff.tlff13='axmt820'
#   ELSE
##FUN-C40072---add-----END
#MOD-D20054---end
      LET g_tlff.tlff13='axmt620'
#   END IF #FUN-C40072 add  #MOD-D20054
   LET g_tlff.tlff14=' '              #異動原因
   LET g_tlff.tlff17='To Consign Warehouse'
   CALL s_imaQOH(l_ogb.ogb04)
        RETURNING g_tlff.tlff18
   LET g_tlff.tlff19=l_oga.oga04
   LET g_tlff.tlff20 = l_oga.oga46
   LET g_tlff.tlff61= l_ima86 #FUN-730018
   LET g_tlff.tlff62=l_ogb.ogb31    #參考單號(訂單)
   LET g_tlff.tlff63=l_ogb.ogb32    #訂單項次
   LET g_tlff.tlff64=l_ogb.ogb908   #手冊編號 no.A050
   LET g_tlff.tlff930=l_ogb.ogb930 #FUN-670063
   IF p_type = "1" THEN   #No:FUN-C50097
      CALL s_tlff(p_flag,NULL)   #No:FUN-C50097
   ELSE   #No:FUN-C50097
      IF cl_null(l_ogb.ogb915) OR l_ogb.ogb915=0 THEN
         CALL s_tlff(p_flag,NULL)
      ELSE
         CALL s_tlff(p_flag,l_ogb.ogb913) 
      END IF
   END IF 
END FUNCTION
 
FUNCTION t600sub_set_imgg(p_unit,p_ware,p_loca,p_lot,l_ogb)  #No.FUN-630061
   DEFINE l_imgg     RECORD LIKE imgg_file.*,
          p_ware     LIKE img_file.img02,
          l_ogb      RECORD LIKE ogb_file.*,
          p_loca     LIKE img_file.img03,
          p_lot      LIKE img_file.img04,
          p_unit     LIKE ima_file.ima25,
          l_img09    LIKE img_file.img09,
          l_ima25    LIKE ima_file.ima25,
          l_cnt      LIKE type_file.num5
   DEFINE l_factor   LIKE img_file.img21
   DEFINE l_ima906   LIKE ima_file.ima906   #MOD-9B0189
   INITIALIZE l_imgg.* TO NULL
   SELECT ima906 INTO l_ima906 FROM ima_file
     WHERE ima01=l_ogb.ogb04
   IF l_ima906 = '2' THEN LET l_imgg.imgg00 = '1' END IF
   IF l_ima906 = '3' THEN LET l_imgg.imgg00 = '2' END IF
   LET l_imgg.imgg01=l_ogb.ogb04
   LET l_imgg.imgg02=p_ware
   LET l_imgg.imgg03=p_loca
   LET l_imgg.imgg04=p_lot
   LET l_imgg.imgg05=l_ogb.ogb01
   LET l_imgg.imgg06=l_ogb.ogb03
   LET l_imgg.imgg09=p_unit
   LET l_imgg.imgg10=0
   LET l_imgg.imgg13=null   #No:7304
   LET l_imgg.imgg17=g_today
   IF g_prog[1,7] = 'axmt628' THEN #MOD-CA0048 add
      LET l_imgg.imgg18=MDY(12,31,9999)
   #MOD-CA0048 add start -----
   ELSE
      SELECT imgg18 INTO l_imgg.imgg18 FROM imgg_file
       WHERE imgg01 = l_ogb.ogb01 AND imgg02 = l_ogb.ogb09
         AND imgg03 = l_ogb.ogb091 AND imgg04 = l_ogb.ogb092
      IF STATUS THEN
         LET l_imgg.imgg18=MDY(12,31,9999)
      END IF
   END IF
   #MOD-CA0048 add end   -----
   SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01=l_ogb.ogb04
   LET l_factor=1
   CALL s_umfchk(l_ogb.ogb04,l_imgg.imgg09,l_ima25)
        RETURNING l_cnt,l_factor
   IF l_cnt THEN
      LET l_factor = 1
   END IF
   LET l_imgg.imgg21=l_factor
   SELECT img09 INTO l_img09 FROM img_file
    WHERE img01= l_ogb.ogb04 AND img02= p_ware
      AND img03= p_loca      AND img04= p_lot
   LET l_factor=1
   CALL s_umfchk(l_ogb.ogb04,l_imgg.imgg09,l_img09)
        RETURNING l_cnt,l_factor
   IF l_cnt THEN
      LET l_factor = 1
   END IF
   LET l_imgg.imgg211=l_factor
 
   LET l_imgg.imgg22='S'
   SELECT imd10,imd11,imd12,imd13 INTO
          l_imgg.imgg22, l_imgg.imgg23, l_imgg.imgg24, l_imgg.imgg25
     FROM imd_file WHERE imd01=l_imgg.imgg02
   LET l_imgg.imgg30=0
   LET l_imgg.imgg31=0
   LET l_imgg.imgg32=0
   LET l_imgg.imgg33=0
   LET l_imgg.imgg34=1
   IF l_imgg.imgg02 IS NULL THEN LET l_imgg.imgg02 = ' ' END IF
   IF l_imgg.imgg03 IS NULL THEN LET l_imgg.imgg03 = ' ' END IF
   IF l_imgg.imgg04 IS NULL THEN LET l_imgg.imgg04 = ' ' END IF
   RETURN l_imgg.*
 
END FUNCTION
 
#變更狀況碼
FUNCTION t600sub_chstatus(l_new,l_oga)
DEFINE l_new  LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
DEFINE l_oga  RECORD LIKE oga_file.*
    LET l_oga.ogaconf=l_new
    CASE l_new
      WHEN 'N'  #取消確認
        UPDATE oga_file SET oga55='0' WHERE oga01=l_oga.oga01
        IF SQLCA.sqlcode THEN
           LET g_success='N'
           RETURN l_oga.*
        END IF
        LET l_oga.oga55='0'
      WHEN 'Y'  #確認
          UPDATE oga_file SET oga55='1' WHERE oga01=l_oga.oga01
          IF SQLCA.sqlcode THEN
             LET g_success='N'
             RETURN l_oga.*
          END IF
          LET l_oga.oga55='1'
      WHEN 'X'  #作廢
        UPDATE oga_file SET oga55='9' WHERE oga01=l_oga.oga01
        IF SQLCA.sqlcode THEN
           LET g_success='N'
           RETURN l_oga.*
        END IF
        LET l_oga.oga55='9'
    END CASE
    RETURN l_oga.*
END FUNCTION
 
FUNCTION t600sub_refresh(p_oga01)
  DEFINE p_oga01 LIKE oga_file.oga01
  DEFINE l_oga   RECORD LIKE oga_file.*
 
  SELECT * INTO l_oga.* FROM oga_file WHERE oga01=p_oga01
  RETURN l_oga.*
END FUNCTION
 
FUNCTION t600sub_imm(p_oga01)
   DEFINE p_oga01  LIKE oga_file.oga01
   DEFINE l_oga    RECORD LIKE oga_file.*
   DEFINE l_ogb    RECORD LIKE ogb_file.*
   DEFINE l_imm    RECORD LIKE imm_file.*
   DEFINE l_imn    RECORD LIKE imn_file.*
   DEFINE l_sql    STRING
   DEFINE li_result LIKE type_file.num5
   DEFINE l_msg    STRING
   DEFINE l_imm03  LIKE imm_file.imm03
   DEFINE l_tot    LIKE oeb_file.oeb24
   DEFINE l_tot1   LIKE oeb_file.oeb24
   DEFINE l_ocn03  LIKE ocn_file.ocn03
   DEFINE l_ocn04  LIKE ocn_file.ocn04
   DEFINE l_cnt    LIKE type_file.num5  #FUN-930038
   DEFINE l_idb    RECORD LIKE idb_file.*      #FUN-930038
   DEFINE l_flag   LIKE type_file.num5   #MOD-950143
   DEFINE l_fac    LIKE type_file.num26_10  #MOD-950143
   DEFINE l_ogg    RECORD LIKE ogg_file.*   #MOD-A70150
   DEFINE l_ogc    RECORD LIKE ogc_file.*   #MOD-A70150
   DEFINE l_ima906 LIKE ima_file.ima906     #MOD-A70150
   DEFINE l_rvbs   RECORD LIKE rvbs_file.*   #MOD-AC0060
   DEFINE l_imni   RECORD LIKE imni_file.*   #FUN-B70074
 
   SELECT * INTO l_oga.* FROM oga_file WHERE oga01=p_oga01
   IF cl_null(l_oga.oga01) THEN
      CALL cl_err('',-400,0)
      RETURN ""
   END IF
 
   BEGIN WORK
 
   LET g_success = "Y"
 
   LET l_imm.imm12=""         #MOD-A60070 add

   CALL s_auto_assign_no("aim",g_oaz.oaz79,l_oga.oga02,"","imm_file",  #NO.CHI-780041   #MOD-870201
                         "imm01","","","")
               RETURNING li_result,l_imm.imm01
   IF (NOT li_result) THEN
      LET g_success = "N"
      ROLLBACK WORK   #MOD-C50142 add
      RETURN ""       #MOD-C50142 add
   END IF
 
   LET l_imm.imm02 = l_oga.oga02   #MOD-860190
   LET l_imm.imm03 = "N"
   LET l_imm.imm10 = "1"
   LET l_imm.imm14 = g_grup
   LET l_imm.immconf = "Y"
   LET l_imm.imm09 = p_oga01       #FUN-870136
   LET l_imm.immuser=g_user
   LET l_imm.immgrup=g_grup
   LET l_imm.immdate=g_today
   LET l_imm.immplant = l_oga.ogaplant  #No.FUN-870007
   LET l_imm.immlegal = l_oga.ogalegal  #No.FUN-870007
 
   LET l_imm.immplant = g_plant 
   LET l_imm.immlegal = g_legal 
 
   LET l_imm.immoriu = g_user      #No.FUN-980030 10/01/04
   LET l_imm.immorig = g_grup      #No.FUN-980030 10/01/04
   #FUN-A60034--add---str---
   #FUN-A70104--mod---str---
   LET l_imm.immmksg = 'N'          #是否簽核
   LET l_imm.imm15 = '1'            #簽核狀況  #MOD-CA0203 mod
   LET l_imm.imm16 = l_oga.oga14    #申請人
   #FUN-A70104--mod---end---
   #FUN-A60034--add---end---
   INSERT INTO imm_file VALUES (l_imm.*)
   IF STATUS THEN
      LET g_success = "N"
   END IF
 
   LET l_sql = "SELECT * FROM ogb_file WHERE ogb01='",p_oga01,"'"
 
   PREPARE pre_imn FROM l_sql
   DECLARE imn_curs CURSOR FOR pre_imn
 
   FOREACH imn_curs INTO l_ogb.*
      #MOD-D10185 add start -----
      IF l_ogb.ogb04[1,4] = 'MISC' THEN
         CONTINUE FOREACH
      END IF
      #MOD-D10185 add start -----
      #-----MOD-A70150---------
      IF l_ogb.ogb17 = 'Y' THEN
         IF g_sma.sma115 = 'Y' THEN
            LET l_sql = "SELECT * FROM ogg_file ",
                        " WHERE ogg01 = '",l_oga.oga01,"'",
                        "   AND ogg03 = ",l_ogb.ogb03
            PREPARE pre_ogg FROM l_sql
            DECLARE ogg_curs CURSOR FOR pre_ogg
            FOREACH ogg_curs INTO l_ogg.*
               IF cl_null(l_ogg.ogg17) THEN
                  LET l_ogg.ogg17 = l_ogb.ogb04  
               END IF
               LET l_imn.imn01 = l_imm.imm01
               SELECT MAX(imn02) + 1 INTO l_imn.imn02
                 FROM imn_file WHERE imn01 = l_imm.imm01
               IF l_imn.imn02 IS NULL THEN
                  LET l_imn.imn02 = 1
               END IF
               LET l_imn.imn03 = l_ogg.ogg17
               LET l_imn.imn04 = l_ogg.ogg09
               LET l_imn.imn05 = l_ogg.ogg091
               LET l_imn.imn06 = l_ogg.ogg092
               #MOD-B90118 --- start ---
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM img_file
                 WHERE img01 = l_imn.imn03  
                   AND img02 = l_imn.imn04 
                   AND img03 = l_imn.imn05
                   AND img04 = l_imn.imn06

               IF l_cnt <= 0 THEN
                  CALL s_add_img(l_imn.imn03,l_imn.imn04,
                                 l_imn.imn05,l_imn.imn06,
                                 l_imm.imm01,l_imn.imn02,l_imm.imm02)
                  IF g_errno='N' THEN
                     LET g_success = 'N'
                  END IF
               END IF
               #MOD-B90118 ---  end  ---
               SELECT img09 INTO l_imn.imn09 FROM img_file
                 WHERE img01 = l_imn.imn03  
                   AND img02 = l_imn.imn04 
                   AND img03 = l_imn.imn05
                   AND img04 = l_imn.imn06
               CALL s_umfchk(l_imn.imn03,l_ogg.ogg10,l_imn.imn09)
                     RETURNING l_flag,l_fac
               IF l_flag = 1 THEN
                  LET l_fac = 1
               END IF
               LET l_imn.imn10 = l_ogg.ogg12 * l_fac
               LET l_imn.imn10 = s_digqty(l_imn.imn10,l_imn.imn09)   #FUN-BB0084
               LET l_ima906 = ''
               SELECT ima906 INTO l_ima906 FROM ima_file 
                 WHERE ima01=l_imn.imn03
               IF l_ima906 = '3' AND l_ogg.ogg20 = '2' THEN
                  LET l_imn.imn10 = 0
               END IF
               LET l_imn.imn28 = l_ogb.ogb1001
               LET l_imn.imn29 = "N"
               IF l_ogg.ogg20 = 1 THEN 
                  LET l_imn.imn30 = l_ogg.ogg10
                  CALL s_du_umfchk(l_imn.imn03,'','','',
                                   l_imn.imn09,l_imn.imn30,'1')
                       RETURNING g_errno,l_imn.imn31
                  LET l_imn.imn32 = l_ogg.ogg12
                  LET l_imn.imn33 = ""
                  LET l_imn.imn34 = 0
                  LET l_imn.imn35 = 0
               ELSE
                  LET l_imn.imn30 = ""
                  LET l_imn.imn31 = 0
                  LET l_imn.imn32 = 0
                  LET l_imn.imn33 = l_ogg.ogg10
                  CALL s_du_umfchk(l_imn.imn03,'','','',
                                   l_imn.imn09,l_imn.imn33,'2')
                       RETURNING g_errno,l_imn.imn34
                  LET l_imn.imn35 = l_ogg.ogg12
               END IF
               LET l_imn.imn15 = g_oaz.oaz78
               LET l_imn.imn16 = " "    
               LET l_imn.imn17 = l_oga.oga03
               IF (NOT cl_null(l_imn.imn03)) 
                 AND (NOT cl_null(l_imn.imn15)) THEN 
                 SELECT * FROM img_file
                  WHERE img01=l_imn.imn03
                    AND img02=l_imn.imn15
                    AND img03=l_imn.imn16
                    AND img04=l_imn.imn17
                 IF STATUS=100 THEN
                    IF NOT cl_confirm('mfg1401') THEN
                       LET g_success = 'N'
                    ELSE
                       CALL s_add_img(l_imn.imn03,l_imn.imn15,
                                       l_imn.imn16,l_imn.imn17,
                                       l_imm.imm01,l_imn.imn02,l_imm.imm02)
                       IF g_errno='N' THEN
                           LET g_success = 'N'
                       END IF
                    END IF
                 END IF
               END IF
               SELECT img09 INTO l_imn.imn20 FROM img_file
                 WHERE img01 = l_imn.imn03  
                   AND img02 = l_imn.imn15 
                   AND img03 = l_imn.imn16
                   AND img04 = l_imn.imn17
               IF l_ima906 = '2' OR (l_ima906 = '3' AND l_ogg.ogg20 = '2') THEN    
                  IF (NOT cl_null(l_imn.imn03)) 
                    AND (NOT cl_null(l_imn.imn15)) THEN 
                    CALL s_chk_imgg(l_imn.imn03,l_imn.imn15,
                                    l_imn.imn16,l_imn.imn17,
                                    l_ogg.ogg10) RETURNING g_flag
                   IF g_flag = 1 THEN
                      IF NOT cl_confirm('mfg1401') THEN
                         LET g_success = 'N'
                      ELSE
                         CALL s_umfchk(l_imn.imn03,l_ogg.ogg10,l_ogb.ogb05)
                               RETURNING l_flag,l_fac
                         CALL s_add_imgg(l_imn.imn03,l_imn.imn15,
                                         l_imn.imn16,l_imn.imn17,
                                         l_ogg.ogg10,l_fac,
                                         l_imm.imm01,
                                         l_imn.imn02,0) RETURNING g_flag
                         IF g_flag = 1 THEN
                             LET g_success = 'N'
                         END IF
                      END IF
                    END IF
                  END IF
                  SELECT imgg09 INTO l_imn.imn20 FROM imgg_file
                    WHERE imgg01 = l_imn.imn03  
                      AND imgg02 = l_imn.imn15 
                      AND imgg03 = l_imn.imn16
                      AND imgg04 = l_imn.imn17
               END IF
               IF l_ogg.ogg20 = 1 THEN 
                  LET l_imn.imn40 = l_ogg.ogg10
                  CALL s_du_umfchk(l_imn.imn03,'','','',
                                   l_imn.imn20,l_imn.imn40,'1')
                       RETURNING g_errno,l_imn.imn41
                  LET l_imn.imn42 = l_ogg.ogg12
                  LET l_imn.imn43 = ""
                  LET l_imn.imn44 = 0
                  LET l_imn.imn45 = 0
               ELSE
                  LET l_imn.imn40 = ""
                  LET l_imn.imn41 = 0
                  LET l_imn.imn42 = 0
                  LET l_imn.imn43 = l_ogg.ogg10
                  CALL s_du_umfchk(l_imn.imn03,'','','',
                                   l_imn.imn20,l_imn.imn43,'1')
                       RETURNING g_errno,l_imn.imn44
                  LET l_imn.imn45 = l_ogg.ogg12
               END IF
               IF l_ogg.ogg20 = 1 THEN 
                  CALL s_umfchk(l_imn.imn03,l_imn.imn30,l_imn.imn40)
                        RETURNING l_flag,l_imn.imn51
                  IF l_flag = 1 THEN
                     LET l_imn.imn51 = 1
                  END IF
                  LET l_imn.imn52 = 0 
               ELSE   
                  CALL s_umfchk(l_imn.imn03,l_imn.imn33,l_imn.imn43)
                        RETURNING l_flag,l_imn.imn52
                  IF l_flag = 1 THEN
                     LET l_imn.imn52 = 1
                  END IF
                  LET l_imn.imn51 = 0 
               END IF
               LET l_imn.imn9301 = s_costcenter(l_imm.imm14)
               LET l_imn.imn9302 = l_imn.imn9301
               CALL s_umfchk(l_imn.imn03,l_imn.imn09,l_imn.imn20)
                     RETURNING l_flag,l_imn.imn21
               IF l_flag = 1 THEN
                  LET l_imn.imn21 = 1
               END IF
               LET l_imn.imn22 = l_imn.imn10 * l_imn.imn21
               LET l_imn.imn22 = s_digqty(l_imn.imn22,l_imn.imn20)      #FUN-BB0084 
               INSERT INTO imn_file VALUES (l_imn.*)
               IF STATUS THEN
                  LET g_success = "N"
               #FUN-B70074-add-str--
               ELSE 
                  IF NOT s_industry('std') THEN 
                     INITIALIZE l_imni.* TO NULL
                     LET l_imni.imni01 = l_imn.imn01
                     LET l_imni.imni02 = l_imn.imn02
                     IF NOT s_ins_imni(l_imni.*,l_imn.imnplant) THEN 
                        LET g_success = 'N'
                     END IF
                  END IF
               #FUN-B70074-add-end--
               END IF
               #-----MOD-AC0060---------
               LET g_ima918 = ''  
               LET g_ima921 = ''  
               SELECT ima918,ima921 INTO g_ima918,g_ima921 
                 FROM ima_file
                WHERE ima01 = l_imn.imn03
                  AND imaacti = "Y"
               
               IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                  DECLARE t600_rvbs_1 CURSOR FOR SELECT * FROM rvbs_file
                                                 WHERE rvbs01 = l_oga.oga01
                                                   AND rvbs02 = l_ogb.ogb03
                                                   AND rvbs13 = l_ogg.ogg18
                  FOREACH t600_rvbs_1 INTO l_rvbs.*
                     IF STATUS THEN
                        CALL cl_err('rvbs',STATUS,1)
                     END IF
               
                     LET l_rvbs.rvbs00 = 'aimt324' 
                     LET l_rvbs.rvbs01 = l_imn.imn01
                     LET l_rvbs.rvbs02 = l_imn.imn02
                     LET l_rvbs.rvbs13 = 0
               
                     INSERT INTO rvbs_file VALUES(l_rvbs.*)
                     IF STATUS OR SQLCA.SQLCODE THEN
                        CALL cl_err3("ins","rvbs_file","","",SQLCA.sqlcode,"","ins rvbs",1)  
                        LET g_success = 'N'
                     END IF
                  END FOREACH
                  #MOD-B50204 add --start--    
                  DELETE FROM rvbs_file WHERE rvbs00 = 'aimt324'
                                          AND rvbs01 = l_imn.imn01
                                          AND rvbs02 = l_imn.imn02
                                          AND rvbs13 = 0
                                          AND rvbs09 = 1
                  DECLARE t600_rvbs_11 CURSOR FOR SELECT * FROM rvbs_file
                                                  WHERE rvbs00 = 'aimt324'
                                                    AND rvbs01 = l_imn.imn01
                                                    AND rvbs02 = l_imn.imn02
                                                    AND rvbs13 = 0
                                                    AND rvbs09 = -1
                  FOREACH t600_rvbs_11 INTO l_rvbs.*
                     IF STATUS THEN         
                        CALL cl_err('rvbs',STATUS,1)
                     END IF
                   
                     LET l_rvbs.rvbs09 = 1
                  
                     INSERT INTO rvbs_file VALUES(l_rvbs.*)
                     IF STATUS OR SQLCA.SQLCODE THEN
                        CALL cl_err3("ins","rvbs_file","","",SQLCA.sqlcode,"","ins rvbs",1)
                        LET g_success = 'N'
                     END IF
                  END FOREACH
                  #MOD-B50204 add --end--
               END IF
               #-----END MOD-AC0060-----

            END FOREACH
         ELSE
            LET l_sql = "SELECT * FROM ogc_file ",
                        " WHERE ogc01 = '",l_oga.oga01,"'",
                        "   AND ogc03 = ",l_ogb.ogb03
            PREPARE pre_ogc FROM l_sql
            DECLARE ogc_curs CURSOR FOR pre_ogc
            FOREACH ogc_curs INTO l_ogc.*
               LET l_imn.imn01 = l_imm.imm01
               SELECT MAX(imn02) + 1 INTO l_imn.imn02
                 FROM imn_file WHERE imn01 = l_imm.imm01
               IF l_imn.imn02 IS NULL THEN
                  LET l_imn.imn02 = 1
               END IF
               LET l_imn.imn03 = l_ogc.ogc17
               LET l_imn.imn04 = l_ogc.ogc09
               LET l_imn.imn05 = l_ogc.ogc091
               LET l_imn.imn06 = l_ogc.ogc092
               #MOD-B90118 --- start ---
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM img_file
                 WHERE img01 = l_imn.imn03  
                   AND img02 = l_imn.imn04 
                   AND img03 = l_imn.imn05
                   AND img04 = l_imn.imn06

               IF l_cnt <= 0 THEN
                  CALL s_add_img(l_imn.imn03,l_imn.imn04,
                                 l_imn.imn05,l_imn.imn06,
                                 l_imm.imm01,l_imn.imn02,l_imm.imm02)
                  IF g_errno='N' THEN
                     LET g_success = 'N'
                  END IF
               END IF
               #MOD-B90118 ---  end  ---
               SELECT img09 INTO l_imn.imn09 FROM img_file
                 WHERE img01 = l_imn.imn03  
                   AND img02 = l_imn.imn04 
                   AND img03 = l_imn.imn05
                   AND img04 = l_imn.imn06
               CALL s_umfchk(l_imn.imn03,l_ogb.ogb05,l_imn.imn09)
                     RETURNING l_flag,l_fac
               IF l_flag = 1 THEN
                  LET l_fac = 1
               END IF
               LET l_imn.imn10 = l_ogc.ogc12 * l_fac
               LET l_imn.imn10 = s_digqty(l_imn.imn10,l_imn.imn09)   #FUN-BB0084
               LET l_imn.imn15 = g_oaz.oaz78
               LET l_imn.imn16 = " "    
               LET l_imn.imn17 = l_oga.oga03
               LET l_imn.imn28 = l_ogb.ogb1001
               LET l_imn.imn29 = "N"
               LET l_imn.imn30 = ""
               LET l_imn.imn31 = 0
               LET l_imn.imn32 = 0
               LET l_imn.imn33 = ""
               LET l_imn.imn34 = 0
               LET l_imn.imn35 = 0
               LET l_imn.imn40 = ""
               LET l_imn.imn41 = 0
               LET l_imn.imn42 = 0
               LET l_imn.imn43 = ""
               LET l_imn.imn44 = 0
               LET l_imn.imn45 = 0
               LET l_imn.imn51 = 0
               LET l_imn.imn52 = 0
               LET l_imn.imn9301 = s_costcenter(l_imm.imm14)
               LET l_imn.imn9302 = l_imn.imn9301
               IF (NOT cl_null(l_imn.imn03)) 
                 AND (NOT cl_null(l_imn.imn15))
                 THEN 
                 SELECT * FROM img_file
                  WHERE img01=l_imn.imn03
                    AND img02=l_imn.imn15
                    AND img03=l_imn.imn16
                    AND img04=l_imn.imn17
                 IF STATUS=100 THEN
                    IF NOT cl_confirm('mfg1401') THEN
                       LET g_success = 'N'
                    ELSE
                       CALL s_add_img(l_imn.imn03,l_imn.imn15,
                                       l_imn.imn16,l_imn.imn17,
                                       l_imm.imm01,l_imn.imn02,l_imm.imm02)
                       IF g_errno='N' THEN
                           LET g_success = 'N'
                       END IF
                    END IF
                 END IF
               END IF
               SELECT img09 INTO l_imn.imn20 FROM img_file
                 WHERE img01 = l_imn.imn03  
                   AND img02 = l_imn.imn15 
                   AND img03 = l_imn.imn16
                   AND img04 = l_imn.imn17
               CALL s_umfchk(l_imn.imn03,l_imn.imn09,l_imn.imn20)
                     RETURNING l_flag,l_imn.imn21
               IF l_flag = 1 THEN
                  LET l_imn.imn21 = 1
               END IF
               LET l_imn.imn22 = l_imn.imn10 * l_imn.imn21
               LET l_imn.imn22 = s_digqty(l_imn.imn22,l_imn.imn20)    #FUN-BB0084 
               INSERT INTO imn_file VALUES (l_imn.*)
               IF STATUS THEN
                  LET g_success = "N"
               #FUN-B70074-add-str--
               ELSE
                  IF NOT s_industry('std') THEN
                     INITIALIZE l_imni.* TO NULL
                     LET l_imni.imni01 = l_imn.imn01
                     LET l_imni.imni02 = l_imn.imn02
                     IF NOT s_ins_imni(l_imni.*,l_imn.imnplant) THEN
                        LET g_success = 'N'
                     END IF
                  END IF
               #FUN-B70074-add-end--
               END IF
               #-----MOD-AC0060---------
               LET g_ima918 = ''  
               LET g_ima921 = ''  
               SELECT ima918,ima921 INTO g_ima918,g_ima921 
                 FROM ima_file
                WHERE ima01 = l_imn.imn03
                  AND imaacti = "Y"
               
               IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                  DECLARE t600_rvbs_2 CURSOR FOR SELECT * FROM rvbs_file
                                                 WHERE rvbs01 = l_oga.oga01
                                                   AND rvbs02 = l_ogb.ogb03
                                                   AND rvbs13 = l_ogc.ogc18
                  FOREACH t600_rvbs_2 INTO l_rvbs.*
                     IF STATUS THEN
                        CALL cl_err('rvbs',STATUS,1)
                     END IF
               
                     LET l_rvbs.rvbs00 = 'aimt324' 
                     LET l_rvbs.rvbs01 = l_imn.imn01
                     LET l_rvbs.rvbs02 = l_imn.imn02
                     LET l_rvbs.rvbs13 = 0
               
                     INSERT INTO rvbs_file VALUES(l_rvbs.*)
                     IF STATUS OR SQLCA.SQLCODE THEN
                        CALL cl_err3("ins","rvbs_file","","",SQLCA.sqlcode,"","ins rvbs",1)  
                        LET g_success = 'N'
                     END IF
                  END FOREACH
                  #MOD-B50204 add --start--
                  DELETE FROM rvbs_file WHERE rvbs00 = 'aimt324'
                                          AND rvbs01 = l_imn.imn01
                                          AND rvbs02 = l_imn.imn02
                                          AND rvbs13 = 0
                                          AND rvbs09 = 1
                  DECLARE t600_rvbs_22 CURSOR FOR SELECT * FROM rvbs_file
                                                  WHERE rvbs00 = 'aimt324'
                                                    AND rvbs01 = l_imn.imn01
                                                    AND rvbs02 = l_imn.imn02
                                                    AND rvbs13 = 0
                                                    AND rvbs09 = -1
                  FOREACH t600_rvbs_22 INTO l_rvbs.*
                     IF STATUS THEN              
                        CALL cl_err('rvbs',STATUS,1)
                     END IF

                     LET l_rvbs.rvbs09 = 1

                     INSERT INTO rvbs_file VALUES(l_rvbs.*)
                     IF STATUS OR SQLCA.SQLCODE THEN
                        CALL cl_err3("ins","rvbs_file","","",SQLCA.sqlcode,"","ins rvbs",1)
                        LET g_success = 'N'
                     END IF
                  END FOREACH
                  #MOD-B50204 add --end--
               END IF
               #-----END MOD-AC0060-----
            END FOREACH
         END IF
         CONTINUE FOREACH
      END IF
      #-----END MOD-A70150-----  

      LET l_imn.imn01 = l_imm.imm01
      IF s_industry('icd') THEN #for ICD 拋轉成的調撥單項次需和出貨單項次相同,以便後續扣帳還原時,能將調撥單的刻號/BIN資料拋轉回借貨單
         LET l_imn.imn02 = l_ogb.ogb03
      ELSE
         SELECT MAX(imn02) + 1 INTO l_imn.imn02
           FROM imn_file WHERE imn01 = l_imm.imm01
         IF l_imn.imn02 IS NULL THEN
            LET l_imn.imn02 = 1
         END IF
      END IF
 
      LET l_imn.imn03 = l_ogb.ogb04
      LET l_imn.imn04 = l_ogb.ogb09
      LET l_imn.imn05 = l_ogb.ogb091
      LET l_imn.imn06 = l_ogb.ogb092
      #MOD-B90118 --- start ---
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM img_file
       WHERE img01 = l_imn.imn03
         AND img02 = l_imn.imn04
         AND img03 = l_imn.imn05
         AND img04 = l_imn.imn06

      IF l_cnt <= 0 THEN
         CALL s_add_img(l_imn.imn03,l_imn.imn04,
                        l_imn.imn05,l_imn.imn06,
                        l_imm.imm01,l_imn.imn02,l_imm.imm02)
         IF g_errno='N' THEN
            LET g_success = 'N'
         END IF
      END IF
      #MOD-B90118 ---  end  ---
      SELECT img09 INTO l_imn.imn09 FROM img_file
        WHERE img01 = l_imn.imn03
          AND img02 = l_imn.imn04
          AND img03 = l_imn.imn05
          AND img04 = l_imn.imn06
      CALL s_umfchk(l_imn.imn03,l_ogb.ogb05,l_imn.imn09)
            RETURNING l_flag,l_fac
      IF l_flag = 1 THEN
         LET l_fac = 1
      END IF
      LET l_imn.imn10 = l_ogb.ogb12 * l_fac
      LET l_imn.imn10 = s_digqty(l_imn.imn10,l_imn.imn09)   #FUN-BB0084
      LET l_imn.imn15 = g_oaz.oaz78
      LET l_imn.imn16 = " "
      LET l_imn.imn17 = l_oga.oga03
      LET l_imn.imn28 = l_ogb.ogb1001
      LET l_imn.imn29 = "N"
      #-----MOD-AC0023--------- 
      #LET l_imn.imn30 = l_ogb.ogb05
      #LET l_imn.imn31 = 1
      #LET l_imn.imn32 = l_ogb.ogb12
      #LET l_imn.imn33 = ""
      #LET l_imn.imn34 = 0
      #LET l_imn.imn35 = 0
      #LET l_imn.imn40 = l_ogb.ogb05
      #LET l_imn.imn41 = 1
      #LET l_imn.imn42 = l_imn.imn32
      #LET l_imn.imn43 = ""
      #LET l_imn.imn44 = 0
      #LET l_imn.imn45 = 0
      #LET l_imn.imn51 = 1
      #LET l_imn.imn52 = 0
      #-----END MOD-AC0023-----
      LET l_imn.imn9301 = s_costcenter(l_imm.imm14)
      LET l_imn.imn9302 = l_imn.imn9301
      LET l_imn.imnplant = l_ogb.ogbplant  #No.FUN-870007
      LET l_imn.imnlegal = l_ogb.ogblegal  #No.FUN-870007
      IF (NOT cl_null(l_imn.imn03))
        AND (NOT cl_null(l_imn.imn15))
        THEN
        SELECT * FROM img_file
         WHERE img01=l_imn.imn03
           AND img02=l_imn.imn15
           AND img03=l_imn.imn16
           AND img04=l_imn.imn17
        IF STATUS=100 THEN
           IF g_bgjob='N' OR cl_null(g_bgjob) THEN  #FUN-840012
              IF NOT cl_confirm('mfg1401') THEN
                 LET g_success = 'N'
              ELSE
                 CALL s_add_img(l_imn.imn03,l_imn.imn15,
                                 l_imn.imn16,l_imn.imn17,
                                 l_imm.imm01,l_imn.imn02,l_imm.imm02)
                 IF g_errno='N' THEN
                     LET g_success = 'N'
                 END IF
              END IF
           END IF
        END IF
        #-----MOD-AC0023---------
        IF g_sma.sma115 = 'Y' THEN 
           LET l_ima906 = ''
           SELECT ima906 INTO l_ima906 FROM ima_file 
             WHERE ima01=l_imn.imn03
           IF l_ima906 = '2' THEN 
              CALL s_chk_imgg(l_imn.imn03,l_imn.imn15,
                              l_imn.imn16,l_imn.imn17,
                              l_ogb.ogb910) RETURNING g_flag
              IF g_flag = 1 THEN
                 IF NOT cl_confirm('mfg1401') THEN
                    LET g_success = 'N'
                 ELSE
                    CALL s_add_imgg(l_imn.imn03,l_imn.imn15,
                                    l_imn.imn16,l_imn.imn17,
                                    l_ogb.ogb910,l_ogb.ogb911,
                                    l_imm.imm01,
                                    l_imn.imn02,0) RETURNING g_flag
                    IF g_flag = 1 THEN
                        LET g_success = 'N'
                    END IF
                 END IF
              END IF
           END IF
           
           IF l_ima906 = '2' OR l_ima906 = '3' THEN 
              CALL s_chk_imgg(l_imn.imn03,l_imn.imn15,
                              l_imn.imn16,l_imn.imn17,
                              l_ogb.ogb913) RETURNING g_flag
              IF g_flag = 1 THEN
                 IF NOT cl_confirm('mfg1401') THEN
                    LET g_success = 'N'
                 ELSE
                    CALL s_add_imgg(l_imn.imn03,l_imn.imn15,
                                    l_imn.imn16,l_imn.imn17,
                                    l_ogb.ogb913,l_ogb.ogb914,
                                    l_imm.imm01,
                                    l_imn.imn02,0) RETURNING g_flag
                    IF g_flag = 1 THEN
                        LET g_success = 'N'
                    END IF
                 END IF
              END IF
           END IF
        END IF
        #-----END MOD-AC0023-----
      END IF
      SELECT img09 INTO l_imn.imn20 FROM img_file
       WHERE img01 = l_imn.imn03
         AND img02 = l_imn.imn15
         AND img03 = l_imn.imn16
         AND img04 = l_imn.imn17
      CALL s_umfchk(l_imn.imn03,l_imn.imn09,l_imn.imn20)
           RETURNING l_flag,l_imn.imn21
      IF l_flag = 1 THEN
         LET l_imn.imn21 = 1
      END IF
      LET l_imn.imn22 = l_imn.imn10 * l_imn.imn21
      LET l_imn.imn22 = s_digqty(l_imn.imn22,l_imn.imn20)     #FUN-BB0084
      #-----MOD-AC0023---------
      LET l_imn.imn30 = l_ogb.ogb910
      CALL s_du_umfchk(l_imn.imn03,'','','',
                       l_imn.imn09,l_imn.imn30,'1')
           RETURNING g_errno,l_imn.imn31
      LET l_imn.imn32 = l_ogb.ogb912
      LET l_imn.imn33 = l_ogb.ogb913
      CALL s_du_umfchk(l_imn.imn03,'','','',
                       l_imn.imn09,l_imn.imn33,'2')
           RETURNING g_errno,l_imn.imn34
      LET l_imn.imn35 = l_ogb.ogb915
      LET l_imn.imn40 = l_ogb.ogb910
      CALL s_du_umfchk(l_imn.imn03,'','','',
                       l_imn.imn20,l_imn.imn40,'1')
           RETURNING g_errno,l_imn.imn41
      LET l_imn.imn42 = l_ogb.ogb912
      LET l_imn.imn43 = l_ogb.ogb913
      CALL s_du_umfchk(l_imn.imn03,'','','',
                       l_imn.imn20,l_imn.imn43,'1')
           RETURNING g_errno,l_imn.imn44
      LET l_imn.imn45 = l_ogb.ogb915
      CALL s_umfchk(l_imn.imn03,l_imn.imn30,l_imn.imn40)
            RETURNING l_flag,l_imn.imn51
      IF l_flag = 1 THEN
         LET l_imn.imn51 = 1
      END IF
      CALL s_umfchk(l_imn.imn03,l_imn.imn33,l_imn.imn43)
            RETURNING l_flag,l_imn.imn52
      IF l_flag = 1 THEN
         LET l_imn.imn52 = 1
      END IF
      #-----END MOD-AC0023-----
 
      LET l_imn.imnplant = g_plant 
      LET l_imn.imnlegal = g_legal 
 
      INSERT INTO imn_file VALUES (l_imn.*)
      IF STATUS THEN
         LET g_success = "N"
      #FUN-B70074-add-str--
      ELSE
         IF NOT s_industry('std') THEN
            INITIALIZE l_imni.* TO NULL
            LET l_imni.imni01 = l_imn.imn01
            LET l_imni.imni02 = l_imn.imn02
            IF NOT s_ins_imni(l_imni.*,l_imn.imnplant) THEN
               LET g_success = 'N'
            END IF
         END IF
      #FUN-B70074-add-end--
      END IF

      #-----MOD-AC0060---------
      LET g_ima918 = ''  
      LET g_ima921 = ''  
      SELECT ima918,ima921 INTO g_ima918,g_ima921 
        FROM ima_file
       WHERE ima01 = l_imn.imn03
         AND imaacti = "Y"
      
      IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
         DECLARE t600_rvbs_3 CURSOR FOR SELECT * FROM rvbs_file
                                        WHERE rvbs01 = l_oga.oga01
                                          AND rvbs02 = l_ogb.ogb03
         FOREACH t600_rvbs_3 INTO l_rvbs.*
            IF STATUS THEN
               CALL cl_err('rvbs',STATUS,1)
            END IF
      
            LET l_rvbs.rvbs00 = 'aimt324' 
            LET l_rvbs.rvbs01 = l_imn.imn01
            LET l_rvbs.rvbs02 = l_imn.imn02
      
            INSERT INTO rvbs_file VALUES(l_rvbs.*)
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL cl_err3("ins","rvbs_file","","",SQLCA.sqlcode,"","ins rvbs",1)  
               LET g_success = 'N'
            END IF
         END FOREACH
         #MOD-B50204 add --start--
         DELETE FROM rvbs_file WHERE rvbs00 = 'aimt324'
                                 AND rvbs01 = l_imn.imn01
                                 AND rvbs02 = l_imn.imn02
                                 AND rvbs13 = 0
                                 AND rvbs09 = 1
         DECLARE t600_rvbs_33 CURSOR FOR SELECT * FROM rvbs_file
                                         WHERE rvbs00 = 'aimt324'
                                           AND rvbs01 = l_imn.imn01
                                           AND rvbs02 = l_imn.imn02
                                           AND rvbs13 = 0
                                           AND rvbs09 = -1
         FOREACH t600_rvbs_33 INTO l_rvbs.*
            IF STATUS THEN       
               CALL cl_err('rvbs',STATUS,1)
            END IF

            LET l_rvbs.rvbs09 = 1

            INSERT INTO rvbs_file VALUES(l_rvbs.*)
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL cl_err3("ins","rvbs_file","","",SQLCA.sqlcode,"","ins rvbs",1)
               LET g_success = 'N'
            END IF
         END FOREACH
         #MOD-B50204 add --end--
      END IF
      #-----END MOD-AC0060-----
 
      #將借貨單刻號/BIN資料拋轉至調撥單
      IF s_industry('icd') THEN
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM idb_file
                        WHERE idb07 = l_ogb.ogb01
                          AND idb08 = l_ogb.ogb03
         IF l_cnt > 0 THEN
            UPDATE idb_file SET idb07 = l_imn.imn01,
                                idb08 = l_imn.imn02
                          WHERE idb07 = l_ogb.ogb01
                            AND idb08 = l_ogb.ogb03
            IF SQLCA.sqlerrd[3] = 0 THEN
               LET g_success='N'
               EXIT FOREACH
            END IF
            SELECT * INTO l_idb.* FROM idb_file
                          WHERE idb07 = l_imn.imn01
                            AND idb08 = l_imn.imn02
            IF SQLCA.sqlcode THEN
               LET g_success='N'
               EXIT FOREACH
            END IF
            #調撥入需產生ida資料
            IF NOT s_icdout_insicin(l_idb.*,l_imn.imn15,l_imn.imn16,l_imn.imn17) THEN
               LET g_success='N'
               EXIT FOREACH
            END IF
         END IF
      END IF
 
   END FOREACH
   IF g_success = 'Y' THEN
      COMMIT WORK
      IF s_industry('icd') THEN 
        #LET l_msg="aimt324_icd '",l_imm.imm01,"' 'A'"        #FUN-A60034 mark
         LET l_msg="aimt324_icd '",l_imm.imm01,"' ' ' 'A'"    #FUN-A60034 add
      ELSE
        #LET l_msg="aimt324 '",l_imm.imm01,"' 'A'"            #FUN-A60034 mark
         LET l_msg="aimt324 '",l_imm.imm01,"' ' ' 'A'"        #FUN-A60034 add
      END IF  #FUN-920207
      CALL cl_cmdrun_wait(l_msg)
      RETURN l_imm.imm01
   ELSE
      ROLLBACK WORK
      RETURN ""
   END IF
 
 
END FUNCTION
 
FUNCTION t600sub_chk_ogb15_fac(l_oga,l_ogb)
DEFINE l_ogb15_fac   LIKE ogb_file.ogb15_fac
DEFINE l_ogb15       LIKE ogb_file.ogb15
DEFINE l_ogb         RECORD LIKE ogb_file.*
DEFINE l_oga         RECORD LIKE oga_file.*
DEFINE l_cnt         LIKE type_file.num5
DEFINE l_msg         STRING                 #MOD-C50020
#FUN-AB0011 -----------------STA
# 聯營或非企業料號不判斷
  IF s_joint_venture( l_ogb.ogb04,g_plant) OR NOT s_internal_item( l_ogb.ogb04,g_plant ) THEN  
     RETURN
  END IF
#FUN-AB0011 -----------------END
   
  SELECT img09 INTO l_ogb15 FROM img_file
        WHERE img01 = l_ogb.ogb04 AND img02 = l_ogb.ogb09
          AND img03 = l_ogb.ogb091 AND img04 = l_ogb.ogb092
 
  CALL s_umfchk(l_ogb.ogb04,l_ogb.ogb05,l_ogb15)
            RETURNING l_cnt,l_ogb15_fac
  IF l_cnt = 1 THEN
     CALL cl_err('','mfg3075',1)
    #MOD-C50020---S---
     CALL cl_getmsg('asf-176',g_lang) RETURNING l_msg
     LET l_msg = l_msg CLIPPED,":",l_ogb.ogb04
     CALL cl_err(l_msg,'mfg3075',1)   #MOD-C50020 add l_msg
    #MOD-C50020---E---
     LET g_success='N'
     RETURN
  END IF
  IF l_ogb15 != l_ogb.ogb15 OR
     l_ogb15_fac != l_ogb.ogb15_fac THEN
     LET l_ogb.ogb15_fac = l_ogb15_fac
     LET l_ogb.ogb15 = l_ogb15
     LET l_ogb.ogb16 = l_ogb.ogb12 * l_ogb15_fac
 
     UPDATE ogb_file SET ogb15_fac=l_ogb.ogb15_fac,
                         ogb16 =l_ogb.ogb16,
                         ogb15 =l_ogb.ogb15
      WHERE ogb01=l_oga.oga01   #MOD-7B0208
        AND ogb03=l_ogb.ogb03   #MOD-7B0208
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
        CALL cl_err3("upd","ogb15_fac",l_oga.oga01,l_ogb.ogb03,SQLCA.sqlcode,"","",1)
        LET g_success='N'
        RETURN
     END IF
  END IF
  RETURN
END FUNCTION
 
FUNCTION t600sub_ind_icd_to_delivery(l_oga01)
DEFINE l_oga01   LIKE oga_file.oga01
DEFINE l_n       LIKE type_file.num5
DEFINE l_ogaconf LIKE oga_file.ogaconf
DEFINE g_msg     LIKE type_file.chr1000
   IF s_shut(0) THEN RETURN END IF
   IF l_oga01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT ogaconf INTO l_ogaconf FROM oga_file WHERE oga01 = l_oga01
     #AND oga09 = '1'         #FUN-D30084 mark
      AND oga09 IN ('1','5')  #FUN-D30084
   IF l_ogaconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
   IF l_ogaconf = 'N' THEN CALL cl_err('','axm-020',0) RETURN END IF
 
      SELECT COUNT(*) INTO l_n FROM oga_file
       WHERE oga011 = l_oga01
         AND oga09 MATCHES '[246]'   #No.7992
         AND ogaconf != 'X'
      #此出貨通知單已經出貨! 不可再做任何處理!
      IF l_n > 0 THEN
          CALL cl_err('oga011!='':','axm-228',1)
          RETURN
      END IF
      LET g_msg ="aicp033 '",l_oga01,"'"
      CALL cl_cmdrun(g_msg)
END FUNCTION
 
FUNCTION t600sub_ind_icd_upd_ogb09(p_oga01)
   DEFINE  l_oga        RECORD LIKE oga_file.*
   DEFINE  l_ogb        RECORD LIKE ogb_file.*
   DEFINE  p_oga01      LIKE oga_file.oga01
   DEFINE  l_ima35      LIKE ima_file.ima35
   #DEFINE  l_imaicd04   LIKE imaicd_file.imaicd04   #FUN-BA0051 mark
   #DEFINE  l_imaicd08   LIKE imaicd_file.imaicd08   #FUN-BA0051 mark
   DEFINE  l_idd        RECORD LIKE idd_file.*
 
    SELECT * INTO l_oga.* FROM oga_file WHERE oga01=p_oga01
    IF cl_null(l_oga.oga01) THEN
       CALL cl_err('',-400,0)
       RETURN ""
    END IF
 
   DECLARE t600_upd_ogb09_cs CURSOR FOR
      SELECT * FROM ogb_file
       WHERE ogb01 = l_oga.oga01
         AND ogbiicd01 = 'Y'
 
   FOREACH t600_upd_ogb09_cs INTO l_ogb.*
      IF STATUS THEN
         CALL cl_err('t600_upd_ogb09_cs:',STATUS,0)
         LET g_success = 'N'
         RETURN
      END IF
 
      LET l_ima35 = NULL
      SELECT ima35 INTO l_ima35
        FROM ima_file
       WHERE ima01 = l_ogb.ogb04
 
      #-->變更倉庫為料號之主倉庫(ima35)
      UPDATE ogb_file SET ogb09 = l_ima35,
                          ogbiicd010 = 'N'
       WHERE ogb01 = l_ogb.ogb01
         AND ogb03 = l_ogb.ogb03
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err('upd ogb09:',SQLCA.SQLCODE,0)
         LET g_success = 'N'
         RETURN
      END IF

      #FUN-BA0051 --START mark--
      #LET l_imaicd04 = NULL  LET l_imaicd08 = NULL
      #SELECT imaicd04,imaicd08
      #  INTO l_imaicd04,l_imaicd08
      #  FROM imaicd_file
      # WHERE imaicd00 = l_ogb.ogb04
      #
      #IF l_imaicd04 MATCHES '[0124]' AND l_imaicd08 = 'Y' THEN
      #FUN-BA0051 --END mark--
      IF s_icdbin(l_ogb.ogb04) THEN   #FUN-BA0051
         #-->更新出貨通知單據的idd_file的倉庫 =  ima35
         UPDATE idd_file SET idd02 = l_ima35
          WHERE idd10 = l_ogb.ogb01
            AND idd11 = l_ogb.ogb03
            AND idd01 = l_ogb.ogb04
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err('upd idd02:',SQLCA.SQLCODE,0)
            LET g_success = 'N'
            RETURN
         END IF
 
         #-->增加新的倉儲批刻號庫存明細的備置量
         INITIALIZE l_idd.* TO NULL
         DECLARE t600_sel_idd_new CURSOR FOR
             SELECT * FROM idd_file
                WHERE idd10 = l_ogb.ogb01
                  AND idd11 = l_ogb.ogb03
         FOREACH t600_sel_idd_new INTO l_idd.*
             #更新idc210(已備置量)(扣除出貨數量)
             UPDATE idc_file
                SET idc21 = idc21 + l_idd.idd13
              WHERE idc01 = l_idd.idd01  #料號
                AND idc02 = l_idd.idd02  #倉庫
                AND idc03 = l_idd.idd03  #儲位
                AND idc04 = l_idd.idd04  #批號
                AND idc05 = l_idd.idd05  #刻號
                AND idc06 = l_idd.idd06  #BIN
             IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
                CALL cl_err('upd idc21',SQLCA.SQLCODE,1) #MOD-990092
                LET g_success = 'N'
                RETURN
             END IF
         END FOREACH
      END IF
   END FOREACH
 
END FUNCTION
FUNCTION t600sub_ind_icd_post(p_oga01,p_cmd)
   DEFINE p_oga01     LIKE oga_file.oga01
   DEFINE p_cmd       LIKE type_file.chr1
   #DEFINE l_imaicd04  LIKE imaicd_file.imaicd04   #FUN-BA0051 mark
   #DEFINE l_imaicd08  LIKE imaicd_file.imaicd08   #FUN-BA0051 mark
   DEFINE l_oga       RECORD LIKE oga_file.*
   DEFINE l_ogb       RECORD LIKE ogb_file.*
   DEFINE l_ogc       RECORD LIKE ogc_file.*   #FUN-B40081
   DEFINE l_flag      LIKE type_file.num5
   DEFINE l_err       STRING
   DEFINE l_argv0     LIKE ogb_file.ogb09
   DEFINE l_ogbi RECORD LIKE ogbi_file.*   #TQC-B80005
   DEFINE l_sql       STRING   #FUN-B40081
 
    SELECT * INTO l_oga.* FROM oga_file WHERE oga01=p_oga01
    IF cl_null(l_oga.oga01) THEN
       CALL cl_err('',-400,0)
       RETURN ""
    END IF
    #TQC-C30062---begin
    IF l_oga.oga09 = '1' THEN
       RETURN
    END IF
    #TQC-C30062---end
    
   LET l_argv0=l_oga.oga09
   DECLARE t600_icdpost_cs CURSOR FOR
     SELECT * FROM ogb_file WHERE ogb01 = l_oga.oga01

   #FUN-B40081 --START--
   LET l_sql= " SELECT * FROM ogc_file WHERE ogc01='",l_oga.oga01,"' AND ogc03=?" 
   PREPARE t600_icdpost_pre1 FROM l_sql
   DECLARE t600_icdpost_cs1 CURSOR FOR t600_icdpost_pre1 
   #FUN-B40081 --END--     
 
   FOREACH t600_icdpost_cs INTO l_ogb.*
     IF STATUS THEN
        CALL cl_err('t600_icdpost_cs:',STATUS,0)
        LET g_success = 'N'
        EXIT FOREACH
     END IF

     #FUN-BA0051 --START mark--
     #LET l_imaicd04 = NULL  LET l_imaicd08 = NULL
     #SELECT imaicd04,imaicd08
     #  INTO l_imaicd04,l_imaicd08
     #  FROM imaicd_file
     # WHERE imaicd00 = l_ogb.ogb04
     #FUN-BA0051 --END mark-- 
     #TQC-B80005 --START--
     SELECT * INTO l_ogbi.* FROM ogbi_file
      WHERE ogbi01 = l_ogb.ogb01 AND ogbi03 = l_ogb.ogb03  
     #TQC-B80005 --END--
     #FUN-B40081 --START--
     IF l_ogb.ogb17='Y' THEN   #多倉儲出貨應以多倉儲裡的資料過帳
        FOREACH t600_icdpost_cs1 USING l_ogb.ogb03 INTO l_ogc.*
           IF STATUS THEN
              CALL cl_err('t600_icdpost_cs1:',STATUS,0)
              LET g_success = 'N'
              EXIT FOREACH
           END IF
           
           LET l_ogb.ogb09 =l_ogc.ogc09   #出貨倉庫編號
           LET l_ogb.ogb091=l_ogc.ogc091  #出貨儲位編號
           LET l_ogb.ogb092=l_ogc.ogc092  #出貨批號
           LET l_ogb.ogb12 =l_ogc.ogc12   #數量

           IF p_cmd = '1' THEN  # 過帳
              IF l_argv0 = '1' THEN
                 CALL s_icdpost(2,l_ogc.ogc17,l_ogc.ogc09,l_ogc.ogc091,
                                 l_ogc.ogc092,l_ogc.ogc15,l_ogc.ogc12,
                                 l_oga.oga01,l_ogc.ogc03,l_oga.oga02,'Y','',''
                                 ,l_ogbi.ogbiicd029,l_ogbi.ogbiicd028,g_plant)
                      RETURNING l_flag
                 IF l_flag = 0 THEN
                    LET g_success = 'N'                   
                    RETURN
                 END IF
              ELSE
                 CALL s_icdpost(-1,l_ogc.ogc17,l_ogc.ogc09,l_ogc.ogc091,
                                 l_ogc.ogc092,l_ogc.ogc15,l_ogc.ogc12,
                                 l_oga.oga01,l_ogc.ogc03,l_oga.oga02,'Y','','' 
                                 ,l_ogbi.ogbiicd029,l_ogbi.ogbiicd028,g_plant)
                      RETURNING l_flag
              END IF
              IF l_flag = 0 THEN
                 LET g_success = 'N'                
                 RETURN
              END IF
           ELSE                 # 過帳還原
              IF l_argv0 = '1' THEN
                 CALL s_icdpost(2,l_ogc.ogc17,l_ogc.ogc09,
                                 l_ogc.ogc091,l_ogc.ogc092,
                                 l_ogc.ogc15,l_ogc.ogc12,
                                 l_oga.oga01,l_ogc.ogc03,
                                 l_oga.oga02,'N','',''
                                 ,l_ogbi.ogbiicd029,l_ogbi.ogbiicd028,g_plant)
                      RETURNING l_flag
              ELSE
                 CALL s_icdpost(-1,l_ogc.ogc17,l_ogc.ogc09,
                                 l_ogc.ogc091,l_ogc.ogc092,
                                 l_ogc.ogc15,l_ogc.ogc12,
                                 l_oga.oga01,l_ogc.ogc03,
                                 l_oga.oga02,'N','',''
                                 ,l_ogbi.ogbiicd029,l_ogbi.ogbiicd028,g_plant)
                      RETURNING l_flag
              END IF
              IF l_flag = 0 THEN
                 LET g_success = 'N'
                 EXIT FOREACH
              END IF
           END IF
        END FOREACH
     ELSE     
     #FUN-B40081 --END-- 
        IF p_cmd = '1' THEN  # 過帳
           IF l_argv0 = '1' THEN
              CALL s_icdpost(2,l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,
                              l_ogb.ogb092,l_ogb.ogb05,l_ogb.ogb12,
                              l_oga.oga01,l_ogb.ogb03,l_oga.oga02,'Y','',''
                              ,l_ogbi.ogbiicd029,l_ogbi.ogbiicd028,'') #FUN-B30187 #TQC-B80005  #FUN-B80119   傳入p_plant參數''   -
                   RETURNING l_flag
              IF l_flag = 0 THEN
                 LET g_success = 'N'
	          #LET l_err = l_oga.oga01 ,"-", l_ogb.ogb03    #FUN-B40066 mark
	          #CALL cl_err(l_err,'DSC017',0) #新增錯誤項次訊息 #FUN-B40066 mark
                 RETURN
              END IF
           ELSE
              CALL s_icdpost(-1,l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,
                              l_ogb.ogb092,l_ogb.ogb05,l_ogb.ogb12,
                              l_oga.oga01,l_ogb.ogb03,l_oga.oga02,'Y','',''
                              ,l_ogbi.ogbiicd029,l_ogbi.ogbiicd028,'') #FUN-B30187 #TQC-B80005  #FUN-B80119   傳入p_plant參數''   -
                   RETURNING l_flag
           END IF
           IF l_flag = 0 THEN
              LET g_success = 'N'
	       #LET l_err = l_oga.oga01 ,"-", l_ogb.ogb03    #FUN-B40066 mark
	       #CALL cl_err(l_err,'DSC017',0)# 新增錯誤項次訊息 #FUN-B40066 mark
              RETURN
           END IF
        ELSE                 # 過帳還原
           IF l_argv0 = '1' THEN
              CALL s_icdpost(2,l_ogb.ogb04,l_ogb.ogb09,
                              l_ogb.ogb091,l_ogb.ogb092,
                              l_ogb.ogb05,l_ogb.ogb12,
                              l_oga.oga01,l_ogb.ogb03,
                              l_oga.oga02,'N','',''
                              ,l_ogbi.ogbiicd029,l_ogbi.ogbiicd028,'') #FUN-B30187 #TQC-B80005  #FUN-B80119   傳入p_plant參數''   -
                   RETURNING l_flag
           ELSE
              CALL s_icdpost(-1,l_ogb.ogb04,l_ogb.ogb09,
                              l_ogb.ogb091,l_ogb.ogb092,
                              l_ogb.ogb05,l_ogb.ogb12,
                              l_oga.oga01,l_ogb.ogb03,
                              l_oga.oga02,'N','',''
                              ,l_ogbi.ogbiicd029,l_ogbi.ogbiicd028,'') #FUN-B30187 #TQC-B80005  #FUN-B80119   傳入p_plant參數''   -
                   RETURNING l_flag
           END IF
           IF l_flag = 0 THEN
              LET g_success = 'N'
              EXIT FOREACH
           END IF
        END IF
      END IF   #FUN-B40081        
   END FOREACH
 
END FUNCTION

#FUN-BC0064---------add--------str-------
FUNCTION t600sub_add_deduct(p_oga01)
DEFINE p_oga01        LIKE oga_file.oga01
DEFINE g_sql          STRING
DEFINE l_n            LIKE type_file.num5
DEFINE l_cnt          LIKE type_file.num5
DEFINE l_ima154       LIKE ima_file.ima154
DEFINE l_rxy_file     RECORD LIKE rxy_file.*
DEFINE l_lqe_file     RECORD LIKE lqe_file.*
DEFINE l_lqb          RECORD LIKE lqb_file.*
DEFINE l_ogb          RECORD LIKE ogb_file.*
DEFINE l_rxe04        LIKE rxe_file.rxe04
DEFINE l_rxe05        LIKE rxe_file.rxe05
DEFINE l_lqe01        LIKE lqe_file.lqe01
DEFINE l_rxe04_1      LIKE rxe_file.rxe04
DEFINE l_rxe05_1      LIKE rxe_file.rxe05
DEFINE max_lsm05      LIKE lsm_file.lsm05     #FUN-BA0069 add
DEFINE l_rxx04_point  LIKE rxx_file.rxx04     #FUN-BA0069 add
DEFINE l_oga          RECORD LIKE oga_file.*  #FUN-BA0069 add
DEFINE l_rxe02_1      LIKE rxe_file.rxe02     #TQC-C30129 add
DEFINE l_ogb31        LIKE ogb_file.ogb31     #TQC-C30129 add

   SELECT * INTO l_oga.* FROM oga_file where oga01 = p_oga01
   #檢查券起訖編號範圍內是否有包含非5.發放或2.退回狀態的券
   CALL s_showmsg_init()   
   LET g_sql = " SELECT rxe02,rxe04,rxe05 FROM rxe_file ",
               "  WHERE rxe01 = '",p_oga01,"' ",
               "    AND rxe00 = '02' "
   DECLARE t620_sel_rxe_cr1 CURSOR FROM g_sql
   FOREACH t620_sel_rxe_cr1 INTO l_rxe02_1,l_rxe04_1,l_rxe05_1       #TQC-C30129 add rxe02
#TQC-C30129 -----------------STA
      SELECT ogb31 INTO l_ogb31 FROM ogb_file WHERE ogb01 = p_oga01 AND ogb03 = l_rxe02_1
      IF NOT cl_null(l_ogb31) THEN
         CONTINUE FOREACH
      END IF
#TQC-C30129 -----------------END
      LET g_sql = "SELECT lqe01 FROM lqe_file ",
                  " WHERE lqe01 BETWEEN '",l_rxe04_1,"' AND '",l_rxe05_1,"'",
                  "   AND (lqe17 <> '5' OR lqe13 <> '",l_oga.ogaplant,"')",
                  "   AND (lqe17 <> '2' OR lqe09 <> '",l_oga.ogaplant,"')"
      PREPARE sel_lqe_pre1 FROM g_sql
      DECLARE sel_lqe_cs1 CURSOR FOR sel_lqe_pre1
      FOREACH sel_lqe_cs1 INTO l_lqe01
         CALL s_errmsg('',l_lqe01,'','axm-685',1)
         LET g_success = 'N'
      END FOREACH
   END FOREACH
   CALL s_showmsg()
   IF g_success = 'N' THEN
      RETURN
   END IF
   #庫存過賬的操作
   SELECT COUNT(*) INTO l_cnt
     FROM rxy_file
    WHERE rxy00 = '02'
      AND rxy01 = p_oga01
      AND rxy03 = '04'
   IF l_cnt > 0 THEN
      LET g_sql = " SELECT * FROM rxy_file ",
                  "  WHERE rxy00 = '02'",
                  "    AND rxy01 = '",p_oga01,"' ",
                  "    AND rxy03 = '04' "
      DECLARE t600sub_sel_rxy_cr CURSOR FROM g_sql
      FOREACH t600sub_sel_rxy_cr INTO l_rxy_file.*
         UPDATE lqe_file
            SET lqe17 = '4',
                #lqe18 = l_rxy_file.rxyplant,  #FUN-D10040 mark
                #lqe19 = l_rxy_file.rxy21      #FUN-D10040 mark
                lqe24 = l_rxy_file.rxyplant,   #FUN-D10040 add
                lqe25 = l_rxy_file.rxy21       #FUN-D10040 add
          WHERE lqe01 >= l_rxy_file.rxy14
            AND lqe01 <= l_rxy_file.rxy15
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","lqe_file",p_oga01,"",SQLCA.sqlcode,"","",1)
            LET g_success = 'N' 
            RETURN
         END IF
         LET g_sql = " SELECT * FROM lqe_file ",
                     "  WHERE lqe01 >= '",l_rxy_file.rxy14,"' ",
                     "    AND lqe01 <= '",l_rxy_file.rxy15,"' "

         DECLARE t600sub_sel_lqe_cr CURSOR FROM g_sql
         FOREACH t600sub_sel_lqe_cr INTO l_lqe_file.*
            CASE l_lqe_file.lqe17
                  WHEN '0' LET l_lqb.lqb06 = l_lqe_file.lqe05
                           LET l_lqb.lqb07 = '1'
                  WHEN '1' LET l_lqb.lqb06 = l_lqe_file.lqe07
                           LET l_lqb.lqb07 = '0'
                  WHEN '2' LET l_lqb.lqb06 = l_lqe_file.lqe10
                           LET l_lqb.lqb07 = '1'
                  WHEN '3' LET l_lqb.lqb06 = l_lqe_file.lqe12
                           LET l_lqb.lqb07 = '1'
                 #WHEN '4' LET l_lqb.lqb06 = l_lqe_file.lqe19   #FUN-D10040 mark
                 #         LET l_lqb.lqb07 = '1'                #FUN-D10040 mark
                  WHEN '4' LET l_lqb.lqb06 = l_lqe_file.lqe25   #FUN-D10040 add
                           LET l_lqb.lqb07 = '0'                #FUN-D10040 add  
             END CASE
             SELECT COUNT(*) INTO l_n
               FROM lqc_file
              WHERE lqc01 = l_lqe_file.lqe01
             IF l_n = 0 THEN
                INSERT INTO lqc_file(lqc01,lqc02,lqc03,lqc04,lqc05,lqc06,lqclegal,lqcplant)
                              VALUES(l_lqe_file.lqe01,l_lqe_file.lqe17,l_lqb.lqb06,l_rxy_file.rxy21,
                                     l_lqb.lqb07,'1',l_rxy_file.rxylegal,l_rxy_file.rxyplant)
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                   CALL cl_err3("ins","lqc_file",l_lqe_file.lqe01,"",SQLCA.sqlcode,"","",1)
                   LET g_success = 'N'
                   RETURN
                END IF
             ELSE
                UPDATE lqc_file
                   SET lqc06 = lqc06 +1
                 WHERE lqc01 = l_lqe_file.lqe01
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                   CALL cl_err3("upd","lqc_file",l_lqe_file.lqe01,"",SQLCA.sqlcode,"","",1)
                   LET g_success = 'N'
                   RETURN
                END IF
             END IF
         END FOREACH
      END FOREACH
   END IF

   LET g_sql = " SELECT * FROM ogb_file ",
               "  WHERE ogb01 = '",p_oga01,"' ",
               "    AND (ogb31 = ' ' OR ogb31 IS NULL) "     #TQC-C30129 add
           
   DECLARE t600sub_sel_ogb_cr CURSOR FROM g_sql
   FOREACH t600sub_sel_ogb_cr INTO l_ogb.*
      LET g_cnt = g_cnt +1
      SELECT ima154 INTO l_ima154
        FROM ima_file
       WHERE ima01 = l_ogb.ogb04
      IF l_ima154 = 'Y' THEN
         LET g_sql = " SELECT rxe04,rxe05 FROM rxe_file ",
                     "  WHERE rxe01 = '",l_ogb.ogb01,"' ",
                     "    AND rxe02 = '",l_ogb.ogb03,"' "
         DECLARE t600sub_sel_rxe04_rxe05_cr CURSOR FROM g_sql
         FOREACH t600sub_sel_rxe04_rxe05_cr INTO l_rxe04,l_rxe05
            UPDATE lqe_file
               SET lqe06 = l_oga.ogaplant,
                   lqe07 = l_oga.oga02,
                   lqe24 = '',         #FUN-D10040 add
                   lqe25 = '',         #FUN-D10040 add
                   lqe17 = '1'
             WHERE lqe01 >= l_rxe04
               AND lqe01 <= l_rxe05
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3("upd","lqe_file",l_lqe_file.lqe01,"",SQLCA.sqlcode,"","",1)
               LET g_success = 'N'
               RETURN
            END IF
         END FOREACH
      END IF
   END FOREACH
   #FUN-BA0069 add begin ---
   SELECT SUM(rxy23) INTO l_rxx04_point
     FROM rxy_file
    WHERE rxy00 = '02'
      AND rxy01 = l_oga.oga01
      AND rxy03 = '09'
      AND rxyplant = l_oga.ogaplant
   IF cl_null(l_rxx04_point) THEN
      LET l_rxx04_point = 0
   END IF
   IF (g_success = 'Y') AND g_azw.azw04 = '2' AND l_oga.oga94 = 'N' AND NOT cl_null(l_oga.oga87) THEN
      IF NOT cl_null(l_rxx04_point) AND l_rxx04_point > 0 THEN
        #INSERT INTO lsm_file(lsm01,lsm02,lsm03,lsm04,lsm05,lsm06,lsm08,lsmlegal,lsmplant,lsm15)   #FUN-C70045 add lsm15  #FUN-C90102 mark
         INSERT INTO lsm_file(lsm01,lsm02,lsm03,lsm04,lsm05,lsm06,lsm08,lsmlegal,lsmstore,lsm15)   #FUN-C90102 add
                       VALUES(l_oga.oga87,'9',l_oga.oga01,l_rxx04_point*(-1),l_oga.oga02,'',0,l_oga.ogalegal,l_oga.ogaplant,'1') #FUN-C70045 add '1' 
      END IF
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","lsm_file",l_oga.oga87,"",SQLCA.sqlcode,"","ins lsm",1)
         LET g_success = 'N'
         RETURN
      END IF
      IF cl_null(l_oga.oga51) THEN
         LET l_oga.oga51 = 0
      END IF
      #MOD-C30216--add---str-- 
      IF cl_null(l_oga.oga95) THEN
         LET l_oga.oga95 = 0
      END IF
      #MOD-C30216--add---end--
     #INSERT INTO lsm_file(lsm01,lsm02,lsm03,lsm04,lsm05,lsm06,lsm08,lsmlegal,lsmplant,lsm15)   #FUN-C70045 add lsm15  #FUN-C90102 mark
      INSERT INTO lsm_file(lsm01,lsm02,lsm03,lsm04,lsm05,lsm06,lsm08,lsmlegal,lsmstore,lsm15)   #FUN-C90102 add   
                  VALUES(l_oga.oga87,'7',l_oga.oga01,l_oga.oga95,l_oga.oga02,'',l_oga.oga51,l_oga.ogalegal,l_oga.ogaplant,'1')   #FUN-C70045 add '1'
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","lsm_file",l_oga.oga01,"",SQLCA.sqlcode,"","ins lsm",1)
         LET g_success = 'N'
         RETURN
      ELSE
         SELECT MAX(lsm05) INTO max_lsm05
           FROM lsm_file
          WHERE lsm01 = l_oga.oga87
#           AND lsm02 IN ('1', '5', '6', '7', '8')     #FUN-C70045 mark
            AND lsm02 IN ('2', '3', '7', '8')          #FUN-C70045 add
         UPDATE lpj_file
            SET lpj07 = COALESCE(lpj07,0) + 1,
                lpj08 = max_lsm05,
                lpj12 = COALESCE(lpj12,0) + l_oga.oga95 - l_rxx04_point,
                lpj13 = COALESCE(lpj13,0) + l_rxx04_point,
                lpj14 = COALESCE(lpj14,0) + l_oga.oga95,
                lpj15 = COALESCE(lpj15,0) + l_oga.oga51,
                lpjpos = '2'             #FUN-D30007 add
          WHERE lpj03 = l_oga.oga87
          IF SQLCA.sqlcode  THEN
             CALL cl_err3("upd","lpj_file",l_oga.oga87,"",SQLCA.sqlcode,"","",1)
             LET g_success = 'N'
             RETURN
          END IF
      END IF
   END IF
   #FUN-BA0069 add end -----
END FUNCTION
#FUN-BC0064---------add--------end-----
FUNCTION t600sub_ind_icd_chk_omb(p_key,p_no,p_seq)
  DEFINE  p_key        LIKE ogb_file.ogb04
  DEFINE  p_no         LIKE ogb_file.ogb31
  DEFINE  p_seq        LIKE ogb_file.ogb32
  DEFINE  l_imaicd05   LIKE imaicd_file.imaicd05
  DEFINE  l_sum        LIKE omb_file.omb35
 
  LET g_errno = ''
 
  LET l_imaicd05 = NULL
  SELECT imaicd05 INTO l_imaicd05
    FROM imaicd_file
   WHERE imaicd00 = p_key
  IF l_imaicd05 = '3' THEN
     LET l_sum = 0
     SELECT SUM(omb35) INTO l_sum
       FROM oma_file,omb_file
      WHERE oma00 = '11'
        AND oma01 = omb01
        AND omb31 = p_no
        AND omb32 = p_seq
     IF SQLCA.SQLCODE OR cl_null(l_sum) THEN
        LET l_sum = 0
     END IF
     IF l_sum != 0 THEN
        LET g_errno = 'aic-313'   #No.FUN-830078
     END IF
  END IF
END FUNCTION
 
FUNCTION t600sub_chk_imgg(l_ima906,l_ogg20,l_ogg17,l_ogg09,l_ogg091,l_ogg092,
l_ogg15,l_ogg15_fac,l_ogg16,l_ogb913,l_ogb915,l_ogb910,l_ogb911,l_ogb912)
   DEFINE l_ima906     LIKE ima_file.ima906,
          l_ogg20      LIKE ogg_file.ogg20,
          l_ogg17      LIKE ogg_file.ogg17,
          l_ogg09      LIKE ogg_file.ogg09,
          l_ogg091     LIKE ogg_file.ogg091,
          l_ogg092     LIKE ogg_file.ogg092,
          l_ogg15      LIKE ogg_file.ogg15,
          l_ogg15_fac  LIKE ogg_file.ogg15_fac,
          l_ogg16      LIKE ogg_file.ogg16,
          l_ogb913     LIKE ogb_file.ogb913,
          l_ogb915     LIKE ogb_file.ogb915,
          l_ogb910     LIKE ogb_file.ogb910,
          l_ogb911     LIKE ogb_file.ogb911,
          l_ogb912     LIKE ogb_file.ogb912,
          l_imgg10_1   LIKE imgg_file.imgg10,
          l_imgg10_2   LIKE imgg_file.imgg10,
          l_msg        STRING 
#FUN-AB0011 ---------------STA 
   IF s_joint_venture( l_ogg17,g_plant) OR NOT s_internal_item( l_ogg17,g_plant ) THEN
      RETURN
   END IF
#FUN-AB0011 ---------------END
   IF g_sma.sma117 = 'N' THEN 
      CASE l_ogg20
         WHEN '2'
            SELECT imgg10 INTO l_imgg10_2 FROM imgg_file
             WHERE imgg01=l_ogg17
               AND imgg02=l_ogg09
               AND imgg03=l_ogg091
               AND imgg04=l_ogg092
               AND imgg09=l_ogg15
            IF cl_null(l_imgg10_2) THEN LET l_imgg10_2=0 END IF
            IF l_ogg16 > l_imgg10_2 THEN
               LET g_flag2 = NULL    #FUN-C80107 add
              #CALL s_inv_shrt_by_warehouse(g_sma.sma894[2,2],l_ogg09) RETURNING g_flag2   #FUN-C80107 add #FUN-D30024
               CALL s_inv_shrt_by_warehouse(l_ogg09,g_plant) RETURNING g_flag2                     #FUN-D30024 add  #TQC-D40078 g_plant
              #IF g_sma.sma894[2,2]='N' THEN   #FUN-C80107 mark
               IF g_flag2 = 'N' OR g_flag2 IS NULL THEN           #FUN-C80107 add
                  LET l_msg=l_ogg17,'-',l_ogg09,'/',l_ogg091,'/',l_ogg092
                  IF g_bgerr THEN
                     CALL s_errmsg('','',l_msg,'mfg1303',1)
                  ELSE
                     CALL cl_err(l_msg,'mfg1303',1)
                  END IF
                  LET g_success = 'N' 
               END IF
            END IF
         WHEN '1'
            IF l_ima906 = '2' THEN
               SELECT imgg10 INTO l_imgg10_1 FROM imgg_file
                WHERE imgg01=l_ogg17
                  AND imgg02=l_ogg09
                  AND imgg03=l_ogg091
                  AND imgg04=l_ogg092
                  AND imgg09=l_ogg15
            END IF
            IF cl_null(l_imgg10_1) THEN LET l_imgg10_1=0 END IF
            IF l_ima906 = '2' THEN 
               IF l_ogg16 > l_imgg10_1 THEN
                  LET g_flag2 = NULL    #FUN-C80107 add
                 #CALL s_inv_shrt_by_warehouse(g_sma.sma894[2,2],l_ogg09) RETURNING g_flag2   #FUN-C80107 add #FUN-D30024
                  CALL s_inv_shrt_by_warehouse(l_ogg09,g_plant) RETURNING g_flag2                     #FUN-D30024 add  #TQC-D40078 g_plant
                 #IF g_sma.sma894[2,2]='N' THEN     #FUN-C80107 mark
                  IF g_flag2 = 'N' OR g_flag2 IS NULL THEN           #FUN-C80107 add
                     LET l_msg=l_ogg17,'-',l_ogg09,'/',l_ogg091,'/',l_ogg092
                     IF g_bgerr THEN
                        CALL s_errmsg('','',l_msg,'mfg1303',1)
                     ELSE
                        CALL cl_err(l_msg,'mfg1303',1)
                     END IF
                     LET g_success = 'N' 
                  END IF
               END IF
            END IF
         OTHERWISE
            SELECT imgg10 INTO l_imgg10_2 FROM imgg_file
             WHERE imgg01=l_ogg17
               AND imgg02=l_ogg09
               AND imgg03=l_ogg091
               AND imgg04=l_ogg092
               AND imgg09=l_ogb913
            IF cl_null(l_imgg10_2) THEN LET l_imgg10_2=0 END IF
            IF l_ima906 = '2' THEN
               SELECT imgg10 INTO l_imgg10_1 FROM imgg_file
                WHERE imgg01=l_ogg17
                  AND imgg02=l_ogg09
                  AND imgg03=l_ogg091
                  AND imgg04=l_ogg092
                  AND imgg09=l_ogb910
            END IF
            IF cl_null(l_imgg10_1) THEN LET l_imgg10_1=0 END IF
            IF l_ogb915 > l_imgg10_2 THEN
               LET g_flag2 = NULL    #FUN-C80107 add
              #CALL s_inv_shrt_by_warehouse(g_sma.sma894[2,2],l_ogg09) RETURNING g_flag2   #FUN-C80107 add #FUN-D30024
               CALL s_inv_shrt_by_warehouse(l_ogg09,g_plant) RETURNING g_flag2                     #FUN-D30024 add   #TQC-D40078 g_plant
              #IF g_sma.sma894[2,2]='N' THEN  #FUN-C80107 mark
               IF g_flag2 = 'N' OR g_flag2 IS NULL THEN           #FUN-C80107 add
                  LET l_msg=l_ogg17,'->',l_ogg09,'/',l_ogg091,'/',l_ogg092
                  IF g_bgerr THEN
                     CALL s_errmsg('','',l_msg,'mfg1303',1)
                  ELSE
                     CALL cl_err(l_msg,'mfg1303',1)
                  END IF
                  LET g_success = 'N' 
               END IF
            END IF
            IF l_ima906 = '2' THEN
               IF l_ogb912 > l_imgg10_1 THEN
                  LET g_flag2 = NULL    #FUN-C80107 add
                 #CALL s_inv_shrt_by_warehouse(g_sma.sma894[2,2],l_ogg09) RETURNING g_flag2   #FUN-C80107 add #FUN-D30024
                  CALL s_inv_shrt_by_warehouse(l_ogg09,g_plant) RETURNING g_flag2                     #FUN-D30024 add  #TQC-D40078 g_plant
                 #IF g_sma.sma894[2,2]='N' THEN  #FUN-C80107 mark
                  IF g_flag2 = 'N' OR g_flag2 IS NULL THEN           #FUN-C80107 add
                     LET l_msg=l_ogg17,'->',l_ogg09,'/',l_ogg091,'/',l_ogg092
                     IF g_bgerr THEN
                        CALL s_errmsg('','',l_msg,'mfg1303',1)
                     ELSE
                        CALL cl_err(l_msg,'mfg1303',1)
                     END IF
                     LET g_success = 'N'
                  END IF
               END IF
            END IF
      END CASE
   END IF
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/18

#FUN-BC0071---------------STA
#FUNCTION t600_upd_lqe(l_oga)
#DEFINE l_oga   RECORD LIKE oga_file.*
#DEFINE l_n     LIKE type_file.num5

# SELECT COUNT(*) INTO l_n FROM ogb_file,lpx_file,lqe_file,lqw_file
#  WHERE lpx32 = ogb04 AND lpx01 = lqe02
#    AND ogb01 = l_oga.oga01
#    AND lqw08 = lqe02 AND lqw00 = '02'
#    AND lqw01= l_oga.oga01
#    AND lqe01 BETWEEN lqw09 AND lqw10
#    AND lqe17 IN ('5','2') 
#    AND lqe13 = l_oga.ogaplant
# IF l_n > 0 THEN

#    UPDATE lqe_file SET  lqe17 = '1',
#                         lqe06 = l_oga.ogaplant,
#                         lqe07 = g_today 
#     WHERE lqe01 IN (SELECT lqe01 FROM ogb_file,lpx_file,lqe_file,lqw_file
#                      WHERE lpx32 = ogb04 AND lpx01 = lqe02
#                        AND ogb01 = l_oga.oga01
#                        AND lqw08 = lqe02 AND lqw00 = '02'
#                        AND lqw01= l_oga.oga01
#                        AND lqe01 BETWEEN lqw09 AND lqw10
#                        AND lqe17 IN ('5','2') 
#                        AND lqe13 = l_oga.ogaplant)
#    IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
#       CALL cl_err3("upd","lqe_file",'',"",SQLCA.sqlcode,"","",1)  
#       LET g_success = 'N'
#       RETURN
#    END IF
#  END IF          

#END FUNCTION 

FUNCTION t600_ins_lsn(l_oga)
DEFINE l_oga    RECORD LIKE oga_file.*
DEFINE l_n      LIKE type_file.num5
DEFINE l_ogb14t LIKE ogb_file.ogb14t
DEFINE l_money  LIKE type_file.num20_6
DEFINE l_lsn07  LIKE lsn_file.lsn07

   SELECT COUNT(*) INTO l_n FROM ogb_file
    WHERE ogb01 = l_oga.oga01 AND ogb04= 'MISCCARD'
      AND ogb1001 = g_oaz.oaz88
      AND (ogb31 = ' ' OR ogb31 IS NULL)      #TQC-C30097 add
   IF l_n >0 THEN
     SELECT SUM(ogb14t) INTO l_ogb14t FROM ogb_file 
      WHERE ogb01 = l_oga.oga01 AND ogb04= 'MISCCARD'
        AND (ogb31 = ' ' OR ogb31 IS NULL)      #TQC-C30097 add
     SELECT SUM(ogb47+ogb14t) INTO l_money FROM ogb_file 
      WHERE ogb01 = l_oga.oga01 AND ogb04= 'MISCCARD'
        AND (ogb31 = ' ' OR ogb31 IS NULL)      #TQC-C30097 add
     UPDATE lpj_file SET lpj06 = lpj06 + l_money,
                         lpjpos = '2'             #FUN-D30007 add
      WHERE lpj03 = l_oga.oga87
     IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
        CALL cl_err3("upd","lpj_file",'',"",SQLCA.sqlcode,"","",1)  
        LET g_success = 'N'
        RETURN
     END IF

     IF g_success = 'Y' THEN
        LET l_lsn07 = l_ogb14t/(l_money*100)
       #INSERT INTO lsn_file (lsn01,lsn02,lsn03,lsn04,lsn05,lsn07,lsnplant,lsnlegal,lsn10)                   #FUN-C70045 add lsn10  #FUN-C90102 mark 
        INSERT INTO lsn_file (lsn01,lsn02,lsn03,lsn04,lsn05,lsn07,lsnstore,lsnlegal,lsn10)                   #FUN-C90102 add
         VALUES (l_oga.oga87,'F',l_oga.oga01,l_money,g_today,l_lsn07,l_oga.ogaplant,l_oga.ogalegal,'1')      #FUN-C70045 add '1'
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","lsn_file",'',"",SQLCA.sqlcode,"","",1)  
           LET g_success = 'N'
           RETURN
        END IF
     END IF
   END IF 

END FUNCTION   
#FUN-BC0071 --------------END

#FUN-C50097 ADD BEGIN----------------
#大陆版多次签收copy自t600_gen_return_note 
FUNCTION t600_gen_return_note2(l_oga)   #MOD-790150 modify l_oga
DEFINE l_oga     RECORD LIKE oga_file.*,
       l_ogb     RECORD LIKE ogb_file.*,
       l_ogbi    RECORD LIKE ogbi_file.*,#No.FUN-7C0017
       l_ogb12   LIKE ogb_file.ogb12,
       l_ogb915  LIKE ogb_file.ogb12,
       l_ogb912  LIKE ogb_file.ogb12,
       l_ogb917  LIKE ogb_file.ogb12,
       li_result LIKE type_file.num5,    #No.FUN-680137 SMALLINT
       l_cnt     LIKE type_file.num5,    #No.FUN-680137 SMALLINT
       tm        RECORD
                 oga01 LIKE oay_file.oayslip,  #No.FUN-680137 VARCHAR(5)
                 cware LIKE img_file.img02,
                 cloc  LIKE img_file.img03
                 END RECORD
DEFINE p_row,p_col LIKE type_file.num5
DEFINE l_t1      LIKE type_file.chr5
DEFINE p_oga01   LIKE oga_file.oga01    #MOD-790150
DEFINE l_rvbs     RECORD LIKE rvbs_file.*   #CHI-970040
DEFINE l_rvbs06a  LIKE rvbs_file.rvbs06     #CHI-970040
DEFINE l_rvbs06b  LIKE rvbs_file.rvbs06     #CHI-970040
DEFINE i          LIKE type_file.num5   #MOD-A10163
DEFINE l_msg      STRING                 #CHI-AC0034 add 
DEFINE l_tot1     LIKE ogc_file.ogc12    #CHI-AC0034 add
DEFINE l_flag     LIKE type_file.chr1    #CHI-AC0034 add
DEFINE l_ogc      RECORD LIKE ogc_file.* #CHI-AC0034 add
DEFINE l_ogc12    LIKE ogc_file.ogc12    #CHI-AC0034 add
DEFINE l_img09    LIKE img_file.img09    #CHI-AC0034 add
DEFINE l_idb      RECORD LIKE idb_file.*  #FUN-B40066
DEFINE l_factor   LIKE type_file.num26_10  #FUN-C50097
DEFINE l_ogb50    LIKE ogb_file.ogb50,     #FUN-C50097
       l_ogb51    LIKE ogb_file.ogb51,      #FUN-C50097
       l_ima906   LIKE ima_file.ima906,
       g_prog_t   LIKE type_file.chr20,
       l_r        LIKE type_file.chr1,
       l_qty      LIKE ogb_file.ogb12,
       l_ogb09    LIKE ogb_file.ogb09, #120712
       l_ogb091   LIKE ogb_file.ogb091, #120712 
       l_ogg      RECORD LIKE ogg_file.*  #120725     
   #檢查是否有驗退數量
   SELECT COUNT(*) INTO l_cnt
     FROM ogb_file b1,oga_file a1
    WHERE b1.ogb01 = l_oga.oga01
      AND a1.oga01 = b1.ogb01
      AND b1.ogb12 < (SELECT SUM(b2.ogb12) FROM oga_file a2,ogb_file b2
                       WHERE a2.oga01 = b2.ogb01
                        #AND a2.oga09 = '2'
                         AND (a2.oga09 = '2' OR a2.oga09 = '3') #FUN-BB0167
                         AND a2.oga65 = 'Y'
                         AND a1.oga011 = a2.oga01
                         AND b1.ogb03 = b2.ogb03)
 
   IF l_cnt = 0 THEN RETURN END IF
 
   LET tm.oga01= NULL
   LET tm.cware=g_oaz.oaz76
   LET tm.cloc =g_oaz.oaz77
 
   LET p_row = 2 LET p_col = 39
 
   OPEN WINDOW t6281_w AT p_row,p_col WITH FORM "axm/42f/axmt6281"   #CHI-690060
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("axmt6281")   #CHI-690060
 
   INPUT BY NAME tm.oga01,tm.cware,tm.cloc WITHOUT DEFAULTS
 
      AFTER FIELD oga01
         IF NOT cl_null(tm.oga01) THEN
            CALL s_check_no("axm",tm.oga01,"","59","oga_file","oga01","")
                 RETURNING li_result,tm.oga01
            IF (NOT li_result) THEN
               NEXT FIELD oga01
            END IF
         END IF
 
      AFTER FIELD cware
         IF NOT cl_null(tm.cware) THEN
            SELECT * FROM imd_file
             WHERE imd01 = tm.cware
               AND imdacti = 'Y'
            IF STATUS <> 0 THEN
               CALL cl_err3("sel","imd_file",tm.cware,"","ams-004","","",1)  #No.FUN-670008
               NEXT FIELD cware
            END IF
 
            SELECT COUNT(*) INTO l_cnt FROM ogb_file
             WHERE ogb01 = l_oga.oga01
               AND ogb09 = tm.cware
            IF l_cnt > 0 THEN
               CALL cl_err('','axm-424',0)
               LET tm.cware=' '
               NEXT FIELD cware #No:8570
            END IF
            IF g_azw.azw04='2' THEN                                                                                                 
               LET l_cnt=0                                                                                                          
               SELECT COUNT(*) INTO l_cnt  FROM jce_file                                                                     
                WHERE jce02=tm.cware                                                                                                
               IF l_cnt !=0 THEN                                                                                             
                  CALL cl_err(tm.cware,'art-452',0)                                                                                 
                  NEXT FIELD cware                                                                                                  
               END IF                                                                                                                
            END IF
            #No.FUN-AA0048  --Begin
            IF NOT s_chk_ware(tm.cware) THEN
               NEXT FIELD cware
            END IF
            #No.FUN-AA0048  --End  
         END IF
#FUN-D40103 -----Begin------
         IF NOT s_imechk(tm.cware,tm.cloc) THEN
            NEXT FIELD cloc
         END IF
 #FUN-D40103 -----End--------
 
      AFTER FIELD cloc
         IF cl_null(tm.cloc) THEN   #FUN-630102 modify
            LET tm.cloc = ' '
         END IF
 #FUN-D40103 -----Begin-----
       ##-----MOD-B40260---------
       ##start FUN-630102 mark
       #SELECT * FROM ime_file
       # WHERE ime01 = tm.cware
       #   AND ime02 = tm.cloc
       ##   AND ime04 = 'S'
       #IF STATUS <> 0 THEN
       #   CALL cl_err('','mfg0095',0)
       #   NEXT FIELD cloc
       #END IF
       ##end FUN-630102 mark
       ##-----END MOD-B40260-----
         IF NOT s_imechk(tm.cware,tm.cloc) THEN
            NEXT FIELD cloc
         END IF
 #FUN-D40103 -----End------- 
 
         SELECT COUNT(*) INTO l_cnt FROM ogb_file
          WHERE ogb01  = l_oga.oga01
            AND ogb09 = tm.cware
            AND ogb091 = tm.cloc
         IF l_cnt > 0 THEN
            CALL cl_err('','axm-424',0)
            LET tm.cloc=' '
            NEXT FIELD cware
         END IF
 
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF

 #FUN-D40103 -------Begin------
      # #start FUN-630102 mark
      # SELECT * FROM ime_file
      #  WHERE ime01 = tm.cware
      #    AND ime02 = tm.cloc
      # #   AND ime04 = 'S'
      # IF STATUS <> 0 THEN
      #    CALL cl_err('','mfg0095',0)
      #    LET tm.cloc=' '
      #    NEXT FIELD cloc
      # END IF
      # #end FUN-630102 mark
      # #-----END MOD-B40260-----
         IF NOT s_imechk(tm.cware,tm.cloc) THEN
            LET tm.cloc=' '
            NEXT FIELD cloc
         END IF
  #FUN-D40103 -------End--------

         SELECT COUNT(*) INTO l_cnt FROM ogb_file
          WHERE ogb01 = l_oga.oga01 AND ogb09 = tm.cware
         IF l_cnt > 0 THEN
            CALL cl_err('','axm-424',0)
            LET tm.cloc=' '
            NEXT FIELD tm.cware
         END IF
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(oga01)
                LET l_t1=s_get_doc_no(tm.oga01)       #No.FUN-550052
              # CALL q_oay(FALSE,TRUE,l_t1,'59',g_sys) RETURNING l_t1       #FUN-A70130 mark
                CALL q_oay(FALSE,TRUE,l_t1,'59','axm') RETURNING l_t1       #FUN-A70130
                LET tm.oga01 = l_t1            #No.FUN-550052
                DISPLAY BY NAME tm.oga01
                NEXT FIELD oga01
            WHEN INFIELD(cware)
                 CALL q_imd_1(FALSE,TRUE,tm.cware,'S',"","","") RETURNING tm.cware 
                 DISPLAY BY NAME tm.cware
            WHEN INFIELD(cloc)
                 CALL q_ime_1(FALSE,TRUE,tm.cloc,tm.cware,"S","","","","") RETURNING tm.cloc 
                 DISPLAY BY NAME tm.cloc
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
      LET g_success = 'N'
      CLOSE WINDOW t6281_w
      RETURN
   END IF
 
   CLOSE WINDOW t6281_w
 
   LET p_oga01 = l_oga.oga01  #MOD-790150 #foreach單身key值用
 
   CALL s_auto_assign_no("axm",tm.oga01,g_today,"","oga_file","oga01","","","")
     RETURNING li_result,l_oga.oga01
 
   IF (NOT li_result) THEN
      LET g_success = 'N'
      RETURN
   END IF
 
   IF cl_null(l_oga.oga01) THEN
      LET g_success = 'N'
      RETURN
   END IF
 
   #BEGIN WORK
 
   LET l_oga.oga02  = l_oga.oga02 #MOD-B70130
   LET l_oga.oga011 = l_oga.oga011 
   LET l_oga.oga66  = tm.cware
   LET l_oga.oga67  = tm.cloc
   LET l_oga.oga09  = '9'
   LET l_oga.ogaconf= 'Y'
   LET l_oga.ogapost= 'Y'
   LET l_oga.ogaprsw= 0
   LET l_oga.oga55  = '0'
   LET l_oga.oga57  = '1'           #FUN-AC0055 add
   LET l_oga.oga56  = p_oga01
   LET l_oga.oga65  = 'N'
 
   SELECT oayapr INTO l_oga.ogamksg FROM oay_file
    WHERE oayslip = tm.oga01
   LET l_oga.oga85=' ' #No.FUN-870007
   LET l_oga.oga94='N' #No.FUN-870007
 
   LET l_oga.ogaplant = g_plant 
   LET l_oga.ogalegal = g_legal 
 
   LET l_oga.ogaoriu = g_user      #No.FUN-980030 10/01/04
   LET l_oga.ogaorig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO oga_file VALUES (l_oga.*)
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err('ins oga',SQLCA.SQLCODE,1)
      LET g_success='N'
      RETURN
   END IF

      DECLARE t600_ins_ogb_c3 CURSOR FOR
       SELECT * FROM ogb_file
        WHERE ogb01= p_oga01              #MOD-790150 modify l_oga.oga01
      CALL s_showmsg_init()               #No.FUN-710046
      FOREACH t600_ins_ogb_c3 INTO l_ogb.*
         IF STATUS THEN
            CALL s_errmsg('','',"t600_ins_ogb_c1 foreach:",SQLCA.sqlcode,1)   #No.FUN-710046
            LET g_success = 'N'                   #No.FUN-8A0086
            EXIT FOREACH
         END IF
        IF g_success = "N" THEN
           LET g_totsuccess = "N"
           LET g_success = "Y"
        END IF
        IF l_ogb.ogb52 > 0 THEN #签退数量大于0
            #更新累计签收数量和累计签退数量
            SELECT ogb50,ogb51 INTO l_ogb50,l_ogb51 FROM ogb_file
             WHERE ogb01 =  l_oga.oga011
               AND ogb03 = l_ogb.ogb03
            IF cl_null(l_ogb50) THEN 
               LET l_ogb50 = 0
            END IF 
            IF cl_null(l_ogb51) THEN 
               LET l_ogb51 = 0
            END IF           
            LET l_ogb50 = l_ogb50 + l_ogb.ogb12
            LET l_ogb51 = l_ogb51 + l_ogb.ogb52
            IF cl_null(l_ogb50) OR l_ogb50 < 0 THEN 
               LET l_ogb50 = 0
            END IF 
            IF cl_null(l_ogb51) OR l_ogb51 < 0 THEN 
               LET l_ogb51 = 0
            END IF
            UPDATE ogb_file SET ogb50 = l_ogb50,
                                ogb51 = l_ogb51
                         WHERE  ogb01 = l_oga.oga011
                           AND  ogb03 = l_ogb.ogb03 
            LET l_ogb.ogb12 = l_ogb.ogb52 
            IF NOT cl_null(l_ogb.ogb916) THEN
               CALL s_umfchk(l_ogb.ogb04,l_ogb.ogb05,l_ogb.ogb916)
                    RETURNING l_cnt,l_factor
               IF l_cnt = 1 THEN
                  LET l_factor = 1               	  
               END IF 
               LET l_ogb.ogb917 = l_ogb.ogb12 * l_factor
            END IF            
          #对母子双单位的签退数量生成
            IF g_sma.sma115 = 'Y' THEN 
               LET l_ogb.ogb912 = l_ogb.ogb53
               LET l_ogb.ogb915 = l_ogb.ogb54
               LET l_ogb.ogb917 = l_ogb.ogb55
            END IF       
            #清空ogb50,51,52這些值在簽退單中沒有意義
            LET l_ogb.ogb50 = 0
            LET l_ogb.ogb51 = 0
            LET l_ogb.ogb52 = 0
            LET l_ogb.ogb53 = 0
            LET l_ogb.ogb54 = 0
            LET l_ogb.ogb55 = 0                          	                            
         ELSE
            #只更新出货单签收数量
            SELECT ogb50 INTO l_ogb50 FROM ogb_file
             WHERE ogb01 =  l_oga.oga011
               AND ogb03 = l_ogb.ogb03
            IF cl_null(l_ogb50) THEN 
               LET l_ogb50 = 0
            END IF
            LET l_ogb50 = l_ogb50 + l_ogb.ogb12
            IF cl_null(l_ogb50) OR l_ogb50 < 0 THEN 
               LET l_ogb50 = 0
            END IF             
            UPDATE ogb_file SET ogb50 = l_ogb50
                         WHERE  ogb01 = l_oga.oga011
                           AND  ogb03 = l_ogb.ogb03                         
            CONTINUE FOREACH
         END IF
    
         LET l_ogb.ogb01 = l_oga.oga01
         LET l_ogb.ogb09 = tm.cware
         LET l_ogb.ogb091= tm.cloc
    
    
         CALL t600_else(l_ogb.*) RETURNING l_ogb.*
         LET l_ogb.ogb44=' ' #No.FUN-870007
         LET l_ogb.ogb47=0   #No.FUN-870007
   #FUN-AB0061 -----------add start----------------                          
         IF cl_null(l_ogb.ogb37) OR l_ogb.ogb37=0 THEN           
            LET l_ogb.ogb37=l_ogb.ogb13                         
         END IF                                                                             
   #FUN-AB0061 -----------add end----------------   
         LET l_ogb.ogbplant = g_plant 
         LET l_ogb.ogblegal = g_legal 
   
    
         INSERT INTO ogb_file VALUES(l_ogb.*)
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL s_errmsg('','',"INS ogb",SQLCA.sqlcode,1)  #No.FUN-710046
            LET g_success='N'
            CONTINUE FOREACH  #No.FUN-710046
         ELSE
            IF NOT s_industry('std') THEN
               INITIALIZE l_ogbi.* TO NULL
               LET l_ogbi.ogbi01 = l_ogb.ogb01
               LET l_ogbi.ogbi03 = l_ogb.ogb03
               IF NOT s_ins_ogbi(l_ogbi.*,'') THEN
                  LET g_success = 'N'
                  CONTINUE FOREACH
               END IF
            END IF
         END IF
         IF l_ogb.ogb17='N' OR cl_null(l_ogb.ogb17) THEN
            LET g_ima918 = ''   #MOD-9C0055
            LET g_ima921 = ''   #MOD-9C0055
            LET g_ima930 = ''   #DEV-D30059 add
            SELECT ima918,ima921,ima930 INTO g_ima918,g_ima921,g_ima930 #DEV-D30059 add ima930 
              FROM ima_file
             WHERE ima01 = l_ogb.ogb04
               AND imaacti = "Y"

            IF cl_null(g_ima930) THEN LET g_ima930 = 'N' END IF  #DEV-D30059 add

            IF g_ima918 = "Y" OR g_ima921 = "Y" THEN           
                  LET g_prog_t = g_prog
                  IF s_industry('icd') THEN 
                     LET g_prog = 'axmt629_icd'
                  ELSE
                     LET g_prog = 'axmt629' 
                  END IF
                  #test 取签收仓的仓库和储位
                  SELECT DISTINCT ogb09 INTO l_ogb09 FROM ogb_file #120712
                   WHERE ogb01 = l_oga.oga56
                  SELECT DISTINCT ogb091 INTO l_ogb091 FROM ogb_file #120712
                   WHERE ogb01 = l_oga.oga56                 
                  IF g_ima930 = 'N' THEN                                        #DEV-D30059
                     CALL s_mod_lot(g_prog,l_oga.oga01,l_ogb.ogb03,0,      
                                    l_ogb.ogb04,l_ogb09,
                                    l_ogb091,l_ogb.ogb092,
                                    l_ogb.ogb05,l_ogb.ogb15,l_ogb.ogb15_fac,
                                    l_ogb.ogb12,'','MOD',-1)   
                        RETURNING l_r,l_qty 
                  END IF                                                        #DEV-D30059
                  LET  g_prog = g_prog_t
            END IF 
         END IF    
         #CHI-AC0034 add --start--
         #FUN-C50097此处多次签收需要调整多倉儲出貨 120718
         #No.MOD-C70145  --beg
         #IF l_ogb.ogb17='Y' AND g_oaz.oaz23 = 'Y' THEN     ##多倉儲出貨
         IF l_ogb.ogb17='Y' THEN     ##多倉儲出貨
         #No.MOD-C70145  --End          
            DECLARE t600sub_ins_ogc_c2 CURSOR FOR
             SELECT * FROM ogc_file
              WHERE ogc01= p_oga01
                AND ogc03= l_ogb.ogb03
            FOREACH t600sub_ins_ogc_c2 INTO l_ogc.*
               IF STATUS THEN
                  CALL s_errmsg('','',"t600sub_ins_ogc_c foreach:",SQLCA.sqlcode,1) 
                  LET g_success = 'N'   
                  EXIT FOREACH
               END IF
               IF g_success = "N" THEN
                  LET g_totsuccess = "N"
                  LET g_success = "Y"
               END IF

               IF l_ogc.ogc13 > 0 THEN 
                  LET l_ogc.ogc12 = l_ogc.ogc13 
                  LET l_ogc.ogc16 = l_ogc.ogc12 * l_ogc.ogc15_fac
                  LET l_ogc.ogc16 = s_digqty(l_ogc.ogc16,l_ogc.ogc15)   #FUN-910088--add--
               ELSE
                  CONTINUE FOREACH
               END IF
   
               LET l_ogc.ogc01 = l_oga.oga01
               LET l_ogc.ogc09 = tm.cware
               LET l_ogc.ogc091= tm.cloc
   
               INSERT INTO ogc_file VALUES(l_ogc.*)
               IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                  CALL s_errmsg('','',"ins ogc",SQLCA.sqlcode,1)  
                  LET g_success='N'
                  CONTINUE FOREACH
               END IF
   
               LET g_ima918 = ''   
               LET g_ima921 = ''  
               SELECT ima918,ima921 INTO g_ima918,g_ima921 
                 FROM ima_file
                WHERE ima01 = l_ogc.ogc17
                  AND imaacti = "Y"
   
               IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                  DECLARE t600sub_g_rvbs_3 CURSOR FOR SELECT * FROM rvbs_file
                                                 WHERE rvbs01 = l_oga.oga011
                                                   AND rvbs02 = l_ogb.ogb03
                                                   AND rvbs13 = l_ogc.ogc18
                  LET i = 1
                  FOREACH t600sub_g_rvbs_3 INTO l_rvbs.*
                     IF STATUS THEN
                        CALL cl_err('rvbs',STATUS,1)
                        LET g_success='N'
                     END IF
   
                     LET l_cnt = 0 
                     SELECT COUNT(*) FROM rvbs_file
                      WHERE rvbs00[1,7] = 'axmt629'   #FUN-B40066 add [1,7]             
                        AND rvbs01 = l_oga.oga01
                        AND rvbs02 = l_ogb.ogb03
                        AND rvbs09 = '-1'
                        AND rvbs13 = 0 
                        AND rvbs03 = l_rvbs.rvbs03
                        AND rvbs04 = l_rvbs.rvbs04
                     IF l_cnt > 0 THEN
                        CONTINUE FOREACH
                     END IF
                     #LET l_rvbs.rvbs00 = 'axmt629' #FUN-B40066 mark
                     #FUN-B40066 --START--
                     IF s_industry('icd') THEN
                        LET l_rvbs.rvbs00 = 'axmt629_icd'
                     ELSE    
                        LET l_rvbs.rvbs00 = 'axmt629' 
                     END IF   
                     #FUN-B40066 --END--
                     LET l_rvbs.rvbs01 = l_oga.oga01
   
                     #檢查銷退數必須 =出貨單上的數量-簽收單上的數量
                     LET l_rvbs06a = 0
   
                     SELECT SUM(rvbs06) INTO l_rvbs06a
                       FROM rvbs_file
                      WHERE rvbs01= l_oga.oga011
                        AND rvbs02= l_ogb.ogb03
                        AND rvbs13 = l_rvbs.rvbs13   
                        AND rvbs09 = -1   #TQC-B90236 modify 
                        AND rvbs03=l_rvbs.rvbs03
                        AND rvbs04=l_rvbs.rvbs04
                     
                     IF cl_null(l_rvbs06a) THEN
                        LET l_rvbs06a = 0
                     END IF
   
                     #已簽收數量
                     LET l_rvbs06b = 0
                     LET l_rvbs.rvbs022 = i 
   
                     SELECT SUM(rvbs06) INTO l_rvbs06b
                       FROM ogb_file,oga_file,rvbs_file
                      WHERE ogb01 = oga01 AND oga09 IN ('8') 
                        AND oga011 = l_oga.oga011
                        AND ogb03 = l_ogb.ogb03
                        AND oga01 = rvbs01
                        AND ogb03 = rvbs02
                        AND rvbs13 = l_rvbs.rvbs13  
                        AND rvbs09 = -1
                        AND ogaconf != 'X' 
                        AND rvbs03=l_rvbs.rvbs03
                        AND rvbs04=l_rvbs.rvbs04
   
                     IF cl_null(l_rvbs06b) THEN
                        LET l_rvbs06b = 0
                     END IF
   
                     LET l_rvbs.rvbs06 = l_rvbs06a - l_rvbs06b
   
                     INSERT INTO rvbs_file VALUES(l_rvbs.*)
                     IF STATUS OR SQLCA.SQLCODE THEN
                        CALL cl_err3("ins","rvbs_file","","",SQLCA.sqlcode,"","ins rvbs",1)  
                        LET g_success='N'
                     END IF
                     LET i = i + 1 
                  END FOREACH
               END IF
            END FOREACH
         END IF
         #CHI-AC0034 add --end--
      END FOREACH

     IF g_totsuccess="N" THEN
        LET g_success="N"
     END IF
   #要處理過帳
   DECLARE t600_post_cur12 CURSOR FOR
    SELECT * FROM ogb_file WHERE ogb01 = l_oga.oga01
 
   FOREACH t600_post_cur12 INTO l_ogb.*
      IF STATUS THEN
         CALL s_errmsg('','',"t600_post_cur12 foreach:",SQLCA.sqlcode,0)  #No.FUN-710046
         EXIT FOREACH
      END IF
     IF g_success = "N" THEN
        LET g_totsuccess = "N"
        LET g_success = "Y"
     END IF
      LET l_ogb.ogb01 = l_oga.oga01
 
      LET l_flag='' 
      #No.MOD-C70145  --Begin
      #IF l_ogb.ogb17='Y' AND g_oaz.oaz23 = 'Y' THEN     ##多倉儲出貨
      IF l_ogb.ogb17='Y' THEN
      #No.MOD-C70145  --End       
         DECLARE t600_s1_ogc_c42 CURSOR FOR          
          SELECT SUM(ogc12),ogc17,ogc092 FROM ogc_file  #MOD-C10103 add ogc092
#           SELECT * FROM ogc_file     
            WHERE ogc01=l_oga.oga01 AND ogc03=l_ogb.ogb03  #MOD-BC0089 remark
          GROUP BY ogc17,ogc092                                             #MOD-C10103 add ogc092
         FOREACH t600_s1_ogc_c42 INTO l_ogc.ogc12,l_ogc.ogc17,l_ogc.ogc092   #MOD-C10103 add ogc092 
            IF SQLCA.SQLCODE THEN
               CALL s_errmsg('','',"Foreach s1_ogc:",SQLCA.sqlcode,1)
               LET g_success='N' RETURN 
            END IF
            LET l_msg='_s1() read ogc02:',l_ogb.ogb03,'-',l_ogc.ogc091
            CALL cl_msg(l_msg)
            LET l_flag='X'    
#CHI-B60054  --Begin #MARK掉CHI-B30093更改
#CHI-B30093 --begin--               
            SELECT img09 INTO l_img09 FROM img_file
             WHERE img01= l_ogb.ogb04  AND img02= l_oga.oga66
            #No.MOD-C70145  --Begin
            #  AND img03= l_oga.oga67 AND img04= l_ogb.ogb092             
               AND img03= l_oga.oga67 AND img04= l_ogc.ogc092             
            #No.MOD-C70145  --End 
            #FUN-C50097 ADD BEG
            IF cl_null(l_img09) THEN 
               SELECT img09 INTO l_img09 FROM img_file
                WHERE img01= l_ogb.ogb04  AND img02= g_oaz.oaz74
                  AND img03= l_oga.oga67 AND img04= l_ogc.ogc092                               
            END IF             
            #FUN-C50097 ADD END  
           CALL s_umfchk(l_ogb.ogb04,l_ogb.ogb05,l_img09) RETURNING g_cnt,l_ogc.ogc15_fac
            LET l_ogc.ogc16=l_ogc.ogc12*l_ogc.ogc15_fac
            LET l_ogc.ogc16 = s_digqty(l_ogc.ogc16,l_ogc.ogc15)    #FUN-910088--add--
           #CALL t600sub_consign(l_oga.oga66,l_oga.oga67,l_ogb.ogb092,    #MOD-C10103 mark  
            CALL t600sub_consign(l_oga.oga66,l_oga.oga67,l_ogc.ogc092,    #MOD-C10103 remark 
#CHI-B30093 --end--
#CHI-B60054  --End #MARK掉CHI-B30093更改
                          l_ogc.ogc12,l_ogb.ogb05,l_ogc.ogc15_fac,l_ogc.ogc16,l_flag,l_ogc.ogc17,l_oga.*,l_ogb.*)  
            IF g_success='N' THEN  
               LET g_totsuccess="N"
               LET g_success="Y"
               #RETURN    #MOD-BB0058 mark
            END IF
            #FUN-B40066 --START--
            IF s_industry('icd') THEN
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM idb_file
                WHERE idb07 = l_ogb.ogb01 AND idb08 = l_ogb.ogb03
               IF l_cnt > 0 THEN
                  DECLARE t600sub_idb_c6 CURSOR FOR
                   SELECT * FROM idb_file
                    WHERE idb07 = l_ogb.ogb01 AND idb08 = l_ogb.ogb03
                  FOREACH t600sub_idb_c6 INTO l_idb.* 
                     #出貨簽收單產生ida資料
                     IF NOT s_icdout_insicin(l_idb.*,l_oga.oga66,l_oga.oga67,l_idb.idb04) THEN  #TQC-BA0136  l_ogc.ogc092->l_idb.idb04
                        LET g_success='N'
                        EXIT FOREACH
                     END IF
                     IF g_success='N' THEN  
                        LET g_totsuccess="N"
                        LET g_success="Y"
                        EXIT FOREACH
                     END IF
                  END FOREACH
               END IF
               SELECT ogbiicd028,ogbiicd029 INTO l_ogbi.ogbiicd02,l_ogbi.ogbiicd029
                FROM ogbi_file WHERE ogbi01 = l_ogb.ogb01 AND ogbi03 = l_ogb.ogb03
               CALL s_icdpost(1,l_ogb.ogb04,l_oga.oga66,l_oga.oga67,
                    l_ogc.ogc092,l_ogb.ogb05,l_ogb.ogb12,
                    l_oga.oga01,l_ogb.ogb03,l_oga.oga02,'Y',
                    '','',l_ogbi.ogbiicd029,l_ogbi.ogbiicd028,'')  #FUN-B80119--傳入p_plant參數''---
                    RETURNING l_flag
               IF l_flag = 0 THEN
                  LET g_success = 'N'                     
                  RETURN
               END IF
            END IF    
            #FUN-B40066 --END--
         END FOREACH
      ELSE
         IF l_ogb.ogb17='Y' THEN 
            LET l_flag = 'Y'
         ELSE 
            LET l_flag='' 
         END IF           #CHI-B30093 #CHI-B60054 去掉mark CHI-B30093 
         CALL t600sub_consign(l_oga.oga66,l_oga.oga67,l_ogb.ogb092,   
                       l_ogb.ogb12,l_ogb.ogb05,l_ogb.ogb15_fac,l_ogb.ogb16,l_flag,l_ogb.ogb04,l_oga.*,l_ogb.*)  
         #END IF           #CHI-B30093 #CHI-B60054 mark CHI-B30093 
         IF g_success='N' THEN 
            LET g_totsuccess="N"
            LET g_success="Y"
         END IF
         #FUN-B40066 --START--
         IF s_industry('icd') THEN
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM idb_file
             WHERE idb07 = l_ogb.ogb01 AND idb08 = l_ogb.ogb03
            IF l_cnt > 0 THEN
               DECLARE t600sub_idb_c42 CURSOR FOR
                SELECT * FROM idb_file
                 WHERE idb07 = l_ogb.ogb01 AND idb08 = l_ogb.ogb03
               FOREACH t600sub_idb_c42 INTO l_idb.* 
                  #出貨簽收單產生ida資料
                  IF NOT s_icdout_insicin(l_idb.*,l_oga.oga66,l_oga.oga67,l_idb.idb04) THEN   #TQC-BA0136  l_ogc.ogc092 ->l_idb.idb04
                     LET g_success='N'
                     EXIT FOREACH
                  END IF
                  IF g_success='N' THEN  
                     LET g_totsuccess="N"
                     LET g_success="Y"
                     EXIT FOREACH
                  END IF
               END FOREACH
            END IF
            SELECT ogbiicd028,ogbiicd029 INTO l_ogbi.ogbiicd02,l_ogbi.ogbiicd029
             FROM ogbi_file WHERE ogbi01 = l_ogb.ogb01 AND ogbi03 = l_ogb.ogb03
            CALL s_icdpost(1,l_ogb.ogb04,l_oga.oga66,l_oga.oga67,
                 l_ogc.ogc092,l_ogb.ogb05,l_ogb.ogb12,
                 l_oga.oga01,l_ogb.ogb03,l_oga.oga02,'Y',
                 '','',l_ogbi.ogbiicd029,l_ogbi.ogbiicd028,'')  #FUN-B80119--傳入p_plant參數''---
                 RETURNING l_flag
            IF l_flag = 0 THEN
               LET g_success = 'N'                     
               RETURN
            END IF
         END IF    
         #FUN-B40066 --END--
      END IF
      #CHI-AC0034 add --end--
 
      IF g_sma.sma115 = 'Y' THEN
#FUN-C50097 ADD BEGIN
#此处要生成签退单ogg_file
         IF l_ogb.ogb17='Y' THEN     ##多倉儲出貨
            DECLARE t600sub_ins_ogg_c2 CURSOR FOR
             SELECT * FROM ogg_file
              WHERE ogg01= p_oga01
                AND ogg03= l_ogb.ogb03
            FOREACH t600sub_ins_ogg_c2 INTO l_ogg.*
               IF STATUS THEN
                  CALL s_errmsg('','',"t600sub_ins_ogg_c2 foreach:",SQLCA.sqlcode,1) 
                  LET g_success = 'N'   
                  EXIT FOREACH
               END IF
               IF g_success = "N" THEN
                  LET g_totsuccess = "N"
                  LET g_success = "Y"
               END IF

               IF l_ogg.ogg13 > 0 THEN 
                  LET l_ogg.ogg12 = l_ogg.ogg13 
                  LET l_ogg.ogg16 = l_ogg.ogg12 * l_ogg.ogg15_fac
                  LET l_ogg.ogg16 = s_digqty(l_ogg.ogg16,l_ogg.ogg15)   #FUN-910088--add--
               ELSE
                  CONTINUE FOREACH
               END IF
   
               LET l_ogg.ogg01 = l_oga.oga01
               LET l_ogg.ogg09 = tm.cware
               LET l_ogg.ogg091= tm.cloc
   
               INSERT INTO ogg_file VALUES(l_ogg.*)
               IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                  CALL s_errmsg('','',"ins ogg",SQLCA.sqlcode,1)  
                  LET g_success='N'
                  CONTINUE FOREACH
               END IF
            END FOREACH   
         END IF       
#FUN-C50097 ADD END
         CALL t600sub_consign_mu(l_oga.oga66,l_oga.oga67,l_ogb.ogb092,l_oga.*,l_ogb.*)     #No.TQC-6B0174
         IF g_success = 'N' THEN
            RETURN
         END IF
      END IF
   END FOREACH
     IF g_totsuccess="N" THEN
        LET g_success="N"
     END IF
#     IF g_success = 'Y' THEN
#        COMMIT WORK
#     ELSE
#        ROLLBACK WORK
#     END IF
END FUNCTION


#FUN-C50097 ADD END----------------

#MOD-CB0050 add begin-----------
FUNCTION t600sub_chk_ogb1001(p_ogb1001)
DEFINE p_ogb1001 LIKE ogb_file.ogb1001,
       l_cnt2    LIKE type_file.num5

   SELECT COUNT(*) INTO l_cnt2 FROM azf_file 
    WHERE azf01=p_ogb1001
    AND azf02 = '2' 
    AND azf08 = 'Y'   
    AND azfacti = 'Y' 
   RETURN l_cnt2
   
END FUNCTION     
#MOD-CB0050 add end-------------

#DEV-D40013 --add
