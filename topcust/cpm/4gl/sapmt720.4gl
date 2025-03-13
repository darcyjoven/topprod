# Prog. Version..: '5.30.06-13.03.12(00000)'     #
# Pattern name...: apmt720.4gl
# Descriptions...: 採購庫存異動維護作業
# Date & Author..: 97/05/13 By Kitty
# Modify.........: 99/06/01 By Carol:由apmt110傳值g_argv1='5'時
#                                    不顯示畫面直接call t720_y()
# Modify.........: 99/10/04 By Kammy:增加 X.作廢 功能
# Modify.........: #No:7516 03/07/16 By Mandy
#                  apmt730'1.轉報工單' 時,
#                  IF  RUN CARD委外 THEN
#                      串asft730(Run Card 生產日報)
#                  ELSE
#                      串asft700(生產日報)
#                  END IF
# Modify.........: No:7708 03/08/06 By Mandy
#                  UPDATE sfa_file 時,確認還原時有判別 SQLCA.sqlerrd[3],
#                  但確認時,.並沒有會造成可以確認,郤無法確認還原
# Modify.........: No:7692 03/08/18 By Mandy 委外收入資料應納入
# Modify.........: No:7857 03/08/20 By Mandy  呼叫自動取單號時應在 Transction中
# Modify.........: No.7882 03/08/22 By Kammy 所有三角貿易單據統一在 apmt74*查
# Modify.........: No:7922 03/08/26 By Mandy 自動開窗詢問=>是否將剩餘未入庫量
#                                            轉為驗退單(Y/N)? 錯誤
# Modify.........: No.7944 03/08/27 Kammy 1.add rva99 多角序號
#                                         2.多角流程檔案poa_file改成poz_file
# Modify.........: No.8939 04/01/09 Kammy 1.輸入數量時入庫數量可大於允收數量
#                                         2.確認時也應檢查 Bug No.5071
# Modify.........: No.9475 04/04/20 Melody LET g_sql=g_sql CLIPPED,' ORDER BY 3,
# Modify.........: No:9733 04/07/08 By Wiky 倉退: t720_bu 在call t720_log 應要排除料件為'MISC'者
# Modify.........: No.9772 04/07/21 Wiky 倉退單沒有對應收料單時,單身不會
#                :                       有採購單資訊t720_u_pmn()應檢查是否有採購單資訊才做
# Modify.........: 04/07/19 By Wiky Bugno.MOD-470041 修改INSERT INTO...
# Modify.........: No.MOD-470479 04/07/22 Kammy 1.修改單價、金額的權限控管
#                                         2. rvv06 = rvu09 未 default
#                                         3. ON ROW CHANGE要加 t720_move_back
# Modify.........: No.9786 04/07/22 Wiky  同張單據,同收貨單項次不可超退(倉退/驗退)
# Modify.........: No.MOD-470534 04/07/27 ching 非委外 應抑制 "轉報工" 功能
# Modify.........: No.9798 04/07/22 Wiky  IQC 檢驗不良若要放入待交換,且收貨單同時有入庫/驗退單時
#                                         調整參數,使捲頁動作仍在入庫,以正確存入tlf
# Modify.........: No.MOD-480495 Kammy 若沒有unit_price的權限，將單價金額隱藏
# Modify.........: No.MOD-480604 04/09/15 By Smapmin 增加倉庫開窗功能
# Modify.........: No.MOD-490571 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.MOD-4A0063 04/10/06 By Mandy q_ime 的參數傳的有誤
# Modify.........: No.MOD-4A0115 04/10/07 定義方式改為like
# Modify.........: No.MOD-4A0213 04/10/14 By Mandy q_imd 的參數傳的有誤
# Modify.........: No.MOD-4A0224 04/10/14 By Mandy 查詢時在收貨單號做開窗,可開窗做選擇,但是選擇後按確定並無傳資料回收貨單號這個欄位
# Modify.........: No.MOD-4A0252 04/10/21 By Smapmin 增加異動單號開窗功能
# Modify.........: No.FUN-4B0025 04/11/05 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.MOD-4B0275 04/11/27 By Danny CALL q_coc2
# Modify.........: No.FUN-4C0011 04/12/02 By Mandy 單價金額位數改為dec(20,6) 或DEFINE 用LIKE方式
# Modify.........: No.FUN-4C0056 04/12/09 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.MOD-4C0053 04/12/10 By Mandy UPDATE rvb_file SET rvb31 = rvb07 - l_rvb29 - l_rvb30 在有 QC 判定允收數量時應該改為SET rvb31 = rvb33 - rvb29 - rvb30
# Modify.........: No.MOD-520104 05/02/21 By Kitty 折讓的開立折讓單否可以不一定要勾
# Modify.........: No.MOD-530073 05/03/24 By Mandy 單身 CONSTRUCT 欄位不可包含 ima021
# Modify.........: No.MOD-530020 05/03/24 By Mandy 按折讓的action,出現此筆單據已取消確認的訊息
# Modify.........: No.BUG-530697 05/03/28 By alex 取消 MOD-480495 更改處
# Modify.........: No.MOD-530452 05/03/29 By Mandy '入庫' 時 '開立折讓單' 應為 noentry
# Modify.........: No.MOD-530510 05/03/29 By Mandy 加強UPDATE imb_file的錯誤訊息
# Modify.........: No.MOD-530023 05/05/05 By Mandy 做確認後會問將剩餘未入庫量轉轉為驗退單,但產生的驗退單少了一筆
# Modify.........: No.MOD-540148 05/05/05 By Mandy 新增時,輸入完一筆單身資料,就去出現Warning(lib-219)您在%1中沒有執行%2的權限!(請檢查權限設定)的訊息.
# Modify.........: No.FUN-550011 05/05/25 By kim GP2.0功能 庫存單據不同期要check庫存是否為負
# Modify.........: No.FUN-540027 05/05/26 By Carrier 雙單位內容修改
# Modify.........: NO.FUN-550060 05/05/31 By jackie 單據編號加大
# Modify.........: No.MOD-550053 05/05/06 By Mandy 單身收貨項次加入限定條件，應做而未做品檢的料不可以直接錄入驗退單。
# Modify.........: No.MOD-560042 05/06/09 By Mandy 單價/金額欄位無法顯示
# Modify.........: No.FUN-560040 05/06/15 By Mandy 允許倉退數量為零
# Modify.........: No.MOD-570098 05/08/10 By Nicola 入庫單卡若有倉退單則無法取消確認的地方,應排除已作廢之倉退單
# Modify.........: No.FUN-570107 05/08/10 By Nicola 1.已做過截取信息至acoi501的收貨單應不可以在做還原修改；
# Modify.........: No.Bug-580184 05/08/17 By Rosayu 1.錯誤訊息mfg3253-->mfg3252
#                   2.新增錯誤訊息3252-->新增一個錯誤訊息,==>此數為可入庫量,異動數量不可大於可入庫量!
#                   3.訊息改要顯示g_inqty
# Modify.........: No.MOD-580138 05/08/17 By Rosayu 修改訊息apm-258:
#                  rvv35<--->g_img09,無此筆記錄的異動單位和倉庫庫存單位間的換算率,請至aooi101 或 aooi102 或 aooi103 補齊資料。
# Modify.........: No.MOD-580161 05/08/24 By Mandy AFTER FIELD rvv31(料件)之後,若是rvv35,rvv80,rvv83,rvv86 是空白的,給default值
# Modify.........: No.MOD-590119 05/09/09 By Carrier 多單位set_origin_field修改
# Modify.........: No.MOD-580168 05/09/12 By Nicola 產生入庫單後,點選[查詢入庫單],將該張入庫單作[確認],遇[詢問是否產生驗退單],選擇Y,隨後竟可於apmt720看到該張驗退單
# Modify.........: No.MOD-590354 05/09/30 By Nicola Sql語法修改
# Modify.........: No.FUN-590133 05/10/27 By ice for大陸版時,apmt720增加BUTTON:價格變更
# Modify.........: No.TQC-5B0009 05/11/09 By Nicola 標題修改
# Modify.........: No.MOD-590539 05/10/20 By Nicola 入庫單在"取消作廢"時,應判斷其對應的收貨單確認碼為"Y"的才可做
# Modify.........: NO.FUN-5B0027 05/11/16 BY Nicola 單身倉庫有效日期判斷
# Modify.........: No.TQC-5B0159 05/11/24 By Rosayu 倉退單身應可輸入數量為0
# Modify.........: No.TQC-5C0014 05/12/05 By Carrier set_required時去除單位換算率
# Modify.........: No.FUN-5B0144 05/12/09 By Rsoayu 1.倉退數量為0時單價金額會重新計算導致金額被清為0
#                                                   2.收貨單空值時，隱藏欄位的單價及金額會是0
# Modify.........: No.MOD-5A0431 05/12/09 By Rosayu 同一收貨單同一項次之入庫總數量不可大於收量
# Modify.........: No.MOD-5C0086 05/12/20 By Nicola 委外採購單，不可倉退
# Modify.........: No.MOD-5C0089 05/12/20 By Nicola 入庫量 rvb31 應 = rvb33 - rvb30
# Modify.........: No.MOD-530018 05/12/20 By Mandy 1.可驗退量應判斷<=實收貨量rvb07-允收量rvb33
# Modify.........: No.MOD-530018 05/12/20 By Mandy 2.MOD-4C0053反應的內容有誤，可入庫量 rvb31 應 = rvb33 - rvb30
# Modify.........: No.MOD-5C0167 06/01/06 By Nicola rvv33,rvv34 Null的判斷移至t720_b_move_back之前
# Modify.........: No.MOD-5C0165 06/01/06 By Nicola 取消確認時，加入sub的判斷
# Modify.........: No.FUN-610018 06/01/17 By ice 採購含稅單價功能調整
# Modify.........: No.FUN-610076 06/01/20 By Nicola 計價單位功能改善
# Modify.........: No.MOD-610067 06/01/23 By Nicola return時，改call show()
# Modify.........: No.FUN-610090 06/02/07 By Nicola 拆併箱功能修改
# Modify.........: No.FUN-610067 06/02/06 By Smapmin 雙單位畫面調整
# Modify.........: No.TQC-630047 06/03/07 By Pengu 按完"確認"或"取消確認"後再進入單身，程式會當掉
# Modify.........: No.MOD-630024 06/03/07 採購倉退目前會判斷有收貨單才會更新原採購單的倉退量.但現在單
                      #                   身可以不打收貨單,但可打採購單及項次.會沒有更新倉退量.
# Modify.........: No.MOD-630031 06/03/07 By Mandy 1.該計價單位不使用.但倉退作業仍會出現計價數量
#                                                  2.修改原倉退數[rvv17]後,計價數量[rvv87]不會跟著動
# Modify.........: No.TQC-630068 06/03/07 By Sarah asft700從傳三個參數增加為傳五個參數
# Modify.........: No.FUN-630010 06/03/09 By saki 流程訊息通知功能
# Modify.........: NO.TQC-620156 06/03/14 By kim GP3.0過帳錯誤統整顯示功能新增
# Modify.........: No.TQC-610085 06/04/06 By claire Review所有報表程式接收的外部參數是否完整
# Modify.........: No.MOD-640268 06/04/10 By kim 「部門」、「人員」非必要欄位，若選取後，再取消，後方顯示欄位並未跟著清除
# Modify.........: No.MOD-640260 06/04/10 By kim 欄位順序建議先跳至 「人員」再 After Field「部門」 自動Default 帶出所屬部門
# Modify.........: No.MOD-640296 06/04/10 By kim 取消確認時，出現訊息 「u_rvb! 」。請顯示使用者可閱讀理解的訊息。
# Modify.........: No.MOD-640430 06/04/12 By Sarah 若QC時量是未全部Pass於入庫確認時會產生一張驗退單，產生後應呼叫apmt721，而不是把程式代號改成apmt721
# Modify.........: No.FUN-640176 06/04/20 By Sarah 當取回日期不為空白時,不得取消確認
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.MOD-650055 06/05/16 By Pengu 當系統參數設使用多單但aimi100中料號單位管制方式為1.單一單位
                              #                    若手動輸入單身資料時，會跳至母/參考單位及母/參考數量維護
# Modify.........: No.TQC-650108 06/05/24 By Rayven 增加多屬性料件機制
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.TQC-660097 06/06/21 By Rayven 多屬性功能改進:查詢時不顯示多屬性內容
# Modify.........: No.MOD-660090 06/06/22 By Rayven 料件多屬性補充修改，check_料號()內應再加傳p_cmd的參數
# Modify.........: No.MOD-660040 06/06/26 By Pengu 已做QC,也做入庫,但還是可以做驗退
# Modify.........: No.FUN-660218 06/07/03 By kim 多單位時,產生入庫數量一,入庫數量二時,需扣掉已入庫量
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-660085 06/07/03 By Joe 若單身倉庫欄位已有值，則倉庫開窗查詢時，重新查詢時不會顯示該料號所有的倉儲。
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.MOD-660046 06/07/05 By Pengu 修改FUN-540027修改段的程式語法
# Modify.........: No.TQC-630284 06/07/12 By Pengu 隱藏無權限按鈕功能修改
# Modify.........: No.FUN-670051 06/07/13 By kim GP3.5 利潤中心
# Modify.........: No.MOD-670098 06/07/25 By Claire b_rvv.*重複定義造成單身只會回寫第二筆
# Modify.........: NO.FUN-670007 06/08/16 BY yiting 判斷為多角收貨且未產生入庫單，則需帶出rvu20/rvu99,rvv17不可修改
# Modify.........: No.FUN-680136 06/09/07 By Jackho 欄位類型修改
# Modify.........: No.MOD-6A0081 06/10/25 By Mandy 誇月做取消確認,會產生負庫存的錯誤訊息(10月確認,11月做取消確認)
# Modify.........: No.CHI-6A0004 06/10/31 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.TQC-6A0074 06/11/10 By Claire 驗退不可做折讓
# Modify.........: No.FUN-6B0032 06/11/13 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.FUN-6A0162 06/11/16 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.MOD-680094 06/11/23 By Claire 排除作廢單據
# Modify.........: No.MOD-690013 06/11/23 By Claire 新增單頭不直接自動產生入庫單會有錯誤
# Modify.........: No.MOD-690021 06/11/23 By Claire 沒有收貨單的退倉不update rvb_file
# Modify.........: No.MOD-6B0028 06/11/23 By Claire 沒有收料單的倉退單新增時料號非MISC時,規格應不可修改
# Modify.........: No.MOD-6A0118 06/11/23 By Claire 允收量要加上待交換倉的數量去判斷
# Modify.........: No.CHI-6A0046 06/12/15 By rainy rvb31應該是rvb33-rvb29-rvb30
# Modify.........: No.TQC-690049 06/12/08 By pengu 若執行步驟為"新增"->"放棄"->"查詢"時，無法查詢收貨單號
# Modify.........: No.TQC-6B0124 06/12/19 By pengu 參數勾選不使用多單位但使用計價單位時，計價單位與計價數量會異常
# Modify.........: No.FUN-6C0055 07/01/08 By Joe 新增與GPM整合的顯示及查詢的Toolbar
# Modify.........: No.MOD-710011 07/01/08 By Claire 取消確認時要判斷是否存在應付憑單或外購到單存在
# Modify.........: No.FUN-6C0083 07/01/08 By Nicola 錯誤訊息彙整
# Modify.........: No.MOD-710017 07/01/10 By Claire 調整MOD-570098 加上關連
# Modify.........: No.TQC-710042 07/01/11 By Joe 解決未經設定整合之工廠,會有Action顯示異常情況出現
# Modify.........: No.CHI-710005 07/01/18 By Elva 去掉aza26的判斷
# Modify.........: No.MOD-710145 07/01/23 By claire 輸入數量為0的折讓時,含稅金額rvv39t會為null
# Modify.........: No.FUN-6C0050 07/01/29 By rainy 新增轉出貨單功能
# Modify.........: No.TQC-6B0079 07/03/05 By pengu  修改驗退數量控管1.若不走IQC流程時可驗退量為 = 收貨數量 - 入庫量
#                                                                   2.若走IQC流程時則可驗退量 = SUM(以登打的QC送驗量) - SUM(QC合格量)
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730068 07/03/29 By kim 行業別架構
# Modify.........: No.TQC-6C0131 06/04/11 By pengu 未考慮計價數量的沖銷的情形
# Modify.........: No.FUN-740046 07/04/12 By rainy 訂單號號/序號存到 pmn24/25,pmn94/95改為 no use
# Modify.........: No.FUN-740046 07/04/17 By rainy 單身採購單序號後加採購單資料來源，來源單號，來源序號
# Modify.........: No.TQC-740124 07/04/18 By chenl 修正原因碼不選擇直接退出報錯的問題。
# Modify.........: No.TQC-740117 07/04/20 By rainy GP5.0整合測試
# Modify.........: No.TQC-740163 07/04/21 By Xufeng GP5.0整合測試
# Modify.........: No.CHI-740040 07/04/23 By rainy 拋轉出貨單時無帶幣別，已拋出貨單不可取消確認
# Modify.........: No.MOD-740049 07/04/24 By pengu 更改倉庫及單頭自動產生單身時rvv35_fac換算率問題修正
# Modify.........: No.FUN-740171 07/04/24 By kim 單頭出貨單號不打時,單身收貨項次要NOENTRY
# Modify.........: No.MOD-740329 07/04/25 By kim 倉退時不可修改rvu00
# Modify.........: No.MOD-740475 07/04/25 By rainy 轉出貨單成功後show出產生的單號
# Modify.........: No.TQC-740305 07/04/26 By Lynn 不可拋轉資料點擊拋轉按鈕無任何報錯提示信息
# Modify.........: NO.MOD-740507 07/05/02 BY yiting TQC-740305判斷不對，應該是要己經拋轉的才要出現錯誤訊息
# Modify.........: No.MOD-740519 07/05/10 By claire 串入庫單已調整功能為外部呼叫,故原程式也需做調整
# Modify.........: No.CHI-730047 07/05/21 By claire 委外入庫單身有已結案工單時不能確認
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.CHI-770019 07/07/25 By Carrier 多單位:參考單位時,交易單位不寫入tlff
# Modify.........: No.MOD-770128 07/07/28 By pengu 當單頭有KEY收貨單號時，強制單身收貨項次一定要輸入
# Modify.........: No.MOD-770158 07/08/29 By claire 更改收量後直接按確認,計價數量也要修改
# Modify.........: NO.TQC-790003 07/09/03 BY yiting insert into前給予預設值
# Modify.........: NO.TQC-790083 07/09/10 BY wujie  rvv87取值有錯
# Modify.........: NO.TQC-790064 07/09/20 BY sherry 進行語言轉換時，進入“折讓”狀態
# Modify.........: NO.TQC-790140 07/09/27 BY wujie  在gapi140發票和入庫單對應關系建好后，仍可以對入庫單取消審核進行修改
# Modify.........: NO.MOD-7A0065 07/10/12 BY Carol 倉退時無img可自動新增
# Modify.........: No.MOD-7A0072 07/10/16 By Pengu 當QC有驗退情況時，在做驗退的數量的控管會異常
# Modify.........: No.TQC-7A0034 07/10/12 By lumxa  GP5.0版本 單身錄入稅前單價 并不能根據稅率計算出稅后單價
# Modify.........: No.TQC-7A0113 07/10/30 By wujie  單身項次帶出的稅率稅種欄位不正確
# Modify.........: No.MOD-790176 07/10/30 By Pengu 判斷若若是待採買料時則還原過帳不call s_stkminus
# Modify.........: No.MOD-7A0180 07/10/30 By claire 退倉時, 沒有數量只有金額, 未稅金額會取位, 含稅金額卻不會取位
# Modify.........: No.MOD-7B0144 07/11/14 By claire 已產生過銷退單時, 應顯示錯誤訊息, 避免誤以為程式完成產生
# Modify.........: No.TQC-7B0085 07/11/15 By Carol 調整MOD-7B0144的問題
# Modify.........: No.CHI-7B0023/CHI-7B0039 07/11/16 By kim 移除GP5.0行業別功能的所有程式段
# Modify.........: No.TQC-7B0129 07/11/23 By chenl 修正無法帶出含稅單價的問題。
# Modify.........: No.TQC-7B0083 07/11/22 By Carier rvv88賦初值0
# Modify.........: No.MOD-7C0019 07/12/04 By claire 轉出貨單的ogb13,ogb14應取自訂單的資料
# Modify.........: No.TQC-7C0058 07/12/26 By Unicorn 增加不可拋轉錯誤信息提示
# Modify.........: No.TQC-7C0062 07/12/26 By Unicorn 增加不可拋轉還原錯誤信息提示
# Modify.........: No.TQC-7C0063 07/12/26 By Unicorn 增加取消審核的條件多角貿易序號
# Modify.........: No.MOD-7C0052 07/12/07 By claire (1)中斷點的入庫單無法人工輸入,會有apm-015的錯誤
#                                                   (2)中斷點該站單據取消確認應可允許
# Modify.........: No.TQC-7C0075 07/12/10 By wujie 倉退判斷錯誤
# Modify.........: No.TQC-7C0073 07/12/13 By Unicorn 非多角貿易來源單據，并且無多角貿易序號時，允許錄入入庫單
# Modify.........: No.TQC-7C0020 07/12/13 By 調整對單位換算率、倉庫、儲位和批次抓取時報錯，判斷的修正。
# Modify.........: No.TQC-7C0146 07/12/14 By claire (1)不可以使用流程序號判斷中斷點
#                                                   (2)中斷點入庫單確認時要取得對應收貨單的流程序號寫入
#                                                   (3)中斷點入庫單取消確認時要清除流程序號
# Modify.........: No.FUN-7C0017 08/01/08 By bnlent 增加行業別規範化修改
# Modify.........: No.FUN-810046 08/01/15 By Johnray 增加串查段
# Modify.........: No.MOD-810200 08/01/24 By claire 倉儲批不可以null
# Modify.........: No.FUN-810038 08/02/12 By kim GP5.1 ICD ; sapmt720.4gl->sapmt720.src.4gl
# Modify.........: No.FUN-810045 08/03/01 By rainy  項目管理: 專案相關欄位代入tlf
# Modify.........: No.FUN-7B0018 08/03/06 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-810036 08/03/16 By Nicola 序號管理
# Modify.........: No.TQC-820011 08/03/18 By claire 銷售逆拋中斷點的入庫單需可以取消還原
# Modify.........: No.MOD-820087 08/03/18 By claire 倉退單的單身品名規格無法帶出
# Modify.........: No.CHI-820010 08/03/18 By claire 自動產單身時,不使用計價單位,計價數量=實收數,rvb87()計算時避免小數位差問題
# Modify.........: No.MOD-820189 08/03/18 By claire (1) 使用計價單位時,輸入完計價數量應不可再重算rvv87計價數量的值
#                                                   (2) 使用計價單位時,為避免重新輸入計價數量小數位計算,若入庫量=收貨數量,應直接帶入rvb87的值給rvv87
# Modify.........: No.FUN-830035 08/03/18 By claire 多角倉退單拋轉還原沒執行
# Modify.........: No.MOD-830159 08/03/21 By Carol 加倉退需為逆拋檢查
# Modify.........: No.CHI-830025 08/03/24 By kim GP5.1整合測試修改
# Modify.........: No.FUN-830078 08/03/24 By bnlent 錯誤訊息修改
# Modify.........: No.MOD-760028 08/03/25 By pengu 當使用多單位時可驗退量的控管與default異常
# Modify.........: No.MOD-810078 08/03/24 By Pengu 可入庫量公式應改為rvb31 = rvb33 - l_rvb30毋需減 rvb29
# Modify.........: No.MOD-810199 08/03/25 By Pengu 委外採購過帳還原時在update工單狀態應參考asft620考慮PULL情況
# Modify.........: No.MOD-830202 08/03/26 By Dido  倉退數量時 IQC 部分需全部計算
# Modify.........: No.MOD-830212 08/03/26 By Dido s_udima 傳遞參數有s_udima 傳遞參數有誤
# Modify.........: No.CHI-830032 08/03/28 By kim GP5.1整合測試修改
# Modify.........: No.MOD-830209 08/04/08 By claire 不勾選採購收貨允收數與IQC勾稽時,需驗退數量來自於rvb_file
# Modify.........: No.FUN-840032 08/04/08 By Dido 屬於委外採購亦可做價格變更
# Modify.........: No.FUN-840042 08/04/08 By Wind 自定欄位功能修改
# Modify.........: No.CHI-830033 08/04/18 By claire 未(含)稅金額=未(含)稅單價*計價數量的方式調整為:
#                                                   (1)單價含稅時,以含稅金額/(1+稅率)/100 = 未稅金額 
#                                                   (1)單價未稅時,以未稅金額*(1+稅率)/100 = 含稅金額 
# Modify.........: No.MOD-840218 08/04/20 By claire 重新過單
# Modify.........: No.MOD-840347 08/04/20 By Nicola 不做批/序號不刪除tlfs_file
# Modify.........: No.MOD-840560 08/04/22 By claire 不做中斷點時, 單據取消確認不可將多角序號清空
# Modify.........: No.FUN-840157 08/04/24 By Nicola IQC做批/序號管理
# Modify.........: No.MOD-840353 08/04/25 By Carrier 無法產生驗退單
# Modify.........: No.CHI-840043 08/04/25 By claire 倉退單, 不控管倉庫別是否為MRP/MPS可用
# Modify.........: No.MOD-840666 08/04/28 By claire rvv32應先display否則值會無法儲存
# Modify.........: No.CHI-850002 08/05/06 By Dido 排除MISC開頭的料號
# Modify.........: No.MOD-840694 08/05/06 By claire apm-730 在驗退單進單身後會控卡驗退數量,參數不勾選iqc數量與允收數勾稽
# Modify.........: No.MOD-850110 08/05/12 By Smapmin CALL t720_IQC_return2()之後,若t720_s1()檢核不通過,應重新顯示單身資料
# Modify.........: No.FUN-850120 08/05/21 By rainy 批序號新增參數 sma90 判斷
# Modify.........: No.FUN-850120 08/05/23 By rainy 多單位補批序號處理
# Modify.........: No.MOD-850300 08/05/30 By Smapmin 修改變數名稱
# Modify.........: No.MOD-860052 08/06/05 By Smapmin MISC料在確認時,未更新收貨單身的入庫量
# Modify.........: No.MOD-860080 08/06/09 By Nicola 自動產生入庫/銷退單時，判斷smy57為"Y"則只能產生一次，如為"N"則用允收量-已入庫量
# Modify.........: No.TQC-860019 08/06/09 By cliare ON IDLE 控制調整
# Modify.........: NO.CHI-860008 08/06/11 BY yiting s_del_rvbs
# Modify.........: No.FUN-860045 08/06/12 By Nicola 批/序號傳入值修改及開窗詢問使用者是否回寫單身數量
# Modify.........: No.MOD-860173 08/06/16 By Smapmin 輸入數量為0的折讓時,含稅金額rvv39t會為null
# Modify.........: No.MOD-860213 08/06/19 By claire 多角驗退時,rvu20,rvu99不顯示
# Modify.........: No.MOD-860227 08/06/23 By Smapmin 驗退單輸入收貨單號的開窗條件,不應考慮可入庫量rvb31
# Modify.........: No.MOD-860262 08/06/25 By Smapmin 系統使用計價單位,輸入完異動數量後計價數量沒有重新計算
# Modify.........: No.MOD-860279 08/06/25 By claire 中斷點的倉退單應不可控卡apm-015
# Modify.........: No.MOD-870058 08/07/04 By claire 銷售流程中斷點的入庫單無法還原確認
# Modify.........: No.MOD-870114 08/07/10 By claire 多角入庫單已有AP資料的不可拋轉還原
# Modify.........: No.MOD-850156 08/07/14 By Pengu 1.當油受貨單串入庫單並要自動確認時時應排除作廢單據
# Modify.........: No.MOD-870240 08/07/21 By Smapmin 單身數量不可為負數
# Modify.........: No.FUN-870110 08/07/21 By Nicola 異動數量為0時，不執行刪除tlfs_file的程式段
# Modify.........: No.CHI-860042 08/07/22 By xiaofeizhu 加入一般采購和委外采購的判斷
# Modify.........: No.MOD-880022 08/08/04 By Smapmin 當收貨單號不為NULL時,才做apm-034的判斷
# Modify.........: No.MOD-880057 08/08/07 By chenl   1.修正訂單結案后，仍然可拋轉出貨單的問題。
# Modify.........:                                   2.修正訂單拋轉出貨單后，更新單頭發票金額時，未對變量賦值的問題。
# Modify.........: No.TQC-880009 08/08/26 By chenyu 審核，取消審核的時候要判斷單身的采購單的狀態，只有在"2.發出采購單"的時候才可以
# Modify.........: NO.FUN-880016 08/08/27 BY yiting 增加GPM控管
# Modify.........: No.MOD-880191 08/09/03 By claire 一般倉退單需控管TRI單據性質的輸入
# Modify.........: No.MOD-890002 08/09/03 By claire 一般倉退單開窗查詢應不可查到多角收貨單
# Modify.........: No.MOD-890023 08/09/03 By chenyu ICD功能修改
# Modify.........: No.MOD-890106 08/09/11 By wujie  rvu00欄位不應該可以修改 
# Modify.........: No.FUN-880129 08/09/05 By xiaofeizhu s_del_rvbs的傳入參數(出/入庫，單據編號，單據項次，專案編號)，改為(出/入庫，單據編號，單據項次，檢驗順序)
# Modify.........: No.MOD-890276 08/09/30 By Smapmin 使用參考單位且參考數量為0時，也需寫入tlff_file
# Modify.........: No.MOD-890277 08/09/30 By Smapmin 單身的稅別與稅率的顯示,當依照採購單抓取不到時,就得依廠商基本資料來抓取
# Modify.........: No.FUN-840012 08/10/03 By kim mBarcode整合
# Modify.........: No.MOD-8A0068 08/10/08 By alexstar 修正單身收貨項次欄位按開窗時查不到資料的問題
# Modify.........: No.MOD-8A0070 08/10/08 By alexstar 修正當要做入庫時,開窗查詢收貨單卻查不到的狀況
# Modify.........: No.FUN-8A0054 08/10/13 By sabrina  若沒勾選〝與GPM整合〞，則不跑GPM控管
# Modify.........: No.MOD-8A0103 08/10/16 By Smapmin 產生待交換倉資料時,金額算錯
# Modify.........: No.CHI-8A0016 08/10/17 By Smapmin 詢問IQC檢驗不良是否放入待驗倉後,要判斷是否存在img_file/imgg_file,並依sma892[3,3]的設定決定是否開窗詢問要新增庫存明細資料
# Modify.........: No.MOD-8A0132 08/10/17 By liuxqa 判斷是否存在應付憑單時,修正其條件,將apa42 != 'x'改為apa42 ='N'
# Modify.........: No.MOD-8A0098 08/10/21 By wujie  設定單別綁定屬性群組時，修改多屬性料件欄位，開窗返回的還是未修改的老料號
# Modify.........: No.MOD-8A0183 08/10/21 By sherry 錄入時，稅前金額計算的保留小數位數，保存后會將小數位數變為0，以整數方式保存
# Modify.........: No.TQC-8A0071 08/10/29 By claire 多角倉退逆拋時,錯誤訊息調整
# Modify.........: No.MOD-8B0027 08/11/04 By sherry 單身收貨項次開窗不對
# Modify.........: No.MOD-8B0070 08/11/06 By claire oga14給值錯誤   
# Modify.........: No.MOD-8B0174 08/11/19 By Smapmin 倉庫不為空時,才檢核與庫存單位是否可轉換
# Modify.........: No.MOD-8C0089 08/12/09 By Smapmin 給予oga021空白值
# Modify.........: No.MOD-8C0183 08/12/20 By Smapmin 製程委外時不異動庫存資料,故關於倉儲批的判斷皆不需要
# Modify.........: No.CHI-8C0017 08/12/17 By xiaofeizhu 一般及委外問題處理
# Modify.........: No.FUN-8C0084 08/12/22 By jan s_upimg相關改以 料倉儲批為參數傳入 ,不使用 ROWID
# Modify.........: No.MOD-910091 09/01/09 By sherry 當采購單收貨入庫后，采購單結案,不能做這個收貨單的倉退單 
# Modify.........: No.CHI-8C0023 09/01/12 By xiaofeizhu 移除允許入庫單與收貨單別一致判斷
# Modify.........: No.MOD-910124 09/01/12 By chenyu 委外入庫單也要像委外收貨單中的對工單發料進行判斷
# Modify.........: No.MOD-910206 09/01/17 By Smapmin 由收貨單自動產生單身時,若異動數量<=0,則不做寫入
# Modify.........: No.MOD-8C0283 09/01/19 By claire 按轉報工單,先確認是否存在PQC單再執行
# Modify.........: No.MOD-910239 09/01/21 By sherry  1、修改消耗材料及代買料的發料套數
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.MOD-920018 09/02/02 By Smapmin imb118定義為本幣,故當sma25為'2'時,要先將原幣收貨單價轉換成本幣
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.CHI-8B0047 09/02/09 By xiaofeizhu apmt740增加拋轉出貨單功能
# Modify.........: No.CHI-920041 09/02/11 BY ve007 強制使用者一定要輸入倉儲批才可離開  
# Modify.........: No.TQC-910033 09/02/12 by ve007 抓取作業編號時，委外要區分制程和非制程
# Modify.........: No.FUN-910053 09/02/12 By jan sma74-->ima153
# Modify.........: No.MOD-920249 09/02/19 By chenl   系統采用雙單位，料件為單一單位時，自動拋轉驗退單時，不應將單位一數量和單位二數量置零，應保持原值。
# Modify.........: No.MOD-920279 09/02/23 By claire 倉退單已拋轉應不可以取消確認
# Modify.........: No.TQC-920088 09/02/26 By chenyu AFTER FIELD rvu03后面，rvb01應該和rvu02對應
# Modify.........: No.TQC-920090 09/02/26 By chenyu 在t720_g_b()中，ima01應該對應rvv31
# Modify.........: No.MOD-930070 09/03/06 By shiwuying 製程中委外入庫量可大於允收量
# Modify.........: No.MOD-930042 09/03/06 By Pengu 不打收貨單時倉退時無法選取批序號
# Modify.........: No.TQC-930128 09/03/19 By douzh 變量撰寫錯誤導致編譯不過
# Modify.........: No.FUN-930145 09/03/20 By destiny rvv26增加管控
# Modify.........: No.FUN-930108 09/03/20 By zhaijie增加s_incchk檢查使用者是否有相應倉,儲的過賬權限
# Modify.........: No.FUN-930107 09/03/24 By lutingting審核時若為委外入庫單且入庫后自動產生移轉資料,則CALL轉報工單按鈕邏輯進行處理 
# Modify.........: No.TQC-930155 09/04/14 By dongbg Transation處理
# Modify.........: No.MOD-940073 09/04/14 By Smapmin 沒有收貨單的料件抓取單價時,幣別依據為供應商基本資料的慣用幣別.
# Modify.........: No.MOD-940128 09/04/14 By Smapmin 新增img_file時因為儲位為NULL而導致出錯
# Modify.........: No.MOD-930261 09/04/14 By Smapmin 鎖表的時候失敗，有的地方不應該用ROLLBACK WORK,應該LET g_success = 'N'
# Modify.........: No.MOD-940235 09/04/26 By Dido 中斷點倉退多角序號應取前站銷退單多角序號
# Modify.........: No.TQC-940140 09/05/04 By chenyu 工藝委外入庫時，倉，儲，批三個字段設為no entry
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.MOD-950140 09/05/18 By chenyu 計算pmn51時，沒有考慮樣品rvb35
# Modify.........: No.TQC-950134 09/05/22 By Carrier rowid定義規範化
# Modify.........: No.MOD-950273 09/05/27 By Smapmin CALL s_lotin使用'SEL'動作前,得先判斷要不要insert rvbs_file
# Modify.........: No.MOD-950271 09/05/29 By Dido 轉出貨單單身時,倉儲批要判斷是否為空值
# Modify.........: No.FUN-940083 09/06/01 By Sunyanchun 新增VIM管理
# Modify.........: No.FUN-960007 09/06/03 By chenmoyan global檔內沒有定義rowid變量
# Modify.........: No.FUN-940083 09/06/15 By shiwuying 採購改善-VMI 新增自動取消審核功能
# Modify.........: No.MOD-940378 09/06/17 By mike 依儲位判斷全型空白條件有誤  
# Modify.........: No.MOD-960033 09/07/07 By Smapmin 刪除tlf_file/tlff_file時,要加入tlf13/tlff13的條件
# Modify.........: No.MOD-970043 09/07/07 By Dido 倉退拋轉還原需檢核是否已拋轉帳款
# Modify.........: No.TQC-950054 09/07/10 By jan updat行業別檔時，KEY值一并update 
# Modify.........: No.MOD-970081 09/07/16 By Smapmin 單身無法default項次欄位
# Modify.........: No.FUN-970041 09/07/17 By chenmoyan 多角入庫單加產生調撥單功能
# Modify.........: No.FUN-960130 09/07/21 By sunyanchun 增加流通零售段處理
# Modify.........: No.MOD-970204 09/07/22 By mike 入庫單按確認時將剩余未入庫量轉為驗退單                                            
#                                                 倉庫,儲位,批號要帶原收單單單身的倉庫,儲位,批號 
# Modify.........: No.MOD-970214 09/07/23 By sherry 在t720_set_rvv87()里面抓采購單位時，先抓采購單上的pmn07如果抓不到再抓ima44
# Modify.........: No.MOD-970192 09/07/22 By sabrina 當sma115='Y' and l_ima906='1'時剩餘未入庫量應轉為驗退單
# Modify.........: No.MOD-970272 09/08/04 By Dido 無論採購單是否存在皆須進入 t720_rvv39
# Modify.........: No.FUN-980006 09/08/17 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.......... No.FUN-930062 09/08/20 By lutingting apmt730新增action'領料生成','領料維護',新增欄位rvu16領料單號并只在apmt730顯示 
# Modify.........: No.CHI-980050 09/08/21 By mike 將l_rvb07 搬到 b_rvv.* 之前 ,避免 rvv 后續有新增欄位 會被丟錯值 .                 
# Modify.........: No.TQC-980195 09/08/27 By lilingyu  1."收貨單項次"開窗查詢后無資料,而直接輸入值是可以過的
# Modify.........: No.TQC-980291 09/08/31 By lilingyu 部分代碼丟失,參照32區補齊 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-990024 09/09/02 By Smapmin 修改取消確認時,更新工單狀態的邏輯
# Modify.........: No.MOD-980252 09/09/04 By mike 還原MOD-970214修改的地方,而MOD-970214原本的問題,應該改為像MOD-960186在sapmt540.4gl
# Mofify.........: No.FUN-980020 09/09/10 By douzh 集團架構調整 修改sub相關傳參
# Modify.........: No.FUN-980038 09/09/10 By chenmoyan rvu08的值由smy72代出
# Modify.........: No.FUN-980093 09/09/24 By TSD.sar2436  GP5.2 跨資料庫語法修改
# Modify.........: No.CHI-960033 09/08/03 By chenmoyan 加pmh22為條件者，再加pm23
# Modify.........: No.CHI-960022 09/10/15 By chenmoyan 預設單位一數量時，加上判斷，單位一數量為空或為1時，才預設
# Modify.........: No.CHI-960052 09/10/15 By chenmoyan 使用多單位，料件是單一單位或參考單位時，單位一的轉換率錯誤
# Modify.........: No.TQC-990073 09/10/15 By lilingyu 樣品收獲時,應不計單價金額
# Modify.........: No.MOD-990077 09/10/15 By Smapmin 入庫確認-->入待交換倉時,未產生批序號資料
# Modify.........: No.MOD-990023 09/10/15 By Smapmin 委外入庫確認時,針對最小發料套數的判斷,要再加上已入庫/驗退量
# Modify.........: No.MOD-990106 09/10/15 By Smapmin t720_minp()計算最小發料數時,也要考慮sfa100的誤差率
# Modify.........: No.TQC-9A0093 09/10/16 By lilingyu 查詢時,資料創建日未帶出值
# Modify.........: No.TQC-9A0092 09/10/16 By lilingyu 調整畫面欄位的錄入順序 
# Modify.........: NO.TQC-9A0168 09/10/28 By liuxqa order by 修改。
# Modify.........: No.FUN-9A0068 09/10/28 By douzh VMI测试结果反馈及相关调整
# Modify.........: No:MOD-9B0004 09/11/03 By Dido 抓取流程代碼條件有誤 
# Modify.........: No.FUN-9B0016 09/11/08 By Sunyanchun post no
# Modify.........: No:MOD-9B0109 09/11/17 By Dido 產生調撥單action僅顯示多角相關程式
# Modify.........: No:CHI-930021 09/11/17 By jan 1.when g_argv1 = '3' ==> 單頭的"收貨單號"及單身的"收貨項次"應該為非必要欄位 
# ...............................................2.AFTER FIELD "採購性質"，檢查段應加上可輸入"WB0-2"==> for icd only
# Modify.........: No.FUN-9B0106 09/11/19 By kevin 用s_dbstring(l_dbs CLIPPED) 判斷跨資料庫
# Modify.........: No.TQC-9B0161 09/11/20 By douzh 收貨單為非JIT收貨時，幣別匯率不可輸入
# Modify.........: No.TQC-9B0175 09/11/23 By sherry 重新過單
# MOdify.........: No:MOD-9B0155 09/11/24 By Smapmin 在抓取入庫單的rvbs_file資料時,要排除已作廢的入庫單
# Modify.........: No:TQC-9B0214 09/11/25 By Sunyanchun  s_defprice --> s_defprice_new
# Modify.........: No:TQC-9B0191 09/12/02 By jan 修改aict042/aict043/aict044 rvu01欄位開窗
# Modify.........: No:MOD-9C0016 09/12/03 By mike 原有的零售管控非成本仓拿掉 
# Modify.........: No:TQC-9B0191 09/12/03 By jan 修改aict042/aict043/aict044 異動單號開窗
# Modify.........: No:FUN-9B0157 09/12/07 By bnlent 零售業退貨採購性質可以是TAP,TRI
# Modify.........: No:TQC-9A0094 09/12/10 By lilingyu 新增時,開啟畫面欄位"付款方式 價格條件"
# Modify.........: No:FUN-9C0075 09/12/17 By Cockroach rvv10默认值改为4
# Modify.........: No:TQC-9C0155 09/12/18 By Carrier 多属性叁数打开时,后台运行程序会报错
# Modify.........: No:MOD-9C0297 09/12/21 by dxfwo  選擇3.價格折讓時，單身仍可輸入數量，還可扣帳，庫存還會減少
# Modify.........: No:MOD-9C0295 09/12/22 By Cockroach rvv10~rvv13僅在零售業態時使用
# Modify.........: No:TQC-9C0165 09/12/23 BY Carrier 录入完"收货单"后,产生的出单身资料rvv89(VMI否)此字段为NULL
# Modify.........: No:MOD-9C0321 09/12/21 By Smapmin 增加錯誤訊息的顯示
# Modify.........: No:TQC-9C0171 09/12/23 By shiwuying 自動取消審核部份
# Modify.........: No:MOD-9C0325 09/12/25 By chenls 判斷是否為製程工單
# Modify.........: No:MOD-9C0328 09/12/25 By chenls 程序邏輯調整
# Modify.........: No:FUN-9C0071 10/01/05 By huangrh 精簡程式
# Modify.........: No:MOD-A10113 10/01/20 By Smapmin 當sfa100=100時,表示不發料,最小發料套數等於生產數量
# Modify.........: No:FUN-A10123 10/01/20 By bnlent  Show the field 'rvupos'
# Modify.........: No:MOD-A20094 10/02/24 By Smapmin 增加數量大於0的條件
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A20037 10/03/15 By lilingyu 替代碼sfa26加上"7,8,Z"的條件
# Modify.........: No:TQC-A30041 10/03/16 By Cockroach add ORIU/ORIG
# Modify.........: No:CHI-9A0022 10/03/20 By chenmoyan給s_lotin加一個參數:歸屬單號
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26*
# Modify.........: No:FUN-8C0131 10/04/07 by dxfwo  過帳還原時的呆滯日期異動
# Modify.........: No:MOD-A40063 10/04/19 By Smapmin 更新ima91時,要以採購或計價單位為基準
# Modify.........: No:TQC-A40104 10/04/21 By Smapmin 修正MOD-940235
# Modify.........: No:FUN-A40054 10/04/22 By shiwuying 退貨方式為“2:原採購單換貨"時也可開立折讓單
# Modify.........: No:FUN-A10130 10/05/21 By jan 拆分'確認'段
# Modify.........: No.FUN-A50071 10/05/21 By lixia 程序增加POS單號字段 并增加相應管控
# Modify.........: No:CHI-A50012 10/05/26 By Summer 寫入rvu_file時,給予rvu101/rvu102/rvu100預設值
# Modify.........: No:CHI-A40068 10/05/26 By Summer 變更"串查button真正對應的程式
# Modify.........: No.FUN-A50054 10/06/01 By chenmoyan 增加服饰版二维功能 
# Modify.........: No.FUN-A50001 10/06/01 By Lilan Lilan EF整合寫作規範:For MESSAGE --> cl_msg
# Modify.........: No.TQC-A60046 10/06/22 By chenmoyan 外連的SQL有誤
# Modify.........: No.FUN-A60076 10/06/25 By huangtao 製造功能優化-平行製程(批量修改)
# Modify.........: No:FUN-A60035 10/07/06 By chenls 服飾狀態下單身顯示
# Modify.........: No.TQC-A60132 10/07/20 By chenmoyan 修改OUTER語句
# Modify.........: No.FUN-A50102 10/07/23 By vealxu 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:FUN-A60035 10/07/27 By chenls 服飾版二維功能mark
# Modify.........: No:MOD-A70201 10/07/29 By Smapmin 修正CHI-960052
# Modify.........: No:MOD-A70203 10/07/29 By Smapmin 修正FUN-970041
# Modify.........: No:MOD-A40166 10/07/30 By Smapmin 修改倉退時,倉庫一定要登打控管的時機點
# Modify.........: No:MOD-A70228 10/07/30 By Smapmin 變數打錯
# Modify.........: No:CHI-A70035 10/08/02 By Summer 加上rvvud02~rvvud06的開窗程式段
# Modify.........: No:FUN-A70120 10/08/03 BY alex 調整rowid為type_file.row_id
# Modify.........: No:FUN-A80026 10/08/11 By Carrier 入库单直接产生AP功能
# Modify.........: No:FUN-A80150 10/09/08 By sabrina 單身新增"計畫批號"(rvv919)欄位
# Modify.........: No:FUN-A20017 10/10/22 by jan 入庫單身可輸入聯產品料號
# Modify.........: No.FUN-AA0059 10/10/22 By chenying 料號開窗控管 
# Modify.........: No.FUN-A40022 10/10/25 By jan 當料件為批號控管,則批號必須輸入
# Modify.........: No.FUN-AA0059 10/10/28 By huangtao 修改料號AFTER FIELD的管控
# Modify.........: No.FUN-AA0049 10/10/29 by destiny  增加倉庫的權限控管
# Modify.........: No.TQC-AA0132 10/11/03 By lilingyu t720_z()和t720_t2()這兩個函數裡有判斷g_rva00,但程式並未給g_rva00賦初值
# Modify.........: No:MOD-AA0165 10/11/04 By Smapmin 金額應用計價數量來算
# Modify.........: No:MOD-AB0037 10/11/04 By Dido rvu15 增加檢核合理性
# Modify.........: No:MOD-A90083 10/11/05 By Smapmin 還原TQC-980195
# Modify.........: No:MOD-AB0051 10/11/10 By Smapmin 驗退/倉退理由碼應為5.退貨原因.
# Modify.........: No.FUN-AB0058 10/11/08 By yinhy 审核段增加倉庫權限控管
# Modify.........: No.FUN-AB0061 10/11/17 By shenyang 出貨單加基礎單價字段ogb37
# Modify.........: No.FUN-AB0066 10/11/18 By lilingyu 审核段增加倉庫權限控管
# Modify.........: No:CHI-AB0018 10/11/24 By Summer ima25(庫存單位)應改為ima44(採購單位)
# Modify.........: No.FUN-AB0096 10/11/25 By vealxu 因新增ogb50的not null欄位,所導致其他作業無法insert into資料的問題修正
# Modify.........: No.TQC-AB0412 10/12/04 By lixh1  修改欄位跳轉順序,忽略p_per順序,修正單身新增修改BUG
# Modify.........: No:TQC-AB0083 10/12/06 By Dido 發票編號有輸入時才檢核 
# Modify.........: No:MOD-AB0254 10/12/10 By Smapmin 使用多單位且料為單一單位時,入庫量的default未扣除已產生的入庫單
# Modify.........: No:TQC-AC0265 10/12/17 By houlia 人員欄位控管修改
# Modofy.........: No.TQC-AC0293 10/12/20 By vealxu sfp01的開窗/檢查要排除smy73='Y'的單據
# Modify.........: No.TQC-AC0257 10/12/22 By suncx s_defprice_new.4gl返回值新增兩個參數
# Modify.........: No.FUN-AC0055 10/12/22 By wangxin oga57,ogb50欄位預設值修正
# Modify.........: No:MOD-AB0205 10/12/24 By Summer 倉退單要可以打MISC料
# Modify.........: No:MOD-AC0355 10/12/28 By chenying apmt740時gen_ap action 不可視 
# Modify.........: No:MOD-AC0359 10/12/28 By chenying apmt722時gen_ap action 不可視
# Modify.........: No:MOD-AC0403 10/12/30 By zhangweib 開立折讓單設定為不需要預設打勾
#                                                      AFTER 退貨方式 if 退貨方式='2' then rvu10='N' ELSE rvu10='Y'
#                                                      after rvu10，if 退貨方式='2' then 不做訊息'apm-436'的判斷
# Modify.........: No:MOD-AC0414 10/12/30 By lixh1  1.稅率不可修改，值由稅別資料帶入; 2.增加顯示gec07字段  
# Modify.........: No:MOD-AC0024 11/01/06 By sabrina 未稅金額與採購單不同
# Modify.........: No:CHI-B10026 11/01/13 By Smapmin 無權限的時候沒有顯示訊息 
# Modify.........: No:CHI-AA0026 11/01/13 By Smapmin 稅率為空時,依供應商基本資料檔對應的稅別來抓稅率
# Modify.........: No:TQC-B10197 11/01/20 By lilingyu 調整錄入收貨單號rvu02後check的報錯訊息
# Modify.........: No:MOD-B10167 11/01/24 By Summer 當計價數量為0時,輸入未稅/含稅單價時,要依稅率推算出含稅/未稅單價 
# Modify.........: No:CHI-B10047 11/01/27 By Smapmin 修正錯誤訊息顯示方式,g_rva00沒有值
# Modify.........: No:FUN-A60009 11/02/18 By Lilan 新增EF(EasyFlow)整合功能
# Modify.........: No:MOD-B30033 11/03/07 By Summer 1.輸入異動數量或是計價數量時也要加上MOD-B10167同樣的邏輯
#                                                   2.MOD-B10167修改的邏輯僅限於倉退單
# Modify.........: No:FUN-A60034 11/03/08 By Mandy (1)EasyFlow整合功能外序參數的接收順序交換為：
#                                                     ARG_VAL(1)-->imm01調撥單號； ARG_VAL(2)-->Action ID ； ARG_VAL(3) -->借出管理flag
#                                                  (2)因aimt324 新增EasyFlow整合功能影響INSERT INTO imm_file
# Modify.........: No:FUN-A70104 11/03/08 By Mandy [EF簽核] aimt324影響程式簽核欄位default
# Modify.........: No:MOD-B30544 11/03/18 By suncx 交易資料頁簽錄入BUG修正
# Modify.........: No:MOD-B30556 11/03/17 By chenying 採購單入庫倉退時，收貨單數量有誤---->抓取rvv17時，需加上條件rvu116='2'
# Modify.........: No:FUN-B30170 11/04/11 By suncx 單身增加批序號明細頁簽
# Modify.........: No:MOD-B40048 11/04/14 By Smapmin 更改完單頭後要update單身資料前,應先判斷有沒有單身資料
# Modify.........: No:MOD-B40046 11/04/14 By Smapmin 委外採購入庫刪完單身後按確定,會出現無法抓取採購單身的訊息
# Modify.........: No:CHI-B40011 11/04/18 By Smapmin 多角採購入庫段加入考量自動拋轉的功能.
# Modify.........: No:FUN-B40031 11/04/19 By shiwuying 增加apmt723，查询联营入库单
# Modify.........: No:FUN-B50042 11/05/09 by jason 已傳POS否狀態調整
# Modify.........: No:TQC-B40100 11/05/09 By Summer 在查詢後按上下筆,右手邊會出現確認與取消
# Modify.........: No:MOD-B40258 11/05/09 By Summer 委外領料單產生,取單別號時異常,取單號傳入系統別應為asf 而非apm
# Modify.........: No:FUN-B40098 11/05/09 By shiwying 扣率代销入非成本仓
# Modify.........: No:FUN-AB0001 11/05/26 By Lilan EF(EasyFlow)簽核asfi510影響程式簽核欄位default
# Modify.........: No.FUN-B50065 11/06/08 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B40083 11/06/10 By guoch 添加廠牌和廠牌名稱
# Modify.........: No:TQC-B60065 11/06/16 By shiwuying 增加虛擬類型rvu27
# Modify.........: No:TQC-B60215 11/06/21 By wuxj 已審核資料才可轉報工單
# Modify.........: No.FUN-A70095 11/06/23 By lixh1 撈取報工單(shb_file)的所有處理作業,必須過濾是已確認的單據
# Modify.........: No.FUN-B30187 11/06/29 By jason ICD功能修改，增加母批、DATECODE欄位 
# Modify.........: No.FUN-B60150 11/07/06 By baogc apmt723單頭 虛擬類型rvu27隱藏1,成本代銷中若sma146=1入成本倉，sma146=2入非成本倉
# Modify.........: No.TQC-B70073 11/07/15 By guoch rvu116選2時rvu10賦值為Y
# Modify.........: No.MOD-B70171 11/07/18 By JoHung 委外採購取得工單的條件修改
# Modify.........: No:MOD-B60049 11/07/19 By JoHung 委外採購入庫rvu02增加控卡採購性質需為SUB
# Modify.........: No:MOD-B70231 11/07/25 By JoHung 倉退金額不可大於採購單金額
# Modify.........: NO.FUN-B70074 11/07/25 By xianghui 添加行業別表的新增於刪除(sfsi_file By lixh1)
# Modify.........: No.TQC-B80005 11/08/03 By jason s_icdpost函數傳入參數
# Modify.........: No:MOD-B60098 11/08/10 By Summer 修正TQC-AC0265改AFTER FIELD rvu07人員欄位的控卡 
# Modify.........: No.FUN-B50096 11/08/18 By lixh1 所有入庫程式應該要加入可以依料號設置"批號(倉儲批的批)是否為必要輸入欄位"的選項
# Modify.........: No:MOD-B80272 11/09/03 By johung icd行業時，程式代號應加上_icd
#                                                   修正r.c2不過
# Modify.........: No:MOD-B90019 11/09/06 By johung t720_rvv05計算rvv17時要扣掉l_okqty
# Modify.........: No:MOD-B90025 11/09/06 By johung 列印時漏傳參數(tm.a、tm.b)
# Modify.........: No.CHI-B90021 11/09/14 By lixh1  拿掉AFTER ROW 之後判斷批號不可為空的程式
# Modify.........: No.FUN-B80119 11/09/14 By fengrui  增加調用s_icdpost的p_plant參數
# Modify.........: No.FUN-B90012 11/09/19 By fengrui  添加cl_used函數返回值,修改g_argv3值為'TAP' 'ICD'的判斷條件
# Modify.........: NO:TQC-BA0051 11/10/11 By suncx 單身錄入BUG修正
# Modify.........: NO:MOD-BA0062 11/10/11 By suncx 單據審核後單身數據發生變動BUG修正
# Modify.........: No:CHI-B50027 11/10/13 By Smapmin 對應得到採購單時,依採購單上的含稅否決定未稅與含稅單價的輸入與否.
# Modify.........: NO:MOD-BA0177 11/10/24 By suncx 驗退單單別開窗帶出單據性質為E（驗退單）的資料
# Modify.........: No:TQC-B90236 11/11/08 By zhuhao 執行s_lotin_del程式段Mark，改為s_lot_del，傳入參數不變
#                                                   於_r()中，FOR迴圈s_del_rvbs程式段Mark，改為s_lot_del，傳入參數同上，但第三個參數傳""
#                                                   執行s_lotin程式段，改為s_mod_lot，於第6,7,8個參數傳入倉儲批，其餘傳入參數不變,
#                                                   rvu00='1'時，最後多傳入1，rvu00='2'or'3'時，最後多傳入-1
# Modify.........: No.FUN-BB0044 11/11/08 By baogc 倉退單時，顯示'折讓'按鈕
# Modify.........: No.FUN-B90104 11/11/10 By huangrh GP5.3服飾版本開發
# Modify.........: No:FUN-B90060 11/11/14 By jason icd行業加上"開立下階工單"的action
# Modify.........: No.FUN-BA0051 11/11/14 By jason 一批號多DATECODE功能 
# Modify.........: No.MOD-BB0126 11/11/23 By suncx 應該過濾調委外單據的錄入
# Modify.........: No.FUN-BB0001 11/11/30 By pauline 新增rvv22,INSERT/UPDATE rvb22時,同時INSERT/UPDATE rvv22
# Modify.........: No.TQC-BB0131 11/11/30 By pauline 當rvu27是空的或 = 1 時才select rvb22 INTO rvu15
# Modify.........: No:CHI-B90036 11/12/12 By Summer 調整為確認後才能產生領料單 
# Modify.........: NO:MOD-BA0048 11/12/12 By Summer 沒有對應採購單時,就不做apm-250的控卡 
# Modify.........: No:MOD-BB0318 11/12/12 By Summer 增加判斷g_rva00為null的情況改抓畫面上的幣別欄位 
# Modify.........: No.FUN-BC0104 12/01/04 By xujing QC料件判定,增加分批順序、判定結果編碼、結果說明、項次 4個欄位

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-BB0086 12/02/03 By tanxc 增加數量欄位小數取位
# Modify.........: No:FUN-C20006 12/02/03 By lixiang 服飾二維BUG修改(對多屬性料件的判斷等)
# Modify.........: No:FUN-C20002 12/02/03 By fanbj 券產品倉庫調整
# Modify.........: No:FUN-C20026 12/02/04 By Abby EF功能調整-客戶不以整張單身資料送簽問題
# Modify.........: No:FUN-C20047 12/02/09 By xujing
# Modify.........: No:TQC-C20117 12/02/10 By lixiang 服飾BUG修改
# Modify.........: No:TQC-BB0243 12/02/13 By Carrier VMI发/退单号开窗
# Modify.........: No.FUN-BA0013 12/02/14 By pauline 增加apmt732委外倉退維護作業1.退貨方式只能選"3.價格折讓"
#                                                                               2.只能選取採購性質"SUB.委外"的資料
# Modify.........: No.FUN-BC0109 12/02/17 By jason for ICD Datecode回寫多筆時即以","做分隔
# Modify.........: No.MOD-BB0271 12/02/20 By suncx 使用多單位時，更改單身異動數量後點確定，未改變金額欄位
# Modify.........: No:TQC-BB0259 12/02/20 By suncx Mark "ON CHANGE rvu21“ 的相關代碼
# Modify.........: No:TQC-C10072 12/02/20 By suncx 非訂單轉入的採購單，入庫做拋轉出貨單時增加報錯信息
# Modify.........: No.MOD-B90102 12/02/20 By Vampire icd欄位開窗,查詢與輸入的用法相反了
# Modify.........: No.MOD-B90145 12/02/20 By Vampire t720_exp_delivery()裡END INPUT後判斷INT_FLAG為TRUE時,CLOSE WINDOW 的畫面名稱錯誤
# Modify.........: No:MOD-BC0155 12/02/20 By Vampire apmt731 控卡apm1064僅能輸入委外收貨
# Modify.........: No:MOD-C10136 12/02/20 By Vampire 撥出量imn10不可由rvv17塞入，應重新由rvv17*rvv35_fac計算
# Modify.........: No:TQC-C20348 12/02/22 By xjll    服飾行業料號開窗的修改
# Modify.........: No.TQC-BB0108 12/02/22 by destiny 抛转出货单检查不正确
# Modify.........: No:MOD-BC0056 12/02/24 By Vampire 輸入批號後若有錯誤,應跳回倉庫欄位
# Modify.........: No:TQC-C20500 12/02/27 By xjll    錄入非多屬性料件，數量不可錄和刷新採購單退貨明細頁簽
# Modify.........: No:TQC-C20512 12/02/29 By lixiang 服飾零售業態下收貨項次的開窗及非多屬性倉退數量的控管
# Modify.........: No:TQC-C30005 12/03/01 By lixiang 服飾零售業態下非多屬性料件數量修改後更新數據庫相關字段的值
# Modify.........: No:TQC-C30048 12/03/02 By xujing  調整驗退單的控管條件
# Modify.........: No:MOD-C30025 12/03/06 By suncx 1、調整單頭退貨方式管控 2、調整單身單價和金額管控
# Modify.........: No:TQC-C30194 12/03/10 By lixiang  控管數量欄位數量不可小於零
# Modify.........: No:MOD-C30217 12/03/12 By xjll    服飾業bug 修改
# Modify.........: No:TQC-C30193 12/03/14 By jason for ICD:TKY工單完工數量應以委外收貨單最終站 收貨數量+不良數+報廢數 + 其它站 不良數+報廢數
# Modify.........: No:MOD-C30590 12/03/15 By zhuhao apm-259的判斷需增加判斷料件不為MISC時才控卡
# Modify.........: No:MOD-C30483 12/03/15 By linlin  倉庫不可空白
# Modify.........: No:FUN-C30140 12/03/16 By Mandy 圖示錯誤,N:未確認,1:已核准 未show"核"
# Modify.........: No:FUN-C30307 12/03/30 By bart 不管是否為TKY不良和報廢都要入完工數量
# Modify.........: No.MOD-C30902 12/04/01 By SunLM 單身的VMI(rvv89)勾選時的倉庫(rvv32)和儲位(rvv33)也禁止挑選
# Modify.........: No:MOD-C40018 12/04/03 By Summer 追MOD-A20017,驗退單在抓取rvv_file資料時,要排除作廢的單據
# Modify.........: No.FUN-C40016 12/04/05 By xianghui 單據作廢時不須清空QC料件判定新增的那幾個欄位,重新回寫已轉入庫量即可，取消作廢時檢查數量是否合理
# Modify.........: No:CHI-C30118 12/04/06 By Sakura 參考來源單號CHI-C30106,批序號維護修改
# Modify.........: No.TQC-C30225 12/04/11 By SunLM 若為運輸發票(gec05='T')時,未稅單價邏輯調整
# Modify.........: No.FUN-C30300 12/04/12 By bart  倉儲批開窗需顯示參考單位數量
# Modify.........: No:FUN-C30302 12/04/13 By bart 修改 s_icdin和s_icdout  回傳值
# Modify.........: No:MOD-C40173 12/04/25 By Elise 抓工單資料時需增加料件編號條件
# Modify.........: No:MOD-C40047 12/05/08 By Vampire 將抓t_azi04的部分全部統一在 t720_get_azi()的共用FUCTION
# Modify.........: No:MOD-BC0262 12/05/11 By Vampire apmt722 單頭有稅別資料時，應以單頭輸入的為主
# Modify.........: No:TQC-C50103 12/05/11 By zhuhao ICD中g_qryparam.where條件調整
# Modify.........: No:TQC-C50130 12/05/15 By zhuhao rvv05選擇性開啟
# Modify.........: No.TQC-BB0118 12/05/23 By Carrier apmt732时 隐藏gen_ap
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:TQC-C60028 12/06/04 By bart 只要是ICD行業 倉儲批開窗改用q_idc
# Modify.........: No:MOD-C30074 12/06/08 By Vampire 收貨無批序號管理，驗退單即可免輸入批序號，增加判斷sma90
# Modify.........: No:MOD-C40098 12/06/08 By Vampire 排除入庫時料件編號有做批序號時，仍需控卡數量
# Modify.........: No:TQC-C60085 12/06/11 By zhuhao 對廠商進行開窗后，判斷其返回值是否為空,AFTER INPUT后 INT_FLAG的順序調整
# Modify.........: No:TQC-C60096 12/06/12 By zhuhao 單身項次新增刪除時，同步更新批序號明細內容
# Modify.........: No:FUN-C50097 12/06/13 By SunLM  對非空字段進行判斷ogb50,51,52       
# Modify.........: No:MOD-C60054 12/06/28 By Vampire 倉退單控卡不可輸入無效廠商
# Modify.........: No:MOD-C50254 12/06/28 By Vampire 增加判斷新舊值不同才重新取價
# Modify.........: No:FUN-C60071 12/07/04 By suncx AFTER FIELD rvv25判斷,其值需為Y/N/P
# Modify.........: No:FUN-C30085 12/07/05 By nanbing CR改串GR
# Modify.........: No:FUN-C60100 12/07/10 By qiaozy  服飾流通：快捷鍵controlb的問題，切換的標記在BEFORE INPUT 賦值
# Modify.........: No:TQC-C70086 12/07/16 By suncx 自動帶出單身時，判斷如果樣品(rvv25='Y')將rvv38/rvv38t/rvv39/rvv39t置為0
# Modify.........: No:FUN-C70014 12/07/16 By suncx 新增sfs014
# Modify.........: No:TQC-C70207 12/08/01 By zhuhao BUG修改
# Modify.........: No:MOD-C80024 12/08/08 By Polly 調整apt110單身串查至入庫單無資料產生問題
# Modify.........: No:FUN-C80030 12/08/10 By xujing 添加批序號依參數sma95隱藏
# Modify.........: No:FUN-C70093 12/08/16 By minpp 如果已经存在于分摊单据当中，则不可以取消审核
# Modify.........: No.FUN-C80045 12/08/17 By nanbing 檢查POS單別，不允許在ERP中錄入
# Modify.........: No.CHI-C80009 12/08/22 By Sakura ICD單身修改時需顯示"刻號/BIN查詢(aic_s_icdqry)","刻號/BIN入庫(aic_s_icdin)"
# Modify.........: No.MOD-C10116 12/09/17 By jt_chen 修正FUNCTION t720_exp_oga/FUNCTION t720_exp_ogb,未給預設值.-391的異常
# Modify.........: No.MOD-C10157 12/09/17 By jt_chen 修正代採逆拋之中斷點的入庫單無法取消確認
# Modify.........: No:MOD-C80178 12/09/20 By jt_chen 新增調撥單單頭時,未清空預設值
# Modify.........: No:MOD-C90169 12/09/24 By wujie  修改sapmt720的传入参数，使其能够被串查时利用参数正确打开查询功能
# Modify.........: No:MOD-C80049 12/09/27 By Vampire 收貨單自動入庫的則不直接CALL t720sub_ecm串報工單，整個Transaction結束之後再串
# Modify.........: No:MOD-CA0041 12/10/08 By jt_chen 修正自動產生入庫單FUNCTION t720_g_b()中，g_sql給予NULL時，多了一個逗號「,」
# Modify.........: No:MOD-CA0071 12/10/11 By Summer 手動輸入入庫單寫入rvu111是MOD-B30544修改導致,增加判斷JIT收貨才須給值
# Modify.........: No:CHI-BB0021 12/10/12 By Vampire apmt740 產生調撥單確認碼為N未確認
# Modify.........: No:MOD-CA0007 12/10/15 By Vampire 用原幣的角度取位t_azi04
# Modify.........: No:FUN-C90049 12/10/19 By Lori 預設成本倉與非成本倉改從s_get_defstore取
# Modify.........: No:FUN-C90050 12/10/24 By Lori 預設單別/預設POS上傳單別改以s_get_defslip取得
# Modify.........: No.FUN-CB0014 12/11/09 By fengrui 增加資料清單
# Modify.........: No:MOD-CB0148 12/11/23 By jt_chen 增加控卡單價不可小於零(mfg5034)
# Modify.........: No.CHI-C80041 12/11/27 By bart 取消單頭資料控制
# Modify.........: No.MOD-CC0068 12/12/14 By jt_chen MOD-C30483的調整是針對入庫單,修正倉退且退貨方式為3.價格折讓不控卡倉庫不可空白
# Modify.........: No.FUN-CB0087 12/12/07 By xianghui 倉庫單據理由碼改善,fengrui sfs_file, qiull imn_file
# Modify.........: No:MOD-CC0047 13/01/11 By Elise 入庫單且為重工工單，不控卡axm-396
# Modify.........: No.FUN-CC0013 13/01/11 By Lori aqci106移除性質3.驗退/重工(qcl05=3)選項
# Modify.........: No.MOD-D10224 13/01/25 By jt_chen MISC不影響庫存,調整排除MISC開頭的料
# Modify.........: No:MOD-D10192 13/01/25 By SunLM 采购单是否已经结案,如已结案则不允许录入仓退单
# Modify.........: No.TQC-D10084 13/01/28 By xujing  資料清單頁簽不可點擊單身按鈕
# Modify.........: No:MOD-D10089 13/01/29 By Elise 產生領料單單身預設替代率sfs28應給1
# MOdify.........: No.TQC-D10103 13/01/30 By xianghui 處理倉庫單據理由碼改善的一些問題
# Modify.........: No:FUN-D20025 13/02/19 By chenying 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No.CHI-CC0014 13/02/25 By huangtao 增加對設限倉庫的控管
# Modify.........: No.TQC-D20050 13/02/26 By xianghui 理由碼調整
# Modify.........: No.FUN-D20078 13/02/26 By xujing 倉退單過帳寫tlf時,區分一般倉退和委外倉退,同時修正成本計算及相關查詢報表邏輯
# Modify.........: No:FUN-BC0062 13/02/28 By lixh1 當成本計算方式ccz28選擇'6'，過帳還原時控制不可過帳還原
# Modify.........: No:MOD-BA0169 13/03/07 By Elise 原先程式寫法就沒有預設上筆的功能,且該支作業也沒有預上上筆的必要,但因為ACTION顯示在畫面上所以會造成誤解
# Modify.........: No:MOD-CC0212 13/03/07 By Elise 取消確認段,如果為價格折讓,不做s_icdpost檢核和異動
# Modify.........: No.MOD-D30033 13/03/07 By Elise (1) 匯率是否重新抓取需用oea18決定
#                                                  (2) 拋轉出貨單Action排除作廢的出貨單
# Modify.........: No.MOD-D30010 13/03/08 By Elise 委外作業需控卡單頭收貨單必須輸入
# Modify.........: No.MOD-D20171 13/03/08 By Elise 依照單頭含稅否來控制單身金額欄位控卡金額欄位。
# Modify.........: No.TQC-D30023 13/03/08 By Elise 修正 AFTER FIELD rvu15於 TQC-BB0131的給值條件
# Modify.........: No.MOD-D30080 13/03/08 By Elise 條件增加判斷新值不為空
# Modify.........: No.MOD-D30066 13/03/11 By Vampire 在 _show() 抓完單頭資料後 會在呼叫 _rvu113() 會依照系統設定帶出 rvu114，無法帶出資料庫實際的資料
# Modify.........: No.MOD-D30083 13/03/11 By Elise (1) 有判斷apmt720處增加判斷aict042,apmt721/aict043,apmt722/aict044
#                                                  (2) mfg1401若倉儲批都為空時不需彈出詢問訊息
# Modify.........: No.MOD-D30089 13/03/11 By Vampire 未考慮到收貨單單頭未輸入採購單號，需增加此判斷
# Modify.........: No:MOD-CB0222 13/03/12 By jt_chen JIT收貨的入庫單在取消確認時沒有更新imgg
# Modify.........: No:MOD-CC0055 13/03/12 By jt_chen 價格折讓與數量無關,調整價格折讓時,多單位數量也不能輸入
# Modify.........: No:MOD-D30109 13/03/13 By Vampire 價格折讓多單位時,數量預設為0
# Modify.........: No:FUN-D30024 13/03/13 By lixh1 負庫存依據imd23判斷
# Modify.........: No.MOD-D30122 13/03/14 By Elise 折讓時不控卡aim-034
# Modify.........: No:MOD-CB0229 13/03/14 By jt_chen 調整判斷退貨方式為3.價格折讓時不需CALL s_lotin
# Modify.........: No:MOD-D20003 13/02/01 By Vampire 倉退/銷退不控卡多角單據
# Modify.........: No.MOD-D20134 13/03/15 By Vampire 多角單據走一般銷退/倉退後,屬於一般單據應可產生
# Modify.........: No.DEV-D30026 13/03/20 By Nina GP5.3 追版:dEV-CB0003為GP5.25 的單號
# Modify.........: No.FUN-D20022 13/03/19 By jt_chen (1)季會決議：未確認數量納入考量，調整為把已產生入庫單的數量都視為已入庫量
#                                                    (2)入庫單輸入收貨項次時,增加檢核該項次是否有未確認單據
# Modify.........: No:MOD-D30166 13/03/25 By ck2yuan 修正 rvv_curs 的sql for aict042
# Modify.........: No:FUN-D20059 13/03/26 By chenjing 統一確認和取消確認時確認人員和確認日期的寫法
# Modify.........: No.MOD-D30016 13/03/28 By Vampire (1) 統一調整計算金額後再重取位
#                                                    (2) 將ON ROW CHANGE 重複 CALL t720sub_rvv39() t720sub_rvv38() 統一在 t720_b_move_back() 處理
# Modify.........: No:DEV-D30045 13/04/01 By TSD.JIE 
#                  1.條碼產生時機點相關程式-增加"條碼查詢"
#                  2.條碼產生時機點相關程式-增加"條碼列印"
#                  3.條碼產生時機點相關程式-增加"條碼產生"
#                  3.調整確認自動產生barcode
#                  4.調整取消確認自動作廢barcode
# Modify.........: No.TQC-D40003 13/04/01 By Elise 修正FUN-D20025
# Modify.........: No.DEV-D30059 13/04/01 By Nina 批序號相關程式,當料件使用條碼時(ima930 = 'Y'),輸入資料時,
#                                                 不要自動開批序號的Key In畫面(s_mod_lot)
# Modify.........: No.MOD-D40025 13/04/03 By Vampire 調整為不自動開窗，但可以維護資料。
# Modify.........: No.MOD-D40048 13/04/09 By Vampire t720_set_entry_b() 當料號為聯產品或MISC時，才可以開放 rvv31 修改
# Modify.........: No.DEV-D40013 13/04/12 By Nina 過單用
# Modify.........: No.CHI-CC0028 13/04/12 By bart 過帳還原需控管"有無此倉儲的過賬權限"
# Modify.........: No.DEV-D40015 13/04/18 By Nina 更改條碼取消作廢時機點
# Modify.........: No:TQC-D40025 13/04/22 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:MOD-D40137 13/04/22 By Vampire 作廢應該參考收貨單也要詢問 aic-112
# Modify.........: NO:FUN-D50103 13/05/30 By zhuhao 单别录入时开窗需和单据形态挂钩。
# Modify.........: No:MOD-D60076 13/06/09 By SunLM 該項次委外倉退金額大於委外采購單金額，是否繼續
# Modify.........: No:FUN-D60130 13/06/28 By lixh1 委外倉退改善:既能退數量也能退金額,委外工單結案后也能進行委外倉退
# Modify.........: No:TQC-D40092 13/07/17 By yangtt 录入的方式维护apmt720的资料时，如果rvb39=Y,需做QC检查
# Modify.........: NO.TQC-D80008 13/08/08 By lixh1 修改多角倉退邏輯
# Modify.........: NO.CHI-D60028 13/08/12 By SunLM 调整QC逻辑
# Modify.........: NO.MOD-D80123 13/08/12 By SunLM apmt722项次2料号不能录入
# Modify.........: NO.MOD-D90146 13/09/26 By SunLM 增加qbe條件查詢存儲按鈕           


DATABASE ds

GLOBALS "../../config/top.global"
GLOBALS "../4gl/sapmt720.global"
GLOBALS
   DEFINE g_rowid     LIKE type_file.row_id    #chr18 FUN-A70120
END GLOBALS       #No.FUN-960007
 


DEFINE g_ima918  LIKE ima_file.ima918  #No.FUN-810036
DEFINE g_ima921  LIKE ima_file.ima921  #No.FUN-810036
DEFINE g_ima930  LIKE ima_file.ima930  #DEV-D30059 add
DEFINE l_r       LIKE type_file.chr1   #No.FUN-860045
DEFINE g_rva00             LIKE rva_file.rva00  #NO.FUN-940083
DEFINE g_tax               LIKE gec_file.gec04   #NO.FUN-960130  NO.FUN-9B0016
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
DEFINE g_rec_b1           LIKE type_file.num5,   #單身二筆數 ##FUN-B30170
       l_ac1              LIKE type_file.num5    #目前處理的ARRAY CNT  #FUN-B30170
#FUN-B30170 add -end---------------------------
DEFINE g_rvu00            LIKE rvu_file.rvu00    #FUN-B40031
DEFINE g_rvv35_t          LIKE rvv_file.rvv35    #No.FUN-BB0086
DEFINE g_rvv80_t          LIKE rvv_file.rvv80    #No.FUN-BB0086
DEFINE g_rvv83_t          LIKE rvv_file.rvv83    #No.FUN-BB0086
DEFINE g_rvv86_t          LIKE rvv_file.rvv86    #No.FUN-BB0086
DEFINE g_rvv38t_t         LIKE rvv_file.rvv38t   #TQC-D80008 add

FUNCTION t720(p_argv1,p_argv2,p_argv3,p_argv4,p_argv5)   #No:FUN-630010  #FUN-A60009 add:p_argv5
   DEFINE p_argv1   LIKE rvu_file.rvu00,     #異動類別  when g_argv1='6' => mBarcode,背景處理自動確認,傳入庫單號
          p_argv2   LIKE rvu_file.rvu02,     #when g_argv1='5':驗收單號 ; when g_argv1='6':入庫單號
          p_argv3   LIKE rvu_file.rvu08,     #採購性質
          p_argv4   STRING,                  #No.FUN-630010 執行功能
          p_argv5   LIKE rvu_file.rvu01      #異動單號 #FUN-A60009 add
   DEFINE cb        ui.ComboBox              #FUN-B40031

   WHENEVER ERROR CONTINUE
 
   SELECT * INTO g_qcz.* FROM qcz_file WHERE qcz00 ='0'
 
   LET g_argv1=p_argv1
   LET g_argv2=p_argv2
   LET g_argv3=p_argv3
   LET g_argv4=p_argv4
   LET g_argv5=p_argv5                     #FUN-A60009 add
  #FUN-B40031 Begin---
   IF  g_argv1='A' THEN
      LET g_rvu00='A'
      LET g_argv1='1'
   ELSE
      LET g_rvu00=g_argv1
   END IF
  #FUN-B40031 End-----

  #------------MOD-C80024------------(S)
   IF NOT cl_null(g_argv5) THEN
      SELECT rvu02 INTO g_argv2
        FROM rvu_file
       WHERE rvu01 = g_argv5
   END IF
  #------------MOD-C80024------------(E)

  #FUN-A60009 str ---
   IF fgl_getenv('EASYFLOW') = "1" THEN    #判斷是否為簽核模式
      LET g_argv5 = aws_efapp_wsk(1)       #取得單號

      SELECT rvu02 INTO g_argv2
        FROM rvu_file
       WHERE rvu01 = g_argv5
   END IF
  #FUN-A60009 end ---

 
   LET g_forupd_sql = "SELECT * FROM rvu_file WHERE rvu01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t720_cl CURSOR FROM g_forupd_sql
 
   LET p_row = 3 LET p_col = 2

#TQC-AA0132 --begin--
   SELECT rva00 INTO g_rva00 FROM rva_file
    WHERE rva01 = g_argv2
#TQC-AA0132 --end-- 
 
   IF g_argv1 MATCHES '[56Z]' THEN                                  #No.FUN-940083
      LET g_rvu.rvu00='1'
      LET g_rvu.rvu08=g_argv3
      LET g_icq=''
      CALL t720_q()
      IF g_argv1 = 'Z' THEN
         CALL t720_z()
      ELSE
        #CALL t720sub_y(g_rvu.rvu01,g_argv1,g_argv2,g_argv3,g_chr,FALSE,'Y') #FUN-A10130   #FUN-A60009 mark
        #FUN-A60009 add str -----------------------
         CALL t720sub_y_chk(g_rvu.rvu01,g_argv1,g_argv2,g_argv3,g_chr,'Y')
         IF g_success = "Y" THEN
            #CALL t720sub_y_upd(g_rvu.rvu01,g_argv1,g_argv2,g_argv3,g_chr,FALSE,'Y')    #MOD-C80049 mark
            CALL t720sub_y_upd(g_rvu.rvu01,g_argv1,g_argv2,g_argv3,g_chr,FALSE,'Y','Y') #MOD-C80049 add  
         END IF
        #FUN-A60009 add end -----------------------

         CALL t720_refresh() RETURNING g_rvu.*  #FUN-A10130
         CALL t720_show()   #FUN-A10130
      END IF
   ELSE
      IF g_bgjob='N' OR cl_null(g_bgjob) THEN               #FUN-A50001 add
        CASE
          WHEN (g_argv1='1' AND g_argv3 !='SUB' AND g_argv3 !='TAP')
                OR (g_argv1=' ' AND g_argv3 !='TAP')
               OPEN WINDOW t720_w WITH FORM "apm/42f/apmt720"
                ATTRIBUTE (STYLE = g_win_style CLIPPED) 
          WHEN g_argv1='2' AND g_argv3 !='SUB' AND g_argv3 !='TAP'
               OPEN WINDOW t720_w WITH FORM "apm/42f/apmt721"
                ATTRIBUTE (STYLE = g_win_style CLIPPED) 
          WHEN g_argv1='3' AND g_argv3 !='SUB' AND g_argv3 !='TAP'
               OPEN WINDOW t720_w WITH FORM "apm/42f/apmt722"
                ATTRIBUTE (STYLE = g_win_style CLIPPED) 
          WHEN g_argv1='1' AND g_argv3='SUB'
               OPEN WINDOW t720_w WITH FORM "apm/42f/apmt730"
                ATTRIBUTE (STYLE = g_win_style CLIPPED) 
          WHEN g_argv1='2' AND g_argv3='SUB'
               OPEN WINDOW t720_w WITH FORM "apm/42f/apmt731"
                ATTRIBUTE (STYLE = g_win_style CLIPPED) 
          WHEN g_argv1='3' AND g_argv3='SUB'
               OPEN WINDOW t720_w WITH FORM "apm/42f/apmt732"
                ATTRIBUTE (STYLE = g_win_style CLIPPED) 
          WHEN (g_argv1='1' AND g_argv3='TAP') OR (g_argv1=' ' AND g_argv3='TAP')
               OPEN WINDOW t720_w WITH FORM "apm/42f/apmt740"
                ATTRIBUTE (STYLE = g_win_style CLIPPED) 
          WHEN (g_argv1='2' AND g_argv3='TAP')
               OPEN WINDOW t720_w WITH FORM "apm/42f/apmt741"
                ATTRIBUTE (STYLE = g_win_style CLIPPED) 
          WHEN (g_argv1='3' AND g_argv3='TAP')
               OPEN WINDOW t720_w WITH FORM "apm/42f/apmt742"
                ATTRIBUTE (STYLE = g_win_style CLIPPED) 
        END CASE
      END IF                                    #FUN-A50001 add
 
      #初始化界面的樣式(沒有任何默認屬性組)
      LET lg_smy62 = ''
      LET lg_group = ''
      CALL t720_refresh_detail()
 
      IF g_bgjob='N' OR cl_null(g_bgjob) THEN   #FUN-A50001 add 
        CALL cl_ui_init()
        
        #CHI-A40068 add --start--
        CASE
        #apmt720
           WHEN (g_argv1='1' AND g_argv3 !='SUB' AND g_argv3 !='TAP')
                 OR (g_argv1=' ' AND g_argv3 !='TAP')
              CASE g_sma.sma124
                 WHEN 'std'
                    CALL cl_reset_qry_btn("rvv36,rvu02","apmt540,apmt110")
                 WHEN 'icd' 
                    CALL cl_reset_qry_btn("rvv36,rvu02","apmt540_icd,apmt110_icd")
                 WHEN 'slk'                                                     
                    CALL cl_reset_qry_btn("rvv36,rvu02","apmt540_slk,apmt110_slk") 
              END CASE
        #apmt721
           WHEN g_argv1='2' AND g_argv3 !='SUB' AND g_argv3 !='TAP'
              CASE g_sma.sma124
                 WHEN 'std'
                    CALL cl_reset_qry_btn("rvv36,rvu02","apmt540,apmt110")
                 WHEN 'icd' 
                    CALL cl_reset_qry_btn("rvv36,rvu02","apmt540_icd,apmt110_icd")
                 WHEN 'slk'
                    CALL cl_reset_qry_btn("rvv36,rvu02","apmt540_slk,apmt110")
              END CASE
        #apmt722
           WHEN g_argv1='3' AND g_argv3 !='SUB' AND g_argv3 !='TAP'
              CASE g_sma.sma124
                 WHEN 'std'
                    CALL cl_reset_qry_btn("rvv36,rvu02","apmt540,apmt110")
                 WHEN 'icd' 
                    CALL cl_reset_qry_btn("rvv36,rvu02","apmt540_icd,apmt110_icd")
                 WHEN 'slk'                                                       #huangrh ??
                    CALL cl_reset_qry_btn("rvv36,rvu02","apmt540_slk,apmt110")    #huangrh ??
              END CASE
           WHEN g_argv1='1' AND g_argv3='SUB' #apmt730
           WHEN g_argv1='2' AND g_argv3='SUB' #apmt731
           WHEN g_argv1='3' AND g_argv3='SUB' #apmt732
        #apmt740
           WHEN (g_argv1='1' AND g_argv3='TAP') OR (g_argv1=' ' AND g_argv3='TAP')
              CASE g_sma.sma124
                 WHEN 'std'
                    CALL cl_reset_qry_btn("rvv36,rvu02","apmt540,apmt300")
                 WHEN 'icd' 
                    CALL cl_reset_qry_btn("rvv36,rvu02","apmt540_icd,apmt300_icd")
                 WHEN 'slk'
                    CALL cl_reset_qry_btn("rvv36,rvu02","apmt540_slk,apmt300")
              END CASE
           WHEN (g_argv1='2' AND g_argv3='TAP')  #apmt741
        #apmt742
           WHEN (g_argv1='3' AND g_argv3='TAP')
              CASE g_sma.sma124
                 WHEN 'std'
                    CALL cl_reset_qry_btn("rvv36,rvu02","apmt540,apmt300")
                 WHEN 'icd' 
                    CALL cl_reset_qry_btn("rvv36,rvu02","apmt540_icd,apmt300_icd")
                 WHEN 'slk'
                    CALL cl_reset_qry_btn("rvv36,rvu02","apmt540_slk,apmt300")
              END CASE
        END CASE
        #CHI-A40068 add --end--
      END IF                                                    #FUN-A50001 add
      #FUN-BC0104---add---str
      IF g_bgjob='N' OR cl_null(g_bgjob) THEN
        IF (g_argv1='3' AND g_argv3 !='SUB' AND g_argv3 !='TAP')
           OR (g_argv1='3' AND g_argv3='SUB')
           OR (g_argv1='3' AND g_argv3='TAP') THEN
           CALL cl_set_comp_visible('rvv45,rvv46,qcl02,rvv47',FALSE)
           CALL cl_set_act_visible("qc_determine_storage",FALSE)   #FUN-C20047
        END IF
      END IF
      CALL t720_set_comp_visible()
      #FUN-BC0104---add---end
      IF g_bgjob='N' OR cl_null(g_bgjob) THEN  #FUN-A60009 add
        #FUN-B40031 Begin---
        #CALL cl_set_comp_visible("rvu25",g_aza.aza88 = 'Y')  #No.FUN-A50071
        #CALL cl_set_comp_visible("rvu25",g_rvu00='A')        #FUN-B40098 Mark
         CALL cl_set_comp_visible("rvu25",g_rvu00='A')        #TQC-B60065
         CALL cl_set_comp_visible("rvu27",g_rvu00='A')        #TQC-B60065
         LET cb = ui.ComboBox.forName("rvu21")
         IF g_rvu00='A' THEN
           #TQC-B60065 Begin---
           #CALL cb.removeItem('1')
           #CALL cb.removeItem('2')
           #CALL cb.removeItem('3')
           #TQC-B60065 End-----
         ELSE
            CALL cb.removeItem('4')
         END IF

#FUN-B60150 ADD - BEGIN -------------------------
         LET cb = ui.ComboBox.forName("rvu27")
         IF g_rvu00='A' THEN
            CALL cb.removeItem('1')
         END IF
#FUN-B60150 ADD -  END  -------------------------

        #FUN-B40031 End-----
         CALL cl_set_comp_visible("rvv919",g_sma.sma1421 = 'Y')    #FUN-A80150 add

         IF g_aza.aza115 ='Y' THEN                    #TQC-D10103
            CALL cl_set_comp_required('rvv26',TRUE)   #TQC-D10103
         END IF                                       #TQC-D10103
    
#        IF g_prog != 'apmt730' THEN        #MOD-B80272 mark
         IF g_prog[1,7] != 'apmt730' THEN   #MOD-B80272
            CALL cl_set_act_visible("gen_mat_wtdw",FALSE)                                                                              
            CALL cl_set_act_visible("maint_mat_wtdw",FALSE)                                                                            
            CALL cl_set_comp_visible("rvu16",FALSE)                                                                                    
         END IF  
         #MOD-AC0355-----add------str----------------
         IF (g_argv1='1' AND g_argv3='TAP') OR (g_argv1=' ' AND g_argv3='TAP') THEN
            CALL cl_set_act_visible("gen_ap",FALSE)
         END IF
         #MOD-AC0355-----add------end----------------       
         #MOD-AC0359-----add------------str------------------   
         IF g_argv1='3' AND g_argv3 !='SUB' AND g_argv3 !='TAP' THEN 
            CALL cl_set_act_visible("gen_ap",FALSE) 
         END IF
         #MOD-AC0359-----add------------end-----------------                                                                                                         

         IF g_aza.aza71 MATCHES '[Yy]' THEN
            CALL aws_gpmcli_toolbar()
            CALL cl_set_act_visible("gpm_show,gpm_query", TRUE)
         ELSE
            CALL cl_set_act_visible("gpm_show,gpm_query",FALSE)
         END IF
         IF g_argv1 = '3' THEN                       #CHI-930021
            IF g_argv3 != 'SUB' THEN #MOD-D30010 add
               CALL cl_set_comp_required("rvu02,rvv05",FALSE) #CHI-930021
           #MOD-D30010 add start -----
            ELSE                     
               CALL cl_set_comp_required("rvu02,rvv05",TRUE)
            END IF
           #MOD-D30010 add end   -----
         END IF                                      #CHI-930021

         IF g_azw.azw04 = '2' THEN            
            CALL cl_set_comp_visible("rvu21,rvu22,rvu22_desc,rvu23,rvu23_desc,rvu24,rvucond,                                         rvuconu,rvuconu_desc,rvu900,rvuplant,rvuplant_desc,rvupos,rvucont",TRUE) #FUN-A60009 mod:拿掉,rvumksg
            CALL cl_set_comp_visible("gem02a,rvv930",FALSE)
            CALL cl_set_comp_visible("rvv10,rvv11,rvv12,rvv13",TRUE)        #MOD-9C0295 ADD
         ELSE
            CALL cl_set_comp_visible("rvu21,rvu22,rvu22_desc,rvu23,rvu23_desc,rvu24,rvucond,                                       rvuconu,rvuconu_desc,rvu900,rvuplant,rvuplant_desc,rvupos,rvucont",FALSE) #FUN-A60009 mod:拿掉,rvumksg    
            CALL cl_set_comp_visible("gem02a,rvv930",TRUE)
            CALL cl_set_comp_visible("rvv10,rvv11,rvv12,rvv13",FALSE)       #MOD-9C0295 ADD
         END IF 
         CALL cl_set_comp_visible("rvupos",FALSE)  #No:FUN-B50042
         CALL cl_set_comp_visible("rvu23,rvu23_desc",FALSE) #bnl                                                                                   
         IF g_argv3 = 'TAP' THEN                                                                                                      
            CALL cl_set_act_visible("gen_transfer_note",TRUE)                                                                                 
         ELSE
            CALL cl_set_act_visible("gen_transfer_note",FALSE)                                                                                 
         END IF                                                                                                                           
         CALL cl_set_comp_entry("rvu12",FALSE)       #MOD-AC0414
      END IF                                         #FUN-A60009 add
#FUN-B90060 --START--
#FUN-B90060 --END--
      #str-----add by guanyao160706
      #IF g_argv3 != 'SUB' THEN
      #   CALL cl_set_act_visible('fa_issue',FALSE)
      #END IF 
      #end-----add by guanyao160706

      #FUN-C80030---add---str---
      CALL cl_set_act_visible('modi_lot,qry_lot',g_sma.sma95 = 'Y')
      CALL cl_set_comp_visible('Page2',g_sma.sma95 = 'Y')
      #FUN-C80030---add---str---

      #DEV-D30045--add--begin
      IF g_prog <> 'apmt720' OR g_aza.aza131 = 'N' THEN
         CALL cl_set_act_visible("barcode_gen,barcode_query,barcode_output", FALSE)
      END IF
      #DEV-D30045--add--end

      CALL t720_def_form()
 
      LET g_rvu.rvu00=g_argv1
      LET g_rvu.rvu08=g_argv3
      LET g_icq=''
      DISPLAY BY NAME g_rvu.rvu00,g_rvu.rvu08
      CASE
         WHEN g_rvu.rvu00='1'
              CALL cl_getmsg('apm-243',g_lang) RETURNING g_buf
         WHEN g_rvu.rvu00='2'
              CALL cl_getmsg('apm-244',g_lang) RETURNING g_buf
         WHEN g_rvu.rvu00='3'
              CALL cl_getmsg('apm-245',g_lang) RETURNING g_buf
      END CASE
      DISPLAY g_buf TO t_1
      CALL s_prtype(g_rvu.rvu08) RETURNING l_str
 
      CALL aws_efapp_toolbar()    #建立簽核模式時的 toolbar icon  #FUN-A60009 add

      IF NOT cl_null(g_argv5) THEN     #表由驗收單call  #MOD-C90169   有传入单号作为参数就该查询出来
         CASE g_argv4
            WHEN "query"
               LET g_action_choice = "query"
               IF cl_chk_act_auth() THEN
                  CALL t720_q()
               END IF
            WHEN "insert"
               LET g_action_choice = "insert"
               IF cl_chk_act_auth() THEN
                  CALL t720_a()
               END IF
           #FUN-A60009 add str ---
            WHEN "efconfirm"
               LET g_action_choice = "efconfirm"
               CALL t720_q()
               CALL t720sub_y_chk(g_argv5,g_argv1,g_argv2,g_argv3,g_chr,'N')
               IF g_success = "Y" THEN
                  #CALL t720sub_y_upd(g_argv5,g_argv1,g_argv2,g_argv3,g_chr,FALSE,'N')    #MOD-C80049 mark
                  CALL t720sub_y_upd(g_argv5,g_argv1,g_argv2,g_argv3,g_chr,FALSE,'N','Y') #MOD-C80049 add
               END IF
               #CALL cl_used(g_prog,g_time,2)   #MOD-B80272     #FUN-B90012--mark-
               CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90012--add--
               EXIT PROGRAM
           #FUN-A60009 add end ---
            OTHERWISE
               LET g_rvu.rvu02=g_argv2
               DISPLAY BY NAME g_rvu.rvu02
               CALL t720_q()
         END CASE
      END IF

     #FUN-A60009 add str ---
     #傳入簽核模式時不應執行的 action 清單
     CALL aws_efapp_flowaction("insert, modify, delete, detail, query, locale, void,undo_void, confirm, undo_confirm, carry, undo_carry, carry_delivery, gen_ap, transfer_to_report, price_change, gen_transfer_note, gen_mat_wtdw, maint_mat_wtdw, recall, allowance, easyflow_approval,barcode_gen,barcode_query,barcode_output") #FUN-D20025 add undo_void #DEV-D30045 add barcode_gen,barcode_query,barcode_output
         RETURNING g_laststage
     #FUN-A60009 add end ---
 
     #TQC-B90201--begin
    #IF g_prog='apmt721' OR g_prog='apmt731' OR g_prog = 'apmt732' THEN    #No.TQC-BB0118    #MOD-D30083 mark
     IF g_prog='apmt721' OR g_prog='aict043' OR g_prog='apmt731' OR g_prog = 'apmt732' THEN  #MOD-D30083 
        CALL cl_set_act_visible("gen_ap",FALSE)
     END IF
     #TQC-B90201--end

      CALL t720_menu()
      CLOSE WINDOW t720_w                    #結束畫面
   END IF
 
END FUNCTION
 
FUNCTION t720_cs()
DEFINE lc_qbe_sn LIKE gbm_file.gbm01    #No.FUN-580031  HCN
DEFINE l_pmm04   LIKE pmm_file.pmm04    #No.MOD-4B0275
DEFINE l_argv2   LIKE rvu_file.rvu02    #WHEN "efconfirm"時,紀錄p_argv2內的值  #FUN-A60009 add
DEFINE l_flag    LIKE type_file.chr1    #FUN-CB0087
DEFINE l_where   STRING                 #FUN-CB0087


  #FUN-A60009 add str --------
   IF fgl_getenv('EASYFLOW') = "1" THEN    #判斷是否為簽核模式
      LET l_argv2 = g_argv2                #紀錄g_argv2的原值(rvu_file.rvu02)
      LET g_argv2 = g_argv5                #異動g_argv2的值為KEY值
   END IF
  #FUN-A60009 add end -------- 

   IF g_argv1 MATCHES '[56Z]' THEN                                      #No.FUN-940083
      IF g_argv3<>' ' THEN
         LET g_sql = "SELECT  rvu01,rvu00 FROM rvu_file",
                     " WHERE rvu00='1' AND (rvu02='",g_argv2 CLIPPED,"' OR rvu01='",g_argv2 CLIPPED,"' )",#No.FUN-810046
                     "   AND rvu08='",g_argv3 CLIPPED,"' ",
                     "   AND rvuconf != 'X' ",            #No.MOD-850156 add
                     " ORDER BY rvu00,rvu01"              #TQC-9A0168 mod
      ELSE
         LET g_sql = "SELECT  rvu01,rvu00 FROM rvu_file",
                     " WHERE rvu00='1' AND (rvu02='",g_argv2 CLIPPED,"' OR rvu01='",g_argv2 CLIPPED,"' )",#No.FUN-810046
                     "   AND rvuconf != 'X' ",            #No.MOD-850156 add
                     "   AND rvu08!='SUB'  ORDER BY rvu00,rvu01"   #TQC-9A0168 mod
      END IF
      LET g_wc = " rvu00='1' AND (rvu02='",g_argv2 CLIPPED,"' OR rvu01='",g_argv2 CLIPPED,"' )" CLIPPED   #No.FUN-810046
      IF g_argv1='6' THEN
         LET g_sql = "SELECT  rvu01,rvu00 FROM rvu_file",
                     " WHERE rvu01='",g_argv2 CLIPPED,"'",
                     "   ORDER BY rvu00,rvu01"   #TQC-9A0168 mod
      END IF
      LET g_wc2 = ' 1=1'
   ELSE
    CLEAR FORM                             #清除畫面
    CALL g_rvv.clear()
    CASE
       WHEN g_rvu.rvu00='1'
            CALL cl_getmsg('apm-243',g_lang) RETURNING g_buf
       WHEN g_rvu.rvu00='2'
            CALL cl_getmsg('apm-244',g_lang) RETURNING g_buf
       WHEN g_rvu.rvu00='3'
            CALL cl_getmsg('apm-245',g_lang) RETURNING g_buf
    END CASE
    DISPLAY BY NAME g_rvu.rvu00
    DISPLAY g_buf TO t_1
    IF g_argv2<> ' ' OR g_icq='Y'  OR g_argv5 <> ' ' THEN   #MOD-C90169 add argv5
       IF NOT cl_null(g_argv3) THEN
          IF g_argv3= 'TAP' THEN
             LET g_wc =" (rvu02='",g_argv2 CLIPPED,"' OR rvu01='",g_argv2 CLIPPED,"')",    #No.FUN-810046 
                       " AND (rvu08='TAP' OR rvu08='TRI')"                                 
          ELSE
             LET g_wc =" (rvu02='",g_argv2 CLIPPED,"' OR rvu01='",g_argv5 CLIPPED,"')",    #No.FUN-810046         #MOD-C90169 argv2 -->argv5
                       " AND rvu08='",g_argv3,"'"   
 
          END IF
          LET g_wc2=" 1=1 "
       ELSE
          LET g_wc =" (rvu02='",g_argv2 CLIPPED,"' OR rvu01='",g_argv2 CLIPPED,"' ) AND rvu08!='SUB' "  #No.FUN-810046
          LET g_wc2=" 1=1 "
       END IF
    ELSE
       CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INITIALIZE g_rvu.* TO NULL    #No.FUN-750051

   IF g_rvu00<>'A' THEN          #FUN-B40031
#TQC-AB0412 -----------------------Begin--------------------------
#       CONSTRUCT BY NAME g_wc ON              #螢幕上取單頭條件
#                 rvu116,rvu02,rvu03,rvu01,rvu04,rvu05,rvu16,               #NO.FUN-940083-add rvu116  #FUN-930062 add rvu16 
#                 rvu08,rvu06,rvu07,rvu09,rvu20,rvu99,rvu117,rvu25,rvuconf, #NO.FUN-940083-add rvu117#NO.FUN-A50071 add rvu25
#                 rvu10,rvu11,rvu15,rvu13,rvu14,rvupos,          #NO.FUN-940083    #NO.FUN-960130---add--pos
#                 rvu21,rvu22,rvu23,rvu24,rvucond,rvucont,rvuconu,rvumksg,rvu900,rvuplant,  #NO.FUN-960130---add----
#                 rvu111,rvu112,rvu115,rvu12,rvu113,rvu114,  #NO.FUN-940083
#                 rvuuser,rvugrup,rvumodu,rvudate,rvucrat,   #NO.FUN-960130--add rvucrat--
#                 rvuoriu,rvuorig,                           #TQC-A30041 ADD
#                 rvuud01,rvuud02,rvuud03,rvuud04,rvuud05,
#                 rvuud06,rvuud07,rvuud08,rvuud09,rvuud10,
#                 rvuud11,rvuud12,rvuud13,rvuud14,rvuud15
        CONSTRUCT BY NAME g_wc ON              #螢幕上取單頭條件
                  rvu116,rvu02,rvu03,rvu01,rvu04,rvu05,rvu16,         
                  rvu08,rvu06,rvu07,rvu20,rvu09,rvu99,rvu117,rvu25,rvuconf,
                  rvucond,rvucont,rvuconu,rvu10,rvu11,rvu15,rvu13,rvu14,
                  rvu21,rvu22,rvu23,rvu24,rvumksg,rvu17,                 #FUN-A60009 add:rvu17
                  rvu900,rvuplant, #NO.FUN-B50042
                  rvu111,rvu112,rvu115,rvu113,rvu12,rvu114,
                  rvuuser,rvugrup,rvuoriu,rvuorig,rvumodu,
                  rvudate,rvucrat,
                  rvuud01,rvuud02,rvuud03,rvuud04,rvuud05,
                  rvuud06,rvuud07,rvuud08,rvuud09,rvuud10,
                  rvuud11,rvuud12,rvuud13,rvuud14,rvuud15  
#TQC-AB0412 ----------------------End---------------------------------
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
        ON ACTION CONTROLP
           CASE
               WHEN INFIELD(rvu01)  # 異動單號
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_rvu1"  #MOD-4A0252異動單號開窗,新增q_rvu1
                    LET g_qryparam.state = 'c'
                    DISPLAY "g_argv1=",g_argv1
                    LET g_qryparam.arg1 = g_argv1
                    IF g_argv3='ICD' THEN
                       LET g_qryparam.form = "q_rvu1_icd"
                       LET g_qryparam.state = 'c'                          
                    ELSE
                       LET g_qryparam.form = "q_rvu1"  #MOD-4A0252異動單號開窗,新增q_rvu1
                       LET g_qryparam.state = 'c'
                       DISPLAY "g_argv1=",g_argv1
                       LET g_qryparam.arg1 = g_argv1
                    END IF
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO rvu01
                    NEXT FIELD rvu01
               WHEN INFIELD(rvu02)  #驗收單
                    CALL cl_init_qry_var()
                    IF g_argv3 <> 'TAP'  THEN             #MOD-890002
                       LET g_qryparam.form = "q_rvall"
                    ELSE                                  #MOD-890002
                       LET g_qryparam.form = "q_rvall04"  #MOD-890002
                    END IF                                #MOD-890002
                    LET g_qryparam.state = 'c'
                    #MOD-B60049 add --start--
                    IF g_argv3 = 'SUB'  THEN
                       LET g_qryparam.where = " rva10 = 'SUB'"
                    #MOD-BB0126 add --start--
                    ELSE
                       LET g_qryparam.where = " rva10 <> 'SUB'"
                    #MOD-BB0126 add --end--
                    END IF
                    #MOD-B60049 add --end--
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO rvu02
                    CALL t720_rvu02()
                    NEXT FIELD rvu02
               WHEN INFIELD(rvu04)  #廠商資料
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_pmc1"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO rvu04
                    NEXT FIELD rvu04
               WHEN INFIELD(rvu16)   #領料單號                                                                                      
                    CALL cl_init_qry_var()                                                                                          
                    LET g_qryparam.state= "c"                                                                                       
                    LET g_qryparam.form ="q_sfp1"                                                                                   
                    CALL cl_create_qry() RETURNING g_qryparam.multiret                                                              
                    DISPLAY g_qryparam.multiret TO rvu16                                                                            
                    NEXT FIELD rvu16                                                                                                
               WHEN INFIELD(rvu07) #人員
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rvu07
                 NEXT FIELD rvu07
              WHEN INFIELD(rvu06) #部門
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rvu06
                 NEXT FIELD rvu06
              WHEN INFIELD(rvu111)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_rvu111"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rvu111
                   NEXT FIELD rvu111
              WHEN INFIELD(rvu112)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_rvu112"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rvu112
                   NEXT FIELD rvu112
              WHEN INFIELD(rvu113)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_rvu113"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rvu113
                   NEXT FIELD rvu113
              WHEN INFIELD(rvu115)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_rvu115"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rvu115
                   NEXT FIELD rvu115
              WHEN INFIELD(rvuconu)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form  = "cq_rvuconu"
                 LET g_qryparam.default1 = g_rvu.rvuconu
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rvuconu
                 NEXT FIELD rvuconu
              #No.TQC-BB0243  --Begin
              WHEN INFIELD(rvu117)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_rvu117"
                   LET g_qryparam.state = 'c'
                   LET g_qryparam.arg1  = g_argv1
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rvu117
                   NEXT FIELD rvu117
              #No.TQC-BB0243  --End
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
#MOD-D90146 add beg----
         ON ACTION qbe_save
            CALL cl_qbe_save()
#MOD-D90146 add end----     
       END CONSTRUCT
   #FUN-B40031 Begin---
    ELSE
        CONSTRUCT BY NAME g_wc ON              #螢幕上取單頭條件
                  rvu00,rvu116,rvu02,rvu03,rvu01,rvu04,rvu05,rvu16,         
                 #rvu08,rvu06,rvu07,rvu20,rvu09,rvu99,rvu117,rvu25,rvuconf,       #TQC-B60065
                  rvu08,rvu06,rvu07,rvu20,rvu09,rvu99,rvu117,rvu27,rvu25,rvuconf, #TQC-B60065
                  rvucond,rvucont,rvuconu,rvu10,rvu11,rvu15,rvu13,rvu14,
                  rvu21,rvu22,rvu23,rvu24,rvumksg,rvu17,
                  rvu900,rvuplant, #NO.FUN-B50042
                  rvu111,rvu112,rvu115,rvu113,rvu12,rvu114,
                  rvuuser,rvugrup,rvuoriu,rvuorig,rvumodu,
                  rvudate,rvucrat,
                  rvuud01,rvuud02,rvuud03,rvuud04,rvuud05,
                  rvuud06,rvuud07,rvuud08,rvuud09,rvuud10,
                  rvuud11,rvuud12,rvuud13,rvuud14,rvuud15  
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
        ON ACTION CONTROLP
           CASE
               WHEN INFIELD(rvu01)  # 異動單號
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_rvu1"  #MOD-4A0252異動單號開窗,新增q_rvu1
                    LET g_qryparam.state = 'c'
                    DISPLAY "g_argv1=",g_argv1
                    LET g_qryparam.arg1 = g_argv1
                    IF g_argv3='ICD' THEN
                       LET g_qryparam.form = "q_rvu1_icd"
                       LET g_qryparam.state = 'c'                          
                    ELSE
                       LET g_qryparam.form = "q_rvu1"  #MOD-4A0252異動單號開窗,新增q_rvu1
                       LET g_qryparam.state = 'c'
                       DISPLAY "g_argv1=",g_argv1
                       LET g_qryparam.arg1 = g_argv1
                    END IF
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO rvu01
                    NEXT FIELD rvu01
               WHEN INFIELD(rvu02)  #驗收單
                    CALL cl_init_qry_var()
                    IF g_argv3 <> 'TAP'  THEN             #MOD-890002
                       LET g_qryparam.form = "q_rvall"
                    ELSE                                  #MOD-890002
                       LET g_qryparam.form = "q_rvall04"  #MOD-890002
                    END IF                                #MOD-890002
                    LET g_qryparam.state = 'c'
                    #MOD-B60049 add --start--
                    IF g_argv3 = 'SUB'  THEN
                       LET g_qryparam.where = " rva10 = 'SUB'"
                    #MOD-BB0126 add --start--
                    ELSE
                       LET g_qryparam.where = " rva10 <> 'SUB'"
                    #MOD-BB0126 add --end--
                    END IF
                    #MOD-B60049 add --end--
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO rvu02
                    CALL t720_rvu02()
                    NEXT FIELD rvu02
               WHEN INFIELD(rvu04)  #廠商資料
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_pmc1"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO rvu04
                    NEXT FIELD rvu04
               WHEN INFIELD(rvu16)   #領料單號                                                                                      
                    CALL cl_init_qry_var()                                                                                          
                    LET g_qryparam.state= "c"                                                                                       
                    LET g_qryparam.form ="q_sfp1"                                                                                   
                    CALL cl_create_qry() RETURNING g_qryparam.multiret                                                              
                    DISPLAY g_qryparam.multiret TO rvu16                                                                            
                    NEXT FIELD rvu16                                                                                                
               WHEN INFIELD(rvu07) #人員
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rvu07
                 NEXT FIELD rvu07
              WHEN INFIELD(rvu06) #部門
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rvu06
                 NEXT FIELD rvu06
              WHEN INFIELD(rvu111)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_rvu111"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rvu111
                   NEXT FIELD rvu111
              WHEN INFIELD(rvu112)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_rvu112"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rvu112
                   NEXT FIELD rvu112
              WHEN INFIELD(rvu113)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_rvu113"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rvu113
                   NEXT FIELD rvu113
              WHEN INFIELD(rvu115)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_rvu115"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rvu115
                   NEXT FIELD rvu115
              WHEN INFIELD(rvuconu)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form  = "cq_rvuconu"
                 LET g_qryparam.default1 = g_rvu.rvuconu
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rvuconu
                 NEXT FIELD rvuconu
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
#MOD-D90146 add beg----
         ON ACTION qbe_save
            CALL cl_qbe_save()
#MOD-D90146 add end----
       END CONSTRUCT

    END IF
   #FUN-B40031 End-----
       IF INT_FLAG THEN RETURN END IF
 
       #資料權限的檢查
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rvuuser', 'rvugrup')
 

        CONSTRUCT g_wc2 ON rvv02,rvv05,rvv45,rvv46,qcl02,rvv47,rvv31,rvv031, #FUN-BC0104 add rvv45,rvv46,qcl02,rvv47
                          rvv35,rvv35_fac, #MOD-530073
                          rvv10,rvv11,rvv12,rvv13,   #NO.FUN-960130---add---
                          rvv18,rvv36,rvv37,rvv919,pmm909,pmn24,pmn25,rvv25,rvv89,rvv17,rvv32,rvv33,rvv34,   #FUN-9A0068 add rvv89   #FUN-A80150 add rvv919
                          rvv83,rvv84,rvv85,rvv80,rvv81,rvv82,rvv86,rvv87,
                          rvv38,rvv38t,rvv39,rvv39t,rvv26,rvv41,  #No.FUN-610018
                          rvv930,   #FUN-670051
                          rvvud01,rvvud02,rvvud03,rvvud04,rvvud05,
                          rvvud06,rvvud07,rvvud08,rvvud09,rvvud10,
                          rvvud11,rvvud12,rvvud13,rvvud14,rvvud15
                     FROM s_rvv[1].rvv02, s_rvv[1].rvv05,
                          s_rvv[1].rvv45, s_rvv[1].rvv46, s_rvv[1].qcl02,   #FUN-BC0104 add
                          s_rvv[1].rvv47,           #FUN-BC0104 add
                          s_rvv[1].rvv31,
                          s_rvv[1].rvv031,
                          s_rvv[1].rvv35, s_rvv[1].rvv35_fac, #MOD-530073
                          s_rvv[1].rvv10,s_rvv[1].rvv11,s_rvv[1].rvv12,s_rvv[1].rvv13,  #NO.FUN-960130----add---
                          s_rvv[1].rvv18, s_rvv[1].rvv36, s_rvv[1].rvv37,s_rvv[1].rvv919,     #FUN-A80150 add rvv919
                          s_rvv[1].pmm909,s_rvv[1].pmn24, s_rvv[1].pmn25,  #FUN-740046 add
                          s_rvv[1].rvv25, s_rvv[1].rvv89, s_rvv[1].rvv17, s_rvv[1].rvv32,  #FUN-9A0068 add rvv89
                          s_rvv[1].rvv33, s_rvv[1].rvv34,
                          s_rvv[1].rvv83,
                          s_rvv[1].rvv84, s_rvv[1].rvv85, s_rvv[1].rvv80,
                          s_rvv[1].rvv81, s_rvv[1].rvv82, s_rvv[1].rvv86,
                          s_rvv[1].rvv87, s_rvv[1].rvv38, s_rvv[1].rvv38t,
                          s_rvv[1].rvv39, s_rvv[1].rvv39t,
                          s_rvv[1].rvv26, s_rvv[1].rvv41, #no.A050
                          s_rvv[1].rvv930,   #FUN-670051
                          s_rvv[1].rvvud01,s_rvv[1].rvvud02,s_rvv[1].rvvud03,
                          s_rvv[1].rvvud04,s_rvv[1].rvvud05,s_rvv[1].rvvud06,
                          s_rvv[1].rvvud07,s_rvv[1].rvvud08,s_rvv[1].rvvud09,
                          s_rvv[1].rvvud10,s_rvv[1].rvvud11,s_rvv[1].rvvud12,
                          s_rvv[1].rvvud13,s_rvv[1].rvvud14,s_rvv[1].rvvud15
    BEFORE CONSTRUCT
       CALL cl_qbe_display_condition(lc_qbe_sn)
        ON ACTION CONTROLP
           CASE WHEN INFIELD(rvv31)      #料號
#FUN-AA0059---------mod------------str-----------------           
#                      CALL cl_init_qry_var()
#                      LET g_qryparam.form = "q_ima"
#                      LET g_qryparam.state = 'c'
#                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  
                        RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                      DISPLAY g_qryparam.multiret TO rvv31
                      NEXT FIELD rvv31
                 WHEN INFIELD(rvv05) #查詢驗收單項次
                      IF g_rvu.rvu00='3' THEN #-- 倉退
                          CALL q_rvb7(TRUE,TRUE,g_rvu.rvu02,g_rvv[1].rvv05,g_rvu.rvu01) RETURNING g_qryparam.multiret
                      ELSE
                          CALL cl_init_qry_var()
                          LET g_qryparam.form = "q_rvb"
                          LET g_qryparam.state = 'c'
                          CALL cl_create_qry() RETURNING g_qryparam.multiret
                      END IF
                       DISPLAY g_qryparam.multiret TO rvv05          #No.MOD-490371
                      NEXT FIELD rvv05
                 WHEN INFIELD(rvv35) #查詢單位
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_gfe"
                      LET g_qryparam.state = 'c'
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO rvv35
                      NEXT FIELD rvv35

                 #FUN-BC0104---add---str
                 WHEN INFIELD(rvv46)
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_qco"
                      LET g_qryparam.state = 'c'
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO rvv46
                      NEXT FIELD rvv46

                 WHEN INFIELD(rvv47)
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_qco"
                      LET g_qryparam.state = 'c'
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO rvv47
                      NEXT FIELD rvv47 
                 #FUN-BC0104---add---end
 
                 WHEN INFIELD(rvv26)   #退貨理由
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_azf01a"                          #No.FUN-930145 
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.default1 = g_rvv[1].rvv26 #FUN-740171
                     #-----MOD-AB0051--------- 
                     #LET g_qryparam.arg1 = '7'                                 #No.FUN-930145
                     IF g_argv1 = '1' THEN 
                        LET g_qryparam.arg1 = '7'
                     ELSE
                        LET g_qryparam.arg1 = '5'
                     END IF
                     #-----END MOD-AB0051-----
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO rvv26
                     NEXT FIELD rvv26
                WHEN INFIELD(rvv32)  #倉庫    #MOD-480604 倉庫開窗
                     #No.FUN-AA0049--begin
                     #CALL cl_init_qry_var()
                     #LET g_qryparam.form = "q_imd"
                     #LET g_qryparam.state = "c"
                     #LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
                     #CALL cl_create_qry() RETURNING g_qryparam.multiret
                     CALL q_imd_1(TRUE,TRUE,"","","","","") RETURNING g_qryparam.multiret
                     #No.FUN-AA0049--end
                     DISPLAY g_qryparam.multiret TO rvv32
                     NEXT FIELD rvv32
               WHEN INFIELD(rvv33)
                  #No.FUN-AA0049--begin
                  #CALL cl_init_qry_var()
                  #LET g_qryparam.form     = "q_ime"
                  #LET g_qryparam.state    = "c"
                  #CALL cl_create_qry() RETURNING g_qryparam.multiret                  
                  CALL q_ime_1(TRUE,TRUE,"","","",g_plant,"","","") RETURNING g_qryparam.multiret
                  #No.FUN-AA0049--end
                  DISPLAY g_qryparam.multiret TO rvv33
                  NEXT FIELD rvv33
               WHEN INFIELD(rvv41)
                    SELECT pmm04 INTO l_pmm04 FROM pmm_file
                     WHERE pmm01 = g_rvv[1].rvv36
                    CALL q_coc2(TRUE,TRUE,g_rvv[1].rvv41,'',l_pmm04,'1',
                                '',g_rvv[1].rvv31)
                    RETURNING g_rvv[1].rvv41
                     DISPLAY BY NAME g_rvv[1].rvv41         #No.MOD-490371
                    NEXT FIELD rvv41
                WHEN INFIELD(rvv83)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form ="q_gfe"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO rvv83
                     NEXT FIELD rvv83
 
                WHEN INFIELD(rvv80)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form ="q_gfe"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO rvv80
                     NEXT FIELD rvv80
 
               WHEN INFIELD(pmn24) #請購單號
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_pml3"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pmn24
                    NEXT FIELD pmn24
 
                WHEN INFIELD(rvv86)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form ="q_gfe"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO rvv86
                     NEXT FIELD rvv86
                WHEN INFIELD(rvv930)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form  = "q_gem4"
                   LET g_qryparam.state = "c"   #多選
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rvv930
                   NEXT FIELD rvv930
                #CHI-A70035 add --start--
                WHEN INFIELD(rvvud02)
                   CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rvvud02
                   NEXT FIELD rvvud02
                WHEN INFIELD(rvvud03)
                   CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rvvud03
                   NEXT FIELD rvvud03
                WHEN INFIELD(rvvud04)
                   CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rvvud04
                   NEXT FIELD rvvud04
                WHEN INFIELD(rvvud05)
                   CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rvvud05
                   NEXT FIELD rvvud05
                WHEN INFIELD(rvvud06)
                   CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rvvud06
                   NEXT FIELD rvvud06
                #CHI-A70035 add --end--
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
        # LET INT_FLAG=0  #FUN-C20006
          RETURN 
       END IF
    END IF
   #FUN-B40031 Begin---
    IF g_rvu00 = 'A' THEN
      #LET g_wc = g_wc CLIPPED," AND rvu21 = '4' "
       LET g_wc = g_wc CLIPPED," AND rvu27 IN ('2','3','4') "
    ELSE
      #LET g_wc = g_wc CLIPPED," AND rvu21 != '4' "
       LET g_wc = g_wc CLIPPED," AND (rvu27 = '1' OR rvu27 = ' ')"
    END IF
   #FUN-B40031 End-----
    IF g_wc2 = " 1=1" THEN                      # 若單身未輸入條件
       LET g_sql = "SELECT rvu01,rvu00 FROM rvu_file",
                   " WHERE ", g_wc CLIPPED
    ELSE                                       # 若單身有輸入條件
       IF g_prog[1,7] = 'apmt720' OR g_prog[1,7] = 'aict042' THEN  #CHI-830025 add 1,7 #MOD-D30083 add aict042
          LET g_sql = "SELECT UNIQUE rvu01,rvu00 ",
                      "  FROM rvu_file, rvv_file",
#TQC-A60046 --Begin
#                     "      ,OUTER (pmn_file, OUTER pmm_file) ",    #No.FUN-940083
#                     " WHERE rvu01 = rvv01 ",
#                     "    AND pmm_file.pmm01 = pmn_file.pmn01 ",      #No.FUN-940083
#                     "   AND pmn_file.pmn01 = rvv36 AND pmn_file.pmn02 = rvv37 ", #No.FUN-940083
                      "   LEFT OUTER JOIN ",
                      "   pmn_file LEFT OUTER JOIN pmm_file ON pmn01=pmm01 ",
                      "    ON pmn01=rvv36 AND pmn02=rvv37 ",
                      " WHERE rvu01 = rvv01 ",
#TQC-A60046 --End
                      "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED
       ELSE
          LET g_sql = "SELECT UNIQUE rvu01,rvu00 ",
                      "  FROM rvu_file, rvv_file",
                      " WHERE rvu01 = rvv01 ",
                      "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED
       END IF
    END IF
    IF NOT cl_null(g_argv1) THEN
      #FUN-B40031 Begin---
      #LET g_sql=g_sql clipped," AND rvu00='",g_argv1,"'"
       IF g_rvu00 = 'A' THEN
          LET g_sql=g_sql clipped," AND (rvu00='1' OR rvu00='3')"
       ELSE
          LET g_sql=g_sql clipped," AND rvu00='",g_argv1,"'"
       END IF
      #FUN-B40031 End-----
    END IF
    IF NOT cl_null(g_argv2) THEN
       LET g_sql=g_sql clipped," AND (rvu02='",g_argv2 CLIPPED,"' OR rvu01='",g_argv2 CLIPPED,"' )" #No.FUN-810046
    END IF
    IF NOT cl_null(g_argv3) THEN
       IF g_argv3 !='TAP' THEN
          LET g_sql=g_sql clipped," AND rvu08='",g_argv3,"'"
       ELSE
          LET g_sql=g_sql CLIPPED," AND (rvu08='TAP' OR rvu08='TRI') "
       END IF
    ELSE
       LET g_sql=g_sql clipped," AND rvu08!='SUB' AND rvu08 != 'TAP' ",
                               " AND rvu08!='TRI'" #No.7882
    END IF    
    LET g_sql=g_sql CLIPPED,' ORDER BY 1,2' #No.9475
  END IF
 
    PREPARE t720_prepare FROM g_sql
    IF status THEN CALL cl_err('t720_prepare :',status,0) END IF
    DECLARE t720_cs                            #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t720_prepare
    DECLARE t720_fill_cs CURSOR FOR t720_prepare    #FUN-CB0014 add
    IF g_wc2 = " 1=1" THEN                     # 取合乎條件筆數
       LET g_sql="SELECT COUNT(*) FROM rvu_file WHERE ",g_wc CLIPPED
    ELSE
       IF g_prog = 'apmt720' OR g_prog = 'aict042' THEN  #MOD-D30083 add aict042
          LET g_sql="SELECT COUNT(DISTINCT rvu01) ",
                    "   FROM rvu_file,rvv_file,OUTER (pmn_file,OUTER pmm_file) ",   #No.FUN-940083
                    " WHERE rvv01=rvu01 ",
                    #"   AND pmm01 = pmn01 AND rvv36 = pmn_file.pmn01 AND rvv37 = pmn_file.pmn02 ",  #FUN-740046   #No.FUN-940083
                    "   AND pmm_file.pmm01 = pmn_file.pmn01 ",   #No.FUN-940083
                    "   AND rvv36 = pmn_file.pmn01 ",             #No.FUN-940083
                    "   AND rvv37 = pmn_file.pmn02 ",            #No.FUN-940083
                    "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
       ELSE
          LET g_sql="SELECT COUNT(DISTINCT rvu01) FROM rvu_file,rvv_file ",
                    " WHERE rvv01=rvu01 ",
                    "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
       END IF
    END IF
    IF NOT g_argv1 MATCHES '[56Z]' THEN                                      #No.FUN-940083
       IF NOT cl_null(g_argv1) THEN
         #FUN-B40031 Begin---
         #LET g_sql=g_sql clipped," AND rvu00='",g_argv1,"'"
          IF g_rvu00 = 'A' THEN
             LET g_sql=g_sql clipped," AND (rvu00='1' OR rvu00='3')"
          ELSE
             LET g_sql=g_sql clipped," AND rvu00='",g_argv1,"'"
          END IF
         #FUN-B40031 End-----
       END IF
       IF NOT cl_null(g_argv3) THEN
          IF g_argv3 !='TAP' THEN
             LET g_sql=g_sql clipped," AND rvu08='",g_argv3,"'"
          ELSE
             LET g_sql=g_sql CLIPPED," AND (rvu08='TAP' OR rvu08='TRI') "
          END IF
       ELSE
          LET g_sql=g_sql clipped," AND rvu08!='SUB' AND rvu08 != 'TAP' ",
                                  " AND rvu08!='TRI'" #No.7882
       END IF
    END IF

   #FUN-A60009 add str ------------
    IF fgl_getenv('EASYFLOW') = "1" THEN    #判斷是否為簽核模式
       LET g_argv2 = l_argv2                #還原g_argv2的值
    END IF
   #FUN-A60009 add end ------------

    PREPARE t720_count FROM g_sql
    DECLARE t720_curs CURSOR FOR t720_count
END FUNCTION
 
FUNCTION t720_menu()
   DEFINE l_partnum    STRING   #GPM料號
   DEFINE l_supplierid STRING   #GPM廠商
   DEFINE l_status     LIKE type_file.num10  #GPM傳回值
   DEFINE g_cnt        LIKE type_file.num5   #MOD-870114 
   DEFINE l_creator    LIKE type_file.chr1   #「不准」時是否退回填表人  #FUN-A60009 add
   DEFINE l_flowuser   LIKE type_file.chr1   # 是否有指定加簽人員       #FUN-A60009 add
   DEFINE l_cmd        LIKE type_file.chr1000     #FUN-BC0104 add
   DEFINE l_poz18      LIKE poz_file.poz18   #MOD-C10157 add
   DEFINE l_poz19      LIKE poz_file.poz19   #MOD-C10157 add
   DEFINE l_n          LIKE type_file.num5   #FUN-CB0087
   DEFINE lj_result    LIKE type_file.chr1   #CHI-CC0028
   DEFINE l_rvv02      LIKE rvv_file.rvv02   #CHI-CC0028
   DEFINE l_rvv32      LIKE rvv_file.rvv32   #CHI-CC0028
   DEFINE l_rvv33      LIKE rvv_file.rvv33   #CHI-CC0028
   DEFINE l_rvviicd07  LIKE rvvi_file.rvviicd07  #CHI-CC0028
   DEFINE l_success    LIKE type_file.chr1   #CHI-CC0028

   LET l_flowuser = "N"                      #FUN-A60009 add 

   WHILE TRUE
      LET INT_FLAG=0
      IF cl_null(g_action_flag) OR g_action_flag = "page_main" THEN   #FUN-CB0014 add
         CALL t720_bp("G")
      #FUN-CB0014---add---str---
      ELSE                           
         CALL t720_list_fill()
         CALL t720_bp3("G")
         IF NOT cl_null(g_action_choice) AND l_ac2>0 THEN #將清單的資料回傳到主畫面
            SELECT rvu_file.* INTO g_rvu.*
              FROM rvu_file
             WHERE rvu01=g_rvu_l[l_ac2].rvu01
         END IF
         IF g_action_choice!= "" THEN
            LET g_action_flag = "page_main"
            LET l_ac2 = ARR_CURR()
            LET g_jump = l_ac2
            LET mi_no_ask = TRUE
            IF g_rec_b2 >0 THEN
               CALL t720_fetch('/')
            END IF
            CALL cl_set_comp_visible("page4,info,userdefined_field", FALSE)
            CALL cl_set_comp_visible("page_list", FALSE) 
            CALL ui.interface.refresh()           
            CALL cl_set_comp_visible("page4,info,userdefined_field", TRUE)      
            CALL cl_set_comp_visible("page_list", TRUE) 
         END IF               
      END IF  
      #FUN-CB0014---add---str--
      CASE g_action_choice
 
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t720_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               LET g_icq=''
               CALL t720_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t720_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t720_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t720_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               IF not cl_null(g_rvu.rvu01) THEN
                  CALL t720_out()
               END IF
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
       #@WHEN "轉報工單"
         WHEN "transfer_to_report"
            IF cl_chk_act_auth() THEN
              IF g_rvu.rvu17 matches '[Ss]' THEN             #FUN-A60009 add
                CALL cl_err('','apm-030',0)                  #FUN-A60009 add
              ELSE                                           #FUN-A60009 add
                IF g_rvu.rvuconf !='X' THEN
                   IF g_rvu.rvuconf !='Y' THEN               #TQC-B60215 add
                      CALL cl_err(g_rvu.rvu01,'apm1060',1)   #TQC-B60215 add
                   ELSE
                      CALL t720sub_ecm(g_rvu.rvu01) #FUN-A10130
                   END IF                                    #TQC-B60215 add 
                END IF
              END IF                                         #FUN-A60009 add
            END IF
       #@WHEN "折讓"
         WHEN "allowance"
            IF cl_chk_act_auth() THEN
              IF g_rvu.rvu17 matches '[Ss]' THEN             #FUN-A60009 add
                CALL cl_err('','apm-030',0)                  #FUN-A60009 add
              ELSE                                           #FUN-A60009 add
                CALL t720_t()
              END IF                                         #FUN-A60009 add
            END IF
       #@WHEN "取回"
         WHEN "recall"
            IF cl_chk_act_auth() THEN
              IF g_rvu.rvu17 matches '[Ss]' THEN             #FUN-A60009 add
                CALL cl_err('','apm-030',0)                  #FUN-A60009 add
              ELSE                                           #FUN-A60009 add
                CALL t720_k()
              END IF                                         #FUN-A60009 add
            END IF
       #@WHEN "作廢"
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL t720_x()  #FUN-D20025
               CALL t720_x(1) #FUN-D20025
               CALL t720_show() #FUN-BC0104 add
            END IF
       #FUN-D20025---add--str---
       #@WHEN "取消作廢"
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
              #CALL t720_x()  #FUN-D20025
               CALL t720_x(2) #FUN-D20025
               CALL t720_show() #FUN-BC0104 add
            END IF
       #FUN-D20025---add--str---
       #@WHEN "確認"
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
              #CALL t720sub_y(g_rvu.rvu01,g_argv1,g_argv2,g_argv3,g_chr,FALSE,'Y') #FUN-A10130   #FUN-A60009 mark
              #FUN-A60009 add str --------------------
               CALL t720sub_y_chk(g_rvu.rvu01,g_argv1,g_argv2,g_argv3,g_chr,'Y')
               #FUN-CB0087---add---str---
               IF g_aza.aza115='Y' THEN 
                  LET l_n = 0
                  SELECT COUNT(*) INTO l_n FROM rvv_file WHERE rvv26 IS NULL AND rvv01 = g_rvu.rvu01
                  IF l_n >0 THEN 
                     CALL cl_err('','aim-888',0)
                     LET g_success='N' 
                  END IF
               END IF
               #FUN-CB0087---add---end---
               IF g_success = "Y" THEN
                  #CALL t720sub_y_upd(g_rvu.rvu01,g_argv1,g_argv2,g_argv3,g_chr,FALSE,'Y')    #MOD-C80049 mark
                  CALL t720sub_y_upd(g_rvu.rvu01,g_argv1,g_argv2,g_argv3,g_chr,FALSE,'Y','N') #MOD-C80049 add
               END IF
              #FUN-A60009 add end ---------------------
               CALL t720_refresh() RETURNING g_rvu.*  #FUN-A10130
               CALL t720_show()   #FUN-A10130
            END IF
       #@WHEN "確認還原"
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
            #FUN-BC0062 ---------Begin--------
            #當成本計算方式ccz28選擇'6'，過帳還原時控制不可過帳還原
               SELECT ccz_file.* INTO g_ccz.* FROM ccz_file WHERE ccz00='0'
               SELECT rvuconf INTO g_rvu.rvuconf FROM rvu_file WHERE rvu01 = g_rvu.rvu01
               IF g_ccz.ccz28  = '6' AND g_rvu.rvuconf = 'Y' THEN
                  CALL cl_err('','apm-936',1)
                  CONTINUE WHILE
               END IF
            #FUN-BC0062 ---------End----------
               #str----add by guanyao160824
               LET l_n =0 
               SELECT COUNT(*) INTO l_n FROM tc_shb_file WHERE tc_shbud03 =g_rvu.rvu01 
               IF l_n  >0 THEN 
                  CALL cl_err('','cpm-052',0)
                  CONTINUE WHILE
               END IF 
               #end----add by guanyao160824
               #CHI-CC0028---begin
               LET l_success = 'Y'
               DECLARE t720_rvv33 CURSOR FOR
                SELECT rvv02,rvv32,rvv33 FROM rvv_file WHERE rvv01 = g_rvu.rvu01
               CALL s_showmsg_init()
               FOREACH t720_rvv33 INTO l_rvv02,l_rvv32,l_rvv33 
                  IF STATUS THEN
                     CALL cl_err('foreach:',SQLCA.sqlcode,0)
                     CONTINUE WHILE
                  END IF

                  IF s_industry('icd') THEN
                     SELECT rvviicd07 INTO l_rvviicd07 FROM rvvi_file
                      WHERE rvvi01 = g_rvu.rvu01 AND rvvi02 = l_rvv02
                     IF l_rvviicd07 = 'Y' THEN
                        CONTINUE FOREACH  
                     END IF 
                  END IF 

                  IF NOT s_chk_ware(l_rvv32) THEN
                     CONTINUE WHILE
                  END IF

                  CALL s_incchk(l_rvv32,l_rvv33,g_user) 
                       RETURNING lj_result
                  IF NOT lj_result THEN
                     LET l_success = 'N'  
                     LET g_showmsg = l_rvv02,"/",l_rvv32,"/",l_rvv33,"/",g_user
                     CALL s_errmsg('rvv02,rvv32,rvv33,inc03',g_showmsg,'','asf-888',1)
                  END IF
               END FOREACH
               CALL s_showmsg() 
               IF l_success = 'N' THEN
                  CONTINUE WHILE
               END IF
               #CHI-CC0028---end            
               #-----CHI-B40011---------
              #SELECT rvuconf,rvu20 INTO g_rvu.rvuconf,g_rvu.rvu20   #MOD-C10157 mark
               SELECT rvuconf,rvu20,rvu02 INTO g_rvu.rvuconf,g_rvu.rvu20,g_rvu.rvu02    #MOD-C10157 add
                 FROM rvu_file 
                WHERE rvu01 = g_rvu.rvu01
               SELECT pod05 INTO g_pod.pod05 
                 FROM pod_file 
                WHERE pod00 = '0'
               #MOD-C10157 add --start--
               SELECT poz18,poz19 INTO l_poz18,l_poz19
                 FROM poz_file,rva_file,rvb_file,pmm_file
                WHERE poz01 = pmm904
                  AND pmm01 = rvb04
                  AND rvb01 = rva01
                  AND rva01 = g_rvu.rvu02
               IF l_poz19 = 'Y'  AND g_plant=l_poz18 THEN    #已設立中斷點
                  LET g_rvu.rvu20 = 'N'
                  LET g_rvu.rvu99 = ''
                  DISPLAY BY NAME g_rvu.rvu20
                  DISPLAY BY NAME g_rvu.rvu99
               END IF
               #MOD-C10157 add --end--
               IF g_pod.pod05 = 'Y' AND 
                  g_rvu.rvuconf='Y' AND g_rvu.rvu20 = 'Y' THEN
                  IF cl_confirm('apm1056') THEN 
                     CASE
                        WHEN g_rvu.rvu00='1' #入庫
                           IF t720sub_chkpoz011(g_rvu.rvu01) THEN
                               LET g_cnt=0
                               SELECT COUNT(*) INTO g_cnt FROM apb_file,apa_file
                                WHERE apa01 = apb01
                                  AND apb21 = g_rvu.rvu01
                                  AND apa42 = 'N'
                               IF g_cnt > 0 THEN
                                  CALL cl_err('sel apb:','axm-502',1)
                               ELSE
                                  LET g_msg="apmp832 '",g_rvu.rvu01,"'"
                                  CALL cl_cmdrun_wait(g_msg CLIPPED)
                               END IF
                           ELSE
                               CALL cl_err('','apm-741',0)     
                           END IF
                        WHEN g_rvu.rvu00='3' #倉退
                           IF t720sub_chkpoz011(g_rvu.rvu01) THEN  
                              LET g_cnt=0
                              SELECT COUNT(*) INTO g_cnt FROM apb_file,apa_file
                               WHERE apa01 = apb01
                                 AND apb21 = g_rvu.rvu01
                                 AND apa42 = 'N'
                              IF g_cnt > 0 THEN
                                 CALL cl_err('sel apb:','axm-502',1)
                              ELSE
                                 LET g_msg="apmp841 '",g_rvu.rvu01,"'"
                                 CALL cl_cmdrun_wait(g_msg CLIPPED)
                              END IF
                           END IF
                     END CASE
                  END IF
                  SELECT rvu20,rvu99 INTO g_rvu.rvu20,g_rvu.rvu99 FROM rvu_file
                  WHERE rvu01 = g_rvu.rvu01
                  DISPLAY BY NAME g_rvu.rvu20
                  DISPLAY BY NAME g_rvu.rvu99
                  IF cl_null(g_rvu.rvu99) THEN
                     CALL t720_z()
                  END IF
               ELSE
               #-----END CHI-B40011-----
                  CALL t720_z()
               END IF   #CHI-B40011
            END IF
       #@WHEN "拋轉"
         WHEN "carry"
            IF NOT cl_sure(10,10) THEN CONTINUE WHILE END IF
            IF g_rvu.rvu17 matches '[Ss]' THEN             #FUN-A60009 add
               CALL cl_err('','apm-030',0)                 #FUN-A60009 add
            ELSE                                           #FUN-A60009 add
               IF g_rvu.rvu20 = 'Y' THEN CALL cl_err('','mfg0999',1) END IF   # No.TQC-740305    #NO.MOD-740507
               IF cl_chk_act_auth() AND g_rvu.rvuconf='Y' AND g_rvu.rvu20 = 'N' THEN     # No.TQC-740305  #no.MOD-740507
                  CASE
                     WHEN g_rvu.rvu00='1' #入庫
                        #IF t720_chkpoz011() THEN   #CHI-B40011
                        IF t720sub_chkpoz011(g_rvu.rvu01) THEN   #CHI-B40011
                           LET g_msg="apmp822 '",g_rvu.rvu01,"'"
                           CALL cl_cmdrun_wait(g_msg CLIPPED)
                        ELSE
                           CALL cl_err('','apm-740',0) #TQC-7C0058
                        END IF
                     WHEN g_rvu.rvu00='3' #倉退
                        IF g_azw.azw04='2' AND g_prog = 'apmt742' THEN
                           #CALL t720_set_poz()   #CHI-B40011
                           CALL t720sub_set_poz(g_rvu.rvu01)   #CHI-B40011
                           LET g_msg="apmp840 '",g_rvu.rvu01,"'"
                           CALL cl_cmdrun_wait(g_msg CLIPPED)
                        ELSE
                           #IF t720_chkpoz011() THEN  #MOD-920279   #CHI-B40011
                           IF t720sub_chkpoz011(g_rvu.rvu01) THEN  #MOD-920279   #CHI-B40011
                              LET g_msg="apmp840 '",g_rvu.rvu01,"'"
                              CALL cl_cmdrun_wait(g_msg CLIPPED)
                           END IF
                        END IF
                  END CASE
                  SELECT rvu20,rvu99 INTO g_rvu.rvu20,g_rvu.rvu99 FROM rvu_file
                  WHERE rvu01 = g_rvu.rvu01
                  DISPLAY BY NAME g_rvu.rvu20
                  DISPLAY BY NAME g_rvu.rvu99
               END IF
            END IF                                #FUN-A60009 add
       #@WHEN "拋轉還原"
         WHEN "undo_carry"
            IF NOT cl_sure(10,10) THEN CONTINUE WHILE END IF
            IF g_rvu.rvu17 matches '[Ss]' THEN             #FUN-A60009 add
               CALL cl_err('','apm-030',0)                 #FUN-A60009 add
            ELSE                                           #FUN-A60009 add
               IF cl_chk_act_auth() AND g_rvu.rvuconf='Y' AND g_rvu.rvu20 = 'Y' THEN
                  CASE
                     WHEN g_rvu.rvu00='1' #入庫
                        #IF t720_chkpoz011() THEN   #CHI-B40011
                        IF t720sub_chkpoz011(g_rvu.rvu01) THEN   #CHI-B40011
                            #no.6150若已經立帳(已有應付帳款資料)則不可拋轉還原...
                            LET g_cnt=0
                            SELECT COUNT(*) INTO g_cnt FROM apb_file,apa_file
                             WHERE apa01 = apb01
                               AND apb21 = g_rvu.rvu01
                               AND apa42 = 'N'
                            IF g_cnt > 0 THEN
                               CALL cl_err('sel apb:','axm-502',1)
                               CONTINUE WHILE
                            END IF
                           LET g_msg="apmp832 '",g_rvu.rvu01,"'"
                           CALL cl_cmdrun_wait(g_msg CLIPPED)
                        ELSE #TQC-7C0062
                           CALL cl_err('','apm-741',0)  #TQC-7C0062
                        END IF
                     WHEN g_rvu.rvu00='3' #倉退
                        #IF t720_chkpoz011() THEN  #MOD-920279   #CHI-B40011
                        IF t720sub_chkpoz011(g_rvu.rvu01) THEN  #MOD-920279   #CHI-B40011
                          #-MOD-970043-add-若已經立帳(已有應付帳款資料)則不可拋轉還原
                           LET g_cnt=0
                           SELECT COUNT(*) INTO g_cnt FROM apb_file,apa_file
                            WHERE apa01 = apb01
                              AND apb21 = g_rvu.rvu01
                              AND apa42 = 'N'
                           IF g_cnt > 0 THEN
                              CALL cl_err('sel apb:','axm-502',1)
                              CONTINUE WHILE
                           END IF
                           LET g_msg="apmp841 '",g_rvu.rvu01,"'"
                           CALL cl_cmdrun_wait(g_msg CLIPPED)
                        END IF
                  END CASE
                  SELECT rvu20,rvu99 INTO g_rvu.rvu20,g_rvu.rvu99 FROM rvu_file
                  WHERE rvu01 = g_rvu.rvu01
                  DISPLAY BY NAME g_rvu.rvu20
                  DISPLAY BY NAME g_rvu.rvu99
               END IF
            END IF                              #FUN-A60009 add
         #@WHEN "價格變更"
         WHEN "price_change"
            IF g_rvu.rvu17 matches '[Ss]' THEN             #FUN-A60009 add
               CALL cl_err('','apm-030',0)                 #FUN-A60009 add
            ELSE                                           #FUN-A60009 add
               IF g_rvu.rvu01 IS NULL THEN
                  CALL cl_err('',-400,0)
               ELSE
                  IF g_rvu.rvuconf = 'X' THEN   #TQC-740117 add
                     CALL cl_err('','9024',0)
                  ELSE
                    SELECT COUNT(*) INTO g_n FROM rvv_file
                     WHERE rvv01 = g_rvu.rvu01
                       AND rvv03='1' AND rvv23=0
                    IF g_n = 0 THEN
                       CALL cl_err('','apm-900',0)
                    ELSE
                       LET g_msg="apmi300 '",g_rvu.rvu01,"'"
                       CALL cl_cmdrun_wait(g_msg CLIPPED)
                       CALL t720_b_fill(' 1=1')

                    END IF
                  END IF
               END IF
            END IF                                         #FUN-A60009 add 

         #FUN-A60009 add str ---
         WHEN "approval_status"               #簽核狀況
            IF cl_chk_act_auth() THEN          #DISPLAY ONLY
               IF aws_condition2() THEN
                  CALL aws_efstat2()
               END IF
            END IF

         WHEN "easyflow_approval"             #EasyFlow送簽
            IF cl_chk_act_auth() THEN
              #FUN-C20026 add str---
               SELECT * INTO g_rvu.* FROM rvu_file
                WHERE rvu01 = g_rvu.rvu01
               CALL t720_show()
               CALL t720_b_fill(' 1=1')
              #FUN-C20026 add end---
               CALL t720_ef()
               CALL t720_show()  #FUN-C20026 add
            END IF
         #FUN-A60009 add end ---
         #FUN-BC0104---add---str
         WHEN "qc_determine_storage"
            IF cl_chk_act_auth() THEN
               LET  l_cmd = "aqcp107 '1' '' '' '' '' '' '' '' '' 'N'"
               CALL cl_cmdrun(l_cmd)
            END IF
         #FUN-BC0104---add---end
         #str----add by guanyao160706
         #WHEN "fa_issue"
         #   IF cl_chk_act_auth() THEN                                                                                                  
         #      CALL t720_fa_issue()                                                                                                         
         #   END IF
         #end----add by guanyao160706

         WHEN "exporttoexcel"     #FUN-4B0025
            IF cl_chk_act_auth() THEN
              #CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rvv),'','') #FUN-CB0014 mark
              #FUN-CB0014---add---str---
              LET w = ui.Window.getCurrent()   
              LET f = w.getForm()       
              IF cl_null(g_action_flag) OR g_action_flag = "page_main" THEN  
                 LET page = f.FindNode("Page","page1") 
                 CALL cl_export_to_excel(page,base.TypeInfo.create(g_rvv),'','')
              END IF
              IF g_action_flag = "page_list" THEN
                 LET page = f.FindNode("Page","page_list")
                    CALL cl_export_to_excel(page,base.TypeInfo.create(g_rvu_l),'','')
              END IF
              #FUN-CB0014---add---end---
            END IF

         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_rvu.rvu01 IS NOT NULL THEN
                LET g_doc.column1 = "rvu01"
                LET g_doc.column2 = "rvu00"
                LET g_doc.value1 = g_rvu.rvu01
                LET g_doc.value2 = g_rvu.rvu00
                CALL cl_doc()
             END IF
          END IF
 
         WHEN "carry_delivery"
           IF cl_chk_act_auth() THEN
             IF g_rvu.rvu17 matches '[Ss]' THEN             #FUN-A60009 add
                CALL cl_err('','apm-030',0)                 #FUN-A60009 add
             ELSE                                           #FUN-A60009 add
                CALL t720_exp_delivery()
             END IF                                         #FUN-A60009 add
           END IF

         WHEN "gen_transfer_note"
           IF cl_chk_act_auth() THEN
             IF g_rvu.rvu17 matches '[Ss]' THEN             #FUN-A60009 add
                CALL cl_err('','apm-030',0)                 #FUN-A60009 add
             ELSE                                           #FUN-A60009 add     
                CALL t720_gen_note()
             END IF                                         #FUN-A60009 add
           END IF
 
         #@WHEN GPM規範顯示
         WHEN "gpm_show"
              LET l_partnum = ''
              LET l_supplierid = ''
              IF l_ac > 0 THEN LET l_partnum = g_rvv[l_ac].rvv31 END IF
              LET l_supplierid = g_rvu.rvu04
              CALL aws_gpmcli(l_partnum,l_supplierid)
                RETURNING l_status
 
         #@WHEN GPM規範查詢
         WHEN "gpm_query"
              LET l_partnum = ''
              LET l_supplierid = ''
              IF l_ac > 0 THEN LET l_partnum = g_rvv[l_ac].rvv31 END IF
              LET l_supplierid = g_rvu.rvu04
              CALL aws_gpmcli(l_partnum,l_supplierid)
                RETURNING l_status
 
         WHEN "qry_lot"
           IF l_ac > 0 THEN                     #TQC-C70207 add
              LET g_ima918=''                   #TQC-C70207 add
              LET g_ima921=''                   #TQC-C70207 add
              SELECT ima918,ima921 INTO g_ima918,g_ima921 
                FROM ima_file
               WHERE ima01 = g_rvv[l_ac].rvv31
                 AND imaacti = "Y"
           
              IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                 IF g_sma.sma90 = "Y" THEN #MOD-C30074 add
                    SELECT img09 INTO g_img09 FROM img_file
                    WHERE img01=g_rvv[l_ac].rvv31 AND img02=g_rvv[l_ac].rvv32
                      AND img03=g_rvv[l_ac].rvv33 AND img04=g_rvv[l_ac].rvv34
                    IF g_rvu.rvu116 <> '3' OR cl_null(g_rvu.rvu116) THEN   #MOD-CB0229 add
   #No.TQC-B90236--------mark---------begin-----------
                   #CALL s_lotin(g_prog,g_rvu.rvu01,g_rvv[l_ac].rvv02,0,                            
                   #             g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv35,g_img09,
                   #             g_rvv[l_ac].rvv35_fac,g_rvv[l_ac].rvv17,'','QRY')#CHI-9A0022 add ''
                   #       RETURNING l_r,g_qty 
   #No.TQC-B90236--------mark---------end-------------
                       CALL s_wo_record(g_rvv[l_ac].rvv18,'Y')   #MOD-CC0047 add
   #No.TQC-B90236--------add----------begin-----------
                       IF g_rvu.rvu00='1' THEN
                          CALL s_mod_lot(g_prog,g_rvu.rvu01,g_rvv[l_ac].rvv02,0,
                                         g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv32,g_rvv[l_ac].rvv33,
                                         g_rvv[l_ac].rvv34,g_rvv[l_ac].rvv35,g_img09,
                                         g_rvv[l_ac].rvv35_fac,g_rvv[l_ac].rvv17,'','QRY',1) #CHI-9A0022 add ''
                                  RETURNING l_r,g_qty
                       ELSE
                          CALL s_mod_lot(g_prog,g_rvu.rvu01,g_rvv[l_ac].rvv02,0,
                                         g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv32,g_rvv[l_ac].rvv33,
                                         g_rvv[l_ac].rvv34,g_rvv[l_ac].rvv35,g_img09,
                                         g_rvv[l_ac].rvv35_fac,g_rvv[l_ac].rvv17,'','QRY',-1) #CHI-9A0022 add ''
                                  RETURNING l_r,g_qty
                       END IF
   #No.TQC-B90236--------add----------end-------------	
                    END IF   #MOD-CB0229 add
                 END IF #MOD-C30074 add
              END IF
           END IF                   #TQC-C70207 add
         WHEN "gen_mat_wtdw"   #領料單生成                                                                                           
           IF cl_chk_act_auth() THEN                                                                                                
              IF g_rvu.rvu17 matches '[Ss]' THEN             #FUN-A60009 add
                 CALL cl_err('','apm-030',0)                 #FUN-A60009 add
              ELSE                                           #FUN-A60009 add
                 CALL t720_m()                                                  
              END IF                                         #FUN-A60009 add                                          
           END IF                                                                                                                   
         WHEN "maint_mat_wtdw"  #領料單維護                                                                                          
           IF cl_chk_act_auth() THEN                                        
              IF g_rvu.rvu17 matches '[Ss]' THEN             #FUN-A60009 add
                 CALL cl_err('','apm-030',0)                 #FUN-A60009 add
              ELSE                                           #FUN-A60009 add                                                        
                 IF g_rvu.rvu16 IS NOT NULL THEN                                                                                       
#MOD-B80272 -- begin --
                    CASE g_sma.sma124
                       WHEN 'icd'
                          LET g_cmd = "asfi510_icd", " '4' " ," '",g_rvu.rvu16,"'"
                       WHEN 'slk'
                          LET g_cmd = "asfi510_slk", " '4' " ," '",g_rvu.rvu16,"'"
                       WHEN 'std'
#MOD-B80272 -- end
                          LET g_cmd = "asfi510", " '4' " ," '",g_rvu.rvu16,"'"                                                               
                    END CASE   #MOD-B80272 add
                    CALL cl_cmdrun_wait(g_cmd CLIPPED)                                                                                 
                 END IF                                                                                                                
                 SELECT rvu16 INTO g_rvu.rvu16 FROM rvu_file                                                                           
                 WHERE rvu01 = g_rvu.rvu01                                                                                             
                 DISPLAY BY NAME g_rvu.rvu16                                                                                           
              END IF                                         #FUN-A60009 add
           END IF

#FUN-A60035 ---MARK BEGIN
##FUN-A50054 --Begin
#        WHEN "style_detail"
#           IF s_industry('slk') THEN
#              IF l_ac>0 THEN
#                 CALL s_detail(g_prog,g_rvu.rvu01,g_rvv[l_ac].rvv02,g_rvv[l_ac].rvv31,'Y')
#                 RETURNING g_rvv[l_ac].rvv31
#              END IF
#           END IF
##FUN-A50054 --End
#FUN-A60035 ---MARK END

         #No.FUN-A80026  --Begin
         WHEN "gen_ap"    #产生应付帐款
           IF cl_chk_act_auth() THEN                                                                                                
              IF g_rvu.rvu17 matches '[Ss]' THEN             #FUN-A60009 add
                 CALL cl_err('','apm-030',0)                 #FUN-A60009 add
              ELSE                                           #FUN-A60009 add
                 CALL t720_gen_ap(g_rvu.rvu01)
              END IF                                         #FUN-A60009 add
           END IF
         #No.FUN-A80026  --End  

        #FUN-A60009 add str -----------------------------
        #@WHEN "准"
          WHEN "agree"
               IF g_laststage = "Y" AND l_flowuser = "N" THEN       #最後一關並且沒有加簽人員
                  #CALL t720sub_y_upd(g_rvu.rvu01,g_argv1,g_argv2,g_argv3,g_chr,FALSE,'Y')    #MOD-C80049 mark
                  CALL t720sub_y_upd(g_rvu.rvu01,g_argv1,g_argv2,g_argv3,g_chr,FALSE,'Y','Y') #MOD-C80049 add
                  CALL t720_refresh() RETURNING g_rvu.*
                  CALL t720_show()
               ELSE
                  LET g_success = "Y"
                  IF NOT aws_efapp_formapproval() THEN    #執行EF簽核
                     LET g_success = "N"
                  END IF
               END IF
               IF g_success = 'Y' THEN
                  IF cl_confirm('aws-081') THEN           #詢問是否繼續下一筆資料的簽核
                     IF aws_efapp_getnextforminfo() THEN  #取得下一筆簽核單號
                        LET l_flowuser = 'N'
                        LET g_argv5 = aws_efapp_wsk(1)    #取得單號
                        IF NOT cl_null(g_argv5) THEN      #自動 query 帶出資料
                           CALL t720_q()
                          #傳入簽核模式時不應執行的 action 清單
                           CALL aws_efapp_flowaction("insert, modify, delete, detail, query, locale, void,undo_void, confirm, undo_confirm, carry, undo_carry, carry_delivery, gen_ap, transfer_to_report, price_change, gen_transfer_note, gen_mat_wtdw, maint_mat_wtdw, recall, allowance, easyflow_approval,barcode_gen,barcode_query,barcode_output")  #FUN-D20025 add undo_void #DEV-D30045 add barcode_gen,barcode_query,barcode_output
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
                 IF aws_efapp_formapproval() THEN                     #執行 EF 簽核
                    IF l_creator = "Y" THEN                           #當退回填表人時
                       LET g_rvu.rvu17 = 'R'                          #顯示狀態碼為 'R' 送簽退回
                       DISPLAY BY NAME g_rvu.rvu17
                    END IF

                    IF cl_confirm('aws-081') THEN                     #詢問是否繼續下一筆資料的簽
                      IF aws_efapp_getnextforminfo() THEN            #取得下一筆簽核單號
                         LET l_flowuser = 'N'
                         LET g_argv5 = aws_efapp_wsk(1)             #取得單號
                         IF NOT cl_null(g_argv5) THEN               #自動 query 帶出資料
                            CALL t720_q()
                           #傳入簽核模式時不應執行的 action 清單
                            CALL aws_efapp_flowaction("insert, modify, delete, detail, query, locale, void,undo_void, confirm, undo_confirm, carry, undo_carry, carry_delivery, gen_ap, transfer_to_report, price_change, gen_transfer_note, gen_mat_wtdw, maint_mat_wtdw, recall, allowance, easyflow_approval,barcode_gen,barcode_query,barcode_output")  #FUN-D20025 add undo_void #DEV-D30045 add barcode_gen,barcode_query,barcode_output
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
               IF aws_efapp_flowuser() THEN                           #選擇欲加簽人員
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
        #FUN-A60009 add end -------------------------------

        #DEV-D30045--add--begin
         WHEN "barcode_gen"     #條碼產生
             IF cl_chk_act_auth() THEN
                CALL t720sub_barcode_gen(g_rvu.rvu01,'Y')
             END IF

         WHEN "barcode_query"   #條碼查詢
             IF cl_chk_act_auth() THEN
                LET g_msg = "abaq100 '",g_rvu.rvu01,"' "
                CALL cl_cmdrun_wait(g_msg)
             END IF

         WHEN "barcode_output"  #條碼列印
             IF cl_chk_act_auth() THEN
                CALL t720_barcode_out()
             END IF
        #DEV-D30045--add--end
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t720_a()
 DEFINE li_result   LIKE type_file.num5     #No.FUN-550060  #No.FUN-680136 SMALLINT
 DEFINE l_azp02     LIKE azp_file.azp02     #NO.FUN-960130
 DEFINE l_rva08     LIKE rva_file.rva08     #CHI-A50012 add
 DEFINE l_rva21     LIKE rva_file.rva21     #CHI-A50012 add
 DEFINE l_rva100    LIKE rva_file.rva100    #CHI-A50012 add
 
    IF s_shut(0) THEN RETURN END IF
    IF g_rvu00 = 'A' THEN RETURN END IF #FUN-B40031
    #MESSAGE ""                    #FUN-A50001 mark
    CALL cl_msg("")                #FUN-A50001 add
    CLEAR FORM
    CALL g_rvv.clear()
    INITIALIZE g_rvu.* TO NULL
    INITIALIZE g_rvu_t.* TO NULL   #No.TQC-740163
    LET g_rvu_o.* = g_rvu.*
    LET g_rec_b  = 0  #FUN-810038
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_rvu.rvu03  = g_today
        LET g_rvu.rvu07  = g_user
        LET g_rvu.rvu06  = g_grup
        LET g_rvu.rvuacti = 'Y'   #MOD-910206
        IF NOT cl_null(g_argv3) THEN
           LET g_rvu.rvu08  = g_argv3
        ELSE
           LET g_rvu.rvu08  = 'REG'
        END IF
       #LET g_rvu.rvu10  = 'N'            #No.FUN-A40054
#       LET g_rvu.rvu10  = 'Y'            #No.FUN-A40054     #No.MOD-AC0403
        LET g_rvu.rvu10  = 'N'            #No.MOD-AC0403
        LET g_rvu.rvu20  = 'N'            #三角貿易拋轉否 no.4475
        LET g_rvu.rvuconf= 'N'            
        LET g_rvu.rvuuser= g_user         
        LET g_rvu.rvuoriu = g_user        #FUN-980030
        LET g_rvu.rvuorig = g_grup        #FUN-980030
        LET g_data_plant = g_plant        #FUN-980030
        LET g_rvu.rvugrup= g_grup
        LET g_rvu.rvucrat = g_today
        LET g_rvu.rvumksg = 'N'   
        LET g_rvu.rvu17  = '0'            #FUN-A60009 add
        LET g_rvu.rvu900 = '0'   
        LET g_rvu.rvuplant = g_plant
        LET g_rvu.rvulegal = g_legal
        LET g_rvu.rvu21 = '1'    
        LET g_rvu.rvupos = '1' #NO.FUN-B50042  
        LET g_rvu.rvucont = '' 
        LET g_rvu.rvu27 = '1'  #TQC-B60065
        SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rvu.rvuplant
        DISPLAY l_azp02 TO FORMONLY.rvuplant_desc    
       #LET g_rvu.rvumksg = 'Y'           #FUN-A60009 mark 
 
       #LET g_rvu.rvu116 = '2'            #FUN-940083--add---  #FUN-BA0013 mark
       #FUN-BA0013 add str -----
        IF g_argv1 = '3' AND g_argv3='SUB' THEN
           LET g_rvu.rvu116 = '3'
        ELSE
           LET g_rvu.rvu116 = '2'
        END IF
       #FUN-BA0013 add end -----
       
        BEGIN WORK #No:7857
        CALL t720_i("a")                        #輸入單頭
        IF INT_FLAG THEN
           INITIALIZE g_rvu.* TO NULL
           LET INT_FLAG=0 CALL cl_err('',9001,0) ROLLBACK WORK EXIT WHILE
        END IF
        IF g_rvu.rvu01 IS NULL THEN CONTINUE WHILE END IF
 
        CALL s_auto_assign_no("apm",g_rvu.rvu01,g_rvu.rvu03,g_chr,"rvu_file","rvu01","","","")
             RETURNING li_result,g_rvu.rvu01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_rvu.rvu01

        #CHI-A50012 add --start--
        IF NOT cl_null(g_rvu.rvu02) THEN
           LET l_rva21 =''
           SELECT rva08,rva21,rva100 INTO l_rva08,l_rva21,l_rva100 FROM rva_file
              WHERE rva01 = g_rvu.rvu02
           IF NOT cl_null(l_rva08) OR NOT cl_null(l_rva21) OR NOT cl_null(l_rva100) THEN  
              LET g_rvu.rvu101= l_rva08 
              LET g_rvu.rvu102= l_rva21    
              LET g_rvu.rvu100= l_rva100  
           END IF
        END IF
        #CHI-A50012 add --end--

        INSERT INTO rvu_file VALUES (g_rvu.*)
        IF STATUS THEN
            ROLLBACK WORK #No:7857
            CALL cl_err3("ins","rvu_file",g_rvu.rvu01,"",STATUS,"","",1)  #No.FUN-660129
            CONTINUE WHILE
        ELSE
            COMMIT WORK #No:7857
            CALL cl_flow_notify(g_rvu.rvu01,'I')
        END IF
        SELECT rvu01 INTO g_rvu.rvu01 FROM rvu_file WHERE rvu01 = g_rvu.rvu01
        LET g_rvu_t.* = g_rvu.*
        LET g_rvu01_t = g_rvu.rvu01
        CALL g_rvv.clear()
 
        LET g_rec_b = 0  #MOD-690013 add
        IF g_rvu.rvu00='1' AND NOT cl_null(g_rvu.rvu02) THEN     #自動產生單身
           CALL t720_g_b()
        END IF
 
        CALL t720_b()                           #輸入單身
        IF NOT cl_null(g_rvu.rvu01) AND g_smy.smyprint='Y' THEN  #是否馬上列印
           IF cl_confirm('mfg9392') THEN CALL t720_out() END IF
        END IF
       #IF NOT cl_null(g_rvu.rvu01) AND g_smy.smydmy4='Y' THEN  #確認  #FUN-A60009 mark 
       #   CALL t720sub_y(g_rvu.rvu01,g_argv1,g_argv2,g_argv3,g_chr,FALSE,'Y') #FUN-A10130  #FUN-A60009 mark 
       #FUN-A60009 add str ---------------
        IF NOT cl_null(g_rvu.rvu01) AND g_smy.smydmy4='Y' AND g_smy.smyapr<>'Y' THEN
           LET g_action_choice = "insert"
           CALL t720sub_y_chk(g_rvu.rvu01,g_argv1,g_argv2,g_argv3,g_chr,'Y')
           IF g_success = "Y" THEN
              #CALL t720sub_y_upd(g_rvu.rvu01,g_argv1,g_argv2,g_argv3,g_chr,FALSE,'Y')    #MOD-C80049 mark
              CALL t720sub_y_upd(g_rvu.rvu01,g_argv1,g_argv2,g_argv3,g_chr,FALSE,'Y','Y') #MOD-C80049 add
           END IF
       #FUN-A60009 add end ---------------
           CALL t720_refresh() RETURNING g_rvu.*  #FUN-A10130
           CALL t720_show()   #FUN-A10130
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t720_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_rvu.rvu01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF

    SELECT * INTO g_rvu.* FROM rvu_file
     WHERE rvu01=g_rvu.rvu01
    IF g_rvu.rvuconf = 'Y' THEN CALL cl_err('','apm-242',0) RETURN END IF
    IF g_rvu.rvuconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF

   #FUN-A60009  add str ---
    IF g_rvu.rvu17 matches '[Ss]' THEN
       CALL cl_err('','apm-030',0)
       RETURN
    END IF
   #FUN-A60009  add end ---

    #MESSAGE ""                    #FUN-A50001 mark
    CALL cl_msg("")                #FUN-A50001 add
    CALL cl_opmsg('u')
    LET g_rvu01_t = g_rvu.rvu01
    LET g_rvu03_t = g_rvu.rvu03
    LET g_rvu_o.* = g_rvu.*
    BEGIN WORK
 
    OPEN t720_cl USING g_rvu.rvu01
    IF STATUS THEN
       CALL cl_err("OPEN t720_cl:", STATUS, 1)
       CLOSE t720_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t720_cl INTO g_rvu.*          #鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_rvu.rvu01,SQLCA.sqlcode,0)      #資料被他人LOCK
       CLOSE t720_cl ROLLBACK WORK RETURN
    END IF
    CALL t720_show()
    WHILE TRUE
        LET g_rvu.rvumodu=g_user
        LET g_rvu.rvudate=g_today
        LET g_rvu.rvupos='1' #No.FUN-960130 #NO.FUN-B50042
        CALL t720_i("u")                             #欄位更改
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           LET g_rvu.*=g_rvu_t.*
           CALL t720_show()
           CALL cl_err('','9001',0)
           EXIT WHILE
        END IF
        #IF g_rvu.rvu01 != g_rvu01_t THEN   #MOD-B40048
        IF g_rvu.rvu01 != g_rvu01_t AND g_rec_b > 0 THEN   #MOD-B40048
           UPDATE rvv_file SET rvv01=g_rvu.rvu01 WHERE rvv01=g_rvu01_t
           IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
              CALL cl_err3("upd","rvv_file",g_rvu01_t,"",SQLCA.sqlcode,"","update rvv",1)  #No.FUN-660129
              ROLLBACK WORK CONTINUE WHILE
           END IF
        END IF
        #-->如有變動必須修改否則tlf/rvv09 的資料會不正確
        #IF g_rvu.rvu03 != g_rvu03_t THEN   #MOD-B40048 
        IF g_rvu.rvu03 != g_rvu03_t AND g_rec_b > 0 THEN   #MOD-B40048 
           UPDATE rvv_file SET rvv09=g_rvu.rvu03 WHERE rvv01=g_rvu.rvu01
           IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
              CALL cl_err3("upd","rvv_file",g_rvu.rvu01,"",SQLCA.sqlcode,"","update rvv09",1)  #No.FUN-660129
              ROLLBACK WORK CONTINUE WHILE
           END IF
        END IF

        LET g_rvu.rvu17 = '0'             #修改後需重新送簽  #FUN-A60009 add

        UPDATE rvu_file SET * = g_rvu.* WHERE rvu01 = g_rvu.rvu01
        IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err3("upd","rvu_file",g_rvu.rvu01,"",SQLCA.sqlcode,"","update rvu",1)  #No.FUN-660129
           ROLLBACK WORK       #NO.TQC-930155 add
           CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t720_cl
    DISPLAY BY NAME g_rvu.rvu17           #FUN-A60009 add
    CALL t720_pic() #FUN-C30140 add
    COMMIT WORK
    CALL cl_flow_notify(g_rvu.rvu01,'U')
END FUNCTION
 
FUNCTION t720_t()
  DEFINE l_rva00         LIKE rva_file.rva00
  DEFINE l_cnt           LIKE type_file.num5            #MOD-AB0037
 
  IF cl_null(g_rvu.rvu01) THEN RETURN END IF
 #IF g_rvu00 = 'A' THEN RETURN END IF #FUN-B40031 #FUN-BB0044 Mark
  BEGIN WORK
 
  OPEN t720_cl USING g_rvu.rvu01
  IF STATUS THEN
     CALL cl_err("OPEN t720_cl:", STATUS, 1)
     CLOSE t720_cl
     ROLLBACK WORK
     RETURN
  END IF
  FETCH t720_cl INTO g_rvu.*          #鎖住將被更改或取消的資料
  IF SQLCA.sqlcode THEN
     CALL cl_err(g_rvu.rvu01,SQLCA.sqlcode,0)      #資料被他人LOCK
     ROLLBACK WORK
     CLOSE t720_cl RETURN
  END IF
  IF g_rvu.rvu00 = '1' THEN RETURN END IF
  IF g_rvu.rvu00 = '2' THEN RETURN END IF   #TQC-6A0074 add
   IF g_rvu.rvuconf = 'N' THEN CALL cl_err('','mfg3550',0) RETURN END IF #此筆單據尚未確認 #MOD-530020
  IF g_rvu.rvuconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
  
  INPUT BY NAME g_rvu.rvu10,g_rvu.rvu11,g_rvu.rvu12,g_rvu.rvu15
                WITHOUT DEFAULTS
     AFTER FIELD rvu10
        #No.MOD-AC0403 -BEGIN--------
        IF g_rvu.rvu116 MATCHES "[123]" AND g_rvu.rvu10 = 'N' THEN       #TQC-B70073  add 2             
           CALL cl_err('','apm-436',0)
           NEXT FIELD rvu10
        END IF
        #No.MOD-AC0403 -END-------
        IF g_rvu.rvu11 IS NULL THEN     #No.MOD-520104
          LET g_rvu.rvu11=TODAY
          IF g_rvu.rvu27 NOT MATCHES "[234]" THEN  #TQC-BB0131 add 
            IF NOT cl_null(g_rvu.rvu02) THEN
               SELECT rva00 INTO l_rva00 FROM rva_file WHERE rva01 = g_rvu.rvu02
               IF l_rva00 = '2' THEN
                  SELECT rva116 INTO g_rvu.rvu12 FROM rva_file WHERE rva01 = g_rvu.rvu02
               ELSE
                  SELECT pmm43 INTO g_rvu.rvu12
                      FROM rva_file,pmm_file
                     WHERE rva01=g_rvu.rvu02 AND rva02=pmm01 AND pmm18 <> 'X'
               END IF
            ELSE
               SELECT pmm43 INTO g_rvu.rvu12
                   FROM rva_file,pmm_file
                  WHERE rva01=g_rvu.rvu02 AND rva02=pmm01 AND pmm18 <> 'X'
            END IF
            IF g_rvu.rvu12 IS NULL THEN LET g_rvu.rvu12=0 END IF
            SELECT SUM(rvv39) INTO g_rvu.rvu13 FROM rvv_file
                 WHERE rvv01=g_rvu.rvu01
            IF g_rvu.rvu13 IS NULL THEN LET g_rvu.rvu13=0 END IF
            LET g_rvu.rvu14=g_rvu.rvu13*g_rvu.rvu12/100
            #no.A010 依本幣取位
            CALL t720_get_azi()                               #MOD-CA0007 add
            LET g_rvu.rvu13 = cl_digcut(g_rvu.rvu13,t_azi04)  #MOD-CA0007 add
            LET g_rvu.rvu14 = cl_digcut(g_rvu.rvu14,t_azi04)  #MOD-CA0007 add
            #LET g_rvu.rvu13 = cl_digcut(g_rvu.rvu13,g_azi04) #MOD-CA0007 mark
            #LET g_rvu.rvu14 = cl_digcut(g_rvu.rvu14,g_azi04) #MOD-CA0007 mark
            IF cl_null(g_rvu.rvu27) OR g_rvu.rvu27 = '1' THEN   #TQC-BB0131 add
               SELECT MAX(rvb22) INTO g_rvu.rvu15 FROM rvb_file
                    WHERE rvb01=g_rvu.rvu02
            END IF                                              #TQC-BB0131 add
            DISPLAY BY NAME g_rvu.rvu11,g_rvu.rvu12,g_rvu.rvu15,
                            g_rvu.rvu13,g_rvu.rvu14
          END IF  #TQC-BB0131 add
        END IF
        IF g_rvu.rvu27 NOT MATCHES "[234]" THEN  #TQC-BB0131 add 
            IF cl_null(g_rvu.rvu10) OR cl_null(g_rvu.rvu15) THEN    #No.MOD-520104
              LET g_rvu.rvu11=NULL
              LET g_rvu.rvu12=NULL
              LET g_rvu.rvu13=NULL
              LET g_rvu.rvu14=NULL
              DISPLAY BY NAME g_rvu.rvu11,g_rvu.rvu12,g_rvu.rvu13,g_rvu.rvu14
           END IF
        END IF      #TQC-BB0131 add
       #TQC-BB0131 add START
        IF g_rvu.rvu10 = 'N' THEN
           LET g_rvu.rvu12=NULL
           LET g_rvu.rvu13=NULL
           LET g_rvu.rvu14=NULL
        END IF
       #TQC-BB0131 add END


#MOD-AC0414 -------------------------Begin--------------------------------
#     AFTER FIELD rvu12
#        IF NOT cl_null(g_rvu.rvu12) AND g_rvu.rvu12 >0 THEN     #FUN-9A0068
#           LET g_rvu.rvu14=g_rvu.rvu13*g_rvu.rvu12/100
#           #no.A010本幣取位
#           LET g_rvu.rvu14=cl_digcut(g_rvu.rvu14,g_azi04)
#           DISPLAY BY NAME g_rvu.rvu14
#        ELSE
#           CALL  cl_err(g_rvu.rvu12,'mfg3291',1)
#           NEXT FIELD rvu12
#        END IF
#MOD-AC0414 ------------------------End-----------------------------------

    #-MOD-AB0037-add-
     AFTER FIELD rvu15
        IF NOT cl_null(g_rvu.rvu15) THEN   #TQC-AB0083
           LET l_cnt = 0
           SELECT COUNT(*) INTO l_cnt
             FROM apa_file,apk_file
            WHERE apa01=apk01
              AND apk03=g_rvu.rvu15
              AND apa00 MATCHES '1*'
              AND apa41='Y'            #已確認
           IF l_cnt = 0 THEN
             #判斷輸入的發票號碼是否存在amdi100,且已確認
              SELECT COUNT(*) INTO l_cnt FROM amd_file
               WHERE amd03=g_rvu.rvu15
                 AND amd30='Y'        #已確認
              IF l_cnt = 0 THEN
                 CALL cl_err(g_rvu.rvu15,'aap-151',0)
                 NEXT FIELD rvu15 
              END IF   
           END IF
        #TQC-BB0131 add START
           IF g_rvu.rvu27 NOT MATCHES "[234]" THEN  #TQC-D30023 add NOT
              SELECT rvu12 INTO g_rvu.rvu12 FROM rvu_file
                  WHERE rvu01 = g_rvu.rvu01
              IF cl_null(g_rvu.rvu12) THEN
                 LET g_rvu.rvu12 = 0
              END IF
              SELECT SUM(rvv39) INTO g_rvu.rvu13 FROM rvv_file
                   WHERE rvv01=g_rvu.rvu01
              IF g_rvu.rvu13 IS NULL THEN LET g_rvu.rvu13=0 END IF
              LET g_rvu.rvu14 = g_rvu.rvu13*g_rvu.rvu12/100
              CALL t720_get_azi()                               #MOD-CA0007 add
              LET g_rvu.rvu13 = cl_digcut(g_rvu.rvu13,t_azi04)  #MOD-CA0007 add
              LET g_rvu.rvu14 = cl_digcut(g_rvu.rvu14,t_azi04)  #MOD-CA0007 add
              #LET g_rvu.rvu13 = cl_digcut(g_rvu.rvu13,g_azi04) #MOD-CA0007 mark
              #LET g_rvu.rvu14 = cl_digcut(g_rvu.rvu14,g_azi04) #MOD-CA0007 mark
              DISPLAY BY NAME g_rvu.rvu12,g_rvu.rvu13,g_rvu.rvu14
           END IF
        #TQC-BB0131 add END
        END IF                             #TQC-AB0083
    #-MOD-AB0037-end-

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
     LET g_rvu.*=g_rvu_t.*
     CALL t720_show()
     LET INT_FLAG=0
     ROLLBACK WORK
     RETURN
  END IF
  BEGIN WORK
  LET g_success='Y'
  UPDATE rvu_file SET
         rvu10=g_rvu.rvu10,
         rvu11=g_rvu.rvu11,
         rvu12=g_rvu.rvu12,
         rvu13=g_rvu.rvu13,
         rvu14=g_rvu.rvu14,
         rvu15=g_rvu.rvu15
       WHERE rvu01=g_rvu.rvu01
  IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
     CALL cl_err3("upd","rvu_file",g_rvu.rvu01,"",STATUS,"","upd rvu",1)  #No.FUN-660129
     LET g_success = 'N'
  END IF
  IF g_success = 'Y' THEN
     COMMIT WORK
  ELSE
     ROLLBACK WORK
  END IF
  CLOSE t720_cl
END FUNCTION
 
FUNCTION t720_k()
  IF cl_null(g_rvu.rvu01) THEN RETURN END IF
  IF g_rvu.rvuconf = 'N' THEN CALL cl_err('','anm-960',0) RETURN END IF
  IF g_rvu.rvuconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
  INPUT BY NAME g_rvu.rvu09 WITHOUT DEFAULTS
 
      AFTER FIELD rvu09
          IF g_rvu.rvu09<g_rvu.rvu03 THEN NEXT FIELD rvu09 END IF
      AFTER INPUT
          IF INT_FLAG THEN
             EXIT INPUT
          END IF
          BEGIN WORK
            UPDATE rvu_file SET rvu09=g_rvu.rvu09
             WHERE rvu01=g_rvu.rvu01 AND rvu00=g_rvu.rvu00
            IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
               ROLLBACK WORK
            ELSE
               COMMIT WORK
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
END FUNCTION
 
FUNCTION t720_i(p_cmd)
  DEFINE p_cmd           LIKE type_file.chr1                  #a:輸入 u:更改  #No.FUN-680136 VARCHAR(1)
  DEFINE l_rva24         LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
  DEFINE l_t             LIKE oay_file.oayslip  #No.FUN-680136 VARCHAR(5)        #No.FUN-550060
  DEFINE l_n             LIKE type_file.num5    #No.FUN-680136 SMALLINT
  DEFINE l_flag          LIKE type_file.chr1    #判斷必要欄位是否有輸入  #No.FUN-680136 VARCHAR(1)
  DEFINE l_smy57         LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
  DEFINE l_rva06         LIKE rva_file.rva06,
         l_rvb39         LIKE rvb_file.rvb39,
         l_rvb40         LIKE rvb_file.rvb40
DEFINE li_result         LIKE type_file.num5    #No.FUN-550060  #No.FUN-680136 SMALLINT
DEFINE l_gem02           LIKE gem_file.gem02    #MOD-640260
DEFINE l_cnt             LIKE type_file.num5    #NO.FUN-670007  #No.FUN-680136 SMALLINT
DEFINE l_pma02           LIKE pma_file.pma02    #NO.FUN-940083
DEFINE l_pnz02           LIKE pnz_file.pnz02    #NO.FUN-940083
DEFINE l_azp02           LIKE azp_file.azp02    #NO.FUN-960130
DEFINE l_gen02           LIKE gen_file.gen02    #NO.FUN-960130
DEFINE l_slip            LIKE smy_file.smyslip  #No.FUN-980038
DEFINE l_rvu08           LIKE rvu_file.rvu08    #No.FUN-980038
DEFINE l_rva00           LIKE rva_file.rva00    #No.FUN-9A0068
DEFINE l_smy73           LIKE smy_file.smy73    #TQC-AC0293
DEFINE l_pmcacti         LIKE pmc_file.pmcacti  #MOD-C60054 add
DEFINE l_cnt1            LIKE type_file.num5    #FUN-C80045 add 
  DISPLAY BY NAME g_rvu.rvu21,g_rvu.rvu22,g_rvu.rvu23,g_rvu.rvucond,g_rvu.rvucont,  #FUN-960130
                  g_rvu.rvuconu,g_rvu.rvumksg,g_rvu.rvu17,                          #FUN-A60009 add:rvu17
                  g_rvu.rvu900,g_rvu.rvuplant,
                  g_rvu.rvucrat,g_rvu.rvuoriu,g_rvu.rvuorig             #TQC-A30041 ADD
  IF g_azw.azw04 = '2' THEN                                                                                                       
     LET l_azp02 = ''                                                                                                             
     SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rvu.rvuplant                                                           
     DISPLAY BY NAME g_rvu.rvu900,g_rvu.rvuplant,g_rvu.rvu22,g_rvu.rvu23,g_rvu.rvuconu  #FUN-960130
     DISPLAY l_azp02 TO FORMONLY.rvuplant_desc                                                                                      
     LET l_azp02 = ''                                                                                                             
     SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rvu.rvu22                                                            
                                                                                                                                   
     DISPLAY l_azp02 TO FORMONLY.rvu22_desc                                                                                       
     SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = g_rvu.rvu23                                                            
     DISPLAY l_gem02 TO FORMONLY.rvu23_desc                                                                                       
     SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_rvu.rvuconu                                                          
     DISPLAY l_gen02 TO FORMONLY.rvuconu_desc                                                                                     
  END IF                                                                                                                          
  CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
#TQC-AB0412 -----------------------------------Begin------------------------------------------
#  INPUT BY NAME g_rvu.rvuoriu,g_rvu.rvuorig,
#      #g_rvu.rvu00,g_rvu.rvu02,g_rvu.rvu03,g_rvu.rvu01,g_rvu.rvu04,g_rvu.rvu05,               #FUN-940083
#      g_rvu.rvu00,g_rvu.rvu116,g_rvu.rvu02,g_rvu.rvu03,g_rvu.rvu01,g_rvu.rvu04,g_rvu.rvu05,   #FUN-940083
#      g_rvu.rvu16,                #FUN-930062  
#      g_rvu.rvu08,g_rvu.rvu07,g_rvu.rvu06,g_rvu.rvu20,g_rvu.rvu99,
#      g_rvu.rvu10,g_rvu.rvu11,g_rvu.rvu15,g_rvu.rvu13,g_rvu.rvu14,g_rvu.rvu12,
#      g_rvu.rvuconf,
#      g_rvu.rvu21,g_rvu.rvumksg,      #NO.FUN-960130
#      g_rvu.rvu111,g_rvu.rvu112,g_rvu.rvu115,g_rvu.rvu113,g_rvu.rvu114,     #FUN-940083
#      g_rvu.rvuuser,g_rvu.rvugrup,g_rvu.rvumodu,g_rvu.rvudate,
#      g_rvu.rvuud01,g_rvu.rvuud02,g_rvu.rvuud03,g_rvu.rvuud04,
#      g_rvu.rvuud05,g_rvu.rvuud06,g_rvu.rvuud07,g_rvu.rvuud08,
#      g_rvu.rvuud09,g_rvu.rvuud10,g_rvu.rvuud11,g_rvu.rvuud12,
#      g_rvu.rvuud13,g_rvu.rvuud14,g_rvu.rvuud15 
#      WITHOUT DEFAULTS
  INPUT BY NAME g_rvu.rvu00,
                g_rvu.rvu116,g_rvu.rvu02,g_rvu.rvu03,g_rvu.rvu01,g_rvu.rvu04,g_rvu.rvu05,g_rvu.rvu16,
                g_rvu.rvu08, g_rvu.rvu06,g_rvu.rvu07,g_rvu.rvu20,g_rvu.rvu99,g_rvu.rvuconf,
                g_rvu.rvu10, g_rvu.rvu11,g_rvu.rvu15,g_rvu.rvu13,g_rvu.rvu14,g_rvu.rvu21,
                g_rvu.rvumksg, g_rvu.rvu17,                                       #FUN-A60009 add
                g_rvu.rvu111,g_rvu.rvu112,g_rvu.rvu115,g_rvu.rvu113,g_rvu.rvu12,
                g_rvu.rvu114, g_rvu.rvuuser,g_rvu.rvugrup,g_rvu.rvuoriu,g_rvu.rvuorig,g_rvu.rvumodu,
                g_rvu.rvudate,
                g_rvu.rvuud01,g_rvu.rvuud02,g_rvu.rvuud03,g_rvu.rvuud04,
                g_rvu.rvuud05,g_rvu.rvuud06,g_rvu.rvuud07,g_rvu.rvuud08,
                g_rvu.rvuud09,g_rvu.rvuud10,g_rvu.rvuud11,g_rvu.rvuud12,
                g_rvu.rvuud13,g_rvu.rvuud14,g_rvu.rvuud15
                WITHOUT DEFAULTS
#TQC-AB0412 --------------------------------End---------------------------------------------
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t720_set_entry(p_cmd)
            CALL t720_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
          CALL cl_set_docno_format("rvu01")
          CALL cl_set_docno_format("rvu02")
 
        IF p_cmd='a' THEN  #MOD-740329
          IF NOT cl_null(g_argv1) THEN
             LET g_rvu.rvu00=g_argv1
             DISPLAY BY NAME g_rvu.rvu00
             CASE
                WHEN g_rvu.rvu00='1'
                    CALL cl_getmsg('apm-243',g_lang) RETURNING g_buf
                WHEN g_rvu.rvu00='2'
                    CALL cl_getmsg('apm-244',g_lang) RETURNING g_buf
                WHEN g_rvu.rvu00='3'
                    CALL cl_getmsg('apm-245',g_lang) RETURNING g_buf
             END CASE
             DISPLAY g_buf TO t_1
          #   NEXT FIELD rvu02  #TQC-B70073 mark
             NEXT FIELD rvu116  #TQC-B70073
          END IF
        END IF
 
        AFTER FIELD rvu00
          IF NOT cl_null(g_rvu.rvu00) THEN
              IF g_rvu.rvu00 NOT MATCHES "[123]" THEN NEXT FIELD rvu00 END IF
              CASE
                 WHEN g_rvu.rvu00='1'
                     CALL cl_getmsg('apm-243',g_lang) RETURNING g_buf
                 WHEN g_rvu.rvu00='2'
                     CALL cl_getmsg('apm-244',g_lang) RETURNING g_buf
                 WHEN g_rvu.rvu00='3'
                     CALL cl_getmsg('apm-245',g_lang) RETURNING g_buf
              END CASE
              DISPLAY g_buf TO t_1
          END IF
        
        AFTER FIELD rvu116
           IF NOT cl_null(g_rvu.rvu116) THEN
              IF g_rvu.rvu116 NOT MATCHES "[123]" THEN NEXT FIELD rvu116 END IF
             #No.FUN-A40054 -BEGIN-----
             #IF g_rvu.rvu116 MATCHES "[13]" THEN
             #   LET g_rvu.rvu10 = 'Y'
             #ELSE
             #   LET g_rvu.rvu10 = 'N'
             #END IF 
#             LET g_rvu.rvu10 = 'Y'                   #No.MOD-AC0403
             #TQC-B70073  --begin--mark
             #No.MOD-AC0403-BEGIN------
             # IF g_rvu.rvu116 = '2' THEN
             #    LET g_rvu.rvu10 = 'N'
             # ELSE
             #    LET g_rvu.rvu10 = 'Y'
             # END IF
             #No.MOD-AC0403-END--------
             #TQC-B70073 --end--mark
             #TQC-B70073 --begin
             IF g_rvu.rvu116 MATCHES "[123]" AND g_rvu.rvu00 = '3' THEN
                LET g_rvu.rvu10 = 'Y'
             ELSE
                LET g_rvu.rvu10 = 'N'
             END IF
             #TQC-B70073 --end
             #MOD-C30025 add begin by suncx 120305--------------------
             LET l_n = 0
             SELECT COUNT(*) INTO l_n FROM rvv_file
              WHERE rvv01 = g_rvu.rvu01
             IF l_n AND g_rvu.rvu116 <> g_rvu_t.rvu116 THEN
                LET g_rvu.rvu116 = g_rvu_t.rvu116
                CALL cl_err('','apm1068',0)
                NEXT FIELD rvu116
             END IF
             #MOD-C30025 add -end- by suncx 120305--------------------
             #No.FUN-A40054 -END-------
              DISPLAY BY NAME g_rvu.rvu10
           END IF
        ON CHANGE rvu116
           IF NOT cl_null(g_rvu.rvu116) THEN
              IF g_rvu.rvu116 NOT MATCHES "[123]" THEN NEXT FIELD rvu116 END IF
             #No.FUN-A40054 -BEGIN-----
             #IF g_rvu.rvu116 MATCHES "[13]" THEN
             #   LET g_rvu.rvu10 = 'Y'
             #ELSE
             #   LET g_rvu.rvu10 = 'N'
             #END IF 
             #No.FUN-A40054 -END-------
              DISPLAY BY NAME g_rvu.rvu10
           END IF
 
        BEFORE FIELD rvu02         #驗收單號
          CALL t720_set_entry(p_cmd)
 #........如單身已有資料則不可修正驗收單號
          IF p_cmd = 'u' AND g_chkey = 'N' THEN
             SELECT COUNT(*) INTO l_n FROM rvv_file
              WHERE rvv01=g_rvu.rvu01 AND rvv03=g_rvu.rvu00
             IF l_n > 0 THEN NEXT FIELD NEXT END IF
          END IF
          IF NOT cl_null(g_argv2) THEN LET g_rvu.rvu02=g_argv2 END IF
          DISPLAY BY NAME g_rvu.rvu02
          LET g_rva06=''
 
        AFTER FIELD rvu02         #驗收單號
           ###### 01/11/19 Tommy 三角倉退不允許不輸入收貨單號
           IF g_azw.azw04 = '2' THEN
              IF (g_rvu.rvu00 = '1' OR g_rvu.rvu00= '2') 
                 AND cl_null(g_rvu.rvu02) THEN
                 NEXT FIELD rvu02
              END IF
           ELSE
              IF (g_rvu.rvu00 = '1' OR g_rvu.rvu00='2' OR (g_rvu.rvu00='3' AND
                  g_argv3 = 'TAP'))
                  AND cl_null(g_rvu.rvu02) THEN
                  NEXT FIELD rvu02
              END IF
           END IF
           IF NOT cl_null(g_rvu.rvu02) THEN
              CALL t720_rvu02()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_rvu.rvu02,g_errno,0) NEXT FIELD rvu02
              END IF
              LET l_gem02 = ''
              LET l_azp02 = ''
 
              SELECT rva00,rva29,rva30,rva31 INTO l_rva00,g_rvu.rvu21,g_rvu.rvu22,g_rvu.rvu23  #TQC-9B0161 add rva00
                  FROM rva_file WHERE rva01 = g_rvu.rvu02
              DISPLAY BY NAME g_rvu.rvu21,g_rvu.rvu22,g_rvu.rvu23
              SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rvu.rvu22
              DISPLAY l_azp02 TO FORMONLY.rvu22_desc
              SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = g_rvu.rvu23
              DISPLAY l_gem02 TO FORMONLY.rvu23_desc
              CALL cl_set_comp_entry("rvu21",FALSE)
            # CALL cl_set_comp_entry("rvu115,rvu12",FALSE)     #FUN-9A0068      #MOD-AC0414
              CALL cl_set_comp_entry("rvu12",FALSE)            #MOD-AC0414 
              IF g_rvu.rvu00 = '3' AND l_rva00 !='2' THEN
                 CALL cl_set_comp_entry("rvu113,rvu114",FALSE)
              ELSE
                 CALL cl_set_comp_entry("rvu113,rvu114",TRUE)
              END IF
           ELSE
              CALL cl_set_comp_entry("rvu21",TRUE)
           END IF
           LET l_t1 = s_get_doc_no(g_rvu.rvu02)
           IF (g_sma.sma120 = 'Y') AND (g_sma.sma907 = 'Y') THEN
              #讀取smy_file中指定作業對應的默認屬性群組
              SELECT smy62 INTO lg_smy621 FROM smy_file WHERE smyslip = l_t1
              IF NOT cl_null(g_rvu.rvu01) THEN
                 IF lg_smy621 <> lg_smy62 THEN
                    CALL cl_err(g_rvu.rvu02,'apm1006',0)
                    NEXT FIELD rvu02
                 END IF
                 IF (cl_null(lg_smy621) AND NOT cl_null(lg_smy62)) OR
                    (NOT cl_null(lg_smy621) AND cl_null(lg_smy62)) THEN
                    CALL cl_err(g_rvu.rvu02,'apm1006',0)
                    NEXT FIELD rvu02
                 END IF
              END IF
           ELSE
              LET lg_smy621 = ''
           END IF
           IF g_rvu.rvu00 ='3' AND NOT cl_null(g_rvu.rvu02) THEN     #FUN-9A0068
              SELECT rva00 INTO l_rva00 FROM rva_file WHERE rva01 = g_rvu.rvu02  #FUN-9A0068
              IF l_rva00 = '2' THEN                                              #FUN-9A0068
                 SELECT rva111,rva112,rva113,rva115
                    INTO g_rvu.rvu111,g_rvu.rvu112,g_rvu.rvu113,g_rvu.rvu115
                   FROM rva_file WHERE rva01 = g_rvu.rvu02
                 IF SQLCA.SQLCODE THEN
                    CALL cl_err(g_rvu.rvu04,SQLCA.SQLCODE,0)
                    NEXT FIELD rvu02
                 END IF
                 SELECT pma02 INTO l_pma02 FROM pma_file WHERE pma01 = g_rvu.rvu111
                 SELECT pnz02 INTO l_pnz02 FROM pnz_file WHERE pnz01 = g_rvu.rvu112
                 SELECT gec04 INTO g_rvu.rvu12 FROM gec_file
                    WHERE gec01 = g_rvu.rvu115 AND gec011 = '1'
                 IF g_rvu.rvu113 = g_aza.aza17 THEN
                    LET g_rvu.rvu114 = 1
                 ELSE
                    CALL s_curr3(g_rvu.rvu113,g_rvu.rvu03,g_sma.sma904) 
                       RETURNING g_rvu.rvu114
                 END IF
                 DISPLAY BY NAME g_rvu.rvu111,g_rvu.rvu112,
                              g_rvu.rvu113,g_rvu.rvu115,
                               g_rvu.rvu114,g_rvu.rvu12
                 DISPLAY l_pma02 TO pma02
                 DISPLAY l_pnz02 TO pnz02
              END IF                                                  #FUN-9A0068
              #MOD-B30544 add begin------------------------
              CALL cl_set_comp_required('rvu111,rvu112,rvu113,rvu115',FALSE)
              #MOD-B30544 add end--------------------------
           ELSE
              #MOD-B30544 add begin------------------------
              CALL cl_set_comp_required('rvu111,rvu112,rvu113,rvu115',TRUE)

              IF l_rva00 = '2' THEN #MOD-CA0071 add 
                 IF NOT cl_null(g_rvu.rvu04) THEN
                    SELECT pmc17,pmc49,pmc22,pmc47
                        INTO g_rvu.rvu111,g_rvu.rvu112,g_rvu.rvu113,g_rvu.rvu115
                      FROM pmc_file WHERE pmc01 = g_rvu.rvu04
                    IF SQLCA.SQLCODE THEN
                       CALL cl_err(g_rvu.rvu04,SQLCA.SQLCODE,0)
                       NEXT FIELD rvu04
                    END IF
                    SELECT pma02 INTO l_pma02 FROM pma_file WHERE pma01 = g_rvu.rvu111
                    SELECT pnz02 INTO l_pnz02 FROM pnz_file WHERE pnz01 = g_rvu.rvu112
                    SELECT gec04 INTO g_rvu.rvu12 FROM gec_file
                        WHERE gec01 = g_rvu.rvu115 AND gec011 = '1'
                    IF g_rvu.rvu113 = g_aza.aza17 THEN
                       LET g_rvu.rvu114 = 1
                    ELSE
                       CALL s_curr3(g_rvu.rvu113,g_rvu.rvu03,g_sma.sma904)
                          RETURNING g_rvu.rvu114
                    END IF
                    DISPLAY BY NAME g_rvu.rvu111,g_rvu.rvu112,
                                    g_rvu.rvu113,g_rvu.rvu115,
                                    g_rvu.rvu114,g_rvu.rvu12
                    DISPLAY l_pma02 TO pma02
                    DISPLAY l_pnz02 TO pnz02
                 END IF
              END IF #MOD-CA0071 add
              #MOD-B30544 add end--------------------------
           END IF  
#CHI-D60028 mark begin----------
#           #TQC-D40092----add--str
#           #如果rvb39=Y，需做QC检验
#           IF NOT cl_null(g_rvu.rvu02) THEN
#             SELECT COUNT(*) INTO l_n FROM qcs_file
#              WHERE qcs01 = g_rvu.rvu02
#                AND qcs14 = 'Y'
#             IF l_n < 1 THEN
#                CALL cl_err('','aqc-532',1)
#                NEXT FIELD rvu02
#             END IF
#
#             LET l_n = 0
#             SELECT COUNT(*) INTO l_n FROM qco_file
#              WHERE qco01 = g_rvu.rvu02
#             IF cl_null(l_n) THEN
#                LET l_n = 0
#             END IF
#             IF l_n < 1 THEN
#                CALL cl_err('','aqc-532',1)
#                NEXT FIELD rvu02
#             END IF
#             LET l_n = 0
#             SELECT COUNT(*) INTO l_n FROM qcs_file,qco_file
#              WHERE qcs01 = qco01
#                AND qcs02 = qco02
#                AND qcs05 = qco05
#                AND qco11 > qco20
#                AND qcs01 = g_rvu.rvu02
#                AND qcs14 = 'Y'
#             IF cl_null(l_n) THEN LET l_n = 0 END IF
#             IF l_n < = 0 THEN
#                CALL cl_err('','aqc-100',1)
#                NEXT FIELD rvu02
#             END IF
#           END IF
#           #TQC-D40092----add--end
#CHI-D60028 mark end---------------

           CALL t720_set_no_entry(p_cmd)
 
        AFTER FIELD rvu03         #單據日期
           IF NOT cl_null(g_rvu.rvu03) THEN
               IF NOT cl_null(g_sma.sma53) AND g_rvu.rvu03 <= g_sma.sma53 THEN
                  CALL cl_err('','mfg9999',0) NEXT FIELD rvu03  #關帳日期
               END IF
               CALL s_yp(g_rvu.rvu03) RETURNING g_yy,g_mm
               IF (g_yy*12+g_mm)>(g_sma.sma51*12+g_sma.sma52)THEN #不可大於現行年月
                  CALL cl_err('','mfg6091',0) NEXT FIELD rvu03
               END IF
               SELECT rva06 INTO l_rva06 FROM rva_file
                WHERE rva01 = g_rvu.rvu02
               #no.7143 檢驗否相關資料改抓單身
               SELECT COUNT(*) INTO g_cnt FROM rvb_file
                WHERE rvb01 = g_rvu.rvu02 AND rvb39 = 'Y'    #No.TQC-920088 add
               IF g_cnt > 0 THEN  #表收貨單有須檢驗的料號
                  SELECT MAX(rvb40) INTO l_rvb40 FROM rvb_file
                   WHERE rvb01 = g_rvu.rvu02 AND rvb39 = 'Y'    #No.TQC-920088 add
                   IF g_rvu.rvu03 < l_rvb40 THEN
                       #異動日期必須大於檢驗日(rvb43)
                       CALL cl_err(l_rvb40,'apm-416',0)
                       NEXT FIELD rvu03
                   END IF
               ELSE
                   IF g_rvu.rvu03 < l_rva06 THEN
                       #異動日期必須大於收貨日(rva06)
                       CALL cl_err(l_rva06,'apm-417',0)
                       NEXT FIELD rvu03
                   END IF
               END IF
               IF g_prog[1,3] = 'aic' THEN
                  CASE WHEN g_rvu.rvu00 ='1' LET g_chr='C' #入庫
                       WHEN g_rvu.rvu00 ='2' LET g_chr='D' #驗退
                       WHEN g_rvu.rvu00 ='3' LET g_chr='D' #倉退
                  END CASE
               ELSE
                  CASE WHEN g_rvu.rvu00 ='1' LET g_chr='7' #入庫
                       WHEN g_rvu.rvu00 ='2' LET g_chr='4' #驗退
                       WHEN g_rvu.rvu00 ='3' LET g_chr='4' #倉退
                  END CASE
               END IF   #TQC-9B0191
               #流水號預設收貨單        #NO.3507
               IF g_rvu.rvu00 = '1' AND p_cmd = 'a' THEN
                  LET l_t=g_rvu.rvu02[1,g_doc_len]
                  SELECT smy52,smy57[3,3] INTO g_rvu.rvu01,l_smy57
                      FROM smy_file WHERE smyslip=l_t
                     IF l_smy57='Y' THEN
                        SELECT COUNT(*) INTO g_cnt FROM rvu_file
                         WHERE rvu01=g_rvu.rvu01
                        IF g_cnt > 0 OR (MONTH(g_rvu.rvu03) <> MONTH(g_rva06)
                           AND g_rva06 IS NOT NULL) THEN
                          CALL s_auto_assign_no("apm",g_rvu.rvu01,g_rvu.rvu03,g_chr,"","","","","")
                            RETURNING li_result,g_rvu.rvu01
                          IF (NOT li_result) THEN
                             LET g_rvu.rvu01 = g_rvu_t.rvu01
                             DISPLAY BY NAME g_rvu.rvu01
                             NEXT FIELD rvu01
                          END IF
                        END IF
                     ELSE
                         #NO.FUN-960130----BEGIN-----
                         IF g_azw.azw04 = '2' THEN
                            #FUN-C90050 mark begin---
                            #SELECT rye03 INTO g_rvu.rvu01 FROM rye_file 
                            #    WHERE rye01 = 'apm' AND rye02 = '7'
                            #IF SQLCA.SQLCODE =100 THEN
                            #   CALL cl_err('','apm-930',1)
                            #   RETURN
                            #END IF
                            #FUN-C90050 mark end-----

                            #FUN-C90050 add begin---
                            CALL s_get_defslip('apm','7',g_plant,'N') RETURNING g_rvu.rvu01  
                            IF cl_null(g_rvu.rvu01) THEN
                               CALL cl_err('','apm-930',1)
                               RETURN
                            END IF
                            #FUN-C90050 add end-----
                         END IF
                         #NO.FUN-960130------END------
                         CALL s_auto_assign_no("apm",g_rvu.rvu01,g_rvu.rvu03,g_chr,"","","","","")
                            RETURNING li_result,g_rvu.rvu01
                         IF (NOT li_result) THEN
                           LET g_rvu.rvu01 = g_rvu_t.rvu01
                           DISPLAY BY NAME g_rvu.rvu01
                           NEXT FIELD rvu01
                        END IF
                     END IF
                  DISPLAY BY NAME g_rvu.rvu01
               END IF
           END IF
        BEFORE FIELD rvu01
          CALL t720_set_entry(p_cmd)
 
        AFTER FIELD rvu01       #單據編號
          IF NOT cl_null(g_rvu.rvu01) AND (g_rvu.rvu01!=g_rvu_t.rvu01) OR cl_null(g_rvu_t.rvu01) THEN
               LET g_t1=g_rvu.rvu01[1,g_doc_len]
                 IF g_prog[1,3] = 'aic' THEN
                    CASE WHEN g_rvu.rvu00 ='1' LET g_chr='C' #入庫
                         WHEN g_rvu.rvu00 ='2' LET g_chr='D' #驗退
                         WHEN g_rvu.rvu00 ='3' LET g_chr='D' #倉退
                    END CASE
                 ELSE
                    CASE WHEN g_rvu.rvu00 ='1' LET g_chr='7' #入庫 
                        #WHEN g_rvu.rvu00 ='2' LET g_chr='4' #驗退
                         WHEN g_rvu.rvu00 ='2' LET g_chr='E' #驗退  #MOD-BA0177
                         WHEN g_rvu.rvu00 ='3' LET g_chr='4' #倉退
                    END CASE
                 END IF   #TQC-9B0191
              LET g_t1 = s_get_doc_no(g_rvu.rvu01)
              IF (g_sma.sma120 = 'Y') AND (g_sma.sma907 = 'Y') THEN
                 #讀取smy_file中指定作業對應的默認屬性群組
                 SELECT smy62 INTO lg_smy62 FROM smy_file WHERE smyslip = g_t1
                 IF NOT cl_null(g_rvu.rvu02) THEN
                    IF lg_smy621 <> lg_smy62 THEN
                       CALL cl_err(g_rvu.rvu01,'apm1006',0)
                       NEXT FIELD rvu01
                    END IF
                    IF (cl_null(lg_smy621) AND NOT cl_null(lg_smy62)) OR
                       (NOT cl_null(lg_smy621) AND cl_null(lg_smy62)) THEN
                       CALL cl_err(g_rvu.rvu01,'apm1006',0)
                       NEXT FIELD rvu01
                    END IF
                 END IF
                 #刷新界面顯示
                 CALL t720_refresh_detail()
              ELSE
                 LET lg_smy62 = ''
              END IF
              #FUN-C80045 add sta
              LET l_cnt1 = 0
              SELECT COUNT(*) INTO l_cnt1 FROM  rye_file WHERE rye04 = g_t1 AND ryeacti = 'Y' AND rye01 = 'apm'
              IF l_cnt1 > 0 THEN
                 CALL cl_err(g_t1,'apc1036',0)
                  NEXT FIELD rvu01
              END IF 
              #FUN-C80045 add    
             CALL s_check_no("apm",g_rvu.rvu01,g_rvu01_t,g_chr,"rvu_file","rvu01","")
                RETURNING li_result,g_rvu.rvu01
             DISPLAY BY NAME g_rvu.rvu01
             IF (NOT li_result) THEN
                 NEXT FIELD rvu01
             END IF
               IF cl_null(g_rvu01_t) THEN                                                                                           
                  CALL s_get_doc_no(g_rvu.rvu01) RETURNING l_slip                                                                   
                  SELECT smy72 INTO l_rvu08 FROM smy_file                                                                       
                   WHERE smyslip = l_slip                                                                                           
                  IF NOT cl_null(l_rvu08) THEN
                     LET g_rvu.rvu08 = l_rvu08
                     DISPLAY BY NAME g_rvu.rvu08
                  END IF
               END IF                                                                                                               
#FUN-D50103 ---------- add ------------ begin --------------- #检查单据形态
           CALL s_get_doc_no(g_rvu.rvu01) RETURNING l_slip
           SELECT smy72 INTO l_rvu08 FROM smy_file WHERE smyslip = l_slip
           IF NOT cl_null(l_rvu08) THEN
              CASE
                 WHEN g_argv3 !='SUB' AND g_argv3 !='TAP'
                    IF l_rvu08 <>'REG' AND l_rvu08 <> 'EXP' AND l_rvu08 <>'CAP' THEN
                       CALL cl_err(l_rvu08,'apm-157',0)
                       NEXT FIELD rvu01
                    END IF
                 WHEN g_argv3 = 'SUB'
                    IF l_rvu08 <> 'SUB' THEN
                       CALL cl_err(l_rvu08,'apm-157',0)
                       NEXT FIELD rvu01
                    END IF
                 WHEN g_argv3 = 'TAP'
                    IF l_rvu08 <> 'TAP' AND l_rvu08 <> 'TRI' THEN
                       CALL cl_err(l_rvu08,'apm-157',0)
                       NEXT FIELD rvu01
                    END IF
              END CASE
           END IF
#FUN-D50103 ---------- add ------------ end -----------------
 
              IF p_cmd = 'a' AND cl_null(g_rvu.rvu01[g_no_sp,g_no_ep]) AND g_smy.smyauno = 'N'
                 THEN NEXT FIELD rvu01
              END IF
              IF g_rvu.rvu01 != g_rvu_t.rvu01 OR cl_null(g_rvu_t.rvu01) THEN
                 SELECT COUNT(*) INTO g_cnt FROM rvu_file
                  WHERE rvu01=g_rvu.rvu01 AND rvu00=g_rvu.rvu00
                 IF g_cnt > 0 THEN   #資料重複
                    CALL cl_err(g_rvu.rvu01,-239,0)
                    LET g_rvu.rvu01 = g_rvu_t.rvu01
                    DISPLAY BY NAME g_rvu.rvu01
                    NEXT FIELD rvu01
                 END IF
              END IF

             #FUN-A60009 add str ---
              IF g_rvu_t.rvu01 IS NULL OR
                 (g_rvu.rvu01 != g_rvu_t.rvu01 ) THEN
                 LET g_rvu.rvumksg = g_smy.smyapr
                 LET g_rvu.rvu17 = '0'
                 DISPLAY BY NAME g_rvu.rvumksg   #簽核否
                 DISPLAY BY NAME g_rvu.rvu17     #簽核狀況
              END IF
             #FUN-A60009 add end ---
          ELSE
             IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN
                LET lg_smy62 = ''
                CALL t720_refresh_detail()
             END IF
          END IF
          CALL t720_set_no_entry(p_cmd)
 
         BEFORE FIELD rvu04
           CALL t720_set_entry(p_cmd)
 
         AFTER FIELD rvu04       #廠商編號
           IF NOT cl_null(g_rvu.rvu04) THEN
               IF NOT cl_null(g_rvu.rvu04) OR g_rvu.rvu04 != g_rvu_t.rvu04 THEN
                  #SELECT pmc03 INTO g_rvu.rvu05 FROM pmc_file                    #MOD-C60054 mark
                  SELECT pmc03,pmcacti INTO g_rvu.rvu05,l_pmcacti FROM pmc_file   #MOD-C60054 add
                   WHERE pmc01=g_rvu.rvu04
                  IF STATUS THEN
                     CALL cl_err3("sel","pmc_file",g_rvu.rvu04,"",STATUS,"","select pmc",1)  #No.FUN-660129
                     NEXT FIELD rvu04
                  END IF
                  #MOD-C60054 add start -----
                  IF g_rvu.rvu00 = '3' AND l_pmcacti = 'N' THEN
                     CALL cl_err('','9028',1)
                     NEXT FIELD rvu04
                  END IF
                  #MOD-C60054 add end   -----
                  IF NOT cl_null(g_rvu.rvu04) THEN
                     SELECT pmc17,pmc49,pmc22,pmc47
                         INTO g_rvu.rvu111,g_rvu.rvu112,g_rvu.rvu113,g_rvu.rvu115
                       FROM pmc_file WHERE pmc01 = g_rvu.rvu04
                     IF SQLCA.SQLCODE THEN
                        CALL cl_err(g_rvu.rvu04,SQLCA.SQLCODE,0)
                        NEXT FIELD rvu04
                     END IF
                     SELECT pma02 INTO l_pma02 FROM pma_file WHERE pma01 = g_rvu.rvu111
                     SELECT pnz02 INTO l_pnz02 FROM pnz_file WHERE pnz01 = g_rvu.rvu112
                     SELECT gec04 INTO g_rvu.rvu12 FROM gec_file
                         WHERE gec01 = g_rvu.rvu115 AND gec011 = '1'
                     IF g_rvu.rvu113 = g_aza.aza17 THEN
                        LET g_rvu.rvu114 = 1
                     ELSE
                        CALL s_curr3(g_rvu.rvu113,g_rvu.rvu03,g_sma.sma904) 
                           RETURNING g_rvu.rvu114
                     END IF
                     DISPLAY BY NAME g_rvu.rvu111,g_rvu.rvu112,
                                     g_rvu.rvu113,g_rvu.rvu115,
                                     g_rvu.rvu114,g_rvu.rvu12
                     DISPLAY l_pma02 TO pma02
                     DISPLAY l_pnz02 TO pnz02
                  END IF  
                  DISPLAY BY NAME g_rvu.rvu05
               END IF
           END IF
           CALL t720_set_no_entry(p_cmd)
 
         AFTER FIELD rvu16                                                                                                          
           IF NOT cl_null(g_rvu.rvu16) THEN                                                                                         
              SELECT COUNT(*) INTO g_cnt FROM sfp_file                                                                              
               WHERE sfp01 = g_rvu.rvu16                                                                                            
                 AND sfp06 = '4'                                                                                                    
                 AND sfpconf!='X'                                                                                                   
              IF g_cnt = 0 THEN                                                                                                     
                 CALL cl_err(g_rvu.rvu16,'asf-525',0)                                                                               
                 NEXT FIELD rvu16                                                                                                   
              END IF                                                                                                                
           END IF                                                                                                                   
 
         AFTER FIELD rvu06       #部門
           IF NOT cl_null(g_rvu.rvu06) THEN
              IF g_rvu_o.rvu06 IS NULL OR (g_rvu.rvu06!=g_rvu_o.rvu06 ) THEN
                 CALL t720_rvu06('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_rvu.rvu06,g_errno,0)
                    LET g_rvu.rvu06 = g_rvu_o.rvu06
                    DISPLAY BY NAME g_rvu.rvu06
                    NEXT FIELD rvu06
                 END IF
                 IF NOT t720_chkall_azf() THEN NEXT FIELD rvu06 END IF   #FUN-CB0087
              END IF
           ELSE
              DISPLAY NULL TO FORMONLY.gem02 #MOD-640268
           END IF
           LET g_rvu_o.rvu06 = g_rvu.rvu06
 
         AFTER FIELD rvu07       #人員
           IF NOT cl_null(g_rvu.rvu07) THEN
               IF g_rvu_o.rvu07 IS NULL OR (g_rvu.rvu07!=g_rvu_o.rvu07) THEN     #TQC-AC0265 #MOD-B60098 remark
                  CALL t720_rvu07('a')
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_rvu.rvu07,g_errno,0)
                        LET g_rvu.rvu07 = g_rvu_o.rvu07
                        DISPLAY BY NAME g_rvu.rvu07
                        NEXT FIELD rvu07
                      END IF
                  SELECT gen03 INTO g_rvu.rvu06 FROM gen_file
                       WHERE gen01=g_rvu.rvu07
                  IF SQLCA.sqlcode THEN
                     LET g_rvu.rvu06=NULL
                  END IF
                  DISPLAY BY NAME g_rvu.rvu06
                  SELECT gem02 INTO l_gem02 FROM gem_file
                      WHERE gem01=g_rvu.rvu06
                  IF SQLCA.sqlcode THEN
                     LET l_gem02=NULL
                  END IF
                  DISPLAY l_gem02 TO FORMONLY.gem02
                  IF NOT t720_chkall_azf() THEN NEXT FIELD rvu07 END IF   #FUN-CB0087
               END IF      #TQC-AC0265 #MOD-B60098 remark	
           ELSE
               DISPLAY NULL TO FORMONLY.gen02 #MOD-640268
           END IF
           LET g_rvu_o.rvu07 = g_rvu.rvu07
 
       AFTER FIELD rvu08
           IF NOT cl_null(g_rvu.rvu08) THEN 
             IF NOT (g_azw.azw04='2' AND g_rvu.rvu00='3') THEN  #No.FUN-9B0157 -IF
               IF g_rvu.rvu08 != 'REG' AND g_rvu.rvu08 != 'EXP' AND
                  g_rvu.rvu08 != 'CAP' AND g_rvu.rvu08 != 'SUB' THEN
                  IF g_prog[1,3] = 'aic' THEN
                     IF g_rvu.rvu08 != 'WB0' AND g_rvu.rvu08 != 'WB1'
                        AND g_rvu.rvu08 != 'WB2' THEN
                        DISPLAY BY NAME g_rvu.rvu08
                        NEXT FIELD rvu08
                     END IF
                  ELSE
                     DISPLAY BY NAME g_rvu.rvu08
                     NEXT FIELD rvu08
                  END IF
               END IF
             END IF #No.FUN-9B0157 -END IF
               CALL s_prtype(g_rvu.rvu08) RETURNING l_str
              #DISPLAY l_str TO FORMONLY.desc
           END IF
       AFTER FIELD rvu10
          IF NOT cl_null(g_rvu.rvu10) THEN
             IF NOT cl_null(g_rvu.rvu116) THEN
               #IF g_rvu.rvu116 MATCHES "[13]" AND g_rvu.rvu10 = 'N' THEN  #No.FUN-A40054
#               IF g_rvu.rvu116 MATCHES "[123]" AND g_rvu.rvu10 = 'N' THEN #No.FUN-A40054   #No.MOD-AC0403
                IF g_rvu.rvu116 MATCHES "[123]" AND g_rvu.rvu10 = 'N' THEN                    #No.MOD-AC0403 #TQC-B70073 add 2
                   CALL cl_err('','apm-436',0)
                   NEXT FIELD rvu10
                END IF
               #No.FUN-A40054 -BEGIN-----
               #IF g_rvu.rvu116 = '2' AND g_rvu.rvu10 = 'Y' THEN
               #   CALL cl_err('','apm-437',0)
               #   NEXT FIELD rvu10
               #END IF
               #No.FUN-A40054 -END-------
             END IF
          END IF
        AFTER FIELD rvu111
           IF NOT cl_null(g_rvu.rvu111) THEN
              CALL t720_rvu111()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_rvu.rvu111,g_errno,0)
                 NEXT FIELD rvu111
              END IF
           END IF
        AFTER FIELD rvu112
           IF NOT cl_null(g_rvu.rvu112) THEN
              CALL t720_rvu112()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_rvu.rvu112,g_errno,0)
                 NEXT FIELD rvu112
              END IF
           END IF
#MOD-AC0414 -----------------------Begin---------------------------
#        AFTER FIELD rvu12
#           IF cl_null(g_rvu.rvu12) OR g_rvu.rvu12 <=0 THEN  
#              CALL  cl_err(g_rvu.rvu12,'mfg3291',0)
#              NEXT FIELD rvu12
#           END IF
#MOD-AC0414 -----------------------End-----------------------------
       #-MOD-AB0037-add-
        AFTER FIELD rvu15
           IF NOT cl_null(g_rvu.rvu15) THEN   #TQC-AB0083
              LET l_cnt = 0
              SELECT COUNT(*) INTO l_cnt
                FROM apa_file,apk_file
               WHERE apa01=apk01
                 AND apk03=g_rvu.rvu15
                 AND apa00 MATCHES '1*'
                 AND apa41='Y'            #已確認
              IF l_cnt = 0 THEN
                #判斷輸入的發票號碼是否存在amdi100,且已確認
                 SELECT COUNT(*) INTO l_cnt FROM amd_file
                  WHERE amd03=g_rvu.rvu15
                    AND amd30='Y'        #已確認
                 IF l_cnt = 0 THEN
                    CALL cl_err(g_rvu.rvu15,'aap-151',0)
                    NEXT FIELD rvu15 
                 END IF   
              END IF
           END IF                             #TQC-AB0083
       #-MOD-AB0037-end-

        AFTER FIELD rvu113
           IF NOT cl_null(g_rvu.rvu113) THEN
              CALL t720_rvu113()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_rvu.rvu113,g_errno,0)
                 NEXT FIELD rvu113
              END IF
           END IF
        AFTER FIELD rvu115
           IF NOT cl_null(g_rvu.rvu115) THEN
              CALL t720_rvu115()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_rvu.rvu115,g_errno,0)
                 NEXT FIELD rvu115
              END IF
           END IF
        AFTER FIELD rvu114
        #  IF cl_null(g_rvu.rvu114) OR g_rvu.rvu114 <=0 THEN          #MOD-AC0414
           IF cl_null(g_rvu.rvu114) OR g_rvu.rvu114 <0 THEN           #MOD-AC0414 
              CALL cl_err('','mfg3291',0)
              NEXT FIELD rvu114
           END IF
      #TQC-BB0259 mark begin----------------
      #ON CHANGE rvu21
      #   IF g_rvu.rvu21 = '1' THEN
      #      LET g_rvu.rvu00 = g_argv1
      #   ELSE
      #      LET g_rvu.rvu00 = '4'
      #   END IF         
      #   DISPLAY BY NAME g_rvu.rvu00
      #TQC-BB0259 mark end -----------------
       AFTER FIELD rvuud01
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rvuud02
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rvuud03
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rvuud04
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rvuud05
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rvuud06
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rvuud07
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rvuud08
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rvuud09
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rvuud10
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rvuud11
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rvuud12
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rvuud13
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rvuud14
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rvuud15
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER INPUT
          #TQC-AC0265  --add
          LET g_rvu.rvuuser = s_get_data_owner("rvu_file") #FUN-C10039
          LET g_rvu.rvugrup = s_get_data_group("rvu_file") #FUN-C10039
          IF INT_FLAG THEN EXIT INPUT END IF     #TQC-C60085 -- add

          IF NOT cl_null(g_rvu.rvu07) THEN
             CALL t720_rvu07('a')
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_rvu.rvu07,g_errno,0)
                   LET g_rvu.rvu07 = g_rvu_o.rvu07
                   DISPLAY BY NAME g_rvu.rvu07
                   NEXT FIELD rvu07
                END IF
          END IF 
          #TQC-AC0265  --end
#MOD-AC0414 --------------------Begin------------------------
          IF NOT cl_null(g_rvu.rvu12) AND g_rvu.rvu12 >= 0 THEN
             LET g_rvu.rvu14=g_rvu.rvu13*g_rvu.rvu12/100
           #no.A010本幣取位
             CALL t720_get_azi_2()                             #MOD-CA0007 add
             LET g_rvu.rvu14=cl_digcut(g_rvu.rvu14,t_azi04)    #MOD-CA0007 add
             #LET g_rvu.rvu14=cl_digcut(g_rvu.rvu14,g_azi04)   #MOD-CA0007 mark
             DISPLAY BY NAME g_rvu.rvu14
          ELSE
             CALL cl_err(g_rvu.rvu12,'apm-798',0)
          END IF
#MOD-AC0414 --------------------End--------------------------
          LET l_flag='N'
         #TQC-C60085 -- mark -- begin
         #IF INT_FLAG THEN
         #   EXIT INPUT
         #END IF
         #TQC-C60085 -- mark -- end
          IF cl_null(g_rvu.rvu01) THEN
             LET l_flag='Y'
             DISPLAY BY NAME g_rvu.rvu01
          END IF
          IF (g_rvu.rvu00 = '1' OR g_rvu.rvu00='2')
              AND cl_null(g_rvu.rvu02) THEN
             LET l_flag='Y'
             DISPLAY BY NAME g_rvu.rvu02
          END IF
          IF cl_null(g_rvu.rvu08) THEN
             LET l_flag='Y'
             DISPLAY BY NAME g_rvu.rvu08
          END IF
          IF l_flag='Y' THEN
             CALL cl_err('','9033',0)
             NEXT FIELD rvu02
          END IF
          IF g_rvu.rvu116 = '2' AND cl_null(g_rvu.rvu02) AND g_rvu.rvu00 = '3' THEN
             CALL cl_err('','apm-534',0)
             NEXT FIELD rvu02
          END IF
       #  IF g_rvu.rvu12 <= 0 AND g_rvu.rvu00 = '3' THEN        #MOD-AC0414
          IF g_rvu.rvu12 < 0 AND g_rvu.rvu00 = '3' THEN         #MOD-AC0414
             CALL cl_err('','apj-036',0)
             NEXT FIELD rvu12
          END IF
       #  IF g_rvu.rvu114 <= 0 AND g_rvu.rvu00 = '3' THEN       #MOD-AC0414
          IF g_rvu.rvu114 < 0 AND g_rvu.rvu00 = '3' THEN        #MOD-AC0414
             CALL cl_err('','apj-036',0)
             NEXT FIELD rvu114
          END IF
          IF p_cmd = 'u' AND g_rvu.rvu04 <> g_rvu_t.rvu04 THEN
              UPDATE rvv_file
                 SET rvv06 = g_rvu.rvu04
               WHERE rvv01 = g_rvu.rvu01
          END IF
          IF cl_null(g_rvu.rvu05) AND g_rvu.rvu04[1,4] = 'MISC' THEN
              NEXT FIELD rvu05
          END IF
          IF cl_null(g_rvu.rvu08) AND cl_null(g_rvu.rvu02) THEN
              NEXT FIELD rvu08
          END IF
 
 
        ON ACTION CONTROLP
          CASE WHEN INFIELD(rvu01) #查詢單据
                 LET g_t1 = s_get_doc_no(g_rvu.rvu01)       #No.FUN-550060
                 IF g_prog[1,3] = 'aic' THEN
                    CASE WHEN g_rvu.rvu00 ='1' LET g_chr='C' #入庫
                         WHEN g_rvu.rvu00 ='2' LET g_chr='D' #驗退
                         WHEN g_rvu.rvu00 ='3' LET g_chr='D' #倉退
                    END CASE
                 ELSE
                    CASE WHEN g_rvu.rvu00 ='1' LET g_chr='7' #入庫
                        #WHEN g_rvu.rvu00 ='2' LET g_chr='4' #驗退
                         WHEN g_rvu.rvu00 ='2' LET g_chr='E' #驗退  #MOD-BA0177
                         WHEN g_rvu.rvu00 ='3' LET g_chr='4' #倉退
                    END CASE
                 END IF   #TQC-9B0191
#FUN-D50103 ----------- add -------------- begin ---------------
                 CASE
                    WHEN g_argv3 !='SUB' AND g_argv3 !='TAP'
                       LET g_sql = " (smy72 in('REG','EXP','CAP') OR smy72 is null ) "
                    WHEN g_argv3 ='SUB'
                       LET g_sql = " (smy72 in('SUB') OR smy72 is null ) "
                    WHEN g_argv3 ='TAP'
                       LET g_sql = " (smy72 in('TAP','TRI') OR smy72 is null ) "
                 END CASE
                 CALL smy_qry_set_par_where(g_sql)
#FUN-D50103 ----------- add -------------- end -----------------
                 CALL q_smy(FALSE,FALSE,g_t1,'APM',g_chr) RETURNING g_t1  #TQC-670008
                 LET g_rvu.rvu01=g_t1             #No.FUN-550060
                 DISPLAY BY NAME g_rvu.rvu01
                 NEXT FIELD rvu01
               WHEN INFIELD(rvu02)  #驗收單
                 CASE
                  WHEN g_rvu.rvu00='1'  #MOD-860227
                       CALL cl_init_qry_var()
                       IF g_argv3 <> 'TAP'  THEN             #MOD-890002
                          LET g_qryparam.form = "q_rvall"
                       ELSE                                  #MOD-890002
                          LET g_qryparam.form = "q_rvall04"  #MOD-890002
                       END IF                                #MOD-890002
                       LET g_qryparam.default1 = g_rvu.rvu02
#                      LET g_qryparam.where    = " rvb31 >0 "  #MOD-8A0070   #MOD-B60049 mark
                       #MOD-B60049 add --start--
                       IF g_argv3 = 'SUB'  THEN
                          LET g_qryparam.where = " rvb31 > 0 AND rva10 = 'SUB'"
                       ELSE
                          #LET g_qryparam.where = " rvb31 > 0 "
                          LET g_qryparam.where = " rvb31 > 0 AND rva10 <> 'SUB'"  #MOD-BB0126
                       END IF
                       #MOD-B60049 add --end--
                       CALL cl_create_qry() RETURNING g_rvu.rvu02
                        DISPLAY BY NAME g_rvu.rvu02              #No.MOD-490371
                  WHEN g_rvu.rvu00='2'  
                       CALL cl_init_qry_var()
                       IF g_argv3 <> 'TAP'  THEN             #MOD-890002
                          LET g_qryparam.form = "q_rvall"
                       ELSE                                  #MOD-890002
                          LET g_qryparam.form = "q_rvall04"  #MOD-890002
                       END IF                                #MOD-890002
                       LET g_qryparam.default1 = g_rvu.rvu02
#                      LET g_qryparam.where    = " rvb18 <='30' "  #MOD-8A0070    #MOD-B60049 mark
                       #MOD-B60049 add --start--
                       IF g_argv3 = 'SUB'  THEN
                          LET g_qryparam.where = " rvb18 <='30' AND rva10 = 'SUB'"
                       ELSE
                          LET g_qryparam.where = " rvb18 <='30' "
                       END IF
                       #MOD-B60049 add --end--
                       CALL cl_create_qry() RETURNING g_rvu.rvu02
                       DISPLAY BY NAME g_rvu.rvu02        
                  WHEN g_rvu.rvu00='3'
                       CALL cl_init_qry_var()
                       IF g_argv3 <> 'TAP'  THEN             #MOD-890002
                          LET g_qryparam.form = "q_rvall"
                       ELSE                                  #MOD-890002
                          LET g_qryparam.form = "q_rvall04"  #MOD-890002
                       END IF                                #MOD-890002
                       LET g_qryparam.default1 = g_rvu.rvu02
#                      LET g_qryparam.where    = " rvb18 <='30' "   #MOD-B60049 mark
                       #MOD-B60049 add --start--
                       IF g_argv3 = 'SUB'  THEN
                          LET g_qryparam.where = " rvb18 <='30' AND rva10 = 'SUB'"
                       ELSE
                          LET g_qryparam.where = " rvb18 <='30' "
                       END IF
                       #MOD-B60049 add --end--
                       CALL cl_create_qry() RETURNING g_rvu.rvu02
                        DISPLAY BY NAME g_rvu.rvu02              #No.MOD-490371
                 END CASE
                 DISPLAY BY NAME g_rvu.rvu02
                 CALL t720_rvu02()
                 NEXT FIELD rvu02
               WHEN INFIELD(rvu04)  #廠商資料
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pmc1"
                 LET g_qryparam.default1 = g_rvu.rvu04
                 CALL cl_create_qry() RETURNING g_rvu.rvu04
                 DISPLAY BY NAME g_rvu.rvu04
                 IF NOT cl_null(g_rvu.rvu04) THEN    #TQC-C60085 -- add
                    SELECT pmc03 INTO g_buf FROM pmc_file WHERE pmc01=g_rvu.rvu04
                    IF STATUS THEN
                       CALL cl_err3("sel","pmc_file",g_rvu.rvu04,"",STATUS,"","select pmc",1)  #No.FUN-660129
                       NEXT FIELD rvu04
                    END IF
                    DISPLAY g_buf TO pmc03
                 END IF                              #TQC-C60085 -- add
                 NEXT FIELD rvu04
               WHEN INFIELD(rvu111)  
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_pma"
                  LET g_qryparam.default1 = g_rvu.rvu111
                  CALL cl_create_qry() RETURNING g_rvu.rvu111
                  CALL t720_rvu111()
                  DISPLAY BY NAME g_rvu.rvu111
                  NEXT FIELD rvu111
               WHEN INFIELD(rvu112)  
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_pnz01"
                  LET g_qryparam.default1 = g_rvu.rvu112
                  CALL cl_create_qry() RETURNING g_rvu.rvu112
                  CALL t720_rvu112()
                  DISPLAY BY NAME g_rvu.rvu112
                  NEXT FIELD rvu112
               WHEN INFIELD(rvu113)  
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azi"
                  LET g_qryparam.default1 = g_rvu.rvu113
                  CALL cl_create_qry() RETURNING g_rvu.rvu113
                  CALL t720_rvu113()
                  DISPLAY BY NAME g_rvu.rvu113
                  NEXT FIELD rvu113
               WHEN INFIELD(rvu115)  
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gec01"
                  LET g_qryparam.default1 = g_rvu.rvu115
                  CALL cl_create_qry() RETURNING g_rvu.rvu115
                  CALL t720_rvu115()
                  DISPLAY BY NAME g_rvu.rvu115
                  NEXT FIELD rvu115
               WHEN INFIELD(rvu16)                                                                                                  
                    CALL cl_init_qry_var()                                                                                          
                    LET g_qryparam.form = "q_sfp1"                                                                                  
                    LET g_qryparam.default1 = g_rvu.rvu16                                                                           
                    CALL cl_create_qry() RETURNING g_rvu.rvu16                                                                      
                    DISPLAY BY NAME g_rvu.rvu16                                                                                     
                    NEXT FIELD rvu16                                                                                                
               WHEN INFIELD(rvu07) #人員
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.default1 = g_rvu.rvu07
                 CALL cl_create_qry() RETURNING g_rvu.rvu07
                 DISPLAY BY NAME g_rvu.rvu07
                 CALL t720_rvu07('a')
                 NEXT FIELD rvu07
              WHEN INFIELD(rvu06) #部門
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.default1 = g_rvu.rvu06
                 CALL cl_create_qry() RETURNING g_rvu.rvu06
                 DISPLAY BY NAME g_rvu.rvu06
                 CALL t720_rvu06('a')
                 NEXT FIELD rvu06
               OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION CONTROLZ
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
 
FUNCTION t720_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_rvu.* TO NULL                                    #No.FUN-6A0162
    #MESSAGE ""                                                   #FUN-A50001 mark
    CALL cl_msg("")                                               #FUN-A50001 add
    IF NOT g_argv1 MATCHES '[56Z]' THEN                           #No.FUN-940083
       DISPLAY ' ' TO FORMONLY.cnt
    END IF
 
    IF g_sma.sma120 = 'Y'  THEN
       IF cl_null(g_argv1) OR g_argv1 NOT MATCHES '[56Z]' THEN     #No.TQC-9C0155
          LET lg_smy62 = ''
          LET lg_group = ''
          CALL t720_refresh_detail()
       END IF                                                     #No.TQC-9C0155
    END IF
 
    CALL t720_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 INITIALIZE g_rvu.* TO NULL RETURN END IF
   #MESSAGE " SEARCHING ! "                   #FUN-A50001 mark
    CALL cl_msg(" SEARCHING ! ")              #FUN-A50001 add 
    OPEN t720_cs                              #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_rvu.* TO NULL
    ELSE
        OPEN t720_curs
        FETCH t720_curs INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        IF NOT g_argv1 MATCHES '[56Z]' THEN                                   #No.FUN-940083
           CALL t720_fetch('F')
        END IF
    END IF
   #MESSAGE ""                                #FUN-A50001 mark
    CALL cl_msg("")                           #FUN-A50001 add
END FUNCTION
 
FUNCTION t720_fetch(p_flag)
DEFINE
    p_flag         LIKE type_file.chr1    #處理方式  #No.FUN-680136 VARCHAR(1)
DEFINE l_slip      LIKE smy_file.smyslip  #No.FUN-680136 VARCHAR(10) #No.TQC-650108
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t720_cs INTO g_rvu.rvu01,g_rvu.rvu00
        WHEN 'P' FETCH PREVIOUS t720_cs INTO g_rvu.rvu01,g_rvu.rvu00
        WHEN 'F' FETCH FIRST    t720_cs INTO g_rvu.rvu01,g_rvu.rvu00
        WHEN 'L' FETCH LAST     t720_cs INTO g_rvu.rvu01,g_rvu.rvu00
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
            FETCH ABSOLUTE g_jump t720_cs INTO g_rvu.rvu01,g_rvu.rvu00
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
       INITIALIZE g_rvu.* TO NULL  #TQC-6B0105
       CALL cl_err(g_rvu.rvu01,SQLCA.sqlcode,0) RETURN
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
 
    #在使用Q查詢的情況下得到當前對應的屬性組smy62
    IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN
       LET l_slip = g_rvu.rvu01[1,g_doc_len]
       SELECT smy62 INTO lg_smy62 FROM smy_file
          WHERE smyslip = l_slip
    END IF
 
    SELECT * INTO g_rvu.* FROM rvu_file WHERE rvu01 = g_rvu.rvu01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","rvu_file",g_rvu.rvu01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
       INITIALIZE g_rvu.* TO NULL
       RETURN
    END IF
    LET g_data_owner = g_rvu.rvuuser      #FUN-4C0056 add
    LET g_data_group = g_rvu.rvugrup      #FUN-4C0056 add
    LET g_data_plant = g_rvu.rvuplant #FUN-980030
    CALL t720_show()
END FUNCTION
 
FUNCTION t720_show()
DEFINE l_azp02     LIKE  azp_file.azp02   #NO.FUN-960130
DEFINE l_gen02     LIKE  gen_file.gen02   #NO.FUN-960130
DEFINE l_gem02     LIKE  gem_file.gem02   #NO.FUN-960130
 
  LET g_rvu_t.* = g_rvu.*                #保存單頭舊值
  IF NOT g_argv1 MATCHES '[56Z]' THEN                                     #No.FUN-940083
     DISPLAY BY NAME g_rvu.rvuoriu,g_rvu.rvuorig,
      g_rvu.rvu00,g_rvu.rvu02,g_rvu.rvu03,g_rvu.rvu01,g_rvu.rvu04,g_rvu.rvu05,
      g_rvu.rvu16,         #FUN-930062  
      g_rvu.rvu08,g_rvu.rvu06,g_rvu.rvu07,g_rvu.rvu20,g_rvu.rvu09,g_rvu.rvu99,
      g_rvu.rvu10,g_rvu.rvu11,g_rvu.rvu15,g_rvu.rvu13,g_rvu.rvu14,g_rvu.rvu12,
      g_rvu.rvumksg,g_rvu.rvu17,                                              #FUN-A60009 add
      g_rvu.rvuconf,g_rvu.rvuuser,g_rvu.rvugrup,g_rvu.rvumodu,g_rvu.rvudate,
      g_rvu.rvucrat,      #TQC-9A0093 
      g_rvu.rvuud01,g_rvu.rvuud02,g_rvu.rvuud03,g_rvu.rvuud04,
      g_rvu.rvuud05,g_rvu.rvuud06,g_rvu.rvuud07,g_rvu.rvuud08,
      g_rvu.rvuud09,g_rvu.rvuud10,g_rvu.rvuud11,g_rvu.rvuud12,
      g_rvu.rvuud13,g_rvu.rvuud14,g_rvu.rvuud15
      ,g_rvu.rvu111,g_rvu.rvu112,g_rvu.rvu113,g_rvu.rvu114,g_rvu.rvu115
      ,g_rvu.rvu117,g_rvu.rvu116,g_rvu.rvu25 #FUN-A50071

   #TQC-B60065 Begin---
    IF g_rvu00 = 'A' THEN
       DISPLAY BY NAME g_rvu.rvu25,g_rvu.rvu27
    END IF
   #TQC-B60065 End-----
 
    IF g_azw.azw04 = '2' THEN
       DISPLAY BY NAME g_rvu.rvucrat
       LET l_azp02 = ''
       SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rvu.rvuplant       
       DISPLAY BY NAME g_rvu.rvuplant                                    
       DISPLAY l_azp02 TO FORMONLY.rvuplant_desc  
       
       LET l_azp02 = '' 
       SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rvu.rvu22
       DISPLAY BY NAME g_rvu.rvu22                                                   
       DISPLAY l_azp02 TO FORMONLY.rvu22_desc 
 
       SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = g_rvu.rvu23
       DISPLAY BY NAME g_rvu.rvu23
       DISPLAY l_gem02 TO FORMONLY.rvu23_desc
 
       SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_rvu.rvuconu
       DISPLAY BY NAME g_rvu.rvuconu
       DISPLAY l_gen02 TO FORMONLY.rvuconu_desc
 
       DISPLAY BY NAME g_rvu.rvucond
       DISPLAY BY NAME g_rvu.rvucont
       DISPLAY BY NAME g_rvu.rvu21
      #DISPLAY BY NAME g_rvu.rvumksg  #FUN-A60009 mark
       DISPLAY BY NAME g_rvu.rvu900
       DISPLAY BY NAME g_rvu.rvu24    #bnl add
       #DISPLAY BY NAME g_rvu.rvupos   #No.FUN-A10123 #NO.FUN-B50042
    END IF
   #FUN-C30140--mod---str--
   #IF g_rvu.rvuconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   #CALL cl_set_field_pic(g_rvu.rvuconf,"","","",g_chr,"")
    CALL t720_pic()
   #FUN-C30140--mod---end--
 
    LET g_buf=' '
    CASE
       WHEN g_rvu.rvu00='1'
           CALL cl_getmsg('apm-243',g_lang) RETURNING g_buf
       WHEN g_rvu.rvu00='2'
           CALL cl_getmsg('apm-244',g_lang) RETURNING g_buf
       WHEN g_rvu.rvu00='3'
           CALL cl_getmsg('apm-245',g_lang) RETURNING g_buf
    END CASE
    DISPLAY g_buf TO t_1
    CALL s_prtype(g_rvu.rvu08) RETURNING l_str
    CALL t720_rvu06('d')
    CALL t720_rvu07('d')
    CALL t720_rvu111( )
    CALL t720_rvu112( )
   #CALL t720_rvu113( ) #MOD-D30066 mark
    CALL t720_rvu115( )
  END IF
  #-----CHI-B10047---------
  SELECT rva00 INTO g_rva00 FROM rva_file WHERE rva01 = g_rvu.rvu02
  IF cl_null(g_rvu.rvu02) THEN
     LET g_rva00 = '2' 
  END IF 
  #-----END CHI-B10047-----
 
  CALL t720_b_fill(g_wc2)
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t720_r()  #刪除
    DEFINE l_chr,l_sure    LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)    
    DEFINE l_i             LIKE type_file.num5  #no.CHI-860008
    #FUN-BC0104---add---str
    DEFINE l_rvv45         LIKE rvv_file.rvv45,
           l_rvv05         LIKE rvv_file.rvv05,
           l_rvv46         LIKE rvv_file.rvv46,
           l_rvv47         LIKE rvv_file.rvv47,
           l_type1         LIKE type_file.chr1,
           l_qcl05         LIKE qcl_file.qcl05,
           l_cn            LIKE type_file.num5,
           l_c             LIKE type_file.num5
    DEFINE l_rvv_a   DYNAMIC ARRAY OF RECORD
           rvv45           LIKE rvv_file.rvv45,
           rvv05           LIKE rvv_file.rvv05,
           rvv46           LIKE rvv_file.rvv46,
           rvv47           LIKE rvv_file.rvv47
                     END RECORD
   DEFINE l_shb01            LIKE shb_file.shb01
   DEFINE l_shb28            LIKE shb_file.shb28
   DEFINE l_shb29            LIKE shb_file.shb29
    #FUN-BC0104---add---end
   DEFINE l_sql      STRING   #add by huanglf161102
 
    IF s_shut(0) THEN RETURN END IF
    IF g_rvu.rvu01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_rvu.* FROM rvu_file
     WHERE rvu01=g_rvu.rvu01
 
    IF g_rvu.rvuconf = 'Y' THEN CALL cl_err('','apm-242',0) RETURN END IF
    IF g_rvu.rvuconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF NOT cl_null(g_rvu.rvu117) THEN CALL cl_err('','apm-438',0) RETURN END IF   #FUN-940083
    IF NOT cl_null(g_rvu.rvu16) THEN                                                                                                
      CALL cl_err('','apm-579',0)                                                                                                   
      RETURN                                                                                                                        
    END IF                                                                                                                          
 
   #FUN-A60009 add str ---
    IF g_rvu.rvu17 MATCHES '[Ss1]' THEN
       CALL cl_err("","mfg3557",0)
       RETURN
    END IF
   #FUN-A60009 add end ---

    BEGIN WORK
 
    OPEN t720_cl USING g_rvu.rvu01
    IF STATUS THEN
       CALL cl_err("OPEN t720_cl:", STATUS, 1)
       CLOSE t720_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t720_cl INTO g_rvu.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_rvu.rvu01,SQLCA.sqlcode,0) ROLLBACK WORK RETURN
    END IF
    CALL t720_show()
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "rvu01"         #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "rvu00"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_rvu.rvu01      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_rvu.rvu00      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
      #MESSAGE "Delete rvu,rvv!"            #FUN-A50001 mark
       CALL cl_msg("Delete rvu,rvv!")       #FUN-A50001 add
       DELETE FROM rvu_file WHERE rvu01 = g_rvu.rvu01
       IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err3("del","rvu_file",g_rvu.rvu01,"",STATUS,"","del rvu:",1) #No.FUN-660129
          ROLLBACK WORK RETURN
       END IF       
       #FUN-BC0104---add---str---
       DECLARE rvv02_cur CURSOR FOR SELECT rvv05,rvv45,rvv46,rvv47 
                                    FROM rvv_file
                                    WHERE rvv01 = g_rvu.rvu01
       LET l_cn = 1
       FOREACH rvv02_cur INTO l_rvv05,l_rvv45,l_rvv46,l_rvv47
          LET l_rvv_a[l_cn].rvv05 = l_rvv05
          LET l_rvv_a[l_cn].rvv45 = l_rvv45
          LET l_rvv_a[l_cn].rvv46 = l_rvv46
          LET l_rvv_a[l_cn].rvv47 = l_rvv47
          LET l_cn = l_cn + 1
       END FOREACH
       #FUN-BC0104---add---end---
       DELETE FROM rvv_file WHERE rvv01 = g_rvu.rvu01
       IF STATUS THEN
          CALL cl_err3("del","rvv_file",g_rvu.rvu01,"",STATUS,"","del rvv",1)  #No.FUN-660129
          ROLLBACK WORK RETURN
      #FUN-BC0104---add---str---
       ELSE 
          FOR l_c=1 TO l_cn-1
              LET l_qcl05 = ''
              SELECT qcl05 INTO l_qcl05 FROM qcl_file WHERE qcl01 = l_rvv_a[l_c].rvv46
              IF NOT cl_null(l_qcl05) THEN
                 IF l_qcl05 = '1' THEN LET l_type1 = '5' ELSE LET l_type1 = '1' END IF
                 IF NOT s_iqctype_upd_qco20(g_rvu.rvu02,l_rvv_a[l_c].rvv05,l_rvv_a[l_c].rvv45,l_rvv_a[l_c].rvv47,l_type1) THEN
                   ROLLBACK WORK
                   RETURN
                 END IF
              END IF
          END FOR
      #FUN-BC0104---add---end---
          #str---add by jixf 160802
          #SELECT DISTINCT shb28,shb29 INTO l_shb28,l_shb29 FROM shb_file WHERE shb14=g_rvu.rvu01
          SELECT DISTINCT tc_shd03,tc_shd04 INTO l_shb28,l_shb29 FROM tc_shd_file WHERE tc_shd05=g_rvu.rvu01
          IF NOT cl_null(l_shb29) THEN              
             DELETE FROM rva_file WHERE rva01=l_shb29
             DELETE FROM rvb_file WHERE rvb01=l_shb29 
             DELETE FROM tlf_file WHERE tlf036 = l_shb29 #收货单的tlf全部删了
             DELETE FROM tlff_file WHERE tlff036 = l_shb29 #收货单的tlff全部删了       
             DELETE FROM pmm_file WHERE pmm01=l_shb28
             DELETE FROM pmn_file WHERE pmn01=l_shb28
             #UPDATE shb_file SET shbud02='N',shb28='',shb29='',shb14='' WHERE shb01=l_shb01
          END IF
#str----add by huanglf161102
          #LET l_sql = "SELECT shb01 FROM shb_file WHERE shb14 = '",g_rvu.rvu01,"'"
          LET l_sql = "SELECT tc_shd02 FROM tc_shd_file WHERE tc_shd05 = '",g_rvu.rvu01,"'"
          PREPARE t720_shb01 FROM l_sql
          DECLARE t720_shb01_curs CURSOR FOR t720_shb01
          FOREACH t720_shb01_curs INTO l_shb01
               IF SQLCA.sqlcode != 0 THEN
                  CALL cl_err('foreach:',SQLCA.sqlcode,1)
                  EXIT FOREACH
               END IF
               UPDATE tc_shb_file SET tc_shbud10='0'  WHERE tc_shb02 = l_shb01
          END FOREACH 
          DELETE FROM tc_shd_file WHERE tc_shd05 = g_rvu.rvu01 #删除关系表里的数据
#str----end by huanglf161102
          CALL cl_err('','cpm-055',1)        
          #end---add by jixf 160802
       END IF


       
        
#FUN-A60035 ---MARK BEGIN
#      #No.FUN-A50054 -BEGIN-----
#       IF s_industry('slk') THEN 
#          DELETE FROM ata_file WHERE ata00=g_prog AND ata01=g_rvu.rvu01
#       END IF
#      #No.FUN-A50054 -END-------
#FUN-A60035 ---MARK END
    #TQC-740117 刪除時應該連價格變動檔一併刪除
       DELETE FROM rvx_file WHERE rvx01 = g_rvu.rvu01
       IF STATUS THEN
          CALL cl_err3("del","rvx_file",g_rvu.rvu01,"",STATUS,"","del rvx",1)  #No.FUN-660129
          ROLLBACK WORK RETURN
       END IF
        FOR l_i = 1 TO g_rec_b
           #IF NOT s_del_rvbs("2",g_rvu.rvu01,g_rvv[l_i].rvv02,0)  THEN         #FUN-880129  #TQC-B90236 mark
            IF NOT s_lot_del(g_prog,g_rvu.rvu01,'',0,g_rvv[l_i].rvv31,'DEL') THEN   #No.FUN-860045  #TQC-B90236
              ROLLBACK WORK
              RETURN 
          END IF
        END FOR
 
       LET g_msg=TIME
 
       INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980006 add azoplant,azolegal
                     VALUES('apmt720',g_user,g_today,g_msg,g_rvu.rvu01,'delete',g_plant,g_legal) #FUN-980006 add g_plant,g_legal
       CLEAR FORM
      #CALL g_rvv.clear()    #TQC-BA0051 mark
       INITIALIZE g_rvu.* TO NULL
      #MESSAGE ""                      #FUN-A50001 mark
       CALL g_rvv.clear()      #TQC-BA0051 add
       CALL cl_msg("")                 #FUN-A50001 add
       OPEN t720_curs
       #FUN-B50065-add-start--
       IF STATUS THEN
          CLOSE t720_cl
          CLOSE t720_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50065-add-end--
       FETCH t720_curs INTO g_row_count
       #FUN-B50065-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t720_cl
          CLOSE t720_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50065-add-end-- 
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t720_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t720_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL t720_fetch('/')
       END IF
    END IF
    CLOSE t720_cl
    COMMIT WORK
    CALL cl_flow_notify(g_rvu.rvu01,'D')
END FUNCTION
 
FUNCTION t720_b()
DEFINE   li_i         LIKE type_file.num5    #No.FUN-680136 SMALLINT
DEFINE   l_count      LIKE type_file.num5    #No.FUN-680136 SMALLINT
DEFINE   l_temp       LIKE ima_file.ima01
DEFINE   l_check_res  LIKE type_file.chr1    #No.FUN-680136 VARCHAR(01)
DEFINE l_img09        LIKE img_file.img09    #No.MOD-740049 add
DEFINE l_i            LIKE type_file.num5    #No.MOD-740049 add
DEFINE
    l_ac_t,i        LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680136 SMALLINT
    l_row,l_col     LIKE type_file.num5,                #No.FUN-680136 SMALLINT,              #分段輸入之行,列數
    l_n,l_cnt       LIKE type_file.num5,                #檢查重複用  #No.FUN-680136 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否  #No.FUN-680136 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態  #No.FUN-680136 VARCHAR(1)
    l_b2            LIKE type_file.chr50,                #No.FUN-680136 VARCHAR(30)
   #l_ima25         LIKE ima_file.ima25,     #FUN-A10130
    l_ima35         LIKE ima_file.ima35,
    l_ima36         LIKE ima_file.ima36,
    l_ima918        LIKE ima_file.ima918,    #No.MOD-930042 add
    l_ima921        LIKE ima_file.ima921,    #No.MOD-930042 add
    l_rvv17_3       LIKE rvv_file.rvv17,
    l_rvv17_2       LIKE rvv_file.rvv17,    #No.9786
    l_rvv17_3_other LIKE rvv_file.rvv17,    #No.9786
    l_rvv17_1_other LIKE rvv_file.rvv17,    #MOD-5A0431 add
    l_rvv17_2_other LIKE rvv_file.rvv17,    #No.9786
    l_rvv17_return  LIKE rvv_file.rvv17,    #MOD-6A0118 add
    l_rvb07         LIKE rvb_file.rvb07,    #MOD-820189 add
    l_rvb87         LIKE rvb_file.rvb87,    #MOD-820189 add
    l_rvb39         LIKE rvb_file.rvb39,
    l_rvb33         LIKE rvb_file.rvb33,
    l_rvb33_tol     LIKE rvb_file.rvb33,    #MOD-5A0431 add
    l_rvb30         LIKE rvb_file.rvb30,
    l_qcs091        LIKE qcs_file.qcs091,
    l_qcs22         LIKE qcs_file.qcs22,
    l_flag          LIKE type_file.num10,   #No.FUN-680136 INTEGER
    l_pmn41         LIKE pmn_file.pmn41,
    l_pmn43         LIKE pmn_file.pmn43,
    l_tmp           LIKE type_file.chr5,    #No.FUN-680136 VARCHAR(05)           #No.FUN-550060
    l_smy57_5       LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(01)
    l_pmm04         LIKE pmm_file.pmm04,
    l_pmm21         LIKE pmm_file.pmm21,    #TQC-7A0034 add
    l_pmm43         LIKE pmm_file.pmm43,    #FUN-5B0144 add
    l_coc04         LIKE coc_file.coc04,    #No.MOD-4B0275
    l_coc10         LIKE coc_file.coc10,    #No.MOD-4B0275
    l_pmn18         LIKE pmn_file.pmn18,
    l_pmn32         LIKE pmn_file.pmn32,
    l_ec_sw         LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
    l_misc          LIKE type_file.chr4,    #No.FUN-680136 VARCHAR(04)
    g_sw            LIKE type_file.num10,   #No.FUN-680136 INTEGER
    l_code          LIKE type_file.num5,    #No.FUN-680136 SMALLINT
    sn1,sn2         LIKE type_file.num5,    #No.FUN-680136 SMALLINT
    l_cmd           LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(100)
    l_okqty         LIKE rvb_file.rvb33,    #MOD-530018 add
    l_allow_insert  LIKE type_file.num5,    #可新增否  #No.FUN-680136 SMALLINT
    l_allow_delete  LIKE type_file.num5,    #可刪除否  #No.FUN-680136 SMALLINT
     l_err_var  STRING                 #MOD-580138 串接錯誤訊息變數用
DEFINE l_ima159     LIKE ima_file.ima159    #FUN-B50096
DEFINE l_azf09      LIKE azf_file.azf09     #No.FUN-930145
DEFINE l_rva00      LIKE rva_file.rva00     #NO.FUN-940083
DEFINE l_rva113     LIKE rva_file.rva113    #NO.FUN-940083
DEFINE l_dbs        LIKE azp_file.azp03     #NO.FUN-960130
DEFINE l_pmc22    LIKE pmc_file.pmc22   #NO.FUN-960130
DEFINE l_bno        LIKE rvbs_file.rvbs08   #CHI-9A0022
#FUN-A60035 ---MARK BEGIN
#DEFINE l_ata02      LIKE ata_file.ata02     #No.FUN-A50054
#DEFINE l_ata04      LIKE ata_file.ata04     #No.FUN-A50054
#DEFINE l_ata05      LIKE ata_file.ata05     #No.FUN-A50054
#DEFINE l_ata08      LIKE ata_file.ata08     #No.FUN-A50054
#DEFINE l_ata RECORD LIKE ata_file.*         #No.FUN-A50054
#DEFINE l_ima151     LIKE ima_file.ima151    #No.FUN-A60035
#FUN-A60035 ---MARK END
DEFINE l_ima01      LIKE ima_file.ima01       #FUN-A20017
DEFINE l_ima903     LIKE ima_file.ima903      #FUN-A20017
DEFINE l_pmn88      LIKE pmn_file.pmn88,      #MOD-B70231 add
       l_pmn88t     LIKE pmn_file.pmn88t      #MOD-B70231 add
DEFINE l_rvv17_in   LIKE rvv_file.rvv17       #MOD-B90019 add
DEFINE l_gec07      LIKE gec_file.gec07       #CHI-B50027
DEFINE l_qcl05       LIKE qcl_file.qcl05      #FUN-BC0104 add
DEFINE l_sum         LIKE qco_file.qco11      #FUN-BC0104 add
DEFINE l_type1       LIKE type_file.chr1      #FUN-BC0104 add
DEFINE l_rvv82       LIKE rvv_file.rvv82      #FUN-BC0104 add
DEFINE l_rvv85       LIKE rvv_file.rvv85      #FUN-BC0104 add
#FUN-C20002--start add-------------------------------------------
DEFINE l_ima154      LIKE ima_file.ima154
DEFINE l_rcj03       LIKE rcj_file.rcj03
DEFINE l_rtz07       LIKE rtz_file.rtz07
DEFINE l_rtz08       LIKE rtz_file.rtz08
#FUN-C20002--end add---------------------------------------------
DEFINE l_qcl05_wc    STRING     #TQC-C30048 
DEFINE l_qcl05_tf    LIKE type_file.num5 #TQC-C30048
DEFINE p_wc          STRING     #TQC-C60096 
DEFINE l_where   STRING                 #FUN-CB0087
DEFINE l_sql     STRING                 #FUN-CB0087
DEFINE l_pmn01      LIKE pmn_file.pmn01, #MOD-D10192 add
       l_pmn02      LIKE pmn_file.pmn02,
       l_pmn16      LIKE pmn_file.pmn16
DEFINE l_rvv17_tol  LIKE rvv_file.rvv17   #FUN-D20022 add
DEFINE l_yes        LIKE type_file.chr1,   #MOD-D60076 add
       l_pmn31      LIKE pmn_file.pmn31,
       l_pmn31t     LIKE pmn_file.pmn31t,
       l_rvv39      LIKE rvv_file.rvv39,
       l_rvv39t      LIKE rvv_file.rvv39t,
       l_rvv39_sum      LIKE rvv_file.rvv39,
       l_rvv39t_sum      LIKE rvv_file.rvv39
       
    LET g_action_choice = ""
    IF cl_null(g_rvu.rvu01) THEN RETURN END IF
    SELECT * INTO g_rvu.* FROM rvu_file
     WHERE rvu01=g_rvu.rvu01
    IF g_rvu.rvuconf = 'Y' THEN CALL cl_err('','apm-242',0) RETURN END IF
    IF g_rvu.rvuconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
 
   #FUN-A60009 add str ---
    IF g_rvu.rvu17 matches '[Ss]' THEN
       CALL cl_err('','apm-030',0)
       RETURN
    END IF

    IF g_rvu.rvuconf='Y' AND g_rvu.rvu17 = "1" AND g_rvu.rvumksg = "Y"  THEN
       CALL cl_err('','mfg3168',0)
       RETURN
    END IF
   #FUN-A60009 add end ---

    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT * FROM rvv_file  WHERE rvv01= ?  AND rvv02= ? ",
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t720_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

 
    LET l_ac_t = 0
    IF cl_null(g_rvu.rvu117) THEN
       LET l_allow_insert = cl_detail_input_auth("insert")
       LET l_allow_delete = cl_detail_input_auth("delete")
       CALL cl_set_comp_entry("rvv31,rvv35,rvv17,rvv32,rvv33,rvv34",TRUE)
    ELSE
       LET l_allow_insert = FALSE
       LET l_allow_delete = FALSE
       CALL cl_set_comp_entry("rvv31,rvv35,rvv17,rvv32,rvv33,rvv34",FALSE)
    END IF
    IF NOT cl_null(g_rvu.rvu02) THEN
       CALL cl_set_comp_entry("rvv89",FALSE)
    ELSE
       CALL cl_set_comp_entry("rvv89",TRUE)
    END IF
    IF g_rvu.rvu116 = '3' THEN
    #FUN-D60130 -----Begin-------
       IF g_argv1 = '3' AND g_argv3 = 'SUB' AND g_rvu00 = '3' THEN  #委外倉退
          CALL cl_set_comp_entry("rvv17",TRUE)
       ELSE 
    #FUN-D60130 -----End---------
          CALL cl_set_comp_entry("rvv17",FALSE)
       END IF      #FUN-D60130
    ELSE
       CALL cl_set_comp_entry("rvv17",TRUE)
    END IF
    LET INT_FLAG=0
    ERROR ''

    INPUT ARRAY g_rvv WITHOUT DEFAULTS FROM s_rvv.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            LET g_before_input_done = FALSE
            CALL t720_set_entry_b(p_cmd)
            CALL t720_set_no_entry_b(p_cmd)
            CALL t720_set_no_required(p_cmd)
            CALL t720_set_required(p_cmd)
            CALL t720_set_no_entry_rvv34()    #FUN-B50096

            LET g_before_input_done = TRUE
            IF g_aaz.aaz90='Y' THEN
               CALL cl_set_comp_entry("rvv930",g_rvu.rvu00='3')
            END IF
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK
 
            OPEN t720_cl USING g_rvu.rvu01
            IF STATUS THEN
               CALL cl_err("OPEN t720_cl:", STATUS, 1)
               CLOSE t720_cl
               ROLLBACK WORK
               RETURN
            END IF
 
            FETCH t720_cl INTO g_rvu.*  #鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_rvu.rvu01,SQLCA.sqlcode,0)      #資料被他人LOCK
               CLOSE t720_cl ROLLBACK WORK RETURN
            END IF
 
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_rvv_t.* = g_rvv[l_ac].*  #BACKUP
               #No.FUN-BB0086--add--begin--
               LET g_rvv35_t = g_rvv[l_ac].rvv35
               LET g_rvv80_t = g_rvv[l_ac].rvv80
               LET g_rvv83_t = g_rvv[l_ac].rvv83
               LET g_rvv86_t = g_rvv[l_ac].rvv86
               #No.FUN-BB0086--add--end--
#FUN-A60035 ---MARK BEGIN
#             #No.FUN-A50054 --Begin
#              IF s_industry('slk') THEN
#                 DECLARE t720_ata1 SCROLL CURSOR FOR
#                  SELECT ata02,ata03,ata04,ata05,ata08 FROM ata_file 
#                   WHERE ata00=g_prog
#                     AND ata01=g_rvu.rvu01
#                     AND ata02=g_rvv_t.rvv02
#                 FOREACH t720_ata1 INTO l_ata02,g_rvv_t.rvv02,l_ata04,l_ata05,l_ata08
#                    OPEN t720_bcl USING g_rvu.rvu01,g_rvv_t.rvv02
#                    IF STATUS THEN
#                       CALL cl_err("OPEN t720_bcl:", STATUS, 1)
#                    ELSE
#                       FETCH t720_bcl INTO b_rvv.*
#                       IF SQLCA.sqlcode THEN
#                          CALL cl_err('lock rvv',SQLCA.sqlcode,1)
#                          LET l_lock_sw = "Y"
#                       ELSE
#                          SELECT ima021 INTO g_rvv[l_ac].ima021 FROM ima_file
#                           WHERE ima01=b_rvv.rvv31
#                          SELECT azf03 INTO g_rvv[l_ac].azf03 FROM azf_file
#                           WHERE azf01=b_rvv.rvv26 AND azf02='2' #6818
#                          SELECT pmm909 INTO g_rvv[l_ac].pmm909
#                            FROM pmm_file WHERE pmm01 = b_rvv.rvv36
#                          SELECT pmn24,pmn25
#                            INTO g_rvv[l_ac].pmn24,g_rvv[l_ac].pmn25
#                            FROM pmn_file
#                           WHERE pmn01 = b_rvv.rvv36
#                             AND pmn02 = b_rvv.rvv37
#                         CALL t720_get_pmm43(l_ac)
#                         CALL t720_set_rvv89()
#                         CALL t720_b_move_to()
#                       END IF 
#                    END IF
#                 END FOREACH
#                 LET b_rvv.rvv02 = l_ata02
#                 LET b_rvv.rvv05 = l_ata02
#                 LET b_rvv.rvv31 = l_ata05
#                 LET g_rvv_t.rvv02 = b_rvv.rvv02
#                 LET g_rvv_t.rvv05 = b_rvv.rvv02
#                 LET g_rvv_t.rvv31 = b_rvv.rvv31
#                 LET b_rvv.rvv17 = l_ata08
#                 LET g_rvv[l_ac].rvv02 = l_ata02
#                 LET g_rvv[l_ac].rvv05 = l_ata02
#                 LET g_rvv[l_ac].rvv31 = l_ata05
#                 LET g_rvv[l_ac].rvv17 = l_ata08
#                 IF cl_null(g_rvv[l_ac].pmm43) THEN
#                    SELECT gec01,gec04 
#                      INTO g_rvv[l_ac].pmm21,g_rvv[l_ac].pmm43 
#                      FROM gec_file,pmc_file 
#                     WHERE gec01 = pmc47
#                       AND pmc01 = g_rvu.rvu04 
#                       AND gec011='1'  #進項
#                 END IF
#                 CALL t720_set_rvv930(g_rvv[l_ac].rvv930) RETURNING g_rvv[l_ac].gem02a #FUN-670051
#                 LET g_rvv_t.* = g_rvv[l_ac].*         #BACKUP
#                 LET g_change='N' 
#                 CALL t720_set_entry_b(p_cmd)
#                 CALL t720_set_no_entry_b(p_cmd)
#                 CALL t720_set_no_required(p_cmd)
#                 CALL t720_set_required(p_cmd)
#                 LET g_before_input_done = TRUE
#             ELSE
#            #No.FUN-A50054 --End
#FUN-A60035 ---MARK END 
               OPEN t720_bcl USING g_rvu.rvu01,g_rvv_t.rvv02
               IF STATUS THEN
                   CALL cl_err("OPEN t720_bcl:", STATUS, 1)
               ELSE
                  FETCH t720_bcl INTO b_rvv.*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('lock rvv',SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  ELSE
                     SELECT ima021 INTO g_rvv[l_ac].ima021 FROM ima_file
                      WHERE ima01=b_rvv.rvv31
                     SELECT azf03 INTO g_rvv[l_ac].azf03 FROM azf_file
                      WHERE azf01=b_rvv.rvv26 AND azf02='2' #6818
                     SELECT pmm909 INTO g_rvv[l_ac].pmm909
                       FROM pmm_file WHERE pmm01 = b_rvv.rvv36
                     SELECT pmn24,pmn25
                       INTO g_rvv[l_ac].pmn24,g_rvv[l_ac].pmn25
                       FROM pmn_file
                      WHERE pmn01 = b_rvv.rvv36
                        AND pmn02 = b_rvv.rvv37
                     CALL t720_get_pmm43(l_ac)
                     CALL t720_set_rvv89()
                     CALL t720_b_move_to()
                     IF cl_null(g_rvv[l_ac].pmm43) THEN
                        SELECT gec01,gec04 
                          INTO g_rvv[l_ac].pmm21,g_rvv[l_ac].pmm43 
                          FROM gec_file,pmc_file 
                         WHERE gec01 = pmc47
                           AND pmc01 = g_rvu.rvu04 
                           AND gec011='1'  #進項
                     END IF
                     CALL t720_set_rvv930(g_rvv[l_ac].rvv930) RETURNING g_rvv[l_ac].gem02a #FUN-670051
                     LET g_rvv_t.* = g_rvv[l_ac].*         #BACKUP
                     LET g_change='N'   #No.FUN-540027
                     CALL t720_set_entry_b(p_cmd)
                     CALL t720_set_no_entry_b(p_cmd)
                     CALL t720_set_no_required(p_cmd)
                     CALL t720_set_required(p_cmd)
                     LET g_before_input_done = TRUE
#&ifdef ICD   #FUN-B50096
                     CALL t720_set_no_required_1()   #FUN-A40022
                     CALL t720_set_required_1(p_cmd) #FUN-A40022 
                     CALL t720_set_entry_rvv34()     #FUN-B50096
                     CALL t720_set_no_entry_rvv34()  #FUN-B50096
                     CALL t720_set_no_entry_rvv32()  #MOD-C30902
                     #FUN-BC0104---add---str---
                     CALL t720_set_noentry_rvv45()   
                     IF NOT cl_null(g_rvv[l_ac].rvv46)THEN
                        CALL t720_qcl02_desc()
                        CALL cl_set_comp_entry('rvv05',FALSE)
                     END IF
                     #FUN-BC0104---add---end---
#&endif       #FUN-B50096
                  END IF 
               END IF               
#              END IF                    #No.FUN-A50054 Add   #FUN-A60035 ---MARK
              CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_rvv[l_ac].* TO NULL      #900423
            INITIALIZE g_rvv_t.* TO NULL
            INITIALIZE arr_detail[l_ac].* TO NULL #No.TQC-650108
            #No.FUN-BB0086--add--begin--
            LET g_rvv35_t = NULL
            LET g_rvv80_t = NULL
            LET g_rvv83_t = NULL
            LET g_rvv86_t = NULL
            #No.FUN-BB0086--add--end--
            LET b_rvv.rvv03=g_rvu.rvu00     #異動類別
            LET b_rvv.rvv01=g_rvu.rvu01     #入庫單號
            LET b_rvv.rvv04=g_rvu.rvu02     #驗收單號
            LET b_rvv.rvv06=g_rvu.rvu04     #廠商單號
            LET b_rvv.rvv09=g_rvu.rvu03     #異動日期
            LET b_rvv.rvv23=0               #已請款匹配量
            LET b_rvv.rvv88=0               #No.TQC-7B0083
            LET b_rvv.rvv24='N'             #拋轉保稅系統否
            LET g_rvv[l_ac].rvv35_fac=1     #轉換率
            LET g_rvv[l_ac].rvv17=0
            LET g_rvv[l_ac].rvv82=0
            LET g_rvv[l_ac].rvv85=0
            LET g_rvv[l_ac].rvv87=0
            LET g_change='Y'
            LET g_rvv[l_ac].rvv38=0
            LET g_rvv[l_ac].rvv38t=0        #No.FUN-610018
            LET g_rvv[l_ac].rvv25='N'       #樣品
            LET g_rvv[l_ac].rvv89='N'       #FUN-940083 
            CALL t720_set_entry_b(p_cmd)
            CALL t720_set_no_required(p_cmd)
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            IF cl_null(g_rvv[l_ac].rvv02) OR g_rvv[l_ac].rvv02 = 0 THEN
               #FUN-A60035 ---MARK BEGIN
               ##No.FUN-A50054 -BEGIN-----
               #IF s_industry('slk') THEN
               #   SELECT MAX(ata03)+1 INTO g_rvv[l_ac].rvv02  #項次
               #     FROM ata_file WHERE ata01 = g_rvu.rvu01 AND ata00 = g_prog
               #ELSE
               #FUN-A60035 ---MARK END
                  SELECT MAX(rvv02)+1 INTO g_rvv[l_ac].rvv02  #項次
                    FROM rvv_file WHERE rvv01 = g_rvu.rvu01
               #END IF   #FUN-A60035 ---MARK
               IF cl_null(g_rvv[l_ac].rvv02) OR (SQLCA.sqlcode) THEN
                  LET g_rvv[l_ac].rvv02 = 1
               END IF
            END IF
            CALL cl_set_comp_required('rvv45,rvv46,rvv47',FALSE)       #FUN-BC0104 add 
           #CALL cl_set_comp_entry('rvv05,rvv45,rvv46,rvv47',TRUE)     #FUN-BC0104 add   #TQC-C50130 mark
           #TQC-C50130 -- add -- begin
            CALL cl_set_comp_entry('rvv45,rvv46,rvv47',TRUE)
            IF NOT cl_null(g_rvu.rvu02) THEN
               CALL cl_set_comp_entry('rvv05',TRUE)
            END IF
           #TQC-C50130 -- add -- end
            NEXT FIELD rvv02
 
        AFTER INSERT
             IF INT_FLAG THEN
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
                CANCEL INSERT
             END IF
           	 IF g_rvv[l_ac].rvv25 = 'Y' THEN 
           	    LET g_rvv[l_ac].rvv38  = 0
           	    LET g_rvv[l_ac].rvv38t = 0              	    
           	    LET g_rvv[l_ac].rvv39  = 0              	    
           	    LET g_rvv[l_ac].rvv39t = 0
           	    DISPLAY BY NAME g_rvv[l_ac].rvv38,g_rvv[l_ac].rvv38t,
           	                    g_rvv[l_ac].rvv39,g_rvv[l_ac].rvv39t              	    
            	 END IF 
             IF g_sma.sma115 = 'Y' THEN
                CALL s_chk_va_setting(g_rvv[l_ac].rvv31)
                     RETURNING g_flag,g_ima906,g_ima907
                IF g_flag=1 THEN
                   NEXT FIELD rvv31
                END IF
                CALL s_chk_va_setting1(g_rvv[l_ac].rvv31)
                     RETURNING g_flag,g_ima908
                IF g_flag=1 THEN
                   NEXT FIELD rvv31
                END IF
                CALL t720_du_data_to_correct()
                CALL t720_set_origin_field()
             END IF
             CALL t720_qcl05_check() RETURNING l_qcl05      #FUN-BC0104 add
             IF g_sma.sma116 MATCHES '[02]' AND (l_qcl05 NOT MATCHES'[12]' OR cl_null(l_qcl05)) THEN  #MOD-630031 add #不使用計價單位時,計價單位/數量給原單據單位/數量 #FUN-BC0104 add
                LET g_rvv[l_ac].rvv86 = g_rvv[l_ac].rvv35
                LET g_rvv[l_ac].rvv87 = g_rvv[l_ac].rvv17
             END IF
 
             IF cl_null(g_rvv[l_ac].rvv33) THEN LET g_rvv[l_ac].rvv33=' ' END IF   #No.MOD-5C0167
             IF cl_null(g_rvv[l_ac].rvv34) THEN LET g_rvv[l_ac].rvv34=' ' END IF   #No.MOD-5C0167
             CALL t720_b_move_back()
             CALL t720_b_else()
             IF cl_null(g_rvv[l_ac].rvv17) THEN                        #FUN-560040 數量可以為零,原因:實務作業會有, 採購收到折讓單, 無倉退發生,所以數量可以為零
                INITIALIZE g_rvv[l_ac].* TO NULL  #重要欄位空白,無效
                CALL cl_err('','afa-043',1)
                CANCEL INSERT
             END IF
             
             #TQC-5B0159--倉退單身可輸入數量為0
             CALL t720_qcl05_check() RETURNING l_qcl05    #FUN-BC0104
             IF (g_rvu.rvu00 != '3') AND (g_rvv[l_ac].rvv17 = 0) AND (l_qcl05 != '1' OR cl_null(l_qcl05)) THEN #FUN-BC0104 add l_qcl05
                INITIALIZE g_rvv[l_ac].* TO NULL  #重要欄位空白,無效
                CALL cl_err('','afa-978',1)
                CANCEL INSERT
             END IF
 
              #取對img換算率
              # 當為製程委外時不寫 tlf,不 update ima,img 所以可不key 倉庫
              LET l_ec_sw = 'N'
              #IF g_rvu.rvu08='SUB' THEN   #MOD-B40046
              IF g_rvu.rvu08='SUB' AND NOT cl_null(g_rvv[l_ac].rvv36) AND NOT cl_null(g_rvv[l_ac].rvv37) THEN   #MOD-B40046
                 SELECT pmn41,pmn43 INTO l_pmn41,l_pmn43 FROM pmn_file
                  WHERE pmn01 = g_rvv[l_ac].rvv36 AND pmn02 = g_rvv[l_ac].rvv37
                 IF STATUS THEN
                    CALL cl_err3("sel","pmn_file",g_rvv[l_ac].rvv36,g_rvv[l_ac].rvv37,STATUS,"","sel pmn_file",1)  #No.FUN-660129
                 END IF
                 IF NOT cl_null(l_pmn41) AND l_pmn43>0 THEN   #W/O<>'' &製程序>0
                    LET l_ec_sw='Y'
                 END IF
              END IF
              IF l_ec_sw='Y' THEN
                 LET g_rvv[l_ac].rvv32=' '
                 LET g_rvv[l_ac].rvv33=' '
                 LET g_rvv[l_ac].rvv34=' '
              END IF

              IF g_rvv[l_ac].rvv31[1,4]='MISC' OR g_rvu.rvu00='2' OR l_ec_sw='Y'
                 OR (g_rvu.rvu00='3' AND g_rvv[l_ac].rvv17=0)   #MOD-A40166 
                 THEN
 
                 LET g_rvv[l_ac].rvv35_fac =1
                 LET g_rvv[l_ac].rvv81=1
                 LET g_rvv[l_ac].rvv84=1
              ELSE
                 LET l_flag=TRUE  #FUN-810038
 
                 IF (NOT cl_null(g_rvv[l_ac].rvv31)) AND (l_flag) THEN #FUN-810038
                    SELECT img09 INTO g_img09 FROM img_file
                     WHERE img01=g_rvv[l_ac].rvv31 AND img02=g_rvv[l_ac].rvv32
                       AND img03=g_rvv[l_ac].rvv33 AND img04=g_rvv[l_ac].rvv34
                    IF (g_rvu.rvu00='1' AND STATUS=100) OR
                       (g_rvu.rvu00='3' AND STATUS=100) THEN
                       IF NOT cl_null(g_rvv[l_ac].rvv32) OR NOT cl_null(g_rvv[l_ac].rvv33) OR NOT cl_null(g_rvv[l_ac].rvv34) THEN  #MOD-D30083 add
                          IF g_sma.sma892[3,3] ='Y' THEN
                            #IF NOT cl_confirm('mfg1401') THEN NEXT FIELD rvv34 END IF     #TQC-AB0412
                             IF NOT cl_confirm('mfg1401') THEN NEXT FIELD rvv32 END IF     #TQC-AB0412
                          END IF
                          CALL s_add_img(g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv32,
                                         g_rvv[l_ac].rvv33,g_rvv[l_ac].rvv34,
                                         g_rvu.rvu01,      g_rvv[l_ac].rvv02,
                                         g_rvu.rvu03)
                       END IF  #MOD-D30083 add
                    ELSE
                       CALL s_umfchk(g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv35,g_img09)
                       RETURNING g_sw,g_rvv[l_ac].rvv35_fac
                       IF g_sw THEN
                          LET l_err_var = ""
                          LET l_err_var = g_rvv[l_ac].rvv35 CLIPPED,'<--->',g_img09 CLIPPED
                          CALL cl_err(l_err_var,'apm-258',1)
                         #MOD-580138(end)
#### Modify:98/11/15 ----單位換算率抓不到 ---####
                       END IF
                    END IF
                 END IF
              END IF

            IF cl_null(b_rvv.rvv32) THEN LET b_rvv.rvv32=' ' END IF
            IF cl_null(b_rvv.rvv33) THEN LET b_rvv.rvv33=' ' END IF
            IF cl_null(b_rvv.rvv34) THEN LET b_rvv.rvv34=' ' END IF
            CALL t720_qcl05_check() RETURNING l_qcl05     #FUN-BC0104 add
            IF g_sma.sma116 MATCHES '[02]' AND (l_qcl05 NOT MATCHES'[12]' OR cl_null(l_qcl05))  THEN  #MOD-630031 add #不使用計價單位時,計價單位/數量給原單據單位/數量 #FUN-BC0104 add
               LET g_rvv[l_ac].rvv86 = g_rvv[l_ac].rvv35
               LET g_rvv[l_ac].rvv87 = g_rvv[l_ac].rvv17
            END IF
             IF g_rvv[l_ac].rvv87 > 0 THEN
                CALL t720sub_rvv38(g_rvv[l_ac].rvv36,g_rvv[l_ac].rvv38,g_rvv[l_ac].rvv38t,g_rvu.rvu04,g_rvu.rvu01)  #TQC-C30225 add
                    RETURNING g_rvv[l_ac].rvv38,g_rvv[l_ac].rvv38t
                LET g_rvv[l_ac].rvv39 = g_rvv[l_ac].rvv87 * g_rvv[l_ac].rvv38
                LET g_rvv[l_ac].rvv39t= g_rvv[l_ac].rvv87 * g_rvv[l_ac].rvv38t   #No.FUN-610018
                LET b_rvv.rvv39t= g_rvv[l_ac].rvv87 * b_rvv.rvv38t
             ELSE
                LET l_pmm43='' #MOD-7A0180 add
                IF NOT cl_null(g_rvu.rvu02) THEN
                   SELECT rva00 INTO l_rva00 FROM rva_file WHERE rva01 = g_rvu.rvu02
                   IF l_rva00 = '2' THEN
                      SELECT rva116 INTO l_pmm43 FROM rva_file WHERE rva01 = g_rvu.rvu02
                   ELSE
                      #MOD-BC0262 ----- modify start -----
                      IF cl_null(g_rvv[l_ac].rvv36) THEN
                         LET l_pmm43 = g_rvu.rvu12
                      ELSE
                      #MOD-BC0262 ----- modify end -----
                         SELECT pmm43 INTO l_pmm43 FROM pmm_file WHERE pmm01 = g_rvv[l_ac].rvv36
                      END IF   #MOD-BC0262 add
                   END IF
                ELSE
                   SELECT pmm43 INTO l_pmm43 FROM pmm_file WHERE pmm01 = g_rvv[l_ac].rvv36
                END IF
                IF g_rvv[l_ac].rvv87=0 AND cl_null(l_pmm43) THEN
                   LET b_rvv.rvv39t = b_rvv.rvv39t    # 退倉無數量且無採購單可參考時
                ELSE
                IF cl_null(l_pmm43) THEN
                   SELECT gec04 INTO l_pmm43 FROM gec_file,pmc_file
                    WHERE gec01 = pmc47
                      AND pmc01 = g_rvu.rvu04
                      AND gec011='1'  #進項
                END IF
                  IF cl_null(l_pmm43) THEN LET l_pmm43=0 END IF
                  IF cl_null(g_rvv[l_ac].rvv39t) THEN
                     LET g_rvv[l_ac].rvv39t= g_rvv[l_ac].rvv39 * (1+l_pmm43/100)  #No.FUN-610018
                     LET b_rvv.rvv39t = g_rvv[l_ac].rvv39 * (1+l_pmm43/100)
                  ELSE
                     LET b_rvv.rvv39t = g_rvv[l_ac].rvv39t
                  END IF
                END IF  #MOD-7A0180
             END IF
            IF cl_null(b_rvv.rvv02) THEN LET b_rvv.rvv02 = 1 END IF
            LET b_rvv.rvv88 = 0  #No.TQC-7B0083
           #-----MOD-AC0024---------
            CALL cl_digcut(b_rvv.rvv39,t_azi04)  
                              RETURNING b_rvv.rvv39
            CALL cl_digcut(b_rvv.rvv39t,t_azi04)   
                              RETURNING b_rvv.rvv39t  
           #-----END MOD-AC0024-----
            CALL t720sub_rvv38(g_rvv[l_ac].rvv36,b_rvv.rvv38,b_rvv.rvv38t,g_rvu.rvu04,g_rvu.rvu01)  #TQC-C30225 add
                 RETURNING b_rvv.rvv38,b_rvv.rvv38t  
            #CALL t720sub_rvv39(g_rvv[l_ac].rvv36,b_rvv.rvv39,b_rvv.rvv39t,g_rvu.rvu04,g_rvu.rvu02)    #MOD-850300 b_rvv.rvv36->g_rvv[l_ac].rvv36 #FUN-A10130 #MOD-BC0262 mark
            CALL t720sub_rvv39(g_rvv[l_ac].rvv36,b_rvv.rvv39,b_rvv.rvv39t,g_rvu.rvu04,g_rvu.rvu01)     #MOD-BC0262 add
                 RETURNING b_rvv.rvv39,b_rvv.rvv39t
#MOD-B70231 -- begin --
            IF g_rvu.rvu00 = '3' THEN
               IF NOT cl_null(b_rvv.rvv04) THEN
                  IF NOT cl_null(g_rvv[l_ac].rvv36) AND NOT cl_null(g_rvv[l_ac].rvv37) THEN   #MOD-BA0048 add
                     SELECT pmn88,pmn88t INTO l_pmn88,l_pmn88t FROM pmn_file
                        WHERE pmn01 = g_rvv[l_ac].rvv36 AND pmn02 = g_rvv[l_ac].rvv37
                     IF cl_null(l_pmn88) THEN LET l_pmn88 = 0 END IF
                     IF cl_null(l_pmn88t) THEN LET l_pmn88t = 0 END IF
                     IF b_rvv.rvv39 > l_pmn88 OR b_rvv.rvv39t > l_pmn88t THEN
                        CALL cl_err('','apm-250',1)
                        CANCEL INSERT
                     END IF
                  END IF #MOD-BA0048 add
               END IF
            END IF
#MOD-B70231 -- end --
            LET b_rvv.rvvplant = g_rvu.rvuplant    #NO.FUN-960130--ADD--
            LET b_rvv.rvvlegal = g_rvu.rvulegal    #FUN-980006 add
            IF b_rvv.rvv10 IS NULL THEN LET b_rvv.rvv10 = '4' END IF   #NO.FUN-9C0075 ADD
           #IF NOT s_industry('slk') THEN   #No.FUN-A50054  #FUN-A60035 ---MARK
        #流通代銷無收貨單,將發票記錄rvb22同時新增到rvv22內
        #FUN-BB0001 add START
            IF NOT cl_null(b_rvv.rvv04) AND NOT cl_null(b_rvv.rvv05) THEN
               SELECT rvb22 INTO b_rvv.rvv22 FROM rvb_file WHERE rvb01 = b_rvv.rvv04 AND rvb02 = b_rvv.rvv05
            END IF
        #FUN-BB0001 add END
            #FUN-D20022 -- add start --
            IF g_rvu00 = '1' THEN
               SELECT SUM(rvv17) INTO l_rvv17_tol FROM rvv_file,rvu_file
                WHERE rvv04 = g_rvu.rvu02 AND rvv05 = g_rvv[l_ac].rvv05
                 AND rvu00='1' AND rvv01=rvu01 AND rvuconf <> 'X'
                  AND rvu01 <> g_rvu.rvu01
               IF cl_null(l_rvv17_tol) THEN LET l_rvv17_tol = 0 END IF
               IF g_rvv[l_ac].rvv17 > l_rvb33 - l_rvv17_tol THEN #異動數量應扣除已產生的入庫單之數量
                  CALL cl_err(l_rvb33 - l_rvv17_tol,'apm1102',1)
                  CANCEL INSERT 
               END IF
            END IF
            #FUN-D20022 -- add end --
            INSERT INTO rvv_file VALUES(b_rvv.*)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","rvv_file",b_rvv.rvv01,b_rvv.rvv02,SQLCA.sqlcode,"","ins rvv",1)  #No.FUN-660129
               CANCEL INSERT
               SELECT ima918,ima921 INTO g_ima918,g_ima921 
                 FROM ima_file
                WHERE ima01 = g_rvv[l_ac].rvv31
                  AND imaacti = "Y"
               
               IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                  IF g_sma.sma90 = "Y" THEN #MOD-C30074 add
                  #IF NOT s_lotin_del(g_prog,g_rvu.rvu01,g_rvv[l_ac].rvv02,0,g_rvv[l_ac].rvv31,'DEL') THEN   #No.FUN-860045  #TQC-B90236 mark
                    IF NOT s_lot_del(g_prog,g_rvu.rvu01,g_rvv[l_ac].rvv02,0,g_rvv[l_ac].rvv31,'DEL') THEN   #No.FUN-860045  #TQC-B90236 
                       CALL cl_err3("del","rvbs_file",g_rvu.rvu01,g_rvv_t.rvv02,
                                      SQLCA.sqlcode,"","",1)
                     END IF
                  END IF #MOD-C30074 add
               END IF
            ELSE
              #MESSAGE 'INSERT O.K'             #FUN-A50001 mark
               CALL cl_msg("INSERT O.K")        #FUN-A50001 add
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
               #FUN-BC0104---add---str
               CALL t720_qcl05_check() RETURNING l_qcl05
               IF l_qcl05 = '1' THEN LET l_type1 = '5' ELSE LET l_type1 = '1' END IF
               IF NOT s_iqctype_upd_qco20(g_rvu.rvu02,g_rvv[l_ac].rvv05,g_rvv[l_ac].rvv45,g_rvv[l_ac].rvv47,l_type1) THEN
                  CANCEL INSERT 
               END IF
               #FUN-BC0104---add---end 
               COMMIT WORK               
            END IF
#FUN-A60035 ---MARK BEGIN
#         #No.FUN-A50054 -BEGIN-----
#          ELSE
#             LET g_sql = " SELECT ata03,ata04,ata08 FROM ata_file ",
#                         "  WHERE ata00 = '",g_prog,"'",
#                         "    AND ata01 = '",g_rvu.rvu01,"'",
#                         "    AND ata02 = '",g_rvv[l_ac].rvv02,"'"
#             DECLARE t720_ata_curs SCROLL CURSOR FROM g_sql
#             FOREACH t720_ata_curs INTO b_rvv.rvv02,b_rvv.rvv31,b_rvv.rvv17
#                LET b_rvv.rvv39 = g_rvv[l_ac].rvv39 * b_rvv.rvv17 / g_rvv[l_ac].rvv17
#                LET b_rvv.rvv39t= g_rvv[l_ac].rvv39t* b_rvv.rvv17 / g_rvv[l_ac].rvv17
#                LET b_rvv.rvv87 = g_rvv[l_ac].rvv87 * b_rvv.rvv17 / g_rvv[l_ac].rvv17
#                CALL cl_digcut(b_rvv.rvv39,t_azi04)  RETURNING b_rvv.rvv39
#                CALL cl_digcut(b_rvv.rvv39t,t_azi04) RETURNING b_rvv.rvv39t
#                INSERT INTO rvv_file VALUES(b_rvv.*)
#                IF SQLCA.sqlcode THEN
#                   CALL cl_err3("ins","rvv_file",b_rvv.rvv01,b_rvv.rvv02,SQLCA.sqlcode,"","ins rvv",1)  #No.FUN-660129
#                   CANCEL INSERT
#                   SELECT ima918,ima921 INTO g_ima918,g_ima921 
#                     FROM ima_file
#                    WHERE ima01 = g_rvv[l_ac].rvv31
#                      AND imaacti = "Y"
#              
#                   IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
#                      IF NOT s_lotin_del(g_prog,g_rvu.rvu01,g_rvv[l_ac].rvv02,0,g_rvv[l_ac].rvv31,'DEL') THEN   #No.FUN-860045
#                         CALL cl_err3("del","rvbs_file",g_rvu.rvu01,g_rvv_t.rvv02,
#                                       SQLCA.sqlcode,"","",1)
#                      END IF
#                   END IF
#                END IF
#             END FOREACH
#             CALL cl_msg("INSERT O.K")
#             LET g_rec_b=g_rec_b+1
#             DISPLAY g_rec_b TO FORMONLY.cn2
#             COMMIT WORK
#          END IF
#         #No.FUN-A50054 -END-------
#FUN-A60035 ---MARK END
 
 
        BEFORE FIELD rvv05             #default 序號
           CALL t720_set_entry_b(p_cmd)
           CALL t720_set_no_required(p_cmd)
           #FUN-BC0104---add---str---
           IF p_cmd = 'a' THEN
              CALL cl_set_comp_required('rvv45,rvv46,rvv47',FALSE)               
              CALL cl_set_comp_entry('rvv05,rvv45,rvv46,rvv47',TRUE) 
           END IF
           #FUN-BC0104---add---end---
 
 
        AFTER FIELD rvv05             #驗收項次        
           IF NOT cl_null(g_rvu.rvu02) AND NOT cl_null(g_rvv[l_ac].rvv05) THEN
              #MOD-D10192 add begin-----------------------
              IF g_rvu.rvu00 = '3' AND g_rvu.rvu116 = '2' THEN 
                 SELECT pmn01,pmn02,pmn16 INTO l_pmn01,l_pmn02,l_pmn16 FROM pmn_file WHERE pmn01 IN 
                    (SELECT rvb04 FROM rvb_file WHERE rvb01 = g_rvu.rvu02 AND rvb02 = g_rvv[l_ac].rvv05)
                    AND pmn02 IN 
                    (SELECT rvb03 FROM rvb_file WHERE rvb01 = g_rvu.rvu02 AND rvb02 = g_rvv[l_ac].rvv05)
                 IF l_pmn16 MATCHES  '[678]' THEN 
                    CALL cl_err(l_pmn01,'apm-599',0)
                    NEXT FIELD rvv05
                 END IF       
              END IF    
              #MOD-D10192 add end-------------------------            
              CALL t720_rvv05(p_cmd)
              LET l_rvb07 = 0
              SELECT rvb07 INTO l_rvb07 FROM rvb_file
               WHERE rvb01=g_rvu.rvu02 
                 AND rvb02=g_rvv[l_ac].rvv05
              IF l_rvb07 <> g_rvv[l_ac].rvv17  AND p_cmd <> 'a' THEN
                 LET g_change = 'Y'
              END IF
              #FUN-BC0104---add---str---
              IF p_cmd = 'a' THEN
                 CALL t720_rvv46_check()
              END IF
              #FUN-BC0104---add---end---
              IF NOT cl_null(g_errno) THEN
                #MOD-C30590 -- add -- begin
                 IF (g_rvv[l_ac].rvv31 = 'MISC') AND (g_errno = 'apm-259') THEN  
                 ELSE
                #MOD-C30590 -- add -- end
                    CALL cl_err(g_rvv[l_ac].rvv05,g_errno,0)

                    IF g_errno <> 'apm-259' THEN #No.TQC-7C0020
                       NEXT FIELD rvv05
                    ELSE                         #No.TQC-7C0020
                       NEXT FIELD rvv32          #No.TQC-7C0020
                    END IF                       #No.TQC-7C0020
                 END IF    #MOD-C30590 -- add
              END IF
              IF NOT cl_null(g_rvv[l_ac].pmm43) THEN
                 LET l_pmm43 = g_rvv[l_ac].pmm43
              END IF
              IF g_sma.sma115 = 'Y' THEN
                 IF NOT cl_null(g_rvv[l_ac].rvv31) THEN
                    CALL s_chk_va_setting(g_rvv[l_ac].rvv31)
                         RETURNING g_flag,g_ima906,g_ima907
                    IF g_flag=1 THEN
                       NEXT FIELD rvv05
                    END IF
                    CALL s_chk_va_setting1(g_rvv[l_ac].rvv31)
                         RETURNING g_flag,g_ima908
                    IF g_flag=1 THEN
                       NEXT FIELD rvv05
                    END IF
                    IF g_ima906 = '3' THEN
                       LET g_rvv[l_ac].rvv83=g_ima907
                    END IF
                 END IF
                 IF g_sma.sma116 MATCHES '[13]' THEN    #No.FUN-610076
                    IF cl_null(g_rvv[l_ac].rvv86) THEN
                       LET g_rvv[l_ac].rvv86=g_ima908
                    END IF
                 END IF
                 #CALL t720_set_required(p_cmd)   #MOD-A40166
              END IF
              CALL t720_set_required(p_cmd)   #MOD-A40166
           END IF 
#FUN-A60035 ---MARK BEGIN
#         #No.FUN-A50054 -BEGIN-----
#          IF s_industry('slk') THEN
#             IF NOT cl_null(g_rvv[l_ac].rvv05) AND NOT cl_null(g_rvv[l_ac].rvv31) THEN
#                IF p_cmd='a' OR (p_cmd='u' AND g_rvv_t.rvv05 <> g_rvv[l_ac].rvv05) THEN
#                   DELETE FROM ata_file 
#                    WHERE ata01 = g_rvu.rvu01
#                      AND ata02 = g_rvv[l_ac].rvv02
#                      AND ata00 = g_prog
#                   DECLARE t720_gen_rvb_ata CURSOR FOR
#                    SELECT * FROM ata_file
#                     WHERE ata00 = 'apmt110' #g_prog1
#                       AND ata01 = g_rvu.rvu02 
#                       AND ata02 = g_rvv[l_ac].rvv05
#                   FOREACH t720_gen_rvb_ata  INTO l_ata.*
#                      IF STATUS THEN EXIT FOREACH END IF
#                      LET l_ata.ata00 = g_prog 
#                      LET l_ata.ata01 = g_rvu.rvu01
#                      LET l_ata.ata02 = g_rvv[l_ac].rvv02 
#                      SELECT MAX(ata03) INTO l_ata.ata03 FROM ata_file
#                       WHERE ata00 = g_prog
#                         AND ata01 = g_rvu.rvu02
#                      IF cl_null(l_ata.ata03) OR l_ata.ata03 = 0 THEN
#                         LET l_ata.ata03 = 1
#                      END IF
#                      INSERT INTO ata_file VALUES(l_ata.*)
#                   END FOREACH
#                END IF
#                CALL s_detail(g_prog,g_rvu.rvu01,g_rvv[l_ac].rvv02,g_rvv[l_ac].rvv31,'N')
#                   RETURNING g_rvv[l_ac].rvv17
#                DISPLAY BY NAME g_rvv[l_ac].rvv17
#                DISPLAY BY NAME g_rvv[l_ac].rvv31
#             END IF
#          END IF
#         #No.FUN-A50054 -END-------
#FUN-A60035 ---MARK END
 
       #BEFORE FIELD rvv32  #genero
           #當為製程委外時不寫 tlf,不 update ima,img 所以可不key 倉庫
           LET l_ec_sw = 'N'
           #IF g_rvu.rvu08='SUB' THEN   #MOD-B40046
           IF g_rvu.rvu08='SUB' AND NOT cl_null(g_rvv[l_ac].rvv36) AND NOT cl_null(g_rvv[l_ac].rvv37) THEN   #MOD-B40046
              SELECT pmn41,pmn43,pmn18,pmn32 INTO l_pmn41,l_pmn43,l_pmn18,l_pmn32 FROM pmn_file
                 WHERE pmn01 = g_rvv[l_ac].rvv36 AND pmn02 = g_rvv[l_ac].rvv37
              IF STATUS THEN
                 CALL cl_err3("sel","pmn_file",g_rvv[l_ac].rvv36,g_rvv[l_ac].rvv37,STATUS,"","sel pmn_file",1)  #No.FUN-660129
              END IF
              IF NOT cl_null(l_pmn41) AND l_pmn43>0 THEN   #W/O<>'' &製程序>0
                 LET l_ec_sw='Y'
              END IF
           END IF
           IF l_ec_sw='Y' THEN
              LET g_rvv[l_ac].rvv32=' '
              LET g_rvv[l_ac].rvv33=' '
              LET g_rvv[l_ac].rvv34=' '
              DISPLAY BY NAME g_rvv[l_ac].rvv32
              DISPLAY BY NAME g_rvv[l_ac].rvv33
              DISPLAY BY NAME g_rvv[l_ac].rvv34
              CALL cl_err('','mfg-021',0)
           END IF
         #FUN-B40083 --begin
           IF NOT cl_null(g_rvv[l_ac].rvv36) AND NOT cl_null(g_rvv[l_ac].rvv37) THEN
              SELECT pmn123 INTO g_rvv[l_ac].pmn123    #FUN-B40083
                FROM pmn_file
               WHERE pmn01 = g_rvv[l_ac].rvv36
                 AND pmn02 = g_rvv[l_ac].rvv37
              IF NOT cl_null(g_rvv[l_ac].pmn123) THEN
                 SELECT mse02 INTO g_rvv[l_ac].mse02
                   FROM mse_file WHERE mse01= g_rvv[l_ac].pmn123
              ELSE
                 LET g_rvv[l_ac].pmn123 = ''
                 LET g_rvv[l_ac].mse02 = ''
              END IF
           END IF
         #FUN-B40083 --end
           CALL t720_set_no_entry_b(p_cmd)
           CALL t720_set_no_entry_rvv34()   #FUN-B50096
           CALL t720_set_no_entry_rvv32()  #MOD-C30902
 
        BEFORE FIELD rvv31
           CALL t720_set_no_required(p_cmd)
           CALL t720_set_entry_b(p_cmd)        #No.MOD-650055 add
          #TQC-C50130 -- add -- begin
           IF p_cmd = 'u' THEN
              CALL t720_set_no_entry_b(p_cmd)    
           END IF
          #TQC-C50130 -- add -- end
#&ifdef ICD   #FUN-B50096
           CALL t720_set_no_required_1()   #FUN-A40022
           CALL t720_set_entry_rvv34()     #FUN-B50096
#&endif       #FUN-B50096

        #FUN-BC0104---add---str
        AFTER FIELD rvv45
          IF NOT cl_null(g_rvv[l_ac].rvv45) AND p_cmd = 'a' THEN
              LET l_n = 0
              SELECT COUNT(*) INTO l_n FROM qcs_file 
                WHERE qcs00='1' AND qcs01=g_rvu.rvu02     
                AND qcs02=g_rvv[l_ac].rvv05
                AND qcs05=g_rvv[l_ac].rvv45  AND qcs14='Y'
       
             IF l_n = 0 THEN
                CALL cl_err('','apm-805',0)
                NEXT FIELD rvv45
             END IF
             IF NOT t720_rvv45_46_47_check() THEN
                CALL cl_err(g_rvv[l_ac].rvv45,'apm-808',0)
                NEXT FIELD rvv45 
             END IF
          END IF
           CALL t720_set_comp_required(g_rvv[l_ac].rvv45,g_rvv[l_ac].rvv46,g_rvv[l_ac].rvv47)
           IF NOT cl_null(g_rvv[l_ac].rvv45) AND NOT cl_null(g_rvv[l_ac].rvv46) AND NOT cl_null(g_rvv[l_ac].rvv47) THEN
              IF NOT t720_qco_show() THEN
                 CALL cl_err('','apm-809',0)
                 NEXT FIELD rvv45
              END IF
              CALL t720_img09() RETURNING l_img09
              CALL s_umfchk(g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv35,l_img09)
                   RETURNING l_i,g_rvv[l_ac].rvv35_fac
              CALL t720_qcl05_check() RETURNING l_qcl05
              IF (l_qcl05 = '0' OR l_qcl05 = '2') AND g_sma.sma115='N' THEN
                 IF NOT t720_rvv17(p_cmd) THEN
                    NEXT FIELD rvv17
                 END IF
              END IF
              IF l_qcl05 = '1' OR l_qcl05 = '2' THEN
                 IF NOT t720_rvv87(p_cmd) THEN
                    NEXT FIELD rvv87
                 END IF
              END IF
           END IF  


         AFTER FIELD rvv46
            IF NOT cl_null(g_rvv[l_ac].rvv46) AND p_cmd = 'a' THEN
               IF NOT t720_rvv45_46_47_check() THEN
                CALL cl_err(g_rvv[l_ac].rvv46,'apm-808',0)
                NEXT FIELD rvv46
               END IF
               #TQC-C30048---add---str---
               LET l_n=0
               IF g_bgjob='N' OR cl_null(g_bgjob) THEN
                  IF (g_argv1='2' AND g_argv3='ICD') OR (g_argv1='2' AND g_argv3 !='SUB' AND g_argv3 !='TAP')
                     OR (g_argv1='2' AND g_argv3='SUB') OR (g_argv1='2' AND g_argv3='TAP') THEN
                     SELECT COUNT(*) INTO l_n FROM qcl_file
                                     WHERE qcl01 = g_rvv[l_ac].rvv46
                                      #AND qcl05 <>'3'     #FUN-CC0013 mark
                     IF l_n > 0 THEN
                        CALL cl_err('','apm-626',0)
                        NEXT FIELD rvv46
                     END IF 
                  #FUN-CC0013 mark begin---
                  #ELSE
                  #   SELECT COUNT(*) INTO l_n FROM qcl_file
                  #                   WHERE qcl01 = g_rvv[l_ac].rvv46
                  #                     AND qcl05 ='3'
                  #   IF l_n > 0 THEN
                  #      CALL cl_err('','apm-806',0)
                  #      NEXT FIELD rvv46
                  #   END IF 
                  #FUN-CC0013 mark end-----
                  END IF
               END IF
              #TQC-C30048---add---end---
            #TQC-C30048---mark---str---
            #  LET l_n = 0
            #  SELECT COUNT(*) INTO l_n FROM qcs_file,qco_file,qcl_file
            #                  WHERE qcs00='1' AND qcs14='Y' AND qco01=qcs01 
            #                  AND qco02=qcs02 AND qco05 = qcs05 AND qcl01 = qco03 AND qco01=g_rvu.rvu02 
            #                  AND qco02=g_rvv[l_ac].rvv05 AND qco03 = g_rvv[l_ac].rvv46
            #                  AND qco05=g_rvv[l_ac].rvv45  
            #                  AND qcl05 = '3'             
            #  IF l_n > 0 THEN
            #     CALL cl_err('','apm-806',0) 
            #     NEXT FIELD rvv46
            #  END IF
            #TQC-C30048---mark---end---
            END IF
            CALL t720_set_comp_required(g_rvv[l_ac].rvv45,g_rvv[l_ac].rvv46,g_rvv[l_ac].rvv47)
            CALL t720_qcl02_desc()
            IF NOT cl_null(g_rvv[l_ac].rvv45) AND NOT cl_null(g_rvv[l_ac].rvv46) AND NOT cl_null(g_rvv[l_ac].rvv47) THEN
               IF NOT t720_qco_show() THEN
                  CALL cl_err('','apm-809',0)
                  NEXT FIELD rvv46
               END IF
               CALL t720_img09() RETURNING l_img09
               CALL s_umfchk(g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv35,l_img09)
                      RETURNING l_i,g_rvv[l_ac].rvv35_fac
               CALL t720_qcl05_check() RETURNING l_qcl05
               IF (l_qcl05 = '0' OR l_qcl05 = '2') AND g_sma.sma115='N' THEN
                  IF NOT t720_rvv17(p_cmd) THEN
                     NEXT FIELD rvv17
                  END IF
               END IF
               IF l_qcl05 = '1' OR l_qcl05 = '2' THEN
                  IF NOT t720_rvv87(p_cmd) THEN
                     NEXT FIELD rvv87
                  END IF
               END IF
            END IF

        AFTER FIELD rvv47
           IF NOT cl_null(g_rvv[l_ac].rvv47) AND p_cmd = 'a' THEN
              IF NOT t720_rvv45_46_47_check() THEN
                CALL cl_err(g_rvv[l_ac].rvv47,'apm-808',0)
                NEXT FIELD rvv47
              END IF
            #TQC-C30048---mark---str-------
            # LET l_n = 0
            # SELECT COUNT(*) INTO l_n FROM qcs_file,qco_file,qcl_file
            #                  WHERE qcs00='1' AND qcs14='Y' AND qco01=qcs01
            #                  AND qco02=qcs02 AND qco05=qcs05 AND qcl01 = qco03 AND qco01=g_rvu.rvu02
            #                  AND qco02=g_rvv[l_ac].rvv05 AND qco04 = g_rvv[l_ac].rvv47 
            #                  AND qco05=g_rvv[l_ac].rvv45 
            #                  AND qcl05 <> '3'           
            # IF l_n = 0 THEN
            #    CALL cl_err('','apm-807',0)
            #    NEXT FIELD rvv47
            # END IF
            #TQC-C30048---mark---end-------
           END IF
           CALL t720_set_comp_required(g_rvv[l_ac].rvv45,g_rvv[l_ac].rvv46,g_rvv[l_ac].rvv47)
           IF NOT cl_null(g_rvv[l_ac].rvv45) AND NOT cl_null(g_rvv[l_ac].rvv46) AND NOT cl_null(g_rvv[l_ac].rvv47) THEN
              IF NOT t720_qco_show() THEN
                 CALL cl_err('','apm-809',0)
                 NEXT FIELD rvv47
              END IF
              CALL t720_img09() RETURNING l_img09
              CALL s_umfchk(g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv35,l_img09)
                     RETURNING l_i,g_rvv[l_ac].rvv35_fac
              CALL t720_qcl05_check() RETURNING l_qcl05
              IF (l_qcl05 = '0' OR l_qcl05 = '2') AND g_sma.sma115 = 'N' THEN
                 IF NOT t720_rvv17(p_cmd) THEN
                    NEXT FIELD rvv17
                 END IF
              END IF
              IF l_qcl05 = '1' OR l_qcl05 = '2' THEN
                 IF NOT t720_rvv87(p_cmd) THEN
                    NEXT FIELD rvv87
                 END IF
              END IF
           END IF
          #FUN-BC0104---add---end

        AFTER FIELD rvv31
#FUN-AA0059 ---------------------start----------------------------
          IF NOT cl_null(g_rvv[l_ac].rvv31) THEN
             IF NOT s_chk_item_no(g_rvv[l_ac].rvv31,"") THEN
                CALL cl_err('',g_errno,1)
                LET g_rvv[l_ac].rvv31= g_rvv_t.rvv31
                NEXT FIELD rvv31
             END IF
          END IF
#FUN-AA0059 ---------------------end-------------------------------
           #AFTER FIELD 處理邏輯修改為使用下面的函數來進行判斷，請參考相關代碼
           CALL t720_check_rvv31('rvv31',l_ac,p_cmd) RETURNING #No.MOD-660090
                 l_check_res
           IF NOT l_check_res THEN NEXT FIELD rvv31 END IF
 
          CALL t720_set_no_entry_b(p_cmd)
          CALL t720_set_required(p_cmd)   #MOD-A40166

           IF NOT cl_null(g_rvv[l_ac].rvv31) THEN
               IF g_rvv[l_ac].rvv31[1,4] != 'MISC' THEN
                  SELECT ima02,ima021,ima25,ima44 #CHI-AB0018 add ima44
                    INTO g_rvv[l_ac].rvv031,g_rvv[l_ac].ima021,g_ima25,g_ima44  #FUN-A10130 #CHI-AB0018 add g_ima44
                    FROM ima_file WHERE ima01=g_rvv[l_ac].rvv31 AND imaacti='Y'
                  IF STATUS THEN
                     CALL cl_err3("sel","ima_file",g_rvv[l_ac].rvv31,"",STATUS,"","sel ima",1)  #No.FUN-660129
                     NEXT FIELD rvv31
                  END IF
               END IF
               IF cl_null(g_rvu.rvu02) THEN
                  IF cl_null(g_rvu.rvu115) AND cl_null(g_rvu.rvu12) THEN #MOD-BC0262 add
                     SELECT pmc22,pmc47 INTO l_pmc22,l_pmm21 #FUN-960130
                       FROM pmc_file
                      WHERE pmc01 = g_rvu.rvu04
                     SELECT gec04 INTO l_pmm43
                       FROM gec_file
                      WHERE   gec01 = l_pmm21
                        AND   gec011 = '1'
                     #MOD-BC0262 mark start -----
                     #LET g_rvv[l_ac].pmm21 = l_pmm21
                     #LET g_rvv[l_ac].pmm43 = l_pmm43
                     #DISPLAY BY NAME g_rvv[l_ac].pmm21
                     #DISPLAY BY NAME g_rvv[l_ac].pmm43
                     #MOD-BC0262 mark end    -----
               #MOD-BC0262 ----- modify start -----
                  ELSE
                     LET l_pmm21 = g_rvu.rvu115
                     LET l_pmm43 = g_rvu.rvu12
                  END IF
               ELSE
                  LET l_pmm21 = g_rvu.rvu115
                  LET l_pmm43 = g_rvu.rvu12
               #MOD-BC0262 ----- modify end   -----
               END IF
               #MOD-BC0262 ----- modify start -----
               LET g_rvv[l_ac].pmm21 = l_pmm21
               LET g_rvv[l_ac].pmm43 = l_pmm43
               DISPLAY BY NAME g_rvv[l_ac].pmm21
               DISPLAY BY NAME g_rvv[l_ac].pmm43
               #MOD-BC0262 ----- modify end -----
               IF cl_null(g_rvv[l_ac].rvv35) OR
                  (g_rvv[l_ac].rvv31 !=g_rvv_t.rvv31)
               THEN
                  LET g_rvv[l_ac].rvv35=g_ima44 #FUN-A10130  #CHI-AB0018 mod g_ima25->g_ima44
               END IF
               CALL t720_set_rvv89()
               IF g_rvv_t.rvv31 != g_rvv[l_ac].rvv31 THEN #MOD-C50254 add
                  CALL t720_get_price()
               END IF #MOD-C50254 add
               DISPLAY BY NAME g_rvv[l_ac].rvv35
               DISPLAY BY NAME g_rvv[l_ac].rvv031
               DISPLAY BY NAME g_rvv[l_ac].ima021
           END IF
           #FUN-A20017--begin--add------
        SELECT pmn04,ima903 INTO l_ima01,l_ima903
             FROM ima_file,pmn_file
            WHERE pmn01 = g_rvv[l_ac].rvv36
              AND pmn02 = g_rvv[l_ac].rvv37
              AND ima01 = pmn04
           IF g_argv3 = 'SUB' AND NOT cl_null(g_rvv[l_ac].rvv31) 
              AND NOT cl_null(g_rvv[l_ac].rvv37) THEN  
              IF g_rvv[l_ac].rvv31 <> l_ima01 THEN
                 IF l_ima903 = 'N' OR cl_null(l_ima903) THEN
                    #不是聯產品,不能相等
                    LET g_rvv[l_ac].rvv31 = g_rvv_t.rvv31
                    NEXT FIELD rvv31
                 ELSE
                    SELECT COUNT(*) INTO g_cnt FROM bmm_file
                     WHERE bmm01 = l_ima01 AND bmm03 = g_rvv[l_ac].rvv31
                       AND bmm05 = 'Y'
                    IF g_cnt = 0 OR cl_null(g_cnt) THEN
                       LET g_rvv[l_ac].rvv31 = g_rvv_t.rvv31
                       CALL cl_err('','TSD0017',0)
                       NEXT FIELD rvv31
                    ELSE
                       SELECT ima02,ima021 INTO g_rvv[l_ac].rvv031,g_rvv[l_ac].ima021 FROM ima_file
                        WHERE ima01 = g_rvv[l_ac].rvv05
                    END IF
                 END IF
              END IF
           END IF
        #FUN-A20017--end--add-----
#&ifdef ICD  #FUN-B50096
        CALL t720_set_required_1(p_cmd) #FUN-A40022
        CALL t720_set_no_entry_rvv34()  #FUN-B50096
        CALL t720_set_no_entry_rvv32()  #MOD-C30902
#&endif      #FUN-B50096
          #FUN-A60035 ---MARK BEGIN
          ##No.FUN-A50054 -BEGIN-----
          #IF s_industry('slk') THEN 
          #   SELECT ima151 INTO l_ima151
          #     FROM ima_file
          #    WHERE ima01 = g_rvv[l_ac].rvviicd03   #g_rvv[g_cnt].rvviicd03   #FUN-A60035
          #   IF NOT cl_null(g_rvv[l_ac].rvv31) AND l_ima151='Y' AND g_sma.sma120='Y' THEN
          #      CALL s_detail(g_prog,g_rvu.rvu01,g_rvv[l_ac].rvv02,g_rvv[l_ac].rvv31,'N')
          #         RETURNING g_rvv[l_ac].rvv17
          #      DISPLAY BY NAME g_rvv[l_ac].rvv17
          #   END IF
          #ELSE
          #END IF
          ##No.FUN-A50054 -END-------
          #FUN-A60035 ---MARK END
 
        #當sma908 <> 'Y'的時候,即不准通過單身來新增子料件,這時
        #對于采用料件多屬性新機制(與單據性質綁定)的分支來說,各個明細屬性欄位都
        #變NOENTRY的, 只能通過在母料件欄位開窗來選擇子料件,并且母料件本身也不允許
        #接受輸入,而只能開窗,所以這里要進行一個特殊的處理,就是一進att00母料件
        #欄位的時候就auto開窗,開完窗之后直接NEXT FIELD以避免用戶亂動
        #其他分支就不需要這么麻煩了
        BEFORE FIELD att00
 
              #根據子料件找到母料件及各個屬性
              SELECT imx00,imx01,imx02,imx03,imx04,imx05,
                     imx06,imx07,imx08,imx09,imx10
              INTO g_rvv[l_ac].att00, g_rvv[l_ac].att01, g_rvv[l_ac].att02,
                   g_rvv[l_ac].att03, g_rvv[l_ac].att04, g_rvv[l_ac].att05,
                   g_rvv[l_ac].att06, g_rvv[l_ac].att07, g_rvv[l_ac].att08,
                   g_rvv[l_ac].att09, g_rvv[l_ac].att10
              FROM imx_file
              WHERE imx000 = g_rvv[l_ac].rvv31
              #賦值所有屬性
              LET g_rvv[l_ac].att01_c = g_rvv[l_ac].att01
              LET g_rvv[l_ac].att02_c = g_rvv[l_ac].att02
              LET g_rvv[l_ac].att03_c = g_rvv[l_ac].att03
              LET g_rvv[l_ac].att04_c = g_rvv[l_ac].att04
              LET g_rvv[l_ac].att05_c = g_rvv[l_ac].att05
              LET g_rvv[l_ac].att06_c = g_rvv[l_ac].att06
              LET g_rvv[l_ac].att07_c = g_rvv[l_ac].att07
              LET g_rvv[l_ac].att08_c = g_rvv[l_ac].att08
              LET g_rvv[l_ac].att09_c = g_rvv[l_ac].att09
              LET g_rvv[l_ac].att10_c = g_rvv[l_ac].att10
              #顯示所有屬性
              DISPLAY BY NAME
                g_rvv[l_ac].att01, g_rvv[l_ac].att01_c,
                g_rvv[l_ac].att02, g_rvv[l_ac].att02_c,
                g_rvv[l_ac].att03, g_rvv[l_ac].att03_c,
                g_rvv[l_ac].att04, g_rvv[l_ac].att04_c,
                g_rvv[l_ac].att05, g_rvv[l_ac].att05_c,
                g_rvv[l_ac].att06, g_rvv[l_ac].att06_c,
                g_rvv[l_ac].att07, g_rvv[l_ac].att07_c,
                g_rvv[l_ac].att08, g_rvv[l_ac].att08_c,
                g_rvv[l_ac].att09, g_rvv[l_ac].att09_c,
                g_rvv[l_ac].att10, g_rvv[l_ac].att10_c
 
        #以下是為料件多屬性機制新增的20個屬性欄位的AFTER FIELD代碼
        #下面是十個輸入型屬性欄位的判斷語句
        AFTER FIELD att00
            #檢查att00里面輸入的母料件是否是符合對應屬性組的母料件
            SELECT COUNT(ima01) INTO l_count FROM ima_file
              WHERE ima01 = g_rvv[l_ac].att00 AND imaag = lg_smy62
            IF l_count = 0 THEN
               CALL cl_err_msg('','aim-909',lg_smy62,0)
               NEXT FIELD att00
            END IF
 
            #如果設置為不允許新增
               CALL t720_check_rvv31('imx00',l_ac,p_cmd) RETURNING #No.MOD-660090
                 l_check_res
               IF NOT l_check_res THEN NEXT FIELD att00 END IF
 
        AFTER FIELD att01
            CALL t720_check_att0x(g_rvv[l_ac].att01,1,l_ac,p_cmd) RETURNING #No.MOD-660090
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att01 END IF
        AFTER FIELD att02
            CALL t720_check_att0x(g_rvv[l_ac].att02,2,l_ac,p_cmd) RETURNING #No.MOD-660090
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att02 END IF
        AFTER FIELD att03
            CALL t720_check_att0x(g_rvv[l_ac].att03,3,l_ac,p_cmd) RETURNING #No.MOD-660090
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att03 END IF
        AFTER FIELD att04
            CALL t720_check_att0x(g_rvv[l_ac].att04,4,l_ac,p_cmd) RETURNING #No.MOD-660090
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att04 END IF
        AFTER FIELD att05
            CALL t720_check_att0x(g_rvv[l_ac].att05,5,l_ac,p_cmd) RETURNING #No.MOD-660090
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att05 END IF
        AFTER FIELD att06
            CALL t720_check_att0x(g_rvv[l_ac].att06,6,l_ac,p_cmd) RETURNING #No.MOD-660090
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att06 END IF
        AFTER FIELD att07
            CALL t720_check_att0x(g_rvv[l_ac].att07,7,l_ac,p_cmd) RETURNING #No.MOD-660090
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att07 END IF
        AFTER FIELD att08
            CALL t720_check_att0x(g_rvv[l_ac].att08,8,l_ac,p_cmd) RETURNING #No.MOD-660090
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att08 END IF
        AFTER FIELD att09
            CALL t720_check_att0x(g_rvv[l_ac].att09,9,l_ac,p_cmd) RETURNING #No.MOD-660090
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att09 END IF
        AFTER FIELD att10
            CALL t720_check_att0x(g_rvv[l_ac].att10,10,l_ac,p_cmd) RETURNING #No.MOD-660090
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att10 END IF
        #下面是十個輸入型屬性欄位的判斷語句
        AFTER FIELD att01_c
            CALL t720_check_att0x_c(g_rvv[l_ac].att01_c,1,l_ac,p_cmd) RETURNING #No.MOD-660090
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att01_c END IF
        AFTER FIELD att02_c
            CALL t720_check_att0x_c(g_rvv[l_ac].att02_c,2,l_ac,p_cmd) RETURNING #No.MOD-660090
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att02_c END IF
        AFTER FIELD att03_c
            CALL t720_check_att0x_c(g_rvv[l_ac].att03_c,3,l_ac,p_cmd) RETURNING #No.MOD-660090
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att03_c END IF
        AFTER FIELD att04_c
            CALL t720_check_att0x_c(g_rvv[l_ac].att04_c,4,l_ac,p_cmd) RETURNING #No.MOD-660090
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att04_c END IF
        AFTER FIELD att05_c
            CALL t720_check_att0x_c(g_rvv[l_ac].att05_c,5,l_ac,p_cmd) RETURNING #No.MOD-660090
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att05_c END IF
        AFTER FIELD att06_c
            CALL t720_check_att0x_c(g_rvv[l_ac].att06_c,6,l_ac,p_cmd) RETURNING #No.MOD-660090
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att06_c END IF
        AFTER FIELD att07_c
            CALL t720_check_att0x_c(g_rvv[l_ac].att07_c,7,l_ac,p_cmd) RETURNING #No.MOD-660090
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att07_c END IF
        AFTER FIELD att08_c
            CALL t720_check_att0x_c(g_rvv[l_ac].att08_c,8,l_ac,p_cmd) RETURNING #No.MOD-660090
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att08_c END IF
        AFTER FIELD att09_c
            CALL t720_check_att0x_c(g_rvv[l_ac].att09_c,9,l_ac,p_cmd) RETURNING #No.MOD-660090
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att09_c END IF
        AFTER FIELD att10_c
            CALL t720_check_att0x_c(g_rvv[l_ac].att10_c,10,l_ac,p_cmd) RETURNING #No.MOD-660090
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att10_c END IF
 
        AFTER FIELD rvv35             #單位
 
           IF NOT cl_null(g_rvv[l_ac].rvv35) THEN
              CALL t720_unit(g_rvv[l_ac].rvv35)
              IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rvv[l_ac].rvv35,g_errno,0)
                  NEXT FIELD rvv35
              END IF
              CALL t720_set_rvv87()     #No.MOD-770158 add
              IF g_rvv_t.rvv31 != g_rvv[l_ac].rvv31 THEN #MOD-C50254 add
                 CALL t720_get_price()     #NO.FUN-940083
              END IF #MOD-C50254 add
              #No.FUN-BB0086--add--begin--
              IF NOT cl_null(g_rvv[l_ac].rvv17) THEN
                 IF cl_null(g_rvv_t.rvv17) OR cl_null(g_rvv35_t) OR g_rvv_t.rvv17 != g_rvv[l_ac].rvv17 OR g_rvv35_t != g_rvv[l_ac].rvv35 THEN
                    LET g_rvv[l_ac].rvv17=s_digqty(g_rvv[l_ac].rvv17,g_rvv[l_ac].rvv35)
                    DISPLAY BY NAME g_rvv[l_ac].rvv17
                 END IF
              END IF
              LET g_rvv35_t = g_rvv[l_ac].rvv35
              #No.FUN-BB0086--add--end--
          END IF
        AFTER FIELD rvv32              #倉庫
           #-----MOD-A40166---------
           #IF cl_null(g_rvv[l_ac].rvv32) AND l_ec_sw='N'  THEN
           #   CALL cl_err('','apm1023',0)   #MOD-9C0321
           #   NEXT FIELD rvv32
           #END IF
           #-----END MOD-A40166-----
           IF g_rvv[l_ac].rvv32 IS NULL THEN
               LET g_rvv[l_ac].rvv32=' '
           END IF
           IF NOT cl_null(g_rvv[l_ac].rvv32) THEN
              #FUN-C20002--start add-----------------------------------
             IF g_azw.azw04 = '2' THEN 
                SELECT ima154 INTO l_ima154
                  FROM ima_file
                 WHERE ima01 = g_rvv[l_ac].rvv31
                
                IF l_ima154 = 'Y' AND g_rvv[l_ac].rvv31[1,4] <> 'MISC' THEN
                   SELECT rcj03 INTO l_rcj03
                     FROM rcj_file
                    WHERE rcj00 = '0'
                   #FUN-C90049 marl begin---
                   #SELECT rtz07,rtz08 INTO l_rtz07,l_rtz08
                   #  FROM rtz_file
                   # WHERE rtz01 = g_plant
                   #FUN-C90049 mark end-----
                   CALL s_get_defstore(g_plant,g_rvv[l_ac].rvv31) RETURNING l_rtz07,l_rtz08    #FUN-C90049 add
                   IF l_rcj03 = '1' THEN 
                      IF g_rvv[l_ac].rvv32 <> l_rtz07 THEN
                         CALL cl_err('','aim1142',0)
                         LET g_rvv[l_ac].rvv32 = g_rvv_t.rvv32
                         NEXT FIELD rvv32
                      END IF
                   ELSE
                      IF g_rvv[l_ac].rvv32 <> l_rtz08 THEN
                         CALL cl_err('','aim1143',0)
                         LET g_rvv[l_ac].rvv32 = g_rvv_t.rvv32
                         NEXT FIELD rvv32
                      END IF
                   END IF
                END IF
             END IF 
              #FUN-C20002--end add-------------------------------------
              #No.FUN-AA0049--begin
               IF NOT s_chk_ware(g_rvv[l_ac].rvv32) THEN
                  NEXT FIELD rvv32
               END IF 
              #No.FUN-AA0049--end           
              #FUN-B40098 Begin---
              #IF cl_null(g_errno) AND g_azw.azw04='2' AND g_rvu.rvu21 = '3' THEN  #FUN-B60150 MARK
               IF cl_null(g_errno) AND g_azw.azw04='2' THEN #FUN-B60150 ADD
                  IF (g_rvu.rvu21 = '3' OR (g_rvu.rvu21 = '2' AND g_sma.sma146 = '2'))THEN #FUN-B60150 ADD
                     LET g_cnt = 0
                     SELECT count(*) INTO g_cnt FROM imd_file
                      WHERE imd01 = g_rvv[l_ac].rvv32
                        AND imd01 IN (SELECT jce02 FROM jce_file)
                     IF g_cnt = 0 THEN
                        IF g_rvu.rvu21 = '3' THEN       #FUN-B60150 ADD
                           CALL cl_err('','apm-147',0)
                        ELSE                            #FUN-B60150 ADD
                           CALL cl_err('','apm-153',0)  #FUN-B60150 ADD
                        END IF                          #FUN-B60150 ADD
                        NEXT FIELD rvv32
                     END IF
                  END IF                                #FUN-B60150 ADD
                  #FUN-B60150 ADD - BEGIN ----------------------------------
                  IF g_rvu.rvu21 = '2' AND g_sma.sma146 = '1' THEN
                     LET g_cnt = 0
                     SELECT count(*) INTO g_cnt FROM imd_file
                      WHERE imd01 = g_rvv[l_ac].rvv32
                        AND imd01 NOT IN (SELECT jce02 FROM jce_file)
                     IF g_cnt = 0 THEN
                       CALL cl_err('','apm-154',0)
                       NEXT FIELD rvv32
                     END IF
                  END IF
                  #FUN-B60150 ADD - END ------------------------------------
               END IF
              #FUN-B40098 End-----
               CALL t720_check_rvv32()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD rvv32
               END IF
               #FUN-BC0104---add---str
               IF NOT cl_null(g_rvv[l_ac].rvv46) THEN
                  IF NOT t720_rvv32_check() THEN
                     CALL cl_err('','aqc-524',0)
                     NEXT FIELD rvv32
                  END IF
               END IF
               #FUN-BC0104---add---end
               IF g_rvv[l_ac].rvv31[1,4] != 'MISC' AND g_rvu.rvu00!='2' THEN  #料號
                  #CHI-CC0014 ----------sta
                 #IF NOT cl_null(g_rvv[l_ac].rvv33) THEN
                  IF NOT s_chksmz(g_rvv[l_ac].rvv31, g_rvu.rvu01,
                         g_rvv[l_ac].rvv32, g_rvv[l_ac].rvv33) THEN
                     NEXT FIELD rvv32
                  END IF
                 #END IF
                  #CHI-CC0014 ----------end
                  #------>check-1  檢查該料是否可收至該倉
                  IF NOT s_imfchk1(g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv32) THEN
                     CALL cl_err('s_imfchk1:','mfg9036',0) NEXT FIELD rvv32
                  END IF
                  #------>check-2  檢查倉庫須存在否
                  CALL s_stkchk(g_rvv[l_ac].rvv32,'A') RETURNING l_code
                  IF NOT l_code THEN
                     CALL cl_err('s_stkchk:','mfg1100',0) NEXT FIELD rvv32
                  END IF
                  #------>check-3  檢查是否為可用倉
                  CALL s_swyn(g_rvv[l_ac].rvv32) RETURNING sn1,sn2
                 #IF sn1=1 AND g_rvv[l_ac].rvv32 != g_rvv_t.rvv32 THEN  #MOD-D30080 mark
                  IF sn1=1 THEN           #MOD-D30080 add
                     IF NOT cl_null(g_rvv[l_ac].rvv32) OR g_rvv[l_ac].rvv32 != g_rvv_t.rvv32 THEN  #MOD-D30080 add
                        LET g_rvv_t.rvv32=g_rvv[l_ac].rvv32
                        CALL cl_err(g_rvv[l_ac].rvv32,'mfg6080',0) NEXT FIELD rvv32
                        NEXT FIELD rvv32  #MOD-D30080 add
                     END IF               #MOD-D30080 add
                  ELSE
                    #IF sn2=2 AND g_rvv[l_ac].rvv32 != g_rvv_t.rvv32 THEN  #MOD-D30080 mark
                     IF sn2=2 THEN  #MOD-D30080 add
                        IF NOT cl_null(g_rvv[l_ac].rvv32) OR g_rvv[l_ac].rvv32 != g_rvv_t.rvv32 THEN  #MOD-D30080 add
                           CALL cl_err(g_rvv[l_ac].rvv32,'mfg6085',0)
                           LET g_rvv_t.rvv32=g_rvv[l_ac].rvv32
                           NEXT FIELD rvv32
                        END IF      #MOD-D30080 add
                     END IF
                  END IF
                  LET sn1=0 LET sn2=0
                  
                 #NEXT FIELD rvv33        #No.CHI-920041     #TQC-C70207 mark
               END IF
           END IF
 
        AFTER FIELD rvv33              #儲位
           #BugNo:5626 控管是否為全型空白
           IF g_rvv[l_ac].rvv33 = '　' OR cl_null(g_rvv[l_ac].rvv33) THEN #全型空白  #MOD-940378
              LET g_rvv[l_ac].rvv33 = ' '
           END IF
           IF NOT cl_null(g_rvv[l_ac].rvv33) THEN
               CALL t720_check_rvv32()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD rvv32
               END IF
           END IF
           LET l_ec_sw = 'N'
           #IF g_rvu.rvu08='SUB' THEN   #MOD-B40046
           IF g_rvu.rvu08='SUB' AND NOT cl_null(g_rvv[l_ac].rvv36) AND NOT cl_null(g_rvv[l_ac].rvv37) THEN   #MOD-B40046
              SELECT pmn41,pmn43,pmn18,pmn32 INTO l_pmn41,l_pmn43,l_pmn18,l_pmn32 FROM pmn_file
                 WHERE pmn01 = g_rvv[l_ac].rvv36 AND pmn02 = g_rvv[l_ac].rvv37
              IF STATUS THEN
                 CALL cl_err3("sel","pmn_file",g_rvv[l_ac].rvv36,g_rvv[l_ac].rvv37,STATUS,"","sel pmn_file",1)  #No.FUN-660129
              END IF
              IF NOT cl_null(l_pmn41) AND l_pmn43>0 THEN   #W/O<>'' &製程序>0
                 LET l_ec_sw='Y'
              END IF
           END IF
          #IF g_rvv[l_ac].rvv31[1,4] != 'MISC' AND g_rvu.rvu00!='2' AND l_ec_sw='N'  THEN   #CHI-CC0014
           IF NOT cl_null(g_rvv[l_ac].rvv32) AND g_rvv[l_ac].rvv31[1,4] != 'MISC' AND g_rvu.rvu00!='2' AND l_ec_sw='N'  THEN   #CHI-CC0014
           #------------------------------------ 檢查料號預設倉儲及單別預設倉儲
              IF NOT s_chksmz(g_rvv[l_ac].rvv31, g_rvu.rvu01,
                              g_rvv[l_ac].rvv32, g_rvv[l_ac].rvv33) THEN
                  NEXT FIELD rvv32
              END IF
              #------>check-1  檢查該料是否可收至該倉/儲位
              IF NOT s_imfchk(g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv32,
                              g_rvv[l_ac].rvv33) THEN
                 CALL cl_err(g_rvv[l_ac].rvv33,'mfg6095',0) NEXT FIELD rvv33
              END IF
              #------>check-2  檢查該倉庫/儲位是否存在
              IF g_rvv[l_ac].rvv33 IS NOT NULL THEN
                 CALL s_hqty(g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv32,
                             g_rvv[l_ac].rvv33)
                      RETURNING g_cnt,g_imf04,g_imf05
                 IF g_imf04 IS NULL THEN LET g_imf04=0 END IF
                 CALL s_lwyn(g_rvv[l_ac].rvv32,g_rvv[l_ac].rvv33)
                      RETURNING sn1,sn2    #可用否
              IF g_rvu.rvu00 <> '3' THEN  #CHI-840043 add
                 IF sn2 = 2 THEN
                    IF g_pmn38 = 'Y' THEN CALL cl_err('','mfg9132',0) END IF
                 ELSE
                    IF g_pmn38 = 'N' THEN CALL cl_err('','mfg9131',0) END IF
                 END IF
                 LET sn1=0 LET sn2=0
              END IF   #CHI-840043 add
              END IF
              IF g_rvv[l_ac].rvv33 IS NULL THEN LET g_rvv[l_ac].rvv33=' ' END IF
             #NEXT FIELD rvv34         #MOD-940128    #TQC-C70207 mark
           END IF
#FUN-B50096 ------------Begin------------
           IF NOT cl_null(g_rvv[l_ac].rvv31) THEN
              SELECT ima159 INTO l_ima159 FROM ima_file
               WHERE ima01 = g_rvv[l_ac].rvv31
              IF l_ima159 = '2' THEN
                 CASE t720_b_rvv34_inschk()
                    WHEN "rvv32"  NEXT FIELD rvv32
                    WHEN "rvv34"  NEXT FIELD rvv33
                 END CASE
              END IF
           END IF
#FUN-B50096 ------------End--------------
 
        AFTER FIELD rvv34              #批號

        #FUN-B50096 -------------Begin------------
           CASE t720_b_rvv34_inschk()
              WHEN "rvv32"  NEXT FIELD rvv32
              WHEN "rvv34"  NEXT FIELD rvv34
           END CASE
        #FUN-B50096 -------------End--------------

#FUN-B50096 --------------Begin-------------------
#           #BugNo:5626 控管是否為全型空白
#           IF g_rvv[l_ac].rvv34 = '　' THEN #全型空白
#              LET g_rvv[l_ac].rvv34 = ' '
#           END IF
#           LET l_flag=TRUE  #FUN-810038
#&ifdef ICD
#           #FUN-A40022----begin--add---------------
#            IF NOT cl_null(g_rvv[l_ac].rvv31) THEN
#               LET l_imaicd13=''
#               SELECT imaicd13 INTO l_imaicd13
#                 FROM imaicd_file
#                WHERE imaicd00 = g_rvv[l_ac].rvv31
#               IF l_imaicd13 = 'Y' AND cl_null(g_rvv[l_ac].rvv34) THEN
#                  CALL cl_err(g_rvv[l_ac].rvv31,'aim-034',1)
#                  NEXT FIELD rvv34
#               END IF
#            END IF
#            #FUN-A40022--end--add------------------
#           #若已有ida存在不可修改
#           IF g_rvv[l_ac].rvv34 IS NULL THEN LET g_rvv[l_ac].rvv34 =' ' END IF
#           IF p_cmd = 'u' AND NOT cl_null(g_rvv[l_ac].rvv34) THEN
#              IF g_rvv_t.rvv34 <> g_rvv[l_ac].rvv34 THEN
#                 CALL t720_ind_icd_chk_icd()
#                 IF NOT cl_null(g_errno) THEN
#                    CALL cl_err('',g_errno,0)
#                    LET g_rvv[l_ac].rvv34 = g_rvv_t.rvv34
#                    NEXT FIELD rvv34
#                 END IF
#              END IF
#           END IF
#           #委外tky非最終站的不檢查(rvviicd07='Y')
#           IF b_rvvi.rvviicd07='Y' THEN
#              LET l_flag=FALSE
#           END IF
#&endif
#           LET l_ec_sw = 'N'
#           #IF g_rvu.rvu08='SUB' THEN   #MOD-B40046
#           IF g_rvu.rvu08='SUB' AND NOT cl_null(g_rvv[l_ac].rvv36) AND NOT cl_null(g_rvv[l_ac].rvv37) THEN   #MOD-B40046
#              SELECT pmn41,pmn43,pmn18,pmn32 INTO l_pmn41,l_pmn43,l_pmn18,l_pmn32 FROM pmn_file
#                 WHERE pmn01 = g_rvv[l_ac].rvv36 AND pmn02 = g_rvv[l_ac].rvv37
#              IF STATUS THEN
#                 CALL cl_err3("sel","pmn_file",g_rvv[l_ac].rvv36,g_rvv[l_ac].rvv37,STATUS,"","sel pmn_file",1)  #No.FUN-660129
#              END IF
#              IF NOT cl_null(l_pmn41) AND l_pmn43>0 THEN   #W/O<>'' &製程序>0
#                 LET l_ec_sw='Y'
#              END IF
#           END IF
#           IF g_rvv[l_ac].rvv31[1,4] != 'MISC' AND g_rvu.rvu00!='2' AND l_flag AND l_ec_sw='N'  #FUN-810038
#              AND NOT (g_rvu.rvu00='3' AND g_rvv[l_ac].rvv17=0) THEN   #MOD-A40166
#              IF g_rvv[l_ac].rvv34 IS NULL THEN LET g_rvv[l_ac].rvv34=' ' END IF
#              SELECT COUNT(*) INTO l_cnt FROM rvv_file
#               WHERE rvv01 = g_rvu.rvu01  #同一張單不可有同料,倉,儲,批之資料
#                 AND rvv31 = g_rvv[l_ac].rvv31 AND rvv32 = g_rvv[l_ac].rvv32
#                 AND rvv33 = g_rvv[l_ac].rvv33 AND rvv34 = g_rvv[l_ac].rvv34
#                 AND rvv02 != g_rvv[l_ac].rvv02
#              IF l_cnt > 0 THEN
#                 CALL cl_err('','mfg9146',0) #NEXT FIELD rvv32
#              END IF
#              SELECT COUNT(*) INTO g_cnt FROM img_file
#               WHERE img01 = g_rvv[l_ac].rvv31   #料號
#                 AND img02 = g_rvv[l_ac].rvv32   #倉庫
#                 AND img03 = g_rvv[l_ac].rvv33   #儲位
#                 AND img04 = g_rvv[l_ac].rvv34   #批號
#                 AND img18 < g_rvu.rvu03
#              IF g_cnt > 0 THEN    #大於有效日期
#                 call cl_err('','aim-400',0)   #須修改
#                 NEXT FIELD rvv32
#              END IF
#              SELECT img07,img10,img09 INTO g_img07,g_img10,g_img09
#                FROM img_file   #採購單位,庫存數量,庫存單位
#               WHERE img01=g_rvv[l_ac].rvv31 AND img02=g_rvv[l_ac].rvv32
#                 AND img03=g_rvv[l_ac].rvv33 AND img04=g_rvv[l_ac].rvv34
#              IF (g_rvu.rvu00='1' AND STATUS=100) OR
#                 (g_rvu.rvu00='3' AND STATUS=100) THEN
#                  IF g_sma.sma892[3,3] ='Y' THEN
#                    #IF NOT cl_confirm('mfg1401') THEN NEXT FIELD rvv34 END IF        #TQC-AB0412
#                     IF NOT cl_confirm('mfg1401') THEN NEXT FIELD rvv32 END IF        #TQC-AB0412
#                  END IF
#                    CALL s_add_img(g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv32,
#                                   g_rvv[l_ac].rvv33,g_rvv[l_ac].rvv34,
#                                   g_rvu.rvu01,      g_rvv[l_ac].rvv02,
#                                   g_rvu.rvu03)
#                 SELECT img07,img10,img09 INTO g_img07,g_img10,g_img09
#                   FROM img_file
#                  WHERE img01=g_rvv[l_ac].rvv31 AND img02=g_rvv[l_ac].rvv32
#                    AND img03=g_rvv[l_ac].rvv33 AND img04=g_rvv[l_ac].rvv34
#              END IF
#                #取對img換算率
#                CALL s_umfchk(g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv35,g_img09)
#                       RETURNING g_sw,g_rvv[l_ac].rvv35_fac
#                DISPLAY BY NAME g_rvv[l_ac].rvv35_fac
#                IF g_sw THEN
#                    #CALL cl_err(g_rvv[l_ac].rvv35,'apm-258',0) #MOD-580138
#                    #MOD-580138 add
#                   LET l_err_var = ""
#                   LET l_err_var = g_rvv[l_ac].rvv35 CLIPPED,'<--->',g_img09 CLIPPED
#                   CALL cl_err(l_err_var,'apm-258',1)
#                   NEXT FIELD rvv34
#                END IF
#           END IF
#           IF g_prog = 'apmt722' AND cl_null(g_rvu.rvu02) THEN 
#              SELECT ima918,ima921 INTO l_ima918,l_ima921 
#                FROM ima_file
#               WHERE ima01 = g_rvv[l_ac].rvv31
#                 AND imaacti = "Y"
#          
#              IF l_ima918 = "Y" OR l_ima921 = "Y" THEN
#                 SELECT COUNT(*) INTO l_n FROM rvbs_file
#                  WHERE rvbs00 = g_prog
#                    AND rvbs01 = g_rvu.rvu01
#                    AND rvbs02 = g_rvv[l_ac].rvv02
#                 IF l_n = 0 THEN
#                    CALL t720sub_ins_rvbs(g_prog,g_rvu.rvu01,g_rvv[l_ac].rvv02,
#                                       g_rvu.rvu02,g_rvv[l_ac].rvv05,g_rvv[l_ac].rvv31,
#                                       g_rvv[l_ac].rvv32,g_rvv[l_ac].rvv33,g_rvv[l_ac].rvv34,g_rvu.rvu02) #FUN-A10130
#                 END IF
#                 IF g_sma.sma90 = 'Y' THEN  #sel
#                    CALL s_lotin(g_prog,g_rvu.rvu01,g_rvv[l_ac].rvv02,0,
#                                 g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv35,g_img09,
#                                 g_rvv[l_ac].rvv35_fac,g_rvv[l_ac].rvv17,'','SEL')#CHI-9A0022 add ''
#                        RETURNING l_r,g_qty 
#                    IF l_r = "Y" THEN
#                       LET g_rvv[l_ac].rvv17 = g_qty
#                    END IF
#                 END IF
#              END IF
#          END IF
#FUN-B50096 -------------------End----------------------
 
        #FUN-CB0087--add---str----
        BEFORE FIELD rvv26
           IF g_aza.aza115 = 'Y' AND cl_null(g_rvv[l_ac].rvv26) THEN
              CALL s_reason_code(g_rvu.rvu01,g_rvu.rvu02,'',g_rvv[1].rvv31,
                               g_rvv[1].rvv32,g_rvu.rvu07,g_rvu.rvu06) RETURNING g_rvv[l_ac].rvv26
              DISPLAY BY NAME g_rvv[l_ac].rvv26
           END IF
        #FUN-CB0087--add---end----

        AFTER FIELD rvv26              #理由
           #FUN-CB0087--add--str--
           IF NOT t720_rvv26_chk() THEN
              NEXT FIELD rvv26
           ELSE
              SELECT azf03 INTO g_rvv[l_ac].azf03 FROM azf_file
               WHERE azf01 = g_rvv[l_ac].rvv26 AND azf02='2'
              DISPLAY BY NAME g_rvv[l_ac].azf03
           END IF  
           #FUN-CB0087--add--end--
           #FUN-CB0087--mark--str--
           #IF g_rvu.rvu00 = '3' THEN
           #   IF cl_null(g_rvv[l_ac].rvv26) THEN
           #      NEXT FIELD rvv26
           #   END IF
           #END IF
           #IF NOT cl_null(g_rvv[l_ac].rvv26) THEN
           #    SELECT azf03 INTO g_rvv[l_ac].azf03 FROM azf_file
           #     WHERE azf01 = g_rvv[l_ac].rvv26 AND azf02='2'
           #    IF STATUS THEN
           #       CALL cl_err3("sel","azf_file",g_rvv[l_ac].rvv26,"",STATUS,"","sel azf",1)  #No.FUN-660129
           #       NEXT FIELD rvv26
           #    END IF
           #    SELECT azf09 INTO l_azf09 FROM azf_file 
           #     WHERE azf01=g_rvv[l_ac].rvv26 AND azf02='2'
           #    #IF l_azf09 !='7' THEN   #MOD-AB0051
           #    IF l_azf09 !='7' AND g_argv1 = '1' THEN   #MOD-AB0051
           #       CALL cl_err('','aoo-406',1)
           #       NEXT FIELD rvv26   
           #    END IF  
           #    #-----MOD-AB0051---------
           #    IF l_azf09 !='5' AND g_argv1 <> '1' THEN   
           #       CALL cl_err('','aoo-406',1)
           #       NEXT FIELD rvv26   
           #    END IF  
           #    #-----END MOD-AB0051----- 
           #    DISPLAY BY NAME g_rvv[l_ac].azf03
           #END IF
           #FUN-CB0087--mark--end--
 
        BEFORE FIELD rvv25   #00/05/21 modify
           IF NOT cl_null(g_rvv[l_ac].rvv25) AND g_rvu.rvu00 = '3' THEN   #倉退
              SELECT ima906 INTO g_ima906 FROM ima_file
               WHERE ima01=g_rvv[l_ac].rvv31
              IF g_sma.sma115 = 'Y' THEN
                 IF g_ima906='1' THEN
                    NEXT FIELD rvv82
                 ELSE
                    NEXT FIELD rvv85
                 END IF
              ELSE
                 NEXT FIELD rvv17
              END IF
           END IF
 
        AFTER FIELD rvv25              #樣品否
           IF NOT cl_null(g_rvv[l_ac].rvv25) THEN
             #IF g_rvv[l_ac].rvv25 NOT MATCHES '[YN]' THEN
              IF g_rvv[l_ac].rvv25 NOT MATCHES '[YNP]' THEN   #FUN-C60071 add
                  NEXT FIELD rvv25
              ELSE
              	 IF g_rvv[l_ac].rvv25 = 'Y' THEN 
              	    LET g_rvv[l_ac].rvv38  = 0
              	    LET g_rvv[l_ac].rvv38t = 0              	    
              	    LET g_rvv[l_ac].rvv39  = 0              	    
              	    LET g_rvv[l_ac].rvv39t = 0
              	    DISPLAY BY NAME g_rvv[l_ac].rvv38,g_rvv[l_ac].rvv38t,
              	                    g_rvv[l_ac].rvv39,g_rvv[l_ac].rvv39t              	    
              	 END IF 
              END IF
           END IF
 
        AFTER FIELD rvv17              #異動數量
           #No.FUN-BB0086--add--begin--
           IF NOT cl_null(g_rvv[l_ac].rvv17) AND NOT cl_null(g_rvv[l_ac].rvv35) THEN
              IF cl_null(g_rvv_t.rvv17) OR cl_null(g_rvv35_t) OR g_rvv_t.rvv17 != g_rvv[l_ac].rvv17 OR g_rvv35_t != g_rvv[l_ac].rvv35 THEN
                 LET g_rvv[l_ac].rvv17=s_digqty(g_rvv[l_ac].rvv17,g_rvv[l_ac].rvv35)
                 DISPLAY BY NAME g_rvv[l_ac].rvv17
              END IF
           END IF
           #No.FUN-BB0086--add--end--
      #FUN-BC0104---add---str---
        IF NOT t720_rvv17(p_cmd) THEN
           NEXT FIELD rvv17
        END IF
        #FUN-BC0104---add---end---
######################FUN-BC0104-----mark-----str#######################
#獨立出FUNCTION t720_rvv17()  
#          IF g_rvv[l_ac].rvv17 < 0 THEN
#             CALL cl_err('','afa-043',0)
#             NEXT FIELD rvv17
#          END IF
#          #TQC-5B0159--倉退單身可輸入數量為0
#          IF (g_rvu.rvu00 != '3') AND (g_rvv[l_ac].rvv17 = 0) THEN
#             CALL cl_err('','afa-978',1)
#             LET g_rvv[l_ac].rvv17 = g_rvv_t.rvv17
#             NEXT FIELD rvv17
#          END IF
#
#          IF g_rvv_t.rvv17 IS NULL AND g_rvv[l_ac].rvv17 IS NOT NULL OR
#             g_rvv_t.rvv17 IS NOT NULL AND g_rvv[l_ac].rvv17 IS NULL OR
#             g_rvv_t.rvv17 <> g_rvv[l_ac].rvv17 THEN
#             LET l_rvb07 = 0
#             SELECT rvb07,rvb87 INTO l_rvb07,l_rvb87 FROM rvb_file
#              WHERE rvb01=g_rvu.rvu02 
#                AND rvb02=g_rvv[l_ac].rvv05
#             IF l_rvb07 = g_rvv[l_ac].rvv17 THEN
#                LET g_rvv[l_ac].rvv87 = l_rvb87 
#                DISPLAY BY NAME g_rvv[l_ac].rvv87
#             END IF
#             IF l_rvb07 <> g_rvv[l_ac].rvv17  AND p_cmd <> 'a' THEN
#                LET g_change='Y'
#             END IF  #MOD-820189 add
#          END IF
#          #MOD-B30033 add --start--
#          IF g_change='Y' THEN                 #MOD-820189 add
#            CALL t720_set_rvv87()              #No.MOD-770158 add
#            DISPLAY BY NAME g_rvv[l_ac].rvv87  #MOD-820189 add
#          END IF                               #MOD-820189 add            
#          #MOD-B30033 add --end--
#           IF g_rvu.rvu00='1' THEN #MOD-4C0053
#             SELECT rvb31,rvb07,rvb87 INTO g_inqty,l_rvb07,l_rvb87 FROM rvb_file,rva_file  #MOD-820189 modify 由收貨單帶計價數量
#              WHERE rvb01=g_rvu.rvu02 AND rvb02=g_rvv[l_ac].rvv05
#                AND rvb01 = rva01
#                AND rvaconf !='X' #作廢資料要剔除 BugNo:3816
#             IF g_rvv[l_ac].rvv17 > g_inqty THEN  #異動數量不可大於可入庫量
#                 CALL cl_err(g_inqty,'mfg3252',1) NEXT FIELD rvv17  #MOD-580184
#             END IF
#          END IF
#          ##-入庫數量不可大於允收量
#          IF g_rvu.rvu00='1' THEN
#             SELECT rvb33,rvb39 INTO l_rvb33,l_rvb39 FROM rvb_file
#              WHERE rvb01=g_rvu.rvu02 AND rvb02=g_rvv[l_ac].rvv05
#             IF l_rvb39 = 'Y' THEN
#                IF cl_null(l_rvb33) THEN LET l_rvb33 = 0 END IF #BugNo:6641
#                IF (g_rvv[l_ac].rvv17 > l_rvb33) THEN
#                   #No.8939 mark
#                   #IF g_qcz.qcz05 = 'N' AND g_sma.sma886[8,8]='Y' THEN #no.5071
#                   IF g_qcz.qcz05 = 'N' THEN                            #No.8939
#                      CALL cl_err(g_rvv[l_ac].rvv31,'apm-282',0)
#                      NEXT FIELD rvv17
#                   END IF
#                END IF
#             END IF
#             #本張單據,其他屬於此收貨項次的入庫數量
#               SELECT SUM(rvv17) INTO l_rvv17_1_other FROM rvv_file,rvu_file
#                WHERE rvv04=g_rvu.rvu02 AND rvv05=g_rvv[l_ac].rvv05
#                  AND rvv03='1'
#                  AND rvv01 =g_rvu.rvu01
#                  AND rvv01=rvu01
#                  AND rvv02 !=g_rvv[l_ac].rvv02
#                  AND rvuconf !='X'
#              IF cl_null(l_rvv17_1_other) THEN
#                 LET l_rvv17_1_other=0
#              END IF
#              LET l_rvv17_1_other = l_rvv17_1_other+ g_rvv[l_ac].rvv17
#              #總允收數量
#              SELECT SUM(rvb33) INTO l_rvb33_tol FROM rvb_file
#                 WHERE rvb01=g_rvu.rvu02 AND rvb02=g_rvv[l_ac].rvv05
#                   AND rvb39 = 'Y'
#                IF g_qcz.qcz05='Y' THEN
#                  SELECT SUM(rvv17) INTO l_rvv17_return FROM rvv_file,rvu_file
#                   WHERE rvv04=g_rvu.rvu02 AND rvv05=g_rvv[l_ac].rvv05
#                     AND rvv03='1'
#                     AND rvv01 =g_rvu.rvu01
#                     AND rvv01=rvu01
#                     AND rvv02 !=g_rvv[l_ac].rvv02
#                     AND rvuconf !='X'
#                     AND rvv32 = g_qcz.qcz051
#                     AND rvv33 = g_qcz.qcz052
#                  IF cl_null(l_rvv17_return) THEN
#                     LET l_rvv17_return=0
#                  END IF
#                  #加上當筆屬於不合格品入庫部份
#                  IF g_rvv[l_ac].rvv32=g_qcz.qcz051 AND
#                     g_rvv[l_ac].rvv33=g_qcz.qcz052  THEN
#                     LET l_rvv17_return=l_rvv17_return + g_rvv[l_ac].rvv17
#                  END IF
#                END IF
#              IF cl_null(l_rvv17_return) THEN LET l_rvv17_return = 0 END IF #No.MOD-930070
#&ifdef ICD
#                #FUN-A20017--begin--add----
#                SELECT COALESCE(rvbiicd06,0) INTO l_rvbiicd06 FROM rvbi_file
#                WHERE rvbi01=g_rvu.rvu02 AND rvbi02=g_rvv[l_ac].rvv05
#                IF l_rvv17_1_other > (l_rvb33_tol+l_rvv17_return+l_rvbiicd06) THEN
#                #FUN-A20017--end--add----
#&else
#                IF l_rvv17_1_other > (l_rvb33_tol+l_rvv17_return) THEN #MOD-6A0118-add
#&endif
#                 CALL cl_err(g_rvv[l_ac].rvv31,'apm-306',0)
#                 NEXT FIELD rvv17
#              END IF
#
#          END IF
#          #退貨不可大於庫存量
#          IF g_rvu.rvu00='3' THEN
#             IF NOT cl_null(b_rvv.rvv04) THEN
#                SELECT SUM(rvv17) INTO l_rvv17_3 FROM rvv_file,rvu_file
#                 WHERE rvv04=g_rvu.rvu02 AND rvv05=g_rvv[l_ac].rvv05
#                   AND rvv03='3' AND rvv01 !=g_rvu.rvu01 AND rvv01=rvu01
#                   AND rvuconf !='X'
#                IF cl_null(l_rvv17_3) THEN LET l_rvv17_3=0 END IF
#                #本張單據,其他屬於此收貨項次的數量
#                SELECT SUM(rvv17) INTO l_rvv17_3_other FROM rvv_file,rvu_file
#                 WHERE rvv04=g_rvu.rvu02 AND rvv05=g_rvv[l_ac].rvv05
#                   AND rvv03='3'
#                   AND rvv01 =g_rvu.rvu01
#                   AND rvv01=rvu01
#                   AND rvv02 !=g_rvv[l_ac].rvv02
#                   AND rvuconf !='X'
#                IF cl_null(l_rvv17_3_other) THEN
#                   LET l_rvv17_3_other=0
#                END IF
#                SELECT rvb30 INTO g_inqty FROM rvb_file,rva_file
#                 WHERE rvb01=g_rvu.rvu02 AND rvb02=g_rvv[l_ac].rvv05
#                   AND rvb01=rva01
#                   AND rvaconf !='X' #作廢資料要剔除 BugNo:3816
#                IF cl_null(g_inqty) THEN LET g_inqty=0 END IF
#                #異動數量不可大於入庫量-倉退量
#                #IF g_rvv[l_ac].rvv17 > (g_inqty-l_rvv17_3) THEN
#                IF g_rvv[l_ac].rvv17 > (g_inqty-l_rvv17_3-l_rvv17_3_other ) THEN
#                   CALL cl_err(g_rvv[l_ac].rvv31,'apm-254',1)
#                   NEXT FIELD rvv17
#                END IF
#             END IF
#          END IF
#          #驗退不可大於(收貨量-已輸入之驗退量)
#          IF g_rvu.rvu00='2' THEN
#             IF NOT cl_null(b_rvv.rvv04) THEN
#                SELECT SUM(rvv17) INTO l_rvv17_2 FROM rvv_file,rvu_file
#                 WHERE rvv04=g_rvu.rvu02 AND rvv05=g_rvv[l_ac].rvv05
#                   AND rvv03='2'
#                   AND rvv01 !=g_rvu.rvu01
#                   AND rvv01=rvu01
#                   AND rvuconf !='X'
#               IF cl_null(l_rvv17_2) THEN LET l_rvv17_2=0 END IF
#               #本張單據,其他屬於此收貨項次的數量
#               SELECT SUM(rvv17) INTO l_rvv17_2_other FROM rvv_file,rvu_file
#                WHERE rvv04=g_rvu.rvu02 AND rvv05=g_rvv[l_ac].rvv05
#                  AND rvv03='2'
#                  AND rvv01 =g_rvu.rvu01
#                  AND rvv01=rvu01
#                  AND rvv02 !=g_rvv[l_ac].rvv02
#                  AND rvuconf !='X'
#                IF cl_null(l_rvv17_2_other) THEN
#                   LET l_rvv17_2_other=0
#                END IF
#               #修改可驗退數量控管
#               #1.若走IQC   可驗退量=SUM(IQC送驗量) - SUM(IQC合格量) - 已驗退量
#               #2.若不走IQC 可驗退量=實收數量 - 已入庫量 - 已驗退量
#
#                SELECT rvb07,rvb33,rvb30,rvb39 INTO g_inqty,l_okqty,
#                   l_rvb30,l_rvb39  FROM rvb_file,rva_file
#                WHERE rvb01=g_rvu.rvu02 AND rvb02=g_rvv[l_ac].rvv05
#                  AND rvb01=rva01
#                  AND rvaconf !='X' #作廢資料要剔除 MODNO:3816
#
#MOD-B90019 -- begin --
#                SELECT SUM(rvv17) INTO l_rvv17_in FROM rvu_file,rvv_file
#                   WHERE rvv04 = g_rvu.rvu02
#                     AND rvv05 = g_rvv[l_ac].rvv05
#                     AND rvv01 = rvu01
#                     AND rvu00 = '1'
#                     AND rvuconf != 'X'
#                IF cl_null(l_rvv17_in) THEN LET l_rvv17_in = 0 END IF
#MOD-B90019 -- end --

#                IF cl_null(g_inqty) THEN LET g_inqty=0 END IF
#                IF cl_null(l_okqty) THEN LET l_okqty=0 END IF
#                IF cl_null(l_rvb30) THEN LET l_rvb30=0 END IF
#
#                IF g_sma.sma886[8,8] = 'N'  OR l_rvb39='N' THEN   
#                  #若勾選允收數與IQC勾稽 , 驗退量以qcs_file為主
#                  #若不勾選允收數與IQC勾稽 , 驗退量以rvb_file為主
#
#                   #不走IQC
#                   #IF g_rvv[l_ac].rvv17 > (g_inqty-l_rvv17_2-l_rvv17_2_other-l_rvb30) THEN      #MOD-B90019 mark
#                    IF g_rvv[l_ac].rvv17 > (g_inqty-l_rvv17_2-l_rvv17_2_other-l_rvv17_in) THEN   #MOD-B90019
#                        CALL cl_err(g_rvv[l_ac].rvv31,'apm-730',1)
#                      NEXT FIELD rvv17
#                    END IF
#                 ELSE
#                   #走IQC
#                    SELECT SUM(qcs091),SUM(qcs22) INTO l_qcs091,l_qcs22
#                       FROM qcs_file WHERE  qcs01 = g_rvu.rvu02
#                       AND qcs02 = g_rvv[l_ac].rvv05
#                       AND qcs14 = 'Y'               #確認否
#                      #AND qcs09 = '1'               #合格否   #No.MOD-7A0072 mark
#
#                    IF cl_null(l_qcs091) THEN LET l_qcs091 = 0 END IF
#                    IF cl_null(l_qcs22)  THEN LET l_qcs22 = 0 END IF
#
#                    IF g_rvv[l_ac].rvv17 > (l_qcs22-l_rvv17_2-l_rvv17_2_other-l_qcs091) THEN
#                        CALL cl_err(g_rvv[l_ac].rvv31,'apm-730',1)
#                      NEXT FIELD rvv17
#                    END IF
#                END IF
#             END IF
#          END IF
#         #IF g_rvv[l_ac].rvv87>0 THEN   #MOD-AA0165 rvv17-->rvv87 #MOD-B30033 mark
#          IF g_rvv[l_ac].rvv87>0 OR g_rvu.rvu00 ='1' THEN #MOD-B30033
#             LET g_rvv[l_ac].rvv39=g_rvv[l_ac].rvv87*g_rvv[l_ac].rvv38   #MOD-AA0165 rvv17-->rvv87
#             LET g_rvv[l_ac].rvv39t=g_rvv[l_ac].rvv87*g_rvv[l_ac].rvv38t   #No.FUN-610018   #MOD-AA0165 rvv17-->rvv87
#             LET t_azi04=''
#             IF g_rva00 = '1' AND g_rvu.rvu00 = '3' THEN
#                SELECT azi04 INTO t_azi04 FROM azi_file
#                    WHERE azi01 = g_rvu.rvu113
#             END IF
#             IF g_rva00 = '1' AND g_rvu.rvu00 <> '3' THEN
#                SELECT azi04 INTO t_azi04                       #No.CHI-6A0004
#                   FROM pmm_file,azi_file
#                  WHERE pmm22=azi01
#                    AND pmm01 = g_rvv[l_ac].rvv36 AND pmm18 <> 'X'
#             END IF
#             IF g_rva00 = '2' THEN
#                SELECT rva113 INTO l_rva113 FROM rva_file 
#                    WHERE rva01 = g_rvu.rvu02
#                SELECT azi04 INTO t_azi04 FROM azi_file
#                    WHERE azi01 = l_rva113
#             END IF
#              IF cl_null(t_azi04) THEN                                         
#                 SELECT azi04 INTO t_azi04                                     
#                   FROM pmc_file,azi_file                                      
#                  WHERE pmc22=azi01                                            
#                    AND pmc01 = g_rvu.rvu04                                    
#              END IF                                                           
#             IF cl_null(t_azi04) THEN LET t_azi04=0 END IF  #No.CHI-6A0004
#             CALL cl_digcut(g_rvv[l_ac].rvv39,t_azi04)      #No.CHI-6A0004
#                               RETURNING g_rvv[l_ac].rvv39
#             CALL cl_digcut(g_rvv[l_ac].rvv39t,t_azi04)     #No.CHI-6A0004
#                               RETURNING g_rvv[l_ac].rvv39t   #No.FUN-610018
#             CALL t720sub_rvv39(g_rvv[l_ac].rvv36,g_rvv[l_ac].rvv39,g_rvv[l_ac].rvv39t,g_rvu.rvu04,g_rvu.rvu02) #FUN-A10130 
#                  RETURNING g_rvv[l_ac].rvv39,g_rvv[l_ac].rvv39t
#             DISPLAY BY NAME g_rvv[l_ac].rvv39
#             DISPLAY BY NAME g_rvv[l_ac].rvv39t
#          #MOD-B30033 add --start--
#          ELSE
#             IF g_rvu.rvu00 ='3' THEN
#                LET g_rvv[l_ac].rvv39=g_rvv[l_ac].rvv38
#                LET g_rvv[l_ac].rvv39t=g_rvv[l_ac].rvv38t  
#                LET t_azi04=''
#                IF g_rva00 = '1' AND g_rvu.rvu00 = '3' THEN
#                   SELECT azi04 INTO t_azi04 FROM azi_file
#                       WHERE azi01 = g_rvu.rvu113
#                END IF
#                IF g_rva00 = '1' AND g_rvu.rvu00 <> '3' THEN
#                   SELECT azi04 INTO t_azi04   
#                      FROM pmm_file,azi_file
#                     WHERE pmm22=azi01
#                       AND pmm01 = g_rvv[l_ac].rvv36 AND pmm18 <> 'X'
#                END IF
#                IF g_rva00 = '2' THEN
#                   SELECT rva113 INTO l_rva113 FROM rva_file 
#                       WHERE rva01 = g_rvu.rvu02
#                   SELECT azi04 INTO t_azi04 FROM azi_file
#                       WHERE azi01 = l_rva113
#                END IF
#                 IF cl_null(t_azi04) THEN                                         
#                    SELECT azi04 INTO t_azi04                                     
#                      FROM pmc_file,azi_file                                      
#                     WHERE pmc22=azi01                                            
#                       AND pmc01 = g_rvu.rvu04                                    
#                 END IF                                                           
#                IF cl_null(t_azi04) THEN LET t_azi04=0 END IF  
#                CALL cl_digcut(g_rvv[l_ac].rvv39,t_azi04)     
#                                  RETURNING g_rvv[l_ac].rvv39
#                CALL cl_digcut(g_rvv[l_ac].rvv39t,t_azi04)   
#                                  RETURNING g_rvv[l_ac].rvv39t  
#                CALL t720sub_rvv39(g_rvv[l_ac].rvv36,g_rvv[l_ac].rvv39,g_rvv[l_ac].rvv39t,g_rvu.rvu04,g_rvu.rvu02)  
#                     RETURNING g_rvv[l_ac].rvv39,g_rvv[l_ac].rvv39t
#                DISPLAY BY NAME g_rvv[l_ac].rvv39
#                DISPLAY BY NAME g_rvv[l_ac].rvv39t
#             END IF
#          #MOD-B30033 add --end--              
#          END IF
#
#             IF g_rvv[l_ac].rvv87 > 0 THEN   #MOD-AA0165 rvv17-->rvv87
#                LET g_rvv39=g_rvv[l_ac].rvv87*b_rvv.rvv38   #MOD-AA0165 rvv17-->rvv87
#                LET g_rvv39t=g_rvv[l_ac].rvv87*b_rvv.rvv38t   #No.FUN-610018   #MOD-AA0165 rvv17-->rvv87
#             END IF
#             LET t_azi04=''   #No.CHI-6A0004
#             IF g_rva00 = '1' AND g_rvu.rvu00 = '3' THEN
#                SELECT azi04 INTO t_azi04 FROM azi_file
#                    WHERE azi01 = g_rvu.rvu113
#             END IF
#             IF g_rva00 = '1' AND g_rvu.rvu00 <> '3' THEN
#                SELECT azi04 INTO t_azi04                       #No.CHI-6A0004
#                   FROM pmm_file,azi_file
#                  WHERE pmm22=azi01
#                    AND pmm01 = g_rvv[l_ac].rvv36 AND pmm18 <> 'X'
#             END IF
#             IF g_rva00 = '2' THEN
#                SELECT rva113 INTO l_rva113 FROM rva_file 
#                    WHERE rva01 = g_rvu.rvu02
#                SELECT azi04 INTO t_azi04 FROM azi_file
#                    WHERE azi01 = l_rva113
#             END IF
#              IF g_rvv[l_ac].rvv17 = 0 OR cl_null(t_azi04) THEN    #No.MOD-8A0183
#                 SELECT azi04 INTO t_azi04
#                   FROM pmc_file,azi_file
#                  WHERE pmc22=azi01
#                    AND pmc01 = g_rvu.rvu04
#              END IF
#             IF cl_null(t_azi04) THEN LET t_azi04=0 END IF  #No.CHI-6A0004
#             CALL cl_digcut(g_rvv39,t_azi04)  #No.CHI-6A0004
#                               RETURNING g_rvv39
#             CALL cl_digcut(g_rvv39t,t_azi04) #No.CHI-6A0004
#                               RETURNING g_rvv39t   #No.FUN-610018
#             IF NOT cl_null(g_rvv[l_ac].rvv36) THEN    #No.MOD-8A0098 
#             CALL t720sub_rvv39(g_rvv[l_ac].rvv36,g_rvv[l_ac].rvv39,g_rvv[l_ac].rvv39t,g_rvu.rvu04,g_rvu.rvu02) #FUN-A10130  
#                  RETURNING g_rvv[l_ac].rvv39,g_rvv[l_ac].rvv39t
#             END IF  #No.MOD-8A0098
#             DISPLAY BY NAME g_rvv[l_ac].rvv39
#             DISPLAY BY NAME g_rvv[l_ac].rvv39t
#          IF g_sma.sma116 MATCHES '[02]' THEN#MOD-630031 add #不使用計價單位時,計價單位/數量給原單據單位/數量
#             LET g_rvv[l_ac].rvv86=g_rvv[l_ac].rvv35
#             LET g_rvv[l_ac].rvv87=g_rvv[l_ac].rvv17
#             DISPLAY BY NAME g_rvv[l_ac].rvv86
#             DISPLAY BY NAME g_rvv[l_ac].rvv87
#          END IF
#         #MOD-B30033 mark --start--
#         #IF g_change='Y' THEN                 #MOD-820189 add
#         #  CALL t720_set_rvv87()              #No.MOD-770158 add
#         #  DISPLAY BY NAME g_rvv[l_ac].rvv87  #MOD-820189 add
#         #END IF                               #MOD-820189 add 
#         #MOD-B30033 mark --end--
#          SELECT ima918,ima921 INTO g_ima918,g_ima921 
#            FROM ima_file
#           WHERE ima01 = g_rvv[l_ac].rvv31
#             AND imaacti = "Y"
#          
#          IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
#             SELECT img09 INTO g_img09 FROM img_file
#             WHERE img01=g_rvv[l_ac].rvv31 AND img02=g_rvv[l_ac].rvv32
#               AND img03=g_rvv[l_ac].rvv33 AND img04=g_rvv[l_ac].rvv34
#             IF (NOT cl_null(g_rvu.rvu02)) OR (cl_null(g_rvu.rvu02)
#                 AND g_prog='apmt722' AND p_cmd='u') THEN   #No.MOD-930042 add
#                IF g_sma.sma90 = 'Y' THEN  #sel
#                   SELECT COUNT(*) INTO l_n FROM rvbs_file
#                    WHERE rvbs00 = g_prog
#                      AND rvbs01 = g_rvu.rvu01
#                      AND rvbs02 = g_rvv[l_ac].rvv02
#                   IF l_n = 0 THEN
#                      CALL t720sub_ins_rvbs(g_prog,g_rvu.rvu01,g_rvv[l_ac].rvv02,
#                                         g_rvu.rvu02,g_rvv[l_ac].rvv05,g_rvv[l_ac].rvv31,
#                                         g_rvv[l_ac].rvv32,g_rvv[l_ac].rvv33,g_rvv[l_ac].rvv34,g_rvu.rvu02) #FUN-A10130
#                   END IF
#                   IF g_rvu.rvu116 <> '3' OR cl_null(g_rvu.rvu116) THEN   #MOD-CB0229 add
#No.TQC-B90236--------mark---------begin-----------
#                  #CALL s_lotin(g_prog,g_rvu.rvu01,g_rvv[l_ac].rvv02,0,
#                  #             g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv35,g_img09,
#                  #             g_rvv[l_ac].rvv35_fac,g_rvv[l_ac].rvv17,'','SEL')#CHI-9A0022 add ''
#                  #       RETURNING l_r,g_qty
#No.TQC-B90236--------mark---------end-------------
#No.TQC-B90236--------add----------begin-----------
#                      IF g_rvu.rvu00='1' THEN
#                         CALL s_mod_lot(g_prog,g_rvu.rvu01,g_rvv[l_ac].rvv02,0,
#                                        g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv32,g_rvv[l_ac].rvv33,
#                                        g_rvv[l_ac].rvv34,g_rvv[l_ac].rvv35,g_img09,
#                                        g_rvv[l_ac].rvv35_fac,g_rvv[l_ac].rvv17,'','SEL',1) #CHI-9A0022 add ''
#                                 RETURNING l_r,g_qty
#                      ELSE
#                         CALL s_mod_lot(g_prog,g_rvu.rvu01,g_rvv[l_ac].rvv02,0,
#                                        g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv32,g_rvv[l_ac].rvv33,
#                                        g_rvv[l_ac].rvv34,g_rvv[l_ac].rvv35,g_img09,
#                                        g_rvv[l_ac].rvv35_fac,g_rvv[l_ac].rvv17,'','SEL',-1) #CHI-9A0022 add ''
#                                 RETURNING l_r,g_qty
#                      END IF
#No.TQC-B90236--------add----------end-------------	
#                   END IF   #MOD-CB0229 add
#                   IF l_r = "Y" THEN
#                      LET g_rvv[l_ac].rvv17 = g_qty
#                   END IF
#                ELSE
#No.CHI-9A0022 --Begin
#                   LET l_bno = ''
#                   SELECT pmn122 INTO l_bno
#                     FROM pmn_file
#                    WHERE pmn01 = g_rvv[l_ac].rvv36
#                      AND pmn02 = g_rvv[l_ac].rvv37
#No.CHI-9A0022 --End				   
#                   IF g_rvu.rvu116 <> '3' OR cl_null(g_rvu.rvu116) THEN   #MOD-CB0229 add
#No.TQC-B90236--------mark---------begin-----------
#                  #CALL s_lotin(g_prog,g_rvu.rvu01,g_rvv[l_ac].rvv02,0,
#                  #             g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv35,g_img09,
#                  #             g_rvv[l_ac].rvv35_fac,g_rvv[l_ac].rvv17,l_bno,'MOD')#CHI-9A0022 add ''
#                  #       RETURNING l_r,g_qty
#No.TQC-B90236--------mark---------end-------------
#No.TQC-B90236--------add----------begin-----------
#                   IF g_rvu.rvu00='1' THEN
#                      CALL s_mod_lot(g_prog,g_rvu.rvu01,g_rvv[l_ac].rvv02,0,
#                                     g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv32,g_rvv[l_ac].rvv33,
#                                     g_rvv[l_ac].rvv34,g_rvv[l_ac].rvv35,g_img09,
#                                     g_rvv[l_ac].rvv35_fac,g_rvv[l_ac].rvv17,l_bno,'MOD',1) #CHI-9A0022 add l_bno
#                              RETURNING l_r,g_qty
#                   ELSE
#                      CALL s_mod_lot(g_prog,g_rvu.rvu01,g_rvv[l_ac].rvv02,0,
#                                     g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv32,g_rvv[l_ac].rvv33,
#                                     g_rvv[l_ac].rvv34,g_rvv[l_ac].rvv35,g_img09,
#                                     g_rvv[l_ac].rvv35_fac,g_rvv[l_ac].rvv17,l_bno,'MOD',-1) #CHI-9A0022 add l_bno
#                              RETURNING l_r,g_qty
#                   END IF
#No.TQC-B90236--------add----------end-------------	
#                   END IF   #MOD-CB0229 add
#                   IF l_r = "Y" THEN
#                      LET g_rvv[l_ac].rvv17 = g_qty
#                   END IF
#                END IF
#             END IF    #No.MOD-930042 add
#          END IF
#          CALL t720_get_price()
#          IF NOT cl_null(g_rvv[l_ac].rvv17) THEN
#             IF g_rvu.rvu00 = '3' AND g_rvu.rvu116 MATCHES '[12]' THEN
#                IF g_rvv[l_ac].rvv17 <= 0 THEN
#                   CALL cl_err(g_rvv[l_ac].rvv17,'axm-948',0)
#                   NEXT FIELD rvv17
#                END IF
#             END IF
#          END IF
#&ifdef ICD
#          CALL t720_b_move_back()
#          #檢查入庫/驗退數量與刻號入庫否數量是否相同
#          IF NOT t720sub_ind_icd_chk_icdin_yn(b_rvv.*,b_rvvi.*,
#                                           g_rvu.rvu00,g_rvu.rvu08,g_rvu.rvu02,g_argv1,g_argv3) THEN   #FUN-A10130
#             LET g_rvv[l_ac].rvv17 = g_rvv_t.rvv17
#             DISPLAY BY NAME g_rvv[l_ac].rvv17
#             NEXT FIELD rvv17
#          END IF
#          
#          #修改數量,若料號有展明細(imaicd08) ='Y',
#          #則需檢查發料量與所維護之數量是否一致,如果不一致,出錯誤訊息
#          IF g_cmd = 'u' AND NOT cl_null(g_rvv_t.rvv17) AND
#             g_rvv_t.rvv17 <> g_rvv[l_ac].rvv17 THEN
#             CALL t720_ind_icd_chk_icdqty()
#          END IF
#          IF g_change = 'Y' THEN
#             #委外入庫,重新計算計價數量,金額,單價等值
#             CALL t720_ind_icd_upd_rvvxx('b')
#          END IF
#&endif
######################FUN-BC0104-----mark-----end#######################
                 
        BEFORE FIELD rvv83
           CALL t720_sel_ima()
           IF NOT cl_null(g_img09) THEN LET g_unit = g_img09 ELSE LET g_unit=g_ima25 END IF
           CALL t720_set_no_required(p_cmd)
 
        AFTER FIELD rvv83  #第二單位
           IF cl_null(g_rvv[l_ac].rvv31) THEN NEXT FIELD rvv05 END IF
           IF cl_null(g_rvv[l_ac].rvv33) THEN LET g_rvv[l_ac].rvv33 = ' ' END IF
           IF cl_null(g_rvv[l_ac].rvv34) THEN LET g_rvv[l_ac].rvv34 = ' ' END IF
           IF l_ec_sw <> 'Y' AND g_rvv[l_ac].rvv31 NOT MATCHES 'MISC*' THEN
              IF g_rvv[l_ac].rvv32 IS NULL OR g_rvv[l_ac].rvv33 IS NULL OR
                 g_rvv[l_ac].rvv34 IS NULL THEN
                 NEXT FIELD rvv32
              END IF
           END IF
           IF g_rvv_t.rvv83 IS NULL AND g_rvv[l_ac].rvv83 IS NOT NULL OR
              g_rvv_t.rvv83 IS NOT NULL AND g_rvv[l_ac].rvv83 IS NULL OR
              g_rvv_t.rvv83 <> g_rvv[l_ac].rvv83 THEN
              LET g_change='Y'
           END IF
           IF NOT cl_null(g_rvv[l_ac].rvv83) THEN
              IF g_rvv_t.rvv83 IS NULL OR g_rvv[l_ac].rvv83 != g_rvv_t.rvv83 THEN
                 CALL t720_unit(g_rvv[l_ac].rvv83)
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_rvv[l_ac].rvv83,g_errno,0)
                    LET g_rvv[l_ac].rvv83 = g_rvv_t.rvv83
                    NEXT FIELD rvv83
                 END IF
              END IF
              CALL s_du_umfchk(g_rvv[l_ac].rvv31,'','','',
                               g_ima44,g_rvv[l_ac].rvv83,g_ima906)
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_rvv[l_ac].rvv83,g_errno,0)
                 NEXT FIELD rvv83
              END IF
              IF cl_null(g_rvv_t.rvv83) OR g_rvv_t.rvv83 <> g_rvv[l_ac].rvv83 THEN
                 LET g_rvv[l_ac].rvv84 = g_factor
                 DISPLAY BY NAME g_rvv[l_ac].rvv84
              END IF
              #No.FUN-BB0086--add--begin--
              IF NOT cl_null(g_rvv[l_ac].rvv85) THEN
                 IF cl_null(g_rvv_t.rvv85) OR cl_null(g_rvv83_t) OR g_rvv_t.rvv85 != g_rvv[l_ac].rvv85 OR g_rvv83_t != g_rvv[l_ac].rvv83 THEN
                   LET g_rvv[l_ac].rvv85=s_digqty(g_rvv[l_ac].rvv85,g_rvv[l_ac].rvv83)
                   DISPLAY BY NAME g_rvv[l_ac].rvv85
                 END IF
              END IF
              #No.FUN-BB0086--add--end--
           END IF
           CALL t720_set_required(p_cmd)
           CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           IF g_change = 'Y' THEN                #MOD-820189 add
              CALL t720_set_rvv87()              #No.MOD-770158 add
              DISPLAY BY NAME g_rvv[l_ac].rvv87  #MOD-820189 add
           END IF                                #MOD-820189 add
 
        BEFORE FIELD rvv84  #第二轉換率
           IF cl_null(g_rvv[l_ac].rvv31) THEN NEXT FIELD rvv31 END IF
           IF cl_null(g_rvv[l_ac].rvv31) THEN NEXT FIELD rvv05 END IF
           IF cl_null(g_rvv[l_ac].rvv33) THEN LET g_rvv[l_ac].rvv33 = ' ' END IF
           IF cl_null(g_rvv[l_ac].rvv34) THEN LET g_rvv[l_ac].rvv34 = ' ' END IF
           IF l_ec_sw <> 'Y' AND g_rvv[l_ac].rvv31 NOT MATCHES 'MISC*' THEN
              IF g_rvv[l_ac].rvv32 IS NULL OR g_rvv[l_ac].rvv33 IS NULL OR
                 g_rvv[l_ac].rvv34 IS NULL THEN
                 NEXT FIELD rvv32
              END IF
           END IF
 
        AFTER FIELD rvv84  #第二轉換率
           IF g_rvv_t.rvv84 IS NULL AND g_rvv[l_ac].rvv84 IS NOT NULL OR
              g_rvv_t.rvv84 IS NOT NULL AND g_rvv[l_ac].rvv84 IS NULL OR
              g_rvv_t.rvv84 <> g_rvv[l_ac].rvv84 THEN
              LET g_change='Y'
           END IF
           IF NOT cl_null(g_rvv[l_ac].rvv84) THEN
              IF g_rvv[l_ac].rvv84=0 THEN
                 NEXT FIELD rvv84
              END IF
           END IF
 
        BEFORE FIELD rvv85  #第二數量
           IF cl_null(g_rvv[l_ac].rvv31) THEN NEXT FIELD rvv31 END IF
           IF cl_null(g_rvv[l_ac].rvv31) THEN NEXT FIELD rvv05 END IF
           IF cl_null(g_rvv[l_ac].rvv33) THEN LET g_rvv[l_ac].rvv33 = ' ' END IF
           IF cl_null(g_rvv[l_ac].rvv34) THEN LET g_rvv[l_ac].rvv34 = ' ' END IF
           IF l_ec_sw <> 'Y' AND g_rvv[l_ac].rvv31 NOT MATCHES 'MISC*' THEN
              IF g_rvv[l_ac].rvv32 IS NULL OR g_rvv[l_ac].rvv33 IS NULL OR
                 g_rvv[l_ac].rvv34 IS NULL THEN
                 NEXT FIELD rvv32
              END IF
           END IF
 
        AFTER FIELD rvv85  #第二數量
           #No.FUN-BB0086--add--begin--
           IF NOT cl_null(g_rvv[l_ac].rvv85) AND NOT cl_null(g_rvv[l_ac].rvv83) THEN
              IF cl_null(g_rvv_t.rvv85) OR cl_null(g_rvv83_t) OR g_rvv_t.rvv85 != g_rvv[l_ac].rvv85 OR g_rvv83_t != g_rvv[l_ac].rvv83 THEN
                 LET g_rvv[l_ac].rvv85=s_digqty(g_rvv[l_ac].rvv85,g_rvv[l_ac].rvv83)
                 DISPLAY BY NAME g_rvv[l_ac].rvv85
              END IF
           END IF
           #No.FUN-BB0086--add--end--
           IF g_rvv[l_ac].rvv85 < 0 THEN
              CALL cl_err('','afa-043',0)
              NEXT FIELD rvv85
           END IF
           IF g_rvv_t.rvv85 IS NULL AND g_rvv[l_ac].rvv85 IS NOT NULL OR
              g_rvv_t.rvv85 IS NOT NULL AND g_rvv[l_ac].rvv85 IS NULL OR
              g_rvv_t.rvv85 <> g_rvv[l_ac].rvv85 THEN
              LET g_change='Y'
           END IF
           LET l_flag=TRUE  #FUN-810038
           IF NOT cl_null(g_rvv[l_ac].rvv83) AND
              g_rvv[l_ac].rvv31 NOT MATCHES 'MISC*' AND l_flag THEN #FUN-810038
              CALL s_chk_imgg(g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv32,
                              g_rvv[l_ac].rvv33,g_rvv[l_ac].rvv34,
                              g_rvv[l_ac].rvv83) RETURNING g_flag
              IF g_flag = 1 THEN
                  IF g_sma.sma892[3,3] ='Y' THEN
                     IF NOT cl_confirm('aim-995') THEN
                        NEXT FIELD rvv32
                     END IF
                  END IF
                  CALL s_add_imgg(g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv32,
                                  g_rvv[l_ac].rvv33,g_rvv[l_ac].rvv34,
                                  g_rvv[l_ac].rvv83,g_rvv[l_ac].rvv84,
                                  g_rvu.rvu01,
                                  g_rvv[l_ac].rvv02,0) RETURNING g_flag
                  IF g_flag = 1 THEN
                     NEXT FIELD rvv32
                  END IF
              END IF
           END IF
           IF NOT cl_null(g_rvv[l_ac].rvv85) THEN
              IF g_rvv[l_ac].rvv85 < 0 THEN
                 CALL cl_err('','aim-391',0)  #
                 NEXT FIELD rvv85
              END IF
              IF p_cmd = 'a' OR p_cmd = '2' AND
                 g_rvv_t.rvv85 <> g_rvv[l_ac].rvv85 THEN
                 IF g_ima906='3' THEN
                    LET g_tot=g_rvv[l_ac].rvv85*g_rvv[l_ac].rvv84
                    IF cl_null(g_rvv[l_ac].rvv82) OR g_rvv[l_ac].rvv82=0 THEN #CHI-960022
                       LET g_rvv[l_ac].rvv82=g_tot*g_rvv[l_ac].rvv81
                       LET g_rvv[l_ac].rvv82=s_digqty(g_rvv[l_ac].rvv82,g_rvv[l_ac].rvv80) #FUN-BB0086 add
                       DISPLAY BY NAME g_rvv[l_ac].rvv82
                    END IF                                                    #CHI-960022
                 END IF
              END IF

              LET g_ima918 = ''   #DEV-D30059 add
              LET g_ima921 = ''   #DEV-D30059 add
              LET g_ima930 = ''   #DEV-D30059 add

              SELECT ima918,ima921,ima930 INTO g_ima918,g_ima921,g_ima930 #DEV-D30059 add ima930 
                FROM ima_file
               WHERE ima01 = g_rvv[l_ac].rvv31
                 AND imaacti = "Y"
              
              IF cl_null(g_ima930) THEN LET g_ima930 = 'N' END IF  #DEV-D30059 add

              IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                 SELECT img09 INTO g_img09 FROM img_file
                 WHERE img01=g_rvv[l_ac].rvv31 AND img02=g_rvv[l_ac].rvv32
                   AND img03=g_rvv[l_ac].rvv33 AND img04=g_rvv[l_ac].rvv34
                 IF g_sma.sma90 = 'Y' THEN  #sel
                    SELECT COUNT(*) INTO l_n FROM rvbs_file
                     WHERE rvbs00 = g_prog
                       AND rvbs01 = g_rvu.rvu01
                       AND rvbs02 = g_rvv[l_ac].rvv02
                    IF l_n = 0 THEN
                       CALL t720sub_ins_rvbs(g_prog,g_rvu.rvu01,g_rvv[l_ac].rvv02,
                                          g_rvu.rvu02,g_rvv[l_ac].rvv05,g_rvv[l_ac].rvv31,
                                          g_rvv[l_ac].rvv32,g_rvv[l_ac].rvv33,g_rvv[l_ac].rvv34,g_rvu.rvu02) #FUN-A10130
                    END IF
                    IF g_rvu.rvu116 <> '3' OR cl_null(g_rvu.rvu116) THEN   #MOD-CB0229 add 
   #No.TQC-B90236--------mark---------begin-----------
                      #CALL s_lotin(g_prog,g_rvu.rvu01,g_rvv[l_ac].rvv02,0,
                      #             g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv35,g_img09,
                      #             g_rvv[l_ac].rvv35_fac,g_rvv[l_ac].rvv17,'','SEL')#CHI-9A0022 add ''
                      #       RETURNING l_r,g_qty
   #No.TQC-B90236--------mark---------end-------------
                       CALL s_wo_record(g_rvv[l_ac].rvv18,'Y')   #MOD-CC0047 add
   #No.TQC-B90236--------add----------begin-----------
                       IF g_ima930 = 'N' THEN                                        #DEV-D30059
                          IF g_rvu.rvu00='1' THEN
                             CALL s_mod_lot(g_prog,g_rvu.rvu01,g_rvv[l_ac].rvv02,0,
                                            g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv32,g_rvv[l_ac].rvv33,
                                            g_rvv[l_ac].rvv34,g_rvv[l_ac].rvv35,g_img09,
                                            g_rvv[l_ac].rvv35_fac,g_rvv[l_ac].rvv17,'','SEL',1) #CHI-9A0022 add ''
                                     RETURNING l_r,g_qty
                          ELSE
                             CALL s_mod_lot(g_prog,g_rvu.rvu01,g_rvv[l_ac].rvv02,0,
                                            g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv32,g_rvv[l_ac].rvv33,
                                            g_rvv[l_ac].rvv34,g_rvv[l_ac].rvv35,g_img09,
                                            g_rvv[l_ac].rvv35_fac,g_rvv[l_ac].rvv17,'','SEL',-1) #CHI-9A0022 add ''
                                     RETURNING l_r,g_qty
                          END IF
                       END IF                                                        #DEV-D30059
   #No.TQC-B90236--------add----------end-------------	
                    END IF   #MOD-CB0229 add
                    IF l_r = "Y" THEN
                       LET g_rvv[l_ac].rvv17 = g_qty
                    END IF
                 ELSE
#No.CHI-9A0022 --Begin
                    LET l_bno = ''
                    SELECT pmn122 INTO l_bno
                      FROM pmn_file
                     WHERE pmn01 = g_rvv[l_ac].rvv36
                       AND pmn02 = g_rvv[l_ac].rvv37
#No.CHI-9A0022 --End					 
                    IF g_rvu.rvu116 <> '3' OR cl_null(g_rvu.rvu116) THEN   #MOD-CB0229 add 
   #No.TQC-B90236--------mark---------begin-----------
                      #CALL s_lotin(g_prog,g_rvu.rvu01,g_rvv[l_ac].rvv02,0,
                      #             g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv35,g_img09,
                      #             g_rvv[l_ac].rvv35_fac,g_rvv[l_ac].rvv17,l_bno,'MOD')#CHI-9A0022 add ''
                      #       RETURNING l_r,g_qty
   #No.TQC-B90236--------mark---------end-------------
                       CALL s_wo_record(g_rvv[l_ac].rvv18,'Y')   #MOD-CC0047 add
   #No.TQC-B90236--------add----------begin-----------
                       IF g_ima930 = 'N' THEN                                        #DEV-D30059
                          IF g_rvu.rvu00='1' THEN
                             CALL s_mod_lot(g_prog,g_rvu.rvu01,g_rvv[l_ac].rvv02,0,
                                            g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv32,g_rvv[l_ac].rvv33,
                                            g_rvv[l_ac].rvv34,g_rvv[l_ac].rvv35,g_img09,
                                            g_rvv[l_ac].rvv35_fac,g_rvv[l_ac].rvv17,l_bno,'MOD',1) #CHI-9A0022 add l_bno
                                     RETURNING l_r,g_qty
                          ELSE
                             CALL s_mod_lot(g_prog,g_rvu.rvu01,g_rvv[l_ac].rvv02,0,
                                            g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv32,g_rvv[l_ac].rvv33,
                                            g_rvv[l_ac].rvv34,g_rvv[l_ac].rvv35,g_img09,
                                            g_rvv[l_ac].rvv35_fac,g_rvv[l_ac].rvv17,l_bno,'MOD',-1) #CHI-9A0022 add l_bno
                                     RETURNING l_r,g_qty
                          END IF
                       END IF                                                        #DEV-D30059
   #No.TQC-B90236--------add----------end-------------
                    END IF   #MOD-CB0229 add
                    IF l_r = "Y" THEN
                       LET g_rvv[l_ac].rvv17 = g_qty
                    END IF
                 END IF
               END IF
           END IF
           LET g_rvv[l_ac].rvv17 = s_digqty(g_rvv[l_ac].rvv17,g_rvv[l_ac].rvv35) #FUN-BB0086 add
           #FUN-BC0104---add---str---
           IF g_sma.sma115='Y' AND NOT cl_null(g_rvv[l_ac].rvv46) THEN
              IF NOT cl_null(g_rvv[l_ac].rvv82) AND NOT cl_null(g_rvv[l_ac].rvv85) THEN
                 IF g_rvv[l_ac].rvv85!=0 THEN
                    CALL t720_set_origin_field()
                    IF NOT t720_rvv17(p_cmd) THEN
                       NEXT FIELD rvv85
                    END IF                  
                 END IF
              END IF
           END IF
           #FUN-BC0104---add---end---
           CALL t720_set_rvv87()                     #No.MOD-760028 add
           CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
        BEFORE FIELD rvv80
           CALL t720_sel_ima()
           IF NOT cl_null(g_img09) THEN LET g_unit = g_img09 ELSE LET g_unit=g_ima25 END IF
           CALL t720_set_no_required(p_cmd)
 
        AFTER FIELD rvv80  #第一單位
           IF cl_null(g_rvv[l_ac].rvv31) THEN NEXT FIELD rvv31 END IF
           IF cl_null(g_rvv[l_ac].rvv33) THEN LET g_rvv[l_ac].rvv33 = ' ' END IF
           IF cl_null(g_rvv[l_ac].rvv34) THEN LET g_rvv[l_ac].rvv34 = ' ' END IF
           IF l_ec_sw <> 'Y' AND g_rvv[l_ac].rvv31 NOT MATCHES 'MISC*' THEN
              IF g_rvv[l_ac].rvv32 IS NULL OR g_rvv[l_ac].rvv33 IS NULL OR
                 g_rvv[l_ac].rvv34 IS NULL THEN
                 NEXT FIELD rvv32
              END IF
           END IF
           IF g_rvv_t.rvv80 IS NULL AND g_rvv[l_ac].rvv80 IS NOT NULL OR
              g_rvv_t.rvv80 IS NOT NULL AND g_rvv[l_ac].rvv80 IS NULL OR
              g_rvv_t.rvv80 <> g_rvv[l_ac].rvv80 THEN
              LET g_change='Y'
           END IF
           IF NOT cl_null(g_rvv[l_ac].rvv80) THEN
              IF g_rvv_t.rvv80 IS NULL OR g_rvv[l_ac].rvv80 != g_rvv_t.rvv80 THEN
                 CALL t720_unit(g_rvv[l_ac].rvv80)
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_rvv[l_ac].rvv80,g_errno,0)
                    LET g_rvv[l_ac].rvv80 = g_rvv_t.rvv80
                    NEXT FIELD rvv80
                 END IF
              END IF
              CALL t720_set_origin_field()   #MOD-A70201
              CALL s_du_umfchk(g_rvv[l_ac].rvv31,'','','',                      
                               g_rvv[l_ac].rvv35,g_rvv[l_ac].rvv80,'1')         
                   RETURNING g_errno,g_factor                                   
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_rvv[l_ac].rvv80,g_errno,0)
                 NEXT FIELD rvv80
              END IF
              IF cl_null(g_rvv_t.rvv80) OR g_rvv_t.rvv80 <> g_rvv[l_ac].rvv80 THEN
                 LET g_rvv[l_ac].rvv81 = g_factor
                 DISPLAY BY NAME g_rvv[l_ac].rvv81
              END IF
              #No.FUN-BB0086--add--begin--
              IF NOT cl_null(g_rvv[l_ac].rvv82) THEN
                 IF cl_null(g_rvv_t.rvv82) OR cl_null(g_rvv80_t) OR g_rvv_t.rvv82 != g_rvv[l_ac].rvv82 OR g_rvv80_t != g_rvv[l_ac].rvv80 THEN
                    LET g_rvv[l_ac].rvv82=s_digqty(g_rvv[l_ac].rvv82,g_rvv[l_ac].rvv80)
                    DISPLAY BY NAME g_rvv[l_ac].rvv82
                 END IF
              END IF
              LET g_rvv80_t = g_rvv[l_ac].rvv80
              #No.FUN-BB0086--add--end--
           END IF
           CALL t720_set_required(p_cmd)
           CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
        BEFORE FIELD rvv81  #第一轉換率
           IF cl_null(g_rvv[l_ac].rvv31) THEN NEXT FIELD rvv31 END IF
           IF cl_null(g_rvv[l_ac].rvv31) THEN NEXT FIELD rvv05 END IF
           IF cl_null(g_rvv[l_ac].rvv33) THEN LET g_rvv[l_ac].rvv33 = ' ' END IF
           IF cl_null(g_rvv[l_ac].rvv34) THEN LET g_rvv[l_ac].rvv34 = ' ' END IF
           IF l_ec_sw <> 'Y' AND g_rvv[l_ac].rvv31 NOT MATCHES 'MISC*' THEN
              IF g_rvv[l_ac].rvv32 IS NULL OR g_rvv[l_ac].rvv33 IS NULL OR
                 g_rvv[l_ac].rvv34 IS NULL THEN
                 NEXT FIELD rvv32
              END IF
           END IF
 
        AFTER FIELD rvv81  #第一轉換率
           IF g_rvv_t.rvv81 IS NULL AND g_rvv[l_ac].rvv81 IS NOT NULL OR
              g_rvv_t.rvv81 IS NOT NULL AND g_rvv[l_ac].rvv81 IS NULL OR
              g_rvv_t.rvv81 <> g_rvv[l_ac].rvv81 THEN
              LET g_change='Y'
              CALL t720_set_rvv87()              #MOD-820189 add
              DISPLAY BY NAME g_rvv[l_ac].rvv87  #MOD-820189 add
           END IF
           IF NOT cl_null(g_rvv[l_ac].rvv81) THEN
              IF g_rvv[l_ac].rvv81=0 THEN
                 NEXT FIELD rvv81
              END IF
           END IF
 
        BEFORE FIELD rvv82  #第一數量
           IF cl_null(g_rvv[l_ac].rvv31) THEN NEXT FIELD rvv31 END IF
           IF cl_null(g_rvv[l_ac].rvv31) THEN NEXT FIELD rvv05 END IF
           IF cl_null(g_rvv[l_ac].rvv33) THEN LET g_rvv[l_ac].rvv33 = ' ' END IF
           IF cl_null(g_rvv[l_ac].rvv34) THEN LET g_rvv[l_ac].rvv34 = ' ' END IF
           IF l_ec_sw <> 'Y' AND g_rvv[l_ac].rvv31 NOT MATCHES 'MISC*' THEN
              IF g_rvv[l_ac].rvv32 IS NULL OR g_rvv[l_ac].rvv33 IS NULL OR
                 g_rvv[l_ac].rvv34 IS NULL THEN
                 NEXT FIELD rvv32
              END IF
           END IF
 
        AFTER FIELD rvv82  #第一數量
           #No.FUN-BB0086--add--begin--
           IF NOT cl_null(g_rvv[l_ac].rvv82) AND NOT cl_null(g_rvv[l_ac].rvv80) THEN
              IF cl_null(g_rvv_t.rvv82) OR cl_null(g_rvv80_t) OR g_rvv_t.rvv82 != g_rvv[l_ac].rvv82 OR g_rvv80_t != g_rvv[l_ac].rvv80 THEN
                 LET g_rvv[l_ac].rvv82=s_digqty(g_rvv[l_ac].rvv82,g_rvv[l_ac].rvv80)
                 DISPLAY BY NAME g_rvv[l_ac].rvv82
                END IF
           END IF
           #No.FUN-BB0086--add--end--
           IF g_rvv[l_ac].rvv82 < 0 THEN
              CALL cl_err('','afa-043',0)
              NEXT FIELD rvv82
           END IF
           IF g_rvv_t.rvv82 IS NULL AND g_rvv[l_ac].rvv82 IS NOT NULL OR
              g_rvv_t.rvv82 IS NOT NULL AND g_rvv[l_ac].rvv82 IS NULL OR
              g_rvv_t.rvv82 <> g_rvv[l_ac].rvv82 THEN
              LET g_change='Y'
           END IF
           LET l_flag=TRUE  #FUN-810038
           IF NOT cl_null(g_rvv[l_ac].rvv80) AND
              g_rvv[l_ac].rvv31 NOT MATCHES 'MISC*' AND l_flag THEN #FUN-810038
              IF g_ima906 = '2' THEN
                 CALL s_chk_imgg(g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv32,
                                 g_rvv[l_ac].rvv33,g_rvv[l_ac].rvv34,
                                g_rvv[l_ac].rvv80) RETURNING g_flag
                 IF g_flag = 1 THEN
                    IF g_sma.sma892[3,3] ='Y' THEN
                       IF NOT cl_confirm('aim-995') THEN
                          NEXT FIELD rvv32
                       END IF
                    END IF
                    CALL s_add_imgg(g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv32,
                                    g_rvv[l_ac].rvv33,g_rvv[l_ac].rvv34,
                                    g_rvv[l_ac].rvv80,g_rvv[l_ac].rvv81,
                                    g_rvu.rvu01,
                                    g_rvv[l_ac].rvv02,0) RETURNING g_flag
                    IF g_flag = 1 THEN
                       NEXT FIELD rvv32
                    END IF
                 END IF
              END IF
           END IF
           IF NOT cl_null(g_rvv[l_ac].rvv82) THEN
              IF g_rvv[l_ac].rvv82 < 0 THEN
                 CALL cl_err('','aim-391',0)  #
                 NEXT FIELD rvv82
              END IF
           END IF
           CALL t720_set_origin_field()
            IF g_rvu.rvu00='1' THEN #MOD-4C0053
              SELECT rvb31 INTO g_inqty FROM rvb_file,rva_file
               WHERE rvb01=g_rvu.rvu02 AND rvb02=g_rvv[l_ac].rvv05
                 AND rvb01 = rva01
                 AND rvaconf !='X' #作廢資料要剔除 BugNo:3816
              IF cl_null(g_inqty) THEN LET g_inqty=0 END IF           #TQC-C20117 add 
              IF g_rvv[l_ac].rvv17 > g_inqty THEN  #異動數量不可大於可入庫量
                  CALL cl_err(g_inqty,'mfg3252',1) NEXT FIELD rvv82   #MOD-580184
              END IF
           END IF
           ##-入庫數量不可大於允收量
           IF g_rvu.rvu00='1' THEN
             #no.7143 檢驗碼改單身
              SELECT rvb33,rvb39 INTO l_rvb33,l_rvb39 FROM rvb_file
               WHERE rvb01=g_rvu.rvu02 AND rvb02=g_rvv[l_ac].rvv05
              IF l_rvb39 = 'Y' THEN
                 IF cl_null(l_rvb33) THEN LET l_rvb33 = 0 END IF #BugNo:6641
                 IF (g_rvv[l_ac].rvv17 > l_rvb33) THEN
                    #No.8939 mark
                    #IF g_qcz.qcz05 = 'N' AND g_sma.sma886[8,8]='Y' THEN #no.5071
                    IF g_qcz.qcz05 = 'N' THEN                            #No.8939
                       CALL cl_err(g_rvv[l_ac].rvv31,'apm-282',0)
                       NEXT FIELD rvv82
                    END IF
                 END IF
              END IF
              #本張單據,其他屬於此收貨項次的入庫數量
                SELECT SUM(rvv17) INTO l_rvv17_1_other FROM rvv_file,rvu_file
                 WHERE rvv04=g_rvu.rvu02 AND rvv05=g_rvv[l_ac].rvv05
                   AND rvv03='1'
                   AND rvv01 =g_rvu.rvu01
                   AND rvv01=rvu01
                   AND rvv02 !=g_rvv[l_ac].rvv02
                   AND rvuconf !='X'
               IF cl_null(l_rvv17_1_other) THEN
                  LET l_rvv17_1_other=0
               END IF
               LET l_rvv17_1_other = l_rvv17_1_other+ g_rvv[l_ac].rvv17
               #總允收數量
               SELECT SUM(rvb33) INTO l_rvb33_tol FROM rvb_file
                  WHERE rvb01=g_rvu.rvu02 AND rvb02=g_rvv[l_ac].rvv05
                    AND rvb39 = 'Y'
               IF l_rvv17_1_other > l_rvb33_tol THEN
                  CALL cl_err(g_rvv[l_ac].rvv31,'apm-306',0)
                  NEXT FIELD rvv82
               END IF
           END IF
           #退貨不可大於庫存量
           IF g_rvu.rvu00='3' THEN
              IF NOT cl_null(b_rvv.rvv04) THEN
                 SELECT SUM(rvv17) INTO l_rvv17_3 FROM rvv_file,rvu_file
                  WHERE rvv04=g_rvu.rvu02 AND rvv05=g_rvv[l_ac].rvv05
                    AND rvv03='3' AND rvv01 !=g_rvu.rvu01 AND rvv01=rvu01
                    AND rvuconf !='X'
                 IF cl_null(l_rvv17_3) THEN LET l_rvv17_3=0 END IF
                 #本張單據,其他屬於此收貨項次的數量
                 SELECT SUM(rvv17) INTO l_rvv17_3_other FROM rvv_file,rvu_file
                  WHERE rvv04=g_rvu.rvu02 AND rvv05=g_rvv[l_ac].rvv05
                    AND rvv03='3'
                    AND rvv01 =g_rvu.rvu01
                    AND rvv01=rvu01
                    AND rvv02 !=g_rvv[l_ac].rvv02
                    AND rvuconf !='X'
                 IF cl_null(l_rvv17_3_other) THEN
                    LET l_rvv17_3_other=0
                 END IF
                 SELECT rvb30 INTO g_inqty FROM rvb_file,rva_file
                  WHERE rvb01=g_rvu.rvu02 AND rvb02=g_rvv[l_ac].rvv05
                    AND rvb01=rva01
                    AND rvaconf !='X' #作廢資料要剔除 BugNo:3816
                 IF cl_null(g_inqty) THEN LET g_inqty=0 END IF
                 #異動數量不可大於入庫量-倉退量
                 #IF g_rvv[l_ac].rvv17 > (g_inqty-l_rvv17_3) THEN
                 IF g_rvv[l_ac].rvv17 > (g_inqty-l_rvv17_3-l_rvv17_3_other ) THEN
                    CALL cl_err(g_rvv[l_ac].rvv31,'apm-254',1)
                    NEXT FIELD rvv82
                 END IF
                 #No.9786(end)
              END IF
           END IF
           #驗退不可大於(收貨量-已輸入之驗退量)
           IF g_rvu.rvu00='2' THEN
              IF NOT cl_null(b_rvv.rvv04) THEN
                 SELECT SUM(rvv17) INTO l_rvv17_2 FROM rvv_file,rvu_file
                  WHERE rvv04=g_rvu.rvu02 AND rvv05=g_rvv[l_ac].rvv05
                    AND rvv03='2'
                    AND rvv01 !=g_rvu.rvu01
                    AND rvv01=rvu01
                    AND rvuconf !='X'
                IF cl_null(l_rvv17_2) THEN LET l_rvv17_2=0 END IF
                #本張單據,其他屬於此收貨項次的數量
                SELECT SUM(rvv17) INTO l_rvv17_2_other FROM rvv_file,rvu_file
                 WHERE rvv04=g_rvu.rvu02 AND rvv05=g_rvv[l_ac].rvv05
                   AND rvv03='2'
                   AND rvv01 =g_rvu.rvu01
                   AND rvv01=rvu01
                   AND rvv02 !=g_rvv[l_ac].rvv02
                   AND rvuconf !='X'
                 IF cl_null(l_rvv17_2_other) THEN
                    LET l_rvv17_2_other=0
                 END IF
                #修改可驗退數量控管
                #1.若走IQC   可驗退量=SUM(IQC送驗量) - SUM(IQC合格量) - 已驗退量
                #2.若不走IQC 可驗退量=實收數量 - 已入庫量 - 已驗退量
 
                 SELECT rvb07,rvb33,rvb30,rvb39 INTO g_inqty,l_okqty,
                    l_rvb30,l_rvb39  FROM rvb_file,rva_file
                 WHERE rvb01=g_rvu.rvu02 AND rvb02=g_rvv[l_ac].rvv05
                   AND rvb01=rva01
                   AND rvaconf !='X' #作廢資料要剔除 MODNO:3816
 
                 IF cl_null(g_inqty) THEN LET g_inqty=0 END IF
                 IF cl_null(l_okqty) THEN LET l_okqty=0 END IF
                 IF cl_null(l_rvb30) THEN LET l_rvb30=0 END IF
 
                 IF g_sma.sma886[8,8] = 'N'  OR l_rvb39='N' THEN   
                  #若勾選允收數與IQC勾稽 , 驗退量以qcs_file為主
                  #若不勾選允收數與IQC勾稽 , 驗退量以rvb_file為主
 
                    #不走IQC
                     IF g_rvv[l_ac].rvv17 > (g_inqty-l_rvv17_2-l_rvv17_2_other-l_rvb30) THEN
                         CALL cl_err(g_rvv[l_ac].rvv31,'apm-730',1)
                       NEXT FIELD rvv85
                     END IF
                  ELSE
                    #走IQC
                     SELECT SUM(qcs091),SUM(qcs22) INTO l_qcs091,l_qcs22
                        FROM qcs_file WHERE  qcs01 = g_rvu.rvu02
                        AND qcs02 = g_rvv[l_ac].rvv05
                        AND qcs14 = 'Y'               #確認否
 
                     IF cl_null(l_qcs091) THEN LET l_qcs091 = 0 END IF
                     IF cl_null(l_qcs22)  THEN LET l_qcs22 = 0 END IF
 
                     IF g_rvv[l_ac].rvv17 > (l_qcs22-l_rvv17_2-l_rvv17_2_other-l_qcs091) THEN
                         CALL cl_err(g_rvv[l_ac].rvv31,'apm-730',1)
                       NEXT FIELD rvv85
                     END IF
                 END IF
              END IF
           END IF
           CALL t720_set_rvv87()     #No.MOD-BB0271 add
           IF g_rvv[l_ac].rvv87>0 THEN   #MOD-AA0165 rvv17-->rvv87
              CALL t720sub_rvv38(g_rvv[l_ac].rvv36,g_rvv[l_ac].rvv38,g_rvv[l_ac].rvv38t,g_rvu.rvu04,g_rvu.rvu01)  #TQC-C30225 add
                    RETURNING g_rvv[l_ac].rvv38,g_rvv[l_ac].rvv38t 
              LET g_rvv[l_ac].rvv39=g_rvv[l_ac].rvv87*g_rvv[l_ac].rvv38   #MOD-AA0165 rvv17-->rvv87
              LET g_rvv[l_ac].rvv39t=g_rvv[l_ac].rvv87*b_rvv.rvv38t   #No.FUN-610018   #MOD-AA0165 rvv17-->rvv87
              #No.+090 010430 add by linda 依幣別四捨五入
             #MOD-C40047 str mark----
             #LET t_azi04=''  #No.CHI-6A0004
             #IF g_rva00 = '1' AND g_rvu.rvu00 = '3' THEN
             #   SELECT azi04 INTO t_azi04 FROM azi_file
             #       WHERE azi01 = g_rvu.rvu113
             #END IF
             #IF g_rva00 = '1' AND g_rvu.rvu00 <> '3' THEN
             #   SELECT azi04 INTO t_azi04                       #No.CHI-6A0004
             #      FROM pmm_file,azi_file
             #     WHERE pmm22=azi01
             #       AND pmm01 = g_rvv[l_ac].rvv36 AND pmm18 <> 'X'
             #END IF
             #IF g_rva00 = '2' THEN
             #   SELECT rva113 INTO l_rva113 FROM rva_file 
             #       WHERE rva01 = g_rvu.rvu02
             #   SELECT azi04 INTO t_azi04 FROM azi_file
             #       WHERE azi01 = l_rva113
             #END IF
             # IF cl_null(t_azi04) THEN                                                                                             
             #    SELECT azi04 INTO t_azi04                                                                                         
             #      FROM pmc_file,azi_file                                                                                          
             #     WHERE pmc22=azi01                                                                                                
             #       AND pmc01 = g_rvu.rvu04                                                                                        
             # END IF                                                                                                               
             #IF cl_null(t_azi04) THEN LET t_azi04=0 END IF  #No.CHI-6A0004
             #MOD-C40047 end mark-----
              CALL t720_get_azi()                            #MOD-C40047 add
              CALL cl_digcut(g_rvv[l_ac].rvv39,t_azi04)      #No.CHI-6A0004
                                RETURNING g_rvv[l_ac].rvv39
              CALL cl_digcut(g_rvv[l_ac].rvv39t,t_azi04)    #No.CHI-6A0004
                                RETURNING g_rvv[l_ac].rvv39t   #No.FUN-610018
              #CALL t720sub_rvv39(g_rvv[l_ac].rvv36,g_rvv39,g_rvv39t,g_rvu.rvu04,g_rvu.rvu02) #FUN-A10130  #MOD-BC0262 mark
              CALL t720sub_rvv39(g_rvv[l_ac].rvv36,g_rvv39,g_rvv39t,g_rvu.rvu04,g_rvu.rvu01)  #MOD-BC0262 add
                   RETURNING g_rvv39,g_rvv39t
              DISPLAY BY NAME g_rvv[l_ac].rvv39
              DISPLAY BY NAME g_rvv[l_ac].rvv39t
           END IF
           IF g_rvv[l_ac].rvv87 > 0 THEN   #MOD-AA0165 rvv17-->rvv87
              CALL t720sub_rvv38(g_rvv[l_ac].rvv36,b_rvv.rvv38,b_rvv.rvv38t,g_rvu.rvu04,g_rvu.rvu01)  #TQC-C30225 add
                  RETURNING b_rvv.rvv38,b_rvv.rvv38t
              LET g_rvv39=g_rvv[l_ac].rvv87*b_rvv.rvv38   #MOD-AA0165 rvv17-->rvv87
              LET g_rvv39t=g_rvv[l_ac].rvv87*b_rvv.rvv38t   #No.FUN-610018   #MOD-AA0165 rvv17-->rvv87
           END IF
           #No.+090 010430 add by linda 依幣別四捨五入
          #MOD-C40047 str mark----
          #LET t_azi04=''  #No.CHI-6A0004
          #IF g_rva00 = '1' AND g_rvu.rvu00 = '3' THEN
          #   SELECT azi04 INTO t_azi04 FROM azi_file
          #       WHERE azi01 = g_rvu.rvu113
          #END IF
          #IF g_rva00 = '1' AND g_rvu.rvu00 <> '3' THEN
          #   SELECT azi04 INTO t_azi04                       #No.CHI-6A0004
          #       FROM pmm_file,azi_file
          #      WHERE pmm22=azi01
          #        AND pmm01 = g_rvv[l_ac].rvv36 AND pmm18 <> 'X'
          #END IF
          #IF g_rva00 = '2' THEN
          #   SELECT rva113 INTO l_rva113 FROM rva_file 
          #      WHERE rva01 = g_rvu.rvu02
          #     SELECT azi04 INTO t_azi04 FROM azi_file
          #         WHERE azi01 = l_rva113
          #END IF
          #    IF g_rvv[l_ac].rvv17 = 0 OR cl_null(t_azi04) THEN     #No.MOD-8A0183
          #       SELECT azi04 INTO t_azi04
          #         FROM pmc_file,azi_file
          #        WHERE pmc22=azi01
          #          AND pmc01 = g_rvu.rvu04
          #    END IF
          ##FUN-BC0104---add---str---
          #IF g_sma.sma115='Y' AND NOT cl_null(g_rvv[l_ac].rvv46) THEN
          #   IF NOT cl_null(g_rvv[l_ac].rvv82) AND g_rvv[l_ac].rvv82!=0 THEN
          #      IF NOT t720_rvv17(p_cmd) THEN
          #         NEXT FIELD rvv82
          #      END IF
          #   END IF
          #END IF
          ##FUN-BC0104---add---end---
          ##CALL t720_set_rvv87()     #No.MOD-760028 add  #MOD-BB0271 mark
          #IF cl_null(t_azi04) THEN LET t_azi04=0 END IF   #No.CHI-6A0004
          #MOD-C40047 end mark----
           CALL t720_get_azi()                            #MOD-C40047 add
           CALL cl_digcut(g_rvv39,t_azi04)  #No.CHI-6A0004
                RETURNING g_rvv39
           CALL cl_digcut(g_rvv39t,t_azi04)  #No.CHI-6A0004
                RETURNING g_rvv39t   #No.FUN-610018
           #CALL t720sub_rvv39(g_rvv[l_ac].rvv36,g_rvv39,g_rvv39t,g_rvu.rvu04,g_rvu.rvu02) #FUN-A10130 #MOD-BC0262 mark 
           CALL t720sub_rvv39(g_rvv[l_ac].rvv36,g_rvv39,g_rvv39t,g_rvu.rvu04,g_rvu.rvu01)  #MOD-BC0262 add
                RETURNING g_rvv39,g_rvv39t
           CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
 
        BEFORE FIELD rvv86
           CALL t720_sel_ima()
           IF NOT cl_null(g_img09) THEN LET g_unit=g_img09 ELSE LET g_unit=g_ima25 END IF
           CALL t720_set_no_required(p_cmd)
 
        AFTER FIELD rvv86
          IF cl_null(g_rvv[l_ac].rvv31) THEN NEXT FIELD rvv31 END IF
          IF cl_null(g_rvv[l_ac].rvv33) THEN LET g_rvv[l_ac].rvv33 = ' ' END IF
          IF cl_null(g_rvv[l_ac].rvv34) THEN LET g_rvv[l_ac].rvv34 = ' ' END IF
          IF l_ec_sw <> 'Y' AND g_rvv[l_ac].rvv31 NOT MATCHES 'MISC*' THEN
             IF g_rvv[l_ac].rvv32 IS NULL OR g_rvv[l_ac].rvv33 IS NULL OR
                g_rvv[l_ac].rvv34 IS NULL THEN
                NEXT FIELD rvv32
             END IF
          END IF
          IF g_rvv_t.rvv86 IS NULL AND g_rvv[l_ac].rvv86 IS NOT NULL OR
             g_rvv_t.rvv86 IS NOT NULL AND g_rvv[l_ac].rvv86 IS NULL OR
             g_rvv_t.rvv86 <> g_rvv[l_ac].rvv86 THEN
             LET g_change='Y'
          END IF
          IF NOT cl_null(g_rvv[l_ac].rvv86) THEN
             IF g_rvv_t.rvv86 IS NULL OR g_rvv[l_ac].rvv86 != g_rvv_t.rvv86 THEN
                CALL t720_unit(g_rvv[l_ac].rvv86)
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_rvv[l_ac].rvv86,g_errno,0)
                   LET g_rvv[l_ac].rvv86 = g_rvv_t.rvv86
                   NEXT FIELD rvv86
                END IF
             END IF
             CALL s_du_umfchk(g_rvv[l_ac].rvv31,'','','',
                              g_ima25,g_rvv[l_ac].rvv86,'2')
                  RETURNING g_errno,g_factor
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_rvv[l_ac].rvv86,g_errno,0)
                NEXT FIELD rvv86
             END IF
             IF g_rvv_t.rvv31 != g_rvv[l_ac].rvv31 THEN #MOD-C50254 add
                CALL t720_get_price()  #NO.FUN-940083
             END IF #MOD-C50254 add
             #No.FUN-BB0086--add--begin--
             IF NOT cl_null(g_rvv[l_ac].rvv87) AND g_rvv[l_ac].rvv87!=0 THEN
                IF NOT t720_rvv87_check(p_cmd) THEN 
                   LET g_rvv86_t = g_rvv[l_ac].rvv86
                   NEXT FIELD rvv87
                END IF 
             END IF
             LET g_rvv86_t = g_rvv[l_ac].rvv86
             #No.FUN-BB0086--add--end--
          END IF
           CALL t720_set_required(p_cmd)
 
        BEFORE FIELD rvv87
           CALL t720_du_data_to_correct()
           IF g_change = 'Y' THEN
              CALL t720_set_rvv87()
           END IF
 
        AFTER FIELD rvv87
           IF NOT t720_rvv87_check(p_cmd) THEN NEXT FIELD rvv87 END IF   #No.FUN-BB0086
        #No.FUN-BB0086--mark--begin--
        #FUN-BC0104---add---str---
        #IF NOT t720_rvv87(p_cmd) THEN
        #   NEXT FIELD rvv87
        #END IF
        #FUN-BC0104---add---end---
        #No.FUN-BB0086--mark--end--
############FUN-BC0104-----mark-----str#############
#獨立到FUNCTION t720_rvv87()
#          IF g_rvv[l_ac].rvv87 < 0 THEN
#             CALL cl_err('','afa-043',0)
#             NEXT FIELD rvv87
#          END IF
#          IF NOT cl_null(g_rvv[l_ac].rvv87) THEN
#             IF g_rvv[l_ac].rvv87 < 0 THEN
#                NEXT FIELD rvv87
#             END IF
#             #FUN-5B0144 add IF #當金額為0時計算含稅金額
#            #IF g_rvv[l_ac].rvv87 > 0 THEN #MOD-B30033 mark
#             IF g_rvv[l_ac].rvv87>0 OR g_rvu.rvu00 ='1' THEN #MOD-B30033
#                LET g_rvv[l_ac].rvv39=g_rvv[l_ac].rvv87*g_rvv[l_ac].rvv38
#                LET g_rvv[l_ac].rvv39t=g_rvv[l_ac].rvv87*g_rvv[l_ac].rvv38t   #No.FUN-610018
#                LET b_rvv.rvv39t=g_rvv[l_ac].rvv87*b_rvv.rvv38t
#               #-----MOD-AC0024---------
#                CALL cl_digcut(g_rvv[l_ac].rvv39,t_azi04)  
#                                  RETURNING g_rvv[l_ac].rvv39
#                CALL cl_digcut(g_rvv[l_ac].rvv39t,t_azi04)   
#                                  RETURNING g_rvv[l_ac].rvv39t  
#               #-----END MOD-AC0024-----
#                CALL t720sub_rvv39(g_rvv[l_ac].rvv36,g_rvv[l_ac].rvv39,g_rvv[l_ac].rvv39t,g_rvu.rvu04,g_rvu.rvu02) #FUN-A10130  
#                     RETURNING g_rvv[l_ac].rvv39,g_rvv[l_ac].rvv39t
#                DISPLAY BY NAME g_rvv[l_ac].rvv39
#                DISPLAY BY NAME g_rvv[l_ac].rvv39t
#             ELSE
#               #MOD-B30033 mark --start--
#               #CALL t720_pmm43(g_rvv[l_ac].rvv36) RETURNING l_pmm43
#               #LET b_rvv.rvv39t = g_rvv[l_ac].rvv39 * (1+l_pmm43/100)
#               #MOD-B30033 mark --end--
#                #MOD-B30033 add --start--
#                   IF g_rvu.rvu00 ='3' THEN
#                      LET g_rvv[l_ac].rvv39=g_rvv[l_ac].rvv38
#                      LET g_rvv[l_ac].rvv39t=g_rvv[l_ac].rvv38t 
#                      LET b_rvv.rvv39t=b_rvv.rvv38t
#                      CALL cl_digcut(g_rvv[l_ac].rvv39,t_azi04)  
#                                        RETURNING g_rvv[l_ac].rvv39
#                      CALL cl_digcut(g_rvv[l_ac].rvv39t,t_azi04)   
#                                        RETURNING g_rvv[l_ac].rvv39t  
#                      CALL t720sub_rvv39(g_rvv[l_ac].rvv36,g_rvv[l_ac].rvv39,g_rvv[l_ac].rvv39t,g_rvu.rvu04,g_rvu.rvu02)  
#                           RETURNING g_rvv[l_ac].rvv39,g_rvv[l_ac].rvv39t
#                      DISPLAY BY NAME g_rvv[l_ac].rvv39
#                      DISPLAY BY NAME g_rvv[l_ac].rvv39t
#                   END IF 
#                #MOD-B30033 add --end--
#             END IF
#             CALL t720_get_price()  #NO.FUN-940083
#           END IF
############FUN-BC0104-----mark-----end#############
 
        #-----CHI-B50027---------
        BEFORE FIELD rvv38,rvv38t
          IF g_rvu.rvu00 <> '1' THEN    #因為入庫單身單價原先都是不可輸入的,只能透過"價格變更作業"
             CALL cl_set_comp_entry("rvv38,rvv38t",TRUE)
             IF NOT cl_null(g_rvv[l_ac].rvv36) THEN 
                LET l_pmm21 = ''
                SELECT pmm21 INTO l_pmm21 FROM pmm_file WHERE pmm01 = g_rvv[l_ac].rvv36  
                LET l_gec07 = ''
                SELECT gec07 INTO l_gec07 FROM gec_file WHERE gec01 = l_pmm21 AND gec011 = '1'
                IF l_gec07 = 'Y' THEN
                   CALL cl_set_comp_entry("rvv38",FALSE)
                ELSE
                   CALL cl_set_comp_entry("rvv38t",FALSE)
                END IF
             END IF 
          END IF
        #-----END CHI-B50027-----
 
        AFTER FIELD rvv38
           IF cl_null(g_rvv[l_ac].rvv38) THEN                                  
              NEXT FIELD rvv38
           END IF                                                               
           #MOD-CB0148 -- add start --
           IF g_rvv[l_ac].rvv38 < 0 THEN
              CALL cl_err(g_rvv[l_ac].rvv38,'mfg5034',0)
              NEXT FIELD rvv38
           END IF
           #MOD-CB0148 -- add end --
           CALL t720_get_azi()
           CALL cl_digcut(g_rvv[l_ac].rvv38,t_azi03)
                             RETURNING g_rvv[l_ac].rvv38
          #IF g_rvv[l_ac].rvv87>0 THEN #MOD-B30033 mark
           IF g_rvv[l_ac].rvv87>0 OR g_rvu.rvu00 ='1' THEN #MOD-B30033
              IF g_rvv[l_ac].rvv36 IS NULL THEN
                 SELECT gec04 INTO l_pmm43 FROM pmc_file,gec_file WHERE pmc01=g_rvu.rvu04 AND gec01=pmc47
              ELSE
                 CALL t720_pmm43(g_rvv[l_ac].rvv36) RETURNING l_pmm43
                 #-----CHI-AA0026---------
                 IF cl_null(l_pmm43) THEN
                    SELECT gec04 INTO l_pmm43 FROM gec_file,pmc_file
                     WHERE gec01 = pmc47
                       AND pmc01 = g_rvu.rvu04
                       AND gec011='1'  #進項
                 END IF
                 #-----END CHI-AA0026-----
              END IF
              LET g_rvv[l_ac].rvv38t=g_rvv[l_ac].rvv38*(1+l_pmm43/100)   #TQC-7A0034
              CALL cl_digcut(g_rvv[l_ac].rvv38t,t_azi03)     #MOD-940073
                                RETURNING g_rvv[l_ac].rvv38t   #MOD-940073
              LET g_rvv[l_ac].rvv39=g_rvv[l_ac].rvv87*g_rvv[l_ac].rvv38
              LET g_rvv[l_ac].rvv39t=g_rvv[l_ac].rvv87*g_rvv[l_ac].rvv38t
              LET b_rvv.rvv39t=g_rvv[l_ac].rvv87*b_rvv.rvv38t
             #MOD-C40047 str mark----
             #LET t_azi04=''
             #IF g_rva00 = '1' AND g_rvu.rvu00 = '3' THEN
             #   SELECT azi04 INTO t_azi04 FROM azi_file
             #       WHERE azi01 = g_rvu.rvu113
             #END IF
             #IF g_rva00 = '1' AND g_rvu.rvu00 <> '3' THEN
             #   SELECT azi04 INTO t_azi04                       #No.CHI-6A0004
             #       FROM pmm_file,azi_file
             #     WHERE pmm22=azi01
             #       AND pmm01 = g_rvv[l_ac].rvv36 AND pmm18 <> 'X'
             #END IF
             #IF g_rva00 = '2' THEN
             #   SELECT rva113 INTO l_rva113 FROM rva_file 
             #       WHERE rva01 = g_rvu.rvu02
             #   SELECT azi04 INTO t_azi04 FROM azi_file
             #       WHERE azi01 = l_rva113
             #END IF
             # IF cl_null(t_azi04) THEN                                                                                             
             #    SELECT azi04 INTO t_azi04                                                                                         
             #      FROM pmc_file,azi_file                                                                                          
             #     WHERE pmc22=azi01                                                                                                
             #       AND pmc01 = g_rvu.rvu04                                                                                        
             # END IF                                                                                                               
             #IF cl_null(t_azi04) THEN LET t_azi04=0 END IF  #No.CHI-6A0004
             #MOD-C40047 end mark----
              CALL t720_get_azi()                            #MOD-C40047 add
              #CALL t720sub_rvv39(g_rvv[l_ac].rvv36,g_rvv[l_ac].rvv39,g_rvv[l_ac].rvv39t,g_rvu.rvu04,g_rvu.rvu02) #FUN-A10130 #MOD-BC0262 mark   
              CALL t720sub_rvv39(g_rvv[l_ac].rvv36,g_rvv[l_ac].rvv39,g_rvv[l_ac].rvv39t,g_rvu.rvu04,g_rvu.rvu01)  #MOD-BC0262 add
                   RETURNING g_rvv[l_ac].rvv39,g_rvv[l_ac].rvv39t
              CALL cl_digcut(g_rvv[l_ac].rvv39,t_azi04)  #No.CHI-6A0004
                                RETURNING g_rvv[l_ac].rvv39
              CALL cl_digcut(g_rvv[l_ac].rvv39t,t_azi04) #No.CHI-6A0004
                                RETURNING g_rvv[l_ac].rvv39t   #No.FUN-610018
#MOD-B70231 -- begin --
              IF g_rvu.rvu00 = '3' THEN
                 IF NOT cl_null(b_rvv.rvv04) THEN
                    IF NOT cl_null(g_rvv[l_ac].rvv36) AND NOT cl_null(g_rvv[l_ac].rvv37) THEN   #MOD-BA0048 add
                       SELECT pmn88,pmn88t INTO l_pmn88,l_pmn88t FROM pmn_file
                          WHERE pmn01 = g_rvv[l_ac].rvv36 AND pmn02 = g_rvv[l_ac].rvv37
                       IF cl_null(l_pmn88) THEN LET l_pmn88 = 0 END IF
                       IF cl_null(l_pmn88t) THEN LET l_pmn88t = 0 END IF
                       IF g_rvv[l_ac].rvv39 > l_pmn88 OR g_rvv[l_ac].rvv39t > l_pmn88t THEN
                          CALL cl_err('','apm-250',1)
                          NEXT FIELD rvv38
                       END IF
                    END IF #MOD-BA0048 add
                 END IF
              END IF
#MOD-B70231 -- end --
             DISPLAY BY NAME g_rvv[l_ac].rvv38t   #TQC-7A0034
             DISPLAY BY NAME g_rvv[l_ac].rvv39
             DISPLAY BY NAME g_rvv[l_ac].rvv39t
           #MOD-B10167 add --start--
           ELSE
              IF g_rvu.rvu00 ='3' THEN #MOD-B30033 add
                 IF g_rvv[l_ac].rvv36 IS NULL THEN
                    #MOD-BC0262 ----- modify start -----
                    IF cl_null(g_rvu.rvu115) AND cl_null(g_rvu.rvu12) THEN
                       SELECT pmc22,pmc47 INTO l_pmc22,l_pmm21
                         FROM pmc_file
                        WHERE pmc01 = g_rvu.rvu04

                       SELECT gec04 INTO l_pmm43
                         FROM gec_file
                        WHERE gec01 = l_pmm21
                          AND gec011 = '1'
                    ELSE
                       LET l_pmm21 = g_rvu.rvu115
                       LET l_pmm43 = g_rvu.rvu12
                    END IF
                    #MOD-BC0262 ----- modify end -----
                    #SELECT gec04 INTO l_pmm43 FROM pmc_file,gec_file WHERE pmc01=g_rvu.rvu04 AND gec01=pmc47 #MOD-BC0262 add
                 ELSE
                    CALL t720_pmm43(g_rvv[l_ac].rvv36) RETURNING l_pmm43
                    IF cl_null(l_pmm43) THEN
                       SELECT gec04 INTO l_pmm43 FROM gec_file,pmc_file
                        WHERE gec01 = pmc47
                          AND pmc01 = g_rvu.rvu04
                          AND gec011='1'  #進項
                    END IF
                 END IF
                 LET g_rvv[l_ac].rvv38t=g_rvv[l_ac].rvv38*(1+l_pmm43/100) 
                 CALL cl_digcut(g_rvv[l_ac].rvv38t,t_azi03)    
                                   RETURNING g_rvv[l_ac].rvv38t
                 LET g_rvv[l_ac].rvv39=g_rvv[l_ac].rvv38
                 LET g_rvv[l_ac].rvv39t=g_rvv[l_ac].rvv38t
                 LET b_rvv.rvv39t=b_rvv.rvv38t
                #MOD-C40047 str mark----
                #LET t_azi04=''
                #IF g_rva00 = '1' AND g_rvu.rvu00 = '3' THEN
                #   SELECT azi04 INTO t_azi04 FROM azi_file
                #       WHERE azi01 = g_rvu.rvu113
                #END IF
                #IF g_rva00 = '1' AND g_rvu.rvu00 <> '3' THEN
                #   SELECT azi04 INTO t_azi04   
                #       FROM pmm_file,azi_file
                #     WHERE pmm22=azi01
                #       AND pmm01 = g_rvv[l_ac].rvv36 AND pmm18 <> 'X'
                #END IF
                #IF g_rva00 = '2' THEN
                #   SELECT rva113 INTO l_rva113 FROM rva_file 
                #       WHERE rva01 = g_rvu.rvu02
                #   SELECT azi04 INTO t_azi04 FROM azi_file
                #    WHERE azi01 = l_rva113
                #END IF
                # IF cl_null(t_azi04) THEN                                                                                             
                #    SELECT azi04 INTO t_azi04                                                                                         
                #      FROM pmc_file,azi_file                                                                                          
                #     WHERE pmc22=azi01                                                                                                
                #       AND pmc01 = g_rvu.rvu04                                                                                        
                # END IF                                                                                                               
                #IF cl_null(t_azi04) THEN LET t_azi04=0 END IF  
                #MOD-C40047 end mark----
                 CALL t720_get_azi()                            #MOD-C40047 add
                 #CALL t720sub_rvv39(g_rvv[l_ac].rvv36,g_rvv[l_ac].rvv39,g_rvv[l_ac].rvv39t,g_rvu.rvu04,g_rvu.rvu02)  #MOD-BC0262 mark 
                 CALL t720sub_rvv39(g_rvv[l_ac].rvv36,g_rvv[l_ac].rvv39,g_rvv[l_ac].rvv39t,g_rvu.rvu04,g_rvu.rvu01)   #MOD-BC0262 add 
                      RETURNING g_rvv[l_ac].rvv39,g_rvv[l_ac].rvv39t
                 CALL cl_digcut(g_rvv[l_ac].rvv39,t_azi04) 
                                   RETURNING g_rvv[l_ac].rvv39
                 CALL cl_digcut(g_rvv[l_ac].rvv39t,t_azi04) 
                                   RETURNING g_rvv[l_ac].rvv39t 
                 DISPLAY BY NAME g_rvv[l_ac].rvv38t 
                 DISPLAY BY NAME g_rvv[l_ac].rvv39
                 DISPLAY BY NAME g_rvv[l_ac].rvv39t
              END IF #MOD-B30033 add
           #MOD-B10167 add --end--
           END IF
           #MOD-D60076 add begin--------
           IF g_rvu.rvu00 ='3' AND NOT cl_null(g_rvv[l_ac].rvv38) AND g_rvu.rvu116 ='3' AND g_rvu.rvu08 ='SUB' THEN
              IF NOT cl_null(g_rvv[l_ac].rvv36) AND NOT cl_null(g_rvv[l_ac].rvv37) THEN
                 SELECT pmn31,pmn31t,pmn88,pmn88t INTO l_pmn31,l_pmn31t,l_pmn88,l_pmn88t FROM pmn_file
                    WHERE pmn01 = g_rvv[l_ac].rvv36 AND pmn02 = g_rvv[l_ac].rvv37
                 IF cl_null(l_pmn88) THEN LET l_pmn88 = 0 END IF
                 IF cl_null(l_pmn88t) THEN LET l_pmn88t = 0 END IF
                 #大于本委外采购单对应的金额,提示信息
                 IF g_rvv[l_ac].rvv39 > l_pmn88 OR g_rvv[l_ac].rvv39t > l_pmn88t THEN
                    IF NOT cl_confirm('apm-200') THEN
                       LET l_yes = 'N'
                    ELSE 
                       LET l_yes = 'Y'
                    END IF
                    IF l_yes = 'N' THEN
                       LET g_rvv[l_ac].rvv38 =  l_pmn88
                       LET g_rvv[l_ac].rvv38t =  l_pmn88t
                       NEXT FIELD rvv38
                    ELSE 
                    
                    END IF                     
                 END IF
              END IF
              #大于本委外收货单对应的金额,提示信息 
              IF NOT cl_null(g_rvu.rvu02) THEN 
                 SELECT rvv39,rvv39t INTO  l_rvv39,l_rvv39t FROM rvv_file,rvu_file
                  WHERE rvv01 = rvu01 
                    AND rvu02 = g_rvu.rvu02
                    AND rvv02 = g_rvv[l_ac].rvv02
                    AND rvu00 ='1'
                    AND rvu08 ='SUB'
                 SELECT SUM(rvv39),SUM(rvv39t) INTO l_rvv39_sum,l_rvv39t_sum FROM rvv_file,rvu_file
                  WHERE rvu01 = rvv01
                    AND rvu02 = g_rvu.rvu02
                    AND rvv02 = g_rvv[l_ac].rvv02
                    AND rvu00 ='3'
                    AND rvu116 ='3'
                    AND rvu08 ='SUB'
                    AND rvu01 != g_rvu.rvu01
                 IF cl_null(l_rvv39_sum) THEN LET l_rvv39_sum = 0 END IF 
                 IF cl_null(l_rvv39t_sum) THEN LET l_rvv39t_sum = 0 END IF  
                 IF (l_rvv39_sum + g_rvv[l_ac].rvv38 > l_rvv39) OR (l_rvv39t_sum + g_rvv[l_ac].rvv38t > l_rvv39t) THEN 
                    IF NOT cl_confirm('apm-179') THEN
                       LET l_yes = 'N'
                    ELSE 
                       LET l_yes = 'Y'
                    END IF
                    IF l_yes = 'N' THEN
                       LET g_rvv[l_ac].rvv38 =  l_pmn31
                       LET g_rvv[l_ac].rvv38t =  l_pmn31t
                       NEXT FIELD rvv38
                    ELSE 
                    
                    END IF                    
                 END IF
              END IF   
           END IF  
           #MOD-D60076 add end----------
 
         AFTER FIELD rvv38t
           IF cl_null(g_rvv[l_ac].rvv38t) THEN                                  
              NEXT FIELD rvv38t                                                 
           END IF                                                               
           #MOD-CB0148 -- add start --
           IF g_rvv[l_ac].rvv38t < 0 THEN
              CALL cl_err(g_rvv[l_ac].rvv38t,'mfg5034',0)
              NEXT FIELD rvv38t
           END IF
           #MOD-CB0148 -- add end --
           CALL t720_get_azi()
           CALL cl_digcut(g_rvv[l_ac].rvv38t,t_azi03)
                             RETURNING g_rvv[l_ac].rvv38t
           #MOD-B10167 add --start--
          #IF g_rvv[l_ac].rvv87>0 THEN #MOD-B30033 mark
           IF g_rvv[l_ac].rvv87>0 OR g_rvu.rvu00 ='1' THEN #MOD-B30033
              IF g_rvv[l_ac].rvv36 IS NULL THEN
                 SELECT gec04 INTO l_pmm43 FROM pmc_file,gec_file WHERE pmc01=g_rvu.rvu04 AND gec01=pmc47
              ELSE
                 CALL t720_pmm43(g_rvv[l_ac].rvv36) RETURNING l_pmm43
                 IF cl_null(l_pmm43) THEN
                    SELECT gec04 INTO l_pmm43 FROM gec_file,pmc_file
                     WHERE gec01 = pmc47
                       AND pmc01 = g_rvu.rvu04
                       AND gec011='1'  #進項
                 END IF
              END IF
            #TQC-D80008 --------Begin-----------
              IF g_azw.azw04 = '2' AND g_prog='apmt742' THEN
                 IF g_rvv[l_ac].rvv38t <> g_rvv38t_t OR cl_null(g_rvv38t_t)  THEN
                    LET g_rvv[l_ac].rvv38=g_rvv[l_ac].rvv38t/(1+l_pmm43/100)
                 END IF
              ELSE
            #TQC-D80008 --------End-------------
                 LET g_rvv[l_ac].rvv38=g_rvv[l_ac].rvv38t/(1+l_pmm43/100)  
              END IF      #TQC-D80008
              CALL cl_digcut(g_rvv[l_ac].rvv38,t_azi03)    
                                RETURNING g_rvv[l_ac].rvv38  
              CALL t720sub_rvv38(g_rvv[l_ac].rvv36,g_rvv[l_ac].rvv38,g_rvv[l_ac].rvv38t,g_rvu.rvu04,g_rvu.rvu01)   #TQC-C30225 add
                  RETURNING g_rvv[l_ac].rvv38,g_rvv[l_ac].rvv38t
              LET g_rvv[l_ac].rvv39=g_rvv[l_ac].rvv87*g_rvv[l_ac].rvv38
              LET g_rvv[l_ac].rvv39t=g_rvv[l_ac].rvv87*g_rvv[l_ac].rvv38t
              LET b_rvv.rvv39t=g_rvv[l_ac].rvv87*b_rvv.rvv38t
             #MOD-C40047 str mark----
             #LET t_azi04=''
             #IF g_rva00 = '1' AND g_rvu.rvu00 = '3' THEN
             #   SELECT azi04 INTO t_azi04 FROM azi_file
             #       WHERE azi01 = g_rvu.rvu113
             #END IF
             #IF g_rva00 = '1' AND g_rvu.rvu00 <> '3' THEN
             #   SELECT azi04 INTO t_azi04   
             #       FROM pmm_file,azi_file
             #     WHERE pmm22=azi01
             #       AND pmm01 = g_rvv[l_ac].rvv36 AND pmm18 <> 'X'
             #END IF
             #IF g_rva00 = '2' THEN
             #   SELECT rva113 INTO l_rva113 FROM rva_file 
             #       WHERE rva01 = g_rvu.rvu02
             #   SELECT azi04 INTO t_azi04 FROM azi_file
             #       WHERE azi01 = l_rva113
             #END IF
             # IF cl_null(t_azi04) THEN                                                                                             
             #    SELECT azi04 INTO t_azi04                                                                                         
             #      FROM pmc_file,azi_file                                                                                          
             #     WHERE pmc22=azi01                                                                                                
             #       AND pmc01 = g_rvu.rvu04                                                                                        
             # END IF                                                                                                               
             #IF cl_null(t_azi04) THEN LET t_azi04=0 END IF  
             #MOD-C40047 end mark----
              CALL t720_get_azi()                            #MOD-C40047 add
              #CALL t720sub_rvv39(g_rvv[l_ac].rvv36,g_rvv[l_ac].rvv39,g_rvv[l_ac].rvv39t,g_rvu.rvu04,g_rvu.rvu02)  #MOD-BC0262 mark 
              CALL t720sub_rvv39(g_rvv[l_ac].rvv36,g_rvv[l_ac].rvv39,g_rvv[l_ac].rvv39t,g_rvu.rvu04,g_rvu.rvu01)   #MOD-BC0262 add
                   RETURNING g_rvv[l_ac].rvv39,g_rvv[l_ac].rvv39t
              CALL cl_digcut(g_rvv[l_ac].rvv39,t_azi04)  
                                RETURNING g_rvv[l_ac].rvv39
              CALL cl_digcut(g_rvv[l_ac].rvv39t,t_azi04) 
                                RETURNING g_rvv[l_ac].rvv39t   
             DISPLAY BY NAME g_rvv[l_ac].rvv38  
             DISPLAY BY NAME g_rvv[l_ac].rvv39
             DISPLAY BY NAME g_rvv[l_ac].rvv39t
           ELSE
              IF g_rvu.rvu00 ='3' THEN #MOD-B30033 add
                 IF g_rvv[l_ac].rvv36 IS NULL THEN
                    #MOD-BC0262 ----- modify start -----
                    IF cl_null(g_rvu.rvu115) AND cl_null(g_rvu.rvu12) THEN
                       SELECT pmc22,pmc47 INTO l_pmc22,l_pmm21
                         FROM pmc_file
                        WHERE pmc01 = g_rvu.rvu04

                       SELECT gec04 INTO l_pmm43
                         FROM gec_file
                        WHERE gec01 = l_pmm21
                          AND gec011 = '1'
                    ELSE
                       LET l_pmm21 = g_rvu.rvu115
                       LET l_pmm43 = g_rvu.rvu12
                    END IF
                    #MOD-BC0262 ----- modify end -----
                    #SELECT gec04 INTO l_pmm43 FROM pmc_file,gec_file WHERE pmc01=g_rvu.rvu04 AND gec01=pmc47 #MOD-BC0262 mark
                 ELSE
                    CALL t720_pmm43(g_rvv[l_ac].rvv36) RETURNING l_pmm43
                    IF cl_null(l_pmm43) THEN
                       SELECT gec04 INTO l_pmm43 FROM gec_file,pmc_file
                        WHERE gec01 = pmc47
                          AND pmc01 = g_rvu.rvu04
                          AND gec011='1'  #進項
                    END IF
                 END IF
                 LET g_rvv[l_ac].rvv38=g_rvv[l_ac].rvv38t/(1+l_pmm43/100) 
                 CALL cl_digcut(g_rvv[l_ac].rvv38,t_azi03)    
                                   RETURNING g_rvv[l_ac].rvv38
                 CALL t720sub_rvv38(g_rvv[l_ac].rvv36,g_rvv[l_ac].rvv38,g_rvv[l_ac].rvv38t,g_rvu.rvu04,g_rvu.rvu01)   #TQC-C30225 add
                      RETURNING g_rvv[l_ac].rvv38,g_rvv[l_ac].rvv38t
                 LET g_rvv[l_ac].rvv39=g_rvv[l_ac].rvv38
                 LET g_rvv[l_ac].rvv39t=g_rvv[l_ac].rvv38t
                 LET b_rvv.rvv39t=b_rvv.rvv38t
                 CALL cl_digcut(g_rvv[l_ac].rvv38,t_azi03)   #MOD-B10167 add 
                                   RETURNING g_rvv[l_ac].rvv38
                #MOD-C40047 str mark----
                #LET t_azi04=''
                #IF g_rva00 = '1' AND g_rvu.rvu00 = '3' THEN
                #   SELECT azi04 INTO t_azi04 FROM azi_file
                #    WHERE azi01 = g_rvu.rvu113
                #END IF
                #IF g_rva00 = '1' AND g_rvu.rvu00 <> '3' THEN
                #   SELECT azi04 INTO t_azi04   
                #     FROM pmm_file,azi_file
                #     WHERE pmm22=azi01
                #       AND pmm01 = g_rvv[l_ac].rvv36 AND pmm18 <> 'X'
                #END IF
                #IF g_rva00 = '2' THEN
                #   SELECT rva113 INTO l_rva113 FROM rva_file 
                #    WHERE rva01 = g_rvu.rvu02
                #   SELECT azi04 INTO t_azi04 FROM azi_file
                #    WHERE azi01 = l_rva113
                #END IF
                # IF cl_null(t_azi04) THEN                                                                                             
                #    SELECT azi04 INTO t_azi04                                                                                         
                #      FROM pmc_file,azi_file                                                                                          
                #     WHERE pmc22=azi01                                                                                                
                #       AND pmc01 = g_rvu.rvu04                                                                                        
                # END IF                                                                                                               
                #IF cl_null(t_azi04) THEN LET t_azi04=0 END IF 
                #MOD-C40047 end mark----
                 CALL t720_get_azi()                            #MOD-C40047 add
                 #CALL t720sub_rvv39(g_rvv[l_ac].rvv36,g_rvv[l_ac].rvv39,g_rvv[l_ac].rvv39t,g_rvu.rvu04,g_rvu.rvu02)  #MOD-BC0262 mark 
                 CALL t720sub_rvv39(g_rvv[l_ac].rvv36,g_rvv[l_ac].rvv39,g_rvv[l_ac].rvv39t,g_rvu.rvu04,g_rvu.rvu01)   #MOD-BC0262 add
                      RETURNING g_rvv[l_ac].rvv39,g_rvv[l_ac].rvv39t
                 CALL cl_digcut(g_rvv[l_ac].rvv39,t_azi04) 
                                   RETURNING g_rvv[l_ac].rvv39
                 CALL cl_digcut(g_rvv[l_ac].rvv39t,t_azi04) 
                                   RETURNING g_rvv[l_ac].rvv39t 
                 DISPLAY BY NAME g_rvv[l_ac].rvv38 
                 DISPLAY BY NAME g_rvv[l_ac].rvv39
                 DISPLAY BY NAME g_rvv[l_ac].rvv39t
              END IF #MOD-B30033 add
           END IF
           #MOD-B10167 add --end--
           #MOD-D60076 add begin--------
           IF g_rvu.rvu00 ='3' AND NOT cl_null(g_rvv[l_ac].rvv38) AND g_rvu.rvu116 ='3' AND g_rvu.rvu08 ='SUB'  THEN
              IF NOT cl_null(g_rvv[l_ac].rvv36) AND NOT cl_null(g_rvv[l_ac].rvv37) THEN
                 SELECT pmn31,pmn31t,pmn88,pmn88t INTO l_pmn31,l_pmn31t,l_pmn88,l_pmn88t FROM pmn_file
                    WHERE pmn01 = g_rvv[l_ac].rvv36 AND pmn02 = g_rvv[l_ac].rvv37
                 IF cl_null(l_pmn88) THEN LET l_pmn88 = 0 END IF
                 IF cl_null(l_pmn88t) THEN LET l_pmn88t = 0 END IF
                 IF g_rvv[l_ac].rvv39 > l_pmn88 OR g_rvv[l_ac].rvv39t > l_pmn88t THEN
                    IF NOT cl_confirm('apm-200') THEN
                       LET l_yes = 'N'
                       LET g_rvv[l_ac].rvv38 =  l_pmn31
                       LET g_rvv[l_ac].rvv38t = l_pmn31t                       
                    ELSE 
                       LET l_yes = 'Y'
                    END IF
                    IF l_yes = 'N' THEN 
                       NEXT FIELD rvv38t
                    ELSE 
                    
                    END IF                     
                 END IF
              END IF
              #大于本委外收货单对应的金额,提示信息 
              IF NOT cl_null(g_rvu.rvu02) THEN 
                 SELECT rvv39,rvv39t INTO  l_rvv39,l_rvv39t FROM rvv_file,rvu_file
                  WHERE rvv01 = rvu01 
                    AND rvu02 = g_rvu.rvu02
                    AND rvv02 = g_rvv[l_ac].rvv02
                    AND rvu00 ='1'
                    AND rvu08 ='SUB'
                 SELECT SUM(rvv39),SUM(rvv39t) INTO l_rvv39_sum,l_rvv39t_sum FROM rvv_file,rvu_file
                  WHERE rvu01 = rvv01
                    AND rvu02 = g_rvu.rvu02
                    AND rvv02 = g_rvv[l_ac].rvv02
                    AND rvu00 ='3'
                    AND rvu116 ='3'
                    AND rvu08 ='SUB'
                    AND rvu01 != g_rvu.rvu01
                 IF cl_null(l_rvv39_sum) THEN LET l_rvv39_sum = 0 END IF 
                 IF cl_null(l_rvv39t_sum) THEN LET l_rvv39t_sum = 0 END IF  
                 IF (l_rvv39_sum + g_rvv[l_ac].rvv38 > l_rvv39) OR (l_rvv39t_sum + g_rvv[l_ac].rvv38t > l_rvv39t) THEN 
                    IF NOT cl_confirm('apm-179') THEN
                       LET l_yes = 'N'
                    ELSE 
                       LET l_yes = 'Y'
                    END IF
                    IF l_yes = 'N' THEN
                       LET g_rvv[l_ac].rvv38 =  l_pmn31
                       LET g_rvv[l_ac].rvv38t =  l_pmn31t
                       NEXT FIELD rvv38t
                    ELSE 
                    
                    END IF                    
                 END IF
              END IF                 
           END IF  
           #MOD-D60076 add end----------
           LET g_rvv38t_t = g_rvv[l_ac].rvv38t    #TQC-D80008  add

         AFTER FIELD rvv39
           CALL t720_get_azi()
           CALL cl_digcut(g_rvv[l_ac].rvv39,t_azi04)
                             RETURNING g_rvv[l_ac].rvv39
         AFTER FIELD rvv39t
           CALL t720_get_azi()
           CALL cl_digcut(g_rvv[l_ac].rvv39t,t_azi04)
                             RETURNING g_rvv[l_ac].rvv39t
 
         AFTER FIELD rvv41
            IF NOT cl_null(g_rvv[l_ac].rvv41) THEN
               SELECT coc10 INTO l_coc10 FROM coc_file
                WHERE coc03 = g_rvv[l_ac].rvv41
               IF STATUS THEN
                  CALL cl_err3("sel","coc_file",g_rvv[l_ac].rvv41,"","aco-062","","",1)  #No.FUN-660129
                  NEXT FIELD rvv41
               END IF
               SELECT COUNT(*) INTO l_cnt FROM coc_file,coe_file,coa_file
                WHERE coc01 = coe01 AND coe03 = coa03
                  AND coa05 = l_coc10
                  AND coa01 = g_rvv[l_ac].rvv31
                  AND coc03 = g_rvv[l_ac].rvv41
               IF l_cnt = 0 THEN
                  CALL cl_err(g_rvv[l_ac].rvv41,'aco-073',0)
                  NEXT FIELD rvv41
               END IF
            END IF
 
        AFTER FIELD rvv930
            IF NOT cl_null(g_rvv[l_ac].rvv930) THEN
                LET l_cnt=0
                SELECT COUNT(*) INTO l_cnt FROM gem_file
                                          WHERE gem01=g_rvv[l_ac].rvv930
                                            AND gem09 IN ('1','2')
                                            AND gemacti='Y'
                IF l_cnt=0 THEN
                   CALL cl_err3("sel","gem_file",g_rvv[l_ac].rvv930,"",100,"","",1)
                   LET g_rvv[l_ac].rvv930=g_rvv_t.rvv930
                   LET g_rvv[l_ac].gem02a=g_rvv_t.gem02a
                   DISPLAY BY NAME g_rvv[l_ac].rvv930,g_rvv[l_ac].gem02a
                   NEXT FIELD rvv930
                END IF
                CALL t720_set_rvv930(g_rvv[l_ac].rvv930) RETURNING g_rvv[l_ac].gem02a
                DISPLAY BY NAME g_rvv[l_ac].gem02a
            ELSE
                LET g_rvv[l_ac].gem02a=NULL
                DISPLAY BY NAME g_rvv[l_ac].gem02a
            END IF
 
        AFTER FIELD rvvud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rvvud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rvvud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rvvud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rvvud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rvvud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rvvud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rvvud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rvvud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rvvud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rvvud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rvvud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rvvud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rvvud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rvvud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        BEFORE DELETE                            #是否取消單身
           IF g_rvv_t.rvv02 > 0 AND NOT cl_null(g_rvv_t.rvv02) THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              SELECT ima918,ima921 INTO g_ima918,g_ima921 
                FROM ima_file
               WHERE ima01 = g_rvv[l_ac].rvv31
                 AND imaacti = "Y"
              
              IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                 IF g_sma.sma90 = "Y" THEN #MOD-C30074 add
                    #IF NOT s_lotin_del(g_prog,g_rvu.rvu01,g_rvv[l_ac].rvv02,0,g_rvv[l_ac].rvv31,'DEL') THEN   #No.FUN-860045  #TQC-B90236 mark
                     IF NOT s_lot_del(g_prog,g_rvu.rvu01,g_rvv[l_ac].rvv02,0,g_rvv[l_ac].rvv31,'DEL') THEN   #No.FUN-860045  #TQC-B90236 
                         CALL cl_err3("del","rvbs_file",g_rvu.rvu01,g_rvv_t.rvv02,
                                       SQLCA.sqlcode,"","",1)
                          ROLLBACK WORK
                          CANCEL DELETE
                     END IF
                 END IF #MOD-C30074 add
              END IF
              # genero shell add start
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              # genero shell add end
             #FUN-A60035 ---MARK BEGIN
             ##No.FUN-A50054 -BEGIN-----
             #IF s_industry('slk') THEN 
             #   DELETE FROM rvv_file
             #    WHERE rvv01 = g_rvu.rvu01
             #      AND rvv02 IN (SELECT ata03 FROM ata_file WHERE ata02 = g_rvv_t.rvv02) 
             #   IF SQLCA.sqlcode THEN
             #      CALL cl_err3("del","rvv_file",g_rvu.rvu01,g_rvv_t.rvv02,SQLCA.sqlcode,"","",1)
             #      ROLLBACK WORK
             #      CANCEL DELETE 
             #   END IF
             #ELSE
             ##No.FUN-A50054 -END-------
             #FUN-A60035 ---MARK END
                 DELETE FROM rvv_file
                  WHERE rvv01 = g_rvu.rvu01
                    AND rvv02 = g_rvv_t.rvv02
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","rvv_file",g_rvu.rvu01,g_rvv_t.rvv02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
                    ROLLBACK WORK
                    CANCEL DELETE
                ELSE  #FUN-BC0104 add
                   #FUN-BC0104---add---str
                   CALL t720_qcl05_check() RETURNING l_qcl05
                   IF l_qcl05 = '1' THEN LET l_type1 = '5' ELSE LET l_type1 = '1' END IF
                   IF NOT s_iqctype_upd_qco20(g_rvu.rvu02,g_rvv[l_ac].rvv05,g_rvv[l_ac].rvv45,g_rvv[l_ac].rvv47,l_type1) THEN
                      ROLLBACK WORK
                      CANCEL DELETE
                   END IF
                   #FUN-BC0104---add---end
                END IF
              #END IF  #No.FUN-A50054 Add   #FUN-A60035 ---MARK
              COMMIT WORK
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_rvv[l_ac].* = g_rvv_t.*
               CLOSE t720_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_rvv[l_ac].rvv02,-263,1)
                LET g_rvv[l_ac].* = g_rvv_t.*
            ELSE
               IF NOT cl_null(g_rvv[l_ac].rvv32) THEN      #MOD-8B0174
                   SELECT img09 INTO l_img09 FROM img_file
                          WHERE img01 = g_rvv[l_ac].rvv31
                          AND img02 = g_rvv[l_ac].rvv32
                          AND img03 = g_rvv[l_ac].rvv33
                          AND img04 = g_rvv[l_ac].rvv34
                   
                   CALL s_umfchk(g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv35,l_img09)
                   RETURNING l_i,g_rvv[l_ac].rvv35_fac
                   IF  l_i = 1 THEN
                       ### ------單位無法轉換--------####
                       CALL cl_err('rvv35/img09: ','abm-731',1)
                       LET g_success ='N'
                       RETURN
                   END IF
                   DISPLAY BY NAME g_rvv[l_ac].rvv35_fac
               END IF   #MOD-8B0174
 
                IF g_sma.sma115 = 'Y' THEN
                   CALL s_chk_va_setting(g_rvv[l_ac].rvv31)
                        RETURNING g_flag,g_ima906,g_ima907
                   IF g_flag=1 THEN
                      NEXT FIELD rvv31
                   END IF
                   CALL s_chk_va_setting1(g_rvv[l_ac].rvv31)
                        RETURNING g_flag,g_ima908
                   IF g_flag=1 THEN
                      NEXT FIELD rvv31
                   END IF
                   CALL t720_du_data_to_correct()
                   CALL t720_set_origin_field()
                END IF
                CALL t720_qcl05_check() RETURNING l_qcl05     #FUN-BC0104 add
                IF g_sma.sma116 MATCHES '[02]' AND (l_qcl05 NOT MATCHES'[12]' OR cl_null(l_qcl05)) THEN #MOD-630031 add #不使用計價單位時,計價單位/數量給原單據單位/數量 #FUN-BC0104 add
                   LET g_rvv[l_ac].rvv86 = g_rvv[l_ac].rvv35
                   LET g_rvv[l_ac].rvv87 = g_rvv[l_ac].rvv17
                END IF
                IF cl_null(g_rvv[l_ac].rvv39) OR g_rvv[l_ac].rvv39 = 0 THEN
                   LET g_rvv[l_ac].rvv39 = g_rvv[l_ac].rvv87 * g_rvv[l_ac].rvv38
                   LET g_rvv[l_ac].rvv39t= g_rvv[l_ac].rvv87 * g_rvv[l_ac].rvv38t   #No.FUN-610018
                END IF
                CALL t720sub_rvv38(b_rvv.rvv36,b_rvv.rvv38,b_rvv.rvv38t,g_rvu.rvu04,g_rvu.rvu01)  #TQC-C30225 add
                     RETURNING b_rvv.rvv38,b_rvv.rvv38t
                LET b_rvv.rvv39t= g_rvv[l_ac].rvv87 * b_rvv.rvv38t
                LET b_rvv.rvv39t= g_rvv[l_ac].rvv87 * b_rvv.rvv38t
               #MOD-D30016 add start -----
                IF cl_null(b_rvv.rvv39) THEN LET b_rvv.rvv39=0 END IF
                IF cl_null(b_rvv.rvv39t) THEN LET b_rvv.rvv39t=g_rvv[l_ac].rvv39t END IF
                IF cl_null(b_rvv.rvv38) THEN LET b_rvv.rvv38=0 END IF
                IF cl_null(b_rvv.rvv38t) THEN LET b_rvv.rvv38t=g_rvv[l_ac].rvv38t END IF
               #MOD-D30016 add end  -----
 
                CALL t720_b_move_back()
                CALL t720_b_else()
                IF cl_null(g_rvv[l_ac].rvv33) THEN
                   LET g_rvv[l_ac].rvv33=' '
                END IF
                IF cl_null(g_rvv[l_ac].rvv34) THEN
                   LET g_rvv[l_ac].rvv34=' '
                END IF
               IF g_aza.aza115 = 'Y' AND NOT t720_rvv26_chk() THEN NEXT FIELD rvv26 END IF   #FUN-CB0087
#FUN-A60035 ---MARK BEGIN
#              #No.FUN-A50054 -BEGIN-----
#               IF s_industry('slk') THEN
#                  DELETE FROM rvv_file WHERE rvv01 = g_rvu.rvu01
#                     AND rvv02 NOT IN(SELECT ata03 FROM ata_file
#                                   WHERE ata00 = g_prog AND ata01 = g_rvu.rvu01)
#                  DELETE FROM rvv_file WHERE rvv01 = g_rvu.rvu01
#                     AND rvv02 IN(SELECT ata03 FROM ata_file
#                                   WHERE ata00 = g_prog AND ata01 = g_rvu.rvu01 AND ata02 = b_rvv.rvv02)
#                  LET g_sql = " SELECT ata03,ata04,ata08 FROM ata_file ",
#                      "  WHERE ata00 = '",g_prog,"'",
#                      "    AND ata01 = '",g_rvu.rvu01,"'",
#                      "    AND ata02 = '",g_rvv[l_ac].rvv02,"'"
#                  DECLARE t720_ata_curs1 SCROLL CURSOR FROM g_sql
#                  FOREACH t720_ata_curs1 INTO b_rvv.rvv02,b_rvv.rvv31,b_rvv.rvv17
#                     LET b_rvv.rvv05 = g_rvv[l_ac].rvv02
#                     LET b_rvv.rvv39 = g_rvv[l_ac].rvv39 * b_rvv.rvv17 / g_rvv[l_ac].rvv17
#                     LET b_rvv.rvv39t= g_rvv[l_ac].rvv39t* b_rvv.rvv17 / g_rvv[l_ac].rvv17
#                     LET b_rvv.rvv87 = g_rvv[l_ac].rvv87 * b_rvv.rvv17 / g_rvv[l_ac].rvv17
#                     CALL cl_digcut(b_rvv.rvv39,t_azi04)  RETURNING b_rvv.rvv39
#                     CALL cl_digcut(b_rvv.rvv39t,t_azi04) RETURNING b_rvv.rvv39t
#                     INSERT INTO rvv_file VALUES(b_rvv.*)
#                     IF SQLCA.sqlcode THEN
#                        CALL cl_err3("ins","rvv_file",b_rvv.rvv01,b_rvv.rvv02,SQLCA.sqlcode,"","ins rvv",1)
#                        EXIT FOREACH
#                        SELECT ima918,ima921 INTO g_ima918,g_ima921 
#                          FROM ima_file
#                         WHERE ima01 = g_rvv[l_ac].rvv31
#                           AND imaacti = "Y"
#              
#                        IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
#                           IF NOT s_lotin_del(g_prog,g_rvu.rvu01,g_rvv[l_ac].rvv02,0,g_rvv[l_ac].rvv31,'DEL') THEN 
#                              CALL cl_err3("del","rvbs_file",g_rvu.rvu01,g_rvv_t.rvv02,
#                                    SQLCA.sqlcode,"","",1)
#                           END IF
#                        END IF
#                     END IF
#                  END FOREACH
#                  CALL cl_msg("UPDATE O.K")
#                  COMMIT WORK
#               ELSE
#              #No.FUN-A50054 -END-------
#FUN-A60035 ---MARK END
               #MOD-D30016 mark start -----
               # IF cl_null(b_rvv.rvv39) THEN LET b_rvv.rvv39=0 END IF
               # IF cl_null(b_rvv.rvv39t) THEN LET b_rvv.rvv39t=g_rvv[l_ac].rvv39t END IF
               # IF cl_null(b_rvv.rvv38) THEN LET b_rvv.rvv38=0 END IF
               # IF cl_null(b_rvv.rvv38t) THEN LET b_rvv.rvv38t=g_rvv[l_ac].rvv38t END IF
               ##-----MOD-AC0024---------
               # CALL cl_digcut(b_rvv.rvv39,t_azi04)  
               #                   RETURNING b_rvv.rvv39
               # CALL cl_digcut(b_rvv.rvv39t,t_azi04)   
               #                   RETURNING b_rvv.rvv39t  
               ##-----END MOD-AC0024-----
               # #CALL t720sub_rvv39(b_rvv.rvv36,b_rvv.rvv39,b_rvv.rvv39t,g_rvu.rvu04,g_rvu.rvu02) #FUN-A10130 #MOD-BC0262 mark 
               # CALL t720sub_rvv39(b_rvv.rvv36,b_rvv.rvv39,b_rvv.rvv39t,g_rvu.rvu04,g_rvu.rvu01)  #MOD-BC0262 add 
               #      RETURNING b_rvv.rvv39,b_rvv.rvv39t
               #MOD-D30016 mark end  -----
                UPDATE rvv_file SET * = b_rvv.*
                 WHERE rvv01=g_rvu.rvu01
                   AND rvv02=g_rvv_t.rvv02
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                   CALL cl_err3("upd","rvv_file",g_rvu.rvu01,g_rvv_t.rvv02,SQLCA.sqlcode,"","upd rvv",1)  #No.FUN-660129
                   LET g_rvv[l_ac].* = g_rvv_t.*
                ELSE
                  #MESSAGE 'UPDATE O.K'            #FUN-A50001 add
                   CALL cl_msg("UPDATE O.K")       #FUN-A50001 add
                   #FUN-BC0104---add---str
                   CALL t720_qcl05_check() RETURNING l_qcl05
                   IF l_qcl05 = '1' THEN LET l_type1 = '5' ELSE LET l_type1 = '1' END IF
                   IF NOT s_iqctype_upd_qco20(g_rvu.rvu02,g_rvv[l_ac].rvv05,g_rvv[l_ac].rvv45,g_rvv[l_ac].rvv47,l_type1) THEN
                      RETURN
                   END IF
                   #FUN-BC0104---add---end 
                   COMMIT WORK                   
                END IF 
#               END IF  #No.FUN-A50054   #FUN-A60035 ---MARK
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
        #   LET l_ac_t = l_ac    #TQC-D40025

            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'a' AND l_ac <= g_rvv.getLength() THEN #CHI-C30118 add
                  SELECT ima918,ima921 INTO g_ima918,g_ima921 
                    FROM ima_file
                   WHERE ima01 = g_rvv[l_ac].rvv31
                     AND imaacti = "Y"
                  
                  
                  IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                     IF g_sma.sma90 = "Y" THEN #MOD-C30074 add
                       #IF NOT s_lotin_del(g_prog,g_rvu.rvu01,g_rvv[l_ac].rvv02,0,g_rvv[l_ac].rvv31,'DEL') THEN   #No.FUN-860045  #TQC-B90236 mark
                        IF NOT s_lot_del(g_prog,g_rvu.rvu01,g_rvv[l_ac].rvv02,0,g_rvv[l_ac].rvv31,'DEL') THEN   #No.FUN-860045  #TQC-B90236 
                            CALL cl_err3("del","rvbs_file",g_rvu.rvu01,g_rvv_t.rvv02,
                                          SQLCA.sqlcode,"","",1)
                        END IF
                     END IF #MOD-C30074 add
                  END IF
               END IF #CHI-C30118 add
               IF p_cmd = 'u' THEN
                  LET g_rvv[l_ac].* = g_rvv_t.*
               ELSE                                  #TQC-AB0412 
                  CALL g_rvv.deleteElement(l_ac)     #TQC-AB0412
          #TQC-D40025--add--str--
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
          #TQC-D40025--add--end--
               END IF
               CLOSE t720_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac    #TQC-D40025
            #FUN-D20022 -- add start --
            IF g_rvu00 = '1' THEN
               SELECT SUM(rvv17) INTO l_rvv17_tol FROM rvv_file,rvu_file
                WHERE rvv04 = g_rvu.rvu02 AND rvv05 = g_rvv[l_ac].rvv05
                 AND rvu00='1' AND rvv01=rvu01 AND rvuconf <> 'X'
                  AND rvu01 <> g_rvu.rvu01
               IF cl_null(l_rvv17_tol) THEN LET l_rvv17_tol = 0 END IF
               IF g_rvv[l_ac].rvv17 > l_rvb33 - l_rvv17_tol THEN #異動數量應扣除已產生的入庫單之數量
                  CALL cl_err(l_rvb33 - l_rvv17_tol,'apm1102',1)
                  NEXT FIELD rvv17
               END IF
            END IF
            #FUN-D20022 -- add end --
            IF g_rvu.rvu116 <> '3' OR cl_null(g_rvu.rvu116) THEN   #MOD-CC0068 add
               #MOD-C30483-----add--begin---
              #IF cl_null(g_rvv[l_ac].rvv32) AND g_rvv[l_ac].rvv31 != 'MISC'      #MOD-D10224 mark
               IF cl_null(g_rvv[l_ac].rvv32) AND g_rvv[l_ac].rvv31[1,4] <> 'MISC' #MOD-D10224 add 
                  AND NOT cl_null(g_rvv[l_ac].rvv31) THEN
                  CALL cl_err('','apm1073 ',0)
                  NEXT FIELD rvv32
               END IF
               #MOD-C30483-----add--end---
            END IF   #MOD-CC0068 add
            IF g_aza.aza115 = 'Y' AND NOT t720_rvv26_chk() THEN NEXT FIELD rvv26 END IF   #FUN-CB0087
            CALL t720_b_fill(p_wc)                #TQC-C60096
            CLOSE t720_bcl
            COMMIT WORK

         #CHI-C30118---add---START 回寫批序料號資料
         AFTER INPUT
             SELECT COUNT(*) INTO g_cnt FROM rvv_file WHERE rvv01=g_rvu.rvu01
             FOR l_ac = 1 TO g_cnt
                 LET g_ima918 = ' '
                 LET g_ima921 = ' '
                 SELECT ima918,ima921 INTO g_ima918,g_ima921
                   FROM ima_file
                  WHERE ima01 = g_rvv[l_ac].rvv31
                    AND imaacti = "Y"

                 IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                    UPDATE rvbs_file SET rvbs021 = g_rvv[l_ac].rvv31
                      WHERE rvbs00 = g_prog
                        AND rvbs01 = g_rvu.rvu01
                        AND rvbs02 = g_rvv[l_ac].rvv02
                 END IF
         END FOR         
        #CHI-C30118---add---END   
            
        #-----MOD-BA0169---------
        #ON ACTION CONTROLO                        #沿用所有欄位
        #    IF INFIELD(rvv03) AND l_ac > 1 THEN
        #       LET g_rvv[l_ac].* = g_rvv[l_ac-1].*
        #       LET g_rvv[l_ac].rvv02 = 0
        #       LET g_rvv[l_ac].rvv05 = 0
        #       NEXT FIELD rvv05
        #    END IF
        #-----END MOD-BA0169-----
 
        ON ACTION CONTROLP
           CASE
             #新增的母料件開窗
             #這里只需要處理g_sma.sma908='Y'的情況,因為不允許單身新增子料件則在前面
             #BEFORE FIELD att00來做開窗了
             #需注意的是其條件限制是要開多屬性母料件且母料件的屬性組等于當前屬性組
             WHEN INFIELD(att00)
                #可以新增子料件,開窗是單純的選取母料件
#FUN-AA0059---------mod------------str-----------------                
#                CALL cl_init_qry_var()
#                LET g_qryparam.form ="q_ima_p"
#                LET g_qryparam.arg1 = lg_group
#                CALL cl_create_qry() RETURNING g_rvv[l_ac].att00

                CALL q_sel_ima(FALSE, "q_ima_p","","",lg_group,"","","","",'' ) 
                RETURNING  g_rvv[l_ac].att00
#FUN-AA0059---------mod------------end-----------------
                LET g_rvv[l_ac].rvv31 =g_rvv[l_ac].att00                        
                LET g_rvv[l_ac].att01 =null                                     
                LET g_rvv[l_ac].att01_c =null                                   
                LET g_rvv[l_ac].att02 =null                                     
                LET g_rvv[l_ac].att02_c =null                                   
                LET g_rvv[l_ac].att03 =null                                     
                LET g_rvv[l_ac].att03_c =null                                   
                LET g_rvv[l_ac].att04 =null                                     
                LET g_rvv[l_ac].att04_c =null                                   
                LET g_rvv[l_ac].att05 =null                                     
                LET g_rvv[l_ac].att05_c =null                                   
                LET g_rvv[l_ac].att06 =null                                     
                LET g_rvv[l_ac].att06_c =null                                   
                LET g_rvv[l_ac].att07 =null                                     
                LET g_rvv[l_ac].att07_c =null                                   
                LET g_rvv[l_ac].att08 =null                                     
                LET g_rvv[l_ac].att08_c =null                                   
                LET g_rvv[l_ac].att09 =null                                     
                LET g_rvv[l_ac].att09_c =null                                   
                LET g_rvv[l_ac].att10 =null                                     
                LET g_rvv[l_ac].att10_c =null                                   
                DISPLAY BY NAME g_rvv[l_ac].att00
 
                NEXT FIELD att00
             WHEN INFIELD(rvv31)      #料號
                  #FUN-A20017--begin--add---  
                  SELECT pmn04,ima903 INTO l_ima01,l_ima903
                    FROM ima_file,pmn_file
                   WHERE pmn01 = g_rvv[l_ac].rvv36
                     AND pmn02 = g_rvv[l_ac].rvv37
                     AND ima01 = pmn04
                  IF g_argv3 <> 'SUB' OR l_ima903 = 'N' OR cl_null(l_ima903) THEN
                  #FUN-A20017--end--add----
#FUN-AA0059---------mod------------str-----------------                  
#                     CALL cl_init_qry_var()
                     IF g_azw.azw04 = '2' AND g_prog='apmt742' THEN
                        CALL cl_init_qry_var()        #FUN-AA0059 add
                        LET g_qryparam.form = "q_rvb05_1"
                        LET g_qryparam.where = " rva29 ='",g_rvu.rvu21,"'"     #FUN-AA0059
                        LET g_qryparam.default1 = g_rvv[l_ac].rvv31            #FUN-AA0059
                        CALL cl_create_qry() RETURNING g_rvv[l_ac].rvv31  
                     ELSE
#                        LET g_qryparam.form = "q_ima"
                         CALL q_sel_ima(FALSE, "q_ima","",g_rvv[l_ac].rvv31,"","","","","",'' ) 
                         RETURNING g_rvv[l_ac].rvv31
                     END IF
#                     LET g_qryparam.default1 = g_rvv[l_ac].rvv31
#                     CALL cl_create_qry() RETURNING g_rvv[l_ac].rvv31  
                   #FUN-A20017--begin--add---
                  ELSE
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_bmm3"
                     LET g_qryparam.default1 = g_rvv[l_ac].rvv31
                     LET g_qryparam.arg1 = l_ima01
                     CALL cl_create_qry() RETURNING g_rvv[l_ac].rvv31
                  END IF
#FUN-AA0059---------mod------------end-----------------                  
                  #FUN-A20017--end--add---
                  DISPLAY BY NAME g_rvv[l_ac].rvv31         #No.MOD-490371
                  NEXT FIELD rvv31
             WHEN INFIELD(rvv05) #查詢驗收單項次
               IF g_rvu.rvu00='3' THEN #-- 倉退
                   CALL q_rvb7(FALSE,TRUE,
                               g_rvu.rvu02,g_rvv[l_ac].rvv05,g_rvu.rvu01)
                   RETURNING g_rvv[l_ac].rvv05
               ELSE
                 IF g_rvu.rvu00='1' THEN   #MOD-8B0027 add
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_rvb"
                   LET g_qryparam.default1 = g_rvv[l_ac].rvv05
                   LET g_qryparam.arg1 = g_rvu.rvu02
                   CALL cl_create_qry() RETURNING g_rvv[l_ac].rvv05
                 ELSE 
                   IF g_rvu.rvu00='2' THEN   
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_rvb4"
                      LET g_qryparam.default1 = g_rvv[l_ac].rvv05
                      LET g_qryparam.arg1 = g_rvu.rvu02
                      CALL cl_create_qry() RETURNING g_rvv[l_ac].rvv05
                   END IF
                 END IF  
               END IF
                DISPLAY BY NAME g_rvv[l_ac].rvv05         #No.MOD-490371
               CALL t720_rvv05(p_cmd)
               IF NOT cl_null(g_errno) THEN
                #MOD-C30590 -- add -- begin
                 IF (g_rvv[l_ac].rvv31 = 'MISC') AND (g_errno = 'apm-259') THEN    
                 ELSE
                #MOD-C30590 -- add -- end
                    CALL cl_err(g_rvv[l_ac].rvv05,g_errno,0)

                    IF g_errno <> 'apm-259' THEN #No.TQC-7C0020
                       NEXT FIELD rvv05
                    END IF
                 END IF   #MOD-C30590 -- add
               END IF
               NEXT FIELD rvv05
             #FUN-BC0104---add---str
             WHEN INFIELD(rvv46)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_qco"
               LET g_qryparam.default1 = g_rvv[l_ac].rvv46
               LET g_qryparam.arg1 = g_rvu.rvu02
               LET g_qryparam.arg2 = g_rvv[l_ac].rvv05
               LET g_qryparam.arg3 = g_rvv[l_ac].rvv45
               CALL t720_qcl05_wc() RETURNING g_qryparam.arg4,l_qcl05_tf    #TQC-C30048
               CALL cl_create_qry() RETURNING g_rvv[l_ac].rvv46,g_rvv[l_ac].rvv47 
               DISPLAY BY NAME g_rvv[l_ac].rvv46,g_rvv[l_ac].rvv47
               NEXT FIELD rvv46
               
             WHEN INFIELD(rvv47)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_qco"
               LET g_qryparam.default1 = g_rvv[l_ac].rvv47
               LET g_qryparam.arg1 = g_rvu.rvu02
               LET g_qryparam.arg2 = g_rvv[l_ac].rvv05
               LET g_qryparam.arg3 = g_rvv[l_ac].rvv45
               CALL t720_qcl05_wc() RETURNING g_qryparam.arg4,l_qcl05_tf    #TQC-C30048
               CALL cl_create_qry() RETURNING g_rvv[l_ac].rvv46,g_rvv[l_ac].rvv47
               DISPLAY BY NAME g_rvv[l_ac].rvv46,g_rvv[l_ac].rvv47
               NEXT FIELD rvv47
             #FUN-BC0104---add---end
             WHEN INFIELD(rvv35) #查詢單位
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gfe"
               LET g_qryparam.default1 = g_rvv[l_ac].rvv35
               CALL cl_create_qry() RETURNING g_rvv[l_ac].rvv35
                DISPLAY BY NAME g_rvv[l_ac].rvv35         #No.MOD-490371
               NEXT FIELD rvv35
             WHEN INFIELD(rvv32) OR INFIELD(rvv33) OR INFIELD(rvv34)
                #FUN-C30300---begin
                LET g_ima906 = NULL
                SELECT ima906 INTO g_ima906 FROM ima_file
                 WHERE ima01 = g_rvv[l_ac].rvv31
                #IF s_industry("icd") AND g_ima906='3' THEN   #TQC-C60028
                IF s_industry("icd") THEN  #TQC-C60028
                    CALL q_idc(FALSE,TRUE,g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv32,g_rvv[l_ac].rvv33,g_rvv[l_ac].rvv34)
                    RETURNING g_rvv[l_ac].rvv32,g_rvv[l_ac].rvv33,g_rvv[l_ac].rvv34
                ELSE
                #FUN-C30300---end 
                   CALL q_img4(FALSE,TRUE,  ##NO.FUN-660085
                               g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv32,
                               g_rvv[l_ac].rvv33,g_rvv[l_ac].rvv34,'A')
                   RETURNING  g_rvv[l_ac].rvv32,g_rvv[l_ac].rvv33,g_rvv[l_ac].rvv34
                END IF #FUN-C30300
               DISPLAY g_rvv[l_ac].rvv32 TO rvv32
               DISPLAY g_rvv[l_ac].rvv33 TO rvv33
               DISPLAY g_rvv[l_ac].rvv34 TO rvv34
 
               IF INFIELD(rvv32) THEN NEXT FIELD rvv32 END IF
               IF INFIELD(rvv33) THEN NEXT FIELD rvv33 END IF
               IF INFIELD(rvv34) THEN NEXT FIELD rvv34 END IF
             WHEN INFIELD(rvv26)   #退貨理由
                  #FUN-CB0087---add---str---
                  CALL s_get_where(g_rvu.rvu01,g_rvu.rvu02,'',g_rvv[l_ac].rvv31,
                                   g_rvv[l_ac].rvv32,g_rvu.rvu07,g_rvu.rvu06) RETURNING l_flag,l_where
                  IF l_flag AND g_aza.aza115 = 'Y' THEN
                     CALL cl_init_qry_var()
                     LET g_qryparam.form  ="q_ggc08"
                     LET g_qryparam.where = l_where
                     LET g_qryparam.default1 = g_rvv[l_ac].rvv26
                  ELSE
                  #FUN-CB0087---add---end---
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_azf01a"                                  #No.FUN-930145
                     LET g_qryparam.default1 = g_rvv[l_ac].rvv26
                     #-----MOD-AB0051--------- 
                     #LET g_qryparam.arg1 = '7'                                 #No.FUN-930145
                     IF g_argv1 = '1' THEN 
                        LET g_qryparam.arg1 = '7'
                     ELSE
                        LET g_qryparam.arg1 = '5'
                     END IF
                     #-----END MOD-AB0051-----
                  END IF   #FUN-CB0087
                  CALL cl_create_qry() RETURNING g_rvv[l_ac].rvv26
                  DISPLAY BY NAME g_rvv[l_ac].rvv26         #No.MOD-490371
                  IF NOT cl_null(g_rvv[l_ac].rvv26) THEN    #No.TQC-740124
                     SELECT azf03 INTO g_rvv[l_ac].azf03 FROM azf_file
                      WHERE azf01 = g_rvv[l_ac].rvv26 AND azf02='2'
                     IF STATUS THEN
                        CALL cl_err3("sel","azf_file",g_rvv[l_ac].rvv26,"",SQLCA.sqlcode,"","sel azf",1)  #No.FUN-660129
                        NEXT FIELD rvv26
                     END IF
                  END IF               #No.TQC-740124
                  NEXT FIELD rvv26
             WHEN INFIELD(rvv34)
                          CALL cl_init_qry_var()
                          LET g_qryparam.form = "q_img"
                          LET g_qryparam.default1 = g_rvv[l_ac].rvv31
                          LET g_qryparam.arg1 = g_rvv[l_ac].rvv32
                          LET g_qryparam.arg2 = g_rvv[l_ac].rvv33
                          LET g_qryparam.arg3 = g_rvv[l_ac].rvv34
                          CALL cl_create_qry() RETURNING g_rvv[l_ac].rvv34
                           DISPLAY BY NAME g_rvv[l_ac].rvv34         #No.MOD-490371
                          NEXT FIELD rvv34
               WHEN INFIELD(rvv41)
                    SELECT pmm04 INTO l_pmm04 FROM pmm_file
                     WHERE pmm01 = g_rvv[l_ac].rvv36
                    CALL q_coc2(FALSE,FALSE,g_rvv[l_ac].rvv41,'',l_pmm04,'1',
                                '',g_rvv[l_ac].rvv31)
                    RETURNING g_rvv[l_ac].rvv41,l_coc04
                     DISPLAY BY NAME g_rvv[l_ac].rvv41         #No.MOD-490371
                    NEXT FIELD rvv41
                WHEN INFIELD(rvv32)    #MOD-480604倉庫開窗
                     CALL cl_init_qry_var()
                     LET g_qryparam.form     = "q_imd"
                     LET g_qryparam.default1 = g_rvv[l_ac].rvv32
                      LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
                     CALL cl_create_qry() RETURNING g_rvv[l_ac].rvv32
                     DISPLAY BY NAME g_rvv[l_ac].rvv32
                     NEXT FIELD rvv32
                 WHEN INFIELD(rvv80) #單位
                      CALL cl_init_qry_var()
                      LET g_qryparam.form ="q_gfe"
                      LET g_qryparam.default1 = g_rvv[l_ac].rvv80
                      CALL cl_create_qry() RETURNING g_rvv[l_ac].rvv80
                      DISPLAY BY NAME g_rvv[l_ac].rvv80
                      NEXT FIELD rvv80
 
                 WHEN INFIELD(rvv83) #單位
                      CALL cl_init_qry_var()
                      LET g_qryparam.form ="q_gfe"
                      LET g_qryparam.default1 = g_rvv[l_ac].rvv83
                      CALL cl_create_qry() RETURNING g_rvv[l_ac].rvv83
                      DISPLAY BY NAME g_rvv[l_ac].rvv83
                      NEXT FIELD rvv83
 
                 WHEN INFIELD(rvv86) #單位
                      CALL cl_init_qry_var()
                      LET g_qryparam.form ="q_gfe"
                      LET g_qryparam.default1 = g_rvv[l_ac].rvv86
                      CALL cl_create_qry() RETURNING g_rvv[l_ac].rvv86
                      DISPLAY BY NAME g_rvv[l_ac].rvv86
                      NEXT FIELD rvv86
 
                 WHEN INFIELD(rvv930)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gem4"
                    CALL cl_create_qry() RETURNING g_rvv[l_ac].rvv930
                    DISPLAY BY NAME g_rvv[l_ac].rvv930
                    NEXT FIELD rvv930
                 #CHI-A70035 add --start--
                 WHEN INFIELD(rvvud02)
                    CALL cl_dynamic_qry() RETURNING g_rvv[l_ac].rvvud02
                    DISPLAY BY NAME g_rvv[l_ac].rvvud02
                    NEXT FIELD rvvud02
                 WHEN INFIELD(rvvud03)
                    CALL cl_dynamic_qry() RETURNING g_rvv[l_ac].rvvud03
                    DISPLAY BY NAME g_rvv[l_ac].rvvud03
                    NEXT FIELD rvvud03
                 WHEN INFIELD(rvvud04)
                    CALL cl_dynamic_qry() RETURNING g_rvv[l_ac].rvvud04
                    DISPLAY BY NAME g_rvv[l_ac].rvvud04
                    NEXT FIELD rvvud04
                 WHEN INFIELD(rvvud05)
                    CALL cl_dynamic_qry() RETURNING g_rvv[l_ac].rvvud05
                    DISPLAY BY NAME g_rvv[l_ac].rvvud05
                    NEXT FIELD rvvud05
                 WHEN INFIELD(rvvud06)
                    CALL cl_dynamic_qry() RETURNING g_rvv[l_ac].rvvud06
                    DISPLAY BY NAME g_rvv[l_ac].rvvud06
                    NEXT FIELD rvvud06
                 #CHI-A70035 add --end--
              OTHERWISE EXIT CASE
           END CASE

#CHI-C80009---add---START
#CHI-C80009---add-----END
 
        ON ACTION qry_warehouse
           CALL cl_init_qry_var()
           LET g_qryparam.form = "q_imd"
           LET g_qryparam.default1 = g_rvv[l_ac].rvv32
            LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
           LET g_qryparam.construct='N'
           CALL cl_create_qry() RETURNING g_rvv[l_ac].rvv32
           DISPLAY BY NAME g_rvv[l_ac].rvv32    #MOD-840666 add
           NEXT FIELD rvv32
 
        ON ACTION qry_loc_warehouse
           CALL cl_init_qry_var()
           LET g_qryparam.form = "q_ime"
           LET g_qryparam.default1 = g_rvv[l_ac].rvv33
            LET g_qryparam.arg1     = g_rvv[l_ac].rvv32 #倉庫編號 #MOD-4A0063
            LET g_qryparam.arg2     = 'SW'              #倉庫類別 #MOD-4A0063
           LET g_qryparam.construct='N'
           CALL cl_create_qry() RETURNING g_rvv[l_ac].rvv33
           DISPLAY BY NAME g_rvv[l_ac].rvv33    #MOD-840666 add
           NEXT FIELD rvv33
 
       ON ACTION default_w_h
          CALL cl_init_qry_var()
          LET g_qryparam.form = "q_imf"
          LET g_qryparam.arg1 = g_rvv[l_ac].rvv31
          LET g_qryparam.construct='N'
          CALL cl_create_qry() RETURNING g_rvv[l_ac].rvv32,g_rvv[l_ac].rvv33
         #MESSAGE ''                           #FUN-A50001 mark
          CALL cl_msg("")                      #FUN-A50001 add
          DISPLAY BY NAME g_rvv[l_ac].rvv32    #MOD-840666 add
          DISPLAY BY NAME g_rvv[l_ac].rvv33    #MOD-840666 add
          NEXT FIELD rvv32
 
        ON ACTION modi_lot
           SELECT ima918,ima921 INTO g_ima918,g_ima921 
             FROM ima_file
            WHERE ima01 = g_rvv[l_ac].rvv31
              AND imaacti = "Y"
           
           IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
              SELECT img09 INTO g_img09 FROM img_file
              WHERE img01=g_rvv[l_ac].rvv31 AND img02=g_rvv[l_ac].rvv32
                AND img03=g_rvv[l_ac].rvv33 AND img04=g_rvv[l_ac].rvv34
              #IF g_sma.sma90 = 'Y' THEN                            #MOD-C40098 mark
              IF NOT (g_sma.sma90 = 'N' AND g_rvu.rvu00 = '2') THEN #MOD-C40098 add
                 SELECT COUNT(*) INTO l_n FROM rvbs_file
                  WHERE rvbs00 = g_prog
                    AND rvbs01 = g_rvu.rvu01
                    AND rvbs02 = g_rvv[l_ac].rvv02
                 IF l_n = 0 THEN
                    CALL t720sub_ins_rvbs(g_prog,g_rvu.rvu01,g_rvv[l_ac].rvv02,
                                       g_rvu.rvu02,g_rvv[l_ac].rvv05,g_rvv[l_ac].rvv31,
                                       g_rvv[l_ac].rvv32,g_rvv[l_ac].rvv33,g_rvv[l_ac].rvv34,g_rvu.rvu02) #FUN-A10130
                 END IF						 
                #IF g_rvu.rvu116 <> '3' OR cl_null(g_rvu.rvu116) THEN   #MOD-CB0229 add #MOD-D40025 mark
   #No.TQC-B90236--------mark---------begin-----------
                   #CALL s_lotin(g_prog,g_rvu.rvu01,g_rvv[l_ac].rvv02,0,
                   #             g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv35,g_img09,
                   #             g_rvv[l_ac].rvv35_fac,g_rvv[l_ac].rvv17,'','SEL')#CHI-9A0022 add ''
                   #       RETURNING l_r,g_qty
   #No.TQC-B90236--------mark---------end-------------
                    CALL s_wo_record(g_rvv[l_ac].rvv18,'Y')   #MOD-CC0047 add
   #No.TQC-B90236--------add----------begin-----------
                    IF g_rvu.rvu00='1' THEN
                       CALL s_mod_lot(g_prog,g_rvu.rvu01,g_rvv[l_ac].rvv02,0,
                                      g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv32,g_rvv[l_ac].rvv33,
                                      g_rvv[l_ac].rvv34,g_rvv[l_ac].rvv35,g_img09,
                                      g_rvv[l_ac].rvv35_fac,g_rvv[l_ac].rvv17,'','SEL',1) #CHI-9A0022 add ''
                               RETURNING l_r,g_qty
                    ELSE
                       CALL s_mod_lot(g_prog,g_rvu.rvu01,g_rvv[l_ac].rvv02,0,
                                      g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv32,g_rvv[l_ac].rvv33,
                                      g_rvv[l_ac].rvv34,g_rvv[l_ac].rvv35,g_img09,
                                      g_rvv[l_ac].rvv35_fac,g_rvv[l_ac].rvv17,'','SEL',-1) #CHI-9A0022 add ''
                               RETURNING l_r,g_qty
                    END IF
   #No.TQC-B90236--------add----------end-------------	
                #END IF   #MOD-CB0229 add #MOD-D40025 mark
                 IF l_r = "Y" THEN
                    LET g_rvv[l_ac].rvv17 = g_qty
                    LET g_rvv[l_ac].rvv17 = s_digqty(g_rvv[l_ac].rvv17,g_rvv[l_ac].rvv35)   #No.FUN-BB0086
                 END IF
              ELSE
#No.CHI-9A0022 --Begin
                 LET l_bno = ''
                 SELECT pmn122 INTO l_bno
                   FROM pmn_file
                  WHERE pmn01 = g_rvv[l_ac].rvv36
                    AND pmn02 = g_rvv[l_ac].rvv37
#No.CHI-9A0022 --End					 
                #IF g_rvu.rvu116 <> '3' OR cl_null(g_rvu.rvu116) THEN   #MOD-CB0229 add #MOD-D40025 mark
   #No.TQC-B90236--------mark---------begin-----------
                   #CALL s_lotin(g_prog,g_rvu.rvu01,g_rvv[l_ac].rvv02,0,
                   #             g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv35,g_img09,
                   #             g_rvv[l_ac].rvv35_fac,g_rvv[l_ac].rvv17,l_bno,'MOD')#CHI-9A0022 add 'l_bno'
                   #       RETURNING l_r,g_qty
   #No.TQC-B90236--------mark---------end-------------
                    CALL s_wo_record(g_rvv[l_ac].rvv18,'Y')   #MOD-CC0047 add
   #No.TQC-B90236--------add----------begin-----------
                    IF g_rvu.rvu00='1' THEN
                       CALL s_mod_lot(g_prog,g_rvu.rvu01,g_rvv[l_ac].rvv02,0,
                                      g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv32,g_rvv[l_ac].rvv33,
                                      g_rvv[l_ac].rvv34,g_rvv[l_ac].rvv35,g_img09,
                                      g_rvv[l_ac].rvv35_fac,g_rvv[l_ac].rvv17,l_bno,'MOD',1) #CHI-9A0022 add 'l_bno'
                               RETURNING l_r,g_qty
                    ELSE
                       CALL s_mod_lot(g_prog,g_rvu.rvu01,g_rvv[l_ac].rvv02,0,
                                      g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv32,g_rvv[l_ac].rvv33,
                                      g_rvv[l_ac].rvv34,g_rvv[l_ac].rvv35,g_img09,
                                      g_rvv[l_ac].rvv35_fac,g_rvv[l_ac].rvv17,l_bno,'MOD',-1) #CHI-9A0022 add 'l_bno'
                               RETURNING l_r,g_qty
                    END IF
   #No.TQC-B90236--------add----------end-------------
                #END IF   #MOD-CB0229 add #MOD-D40025 mark
                 IF l_r = "Y" THEN
                    LET g_rvv[l_ac].rvv17 = g_qty
                    LET g_rvv[l_ac].rvv17 = s_digqty(g_rvv[l_ac].rvv17,g_rvv[l_ac].rvv35)   #No.FUN-BB0086
                 END IF
              END IF
           END IF
 
        ON ACTION CONTROLZ
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
 
      ON ACTION controls                           #No.FUN-6B0032
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
      END INPUT

      LET g_rvu.rvu17 = '0'                        #修改後需重新送簽  #FUN-A60009 add

      UPDATE rvu_file 
         SET rvumodu=g_user
            ,rvudate=g_today
            ,rvu17 = g_rvu.rvu17                   #FUN-A60009 add
       WHERE rvu01=g_rvu.rvu01
      SELECT COUNT(*) INTO g_cnt FROM rvv_file WHERE rvv01=g_rvu.rvu01
 
    CLOSE t720_bcl

    DISPLAY BY NAME g_rvu.rvu17                    #FUN-A60009 add
    CALL t720_pic() #FUN-C30140 add
    COMMIT WORK
    CALL t720_delHeader()     #CHI-C30002 add
#TQC-C20500----add---begin---------
#TQC-C20500-----end---------------
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION t720_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   DEFINE l_shb01            LIKE shb_file.shb01
   DEFINE l_shb28            LIKE shb_file.shb28
   DEFINE l_shb29            LIKE shb_file.shb29
   
   SELECT COUNT(*) INTO g_cnt FROM rvv_file WHERE  rvv01=g_rvu.rvu01
   IF g_cnt = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_rvu.rvu01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM rvu_file ",
                  "  WHERE rvu01 LIKE '",l_slip,"%' ",
                  "    AND rvu01 > '",g_rvu.rvu01,"'"
      PREPARE t720_pb1 FROM l_sql 
      EXECUTE t720_pb1 INTO l_cnt 
      
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
        #CALL t720_x()    #FUN-D20025
         CALL t720_x(1)   #FUN-D20025
         CALL t720_show()
      END IF 
      
      IF l_cho = 3 THEN 
         DELETE FROM rvx_file WHERE rvx01 = g_rvu.rvu01
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM rvu_file WHERE  rvu01=g_rvu.rvu01
         #str---add by jixf 160802
          SELECT shb01,shb28,shb29 INTO l_shb01,l_shb28,l_shb29 FROM shb_file WHERE shb14=g_rvu.rvu01
          IF NOT cl_null(l_shb01) THEN 
             DELETE FROM rva_file WHERE rva01=l_shb29
             DELETE FROM rvb_file WHERE rvb01=l_shb29
             DELETE FROM pmm_file WHERE pmm01=l_shb28
             DELETE FROM pmn_file WHERE pmn01=l_shb28
             UPDATE shb_file SET shbud02='N',shb28='',shb29='',shb14='' WHERE shb01=l_shb01
          END IF 
          MESSAGE '自动产生的委外收货单，采购单已一并删除！'
          #end---add by jixf 160802
         INITIALIZE g_rvu.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#FUN-B50096 -----------------------------Begin--------------------------
FUNCTION t720_b_rvv34_inschk()
DEFINE  l_ima159    LIKE ima_file.ima159
DEFINE  l_ec_sw     LIKE type_file.chr1
DEFINE  g_sw        LIKE type_file.num10
DEFINE  l_flag      LIKE type_file.num10
DEFINE  l_n,l_cnt   LIKE type_file.num5
DEFINE  l_pmn41     LIKE pmn_file.pmn41
DEFINE  l_pmn43     LIKE pmn_file.pmn43
DEFINE  l_pmn18     LIKE pmn_file.pmn18
DEFINE  l_pmn32     LIKE pmn_file.pmn32
DEFINE  l_ima918    LIKE ima_file.ima918
DEFINE  l_ima921    LIKE ima_file.ima921
DEFINE  p_cmd       LIKE type_file.chr1
DEFINE  l_err_var   STRING

   IF g_rvv[l_ac].rvv34 = '　' THEN #全型空白
      LET g_rvv[l_ac].rvv34 = ' '
   END IF
   IF g_rvv[l_ac].rvv34 IS NULL THEN LET g_rvv[l_ac].rvv34=' ' END IF
   LET l_flag=TRUE 
   IF NOT cl_null(g_rvv[l_ac].rvv31) AND g_rvu.rvu116 <> '3' THEN  #MOD-D30122 add rvu116
      LET l_ima159 = ''
      SELECT ima159 INTO l_ima159 FROM ima_file
       WHERE ima01 = g_rvv[l_ac].rvv31
      IF l_ima159 = '1' AND cl_null(g_rvv[l_ac].rvv34) THEN 
         CALL cl_err(g_rvv[l_ac].rvv31,'aim-034',1)
         RETURN "rvv34"
      END IF
   END IF
    LET l_ec_sw = 'N'
    IF g_rvu.rvu08='SUB' AND NOT cl_null(g_rvv[l_ac].rvv36) AND NOT cl_null(g_rvv[l_ac].rvv37) THEN 
       SELECT pmn41,pmn43,pmn18,pmn32 INTO l_pmn41,l_pmn43,l_pmn18,l_pmn32 FROM pmn_file
          WHERE pmn01 = g_rvv[l_ac].rvv36 AND pmn02 = g_rvv[l_ac].rvv37
       IF STATUS THEN
          CALL cl_err3("sel","pmn_file",g_rvv[l_ac].rvv36,g_rvv[l_ac].rvv37,STATUS,"","sel pmn_file",1)
       END IF
       IF NOT cl_null(l_pmn41) AND l_pmn43>0 THEN   #W/O<>'' &製程序>0
          LET l_ec_sw='Y'
       END IF
    END IF
    IF g_rvv[l_ac].rvv31[1,4] != 'MISC' AND g_rvu.rvu00!='2' AND l_flag AND l_ec_sw='N' 
       AND NOT (g_rvu.rvu00='3' AND g_rvv[l_ac].rvv17=0) THEN 
       IF g_rvv[l_ac].rvv34 IS NULL THEN LET g_rvv[l_ac].rvv34=' ' END IF
       SELECT COUNT(*) INTO l_cnt FROM rvv_file
        WHERE rvv01 = g_rvu.rvu01  #同一張單不可有同料,倉,儲,批之資料
          AND rvv31 = g_rvv[l_ac].rvv31 AND rvv32 = g_rvv[l_ac].rvv32
          AND rvv33 = g_rvv[l_ac].rvv33 AND rvv34 = g_rvv[l_ac].rvv34
          AND rvv02 != g_rvv[l_ac].rvv02
       IF l_cnt > 0 THEN
          CALL cl_err('','mfg9146',0)
       END IF
       SELECT COUNT(*) INTO g_cnt FROM img_file
        WHERE img01 = g_rvv[l_ac].rvv31   #料號
          AND img02 = g_rvv[l_ac].rvv32   #倉庫
          AND img03 = g_rvv[l_ac].rvv33   #儲位
          AND img04 = g_rvv[l_ac].rvv34   #批號
          AND img18 < g_rvu.rvu03
       IF g_cnt > 0 THEN    #大於有效日期
          call cl_err('','aim-400',0)   #須修改
          #RETURN "rvv32"
       END IF
       SELECT img07,img10,img09 INTO g_img07,g_img10,g_img09
         FROM img_file   #採購單位,庫存數量,庫存單位
        WHERE img01=g_rvv[l_ac].rvv31 AND img02=g_rvv[l_ac].rvv32
          AND img03=g_rvv[l_ac].rvv33 AND img04=g_rvv[l_ac].rvv34
       IF (g_rvu.rvu00='1' AND STATUS=100) OR
          (g_rvu.rvu00='3' AND STATUS=100) THEN
          IF NOT cl_null(g_rvv[l_ac].rvv32) OR NOT cl_null(g_rvv[l_ac].rvv33) OR NOT cl_null(g_rvv[l_ac].rvv34) THEN  #MOD-D30083 add
             IF g_sma.sma892[3,3] ='Y' THEN
                IF NOT cl_confirm('mfg1401') THEN RETURN "rvv32" END IF  
             END IF
             CALL s_add_img(g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv32,
                            g_rvv[l_ac].rvv33,g_rvv[l_ac].rvv34,
                            g_rvu.rvu01,      g_rvv[l_ac].rvv02,
                            g_rvu.rvu03)
             SELECT img07,img10,img09 INTO g_img07,g_img10,g_img09
               FROM img_file
              WHERE img01=g_rvv[l_ac].rvv31 AND img02=g_rvv[l_ac].rvv32
                AND img03=g_rvv[l_ac].rvv33 AND img04=g_rvv[l_ac].rvv34
          END IF  #MOD-D30083 add
       END IF
         #取對img換算率
         CALL s_umfchk(g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv35,g_img09)
                RETURNING g_sw,g_rvv[l_ac].rvv35_fac
         DISPLAY BY NAME g_rvv[l_ac].rvv35_fac
         IF g_sw THEN
            LET l_err_var = ""
            LET l_err_var = g_rvv[l_ac].rvv35 CLIPPED,'<--->',g_img09 CLIPPED
            CALL cl_err(l_err_var,'apm-258',1)
            #RETURN "rvv34"   #MOD-BC0056 mark
            RETURN "rvv32"   #MOD-BC0056 add
         END IF
    END IF
    IF g_prog = 'apmt722' OR g_prog = 'aict044' AND cl_null(g_rvu.rvu02) THEN  #MOD-D30083 add aict044
       SELECT ima918,ima921 INTO l_ima918,l_ima921 
         FROM ima_file
        WHERE ima01 = g_rvv[l_ac].rvv31
          AND imaacti = "Y"
   
       IF l_ima918 = "Y" OR l_ima921 = "Y" THEN
          SELECT COUNT(*) INTO l_n FROM rvbs_file
           WHERE rvbs00 = g_prog
             AND rvbs01 = g_rvu.rvu01
             AND rvbs02 = g_rvv[l_ac].rvv02
          IF l_n = 0 THEN
             CALL t720sub_ins_rvbs(g_prog,g_rvu.rvu01,g_rvv[l_ac].rvv02,
                                g_rvu.rvu02,g_rvv[l_ac].rvv05,g_rvv[l_ac].rvv31,
                                g_rvv[l_ac].rvv32,g_rvv[l_ac].rvv33,g_rvv[l_ac].rvv34,g_rvu.rvu02)
          END IF
          IF g_sma.sma90 = 'Y' THEN  #sel	
             IF g_rvu.rvu116 <> '3' OR cl_null(g_rvu.rvu116) THEN   #MOD-CB0229 add
   #No.TQC-B90236--------mark---------begin-----------
               #CALL s_lotin(g_prog,g_rvu.rvu01,g_rvv[l_ac].rvv02,0,
               #             g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv35,g_img09,
               #             g_rvv[l_ac].rvv35_fac,g_rvv[l_ac].rvv17,'','SEL')
               #       RETURNING l_r,g_qty
   #No.TQC-B90236--------mark---------end-------------
                CALL s_wo_record(g_rvv[l_ac].rvv18,'Y')   #MOD-CC0047 add
   #No.TQC-B90236--------add----------begin-----------
                IF g_rvu.rvu00='1' THEN
                   CALL s_mod_lot(g_prog,g_rvu.rvu01,g_rvv[l_ac].rvv02,0,
                                  g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv32,g_rvv[l_ac].rvv33,
                                  g_rvv[l_ac].rvv34,g_rvv[l_ac].rvv35,g_img09,
                                  g_rvv[l_ac].rvv35_fac,g_rvv[l_ac].rvv17,'','SEL',1)
                           RETURNING l_r,g_qty
                ELSE
                   CALL s_mod_lot(g_prog,g_rvu.rvu01,g_rvv[l_ac].rvv02,0,
                                  g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv32,g_rvv[l_ac].rvv33,
                                  g_rvv[l_ac].rvv34,g_rvv[l_ac].rvv35,g_img09,
                                  g_rvv[l_ac].rvv35_fac,g_rvv[l_ac].rvv17,'','SEL',-1)
                           RETURNING l_r,g_qty
                END IF
   #No.TQC-B90236--------add----------end-------------	  
             END IF   #MOD-CB0229 add
             IF l_r = "Y" THEN
                LET g_rvv[l_ac].rvv17 = g_qty
                LET g_rvv[l_ac].rvv17 = s_digqty(g_rvv[l_ac].rvv17,g_rvv[l_ac].rvv35)   #No.FUN-BB0086
             END IF
          END IF
       END IF
   END IF
   RETURN NULL
END FUNCTION
#FUN-B50096 -----------------------------End-----------------------------

FUNCTION t720_pmm43(p_no)
DEFINE p_no              LIKE pmm_file.pmm01
DEFINE l_pmm43           LIKE pmm_file.pmm43
DEFINE l_rva00           LIKE rva_file.rva00
 
    LET l_pmm43 = 0
    IF NOT cl_null(g_rvu.rvu02) THEN
       SELECT rva00 INTO l_rva00 FROM rva_file WHERE rva01 = g_rvu.rvu02
       IF l_rva00 = '2' THEN
          SELECT rva116 INTO l_pmm43 FROM rva_file WHERE rva01 = g_rvu.rvu02
       ELSE
          SELECT pmm43 INTO l_pmm43 FROM pmm_file WHERE pmm01 = p_no 
       END IF
    ELSE
       SELECT pmm43 INTO l_pmm43 FROM pmm_file WHERE pmm01 = p_no
    END IF
    IF cl_null(l_pmm43) THEN LET l_pmm43 = 0 END IF
 
    RETURN l_pmm43
END FUNCTION
FUNCTION t720_b_move_to()
   LET g_rvv[l_ac].rvv02     = b_rvv.rvv02
   LET g_rvv[l_ac].rvv05     = b_rvv.rvv05
   #FUN-BC0104---add---str---
   LET g_rvv[l_ac].rvv45     = b_rvv.rvv45
   LET g_rvv[l_ac].rvv46     = b_rvv.rvv46
   LET g_rvv[l_ac].rvv47     = b_rvv.rvv47
   #FUN-BC0104---add---end---
   LET g_rvv[l_ac].rvv31     = b_rvv.rvv31
   LET g_rvv[l_ac].rvv031    = b_rvv.rvv031
   LET g_rvv[l_ac].rvv32     = b_rvv.rvv32
   LET g_rvv[l_ac].rvv33     = b_rvv.rvv33
   LET g_rvv[l_ac].rvv34     = b_rvv.rvv34
   LET g_rvv[l_ac].rvv35     = b_rvv.rvv35
   LET g_rvv[l_ac].rvv35_fac = b_rvv.rvv35_fac
   LET g_rvv[l_ac].rvv36     = b_rvv.rvv36
   LET g_rvv[l_ac].rvv37     = b_rvv.rvv37
   LET g_rvv[l_ac].rvv18     = b_rvv.rvv18
   LET g_rvv[l_ac].rvv26     = b_rvv.rvv26
   LET g_rvv[l_ac].rvv17     = b_rvv.rvv17
   LET g_rvv[l_ac].rvv25     = b_rvv.rvv25
   LET g_rvv[l_ac].rvv41     = b_rvv.rvv41 #no.A050
   LET g_rvv[l_ac].rvv80     = b_rvv.rvv80
   LET g_rvv[l_ac].rvv81     = b_rvv.rvv81
   LET g_rvv[l_ac].rvv82     = b_rvv.rvv82
   LET g_rvv[l_ac].rvv83     = b_rvv.rvv83
   LET g_rvv[l_ac].rvv84     = b_rvv.rvv84
   LET g_rvv[l_ac].rvv85     = b_rvv.rvv85
   LET g_rvv[l_ac].rvv86     = b_rvv.rvv86
   LET g_rvv[l_ac].rvv87     = b_rvv.rvv87
   LET g_rvv[l_ac].rvv930    = b_rvv.rvv930 #FUN-670051
   LET g_rvv[l_ac].rvv919    = b_rvv.rvv919 #FUN-A80150 add
 
      LET g_rvv[l_ac].rvv38=b_rvv.rvv38
      LET g_rvv[l_ac].rvv39=b_rvv.rvv39
      LET g_rvv[l_ac].rvv38t=b_rvv.rvv38t    #No.FUN-610018
      LET g_rvv[l_ac].rvv39t=b_rvv.rvv39t    #No.FUN-610018
   LET g_rvv[l_ac].rvvud01 = b_rvv.rvvud01
   LET g_rvv[l_ac].rvvud02 = b_rvv.rvvud02
   LET g_rvv[l_ac].rvvud03 = b_rvv.rvvud03
   LET g_rvv[l_ac].rvvud04 = b_rvv.rvvud04
   LET g_rvv[l_ac].rvvud05 = b_rvv.rvvud05
   LET g_rvv[l_ac].rvvud06 = b_rvv.rvvud06
   LET g_rvv[l_ac].rvvud07 = b_rvv.rvvud07
   LET g_rvv[l_ac].rvvud08 = b_rvv.rvvud08
   LET g_rvv[l_ac].rvvud09 = b_rvv.rvvud09
   LET g_rvv[l_ac].rvvud10 = b_rvv.rvvud10
   LET g_rvv[l_ac].rvvud11 = b_rvv.rvvud11
   LET g_rvv[l_ac].rvvud12 = b_rvv.rvvud12
   LET g_rvv[l_ac].rvvud13 = b_rvv.rvvud13
   LET g_rvv[l_ac].rvvud14 = b_rvv.rvvud14
   LET g_rvv[l_ac].rvvud15 = b_rvv.rvvud15
END FUNCTION
 
FUNCTION t720_b_move_back()
DEFINE l_pmm43   LIKE pmm_file.pmm43 #FUN-5B0144 add
DEFINE l_rva113     LIKE rva_file.rva113    #NO.FUN-940083
 
   LET b_rvv.rvv02     = g_rvv[l_ac].rvv02
   LET b_rvv.rvv05     = g_rvv[l_ac].rvv05
   #FUN-BC0104---add---str---
   LET b_rvv.rvv45     = g_rvv[l_ac].rvv45
   LET b_rvv.rvv46     = g_rvv[l_ac].rvv46 
   LET b_rvv.rvv47     = g_rvv[l_ac].rvv47
   #FUN-BC0104---add---end---
   LET b_rvv.rvv31     = g_rvv[l_ac].rvv31
   LET b_rvv.rvv031    = g_rvv[l_ac].rvv031
   LET b_rvv.rvv32     = g_rvv[l_ac].rvv32
   LET b_rvv.rvv33     = g_rvv[l_ac].rvv33
   LET b_rvv.rvv34     = g_rvv[l_ac].rvv34
   LET b_rvv.rvv35     = g_rvv[l_ac].rvv35
   LET b_rvv.rvv35_fac = g_rvv[l_ac].rvv35_fac
   LET b_rvv.rvv36     = g_rvv[l_ac].rvv36
   LET b_rvv.rvv37     = g_rvv[l_ac].rvv37
   LET b_rvv.rvv18     = g_rvv[l_ac].rvv18
   LET b_rvv.rvv26     = g_rvv[l_ac].rvv26
   LET b_rvv.rvv17     = g_rvv[l_ac].rvv17
   LET b_rvv.rvv25     = g_rvv[l_ac].rvv25
   LET b_rvv.rvv41     = g_rvv[l_ac].rvv41 #no.A050
   LET b_rvv.rvv80     = g_rvv[l_ac].rvv80
   LET b_rvv.rvv81     = g_rvv[l_ac].rvv81
   LET b_rvv.rvv82     = g_rvv[l_ac].rvv82
   LET b_rvv.rvv83     = g_rvv[l_ac].rvv83
   LET b_rvv.rvv84     = g_rvv[l_ac].rvv84
   LET b_rvv.rvv85     = g_rvv[l_ac].rvv85
   LET b_rvv.rvv86     = g_rvv[l_ac].rvv86
   LET b_rvv.rvv87     = g_rvv[l_ac].rvv87
   LET b_rvv.rvv89     = g_rvv[l_ac].rvv89   #FUN-940083 
   LET b_rvv.rvv930    = g_rvv[l_ac].rvv930  #FUN-670051
   LET b_rvv.rvv919    = g_rvv[l_ac].rvv919  #FUN-A80150 add
      LET b_rvv.rvv38=g_rvv[l_ac].rvv38
      LET b_rvv.rvv39=g_rvv[l_ac].rvv39
      LET b_rvv.rvv38t=g_rvv[l_ac].rvv38t   #No.FUN-610018
      LET b_rvv.rvv39t=g_rvv[l_ac].rvv39t   #No.FUN-610018
  #回歸於 p_perright 控管
  #若不想讓User看到單價rvv38,金額的欄位rvv39,可至p_perright建資料即可
  #程式�不再控管
 
      IF b_rvv.rvv87 > 0 THEN
         CALL t720sub_rvv38(b_rvv.rvv36,b_rvv.rvv38,b_rvv.rvv38t,g_rvu.rvu04,g_rvu.rvu01)  #TQC-C30225 add
            RETURNING b_rvv.rvv38,b_rvv.rvv38t 
         LET b_rvv.rvv39=b_rvv.rvv87*b_rvv.rvv38
         LET b_rvv.rvv39t=b_rvv.rvv87*b_rvv.rvv38t
      ELSE
         CALL t720_pmm43(b_rvv.rvv36) RETURNING l_pmm43
        #IF cl_null(l_pmm43) THEN
         IF cl_null(l_pmm43) OR l_pmm43 = 0 THEN   #MOD-BA0062 add
            SELECT gec04 INTO l_pmm43 FROM gec_file,pmc_file 
             WHERE gec01 = pmc47
               AND pmc01 = g_rvu.rvu04 
               AND gec011='1'  #進項
         END IF
        #MOD-D30016 mark start -----
        #IF cl_null(l_pmm43) THEN LET l_pmm43=0 END IF
        #LET b_rvv.rvv39t = b_rvv.rvv39 * (1+l_pmm43/100)
        #MOD-D30016 mark end   -----
         IF b_rvv.rvv87=0 AND cl_null(l_pmm43) THEN
            LET b_rvv.rvv39t=b_rvv.rvv38t
         END IF
      END IF
 
      #No.+090 010430 add by linda 依幣別四捨五入
     #MOD-C40047 str mark----
     #LET t_azi04=''   #No.CHI-6A0004
     # SELECT rva00 INTO g_rva00 FROM rva_file WHERE rva01 = g_rvu.rvu02
     # IF g_rva00 = '1' AND g_rvu.rvu00 = '3' THEN
     #    SELECT azi04 INTO t_azi04 FROM azi_file
     #        WHERE azi01 = g_rvu.rvu113
     # END IF
     # IF g_rva00 = '1' AND g_rvu.rvu00 <> '3' THEN
     #    SELECT azi04 INTO t_azi04                       #No.CHI-6A0004
     #        FROM pmm_file,azi_file
     #     WHERE pmm22=azi01
     #       AND pmm01 = g_rvv[l_ac].rvv36 AND pmm18 <> 'X'
     #END IF
     #IF g_rva00 = '2' THEN
     #   SELECT rva113 INTO l_rva113 FROM rva_file 
     #      WHERE rva01 = g_rvu.rvu02
     #   SELECT azi04 INTO t_azi04 FROM azi_file
     #      WHERE azi01 = l_rva113
     #END IF
     #    IF b_rvv.rvv87 = 0 OR cl_null(t_azi04) THEN      #No.MOD-8A0183
     #       SELECT azi04 INTO t_azi04
     #         FROM pmc_file,azi_file
     #        WHERE pmc22=azi01
     #          AND pmc01 = g_rvu.rvu04
     #    END IF
     #IF cl_null(t_azi04) THEN LET t_azi04=0 END IF  #No.CHI-6A0004
     #MOD-C40047 end mark----
      CALL t720_get_azi()                            #MOD-C40047 add
     #MOD-D30016 mark start -----
     #CALL cl_digcut(b_rvv.rvv39,t_azi04)  #No.CHI-6A0004
     #                  RETURNING b_rvv.rvv39
     #CALL cl_digcut(b_rvv.rvv39t,t_azi04)  #No.CHI-6A0004
     #                  RETURNING b_rvv.rvv39t   #No.FUN-610018
     #MOD-D30016 mark end   -----
    #CALL t720sub_rvv39(b_rvv.rvv36,b_rvv.rvv39,b_rvv.rvv39t,g_rvu.rvu04,g_rvu.rvu02) #FUN-A10130 #MOD-BC0262 mark  
    CALL t720sub_rvv39(b_rvv.rvv36,b_rvv.rvv39,b_rvv.rvv39t,g_rvu.rvu04,g_rvu.rvu01)  #MOD-BC0262 add
         RETURNING b_rvv.rvv39,b_rvv.rvv39t
     #MOD-D30016 add start -----
      CALL cl_digcut(b_rvv.rvv39,t_azi04)
                        RETURNING b_rvv.rvv39
      CALL cl_digcut(b_rvv.rvv39t,t_azi04)
                        RETURNING b_rvv.rvv39t
     #MOD-D30016 add end   -----
 
   LET b_rvv.rvvud01 = g_rvv[l_ac].rvvud01
   LET b_rvv.rvvud02 = g_rvv[l_ac].rvvud02
   LET b_rvv.rvvud03 = g_rvv[l_ac].rvvud03
   LET b_rvv.rvvud04 = g_rvv[l_ac].rvvud04
   LET b_rvv.rvvud05 = g_rvv[l_ac].rvvud05
   LET b_rvv.rvvud06 = g_rvv[l_ac].rvvud06
   LET b_rvv.rvvud07 = g_rvv[l_ac].rvvud07
   LET b_rvv.rvvud08 = g_rvv[l_ac].rvvud08
   LET b_rvv.rvvud09 = g_rvv[l_ac].rvvud09
   LET b_rvv.rvvud10 = g_rvv[l_ac].rvvud10
   LET b_rvv.rvvud11 = g_rvv[l_ac].rvvud11
   LET b_rvv.rvvud12 = g_rvv[l_ac].rvvud12
   LET b_rvv.rvvud13 = g_rvv[l_ac].rvvud13
   LET b_rvv.rvvud14 = g_rvv[l_ac].rvvud14
   LET b_rvv.rvvud15 = g_rvv[l_ac].rvvud15
END FUNCTION
 
FUNCTION t720_b_else()
   IF g_rvv[l_ac].rvv05 IS NULL THEN LET g_rvv[l_ac].rvv05 =' ' END IF
   IF g_rvv[l_ac].rvv02 IS NULL THEN LET g_rvv[l_ac].rvv02 =' ' END IF
#--------數字為null則default 0 ------------
   IF cl_null(b_rvv.rvv17) THEN LET b_rvv.rvv17=0 END IF
END FUNCTION
 
FUNCTION t720_b_askkey()
DEFINE l_wc2    LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(300)
 
    CONSTRUCT l_wc2 ON rvv02, rvv05, rvv45,rvv46,qcl02,rvv47,  #FUN-BC0104 add
                       rvv31, rvv031, rvv32, rvv33,
                       rvv34, rvv35, rvv35_fac, rvv36, rvv37,
                       rvv18, rvv17, rvv25, rvv03, rvv20, rvv21,rvv41,
                       rvvud01,rvvud02,rvvud03,rvvud04,rvvud05,
                       rvvud06,rvvud07,rvvud08,rvvud09,rvvud10,
                       rvvud11,rvvud12,rvvud13,rvvud14,rvvud15
                  FROM s_rvv[1].rvv02, s_rvv[1].rvv05, 
                       s_rvv[1].rvv45, s_rvv[1].rvv46,s_rvv[1].qcl02,s_rvv[1].rvv47,   #FUN-BC0104 add
                       s_rvv[1].rvv31,
                       s_rvv[1].rvv031,s_rvv[1].rvv32, s_rvv[1].rvv33,
                       s_rvv[1].rvv34, s_rvv[1].rvv35, s_rvv[1].rvv35_fac,
                       s_rvv[1].rvv36, s_rvv[1].rvv37, s_rvv[1].rvv18,
                       s_rvv[1].rvv17, s_rvv[1].rvv25, s_rvv[1].rvv03,
                       s_rvv[1].rvv20, s_rvv[1].rvv21, s_rvv[1].rvv41,
                       s_rvv[1].rvvud01,s_rvv[1].rvvud02,s_rvv[1].rvvud03,
                       s_rvv[1].rvvud04,s_rvv[1].rvvud05,s_rvv[1].rvvud06,
                       s_rvv[1].rvvud07,s_rvv[1].rvvud08,s_rvv[1].rvvud09,
                       s_rvv[1].rvvud10,s_rvv[1].rvvud11,s_rvv[1].rvvud12,
                       s_rvv[1].rvvud13,s_rvv[1].rvvud14,s_rvv[1].rvvud15
 
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
 
    CALL t720_b_fill(l_wc2)
 
END FUNCTION
 
FUNCTION t720_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2           LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(200)
#FUN-A60035 ---MARK BEGIN
##FUN-A60035 ---add begin
#  DEFINE l_rvv02  DYNAMIC ARRAY OF RECORD
#         rvv02    LIKE rvv_file.rvv02
#         END RECORD
#  DEFINE l_i      LIKE type_file.num5
#  DEFINE l_go     LIKE type_file.chr1
##FUN-A60035 ---add end
#FUN-A60035 ---MARK END
 
    IF cl_null(p_wc2) THEN LET p_wc2=" 1=1 " END IF
 
    IF g_prog = 'apmt720' OR g_prog = 'aict042' THEN  #MOD-D30083 add aict042
          LET g_sql = "SELECT rvv02,rvv05,rvv45,rvv46,qcl02,rvv47,rvv31,'','','','','','','','','','','','','','','','','','','','','',rvv031,ima021,'','','','',rvv35,rvv35_fac,", #TQC-650108 新增21個空位 #FUN-810038  #FUN-BC0104 add rvv45,rvv46,qcl02,rvv47
          " rvv10,rvv11,rvv12,rvv13,",  #NO.FUN-960130
          "       rvv18,rvv36,rvv37,rvv919,'','','',rvv25, rvv89,rvv17, rvv32,rvv33,rvv34,'','','','','',", #FUN-740046 rvv37 #FUN-9A0068  #FUN-A80150 add rvv919
          "       rvv83,rvv84,rvv85,rvv80, rvv81, rvv82,rvv86,rvv87,",
          "       rvv38,rvv38t,rvv39,rvv39t,rvv26,azf03, rvv41,'','','','',", #no.A050  FUN-610018  #FUN-B40083  add pmn123 mse02
          "       rvv930,'', ",  #FUN-670051
          "       rvvud01,rvvud02,rvvud03,rvvud04,rvvud05,",
          "       rvvud06,rvvud07,rvvud08,rvvud09,rvvud10,",
          "       rvvud11,rvvud12,rvvud13,rvvud14,rvvud15 ",
#TQC-A60046 --Begin
#         "  FROM rvv_file, OUTER azf_file, OUTER ima_file ",
#         "      ,OUTER(pmn_file,OUTER pmm_file) ",          #FUN-940083   
#         " WHERE rvv01 ='",g_rvu.rvu01,"'",     #單頭
#         "   AND pmm_file.pmm01 = pmn01 AND rvv36 = pmn_file.pmn01 AND rvv37 = pmn_file.pmn02 ",  #FUN-740046
#         "   AND rvv26=azf_file.azf01 AND azf_file.azf02='2' ",
#         "   AND rvv31=ima_file.ima01 ",
          "  FROM rvv_file LEFT OUTER JOIN azf_file ON rvv26=azf01 AND azf02='2' ",
          "                LEFT OUTER JOIN ima_file ON rvv31=ima01 ",
          "                LEFT OUTER JOIN ",
          "                    pmn_file LEFT OUTER JOIN pmm_file ON pmn01=pmm01 ",
          "                ON rvv36=pmn01 AND rvv37=pmn02 ",
          "                LEFT OUTER JOIN qcl_file ON rvv46=qcl01 ",                       #FUN-BC0104
          " WHERE rvv01 ='",g_rvu.rvu01,"'",     #單頭
#TQC-A60046 --End
          "   AND ",p_wc2 CLIPPED,               #單身
          " ORDER BY rvv02 "
    ELSE
          LET g_sql = "SELECT rvv02,rvv05,rvv45,rvv46,qcl02,rvv47,rvv31,'','','','','','','','','','','','','','','','','','','','','',rvv031,ima021,'','','','',rvv35,rvv35_fac,", #TQC-650108 新增21個空位 #FUN-810038    #FUN-BC0104add
          " rvv10,rvv11,rvv12,rvv13,",  #NO.FUN-960130
          "       rvv18,rvv36,rvv37,rvv919,'','','',rvv25, rvv89, rvv17, rvv32,rvv33,rvv34,'','','','','',",   #FUN-740046 rvv37後#FUN-9A00688  #FUN-A80150 add rvv919
          "       rvv83,rvv84,rvv85,rvv80, rvv81, rvv82,rvv86,rvv87,",
          "       rvv38,rvv38t,rvv39,rvv39t,rvv26,azf03, rvv41,'','','','',", #no.A050  FUN-610018  #FUN-B40083  add pmn123 mse02
          "       rvv930,'', ",  #FUN-670051
          "       rvvud01,rvvud02,rvvud03,rvvud04,rvvud05,",
          "       rvvud06,rvvud07,rvvud08,rvvud09,rvvud10,",
          "       rvvud11,rvvud12,rvvud13,rvvud14,rvvud15 ",
          "  FROM rvv_file, OUTER azf_file, OUTER ima_file ,OUTER qcl_file", #FUN-BC0104 qcl_file
          " WHERE rvv01 ='",g_rvu.rvu01,"'",     #單頭
          "   AND rvv26=azf_file.azf01 AND azf_file.azf02='2' ",
          "   AND rvv31=ima_file.ima01 ",
          "   AND rvv46=qcl_file.qcl01 ",        #FUN-BC0104
          "   AND ",p_wc2 CLIPPED,               #單身
          " ORDER BY rvv02 "
    END IF
    PREPARE t720_pb FROM g_sql
    DECLARE rvv_curs CURSOR FOR t720_pb
 
    CALL g_rvv.clear()
    LET g_cnt = 1
    FOREACH rvv_curs INTO g_rvv[g_cnt].*               #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 
        IF cl_null(g_rvv[g_cnt].rvv80) THEN
           LET g_rvv[g_cnt].rvv81 = NULL
           LET g_rvv[g_cnt].rvv82 = NULL
        END IF
        IF cl_null(g_rvv[g_cnt].rvv83) THEN
           LET g_rvv[g_cnt].rvv84 = NULL
           LET g_rvv[g_cnt].rvv85 = NULL
        END IF
       SELECT pmm909 INTO g_rvv[g_cnt].pmm909
         FROM pmm_file WHERE pmm01 = g_rvv[g_cnt].rvv36
       SELECT pmn24,pmn25,pmn123                     #FUN-B40083   add pmn123
         INTO g_rvv[g_cnt].pmn24,g_rvv[g_cnt].pmn25,g_rvv[g_cnt].pmn123    #FUN-B40083
         FROM pmn_file
        WHERE pmn01 = g_rvv[g_cnt].rvv36
          AND pmn02 = g_rvv[g_cnt].rvv37
        #FUN-B40083 --begin
        IF NOT cl_null(g_rvv[g_cnt].pmn123) THEN
           SELECT mse02 INTO g_rvv[g_cnt].mse02
             FROM mse_file WHERE mse01= g_rvv[g_cnt].pmn123
        ELSE
           LET g_rvv[g_cnt].pmn123 = ' '
           LET g_rvv[g_cnt].mse02 = ' '
        END IF
        #FUN-B40083 --end
        CALL t720_get_pmm43(g_cnt)
        IF cl_null(g_rvv[g_cnt].pmm43) THEN
           SELECT gec01,gec04 
             INTO g_rvv[g_cnt].pmm21,g_rvv[g_cnt].pmm43 
             FROM gec_file,pmc_file 
            WHERE gec01 = pmc47
              AND pmc01 = g_rvu.rvu04 
              AND gec011='1'  #進項
        END IF
        CALL t720_set_rvv930(g_rvv[g_cnt].rvv930) RETURNING g_rvv[g_cnt].gem02a #FUN-670051
         
#FUN-A60035 ---MARK BEGIN
#      #No.FUN-A50054 -BEGIN----- 
#       IF s_industry('slk') THEN
#          #FUN-A60035 ---mark begin
#          SELECT ata02 INTO g_rvv[g_cnt].rvv05 FROM ata_file
#           WHERE ata00 = 'apmt110'
#             AND ata01 = g_rvu.rvu02
#             AND ata03 = g_rvv[g_cnt].rvv02
#          #FUN-A60035 ---mark end
#          SELECT ata02,ata05 INTO g_rvv[g_cnt].rvv02,g_rvv[g_cnt].rvv31
#            FROM ata_file
#           WHERE ata00 = g_prog
#             AND ata01 = g_rvu.rvu01
#             AND ata03 = g_rvv[g_cnt].rvv02
#          LET l_rvv02[l_rvv02.getLength() + 1] = g_rvv[g_cnt].rvv02   #FUN-A60035 add
#          IF g_cnt > 1 THEN
#             #FUN-A60035 ---mark begin
#             #IF g_rvv[g_cnt].rvv02 = g_rvv[g_cnt-1].rvv02 THEN
#             #   CONTINUE FOREACH
#             #END IF
#             #FUN-A60035 ---mark end
#             #FUN-A60035 ---add begin
#                LET l_go = 'N'
#                FOR l_i = 1 TO l_rvv02.getLength()-1
#                    IF g_rvv[g_cnt].rvv02 = l_rvv02[l_i].rvv02 THEN
#                       LET l_go = 'Y'
#                       EXIT FOR
#                    END IF
#                END FOR
#                IF l_go = 'Y' THEN
#                   CONTINUE FOREACH
#                END IF
#             #FUN-A60035 ---add end
#          END IF
#          SELECT SUM(ata08) INTO g_rvv[g_cnt].rvv17 from ata_file
#           WHERE ata00 = g_prog
#             AND ata01 = g_rvu.rvu01
#             AND ata02 = g_rvv[g_cnt].rvv02
#       ELSE
#      #No.FUN-A50054 -END-------
#FUN-A60035 ---MARK END
        #如果進行料件多屬性管理并選擇新機制則要對單身顯示的東東進行更改
         IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN
           #得到該料件對應的父料件和所有屬性
           SELECT imx00,imx01,imx02,imx03,imx04,imx05,imx06,
                  imx07,imx08,imx09,imx10 INTO
                  g_rvv[g_cnt].att00,g_rvv[g_cnt].att01,g_rvv[g_cnt].att02,
                  g_rvv[g_cnt].att03,g_rvv[g_cnt].att04,g_rvv[g_cnt].att05,
                  g_rvv[g_cnt].att06,g_rvv[g_cnt].att07,g_rvv[g_cnt].att08,
                  g_rvv[g_cnt].att09,g_rvv[g_cnt].att10
           FROM imx_file WHERE imx000 = g_rvv[g_cnt].rvv31
 
           LET g_rvv[g_cnt].att01_c = g_rvv[g_cnt].att01
           LET g_rvv[g_cnt].att02_c = g_rvv[g_cnt].att02
           LET g_rvv[g_cnt].att03_c = g_rvv[g_cnt].att03
           LET g_rvv[g_cnt].att04_c = g_rvv[g_cnt].att04
           LET g_rvv[g_cnt].att05_c = g_rvv[g_cnt].att05
           LET g_rvv[g_cnt].att06_c = g_rvv[g_cnt].att06
           LET g_rvv[g_cnt].att07_c = g_rvv[g_cnt].att07
           LET g_rvv[g_cnt].att08_c = g_rvv[g_cnt].att08
           LET g_rvv[g_cnt].att09_c = g_rvv[g_cnt].att09
           LET g_rvv[g_cnt].att10_c = g_rvv[g_cnt].att10
 
         END IF
#        END IF  #No.FUN-A50054 Add   #FUN-A60035 ---MARK
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
            CALL cl_err( '', 9035, 0 )
     EXIT FOREACH
       END IF
    END FOREACH
    CALL g_rvv.deleteElement(g_cnt)
 
    LET g_rec_b=g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
 
    CALL t720_refresh_detail() #No.TQC-650108
    #FUN-B30170 add begin-------------------------
    LET g_sql = " SELECT rvbs02,rvbs021,ima02,ima021,rvbs022,rvbs04,rvbs03,rvbs05,rvbs06,rvbs07,rvbs08",
                "   FROM rvbs_file LEFT JOIN ima_file ON rvbs021 = ima01",
                "  WHERE rvbs00 = '",g_prog,"' AND rvbs01 = '",g_rvu.rvu01,"'"

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


FUNCTION t720_get_price()
 
   IF g_rvu.rvu00 != '3' OR NOT cl_null(g_rvu.rvu02) THEN RETURN END IF
   IF cl_null(g_rvv[l_ac].rvv31) OR cl_null(g_rvv[l_ac].rvv35) 
      OR cl_null(g_rvv[l_ac].rvv87) OR cl_null(g_rvv[l_ac].rvv86) THEN
      RETURN
   END IF
   CALL s_defprice_new(g_rvv[l_ac].rvv31,g_rvu.rvu04,g_rvu.rvu113,g_rvu.rvu03,
                   g_rvv[l_ac].rvv87,'',g_rvu.rvu115,g_rvu.rvu12,'',
                   g_rvv[l_ac].rvv86,'',g_rvu.rvu112,g_rvu.rvu111,g_rvu.rvuplant)
      RETURNING g_rvv[l_ac].rvv38,g_rvv[l_ac].rvv38t,
                g_rvv[l_ac].rvv10,g_rvv[l_ac].rvv11    #TQC-AC0257 add
   LET g_rvv[l_ac].rvv39 = g_rvv[l_ac].rvv38*g_rvv[l_ac].rvv87
   LET g_rvv[l_ac].rvv39t = g_rvv[l_ac].rvv38t*g_rvv[l_ac].rvv87
   IF cl_null(g_rvv[l_ac].rvv10) THEN LET g_rvv[l_ac].rvv10 = '4' END IF  #TQC-AC0257 add
END FUNCTION

FUNCTION t720_check_rvv32()
DEFINE l_ime12            LIKE ime_file.ime12
 
   LET g_errno = ' '
   IF cl_null(g_rvv[l_ac].rvv32) OR cl_null(g_rvv[l_ac].rvv33) THEN
      RETURN
   END IF
 
   SELECT ime12 INTO l_ime12 FROM ime_file WHERE ime01 = g_rvv[l_ac].rvv32
                                             AND ime02 = g_rvv[l_ac].rvv33
   IF SQLCA.SQLCODE THEN LET g_errno = SQLCA.SQLCODE END IF
   IF g_rvv[l_ac].rvv89 = 'Y' THEN
      IF l_ime12 = '0' THEN
         LET g_errno = 'apm-329'
      END IF
   ELSE
      IF l_ime12 = '1' THEN
         LET g_errno = 'apm-309'
      END IF
   END IF
END FUNCTION

FUNCTION t720_set_rvv89()
DEFINE l_pmh24       LIKE pmh_file.pmh24
    
   IF NOT cl_null(g_rvu.rvu02) THEN RETURN END IF
 
   SELECT pmh24 INTO l_pmh24 FROM pmh_file
        WHERE pmh01 = g_rvv[l_ac].rvv31 AND pmh02 = g_rvu.rvu04
          AND pmh13 = g_rvu.rvu113 AND pmh21 = ' '
          AND pmh22 = '1' AND pmh23 = ' '
   IF SQLCA.SQLCODE = 100 THEN
      SELECT pmc914 INTO l_pmh24 FROM pmc_file WHERE pmc01 = g_rvu.rvu04
   END IF
   IF l_pmh24 IS NULL THEN LET l_pmh24 = 'N' END IF
   IF l_pmh24 = 'Y' THEN LET g_rvv[l_ac].rvv89 = 'Y' END IF
   IF g_rvv[l_ac].rvv89 = 'Y' THEN
      CALL cl_set_comp_entry("rvv32,rvv33",FALSE)
      SELECT pmc917,pmc918 INTO g_rvv[l_ac].rvv32,g_rvv[l_ac].rvv33
          FROM pmc_file WHERE pmc01 = g_rvu.rvu04
   ELSE
      CALL cl_set_comp_entry("rvv32,rvv33",TRUE)
   END IF
END FUNCTION
FUNCTION t720_get_pmm43(p_row)
DEFINE p_row       LIKE type_file.num5
DEFINE l_rva115    LIKE rva_file.rva115
DEFINE l_rva116    LIKE rva_file.rva116
DEFINE l_rva00     LIKE rva_file.rva00
 
    IF NOT cl_null(g_rvu.rvu02) THEN
       SELECT rva00,rva115,rva116 INTO l_rva00,l_rva115,l_rva116 
          FROM rva_file WHERE rva01 = g_rvu.rvu02
       IF l_rva00 = '2' THEN
          LET g_rvv[p_row].pmm21 = l_rva115
          LET g_rvv[p_row].pmm43 = l_rva116
       ELSE
          SELECT pmm21,pmm43
             INTO g_rvv[p_row].pmm21,g_rvv[p_row].pmm43
            FROM pmm_file
           WHERE pmm01 = g_rvv[p_row].rvv36
       END IF
    ELSE
       IF g_rvu.rvu00 = '3' THEN
          SELECT rvu115,rvu12 INTO g_rvv[p_row].pmm21,g_rvv[p_row].pmm43
              FROM rvu_file WHERE rvu01 = g_rvu.rvu01
       ELSE 
          SELECT pmm21,pmm43
             INTO g_rvv[p_row].pmm21,g_rvv[p_row].pmm43
            FROM pmm_file
           WHERE pmm01 = g_rvv[p_row].rvv36
       END IF
    END IF
 
END FUNCTION
FUNCTION t720_bp(p_ud)
   DEFINE   p_ud       LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
  #FUN-A60009 mark str ---
  #MARK原因:放段程式寫在此處會造成EF簽核時出現此ACTION
  #IF (g_argv1 = '1' AND cl_null(g_argv3)) OR (g_argv1 = '1' AND g_argv3 = 'TAP')  THEN     #CHI-8B0047 
  #    CALL cl_set_act_visible("carry_delivery",TRUE)
  #ELSE
  #    CALL cl_set_act_visible("carry_delivery",FALSE)
  #END IF
  #FUN-A60009 mark end ---
  #FUN-6C0050--end
   
   CALL cl_set_act_visible("accept,cancel", FALSE)
#FUN-B30170 add begin-------------------------
   DIALOG ATTRIBUTES(UNBUFFERED)

#FUN-B90104---Add---End--
#FUN-B90104---Add---End--

      DISPLAY ARRAY g_rvv TO s_rvv.* ATTRIBUTE(COUNT=g_rec_b)
 
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
         # 2004/05/24 分別判斷是否需顯現
         LET g_action_choice="recall"
         CALL cl_chk_act_auth_nomsg()   #No.TQC-630284 add
         IF NOT cl_chk_act_auth() THEN
            CALL cl_set_act_visible("recall",FALSE)
         END IF
         CALL cl_chk_act_auth_showmsg()   #CHI-B10026
         LET g_action_choice="allowance"
         CALL cl_chk_act_auth_nomsg()   #No.TQC-630284 add
         IF NOT cl_chk_act_auth() THEN
            CALL cl_set_act_visible("allowance",FALSE)
         END IF
         CALL cl_chk_act_auth_showmsg()   #CHI-B10026
         IF NOT ( g_argv1='1' AND g_argv3='SUB' ) THEN
            CALL cl_set_act_visible("transfer_to_report",FALSE)
         END IF
         IF g_argv3 != 'TAP' OR (g_argv3='TAP' AND g_argv1='2') THEN
            CALL cl_set_act_visible("carry,undo_carry,",FALSE)
         END IF
         IF g_argv1='1' THEN
            CALL  cl_set_act_visible("recall,allowance,",FALSE)
         END IF
         IF g_argv1 != '1' OR NOT cl_null(g_argv3) AND g_argv3 <> 'SUB' THEN #FUN-840032
            CALL  cl_set_act_visible("price_change",FALSE)
         END IF
         IF g_argv1='2' THEN
            CALL  cl_set_act_visible("allowance,",FALSE)
         END IF
         LET g_action_choice = " " #TQC-B40100 add
        #FUN-B40031 Begin---
         IF g_rvu00='A' THEN
            #TQC-D40003---mark---S
            #CALL cl_set_act_visible("transfer_to_report,allowance,recall,void,undo_void,  #FUN-D20025 add undo_void
            #                         confirm,undo_confirm,carry,
            #undo_carry,price_change,approval_status,easyflow_approval,carry_delivery,
            #gen_transfer_note,gpm_show,gpm_query,aic_qry_back,aic_s_icdin,aic_s_icdqry,
            #qry_lot,gen_mat_wtdw,maint_mat_wtdw,,agree,deny,modify_flow,withdraw,
            #org_withdraw,phrase",FALSE)
            #TQC-D40003---mark---E
            #TQC-D40003---S
             CALL cl_set_act_visible("transfer_to_report,allowance,recall,void,undo_void,                                        confirm,undo_confirm,carry,undo_carry,price_change,                                      approval_status,easyflow_approval,carry_delivery,                                      gen_transfer_note,gpm_show,gpm_query,aic_qry_back,aic_s_icdin,aic_s_icdqry,                                      qry_lot,gen_mat_wtdw,maint_mat_wtdw,,agree,deny,modify_flow,withdraw,                                      org_withdraw,phrase", FALSE)
            #TQC-D40003---E
         END IF
        #FUN-B40031 End-----
        #FUN-BB0044 Add Begin ---
         IF NOT cl_null(g_rvu.rvu00) THEN
            IF g_rvu.rvu00 = '3' THEN
               CALL cl_set_act_visible("allowance",TRUE)
               CALL cl_set_comp_visible("rvu116",TRUE)
            ELSE
               CALL cl_set_act_visible("allowance",FALSE)
               CALL cl_set_comp_visible("rvu116",FALSE)
            END IF
         END IF
        #FUN-BB0044 Add End -----
        #FUN-CB0014---add---str---
        CALL cl_set_act_visible("page_list",FALSE)
        IF g_prog = 'apmt720' OR g_prog = 'apmt720_icd' OR g_prog = 'aict042' OR  #MOD-D30083 add acit042 
           g_prog = 'apmt721' OR g_prog = 'apmt721_icd' OR g_prog = 'aict043' OR  #MOD-D30083 add acit043
           g_prog = 'apmt722' OR g_prog = 'apmt722_icd' OR g_prog = 'aict044' OR  #MOD-D30083 add acit044
           g_prog = 'apmt740' OR g_prog = 'apmt740_icd' OR
           g_prog = 'apmt741' OR g_prog = 'apmt741_icd' OR
           g_prog = 'apmt742' OR g_prog = 'apmt742_icd' THEN  
           CALL cl_set_act_visible("page_list",TRUE)
        END IF
        #FUN-CB0014---add---end---


     #FUN-CB0014---add---str---
      ON ACTION page_list
         LET g_action_flag = "page_list"  
         EXIT DIALOG
     #FUN-CB0014---add---end--- 
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
         CALL t720_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
           ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL t720_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
  ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL t720_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
  ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t720_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
  ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t720_fetch('L')
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
         IF g_aza.aza71 MATCHES '[Yy]' THEN
            CALL aws_gpmcli_toolbar()
            CALL cl_set_act_visible("gpm_show,gpm_query", TRUE)
         ELSE
            CALL cl_set_act_visible("gpm_show,gpm_query", FALSE)  #N0.TQC-710042
         END IF
         #CKP
        #FUN-C30140--mod---str--
        #IF g_rvu.rvuconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
        #CALL cl_set_field_pic(g_rvu.rvuconf,"","","",g_chr,"")
         CALL t720_pic()
        #FUN-C30140--mod---end--
         CALL t720_def_form()     #FUN-610067
         LET g_action_choice="locale"       #No.TQC-790064
         EXIT DIALOG
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
          
#FUN-A60035 ---MARK BEGIN
#   #No.FUN-A50054 -BEGIN-----
#     ON ACTION style_detail
#        LET g_action_choice="style_detail"
#        EXIT DIALOG
#   #No.FUN-A50054 -END-------
#FUN-A60035 ---MARK END

    #@ON ACTION 轉報工單
      ON ACTION transfer_to_report
         LET g_action_choice="transfer_to_report"
         EXIT DIALOG
    #@ON ACTION 折讓
      ON ACTION allowance
         LET g_action_choice="allowance"
         EXIT DIALOG
    #@ON ACTION recall
      ON ACTION recall
         LET g_action_choice="recall"
         EXIT DIALOG
    #@ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DIALOG
    #FUN-D20025--add--str--
    #@ON ACTION 取消作廢 
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DIALOG
    #FUN-D20025--add--end--
    #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DIALOG
    #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DIALOG
    #@ON ACTION 拋轉
      ON ACTION carry
         LET g_action_choice="carry"
         EXIT DIALOG
    #@ON ACTION 拋轉還原
      ON ACTION undo_carry
         LET g_action_choice="undo_carry"
         EXIT DIALOG
    #@ON ACTION 單價變更
      ON ACTION price_change
         LET g_action_choice="price_change"
         EXIT DIALOG
 
    #FUN-A60009 add str ---
    #@ON ACTION 簽核狀況
      ON ACTION approval_status
         LET g_action_choice="approval_status"
         EXIT DIALOG

    #@ON ACTION easyflow送簽
      ON ACTION easyflow_approval
         LET g_action_choice = "easyflow_approval"
         EXIT DIALOG
    #FUN-A60009 add end --
    #FUN-BC0104---add---str
      #QC 結果判定產生入庫單
      ON ACTION qc_determine_storage 
         LET g_action_choice = "qc_determine_storage"
         EXIT DIALOG
    #FUN-BC0104---add---end

      #str----add by guanyao160517
      #ON ACTION fa_issue
      #   LET g_action_choice = 'fa_issue'
      #   EXIT DIALOG
      #end----add by guanyao160517

 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DIALOG
 
      ON ACTION cancel
         LET INT_FLAG=FALSE     #MOD-570244 mars
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel       #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG

     #FUN-A60009 add str ---
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
     #FUN-A60009 add end ---
 
      ON ACTION controls                           #No.FUN-6B0032
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032

 
      ON ACTION related_document                #No.FUN-6A0162  相關文件
         LET g_action_choice="related_document"
         EXIT DIALOG
 
      ON ACTION carry_delivery                #No.FUN-6C0050 轉出貨單
         LET g_action_choice="carry_delivery"
         EXIT DIALOG
 
      ON ACTION gpm_show
         LET g_action_choice="gpm_show"
         EXIT DIALOG
 
      ON ACTION gpm_query
         LET g_action_choice="gpm_query"
         EXIT DIALOG
      ON ACTION qry_lot
         LET g_action_choice="qry_lot"
         EXIT DIALOG
      ON ACTION gen_transfer_note
         LET g_action_choice="gen_transfer_note"
         EXIT DIALOG
 
#@    ON ACTION 領料產生                                                                                                            
      ON ACTION gen_mat_wtdw                                                                                                        
         LET g_action_choice="gen_mat_wtdw"                                                                                         
         EXIT DIALOG                                                                                                               
#@    ON ACTION 領料維護                                                                                                            
      ON ACTION maint_mat_wtdw                                                                                                      
         LET g_action_choice="maint_mat_wtdw"                                                                                       
         EXIT DIALOG                                                                                                               

      #No.FUN-A80026  --Begin
#@    ON ACTION 产生应付帐款
      ON ACTION gen_ap
         LET g_action_choice="gen_ap"
         EXIT DIALOG                                                                                                               
      #No.FUN-A80026  --End  

      #DEV-D30045--add--begin
      ON ACTION barcode_gen
         LET g_action_choice="barcode_gen"
         EXIT DIALOG                                                                                                               

      ON ACTION barcode_query
         LET g_action_choice="barcode_query"
         EXIT DIALOG                                                                                                               

      ON ACTION barcode_output
         LET g_action_choice="barcode_output"
         EXIT DIALOG                                                                                                               
      #DEV-D30045--add--end
 
      &include "qry_string.4gl"
   END DIALOG
#FUN-B30170 add -end--------------------------
#FUN-B30170 mark -begin-----------------------------
#   DISPLAY ARRAY g_rvv TO s_rvv.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
# 
#      BEFORE DISPLAY
#         CALL cl_navigator_setting( g_curs_index, g_row_count )
##FUN-A60035 ---MARK BEGIN
##       #No.FUN-A50054 -BEGIN-----
##        IF NOT s_industry('slk') THEN 
##           CALL cl_set_act_visible("style_detail",FALSE)
##        END IF
##       #No.FUN-A50054 -END-------
##FUN-A60035 ---MARK END
# 
#         # 2004/05/24 分別判斷是否需顯現
#         LET g_action_choice="recall"
#         CALL cl_chk_act_auth_nomsg()   #No.TQC-630284 add
#         IF NOT cl_chk_act_auth() THEN
#            CALL cl_set_act_visible("recall",FALSE)
#         END IF
#         CALL cl_chk_act_auth_showmsg()   #CHI-B10026
#         LET g_action_choice="allowance"
#         CALL cl_chk_act_auth_nomsg()   #No.TQC-630284 add
#         IF NOT cl_chk_act_auth() THEN
#            CALL cl_set_act_visible("allowance",FALSE)
#         END IF
#         CALL cl_chk_act_auth_showmsg()   #CHI-B10026
#         IF NOT ( g_argv1='1' AND g_argv3='SUB' ) THEN
#            CALL cl_set_act_visible("transfer_to_report",FALSE)
#         END IF
#         IF g_argv3 != 'TAP' OR (g_argv3='TAP' AND g_argv1='2') THEN
#            CALL cl_set_act_visible("carry,undo_carry,",FALSE)
#         END IF
#         IF g_argv1='1' THEN
#            CALL  cl_set_act_visible("recall,allowance,",FALSE)
#         END IF
#         IF g_argv1 != '1' OR NOT cl_null(g_argv3) AND g_argv3 <> 'SUB' THEN #FUN-840032
#            CALL  cl_set_act_visible("price_change",FALSE)
#         END IF
#         IF g_argv1='2' THEN
#            CALL  cl_set_act_visible("allowance,",FALSE)
#         END IF
# 
#      BEFORE ROW
#         LET l_ac = ARR_CURR()
#      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
#         CALL t720_fetch('F')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#         IF g_rec_b != 0 THEN
#            CALL fgl_set_arr_curr(1)
#         END IF
#           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
# 
#      ON ACTION previous
#         CALL t720_fetch('P')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#         IF g_rec_b != 0 THEN
#            CALL fgl_set_arr_curr(1)
#         END IF
#  ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
# 
#      ON ACTION jump
#         CALL t720_fetch('/')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#         IF g_rec_b != 0 THEN
#            CALL fgl_set_arr_curr(1)
#         END IF
#  ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
# 
# 
#      ON ACTION next
#         CALL t720_fetch('N')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#         IF g_rec_b != 0 THEN
#            CALL fgl_set_arr_curr(1)
#         END IF
#  ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
# 
# 
#      ON ACTION last
#         CALL t720_fetch('L')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#         IF g_rec_b != 0 THEN
#            CALL fgl_set_arr_curr(1)  ######add in 040505
#         END IF
#  ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
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
#         IF g_aza.aza71 MATCHES '[Yy]' THEN
#            CALL aws_gpmcli_toolbar()
#            CALL cl_set_act_visible("gpm_show,gpm_query", TRUE)
#         ELSE
#            CALL cl_set_act_visible("gpm_show,gpm_query", FALSE)  #N0.TQC-710042
#         END IF
#         #CKP
#         IF g_rvu.rvuconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
#         CALL cl_set_field_pic(g_rvu.rvuconf,"","","",g_chr,"")
#         CALL t720_def_form()     #FUN-610067
#         LET g_action_choice="locale"       #No.TQC-790064
#         EXIT DISPLAY
# 
#      ON ACTION exit
#         LET g_action_choice="exit"
#         EXIT DISPLAY
# 
#      ON ACTION controlg
#         LET g_action_choice="controlg"
#         EXIT DISPLAY
#          
##FUN-A60035 ---MARK BEGIN
##   #No.FUN-A50054 -BEGIN-----
##     ON ACTION style_detail
##        LET g_action_choice="style_detail"
##        EXIT DISPLAY
##   #No.FUN-A50054 -END-------
##FUN-A60035 ---MARK END
#
#    #@ON ACTION 轉報工單
#      ON ACTION transfer_to_report
#         LET g_action_choice="transfer_to_report"
#         EXIT DISPLAY
#    #@ON ACTION 折讓
#      ON ACTION allowance
#         LET g_action_choice="allowance"
#         EXIT DISPLAY
#    #@ON ACTION recall
#      ON ACTION recall
#         LET g_action_choice="recall"
#         EXIT DISPLAY
#    #@ON ACTION 作廢
#      ON ACTION void
#         LET g_action_choice="void"
#         EXIT DISPLAY
#    #@ON ACTION 確認
#      ON ACTION confirm
#         LET g_action_choice="confirm"
#         EXIT DISPLAY
#    #@ON ACTION 取消確認
#      ON ACTION undo_confirm
#         LET g_action_choice="undo_confirm"
#         EXIT DISPLAY
#    #@ON ACTION 拋轉
#      ON ACTION carry
#         LET g_action_choice="carry"
#         EXIT DISPLAY
#    #@ON ACTION 拋轉還原
#      ON ACTION undo_carry
#         LET g_action_choice="undo_carry"
#         EXIT DISPLAY
#    #@ON ACTION 單價變更
#      ON ACTION price_change
#         LET g_action_choice="price_change"
#         EXIT DISPLAY
# 
#    #FUN-A60009 add str ---
#    #@ON ACTION 簽核狀況
#      ON ACTION approval_status
#         LET g_action_choice="approval_status"
#         EXIT DISPLAY
#
#    #@ON ACTION easyflow送簽
#      ON ACTION easyflow_approval
#         LET g_action_choice = "easyflow_approval"
#         EXIT DISPLAY
#    #FUN-A60009 add end --
#
#&ifdef ICD
##@  ON ACTION 回貨查詢作業                                                    
#    ON ACTION aic_qry_back
#       LET g_action_choice = "aic_qry_back"
#       EXIT DISPLAY
# 
##@  ON ACTION 單據刻號BIN查詢作業
#    ON ACTION aic_s_icdqry
#       LET g_action_choice = "aic_s_icdqry"
#       EXIT DISPLAY
# 
##@  ON ACTION 刻號BIN維護作業
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
#         LET INT_FLAG=FALSE     #MOD-570244 mars
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
#      ON ACTION exporttoexcel       #FUN-4B0025
#         LET g_action_choice = 'exporttoexcel'
#         EXIT DISPLAY
#
#     #FUN-A60009 add str ---
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
#     #FUN-A60009 add end ---
# 
#      AFTER DISPLAY
#         CONTINUE DISPLAY
# 
#      ON ACTION controls                           #No.FUN-6B0032
#         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
# 
#      ON ACTION related_document                #No.FUN-6A0162  相關文件
#         LET g_action_choice="related_document"
#         EXIT DISPLAY
# 
#      ON ACTION carry_delivery                #No.FUN-6C0050 轉出貨單
#         LET g_action_choice="carry_delivery"
#         EXIT DISPLAY
# 
#      ON ACTION gpm_show
#         LET g_action_choice="gpm_show"
#         EXIT DISPLAY
# 
#      ON ACTION gpm_query
#         LET g_action_choice="gpm_query"
#         EXIT DISPLAY
#      ON ACTION qry_lot
#         LET g_action_choice="qry_lot"
#         EXIT DISPLAY
#      ON ACTION gen_transfer_note
#         LET g_action_choice="gen_transfer_note"
#         EXIT DISPLAY
# 
##@    ON ACTION 領料產生                                                                                                            
#      ON ACTION gen_mat_wtdw                                                                                                        
#         LET g_action_choice="gen_mat_wtdw"                                                                                         
#         EXIT DISPLAY                                                                                                               
##@    ON ACTION 領料維護                                                                                                            
#      ON ACTION maint_mat_wtdw                                                                                                      
#         LET g_action_choice="maint_mat_wtdw"                                                                                       
#         EXIT DISPLAY                                                                                                               
#
#      #No.FUN-A80026  --Begin
##@    ON ACTION 产生应付帐款
#      ON ACTION gen_ap
#         LET g_action_choice="gen_ap"
#         EXIT DISPLAY                                                                                                               
#      #No.FUN-A80026  --End  
# 
#      &include "qry_string.4gl"
# 
#   END DISPLAY
#FUN-B30170 mark --end------------------------------
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
FUNCTION t720_rvu111()
DEFINE l_pmaacti          LIKE pma_file.pmaacti
DEFINE l_pma02            LIKE pma_file.pma02
 
   LET g_errno = ' '
   SELECT pma02,pmaacti INTO l_pma02,l_pmaacti FROM pma_file WHERE pma01 = g_rvu.rvu111
   
   CASE
      WHEN SQLCA.SQLCODE = 100 LET g_errno = 100
      WHEN l_pmaacti = 'N'     LET g_errno = 9028
      OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
                               DISPLAY l_pma02 TO pma02
   END CASE
END FUNCTION
FUNCTION t720_rvu112()
DEFINE l_pnz02            LIKE pnz_file.pnz02
 
   LET g_errno = ' '
   SELECT pnz02 INTO l_pnz02 FROM pnz_file WHERE pnz01 = g_rvu.rvu112
   
   CASE
      WHEN SQLCA.SQLCODE = 100 LET g_errno = 100
      OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
                               DISPLAY l_pnz02 TO pnz02
   END CASE
END FUNCTION
FUNCTION t720_rvu113()
DEFINE l_aziacti          LIKE azi_file.aziacti
 
   LET g_errno = ' '
   SELECT aziacti INTO l_aziacti FROM azi_file WHERE azi01 = g_rvu.rvu113
   
   CASE
      WHEN SQLCA.SQLCODE = 100 LET g_errno = 100
      WHEN l_aziacti = 'N'     LET g_errno = 9028
      OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
                               
   END CASE
   IF cl_null(g_errno) THEN
      IF g_rvu.rvu113 = g_aza.aza17 THEN
         LET g_rvu.rvu114 = 1
      ELSE
         CALL s_curr3(g_rvu.rvu113,g_rvu.rvu03,g_sma.sma904)
            RETURNING g_rvu.rvu114
      END IF
      DISPLAY BY NAME g_rvu.rvu114
   END IF
END FUNCTION
FUNCTION t720_rvu115()
DEFINE l_gecacti          LIKE gec_file.gecacti
DEFINE l_gec07            LIKE gec_file.gec07        #MOD-AC0414 
   LET g_errno = ' '
#   SELECT gec04,gecacti INTO g_rvu.rvu12,l_gecacti FROM gec_file                #MOD-AC0414
   SELECT gec04,gec07,gecacti INTO g_rvu.rvu12,l_gec07,l_gecacti FROM gec_file   #MOD-AC0414
       WHERE gec01 = g_rvu.rvu115 AND gec011 = '1'
   
   CASE
      WHEN SQLCA.SQLCODE = 100 LET g_errno = 100
      WHEN l_gecacti = 'N'     LET g_errno = 9028
      OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
                               DISPLAY BY NAME g_rvu.rvu12    
                               DISPLAY l_gec07 TO gec07     #MOD-AC0414            
   END CASE
END FUNCTION
FUNCTION t720_rvu02()      #驗收單號
   DEFINE l_pmc03   LIKE pmc_file.pmc03     #簡稱
   DEFINE l_rvb04   LIKE rvb_file.rvb04
 
   LET g_errno = ' '
 
   #供應廠商,採購性質,廠商簡稱
   SELECT rva05,rva10,pmc03,rva06
     INTO g_rvu.rvu04,g_rvu.rvu08,g_rvu.rvu05,g_rva06
     FROM rva_file, OUTER pmc_file
#TQC-A60132 --Begin
#   WHERE rva01 = g_rvu.rvu02
#     AND pmc01 = rva05
#     AND rvaconf = 'Y'
    WHERE rva_file.rva01 = g_rvu.rvu02
      AND pmc_file.pmc01 = rva_file.rva05
      AND rva_file.rvaconf = 'Y'
#TQC-A60132 --End
 
   IF SQLCA.sqlcode THEN
      LET g_errno = 'apm-142'               #TQC-B10197 'mfg3070'->'apm-142'
      RETURN
   END IF
   IF g_rvu.rvu00 = '3' THEN
      SELECT rva111,rva112,rva113,rva114,rva115,rva116
         INTO g_rvu.rvu111,g_rvu.rvu112,g_rvu.rvu113,g_rvu.rvu114,
             g_rvu.rvu115,g_rvu.rvu12
        FROM rva_file WHERE rva01 = g_rvu.rvu02
      IF SQLCA.SQLCODE THEN
         LET g_errno = SQLCA.SQLCODE
         RETURN
      END IF
   END IF
 
   IF g_argv3 != 'TAP' THEN  #no.4061 02/02/01
      IF g_argv1 != '3' THEN #MOD-D20003 add
         IF g_rvu.rvu08 = 'TAP' OR g_rvu.rvu08 = 'TRI' THEN  #MOD-880191 add TRI
            LET g_errno = 'apm-016'
         END IF
     #MOD-D20134 add start -----
      ELSE
         IF g_rvu.rvu08 = 'TAP' OR g_rvu.rvu08 = 'TRI' THEN
            LET g_rvu.rvu08 = 'REG'
         END IF
     #MOD-D20134 add end   -----
      END IF #MOD-D20003 add
   END IF

  #FUN-BA0013 mark str -----  
  #IF g_rvu.rvu00 = "3" AND g_rvu.rvu08 = "SUB" THEN
  #   LET g_errno="apm-032"
  #END IF
  #FUN-BA0013 mark end -----

  #FUN-BA0013 add str -----
   IF g_rvu.rvu00 = "3" THEN
      IF g_argv3 = 'SUB' THEN
         IF g_rvu.rvu08 <> 'SUB' THEN
            LET g_errno="apm732"
         END IF
      ELSE
        #IF g_rvu.rvu08 <> 'SUB' THEN #MOD-BA0048 mark
         IF g_rvu.rvu08 = 'SUB' THEN  #MOD-BA0048
            LET g_errno="apm-032"
         END IF
      END IF
   END IF
  #FUN-BA0013 add end -----
   #MOD-BB0126 add str-------
   #IF g_rvu.rvu00 = "1" THEN                     #MOD-BC0155 mark
   IF g_rvu.rvu00 = "1" OR g_rvu.rvu00 = "2" THEN #MOD-BC0155 add
      IF g_argv3 = 'SUB' THEN
         IF g_rvu.rvu08 <> 'SUB' THEN
            LET g_errno="apm1064"
         END IF
      ELSE
         IF g_rvu.rvu08 = 'SUB' THEN
            LET g_errno="apm1065"
         END IF
      END IF
   END IF
   #MOD-BB0126 add end-------
 
   IF NOT cl_null(g_errno) THEN
      RETURN
   END IF
 
   IF g_argv3 = 'TAP' THEN   #no.4061
      CALL t720_chk_poz()
   END IF
 
   IF cl_null(g_errno) THEN
      DISPLAY BY NAME g_rvu.rvu04
      DISPLAY BY NAME g_rvu.rvu08
      DISPLAY BY NAME g_rvu.rvu05
      CALL s_prtype(g_rvu.rvu08) RETURNING l_str
   END IF
 
END FUNCTION
 

FUNCTION t720_rvv05(p_cmd)     # 驗收單項次
  DEFINE l_pmn041 LIKE pmn_file.pmn041       #品名規格
  DEFINE l_ima35  LIKE ima_file.ima35        #倉庫
  DEFINE l_ima36  LIKE ima_file.ima36        #儲位
  DEFINE l_rvb36  LIKE rvb_file.rvb36        #倉庫
  DEFINE l_rvb37  LIKE rvb_file.rvb37        #儲位
  DEFINE l_rvb38  LIKE rvb_file.rvb38        #批號
  DEFINE l_rvv17_3 LIKE rvv_file.rvv17
  DEFINE l_rvv17_2 LIKE rvv_file.rvv17       #No.9786
  DEFINE l_rvv17_3_other LIKE rvv_file.rvv17 #No.9786
  DEFINE l_rvv17_2_other LIKE rvv_file.rvv17 #No.9786
  DEFINE l_rvv82_2_other LIKE rvv_file.rvv82 #MOD-760028 add
  DEFINE l_rvv85_2_other LIKE rvv_file.rvv85 #MOD-760028 add
  DEFINE l_rvv82_2       LIKE rvv_file.rvv82 #MOD-760028 add
  DEFINE l_rvv85_2       LIKE rvv_file.rvv85 #MOD-760028 add
  DEFINE l_rvv82_1       LIKE rvv_file.rvv82 #MOD-760028 add
  DEFINE l_rvv85_1       LIKE rvv_file.rvv85 #MOD-760028 add
  DEFINE l_okqty_rvv82   LIKE rvv_file.rvv82 #MOD-760028 add
  DEFINE l_okqty_rvv85   LIKE rvv_file.rvv85 #MOD-760028 add
  DEFINE l_qcs32         LIKE qcs_file.qcs32 #MOD-760028 add
  DEFINE l_qcs35         LIKE qcs_file.qcs35 #MOD-760028 add
  DEFINE l_qcs38         LIKE qcs_file.qcs38 #MOD-760028 add
  DEFINE l_qcs41         LIKE qcs_file.qcs41 #MOD-760028 add
  DEFINE l_rvb331        LIKE rvb_file.rvb331    #No.MOD-760028 add
  DEFINE l_rvb332        LIKE rvb_file.rvb332    #No.MOD-760028 add
  DEFINE l_rvb33   LIKE rvb_file.rvb33
  DEFINE l_rvb39   LIKE rvb_file.rvb39
  DEFINE l_rvb40   LIKE rvb_file.rvb40
  DEFINE l_ima906  LIKE ima_file.ima906
  DEFINE l_ima44   LIKE ima_file.ima44
  DEFINE l_img09   LIKE img_file.img09
  DEFINE l_rvv80   LIKE rvv_file.rvv80
  DEFINE l_rvv81   LIKE rvv_file.rvv81
  DEFINE l_rvv82   LIKE rvv_file.rvv82
  DEFINE l_rvv83   LIKE rvv_file.rvv83
  DEFINE l_rvv84   LIKE rvv_file.rvv84
  DEFINE l_rvv85   LIKE rvv_file.rvv85
  DEFINE l_rvv86   LIKE rvv_file.rvv86
  DEFINE l_rvv87   LIKE rvv_file.rvv87
  DEFINE l_pmm43   LIKE pmm_file.pmm43  #FUN-5B0144 add
  DEFINE l_okqty   LIKE rvb_file.rvb33       #No.MOD-660040 add
  DEFINE p_cmd    LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
  DEFINE l_qcs091  LIKE qcs_file.qcs091       #No.TQC-6B0079 add
  DEFINE l_qcs22   LIKE qcs_file.qcs22        #No.TQC-6B0079 add
  DEFINE l_i       LIKE type_file.num5        #No.MOD-740049 add
  DEFINE l_n       LIKE type_file.num5  #No.FUN-850100
  DEFINE l_rvb42   LIKE rvb_file.rvb42  #NO.FUN-960130
  DEFINE l_rvb43   LIKE rvb_file.rvb43  #NO.FUN-960130
  DEFINE l_rvb44   LIKE rvb_file.rvb44  #NO.FUN-960130
  DEFINE l_rvb45   LIKE rvb_file.rvb45  #NO.FUN-960130
  DEFINE l_rtz07   LIKE rtz_file.rtz07   #NO.FUN-960130
  DEFINE l_rvv17_in      LIKE rvv_file.rvv17   #MOD-B90019 add
  #FUN-C20002--start add-------------------------------------------
  DEFINE l_ima154      LIKE ima_file.ima154
  DEFINE l_rcj03       LIKE rcj_file.rcj03
  DEFINE l_rtz08       LIKE rtz_file.rtz08
  #FUN-C20002--end add---------------------------------------------  

  DEFINE l_rva113        LIKE rva_file.rva113   ##No.FUN-940083
  DEFINE l_rvv17_tol     LIKE rvv_file.rvv17    #FUN-D20022 add
 
  LET g_errno = " "
  SELECT rva00 INTO g_rva00 FROM rva_file WHERE rva01 = g_rvu.rvu02  #No.FUN-940083
  IF g_rvu.rvu02 != g_rvu_t.rvu02 OR g_rvv[l_ac].rvv05 != g_rvv_t.rvv05 OR
     cl_null(g_rvv_t.rvv05) THEN
 
       CASE
        WHEN g_rvu.rvu00='1' OR g_rvu.rvu00='3' #入庫
          SELECT rvb03,rvb04,rvb05,rvb919,rvb31,rvb34,rvb35,rvb89,rvb30,rvb10,rvb33,  #FUN-9A0068 add rvb89  #FUN-A80150 add rvb919
                 rvb331,rvb332,     #No.MOD-760028 add
                 rvb36,rvb37,rvb38, #BugNo:5611
                 rvb39,rvb40,       #no.7143
                 rvb25,             #no.A050
                 rvb80,rvb81,rvb82,rvb83,rvb84,rvb85,rvb86,rvb87,rvb10t,       
                 rvb930  #FUN-670051
                 ,rvbud04,rvbud13   #add by guanyao160621
            INTO g_rvv[l_ac].rvv37,g_rvv[l_ac].rvv36,
                 g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv919,g_inqty,g_rvv[l_ac].rvv18,     #FUN-A80150 add rvv919
                 g_rvv[l_ac].rvv25,g_rvv[l_ac].rvv89,l_rvb30,b_rvv.rvv38,l_rvb33,    #FUN-9A0068 add rvv89
                 l_rvb331,l_rvb332,              #No.MOD-760028 add
                 l_rvb36,l_rvb37,l_rvb38,
                 l_rvb39,l_rvb40,   #no.7143
                 g_rvv[l_ac].rvv41, #no.A050
                 l_rvv80,l_rvv81,l_rvv82,l_rvv83,l_rvv84,l_rvv85,
                 l_rvv86,l_rvv87,b_rvv.rvv38t,                               
                 g_rvv[l_ac].rvv930  #FUN-670051
                 ,g_rvv[l_ac].rvvud02,g_rvv[l_ac].rvvud13  #add by guanyao160621
            FROM rvb_file
           WHERE rvb01=g_rvu.rvu02 AND rvb02=g_rvv[l_ac].rvv05 #驗收單號,項次
          IF SQLCA.sqlcode THEN LET g_errno='mfg3070' RETURN END IF
          IF cl_null(g_inqty) THEN LET g_inqty=0 END IF           #TQC-C20117 add      
          IF g_inqty <= 0 AND g_rvu.rvu00='1' THEN                                 
             LET g_errno='mfg3173' RETURN
          END IF
          IF l_rvb30 <= 0 AND g_rvu.rvu00='3' THEN
             LET g_errno='apm-260' RETURN
          END IF
          
          CALL t720_get_pmm43(l_ac)
          IF cl_null(g_rvv[l_ac].pmm43) THEN
             SELECT gec01,gec04 
               INTO g_rvv[l_ac].pmm21,g_rvv[l_ac].pmm43 
               FROM gec_file,pmc_file 
              WHERE gec01 = pmc47
                AND pmc01 = g_rvu.rvu04 
                AND gec011='1'  #進項
          END IF
          
       #FUN-B40083 --begin
          IF NOT cl_null(g_rvv[l_ac].rvv36) AND NOT cl_null(g_rvv[l_ac].rvv37) THEN
             SELECT pmn123 INTO g_rvv[l_ac].pmn123 FROM pmn_file
              WHERE pmn01 = g_rvv[l_ac].rvv36
                AND pmn02 = g_rvv[l_ac].rvv37
             IF NOT cl_null(g_rvv[l_ac].pmn123) THEN
                SELECT mse02 INTO g_rvv[l_ac].mse02
                  FROM mse_file WHERE mse01= g_rvv[l_ac].pmn123
             ELSE
                LET g_rvv[l_ac].pmn123 = ''
                LET g_rvv[l_ac].mse02 = ''
             END IF
          END IF
       #FUN-B40083 --end
          
          IF g_rvu.rvu00='1' THEN
             IF g_sma.sma886[6]='Y' AND l_rvb39='Y' AND l_rvb40 IS NULL THEN
                LET g_errno='apm-264'
                RETURN  #No.TQC-7C0020
             END IF
             IF l_rvb39 = 'Y' THEN      #-->檢驗  no.7143
                LET g_rvv[l_ac].rvv17 = l_rvb33
             ELSE
                LET g_rvv[l_ac].rvv17 = g_inqty
             END IF
             #FUN-D20022 -- add start --
             SELECT SUM(rvv17) INTO l_rvv17_tol FROM rvv_file,rvu_file
              WHERE rvv04 = g_rvu.rvu02 AND rvv05 = g_rvv[l_ac].rvv05
               AND rvu00='1' AND rvv01=rvu01 AND rvuconf <> 'X'
             IF cl_null(l_rvv17_tol) THEN LET l_rvv17_tol = 0 END IF
             IF l_rvb33 - l_rvv17_tol <= 0 THEN
                LET g_errno='apm1105' RETURN
             ELSE
                LET g_rvv[l_ac].rvv17 =  l_rvb33 - l_rvv17_tol
             END IF
             #FUN-D20022 -- add end --
             SELECT SUM(rvv82),SUM(rvv85) 
                   INTO l_rvv82_1,l_rvv85_1 
                   FROM rvu_file,rvv_file 
                  WHERE rvu01=rvv01 
                    AND rvuconf<>'X'
                    AND rvuacti='Y'
                    AND rvv04=g_rvu.rvu02
                    AND rvv05=g_rvv[l_ac].rvv05
                    #AND rvv82 IS NOT NULL   #MOD-AB0254
                    #AND rvv85 IS NOT NULL   #MOD-AB0254
             
             IF cl_null(l_rvv82_1) THEN
                LET l_rvv82_1=0
             END IF
             IF cl_null(l_rvv85_1) THEN
                LET l_rvv85_1=0
             END IF
 
            LET l_rvv82=l_rvb331-l_rvv82_1 
            LET l_rvv85=l_rvb332-l_rvv85_1 
          ELSE
             SELECT SUM(rvv17) INTO l_rvv17_3 FROM rvv_file,rvu_file #MOD-680094 add ruv_file
               WHERE rvv04=g_rvu.rvu02 AND rvv05=g_rvv[l_ac].rvv05
                 AND rvv03='3' AND rvv01!=g_rvu.rvu01
                 AND rvv01=rvu01                 #MOD-680094 add
                 AND rvuconf != 'X'              #MOD-680094 add
             IF cl_null(l_rvv17_3) THEN LET l_rvv17_3=0 END IF
             SELECT SUM(rvv17) INTO l_rvv17_3_other FROM rvv_file,rvu_file #MOD-680094 add rvu_file
               WHERE rvv04=g_rvu.rvu02 AND rvv05=g_rvv[l_ac].rvv05
                 AND rvv03='3'
                 AND rvv01=g_rvu.rvu01
                 AND rvv02 !=g_rvv[l_ac].rvv02
                 AND rvv01=rvu01                 #MOD-680094 add
                 AND rvuconf != 'X'              #MOD-680094 add
             IF cl_null(l_rvv17_3_other) THEN LET l_rvv17_3_other=0 END IF
             IF g_rvu.rvu116 = '3' THEN 
                LET g_rvv[l_ac].rvv17 = 0 
               #MOD-D30109 add start -----
                LET g_rvv[l_ac].rvv82 = 0 
                LET g_rvv[l_ac].rvv85 = 0 
                LET g_rvv[l_ac].rvv87 = 0 
               #MOD-D30109 add end   -----
                CALL cl_set_comp_entry("rvv17",FALSE)
             #FUN-D60130 -----Begin------
                IF g_rvu.rvu00 = '3' AND g_argv1 = '3' AND g_argv3 = 'SUB' THEN #委外倉退
                   CALL cl_set_comp_entry("rvv17",TRUE)
                   LET g_rvv[l_ac].rvv17 = l_rvb30 - l_rvv17_3 - l_rvv17_3_other
                END IF
             #FUN-D60130 -----End--------
             ELSE       
                LET g_rvv[l_ac].rvv17 = l_rvb30-l_rvv17_3-l_rvv17_3_other
            END IF 
          END IF

        WHEN g_rvu.rvu00='2'     #驗退
         SELECT rvb03,rvb04,rvb05,rvb919,rvb30,rvb34,rvb35,rvb89,rvb07,rvb10,rvb25,  #FUN-9A0068 add rvb89  #FUN-A80150 add rvb919
                rvb80,rvb81,rvb82,rvb83,rvb84,rvb85,rvb86,rvb87,
                 rvb10t,rvb39,rvb40 #MOD-550053 add rvb39,rvb40,
                 rvb930  #FUN-670051
                 ,rvbud04,rvbud13   #add by guanyao160621
          INTO g_rvv[l_ac].rvv37,g_rvv[l_ac].rvv36,
               g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv919,g_rvv[l_ac].rvv17,g_rvv[l_ac].rvv18,   #FUN-A80150 add rvv919
               g_rvv[l_ac].rvv25,g_rvv[l_ac].rvv89,g_inqty,b_rvv.rvv38,   #FUN-9A0068 add rvv89
               g_rvv[l_ac].rvv41,  #no.A050
               l_rvv80,l_rvv81,l_rvv82,l_rvv83,l_rvv84,l_rvv85,
                l_rvv86,l_rvv87,b_rvv.rvv38t,l_rvb39,l_rvb40, #MOD-550053 add rvb39,rvb40
                g_rvv[l_ac].rvv930  #FUN-670051
                ,g_rvv[l_ac].rvvud02,g_rvv[l_ac].rvvud13  #add by guanyao160621
          FROM rvb_file
         WHERE rvb01=g_rvu.rvu02 AND rvb02=g_rvv[l_ac].rvv05
         
         IF SQLCA.sqlcode THEN LET g_errno='mfg3070' RETURN END IF

         IF g_sma.sma886[6]='Y' AND l_rvb39='Y' AND l_rvb40 IS NULL THEN    #TQC-980195   #MOD-A90083 取消mark
         #IF g_sma.sma886[6]='Y' AND (l_rvb39='N' OR l_rvb40 IS NULL) THEN   #TQC-980195   #MOD-A90083 mark
            #本單需檢驗, 但尚未執行品管確認!
            LET g_errno='apm-264'
            RETURN     #No.TQC-7C0020
         END IF
         
          CALL t720_get_pmm43(l_ac)
         IF cl_null(g_rvv[l_ac].pmm43) THEN
            SELECT gec01,gec04 
              INTO g_rvv[l_ac].pmm21,g_rvv[l_ac].pmm43 
              FROM gec_file,pmc_file 
             WHERE gec01 = pmc47
               AND pmc01 = g_rvu.rvu04 
               AND gec011='1'  #進項
         END IF
        #FUN-B40083 --begin
         IF NOT cl_null(g_rvv[l_ac].rvv36) AND NOT cl_null(g_rvv[l_ac].rvv37) THEN
            SELECT pmn123 INTO g_rvv[l_ac].pmn123 FROM pmn_file
             WHERE pmn01 = g_rvv[l_ac].rvv36
               AND pmn02 = g_rvv[l_ac].rvv37
            IF NOT cl_null(g_rvv[l_ac].pmn123) THEN
               SELECT mse02 INTO g_rvv[l_ac].mse02
                 FROM mse_file WHERE mse01= g_rvv[l_ac].pmn123
            ELSE
               LET g_rvv[l_ac].pmn123 = ''
               LET g_rvv[l_ac].mse02 = ''
            END IF
         END IF
       #FUN-B40083 --end
         SELECT SUM(rvv17),SUM(rvv82),SUM(rvv85) 
          #INTO l_rvv17_2,l_rvv82_2,l_rvv85_2 FROM rvv_file          #MOD-C40018 mark
           INTO l_rvv17_2,l_rvv82_2,l_rvv85_2 FROM rvv_file,rvu_file #MOD-C40018
            WHERE rvv04=g_rvu.rvu02 AND rvv05=g_rvv[l_ac].rvv05
             AND rvu01 = rvv01   #MOD-C40018 add
             AND rvuconf <> 'X'  #MOD-C40018 add
             AND rvv03='2'
             AND rvv01!=g_rvu.rvu01
         IF cl_null(l_rvv17_2) THEN LET l_rvv17_2=0 END IF
         SELECT SUM(rvv82),SUM(rvv85) 
          #INTO l_okqty_rvv82,l_okqty_rvv85 FROM rvv_file          #MOD-C40018 mark
           INTO l_okqty_rvv82,l_okqty_rvv85 FROM rvv_file,rvu_file #MOD-C40018
            WHERE rvv04=g_rvu.rvu02 AND rvv05=g_rvv[l_ac].rvv05
             AND rvu01 = rvv01   #MOD-C40018 add
             AND rvuconf <> 'X'  #MOD-C40018 add
             AND rvv03='1'
 
         IF cl_null(l_okqty_rvv82) THEN LET l_okqty_rvv82=0 END IF
         IF cl_null(l_okqty_rvv85) THEN LET l_okqty_rvv85=0 END IF
         IF cl_null(l_rvv82_2) THEN LET l_rvv82_2=0 END IF
         IF cl_null(l_rvv85_2) THEN LET l_rvv85_2=0 END IF
         SELECT SUM(rvv17),SUM(rvv82),SUM(rvv85) 
          #INTO l_rvv17_2_other,l_rvv82_2_other,l_rvv85_2_other FROM rvv_file          #MOD-C40018 mark
           INTO l_rvv17_2_other,l_rvv82_2_other,l_rvv85_2_other FROM rvv_file,rvu_file #MOD-C40018
            WHERE rvv04=g_rvu.rvu02 AND rvv05=g_rvv[l_ac].rvv05
             AND rvu01 = rvv01   #MOD-C40018 add
             AND rvuconf <> 'X'  #MOD-C40018 add
             AND rvv03='2'
             AND rvv01=g_rvu.rvu01
             AND rvv02 != g_rvv[l_ac].rvv02
         IF cl_null(l_rvv17_2_other) THEN LET l_rvv17_2_other=0 END IF
         IF cl_null(l_rvv82_2_other) THEN LET l_rvv82_2_other=0 END IF
         IF cl_null(l_rvv85_2_other) THEN LET l_rvv85_2_other=0 END IF
 
         SELECT rvb33 INTO l_okqty FROM rvb_file,rva_file
            WHERE rvb01=g_rvu.rvu02 AND rvb02=g_rvv[l_ac].rvv05
                  AND rvb01=rva01
                  AND rvaconf !='X' #作廢資料要剔除 MODNO:3816
         IF cl_null(l_okqty) THEN LET l_okqty=0 END IF

#MOD-B90019 -- begin --
         SELECT SUM(rvv17) INTO l_rvv17_in FROM rvu_file,rvv_file
            WHERE rvv04 = g_rvu.rvu02
              AND rvv05 = g_rvv[l_ac].rvv05
              AND rvv01 = rvu01
              AND rvu00 = '1'
              AND rvuconf != 'X'
         IF cl_null(l_rvv17_in) THEN LET l_rvv17_in = 0 END IF
#MOD-B90019 -- end --
 
        IF l_rvb39='Y' THEN
           SELECT SUM(qcs091),SUM(qcs22),SUM(qcs32),
                  SUM(qcs35),SUM(qcs38),SUM(qcs41) 
             INTO l_qcs091,l_qcs22,l_qcs32,l_qcs35,l_qcs38,l_qcs41
              FROM qcs_file WHERE  qcs01 = g_rvu.rvu02
              AND qcs02 = g_rvv[l_ac].rvv05
              AND qcs14 = 'Y'               #確認否
             #AND qcs09 = '1'               #合格否    #No.MOD-7A0072 add
 
           IF cl_null(l_qcs32) THEN LET l_qcs32 = 0 END IF
           IF cl_null(l_qcs35) THEN LET l_qcs35 = 0 END IF
           IF cl_null(l_qcs38) THEN LET l_qcs38 = 0 END IF
           IF cl_null(l_qcs41) THEN LET l_qcs41 = 0 END IF
           IF cl_null(l_qcs091) THEN LET l_qcs091 = 0 END IF
           IF cl_null(l_qcs22)  THEN LET l_qcs22 = 0 END IF
           IF g_sma.sma886[8,8] = 'Y'  THEN      #MOD-830209 add
              #若勾選允收數與IQC勾稽 , 驗退量以qcs_file為主
              #若不勾選允收數與IQC勾稽 , 驗退量以rvb_file為主
              LET g_rvv[l_ac].rvv17=l_qcs22-l_rvv17_2-l_rvv17_2_other-l_qcs091
              LET l_rvv82=l_qcs32-l_rvv82_2-l_rvv82_2_other-l_qcs38
              LET l_rvv85=l_qcs35-l_rvv85_2-l_rvv85_2_other-l_qcs41
           ELSE
             #LET g_rvv[l_ac].rvv17=g_inqty-l_rvv17_2-l_rvv17_2_other-g_rvv[l_ac].rvv17   #MOD-B90019 mark
              LET g_rvv[l_ac].rvv17=g_inqty-l_rvv17_2-l_rvv17_2_other-l_rvv17_in          #MOD-B90019
              LET l_rvv82=l_rvv82-l_rvv82_2-l_rvv82_2_other-l_okqty_rvv82
              LET l_rvv85=l_rvv85-l_rvv85_2-l_rvv85_2_other-l_okqty_rvv85
           END IF   
        ELSE
          #LET g_rvv[l_ac].rvv17=g_inqty-l_rvv17_2-l_rvv17_2_other-g_rvv[l_ac].rvv17      #MOD-B90019 mark
           LET g_rvv[l_ac].rvv17=g_inqty-l_rvv17_2-l_rvv17_2_other-l_rvv17_in             #MOD-B90019
           LET l_rvv82=l_rvv82-l_rvv82_2-l_rvv82_2_other-l_okqty_rvv82
           LET l_rvv85=l_rvv85-l_rvv85_2-l_rvv85_2_other-l_okqty_rvv85
        END IF
 
        IF g_rvv[l_ac].rvv17 = 0 THEN
           LET g_errno='apm-129'
           RETURN       #No.TQC-7C0020
        END IF
        IF cl_null(l_rvv82) OR l_rvv82 < 0 THEN
           LET l_rvv82 = 0
        END IF
        IF cl_null(l_rvv85) OR l_rvv85 < 0 THEN
           LET l_rvv85 = 0
        END IF
 
 
      END CASE
      LET b_rvv.rvv17 = g_rvv[l_ac].rvv17    #No.+089 010430 add by linda 一行
      LET b_rvv.rvv930= g_rvv[l_ac].rvv930  #FUN-670051
      CALL t720_set_rvv930(g_rvv[l_ac].rvv930) RETURNING g_rvv[l_ac].gem02a #FUN-670051
      LET l_ima906=NULL
      SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01=g_rvv[l_ac].rvv31
      IF g_sma.sma115 = 'Y' THEN
         LET g_rvv[l_ac].rvv80 = l_rvv80
         LET g_rvv[l_ac].rvv81 = l_rvv81
         LET g_rvv[l_ac].rvv82 = l_rvv82
         LET g_rvv[l_ac].rvv83 = l_rvv83
         LET g_rvv[l_ac].rvv84 = l_rvv84
         LET g_rvv[l_ac].rvv85 = l_rvv85
         LET b_rvv.rvv80 = g_rvv[l_ac].rvv80
         LET b_rvv.rvv81 = g_rvv[l_ac].rvv81
         LET b_rvv.rvv81 = g_rvv[l_ac].rvv82
         LET b_rvv.rvv83 = g_rvv[l_ac].rvv83
         LET b_rvv.rvv84 = g_rvv[l_ac].rvv84
         LET b_rvv.rvv81 = g_rvv[l_ac].rvv85
      END IF
      LET g_rvv[l_ac].rvv86 = l_rvv86
      LET g_rvv[l_ac].rvv87 = l_rvv87
      LET b_rvv.rvv86 = g_rvv[l_ac].rvv86
      LET b_rvv.rvv87 = g_rvv[l_ac].rvv87
       IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN                        
          SELECT imx00,imx01,imx02,imx03,imx04,imx05,                           
                 imx06,imx07,imx08,imx09,imx10                                  
           INTO g_rvv[l_ac].att00, g_rvv[l_ac].att01, g_rvv[l_ac].att02,        
                g_rvv[l_ac].att03, g_rvv[l_ac].att04, g_rvv[l_ac].att05,        
                g_rvv[l_ac].att06, g_rvv[l_ac].att07, g_rvv[l_ac].att08,        
                g_rvv[l_ac].att09, g_rvv[l_ac].att10                            
           FROM imx_file                                                        
            WHERE imx000 = g_rvv[l_ac].rvv31                                    
          #賦值所有屬性                                                         
          LET g_rvv[l_ac].att01_c = g_rvv[l_ac].att01                           
          LET g_rvv[l_ac].att02_c = g_rvv[l_ac].att02                           
          LET g_rvv[l_ac].att03_c = g_rvv[l_ac].att03                           
          LET g_rvv[l_ac].att04_c = g_rvv[l_ac].att04                           
          LET g_rvv[l_ac].att05_c = g_rvv[l_ac].att05                           
          LET g_rvv[l_ac].att06_c = g_rvv[l_ac].att06                           
          LET g_rvv[l_ac].att07_c = g_rvv[l_ac].att07                           
          LET g_rvv[l_ac].att08_c = g_rvv[l_ac].att08                           
          LET g_rvv[l_ac].att09_c = g_rvv[l_ac].att09                           
          LET g_rvv[l_ac].att10_c = g_rvv[l_ac].att10                           
       END IF                                                                   
   END IF
     ###### 01/11/18 Tommy 考慮多單位的換算(pmn09)
    IF g_rva00 = '1' THEN
       SELECT pmn041,pmn07,pmn09,pmn38
          INTO l_pmn041,g_rvv[l_ac].rvv35,g_rvv[l_ac].rvv35_fac,g_pmn38
         FROM pmn_file  #品名規格,單位,轉換率,可用否
        WHERE pmn01 = g_rvv[l_ac].rvv36 AND pmn02 = g_rvv[l_ac].rvv37
     ELSE
        LET l_pmn041 = g_rvv[l_ac].rvv031
        SELECT rvb90,rvb90_fac INTO g_rvv[l_ac].rvv35,g_rvv[l_ac].rvv35_fac
             FROM rvb_file WHERE rvb01 = g_rvu.rvu02 AND rvb02 = g_rvv[l_ac].rvv05
        LET g_pmn38 = 'Y'
     END IF
     IF SQLCA.sqlcode THEN
        LET l_pmn041 =' '
        LET g_rvv[l_ac].rvv35=' '
        LET g_rvv[l_ac].rvv35_fac=1
     END IF
     LET l_ima906=NULL
     SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01=g_rvv[l_ac].rvv31
    # 計價單位不受多單位參數的影響
     LET b_rvv.rvv86=g_rvv[l_ac].rvv86
     LET b_rvv.rvv87=g_rvv[l_ac].rvv87
     IF g_rvv[l_ac].rvv31[1,4] = 'MISC' THEN   #料件編號
        LET g_rvv[l_ac].rvv031 = l_pmn041  #品名規格
     ELSE
       SELECT ima02,ima021    #品名規格
         INTO g_rvv[l_ac].rvv031,g_rvv[l_ac].ima021
         FROM ima_file
        WHERE ima01 = g_rvv[l_ac].rvv31
       #將此段搬入下面處理更為合理！ by chenl
        IF p_cmd='a' OR g_rvv_t.rvv31!=g_rvv[l_ac].rvv31 THEN
           #FUN-C20002--start add-----------------------------------------------
           IF g_azw.azw04 = '2' THEN
              SELECT ima154 INTO l_ima154
                  FROM ima_file
                 WHERE ima01 = g_rvv[l_ac].rvv31
              
              IF l_ima154 = 'Y' AND g_rvv[l_ac].rvv31[1,4] <> 'MISC' THEN
                 SELECT rcj03 INTO l_rcj03
                   FROM rcj_file
                  WHERE rcj00 = '0'
                 #FUN-C90049 mark begin---
                 #SELECT rtz07,rtz08 INTO l_rtz07,l_rtz08
                 #  FROM rtz_file
                 # WHERE rtz01 = g_plant
                 #FUN-C90049 mark end-----
                 CALL s_get_defstore(g_plant,g_rvv[l_ac].rvv31) RETURNING l_rtz07,l_rtz08      #fun-c90049 add 
                 IF l_rcj03 = '1' THEN
                    LET g_rvv[l_ac].rvv32 = l_rtz07 
                 ELSE
                    LET g_rvv[l_ac].rvv32 = l_rtz08 
                 END IF
              END IF     
           ELSE
              IF NOT cl_null(l_rvb36) THEN
                 LET g_rvv[l_ac].rvv32=l_rvb36
              ELSE
                 SELECT ima35 INTO l_ima35
                   FROM ima_file
                  WHERE ima01 = g_rvv[l_ac].rvv31
                 LET g_rvv[l_ac].rvv32=l_ima35
              END IF   
           END IF    
           #FUN-C20002--end add-------------------------------------------------    
            IF NOT cl_null(l_rvb36) THEN #BugNo:5611
                #LET g_rvv[l_ac].rvv32=l_rvb36          #FUN-C20002 mark
                LET g_rvv[l_ac].rvv33=l_rvb37
                LET g_rvv[l_ac].rvv34=l_rvb38
            ELSE
                LET l_ima35 = NULL
                LET l_ima36 = NULL
                SELECT ima02,ima35,ima36,ima021    #品名,倉庫,儲位
                  INTO g_rvv[l_ac].rvv031,l_ima35,l_ima36,g_rvv[l_ac].ima021
                  FROM ima_file
                 WHERE ima01 = g_rvv[l_ac].rvv31
                IF SQLCA.sqlcode THEN LET g_rvv[l_ac].rvv031 = ' ' END IF
                IF cl_null(l_ima35) THEN LET l_ima35=' ' END IF #MOD-810200 
                IF cl_null(l_ima36) THEN LET l_ima36=' ' END IF #MOD-810200 
                #No.FUN-AA0049--begin
                #IF NOT s_chk_ware(l_ima35) THEN  #No.FUN-AB0058 mark  
                #   LET l_ima35=' '               #No.FUN-AB0058 mark
                #   LET l_ima36=' '               #No.FUN-AB0058 mark
                #END IF                           #No.FUN-ABOo58 mark 
                #No.FUN-AA0049--end                     
                #LET g_rvv[l_ac].rvv32=l_ima35   #FUN-C20002 mark
                LET g_rvv[l_ac].rvv33=l_ima36
                LET g_rvv[l_ac].rvv34=' '
                IF g_azw.azw04 = '2' THEN  
                   #FUN-C90049 mark begin---
                   #SELECT rtz07 INTO l_rtz07 FROM rtz_file #MOD-9C0016 del rtz08
                   # WHERE rtz01 = g_rvu.rvuplant  
                   #FUN-C90049 mark end------
                   CALL s_get_coststore(g_rvu.rvuplant,g_rvv[l_ac].rvv31) RETURNING l_rtz07     #FUN-C90049 add
                  #FUN-B40098 Begin---
                  #IF g_rvu.rvu21 = '3' THEN  #FUN-B60150 MARK
                   IF g_rvu.rvu21 = '3' OR (g_rvu.rvu27 = '2' AND g_sma.sma146 = '2') THEN #FUN-B60150 ADD
                      #FUN-C90049 mark beign---
                      #SELECT rtz08 INTO l_rtz07 FROM rtz_file
                      # WHERE rtz01 = g_rvu.rvuplant
                      #FUN-C90049 mark end-----
                      CALL s_get_noncoststore(g_rvu.rvuplant,g_rvv[l_ac].rvv31) RETURNING l_rtz07     #FUN-C90049 add
                   END IF
                  #FUN-B40098 End-----
                   LET g_rvv[l_ac].rvv32 = l_rtz07
                END IF
            END IF
        END IF
     END IF
    IF NOT cl_null(g_rvv[l_ac].rvv32) THEN
       SELECT img09 INTO l_img09 FROM img_file
              WHERE img01 = g_rvv[l_ac].rvv31
              AND img02 = g_rvv[l_ac].rvv32
              AND img03 = g_rvv[l_ac].rvv33
              AND img04 = g_rvv[l_ac].rvv34
 
       CALL s_umfchk(g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv35,l_img09)
       RETURNING l_i,g_rvv[l_ac].rvv35_fac
       IF  l_i = 1 THEN
           ### ------單位無法轉換--------####
           CALL cl_err('rvv35/img09: ','abm-731',1)
           LET g_rvv[l_ac].rvv35_fac=1
       END IF
    ELSE
       IF NOT (g_rvu.rvu00='3' AND g_rvv[l_ac].rvv17=0) THEN   #MOD-A40166
          LET g_rvv[l_ac].rvv32 = NULL
          LET g_rvv[l_ac].rvv33 = NULL
          LET g_rvv[l_ac].rvv34 = NULL
          LET g_rvv[l_ac].rvv35_fac=1
          LET g_errno = 'apm-259'
       END IF   #MOD-A40166
    END IF
 
     IF b_rvv.rvv87>=0 THEN    #No.9786   #MOD-AA0165 rvv17-->rvv87
        #FUN-5B0144 add IF ELSE
        IF b_rvv.rvv87 > 0 THEN   #MOD-AA0165 rvv17-->rvv87
           CALL t720sub_rvv38(g_rvv[l_ac].rvv36,b_rvv.rvv38,b_rvv.rvv38t,g_rvu.rvu04,g_rvu.rvu01)  #TQC-C30225 add
                   RETURNING b_rvv.rvv38,b_rvv.rvv38t 
           LET b_rvv.rvv39=b_rvv.rvv87*b_rvv.rvv38   #MOD-AA0165 rvv17-->rvv87
           LET b_rvv.rvv39t=b_rvv.rvv87*b_rvv.rvv38t  #No.FUN-540027   #MOD-AA0165 rvv17-->rvv87
        ELSE
           CALL t720_pmm43(b_rvv.rvv36) RETURNING l_pmm43
           LET b_rvv.rvv39t = b_rvv.rvv39 * (1+l_pmm43/100)
        END IF
             #MOD-C40047 str mark----
             #LET t_azi04=''  #No.CHI-6A0004
             #IF g_rva00 = '1' AND g_rvu.rvu00 = '3' THEN
             #   SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = g_rvu.rvu113
             #END IF
             #IF g_rva00 = '1' AND g_rvu.rvu00 <> '3' THEN
             #   SELECT azi04 INTO t_azi04  #No.CHI-6A0004
             #      FROM pmm_file,azi_file
             #     WHERE pmm22=azi01
             #       AND pmm01 = g_rvv[l_ac].rvv36 AND pmm18 <> 'X'
             #END IF
             #IF g_rva00 = '2' THEN
             #   SELECT rva113 INTO l_rva113 FROM rva_file WHERE rva01 = g_rvu02
             #   SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = l_rva113
             #END IF
             #  IF b_rvv.rvv87 = 0 OR cl_null(t_azi04) THEN      #No.MOD-8A0183
             #     SELECT azi04 INTO t_azi04
             #       FROM pmc_file,azi_file
             #      WHERE pmc22=azi01
             #        AND pmc01 = g_rvu.rvu04
             #  END IF
             #IF cl_null(t_azi04) THEN LET t_azi04=0 END IF  #No.CHI-6A0004
             #MOD-C40047 end mark----
              CALL t720_get_azi()                            #MOD-C40047 add
              CALL cl_digcut(b_rvv.rvv39,t_azi04)  #No.CHI-6A0004
                                RETURNING b_rvv.rvv39
              CALL cl_digcut(b_rvv.rvv39t,t_azi04)   #No.CHI-6A0004
                                RETURNING b_rvv.rvv39t  #No.FUN-540027
              #CALL t720sub_rvv39(g_rvv[l_ac].rvv36,b_rvv.rvv39,b_rvv.rvv39t,g_rvu.rvu04,g_rvu.rvu02) #FUN-A10130 #MOD-850300 b_rvv.rvv36->g_rvv[l_ac].rvv36 #MOD-BC0262 mark
              CALL t720sub_rvv39(g_rvv[l_ac].rvv36,b_rvv.rvv39,b_rvv.rvv39t,g_rvu.rvu04,g_rvu.rvu01) #MOD-BC0262 add
                   RETURNING b_rvv.rvv39,b_rvv.rvv39t
     END IF
     #-----MOD-AA0165---------
     ##No.FUN-540027  用計價數量計算
     #IF b_rvv.rvv87>=0 THEN    #No.9786
     #   IF b_rvv.rvv87 > 0 THEN
     #      LET b_rvv.rvv39=b_rvv.rvv87*b_rvv.rvv38
     #      LET b_rvv.rvv39t=b_rvv.rvv87*b_rvv.rvv38t
     #   ELSE
     #      CALL t720_pmm43(b_rvv.rvv36) RETURNING l_pmm43
     #      LET b_rvv.rvv39t = b_rvv.rvv39 * (1+l_pmm43/100)
     #   END IF
     #         LET t_azi04=''   #No.CHI-6A0004
     #         IF g_rva00 = '1' AND g_rvu.rvu00 = '3' THEN
     #            SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = g_rvu.rvu113
     #         END IF
     #         IF g_rva00 = '1' AND g_rvu.rvu00 <> '3' THEN
     #            SELECT azi04 INTO t_azi04  #No.CHI-6A0004
     #               FROM pmm_file,azi_file
     #              WHERE pmm22=azi01
     #                AND pmm01 = g_rvv[l_ac].rvv36 AND pmm18 <> 'X'
     #         END IF
     #         IF g_rva00 = '2' THEN
     #            SELECT rva113 INTO l_rva113 FROM rva_file WHERE rva01 = g_rvu02
     #            SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = l_rva113
     #         END IF
     #          IF cl_null(t_azi04) THEN                                                                                             
     #             SELECT azi04 INTO t_azi04                                                                                         
     #               FROM pmc_file,azi_file                                                                                          
     #              WHERE pmc22=azi01                                                                                                
     #                AND pmc01 = g_rvu.rvu04                                                                                        
     #          END IF                                                                                                               
     #         IF cl_null(t_azi04) THEN LET t_azi04=0 END IF   #No.CHI-6A0004
     #         CALL cl_digcut(b_rvv.rvv39,t_azi04)  #No.CHI-6A0004
     #                           RETURNING b_rvv.rvv39
     #         CALL cl_digcut(b_rvv.rvv39t,t_azi04)  #No.CHI-6A0004
     #                           RETURNING b_rvv.rvv39t  #No.FUN-540027
     #         CALL t720sub_rvv39(g_rvv[l_ac].rvv36,b_rvv.rvv39,b_rvv.rvv39t,g_rvu.rvu04,g_rvu.rvu02) #FUN-A10130 #MOD-850300 b_rvv.rvv36->g_rvv[l_ac].rvv36 
     #              RETURNING b_rvv.rvv39,b_rvv.rvv39t
     #END IF
     #-----END MOD-AA0165-----
        LET g_rvv[l_ac].rvv38=b_rvv.rvv38
        LET g_rvv[l_ac].rvv39=b_rvv.rvv39
        LET g_rvv[l_ac].rvv38t=b_rvv.rvv38t    #No.FUN-610018
        LET g_rvv[l_ac].rvv39t=b_rvv.rvv39t    #No.FUN-610018
 
     IF g_rvu.rvu00='2' THEN
        LET b_rvv.rvv32=NULL LET g_rvv[l_ac].rvv32=NULL
        LET b_rvv.rvv33=NULL LET g_rvv[l_ac].rvv33=NULL
        LET b_rvv.rvv34=NULL LET g_rvv[l_ac].rvv34=NULL
     END IF
 
     SELECT ima918,ima921 INTO g_ima918,g_ima921 
       FROM ima_file
      WHERE ima01 = g_rvv[l_ac].rvv31
        AND imaacti = "Y"
     
     IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
        IF g_sma.sma90 = "Y" THEN #MOD-C30074 add
           SELECT COUNT(*) INTO l_n FROM rvbs_file
            WHERE rvbs00 = g_prog
              AND rvbs01 = g_rvu.rvu01
              AND rvbs02 = g_rvv[l_ac].rvv02
           IF l_n = 0 THEN
              CALL t720sub_ins_rvbs(g_prog,g_rvu.rvu01,g_rvv[l_ac].rvv02,
                                 g_rvu.rvu02,g_rvv[l_ac].rvv05,g_rvv[l_ac].rvv31,
                                 g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv33,g_rvv[l_ac].rvv34,g_rvu.rvu02) #FUN-A10130
           END IF
        END IF #MOD-C30074 add
     END IF
 
     LET l_rvb42 = ''
     LET l_rvb43 = ''
     LET l_rvb44 = ''
     LET l_rvb45 = ''
 
     SELECT rvb42,rvb43,rvb44,rvb45 INTO l_rvb42,l_rvb43,l_rvb44,l_rvb45
         FROM rvb_file WHERE rvb01=g_rvu.rvu02 AND rvb02=g_rvv[l_ac].rvv05
 
     LET g_rvv[l_ac].rvv10 = l_rvb42
     LET g_rvv[l_ac].rvv11 = l_rvb43
     LET g_rvv[l_ac].rvv12 = l_rvb44
     LET g_rvv[l_ac].rvv13 = l_rvb45
END FUNCTION
 
FUNCTION t720_rvu07(p_cmd)    #人員
         DEFINE p_cmd       LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
                l_gen02     LIKE gen_file.gen02,
                l_genacti   LIKE gen_file.genacti
 
    LET g_errno = ' '
    SELECT gen02,genacti INTO l_gen02,l_genacti
            FROM gen_file WHERE gen01 = g_rvu.rvu07
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1312'
                                         LET l_gen02 = NULL
               WHEN l_genacti='N' LET g_errno = '9028'
               OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
          DISPLAY l_gen02 TO FORMONLY.gen02
END FUNCTION
 
FUNCTION t720_rvu06(p_cmd)    #部門
         DEFINE p_cmd       LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
                l_gem02     LIKE gem_file.gem02,
                l_gemacti   LIKE gem_file.gemacti
 
    LET g_errno = ' '
    SELECT gem02,gemacti INTO l_gem02,l_gemacti FROM gem_file
          WHERE gem01 = g_rvu.rvu06
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3097'
                                         LET l_gem02 = NULL
               WHEN l_gemacti='N' LET g_errno = '9028'
               OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
          DISPLAY l_gem02 TO FORMONLY.gem02
END FUNCTION

#FUNCTION t720_x()        #FUN-D20025
FUNCTION t720_x(p_type)   #FUN-D20025
   DEFINE l_rvaconf LIKE rva_file.rvaconf   #No.MOD-590539
   DEFINE p_type    LIKE type_file.num5     #FUN-D20025
   DEFINE l_flag    LIKE type_file.chr1     #FUN-D20025
   #FUN-BC0104---add---str---
   DEFINE  l_rvv02         LIKE rvv_file.rvv02,
           l_rvv45         LIKE rvv_file.rvv45,
           l_rvv05         LIKE rvv_file.rvv05,
           l_rvv46         LIKE rvv_file.rvv46,
           l_rvv47         LIKE rvv_file.rvv47,
           l_qcl05         LIKE qcl_file.qcl05,
           l_rvv17         LIKE rvv_file.rvv17,
           l_rvv87         LIKE rvv_file.rvv87,
           l_qty           LIKE rvv_file.rvv17
    #FUN-BC0104---add---end--- 
   DEFINE l_type   LIKE type_file.chr1      #FUN-C40016
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_rvu.rvu01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_rvu.* FROM rvu_file
    WHERE rvu01=g_rvu.rvu01
 
   IF g_rvu.rvuconf = 'Y' THEN
      CALL cl_err('',9023,0)
      RETURN
   END IF

  #FUN-A60009  add str ---
   IF g_rvu.rvu17 matches '[Ss]' THEN
      CALL cl_err('','apm-030',0)
      RETURN
   END IF
   IF g_rvu.rvu17 = "1" THEN
      CALL cl_err('','mfg3168',0)
      RETURN
   END IF
  #FUN-A60009  add end ---
  
   #FUN-D20025--add--str--
   IF p_type = 1 THEN 
      IF g_rvu.rvuconf='X' THEN RETURN END IF
   ELSE
      IF g_rvu.rvuconf<>'X' THEN RETURN END IF
   END IF
   #FUN-D20025--add--end--
 
   BEGIN WORK
   LET g_success='Y'
 
   OPEN t720_cl USING g_rvu.rvu01
   IF STATUS THEN
      CALL cl_err("OPEN t720_cl:", STATUS, 1)
      CLOSE t720_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t720_cl INTO g_rvu.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rvu.rvu01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t720_cl
      ROLLBACK WORK
      RETURN
   END IF
 
  #IF cl_void(0,0,g_rvu.rvuconf) THEN  #FUN-D20025
   IF p_type = 1 THEN LET l_flag = 'N' ELSE LET l_flag = 'X' END IF  #FUN-D20025
   IF cl_void(0,0,l_flag) THEN         #FUN-D20025
      LET g_chr=g_rvu.rvuconf
     #IF g_rvu.rvuconf ='N' THEN   #FUN-D20025
      IF p_type = 1 THEN           #FUN-D20025
         LET g_rvu.rvuconf='X'
         LET g_rvu.rvu17 = '9'              #FUN-A60009 add
      ELSE
         IF NOT cl_null(g_rvu.rvu02) THEN   #MOD-880022
            SELECT rvaconf INTO l_rvaconf
              FROM rva_file
             WHERE rva01 = g_rvu.rvu02
            IF l_rvaconf = "Y" THEN
               LET g_rvu.rvuconf='N'
               LET g_rvu.rvu17 = '0'        #FUN-A60009 add
            ELSE
               CALL cl_err("g_rvu.rvu01","apm-034",0)
               LET g_success="N"
               LET g_rvu.rvu17 = '0'        #FUN-A60009 add
            END IF
         ELSE   #MOD-880022
            LET g_rvu.rvuconf = 'N'   #MOD-880022
            LET g_rvu.rvu17 = '0'        #FUN-A60009 add
         END IF   #MOD-880022
      END IF
      UPDATE rvu_file SET rvuconf = g_rvu.rvuconf,
                          rvu17   = g_rvu.rvu17,     #FUN-A60009 add
                          rvupos = '1', #NO.FUN-960130 #NO.FUN-B50042                          
                          rvumodu = g_user,  
                          rvudate = TODAY                            
       WHERE rvu01 = g_rvu.rvu01
      IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","rvu_file",g_rvu.rvu01,"",STATUS,"","upd rvuconf:",1) #No.FUN-660129
         LET g_success = 'N'
      #END IF  #FUN-BC0104 mark
      #FUN-C40016----------mark-----------str----------
      ##FUN-BC0104---add---str---
      #ELSE
      #   DECLARE rvv02_cur1 CURSOR FOR SELECT rvv05,rvv45,rvv46,rvv47,rvv17,rvv87
      #                              FROM rvv_file
      #                              WHERE rvv01 = g_rvu.rvu01
      #   FOREACH rvv02_cur1 INTO l_rvv05,l_rvv45,l_rvv46,l_rvv47,l_rvv17,l_rvv87
      #      LET l_qcl05 = ''
      #      LET l_qty = 0
      #      SELECT qcl05 INTO l_qcl05 FROM qcl_file WHERE qcl01 = l_rvv46
      #      IF NOT cl_null(l_qcl05) THEN
      #         IF l_qcl05 = '1' THEN
      #            LET l_qty=l_rvv87
      #         ELSE
      #            LET l_qty=l_rvv17
      #         END IF
      #         UPDATE qco_file SET qco20 = qco20-l_qty WHERE qco01 = g_rvu.rvu02
      #                                                   AND qco02 = l_rvv05 
      #                                                   AND qco04 = l_rvv47
      #                                                   AND qco05 = l_rvv45
      #         IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      #            CALL cl_err3("upd","qco_file",g_rvu.rvu01,"",STATUS,"","upd qco20:",1)
      #            LET g_success = 'N'
      #         END IF
      #      END IF           
      #   END FOREACH
      #   UPDATE rvv_file SET rvv45 = '',rvv46 = '',rvv47 = ''
      #       WHERE rvv01 = g_rvu.rvu01
      #   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      #      CALL cl_err3("upd","rvu_file",g_rvu.rvu01,"",STATUS,"","upd rvv45,rvv46,rvv47:",1)
      #      LET g_success = 'N'
      #   END IF
      ##FUN-BC0104---add---str---
      #FUN-C40016----------mark-----------end----------
      #FUN-C40016-----add-----str-----
      ELSE
         DECLARE rvv02_cur1 CURSOR FOR SELECT rvv05,rvv45,rvv46,rvv47
                                         FROM rvv_file
                                        WHERE rvv01 = g_rvu.rvu01
         FOREACH rvv02_cur1 INTO l_rvv05,l_rvv45,l_rvv46,l_rvv47
            SELECT qcl05 INTO l_qcl05 FROM qcl_file WHERE qcl01 = l_rvv46
            IF NOT cl_null(l_qcl05) THEN
               IF l_qcl05 = '1' THEN LET l_type = '5' ELSE LET l_type = '1' END IF
               IF NOT s_iqctype_upd_qco20(g_rvu.rvu02,l_rvv05,l_rvv45,l_rvv47,l_type) THEN
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF
            END IF
         END FOREACH
      #FUN-C40016-----add-----end-----
      END IF
   END IF
 
   CLOSE t720_cl
 
   IF g_success='Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_rvu.rvu01,'V')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT rvuconf,rvu17                          #FUN-A60009 add:rvu17
     INTO g_rvu.rvuconf,g_rvu.rvu17              #FUN-A60009 add:g_rvu.rvu17 
     FROM rvu_file
    WHERE rvu01 = g_rvu.rvu01
   DISPLAY BY NAME g_rvu.rvuconf,g_rvu.rvu17     #FUN-A60009 add:g_rvu.rvu17
   
 
  #FUN-C30140--mod---str--
  #IF g_rvu.rvuconf = 'X' THEN
  #   LET g_chr = 'Y'
  #ELSE
  #   LET g_chr = 'N'
  #END IF
 
  #CALL cl_set_field_pic(g_rvu.rvuconf,"","","",g_chr,"")
   CALL t720_pic()
  #FUN-C30140--mod---end--
 
END FUNCTION
 
#***************************#
#    取  消  確  認         #
FUNCTION t720_z()
   DEFINE l_pmn41  LIKE pmn_file.pmn41,  #W/O
          l_pmn18  LIKE pmn_file.pmn18,
          l_pmn32  LIKE pmn_file.pmn32,
          l_pmn43  LIKE pmn_file.pmn43   #製程序
   DEFINE l_rvv    RECORD LIKE rvv_file.*,
          l_sfb04  LIKE sfb_file.sfb04,
          l_cnt    LIKE type_file.num5    #No.FUN-680136 SMALLINT
   DEFINE l_cmd    LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(300)
   DEFINE l_rvb04  LIKE rvb_file.rvb04
   DEFINE l_poz011 LIKE poz_file.poz011
   DEFINE l_n      LIKE type_file.num5    #No.FUN-680136 SMALLINT
   DEFINE l_rvv36  LIKE rvv_file.rvv36
   DEFINE l_rvv37  LIKE rvv_file.rvv37
   DEFINE l_pmn16  LIKE pmn_file.pmn16
   DEFINE l_ebocode VARCHAR(1)            #eB-Online回傳值  #NO.FUN-960116 add
   DEFINE l_rvu17  LIKE rvu_file.rvu17    #FUN-A60009 add
   DEFINE l_cnt1   LIKE type_file.num5    #FUN-C70093 
   DEFINE l_flag2  LIKE type_file.chr1    #MOD-CC0212 add
   DEFINE l_rvucont LIKE rvu_file.rvucont #FUN-D20059 
   DEFINE l_gen02       LIKE gen_file.gen02          #FUN-D20059 Add
   DEFINE l_x       LIKE type_file.num5  #add by guanyao160707
   DEFINE l_rvv05_1 LIKE rvv_file.rvv05  #add by guanyao160707
 
   IF s_shut(0) THEN RETURN END IF

   IF g_argv1='Z' THEN
      SELECT rvu_file.* INTO g_rvu.*
        FROM rvu_file
       WHERE rvu01 = g_argv2
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("sel","rvu_file","","",SQLCA.sqlcode,"","sel rvu",1)
         RETURN
      END IF
   END IF

   #No.FUN-A50071 -----start---------    
    #-->POS單號不為空時不可取消確認
    IF NOT cl_null(g_rvu.rvu25) THEN
       CALL cl_err(' ','axm-743',0)
       RETURN
    END IF 
    #No.FUN-A50071 -----end---------

   IF cl_null(g_rvu.rvu01) THEN CALL cl_err('',-400,0) RETURN END IF

   #FUN-C70093---ADD--STR
   #已存在分攤單據中，不可取消確認
   SELECT COUNT(*) INTO l_cnt1 FROM aqc_file WHERE aqc02=g_rvu.rvu01
   IF l_cnt1>0  THEN
      CALL cl_err('','apm0007',0)
      RETURN
   END IF
   #FUN-C70093---ADD--END

    IF NOT cl_null(g_rvu.rvu16) THEN                                                                                                
      CALL cl_err('','apm-578',0)                                                                                                   
      RETURN                                                                                                                        
    END IF                                                                                                                          
   SELECT COUNT(*) INTO g_cnt FROM rvw_file
    WHERE rvw08 =g_rvu.rvu01
   IF g_cnt > 0 THEN
      CALL cl_err(g_rvu.rvu01,'apm-987',1)
      RETURN
   END IF
   SELECT * INTO g_rvu.* FROM rvu_file
    WHERE rvu01=g_rvu.rvu01
 
   IF g_rvu.rvuconf = 'N' THEN CALL cl_err('','9002',0) RETURN END IF
 
   IF g_rvu.rvuconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
 
  #FUN-A60009  add str ---
   LET l_rvu17 = g_rvu.rvu17

   IF g_rvu.rvu17 matches '[Ss]' THEN
      CALL cl_err('','apm-030',0)
      RETURN
   END IF
  #FUN-A60009  add end --

  #str-------add by guanyao160707
   IF g_rvu.rvu08 = 'SUB' THEN 
      DECLARE t720_rvv01 CURSOR FOR SELECT rvv05 FROM rvv_file WHERE rvv01 = g_rvu.rvu01
      LET l_rvv05_1 = ''
      FOREACH t720_rvv01 INTO l_rvv05_1
         LET l_x = 0
         SELECT COUNT(*) INTO l_x FROM tc_sfp_file WHERE tc_sfpconf = 'Y' AND tc_sfp11 = g_rvu.rvu02 AND tc_sfp12 = l_rvv05_1
         IF l_x >0 THEN 
            CALL cl_err(g_rvu.rvu02||l_rvv05_1,'cpm-039',0)
            RETURN 
         END IF 
      END FOREACH 
   END IF 
  #end-------add by guanyao160707

  SELECT COUNT(*) INTO l_cnt FROM oga_file
   WHERE oga914 = g_rvu.rvu01
  IF l_cnt > 0 THEN CALL cl_err('','apm-901',0) RETURN END IF
 
   IF g_sma.sma53 IS NOT NULL AND g_rvu.rvu03 <= g_sma.sma53 THEN
      CALL cl_err('','mfg9999',0) RETURN
   END IF
 
   IF NOT cl_null(g_rvu.rvu09) THEN
      CALL cl_err ('','apm-725',0)
      RETURN
   END IF
 
   DECLARE t720_rvv37 CURSOR FOR
    SELECT rvv36,rvv37 FROM rvv_file WHERE rvv01 = g_rvu.rvu01
 
   FOREACH t720_rvv37 INTO l_rvv36,l_rvv37
      IF STATUS THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,0)
         RETURN
      END IF
 
      SELECT pmn16 INTO l_pmn16 FROM pmn_file 
       WHERE pmn01 = l_rvv36
         AND pmn02 = l_rvv37
 
      IF g_rva00 = '1' THEN
         SELECT pmn16 INTO l_pmn16 FROM pmn_file 
            WHERE pmn01 = l_rvv36
              AND pmn02 = l_rvv37
         IF l_pmn16 != '2' AND g_rvu.rvu00<>'3' THEN   #MOD-910091   
            #CALL cl_err('','mfg3166',1)   #CHI-B10047
            CALL cl_err_msg("","apm1054",l_rvv36 CLIPPED|| "|" || l_rvv37 CLIPPED,0)   #CHI-B10047
            RETURN
         END IF
      END IF
   END FOREACH
 
   SELECT COUNT(*) INTO l_n FROM cop_file
    WHERE cop01 = g_rvu.rvu02
   IF l_n > 0 THEN
      CALL cl_err(g_rvu.rvu02,'aco-031',0)
      RETURN
   END IF
 
   CALL s_yp(g_rvu.rvu03) RETURNING g_yy,g_mm
 
   IF (g_yy*12+g_mm)>(g_sma.sma51*12+g_sma.sma52) THEN #不可大於現行年月
      CALL cl_err('','mfg6091',0)
   END IF
 
   #-- 若為三角貿易單據則非來源單據不可取消確認  no.4061
   IF g_rvu.rvu08 ='TAP' OR g_rvu.rvu08 = 'TRI' THEN  #TQC-820011 modify add 'TRI'
      CALL t720_chk_poz()
      IF NOT cl_null(g_errno) THEN
         CALL cl_err('',g_errno,1) RETURN
      END IF
   END IF
 
   #----若為委外,則判斷是否為生產系統所產生之單據
   IF g_rvu.rvu08='SUB' THEN
      SELECT COUNT(*) INTO g_cnt FROM sfu_file
       WHERE sfu01=g_rvu.rvu01
      IF g_cnt>0 THEN CALL cl_err(g_rvu.rvu01,'apm-263',0) RETURN END IF
      LET l_cnt=0
      DECLARE t720_s2_chk CURSOR FOR
          SELECT * FROM rvv_file WHERE rvv01=g_rvu.rvu01
      FOREACH t720_s2_chk INTO l_rvv.*
         SELECT pmn41,pmn43,pmn18,pmn32          #No.MOD-5C0165
           INTO l_pmn41,l_pmn43,l_pmn18,l_pmn32  #No.MOD-5C0165
           FROM pmn_file
          WHERE pmn01 = l_rvv.rvv36 AND pmn02 = l_rvv.rvv37
         IF STATUS THEN
            CALL cl_err3("sel","pmn_file",l_rvv.rvv36,l_rvv.rvv37,STATUS,"","sel pmn_file",1)  #No.FUN-660129
            LET l_cnt=1
            EXIT FOREACH
         END IF
         IF (NOT cl_null(l_pmn41) AND l_pmn43>0) OR   #W/O<>'' &製程序>0 #No.MOD-5C0165
            (NOT cl_null(l_pmn18) AND l_pmn32>0) THEN #RUN<>'' &製程序>0 #No.MOD-5C0165
            LET l_cnt=0
            SELECT COUNT(*) INTO l_cnt
              FROM shb_file
             WHERE shb14 = l_rvv.rvv01 AND shb15=l_rvv.rvv02
               AND shbconf = 'Y'       #FUN-A70095
            IF l_cnt > 0 THEN
               CALL cl_err(l_rvv.rvv02,'mfg-019',0)
               EXIT FOREACH
            END IF
         END IF
         IF NOT cl_null(l_pmn41) THEN
            SELECT sfb04 INTO l_sfb04 FROM sfb_file
             WHERE sfb01 = l_pmn41
            IF STATUS THEN
               LET l_cnt = 1
               CALL cl_err3("sel","sfb_file",l_pmn41,"",STATUS,"","sel pmn_file",1)  #No.FUN-660129
               EXIT FOREACH
            ELSE
               IF l_sfb04 = '8' THEN   #表己結案
                  LET l_cnt = 1
                  CALL cl_err(l_pmn41,'asf-716',0)
                  EXIT FOREACH
               END IF
            END IF
         END IF
      END FOREACH
      IF l_cnt > 0 THEN
         RETURN
      END IF
   END IF
 
  #判斷是否已有應付憑單存在
  LET l_cnt=0
  SELECT COUNT(*) INTO l_cnt
    FROM apa_file,apb_file
   WHERE apa01 = apb01
     AND apb21 = g_rvu.rvu01
     AND apa42 = 'N'   #No.MOD-8A0132 modify by liuxqa
  IF l_cnt > 0 THEN
     CALL cl_err(g_rvu.rvu01,'apm-881',1)
     RETURN
  END IF
  #判斷是否已有外購到單存在
  LET l_cnt=0
  SELECT COUNT(*) INTO l_cnt
    FROM alk_file,ale_file
   WHERE alk01 = ale01
     AND ale16 = g_rvu.rvu01
     AND alkfirm != 'X'
  IF l_cnt > 0 THEN
     CALL cl_err(g_rvu.rvu01,'apm-882',1)
     RETURN
  END IF
 
   IF NOT cl_null(g_rvu.rvu117) THEN                  #FUN-9A0068 add
      IF NOT cl_confirm('apm-106') THEN RETURN END IF #NO.FUN-940083
   ELSE                                               #FUN-9A0068
      IF NOT cl_confirm('axm-109') THEN RETURN END IF #NO.FUN-940083 #FUN-9A0068
   END IF                                             #No.FUN-940083
 
   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN t720_cl USING g_rvu.rvu01
   IF STATUS THEN
      CALL cl_err("OPEN t720_cl:", STATUS, 1)
      CLOSE t720_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t720_cl INTO g_rvu.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rvu.rvu01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t720_cl ROLLBACK WORK RETURN
   END IF
#------- UPDATE -------
   #退貨單號不為NULL
   LET g_rvu01 = g_rvu.rvu01
   SELECT * INTO g_rvu.* FROM rvu_file WHERE rvu01 = g_rvu01
   CALL t720_s2(g_rvu.rvu01)
   IF g_success = 'Y' THEN
      LET l_rvucont=TIME     #FUN-D20059
      UPDATE rvu_file SET rvuconf='N',rvu99='',rvu20='N',
                          rvu17='0',                        #FUN-A60009 add
                      #   rvucont='',rvupos='1', #NO.FUN-B50042    #FUN-D20059
                      #   rvucond = NULL,rvuconu = NULL            #FUN-D20059
                          rvucont= l_rvucont,                      #FUN-D20059
                          rvupos='1',                              #FUN-D20059
                          rvucond = g_today,                       #FUN-D20059
                          rvuconu = g_user                         #FUN-D20059
          WHERE rvu01=g_rvu.rvu01
      IF sqlca.sqlcode THEN
         CALL cl_err3("upd","rvu_file",g_rvu.rvu01,"",STATUS,"","upd rvu",1) #No.FUN-660129
         LET g_success='N'
      END IF
     #MESSAGE ""                    #FUN-A50001 mark
      CALL cl_msg("")               #FUN-A50001 add
      IF g_success = 'Y' THEN
      #FUN-D20059--str--
      #  LET g_rvu.rvucond = ''    #NO.FUN-960130
      #  LET g_rvu.rvuconu = ''    #NO.FUN-960130
      #  LET g_rvu.rvucont = ''    #NO.FUN-960130
         LET g_rvu.rvucond = g_today     
         LET g_rvu.rvuconu = g_user    
         LET g_rvu.rvucont = l_rvucont    
      #FUN-D20059--end--
         DECLARE t720_z_c CURSOR FOR
         SELECT * FROM rvv_file WHERE rvv01 = g_rvu.rvu01
         FOREACH t720_z_c INTO b_rvv.*
            
            IF NOT cl_null(g_rvu.rvu02) THEN    #MOD-690021 add
#退貨方式為價格折讓，則不做異動
                  CALL t720sub_u_rvb('z',g_rvu.*,b_rvv.*,g_argv1) #FUN-A10130
            END IF                              #MOD-690021 add

            IF g_rva00 = '1' THEN
                  CALL t720sub_u_pmn(b_rvv.*,'')  #FUN-A10130
            END IF
            IF g_rvu.rvu08='SUB' AND NOT cl_null(b_rvv.rvv18) THEN
               CALL s_updsfb117(b_rvv.rvv18)
               IF g_success='N' THEN
                  CALL cl_err('Update sfb',SQLCA.sqlcode,1)
                  EXIT FOREACH
               END IF
            END IF
         END FOREACH

         #DEV-D40015--add--begin
         #自動作廢barcode
         IF g_success='Y' AND g_prog = 'apmt720' AND g_aza.aza131 = 'Y' THEN
            CALL t720sub_barcode_z(g_rvu.rvu01,TRUE)
         END IF
         #DEV-D40015--add--end

         IF g_success = 'Y' THEN
            LET g_rvu.rvuconf='N' 
            LET g_rvu.rvu17 = '0'       #FUN-A60009 add
            COMMIT WORK
         ELSE
            LET g_rvu.rvuconf='Y' 
            LET g_rvu.rvu17 = l_rvu17   #FUN-A60009 add  #舊值
            ROLLBACK WORK
         END IF
      ELSE
         LET g_rvu.rvuconf='Y' 
         LET g_rvu.rvu17 = l_rvu17      #FUN-A60009 add  #舊值
         ROLLBACK WORK
      END IF
   ELSE
      LET g_rvu.rvuconf='Y' 
      LET g_rvu.rvu17 = l_rvu17         #FUN-A60009 add  #舊值
      ROLLBACK WORK
   END IF
   DISPLAY BY NAME g_rvu.rvuconf
   DISPLAY BY NAME g_rvu.rvu17          #FUN-A60009 add
   DISPLAY BY NAME g_rvu.rvucond,g_rvu.rvuconu,g_rvu.rvucont    #NO.FUN-960130  
#  DISPLAY '' TO FORMONLY.rvuconu_desc                          #NO.FUN-960130  #FUN-D20059
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_rvu.rvuconu          #FUN-D20059 Add
   DISPLAY l_gen02 TO FORMONLY.rvuconu_desc                                     #FUN-D20059
 
   LET g_rvu.rvu99 = ' '             #TQC-7C0146
   LET g_rvu.rvu20 = 'N'             #TQC-7C0146
   DISPLAY BY NAME g_rvu.rvu99       #TQC-7C0146
   DISPLAY BY NAME g_rvu.rvu20       #TQC-7C0146
   #CKP
  #FUN-C30140--mod---str--
  #IF g_rvu.rvuconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
  #CALL cl_set_field_pic(g_rvu.rvuconf,"","","",g_chr,"")
   CALL t720_pic()
  #FUN-C30140--mod---end--
 
   IF g_rvu.rvuconf = "Y" THEN
      DECLARE t720_s1_c2 CURSOR FOR SELECT * FROM rvv_file
        WHERE rvv01 = g_rvu.rvu01
 
      LET g_imm01 = ""
      LET g_success = "Y"
 
      CALL s_showmsg_init()   #No.FUN-6C0083
 
      BEGIN WORK
 
      FOREACH t720_s1_c2 INTO b_rvv.*
         IF STATUS THEN
            EXIT FOREACH
         END IF
 
         IF g_sma.sma115 = 'Y' THEN
            IF g_ima906 = '2' THEN  #子母單位
               LET g_unit_arr[1].unit= b_rvv.rvv80
               LET g_unit_arr[1].fac = b_rvv.rvv81
               LET g_unit_arr[1].qty = b_rvv.rvv82
               LET g_unit_arr[2].unit= b_rvv.rvv83
               LET g_unit_arr[2].fac = b_rvv.rvv84
               LET g_unit_arr[2].qty = b_rvv.rvv85
               CALL s_dismantle(g_rvu.rvu01,b_rvv.rvv02,g_rvu.rvu03,
                                b_rvv.rvv31,b_rvv.rvv32,b_rvv.rvv33,
                                b_rvv.rvv34,g_unit_arr,g_imm01)
                      RETURNING g_imm01
               IF g_success='N' THEN
                  LET g_totsuccess='N'
                  LET g_success="Y"
                  CONTINUE FOREACH   #No.FUN-6C0083
                  #RETURN
               END IF
            END IF
         END IF
      END FOREACH
 
      IF g_totsuccess="N" THEN
         LET g_success="N"
      END IF
 
      CALL s_showmsg()   #No.FUN-6C0083
 
      IF g_success = "Y" AND NOT cl_null(g_imm01) THEN
         COMMIT WORK
         LET g_msg="aimt324 '",g_imm01,"'"
         CALL cl_cmdrun_wait(g_msg)
      ELSE
         ROLLBACK WORK
      END IF
   END IF

   #DEV-D40015--mark--begin
   ##DEV-D30045--add--begin
   ##自動作廢barcode
   #IF g_success='Y' AND g_prog = 'apmt720' AND g_aza.aza131 = 'Y' THEN
   #   CALL t720sub_barcode_z(g_rvu.rvu01)
   #END IF
   ##DEV-D30045--add--end
   #DEV-D40015--mark--end
 
END FUNCTION
 
FUNCTION t720_s2(p_rvu01)
  DEFINE p_rvu01  LIKE rvu_file.rvu01,
         l_pmn18  LIKE pmn_file.pmn18,
         l_pmn32  LIKE pmn_file.pmn32,
         l_pmn41  LIKE pmn_file.pmn41,  #W/O
         l_pmn43  LIKE pmn_file.pmn43   #製程序
  DEFINE l_str    STRING                #FUN-A50001 add
 
  CALL s_showmsg_init()   #No.FUN-6C0083
 
  DECLARE t720_s2_c CURSOR FOR SELECT * FROM rvv_file WHERE rvv01=p_rvu01
  FOREACH t720_s2_c INTO b_rvv.*
      IF STATUS THEN EXIT FOREACH END IF

     #MESSAGE '_s2() read no:',b_rvv.rvv02 USING '#####&','--> parts: ', b_rvv.rvv31     #FUN-A50001
      LET l_str = '_s2() read no:',b_rvv.rvv02 USING '#####&','--> parts: ', b_rvv.rvv31 #FUN-A50001
      CALL cl_msg(l_str)                                                                 #FUN-A50001

      IF g_bgjob='N' OR cl_null(g_bgjob) THEN                                            #FUN-A50001
         CALL ui.Interface.refresh()
      END IF                                                                             #FUN-A50001
      IF cl_null(b_rvv.rvv04) AND g_rvu.rvu00='1' THEN CONTINUE FOREACH END IF
 
## 當為製程委外時不寫 tlf,不 update ima,img ---------
      IF g_rvu.rvu08='SUB' THEN
         SELECT pmn41,pmn43,pmn18,pmn32 INTO l_pmn41,l_pmn43,l_pmn18,l_pmn32 FROM pmn_file
            WHERE pmn01 = b_rvv.rvv36 AND pmn02 = b_rvv.rvv37
         IF STATUS THEN CALL cl_err('sel pmn_file',STATUS,0)
            LET g_success='N'
            RETURN
         END IF
         IF (NOT cl_null(l_pmn41) AND l_pmn43>0) OR   #W/O<>'' &製程序>0 #No.MOD-5C0165
            (NOT cl_null(l_pmn18) AND l_pmn32>0) THEN #RUN<>'' &製程序>0 #No.MOD-5C0165
            CONTINUE FOREACH
         END IF
      END IF
  #--- 若已請款匹配數量不為0則不可取消確認 ------------
      IF b_rvv.rvv23 != 0 THEN
         CALL cl_err(b_rvv.rvv01,'apm-256',1) LET g_success='N' EXIT FOREACH
      END IF
      IF g_rvu.rvu00 !='1' THEN
         SELECT ima25 INTO g_ima25 FROM ima_file #FUN-A10130
          WHERE ima01=b_rvv.rvv31
      END IF
      IF g_rvu.rvu00='1' THEN
         SELECT COUNT(*) INTO g_cnt FROM rvu_file,rvv_file
            WHERE rvv04=b_rvv.rvv04 AND rvv05=b_rvv.rvv05 AND rvv03='3'
             AND rvuconf != 'X'   #No.MOD-570098
             AND rvu01 = rvv01    #MOD-710017 add
         IF g_cnt>0 THEN
            CALL cl_err(b_rvv.rvv05,'apm-410',1) LET g_success='N' EXIT FOREACH
         END IF
      END IF
 
      CASE
        WHEN g_rvu.rvu00='1'
             CALL t720_t2()
        WHEN g_rvu.rvu00='2'
             CALL t720sub_uh(0,b_rvv.*,g_argv1,g_rvu.*)  #No.FUN-850100 #FUN-A10130
             CALL t720_log2()
        WHEN g_rvu.rvu00='3'
             CALL t720_bu2()
             CALL t720_log2()
      END CASE
      IF g_success='N' THEN
         LET g_totsuccess="N"
         LET g_success="Y"
         CONTINUE FOREACH   #No.FUN-6C0083
      END IF
   END FOREACH
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF

  #No:DEV-D30026--add--begin
   IF g_success ='Y' AND g_rvu.rvu00 ='1' AND g_aza.aza131='Y' THEN
      CALL t720sub_barcode(g_rvu.rvu01,-1,g_argv3)
   END IF
  #No:DEV-D30026--add--end

   CALL s_showmsg()   #No.FUN-6C0083
 
END FUNCTION
 
#--------- 入庫 UPDATE (取消確認)----------------
FUNCTION t720_t2()
  DEFINE l_pmn65  LIKE pmn_file.pmn65,
         l_img23  like img_file.img23,
         l_img24  like img_file.img24,
        #l_ima25  LIKE ima_file.ima25,  #FUN-A10130
         l_ima55  LIKE ima_file.ima55,
         l_ima906 LIKE ima_file.ima906, #No.FUN-540027
         l_ima907 LIKE ima_file.ima907, #No.FUN-540027
         l_sfb04  LIKE sfb_file.sfb04,  #No.MOD-810199 add
         l_cmd    LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(100)
         l_factor LIKE ima_file.ima31_fac,  #No.FUN-680136 DEC(16,8)
         l_cnt    LIKE type_file.num5   #MOD-990024
  DEFINE l_ima01  LIKE ima_file.ima01   #wujie 091021
  DEFINE la_tlf  DYNAMIC ARRAY OF RECORD LIKE tlf_file.*   #NO.FUN-8C0131 
  DEFINE l_sql   STRING                                    #NO.FUN-8C0131 
  DEFINE l_i     LIKE type_file.num5                       #NO.FUN-8C0131
  DEFINE l_pmn43 LIKE pmn_file.pmn43                       #No.FUN-A60076 
  DEFINE l_pmn012 LIKE pmn_file.pmn012                     #No.FUN-A60076
  DEFINE l_sfa12  LIKE sfa_file.sfa12                      #No.FUN-BB0086 
  DEFINE l_sfa06  LIKE sfa_file.sfa06                      #No.FUN-BB0086 
  DEFINE l_sfb93         LIKE sfb_file.sfb93   #TQC-C30193
  DEFINE l_tky_cnt       LIKE type_file.num5   #TQC-C30193
  DEFINE l_qty    LIKE type_file.num10         #FUN-C30307
  IF g_rva00 = '1' THEN
     SELECT pmn65 INTO l_pmn65 FROM pmn_file   #代買性質 1.一般採購 2.代買採購
       WHERE pmn01=b_rvv.rvv36 AND pmn02=b_rvv.rvv37
     IF l_pmn65 IS NULL THEN LET l_pmn65 = ' ' END IF
     IF l_pmn65 != '2' THEN
     #FUN-D30024 -----------Begin---------
     #  IF NOT s_stkminus(b_rvv.rvv31,b_rvv.rvv32,b_rvv.rvv33,b_rvv.rvv34, #MOD-6A0081 mod 第一個參數應傳料件編號rvv31
     #                    b_rvv.rvv17,b_rvv.rvv35_fac,g_rvu.rvu03,g_sma.sma894[6,6]) THEN
        IF NOT s_stkminus(b_rvv.rvv31,b_rvv.rvv32,b_rvv.rvv33,b_rvv.rvv34,
                          b_rvv.rvv17,b_rvv.rvv35_fac,g_rvu.rvu03) THEN
     #FUN-D30024 -----------End-----------
           LET g_success='N'
           RETURN
        END IF
     END IF
  END IF
 
  DECLARE t720_t2_c CURSOR FOR
   SELECT ROWID ,tlf_file.* FROM tlf_file
    WHERE tlf01=b_rvv.rvv31 AND tlf036=b_rvv.rvv01
      AND tlf037=b_rvv.rvv02 AND tlf03=50
      AND (tlf13 = 'apmt150' OR tlf13 = 'asft6201' OR tlf13 = 'apmt230')   #MOD-960033
  FOREACH t720_t2_c INTO g_rowid ,g_tlf.*
      IF STATUS THEN LET g_success='N' RETURN END IF
 
      MESSAGE '_s2() read tlf:',g_tlf.tlf036,' ',g_tlf.tlf037 CLIPPED
      CALL ui.Interface.refresh()
      IF g_rva00 = '1' THEN
         SELECT pmn65 INTO l_pmn65 FROM pmn_file   #代買性質 1.一般採購 2.代買採購
            WHERE pmn01=b_rvv.rvv36 AND pmn02=b_rvv.rvv37
         IF l_pmn65 IS NULL THEN LET l_pmn65 = ' ' END IF  #No.FUN-940083
         IF l_pmn65='1' THEN CALL t720_u_img() END IF
      ELSE
         CALL t720_u_img()
      END IF
      IF g_success='N' THEN RETURN END IF
      CALL t720_u_tlf()
  END FOREACH
 
  IF g_sma.sma115 = 'Y' THEN
     DECLARE t720_t2_du_c CURSOR FOR
      SELECT ROWID ,tlff_file.* FROM tlff_file
       WHERE tlff01=b_rvv.rvv31 AND tlff036=b_rvv.rvv01
         AND tlff037=b_rvv.rvv02 AND tlff03=50
         AND (tlff13 = 'apmt150' OR tlff13 = 'asft6201' OR tlff13 = 'apmt230')   #MOD-960033
     FOREACH t720_t2_du_c INTO g_rowid ,g_tlff.*
         IF STATUS THEN LET g_success='N' RETURN END IF
 
         LET l_ima906 = NULL
         LET l_ima907 = NULL
         SELECT ima906,ima907 INTO l_ima906,l_ima907 FROM ima_file
          WHERE ima01=g_tlff.tlff01
         IF cl_null(l_ima906) OR l_ima906 = '1' THEN CONTINUE FOREACH END IF
         MESSAGE '_s2() read tlff:',g_tlff.tlff036,' ',g_tlff.tlff037 CLIPPED
         CALL ui.Interface.refresh()
 
         IF g_rva00 = '1' THEN
            SELECT pmn65 INTO l_pmn65 FROM pmn_file   #代買性質 1.一般採購 2.代買採購
               WHERE pmn01=b_rvv.rvv36 AND pmn02=b_rvv.rvv37
 
            IF l_pmn65='1' THEN
               #參考單位的第一單位/單一單位的內容是不寫imgg_file的
               IF l_ima906 = '2' OR l_ima906 = '3' AND g_tlff.tlff11 = l_ima907 THEN
                  IF g_tlff.tlff219='1' THEN
                     CALL t720_u_imgg('2')
                  ELSE
                     CALL t720_u_imgg('1')
                  END IF
               END IF
            END IF
         #MOD-CB0222 -- add start --
         ELSE   #JIT收貨
            #參考單位的第一單位/單一單位的內容是不寫imgg_file的
            IF l_ima906 = '2' OR l_ima906 = '3' AND g_tlff.tlff11 = l_ima907 THEN
               IF g_tlff.tlff219='1' THEN
                  CALL t720_u_imgg('2')
               ELSE
                  CALL t720_u_imgg('1')
               END IF
            END IF
         #MOD-CB0222 -- add end --
         END IF
         IF g_success='N' THEN RETURN END IF
         IF l_ima906 MATCHES '[23]' THEN
            CALL t720_u_tlff()
         END IF
         IF g_success='N' THEN RETURN END IF
     END FOREACH
  END IF
 
      IF g_rvu.rvu08='SUB' AND NOT cl_null(b_rvv.rvv18) THEN
         INITIALIZE g_sfb.* TO NULL
         SELECT ima25,ima55 INTO g_ima25,l_ima55 FROM ima_file #FUN-A10130
          WHERE ima01 = b_rvv.rvv31
         CALL s_umfchk(b_rvv.rvv31,b_rvv.rvv35,l_ima55)
              RETURNING g_cnt,l_factor
         IF g_cnt THEN
            CALL cl_err('rvv35/ima55: ','abm-731',1)
            LET g_success = 'N'
            RETURN
         END IF
         SELECT * INTO g_sfb.* FROM sfb_file
          WHERE sfb01=b_rvv.rvv18   #單號
#           AND sfb02=7             #委外   #MOD-B70171 mark
        LET l_sfb04 = g_sfb.sfb04
        IF g_sfb.sfb04 = '7' THEN 
           LET l_cnt = 0
           SELECT COUNT(*) INTO l_cnt FROM rvu_file,rvv_file
             WHERE rvu01 = rvv01 
               AND rvuconf = 'Y'
               AND rvv01 <> b_rvv.rvv01
               AND rvv18 = b_rvv.rvv18 
           IF l_cnt = 0 THEN 
              LET l_sfb04 = '6'
           END IF
        END IF
         IF l_pmn65='1' THEN
            #TQC-C30193 --START-- TKY工單完工入庫數需加各站不良與報廢數
            IF s_industry('icd') THEN
               SELECT sfb93 INTO l_sfb93 FROM sfb_file 
                WHERE sfb01 = b_rvv.rvv36
               IF l_sfb93 = 'Y' THEN
                  CALL t720_tky_sfb09_2(b_rvv.rvv04)
                        RETURNING l_tky_cnt
                  LET b_rvv.rvv17 = b_rvv.rvv17 + l_tky_cnt 
               #FUN-C30307---begin
               ELSE   #非TKY工單,完工入庫數需該項次不良與報廢數
                  LET l_qty = 0
                  SELECT (rvbiicd06 + rvbiicd07) INTO l_qty
                   FROM rvb_file,rvbi_file
                   WHERE rvb01 = rvbi01 AND rvb02 = rvbi02  
                   AND rvb01 = b_rvv.rvv04 AND rvb02 = b_rvv.rvv05
                   LET b_rvv.rvv17 = b_rvv.rvv17 + l_qty  
               #FUN-C30307---end
               END IF  
            END IF 
            #TQC-C30193    END   
            UPDATE sfb_file SET sfb09 = sfb09 - (b_rvv.rvv17 * l_factor),
                                sfb04 = l_sfb04
             WHERE sfb01 = b_rvv.rvv18
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
               CALL cl_err3("upd","sfb_file",b_rvv.rvv18,"",SQLCA.sqlcode,"","Update sfb",1)  #No.FUN-660129
               LET g_success = 'N'
               RETURN
            END IF
            CALL t720_d_sfh(b_rvv.rvv02)
         ELSE
      #---代買入庫(update 已發料量)
            #FUN-A60076 ----------------start---------------------------
            SELECT pmn43,pmn012 INTO l_pmn43,l_pmn012 FROM pmn_file
             WHERE pmn01 = b_rvv.rvv36
               AND pmn02 = b_rvv.rvv37
            #FUN-A60076 ----------------end-----------------------------

            #No.FUN-BB0086--add--begin--
            SELECT sfa12 INTO l_sfa12 FROM sfa_file 
             WHERE sfa01 = b_rvv.rvv18 AND sfa03=b_rvv.rvv31
               AND sfa012 = l_pmn012 AND sfa013 = l_pmn43
            LET l_sfa06 = s_digqty(b_rvv.rvv17 * l_factor,l_sfa12)
            #No.FUN-BB0086--add--end--
            UPDATE sfa_file SET sfa06=sfa06 - l_sfa06
             WHERE sfa01 = b_rvv.rvv18 AND sfa03=b_rvv.rvv31
               AND sfa012 = l_pmn012 AND sfa013 = l_pmn43    #FUN-A60076  
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3("upd","sfa_file",b_rvv.rvv18,"",SQLCA.sqlcode,"","Update sfb",1)  #No.FUN-660129
               LET g_success = 'N'
               RETURN
            END IF
  ##NO.FUN-8C0131   add--begin   
            LET l_sql =  " SELECT  * FROM tlf_file ", 
                         "  WHERE  tlf01 = '",b_rvv.rvv31,"' AND tlf03=18 ",
                         "    AND  tlf036='",b_rvv.rvv01,"' AND tlf037=",b_rvv.rvv02," "
            DECLARE t720_u_tlf_c CURSOR FROM l_sql
            LET l_i = 0 
            CALL la_tlf.clear()
            FOREACH t720_u_tlf_c INTO g_tlf.*
               LET l_i = l_i + 1
               LET la_tlf[l_i].* = g_tlf.*
            END FOREACH     

  ##NO.FUN-8C0131   add--end
            DELETE FROM tlf_file
             WHERE tlf01=b_rvv.rvv31 AND tlf03=18 AND #No:7692
                   tlf036=b_rvv.rvv01 AND tlf037=b_rvv.rvv02
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
               CALL cl_err3("del","tlf_file",b_rvv.rvv31,"",SQLCA.sqlcode,"","Delete sfb",1)  #No.FUN-660129
               LET g_success = 'N'
               RETURN
            END IF
    ##NO.FUN-8C0131   add--begin
               FOR l_i = 1 TO la_tlf.getlength()
                  LET g_tlf.* = la_tlf[l_i].*
                  IF NOT s_untlf1('') THEN 
                     LET g_success='N' RETURN
                  END IF 
               END FOR       
  ##NO.FUN-8C0131   add--end 
            IF g_sma.sma115 = 'Y' THEN
               LET l_ima906 = NULL
               SELECT ima906 INTO l_ima906 FROM ima_file
                WHERE ima01=b_rvv.rvv31
               IF l_ima906 MATCHES '[23]' THEN
                  DELETE FROM tlff_file
                   WHERE tlff01 = b_rvv.rvv31 AND tlff03=18
                     AND tlff036= b_rvv.rvv01 AND tlff037=b_rvv.rvv02
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                     CALL cl_err3("del","tlff_file",b_rvv.rvv31,"",SQLCA.sqlcode,"","Delete sfb",1)  #No.FUN-660129
                     LET g_success = 'N'
                     RETURN
                  END IF
               END IF
            END IF
         END IF
      END IF
      IF g_success='N' THEN RETURN END IF
 
  IF b_rvv.rvv31[1,4]!='MISC' THEN
     #  ----鎖ima
     LET g_forupd_sql="SELECT ima01 FROM ima_file",    #wujie 091021
                      " WHERE ima01= ? FOR UPDATE "
     LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
     DECLARE ima_lock_2 CURSOR FROM g_forupd_sql
     OPEN ima_lock_2 USING b_rvv.rvv31
     IF SQLCA.sqlcode THEN
        CALL cl_err('lock ima fail',STATUS,1)
        LET g_success = 'N'
        RETURN
     END IF
     FETCH ima_lock_2 INTO l_ima01     #wujie 091021
     IF SQLCA.sqlcode THEN
        CALL cl_err('lock ima fail',STATUS,1)
        LET g_success = 'N'
        RETURN
     END IF
   #    ----鎖ima
      SELECT img23,img24
        INTO l_img23,l_img24 FROM img_file
       WHERE img01=b_rvv.rvv31 AND img02=b_rvv.rvv32
         AND img03=b_rvv.rvv33 AND img04=b_rvv.rvv34
     IF s_udima(b_rvv.rvv31,l_img23,l_img24,b_rvv.rvv17*b_rvv.rvv35_fac,
                g_rvu.rvu03,-1)
        THEN
        LET g_success='N'
        RETURN
     END IF
  END IF
END FUNCTION
 
FUNCTION t720_d_sfh(b_rvv02)
    DEFINE b_rvv02 LIKE rvv_file.rvv02
 
    DELETE FROM sfh_file
     WHERE sfh01=b_rvv.rvv18
       AND sfh02=g_rvu.rvu03
       AND sfh13=g_rvu.rvu01  #入庫單號
       AND sfh14=b_rvv02        #入庫單身序號
    IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
       CALL cl_err3("del","sfh_file",b_rvv.rvv18,"",STATUS,"","del sfh",1)  #No.660129
       LET g_success='N'
    END IF
 
END FUNCTION
 
#No.+046 010404 by plum add因必須考慮到參數sma894,最好都一致去call s_upimg
FUNCTION t720_u_img()  #入庫的取消確認
    DEFINE l_img10  LIKE img_file.img10
 
    IF cl_null(g_tlf.tlf12) THEN LET g_tlf.tlf12=1 END IF
    LET l_img10=g_tlf.tlf10*g_tlf.tlf12
    IF cl_null(l_img10) THEN LET l_img10=0 END IF
 
    IF g_tlf.tlf03 != 50 AND g_tlf.tlf02 != 50 THEN RETURN END IF
    IF g_tlf.tlf02 = 50 THEN LET g_tlf.tlf10=g_tlf.tlf10*-1 END IF
    IF b_rvv.rvv31[1,4]='MISC' THEN RETURN END IF
 
    MESSAGE "update img_file ..."
    CALL ui.Interface.refresh()
 
    LET g_forupd_sql =
          " SELECT img01,img02,img03,img04 FROM img_file ",
          "   WHERE img01= ? ",
          "    AND img02= ? ",
          "    AND img03= ? ",
          "    AND img04= ? ",
          " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE img_lock_u_img CURSOR FROM g_forupd_sql
 
    OPEN img_lock_u_img USING g_tlf.tlf01,g_tlf.tlf031,g_tlf.tlf032,g_tlf.tlf033
    IF STATUS THEN
       CALL cl_err("OPEN img_lock_u_img:", STATUS, 1)
       CLOSE img_lock_u_img
       LET g_success = 'N'   #MOD-930261
       RETURN
    END IF
    FETCH img_lock_u_img INTO g_tlf.tlf01,g_tlf.tlf031,g_tlf.tlf032,g_tlf.tlf033
    IF STATUS THEN
       CALL cl_err('img_lock_u_img fail',STATUS,1) LET g_success='N' RETURN
    END IF
 
    CALL s_upimg(g_tlf.tlf01,g_tlf.tlf031,g_tlf.tlf032,g_tlf.tlf033,-1,l_img10,g_today,  #FUN-8C0084
                #'','','','','','','','','','','','','','',0,0,'','')                    #FUN-810036
                 '','','','',b_rvv.rvv01,b_rvv.rvv02,'','','','','','','','',0,0,'','')  #FUN-810036
    IF STATUS OR g_success = 'N' THEN
       CALL cl_err('t2_upimg(-1):','9050',0)
       LET g_success='N'
       RETURN
    END IF
 
END FUNCTION
 
FUNCTION t720_u_tlf() #------------------------------------ Update tlf_file
  DEFINE la_tlf  DYNAMIC ARRAY OF RECORD LIKE tlf_file.*   #NO.FUN-8C0131 
  DEFINE l_sql   STRING                                    #NO.FUN-8C0131 
  DEFINE l_i     LIKE type_file.num5                       #NO.FUN-8C0131 
    MESSAGE "d_tlf!"
    CALL ui.Interface.refresh()
  ##NO.FUN-8C0131   add--begin   
            LET l_sql =  " SELECT  * FROM tlf_file ", 
                         " WHERE ROWID='",g_rowid,"' " 
            DECLARE t720_u_tlf_c1 CURSOR FROM l_sql
            LET l_i = 0 
            CALL la_tlf.clear()
            FOREACH t720_u_tlf_c1 INTO g_tlf.* 
               LET l_i = l_i + 1
               LET la_tlf[l_i].* = g_tlf.*
            END FOREACH     

  ##NO.FUN-8C0131   add--end 
    DELETE FROM tlf_file WHERE ROWID  =  g_rowid
    IF STATUS THEN
       CALL cl_err3("del","tlf_file","","",STATUS,"","del tlf:",1)  #No.FUN-660129
       LET g_success='N' RETURN
    END IF
    IF SQLCA.SQLERRD[3]=0 THEN
       CALL cl_err('del tlf:','axm-176',1) LET g_success='N' RETURN
    END IF
    ##NO.FUN-8C0131   add--begin
    FOR l_i = 1 TO la_tlf.getlength()
       LET g_tlf.* = la_tlf[l_i].*
       IF NOT s_untlf1('') THEN 
          LET g_success='N' RETURN
       END IF 
    END FOR       
  ##NO.FUN-8C0131   add--end     
    CALL t720_u_tlfs()  #FUN-810036 
END FUNCTION
 
#**********刪除退貨單頭/單身檔********************************************
FUNCTION t720_log2()
 
  DECLARE t720_log_c CURSOR FOR
          SELECT ROWID ,tlf_file.* FROM tlf_file
           WHERE tlf01=b_rvv.rvv31 AND
                 tlf026=b_rvv.rvv01 AND tlf027=b_rvv.rvv02
#            AND (tlf13 = 'apmt102' OR tlf13 = 'apmt1072')   #MOD-960033 #FUN-D20078 mark
             AND (tlf13 = 'apmt102' OR tlf13 = 'apmt1072' OR tlf13 = 'asft6201' OR tlf13 = 'apmt230')  #FUN-D20078 add
  IF STATUS THEN
     CALL cl_err3("sel","tlf_file",b_rvv.rvv31,"",STATUS,"","declare log",1)  #No.FUN-660129
     LET g_success = 'N' RETURN
  END IF
  FOREACH t720_log_c INTO g_rowid ,g_tlf.*
      IF STATUS THEN LET g_success='N' RETURN END IF
      DISPLAY '_s2() read log:',g_tlf.tlf036,' ',g_tlf.tlf037,' ' AT 2,1
      CALL t720_u_log()
      IF g_success='N' THEN RETURN END IF
  END FOREACH
 
  DECLARE t720_log_du_c CURSOR FOR
          SELECT ROWID ,tlff_file.* FROM tlff_file
           WHERE tlff01=b_rvv.rvv31 AND
                 tlff026=b_rvv.rvv01 AND tlff027=b_rvv.rvv02
#            AND (tlff13 = 'apmt102' OR tlff13 = 'apmt1072')   #MOD-960033  #FUN-D20078 mark
             AND (tlff13 = 'apmt102' OR tlff13 = 'apmt1072' OR tlff13 = 'asft6201' OR tlff13 = 'apmt230')  #FUN-D20078 add
  IF STATUS THEN
     CALL cl_err('declare log',STATUS,1) LET g_success = 'N' RETURN
  END IF
  FOREACH t720_log_du_c INTO g_rowid ,g_tlff.*
      IF STATUS THEN LET g_success='N' RETURN END IF
      DISPLAY '_s2() read log:',g_tlff.tlff036,' ',g_tlff.tlff037,' ' AT 2,1
      CALL t720_u_log_du()
      IF g_success='N' THEN RETURN END IF
  END FOREACH
END FUNCTION
 
FUNCTION t720_u_log() #------------------------------------ Update tlf_file
  DEFINE la_tlf  DYNAMIC ARRAY OF RECORD LIKE tlf_file.*   #NO.FUN-8C0131 
  DEFINE l_sql   STRING                                    #NO.FUN-8C0131 
  DEFINE l_i     LIKE type_file.num5                       #NO.FUN-8C0131 
  
    MESSAGE "d_tlf!"
  ##NO.FUN-8C0131   add--begin   
            LET l_sql =  " SELECT  * FROM tlf_file ", 
                         " WHERE ROWID='",g_rowid,"' " 
            DECLARE t720_u_tlf_c2 CURSOR FROM l_sql
            LET l_i = 0 
            CALL la_tlf.clear()
            FOREACH t720_u_tlf_c2 INTO g_tlf.* 
               LET l_i = l_i + 1
               LET la_tlf[l_i].* = g_tlf.*
            END FOREACH     

  ##NO.FUN-8C0131   add--end 
    DELETE FROM tlf_file WHERE ROWID  =  g_rowid
    IF STATUS THEN
       CALL cl_err3("del","tlf_file","","",SQLCA.sqlcode,"","del tlf:",1)  #No.FUN-660129
       LET g_success='N' RETURN
    END IF
    IF SQLCA.SQLERRD[3]=0 THEN
       CALL cl_err('del tlf:','axm-176',1) LET g_success='N' RETURN
    END IF
    ##NO.FUN-8C0131   add--begin
    FOR l_i = 1 TO la_tlf.getlength()
       LET g_tlf.* = la_tlf[l_i].*
       IF NOT s_untlf1('') THEN 
          LET g_success='N' RETURN
       END IF 
    END FOR       
  ##NO.FUN-8C0131   add--end
    CALL t720_u_tlfs()  #FUN-810036 
END FUNCTION
 
#*********倉退update (取消確認)**************************************
#更新相關的檔案
FUNCTION t720_bu2()
   DEFINE
      g_img21         LIKE img_file.img21,
      g_img23         LIKE img_file.img23,
      g_img24         LIKE img_file.img24,
      l_pmn07         LIKE pmn_file.pmn07,
      l_rvb29         LIKE rvb_file.rvb29,
      l_rvb291        LIKE rvb_file.rvb29,
      l_rvv17         LIKE rvv_file.rvv17,
      l_rvb30         LIKE rvb_file.rvb30,
      l_rvb39         LIKE rvb_file.rvb39, #MOD-4C0053
      l_sta           LIKE type_file.num5,    #No.FUN-680136 SMALLINT
      l_ima906        LIKE ima_file.ima906, #No.FUN-540027
      l_qty_ima       LIKE img_file.img10,
      l_qty_img       LIKE img_file.img10,
      l_qty1_ima      LIKE img_file.img10,
      l_qty1_img      LIKE img_file.img10,
      l_qty_rvv17     LIKE rvv_file.rvv17,
      l_ima55         LIKE ima_file.ima55,
      l_factor        LIKE ima_file.ima31_fac, #No.FUN-680136 DEC(16,8)
      l_code          LIKE type_file.chr1    #No.FUN-680136 VARCHAR(01)
   DEFINE l_ima01     LIKE ima_file.ima01    #wujie 091021
 
 IF b_rvv.rvv31[1,4]!='MISC' 
    AND NOT (g_rvu.rvu00='3' AND b_rvv.rvv17=0) THEN   #MOD-A40166
    MESSAGE "update img_file ..."
 
    LET g_forupd_sql =
          " SELECT img01,img02,img03,img04 FROM img_file ",
          "   WHERE img01= ? ",
          "    AND img02= ? ",
          "    AND img03= ? ",
          "    AND img04= ? ",
          " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE img_lock_bu2 CURSOR FROM g_forupd_sql
 
    OPEN img_lock_bu2 USING b_rvv.rvv31,b_rvv.rvv32,b_rvv.rvv33,b_rvv.rvv34
    IF STATUS THEN
       CALL cl_err("OPEN img_lock_bu2:", STATUS, 1)
       CLOSE img_lock_bu2
       #ROLLBACK WORK   #MOD-930261
       LET g_success = 'N'   #MOD-930261
       RETURN
    END IF
    FETCH img_lock_bu2 INTO b_rvv.rvv31,b_rvv.rvv32,b_rvv.rvv33,b_rvv.rvv34
    IF STATUS THEN
       CALL cl_err('img_lock_bu2 fail',STATUS,1) LET g_success='N' RETURN
    END IF
 
   SELECT img21,img23,img24
     INTO g_img21,g_img23,g_img24 FROM img_file
    WHERE img01=b_rvv.rvv31 AND img02=b_rvv.rvv32
      AND img03=b_rvv.rvv33 AND img04=b_rvv.rvv34
 
        IF STATUS THEN
           CALL cl_err3("sel","img_file",b_rvv.rvv31,"",STATUS,"","sel img",1)  #No.FUN-660129
           LET g_success='N'
           RETURN
        END IF
   IF cl_null(g_img21) THEN LET g_img21=1 END IF
   IF g_sma.sma12 ='Y' THEN
      LET l_qty_img=b_rvv.rvv17*b_rvv.rvv35_fac        #退貨總數(img_file)
      LET l_qty_ima = l_qty_img * g_img21          #退貨總數(ima_file)
   ELSE
      LET l_qty_img=b_rvv.rvv17                    #退貨總數(img_file)
      LET l_qty_ima= b_rvv.rvv17                   #退貨總數(ima_file)
   END IF
   LET l_qty1_img = b_rvv.rvv17 * b_rvv.rvv35_fac
   LET l_qty1_ima = l_qty1_img * g_img21
  #FUN-D60130 ------Begin------
   IF g_argv1 = '3' AND g_argv3 = 'SUB' AND g_rvu00 = '3' THEN  #委外倉退
      LET l_qty1_img = 0
      LET l_qty1_ima = 0
   END IF
  #FUN-D60130 ------End--------
#-----更新倉庫庫存明細資料
#---------------------- +1代表入庫(因庫退取消確認須加回數量)
   CALL s_upimg(b_rvv.rvv31,b_rvv.rvv32,b_rvv.rvv33,b_rvv.rvv34,+1,l_qty1_img,g_rvu.rvu03,  #FUN-8C0084
               #'','','','','','','','','','','','','','',0,0,'','') #FUN-810036
                '','','','',b_rvv.rvv01,b_rvv.rvv02,'','','','','','','','',0,0,'','')  #FUN-810036
   IF g_success = 'N' THEN
     #CALL cl_err('bu2_upimg',STATUS,1) RETURN
      CALL cl_err('bu2_upimg','9050',0) RETURN
   END IF
#------若庫存異動後其庫存量小於等於零時將該筆資料刪除
   CALL s_delimg(b_rvv.rvv31,b_rvv.rvv32,b_rvv.rvv33,b_rvv.rvv34) #FUN-8C0084
#------更新庫存主檔之庫存數量 (單位為主檔之庫存單位)
   LET g_forupd_sql="SELECT ima01 FROM ima_file",   #wujie 091021
                    " WHERE ima01= ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE ima_lock_3 CURSOR FROM g_forupd_sql
   OPEN ima_lock_3 USING b_rvv.rvv31
   IF SQLCA.sqlcode THEN
      CALL cl_err('lock ima fail',STATUS,1)
      LET g_success = 'N'
      RETURN
   END IF
   FETCH ima_lock_3 INTO l_ima01      #wujie 091021
   IF SQLCA.sqlcode THEN
      CALL cl_err('lock ima fail',STATUS,1)
      LET g_success = 'N'
      RETURN
   END IF
  #    ----鎖ima
   IF s_udima(b_rvv.rvv31,g_img23,g_img24,l_qty1_ima,g_rvu.rvu03,+1) THEN  #MOD-830212
      RETURN
   END IF
   IF g_success = 'N' THEN
      CALL cl_err('udima',STATUS,1) RETURN
   END IF
   SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01=b_rvv.rvv31
   IF g_sma.sma115 = 'Y' AND l_ima906 MATCHES '[23]' THEN
      CALL t720sub_update_imgg(+1,b_rvv.*,g_rvu.rvu02)  #FUN-A10130
   END IF
 END IF
   IF b_rvv.rvv37 IS NOT NULL AND b_rvv.rvv37 !=' ' THEN
      SELECT pmn07 INTO l_pmn07 FROM pmn_file
      WHERE pmn01 = b_rvv.rvv36 AND pmn02 = b_rvv.rvv37
      IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","pmn_file",b_rvv.rvv36,b_rvv.rvv37,SQLCA.sqlcode,"","pmn07(purchase unit not found):",1)  #No.FUN-660129
      END IF
   ELSE
      LET l_pmn07 = b_rvv.rvv35
   END IF
   CALL s_umfchk(b_rvv.rvv31,b_rvv.rvv35,l_pmn07)
             RETURNING l_sta,l_fac
   IF l_sta THEN
      ###Modify:98/11/15 -----單位換算率抓不到 ------####
      CALL cl_err('rvv35/pmn07: ','abm-731',1)
      LET g_success ='N'
      LET l_fac = 1.0
   END IF
   LET l_qty_rvv17 = b_rvv.rvv17 * l_fac
   LET l_qty_rvv17 = s_digqty(l_qty_rvv17,l_pmn07)   #No.FUN-BB0086
#--------如果有驗收單, 則更新rvb,採購單
   IF NOT cl_null(g_rvu.rvu02) THEN
      SELECT SUM(rvv17) INTO l_rvb30 FROM rvv_file,rvu_file     #計算已入庫量
       WHERE rvv04=b_rvv.rvv04 AND rvv05=b_rvv.rvv05
             AND rvuconf='Y' AND rvu00='1' AND rvv01=rvu01
      SELECT SUM(rvv17) INTO l_rvb29 FROM rvv_file,rvu_file     #計算驗退
       WHERE rvv04=b_rvv.rvv04 AND rvv05=b_rvv.rvv05
             AND rvuconf='Y' AND rvu00='2' AND rvv01=rvu01
      SELECT SUM(rvv17) INTO l_rvb291 FROM rvv_file,rvu_file     #計算倉退
       WHERE rvv04=b_rvv.rvv04 AND rvv05=b_rvv.rvv05
             AND rvuconf='Y' AND rvu00='3' AND rvv01=rvu01
      IF cl_null(l_rvb30) THEN LET l_rvb30=0 END IF
      IF cl_null(l_rvb29) THEN LET l_rvb29=0 END IF
      IF cl_null(l_rvb291) THEN LET l_rvb291=0 END IF
      SELECT rvb39 INTO l_rvb39
        FROM rvb_file
       WHERE rvb01 = g_rvu.rvu02
         AND rvb02 = b_rvv.rvv05
      IF l_rvb39 = 'Y' THEN
          UPDATE rvb_file SET rvb29 = l_rvb29,         #退貨量
                              rvb30 = l_rvb30,         #入庫量
                              rvb09 = l_rvb30-l_rvb291, #允請量
                              rvb31 = rvb33-l_rvb30 #可入庫量   #No.MOD-5C0089 #CHI-6A0046
           WHERE rvb01 = g_rvu.rvu02 AND rvb02 = b_rvv.rvv05
          IF SQLCA.sqlcode THEN
             CALL cl_err3("upd","rvb_file",g_rvu.rvu02,b_rvv.rvv05,SQLCA.sqlcode,"","退 upd rvb29,rvb09,rvb31:",1)  #No.FUN-660129
             LET g_success = 'N'
          END IF
      ELSE
          UPDATE rvb_file SET rvb29 = l_rvb29,         #退貨量
                              rvb30 = l_rvb30,         #入庫量
                              rvb09 = l_rvb30-l_rvb291, #允請量
                              rvb31 = rvb07-l_rvb29-l_rvb30 #可入庫量
           WHERE rvb01 = g_rvu.rvu02 AND rvb02 = b_rvv.rvv05
          IF SQLCA.sqlcode THEN
             CALL cl_err3("upd","rvb_file",g_rvu.rvu02,b_rvv.rvv05,SQLCA.sqlcode,"","退 upd rvb29,rvb09,rvb31:",1)  #No.FUN-660129
             LET g_success = 'N'
          END IF
      END IF

      SELECT ima918,ima921 INTO g_ima918,g_ima921 
        FROM ima_file
       WHERE ima01 = b_rvv.rvv31
         AND imaacti = "Y"
      
      IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
         IF g_sma.sma90 = "Y" THEN #MOD-C30074 add
            CALL t720sub_upd_rvbs(-1,g_rvu.rvu01,g_rvu.rvu02,b_rvv.rvv02,b_rvv.rvv05) #FUN-A10130
         END IF #MOD-C30074 add
      END IF
#---------更新採購單退貨量
      IF NOT cl_null(b_rvv.rvv36) AND b_rvv.rvv25='N' THEN
         SELECT SUM(rvb29) INTO l_rvb29 FROM rvb_file,rva_file
          WHERE rvb04=b_rvv.rvv36 AND rvb03=b_rvv.rvv37
            AND rvaconf='Y' AND rvb01=rva01 AND rvb35='N'
         IF cl_null(l_rvb29) THEN LET l_rvb29=0 END IF
         SELECT SUM(rvv17) INTO l_rvv17 FROM rvv_file,rvu_file     #計算倉退
          WHERE rvv36=b_rvv.rvv36 AND rvv37=b_rvv.rvv37
                AND rvuconf='Y' AND rvu00='3' AND rvv01=rvu01 AND rvv25='N'
                AND rvu01!=g_rvu.rvu01
                AND rvu116 = '2'  #MOD-B30556
         IF cl_null(l_rvv17) THEN LET l_rvv17=0 END IF
         IF g_rvu.rvu116 = '2' THEN
            UPDATE pmn_file SET pmn58 = l_rvv17
                WHERE pmn01 = b_rvv.rvv36 AND pmn02 = b_rvv.rvv37
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","pmn_file",b_rvv.rvv36,b_rvv.rvv37,SQLCA.sqlcode,"","upd pmn55:",1)  #No.FUN-660129
               LET g_success = 'N'
            END IF
         END IF
         UPDATE pmn_file SET pmn55 = l_rvb29
            WHERE pmn01 = b_rvv.rvv36 AND pmn02 = b_rvv.rvv37
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","pmn_file",b_rvv.rvv36,b_rvv.rvv37,SQLCA.sqlcode,"","upd pmn55:",1)  #No.FUN-660129
            LET g_success = 'N'
         END IF
#--------更新超短交量 = 收貨量 - 訂購量
         CALL s_udpmn57(b_rvv.rvv36,b_rvv.rvv37)
       END IF
   END IF
### ---委外倉退取消確認應update sfb09=sfb09+倉退量*轉換率
   IF g_rvu.rvu08='SUB' AND NOT cl_null(b_rvv.rvv18) THEN
      INITIALIZE g_sfb.* TO NULL
      SELECT * INTO g_sfb.* FROM sfb_file
       WHERE sfb01=b_rvv.rvv18   #單號
#        AND sfb02=7             #委外   #MOD-B70171 mark
         AND sfb04<>'8'          #結案
      IF g_sfb.sfb05=b_rvv.rvv31 #料件
         THEN
         SELECT ima55 INTO l_ima55 FROM ima_file
          WHERE ima01 = b_rvv.rvv31
         CALL s_umfchk(b_rvv.rvv31,b_rvv.rvv35,l_ima55)   #生產/入庫
              RETURNING g_cnt,l_factor
         IF g_cnt THEN
            CALL cl_err('(t720_bu2)rvv35/ima55: ','abm-731',1)
            LET g_success ='N'
            RETURN
         END IF
         UPDATE sfb_file SET sfb09=sfb09+( b_rvv.rvv17 * l_factor )  #數量
          WHERE sfb01 = b_rvv.rvv18
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
            CALL cl_err3("upd","sfb_file",b_rvv.rvv18,"",SQLCA.sqlcode,"","Update sfb",1)  #No.FUN-660129
            LET g_success = 'N'
            RETURN
         END IF
      END IF
   END IF
   IF g_success = 'N' THEN RETURN  END IF
END FUNCTION
 
FUNCTION t720_unit(p_unit)  #單位
    DEFINE p_unit    LIKE gfe_file.gfe01,
           l_gfeacti LIKE gfe_file.gfeacti
 
    LET g_errno = ' '
    SELECT gfeacti INTO l_gfeacti
           FROM gfe_file WHERE gfe01 = p_unit
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg2605'
                                   LET l_gfeacti = NULL
         WHEN l_gfeacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION t720_out()
   DEFINE l_cmd        LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(200)
          l_wc,l_wc2   LIKE type_file.chr50,   #No.FUN-680136 VARCHAR(50)
          l_program    LIKE zz_file.zz01,      #No.FUN-680136 VARCHAR(10)
          l_prtway     LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
      CALL cl_wait()
      LET l_wc='rvu01="',g_rvu.rvu01,'"'
      IF g_prog = 'apmt720' THEN 
      LET g_msg = "cpmr720", 
                       " '",g_today CLIPPED,"' ''",
                       " '",g_lang CLIPPED,"' '",g_bgjob CLIPPED,"'  '' '1'",
                       " '",l_wc CLIPPED,"' '1' '' 'N' "  
      END IF 
      IF g_prog = 'apmt722' THEN 
      LET g_msg = "cpmr720", 
                       " '",g_today CLIPPED,"' ''",
                       " '",g_lang CLIPPED,"' '",g_bgjob CLIPPED,"'  '' '1'",
                       " '",l_wc CLIPPED,"' '2' '' 'N' "  
      END IF 

      IF g_prog = 'apmt730' THEN 
      LET g_msg = "cpmr730", 
                       " '",g_today CLIPPED,"' ''",
                       " '",g_lang CLIPPED,"' '",g_bgjob CLIPPED,"'  '' '1'",
                       " '",l_wc CLIPPED,"' '' '2' '' 'N' "  
      END IF 
      IF g_argv1 = '2' THEN 
      LET g_msg = "cpmr721", 
                       " '",g_today CLIPPED,"' ''",
                       " '",g_lang CLIPPED,"' '",g_bgjob CLIPPED,"'  '' '1'",
                       " '",l_wc CLIPPED,"' '' 'N' "  
      END IF 
                    CALL cl_cmdrun(g_msg)
      #IF g_rvu.rvu00='1' THEN LET l_program='apmr630' END IF #FUN-C30085 mark
      --IF g_rvu.rvu00='1' THEN LET l_program='apmg630' END IF #FUN-C30085 add
      #IF g_rvu.rvu00='2' THEN LET l_program='apmr632' END IF #FUn-C30085 mark
      --IF g_rvu.rvu00='2' THEN LET l_program='apmg632' END IF #FUn-C30085 add
      #IF g_rvu.rvu00='3' THEN LET l_program='apmr631' END IF #FUn-C30085 mark
      --IF g_rvu.rvu00='3' THEN LET l_program='apmg631' END IF #FUn-C30085 add
      --SELECT zz21,zz22 INTO l_wc2,l_prtway FROM zz_file WHERE zz01 = l_program
      --IF SQLCA.sqlcode OR l_wc2 IS NULL THEN
        #LET l_wc2 = " '3' 'N' "   #MOD-B90025 mark
         --LET l_wc2 = " '3' 'Y' "   #MOD-B90025
      --END IF
      --LET l_cmd = l_program,
                  --" '",g_today CLIPPED,"' ''",
                  --" '",g_lang CLIPPED,"' 'Y' '",l_prtway,"' '1'",
                  --" '",l_wc CLIPPED,"' "   #TQC-610085  ,l_wc2
                  --,l_wc2                   #MOD-B90025 add
      --CALL cl_cmdrun(l_cmd)
   --ERROR ' '
END FUNCTION
 
FUNCTION t720_g_b()        #自動產生入庫單
   DEFINE l_rvb331   LIKE rvb_file.rvb331    #No.MOD-760028 add
   DEFINE l_rvb332   LIKE rvb_file.rvb332    #No.MOD-760028 add
   DEFINE l_rvb33    LIKE rvb_file.rvb33
   DEFINE l_rvb39    LIKE rvb_file.rvb39
   DEFINE l_rvb40    LIKE rvb_file.rvb40
   DEFINE l_rvb25    LIKE rvb_file.rvb25
   DEFINE l_ima906   LIKE ima_file.ima906  #No.FUN-540027
   DEFINE l_rvv82    LIKE rvv_file.rvv82   #FUN-660218
   DEFINE l_rvv85    LIKE rvv_file.rvv85   #FUN-660218
   DEFINE l_img09    LIKE img_file.img09   #No.MOD-740049 add
   DEFINE l_i        LIKE type_file.num5   #No.MOD-740049 add
   DEFINE l_rvb07    LIKE rvb_file.rvb07   #MOD-820189
   DEFINE l_rvv87_o  LIKE rvv_file.rvv87   #MOD-820189
   DEFINE l_sql      STRING  #No.FUN-810036
   DEFINE l_rvb89    LIKE rvb_file.rvb89   #FUN-940083
   DEFINE l_rva113     LIKE rva_file.rva113    #NO.FUN-940083
   DEFINE l_rvb42    LIKE rvb_file.rvb42   #NO.FUN-960130
   DEFINE l_rvb43    LIKE rvb_file.rvb43   #NO.FUN-960130
   DEFINE l_rvb44    LIKE rvb_file.rvb44   #NO.FUN-960130
   DEFINE l_rvb45    LIKE rvb_file.rvb45   #NO.FUN-960130
   DEFINE l_rtz07    LIKE rtz_file.rtz07   #NO.FUN-960130
   DEFINE l_pmc22    LIKE pmc_file.pmc22   #NO.FUN-960130
#FUN-A60035 ---MARK BEGIN
#  DEFINE l_cnt      LIKE type_file.num5   #No.FUN-A50054
#  DEFINE l_ata05    LIKE ata_file.ata05   #No.FUN-A50054
#  DEFINE l_ata      RECORD LIKE ata_file.* #No.FUN-A50054
#FUN-A60035 ---MARK END
   DEFINE l_prog     LIKE type_file.chr20   #No.FUN-A30025
   DEFINE l_pmn123   LIKE pmn_file.pmn123   #FUN-B40083
   DEFINE l_rvv17_tol LIKE rvv_file.rvv17   #FUN-D20022 add
   DEFINE l_rvb36    LIKE rvb_file.rvb36    #倉庫  #TQC-C20117 add
   DEFINE l_rvb37    LIKE rvb_file.rvb37    #儲位  #TQC-C20117 add
   DEFINE l_rvb38    LIKE rvb_file.rvb38    #批號  #TQC-C20117 add
   #FUN-C20002--start add-------------------------------------------
   DEFINE l_ima154      LIKE ima_file.ima154
   DEFINE l_rcj03       LIKE rcj_file.rcj03
   DEFINE l_rtz08       LIKE rtz_file.rtz08
   #FUN-C20002--end add---------------------------------------------

   IF g_rvu.rvu01 IS NULL THEN RETURN END IF
   IF NOT cl_confirm('apm-255') THEN RETURN END IF
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   SELECT rva00 INTO g_rva00 FROM rva_file WHERE rva01 = g_rvu.rvu02
   IF g_rva00 = '1' THEN
      LET g_sql = "SELECT rvb25,rvb89,rvb39,rvb40,rvb33,rvb331,rvb332, ",  #No.MOD-760028 add rvb331,rvb332 #no.A050 add rvb25 #FUN-9A0068 add rvb89
                  "       rvb07,", #CHI-980050   
                  "       ' ',' ','1',rvb01,rvb02,' ',' ',",
                  "       rvb31,rvb34,0,' ',rvb35,",
                  "       ' ',rvb05,ima02,rvb36,rvb37,rvb38,pmn07,", #No:5611
                  "       pmn09,rvb04,rvb03,rvb10,'','','','','', ",
                  "       rvb80,rvb81,rvb82,rvb83,rvb84,rvb85,rvb86,rvb87,'',rvb10t,",
                  "       rvb930,0,",
                  #"       '','','','','','','','','','','','','','',''", #CHI-980050 del ,   #mark by guanyao160621
                  "       '',rvbud04,'','','','','','','','','','',rvbud13,'',''", #CHI-980050 del ,  #add by guanyao160621
                  "  FROM rvb_file,OUTER pmn_file,OUTER ima_file",
                  " WHERE rvb01 = '",g_rvu.rvu02 CLIPPED,"'",
                  "     AND rvb04=pmn_file.pmn01 ",   #MOD-910206
                  " AND rvb03=pmn_file.pmn02",
                  "     AND rvb05=ima_file.ima01 "
   ELSE
      LET g_sql = "SELECT rvb25,rvb89,rvb39,rvb40,rvb33,rvb331,rvb332, ",    #FUN-9A0068
                  "       rvb07,", #CHI-980050 
                  "       ' ',' ','1',rvb01,rvb02,' ',' ',",
                  "       rvb31,rvb34,0,' ',rvb35,",
                  "       ' ',rvb05,ima02,rvb36,rvb37,rvb38,rvb90,", 
                  "       rvb90_fac,rvb04,rvb03,rvb10,'','','','','', ",
                  "       rvb80,rvb81,rvb82,rvb83,rvb84,rvb85,rvb86,rvb87,'',rvb10t,",
                  "       rvb930,0,",
                 # "       '','','','','','','','','','','','','','',''",   #MOD-CA0041 del ,  #mark by guanyao160621
                  "       '',rvbud04,'','','','','','','','','','',rvbud13,'',''", #CHI-980050 del ,  #add by guanyao160621
                  "  FROM rvb_file,OUTER ima_file",
                  " WHERE rvb01 = '",g_rvu.rvu02 CLIPPED,"'",
                  "     AND rvb05=ima_file.ima01 "
   END IF
   PREPARE t720_g_b_p1 FROM g_sql
 
   DECLARE t720_g_b_c1 CURSOR WITH HOLD FOR t720_g_b_p1
 
   LET l_ac = 1
 
   FOREACH t720_g_b_c1 INTO l_rvb25,l_rvb89,l_rvb39,l_rvb40,l_rvb33,l_rvb331,l_rvb332,l_rvb07,b_rvv.*    #CHI-980050   #FUN-9A0068
      IF STATUS THEN
         CALL cl_err('for rvb',STATUS,1)
         EXIT FOREACH
      END IF

#FUN-A60035 ---MARK BEGIN
#     #No.FUN-A50054 -BEGIN-----
#      IF s_industry('slk') THEN
#         LET l_cnt = 0
#         SELECT COUNT(*) INTO l_cnt FROM ata_file
#          WHERE ata00 = g_prog
#            AND ata01 = g_rvu.rvu01
#            AND ata04 = b_rvv.rvv31
#         IF l_cnt = 0 THEN
#            IF g_rvu.rvu00 = '1' THEN
#               IF g_argv3 !='SUB' AND g_argv3 !='TAP' THEN LET l_prog = 'apmt110' END IF
#               IF g_argv3='SUB' THEN LET l_prog = 'apmt200' END IF
#               IF (g_argv1='1' AND g_argv3='TAP') OR (g_argv1=' ' AND g_argv3='TAP') THEN
#                  LET l_prog = 'apmt300'
#               END IF
#            END IF
#            DECLARE t720_rvbata SCROLL CURSOR FOR
#             SELECT * FROM ata_file
#              WHERE ata00=l_prog
#                AND ata01=b_rvv.rvv04
#                AND ata03=b_rvv.rvv05
#            FOREACH t720_rvbata INTO l_ata.*
#               LET l_ata.ata00 = g_prog
#               LET l_ata.ata01 = g_rvu.rvu01
#               INSERT INTO ata_file VALUES (l_ata.*)
#            END FOREACH
#         END IF
#      END IF
#     #No.FUN-A50054 -END-------
#FUN-A60035 ---MARK END

      LET l_rvv87_o = b_rvv.rvv87     #MOD-820189 add

#FUN-A60035 ---MARK BEGIN
#    #No.FUN-A50054 -BEGIN-----
#     IF s_industry('slk') THEN
#        LET b_rvv.rvv02 = b_rvv.rvv05
#     ELSE
#FUN-A60035 ---MARK END
      	 SELECT max(rvv02)+1 INTO b_rvv.rvv02 FROM rvv_file
         WHERE rvv01 = g_rvu.rvu01
#FUN-A60035 ---MARK BEGIN
#     END IF
#    #No.FUN-A50054 -END-------
#FUN-A60035 ---MARK END
 
      IF b_rvv.rvv02 IS NULL THEN
         LET b_rvv.rvv02 = 1
      END IF
 
      LET b_rvv.rvv01=g_rvu.rvu01
      IF g_azw.azw04 = '2' THEN
         SELECT rvb36,rvb37,rvb38,rvb42,rvb43,rvb44,rvb45     #TQC-C20117 add rvb36,rvb37,rvb38
           INTO l_rvb36,l_rvb37,l_rvb38,                      #TQC-C20117 add 
                l_rvb42,l_rvb43,l_rvb44,l_rvb45  
              FROM rvb_file                                                                     
           WHERE rvb01 = g_rvu.rvu02 AND rvb07+rvb29-rvb30>0                                                       
                                                            
         LET b_rvv.rvv10 = l_rvb42
         LET b_rvv.rvv11 = l_rvb43
         LET b_rvv.rvv12 = l_rvb44
         LET b_rvv.rvv13 = l_rvb45
         #FUN-C90049 mark begin----
         #SELECT rtz07 INTO l_rtz07 FROM rtz_file #MOD-9C0016 del rtz08
         # WHERE rtz01 = g_rvu.rvuplant 
         #FUN-C90049 mark end-----
         CALL s_get_coststore(g_rvu.rvuplant,g_rvv[l_ac].rvv31) RETURNING l_rtz07    #FUN-C90049 add
       #FUN-C20002--start add-------------------------------------------
       SELECT ima154 INTO l_ima154
         FROM ima_file
        WHERE ima01 = g_rvv[l_ac].rvv31 
       IF l_ima154 = 'Y' AND g_rvv[l_ac].rvv31[1,4] <> 'MISC' THEN
          SELECT rcj03 INTO l_rcj03
            FROM rcj_file
           WHERE rcj00 = '0'
         #FUN-C90049 mark begin--- 
         #SELECT rtz07,rtz08 INTO l_rtz07,l_rtz08
         #  FROM rtz_file
         # WHERE rtz01 = g_plant
         #FUN-C90049 mark end-----
         CALL s_get_defstore(g_plant,g_rvv[l_ac].rvv31) RETURNING  l_rtz07,l_rtz08    #FUN-C90049 add
         IF l_rcj03 = '1' THEN
            LET b_rvv.rvv32 = l_rtz07
         ELSE
            LET b_rvv.rvv32 = l_rtz08
         END IF 
      ELSE
         IF NOT cl_null(l_rvb36) THEN
            LET b_rvv.rvv32 = l_rvb36
            LET b_rvv.rvv33 = l_rvb37
            LET b_rvv.rvv34 = l_rvb38   
         ELSE
            #FUN-C90049 mark begin---
            #SELECT rtz08 INTO l_rtz07 FROM rtz_file
            #    WHERE rtz01 = g_rvu.rvuplant
            #FUN-C90049 mark end-----
            CALL s_get_noncoststore(g_rvu.rvuplant,g_rvv[l_ac].rvv31) RETURNING l_rtz07    #FUN-C90049 add
            LET b_rvv.rvv32 = l_rtz07
         END IF  
      END IF  
 
       #FUN-C20002--end  add--------------------------------------------
       #FUN-C20002--start mark-------------------------------------------------
       # #TQC-C20117--add--begin--
       #  IF NOT cl_null(l_rvb36) THEN
       #     #LET b_rvv.rvv32 = l_rvb36  #FUN-C20002 mark
       #     LET b_rvv.rvv33 = l_rvb37
       #     LET b_rvv.rvv34 = l_rvb38
       #  ELSE
       # #TQC-C20117--add--end--
       #    #FUN-B40098 Begin---
       #    #IF g_rvu.rvu21 = '3' THEN  #FUN-B60150 MARK
       #     IF g_rvu.rvu21 = '3' OR (g_rvu.rvu27 = '2' AND g_sma.sma146 = '2') THEN #FUN-B60150 ADD
       #        SELECT rtz08 INTO l_rtz07 FROM rtz_file
       #         WHERE rtz01 = g_rvu.rvuplant
       #     END IF
       #    #FUN-B40098 End-----
       #     LET b_rvv.rvv32 = l_rtz07
       #  END IF          #TQC-C20117 add
       #FUN-C20002--end mark----------------------------------------------------------
      ELSE
         LET b_rvv.rvv10 = '4'   #FUN-9C0075 ADD
      END IF
      LET b_rvv.rvvplant=g_rvu.rvuplant
      LET b_rvv.rvvlegal=g_rvu.rvulegal
 
      LET b_rvv.rvv09=g_rvu.rvu03
      LET b_rvv.rvv06=g_rvu.rvu04     #廠商單號
 
      IF b_rvv.rvv31[1,4]='MISC' THEN
 
         SELECT pmn041 INTO b_rvv.rvv031 FROM pmn_file
 
          WHERE pmn01=b_rvv.rvv36 AND pmn02=b_rvv.rvv37  #No.MOD-590354
      END IF
      IF NOT cl_null(b_rvv.rvv32) THEN
         SELECT img09 INTO l_img09 FROM img_file
             WHERE img01 = b_rvv.rvv31
               AND img02 = b_rvv.rvv32
               AND img03 = b_rvv.rvv33
               AND img04 = b_rvv.rvv34
         CALL s_umfchk(b_rvv.rvv31,b_rvv.rvv35,l_img09)
             RETURNING l_i,b_rvv.rvv35_fac
         IF l_i = 1 THEN
            ### ------單位無法轉換--------####
            CALL cl_err('rvv35/img09: ','abm-731',1)
            LET g_success ='N'
            RETURN
         END IF
      END IF
      LET g_rvv[l_ac].rvv02=b_rvv.rvv02
      LET g_rvv[l_ac].rvv05=b_rvv.rvv05
      IF l_rvb39 = 'Y' THEN          #-->檢驗 #no.7143
         #no.7143
         IF g_sma.sma886[6]='Y' AND l_rvb39='Y' AND l_rvb40 IS NULL THEN
            CONTINUE FOREACH
         END IF
         IF NOT cl_null(l_rvb33) AND l_rvb33 > 0 THEN
           IF b_rvv.rvv17 > l_rvb33 THEN
              LET b_rvv.rvv17=l_rvb33
           END IF
         ELSE
            CONTINUE FOREACH
         END IF         
      END IF
      IF b_rvv.rvv17 <= 0 THEN
         CONTINUE FOREACH
      END IF
      #FUN-D20022 -- add start --
      IF g_rva00 = '1' THEN
         SELECT SUM(rvv17) INTO l_rvv17_tol FROM rvv_file,rvu_file
          WHERE rvv04 = g_rvu.rvu02 AND rvv05 = b_rvv.rvv05
           AND rvu00='1' AND rvv01=rvu01 AND rvuconf <> 'X'
         IF cl_null(l_rvv17_tol) THEN LET l_rvv17_tol = 0 END IF
         IF b_rvv.rvv17 - l_rvv17_tol <= 0 THEN
            CONTINUE FOREACH
         ELSE
            LET b_rvv.rvv17 = b_rvv.rvv17 - l_rvv17_tol
         END IF
      END IF
      #FUN-D20022 -- add end --
      LET g_rvv[l_ac].rvv89=l_rvb89        #FUN-9A0068
      LET b_rvv.rvv89 = l_rvb89            #No.TQC-9C0165
      LET g_rvv[l_ac].rvv17=b_rvv.rvv17
      LET g_rvv[l_ac].rvv18=b_rvv.rvv18
      LET g_rvv[l_ac].rvv25=b_rvv.rvv25
      LET g_rvv[l_ac].rvv26=b_rvv.rvv26
      LET g_rvv[l_ac].rvv31=b_rvv.rvv31
      LET g_rvv[l_ac].rvv031=b_rvv.rvv031
      LET g_rvv[l_ac].rvv32=b_rvv.rvv32
      LET g_rvv[l_ac].rvv33=b_rvv.rvv33
      LET g_rvv[l_ac].rvv34=b_rvv.rvv34
      LET g_rvv[l_ac].rvv930=b_rvv.rvv930  #FUN-670051
      LET l_ima906 = NULL
      SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01=b_rvv.rvv31
    #1.當不使用多單位時，單位一的單位與數量不default值
    #2.計價單位與計價數量不受多單位參數影響
      LET g_rvv[l_ac].rvv86=b_rvv.rvv86
      IF (g_sma.sma115 = 'Y') AND (l_ima906 MATCHES '[23]') THEN
         SELECT SUM(rvv82),SUM(rvv85)
               INTO l_rvv82,l_rvv85
               FROM rvu_file,rvv_file
              WHERE rvu01=rvv01
                AND rvuconf<>'X'
                AND rvuacti='Y'
                AND rvv04=g_rvu.rvu02
                AND rvv05=b_rvv.rvv05
                AND rvv82 IS NOT NULL
                AND rvv85 IS NOT NULL
 
         IF cl_null(l_rvv82) THEN
            LET l_rvv82=0
         END IF
         IF cl_null(l_rvv85) THEN
            LET l_rvv85=0
         END IF
         LET b_rvv.rvv82=l_rvb331-l_rvv82
         LET b_rvv.rvv85=l_rvb332-l_rvv85
         IF b_rvv.rvv82<0 THEN
            LET b_rvv.rvv82=0
         END IF
         IF b_rvv.rvv85<0 THEN
            LET b_rvv.rvv85=0
         END IF
      END IF
      LET g_rvv[l_ac].rvv80=b_rvv.rvv80
      LET g_rvv[l_ac].rvv81=b_rvv.rvv81
      LET g_rvv[l_ac].rvv82=b_rvv.rvv82
      LET g_rvv[l_ac].rvv83=b_rvv.rvv83
      LET g_rvv[l_ac].rvv84=b_rvv.rvv84
      LET g_rvv[l_ac].rvv85=b_rvv.rvv85
      LET g_rvv[l_ac].rvv86=b_rvv.rvv86
      CALL t720_set_rvv87()
        IF g_sma.sma116 MATCHES '[02]' THEN
           LET g_rvv[l_ac].rvv87 = g_rvv[l_ac].rvv17
        END IF
        IF cl_null(l_rvb07) THEN LET l_rvb07=0 END IF
        IF g_rvv[l_ac].rvv17= l_rvb07 THEN
           LET g_rvv[l_ac].rvv87 = l_rvv87_o
        END IF 
      LET b_rvv.rvv87=g_rvv[l_ac].rvv87
      LET g_rvv[l_ac].rvv87=b_rvv.rvv87
      IF cl_null(b_rvv.rvv32) THEN #BugNo:5611
          SELECT ima35,ima36
            INTO g_rvv[l_ac].rvv32,g_rvv[l_ac].rvv33
            FROM ima_file
           WHERE ima01 = g_rvv[l_ac].rvv31      #No.TQC-920090 add
          LET g_rvv[l_ac].rvv34 = ' '
          IF g_azw.azw04 = '2' THEN  
             #FUN-C90049 mark begin---
             #SELECT rtz07 INTO l_rtz07 FROM rtz_file #MOD-9C0016 del rtz08
             #    WHERE rtz01 = g_rvu.rvuplant
             #FUN-C90049 mark end-----
             CALL s_get_coststore(g_rvu.rvuplant,g_rvv[l_ac].rvv31) RETURNING l_rtz07    #FUN-C90049 add
            #FUN-B40098 Begin---
            #IF g_rvu.rvu21 = '3' THEN #FUN-B60150 ADD
             IF g_rvu.rvu21 = '3' OR (g_rvu.rvu27 = '2' AND g_sma.sma146 = '2') THEN #FUN-B60150 ADD
                #FUN-C90049 mark begin---
                #SELECT rtz08 INTO l_rtz07 FROM rtz_file
                # WHERE rtz01 = g_rvu.rvuplant
                #FUN-C90049 mark end-----
                CALL s_get_noncoststore(g_rvu.rvuplant,g_rvv[l_ac].rvv31) RETURNING l_rtz07    #FUN-C90049 add
             END IF
            #FUN-B40098 End-----
             LET g_rvv[l_ac].rvv32 = l_rtz07
          END IF
#FUN-AB0066 --begin--
#          #No.FUN-AA0049--begin
#          IF NOT s_chk_ware(g_rvv[l_ac].rvv32) THEN
#             LET g_rvv[l_ac].rvv32=' '
#             LET g_rvv[l_ac].rvv33=' '
#          END IF 
#          #No.FUN-AA0049--end               
#FUN-AB0066 --end--
      END IF
      #FUN-CB0087--add---str----
      IF g_aza.aza115 = 'Y' AND cl_null(g_rvv[l_ac].rvv26) THEN
         CALL s_reason_code(g_rvu.rvu01,g_rvu.rvu02,'',g_rvv[l_ac].rvv31,
                            g_rvv[l_ac].rvv32,g_rvu.rvu07,g_rvu.rvu06) RETURNING b_rvv.rvv26
         LET g_rvv[l_ac].rvv26 = b_rvv.rvv26  
      END IF
      #FUN-CB0087--add---end----
      LET g_rvv[l_ac].rvv35=b_rvv.rvv35
      LET g_rvv[l_ac].rvv35_fac=b_rvv.rvv35_fac
    #當不使用多單位時，單位一的換算率也不default值
      LET g_rvv[l_ac].rvv36=b_rvv.rvv36
      LET g_rvv[l_ac].rvv37=b_rvv.rvv37
      #FUN-B40083  --begin
      SELECT pmn123 INTO l_pmn123 FROM pmn_file
       WHERE pmn01=g_rvv[l_ac].rvv36
         AND pmn02=g_rvv[l_ac].rvv37
      IF cl_null(l_pmn123) THEN
         LET g_rvv[l_ac].pmn123 = l_pmn123
         SELECT mse02 INTO g_rvv[l_ac].mse02 FROM mse_file
          WHERE mse01= l_pmn123
      ELSE
         LET g_rvv[l_ac].pmn123 = ''
         LET g_rvv[l_ac].mse02 = ''
      END IF
      #FUN-B40083  --end      
      IF b_rvv.rvv87>0 THEN   #MOD-AA0165 rvv17-->rvv87
         CALL t720sub_rvv38(g_rvv[l_ac].rvv36,b_rvv.rvv38,b_rvv.rvv38t,g_rvu.rvu04,g_rvu.rvu01)  #TQC-C30225 add
                   RETURNING b_rvv.rvv38,b_rvv.rvv38t
         LET b_rvv.rvv39=b_rvv.rvv87*b_rvv.rvv38   #MOD-AA0165 rvv17-->rvv87
         LET b_rvv.rvv39t=b_rvv.rvv87*b_rvv.rvv38t  #No.FUN-540027   #MOD-AA0165 rvv17-->rvv87
             #MOD-C40047 str mark----
             #LET t_azi04=''    #No.CHI-6A0004
             #IF g_rva00 = '1' AND g_rvu.rvu00 = '3' THEN
             #   SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = g_rvu.rvu113
             #END IF
             #IF g_rva00 = '1' AND g_rvu.rvu00 <> '3' THEN
             #   SELECT azi04 INTO t_azi04  #No.CHI-6A0004
             #      FROM pmm_file,azi_file
             #     WHERE pmm22=azi01
             #       AND pmm01 = g_rvv[l_ac].rvv36 AND pmm18 <> 'X'
             #END IF
             #IF g_rva00 = '2' THEN
             #   SELECT rva113 INTO l_rva113 FROM rva_file WHERE rva01 = g_rvu02
             #   SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = l_rva113
             #END IF
             # IF cl_null(t_azi04) THEN                                                                                             
             #    SELECT azi04 INTO t_azi04                                                                                         
             #      FROM pmc_file,azi_file                                                                                          
             #     WHERE pmc22=azi01                                                                                                
             #       AND pmc01 = g_rvu.rvu04                                                                                        
             # END IF                                                                                                               
             #IF cl_null(t_azi04) THEN LET t_azi04=0 END IF   #No.CHI-6A0004
             #MOD-C40047 end mark----
              CALL t720_get_azi()                            #MOD-C40047 add
              CALL cl_digcut(b_rvv.rvv39,t_azi04)  #No.CHI-6A0004
                                RETURNING b_rvv.rvv39
              CALL cl_digcut(b_rvv.rvv39t,t_azi04)  #No.CHI-6A0004
                                RETURNING b_rvv.rvv39t   #No.FUN-540027
              #CALL t720sub_rvv39(g_rvv[l_ac].rvv36,b_rvv.rvv39,b_rvv.rvv39t,g_rvu.rvu04,g_rvu.rvu02) #FUN-A10130  #MOD-BC0262 mark 
              CALL t720sub_rvv39(g_rvv[l_ac].rvv36,b_rvv.rvv39,b_rvv.rvv39t,g_rvu.rvu04,g_rvu.rvu01)  #MOD-BC0262 add
                   RETURNING b_rvv.rvv39,b_rvv.rvv39t
      END IF
      #-----MOD-AA0165---------
      ##No.FUN-540027  計價數量計算
      #IF b_rvv.rvv17>0 THEN
      #   LET b_rvv.rvv39=b_rvv.rvv87*b_rvv.rvv38
      #   LET b_rvv.rvv39t=b_rvv.rvv87*b_rvv.rvv38t  #No.FUN-540027
      #        LET t_azi04=''  #No.CHI-6A0004
      #        IF g_rva00 = '1' AND g_rvu.rvu00 = '3' THEN
      #           SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = g_rvu.rvu113
      #        END IF
      #        IF g_rva00 = '1' AND g_rvu.rvu00 <> '3' THEN
      #           SELECT azi04 INTO t_azi04  #No.CHI-6A0004
      #              FROM pmm_file,azi_file
      #             WHERE pmm22=azi01
      #               AND pmm01 = g_rvv[l_ac].rvv36 AND pmm18 <> 'X'
      #        END IF
      #        IF g_rva00 = '2' THEN
      #           SELECT rva113 INTO l_rva113 FROM rva_file WHERE rva01 = g_rvu02
      #           SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = l_rva113
      #        END IF
      #         IF cl_null(t_azi04) THEN                                                                                             
      #            SELECT azi04 INTO t_azi04                                                                                         
      #              FROM pmc_file,azi_file                                                                                          
      #             WHERE pmc22=azi01                                                                                                
      #               AND pmc01 = g_rvu.rvu04                                                                                        
      #         END IF                                                                                                               
      #        IF cl_null(t_azi04) THEN LET t_azi04=0 END IF  #No.CHI-6A0004
      #        CALL cl_digcut(b_rvv.rvv39,t_azi04)  #No.CHI-6A0004
      #                          RETURNING b_rvv.rvv39
      #        CALL cl_digcut(b_rvv.rvv39t,t_azi04)  #No.CHI-6A0004
      #                          RETURNING b_rvv.rvv39t
      #        CALL t720sub_rvv39(g_rvv[l_ac].rvv36,b_rvv.rvv39,b_rvv.rvv39t,g_rvu.rvu04,g_rvu.rvu02) #FUN-A10130   
      #             RETURNING b_rvv.rvv39,b_rvv.rvv39t
      #END IF
      #-----END MOD-AA0165-----
      LET g_rvv[l_ac].rvv38=b_rvv.rvv38
      LET g_rvv[l_ac].rvv39=b_rvv.rvv39
      LET g_rvv[l_ac].rvv38t=b_rvv.rvv38t   #No.FUN-610018
      LET g_rvv[l_ac].rvv39t=b_rvv.rvv39t   #No.FUN-610018
      LET b_rvv.rvv40 = 'N'            #no.5748(default非沖暫估)
      LET b_rvv.rvv41 = l_rvb25        #no.A050(add 手冊編號)
      BEGIN WORK LET g_success = 'Y'
      IF cl_null(b_rvv.rvv32) THEN LET b_rvv.rvv32=' ' END IF
      IF cl_null(b_rvv.rvv33) THEN LET b_rvv.rvv33=' ' END IF
      IF cl_null(b_rvv.rvv34) THEN LET b_rvv.rvv34=' ' END IF
      IF cl_null(b_rvv.rvv02) THEN LET b_rvv.rvv02 = 1 END IF
      LET b_rvv.rvv88 = 0  #No.TQC-7B0083
      
      IF g_rvu.rvu00 = '3' AND g_rvu.rvu116 = '3' THEN
         LET b_rvv.rvv17 = 0
         LET b_rvv.rvv87 = 0
         LET b_rvv.rvv38 = 0
         LET b_rvv.rvv38t = 0
         LET b_rvv.rvv39 = 0
         LET b_rvv.rvv39t = 0
      END IF
      #TQC-C70086 add begin----------------
      IF b_rvv.rvv25 = 'Y' THEN 
         LET b_rvv.rvv38 = 0
         LET b_rvv.rvv38t = 0
         LET b_rvv.rvv39 = 0
         LET b_rvv.rvv39t = 0
      END IF 
      #TQC-C70086 add end -----------------
      
      IF b_rvv.rvv10 IS NULL THEN LET b_rvv.rvv10 = '4' END IF  #NO.FUN-9C0075 add
   #流通代銷無收貨單,將發票記錄rvb22同時新增到rvv22內
   #FUN-BB0001 add START
      IF NOT cl_null(b_rvv.rvv04) AND NOT cl_null(b_rvv.rvv05) THEN
          SELECT rvb22 INTO b_rvv.rvv22 FROM rvb_file WHERE rvb01 = b_rvv.rvv04 AND rvb02 = b_rvv.rvv05
      END IF
   #FUN-BB0001 add END
      INSERT INTO rvv_file VALUES(b_rvv.*)
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","rvv_file",b_rvv.rvv01,b_rvv.rvv02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
         ROLLBACK WORK
         CONTINUE FOREACH
      END IF
 
      SELECT ima918,ima921 INTO g_ima918,g_ima921 
        FROM ima_file
       WHERE ima01 = b_rvv.rvv31
         AND imaacti = "Y"
      
      IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
         IF g_sma.sma90 = "Y" THEN #MOD-C30074 add
            CALL t720sub_ins_rvbs(g_prog,b_rvv.rvv01,b_rvv.rvv02,
                               b_rvv.rvv04,b_rvv.rvv05,b_rvv.rvv31,
                               b_rvv.rvv32,b_rvv.rvv33,b_rvv.rvv34,g_rvu.rvu02) #FUN-A10130
         END IF #MOD-C30074 add
      END IF
 
      IF g_success='Y' THEN
         COMMIT WORK
      ELSE
         ROLLBACK WORK
      END IF
   END FOREACH
 
   CALL t720_b_fill(' 1=1')
 
END FUNCTION
 
#-----CHI-B40011---------
#移到sub裡
#FUNCTION t720_chkpoz011()  #檢查是否為正拋入庫
# DEFINE l_poz011 LIKE poz_file.poz011
# DEFINE l_rvv36 LIKE rvv_file.rvv36
# DEFINE l_pmm901 LIKE pmm_file.pmm901
# 
#   DECLARE rvv36_curs CURSOR FOR
#    SELECT rvv36 FROM rvv_file WHERE rvv01 = g_rvu.rvu01
#   FOREACH rvv36_curs INTO l_rvv36
#      SELECT pmm901 INTO l_pmm901 FROM pmm_file WHERE pmm01 = l_rvv36
#      IF cl_null(l_pmm901) OR l_pmm901 = 'N' THEN RETURN 0 END IF
#      SELECT poz011 INTO l_poz011 FROM poz_file,pmm_file
#       WHERE pmm01 = l_rvv36 AND pmm904 = poz01
#      IF SQLCA.sqlcode THEN LET l_poz011 = '' END IF
#      IF cl_null(l_poz011) OR l_poz011 = '2' THEN
#   RETURN 0
#      END IF
#   END FOREACH
#   RETURN 1
#END FUNCTION

#FUNCTION t720_set_poz()
#DEFINE l_poz   RECORD LIKE poz_file.*
#DEFINE l_poy   RECORD LIKE poy_file.*
#DEFINE l_pov1   RECORD LIKE pov_file.*
#DEFINE l_pov2   RECORD LIKE pov_file.*
#DEFINE l_occ   RECORD LIKE occ_file.*
#DEFINE l_poz01 LIKE poz_file.poz01
#DEFINE l_dbs  LIKE azp_file.azp03
#DEFINE l_n,l_cnt LIKE type_file.num5
#DEFINE l_pmc   RECORD LIKE pmc_file.*
#DEFINE l_sql   STRING
#DEFINE l_rvu24 LIKE rvu_file.rvu24
# 
#    LET l_sql = "SELECT * FROM pmc_file",
#                " WHERE pmc01 = '",g_rvu.rvuplant,"' AND pmc05='1'",
#                "   AND pmc903 = 'Y'"
#    PREPARE pmc_cs1 FROM l_sql
#    EXECUTE pmc_cs1 INTO l_pmc.*
# 
#    LET l_sql = "SELECT * FROM pov_file",
#                " WHERE pov01 = '1' AND pov02 = '",g_rvu.rvuplant,"'"
#    PREPARE pov_cs FROM l_sql
#    EXECUTE pov_cs INTO l_pov1.*
# 
#    CALL t720sub_azp(g_rvu.rvu04) RETURNING l_dbs #FUN-A10130
#    LET l_dbs = s_dbstring(l_dbs CLIPPED)
#  # LET l_sql = "SELECT * FROM ",l_dbs,"pov_file",                             #FUN-A50102 mark
#    LET l_sql = "SELECT * FROM ",cl_get_target_table(g_rvu.rvu04,'pov_file'),  #FUN-A50102
#                 " WHERE pov01 = '1'",
#                 "   AND pov02 = '",g_rvu.rvu04 CLIPPED,"'"
#     CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
#     CALL cl_parse_qry_sql(l_sql,g_rvu.rvu04) RETURNING l_sql  #FUN-A50102
#     PREPARE pov_pre FROM l_sql
#     EXECUTE pov_pre INTO l_pov2.*
#     
#   # LET l_sql = "SELECT * FROM ",l_dbs,"occ_file",                            #FUN-A50102 mark
#     LET l_sql = "SELECT * FROM ",cl_get_target_table(g_rvu.rvu04,'occ_file'), #FUN-A50102 
#                " WHERE pmc01 = '",g_rvu.rvu04 CLIPPED,"'"
#     CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102 
#     CALL cl_parse_qry_sql(l_sql,g_rvu.rvu04) RETURNING l_sql  #FUN-A50102
#     PREPARE occ_cs FROM l_sql
#     EXECUTE occ_cs INTO l_occ.*
# 
#     DECLARE poz_cs CURSOR FOR SELECT poz01 FROM poz_file
#                                WHERE poz00 = '2' 
#                                  AND poz011='1' AND poz12 = 'Y'
#     FOREACH poz_cs INTO l_poz01
#       SELECT COUNT(poy02) INTO l_cnt FROM poy_file
#        WHERE poy01 = l_poz01
#       IF l_cnt=2 THEN
#             SELECT COUNT(*) INTO l_n FROM poy_file a,poy_file b
#              WHERE a.poy01 = l_poz01
#                AND a.poy02 = (SELECT MIN(poy02) FROM poy_file WHERE poy01 = l_poz01)
#                AND a.poy04 = g_rvu.rvuplant AND a.poy03 = g_rvu.rvuplant
#                AND a.poy01 = b.poy01
#                AND b.poy02 = (SELECT MAX(poy02) FROM poy_file WHERE poy01 = l_poz01)
#                AND b.poy04 = g_rvu.rvu04 AND b.poy03 = g_rvu.rvu04
#             IF l_n > 0 THEN
#                LET l_rvu24 = l_poz01
#                UPDATE rvu_file SET rvu24 = l_poz01 WHERE rvu01 = g_rvu.rvu01
#                EXIT FOREACH
#             END IF
#       END IF
#    END FOREACH
#    IF NOT cl_null(l_rvu24) THEN
#       RETURN
#    END IF
#    SELECT MAX(poz01)+1 INTO l_poz.poz01 FROM poz_file
#    LET l_poz.poz01 = l_poz.poz01 USING '&&&&&&&&'
#    LET l_poz.poz02 = g_rvu.rvuplant CLIPPED,">>",g_rvu.rvu04 CLIPPED
#    LET l_poz.poz00 = '2'
#    LET l_poz.poz011 = '1'
#    LET l_poz.poz12 = 'Y'
#    LET l_poz.poz20 = 'N'
#    LET l_poz.poz09 = 'N'
#    LET l_poz.poz10 = 'N'
#    LET l_poz.poz13 = g_rvu.rvuplant
#    LET l_poz.poz14 = g_rvu.rvu04
#    LET l_poz.pozacti = 'Y'
#    LET l_poz.pozuser = g_user
#    LET l_poz.pozgrup = g_grup
#    LET l_poz.pozmodu = ' '
#    LET l_poz.pozdate = g_today
#    LET l_poz.poz17 = 'Y'
#    LET l_poz.poz18 = ' '
#    LET l_poz.poz19 = 'N'
#    LET l_poz.pozoriu = g_user      #No.FUN-980030 10/01/04
#    LET l_poz.pozorig = g_grup      #No.FUN-980030 10/01/04
#    INSERT INTO poz_file VALUES (l_poz.*)
#     IF SQLCA.sqlcode THEN
#        CALL cl_err3("ins","poz_file",l_poz.poz01,"",SQLCA.sqlcode,"","",1)
#        LET g_success = 'N'
#        RETURN
#     END IF
#     #INSRET 第0站
#     LET l_poy.poy01 = l_poz.poz01
#     LET l_poy.poy02 = 0
#     LET l_poy.poy03 = g_rvu.rvuplant
#     LET l_poy.poy04 = g_rvu.rvuplant
#     LET l_poy.poy05 = l_pmc.pmc22
#     LET l_poy.poy06 = l_pmc.pmc17
#     LET l_poy.poy07 = ' '
#     LET l_poy.poy08 = ' '
#     LET l_poy.poy09 = l_pmc.pmc47
#     LET l_poy.poy10 = ' '
#     LET l_poy.poy11 = l_pov1.pov04
#     LET l_poy.poy12 = ' '
#     LET l_poy.poy13 = l_pov1.pov07
#     LET l_poy.poy14 = ' '
#     LET l_poy.poy15 = l_poy.poy05
#     LET l_poy.poy16 = ' '
#     LET l_poy.poy17 = l_pov1.pov07
#     LET l_poy.poy18 = ' '
#     LET l_poy.poy19 = g_grup
#     LET l_poy.poy20 = ' '
#     LET l_poy.poy26 = ' '
#     LET l_poy.poy27 = ' '
#     LET l_poy.poy28 = ' '
#     LET l_poy.poy29 = ' '
#     SELECT pmc1913 INTO l_poy.poy30  FROM pmc_file
#      WHERE pmc01 = l_pov1.pov27
#     LET l_poy.poy31 = ' '
#     LET l_poy.poy32 = ' '
#     LET l_poy.poy33 = ' '
#     LET l_poy.poy34 = ' '
#     LET l_poy.poy35 = l_pov1.pov14
#     LET l_poy.poy36 = ' '
#     LET l_poy.poy37 = l_pov1.pov16
#     LET l_poy.poy38 = l_pov1.pov17
#     LET l_poy.poy39 = ' '
#     LET l_poy.poy40 = l_pov1.pov19
#     LET l_poy.poy41 = ' '
#     LET l_poy.poy42 = l_pov1.pov21
#     LET l_poy.poy43 = ' '
#     LET l_poy.poy44 = l_pov1.pov23
#     LET l_poy.poy45 = ' '
#     LET l_poy.poy46 = l_pov1.pov25
#     LET l_poy.poy47 = ' '
#     INSERT INTO poy_file VALUES (l_poy.*)
#     IF SQLCA.sqlcode THEN
#        CALL cl_err3("ins","poy_file",l_poy.poy01,"",SQLCA.sqlcode,"","",1)
#        LET g_success = 'N'
#        RETURN
#     END IF
#      #INSRET 第1站
#     LET l_poy.poy01 = l_poz.poz01
#     LET l_poy.poy02 = 1
#     LET l_poy.poy03 = g_rvu.rvu04
#     LET l_poy.poy04 = g_rvu.rvu04
#     LET l_poy.poy05 = l_pmc.pmc22
#     LET l_poy.poy06 = ''
#     LET l_poy.poy07 = l_occ.occ45
#     LET l_poy.poy08 = l_occ.occ41
#     LET l_poy.poy09 = ''
#     LET l_poy.poy10 = l_occ.occ43
#     LET l_poy.poy11 = l_pov2.pov04
#     LET l_poy.poy12 = ''
#     LET l_poy.poy13 = ''
#     LET l_poy.poy14 = ' '
#     LET l_poy.poy15 = l_poy.poy05
#     LET l_poy.poy16 = l_pov2.pov06
#     LET l_poy.poy17 = ' '
#     LET l_poy.poy18 = l_pov2.pov09
#     LET l_poy.poy19 = ' '
#     LET l_poy.poy20 = l_pov2.pov10
#     LET l_poy.poy26 = l_pov2.pov11
#     LET l_poy.poy27 = ''
#     LET l_poy.poy28 = ''
#     LET l_poy.poy29 = ''
#     LET l_poy.poy30 = ' '
#     LET l_poy.poy31 = l_occ.occ1705
#     LET l_poy.poy32 = l_pov2.pov12
#   # LET l_sql = "SELECT tqk02 FROM ",l_dbs,"tqk_file",                            #FUN-A50102 mark
#     LET l_sql = "SELECT tqk02 FROM ",cl_get_target_table(g_rvu.rvu04,'tqk_file'), #FUN-A50102
#                 " WHERE tqk01 = ?"
#     CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
#     CALL cl_parse_qry_sql(l_sql,g_rvu.rvu04) RETURNING l_sql  #FUN-A50102
#     PREPARE tqk_pre  FROM l_sql
#     EXECUTE tqk_pre INTO l_poy.poy33 USING l_occ.occ01
#     LET l_poy.poy34 = l_pov2.pov13
#     LET l_poy.poy35 = ' '
#     LET l_poy.poy36 = l_pov2.pov15
#     LET l_poy.poy37 = ' '
#     LET l_poy.poy38 = ' '
#     LET l_poy.poy39 = l_pov2.pov18
#     LET l_poy.poy40 = ' '
#     LET l_poy.poy41 = l_pov2.pov20
#     LET l_poy.poy42 = ' '
#     LET l_poy.poy43 = l_pov2.pov22
#     LET l_poy.poy44 = ' '
#     LET l_poy.poy45 = l_pov2.pov25
#     LET l_poy.poy46 = ' '
#     LET l_poy.poy47 = l_pov2.pov26
#     INSERT INTO poy_file VALUES (l_poy.*)
#     IF SQLCA.sqlcode THEN
#        CALL cl_err3("ins","poy_file",l_poy.poy01,"",SQLCA.sqlcode,"","",1)
#        LET g_success = 'N'
#        RETURN
#     END IF
#     UPDATE rvu_file SET rvu24 = l_poz.poz01 WHERE rvu01 = g_rvu.rvu01
#     IF SQLCA.sqlcode THEN
#        CALL cl_err3("upd","rvu_file",g_rvu.rvu01,"",SQLCA.sqlcode,"","",1)
#        LET g_success = 'N'
#        RETURN
#     END IF
#END FUNCTION
#-----END CHI-B40011-----
 
FUNCTION t720_chk_poz()
DEFINE l_rvb04  LIKE rvb_file.rvb04
DEFINE l_poz011 LIKE poz_file.poz011
DEFINE l_poz01  LIKE poz_file.poz01
DEFINE l_poz18  LIKE poz_file.poz18,
       l_poz19  LIKE poz_file.poz19,
       l_c      LIKE type_file.num5
DEFINE l_poy04  LIKE poy_file.poy04
DEFINE l_poy02  LIKE poy_file.poy02
 
     LET g_errno = ' '
     DECLARE rvb04_cs CURSOR FOR
      SELECT UNIQUE(rvb04) FROM rvb_file WHERE rvb01 = g_rvu.rvu02
     FOREACH rvb04_cs INTO l_rvb04
          IF NOT cl_null(l_rvb04) THEN EXIT FOREACH END IF
     END FOREACH
     SELECT poz011,poz01 INTO l_poz011,l_poz01
       FROM pmm_file,poz_file
      WHERE pmm904 = poz01
        AND pmm01  = l_rvb04
        AND pmm901 = 'Y'         #三角貿易否
        AND pmm905 = 'Y'         #已拋轉
        AND pmm02  = 'TAP'       #代採買性質
     IF SQLCA.sqlcode THEN LET l_poz011 = '' END IF
    #pmm02性質有可能TAP/TRI
     SELECT poz01,poz18,poz19,poz011 INTO l_poz01,l_poz18,l_poz19,l_poz011
       FROM pmm_file,poz_file
      WHERE pmm904 = poz01
        AND pmm01  = l_rvb04
        AND pmm901 = 'Y'         #三角貿易否
        AND pmm905 = 'Y'         #已拋轉
 
      LET l_c = 0
     IF l_poz19 = 'Y'  AND g_plant=l_poz18 THEN    #已設立中斷點
         SELECT COUNT(*) INTO l_c   #check poz18設定的中斷營運中心是否存在單身設>
           FROM poy_file
         WHERE poy01 = l_poz01
           AND poy04 = l_poz18
     END IF
     IF l_c > 0 THEN
         SELECT rva10 INTO g_rvu.rvu08 FROM rva_file
          WHERE rva01 = g_rvu.rvu02
         IF cl_null(g_rvu.rvu08) THEN
            LET g_rvu.rvu08='TAP'
         END IF
     ELSE
         IF (g_rvu.rvu08='TRI' OR g_rvu.rvu08='TAP') AND NOT cl_null(g_rvu.rvu99) THEN #TQC-7C0063  #MOD-7C0052
            LET l_c = 0  
            SELECT COUNT(*) INTO l_c  FROM poy_file
             WHERE poy01 = l_poz01
               AND poy02 = '0'
               AND poy04 = g_plant
            IF l_c = 0 THEN 
               LET g_errno = 'apm-015'  #TQC-820011 add
               RETURN             
            END IF
         END IF   #FUN-830035 add
         IF g_rvu.rvu00 = '1' OR g_rvu.rvu00 = '2' THEN
            IF (cl_null(l_poz011) OR l_poz011 <> '1')
               AND NOT cl_null(g_rvu.rvu99)  THEN # TQC-7C0073
               LET g_errno='apm-015'
            END IF
            #代採正拋,非中斷點,入庫單應不可取消確認
            IF l_poz011='1'  AND NOT cl_null(g_rvu.rvu99)  THEN 
               LET g_errno='axm-316'
               RETURN
            END IF 
         END IF
     END IF   #MOD-7C0052 add
 
     IF g_rvu.rvu00 = '3' THEN #若為倉退
       #IF cl_null(l_poz011) OR l_poz011 <> '1' THEN #MOD-D20003 mark
        IF cl_null(l_poz011) THEN                    #MOD-D20003 add
           LET g_errno='axm-413'  #TQC-8A0071
           #MOD-860279 add  中斷點的判斷
           IF l_poz19 = 'Y' AND (g_plant=l_poz18) THEN 
              LET g_errno=' '
           END IF
           #MOD-860279 add  中斷點的判斷
        END IF
       #代採正拋,非中斷點,入庫單應不可取消確認
       IF l_poz011='1'  AND NOT cl_null(g_rvu.rvu99)  THEN 
          LET g_errno='axm-316'
          RETURN
       END IF 
        SELECT * INTO g_poz.* FROM poz_file WHERE poz01 = l_poz01
        IF STATUS = 100 THEN LET g_errno = 'apm-015' END IF #no.7176
        SELECT MIN(poy02) INTO l_poy02 FROM poy_file WHERE poy01=l_poz01
        SELECT poy04 INTO l_poy04 FROM poy_file WHERE poy01=l_poz01 AND poy02=l_poy02	  #MOD-9B0004
        IF g_plant <> l_poy04 THEN
           LET g_errno ='apm-020'
        END IF
     END IF
END FUNCTION
 
#genero
FUNCTION t720_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
   IF (NOT g_before_input_done) THEN
      #CALL cl_set_comp_entry("rvu01,rvu10,rvu111,rvu112",TRUE) #MOD-530452  #TQC-9A0094 add rvu111,rvu112
      CALL cl_set_comp_entry("rvu01,rvu10",TRUE)     #MOD-B30544
      IF cl_null(g_rvu.rvu02) THEN
         CALL cl_set_comp_entry("rvu111,rvu112,rvu113,rvu115",TRUE)  #MOD-B30544
      END IF
   END IF
   IF INFIELD(rvu01) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("rvu02",TRUE)
   END IF
 
   IF INFIELD(rvu02) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("rvu04,rvu05,rvu08",TRUE)
   END IF
 
   IF INFIELD(rvu04) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("rvu05",TRUE)
   END IF
   IF g_prog='apmt742' THEN
      CALL cl_set_comp_required("rvu02",g_azw.azw04!='2')
   END IF
 
END FUNCTION
 
FUNCTION t720_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
DEFINE   l_n       LIKE type_file.num5    #No.FUN-680136 SMALLINT
 
   IF (NOT g_before_input_done) THEN
       IF p_cmd = 'u' AND g_chkey matches'[Nn]' THEN
           CALL cl_set_comp_entry("rvu01",FALSE)
       END IF
        IF g_argv1 = '1' THEN                  #MOD-530452
           CALL cl_set_comp_entry("rvu10",FALSE)
       END IF
       IF NOT cl_null(g_rvu.rvu02) THEN
          CALL cl_set_comp_entry("rvu111,rvu112,rvu113,rvu115",FALSE)  #MOD-B30544
       END IF
   END IF
 
   IF INFIELD(rvu01) OR (NOT g_before_input_done) THEN
       SELECT COUNT(*) INTO l_n FROM rvv_file
        WHERE rvv01=g_rvu.rvu01
          AND rvv03=g_rvu.rvu00
       IF l_n > 0 THEN
           CALL cl_set_comp_entry("rvu02",FALSE)
       END IF
   END IF
 
   IF INFIELD(rvu02) OR (NOT g_before_input_done) THEN
       IF NOT cl_null(g_rvu.rvu02) THEN
         #CALL cl_set_comp_entry("rvu04,rvu08",FALSE)
          CALL cl_set_comp_entry("rvu04,rvu08,rvu111,rvu112,rvu113,rvu115",FALSE)  #MOD-B30544
       END IF
       IF NOT cl_null(g_rvu.rvu04) THEN
         IF g_rvu.rvu04[1,4] != 'MISC' THEN
           CALL cl_set_comp_entry("rvu05",FALSE)
         END IF
       END IF
   END IF
 
   IF INFIELD(rvu04) OR (NOT g_before_input_done) THEN
       IF g_rvu.rvu04[1,4] != 'MISC' THEN
           CALL cl_set_comp_entry("rvu05",FALSE)
       END IF
   END IF
   CALL cl_set_comp_entry("rvu00",FALSE)    #No.MOD-890106
 
END FUNCTION
 
FUNCTION t720_set_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
DEFINE   l_ima903  LIKE ima_file.ima903   #MOD-D40048 add
 
   IF NOT g_before_input_done THEN
       CALL cl_set_comp_entry("rvv35,rvv25",TRUE)
       CALL cl_set_comp_entry("rvv41",TRUE)
   END IF
 
   IF INFIELD(rvv05) OR p_cmd = 'u' THEN
      #MOD-D40048 add
       IF g_before_input_done THEN
          SELECT ima903 INTO l_ima903 FROM ima_file WHERE ima01 = g_rvv[l_ac].rvv31
          IF g_rvv[l_ac].rvv31[1,4] = 'MISC' OR l_ima903 = 'Y' THEN
      #MOD-D40048 add
             CALL cl_set_comp_entry("rvv31",TRUE)
             CALL cl_set_comp_entry("rvv031",TRUE)
             CALL cl_set_comp_entry("rvv31,rvv32,rvv33",TRUE)
     #MOD-D40048 add start -----
         END IF
      END IF
     #MOD-D40048 add end   -----
   END IF
 
    CALL cl_set_comp_entry("rvv83,rvv85,rvv86,rvv87",TRUE)
 
   IF INFIELD(rvv31)  THEN
      CALL cl_set_comp_entry("rvv031",TRUE)
   END IF
  #MOD-D40048 add
   IF g_before_input_done THEN
      SELECT ima903 INTO l_ima903 FROM ima_file WHERE ima01 = g_rvv[l_ac].rvv31
      IF g_rvv[l_ac].rvv31[1,4] = 'MISC' OR l_ima903 = 'Y' THEN
  #MOD-D40048 add
         CALL cl_set_comp_entry("rvv31",TRUE) #FUN-A20017
  #MOD-D40048 add start -----
      END IF 
   END IF 
  #MOD-D40048 add end   -----
      IF g_sma.sma120='Y' THEN
         CALL cl_set_comp_entry("att00,att01,att01_c,att02,att02_c,att03,att03_c,                                                                                                       att04,att04_c,att05,att05_c,att06,att06_c,att07,                                                                                                       att07_c,att08,att08_c,att09,att09_c,att10,                              att10_c ",TRUE) 
      END IF
    IF g_prog='apmt742' THEN
       CALL cl_set_comp_required("rvv05",g_azw.azw04<>'2')
    END IF
 
END FUNCTION
 
FUNCTION t720_set_no_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
DEFINE   l_tmp     LIKE type_file.chr5    #No.FUN-680136 VARCHAR(05)  #No.FUN-550060
DEFINE   l_smy57_5 LIKE type_file.chr1    #No.FUN-680136 VARCHAR(01)
DEFINE   l_cnt     LIKE type_file.num5          #NO.FUN-670007  #No.FUN-680136 SMALLINT
DEFINE   l_pmn41   LIKE pmn_file.pmn41    #No.TQC-940140 add
DEFINE   l_pmn43   LIKE pmn_file.pmn43    #No.TQC-940140 add
DEFINE   l_ima903  LIKE ima_file.ima903   #FUN-A20017
DEFINE   l_gec07   LIKE gec_file.gec07    #MOD-C30025 add
 
   IF NOT g_before_input_done THEN
       IF NOT cl_null(g_rvu.rvu02) THEN
           CALL cl_set_comp_entry("rvv35",FALSE)
           CALL cl_set_comp_entry("rvv80",FALSE)
           CALL cl_set_comp_entry("rvv83",FALSE)
           CALL cl_set_comp_entry("rvv86",FALSE)
       END IF
   END IF
 
   #FUN-A20017--begin--add----
   #IF l_ac > 0 THEN   #MOD-A80146
   IF l_ac > 0 AND g_before_input_done  THEN   #MOD-A80146  
      IF NOT cl_null(g_rvv[l_ac].rvv05)  THEN
         SELECT ima903 INTO l_ima903
           FROM ima_file,pmn_file
          WHERE pmn01 = g_rvv[l_ac].rvv36
            AND pmn02 = g_rvv[l_ac].rvv37
            AND ima01 = pmn04
      END IF
      IF g_argv3 <> 'SUB' OR l_ima903 = 'N' OR cl_null(l_ima903) THEN
         CALL cl_set_comp_entry("rvv31",FALSE)
      END IF
   END IF  
   #FUN-A20017--end---
   
   IF p_cmd = 'u' THEN
      IF NOT cl_null(g_rvv[l_ac].rvv25) THEN
          CALL cl_set_comp_entry("rvv25",FALSE)
      END IF
   END IF
 
   IF g_before_input_done THEN
   IF g_rvv[l_ac].rvv31[1,4] != 'MISC' AND INFIELD(rvv31) THEN
      CALL cl_set_comp_entry("rvv031",FALSE)
   END IF
   END IF
 
   IF INFIELD(rvv05) OR p_cmd = 'u' THEN
      IF NOT cl_null(g_rvu.rvu02) AND NOT cl_null(g_rvv[l_ac].rvv05) THEN
#FUN-A20017--begin-判斷非ICD行業下才需做此處理
         IF g_argv3 <> 'SUB' OR l_ima903 = 'N' OR cl_null(l_ima903) THEN
            CALL cl_set_comp_entry("rvv31",FALSE)
         END IF
#FUN-A20017--end---
          CALL cl_set_comp_entry("rvv35",FALSE)
          CALL cl_set_comp_entry("rvv83",FALSE)
          CALL cl_set_comp_entry("rvv80",FALSE)
          CALL cl_set_comp_entry("rvv86",FALSE)
      END IF
      IF g_rvv[l_ac].rvv31[1,4] != 'MISC' THEN
           CALL cl_set_comp_entry("rvv031",FALSE)
      END IF
      IF g_rvv[l_ac].rvv31[1,4] = 'MISC' THEN
          CALL cl_set_comp_entry("rvv32,rvv33,rvv34",FALSE)
      END IF
      LET l_tmp=''
      LET l_smy57_5=''
      LET l_tmp=g_rvv[l_ac].rvv36
      SELECT smy57[5,5] INTO l_smy57_5 FROM smy_file WHERE smyslip=l_tmp
      IF g_aza.aza27 != 'Y' OR l_smy57_5 != 'Y' THEN
          CALL cl_set_comp_entry("rvv41",FALSE)
      END IF
   END IF
    IF g_ima906 = '1' THEN
       CALL cl_set_comp_entry("rvv83,rvv84,rvv85",FALSE)
    END IF
    IF g_ima906 = '2' THEN
       CALL cl_set_comp_entry("rvv81,rvv84",FALSE)
    END IF
    #參考單位，每個料件只有一個，所以不開放讓用戶輸入
    IF g_ima906 = '3' THEN
       CALL cl_set_comp_entry("rvv83",FALSE)
    END IF
    IF g_sma.sma116 MATCHES '[02]' THEN    #No.FUN-610076
       CALL cl_set_comp_entry("rvv86,rvv87",FALSE)
    END IF
    IF cl_null(g_rvu.rvu02) THEN
       CALL cl_set_comp_entry("rvv05",FALSE)
    ELSE
       CALL cl_set_comp_entry("rvv05",TRUE)
    END IF
  
    IF NOT cl_null(g_rvu.rvu117) THEN
       CALL cl_set_comp_entry("rvv17,rvv33,rvv33,rvv34",FALSE)
    ELSE
       CALL cl_set_comp_entry("rvv17,rvv33,rvv33,rvv34",TRUE)
    END IF
    IF g_rvu.rvu116 = '3' THEN 
    #FUN-D60130 -----Begin------
       IF g_rvu.rvu00 = '3' AND g_argv1 = '3' AND g_argv3 = 'SUB' THEN    
          CALL cl_set_comp_entry("rvv17",TRUE)
          CALL cl_set_comp_entry("rvv85,rvv82,rvv87",TRUE)
       ELSE
    #FUN-D60130 -----End--------
          CALL cl_set_comp_entry("rvv17",FALSE)
          CALL cl_set_comp_entry("rvv85,rvv82,rvv87",FALSE)   #MOD-CC0055 add
       END IF   #FUN-D60130 
    END IF 
    
    CALL cl_set_comp_entry("rvv32,rvv33,rvv34",TRUE)
    IF g_rvu.rvu08='SUB' AND g_before_input_done THEN   #MOD-970081
       IF NOT cl_null(g_rvv[l_ac].rvv36) AND NOT cl_null(g_rvv[l_ac].rvv37) THEN
          SELECT pmn41,pmn43 INTO l_pmn41,l_pmn43 FROM pmn_file
           WHERE pmn01 = g_rvv[l_ac].rvv36 AND pmn02 = g_rvv[l_ac].rvv37
          IF NOT cl_null(l_pmn41) AND l_pmn43>0 THEN   #W/O<>'' &製程序>0
             CALL cl_set_comp_entry("rvv32,rvv33,rvv34",FALSE)
          END IF
       END IF
    END IF
 
    #MOD-C30025 add by suncx sta 120305--------------------
   #IF g_prog='apmt722' THEN  #MOD-D20171 mark
    IF g_prog[1,7]='apmt722' OR g_prog[1,7]='aict044' OR g_prog[1,7]='apmt732' THEN  #MOD-D20171 add  #MOD-D30083 add aict044
       SELECT gec07 INTO l_gec07 FROM gec_file WHERE gec01 = g_rvu.rvu115
#TQC-C30225 add begin
       IF cl_null(l_gec07) THEN 
            #MOD-D30089 mark start -----
            #SELECT DISTINCT gec07 INTO l_gec07  FROM pmm_file,rvu_file,rva_file,gec_file 
            # WHERE pmm01 = rva02
            #   AND rva01 = rvu02
            #   AND rvu02 = g_rvu.rvu02
            #MOD-D30089 mark start -----
            #MOD-D30089 add end   -----
             IF g_before_input_done THEN
                SELECT DISTINCT gec07 INTO l_gec07 FROM pmm_file,rvb_file,gec_file 
                 WHERE rvb02 = g_rvv[l_ac].rvv05
                   AND rvb01 = g_rvu.rvu02
                   AND pmm01 = rvb04
            #MOD-D30089 add end  -----
                   AND pmm21 = gec01
             END IF #MOD-D30089 add
       END IF
#TQC-C30225 add end
       IF l_gec07 = 'Y' THEN   #含稅
          CALL cl_set_comp_entry("rvv38",FALSE)
          CALL cl_set_comp_entry("rvv38t",TRUE)
       ELSE
          CALL cl_set_comp_entry("rvv38t",FALSE)
          CALL cl_set_comp_entry("rvv38",TRUE)
       END IF
       CALL cl_set_comp_entry("rvv39,rvv39t",FALSE)
       CALL cl_set_comp_entry("rvv31",TRUE) #MOD-D80123
    END IF
    #MOD-C30025 add by suncx end 120305--------------------
 
END FUNCTION
 
FUNCTION t720_set_required(p_cmd)
  DEFINE p_cmd LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
  IF NOT g_before_input_done THEN
     IF NOT cl_null(g_rvu.rvu02) THEN
        CALL cl_set_comp_required("rvv05",TRUE)
     END IF
  END IF
  IF p_cmd = 'u' OR INFIELD(rvv31) THEN
     #IF g_rvv[l_ac].rvv31[1,4] != 'MISC' AND g_rvu.rvu00 !='2' THEN   #MOD-A40166
     IF g_rvv[l_ac].rvv31[1,4] != 'MISC' AND g_rvu.rvu00 ='1' THEN   #MOD-A40166
        CALL cl_set_comp_required("rvv32",TRUE)
     END IF
  END IF
    IF p_cmd IS NOT NULL THEN
    IF g_ima906 = '3' THEN
       CALL cl_set_comp_required("rvv83,rvv85,rvv80,rvv82",TRUE)
    END IF
    #單位不同,轉換率,數量必KEY
    IF NOT cl_null(g_rvv[l_ac].rvv80) THEN
       CALL cl_set_comp_required("rvv82",TRUE)
    END IF
    IF NOT cl_null(g_rvv[l_ac].rvv83) THEN
       CALL cl_set_comp_required("rvv85",TRUE)
    END IF
    IF g_sma.sma116 MATCHES '[13]' THEN    #MOD-630031 add #使用計價單位時
       CALL cl_set_comp_required("rvv87",TRUE)
    END IF
    END IF
END FUNCTION
 
FUNCTION t720_set_no_required(p_cmd)
  DEFINE p_cmd LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
  IF NOT g_before_input_done THEN
     CALL cl_set_comp_required("rvv05",FALSE)
  END IF
  CALL cl_set_comp_required("rvv32",FALSE)
  CALL cl_set_comp_required("rvv83,rvv84,rvv85,rvv80,rvv81,rvv82,rvv86,rvv87",FALSE)
END FUNCTION

#&ifdef ICD  #FUN-B50096
#FUN-A40022--begin--add---- 
FUNCTION t720_set_required_1(p_cmd)
#DEFINE l_imaicd13 LIKE imaicd_file.imaicd13  #FUN-B50096
DEFINE l_ima159   LIKE ima_file.ima159        #FUN-B50096
DEFINE p_cmd      LIKE type_file.chr1

   IF p_cmd='u' OR INFIELD(rvv31) THEN
      IF NOT cl_null(g_rvv[l_ac].rvv31) THEN
#FUN-B50096 --------------Begin---------------
#        SELECT imaicd13 INTO l_imaicd13 FROM imaicd_file
#         WHERE imaicd00 = g_rvv[l_ac].rvv31
#        IF l_imaicd13 = 'Y' THEN
         SELECT ima159 INTO l_ima159 FROM ima_file
          WHERE ima01 = g_rvv[l_ac].rvv31
         IF l_ima159 = '1' THEN   
#FUN-B50096 --------------End-----------------
            CALL cl_set_comp_required("rvv34",TRUE)
         END IF
      END IF
   END IF
END FUNCTION 

FUNCTION t720_set_no_required_1()
     CALL cl_set_comp_required("rvv34",FALSE)
END FUNCTION

#FUN-B50096 ---------------Begin----------------
FUNCTION t720_set_no_entry_rvv34()
DEFINE l_ima159   LIKE ima_file.ima159
  #IF l_ac > 0 THEN
   IF l_ac > 0 AND g_rec_b > 0 THEN    #TQC-BA0051
      IF NOT cl_null(g_rvv[l_ac].rvv31) THEN
         SELECT ima159 INTO l_ima159 FROM ima_file
          WHERE ima01 = g_rvv[l_ac].rvv31
         IF l_ima159 = '2' THEN
            CALL cl_set_comp_entry("rvv34",FALSE)
         ELSE
            CALL cl_set_comp_entry("rvv34",TRUE)  
         END IF
      END IF
   END IF
END FUNCTION

FUNCTION t720_set_entry_rvv34()
   CALL cl_set_comp_entry("rvv34",TRUE)
END FUNCTION
#FUN-B50096 ---------------End------------------

#CHI-B90021 ---------------Begin--------------
#FUNCTION t720_chk_rvv()                                                                                                             
#DEFINE l_n  LIKE type_file.num5                                                                                                     
#                                                                                                                                    
#  LET l_n = 0                                                                                                                       
#  SELECT COUNT(*) INTO l_n FROM rvv_file                                                                                            
#   WHERE rvv01 = g_rvu.rvu01                                                                                                        
#  IF l_n = 0 AND INT_FLAG THEN RETURN 1 ELSE RETURN 0 END IF                                                                        
#END FUNCTION
#CHI-B90021 ---------------End----------------
#FUN-A40022--end--add---------
#&endif    #FUN-B50096
 
#No.+046 010404 by plum add因必須考慮到參數sma894,最好都一致去call s_upimgg
FUNCTION t720_u_imgg_du(p_no)  #入庫的取消確認
    DEFINE l_imgg10  LIKE imgg_file.imgg10
    DEFINE l_imgg21  LIKE imgg_file.imgg21
   #DEFINE l_ima25   LIKE ima_file.ima25    #FUN-A10130
    DEFINE p_no      LIKE type_file.chr1    #No.FUN-680136 VARCHAR(01)
 
    IF cl_null(g_tlff.tlff12) THEN LET g_tlff.tlff12=1 END IF
    LET l_imgg10=g_tlff.tlff10
    IF cl_null(l_imgg10) THEN LET l_imgg10=0 END IF
 
    IF g_tlff.tlff03 != 50 AND g_tlff.tlff02 != 50 THEN RETURN END IF
    IF g_tlff.tlff02 = 50 THEN LET g_tlff.tlff10=g_tlff.tlff10*-1 END IF
    IF b_rvv.rvv31[1,4]='MISC' THEN RETURN END IF
 
    MESSAGE "update imgg_file ..."
    CALL ui.Interface.refresh()
 
    LET g_forupd_sql =
          " SELECT imgg01,imgg02,imgg03,imgg04,imgg09 FROM imgg_file ",
          "   WHERE imgg01= ? ",
          "    AND imgg02= ? ",
          "    AND imgg03= ? ",
          "    AND imgg04= ? ",
          "    AND imgg09= ? ",
          " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE imgg_lock_du_imgg CURSOR FROM g_forupd_sql
 
    OPEN imgg_lock_du_imgg USING g_tlff.tlff01,g_tlff.tlff031,g_tlff.tlff032,g_tlff.tlff033,g_tlff.tlff11
    IF STATUS THEN
       CALL cl_err("OPEN imgg_lock_du_imgg:", STATUS, 1)
       CLOSE imgg_lock_du_imgg
       #ROLLBACK WORK   #MOD-930261
       LET g_success='N'  #MOD-930261
       RETURN
    END IF
    FETCH imgg_lock_du_imgg INTO g_tlff.tlff01,g_tlff.tlff031,g_tlff.tlff032,g_tlff.tlff033,g_tlff.tlff11
    IF STATUS THEN
       CALL cl_err('imgg_lock_du_imgg fail',STATUS,1) LET g_success='N' RETURN
    END IF
    LET g_ima906=NULL LET g_ima907=NULL
    SELECT ima25,ima906,ima907 INTO g_ima25,g_ima906,g_ima907 #FUN-A10130
      FROM ima_file WHERE ima01=g_tlff.tlff01
    IF SQLCA.sqlcode OR g_ima25 IS NULL THEN  #FUN-A10130
       CALL cl_err('ima25 null',SQLCA.sqlcode,0)
       LET g_success = 'N' RETURN
    END IF
 
    CALL s_umfchk(g_tlff.tlff01,g_tlff.tlff11,g_ima25) #FUN-A10130
          RETURNING g_cnt,l_imgg21
    IF g_cnt = 1 AND NOT (g_ima906='3' AND p_no='2') THEN
       CALL cl_err('','mfg3075',0)
       LET g_success = 'N' RETURN
    END IF
 
    CALL s_upimgg(g_tlff.tlff01,g_tlff.tlff031,g_tlff.tlff032,g_tlff.tlff033,g_tlff.tlff11,-1,l_imgg10,g_today,   #FUN-8C0084
g_tlff.tlff01,g_tlff.tlff031,g_tlff.tlff032,g_tlff.tlff033,'','','','',g_tlff.tlff11,'',l_imgg21,'','','',0,0,'','',g_tlff.tlff12)
 
    IF STATUS OR g_success = 'N' THEN
       CALL cl_err('t2_upimgg(-1):','9050',0)
       LET g_success='N'
       RETURN
    END IF
 
END FUNCTION
 
FUNCTION t720_u_tlff() #------------------------------------ Update tlff_file
    MESSAGE "d_tlff!"
    CALL ui.Interface.refresh()
    DELETE FROM tlff_file WHERE ROWID  =  g_rowid
    IF STATUS THEN
       CALL cl_err3("del","tlff_file","","",STATUS,"","del tlff:",1)  #No.FUN-660129
       LET g_success='N' RETURN
    END IF
    IF SQLCA.SQLERRD[3]=0 THEN
       CALL cl_err('del tlff:','axm-176',1) LET g_success='N' RETURN
    END IF
END FUNCTION
 
FUNCTION t720_u_log_du() #------------------------------------ Update tlff_file
    MESSAGE "d_tlff!"
    DELETE FROM tlff_file WHERE ROWID  =  g_rowid
    IF STATUS THEN
       CALL cl_err3("del","tlff_file","","",STATUS,"","del tlff:",1)  #No.FUN-660129
       LET g_success='N' RETURN
    END IF
    IF SQLCA.SQLERRD[3]=0 THEN
       CALL cl_err('del tlff:','axm-176',1) LET g_success='N' RETURN
    END IF
END FUNCTION
 
#No.+046 010404 by plum add因必須考慮到參數sma894,最好都一致去call s_upimgg
FUNCTION t720_u_imgg(p_no)  #入庫的取消確認
    DEFINE l_imgg10  LIKE imgg_file.imgg10
   #DEFINE l_ima25   LIKE ima_file.ima25  #FUN-A10130
    DEFINE l_imgg21  LIKE imgg_file.imgg21
    DEFINE p_no      LIKE type_file.chr1    #No.FUN-680136 VARCHAR(01)
 
    LET l_imgg10=g_tlff.tlff10
    IF cl_null(l_imgg10) THEN LET l_imgg10=0 END IF
 
    IF g_tlff.tlff03 != 50 AND g_tlff.tlff02 != 50 THEN RETURN END IF
    IF g_tlff.tlff02 = 50 THEN LET g_tlff.tlff10=g_tlff.tlff10*-1 END IF
    IF b_rvv.rvv31[1,4]='MISC' THEN RETURN END IF
 
    MESSAGE "update imgg_file ..."
    CALL ui.Interface.refresh()
 
    LET g_forupd_sql =
          " SELECT imgg01,imgg02,imgg03,imgg04,imgg09 FROM imgg_file ",
          "   WHERE imgg01= ? ",
          "    AND imgg02= ? ",
          "    AND imgg03= ? ",
          "    AND imgg04= ? ",
          "    AND imgg09= ? ",
          " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE imgg_lock_u_imgg CURSOR FROM g_forupd_sql
 
    OPEN imgg_lock_u_imgg USING g_tlff.tlff01,g_tlff.tlff031,
                                g_tlff.tlff032,g_tlff.tlff033,g_tlff.tlff11
    IF STATUS THEN
       CALL cl_err("OPEN imgg_lock_u_imgg:", STATUS, 1)
       CLOSE imgg_lock_u_imgg
       LET g_success='N'  #MOD-930261
       RETURN
    END IF
    FETCH imgg_lock_u_imgg INTO g_tlff.tlff01,g_tlff.tlff031,g_tlff.tlff032,g_tlff.tlff033,g_tlff.tlff11
    IF STATUS THEN
       CALL cl_err('imgg_lock_u_imgg fail',STATUS,1) LET g_success='N' RETURN
    END IF
 
    LET g_ima906=NULL LET g_ima907=NULL
    SELECT ima25,ima906,ima907 INTO g_ima25,g_ima906,g_ima907 #FUN-A10130
      FROM ima_file WHERE ima01=g_tlff.tlff01
    IF SQLCA.sqlcode OR g_ima25 IS NULL THEN  #FUN-A10130
       CALL cl_err('ima25 null',SQLCA.sqlcode,0)
       LET g_success = 'N' RETURN
    END IF
 
    CALL s_umfchk(g_tlff.tlff01,g_tlff.tlff11,g_ima25)  #FUN-A10130
          RETURNING g_cnt,l_imgg21
    IF g_cnt = 1 AND NOT (g_ima906='3' AND p_no='2') THEN
       CALL cl_err('','mfg3075',0)
       LET g_success = 'N' RETURN
    END IF
 
    CALL s_upimgg(g_tlff.tlff01,g_tlff.tlff031,g_tlff.tlff032,g_tlff.tlff033,g_tlff.tlff11,-1,l_imgg10,g_today,  #FUN-8C0084
g_tlff.tlff01,g_tlff.tlff031,g_tlff.tlff032,g_tlff.tlff033,'','','','',g_tlff.tlff11,'',l_imgg21,'','','',0,0,'','',g_tlff.tlff12)
 
    IF STATUS OR g_success = 'N' THEN
       CALL cl_err('t2_upimgg(-1):','9050',0)
       LET g_success='N'
       RETURN
    END IF
 
END FUNCTION
 
#用于default 雙單位/轉換率/數量
FUNCTION t720_du_default(p_cmd)
 DEFINE    l_item   LIKE img_file.img01,     #料號
           l_ware   LIKE img_file.img02,     #倉庫
           l_loc    LIKE img_file.img03,     #儲
           l_lot    LIKE img_file.img04,     #批
          #l_ima25  LIKE ima_file.ima25,     #ima單位 #FUN-A10130
           l_ima44  LIKE ima_file.ima44,     #ima單位
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
           p_cmd    LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
           l_factor LIKE ima_file.ima31_fac     #No.FUN-680136 DECIMAL(16,8)
 
   LET l_item = g_rvv[l_ac].rvv31
   LET l_ware = g_rvv[l_ac].rvv32
   LET l_loc  = g_rvv[l_ac].rvv33
   LET l_lot  = g_rvv[l_ac].rvv34
 
   SELECT ima25,ima44,ima906,ima907 INTO g_ima25,l_ima44,l_ima906,l_ima907  #FUN-A10130
     FROM ima_file WHERE ima01 = l_item
 
   SELECT img09 INTO l_img09 FROM img_file
    WHERE img01 = l_item
      AND img02 = l_ware
      AND img03 = l_loc
      AND img04 = l_lot
 
   IF l_ima906 = '1' THEN  #不使用雙單位
      LET l_unit2 = NULL
      LET l_fac2  = NULL
      LET l_qty2  = NULL
   ELSE
      LET l_unit2 = l_ima907
      CALL s_du_umfchk(l_item,'','','',l_ima44,l_ima907,l_ima906)
           RETURNING g_errno,l_factor
      LET l_fac2 = l_factor
      LET l_qty2  = 0
   END IF
   LET l_unit1 = l_ima44
   LET l_fac1  = 1
   LET l_qty1  = 0
 
   IF g_sma.sma116 MATCHES '[02]' THEN    #No.FUN-610076
      LET l_unit3 = NULL
      LET l_qty3  = NULL
   ELSE
      LET l_unit3 = l_ima908
      LET l_qty3  = 0
   END IF
 
   IF p_cmd = 'a' THEN
      LET g_rvv[l_ac].rvv83=l_unit2
      LET g_rvv[l_ac].rvv84=l_fac2
      LET g_rvv[l_ac].rvv85=l_qty2
      LET g_rvv[l_ac].rvv80=l_unit1
      LET g_rvv[l_ac].rvv81=l_fac1
      LET g_rvv[l_ac].rvv82=l_qty1
   END IF
END FUNCTION
 
#對原來數量/換算率/單位的賦值
FUNCTION t720_set_origin_field()
  DEFINE    l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_img09  LIKE img_file.img09,     #img單位
           #l_ima25  LIKE ima_file.ima25,     #FUN-A10130
            l_ima44  LIKE ima_file.ima44,
            l_tot    LIKE img_file.img10,
            l_fac2   LIKE rvv_file.rvv84,
            l_qty2   LIKE rvv_file.rvv85,
            l_fac1   LIKE rvv_file.rvv81,
            l_qty1   LIKE rvv_file.rvv82,
            l_factor LIKE ima_file.ima31_fac  #No.FUN-680136 DECIMAL(16,8)
 
    IF g_sma.sma115='N' THEN RETURN END IF
    SELECT ima25,ima44 INTO g_ima25,l_ima44 FROM ima_file  #FUN-A10130
     WHERE ima01=g_rvv[l_ac].rvv31
    IF SQLCA.sqlcode = 100 THEN
       IF g_rvv[l_ac].rvv31 MATCHES 'MISC*' THEN
          SELECT ima25,ima44 INTO g_ima25,l_ima44 FROM ima_file #FUN-A10130
           WHERE ima01='MISC'
       END IF
    END IF
    IF cl_null(l_ima44) THEN LET l_ima44=g_ima25 END IF  #FUN-A10130
 
    SELECT img09 INTO l_img09 FROM img_file
     WHERE img01=g_rvv[l_ac].rvv31
       AND img02=g_rvv[l_ac].rvv32
       AND img03=g_rvv[l_ac].rvv33
       AND img04=g_rvv[l_ac].rvv34
    IF l_img09 IS NULL THEN LET l_img09=l_ima44 END IF
    LET l_fac2=g_rvv[l_ac].rvv84
    LET l_qty2=g_rvv[l_ac].rvv85
    LET l_fac1=g_rvv[l_ac].rvv81
    LET l_qty1=g_rvv[l_ac].rvv82
 
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
 
    IF g_sma.sma115 = 'Y' THEN
       CASE g_ima906
          WHEN '1' LET g_rvv[l_ac].rvv35=g_rvv[l_ac].rvv80
                   LET g_rvv[l_ac].rvv17=l_qty1
          WHEN '2' LET l_tot=l_fac1*l_qty1+l_fac2*l_qty2
                   LET g_rvv[l_ac].rvv35=l_ima44
                   LET g_rvv[l_ac].rvv17=l_tot
          WHEN '3' LET g_rvv[l_ac].rvv35=g_rvv[l_ac].rvv80
                   LET g_rvv[l_ac].rvv17=l_qty1
                   IF l_qty2 <> 0 THEN
                      LET g_rvv[l_ac].rvv84=l_qty1/l_qty2
                   ELSE
                      LET g_rvv[l_ac].rvv84=0
                   END IF
       END CASE
       LET g_rvv[l_ac].rvv17 = s_digqty(g_rvv[l_ac].rvv17,g_rvv[l_ac].rvv35)   #No.FUN-BB0086
    ELSE  #不使用雙單位
    END IF
    LET g_factor = 1
    CALL s_umfchk(g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv35,g_ima25) #FUN-A10130
          RETURNING g_cnt,g_factor
    IF g_cnt = 1 THEN
       LET g_factor = 1
    END IF
    LET b_rvv.rvv35_fac = g_factor
 
END FUNCTION
 
 
#兩組雙單位資料不是一定要全部KEY,如果沒有KEY單位,則把換算率/數量清空
FUNCTION t720_du_data_to_correct()
 
   IF cl_null(g_rvv[l_ac].rvv83) THEN
      LET g_rvv[l_ac].rvv84 = NULL
      LET g_rvv[l_ac].rvv85 = NULL
   END IF
 
   IF cl_null(g_rvv[l_ac].rvv80) THEN
      LET g_rvv[l_ac].rvv81 = NULL
      LET g_rvv[l_ac].rvv82 = NULL
   END IF
 
   DISPLAY BY NAME g_rvv[l_ac].rvv83
   DISPLAY BY NAME g_rvv[l_ac].rvv84
   DISPLAY BY NAME g_rvv[l_ac].rvv85
   DISPLAY BY NAME g_rvv[l_ac].rvv80
   DISPLAY BY NAME g_rvv[l_ac].rvv81
   DISPLAY BY NAME g_rvv[l_ac].rvv82
END FUNCTION
 
FUNCTION t720_set_rvv87()
  DEFINE    l_item   LIKE img_file.img01,     #料號
           #l_ima25  LIKE ima_file.ima25,     #ima單位 #FUN-A10130
            l_ima44  LIKE ima_file.ima44,     #ima單位
            l_ima906 LIKE ima_file.ima906,
            l_img09  LIKE img_file.img09,
            l_fac2   LIKE img_file.img21,     #第二轉換率
            l_qty2   LIKE img_file.img10,     #第二數量
            l_fac1   LIKE img_file.img21,     #第一轉換率
            l_qty1   LIKE img_file.img10,     #第一數量
            l_tot    LIKE img_file.img10,     #計價數量
            l_factor LIKE ima_file.ima31_fac  #No.FUN-680136 DECIMAL(16,8)
  DEFINE    l_qcl05  LIKE qcl_file.qcl05      #FUN-BC0104     

       #FUN-BC0104---add---str---
       CALL t720_qcl05_check() RETURNING l_qcl05
       IF NOT cl_null(l_qcl05) THEN
          IF l_qcl05 MATCHES '[12]' THEN
             RETURN
          END IF
       END IF
       #FUN-BC0104---add---end---
       SELECT ima25,ima44,ima906 INTO g_ima25,l_ima44,l_ima906  #FUN-A10130
         FROM ima_file WHERE ima01=g_rvv[l_ac].rvv31
       IF SQLCA.sqlcode = 100 THEN
          IF g_rvv[l_ac].rvv31 MATCHES 'MISC*' THEN
             SELECT ima25,ima44,ima906 INTO g_ima25,l_ima44,l_ima906 #FUN-A10130
               FROM ima_file WHERE ima01='MISC'
          END IF
       END IF
       IF cl_null(l_ima44) THEN LET l_ima44=g_ima25 END IF #FUN-A10130
 
    LET l_fac2=g_rvv[l_ac].rvv84
    LET l_qty2=g_rvv[l_ac].rvv85
    IF g_sma.sma115 = 'Y' THEN
       LET l_fac1=g_rvv[l_ac].rvv81
       LET l_qty1=g_rvv[l_ac].rvv82
    ELSE
       LET l_fac1=1
       LET l_qty1=g_rvv[l_ac].rvv17
       CALL s_umfchk(g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv35,l_ima44)
             RETURNING g_cnt,l_fac1
       IF g_cnt = 1 THEN
          LET l_fac1 = 1
       END IF
    END IF
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
 
    SELECT img09 INTO l_img09 FROM img_file
     WHERE img01=g_rvv[l_ac].rvv31
       AND img02=g_rvv[l_ac].rvv32
       AND img03=g_rvv[l_ac].rvv33
       AND img04=g_rvv[l_ac].rvv34
    IF l_img09 IS NULL THEN LET l_img09=l_ima44 END IF
 
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
       CALL s_umfchk(g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv35,g_rvv[l_ac].rvv86)                                                         
             RETURNING g_cnt,l_factor                                                                                               
    ELSE           
       CALL s_umfchk(g_rvv[l_ac].rvv31,l_ima44,g_rvv[l_ac].rvv86)
             RETURNING g_cnt,l_factor
    END IF #MOD-980252
    IF g_cnt = 1 THEN
       LET l_factor = 1
    END IF
    LET l_tot = l_tot * l_factor
 
    LET g_rvv[l_ac].rvv87 = l_tot
    LET g_rvv[l_ac].rvv87 = s_digqty(g_rvv[l_ac].rvv87,g_rvv[l_ac].rvv86)   #No.FUN-BB0086
END FUNCTION
 
FUNCTION t720_sel_ima()
    SELECT ima25,ima44,ima906,ima907,ima908
      INTO g_ima25,g_ima44,g_ima906,g_ima907,g_ima908
      FROM ima_file
     WHERE ima01=g_rvv[l_ac].rvv31
END FUNCTION
 
FUNCTION t720_def_form()
 
  #FUN-A60009 add str ----
   IF (g_argv1 = '1' AND cl_null(g_argv3)) OR (g_argv1 = '1' AND g_argv3 = 'TAP') THEN 
       CALL cl_set_act_visible("carry_delivery",TRUE)
   ELSE
       CALL cl_set_act_visible("carry_delivery",FALSE)
   END IF
  #FUN-A60009 add end ----

   IF (g_argv1='2' AND g_argv3='TAP') THEN
      CALL cl_set_comp_visible("rvu20,rvu99",FALSE)   
   ELSE
      CALL cl_set_comp_visible("rvu20,rvu99",TRUE)   
   END IF
 
   CALL cl_set_comp_visible("rvv84,rvv81",FALSE)
 
   IF g_sma.sma115 = 'Y' THEN
      CALL cl_set_comp_visible("rvv17,rvv35,rvv35_fac",FALSE)
   ELSE
      CALL cl_set_comp_visible("rvv83,rvv84,rvv85",FALSE)
      CALL cl_set_comp_visible("rvv80,rvv81,rvv82",FALSE)
   END IF
 
   IF g_sma.sma116 MATCHES '[02]' THEN    #MOD-630031 add #不使用計價單位
      CALL cl_set_comp_visible("rvv86,rvv87",FALSE)
   END IF
 
   IF g_sma.sma122 ='1' THEN
      CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("rvv83",g_msg CLIPPED)
      CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("rvv85",g_msg CLIPPED)
      CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("rvv80",g_msg CLIPPED)
      CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("rvv82",g_msg CLIPPED)
   END IF
 
   IF g_sma.sma122 ='2' THEN
      CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("rvv83",g_msg CLIPPED)
      CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("rvv85",g_msg CLIPPED)
      CALL cl_getmsg('asm-328',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("rvv80",g_msg CLIPPED)
      CALL cl_getmsg('asm-329',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("rvv82",g_msg CLIPPED)
   END IF
 
   CALL cl_set_comp_visible("rvv930,gem02a",g_aaz.aaz90='Y')
 
   CALL cl_set_comp_visible("rvu116",g_argv1='3')   #FUN-940083--add---
   CALL cl_set_comp_visible("Page4",g_argv1='3')   #FUN-940083--add---
END FUNCTION
 
FUNCTION t720_refresh_detail()
  DEFINE l_compare          LIKE smy_file.smy62
  DEFINE li_col_count       LIKE type_file.num5    #No.FUN-680136 SMALLINT
  DEFINE li_i, li_j         LIKE type_file.num5    #No.FUN-680136 SMALLINT
  DEFINE lc_agb03           LIKE agb_file.agb03
  DEFINE lr_agd             RECORD LIKE agd_file.*
  DEFINE lc_index           STRING
  DEFINE ls_combo_vals      STRING
  DEFINE ls_combo_txts      STRING
  DEFINE ls_sql             STRING
  DEFINE ls_show,ls_hide    STRING
  DEFINE l_gae04            LIKE gae_file.gae04
 
  #判斷是否進行料件多屬性新機制管理以及是否傳入了屬性群組
  IF (g_sma.sma120 = 'Y') AND (g_sma.sma907 = 'Y') AND
      NOT cl_null(lg_smy62) THEN
     #首先判斷有無單身記錄，如果單身根本沒有東東，則按照默認的lg_smy62來決定
     #顯示什么組別的信息，如果有單身，則進行下面的邏輯判斷
     IF g_rvv.getLength() = 0 THEN
        LET lg_group = lg_smy62
     ELSE
       #讀取當前單身所有的料件資料，如果它們都屬于多屬性子料件，并且擁有一致的
       #屬性群組，則以該屬性群組作為顯示單身明細屬性的依據，如果有不統一的狀況
       #則返回一個NULL，下面將不顯示任明細屬性列
       FOR li_i = 1 TO g_rvv.getLength()
         #如果某一個料件沒有對應的母料件(已經在前面的b_fill中取出來放在imx00中了)
         #則不進行下面判斷直接退出了
         IF  cl_null(g_rvv[li_i].att00) THEN
            LET lg_group = ''
            EXIT FOR
         END IF
         SELECT imaag INTO l_compare FROM ima_file WHERE ima01 = g_rvv[li_i].att00
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
 
     #走到這個分支說明是采用新機制，那么使用att00父料件編號代替rvv31子料件編號來顯示
     #得到當前語言別下rvv31的欄位標題
     SELECT gae04 INTO l_gae04 FROM gae_file
       WHERE gae01 = g_prog AND gae02 = 'rvv31' AND gae03 = g_lang
     CALL cl_set_comp_att_text("att00",l_gae04)
 
     #為了提高效率，把需要顯示和隱藏的欄位都放到各自的變量里，然后在結尾的地方一次性顯示或隱藏
     IF NOT cl_null(lg_group) THEN
        LET ls_hide = 'rvv31,ima02'
        LET ls_show = 'att00'
     ELSE
        LET ls_hide = 'att00'
        LET ls_show = 'rvv31,ima02'
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
    LET ls_show = 'rvv31'
  END IF
 
  #下面開始隱藏其他明細屬性欄位(從li_i開始)
  FOR li_j = li_i TO 10
      LET lc_index = li_j USING '&&'
      #注意att0x和att0x_c都要隱藏，別忘了_c的
      LET ls_hide = ls_hide || ",att" || lc_index || ",att" || lc_index || "_c"
  END FOR
 
  IF g_prog = 'apmt720' OR g_prog = 'aict042' THEN  #MOD-D30083 add aict042
    LET ls_show = ls_show ,",pmm909,pmn24,pmn25"
  ELSE
    LET ls_hide = ls_hide ,",pmm909,pmn24,pmn25"
  END IF
 
  #這樣只用調兩次公共函數就可以解決問題了，效率應該會高一些
  CALL cl_set_comp_visible(ls_show, TRUE)
  CALL cl_set_comp_visible(ls_hide, FALSE)
 
END FUNCTION
 
#--------------------在修改下面的代碼前請讀一下注釋先，謝了! -----------------------
 
#下面代碼是從單身INPUT ARRAY語句中的AFTER FIELD段中拷貝來的，因為在多屬性新模式下原來的oea04料件編號
#欄位是要被隱藏起來，并由新增加的imx00（母料件編號）+各個明細屬性欄位來取代，所以原來的AFTER FIELD
#代碼是不會被執行到，需要執行的判斷應該放新增加的几個欄位的AFTER FIELD中來進行，因為要用多次嘛，所以
#單獨用一個FUNCTION來放，順便把oeb04的AFTER FIELD也移過來，免得將來維護的時候遺漏了
#下標g_rvv[l_ac]都被改成g_rvv[p_ac]，請注意
 
#本函數返回TRUE/FALSE,表示檢核過程是否通過，一般說來，在使用過程中應該是如下方式□
#    AFTER FIELD XXX
#        IF NOT t720_check_oeb04(.....)  THEN NEXT FIELD XXX END IF
FUNCTION t720_check_rvv31(p_field,p_ac,p_cmd) #No.MOD-660090
DEFINE
  p_field                     STRING,    #當前是在哪個欄位中觸發了AFTER FIELD事件
  p_ac                        LIKE type_file.num5,    #No.FUN-680136 SMALLINT  #g_rvv數組中的當前記錄下標
 
  l_ps                        LIKE sma_file.sma46,
  l_str_tok                   base.stringTokenizer,
  l_tmp, ls_sql               STRING,
  l_param_list                STRING,
  l_cnt, li_i                 LIKE type_file.num5,    #No.FUN-680136 SMALLINT
  ls_value                    STRING,
  g_value                     LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(1000)
  ls_pid,ls_value_fld         LIKE ima_file.ima01,
  ls_name, ls_spec            STRING,
  lc_agb03                    LIKE agb_file.agb03,
  lc_agd03                    LIKE agd_file.agd03,
  ls_pname                    LIKE ima_file.ima02,
  l_misc                      LIKE type_file.chr4,     #No.FUN-680136 VARCHAR(04)
  l_n                         LIKE type_file.num5,    #No.FUN-680136 SMALLINT
  l_b2                        LIKE ima_file.ima31,
  l_ima130                    LIKE ima_file.ima130,
  l_ima131                    LIKE ima_file.ima131,
 #l_ima25                     LIKE ima_file.ima25,    #FUN-A10130
  l_imaacti                   LIKE ima_file.imaacti,
  l_qty                       LIKE type_file.num10,   #No.FUN-680136 INTEGER
  p_cmd                       LIKE type_file.chr1,   #No.MOD-660090   #No.FUN-680136 VARCHAR(1)
  l_check                     LIKE type_file.chr1,   #No.FUN-680136 VARCHAR(01)
  l_pmm02                     LIKE pmm_file.pmm02,   #No.CHI-8C0017
  l_pmn18                     LIKE pmn_file.pmn18,   #No.CHI-8C0017  
  l_pmn41                     LIKE pmn_file.pmn41,   #No.CHI-8C0017
  l_pmn43                     LIKE pmn_file.pmn43,   #No.CHI-8C0017
  l_pmn012                    LIKE pmn_file.pmn012,  #FUN-A60076 add 
  l_pmh21                     LIKE pmh_file.pmh21,   #No.CHI-8C0017
  l_pmh22                     LIKE pmh_file.pmh22    #No.CHI-8C0017  
 
 
  #如果當前欄位是新增欄位（母料件編號以及十個明細屬性欄位）的時候，如果全部輸了值則合成出一個
  #新的子料件編號并把值填入到已經隱藏起來的oeb04中（如果imxXX能夠顯示，oeb04一定是隱藏的）
  #下面就可以直接沿用oeb04的檢核邏輯了
  #如果不是，則看看是不是oeb04自己觸發了，如果還不是則什么也不做(無聊)，返回一個FALSE
  IF (p_field = 'imx00') OR (p_field = 'imx01') OR (p_field = 'imx02') OR
     (p_field = 'imx03') OR (p_field = 'imx04') OR (p_field = 'imx05') OR
     (p_field = 'imx06') OR (p_field = 'imx07') OR (p_field = 'imx08') OR
     (p_field = 'imx09') OR (p_field = 'imx10')  THEN
 
     #首先判斷需要的欄位是否全部完成了輸入（只有母料件編號+被顯示出來的所有明細屬性
     #全部被輸入完成了才進行后續的操作
     LET ls_pid   = g_rvv[p_ac].att00   # ls_pid 父料件編號
     LET ls_value = g_rvv[p_ac].att00   # ls_value 子料件編號
     IF cl_null(ls_pid) THEN
        #所有要返回TRUE的分支都要加這兩句話,原來下面的會被注釋掉
        CALL t720_sel_ima() #MOD-580161 add
        CALL t720_set_no_entry_b(p_cmd)        #No.MOD-650055 add
        CALL t720_set_required(p_cmd)
 
        RETURN TRUE
     END IF  #注意這里沒有錯，所以返回TRUE
 
     #取出當前母料件包含的明細屬性的個數
     SELECT COUNT(*) INTO l_cnt FROM agb_file WHERE agb01 =
        (SELECT imaag FROM ima_file WHERE ima01 = ls_pid)
     IF l_cnt = 0 THEN
        #所有要返回TRUE的分支都要加這兩句話,原來下面的會被
        #注釋掉
        CALL t720_sel_ima() #MOD-580161 add
        CALL t720_set_no_entry_b(p_cmd)        #No.MOD-650055 add
        CALL t720_set_required(p_cmd)
 
        RETURN TRUE
     END IF
 
     FOR li_i = 1 TO l_cnt
         #如果有任何一個明細屬性應該輸而沒有輸的則退出
         IF cl_null(arr_detail[p_ac].imx[li_i]) THEN
            #所有要返回TRUE的分支都要加這兩句話,原來下面的會被
            #注釋掉
            CALL t720_sel_ima() #MOD-580161 add
            CALL t720_set_no_entry_b(p_cmd)        #No.MOD-650055 add
            CALL t720_set_required(p_cmd)
 
            RETURN TRUE
         END IF
     END FOR
 
     #得到系統定義的標准分隔符sma46
     SELECT sma46 INTO l_ps FROM sma_file
 
     #合成子料件的名稱
     SELECT ima02 INTO ls_pname FROM ima_file   # ls_name 父料件名稱
       WHERE ima01 = ls_pid
     LET ls_spec = ls_pname  # ls_spec 子料件名稱
     #方法:循環在agd_file中找有沒有對應記錄，如果有，就用該記錄的名稱來
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
 
     LET g_value=ls_value
     SELECT COUNT(*) INTO l_n FROM ima_file WHERE ima01=g_value
     IF l_n=0 THEN
        CALL cl_err('g_value','ams-003',1)
        RETURN FALSE
     END IF
     #調用cl_copy_ima將新生成的子料件插入到數據庫中
 
     #把生成的子料件賦給rvv31，否則下面的檢查就沒有意義了
     LET g_rvv[p_ac].rvv31 = ls_value
     LET g_rvv[p_ac].rvv031 = ls_spec     #No.MOD-8A0098
     SELECT COUNT(*) INTO l_n FROM ima_file WHERE ima01=g_rvv[l_ac].rvv31
     IF l_n=0 THEN
        CALL cl_err('rvv31','ams-003',1)
        RETURN FALSE
     END IF
  ELSE
    IF ( p_field <> 'rvv31' )AND( p_field <> 'imx00' ) THEN
       RETURN FALSE
    END IF
  END IF
 
  #到這里已經完成了以前在cl_itemno_multi_att()中做的所有准備工作，在系統資料庫
  #中已經有了對應的子料件的名稱，下面可以按照oeb04進行判斷了
 
  #--------重要 !!!!!!!!!!!-------------------------
  #下面的代碼都是從原INPUT ARRAY中的AFTER FIELD oeb04段拷貝來的，唯一做的修改
  #是將原來的NEXT FIELD 語句都改成了RETURN FALSE, xxx,xxx ... ，因為NEXE FIELD
  #語句要交給調用方來做，這里只需要返回一個FALSE告訴它有錯誤就可以了，同時一起
  #返回的還有一些CHECK過程中要從ima_file中取得的欄位信息，其他的比如判斷邏輯和
  #錯誤提示都沒有改，如果你需要在里面添加代碼請注意上面的那個要點就可以了
 
  IF NOT cl_null(g_rvv[l_ac].rvv31) THEN
     #新增一個判斷,如果lg_smy62不為空,表示當前采用的是料件多屬性的新機制,因此這個函數應該是被
     #attxx這樣的明細屬性欄位的AFTER FIELD來調用的,所以不再使用原來的輸入機制,否則不變
     IF cl_null(lg_smy62) THEN
       IF g_sma.sma120 = 'Y' THEN
          CALL cl_itemno_multi_att("rvv31",g_rvv[l_ac].rvv31,"",'1','f') RETURNING l_check,g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv031   #No.MOD-8A0098
          DISPLAY g_rvv[l_ac].rvv31 TO rvv31
          DISPLAY g_rvv[l_ac].rvv031 TO rvv031
       END IF
     END IF
 
     #-----MOD-AB0205---------
     #SELECT COUNT(*) INTO l_n FROM ima_file WHERE ima01=g_rvv[l_ac].rvv31
     #IF l_n=0 THEN
     #   CALL cl_err('rvv31','ams-003',1)
     #   RETURN FALSE
     #END IF
     #-----END MOD-AB0205-----
 
     LET l_misc=g_rvv[l_ac].rvv31[1,4]
     IF g_rvv[l_ac].rvv31[1,4]='MISC' THEN  #NO:6808
        SELECT COUNT(*) INTO l_n FROM ima_file
         WHERE ima01=l_misc
           AND ima01='MISC'
        IF l_n=0 THEN
           CALL cl_err('','aim-806',0)
           RETURN FALSE
        END IF
     #-----MOD-AB0205---------
     ELSE
        SELECT COUNT(*) INTO l_n FROM ima_file WHERE ima01=g_rvv[l_ac].rvv31
        IF l_n=0 THEN
           CALL cl_err('rvv31','ams-003',1)
           RETURN FALSE
        END IF
     #-----END MOD-AB0205-----
     END IF
 
     IF g_sma.sma115 = 'Y' THEN
        IF NOT cl_null(g_rvv[l_ac].rvv31) THEN
           CALL s_chk_va_setting(g_rvv[l_ac].rvv31)
                RETURNING g_flag,g_ima906,g_ima907
           IF g_flag=1 THEN
              RETURN FALSE
           END IF
           CALL s_chk_va_setting1(g_rvv[l_ac].rvv31)
                RETURNING g_flag,g_ima908
           IF g_flag=1 THEN
              RETURN FALSE
           END IF
           IF g_ima906 = '3' THEN
              LET g_rvv[l_ac].rvv83=g_ima907
              DISPLAY BY NAME g_rvv[l_ac].rvv83
           END IF
        END IF
        IF g_sma.sma116 MATCHES '[13]' THEN    #No.FUN-610076
           IF cl_null(g_rvv[l_ac].rvv86) THEN
              LET g_rvv[l_ac].rvv86=g_ima908
              DISPLAY BY NAME g_rvv[l_ac].rvv86
           END IF
        END IF
     END IF
      IF g_sma.sma115 = 'Y' THEN
          #單位一
          IF cl_null(g_rvv[l_ac].rvv80) THEN
              LET g_rvv[l_ac].rvv80 = g_ima25
              DISPLAY BY NAME g_rvv[l_ac].rvv80
          END IF
 
          #單位二
          IF cl_null(g_rvv[l_ac].rvv83) THEN
              LET g_rvv[l_ac].rvv83 = g_ima907
              DISPLAY BY NAME g_rvv[l_ac].rvv83
          END IF
 
          #計價單位
          IF cl_null(g_rvv[l_ac].rvv86) THEN
              IF g_sma.sma116 MATCHES '[13]' THEN    #No.FUN-610076
                  LET g_rvv[l_ac].rvv86 = g_ima908
              ELSE
                  LET g_rvv[l_ac].rvv86 = g_rvv[l_ac].rvv80
              END IF
              DISPLAY BY NAME g_rvv[l_ac].rvv86
          END IF
      ELSE
          IF cl_null(g_rvv[l_ac].rvv35) THEN
              LET g_rvv[l_ac].rvv35=g_ima25
              DISPLAY BY NAME g_rvv[l_ac].rvv35
          END IF
      END IF
     #FUN-5B0144 add如果收貨單空值抓最近採購單價
     IF NOT cl_null(g_rvv[l_ac].rvv31) AND g_rvv[l_ac].rvv31[1,4]!='MISC'
        AND cl_null(g_rvu.rvu02) THEN
        SELECT pmm02 INTO l_pmm02 FROM pmm_file 
         WHERE pmm01 = g_rvv[p_ac].rvv36
        SELECT pmn41,pmn43,pmn18,pmn012 INTO l_pmn41,l_pmn43,l_pmn18,l_pmn012 FROM pmn_file         #FUN-A60076 add pmn012,l_pmn012
         WHERE pmn01 = g_rvv[p_ac].rvv36 AND pmn02 = g_rvv[p_ac].rvv37          
        IF cl_null(l_pmm02) THEN LET l_pmm02 = ' ' END IF  #No.FUN-940083
        IF l_pmm02='SUB' THEN
           LET l_pmh22='2'
           IF l_pmn43 = 0 OR cl_null(l_pmn43) THEN  
              LET l_pmh21 =' '
           ELSE
             IF NOT cl_null(l_pmn18) THEN
              SELECT sgm04 INTO l_pmh21 FROM sgm_file
               WHERE sgm01=l_pmn18
                 AND sgm02=l_pmn41
                 AND sgm03=l_pmn43
                 AND sgm012 = l_pmn012                   #FUN-A60076 add by vealxu  
             ELSE
              SELECT ecm04 INTO l_pmh21 FROM ecm_file 
               WHERE ecm01=l_pmn41
                 AND ecm03=l_pmn43
                 AND ecm012 =l_pmn012                     #FUN-A60076 add 
             END IF
           END IF     #No.TQC-910033  
        ELSE
           LET l_pmh22='1'
           LET l_pmh21=' '
        END IF
        SELECT pmh12,pmh19  #No.FUN-610018
          INTO g_rvv[l_ac].rvv38,g_rvv[l_ac].rvv38t
          FROM pmh_file
         WHERE pmh01 = g_rvv[l_ac].rvv31 AND pmh05 = '0' 
               AND pmh02 = g_rvu.rvu04 
               AND pmh13 = (SELECT pmc22 FROM pmc_file WHERE pmc01=g_rvu.rvu04)   #MOD-940073
               AND pmh21 = l_pmh21                                                      #CHI-8C0017
               AND pmh22 = l_pmh22                                                      #CHI-8C0017
               AND pmh23 = ' '                                             #CHI-960033
               AND pmhacti = 'Y'                                           #CHI-910021           
     END IF
 
 
     CALL t720_sel_ima() #MOD-580161 add
     CALL t720_set_no_entry_b(p_cmd)        #No.MOD-650055 add
     CALL t720_set_required(p_cmd)
 
     RETURN TRUE
  ELSE
     #如果是由oeb04來觸發的,說明當前用的是舊的流程,那么oeb04為空是可以的
     #如果是由att00來觸發,原理一樣
     IF (p_field = 'rvv31') OR (p_field = 'imx00') THEN
        #所有要返回TRUE的分支都要加這兩句話,原來下面的會被
        #注釋掉
 
        CALL t720_sel_ima() #MOD-580161 add
        CALL t720_set_no_entry_b(p_cmd)        #No.MOD-650055 add
        CALL t720_set_required(p_cmd)
 
        LET g_value=ls_value
        IF NOT cl_null(g_value) THEN      #No.MOD-8A0098 
        SELECT COUNT(*) INTO l_n FROM ima_file WHERE ima01=g_value
        IF l_n=0 THEN
           CALL cl_err('g_value','ams-003',1)
           RETURN FALSE
        END IF
        END IF     #No.MOD-8A0098
 
        RETURN TRUE
     ELSE
        #如果不是oeb,則是由attxx來觸發的,則非輸不可
        RETURN FALSE
     END IF #如果為空則不允許新增
  END IF
END FUNCTION
 
#用于att01~att10這十個輸入型屬性欄位的AFTER FIELD事件的判斷函數
#傳入參數:p_value 要比較的欄位內容,p_index當前欄位的索引號(從1~10表示att01~att10)
#         p_row是當前行索引,傳入INPUT ARRAY中使用的l_ac即可
#與t720_check_rvv31相同,如果檢查過程中如果發現錯誤,則報錯并返回一個FALSE
#而AFTER FIELD的時候檢測到這個返回值則會做NEXT FIELD
FUNCTION t720_check_att0x(p_value,p_index,p_row,p_cmd) #No.MOD-660090
DEFINE
  p_value      LIKE imx_file.imx01,
  p_index      LIKE type_file.num5,    #No.FUN-680136 SMALLINT
  p_row        LIKE type_file.num5,    #No.FUN-680136 SMALLINT
  li_min_num   LIKE agc_file.agc05,
  li_max_num   LIKE agc_file.agc06,
  l_index      STRING,
  p_cmd        LIKE type_file.chr1,   #No.MOD-660090  #No.FUN-680136 VARCHAR(1)
  l_check_res     LIKE type_file.num5,    #No.FUN-680136 SMALLINT
  l_b2            LIKE type_file.chr50,   #No.FUN-680136 VARCHAR(30)
  l_imaacti       LIKE ima_file.imaacti,
  l_ima130        LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
  l_ima131        LIKE ima_file.ima131  #No.FUN-680136 VARCHAR(10)
 #l_ima25         LIKE ima_file.ima25   #FUN-A10130
 
  #這個欄位一旦進入了就不能忽略，因為要保証在輸入其他欄位之前必須要生成rvv31料件編號
  IF cl_null(p_value) THEN
     RETURN FALSE
  END IF
 
  #這里使用到了一個用于存放當前屬性組包含的所有屬性信息的全局數組lr_agc
  #該數組會由t720_refresh_detail()函數在較早的時候填充
 
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
  CALL t720_check_rvv31('imx' || l_index ,p_row,p_cmd)  #No.MOD-660090
    RETURNING l_check_res
    RETURN l_check_res
END FUNCTION
 
#用于att01_c~att10_c這十個選擇型屬性欄位的AFTER FIELD事件的判斷函數
#傳入參數:p_value 要比較的欄位內容,p_index當前欄位的索引號(從1~10表示att01~att10)
#         p_row是當前行索引,傳入INPUT ARRAY中使用的l_ac即可
#與t720_check_rvv31相同,如果檢查過程中如果發現錯誤,則報錯并返回一個FALSE
#而AFTER FIELD的時候檢測到這個返回值則會做NEXT FIELD
FUNCTION t720_check_att0x_c(p_value,p_index,p_row,p_cmd) #No.MOD-660090
DEFINE
  p_value  LIKE imx_file.imx01,
  p_index  LIKE type_file.num5,    #No.FUN-680136 SMALLINT
  p_row    LIKE type_file.num5,    #No.FUN-680136 SMALLINT
  l_index  STRING,
  p_cmd    LIKE type_file.chr1,    #No.MOD-660090  #No.FUN-680136 VARCHAR(1)
  l_check_res     LIKE type_file.num5,    #No.FUN-680136 SMALLINT
  l_b2            LIKE type_file.chr50,     #No.FUN-680136 VARCHAR(30)
  l_imaacti       LIKE ima_file.imaacti,
  l_ima130        LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1),
  l_ima131        LIKE ima_file.ima131    #No.FUN-680136 VARCHAR(10)
 #l_ima25         LIKE ima_file.ima25     #FUN-A10130
 
 
  #這個欄位一旦進入了就不能忽略，因為要保証在輸入其他欄位之前必須要生成oeb04料件編號
  IF cl_null(p_value) THEN
     RETURN FALSE
  END IF
  #下拉框選擇項相當簡單，不需要進行范圍和長度的判斷，因為肯定是符合要求的了
  LET arr_detail[p_row].imx[p_index] = p_value
  LET l_index = p_index USING '&&'
  CALL t720_check_rvv31('imx'||l_index,p_row,p_cmd) #No.MOD-660090
    RETURNING l_check_res
  RETURN l_check_res
END FUNCTION
 
FUNCTION t720_set_rvv930(p_rvv930)
DEFINE p_rvv930 LIKE rvv_file.rvv930
DEFINE l_gem02  LIKE gem_file.gem02
 
   SELECT gem02 INTO l_gem02 FROM gem_file
                            WHERE gem01=p_rvv930
   IF SQLCA.sqlcode THEN
      LET l_gem02=NULL
   END IF
   RETURN l_gem02
END FUNCTION
 
FUNCTION t720_exp_delivery()
  DEFINE l_oea01 LIKE oea_file.oea01
  DEFINE l_sql STRING
  DEFINE l_cnt LIKE type_file.num5
  DEFINE li_result LIKE type_file.num5
  DEFINE l_pmn24   LIKE pmn_file.pmn24   #FUN-740046
  DEFINE tm RECORD
         slip     LIKE oay_file.oayslip
         END RECORD
  DEFINE l_n   LIKE type_file.num5  #No.MOD-880057 #記錄可執行筆數
 
 
  LET begin_no = NULL    #MOD-740475
  LET end_no = NULL      #MOD-740475
  IF g_rvu.rvuconf = 'N' THEN CALL cl_err('','mfg3550',0) RETURN END IF
  IF g_rvu.rvuconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
  LET l_cnt = 0
  SELECT COUNT(*) INTO l_cnt FROM oga_file
   WHERE oga914 = g_rvu.rvu01
     AND ogaconf <> 'X'      #MOD-D30033 add
  IF l_cnt > 0 THEN CALL cl_err('','apm-901',0) RETURN END IF
 
  SELECT rva00 INTO g_rva00 FROM rva_file WHERE rva01 = g_rvu.rvu02
  IF g_rva00 IS NULL THEN LET g_rva00 = ' ' END IF
  IF g_rva00 = '2' THEN
     CALL cl_err('','apm-923',1)
     RETURN
  END IF
  #TQC-BB0108--mark--begin 
# SELECT COUNT(*) INTO l_cnt FROM pmn_file,pmm_file,rvv_file   #FUN-740046 add pmm_file
#  WHERE rvv01 = g_rvu.rvu01
#    AND pmm01 = pmn01 AND pmm909 = '3'                        #FUN-740046
#    AND rvv36 = pmn01 AND rvv37 = pmn02
#    AND pmn24 IS NOT NULL AND pmn25 IS NOT NULL    #FUN-740046
# IF l_cnt = 0 THEN RETURN END IF
  #TQC-BB0108--end
  LET p_row = 5 LET p_col = 11
 
  OPEN WINDOW t720_exp_w AT p_row,p_col WITH FORM "apm/42f/apmt720g"
    ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("apmt720g")
 
   INPUT BY NAME tm.slip
      AFTER FIELD slip
         IF NOT cl_null(tm.slip) THEN
            LET g_cnt = 0
            CALL s_check_no("axm",tm.slip,"","50","","","")
                 RETURNING li_result,tm.slip
 
            IF (NOT li_result) THEN
               CALL cl_err(tm.slip,'aap-010',0)
               NEXT FIELD slip
            END IF
         END IF
         LET g_slip = tm.slip
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_success = 'N'
         CLOSE WINDOW t720_exp_w
         RETURN
      END IF
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(slip)
                 LET tm.slip=s_get_doc_no(tm.slip)
                 CALL q_oay(FALSE,FALSE,tm.slip,'50','AXM') RETURNING tm.slip
                 CALL FGL_DIALOG_SETBUFFER(tm.slip)
                 DISPLAY BY NAME tm.slip
                 NEXT FIELD slip
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
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_success = 'N'
      ROLLBACK WORK
      #CLOSE WINDOW t400global_exp_po #MOD-B90145 mark 
      CLOSE WINDOW t720_exp_w         #MOD-B90145 add
      RETURN
   END IF
 
  LET l_sql = "SELECT DISTINCT pmn24 FROM pmn_file,pmm_file,rvv_file,rvu_file",   #FUN-740046 add pmm_file
              " WHERE rvv01 = rvu01 ",
              "   AND pmm01 = pmn01 AND pmm909 = '3'",  #FUN-740046 add
              "   AND rvv36 = pmn01 AND rvv37 = pmn02 ",
              "   AND rvu01 = '", g_rvu.rvu01 CLIPPED, "'",
              "   AND pmn24 IS NOT NULL AND pmn25 IS NOT NULL ",
              " ORDER BY pmn24"
 
  PREPARE t720_pmn24 FROM l_sql
  DECLARE pmn_curs CURSOR FOR t720_pmn24
  LET g_success = 'Y'
  LET l_n = 0   #No.MOD-880057 
  BEGIN WORK
  FOREACH pmn_curs INTO l_pmn24
    IF STATUS THEN LET g_success = 'N' EXIT FOREACH  END IF
 
    LET l_cnt = 0 
    SELECT COUNT(*) INTO l_cnt FROM oeb_file
     WHERE oeb01 = l_pmn24 AND oeb70 <> 'Y' 
    IF l_cnt = 0 THEN  
       CONTINUE FOREACH 
    END IF
    CALL t720_exp_oga(l_pmn24)
    IF g_success = 'N' THEN
      EXIT FOREACH
    END IF
    LET l_n = l_n + 1  #No.MOD-880057 
  END FOREACH
  IF l_n = 0 THEN
     LET g_success = 'N'
     CALL cl_err('','apm1071',1)  #TQC-C10072
  END IF 
  IF g_success = 'Y' THEN
    COMMIT WORK
    MESSAGE '已轉出貨單'
     IF NOT cl_null(begin_no) THEN
       LET g_msg = begin_no CLIPPED,"~",end_no CLIPPED
       CALL cl_err(g_msg CLIPPED,"mfg0101",1)
     END IF
  ELSE
    ROLLBACK WORK
  END IF
 
  CLOSE WINDOW t720_exp_w
END FUNCTION
 
FUNCTION t720_exp_oga(p_oea01)
  DEFINE p_oea01 LIKE oea_file.oea01
  DEFINE l_sql STRING
  DEFINE l_cnt LIKE type_file.num5
  DEFINE l_oea RECORD LIKE oea_file.*
  DEFINE l_oga RECORD LIKE oga_file.*
  DEFINE li_result    LIKE type_file.num5
  DEFINE g_dbs2       LIKE type_file.chr30
  DEFINE l_date1,l_date2,l_date3  LIKE oga_file.oga11
  DEFINE g_plant2     LIKE type_file.chr10   #FUN-980020 
 #MOD-D30033---add---S
  DEFINE g_oea18_yn   LIKE oea_file.oea18
  DEFINE exT          LIKE type_file.chr1
  DEFINE g_exdate     LIKE oga_file.oga021
 #MOD-D30033---add---E
 
  LET g_plant2 = g_plant                     #FUN-980020
 
  LET g_dbs2 = s_dbstring(g_dbs CLIPPED)   #FUN-9B0106
 
  SELECT * INTO l_oea.* from oea_file WHERE oea01 = p_oea01
 
  LET l_oga.oga00 = '1'       #出貨別
  CALL s_auto_assign_no("AXM",g_slip,g_today,"","oga_file","oga01","","","")
     RETURNING li_result,l_oga.oga01
  LET l_oga.oga02  = g_today
  LET l_oga.oga03  = l_oea.oea03
  LET l_oga.oga032 = l_oea.oea032
  LET l_oga.oga033 = l_oea.oea033
  LET l_oga.oga04  = l_oea.oea04
  LET l_oga.oga044 = l_oea.oea044
  LET l_oga.oga05  = l_oea.oea05
  LET l_oga.oga06  = '0'            #修改版本
  LET l_oga.oga07  = l_oea.oea07
  LET l_oga.oga08  = l_oea.oea08
  LET l_oga.oga09  = '2'            #出貨單
  LET l_oga.oga10  = ''             #帳單編號
  SELECT occ67 INTO l_oga.oga13 FROM occ_file
   WHERE occ01 = l_oea.oea03
     AND occ1004 = '1' AND occ06 = '1' AND occacti = 'Y'
  LET l_oga.oga14  = l_oea.oea14     #MOD-8B0070
  LET l_oga.oga15  = l_oea.oea15
  LET l_oga.oga16  = l_oea.oea01     #訂單編號
  LET l_oga.oga161 = l_oea.oea161
  LET l_oga.oga162 = l_oea.oea162
  LET l_oga.oga163 = l_oea.oea163
  LET l_oga.oga17  = 0
  LET l_oga.oga18  = l_oea.oea17
  SELECT oma01 INTO l_oga.oga19 FROM oma_file WHERE oma16 = l_oea.oea01    #TQC-930128
  LET l_oga.oga20  = 'Y'
  LET l_oga.oga21  = l_oea.oea21
  LET l_oga.oga211 = l_oea.oea211
  LET l_oga.oga212 = l_oea.oea212
  LET l_oga.oga213 = l_oea.oea213
  LET l_oga.oga23  = l_oea.oea23     #CHI-740040
 #MOD-D30033---add---S
  CALL t720_oea18_get() RETURNING g_oea18_yn 
  SELECT oaz52,oaz70 INTO g_oaz.oaz52,g_oaz.oaz70 FROM oaz_file
  IF g_oea18_yn = 'N' THEN    
     IF l_oga.oga08 = '1' THEN
        LET exT = g_oaz.oaz52
     ELSE
        LET exT = g_oaz.oaz70
     END IF
     LET g_exdate = l_oga.oga02     #出貨日期
     CALL s_curr3(l_oga.oga23,g_exdate,exT) RETURNING l_oga.oga24
  ELSE
 #MOD-D30033---add---E
     LET l_oga.oga24  = l_oea.oea24
  END IF  #MOD-D30033 add
  LET l_oga.oga25  = l_oea.oea25
  LET l_oga.oga26  = l_oea.oea26
  LET l_oga.oga27  = ''
  LET l_oga.oga29  = 0             #信用額度餘額
  LET l_oga.oga30  = 'N'           #包裝單確認碼
  LET l_oga.oga31  = l_oea.oea31
  LET l_oga.oga32  = l_oea.oea32
  LET l_oga.oga33  = l_oea.oea33
  LET l_oga.oga34  = l_oea.oea34
  LET l_oga.oga41  = l_oea.oea41
  LET l_oga.oga42  = l_oea.oea42
  LET l_oga.oga43  = l_oea.oea43
  LET l_oga.oga44  = l_oea.oea44
  LET l_oga.oga45  = l_oea.oea45
  LET l_oga.oga46  = l_oea.oea46
  LET l_oga.oga49  = l_oea.oea35
  LET l_oga.oga50  = 0           #原幣金額
  LET l_oga.oga52  = 0           #原幣預收訂金轉銷貨收入金額
  LET l_oga.oga53  = 0           #原幣應開發票未稅金額
  LET l_oga.oga54  = 0           #原幣已開發票未稅金額
  LET l_oga.oga99  = ''          #多角貿易流程序號
  LET l_oga.oga901 = 'N'         #post to abx sys flag
  LET l_oga.oga902 = ''          #信用超限留置代碼
  LET l_oga.oga903 = 'N'         #信用查核放行否
  LET l_oga.oga905 = 'N'         #已轉三角貿易出貨單否
  LET l_oga.oga906 = l_oea.oea906
  LET l_oga.oga909 = 'N'
  LET l_oga.oga914 = g_rvu.rvu01 #入庫單號
  SELECT tuo04,tuo05 INTO l_oga.oga910,l_oga.oga911
    FROM tuo_file WHERE tuo01 = l_oea.oea03
  LET l_oga.ogaconf = 'N'
  LET l_oga.ogapost = 'N'
  LET l_oga.ogaprsw = 0
  LET l_oga.ogauser = g_user
  LET l_oga.ogagrup = g_grup
  LET l_oga.ogadate = g_today
  LET l_oga.oga55   = '0'
  LET l_oga.oga57 = '1'    #FUN-AC0055 add
  LET l_oga.oga65   = 'N'
  SELECT oayapr INTO l_oga.ogamksg FROM oay_file WHERE oayslip = g_slip
  LET l_oga.oga1001 = l_oea.oea1001
  LET l_oga.oga1002 = l_oea.oea1002
  LET l_oga.oga1003 = l_oea.oea1003
  LET l_oga.oga1004 = l_oea.oea1004
  LET l_oga.oga1005 = l_oea.oea1005
  LET l_oga.oga1016 = l_oea.oea1015
  LET l_oga.ogaspc  = '0'
  LET l_oga.oga69   = g_today
  LET l_oga.ogaplant = g_rvu.rvuplant   #NO.FUN-960130
  LET l_oga.ogalegal = g_rvu.rvulegal   #NO.FUN-960130
  LET l_oga.oga021  = ''   #MOD-8C0089
  LET l_oga.oga85 = ' '    #MOD-C10116
  LET l_oga.oga94 = 'N'    #MOD-C10116
  LET g_ogb930 = s_costcenter(l_oga.oga15)
  SELECT oea02 INTO l_date3 FROM oea_file WHERE oea01 = l_oea.oea01
  CALL s_rdatem(l_oga.oga03,l_oga.oga32,l_oga.oga02,l_oga.oga02,
                l_date3,g_plant2)       #FUN-980020
     RETURNING l_oga.oga11,l_oga.oga12
 
  LET l_oga.ogaoriu = g_user      #No.FUN-980030 10/01/04
  LET l_oga.ogaorig = g_grup      #No.FUN-980030 10/01/04

  INSERT INTO oga_file values(l_oga.*)
 
  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
     CALL cl_err3("ins","oga_file",l_oga.oga01,"",SQLCA.sqlcode,"","ins oga",1)
     LET g_success = 'N'
  ELSE
     IF cl_null(begin_no) THEN
        LET begin_no = l_oga.oga01
     END IF
     LET end_no=l_oga.oga01
     CALL t720_exp_ogb(l_oga.oga01,p_oea01)
  END IF
 
END FUNCTION

#MOD-D30033---add---S
FUNCTION t720_oea18_get()
   DEFINE l_oea18   LIKE oea_file.oea18
   DEFINE l_n       LIKE type_file.num5

     IF cl_null(g_rvu.rvu02) THEN RETURN 'N' END IF

     IF cl_null(l_ac) OR l_ac = 0 THEN LET l_ac = 1 END IF
     IF cl_null(g_rvv[l_ac].pmn24) THEN

        SELECT COUNT(*) INTO l_n
          FROM oea_file,oeb_file
         WHERE oea01 = oeb01
           AND oeb27 = g_rvv[l_ac].rvv36

        IF l_n >=1 THEN
            DECLARE oea18_get CURSOR FOR
                SELECT oea18
                  FROM oea_file,oeb_file
                 WHERE oea01 = oeb01
                   AND oeb01 = g_rvv[l_ac].pmn24

             FOREACH oea18_get INTO l_oea18
                 EXIT FOREACH
             END FOREACH
        END IF
     ELSE
        SELECT oea18 INTO l_oea18
          FROM oea_file
         WHERE oea01 = g_rvv[l_ac].pmn24
     END IF

     IF cl_null(l_oea18) THEN LET l_oea18 = 'N' END IF
     RETURN l_oea18
END FUNCTION
#MOD-D30033---add---E

 
FUNCTION t720_exp_ogb(p_oga01,p_oea01)
  DEFINE p_oga01  LIKE oga_file.oga01
  DEFINE p_oea01  LIKE oea_file.oea01
  DEFINE l_sql    STRING
  DEFINE l_cnt    LIKE type_file.num5
  DEFINE l_oea211 LIKE oea_file.oea211,
         l_oea213 LIKE oea_file.oea213
  DEFINE l_oeb    RECORD LIKE oeb_file.*,
         l_rvv    RECORD LIKE rvv_file.*,
         l_ogb    RECORD LIKE ogb_file.*
  DEFINE l_ogb03  LIKE ogb_file.ogb03
  DEFINE l_ima35  LIKE ima_file.ima35,
         l_ima36  LIKE ima_file.ima36
  DEFINE l_oga14  LIKE oga_file.oga14  #FUN-CB0087
  DEFINE l_oga15  LIKE oga_file.oga15  #FUN-CB0087
 
  SELECT oea211,oea213 INTO l_oea211,l_oea213
    FROM oea_file WHERE oea01 = p_oea01
 
  LET l_ogb03 = 0
  LET l_sql = "SELECT rvv_file.*,oeb_file.* ",
              "  FROM rvv_file,pmn_file,oeb_file ",
              " WHERE rvv36 = pmn01 AND rvv37 = pmn02 ",
              "   AND pmn24 = oeb01 AND pmn25 = oeb03 ",
              "   AND rvv01 ='", g_rvu.rvu01 CLIPPED, "'",
              "   AND pmn24 ='", p_oea01 CLIPPED, "'",
              "   AND oeb70 <>'Y' "  #No.MOD-880057 
 
  PREPARE ogb_pre FROM l_sql
  DECLARE ogb_curs CURSOR FOR ogb_pre
  FOREACH ogb_curs INTO l_rvv.*,l_oeb.*
    LET l_ogb03 = l_ogb03 + 1
    LET l_ogb.ogb01 = p_oga01
    LET l_ogb.ogb03 = l_ogb03
    LET l_ogb.ogb04 = l_oeb.oeb04
    LET l_ogb.ogb05 = l_oeb.oeb05
    LET l_ogb.ogb05_fac = l_oeb.oeb05_fac
    LET l_ogb.ogb06 = l_oeb.oeb06
    LET l_ogb.ogb07 = l_oeb.oeb07
    LET l_ogb.ogb08 = l_oeb.oeb08
    SELECT ima15,ima36 INTO l_ima35,l_ima36 FROM ima_file WHERE ima01 = l_oeb.oeb04
    LET l_ogb.ogb09 = l_oeb.oeb09
    LET l_ogb.ogb091 = l_oeb.oeb091
    #IF s_chk_ware(l_ima35) THEN      #No.FUN-AA0049  #No.FUN-AB0058 mark
       IF cl_null(l_ogb.ogb09) THEN LET l_ogb.ogb09 = l_ima35 END IF
       IF cl_null(l_ogb.ogb091) THEN LET l_ogb.ogb091 = l_ima36 END IF
    #END IF                           #No.FUN-AA0049  #No.FUN-AB0058 mark
    LET l_ogb.ogb092 = l_oeb.oeb092    
    IF l_ogb.ogb09  IS NULL THEN LET l_ogb.ogb09  = ' ' END IF
    IF l_ogb.ogb091 IS NULL THEN LET l_ogb.ogb091 = ' ' END IF
    IF l_ogb.ogb092 IS NULL THEN LET l_ogb.ogb092 = ' ' END IF
 
    LET l_ogb.ogb11 = l_oeb.oeb11
    LET l_ogb.ogb12 = l_rvv.rvv17
    LET l_ogb.ogb12 = s_digqty(l_ogb.ogb12,l_ogb.ogb05)   #FUN-BB0086 add
    LET l_ogb.ogb13 = l_oeb.oeb13 #MOD-7C0019
    SELECT img09 INTO l_ogb.ogb15
      FROM img_file
     WHERE img01 = l_oeb.oeb04  AND img02 = l_ogb.ogb09
       AND img03 = l_ogb.ogb091 AND img04 = l_ogb.ogb092
    LET l_ogb.ogb15_fac = 1
    LET l_ogb.ogb16 = l_rvv.rvv17
    LET l_ogb.ogb16 = s_digqty(l_ogb.ogb16,l_ogb.ogb15)   #No.FUN-BB0086 
    LET l_ogb.ogb17 = 'N'
    LET l_ogb.ogb18 = l_rvv.rvv17
    LET l_ogb.ogb18 = s_digqty(l_ogb.ogb18,l_ogb.ogb05)   #No.FUN-BB0086 
    SELECT rvb39 INTO l_ogb.ogb19 FROM rvb_file
     WHERE rvb04 = l_rvv.rvv36 AND rvb03 = l_rvv.rvv37
    LET l_ogb.ogb31 = l_oeb.oeb01
    LET l_ogb.ogb32 = l_oeb.oeb03
    LET l_ogb.ogb60 = 0
    LET l_ogb.ogb63 = 0
    LET l_ogb.ogb64 = 0
    LET l_ogb.ogb908 = l_oeb.oeb908
    LET l_ogb.ogb910 = l_rvv.rvv80
    LET l_ogb.ogb911 = l_rvv.rvv81
    LET l_ogb.ogb912 = l_rvv.rvv82
    LET l_ogb.ogb913 = l_rvv.rvv83
    LET l_ogb.ogb914 = l_rvv.rvv84
    LET l_ogb.ogb915 = l_rvv.rvv85
    LET l_ogb.ogb916 = l_rvv.rvv86
    LET l_ogb.ogb917 = l_rvv.rvv87
    LET l_ogb.ogb65  = ''
    LET l_ogb.ogb41 = l_oeb.oeb41    #專案
    LET l_ogb.ogb42 = l_oeb.oeb42    #WBS
    LET l_ogb.ogb43 = l_oeb.oeb43    #活動
    LET l_ogb.ogb1001 = l_oeb.oeb1001 #費用原因
    LET l_ogb.ogb1002 = l_oeb.oeb1002
    LET l_ogb.ogb1003 = l_oeb.oeb15
    LET l_ogb.ogb1004 = l_oeb.oeb1004
    LET l_ogb.ogb1005 = '1'
    LET l_ogb.ogb1006 = l_oeb.oeb1006
    LET l_ogb.ogb1007 = l_oeb.oeb1007
    LET l_ogb.ogb1008 = l_oeb.oeb1008
    LET l_ogb.ogb1009 = l_oeb.oeb1009
    LET l_ogb.ogb1010 = l_oeb.oeb1010
    LET l_ogb.ogb1012 = 'N'
    LET l_ogb.ogb1013 = '0'
    LET l_ogb.ogb1014 = 'N'
    LET l_ogb.ogb930 = g_ogb930
    IF cl_null(l_ogb.ogb37) OR l_ogb.ogb37=0 THEN    #FUN-AB0061           
       LET l_ogb.ogb37=l_ogb.ogb13                   #FUN-AB0061           
    END IF                               #FUN-AB0061   
    LET l_ogb.ogb14  = l_ogb.ogb917*l_ogb.ogb13  #MOD-7C0019
    LET l_ogb.ogb14t = l_ogb.ogb14*(1+l_oea211/100)
    LET l_ogb.ogbplant = l_oeb.oebplant   #NO.FUN-960130
    LET l_ogb.ogblegal = l_oeb.oeblegal   #NO.FUN-960130
    LET l_ogb.ogb44 = '1' #MOD-C10116
    LET l_ogb.ogb47= 0    #MOD-C10116
    #FUN-AC0055 mark ---------------------begin-----------------------
    ##FUN-AB0096 --------------add start--------------
    #IF cl_null(l_ogb.ogb50) THEN
    #   LET l_ogb.ogb50 = '1'
    #END IF
    ##FUN-AB0096 -------------add end----------------------
    #FUN-AC0055 mark ----------------------end------------------------
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
    IF g_aza.aza115='Y' THEN 
       SELECT oga14,oga15 INTO l_oga14,l_oga15 FROM oga_file WHERE oga01=l_ogb.ogb01
       CALL s_reason_code(l_ogb.ogb01,l_ogb.ogb31,'',l_ogb.ogb04,l_ogb.ogb09,l_oga14,l_oga15) RETURNING l_ogb.ogb1001
       IF cl_null(l_ogb.ogb1001) THEN 
          CALL cl_err(l_ogb.ogb1001,'aim-425',1)
          LET g_success = 'N'
          EXIT FOREACH
       END IF
    END IF
    #FUN-CB0087--add--end--
    INSERT INTO ogb_file VALUES(l_ogb.*)
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","ogb_file",l_ogb.ogb01,l_ogb.ogb03,SQLCA.sqlcode,"","ins ogb",1)
       LET g_success = 'N'
       EXIT FOREACH
    END IF
  END FOREACH
  IF g_success = 'Y' THEN
    CALL t720_upd_oga(p_oga01)
  END IF
END FUNCTION
 
FUNCTION t720_upd_oga(p_oga01)
  DEFINE p_oga01  LIKE oga_file.oga01
  DEFINE l_oga50  LIKE oga_file.oga50,
         l_oga51  LIKE oga_file.oga51,
         l_oga52  LIKE oga_file.oga52,
         l_oga53  LIKE oga_file.oga53,
         l_oga161 LIKE oga_file.oga161,
         l_oga162 LIKE oga_file.oga162,
         l_oga163 LIKE oga_file.oga163
 
   LET l_oga50 = NULL
   LET l_oga161= NULL    #No.MOD-880057 
   LET l_oga162= NULL    #No.MOD-880057
   LET l_oga163= NULL    #No.MOD-880057
 
   SELECT SUM(ogb14) INTO l_oga50 FROM ogb_file
    WHERE ogb01 = p_oga01
 
   IF cl_null(l_oga50) THEN LET l_oga50 = 0 END IF
   SELECT oga161,oga162,oga163 INTO l_oga161,l_oga162,l_oga163 
     FROM oga_file 
    WHERE oga01 = p_oga01 
   IF cl_null(l_oga161) THEN LET l_oga161 = 0 END IF 
   IF cl_null(l_oga162) THEN LET l_oga162 = 0 END IF 
   IF cl_null(l_oga163) THEN LET l_oga163 = 0 END IF 
   LET l_oga52 = l_oga50 * l_oga161/100
   LET l_oga53 = l_oga50 * (l_oga162+l_oga163)/100
 
   UPDATE oga_file SET oga50=l_oga50,
                       oga52=l_oga52,
                       oga53=l_oga53
    WHERE oga01 = p_oga01
   IF STATUS THEN
      LET g_success = 'N'
   END IF
 
END FUNCTION


FUNCTION t720_u_tlfs() #------------------------------------ Update tlfs_file
   DEFINE l_ima918   LIKE ima_file.ima918   #No.MOD-840347
   DEFINE l_ima921   LIKE ima_file.ima921   #No.MOD-840347
 
   SELECT ima918,ima921 INTO l_ima918,l_ima921 
     FROM ima_file
    WHERE ima01 = b_rvv.rvv31
      AND imaacti = "Y"
   
   IF cl_null(l_ima918) THEN
      LET l_ima918='N'
   END IF
                                                                                
   IF cl_null(l_ima921) THEN
      LET l_ima921='N'
   END IF
 
   IF l_ima918 = "N" AND l_ima921 = "N" THEN
      RETURN
   END IF
 
   IF b_rvv.rvv17 = 0 THEN                                                      
      RETURN                                                                    
   END IF                                                                       

   #MOD-C40098 add start -----
   IF g_sma.sma90 = 'N' AND g_rvu.rvu00 = 2 THEN
      RETURN
   END IF
   #MOD-C40098 add end   -----
 
   IF g_bgjob = 'N' THEN
      MESSAGE "d_tlfs!"
   END IF
 
   CALL ui.Interface.refresh()
 
   DELETE FROM tlfs_file
    WHERE tlfs01 = b_rvv.rvv31
      AND tlfs10 = g_rvu.rvu01
      AND tlfs11 = b_rvv.rvv02
      AND tlfs111 = g_rvu.rvu03
 
   IF STATUS THEN
      IF g_bgerr THEN
         LET g_showmsg = b_rvv.rvv31,'/',g_rvu.rvu02
         CALL s_errmsg('tlfs01,tlfs111',g_showmsg,'del tlfs:',STATUS,1)
      ELSE
         CALL cl_err3("del","tlfs_file",g_rvu.rvu01,"",STATUS,"","del tlfs",1)
      END IF
      LET g_success='N'
      RETURN
   END IF
 
   IF SQLCA.SQLERRD[3]=0 THEN    
      IF g_bgerr THEN
         LET g_showmsg = b_rvv.rvv31,'/',g_rvu.rvu02
         CALL s_errmsg('tlfs01,tlfs111',g_showmsg,'del tlfs:','mfg0177',1)
      ELSE
         CALL cl_err3("del","tlfs_file",g_rvu.rvu01,"","mfg0177",
                      "","del tlfs",1)
      END IF
      LET g_success='N'
      RETURN
   END IF
 
END FUNCTION
 
FUNCTION t720_getprice()
DEFINE l_pmc930 LIKE pmc_file.pmc930
DEFINE l_gec04  LIKE gec_file.gec04
DEFINE l_success LIKE type_file.num5
      
      SELECT gec04 INTO l_gec04 FROM gec_file,pmc_file
       WHERE gec01 = pmc47 AND pmc01 = g_rvu.rvu04
      SELECT pmc930 INTO l_pmc930 FROM pmc_file
       WHERE pmc01 = g_rvu.rvu04
      IF l_success THEN
         LET g_rvv[l_ac].rvv38t = g_rvv[l_ac].rvv38*(1+l_gec04/100)
      END IF  
      DISPLAY BY NAME g_rvv[l_ac].rvv38,g_rvv[l_ac].rvv38t
END FUNCTION
 
FUNCTION t720_get_azi()
DEFINE l_rva113          LIKE rva_file.rva113   ##No.FUN-940083
 
   LET t_azi03=''
   LET t_azi04=''
  #IF g_rva00 = '1' AND g_rvu.rvu00 = '3' THEN                       #MOD-BB0318 mark
   IF (g_rva00 = '1' AND g_rvu.rvu00 = '3') OR cl_null(g_rva00) THEN #MOD-BB0318
      #MOD-C40047 add start -----
      IF NOT cl_null(g_rvv[l_ac].rvv36) THEN
        SELECT pmm22 INTO l_rva113 FROM pmm_file WHERE pmm01 = g_rvv[l_ac].rvv36
      ELSE
        LET l_rva113 = g_rvu.rvu113
      END IF
      #MOD-C40047 add end   -----
      SELECT azi03,azi04 INTO t_azi03,t_azi04 FROM azi_file
       WHERE azi01 = l_rva113      #MOD-C40047 add
           #WHERE azi01 = g_rvu.rvu113 #MOD-C40047 mark
   END IF
   IF g_rva00 = '1' AND g_rvu.rvu00 <> '3' THEN
    IF NOT cl_null(g_rvv[l_ac].rvv36) THEN         #MOD-C40047 add
      SELECT azi03,azi04 INTO t_azi03,t_azi04
        FROM pmm_file,azi_file
       WHERE pmm22=azi01
         AND pmm01 = g_rvv[l_ac].rvv36 AND pmm18 <> 'X'
    #MOD-C40047 add start -----
    ELSE
      LET l_rva113 = g_rvu.rvu113
    END IF
    #MOD-C40047 add end   -----
   END IF
   IF g_rva00 = '2' THEN
     #SELECT rva113 INTO l_rva113 FROM rva_file WHERE rva01 = g_rvu.rvu02  #MOD-C40047 mark
     #MOD-C40047 str add-----
      IF NOT cl_null(g_rvv[l_ac].rvv36) THEN
        SELECT pmm43 INTO l_rva113 FROM pmm_file WHERE pmm01 = g_rvv[l_ac].rvv36
      ELSE
        LET l_rva113 = g_rvu.rvu113
      END IF
     #MOD-C40047 end add----- 
      SELECT azi03,azi04 INTO t_azi03,t_azi04 FROM azi_file
          WHERE azi01 = l_rva113
   END IF
    IF cl_null(t_azi03) THEN
       SELECT azi03,azi04 INTO t_azi03,t_azi04
         FROM pmc_file,azi_file
        WHERE pmc22=azi01
          AND pmc01 = g_rvu.rvu04
    END IF
    IF cl_null(t_azi03) THEN LET t_azi03=0 END IF
    IF cl_null(t_azi04) THEN LET t_azi04=0 END IF   #MOD-C40047 add
END FUNCTION
#MOD-CA0007 add start ------
FUNCTION t720_get_azi_2()
   DEFINE l_rva113          LIKE rva_file.rva113

   LET t_azi03=''
   LET t_azi04=''
   IF NOT cl_null(g_rvu.rvu113) THEN
      LET l_rva113 = g_rvu.rvu113
      SELECT azi03,azi04 INTO t_azi03,t_azi04 FROM azi_file
       WHERE azi01 = l_rva113
   END IF
   IF cl_null(t_azi03) THEN
      SELECT azi03,azi04 INTO t_azi03,t_azi04
        FROM pmc_file,azi_file
       WHERE pmc22 = azi01
         AND pmc01 = g_rvu.rvu04
   END IF
   IF cl_null(t_azi03) THEN LET t_azi03 = 0 END IF
   IF cl_null(t_azi04) THEN LET t_azi04 = 0 END IF
END FUNCTION
#MOD-CA0007 add end   ------
FUNCTION t720_gen_note()
DEFINE l_cnt          LIKE type_file.num5
DEFINE i              LIKE type_file.num5
DEFINE li_result      LIKE type_file.chr1
DEFINE l_flag         LIKE type_file.chr1
DEFINE l_cmd          LIKE type_file.chr1000
DEFINE l_pmm904       LIKE pmm_file.pmm904
DEFINE l_poy02        LIKE poy_file.poy02
DEFINE l_imm   RECORD LIKE imm_file.*
DEFINE l_imn   RECORD LIKE imn_file.*
DEFINE l_rvbs  RECORD LIKE rvbs_file.*
DEFINE tm      RECORD
       slip    LIKE   smy_file.smyslip
               END RECORD
DEFINE l_store STRING                    #FUN-CB0087--qiull--add--

   LET l_cnt = 0
   LET l_poy02 = ''
   SELECT COUNT(*) INTO l_cnt FROM imm_file                                                                                         
    WHERE imm09 = g_rvu.rvu01                                                                                                       
   IF l_cnt > 0 THEN                                                                                                                
      CALL cl_err(g_rvu.rvu01,'apm-076',0)                                                                                          
      RETURN                                                                                                                        
   END IF
   IF g_rvu.rvuconf='N' THEN
      CALL cl_err('','mfg3550',0)
      RETURN
   END IF
   IF g_rvu.rvuconf='X' THEN
      CALL cl_err('','9024',0)
      RETURN
   END IF
   SELECT DISTINCT pmm904 INTO l_pmm904
     FROM pmm_file
    #-----MOD-A70203---------
    #WHERE pmm99=g_rvu.rvu99
    WHERE pmm01 IN (SELECT rvv36 FROM rvv_file where rvv01=g_rvu.rvu01)
    #-----END MOD-A70203-----
   SELECT poy02 INTO l_poy02 FROM poy_file,poz_file,azp_file
    WHERE poy01=poz01
      AND poz01=l_pmm904
      AND poy04=azp01
      AND azp01 = g_plant      #FUN-980020
   IF l_poy02 <> 0 OR cl_null(l_poy02) THEN
      CALL cl_err('','apm-075',0)
      RETURN
   END IF
   LET tm.slip = ' '
                                                                                                                                    
   OPEN WINDOW p201_exp WITH FORM "apm/42f/apmp201a"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("apmp201a")
   INPUT BY NAME tm.slip WITHOUT DEFAULTS
      AFTER FIELD slip
         IF NOT cl_null(tm.slip) THEN
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt
              FROM smy_file
             WHERE smysys='aim'
               AND smykind='4'
               AND smyslip=tm.slip
            IF l_cnt = 0 THEN
               CALL cl_err(tm.slip,'aap-091',0)
               NEXT FIELD slip
            END IF
         END IF
      ON ACTION controlp
         CASE
            WHEN INFIELD(slip)
               CALL q_smy(FALSE,FALSE,tm.slip,'AIM','4') RETURNING tm.slip
               DISPLAY BY NAME tm.slip
               NEXT FIELD slip
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
      LET INT_FLAG=0
      CLOSE WINDOW p201_exp
      RETURN
   END IF
   CLOSE WINDOW p201_exp
#---------------調撥單單頭------------
   LET g_success = 'Y'
   BEGIN WORK
   INITIALIZE l_imm.* TO NULL #MOD-C80178 add
   CALL s_auto_assign_no("aim",tm.slip,g_today,"4","imm_file","imm01","","","")
      RETURNING li_result,l_imm.imm01
   IF (NOT li_result) THEN
      LET g_success = 'N'
      CALL cl_err('','abm-621',0)
      ROLLBACK WORK
   END IF
                                                                                                                                    
   LET l_imm.imm02=g_today
   LET l_imm.imm03="N"
   LET l_imm.imm09=g_rvu.rvu01
   LET l_imm.imm10="1"
   LET l_imm.immacti="Y"
   LET l_imm.immuser=g_user
   LET l_imm.immgrup=g_grup
   LET l_imm.immdate=g_today
   #LET l_imm.immconf="Y" #CHI-BB0021 mark
   LET l_imm.immconf="N"  #CHI-BB0021 add
   LET l_imm.imm14=g_grup
   LET l_imm.immplant=g_plant #FUN-980006 add
   LET l_imm.immlegal=g_legal #FUN-980006 add
   LET l_imm.immoriu = g_user      #No.FUN-980030 10/01/04
   LET l_imm.immorig = g_grup      #No.FUN-980030 10/01/04
   #FUN-A60034--add---str---
   #FUN-A70104--mod---str---
   LET l_imm.immmksg = 'N'          #是否簽核
   LET l_imm.imm15 = '0'            #簽核狀況
   LET l_imm.imm16 = g_user         #申請人
   #FUN-A70104--mod---end---
   #FUN-A60034--add---end---
   INSERT INTO imm_file VALUES(l_imm.*)
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL cl_err3("ins","imm_file",l_imm.imm01,"",SQLCA.sqlcode,"","ins imm",1)
      ROLLBACK WORK
      RETURN
   END IF
#--------------調撥單單身--------------
   FOR i=1 TO g_rec_b
      LET l_imn.imn01=l_imm.imm01
      LET l_imn.imn02=g_rvv[i].rvv02
      LET l_imn.imn03=g_rvv[i].rvv31
      LET l_imn.imn04=g_rvv[i].rvv32
      LET l_imn.imn05=g_rvv[i].rvv33
      LET l_imn.imn06=g_rvv[i].rvv34
      SELECT img09 INTO l_imn.imn09
        FROM img_file
       WHERE img01=l_imn.imn03
         AND img02=l_imn.imn04
         AND img03=l_imn.imn05
         AND img04=l_imn.imn06
      IF cl_null(l_imn.imn09) THEN
         LET l_imn.imn09 = ' '
      END IF
      #LET l_imn.imn10=g_rvv[i].rvv17                    #MOD-C10136 mark 
      LET l_imn.imn10=g_rvv[i].rvv17*g_rvv[i].rvv35_fac  #MOD-C10136 add
      LET l_imn.imn10=s_digqty(l_imn.imn10,l_imn.imn09)   #No.FUN-BB0086
      SELECT ima35,ima36 INTO l_imn.imn15,l_imn.imn16
        FROM ima_file
       WHERE ima01=g_rvv[i].rvv31
      #No.FUN-AB0058  mark--Begin
      #No.FUN-AA0049--begin
      #IF NOT s_chk_ware(l_imn.imn15) THEN
      #   LET l_imn.imn15=' '
      #   LET l_imn.imn16=' '
      #END IF 
      #No.FUN-AA0049--end           
      #No.FUN-AB0058  mark--End
      IF cl_null(l_imn.imn15) THEN
         LET l_imn.imn15 = ' '
      END IF
      IF cl_null(l_imn.imn16) THEN
         LET l_imn.imn16 = ' '
      END IF
      LET l_imn.imn17=g_rvv[i].rvv34
      SELECT img09 INTO l_imn.imn20 FROM img_file
       WHERE img01=l_imn.imn03
         AND img02=l_imn.imn15
         AND img03=l_imn.imn16
         AND img04=l_imn.imn17
      IF cl_null(l_imn.imn20) THEN
         LET l_imn.imn20 = ' '
      END IF
      CALL s_umfchk(g_rvv[i].rvv31,l_imn.imn09,l_imn.imn20)
         RETURNING l_flag,l_imn.imn21
      IF l_flag THEN
         LET l_imn.imn21 = 1
      END IF
      LET l_imn.imn22=l_imn.imn10*l_imn.imn21
      LET l_imn.imn22=s_digqty(l_imn.imn22,l_imn.imn20)   #No.FUN-BB0086
      LET l_imn.imn29='N'
      LET l_imn.imn30=g_rvv[i].rvv80
      CALL s_umfchk(g_rvv[i].rvv31,g_rvv[i].rvv80,l_imn.imn09)
         RETURNING l_flag,l_imn.imn31
      IF l_flag THEN
         LET l_imn.imn31 = 1
      END IF
      LET l_imn.imn32=l_imn.imn10*l_imn.imn31
      LET l_imn.imn32=s_digqty(l_imn.imn32,l_imn.imn30)   #No.FUN-BB0086
      LET l_imn.imn33=g_rvv[i].rvv83
      CALL s_umfchk(g_rvv[i].rvv31,g_rvv[i].rvv83,l_imn.imn20)
         RETURNING l_flag,l_imn.imn34
      IF l_flag THEN
         LET l_imn.imn34 = 1
      END IF
      LET l_imn.imn35=l_imn.imn10*l_imn.imn34
      LET l_imn.imn35=s_digqty(l_imn.imn35,l_imn.imn33)   #No.FUN-BB0086
      LET l_imn.imn40=g_rvv[i].rvv80
      CALL s_umfchk(g_rvv[i].rvv31,g_rvv[i].rvv80,l_imn.imn09)
         RETURNING l_flag,l_imn.imn41
      IF l_flag THEN
         LET l_imn.imn41 = 1
      END IF
      LET l_imn.imn42=l_imn.imn10*l_imn.imn41
      LET l_imn.imn42=s_digqty(l_imn.imn42,l_imn.imn40)   #No.FUN-BB0086
      LET l_imn.imn43=g_rvv[i].rvv83
      CALL s_umfchk(g_rvv[i].rvv31,g_rvv[i].rvv83,l_imn.imn20)
         RETURNING l_flag,l_imn.imn44
      IF l_flag THEN
         LET l_imn.imn44 = 1
      END IF
      LET l_imn.imn45=l_imn.imn10*l_imn.imn44
      LET l_imn.imn45=s_digqty(l_imn.imn45,l_imn.imn43)   #No.FUN-BB0086
      LET l_imn.imn51=1
      LET l_imn.imn52=1
      LET l_imn.imnplant=g_plant #FUN-980006 add
      LET l_imn.imnlegal=g_legal #FUN-980006 add
      #FUN-CB0087---qiull---add---str---
      IF g_aza.aza115 = 'Y' THEN
         LET l_store = ''
         IF NOT cl_null(l_imn.imn04) THEN
            LET l_store = l_store,l_imn.imn04
         END IF
         IF NOT cl_null(l_imn.imn15) THEN
            IF NOT cl_null(l_store) THEN
               LET l_store = l_store,"','",l_imn.imn15
            ELSE
               LET l_store = l_store,l_imn.imn15
            END IF
         END IF
         CALL s_reason_code(l_imn.imn01,'','',l_imn.imn03,l_store,l_imm.imm16,l_imm.imm14) RETURNING l_imn.imn28
         IF cl_null(l_imn.imn28) THEN
            CALL cl_err('','aim-425',1)
            LET g_success = 'N'
            ROLLBACK WORK
            RETURN 
         END IF
      END IF
      #FUN-CB0087---qiull---add---end---
      INSERT INTO imn_file VALUES(l_imn.*)
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         CALL cl_err3("ins","imn_file",l_imn.imn01,l_imn.imn02,SQLCA.sqlcode,"","ins imn",1)
         ROLLBACK WORK
         RETURN
      END IF
   END FOR
#----------------產生批序號資料---------------
   DECLARE t720_rvbs_cs CURSOR FOR
   SELECT * FROM rvbs_file
    WHERE rvbs00='apmt740' AND rvbs01=g_rvu.rvu01
   FOREACH t720_rvbs_cs INTO l_rvbs.*
      IF STATUS THEN
         LET g_success = 'N'
         CALL cl_err('foreach:',SQLCA.sqlcode,0)
         ROLLBACK WORK
         RETURN
      END IF
      LET l_rvbs.rvbs00='aimt324'
      LET l_rvbs.rvbs01=l_imm.imm01
      LET l_rvbs.rvbsplant = g_plant #FUN-980006 add
      LET l_rvbs.rvbslegal = g_legal #FUN-980006 add
      INSERT INTO rvbs_file VALUES(l_rvbs.*)
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         CALL cl_err3("ins","rvbs_file",l_rvbs.rvbs00,l_rvbs.rvbs01,SQLCA.sqlcode,"","ins rvbs",1)
         ROLLBACK WORK
         RETURN
      END IF
   END FOREACH
   IF g_success = 'Y' THEN
      COMMIT WORK
   END IF
  #LET l_cmd = "aimt324 '",l_imm.imm01,"' 'A'" CLIPPED     #FUN-A60034 mark
   LET l_cmd = "aimt324 '",l_imm.imm01,"' ' ' 'A'" CLIPPED #FUN-A60034 add
   CALL cl_cmdrun_wait(l_cmd)
END FUNCTION
 
FUNCTION t720_m()                                                                                                                   
  DEFINE li_result   LIKE type_file.num5                                                                                            
  DEFINE l_rvv    RECORD LIKE rvv_file.*,                                                                                           
         l_sfa    RECORD LIKE sfa_file.*,                                                                                           
         l_sfs    RECORD LIKE sfs_file.*,                                                                                           
         l_qpa    LIKE sfa_file.sfa161,                                                                                             
         l_qty    LIKE sfs_file.sfs05,                                                                                              
         g_rvu16  LIKE rvu_file.rvu16,                                                                                              
         g_t1     LIKE oay_file.oayslip,                                                                                            
         l_flag   LIKE type_file.chr1,                                                                                              
         l_name   LIKE type_file.chr20,                                                                                             
         l_sfp    RECORD                                                                                                            
               sfp01   LIKE sfp_file.sfp01,                                                                                         
               sfp02   LIKE sfp_file.sfp02,                                                                                         
               sfp03   LIKE sfp_file.sfp03,                                                                                         
               sfp04   LIKE sfp_file.sfp04,                                                                                         
               sfp05   LIKE sfp_file.sfp05,                                                                                         
               sfp06   LIKE sfp_file.sfp06,                                                                                         
               sfp07   LIKE sfp_file.sfp07                                                                                          
                  END RECORD,                                                                                                       
         l_sfb81  LIKE sfb_file.sfb81,                                                                                              
         l_sfb82  LIKE sfb_file.sfb82,                                                                                              
         l_bdate  LIKE type_file.dat, 
         l_edate  LIKE type_file.dat,                                                                                               
         l_day    LIKE type_file.num5,                                                                                              
         l_cnt    LIKE type_file.num5                                                                                               
  DEFINE l_sfv11 LIKE sfv_file.sfv11                                                                                                
  DEFINE l_msg  LIKE type_file.chr1000                                                                                              
  DEFINE l_sfb04  LIKE sfb_file.sfb04                                                                                               
  DEFINE l_sfb02  LIKE sfb_file.sfb02                                                                                               
  DEFINE l_sfp02  LIKE sfp_file.sfp02                                                                                               
  DEFINE g_ima55  LIKE ima_file.ima55  
  DEFINE l_pmn43  LIKE pmn_file.pmn43   #FUN-A60076
  DEFINE l_pmn012 LIKE pmn_file.pmn012  #FUN-A60076
  DEFINE l_smy73  LIKE smy_file.smy73   #TQC-AC0293
                                                                                               
   DROP TABLE tmp                                                                                                                   
   CREATE TEMP TABLE tmp(                                                                                                                 
    a         LIKE oea_file.oea01,                                                                                                
    b         LIKE type_file.chr1000,                                                                                                 
    c         LIKE type_file.num15_3);  #FUN-A20044                                                                                                                                                                                                                              
#    c         LIKE ima_file.ima26);  #FUN-A20044                                                                                                                                                                                                                              
   IF g_rvu.rvu01 IS NULL THEN RETURN END IF                                                                                        
    SELECT * INTO g_rvu.* FROM rvu_file                                                                                             
     WHERE rvu01 = g_rvu.rvu01                                                                                                      
    IF g_rvu.rvuconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF                                                              
    IF g_rvu.rvuconf = 'N' THEN CALL cl_err('','mfg3550',0) RETURN END IF #此筆單據尚未確認 #CHI-B90036 add
    IF g_rvu.rvu16 IS NOT NULL THEN  #已產生領料單                                                                                  
       CALL cl_err(g_rvu.rvu16,'asf-826',0)  
       RETURN                                                                                                                       
    END IF                                                                                                                          
                                                                                                                                    
#...check單身工單是否有使用消耗性料件 -> 沒有則不可產生領料單                                                                       
    SELECT COUNT(*) INTO l_cnt FROM rvv_file,sfa_file                                                                               
     WHERE rvv01 = g_rvu.rvu01                                                                                                      
       AND rvv18 = sfa01 AND sfa11 = 'E'                                                                                            
    IF l_cnt = 0 THEN CALL cl_err('sel sfa','asf-735',0) RETURN  END IF                                                             
#............................................................                                                                       
                                                                                                                                    
    BEGIN WORK                                                                                                                      
                                                                                                                                    
    LET l_flag =' '                                                                                                                 
    LET g_success = 'Y'                                                                                                             
    INPUT g_rvu16 WITHOUT DEFAULTS FROM rvu16                                                                                       
       AFTER FIELD rvu16                                                                                                            
         IF NOT cl_null(g_rvu16) THEN                                                                                               
            CALL s_check_no("asf",g_rvu16,"","3","rvu_file","rvu16","")                                                             
                 RETURNING li_result,g_rvu.rvu16                                                                                    
            DISPLAY BY NAME g_rvu.rvu16                                                                                             
            IF (NOT li_result) THEN                                                                                                 
               NEXT FIELD rvu16
            END IF                                                                                                                  
           #TQC-AC0293 ---------------add start----------
            LET g_t1 = s_get_doc_no(g_rvu.rvu16)
            SELECT smy73 INTO l_smy73 FROM smy_file
             WHERE smyslip = g_t1
            IF l_smy73 = 'Y' THEN
               CALL cl_err('','asf-874',0)
               NEXT FIELD rvu16
            END IF
           #TQC-AC0293 ---------------add end-------------
            DISPLAY BY NAME g_rvu.rvu16                                                                                             
            LET g_rvu16=g_rvu.rvu16                                                                                                 
          END IF                                                                                                                    
                                                                                                                                    
       ON ACTION controlp                                                                                                           
          CASE WHEN INFIELD(rvu16)                                                                                                  
            LET g_t1 = s_get_doc_no(g_rvu.rvu16)                                                                                    
            LET g_sql = " (smy73 <> 'Y' OR smy73 is null ) "          #TQC-AC0293
            CALL smy_qry_set_par_where(g_sql)                         #TQC-AC0293
            CALL q_smy( FALSE, TRUE,g_t1,'ASF','3') RETURNING g_t1                                                                  
            LET g_rvu16=g_t1                                                                                                        
            DISPLAY BY NAME g_rvu16                                                                                                 
            NEXT FIELD rvu16                                                                                                        
               OTHERWISE EXIT CASE                                                                                                  
          END CASE                                                                                                                  
       ON IDLE g_idle_seconds                                                                                                       
          CALL cl_on_idle()                                                                                                         
          CONTINUE INPUT                                                                                                            
                                                                                                                                    
    END INPUT                                                                                                                       
                                                                                                                                    
    IF cl_null(g_rvu16) THEN   #未輸入任何data                                                                                      
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
    #新增一筆資料                                                                                                                   
    IF g_rvu16 IS NOT NULL THEN                                                                                                     
      #CALL s_auto_assign_no("apm",g_rvu.rvu16,g_rvu.rvu03,"","sfp_file","sfp01","","","") #MOD-B40258 mark                                            
       CALL s_auto_assign_no("asf",g_rvu.rvu16,g_rvu.rvu03,"","sfp_file","sfp01","","","") #MOD-B40258                                            
         RETURNING li_result,g_rvu.rvu16                                                                                            
       IF (NOT li_result) THEN                                                                                                      
          ROLLBACK WORK                                                                                                             
          RETURN                                                                                                                    
       END IF                                                                                                                       
    DISPLAY BY NAME g_rvu.rvu16                                                                                                     
    LET g_rvu16=g_rvu.rvu16                                                                                                         
      #----先檢查領料單身資料是否已經存在------------                                                                               
       DECLARE count_cur CURSOR FOR
           SELECT COUNT(*) FROM sfs_file                                                                                            
       WHERE sfs01 = g_rvu16                                                                                                        
       OPEN count_cur                                                                                                               
       FETCH count_cur INTO g_cnt                                                                                                   
       IF g_cnt > 0  THEN  #已存在                                                                                                  
          LET l_flag ='Y'                                                                                                           
       ELSE                                                                                                                         
          LET l_flag ='N'                                                                                                           
       END IF                                                                                                                       
       #-----------產生領料資料------------------------                                                                             
                                                                                                                                    
       DECLARE t720_rvv_cur CURSOR  WITH HOLD FOR                                                                                   
          SELECT *  FROM  rvv_file                                                                                                  
           WHERE rvv01 = g_rvu.rvu01                                                                                                
       LET l_cnt = 0                                                                                                                
       CALL cl_outnam('apmt730') RETURNING l_name                                                                                   
       START REPORT t720_rep TO l_name                                                                                              
                                                                                                                                    
       LET g_success = 'Y'                                                                                                          
       FOREACH t720_rvv_cur INTO l_rvv.*                                                                                            
         IF STATUS THEN                                                                                                             
            CALL cl_err('foreach s:',STATUS,0)                                                                                      
            LET g_success = 'N'                                                                                                     
            EXIT FOREACH
         END IF                                                                                                                     
         SELECT sfb04,sfb81,sfb02                                                                                                   
           INTO l_sfb04,l_sfb81,l_sfb02                                                                                             
           FROM sfb_file                                                                                                            
          WHERE sfb01 = l_rvv.rvv18                                                                                                 
                                                                                                                                    
                                                                                                                                    
         IF STATUS THEN                                                                                                             
            CALL cl_err3("sel","sfb_file",l_rvv.rvv18,"",STATUS,"","sel sfb",1)                                                     
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
         DECLARE t720_sfs_cur CURSOR WITH HOLD FOR                                                                                  
         SELECT sfa_file.*,sfb82 FROM sfb_file,sfa_file                                                                             
          WHERE sfb01 = l_rvv.rvv18   #工單單號                                                                                     
            AND sfb01 = sfa01                                                                                                       
            AND sfa11 = 'E'                                                                                                         
            AND sfb05 = l_rvv.rvv31   #MOD-C40173 add
            ORDER BY sfa26                                                                                                          
                                                                                                                                    
        FOREACH t720_sfs_cur INTO l_sfa.*,l_sfb82                                                                                   
            INITIALIZE l_sfs.* TO NULL                                                                                              
            INITIALIZE l_sfp.* TO NULL                                                                                              
                                                                                                                                    
        #-------發料單頭--------------                                                                                              
          LET l_sfp.sfp01 = g_rvu16                                                                                                 
#領料單月份以完工入庫日期該月的最後一天為領料日                                                                                     
          LET l_sfp.sfp02 = g_today                                                                                                 
          LET l_sfp.sfp03 = g_today                                                                                                 
          IF MONTH(g_today) != MONTH(g_rvu.rvu03) THEN                                                                              
             IF MONTH(g_rvu.rvu03) = 12 THEN                                                                                        
                LET l_bdate = MDY(MONTH(g_rvu.rvu03),1,YEAR(g_rvu.rvu03))                                                           
                LET l_edate = MDY(1,1,YEAR(g_rvu.rvu03)+1)  
             ELSE                                                                                                                   
                LET l_bdate = MDY(MONTH(g_rvu.rvu03),1,YEAR(g_rvu.rvu03))                                                           
                LET l_edate = MDY(MONTH(g_rvu.rvu03)+1,1,YEAR(g_rvu.rvu03))                                                         
             END IF                                                                                                                 
             LET l_day = l_edate - l_bdate   #計算最後一天日期                                                                      
             LET l_sfp.sfp03 = MDY(MONTH(g_rvu.rvu03),l_day,YEAR(g_rvu.rvu03))                                                      
          END IF                                                                                                                    
          LET l_sfp.sfp04 = 'N'                                                                                                     
          LET l_sfp.sfp05 = 'N'                                                                                                     
          LET l_sfp.sfp06 ='4'                                                                                                      
          LET l_sfp.sfp07 = l_sfb82                                                                                                 
          OUTPUT TO REPORT t720_rep(l_sfp.*,l_flag)                                                                                 
          SELECT MAX(sfs02) INTO l_cnt FROM sfs_file                                                                                
           WHERE sfs01 = g_rvu16                                                                                                    
          IF l_cnt IS NULL THEN    #項次                                                                                            
             LET l_cnt = 1                                                                                                          
          ELSE  LET l_cnt = l_cnt + 1                                                                                               
          END IF                                                                                                                    
         #-------發料單身--------------                                                                                             
          LET l_sfs.sfs01 = g_rvu16                                                                                                 
          LET l_sfs.sfs02 = l_cnt                                                                                                   
          LET l_sfs.sfs03 = l_sfa.sfa01
          LET l_sfs.sfs04 = l_sfa.sfa03                                                                                             
          #LET l_sfs.sfs05 = l_rvv.rvv09*l_sfa.sfa161 #已發料量   #MOD-A70228                                                                     
          LET l_sfs.sfs05 = l_rvv.rvv17*l_sfa.sfa161 #已發料量   #MOD-A70228                                                                     
          LET l_sfs.sfs06 = l_sfa.sfa12  #發料單位 
          LET l_sfs.sfs05 = s_digqty(l_sfs.sfs05,l_sfs.sfs06)   #No.FUN-BB0086
          LET l_sfs.sfs07 = l_sfa.sfa30  #倉庫                                                                                      
          LET l_sfs.sfs08 = l_sfa.sfa31  #儲位                                                                                      
          LET l_sfs.sfs09 = ' '          #批號                                                                                      
          LET l_sfs.sfs10 = l_sfa.sfa08  #作業序號                                                                                  
          LET l_sfs.sfs26 = NULL         #替代碼                                                                                    
          LET l_sfs.sfs27 = NULL         #被替代料號                                                                                
         #LET l_sfs.sfs28 = NULL         #替代率 #MOD-D10089 mark                                                                                   
          LET l_sfs.sfs28 = 1            #替代率 #MOD-D10089 add
          LET l_sfs.sfs930 = l_rvv.rvv930                                                                                           
          LET l_sfs.sfsplant = g_plant
          LET l_sfs.sfslegal = g_legal
          LET l_sfs.sfs012 = l_sfa.sfa012  #FUN-A60076
          LET l_sfs.sfs013 = l_sfa.sfa013  #FUN-A60076
          LET l_sfs.sfs014 = ' '           #FUN-C70014 add
         #IF l_sfa.sfa26 MATCHES '[SUT]' THEN      #FUN-A20037 
          IF l_sfa.sfa26 MATCHES '[SUTZ]' THEN      #FUN-A20037 
             LET l_sfs.sfs26 = l_sfa.sfa26                                                                                          
             LET l_sfs.sfs27 = l_sfa.sfa27                                                                                          
             LET l_sfs.sfs28 = l_sfa.sfa28                                                                                          
             #FUN-A60076 --------------------------start--------------------- 
             SELECT pmn43,pmn012 INTO l_pmn43,l_pmn012 FROM pmn_file
              WHERE pmn01 = l_rvv.rvv36 
                AND pmn02 = l_rvv.rvv37
             #FUN-A60076 -------------------------end------------------------ 
             SELECT (sfa161 * sfa28) INTO l_qpa FROM sfa_file                                                                       
                WHERE sfa01 = l_sfa.sfa01 AND sfa03 = l_sfa.sfa27                                                                   
                  AND sfa012 = l_pmn012 AND sfa013  = l_pmn43   #FUN-A60076
             #LET l_sfs.sfs05 = l_rvv.rvv09*l_qpa   #MOD-A70228                                                                                 
             LET l_sfs.sfs05 = l_rvv.rvv17*l_qpa   #MOD-A70228   
             SELECT SUM(c) INTO l_qty FROM tmp WHERE a = l_sfa.sfa01                                                                
                AND b = l_sfa.sfa27                                                                                                 
             IF l_sfs.sfs05 < l_qty THEN                                                                                            
                LET l_sfs.sfs05 = 0 
             ELSE                                                                                                                   
                LET l_sfs.sfs05 = l_sfs.sfs05 - l_qty                                                                               
             END IF                                                                                                                 
          ELSE                                                                                                                      
             LET l_sfs.sfs27 = l_sfa.sfa27                                                                                          
          END IF                                                                                                                    
          CALL t720_chk_ima64(l_sfs.sfs04, l_sfs.sfs05) RETURNING l_sfs.sfs05
          LET l_sfs.sfs05 = s_digqty(l_sfs.sfs05,l_sfs.sfs06)   #No.FUN-BB0086          
        #判斷發料是否大於可發料數(sfa05-sfa06)                                                                                      
          IF l_sfs.sfs05 > (l_sfa.sfa05 - l_sfa.sfa06) THEN                                                                         
             LET l_sfs.sfs05 = l_sfa.sfa05 - l_sfa.sfa06                                                                            
          END IF                                                                                                                    
          IF cl_null(l_sfs.sfs07) AND cl_null(l_sfs.sfs08) THEN                                                                     
             SELECT ima35,ima36 INTO  l_sfs.sfs07,l_sfs.sfs08                                                                       
               FROM ima_file                                                                                                        
              WHERE ima01 = l_sfs.sfs04    
              #No.FUN-AB0058 mark--begin
              #No.FUN-AA0049--begin
              #IF NOT s_chk_ware(l_sfs.sfs07) THEN
              #   LET l_sfs.sfs07=' '
              #   LET l_sfs.sfs08=' '
              #END IF 
              #No.FUN-AA0049--end                                                                                                            
              #No.FUN-AB0058 mark--End
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
                LET l_sfs.sfs35=s_digqty(l_sfs.sfs35,l_sfs.sfs33)   #No.FUN-BB0086
             END IF                                                                                                                 
             IF g_ima906='1' THEN                                                                                                   
                LET l_sfs.sfs33=NULL                                                                                                
                LET l_sfs.sfs34=NULL                                                                                                
                LET l_sfs.sfs35=NULL                                                                                                
             END IF                                                                                                                 
          END IF  
         OPEN t720_cl USING g_rvu.rvu01                                                                                             
         IF STATUS THEN                                                                                                             
            CALL cl_err("OPEN t720_cl:", STATUS, 1)                                                                                 
            CLOSE t720_cl                                                                                                           
            ROLLBACK WORK                                                                                                           
            RETURN                                                                                                                  
         END IF                                                                                                                     
         FETCH t720_cl INTO g_rvu.*          # 鎖住將被更改或取消的資料                                                             
         IF SQLCA.sqlcode THEN                                                                                                      
            CALL cl_err(g_rvu.rvu01,SQLCA.sqlcode,0)     # 資料被他人LOCK                                                           
            CLOSE t720_cl ROLLBACK WORK RETURN                                                                                      
         END IF                                                                                                                     
                                                                                                                                    
         IF l_flag ='N' THEN                                                                                                        
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
     FINISH REPORT t720_rep                                                                                                         
     IF g_rvu16 IS NOT NULL THEN                                                                                                    
        LET g_rvu.rvu16 = g_rvu16                                                                                                   
        UPDATE rvu_file SET rvu16 = g_rvu.rvu16                                                                                     
         WHERE rvu01 = g_rvu.rvu01                                                                                                  
        IF STATUS THEN                                                                                                              
           CALL cl_err('upd rvu',STATUS,1)                                                                                          
           LET g_success = 'N'                                                                                                      
        END IF                                                                                                                      
        DISPLAY BY NAME g_rvu.rvu16                                                                                                 
     END IF                                                                                                                         
    END IF                                                                                                                          
    IF g_success = 'Y' THEN                                                                                                         
       COMMIT WORK                                                                                                                  
    ELSE                                                                                                                            
       ROLLBACK WORK                                                                                                                
    END IF
END FUNCTION                                                                                                                        
                                                                                                                                    
REPORT t720_rep(sr,p_flag)                                                                                                          
  DEFINE p_flag  LIKE type_file.chr1,                                                                                               
        sr  RECORD                                                                                                                  
            sfp01 LIKE sfp_file.sfp01,                                                                                              
            sfp02 LIKE sfp_file.sfp02,                                                                                              
            sfp03 LIKE sfp_file.sfp03,                                                                                              
            sfp04 LIKE sfp_file.sfp04,                                                                                              
            sfp05 LIKE sfp_file.sfp05,                                                                                              
            sfp06 LIKE sfp_file.sfp06,                                                                                              
            sfp07 LIKE sfp_file.sfp07                                                                                               
             END RECORD                                                                                                             
                                                                                                                                    
  ORDER BY sr.sfp01                                                                                                                 
  FORMAT                                                                                                                            
    AFTER GROUP OF sr.sfp01                                                                                                         
      IF p_flag ='Y' THEN                                                                                                           
         UPDATE sfp_file SET sfp02= sr.sfp02,                                                                                       
                             sfp04= sr.sfp04,sfp05 = sr.sfp05,                                                                      
                             sfp06= sr.sfp06,sfp07 = sr.sfp07,                                                                      
                             sfpgrup=g_grup,                                                                                        
                             sfpmodu=g_user,sfpdate=g_today 
          WHERE sfp01 = sr.sfp01                                                                                                    
         IF SQLCA.sqlcode THEN LET g_success='N' END IF                                                                             
      ELSE                                                                                                                          
         INSERT INTO sfp_file(sfp01,sfp02,sfp03,sfp04,sfp05,sfp06,sfp07,sfp09,          
                              sfp15,sfp16,sfpmksg,                             #FUN-AB0001 add                                            
                              sfpuser,sfpdate,sfpconf,sfpgrup,sfpplant,sfplegal,sfporiu,sfporig)                                                                      
              VALUES(sr.sfp01,sr.sfp02,sr.sfp03,sr.sfp04,                                                                           
                     sr.sfp05,sr.sfp06,sr.sfp07,'N', 
                     '0',g_user,g_smy.smyapr,                                  #FUN-AB0001 add                                                                               
                     g_user,g_today,'N',g_grup,g_plant,g_legal, g_user, g_grup)                                                                                           #No.FUN-980030 10/01/04  insert columns oriu, orig
         IF SQLCA.sqlcode THEN LET g_success='N' END IF                                                                             
      END IF                                                                                                                        
                                                                                                                                    
END REPORT                                                                                                                          
                                                                                                                                    
FUNCTION t720_chk_ima64(p_part, p_qty)                                                                                              
  DEFINE p_part         LIKE ima_file.ima01                                                                                         
  DEFINE p_qty          LIKE ima_file.ima641                                                                                        
  DEFINE l_ima108       LIKE ima_file.ima108                                                                                        
  DEFINE l_ima64        LIKE ima_file.ima64                                                                                         
  DEFINE l_ima641       LIKE ima_file.ima641                                                                                        
  DEFINE i              LIKE type_file.num10                                                                                        
                                                                                                                                    
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

#FUN-A10130--begin--add----                                                                                                         
FUNCTION t720_refresh()
 DEFINE l_rvu    RECORD LIKE rvu_file.*

 SELECT * INTO l_rvu.* FROM rvu_file WHERE rvu01=g_rvu.rvu01 
 RETURN l_rvu.*
END FUNCTION
#FUN-A10130--end--add-----        

#FUN-A60009 add str ---
FUNCTION t720_ef()
     CALL t720sub_y_chk(g_rvu.rvu01,g_argv1,g_argv2,g_argv3,g_chr,'N')
     IF g_success = "N" THEN
        RETURN
     END IF

     CALL aws_condition()                     #判斷送簽資料
     IF g_success = 'N' THEN
        RETURN
     END IF

  ##########
  # CALL aws_efcli2()
  # 傳入參數: (1)單頭資料, (2-6)單身資料
  # 回傳值  : 0 開單失敗; 1 開單成功
  ##########
   IF aws_efcli2(base.TypeInfo.create(g_rvu),base.TypeInfo.create(g_rvv),'','','','')
   THEN
       LET g_success='Y'
       LET g_rvu.rvu17='S'
       DISPLAY BY NAME g_rvu.rvu17
   ELSE
       LET g_success='N'
   END IF
END FUNCTION
#FUN-A60009 add end ---

#FUN-BC0104---add---str
FUNCTION t720_set_comp_visible()
DEFINE l_qcz14 LIKE qcz_file.qcz14

   SELECT qcz14 INTO l_qcz14 FROM qcz_file
      WHERE qcz00 = '0'
   IF l_qcz14 = 'N' THEN
      CALL cl_set_comp_visible('rvv45,rvv46,qcl02,rvv47',FALSE)
      CALL cl_set_act_visible('qc_determine_storage',FALSE)
   END IF
END FUNCTION

FUNCTION t720_qcl02_desc()
    
      SELECT qcl02 INTO g_rvv[l_ac].qcl02 FROM qcl_file
             WHERE qcl01 = g_rvv[l_ac].rvv46
      DISPLAY BY NAME  g_rvv[l_ac].qcl02 

END FUNCTION

FUNCTION t720_set_comp_required(p_rvv45,p_rvv46,p_rvv47)
   DEFINE p_rvv45 LIKE rvv_file.rvv45,
          p_rvv46 LIKE rvv_file.rvv46,
          p_rvv47 LIKE rvv_file.rvv47

   IF NOT cl_null(p_rvv45) OR NOT cl_null(p_rvv46) OR NOT cl_null(p_rvv47) THEN
      CALL cl_set_comp_required('rvv45,rvv46,rvv47',TRUE)
   END IF
 
   IF cl_null(p_rvv45) AND cl_null(p_rvv46) AND cl_null(p_rvv47) THEN
      CALL cl_set_comp_required('rvv45,rvv46,rvv47',FALSE)
      LET g_rvv[l_ac].qcl02 = ''
   END IF
END FUNCTION

FUNCTION t720_set_noentry_rvv45()
   CALL cl_set_comp_entry('rvv45,rvv46,rvv47',FALSE)
END FUNCTION

FUNCTION t720_qcl05_check() 
   DEFINE l_qcl05 LIKE qcl_file.qcl05

   IF NOT cl_null(g_rvv[l_ac].rvv46) THEN
      SELECT qcl05 INTO l_qcl05 FROM qcl_file
                                WHERE qcl01 = g_rvv[l_ac].rvv46
      RETURN l_qcl05
   END IF
RETURN '' 
END FUNCTION

FUNCTION t720_rvv46_check()
   DEFINE l_rvv46 LIKE rvv_file.rvv46
   DEFINE l_n     LIKE type_file.num5
   DEFINE l_n1    LIKE type_file.num5
   DEFINE l_sql   STRING
   DEFINE l_sql1  STRING
   DEFINE l_sql2  STRING

   LET l_n  = 0
   LET l_n1 = 0
  
   LET l_sql= "SELECT COUNT(*) FROM rvv_file",       
              " WHERE  rvv04 = ?", 
              "   AND  rvv05 = ?"
   LET l_sql1=l_sql CLIPPED," AND rvv46 IS NOT NULL AND rvv46<>' '"
   PREPARE insert_ln FROM l_sql1
   EXECUTE insert_ln INTO l_n USING g_rvu.rvu02,g_rvv[l_ac].rvv05 

   LET l_sql2=l_sql CLIPPED," AND (rvv46 IS NULL OR rvv46=' ')"
   PREPARE insert_ln1 FROM l_sql2       
   EXECUTE insert_ln1 INTO l_n1 USING g_rvu.rvu02,g_rvv[l_ac].rvv05
   
   IF l_n >0  THEN 
      CALL cl_set_comp_required('rvv45,rvv46,rvv47',TRUE)
   END IF
   IF l_n1 > 0 THEN 
      LET g_rvv[l_ac].rvv45 = ''
      LET g_rvv[l_ac].rvv46 = ''
      LET g_rvv[l_ac].rvv47 = ''
      DISPLAY BY NAME g_rvv[l_ac].rvv45,g_rvv[l_ac].rvv46,g_rvv[l_ac].rvv47
      CALL cl_set_comp_entry('rvv45,rvv46,rvv47',FALSE)
   END IF 
                 
END FUNCTION 

FUNCTION t720_qco_show()
DEFINE l_qcl05 LIKE qcl_file.qcl05,
       l_rvv80 LIKE rvv_file.rvv80,
       l_rvv82 LIKE rvv_file.rvv82,
       l_rvv83 LIKE rvv_file.rvv83,
       l_rvv85 LIKE rvv_file.rvv85,
       l_qco20 LIKE qco_file.qco20,
       l_img09 LIKE img_file.img09,
       l_i     LIKE type_file.num5,
       l_ima906 LIKE ima_file.ima906,
       l_ima44 LIKE ima_file.ima44
  
      SELECT qco06,qco07,qco08,qco09,qco10,qco13,qco15,qco16,qco18,qco20
                                           INTO g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv32,g_rvv[l_ac].rvv33, 
                                                g_rvv[l_ac].rvv34,g_rvv[l_ac].rvv35,l_rvv80,l_rvv82,
                                                l_rvv83,l_rvv85,l_qco20
                                           FROM qco_file
                                          WHERE qco01 = g_rvu.rvu02
                                            AND qco02 = g_rvv[l_ac].rvv05
                                            AND qco04 = g_rvv[l_ac].rvv47
                                            AND qco05 = g_rvv[l_ac].rvv45
                                            AND qco03 = g_rvv[l_ac].rvv46
      DISPLAY BY NAME g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv32,g_rvv[l_ac].rvv33,
                      g_rvv[l_ac].rvv34,g_rvv[l_ac].rvv35
      IF g_sma.sma115 = 'Y' THEN 
         LET g_rvv[l_ac].rvv80 = l_rvv80  #單位一賦值
         LET g_rvv[l_ac].rvv83 = l_rvv83  #單位二賦值
         CALL t720_set_origin_field()
         CALL s_du_umfchk(g_rvv[l_ac].rvv31,'','','',         #單位一換算率
                                g_rvv[l_ac].rvv35,g_rvv[l_ac].rvv80,'1')
                    RETURNING g_errno,g_factor
                  LET g_rvv[l_ac].rvv81 = g_factor
                  DISPLAY BY NAME g_rvv[l_ac].rvv81
         SELECT ima906,ima44 INTO l_ima906,l_ima44 FROM ima_file
                  WHERE ima01 = g_rvv[l_ac].rvv31
         CALL s_du_umfchk(g_rvv[l_ac].rvv31,'','','',         #單位二換算率
                                l_ima44,g_rvv[l_ac].rvv83,l_ima906)
                    RETURNING g_errno,g_factor
                  LET g_rvv[l_ac].rvv84 = g_factor
                  DISPLAY BY NAME g_rvv[l_ac].rvv84
      END IF
         CALL t720_qcl05_check() RETURNING l_qcl05
      IF l_qcl05 = '0' OR l_qcl05 = '2' THEN 
         IF g_sma.sma115 = 'N' THEN
            CALL t720_rvv17_rvv87_check('') RETURNING g_rvv[l_ac].rvv17 
            DISPLAY BY NAME g_rvv[l_ac].rvv17
         ELSE
            IF l_qco20=0 THEN
               LET g_rvv[l_ac].rvv82 = l_rvv82
               LET g_rvv[l_ac].rvv85 = l_rvv85
            ELSE
               LET g_rvv[l_ac].rvv82=0
               LET g_rvv[l_ac].rvv85=0
            END IF 
            CALL t720_set_origin_field()
            DISPLAY BY NAME g_rvv[l_ac].rvv82,g_rvv[l_ac].rvv85
         END IF
      END IF
      IF l_qcl05 = '1' THEN
         CALL t720_rvv17_rvv87_check('') RETURNING g_rvv[l_ac].rvv87
         IF g_rvv[l_ac].rvv87 = 0 THEN
            RETURN FALSE
         END IF
         LET g_rvv[l_ac].rvv17 = 0
         LET g_rvv[l_ac].rvv82 = 0
         LET g_rvv[l_ac].rvv85 = 0
         LET g_rvv[l_ac].rvv86 = g_rvv[l_ac].rvv35
         DISPLAY BY NAME g_rvv[l_ac].rvv17,g_rvv[l_ac].rvv87,g_rvv[l_ac].rvv86,
                         g_rvv[l_ac].rvv82,g_rvv[l_ac].rvv85
         IF g_sma.sma116 = '1' OR g_sma.sma116 = '3' THEN
            CALL cl_set_comp_entry('rvv87',TRUE)
         END IF
         IF g_sma.sma115 = 'Y' THEN
              LET g_rvv[l_ac].rvv82 = 0        #單位一
              LET g_rvv[l_ac].rvv85 = 0        #單位二
              DISPLAY BY NAME g_rvv[l_ac].rvv82,g_rvv[l_ac].rvv85
         END IF
      END IF
      IF l_qcl05 = '2' THEN
         LET g_rvv[l_ac].rvv86 = g_rvv[l_ac].rvv35
         LET g_rvv[l_ac].rvv87 = 0
         DISPLAY BY NAME g_rvv[l_ac].rvv86,g_rvv[l_ac].rvv87
      END IF
 RETURN TRUE
 END FUNCTION

FUNCTION t720_rvv17_rvv87_check(p_cmd)
DEFINE l_sum   LIKE qco_file.qco11,
       l_qcl05 LIKE qcl_file.qcl05,
       p_cmd   LIKE type_file.chr1,
       l_qco10 LIKE qco_file.qco10,
       l_i     LIKE type_file.num5,
       l_fac   LIKE rvv_file.rvv35_fac 

   SELECT qco11-qco20,qco10 INTO l_sum,l_qco10 FROM qco_file
                                      WHERE qco01 = g_rvu.rvu02
                                        AND qco02 = g_rvv[l_ac].rvv05
                                        AND qco04 = g_rvv[l_ac].rvv47
                                        AND qco05 = g_rvv[l_ac].rvv45
   IF cl_null(l_sum) THEN LET l_sum=0 END IF
   CALL t720_qcl05_check() RETURNING l_qcl05
   IF (l_qcl05 = '0' OR l_qcl05 = '2') AND p_cmd = 'u' THEN
      LET l_sum = l_sum+g_rvv_t.rvv17
      CALL s_umfchk(g_rvv[l_ac].rvv31,l_qco10,g_rvv[l_ac].rvv35)
          RETURNING l_i,l_fac
      IF l_i THEN LET l_fac=1 END IF
      LET l_sum = l_sum*l_fac
   END IF
   IF l_qcl05 = '1' AND p_cmd = 'u' THEN
      LET l_sum = l_sum+g_rvv_t.rvv87
      CALL s_umfchk(g_rvv[l_ac].rvv31,l_qco10,g_rvv[l_ac].rvv86)
          RETURNING l_i,l_fac
      IF l_i THEN LET l_fac=1 END IF
      LET l_sum = l_sum*l_fac
   END IF
   RETURN l_sum
END FUNCTION

FUNCTION t720_rvv32_check()
DEFINE l_n     LIKE type_file.num5,
       l_qcl05 LIKE qcl_file.qcl05,
       l_sql   STRING
   LET l_n = 0
   LET l_sql="SELECT COUNT(*) FROM qcl_file,imd_file",
             " WHERE qcl01='",g_rvv[l_ac].rvv46 CLIPPED,
             "' AND imd01 = '",g_rvv[l_ac].rvv32 CLIPPED,
             "' AND qcl03=imd11 AND qcl04=imd12"

   SELECT qcl05 INTO l_qcl05 FROM qcl_file 
                  WHERE qcl01 = g_rvv[l_ac].rvv46
                    
   IF l_qcl05 = '0' OR l_qcl05 = '1' THEN
      LET l_sql = l_sql CLIPPED," AND imd01 NOT IN(SELECT jce02 FROM jce_file)"
   END IF
   IF l_qcl05 = '2' THEN
      LET l_sql = l_sql CLIPPED," AND imd01 IN(SELECT jce02 FROM jce_file)"
   END IF

   PREPARE insert_l_n2 FROM l_sql
   EXECUTE insert_l_n2 INTO l_n

   IF l_n = 0 THEN
      RETURN FALSE 
   END IF
RETURN TRUE
END FUNCTION

FUNCTION t720_rvv45_46_47_check()
DEFINE l_n    LIKE type_file.num5,
       l_sql  STRING,
       l_qcl05_wc STRING,               #TQC-C30048
       l_qcl05_tf LIKE type_file.num5   #TQC-C30048
   
   LET l_n = 0   
   LET l_sql=" SELECT COUNT(*) FROM qcs_file,qco_file,qcl_file",
                 " WHERE qcs00='1' AND qcs14='Y' AND qco01=qcs01", 
                 " AND qco02=qcs02 AND qco05=qcs05 AND qcl01 = qco03 AND qco01='",g_rvu.rvu02 CLIPPED,
                 "' AND qco02=",g_rvv[l_ac].rvv05 CLIPPED

    IF NOT cl_null(g_rvv[l_ac].rvv45) THEN
       LET l_sql=l_sql CLIPPED," AND qco05=",g_rvv[l_ac].rvv45 CLIPPED
    END IF 
    IF NOT cl_null(g_rvv[l_ac].rvv46) THEN
      #TQC-C30048---add---str---
       LET l_qcl05_wc=''
       LET l_qcl05_tf=''
       CALL t720_qcl05_wc() RETURNING l_qcl05_wc,l_qcl05_tf
       IF l_qcl05_tf=1 THEN
          LET l_sql=l_sql CLIPPED," AND qcl05 IN ('0','1','2')"
       #ELSE                                                #FUN-CC0013 mark
       #   LET l_sql=l_sql CLIPPED," AND qcl05='3'"         #FUN-CC0013 mark
       END IF
      #TQC-C30048---add---end---
       LET l_sql=l_sql CLIPPED," AND qco03='",g_rvv[l_ac].rvv46 CLIPPED,"'"
    END IF
    IF NOT cl_null(g_rvv[l_ac].rvv47) THEN
       LET l_sql=l_sql CLIPPED," AND qco04=",g_rvv[l_ac].rvv47 CLIPPED
    END IF
    PREPARE insert_l_n FROM l_sql
    EXECUTE insert_l_n INTO l_n

    IF l_n = 0 THEN 
       RETURN FALSE
    END IF
RETURN TRUE
END FUNCTION

FUNCTION t720_rvv17(p_cmd)
DEFINE
    l_ac_t,i        LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680136 SMALLINT
    l_row,l_col     LIKE type_file.num5,                #No.FUN-680136 SMALLINT,              #分段輸入之行,列數
    l_n,l_cnt       LIKE type_file.num5,                #檢查重複用  #No.FUN-680136 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否  #No.FUN-680136 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態  #No.FUN-680136 VARCHAR(1)
    l_b2            LIKE type_file.chr50,                #No.FUN-680136 VARCHAR(30)
   #l_ima25         LIKE ima_file.ima25,     #FUN-A10130
    l_ima35         LIKE ima_file.ima35,
    l_ima36         LIKE ima_file.ima36,
    l_ima918        LIKE ima_file.ima918,    #No.MOD-930042 add
    l_ima921        LIKE ima_file.ima921,    #No.MOD-930042 add
    l_rvv17_3       LIKE rvv_file.rvv17,
    l_rvv17_2       LIKE rvv_file.rvv17,    #No.9786
    l_rvv17_3_other LIKE rvv_file.rvv17,    #No.9786
    l_rvv17_1_other LIKE rvv_file.rvv17,    #MOD-5A0431 add
    l_rvv17_2_other LIKE rvv_file.rvv17,    #No.9786
    l_rvv17_return  LIKE rvv_file.rvv17,    #MOD-6A0118 add
    l_rvb07         LIKE rvb_file.rvb07,    #MOD-820189 add
    l_rvb87         LIKE rvb_file.rvb87,    #MOD-820189 add
    l_rvb39         LIKE rvb_file.rvb39,
    l_rvb33         LIKE rvb_file.rvb33,
    l_rvb33_tol     LIKE rvb_file.rvb33,    #MOD-5A0431 add
    l_rvb30         LIKE rvb_file.rvb30,
    l_qcs091        LIKE qcs_file.qcs091,
    l_qcs22         LIKE qcs_file.qcs22,
    l_flag          LIKE type_file.num10,   #No.FUN-680136 INTEGER
    l_pmn41         LIKE pmn_file.pmn41,
    l_pmn43         LIKE pmn_file.pmn43,
    l_tmp           LIKE type_file.chr5,    #No.FUN-680136 VARCHAR(05)           #No.FUN-550060
    l_smy57_5       LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(01)
    l_pmm04         LIKE pmm_file.pmm04,
    l_pmm21         LIKE pmm_file.pmm21,    #TQC-7A0034 add
    l_pmm43         LIKE pmm_file.pmm43,    #FUN-5B0144 add
    l_coc04         LIKE coc_file.coc04,    #No.MOD-4B0275
    l_coc10         LIKE coc_file.coc10,    #No.MOD-4B0275
    l_pmn18         LIKE pmn_file.pmn18,
    l_pmn32         LIKE pmn_file.pmn32,
    l_ec_sw         LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
    l_misc          LIKE type_file.chr4,    #No.FUN-680136 VARCHAR(04)
    g_sw            LIKE type_file.num10,   #No.FUN-680136 INTEGER
    l_code          LIKE type_file.num5,    #No.FUN-680136 SMALLINT
    sn1,sn2         LIKE type_file.num5,    #No.FUN-680136 SMALLINT
    l_cmd           LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(100)
    l_okqty         LIKE rvb_file.rvb33,    #MOD-530018 add
    l_allow_insert  LIKE type_file.num5,    #可新增否  #No.FUN-680136 SMALLINT
    l_allow_delete  LIKE type_file.num5,    #可刪除否  #No.FUN-680136 SMALLINT
    l_err_var  STRING,                 #MOD-580138 串接錯誤訊息變數用
    l_qcl05 LIKE qcl_file.qcl05,
    l_sum   LIKE qco_file.qco11
DEFINE l_rva113     LIKE rva_file.rva113     
DEFINE l_bno        LIKE rvbs_file.rvbs08
DEFINE l_rvv17_in   LIKE rvv_file.rvv17
DEFINE l_rvv17_tol LIKE rvv_file.rvv17   #FUN-D20022 add


       CALL t720_qcl05_check() RETURNING l_qcl05 
       IF l_qcl05 = '1' AND NOT cl_null(l_qcl05) THEN
          IF g_rvv[l_ac].rvv17 != 0 THEN
             CALL cl_err('','apm-818',0)
             RETURN FALSE
          END IF
       ELSE   
           IF g_rvv[l_ac].rvv17 < 0 THEN
              CALL cl_err('','afa-043',0)
              RETURN FALSE
           END IF
           #TQC-5B0159--倉退單身可輸入數量為0
           IF (g_rvu.rvu00 != '3') AND (g_rvv[l_ac].rvv17 = 0) AND (l_qcl05 != '1' OR cl_null(l_qcl05)) THEN  #FUN-BC0104 add l_qcl05
              CALL cl_err('','afa-978',1)
              LET g_rvv[l_ac].rvv17 = g_rvv_t.rvv17
              RETURN FALSE
           END IF
 
           IF g_rvv_t.rvv17 IS NULL AND g_rvv[l_ac].rvv17 IS NOT NULL OR
              g_rvv_t.rvv17 IS NOT NULL AND g_rvv[l_ac].rvv17 IS NULL OR
              g_rvv_t.rvv17 <> g_rvv[l_ac].rvv17 THEN
              LET l_rvb07 = 0
              SELECT rvb07,rvb87 INTO l_rvb07,l_rvb87 FROM rvb_file
               WHERE rvb01=g_rvu.rvu02 
                 AND rvb02=g_rvv[l_ac].rvv05
              IF l_rvb07 = g_rvv[l_ac].rvv17 THEN
                 LET g_rvv[l_ac].rvv87 = l_rvb87 
                 DISPLAY BY NAME g_rvv[l_ac].rvv87
              END IF
              IF l_rvb07 <> g_rvv[l_ac].rvv17  AND p_cmd <> 'a' THEN
                 LET g_change='Y'
              END IF  #MOD-820189 add
           END IF
           #MOD-B30033 add --start--
           IF g_change='Y' THEN                 #MOD-820189 add
             CALL t720_set_rvv87()              #No.MOD-770158 add
             DISPLAY BY NAME g_rvv[l_ac].rvv87  #MOD-820189 add
           END IF                               #MOD-820189 add            
           #MOD-B30033 add --end--
            IF g_rvu.rvu00='1' THEN #MOD-4C0053
              SELECT rvb31,rvb07,rvb87 INTO g_inqty,l_rvb07,l_rvb87 FROM rvb_file,rva_file  #MOD-820189 modify 由收貨單帶計價數量
               WHERE rvb01=g_rvu.rvu02 AND rvb02=g_rvv[l_ac].rvv05
                 AND rvb01 = rva01
                 AND rvaconf !='X' #作廢資料要剔除 BugNo:3816
              IF cl_null(g_inqty) THEN LET g_inqty=0 END IF           #TQC-C20117 add  
              IF g_rvv[l_ac].rvv17 > g_inqty THEN  #異動數量不可大於可入庫量
                  CALL cl_err(g_inqty,'mfg3252',1) RETURN FALSE  #MOD-580184
              END IF
           END IF
           ##-入庫數量不可大於允收量
           IF g_rvu.rvu00='1' THEN
              SELECT rvb33,rvb39 INTO l_rvb33,l_rvb39 FROM rvb_file
               WHERE rvb01=g_rvu.rvu02 AND rvb02=g_rvv[l_ac].rvv05
              IF l_rvb39 = 'Y' THEN
                 IF cl_null(l_rvb33) THEN LET l_rvb33 = 0 END IF #BugNo:6641
                 IF (g_rvv[l_ac].rvv17 > l_rvb33) THEN
                    #No.8939 mark
                    #IF g_qcz.qcz05 = 'N' AND g_sma.sma886[8,8]='Y' THEN #no.5071
                    IF g_qcz.qcz05 = 'N' THEN                            #No.8939
                       CALL cl_err(g_rvv[l_ac].rvv31,'apm-282',0)
                       RETURN FALSE
                    END IF
                 END IF
              END IF
              #本張單據,其他屬於此收貨項次的入庫數量
                SELECT SUM(rvv17) INTO l_rvv17_1_other FROM rvv_file,rvu_file
                 WHERE rvv04=g_rvu.rvu02 AND rvv05=g_rvv[l_ac].rvv05
                   AND rvv03='1'
                   AND rvv01 =g_rvu.rvu01          
                   AND rvv01=rvu01
                   AND rvv02 !=g_rvv[l_ac].rvv02   
                   AND rvuconf !='X'
               IF cl_null(l_rvv17_1_other) THEN
                  LET l_rvv17_1_other=0
               END IF
               LET l_rvv17_1_other = l_rvv17_1_other+ g_rvv[l_ac].rvv17
               #總允收數量
               SELECT SUM(rvb33) INTO l_rvb33_tol FROM rvb_file
                  WHERE rvb01=g_rvu.rvu02 AND rvb02=g_rvv[l_ac].rvv05
                    AND rvb39 = 'Y'
               IF g_qcz.qcz05='Y' THEN
                 SELECT SUM(rvv17) INTO l_rvv17_return FROM rvv_file,rvu_file
                  WHERE rvv04=g_rvu.rvu02 AND rvv05=g_rvv[l_ac].rvv05
                    AND rvv03='1'
                    AND rvv01 =g_rvu.rvu01
                    AND rvv01=rvu01
                    AND rvv02 !=g_rvv[l_ac].rvv02
                    AND rvuconf !='X'
                    AND rvv32 = g_qcz.qcz051
                    AND rvv33 = g_qcz.qcz052
                 IF cl_null(l_rvv17_return) THEN
                    LET l_rvv17_return=0
                 END IF
                 #加上當筆屬於不合格品入庫部份
                 IF g_rvv[l_ac].rvv32=g_qcz.qcz051 AND
                    g_rvv[l_ac].rvv33=g_qcz.qcz052  THEN
                    LET l_rvv17_return=l_rvv17_return + g_rvv[l_ac].rvv17
                 END IF
               END IF
               IF cl_null(l_rvv17_return) THEN LET l_rvv17_return = 0 END IF #No.MOD-930070
                IF l_rvv17_1_other > (l_rvb33_tol+l_rvv17_return) THEN #MOD-6A0118-add
                  CALL cl_err(g_rvv[l_ac].rvv31,'apm-306',0)
                  RETURN FALSE
               END IF
           END IF
           #退貨不可大於庫存量
           IF g_rvu.rvu00='3' THEN
              IF NOT cl_null(b_rvv.rvv04) THEN
                 SELECT SUM(rvv17) INTO l_rvv17_3 FROM rvv_file,rvu_file
                  WHERE rvv04=g_rvu.rvu02 AND rvv05=g_rvv[l_ac].rvv05
                    AND rvv03='3' AND rvv01 !=g_rvu.rvu01 AND rvv01=rvu01
                    AND rvuconf !='X'
                 IF cl_null(l_rvv17_3) THEN LET l_rvv17_3=0 END IF
                 #本張單據,其他屬於此收貨項次的數量
                 SELECT SUM(rvv17) INTO l_rvv17_3_other FROM rvv_file,rvu_file
                  WHERE rvv04=g_rvu.rvu02 AND rvv05=g_rvv[l_ac].rvv05
                    AND rvv03='3'
                    AND rvv01 =g_rvu.rvu01
                    AND rvv01=rvu01
                    AND rvv02 !=g_rvv[l_ac].rvv02
                    AND rvuconf !='X'
                 IF cl_null(l_rvv17_3_other) THEN
                    LET l_rvv17_3_other=0
                 END IF
                 SELECT rvb30 INTO g_inqty FROM rvb_file,rva_file
                  WHERE rvb01=g_rvu.rvu02 AND rvb02=g_rvv[l_ac].rvv05
                    AND rvb01=rva01
                    AND rvaconf !='X' #作廢資料要剔除 BugNo:3816
                 IF cl_null(g_inqty) THEN LET g_inqty=0 END IF
                 #異動數量不可大於入庫量-倉退量
                 #IF g_rvv[l_ac].rvv17 > (g_inqty-l_rvv17_3) THEN
                 IF g_rvv[l_ac].rvv17 > (g_inqty-l_rvv17_3-l_rvv17_3_other ) THEN
                    CALL cl_err(g_rvv[l_ac].rvv31,'apm-254',1)
                    RETURN FALSE
                 END IF
              END IF
           END IF
           #驗退不可大於(收貨量-已輸入之驗退量)
           IF g_rvu.rvu00='2' THEN
              IF NOT cl_null(b_rvv.rvv04) THEN
                 SELECT SUM(rvv17) INTO l_rvv17_2 FROM rvv_file,rvu_file
                  WHERE rvv04=g_rvu.rvu02 AND rvv05=g_rvv[l_ac].rvv05
                    AND rvv03='2'
                    AND rvv01 !=g_rvu.rvu01
                    AND rvv01=rvu01
                    AND rvuconf !='X'
                IF cl_null(l_rvv17_2) THEN LET l_rvv17_2=0 END IF
                #本張單據,其他屬於此收貨項次的數量
                SELECT SUM(rvv17) INTO l_rvv17_2_other FROM rvv_file,rvu_file
                 WHERE rvv04=g_rvu.rvu02 AND rvv05=g_rvv[l_ac].rvv05
                   AND rvv03='2'
                   AND rvv01 =g_rvu.rvu01
                   AND rvv01=rvu01
                   AND rvv02 !=g_rvv[l_ac].rvv02
                   AND rvuconf !='X'
                 IF cl_null(l_rvv17_2_other) THEN
                    LET l_rvv17_2_other=0
                 END IF
                #修改可驗退數量控管
                #1.若走IQC   可驗退量=SUM(IQC送驗量) - SUM(IQC合格量) - 已驗退量
                #2.若不走IQC 可驗退量=實收數量 - 已入庫量 - 已驗退量
 
                 SELECT rvb07,rvb33,rvb30,rvb39 INTO g_inqty,l_okqty,
                    l_rvb30,l_rvb39  FROM rvb_file,rva_file
                 WHERE rvb01=g_rvu.rvu02 AND rvb02=g_rvv[l_ac].rvv05
                   AND rvb01=rva01
                   AND rvaconf !='X' #作廢資料要剔除 MODNO:3816
 
#MOD-B90019 -- begin --
                 SELECT SUM(rvv17) INTO l_rvv17_in FROM rvu_file,rvv_file
                    WHERE rvv04 = g_rvu.rvu02
                      AND rvv05 = g_rvv[l_ac].rvv05
                      AND rvv01 = rvu01
                      AND rvu00 = '1'
                      AND rvuconf != 'X'
                 IF cl_null(l_rvv17_in) THEN LET l_rvv17_in = 0 END IF
#MOD-B90019 -- end --

                 IF cl_null(g_inqty) THEN LET g_inqty=0 END IF
                 IF cl_null(l_okqty) THEN LET l_okqty=0 END IF
                 IF cl_null(l_rvb30) THEN LET l_rvb30=0 END IF
 
                 IF g_sma.sma886[8,8] = 'N'  OR l_rvb39='N' THEN   
                   #若勾選允收數與IQC勾稽 , 驗退量以qcs_file為主
                   #若不勾選允收數與IQC勾稽 , 驗退量以rvb_file為主
 
                    #不走IQC
                    #IF g_rvv[l_ac].rvv17 > (g_inqty-l_rvv17_2-l_rvv17_2_other-l_rvb30) THEN      #MOD-B90019 mark
                     IF g_rvv[l_ac].rvv17 > (g_inqty-l_rvv17_2-l_rvv17_2_other-l_rvv17_in) THEN   #MOD-B90019
                         CALL cl_err(g_rvv[l_ac].rvv31,'apm-730',1)
                       RETURN FALSE
                     END IF
                  ELSE
                    #走IQC
                     SELECT SUM(qcs091),SUM(qcs22) INTO l_qcs091,l_qcs22
                        FROM qcs_file WHERE  qcs01 = g_rvu.rvu02
                        AND qcs02 = g_rvv[l_ac].rvv05
                        AND qcs14 = 'Y'               #確認否
                       #AND qcs09 = '1'               #合格否   #No.MOD-7A0072 mark
 
                     IF cl_null(l_qcs091) THEN LET l_qcs091 = 0 END IF
                     IF cl_null(l_qcs22)  THEN LET l_qcs22 = 0 END IF
 
                     IF g_rvv[l_ac].rvv17 > (l_qcs22-l_rvv17_2-l_rvv17_2_other-l_qcs091) THEN
                         CALL cl_err(g_rvv[l_ac].rvv31,'apm-730',1)
                       RETURN FALSE
                     END IF
                 END IF
              END IF
           END IF

          #IF g_rvv[l_ac].rvv87>0 THEN   #MOD-AA0165 rvv17-->rvv87 #MOD-B30033 mark
           IF g_rvv[l_ac].rvv87>0 OR g_rvu.rvu00 ='1' THEN #MOD-B30033
              CALL t720sub_rvv38(g_rvv[l_ac].rvv36,g_rvv[l_ac].rvv38,g_rvv[l_ac].rvv38t,g_rvu.rvu04,g_rvu.rvu01)  #TQC-C30225 add
                    RETURNING g_rvv[l_ac].rvv38,g_rvv[l_ac].rvv38t
              LET g_rvv[l_ac].rvv39=g_rvv[l_ac].rvv87*g_rvv[l_ac].rvv38   #MOD-AA0165 rvv17-->rvv87
              LET g_rvv[l_ac].rvv39t=g_rvv[l_ac].rvv87*g_rvv[l_ac].rvv38t   #No.FUN-610018   #MOD-AA0165 rvv17-->rvv87
              LET t_azi04=''
              IF g_rva00 = '1' AND g_rvu.rvu00 = '3' THEN
                 SELECT azi04 INTO t_azi04 FROM azi_file
                     WHERE azi01 = g_rvu.rvu113
              END IF
              IF g_rva00 = '1' AND g_rvu.rvu00 <> '3' THEN
                 SELECT azi04 INTO t_azi04                       #No.CHI-6A0004
                    FROM pmm_file,azi_file
                   WHERE pmm22=azi01
                     AND pmm01 = g_rvv[l_ac].rvv36 AND pmm18 <> 'X'
              END IF
              IF g_rva00 = '2' THEN
                 SELECT rva113 INTO l_rva113 FROM rva_file 
                     WHERE rva01 = g_rvu.rvu02
                 SELECT azi04 INTO t_azi04 FROM azi_file
                     WHERE azi01 = l_rva113
              END IF
               IF cl_null(t_azi04) THEN                                         
                  SELECT azi04 INTO t_azi04                                     
                    FROM pmc_file,azi_file                                      
                   WHERE pmc22=azi01                                            
                     AND pmc01 = g_rvu.rvu04                                    
               END IF                                                           
              IF cl_null(t_azi04) THEN LET t_azi04=0 END IF  #No.CHI-6A0004
              CALL cl_digcut(g_rvv[l_ac].rvv39,t_azi04)      #No.CHI-6A0004
                                RETURNING g_rvv[l_ac].rvv39
              CALL cl_digcut(g_rvv[l_ac].rvv39t,t_azi04)     #No.CHI-6A0004
                                RETURNING g_rvv[l_ac].rvv39t   #No.FUN-610018
              #CALL t720sub_rvv39(g_rvv[l_ac].rvv36,g_rvv[l_ac].rvv39,g_rvv[l_ac].rvv39t,g_rvu.rvu04,g_rvu.rvu02) #FUN-A10130 #MOD-BC0262 mark 
              CALL t720sub_rvv39(g_rvv[l_ac].rvv36,g_rvv[l_ac].rvv39,g_rvv[l_ac].rvv39t,g_rvu.rvu04,g_rvu.rvu01)  #MOD-BC0262 add
                   RETURNING g_rvv[l_ac].rvv39,g_rvv[l_ac].rvv39t
              DISPLAY BY NAME g_rvv[l_ac].rvv39
              DISPLAY BY NAME g_rvv[l_ac].rvv39t
           #MOD-B30033 add --start--
           ELSE
              IF g_rvu.rvu00 ='3' THEN
                 LET g_rvv[l_ac].rvv39=g_rvv[l_ac].rvv38
                 LET g_rvv[l_ac].rvv39t=g_rvv[l_ac].rvv38t  
                 LET t_azi04=''
                 IF g_rva00 = '1' AND g_rvu.rvu00 = '3' THEN
                    SELECT azi04 INTO t_azi04 FROM azi_file
                        WHERE azi01 = g_rvu.rvu113
                 END IF
                 IF g_rva00 = '1' AND g_rvu.rvu00 <> '3' THEN
                    SELECT azi04 INTO t_azi04   
                       FROM pmm_file,azi_file
                      WHERE pmm22=azi01
                        AND pmm01 = g_rvv[l_ac].rvv36 AND pmm18 <> 'X'
                 END IF
                 IF g_rva00 = '2' THEN
                    SELECT rva113 INTO l_rva113 FROM rva_file 
                        WHERE rva01 = g_rvu.rvu02
                    SELECT azi04 INTO t_azi04 FROM azi_file
                        WHERE azi01 = l_rva113
                 END IF
                  IF cl_null(t_azi04) THEN                                         
                     SELECT azi04 INTO t_azi04                                     
                       FROM pmc_file,azi_file                                      
                      WHERE pmc22=azi01                                            
                        AND pmc01 = g_rvu.rvu04                                    
                  END IF                                                           
                 IF cl_null(t_azi04) THEN LET t_azi04=0 END IF  
                 CALL cl_digcut(g_rvv[l_ac].rvv39,t_azi04)     
                                   RETURNING g_rvv[l_ac].rvv39
                 CALL cl_digcut(g_rvv[l_ac].rvv39t,t_azi04)   
                                   RETURNING g_rvv[l_ac].rvv39t  
                 #CALL t720sub_rvv39(g_rvv[l_ac].rvv36,g_rvv[l_ac].rvv39,g_rvv[l_ac].rvv39t,g_rvu.rvu04,g_rvu.rvu02) #MOD-BC0262 mark 
                 CALL t720sub_rvv39(g_rvv[l_ac].rvv36,g_rvv[l_ac].rvv39,g_rvv[l_ac].rvv39t,g_rvu.rvu04,g_rvu.rvu01)  #MOD-BC0262 add
                      RETURNING g_rvv[l_ac].rvv39,g_rvv[l_ac].rvv39t
                 DISPLAY BY NAME g_rvv[l_ac].rvv39
                 DISPLAY BY NAME g_rvv[l_ac].rvv39t
              END IF
           #MOD-B30033 add --end--              
           END IF
 
              IF g_rvv[l_ac].rvv87 > 0 THEN   #MOD-AA0165 rvv17-->rvv87
                 CALL t720sub_rvv38(g_rvv[l_ac].rvv36,b_rvv.rvv38,b_rvv.rvv38t,g_rvu.rvu04,g_rvu.rvu01)  #TQC-C30225 add
                     RETURNING b_rvv.rvv38,b_rvv.rvv38t
                 LET g_rvv39=g_rvv[l_ac].rvv87*b_rvv.rvv38   #MOD-AA0165 rvv17-->rvv87
                 LET g_rvv39t=g_rvv[l_ac].rvv87*b_rvv.rvv38t   #No.FUN-610018   #MOD-AA0165 rvv17-->rvv87
              END IF
              LET t_azi04=''   #No.CHI-6A0004
              IF g_rva00 = '1' AND g_rvu.rvu00 = '3' THEN
                 SELECT azi04 INTO t_azi04 FROM azi_file
                     WHERE azi01 = g_rvu.rvu113
              END IF
              IF g_rva00 = '1' AND g_rvu.rvu00 <> '3' THEN
                 SELECT azi04 INTO t_azi04                       #No.CHI-6A0004
                    FROM pmm_file,azi_file
                   WHERE pmm22=azi01
                     AND pmm01 = g_rvv[l_ac].rvv36 AND pmm18 <> 'X'
              END IF
              IF g_rva00 = '2' THEN
                 SELECT rva113 INTO l_rva113 FROM rva_file 
                     WHERE rva01 = g_rvu.rvu02
                 SELECT azi04 INTO t_azi04 FROM azi_file
                     WHERE azi01 = l_rva113
              END IF
               IF g_rvv[l_ac].rvv17 = 0 OR cl_null(t_azi04) THEN    #No.MOD-8A0183
                  SELECT azi04 INTO t_azi04
                    FROM pmc_file,azi_file
                   WHERE pmc22=azi01
                     AND pmc01 = g_rvu.rvu04
               END IF
              IF cl_null(t_azi04) THEN LET t_azi04=0 END IF  #No.CHI-6A0004
              CALL cl_digcut(g_rvv39,t_azi04)  #No.CHI-6A0004
                                RETURNING g_rvv39
              CALL cl_digcut(g_rvv39t,t_azi04) #No.CHI-6A0004
                                RETURNING g_rvv39t   #No.FUN-610018
              IF NOT cl_null(g_rvv[l_ac].rvv36) THEN    #No.MOD-8A0098 
              #CALL t720sub_rvv39(g_rvv[l_ac].rvv36,g_rvv[l_ac].rvv39,g_rvv[l_ac].rvv39t,g_rvu.rvu04,g_rvu.rvu02) #FUN-A10130 #MOD-BC0262 mark 
              CALL t720sub_rvv39(g_rvv[l_ac].rvv36,g_rvv[l_ac].rvv39,g_rvv[l_ac].rvv39t,g_rvu.rvu04,g_rvu.rvu01)  #MOD-BC0262 add
                   RETURNING g_rvv[l_ac].rvv39,g_rvv[l_ac].rvv39t
              END IF  #No.MOD-8A0098
              DISPLAY BY NAME g_rvv[l_ac].rvv39
              DISPLAY BY NAME g_rvv[l_ac].rvv39t
           CALL t720_qcl05_check() RETURNING l_qcl05     #FUN-BC0104 add
           IF g_sma.sma116 MATCHES '[02]' AND (l_qcl05 NOT MATCHES'[12]' OR cl_null(l_qcl05)) THEN #MOD-630031 add #不使用計價單位時,計價單位/數量給原單據單位/數量 #FUN-BC0104 add
              LET g_rvv[l_ac].rvv86=g_rvv[l_ac].rvv35
              LET g_rvv[l_ac].rvv87=g_rvv[l_ac].rvv17
              DISPLAY BY NAME g_rvv[l_ac].rvv86
              DISPLAY BY NAME g_rvv[l_ac].rvv87
           END IF
          #MOD-B30033 mark --start--
          #IF g_change='Y' THEN                 #MOD-820189 add
          #  CALL t720_set_rvv87()              #No.MOD-770158 add
          #  DISPLAY BY NAME g_rvv[l_ac].rvv87  #MOD-820189 add
          #END IF                               #MOD-820189 add 
          #MOD-B30033 mark --end--
           LET g_ima918 = ''   #DEV-D30059 add
           LET g_ima921 = ''   #DEV-D30059 add
           LET g_ima930 = ''   #DEV-D30059 add
           SELECT ima918,ima921,ima930 INTO g_ima918,g_ima921,g_ima930 #DEV-D30059 add ima930 
             FROM ima_file
            WHERE ima01 = g_rvv[l_ac].rvv31
              AND imaacti = "Y"
           
           IF cl_null(g_ima930) THEN LET g_ima930 = 'N' END IF  #DEV-D30059 add

           IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
              SELECT img09 INTO g_img09 FROM img_file
              WHERE img01=g_rvv[l_ac].rvv31 AND img02=g_rvv[l_ac].rvv32
                AND img03=g_rvv[l_ac].rvv33 AND img04=g_rvv[l_ac].rvv34
              IF (NOT cl_null(g_rvu.rvu02)) OR (cl_null(g_rvu.rvu02)
                  AND g_prog='apmt722' OR g_prog='aict044' AND p_cmd='u') THEN   #No.MOD-930042 add #MOD-D30083 add aict044
                 IF g_sma.sma90 = 'Y' THEN  #sel
                    SELECT COUNT(*) INTO l_n FROM rvbs_file
                     WHERE rvbs00 = g_prog
                       AND rvbs01 = g_rvu.rvu01
                       AND rvbs02 = g_rvv[l_ac].rvv02
                    IF l_n = 0 THEN
                       CALL t720sub_ins_rvbs(g_prog,g_rvu.rvu01,g_rvv[l_ac].rvv02,
                                          g_rvu.rvu02,g_rvv[l_ac].rvv05,g_rvv[l_ac].rvv31,
                                          g_rvv[l_ac].rvv32,g_rvv[l_ac].rvv33,g_rvv[l_ac].rvv34,g_rvu.rvu02) #FUN-A10130
                    END IF
                    IF g_rvu.rvu116 <> '3' OR cl_null(g_rvu.rvu116) THEN   #MOD-CB0229 add
   #No.TQC-B90236--------mark---------begin-----------
                      #CALL s_lotin(g_prog,g_rvu.rvu01,g_rvv[l_ac].rvv02,0,
                      #             g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv35,g_img09,
                      #             g_rvv[l_ac].rvv35_fac,g_rvv[l_ac].rvv17,'','SEL')#CHI-9A0022 add ''
                      #       RETURNING l_r,g_qty
   #No.TQC-B90236--------mark---------end-------------
                       CALL s_wo_record(g_rvv[l_ac].rvv18,'Y')   #MOD-CC0047 add
   #No.TQC-B90236--------add----------begin-----------
                       IF g_ima930 = 'N' THEN                                        #DEV-D30059
                          IF g_rvu.rvu00='1' THEN
                             CALL s_mod_lot(g_prog,g_rvu.rvu01,g_rvv[l_ac].rvv02,0,
                                            g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv32,g_rvv[l_ac].rvv33,
                                            g_rvv[l_ac].rvv34,g_rvv[l_ac].rvv35,g_img09,
                                            g_rvv[l_ac].rvv35_fac,g_rvv[l_ac].rvv17,'','SEL',1) #CHI-9A0022 add ''
                                     RETURNING l_r,g_qty
                          ELSE
                             CALL s_mod_lot(g_prog,g_rvu.rvu01,g_rvv[l_ac].rvv02,0,
                                            g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv32,g_rvv[l_ac].rvv33,
                                            g_rvv[l_ac].rvv34,g_rvv[l_ac].rvv35,g_img09,
                                            g_rvv[l_ac].rvv35_fac,g_rvv[l_ac].rvv17,'','SEL',-1) #CHI-9A0022 add ''
                                     RETURNING l_r,g_qty
                          END IF
                       END IF                                                        #DEV-D30059
   #No.TQC-B90236--------add----------end-------------
                    END IF   #MOD-CB0229 add
                    IF l_r = "Y" THEN
                       LET g_rvv[l_ac].rvv17 = g_qty
                    END IF
                 ELSE
#No.CHI-9A0022 --Begin
                    LET l_bno = ''
                    SELECT pmn122 INTO l_bno
                      FROM pmn_file
                     WHERE pmn01 = g_rvv[l_ac].rvv36
                       AND pmn02 = g_rvv[l_ac].rvv37
#No.CHI-9A0022 --End
                     IF g_rvu.rvu116 <> '3' OR cl_null(g_rvu.rvu116) THEN   #MOD-CB0229 add
   #No.TQC-B90236--------mark---------begin-----------
                      #CALL s_lotin(g_prog,g_rvu.rvu01,g_rvv[l_ac].rvv02,0,
                      #             g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv35,g_img09,
                      #             g_rvv[l_ac].rvv35_fac,g_rvv[l_ac].rvv17,l_bno,'MOD')#CHI-9A0022 add ''
                      #       RETURNING l_r,g_qty
   #No.TQC-B90236--------mark---------end-------------
                       CALL s_wo_record(g_rvv[l_ac].rvv18,'Y')   #MOD-CC0047 add        
   #No.TQC-B90236--------add----------begin-----------
                       IF g_ima930 = 'N' THEN                                        #DEV-D30059
                          IF g_rvu.rvu00='1' THEN
                             CALL s_mod_lot(g_prog,g_rvu.rvu01,g_rvv[l_ac].rvv02,0,
                                            g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv32,g_rvv[l_ac].rvv33,
                                            g_rvv[l_ac].rvv34,g_rvv[l_ac].rvv35,g_img09,
                                            g_rvv[l_ac].rvv35_fac,g_rvv[l_ac].rvv17,l_bno,'MOD',1) #CHI-9A0022 add l_bno
                                     RETURNING l_r,g_qty
                          ELSE
                             CALL s_mod_lot(g_prog,g_rvu.rvu01,g_rvv[l_ac].rvv02,0,
                                            g_rvv[l_ac].rvv31,g_rvv[l_ac].rvv32,g_rvv[l_ac].rvv33,
                                            g_rvv[l_ac].rvv34,g_rvv[l_ac].rvv35,g_img09,
                                            g_rvv[l_ac].rvv35_fac,g_rvv[l_ac].rvv17,l_bno,'MOD',-1) #CHI-9A0022 add l_bno
                                     RETURNING l_r,g_qty
                          END IF
                       END IF                                                        #DEV-D30059
   #No.TQC-B90236--------add----------end-------------
                    END IF   #MOD-CB0229 add
                    IF l_r = "Y" THEN
                       LET g_rvv[l_ac].rvv17 = g_qty
                    END IF
                 END IF
              END IF    #No.MOD-930042 add
           END IF
           IF g_rvv_t.rvv31 != g_rvv[l_ac].rvv31 THEN #MOD-C50254 add
              CALL t720_get_price()
           END IF #MOD-C50254 add
           IF NOT cl_null(g_rvv[l_ac].rvv17) THEN
              IF g_rvu.rvu00 = '3' AND g_rvu.rvu116 MATCHES '[12]' THEN
                 IF g_rvv[l_ac].rvv17 <= 0 THEN
                    CALL cl_err(g_rvv[l_ac].rvv17,'axm-948',0)
                    RETURN FALSE
                 END IF
              END IF
           END IF
           IF NOT cl_null(g_rvv[l_ac].rvv17) THEN 
              IF cl_null(g_rvv_t.rvv17) OR (p_cmd='u' AND g_rvv_t.rvv17 != g_rvv[l_ac].rvv17) THEN
                 IF l_qcl05 = '0' OR l_qcl05 = '2' THEN
                    CALL t720_rvv17_rvv87_check(p_cmd) RETURNING l_sum
                    IF g_rvv[l_ac].rvv17 > l_sum THEN
                       CALL cl_err('','apm-804',0)
                       LET g_rvv[l_ac].rvv17 = l_sum 
                       DISPLAY BY NAME g_rvv[l_ac].rvv17
                       RETURN FALSE 
                    END IF
                 END IF 
             END IF
             #FUN-D20022 -- add start --
             IF g_rvu00 = '1' THEN
                SELECT SUM(rvv17) INTO l_rvv17_tol FROM rvv_file,rvu_file
                 WHERE rvv04 = g_rvu.rvu02 AND rvv05 = g_rvv[l_ac].rvv05
                  AND rvu00='1' AND rvv01=rvu01 AND rvuconf <> 'X'
                   AND rvu01 <> g_rvu.rvu01
                IF cl_null(l_rvv17_tol) THEN LET l_rvv17_tol = 0 END IF
                IF g_rvv[l_ac].rvv17 > l_rvb33 - l_rvv17_tol THEN #異動數量應扣除已產生的入庫單之數量
                   CALL cl_err(l_rvb33 - l_rvv17_tol,'apm1102',1)
                   RETURN FALSE 
                END IF
             END IF
             #FUN-D20022 -- add end --
           END IF
      END IF
RETURN TRUE 
END FUNCTION

FUNCTION t720_rvv87(p_cmd)
DEFINE l_qcl05 LIKE qcl_file.qcl05,
       l_sum   LIKE qco_file.qco11,
       p_cmd   LIKE type_file.chr1

       CALL t720_qcl05_check() RETURNING l_qcl05
       IF l_qcl05 = '2' AND NOT cl_null(l_qcl05) THEN
          IF g_rvv[l_ac].rvv87 != 0 THEN
             CALL cl_err('','apm-812',0)
             RETURN FALSE
          ELSE
             LET g_rvv[l_ac].rvv39=0
             LET g_rvv[l_ac].rvv39t=0
             DISPLAY BY NAME g_rvv[l_ac].rvv39,g_rvv[l_ac].rvv39t
          END IF
       ELSE
           IF g_rvv[l_ac].rvv87 < 0 THEN
              CALL cl_err('','afa-043',0)
              RETURN FALSE
           END IF
           IF NOT cl_null(g_rvv[l_ac].rvv87) THEN
              IF g_rvv[l_ac].rvv87 < 0 THEN
                 RETURN FALSE
              END IF
              #FUN-5B0144 add IF #當金額為0時計算含稅金額
             #IF g_rvv[l_ac].rvv87 > 0 THEN #MOD-B30033 mark
              IF g_rvv[l_ac].rvv87>0 OR g_rvu.rvu00 ='1' THEN #MOD-B30033
                 CALL t720sub_rvv38(g_rvv[l_ac].rvv36,g_rvv[l_ac].rvv38,g_rvv[l_ac].rvv38t,g_rvu.rvu04,g_rvu.rvu01)  #TQC-C30225 add
                    RETURNING g_rvv[l_ac].rvv38,g_rvv[l_ac].rvv38t
                 LET g_rvv[l_ac].rvv39=g_rvv[l_ac].rvv87*g_rvv[l_ac].rvv38
                 LET g_rvv[l_ac].rvv39t=g_rvv[l_ac].rvv87*g_rvv[l_ac].rvv38t   #No.FUN-610018
                 LET b_rvv.rvv39t=g_rvv[l_ac].rvv87*b_rvv.rvv38t
                #-----MOD-AC0024---------
                 CALL cl_digcut(g_rvv[l_ac].rvv39,t_azi04)  
                                   RETURNING g_rvv[l_ac].rvv39
                 CALL cl_digcut(g_rvv[l_ac].rvv39t,t_azi04)   
                                   RETURNING g_rvv[l_ac].rvv39t  
                #-----END MOD-AC0024-----
                 #CALL t720sub_rvv39(g_rvv[l_ac].rvv36,g_rvv[l_ac].rvv39,g_rvv[l_ac].rvv39t,g_rvu.rvu04,g_rvu.rvu02) #FUN-A10130 #MOD-BC0262 mark 
                 CALL t720sub_rvv39(g_rvv[l_ac].rvv36,g_rvv[l_ac].rvv39,g_rvv[l_ac].rvv39t,g_rvu.rvu04,g_rvu.rvu01) #MOD-BC0262 add
                      RETURNING g_rvv[l_ac].rvv39,g_rvv[l_ac].rvv39t
                 DISPLAY BY NAME g_rvv[l_ac].rvv39
                 DISPLAY BY NAME g_rvv[l_ac].rvv39t
              ELSE
                #MOD-B30033 mark --start--
                #CALL t720_pmm43(g_rvv[l_ac].rvv36) RETURNING l_pmm43
                #LET b_rvv.rvv39t = g_rvv[l_ac].rvv39 * (1+l_pmm43/100)
                #MOD-B30033 mark --end--
                 #MOD-B30033 add --start--
                    IF g_rvu.rvu00 ='3' THEN
                       LET g_rvv[l_ac].rvv39=g_rvv[l_ac].rvv38
                       LET g_rvv[l_ac].rvv39t=g_rvv[l_ac].rvv38t 
                       LET b_rvv.rvv39t=b_rvv.rvv38t
                       CALL cl_digcut(g_rvv[l_ac].rvv39,t_azi04)  
                                         RETURNING g_rvv[l_ac].rvv39
                       CALL cl_digcut(g_rvv[l_ac].rvv39t,t_azi04)   
                                         RETURNING g_rvv[l_ac].rvv39t  
                       #CALL t720sub_rvv39(g_rvv[l_ac].rvv36,g_rvv[l_ac].rvv39,g_rvv[l_ac].rvv39t,g_rvu.rvu04,g_rvu.rvu02) #MOD-BC0262 mark 
                       CALL t720sub_rvv39(g_rvv[l_ac].rvv36,g_rvv[l_ac].rvv39,g_rvv[l_ac].rvv39t,g_rvu.rvu04,g_rvu.rvu01) #MOD-BC0262 add 
                            RETURNING g_rvv[l_ac].rvv39,g_rvv[l_ac].rvv39t
                       DISPLAY BY NAME g_rvv[l_ac].rvv39
                       DISPLAY BY NAME g_rvv[l_ac].rvv39t
                    END IF 
                 #MOD-B30033 add --end--
              END IF
              IF g_rvv_t.rvv31 != g_rvv[l_ac].rvv31 THEN #MOD-C50254 add
                 CALL t720_get_price()  #NO.FUN-940083
              END IF #MOD-C50254
              IF l_qcl05 = '1' THEN
                 IF g_sma.sma116 = '1' OR g_sma.sma116 = '3' THEN
                    IF cl_null(g_rvv_t.rvv87) OR (p_cmd='u' AND g_rvv_t.rvv87 != g_rvv[l_ac].rvv87) THEN
                       CALL t720_rvv17_rvv87_check(p_cmd) RETURNING l_sum
                       IF g_rvv[l_ac].rvv87 > l_sum THEN
                          CALL cl_err('','apm-804',0)                       
                          LET g_rvv[l_ac].rvv87 = l_sum 
                          LET g_rvv[l_ac].rvv87 = s_digqty(g_rvv[l_ac].rvv87,g_rvv[l_ac].rvv86)   #No.FUN-BB0086
                          DISPLAY BY NAME g_rvv[l_ac].rvv87
                          RETURN FALSE
                       END IF
                    END IF
                 END IF
              END IF
           END IF
        END IF   
RETURN TRUE
END FUNCTION

FUNCTION t720_img09()
DEFINE l_img09 LIKE img_file.img09

   IF NOT cl_null(g_rvv[l_ac].rvv32) THEN      
                  SELECT img09 INTO l_img09 FROM img_file
                         WHERE img01 = g_rvv[l_ac].rvv31
                         AND img02 = g_rvv[l_ac].rvv32
                         AND img03 = g_rvv[l_ac].rvv33
                         AND img04 = g_rvv[l_ac].rvv34
   END IF
   RETURN l_img09
END FUNCTION

#FUN-BC0104---add---end

#FUN-BB0086--add--begin--
FUNCTION t720_rvv87_check(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
   IF NOT cl_null(g_rvv[l_ac].rvv87) AND NOT cl_null(g_rvv[l_ac].rvv86) THEN
      IF cl_null(g_rvv_t.rvv87) OR cl_null(g_rvv86_t) OR g_rvv_t.rvv87 != g_rvv[l_ac].rvv87 OR g_rvv86_t != g_rvv[l_ac].rvv86 THEN
         LET g_rvv[l_ac].rvv87=s_digqty(g_rvv[l_ac].rvv87,g_rvv[l_ac].rvv86)
         DISPLAY BY NAME g_rvv[l_ac].rvv87
      END IF
   END IF

   IF NOT t720_rvv87(p_cmd) THEN
      RETURN FALSE 
   END IF
   RETURN TRUE 
END FUNCTION 
#FUN-BB0086--add--end--
#TQC-C30048---add---str---
FUNCTION t720_qcl05_wc()
DEFINE l_qcl05_wc STRING
   IF g_bgjob='N' OR cl_null(g_bgjob) THEN   #開驗退單的條件
      #FUN-CC0013 mark begin---
      #IF (g_argv1='2' AND g_argv3='ICD') OR (g_argv1='2' AND g_argv3 !='SUB' AND g_argv3 !='TAP')
      #    OR (g_argv1='2' AND g_argv3='SUB') OR (g_argv1='2' AND g_argv3='TAP') THEN
      #    LET l_qcl05_wc = '3'    
      #    RETURN l_qcl05_wc,FALSE
      #ELSE
      #FUN-CC0013 mark end-----
       IF NOT((g_argv1='2' AND g_argv3='ICD') OR (g_argv1='2' AND g_argv3 !='SUB' AND g_argv3 !='TAP')
               OR (g_argv1='2' AND g_argv3='SUB') OR (g_argv1='2' AND g_argv3='TAP') ) THEN
          LET l_qcl05_wc = '012' 
          RETURN l_qcl05_wc,TRUE
      END IF
   END IF
   RETURN l_qcl05_wc,TRUE
END FUNCTION
#TQC-C30048---add---str---

#TQC-C30193 --START--
FUNCTION t720_tky_sfb09_2(l_rvv04)
DEFINE l_rvv18     LIKE rvv_file.rvv18
DEFINE l_rvv04     LIKE rvv_file.rvv36
DEFINE l_rvb       RECORD LIKE rvb_file.*
DEFINE l_rvbi      RECORD LIKE rvbi_file.*
DEFINE l_cnt       LIKE type_file.num5
DEFINE l_tky_cnt   LIKE type_file.num5
DEFINE l_ecdicd01  LIKE ecd_file.ecdicd01
DEFINE l_sfa161    LIKE sfa_file.sfa161

    LET l_tky_cnt = 0
    DECLARE t720_tky_sfb09_2 CURSOR FOR
      SELECT * FROM rvb_file,rvbi_file
       WHERE rvb01 = rvbi01 AND rvb02 = rvbi02  
        AND rvb01 = l_rvv04 

    FOREACH t720_tky_sfb09_2 INTO l_rvb.*,l_rvbi.*
       SELECT ecdicd01 INTO l_ecdicd01 FROM ecd_file
        WHERE ecd01 = l_rvbi.rvbiicd03 
       IF l_ecdicd01 = '2' THEN  #CP
          SELECT sfa161 INTO l_sfa161 FROM sfa_file        
           WHERE sfa01 = l_rvb.rvb34  
          IF cl_null(l_sfa161) THEN LET l_sfa161 = 1 END IF           
          LET l_rvbi.rvbiicd06 = l_rvbi.rvbiicd06 / l_sfa161
          LET l_rvbi.rvbiicd07 = l_rvbi.rvbiicd07 / l_sfa161       
       END IF
       LET l_tky_cnt = l_tky_cnt + l_rvbi.rvbiicd06 + l_rvbi.rvbiicd07
    END FOREACH   
    RETURN l_tky_cnt     
END FUNCTION 
#TQC-C30193 --END--

#FUN-C30140--add---str---
FUNCTION t720_pic()
   IF g_rvu.rvuconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF #確認碼
   IF g_rvu.rvu17='1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF #狀況碼
   CALL cl_set_field_pic(g_rvu.rvuconf,g_chr2,""  ,""  ,g_chr,""   )
                         #確認碼      ,核准  ,過帳,結案,作廢 ,有效
END FUNCTION
#FUN-C30140--add---end---

#MOD-C30902 add begin
FUNCTION t720_set_no_entry_rvv32()

   IF l_ac > 0 AND g_rec_b > 0 THEN    
      IF NOT cl_null(g_rvv[l_ac].rvv31) THEN
         IF NOT cl_null(g_rvu.rvu117) OR g_rvv[l_ac].rvv89 ='Y' THEN
            CALL cl_set_comp_entry("rvv32,rvv33",FALSE)
         ELSE
            CALL cl_set_comp_entry("rvv32,rvv33",TRUE)
         END IF
      END IF
   END IF
   
END FUNCTION
#MOD-C30902 add end

#FUN-CB0014---add---str---
FUNCTION t720_list_fill()
  DEFINE l_rvu01         LIKE rvu_file.rvu01
  DEFINE l_rvu00         LIKE rvu_file.rvu00
  DEFINE l_i             LIKE type_file.num10

    CALL g_rvu_l.clear()
    LET l_i = 1
    FOREACH t720_fill_cs INTO l_rvu01,l_rvu00
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach item_cur',SQLCA.sqlcode,1)
          CONTINUE FOREACH
       END IF
       SELECT rvu00,rvu02,rvu03,rvu01,rvu04,rvu05,rvu08,rvu06,gem02,
              rvu07,gen02,rvu20,rvuconf,rvumksg,rvu17,rvu900
         INTO g_rvu_l[l_i].*
         FROM rvu_file
              LEFT OUTER JOIN gen_file ON rvu07 = gen01
              LEFT OUTER JOIN gem_file ON rvu06 = gem01
        WHERE rvu01=l_rvu01 AND rvu00=l_rvu00
       LET l_i = l_i + 1
       IF l_i > g_max_rec THEN
          IF g_action_choice ="query"  THEN  
            CALL cl_err( '', 9035, 0 )
          END IF                             
          EXIT FOREACH
       END IF
    END FOREACH
    LET g_rec_b2 = l_i - 1
    DISPLAY ARRAY g_rvu_l TO s_rvu_l.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
       BEFORE DISPLAY
          EXIT DISPLAY
    END DISPLAY

END FUNCTION

FUNCTION t720_bp3(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
 
   IF p_ud <> "G"  THEN
      RETURN
   END IF
 
   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rvu_l TO s_rvu_l.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
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
             CALL t720_fetch('/')
         END IF
         CALL cl_set_comp_visible("page4,info,userdefined_field", FALSE)
         CALL cl_set_comp_visible("page_list", FALSE) 
         CALL ui.interface.refresh()           
         CALL cl_set_comp_visible("page4,info,userdefined_field", TRUE)      
         CALL cl_set_comp_visible("page_list", TRUE) 
         EXIT DISPLAY

      ON ACTION ACCEPT
         LET g_action_flag = "page_main"
         LET l_ac2 = ARR_CURR()
         LET g_jump = l_ac2
         LET mi_no_ask = TRUE
         CALL t720_fetch('/')
         CALL cl_set_comp_visible("page4,info,userdefined_field", FALSE)
         CALL cl_set_comp_visible("page_list", FALSE) 
         CALL ui.interface.refresh()           
         CALL cl_set_comp_visible("page4,info,userdefined_field", TRUE)      
         CALL cl_set_comp_visible("page_list", TRUE)    
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
         CALL t720_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL t720_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL t720_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t720_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t720_fetch('L')
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
         IF g_aza.aza71 MATCHES '[Yy]' THEN
            CALL aws_gpmcli_toolbar()
            CALL cl_set_act_visible("gpm_show,gpm_query", TRUE)
         ELSE
            CALL cl_set_act_visible("gpm_show,gpm_query", FALSE)  #N0.TQC-710042
         END IF
         #CKP
        #FUN-C30140--mod---str--
        #IF g_rvu.rvuconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
        #CALL cl_set_field_pic(g_rvu.rvuconf,"","","",g_chr,"")
         CALL t720_pic()
        #FUN-C30140--mod---end--
         CALL t720_def_form()     #FUN-610067
         LET g_action_choice="locale"       #No.TQC-790064
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
          
#FUN-A60035 ---MARK BEGIN
#   #No.FUN-A50054 -BEGIN-----
#     ON ACTION style_detail
#        LET g_action_choice="style_detail"
#        EXIT DIALOG
#   #No.FUN-A50054 -END-------
#FUN-A60035 ---MARK END

    #@ON ACTION 轉報工單
      ON ACTION transfer_to_report
         LET g_action_choice="transfer_to_report"
         EXIT DISPLAY
    #@ON ACTION 折讓
      ON ACTION allowance
         LET g_action_choice="allowance"
         EXIT DISPLAY
    #@ON ACTION recall
      ON ACTION recall
         LET g_action_choice="recall"
         EXIT DISPLAY
    #@ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
    #FUN-D20025--add--str--
    #@ON ACTION 取消作廢
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
    #FUN-D20025--add--end--
    #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
    #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
    #@ON ACTION 拋轉
      ON ACTION carry
         LET g_action_choice="carry"
         EXIT DISPLAY
    #@ON ACTION 拋轉還原
      ON ACTION undo_carry
         LET g_action_choice="undo_carry"
         EXIT DISPLAY
    #@ON ACTION 單價變更
      ON ACTION price_change
         LET g_action_choice="price_change"
         EXIT DISPLAY
 
    #FUN-A60009 add str ---
    #@ON ACTION 簽核狀況
      ON ACTION approval_status
         LET g_action_choice="approval_status"
         EXIT DISPLAY

    #@ON ACTION easyflow送簽
      ON ACTION easyflow_approval
         LET g_action_choice = "easyflow_approval"
         EXIT DISPLAY
    #FUN-A60009 add end --
    #FUN-BC0104---add---str
      #QC 結果判定產生入庫單
      ON ACTION qc_determine_storage 
         LET g_action_choice = "qc_determine_storage"
         EXIT DISPLAY
    #FUN-BC0104---add---end

      #str----add by guanyao160517
      #ON ACTION fa_issue
      #   LET g_action_choice = 'fa_issue'
      #   EXIT DISPLAY
      #end----add by guanyao160517


      ON ACTION cancel
         LET INT_FLAG=FALSE     #MOD-570244 mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel       #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

     #FUN-A60009 add str ---
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
     #FUN-A60009 add end ---
 
      ON ACTION controls                           #No.FUN-6B0032
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032

 
      ON ACTION related_document                #No.FUN-6A0162  相關文件
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION carry_delivery                #No.FUN-6C0050 轉出貨單
         LET g_action_choice="carry_delivery"
         EXIT DISPLAY
 
      ON ACTION gpm_show
         LET g_action_choice="gpm_show"
         EXIT DISPLAY
 
      ON ACTION gpm_query
         LET g_action_choice="gpm_query"
         EXIT DISPLAY
      ON ACTION qry_lot
         LET g_action_choice="qry_lot"
         EXIT DISPLAY
      ON ACTION gen_transfer_note
         LET g_action_choice="gen_transfer_note"
         EXIT DISPLAY
 
#@    ON ACTION 領料產生                                                                                                            
      ON ACTION gen_mat_wtdw                                                                                                        
         LET g_action_choice="gen_mat_wtdw"                                                                                         
         EXIT DISPLAY                                                                                                               
#@    ON ACTION 領料維護                                                                                                            
      ON ACTION maint_mat_wtdw                                                                                                      
         LET g_action_choice="maint_mat_wtdw"                                                                                       
         EXIT DISPLAY                                                                                                               

      #No.FUN-A80026  --Begin
#@    ON ACTION 产生应付帐款
      ON ACTION gen_ap
         LET g_action_choice="gen_ap"
         EXIT DISPLAY                                                                                                               
      #No.FUN-A80026  --End  

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
 
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

#FUN-CB0087--add--str--
FUNCTION t720_chkall_azf()
DEFINE l_flag        LIKE type_file.chr1
DEFINE l_where       STRING
DEFINE l_sql         STRING
DEFINE l_n           LIKE type_file.num5
DEFINE l_cnt         LIKE type_file.num5

   IF g_rvv.getlength() = 0 THEN RETURN TRUE END IF
   IF g_aza.aza115='Y' THEN
      FOR l_cnt = 1 TO  g_rvv.getlength()
         CALL s_get_where(g_rvu.rvu01,g_rvu.rvu02,'',g_rvv[l_cnt].rvv31,g_rvv[l_cnt].rvv32,g_rvu.rvu07,g_rvu.rvu06) RETURNING l_flag,l_where
         IF l_flag THEN
            LET l_n = 0
            LET l_sql = " SELECT COUNT(*) FROM ggc_file WHERE ggc08='",g_rvv[l_cnt].rvv26,"' AND ",l_where
            PREPARE ggc08_pre5 FROM l_sql
            EXECUTE ggc08_pre5 INTO l_n
            IF l_n < 1 THEN
               CALL cl_err('','aim-425',1)
               LET g_rvu.rvu07 = g_rvu_t.rvu07
               LET g_rvu.rvu06 = g_rvu_t.rvu06
               RETURN FALSE
            END IF
         END IF
      END FOR
   END IF
   RETURN TRUE
END FUNCTION
FUNCTION t720_rvv26_chk()
DEFINE l_sql     STRING,
       l_n       LIKE type_file.num5,
       l_flag    LIKE type_file.chr1,
       l_where   STRING,
       l_azf09   LIKE azf_file.azf09

   IF g_rvu.rvu00 = '3' THEN
      IF cl_null(g_rvv[l_ac].rvv26) THEN
         RETURN FALSE
      END IF
   END IF
   IF NOT cl_null(g_rvv[l_ac].rvv26) THEN
      LET l_n = 0
      CALL s_get_where(g_rvu.rvu01,g_rvu.rvu02,'',g_rvv[l_ac].rvv31,
                       g_rvv[l_ac].rvv32,g_rvu.rvu07,g_rvu.rvu06) RETURNING l_flag,l_where
      IF g_aza.aza115='Y' AND l_flag THEN
         LET l_sql = " SELECT COUNT(*) FROM ggc_file WHERE ggc08='",g_rvv[l_ac].rvv26,"' AND ",l_where
         PREPARE ggc08_pre FROM l_sql
         EXECUTE ggc08_pre INTO l_n
         IF l_n < 1 THEN
            CALL cl_err(g_rvv[l_ac].rvv26,'aim-425',0)
            RETURN FALSE
         ELSE
            SELECT azf03 INTO g_rvv[l_ac].azf03 FROM azf_file
             WHERE azf01 = g_rvv[l_ac].rvv26 AND azf02='2'
            DISPLAY BY NAME g_rvv[l_ac].azf03
         END IF
      ELSE
         IF NOT cl_null(g_rvv[l_ac].rvv26) THEN
             SELECT azf03 INTO g_rvv[l_ac].azf03 FROM azf_file
              WHERE azf01 = g_rvv[l_ac].rvv26 AND azf02='2'
             IF STATUS THEN
                CALL cl_err3("sel","azf_file",g_rvv[l_ac].rvv26,"",STATUS,"","sel azf",1)  #No.FUN-660129
                RETURN FALSE     
             END IF
             SELECT azf09 INTO l_azf09 FROM azf_file
              WHERE azf01=g_rvv[l_ac].rvv26 AND azf02='2'
             IF l_azf09 !='7' AND g_argv1 = '1' THEN 
                CALL cl_err('','aoo-406',1)
                RETURN FALSE     
             END IF
             IF l_azf09 !='5' AND g_argv1 <> '1' THEN
                CALL cl_err('','aoo-406',1)
                RETURN FALSE     
             END IF
             DISPLAY BY NAME g_rvv[l_ac].azf03
         END IF
      END IF  
   ELSE                                    #TQC-D20050
      LET g_rvv[l_ac].azf03= ' '           #TQC-D20050
      DISPLAY BY NAME g_rvv[l_ac].azf03    #TQC-D20050
   END IF    
   RETURN TRUE
END FUNCTION

#FUN-CB0087--add--end--
#FUN-CB0014---add---end---

#DEV-D30045--add--begin
FUNCTION t720_barcode_out()
   DEFINE l_cmd       STRING

   IF g_rvu.rvu01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   LET g_msg = ' ibb03="',g_rvu.rvu01 CLIPPED,'"'
   LET l_cmd = "abar100",
               " '",g_today CLIPPED,"' ''",
               " '",g_lang CLIPPED,"' 'Y' '' '1'",
               " '' '' '' '' ",
               " '",g_msg CLIPPED,"' ",
               " ' ' 'E' '",s_gen_barcode_ibd07(),"'"
   CALL cl_cmdrun_wait(l_cmd)
END FUNCTION
#DEV-D30045--add--end
#DEV-D40013

#str----add by guanyao160517
--FUNCTION t720_fa_issue()
--DEFINE l_x     LIKE type_file.num5
--DEFINE l_cmd   STRING 
--
   --IF cl_null(g_rvu.rvu01) THEN 
      --CALL cl_err('',-400,0)
      --RETURN
   --END IF 
   --SELECT * INTO g_rvu.* FROM rvu_file WHERE rvu01 = g_rvu.rvu01
   --IF g_argv3 != 'SUB' THEN 
      --RETURN 
   --END IF 
--
   --IF g_rvu.rvuconf <> 'Y' THEN
      --CALL cl_err('','csf-009',0)
      --RETURN 
   --END IF 
--
   --LET l_x = ARR_CURR()
   --LET l_cmd = ''
   --LET l_cmd = "csft001",
               --" '2' '",g_rvu.rvu02 CLIPPED,"'",
               --" '",g_rvv[l_x].rvv05 CLIPPED,"'",
               --" '0'"   #add by guanyao160523 #增加版本号
   --CALL cl_cmdrun_wait(l_cmd)
--END FUNCTION 
#end----add by guanyao160517
