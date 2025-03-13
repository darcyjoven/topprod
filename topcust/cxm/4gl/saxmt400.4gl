# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: saxmt400.4gl
# Descriptions...: 合約/訂單維護作業
# Date & Author..: 94/12/22 By Danny
# Modify	 : 95/06/20 by nick 在csd重計時,有已發量及待發量的項次將不予列入
# Modify(V.2.0)..: 95/11/07 By Apple 取消確認時必須check 是否已出貨
# 應帶出符合該客戶的資料,2.其它資料中銷貨待驗收入應check match Y/N,
                   # CSD 應check match Y/N
                   # (1)增加自動確認&立即確認功能,(2)客戶編號改為10碼
                   # (3)將客戶品號轉為本公司品號
                   # (4)csd展開時show輸入金額和總金額差額
                   # (5)發票別不可空白
                   # (6)信用查核超限處理
                   # 增加備置欄位
# Modify.........: 99/07/05 By Carol 新增簽核功能
# Modify.........: 00/04/11 By Carol 新增報價單轉入
#                : 01-04-10 BY ANN CHEN B326 統一oea49的碼別
#                                            0.表開立/送簽中 1.已核淮
# Modify.........: 01/04/27 By Tommy No.B457 新增 D.拋轉請購單
# Modify.........: 02/08/16 By Kitty No.3795 新增 oeb904議價單價(定價)
# Modify.........: 02/08/16 By Kitty No.3795 新增 oeb904議價單價(定價)
# Modify.........: No:7677 03/08/08 Carol delete時,應判斷有無產生訂金
#                                         應收於 axrt300 (無論其確認否)
# Modify.........: No.FUN-4B0038 04/11/16 By pengu ARRAY轉為EXCEL檔
# Modify.........: No:7829 03/08/18 Carol 單據程式中呼叫單據自動編號時,
#                                         應該是要包覆在 BEGIN WORK
#                                         中(transaction)才會達到lock 的功能
# Modify.........: No:7578 03/08/29 Carol 訂單量100,有做備置量 60,後來修改訂單量
#                                         ->修改訂單量時顯示訊息提示,訂單量<備置
# Modify.........: No.7946 03/08/27 Kammy 多角貿易共用本支程式
#                  1.非多角訂單有 (1)一般 (2)換貨 (3)出至境外 (4)境外出貨 (5)BU
#                  2.多角訂單只有 (1)一般 (2)換貨
# Modify.........: No:8330 03/09/26 Carol 使用OUTER ima_file,要oeb04=ima_file.ima01才對
#                                         -->調整ora
# Modify.........: No:9436 04/04/09 Melody 原MOD遇大數時有問題,改寫
# Modify.........: No:9803 04/07/27 Wiky   訂單列印簡表時,程式原來的寫法就有考慮讓 user下查詢條件
#                                          但組sql 時,僅有考慮單頭條件,未考慮單身下的條件
# Modify.........: No.MOD-480274 04/08/10 Wiky 1.若客戶編號與送貨客戶不同時,送貨地址碼開窗後帶出資料後,按ENTER卻異常
# Modify.........: No:9864 04/08/18 ching  做複製時需將oea99清空
# Modify.........: No.MOD-490073 Kammy 境外倉出貨收款客戶未帶出，且轉入項次應可自動帶出資料
# Modify.........: No.MOD-490388 Wiky  1.品名規格有時會空白(檢查,INSERT/UPDATE),測試第一筆改完,又往前面修改方式
# Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.MOD-490485 04/10/04 By Yuna 麥頭代號開窗不會帶出
# Modify.........: No.MOD-4A0063 04/10/06 By Mandy q_ime 的參數傳的有誤
# Modify.........: No.FUN-4A0014 04/10/08 By Carol axmt4004 add CALL q_bma101()
#                                                  construct add call q_oea6()
# Modify.........: No.MOD-4A0213 04/10/14 By Mandy q_imd 的參數傳的有誤
# Modify.........: No.MOD-4A0252 04/10/19 By Smapmin 增加麥頭代號開窗功能,修正訂單單號開窗資料
# Modify.........: No.MOD-4B0043 04/11/04 By Mandy 做單身修正時,單頭有合約單號,輸入轉入項次後,無重新帶出產品編號...等值
# Modify.........: No.MOD-4A0299 04/11/19 By Echo 複製功能，並無判斷合約單號、訂單單號是否簽核
# Modify.........: No.MOD-4B0169 04/11/22 By Mandy check imd_file 的程式段...應加上 imdacti 的判斷
# Modify.........: No.FUN-4B0050 04/11/23 By Mandy 匯率加開窗功能
# Modify.........: No.MOD-4B0275 04/11/27 By Danny CALL q_coc2
# Modify.........: No.MOD-4B0293 04/11/30 By Carol 傳值呼叫另一隻程式時,參數應該用引號括起來,避免參數中的空白影響執行結果
# Modify.........: No.FUN-4C0057 04/12/09 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.MOD-4C0041 04/12/13 By Echo  查看"簽核狀況"的button
# Modify.........: No.MOD-4B0136 04/12/13 By Mandy 在進行功能鍵「受訂庫存明細查詢」時，系統應自動帶出所有訂單單身之料號，而不是讓使用者自行輸入料號查詢。
# Modify.........: No.FUN-4C0076 04/12/15 By pengu  匯率幣別欄位修改，與aoos010的aza17做判斷，
                                                    #如果二個幣別相同時，匯率強制為 1
# Modify.........: NO.FUN-4C0096 05/01/11 By Carol 修改報表架構轉XML
# Modify.........: NO.MOD-510128 05/01/18 By Carol 單身由報價單轉訂單,oqu02 應 = g_oeb[l_ac].oeb71(來源項次)
#                                                  不是g_oeb[l_ac].oeb03(訂單項次)
# Modify.........: No.MOD-510171 05/03/02 By Carrier 內銷時可以KEY手冊編號
# Modify.........: NO.FUN-530031 05/03/22 By Carol 單價/金額欄位所用的變數型態應為 dec(20,6),匯率 dec(20,10)
# Modify.........: NO.MOD-530369 05/03/29 By Mandy 修改客戶編號時, 送貨客戶應該比照收款客戶的方式一併異動.
# Modify.........: NO.MOD-530535 05/03/30 By Mandy 1.資料來源為5:報價單轉入時, 稅別/價格條件/收款條件/銷售分類一
#                                                  請根據客戶編號取客戶主檔的慣用稅別/價格條件/收款條件/銷售分類為Deafault值.
#                                                  2.資料來源為5:報價單轉入時, 單身由報價單自動轉為訂單, 未稅金額未計算.
# Modify.........: No.MOD-530870 05/03/30 By Smapmin 將VAR CHAR轉為CHAR
# Modify.........: No.MOD-4A0299 05/05/06 By Echo  複製功能，並無判斷合約單號、訂單單號是否簽核
#                                                  將送簽程式段獨立
# Modify.........: No.FUN-540049 05/05/11 By Carrier 雙單位內容修改
# Modify.........: No.FUN-550052 05/05/25 By wujie   單據編號加大
# Modify.........: No.FUN-550103 05/05/26 By Lifeng  料件多屬性內容修改
# Modify.........: No.FUN-550095 05/06/06 By Mandy 特性BOM
# Modify.........: No.MOD-560007 05/06/02 By Echo   重新定義整合FUN名稱
# Modify.........: No.FUN-560074 05/06/16 By pengu  CREATE TEMP TABLE 欄位放大
# Modify.........: No.MOD-530193 05/04/18 By Mandy 新增完整張單據後，再去修改稅別 (有可能其稅額有變，或者含稅改為未稅)，此時並未重新計算單身金額，以及單頭的未稅金額
# Modify.........: No.MOD-530194 05/04/18 By Mandy 條格條件的取價方式為"2:取產品價格檔訂價方式"在輸入訂單時，check產品價格檔中的國別
# Modify.........: No.MOD-550004 05/05/02 By Mandy 無法正確執行列印明細
# Modify.........: No.MOD-530157 05/05/09 By Mandy QR 查詢無法RUN
# Modify.........: No.MOD-520018 05/06/19 By Smamin 退補轉入,數量不可大於原銷退量
# Modify.........: No.FUN-560106 05/06/19 By wujie   單據編號加大
# Modify.........: No.FUN-560132 05/06/20 By wujie   單據編號加大
# Modify.........: No.FUN-570098 05/07/13 By Nicola 1.增加一個Action "其它資料",秀出單身的[其他資料]
# Modify.........: No.MOD-570405 05/08/03 By Nicola 右側的多角貿易按鍵,出現prompt 但沒有任何訊息
# Modify.........: No.MOD-570047 05/08/03 By Nicola "MPS轉入"功能Mark
# Modify.........: No.MOD-570192 05/08/04 By Nicola 取消oaz43的Mark
# Modify.........: No.MOD-570251 05/08/04 By Nicola 轉入之單據，應不可修改單位、取位放大
# Modify.........: No.MOD-570397 05/08/04 By Nicola 料件需在報價單中控管
# Modify.........: No.FUN-570020 05/07/04 By kim oea08修改時Noentry,選境外倉出貨訂單時,輸入客戶編號後帶出其他資料
# Modify.........: No.FUN-520002 05/08/05 By saki 自訂欄位功能範例
# Modify.........: NO.MOD-580085 05/08/11 By Rosayu 麥頭代號開窗挑完資料後,檢查不過,開窗改用q_ocf
# Modify.........: No.MOD-570260 05/08/11 By Rosayu
# Modify.........: No.MOD-570253 05/08/11 By Rosayu oeb08=>no use
# Modify.........: No.MOD-580021 05/08/15 By Nicola 銷售分類二新增開窗功能並顯示銷售名稱
# Modify.........: NO.MOD-570103 05/07/20 By Yiting 輸入業務員後，會自動帶出部門
# Modify.........: NO.MOD-570284 05/07/21 By Yiting NEXT FIELD時，卻跳到了另一個
# Modify.........: NO.MOD-580261 05/08/23 By Carrier set_oeb917有誤,沒有考慮不使用計價的情況
# Modify.........: NO.MOD-570250 05/07/21 By YITING 若訂單已有來源單據 ,重要欄位要秀訊息
# Modify.........: NO.MOD-580175 05/09/08 By Nicola 無使用多單位參數,單身修改後會出現aim-996 錯誤訊息
# Modify.........: No.MOD-590122 05/09/09 By Carrier set_origin_field修改
# Modify.........: NO.MOD-570396 05/09/12 By Nicola 選擇完業務員後，自動帶出部門代號
# Modify.........: NO.MOD-580145 05/09/12 By Nicola 修改產品編號後，重新取價
# Modify.........: No.FUN-580155 05/09/14 By Sarah 以EF為backend engine,由TIPTOP處理前端簽核動作
# Modify.........: No.MOD-590346 05/09/16 By Carrier mark du_default()
# Modify.........: No.MOD-580284 05/09/30 By Nicola 數量修改時，需重新取價
# Modify.........: No.MOD-570248 05/10/07 By Mandy 當取價是依價格表取價時,若異動數量,單價也要重新取
# Modify.........: No.MOD-590192 05/10/20 By Nicola 由報價轉入未帶收款客戶/起運/到達地 /交運方式
# Modify.........: No.MOD-590540 05/10/20 By Nicola 住址碼有輸入時，oap042不可輸入
# Modify.........: No.MOD-5A0001 05/10/20 By Nicola _u() 如原先地址碼(oea044)為MISC 有insert oap_file ,之後修改成不是 MISC ,應要將oap_file delete
# Modify.........: No.MOD-5A0083 05/10/21 By Nicola 無資料時，不可按其他資料
# Modify.........: No.FUN-5A0103 05/10/24 By Sarah 將oea904的controlp部分換成call q_poz1
# Modify.........: No.MOD-5A0271 05/10/24 By Rosayu 參數中'訂單單身儲存最大筆數'應放在after row 的interrupt之後判斷
# Modify.........: NO.MOD-590451 05/10/25 By Yiting  IF g_flag=1 THEN NEXT FIELD ofe04錯誤
# Modify.........: No.TQC-5B0117 05/11/17 By Echo 單據程式裡的「相關文件」button，在簽核時應顯示。
# Modify.........: No.TQC-5A0093 05/11/22 By Nicola oap041,oap042,oap043的值會被清空
# Modify.........: No.MOD-5A0137 05/11/23 By Rosayu 由合約轉訂單時,若已經轉過其中一部份的數量 ,第二次登打資料自動轉出的時候並未扣掉已轉出的數量(兩個單位都未扣除)
# Modify.........: No.MOD-5B0115 05/11/29 By Nicola 客戶單號輸入完後，需重show到主畫面
# Modify.........: No.TQC-5B0078 05/11/29 By Nicola 單身修改數量(由10->12->10)後,後面的金額欄位不會跟著換算
# Modify.........: No.MOD-5C0037 05/12/06 By Nicola 從估價單轉入時不會生成訂單總金額
# Modify.........: No.TQC-5C0014 05/12/07 By Carrier set_required時去除單位換算率
# Modify.........: No.FUN-5C0076 05/12/21 By wujie  增加oeb906欄位，判斷是否需要檢驗，并把此欄位值傳給出貨單
# Modify.........: No.FUN-610053 06/01/10 By Nicola 新增程式axmt401，傳入的參數為"A"
# Modify.........: No.FUN-610056 06/01/11 By Carrier 出貨驗收功能 -- 新增oea65
# Modify.........: No.FUN-610055 06/01/18 By Elva 分銷系統更改
# Modify.........: No.TQC-5C0103 06/01/23 By Nicola 計價數量會自己跑出來
# Modify.........: No.TQC-5C0104 06/01/23 By Nicola 不使用計價數量時，計價數量需等於單據數量
# Modify.........: No.TQC-5C0107 06/01/23 By Nicola 計價數量改變時，金額要跟著改變
# Modify.........: No.MOD-5C0150 06/01/23 By Nicola 修改時，g_tt_oeb12也要給值
# Modify.........: NO.MOD-610123 06/01/23 By PENGU 若來源單號不是NULL就要控制幣別欄位不允許輸入
# Modify.........: No.FUN-610055 06/03/07 BY Ray 訂單簡表格式修改
# Modify.........: No.FUN-640024 06/04/07 By Echo 新增流程訊息通知功能
# Modify.........: No.MOD-610149 06/04/03 By pengu 單身的含稅金額應卡關,不得小于未稅金額
# Modify.........: No.TQC-640085 06/04/08 By Elva 返利時不拋轉請購單
# Modify.........: No.FUN-640181 06/04/13 By Alexstar 若在「系統參數設定作業(aoos010)」裡未設定「簽核流程與EasyFlow串聯」，
#                                                     請"隱藏"整合單據作業裡的「EasyFlow送簽」及「簽核狀況」Button.
# Modify.........: No.FUN-640074 06/04/11 By Rayven 根據aqci150的設定來決定檢驗否
# Modify.........: No.FUN-610076 06/01/23 By Nicola 計價單位功能改善
# Modify.........: No.FUN-610002 06/01/23 By Nicola 使用多屬性料件(sma120='Y')時,訂單輸入料號時,應可開窗查詢貨號
# Modify.........: NO.FUN-5A0071 06/02/08 By yiting MENU 其它資料  改用多欄維護display
# Modify.........: No.FUN-620063 06/02/27 By Saki 自訂欄位功能
# Modify.........: No.FUN-630006 06/03/06 By Nicola oeb920有值，不可取消確認
# Modify.........: No.FUN-640013 06/03/27 By Lifeng 料件多屬性新機制修改
# Modify.........: No.FUN-630013 06/04/03 By pengu 查詢時,提供來源號碼可開窗
# Modify.........: No.FUN-640025 06/04/08 By Nicola 新增欄位oea37
# Modify.........: No.FUN-640048 06/04/08 By Sarah 將show0()段裡,原來CALL t400_oea1015()改掉
# Modify.........: No.MOD-640107 06/04/09 By Lifeng Fix Bug
# Modify.........: No.TQC-640132 06/04/18 By Nicola 日期調整
# Modify.........: No.MOD-640540 06/04/21 By wujie t320_b_get_price重新取價后，oeb17沒有更新
# Modify.........: No.TQC-640171 06/04/28 By Rayven 多屬性新增訂價編號判定
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.TQC-640013 06/04/25 By pengu ma116的值已改變為0,1,2,3 所以應改寫
# Modify.........: No.FUN-640259 06/04/28 By Sarah 其他資料畫面增加顯示oeb17(取得單價)
# Modify........,: No.MOD-640569 06/04/26 By Nicola 出貨改用況狀碼判斷 (by Clinton 060502)
# Modify.........: No.FUN-570069 06/05/04 By Sarah t400_out(),修改ON ACTION print_this_order里的g_msg
# Modify.........: No.TQC-650075 06/05/19 By Rayven 現將程序中涉及的imandx表改為imx表，原欄位imandx改為imx000
# Modify.........: No.TQC-650111 06/05/24 By Elva 單別去出后自動帶出是否計算業績
# Modify.........: No.FUN-650108 06/06/05 By Rayven 將atmt230和axmt410合并成一支程序
# Modify.........: No.FUN-640248 06/05/26 By Echo 自動執行確認功能
# Modify.........: No.TQC-650117 06/06/07 By Pengu axmt410 串axmr400時,單價金額無法印出
# Modify.........: No.MOD-650026 06/06/16 By Claire 查詢的資料再以其它資料鈕開窗,再以X關閉時,會將原單身資料清除
# Modify.........: No.MOD-540201 06/06/23 By Mandy 更新料件主檔的最近售價ima33
# Modify.........: No.TQC-660097 06/06/23 By Rayven 多屬性功能改進:查詢時不顯示多屬性內容
# Modify.........: No.FUN-650108 06/06/28 By Rayven cl_err --> cl_err3
# Modify.........: No.MOD-660156 06/07/03 By kim 修改單身時,第一數量不會跟著第二數量作轉變
# Modify.........: No.FUN-660216 06/07/11 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-670061 06/07/17 By kim GP3.5 利潤中心
# Modify.........: No.FUN-670063 06/07/20 By kim GP3.5 利潤中心
# Modify.........: No.MOD-670123 06/07/28 By Rayven 訂單單身筆數顯示不正確
# Modify.........: NO.FUN-670007 06/08/04 BY yiting 1.add oeb27/oeb28 2.改拋轉請購單畫面
#                                                   3.單頭新增(7.多角銷售轉入)
#                                                   4.若資料來源為1輸入，單身轉入項次改為「客戶訂單項次」並可輸入:
# Modify.........: No.FUN-680022 06/08/25 By cl     多帳期處理
# Modify.........: No.FUN-670099 06/08/28 By Nicola 價格管理處理
# Modify.........: No.FUN-660073 06/08/28 By Nicola 原因碼外顯可維護
# Modify.........: No.TQC-690018 06/09/05 By Rayven 隱藏有些程式不顯示的調貨客戶，代送商欄位

