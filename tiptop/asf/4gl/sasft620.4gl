# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program code...: asft620.4gl
# Program name...: 工單完工入庫維護作業
# Modify.........: Copy from saimt620
# Modify.........: Modify By Carol:領料單如有輸入單號別則自動產生一張領料單
#                                  無須領料單先建立單頭再由K.領料產生insert單身
# Modify.........: Modify By Carol:1999/04/14 完工入庫數量check最小套數數量
# Modify.........: 99/08/18 By Carol:工單完工時未使用消秏性料件則不可產生領料單
# Modify.........: 01/05/08 BY ANN CHEN No.B363 任何異動應排除已結案工單
#                : 01/05/09 BY ANN CHEN No.B492 是否需FQC單號依工單[sfa94]
#                                               與參數[sma896]決定
#                                               如參數為'N'則工單的flag無效
# Modify.........: No:6962 03/07/14 BY Carol:按K.領料單產生時,
#                                            扣帳日default g_today
# Modify.........: No:6836 03/07/14 BY Carol:工單最小發料日期>入庫日期的檢查
#                                            改在非PULL 的狀況下才check
# Modify.........: No:7049,7280 03/07/16 By Carol:同上問題
# Modify.........: No:7813 03/08/18 Carol t620_s1_c中sfb01 = b_sfv.sfb11
#                                         應該為 sfb01 = b_sfv.sfv11
# Modify.........: No:7812 03/08/18 Carol 聯產品參數設定為工單完工入庫時,系統無法使用
#                                         同 7813 一起修改
# Modify.........: No:7829 03/08/18 Carol 單據程式中呼叫單據自動編號時,
#                                         應該是要包覆在 BEGIN WORK 中(transaction)
#                                         才會達到lock 的功能
# Modify.........: No.6963 03/08/25 Nicola 從apmp300過來的單子會秀該筆資料
# Modify.........: No:7834 03/09/03 Carol 針對完工方式='2'(PULL)若有走製程, 則入庫量應= 製程終站轉出量, 且入庫量
#                                         也應該控管不可超過製程終站轉出量
#                                         --> AFETR FIELD sfv09 add check數量
# Modify.........: No:9697 04/06/28 Melody 多判斷null與空白,避免自動帶出時無法過帳
# Modify.........: MOD-470041 04/07/16 Wiky 修改INSERT INTO...
# Modify.........: MOD-470503(9792) 04/07/22 Carol 1.add sfpuser/sfpmodu/sfpdate
#                                                  2.型態7,8 屬委外,不可做工單完工入庫
# Modify.........: MOD-480206 04/08/06 Carol 單身修改時,call t620_sfb01()應不可將倉儲自動變更預設為工單預設入庫or庫存的倉儲
# Modify.........: MOD-480058 04/08/26 Wiky FQC檢查輸入,還要CHECK asi300 部份
# Modify.........: MOD-490217 04/09/10 by yiting 料號欄位使用like方式
# Modify.........: MOD-460966 04/09/22 Kammy 若外部參數傳進 default g_wc2='1=1'
# Modify.........: No.MOD-490371 04/09/22 By Yuna Controlp 未加display
# Modify.........: No:MOD-4A0063 04/10/06 By Mandy q_ime 的參數傳的有誤
# Modify.........: No:MOD-4A0213 04/10/14 By Mandy q_imd 的參數傳的有誤
# Modify.........: No:MOD-4A0260 04/10/19 By Mandy 在INPUT ARRAY 段中所有的LET g_sfv[l_ac].xxx=???之後再加一行DISPLAY BY NAME g_sfv[l_ac].xxx,避免修改狀態之下沒有觸發ON ROW CHANGE
# Modify.........: No:MOD-4A0252 04/10/21 By Smapmin 新增領料單號開窗
# Modify.........: No:FUN-4B0011 04/11/02 By Carol 新增 I,T,Q類 單身資料轉 EXCEL功能(包含假雙檔)
# Modify.........: No:FUN-4B0072 04/11/10 By Carol 若走製程應以製程轉出數為準,而非最小套數
# Modify.........: No:MOD-4B0169 04/11/22 By Mandy check imd_file 的程式段...應加上 imdacti 的判斷
# Modify.........: No:MOD-4C0010 04/12/02 By Mandy DEFINE smydesc欄位用LIKE方式
# Modify.........: No:FUN-4C0035 04/12/08 By Carol Q,U,R 加入權限控管處理
# Modify.........: No:MOD-510135 05/01/18 By ching 非聯產品料號noentry
# Modify.........: No:MOD-540191 05/04/28 By Carol 修改工單編號後料號應一起變更display
# Modify.........: No:FUN-540055 05/05/12 By Elva  新增雙單位內容  & 單號加大
# Modify.........: No:FUN-550085 05/05/24 By Carol 單身加FQC單欄位(sfv17)
# Modify.........: No:FUN-550011 05/05/31 By kim GP2.0功能 庫存單據不同期要check庫存是否為負
# Modify.........: NO.FUN-560020 05/06/10 By Elva   雙單位內容調整
# Modify.........: NO.FUN-560121 05/06/19 By Carol  aim-995訊息顯示之後,應可離開欄位
# Modify.........: NO.FUN-560195 05/07/04 By Carol  6/19會議:sfu03決定拿掉,改成 no use
# Modify.........: No:MOD-570344 05/07/25 By pengu tlf024,tlf034應該記錄img10量而不是ima262
# Modify.........: No:MOD-580251 05/08/23 By kim 修改產生領料單的錯誤
# Modify.........: No:FUN-580119 05/08/23 By Carrier 產生領料單的多單位內容
# Modify.........: No:MOD-580230 05/08/29 By Carrier s_add_imgg在參考單位的時候執行不到
# Modify.........: No.MOD-590120 05/09/09 By Carrier 修改set_origin_field
# Modify.........: No:MOD-580334 05/09/13 By kim 當入庫單的領料單號(sfu09)不為NULL時,不可以作入庫單扣帳還原
# Modify.........: No:MOD-590260 05/09/22 By kim 入庫單單身FQC單號欄位,應該參考該張工單是否需要fqc決定,而不是參考該入庫單單據類別設定
# Modify.........: No.MOD-590347 05/09/29 By Carrier mark du_default()
# Modify.........: No:MOD-5A0044 05/10/04 By kim 以入庫量產生發料單的部分 ,在選單據別時目前客戶的單據別代碼為 5 碼 ,但是目前系統會檢查 3 碼
# Modify.........: No:MOD-5A0043 05/10/04 By kim FQC時,參考單位,參考數量不要清空
# Modify.........: No:MOD-5A0011 05/10/12 By pengu   輸入入庫日期會有 '-'
# Modify.........: No:MOD-5B0100 05/11/08 By kim 變數全部改用LIKE
# Modify.........: No:TQC-5B0075 05/11/09 By Pengu 1.依工單上FQC否的欄位='Y'來檢查此工單是否須keyFQC單號
# Modify.........: No.TQC-5C0035 05/12/07 By Carrier set_required時去除單位換算率
# Modify.........: No:TQC-5C0032 05/12/07 By Claire 開窗查料號q_ima,不判斷聯產品
# Modify.........: No:FUN-5B0077 05/12/13 By Sarah 當g_ccz.ccz06='2'時,LET g_tlf.tlf19=g_sfu.sfu04
# Modify.........: No:FUN-5C0055 05/12/19 By kim 更新工單狀態為'4'時,不應該考慮sfs_file是否存在
# Modify.........: No:MOD-5B0302 05/12/22 By Pengu 程式段sql語法錯誤
# Modify.........: No:MOD-5B0304 05/12/22 By Pengu 1.進入單身時message未show完整
                                     #             2.單身自動產生資料時，可入庫量應DEFAULT FQC量
# Modify.........: No:MOD-5A0444 05/12/22 By  1.判斷若g_over_qty為NULL時default=0
# Modify.........: No:MOD-5B0054 05/12/22 By Pengu 入庫過帳時在確認單身入庫料號是否與工單生產料號matches
# Modify.........: No:FUN-610006 06/01/07 By Smapmin 雙單位畫面調整
# Modify.........: No:FUN-610075 06/01/20 By Nicola QC多單位
# Modify.........: No:MOD-610135 06/01/23 By Kevin 將l_min_qty 調整為LIKE sfv_file.sfv09
# Modify.........: No:FUN-610090 06/02/07 By Nicola 拆併箱功能修改
# Modify.........: No:FUN-5C0114 06/02/10 By kim GP3.0 重複性生產 入庫功能
# Modify.........: No:FUN-630001 06/03/02 By kim GP3.0 重複性生產 入庫單列印功能
# Modify.........: No:TQC-630013 06/03/03 By Claire 串報表傳參數
# Modify.........: No:FUN-630010 06/03/08 By saki 流程訊息通知功能
# Modify.........: NO:TQC-620156 06/03/15 By kim GP3.0過帳錯誤統整顯示功能新增
# Modify.........: NO:MOD-630064 06/03/16 By kim for ASR-完工入庫數不可修改大於報工數 / FQC量
# Modify.........: NO:TQC-630246 06/03/24 By Claire 當聯產品料號完工入庫過帳時,存在於abmi608建檔的料號要忽略asf-968錯誤
# Modify.........: NO:MOD-640120 06/04/09 By kim asrt320過帳後,再過帳還原,再過帳就不行了
# Modify.........: NO:FUN-640041 06/04/09 By kim asrt320單身應該要控管該項次入庫總量不可(單身報工項次因倉儲批不同多筆呈現)>FQC量
# Modify.........: NO:MOD-640427 06/04/13 By cl 修正不使用雙單位時，show雙單位的情況。
# Modify.........: NO:FUN-630105 06/04/19 By kim ASR刪除入庫單時,清空FQC的入庫單號
# Modify.........: No:MOD-640013 06/04/25 By pengu 生成領料單時,未考慮取替代料的情況
# Modify.........: No:MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: NO:TQC-650121 06/05/26 By kim 單身查詢報工單單號,已入庫之報工單不應被查詢出來
# Modify.........: NO:FUN-650178 06/06/08 By kim 刪除入庫單時,一併清除報工單的入庫單號欄位
# Modify.........: NO:MOD-660023 06/06/09 By Claire apm->asf
# Modify.........: No:FUN-660110 06/06/15 By Sarah 輸入sfv11工單號碼時需檢查是否為15.試產工單,若是需警告並要求重新輸入
# Modify.........: No:FUN-660106 06/06/16 By kim GP3.1 增加確認碼欄位與處理
# Modify.........: No:FUN-660137 06/06/20 By kim GP3.1 增加確認碼欄位與處理
# Modify.........: No:FUN-660085 06/07/03 By Joe 若單身倉庫欄位已有值，則倉庫開窗查詢時，重新查詢時不會顯示該料號所有的倉儲。
# Modify.........: No:MOD-660106 06/07/05 By Pengu 領料(事後扣帳)的工單，工單在入庫時數量並不會檢查可入庫數
# Modify.........: No:MOD-660086 06/07/05 By Sarah 查詢一筆未確認的單號後按新增再放棄,再按作廢,之前查詢的那筆會被作廢掉
# Modify.........: No:TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No:FUN-670103 06/07/28 By kim GP3.5 利潤中心
# Modify.........: No:FUN-680121 06/09/01 By huchenghao 類型轉換
# Modify.........: No:FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No:FUN-6B0031 06/11/10 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No:FUN-6A0166 06/11/10 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No:FUN-680139 06/12/04 By rainy 過帳後要 call t620_k()
# Modify.........: No:MOD-6C0034 06/12/07 By kim 輸入新的單位開窗的時機點
# Modify.........: No:MOD-690018 06/12/08 By pengu UPDATE sfv_file 未更新 sfv17 
# Modify.........: No:MOD-6C0082 06/12/13 By kim 單身輸入FQC單號後,沒有帶出入庫量，在工單單號按ENTER後才會帶出來
# Modify.........: No:MOD-6A0009 06/12/13 By pengu 入庫數量的提示字不見
# Modify.........: No:MOD-690005 06/12/14 By pengu 同一張工單分多張FQC單入庫時，允入庫量出現異常
# Modify.........: No:FUN-6C0083 07/01/09 By Nicola 錯誤訊息彙整
# Modify.........: No:CHI-6C0004 07/01/22 By rainy 為當"新增單身,且入庫量為0或空值時才重算發料套數
# Modify.........: No:MOD-6C0081 07/01/29 By claire 單身入庫量已輸入後,更正單身時入庫量不應重計
# Modify.........: No:MOD-6C0156 07/03/05 By pengu l_sfv09計算有誤，未考慮工單分批FQC的情況
# Modify.........: No:MOD-710034 07/03/06 By pengu  操作方式為輸入單據別後直接按確認跳至單身,單據日期不會
#                                                   Check現行年月及會計期間的合理性檢測
# Modify.........: No:MOD-710050 07/03/06 By pengu 輸入一個新倉儲批時，會詢問"新的料件倉庫儲位,是否確定新增庫存明細(Y/N)"
#                                                  當按'N'無法離開該欄位
# Modify.........: No:MOD-710160 07/03/07 By Pengu 程式段sql語法錯誤
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No:TQC-710114 07/03/20 By Ray 1.單身開窗字段"FQC單號"錄入任何值不報錯
#                                                2.進單身報錯
# Modify.........: No:TQC-720052 07/03/21 By Judy 開窗字段"項目編號"錄入任何值不報錯
# Modify.........: No:FUN-730075 07/04/02 By kim 行業別架構
# Modify.........: No:MOD-740151 07/04/22 By kim 新增單身時,入庫數沒帶套數
# Modify.........: No:TQC-740263 07/04/23 By Sarah 當入庫單是由asft300生產報工產生的,在修改單身的入庫數量時要檢查兩邊若不match則顯示訊息
# Modify.........: No:MOD-740165 07/04/23 By Pengu 入庫單單身之功能鍵「產生」在輸入料號為條件後
#                                                  未產生該工單相關之可入庫工單供選擇。
# Modify.........: No:MOD-740061 07/04/24 By Pengu 若同時有兩人在產生領料單時，若單別選一樣的時候
#                                                  會出現領料單號一樣
# Modify.........: No:FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No:TQC-750208 07/05/28 By pengu 修正zl單MOD-660106的寫法
# Modify.........: No:TQC-760057 07/06/15 By rainy 系統自動產生領料單時, 產生到 asfi514單身的 '倉庫''儲位' 應自動先帶入該料的主要倉儲(ima35,ima36)
# Modify.........: No:MOD-770048 07/07/13 By pengu 右下角的MSG秀的可入庫量的值取為錯誤
# Modify.........: No:TQC-760185 07/07/18 By pengu 工單若走FQC時，在入庫單單身數量修改時會出現"asf-675"錯誤訊息
# Modify.........: No:CHI-770019 07/07/26 By Carrier 多單位:參考單位時,交易單位不寫入tlff
# Modify.........: No:MOD-770140 07/07/28 By pengu 入庫單直接按產生領料時,所產生之領料單應多Insert sfpgrup
# Modify.........: No:MOD-750061 07/09/26 By pengu 在FQC單維護聯產品資料時，當作完工入庫單時不會卡入庫的數量要和FQC matches
# Modify.........: No:MOD-790122 07/09/26 By Pengu 聯產品入庫時會跳過料號欄位無法維護
# Modify.........: No:MOD-780278 07/10/17 By Pengu 扣帳的工單還沒確認卻可以打在單身工單上
# Modify.........: No:MOD-7A0059 07/11/01 By Pengu 在AFTER INSERT時在判定imgg是否存在
# Modify.........: No:CHI-7B0023 07/11/16 By kim 移除GP5.0行業別功能的所有程式段
# Modify.........: No:TQC-7B0083 07/11/23 By Carrier rvv88給default值
# Modify.........: No:FUN-810045 08/01/16 By rainy 項目管理 單頭理由碼取消，單身加專案編號(sfv41)/WBS(sfv42)/活動編號(sfv43)/理由碼(sfv44)
# Modify.........: No:FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No:FUN-810036 08/01/16 By Nicola 序號管理
# Modify.........: No:FUN-7B0018 08/03/05 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-810038 08/03/07 By kim GP5.1 ICD 4gl->src
# Modify.........: No:FUN-830061 08/03/18 By mike ICD
# Modify.........: No:CHI-7A0029 08/03/21 By kim GP5.1 ICD
# Modify.........: No:FUN-830078 08/03/24 By bnlent 錯誤訊息修改 
# Modify.........: No.FUN-840042 08/04/16 by TSD.zeak 自訂欄位功能修改 
# Modify.........: No:MOD-840216 08/04/20 By Nicola 不做批/序號不刪除tlfs_file
# Modify.........: No:MOD-840552 08/04/25 By kim GP5.1顧問測試修改
# Modify.........: No:MOD-850193 08/05/22 By claire 倒扣料生產入庫時所產生的領料單要考慮最少發料量及批量
# Modify.........: No:MOD-850223 08/05/22 By claire 產生時排除工單是委外工單
# Modify.........: No:FUN-850120 08/05/23 By rainy 多單位補批序號處理
# Modify.........: NO.CHI-860008 08/06/11 BY yiting s_del_rvbs條件修改
# Modify.........: No:FUN-860045 08/06/12 By Nicola 批/序號傳入值修改及開窗詢問使用者是否回寫單身數量
# Modify.........: No:FUN-860069 08/06/18 By Sherry 增加輸入日期
# Modify.........: No:FUN-850027 08/06/18 By douzh WBS編碼錄入時要求時尾階并且為成本對象的WBS編碼
# Modify.........: No:MOD-860261 08/06/24 By Nicola 調整upimg()傳入參數
# Modify.........: No:TQC-850009 08/07/16 By liuxqa 審核時單身可以為空
# Modify.........: No:MOD-860208 08/07/16 By Pengu t620_upd_sre11() 中,不應該在此function中做commit work 或 rollback work 的動作
# Modify.........: No:MOD-880111 08/08/14 By wujie 產生領料單時，按照asfi514的限制去除不符合條件的工單
# Modify.........: No:FUN-880129 08/09/05 By xiaofeizhu s_del_rvbs的傳入參數(出/入庫，單據編號，單據項次，專案編號)，改為(出/入庫，單據編號，單據項次，檢驗順序)
# Modify.........: No:MOD-890168 08/09/18 By claire 調整MOD-880111的語法
# Modify.........: No:FUN-840012 08/10/06 By kim mBarcode整合
# Modify.........: No:MOD-8A0031 08/10/07 By claire 調整MOD-890168的語法
# Modify.........: No:MOD-8A0114 08/10/14 By claire 可入庫量,小於零時,負數顯示
# Modify.........: No:MOD-8A0197 08/10/22 By claire (1)調整MOD-850223
#                                                   (2)單身產生action,料號應不適合輸入*表示全部
# Modify.........: No:MOD-8B0086 08/11/10 By chenyu 工單沒有取替代料號時，讓sfs27=sfa27
# Modify.........: No:FUN-8A0126 08/11/10 By jan 單身查詢時 , 增加 "依PBI#欄位查詢工單號碼" 此按鈕
# Modify.........: No:MOD-8B0227 08/11/21 By claire 倉庫為wip應可輸入
# Modify.........: No:MOD-8B0232 08/11/21 By claire upd_imgg() 若有錯誤時,不應roll back,會造成沒有包覆在原來transation
# Modify.........: No:MOD-8B0261 08/11/25 By claire asf-668 要考慮sma73的參數,不勾選時入庫數會檢核生產套數
# Modify.........: No:MOD-8B0305 08/12/01 By claire asf-819 調整判斷
# Modify.........: No:FUN-8C0084 08/12/22 By jan s_upimg相關改以 料倉儲批為參數傳入 ,不使用 ROWID
# Modify.........: No:CHI-910024 09/01/12 By claire asf-824 入庫日要與發料扣帳日比較,而非發料單據日
# Modify.........: No:CHI-910027 09/01/12 By claire asf-824 於新增時有控卡,但更改時應該也要控卡
# Modify.........: No:MOD-920168 09/02/12 By chenyu 單身FQC單號查詢時開窗q_qcf3中的條件應該加上OR qcf03 = ' '
# Modify.........: No:MOD-920158 09/02/12 By claire 工單報工會一對多,故條件加入工單
# Modify.........: No:MOD-920173 09/02/12 By claire 多單位新增imgg_file應先新增img_file
# Modify.........: No:FUN-910053 09/02/12 By jan sma74-->ima153
# Modify.........: No:MOD-930013 09/03/05 By Pengu tlf64未依工單的手冊編號(sfb97)給值
# Modify.........: No:FUN-930107 09/03/18 By lutingtingGP 5.2刪除資料是清除報工單的入庫單號
# Modify.........: No:FUN-930133 09/03/19 By kim ima513--->ima153
# Modify.........: No:FUN-930108 09/03/20 By zhaijie過賬時增加s_incchk檢查使用者是否有相應倉,儲的過賬權限
# Modify.........: No:FUN-930145 09/03/23 By lala 理由碼sfv44必須為生產原因 
# Modify.........: No:TQC-930157 09/03/30 By liuxqa 過單TQC-850009
# Modify.........: No:FUN-940076 09/04/14 By Carrier input/qbe時過濾掉從組合拆解產生的發料資料!
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.FUN-950021 09/05/20 By Carrier 組合拆解&將sasft620中的過帳段/審核段等拆出
# Modify.........: No:MOD-950119 09/05/26 By Pengu 1.聯產品料號,不會自動帶出該張FQC該顆聯產品料號可入量顯示於畫面
#                                                  2.核到聯產品入庫量大於可入量時，目前沒有提示訊息
#                                                  3.調整620_FQC()中的SQL條件
#                                                  4.進入單身,若直接點選數量,改為大於FQC該顆聯產品料號可入量
#                                                  5.修改時，原已key好的聯產品又會被變回原產品編號
# Modify.........: No:MOD-950192 09/05/26 By Pengu 在計算g_over_qty的值時，改用s_minp計算
# Modify.........: No.FUN-960007 09/06/04 By chenmoyan global檔內沒有定義rowid變量
# Modify.........: No.CHI-950010 09/06/17 By mike t620_check_inventory_qty()中所有RETURN 1之前都應該加上報錯                  
# Modify.........: No:MOD-950101 09/06/17 By mike 工單入庫時，并未檢查是否已重復Key In 入庫單                                 
# Modify.........: No.MOD-950133 09/06/17 By mike 同一工單料號報工報三個項次,而入庫也是同一工單料號入三個項次,在select srg05時>
# Modify.........: No:TQC-970201 09/07/21 By Carrier 單身"工單編號"為空時,清掉g_sfb的內容
# Modify.........: No.MOD-970244 09/07/27 By sabrina ima153有輸入數值，但在完工入庫時沒有做用，所以不能多入庫
# Modify.........: No.FUN-950056 09/07/28 By chenmoyan 去掉ima920
# Modify.........: No:MOD-950184 09/05/19 By chenyu 生成領料單時，sfp02和sfp03算法互換    
# Modify.........: No:FUN-980008 09/08/17 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No:MOD-980102 09/08/20 By Smapmin 單頭部門欄位的控管,AFTER INPUT時也要做此控管
# Modify.........: No:FUN-980043 09/08/21 By mike 請將abm-731錯誤訊息加上項次與料號
# Modify.........: No:FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960038 09/09/04 By chenmoyan 專案加上'結案'的判斷
# Modify.........: No:MOD-990121 09/10/08 By Smapmin 領料維護ACTION要區分為不同行業別的程式
# Modify.........: No.CHI-960022 09/10/15 By chenmoyan 預設單位一數量時，加上判斷，單位一數量為空或為1時，才預設
# Modify.........: No.CHI-960052 09/10/15 By chenmoyan 使用多單位，料件是單一單位或參考單位時，單位一的轉換率錯誤
# Modify.........: No:TQC-9A0120 09/10/23 By liuxqa 修改ROWID.
# Modify.........: No:TQC-9A0190 09/10/30 By Carrier 加上 ERROR处理机制
# Modify.........: No:TQC-9B0007 09/11/02 By Carrier fill()前,判断p_wc2是否为null
# Modify.........: No:CHI-9B0005 09/11/05 BY liuxqa substr 修改。
# Modify.........: No.FUN-970079 09/08/14 By jan 修改cl_outnam傳參方式
# Modify.........: No:MOD-970289 09/11/25 By sabrina 單身執行CONTROLO預設上一筆會無法INSERT
# Modify.........: No:MOD-960289 09/11/26 By sabrina 當分批FQC檢驗時第二次入庫時會出現錯誤訊息asf-675 
# Modify.........: No:MOD-970035 09/11/26 By sabrina 顯示可入庫量訊息的位數不夠，會造成用****呈現的情況
# Modify.........: No:FUN-9B0144 09/11/27 By jan 修改sfu01的開窗資料
# Modify.........: No:FUN-960130 09/12/09 By Cockroach PASS NO.
# Modify.........: No:TQC-9C0148 09/12/17 BY Carrier 取消过帐前,g_success设为'Y'
# Modify.........: No:MOD-9C0224 09/12/22 By Pengu 走FQC時不會依據FQC合格量控管數量
# Modify.........: No:FUN-9C0073 10/01/08 By chenls 程序精簡
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A20037 10/03/16 By lilingyu 替代碼sfa26加上"7,8,Z"的條件
# Modify.........: No:CHI-9A0022 10/03/20 By chenmoyan給s_lotin加一個參數:歸屬單號
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造 
#                                                 成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No:CHI-A40006 10/04/02 By Sarah 作廢/取消作廢時須將asft300的單身的入庫單號清空/寫入
# Modify.........: No:MOD-A40043 10/04/09 By Summer AND sfupost <> 'X'改成AND sfuconf <> 'X'
# Modify.........: No:MOD-A40051 10/04/13 By Summer 單據編號編碼原則改依輸入日期來編碼
# Modify.........: No:CHI-A40030 10/04/28 By Summer 領料產生,開窗讓user決定倉庫與儲位的default模式
# Modify.........: No:MOD-A50082 10/05/12 By Sarah 修正CHI-A40006,當入庫單沒有報工時作廢會出現9050的錯誤訊息
# Modify.........: No:FUN-A60027 10/06/22 by sunchenxu 製造功能優化-平行制程（批量修改）
# Modify.........: No:MOD-A60131 10/06/22 By Sarah 理由碼欄位不應因為參數設定不使用專案管理而隱藏
# Modify.........: No:MOD-A60141 10/06/22 By Sarah 在理由碼(sfv44)的後面增加顯示理由說明(azf03)
# Modify.........: No:FUN-A50066 10/06/24 By kim 平行工艺功能
# Modify.........: No.FUN-A60076 10/07/02 By vealxu 製造功能優化-平行制程
# Modify.........: No.FUN-A70125 10/07/27 By lilingyu 平行工藝整批修改
# Modify.........: No.FUN-A70138 10/07/29 By jan 調整CREATE TEMP TABLE 寫法
# Modify.........: No:MOD-A80060 10/08/09 By sabrina 完工入庫時可依使用者輸入的入庫單位入庫 
# Modify.........: No:TQC-A80175 10/08/30 By lilingyu 點擊“批序號查詢”,程序畫面宕出
# Modify.........: No:MOD-A80079 10/08/12 By sabrina 單身按"產生"action時所產生的入庫應要check是否大於最小發料套數 
# Modify.........: No:FUN-A80102 10/09/16 By kim GP5.25號機管理
# Modify.........: No.FUN-A90035 10/09/21 bY vealxu sfu08的開窗和欄位檢查，加上sfd.確認碼='Y'
# Modify.........: No:MOD-A90152 10/09/23 By sabrina 工單有走製程，則入庫量要<=終站轉出量
# Modify.........: No:FUN-AA0055 10/10/21 By zhangll 控制只能查询和选择属于该营运中心的仓库
# Modify.........: No:FUN-A40022 10/10/25 By jan 當料件為批號控管,則批號必須輸入
# Modify.........: No.FUN-AA0059 10/11/01 By chenying 料號開窗控管
# Modify.........: No.FUN-AA0059 10/11/02 By huangtao 修改料號AFTER FIELD的管控
# Modify.........: No.FUN-AB0054 10/11/12 By zhangll 倉庫營運中心權限控管審核段控管
# Modify.........: No.TQC-AB0097 10/12/07 By yinhy 點擊“領料生成”功能鈕，系統報錯“(-391)ins sfs無法將null插入欄的欄名稱
# Modify.........: No.TQC-AC0293 10/12/20 By vealxu sfp01的開窗/檢查要排除smy73='Y'的單據
# Modify.........: No:TQC-AC0347 10/12/23 By zhangll 修正No.TQC-AC0293导致asft620錄入時開窗選擇單別，返回的只有一個字符
# Modify.........: No:TQC-AC0277 10/12/24 By jan 重新抓取最終制程
# Modify.........: No:CHI-AC0023 11/01/03 By Summer 消耗性料件增加考慮完工誤差率
# Modify.........: No:MOD-B10184 11/01/24 By sabrina 當為多單位且是參考單位時，若料號的單位管製為參考單位/單一單位則sfv30不允許修改
# Modify.........: No:MOD-B20122 11/02/22 By sabrina 要將值DISPLAY到畫面上
# Modify.........: No.FUN-B20086 11/03/01 By chenmoyan 給PBI NO.加開窗
# Modify.........: No:FUN-A80128 11/03/09 By Mandy EasyFlow整合功能
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-B30170 11/04/11 By suncx 單身增加批序號明細頁簽
# Modify.........: No.FUN-B40029 11/04/13 By xianghui 修改substr
# Modify.........: No:FUN-AB0001 11/04/25 By Lilan 因asfi510 新增EasyFlow整合功能影響INSERT INTO sfp_file
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-A70095 11/06/14 By lixh1 撈取報工單(shb_file)的所有處理作業,必須過濾是已確認的單據
# Modify.........: No.TQC-B60082 11/06/15 By xianghui 添加校驗申請人欄位
# Modify.........: No.TQC-B60154 11/06/17 By jan 當光標在【工單號碼】欄位時，點擊“依PBI查詢工單號碼”按鈕，系統無資料顯示
# Modify.........: No.FUN-B20089 11/07/10 By lixh1 打完PBI No.自動帶單身工單編號
# Modify.........: No.MOD-B70176 11/07/18 By Carrier CONTROLO时,数量DEFAULT为0
# Modify.........: No.FUN-B70061 11/07/18 By jason ICD功能修改，增加母批、DATECODE欄位
# Modify.........: No.FUN-B70074 11/07/26 By lixh1 增加行業別TABLE(sfsi_file)的處理
# Modify.........: No:FUN-B80086 11/08/09 By Lujh 模組程序撰寫規範修正
# Modify.........: No:TQC-B80264 11/09/06 By houlia 產生領料單時判斷應發量跟發料最少量
# Modify.........: No.FUN-B50096 11/09/19 By lixh1 所有入庫程式應該要加入可以依料號設置"批號(倉儲批的批)是否為必要輸入欄位"的選項
# Modify.........: NO:MOD-BA0106 11/11/07 By johung s_lotin_del拿掉transaction，相關程式應調整
# Modify.........: No.MOD-BB0061 11/11/08 By destiny  多次产生领料单程序会荡出
# Modify.........: No.FUN-BA0051 11/11/10 By jason 一批號多DATECODE功能
# Modify.........: No.MOD-BB0104 11/11/11 By suncx 進入修改單身前獲取數據庫最新單頭狀態
# Modify.........: No:MOD-B40113 11/11/22 By Vampire 在新增庫存明細前應先判斷若sfv06、sfv07為null則給空白
# Modify.........: No:MOD-B40243 11/11/22 By Vampire 當入庫量超打時，入庫數量會變成負數
# Modify.........: No.MOD-B80014 11/11/22 By Vampire 在抓sfp03時應多判斷sfb04='Y'
# Modify.........: No:FUN-BB0086 11/12/07 By tanxc 增加數量欄位小數取位
# Modify.........: No:FUN-BB0084 11/12/14 By lixh1 增加數量欄位小數取位(sfs_file)
# Modify.........: No:TQC-BC0155 12/01/10 By destiny 生成领料单单号开窗只开单据形态为'4'的单据
# Modify.........: No.TQC-B90236 12/01/11 By zhuhao 原執行s_lotin_del程式段Mark，改為s_lot_del，傳入參數不變
#                                                   原於_r()中，使用FOR迴圈執行s_del_rvbs程式段Mark，改為s_lot_del
#                                                   原BEFORE DELETE中s_del_rvbs程式段Mark，改為s_lot_del，傳入參數同第1點
#                                                   原執行s_lotin程式段，改為s_mod_lot，於第6,7,8個參數傳入倉儲批，最後多傳入1，其餘傳入參數不變
# Modify.........: No.MOD-C10064 12/01/08 By ck2yuan 如果為料消耗性材料且被完全取替代，就不應該出現在領料單
# Modify.........: No.FUN-BC0104 12/01/14 By xujing QC料件判定,判定結果編碼、結果說明、項次 3個欄位

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C20027 12/02/04 By Abby EF功能調整-客戶不以整張單身資料送簽問題
# Modify.........: No.MOD-B80329 12/02/09 By Vampire FUNCTION t620_sfb01()的錯誤訊息(g_errno) 應 call cl_err
# Modify.........: No.FUN-BC0109 12/02/09 By jason for ICD Datecode回寫多筆時即以","做分隔
# Modify.........: No:FUN-C20048 12/02/10 By tanxc 增加數量欄位小數取位
# Modify.........: No.TQC-BB0236 12/02/13 By Carrier 单身修改状态下,工单没有做更改,完工数量sfv09卡不住,因为g_over_qty为NULL
# Modify.........: No.TQC-BB0159 12/02/13 By destiny 新增一笔资料再点新增进入单身时会报错
# Modify.........: No.TQC-C10126 12/02/17 By SunLM 修正發料套數管控的錯誤提示,暫時mark掉
# Modify.........:                                 如果有多個工藝序,每個工藝序都有bonus的話,最終入庫數量肯定會大於發料套數
# Modify.........: No.TQC-C30013 12/03/01 By xujing 增加判定結果編碼性質為'2'的情況
# Modify.........: No:MOD-C30084 12/03/09 by destiny 当单身入库数量已存在且大于0时,修改工单单号后应重新检查入库数量
# Modify.........: No:FUN-C30293 12/03/29 By Abby  執行[單身],按"確定",狀況碼才能變成0.開立
# Modify.........: No:CHI-C30118 12/04/06 By Sakura 參考來源單號CHI-C30106,批序號維護修改
# Modify.........: No.FUN-C40016 12/04/06 By xianghui 單據作廢時不須清空QC料件判定新增的那幾個欄位,重新回寫已轉入庫量即可，取消作廢時檢查數量是否合理
# Modify.........: No.FUN-C30300 12/04/09 By bart  倉儲批開窗需顯示參考單位數量
# Modify.........: No:FUN-C30302 12/04/13 By bart 修改 s_icdin 回傳值
# Modify.........: No:MOD-C50012 12/05/04 By Elise 將aim-400的判斷搬到IF外先做
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:TQC-C60028 12/06/04 By bart 只要是ICD行業 倉儲批開窗改用q_idc
# Modify.........: No:MOD-C60053 12/06/06 By ck2yuan 工單開窗查詢改為q_sfb021 (排除 拆件式工單)
# Modify.........: No:TQC-C60020 12/06/14 By bart datecode可維護
# Modify.........: No.MOD-B90063 12/06/18 By Elise 在進FUNCTION t620_sfb01時應將g_err變數清空
# Modify.........: No.MOD-B90107 12/06/18 By ck2yuan 當工單是走製程時不需考慮最小套數
# Modify.........: No.TQC-C60148 12/06/19 By fengrui 添加單身數組更新 
# Modify.........: No:MOD-C60203 12/06/28 By ck2yuan 產生領料單單身預設替代率應給 1 非NULL
# Modify.........: No:FUN-C30085 12/07/05 By nanbing CR改串GR
# Modify.........: No:FUN-C70014 12/07/16 By suncx 新增sfs014
# Modify.........: No:TQC-C70109 12/07/17 By fengrui 若事後扣帳,則控卡入庫日期不可小於工單開立日期
# Modify.........: No.MOD-BA0192 12/07/19 By ck2yuan 走製程時也有可能分批入庫
# Modify.........: No:MOD-C70211 12/07/19 By ck2yuan 入庫誤差率應該是以工單產生料的誤差率為主,避免聯產品無法輸入
# Modify.........: No:FUN-C80030 12/08/10 By fengrui 添加批序號依參數sma95隱藏
# Modify.........: No:TQC-C50227 12/08/07 By SunLM  組合拆解工單可以查詢,但不可取消審核和取消過帳
# Modify.........: No:FUN-C70037 12/08/16 By lixh1 CALL s_minp增加傳入日期參數
# Modify.........: No:TQC-C90029 12/09/05 By chenjing 修改挑選不勾選時入庫數量情況問題
# Modify.........: No.TQC-C90055 12/09/11 By chenjing 點擊“領料生成”功能鈕，系統報錯“(-391)ins sfs無法將null插入欄的欄名稱
# Modify.........: No.TQC-C90071 12/09/13 By chenjing 修改點擊“領料生成”功能鈕領料單生產以後報錯問題
# Nodify.........: No.TQC-C90076 12/09/16 By chenjing 增加查詢狀態下，【資料建立者】、【資料建立者部門】可以下查詢條件。
# Modify.........: No:CHI-CA0011 12/11/09 By Elise 排除拆件式工單之FQC單據
# Modify.........: No.FUN-CB0014 12/11/12 By xujing 增加資料清單
# Modify.........: No:MOD-CB0188 12/11/23 By Elise AFTER FIELD sfv04判斷 ima903之前增加判斷
# Modify.........: No:MOD-CB0031 12/11/23 By Elise 入庫單且為重工工單，不控卡axm-396
# Modify.........: No.CHI-C80041 12/11/28 By bart 取消單頭資料控制
# Modify.........: No.FUN-CB0087 12/12/14 By fengrui 倉庫單據理由碼改善
# Modify.........: No:MOD-CB0170 13/01/07 By Elise 修正輸入PBI後,單身新增無法正常顯示的問題
# Modify.........: No:CHI-CA0070 13/01/08 By Elise 過帳日期,不可早於工單的開單日期
# Modify.........: No:MOD-CC0233 13/01/08 By Elise 修改CHI-CA0070於修改段且單身有資料時控卡
# Modify.........: No:MOD-D10050 13/01/09 By bart 修改MOD-B40243判斷式
# Modify.........: No.FUN-CC0013 13/01/11 By Lori aqci106移除性質3.驗退/重工(qcl05=3)選項
# Modify.........: No:MOD-D10117 13/01/17 By suncx 調用自動編號函數時傳如參數錯誤，可能導致無法正確編號
# Modify.........: No:MOD-D10146 13/01/16 By bart 扣除最終站的轉出數量
# Modify.........: No:TQC-CC0133 13/01/25 By SunLM 組合工單完工入庫可以查詢，但不可刪除，取消審核等操作
# Modify.........: No.TQC-D10084 13/01/28 By xujing  資料清單頁簽不可點擊單身按鈕
# Modify.........: No:TQC-D10099 13/02/01 By Lori 訊息顯示抓取zaa的部份,改抓ze
# Modify.........: No:CHI-D20010 13/02/19 By minpp 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No.FUN-D20060 13/02/22 By yangtt 設限倉庫/儲位控卡
# Modify.........: No:MOD-C80170 13/03/07 By Alberti 若無產生領料單(因錯誤),單頭就不須回寫領料單號,因也未產生
# Modify.........: No:MOD-C70307 13/03/07 By Alberti 在進入數量前重抓g_min_set與tmp_qry 
# Modify.........: No:MOD-C80187 13/03/08 By Alberti 領料不應考慮發料批量,還原MOD-850193之修改
# Modify.........: No:MOD-D30197 13/03/22 By bart sma73沒勾時,誤差量也要考慮誤差率
# Modify.........: No:CHI-D40003 13/04/01 By bart 取消作廢需控卡關帳日期
# Modify.........: No.DEV-D30059 13/04/01 By Nina 批序號相關程式,當料件使用條碼時(ima930 = 'Y'),輸入資料時,
#                                                 不要自動開批序號的Key In畫面(s_mod_lot)
# Modify.........: No:FUN-D40030 13/04/08 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:MOD-D40122 13/04/17 By bart 批號預帶空白
# Modify.........: No:FUN-D60054 13/06/13 By lixh1 倒扣料完工入庫時入庫數量給預設值
# Modify.........: No:MOD-D60129 13/06/17 By suncx 过數量欄位時，提示最小套數等數量的提示信息錯誤
# Modify.........: No:FUN-D40103 13/05/09 By lixh1 增加儲位有效性檢查
# Modify.........: No:TQC-D50124 13/05/28 By lixh1 拿掉儲位有效性檢查
# Modify.........: No:TQC-D50127 13/05/30 By lixh1 儲位為空則給空格
# Modify.........: No.TQC-D40080 13/08/14 By dongsz 入庫數量的控卡調整
# Modify.........: No.TQC-D40089 13/08/14 By dongsz 錄入FQC單帶出入庫數量調整

DATABASE ds

GLOBALS "../../config/top.global"
GLOBALS "../4gl/sasft620.global"

#FUN-A80128--mark---str--
#將變數挪至sasft620.global
#DEFINE g_ima918  LIKE ima_file.ima918  #No:FUN-810036
#DEFINE g_ima921  LIKE ima_file.ima921  #No:FUN-810036
#DEFINE l_fac     LIKE img_file.img34   #No:FUN-860045
#FUN-A80128--mark---end--
DEFINE l_r       LIKE type_file.chr1   #No:FUN-860045
DEFINE g_rg1     LIKE type_file.chr1   #CHI-A40030 add
DEFINE g_ima35   LIKE ima_file.ima35   #CHI-A40030 add
DEFINE g_ima36   LIKE ima_file.ima36   #CHI-A40030 add
#DEFINE g_t1      LIKE type_file.chr1   #TQC-AC0293 add   #Mark No:TQC-AC0347
DEFINE g_t1      LIKE smy_file.smyslip   #TQC-AC0293 add   #Add No:TQC-AC0347
DEFINE g_laststage  LIKE type_file.chr1  #FUN-A80128 add
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
                END RECORD
#FUN-CB0014---add---str---
DEFINE g_sfu_l  DYNAMIC ARRAY OF RECORD
                  sfu01   LIKE sfu_file.sfu01,
                  smydesc LIKE smy_file.smydesc,
                  sfu14   LIKE sfu_file.sfu14,
                  sfu02   LIKE sfu_file.sfu02,
                  sfu04   LIKE sfu_file.sfu04,
                  gem02   LIKE gem_file.gem02,
                  sfu08   LIKE sfu_file.sfu08,
                  sfu09   LIKE sfu_file.sfu09,
                  sfu16   LIKE sfu_file.sfu16,
                  gen02   LIKE gen_file.gen02,
                  sfu07   LIKE sfu_file.sfu07,
                  sfuconf LIKE sfu_file.sfuconf,
                  sfupost LIKE sfu_file.sfupost,
                  sfu15   LIKE sfu_file.sfu15,
                  sfumksg LIKE sfu_file.sfumksg
                END RECORD
DEFINE g_rec_b2           LIKE type_file.num5,
       l_ac2              LIKE type_file.num5
DEFINE g_action_flag      STRING
DEFINE   w    ui.Window
DEFINE   f    ui.Form
DEFINE   page om.DomNode
#FUN-CB0014---add---end---
DEFINE g_rec_b1           LIKE type_file.num5,   #單身二筆數 ##FUN-B30170
       l_ac1              LIKE type_file.num5    #目前處理的ARRAY CNT  #FUN-B30170
#FUN-B30170 add -end---------------------------
DEFINE g_sfv30_t     LIKE sfv_file.sfv30       #No.FUN-BB0086
DEFINE g_sfv33_t     LIKE sfv_file.sfv33       #No.FUN-BB0086

FUNCTION sasft620(p_argv,p_argv2,p_argv3)   #No:FUN-630010
DEFINE  p_argv   LIKE type_file.chr1,   #No:FUN-680121 CHAR(1)   #No.FUN-6A0090
        p_argv2  LIKE sfu_file.sfu01,   #bugno:6963
        p_argv3  STRING                 #No:FUN-630010

   WHENEVER ERROR CALL cl_err_msg_log  #No.TQC-9A0190


    CALL t620_def_form()

    LET g_forupd_sql = "SELECT * FROM sfu_file WHERE sfu01 = ? FOR UPDATE"  #No.TQC-9A0120 mod
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t620_cl CURSOR FROM g_forupd_sql

    LET g_argv = p_argv
    LET g_argv2 = p_argv2    #bugno:6963
    LET g_argv3 = p_argv3    #No:FUN-630010
    #FUN-A80128--add--str---
    IF fgl_getenv('EASYFLOW') = "1" THEN    #判斷是否為簽核模式
       LET g_argv2 = aws_efapp_wsk(1)       #取得單號
    END IF                                 
    #FUN-A80128--add--end---
    CALL t620_set_form_default() #FUN-5C0114
    IF g_argv = '2' THEN LET u_sign=-1 ELSE LET u_sign=1 END IF
    SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'

    #FUN-A80128---add---str--
    CALL aws_efapp_toolbar()    #建立簽核模式時的 toolbar icon 
    #FUN-A80128---add---end--

   IF cl_null(g_argv2) THEN    #bugno:6963
   ELSE
      CASE g_argv3
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL t620_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL t620_a()
            END IF
         #FUN-A80128--add---str---
         WHEN "efconfirm"
            LET g_action_choice = "efconfirm"
            CALL t620_q()
            CALL t620sub_y_chk(g_argv,g_sfu.sfu01,g_action_choice) #CALL 原確認的 check 段 #CHI-C30118 add g_action_choice 
            IF g_success = 'Y' THEN
                CALL t620sub_y_upd(g_sfu.sfu01,g_action_choice,FALSE)
                CALL t620sub_refresh(g_sfu.sfu01) RETURNING g_sfu.*
                CALL t620_show()
            END IF
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
            EXIT PROGRAM
         #FUN-A80128--add---end---

         WHEN "stock_post"  #自動過帳
            LET g_action_choice = ""  #M化背景處理,自動過帳
            LET g_sfu.sfu01=g_argv2
            #str----add by guanyao160928
            SELECT smaud03 INTO g_sma.smaud03 FROM sma_file WHERE sma00 ='0'
            IF g_sma.smaud03 = 'Y' THEN 
               CALL cl_err('','csf-087',1)
               EXIT PROGRAM
            END IF 
            #end----add by guanyao160928
            CALL t620sub_y_chk(g_argv,g_sfu.sfu01,g_action_choice) #CHI-C30118 add g_action_choice
            IF g_success = 'Y' THEN
               CALL t620sub_y_upd(g_sfu.sfu01,g_action_choice,FALSE)
            END IF
            CALL t620sub_refresh(g_sfu.sfu01) RETURNING g_sfu.*
            IF g_success = "Y" THEN
               CALL t620sub_s(g_sfu.sfu01,g_argv,FALSE,g_action_choice)
               IF NOT cl_null(g_action_choice) AND g_success = 'Y' THEN  #FUN-840012
                   SELECT COUNT(*) INTO g_cnt FROM sfv_file,sfa_file
                    WHERE sfv01 = g_sfu.sfu01
                      AND sfv11 = sfa01 AND sfa11 = 'E'
                   IF g_cnt > 0 THEN 
                     CALL t620_k() 
                   END IF
               END IF
               CALL t620sub_refresh(g_sfu.sfu01) RETURNING g_sfu.*
               CALL t620_show() #FUN-A80128 add
            END IF
            IF NOT cl_null(g_action_choice) AND g_success = 'Y' THEN  #FUN-840012
                SELECT COUNT(*) INTO g_cnt FROM sfv_file,sfa_file
                 WHERE sfv01 = g_sfu.sfu01
                   AND sfv11 = sfa01 AND sfa11 = 'E'
                IF g_cnt > 0 THEN 
                  CALL t620_k() 
                END IF
            END IF
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
            EXIT PROGRAM
         OTHERWISE
            CALL t620_q()
      END CASE
   END IF

   #FUN-A80128---add---str---
   ##傳入簽核模式時不應執行的 action 清單
   CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, undo_void,                            #CHI-D20010 add-undo_void                             confirm, undo_confirm,easyflow_approval,stock_post,undo_post,gen_mat_wtdw,maint_mat_wtdw,aic_s_icdin")  
         RETURNING g_laststage
   #FUN-A80128---add---end---

   CALL t620_menu()
END FUNCTION

FUNCTION t620_cs()
DEFINE  lc_qbe_sn LIKE    gbm_file.gbm01    #No:FUN-580031  HCN
    CLEAR FORM                             #清除畫面
    CALL g_sfv.clear()
    IF cl_null(g_argv2) THEN    #bugno:6963
       IF (g_argv='1') OR (g_argv='3') THEN  #FUN-5C0114 add "OR (g_argv='3')"
          CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_sfu.* TO NULL    #No.FUN-750051
          CONSTRUCT BY NAME g_wc ON
             #sfu01,sfu02,sfu04,sfu08,sfu09,sfu06,sfu05,sfu07,sfuconf, #FUN-660137  #FUN-810045
             sfu01,sfu14,sfu02,sfu04,sfu08,sfu09,sfu16,sfu06,sfu07,sfuconf, #FUN-660137         #FUN-810045  #FUN-860069 #FUN-A80128 add sfu16
             sfupost,sfu15,sfumksg,sfuuser,sfugrup,sfumodu,sfudate,sfuoriu,sfuorig #FUN-A80128 add sfu15,sfumksg #TQC-C90076 add sfuoriu,sfuorig
             ,sfuud01,sfuud02,sfuud03,sfuud04,sfuud05,
             sfuud06,sfuud07,sfuud08,sfuud09,sfuud10,
             sfuud11,sfuud12,sfuud13,sfuud14,sfuud15

               BEFORE CONSTRUCT
                  CALL cl_qbe_init()


             ON ACTION controlp
               CASE WHEN INFIELD(sfu01) #查詢單据
                         CALL cl_init_qry_var()
                         LET g_qryparam.state = "c"
                         LET g_qryparam.form  = "q_sfu"
                         ##組合拆解的完工入庫單不顯示出來!
                        #LET g_qryparam.where = " substr(sfu01,1,",g_doc_len,") NOT IN (SELECT smy71 FROM smy_file WHERE smy71 IS NOT NULL) "
                        # LET g_qryparam.where = " sfu01[1,",g_doc_len,"] NOT IN (SELECT smy71 FROM smy_file WHERE smy71 IS NOT NULL) " #FUN-B40029 #TQC-C50227
                         CALL cl_create_qry() RETURNING g_qryparam.multiret
                         DISPLAY g_qryparam.multiret TO sfu01
                         NEXT FIELD sfu01

                    WHEN INFIELD(sfu04)
                         CALL cl_init_qry_var()
                         LET g_qryparam.state = "c"
                         LET g_qryparam.form  = "q_gem"
                         CALL cl_create_qry() RETURNING g_qryparam.multiret
                         DISPLAY g_qryparam.multiret TO sfu04
                         NEXT FIELD sfu04
 

                    WHEN INFIELD(sfu06)
                         CALL cl_init_qry_var()
                         LET g_qryparam.state= "c"
                         LET g_qryparam.form ="q_pja2"  #FUN-810045
                         CALL cl_create_qry() RETURNING g_qryparam.multiret
                         DISPLAY g_qryparam.multiret TO sfu06
                         NEXT FIELD sfu06
#FUN-B20086 --Begin
                    WHEN INFIELD(sfu08)
                         CALL cl_init_qry_var()
                         LET g_qryparam.state= "c"
                         LET g_qryparam.form ="q_sfu08"
                         CALL cl_create_qry() RETURNING g_qryparam.multiret
                         DISPLAY g_qryparam.multiret TO sfu08
                         NEXT FIELD sfu08
#FUN-B20086 --End
                    WHEN INFIELD(sfu09)   #MOD-4A0252
                         CALL cl_init_qry_var()
                         LET g_qryparam.state= "c"
                         IF g_argv='3' THEN
                            LET g_qryparam.form ="q_sfp"
                            LET g_qryparam.arg1='C'
                         ELSE
                            LET g_qryparam.form ="q_sfp1"
                         END IF
                         CALL cl_create_qry() RETURNING g_qryparam.multiret
                         DISPLAY g_qryparam.multiret TO sfu09
                         NEXT FIELD sfu09
                   #FUN-A80128 add str ----             
                    WHEN INFIELD(sfu16) #申請人員
                       CALL cl_init_qry_var() 
                       LET g_qryparam.form = "q_gen" 
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret 
                       DISPLAY g_qryparam.multiret TO sfu16
                       NEXT FIELD sfu16
                   #FUN-A80128 add end ---- 
                 END CASE

             ON IDLE g_idle_seconds
                CALL cl_on_idle()
                CONTINUE CONSTRUCT
                ON ACTION qbe_select
                   CALL cl_qbe_list() RETURNING lc_qbe_sn
                   CALL cl_qbe_display_condition(lc_qbe_sn)


          END CONSTRUCT

       ELSE
          CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
          CONSTRUCT BY NAME g_wc ON
             #sfu01,sfu02,sfu04,sfu05,sfu06,sfu07,sfu08,sfu09,sfuconf, #FUN-660137   #FUN-810045
             sfu01,sfu14,sfu02,sfu04,sfu06,sfu07,sfu08,sfu09,sfuconf, #FUN-660137          #FUN-810045  #FUN-860069
             sfupost,sfuuser,sfugrup,sfumodu,sfudate,sfuoriu,sfuorig      #TQC-C90076 add sfuoriu,sfuorig
 
                  BEFORE CONSTRUCT
                  CALL cl_qbe_init()

             ON ACTION controlp
               CASE WHEN INFIELD(sfu01) #查詢單据
                         CALL cl_init_qry_var()
                         LET g_qryparam.state = "c"
                         LET g_qryparam.form  = "q_sfu"
                         ##組合拆解的完工入庫單不顯示出來!
                        #LET g_qryparam.where = " substr(sfu01,1,",g_doc_len,") NOT IN (SELECT smy71 FROM smy_file WHERE smy71 IS NOT NULL) "
                         #LET g_qryparam.where = " sfu01[1,",g_doc_len,"] NOT IN (SELECT smy71 FROM smy_file WHERE smy71 IS NOT NULL) "      #FUN-B40029 #TQC-C50227
                         CALL cl_create_qry() RETURNING g_qryparam.multiret
                         DISPLAY g_qryparam.multiret TO sfu01
                         NEXT FIELD sfu01

                    WHEN INFIELD(sfu04)
                         CALL cl_init_qry_var()
                         LET g_qryparam.state = "c"
                         LET g_qryparam.form  = "q_gem"
                         CALL cl_create_qry() RETURNING g_qryparam.multiret
                         DISPLAY g_qryparam.multiret TO sfu04
                         NEXT FIELD sfu04
 

                    WHEN INFIELD(sfu06)
                         CALL cl_init_qry_var()
                         LET g_qryparam.state= "c"
                         LET g_qryparam.form ="q_pja2"   #FUN-810045
                         CALL cl_create_qry() RETURNING g_qryparam.multiret
                         DISPLAY g_qryparam.multiret TO sfu06
                         NEXT FIELD sfu06
#FUN-B20086 --Begin
                    WHEN INFIELD(sfu08)
                         CALL cl_init_qry_var()
                         LET g_qryparam.state= "c"
                         LET g_qryparam.form ="q_sfu08"
                         CALL cl_create_qry() RETURNING g_qryparam.multiret
                         DISPLAY g_qryparam.multiret TO sfu08
                         NEXT FIELD sfu08
#FUN-B20086 --End
                 END CASE

             ON IDLE g_idle_seconds
                CALL cl_on_idle()
                CONTINUE CONSTRUCT
 
                ON ACTION qbe_select
                   CALL cl_qbe_list() RETURNING lc_qbe_sn
                   CALL cl_qbe_display_condition(lc_qbe_sn)
 
          END CONSTRUCT

       END IF
       IF INT_FLAG THEN RETURN END IF
    ELSE
        LET g_wc=" sfu01='",g_argv2,"'" #No.MOD-4A0014
    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('sfuuser', 'sfugrup')

    ##組合拆解的完工入庫單不顯示出來!
    #LET g_wc = g_wc CLIPPED, #TQC-C50227
   #               " AND sfu01[1,",g_doc_len,"] NOT IN (SELECT smy71 FROM smy_file WHERE smy71 IS NOT NULL) "  #CHI-9B0005 mod

    IF cl_null(g_argv2) THEN    #bugno:6963
       CONSTRUCT g_wc2 ON sfv03,sfv17,sfv11,
                          sfv46,qcl02,sfv47,          #FUN-BC0104
                          sfv04,sfv08,sfv05,   
                          sfv06,sfv07,sfv09,sfv33,sfv34,
                          sfv35,sfv30,sfv31,sfv32,
                          sfv41,sfv42,sfv43,sfv44,    #FUN-810045 add
                          sfv12,sfv16,
                          sfv930  #FUN-670103
                          ,sfvud01,sfvud02,sfvud03,sfvud04,sfvud05,
                          sfvud06,sfvud07,sfvud08,sfvud09,sfvud10,
                          sfvud11,sfvud12,sfvud13,sfvud14,sfvud15
               FROM s_sfv[1].sfv03, s_sfv[1].sfv17, s_sfv[1].sfv11,  #FUN-550085
                    s_sfv[1].sfv46, s_sfv[1].qcl02, s_sfv[1].sfv47,  #FUN-BC0104 
                    s_sfv[1].sfv04, s_sfv[1].sfv08, s_sfv[1].sfv05,
                    s_sfv[1].sfv06, s_sfv[1].sfv07, s_sfv[1].sfv09,
                    s_sfv[1].sfv33, s_sfv[1].sfv34, s_sfv[1].sfv35,
                    s_sfv[1].sfv30, s_sfv[1].sfv31, s_sfv[1].sfv32,
                    s_sfv[1].sfv41, s_sfv[1].sfv42, s_sfv[1].sfv43, s_sfv[1].sfv44,  #FUN-810045 add
                    s_sfv[1].sfv12, s_sfv[1].sfv16, s_sfv[1].sfv930  #FUN-670103
                    ,s_sfv[1].sfvud01,s_sfv[1].sfvud02,s_sfv[1].sfvud03,s_sfv[1].sfvud04,s_sfv[1].sfvud05,
                    s_sfv[1].sfvud06,s_sfv[1].sfvud07,s_sfv[1].sfvud08,s_sfv[1].sfvud09,s_sfv[1].sfvud10,
                    s_sfv[1].sfvud11,s_sfv[1].sfvud12,s_sfv[1].sfvud13,s_sfv[1].sfvud14,s_sfv[1].sfvud15
                BEFORE CONSTRUCT
                   CALL cl_qbe_display_condition(lc_qbe_sn)
 
        ON ACTION controlp
           CASE WHEN INFIELD(sfv11)    #工單單號
#                    CALL cl_init_qry_var()                    #FUN-AA0059 mark
#                    LET g_qryparam.state= "c"                 #FUN-AA0059 mark
                     IF g_argv<>'3' THEN #FUN-5C0114
                        CALL cl_init_qry_var()                 #FUN-AA0059 add 
                        LET g_qryparam.state= "c"              #FUN-AA0059 add 
                       #LET g_qryparam.form ="q_sfb02"         #MOD-C60053 mark 
                        LET g_qryparam.form ="q_sfb021"        #MOD-C60053 add
                        LET g_qryparam.construct = "Y"
                        LET g_qryparam.arg1 = 234567
                        ##組合拆解的工單發料不顯示出來!
                       #LET g_qryparam.where = " substr(sfb01,1,",g_doc_len,") NOT IN (SELECT smy69 FROM smy_file WHERE smy69 IS NOT NULL) "
                       # LET g_qryparam.where = " sfb01[1,",g_doc_len,"] NOT IN (SELECT smy69 FROM smy_file WHERE smy69 IS NOT NULL) "   #FUN-B40029 #TQC-C50227
                        CALL cl_create_qry() RETURNING g_qryparam.multiret   #FUN-AA0059 add
                     ELSE
#                       LET g_qryparam.form ="q_ima"                 #FUN-AA0059 mark
                        CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret #FUN-AA0059 add
                     END IF
#                    CALL cl_create_qry() RETURNING g_qryparam.multiret  #FUN-AA0059 mark
                     DISPLAY g_qryparam.multiret TO sfv11
                     NEXT FIELD sfv11
                WHEN INFIELD(sfv17)    #FQC單號
                     CALL cl_init_qry_var()
                     LET g_qryparam.state= "c"
                     IF g_argv<>'3' THEN #FUN-5C0114
                        LET g_qryparam.construct = "Y"
                        LET g_qryparam.form ="q_qcf5"   #No:MOD-920168 add
                     ELSE
                        LET g_qryparam.form ="q_srf"
                        LET g_qryparam.where ="srf07='1'" #FUN-670103
                     END IF
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO sfv17
                     NEXT FIELD sfv17
                WHEN INFIELD(sfv05)
                    #Mod No.FUN-AA0055
                    #CALL cl_init_qry_var()
                    #LET g_qryparam.state= "c"
                    #LET g_qryparam.form ="q_imd"
                    #LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
                    #CALL cl_create_qry() RETURNING g_qryparam.multiret
                     CALL q_imd_1(TRUE,TRUE,"","",g_plant,"","")  #只能开当前门店的
                          RETURNING g_qryparam.multiret
                    #End Mod No.FUN-AA0055
                     DISPLAY g_qryparam.multiret TO sfv05
                     NEXT FIELD sfv05
                WHEN INFIELD(sfv04) #聯產品料號 NO:6872
#FUN-AA0059---------mod------------str-----------------
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.form     = "q_ima"
#                   LET g_qryparam.state    = "c"
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                    CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end------------------
                    DISPLAY g_qryparam.multiret TO sfv04
                    NEXT FIELD sfv06
               WHEN INFIELD(sfv06)
                   #Mod No.FUN-AA0055
                   #CALL cl_init_qry_var()
                   #LET g_qryparam.form     = "q_ime"
                   #LET g_qryparam.state    = "c"
                   #CALL cl_create_qry() RETURNING g_qryparam.multiret
                    CALL q_ime_1(TRUE,TRUE,"","","",g_plant,"","","")
                         RETURNING g_qryparam.multiret
                   #End Mod No.FUN-AA0055
                    DISPLAY g_qryparam.multiret TO sfv06
                    NEXT FIELD sfv06
               WHEN INFIELD(sfv07)
                    CALL cl_init_qry_var()
                   #Mod No.FUN-AA0055
                   #LET g_qryparam.form     = "q_ime"
                    LET g_qryparam.form     = "q_sfv07"
                   #End Mod No.FUN-AA0055
                    LET g_qryparam.state    = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO sfv07
                    NEXT FIELD sfv07
               WHEN INFIELD(sfv33)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gfe"
                  LET g_qryparam.default1 = g_sfv[1].sfv33
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sfv33
                  NEXT FIELD sfv33
               WHEN INFIELD(sfv30)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gfe"
                  LET g_qryparam.default1 = g_sfv[1].sfv30
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sfv30
                  NEXT FIELD sfv30
               WHEN INFIELD(sfv930)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_gem4"
                  LET g_qryparam.state = "c"   #多選
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sfv930
                  NEXT FIELD sfv930
                WHEN INFIELD(sfv41) #專案
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pja2"  
                  LET g_qryparam.state = "c"   #多選
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sfv41
                  NEXT FIELD sfv41
                WHEN INFIELD(sfv42)  #WBS
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pjb4"
                  LET g_qryparam.state = "c"   #多選
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sfv42
                  NEXT FIELD sfv42
                WHEN INFIELD(sfv43)  #活動
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pjk3"
                  LET g_qryparam.state = "c"   #多選
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sfv43
                  NEXT FIELD sfv43
                  
                WHEN INFIELD(sfv44)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_azf01a"     #FUN-930145
                  LET g_qryparam.state = "c"   #多選
                  LET g_qryparam.arg1 = 'C'           #FUN-930145
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sfv44
                  NEXT FIELD sfv44

                #FUN-BC0104---add---str
                WHEN INFIELD(sfv46)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_qco1"     
                  LET g_qryparam.state = "c"   
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sfv46
                  NEXT FIELD sfv46

                WHEN INFIELD(sfv47)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_qco1"    
                  LET g_qryparam.state = "c"   
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sfv47
                  NEXT FIELD sfv47
                #FUN-BC0104---add---end
           END CASE

          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
                    ON ACTION qbe_save
                       CALL cl_qbe_save()
 
       END CONSTRUCT

       IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    ELSE
       LET g_wc2 = ' 1=1'
    END IF
    #組合拆解的完工入庫單不顯示出來!
    #TQC-CC0133 mark begin
#    LET g_wc2 = g_wc2 CLIPPED," AND (sfv11 IS NULL OR (sfv11 NOT IN (",
#                              " SELECT tsc19 FROM tsc_file WHERE tsc19 IS NOT NULL) ",
#                              " AND sfv11 NOT IN (",
#                              " SELECT tse19 FROM tse_file WHERE tse19 IS NOT NULL) ))"
    #TQC-CC0133 mark end                              
    LET g_sql = " SELECT UNIQUE  sfu01 ",   #No.TQC-9A1020 mod
                "   FROM sfu_file LEFT OUTER JOIN sfv_file",
                "                 ON sfu01 = sfv01",
                "  WHERE sfu00 = '",g_argv,"'",
                "    AND ",g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                "  ORDER BY sfu01 "

    PREPARE t620_prepare FROM g_sql
    DECLARE t620_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t620_prepare
    DECLARE t620_fill_cs CURSOR FOR t620_prepare    #FUN-CB0014 add

    #組合拆解的完工入庫單不顯示出來!
    LET g_sql = " SELECT COUNT(DISTINCT sfu01) ",
                "   FROM sfu_file LEFT OUTER JOIN sfv_file",
                "                 ON sfu01 = sfv01",
                "  WHERE sfu00 = '",g_argv,"'",
                "    AND ",g_wc CLIPPED, " AND ",g_wc2 CLIPPED
    PREPARE t620_precount FROM g_sql
    DECLARE t620_count CURSOR FOR t620_precount

END FUNCTION

FUNCTION t620_menu()
DEFINE l_creator    LIKE type_file.chr1      #FUN-A80128 add
DEFINE l_flowuser   LIKE type_file.chr1      #FUN-A80128 add
DEFINE l_flag       LIKE type_file.chr1      #TQC-B60082 add
DEFINE l_cmd        LIKE type_file.chr1000   #FUN-BC0104
DEFINE l_sfu01_doc  LIKE sfu_file.sfu01, #TQC-C50227
       l_cnt        LIKE type_file.num5 
   LET l_flowuser = "N"                         #FUN-A80128 add

   WHILE TRUE
      IF cl_null(g_action_flag) OR g_action_flag = "page_main" THEN   #FUN-CB0014 add
         CALL t620_bp("G")
      #FUN-CB0014---add---str---
      ELSE                           
         CALL t620_list_fill()
         CALL t620_bp2("G")           
         IF NOT cl_null(g_action_choice) AND l_ac2>0 THEN #將清單的資料回傳到主畫面
            SELECT sfu_file.* INTO g_sfu.*
              FROM sfu_file
             WHERE sfu01=g_sfu_l[l_ac2].sfu01
         END IF
         IF g_action_choice!= "" THEN
            LET g_action_flag = "page_main"
            LET l_ac2 = ARR_CURR()
            LET g_jump = l_ac2
            LET mi_no_ask = TRUE
            IF g_rec_b2 >0 THEN
               CALL t620_fetch('/')
            END IF
            CALL cl_set_comp_visible("page_list", FALSE)
            CALL cl_set_comp_visible("info,userdefined_field", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page_list", TRUE)
            CALL cl_set_comp_visible("info,userdefined_field", TRUE)
          END IF               
      END IF  
      #FUN-CB0014---add---end--
      CALL t620sub_refresh(g_sfu.sfu01) RETURNING g_sfu.*   #MOD-BB0104 add
      CASE g_action_choice

           WHEN "insert"
              IF cl_chk_act_auth() THEN
                 CALL t620_a()
              END IF
           WHEN "query"
              IF cl_chk_act_auth() THEN
                 CALL t620_q()
              END IF
           WHEN "delete"
              IF cl_chk_act_auth() THEN
                 CALL t620_r()
              END IF
           WHEN "modify"
              IF cl_chk_act_auth() THEN
                 CALL t620_u()
              END IF
           WHEN "detail"
              IF cl_chk_act_auth() THEN
                 CALL t620_b()
                 #FUN-A80128---add---str--
                 CALL t620sub_refresh(g_sfu.sfu01) RETURNING g_sfu.*
                 CALL t620_show() 
                 #FUN-A80128---add---end--
                 IF g_action_choice="gen_detail" THEN CONTINUE WHILE END IF
              ELSE
                 LET g_action_choice = NULL
              END IF
           WHEN "output"
              IF cl_chk_act_auth() THEN
                 CALL t620_out()
              END IF
           WHEN "help"
              CALL cl_show_help()
           WHEN "exit"
              EXIT WHILE
           WHEN "controlg"
              CALL cl_cmdask()
           WHEN "confirm"
              IF cl_chk_act_auth() THEN
                 #TQC-B60082-add-str--
                 LET l_flag = 'Y'
                 IF NOT cl_null(g_sfu.sfu16) THEN
                    CALL t620_sfu16('a')
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_sfu.sfu16,'art-241',1)    
                       LET l_flag = 'N'
                    END IF
                 END IF 
                 #TQC-B60082-add-end--
                 IF l_flag= 'Y' THEN             #TQC-B60082
                    CALL t620sub_y_chk(g_argv,g_sfu.sfu01,g_action_choice) #CHI-C30118 add g_action_choice
                    IF g_success = 'Y' THEN
                       CALL t620sub_y_upd(g_sfu.sfu01,g_action_choice,FALSE)
                    END IF
                    CALL t620sub_refresh(g_sfu.sfu01) RETURNING g_sfu.*
                    CALL t620_show()
                 END IF                          #TQC-B60082
              END IF
           WHEN "undo_confirm"
              IF cl_chk_act_auth() THEN
                 #TQC-C50227 add begin---- 拆解組合工單不能取消審核
                 LET l_cnt=0
                 LET l_sfu01_doc = g_sfu.sfu01[1,g_doc_len]
                 SELECT COUNT(*) INTO l_cnt FROM smy_file WHERE smy71 = l_sfu01_doc
                 IF l_cnt > 0 THEN 
                    CALL cl_err('','asf-599',1)
                 ELSE    
                 #TQC-C50227 add  end------                
                    CALL t620sub_z(g_sfu.sfu01,g_action_choice,FALSE)
                    CALL t620sub_refresh(g_sfu.sfu01) RETURNING g_sfu.*
                    CALL t620_show()
                 END IF   #TQC-C50227 add                 
              END IF
           WHEN "void"
              IF cl_chk_act_auth() THEN
                #CALL t620_x()                          #CHI-D20010
                 CALL t620_x(1)                          #CHI-D20010
                 CALL t620_show() #FUN-BC0104 add
              END IF
              CALL t620_pic() #圖形顯示 #FUN-660137

           #CHI-D20010---add---str
           WHEN "undo_void"
              IF cl_chk_act_auth() THEN
                #CALL t620_x()                          #CHI-D20010
                 CALL t620_x(2)                          #CHI-D20010
                 CALL t620_show() #FUN-BC0104 add
              END IF
              CALL t620_pic() #圖形顯示 #FUN-660137
           #CHI-D20010---add--end
           WHEN "stock_post"
              IF cl_chk_act_auth() THEN
                 CALL t620sub_s(g_sfu.sfu01,g_argv,FALSE,g_action_choice)
                 IF NOT cl_null(g_action_choice) AND g_success = 'Y' THEN  #FUN-840012
                     SELECT COUNT(*) INTO g_cnt FROM sfv_file,sfa_file
                      WHERE sfv01 = g_sfu.sfu01
                        AND sfv11 = sfa01 AND sfa11 = 'E'
                     IF g_cnt > 0 THEN 
                       CALL t620_k() 
                     END IF
                 END IF
                 CALL t620sub_refresh(g_sfu.sfu01) RETURNING g_sfu.*
                 CALL t620_show()
              END IF
              CALL t620_pic() #圖形顯示 #FUN-660137
           WHEN "undo_post"
              IF cl_chk_act_auth() THEN
                 #TQC-C50227 add begin---- 拆解組合工單不能取消審核
                 LET l_cnt=0
                 LET l_sfu01_doc = g_sfu.sfu01[1,g_doc_len]
                 SELECT COUNT(*) INTO l_cnt FROM smy_file WHERE smy71 = l_sfu01_doc
                 IF l_cnt > 0 THEN 
                    CALL cl_err('','asf-598',1)
                 ELSE    
                 #TQC-C50227 add  end------                
                    LET g_success = 'Y'   #No.TQC-9C0148
                    CALL t620sub_w(g_sfu.sfu01,g_action_choice,FALSE,g_argv)
                    CALL t620sub_refresh(g_sfu.sfu01) RETURNING g_sfu.*
                    CALL t620_show()
                 END IF #TQC-C50227
                IF g_success = 'Y' THEN 
                    LET g_msg=TIME
                    INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)     #FUN-980008 add
                    VALUES ('asft620',g_user,g_today,g_msg,g_sfu.sfu01,'undo_post',g_plant,g_legal) #FUN-980008 add
                END IF 
              END IF
              CALL t620_pic() #圖形顯示 #FUN-660137
           WHEN "gen_mat_wtdw"
              IF cl_chk_act_auth() THEN
                 IF g_argv='3' THEN
                    CALL t620_v()
                 ELSE
                    CALL t620_k()
                 END IF
              END IF
           WHEN "maint_mat_wtdw"
              IF cl_chk_act_auth() THEN
                 IF g_sfu.sfu09 IS NOT NULL THEN
                    IF g_argv='3' THEN
                       LET g_cmd = "asrt320"," '",g_sfu.sfu09,"'"
                    ELSE
                       IF s_industry('icd') THEN 
                          LET g_cmd = "asfi510_icd", " '4' " ," '",g_sfu.sfu09,"'"
                       END IF
                       IF s_industry('slk') THEN 
                          LET g_cmd = "asfi510_slk", " '4' " ," '",g_sfu.sfu09,"'"
                       END IF
                       IF s_industry('std') THEN 
                          LET g_cmd = "asfi510", " '4' " ," '",g_sfu.sfu09,"'"
                       END IF
                    END IF
                    CALL cl_cmdrun(g_cmd CLIPPED)
                 END IF
              END IF
         #FUN-BC0104---add---str
          WHEN "qc_determine_storage"
            IF cl_chk_act_auth() THEN
               LET  l_cmd = "aqcp107 '2' '' '' '' '' '' '' '' '' 'N'"
               CALL cl_cmdrun(l_cmd)
            END IF
         #FUN-BC0104---add---end
         WHEN "exporttoexcel"
            LET w = ui.Window.getCurrent()   #FUN-CB0014 add  
            LET f = w.getForm()              #FUN-CB0014 add
            IF cl_null(g_action_flag) OR g_action_flag = "page_main" THEN   #FUN-CB0014 add
               IF cl_chk_act_auth() THEN
                  LET page = f.FindNode("Page","page_main")  #FUN-CB0014 add
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_sfv),'','')
               END IF
            #FUN-CB0014---add---str---
            END IF
            IF g_action_flag = "page_list" THEN
               LET page = f.FindNode("Page","page_list")
               IF cl_chk_act_auth() THEN
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_sfu_l),'','')
               END IF
            END IF
            #FUN-CB0014---add---end---
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_sfu.sfu01 IS NOT NULL THEN
                 LET g_doc.column1 = "sfu01"
                 LET g_doc.value1 = g_sfu.sfu01
                 CALL cl_doc()
               END IF
         END IF
         WHEN "qry_lot"
          IF l_ac > 0 THEN                        #TQC-A80175 
            SELECT ima918,ima921 INTO g_ima918,g_ima921 
              FROM ima_file
             WHERE ima01 = g_sfv[l_ac].sfv04
               AND imaacti = "Y"
            
            IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
               IF cl_null(g_sfv[l_ac].sfv06) THEN
                  LET g_sfv[l_ac].sfv06 = ' '
               END IF
               IF cl_null(g_sfv[l_ac].sfv07) THEN
                  LET g_sfv[l_ac].sfv07 = ' '
               END IF
               SELECT img09 INTO g_img09 FROM img_file
                WHERE img01=g_sfv[l_ac].sfv04
                  AND img02=g_sfv[l_ac].sfv05
                  AND img03=g_sfv[l_ac].sfv06
                  AND img04=g_sfv[l_ac].sfv07
               CALL s_umfchk(g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv08,g_img09) 
                   RETURNING l_i,l_fac
               IF l_i = 1 THEN LET l_fac = 1 END IF
#TQC-B90236---mark---begin
#              CALL s_lotin(g_prog,g_sfu.sfu01,g_sfv[l_ac].sfv03,0,
#                           g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv08,g_img09,
#                           l_fac,g_sfv[l_ac].sfv09,'','QRY')#CHI-9A0022 add ''
#TQC-B90236---mark---end
#TQC-B90236---add----begin
               CALL s_wo_record(g_sfv[l_ac].sfv11,'Y')  #MOD-CB0031 add
               CALL s_mod_lot(g_prog,g_sfu.sfu01,g_sfv[l_ac].sfv03,0,
                              g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv05,
                              g_sfv[l_ac].sfv06,g_sfv[l_ac].sfv07,
                              g_sfv[l_ac].sfv08,g_img09,l_fac,g_sfv[l_ac].sfv09,'','QRY',1)   
#TQC-B90236---add----end
                     RETURNING l_r,g_qty 
            END IF
          END IF                                #TQC-A80175

         #FUN-A80128---add----str---
         WHEN "approval_status"               #簽核狀況
           IF cl_chk_act_auth() THEN          #DISPLAY ONLY
              IF aws_condition2() THEN        
                 CALL aws_efstat2()    
              END IF
           END IF
         
         WHEN "easyflow_approval"             #EasyFlow送簽
           IF cl_chk_act_auth() THEN
             #FUN-C20027 add str---
              SELECT * INTO g_sfu.* FROM sfu_file
               WHERE sfu01 = g_sfu.sfu01
              CALL t620_show()
              CALL t620_b_fill(' 1=1')
             #FUN-C20027 add end---
              CALL t620_ef()
              CALL t620_show()  #FUN-C20027 add
           END IF
         #@WHEN "准"
         WHEN "agree"
              IF g_laststage = "Y" AND l_flowuser = "N" THEN  #最後一關並且沒有加簽人員
                 CALL t620sub_y_upd(g_sfu.sfu01,g_action_choice,FALSE) 
                 CALL t620sub_refresh(g_sfu.sfu01) RETURNING g_sfu.*  
                 CALL t620_show() 
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
                       LET g_argv2 = aws_efapp_wsk(1)   #取得單號
                       IF NOT cl_null(g_argv2) THEN     #自動 query 帶出資料
                             CALL t620_q()
                             #傳入簽核模式時不應執行的 action 清單
                             CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, undo_void,       #CHI-D20010 add--undo_void                                                        confirm, undo_confirm,easyflow_approval,stock_post,undo_post,gen_mat_wtdw,maint_mat_wtdw,aic_s_icdin")  
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
                      LET g_sfu.sfu15 = 'R'        #顯示狀態碼為 'R' 送簽退回
                      DISPLAY BY NAME g_sfu.sfu15
                   END IF
                   IF cl_confirm('aws-081') THEN #詢問是否繼續下一筆資料的簽核
                      IF aws_efapp_getnextforminfo() THEN   #取得下一筆簽核單號
                          LET l_flowuser = 'N'
                          LET g_argv2 = aws_efapp_wsk(1)    #取得單號
                          IF NOT cl_null(g_argv2) THEN      #自動 query 帶出資料
                                CALL t620_q()
                                #傳入簽核模式時不應執行的 action 清單
                                CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, undo_void,     #CHI-D20010 add--undo_void                                                           confirm, undo_confirm,easyflow_approval,stock_post,undo_post,gen_mat_wtdw,maint_mat_wtdw,aic_s_icdin")  
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
         #FUN-A80128---add----end---
         
      END CASE
   END WHILE
END FUNCTION

FUNCTION t620_a()

DEFINE li_result   LIKE type_file.num5        #No.FUN-540055        #No.FUN-680121 SMALLINT
    IF s_shut(0) THEN RETURN END IF
    CALL cl_msg("")
    CLEAR FORM
    CALL g_sfv.clear()
    INITIALIZE g_sfu.* TO NULL
    LET g_sfu_o.* = g_sfu.*
    LET g_sfu_t.* = g_sfu.*
    #FUN-A80128--add---str--
    LET g_sfu.sfu15 = '0'         #開立
    LET g_sfu.sfumksg = "N"               
    LET g_sfu.sfu16 = g_user
    CALL t620_sfu16('d')
    #FUN-A80128--add---end--
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_sfu.sfu00 = g_argv
        LET g_sfu.sfu02 = g_today
        LET g_sfu.sfu14 = g_today #FUN-860069
        LET g_sfu.sfupost='N'
        LET g_sfu.sfuconf='N' #FUN-660137
        LET g_sfu.sfuuser=g_user
        LET g_sfu.sfuoriu = g_user #FUN-980030
        LET g_sfu.sfuorig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_sfu.sfugrup=g_grup
        LET g_sfu.sfudate=g_today
        LET g_sfu.sfu04=g_grup #FUN-670103
        LET g_sfu.sfuplant = g_plant #FUN-980008 add
        LET g_sfu.sfulegal = g_legal #FUN-980008 add

        CALL t620_i("a")                #輸入單頭
        IF INT_FLAG THEN
           LET INT_FLAG=0 CALL cl_err('',9001,0)
           INITIALIZE g_sfu.* TO NULL
           ROLLBACK WORK EXIT WHILE
        END IF


        IF cl_null(g_sfu.sfu01) THEN CONTINUE WHILE END IF

        BEGIN WORK   #No:7829
       #CALL s_auto_assign_no("asf",g_sfu.sfu01,g_sfu.sfu02,"A","sfu_file","sfu01","","","")  #MOD-660023 #MOD-A40051 mark
        CALL s_auto_assign_no("asf",g_sfu.sfu01,g_sfu.sfu14,"A","sfu_file","sfu01","","","")  #MOD-A40051
             RETURNING li_result,g_sfu.sfu01
        IF (NOT li_result) THEN
            ROLLBACK WORK
            CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_sfu.sfu01


        INSERT INTO sfu_file VALUES (g_sfu.*)
        IF STATUS THEN
           CALL cl_err(g_sfu.sfu01,STATUS,1)
           ROLLBACK WORK   #No:7829
           CONTINUE WHILE
        END IF

#FUN-B20089 -------------Begin-------------
        INITIALIZE g_sfv_t.* TO NULL
        IF NOT cl_null(g_sfu.sfu08) THEN
           CALL t620_sfv_b1("a")
        END IF
#FUN-B20089 -------------End---------------

        COMMIT WORK

#FUN-B20089 -------------Begin-------------
        IF NOT cl_null(g_sfu.sfu08) THEN
           CALL t620_b_fill(' 1=1')
        END IF
#FUN-B20089 -------------End---------------

        CALL cl_flow_notify(g_sfu.sfu01,'I')

        LET g_sfu_t.* = g_sfu.*

        SELECT COUNT(*) INTO g_cnt FROM sfv_file WHERE sfv01 = g_sfu.sfu01

#sfu03改為no use
#改由單身輸入FQC,單頭不做自動產生的功能,sfu03只在單身做預設用
#       CALL g_sfv.clear()    #FUN-B20089  mark
#       LET g_rec_b = 0       #FUN-B20089  mark
        IF cl_null(g_sfu.sfu08) THEN    #MOD-CB0170 add
           LET g_rec_b = 0       #TQC-BB0159
        END IF                          #MOD-CB0170 add
        CALL t620_b()                   #輸入單身

        SELECT COUNT(*) INTO g_cnt FROM sfv_file WHERE sfv01=g_sfu.sfu01
        IF g_cnt>0 THEN
           IF g_smy.smyprint='Y' THEN
              IF cl_confirm('mfg9392') THEN CALL t620_out() END IF
           END IF
          #FUN-A80128---mod---str---
          #IF g_smy.smydmy4='Y' THEN
           IF g_smy.smydmy4='Y' AND g_smy.smyapr <> 'Y' THEN  #單據需自動確認且不需簽核 
              LET g_action_choice = "insert"                
          #FUN-A80128---mod---end---
              CALL t620sub_y_chk(g_argv,g_sfu.sfu01,g_action_choice) #CHI-C30118 add g_action_choice
              IF g_success = 'Y' THEN
                 CALL t620sub_y_upd(g_sfu.sfu01,g_action_choice,FALSE)
              END IF
              CALL t620sub_refresh(g_sfu.sfu01) RETURNING g_sfu.*
              CALL t620_pic() #圖形顯示 #FUN-660137
              CALL t620_show() #FUN-A80128 add
           END IF
        END IF

        EXIT WHILE

    END WHILE
END FUNCTION

FUNCTION t620_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_sfu.sfu01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_sfu.* FROM sfu_file WHERE sfu01 = g_sfu.sfu01
    IF g_sfu.sfupost = 'Y' THEN CALL cl_err('','mfg0175',0) RETURN END IF
    IF g_sfu.sfuconf = 'Y' THEN CALL cl_err('','9023',0) RETURN END IF #FUN-660137
    IF g_sfu.sfuconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF #FUN-660137
    #FUN-A80128  add str ---              
    IF g_sfu.sfu15 matches '[Ss]' THEN
         CALL cl_err('','apm-030',0) #送簽中, 不可修改資料!
         RETURN
    END IF
    IF g_sfu.sfuconf='Y' AND g_sfu.sfu15 = "1" AND g_sfu.sfumksg = "Y"  THEN
       CALL cl_err('','mfg3168',0) #此張單據已核准, 不允許更改或取消
       RETURN
    END IF
    #FUN-A80128  add end ---    

    CALL cl_msg("")

    CALL cl_opmsg('u')
    LET g_sfu_o.* = g_sfu.*

    BEGIN WORK

    OPEN t620_cl USING g_sfu.sfu01     #No.TQC-9A0120 mod
    IF STATUS THEN
       CALL cl_err("OPEN t620_cl:", STATUS, 1)
       CLOSE t620_cl
       ROLLBACK WORK
       RETURN
    END IF






    FETCH t620_cl INTO g_sfu.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_sfu.sfu01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE t620_cl
       ROLLBACK WORK
       RETURN
    END IF



    CALL t620_show()

    WHILE TRUE
        LET g_sfu.sfumodu=g_user
        LET g_sfu.sfudate=g_today
        CALL t620_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_sfu.*=g_sfu_t.*
            CALL t620_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        LET g_sfu.sfu15 = 0 #FUN-A80128 add
        UPDATE sfu_file SET * = g_sfu.* WHERE sfu01 = g_sfu_o.sfu01  #No.TQC-9A0120 mod 
        IF STATUS OR SQLCA.SQLERRD[3]=0  THEN
           CALL cl_err(g_sfu.sfu01,STATUS,0)
           CONTINUE WHILE
        END IF
        IF g_sfu.sfu01 != g_sfu_t.sfu01 THEN CALL t620_chkkey() END IF
        EXIT WHILE
    END WHILE

    CLOSE t620_cl
    COMMIT WORK
    CALL t620_show()                             # 顯示最新資料   #FUN-A80128 add
    CALL cl_flow_notify(g_sfu.sfu01,'U')

END FUNCTION

FUNCTION t620_chkkey()
    UPDATE sfv_file SET sfv01=g_sfu.sfu01 WHERE sfv01=g_sfu_t.sfu01
    IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
       CALL cl_err('upd sfv01',STATUS,1)
       LET g_sfu.*=g_sfu_t.* CALL t620_show() ROLLBACK WORK RETURN
    END IF
END FUNCTION

FUNCTION t620_i(p_cmd)
  DEFINE p_cmd           LIKE type_file.chr1                  #a:輸入 u:更改        #No.FUN-680121 CHAR(1)
  DEFINE l_flag          LIKE type_file.chr1                  #判斷必要欄位是否有輸入        #No.FUN-680121 CHAR(1)
  DEFINE l_qcf14         LIKE qcf_file.qcf14    #MOD-530388
  DEFINE li_result   LIKE type_file.num5        #No.FUN-540055        #No.FUN-680121 SMALLINT
  DEFINE l_sfp06         LIKE sfp_file.sfp06
  DEFINE l_smy73         LIKE smy_file.smy73    #TQC-AC0293 
  DEFINE l_date          LIKE sfu_file.sfu02    #CHI-CA0070 add
  DEFINE l_cnt           LIKE type_file.num5,   #MOD-CC0233 add
         l_sfv11         LIKE sfv_file.sfv11    #MOD-CC0233 add

    DISPLAY BY NAME
        g_sfu.sfu01,g_sfu.sfu14,g_sfu.sfu02,g_sfu.sfu04, #FUN-860069
        #g_sfu.sfu05,g_sfu.sfu06,g_sfu.sfu07,g_sfu.sfu08,g_sfu.sfu09,g_sfu.sfuconf, #FUN-660137   #FUN-810045
        g_sfu.sfu06,g_sfu.sfu07,g_sfu.sfu08,g_sfu.sfu09,g_sfu.sfu16,g_sfu.sfuconf, #FUN-660137    #FUN-810045 #FUN-A80128 add sfu16
        g_sfu.sfupost,g_sfu.sfu15,g_sfu.sfumksg,g_sfu.sfuuser,g_sfu.sfugrup,g_sfu.sfumodu,g_sfu.sfudate       #FUN-A80128 add sfu15,sfumksg
        CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
        INPUT BY NAME g_sfu.sfuoriu,g_sfu.sfuorig,
          g_sfu.sfu01,g_sfu.sfu14,g_sfu.sfu02,g_sfu.sfu04, #FUN-860069
          #g_sfu.sfu08,g_sfu.sfu09,g_sfu.sfu06,g_sfu.sfu05,g_sfu.sfu07,g_sfu.sfuconf, #FUN-660137 #FUN-810045
          g_sfu.sfu08,g_sfu.sfu09,g_sfu.sfu16,g_sfu.sfu06,g_sfu.sfu07,g_sfu.sfuconf, #FUN-660137  #FUN-810045 #FUN-A80128 add sfu16
          g_sfu.sfupost,g_sfu.sfu15,g_sfu.sfumksg,g_sfu.sfuuser,g_sfu.sfugrup,g_sfu.sfumodu,g_sfu.sfudate     #FUN-A80128 add sfu15,sfumksg
          ,g_sfu.sfuud01,g_sfu.sfuud02,g_sfu.sfuud03,g_sfu.sfuud04,
          g_sfu.sfuud05,g_sfu.sfuud06,g_sfu.sfuud07,g_sfu.sfuud08,
          g_sfu.sfuud09,g_sfu.sfuud10,g_sfu.sfuud11,g_sfu.sfuud12,
          g_sfu.sfuud13,g_sfu.sfuud14,g_sfu.sfuud15 
             WITHOUT DEFAULTS

        BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL t620_set_entry(p_cmd)
          CALL t620_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
         CALL cl_set_docno_format("sfu01")

        BEFORE FIELD sfu01
          CALL t620_set_entry(p_cmd)
        AFTER FIELD sfu01
          IF NOT cl_null(g_sfu.sfu01) THEN
            CALL s_check_no("asf",g_sfu.sfu01,g_sfu_t.sfu01,"A","sfu_file","sfu01","")
               RETURNING li_result,g_sfu.sfu01
            DISPLAY BY NAME g_sfu.sfu01
            IF (NOT li_result) THEN
              NEXT FIELD sfu01
            END IF
           #TQC-AC0293 ---------------add start----------
            LET g_t1 = s_get_doc_no(g_sfu.sfu01)
            SELECT smy73 INTO l_smy73 FROM smy_file
             WHERE smyslip = g_t1
            IF l_smy73 = 'Y' THEN
               CALL cl_err('','asf-872',0)
               NEXT FIELD sfu01 
            END IF
           #TQC-AC0293 ---------------add end-------------
            CALL t620_sfu01(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_sfu.sfu01,g_errno,0)
               NEXT FIELD sfu01
            END IF
 	     DISPLAY BY NAME g_smy.smydesc
##----------------------------------------
            #FUN-A80128 add str ---
            IF g_sfu_t.sfu01 IS NULL OR
               (g_sfu.sfu01 != g_sfu_t.sfu01 ) THEN
               LET g_sfu.sfumksg = g_smy.smyapr
               LET g_sfu.sfu15 = '0'
               DISPLAY BY NAME g_sfu.sfumksg   #簽核否
               DISPLAY BY NAME g_sfu.sfu15     #簽核狀況
            END IF 
            #FUN-A80128 add end ---
          END IF

          CALL t620_set_no_entry(p_cmd)


        AFTER FIELD sfu14
          IF NOT cl_null(g_sfu.sfu14) THEN
	     IF g_sma.sma53 IS NOT NULL AND g_sfu.sfu14 <= g_sma.sma53 THEN
	        CALL cl_err('','mfg9999',0) NEXT FIELD sfu14
	     END IF
             CALL s_yp(g_sfu.sfu14) RETURNING g_yy,g_mm
             #不可大於現行年月
             IF (g_yy*12+g_mm) > (g_sma.sma51*12+g_sma.sma52) THEN
                CALL cl_err('','mfg6091',0) NEXT FIELD sfu14
             END IF
          END IF
        #--

        AFTER FIELD sfu02
          IF NOT cl_null(g_sfu.sfu02) THEN
	     IF g_sma.sma53 IS NOT NULL AND g_sfu.sfu02 <= g_sma.sma53 THEN
	        CALL cl_err('','mfg9999',0) NEXT FIELD sfu02
	     END IF
             CALL s_yp(g_sfu.sfu02) RETURNING g_yy,g_mm
             #不可大於現行年月
             IF (g_yy*12+g_mm) > (g_sma.sma51*12+g_sma.sma52) THEN
                CALL cl_err('','mfg6091',0) NEXT FIELD sfu02
             END IF
            #CHI-CA0070---add---S
            #入庫日期不可小於工單(單身)開立日期
            #MOD-CC0233
            #修改且有單身時控卡
             LET l_cnt=0
             SELECT COUNT(*) INTO l_cnt FROM sfv_file WHERE sfv01=g_sfu.sfu01
             IF p_cmd='u' AND l_cnt>0 THEN
            #MOD-CC0233
                DECLARE t620_sfu02 CURSOR FOR SELECT sfv11 FROM sfv_file
                                               WHERE sfv01 = g_sfu.sfu01
               #FOREACH t620_sfu02 INTO g_sfv[l_ac].sfv11  #MOD-CC0233 mark
                FOREACH t620_sfu02 INTO l_sfv11            #MOD-CC0233
                   LET l_date= ''
                  #SELECT sfb81 INTO l_date FROM sfb_file WHERE sfb01 = g_sfv[l_ac].sfv11   #MOD-CC0233 mark
                   SELECT sfb81 INTO l_date FROM sfb_file WHERE sfb01 = l_sfv11             #MOD-CC0233
                   IF cl_null(l_date) OR l_date > g_sfu.sfu02 THEN
                     #CALL cl_err(g_sfv[l_ac].sfv11,'asf-342',1)  #MOD-CC0233 mark
                      CALL cl_err(l_sfv11,'asf-342',1)            #MOD-CC0233
                      NEXT FIELD sfu02
                   END IF
                END FOREACH
             END IF   #MOD-CC0233
            #CHI-CA0070---add---E
          END IF

        AFTER FIELD sfu04
          IF NOT cl_null(g_sfu.sfu04) THEN
             LET g_buf = ''
             SELECT gem02 INTO g_buf FROM gem_file WHERE gem01=g_sfu.sfu04
                AND gemacti='Y'   #NO:6950
             IF STATUS THEN
                CALL cl_err('select gem',STATUS,0) NEXT FIELD sfu04
             END IF
             DISPLAY g_buf TO gem02
             #FUN-CB0087--add--str--
             IF g_aza.aza115 = 'Y' AND NOT t620_sfv44_chkall() THEN 
                LET g_sfu.sfu04 = g_sfu_t.sfu04
                NEXT FIELD sfu04 
             END IF
             #FUN-CB0087--add--end--  
          END IF


        AFTER FIELD sfu06
          IF NOT cl_null(g_sfu.sfu06) THEN
             SELECT COUNT(*) INTO g_cnt FROM pja_file
              WHERE pja01 = g_sfu.sfu06
                AND pjaacti = 'Y'    #FUN-810045
                AND pjaclose='N'     #FUN-960038 
             IF g_cnt = 0 THEN
                CALL cl_err(g_sfu.sfu06,'asf-984',0)
                NEXT FIELD sfu06
             END IF
             CALL t620_pja02()   #FUN-810045
          END IF

        AFTER FIELD sfu08
          IF NOT cl_null(g_sfu.sfu08) THEN
             SELECT COUNT(*) INTO g_cnt FROM sfd_file
              WHERE sfd01 = g_sfu.sfu08 AND sfdconf = 'Y'              #FUN-A90035 add sfdconf = 'Y' 
             IF g_cnt = 0 THEN
              # CALL cl_err(g_sfu.sfu08,'asf-401',0)                   #FUN-A90035 mark 
                CALL cl_err(g_sfu.sfu08,'asf-772',0)                   #FUN-A90035 add
                NEXT FIELD sfu08
             END IF
          END IF

        AFTER FIELD sfu09    #領料單號
          IF NOT cl_null(g_sfu.sfu09)  THEN
             IF g_argv<>'3' THEN
                LET l_sfp06='4'
             ELSE
                LET l_sfp06='C'
             END IF
             SELECT COUNT(*) INTO g_cnt FROM sfp_file
                WHERE sfp01 = g_sfu.sfu09
                  AND sfp06  = l_sfp06
                  AND sfpconf!='X' #FUN-660106
             IF g_cnt = 0 THEN
                CALL cl_err(g_sfu.sfu09,'asf-525',0)
                NEXT FIELD sfu09
             END IF
            #TQC-AC0293 ---------------add start----------
            #LET g_t1 = s_get_doc_no(g_sfu.sfu09)
            #SELECT smy73 INTO l_smy73 FROM smy_file
            # WHERE smyslip = g_t1
            #IF l_smy73 = 'Y' THEN
            #   CALL cl_err('','asf-874',0)
            #   NEXT FIELD sfu09
            #END IF
            #TQC-AC0293 ---------------add end------------- 
          END IF

       #FUN-A80128 add str ------
        AFTER FIELD sfu16  #申請人
            IF NOT cl_null(g_sfu.sfu16) THEN
               CALL t620_sfu16('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_sfu.sfu16,g_errno,0)
                  LET g_sfu.sfu16 = g_sfu_t.sfu16
                  DISPLAY BY NAME g_sfu.sfu16
                  NEXT FIELD sfu16
               END IF
               #FUN-CB0087--add--str--
               IF g_aza.aza115 = 'Y' AND NOT t620_sfv44_chkall() THEN 
                  LET g_sfu.sfu16 = g_sfu_t.sfu16
                  NEXT FIELD sfu16 
               END IF
               #FUN-CB0087--add--end--  
            END IF
            LET g_sfu_o.sfu16 = g_sfu.sfu16
       #FUN-A80128 add end ---

        AFTER FIELD sfuud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfuud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfuud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfuud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfuud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfuud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfuud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfuud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfuud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfuud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfuud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfuud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfuud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfuud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfuud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER INPUT 
           LET g_sfu.sfuuser = s_get_data_owner("sfu_file") #FUN-C10039
           LET g_sfu.sfugrup = s_get_data_group("sfu_file") #FUN-C10039
           IF INT_FLAG THEN
              EXIT INPUT      
           END IF
           IF NOT cl_null(g_sfu.sfu02) THEN
              IF g_sma.sma53 IS NOT NULL AND g_sfu.sfu02 <= g_sma.sma53 THEN
                 CALL cl_err('','mfg9999',0) NEXT FIELD sfu02
              END IF
              CALL s_yp(g_sfu.sfu02) RETURNING g_yy,g_mm
              IF (g_yy*12+g_mm) > (g_sma.sma51*12+g_sma.sma52) THEN
                 CALL cl_err(g_yy,'mfg6090',0) NEXT FIELD sfu02
              END IF
           END IF
           IF NOT cl_null(g_sfu.sfu04) THEN
              LET g_buf = ''
              SELECT gem02 INTO g_buf FROM gem_file WHERE gem01=g_sfu.sfu04
                 AND gemacti='Y'   #NO:6950
              IF STATUS THEN
                 CALL cl_err('select gem',STATUS,0) NEXT FIELD sfu04
              END IF
              DISPLAY g_buf TO gem02
           END IF
           #TQC-B60082-add-str--
           IF NOT cl_null(g_sfu.sfu16) THEN
              CALL t620_sfu16('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_sfu.sfu16,g_errno,0)
                 LET g_sfu.sfu16 = g_sfu_t.sfu16
                 DISPLAY BY NAME g_sfu.sfu16
                 NEXT FIELD sfu16
              END IF
           END IF
           LET g_sfu_o.sfu16 = g_sfu.sfu16
           #TQC-B60082-add-end--

        ON ACTION controlp
          CASE WHEN INFIELD(sfu01) #查詢單据
 	            LET g_t1 = s_get_doc_no(g_sfu.sfu01)       #No.FUN-540055
                    LET g_sql = " (smy73 <> 'Y' OR smy73 is null)"  #FUN-9B0144
                    CALL smy_qry_set_par_where(g_sql)
                    IF g_argv='0' THEN
                       CALL q_smy( FALSE, TRUE,g_t1,'ASF','9') RETURNING g_t1  #TQC-670008 
                    ELSE
                       CALL q_smy( FALSE, TRUE,g_t1,'ASF','A') RETURNING g_t1     #TQC-670008
	            END IF
                    LET g_sfu.sfu01=g_t1      #No.FUN-540055
                    DISPLAY BY NAME g_sfu.sfu01
                    NEXT FIELD sfu01
               WHEN INFIELD(sfu04)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gem"
                    LET g_qryparam.default1 = g_sfu.sfu04
                    CALL cl_create_qry() RETURNING g_sfu.sfu04
                    DISPLAY BY NAME g_sfu.sfu04
                    NEXT FIELD sfu04

               WHEN INFIELD(sfu06)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_pja2"   #FUN-810045
                    LET g_qryparam.default1 = g_sfu.sfu06
                    CALL cl_create_qry() RETURNING g_sfu.sfu06
                    DISPLAY BY NAME g_sfu.sfu06
                    NEXT FIELD sfu06

#FUN-B20086 --Begin
               WHEN INFIELD(sfu08)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_sfu08"   #FUN-810045
                    LET g_qryparam.default1 = g_sfu.sfu08
                    CALL cl_create_qry() RETURNING g_sfu.sfu08
                    DISPLAY BY NAME g_sfu.sfu08
                    NEXT FIELD sfu08
#FUN-B20086 --End
               WHEN INFIELD(sfu09) #查詢單据
                    CALL cl_init_qry_var()
                    IF g_argv='3' THEN
                       LET g_qryparam.form ="q_sfp"
                       LET g_qryparam.arg1='C'
                    ELSE
                       LET g_qryparam.form ="q_sfp1"
                    END IF
                    LET g_qryparam.default1 = g_sfu.sfu09
                    CALL cl_create_qry() RETURNING g_sfu.sfu09
                    DISPLAY BY NAME g_sfu.sfu09
                    NEXT FIELD sfu09
               #FUN-A80128 add str ----             
               WHEN INFIELD(sfu16) #申請人員
                  CALL cl_init_qry_var() 
                  LET g_qryparam.form = "q_gen" 
                  CALL cl_create_qry() RETURNING g_sfu.sfu16
                  DISPLAY BY NAME g_sfu.sfu16
                  NEXT FIELD sfu16
               #FUN-A80128 add end ---- 
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

FUNCTION t620_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680121 CHAR(1)

    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("sfu01",TRUE)   #FUN-560195
    END IF

END FUNCTION

FUNCTION t620_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680121 CHAR(1)

    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("sfu01",FALSE)
    END IF

END FUNCTION



FUNCTION t620_pja02()   #專案名稱
   DEFINE
       l_pja02 LIKE pja_file.pja02 

   IF g_sfu.sfu06 IS NULL THEN RETURN END IF
   LET l_pja02=' '
   LET g_errno=' '
   SELECT pja02 INTO l_pja02
     FROM pja_file
     WHERE pja01=g_sfu.sfu06 AND pjaacti='Y'
       AND pjaclose='N'     #FUN-960038
   IF SQLCA.sqlcode THEN
      LET g_errno='apj-005'
      LET l_pja02=''
   END IF
   DISPLAY l_pja02 TO FORMONLY.pja02

END FUNCTION

FUNCTION t620_q()

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_sfu.* TO NULL               #No.FUN-6A0166 
    CALL cl_opmsg('q')
    CALL cl_msg("")
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t620_cs()
    IF INT_FLAG THEN 
       LET INT_FLAG = 0 
       INITIALIZE g_sfu.* TO NULL 
       RETURN 
    END IF
    CALL cl_msg(" SEARCHING ! ")
    OPEN t620_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_sfu.* TO NULL
    ELSE
        OPEN t620_count
        FETCH t620_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t620_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    CALL cl_msg("")
END FUNCTION

FUNCTION t620_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680121 CHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680121 INTEGER

    CASE p_flag
        WHEN 'N' FETCH NEXT     t620_cs INTO g_sfu.sfu01   #No.TQC-9A0120 mod
        WHEN 'P' FETCH PREVIOUS t620_cs INTO g_sfu.sfu01
        WHEN 'F' FETCH FIRST    t620_cs INTO g_sfu.sfu01
        WHEN 'L' FETCH LAST     t620_cs INTO g_sfu.sfu01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
 
                END PROMPT
                IF INT_FLAG THEN
                    LET INT_FLAG = 0
                    EXIT CASE
                END IF
            END IF
             FETCH ABSOLUTE g_jump t620_cs INTO g_sfu.sfu01   #No.TQC-9A0120 mod
            LET mi_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_sfu.sfu01,SQLCA.sqlcode,0)
        INITIALIZE g_sfu.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_sfu.* FROM sfu_file WHERE sfu01 = g_sfu.sfu01   #No.TQC-9A0120 mod 

    IF SQLCA.sqlcode THEN
       CALL cl_err(g_sfu.sfu01,SQLCA.sqlcode,0)
       INITIALIZE g_sfu.* TO NULL
    ELSE
       LET g_data_owner = g_sfu.sfuuser      #FUN-4C0035
       LET g_data_group = g_sfu.sfugrup      #FUN-4C0035
       LET g_data_plant = g_sfu.sfuplant #FUN-980030
       CALL t620_show()
    END IF

END FUNCTION

FUNCTION t620_show()
   DEFINE l_smydesc LIKE smy_file.smydesc  #MOD-4C0010

   SELECT sfuconf,sfu15 INTO g_sfu.sfuconf,g_sfu.sfu15   #FUN-C40016
     FROM sfu_file                                       #FUN-C40016
    WHERE sfu01 = g_sfu.sfu01                            #FUN-C40016
   LET g_sfu_t.* = g_sfu.*                #保存單頭舊值
   DISPLAY BY NAME g_sfu.sfuoriu,g_sfu.sfuorig,
        g_sfu.sfu01,g_sfu.sfu14,g_sfu.sfu02,g_sfu.sfu04, #FUN-860069
        #g_sfu.sfu05,g_sfu.sfu06,g_sfu.sfu07,g_sfu.sfu08,g_sfu.sfu09, #FUN-810045
        g_sfu.sfu06,g_sfu.sfu07,g_sfu.sfu08,g_sfu.sfu09,g_sfu.sfu16,  #FUN-810045 #FUN-A80128 add sfu16
        g_sfu.sfuconf,g_sfu.sfupost,g_sfu.sfu15,g_sfu.sfumksg, #FUN-660137        #FUN-A80128 add sfu15,sfumksg
        g_sfu.sfuuser,g_sfu.sfugrup,g_sfu.sfumodu,g_sfu.sfudate
        ,g_sfu.sfuud01,g_sfu.sfuud02,g_sfu.sfuud03,g_sfu.sfuud04,
        g_sfu.sfuud05,g_sfu.sfuud06,g_sfu.sfuud07,g_sfu.sfuud08,
        g_sfu.sfuud09,g_sfu.sfuud10,g_sfu.sfuud11,g_sfu.sfuud12,
        g_sfu.sfuud13,g_sfu.sfuud14,g_sfu.sfuud15 
    LET g_buf = s_get_doc_no(g_sfu.sfu01)       #No.FUN-540055
     SELECT smydesc INTO l_smydesc FROM smy_file WHERE smyslip=g_buf #MOD-4C0010
    DISPLAY l_smydesc TO smydesc
    SELECT * INTO g_smy.* FROM smy_file WHERE smyslip=g_buf
     LET g_buf = NULL #MOD-4C0010
 

    CALL t620_show2()
    CALL t620_sfu16('d') #FUN-A80128 add

    CALL t620_pic() #圖形顯示 #FUN-660137 
    CALL t620_b_fill(g_wc2)
    CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
END FUNCTION

FUNCTION t620_show2()
    SELECT gem02 INTO g_buf FROM gem_file WHERE gem01=g_sfu.sfu04
                 DISPLAY g_buf TO gem02 LET g_buf = NULL
    SELECT pja02 INTO g_buf FROM pja_file WHERE pja01 = g_sfu.sfu06
    CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
   
    DISPLAY g_buf TO FORMONLY.pja02 LET g_buf = NULL  #FUN-810045
END FUNCTION

FUNCTION t620_r()
    DEFINE l_chr,l_sure LIKE type_file.chr1          #No:FUN-680121 CHAR(1)
    DEFINE l_i LIKE type_file.num10         #No:FUN-680121 INTEGER#MOD-640180
    #FUN-BC0104---add---str---
    DEFINE l_sfv17         LIKE sfv_file.sfv17,
           l_sfv47         LIKE sfv_file.sfv47,
           l_cn            LIKE type_file.num5,
           l_c             LIKE type_file.num5       
    DEFINE l_sfv_a   DYNAMIC ARRAY OF RECORD
           sfv17           LIKE sfv_file.sfv17,
           sfv47           LIKE sfv_file.sfv47
                     END RECORD
    #FUN-BC0104---add---end---

    IF s_shut(0) THEN RETURN END IF
    IF g_sfu.sfu01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_sfu.* FROM sfu_file WHERE sfu01 = g_sfu.sfu01
    IF g_sfu.sfupost = 'Y' THEN CALL cl_err('','mfg0175',0) RETURN END IF
    IF g_sfu.sfuconf = 'Y' THEN CALL cl_err('','9023',0) RETURN END IF #FUN-660137
    IF g_sfu.sfuconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF #FUN-660137
    #FUN-A80128  add str ---              
    IF g_sfu.sfu15 matches '[Ss]' THEN
         CALL cl_err('','aws-200',0) #送簽中,不可刪除資料
         RETURN
    END IF
    #FUN-A80128  add end ---              

    BEGIN WORK

    OPEN t620_cl USING g_sfu.sfu01     #No.TQC-9A0120 mod
    IF STATUS THEN
       CALL cl_err("OPEN t620_cl:", STATUS, 1)
       CLOSE t620_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t620_cl INTO g_sfu.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_sfu.sfu01,SQLCA.sqlcode,0)
       CLOSE t620_cl
       ROLLBACK WORK RETURN
    END IF
    CALL t620_show()
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "sfu01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_sfu.sfu01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
        CALL cl_msg("Delete sfu,sfv!")
        IF g_argv='3' THEN
           FOR l_i=1 TO g_sfv.getlength()
              UPDATE srg_file SET srg11=NULL
                                WHERE srg01=g_sfv[l_i].sfv17
                                  AND srg02=g_sfv[l_i].sfv14
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                 CALL cl_err('upd srg11','9050',1)
                 ROLLBACK WORK 
                 RETURN
              END IF
           END FOR      
           SELECT COUNT(*) INTO l_i FROM qcs_file
              WHERE qcs20=g_sfu.sfu01
           IF SQLCA.sqlcode THEN LET l_i=0 END IF
           IF l_i>0 THEN
              UPDATE qcs_file set qcs20=NULL 
                 WHERE qcs20=g_sfu.sfu01
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                 CALL cl_err('upd qcs20',SQLCA.sqlcode,1)
                 ROLLBACK WORK 
                 RETURN
              END IF
           END IF
        END IF
        
        IF g_argv='1' THEN
           LET l_i=0
           SELECT COUNT(*) INTO l_i FROM srg_file
                                   WHERE srg11=g_sfu.sfu01
           IF l_i>0 THEN
              UPDATE srg_file SET srg11=NULL
                                   WHERE srg11=g_sfu.sfu01
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                 CALL cl_err('upd qcs20',SQLCA.sqlcode,1)
                 ROLLBACK WORK 
                 RETURN
              END IF
           END IF
           SELECT COUNT(*) INTO l_i FROM shb_file                                                                                    
               WHERE shb21 = g_sfu.sfu01                                                                                            
                 AND shbconf = 'Y'     #FUN-A70095
           IF SQLCA.sqlcode THEN LET l_i = 0  END IF                                                                                 
           IF l_i>0 THEN                                                                                                             
              UPDATE shb_file SET shb21 = NULL                                                                                       
               WHERE shb21 = g_sfu.sfu01                                                                                             
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN                                                                            
                 CALL cl_err('upd shb21',SQLCA.sqlcode,1)                                                                            
                 ROLLBACK WORK                                                                                                       
                 RETURN                                                                                                              
              END IF                                                                                                                 
           END IF     
        END IF
        DELETE FROM sfu_file WHERE sfu01 = g_sfu.sfu01
        IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err('No sfu deleted',SQLCA.SQLCODE,0)
           ROLLBACK WORK RETURN
        END IF
        #FUN-BC0104---add---str---
        DECLARE sfv03_cur CURSOR FOR SELECT sfv17,sfv47 
                                     FROM sfv_file
                                     WHERE sfv01 = g_sfu.sfu01
        LET l_cn = 1
        FOREACH sfv03_cur INTO l_sfv17,l_sfv47
           LET l_sfv_a[l_cn].sfv17 = l_sfv17
           LET l_sfv_a[l_cn].sfv47 = l_sfv47
           LET l_cn = l_cn+1
        END FOREACH
        #FUN-BC0104---add---end---
        DELETE FROM sfv_file WHERE sfv01 = g_sfu.sfu01
        #FUN-BC0104---add---str---
        FOR l_c=1 TO l_cn-1
           IF NOT s_iqctype_upd_qco20(l_sfv_a[l_c].sfv17,0,0,l_sfv_a[l_c].sfv47,'2') THEN
                   ROLLBACK WORK
                   RETURN 
                END IF 
        END FOR
        #FUN-BC0104---add---end---

       FOR l_i = 1 TO g_rec_b 
          #IF NOT s_del_rvbs("2",g_sfu.sfu01,g_sfv[l_i].sfv03,0)  THEN      #FUN-880129   #TQC-B90236 mark
           IF NOT s_lot_del(g_prog,g_sfu.sfu01,'',0,g_sfv[l_i].sfv04,'DEL') THEN  #TQC-B90236 add
              ROLLBACK WORK
              RETURN
           END IF
       END FOR

        LET g_msg=TIME
        INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)     #FUN-980008 add
           VALUES ('asft620',g_user,g_today,g_msg,g_sfu.sfu01,'delete',g_plant,g_legal) #FUN-980008 add
        CLEAR FORM
        CALL g_sfv.clear()
    	INITIALIZE g_sfu.* TO NULL
        CALL cl_msg("")
        OPEN t620_count
        #FUN-B50064-add-start--
        IF STATUS THEN
           CLOSE t620_cs
           CLOSE t620_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50064-add-end-- 
        FETCH t620_count INTO g_row_count
        #FUN-B50064-add-start--
        IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
           CLOSE t620_cs
           CLOSE t620_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50064-add-end-- 
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN t620_cs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL t620_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET mi_no_ask = TRUE
           CALL t620_fetch('/')
        END IF

    END IF

    CLOSE t620_cl
    COMMIT WORK
    CALL cl_flow_notify(g_sfu.sfu01,'D')

END FUNCTION

#CHI-A40030 add --start--
FUNCTION t620_g_b1()
DEFINE rg1    LIKE type_file.chr1
DEFINE ima35  LIKE ima_file.ima35
DEFINE ima36  LIKE ima_file.ima36

  OPEN WINDOW t6201_w WITH FORM "asf/42f/asft6201"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)

  CALL cl_ui_locale("asft6201")

  INPUT BY NAME rg1,ima35,ima36 WITHOUT DEFAULTS

     BEFORE INPUT
        LET rg1 = '1'
        LET g_rg1 = '1'
        CALL t6201_set_no_entry()

     AFTER FIELD rg1
        IF cl_null(rg1) OR rg1 NOT MATCHES '[123]' THEN
           NEXT FIELD rg1
        END IF
        LET g_rg1 = rg1
        #CALL t6201_set_entry()
        CALL t6201_set_no_entry()

     AFTER FIELD ima35
        IF rg1 = '3' THEN
           IF NOT cl_null(ima35) THEN
              SELECT imd02 INTO g_buf FROM imd_file
               WHERE imd01=ima35
                  AND imdacti = 'Y' 
              IF STATUS THEN
                 CALL cl_err3("sel","imd_file",ima35,"",STATUS,"","sel imd",1) 
                 NEXT FIELD ima35
              END IF
              #Add No.FUN-AA0055
              IF NOT s_chk_ware(ima35) THEN  #检查仓库是否属于当前门店
                 NEXT FIELD ima35
              END IF
              #End Add No.FUN-AA0055
           END IF
            #FUN-D40103 ------Begin-------
           IF NOT s_imechk(ima35,ima36) THEN
              NEXT FIELD ima36
           END IF
           #FUN-D40103 ------End---------
        END IF

     AFTER FIELD ima36
        IF rg1 = '3' THEN
           IF NOT cl_null(ima36) THEN
              SELECT * FROM ime_file WHERE ime01=ima35
                 AND ime02=ima36
              IF STATUS THEN
                 CALL cl_err3("sel","ime_file",ima36,"","STATUS","","sel ime",1)
                 NEXT FIELD ima36
              END IF
           END IF
           IF cl_null(ima36) THEN LET ima36 = ' ' END IF    #TQC-D50127
           #FUN-D40103 ------Begin-------
           IF NOT s_imechk(ima35,ima36) THEN
              NEXT FIELD ima36
           END IF
           #FUN-D40103 ------End---------
        END IF

     ON CHANGE rg1
        LET g_rg1 = rg1
        CALL t6201_set_entry()
        CALL t6201_set_no_entry()

     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT

     ON ACTION about
        CALL cl_about()
 
     ON ACTION help
        CALL cl_show_help()

     ON ACTION controlg
        CALL cl_cmdask()

     ON ACTION controlp
         CASE
            WHEN INFIELD(ima35)
              #Mod No.FUN-AA0055
              #CALL cl_init_qry_var()
              #LET g_qryparam.form     = "q_imd"
              ##LET g_qryparam.default1 = ima35
              #LET g_qryparam.arg1     = 'SW'        #倉庫類別
              #CALL cl_create_qry() RETURNING ima35
               CALL q_imd_1(FALSE,TRUE,"","",g_plant,"","")  #只能开当前门店的
                    RETURNING ima35
              #End Mod No.FUN-AA0055
               DISPLAY BY NAME ima35
               NEXT FIELD ima35
            WHEN INFIELD(ima36)
              #Mod No.FUN-AA0055
              #CALL cl_init_qry_var()
              #LET g_qryparam.form     = "q_ime"
              ##LET g_qryparam.default1 = ima36
              #LET g_qryparam.arg1     = ima35       #倉庫編號 
              #LET g_qryparam.arg2     = 'SW'        #倉庫類別 
              #CALL cl_create_qry() RETURNING ima36
               CALL q_ime_1(FALSE,TRUE,"",ima35,"",g_plant,"","","")
                    RETURNING ima36
              #End Mod No.FUN-AA0055
               DISPLAY BY NAME ima36
               NEXT FIELD ima36
         END CASE

     AFTER INPUT
        IF INT_FLAG THEN
           EXIT INPUT
        END IF

        #IF cl_null(rg1) OR rg1 NOT MATCHES '[123]' THEN
        #   CALL cl_err("rgl",'zta-003',1)
        #   NEXT FIELD rg1
        #END IF

        LET g_rg1 = rg1
        LET g_ima35 = ima35
        IF cl_null(g_ima35) THEN
           LET g_ima35 = ' '
        END IF   
        LET g_ima36 = ima36
        IF cl_null(g_ima36) THEN
           LET g_ima36 = ' '
        END IF   
    
  END INPUT

  CLOSE WINDOW t6201_w

END FUNCTION
#CHI-A40030 add --end--

#FUN-B20089 -----------------------------Begin----------------------------------
 FUNCTION t620_sfv_b1(p_cmd)
  DEFINE p_cmd      LIKE type_file.chr1
  DEFINE l_sfb94    LIKE sfb_file.sfb94
  DEFINE l_qcf02    LIKE qcf_file.qcf02
  DEFINE l_qcf021   LIKE qcf_file.qcf021
  DEFINE l_qcf36    LIKE qcf_file.qcf36
  DEFINE l_qcf37    LIKE qcf_file.qcf37
  DEFINE l_qcf38    LIKE qcf_file.qcf38
  DEFINE l_qcf39    LIKE qcf_file.qcf39
  DEFINE l_qcf40    LIKE qcf_file.qcf40
  DEFINE l_qcf41    LIKE qcf_file.qcf41
  DEFINE l_qcf14    LIKE qcf_file.qcf14
  DEFINE l_qcf09    LIKE qcf_file.qcf09
  DEFINE l_qcfacti  LIKE qcf_file.qcfacti
  DEFINE l_qty_FQC  LIKE sfv_file.sfv09
  DEFINE tmp_qty    LIKE sfv_file.sfv09
  DEFINE l_qde03    LIKE qde_file.qde03
  DEFINE l_n1       LIKE type_file.num5
  DEFINE l_n2       LIKE type_file.num5

  DECLARE t620_pbino_curs CURSOR FOR
     SELECT DISTINCT sfd03,sfb05 FROM sfd_file,sfb_file
      WHERE sfb01 = sfd03 AND sfd01 = g_sfu.sfu08
  CALL g_sfv.clear()
  LET l_ac = 1
  LET g_sfv[l_ac].sfv03 = 1
  LET g_rec_b = 0
  FOREACH t620_pbino_curs INTO g_sfv[l_ac].sfv11,g_sfv[l_ac].sfv04
  #計算可入庫量
     LET l_n1 = 0
     SELECT COUNT(*) INTO l_n1 FROM qcf_file WHERE qcf02 = g_sfv[l_ac].sfv11
     IF cl_null(l_n1) THEN LET l_n1 = 0 END IF
     IF l_n1 > 0 THEN
        DECLARE t620_qcf_b CURSOR FOR
           SELECT qcf01,qcf021 FROM qcf_file WHERE qcf02 = g_sfv[l_ac].sfv11
        FOREACH t620_qcf_b INTO g_sfv[l_ac].sfv17,g_sfv[l_ac].sfv04
           LET l_n2 = 0
           SELECT COUNT(*) INTO l_n2 FROM qde_file WHERE qde01 = g_sfv[l_ac].sfv17 AND qde02 = g_sfv[l_ac].sfv11
           IF l_n2 > 0 THEN
              DECLARE t620_qde_b CURSOR FOR
               SELECT qde01,qde02,qde03,qde05 FROM qde_file WHERE qde01 = g_sfv[l_ac].sfv17 AND qde02 = g_sfv[l_ac].sfv11
              FOREACH t620_qde_b INTO g_sfv[l_ac].sfv17,g_sfv[l_ac].sfv11,l_qde03,g_sfv[l_ac].sfv04
                 SELECT qcf01,qcf02,qcf14,qcfacti,qcf09,qcf36,qcf37,qcf38,qcf39,qcf40,qcf41
                   INTO g_qcf.qcf01,g_qcf.qcf02,l_qcf14,l_qcfacti,l_qcf09,
                        l_qcf36,l_qcf37,l_qcf38,l_qcf39,l_qcf40,l_qcf41
                   FROM qcf_file
                  WHERE qcf01 = g_sfv[l_ac].sfv17
                 IF NOT STATUS THEN
                    LET g_sfv[l_ac].sfv31 = l_qcf37
                    LET g_sfv[l_ac].sfv32 = l_qcf38
                    LET g_sfv[l_ac].sfv33 = l_qcf39
                    LET g_sfv[l_ac].sfv34 = l_qcf40
                    LET g_sfv[l_ac].sfv35 = l_qcf41
                 END IF

                 CALL t620_sfb01(l_ac,p_cmd)

                 SELECT qde05 INTO g_sfv[l_ac].sfv04 FROM qde_file
                  WHERE qde01 = g_sfv[l_ac].sfv17
                    AND qde02 = g_sfv[l_ac].sfv11
                    AND qde03 = l_qde03
                 CALL t620_FQC() RETURNING tmp_qty,l_qty_FQC
                 LET g_sfv[l_ac].sfv09 = l_qty_FQC
                 IF cl_null(g_sfv[l_ac].sfv09) OR g_sfv[l_ac].sfv09 <= 0 THEN
                    CONTINUE FOREACH
                 END IF
                 IF l_ac >1 THEN
                    LET g_sfv[l_ac].sfv03 = g_sfv[l_ac-1].sfv03 + 1
                 END IF
                 LET g_sfv[l_ac].sfv16='Y'
                 CALL t620_ins_sfv()
                 IF g_success = 'N' THEN
                    CONTINUE FOREACH
                 END IF
                 LET l_ac = l_ac + 1
                 IF l_ac > g_max_rec THEN
                    CALL cl_err( '', 9035, 0 )
                    EXIT FOREACH
                 END IF
              END FOREACH
           ELSE
              IF g_argv<>'3' THEN
                  CALL t620_sfv17(p_cmd)
                  IF NOT cl_null(g_errno) THEN
                     CONTINUE FOREACH
                  END IF
              ELSE
                 LET l_n1 = 0
                 SELECT COUNT(*) INTO l_n1 FROM srf_file WHERE srfconf='Y'
                                                            AND srf07='1'
                    AND srf01 = g_sfv[l_ac].sfv17
                 IF SQLCA.sqlcode THEN
                    LET l_n1=0
                    CONTINUE FOREACH
                 END IF
              END IF
              IF NOT t620_sfv11(p_cmd) THEN
                 CONTINUE FOREACH
              END IF
              IF cl_null(g_sfv[l_ac].sfv09) OR g_sfv[l_ac].sfv09 <= 0 THEN
                 CONTINUE FOREACH
              END IF
              IF l_ac >1 THEN
                 LET g_sfv[l_ac].sfv03 = g_sfv[l_ac-1].sfv03 + 1
              END IF
              CALL t620_ins_sfv()
              IF g_success = 'N' THEN
                 CONTINUE FOREACH
              END IF
              LET l_ac = l_ac + 1
              IF l_ac > g_max_rec THEN
                 CALL cl_err( '', 9035, 0 )
                 EXIT FOREACH
              END IF
          END IF
        END FOREACH
     ELSE
        LET g_sfv[l_ac].sfv17 = NULL
        IF NOT t620_sfv11(p_cmd) THEN
           CONTINUE FOREACH
        END IF
        IF cl_null(g_sfv[l_ac].sfv09) OR g_sfv[l_ac].sfv09 <= 0  THEN
           CONTINUE FOREACH
        END IF
        IF l_ac >1 THEN
           LET g_sfv[l_ac].sfv03 = g_sfv[l_ac-1].sfv03 + 1
        END IF
        CALL t620_ins_sfv()
        IF g_success = 'N' THEN
           CONTINUE FOREACH
        END IF
        LET l_ac = l_ac + 1
        IF l_ac > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
     END IF
  END FOREACH

  LET g_rec_b=l_ac - 1
  CALL g_sfv.deleteElement(l_ac)

  DISPLAY g_rec_b TO FORMONLY.cn2
  LET l_ac = 0

 END FUNCTION

 FUNCTION t620_ins_sfv()
  LET g_success = 'Y'
  CALL t620_b_move_back()
  INSERT INTO sfv_file VALUES (b_sfv.*)
  IF SQLCA.sqlcode THEN
     CALL cl_err('ins sfv',SQLCA.sqlcode,1)
     LET g_success = 'N'
    END IF
 END FUNCTION
#FUN-B20089 -----------------------------End------------------------------------

FUNCTION t620_b()
DEFINE
    l_ac_t           LIKE type_file.num5,          #未取消的ARRAY CNT        #No.FUN-680121 SMALLINT
    l_row,l_col      LIKE type_file.num5,          #No:FUN-680121 SMALLINT#分段輸入之行,列數
    l_n,l_cnt        LIKE type_file.num5,          #檢查重複用        #No.FUN-680121 SMALLINT
    l_lock_sw        LIKE type_file.chr1,          #單身鎖住否        #No.FUN-680121 CHAR(1)
    p_cmd            LIKE type_file.chr1,          #處理狀態          #No.FUN-680121 CHAR(1)
    l_b2             LIKE type_file.chr50,         #No:FUN-680121 CHAR(30)
    l_ima35          LIKE ima_file.ima35,          #MOD-5B0100
    l_ima36          LIKE ima_file.ima36,          #MOD-5B0100
    l_sfv09          LIKE sfv_file.sfv09,
    l_qty1           LIKE sfv_file.sfv09,          #TQC-750208 add
    l_qty2           LIKE sfv_file.sfv09,          #TQC-750208 add 
    l_sfb08          LIKE sfb_file.sfb08,
    l_sfb39          LIKE sfb_file.sfb39,
    l_qcf091         LIKE qcf_file.qcf091,
    ll_qcf091        LIKE qcf_file.qcf091,
    l_ecm311         LIKE ecm_file.ecm311,         #No:7834 add
    l_ecm315         LIKE ecm_file.ecm315,         #No:7834 add
    l_ecm_out        LIKE ecm_file.ecm315,         #No:7834 add
    l_qty            LIKE sfv_file.sfv09,          #No:FUN-680121 DECIMAL(15,3)
    l_name           LIKE type_file.chr20,         #No:FUN-680121 CHAR(10)#No:MOD-5B0304 add
    l_qty_FQC        LIKE sfv_file.sfv09,          #No:FUN-680121 DEC(15,3)
    l_bmm01          LIKE bmm_file.bmm01,
    l_allow_insert   LIKE type_file.num5,          #可新增否        #No.FUN-680121 SMALLINT
    l_allow_delete   LIKE type_file.num5,          #可刪除否        #No.FUN-680121 SMALLINT
    l_srg05          LIKE srg_file.srg05,           #TQC-740263 add
    l_pjb25          LIKE pjb_file.pjb25,          #FUN-810045
    l_pja26          LIKE pja_file.pja26           #FUN-810045
DEFINE  l_pjb09      LIKE pjb_file.pjb09           #FUN-850027
DEFINE  l_pjb11      LIKE pjb_file.pjb11           #FUN-850027
#DEFINE  l_azf09      LIKE azf_file.azf09          #FUN-930145  #FUN-CB0087 mark
DEFINE  l_tmp_qcqty  LIKE sfv_file.sfv09           #No:MOD-960289 add
DEFINE  l_bno        LIKE rvbs_file.rvbs08         #No.CHI-9A0022
DEFINE  l_ecm012     LIKE ecm_file.ecm012          #FUN-A50066
DEFINE  l_ecm03      LIKE ecm_file.ecm03           #FUN-A50066
DEFINE l_ima153      LIKE ima_file.ima153      #CHI-AC0023 add
DEFINE l_ima159      LIKE ima_file.ima159      #FUN-B50096
DEFINE l_tf          LIKE type_file.chr1                   #No.FUN-BB0086
DEFINE l_case        STRING                    #No.FUN-BB0086
DEFINE l_sum         LIKE qco_file.qco11       #FUN-BC0104 add
DEFINE l_qcl05       LIKE qcl_file.qcl05       #FUN-BC0104 add
DEFINE l_sfu15_FLAG  LIKE type_file.chr1       #FUN-C30293  #判斷執行單身並確定才將sfu15改為0:已開立(FLAG=Y)，放棄則不改變狀況碼(FLAG=N) 
DEFINE l_ac2         LIKE type_file.num5       #CHI-C30118
DEFINE l_flag        LIKE type_file.chr1       #FUN-CB0087
DEFINE l_where       STRING                    #FUN-CB0087   

    LET g_action_choice = ""
    LET l_sfu15_FLAG = 'Y'  #FUN-C30293

    IF g_sfu.sfu01 IS NULL THEN RETURN END IF
    IF g_sfu.sfupost = 'Y' THEN CALL cl_err('','mfg0175',0) RETURN END IF
    IF g_sfu.sfuconf = 'Y' THEN CALL cl_err('','9023',0) RETURN END IF #FUN-660137
    IF g_sfu.sfuconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF #FUN-660137
    #FUN-A80128  add str ---              
    IF g_sfu.sfu15 matches '[Ss]' THEN
         CALL cl_err('','apm-030',0) #送簽中, 不可修改資料!
         RETURN
    END IF
    IF g_sfu.sfuconf='Y' AND g_sfu.sfu15 = "1" AND g_sfu.sfumksg = "Y"  THEN
       CALL cl_err('','mfg3168',0) #此張單據已核准, 不允許更改或取消
       RETURN
    END IF
    #FUN-A80128  add end ---    

    CALL cl_opmsg('b')
    IF g_argv <> '3' THEN      #No.TQC-710114 
       IF g_prog = 'asft620_icd' THEN   #FUN-970079
          CALL cl_outnam('asft620_icd') RETURNING l_name  #FUN-970079
       ELSE   #FUN-970079
          CALL cl_outnam('asft620') RETURNING l_name    #No:MOD-5B0304 add
       END IF #FUN-970079
    END IF      #No.TQC-710114

    LET g_forupd_sql = "SELECT * FROM sfv_file",
                       " WHERE sfv01= ? AND sfv03= ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t620_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR


    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

    IF g_rec_b=0 THEN CALL g_sfv.clear() END IF

    INPUT ARRAY g_sfv WITHOUT DEFAULTS FROM s_sfv.*

          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF

        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()

            BEGIN WORK

            OPEN t620_cl USING g_sfu.sfu01   #No.TQC-9A0120 mod
            IF STATUS THEN
               CALL cl_err("OPEN t620_cl:", STATUS, 1)
               CLOSE t620_cl
               ROLLBACK WORK
               RETURN
            ELSE
               FETCH t620_cl INTO g_sfu.*          # 鎖住將被更改或取消的資料
               IF SQLCA.sqlcode THEN
                   CALL cl_err(g_sfu.sfu01,SQLCA.sqlcode,0)     # 資料被他人LOCK
                   CLOSE t620_cl ROLLBACK WORK RETURN
               END IF
            END IF

            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_sfv_t.* = g_sfv[l_ac].*  #BACKUP
               OPEN t620_bcl USING g_sfu.sfu01,g_sfv_t.sfv03
               IF STATUS THEN
                  CALL cl_err("OPEN t620_bcl:", STATUS, 1)
                  CLOSE t620_bcl
                  ROLLBACK WORK
                  RETURN
               ELSE
                  FETCH t620_bcl INTO b_sfv.* #FUN-730075
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('lock sfv',SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  ELSE
                     CALL t620_b_move_to() #FUN-730075
                  END IF
                  LET g_sfv[l_ac].gem02c=s_costcenter_desc(g_sfv[l_ac].sfv930) #FUN-670103
                  SELECT sfb_file.* INTO g_sfb.*
                    FROM sfb_file
                   WHERE sfb01 = g_sfv[l_ac].sfv11 #FQC單號

                  IF g_sma.sma104 = 'Y' AND g_sma.sma105 = '1' THEN #認定聯產品的時機點為:1.FQC
                     SELECT qcf_file.* INTO g_qcf.*
                       FROM qcf_file
                      WHERE qcf01 = g_sfv[l_ac].sfv17 #FQC單號

                      SELECT COUNT(*) INTO g_cnt
                        FROM qde_file
                       WHERE qde01 = g_sfv[l_ac].sfv17
                         AND qde02 = g_sfv[l_ac].sfv11
                      IF g_cnt >= 1 THEN
                          LET l_FQC = 'Y'
                      END IF
                  END IF

                  IF g_sma.sma115 = 'Y' THEN
                     IF NOT cl_null(g_sfv[l_ac].sfv04) THEN
                        SELECT ima55 INTO g_ima55
                          FROM ima_file WHERE ima01=g_sfv[l_ac].sfv04

                        CALL s_chk_va_setting(g_sfv[l_ac].sfv04)
                             RETURNING g_flag,g_ima906,g_ima907
                     END IF
                  END IF
                 #str MOD-A60141 add
                  IF NOT cl_null(g_sfv[l_ac].sfv44) THEN
                     LET g_sfv[l_ac].azf03=''
                     SELECT azf03 INTO g_sfv[l_ac].azf03 FROM azf_file
                      WHERE azf01=g_sfv[l_ac].sfv44 AND azf02='2' AND azfacti='Y'
                  END IF
                 #end MOD-A60141 add
 
                  LET g_before_input_done = FALSE
    
                  IF g_sma.sma115='Y' THEN  #MOD-640427
                     CALL t620_set_entry_b('u')
                     CALL t620_set_no_entry_b('u')    
                     CALL t620_set_no_required_b()
                     CALL t620_set_required_b()
                  END IF                    #MOD-640427
                  LET g_before_input_done = TRUE
               END IF
               IF g_argv='3' THEN
                  CALL cl_set_comp_entry("sfv04",FALSE)  
               END IF
              #IF由工單帶入，則不可修改sfv41-43
               IF NOT cl_null(g_sfv[l_ac].sfv11) THEN
                  CALL cl_set_comp_entry("sfv41,sfv42,sfv43,sfv44",FALSE) 
                  IF g_aza.aza115 = 'Y' THEN CALL cl_set_comp_entry("sfv44",TRUE) END IF  #FUN-CB0087
               ELSE
                  CALL cl_set_comp_entry("sfv41,sfv42,sfv43,sfv44",TRUE)  
               END IF
#&ifdef ICD    #FUN-B50096 
               CALL t620_set_no_required_1()   #FUN-A40022
               CALL t620_set_required_1(p_cmd) #FUN-A40022
               CALL t620_set_entry_sfv07()     #FUN-B50096  
               CALL t620_set_no_entry_sfv07()  #FUN-B50096
               #FUN-BC0104---add---str---
               CALL t620_set_noentry_sfv46()       
               IF NOT cl_null(g_sfv[l_ac].sfv46) THEN
                  CALL t620_qcl02_desc()
               END IF
               #FUN-BC0104---add---end---
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF

        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET l_sfu15_FLAG = 'N'  #FUN-C30293
               CANCEL INSERT
            END IF

            CALL t620_b_else()
            IF NOT t620_add_img(g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv05,
                                g_sfv[l_ac].sfv06,g_sfv[l_ac].sfv07,
                                g_sfu.sfu01,      g_sfv[l_ac].sfv03,
                                g_today) THEN

               NEXT FIELD sfv07
            END IF
            IF g_sma.sma115 = 'Y' THEN
               CALL s_chk_va_setting(g_sfv[l_ac].sfv04)
                    RETURNING g_flag,g_ima906,g_ima907
               IF g_flag=1 THEN
                  NEXT FIELD sfv04
               END IF
 
               CASE g_ima906
                  WHEN "2"
                        IF NOT t620_add_imgg(g_sfv[l_ac].sfv33,g_sfv[l_ac].sfv34) THEN    
                           NEXT FIELD sfv33
                        END IF
                  
                        IF NOT  t620_add_imgg(g_sfv[l_ac].sfv30,g_sfv[l_ac].sfv31) THEN    
                           NEXT FIELD sfv30
                        END IF
                   WHEN "3"
                        IF NOT t620_add_imgg(g_sfv[l_ac].sfv33,g_sfv[l_ac].sfv34) THEN    
                           NEXT FIELD sfv33
                        END IF
                END CASE
 
               SELECT img09 INTO g_img09 FROM img_file
                WHERE img01=g_sfv[l_ac].sfv04
                  AND img02=g_sfv[l_ac].sfv05
                  AND img03=g_sfv[l_ac].sfv06
                  AND img04=g_sfv[l_ac].sfv07
               IF cl_null(g_img09) THEN
                  CALL cl_err(g_sfv[l_ac].sfv04,'mfg6069',1)
                  NEXT FIELD sfv04
               END IF
   
               CALL t620_set_origin_field()
               #計算sfv09的值,檢查入庫數量的合理性
               IF g_argv<>'3' THEN #FUN-5C0114
                  CALL t620_check_inventory_qty(l_qty_FQC,l_FQC,l_qcf091)
                      RETURNING g_flag
                  IF g_flag = '1' THEN
                     INITIALIZE g_sfv[l_ac].* TO NULL
                     DISPLAY BY NAME g_sfv[l_ac].*
                     RETURN   #FUN-540055
                  END IF
               END IF
            END IF

            LET g_success='Y'
            IF g_argv='3' THEN
               UPDATE srg_file SET srg11=g_sfu.sfu01
                   WHERE srg01=g_sfv[l_ac].sfv17
                     AND srg02=g_sfv[l_ac].sfv14
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                  LET g_success='N'
                  CALL cl_err('upd srg11','9050',1)
               END IF
            END IF 
            IF s_chk_rvbs(g_sfv[l_ac].sfv41,g_sfv[l_ac].sfv04) THEN
              CALL t620_rvbs(g_sfv[l_ac].sfv03,g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv08,g_sfv[l_ac].sfv09,g_sfv[l_ac].sfv41)
            END IF
            CALL t620_b_move_back() #FUN-730075
            IF g_success='Y' THEN
               INSERT INTO sfv_file VALUES (b_sfv.*)
               #FUN-B70061 --START--
               IF SQLCA.sqlcode THEN
                  CALL cl_err('ins sfv',SQLCA.sqlcode,1)
                  LET g_success='N'
               END IF
               #FUN-B70061 --END--
            END IF
            
            IF g_success='N' THEN #MOD-640180 #FUN-B70061
               LET g_sfv[l_ac].* = g_sfv_t.*
              #CANCEL INSERT   #MOD-BA0106 mark
               SELECT ima918,ima921 INTO g_ima918,g_ima921 
                 FROM ima_file
                WHERE ima01 = g_sfv[l_ac].sfv04
                  AND imaacti = "Y"
               
               IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                 #IF NOT s_lotin_del(g_prog,g_sfu.sfu01,g_sfv[l_ac].sfv03,0,g_sfv[l_ac].sfv04,'DEL') THEN   #No:FUN-860045 #TQC-B90236 mark
                  IF NOT s_lot_del(g_prog,g_sfu.sfu01,g_sfv[l_ac].sfv03,0,g_sfv[l_ac].sfv04,'DEL') THEN   #No:FUN-860045 #TQC-B90236 add
                     CALL cl_err3("del","rvbs_file",g_sfu.sfu01,g_sfv_t.sfv03,
                                   SQLCA.sqlcode,"","",1)
                  END IF
               END IF
               CANCEL INSERT   #MOD-BA0106
            ELSE
               CALL cl_msg('INSERT O.K')
               #FUN-BC0104---add---str
               IF NOT s_iqctype_upd_qco20(g_sfv[l_ac].sfv17,0,0,g_sfv[l_ac].sfv47,'2') THEN
                  CANCEL INSERT 
               END IF
               #FUN-BC0104---add---end
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF

        BEFORE INSERT
            LET p_cmd = 'a'

            LET g_before_input_done = FALSE
            CALL t620_set_entry_b('a')
            CALL t620_set_no_entry_b('a')
            CALL t620_set_no_required_b()
            CALL t620_set_required_b()
            LET g_before_input_done = TRUE

            LET l_n = ARR_COUNT()
            INITIALIZE g_sfv[l_ac].* TO NULL

            LET g_sfv[l_ac].sfv09=0

            LET g_sfv[l_ac].sfv41 = g_sfu.sfu06  #FUN-810045 add
            LET g_sfv[l_ac].sfv16='N'
            LET g_sfv[l_ac].sfv930=s_costcenter(g_sfu.sfu04) #FUN-670103
            LET g_sfv[l_ac].gem02c=s_costcenter_desc(g_sfv[l_ac].sfv930) #FUN-670103
            LET g_sfv_t.* = g_sfv[l_ac].*
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            CALL cl_set_comp_required('sfv46,sfv47',FALSE)       #FUN-BC0104 add 
            CALL cl_set_comp_entry('sfv46,sfv47',TRUE)     #FUN-BC0104 add
            NEXT FIELD sfv03

        BEFORE FIELD sfv03                            #default 序號
            IF g_sfv[l_ac].sfv03 IS NULL OR g_sfv[l_ac].sfv03 = 0 THEN
                SELECT max(sfv03)+1 INTO g_sfv[l_ac].sfv03
                  FROM sfv_file WHERE sfv01 = g_sfu.sfu01
                IF g_sfv[l_ac].sfv03 IS NULL THEN
                    LET g_sfv[l_ac].sfv03 = 1
                     DISPLAY BY NAME g_sfv[l_ac].sfv03 #MOD-4A0260
                END IF
            END IF
            #FUN-BC0104---add---str---
            IF p_cmd = 'a' THEN
              CALL cl_set_comp_required('sfv46,sfv47',FALSE)               
              CALL cl_set_comp_entry('sfv46,sfv47',TRUE) 
            END IF
           #FUN-BC0104---add---end---

        AFTER FIELD sfv03                        #check 序號是否重複
            IF NOT cl_null(g_sfv[l_ac].sfv03) THEN
               IF g_sfv[l_ac].sfv03 != g_sfv_t.sfv03 OR
                  g_sfv_t.sfv03 IS NULL THEN
                   SELECT count(*) INTO l_n FROM sfv_file
                       WHERE sfv01 = g_sfu.sfu01 AND sfv03 = g_sfv[l_ac].sfv03
                   IF l_n > 0 THEN
                       LET g_sfv[l_ac].sfv03 = g_sfv_t.sfv03
                        DISPLAY BY NAME g_sfv[l_ac].sfv03 #MOD-4A0260
                       CALL cl_err('',-239,0) NEXT FIELD sfv03
                   END IF
               END IF
            END IF

        AFTER FIELD sfv17
          IF NOT cl_null(g_sfv[l_ac].sfv17) THEN
             IF g_sfv[l_ac].sfv17 != g_sfv_t.sfv17 OR
                g_sfv_t.sfv17 IS NULL THEN
                 IF g_argv<>'3' THEN #FUN-5C0114
                     CALL t620_sfv17(p_cmd)
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err('',g_errno,1)
                        NEXT FIELD sfv17
                     END IF
                 ELSE
                     IF NOT t620_asr_sfv17() THEN
                        NEXT FIELD sfv17
                     END IF
                 END IF
               IF NOT t620_sfv11(p_cmd) THEN
                  NEXT FIELD sfv17
               END IF 
             END IF       #No:MOD-950119 add
             #FUN-BC0104---add---str---
             IF p_cmd = 'a' THEN
                CALL t620_sfv46_check() 
             END IF
             #FUN-BC0104---add---end---
          END IF

        AFTER FIELD sfv14
           IF g_argv='3' THEN
              IF NOT t620_asr_sfv14() THEN
                 NEXT FIELD sfv14
              END IF
           END IF
 
        BEFORE FIELD sfv11     #工單號碼
           IF g_argv<>'3' THEN #FUN-5C0114
              CALL t620_set_entry_b('u')
           END IF
#&ifdef ICD   #FUN-B50096
           CALL t620_set_no_required_1()  #FUN-A40022
#&endif       #FUN-B50096
           CALL t620_set_entry_sfv07()    #FUN-B50096
        #--

        AFTER FIELD sfv11     #工單號碼
           #MOD-6C0082 程式碼移至 t620_sfv11()
           IF NOT t620_sfv11(p_cmd) THEN
              NEXT FIELD sfv11
           END IF 
#&ifdef ICD   #FUN-B50096
           #FUN-A40022--begin--add-------------
           IF NOT cl_null(g_sfv[l_ac].sfv04) THEN
#FUN-B50096 -------------------Begin-------------------
           #  SELECT imaicd13 INTO l_imaicd13 FROM imaicd_file
           #   WHERE imaicd00 = g_sfv[l_ac].sfv04
           #  IF l_imaicd13 = 'Y' THEN
              SELECT ima159 INTO l_ima159 FROM ima_file
               WHERE ima01 = g_sfv[l_ac].sfv04
              IF l_ima159 = '1' THEN
#FUN-B50096 -------------------End---------------------
                 CALL cl_set_comp_required("sfv07",TRUE)
              END IF
           END IF
           #FUN-A40022--end--add--------------
           CALL t620_set_no_entry_sfv07()   #FUN-B50096
           #MOD-C30084--begin
           IF p_cmd='u' AND g_sfv[l_ac].sfv11 !=g_sfv_t.sfv11 AND g_sfv[l_ac].sfv09>0 THEN
              IF NOT t620_sfv09_check1() THEN
                 NEXT FIELD sfv09
              END IF 
           END IF 
           #MOD-C30084--end          
           
        #FUN-BC0104---add---str
        BEFORE FIELD sfv46
           CALL t620_set_entry_b(p_cmd)
  
        AFTER FIELD sfv46
           IF NOT cl_null(g_sfv[l_ac].sfv46) AND p_cmd = 'a' THEN
              IF NOT t620_sfv46_47_check() THEN
                 CALL cl_err(g_sfv[l_ac].sfv46,'apm-808',0)
                 NEXT FIELD sfv46
              END IF
              #FUN-CC0013 mark begin---
              #LET l_n = 0
              #SELECT COUNT(*) INTO l_n FROM qco_file,qcf_file,
              #                              qcl_file
              #                        WHERE qco01 = g_sfv[l_ac].sfv17 
              #                        AND   qcf00 = '1' 
              #                        AND   qcf01 = qco01 
              #                        AND   qcf14 = 'Y'
              #                        AND   qco03 = g_sfv[l_ac].sfv46
              #                        AND   qcl01 = qco03
              #                        AND   qcl05 = '3'
              #IF l_n > 0 THEN
              #   CALL cl_err('','apm-806',0)
              #   NEXT FIELD sfv46
              #END IF
              #FUN-CC0013 mark end-----
               CALL t620_set_comp_required(g_sfv[l_ac].sfv46,g_sfv[l_ac].sfv47)
               CALL t620_qcl02_desc()
               CALL t620_set_no_entry_b(p_cmd)
               
               IF NOT cl_null(g_sfv[l_ac].sfv46) AND NOT cl_null(g_sfv[l_ac].sfv47) THEN
                  CALL t620_qco_show()
                  CALL t620_qcl05_check() RETURNING l_qcl05
                  IF (l_qcl05 = '0' OR l_qcl05 = '2') AND g_sma.sma115='N' THEN    #TQC-C30013
                     LET l_case = ''
                     CALL t620_sfv09(p_cmd) RETURNING l_case
                     CASE l_case
                       WHEN "sfv09"
                         NEXT FIELD sfv09
                       WHEN "sfv03"
                         NEXT FIELD sfv03
                       WHEN "sfv17"
                         NEXT FIELD sfv17
                       OTHERWISE EXIT CASE
                     END CASE
                  END IF
               END IF
               
           END IF 

        AFTER FIELD sfv47
           IF NOT cl_null(g_sfv[l_ac].sfv47) AND p_cmd = 'a' THEN
              IF NOT t620_sfv46_47_check() THEN
                 CALL cl_err(g_sfv[l_ac].sfv47,'apm-808',0)
                 NEXT FIELD sfv47 
              END IF 
              LET l_n = 0
              SELECT COUNT(*) INTO l_n FROM qco_file,qcf_file,
                                             qcl_file
                                       WHERE qco01 = g_sfv[l_ac].sfv17 
                                       AND   qcf00 = '1' 
                                       AND   qcf01 = qco01 
                                       AND   qcf14 = 'Y'
                                       AND   qco04 = g_sfv[l_ac].sfv47
                                       AND   qcl01 = qco03
                                      #AND   qcl05 <> '3'     #FUN-CC0013 mark
               IF l_n = 0 THEN
                  CALL cl_err('','apm-807',0)
                  NEXT FIELD sfv47
               END IF
               CALL t620_set_comp_required(g_sfv[l_ac].sfv46,g_sfv[l_ac].sfv47)
               CALL t620_set_entry_b(p_cmd) 
               IF NOT cl_null(g_sfv[l_ac].sfv46) AND NOT cl_null(g_sfv[l_ac].sfv47) THEN
                  CALL t620_qco_show() 
                  CALL t620_qcl05_check() RETURNING l_qcl05
                  IF (l_qcl05 = '0' OR l_qcl05 = '2') AND g_sma.sma115='N' THEN   #TQC-C30013
                     LET l_case = ''
                     CALL t620_sfv09(p_cmd) RETURNING l_case
                     CASE l_case
                       WHEN "sfv09"
                         NEXT FIELD sfv09
                       WHEN "sfv03"
                         NEXT FIELD sfv03
                       WHEN "sfv17"
                         NEXT FIELD sfv17
                       OTHERWISE EXIT CASE
                     END CASE
                  END IF
               END IF 
            END IF 
        #FUN-BC0104---add---end

        BEFORE FIELD sfv04
           CALL t620_set_entry_b('a')
           CALL t620_set_no_required_b()
#&ifdef ICD     #FUN-B50096  
           CALL t620_set_no_required_1()   #FUN-A40022
           CALL t620_set_entry_sfv07()     #FUN-B50096
        #---->聯產品控管 NO:6872
        AFTER FIELD sfv04 #料號
          IF g_argv<>'3' THEN #FUN-5C0114
#FUN-AA0059 ---------------------start----------------------------
            IF NOT cl_null(g_sfv[l_ac].sfv04) THEN
               IF NOT s_chk_item_no(g_sfv[l_ac].sfv04,"") THEN
                  CALL cl_err('',g_errno,1)
                  LET g_sfv[l_ac].sfv04= g_sfv_t.sfv04
                  NEXT FIELD sfv04
               END IF
            END IF
#FUN-AA0059 ---------------------end-------------------------------
            IF NOT cl_null(g_sfv[l_ac].sfv16) THEN
               IF g_sfv[l_ac].sfv16 = 'Y' THEN
                 #MOD-CB0188---add---S
                  IF g_sfv[l_ac].sfv11 IS NOT NULL THEN
                     SELECT ima903 INTO g_ima.ima903
                       FROM ima_file,sfb_file
                      WHERE sfb01 = g_sfv[l_ac].sfv11
                        AND ima01 = g_sfb.sfb05
                  END IF
                 #MOD-CB0188---add---E
                  IF g_sma.sma105 = '1' AND g_ima.ima903 = 'Y' THEN #認定聯產品的時機點為:1.FQC
                     CALL t620_sfv04_1('a')
                  END IF
                  IF g_sma.sma105 = '2' AND g_ima.ima903 = 'Y' THEN #認定聯產品的時機點為:2.完工入庫
                     CALL t620_sfv04_2('a')
                  END IF
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_sfv[l_ac].sfv04,g_errno,0)
                     LET g_sfv[l_ac].sfv04 = g_sfv_t.sfv04
                      DISPLAY BY NAME g_sfv[l_ac].sfv04 #MOD-4A0260
                     NEXT FIELD sfv04
                  END IF
               END IF
            END IF
            IF g_sma.sma115 ='Y' THEN
               IF NOT cl_null(g_sfv[l_ac].sfv04) THEN
                  SELECT ima55 INTO g_ima55
                    FROM ima_file WHERE ima01=g_sfv[l_ac].sfv04
                  CALL s_chk_va_setting(g_sfv[l_ac].sfv04)
                      RETURNING g_flag,g_ima906,g_ima907
                  IF g_flag=1 THEN
                     NEXT FIELD sfv04
                  END IF
                  IF g_ima906 = '3' THEN
                     LET g_sfv[l_ac].sfv33=g_ima907
                  END IF
               END IF
               CALL t620_set_no_entry_b('a')
               CALL t620_set_required_b()
            END IF
          END IF
#&ifdef ICD    #FUN-B50096
          CALL t620_set_required_1(p_cmd) #FUN-A40022
          CALL t620_set_no_entry_sfv07()  #FUN-B50096
 
        AFTER FIELD sfv05     #倉庫
           IF NOT cl_null(g_sfv[l_ac].sfv05) THEN
              #FUN-D20060----add---str--
              IF NOT s_chksmz(g_sfv[l_ac].sfv04, g_sfu.sfu01,
                              g_sfv[l_ac].sfv05, g_sfv[l_ac].sfv06) THEN
                 NEXT FIELD sfv05
              END IF
              #FUN-D20060----add---end--
              IF g_argv MATCHES '[123]' THEN #FUN-5C0114 add '3'
                 SELECT imd02 INTO g_buf FROM imd_file
                  WHERE imd01=g_sfv[l_ac].sfv05 AND (imd10='S' OR imd10='W')  #MOD-8B0227
                     AND imdacti = 'Y' #MOD-4B0169
                 IF STATUS THEN
                    CALL cl_err('imd','mfg1100',0)
                    NEXT FIELD sfv05
                 END IF
              END IF
              #Add No.FUN-AA0055
              IF NOT s_chk_ware(g_sfv[l_ac].sfv05) THEN  #检查仓库是否属于当前门店
                 NEXT FIELD sfv05
              END IF
              #End Add No.FUN-AA0055
              #FUN-BC0104---add---str---
              IF NOT cl_null(g_sfv[l_ac].sfv46) THEN
                 IF NOT t620_sfv05_check() THEN
                    CALL cl_err('','aqc-524',0)
                    NEXT FIELD sfv05
                 END IF 
              END IF 
              #FUN-BC0104---add---end---
           END IF
          #TQC-D50124 -------Begin------
          ##FUN-D40103 ------Begin-------
          #IF NOT s_imechk(g_sfv[l_ac].sfv05,g_sfv[l_ac].sfv06) THEN
          #   NEXT FIELD sfv06 
          #END IF
          ##FUN-D40103 ------End---------
        #TQC-D50124 -------End--------

        AFTER FIELD sfv06    #儲位
           #控管是否為全型空白
           IF g_sfv[l_ac].sfv06 = '　' THEN #全型空白
               LET g_sfv[l_ac].sfv06 = ' '
                DISPLAY BY NAME g_sfv[l_ac].sfv06 #MOD-4A0260
           END IF
           IF g_argv MATCHES '[123]' THEN #FUN-5C0114 add '3'
              IF cl_null(g_sfv[l_ac].sfv06) THEN
                 LET g_sfv[l_ac].sfv06 = ' '
                  DISPLAY BY NAME g_sfv[l_ac].sfv06 #MOD-4A0260
              END IF
              #------------------------------------ 檢查料號預設倉儲及單別預設倉儲
              IF NOT cl_null(g_sfv[l_ac].sfv05) THEN  #FUN-D20060 add
                 IF NOT s_chksmz(g_sfv[l_ac].sfv04, g_sfu.sfu01,
                                 g_sfv[l_ac].sfv05, g_sfv[l_ac].sfv06) THEN
                    NEXT FIELD sfv05
                 END IF
              END IF  #FUN-D20060 add
              #------------------------------------- 970910 sophia
           END IF
        #FUN-B50096 -------------Begin---------------
           IF NOT cl_null(g_sfv[l_ac].sfv04) THEN
              SELECT ima159 INTO l_ima159 FROM ima_file
               WHERE ima01 = g_sfv[l_ac].sfv04
              IF l_ima159 = '2' THEN
                 CASE t620_b_sfv07_inschk(p_cmd)
                    WHEN "sfv05" NEXT FIELD sfv05
                    WHEN "sfv07" NEXT FIELD sfv06
                 END CASE
              END IF
           END IF  
        #FUN-B50096 -------------End-----------------

           #TQC-D50124 -------Begin--------
        ##FUN-D40103 ------Begin-------
        #  IF NOT s_imechk(g_sfv[l_ac].sfv05,g_sfv[l_ac].sfv06) THEN
        #     NEXT FIELD sfv06
        #  END IF
        ##FUN-D40103 ------End---------
       #TQC-D50124 -------End--------
        AFTER FIELD sfv07    #批號

        #FUN-B50096 -------Begin-----------
           CASE t620_b_sfv07_inschk(p_cmd)
              WHEN "sfv05" NEXT FIELD sfv05
              WHEN "sfv07" NEXT FIELD sfv07
           END CASE
        #FUN-B50096 -------End-------------
         #TQC-D50124 ------Begin------
        ##FUN-D40103 ------Begin-------
        #  IF NOT cl_null(g_sfv[l_ac].sfv05) THEN
        #     IF NOT s_imechk(g_sfv[l_ac].sfv05,g_sfv[l_ac].sfv06) THEN
        #        NEXT FIELD sfv05
        #     END IF
        #  END IF
        ##FUN-D40103 ------End---------
      #TQC-D50124 ------End--------
#FUN-B50096 -------------------Begin------------------------
#           #控管是否為全型空白
#           IF g_sfv[l_ac].sfv07 = '　' THEN #全型空白
#               LET g_sfv[l_ac].sfv07 = ' '
#                DISPLAY BY NAME g_sfv[l_ac].sfv07 #MOD-4A0260
#           END IF
#&ifdef ICD                                                                                                                          
#           #FUN-A40022----begin--add--------------- 
#            IF NOT cl_null(g_sfv[l_ac].sfv04) THEN 
#               LET l_imaicd13=''
#               SELECT imaicd13 INTO l_imaicd13
#                 FROM imaicd_file
#                WHERE imaicd00 = g_sfv[l_ac].sfv04
#               IF l_imaicd13 = 'Y' AND cl_null(g_sfv[l_ac].sfv07) THEN
#                  CALL cl_err(g_sfv[l_ac].sfv04,'aim-034',1)
#                  NEXT FIELD sfv07
#               END IF
#            END IF
#            #FUN-A40022--end--add------------------
#&endif
#           IF g_argv MATCHES '[123]' THEN #FUN-5C0114 add '3'
#              IF cl_null(g_sfv[l_ac].sfv07) THEN
#                 LET g_sfv[l_ac].sfv07 = ' '
#                  DISPLAY BY NAME g_sfv[l_ac].sfv07 #MOD-4A0260
#              END IF
#              IF NOT cl_null(g_sfv[l_ac].sfv05) THEN
#                #將整段包成一個FUNCTION
#                IF NOT t620_add_img(g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv05,
#                                    g_sfv[l_ac].sfv06,g_sfv[l_ac].sfv07,
#                                    g_sfu.sfu01,      g_sfv[l_ac].sfv03,
#                                    g_today) THEN
#
#                   NEXT FIELD sfv05
#                END IF
#              IF g_sma.sma115 ='N' THEN
#                 IF cl_null(g_sfv[l_ac].sfv08) THEN   #若單位空白
#                    LET g_sfv[l_ac].sfv08=g_img09
#                     DISPLAY BY NAME g_sfv[l_ac].sfv08 #MOD-4A0260
#                 END IF
#              ELSE
#                 SELECT COUNT(*) INTO g_cnt FROM img_file
#                  WHERE img01 = g_sfv[l_ac].sfv04   #料號
#                    AND img02 = g_sfv[l_ac].sfv05   #倉庫
#                    AND img03 = g_sfv[l_ac].sfv06   #儲位
#                    AND img04 = g_sfv[l_ac].sfv07   #批號
#                    AND img18 < g_sfu.sfu02   #調撥日期
#                 IF g_cnt > 0 THEN    #大於有效日期
#                    call cl_err('','aim-400',0)   #須修改
#                    NEXT FIELD sfv05 #MOD-590236
#                 END IF
#
#                # - FQC入庫不做雙單位處理
#                 IF cl_null(g_sfv[l_ac].sfv17) OR (g_argv='3') THEN  #FUN-5C0114 add OR (g_argv='3')
#                    CALL t620_du_default(p_cmd)
#                 ELSE
#                    CALL s_du_umfchk(g_sfv[l_ac].sfv04,'','','',
#                                     g_ima55,g_sfv[l_ac].sfv30,'1')
#                         RETURNING g_errno,g_factor
#                    IF NOT cl_null(g_errno) THEN
#                       CALL cl_err(g_sfv[l_ac].sfv30,g_errno,1)
#                       NEXT FIELD sfv07
#                    END IF
#                    LET g_sfv[l_ac].sfv31 = g_factor
#                    DISPLAY BY NAME g_sfv[l_ac].sfv31
#                 END IF
#              END IF
#              END IF
#           END IF
#FUN-B50096 -------------------End--------------------------

        BEFORE FIELD sfv09    #入庫量
          IF g_argv<>'3' THEN #FUN-5C0114
            IF NOT cl_null(g_sfv[l_ac].sfv09) THEN
               IF l_FQC = 'Y' THEN
                   CALL t620_FQC() RETURNING tmp_qty,l_qty_FQC #check 數量的勾稽
                   LET g_sfv[l_ac].sfv09 = l_qty_FQC
                    DISPLAY BY NAME g_sfv[l_ac].sfv09 #MOD-4A0260
                   LET g_msg=""
                   LET g_msg=g_msg CLIPPED,
                             g_x[2] CLIPPED,tmp_qty USING '############.###',    #已登打入庫量     #No:MOD-770048 modify  #No:MOD-970035 modify
                             g_x[3] CLIPPED,l_qty_FQC USING '############.###' #可入庫量    #No:MOD-970035 modify
               END IF
               IF g_sfb.sfb39 !='2' THEN    #No:7834 add
                  ERROR g_msg
               END IF
            END IF
          END IF

        AFTER FIELD sfv09    #入庫量
#FUN-BC0104---add---str---
           LET l_case = ''
           CALL t620_sfv09(p_cmd) RETURNING l_case
           CASE l_case
            WHEN "sfv09"
               NEXT FIELD sfv09
            WHEN "sfv03"
               NEXT FIELD sfv03
            WHEN "sfv17"
               NEXT FIELD sfv17
            OTHERWISE EXIT CASE
           END CASE 
#FUN-BC0104---add---end--- 
#########FUN-BC0104---mark---str##########
#          #No.FUN-BB0086--add--start--
#          IF NOT cl_null(g_sfv[l_ac].sfv09) AND NOT cl_null(g_sfv[l_ac].sfv08) THEN
#             IF cl_null(g_sfv_t.sfv09) OR g_sfv_t.sfv09 != g_sfv[l_ac].sfv09 THEN
#             LET g_sfv[l_ac].sfv09=s_digqty(g_sfv[l_ac].sfv09, g_sfv[l_ac].sfv08)
#             DISPLAY BY NAME g_sfv[l_ac].sfv09
#             END IF
#          END IF
#          #No.FUN-BB0086--add--end--
#          IF (NOT cl_null(g_sfv[l_ac].sfv09)) AND (g_argv<>'3') THEN  #FUN-5C0114 add g_argv<>'3'
#             IF g_sfv[l_ac].sfv09 <= 0 THEN
#                LET g_sfv[l_ac].sfv09 = 0
#                 DISPLAY BY NAME g_sfv[l_ac].sfv09 #MOD-4A0260
#                NEXT FIELD sfv09
#             END IF
#
#    #------->聯產品 NO:6872
#             IF l_FQC = 'Y' THEN
#                 IF g_sfv[l_ac].sfv09 > l_qty_FQC THEN
#                     NEXT FIELD sfv09
#                 END IF
#             ELSE
#    ##---------------------------------------------------
#                 IF g_argv MATCHES '[12]' THEN   #入庫,退回
#                    SELECT sfb08,sfb09 INTO l_sfb08,l_sfv09 FROM sfb_file
#                     WHERE sfb01 = g_sfv[l_ac].sfv11
#                    IF l_sfv09 IS NULL THEN LET l_sfv09 = 0 END IF
#                    IF l_sfb08 IS NULL THEN LET l_sfb08 = 0 END IF
#                    IF g_argv = '2' THEN   #退庫時不可大於入庫數量
#                       IF g_sfv[l_ac].sfv09 > l_sfv09 THEN
#                          CALL cl_err(g_sfv[l_ac].sfv09,'asf-712',1)
#                          NEXT FIELD sfv09
#                       END IF
#                    END IF
#                 END IF
#             ##----------------------------------------
#                #工單完工方式為'2' pull
#                 IF g_argv = '1' AND g_sfv[l_ac].sfv09 > 0  AND
#                    g_sfb.sfb39 <> '2' THEN
#                  # check 入庫數量 不可 大於 (生產數量-完工數量)
#                    IF g_sfb.sfb93!='Y'THEN
#                       IF (g_sfv[l_ac].sfv09 > l_sfb08 - l_sfv09 + g_over_qty ) THEN
#                             CALL cl_err(g_sfv[l_ac].sfv09,'asf-714',1)
#                             NEXT FIELD sfv09
#                       END IF
# sma73    工單完工數量是否檢查發料最小套數
# sma74    工單完工量容許差異百分比
#                       # sum(已存在入庫單入庫數量) by W/O (不管有無過帳)
#                       SELECT SUM(sfv09) INTO tmp_qty FROM sfv_file,sfu_file
#                        WHERE sfv11 = g_sfv[l_ac].sfv11
#                          AND sfv01 = sfu01
#                          AND sfu00 = '1'   #類別 1.入庫  2.入庫退回
#                          AND (sfv01 != g_sfu.sfu01 OR                                                                             
#                              (sfv01 = g_sfu.sfu01 AND sfv03 != g_sfv[l_ac].sfv03))                                                
#                          AND sfuconf <> 'X' #FUN-660137
#                       
#                       IF tmp_qty IS NULL OR SQLCA.sqlcode THEN LET tmp_qty=0 END IF
#                       #入庫量不可大於最小套數-以keyin 入庫量
#                       IF g_sma.sma73='Y' AND (g_sfv[l_ac].sfv09) > (g_min_set-tmp_qty) THEN
#                          CALL cl_err(g_sfv[l_ac].sfv09,'asf-675',1)
#                          NEXT FIELD sfv09
#                       END IF
#                    END IF
#
#                    IF g_sfb.sfb93='Y' THEN # 走製程 check 轉出量
#                      #MOD-A90152---add---start---
#                       LET g_ecm311 = 0   
#                       LET g_ecm315 = 0
#                       CALL s_schdat_max_ecm03(g_sfv[l_ac].sfv11) RETURNING l_ecm012,l_ecm03  #TQC-AC0277
#                       SELECT ecm311,ecm315 INTO g_ecm311,g_ecm315 FROM ecm_file
#                        WHERE ecm01=g_sfv[l_ac].sfv11
#                         #AND ecm03= (SELECT MAX(ecm03) FROM ecm_file #TQC-AC0277
#                         #             WHERE ecm01=g_sfv[l_ac].sfv11) #TQC-AC0277
#                          AND ecm012= l_ecm012  #TQC-AC0277
#                          AND ecm03 = l_ecm03   #TQC-AC0277
#                       IF STATUS THEN LET g_ecm311=0 END IF
#                       IF STATUS THEN LET g_ecm315=0 END IF
#                       LET g_ecm_out = g_ecm311 + g_ecm315
#                       IF cl_null(tmp_qty) THEN LET tmp_qty = 0 END IF
#                      #MOD-A90152---add---end---
#                       IF g_sfv[l_ac].sfv09 > g_ecm_out - tmp_qty THEN
#                          IF NOT t620_chk_auto_report(g_sfv[l_ac].sfv11,g_sfv[l_ac].sfv09) THEN  #FUN-A80102
#                             CALL cl_err(g_sfv[l_ac].sfv09,'asf-675',1)
#                             NEXT FIELD sfv09
#                          END IF
#                       END IF
#                       IF g_sma.sma73='Y' AND (g_sfv[l_ac].sfv09) > (g_min_set+g_ecm315-tmp_qty) THEN
#                          CALL cl_err(g_sfv[l_ac].sfv09,'asf-675',1)
#                          NEXT FIELD sfv09
#                       END IF
#                    END IF

#                    IF g_sfb.sfb94 = 'Y' AND g_sma.sma896 = 'Y' THEN
#                       SELECT qcf091 INTO l_qcf091 FROM qcf_file   
#                          WHERE qcf01 = g_sfv[l_ac].sfv17
#                            AND qcf09 <> '2'   
#                            AND qcf14 = 'Y'
#                       IF STATUS OR l_qcf091 IS NULL THEN
#                          LET l_qcf091 = 0
#                       END IF
#                  
#                       SELECT SUM(sfv09) INTO l_tmp_qcqty FROM sfv_file,sfu_file
#                        WHERE sfv11 = g_sfv[l_ac].sfv11
#                          AND sfv17 = g_sfv[l_ac].sfv17
#                          AND sfv01 = sfu01
#                          AND sfu00 = '1'  
#                          AND (sfv01 != g_sfu.sfu01 OR                                                                             
#                              (sfv01 = g_sfu.sfu01 AND sfv03 != g_sfv[l_ac].sfv03))                                                
#                          AND sfuconf <> 'X' 
#                          IF cl_null(l_tmp_qcqty) THEN LET l_tmp_qcqty = 0 END IF
#                    END IF

#                    #IF g_sfb.sfb94='Y' AND #是否使用FQC功能
#                    IF g_sfb.sfb94='Y' AND g_sma.sma896='Y' AND
#                       (g_sfv[l_ac].sfv09) > l_qcf091 - l_tmp_qcqty       #No:MOD-960289 modify
#                       THEN
#                       #----FQC No.不為null,入庫量不可大於FQC量-以keyin 入庫量
#                       CALL cl_err(g_sfv[l_ac].sfv09,'asf-675',1)
#                       NEXT FIELD sfv09
#                    END IF
#                 END IF
##--------------------------------------------------
#No:7834      工單完工方式為'2' pull(sfb39='2')&走製程(sfb93='Y')
#                 IF g_argv = '1' AND g_sfv[l_ac].sfv09 > 0  AND
#                    g_sfb.sfb39= '2' THEN
#                    CALL s_schdat_max_ecm03(g_sfv[l_ac].sfv11) RETURNING l_ecm012,l_ecm03  #FUN-A50066
#                   #check 最終製程之總轉出量(良品轉出量+Bonus)
#                    SELECT ecm311,ecm315 INTO l_ecm311,l_ecm315 FROM ecm_file
#                     WHERE ecm01=g_sfv[l_ac].sfv11
#                      #AND ecm03= (SELECT MAX(ecm03) FROM ecm_file      #No:MOD-5B0302 add #FUN-A50066
#                      #             WHERE ecm01=g_sfv[l_ac].sfv11)                         #FUN-A50066
#                       AND ecm012= l_ecm012  #FUN-A50066
#                       AND ecm03 = l_ecm03   #FUN-A50066
#                    IF SQLCA.sqlcode THEN
#                       LET l_ecm311=0
#                       LET l_ecm315=0
#                    END IF
#                    LET l_ecm_out=l_ecm311 + l_ecm315
#

#                    LET l_sfv09=0     #已key之入庫量(不分是否已過帳)
#                    SELECT SUM(sfv09) INTO l_qty1 FROM sfv_file,sfu_file
#                     WHERE sfv11 = g_sfv[l_ac].sfv11
#                       AND sfv01 ! = g_sfu.sfu01  
#                       AND sfv01 = sfu01
#                       AND sfu00 = '1'           #完工入庫
#                      #AND sfupost <> 'X'  #MOD-A40043 mark
#                       AND sfuconf <> 'X'  #MOD-A40043
#                    IF l_qty1 IS NULL THEN LET l_qty1 =0 END IF

#                    SELECT SUM(sfv09) INTO l_qty2 FROM sfv_file,sfu_file
#                     WHERE sfv11 = g_sfv[l_ac].sfv11
#                       AND sfv01 = g_sfu.sfu01   
#                       AND sfv03!= g_sfv[l_ac].sfv03
#                       AND sfv01 = sfu01
#                       AND sfu00 = '1'           #完工入庫
#                      #AND sfupost <> 'X'  #MOD-A40043 mark
#                       AND sfuconf <> 'X'  #MOD-A40043
#                    IF l_qty2 IS NULL THEN LET l_qty2 =0 END IF

#                    LET l_sfv09 = l_qty1 + l_qty2 + g_sfv[l_ac].sfv09

#                   IF g_sfb.sfb93 = 'Y' THEN
#                      #入庫量 > 製程最後轉出量
#                      IF l_sfv09 > l_ecm_out THEN
#                         LET g_msg ="(",l_sfv09   USING '############.###','>',    #No:MOD-970035 modify
#                                    l_ecm_out USING '############.###',")"         #No:MOD-970035 modify
#                         IF NOT t620_chk_auto_report(g_sfv[l_ac].sfv11,g_sfv[l_ac].sfv09) THEN  #FUN-A80102
#                            CALL cl_err(g_msg,'asf-675',1)
#                            NEXT FIELD sfv09
#                         END IF
#                      END IF
#                   ELSE
#                      #CHI-AC0023 add --start--
#                      CALL s_get_ima153(g_sfv[l_ac].sfv04) RETURNING l_ima153    
#                      CALL s_minp(g_sfv[l_ac].sfv11,g_sma.sma73,l_ima153,'','','') RETURNING g_cnt,l_sfb08
#                      #CHI-AC0023 add --end--
#                      IF l_sfv09 > l_sfb08 THEN
#                         LET g_msg ="(",l_sfv09   USING '############.###','>',  #No:MOD-970035 modify
#                                    l_sfb08 USING '############.###',")"         #No:MOD-970035 modify
#                         CALL cl_err(g_msg,'asf-675',1)
#                         NEXT FIELD sfv09
#                      END IF
#                   END IF
#                 END IF
#                 IF g_argv = '2' AND g_sfv[l_ac].sfv09 > 0  AND
#                    g_sfv[l_ac].sfv09> g_sfb.sfb09 - tmp_qty
#                 THEN
#                    #----退回量不可大於完工入庫量
#                    CALL cl_err(g_sfv[l_ac].sfv09,'asf-712',1)
#                    NEXT FIELD sfv09
#                 END IF
#              END IF #--->聯產品END
#          END IF
#          #當入庫單是由asft300生產報工產生的,在修改單身的入庫數量時要檢查
#          #與報工單身的良品數應一致,兩邊若不match則顯示訊息
#          LET l_cnt = 0
#          SELECT COUNT(*) INTO l_cnt FROM srg_file 
#           WHERE srg11=g_sfu.sfu01 AND srg14=g_sfv[l_ac].sfv04
#             AND srg16 = g_sfv[l_ac].sfv11   #MOD-920158 add
#          IF l_cnt != 0 THEN
#             SELECT SUM(srg05) INTO l_srg05 FROM srg_file    #No.MOD-950133    
#              WHERE srg11=g_sfu.sfu01 AND srg14=g_sfv[l_ac].sfv04
#             AND srg16 = g_sfv[l_ac].sfv11   #MOD-920158 add
#             IF g_sfv[l_ac].sfv09 > l_srg05 THEN
#                CALL cl_err(g_sfv[l_ac].sfv09,'asr-033',1)
#                NEXT FIELD sfv09
#             END IF
#             IF g_sfv[l_ac].sfv09 < l_srg05 THEN
#                CALL cl_err(g_sfv[l_ac].sfv09,'asr-050',0)
#             END IF
#          END IF
#          IF (NOT cl_null(g_sfv[l_ac].sfv09)) AND (g_argv='3') THEN
#             IF cl_null(g_sfv[l_ac].sfv03) THEN
#                NEXT FIELD sfv03
#             END IF
#             IF NOT t620_asrchk_sfv09(g_sfv[l_ac].sfv17,
#                                      g_sfv[l_ac].sfv14,
#                                      g_sfv[l_ac].sfv09) THEN
#                NEXT FIELD sfv17
#             END IF
#          END IF
#          SELECT ima918,ima921 INTO g_ima918,g_ima921 
#            FROM ima_file
#           WHERE ima01 = g_sfv[l_ac].sfv04
#             AND imaacti = "Y"
#          
#          IF (g_ima918 = "Y" OR g_ima921 = "Y") AND
#             (cl_null(g_sfv_t.sfv09) OR (g_sfv[l_ac].sfv09<>g_sfv_t.sfv09 )) THEN
#             IF cl_null(g_sfv[l_ac].sfv06) THEN
#                LET g_sfv[l_ac].sfv06 = ' '
#             END IF
#             IF cl_null(g_sfv[l_ac].sfv07) THEN
#                LET g_sfv[l_ac].sfv07 = ' '
#             END IF
#             SELECT img09 INTO g_img09 FROM img_file
#              WHERE img01=g_sfv[l_ac].sfv04
#                AND img02=g_sfv[l_ac].sfv05
#                AND img03=g_sfv[l_ac].sfv06
#                AND img04=g_sfv[l_ac].sfv07
#             CALL s_umfchk(g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv08,g_img09) 
#                 RETURNING l_i,l_fac
#             IF l_i = 1 THEN LET l_fac = 1 END IF
#CHI-9A0022 --Begin
#             IF cl_null(g_sfv[l_ac].sfv41) THEN
#                LET l_bno = ''
#             ELSE
#                LET l_bno = g_sfv[l_ac].sfv41
#             END IF
#CHI-9A0022 --End
#TQC-B90236---mark---begin
#             CALL s_lotin(g_prog,g_sfu.sfu01,g_sfv[l_ac].sfv03,0,
#                          g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv08,g_img09,
#                          l_fac,g_sfv[l_ac].sfv09,l_bno,'MOD')#CHI-9A0022 add l_bno
#TQC-B90236---mark---end
#TQC_B90236---add----begin
#             CALL s_mod_lot(g_prog,g_sfu.sfu01,g_sfv[l_ac].sfv03,0,
#                            g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv05,
#                            g_sfv[l_ac].sfv06,g_sfv[l_ac].sfv07,
#                            g_sfv[l_ac].sfv08,g_img09,l_fac,g_sfv[l_ac].sfv09,l_bno,'MOD',1)
#TQC-B90236---add----end
#                    RETURNING l_r,g_qty 
#             IF l_r = "Y" THEN
#                LET g_sfv[l_ac].sfv09 = g_qty
#             END IF
#          END IF
#########FUN-BC0104---mark---end##########
        BEFORE FIELD sfv33
           CALL t620_set_no_required_b()
 
        AFTER FIELD sfv33  #第二單位
           LET l_case = '' #FUN-BB0086 add
           IF cl_null(g_sfv[l_ac].sfv04) THEN NEXT FIELD sfv04 END IF
           IF g_sfv[l_ac].sfv05 IS NULL OR g_sfv[l_ac].sfv06 IS NULL OR
              g_sfv[l_ac].sfv07 IS NULL THEN
              NEXT FIELD sfv07
           END IF
           IF NOT cl_null(g_sfv[l_ac].sfv33) THEN
              SELECT gfe02 INTO g_buf FROM gfe_file
               WHERE gfe01=g_sfv[l_ac].sfv33
                 AND gfeacti='Y'
              IF STATUS THEN
                 CALL cl_err('gfe:',STATUS,0)
                 NEXT FIELD sfv33
              END IF
              CALL s_du_umfchk(g_sfv[l_ac].sfv04,'','','',
                               g_ima55,g_sfv[l_ac].sfv33,g_ima906)
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_sfv[l_ac].sfv33,g_errno,0)
                 NEXT FIELD sfv33
              END IF
              LET g_sfv[l_ac].sfv34 = g_factor
              DISPLAY BY NAME g_sfv[l_ac].sfv34    #FUN-550085
              CALL s_chk_imgg(g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv05,
                              g_sfv[l_ac].sfv06,g_sfv[l_ac].sfv07,
                              g_sfv[l_ac].sfv33) RETURNING g_flag
              IF g_flag = 1 THEN
                 IF g_argv = '2' THEN    #入庫退回
                    CALL cl_err('sel img:',STATUS,0)
                    NEXT FIELD sfv05
                 END IF
                 IF g_sma.sma892[3,3] = 'Y' THEN
                    IF NOT cl_confirm('aim-995') THEN NEXT FIELD sfv33 END IF
                 END IF
                    CALL s_add_imgg(g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv05,
                                    g_sfv[l_ac].sfv06,g_sfv[l_ac].sfv07,
                                    g_sfv[l_ac].sfv33,g_sfv[l_ac].sfv34,
                                    g_sfu.sfu01,
                                    g_sfv[l_ac].sfv03,0) RETURNING g_flag
                    IF g_flag = 1 THEN
                       NEXT FIELD sfv33
                    END IF
              END IF
              #FUN-BC0104---add---str---
              IF NOT cl_null(g_sfv[l_ac].sfv35) AND g_sfv[l_ac].sfv35<>0 THEN
                 CALL t620_sfv35_check(p_cmd,l_bno) RETURNING l_case
              END IF
              #FUN-BC0104---add---end---
#FUN-BC0104---mark---str---
#                 IF NOT t620_sfv35_check(p_cmd,l_bno) THEN
#                    LET g_sfv33_t = g_sfv[l_ac].sfv33
#                    NEXT FIELD sfv35
#                 END IF
#FUN-BC0104---mark---end---
           END IF
           CALL t620_du_data_to_correct()
           CALL t620_set_required_b()
           CALL cl_show_fld_cont()
           #FUN-BB0086-add-str-
           LET g_sfv33_t = g_sfv[l_ac].sfv33
           CASE l_case
              WHEN "sfv03"
                 NEXT FIELD sfv03
              WHEN "sfv17"
                 NEXT FIELD sfv17
              WHEN "sfv35"
                 NEXT FIELD sfv35
              OTHERWISE EXIT CASE
           END CASE
           #FUN-BB0086-add-end-

        BEFORE FIELD sfv35  #第二數量
           IF cl_null(g_sfv[l_ac].sfv04) THEN NEXT FIELD sfv04 END IF
           IF g_sfv[l_ac].sfv05 IS NULL OR g_sfv[l_ac].sfv06 IS NULL OR
              g_sfv[l_ac].sfv07 IS NULL THEN
              NEXT FIELD sfv07
           END IF
           IF NOT cl_null(g_sfv[l_ac].sfv33) AND g_ima906 = '3' THEN
              SELECT gfe02 INTO g_buf FROM gfe_file
               WHERE gfe01=g_sfv[l_ac].sfv33
                 AND gfeacti='Y'
              IF STATUS THEN
                 CALL cl_err('gfe:',STATUS,0)
                 NEXT FIELD sfv04
              END IF
              CALL s_du_umfchk(g_sfv[l_ac].sfv04,'','','',
                               g_ima55,g_sfv[l_ac].sfv33,g_ima906)
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_sfv[l_ac].sfv33,g_errno,0)
                 NEXT FIELD sfv04
              END IF
              LET g_sfv[l_ac].sfv34 = g_factor
              DISPLAY BY NAME g_sfv[l_ac].sfv34    #FUN-550085
              CALL s_chk_imgg(g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv05,
                              g_sfv[l_ac].sfv06,g_sfv[l_ac].sfv07,
                              g_sfv[l_ac].sfv33) RETURNING g_flag
              IF g_flag = 1 THEN
                 IF g_argv = '2' THEN    #入庫退回
                    CALL cl_err('sel img:',STATUS,0)
                    NEXT FIELD sfv05
                 END IF
                 IF g_sma.sma892[3,3] = 'Y' THEN
                    IF NOT cl_confirm('aim-995') THEN NEXT FIELD sfv05 END IF
                 END IF
                 CALL s_add_imgg(g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv05,
                                 g_sfv[l_ac].sfv06,g_sfv[l_ac].sfv07,
                                 g_sfv[l_ac].sfv33,g_sfv[l_ac].sfv34,
                                 g_sfu.sfu01,
                                 g_sfv[l_ac].sfv03,0) RETURNING g_flag
                 IF g_flag = 1 THEN
                    NEXT FIELD sfv05
                 END IF
              END IF
           END IF

        AFTER FIELD sfv34  #第二轉換率
           IF NOT cl_null(g_sfv[l_ac].sfv34) THEN
              IF g_sfv[l_ac].sfv34=0 THEN
                 NEXT FIELD sfv34
              END IF
           END IF

        AFTER FIELD sfv35  #第二數量
           #FUN-BC0104---add---str---
           LET l_case = ''
           CALL t620_sfv35_check(p_cmd,l_bno) RETURNING l_case
           CASE l_case
              WHEN "sfv03"
                 NEXT FIELD sfv03
              WHEN "sfv17"
                 NEXT FIELD sfv17
              WHEN "sfv35"
                 NEXT FIELD sfv35
              OTHERWISE EXIT CASE
           END CASE
           #FUN-BC0104---add---end---
           #IF NOT t620_sfv35_check(p_cmd,l_bno) THEN NEXT FIELD sfv35 END IF   #No.FUN-BB0086  #FUN-BC0104 mark
           #No.FUN-BB0086--mark--start---
           #IF NOT cl_null(g_sfv[l_ac].sfv35) THEN
           #   IF g_sfv[l_ac].sfv35 < 0 THEN
           #      CALL cl_err('','aim-391',0)  #
           #      NEXT FIELD sfv35
           #   END IF
           #   IF p_cmd = 'a' OR  p_cmd = 'u' AND
           #      g_sfv_t.sfv35 <> g_sfv[l_ac].sfv35 THEN
           #      IF g_ima906='3' THEN
           #         LET g_tot=g_sfv[l_ac].sfv35*g_sfv[l_ac].sfv34
           #         IF cl_null(g_sfv[l_ac].sfv32) OR g_sfv[l_ac].sfv32=0 THEN #CHI-960022
           #            LET g_sfv[l_ac].sfv32=g_tot*g_sfv[l_ac].sfv31
           #         END IF                                                    #CHI-960022
           #      END IF
           #   END IF
           #SELECT ima918,ima921 INTO g_ima918,g_ima921 
           #  FROM ima_file
           # WHERE ima01 = g_sfv[l_ac].sfv04
           #   AND imaacti = "Y"
           
           #IF (g_ima918 = "Y" OR g_ima921 = "Y") AND
           #   (cl_null(g_sfv_t.sfv35) OR (g_sfv[l_ac].sfv35<>g_sfv_t.sfv35 )) THEN
           #   IF cl_null(g_sfv[l_ac].sfv06) THEN
           #      LET g_sfv[l_ac].sfv06 = ' '
           #   END IF
           #   IF cl_null(g_sfv[l_ac].sfv07) THEN
           #      LET g_sfv[l_ac].sfv07 = ' '
           #   END IF
           #   SELECT img09 INTO g_img09 FROM img_file
           #    WHERE img01=g_sfv[l_ac].sfv04
           #      AND img02=g_sfv[l_ac].sfv05
           #      AND img03=g_sfv[l_ac].sfv06
           #      AND img04=g_sfv[l_ac].sfv07
           #   CALL s_umfchk(g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv08,g_img09) 
           #       RETURNING l_i,l_fac
           #   IF l_i = 1 THEN LET l_fac = 1 END IF
           ##CHI-9A0022 --Begin
           #   IF cl_null(g_sfv[l_ac].sfv41) THEN
           #      LET l_bno = ''
           #   ELSE
           #      LET l_bno = g_sfv[l_ac].sfv41
           #   END IF
           ##CHI-9A0022 --End
           #   CALL s_lotin(g_prog,g_sfu.sfu01,g_sfv[l_ac].sfv03,0,
           #                g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv08,g_img09,
           #                l_fac,g_sfv[l_ac].sfv09,l_bno,'MOD')#CHI-9A0022 add l_bno
           #          RETURNING l_r,g_qty 
           #   IF l_r = "Y" THEN
           #      LET g_sfv[l_ac].sfv09 = g_qty
           #   END IF
           #END IF
           #END IF
           #CALL cl_show_fld_cont()
           #No.FUN-BB0086--mark--end---

        BEFORE FIELD sfv30
           CALL t620_set_no_required_b()
           CALL t620_set_entry_b('a')              #MOD-B10184 add
           CALL t620_set_no_entry_b('a')           #MOD-B10184 add
 
        AFTER FIELD sfv30  #第一單位
           #No.FUN-BB0086--add--start--
           LET l_case = ''
           LET l_tf = ''
           #No.FUN-BB0086--add--end--
           IF cl_null(g_sfv[l_ac].sfv04) THEN NEXT FIELD sfv04 END IF
           IF (NOT cl_null(g_sfv[l_ac].sfv09)) AND (g_argv<>'3') THEN #FUN-5C0114 add "g_argv<>'3'"
              IF l_FQC = 'Y' THEN
                  CALL t620_FQC() RETURNING tmp_qty,l_qty_FQC #check 數量的勾稽
                  LET g_sfv[l_ac].sfv09 = l_qty_FQC
                  IF g_sfv_t.sfv09 != g_sfv[l_ac].sfv09 THEN
                     CALL t620_set_du_by_origin()
                  END IF
                  LET g_msg=""
                  LET g_msg=g_msg CLIPPED,
                            g_x[2] CLIPPED,tmp_qty USING '############.###',    #已登打入庫量    #No:MOD-770048 modify  #No:MOD-970035 modify
                            g_x[3] CLIPPED,l_qty_FQC USING '############.###' #可入庫量   #No:MOD-970035 modify
              END IF
              IF g_sfb.sfb39 !='2' THEN    #No:7834 add
                 ERROR g_msg
              END IF
           END IF
           IF g_sfv[l_ac].sfv05 IS NULL OR g_sfv[l_ac].sfv06 IS NULL OR
              g_sfv[l_ac].sfv07 IS NULL THEN
              NEXT FIELD sfv07
           END IF
           IF NOT cl_null(g_sfv[l_ac].sfv30) THEN
              SELECT gfe02 INTO g_buf FROM gfe_file
               WHERE gfe01=g_sfv[l_ac].sfv30
                 AND gfeacti='Y'
              IF STATUS THEN
                 CALL cl_err('gfe:',STATUS,0)
                 NEXT FIELD sfv30
              END IF
              CALL s_du_umfchk(g_sfv[l_ac].sfv04,'','','',
                               g_sfv[l_ac].sfv08,g_sfv[l_ac].sfv30,'1')
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_sfv[l_ac].sfv30,g_errno,0)
                 NEXT FIELD sfv30
              END IF
              LET g_sfv[l_ac].sfv31 = g_factor    #FUN-550085
              DISPLAY BY NAME g_sfv[l_ac].sfv31
              IF g_ima906 = '2' THEN
                 CALL s_chk_imgg(g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv05,
                                 g_sfv[l_ac].sfv06,g_sfv[l_ac].sfv07,
                                 g_sfv[l_ac].sfv30) RETURNING g_flag
                 IF g_flag = 1 THEN
                    IF g_argv = '2' THEN    #入庫退回
                       CALL cl_err('sel img:',STATUS,0)
                       NEXT FIELD sfv05
                    END IF
                    IF g_sma.sma892[3,3] = 'Y' THEN
                       IF NOT cl_confirm('aim-995') THEN NEXT FIELD sfv30 END IF
                    END IF
                       CALL s_add_imgg(g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv05,
                                       g_sfv[l_ac].sfv06,g_sfv[l_ac].sfv07,
                                       g_sfv[l_ac].sfv30,g_sfv[l_ac].sfv31,
                                       g_sfu.sfu01,
                                       g_sfv[l_ac].sfv03,0) RETURNING g_flag
                       IF g_flag = 1 THEN
                          NEXT FIELD sfv30
                       END IF
                 END IF
              END IF
              #No.FUN-BB0086--add--start--
              IF NOT cl_null(g_sfv[l_ac].sfv32) AND g_sfv[l_ac].sfv32<>0 THEN
                 CALL t620_sfv32_check(l_qty_FQC,l_qcf091,p_cmd) RETURNING l_tf,l_case  #FUN-BC0104 add p_cmd
              END IF
              #No.FUN-BB0086--add--end--
           END IF
           CALL t620_du_data_to_correct()
           CALL t620_set_required_b()
           CALL cl_show_fld_cont()
           #No.FUN-BB0086--add--start--
           LET g_sfv30_t = g_sfv[l_ac].sfv30                 
           IF NOT l_tf THEN
              CASE l_case
                 WHEN "sfv32"
                    NEXT FIELD sfv32
                 WHEN "sfv35"
                    NEXT FIELD sfv35
                 WHEN "sfv03"
                    NEXT FIELD sfv03
                 #FUN-BC0104---add---str
                 WHEN "sfv17"
                    NEXT FIELD sfv17
                 #FUN-BC0104---add---end
                 OTHERWISE EXIT CASE
              END CASE
           END IF
           #No.FUN-BB0086--add--end--

        AFTER FIELD sfv31  #第一轉換率
           IF NOT cl_null(g_sfv[l_ac].sfv31) THEN
              IF g_sfv[l_ac].sfv31=0 THEN
                 NEXT FIELD sfv31
              END IF
           END IF

        BEFORE FIELD sfv32
           IF (NOT cl_null(g_sfv[l_ac].sfv09)) AND (g_argv<>'3') THEN
              IF l_FQC = 'Y' THEN
                  CALL t620_FQC() RETURNING tmp_qty,l_qty_FQC #check 數量的勾稽
                  LET g_sfv[l_ac].sfv09 = l_qty_FQC
                  IF g_sfv_t.sfv09 != g_sfv[l_ac].sfv09 THEN
                     CALL t620_set_du_by_origin()
                  END IF
                  LET g_msg=""
                  LET g_msg=g_msg CLIPPED,
                            g_x[2] CLIPPED,tmp_qty USING '############.###',    #已登打入庫量     #No:MOD-970035 modify
                            g_x[3] CLIPPED,l_qty_FQC USING '############.###' #可入庫量    #No:MOD-970035 modify
              END IF
              IF g_sfb.sfb39 !='2' THEN    #No:7834 add
                 ERROR g_msg
              END IF
              #MOD-C70307 str add-----
              IF NOT t620_sfv11(p_cmd) THEN
                 NEXT FIELD sfv11   
              END IF
             #MOD-C70307 end add-----
           END IF

        AFTER FIELD sfv32  #第一數量
           #No.FUN-BB0086--add--start--
           LET l_case = ''
           CALL t620_sfv32_check(l_qty_FQC,l_qcf091,p_cmd) RETURNING l_tf,l_case  #FUN-BC0104 add p_cmd
           IF NOT l_tf THEN 
              CASE l_case
                 WHEN "sfv32"
                    NEXT FIELD sfv32
                 WHEN "sfv35"
                    NEXT FIELD sfv35
                 WHEN "sfv03"
                    NEXT FIELD sfv03
                 #FUN-BC0104---add---str
                 WHEN "sfv17"
                    NEXT FIELD sfv17
                 #FUN-BC0104---add---end
                 OTHERWISE EXIT CASE 
              END CASE 
           END IF
           #No.FUN-BB0086--add--end--

           #No.FUN-BB0086--mark--start--
           #IF NOT cl_null(g_sfv[l_ac].sfv32) THEN
           #   IF g_sfv[l_ac].sfv32 < 0 THEN
           #      CALL cl_err('','aim-391',0)  #
           #      NEXT FIELD sfv32
           #   END IF
           #END IF
           #CALL t620_set_origin_field()
           ##計算sfv09的值,檢查入庫數量的合理性
           #IF g_argv<>'3' THEN #FUN-5C0114
           #   CALL t620_check_inventory_qty(l_qty_FQC,l_FQC,l_qcf091)
           #       RETURNING g_flag
           #   IF g_flag = '1' THEN
           #      IF g_ima906 = '3' OR g_ima906 = '2' THEN
           #         NEXT FIELD sfv35
           #      ELSE
           #         NEXT FIELD sfv32
           #      END IF
           #   END IF
           #ELSE
           #   IF cl_null(g_sfv[l_ac].sfv03) THEN
           #      NEXT FIELD sfv03
           #   END IF
           #   IF NOT t620_asrchk_sfv09(g_sfv[l_ac].sfv17,
           #                            g_sfv[l_ac].sfv14,
           #                            g_sfv[l_ac].sfv09) THEN
           #     IF g_ima906 = '3' OR g_ima906 = '2' THEN
           #        NEXT FIELD sfv35
           #     ELSE
           #        NEXT FIELD sfv32
           #     END IF
           #   END IF
           #END IF
           #CALL cl_show_fld_cont()
           #No.FUN-BB0086--mark--end--
           
        AFTER FIELD sfv930 
           IF NOT s_costcenter_chk(g_sfv[l_ac].sfv930) THEN
              LET g_sfv[l_ac].sfv930=g_sfv_t.sfv930
              LET g_sfv[l_ac].gem02c=g_sfv_t.gem02c
              DISPLAY BY NAME g_sfv[l_ac].sfv930,g_sfv[l_ac].gem02c
              NEXT FIELD sfv930
           ELSE
              LET g_sfv[l_ac].gem02c=s_costcenter_desc(g_sfv[l_ac].sfv930)
              DISPLAY BY NAME g_sfv[l_ac].gem02c
           END IF

       AFTER FIELD sfv41
          IF NOT cl_null(g_sfv[l_ac].sfv41) THEN
             SELECT COUNT(*) INTO g_cnt FROM pja_file
              WHERE pja01 = g_sfv[l_ac].sfv41
                AND pjaacti = 'Y'    
                AND pjaclose='N'     #FUN-960038
             IF g_cnt = 0 THEN
                CALL cl_err(g_sfv[l_ac].sfv41,'asf-984',0)
                NEXT FIELD sfv41
             END IF
          ELSE 
             NEXT FIELD sfv12    #IF 專案沒輸入資料，直接跳到理由碼,WBS/活動不可輸入
          END IF
         
       BEFORE FIELD sfv42
         IF cl_null(g_sfv[l_ac].sfv41) THEN
            NEXT FIELD sfv41
         END IF

       AFTER FIELD sfv42
          IF NOT cl_null(g_sfv[l_ac].sfv42) THEN
             SELECT COUNT(*) INTO g_cnt FROM pjb_file
              WHERE pjb01 = g_sfv[l_ac].sfv41
                AND pjb02 = g_sfv[l_ac].sfv42
                AND pjbacti = 'Y'    
             IF g_cnt = 0 THEN
                CALL cl_err(g_sfv[l_ac].sfv42,'apj-051',0)
                LET g_sfv[l_ac].sfv42 = g_sfv_t.sfv42
                NEXT FIELD sfv42
             END IF
             SELECT pjb09,pjb11
               INTO l_pjb09,l_pjb11 
               FROM pjb_file
              WHERE pjb01 = g_sfv[l_ac].sfv41
                AND pjb02 = g_sfv[l_ac].sfv42
                AND pjb25 = 'N'
                AND pjbacti = 'Y'
             CASE WHEN l_pjb09 !='Y' 
                       CALL cl_err(g_sfv[l_ac].sfv42,'apj-090',0)
                       LET g_sfv[l_ac].sfv42 = g_sfv_t.sfv42
                       NEXT FIELD sfv42
                  WHEN l_pjb11 !='Y'
                       CALL cl_err(g_sfv[l_ac].sfv42,'apj-090',0)
                       LET g_sfv[l_ac].sfv42 = g_sfv_t.sfv42
                       NEXT FIELD sfv42
                  OTHERWISE  LET g_errno = SQLCA.sqlcode USING '-------'
                       CALL cl_err(g_sfv[l_ac].sfv42,g_errno,0)
                       LET g_sfv[l_ac].sfv42 = g_sfv_t.sfv42
                       NEXT FIELD sfv42
             END CASE
             SELECT pjb25 INTO l_pjb25 FROM pjb_file
              WHERE pjb02 = g_sfv[l_ac].sfv42
             IF l_pjb25 = 'Y' THEN
                NEXT FIELD sfv43
             ELSE
                LET g_sfv[l_ac].sfv43 = ' '
                DISPLAY BY NAME g_sfv[l_ac].sfv43
                NEXT FIELD sfv44
             END IF
          END IF

       BEFORE FIELD sfv43
         IF cl_null(g_sfv[l_ac].sfv42) THEN
            NEXT FIELD sfv42
         ELSE
            SELECT pjb25 INTO l_pjb25 FROM pjb_file
             WHERE pjb02 = g_sfv[l_ac].sfv42
            IF l_pjb25 = 'N' THEN  #WBS不做活動時，活動帶空白，跳開不輸入
               LET g_sfv[l_ac].sfv43 = ' '
               DISPLAY BY NAME g_sfv[l_ac].sfv43
               NEXT FIELD sfv44
            END IF
         END IF

       AFTER FIELD sfv43
          IF NOT cl_null(g_sfv[l_ac].sfv43) THEN
             SELECT COUNT(*) INTO g_cnt FROM pjk_file
              WHERE pjk02 = g_sfv[l_ac].sfv43
                AND pjk11 = g_sfv[l_ac].sfv42
                AND pjkacti = 'Y'    
             IF g_cnt = 0 THEN
                CALL cl_err(g_sfv[l_ac].sfv43,'apj-049',0)
                NEXT FIELD sfv43
             END IF
          END IF

       #FUN-CB0087--add--str--
       BEFORE FIELD sfv44
          IF g_aza.aza115 = 'Y' AND cl_null(g_sfv[l_ac].sfv44) THEN 
             CALL s_reason_code(g_sfu.sfu01,g_sfv[l_ac].sfv11,'',g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv05,g_sfu.sfu16,g_sfu.sfu04) RETURNING g_sfv[l_ac].sfv44
             DISPLAY BY NAME g_sfv[l_ac].sfv44
          END IF
       #FUN-CB0087--add--end-- 
       AFTER FIELD sfv44
          #FUN-CB0087--add--str--
          IF t620_sfv44_check() THEN 
             SELECT azf03 INTO g_sfv[l_ac].azf03 FROM azf_file WHERE azf01=g_sfv[l_ac].sfv44 AND azf02='2'
          ELSE
             NEXT FIELD sfv44
          END IF 
          #FUN-CB0087--add--end-- 
          #FUN-CB0087--mark--str--
          #IF NOT cl_null(g_sfv[l_ac].sfv44) THEN
          #   SELECT COUNT(*) INTO g_cnt FROM azf_file
          #    WHERE azf01=g_sfv[l_ac].sfv44 AND azf02='2' AND azfacti='Y'
          #   IF g_cnt = 0 THEN
          #      CALL cl_err(g_sfv[l_ac].sfv44,'asf-453',0)
          #      NEXT FIELD sfv44
          #  #str MOD-A60141 add
          #   ELSE
          #      SELECT azf03 INTO g_sfv[l_ac].azf03 FROM azf_file
          #       WHERE azf01=g_sfv[l_ac].sfv44 AND azf02='2' AND azfacti='Y'
          #  #end MOD-A60141 add
          #   END IF
          #   SELECT azf09 INTO l_azf09 FROM azf_file
          #    WHERE azf01=g_sfv[l_ac].sfv44 AND azf02='2' AND azfacti='Y'
          #   IF l_azf09 != 'C' THEN
          #      CALL cl_err(g_sfv[l_ac].sfv44,'aoo-411',0)
          #      NEXT FIELD sfv44
          #   END IF
          #ELSE  #料號如果要做專案控管的話，一定要輸入理由碼
          #   IF g_smy.smy59 = 'Y' THEN
          #      CALL cl_err('','apj-201',0)
          #      NEXT FIELD sfv44
          #   END IF
          #END IF
          #FUN-CB0087--mark--end--
             
        AFTER FIELD sfvud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfvud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfvud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfvud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfvud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfvud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfvud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfvud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfvud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfvud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfvud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfvud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfvud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfvud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfvud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

        BEFORE DELETE                            #是否取消單身
            IF g_sfv_t.sfv03 > 0 AND g_sfv_t.sfv03 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF

                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF

                SELECT ima918,ima921 INTO g_ima918,g_ima921 
                  FROM ima_file
                 WHERE ima01 = g_sfv[l_ac].sfv04
                   AND imaacti = "Y"
                
                IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                  #IF NOT s_lotin_del(g_prog,g_sfu.sfu01,g_sfv[l_ac].sfv03,0,g_sfv[l_ac].sfv04,'DEL') THEN   #No:FUN-860045  #TQC-B90236 mark
                   IF NOT s_lot_del(g_prog,g_sfu.sfu01,g_sfv[l_ac].sfv03,0,g_sfv[l_ac].sfv04,'DEL') THEN   #No:FUN-860045  #TQC-B90236 add
                      CALL cl_err3("del","rvbs_file",g_sfu.sfu01,g_sfv_t.sfv03,
                                    SQLCA.sqlcode,"","",1)
                       ROLLBACK WORK
                       CANCEL DELETE
                   END IF
                END IF

                IF g_argv='3' THEN
                   UPDATE srg_file SET srg11=NULL WHERE srg01=g_sfv[l_ac].sfv17
                                                    AND srg02=g_sfv[l_ac].sfv14
                   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                      CALL cl_err('upd srg11','9050',1)
                      ROLLBACK WORK 
                      CANCEL DELETE
                   END IF
                END IF
               IF s_chk_rvbs(g_sfv[l_ac].sfv41,g_sfv[l_ac].sfv04) THEN   
                 #IF NOT s_del_rvbs("2",g_sfu.sfu01,g_sfv[l_ac].sfv03,0)  THEN         #FUN-880129   #TQC-B90236 mark
                  IF NOT s_lot_del(g_prog,g_sfu.sfu01,g_sfv[l_ac].sfv03,0,g_sfv[l_ac].sfv04,'DEL') THEN  #TQC-B90236 add
                     ROLLBACK WORK
                     CANCEL DELETE
                  END IF
               END IF   

                DELETE FROM sfv_file
                 WHERE sfv01 = g_sfu.sfu01 AND sfv03 = g_sfv_t.sfv03
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_sfv_t.sfv03,SQLCA.sqlcode,0)
                   ROLLBACK WORK
                   CANCEL DELETE
                ELSE  #FUN-BC0104 add
                END IF
                #FUN-BC0104---add---str
                IF NOT s_iqctype_upd_qco20(g_sfv[l_ac].sfv17,0,0,g_sfv[l_ac].sfv47,'2') THEN
                   ROLLBACK WORK
                   CANCEL DELETE 
                END IF
                #FUN-BC0104---add---end
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
		            COMMIT WORK
            END IF

        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET l_sfu15_FLAG = 'N'  #FUN-C30293
               LET g_sfv[l_ac].* = g_sfv_t.*
               CLOSE t620_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF


            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_sfv[l_ac].sfv04,-263,1)
               LET g_sfv[l_ac].* = g_sfv_t.*
            ELSE
               CALL t620_b_else()
               IF NOT t620_add_img(g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv05,
                                   g_sfv[l_ac].sfv06,g_sfv[l_ac].sfv07,
                                   g_sfu.sfu01,      g_sfv[l_ac].sfv03,
                                   g_today) THEN
                  NEXT FIELD sfv07
               END IF
               IF g_sma.sma115 = 'Y' THEN
                  CALL s_chk_va_setting(g_sfv[l_ac].sfv04)
                       RETURNING g_flag,g_ima906,g_ima907
                  IF g_flag=1 THEN
                     NEXT FIELD sfv04
                  END IF
 
                 CASE g_ima906
                    WHEN "2"
                          IF NOT t620_add_imgg(g_sfv[l_ac].sfv33,g_sfv[l_ac].sfv34) THEN    
                             NEXT FIELD sfv33
                          END IF
                    
                          IF NOT t620_add_imgg(g_sfv[l_ac].sfv30,g_sfv[l_ac].sfv31) THEN    
                             NEXT FIELD sfv30
                          END IF
                     WHEN "3"
                          IF NOT t620_add_imgg(g_sfv[l_ac].sfv33,g_sfv[l_ac].sfv34) THEN    
                             NEXT FIELD sfv33
                          END IF
                  END CASE

                  CALL t620_du_data_to_correct()

                  CALL t620_set_origin_field()
                  IF g_argv<>'3' THEN #FUN-5C0114
                     CALL t620_check_inventory_qty(l_qty_FQC,l_FQC,l_qcf091)
                         RETURNING g_flag
                     IF g_flag = '1' THEN
                        IF g_ima906 = '3' OR g_ima906 = '2' THEN
                           NEXT FIELD sfv35
                        ELSE
                           NEXT FIELD sfv32
                        END IF
                     END IF
                  END IF
               END IF
               IF g_aza.aza115 = 'Y' AND NOT t620_sfv44_check() THEN NEXT FIELD sfv44 END IF  #FUN-CB0087 add
               #IF 有專案且要做預算控管
               # check料件， if料件沒做批號管理也沒做序號管理，則要寫入rvbs_file
               LET g_success = 'Y'
               IF s_chk_rvbs(g_sfv[l_ac].sfv41,g_sfv[l_ac].sfv04) THEN
                  CALL t620_rvbs(g_sfv[l_ac].sfv03,g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv08,g_sfv[l_ac].sfv09,g_sfv[l_ac].sfv41)
               END IF
               CALL t620_b_move_back() #FUN-730075
               IF g_success = 'Y' THEN
                 UPDATE sfv_file SET * = b_sfv.*
                  WHERE sfv01=g_sfu.sfu01
                    AND sfv03=g_sfv_t.sfv03
               END IF
               IF SQLCA.sqlcode THEN
                  CALL cl_err('upd sfv',SQLCA.sqlcode,0)
                  LET g_sfv[l_ac].* = g_sfv_t.*
               #FUN-B70061 --START--
                  LET g_success = 'N'
               END IF
               IF g_success = 'Y' THEN
                  CALL cl_msg(' O.K ')  #FUN-CB0087 刪除UPDATE
                  #FUN-BC0104---add---str
                  IF NOT s_iqctype_upd_qco20(g_sfv[l_ac].sfv17,0,0,g_sfv[l_ac].sfv47,'2') THEN
                     ROLLBACK WORK       
                  END IF
                  #FUN-BC0104---add---end
	              COMMIT WORK  
               END IF
               #FUN-B70061 --END-- 
            END IF

        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac     #FUN-D40030 Mark 
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET l_sfu15_FLAG = 'N'  #FUN-C30293
               IF p_cmd = 'a' AND l_ac <= g_sfv.getLength() THEN #CHI-C30118 add
                  SELECT ima918,ima921 INTO g_ima918,g_ima921 
                    FROM ima_file
                   WHERE ima01 = g_sfv[l_ac].sfv04
                     AND imaacti = "Y"
                  
                  IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                    #IF NOT s_lotin_del(g_prog,g_sfu.sfu01,g_sfv[l_ac].sfv03,0,g_sfv[l_ac].sfv04,'DEL') THEN   #No:FUN-860045 #TQC-B90236 mark
                     IF NOT s_lot_del(g_prog,g_sfu.sfu01,g_sfv[l_ac].sfv03,0,g_sfv[l_ac].sfv04,'DEL') THEN   #No:FUN-860045 #TQC-B90236 add
                        CALL cl_err3("del","rvbs_file",g_sfu.sfu01,g_sfv_t.sfv03,
                                      SQLCA.sqlcode,"","",1)
                     END IF
                  END IF
               END IF #CHI-C30118 add
               IF p_cmd='u' THEN
                  LET g_sfv[l_ac].* = g_sfv_t.* 
              #MOD-C50012---S---
               ELSE
                  INITIALIZE g_sfv[l_ac].* TO NULL
                  CALL g_sfv.deleteElement(l_ac)
                  #FUN-D40030--add--str--
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
                  #FUN-D40030--add--end--
              #MOD-C50012---E---
               END IF
               CLOSE t620_bcl
               ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac     #FUN-D40030 Add
            #MOD-D10050---begin
            IF g_sfv[l_ac].sfv09 <= 0 THEN
               LET g_sfv[l_ac].sfv09 = 0
               DISPLAY BY NAME g_sfv[l_ac].sfv09 
               NEXT FIELD sfv09
            END IF
            #MOD-D10050---end
           IF g_aza.aza115 = 'Y' AND NOT t620_sfv44_check() THEN NEXT FIELD sfv44 END IF  #FUN-CB0087 add

           #MOD-C50012---S---
            IF l_ac >= g_sfv.getLength() THEN
               CASE t620_b_sfv07_inschk(p_cmd)
                  WHEN "sfv05" NEXT FIELD sfv05
                  WHEN "sfv07" NEXT FIELD sfv07
               END CASE
            END IF
           #MOD-C50012---E---

            #TQC-C60148--add--str--
            IF cl_null(g_sfv[l_ac].sfv03) THEN
               CALL g_sfv.deleteElement(l_ac)
            END IF
            #TQC-C60148--add--end--
            CLOSE t620_bcl
            COMMIT WORK
               

    #CHI-C30118---add---START 回寫批序料號資料
        AFTER INPUT
            SELECT COUNT(*) INTO g_cnt FROM sfv_file WHERE sfv01=g_sfu.sfu01
            FOR l_ac2 = 1 TO g_cnt
                LET g_ima918 = ' '
                LET g_ima921 = ' '
                SELECT ima918,ima921 INTO g_ima918,g_ima921
                  FROM ima_file
                 WHERE ima01 = g_sfv[l_ac2].sfv04
                   AND imaacti = "Y"
                   
                IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                   UPDATE rvbs_file SET rvbs021 = g_sfv[l_ac2].sfv04
                     WHERE rvbs00 = g_prog
                       AND rvbs01 = g_sfu.sfu01
                       AND rvbs02 = g_sfv[l_ac2].sfv03
                END IF
            END FOR
    #CHI-C30118---add---END
            
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(sfv03) AND l_ac > 1 THEN
              LET g_sfv[l_ac].* = g_sfv[l_ac-1].*
              LET g_sfv[l_ac].sfv09 = 0           #No.MOD-B70176
              LET g_sfv[l_ac].sfv32 = 0           #No.MOD-B70176
              LET g_sfv[l_ac].sfv35 = 0           #No.MOD-B70176
              SELECT max(sfv03)+1 INTO g_sfv[l_ac].sfv03
                FROM sfv_file WHERE sfv01 = g_sfu.sfu01
              IF g_sfv[l_ac].sfv03 IS NULL THEN
                  LET g_sfv[l_ac].sfv03 = 1
                   DISPLAY BY NAME g_sfv[l_ac].sfv03 #MOD-4A0260
              END IF
              DISPLAY BY NAME g_sfv[l_ac].*
              NEXT FIELD sfv03
           END IF

        ON ACTION controlp
           CASE WHEN INFIELD(sfv11)    #工單單號
                     IF g_argv='3' THEN EXIT CASE END IF #FUN-5C0114
                     CALL cl_init_qry_var()
                    #LET g_qryparam.form ="q_sfb02"         #MOD-C60053 mark
                     LET g_qryparam.form ="q_sfb021"        #MOD-C60053 add
                     LET g_qryparam.construct = "Y"
                     LET g_qryparam.default1 = g_sfv[l_ac].sfv11
                     LET g_qryparam.arg1 = 234567
                     ##組合拆解的工單發料不顯示出來!
                    #LET g_qryparam.where = " substr(sfb01,1,",g_doc_len,") NOT IN (SELECT smy69 FROM smy_file WHERE smy69 IS NOT NULL) "
                     LET g_qryparam.where = " sfb01[1,",g_doc_len,"] NOT IN (SELECT smy69 FROM smy_file WHERE smy69 IS NOT NULL) "       #FUN-B40029
                     CALL cl_create_qry() RETURNING g_sfv[l_ac].sfv11
                     DISPLAY BY NAME g_sfv[l_ac].sfv11   #No:MOD-490371
                     NEXT FIELD sfv11
                WHEN INFIELD(sfv17)    #FQC NO.
                     IF g_argv<>'3' THEN #FUN-5C0114
                       #CALL q_qcf(FALSE,TRUE,g_sfv[l_ac].sfv17,'1')    #CHI-CA0011 mark
                        CALL q_qcf_2(FALSE,TRUE,g_sfv[l_ac].sfv17,'1')  #CHI-CA0011 
                             RETURNING g_sfv[l_ac].sfv17
                        DISPLAY BY NAME g_sfv[l_ac].sfv17
                     ELSE
                        CALL cl_init_qry_var()
                        LET g_qryparam.form ="q_srg03"
                        CALL cl_create_qry() RETURNING g_sfv[l_ac].sfv17,g_sfv[l_ac].sfv14
                        DISPLAY BY NAME g_sfv[l_ac].sfv17
                        DISPLAY BY NAME g_sfv[l_ac].sfv14
                     END IF
                     NEXT FIELD sfv17

                WHEN INFIELD(sfv05) OR INFIELD(sfv06) OR INFIELD(sfv07)
                   #FUN-C30300---begin
                   LET g_ima906 = NULL
                   SELECT ima906 INTO g_ima906 FROM ima_file
                    WHERE ima01 = g_sfv[l_ac].sfv04
                   #IF s_industry("icd") AND g_ima906='3' THEN  #TQC-C60028
                   IF s_industry("icd") THEN  #TQC-C60028
                      CALL q_idc(FALSE,TRUE,g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv05,g_sfv[l_ac].sfv06,g_sfv[l_ac].sfv07)
                      RETURNING g_sfv[l_ac].sfv05,g_sfv[l_ac].sfv06,g_sfv[l_ac].sfv07
                   ELSE
                   #FUN-C30300---end 
                      CALL q_img4(0,1,g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv05, ##NO:FUN-660085
                                      g_sfv[l_ac].sfv06,g_sfv[l_ac].sfv07,'A')
                         RETURNING    g_sfv[l_ac].sfv05,g_sfv[l_ac].sfv06,
                                      g_sfv[l_ac].sfv07
                   END IF #FUN-C30300
                     DISPLAY g_sfv[l_ac].sfv05 TO sfv05
                     DISPLAY g_sfv[l_ac].sfv06 TO sfv06
                     DISPLAY g_sfv[l_ac].sfv07 TO sfv07
                     IF INFIELD(sfv05) THEN NEXT FIELD sfv05 END IF
                     IF INFIELD(sfv06) THEN NEXT FIELD sfv06 END IF
                     IF INFIELD(sfv07) THEN NEXT FIELD sfv07 END IF
                WHEN INFIELD(sfv04) #聯產品料號 NO:6872  #FUN-550085
                     IF g_argv='3' THEN EXIT CASE END IF #FUN-5C0114
                     IF g_sma.sma105 = '1' THEN #認定聯產品的時機點為:1.FQC
                        CAll q_qde(FALSE,TRUE,g_sfv[l_ac].sfv17,g_sfv[l_ac].sfv11)
                             RETURNING g_sfv[l_ac].sfv04, g_sfv[l_ac].sfv08,
                                       g_sfv[l_ac].sfv05, g_sfv[l_ac].sfv06,
                                       g_sfv[l_ac].sfv07
                        DISPLAY BY NAME g_sfv[l_ac].sfv04, g_sfv[l_ac].sfv08,
                                        g_sfv[l_ac].sfv05, g_sfv[l_ac].sfv06,
                                        g_sfv[l_ac].sfv07
                     END IF
                     IF g_sma.sma105 = '2' AND g_ima.ima903 = 'Y' THEN #認定聯產品的時機點為:2.完工入庫
                        IF cl_null(g_qcf.qcf021) THEN
                           LET l_bmm01 = g_ima.ima01
                        ELSE
                           LET l_bmm01 = g_qcf.qcf021
                        END IF
                        CALL cl_init_qry_var()
                        LET g_qryparam.form ="q_bmm"
                        LET g_qryparam.construct = "Y"
                        LET g_qryparam.arg1 = l_bmm01
                        CALL cl_create_qry() RETURNING g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv08
                        DISPLAY BY NAME g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv08
                     END IF
                     NEXT FIELD sfv04
                WHEN INFIELD(sfv30) #單位
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gfe"
                     LET g_qryparam.default1 = g_sfv[l_ac].sfv30
                     CALL cl_create_qry() RETURNING g_sfv[l_ac].sfv30
                     DISPLAY BY NAME g_sfv[l_ac].sfv30
                     NEXT FIELD sfv30

                WHEN INFIELD(sfv33) #單位
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gfe"
                     LET g_qryparam.default1 = g_sfv[l_ac].sfv33
                     CALL cl_create_qry() RETURNING g_sfv[l_ac].sfv33
                     DISPLAY BY NAME g_sfv[l_ac].sfv33
                     NEXT FIELD sfv33
                WHEN INFIELD(sfv930)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gem4"
                   CALL cl_create_qry() RETURNING g_sfv[l_ac].sfv930
                   DISPLAY BY NAME g_sfv[l_ac].sfv930
                   NEXT FIELD sfv930
                WHEN INFIELD(sfv41) #專案
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pja2"  
                  CALL cl_create_qry() RETURNING g_sfv[l_ac].sfv41 
                  DISPLAY BY NAME g_sfv[l_ac].sfv41
                  NEXT FIELD sfv41
                WHEN INFIELD(sfv42)  #WBS
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pjb4"
                  LET g_qryparam.arg1 = g_sfv[l_ac].sfv41  
                  CALL cl_create_qry() RETURNING g_sfv[l_ac].sfv42 
                  DISPLAY BY NAME g_sfv[l_ac].sfv42
                  NEXT FIELD sfv42
                WHEN INFIELD(sfv43)  #活動
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pjk3"
                  LET g_qryparam.arg1 = g_sfv[l_ac].sfv42  
                  CALL cl_create_qry() RETURNING g_sfv[l_ac].sfv43 
                  DISPLAY BY NAME g_sfv[l_ac].sfv43
                  NEXT FIELD sfv43
                  
                WHEN INFIELD(sfv44)
                  #FUN-CB0087---add---str---         
                  CALL s_get_where(g_sfu.sfu01,g_sfv[l_ac].sfv11,'',g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv05,g_sfu.sfu16,g_sfu.sfu04) RETURNING l_flag,l_where
                  IF l_flag AND g_aza.aza115 = 'Y' THEN 
                     CALL cl_init_qry_var()
                     LET g_qryparam.form     ="q_ggc08"
                     LET g_qryparam.where = l_where
                     LET g_qryparam.default1 = g_sfv[l_ac].sfv44
                  ELSE
                  #FUN-CB0087---add---end---
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_azf01a"              #FUN-930145
                     LET g_qryparam.default1 = g_sfv[l_ac].sfv44
                     LET g_qryparam.arg1 = 'C'                    #FUN-930145
                  END IF  #FUN-CB0087 add
                  CALL cl_create_qry() RETURNING g_sfv[l_ac].sfv44
                  DISPLAY BY NAME g_sfv[l_ac].sfv44
                  NEXT FIELD sfv44

                #FUN-BC0104---add---str
                WHEN INFIELD(sfv46)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_qco1"     
                  LET g_qryparam.default1 = g_sfv[l_ac].sfv46 
                  LET g_qryparam.arg1 = g_sfv[l_ac].sfv17
                  CALL cl_create_qry() RETURNING g_sfv[l_ac].sfv46,g_sfv[l_ac].sfv47
                  DISPLAY BY NAME g_sfv[l_ac].sfv46,g_sfv[l_ac].sfv47
                  NEXT FIELD sfv46

                WHEN INFIELD(sfv47)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_qco1"     
                  LET g_qryparam.default1 = g_sfv[l_ac].sfv47 
                  LET g_qryparam.arg1 = g_sfv[l_ac].sfv17
                  CALL cl_create_qry() RETURNING g_sfv[l_ac].sfv46,g_sfv[l_ac].sfv47
                  DISPLAY BY NAME g_sfv[l_ac].sfv46,g_sfv[l_ac].sfv47
                  NEXT FIELD sfv47
                #FUN-BC0104---add---end
           END CASE

        ON ACTION gen_detail
           CALL t620_y_b()
           LET g_action_choice="gen_detail"
           COMMIT WORK
           RETURN

        ON ACTION QBE_WO_No
        IF NOT cl_null(g_sfu.sfu08) THEN
             CASE WHEN INFIELD(sfv11)    #工單單號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_sfv11"
                  LET g_qryparam.default1 = g_sfv[l_ac].sfv11 
                  LET g_qryparam.arg1 = g_sfu.sfu08
                  ##組合拆解的工單不顯示出來!
                 #LET g_qryparam.where = " substr(sfv11,1,",g_doc_len,") NOT IN (SELECT smy69 FROM smy_file WHERE smy69 IS NOT NULL) "
                 #LET g_qryparam.where = " sfv11[1,",g_doc_len,"] NOT IN (SELECT smy69 FROM smy_file WHERE smy69 IS NOT NULL) "    #FUN-B40029 #TQC-B60154
                  LET g_qryparam.where = " sfd03[1,",g_doc_len,"] NOT IN (SELECT smy69 FROM smy_file WHERE smy69 IS NOT NULL) "    #TQC-B60154
                  CALL cl_create_qry() RETURNING g_sfv[l_ac].sfv11
                  DISPLAY BY NAME g_sfv[l_ac].sfv11
                  NEXT FIELD sfv11
             END CASE
        END IF
        ON ACTION qry_warehouse
                    #Mod No.FUN-AA0055
                    #CALL cl_init_qry_var()
                    #LET g_qryparam.form = 'q_imd'
                    #LET g_qryparam.default1 = g_sfv[l_ac].sfv05
                    #LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
                    #CALL cl_create_qry() RETURNING g_sfv[l_ac].sfv05
                     CALL q_imd_1(FALSE,TRUE,g_sfv[l_ac].sfv05,"",g_plant,"","")  #只能开当前门店的
                          RETURNING g_sfv[l_ac].sfv05
                    #End Mod No.FUN-AA0055
                     NEXT FIELD sfv05

        ON ACTION qry_location
                    #Mod No.FUN-AA0055
                    #CALL cl_init_qry_var()
                    #LET g_qryparam.form = 'q_ime'
                    #LET g_qryparam.default1 = g_sfv[l_ac].sfv06
                    #LET g_qryparam.arg1     = g_sfv[l_ac].sfv05 #倉庫編號 #MOD-4A0063
                    #LET g_qryparam.arg2     = 'SW'              #倉庫類別 #MOD-4A0063
                    #CALL cl_create_qry() RETURNING g_sfv[l_ac].sfv06
                     CALL q_ime_1(FALSE,TRUE,g_sfv[l_ac].sfv06,g_sfv[l_ac].sfv05,"",g_plant,"","","")
                          RETURNING g_sfv[l_ac].sfv06
                    #End Mod No.FUN-AA0055
                     NEXT FIELD sfv06

        ON ACTION modi_lot
           SELECT ima918,ima921 INTO g_ima918,g_ima921 
             FROM ima_file
            WHERE ima01 = g_sfv[l_ac].sfv04
              AND imaacti = "Y"
           
           IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
              IF cl_null(g_sfv[l_ac].sfv06) THEN
                 LET g_sfv[l_ac].sfv06 = ' '
              END IF
              IF cl_null(g_sfv[l_ac].sfv07) THEN
                 LET g_sfv[l_ac].sfv07 = ' '
              END IF
              SELECT img09 INTO g_img09 FROM img_file
               WHERE img01=g_sfv[l_ac].sfv04
                 AND img02=g_sfv[l_ac].sfv05
                 AND img03=g_sfv[l_ac].sfv06
                 AND img04=g_sfv[l_ac].sfv07
              CALL s_umfchk(g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv08,g_img09) 
                  RETURNING l_i,l_fac
              IF l_i = 1 THEN LET l_fac = 1 END IF
#CHI-9A0022 --Begin
              IF cl_null(g_sfv[l_ac].sfv41) THEN
                 LET l_bno = ''
              ELSE
                 LET l_bno = g_sfv[l_ac].sfv41
              END IF
#CHI-9A0022 --End
#TQC-B90236--mark--begin
#             CALL s_lotin(g_prog,g_sfu.sfu01,g_sfv[l_ac].sfv03,0,
#                          g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv08,g_img09,
#                          l_fac,g_sfv[l_ac].sfv09,l_bno,'MOD')#CHI-9A0022 add l_bno
#TQC-B90236--mark--end
#TQC-B90236--add---begin
              CALL s_wo_record(g_sfv[l_ac].sfv11,'Y')  #MOD-CB0031 add
              CALL s_mod_lot(g_prog,g_sfu.sfu01,g_sfv[l_ac].sfv03,0,
                             g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv05,
                             g_sfv[l_ac].sfv06,g_sfv[l_ac].sfv07,
                             g_sfv[l_ac].sfv08,g_img09,l_fac,g_sfv[l_ac].sfv09,l_bno,'MOD',1)
#TQC-B90236--add---end
                     RETURNING l_r,g_qty 
              IF l_r = "Y" THEN
                 LET g_sfv[l_ac].sfv09 = g_qty
                 LET g_sfv[l_ac].sfv09 = s_digqty(g_sfv[l_ac].sfv09,g_sfv[l_ac].sfv08)   #No.FUN-C20048
                 DISPLAY BY NAME g_sfv[l_ac].sfv09     #MOD-B20122 add
              END IF
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
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
      END INPUT

      IF l_sfu15_FLAG = 'Y' THEN  #FUN-C30293
         LET g_sfu.sfu15 = '0' #FUN-A80128 add
      END IF  #FUN-C30293 
      UPDATE sfu_file SET sfumodu = g_user,
                          sfudate = g_today,
                          sfu15   = g_sfu.sfu15 #FUN-A80128 add
       WHERE sfu01 = g_sfu.sfu01

     CLOSE t620_bcl
     COMMIT WORK

     CALL t620_delHeader()     #CHI-C30002 add
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION t620_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_sfu.sfu01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM sfu_file ",
                  "  WHERE sfu01 LIKE '",l_slip,"%' ",
                  "    AND sfu01 > '",g_sfu.sfu01,"'"
      PREPARE t620_pb1 FROM l_sql 
      EXECUTE t620_pb1 INTO l_cnt 
      
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
        #CALL t620_x()              #CHI-D20010
         CALL t620_x(1)             #CHI-D20010
         CALL t620_show()
         CALL t620_pic() 
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM sfu_file WHERE sfu01 = g_sfu.sfu01
         INITIALIZE g_sfu.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
#FUN-B50096 ----------------Begin------------------
FUNCTION t620_b_sfv07_inschk(p_cmd)
DEFINE   l_ima159   LIKE ima_file.ima159
DEFINE   p_cmd      LIKE type_file.chr1
   IF g_sfv[l_ac].sfv07 = '　' THEN #全型空白
       LET g_sfv[l_ac].sfv07 = ' '
        DISPLAY BY NAME g_sfv[l_ac].sfv07
   END IF
   IF NOT cl_null(g_sfv[l_ac].sfv04) THEN 
      LET l_ima159 = ''
      SELECT ima159 INTO l_ima159 FROM ima_file
       WHERE ima01 = g_sfv[l_ac].sfv04
      IF l_ima159 = '1' AND cl_null(g_sfv[l_ac].sfv07) THEN
         CALL cl_err(g_sfv[l_ac].sfv04,'aim-034',1)
         RETURN "sfv07"
      END IF
   END IF
   IF g_argv MATCHES '[123]' THEN #FUN-5C0114 add '3'
      IF cl_null(g_sfv[l_ac].sfv07) THEN
         LET g_sfv[l_ac].sfv07 = ' '
          DISPLAY BY NAME g_sfv[l_ac].sfv07
      END IF
      IF NOT cl_null(g_sfv[l_ac].sfv05) THEN
        #將整段包成一個FUNCTION
         IF NOT t620_add_img(g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv05,
                             g_sfv[l_ac].sfv06,g_sfv[l_ac].sfv07,
                             g_sfu.sfu01,      g_sfv[l_ac].sfv03,
                             g_today) THEN
 
            RETURN "sfv05"
         END IF

        #MOD-C50012---S---
            SELECT COUNT(*) INTO g_cnt FROM img_file
             WHERE img01 = g_sfv[l_ac].sfv04   #料號
               AND img02 = g_sfv[l_ac].sfv05   #倉庫
               AND img03 = g_sfv[l_ac].sfv06   #儲位
               AND img04 = g_sfv[l_ac].sfv07   #批號
               AND img18 < g_sfu.sfu02   #調撥日期
            IF g_cnt > 0 THEN    #大於有效日期
               call cl_err('','aim-400',0)   #須修改
               RETURN "sfv05"
            END IF
        #MOD-C50012---E---

         IF g_sma.sma115 ='N' THEN
            IF cl_null(g_sfv[l_ac].sfv08) THEN   #若單位空白
               LET g_sfv[l_ac].sfv08=g_img09
               LET g_sfv[l_ac].sfv09=s_digqty(g_sfv[l_ac].sfv09,g_sfv[l_ac].sfv08)   #No.FUN-BB0086
               DISPLAY BY NAME g_sfv[l_ac].sfv08
            END IF
         ELSE
        #MOD-C50012---S---
        #   SELECT COUNT(*) INTO g_cnt FROM img_file
        #    WHERE img01 = g_sfv[l_ac].sfv04   #料號
        #      AND img02 = g_sfv[l_ac].sfv05   #倉庫
        #      AND img03 = g_sfv[l_ac].sfv06   #儲位
        #      AND img04 = g_sfv[l_ac].sfv07   #批號
        #      AND img18 < g_sfu.sfu02   #調撥日期
        #   IF g_cnt > 0 THEN    #大於有效日期
        #      call cl_err('','aim-400',0)   #須修改
        #      RETURN "sfv05"
        #   END IF
        #MOD-C50012---E---

           # - FQC入庫不做雙單位處理
            IF cl_null(g_sfv[l_ac].sfv17) OR (g_argv='3') THEN  #FUN-5C0114 add OR (g_argv='3')
               CALL t620_du_default(p_cmd)
            ELSE
               CALL s_du_umfchk(g_sfv[l_ac].sfv04,'','','',
                                g_ima55,g_sfv[l_ac].sfv30,'1')
                    RETURNING g_errno,g_factor
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_sfv[l_ac].sfv30,g_errno,1)
                  RETURN "sfv07"
               END IF
               LET g_sfv[l_ac].sfv31 = g_factor
               DISPLAY BY NAME g_sfv[l_ac].sfv31
            END IF
         END IF
      END IF
   END IF
   RETURN NULL
END FUNCTION
#FUN-B50096 -----------------End------------------------

FUNCTION  t620_sfv17(p_cmd)
 DEFINE l_qcf02   LIKE qcf_file.qcf02,
        l_qcf021  LIKE qcf_file.qcf021,
        l_qcf14   LIKE qcf_file.qcf14,
        l_qcfacti LIKE qcf_file.qcfacti,
        l_qcf09   LIKE qcf_file.qcf09,
        l_qcf36   LIKE qcf_file.qcf36,   #No:FUN-610075
        l_qcf37   LIKE qcf_file.qcf37,   #No:FUN-610075
        l_qcf38   LIKE qcf_file.qcf38,   #No:FUN-610075
        l_qcf39   LIKE qcf_file.qcf39,   #No:FUN-610075
        l_qcf40   LIKE qcf_file.qcf40,   #No:FUN-610075
        l_qcf41   LIKE qcf_file.qcf41,   #No:FUN-610075
        p_cmd     LIKE type_file.chr1          #No.FUN-680121 CHAR(1)

   LET g_errno = ''
   SELECT qcf02,qcf021,qcf14,qcfacti,qcf09,
          qcf36,qcf37,qcf38,qcf39,qcf40,qcf41  #No:FUN-610075
     INTO l_qcf02,l_qcf021,l_qcf14,l_qcfacti,l_qcf09,
          l_qcf36,l_qcf37,l_qcf38,l_qcf39,l_qcf40,l_qcf41  #No:FUN-610075
     FROM qcf_file
    WHERE qcf01 = g_sfv[l_ac].sfv17

   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0044'
        WHEN l_qcfacti='N'        LET g_errno = '9028'
        WHEN l_qcf14='N'          LET g_errno = 'asf-048'
        WHEN l_qcf09='2'          LET g_errno = 'aqc-400'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) THEN
      LET g_sfv[l_ac].sfv11 = l_qcf02
      LET g_sfv[l_ac].sfv04 = l_qcf021
      LET g_sfv[l_ac].sfv30 = l_qcf36   #No:FUN-610075
      LET g_sfv[l_ac].sfv31 = l_qcf37   #No:FUN-610075
      LET g_sfv[l_ac].sfv32 = l_qcf38   #No:FUN-610075
      LET g_sfv[l_ac].sfv33 = l_qcf39   #No:FUN-610075
      LET g_sfv[l_ac].sfv34 = l_qcf40   #No:FUN-610075
      LET g_sfv[l_ac].sfv35 = l_qcf41   #No:FUN-610075
      DISPLAY BY NAME g_sfv[l_ac].sfv11
      DISPLAY BY NAME g_sfv[l_ac].sfv04
      DISPLAY BY NAME g_sfv[l_ac].sfv30,g_sfv[l_ac].sfv31,g_sfv[l_ac].sfv32  #No:FUN-610075
      DISPLAY BY NAME g_sfv[l_ac].sfv33,g_sfv[l_ac].sfv34,g_sfv[l_ac].sfv35  #No:FUN-610075
   END IF

   IF cl_null(g_sfv_t.sfv11) OR g_sfv[l_ac].sfv11 ! = g_sfv_t.sfv11 THEN
      CALL t620_sfb01(l_ac,p_cmd)
   END IF

END FUNCTION

#--->工單相關資料顯示於劃面
 FUNCTION  t620_sfb01(p_ac,p_cmd)  #MOD-480206
   DEFINE l_ima02   LIKE ima_file.ima02,
          l_ima021  LIKE ima_file.ima021,
          l_ima25   LIKE ima_file.ima25,
          l_ima35   LIKE ima_file.ima35,
          l_ima36   LIKE ima_file.ima36,
          l_ima55   LIKE ima_file.ima55,
          l_ima55_fac   LIKE ima_file.ima55_fac,
          l_sfv09   LIKE sfv_file.sfv09,
          l_qcf091  LIKE qcf_file.qcf091,
          l_smydesc LIKE smy_file.smydesc,
          l_cnt     LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_d2      LIKE oea_file.oea01,          #No:FUN-680121 CHAR(15)
          l_d4      LIKE type_file.chr20,         #No:FUN-680121 CHAR(20)
          l_no     LIKE type_file.chr5,           #No:FUN-680121 CHAR(5)#No.FUN-540055
          l_status LIKE type_file.num10,          #No:FUN-680121 INTEGER
          p_cmd    LIKE type_file.chr1,           #No.FUN-680121 CHAR(1)
          p_ac     LIKE type_file.num5            #No:FUN-680121 SMALLINT
 
    INITIALIZE g_sfb.* TO NULL
   LET g_err = 'N'     #MOD-B90063 add
   IF NOT cl_null(g_sfv[p_ac].sfv17) AND g_sma.sma896='Y' THEN

      LET l_qcf091 = 0
     #LET g_err ='N'    #No:TQC-5B0075 add   #MOD-B90063 mark   #將此行程式碼往上移，在最一開始時做控卡
      SELECT qcf091 INTO l_qcf091 FROM qcf_file
       WHERE qcf01 = g_sfv[p_ac].sfv17
         AND qcf02 = g_sfv[p_ac].sfv11
         AND qcf09 <> '2'                 #NO:6872
         AND qcf14 = 'Y'
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_sfv[p_ac].sfv17,'asf-732',1)
         LET g_err ='Y'     #No:TQC-5B0075 add
         RETURN
      ELSE
         IF cl_null(l_qcf091) THEN
            LET l_qcf091 = 0
         END IF
      END IF
   END IF

    LET l_ima02=' '
    LET l_ima021=' '
    LET l_ima25=' '
    LET l_ima35=' '
    LET l_ima36=' '
    LET l_ima55=' '
    LET l_ima55_fac=0
 
    SELECT sfb_file.* INTO g_sfb.* FROM sfb_file  #No.TQC-9A0120 mod
     WHERE sfb01=g_sfv[p_ac].sfv11
    IF SQLCA.sqlcode THEN
       LET l_status=SQLCA.sqlcode
    ELSE
       LET l_status=0
    END IF
 
    LET g_sfv[p_ac].sfv04 = g_sfb.sfb05      #MOD-540191

    LET g_sfv[p_ac].sfv41 = g_sfb.sfb27
    LET g_sfv[p_ac].sfv42 = g_sfb.sfb271
    LET g_sfv[p_ac].sfv43 = g_sfb.sfb50
    LET g_sfv[p_ac].sfv44 = g_sfb.sfb51

    SELECT ima02,ima021,ima35,ima36,ima55,ima55_fac
      INTO l_ima02,l_ima021,l_ima35,l_ima36,l_ima55,l_ima55_fac
      FROM ima_file
     WHERE ima01 = g_sfb.sfb05
    IF SQLCA.sqlcode THEN
       CALL cl_err('sel ima:',SQLCA.sqlcode,1)
       LET l_status = SQLCA.sqlcode
   ##Add No.FUN-AA0055  #Mark No.FUN-AB0054 此处不做判断，交予单据审核时控管
   #ELSE
   #   IF NOT s_chk_ware(l_ima35) THEN  #检查仓库是否属于当前门店
   #      LET l_ima35 = ' '
   #      LET l_ima36 = ' '
   #   END IF
   ##End Add No.FUN-AA0055
    END IF

    LET g_errno=' '
    CASE
       WHEN l_status = NOTFOUND
            LET g_errno = 'mfg9005'
            INITIALIZE g_sfb.* TO NULL
            LET l_ima02=' '
            LET l_ima021=' '
            LET l_ima35=' '
            LET l_ima36=' '
            LET l_ima55=' '
            #MOD-B80329 --- modify --- start ---
            CALL cl_err('',g_errno,0)
            LET g_err = 'Y'
            RETURN 
            #MOD-B80329 --- modify ---  end  ---
       WHEN g_sfb.sfbacti='N'
            LET g_errno = '9028'
            #MOD-B80329 --- modify --- start ---
            CALL cl_err('',g_errno,0)
            LET g_err = 'Y'
            RETURN 
            #MOD-B80329 --- modify ---  end  ---
       WHEN g_argv='0' AND g_sfb.sfb06 IS NULL
            LET g_errno = 'asf-394'
            #MOD-B80329 --- modify --- start ---
            CALL cl_err('',g_errno,0)
            LET g_err = 'Y'
            RETURN 
            #MOD-B80329 --- modify ---  end  ---
       WHEN g_sfb.sfb04<'2' OR   g_sfb.sfb28='3'
            LET g_errno='mfg9006'
            #MOD-B80329 --- modify --- start ---
            CALL cl_err('',g_errno,0)
            LET g_err = 'Y'
            RETURN 
            #MOD-B80329 --- modify ---  end  ---
       WHEN g_sfb.sfb04 ='8'
            LET g_errno='mfg3430'
            #MOD-B80329 --- modify --- start ---
            CALL cl_err('',g_errno,0)
            LET g_err = 'Y'
            RETURN 
            #MOD-B80329 --- modify ---  end  ---
       #TQC-C70109--add--str--
       WHEN g_sfb.sfb04 < '4'
            IF g_sfb.sfb39 != '2' THEN
               LET g_errno='asf-570'
               CALL cl_err('',g_errno,0)
               LET g_err = 'Y'
               RETURN
            END IF
       #TQC-C70109--add--end--
       OTHERWISE
            LET g_errno = l_status USING '-------'
    END CASE
     IF g_sfb.sfb02 MATCHES '[78]' THEN    #委外工單      #MOD-470503 add [8]
       LET g_errno='mfg9185'
       #MOD-B80329 --- modify --- start ---
       CALL cl_err('',g_errno,0)
       LET g_err = 'Y'
       RETURN 
       #MOD-B80329 --- modify ---  end  ---
    END IF
    IF g_sfb.sfb02 = 11 THEN    #拆件式工單
       LET g_errno='asf-709'
       #MOD-B80329 --- modify --- start ---
       CALL cl_err('',g_errno,0)
       LET g_err = 'Y'
       RETURN 
       #MOD-B80329 --- modify ---  end  ---
    END IF

    IF p_cmd = 'a' THEN  #MOD-480206 add
       IF g_sfb.sfb30 IS NULL OR g_sfb.sfb30 = ' ' THEN
          LET g_sfv[p_ac].sfv05 = l_ima35
       ELSE
          LET g_sfv[p_ac].sfv05 = g_sfb.sfb30
       END IF
       IF g_sfb.sfb31 IS NULL OR g_sfb.sfb31 = ' ' THEN
          LET g_sfv[p_ac].sfv06 = l_ima36
       ELSE
          LET g_sfv[p_ac].sfv06 = g_sfb.sfb31
       END IF
       LET g_sfv[p_ac].sfv07 = ' '  #MOD-D40122
    END IF  #MOD-480206 add
    LET g_sfv[p_ac].ima02  = l_ima02
    LET g_sfv[p_ac].ima021 = l_ima021

    LET g_sfv[p_ac].sfv08  = l_ima55       #生產單位
    LET g_sfv[p_ac].sfv09  = s_digqty(g_sfv[p_ac].sfv09,g_sfv[p_ac].sfv08)    #No.FUN-BB0086
    LET g_sfv[p_ac].sfv30  = l_ima55       #生產單位
    LET g_sfv[p_ac].sfv32  = s_digqty(g_sfv[p_ac].sfv32,g_sfv[p_ac].sfv30)    #No.FUN-BB0086
    LET g_sfv[p_ac].sfv31  = 1


#須走FQC流程-合計FQC單總完工入庫量
    IF p_cmd = 'a' THEN  #FUN-540055 add
       IF g_sfb.sfb94 = 'Y' THEN          #MOD-5B0304 add
          SELECT SUM(sfv09) INTO l_sfv09 FROM sfv_file,sfu_file
           WHERE sfv17 = g_sfv[l_ac].sfv17
             AND (( sfv01 != g_sfu.sfu01 ) OR
                  ( sfv01 = g_sfu.sfu01 AND sfv03 != g_sfv[l_ac].sfv03 ))
             AND sfv01 = sfu01
             AND sfuconf !='X' #FUN-660137
          IF cl_null(l_sfv09) THEN
             LET l_sfv09 = 0
          END IF
          LET g_sfv[p_ac].sfv32 = l_qcf091 - l_sfv09
       ELSE
          LET g_sfv[p_ac].sfv32 = g_sfb.sfb081 - g_sfb.sfb09
       END IF
    END IF
    IF g_sma.sma115 = 'Y' THEN
       CALL t620_du_default(p_cmd)
    END IF

    LET g_sfv[l_ac].sfv930=g_sfb.sfb98 #FUN-670103
    LET g_sfv[l_ac].gem02c=s_costcenter_desc(g_sfv[l_ac].sfv930) #FUN-670103
    DISPLAY BY NAME g_sfv[p_ac].sfv930 #FUN-670103
    DISPLAY BY NAME g_sfv[p_ac].gem02c #FUN-670103
    
    DISPLAY BY NAME g_sfv[p_ac].sfv04
    DISPLAY BY NAME g_sfv[p_ac].ima02
    DISPLAY BY NAME g_sfv[p_ac].ima021
    DISPLAY BY NAME g_sfv[p_ac].sfv05
    DISPLAY BY NAME g_sfv[p_ac].sfv06
    DISPLAY BY NAME g_sfv[p_ac].sfv07
    DISPLAY BY NAME g_sfv[p_ac].sfv08
    DISPLAY BY NAME g_sfv[p_ac].sfv30
    DISPLAY BY NAME g_sfv[p_ac].sfv31
    DISPLAY BY NAME g_sfv[p_ac].sfv32
    DISPLAY BY NAME g_sfv[p_ac].sfv41
    DISPLAY BY NAME g_sfv[p_ac].sfv42
    DISPLAY BY NAME g_sfv[p_ac].sfv43
    DISPLAY BY NAME g_sfv[p_ac].sfv44
END FUNCTION

#--->工單相關資料顯示於劃面
FUNCTION  t620_sfb011(p_ac)
   DEFINE l_ima02   LIKE ima_file.ima02,
          l_ima021  LIKE ima_file.ima021,
          l_ima25   LIKE ima_file.ima25,
          l_ima35   LIKE ima_file.ima35,
          l_ima36   LIKE ima_file.ima36,
          l_ima55   LIKE ima_file.ima55,
          l_sfv09   LIKE sfv_file.sfv09,
          l_smydesc LIKE smy_file.smydesc,
          l_cnt     LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_d2      LIKE type_file.chr20,         #No:FUN-680121 CHAR(15)
          l_d4      LIKE type_file.chr20,         #No:FUN-680121 CHAR(20)
          l_no     LIKE aab_file.aab02,           #No:FUN-680121 #No.FUN-540055
          l_status LIKE type_file.num10,          #No:FUN-680121 INTEGER
          p_ac     LIKE type_file.num5            #No:FUN-680121 SMALLINT
 
    INITIALIZE g_sfb.* TO NULL
    LET l_ima02=' '
    LET l_ima021=' '
    LET l_ima35=' '
    LET l_ima36=' '
    LET l_ima55=' '
    LET g_min_set = 0
    LET l_sfv09 = 0
    SELECT sfb_file.*   #No.TQC-9A0120 mod
    INTO g_sfb.*
    FROM  sfb_file
    WHERE sfb01=g_sfv[p_ac].sfv11
    IF SQLCA.sqlcode THEN
       LET l_status=SQLCA.sqlcode
    ELSE
       LET l_status=0
    END IF
 
    SELECT ima02,ima021,ima35,ima36,ima55
      INTO l_ima02,l_ima021,l_ima35,l_ima36,l_ima55
     FROM ima_file WHERE ima01 = g_sfb.sfb05
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_sfb.sfb05,SQLCA.sqlcode,1)
       LET l_status = SQLCA.sqlcode
   ##Add No.FUN-AA0055  #Mark No.FUN-AB0054 此处不做判断，交予单据审核时控管
   #ELSE
   #   IF NOT s_chk_ware(l_ima35) THEN  #检查仓库是否属于当前门店
   #      LET l_ima35 = ' '
   #      LET l_ima36 = ' '
   #   END IF
   ##End Add No.FUN-AA0055
    END IF
    LET g_errno=' '
    CASE
       WHEN l_status = NOTFOUND
            LET g_errno = 'mfg9005'
            INITIALIZE g_sfb.* TO NULL
            LET l_ima02=' '
            LET l_ima021=' '
            LET l_ima35=' '
            LET l_ima36=' '
            LET l_ima55=' '
       WHEN g_sfb.sfbacti='N' LET g_errno = '9028'
       WHEN g_argv='0' AND g_sfb.sfb06 IS NULL LET g_errno = 'asf-394'
       WHEN g_sfb.sfb04<'2' OR   g_sfb.sfb28='3'
            LET g_errno='mfg9006'
       OTHERWISE
            LET g_errno = l_status USING '-------'
    END CASE
    LET g_sfv[p_ac].sfv04 = g_sfb.sfb05
    IF g_argv='2' THEN
       IF g_sfb.sfb30 IS NULL OR g_sfb.sfb30 = ' ' THEN
          LET g_sfv[p_ac].sfv05 = l_ima35
       ELSE
          LET g_sfv[p_ac].sfv05 = g_sfb.sfb30
       END IF
       IF g_sfb.sfb31 IS NULL OR g_sfb.sfb31 = ' ' THEN
          LET g_sfv[p_ac].sfv06 = l_ima36
       ELSE
          LET g_sfv[p_ac].sfv06 = g_sfb.sfb31
       END IF
       LET g_sfv[p_ac].sfv07 = ' '  #MOD-D40122
       LET g_sfv[p_ac].sfv09 = g_sfb.sfb09
    END IF
    LET g_sfv[p_ac].ima02 = l_ima02
    LET g_sfv[p_ac].ima021= l_ima021
    LET g_sfv[p_ac].sfv08 = l_ima55    #生產單位
    LET g_sfv[l_ac].sfv09=s_digqty(g_sfv[l_ac].sfv09,g_sfv[l_ac].sfv08)   #No.FUN-C20048
END FUNCTION

FUNCTION t620_b_else()
     IF g_sfv[l_ac].sfv05 IS NULL THEN LET g_sfv[l_ac].sfv05 =' ' END IF
     IF g_sfv[l_ac].sfv06 IS NULL THEN LET g_sfv[l_ac].sfv06 =' ' END IF
     IF g_sfv[l_ac].sfv07 IS NULL THEN LET g_sfv[l_ac].sfv07 =' ' END IF
END FUNCTION

FUNCTION t620_y_b()

      OPEN WINDOW t620_y_w AT 2,12 WITH FORM "asf/42f/asft620y"
            ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN

      CALL cl_ui_locale("asft620y")

      CALL t620_y_b1()

      CLOSE WINDOW t620_y_w

      CALL t620_b_fill(' 1=1')
      CALL t620_b()
      CALL t620_show() #FUN-A80128 add

END FUNCTION
 
FUNCTION t620_y_b1()
   DEFINE l_sql,l_wc          LIKE type_file.chr1000       #No.FUN-680121 CHAR(500)
   DEFINE i,j,k,l_i           LIKE type_file.num10         #No:FUN-680121 INTEGER
   DEFINE in_qty_t,qty_t      LIKE type_file.num10         #No:FUN-680121 INTEGER
   DEFINE l_sfb DYNAMIC ARRAY OF RECORD
			sfb05	LIKE sfb_file.sfb05,
			sfb01	LIKE sfb_file.sfb01,
			seq  	LIKE type_file.num5,          #No:FUN-680121 SMALLINT
			qty	LIKE type_file.num10,         #No:FUN-680121 INTEGER
			y  	LIKE type_file.chr1,          #No:FUN-680121 CHAR(1)
			in_qty	LIKE type_file.num10,         #No:FUN-680121 INTEGER
			sfb98 LIKE sfb_file.sfb98 #FUN-670103
		 	END RECORD
   DEFINE l_sfv  RECORD LIKE sfv_file.*
   DEFINE l_sfvi RECORD LIKE sfvi_file.*   #FUN-B70061
    DEFINE partno          LIKE sfb_file.sfb05   #No:MOD-490217
   DEFINE tot_qty,qty2	  LIKE type_file.num10         #No:FUN-680121 INTEGER
   DEFINE seq1		  LIKE type_file.num5          #No:FUN-680121 SMALLINT
   DEFINE ware            LIKE img_file.img02,
          loc             LIKE img_file.img03,
          lot             LIKE img_file.img04,
          l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680121 SMALLINT
          l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680121 SMALLINT
   DEFINE l_cnt           LIKE type_file.num5       #MOD-A80079 add
   DEFINE g_min_set2      LIKE type_file.num5       #MOD-A80079 add
   DEFINE l_over_qty2     LIKE type_file.num5       #MOD-A80079 add
   DEFINE g_over_qty2     LIKE type_file.num5       #MOD-A80079 add
   DEFINE tmp_qty2        LIKE type_file.num5       #MOD-A80079 add
   DEFINE l_ima153        LIKE ima_file.ima153      #MOD-A80079 add

   LET seq1=NULL
   INPUT BY NAME partno,seq1,tot_qty,ware,loc,lot WITHOUT DEFAULTS

      AFTER FIELD partno
        LET g_cnt = 0
        SELECT COUNT(*) INTO g_cnt FROM ima_file
          #WHERE ima01=g_sfb.sfb05      #MOD-A80079 mark
           WHERE ima01=partno           #MOD-A80079 add
        IF g_cnt=0 THEN
           CALL cl_err('','asf-399',1)
           NEXT FIELD partno
        END IF

      #Add No.FUN-AA0055
      AFTER FIELD ware
        IF NOT cl_null(ware) THEN
           IF NOT s_chk_ware(ware) THEN  #检查仓库是否属于当前门店
              NEXT FIELD ware
           END IF
        END IF
      #End Add No.FUN-AA0055

      AFTER FIELD loc
        IF NOT cl_null(ware) OR NOT cl_null(loc) THEN
           IF NOT s_chksmz('', g_sfu.sfu01,ware,loc) THEN
              NEXT FIELD ware
           END IF
        END IF

      ON ACTION controlp
        CASE WHEN INFIELD(partno)
#FUN-AA0059---------mod------------str-----------------
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form ="q_ima"
#                 LET g_qryparam.default1 = partno
#                 CALL cl_create_qry() RETURNING partno
                  CALL q_sel_ima(FALSE, "q_ima","",partno,"","","","","",'' ) 
                    RETURNING  partno 
#FUN-AA0059---------mod------------end-----------------
                  DISPLAY BY NAME partno
                  NEXT FIELD partno
        END CASE

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
   END INPUT

   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF  #MOD-8A0197  add return

   IF g_sfu.sfu00='1' THEN
      LET l_sql="SELECT sfb05,sfb01,ecm03,sfb081-sfb09,'','',sfb25,sfb98", #FUN-670103
                "  FROM sfb_file LEFT OUTER JOIN ecm_file ON sfb01 = ecm01 ", #No.TQC-9A0120 mod
                " WHERE sfb081>sfb09 AND sfb04<'8'",
                "   AND sfb05 = '",partno CLIPPED,"'",
                "   AND sfb02 <> '7' AND sfb02 <> '8' " #MOD-850223 add 排除委外工單  #MOD-8A0197 modify sfb07->sfb02
                IF seq1 IS NOT NULL THEN
                   LET l_sql=l_sql CLIPPED, " AND ecm03=",seq1
                END IF
                LET l_sql=l_sql CLIPPED, " ORDER BY sfb05,sfb01,ecm03"
   END IF
   IF g_sfu.sfu00='2' THEN
      LET l_sql="SELECT sfb05,sfb01,0,sfb09,'','',sfb25,sfb98", #FUN-670103
                "  FROM sfb_file",
                " WHERE sfb09>0 AND sfb04<'8'",
                "   AND sfb05 MATCHES '",partno CLIPPED,"'",
                " ORDER BY sfb05,sfb25 DESC"	# 依實際開工日排列(後進先出)
   END IF
   PREPARE t620_y_b1_p FROM l_sql
   DECLARE t620_y_b1_c CURSOR FOR t620_y_b1_p
   LET i   = 1
   LET l_i = 0
   LET qty2=tot_qty
   CALL cl_msg("Waiting...")
   FOREACH t620_y_b1_c INTO l_sfb[i].*
      IF g_sfu.sfu00 = '1' THEN
         IF l_sfb[i].qty<=0 THEN CONTINUE FOREACH END IF
      END IF
      IF qty2>0 THEN
         LET l_sfb[i].y='Y'
         IF qty2 > l_sfb[i].qty
            THEN LET l_sfb[i].in_qty=l_sfb[i].qty
            ELSE LET l_sfb[i].in_qty=qty2
         END IF
         LET qty2 = qty2 - l_sfb[i].in_qty
      ELSE
         LET l_sfb[i].y='N'
      END IF
      LET i=i+1
   END FOREACH

   CALL l_sfb.deleteElement(i)
   CALL cl_msg("")
   LET l_i = i - 1
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   INPUT ARRAY l_sfb WITHOUT DEFAULTS FROM s_sfb.*
         ATTRIBUTE(COUNT=l_i,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)

      BEFORE INPUT
        IF l_i !=0 THEN
           CALL fgl_set_arr_curr(i)
        END IF

      BEFORE ROW
        LET i=ARR_CURR()
        CALL cl_show_fld_cont()     #FUN-550037(smin)

      BEFORE FIELD y
        LET qty_t=0 LET in_qty_t=0
        FOR k=1 TO l_sfb.getLength()
            IF l_sfb[k].qty > 0 THEN
               LET qty_t = qty_t+l_sfb[k].qty
            END IF
            IF l_sfb[k].y ='Y' AND l_sfb[k].in_qty IS NOT NULL THEN
               LET in_qty_t = in_qty_t+l_sfb[k].in_qty
            END IF
        END FOR
        DISPLAY BY NAME qty_t,in_qty_t
   #TQC-C90029--add--start--
      ON CHANGE y
         IF l_sfb[i].y IS NULL OR l_sfb[i].y<>'Y' THEN
            LET l_sfb[i].in_qty=NULL
            DISPLAY l_sfb[i].in_qty TO s_sfb[j].in_qty
         END IF
   #TQC-C90029--add--end--

      BEFORE FIELD in_qty
        IF l_sfb[i].y IS NULL OR l_sfb[i].y<>'Y'  OR l_sfb[i].sfb01 IS NULL THEN
           LET l_sfb[i].in_qty=NULL
           DISPLAY l_sfb[i].in_qty TO s_sfb[j].in_qty
           NEXT FIELD PREVIOUS
        END IF
        IF l_sfb[i].in_qty IS NULL OR l_sfb[i].in_qty = 0 THEN
           LET l_sfb[i].in_qty = l_sfb[i].qty
           DISPLAY l_sfb[i].in_qty TO s_sfb[j].in_qty
        END IF

      AFTER FIELD in_qty
        IF l_sfb[i].in_qty > l_sfb[i].qty THEN
           CALL cl_err('','asf-550',0) NEXT FIELD in_qty
        END IF
       #MOD-A80079---add---start---
        LET l_ima153=NULL
        CALL s_get_ima153(partno) RETURNING l_ima153
        LET g_min_set2 = 0
      # CALL s_minp(l_sfb[i].sfb01,g_sma.sma73,0,'','','')               #FUN-C70037  mark
        CALL s_minp(l_sfb[i].sfb01,g_sma.sma73,0,'','','',g_sfu.sfu02)   #FUN-C70037
             RETURNING l_cnt,g_min_set2
        IF l_cnt !=0  THEN
           CALL cl_err('s_minp()','asf-549',0)
           RETURN FALSE
        END IF

        LET l_over_qty2=0
        LET g_over_qty2=0
        IF g_sma.sma73='Y' THEN 
        #  CALL s_minp(l_sfb[i].sfb01,g_sma.sma73,l_ima153,'','','')               #FUN-C70037  mark
           CALL s_minp(l_sfb[i].sfb01,g_sma.sma73,l_ima153,'','','',g_sfu.sfu02)   #FUN-C70037 
                RETURNING l_cnt,l_over_qty2
           
           IF cl_null(l_over_qty2) THEN LET l_over_qty2 = 0 END IF
           LET g_over_qty2 = l_over_qty2 - g_min_set2
        ELSE
           LET g_over_qty2=0
        END IF

        IF g_over_qty2 IS NULL THEN LET g_over_qty2=0 END IF

        # sum(已存在入庫單入庫數量) by W/O (不管有無過帳)
        LET tmp_qty2=0
        SELECT SUM(sfv09) INTO tmp_qty2 FROM sfv_file,sfu_file
         WHERE sfv11 = l_sfb[i].sfb01
           AND sfv01 = sfu01
           AND sfu00 = '1'   #類別 1.入庫  2.入庫退回
           AND sfuconf <> 'X' 

        IF tmp_qty2 IS NULL OR SQLCA.sqlcode THEN LET tmp_qty2=0 END IF
        IF l_sfb[i].in_qty > (g_min_set2 - tmp_qty2 + g_over_qty2) THEN
           LET l_sfb[i].in_qty=g_min_set2 - tmp_qty2 + g_over_qty2
        END IF
       #MOD-A80079---add---end---

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
   END INPUT

   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF

   IF NOT cl_sure(0,0) THEN RETURN END IF

   INITIALIZE l_sfv.* TO NULL
   SELECT MAX(sfv03) INTO l_sfv.sfv03 FROM sfv_file WHERE sfv01=g_sfu.sfu01
   IF l_sfv.sfv03 IS NULL THEN LET l_sfv.sfv03 = 0 END IF
   FOR k=1 TO l_sfb.getLength()
       IF l_sfb[k].sfb01 IS NULL THEN CONTINUE FOR END IF
       IF l_sfb[k].in_qty IS NULL OR l_sfb[k].in_qty<=0 THEN CONTINUE FOR END IF
       LET l_sfv.sfv01=g_sfu.sfu01
       LET l_sfv.sfv03=l_sfv.sfv03+1
       LET l_sfv.sfv04=l_sfb[k].sfb05
       LET l_sfv.sfv05=ware
       LET l_sfv.sfv06=loc
       LET l_sfv.sfv07=lot
       SELECT ima55 INTO l_sfv.sfv08 FROM ima_file WHERE ima01=l_sfv.sfv04
       LET l_sfv.sfv09=l_sfb[k].in_qty    
       LET l_sfv.sfv09 = s_digqty(l_sfv.sfv09,l_sfv.sfv08)    #No.FUN-BB0086 
       LET l_sfv.sfv11=l_sfb[k].sfb01
       LET l_sfv.sfv930=l_sfb[k].sfb98 #FUN-670103
       #依工單號將工單單頭的專案/WBS/活動/理由碼自動代入到sfv單身
        SELECT sfb27,sfb271,sfb50,sfb51 
          INTO l_sfv.sfv41,l_sfv.sfv42,l_sfv.sfv43,l_sfv.sfv44
          FROM sfb_file
         WHERE sfb01 = l_sfv.sfv11

       LET g_success = 'Y'      #MOD-A80079 add
       IF s_chk_rvbs(l_sfv.sfv41,l_sfv.sfv04) THEN
        #LET g_success = 'Y'    #MOD-A80079 mark 
         CALL t620_rvbs(l_sfv.sfv03,l_sfv.sfv04,l_sfv.sfv08,l_sfv.sfv09,l_sfv.sfv41)
       END IF
       IF g_success = 'Y' THEN
          LET l_sfv.sfvplant = g_plant #FUN-980008 add
          LET l_sfv.sfvlegal = g_legal #FUN-980008 add
          #FUN-CB0087--add--str--
          IF g_aza.aza115 = 'Y' THEN
             LET l_sfv.sfv44 = s_reason_code(g_sfu.sfu01,l_sfv.sfv11,'',l_sfv.sfv04,l_sfv.sfv05,g_sfu.sfu16,g_sfu.sfu04) 
          END IF  
          #FUN-CB0087--add--end--
          INSERT INTO sfv_file VALUES(l_sfv.*)
          
       END IF
       LET l_sql='ins sfv:',l_sfv.sfv03,l_sfv.sfv11,STATUS
       CALL cl_msg(l_sql)
   END FOR
END FUNCTION

FUNCTION t621_y_b()
   DEFINE l_sql,l_wc	LIKE type_file.chr1000       #No.FUN-680121 CHAR(500)
   DEFINE i,j,k,l_i     LIKE type_file.num10         #No:FUN-680121 INTEGER
   DEFINE in_qty_t,qty_t	LIKE type_file.num10         #No:FUN-680121 INTEGER
   DEFINE l_sfb DYNAMIC ARRAY OF RECORD
          sfb05   LIKE sfb_file.sfb05,
          sfb01   LIKE sfb_file.sfb01,
          qty     LIKE type_file.num10,         #No:FUN-680121 INTEGER
          y       LIKE type_file.chr1,          #No:FUN-680121 CHAR(1)
          in_qty  LIKE type_file.num10,         #No:FUN-680121 INTEGER
          sfb98   LIKE sfb_file.sfb98 #FUN-670103
          END RECORD
   DEFINE l_sfv  RECORD LIKE sfv_file.*
   DEFINE l_sfvi RECORD LIKE sfvi_file.*   #FUN-B70061
   DEFINE partno	LIKE sfb_file.sfb05   #No:MOD-490217
   DEFINE tot_qty,qty2	LIKE type_file.num10         #No:FUN-680121 INTEGER
   DEFINE seq1,seq2	LIKE type_file.num5,         #No:FUN-680121 SMALLINT
          l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680121 SMALLINT
          l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680121 SMALLINT

   LET g_action_choice = ""
 
   INPUT BY NAME partno,tot_qty,seq1,seq2 WITHOUT DEFAULTS
      AFTER FIELD partno
        IF partno IS NULL THEN NEXT FIELD partno END IF
      AFTER FIELD seq1
        IF seq1 IS NULL THEN NEXT FIELD seq1 END IF
      AFTER FIELD seq2
        IF seq2 IS NULL THEN NEXT FIELD seq2 END IF

      ON ACTION controlp
        CASE WHEN INFIELD(partno)    #
#FUN-AA0059---------mod------------str-----------------
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form ="q_ima"
#                 LET g_qryparam.default1 = partno
#                 CALL cl_create_qry() RETURNING partno
                  CALL q_sel_ima(FALSE, "q_ima","",partno,"","","","","",'' ) 
                     RETURNING partno  
#FUN-AA0059---------mod------------end-----------------
                  DISPLAY BY NAME partno
                  NEXT FIELD partno
        END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
   END INPUT

   IF INT_FLAG THEN LET INT_FLAG=0 END IF
   LET l_sql="SELECT sfb05,sfb01,0,'','',sfb25,sfb98", #FUN-670103
             "  FROM sfb_file,ecm_file",
             " WHERE sfb04<'8'",
             "   AND sfb05 MATCHES '",partno CLIPPED,"'",
             "   AND sfb01=ecm01 AND ecm03=",seq1,
             " ORDER BY sfb05,sfb25"		# 依實際開工日排列(先進先出)
   PREPARE t621_y_b_p FROM l_sql
   DECLARE t621_y_b_c CURSOR FOR t621_y_b_p

   LET i=1
   LET l_i=0
   LET qty2=tot_qty

   CALL cl_msg("Waiting...")

   FOREACH t621_y_b_c INTO l_sfb[i].*
      IF qty2>0 THEN
         LET l_sfb[i].y='Y'
         IF qty2 > l_sfb[i].qty THEN
            LET l_sfb[i].in_qty=l_sfb[i].qty
         ELSE
            LET l_sfb[i].in_qty=qty2
         END IF
         LET qty2 = qty2 - l_sfb[i].in_qty
      END IF
      LET i=i+1

   END FOREACH
   CALL cl_msg("")
   LET l_i = i-1
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   INPUT ARRAY l_sfb WITHOUT DEFAULTS FROM s_sfb.*
         ATTRIBUTE(COUNT=l_i,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

      BEFORE INPUT
        CALL fgl_set_arr_curr(l_ac)

      BEFORE ROW
        LET i=ARR_CURR()
        CALL cl_show_fld_cont()     #FUN-550037(smin)

      BEFORE FIELD y
        LET qty_t=0 LET in_qty_t=0
        FOR k=1 TO l_sfb.getLength()
            IF l_sfb[k].qty > 0 THEN
               LET qty_t = qty_t+l_sfb[k].qty
            END IF
            IF l_sfb[k].y ='Y' AND l_sfb[k].in_qty IS NOT NULL THEN
               LET in_qty_t = in_qty_t+l_sfb[k].in_qty
            END IF
        END FOR
        DISPLAY BY NAME qty_t,in_qty_t

      BEFORE FIELD in_qty
        IF l_sfb[i].y IS NULL OR l_sfb[i].y<>'Y'  OR l_sfb[i].sfb01 IS NULL THEN
           LET l_sfb[i].in_qty=NULL
           DISPLAY l_sfb[i].in_qty TO s_sfb[j].in_qty
           NEXT FIELD PREVIOUS
        END IF
        IF l_sfb[i].in_qty IS NULL OR l_sfb[i].in_qty = 0 THEN
           LET l_sfb[i].in_qty = l_sfb[i].qty
           DISPLAY l_sfb[i].in_qty TO s_sfb[j].in_qty
        END IF

      AFTER FIELD in_qty
        IF l_sfb[i].in_qty > l_sfb[i].qty THEN
           CALL cl_err('','asf-550',0) NEXT FIELD in_qty
        END IF
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
   END INPUT

   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   IF NOT cl_sure(0,0) THEN RETURN END IF
   INITIALIZE l_sfv.* TO NULL
   SELECT MAX(sfv03) INTO l_sfv.sfv03 FROM sfv_file WHERE sfv01=g_sfu.sfu01
   IF l_sfv.sfv03 IS NULL THEN LET l_sfv.sfv03 = 0 END IF
   FOR k=1 TO l_sfb.getLength()
       IF l_sfb[k].sfb01 IS NULL                        THEN CONTINUE FOR END IF
       IF l_sfb[k].in_qty IS NULL OR l_sfb[k].in_qty<=0 THEN CONTINUE FOR END IF
       LET l_sfv.sfv01=g_sfu.sfu01
       LET l_sfv.sfv03=l_sfv.sfv03+1
       LET l_sfv.sfv04=l_sfb[k].sfb05
       LET l_sfv.sfv05=' '
       LET l_sfv.sfv06=' '
       LET l_sfv.sfv07=' '
       SELECT ima55 INTO l_sfv.sfv08 FROM ima_file WHERE ima01=l_sfv.sfv04
       LET l_sfv.sfv09=l_sfb[k].in_qty
       LET l_sfv.sfv09 = s_digqty(l_sfv.sfv09,l_sfv.sfv08)    #No.FUN-BB0086
       LET l_sfv.sfv11=l_sfb[k].sfb01
       LET l_sfv.sfv930=l_sfb[k].sfb98 #FUN-670103

       LET l_sfv.sfvplant = g_plant #FUN-980008 add
       LET l_sfv.sfvlegal = g_legal #FUN-980008 add
       #FUN-CB0087--add--str--
       IF g_aza.aza115 = 'Y' THEN
          LET l_sfv.sfv44 = s_reason_code(g_sfu.sfu01,l_sfv.sfv11,'',l_sfv.sfv04,l_sfv.sfv05,g_sfu.sfu16,g_sfu.sfu04) 
       END IF  
       #FUN-CB0087--add--end--
       INSERT INTO sfv_file VALUES(l_sfv.*)
       LET l_sql='ins sfv:',l_sfv.sfv03,l_sfv.sfv11,STATUS
       
       CALL cl_msg(l_sql)
   END FOR
END FUNCTION

FUNCTION t620_b_askkey()
DEFINE l_wc2           LIKE type_file.chr1000       #No.FUN-680121 CHAR(200)
 
    CONSTRUCT l_wc2 ON sfv03,sfv17,sfv11,sfv16,sfv04,sfv08,sfv05, #FUN-550085
                       sfv06,sfv07,sfv09,sfv41,sfv42,sfv43,sfv44,sfv12  #FUN-810045 add 41/42/43/44
                  FROM s_sfv[1].sfv03, s_sfv[1].sfv17,  #FUN-550085
                       s_sfv[1].sfv11,                  #NO:6872
                       s_sfv[1].sfv16,                  #NO:6872
                       s_sfv[1].sfv04,
                       s_sfv[1].sfv08, s_sfv[1].sfv05,
                       s_sfv[1].sfv06, s_sfv[1].sfv07, s_sfv[1].sfv09,
                       s_sfv[1].sfv41, s_sfv[1].sfv42, s_sfv[1].sfv43,s_sfv[1].sfv44,  #FUN-810045 add
                       s_sfv[1].sfv12
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
    CALL t620_b_fill(l_wc2)
END FUNCTION

FUNCTION t620_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2           LIKE type_file.chr1000       #No.FUN-680121 CHAR(200)

       IF cl_null(p_wc2) THEN LET p_wc2 = ' 1=1' END IF

       LET g_sql = "SELECT sfv03,sfv17,sfv14,sfv11,sfv46,qcl02,sfv47,sfv04,ima02,ima021,", #FUN-550085 #FUN-5C0114 add sfv14  #FUN-BC0104 add sfv46,qcl02,sfv47
                   "sfv08,sfv05,sfv06,sfv07,sfv09,sfv33,sfv34,",
                   "sfv35,sfv30,sfv31,sfv32,sfv41,sfv42,sfv43,sfv44,azf03,sfv12,sfv16,sfv930,'',  ", #FUN-670103  #FUN-810045 add sfv41-44  #MOD-A60141 add azf03
                   "sfvud01,sfvud02,sfvud03,sfvud04,sfvud05,",
                   "sfvud06,sfvud07,sfvud08,sfvud09,sfvud10,",
                   "sfvud11,sfvud12,sfvud13,sfvud14,sfvud15 ",
                   ",'','' ",   #FUN-B70061 
                   " FROM sfv_file LEFT OUTER JOIN ima_file ON sfv04 = ima01 ",  #No.TQC-9A0120 mod
                   "               LEFT OUTER JOIN azf_file ON sfv44 = azf01 AND azf02='2' AND azfacti='Y'",  #MOD-A60141 add azf_file
                   "               LEFT OUTER JOIN qcl_file ON sfv46 = qcl01 ",   #FUN-BC0104
                   " WHERE sfv01 ='",g_sfu.sfu01,"'",
                   " AND ",p_wc2 CLIPPED,  #單頭  #No.TQC-9A0120 mod
                   " ORDER BY sfv03"

    PREPARE t620_pb FROM g_sql
    DECLARE sfv_curs CURSOR FOR t620_pb

    CALL g_sfv.clear()

    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH sfv_curs INTO g_sfv[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      LET g_sfv[g_cnt].gem02c=s_costcenter_desc(g_sfv[g_cnt].sfv930) #FUN-670103
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	       EXIT FOREACH
      END IF
    END FOREACH

    CALL g_sfv.deleteElement(g_cnt)

    LET g_rec_b=g_cnt - 1

    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0

    #FUN-B30170 add begin-------------------------
    LET g_sql = " SELECT rvbs02,rvbs021,ima02,ima021,rvbs022,rvbs04,rvbs03,rvbs05,rvbs06,rvbs07,rvbs08",
                "   FROM rvbs_file LEFT JOIN ima_file ON rvbs021 = ima01",
                "  WHERE rvbs00 = '",g_prog,"' AND rvbs01 = '",g_sfu.sfu01,"'"
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

FUNCTION t620_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680121 CHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
#FUN-B30170 add begin--------------------------
   DIALOG ATTRIBUTE(UNBUFFERED)
      DISPLAY ARRAY g_sfv TO s_sfv.* ATTRIBUTE(COUNT=g_rec_b)

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
      
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################

      #FUN-CB0014---add---str---
      ON ACTION page_list
         LET g_action_flag = "page_list"  
         EXIT DIALOG
     #FUN-CB0014---add---end--- 
      ON ACTION CONTROLS                                                                                                          
         CALL cl_set_head_visible("","AUTO")                                                                                      
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
         CALL t620_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DIALOG                   #No:FUN-530067 HCN TEST
 

      ON ACTION previous
         CALL t620_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DIALOG                   #No:FUN-530067 HCN TEST
 

      ON ACTION jump
         CALL t620_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DIALOG                   #No:FUN-530067 HCN TEST
 

      ON ACTION next
         CALL t620_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DIALOG                   #No:FUN-530067 HCN TEST
 

      ON ACTION last
         CALL t620_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DIALOG                   #No:FUN-530067 HCN TEST
 

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
         CALL t620_def_form()   #FUN-610006
         CALL t620_pic() #圖形顯示 #FUN-660137
         EXIT DIALOG

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG

      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
    #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DIALOG
    #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DIALOG
#@    ON ACTION 庫存過帳
      ON ACTION stock_post
         LET g_action_choice="stock_post"
         EXIT DIALOG
#@    ON ACTION 過帳還原
      ON ACTION undo_post
         LET g_action_choice="undo_post"
         EXIT DIALOG
#@    ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DIALOG
#CHI-D20010---add--str
#@    ON ACTION 取消作廢
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DIALOG
#CHI-D20010---add--end
#@    ON ACTION 領料產生
      ON ACTION gen_mat_wtdw
         LET g_action_choice="gen_mat_wtdw"
         EXIT DIALOG
#@    ON ACTION 領料維護
      ON ACTION maint_mat_wtdw
         LET g_action_choice="maint_mat_wtdw"
         EXIT DIALOG

      #FUN-BC0104---add---str
      #QC 結果判定產生入庫單
      ON ACTION qc_determine_storage 
         LET g_action_choice = "qc_determine_storage"
         EXIT DIALOG
      #FUN-BC0104---add---end

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
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG

      ON ACTION related_document                #No:FUN-6A0166  相關文件
         LET g_action_choice="related_document"          
         EXIT DIALOG

      ON ACTION qry_lot
         LET g_action_choice="qry_lot"
         EXIT DIALOG
      #FUN-A80128---add----str---
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
      #FUN-A80128---add----end---

      AFTER DIALOG
         CONTINUE DIALOG

      &include "qry_string.4gl"
   END DIALOG
#FUN-B30170 add -end---------------------------
#FUN-B30170 mark begin--------------------------
#   DISPLAY ARRAY g_sfv TO s_sfv.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
#
#      BEFORE DISPLAY
#         CALL cl_navigator_setting( g_curs_index, g_row_count )
#
#      BEFORE ROW
#         LET l_ac = ARR_CURR()
#         CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
#
#      ##########################################################################
#      # Standard 4ad ACTION
#      ##########################################################################
#      ON ACTION CONTROLS                                                                                                          
#         CALL cl_set_head_visible("","AUTO")                                                                                      
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
#         CALL t620_fetch('F')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)  ######add in 040505
#           END IF
#           ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
# 
#
#      ON ACTION previous
#         CALL t620_fetch('P')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)  ######add in 040505
#           END IF
#	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
# 
#
#      ON ACTION jump
#         CALL t620_fetch('/')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)  ######add in 040505
#           END IF
#	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
# 
#
#      ON ACTION next
#         CALL t620_fetch('N')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)  ######add in 040505
#           END IF
#	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
# 
#
#      ON ACTION last
#         CALL t620_fetch('L')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)  ######add in 040505
#           END IF
#	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
# 
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
#         CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
#         CALL t620_def_form()   #FUN-610006
#         CALL t620_pic() #圖形顯示 #FUN-660137
#         EXIT DISPLAY
#
#      ON ACTION exit
#         LET g_action_choice="exit"
#         EXIT DISPLAY
#
#      ##########################################################################
#      # Special 4ad ACTION
#      ##########################################################################
#      ON ACTION controlg
#         LET g_action_choice="controlg"
#         EXIT DISPLAY
#    #@ON ACTION 確認
#      ON ACTION confirm
#         LET g_action_choice="confirm"
#         EXIT DISPLAY
#    #@ON ACTION 取消確認
#      ON ACTION undo_confirm
#         LET g_action_choice="undo_confirm"
#         EXIT DISPLAY
##@    ON ACTION 庫存過帳
#      ON ACTION stock_post
#         LET g_action_choice="stock_post"
#         EXIT DISPLAY
##@    ON ACTION 過帳還原
#      ON ACTION undo_post
#         LET g_action_choice="undo_post"
#         EXIT DISPLAY
##@    ON ACTION 作廢
#      ON ACTION void
#         LET g_action_choice="void"
#         EXIT DISPLAY
##@    ON ACTION 領料產生
#      ON ACTION gen_mat_wtdw
#         LET g_action_choice="gen_mat_wtdw"
#         EXIT DISPLAY
##@    ON ACTION 領料維護
#      ON ACTION maint_mat_wtdw
#         LET g_action_choice="maint_mat_wtdw"
#         EXIT DISPLAY
#&ifdef ICD
##@  ON ACTION 單據刻號BIN查詢作業
#    ON ACTION aic_s_icdqry
#       LET g_action_choice = "aic_s_icdqry"
#       EXIT DISPLAY
#
##@  ON ACTION 刻號/BIN號入庫明細
#    ON ACTION aic_s_icdin
#       LET g_action_choice = "aic_s_icdin"
#       EXIT DISPLAY
#&endif
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
#      ON ACTION exporttoexcel
#         LET g_action_choice = 'exporttoexcel'
#         EXIT DISPLAY
#
#      ON ACTION related_document                #No:FUN-6A0166  相關文件
#         LET g_action_choice="related_document"          
#         EXIT DISPLAY
#
#      ON ACTION qry_lot
#         LET g_action_choice="qry_lot"
#         EXIT DISPLAY
#      #FUN-A80128---add----str---
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
#      #FUN-A80128---add----end---
#
#      AFTER DISPLAY
#         CONTINUE DISPLAY
#
#      &include "qry_string.4gl"
#
#   END DISPLAY
#FUN-B30170 mark -end---------------------------
   CALL cl_set_act_visible("accept,cancel", TRUE)

END FUNCTION


FUNCTION t620_out()
     CASE WHEN g_argv = '0'  #作業移轉
            #LET l_program = 'asfr620' #FUN-C30085 mark
             LET l_program = 'asfg620' #FUN-C30085 add
          WHEN g_argv = '1'  #完工入庫
            #LET l_program = 'asfr621' #FUN-C30085 mark
             LET l_program = 'asfg621' #FUN-C30085 add
          WHEN g_argv = '2'  #入庫退回
            #LET l_program = 'asfr622' #FUN-C30085 mark
             LET l_program = 'asfg622' #FUN-C30085 add
          WHEN g_argv = '3'  #重複性生產入庫 #FUN-5C0114
            LET l_program = 'asrr320'  #FUN-630001
     END CASE
     LET g_wc = 'sfu01 = "',g_sfu.sfu01,'"'
     LET g_cmd = l_program,
                 " '",g_today,"'",
                 " '",g_user,"'",  #TQC-630013
                 " '",g_lang,"'",
                 " 'Y'",
                 " ' '",
                 " '1'",
                 " '",g_wc CLIPPED,"'"
     display g_cmd
     CALL cl_cmdrun_wait(g_cmd CLIPPED) #MOD-490247
END FUNCTION

#作廢、取消作廢
#FUNCTION t620_x()                             #CHI-D20010
FUNCTION t620_x(p_type)                        #CHI-D20010               
   DEFINE l_srg11   LIKE srg_file.srg11    #CHI-A40006 add
   DEFINE l_n       LIKE type_file.num10   #CHI-A40006 add
   DEFINE l_i       LIKE type_file.num10   #CHI-A40006 add
   DEFINE l_sfv14   LIKE sfv_file.sfv14    #CHI-A40006 add
   DEFINE l_sfv17   LIKE sfv_file.sfv17    #CHI-A40006 add
   DEFINE l_sfv20   LIKE sfv_file.sfv20    #CHI-A40006 add
   DEFINE l_sfv47   LIKE sfv_file.sfv47    #FUN-BC0104
   DEFINE l_sfv46   LIKE sfv_file.sfv46    #FUN-BC0104
   DEFINE l_sfv09   LIKE sfv_file.sfv09    #FUN-BC0104 
   DEFINE p_type    LIKE type_file.chr1  #CHI-D20010
   DEFINE l_flag    LIKE type_file.chr1  #CHI-D20010

   IF s_shut(0) THEN RETURN END IF

   SELECT * INTO g_sfu.* FROM sfu_file WHERE sfu01 = g_sfu.sfu01       #MOD-660086 add
   IF cl_null(g_sfu.sfu01) THEN CALL cl_err('',-400,0) RETURN END IF   #MOD-660086 add
   #FUN-A80128  add str ---              
   IF g_sfu.sfu15 matches '[Ss]' THEN
        CALL cl_err('','apm-030',0) #送簽中, 不可修改資料!
        RETURN
   END IF
   IF g_sfu.sfuconf='Y' AND g_sfu.sfu15 = "1" AND g_sfu.sfumksg = "Y"  THEN
      CALL cl_err('','mfg3168',0) #此張單據已核准, 不允許更改或取消
      RETURN
   END IF
   #FUN-A80128  add end ---    
   #CHI-D20010---begin
   IF p_type = 1 THEN
      IF g_sfu.sfuconf='X' THEN RETURN END IF
   ELSE
      IF g_sfu.sfuconf<>'X' THEN RETURN END IF
   END IF
   #CHI-D20010---end

   LET g_success='Y'

   BEGIN WORK

   OPEN t620_cl USING g_sfu.sfu01     #No.TQC-9A0120 mod
   IF STATUS THEN
      CALL cl_err("OPEN t620_cl:", STATUS, 1)
      CLOSE t620_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t620_cl INTO g_sfu.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_sfu.sfu01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t620_cl ROLLBACK WORK RETURN
   END IF
   IF cl_null(g_sfu.sfu01) THEN CALL cl_err('',-400,0) RETURN END IF
   #-->確認不可作廢
   IF g_sfu.sfupost = 'Y' THEN CALL cl_err('','asf-812',0) RETURN END IF #FUN-660137
   IF g_sfu.sfuconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF #FUN-660137
   #CHI-D40003---begin
   IF g_sfu.sfuconf='X' AND NOT cl_null(g_sma.sma53) AND g_sfu.sfu02 <= g_sma.sma53 THEN
      CALL cl_err('','alm1393',0)
      RETURN
   END IF
   #CHI-D40003---end
   #IF cl_void(0,0,g_sfu.sfuconf)   THEN #FUN-660137                   #CHI-D20010
   IF p_type = 1 THEN LET l_flag = 'N' ELSE LET l_flag = 'X' END IF    #CHI-D20010
   IF cl_void(0,0,l_flag) THEN                                         #CHI-D20010
      LET g_chr=g_sfu.sfuconf #FUN-660137
     #str CHI-A40006 add
      IF g_sfu.sfuconf ='N' THEN   #入庫單作廢,需將報工單身的入庫單號清掉   
         LET l_srg11=NULL
      ELSE                         #入庫單取消作廢,需回寫報工單身的入庫單號
         LET l_srg11=g_sfu.sfu01
      END IF
      IF g_argv='3' THEN
         FOR l_i=1 TO g_sfv.getlength()
           #str MOD-A50082 add
           #當入庫單有報工時才需回寫報工單身的入庫單號
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM srg_file
             WHERE srg01=g_sfv[l_i].sfv17
               AND srg02=g_sfv[l_i].sfv14
            IF l_n>0 THEN
           #end MOD-A50082 add
               LET l_n = 0
              #str MOD-A50082 mod
               IF g_sfu.sfuconf ='N' THEN   #入庫單作廢,需將報工單身的入庫單號清掉 
                  SELECT COUNT(*) INTO l_n FROM srg_file
                   WHERE srg01=g_sfv[l_i].sfv17
                     AND srg02=g_sfv[l_i].sfv14
                     AND srg11=g_sfu.sfu01
               ELSE
                  SELECT COUNT(*) INTO l_n FROM srg_file
                   WHERE srg01=g_sfv[l_i].sfv17
                     AND srg02=g_sfv[l_i].sfv14
                     AND srg11 IS NULL
               END IF
              #end MOD-A50082 mod
              #IF l_n>0 OR g_sfu.sfuconf ='N' THEN   #MOD-A50082 mark
               IF l_n>0 THEN                         #MOD-A50082
                  UPDATE srg_file SET srg11=l_srg11
                                WHERE srg01=g_sfv[l_i].sfv17
                                  AND srg02=g_sfv[l_i].sfv14
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                     CALL cl_err('upd srg11','9050',1)
                     ROLLBACK WORK 
                     RETURN
                  END IF
               ELSE
                  CALL cl_err(g_sfu.sfu01,'asf-620',1)
                  ROLLBACK WORK 
                  RETURN
               END IF                        
            END IF     #MOD-A50082 add
         END FOR      
      END IF
      IF g_argv='1' THEN
         DECLARE t620_sfv_c CURSOR FOR
            SELECT sfv20,sfv14 FROM sfv_file WHERE sfv01=g_sfu.sfu01
         FOREACH t620_sfv_c INTO l_sfv20,l_sfv14   
           #str MOD-A50082 add
           #當入庫單有報工時才需回寫報工單身的入庫單號
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM srg_file
             WHERE srg01=l_sfv20
               AND srg02=l_sfv14
            IF l_n>0 THEN
           #end MOD-A50082 add
               LET l_n = 0
              #str MOD-A50082 mod
               IF g_sfu.sfuconf ='N' THEN   #入庫單作廢,需將報工單身的入庫單號清掉 
                  SELECT COUNT(*) INTO l_n FROM srg_file
                   WHERE srg01=l_sfv20
                     AND srg02=l_sfv14
                     AND srg11=g_sfu.sfu01
               ELSE
                  SELECT COUNT(*) INTO l_n FROM srg_file
                   WHERE srg01=l_sfv20
                     AND srg02=l_sfv14
                     AND srg11 IS NULL
               END IF
              #end MOD-A50082 mod
              #IF l_n>0 OR g_sfu.sfuconf ='N' THEN   #MOD-A50082 mark
               IF l_n>0 THEN                         #MOD-A50082
                  UPDATE srg_file SET srg11=l_srg11
                                WHERE srg01=l_sfv20
                                  AND srg02=l_sfv14
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                     CALL cl_err('upd srg11','9050',1)
                     ROLLBACK WORK 
                     RETURN
                  END IF
               ELSE
                  CALL cl_err(g_sfu.sfu01,'asf-620',1)
                  ROLLBACK WORK 
                  RETURN
               END IF                        
            END IF     #MOD-A50082 add
         END FOREACH
      END IF
     #end CHI-A40006 add

     #IF g_sfu.sfuconf ='N' THEN #FUN-660137              #CHI-D20010
      IF p_type = 1 THEN                                  #CHI-D20010
          LET g_sfu.sfuconf='X' #FUN-660137
          LET g_sfu.sfu15  ='9' #FUN-A80128 add
      ELSE
          LET g_sfu.sfuconf='N' #FUN-660137
          LET g_sfu.sfu15  ='0' #FUN-A80128 add
      END IF
      UPDATE sfu_file
         SET sfuconf=g_sfu.sfuconf, #FUN-660137
             sfumodu=g_user,
             sfudate=g_today,
             sfu15  =g_sfu.sfu15    #FUN-A80128 add
       WHERE sfu01  =g_sfu.sfu01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err(g_sfu.sfuconf,SQLCA.sqlcode,0) #FUN-660137
          LET g_sfu.sfuconf=g_chr #FUN-660137
      #FUN-C40016----------mark----------str----------
      ##FUN-BC0104---add---str---
      #ELSE 
      #   DECLARE sfv03_cur1 CURSOR FOR SELECT sfv09,sfv17,sfv46,sfv47 
      #                               FROM sfv_file
      #                               WHERE sfv01 = g_sfu.sfu01
      #   FOREACH sfv03_cur1 INTO l_sfv09,l_sfv17,l_sfv46,l_sfv47       
      #      IF NOT cl_null(l_sfv46) THEN      
      #         UPDATE qco_file SET qco20 = qco20-l_sfv09 WHERE qco01 = l_sfv17
      #                                                     AND qco02 = 0 
      #                                                     AND qco04 = l_sfv47 
      #                                                     AND qco05 = 0 
      #         IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      #            CALL cl_err3("upd","qco_file",g_sfu.sfu01,"",STATUS,"","upd qco20:",1)
      #            ROLLBACK WORK
      #            RETURN 
      #         END IF
      #      END IF
      #   END FOREACH
      #   UPDATE sfv_file SET sfv46 = '',sfv47 = ''
      #       WHERE sfv01 = g_sfu.sfu01
      #   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      #      CALL cl_err3("upd","sfu_file",g_sfu.sfu01,"",STATUS,"","upd sfv46,sfv47:",1)
      #      ROLLBACK WORK
      #      RETURN
      #   END IF
      ##FUN-BC0104---add---end---
      #FUN-C40016-----------mark----------end----------
      #FUN-C40016----add----str----
      ELSE
         DECLARE sfv03_cur1 CURSOR FOR SELECT sfv17,sfv47
                                         FROM sfv_file
                                        WHERE sfv01 = g_sfu.sfu01
         FOREACH sfv03_cur1 INTO l_sfv17,l_sfv47
            IF NOT s_iqctype_upd_qco20(l_sfv17,0,0,l_sfv47,'2') THEN
               ROLLBACK WORK
               RETURN
            END IF
         END FOREACH
       #FUN-C40016----add----end----
      END IF
      DISPLAY BY NAME g_sfu.sfuconf #FUN-660137
      DISPLAY BY NAME g_sfu.sfu15   #FUN-A80128 add
   END IF

   CLOSE t620_cl
   COMMIT WORK
   CALL cl_flow_notify(g_sfu.sfu01,'V')

END FUNCTION


FUNCTION t620_k()
DEFINE li_result   LIKE type_file.num5        #No.FUN-540055        #No.FUN-680121 SMALLINT
  DEFINE l_sfv    RECORD LIKE sfv_file.*,
         l_sfa    RECORD LIKE sfa_file.*,
         l_sfs    RECORD LIKE sfs_file.*,
         l_qpa    LIKE sfa_file.sfa161,        #No:MOD-640013 add
         l_qty    LIKE sfs_file.sfs05,         #No:MOD-640013 add
         g_sfu09  LIKE sfu_file.sfu09,
         g_t1     LIKE oay_file.oayslip, #No.FUN-540055        #No.FUN-680121 CHAR(5)
         l_flag   LIKE type_file.chr1,          #No.FUN-680121 CHAR(1)
         l_name   LIKE type_file.chr20,         #No:FUN-680121 CHAR(12)
         l_sfp    RECORD
               sfp01   LIKE sfp_file.sfp01,
               sfp02   LIKE sfp_file.sfp02,
               sfp03   LIKE sfp_file.sfp03,
               sfp04   LIKE sfp_file.sfp04,
               sfp05   LIKE sfp_file.sfp05,
               sfp06   LIKE sfp_file.sfp06,
               sfp07   LIKE sfp_file.sfp07
                  END RECORD,
         l_sfb82  LIKE sfb_file.sfb82,
         l_bdate  LIKE type_file.dat,           #No:FUN-680121 DATE#bugno:6287 add
         l_edate  LIKE type_file.dat,           #No:FUN-680121 DATE#bugno:6287 add
         l_day    LIKE type_file.num5,          #No:FUN-680121 SMALLINT #bugno:6287 add
         l_cnt    LIKE type_file.num5           #No.FUN-680121 SMALLINT
    DEFINE l_sfv11 LIKE sfv_file.sfv11
    DEFINE l_msg  LIKE type_file.chr1000        #No:FUN-680121 CHAR(300)
    DEFINE l_sfb04  LIKE sfb_file.sfb04
    DEFINE l_sfb81  LIKE sfb_file.sfb81
    DEFINE l_sfb02  LIKE sfb_file.sfb02
    DEFINE l_sfp02  LIKE sfp_file.sfp02
    DEFINE l_smy73  LIKE smy_file.smy73   #TQC-AC0293

   DROP TABLE tmp
   CREATE TEMP TABLE tmp(
    a         LIKE type_file.chr20,  #FUN-A70138
    b         LIKE type_file.chr1000,
    c         LIKE type_file.num15_3);

    IF g_sfu.sfu01 IS NULL THEN RETURN END IF
    SELECT * INTO g_sfu.* FROM sfu_file
     WHERE sfu01 = g_sfu.sfu01
    IF g_sfu.sfuconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF #FUN-660137
    IF g_sfu.sfupost = 'N' THEN  #未過帳
       CALL cl_err(g_sfu.sfu09,'asf-666',0)
       RETURN
    END IF
    IF g_sfu.sfu09 IS NOT NULL THEN  #已產生領料單
       CALL cl_err(g_sfu.sfu09,'asf-826',0)
       RETURN
    END IF

#...check單身工單是否有使用消秏性料件 -> 沒有則不可產生領料單
    SELECT COUNT(*) INTO l_cnt FROM sfv_file,sfa_file
     WHERE sfv01 = g_sfu.sfu01
       AND sfv11 = sfa01 AND sfa11 = 'E'
    IF l_cnt = 0 THEN CALL cl_err('sel sfa','asf-735',0) RETURN  END IF

    BEGIN WORK      #No:7829

    LET l_flag =' '
    LET g_success = 'Y'
    INPUT g_sfu09 WITHOUT DEFAULTS FROM sfu09
       AFTER FIELD sfu09
         IF NOT cl_null(g_sfu09) THEN
           CALL s_check_no("asf",g_sfu09,"","3","sfu_file","sfu09","") #MOD-580251
           RETURNING li_result,g_sfu.sfu09
          DISPLAY BY NAME g_sfu.sfu09
          IF (NOT li_result) THEN
            NEXT FIELD sfu09
          END IF
         #TQC-AC0293 ---------------add start----------
          LET g_t1 = s_get_doc_no(g_sfu09)
          SELECT smy73 INTO l_smy73 FROM smy_file
           WHERE smyslip = g_t1
          IF l_smy73 = 'Y' THEN
             CALL cl_err('','asf-872',0)
             NEXT FIELD sfu09
          END IF
         #TQC-AC0293 ---------------add end-------------
          DISPLAY BY NAME g_sfu.sfu09
          LET g_sfu09=g_sfu.sfu09
          CALL t620_g_b1()  #CHI-A40030 add
         END IF

       ON ACTION controlp
          CASE WHEN INFIELD(sfu09)
            LET g_t1 = s_get_doc_no(g_sfu.sfu09)       #No.FUN-540055
                    #LET g_sql = " (smy73 <> 'Y' OR smy73 is null)"  #TQC-AC0293    #TQC-BC0155 
                    LET g_sql = " (smy73 <> 'Y' OR smy73 is null) AND smy72='4' "  #TQC-BC0155
                    CALL smy_qry_set_par_where(g_sql)               #TQC-AC0293
                    CALL q_smy( FALSE, TRUE,g_t1,'ASF','3') RETURNING g_t1  #TQC-670008
                    LET g_sfu09=g_t1 #MOD-5A0044
                    DISPLAY BY NAME g_sfu09
                    NEXT FIELD sfu09
               OTHERWISE EXIT CASE
          END CASE
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
    END INPUT

    IF cl_null(g_sfu09) THEN   #未輸入任何data
       ROLLBACK WORK
       RETURN
    END IF
    IF g_success = 'N' THEN
       ROLLBACK WORK
       RETURN
    END IF
    IF NOT cl_sure(0,0) THEN
       ROLLBACK WORK
       RETURN
    END IF
##
  #TQC-C90071--add--start
    IF NOT cl_null(g_sfu.sfu09) THEN  #已產生領料單
       CALL cl_err('','asf-826',0)
    END IF
  #TQC-C90071-add--end
    #新增一筆資料
    IF g_sfu09 IS NOT NULL AND g_sfu.sfupost = 'Y' THEN
   #CALL s_auto_assign_no("asf",g_sfu.sfu09,g_sfu.sfu02,"","sfp_file","sfp01","","","") #MOD-A40051 mark
   #CALL s_auto_assign_no("asf",g_sfu.sfu09,g_sfu.sfu14,"","sfp_file","sfp01","","","") #MOD-A40051 #MOD-D10117 mark
    CALL s_auto_assign_no("asf",g_sfu09,g_sfu.sfu14,"","sfp_file","sfp01","","","")     #MOD-D10117 g_sfu.sfu09 -> g_sfu09
         RETURNING li_result,g_sfu.sfu09
    IF (NOT li_result) THEN
       ROLLBACK WORK
       RETURN
    END IF
    DISPLAY BY NAME g_sfu.sfu09
    LET g_sfu09=g_sfu.sfu09
      #----先檢查領料單身資料是否已經存在------------
       DECLARE count_cur CURSOR FOR
           SELECT COUNT(*) FROM sfs_file
       WHERE sfs01 = g_sfu09
       OPEN count_cur
       FETCH count_cur INTO g_cnt
       IF g_cnt > 0  THEN  #已存在
          LET l_flag ='Y'
       ELSE
          LET l_flag ='N'
       END IF
       #-----------產生領料資料------------------------

       DECLARE t620_sfv_cur CURSOR  WITH HOLD FOR
          SELECT *  FROM  sfv_file
           WHERE sfv01 = g_sfu.sfu01
       LET l_cnt = 0
       CALL cl_outnam('asft620') RETURNING l_name
       START REPORT t620_rep TO l_name

       LET g_success = 'Y'
       FOREACH t620_sfv_cur INTO l_sfv.*
         IF STATUS THEN
            CALL cl_err('foreach s:',STATUS,0)
            LET g_success = 'N'    #No:7829
            EXIT FOREACH
         END IF
         SELECT sfb04,sfb81,sfb02          #MOD-890168 mark ,sfp02
           INTO l_sfb04,l_sfb81,l_sfb02    #MOD-890168 mark ,l_sfp02 
           FROM sfb_file                   #MOD-8A0031 mark ,sfp_file
          WHERE sfb01 = l_sfv.sfv11


         IF STATUS THEN
            CALL cl_err3("sel","sfb_file",l_sfv.sfv11,"",STATUS,"","sel sfb",1) 
            CONTINUE FOREACH
         END IF

         IF l_sfb04='1' THEN
            CALL cl_err('sfb04=1','asf-381',0) CONTINUE FOREACH
         END IF

         IF l_sfb04='8' THEN
            CALL cl_err('sfb04=8','asf-345',0) CONTINUE FOREACH
         END IF
        

         IF l_sfb02=13 THEN  
            CALL cl_err('sfb02=13','asf-346',0) CONTINUE FOREACH
         END IF
         DECLARE t620_sfs_cur CURSOR WITH HOLD FOR
         SELECT sfa_file.*,sfb82 FROM sfb_file,sfa_file
          WHERE sfb01 = l_sfv.sfv11   #工單單號
            AND sfb01 = sfa01
            AND sfa11 = 'E'
            AND sfa05<>0         #MOD-C10064 add
            ORDER BY sfa26       #No:MOD-640013 add

        FOREACH t620_sfs_cur INTO l_sfa.*,l_sfb82
            INITIALIZE l_sfs.* TO NULL
            INITIALIZE l_sfp.* TO NULL

         #-------發料單頭--------------
          LET l_sfp.sfp01 = g_sfu09
#領料單月份已與完工入庫單月份不同時,以完工入庫日期該月的最後一天為領料日
          LET l_sfp.sfp02 = g_today
          LET l_sfp.sfp03 = g_today      #No:MOD-950184 add    
          IF MONTH(g_today) != MONTH(g_sfu.sfu02) THEN
             IF MONTH(g_sfu.sfu02) = 12 THEN
                LET l_bdate = MDY(MONTH(g_sfu.sfu02),1,YEAR(g_sfu.sfu02))
                LET l_edate = MDY(1,1,YEAR(g_sfu.sfu02)+1)
             ELSE
                LET l_bdate = MDY(MONTH(g_sfu.sfu02),1,YEAR(g_sfu.sfu02))
                LET l_edate = MDY(MONTH(g_sfu.sfu02)+1,1,YEAR(g_sfu.sfu02))
             END IF
             LET l_day = l_edate - l_bdate   #計算最後一天日期
             LET l_sfp.sfp03 = MDY(MONTH(g_sfu.sfu02),l_day,YEAR(g_sfu.sfu02))   #No:MOD-950184 add    
          END IF
          LET l_sfp.sfp04 = 'N'
          LET l_sfp.sfp05 = 'N'
          LET l_sfp.sfp06 ='4'
          LET l_sfp.sfp07 = l_sfb82
          OUTPUT TO REPORT t620_rep(l_sfp.*,l_flag)
          SELECT MAX(sfs02) INTO l_cnt FROM sfs_file
           WHERE sfs01 = g_sfu09
          IF l_cnt IS NULL THEN    #項次
             LET l_cnt = 1
          ELSE  LET l_cnt = l_cnt + 1
          END IF
         #-------發料單身--------------
          LET l_sfs.sfs01 = g_sfu09
          LET l_sfs.sfs02 = l_cnt
          LET l_sfs.sfs03 = l_sfa.sfa01
          LET l_sfs.sfs04 = l_sfa.sfa03
          LET l_sfs.sfs05 = l_sfv.sfv09*l_sfa.sfa161 #已發料量
          LET l_sfs.sfs06 = l_sfa.sfa12  #發料單位
          LET l_sfs.sfs05 = s_digqty(l_sfs.sfs05,l_sfs.sfs06)   #FUN-BB0084
          #CHI-A40030 mod --start--
          #LET l_sfs.sfs07 = l_sfa.sfa30  #倉庫
          #LET l_sfs.sfs08 = l_sfa.sfa31  #儲位
          CASE g_rg1
             WHEN '1'
              SELECT ima35,ima36 INTO g_ima35,g_ima36
                 FROM ima_file
                WHERE ima01= l_sfa.sfa03
              ##Add No.FUN-AA0055  #Mark No.FUN-AB0054 此处不做判断，交予单据审核时控管
              #IF NOT s_chk_ware(g_ima35) THEN  #检查仓库是否属于当前门店
              #   LET g_success = 'N'
              #END IF
              ##End Add No.FUN-AA0055
               LET l_sfs.sfs07 = g_ima35  #倉庫
               LET l_sfs.sfs08 = g_ima36  #儲位
             WHEN '2'
               LET l_sfs.sfs07 = l_sfa.sfa30  #倉庫
               LET l_sfs.sfs08 = l_sfa.sfa31  #儲位
             WHEN '3'
               LET l_sfs.sfs07 = g_ima35  #倉庫
               LET l_sfs.sfs08 = g_ima36  #儲位
          END CASE
          #CHI-A40030 mod --end--
          LET l_sfs.sfs09 = ' '          #批號
          LET l_sfs.sfs10 = l_sfa.sfa08  #作業序號
          LET l_sfs.sfs26 = NULL         #替代碼
          LET l_sfs.sfs27 = NULL         #被替代料號
         #LET l_sfs.sfs28 = NULL         #替代率      #MOD-C60203 mark
          LET l_sfs.sfs28 = 1            #替代率      #MOD-C60203 add
          LET l_sfs.sfs930 = l_sfv.sfv930 #FUN-670103
          IF l_sfa.sfa26 MATCHES '[SUTZ]' THEN    #bugno:7111 add 'T'  #FUN-A20037 add 'Z'
             LET l_sfs.sfs26 = l_sfa.sfa26
             LET l_sfs.sfs27 = l_sfa.sfa27
             LET l_sfs.sfs28 = l_sfa.sfa28
             SELECT (sfa161 * sfa28) INTO l_qpa FROM sfa_file
                WHERE sfa01 = l_sfa.sfa01 AND sfa03 = l_sfa.sfa27
                  AND sfa012 = l_sfa.sfa012 AND sfa013 = l_sfa.sfa013        #FUN-A60076 
             LET l_sfs.sfs05 = l_sfv.sfv09*l_qpa
             LET l_sfs.sfs05 = s_digqty(l_sfs.sfs05,l_sfs.sfs06)             #FUN-BB0084 
             SELECT SUM(c) INTO l_qty FROM tmp WHERE a = l_sfa.sfa01
                AND b = l_sfa.sfa27
             IF  cl_null(l_qty) THEN LET l_qty=0 END IF       #MOD-C10064 add
             IF l_sfs.sfs05 < l_qty THEN
                LET l_sfs.sfs05 = 0
             ELSE
                LET l_sfs.sfs05 = l_sfs.sfs05 - l_qty
                LET l_sfs.sfs05 = s_digqty(l_sfs.sfs05,l_sfs.sfs06)          #FUN-BB0084
             END IF
          ELSE                               #No:MOD-8B0086 add
             LET l_sfs.sfs27 = l_sfa.sfa27   #No:MOD-8B0086 add
          END IF
         #CALL t620_chk_ima64(l_sfs.sfs04, l_sfs.sfs05) RETURNING l_sfs.sfs05  #MOD-850193 add   #MOD-C80187 mark
          LET l_sfs.sfs05 = s_digqty(l_sfs.sfs05,l_sfs.sfs06)    #FUN-BB0084
       ##判斷發料是否大於可發料數(sfa05-sfa06)
       ##TQC-B80264  --begin   #MOD-C10064 str mark
       # # IF l_sfs.sfs05 > (l_sfa.sfa05 - l_sfa.sfa06) THEN
       # #    LET l_sfs.sfs05 = l_sfa.sfa05 - l_sfa.sfa06
       # # END IF
       # IF l_sfs.sfs05 > (l_sfa.sfa05 - l_sfa.sfa06) THEN
       #    CALL cl_err('sfs05','asf-774',1)  
       #     LET g_success = 'N'     
       #     LET g_sfu.sfu09 = NULL   
       #     DISPLAY BY NAME g_sfu.sfu09    
       #     RETURN
       # END IF 
       ##TQC-B80264  --end     #MOD-C10064 end mark
          IF cl_null(l_sfs.sfs07) AND cl_null(l_sfs.sfs08) THEN
             SELECT ima35,ima36 INTO  l_sfs.sfs07,l_sfs.sfs08
               FROM ima_file
              WHERE ima01 = l_sfs.sfs04
            ##Add No.FUN-AA0055  #Mark No.FUN-AB0054 此处不做判断，交予单据审核时控管
            #IF NOT s_chk_ware(l_sfs.sfs07) THEN  #检查仓库是否属于当前门店
            #   LET g_success = 'N'
            #END IF
            ##End Add No.FUN-AA0055
          END IF
          IF l_sfs.sfs07 IS NULL THEN LET l_sfs.sfs07 = ' ' END IF
          IF l_sfs.sfs08 IS NULL THEN LET l_sfs.sfs08 = ' ' END IF
          IF l_sfs.sfs09 IS NULL THEN LET l_sfs.sfs09 = ' ' END IF
          INSERT INTO tmp
            VALUES(l_sfa.sfa01,l_sfa.sfa27,l_sfs.sfs05)
          IF g_sma.sma115 = 'Y' THEN
             SELECT ima25,ima55,ima906,ima907
               INTO g_ima25,g_ima55,g_ima906,g_ima907
               FROM ima_file
              WHERE ima01=l_sfs.sfs04
             IF SQLCA.sqlcode THEN
                CALL cl_err('sel ima',SQLCA.sqlcode,1)
                LET g_success = 'N'
             END IF
             IF cl_null(g_ima55) THEN LET g_ima55 = g_ima25 END IF
             LET l_sfs.sfs30=l_sfs.sfs06
             LET g_factor = 1
             CALL s_umfchk(l_sfs.sfs04,l_sfs.sfs30,g_ima55)
               RETURNING g_cnt,g_factor
             IF g_cnt = 1 THEN
                LET g_factor = 1
             END IF
             LET l_sfs.sfs31=g_factor
             LET l_sfs.sfs32=l_sfs.sfs05
             LET l_sfs.sfs33=g_ima907
             LET g_factor = 1
             CALL s_umfchk(l_sfs.sfs04,l_sfs.sfs33,g_ima55)
               RETURNING g_cnt,g_factor
             IF g_cnt = 1 THEN
                LET g_factor = 1
             END IF
             LET l_sfs.sfs34=g_factor
             LET l_sfs.sfs35=0
             IF g_ima906 = '3' THEN
                LET g_factor = 1
                CALL s_umfchk(l_sfs.sfs04,l_sfs.sfs30,l_sfs.sfs33)
                  RETURNING g_cnt,g_factor
                IF g_cnt = 1 THEN
                   LET g_factor = 1
                END IF
                LET l_sfs.sfs35=l_sfs.sfs32*g_factor
                LET l_sfs.sfs35=s_digqty(l_sfs.sfs35,l_sfs.sfs33)    #FUN-BB0084
             END IF
             IF g_ima906='1' THEN
                LET l_sfs.sfs33=NULL
                LET l_sfs.sfs34=NULL
                LET l_sfs.sfs35=NULL
             END IF
          END IF

         OPEN t620_cl USING g_sfu.sfu01    #No.TQC-9A0120 mod
         IF STATUS THEN
            CALL cl_err("OPEN t620_cl:", STATUS, 1)
            CLOSE t620_cl
            ROLLBACK WORK
            RETURN
         END IF
         FETCH t620_cl INTO g_sfu.*          # 鎖住將被更改或取消的資料
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_sfu.sfu01,SQLCA.sqlcode,0)     # 資料被他人LOCK
            CLOSE t620_cl ROLLBACK WORK RETURN
         END IF

         IF l_flag ='N' THEN

            #LET l_sfv.sfvplant = g_plant #FUN-980008 add  #TQC-AB0097 mark
            #LET l_sfv.sfvlegal = g_legal #FUN-980008 add  #TQC-AB0097 mark
            LET l_sfs.sfsplant = g_plant #TQC-AB0097
            LET l_sfs.sfslegal = g_legal #TQC-AB0097
#FUN-A70125 --begin--
            IF cl_null(l_sfs.sfs012) THEN
               LET l_sfs.sfs012 = ' ' 
            END IF 
            IF cl_null(l_sfs.sfs013) THEN
               LET l_sfs.sfs013 = 0 
            END IF            
#FUN-A70125 --end--
#TQC-C90055--remark--add--start--
#FUN-C70014 add begin-----------------
            IF cl_null(l_sfs.sfs014) THEN
               LET l_sfs.sfs014 = ' '  
            END IF
#FUN-C70014 add end ------------------
#TQC-C90055--remark--add--end--
            #FUN-CB0087---add---str---
            IF g_aza.aza115 = 'Y' THEN
               CALL s_reason_code(l_sfs.sfs01,l_sfs.sfs03,'',l_sfs.sfs04,l_sfs.sfs07,g_user,l_sfp.sfp07) RETURNING l_sfs.sfs37
               IF cl_null(l_sfs.sfs37) THEN
                  CALL cl_err('','aim-425',1)
                  LET g_success = 'N'
               END IF
            END IF
            #FUN-CB0087---add---end--
            INSERT INTO sfs_file VALUES (l_sfs.*)
            IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
              CALL cl_err('ins sfs',STATUS,0)
              LET g_success = 'N'
            END IF
         ELSE
            UPDATE sfs_file SET * = l_sfs.* WHERE sfs01 = l_sfs.sfs01
            IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
               CALL cl_err('ins sfs',STATUS,0)
               LET g_success = 'N'
            END IF
         END IF
       END FOREACH
     END FOREACH
     FINISH REPORT t620_rep
     #MOD-C80170 str add-----
     LET l_cnt = 0                                                 
     SELECT COUNT(*) INTO l_cnt FROM sfp_file WHERE sfp01 = g_sfu09 
     IF l_cnt = 0 THEN 
        LET g_sfu.sfu09 = NULL 
        DISPLAY BY NAME g_sfu.sfu09
     END IF
    #MOD-C80170 end add-----
     IF g_sfu09 IS NOT NULL THEN
        LET g_sfu.sfu09 = g_sfu09
        UPDATE sfu_file SET sfu09 = g_sfu.sfu09
         WHERE sfu01 = g_sfu.sfu01
        IF STATUS THEN
           CALL cl_err('upd sfu',STATUS,1)
           LET g_success = 'N'
        END IF
        DISPLAY BY NAME g_sfu.sfu09
     END IF
    END IF
    IF g_success = 'Y' THEN
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF

END FUNCTION

REPORT t620_rep(sr,p_flag)
  DEFINE p_flag  LIKE type_file.chr1,          #No.FUN-680121 CHAR(1)
        sr  RECORD
            sfp01 LIKE sfp_file.sfp01,
            sfp02 LIKE sfp_file.sfp02,
            sfp03 LIKE sfp_file.sfp03,
            sfp04 LIKE sfp_file.sfp04,
            sfp05 LIKE sfp_file.sfp05,
            sfp06 LIKE sfp_file.sfp06,
            sfp07 LIKE sfp_file.sfp07
             END RECORD

 #ORDER BY sr.sfp01 #MOD-BB0061
  ORDER EXTERNAL BY sr.sfp01 #MOD-BB0061
  FORMAT
    AFTER GROUP OF sr.sfp01
      IF p_flag ='Y' THEN
            UPDATE sfp_file SET sfp02= sr.sfp02,  #sfp03 = sr.sfp03,
                                sfp04= sr.sfp04,sfp05 = sr.sfp05,
                                 sfp06= sr.sfp06,sfp07 = sr.sfp07,  #MOD-470503
                                 sfpgrup=g_grup,                    #No:MOD-770140 add
                                 sfpmodu=g_user,sfpdate=g_today #MOD-470503 add
               WHERE sfp01 = sr.sfp01
            IF SQLCA.sqlcode THEN LET g_success='N' END IF
      ELSE
           INSERT INTO sfp_file(sfp01,sfp02,sfp03,sfp04,sfp05,sfp06,sfp07,sfp09, #MOD-5A0044 add sfp09
                                sfpuser,sfpdate,sfpconf,sfpgrup, #FUN-660106     #No:MOD-770140 add sfpgrup
                                sfpmksg,sfp15,sfp16,                             #FUN-AB0001 add
                                sfpplant,sfplegal)                               #FUN-980008 add
                         VALUES(sr.sfp01,sr.sfp02,sr.sfp03,sr.sfp04,
                                sr.sfp05,sr.sfp06,sr.sfp07,'N',        #MOD-5A0044 add 'N'
                                g_user,g_today,'N',g_grup,             #FUN-660106       #No:MOD-770140 add g_grup
                                g_smy.smyapr,'0',g_user,               #FUN-AB0001 add
                                g_plant,g_legal)                       #FUN-980008 add
            IF SQLCA.sqlcode THEN LET g_success='N' END IF
      END IF
 
END REPORT

FUNCTION t620_sfv04_2(p_cmd)    #聯產品料件號編號 NO:6872
  DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680121 CHAR(1)
         l_ima02     LIKE ima_file.ima02,
         l_ima021    LIKE ima_file.ima021,
         l_bmm04     LIKE bmm_file.bmm04,
         l_bmm05     LIKE bmm_file.bmm05

  LET g_errno = ' '
       #單位,生效否
  SELECT bmm04,bmm05,ima02,ima021
    INTO l_bmm04,l_bmm05,l_ima02,l_ima021
    FROM bmm_file LEFT OUTER JOIN ima_file ON bmm03 = ima01   #NO.TQC-9A0120 mod
   WHERE bmm01 = g_ima.ima01       #主件料件編號
     AND bmm03 = g_sfv[l_ac].sfv04 #聯產品料件號編號
  CASE WHEN SQLCA.SQLCODE = 100
            IF g_ima.ima01 = g_sfv[l_ac].sfv04 THEN #可建成品料號
                SELECT ima55,ima02,ima021 INTO
                      l_bmm04,l_ima02,l_ima021
                  FROM ima_file
                 WHERE ima01=g_sfv[l_ac].sfv04
                IF SQLCA.sqlcode = 100 THEN
                    LET g_errno = 'abm-610' #無此聯產品料號!
                    LET l_bmm04 = NULL
                    LET l_bmm05 = NULL
                    LET l_ima02 = NULL
                    LET l_ima021= NULL
                END IF
            ELSE
                LET g_errno = 'abm-610' #無此聯產品料號!
                LET l_bmm04 = NULL
                LET l_bmm05 = NULL
                LET l_ima02 = NULL
                LET l_ima021= NULL
            END IF
       WHEN l_bmm05='N' LET g_errno = '9028'
       OTHERWISE        LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  LET g_sfv[l_ac].sfv08 = l_bmm04 #聯產品單位
  LET g_sfv[l_ac].sfv09=s_digqty(g_sfv[l_ac].sfv09,g_sfv[l_ac].sfv08)   #No.FUN-C20048
  LET g_sfv[l_ac].ima02 = l_ima02
  LET g_sfv[l_ac].ima021= l_ima021
END FUNCTION

FUNCTION t620_sfv04_1(p_cmd)    #聯產品料件號編號
  DEFINE p_cmd       LIKE type_file.chr1          #No.FUN-680121 CHAR(1)
  DEFINE l_qde06     LIKE qde_file.qde06          #No:MOD-950101 add    
          #單位 ,數量 ,倉   ,儲   ,批                ,備註
    SELECT qde12,qde06,qde09,qde10,qde11,ima02,ima021,qde08 #No:MOD-950101 add qde06
      INTO g_sfv[l_ac].sfv08,l_qde06,g_sfv[l_ac].sfv05,     #No:MOD-950101 add l_qde06
           g_sfv[l_ac].sfv06,g_sfv[l_ac].sfv07,g_sfv[l_ac].ima02,
           g_sfv[l_ac].ima021,g_sfv[l_ac].sfv12
      FROM qde_file,ima_file
     WHERE qde01 = g_sfv[l_ac].sfv17   #FUN-550085
       AND qde02 = g_sfv[l_ac].sfv11
       AND qde05 = g_sfv[l_ac].sfv04
       AND qde05 = ima01
    CASE WHEN SQLCA.SQLCODE = 100
                      LET g_errno = 'aqc-423' #在FQC聯產品資料維護作業(aqct403)中並無認定此聯產品料號
       OTHERWISE      LET g_errno = SQLCA.SQLCODE USING '-------'
                      IF cl_null(l_qde06) THEN LET l_qde06 = 0 END IF                                                               
                      LET g_sfv[l_ac].sfv09 = l_qde06                                                                               
                      IF g_sma.sma115 = 'Y' THEN                                                                                    
                         LET g_sfv[l_ac].sfv32 = l_qde06                                                                            
                      END IF                                                                                                        
    END CASE
END FUNCTION

FUNCTION t620_FQC()
  DEFINE l_qde06     LIKE qde_file.qde06,
         l_sfv09     LIKE sfv_file.sfv09,
         l_sfv09_now LIKE sfv_file.sfv09,
         l_qty_FQC   LIKE sfv_file.sfv09        #No:FUN-680121 DEC(15,3)#允許入庫量

    SELECT qde06 INTO l_qde06 #聯產品量
      FROM qde_file
     WHERE qde01 = g_qcf.qcf01
       AND qde02 = g_qcf.qcf02
       AND qde05 = g_sfv[l_ac].sfv04

    # sum(已存在入庫單入庫數量) by W/O (不管有無過帳)
    SELECT SUM(sfv09) INTO l_sfv09 FROM sfv_file,sfu_file
     WHERE sfv11 = g_sfv[l_ac].sfv11
       AND sfv04 = g_sfv[l_ac].sfv04
       AND sfv01 = sfu01
       AND sfu00 = '1'   #類別 1.入庫  2.入庫退回
       AND sfv17 = g_sfv[l_ac].sfv17     #No:MOD-950119 add
       AND sfuconf <> 'X' #FUN-660137
       AND sfv01 != g_sfu.sfu01
    SELECT SUM(sfv09) INTO l_sfv09_now FROM sfv_file
     WHERE sfv01  = g_sfu.sfu01
       AND sfv11  = g_sfv[l_ac].sfv11
       AND sfv04  = g_sfv[l_ac].sfv04
       AND sfv17  = g_sfv[l_ac].sfv17     #No:MOD-950119 add
       AND sfv03 != g_sfv[l_ac].sfv03
    IF cl_null(l_sfv09) THEN LET l_sfv09=0 END IF
    IF cl_null(l_sfv09_now) THEN LET l_sfv09_now=0 END IF
    LET l_sfv09 = l_sfv09 + l_sfv09_now
 
    LET l_qty_FQC = l_qde06 - l_sfv09
    RETURN l_sfv09,l_qty_FQC
END FUNCTION

FUNCTION t620_set_entry_b(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680121 CHAR(1)

    CALL cl_set_comp_entry("sfv04",TRUE)
    CALL cl_set_comp_entry("sfv30,sfv31,sfv32,sfv33,sfv34,sfv35",TRUE)
    

END FUNCTION

FUNCTION t620_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680121 CHAR(1)
  DEFINE l_imaicd09 LIKE imaicd_file.imaicd09  #TQC-C60020
  #DEFINE l_imaicd08 LIKE imaicd_file.imaicd08   #FUN-B70061 #FUN-BA0051 mark

 
  IF g_argv<>'3' THEN  #FUN-5C0114
     IF (INFIELD(sfv11) OR INFIELD(sfv17)) AND g_sfv[l_ac].sfv16<>'Y' 
        AND p_cmd <> 's' THEN #MOD-590260 add INFIELD(sfv17)   #No:MOD-790122 modify
        CALL cl_set_comp_entry("sfv04",FALSE)
     END IF
  ELSE
     CALL cl_set_comp_entry("sfv11,sfv04",FALSE)
  END IF
 
  IF g_ima906 = '1' THEN
     CALL cl_set_comp_entry("sfv33,sfv34,sfv35",FALSE)
  END IF
  IF g_ima906 = '2' THEN
     CALL cl_set_comp_entry("sfv31,sfv34",FALSE)
  END IF
  IF g_ima906 = '3' THEN
     CALL cl_set_comp_entry("sfv33",FALSE)
  END IF
 #FUN-BC0104---add---str---
  IF NOT cl_null(g_sfv[l_ac].sfv46) THEN
     CALL cl_set_comp_entry('sfv30,sfv33',FALSE) 
  END IF
 #FUN-BC0104---add---end---
 #MOD-B10184---add---start---
  IF g_ima906 != '2' THEN
     CALL cl_set_comp_entry("sfv30",FALSE)
  END IF
 #MOD-B10184---add---end---


END FUNCTION

#CHI-A40030 add --start--
FUNCTION t6201_set_entry()
    CALL cl_set_comp_entry("ima35,ima36",TRUE)
END FUNCTION
#CHI-A40030 add --end--

#CHI-A40030 add --start--
FUNCTION t6201_set_no_entry()
 IF g_rg1 != '3' THEN
    CALL cl_set_comp_entry("ima35,ima36",FALSE)
 END IF
END FUNCTION
#CHI-A40030 add --end--

FUNCTION t620_set_required_b()

  IF g_ima906 = '3' THEN
     CALL cl_set_comp_required("sfv33,sfv35,sfv30,sfv32",TRUE)
  END IF
  IF NOT cl_null(g_sfv[l_ac].sfv33) THEN
     CALL cl_set_comp_required("sfv35",TRUE)
  END IF
  IF NOT cl_null(g_sfv[l_ac].sfv30) THEN
     CALL cl_set_comp_required("sfv32",TRUE)
  END IF
 
END FUNCTION

FUNCTION t620_set_no_required_b()
 
  CALL cl_set_comp_required("sfv33,sfv34,sfv35,sfv30,sfv31,sfv32",FALSE)

END FUNCTION

#用于default 雙單位/轉換率/數量
FUNCTION t620_du_default(p_cmd)
  DEFINE    l_item   LIKE img_file.img01,     #料號
            l_ware   LIKE img_file.img02,     #倉庫
            l_loc    LIKE img_file.img03,     #儲
            l_lot    LIKE img_file.img04,     #批
            l_ima55  LIKE ima_file.ima55,     #ima單位
            l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_unit2  LIKE img_file.img09,     #第二單位
            l_fac2   LIKE sfv_file.sfv34,     #第二轉換率
            l_qty2   LIKE sfv_file.sfv35,     #第二數量
            l_unit1  LIKE img_file.img09,     #第一單位
            l_fac1   LIKE sfv_file.sfv31,     #第一轉換率
            l_qty1   LIKE sfv_file.sfv32,     #第一數量
            p_cmd    LIKE type_file.chr1,          #No.FUN-680121 CHAR(1)
            l_errno  LIKE type_file.chr20,         #No:MOD-780278 add
            l_factor LIKE ima_file.ima31_fac       #No:FUN-680121 DECIMAL(16,8)

    IF cl_null(g_sfv[l_ac].sfv04) THEN RETURN END IF
    LET l_item = g_sfv[l_ac].sfv04
    LET l_ware = g_sfv[l_ac].sfv05
    LET l_loc  = g_sfv[l_ac].sfv06
    LET l_lot  = g_sfv[l_ac].sfv07

    SELECT ima55,ima906,ima907 INTO l_ima55,l_ima906,l_ima907
      FROM ima_file WHERE ima01 = l_item

    IF l_ima906 = '1' THEN  #不使用雙單位
       LET l_unit2 = NULL
       LET l_fac2  = NULL
       LET l_qty2  = NULL
    ELSE
       LET l_unit2 = l_ima907
       CALL s_du_umfchk(l_item,'','','',l_ima55,l_ima907,l_ima906)
            RETURNING l_errno,l_factor
       IF NOT cl_null(l_errno) THEN LET g_errno =l_errno ENd IF
       LET l_fac2 = l_factor
       LET l_qty2  = 0
    END IF

    IF p_cmd = 'a' THEN
       LET g_sfv[l_ac].sfv33=l_unit2
       LET g_sfv[l_ac].sfv34=l_fac2
       LET g_sfv[l_ac].sfv35=l_qty2
    END IF
END FUNCTION

#對原來數量/換算率/單位的賦值
FUNCTION t620_set_origin_field()
  DEFINE    l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_img09  LIKE img_file.img09,     #img單位
            l_tot    LIKE img_file.img10,
            l_fac2   LIKE sfv_file.sfv34,
            l_qty2   LIKE sfv_file.sfv35,
            l_fac1   LIKE sfv_file.sfv31,
            l_qty1   LIKE sfv_file.sfv32,
            l_factor LIKE ima_file.ima31_fac           #No:FUN-680121 DECIMAL(16,8)

    IF g_sma.sma115='N' THEN RETURN END IF
    LET l_fac2=g_sfv[l_ac].sfv34
    LET l_qty2=g_sfv[l_ac].sfv35
    LET l_fac1=g_sfv[l_ac].sfv31
    LET l_qty1=g_sfv[l_ac].sfv32
 
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF

    SELECT ima55 INTO g_ima55 FROM ima_file WHERE ima01=g_sfv[l_ac].sfv04
    IF g_sma.sma115 = 'Y' THEN
       CASE g_ima906
          #'1'這種情況是不應該出現的.但是由于操作的順序問題,故目前保留它
          WHEN '1' LET g_sfv[l_ac].sfv08=g_sfv[l_ac].sfv30
                   LET g_sfv[l_ac].sfv09=l_qty1
          WHEN '2' LET l_tot=l_fac1*l_qty1+l_fac2*l_qty2
                   LET g_sfv[l_ac].sfv08=g_ima55
                   LET g_sfv[l_ac].sfv09=l_tot
          WHEN '3' LET g_sfv[l_ac].sfv08=g_sfv[l_ac].sfv30
                   LET g_sfv[l_ac].sfv09=l_qty1
                   IF l_qty2 <> 0 THEN
                      LET g_sfv[l_ac].sfv34=l_qty1/l_qty2
                   ELSE
                      LET g_sfv[l_ac].sfv34=0
                   END IF
       END CASE
       LET g_sfv[l_ac].sfv09 = s_digqty(g_sfv[l_ac].sfv09,g_sfv[l_ac].sfv08)   #No.FUN-C20048
    END IF
   #MOD-A80060---mark---start---
   #LET l_factor = 1
   #IF g_ima55 != g_sfv[l_ac].sfv08 THEN
   #   CALL s_umfchk(g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv08,g_ima55)
   #      RETURNING g_cnt,l_factor
   #   IF g_cnt = 1 THEN
   #      LET l_factor = 1
   #   END IF
   #   LET g_sfv[l_ac].sfv08=g_ima55
   #   LET g_sfv[l_ac].sfv09=g_sfv[l_ac].sfv09 * l_factor
   #END IF
   #MOD-A80060---mark---end---
END FUNCTION

FUNCTION t620_set_du_by_origin()
  DEFINE l_ima25    LIKE ima_file.ima25,
         l_ima31    LIKE ima_file.ima31,
         l_ima906   LIKE ima_file.ima906,
         l_ima907   LIKE ima_file.ima907,
         l_ima908   LIKE ima_file.ima908,
         l_factor   LIKE ima_file.ima31_fac           #No:FUN-680121 DECIMAL(16,8)


       IF cl_null(g_sfv[l_ac].sfv30) THEN
          LET g_sfv[l_ac].sfv30 = g_sfv[l_ac].sfv08
          LET g_sfv[l_ac].sfv31 = 1
          LET g_sfv[l_ac].sfv32 = g_sfv[l_ac].sfv09
       END IF
 
       IF l_ima906 = '1' THEN  #不使用雙單位
          LET g_sfv[l_ac].sfv33 = NULL
          LET g_sfv[l_ac].sfv34 = NULL
          LET g_sfv[l_ac].sfv35 = NULL
       ELSE
          IF cl_null(g_sfv[l_ac].sfv33) THEN
             LET g_sfv[l_ac].sfv33 = l_ima907
             CALL s_du_umfchk(g_sfv[l_ac].sfv04,'','','',g_sfv[l_ac].sfv08,l_ima907,l_ima906)
                  RETURNING g_errno,l_factor
             LET g_sfv[l_ac].sfv34 = l_factor
             LET g_sfv[l_ac].sfv35 = 0
          END IF
       END IF
 
END FUNCTION

#以img09單位來計算雙單位所確定的數量
FUNCTION t620_tot_by_img09(p_item,p_fac2,p_qty2,p_fac1,p_qty1)
  DEFINE p_item    LIKE ima_file.ima01
  DEFINE p_fac2    LIKE sfv_file.sfv34
  DEFINE p_qty2    LIKE sfv_file.sfv35
  DEFINE p_fac1    LIKE sfv_file.sfv31
  DEFINE p_qty1    LIKE sfv_file.sfv32
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
          #'1'這種情況是不應該出現的.但是由于操作的順序問題,故目前保留它
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
FUNCTION t620_check_inventory_qty(p_qty_FQC,p_FQC,p_qcf091)
  DEFINE l_tot      LIKE img_file.img10
  DEFINE p_qty_FQC  LIKE sfv_file.sfv09,           #No:FUN-680121 DEC(15,3)
         p_FQC      LIKE type_file.chr1,           #No:FUN-680121 CHAR(1)
         p_qcf091   LIKE qcf_file.qcf091,
         l_ecm315   LIKE ecm_file.ecm315,
         l_ecm_out  LIKE ecm_file.ecm315,
         l_ecm311   LIKE ecm_file.ecm311
  DEFINE l_sfb08    LIKE sfb_file.sfb08
  DEFINE l_sfb09    LIKE sfb_file.sfb09
  DEFINE l_sfv09    LIKE sfv_file.sfv09
  DEFINE l_flag     LIKE type_file.chr1          #No.FUN-680121 CHAR(1)
  DEFINE l_ecm012   LIKE ecm_file.ecm012         #FUN-A50066
  DEFINE l_ecm03    LIKE ecm_file.ecm03          #FUN-A50066
  DEFINE l_qcl05    LIKE qcl_file.qcl05          #FUN-BC0104

    CALL t620_tot_by_img09(g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv34,g_sfv[l_ac].sfv35,
                           g_sfv[l_ac].sfv31,g_sfv[l_ac].sfv32)
         RETURNING l_tot
 
    LET g_sfv[l_ac].sfv09 = l_tot
    LET g_sfv[l_ac].sfv09 = s_digqty(g_sfv[l_ac].sfv09,g_sfv[l_ac].sfv08)   #No.FUN-BB0086
    IF g_sfv[l_ac].sfv09 <= 0 THEN 
       LET g_sfv[l_ac].sfv09 = 0
       CALL cl_err(g_sfv[l_ac].sfv09,'asf-989',1)  #No:CHI-950010     
       RETURN 1
    END IF

    #------->聯產品 NO:6872
    IF p_FQC = 'Y' THEN
       IF g_sfv[l_ac].sfv09 > p_qty_FQC THEN
          CALL cl_err(g_sfv[l_ac].sfv09,'asf-997',1)  #No:CHI-950010 
          RETURN 1
       END IF
    ELSE
       ##---------------------------------------------------
       IF g_argv MATCHES '[12]' THEN   #入庫,退回
          SELECT sfb08,sfb09 INTO l_sfb08,l_sfv09 FROM sfb_file
           WHERE sfb01 = g_sfv[l_ac].sfv11
          IF l_sfv09 IS NULL THEN LET l_sfv09 = 0 END IF
          IF l_sfb08 IS NULL THEN LET l_sfb08 = 0 END IF
          IF g_argv = '2' THEN   #退庫時不可大於入庫數量
             IF g_sfv[l_ac].sfv09 > l_sfv09 THEN
                CALL cl_err(g_sfv[l_ac].sfv09,'asf-712',1)
                RETURN 1
             END IF
          END IF
       END IF
       ##----------------------------------------
       #工單完工方式為'2' pull
       IF g_argv = '1' AND g_sfv[l_ac].sfv09 > 0  AND
          g_sfb.sfb39 <> '2' THEN
          # check 入庫數量 不可 大於 (生產數量-完工數量)
          IF g_sfb.sfb93!='Y'THEN
             IF (g_sfv[l_ac].sfv09 > l_sfb08 - l_sfv09 + g_over_qty ) THEN
                CALL cl_err(g_sfv[l_ac].sfv09,'asf-714',1)
                RETURN 1
             END IF
# sma73    工單完工數量是否檢查發料最小套數
# sma74    工單完工量容許差異百分比
          #入庫量不可大於最小套數-以keyin 入庫量
             IF g_sma.sma73='Y' AND (g_sfv[l_ac].sfv09) > (g_min_set-tmp_qty) THEN
                CALL cl_err(g_sfv[l_ac].sfv09,'asf-675',1)
                RETURN 1
             END IF
          END IF
 
          IF g_sfb.sfb93='Y' THEN # 走製程 check 轉出量
             IF g_sfv[l_ac].sfv09 > g_ecm_out - tmp_qty THEN
                IF NOT t620_chk_auto_report(g_sfv[l_ac].sfv11,g_sfv[l_ac].sfv09) THEN  #FUN-A80102
                   CALL cl_err(g_sfv[l_ac].sfv09,'asf-675',1)
                   RETURN 1
                END IF
             END IF
#TQC-C10126 mark begin 因為,如果有多個工藝序,每個工藝序都有bonus的話,最終入庫數量肯定會大於發料套數
#             IF g_sma.sma73='Y' AND (g_sfv[l_ac].sfv09) > (g_min_set+g_ecm315-tmp_qty) THEN
#                CALL cl_err(g_sfv[l_ac].sfv09,'asf-675',1)
#                RETURN 1
#             END IF
#TQC-C10126 mark end
          END IF
 
          #IF g_sfb.sfb94='Y' AND #是否使用FQC功能
          IF g_sfb.sfb94='Y' AND g_sma.sma896='Y' AND
             (g_sfv[l_ac].sfv09) > p_qcf091 - tmp_qty
          THEN
          #----FQC No.不為null,入庫量不可大於FQC量-以keyin 入庫量
             CALL cl_err(g_sfv[l_ac].sfv09,'asf-675',1)
             RETURN 1
          END IF
       END IF
##--------------------------------------------------
#No:7834      工單完工方式為'2' pull(sfb39='2')&走製程(sfb93='Y')
       IF g_argv = '1' AND g_sfv[l_ac].sfv09 > 0  AND
          g_sfb.sfb39= '2' AND g_sfb.sfb93='Y' THEN
          CALL s_schdat_max_ecm03(g_sfv[l_ac].sfv11) RETURNING l_ecm012,l_ecm03  #FUN-A50066
          #check 最終製程之總轉出量(良品轉出量+Bonus)
          SELECT ecm311,ecm315 INTO l_ecm311,l_ecm315 FROM ecm_file
           WHERE ecm01=g_sfv[l_ac].sfv11
            #AND ecm03= (SELECT MAX(ecm03) FROM ecm_file  #FUN-A50066
            #             WHERE ecm01=g_sfv[l_ac].sfv11)  #FUN-A50066
             AND ecm012= l_ecm012  #FUN-A50066
             AND ecm03 = l_ecm03   #FUN-A50066

          IF SQLCA.sqlcode THEN
             LET l_ecm311=0
             LET l_ecm315=0
          END IF
          LET l_ecm_out=l_ecm311 + l_ecm315
 
          LET l_sfv09=0     #已key之入庫量(不分是否已過帳)
          SELECT SUM(sfv09) INTO l_sfv09 FROM sfv_file,sfu_file
           WHERE sfv11 = g_sfv[l_ac].sfv11
             AND sfv01 ! = g_sfu.sfu01
             AND sfv01 = sfu01
             AND sfu00 = '1'           #完工入庫
             AND sfuconf <> 'X' #FUN-660137
          IF l_sfv09 IS NULL THEN LET l_sfv09 =0 END IF
          LET l_sfv09 = l_sfv09 + g_sfv[l_ac].sfv09
 
          #入庫量 > 製程最後轉出量
          IF l_sfv09 > l_ecm_out THEN
             LET g_msg ="(",l_sfv09   USING '############.###','>',  #No:MOD-970035 modify
                         l_ecm_out USING '############.###',")"      #No:MOD-970035 modify
             IF NOT t620_chk_auto_report(g_sfv[l_ac].sfv11,g_sfv[l_ac].sfv09) THEN  #FUN-A80102
                CALL cl_err(g_msg,'asf-675',1)
                RETURN 1
             END IF
          END IF
       END IF
##
       IF g_argv = '2' AND g_sfv[l_ac].sfv09 > 0  AND
          g_sfv[l_ac].sfv09> g_sfb.sfb09 - tmp_qty
       THEN
       #----退回量不可大於完工入庫量
           CALL cl_err(g_sfv[l_ac].sfv09,'asf-712',1)
           RETURN 1
       END IF
    END IF #--->聯產品END
    RETURN 0
END FUNCTION

#兩組雙單位資料不是一定要全部KEY,如果沒有KEY單位,則把換算率/數量清空
FUNCTION t620_du_data_to_correct()

   IF cl_null(g_sfv[l_ac].sfv30) THEN
      LET g_sfv[l_ac].sfv31 = NULL
      LET g_sfv[l_ac].sfv32 = NULL
   END IF
 
   IF cl_null(g_sfv[l_ac].sfv33) THEN
      LET g_sfv[l_ac].sfv34 = NULL
      LET g_sfv[l_ac].sfv35 = NULL
   END IF
   DISPLAY BY NAME g_sfv[l_ac].sfv31
   DISPLAY BY NAME g_sfv[l_ac].sfv32
   DISPLAY BY NAME g_sfv[l_ac].sfv34
   DISPLAY BY NAME g_sfv[l_ac].sfv35

END FUNCTION


FUNCTION t620_def_form()
    IF g_sma.sma115 ='N' THEN
       CALL cl_set_comp_visible("sfv30,sfv32,sfv33,sfv35",FALSE)
       CALL cl_set_comp_visible("sfv08,sfv09",TRUE)
    ELSE
       CALL cl_set_comp_visible("sfv30,sfv32,sfv33,sfv35",TRUE)
       CALL cl_set_comp_visible("sfv08,sfv09",FALSE)
    END IF
    CALL cl_set_comp_visible("sfv31,sfv34",FALSE)
    IF g_sma.sma122 ='1' THEN
       CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("sfv33",g_msg CLIPPED)
       CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("sfv35",g_msg CLIPPED)
       CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("sfv30",g_msg CLIPPED)
       CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("sfv32",g_msg CLIPPED)
    END IF
    IF g_sma.sma122 ='2' THEN
       CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("sfv33",g_msg CLIPPED)
       CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("sfv35",g_msg CLIPPED)
       CALL cl_getmsg('asm-328',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("sfv30",g_msg CLIPPED)
       CALL cl_getmsg('asm-329',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("sfv32",g_msg CLIPPED)
    END IF
END FUNCTION

FUNCTION t620_set_form_default()
DEFINE l_items STRING
   CALL cl_set_comp_visible("sfv14",g_argv='3')
   IF g_argv='3' THEN
      CALL cl_set_comp_visible("sfu09",FALSE)
      CALL cl_set_act_visible("gen_mat_wtdw",FALSE)
      CALL cl_set_act_visible("maint_mat_wtdw",FALSE)
      LET l_items = '1:',cl_getmsg('asr-016',g_lang)
      LET l_items = l_items CLIPPED,',2:',cl_getmsg('asr-017',g_lang)
      LET l_items = l_items CLIPPED,',3:',cl_getmsg('asr-018',g_lang)
      LET l_items = l_items CLIPPED,',4:',cl_getmsg('asr-019',g_lang)
      CALL cl_set_combo_items("sfv16","1,2,3,4",l_items CLIPPED)
      LET l_items = cl_getmsg('asr-020',g_lang)
      CALL cl_set_comp_att_text("sfv17",l_items CLIPPED)
      LET l_items = cl_getmsg('asr-021',g_lang)
      CALL cl_set_comp_att_text("sfv16",l_items CLIPPED)
      LET l_items = cl_getmsg('asr-022',g_lang)
      CALL cl_set_comp_att_text("sfv11",l_items CLIPPED)
      LET l_items = cl_getmsg('asr-023',g_lang)
      CALL cl_set_comp_att_text("sfv04",l_items CLIPPED)
      CALL cl_set_comp_required("sfv17",TRUE) #FUN-670103
   END IF
   IF g_aaz.aaz90='Y' THEN
      CALL cl_set_comp_required("sfu04",TRUE)
   END IF
   CALL cl_set_comp_visible("sfv930,gem02c",g_aaz.aaz90='Y')
   IF g_argv<>'3' THEN #For ASF
      CALL cl_set_comp_entry("sfv930",FALSE)
   END IF

   CALL cl_set_comp_visible("sfu06,pja02,sfv41,sfv42,sfv43",g_aza.aza08='Y')  #MOD-A60131 remove sfv44
   CALL cl_set_comp_required('sfv44',g_aza.aza115 ='Y')         #FUN-CB0087 add 

   CALL cl_set_act_visible("qry_lot,modi_lot",g_sma.sma95="Y")  #FUN-C80030 add
   CALL cl_set_comp_visible("Page2",g_sma.sma95="Y")            #FUN-C80030 add
END FUNCTION

FUNCTION t620_asr_sfv17()
DEFINE l_result LIKE type_file.num5,          #No:FUN-680121 SMALLINT
       l_cnt    LIKE type_file.num10          #No:FUN-680121 INTEGER

   LET l_result=FALSE
   SELECT COUNT(*) INTO l_cnt FROM srf_file WHERE srfconf='Y'
                                              AND srf07='1' #FUN-670103
      AND srf01 = g_sfv[l_ac].sfv17      #No.TQC-710114
   IF SQLCA.sqlcode THEN
      LET l_cnt=0
   END IF
   IF l_cnt = 0 THEN
      CALL cl_err(g_sfv[l_ac].sfv17,'asf-107',0)
      LET l_result=FALSE
   END IF
   IF l_cnt>0 THEN
      LET l_result=TRUE
   END IF
   RETURN l_result
END FUNCTION

FUNCTION t620_asr_sfv14()
DEFINE l_srg15  LIKE srg_file.srg15,
       l_srg12  LIKE srg_file.srg12,
       l_cnt    LIKE type_file.num10         #No:FUN-680121 INTEGER

   IF cl_null(g_sfv[l_ac].sfv17) OR cl_null(g_sfv[l_ac].sfv14) THEN
      RETURN TRUE
   END IF
   SELECT srg15,srg12 INTO l_srg15,l_srg12 FROM srf_file,srg_file WHERE srf01=srg01
                                                                    AND srfconf='Y'
                                                                    AND srg01=g_sfv[l_ac].sfv17
                                                                    AND srg02=g_sfv[l_ac].sfv14
   IF SQLCA.sqlcode THEN
      CALL cl_err('chk srg',100,1)
      RETURN FALSE
   END IF
 
   IF (l_srg15='Y') AND (NOT cl_null(l_srg12)) THEN
      SELECT COUNT(*) INTO l_cnt FROM qcs_file WHERE qcs01=l_srg12
                                                 AND qcs02=g_sfv[l_ac].sfv14
                                                 AND qcs14='Y'
                                                 AND (qcs09='1' OR qcs09='3')
      IF (SQLCA.sqlcode) OR (l_cnt=0) THEN
         CALL cl_err('chk srg',100,1)
         RETURN FALSE
      ELSE
         CALL t620_asr_set_sfv14()
         RETURN TRUE
      END IF
   ELSE
      CALL t620_asr_set_sfv14()
      RETURN TRUE
   END IF
END FUNCTION

FUNCTION t620_asr_set_sfv14()
DEFINE l_srg05     LIKE srg_file.srg05
DEFINE l_tot       LIKE sfv_file.sfv09
DEFINE l_ima55_fac LIKE ima_file.ima55_fac
   IF cl_null(g_sfv[l_ac].sfv17) OR cl_null(g_sfv[l_ac].sfv14) THEN
      LET g_sfv[l_ac].sfv11 =''
      LET g_sfv[l_ac].sfv04 =''
      LET g_sfv[l_ac].ima02 =''
      LET g_sfv[l_ac].ima021=''
      LET g_sfv[l_ac].sfv08 =''
      LET g_sfv[l_ac].sfv09 =''
      LET g_sfv[l_ac].sfv30 =''
      LET g_sfv[l_ac].sfv31 =''
      LET g_sfv[l_ac].sfv32 =''
      LET g_sfv[l_ac].sfv33 =''
      LET g_sfv[l_ac].sfv34 =''
      LET g_sfv[l_ac].sfv35 =''
      DISPLAY BY NAME g_sfv[l_ac].sfv11,g_sfv[l_ac].sfv04,g_sfv[l_ac].ima02,g_sfv[l_ac].ima021,
                      g_sfv[l_ac].sfv08,g_sfv[l_ac].sfv09,g_sfv[l_ac].sfv30,g_sfv[l_ac].sfv31,
                      g_sfv[l_ac].sfv32,g_sfv[l_ac].sfv33,g_sfv[l_ac].sfv34,g_sfv[l_ac].sfv35
   ELSE
      SELECT srg03,srg14,srg13,srg05 INTO g_sfv[l_ac].sfv11,g_sfv[l_ac].sfv04,
                                    g_sfv[l_ac].sfv16,l_srg05
                                    FROM srg_file WHERE srg01=g_sfv[l_ac].sfv17
                                                    AND srg02=g_sfv[l_ac].sfv14
      DISPLAY BY NAME g_sfv[l_ac].sfv11,g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv16
      SELECT ima02,ima021,ima55,ima906,ima907,ima55_fac 
        INTO g_sfv[l_ac].ima02,g_sfv[l_ac].ima021,
             g_ima55,g_ima906,g_ima907,l_ima55_fac FROM ima_file
              WHERE ima01=g_sfv[l_ac].sfv04
      DISPLAY BY NAME g_sfv[l_ac].ima02,g_sfv[l_ac].ima021
      LET g_sfv[l_ac].sfv30=g_ima55
      LET g_sfv[l_ac].sfv32=s_digqty(g_sfv[l_ac].sfv32,g_sfv[l_ac].sfv30)   #No.FUN-C20048
      DISPLAY BY NAME g_sfv[l_ac].sfv30
      IF g_sma.sma115 ='Y' THEN
         IF g_ima906 = '3' THEN
            LET g_sfv[l_ac].sfv33=g_ima907
            DISPLAY BY NAME g_sfv[l_ac].sfv30
         END IF
      #...............begin #當sfv09無值時,帶最大可入庫數
      ELSE
         IF cl_null(g_sfv[l_ac].sfv09) OR (g_sfv[l_ac].sfv09=0) THEN
            SELECT SUM(sfv09) INTO l_tot
               FROM sfu_file,sfv_file 
              WHERE sfu01=sfv01 AND sfu00='3' 
                AND sfuconf<>'X' #FUN-660137
                AND sfv17=g_sfv[l_ac].sfv17
                AND sfv14=g_sfv[l_ac].sfv14
            IF cl_null(l_tot) THEN LET l_tot=0 END IF
            LET l_srg05=l_srg05*l_ima55_fac
            IF l_tot<l_srg05 THEN
               LET l_srg05=l_srg05-l_tot
               LET l_srg05=l_srg05/l_ima55_fac
               LET g_sfv[l_ac].sfv09=l_srg05
               LET g_sfv[l_ac].sfv09=s_digqty(g_sfv[l_ac].sfv09,g_sfv[l_ac].sfv08)   #No.FUN-C20048
               DISPLAY BY NAME g_sfv[l_ac].sfv09
            END IF
         END IF
      END IF
   END IF
END FUNCTION

#for asrt320 only , same as asrt300_v()
FUNCTION t620_v()
DEFINE li_result LIKE type_file.num5,      #No.FUN-680121 SMALLINT
       l_cnt LIKE type_file.num10,         #No:FUN-680121 INTEGER
       l_srg RECORD LIKE srg_file.*,
       l_sfp RECORD LIKE sfp_file.*,
       l_sfs RECORD LIKE sfs_file.*,
       l_sfv RECORD LIKE sfv_file.*,
       l_srf02    LIKE srf_file.srf02,
       l_ima55    LIKE ima_file.ima55,
       l_sql STRING
DEFINE l_bmb RECORD
            bmb03   LIKE bmb_file.bmb03,
            bmb06   LIKE bmb_file.bmb06,
            bmb07   LIKE bmb_file.bmb07,
            bmb08   LIKE bmb_file.bmb08,
            bmb16   LIKE bmb_file.bmb16
             END RECORD
DEFINE  l_n1        LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
DEFINE  l_n2        LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
DEFINE  l_n3        LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044  
DEFINE  l_smy73     LIKE smy_file.smy73    #TQC-AC0293 
 
   IF g_sfu.sfu01 IS NULL THEN RETURN END IF
   SELECT * INTO g_sfu.* FROM sfu_file WHERE sfu01 = g_sfu.sfu01
 
   IF g_sfu.sfuconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF #FUN-660137
   IF g_sfu.sfupost = 'N' THEN  #未過帳
      CALL cl_err(g_sfu.sfu09,'asf-666',0)
      RETURN
   END IF
   IF NOT cl_null(g_sfu.sfu09) THEN  #已產生領料單
      CALL cl_err(g_sfu.sfu09,'asf-826',0)
      RETURN
   END IF
 
   INPUT g_sfu.sfu09 WITHOUT DEFAULTS FROM g_sfu.sfu09
      AFTER FIELD sfu09
        IF NOT cl_null(g_sfu.sfu09) THEN
           CALL s_check_no("asf",g_sfu.sfu09,"","3","sfu_file","sfu09","")
              RETURNING li_result,g_sfu.sfu09
           DISPLAY BY NAME g_sfu.sfu09
           IF (NOT li_result) THEN
              NEXT FIELD sfu09
           END IF
          #TQC-AC0293 ---------------add start----------
           LET g_t1 = s_get_doc_no(g_sfu.sfu09)
           SELECT smy73 INTO l_smy73 FROM smy_file
            WHERE smyslip = g_t1
           IF l_smy73 = 'Y' THEN
              CALL cl_err('','asf-872',0)
              NEXT FIELD sfu09
           END IF
          #TQC-AC0293 ---------------add end-------------
          #CALL s_auto_assign_no("asf",g_sfu.sfu09,g_sfu.sfu02,"","sfp_file","sfp01","","","") #MOD-A40051 mark
           CALL s_auto_assign_no("asf",g_sfu.sfu09,g_sfu.sfu14,"","sfp_file","sfp01","","","") #MOD-A40051
                RETURNING li_result,g_sfu.sfu09
           IF (NOT li_result) THEN
              NEXT FIELD sfu09
           END IF
           DISPLAY BY NAME g_sfu.sfu09
        END IF

      ON ACTION controlp
         CASE
            WHEN INFIELD(sfu09)
               LET g_t1 = s_get_doc_no(g_sfu.sfu09)
               LET g_sql = " (smy73 <> 'Y' OR smy73 is null)"  #TQC-AC0293
               CALL smy_qry_set_par_where(g_sql)               #TQC-AC0293
               CALL q_smy(FALSE,TRUE,g_t1,'ASF','3') RETURNING g_t1  #TQC-670008
               LET g_sfu.sfu09=g_t1
               DISPLAY BY NAME g_sfu.sfu09
               NEXT FIELD sfu09
            OTHERWISE EXIT CASE
         END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
   END INPUT

   IF cl_null(g_sfu.sfu09) THEN   #未輸入任何data
      RETURN
   END IF
   IF NOT cl_sure(0,0) THEN
      RETURN
   END IF
 
  #TQC-C90071--add--start
   IF NOT cl_null(g_sfu.sfu09) THEN  #已產生領料單
      CALL cl_err('','asf-826',0)
   END IF
  #TQC-C90071-add--end
   LET l_sfp.sfp01 = g_sfu.sfu09
   LET l_sfp.sfp02 = g_today
   LET l_sfp.sfp03 = g_today
   LET l_sfp.sfp04 = 'N'
   LET l_sfp.sfpconf = 'N' #FUN-660106
   LET l_sfp.sfp05 = 'N'
   LET l_sfp.sfp06 = 'C'
   #FUN-AB0001--add---str---
   LET l_sfp.sfpmksg = g_smy.smyapr #是否簽核
   LET l_sfp.sfp15 = '0'            #簽核狀況
   LET l_sfp.sfp16 = g_user         #申請人
   #FUN-AB0001--add---end---
   LET l_sfp.sfp07 = g_grup #FUN-670103
   LET l_sfp.sfpplant = g_plant #FUN-980008 add
   LET l_sfp.sfplegal = g_legal #FUN-980008 add
 
   LET g_success='Y'
   BEGIN WORK
   INSERT INTO sfp_file VALUES (l_sfp.*)
   IF SQLCA.sqlcode THEN
      LET g_success='N'
      CALL cl_err('',SQLCA.sqlcode,1)      #FUN-B80086    ADD
      ROLLBACK WORK
     # CALL cl_err('',SQLCA.sqlcode,1)     #FUN-B80086    MARK
      LET g_sfu.sfu09=''
      DISPLAY BY NAME g_sfu.sfu09
      RETURN
   END IF

   LET l_cnt=0
   DECLARE t300_v_cur CURSOR FOR SELECT srg_file.*,sfv_file.*,srf02
                                                        FROM srg_file,sfv_file,srf_file
                                                       WHERE srg01=sfv01
                                                         AND srg02=sfv03   #FUN-810038
                                                         AND srf01=srg01
                                                         AND sfv01=g_sfu.sfu01
   FOREACH t300_v_cur INTO l_srg.*,l_sfv.*,l_srf02
      IF SQLCA.sqlcode THEN
         LET g_success='N'
         CALL cl_err('',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      LET l_sql = "SELECT bmb03,bmb06,bmb07,bmb08,bmb16,ima55 FROM bmb_file,ima_file",
                  " WHERE ima01=bmb03 AND bmb01='",l_sfv.sfv04,"'",
                  "   AND (bmb04 <='",l_srf02,"' OR bmb04 IS NULL )",
                  "   AND (bmb05 > '",l_srf02,"' OR bmb05 IS NULL )",
                  "   AND bmb15='Y'"
      PREPARE t300_v_cur1_pre FROM l_sql
      DECLARE t300_v_cur1 CURSOR FOR t300_v_cur1_pre
      FOREACH t300_v_cur1 INTO l_bmb.*,l_ima55
         IF SQLCA.sqlcode THEN
            LET g_success='N'
            CALL cl_err('',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         LET l_cnt = l_cnt+1
         LET l_sfs.sfs01 = l_sfp.sfp01
         LET l_sfs.sfs02 = l_cnt
         LET l_sfs.sfs03 = l_sfv.sfv04
         LET l_sfs.sfs04 = l_bmb.bmb03
         LET l_sfs.sfs05 = l_sfv.sfv09      #入庫量
         LET l_sfs.sfs06 = l_sfv.sfv08      #入庫單位
         LET l_sfs.sfs07 = l_sfv.sfv05      #倉庫
         LET l_sfs.sfs08 = l_sfv.sfv06      #儲位
         LET l_sfs.sfs09 = l_sfv.sfv07      #批號
         LET l_sfs.sfs10 = ' '          #作業序號
         LET l_sfs.sfs26 = NULL         #替代碼
         LET l_sfs.sfs27 = l_sfs.sfs04  #被替代料號   #No:MOD-8B0086 add
        #LET l_sfs.sfs28 = NULL         #替代率      #MOD-C60203 mark
         LET l_sfs.sfs28 = 1            #替代率      #MOD-C60203 add
         LET l_sfs.sfs30 = l_sfv.sfv30
         LET l_sfs.sfs31 = l_sfv.sfv31
         LET l_sfs.sfs32 = l_sfv.sfv32
         LET l_sfs.sfs33 = l_sfv.sfv33
         LET l_sfs.sfs34 = l_sfv.sfv34
         LET l_sfs.sfs35 = l_sfv.sfv35
         LET l_sfs.sfs930= l_sfv.sfv930 #FUN-670103
          IF cl_null(l_sfs.sfs07) AND cl_null(l_sfs.sfs08) THEN
#            SELECT ima35,ima26 INTO  l_sfs.sfs07,l_sfs.sfs08
             SELECT ima35,0 INTO  l_sfs.sfs07,l_sfs.sfs08
               FROM ima_file
              WHERE ima01 = l_sfs.sfs04
            ##Add No.FUN-AA0055  #Mark No.FUN-AB0054 此处不做判断，交予单据审核时控管
            #IF NOT s_chk_ware(l_sfs.sfs07) THEN  #检查仓库是否属于当前门店
            #   LET g_success = 'N'
            #END IF
            ##End Add No.FUN-AA0055
             CALL s_getstock(l_sfs.sfs04,g_plant) RETURNING  l_n1,l_n2,l_n3  ###GP5.2  #NO.FUN-A20044 
             LET l_sfs.sfs08 = l_n1
          END IF

         LET l_sfs.sfsplant = g_plant #FUN-980008 add
         LET l_sfs.sfslegal = g_legal #FUN-980008 add

#FUN-A70125 --begin--
            IF cl_null(l_sfs.sfs012) THEN
               LET l_sfs.sfs012 = ' ' 
            END IF  
            IF cl_null(l_sfs.sfs013) THEN
               LET l_sfs.sfs013 = 0 
            END IF        
#FUN-A70125 --end--
#FUN-C70014 add begin-----------------
            IF cl_null(l_sfs.sfs014) THEN
               LET l_sfs.sfs014 = ' '  
            END IF
#FUN-C70014 add end ------------------
         #FUN-CB0087---add---str---
         IF g_aza.aza115 = 'Y' THEN
            CALL s_reason_code(l_sfs.sfs01,l_sfs.sfs03,'',l_sfs.sfs04,l_sfs.sfs07,l_sfp.sfp16,l_sfp.sfp07) RETURNING l_sfs.sfs37
            IF cl_null(l_sfs.sfs37) THEN
               CALL cl_err('','aim-425',1)
               LET g_success = 'N'
            END IF
         END IF
         #FUN-CB0087---add---end--
         INSERT INTO sfs_file VALUES (l_sfs.*)
         IF SQLCA.sqlcode THEN
            LET g_success='N'
            CALL cl_err('',SQLCA.sqlcode,1)
         END IF
      END FOREACH
   END FOREACH

   IF l_cnt=0 THEN #無產生任何單身資料
      CALL cl_err('','mfg3442',1)
      LET g_success='N'
   END IF

   IF g_success='Y' THEN
      UPDATE sfu_file SET sfu09=g_sfu.sfu09 WHERE sfu01=g_sfu.sfu01
      IF SQLCA.sqlcode THEN
         CALL cl_err('',SQLCA.sqlcode,1)
         LET g_success='N'
      END IF
   END IF
 
   IF g_success='Y' THEN
      COMMIT WORK
      CALL cl_err('','lib-284',1)
   ELSE
      ROLLBACK WORK
      LET g_sfu.sfu09=''
   END IF
   DISPLAY BY NAME g_sfu.sfu09
END FUNCTION


FUNCTION t620_asrchk_sfv09(p_sfv17,p_sfv14,p_sfv09)
DEFINE p_sfv17 LIKE sfv_file.sfv17, #報工單號
       p_sfv14 LIKE sfv_file.sfv14, #報工項次
       p_sfv09,l_tot LIKE sfv_file.sfv09, #入庫數
       l_srg05 LIKE srg_file.srg05,
       l_srg03 LIKE srg_file.srg03,
       l_srg15 LIKE srg_file.srg15,
       l_qcs091 LIKE qcs_file.qcs091,
       l_ima55_fac LIKE ima_file.ima55_fac
   
   IF cl_null(p_sfv17) OR cl_null(p_sfv14) THEN
      RETURN TRUE
   END IF

   SELECT srg05,srg03,srg15 INTO l_srg05,l_srg03,l_srg15 
                                  FROM srg_file 
                                 WHERE srg01=p_sfv17
                                   AND srg02=p_sfv14
   IF SQLCA.sqlcode OR cl_null(l_srg05) THEN
      LET l_srg05=0
   END IF 
   
   SELECT SUM(sfv09) INTO l_tot FROM sfu_file,sfv_file
      WHERE sfu01=sfv01
        AND sfu00='3'
        AND sfuconf<>'X' #FUN-660137
        AND sfv17=p_sfv17
        AND sfv14=p_sfv14
        AND NOT (sfv01=g_sfu.sfu01 AND sfv03=g_sfv[l_ac].sfv03)
   IF SQLCA.sqlcode OR cl_null(l_tot) THEN
      LET l_tot=0
   END IF

   IF l_srg15='Y' THEN #需檢驗,Check FQC 合格量
      SELECT SUM(qcs091) INTO l_qcs091 FROM qcs_file
                                 WHERE qcs01=p_sfv17
                                   AND qcs02=p_sfv14
                                   AND qcs14='Y'
                                   AND qcsacti='Y'
      IF SQLCA.sqlcode THEN
         LET l_qcs091=0
      END IF
   END IF
   
   CASE l_srg15
      WHEN "Y"
         IF l_qcs091<(p_sfv09+l_tot) THEN
            CALL cl_err('','asr-034',1)
            RETURN FALSE
         ELSE
            RETURN TRUE
         END IF
      OTHERWISE
         SELECT ima55_fac INTO l_ima55_fac FROM ima_file WHERE ima01=l_srg03
         IF SQLCA.sqlcode OR cl_null(l_ima55_fac) THEN
            LET l_ima55_fac=1
         END IF 
         LET l_srg05=l_srg05*l_ima55_fac
         IF (l_srg05<p_sfv09+l_tot) THEN
            CALL cl_err('','asr-033',1)
            RETURN FALSE
         ELSE
            RETURN TRUE
         END IF
   END CASE
END FUNCTION

#圖形顯示
FUNCTION t620_pic()
  DEFINE g_chr2     LIKE type_file.chr1    #FUN-A80128 add
   IF g_sfu.sfuconf = 'X' THEN
      LET g_void = 'Y'
   ELSE
      LET g_void = 'N'
   END IF
   #FUN-A80128--add---str--
   IF g_sfu.sfu15 = '1' THEN
       LET g_chr2 = 'Y'
   ELSE
       LET g_chr2 = 'N'
   END IF
   CALL cl_set_field_pic(g_sfu.sfuconf,g_chr2,g_sfu.sfupost,"",g_void,"")
  #CALL cl_set_field_pic(g_sfu.sfuconf,"",g_sfu.sfupost,"",g_void,"") #FUN-A80128 mark
END FUNCTION


FUNCTION t620_add_img(p_sfv04,p_sfv05,p_sfv06,p_sfv07,p_sfu01,p_sfv03,p_day)
   DEFINE p_sfv04 LIKE sfv_file.sfv04,
          p_sfv05 LIKE sfv_file.sfv05,
          p_sfv06 LIKE sfv_file.sfv06,
          p_sfv07 LIKE sfv_file.sfv07,
          p_sfu01 LIKE sfu_file.sfu01,
          p_sfv03 LIKE sfv_file.sfv03,
          p_day   LIKE type_file.dat

   IF cl_null(g_sfv[l_ac].sfv06) THEN LET g_sfv[l_ac].sfv06 = ' ' END IF   #MOD-B40113 add
   IF cl_null(g_sfv[l_ac].sfv07) THEN LET g_sfv[l_ac].sfv07 = ' ' END IF   #MOD-B40113 add

   SELECT img09,img10 INTO g_img09,g_img10 FROM img_file
    WHERE img01=g_sfv[l_ac].sfv04 AND img02=g_sfv[l_ac].sfv05
      AND img03=g_sfv[l_ac].sfv06 AND img04=g_sfv[l_ac].sfv07
   IF STATUS = 100 THEN
      IF g_sma.sma892[3,3] = 'Y' THEN
         IF NOT cl_confirm('mfg1401') THEN 
            RETURN FALSE
         END IF
      END IF
      CALL s_add_img(g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv05,
                     g_sfv[l_ac].sfv06,g_sfv[l_ac].sfv07,
                     g_sfu.sfu01,      g_sfv[l_ac].sfv03,
                     g_today)
      IF g_errno='N' THEN 
         RETURN FALSE
      END IF
      SELECT img09,img10 INTO g_img09,g_img10 FROM img_file
       WHERE img01=g_sfv[l_ac].sfv04 AND img02=g_sfv[l_ac].sfv05
         AND img03=g_sfv[l_ac].sfv06 AND img04=g_sfv[l_ac].sfv07
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t620_add_imgg(p_imgg09,p_factor)
   DEFINE l_cnt        LIKE type_file.num5 
   DEFINE p_imgg09     LIKE imgg_file.imgg09 
   DEFINE p_factor     LIKE imgg_file.imgg20 

   IF cl_null(g_sfv[l_ac].sfv06) THEN LET g_sfv[l_ac].sfv06 = ' ' END IF   #MOD-B40113 add
   IF cl_null(g_sfv[l_ac].sfv07) THEN LET g_sfv[l_ac].sfv07 = ' ' END IF   #MOD-B40113 add

   SELECT COUNT(*) INTO l_cnt FROM imgg_file
    WHERE imgg01=g_sfv[l_ac].sfv04 AND imgg02=g_sfv[l_ac].sfv05
      AND imgg03=g_sfv[l_ac].sfv06 AND imgg04=g_sfv[l_ac].sfv07
      AND imgg09=p_imgg09

   IF cl_null(l_cnt) OR l_cnt <= 0 THEN
      IF g_sma.sma892[3,3] = 'Y' THEN
         IF NOT cl_confirm('aim-995') THEN 
            RETURN FALSE
         END IF
      END IF
      CALL s_add_imgg(g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv05,
                      g_sfv[l_ac].sfv06,g_sfv[l_ac].sfv07,
                      p_imgg09,p_factor,
                      g_sfu.sfu01,
                      g_sfv[l_ac].sfv03,0) RETURNING g_flag
      IF g_flag = 1 THEN
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t620_sfv11(p_cmd)
DEFINE p_cmd LIKE type_file.chr1,
    l_ecu04          LIKE ecu_file.ecu04,
    l_ecu05          LIKE ecu_file.ecu05,
    l_msg            LIKE type_file.chr1000,   #No:MOD-6A0009 add
    l_sfv09_o        LIKE sfv_file.sfv09,      #No:MOD-6C0081 add
    l_over_qty       LIKE sfv_file.sfv09,      #No:MOD-950192 add
    l_sfb02          LIKE sfb_file.sfb02,      #FUN-660110 add
    l_qcf091         LIKE qcf_file.qcf091,
    l_bmm03_cnt      LIKE type_file.num10,
    l_n              LIKE type_file.num10,
    l_date           LIKE type_file.dat 
   DEFINE  l_ima153     LIKE ima_file.ima153   #FUN-910053 
   DEFINE l_slip    LIKE smy_file.smyslip      #No.FUN-950021
   DEFINE l_cnt     LIKE type_file.num5        #No.FUN-950021
   DEFINE l_ecm012  LIKE ecm_file.ecm012  #FUN-A50066
   DEFINE l_ecm03   LIKE ecm_file.ecm03   #FUN-A50066
   DEFINE l_sfb08   LIKE sfb_file.sfb08   #MOD-D30197

   ##組合拆解的工單不得選用!
   IF NOT cl_null(g_sfv[l_ac].sfv11) THEN

      LET l_slip = s_get_doc_no(g_sfv[l_ac].sfv11)
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM smy_file
       WHERE smy69 = l_slip          #No.FUN-950021
      IF l_cnt > 0 THEN
         CALL cl_err(g_sfv[l_ac].sfv11,'asf-873',1)  #組合拆解對應的工單,不得使用!
         RETURN FALSE
      END IF
   END IF 

   IF cl_null(g_sfv[l_ac].sfv11) THEN
      INITIALIZE g_sfb.* TO NULL
   END IF
   IF (NOT cl_null(g_sfv[l_ac].sfv11)) AND (g_argv<>'3')  THEN                          #MOD-C70307 add THEN
      #AND (g_sfv[l_ac].sfv11 != g_sfv_t.sfv11 OR g_sfv_t.sfv11 IS NULL)THEN            #MOD-C70307 mark
      SELECT sfb02 INTO l_sfb02 FROM sfb_file
       WHERE sfb01=g_sfv[l_ac].sfv11
      IF l_sfb02 = '15' THEN
         CALL cl_err(g_sfv[l_ac].sfv11,'asr-047',1)   #所輸入之工單型態不可為試產工單,請重新輸入!
         RETURN FALSE
      END IF

      CALL t620_sfb01(l_ac,p_cmd)
      CALL s_get_ima153(g_sfv[l_ac].sfv04) RETURNING l_ima153     #MOD-970244 add
      IF g_err = 'Y' THEN
         RETURN FALSE
      END IF
    #---->聯產品 NO:6872
      LET g_cnt = 0
      IF NOT cl_null(g_sfv[l_ac].sfv17) AND g_sma.sma104 = 'Y' THEN #sma104是否使用聯產
         SELECT qcf_file.*,ima_file.* INTO g_qcf.*,g_ima.*
           FROM qcf_file,ima_file
          WHERE qcf01 = g_sfv[l_ac].sfv17 #FQC單號
            AND qcf021= ima01
         IF g_sma.sma104 = 'Y' AND g_sma.sma105 = '1' THEN #認定聯產品的時機點為:1.FQC
             SELECT COUNT(*) INTO g_cnt
               FROM qde_file
              WHERE qde01 = g_sfv[l_ac].sfv17
                AND qde02 = g_sfv[l_ac].sfv11
             IF g_cnt >= 1 THEN
                 LET l_FQC = 'Y'
                 LET g_sfv[l_ac].sfv16='Y' #MOD-590260
                 DISPLAY BY NAME g_sfv[l_ac].sfv16 #MOD-590260
             END IF
         END IF
      END IF

      LET l_bmm03_cnt = 0
      IF NOT cl_null(g_sfv[l_ac].sfv11)
         AND NOT cl_null(g_sfv[l_ac].sfv04)
         AND g_sma.sma104 = 'Y'
         AND g_sma.sma105 = '2'THEN #避免修改時,原本已入聯產品,結果又被蓋掉
         SELECT ima_file.* INTO g_ima.* FROM ima_file,sfb_file
          WHERE ima01 = sfb05
            AND sfb01 = g_sfv[l_ac].sfv11
         SELECT COUNT(*) INTO l_bmm03_cnt FROM bmm_file
          WHERE bmm03 = g_sfv[l_ac].sfv04   #聯產品
            AND bmm01 = g_ima.ima01         #主件
      END IF

      IF g_cnt = 0 AND l_bmm03_cnt = 0 THEN
         IF p_cmd='u' THEN
            LET l_sfv09_o = g_sfv[l_ac].sfv09 
         END IF 
         #程式原走法
         IF g_argv = '1' THEN
             CALL t620_sfb01(l_ac,p_cmd) #MOD-480206 modify
              IF g_err = 'Y' THEN
                 RETURN FALSE
              END IF

            IF cl_null(g_sfb.sfb01) THEN
               LET g_sfv[l_ac].sfv11=g_sfv_t.sfv11
                DISPLAY BY NAME g_sfv[l_ac].sfv11 #MOD-4A0260
                RETURN FALSE
            END IF
            #檢查ima906的設定和sma115是否一致
            IF g_sma.sma115 ='Y' THEN
               CALL s_chk_va_setting(g_sfv[l_ac].sfv04)
                    RETURNING g_flag,g_ima906,g_ima907
               SELECT ima55 INTO g_ima55
                 FROM ima_file WHERE ima01=g_sfv[l_ac].sfv04
               IF g_flag=1 THEN
                  RETURN FALSE
               END IF
               IF g_ima906 = '3' THEN
                  LET g_sfv[l_ac].sfv33=g_ima907
               END IF
               CALL t620_set_no_entry_b('s')     #No:MOD-790122 modify
               CALL t620_set_no_required_b()
            END IF

            IF g_sfb.sfb94='Y' AND
               cl_null(g_sfv[l_ac].sfv17)  THEN   #No:TQC-5B0075 modify
               CALL cl_err(g_sfb.sfb01,'asf-680',1)
               RETURN FALSE
            END IF

            IF g_sfb.sfb94='Y' AND (NOT cl_null(g_sfv[l_ac].sfv17)) THEN
               SELECT COUNT(*) INTO l_n FROM qcf_file
                WHERE qcf00='1' AND qcf01=g_sfv[l_ac].sfv17
                  AND qcf02=g_sfb.sfb01 AND qcf14 <> 'X'
               IF l_n=0 THEN
                  CALL cl_err(g_sfb.sfb01,'asf-825',1) #bugno:6501
                  RETURN FALSE
               END IF
            END IF

             DECLARE t620_zaa_cur1 CURSOR FOR
              SELECT zaa02,zaa08 FROM zaa_file
               WHERE zaa01 = "asft620"
                 AND zaa03 = g_rlang
                 AND zaa04 = "default"
                 AND zaa11 = "voucher"
                 AND zaa10 = 'N'
             FOREACH t620_zaa_cur1 INTO l_i,l_zaa08
                LET g_x[l_i] = l_zaa08
             END FOREACH
             #TQC-D10099 add begin---
            #CALL cl_getmsg('asf1037',g_lang) RETURNING g_x[1]  #MOD-D60129 mark
             CALL cl_getmsg('asf1042',g_lang) RETURNING g_x[1]  #MOD-D60129 add
             CALL cl_getmsg('asf1038',g_lang) RETURNING g_x[2]
             CALL cl_getmsg('asf1039',g_lang) RETURNING g_x[3]
             CALL cl_getmsg('asf1040',g_lang) RETURNING g_x[4]
             CALL cl_getmsg('asf1041',g_lang) RETURNING g_x[5]
             #TQC-D10099 add end-----
            IF g_sfb.sfb39 != '2' THEN
               #檢查工單最小發料日是否小於入庫日
               SELECT MIN(sfp03) INTO l_date FROM sfe_file,sfp_file  #CHI-910024
                #WHERE sfe01 = g_sfv[l_ac].sfv11 AND sfe02 = sfp01                      #MOD-B80014 mark
                WHERE sfe01 = g_sfv[l_ac].sfv11 AND sfe02 = sfp01 AND sfp04 = 'Y'       #MOD-B80014 add
               IF STATUS OR cl_null(l_date) THEN
                  SELECT MIN(sfp03) INTO l_date FROM sfs_file,sfp_file #CHI-910024
                   #WHERE sfs03=g_sfv[l_ac].sfv11 AND sfp01=sfs01                       #MOD-B80014 mark
                   WHERE sfs03=g_sfv[l_ac].sfv11 AND sfp01=sfs01 AND sfp04 = 'Y'        #MOD-B80014 add
               END IF
               IF cl_null(l_date) OR l_date > g_sfu.sfu02 THEN
                  CALL cl_err('sel_sfp02','asf-824',1)
                  RETURN FALSE
               END IF
          #FUN-D60054 -----------Begin-----------
            ELSE
               SELECT sfb81 INTO l_date FROM sfb_file WHERE sfb01 = g_sfv[l_ac].sfv11
               IF cl_null(l_date) OR l_date > g_sfu.sfu02 THEN
                  CALL cl_err(g_sfv[l_ac].sfv11,'asf-342',1)
                  RETURN FALSE
               END IF
            END IF
          #FUN-D60054 -----------End-------------
          #MOD-B90107---add---start---
            LET tmp_qty = 0
            # sum(已存在入庫單入庫數量) by W/O (不管有無過帳)
            SELECT SUM(sfv09) INTO tmp_qty FROM sfv_file,sfu_file
             WHERE sfv11 = g_sfv[l_ac].sfv11
               AND sfv01 = sfu01
               AND sfu00 = '1'   #類別 1.入庫  2.入庫退回
               AND sfuconf <> 'X'

            IF tmp_qty IS NULL OR SQLCA.sqlcode THEN LET tmp_qty=0 END IF
            IF g_sfb.sfb93!='Y' THEN
          #MOD-B90107---add---end---
                 #工單完工方式為'2' pull 不check min_set
                 #最小套=min_set
               LET g_min_set = 0

               IF g_sfb.sfb39!='2' THEN     #FUN-D60054
                  #default 時不考慮超限率sma74
               #  CALL s_minp(g_sfv[l_ac].sfv11,g_sma.sma73,0,'','','')   #FUN-A60027  #FUN-C70037 mark
                  CALL s_minp(g_sfv[l_ac].sfv11,g_sma.sma73,0,'','','',g_sfu.sfu02)    #FUN-C70037
                       RETURNING g_cnt,g_min_set

                  IF g_cnt !=0  THEN
                     CALL cl_err('s_minp()','asf-549',0)
                     RETURN FALSE
                  END IF

              # sma73 工單完工數量是否檢查發料最小套數
              # sma74 工單完工量容許差異百分比

                  IF g_sma.sma73='Y' THEN  #
                  #  CALL s_minp(g_sfv[l_ac].sfv11,g_sma.sma73,l_ima153,'','','')   #FUN-A60027 #FUN-C70037 mark
                     CALL s_minp(g_sfv[l_ac].sfv11,g_sma.sma73,l_ima153,'','','',g_sfu.sfu02)   #FUN-C70037
                          RETURNING g_cnt,l_over_qty
 
                     IF cl_null(l_over_qty) THEN LET l_over_qty = 0 END IF
                     LET g_over_qty = l_over_qty - g_min_set
                  ELSE
                     #MOD-D30197---begin
                     #LET g_over_qty=0  
                     SELECT sfb08 INTO l_sfb08 FROM sfb_file WHERE sfb01 = g_sfv[l_ac].sfv11
                     LET g_over_qty= l_sfb08 * l_ima153/100
                     #MOD-D30197---end
                  END IF

              #TQC-D60054 ---------Begin--------
               ELSE
                  SELECT sfb08 INTO l_sfb08 FROM sfb_file WHERE sfb01 = g_sfv[l_ac].sfv11
                  #最小發料套數
                  LET g_min_set = l_sfb08 
                  #完工入庫允許誤差率
                  LET g_over_qty= l_sfb08 * l_ima153/100
               END IF
              #TQC-D60054 ---------End----------
               IF g_over_qty IS NULL THEN LET g_over_qty=0 END IF  #No:MOD-5A0444 add

                #MOD-B90107---mark---start---
                ## sum(已存在入庫單入庫數量) by W/O (不管有無過帳)
                #SELECT SUM(sfv09) INTO tmp_qty FROM sfv_file,sfu_file
                # WHERE sfv11 = g_sfv[l_ac].sfv11
                #   AND sfv01 = sfu01
                #   AND sfu00 = '1'   #類別 1.入庫  2.入庫退回
                #   AND sfuconf <> 'X' #FUN-660137
                #IF tmp_qty IS NULL OR SQLCA.sqlcode THEN LET tmp_qty=0 END IF
                #MOD-B90107---mark----end----
                IF g_sfv_t.sfv09 > 0 AND
                   g_sfv_t.sfv11=g_sfv[l_ac].sfv11 THEN
                   LET tmp_qty=tmp_qty - g_sfv_t.sfv09
                END IF

                IF (p_cmd='a') OR
                   (cl_null(g_sfv[l_ac].sfv09)) OR
                   (g_sfv[l_ac].sfv09=0) OR
                   (p_cmd='u' AND g_sfv[l_ac].sfv11<>g_sfv_t.sfv11) THEN #MOD-740151
                   LET g_sfv[l_ac].sfv09=g_min_set - tmp_qty
                  #MOD-B40243 --- modify --- start ---
                   #IF g_sfv[l_ac].sfv09 <= 0 THEN  #MOD-D10050
                   IF g_sfv[l_ac].sfv09 + g_over_qty <= 0 THEN  #MOD-D10050
                      CALL cl_err(g_sfv[l_ac].sfv11,'asf-675',0)
                      RETURN FALSE
                   END IF
                  #MOD-B40243 --- modify ---  end ---
                   IF g_sfv[l_ac].sfv09 < 0 THEN LET g_sfv[l_ac].sfv09 = 0 END IF  #MOD-D10050
                END IF   #CHI-6C0004

                LET g_min_set=g_min_set + g_over_qty

                LET l_msg = cl_getmsg('asf-205',g_lang)
                LET g_msg = l_msg CLIPPED,g_min_set USING '############.###'  #最小套數   #No:MOD-770048 modify #No:MOD-970035 modify
                CASE WHEN g_sma.sma73='Y' AND l_ima153>0      #FUN-910053
                          LET g_msg=g_msg CLIPPED,'(',l_ima153 USING '+++','%)'     #FUN-910053
                     WHEN g_sma.sma73='Y' AND l_ima153<0  #FUN-910053
                          LET g_msg=g_msg CLIPPED,'(',l_ima153 USING '---','%)'     #FUN-910053
                END CASE
                LET l_msg = cl_getmsg('asf-206',g_lang)
                LET g_msg = g_msg CLIPPED,l_msg CLIPPED,
                            tmp_qty USING  '############.###'     #No:MOD-770048 modify     #No:MOD-970035 modify
                LET l_msg = cl_getmsg('asf-207',g_lang)
                LET g_msg = g_msg CLIPPED,l_msg CLIPPED,
                             (g_sfv[l_ac].sfv09 + g_over_qty) USING '############.###'  #可入庫量    #No:MOD-770048 modify  #MOD-8A0114 modify ----  #No:MOD-970035 modify
                #MESSAGE g_msg  #FUN-840012
                CALL cl_msg(g_msg)  #FUN-840012
             ELSE                            #MOD-B90107 add
              #IF g_sfb.sfb93='Y' THEN # 製程否 modify by Raymon   #MOD-B90107 mark
                CALL s_schdat_max_ecm03(g_sfv[l_ac].sfv11) RETURNING l_ecm012,l_ecm03  #FUN-A50066
                # 取最終製程之總轉出量(良品轉出量+Bonus)
                SELECT ecm311,ecm315 INTO g_ecm311,g_ecm315 FROM ecm_file 
                WHERE ecm01=g_sfv[l_ac].sfv11
                 #AND ecm03= (SELECT MAX(ecm03) FROM ecm_file   #FUN-A50066
                 #             WHERE ecm01=g_sfv[l_ac].sfv11)   #FUN-A50066
                  AND ecm012= l_ecm012  #FUN-A50066
                  AND ecm03 = l_ecm03   #FUN-A50066

                IF STATUS THEN LET g_ecm311=0 END IF
                IF STATUS THEN LET g_ecm315=0 END IF

                LET g_ecm_out = g_ecm311 + g_ecm315 

                #IF ..END 若走製程應以製程轉出數為準,而非最小套數
                LET g_sfv[l_ac].sfv09=g_ecm_out - tmp_qty

                LET g_msg= g_x[1] CLIPPED,
                             g_min_set USING '############.###'  #最小套數     #No:MOD-770048 modify  #No:MOD-970035 modify

                CASE WHEN g_sma.sma73='Y' AND l_ima153>0
                          LET g_msg=g_msg CLIPPED,'(',l_ima153 USING '+++','%)'
                     WHEN g_sma.sma73='Y' AND l_ima153<0
                          LET g_msg=g_msg CLIPPED,'(',l_ima153 USING '---','%)'
                END CASE

                LET g_msg=g_msg CLIPPED,
                          g_x[4] CLIPPED,g_ecm_out USING '############.###',#終站總轉出量    #No:MOD-770048 modify #No:MOD-970035 modify 
                          g_x[2] CLIPPED,tmp_qty USING '############.###',  #已登打入庫量    #No:MOD-770048 modify #No:MOD-970035 modify 
                          g_x[3] CLIPPED,(g_sfv[l_ac].sfv09+g_over_qty)
                          USING '############.###' #可入庫量      #No:MOD-770048 modify   #No:MOD-970035 modify
                #MESSAGE g_msg  #FUN-840012
                CALL cl_msg(g_msg) #FUN-840012
             END IF


                 #是否使用FQC功能
             IF g_sfb.sfb94='Y' AND g_sma.sma896='Y' THEN
                # sum(已存在入庫單入庫數量) by W/O (不管有無過帳)
                SELECT SUM(sfv09) INTO tmp_qty FROM sfv_file,sfu_file
                 WHERE sfv17 = g_sfv[l_ac].sfv17
                   AND sfv01 = sfu01
                   AND sfu00 = '1'   #類別 1.入庫  2.入庫退回
                   AND sfuconf <> 'X' #FUN-660137

                IF tmp_qty IS NULL THEN LET tmp_qty=0 END IF
                IF g_sfv_t.sfv09 > 0 AND
                   g_sfv_t.sfv11=g_sfv[l_ac].sfv11 THEN
                   LET tmp_qty=tmp_qty - g_sfv_t.sfv09
                END IF

                SELECT qcf091 INTO l_qcf091 FROM qcf_file   # QC
                 WHERE qcf01 = g_sfv[l_ac].sfv17
                   AND qcf09 <> '2'   #accept #NO:6872
                   AND qcf14 = 'Y'
                IF STATUS OR l_qcf091 IS NULL THEN
                   LET l_qcf091 = 0
                END IF


                IF g_sma.sma54='Y' AND g_sfb.sfb93='Y' THEN
                  #TQC-D40089--mark--str---
                  #IF cl_null(g_ecm_out) THEN LET g_ecm_out=0 END IF
                  #IF g_min_set > g_ecm_out THEN
                  #   LET l_min_qty= g_ecm_out
                  #ELSE
                  #   LET l_min_qty= g_min_set
                  #END IF
                  #IF l_min_qty > l_qcf091 THEN
                  #TQC-D40089--mark--end---
                   LET g_sfv[l_ac].sfv09=l_qcf091-tmp_qty
                   DISPLAY BY NAME g_sfv[l_ac].sfv09 #MOD-4A0260
                  #END IF            #TQC-D40089 mark
                ELSE
                   IF g_min_set > l_qcf091 THEN
                      LET g_sfv[l_ac].sfv09=l_qcf091-tmp_qty
                       DISPLAY BY NAME g_sfv[l_ac].sfv09 #MOD-4A0260
                   END IF
                END IF

                LET g_msg= g_x[1] CLIPPED,
                           g_min_set USING '############.###'  #最小套數     #No:MOD-770048 modify    #No:MOD-970035 modify

                CASE WHEN g_sma.sma73='Y' AND l_ima153>0
                          LET g_msg=g_msg CLIPPED,'(',l_ima153 USING '+++','%)'
                     WHEN g_sma.sma73='Y' AND l_ima153<0
                          LET g_msg=g_msg CLIPPED,'(',l_ima153 USING '---','%)'
                END CASE

                LET g_msg=g_msg CLIPPED,
                          g_x[5] CLIPPED,l_qcf091 USING '############.###' ,  #FQC量          #No:MOD-770048 modify #No:MOD-970035 modify 
                          g_x[2] CLIPPED,tmp_qty USING '############.###',  #已登打入庫量    #No:MOD-770048 modify  #No:MOD-970035 modify
                          g_x[3] CLIPPED,(l_qcf091-tmp_qty)   #MOD-840552
                                          USING '############.###'  #可入庫量                 #No:MOD-770048 modify #No:MOD-970035 modify 
                #MESSAGE g_msg #FUN-840012
                CALL cl_msg(g_msg) 
             END IF
            #TQC-C70109--add--str--
          #FUN-D60054 ----------Begin---------
           #ELSE
           #   SELECT sfb81 INTO l_date FROM sfb_file WHERE sfb01 = g_sfv[l_ac].sfv11
           #   IF cl_null(l_date) OR l_date > g_sfu.sfu02 THEN
           #      CALL cl_err(g_sfv[l_ac].sfv11,'asf-342',1)
           #      RETURN FALSE
           #   END IF
           ##TQC-C70109--add--end--
           #END IF
          #FUN-D60054 ----------End-----------

         ELSE   #退庫
            CALL t620_sfb011(l_ac)
            # sum(已存在退庫單退庫數量) by W/O (不管有無過帳)
            SELECT SUM(sfv09) INTO tmp_qty FROM sfv_file,sfu_file
             WHERE sfv11 = g_sfv[l_ac].sfv11
               AND sfv01 = sfu01
               AND sfu00 = '2'   #類別 1.入庫  2.入庫退回
               AND sfuconf <> 'X' #FUN-660137
            IF tmp_qty IS NULL THEN LET tmp_qty=0 END IF
            LET g_sfv[l_ac].sfv09= g_sfb.sfb09 - tmp_qty
             DISPLAY BY NAME g_sfv[l_ac].sfv09 #MOD-4A0260
            #檢查ima906的設定和sma115是否一致
            IF g_sma.sma115 ='Y' THEN
               CALL s_chk_va_setting(g_sfv[l_ac].sfv04)
                    RETURNING g_flag,g_ima906,g_ima907
               IF g_flag=1 THEN
                  RETURN FALSE
               END IF
               IF g_ima906 = '3' THEN
                  LET g_sfv[l_ac].sfv33=g_ima907
               END IF
               IF g_sfv_t.sfv11 != g_sfv[l_ac].sfv11 THEN
                  CALL t620_set_du_by_origin()
               END IF
               CALL t620_set_no_entry_b('s')     #No:MOD-790122 modify
               CALL t620_set_no_required_b()
            END IF
         END IF

          IF p_cmd='u' THEN
             LET g_sfv[l_ac].sfv09 = l_sfv09_o
             DISPLAY BY NAME g_sfv[l_ac].sfv09
          END IF 

         IF NOT cl_null(g_errno) THEN
            CALL cl_err(g_sfv[l_ac].sfv11,g_errno,0)
            RETURN FALSE
         END IF

         SELECT ima571 INTO g_ima571 FROM ima_file
          WHERE ima01=g_sfb.sfb05
         IF g_ima571 IS NULL THEN LET g_ima571=' ' END IF

         LET l_ecu04=0 LET l_ecu05=0

         IF g_sfb.sfb93 = 'Y'THEN  #製程否
            SELECT ecu04,ecu05 INTO l_ecu04,l_ecu05 FROM ecu_file
             WHERE ecu01=g_ima571 AND ecu02=g_sfb.sfb06
            IF g_argv MATCHES '[0]' AND l_ecu04=l_ecu05 THEN
               CALL cl_err('','asf-702',0) 
               RETURN FALSE
            END IF
         END IF
         #---->聯產品 NO:6872
         SELECT * INTO g_ima.* FROM ima_file
           WHERE ima01 = (SELECT sfb05 FROM sfb_file
                           WHERE sfb01 = g_sfv[l_ac].sfv11)
         IF g_sma.sma104 = 'Y' AND g_sma.sma105 = '2' AND g_ima.ima903 = 'Y' THEN #認定聯產品的時機點為:2.完工入庫
             SELECT COUNT(*) INTO g_cnt FROM bmm_file
              WHERE bmm01 = g_ima.ima01
             IF g_cnt >= 1 THEN
                 LET g_sfv[l_ac].sfv16 = 'Y'
                  DISPLAY BY NAME g_sfv[l_ac].sfv16 #MOD-4A0260
             ELSE
                  CALL t620_set_no_entry_b('u') #MOD-510135
             END IF
         ELSE
              CALL t620_set_no_entry_b('u') #MOD-510135
         END IF
      ELSE
         #---->聯產品 NO:6872
         LET g_sfv[l_ac].sfv16 = 'Y'
          DISPLAY BY NAME g_sfv[l_ac].sfv16 #MOD-4A0260
      END IF
      
   END IF
      IF g_sfb.sfb94='Y' AND
         cl_null(g_sfv[l_ac].sfv17)  THEN   #No:TQC-5B0075 modify
         CALL cl_err(g_sfb.sfb01,'asf-680',1)
         RETURN FALSE
      END IF

      IF g_sfb.sfb94='Y' AND (NOT cl_null(g_sfv[l_ac].sfv17)) THEN
         SELECT COUNT(*) INTO l_n FROM qcf_file
          WHERE qcf00='1' AND qcf01=g_sfv[l_ac].sfv17
            AND qcf02=g_sfb.sfb01 AND qcf14 <> 'X'
         IF l_n=0 THEN
            CALL cl_err(g_sfb.sfb01,'asf-825',1) #bugno:6501
            RETURN FALSE
         END IF
      END IF
   DISPLAY BY NAME g_sfv[l_ac].sfv09  #mandy test
   DISPLAY BY NAME g_sfv[l_ac].sfv11  #mandy test
   DISPLAY BY NAME g_sfv[l_ac].sfv16  #mandy test

   CALL t620_set_no_entry_b('u') #MOD-510135
   CALL t620_set_no_required_b()   #FUN-540055
  #IF由工單帶入，則不可修改sfv41-43
   IF NOT cl_null(g_sfv[l_ac].sfv11) THEN
      CALL cl_set_comp_entry("sfv41,sfv42,sfv43,sfv44",FALSE)
      IF g_aza.aza115 = 'Y' THEN CALL cl_set_comp_entry("sfv44",TRUE) END IF  #FUN-CB0087
   ELSE
      CALL cl_set_comp_entry("sfv41,sfv42,sfv43,sfv44",TRUE)
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t620_b_move_to()
   LET g_sfv[l_ac].sfv03  = b_sfv.sfv03 
   LET g_sfv[l_ac].sfv17  = b_sfv.sfv17 
   LET g_sfv[l_ac].sfv14  = b_sfv.sfv14 
   LET g_sfv[l_ac].sfv11  = b_sfv.sfv11
   #FUN-BC0104---add---str---
   LET g_sfv[l_ac].sfv46  = b_sfv.sfv46
   LET g_sfv[l_ac].sfv47  = b_sfv.sfv47
   #FUN-BC0104---add---end---
   LET g_sfv[l_ac].sfv04  = b_sfv.sfv04 
   LET g_sfv[l_ac].sfv08  = b_sfv.sfv08 
   LET g_sfv[l_ac].sfv05  = b_sfv.sfv05 
   LET g_sfv[l_ac].sfv06  = b_sfv.sfv06 
   LET g_sfv[l_ac].sfv07  = b_sfv.sfv07 
   LET g_sfv[l_ac].sfv09  = b_sfv.sfv09 
   LET g_sfv[l_ac].sfv33  = b_sfv.sfv33 
   LET g_sfv[l_ac].sfv34  = b_sfv.sfv34 
   LET g_sfv[l_ac].sfv35  = b_sfv.sfv35 
   LET g_sfv[l_ac].sfv30  = b_sfv.sfv30 
   LET g_sfv[l_ac].sfv31  = b_sfv.sfv31 
   LET g_sfv[l_ac].sfv32  = b_sfv.sfv32 
   LET g_sfv[l_ac].sfv12  = b_sfv.sfv12 
   LET g_sfv[l_ac].sfv16  = b_sfv.sfv16 
   LET g_sfv[l_ac].sfv930 = b_sfv.sfv930
   LET g_sfv[l_ac].sfvud01 = b_sfv.sfvud01
   LET g_sfv[l_ac].sfvud02 = b_sfv.sfvud02
   LET g_sfv[l_ac].sfvud03 = b_sfv.sfvud03
   LET g_sfv[l_ac].sfvud04 = b_sfv.sfvud04
   LET g_sfv[l_ac].sfvud05 = b_sfv.sfvud05
   LET g_sfv[l_ac].sfvud06 = b_sfv.sfvud06
   LET g_sfv[l_ac].sfvud07 = b_sfv.sfvud07
   LET g_sfv[l_ac].sfvud08 = b_sfv.sfvud08
   LET g_sfv[l_ac].sfvud09 = b_sfv.sfvud09
   LET g_sfv[l_ac].sfvud10 = b_sfv.sfvud10
   LET g_sfv[l_ac].sfvud11 = b_sfv.sfvud11
   LET g_sfv[l_ac].sfvud12 = b_sfv.sfvud12
   LET g_sfv[l_ac].sfvud13 = b_sfv.sfvud13
   LET g_sfv[l_ac].sfvud14 = b_sfv.sfvud14
   LET g_sfv[l_ac].sfvud15 = b_sfv.sfvud15
END FUNCTION

FUNCTION t620_b_move_back()
   LET b_sfv.sfv01 = g_sfu.sfu01 #Key 值
   
   LET b_sfv.sfv03 = g_sfv[l_ac].sfv03 
   LET b_sfv.sfv17 = g_sfv[l_ac].sfv17 
   LET b_sfv.sfv14 = g_sfv[l_ac].sfv14 
   LET b_sfv.sfv11 = g_sfv[l_ac].sfv11 
   #FUN-BC0104---add---str---
   LET b_sfv.sfv46 = g_sfv[l_ac].sfv46
   LET b_sfv.sfv47 = g_sfv[l_ac].sfv47
   #FUN-BC0104---add---end---
   LET b_sfv.sfv04 = g_sfv[l_ac].sfv04 
   LET b_sfv.sfv08 = g_sfv[l_ac].sfv08 
   LET b_sfv.sfv05 = g_sfv[l_ac].sfv05 
   LET b_sfv.sfv06 = g_sfv[l_ac].sfv06 
   LET b_sfv.sfv07 = g_sfv[l_ac].sfv07 
   LET b_sfv.sfv09 = g_sfv[l_ac].sfv09 
   LET b_sfv.sfv33 = g_sfv[l_ac].sfv33 
   LET b_sfv.sfv34 = g_sfv[l_ac].sfv34 
   LET b_sfv.sfv35 = g_sfv[l_ac].sfv35 
   LET b_sfv.sfv30 = g_sfv[l_ac].sfv30 
   LET b_sfv.sfv31 = g_sfv[l_ac].sfv31 
   LET b_sfv.sfv32 = g_sfv[l_ac].sfv32 
   LET b_sfv.sfv41 = g_sfv[l_ac].sfv41
   LET b_sfv.sfv42 = g_sfv[l_ac].sfv42
   LET b_sfv.sfv43 = g_sfv[l_ac].sfv43
   LET b_sfv.sfv44 = g_sfv[l_ac].sfv44
   LET b_sfv.sfv12 = g_sfv[l_ac].sfv12 
   LET b_sfv.sfv16 = g_sfv[l_ac].sfv16 
   LET b_sfv.sfv930= g_sfv[l_ac].sfv930
   LET b_sfv.sfvud01 = g_sfv[l_ac].sfvud01
   LET b_sfv.sfvud02 = g_sfv[l_ac].sfvud02
   LET b_sfv.sfvud03 = g_sfv[l_ac].sfvud03
   LET b_sfv.sfvud04 = g_sfv[l_ac].sfvud04
   LET b_sfv.sfvud05 = g_sfv[l_ac].sfvud05
   LET b_sfv.sfvud06 = g_sfv[l_ac].sfvud06
   LET b_sfv.sfvud07 = g_sfv[l_ac].sfvud07
   LET b_sfv.sfvud08 = g_sfv[l_ac].sfvud08
   LET b_sfv.sfvud09 = g_sfv[l_ac].sfvud09
   LET b_sfv.sfvud10 = g_sfv[l_ac].sfvud10
   LET b_sfv.sfvud11 = g_sfv[l_ac].sfvud11
   LET b_sfv.sfvud12 = g_sfv[l_ac].sfvud12
   LET b_sfv.sfvud13 = g_sfv[l_ac].sfvud13
   LET b_sfv.sfvud14 = g_sfv[l_ac].sfvud14
   LET b_sfv.sfvud15 = g_sfv[l_ac].sfvud15

   LET b_sfv.sfvplant = g_plant #FUN-980008 add
   LET b_sfv.sfvlegal = g_legal #FUN-980008 add
END FUNCTION

FUNCTION t620_rvbs(l_sfv03,l_sfv04,l_sfv08,l_sfv09,l_sfv41)
  DEFINE l_sfv03        LIKE sfv_file.sfv03,
         l_sfv04        LIKE sfv_file.sfv04,
         l_sfv08        LIKE sfv_file.sfv08,
         l_sfv09        LIKE sfv_file.sfv09,
         l_sfv41        LIKE sfv_file.sfv41

  DEFINE b_rvbs  RECORD  LIKE rvbs_file.*
  DEFINE l_ima25         LIKE ima_file.ima25,
         l_imafac        LIKE img_file.img21
  DEFINE l_msg           STRING #FUN-980043     
 

 #抓取庫存單位換算率，寫到rvbs_file一律以庫存單位計量
  SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01= l_sfv04
  IF l_sfv08=l_ima25 THEN
     LET l_imafac = 1
  ELSE
     CALL s_umfchk(l_sfv04,l_sfv08,l_ima25)
          RETURNING g_cnt,l_imafac
  END IF
  IF cl_null(l_imafac) OR l_imafac=0  THEN
    #### ----庫存/料號無法轉換 -------###
    LET l_msg=l_sfv03,'',l_sfv04,'','sfv08/ima25: ' #FUN-980043                                                                     
    CALL cl_err(l_msg,'abm-731',1)       #FUN-980043         
    LET g_success ='N'
    RETURN
  END IF
  
  LET b_rvbs.rvbs00 = g_prog
  LET b_rvbs.rvbs01 = g_sfu.sfu01
  LET b_rvbs.rvbs02 = l_sfv03
  LET b_rvbs.rvbs021= l_sfv04
  LET b_rvbs.rvbs06 = l_sfv09 * l_imafac  #數量*庫存單位換算率
  LET b_sfv.sfv34  = g_sfv[l_ac].sfv34
  LET b_sfv.sfv35  = g_sfv[l_ac].sfv35
  DISPLAY BY NAME g_sfv[l_ac].sfv34, g_sfv[l_ac].sfv35
END FUNCTION
FUNCTION t620_chk_ima64(p_part, p_qty)
  DEFINE p_part		LIKE ima_file.ima01
  DEFINE p_qty		LIKE ima_file.ima641   
  DEFINE l_ima108	LIKE ima_file.ima108
  DEFINE l_ima64	LIKE ima_file.ima64
  DEFINE l_ima641	LIKE ima_file.ima641
  DEFINE i		LIKE type_file.num10  

  SELECT ima108,ima64,ima641 INTO l_ima108,l_ima64,l_ima641 FROM ima_file
   WHERE ima01=p_part
  IF STATUS THEN RETURN p_qty END IF

  IF l_ima108='Y' THEN RETURN p_qty END IF

  IF l_ima641 != 0 AND p_qty<l_ima641 THEN
     LET p_qty=l_ima641
  END IF

  IF l_ima64<>0 THEN
     LET i=p_qty / l_ima64 + 0.999999
     LET p_qty= i * l_ima64
  END IF
  RETURN p_qty

END FUNCTION
FUNCTION t620_sfu01(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1
   DEFINE l_slip    LIKE smy_file.smyslip
   DEFINE l_smy73   LIKE smy_file.smy73    #FUN-9B0144
 
   LET g_errno = ' '
   IF cl_null(g_sfu.sfu01) THEN RETURN END IF
   LET l_slip = s_get_doc_no(g_sfu.sfu01)
 
   SELECT smy73 INTO l_smy73 FROM smy_file
    WHERE smyslip = l_slip
   IF l_smy73 = 'Y' THEN
      LET g_errno = 'asf-876'
   END IF

END FUNCTION
# No.FUN-9C0073 -----------------By chenls  10/01/08

#若完工入庫量 > 最終站轉出量,且設定自動開立移轉單,且最終站可自動報工,則回傳TRUE,否則回傳FALSE
FUNCTION t620_chk_auto_report(p_sfv11,p_sfv09)
   DEFINE l_ecm012       LIKE ecm_file.ecm012
   DEFINE l_ecm03        LIKE ecm_file.ecm03
   DEFINE l_min_ecm012   LIKE ecm_file.ecm012
   DEFINE l_min_ecm03    LIKE ecm_file.ecm03
   DEFINE l_min_tran_out LIKE ecm_file.ecm311
   DEFINE p_sfv11        LIKE sfv_file.sfv11
   DEFINE p_sfv09        LIKE sfv_file.sfv09
   DEFINE l_ecm311       LIKE ecm_file.ecm311  #MOD-D10146
   DEFINE l_ecm312       LIKE ecm_file.ecm312  #MOD-D10146
   DEFINE l_ecm313       LIKE ecm_file.ecm313  #MOD-D10146
   DEFINE l_ecm314       LIKE ecm_file.ecm314  #MOD-D10146
   DEFINE l_ecm316       LIKE ecm_file.ecm316  #MOD-D10146
   
   IF g_sma.sma1434 ='Y' THEN      
      #step.1:先檢查最終站是否有足夠的量可自動報工
      CALL s_schdat_max_ecm03(p_sfv11) RETURNING l_ecm012,l_ecm03
      CALL t700sub_check_auto_report(p_sfv11,' ',l_ecm012,l_ecm03)
         RETURNING l_min_ecm012,l_min_ecm03,l_min_tran_out
      #MOD-D10146---begin
      SELECT ecm311,ecm312,ecm313,ecm314,ecm316
       INTO l_ecm311,l_ecm312,l_ecm313,l_ecm314,l_ecm316
       FROM ecm_file
      WHERE ecm01 = p_sfv11 AND ecm012 = l_ecm012 AND ecm03 = l_ecm03
      IF cl_null(l_ecm311) THEN LET l_ecm311 = 0 END IF 
      IF cl_null(l_ecm312) THEN LET l_ecm312 = 0 END IF 
      IF cl_null(l_ecm313) THEN LET l_ecm313 = 0 END IF 
      IF cl_null(l_ecm314) THEN LET l_ecm314 = 0 END IF 
      IF cl_null(l_ecm316) THEN LET l_ecm316 = 0 END IF 
      LET l_min_tran_out = l_min_tran_out - l_ecm311 - l_ecm312 - l_ecm313 - l_ecm314 - l_ecm316
      #MOD-D10146---end  
      IF l_min_tran_out > = p_sfv09 THEN
         RETURN TRUE
      ELSE
         RETURN FALSE
      END IF
   ELSE
      RETURN FALSE
   END IF 
END FUNCTION

#&ifdef ICD       #FUN-B50096
#FUN-A40022--begin--add----
FUNCTION t620_set_required_1(p_cmd)
#DEFINE l_imaicd13 LIKE imaicd_file.imaicd13   #FUN-B50096
DEFINE l_ima159   LIKE ima_file.ima159         #FUN-B50096
DEFINE p_cmd      LIKE type_file.chr1

   IF p_cmd='u' OR INFIELD(sfv04) THEN 
      IF NOT cl_null(g_sfv[l_ac].sfv04) THEN
#FUN-B50096 -------------------Begin---------------------
   #     SELECT imaicd13 INTO l_imaicd13 FROM imaicd_file
   #      WHERE imaicd00 = g_sfv[l_ac].sfv04
   #     IF l_imaicd13 = 'Y' THEN
         SELECT ima159 INTO l_ima159 FROM ima_file
          WHERE ima01 = g_sfv[l_ac].sfv04
         IF l_ima159 = '1' THEN
#FUN-B50096 -------------------End-----------------------
            CALL cl_set_comp_required("sfv07",TRUE)
         END IF
      END IF
   END IF
END FUNCTION

FUNCTION t620_set_no_required_1()
     CALL cl_set_comp_required("sfv07",FALSE)
END FUNCTION
#FUN-A40022--end--add--------

#FUN-B50096 ----------------Begin------------------
FUNCTION t620_set_entry_sfv07()
   CALL cl_set_comp_entry("sfv07",TRUE)
END FUNCTION

FUNCTION t620_set_no_entry_sfv07()
DEFINE l_ima159   LIKE ima_file.ima159
   IF l_ac > 0 THEN
      IF NOT cl_null(g_sfv[l_ac].sfv04) THEN
         SELECT ima159 INTO l_ima159 FROM ima_file
          WHERE ima01 = g_sfv[l_ac].sfv04 
         IF l_ima159 = '2' THEN
            CALL cl_set_comp_entry("sfv07",FALSE)
         ELSE 
            CALL cl_set_comp_entry("sfv07",TRUE)
         END IF
      END IF
   END IF
END FUNCTION
#FUN-B50096 ----------------End--------------------


#FUN-A80128---add----str---
FUNCTION t620_ef()

     CALL t620sub_y_chk(g_argv,g_sfu.sfu01,g_action_choice)  #CHI-C30118 add g_action_choice   
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

   IF aws_efcli2(base.TypeInfo.create(g_sfu),base.TypeInfo.create(g_sfv),'','','','')
   THEN
       LET g_success='Y'
       LET g_sfu.sfu15='S'
       DISPLAY BY NAME g_sfu.sfu15
   ELSE
       LET g_success='N'
   END IF
END FUNCTION
#FUN-A80128---add----end---

#FUN-A80128 add str ------
FUNCTION t620_sfu16(p_cmd)  #申請人編號
 DEFINE   p_cmd      LIKE type_file.chr1,          
          l_gen02    LIKE gen_file.gen02,
          l_genacti  LIKE gen_file.genacti

    LET g_errno = ' '

    SELECT gen02,genacti INTO l_gen02,l_genacti
      FROM gen_file
     WHERE gen01 = g_sfu.sfu16
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
#FUN-A80128 add end -----

#FUN-B70061 --END--
   
#No.FUN-BB0086---start---add---
FUNCTION t620_sfv32_check(l_qty_FQC,l_qcf091,p_cmd) #FUN-BC0104 add p_cmd
DEFINE l_qty_FQC  LIKE sfv_file.sfv09
DEFINE l_qcf091   LIKE qcf_file.qcf091
DEFINE l_case     STRING
DEFINE p_cmd      LIKE type_file.chr1
   IF NOT cl_null(g_sfv[l_ac].sfv32) AND NOT cl_null(g_sfv[l_ac].sfv30) THEN
      IF cl_null(g_sfv_t.sfv32) OR cl_null(g_sfv30_t) OR g_sfv_t.sfv32 != g_sfv[l_ac].sfv32 OR g_sfv30_t != g_sfv[l_ac].sfv30 THEN
         LET g_sfv[l_ac].sfv32=s_digqty(g_sfv[l_ac].sfv32, g_sfv[l_ac].sfv30)
         DISPLAY BY NAME g_sfv[l_ac].sfv32
      END IF
   END IF
   
   IF NOT cl_null(g_sfv[l_ac].sfv32) THEN
      IF g_sfv[l_ac].sfv32 < 0 THEN
         CALL cl_err('','aim-391',0)  #
         RETURN FALSE,'sfv32'
      END IF
   END IF
   CALL t620_set_origin_field()
   #計算sfv09的值,檢查入庫數量的合理性
   IF g_argv<>'3' THEN #FUN-5C0114
      CALL t620_check_inventory_qty(l_qty_FQC,l_FQC,l_qcf091)
      RETURNING g_flag
      IF g_flag = '1' THEN
         IF g_ima906 = '3' OR g_ima906 = '2' THEN
            RETURN FALSE,'sfv35'
         ELSE
            RETURN FALSE,'sfv32'
         END IF
      END IF
   ELSE
      IF cl_null(g_sfv[l_ac].sfv03) THEN
         RETURN FALSE,'sfv03'
      END IF
      IF NOT t620_asrchk_sfv09(g_sfv[l_ac].sfv17,
                               g_sfv[l_ac].sfv14,
                               g_sfv[l_ac].sfv09) THEN
      IF g_ima906 = '3' OR g_ima906 = '2' THEN
         RETURN FALSE,'sfv35'
      ELSE
         RETURN FALSE,'sfv32'
      END IF
   END IF
   END IF
   #FUN-BC0104---add---str---
           IF g_sma.sma115='Y' AND NOT cl_null(g_sfv[l_ac].sfv46) THEN
              IF NOT cl_null(g_sfv[l_ac].sfv32) AND g_sfv[l_ac].sfv32!=0 THEN
                 LET l_case = ''
                 CALL t620_sfv09(p_cmd) RETURNING l_case
                 CASE l_case
                   WHEN "sfv09"
                      RETURN FALSE,'sfv32'
                   WHEN "sfv03"
                      RETURN FALSE,'sfv03'
                   WHEN "sfv17"
                      RETURN FALSE,'sfv17' 
                   OTHERWISE EXIT CASE
                  END CASE
              END IF
           END IF
   #FUN-BC0104---add---end---
   CALL cl_show_fld_cont()

   RETURN TRUE,''
END FUNCTION

FUNCTION t620_sfv35_check(p_cmd,l_bno)
DEFINE p_cmd           LIKE type_file.chr1
DEFINE l_bno           LIKE rvbs_file.rvbs08
DEFINE l_case          STRING 
   IF NOT cl_null(g_sfv[l_ac].sfv35) AND NOT cl_null(g_sfv[l_ac].sfv33) THEN
      IF cl_null(g_sfv_t.sfv35) OR cl_null(g_sfv33_t) OR g_sfv_t.sfv35 != g_sfv[l_ac].sfv35 OR g_sfv33_t != g_sfv[l_ac].sfv33 THEN
         LET g_sfv[l_ac].sfv35=s_digqty(g_sfv[l_ac].sfv35, g_sfv[l_ac].sfv33)
         DISPLAY BY NAME g_sfv[l_ac].sfv35
      END IF
   END IF
   
   IF NOT cl_null(g_sfv[l_ac].sfv35) THEN
      IF g_sfv[l_ac].sfv35 < 0 THEN
      CALL cl_err('','aim-391',0)  #
      RETURN "sfv35"         #FUN-BC0104
   END IF
   IF p_cmd = 'a' OR  p_cmd = 'u' AND
      g_sfv_t.sfv35 <> g_sfv[l_ac].sfv35 THEN
      IF g_ima906='3' THEN
         LET g_tot=g_sfv[l_ac].sfv35*g_sfv[l_ac].sfv34
         IF cl_null(g_sfv[l_ac].sfv32) OR g_sfv[l_ac].sfv32=0 THEN #CHI-960022
         LET g_sfv[l_ac].sfv32=g_tot*g_sfv[l_ac].sfv31
         END IF                                                    #CHI-960022
      END IF
   END IF
   SELECT ima918,ima921,ima930 INTO g_ima918,g_ima921,g_ima930 #DEV-D30059 add ima930 
     FROM ima_file
     WHERE ima01 = g_sfv[l_ac].sfv04
       AND imaacti = "Y"
           
   IF cl_null(g_ima930) THEN LET g_ima930 = 'N' END IF  #DEV-D30059 add

   IF (g_ima918 = "Y" OR g_ima921 = "Y") AND
      (cl_null(g_sfv_t.sfv35) OR (g_sfv[l_ac].sfv35<>g_sfv_t.sfv35 )) THEN
   IF cl_null(g_sfv[l_ac].sfv06) THEN
      LET g_sfv[l_ac].sfv06 = ' '
   END IF
   IF cl_null(g_sfv[l_ac].sfv07) THEN
      LET g_sfv[l_ac].sfv07 = ' '
   END IF
   SELECT img09 INTO g_img09 FROM img_file
      WHERE img01=g_sfv[l_ac].sfv04
        AND img02=g_sfv[l_ac].sfv05
        AND img03=g_sfv[l_ac].sfv06
        AND img04=g_sfv[l_ac].sfv07
   CALL s_umfchk(g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv08,g_img09) 
         RETURNING l_i,l_fac
   IF l_i = 1 THEN LET l_fac = 1 END IF
   #CHI-9A0022 --Begin
   IF cl_null(g_sfv[l_ac].sfv41) THEN
      LET l_bno = ''
   ELSE
      LET l_bno = g_sfv[l_ac].sfv41
   END IF
   #CHI-9A0022 --End
#TQC-B90236--mark--begin
#  CALL s_lotin(g_prog,g_sfu.sfu01,g_sfv[l_ac].sfv03,0,
#              g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv08,g_img09,
#              l_fac,g_sfv[l_ac].sfv09,l_bno,'MOD')#CHI-9A0022 add l_bno
#TQC-B90236--mark--end
#TQC-B90236--add---begin
   CALL s_wo_record(g_sfv[l_ac].sfv11,'Y')  #MOD-CB0031 add
   IF g_ima930 = 'N' THEN                                        #DEV-D30059
      CALL s_mod_lot(g_prog,g_sfu.sfu01,g_sfv[l_ac].sfv03,0,
                     g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv05,
                     g_sfv[l_ac].sfv06,g_sfv[l_ac].sfv07,
                     g_sfv[l_ac].sfv08,g_img09,l_fac,g_sfv[l_ac].sfv09,l_bno,'MOD',1)
#TQC-B90236--add---end
         RETURNING l_r,g_qty 
   END IF                                                        #DEV-D30059
   IF l_r = "Y" THEN
      LET g_sfv[l_ac].sfv09 = g_qty
      LET g_sfv[l_ac].sfv09 = s_digqty(g_sfv[l_ac].sfv09,g_sfv[l_ac].sfv08)   #No.FUN-C20048
   END IF
   END IF
   END IF
   #FUN-BC0104---add---str---
   IF g_sma.sma115='Y' AND NOT cl_null(g_sfv[l_ac].sfv46) THEN
       IF NOT cl_null(g_sfv[l_ac].sfv32) AND NOT cl_null(g_sfv[l_ac].sfv35) THEN
          IF g_sfv[l_ac].sfv35!=0 THEN
             CALL t620_set_origin_field()
             LET l_case = ''
             CALL t620_sfv09(p_cmd) RETURNING l_case
             CASE l_case
               WHEN "sfv09"
                  RETURN "sfv35"
               WHEN "sfv03"
                  RETURN "sfv03"
               WHEN "sfv17"
                  RETURN "sfv17"
               OTHERWISE EXIT CASE
             END CASE
          END IF
      END IF
   END IF
   #FUN-BC0104---add---end---
   CALL cl_show_fld_cont()
   RETURN '' 
END FUNCTION
#No.FUN-BB0086---end---add---

#FUN-BC0104---add---str       

FUNCTION t620_sfv46_check()
   DEFINE l_n     LIKE type_file.num5
   DEFINE l_n1    LIKE type_file.num5
   DEFINE l_sql   STRING
   DEFINE l_sql1  STRING
   DEFINE l_sql2  STRING
   
   LET l_n  = 0
   LET l_n1 = 0

   LET l_sql= "SELECT COUNT(*) FROM sfv_file",
              " WHERE  sfv17 = ?"
 
   LET l_sql1=l_sql CLIPPED," AND sfv46 IS NOT NULL AND sfv46<>' '"
   PREPARE insert_ln FROM l_sql1
   EXECUTE insert_ln INTO l_n USING g_sfv[l_ac].sfv17 
                                           
   LET l_sql2=l_sql CLIPPED," AND sfv46 IS NULL OR sfv46=' '"
   PREPARE insert_ln1 FROM l_sql2           
   EXECUTE insert_ln1 INTO l_n1 USING g_sfv[l_ac].sfv17

   IF l_n > 0 THEN 
      CALL cl_set_comp_required('sfv46,sfv47',TRUE)
   END IF
   IF l_n1 > 0 THEN
      LET g_sfv[l_ac].sfv46 = ''
      LET g_sfv[l_ac].sfv47 = ''
      DISPLAY BY NAME g_sfv[l_ac].sfv46,g_sfv[l_ac].sfv47
      CALL cl_set_comp_entry('sfv46,sfv47',FALSE)
   END IF 
                 
END FUNCTION 

FUNCTION t620_set_noentry_sfv46()
   CALL cl_set_comp_entry('sfv46,sfv47',FALSE)
END FUNCTION

FUNCTION t620_set_comp_required(p_sfv46,p_sfv47)
   DEFINE p_sfv46 LIKE sfv_file.sfv46,
          p_sfv47 LIKE sfv_file.sfv47

   IF NOT cl_null(p_sfv46) OR NOT cl_null(p_sfv47) THEN
      CALL cl_set_comp_required('sfv46,sfv47',TRUE)
   END IF
 
   IF cl_null(p_sfv46) AND cl_null(p_sfv47) THEN
      CALL cl_set_comp_required('sfv46,sfv47',FALSE)
      LET g_sfv[l_ac].qcl02 = ''
   END IF
END FUNCTION

FUNCTION t620_qcl02_desc()
  
      SELECT qcl02 INTO g_sfv[l_ac].qcl02 FROM qcl_file
             WHERE qcl01 = g_sfv[l_ac].sfv46
      DISPLAY BY NAME g_sfv[l_ac].qcl02
   
END FUNCTION

FUNCTION t620_qcl05_check() 
   DEFINE l_qcl05 LIKE qcl_file.qcl05

   IF NOT cl_null(g_sfv[l_ac].sfv46) THEN
      SELECT qcl05 INTO l_qcl05 FROM qcl_file
                                WHERE qcl01 = g_sfv[l_ac].sfv46
      RETURN l_qcl05
   END IF 
RETURN ''
END FUNCTION

FUNCTION t620_qco_show()
DEFINE l_qcl05 LIKE qcl_file.qcl05,
       l_qco20 LIKE qco_file.qco20,
       l_sfv30 LIKE sfv_file.sfv30,
       l_sfv32 LIKE sfv_file.sfv32,
       l_sfv33 LIKE sfv_file.sfv33,
       l_sfv35 LIKE sfv_file.sfv35,
       l_i     LIKE type_file.num5,
       l_ima906 LIKE ima_file.ima906,
       l_ima55 LIKE ima_file.ima55

      SELECT qco06,qco07,qco08,qco09,qco10,qco13,qco15,qco16,qco18,qco20 INTO g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv05,
                                                g_sfv[l_ac].sfv06,g_sfv[l_ac].sfv07,
                                                g_sfv[l_ac].sfv08,l_sfv30,l_sfv32,l_sfv33,l_sfv35,l_qco20
                                           FROM qco_file
                                          WHERE qco01 = g_sfv[l_ac].sfv17
                                            AND qco02 = 0
                                            AND qco05 = 0
                                            AND qco04 = g_sfv[l_ac].sfv47
      DISPLAY BY NAME g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv05,
                      g_sfv[l_ac].sfv06,g_sfv[l_ac].sfv07,
                      g_sfv[l_ac].sfv08
      IF g_sma.sma115 = 'Y' THEN
         LET g_sfv[l_ac].sfv30 = l_sfv30  #單位一賦值
         LET g_sfv[l_ac].sfv33 = l_sfv33  #單位二賦值
         CALL t620_set_origin_field()
         CALL s_du_umfchk(g_sfv[l_ac].sfv04,'','','',        #單位一換算率                                       
                          g_sfv[l_ac].sfv08,g_sfv[l_ac].sfv30,'1')
         RETURNING g_errno,g_factor

         LET g_sfv[l_ac].sfv31 = g_factor
         DISPLAY BY NAME g_sfv[l_ac].sfv31
                
         SELECT ima906,ima55 INTO l_ima906,l_ima55 FROM ima_file
         WHERE ima01 = g_sfv[l_ac].sfv04 
         CALL s_du_umfchk(g_sfv[l_ac].sfv04,'','','',        #單位二換算率                                    
                          l_ima55,g_sfv[l_ac].sfv33,l_ima906)
         RETURNING g_errno,g_factor

         LET g_sfv[l_ac].sfv34 = g_factor
         DISPLAY BY NAME g_sfv[l_ac].sfv34
      END IF
      CALL t620_qcl05_check() RETURNING l_qcl05
      IF l_qcl05 = '0' OR l_qcl05 = '2' THEN        #TQC-C30013
         IF g_sma.sma115 = 'N' THEN
            CALL t620_sfv09_check('') RETURNING g_sfv[l_ac].sfv09
            LET g_sfv[l_ac].sfv09 = s_digqty(g_sfv[l_ac].sfv09,g_sfv[l_ac].sfv08)   #No.FUN-C20048
            CALL cl_set_comp_entry('sfv09',TRUE)
            DISPLAY BY NAME g_sfv[l_ac].sfv09
         ELSE
            IF l_qco20=0 THEN
               LET g_sfv[l_ac].sfv32 = l_sfv32
               LET g_sfv[l_ac].sfv35 = l_sfv35
            ELSE
               LET g_sfv[l_ac].sfv32=0
               LET g_sfv[l_ac].sfv35=0
            END IF
            CALL t620_set_origin_field()
            DISPLAY BY NAME g_sfv[l_ac].sfv32,g_sfv[l_ac].sfv35
         END IF
      END IF
END FUNCTION

FUNCTION t620_sfv09_check(p_cmd)
DEFINE l_sum LIKE qco_file.qco11,
       p_cmd LIKE type_file.chr1,
       l_qco10 LIKE qco_file.qco10,
       l_i     LIKE type_file.num5,
       l_fac   LIKE rvv_file.rvv35_fac
       
   SELECT qco11-qco20,qco10 INTO l_sum,l_qco10 FROM qco_file
                                      WHERE qco01 = g_sfv[l_ac].sfv17
                                        AND qco02 = 0
                                        AND qco05 = 0
                                        AND qco04 = g_sfv[l_ac].sfv47
   IF cl_null(l_sum) THEN LET l_sum=0 END IF
   IF p_cmd = 'u' THEN
      LET l_sum = l_sum+g_sfv_t.sfv09
   END IF
   CALL s_umfchk(g_sfv[l_ac].sfv04,l_qco10,g_sfv[l_ac].sfv08)
          RETURNING l_i,l_fac
   IF l_i THEN LET l_fac=1 END IF
   LET l_sum = l_sum*l_fac

   RETURN l_sum
END FUNCTION 

FUNCTION t620_sfv05_check()
DEFINE l_n     LIKE type_file.num5,
       l_qcl05 LIKE qcl_file.qcl05,
       l_sql   STRING
   LET l_n = 0
   LET l_sql="SELECT COUNT(*) FROM qcl_file,imd_file",
             " WHERE qcl01='",g_sfv[l_ac].sfv46 CLIPPED,
             "' AND imd01 = '",g_sfv[l_ac].sfv05 CLIPPED,
             "' AND qcl03=imd11 AND qcl04=imd12"
   SELECT qcl05 INTO l_qcl05 FROM qcl_file
                  WHERE qcl01 = g_sfv[l_ac].sfv46
   IF l_qcl05 = '0' THEN                              
      LET l_sql = l_sql CLIPPED," AND imd01 NOT IN(SELECT jce02 FROM jce_file)"
   END IF
  #TQC-C30013---add---str---
   IF l_qcl05 = '2' THEN
      LET l_sql = l_sql CLIPPED," AND imd01 IN(SELECT jce02 FROM jce_file)"
   END IF
  #TQC-C30013---add---end---
   PREPARE insert_l_n2 FROM l_sql
   EXECUTE insert_l_n2 INTO l_n
       
   IF l_n = 0 THEN
      RETURN FALSE
   END IF
RETURN TRUE
END FUNCTION

FUNCTION t620_sfv46_47_check()
DEFINE l_n    LIKE type_file.num5,
       l_sql  STRING

   LET l_n = 0
   LET l_sql=" SELECT COUNT(*) FROM qcf_file,qco_file,qcl_file",
                 " WHERE qcf00='1' AND qcf14='Y' AND qco01=qcf01",
                 "  AND qcl01 = qco03 AND qco01='",g_sfv[l_ac].sfv17 CLIPPED,"'"
                 
    IF NOT cl_null(g_sfv[l_ac].sfv46) THEN
       LET l_sql=l_sql CLIPPED," AND qco03='",g_sfv[l_ac].sfv46 CLIPPED,"'"
    END IF

    IF NOT cl_null(g_sfv[l_ac].sfv47) THEN
       LET l_sql=l_sql CLIPPED," AND qco04=",g_sfv[l_ac].sfv47 CLIPPED
    END IF

    PREPARE insert_l_n FROM l_sql
    EXECUTE insert_l_n INTO l_n

    IF l_n = 0 THEN
       RETURN FALSE
    END IF
RETURN TRUE
END FUNCTION

FUNCTION t620_sfv09(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1
DEFINE  l_pjb09      LIKE pjb_file.pjb09           #FUN-850027
DEFINE  l_pjb11      LIKE pjb_file.pjb11           #FUN-850027
DEFINE  l_azf09      LIKE azf_file.azf09           #FUN-930145
DEFINE  l_tmp_qcqty  LIKE sfv_file.sfv09           #No:MOD-960289 add
DEFINE  l_bno        LIKE rvbs_file.rvbs08         #No.CHI-9A0022
DEFINE  l_ecm012     LIKE ecm_file.ecm012          #FUN-A50066
DEFINE  l_ecm03      LIKE ecm_file.ecm03           #FUN-A50066
DEFINE l_ima153      LIKE ima_file.ima153      #CHI-AC0023 add
DEFINE l_ima159      LIKE ima_file.ima159      #FUN-B50096
DEFINE l_tf          LIKE type_file.chr1                   #No.FUN-BB0086
DEFINE l_case        STRING                    #No.FUN-BB0086
DEFINE l_sum         LIKE qco_file.qco11       #FUN-BC0104 add
DEFINE l_qcl05       LIKE qcl_file.qcl05       #FUN-BC0104 add
DEFINE l_b2             LIKE type_file.chr50,         #No:FUN-680121 CHAR(30)
     l_ima35          LIKE ima_file.ima35,          #MOD-5B0100
     l_ima36          LIKE ima_file.ima36,          #MOD-5B0100
     l_sfv09          LIKE sfv_file.sfv09,
     l_qty1           LIKE sfv_file.sfv09,          #TQC-750208 add
     l_qty2           LIKE sfv_file.sfv09,          #TQC-750208 add
     l_sfb08          LIKE sfb_file.sfb08,
     l_sfb39          LIKE sfb_file.sfb39,
     l_qcf091         LIKE qcf_file.qcf091,
     ll_qcf091        LIKE qcf_file.qcf091,
     l_ecm311         LIKE ecm_file.ecm311,         #No:7834 add
     l_ecm315         LIKE ecm_file.ecm315,         #No:7834 add
     l_ecm_out        LIKE ecm_file.ecm315,         #No:7834 add
     l_qty            LIKE sfv_file.sfv09,          #No:FUN-680121 DECIMAL(15,3)
     l_name           LIKE type_file.chr20,         #No:FUN-680121 CHAR(10)#No:MOD-5B0304 add
     l_qty_FQC        LIKE sfv_file.sfv09,          #No:FUN-680121 DEC(15,3)
     l_bmm01          LIKE bmm_file.bmm01,
     l_allow_insert   LIKE type_file.num5,          #可新增否        #No.FUN-680121 SMALLINT
     l_allow_delete   LIKE type_file.num5,          #可刪除否        #No.FUN-680121 SMALLINT
     l_srg05          LIKE srg_file.srg05,           #TQC-740263 add
     l_pjb25          LIKE pjb_file.pjb25,          #FUN-810045
     l_pja26          LIKE pja_file.pja26,           #FUN-810045
     l_cnt            LIKE type_file.num5
           #No.FUN-BB0086--add--start--

        CALL t620_qcl05_check() RETURNING l_qcl05
           IF NOT cl_null(g_sfv[l_ac].sfv09) AND NOT cl_null(g_sfv[l_ac].sfv08) THEN
              IF cl_null(g_sfv_t.sfv09) OR g_sfv_t.sfv09 != g_sfv[l_ac].sfv09 THEN
              LET g_sfv[l_ac].sfv09=s_digqty(g_sfv[l_ac].sfv09, g_sfv[l_ac].sfv08)
              DISPLAY BY NAME g_sfv[l_ac].sfv09
              END IF
           END IF
           #No.FUN-BB0086--add--end--
           IF (NOT cl_null(g_sfv[l_ac].sfv09)) AND (g_argv<>'3') THEN  #FUN-5C0114 add g_argv<>'3'
              IF g_sfv[l_ac].sfv09 <= 0 THEN
                 LET g_sfv[l_ac].sfv09 = 0
                 DISPLAY BY NAME g_sfv[l_ac].sfv09 #MOD-4A0260
                 RETURN "sfv09"
              END IF
 
     #------->聯產品 NO:6872
              IF l_FQC = 'Y' THEN
                  IF g_sfv[l_ac].sfv09 > l_qty_FQC THEN
                      RETURN "sfv09"
                  END IF
              ELSE
     ##---------------------------------------------------
                  IF g_argv MATCHES '[12]' THEN   #入庫,退回
                     SELECT sfb08,sfb09 INTO l_sfb08,l_sfv09 FROM sfb_file
                      WHERE sfb01 = g_sfv[l_ac].sfv11
                     IF l_sfv09 IS NULL THEN LET l_sfv09 = 0 END IF
                     IF l_sfb08 IS NULL THEN LET l_sfb08 = 0 END IF
                     IF g_argv = '2' THEN   #退庫時不可大於入庫數量
                        IF g_sfv[l_ac].sfv09 > l_sfv09 THEN
                           CALL cl_err(g_sfv[l_ac].sfv09,'asf-712',1)
                           RETURN "sfv09"
                        END IF
                     END IF
                  END IF
              ##----------------------------------------
                 #工單完工方式為'2' pull
                  IF g_argv = '1' AND g_sfv[l_ac].sfv09 > 0  AND
                     g_sfb.sfb39 <> '2' THEN
                    #MOD-BA0192---add---start---
                     # sum(已存在入庫單入庫數量) by W/O (不管有無過帳)
                     SELECT SUM(sfv09) INTO tmp_qty FROM sfv_file,sfu_file
                      WHERE sfv11 = g_sfv[l_ac].sfv11
                        AND sfv01 = sfu01
                        AND sfu00 = '1'   #類別 1.入庫  2.入庫退回
                        AND (sfv01 != g_sfu.sfu01 OR
                            (sfv01 = g_sfu.sfu01 AND sfv03 != g_sfv[l_ac].sfv03))
                        AND sfuconf <> 'X' #FUN-660137

                     IF tmp_qty IS NULL OR SQLCA.sqlcode THEN LET tmp_qty=0 END IF
                    #MOD-BA0192---add---end---
                   # check 入庫數量 不可 大於 (生產數量-完工數量)
                     IF g_sfb.sfb93!='Y'THEN
                        #No.TQC-BB0236  --Begin
                        CALL t620_get_over_qty()
                        #No.TQC-BB0236  --End
                        IF (g_sfv[l_ac].sfv09 > l_sfb08 - l_sfv09 + g_over_qty ) THEN
                              CALL cl_err(g_sfv[l_ac].sfv09,'asf-714',1)
                              RETURN "sfv09"
                        END IF
# sma73    工單完工數量是否檢查發料最小套數
# sma74    工單完工量容許差異百分比
                       #MOD-BA0192---mark---start---
                       #移到上面，因走製程也有可能分段入庫
                       ## sum(已存在入庫單入庫數量) by W/O (不管有無過帳)
                       #SELECT SUM(sfv09) INTO tmp_qty FROM sfv_file,sfu_file
                       # WHERE sfv11 = g_sfv[l_ac].sfv11
                       #   AND sfv01 = sfu01
                       #   AND sfu00 = '1'   #類別 1.入庫  2.入庫退回
                       #   AND (sfv01 != g_sfu.sfu01 OR                                                                             
                       #       (sfv01 = g_sfu.sfu01 AND sfv03 != g_sfv[l_ac].sfv03))                                                
                       #   AND sfuconf <> 'X' #FUN-660137
                       #
                       #IF tmp_qty IS NULL OR SQLCA.sqlcode THEN LET tmp_qty=0 END IF
                       #MOD-BA0192---mark---end---
                        #入庫量不可大於最小套數-以keyin 入庫量
                       #TQC-D40080--add--str---
                        LET g_min_set = 0
                        CALL s_minp(g_sfv[l_ac].sfv11,g_sma.sma73,0,'','','',g_sfu.sfu02)
                           RETURNING g_cnt,g_min_set
                        IF g_cnt !=0  THEN
                           CALL cl_err('s_minp()','asf-549',0)
                           RETURN "sfv09"
                        END IF
                       #TQC-D40080--add--end---
                       #IF g_sma.sma73='Y' AND (g_sfv[l_ac].sfv09) > (g_min_set-tmp_qty) THEN              #MOD-C70211 mark
                        IF (g_sfv[l_ac].sfv09) > (g_min_set-tmp_qty+g_over_qty) THEN                       #MOD-C70211 add 
                           CALL cl_err(g_sfv[l_ac].sfv09,'asf-675',1)
                           RETURN "sfv09"
                        END IF
                     END IF
 
                     IF g_sfb.sfb93='Y' THEN # 走製程 check 轉出量
                       #MOD-A90152---add---start---
                        LET g_ecm311 = 0   
                        LET g_ecm315 = 0
                        CALL s_schdat_max_ecm03(g_sfv[l_ac].sfv11) RETURNING l_ecm012,l_ecm03  #TQC-AC0277
                        SELECT ecm311,ecm315 INTO g_ecm311,g_ecm315 FROM ecm_file
                         WHERE ecm01=g_sfv[l_ac].sfv11
                          #AND ecm03= (SELECT MAX(ecm03) FROM ecm_file #TQC-AC0277
                          #             WHERE ecm01=g_sfv[l_ac].sfv11) #TQC-AC0277
                           AND ecm012= l_ecm012  #TQC-AC0277
                           AND ecm03 = l_ecm03   #TQC-AC0277
                        IF STATUS THEN LET g_ecm311=0 END IF
                        IF STATUS THEN LET g_ecm315=0 END IF
                        LET g_ecm_out = g_ecm311 + g_ecm315
                        IF cl_null(tmp_qty) THEN LET tmp_qty = 0 END IF
                       #MOD-A90152---add---end---
                        IF g_sfv[l_ac].sfv09 > g_ecm_out - tmp_qty THEN
                           IF NOT t620_chk_auto_report(g_sfv[l_ac].sfv11,g_sfv[l_ac].sfv09) THEN  #FUN-A80102
                              CALL cl_err(g_sfv[l_ac].sfv09,'asf-675',1)
                              RETURN "sfv09"
                           END IF
                        END IF
#TQC-C10126 mark begin 因為,如果有多個工藝序,每個工藝序都有bonus的話,最終入庫數量肯定會大於發料套數
#                        IF g_sma.sma73='Y' AND (g_sfv[l_ac].sfv09) > (g_min_set+g_ecm315-tmp_qty) THEN
#                           CALL cl_err(g_sfv[l_ac].sfv09,'asf-675',1)
#                           RETURN "sfv09"
#                        END IF
#TQC-C10126 mark end
                     END IF

                     IF g_sfb.sfb94 = 'Y' AND g_sma.sma896 = 'Y' THEN
                        SELECT qcf091 INTO l_qcf091 FROM qcf_file   
                           WHERE qcf01 = g_sfv[l_ac].sfv17
                             AND qcf09 <> '2'   
                             AND qcf14 = 'Y'
                        IF STATUS OR l_qcf091 IS NULL THEN
                           LET l_qcf091 = 0
                        END IF
                   
                        SELECT SUM(sfv09) INTO l_tmp_qcqty FROM sfv_file,sfu_file
                         WHERE sfv11 = g_sfv[l_ac].sfv11
                           AND sfv17 = g_sfv[l_ac].sfv17
                           AND sfv01 = sfu01
                           AND sfu00 = '1'  
                           AND (sfv01 != g_sfu.sfu01 OR                                                                             
                               (sfv01 = g_sfu.sfu01 AND sfv03 != g_sfv[l_ac].sfv03))                                                
                           AND sfuconf <> 'X' 
                           IF cl_null(l_tmp_qcqty) THEN LET l_tmp_qcqty = 0 END IF
                     END IF

                     #IF g_sfb.sfb94='Y' AND #是否使用FQC功能
                     IF g_sfb.sfb94='Y' AND g_sma.sma896='Y' AND
                        (g_sfv[l_ac].sfv09) > l_qcf091 - l_tmp_qcqty       #No:MOD-960289 modify
                        THEN
                        #----FQC No.不為null,入庫量不可大於FQC量-以keyin 入庫量
                        CALL cl_err(g_sfv[l_ac].sfv09,'asf-675',1)
                        RETURN "sfv09"
                     END IF
                  END IF
##--------------------------------------------------
#No:7834      工單完工方式為'2' pull(sfb39='2')&走製程(sfb93='Y')
                  IF g_argv = '1' AND g_sfv[l_ac].sfv09 > 0  AND
                     g_sfb.sfb39= '2' THEN
                     CALL s_schdat_max_ecm03(g_sfv[l_ac].sfv11) RETURNING l_ecm012,l_ecm03  #FUN-A50066
                    #check 最終製程之總轉出量(良品轉出量+Bonus)
                     SELECT ecm311,ecm315 INTO l_ecm311,l_ecm315 FROM ecm_file
                      WHERE ecm01=g_sfv[l_ac].sfv11
                       #AND ecm03= (SELECT MAX(ecm03) FROM ecm_file      #No:MOD-5B0302 add #FUN-A50066
                       #             WHERE ecm01=g_sfv[l_ac].sfv11)                         #FUN-A50066
                        AND ecm012= l_ecm012  #FUN-A50066
                        AND ecm03 = l_ecm03   #FUN-A50066
                     IF SQLCA.sqlcode THEN
                        LET l_ecm311=0
                        LET l_ecm315=0
                     END IF
                     LET l_ecm_out=l_ecm311 + l_ecm315
 

                     LET l_sfv09=0     #已key之入庫量(不分是否已過帳)
                     SELECT SUM(sfv09) INTO l_qty1 FROM sfv_file,sfu_file
                      WHERE sfv11 = g_sfv[l_ac].sfv11
                        AND sfv01 ! = g_sfu.sfu01  
                        AND sfv01 = sfu01
                        AND sfu00 = '1'           #完工入庫
                       #AND sfupost <> 'X'  #MOD-A40043 mark
                        AND sfuconf <> 'X'  #MOD-A40043
                     IF l_qty1 IS NULL THEN LET l_qty1 =0 END IF

                     SELECT SUM(sfv09) INTO l_qty2 FROM sfv_file,sfu_file
                      WHERE sfv11 = g_sfv[l_ac].sfv11
                        AND sfv01 = g_sfu.sfu01   
                        AND sfv03!= g_sfv[l_ac].sfv03
                        AND sfv01 = sfu01
                        AND sfu00 = '1'           #完工入庫
                       #AND sfupost <> 'X'  #MOD-A40043 mark
                        AND sfuconf <> 'X'  #MOD-A40043
                     IF l_qty2 IS NULL THEN LET l_qty2 =0 END IF

                     LET l_sfv09 = l_qty1 + l_qty2 + g_sfv[l_ac].sfv09

                    IF g_sfb.sfb93 = 'Y' THEN
                       #入庫量 > 製程最後轉出量
                       IF l_sfv09 > l_ecm_out THEN
                          LET g_msg ="(",l_sfv09   USING '############.###','>',    #No:MOD-970035 modify
                                     l_ecm_out USING '############.###',")"         #No:MOD-970035 modify
                          IF NOT t620_chk_auto_report(g_sfv[l_ac].sfv11,g_sfv[l_ac].sfv09) THEN  #FUN-A80102
                             CALL cl_err(g_msg,'asf-675',1)
                             RETURN "sfv09"
                          END IF
                       END IF
                    ELSE
                       #CHI-AC0023 add --start--
                       CALL s_get_ima153(g_sfv[l_ac].sfv04) RETURNING l_ima153    
                    #  CALL s_minp(g_sfv[l_ac].sfv11,g_sma.sma73,l_ima153,'','','') RETURNING g_cnt,l_sfb08  #FUN-C70037 mark            
                       CALL s_minp(g_sfv[l_ac].sfv11,g_sma.sma73,l_ima153,'','','',g_sfu.sfu02) RETURNING g_cnt,l_sfb08  #FUN-C70037
                       #CHI-AC0023 add --end--
                       IF l_sfv09 > l_sfb08 THEN
                          LET g_msg ="(",l_sfv09   USING '############.###','>',  #No:MOD-970035 modify
                                     l_sfb08 USING '############.###',")"         #No:MOD-970035 modify
                          CALL cl_err(g_msg,'asf-675',1)
                          RETURN "sfv09"
                       END IF
                    END IF
                  END IF
                  IF g_argv = '2' AND g_sfv[l_ac].sfv09 > 0  AND
                     g_sfv[l_ac].sfv09> g_sfb.sfb09 - tmp_qty
                  THEN
                     #----退回量不可大於完工入庫量
                     CALL cl_err(g_sfv[l_ac].sfv09,'asf-712',1)
                     RETURN "sfv09"
                  END IF
               END IF #--->聯產品END
           END IF
           #當入庫單是由asft300生產報工產生的,在修改單身的入庫數量時要檢查
           #與報工單身的良品數應一致,兩邊若不match則顯示訊息
           LET l_cnt = 0
           SELECT COUNT(*) INTO l_cnt FROM srg_file 
            WHERE srg11=g_sfu.sfu01 AND srg14=g_sfv[l_ac].sfv04
              AND srg16 = g_sfv[l_ac].sfv11   #MOD-920158 add
           IF l_cnt != 0 THEN
              SELECT SUM(srg05) INTO l_srg05 FROM srg_file    #No.MOD-950133    
               WHERE srg11=g_sfu.sfu01 AND srg14=g_sfv[l_ac].sfv04
              AND srg16 = g_sfv[l_ac].sfv11   #MOD-920158 add
              IF g_sfv[l_ac].sfv09 > l_srg05 THEN
                 CALL cl_err(g_sfv[l_ac].sfv09,'asr-033',1)
                 RETURN "sfv09"
              END IF
              IF g_sfv[l_ac].sfv09 < l_srg05 THEN
                 CALL cl_err(g_sfv[l_ac].sfv09,'asr-050',0)
              END IF
           END IF
           IF (NOT cl_null(g_sfv[l_ac].sfv09)) AND (g_argv='3') THEN
              IF cl_null(g_sfv[l_ac].sfv03) THEN
                 RETURN "sfv03"
              END IF
              IF NOT t620_asrchk_sfv09(g_sfv[l_ac].sfv17,
                                       g_sfv[l_ac].sfv14,
                                       g_sfv[l_ac].sfv09) THEN
                 RETURN "sfv17"
              END IF
           END IF
           SELECT ima918,ima921,ima930 INTO g_ima918,g_ima921,g_ima930 #DEV-D30059 add ima930 
             FROM ima_file
            WHERE ima01 = g_sfv[l_ac].sfv04
              AND imaacti = "Y"
           
           IF cl_null(g_ima930) THEN LET g_ima930 = 'N' END IF  #DEV-D30059 add

           IF (g_ima918 = "Y" OR g_ima921 = "Y") AND
              (cl_null(g_sfv_t.sfv09) OR (g_sfv[l_ac].sfv09<>g_sfv_t.sfv09 )) THEN
              IF cl_null(g_sfv[l_ac].sfv06) THEN
                 LET g_sfv[l_ac].sfv06 = ' '
              END IF
              IF cl_null(g_sfv[l_ac].sfv07) THEN
                 LET g_sfv[l_ac].sfv07 = ' '
              END IF
              SELECT img09 INTO g_img09 FROM img_file
               WHERE img01=g_sfv[l_ac].sfv04
                 AND img02=g_sfv[l_ac].sfv05
                 AND img03=g_sfv[l_ac].sfv06
                 AND img04=g_sfv[l_ac].sfv07
              CALL s_umfchk(g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv08,g_img09) 
                  RETURNING l_i,l_fac
              IF l_i = 1 THEN LET l_fac = 1 END IF
#CHI-9A0022 --Begin
              IF cl_null(g_sfv[l_ac].sfv41) THEN
                 LET l_bno = ''
              ELSE
                 LET l_bno = g_sfv[l_ac].sfv41
              END IF
#CHI-9A0022 --End
#TQC-B90236---mark---begin
#             CALL s_lotin(g_prog,g_sfu.sfu01,g_sfv[l_ac].sfv03,0,
#                          g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv08,g_img09,
#                          l_fac,g_sfv[l_ac].sfv09,l_bno,'MOD')#CHI-9A0022 add l_bno
#TQC-B90236---mark---end
#TQC_B90236---add----begin
              CALL s_wo_record(g_sfv[l_ac].sfv11,'Y')  #MOD-CB0031 add
              IF g_ima930 = 'N' THEN                                        #DEV-D30059
                 CALL s_mod_lot(g_prog,g_sfu.sfu01,g_sfv[l_ac].sfv03,0,
                                g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv05,
                                g_sfv[l_ac].sfv06,g_sfv[l_ac].sfv07,
                                g_sfv[l_ac].sfv08,g_img09,l_fac,g_sfv[l_ac].sfv09,l_bno,'MOD',1)
#TQC-B90236---add----end
                        RETURNING l_r,g_qty 
              END IF                                                        #DEV-D30059
              IF l_r = "Y" THEN
                 LET g_sfv[l_ac].sfv09 = g_qty
              END IF
           END IF
           #FUN-BC0104---add---str
           IF NOT cl_null(g_sfv[l_ac].sfv09) THEN
              IF p_cmd='a' OR (p_cmd='u' AND g_sfv_t.sfv09 != g_sfv[l_ac].sfv09) THEN
                 CALL t620_qcl05_check() RETURNING l_qcl05
                 IF l_qcl05 = '0' OR l_qcl05 = '2' THEN             #TQC-C30013
                    CALL t620_sfv09_check(p_cmd) RETURNING l_sum
                    IF g_sfv[l_ac].sfv09 > l_sum THEN
                       CALL cl_err('','apm-804',1)
                       LET g_sfv[l_ac].sfv09 = l_sum
                       DISPLAY BY NAME g_sfv[l_ac].sfv09
                       RETURN "sfv09"
                    END IF 
                 END IF 
              END IF
            END IF
           #FUN-BC0104---add---end
RETURN '' 
END FUNCTION 
#FUN-BC0104---add---end

#No.TQC-BB0236  --Begin
FUNCTION t620_get_over_qty()
   DEFINE l_over_qty       LIKE sfv_file.sfv09
   DEFINE l_ima153         LIKE ima_file.ima153
   DEFINE l_sfb05          LIKE sfb_file.sfb05      #MOD-C70211 add
   DEFINE l_sfb08          LIKE sfb_file.sfb08      #MOD-D30197

   IF NOT cl_null(g_over_qty) THEN RETURN END IF

   LET g_over_qty = 0
   SELECT sfb05 INTO l_sfb05 FROM sfb_file WHERE sfb01 = g_sfv[l_ac].sfv11    #MOD-C70211 add

   IF g_sfb.sfb93!='Y' AND g_argv = '1' THEN
     #CALL s_get_ima153(g_sfv[l_ac].sfv04) RETURNING l_ima153   #MOD-C70211 mark
      CALL s_get_ima153(l_sfb05) RETURNING l_ima153             #MOD-C70211 add
      IF g_err = 'Y' THEN
         RETURN
      END IF

      #default 時不考慮超限率sma74
   #  CALL s_minp(g_sfv[l_ac].sfv11,g_sma.sma73,0,'','','')              #FUN-C70037  mark
      CALL s_minp(g_sfv[l_ac].sfv11,g_sma.sma73,0,'','','',g_sfu.sfu02)  #FUN-C70037
           RETURNING g_cnt,g_min_set

      IF g_cnt !=0  THEN
         RETURN
      END IF

      #sma73 工單完工數量是否檢查發料最小套數
      #sma74 工單完工量容許差異百分比

      IF g_sma.sma73='Y' THEN  #
      #  CALL s_minp(g_sfv[l_ac].sfv11,g_sma.sma73,l_ima153,'','','')     #FUN-C70037  mark
         CALL s_minp(g_sfv[l_ac].sfv11,g_sma.sma73,l_ima153,'','','',g_sfu.sfu02)  #FUN-C70037
              RETURNING g_cnt,l_over_qty

         IF cl_null(l_over_qty) THEN LET l_over_qty = 0 END IF
         LET g_over_qty = l_over_qty - g_min_set
      ELSE
         #MOD-D30197---begin
         #LET g_over_qty=0  
         SELECT sfb08 INTO l_sfb08 FROM sfb_file WHERE sfb01 = g_sfv[l_ac].sfv11
         LET g_over_qty= l_sfb08 * l_ima153/100
         #MOD-D30197---end
      END IF

      IF g_over_qty IS NULL THEN LET g_over_qty=0 END IF
   END IF

END FUNCTION
#No.TQC-BB0236  --End

#MOD-C30084--begin
#当单身入库数量已存在且大于0时,修改工单单号后应重新检查入库数量
FUNCTION t620_sfv09_check1()
DEFINE 
    l_qty1           LIKE sfv_file.sfv09,          
    l_qty2           LIKE sfv_file.sfv09,       
    l_ecm311         LIKE ecm_file.ecm311,       
    l_ecm315         LIKE ecm_file.ecm315,       
    l_ecm_out        LIKE ecm_file.ecm315,       
    l_qty            LIKE sfv_file.sfv09,        
    l_qty_FQC        LIKE sfv_file.sfv09,
    l_sfv09          LIKE sfv_file.sfv09,
    l_sfb08          LIKE sfb_file.sfb08,
    l_ecm012         LIKE ecm_file.ecm012,        
    l_ecm03          LIKE ecm_file.ecm03,
    l_ima153         LIKE ima_file.ima153,
    l_qcf091         LIKE qcf_file.qcf091,
    l_tmp_qcqty      LIKE sfv_file.sfv09    
    #p_cmd            LIKE type_file.chr1    
              
       IF g_argv = '1' THEN             
          IF g_sfb.sfb09='1' THEN                       
             SELECT SUM(sfv09) INTO tmp_qty FROM sfv_file,sfu_file
              WHERE sfv11 = g_sfv[l_ac].sfv11
                AND sfv01 = sfu01
                AND sfu00 = '1'   #類別 1.入庫  2.入庫退回
                AND (sfv01 != g_sfu.sfu01 OR                                                                             
                    (sfv01 = g_sfu.sfu01 AND sfv03 != g_sfv[l_ac].sfv03))                                                
                AND sfuconf <> 'X' 
             
             IF tmp_qty IS NULL OR SQLCA.sqlcode THEN LET tmp_qty=0 END IF
             # check 入庫數量 不可 大於 (生產數量-完工數量)
             IF g_sfb.sfb93!='Y'THEN
                CALL t620_get_over_qty() 
                IF (g_sfv[l_ac].sfv09 > l_sfb08 - l_sfv09 + g_over_qty ) THEN
                      CALL cl_err(g_sfv[l_ac].sfv09,'asf-714',1)
                      RETURN 0
                END IF
# sma73    工單完工數量是否檢查發料最小套數
# sma74    工單完工量容許差異百分比
                #入庫量不可大於最小套數-以keyin 入庫量
                IF g_sma.sma73='Y' AND (g_sfv[l_ac].sfv09) > (g_min_set-tmp_qty) THEN
                   CALL cl_err(g_sfv[l_ac].sfv09,'asf-675',1)
                   RETURN 0
                END IF
             END IF
 
             IF g_sfb.sfb93='Y' THEN # 走製程 check 轉出量
                LET g_ecm311 = 0   
                LET g_ecm315 = 0
                CALL s_schdat_max_ecm03(g_sfv[l_ac].sfv11) RETURNING l_ecm012,l_ecm03  
                SELECT ecm311,ecm315 INTO g_ecm311,g_ecm315 FROM ecm_file
                 WHERE ecm01=g_sfv[l_ac].sfv11
                   AND ecm012= l_ecm012 
                   AND ecm03 = l_ecm03  
                IF STATUS THEN LET g_ecm311=0 END IF
                IF STATUS THEN LET g_ecm315=0 END IF
                LET g_ecm_out = g_ecm311 + g_ecm315
                IF cl_null(tmp_qty) THEN LET tmp_qty = 0 END IF
                IF g_sfv[l_ac].sfv09 > g_ecm_out - tmp_qty THEN  
                   IF NOT t620_chk_auto_report(g_sfv[l_ac].sfv11,g_sfv[l_ac].sfv09) THEN 
                      CALL cl_err(g_sfv[l_ac].sfv09,'asf-675',1)
                      RETURN 0
                   END IF
                END IF
             END IF

             IF g_sfb.sfb94 = 'Y' AND g_sma.sma896 = 'Y' THEN
                SELECT qcf091 INTO l_qcf091 FROM qcf_file   
                   WHERE qcf01 = g_sfv[l_ac].sfv17
                     AND qcf09 <> '2'   
                     AND qcf14 = 'Y'
                IF STATUS OR l_qcf091 IS NULL THEN
                   LET l_qcf091 = 0
                END IF
             
                SELECT SUM(sfv09) INTO l_tmp_qcqty FROM sfv_file,sfu_file
                 WHERE sfv11 = g_sfv[l_ac].sfv11
                   AND sfv17 = g_sfv[l_ac].sfv17
                   AND sfv01 = sfu01
                   AND sfu00 = '1'  
                   AND (sfv01 != g_sfu.sfu01 OR                                                                             
                       (sfv01 = g_sfu.sfu01 AND sfv03 != g_sfv[l_ac].sfv03))                                                
                   AND sfuconf <> 'X' 
                   IF cl_null(l_tmp_qcqty) THEN LET l_tmp_qcqty = 0 END IF
             END IF

             IF g_sfb.sfb94='Y' AND g_sma.sma896='Y' AND
                (g_sfv[l_ac].sfv09) > l_qcf091 - l_tmp_qcqty     
                THEN
                #----FQC No.不為null,入庫量不可大於FQC量-以keyin 入庫量
                CALL cl_err(g_sfv[l_ac].sfv09,'asf-675',1)
                RETURN 0
             END IF                    
          ELSE                    	  
             CALL s_schdat_max_ecm03(g_sfv[l_ac].sfv11) RETURNING l_ecm012,l_ecm03  
             #check 最終製程之總轉出量(良品轉出量+Bonus)
             SELECT ecm311,ecm315 INTO l_ecm311,l_ecm315 FROM ecm_file
              WHERE ecm01=g_sfv[l_ac].sfv11
                AND ecm012= l_ecm012 
                AND ecm03 = l_ecm03  
             IF SQLCA.sqlcode THEN
                LET l_ecm311=0
                LET l_ecm315=0
             END IF
             LET l_ecm_out=l_ecm311 + l_ecm315
                          
             LET l_sfv09=0     #已key之入庫量(不分是否已過帳)
             SELECT SUM(sfv09) INTO l_qty1 FROM sfv_file,sfu_file
              WHERE sfv11 = g_sfv[l_ac].sfv11
                AND sfv01 ! = g_sfu.sfu01  
                AND sfv01 = sfu01
                AND sfu00 = '1'           #完工入庫
                AND sfuconf <> 'X'
             IF l_qty1 IS NULL THEN LET l_qty1 =0 END IF
             
             SELECT SUM(sfv09) INTO l_qty2 FROM sfv_file,sfu_file
              WHERE sfv11 = g_sfv[l_ac].sfv11
                AND sfv01 = g_sfu.sfu01   
                AND sfv03!= g_sfv[l_ac].sfv03
                AND sfv01 = sfu01
                AND sfu00 = '1'           #完工入庫
                AND sfuconf <> 'X' 
             IF l_qty2 IS NULL THEN LET l_qty2 =0 END IF
             
             LET l_sfv09 = l_qty1 + l_qty2 + g_sfv[l_ac].sfv09
             IF g_sfb.sfb93 = 'Y' THEN
                #入庫量 > 製程最後轉出量
                IF l_sfv09 > l_ecm_out THEN
                   LET g_msg ="(",l_sfv09   USING '############.###','>',    
                              l_ecm_out USING '############.###',")"        
                   IF NOT t620_chk_auto_report(g_sfv[l_ac].sfv11,g_sfv[l_ac].sfv09) THEN  
                      CALL cl_err(g_msg,'asf-675',1)
                      RETURN 0
                   END IF
                END IF
             ELSE
                CALL s_get_ima153(g_sfv[l_ac].sfv04) RETURNING l_ima153    
             #  CALL s_minp(g_sfv[l_ac].sfv11,g_sma.sma73,l_ima153,'','','') RETURNING g_cnt,l_sfb08               #FUN-C70037 mark 
                CALL s_minp(g_sfv[l_ac].sfv11,g_sma.sma73,l_ima153,'','','',g_sfu.sfu02) RETURNING g_cnt,l_sfb08   #FUN-C70037
                IF l_sfv09 > l_sfb08 THEN
                   LET g_msg ="(",l_sfv09   USING '############.###','>',  
                              l_sfb08 USING '############.###',")"         
                   CALL cl_err(g_msg,'asf-675',1)
                   RETURN 0
                END IF
             END IF                                                             	
          END IF                        
       END IF                           
    
    RETURN 1 
    
END FUNCTION 

#MOD-C30084--end

#FUN-CB0014---add---str---
FUNCTION t620_list_fill()
  DEFINE l_sfu01         LIKE sfu_file.sfu01
  DEFINE l_i             LIKE type_file.num10

    CALL g_sfu_l.clear()
    LET l_i = 1
    FOREACH t620_fill_cs INTO l_sfu01
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach item_cur',SQLCA.sqlcode,1)
          CONTINUE FOREACH
       END IF
       SELECT sfu01,'',sfu14,sfu02,sfu04,gem02,sfu08,sfu09,
              sfu16,gen02,sfu07,sfuconf,sfupost,sfu15,sfumksg
         INTO g_sfu_l[l_i].*
         FROM sfu_file
              LEFT OUTER JOIN gen_file ON sfu16 = gen01
              LEFT OUTER JOIN gem_file ON sfu04 = gem01
        WHERE sfu01=l_sfu01
       LET g_buf = s_get_doc_no(l_sfu01)
       SELECT smydesc INTO g_sfu_l[l_i].smydesc FROM smy_file WHERE smyslip=g_buf
       LET l_i = l_i + 1
       IF l_i > g_max_rec THEN
          IF g_action_choice ="query"  THEN  
            CALL cl_err( '', 9035, 0 )
          END IF                             
          EXIT FOREACH
       END IF
    END FOREACH
    LET g_buf = NULL
    LET g_rec_b2 = l_i - 1
    DISPLAY ARRAY g_sfu_l TO s_sfu_l.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
       BEFORE DISPLAY
          EXIT DISPLAY
    END DISPLAY

END FUNCTION

FUNCTION t620_bp2(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680121 CHAR(1)

   IF p_ud <> "G" THEN
      RETURN
   END IF

   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)

   DISPLAY ARRAY g_sfu_l TO s_sfu_l.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
      
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
             CALL t620_fetch('/')
         END IF
         CALL cl_set_comp_visible("page_list", FALSE)
         CALL cl_set_comp_visible("info,userdefined_field", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page_list", TRUE)
         CALL cl_set_comp_visible("info,userdefined_field", TRUE)
         EXIT DISPLAY

      ON ACTION ACCEPT
         LET g_action_flag = "page_main"
         LET l_ac2 = ARR_CURR()
         LET g_jump = l_ac2
         LET mi_no_ask = TRUE
         CALL t620_fetch('/')
         CALL cl_set_comp_visible("info,userdefined_field", FALSE)
         CALL cl_set_comp_visible("info,userdefined_field", TRUE)
         CALL cl_set_comp_visible("page_list", FALSE) 
         CALL ui.interface.refresh()                 
         CALL cl_set_comp_visible("page_list", TRUE)    
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
      ON ACTION first
         CALL t620_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(g_curs_index) 
           END IF
           ACCEPT DISPLAY                 
 

      ON ACTION previous
         CALL t620_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(g_curs_index)  
           END IF
	ACCEPT DISPLAY                  
 

      ON ACTION jump
         CALL t620_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(g_curs_index)  
           END IF
	ACCEPT DISPLAY                 
 

      ON ACTION next
         CALL t620_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(g_curs_index)  
           END IF
	ACCEPT DISPLAY                  
 

      ON ACTION last
         CALL t620_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(g_curs_index)  
           END IF
	ACCEPT DISPLAY                 
 
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
         CALL cl_show_fld_cont()                  
         CALL t620_def_form()   #FUN-610006
         CALL t620_pic() #圖形顯示 #FUN-660137
         EXIT DISPLAY

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
    #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
    #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
#@    ON ACTION 庫存過帳
      ON ACTION stock_post
         LET g_action_choice="stock_post"
         EXIT DISPLAY
#@    ON ACTION 過帳還原
      ON ACTION undo_post
         LET g_action_choice="undo_post"
         EXIT DISPLAY
#@    ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
#@    ON ACTION 領料產生
      ON ACTION gen_mat_wtdw
         LET g_action_choice="gen_mat_wtdw"
         EXIT DISPLAY
#@    ON ACTION 領料維護
      ON ACTION maint_mat_wtdw
         LET g_action_choice="maint_mat_wtdw"
         EXIT DISPLAY

      #FUN-BC0104---add---str
      #QC 結果判定產生入庫單
      ON ACTION qc_determine_storage 
         LET g_action_choice = "qc_determine_storage"
         EXIT DISPLAY
      #FUN-BC0104---add---end

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

      ON ACTION related_document                #No:FUN-6A0166  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY

      ON ACTION qry_lot
         LET g_action_choice="qry_lot"
         EXIT DISPLAY
      #FUN-A80128---add----str---
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
      #FUN-A80128---add----end---

      &include "qry_string.4gl"
   END DISPLAY

   CALL cl_set_act_visible("accept,cancel", TRUE)

END FUNCTION
#FUN-CB0014---add---end---

#FUN-CB0087--add--str--
FUNCTION t620_sfv44_check()
DEFINE l_flag        LIKE type_file.chr1       
DEFINE l_where       STRING                    
DEFINE l_sql         STRING                    
DEFINE l_n           LIKE type_file.num5
DEFINE l_azf09       LIKE azf_file.azf09       

   LET l_flag = FALSE 
   IF g_aza.aza115='Y' AND cl_null(g_sfv[l_ac].sfv44) THEN RETURN TRUE END IF
   IF g_aza.aza115='Y' THEN 
      CALL s_get_where(g_sfu.sfu01,g_sfv[l_ac].sfv11,'',g_sfv[l_ac].sfv04,g_sfv[l_ac].sfv05,g_sfu.sfu16,g_sfu.sfu04) RETURNING l_flag,l_where
   END IF 
   IF g_aza.aza115='Y' AND l_flag THEN
      LET l_sql = " SELECT COUNT(*) FROM ggc_file WHERE ggc08='",g_sfv[l_ac].sfv44,"' AND ",l_where
      PREPARE ggc08_pre1 FROM l_sql
      EXECUTE ggc08_pre1 INTO l_n
      IF l_n < 1 THEN
         CALL cl_err(g_sfv[l_ac].sfv44,'aim-425',1)
         RETURN FALSE 
      END IF
   ELSE 
      IF NOT cl_null(g_sfv[l_ac].sfv44) THEN
         SELECT COUNT(*) INTO g_cnt FROM azf_file
          WHERE azf01=g_sfv[l_ac].sfv44 AND azf02='2' AND azfacti='Y'
         IF g_cnt = 0 THEN
            CALL cl_err(g_sfv[l_ac].sfv44,'asf-453',0)
            RETURN FALSE 
        #str MOD-A60141 add
         ELSE
            SELECT azf03 INTO g_sfv[l_ac].azf03 FROM azf_file
             WHERE azf01=g_sfv[l_ac].sfv44 AND azf02='2' AND azfacti='Y'
        #end MOD-A60141 add
         END IF
         SELECT azf09 INTO l_azf09 FROM azf_file
          WHERE azf01=g_sfv[l_ac].sfv44 AND azf02='2' AND azfacti='Y'
         IF l_azf09 != 'C' THEN
            CALL cl_err(g_sfv[l_ac].sfv44,'aoo-411',0)
            RETURN FALSE 
         END IF
      ELSE  #料號如果要做專案控管的話，一定要輸入理由碼
         IF g_smy.smy59 = 'Y' THEN
            CALL cl_err('','apj-201',0)
            RETURN FALSE 
         END IF
      END IF
   END IF  
   RETURN TRUE 
END FUNCTION 

FUNCTION t620_sfv44_chkall()
DEFINE l_flag        LIKE type_file.chr1       
DEFINE l_where       STRING                    
DEFINE l_sql         STRING                    
DEFINE l_n           LIKE type_file.num5
DEFINE l_cnt         LIKE type_file.num5
DEFINE l_azf09       LIKE azf_file.azf09       

   IF g_sfv.getlength() = 0 THEN RETURN TRUE END IF 
   IF g_aza.aza115='Y' THEN 
      FOR l_cnt = 1 TO  g_sfv.getlength()
         CALL s_get_where(g_sfu.sfu01,g_sfv[l_cnt].sfv11,'',g_sfv[l_cnt].sfv04,g_sfv[l_cnt].sfv05,g_sfu.sfu16,g_sfu.sfu04) RETURNING l_flag,l_where
         IF l_flag THEN
            LET l_n = 0 
            LET l_sql = " SELECT COUNT(*) FROM ggc_file WHERE ggc08='",g_sfv[l_cnt].sfv44,"' AND ",l_where
            PREPARE ggc08_pre2 FROM l_sql
            EXECUTE ggc08_pre2 INTO l_n
            IF l_n < 1 THEN
               CALL cl_err('','aim-425',1)
               RETURN FALSE 
            END IF
         ELSE
            IF NOT cl_null(g_sfv[l_cnt].sfv44) THEN
               SELECT COUNT(*) INTO g_cnt FROM azf_file
                WHERE azf01=g_sfv[l_cnt].sfv44 AND azf02='2' AND azfacti='Y'
               IF g_cnt = 0 THEN
                  CALL cl_err(g_sfv[l_cnt].sfv44,'asf-453',0)
                  RETURN FALSE
              #str MOD-A60141 add
               ELSE
                  SELECT azf03 INTO g_sfv[l_cnt].azf03 FROM azf_file
                   WHERE azf01=g_sfv[l_cnt].sfv44 AND azf02='2' AND azfacti='Y'
              #end MOD-A60141 add
               END IF
               LET l_azf09 = ''
               SELECT azf09 INTO l_azf09 FROM azf_file
                WHERE azf01=g_sfv[l_cnt].sfv44 AND azf02='2' AND azfacti='Y'
               IF l_azf09 != 'C' THEN
                  CALL cl_err(g_sfv[l_cnt].sfv44,'aoo-411',0)
                  RETURN FALSE
               END IF
            #ELSE  #料號如果要做專案控管的話，一定要輸入理由碼
            #   IF g_smy.smy59 = 'Y' THEN
            #      CALL cl_err('','apj-201',0)
            #      RETURN FALSE
            #   END IF
            END IF
         END IF 
      END FOR
   END IF    
   RETURN TRUE 
END FUNCTION 
#FUN-CB0087--add--end-- 