# Modify.........: No.FUN-680137 06/09/18 By bnlent 欄位型態用LIKE定義
# Modify.........: No.FUN-680057 06/09/18 By rainy 1.代入預設倉儲位
#                                                  2.未確認單據可按"其他資料"
# Modify.........: No.TQC-680107 06/09/22 By Rayven 修改流通配銷下axmr820,axmr830 CALL的參數
# Modify.........: No.FUN-690024 06/09/28 By jamie 判斷pmcacti
# Modify.........: No.FUN-690025 06/09/28 By jamie 改判斷狀況碼ima1010、occ1004
# Modify.........: No.FUN-690044 06/10/23 By rainy 取消BU間銷售
# Modify.........: NO.CHI-6A0016 06/10/26 BY yiting 訂單?轉請購單時,未default 統購否及拋轉否兩欄位的值='N'
#                  會造成所產生的請購單透過apmp500請購轉採購時,無法自動產生單身
# Modify.........: No.CHI-6A0004 06/11/06 By Czl g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0092 06/11/13 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0058 06/11/14 By day 在單價、金額截位后加顯示
# Modify.........: No.TQC-6A0045 06/11/15 By Claire 合約訂單檢驗否default 'N'
# Modify.........: No.FUN-6A0020 06/11/17 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.TQC-6B0046 06/11/21 By Judy 復制未控管，導致復制無法退出
# Modify.........: No.TQC-6B0117 06/11/21 By day 欄位加控管
# Modify.........: No.FUN-6B0065 06/11/21 By Ray atmi217并入aooi313(azf09,10,11,12,13取代tqe03,04,05,11,08)
# Modify.........: No.TQC-690060 06/11/24 By Sarah 當aza50='N',oea00='7'時,要可以帶出oea1015(代送商)
# Modify.........: NO.FUN-670007 06/12/01 by Yiting poz05取消使用/站別流程從第0站開始
# Modify.........: No.FUN-6A0151 06/12/04 By jamie 加show欄位oeb16"排定交貨日"
# Modify.........: No.FUN-690082 06/12/06 By Claire 列印時menu多一個放棄action
# Modify.........: No.MOD-6B0153 06/12/06 By Claire 傳參數錯誤
# Modify.........: No.MOD-680102 06/12/06 By Claire insert into pml_file pml190,pml192 default 'N'
# Modify.........: No.MOD-6A0087 06/12/06 By Claire mark不需給值
# Modify.........: No.TQC-690041 06/12/06 By Claire 由合約轉入時,l_qty需回傳,調整MOD-660090
# Modify.........: No.TQC-690027 06/12/06 By Claire 其它資料的抬頭會有多單位的顯示
# Modify.........: No.MOD-690033 06/12/05 By pengu 程式6578行sql語法錯誤
# Modify.........: No.CHI-690038 06/12/08 By pengu oea72不管是不是首次確認，均應於確認時更新成Today
# Modify.........: No.MOD-6B0151 06/12/11 By claire update oeb17改 oeb07
# Modify.........: No.MOD-6A0171 06/12/11 By claire oea11不需選項A訂單底稿
# Modify.........: No.MOD-680093 06/12/14 By pengu 2434行BUG單FUN-540049新增判斷式錯誤
# Modify.........: No.MOD-6A0080 06/12/14 By Mandy 做ckd/skd 時,insert 單身,有些欄位oeb920,oeb906給default
# Modify.........: No.TQC-6B0124 06/12/19 By pengu 參數勾選不使用多單位但使用計價單位時，計價單位與計價數量會異常
# Modify.........: No.TQC-6C0138 06/12/25 By Rayven 當流通配銷大陸版時，如果單別是勾選自動審核的，單身沒有走到返利單身就直接審核了
# Modify.........: No.TQC-6C0183 06/12/29 By chenl  修正查詢無效資料時報錯信息錯誤的bug。
# Modify.........: No.TQC-6C0217 06/12/28 By Rayven 點作廢沒有立即顯示作廢的圖標
# Modify.........: No.MOD-710012 07/01/03 By jamie 資料來源為合約轉入時，輸入時會帶錯oeb05_fac
# Modify.........: No.FUN-6C0006 07/01/10 By kim GP3.6產業別程式模組化(與aza50相關處理移至saxmt400dis.4gl)
# Modify.........: No.FUN-710037 07/01/17 By kim GP3.6 add saxmt400icd
# Modify.........: No.FUN-6C0050 07/01/29 By rainy 新增拋轉採購單功能
# Modify.........: No.TQC-710032 07/01/30 By Smapmin 雙單位畫面調整
# Modify.........: No.FUN-710046 07/02/02 By cheunl 錯誤訊息匯整
# Modify.........: No.FUN-710074 07/02/02 By kim 修正FUN-6C0006的問題
# Modify.........: No.FUN-720009 07/02/07 By kim 行業別架構調整
# Modify.........: No.CHI-6A0054 07/02/08 By rainy 作廢還原時檢查要還原的訂單來源是否也為2.退補，且銷退單號相同的未作廢訂單
# Modify.........: No.FUN-6A0136 07/02/12 By Nicola 增加一action"取消分配"
# Modify.........: No.MOD-720009 07/02/13 By pengu 訂單拋轉請購單時pml18會被default "1899/12/31"
# Modify.........: No.CHI-6B0006 07/02/14 By rainy 稅別更改時，訊問是否更新單價並重算，幣別匯率更改時，提示使用者要更改單身資
# Modify.........: No.FUN-730002 07/02/27 By kim 行業別架構調整
# Modify.........: No.FUN-720014 07/03/02 By rainy 地址擴充為5欄255
# Modify.........: No.FUN-720043 07/03/05 By Mandy APS整合調整
# Modify.........: No.FUN-730018 07/03/07 By kim 行業別試調整
# Modify.........: No.TQC-6B0105 07/03/09 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-730022 07/03/12 By rainy GP5.0新功能，修改拋轉請購單及採購單
# Modify.........: No.MOD-730043 07/03/14 By claire axm-033的判斷調整
# Modify.........: No.FUN-730012 07/03/16 By kim 將確認段和過帳段移到saxmt400_sub.4gl
# Modify.........: No.FUN-730018 07/03/27 By kim 行業別架構
# Modify.........: No.MOD-730103 07/04/04 By claire 補傳 l_qty
# Modify.........: No.MOD-710180 07/04/04 By claire obg07,obg08,obg22取值來自於occ21,occ20,occ22
# Modify.........: No.MOD-730075 07/04/04 By claire oeb916 誤寫oeb12 csd 取價問題
# Modify.........: No.TQC-740041 07/04/09 By claire get_price 的判斷修改
# Modify.........: No.TQC-6C0131 07/04/11 By pengu 未考慮計價數量的沖銷的情形
# Modify.........: No.FUN-740040 07/04/11 By Nicola 原因碼應只開出 azf02='2' 理由碼資料
# Modify.........: No.FUN-740046 07/04/12 By rainy pmn94->pmn24
# Modify.........: No.CHI-730002 07/04/12 By Smapmin 當類別＝出至境外倉時，單頭[出貨簽收]欄位default='N' 且設為noentry
# Modify.........: No.FUN-740053 07/04/12 By Nicola 原因碼改call q_azf
# Modify.........: No.FUN-740016 07/04/16 By Nicola 借出管理修改
# Modify.........: No.CHI-740014 07/04/16 By kim (多角訂單) oea905(多角拋轉否) 應不可輸入
# Modify.........: No.TQC-740127 07/04/18 By claire Easy Flow 開啟畫面時,action取消分配不可顯示
# Modify.........: No.TQC-740135 07/04/19 By arman 估價單、報價單轉入時候，單身不能自動帶出
# Modify.........: No.TQC-740152 07/04/20 By rainy GP5.0整合測試
# Modify.........: No.TQC-740202 07/04/22 By claire 原因碼的條件應同於qry的 azf02='2'
# Modify.........: No.TQC-740203 07/04/23 By elva 取消atmr231,atmr230
# Modify.........: No.MOD-740365 07/04/23 By Nicola q_pmc4傳回值不正確
# Modify.........: NO.MOD-740313 07/04/23 BY yiting 若不提供客戶簽收流程，則"客戶出貨簽收否"欄位應隱藏，以免造成誤解。
# Modify.........: No.MOD-740308 07/04/24 By Claire 由流通配銷合約轉入的訂單,不用check料號
# Modify.........: No.TQC-740281 07/04/24 By Echo 若由TIPTOP走簽核流程,APS Action要隱藏
# Modify.........: No.MOD-740114 07/04/25 By Mandy 料件的正確性控管,不應只限制在走流通配銷的參數內
# Modify.........: No.TQC-740227 07/04/25 By rainy 若訂單留置，確認時，不可執行流程自動化的自動拋轉作業
# Modify.........: No.FUN-740091 07/04/25 By rainy 流程自動化應過濾掉非axmt410的
# Modify.........: No.TQC-740302 07/04/25 By Sarah 串報表axmr401少傳參數
# Modify.........: No.MOD-740441 07/04/24 By claire 使用計價單位(ex,KPCS)由報價單轉入時,單位(ex,PCS)至訂單單身計價單位仍應為KPCS且計價數量要轉換為KPCS的數量
# Modify.........: No.TQC-740323 07/04/26 By Rayven 第一次單身使用搭贈類的原因碼，在這一行輸入完畢以后再回到原因碼的欄位修改成非搭贈類的，然后就離開當前行，這個時候金額是不會重新計算的，導致金額錯誤
# Modify.........: No.TQC-740349 07/04/28 By Rayven 若為帶出訂價編號也應先可以過"單位"欄位，返利單身的小數金額沒有截位
# Modify.........: No.TQC-750013 07/05/04 By Mandy 1.參數設不串APS時或axmt400或axmt420 Action "APS相關資料"不要出現
#                                                  2.一進入程式,不查詢直接按APS相關資料,當出
# Modify.........: No.FUN-750036 07/05/09 By rainy 商品借貨送貨單
# Modify.........: No.FUN-740034 07/05/14 By kim 確認過帳不使用rowid,改用單號
# Modify.........: No.TQC-750111 07/05/21 By rainy 單身由報價單轉入oeb906要default
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-750133 07/05/24 By jamie 按Action "拋轉請購單"或"拋轉採購單",因為留置[oeahold]而無動作,加show message
# Modify.........: NO.TQC-750157 07/05/25 BY yiting oeb900改為oeb920
# Modify.........: NO.TQC-750207 07/05/28 BY kim 合約轉入訂單時,合約單號開窗有誤
# Modify.........: No.TQC-750231 07/05/29 By wujie 刪除資料時，需同時更新mps的資料
# Modify.........: NO.TQC-750150 07/06/03 BY yiting 依package做法先不處理
# Modify.........: No.TQC-720023 07/06/05 By Echo 若此單別勾選自動確認時，新增單據完成時應詢問使用者「是否確認」而不該直接執行確認段。
# Modify.........: No.TQC-760132 07/06/14 By Judy 沒有根據客戶+債權帶出相應的稅種，收款條件
# Modify.........: No.MOD-760083 07/06/20 By claire 來源自報價單時應先帶入發票別及客戶簡稱
# Modify.........: No.TQC-760210 07/06/29 By wujie  合約單時，隱藏備置按鈕
# Modify.........: No.TQC-770039 07/07/06 By Rayven 稅種已設為無效,錄入此稅種無控管
# Modify.........: No.TQC-780001 07/08/01 By wujie  axmt410中，當在銷售參數檔axms100中勾選“訂單錄入時，依客戶品號轉換”，在下訂單時，目前無法錄入客戶料號通過。
# Modify.........: No.MOD-780014 07/08/02 By claire EasyFlow執行時遇到axm-802會造成執行結果與原據狀況不符
#                                                                     axm-104 修改同上
# Modify.........: No.TQC-710080 07/08/11 By pengu  當不使用計價單位時,若去修改請購單位時隱藏的計價單位不會跟著變動
# Modify.........: No.MOD-770007 07/08/24 By claire 由單身新增時自行帶報價單項次資料會沒帶出計價數量及計價單位
# Modify.........: NO.CHI-780042 07/08/27 BY yiting oeb1001理由碼不需為not null
# Modify.........: NO.MOD-780118 07/08/28 BY claire 維護oeb15時 oeb15也需調整
# Modify.........: NO.MOD-780272 07/08/29 BY claire oeb11的值被清空
# Modify.........: NO.MOD-780165 07/08/29 BY claire 調貨出貨代送商(oga1016)可以空白且可輸入
# Modify.........: NO.MOD-780155 07/08/30 BY yiting oeb1001要判斷流通配銷參數
# Modify.........: NO.MOD-790121 07/09/26 BY claire 使用母子單位依產品價格檔取價錯誤
# Modify.........: NO.MOD-7A0003 07/10/04 BY Carol 單身修改狀態下fetch資料後重新讀取料件ima_file的相關資料
# Modify.........: No.TQC-7A0009 07/10/05 By saki unicode區程式段缺
# Modify.........: No.MOD-7A0063 07/10/11 By Pengu 使用母子單位時oeb12的值會異常
# Modify.........: No.MOD-7A0074 07/10/15 By claire order_query加入權限控管
# Modify.........: No.CHI-7A0036 07/10/24 By Carol 金額計算的處理同AXR
# Modify.........: No.MOD-7A0155 07/10/29 By claire 合約主檔的單身oeb24應改為已訂數量而非已交數量
# Modify.........: No.CHI-7B0023/CHI-7B0039 07/11/14 By kim 移除GP5.0行業別功能的所有程式段
# Modify.........: No.FUN-7B0080 07/11/16 By saki 自定義欄位功能修改
# Modify.........: No.MOD-7B0155 07/11/16 By claire 新增時oeb16被清空是不合理的
# Modify.........: No.TQC-7B0136 07/11/26 By wujie  非搭增時單身金額應不小于數量*單價
# Modify.........: No.MOD-7B0216 07/11/26 By claire 報表傳入語言別有誤
# Modify.........: No.MOD-7C0023 07/12/05 By claire 寄銷訂單若已帶入預設倉庫不應再重取主要倉庫(ima35)
# Modify.........: No.TQC-7C0011 07/12/05 By Judy 已拋轉資料，取消審核時無錯誤提示信息
# Modify.........: No.TQC-7C0054 07/12/06 By Rayven 點擊“多角拋轉還原”無任何反應，亦無提示信息
# Modify.........: No.TQC-7C0069 07/12/07 By heather 點擊"多角貿易"后會彈出對話框"請按ENTER繼續",
#                                                     現在要求將這個對話框去掉
# Modify.........: No.TQC-7C0103 07/12/08 By Unicorn 增加ROLLBACK
# Modify.........: No.TQC-7C0098 07/12/08 By Judy 1.寄銷出貨時代送商不為必要輸入
#                                                 2.更改報錯信息"atm-028"->"atm-045"
#                                                 3.可修改訂單單價時，可手動輸入定價編號和單價
#                                                 4.出貨單身為非搭贈時，總金額不可修改
#                                                 5.單身單價要考慮單頭是否含稅
#                                                 6.出貨單身輸入提案取單價時，要加入幣別條件
#                                                 7.出貨單身有正常出貨和搭贈時，總金額欄位不可輸入
#                                                 8.出貨單身理由媽應該開出貨類型
#                                                 9.出貨單為寄銷出貨時，不可勾選客戶出貨簽收
# Modify.........: No.TQC-7C0118 07/12/08 By agatha 修改CALL cl_err3("sel","occ_file",g_oea.oea17,"",STATUS,"","select occ",1) 將status 替換成axm-177
# Modify.........: No.FUN-7B0142 07/12/10 By jamie不應在rpt寫入各語言的title，要廢除這樣的寫法(程式中使用g_rlang再切換)，報表列印不需參考慣用語言的設定。
# Modify.........: No.MOD-7B0201 07/12/12 By Carol oeb906欄位給值後應再display一次
# Modify.........: No.MOD-7C0196 07/12/26 By claire axmr401只印出對外公司名稱
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-810016 08/01/31 By hongmei 增加oebislk01
# Modify.........: No.FUN-810045 08/02/13 rainy 項目管理，單身新增專案代號oeb41/WBS編號oeb42/活動代號oeb43
# Modify.........: No.FUN-7C0017 08/02/26 By bnlent 新增ICD行業字段
# Modify.........: No.FUN-7B0018 08/02/16 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-820046 08/03/05 By xumin 增加混合包裝和二維單身錄入功能
# Modify.........: No.FUN-820033 08/03/10 By wujie 返利改善，增加“生成現返”，“生成物返”，“物返結案”三個功能
# Modify.........: No.FUN-7B0077 08/03/12 By mike  新增ICD功能
# Modify.........: No.MOD-810066 08/03/19 By claire 新增單身時輸入其它資料的出貨倉儲批, 待寫入後就不該再重取ima35,ima36的資料
# Modify.........: No.MOD-810072 08/03/19 By claire 需加入小數取位再判斷
# Modify.........: No.MOD-810088 08/03/19 By claire 使用客戶品號轉換(oaz46)規格調整
# Modify.........: No.MOD-810135 08/03/19 By claire 來源以報價單轉入時,oeb1012應給值,以免造成AR無法立帳
# Modify.........: No.MOD-820174 08/03/20 By claire 確認時,判段的錯誤訊息顯示
# Modify.........: No.MOD-830183 08/03/24 By claire 應使用g_oeb_t.oeb03,否則會有axm-073的錯誤
# Modify.........: No.FUN-830089 FUN-840036 08/03/27 By xumin  單頭二維輸入欄位修改時管控
# Modify.........: No.FUN-840011 08/04/02 By saki 單身自定義欄位範例
# Modify.........: No.MOD-840060 08/04/08 By claire 於項次時,按確定應為不寫入
# Modify.........: No.MOD-840077 08/04/10 By claire 取消確認時排除已作廢的帳款資料
# Modify.........: No.FUN-830116 08/01/31 By hongmei 修改oebislk01為非必輸欄位
# Modify.........: No.CHI-840015 08/04/18 By claire 使用參考單位時,修改單位一(銷售)單位時,應更新單位一的轉換率,以oeb05不以ima31
# Modify.........: No.MOD-840073 08/04/09 By chenl 多角貿易下，隱藏"拋轉請購單,拋轉采購單"兩個按鈕.
# Modify.........: No.MOD-840473 08/04/21 By kim 因單頭的幣別可能會更改,單身單價不管事後有無修改都應該重計金額
# Modify.........: No.MOD-840574 08/04/22 By hellen 客戶代號沒有任何卡關，但是到出通知單時，會卡occ06性質必為1.買受人才能填，
#                                                   若是要卡關，在訂單就開始卡關。
# Modify.........: No.FUN-840210 08/04/25 By kim 若該幣別的匯率檔取不到匯率資料，應該設定錯誤訊息
# Modify.........: No.FUN-840128 08/04/28 By Carrier 拋轉采購單成功后,要即時將采購單及數量顯示在單身上
# Modify.........: No.CHI-840073 08/04/29 By claire 單價比取得單價低時,要停在單價欄位
# Modify.........: No.MOD-850014 08/05/05 By claire 需加入小數取位再判斷
# Modify.........: No.MOD-850198 08/05/20 By Carrier sma908判斷時,加入sma120='Y'的額外判斷
# Modify.........: No.FUN-850128 08/05/26 by sherry 選擇類別為 "借貨還價" , 輸入資料來源為 : 借貨訂單 ,
#                                                   但是, 開窗看不到 借貨訂單資料
# Modify.........: No.FUN-850027 08/05/30 By douzh WBS編碼錄入時要求時尾階并且為成本對象的WBS編碼
# Modify.........: No.FUN-840165 08/06/02 By xiaofeizhu 類別為8或者9時動態地顯示title“借貨申請單資料”以及報表改為CR
# Modify.........: No.FUN-850100 08/05/19 By Nicola 批/序號管理第二階段
# Modify.........: NO.MOD-860078 08/06/06 BY Yiting ON IDLE 處理
# Modify.........: No.MOD-860114 08/06/12 By Smapmin 無法連續列印二次
# Modify.........: No.MOD-860171 08/06/16 By Smapmin axmt420無法複製
# Modify.........: No.FUN-860096 08/06/24 By xiaofeizhu axmt420打印時選擇“打印訂單變更單”時，報表動態變換title內容為"借貨申請單資料"
# Modify.........: No.MOD-870031 08/07/02 By Smapmin 修改檢驗(oeb906)輸入與否的判斷
# Modify.........: No.MOD-870034 08/07/03 By Smapmin 當oeb1012為NULL時,預設為'N'
# Modify.........: No.FUN-840184 08/07/07 By xiaofeizhu oeb11不需做隱藏的管控，直接顯示
# Modify.........: No.MOD-860316 08/07/08 By Sarah CALL cl_flow_notify(g_oea.oea01,'D')時,g_oea.oea01已被清空,需在g_oea清空前LET l_oea01=g_oea.oea01,cl_flow_notify改傳l_oea01
# Modify.........: No.MOD-860095 08/07/10 By claire 拋請購單及拋採購單的Action,若為最終訂單且沒有最終供應商的設定才可以使用
# Modify.........: No.MOD-870139 08/07/11 By Smapmin 備品料號不可與訂單銷售料號相同.
# Modify.........: No.MOD-830073 08/07/14 By jan  將show函數內對表進行更新操作的語句mark。對單頭金額的統計已經在單身中存在，此處已不再需要做統計。且show函數內不該出現update的動作。
# Modify.........: No.FUN-840183 08/07/14 By xiaofeizhu axmt410在新增時，訂金條件、尾款條件帶出做為預設
# Modify.........: No.MOD-870175 08/07/14 By Smapmin 複製時,單身請購單號與請購數量要清空
# Modify.........: No.MOD-820066 08/07/15 By jan  修改金額計算，將單價*折扣率后的單價進行取位后再與數量相乘得到金額。
# Modify.........: No.MOD-830016 08/07/15 By jan  修正MOD-820066。需判斷折扣率是否為null，若為null則應該賦值為100
# Modify.........: No.MOD-870229 08/07/21 By Smapmin 約定交貨日,應卡關不可小於訂單日期
# Modify.........: No.MOD-880038 08/08/06 By Smapmin 訂單來源為合約單時,訂單數量應考慮與合約單單位換算的問題
# Modify.........: No.MOD-880064 08/08/12 By Pengu 資料來源為估價單轉入時單價未依單頭含稅否存放正確值
# Modify.........: No.MOD-880102 08/08/13 By lumx 修改產品編號時候 直接點擊確定沒有更新客戶產品編號
# Modify.........: No.MOD-880123 08/08/15 By claire 單身自定義欄位新增時未寫回oeb_file
# Modify.........: No.FUN-870117 08/08/20 By chenyu 服飾版單頭增加出口國欄位
# Modify.........: No.MOD-820125 08/02/25 By chenl  對取價后的單價進行取位。
# Modify.........: No.TQC-890035 08/09/16 BY DUKE 移除 APS 相關資料ACTION
# Modify.........: No.MOD-890150 08/09/18 By Smapmin 更改報表temp table定義的位置
# Modify.........: No.MOD-890137 08/09/19 By Smapmin 客戶產品編號(oeb11)無法維護
# Modify.........: No.FUN-890011 08/10/14 By xiaofeizhu 由估價單/報價單轉入時，要檢查客戶是否存在於正式客戶資料(occ_file)中，如未存在顯示錯誤訊息并不允許新增
# Modify.........: No.MOD-8A0144 08/10/16 By Smapmin 輸入完單身資料後開窗輸入其他資料時,無法update oeb_file
# Modify.........: No.MOD-8A0137 08/10/17 By chenl   若計價單位與銷售單位一致，則計價數量等于銷售數量，不必通過轉換取得，以避免尾數。
# Modify.........: No.MOD-8A0154 08/10/17 By chenl   若使用計價單位，則取價時應以計價單位為主。
# Modify.........: No.MOD-8A0098 08/10/22 By wujie  設定單別綁定屬性群組時，修改多屬性料件欄位，開窗返回的還是未修改的老料號
# Modify.........: No.TQC-8A0073 08/10/29 By claire 若以借貨訂單要帶出單身時,無法帶出
# Modify.........: No.MOD-8A0267 08/10/31 By sherry 在call t400_two_uygur()前加入判斷是否使用多屬性料件
# Modify.........: No.MOD-8B0048 08/11/10 By Smapmin 料號若未更改,檢驗否欄位不需重新帶出
# Modify.........: No.FUN-8B0035 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910
# Modify.........: No.MOD-8C0003 08/12/02 By Smapmin 客戶編號輸入時,不應限制只能輸入買受人
# Modify.........: No.MOD-8C0053 08/12/05 By Smapmin 修改其他資料裡的客戶產品編號,但並未update到資料庫
# Modify.........: No.CHI-8B0015 08/12/11 By xiaofeizhu 在axmt410判斷如oea00='6' 則 oea65 不可輸入，且設為"N"
# Modify.........: No.MOD-8C0118 08/12/15 By Smapmin 取消留置後未重新查詢,留置的變數未更新導致判斷錯誤
# Modify.........: No.MOD-8C0193 08/12/22 By Smapmin 複製後版號應default為0
# Modify.........: NO.FUN-8C0078 08/12/23 BY yiting add oea918訂金立帳分期/oea919尾款立帳分期
# Modify.........: No.TQC-910038 09/01/16 By xiaofeizhu axmt420借貨償價(oea00='9')訂單之倉庫批預設為oeb09=oaz78，oeb091=" "，oeb092=oea03
# Modify.........: NO.FUN-920041 09/02/04 By ve007 列印明細時會列出重復的資料
# Modify.........: No.MOD-920047 09/02/04 By Smapmin 訂單單號存在出貨單單頭/單身時,皆不能取消確認
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.MOD-920091 09/02/06 By Smapmin 執行單身其他資料action之後,要停留在原先的欄位
# Modify.........: No.MOD-920281 09/02/23 By Smapmin 確保跑ON ROW CHANGE段
# Modify.........: No.MOD-920301 09/02/24 By Smapmin 使用多單位時,無法使用價格表取價
# Modify.........: No.CHI-930018 09/03/11 By jan 解決執行 axmt410_icd 打印 [打印明細]，會出現報表檔案路徑無效 的錯誤
# Modify.........: No.MOD-930071 09/03/12 By Pengu 新增時無法修改檢驗碼
# Modify.........: No.FUN-920186 09/03/20 By lala  理由碼oeb1001必須為銷售原因
# Modify.........: No.MOD-930223 09/03/25 By Dido oea65 需增加 oea901 = 'Y' 時預設值為 'N'
# Modify.........: No.MOD-940052 09/04/07 By Dido oea00 為 4.境外倉出貨訂單, 不可以點選 carry_po,carry_pr action
# Modify.........: No.MOD-940118 09/04/09 By lutingting單身得轉入項次,若在修改時,不應再預設為1或NULL
# Modify.........: No.MOD-940151 09/04/12 By Dido 將報價單客戶料號(oqu04)轉至訂單客戶料號(oeb11)中
# Modify.........: No.MOD-940312 09/04/23 By Smapmin 抓取庫存量時,要用SUM(img10*img21)
# Modify.........: No.MOD-940271 09/04/20 By Smapmin g_oeb17的值未重新抓取
# Modify.........: No.MOD-940263 09/04/22 By Dido oeb14與oeb14t須先取位後再計算
# Modify.........: No.MOD-940276 09/04/22 By Dido 串至出至境外倉訂單取 oea10
# Modify.........: No.TQC-940120 09/04/24 By sherry 其它資料action打不開
# Modify.........: No.MOD-940385 09/04/30 By Smapmin 抓取產品客戶檔(obk_file)時,應加上幣別條件的判斷
# Modify.........: No.TQC-950002 09/05/04 By chenyu b_ima918應該為b_ima921
# Modify.........: No.TQC-950020 09/05/13 By mike 跨庫的SQL語句一律使用s_dbstring()的寫法
# Modify.........: No.FUN-940008 09/05/17 By hongmei 發料改善
# Modify.........: No.FUN-960007 09/06/03 By chenmoyan global檔內沒有定義rowid變量
# Modify.........: No.TQC-950054 09/06/22 By jan 單身更改時，ICD行業欄位更改不成功
# Modify.........: No.TQC-960137 09/06/12 By lilingyu sql語句中請增加關聯oea_file
# Modify.........: No.MOD-960187 09/06/17 By Dido 取消確認執行 axmp810 條件應與 restore action 一致
# Modify.........: No.MOD-940234 09/06/24 By mike 當訂單類別為9.借貨償價時,資料來源oea11應該要默認為8.借貨訂單,oea12要為必輸欄>
# Modify.........: No.MOD-960262 09/06/24 By Dido 料號異動時 oeb904 依 oeb13 異動
# Modify.........: No.FUN-960066 09/07/02 By Mandy 若單據需要跟EASYFLOW整合，將"信用額度"的檢查時間點調整為=>按下EASYFLOW送簽按鈕當下
# Modify.........: No.MOD-960046 09/07/07 By Smapmin 使用多單位且料件為單一單位時,單位一的轉換率有錯誤
# Modify.........: No.TQC-960401 09/07/07 By lilingyu 依原來設計,若不先輸入料號,應該單身輸入客戶產品編號后,
# ...................................................會自動從obk_file帶出料號,銷售單位等欄位,不過目前此功能無效
# Modify.........: No.MOD-960225 09/07/09 By Smapmin 單身oeb71名稱顯示問題
# Modify.........: No.TQC-970111 09/07/13 By lilingyu 輸入完單頭后就報錯:無法將NULL值插入到oea_file
# Modify.........: No.MOD-970142 09/07/16 By Smapmin 新增完後執行列印,應印出該筆新增的資料
# Modify.........: No.MOD-970154 09/07/21 By Dido 複製時 oea00,oea08 不可維護
# Modify.........: No.MOD-970229 09/07/24 By Dido t400_mixed_wrap() 應僅限用於 SLK 行業別
# Modify.........: No.FUN-870007 09/07/27 By Zhangyajun 流通零售功能修改
# Modify.........: No.CHI-970074 09/08/03 By mike axmt410手動登打類別為4.境外倉出貨時,或是出至境外倉出貨單確認時自動產生境外倉出貨訂
#                                                 都要將檢驗碼default為'N'
# Modify.........: No.MOD-980022 09/08/04 By mike 將IF l_count < 1 THEN ....END IF的判斷拿掉.
# Modify.........: No.CHI-960007 09/08/12 By mike 發現訂單不定時出現計價數量／計價單位為null值的情況
# Modify.........: No.TQC-980055 09/08/17 By lilingyu 1.返利單身錄入,確定后,返利單身的資料丟失 2.返利單身有資料的情況,含稅欄位的值顯示到了非直營KAB欄位上
# Modify.........: No.TQC-8C0091 09/08/18 By hongmei 同FUN-8C0078
# Modify.........: No.MOD-980150 09/08/19 By Dido 取消作廢邏輯更新 oeb_file 問題調整
# Modify.........: No.FUN-960130 09/08/27 By Sunyanchun 取價
# Modify.........: No.TQC-980181 09/08/21 By sherry 賬務資料頁簽“定金應收比例、出貨應收比例”應該控管為不可輸入負數！
# Modify.........: No.TQC-980182 09/08/21 By sherry 幣種后面的匯率欄位輸入負數沒有控管！
# Modify.........: No.TQC-980149 09/08/31 By lilingyu "交運方式"欄位旁需增加一個欄位,并且自動帶出值
# Modify.........: No.TQC-980184 09/08/31 By lilingyu "允許超交率"欄位輸入負數及超過100沒有控管
# Modify.........: No.FUN-980010 09/08/31 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.CHI-970015 09/09/01 By Dido 依據不同訂單類型開窗
# Modify.........: No.MOD-990022 09/09/02 By sherry 修改單頭的客戶后，增加提示，請用戶確認單身的單價
# Modify.........: No.FUN-960038 09/09/04 By chenmoyan 專案加上'結案'的判斷
# Modify.........: No.MOD-980285 09/09/07 By mike oeb17=oeb13應取消，否則將導致復制后之oeb17被改變與原單據不同，如此在確認段做低於單
# Modify.........: No.MOD-990026 09/09/07 By mike 若換貨訂單單身料號相同有多筆會卡住
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-980029 09/08/05 By baofei 1.刪除段增加刪除tqw_file
#                                                   2.把自動編號放在事物中
# Modify.........: No.MOD-990184 09/09/29 By Smapmin 訂單變更單要依不同行業別執行不同的程式
# Modify.........: No.CHI-960022 09/10/15 By chenmoyan 預設單位一數量時，加上判斷，單位一數量為空或為1時，才預設
# Modify.........: No:MOD-9A0154 09/10/26 By Smapmin oeb19 default 為N
# Modify.........: No:MOD-9A0165 09/10/27 By Smapmin 單頭"其他資料"ACTION,oebislk01只有在slk行業別時才update
# Modify.........: No:CHI-9A0052 09/11/02 By Smapmin 畫面沒有a1015_cs這個欄位
# Modify.........: No.FUN-9B0016 09/11/08 By Sunyanchun post no
# Modify.........: No:CHI-980019 09/11/05 By jan 虛擬料件不可做任何單據
# Modify.........: No:MOD-9B0110 09/11/18 By Smapmin 輸入完資料來源的單號後,要再檢核一下訂單單號是否正確
# Modify.........: No:MOD-9B0185 09/11/30 By Smapmin 境外倉出貨訂單分批產生
# Modify.........: No:FUN-9B0025 09/12/02 By Cockroach oeb48 0-->1,1-->2 和添加對 oeb13的管控
# Modify.........: No:MOD-9C0016 09/12/03 By mike 原有的零售管控非成本仓拿掉
# Modify.........: No:FUN-9C0064 09/12/14 By Cockroach oha87 改为开窗录入
# Modify.........: No:FUN-9C0082 09/12/16 By Cockroach 自动带出单身报错
# Modify.........: No:FUN-9C0083 09/12/16 By mike 取价call s_fetch_price_new()
# Modify.........: No:FUN-9C0090 09/12/16 By Cockroach mark cancle_price
# Modify.........: No:FUN-9C0120 09/12/21 By mike 通过价格条件管控单价栏位未取到价格时是否可以输入
# Modify.........: No:MOD-9C0326 09/12/24 By Smapmin 單身原因碼若屬於樣品時，建議不受取出單價控管
# Modify.........: No:MOD-9C0204 09/12/24 By Smapmin 境外倉出貨訂單的數量不可大於出至境外倉出貨單的數量
# Modify.........: No:MOD-9C0388 09/12/24 By Dido 於 oea01 時顯示 oaydesc
# Modify.........: No:FUN-9C0073 10/01/07 By chenls 程序精簡
# Modify.........: No:FUN-A10014 10/01/05 By Carrier 资料来源为2.退补时,自动产生单身
# Modify.........: No:TQC-A10104 10/01/11 By Carrier 输入杂项客户时,按"退出"会使单头输入完后,无法保存的现象
# Modify.........: No:FUN-A10110 10/01/26 By Cockroach 訂購單新增【折價明細】按鈕
# Modify.........: No:FUN-A10106 10/02/01 By destiny 订单新增赠品发放按钮      
# Modify.........: No:TQC-A20002 10/02/03 By cockroach 點【更改】時,oeb13應該不可更改,以及金額應在單價或數量更改后從新自動帶出
# Modify.........: No:MOD-A10123 10/02/03 By Smapmin oeb1006若為空時,default 100
# Modify.........: No:CHI-A10002 10/02/23 By sabrina 確認時,無倉儲批的錯誤訊息請加上料號,當單身筆數很多時,會查不出是哪一筆的問題
# Modify.........: No.TQC-A20058 10/02/25 By Cockroach lpj05的條件不完全
# Modify.........: No:CHI-880006 10/02/25 By Smapmin 在產品客戶檔(obk_file)有對應資料,且檢驗否(obk11)為Y時,才允許維護檢驗碼(oeb906)
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:MOD-A30026 10/03/05 By Smapmin 延續MOD-8C0003的調整
# Modify.........: No:MOD-A30087 10/03/15 By Smapmin 修改來源單號後,單身若已有資料,詢問是否刪除
# Modify.........: No.TQC-A30041 10/03/16 By Cockroach add oriu/orig
# Modify.........: No.FUN-A20044 10/03/20 By jiachenchao 刪除字段ima26*
# Modify.........: No.TQC-A30149 10/04/02 By lilingyu 一般訂單作業,“尾款應收比率”欄位應控管不可更改
# Modify.........: No:TQC-A30155 10/04/02 By houlia  增加大陸版本的時候oea212的錄入查詢資料
# Modify.........: No:MOD-A30147 10/04/14 By Smapmin 單據複製時,匯率要重抓
# Modify.........: NO.MOD-A30239 10/04/14 By Smapmin 出至境外倉訂單要能輸入代送商
# Modify.........: No:CHI-990037 10/04/14 By Smapmin 還原TQC-960401
# Modify.........: No.FUN-A40041 10/04/20 By wujie     g_sys->AXM
# Modify.........: No:MOD-A40121 10/04/21 By Smapmin 沒有使用計價單位時,畫面不可呈現計價數量
# Modify.........: No:TQC-A40113 10/04/22 By lilingyu 訂單復制時,未情況已分配量oeb920,導致無法取消審核
# Modify.........: No:TQC-A40142 10/04/29 By houlia oea212調整顯示資料
# Modify.........: No:MOD-A50014 10/05/05 By Smapmin 借貨訂單,單頭資料來源為1.輸入.借貨償價,單頭資料來源為8.借貨訂單
# Modify.........: No:FUN-A40055 10/05/10 By destiny 将construct和单身显示改为dialog写法
# Modify.........: No:MOD-A50009 10/05/10 By sabrina CALL s_signx1為舊的簽核功能，目前已不使用
# Modify.........: No.FUN-A50071 10/05/19 By vealxu GP5.2 相關程序增加POS單號字段 并管控如果不為空的情況下 不可取消審核與取消過帳
# Modify.........: No:TQC-A50060 10/05/20 By houlia 調整稅種oea21開窗資料顯示 
# Modify.........: No.FUN-A50054 10/05/25 By chenmoyan 增加服饰版二维功能
# Modify.........: No:FUN-A50103 10/06/03 By Nicola 訂單多帳期 1.取消訂單/尾款分期立帳欄位 2.增加訂單多帳期維護 3.增加訂金/出貨/尾款應收金額欄位
# Modify.........: No.FUN-A60027 10/06/08 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No:CHI-A50004 10/06/24 By Summer 在確認/取消確認時,將lock資料的動作往前移至FUNCTION的一開始
# Modify.........: No:FUN-A60035 10/07/01 By chenls INSERT INTO oeb之前檢查oeb44
#                                                   slk行业下考虑项次问题
# Modify.........: No.FUN-A50102 10/07/23 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:FUN-A60035 10/07/28 By chenls 服飾版二維功能mark
# Modify.........: No:MOD-A70112 10/07/29 By Smapmin 複製後要回到舊資料的畫面
# Modify.........: No:MOD-A50128 10/07/30 By Smapmin 由報價單轉入資料時,要考慮單位轉換率
# Modify.........: No:MOD-A60146 10/07/30 By Smapmin 訂單類別與訂單單別必須一致
# Modify.........: No:MOD-A70041 10/07/30 By Smapmin 由報價單default單身資料的方式要一致.
# Modify.........: No:MOD-A50092 10/07/30 By Smapmin 修改單身項次時,要連動修改選配件資料的對應
# Modify.........: No:FUN-A70146 10/08/02 By lilingyu 增加“單價查詢”action,通過輸入訂單項次,自動帶出"銷售價格明細查詢作業"axmq411
# Modify.........: No:MOD-A70164 10/07/21 By Carrier s_t400oeo时,加传订单单身数量
# Modify.........: No:TQC-A70029 10/08/03 By lilingyu  由客戶編號回推料號等資料時,加入單頭的幣別去obk_file 抓取資料
# Modify.........: No:CHI-A60026 10/08/03 By Summer 變更價格條件時，詢問是否update單價 
# Modify.........: No:CHI-A70030 10/08/03 By Summer 延續CHI-A60026,訂單單頭的金額沒有一併update
# Modify.........: No:FUN-A80024 10/08/09 By wujie  增加oeb32栏位
# Modify.........: No:MOD-A80124 10/08/16 By Smapmin oeb906為空時,未給N
# Modify.........: No:FUN-A80056 10/08/18 By destiny 資料來源為報價單時,幣別,稅別等皆抓取報價單上的資料
# Modify.........: No:FUN-A80102 10/08/18 By kim GP5.25號機管理
# Modify.........: No:FUN-A80054 10/08/25 By jan GP5.25工單合拼--新增oeb918欄位
# Modify.........: No.FUN-A80121 10/08/25 By shenyang  單身選擇料件可以多選，多選后自動生成多筆單身資料
# Modify.........: No.MOD-A80183 10/09/03 By lilingyu 經營方式欄位沒有帶出值
# Modify.........: No:FUN-A70132 10/09/08 By lixh1   增加“單身稅別明顯”按鈕
# Modify.........: No:MOD-A10134 10/09/28 By sabrina 在判斷排定交貨日oeb16為空時，將oeb05/oeb12回押oeb916/oeb917，
#                                                    會造成有使用雙單位時的單價錯誤
# Modify.........: No.FUN-A90048 10/09/29 By huangtao 修改料號欄位控管以及開窗
# Modify.........: No.FUN-A90040 10/10/08 By shenyang 添加單位編號和商戶編號兩個欄位
# Modify.........: No.FUN-AA0047 10/10/20 By Huangtao 修改料號管控bug
# Modify.........: No.TQC-AA0101 10/10/21 By lilingyu 1.單身欄位"折扣率"改為"配銷折扣率"(當流通配銷參數='Y'時)
#                                                     2.當營運中心的業態<>'2'時,隱藏action"可發贈品,單身稅別明細,折價明細,取消折價"
# Modify.........: No.TQC-AA0118 10/10/21 By lilingyu 1.若訂單為流通配銷的合約訂單時,單身的客戶項次可以不輸入值
#                                                     2."產生物返"action,諸多sql語法錯誤,以及程序邏輯更改
# Modify.........: No.TQC-A80141 10/10/21 By lilingyu 若是配銷合約時,不需要提示"是否由合約轉入訂單內容"的訊息和相關邏輯 
# Modify.........: No.TQC-AA0025 10/10/22 By lilingyu 1.合約訂單的截止日期判斷有誤 2.若債權對於的產品及其產品系列不符時,手工輸入會出現'atm-018'的提示,但開窗不會出現 
#                                                     3.在錄入單身"提案編號"後,程式判別單價抓取,若抓取不到,則加err msg     
#                                                     4.在錄入單身"產品編號"後,程式立即判別單價,但尚未輸入數量未產生計價數量,所以程式一定會卡住
# Modify.........: No:FUN-AA0038 10/10/22 By Nicola 訂金/尾款多帳期時，無分期資料不要詢問
# Modify.........: No.FUN-A30072 10/10/25 By jan 單價不可低于設定的最低單價
# Modify.........: No.TQC-AA0135 10/10/28 By lilingyu 單身無法新增
# Modify.........: No:MOD-AA0180 10/10/28 By Smapmin 修改計價單位與計價數量沒有值的問題
# Modify.........: No:MOD-AA0054 10/10/28 By Smapmin 由obk01預設給oeb04時,未給予ima相關的變數值
# Modify.........: No:MOD-AA0128 10/10/28 By Smapmin occ1029改由occ66取代
# Modify.........: No:FUN-AA0048 10/10/28 By Carrier GP5.2架构下仓库权限修改
# Modify.........: No:TQC-AA0139 10/11/01 By lilingyu AFTER INSERT 段oeb71,oeb04的判斷邏輯調整至確認段
# Modify.........: No:TQC-AA0128 10/11/04 By Carrier oeb1006赋值100
# Modify.........: No.FUN-AA0089 10/11/04 By suncx  單身選擇料件可以多選，多選后自動生成多筆單身資料,资料抓取修改
# Modify.........: No:FUN-AB0011 10/11/08 By huangtao 從庫存抓取資料前做料號控管
# Modify.........: No:TQC-AB0045 10/11/12 By lilingyu 選擇"資料來源"後,光標會移到合約單號的欄位,但這個欄位判別的原則是需加入客戶代號作為判別來源,這樣在輸入順便有點怪,
#                                                     現調整為"輸入合約只判別合約是否存在,之後才在客戶代號欄位判別此合約的客戶和訂單的客戶是否相同"(幣別欄位相同情況) 
# Modify.........: No.FUN-AB0061 10/11/16 By vealxu 增加基础单价oeb37和修改分摊折价计算
# Modify.........: No:MOD-AB0018 10/11/23 By Smapmin 帳款客戶編號不能選擇已停止交易的客戶
# Modify.........: No:MOD-A90080 10/11/23 By Smapmin 修改銷售性質後重抓匯率
# Modify.........: No:MOD-A80202 10/11/23 By Smapmin 多單位時也要做MOD-9C0204的控卡
# Modify.........: No:MOD-A80145 10/11/23 By Smapmin 計算已新增換貨訂單數量時,未排除作廢單據
# Modify.........: No:MOD-A80149 10/11/24 By Smapmin 修正錯誤訊息顯示內容
# Modify.........: No:FUN-AB0039 10/11/25 By lixh1   當程式代碼為"axmt410"時,"單身稅別明細"Action 才顯示,否則隱藏
# Modify.........: No:TQC-AB0025 10/11/26 By chenying 修改Sybase問題
# Modify.........: No:MOD-AB0233 10/11/26 By Dido 若訂金比率為 100 則 oea07 應為 'N' 
# Modify.........: No:TQC-AB0170 10/11/29 By lixh1   當留置碼oeahold不為空時才彈出'取消留置'提示
# Modify.........: No:TQC-AB0286 10/11/30 By wangxin after field oea12帶出後面的資料
# Modify.........: No:TQC-AB0407 10/12/02 By wuxj   insert tqn_file前判断tqn01,tqn02 是否为空
# Modify.........: No:TQC-AC0034 10/12/03 By lilingyu 單身"折扣"頁簽page07,在g_aza.aza26='0'時,不需隱藏
# Modify.........: No:TQC-AC0030 10/12/03 By lilingyu 产生现返时,t400_cash_cs4 cursor,foreach时,不可在回圈中加入commit,这样会造成无穷回圈 
# Modify.........: No:TQC-AC0028 10/12/03 By lilingyu 产生现返时,計算折扣金額的時候,折扣率tqr05應先除以100再進行計算
# Modify.........: No:TQC-AC0031 10/12/03 By lilingyu 产生现返时,會抓取預設現金折扣單別,若抓不到時需顯示error message,並且跳離現返作業(目前程式會卡,無法往下運作)
# Modify.........: No:TQC-AB0204 10/11/30 By shiwuying 单身折扣率oeb1006修改后，更新单价oeb13
# Modify.........: No:FUN-AC0012 10/12/03 By shiwuying 單價按鈕修改單價后,INSERT一筆到rxc_file,rxc03='13'
# Modify.........: No:FUN-AA0057 10/12/06 BY shenyang  修改q_lnt06_1 傳入參數
# Modify.........: No:TQC-AB0368 10/12/08 By wangxin   流通配銷勾選時也帶出oea12後面資料
# Modify.........: No:FUN-AB0096 10/12/14 By shiwuying 稅別明細按鈕只有azw04=2才顯示
# Modify.........: No:TQC-AC0139 10/12/15 By suncx 單身出貨倉庫修改後，游標移至下一筆時會回復原狀
# Modify.........: No:TQC-AC0163 10/12/15 By huangtao  INSERT INTO oeb_file時，有些字段未賦初值
# Modify.........: No:TQC-AC0035 10/12/16 By lilingyu 錄入"現金折扣單"欄位時,不需要加arg3:訂單單號
# Modify.........: No:TQC-AC0153 10/12/16 By huangtao 調整現返管控
# Modify.........: No:TQC-AC0251 10/12/17 By lilingyu 資料來源為3:合約轉入時,訂單單身無法由合約單自動帶出資料
# Modify.........: No:TQC-AA0040 10/12/17 By houlia 對oeb47、oeb48賦初值
# Modify.........: No:MOD-AC0151 10/12/18 By huangtao 單身輸入資料報錯無法繼續進行
# Modify.........: No:MOD-AC0180 10/12/18 By suncx p_qry的查詢條件資料錄入有誤，oea12開窗無資料
# Modify.........: No:MOD-AC0205 10/12/20 By shiwuying 查询画面最下方几个栏位显示异常
# Modify.........: No:MOD-AC0314 10/12/27 By chenying 輸入按確認 (跳到單身),此時單頭的價格條件、收款條件、業務、部門的說明都未自動帶出來
# Modify.........: No:MOD-AC0170 10/12/28 By shiwuying 現金折扣項次,料號DEFAULT 'MISC' 數量DEFAULT '1'方式處理
# Modify.........: No:FUN-AC0097 10/12/29 By shenyang 修改bug
# Modify.........: No:MOD-AC0316 10/12/30 By huangtao 料號未作轉換之前就做判斷
# Modify.........: No.MOD-AC0381 11/01/05 By Smapmin 複製時,oebi_file的資料無法完全複製
# Modify.........: No:CHI-AC0036 11/01/06 By Smapmin 信用查核要納入送簽中的單據
# Modify.........: No:TQC-B10013 11/01/06 By shiwuying 
# Modify.........: No:FUN-B10010 11/01/06 By shenyang 右邊單價按鈕的畫面中顯示基礎單價;
# Modify.........: No:FUN-B10014 11/01/07 By shiwuying 零售才写rxc_file
# Modify.........: No:TQC-B10066 11/01/10 By shiwuying 现返栏位赋预设值
# Modify.........: No:MOD-B20074 11/02/17 By Summer 借貨出貨/借貨償價訂單,因為都不會有簽收流程,故改為-->單頭[出貨簽收]欄位default='N' 且設為noentry
# Modify.........: No:MOD-B20125 11/02/22 By lilingyu 新增一筆訂單資料,沒有正確產生多帳期資料
# Modify.........: No:FUN-A50013 11/03/07 By Lilan EF整合ICD
# Modify.........: No:TQC-B30088 11/03/09 By lilingyu ICD行業別的程式段,where條件有誤,導致執行axmt410_icd無法顯示單身
# Modify.........: No:MOD-B30116 11/03/11 By suncx 修正尾款金額為負數的BUG 
# Modify.........: No:MOD-B30131 11/03/11 By Summer 新增單頭時，oea07預設為N
# Modify.........: No:MOD-B30121 11/03/11 By baogc 控管資料來源項中的9.POS拋轉的顯示
# Modify.........: No:MOD-B30127 11/03/11 By lixia axmt410及axmt810流通零售時,oeacont 隱藏掉
# Modify.........: No:MOD-B30166 11/03/11 By Summer 非鞋服業不要顯示『二維輸入』 
# Modify.........: No:MOD-B30224 11/03/12 By suncx 增加合約轉訂單報錯信息
# Modify.........: No.MOD-B30347 11/03/14 By lixia 合約轉入時修改訂單日期時增加失效日期判斷
# Modify.........: No.MOD-B30466 11/03/14 By chenying 修改合約轉入時,單身欄位[轉入項次]報錯信息的判斷
# Modify.........: No.MOD-B30297 11/03/14 By chenying Action'更改單價'修改完單身單價後，也要重算單頭訂金/出貨/尾款金額
# Modify.........: No.MOD-B30440 11/03/15 By Summer 控卡已產生至一般訂單的合約訂單不可取消確認 
# Modify.........: No.MOD-B30404 11/03/15 By Summer 於AFTER INPUT段再做一次axm-987的控卡,若是匯率小於等於0就NEXT FIELD幣別 
# Modify.........: No.MOD-B30428 11/03/15 By chenying 訂單Action[修改價格]修改
# Modify.........: No.MOD-B30443 11/03/16 By baogc 修改取价函数的调用
# Modify.........: No.FUN-B30012 11/03/16 By huangtao 促銷贈品發放和退還邏輯調整
# Modify.........: No:MOD-B30277 11/03/17 By Summer oea00 MATCHES '[123467]'時開窗出來的資料要加上ima130 <> '0' 
# Modify.........: No:MOD-B30451 11/03/17 By Summer 在自動產生單身時,判斷若是分量計價的狀況,給一個提示訊息 
# Modify.........: No:MOD-B30616 11/03/20 By lilingyu 單頭選擇CKD/SKD時然後選擇SKD單階展開,報錯
# Modify.........: No:CHI-B30081 11/03/22 By Smapmin 從報價單將地址預先帶入訂單
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:MOD-B30045 11/04/06 By baogc INSERT oeb_file時的BUG修改
# Modify.........: No:FUN-B20060 11/04/07 By zhangll 單身增加oeb72
# Modify.........: No:FUN-B40028 11/04/12 By xianghui  加cl_used(g_prog,g_time,2)
# Modify.........: No:TQC-B40118 11/04/20 By lixia 增加計劃批號截止量-起始量=訂單的數量管控
# Modify.........: No:MOD-B40222 11/04/25 By lilingyu 查詢時,無法查到下屬虛擬庫的單據
# Modify.........: No:TQC-B40205 11/04/25 By lilingyu EF簽核相關問題修改
# Modify.........: No:TQC-B40220 11/04/28 By lixia 計劃批號管控修改
# Modify.........: No:FUN-AC0074 11/05/03 By jan 若單據有備置，不可取消確認
# Modify.........: No:FUN-B50046 11/05/13 By abby APS GP5.25 追版 str-----
# Modify.........: No:FUN-9B0084 09/11/18 By Mandy 新增Action "APS單據追溯"
# Modify.........: No:FUN-B50046 11/05/13 By abby APS GP5.25 追版 end-----
# Modify.........: No:MOD-B50051 11/05/24 By wujie 更改出货金额时更新出货金额比例
# Modify.........: No:FUN-B50168 11/05/26 By lixiang 隱藏axmt410的oeb37和其他資料（axmt4005_memo）的oeb17
# Modify.........: No:MOD-B60057 11/06/08 By JoHung axm-983的控卡應是在合約轉入的條件
# Modify.........: No:MOD-B50114 11/06/15 By Summer 做複製動作後再按新增時，oea08欄位被控卡無法輸入
# Modify.........: No:MOD-B60123 11/06/15 By yangxf 多餘字段 
# Modify.........: No:MOD-B60138 11/06/16 By zhangll 單頭oea261,oea262欠缺考慮含稅否
# Modify.........: No:MOD-B60153 11/06/17 By guoch mark掉oeb04處TQC-AA0025
# Modify.........: No:TQC-B60112 11/06/17 By wuxj  截止日期應大於訂單日期
# Modify.........: No:MOD-B60172 11/06/20 By JoHung 取消確認時將留置碼清空
# Modify.........: No.TQC-B60101 11/06/22 By lixiang oeaslk01在SLK行业别下不可见
# Modify.........: No.TQC-B60298 11/06/23 By jan for gp5.25 axmt410右邊的"備置"，應該改串axmi611
# Modify.........: No:MOD-B70045 11/07/06 By Summer 複製時按放棄後,再按新增oea08無法輸入
# Modify.........: No.CHI-B70016 11/07/12 By xianghui 程式處理單身新增多筆資料時，一並處理行業別table
# Modify.........: No.MOD-B70114 11/07/13 By zhangll 單頭定金金額更新有误
# Modify.........: No.MOD-B70126 11/07/15 By suncx   更改單價後未同步更新訂金多帳期和尾款多帳期金額
# Modify.........: No:MOD-B70089 11/07/12 By JoHung 資料來源為3,7,8時，才控卡單身訂單項次有無填寫對單位的控卡
# Modify.........: No:FUN-B70058 11/07/20 By zhangll 增加oah07控制
# Modify.........: No:FUN-B70087 11/07/21 By zhangll 增加oah07控管，s_unitprice_entry增加传参
# Modify.........: No:MOD-B70181 11/07/29 By JoHung t400_ef()第二個ROLLBACK WORK改為COMMIT WORK
#                                                   修改程式檢核不過的部分
# Modify.........: No:TQC-B80019 11/08/02 By lixia 複製時單頭SQL中oea01賦值有誤
# Modify.........: No:MOD-B80036 11/08/04 By johung 訂單日期修改時重抓匯率
# Modify.........: No:CHI-B70039 11/08/04 By joHung 金額 = 計價數量 x 單價
# Modify.........: No:CHI-B80016 11/08/11 By johung 依s_mpslog判斷是否取消異動
# Modify.........: No:MOD-B80154 11/08/16 By Summer FUNCTION t400_chk_oeb71中增加oeb11,ima021給值 
# Modify.........: No:MOD-B80131 11/08/16 By johung 修正數量變更不會重新取價
# Modify.........: No:MOD-B80185 11/08/18 By johung 還原MOD-B50051，修改訂金金額、出貨金額不回推比率
# Modify.........: No:MOD-B80096 11/08/29 By Summer 金額取位用t_azi04 
# Modify.........: No:MOD-B80098 11/08/29 By Summer 輸入第2筆單身料號有錯誤訊息時,第1筆的料號品名會顯示為第2筆的資料 
# Modify.........: No:MOD-B90023 11/09/06 By johung 金額欄位不允許修改
# Modify.........: No:CHI-B80050 11/09/09 By johung t400sub_y_upd增加參數p_inTransaction
# Modify.........: No:MOD-B90091 11/09/13 By suncx EasyFlow送簽BUG修正
# Modify.........: No:FUN-B90101 11/09/20 By Lixiang 服飾改成二維的形式
# Modify.........: No:TQC-B90236 11/10/21 By Zhuhao 新增ACTION 指定料件特性 單身AFTER ROW 后加判斷及某些特定條件這個ACTION隱藏
# Modify.........: No:FUN-BA0094 11/10/24 By huangtao 上傳訂單，在一般訂單維護作業中查詢的時候不用重新計算訂金金額
# Modify.........: No:MOD-BB0245 11/11/22 By ck2yuan 刪除訂單,將oeaa_file的資料一併刪除
# Modify.........: No:MOD-B90196 11/11/23 By Vampire oea41,oea42,oea43 自動帶出
# Modify.........: No:MOD-BB0119 11/11/23 By Vampire 單價ACTION卻仍是可以打負數
# Modify.........: No:MOD-BB0136 11/11/23 By Vampire 轉入訂單時,有重抓稅別,但稅率還是用客戶的慣用稅別
# Modify.........: No:MOD-BB0254 11/11/23 By Vampire 複製時，備置(oeb19)應更新為N，備置量(oeb905)應更新為0
# Modify.........: No:MOD-BC0307 12/01/05 By suncx 單身料號選料件帶入的客戶產品編號BUG
# Modify.........: No:MOD-C10041 12/01/06 By suncx 需控管不允許錄入規格組件
# Modify.........: No:FUN-BC0130 12/01/15 By yangxf 更新税别时添加三个条件，以及更新含税价与未税价，在单身新增、修改、删除的同时更新oeg_file 
# Modify.........: No:FUN-910088 11/10/13 By fengrui 增加數量欄位小數取位
# Modify.........: No:FUN-BC0071 12/01/30 By huangtao 取消確認時check禮券或抵現積分
# Modify.........: No:FUN-BB0086 12/02/01 By tanxc 增加數量欄位小數取位
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C20006 12/02/03 By lixiang 服飾二維BUG修改(對多屬性料件的判斷，製造業開啟的畫面等)
# Modify.........: No:TQC-C20117 12/02/10 By lixiang 服飾BUG修改
# Modify.........: No:FUN-C20028 12/02/13 By Abby EF功能調整-客戶不以整張單身資料送簽問題
# Modify.........: No:TQC-C20172 12/02/14 By lixiang 服飾BUG修改
# Modify.........: No:MOD-C20047 12/02/15 By suncx t400_multi_ima01()中給oeb32賦預設值
# Modify.........: No:MOD-B90197 12/02/15 By bart (abm-731)要改為卡關不能只是提示
# Modify.........: No:MOD-B90228 12/02/15 By Summer 修正MOD-AC0314 
# Modify.........: No:MOD-BA0103 12/02/15 By Summer 自動帶出至境外倉單身資料,oea61沒有更新 
# Modify.........: No:MOD-BB0023 12/02/15 by Summer 在新增時重新給g_success值 
# Modify.........: No:MOD-BB0060 12/02/15 By Summer FUN-A40055此單將CONSTRUCT改成DIALOG的寫法時,少了條件儲存ACTION 
# Modify.........: No:MOD-BB0122 12/02/15 By Summer 修改地址碼欄位按確定後，其值都會回寫成空值 
# Modify.........: No:MOD-BB0337 12/02/15 By Summer 還原MOD-B70181,UPDATE oea49='S'是為了CALL t400sub_hu1檢查信用查核,但檢查完後應該還原,故需用ROLLBACK WORK 
# Modify.........: No:TQC-BB0132 12/02/17 By destiny 更改单价时总停在第一行如果预设改后的单价和原单价一样会报错，但是可能只修改其他项次的单价
# Modify.........: No:TQC-BA0033 12/02/17 by destiny 每查询一次发票联数栏位就会增加3个选项
# Modify.........: No:TQC-BC0038 12/02/17 By destiny 更改时进入oea12后会报oea01单号重复
# Modify.........: No:TQC-BB0062 12/02/17 By destiny 输入完订金应收比率后订金金额栏位会为空
# Modify.........: No:FUN-C20098 12/02/20 By huangtao 刪除需要重新取價
# Modify.........: No:MOD-B90148 12/02/20 By Vampire 於訂單輸入時(q_occ)能做過濾處理未確認或已留置
# Modify.........: No:MOD-BA0120 12/02/20 By Vampire 取消作廢時與確認時增加控卡axm-383,數量大於出至境外倉的數量時不可取消作廢或確認
# Modify.........: No:MOD-BB0008 12/02/20 By Vampire 修改 t400_bu UPDATE 語法
# Modify.........: No:MOD-BB0336 12/02/20 By Vampire 新增時排定交貨日oeb16帶的預設值為約定交貨日oeb15，oeb16不為空時才帶oeb15值
# Modify.........: No:TQC-BC0054 12/02/20 By Vampire 排定交貨日期與約定交貨日相同時不再詢問
# Modify.........: No:MOD-BC0210 12/02/20 By Vampire 合約訂單轉入訂單時,單頭oea12欄位排除oea49=2結案的就整筆不能轉入
# Modify.........: No:MOD-C10031 12/02/20 By Vampire 修正MOD-AC0314,還原MOD-B90228mark的程式
# Modify.........: No:MOD-C20043 12/02/20 By Vampire 換貨訂單增加控卡必須存在銷退單的料件
# Modify.........: No:CHI-BC0041 12/02/20 By Vampire 當oaz43有勾選時才開啟axmt811
# Modify.........: No:MOD-C20123 12/02/20 By Vampire "出貨計入未開發票待驗收入"與"客戶出貨簽收"兩個選項不能同時勾選！
# Modify.........: No:MOD-C20139 12/02/20 By Vampire 在FUNCTION t400_copy()的BEGIN WORK前加LET g_success='Y'
# Modify.........: No:TQC-C20183 12/02/21 By fengrui 數量欄位小數取位處理 
# Modify.........: No:TQC-C20339 12/02/21 By lixiang BUG 修改
# Modify.........: No:TQC-C20348 12/02/22 By xjll    服飾流通業商品策略，價格策略的修改以及開窗的修改
# Modify.........: No:TQC-C20341 12/02/22 By zhuhao  cl_err錯誤信息維護
# Modify.........: No:TQC-C20385 12/02/22 By zhuhao  Action"指定料件特性"開窗時，不可新增刪除，且項次、特性代碼不可維護
# Modify.........: No:TQC-C20490 12/02/23 By lixiang 服飾非多屬性料件的倉庫庫存檢查
# Modify.........: No:MOD-C10178 12/02/29 By jt_chen axm-806出至境外倉出貨單轉為境外倉出貨訂單,訂單數量為0->不轉入
# Modify.........: No:MOD-C10165 12/02/29 By jt_chen 客戶代號變更時,發票別oea05請重新抓取客戶慣用發票別(occ08)
# Modify.........: No:MOD-C20055 12/02/29 By jt_chen 修正單別設定"自動確認"時,狀況碼依舊為0.開立的問題
# Modify.........: No:TQC-C20418 12/03/05 By huangrh 修改服飾行業SQL-BUG
# Modify.........: No:TQC-C30100 12/03/05 By yangxf  修改單身不能新增，oeb14沒有給值
# Modify.........: No:TQC-C30106 12/03/06 By yangxf  單身攤位檢查時，攤位對應的合同必須是統一收銀；預租期內的攤位商戶也可以錄入
# Modify.........: No:TQC-C30114 12/03/07 By huangrh 服飾流通單身可以錄入重複的母料件
# Modify.........: No:MOD-C30137 12/03/10 By yangxf  單身輸提案編號時check 若價格條件沒有客戶提案時,不允許輸入
# Modify.........: No:MOD-C30188 12/02/10 By yangxf  自動產生的現金折扣單部門別取 oea15,人員取 oea14
# Modify.........: No:TQC-C30196 12/03/10 By lixiang 服飾新增時錄入資料后，再返回來更改母料件,需將後面的數值金額欄位等重新賦值 
# Modify.........: No:MOD-C30319 12/03/10 By lixiang 服飾母料件單身中的倉儲批的檢查
# Modify.........: No:MOD-C30146 12/03/10 By yangxf  維護客戶編號時依客戶預設帶出
# Modify.........: No:MOD-C30217 12/03/10 By lixiang 控管數量欄位數量不可小於零和多屬性單身bug修改
# Modify.........: No:MOD-C30132 12/03/10 By yangxf  產生現返及物返均要判斷若合約有輸入合約編號時才詢問
#                                                    (包括訂單存檔時的詢問及按現返及物返 action 時控卡可否點選)
# Modify.........: No:MOD-C30298 12/03/14 By yangxf  修改BUG(單身存檔產生現金折扣單時，出現key值重覆的err msg。)
# Modify.........: No:MOD-C30153 12/03/12 By yangxf  當g_aza.aza50 = 'Y' AND g_oea.oea11 = '3'時，開開窗多選并回傳值
# Modify.........: No:MOD-C30219 12/03/12 By yangxf  補齊主鍵條件 
# Modify.........: No:MOD-C30779 12/03/20 By SunLM   axm-581報錯,從pmm檢查時，增加pmm909=3的條件
# Modify.........: No:FUN-C30235 12/03/20 By bart 單身備品比率及SPARE數要隱藏
# Modify.........: No:FUN-C30278 12/03/28 By bart 判斷imaicd05改為判斷imaicd04
# Modify.........: No:FUN-C30289 12/04/03 By bart 所有程式的Multi Die隱藏
# Modify.........: No:MOD-C40035 12/04/05 By SunLM 加入客戶編號,從obk_file抓取obk11"檢驗否"的資料
# Modify.........: No:TQC-C10065 12/04/09 By SunLM 在FUNCTION t400_b()的BEFORE ROW 後面的BEGIN WORK前加LET g_success='Y'
# Modify.........: No:TQC-C40144 12/04/18 By yuhuabao 單身沒有權限新增的時候，點確定畫面會down掉
# Modify.........: No:FUN-C30161 12/04/23 By lixiang 母單身增加oebslk15，交貨日期欄位
# Modify.........: No:MOD-C40191 12/04/24 By Elise 判斷單身有資料時才CALL t400_fetch_price
# Modify.........: No:MOD-C40129 12/04/25 By Elise 程式中列印output功能沒有權限控管應該加上
# Modify.........: No:TQC-C40240 12/04/26 By zhuhao 修改SQL-BUG
# Modify.........: No:TQC-C40246 12/04/26 By zhuhao 送貨客戶編號代出對應的客戶簡稱
# Modify.........: No.FUN-C40089 12/05/02 By bart 判斷銷售價格條件(axmi060)的oah08,若oah08為Y則單價欄位可輸入0;若oah08為N則單價欄位不可輸入0
# Modify.........: No:TQC-C40197 12/05/07 By qiaozy oeaslk02不可修改
# Modify.........: No:FUN-C30053 12/05/08 By pauline 當選擇流通配銷參數時,料號開窗只顯示對應債權範圍內資料
# Modify.........: No:FUN-BC0088 12/05/10 By Vampire 判斷MISC料可輸入單價
# Modify.........: No.FUN-C50074 12/05/18 By bart 更改錯誤訊息代碼
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.TQC-C50221 12/05/28 By zhuhao 結案時對應的圖片變更
# Modify.........: No:FUN-C40072 12/05/29 By Sakura axmt810多角新增"客戶出貨簽收oea65"功能
# Modify.........: No:TQC-C60042 12/06/05 By yangtt 控卡select oea錯誤的地方,增加判斷oea00=g_argv1條件
# Modify.........: No:MOD-C40009 12/06/11 By Vampire g_oeb17 重抓該筆訂單項次的oeb17
# Modify.........: No:MOD-C40077 12/06/15 By Vampire 取消確認時請排除已作廢的訂單變更單
# Modify.........: No:MOD-C60213 12/06/27 By Vampire oea11='3'時,oea00的條件='0',oea11='8'時,oea00的條件=g_oea.oea11
# Modify.........: No:MOD-C60161 12/06/27 By Vampire 出至境外倉訂單分批轉成兩張境外倉出貨訂單未稅金額與含稅金額並無跟著修正
# Modify.........: No:FUN-C60100 12/06/27 By qiaozy 服飾流通：快捷鍵controlb的問題，切換的標記請在BEFORE INPUT 賦值
# Modify.........: No.FUN-C60046 12/06/18 By bart sma94控制是否顯示指定特性料件
# Modify.........: No.FUN-C50136 12/07/03 By xujing 取消確認時從oib_file刪除該訂單號的所有信用異動記錄
# Modify.........: No:FUN-C30085 12/07/10 By nanbing CR改串GR
# Modify.........: No:CHI-C50018 12/07/10 By Elise 當報價單轉入時,如果客戶產品編號是空的才重新抓取axmi151
# Modify.........: No:FUN-C70045 12/07/12 By yangxf 单据类型调整
# Modify.........: No:FUN-C70065 12/07/16 BY huangrh 服飾製造，報價單轉訂單時，oebi03賦值有誤
# Modify.........: No:TQC-C70205 12/07/30 By dongsz 控管歸還日期欄位oeb30
# Modify.........: No:TQC-C70220 12/08/10 By dongsz 有非作廢的退補單的換貨訂單后不能再複製
# Modify.........: No.FUN-C80045 12/08/17 By nanbing 檢查POS單別，不允許在ERP中錄入
# Modify.........: No:FUN-C80046 12/08/20 By bart 複製後停在新資料畫面
# Modify.......... No:CHI-C80060 12/08/27 By pauline 令oeb72預設值為null
# Modify.........: No:TQC-C80128 12/09/04 By dongsz 訂單日期欄位需控卡axm-330
# Modify.........: No:FUN-C90011 12/09/05 By baogc 單身添加欄位"交貨日期/oeb51"
# Modify.........: No:TQC-C90016 12/09/06 By yangxf 所屬營運中心名稱在查询后未显示
# Modify.........: No:TQC-C90053 12/09/10 By zhuhao 資料來源為2.退補時欄位的控管及關聯欄位及時顯示
#                                                   以及oea05欄位的及時顯示
# Modify.........: No:TQC-C90021 12/09/13 By yangxf 调整画面，新增数量，含税金额
# Modify.........: No:MOD-C90105 12/09/13 By suncx t400_price()函數中，調用s_fetch_price_new(）傳入參數錯誤
# Modify.........: No:MOD-C70108 12/09/18 By SunLM  月結后,不能錄入上月單據
# Modify.........: No:TQC-CA0016 12/10/09 By dongsz 修改默認代送商后不再由送貨客戶帶出
# Modify.........: No:MOD-CA0003 12/10/17 By Nina 單身輸入客戶產品編號時,其他資料Action的客戶產品編號需帶出單身輸入的客戶產品編號
# Modify.........: No:MOD-C90176 12/10/18 By Nina 調整作廢否cl_void選否時,ROLLBACK WORK並RETURN
# Modify.........: No:MOD-C90051 12/10/18 By Nina 計價單位應跟著單位變更
# Modify.........: No:FUN-C90049 12/10/19 By Lori 預設成本倉與非成本倉改從s_get_defstore取
# Modify.........: No.FUN-CB0014 12/11/06 By xianghui 增加資料清單
# Modify.........: No.CHI-CB0008 12/11/08 By Lori 1.單頭的稅「率」改變，不詢問直接自動更新單身。
#                                                 2.單頭的「稅率」不變，但「是否含稅」改變，才需要顯示詢問視窗。
#                                                 3.單身若進入單價後，單價無任何異動時，亦不能更新後面的金額。
# Modify.........: No:CHI-C60033 12/11/28 By Vampire 留置時圖檔改為留置,取消留置則還原
# Modify.........: No.CHI-C80041 12/11/28 By bart 取消單頭資料控制
# Modify.........: No:CHI-C90032 12/12/13 By pauline 單據取消確認時,若類別為借貨出貨訂單或借貨償價,並且來源為借貨出貨訂單時才計算業務額度
# Modify.........: No:FUN-CC0057 12/12/14 By xumeimei 添加生产营运中心栏位
# Modify.........: No:FUN-CC0006 12/12/17 By Sakura 訂單特性料件條件新增欄位"條件"oeba07，條件增加大於、小於、等於、大於等於、小於等於、區間等選項
# Modify.........: No:FUN-C30124 13/01/22 By pauline 該料件的ima24(檢驗碼)為Y, 且 “訂單輸入料號時，新增檢驗資料” 參數為Y時, 自動開啟aqci150作業讓user維護 
# Modify.........: No.TQC-D10084 13/01/28 By xianghui 資料清單頁簽下隱藏一部分ACTION
# Modify.........: No.MOD-CC0119 13/01/29 By Elise 依照該料件+客戶是否有設定於aqci150.若有設定則為noentry/若沒設定則為entry
# Modify.........: No.TQC-D10107 13/01/30 By xianghui 因將FUN-C30124,FUN-CC0006過到正式區導致程式編譯報錯，故先還原
# Modify.........: No.MOD-CC0197 13/01/31 By jt_chen AFTER FIELD oeb916中 IF g_aza.aza50='Y' THEN的判斷搬到CALL t400_price(l_ac) RETURNING l_fac外
# Modify.........: No.MOD-CC0181 13/01/31 By jt_chen check oeb04段:品名改用_o判斷oeb04新舊值
# Modify.........: No.MOD-CC0149 13/01/31 By jt_chen 修正ACTION預設上筆資料,調整為抓取項次最大值+1
# Modify.........: No.MOD-D10083 13/01/31 By Elise 新單價預設為原單價,判斷新舊單價不同時回寫
# Modify.........: No.TQC-D10103 13/02/05 By xianghui 對理由碼預設和修改時時增加盤點人員
# Modify.........: No:FUN-D20025 13/02/20 By chenying 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:MOD-D10033 13/02/25 By SunLM  經銷業態時候，將債權賦值給oea1002
# Modify.........: No.MOD-D10214 13/02/27 By Elise 調整錯誤訊息
# Modify.........: No.MOD-CB0247 13/02/27 By Elise FUNCTION t400_check_oeb04中LET g_oeb[l_ac].oeb05=l_b2這邊請增加oeb05_fac給值
# Modify.........: No:MOD-C90108 13/03/04 By Elise 訂單日期變更請用g_oea_o判斷
# Modify.........: No:FUN-D30007 13/03/04 By pauline 異動lpj_file時同步異動lpjpos欄位
# Modify.........: No.MOD-CB0264 13/03/05 By jt_chen 境外倉出貨訂單展單身時的未給予oeb30預設值,調整在FUNCTION t400_g_b7()中給預設值oeb30=NULL
# Modify.........: No:TQC-CA0059 13/03/06 By jt_chen GP 5.25、GP 5.30程式axmt410，於單身切換上下筆，會造成速度過慢問題，改善saxmt400內CALL t400_b_move_to()程式碼
# Modify.........: No.TQC-CB0028 13/03/06 By jt_chen 修正FUNCTION t400_chk_oeb04_1中判斷料號不為null才撈ima資料
# Modify.........: No:MOD-BA0054 13/03/07 By Elise 由報價單轉入時,oea65預設occ65
# Modify.........: No:MOD-D30071 13/03/08 By Vampire (1) 使用foreach 的方式取得該單據全部單身資料
#                                                    (2) 把[l_ac]改成[i]
# Modify.........: No.MOD-D20120 13/03/11 By Elise (1) 再取位之前應該重抓 t_azi03, t_azi04
#                                                  (2) 報價單轉訂單單價應該以 t_azi03 取位
# Modify.........: No:MOD-C60163 13/03/12 By jt_chen 項次9000的控卡只適用於使用流通配銷系統
# Modify.........: No:MOD-D30073 13/03/13 By Vampire 價格條件設定不能人工輸入,且單價不可為零,造成無窮迴圈
# Modify.........: No.MOD-D20143 13/03/14 By Elise axm-967的控卡會停在比率欄位，請調整停在金額欄位
# Modify.........: No.TQC-D30040 13/03/14 By Vampire 因訂單與合約訂單欄位不同導致axm-338錯誤，無法確認
# Modify.........: No:CHI-B60094 13/03/22 By Elise s_cusqry加傳參數
# Modify.........: No:MOD-D30218 13/03/25 By Vampire 當類別為 4:境外倉出貨 需控卡資料來源必須為 7:出至境外倉出貨
# Modify.........: No:MOD-D30230 13/03/27 By Vampire FUN-610076 在 t400_du_default() 的調整， 當有使用多單位時oeb916預設給ima31
# Modify.........: No:FUN-D20059 13/04/01 By chenjing 統一確認和取消確認時確認人員和確認日期的寫法
# Modify.........: No:FUN-D30038 13/04/11 By jt_chen 季會決議：報價單轉入訂單時，取出單價欄位先重新取價，單身資料若有低於取出單價警告詢問是否轉入訂單
# Modify.........: No:FUN-D30034 13/04/16 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:FUN-D40080 13/04/19 By qiaozy 服飾業畫面檔增加oeb51,oea95,oea95_desc
# Modify.........: No:MOD-D50078 13/05/11 By zhangll 修改审核后单身显示异常的问题
# Modify.........: No:MOD-D50089 13/05/11 By suncx 订单含税时，输入是单头的订单总含税金额oea1008没有给默认值，导致后面根据含税金额算订金、出货、尾款等金额时计算不出
# Modify.........: No:MOD-D50102 13/05/13 By zhangll 料号修改后可以更新单价等
# Modify.........: No:MOD-D50104 13/05/13 By zhangll 估价单转入检验oeb906栏位赋值
# Modify.........: No:MOD-D50171 13/05/16 By zhangll 报价单转入分量计价单身数量可合并取价
# Modify.........: No:TQC-D50053 13/05/24 By SunLM 調整CSD生成資料邏輯
# Modify.........: No:FUN-D40103 13/05/20 By lixh1 增加儲位有效性檢查
# Modify.........: No:TQC-D50127 13/06/03 By lixh1 調整儲位有效性檢查
# Modify.........: No:TQC-D50126 13/06/06 By lixh1 修正欄位跳轉問題
# Modify.........: No:TQC-D70016 13/07/01 By lujh 離開單價後，自動帶出稅前金額和含稅金額,此時回到“單價”欄位修改為其他值
#                                                 稅前金額和含稅金額欄位都沒有跟著變動，還是原來的舊值。
# Modify.........: No:MOD-D80040 13/08/07 By SunLM 调整插入返利资料oeb04料号为MISC
# Modify.........: No:TQC-DC0014 13/12/05 By wangrr 進入[指定料件特性]單身如果在最後一行點回車鍵,則保存退出單身,
#                                                   複製時同步複製oeba_file
# Modify.........: No:160614 16/06/14 By guanyao 一般订单只能由合约订单生成

DATABASE ds

GLOBALS "../../config/top.global"
GLOBALS "../4gl/saxmt400.global"
GLOBALS "../4gl/s_slk.global"     #No.FUN-B90101 

DEFINE  g_multi_ima01  STRING     #  No.FUN-A80121 
#FUN-B90101--add--begin--
#FUN-B90101--add--end--
#FUN-CB0014---add---str---
DEFINE g_rec_b3      LIKE type_file.num5
DEFINE  g_oea_l      DYNAMIC ARRAY OF RECORD
                     oea00_l  LIKE oea_file.oea00,
                     oea08_l  LIKE oea_file.oea08,
                     oea01_l  LIKE oea_file.oea01,
                     oea02_l  LIKE oea_file.oea02,
                     oea03_l  LIKE oea_file.oea03,
                     oea032_l LIKE oea_file.oea032,
                     oea14_l  LIKE oea_file.oea14,
                     gen02_l  LIKE gen_file.gen02,
                     oea15_l  LIKE oea_file.oea15,
                     gem02_l  LIKE gem_file.gem02,
                     oea10_l  LIKE oea_file.oea10,
                     oea31_l  LIKE oea_file.oea31,
                     oah02_l  LIKE oah_file.oah02,
                     oea32_l  LIKE oea_file.oea32,
                     oag02_l  LIKE oag_file.oag02,
                     oeaconf_l LIKE oea_file.oeaconf,
                     oea49_l  LIKE oea_file.oea49
                     END RECORD
DEFINE w        ui.Window
DEFINE f        ui.Form
DEFINE page     om.DomNode
#FUN-CB0014---add---end---
#FUN-910088--add--start--
DEFINE g_oeb05_t            LIKE oeb_file.oeb05
DEFINE g_oeb910_t           LIKE oeb_file.oeb910
DEFINE g_oeb913_t           LIKE oeb_file.oeb913
DEFINE g_oeb916_t           LIKE oeb_file.oeb916
#FUN-910088--add--end--

#No.TQC-B90236--------------add-----------begin----------------
DEFINE  g_oeba         DYNAMIC ARRAY OF RECORD
            oeba03     LIKE oeba_file.oeba03,
            oeba04     LIKE oeba_file.oeba04,
            ini02      LIKE ini_file.ini02,
            ini03      LIKE ini_file.ini03,
            oeba07     LIKE oeba_file.oeba07, #FUN-CC0006 add
            oeba05     LIKE oeba_file.oeba05,
            oeba06     LIKE oeba_file.oeba06
                       END RECORD,
        g_oeba_t       RECORD
            oeba03     LIKE oeba_file.oeba03,
            oeba04     LIKE oeba_file.oeba04,
            ini02      LIKE ini_file.ini02,
            ini03      LIKE ini_file.ini03,
            oeba07     LIKE oeba_file.oeba07, #FUN-CC0006 add
            oeba05     LIKE oeba_file.oeba05,
            oeba06     LIKE oeba_file.oeba06
                       END RECORD
DEFINE  l_ac1         LIKE type_file.num5   #FUN-CB0014                     
DEFINE  l_ac4         LIKE type_file.num5
#No.TQC-B90236--------------add-----------end------------------
DEFINE g_oah08     LIKE oah_file.oah08  #FUN-C40089
DEFINE g_oah04     LIKE oah_file.oah04  #MOD-D30073 add
DEFINE g_argv1      LIKE type_file.chr1 

FUNCTION t400(p_argv1,p_oea901,p_argv2,p_argv3)
   DEFINE p_argv1      LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)   # 0.合約 1.訂單/換貨訂單
   DEFINE p_oea901     LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)   # 多角貿易否 No.7946
   DEFINE p_argv2      LIKE oea_file.oea01 #No.FUN-640024
   DEFINE p_argv3      STRING              #No.FUN-640024
   DEFINE cb           ui.ComboBox         #TQC-BA0033
   DEFINE l_msg        STRING              #TQC-BA0033
   
   WHENEVER ERROR CONTINUE   #CHI-9A0052
    LET g_argv1 = p_argv1
    LET g_wc2=' 1=1'
    LET g_wc3=' 1=1'
    LET g_wc4=' 1=1' #FUN-6C0006
#FUN-B90101--add--begin--
#FUN-B90101--add--end--
    LET g_sql = "l_gen02.gen_file.gen02,",
                "l_gem02.gem_file.gem02,",
                "oea00.oea_file.oea00,",
                "oea01.oea_file.oea01,",
                "oea02.oea_file.oea02,",
                "oea03.oea_file.oea03,",
                "oea032.oea_file.oea032,",
                "oea14.oea_file.oea14,",
                "oea15.oea_file.oea15,",
                "oea25.oea_file.oea25,",
                "oea23.oea_file.oea23,",
                "oea61.oea_file.oea61,",
                "oea1006.oea_file.oea1006,",
               # "l_tax.ima_file.ima26,", # FUN-A20044
                "l_tax.type_file.num15_3,", # FUN-A20044
               # "l_tax1.ima_file.ima26,", # FUN-A20044
                "l_tax1.type_file.num15_3,", # FUN-A20044
               # "l_tot.ima_file.ima26,",  # FUN-A20044
                "l_tot.type_file.num15_3,",  # FUN-A20044
                "t_azi04.azi_file.azi04"
    LET l_table = cl_prt_temptable('axmt420',g_sql) CLIPPED   # 產生Temp Table
    IF l_table = -1 THEN 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
       EXIT PROGRAM 
    END IF                  # Temp Table產生
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?,                         ?, ?, ?, ?, ?, ?, ?)"
   PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep:',status,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
       EXIT PROGRAM
    END IF
##-MOD-B30121 -ADD --BEGIN--
   LET cb = ui.ComboBox.forName("oea11")
   IF (g_aza.aza88 <> 'Y') THEN
      CALL cb.removeItem('9')
   END IF
##-MOD-B30121 -ADD ---END---

   #No.FUN-A90040  begin--  
   IF (g_azw.azw04 <> '2') THEN 
       CALL cl_set_comp_visible("oeb49,oeb50",FALSE)
    ELSE
       CALL cl_set_comp_visible("oeb49,oeb50",TRUE)
   END IF
   #No.FUN-A90040  end--  
   
#TQC-AA0101 --begin--
   IF g_azw.azw04 <> '2' THEN 
      CALL cl_set_act_visible("detail_tax,kefa,cancel_price,discount_detail",FALSE)
   ELSE
   	  CALL cl_set_act_visible("detail_tax,kefa,cancel_price,discount_detail",TRUE)  
   END IF 
#TQC-AA0101 --end--
#TQC-B90236---Begin--
   IF g_prog='axmt400' OR g_prog='axmt420' OR g_prog='axmt810' THEN
      CALL cl_set_act_visible("specify",FALSE)
   ELSE
      IF g_sma.sma94 = 'Y' THEN   #FUN-C60046
         CALL cl_set_act_visible("specify",TRUE)
      #FUN-C60046---begin
      ELSE
         CALL cl_set_act_visible("specify",FALSE)
      END IF 
      #FUN-C60046---end
   END IF
#TQC-B90236---End----
#FUN-AB0039 --Begin--
  #IF p_argv1 = '1'  THEN                      #FUN-AB0096
   IF p_argv1 = '1' AND g_azw.azw04 = '2' THEN #FUN-AB0096
      CALL cl_set_act_visible("detail_tax",TRUE)
   ELSE
      CALL cl_set_act_visible("detail_tax",FALSE)
   END IF
#FUN-AB0039 --End----
#MOD-B30127--add--str--
   IF p_argv1 = '1' AND g_azw.azw04 <> '2' THEN 
      CALL cl_set_comp_visible("oeacont",FALSE)
   END IF
#MOD-B30127--add--end--
#FUN-B50168--ADD-START--
    IF g_azw.azw04 <> '2' THEN
      CALL cl_set_comp_visible("oeb37",FALSE)
    ELSE
      CALL cl_set_comp_visible("oeb37",TRUE)
    END IF
#FUN-B50168--ADD-END   

#TQC-BA0033--begin
   LET cb = ui.ComboBox.forName("oea212")
   IF g_aza.aza26 = '2' THEN
      LET l_msg=cl_getmsg('axm-397',g_lang)
      LET l_msg="A:",l_msg CLIPPED
      CALL cb.addItem('A', l_msg)

      LET l_msg=cl_getmsg('axm-398',g_lang)
      LET l_msg="B:",l_msg CLIPPED
      CALL cb.addItem('B', l_msg)

      LET l_msg=cl_getmsg('axm-400',g_lang)
      LET l_msg="C:",l_msg CLIPPED
      CALL cb.addItem('C', l_msg)
   END IF
#TQC-BA0033--end
 
    LET g_oea901 = p_oea901          #No.7946

#FUN-C40072---mark---START
#   IF g_oea901 = 'Y' THEN
#       CALL cl_set_comp_visible("oea65",FALSE)
#   ELSE
#       CALL cl_set_comp_visible("oea65",TRUE)
#   END IF
#FUN-C40072---mark-----END
    IF g_prog != 'axmt410' OR g_aza.aza50 = 'N' THEN
        CALL cl_set_comp_visible("oeb935,oeb936,oeb937",FALSE)
    END IF
#FUN-B90101--add--str--
#FUN-B90101--add--end--
    #CALL cl_set_comp_visible("oea917,oeaslk02",FALSE)  #FUN-A50054 add oeaslk02  #FUN-A60035 ---MARK
    CALL cl_set_comp_visible("oea917",FALSE) 
    CALL cl_set_comp_visible("oeaslk01,geb02",FALSE)          #No.TQC-B60101 ADD
#MOD-B30166 mark --start--
#&ifndef ICD
#    IF g_sma.sma120 NOT MATCHES '[Yy]' OR g_sma.sma115 MATCHES '[Yy]' THEN
#        CALL cl_set_comp_visible("oea917",FALSE)
#    ELSE
#        CALL cl_set_comp_visible("oea917",TRUE)
#    END IF
#&endif
#MOD-B30166 mark --end--
   CALL cl_set_comp_visible("oebiicd04,oebiicd05",FALSE)  #FUN-C30289
#FUN-B90101  add &ifndef SLK
#FUN-A60035 ---ADD BEGIN   #二維功能mark后 款式明細欄位去掉
    CALL cl_set_comp_required("oeaslk02",FALSE)
    CALL cl_set_comp_visible("oeaslk02",FALSE)
    CALL cl_set_act_visible("modify_price",g_azw.azw04='2')
    CALL cl_set_act_visible("modify_rate",g_azw.azw04='2')
#FUN-A60035 ---ADD END
#FUN-B90101  add &endif
#str----add by guanyao160608  只有合约订单的时候显示已转工单数和合约订单状况
    IF g_prog != 'axmt400' THEN 
       CALL cl_set_act_visible("oea_count",FALSE)
       CALL cl_set_comp_visible("oebud07",FALSE)
       CALL cl_set_comp_visible("oebud08,oebud09",FALSE)   #add by guanyao160614
    END IF 
#end----add by guanyao160608
#    CALL cl_set_act_visible("controlb",FALSE)        #FUN-B90101 add #FUN-C60100--MARK--
    CALL cl_set_comp_visible("grhide",g_azw.azw04='2')
    CALL cl_set_comp_visible("oeb44,oeb45,oeb46,oeb47,oeb48",g_azw.azw04='2')
    CALL cl_set_comp_visible("oea94",g_aza.aza88 = 'Y')                          #FUN-A50071 add
    CALL cl_set_act_visible("carry_po",g_azw.azw04<>'2')
    CALL cl_set_act_visible("pay_money,money_detail,modify_rate",g_azw.azw04='2') #FUN-9C0083
#   CALL cl_set_act_visible("discount_detail",g_prog='axmt410')       #FUN-A10110 ADD  #TQC-AA0101 mark
    CALL cl_set_comp_visible("spare_qty,oebiicd03",FALSE)           #FUN-C30235
    CALL cl_set_comp_visible("oeb918",g_sma.sma541='Y')   #FUN-A80054
#FUN-B90101--add--begin--
#FUN-B90101--add--end--
    LET g_forupd_sql = "SELECT * FROM oea_file WHERE oea01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t400_cl CURSOR FROM g_forupd_sql
    LET g_argv1 = p_argv1
    LET g_argv2 = p_argv2            #No.FUN-640024
    LET g_argv3 = p_argv3            #No.FUN-640024

    CALL t400_init() #FUN-710037


      LET g_action_choice = ""

     IF NOT cl_null(g_argv2) THEN
        CASE g_argv3
           WHEN "query"
              LET g_action_choice = "query"
              IF cl_chk_act_auth() THEN
                 CALL t400_q()
              END IF
           WHEN "insert"
              LET g_action_choice = "insert"
              IF cl_chk_act_auth() THEN
                 CALL t400_a()
              END IF
           WHEN "efconfirm"
              CALL t400_q()
              CALL t400sub_y_chk('1',g_oea.oea01)         #CALL 原確認的 check 段  #FUN-730012 #FUN-740034
              IF g_success = "Y" THEN
                #CALL t400sub_y_upd(g_oea.oea01,'efconfirm')       #CALL 原確認的 update 段 #FUN-730012   #FUN-740034   #CHI-B80050 mark
                 CALL t400sub_y_upd(g_oea.oea01,'efconfirm',FALSE)   #CHI-B80050
              END IF
              CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B40028
              EXIT PROGRAM
           OTHERWISE
              CALL t400_q()
        END CASE
     END IF

      #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
      CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query,locale,                        void, undo_void,confirm, undo_confirm, easyflow_approval, csd_data, expense_data,  #FUN-D20025 add undo_void                       on_hold, undo_on_hold, change_status, restore, carry_pr,carry_po,                        mul_trade, mul_trade_other, allocate, undo_distribution, modify_price,                        modify_rate, pref, discount_allowed, deposit_multi_account,                        balance_multi_account, new_code_application, product_inf                      ,memo,other_data     #TQC-B40205 add                       ") ##TQC-5B0117   #FUN-6C0050 add carry_po #TQC-740127  #TQC-740281  #FUN-A50013
           RETURNING g_laststage
    CALL t400_menu()

END FUNCTION

FUNCTION t400_cs()
DEFINE  lc_qbe_sn       LIKE gbm_file.gbm01    #No.FUN-580031  HCN
DEFINE  l_i             LIKE type_file.num5    #FUN-610055  #No.FUN-680137 SMALLINT
DEFINE  l_oea11         LIKE oea_file.oea11       #No.FUN-630013
DEFINE cb ui.ComboBox                          #TQC-A30155
DEFINE  aza26           LIKE aza_file.aza26    #TQC-A30155
DEFINE  l_msg           STRING                 #TQC-A30155

    CLEAR FORM                       #清除畫面
    CALL g_oeb.clear()
    CALL g_oeb1.clear()
#FUN-B90101--add--str--
#FUN-B90101--add--end--
#TQC-BA0033--mark--begin
#start TQC-A30155
   LET cb = ui.ComboBox.forName("oea212")
   IF g_aza.aza26 = '2' THEN
      LET l_msg=cl_getmsg('axm-397',g_lang)
      LET l_msg="A:",l_msg CLIPPED
      CALL cb.addItem('A', l_msg)

      LET l_msg=cl_getmsg('axm-398',g_lang)
      LET l_msg="B:",l_msg CLIPPED
      CALL cb.addItem('B', l_msg)

 #    LET l_msg=cl_getmsg('axm-399',g_lang)      #TQC-A40142
      LET l_msg=cl_getmsg('axm-400',g_lang)      #TQC-A40142
      LET l_msg="C:",l_msg CLIPPED
      CALL cb.addItem('C', l_msg)
   END IF
#end   TQC-A30155
#TQC-BA0033--mark--end
    IF NOT cl_null(g_argv2) THEN
       LET g_wc = " oea01 = '",g_argv2,"'"
       LET g_wc2 = " 1=1"
       LET g_wc3 = " 1=1"
       LET g_wc4 = " 1=1" #FUN-6C0006
#FUN-B90101--add--str--
#FUN-B90101--add--end--
    ELSE
       WHILE TRUE
          CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
          INITIALIZE g_oea.* TO NULL      #No.FUN-750051
       #No.FUN-A40055--begin
#          CONSTRUCT BY NAME g_wc ON      # 螢幕上取單頭條件
#             oea00,oea08,oea01,oea06,oea02,oea11,oea12,oea03,oea032,
#             oea04,oea17,oea1004,oea1015,oea14,oea15,oea1002,oea1009,
#             oea1003,oea917,
#&ifdef SLK
#             oeaslk01,    #FUN-870117 add oeaslk01
#&endif
#             oea10,oea23,oea24,oea21,oea211,oea212,oea213,  #FUN-820046 add oea917
#             oea31,oea32,oea37,oea50,oeamksg,oea1005,oeahold,oeaconf,oeacont,oea49, #No.FUN-870007-add-oeacont
#             oea044,oea41,oea42,oea43,oea44,oea33,oea09,oea1012,oea1013,
#             oea1014,oea161,oea162,oea163,oea1011,oea1010,oea05,oea18,
#             oea07,oea62,oea63,oea65,                          #No.FUN-870007
#             oea83,oea84,oea85,oea86,oea87,oeaplant,oeaconu,   #No.FUN-870007
#             oea88,oea89,oea90,oea91,oea92,oea93,              #No.FUN-870007
#             oea25,oea26,oea46,oea80,oea81,oea47,oea48,        #No.FUN-870007
#             oea905,oea99,oea61,oeauser,oeagrup,oeamodu,oeadate,
#             oeaoriu,oeaorig,                                  #TQC-A30041 ADD
#             oeaud01,oeaud02,oeaud03,oeaud04,oeaud05,
#             oeaud06,oeaud07,oeaud08,oeaud09,oeaud10,
#             oeaud11,oeaud12,oeaud13,oeaud14,oeaud15,
#             oea918,oea919      #FUN-8C0078
#
#               BEFORE CONSTRUCT
#                  CALL cl_qbe_init()
#
#               AFTER FIELD oea11
#                  LET l_oea11 = GET_FLDBUF(oea11)
#
#             ON ACTION controlp
#                CASE
#                   WHEN INFIELD(oea01) #查詢單据
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form ="q_oea11"   #MOD-4A0252
#                        IF g_argv1='0' THEN
#                           LET g_qryparam.where = " oea00 = '0' "
#                        END IF
#                        IF g_argv1='1' THEN
#			   LET g_qryparam.where = " oea00 MATCHES '[123467]' AND oea901 = '",g_oea901,"' "
#                        END IF
#                        IF g_argv1='2' THEN
#                           LET g_qryparam.where = " oea00 MATCHES '[89]' "
#                        END IF
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea01
#                        NEXT FIELD oea01
#                   WHEN INFIELD(oea12)
#                      CASE l_oea11
#                         WHEN '2'
#                            CALL cl_init_qry_var()
#                            LET g_qryparam.state = "c"
#                            LET g_qryparam.form ="q_oha"
#                            CALL cl_create_qry() RETURNING g_qryparam.multiret
#                            DISPLAY g_qryparam.multiret TO oea12
#                         WHEN '3'
#                            CALL cl_init_qry_var()
#                            LET g_qryparam.state = "c"
#                            LET g_qryparam.form ="q_oea2"
#                            CALL cl_create_qry() RETURNING g_qryparam.multiret
#                            DISPLAY g_qryparam.multiret TO oea12
#                         WHEN '4'
#                            CALL cl_init_qry_var()
#                            LET g_qryparam.state = "c"
#                            LET g_qryparam.form ="q_oqa"
#                            CALL cl_create_qry() RETURNING g_qryparam.multiret
#                            DISPLAY g_qryparam.multiret TO oea12
#                         WHEN '5'
#                            CALL cl_init_qry_var()
#                            LET g_qryparam.state = "c"
#                            LET g_qryparam.form ="q_oqt"
#                            CALL cl_create_qry() RETURNING g_qryparam.multiret
#                            DISPLAY g_qryparam.multiret TO oea12
#                         WHEN '7'
#                            CALL cl_init_qry_var()
#                            LET g_qryparam.state = "c"
#                            LET g_qryparam.form ="q_oga"
#                            CALL cl_create_qry() RETURNING g_qryparam.multiret
#                            DISPLAY g_qryparam.multiret TO oea12
#                         OTHERWISE EXIT CASE
#                      END CASE
#
#                   WHEN INFIELD(oea1015)
#                      CALL cl_init_qry_var()
#                      LET g_qryparam.state = "c"
#                      LET g_qryparam.form ="q_pmc8"
#                      LET g_qryparam.default1 = g_oea.oea1015
#                      CALL cl_create_qry() RETURNING g_qryparam.multiret
#                      DISPLAY g_qryparam.multiret TO oea1015
#                      NEXT FIELD oea1015
#                   WHEN INFIELD(oea03)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        #-----MOD-A30026---------
#                        #LET g_qryparam.form ="q_occ3"   
#                        IF g_aza.aza50='Y' THEN  
#                           LET g_qryparam.form ="q_occ3" 
#                        ELSE 
#                           LET g_qryparam.form ="q_occ"  
#                        END IF   
#                        #-----END MOD-A30026-----
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea03
#                        NEXT FIELD oea03
#                   WHEN INFIELD(oea04)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        IF g_aza.aza50='Y' THEN
#                           LET g_qryparam.form ="q_occ4"    #FUN-610055
#                        ELSE
#                           LET g_qryparam.form ="q_occ"  #No.FUN-650108
#                        END IF
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea04
#                        NEXT FIELD oea04
#                   WHEN INFIELD(oea14)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form ="q_gen"
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea14
#                        NEXT FIELD oea14
#                   WHEN INFIELD(oea15)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form ="q_gem"
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea15
#                        NEXT FIELD oea15
#                   WHEN INFIELD(oea1011)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form ="q_occ7"
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea1011
#                        NEXT FIELD oea1011
#                   WHEN INFIELD(oea17)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        IF g_aza.aza50='Y' THEN
#                           LET g_qryparam.form ="q_occ6"
#                        ELSE
#                           LET g_qryparam.form ="q_occ"  #No.FUN-650108
#                        END IF
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea17
#                        NEXT FIELD oea17
#                   WHEN INFIELD(oea1002)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form ="q_tqa1"
#                        LET g_qryparam.arg1 ='20'
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea1002
#                        NEXT FIELD oea1002
#                   WHEN INFIELD(oea1003)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form ="q_tqb"
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea1003
#                        NEXT FIELD oea1003
#                   WHEN INFIELD(oea1004)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form ="q_occ5"
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea1004
#                        NEXT FIELD oea1004
#                   WHEN INFIELD(oea1009)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form ="q_tqa1"
#                        LET g_qryparam.arg1 ='19'
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea1009
#                        NEXT FIELD oea1009
#                   WHEN INFIELD(oea1010)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form ="q_tqb"
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea1010
#                        NEXT FIELD oea1010
#                   WHEN INFIELD(oea21)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form ="q_gec"
#                        LET g_qryparam.arg1 = '2'
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea21
#                        NEXT FIELD oea21
#                   WHEN INFIELD(oea23)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form ="q_azi"
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea23
#                        NEXT FIELD oea23
#                   WHEN INFIELD(oea25)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form ="q_oab"
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea25
#                        NEXT FIELD oea25
#                   WHEN INFIELD(oea26)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form ="q_oab"
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea26
#                        NEXT FIELD oea26
#                   WHEN INFIELD(oea31)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form ="q_oah"
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea31
#                        NEXT FIELD oea31
#                   WHEN INFIELD(oea32)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form ="q_oag"
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea32
#                        NEXT FIELD oea32
#                   WHEN INFIELD(oea044)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form ="q_ocd"
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea044
#                   WHEN INFIELD(oea41)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form ="q_oac"
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea41
#                   WHEN INFIELD(oea42)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form ="q_oac"
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea42
#                   WHEN INFIELD(oea43)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form ="q_ged"
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea43
#                   WHEN INFIELD(oea44)    #MOD-4A0252
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form = "q_ocf"   # MOD-580085
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea44
#                   WHEN INFIELD(oea46)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form ="q_pja2"  #FUN-810045
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea46
#                   WHEN INFIELD(oea47)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form = "q_pmc4"
#                        LET g_qryparam.arg1 = '4'
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea47
#                   WHEN INFIELD(oea48)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form = "q_ofs"
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea48
#                   WHEN INFIELD(oeahold)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form ="q_oak1"
#                        LET g_qryparam.default1= g_oea.oeahold
#                        LET g_qryparam.arg1 ='1'
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oeahold
#                        NEXT FIELD oeahold
#                   WHEN INFIELD(oea80)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form ="q_oag"
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea80
#                        NEXT FIELD oea80
#                   WHEN INFIELD(oea81)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form ="q_oag"
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oea81
#                        NEXT FIELD oea81
#&ifdef SLK
#                   WHEN INFIELD(oeaslk01)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form ="q_geb"
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oeaslk01
#                        NEXT FIELD oeaslk01
#&endif
#                   WHEN INFIELD(oea83)
#                         CALL cl_init_qry_var()
#                         LET g_qryparam.state = "c"
#                         LET g_qryparam.form ="q_oea83"
#                         CALL cl_create_qry() RETURNING g_qryparam.multiret
#                         DISPLAY g_qryparam.multiret TO oea83
#                         NEXT FIELD oea83
#                   WHEN INFIELD(oea84)
#                         CALL cl_init_qry_var()
#                         LET g_qryparam.state = "c"
#                         LET g_qryparam.form ="q_oea84"
#                         CALL cl_create_qry() RETURNING g_qryparam.multiret
#                         DISPLAY g_qryparam.multiret TO oea84
#                         NEXT FIELD oea84
#                   WHEN INFIELD(oea86)
#                         CALL cl_init_qry_var()
#                         LET g_qryparam.state = "c"
#                         LET g_qryparam.form ="q_oea86"
#                         CALL cl_create_qry() RETURNING g_qryparam.multiret
#                         DISPLAY g_qryparam.multiret TO oea86
#                         NEXT FIELD oea86
#                   WHEN INFIELD(oeaconu)
#                         CALL cl_init_qry_var()
#                         LET g_qryparam.state = "c"
#                         LET g_qryparam.form ="q_oeaconu"
#                         CALL cl_create_qry() RETURNING g_qryparam.multiret
#                         DISPLAY g_qryparam.multiret TO oeaconu
#                         NEXT FIELD oeaconu
#                   WHEN INFIELD(oeaplant)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.form ="q_azp"
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO oeaplant
#                        NEXT FIELD oeaplant
#                   WHEN INFIELD(oeaud02)
#                      CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
#                      DISPLAY g_qryparam.multiret TO oeaud02
#                      NEXT FIELD oeaud02
#                   WHEN INFIELD(oeaud03)
#                      CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
#                      DISPLAY g_qryparam.multiret TO oeaud03
#                      NEXT FIELD oeaud03
#                   WHEN INFIELD(oeaud04)
#                      CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
#                      DISPLAY g_qryparam.multiret TO oeaud04
#                      NEXT FIELD oeaud04
#                   WHEN INFIELD(oeaud05)
#                      CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
#                      DISPLAY g_qryparam.multiret TO oeaud05
#                      NEXT FIELD oeaud05
#                   WHEN INFIELD(oeaud06)
#                      CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
#                      DISPLAY g_qryparam.multiret TO oeaud06
#                      NEXT FIELD oeaud06
#                END CASE
#
#             ON IDLE g_idle_seconds
#                CALL cl_on_idle()
#                CONTINUE CONSTRUCT
#
#             ON ACTION about         #MOD-4C0121
#                CALL cl_about()      #MOD-4C0121
#
#             ON ACTION help          #MOD-4C0121
#                CALL cl_show_help()  #MOD-4C0121
#
#             ON ACTION controlg      #MOD-4C0121
#                CALL cl_cmdask()     #MOD-4C0121
#
#                 ON ACTION qbe_select
#		   CALL cl_qbe_list() RETURNING lc_qbe_sn
#		   CALL cl_qbe_display_condition(lc_qbe_sn)
#          END CONSTRUCT
#
#          IF INT_FLAG THEN RETURN END IF
#          EXIT WHILE
#       END WHILE
#
#       CONSTRUCT g_wc2 ON
#           oeb03,
#&ifdef SLK
#           oebislk01,    #No.FUN-810016
#&endif
#           oeb04,oeb06,oeb11,oeb1001,oeb1012,oeb906,oeb092,
#           oeb15,oeb30,oeb31,oeb05,oeb12,  #No.FUN-5C0076     #No.FUN-740016
#           oeb913,oeb914,oeb915,oeb910,oeb911,oeb912,
#           oeb916,oeb917,oeb29,oeb24,oeb25,oeb27,oeb28,oeb1004,oeb1002,   # 螢幕上取單身條件  #NO.FUN-670007   #No.FUN-740016
#           oeb13,oeb1006,oeb14,oeb14t,oeb41,oeb42,oeb43,oeb09,oeb091,    #FUN-810045 add oeb41,42,43
#           oeb930,oeb908,oeb22,oeb19,oeb70,oeb16  #FUN-670063 #FUN-6B0151 add oeb16
#&ifdef ICD
#           ,oebiicd01,oebiicd03,oebiicd05,oebiicd07  #No.FUN-7C0017
#&endif
#           ,oebud01,oebud02,oebud03,oebud04,oebud05
#           ,oebud06,oebud07,oebud08,oebud09,oebud10
#           ,oebud11,oebud12,oebud13,oebud14,oebud15
#           ,oeb44,oeb45,oeb46,oeb47,oeb48          #No.FUN-870007
#       FROM
#           s_oeb[1].oeb03,                           #No.FUN-7C0017
#&ifdef SLK
#           s_oeb[1].oebislk01,     #No.FUN-810016
#&endif
#           s_oeb[1].oeb04,s_oeb[1].oeb06,
#           s_oeb[1].oeb11,s_oeb[1].oeb1001,s_oeb[1].oeb1012,s_oeb[1].oeb906,s_oeb[1].oeb092,
#           s_oeb[1].oeb15,s_oeb[1].oeb30,s_oeb[1].oeb31,s_oeb[1].oeb05,s_oeb[1].oeb12,    #No.FUN-5C0076   #No.FUN-740016
#           s_oeb[1].oeb913,s_oeb[1].oeb914,s_oeb[1].oeb915,
#           s_oeb[1].oeb910,s_oeb[1].oeb911,s_oeb[1].oeb912,
#           s_oeb[1].oeb916,s_oeb[1].oeb917,s_oeb[1].oeb29,s_oeb[1].oeb24,s_oeb[1].oeb25,   #No.FUN-740016
#           s_oeb[1].oeb27,s_oeb[1].oeb28,       #NO.FUN-670007 add
#           s_oeb[1].oeb1004,s_oeb[1].oeb1002,
#           s_oeb[1].oeb13,s_oeb[1].oeb1006,
#           s_oeb[1].oeb14,s_oeb[1].oeb14t,
#           s_oeb[1].oeb41,s_oeb[1].oeb42,s_oeb[1].oeb43,  #FUN-810045
#           s_oeb[1].oeb09,s_oeb[1].oeb091,s_oeb[1].oeb930,s_oeb[1].oeb908,  #FUN-670063
#           s_oeb[1].oeb22,s_oeb[1].oeb19,s_oeb[1].oeb70,s_oeb[1].oeb16  #FUN-6B0151 add oeb16
#&ifdef ICD
#          ,s_oeb[1].oebiicd01,s_oeb[1].oebiicd03,s_oeb[1].oebiicd05,s_oeb[1].oebiicd07  #No.FUN-7C0017
#&endif
#           ,s_oeb[1].oebud01,s_oeb[1].oebud02,s_oeb[1].oebud03,s_oeb[1].oebud04,s_oeb[1].oebud05
#           ,s_oeb[1].oebud06,s_oeb[1].oebud07,s_oeb[1].oebud08,s_oeb[1].oebud09,s_oeb[1].oebud10
#           ,s_oeb[1].oebud11,s_oeb[1].oebud12,s_oeb[1].oebud13,s_oeb[1].oebud14,s_oeb[1].oebud15
#           ,s_oeb[1].oeb44,s_oeb[1].oeb45,s_oeb[1].oeb46,s_oeb[1].oeb47,s_oeb[1].oeb48   #No.FUN-870007
#
#		BEFORE CONSTRUCT
#		   CALL cl_qbe_display_condition(lc_qbe_sn)
#          ON ACTION controlp
#             CASE
#&ifdef SLK
#                WHEN INFIELD(oebislk01)
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.form  = "q_skd01"
#                   LET g_qryparam.state = "c"   #多選
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO oebislk01
#                   NEXT FIELD oebislk01
#&endif
#                WHEN INFIELD(oeb1001)
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.state = "c"
#                      LET g_qryparam.form ="q_azf03" #TQC-7C0098
#                      LET g_qryparam.arg1 = "2"   #No.FUN-660073
#                      LET g_qryparam.arg2 = "1"   #No.TQC-7C0098
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO oeb1001
#                   NEXT FIELD oeb1001
#                WHEN INFIELD(oeb31)
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.state = "c"
#                   LET g_qryparam.form ="q_azf1"
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO oeb31
#                   NEXT FIELD oeb31
#                WHEN INFIELD(oeb04)
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.state = "c"
#                   IF g_aza.aza50='Y' THEN
#                      LET g_qryparam.form ="q_ima15"   #FUN-610055
#                   ELSE
#                      LET g_qryparam.form ="q_ima"   #FUN-610055
#                   END IF
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO oeb04
#                   NEXT FIELD oeb04
#
#                WHEN INFIELD(oeb05)
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.state = "c"
#                   LET g_qryparam.form ="q_gfe"
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO oeb05
#                   NEXT FIELD oeb05
#
#                WHEN INFIELD(oeb908)
#                   CALL q_coc2(TRUE,TRUE,g_oeb[1].oeb908,'',g_oea.oea02,'0',
#                               '',g_oeb[1].oeb04)
#                   RETURNING g_oeb[1].oeb908
#                   DISPLAY BY NAME g_oeb[1].oeb908
#                   NEXT FIELD oeb908
#                WHEN INFIELD(oeb913)
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.state = "c"
#                   LET g_qryparam.form ="q_gfe"
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO oeb913
#                   NEXT FIELD oeb913
#
#                WHEN INFIELD(oeb910)
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.state = "c"
#                   LET g_qryparam.form ="q_gfe"
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO oeb910
#                   NEXT FIELD oeb910
#
#                WHEN INFIELD(oeb916)
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.state = "c"
#                   LET g_qryparam.form ="q_gfe"
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO oeb916
#                   NEXT FIELD oeb916
#                WHEN INFIELD(oeb1004)
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.state = "c"
#                   LET g_qryparam.form ="q_tqx3"  #TQC-7C0098
#                   LET g_qryparam.arg1 = g_oea.oea23  #TQC-7C0098
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO oeb1004
#                   NEXT FIELD oeb1004
#                WHEN INFIELD(oeb41) #專案
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form ="q_pja2"
#                  LET g_qryparam.state = "c"   #多選
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO oeb41
#                  NEXT FIELD oeb41
#                WHEN INFIELD(oeb42)  #WBS
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form ="q_pjb4"
#                  LET g_qryparam.state = "c"   #多選
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO oeb42
#                  NEXT FIELD oeb42
#                WHEN INFIELD(oeb43)  #活動
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form ="q_pjk3"
#                  LET g_qryparam.state = "c"   #多選
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO oeb43
#                  NEXT FIELD oeb43
#
#                WHEN INFIELD(oeb09)
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.state = "c"
#                   LET g_qryparam.form ="q_imd01"
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO oeb09
#                   NEXT FIELD oeb09
#                WHEN INFIELD(oeb091)
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.state = "c"
#                   LET g_qryparam.form ="q_ime"
#                   LET g_qryparam.arg1 = g_oeb[1].oeb09
#                   LET g_qryparam.arg2 = 'SW'
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO oeb091
#                   NEXT FIELD oeb091
#                WHEN INFIELD(oeb930)
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.form  = "q_gem4"
#                   LET g_qryparam.state = "c"   #多選
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO oeb930
#                   NEXT FIELD oeb930
#&ifdef ICD
#                WHEN INFIELD(oebiicd01)
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.state = 'c'
#                   LET g_qryparam.form = "q_imaicd00"
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO oebiicd01
#                   NEXT FIELD oebiicd01
#
#                WHEN INFIELD(oebiicd07)
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.state = 'c'
#                   LET g_qryparam.form = "q_icd3"
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO oebiicd07
#                   NEXT FIELD oebiicd07
#&endif
#                WHEN INFIELD(oebud02)
#                   CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO oebud02
#                   NEXT FIELD oebud02
#                WHEN INFIELD(oebud03)
#                   CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO oebud03
#                   NEXT FIELD oebud03
#                WHEN INFIELD(oebud04)
#                   CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO oebud04
#                   NEXT FIELD oebud04
#                WHEN INFIELD(oebud05)
#                   CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO oebud05
#                   NEXT FIELD oebud05
#                WHEN INFIELD(oebud06)
#                   CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO oebud06
#                   NEXT FIELD oebud06
#
#                OTHERWISE
#             END CASE
#
#          ON IDLE g_idle_seconds
#             CALL cl_on_idle()
#             CONTINUE CONSTRUCT
#
#          ON ACTION about         #MOD-4C0121
#             CALL cl_about()      #MOD-4C0121
#
#          ON ACTION help          #MOD-4C0121
#             CALL cl_show_help()  #MOD-4C0121
#
#          ON ACTION controlg      #MOD-4C0121
#             CALL cl_cmdask()     #MOD-4C0121
#
#              ON ACTION qbe_save
#                 CALL cl_qbe_save()
#
#       END CONSTRUCT

#       IF INT_FLAG THEN RETURN END IF #FUN-720009
#
#       IF g_aza.aza50='Y' THEN
#          CONSTRUCT g_wc3 ON oeb03_1,oeb1007,oeb1008,oeb1009,oeb1010,
#                             oeb1011,oeb1001_1,oeb14_1,oeb14t_1
#                  FROM s_oeb1[1].oeb03_1,s_oeb1[1].oeb1007,s_oeb1[1].oeb1008,
#                       s_oeb1[1].oeb1009,s_oeb1[1].oeb1010,
#                       s_oeb1[1].oeb1011,s_oeb1[1].oeb1001_1,
#                       s_oeb1[1].oeb14_1,s_oeb1[1].oeb14t_1
#
#   		          BEFORE CONSTRUCT
#   		             CALL cl_qbe_display_condition(lc_qbe_sn)
#                ON ACTION controlp
#                   CASE
#                      WHEN INFIELD(oeb1007)
#                         CALL cl_init_qry_var()
#                         LET g_qryparam.state = "c"
#                         LET g_qryparam.form ="q_tqw2"      #No.FUN-820033
#                         CALL cl_create_qry() RETURNING g_qryparam.multiret
#                         DISPLAY g_qryparam.multiret TO oeb1007
#                         NEXT FIELD oeb1007
#                      OTHERWISE
#                   END CASE
#
#                ON IDLE g_idle_seconds
#                   CALL cl_on_idle()
#                   CONTINUE CONSTRUCT
#
#                ON ACTION about         #MOD-4C0121
#                   CALL cl_about()      #MOD-4C0121
#
#                ON ACTION help          #MOD-4C0121
#                   CALL cl_show_help()  #MOD-4C0121
#
#                ON ACTION controlg      #MOD-4C0121
#                   CALL cl_cmdask()     #MOD-4C0121
#
#   		          ON ACTION qbe_save
#   		             CALL cl_qbe_save()
#             END CONSTRUCT
#
#          IF INT_FLAG THEN RETURN END IF #FUN-720009
#       END IF
#    END IF   #FUN-580155
#####
       IF g_aza.aza50='N' THEN
          DIALOG ATTRIBUTES(UNBUFFERED)
          CONSTRUCT BY NAME g_wc ON      # 螢幕上取單頭條件
             oea00,oea08,oea01,oea06,oea02,oea11,oea12,oea03,oea032,
             oea04,oea17,oea1004,oea1015,oea14,oea15,oea1002,oea1009,
             oea1003,oea917,
             oea10,oea23,oea24,oea21,oea211,oea212,oea213,  #FUN-820046 add oea917
             oea31,oea32,oea37,oea50,oeamksg,oea1005,oeahold,oeaconf,oeacont,oea49, #No.FUN-870007-add-oeacont
             oea044,oea41,oea42,oea43,oea44,oea33,oea09,oea1012,oea1013,
             oea1014,oea161,oea261,oea162,oea262,oea163,oea263,oea1011,oea1010,oea05,oea18,     #No:FUN-A50103
             oea07,oea62,oea63,oea65,oea95,                    #No.FUN-870007    #FUN-CC0057 add oea95
             oea83,oea84,oea85,oea86,oea87,oeaplant,oeaconu,   #No.FUN-870007
             oea88,oea89,oea90,oea91,oea92,oea93,oea94,        #No.FUN-870007   #FUN-A50071 add oea94
             oea25,oea26,oea46,oea80,oea81,oea47,oea48,        #No.FUN-870007
            #oea905,oea99,oea61,oeauser,oeagrup,oeamodu,oeadate,             #TQC-C90021 mark
             oea905,oea99,oeauser,oeagrup,oeamodu,oeadate,                   #TQC-C90021 add
             oeaoriu,oeaorig,                                  #TQC-A30041 ADD
             oeaud01,oeaud02,oeaud03,oeaud04,oeaud05,
             oeaud06,oeaud07,oeaud08,oeaud09,oeaud10,
             oeaud11,oeaud12,oeaud13,oeaud14,oeaud15    #No:FUN-A50103
#            oea918,oea919      #FUN-8C0078   #No:FUN-A50103 Mark

               BEFORE CONSTRUCT
                  CALL cl_qbe_init()

               AFTER FIELD oea11
                  LET l_oea11 = GET_FLDBUF(oea11)
          END CONSTRUCT 
          
#FUN-B90101---add--str---
#FUN-B90101---add--end--
          CONSTRUCT g_wc2 ON oeb03,
           oeb49,oeb50,oeb04,oeb06,oeb918,oeb11,oeb1001,oeb1012,oeb906,oeb092,  #FUN-A80054  #FUN-A90040
           oeb15,oeb51,oeb72,oeb32,oeb30,oeb31,oeb05,oeb12,  #No.FUN-5C0076     #No.FUN-740016  #No.FUN-A80024 #FUN-B20060 add oeb72 #FUN-C90011 Add oeb51
           oeb913,oeb914,oeb915,oeb910,oeb911,oeb912,
           oeb916,oeb917,oeb29,oeb24,oeb25,oeb27,oeb28,oeb1004,oeb1002,   # 螢幕上取單身條件  #NO.FUN-670007   #No.FUN-740016
           oeb37,oeb13,oeb1006,oeb14,oeb14t,oeb919,oeb41,oeb42,oeb43,oeb09,oeb091,    #FUN-810045 add oeb41,42,43  ##FUN-A80102    #FUN-AB0061 add oeb37
           oeb930,oeb908,oeb22,oeb19,oeb70,oeb16  #FUN-670063 #FUN-6B0151 add oeb16
           ,oebud01,oebud02,oebud03,oebud04,oebud05
           ,oebud06,oebud07,oebud08,oebud09,oebud10
           ,oebud11,oebud12,oebud13,oebud14,oebud15
           ,oeb44,oeb45,oeb46,oeb47,oeb48          #No.FUN-870007
       FROM
           s_oeb[1].oeb03,                           #No.FUN-7C0017
           s_oeb[1].oeb49,s_oeb[1].oeb50,s_oeb[1].oeb04,s_oeb[1].oeb06,s_oeb[1].oeb918, #FUN-A80054  #FUN-A90040
           s_oeb[1].oeb11,s_oeb[1].oeb1001,s_oeb[1].oeb1012,s_oeb[1].oeb906,s_oeb[1].oeb092,
           s_oeb[1].oeb15,s_oeb[1].oeb51,s_oeb[1].oeb72,s_oeb[1].oeb32,s_oeb[1].oeb30,s_oeb[1].oeb31,s_oeb[1].oeb05,s_oeb[1].oeb12,    #No.FUN-5C0076   #No.FUN-740016  #No.FUN-A80024a  #FUN-B20060 add oeb72 #FUN-C90011 Add Oeb51
           s_oeb[1].oeb913,s_oeb[1].oeb914,s_oeb[1].oeb915,
           s_oeb[1].oeb910,s_oeb[1].oeb911,s_oeb[1].oeb912,
           s_oeb[1].oeb916,s_oeb[1].oeb917,s_oeb[1].oeb29,s_oeb[1].oeb24,s_oeb[1].oeb25,   #No.FUN-740016
           s_oeb[1].oeb27,s_oeb[1].oeb28,       #NO.FUN-670007 add
           s_oeb[1].oeb1004,s_oeb[1].oeb1002,
           s_oeb[1].oeb37,s_oeb[1].oeb13,s_oeb[1].oeb1006,  #FUN-AB0061 add s_oeb[1].oeb37 
           s_oeb[1].oeb14,s_oeb[1].oeb14t,s_oeb[1].oeb919,  #FUN-A80102
           s_oeb[1].oeb41,s_oeb[1].oeb42,s_oeb[1].oeb43,  #FUN-810045 
           s_oeb[1].oeb09,s_oeb[1].oeb091,s_oeb[1].oeb930,s_oeb[1].oeb908,  #FUN-670063
           s_oeb[1].oeb22,s_oeb[1].oeb19,s_oeb[1].oeb70,s_oeb[1].oeb16  #FUN-6B0151 add oeb16
           ,s_oeb[1].oebud01,s_oeb[1].oebud02,s_oeb[1].oebud03,s_oeb[1].oebud04,s_oeb[1].oebud05
           ,s_oeb[1].oebud06,s_oeb[1].oebud07,s_oeb[1].oebud08,s_oeb[1].oebud09,s_oeb[1].oebud10
           ,s_oeb[1].oebud11,s_oeb[1].oebud12,s_oeb[1].oebud13,s_oeb[1].oebud14,s_oeb[1].oebud15
           ,s_oeb[1].oeb44,s_oeb[1].oeb45,s_oeb[1].oeb46,s_oeb[1].oeb47,s_oeb[1].oeb48   #No.FUN-870007

	       	BEFORE CONSTRUCT
		        CALL cl_qbe_display_condition(lc_qbe_sn)     
	      	END CONSTRUCT 
             ON ACTION controlp
                CASE
                   WHEN INFIELD(oea01) #查詢單据
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_oea11"   #MOD-4A0252
                        IF g_argv1='0' THEN
                           LET g_qryparam.where = " oea00 = '0' "
                        END IF
                        IF g_argv1='1' THEN
			                     LET g_qryparam.where = " oea00 MATCHES '[123467]' AND oea901 = '",g_oea901,"' "
                        END IF
                        IF g_argv1='2' THEN
                           LET g_qryparam.where = " oea00 MATCHES '[89]' "
                        END IF
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea01
                        NEXT FIELD oea01
                   WHEN INFIELD(oea12)
                      CASE l_oea11
                         WHEN '2'
                            CALL cl_init_qry_var()
                            LET g_qryparam.state = "c"
                            LET g_qryparam.form ="q_oha"
                            CALL cl_create_qry() RETURNING g_qryparam.multiret
                            DISPLAY g_qryparam.multiret TO oea12
                         WHEN '3'
                            CALL cl_init_qry_var()
                            LET g_qryparam.state = "c"
                            #LET g_qryparam.form ="q_oea2" #MOD-BC0210 mark
                            LET g_qryparam.form ="q_oea22" #MOD-BC0210 add
                            CALL cl_create_qry() RETURNING g_qryparam.multiret
                            DISPLAY g_qryparam.multiret TO oea12
                         WHEN '4'
                            CALL cl_init_qry_var()
                            LET g_qryparam.state = "c"
                            LET g_qryparam.form ="q_oqa"
                            CALL cl_create_qry() RETURNING g_qryparam.multiret
                            DISPLAY g_qryparam.multiret TO oea12
                         WHEN '5'
                            CALL cl_init_qry_var()
                            LET g_qryparam.state = "c"
                            LET g_qryparam.form ="q_oqt"
                            CALL cl_create_qry() RETURNING g_qryparam.multiret
                            DISPLAY g_qryparam.multiret TO oea12
                         WHEN '7'
                            CALL cl_init_qry_var()
                            LET g_qryparam.state = "c"
                            LET g_qryparam.form ="q_oga"
                            CALL cl_create_qry() RETURNING g_qryparam.multiret
                            DISPLAY g_qryparam.multiret TO oea12
                         OTHERWISE EXIT CASE
                      END CASE

                   WHEN INFIELD(oea1015)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state = "c"
                      LET g_qryparam.form ="q_pmc8"
                      LET g_qryparam.default1 = g_oea.oea1015
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO oea1015
                      NEXT FIELD oea1015
                   WHEN INFIELD(oea03)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        #-----MOD-A30026---------
                        #LET g_qryparam.form ="q_occ3"   
                        IF g_aza.aza50='Y' THEN  
                           LET g_qryparam.form ="q_occ3" 
                        ELSE 
                           LET g_qryparam.form ="q_occ"  
                        END IF   
                        #-----END MOD-A30026-----
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea03
                        NEXT FIELD oea03
                   WHEN INFIELD(oea04)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        IF g_aza.aza50='Y' THEN
                           LET g_qryparam.form ="q_occ4"    #FUN-610055
                        ELSE
                           LET g_qryparam.form ="q_occ"  #No.FUN-650108
                        END IF
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea04
                        NEXT FIELD oea04
                   WHEN INFIELD(oea14)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_gen"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea14
                        NEXT FIELD oea14
                   WHEN INFIELD(oea15)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_gem"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea15
                        NEXT FIELD oea15
                   WHEN INFIELD(oea1011)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_occ7"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea1011
                        NEXT FIELD oea1011
                   WHEN INFIELD(oea17)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        IF g_aza.aza50='Y' THEN
                           LET g_qryparam.form ="q_occ6"
                        ELSE
                           LET g_qryparam.form ="q_occ"  #No.FUN-650108
                        END IF
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea17
                        NEXT FIELD oea17
                   WHEN INFIELD(oea1002)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_tqa1"
                        LET g_qryparam.arg1 ='20'
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea1002
                        NEXT FIELD oea1002
                   WHEN INFIELD(oea1003)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_tqb"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea1003
                        NEXT FIELD oea1003
                   WHEN INFIELD(oea1004)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_occ5"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea1004
                        NEXT FIELD oea1004
                   WHEN INFIELD(oea1009)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_tqa1"
                        LET g_qryparam.arg1 ='19'
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea1009
                        NEXT FIELD oea1009
                   WHEN INFIELD(oea1010)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_tqb"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea1010
                        NEXT FIELD oea1010
                   WHEN INFIELD(oea21)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        IF g_aza.aza26 = '2' THEN         #TQC-A50060 --modify
                           LET g_qryparam.form ="q_gec9"  #TQC-A50060 --modify
                        ELSE                              #TQC-A50060 --modify
                        LET g_qryparam.form ="q_gec"
                        END IF                            #TQC-A50060 --modify
                        LET g_qryparam.arg1 = '2'
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea21
                        NEXT FIELD oea21
                   WHEN INFIELD(oea23)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_azi"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea23
                        NEXT FIELD oea23
                   WHEN INFIELD(oea25)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_oab"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea25
                        NEXT FIELD oea25
                   WHEN INFIELD(oea26)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_oab"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea26
                        NEXT FIELD oea26
                   WHEN INFIELD(oea31)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_oah"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea31
                        NEXT FIELD oea31
                   WHEN INFIELD(oea32)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_oag"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea32
                        NEXT FIELD oea32
                   WHEN INFIELD(oea044)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_ocd"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea044
                   WHEN INFIELD(oea41)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_oac"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea41
                   WHEN INFIELD(oea42)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_oac"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea42
                   WHEN INFIELD(oea43)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_ged"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea43
                   WHEN INFIELD(oea44)    #MOD-4A0252
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form = "q_ocf"   # MOD-580085
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea44
                   WHEN INFIELD(oea46)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_pja2"  #FUN-810045
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea46
                   WHEN INFIELD(oea47)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form = "q_pmc4"
                        LET g_qryparam.arg1 = '4'
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea47
                   WHEN INFIELD(oea48)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form = "q_ofs"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea48
                   WHEN INFIELD(oeahold)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_oak1"
                        LET g_qryparam.default1= g_oea.oeahold
                        LET g_qryparam.arg1 ='1'
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oeahold
                        NEXT FIELD oeahold
                   WHEN INFIELD(oea80)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_oag"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea80
                        NEXT FIELD oea80
                   WHEN INFIELD(oea81)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_oag"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea81
                        NEXT FIELD oea81
                   WHEN INFIELD(oea83)
                         CALL cl_init_qry_var()
                         LET g_qryparam.state = "c"
                         LET g_qryparam.form ="q_oea83"
                         CALL cl_create_qry() RETURNING g_qryparam.multiret
                         DISPLAY g_qryparam.multiret TO oea83
                         NEXT FIELD oea83
                   #FUN-CC0057---------add------str
                   WHEN INFIELD(oea95)
                         CALL cl_init_qry_var()
                         LET g_qryparam.state = "c"
                         LET g_qryparam.form ="q_oea95"
                         CALL cl_create_qry() RETURNING g_qryparam.multiret
                         DISPLAY g_qryparam.multiret TO oea95
                         NEXT FIELD oea95
                   #FUN-CC0057---------add------end
                   WHEN INFIELD(oea84)
                         CALL cl_init_qry_var()
                         LET g_qryparam.state = "c"
                         LET g_qryparam.form ="q_oea84"
                         CALL cl_create_qry() RETURNING g_qryparam.multiret
                         DISPLAY g_qryparam.multiret TO oea84
                         NEXT FIELD oea84
                   WHEN INFIELD(oea86)
                         CALL cl_init_qry_var()
                         LET g_qryparam.state = "c"
                         LET g_qryparam.form ="q_oea86"
                         CALL cl_create_qry() RETURNING g_qryparam.multiret
                         DISPLAY g_qryparam.multiret TO oea86
                         NEXT FIELD oea86
                   WHEN INFIELD(oeaconu)
                         CALL cl_init_qry_var()
                         LET g_qryparam.state = "c"
                         LET g_qryparam.form ="q_oeaconu"
                         CALL cl_create_qry() RETURNING g_qryparam.multiret
                         DISPLAY g_qryparam.multiret TO oeaconu
                         NEXT FIELD oeaconu
                   WHEN INFIELD(oeaplant)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_azp"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oeaplant
                        NEXT FIELD oeaplant
                   WHEN INFIELD(oeaud02)
                      CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO oeaud02
                      NEXT FIELD oeaud02
                   WHEN INFIELD(oeaud03)
                      CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO oeaud03
                      NEXT FIELD oeaud03
                   WHEN INFIELD(oeaud04)
                      CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO oeaud04
                      NEXT FIELD oeaud04
                   WHEN INFIELD(oeaud05)
                      CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO oeaud05
                      NEXT FIELD oeaud05
                   WHEN INFIELD(oeaud06)
                      CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO oeaud06
                      NEXT FIELD oeaud06
##

#FUN-B90101--add--begin--
                 WHEN INFIELD(oebslk04)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form ="q_oebslk04"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO oebslk04
                     NEXT FIELD oebslk04    
                 WHEN INFIELD(oebslk05)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form ="q_gfe"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO oebslk05
                     NEXT FIELD oebslk05
                 WHEN INFIELD(oebslk09)
                     CALL q_imd_1(TRUE,TRUE,"","","","","") RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO oebslk09
                     NEXT FIELD oebslk09
                 WHEN INFIELD(oebslk091)
                     CALL q_ime_1(TRUE,TRUE,"","","","","","","") RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO oebslk091
                     NEXT FIELD oebslk091                   
#FUN-B90101--add--end--

  #No.FUN-A90040      begin--       
             WHEN INFIELD(oeb49)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_oeb49"  
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oeb49
                 NEXT FIELD oeb49
    #No.FUN-A90040      end-- 



                WHEN INFIELD(oeb1001)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                      LET g_qryparam.form ="q_azf03" #TQC-7C0098
                      LET g_qryparam.arg1 = "2"   #No.FUN-660073
                      LET g_qryparam.arg2 = "1"   #No.TQC-7C0098
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oeb1001
                   NEXT FIELD oeb1001
                WHEN INFIELD(oeb31)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_azf1"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oeb31
                   NEXT FIELD oeb31
                WHEN INFIELD(oeb04)
         #No.FUN-A90048 -------------start-----------------------       
         #          CALL cl_init_qry_var()
         #          LET g_qryparam.state = "c"
         #          IF g_aza.aza50='Y' THEN
         #             LET g_qryparam.form ="q_ima15"   #FUN-610055
         #          ELSE
         #             LET g_qryparam.form ="q_ima"   #FUN-610055
         #          END IF
         #          CALL cl_create_qry() RETURNING g_qryparam.multiret
                   IF g_aza.aza50='Y' THEN
                      CALL q_sel_ima( TRUE, "q_ima15","","","","","","","",'') 
                              RETURNING  g_qryparam.multiret
                   ELSE
                      CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')
                              RETURNING  g_qryparam.multiret
                   END IF
          #No.FUN-A90048 -------------end -------------------------
                   DISPLAY g_qryparam.multiret TO oeb04
                   NEXT FIELD oeb04

                WHEN INFIELD(oeb05)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_gfe"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oeb05
                   NEXT FIELD oeb05

                #FUN-A80054--begin--add----------
                WHEN INFIELD(oeb918)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_eda"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oeb918
                   NEXT FIELD oeb918
                #FUN-A80054--end--add------------

                WHEN INFIELD(oeb908)
                   CALL q_coc2(TRUE,TRUE,g_oeb[1].oeb908,'',g_oea.oea02,'0',
                               '',g_oeb[1].oeb04)
                   RETURNING g_oeb[1].oeb908
                   DISPLAY BY NAME g_oeb[1].oeb908
                   NEXT FIELD oeb908
                WHEN INFIELD(oeb913)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_gfe"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oeb913
                   NEXT FIELD oeb913

                WHEN INFIELD(oeb910)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_gfe"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oeb910
                   NEXT FIELD oeb910

                WHEN INFIELD(oeb916)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_gfe"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oeb916
                   NEXT FIELD oeb916
                WHEN INFIELD(oeb1004)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_tqx3"  #TQC-7C0098
                   LET g_qryparam.arg1 = g_oea.oea23  #TQC-7C0098
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oeb1004
                   NEXT FIELD oeb1004
                WHEN INFIELD(oeb41) #專案
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pja2"
                  LET g_qryparam.state = "c"   #多選
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oeb41
                  NEXT FIELD oeb41
                WHEN INFIELD(oeb42)  #WBS
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pjb4"
                  LET g_qryparam.state = "c"   #多選
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oeb42
                  NEXT FIELD oeb42
                WHEN INFIELD(oeb43)  #活動
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pjk3"
                  LET g_qryparam.state = "c"   #多選
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oeb43
                  NEXT FIELD oeb43
                WHEN INFIELD(oeb09)
                #No.FUN-AA0048  --Begin
                #  CALL cl_init_qry_var()
                #  LET g_qryparam.state = "c"
                #  LET g_qryparam.form ="q_imd01"
                #  CALL cl_create_qry() RETURNING g_qryparam.multiret
                   CALL q_imd_1(TRUE,TRUE,"","","","","") RETURNING g_qryparam.multiret
                #No.FUN-AA0048  --End  
                   DISPLAY g_qryparam.multiret TO oeb09
                   NEXT FIELD oeb09
                WHEN INFIELD(oeb091)
                #No.FUN-AA0048  --Begin
                #  CALL cl_init_qry_var