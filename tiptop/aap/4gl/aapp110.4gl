# Prog. Version..: '5.30.06-13.04.19(00010)'     #
#
# Pattern name...: aapp110.4gl
# Descriptions...: 發票帳款產生
# Date & Author..: 92/02/07 By Roger
#                  如空白default採購人員,部門   2.帳款類別可空白,如空白,
#                  借方取採購單上會計科目,貸方取帳款部門應付帳款科目
#                  1.如rvw05=0,以apb10計算單頭金額時,應判斷判退貨要扣除
#                  2.rvw05!=0,原幣計算有誤
# Modify.........: 97/05/08 By Danny 付款日推算須考慮結帳日
#                                    將insert, update apk_file 刪除
# Modify.........: No.B198 01/04/19 by plum
#                          同廠商但不同幣別,稅別,付款條件就不同帳款單號
# Modify.........: No.5954 02/09/17 By Kammy  (rvw_file、apk_file增加以下欄位)
#                          付款幣別/匯率/原幣未稅/原幣稅額
#                          a.apa31f=rvw05f apa32f=rvw06f
#                          b.幣別原取 pmm22 改取 rvw11
# Modify.........: No.7644 03/07/18 BY Kammy
#                          1.先不考慮rvu10(折讓否)，否則發票金額會加上驗退金額
#                          2.剔除 "驗退" rvu00!='2' 的資料
# Modify.........: No.8841 03/12/04 BY Kitty g_pmn122為NULL會導致取不到apa_file
# Modify.........: MOD-470536 04/09/14 BY Kitty p110_chkdate() 多宣告一個l_flag,mark掉
# Modify ........: No.FUN-4B0079 04/11/30 By ching 單價,金額改成 DEC(20,6)
# Modify ........: No.MOD-510105 05/01/17 By kitty 條件選依廠商彙總,會將採購單中不同幣別/付款方式/稅別合併在同一張應付憑單
# Modify ........: No.MOD-520077 05/02/16 By kitty FUNCTION p110_prepaid_off apv04未依本幣取位
# Modify ........: No.MOD-520104 05/02/21 By kitty 1.FUNCTION p110_ins_apa()應該要加狀況碼判斷否則已送簽未確認又拋轉會與送簽的資料不合
#                                                  2.同一張發的進與退在不同張應付憑單
# Modify ........: No.MOD-530053 05/03/08 By kitty g_ino_no,t_inv_no改為用like的
# Modify ........: No.FUN-530053 05/04/07 By Nicola 多一選項:單價為0立帳否(非樣品時但單價會為0)
# Modify ........: No.MOD-530446 05/04/08 By Nicola 自動沖預付加show錯誤訊息
# Modify ........: No.FUN-550030 05/05/12 By wujie 單據編號加大
# Modify.........: No.FUN-560002 05/06/03 By Will 單據編號修改
# Modify.........: No.FUN-560070 05/06/16 By Smapmin 單位數量改抓計價單位計價數量
# Modify ........: No.MOD-560109 05/06/18 By alex set_noentry 設定錯誤修改
# Modify.........: No.FUN-560099 05/06/20 By Smapmin 匯總方式應要可以選擇
# Modify.........: No.MOD-540169 05/08/08 By ice 以大陸的情況，發票錄入時對應入庫單,不再對應收貨單。
# Modify.........: No.FUN-580006 05/08/11 By ice 是否使用進項防偽稅控接口
# Modify.........: No.MOD-580258 05/08/29 By Smapmin '單價為0是否立帳'預設為'N'
#                                                     加where條件判斷 rva04 !='Y'
# Modify.........: No.MOD-590440 05/11/03 By ice 依月底重評價對AP未付金額調整,修正未付金額apa73的計算方法
# Modify.........: No.TQC-5B0115 05/11/12 By Nicola aapp110 insert 到aapt110的單身時，若科目是要做部門控管的，部門要預設為單頭的部門
# Modify.........: No.MOD-5B0060 05/11/23 By Smapmin 拋轉到aapt110時,簽核欄位為NULL
#                                                    aapp110產生整批的過去aapt110時，會有出現upd apb_file的錯誤，但有塞資料過去.
# Modify.........: No.MOD-5B0143 05/12/08 By Smapmin apb25按 apa51='STOCK'的邏輯重新抓取科目資料
# Modify.........: NO.MOD-5C0071 05/12/13 By Rosayu apa31f/apa32f要加判斷為null時給0
# Modify.........: No.TQC-5C0038 05/12/19 By Smapmin 產生的發票請款,單身會有資料重複的情況
# Modify.........: No.MOD-5C0107 05/12/21 By Smapmin apamksg為null,造成無法確認
# Modify.........: NO.MOD-5B0178 05/12/21 BY yiting 作業程式會造成不同時間拋轉時會造成與先前單子apa_file,apb_file併單
# Modify.........: No.TQC-5C0112 05/12/27 By Smapmin 修正TQC-5C0038
# Modify.........: No.FUN-5B0089 05/12/30 By Rosayu 產生apa資料後要加判斷單別設定產生分錄底稿
# Modify.........: No.FUN-570112 06/02/23 By yiting 批次背景執行
# Modify.........: No.TQC-610108 06/03/02 By Smapmin 應將入庫與退貨一併產生到aapt110的單身
# Modify.........: No.MOD-630030 06/03/06 By Smapmin 依廠商彙總,where 處建議應加上AND apa14=g_apa.apa14 AND apa15 = g_apa.apa15,
#                                                    才能達到依匯率&稅別不同而拆單的功能.
# Modify.........: NO.FUN-630043 06/03/14 By Melody 多工廠帳務中心功能修改
# Modify.........: NO.TQC-630243 06/03/24 BY yiting 同入庫單有多項次同時入庫,發票同一張,但轉入aapt110單身只轉入第一項次
# Modify.........: No.TQC-630174 06/03/30 By Smapmin 增加INSERT,UPDATE執行不成功的錯誤訊息
# Modify.........: No.MOD-630123 06/03/31 By Smapmin 修正TQC-610108
# Modify.........: No.FUN-640022 06/04/08 By kim GP3.0 匯率參數功能改善
# Modify.........: No.MOD-640547 06/04/25 By ice 有匯差時的預付款衝帳功能修改
# Modify.........: No.MOD-650008 06/05/03 By Smapmin 申報格式的值由稅別決定
# Modify.........: No.FUN-660117 06/06/16 By Rainy Char改為 Like
# Modify.........: No.FUN-660122 06/06/27 By Hellen cl_err --> cl_err3
# Modify.........: No.MOD-660122 06/06/29 By Smampin 要剔除pmm02=TAP,TRI
# Modify.........: No.FUN-670064 06/07/19 By kim GP3.5 利潤中心
# Modify.........: No.FUN-680027 06/08/10 By Rayven 多帳期修改
# Modify.........: No.FUN-680029 06/08/17 By Rayven 新增多帳套功能
# Modify.........: No.FUN-650164 06/08/30 By rainy 取消 'RTN' 判斷
# Modify.........: No.FUN-670007 06/09/09 by yiting 拋轉程式需要拋轉流程代碼
# Modify.........: No.FUN-690028 06/09/15 By flowld 欄位類型修改為LIKE
# Modify.........: No.CHI-6A0004 06/10/27 By Jackho 本（原）幣取位修改
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-680110 06/11/02 By Sarah 將aapp116功能合併至aapp110
# Modify.........: No.TQC-6B0156 06/11/24 By Sarah 當產生沖暫估的應付帳款,分錄產生後的金額有誤
# Modify.........: No.TQC-6C0032 06/12/07 By Smapmin 帳款編號不為空白才CALL p110_upd_apa57()
# Modify.........: No.TQC-6B0151 06/12/08 By Smapmin 數量應抓取計價數量
# Modify.........: No.MOD-6C0029 06/12/12 By Smapmin INSERT INTO apa_file 之預設值的抓取,皆抓取第一筆
# Modify.........: No.TQC-6B0066 06/12/13 By Rayven 對原幣和本幣合計按幣種進行截位
# Modify.........: No.FUN-710014 07/01/10 By Carrier 錯誤訊息匯整
# Modify.........: No.TQC-710087 07/01/25 By Smapmin 貨款須全額呈現,不得直接扣抵
# Modify.........: No.FUN-730064 07/03/28 By bnlent 會計科目加帳套
# Modify.........: No.MOD-730140 07/04/02 By Smapmin 單身項次重排功能先mark掉
# Modify.........: No.TQC-730030 07/04/05 By Rayven 增加參數接收發票號碼
# Modify ........: No.TQC-740042 07/04/09 By johnray s_get_bookno和s_get_bookno1參數應先取出年份
# Modify.........: No.MOD-740035 07/04/11 By Smampin 修改SELECT條件
# Modify.........: No.TQC-740072 07/04/13 By Xufeng  把"資料來源營運中心"插入到應付帳款資料中
# Modify.........: No.CHI-740008 07/04/18 By Smapmin 只有退貨已立折讓不應產生至aapt110
#                                                    修改ORDER BY 的順序同aapp116
# Modify.........: No.TQC-740142 07/04/21 By Rayven aapp110bug匯總修改
# Modify.........: No.TQC-740288 07/04/24 By Rayven 選擇”自動將預付款依P/O#衝銷”無法實現
#                                                   apa31f,apa31是否回加判斷有誤
# Modify.........: No.MOD-740489 07/05/07 By Sarah 1.當入庫單已產生暫估資料,而此暫估資料尚未確認,則不可產生應付資料
#                                                  2.沖暫估與本月入庫同時產生時分錄錯誤
# Modify.........: No.MOD-750101 07/05/23 By Smapmin 帳款編號不為空白才CALL p110_prepaid_off()
# Modify.........: No.MOD-750094 07/05/24 By Smapmin 修改SQL語法以提升效率
# Modify.........: No.TQC-760006 07/06/01 By Rayven 衝暫估應該按發票數量來控制衝暫估的數量，如果金額部分再有差異，作為暫估的DIFF處理
# Modify.........: No.MOD-760117 07/06/26 By Smapmin 帳款類別不可為空
# Modify.........: No.TQC-770051 07/07/11 By Rayven 參數“依部門區分缺省會計科目”未勾選,錄入"帳款類型"時仍然報錯
# Modify.........: No.MOD-780215 07/08/21 By Smapmin 修改幣別位數取位
# Modify.........: No.MOD-780145 07/08/21 By Sarah 修正TQC-760006修改後，導致使用功能別非大陸時，數量及分錄的產生都會錯
# Modify.........: No.TQC-790090 07/09/14 By Melody 修正Primary Key後, 程式判斷錯誤訊息時必須改變做法
# Modify.........: No.TQC-790162 07/09/28 By chenl  倉退單身資料要為數量為負數，單價為正數
# Modify.........: No.MOD-790033 07/10/08 By Smapmin 自動產生沖暫估的DIFF應匯整成一筆
# Modify.........: No.MOD-7A0069 07/10/15 By Sarah 若為倉退單則金額也需顯示為負數
# Modify.........: No.TQC-790138 07/10/15 By Sarah 當兩張入庫單或一張入庫單兩張發票要產生沖暫估帳款資料時，"沖暫估"ACTION(api_file)的資料只會產生一筆(應該要有兩筆)
# Modify.........: No.FUN-7B0024 07/10/25 By Sarah 大陸版沖暫估金額有誤修正
# Modify.........: No.MOD-7A0196 07/10/30 By Sarah aapp110進貨發票貨款整批產生作業,會有錯誤訊息產生(apc_file寫入重覆)
# Modify.........: No.TQC-7B0013 07/11/01 By chenl 倉退單時，單身金額應為負數。
# Modify.........: No.MOD-7B0150 07/11/15 By chenl 1.若發票類型為入庫或兩者時，才可進行處理。即倉退時，不應做處理。
# Modify.........:                                 2.針對大陸版本，修改資料抓取sql，只抓rvv,rvu,rvw，其他資料放于foreach中抓取。
# Modify.........:                                 3.新建函數p110_ins_apc，將原新增apc_file段放入函數內。
# Modify.........: No.TQC-7B0125 07/11/22 By chenl 修正aapp110回寫rvv23錯誤。
# Modify.........: No.TQC-7B0083 07/11/23 By Carrier 1.加入衝暫估功能
#                                                    2.加入rvv8暫估數量判斷
# Modify.........: No.MOD-7C0052 07/12/07 By claire (1)中斷點入庫單,不會有發票資料(rvb22),故帶入rva99(此問題改saxmp900)
#                                                   (2)中斷點入庫單應可以使用本支程式拋應付
# Modify.........: No.TQC-7C0172 07/12/28 By chenl  更新apc插入時機。
# Modify.........: No.MOD-810241 08/01/29 By Smapmin l_diff_api05f/l_diff_api05為null時,未給0
# Modify.........: No.TQC-810090 08/01/30 By chenl  1.修正按發票產生單據時，同一發票單還會拆單的情況。
# Modify.........:                                  2.銷退時，若為對應采購單，則付款方式取廠商資料檔內的付款方式。
# Modify.........: No.TQC-810091 08/01/31 By chenl  1.對api05,api05f進行截位處理。
# Modify.........:                                  2.大陸版本下，根據發票資料來取相應的金額位數及稅率資料。
# Modify.........: No.MOD-820176 08/02/27 By wujie  未取到付款條件，則根據付款廠商抓取付款條件。
# Modify.........: No.MOD-830072 08/03/10 By Smapmin列印次數default為0
# Modify.........: No.FUN-810045 08/03/24 By rainy 項目管理，專案相關欄位代入pab_file
# Modify.........: No.FUN-840006 08/04/02 By hellen項目管理，去掉預算編號相關欄位
# Modify.........: No.MOD-850005 08/05/05 By Smapmin 幣別位數取錯
# Modify.........: No.MOD-850126 08/05/13 By Sarah CALL p110_ins_apk(),p110_upd_apa31()之前,增加IF g_apa.apa01 IS NOT NULL THEN的判斷
# Modify.........: No.MOD-840632 08/05/20 By Smapmin 修改本幣金額計算方式
# Modify.........: No.MOD-860028 08/06/09 By Sarah AFTER FIELD apa02增加檢核apz57,提示aap-176訊息
# Modify.........: No.MOD-860037 08/06/09 By Sarah 在相關apa00='16'段,增加apa42='N'條件
# Modify.........: No.TQC-860021 08/06/10 By Sarah INPUT段漏了ON IDLE控制
# Modify.........: No.MOD-860247 08/06/23 By claire 銷售逆拋中斷點的採購單pmm906='N'且需可以拋AP帳款
# Modify.........: No.MOD-860221 08/06/27 By Sarah apb10應統一為apb24*apa14
# Modify.........: No.MOD-830014 08/03/14 By jan  大陸版本下，日期判斷修改為，入庫日期小于等于帳款日期即可。
# Modify.........: No.TQC-870024 08/07/16 By lutingting 將單號為TQC-810037追單到31區：修正FUN-680029
# Modify.........: No.MOD-890100 08/09/17 By Sarah p110_prepaid_off()段產生沖帳資料需對應到採購項次
# Modify.........: No.MOD-870055 08/07/04 By chenl  在ins_api()中，增加對暫估單的條件，增加apa41='Y'
# Modify.........: No.MOD-8B0064 08/11/06 By Sarah 在抓g_apb.apb27前,先清空變數,以免殘留前值
# Modify.........: No.TQC-8A0079 08/11/11 By Sarah 單價含稅時,含稅金額=含稅單價*計價數量
#                                                             未稅金額=含稅金額/(1+稅額)/100
#                                                  單價未稅時,未稅金額=未稅單價*計價數量
#                                                             含稅金額=未稅金額*(1+稅額)/100
# Modify.........: No.MOD-8C0146 08/12/16 By Sarah 將SQL中rvv87=0條件拿掉
# Modify.........: No.MOD-8C0179 08/12/18 By Sarah 大陸版p110_chkdate()段SQL,應參考大陸版p110_process()中SQL改法,只抓rvv,rvu,rvw
# Modify.........: No.MOD-8C0264 08/12/26 By chenl 將MOD-750094修改內容還原。
# Modify.........: No.CHI-910031 09/01/16 By Sarah 若採購單身有多筆,且專案編號不同,直接彙總成一筆AP,將專案編號寫入單身,單頭專案編號給''
# Modify.........: No.MOD-920002 09/02/03 By sherry 在拋轉賬款時，insert api_file的金額和單身暫估的金額不一致
# Modify.........: No.MOD-920117 09/02/09 By Sarah 數量為0的倉退單應可產生至aapt110
# Modify.........: No.TQC-920018 09/02/09 By Sarah 當aza63!=Y時,CALL t110_stock_act()應回傳到apb25,當aza63=Y時,應回傳到apb251
# Modify.........: No.MOD-920204 09/02/17 By chenl 1.修正多發票按廠商匯總時，不能將api資料插入完整的問題。
#                                                  2.修正外幣衝暫估時，不做重評價本幣有差異的問題。
#                                                  3.調整自動p/o衝銷時，匯差有差異的問題。
# Modify.........: No.MOD-930166 09/03/16 By chenl 若有暫估單未審核,則拋轉結束. 
# Modify.........: No.MOD-930201 09/03/20 By chenyu 自動編號失敗，沒有報錯，導致insert into的時候有沒有編號的資料
# Modify.........: No.MOD-940152 09/04/10 By Sarah 不可在TRANSACTION中寫到BDL語法(如DROP TABLE)
# Modify.........: No.MOD-940260 09/04/20 By lilingyu 凡是抓gec_file 的都要加上gec011 = '1'條件
# Modify.........: No.MOD-940335 09/04/24 By chenl 根據版本，切分對單價為零的資料的判斷。 
# Modify.........: No.MOD-940356 09/04/27 By lilingyu 沒有對apa14取位
# Modify.........: No.MOD-940324 09/04/29 By Sarah g_sql的OUTER寫法,在Ifx環境會造成錯誤
# Modify.........: No.MOD-950024 09/05/05 By Sarah FUNCTION p110_process()段一開始需先清除Temptable資料
# Modify.........: No.FUN-940083 09/05/13 By shiwuying 採購改善-VMI
# Modify.........: No.FUN-930165 09/06/01 By jan MISC料件改抓請購單單頭的部門(pmk13) 
# Modify.........: No.MOD-960081 09/06/06 By Sarah p110_prepaid_off()段抓PO的SQL應區分為apa06='MISC'時不串apa07條件,apa06!='MISC'時串apa07條件
# Modify.........: No.FUN-960141 09/06/29 By dongbg GP5.2修改:增加門店編號欄位
# Modify.........: No.MOD-960142 09/07/15 By baofei 若為樣品者預設g_rvw.rvw17 = 0  
# Modify.........: No.FUN-980001 09/08/12 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.MOD-980025 09/08/05 By Sarah 大陸版應增加卡關,判斷若入庫單當月沒先立暫估帳款,不可跨月產生帳款
# Modify.........: No.MOD-950177 09/08/12 BY lilingyu 調整只要為MISC開頭的料件,單身部門就捉取請購部門
# Modify.........: No.MOD-980223 09/08/26 By mike 衝暫估時, 未考慮到多發票狀況下的api_file   
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990069 09/09/27 By baofei 修改GP5.2的相關設定
# Modify.........: No.FUN-970108 09/08/25 By hongmei 抓apz63欄位寫入apa77
# Modify.........: No.FUN-990014 09/09/08 By hongmei 先抓apyvcode申報統編，若無則將apz63的值寫入apa77/apk32
# Modify.........: No.CHI-9A0021 09/10/15 By Lilan 將程式段多餘的DISPLAY給MARK
# Modify.........: No.CHI-9A0021 09/10/15 By Lilan 將YEAR/MONTH的語法改成用BETWEEN語法 
# Modify.........: No.MOD-990198 09/10/18 By mike g_apa.apa21與g_apa.apa22的值,應該是aapp110畫面上輸入的帳款人員(g_apa21)與帳款部門(
# Modify.........: No.FUN-990031 09/10/22 By lutingtingGP5.2財務營運中心欄位調整,營運中心要控制在同一法人下,条件选项来源营运中心隐藏
# Modify.........: No.TQC-9A0156 09/10/28 By Carrier SQL STANDARDIZE
# Modify.........: No:MOD-9A0174 09/11/02 By mike 因位在Transaction内,所以不可用drop table;但在insert前仍应将x内的资料清空,否则会导>
# Modify.........: No.FUN-9A0093 09/11/02 By lutingting拋轉apb時給欄位apb37賦值
# Modify.........: No.FUN-9C0001 09/12/01 By lutingting QBE門店編號改為來源營運中心,實現可由當前法人下DB得入庫單生成發票請款
# Modify.........: No.FUN-9C0041 09/12/10 By lutingting t110_stock_act 加傳參數營運中心
# Modify.........: No:TQC-9C0102 09/12/14 By Sarah 修正MOD-9C0061,計算api05f與api05時,當數量不為0時以單價*數量計算
# Modify.........: No.MOD-9C0144 09/12/24 By liuxqa 冲暂估时，暂估金额不对。
# Modify.........: No:MOD-9C0061 09/12/30 By sabrina 數量為0 時，api05/api05f直接帶暫估金額 
# Modify.........: No.FUN-9C0077 10/01/04 By baofei 程式精簡
# Modify.........: No:MOD-A10022 10/01/06 By Sarah 當勾選"自動將預付款依P/O#沖銷"時,若此次立帳金額小於預付金額,沖帳金額應寫入此次立帳金額
# Modify.........: No.FUN-A20006 10/02/02 By lutingting 修改p110_upd_apa57()寫法
# Modify.........: No:MOD-A20035 10/02/05 By sabrina 將p110_upd_apa57()產生分錄底稿段移出另成一個FUNCTION 
# Modify.........: No:MOD-A30022 10/03/04 By sabrina N p110_chkdate()的rvw_file要改用OUTER的方式join
# Modify.........: No:MOD-A20113 10/03/09 By sabrina apb21+apb22若已存在倉退單時則CONTIUNE FOREACH
# Modify.........: No:MOD-A30046 10/03/09 By sabrina 同時存在暫估入庫及暫估倉退單，用aapp110拋轉至aapt110時，16的入庫單不能產生
# Modify.........: No:MOD-A30064 10/03/11 By sabrina apa172之值應依aza26來抓取gec05 
# Modify.........: No:CHI-A10006 10/04/19 By Summer 寫入api_file段,若原幣金額加總為剩餘未沖原幣金額,
#                                                   則本幣金額也應全數沖完,將尾差調在金額最大的一筆上
# Modify.........: No:CHI-A30035 10/04/28 By sabrina 使用「自動將預付款依P/O#沖銷」，若預付時匯率與本次沖帳匯率不同，產生之帳款金額有誤
# Modify.........: No:FUN-A40003 10/05/21 By wujie   增加apa79，预设为N
# Modify.........: No:FUN-A60024 10/06/12 By wujie   调整apa79的值为0 
# Modify.........: No.FUN-A60056 10/06/24 By lutingting GP5.2財務串前段問題整批調整
# Modify.........: No:MOD-A70020 10/07/02 By Dido 反推未稅金額不需區分大陸版 
# Modify.........: No:MOD-A70079 10/07/09 By Dido 組 zaw_file 時語法未轉換 
# Modify.........: No:CHI-A70005 10/07/12 By Summer 增加aza63判斷使用s_azmm
# Modify.........: No:MOD-A70131 10/07/16 By sabrina 修改CHI-A30035的錯誤 
# Modify.........: No:MOD-A70137 10/07/16 By wujie   MOD-9C0144 有代码写错 
# Modify.........: No.FUN-A50102 10/07/21 By vealxu 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.MOD-A50130 10/07/27 By sabrina SELECT rvv_file 應該要排除rvb89='Y'/rvv89='Y' VMI收貨入庫資料  
# Modify.........: No.FUN-A70139 10/07/29 By lutingting 過單
# Modify.........: No.FUN-A80026 10/08/26 By Carrier 入库单直接产生AP-加入传参g_wc2
# Modify.........: No:MOD-A80052 10/08/09 By Dido 若為運輸發票(gec05='T')時,稅額與未稅金額邏輯調整 
# Modify.........: No:MOD-A80093 10/08/11 By Dido 大陸版由於apb24/apb10金額已依入庫項次維護在gapi140中,因此不可再重算 
# Modify.........: No:MOD-A80230 10/08/27 By Dido 檢核年月語法應排除樣品 
# Modify.........: No:MOD-A90121 10/09/17 By Dido 產生分錄由於有使用 TEMP FILE 會影響 transation 因此將其移至後面產生 
# Modify.........: No:MOD-A90161 10/09/24 By Dido 轉換 rvb22 部分移至 chdate 之前 
# Modify.........: No:MOD-A10175 10/09/29 By sabrina N p110_ins_apa()多增加判斷條件
# Modify.........: No:MOD-AA0003 10/10/01 By Dido 檢核彙總錯誤段移至 p110_process 尾端處理 
# Modify.........: No:MOD-AA0021 10/10/06 By Dido 單價改用原 rvv38/rvv38t 計算
# Modify.........: No:CHI-A90002 10/10/06 By Summer 應過濾pmcacti='Y'才能立帳
# Modify.........: No:MOD-AB0028 10/11/02 By Dido 抓取資料增加 DISTINCT 
# Modify.........: No:CHI-AB0011 10/11/19 By Summer QBE增加採購人員(pmm12) 
# Modify.........: No:TQC-AB0200 10/12/06 By chenying 產生 aapt160/aapt260 沖暫估時,差異金額 = 0 但 apa56 卻為 '1' 
# Modify.........: No:MOD-AC0230 10/12/21 By Dido 檢核本此預付金額時應增加預付發票金額 
# Modify.........: No:MOD-AC0423 10/12/31 By wujie 判断rvw10与apb09的值时没有考虑仓退rvw10为负数
# Modify.........: No:MOD-B10080 11/01/12 By Dido 於 AFTER FIELD 後有重新給予 apa51/apa511/apa54/apa541 的值,應以此值為主 
# Modify.........: No:MOD-B20088 11/02/18 By Dido apa37/apa37f 預設為 0 
# Modify.........: No:MOD-B30013 11/03/01 By Dido 變數歸零 
# Modify.........: No:MOD-B30183 11/03/18 By Sarah 
# Modify.........: No:MOD-B30649 11/03/22 By Dido l_sql變數改為STRING 
# Modify.........: No:MOD-B30671 11/03/25 By Dido 大陸版需增加 pmm20 做為排序之一 
# Modify.........: No:MOD-B30661 11/03/29 By Dido 大陸版未使用 rvb22 需轉換為 rvw01   
# Modify.........: No:FUN-B30211 11/03/30 By yangtingting 未加離開前的 cl_used(2)
# Modify.........: No:TQC-B40072 11/04/11 By yinhy 系統報錯“-1213 p111(ckp#1):字元轉換至數字程序失敗
# Modify.........: No:MOD-B40045 11/04/13 By Dido 如有重評價沖帳與沖暫估DIFF金額計算調整 
# Modify.........: No:MOD-B40052 11/04/13 By Dido 預付若為收據或不申報者,則不計算至未稅金額中 
# Modify.........: No:MOD-B40087 11/04/18 By Dido 沖暫估DIFF預設科目為匯兌損益科目 
# Modify.........: No:MOD-B40197 11/04/21 By wujie 币种小数位数取错
# Modify.........: No:CHI-B40052 11/04/26 By Dido 分批拋轉入庫時,寫入暫估數量判斷調整 
# Modify.........: No:FUN-B50019 11/05/05 By elva 支持无采购无收货单的入库单产生应付
# Modify.........: No:FUN-B50016 11/05/10 By guoch 廠商編號、入庫單號、發票編號進行開窗查詢
# Modify.........: No:MOD-B50037 11/05/10 By Dido 檢核發票相同不可重複拋轉 
# Modify.........: No:MOD-B50074 11/05/10 By Dido 排除 rvv89/rvb89 = 'Y' 資料 
# Modify.........: No:MOD-B50160 11/05/18 By Dido 排除本身帳款資料 
# Modify.........: No:TQC-B50144 11/05/25 By yinhy 出現SELECT寫成SELICT的狀況,導致“rvv38t含稅單價”抓取失敗
# Modify.........: No:CHI-820005 11/05/26 By zhangweib 檢查發票號碼是否有重複時,應多判斷已存在的發票資料其發票日期年度是否為今年,若是的話才卡住.
# Modify.........: NO.TQC-B60093 11/06/17 By Polly 延續FUN-A40041處理，調整g_sys為實際系統代號
# Modify.........: No:MOD-B60203 11/06/24 By Dido 沖暫估時 apb24 直接抓立暫估的 apb24 
# Modify.........: No:MOD-B60225 11/06/25 By Sarah 檢核不同年月SQL應加上rvu00 != '2'條件
# Modify.........: No:MOD-B60220 11/06/25 By Sarah 沖預付時,預付發票金額=入庫金額-入庫發票金額
# Modify.........: No:TQC-B60326 11/06/27 By wujie 大陆版p/o冲销时，预付金额不累加到税前金额
# Modify.........: No:MOD-B60198 11/06/23 By Polly 修改p110_prepaid_off()，回寫apa35f與apa35程式段，需多計算oob10+aqb04
# Modify.........: No:MOD-B70100 11/07/12 By Dido 單價為0不立帳時,不做跨月檢核 
# Modify.........: No:MOD-B70287 11/07/29 By yinhy 科目不做部門管理時，apb26置為null
# Modify.........: No.FUN-B80058 11/08/05 By lixia 兩套帳內容修改，新增azf141
# Modify.........: No:MOD-B80120 11/08/11 By Polly 控卡外購的收貨單
# Modify.........: No:TQC-B80136 11/08/17 By wujie 增加apz69=Y时对apa14的处理
# Modify.........: No:MOD-B80270 11/08/25 By yinhy 為暫估差异diff科目更改默認取值為aps44
# Modify.........: No:MOD-B80335 11/08/30 By yinhy JIT收貨入庫后，用aapp110拋轉賬款稅額科目未能帶出
# Modify.........: No.TQC-B80261 11/08/31 By guoch apz13为Y,apa22不为空，apa36不需要设置必要栏位
# Modify.........: No.TQC-B90006 11/09/05 By guoch mark TQC-B80261
# Modify.........: No.MOD-B90002 11/09/02 By Polly 修正apc08與apc09值沒有包含沖帳金額，apc14與apc15沒有寫入沖帳金額
# Modify.........: No.MOD-B90143 11/09/21 By Polly 修正拋轉時,發票扣抵區分(pmm44)值不是帶原採購單設定
# Modify.........: No.MOD-B90190 11/09/26 By Polly 增加檢核，帳款日不可小於入庫日
# Modify.........: No.TQC-B90072 11/09/08 By guoch  营运中心赋默认值
# Modify.........: No.MOD-B90164 11/09/23 By Polly 增加 g_apb24t 原幣取位
# Modify.........: No.MOD-B90242 11/09/28 By Polly 撈稅額科目取消大地區別限制
# Modify.........: No.MOD-BA0018 11/10/06 By Dido for 預算控管 apb26 需為一個空白 
# Modify.........: No.MOD-BA0074 11/10/12 By Dido 檢核數量應區分地區別;單身尾差處理 
# Modify.........: No.MOD-BA0043 11/10/13 By Dido 檢核 sqlcode 應為 FETCH FIRST p110_c 的,中間不可有其他的 SQL 語法 
# Modify.........: No.TQC-BA0047 11/10/10 By yinhy 發票金額為0時產生apa31錯誤
# Modify.........: No.FUN-BB0001 11/11/29 By pauline 新增rvv22,INSERT/UPDATE rvb22時,同時INSERT/UPDATE rvv22
# Modify.........: No.TQC-BB0131 11/11/29 By pauline insert apa_file 時apa76給與ruv21
# Modify.........: No:MOD-BC0197 11/12/28 By Summer 外部呼叫aapp110來產生帳款的借貸方科目會沒有值 
# Modify.........: No.MOD-BC0281 11/12/29 By Polly QBE有輸入發票號碼時，將rvb22轉換成 rvv22，並拿掉ORDER BY rvw01
# Modify.........: No.TQC-C20081 12/02/08 By pauline 修正代銷立帳發票錯誤 
# Modify.........: No.MOD-BB0053 12/02/09 By jt_chen 修正FUNCTION p110_prepaid_off()裡apk08,apk08f應該為金額加總
# Modify.........: No.TQC-C10017 12/02/10 By yinhy 調整apb25，apb26，apb27，apb36，apb31，apb930欄位的值
# Modify.........: No.TQC-C10048 12/02/17 By yinhy 大陸版批處理選擇依發票，系統報錯“-1213 p111(ckp#1):字元轉換至數字程序失敗
# Modify.........: No.MOD-C20104 12/02/10 By Dido 沖暫估時,重評價金額比較差異,金額調整在最大筆中
# Modify.........: No.MOD-C30592 12/03/12 By yinhy 沖預付時金額計算錯誤
# Modify.........: No.MOD-C30007 12/03/14 By Polly 增加畫面條件，條件相同才能合併
# Modify.........: No.MOD-C30800 12/03/20 By Polly 若多次預付時，應紀錄第一次沖抵金額，作為下張預付單的沖帳依據
# Modify.........: No.MOD-C40003 12/04/02 By Polly 增加條件g_apa.apaprno > 0進入新增單頭段
# Modify.........: No.MOD-C30780 12/04/03 By Polly 產生單身資料應為一筆,為入庫單+項次方式彙總成一筆
# Modify.........: No.TQC-B90062 12/04/25 By Elise 在aapp110拋轉時會因為判斷發票金額為 0 時不寫入apk_file建議將此部分開放寫入
# Modify.........: No.MOD-C40221 12/04/30 By Elise 若發票金額為0,需再增加判斷如不申報者,仍可產生發票資料
# Modify.........: No.MOD-C50040 12/05/08 By Elise 倉退單沒有發票也沒有採購單時，不應再幣別取位
# Modify.........: No.MOD-C50054 12/05/16 By Elise 大陸版不可重算(除重評價以外)api05f/api05應直接抓取rvw05f/rvw05資料
# Modify.........: No.MOD-C50137 12/05/17 By Dido 若入庫+項次分多次沖暫估時金額尾差調整 
# Modify.........: No.TQC-C50212 12/05/25 By lujh TQC-B80136 修改錯誤 不勾選時現在按照發票匯率產生,要改為按照採購單匯率產生
# Modify.........: No.MOD-C50181 12/05/28 By Polly 文字型態不可累加
# Modify.........: No.MOD-C60155 12/06/18 By Polly 調整沖暫估資料重覆問題
# Modify.........: No.MOD-C60106 12/06/21 By Elise 將 IF l_apa00 = '26' THEN 移到 INSERT INTO api_file前
# Modify.........: No.MOD-C60222 12/06/29 By Polly 調整slq抓取
# Modify.........: No.CHI-C40006 12/07/05 By fengmy 取消合併入庫單
# Modify.........: No.TQC-C70043 12/07/09 By lujh 【入庫單號/退貨單號】欄位開窗應剔除VMI倉的入庫/退貨單號， 1:VMI庫存儲位的異動單據不產生賬款只在VMI結算倉才產生賬款
# Modify.........: No.FUN-C70049 12/07/11 By minpp 大陆版时，冲销预付账款拿掉项次apb07
# Modify.........: No.FUN-C70052 12/07/12 By xuxz 區分採購性質立帳選項
# Modify.........: No.FUN-C70073 12/07/17 By pauline 調整FUN-BB0001 錯誤
# Modify.........: No.MOD-C70196 12/07/23 By Polly 調整錯誤訊息的顯示方式和增加aap-034的控卡
# Modify.........: No.MOD-C70248 12/07/27 By Polly 計算未稅金額抓取預算金額時,判斷若本次沖帳金額小於原預算金額時,以沖帳金額為主
# Modify.........: No.FUN-C80022 12/08/07 By xuxz mod  FUN-C70052 添加採購性質下拉框
# Modify.........: No:MOD-C80004 12/08/03 By Polly 調整OUTER寫法
# Modify.........: No.FUN-C80047 12/08/13 By xuxz 調整自動沖銷當apz61 = ‘2’時候根據供應商選取沖銷資料
# Modify.........: No:MOD-CA0172 12/10/30 By Polly aapp110有做留置，apc16應依留置金額分配給值
# Modify.........: No:MOD-CA0227 12/10/31 By yinhy 大陸版拋磚賬款時，會報錯aap-604
# Modify.........: No:MOD-CB0174 12/11/20 by Polly 立帳時以發票匯率為主
# Modify.........: No:MOD-CC0034 12/12/05 By Polly 非大陸版重新計算本幣金額後，需再重新取位
# Modify.........: No.FUN-CB0048 13/01/09 By zhangweib 增加rvw18(帳款編號),產生應付賬款時回寫帳款編號到rvw18
# Modify.........: No.FUN-CB0053 13/01/09 By zhangweib 修改g_apa.apa02的初值，如果為背景作業則接收傳入的參數
# Modify.........: No.MOD-CC0070 13/01/17 By Vampire 抓取 apt_file 增加 aptacti 欄位判斷,若為 N 則提示 ams-106 訊息
# Modify.........: No.CHI-CC0038 12/12/26 By yinhy 大陸版依廠商匯總去掉付款條件限制
# Modify.........: No.MOD-D20116 13/02/25 By Polly 增加多串採購員條件
# Modify.........: No.MOD-D30007 13/03/15 By Polly 部分沖銷時，apv04f/apv04應為實際入庫單所對應的採購單金額
# Modify.........: No.MOD-D30164 13/03/19 By Polly 調整抓取沖銷條件判斷
# Modify.........: No:MOD-C90027 13/04/08 By apo 改用期別概念抓取 s_yp 函式 
# Modify.........: No:MOD-C90229 13/04/10 By apo 當不同入庫與項次時皆須重新計算 
# Modify.........: No:MOD-CB0232 13/04/10 By apo 台灣版本依廠商匯總時，增加付款條件排序，排序後，才做匯總
# Modify.........: No.MOD-D60145 13/06/18 By yinhy 判斷若是留置廠商不可更新金額
# Modify.........: No.FUN-D70021 13/08/26 By yangtt MISC料件不判斷跨月是否立暫估
# Modify.........: No.MOD-D80161 13/08/07 By yinhy 部份立暫估產生沖暫估金額錯誤
# Modify.........: No.yinhy130826 13/08/26 By yinhy 产生的冲账资料错误
# Modify.........: No.yinhy131218 13/13/18 By yinhy 沖銷待抵單時抓取重估匯率
# Modify.........: No.CHI-E30030 14/03/20 By yihsuan 1.將 api40 紀錄 aapt160 對應項次(apb02)
#                                                    2.抓取已對應沖暫估原幣與本幣改用 api26+api40 抓取對應關係
# Modify.........: No.MOD-F30090 15/03/25 By doris 修正CHI-E30030,增加對應apa00為26

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE trtype          LIKE apy_file.apyslip, #No.FUN-690028 VARCHAR(5),       #No.FUN-550030
       g_vendor        LIKE rvv_file.rvv06,   #FUN-660117 #CHAR(10)
       g_vendor2       LIKE pmc_file.pmc04,   #FUN-660117 #CHAR(10)
       g_abbr          LIKE pmc_file.pmc03,   #FUN-660117 #CHAR(10)
       g_inv_no        LIKE apa_file.apa08,         #No.MOD-530053
       g_iqc_seq       LIKE type_file.num5,   #No.FUN-690028 SMALLINT,
       g_rvv09         LIKE type_file.dat,    #No.FUN-690028 DATE,
       purchas_sw      LIKE type_file.chr1,   #No.FUN-C70052 VARCHAR(1),
       prepaid_off_sw  LIKE type_file.chr1,   #No.FUN-690028 VARCHAR(1),
       enter_account   LIKE type_file.chr1,   #No.FUN-690028 VARCHAR(1),   #No.FUN-530053
       summary_sw      LIKE type_file.chr1,   #No.FUN-690028 VARCHAR(1),
       l_flag          LIKE type_file.chr1,   #No.FUN-690028 VARCHAR(1),
       begin_no        LIKE apa_file.apa01,         #FUN-660017 #CHAR(16)
       end_no          LIKE apa_file.apa01,         #FUN-660017 #CHAR(16)
       g_edate         LIKE type_file.dat,    #No.FUN-690028 DATE,
       g_amt1,g_amt2   LIKE type_file.num20_6, #No.FUN-690028 DEC(20,6),  #FUN-4B0079
       f_amt1,f_amt2   LIKE type_file.num20_6, #No.FUN-690028 DEC(20,6),  #FUN-4B0079
       t_vendor        LIKE rvv_file.rvv06,   #FUN-660117 #CHAR(10)
       t_inv_no        LIKE apa_file.apa08,      #No.MOD-530053
       t_pmn122        LIKE pmn_file.pmn122,
       t_pmm20         LIKE pmm_file.pmm20,
       t_pmm21         LIKE pmm_file.pmm21,
       t_rvw11         LIKE rvw_file.rvw11,
       t_rvw12         LIKE rvw_file.rvw12,
       g_apa01         LIKE apa_file.apa01,   #NO.MOD-5B0178
       g_apa02         LIKE apa_file.apa02,
       g_apa21         LIKE apa_file.apa21,
       g_apa22         LIKE apa_file.apa22,
       g_apa36         LIKE apa_file.apa36,
       g_pmm02         LIKE pmm_file.pmm02,
      #g_pmm02_t       LIKE pmm_file.pmm02, #FUN-C70052 add#FUN-C80022 mark
       g_pmn122        LIKE pmn_file.pmn122,
       g_pmm13         LIKE pmm_file.pmm13,
       g_pmm12         LIKE pmm_file.pmm12,
       g_pmn40         LIKE pmn_file.pmn40,       #96/07/18 modify
       g_aps22         LIKE aps_file.aps22,
       g_rvv25         LIKE rvv_file.rvv25,
       g_rvw           RECORD LIKE rvw_file.*,
       g_rva04         LIKE rva_file.rva04,
       g_rvu10         LIKE rvu_file.rvu10,
       g_rvu15         LIKE rvu_file.rvu15,          #No.MOD-520104
       g_apa           RECORD LIKE apa_file.*,
       g_apb           RECORD LIKE apb_file.*,
       g_apc           RECORD LIKE apc_file.*,    #No.FUN-680027
       g_pmb           RECORD LIKE pmb_file.*,    #No.FUN-680027
       g_temp          LIKE apa_file.apa24,       #No.FUN-680027
       g_n             LIKE type_file.num10,    #No.FUN-690028 INTEGER,
       g_wc,g_sql      string,  #No.FUN-580092 HCN
       g_wc3           STRING,  #CHI-AB0011 add
       g_change_lang   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(01)               #是否有做語言切換 No.FUN-570112
DEFINE g_aps           RECORD LIKE aps_file.* #No.TQC-7B0083
DEFINE g_net           LIKE apv_file.apv04    #MOD-59044
DEFINE p_row,p_col     LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE g_chr           LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
DEFINE g_cnt           LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE g_i             LIKE type_file.num5    #No.FUN-690028 SMALLINT   #count/index for any purpose
DEFINE g_msg           LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(72)
DEFINE g_before_input_done   LIKE type_file.num5     #No.FUN-690028 SMALLINT,
DEFINE p_cmd           LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
DEFINE source          LIKE azp_file.azp01    #FUN-660017 #CHAR(10)
DEFINE g_rvv930        LIKE rvv_file.rvv930   #FUN-670064
DEFINE g_rvuplant      LIKE rvu_file.rvuplant #FUN-960141
DEFINE t_rvuplant      LIKE rvu_file.rvuplant #FUN-960141
DEFINE g_flag          LIKE type_file.chr1    #FUN-730064
DEFINE g_flag2         LIKE type_file.chr1    #MOD-B10080
DEFINE g_flag3         LIKE type_file.chr1    #FUN-BB0001 add
DEFINE g_chkdiff       LIKE type_file.chr1    #MOD-BA0074
DEFINE g_bookno1       LIKE aza_file.aza81    #FUN-730064
DEFINE g_bookno2       LIKE aza_file.aza82    #FUN-730064
DEFINE g_rvb22         LIKE rvb_file.rvb22    #No.TQC-730030
DEFINE buf             base.StringBuffer      #No.TQC-740142
DEFINE g_apa51_o       LIKE apa_file.apa51    #MOD-740489 add
DEFINE g_apa511_o      LIKE apa_file.apa511   #MOD-740489 add
DEFINE g_apa54         LIKE apa_file.apa54    #MOD-B10080
DEFINE g_apa541        LIKE apa_file.apa541   #MOD-B10080
DEFINE g_apa01_t       LIKE apa_file.apa01    #No.MOD-7B0150
DEFINE g_apa01_o       LIKE apa_file.apa01    #No.MOD-7B0150
DEFINE g_apb24t        LIKE apb_file.apb24    #TQC-8A0079 add   #含稅金額
#該動態數組用于存放新增的apa01，為之后產生apc資料做准備。
DEFINE apa_nw          DYNAMIC ARRAY OF RECORD
                azp01  LIKE azp_file.azp01,        #MOD-A90121
                apa00  LIKE apa_file.apa00,        #MOD-A90121
                apa01  LIKE apa_file.apa01
                       END RECORD
DEFINE g_wc2           STRING                 #FUN-9C0001
DEFINE l_dbs           LIKE type_file.chr21   #FUN-9C0001
DEFINE l_azp01         LIKE azp_file.azp01    #FUN-9C0001 
DEFINE t_azp01         LIKE azp_file.azp01    #FUN-9C0001
DEFINE t_azp03         LIKE azp_file.azp03    #FUN-9C0001
DEFINE g_apa34         LIKE apa_file.apa34    #No.FUN-CB0048   Add
DEFINE g_rvw01         LIKE rvw_file.rvw01    #No.FUN-CB0048   Add
DEFINE g_apa01_s       LIKE apa_file.apa01    #No.FUN-CB0048   Add

MAIN
   DEFINE ls_date       STRING    #->No.FUN-570112
   DEFINE l_n           LIKE type_file.num5         #MOD-A90121
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc           = ARG_VAL(1)       #QBE條件
   LET trtype         = ARG_VAL(2)       #帳款單別
   LET ls_date        = ARG_VAL(3)
   LET g_apa.apa02    = cl_batch_bg_date_convert(ls_date)   #帳款日期
   LET g_apa.apa21    = ARG_VAL(4)       #帳款人員
   LET g_apa.apa22    = ARG_VAL(5)       #帳款部門
   LET g_apa.apa36    = ARG_VAL(6)       #帳款類別
   LET prepaid_off_sw = ARG_VAL(7)       #自動將預付款依P/O#沖銷
   LET enter_account  = ARG_VAL(8)       #單價為0立帳否
   LET summary_sw     = ARG_VAL(9)       #匯總方式
   LET g_bgjob        = ARG_VAL(10)      #背景作業
   LET g_rvb22        = ARG_VAL(11)      #發票號碼  #No.TQC-730030
   #No.FUN-A80026  --Begin
   LET g_wc2          = ARG_VAL(12)      #营运中心CONSTRUCT值
   #No.FUN-A80026  --End  
   LET g_wc3          = ARG_VAL(13)      #CHI-AB0011 add

   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
 
   CALL p110_create_temp_table()   #MOD-940324 add
   LET g_flag2 = 'N'               #MOD-B10080

   #MOD-BC0197 add --start--
   IF NOT cl_null(g_apa.apa36) THEN
      CALL p110_apa36('')
   END IF
   #MOD-BC0197 add --end--
 
   WHILE TRUE
      #No.FUN-A80026  --Begin
      #IF g_bgjob = "N" THEN
      IF g_bgjob = "N" OR cl_null(g_wc) THEN
      #No.FUN-A80026  --End  
         CALL p110()
         IF cl_sure(18,20) THEN
            LET g_success = 'Y'
            BEGIN WORK
            CALL p110_process()
            CALL s_showmsg()
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
           #-MOD-A90121-add-
            FOR l_n = 1 TO apa_nw.getLength()
               LET l_azp01     = apa_nw[l_n].azp01
               LET g_apa.apa00 = apa_nw[l_n].apa00
               LET g_apa.apa01 = apa_nw[l_n].apa01
               IF g_apa.apa01 IS NOT NULL THEN
                  CALL p110_upd_apa57_2()
               END IF     
            END FOR 
           #-MOD-A90121-end-
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p110_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         #No.FUN-A80026  --Begin
         IF cl_null(g_wc2) THEN
            LET g_wc2 = " azp01 = '",g_plant,"'"
         END IF
         #No.FUN-A80026  --End  
         LET g_success = 'Y'
         BEGIN WORK
         CALL p110_process()
         CALL s_showmsg()
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
        #-MOD-A90121-add-
         FOR l_n = 1 TO apa_nw.getLength()
            LET l_azp01     = apa_nw[l_n].azp01
            LET g_apa.apa00 = apa_nw[l_n].apa00
            LET g_apa.apa01 = apa_nw[l_n].apa01
            IF g_apa.apa01 IS NOT NULL THEN
               CALL p110_upd_apa57_2()
            END IF     
         END FOR 
        #-MOD-A90121-end-
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
 
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
 
END MAIN
 
FUNCTION p110_create_temp_table()
 
   DROP TABLE aapp110_temp
   CREATE TEMP TABLE aapp110_temp(
    apk03   LIKE apk_file.apk03,              #MOD-C30780 add
    rvv06   LIKE rvv_file.rvv06,
    rvv09   LIKE rvv_file.rvv09,
    pmc04   LIKE pmc_file.pmc04,
    pmc03   LIKE pmc_file.pmc03,
    pmc24   LIKE pmc_file.pmc24,
    rvv01   LIKE rvv_file.rvv01,
    rvv02   LIKE rvv_file.rvv02,
    rvv03   LIKE rvv_file.rvv03,
    rvv04   LIKE rvv_file.rvv04,
    rvv05   LIKE rvv_file.rvv05,
    rvv36   LIKE rvv_file.rvv36,
    rvv37   LIKE rvv_file.rvv37,
    rvv38   LIKE rvv_file.rvv38,
    rvv87   LIKE rvv_file.rvv87,
    rvv23   LIKE rvv_file.rvv23,
    rvv38t  LIKE rvv_file.rvv38t,       #MOD-AA0021 rvb10t -> rvv38t
    rvb22   LIKE rvb_file.rvb22,
    rvv31   LIKE rvv_file.rvv31,
    rva06   LIKE rva_file.rva06,
    pmm12   LIKE pmm_file.pmm12,
    pmm20   LIKE pmm_file.pmm20,
    pmm21   LIKE pmm_file.pmm21,
    pmm22   LIKE pmm_file.pmm22,
    pmm44   LIKE pmm_file.pmm44,
    pmm02   LIKE pmm_file.pmm02,
    pmn122  LIKE pmn_file.pmn122,
    rvv25   LIKE rvv_file.rvv25,
    rva04   LIKE rva_file.rva04,
    rvu03   LIKE rvu_file.rvu03,
    rvu10   LIKE rvu_file.rvu10,
    rvu15   LIKE rvu_file.rvu15,
    rvv930  LIKE rvv_file.rvv930,
    flag    LIKE type_file.chr1);      #MOD-CB0232 add     
 
   DROP TABLE x
   CREATE TEMP TABLE x(
    po_no   LIKE apb_file.apb06,
    seq     LIKE apb_file.apb07);
 
END FUNCTION
 
FUNCTION p110()
DEFINE li_result LIKE type_file.num5    #No.FUN-690028 SMALLINT       #No.FUN-560002
DEFINE lc_cmd    LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(500)      #No.FUN-570112
DEFINE l_azp02   LIKE azp_file.azp02  #FUN-630043   
DEFINE l_azp03   LIKE azp_file.azp03  #FUN-630043
DEFINE ls_date       STRING   #No.FUN-CB0053
DEFINE l_rvv09   LIKE rvv_file.rvv09  #add by kuangxj170823
 
   WHILE TRUE
      LET g_action_choice = ""
 
      OPEN WINDOW p110_w AT p_row,p_col
           WITH FORM "aap/42f/aapp110" ATTRIBUTE (STYLE = g_win_style)
      CALL cl_ui_init()
 
 
      CLEAR FORM
 

      CONSTRUCT BY NAME g_wc2 ON azp01

         ON ACTION locale
            LET g_change_lang = TRUE    
            EXIT CONSTRUCT

         BEFORE CONSTRUCT
             CALL cl_qbe_init()
             DISPLAY g_plant TO azp01      #TQC-B90072 add

         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT

         ON ACTION about        
            CALL cl_about()     

         ON ACTION help         
            CALL cl_show_help() 

         ON ACTION controlg    
            CALL cl_cmdask()  

         ON ACTION qbe_select
            CALL cl_qbe_select()

         ON ACTION CONTROLP
            CASE
              WHEN INFIELD(azp01)   #來源營運中心
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azw"     
                   LET g_qryparam.where = "azw02 = '",g_legal,"' "
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO azp01
                   NEXT FIELD azp01
            END CASE
      END CONSTRUCT

      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()  
         EXIT WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p110_w
         CALL  cl_used(g_prog,g_time,2) RETURNING g_time     #FUN-B30211
         EXIT PROGRAM
      END IF


      IF cl_null(g_rvb22) THEN  #No.TQC-730030
         CONSTRUCT BY NAME g_wc ON rvv01,rvv06,rvb22,rvv09,rvv36            #FUN-9C0001
 
            ON ACTION locale
               LET g_change_lang = TRUE        #->No.FUN-570112
               EXIT CONSTRUCT
 
            BEFORE CONSTRUCT
                CALL cl_qbe_init()
 
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
#FUN-B50016 --begin
            ON ACTION CONTROLP
               CASE
                  WHEN INFIELD(rvv01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = 'q_rvv9'
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.where = " rvv89 != 'Y' "      #TQC-C70043  add
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO rvv01
                     NEXT FIELD rvv01
                  WHEN INFIELD(rvv06)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = 'q_pmc'
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO rvv06
                     NEXT FIELD rvv06
                  WHEN INFIELD(rvv36)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form ="q_rvv32"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO rvv36
                     NEXT FIELD rvv36
                  WHEN INFIELD(rvb22)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = 'q_rvw1'
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO rvb22
                     NEXT FIELD rvb22
               END CASE  
#FUN-B50016 --end
         END CONSTRUCT
         LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030

         #CHI-AB0011 add --start--
          CONSTRUCT BY NAME g_wc3 ON pmm12 

            ON ACTION locale
               LET g_change_lang = TRUE
               EXIT CONSTRUCT

            BEFORE CONSTRUCT
                CALL cl_qbe_init()

            ON ACTION CONTROLP
               CASE
                  WHEN INFIELD(pmm12) #採購員
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gen"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO pmm12
                     NEXT FIELD pmm12
               END CASE

            ON ACTION exit
               LET INT_FLAG = 1
               EXIT CONSTRUCT

            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE CONSTRUCT

            ON ACTION about
               CALL cl_about()

            ON ACTION help 
               CALL cl_show_help()

            ON ACTION controlg
               CALL cl_cmdask()

            ON ACTION qbe_select
               CALL cl_qbe_select()

         END CONSTRUCT
         #CHI-AB0011 add --end--

      END IF #No.TQC-730030
 

      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         EXIT WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p110_w
         CALL  cl_used(g_prog,g_time,2) RETURNING g_time     #FUN-B30211
         EXIT PROGRAM
      END IF
 
      IF NOT cl_null(g_rvb22) THEN
         DISPLAY g_rvb22 TO FORMONLY.rvb22
         LET g_wc = "rvb22 = '",g_rvb22,"'"
      END IF
      INITIALIZE g_apa.* TO NULL
      INITIALIZE g_apb.* TO NULL
     #LET g_apa.apa02 = g_today   #No.FUN-CB0053 Mark
      LET g_apa.apa21 = g_user
      LET g_apa.apa22 = g_grup
      LET prepaid_off_sw = 'Y'
     #No.FUN-CB0053 ---start--- Add
      IF g_bgjob = "N" OR cl_null(g_wc) THEN
         LET ls_date        = ARG_VAL(3)
         LET g_apa.apa02    = cl_batch_bg_date_convert(ls_date)   #帳款日期
      ELSE
         LET g_apa.apa02 = g_today
      END IF
     #No.FUN-CB0053 ---end  --- Add
      LET purchas_sw = '1'#FUN-C70052 add#FUN-C80022 mod N-->1
      #LET enter_account = 'N'   #MOD-580258
      LET enter_account = 'Y'   #yinhy130530
      IF cl_null(g_rvb22) THEN  #No.TQC-730030
         LET summary_sw = '2'
      END IF                    #No.TQC-730030
      LET begin_no = NULL       #No.MOD-540169
      LET end_no   = NULL       #No.MOD-540169
      LET g_apa01 = NULL        #NO.MOD-5B0178
      CALL s_get_bookno(YEAR(g_apa.apa02)) RETURNING g_flag,g_bookno1,g_bookno2  #No.TQC-740042
      IF g_flag = '1' THEN
         CALL cl_err(g_apa.apa02,'aoo-081',1)
      END IF
 
      INPUT BY NAME trtype,g_apa.apa02,g_apa.apa21,g_apa.apa22,g_apa.apa36,
                    #prepaid_off_sw,enter_account,summary_sw   #No.FUN-530053
                    purchas_sw,     #FUN-C70052 add
                    prepaid_off_sw,enter_account,summary_sw,g_bgjob   #NO.FUN-570112
                    WITHOUT DEFAULTS
 

 
         AFTER FIELD trtype
            IF NOT cl_null(trtype) THEN
              #CALL s_check_no(g_sys,trtype,"","11","","","")   #NO.TQC-B60093 mark
               CALL s_check_no("aap",trtype,"","11","","","")   #NO.TQC-B60093 add
                 RETURNING li_result,trtype
               IF (NOT li_result) THEN
         	       NEXT FIELD trtype
               END IF

               LET g_apa.apamksg = g_apy.apyapr
            END IF
 
         AFTER FIELD apa02
            IF NOT cl_null(g_apa.apa02) THEN
               IF g_apa.apa02 <= g_apz.apz57 THEN   #立帳日期不可小於關帳日期
                  CALL cl_err('','aap-176',1)
                  NEXT FIELD apa02
               END IF
               #add by kuangxj170823 begin
               IF NOT cl_null(g_rvb22) THEN
                 LET l_rvv09 = ''
                 SELECT MAX(rvv09) INTO l_rvv09 FROM rvv_file,rvw_file WHERE rvw01 = g_rvb22 AND rvv01 = rvw08
         
                  IF l_rvv09 > g_apa.apa02  THEN
                     CALL cl_err('','cgap-02',1)
                     NEXT FIELD apa02
                  END IF
               END IF 
               #add by kuangxj170823 end
            END IF
           
 
         AFTER FIELD apa21         #96/07/17 modify 可空白
            IF NOT cl_null(g_apa.apa21) THEN
               CALL p110_apa21('')
               IF NOT cl_null(g_errno) THEN            #抱歉, 有問題
                  CALL cl_err(g_apa.apa21,g_errno,0)
                  NEXT FIELD apa21
               END IF
            END IF
            IF cl_null(g_apa.apa21) THEN
               LET g_apa.apa21 = ' '
            END IF
 
         AFTER FIELD apa22      #96/07/17 modify 可空白
            IF NOT cl_null(g_apa.apa22) THEN
               CALL p110_apa22('')
               IF NOT cl_null(g_errno) THEN                   #抱歉, 有問題
                  CALL cl_err(g_apa.apa22,g_errno,0)
                  NEXT FIELD apa22
               END IF
            END IF
            IF cl_null(g_apa.apa22) THEN
               LET g_apa.apa22 = ' '
            END IF
 
         AFTER FIELD apa36
           #TQC-B90006 mark --begin
           #TQC-B80261 -begin
           # IF NOT (g_apz.apz13 = 'Y' AND NOT cl_null(g_apa.apa22)) THEN
           #    IF cl_null(g_apa.apa36) THEN
           #       CALL cl_err('','aap-405',0)
           #       NEXT FIELD apa36
           #    END IF
           # END IF
           #TQC-B80261 -end
           #TQC-B90006 mark --end
            IF NOT cl_null(g_apa.apa36) THEN
               CALL p110_apa36('')
               IF NOT cl_null(g_errno) THEN                   #抱歉, 有問題
                  CALL cl_err(g_apa.apa36,g_errno,0)
                  NEXT FIELD apa36
               END IF
            END IF
         #TQC-B90006 mark --begin
         #TQC-B80261 -begin
        # AFTER INPUT
        #    IF  INT_FLAG THEN EXIT INPUT END IF
        #    IF NOT (g_apz.apz13 = 'Y' AND NOT cl_null(g_apa.apa22)) THEN
        #       IF cl_null(g_apa.apa36) THEN
        #          CALL cl_err('','aap-405',0)
        #          NEXT FIELD apa36
        #       END IF
        #    END IF
         #TQC-B80261 -end
         #TQC-B90006 mark --end
         BEFORE FIELD summary_sw
            IF g_aza.aza26 = '2' THEN
               LET summary_sw = '2'
               DISPLAY BY NAME summary_sw
            END IF
            IF NOT cl_null(g_rvb22) THEN
               LET summary_sw = '1'
               DISPLAY BY NAME summary_sw
               CALL p110_set_no_entry('1')
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(trtype) # Class
                  CALL q_apy(FALSE,FALSE,trtype,'11','AAP') RETURNING trtype
                  DISPLAY BY NAME trtype
               WHEN INFIELD(apa21) # Class
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gen"
                  LET g_qryparam.default1 = g_apa.apa21
                  CALL cl_create_qry() RETURNING g_apa.apa21
                  DISPLAY BY NAME g_apa.apa21
               WHEN INFIELD(apa22) # Class
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem"
                  LET g_qryparam.default1 = g_apa.apa22
                  CALL cl_create_qry() RETURNING g_apa.apa22
                  DISPLAY BY NAME g_apa.apa22
               WHEN INFIELD(apa36) # Class
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_apr"
                  LET g_qryparam.default1 = g_apa.apa36
                  CALL cl_create_qry() RETURNING g_apa.apa36
                  DISPLAY BY NAME g_apa.apa36
            END CASE
 
         ON ACTION locale
            LET g_change_lang = TRUE
            EXIT INPUT
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END INPUT
 
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin) #NO.FUN-570112 MARK
         CONTINUE WHILE
      END IF
 

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p110_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B30211
      EXIT PROGRAM
   END IF
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01 = "aapp110"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
          CALL cl_err('aapp110','9031',1)
      ELSE
         LET g_wc=cl_replace_str(g_wc, "'", "\"")
         LET g_wc3=cl_replace_str(g_wc3, "'", "\"") #CHI-AB0011 add
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",g_wc CLIPPED,"'",
                      " '",trtype CLIPPED,"'",
                      " '",g_apa.apa02 CLIPPED,"'",
                      " '",g_apa.apa21 CLIPPED,"'",
                      " '",g_apa.apa22 CLIPPED,"'",
                      " '",g_apa.apa36 CLIPPED,"'",
                      " '",prepaid_off_sw CLIPPED,"'",
                      " '",enter_account CLIPPED,"'",
                      " '",summary_sw CLIPPED,"'",
                      " '",g_bgjob CLIPPED,"'",
                      " '",g_rvb22 CLIPPED,"'",   #No.FUN-A80026
                      " '",g_wc2   CLIPPED,"'",   #No.FUN-A80026 #CHI-AB0011 add ,
                      " '",g_wc3 CLIPPED,"'"    #CHI-AB0011 add
         CALL cl_cmdat('aapp110',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p110_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B30211
      EXIT PROGRAM
   END IF
   EXIT WHILE
END WHILE
 
END FUNCTION
 
FUNCTION p110_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("summary_sw",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION p110_set_no_entry(p_cmd)
   DEFINE p_cmd    LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
      IF g_aza.aza26 = '2' THEN
         CALL cl_set_comp_entry("summary_sw",FALSE)
      END IF
   END IF
   IF NOT cl_null(g_rvb22) THEN
      CALL cl_set_comp_entry("summary_sw",FALSE)
   END IF
 
END FUNCTION
 
FUNCTION p110_process()
   DEFINE t_apb04   LIKE apb_file.apb04
   DEFINE t_apb05   LIKE apb_file.apb05
   DEFINE l_cnt     LIKE type_file.num5   #No.FUN-690028 SMALLINT   #TQC-610108
   DEFINE l_n       LIKE type_file.num5   #No.FUN-690028 SMALLINT             #No.FUN-680027
   DEFINE l_apc13   LIKE apc_file.apc13   #No.FUN-680027
   DEFINE l_gec031  LIKE gec_file.gec031  #No.FUN-680029
   DEFINE l_apb21   LIKE apb_file.apb21   #No.TQC-790138 add
   DEFINE l_apb22   LIKE apb_file.apb22   #No.TQC-790138 add
   DEFINE l_apa01   LIKE apa_file.apa01   #No.TQC-790138 add
   DEFINE l_rvw05f_s LIKE rvw_file.rvw05f #No.MOD-7B0150 add  發票原幣金額合計值
   DEFINE l_pmm12   LIKE pmm_file.pmm12   #No.MOD-7B0150
   DEFINE l_pmm25   LIKE pmm_file.pmm25   #No.MOD-7B0150
   DEFINE l_pmm21   LIKE pmm_file.pmm21   #No.MOD-7B0150
   DEFINE l_pmm22   LIKE pmm_file.pmm22   #No.MOD-7B0150
   DEFINE l_poz18   LIKE poz_file.poz18,
          l_poz19   LIKE poz_file.poz19,
          l_poz01   LIKE poz_file.poz01,
          l_c       LIKE type_file.num5
   DEFINE l_temp    RECORD                            #MOD-940324 add
                     rvw01   LIKE rvw_file.rvw01,     #MOD-C30780 add
                     rvv06   LIKE rvv_file.rvv06,
                     rvv09   LIKE rvv_file.rvv09,
                     pmc04   LIKE pmc_file.pmc04,
                     pmc03   LIKE pmc_file.pmc03,
                     pmc24   LIKE pmc_file.pmc24,
                     rvv01   LIKE rvv_file.rvv01,
                     rvv02   LIKE rvv_file.rvv02,
                     rvv03   LIKE rvv_file.rvv03,
                     rvv04   LIKE rvv_file.rvv04,
                     rvv05   LIKE rvv_file.rvv05,
                     rvv36   LIKE rvv_file.rvv36,
                     rvv37   LIKE rvv_file.rvv37,
                     rvv38   LIKE rvv_file.rvv38,
                     rvv87   LIKE rvv_file.rvv87,
                     rvv23   LIKE rvv_file.rvv23,
                     rvv38t  LIKE rvv_file.rvv38t,   #MOD-AA0021 rvb10t -> rvv38t
                     rvb22   LIKE rvb_file.rvb22,
                     rvv31   LIKE rvv_file.rvv31,
                     rva06   LIKE rva_file.rva06,
                     pmm12   LIKE pmm_file.pmm12,
                     pmm20   LIKE pmm_file.pmm20,
                     pmm21   LIKE pmm_file.pmm21,
                     pmm22   LIKE pmm_file.pmm22,
                     pmm44   LIKE pmm_file.pmm44,
                     pmm02   LIKE pmm_file.pmm02,
                     pmn122  LIKE pmn_file.pmn122,
                     rvv25   LIKE rvv_file.rvv25,
                     rva04   LIKE rva_file.rva04,
                     rvu03   LIKE rvu_file.rvu03,
                     rvu10   LIKE rvu_file.rvu10,
                     rvu15   LIKE rvu_file.rvu15,
                     rvv930  LIKE rvv_file.rvv930,
                     flag    LIKE type_file.chr1       #MOD-CB0232 add     
                    END RECORD
   DEFINE l_bdate    LIKE type_file.dat    #CHI-9A0021 add
   DEFINE l_edate    LIKE type_file.dat    #CHI-9A0021 add
   DEFINE l_correct  LIKE type_file.chr1   #CHI-9A0021 add
   DEFINE l_apa100_t LIKE apa_file.apa100  #FUN-9C0001
   DEFINE l_apa01_t  LIKE apa_file.apa01   #FUN-9C0001
   DEFINE l_n1,l_n2  LIKE type_file.num5   #MOD-B50037
   DEFINE l_year     LIKE type_file.num5   #CHI-820005
   DEFINE l_month     LIKE type_file.num5   #MOD-C90027
   DEFINE l_sql2     STRING                #FUN-BB0001 add
   DEFINE l_rvu27    LIKE rvu_file.rvu27   #FUN-BB0001 add
   DEFINE l_wc       STRING                #MOD-BC0281 add
 
   LET g_apa02 = g_apa.apa02
   LET g_apa21 = g_apa.apa21
   LET g_apa22 = g_apa.apa22
   LET g_apa36 = g_apa.apa36
 
   LET g_apa34   = 0    #No.FUN-CB0048   Add
   LET g_rvw01   = NULL #No.FUN-CB0048   Add
   LET g_apa01_s   = NULL #No.FUN-CB0048   Add

   CALL apa_nw.clear()    #No.TQC-7C0172
 
   DELETE FROM aapp110_temp    #MOD-950024 add
   DELETE FROM x               #MOD-950024 add
 
  #-MOD-A90161-add-
   IF g_aza.aza26 = '2' THEN
      LET buf = base.StringBuffer.create()
      CALL buf.append(g_wc)
      CALL buf.replace("rvb22","rvw01",0)
      LET g_wc = buf.toString()
   END IF
  #-MOD-A90161-end-
   IF NOT cl_null(g_apa02) THEN
      LET l_flag='N'
      CALL p110_chkdate()
      IF l_flag ='X' THEN
         LET g_success = 'N'
         RETURN
      END IF
 
      IF l_flag='Y' THEN
         LET g_success = 'N'
         CALL cl_err('','axr-065',1)
         RETURN
      END IF
   END IF
 
   LET g_sql = "SELECT azp01 FROM azp_file,azw_file ",
               " WHERE ",g_wc2 CLIPPED ,
               "   AND azw01 = azp01 AND azw02 = '",g_legal,"' ",
               " ORDER BY azp01 "
   PREPARE sel_azp03_pre FROM g_sql
   DECLARE sel_azp03_cs CURSOR FOR sel_azp03_pre
   LET t_azp01 = NULL    
   LET t_azp03 = NULL 
   LET t_vendor = NULL
   LET t_inv_no = ' '
   LET t_pmn122 = ' '
   LET t_apb04  = ' '
   LET t_apb05  = ' '
   LET t_rvw11  = NULL
   LET t_rvw12  = NULL
   LET g_apa.apa01 = NULL
   LET g_apa01_t = NULL          # 用于對apa01進行備份，同時用于判斷是否已新增一張單據
   LET g_apa01_o = NULL          # 用于對apa01進行備份，同時用于判斷是否已新增一張單據
   FOREACH sel_azp03_cs INTO l_azp01
      IF STATUS THEN
         CALL cl_err('p110(ckp#1):',SQLCA.sqlcode,1)
         RETURN
      END IF 
      LET g_plant_new = l_azp01
      CALL s_gettrandbs()
      LET l_dbs = g_dbs_tra

     #-MOD-A90161-mark-
     #IF g_aza.aza26 = '2' THEN
     #   LET buf = base.StringBuffer.create()
     #   CALL buf.append(g_wc)
     #   CALL buf.replace("rvb22","rvw01",0)
     #   LET g_wc = buf.toString()
     #END IF
     #-MOD-A90161-end-
    
      #重要信息: 1.rvv40 沒有作用  2.請款數量(下月衝暫估數量)=rvv87-rvv23(rvw10)
      #                              不考慮rvv88數量 請款數量與rvv88無關
      #          3.若請款能衝到暫估時,則rvv23+請款數量 rvv88-請款數量
      #            若一般請款(衝不到暫估時),則rvv23+請款數量
      IF g_aza.aza26 = '2' THEN   #TQC-5C0112
        #LET g_sql = "SELECT rvv06,rvv09,'','','',rvv01,rvv02,rvv03,rvv04,rvv05,",        #MOD-C30780 mark
         LET g_sql = "SELECT rvw01,rvv06,rvv09,'','','',rvv01,rvv02,rvv03,rvv04,rvv05,",  #MOD-C30780 add
                    #"       rvv36,rvv37,rvv38,rvv87-rvv23,(rvv87-rvv23)*rvv38,", #MOD-B30671 mark
                     "       rvv36,rvv37,rvv38,rvv87,rvv23,",                     #MOD-B30671
                    #"       (rvv87-rvv23)*rvv38t,",   #TQC-8A0079 add            #MOD-B30671 mark
                     "       rvv38t,",                                            #MOD-B30671 
                    #"       rvv31,rvu03,'','','','','','', ",                    #MOD-B30671 mark
                     "       rvw01,rvv31,'','','','','','','','', ",              #MOD-B30671
                    #"       '','','','','', ",                                   #MOD-B30671 mark 
                    #"       rvw_file.*,rvv25,'',rvu10,rvu15,rvv930",             #MOD-B30671 mark
                     "       rvv25,'',rvu03,rvu10,rvu15,rvv930,''",               #MOD-B30671 #MOD-CB0232 add ''
                   # "  FROM ",l_dbs CLIPPED,"rvv_file,",l_dbs CLIPPED,"rvu_file,rvw_file",      #FUN-A50102 mark
                     "  FROM ",cl_get_target_table(l_azp01,'rvv_file'),",",                      #FUN-A50102
                               cl_get_target_table(l_azp01,'rvu_file'),",rvw_file",              #FUN-A50102 
                     " WHERE ",g_wc CLIPPED,
                     "   AND rvvplant = '",l_azp01,"' ",   #FUN-9C0001
                     "   AND (rvv87 > rvv23 OR (rvv23=0 AND rvv39>0))",  #MOD-8C0146  #MOD-920117
                     "   AND rvu01 = rvv01 AND rvuconf='Y' ",
                     "   AND rvu00 != '2' ",
                     "   AND rvv01 = rvw08 AND rvv02 = rvw09 ", #No.MOD-8C0264 add ,
                     "   AND rvw99 = '",l_azp01,"' ",   #FUN-A20006
                     "   AND rvv89 != 'Y' ",            #MOD-B50074
                     "   AND rvw01 NOT IN (SELECT DISTINCT apk03 ",
                     "   FROM apk_file,apa_file,apb_file ",
                     "  WHERE apk01 = apa01 ",
                     "    AND apa01 = apb01 ",
                     "    AND apb21 = rvw08 ",
                     "    AND apb22 = rvw09) "
        #-MOD-B30671-add-
         #大陸版選擇依廠商彙總，拆單錯誤，故必須增加pmm20排序條件，否則後續FOREACH因排序問題一遇到不同付款條件者就會拆單。
         PREPARE p110_tmp_prep1 FROM g_sql
         DECLARE p110_tmp_cs1 CURSOR WITH HOLD FOR p110_tmp_prep1
         FOREACH p110_tmp_cs1 INTO l_temp.*
         
            SELECT pmm12,pmm20,pmm21,pmm22 INTO l_temp.pmm12,l_temp.pmm20,l_temp.pmm21,l_temp.pmm22 
              FROM pmm_file,pmn_file
             WHERE pmn01 = pmm01 
               AND pmn01 = l_temp.rvv36  
               AND pmn02 = l_temp.rvv37 
                 
            INSERT INTO aapp110_temp VALUES(l_temp.*)  
         END FOREACH
         LET g_sql = "SELECT '',a.rvv06,a.rvv09,a.pmc04,a.pmc03,a.pmc24,a.rvv01,a.rvv02,a.rvv03,a.rvv04,a.rvv05,",  #TQC-C10048 add ''
                     "       a.rvv36,a.rvv37,a.rvv38,a.rvv87-a.rvv23,",   
                     "       (a.rvv87-a.rvv23)*a.rvv38,",               #TQC-B40072 add 
                     "       (a.rvv87-a.rvv23)*a.rvv38t,",   
                     "       a.rvv31,a.rva06,a.pmm20,a.pmm21,a.pmm44,a.pmm02,'',a.pmn122,",     
                     "       '','','','','',",  
                     "       rvw_file.*,a.rvv25,a.rva04,a.rvu10,a.rvu15,a.rvv930",                         
                     "  FROM aapp110_temp a ",
                     "  ,rvw_file",
                     "  WHERE a.rvv01 = rvw08 AND a.rvv02 = rvw09 ", 
                     "    AND a.apk03 = rvw01 "                               #MOD-C30780 add
        #-MOD-B30671-end-
      ELSE
        #LET g_sql = "SELECT '1',rvv06,rvv09,pmc04,pmc03,pmc24,rvv01,rvv02,rvv03,rvv04,rvv05,"  ,     #FUN-BB0001 add '1' #MOD-CB0232 mark
                    #"       rvv36,rvv37,rvv38,rvv87-rvv23,(rvv87-rvv23)*rvb10,",   #MOD-AA0021 mark
                    #"       rvv36,rvv37,rvv38,rvv87-rvv23,(rvv87-rvv23)*rvv38,",                     #MOD-AA0021 #MOD-CB0232 mark
                    #"       (rvv87-rvv23)*rvb10t,",                                #MOD-AA0021 mark
                    #"       (rvv87-rvv23)*rvv38t,",                                                  #MOD-AA0021 #MOD-CB0232 mark
                    #"       rvv31,rva06,'','','','','','',",                                         #MOD-CB0232 mark                                 
                    #"       '','','','','',",                                                        #MOD-CB0232 mark
                    #"       rvw_file.*,rvv25,rva04,rvu10,rvu15,rvv930",                              #FUN-9C0001 #MOD-CB0232 mark
                    #"  FROM ",l_dbs CLIPPED,"rvu_file,",                                                    #FUN-A50102 mark
                    #          l_dbs CLIPPED,"rvv_file LEFT OUTER JOIN ",l_dbs CLIPPED,"rva_file ",          #FUN-A50102 mark
                    #"                                 ON rvv04 = rva01 ",                                   #FUN-A50102 mark
                    #"                                 LEFT OUTER JOIN ",l_dbs CLIPPED,"ima_file ",          #FUN-A50102 mark
                    #"                                 ON rvv31 = ima01 ",                                   #FUN-A50102 mark
                    #"                                 LEFT OUTER JOIN ",l_dbs CLIPPED,"pmc_file ",          #FUN-A50102 mark
                    #"                                 ON rvv06 = pmc01 ",                                   #FUN-A50102 mark
                    #"                                 LEFT OUTER JOIN (",l_dbs CLIPPED,"rvb_file ",         #FUN-A50102 mark
         LET g_sql = "SELECT rvw01,rvv06,rvv09,pmc04,pmc03,",                                         #MOD-CB0232 add
                     "       pmc24,rvv01,rvv02,rvv03,rvv04,",                                         #MOD-CB0232 add
                     "       rvv05,rvv36,rvv37,rvv38,rvv87,",                                         #MOD-CB0232 add
                     "       rvv23,rvv38t,rvw01,rvv31,rva06,",                                        #MOD-CB0232 add
                     "       '','','','','',",                                                        #MOD-CB0232 add
                     "       '','',rvv25,rva04,rvu03,",                                               #MOD-CB0232 add                                
                     "       rvu10,rvu15,rvv930,'1'",                                                 #MOD-CB0232 add
                     "  FROM ",cl_get_target_table(l_azp01,'rvu_file'),",",                                  #FUN-A50102
                               cl_get_target_table(l_azp01,'rvv_file'),                                      #FUN-A50102
                     " LEFT OUTER JOIN ",cl_get_target_table(l_azp01,'rva_file')," ON rvv04 = rva01 ",       #FUN-A50102
                     " LEFT OUTER JOIN ",cl_get_target_table(l_azp01,'ima_file')," ON rvv31 = ima01 ",       #FUN-A50102
                     " LEFT OUTER JOIN ",cl_get_target_table(l_azp01,'pmc_file')," ON rvv06 = pmc01 ",       #FUN-A50102
                     " LEFT OUTER JOIN (",cl_get_target_table(l_azp01,'rvb_file'),                           #FUN-A50102            
                     "                                                   LEFT OUTER JOIN rvw_file ",
                     "                                                   ON rvb22 = rvw01) ",
                     "                                           ON rvv04 = rvb01 AND rvv05 = rvb02 ", 
                     " WHERE ",g_wc CLIPPED,
                     "   AND rvvplant = '",l_azp01,"' ",   #FUN-9C0001
                     "   AND (rvv87 > rvv23 OR (rvv23=0 AND rvv39>0))", 
                     "   AND rvu01 = rvv01 AND rvuconf='Y' ",
                     "   AND rvu00 != '2' ",  
                     "   AND rvv89 != 'Y' ",            #MOD-B50074
                     "   AND ((rvb22 IS NOT NULL AND rvb22 != ' ') OR (rvu00='3'))",
                     "   AND  ( rvu27 = '1' OR rvu27 IS NULL OR rvu27 = ' ' ) "   #FUN-BB0001 add 
         IF summary_sw = '1' THEN                                                            #MOD-CB0232 add
            LET g_sql = g_sql CLIPPED,"   AND rvv03 IN ('1','3') "                           #MOD-CB0232 add
         END IF                                                                              #MOD-CB0232 add
      #流通代銷 虛擬入庫單 無收貨單，發票記錄於 rvv22
      #FUN-BB0001 add START
         LET l_wc= cl_replace_str(g_wc,'rvb22','rvv22')               #MOD-BC0281 add
        #-------------------------MOD-CB0232-------------------------------------------------(S)
        #--MOD-CB0232--mark
        #LET l_sql2 = "SELECT '2',rvv06,rvv09,pmc04,pmc03,pmc24,rvv01,rvv02,rvv03,rvv04,rvv05,",
        #            "       rvv36,rvv37,rvv38,rvv87-rvv23,(rvv87-rvv23)*rvv38,",
        #            "       (rvv87-rvv23)*rvv38t,",
        #            "       rvv31,rva06,'','','','','','',",
        #            "       '','','','','',",
        #            "       rvw_file.*,rvv25,rva04,rvu10,rvu15,rvv930",
        #--MOD-CB0232--mark
         LET l_sql2 ="SELECT rvw01,rvv06,rvv09,pmc04,pmc03,",                                        
                     "       pmc24,rvv01,rvv02,rvv03,rvv04,",                                  
                     "       rvv05,rvv36,rvv37,rvv38,rvv87,",                               
                     "       rvv23,rvv38t,rvw01,rvv31,rva06,",                         
                     "       '','','','','',",                                      
                     "       '','',rvv25,rva04,rvu03,",                                                          
                     "       rvu10,rvu15,rvv930,'2'",                              
        #-------------------------MOD-CB0232-------------------------------------------------(E)
                     "  FROM ",cl_get_target_table(l_azp01,'rvu_file'),",",
                               cl_get_target_table(l_azp01,'rvv_file'),
                     " LEFT OUTER JOIN ",cl_get_target_table(l_azp01,'rva_file')," ON rvv04 = rva01 ",
                     " LEFT OUTER JOIN ",cl_get_target_table(l_azp01,'ima_file')," ON rvv31 = ima01 ",
                     " LEFT OUTER JOIN ",cl_get_target_table(l_azp01,'pmc_file')," ON rvv06 = pmc01 ",
                     " LEFT OUTER JOIN rvw_file  ON rvv22 = rvw01  ",
                    #" WHERE ",g_wc CLIPPED,                            #MOD-BC0281 mark
                     " WHERE ",l_wc CLIPPED,                            #MOD-BC0281 add
                     "   AND rvvplant = '",l_azp01,"' ",
                     "   AND (rvv87 > rvv23 OR (rvv23=0 AND rvv39>0))",
                     "   AND rvu01 = rvv01 AND rvuconf='Y' ",
                     "   AND rvu00 != '2' ",
                     "   AND rvv89 != 'Y' ",
                     "   AND ((rvv22 IS NOT NULL AND rvv22 != ' ') OR (rvu00='3'))",
                     "   AND  rvu27  IN ('2','3','4') "
         IF summary_sw = '1' THEN                                                            #MOD-CB0232 add
            LET l_sql2 = l_sql2 CLIPPED,"   AND rvv03 IN ('1','3') "                         #MOD-CB0232 add 
         END IF                                                                              #MOD-CB0232 add
         LET g_sql = g_sql," UNION ALL " ,l_sql2                                             #MOD-CB0232 add 
      #FUN-BB0001 add END
        #----------------------MOD-CB0232-------------------------------------(S)
         PREPARE p110_tmp_prep2 FROM g_sql
         DECLARE p110_tmp_cs2 CURSOR WITH HOLD FOR p110_tmp_prep2
         FOREACH p110_tmp_cs2 INTO l_temp.*

            SELECT pmm12,pmm20,pmm21,pmm22 INTO l_temp.pmm12,l_temp.pmm20,l_temp.pmm21,l_temp.pmm22
              FROM pmm_file,pmn_file
             WHERE pmn01 = pmm01
               AND pmn01 = l_temp.rvv36
               AND pmn02 = l_temp.rvv37

            INSERT INTO aapp110_temp VALUES(l_temp.*)
         END FOREACH
         LET l_cnt = 0
         LET g_sql = "SELECT a.flag,a.rvv06,a.rvv09,a.pmc04,a.pmc03,a.pmc24,a.rvv01,a.rvv02,a.rvv03,a.rvv04,a.rvv05,", 
                     "       a.rvv36,a.rvv37,a.rvv38,a.rvv87-a.rvv23,",
                     "       (a.rvv87-a.rvv23)*a.rvv38,",              
                     "       (a.rvv87-a.rvv23)*a.rvv38t,",
                     "       a.rvv31,a.rva06,a.pmm20,a.pmm21,a.pmm44,a.pmm02,'',a.pmn122,",
                     "       '','','','','',",
                     "       rvw_file.*,a.rvv25,a.rva04,a.rvu10,a.rvu15,a.rvv930",
                     "  FROM aapp110_temp a ",
                     "  ,rvw_file",
                     " WHERE a.apk03 = rvw01 "                               
        #----------------------MOD-CB0232-------------------------------------(S)
      END IF
    
      IF g_aza.aza26 = '2' THEN
         IF summary_sw='1' THEN
            LET g_sql = g_sql CLIPPED,"   AND rvv03 IN ('1','3') ",
                       #" ORDER BY rvw01,rvv01,rvv02,rvv06,rvv03,rvw05 DESC"              #FUN-9C0001   #FUN-BB0001 mark
                       #" ORDER BY rvw01,rvv01,rvv02,rvv06,rvv03,rvw05 DESC"              #TQC-C20081 add  #MOD-CB0232 mark	  
                        " ORDER BY rvw01,a.rvv01,a.rvv02,a.rvv06,a.rvv03,rvw05 DESC"      #MOD-CB0232 add
           #TQC-C20081 mark START
           #LET l_sql2 = l_sql2 CLIPPED,"   AND rvv03 IN ('1','3') "    #FUN-BB0001 add
           #LET g_sql = g_sql," UNION ALL " ,l_sql2                     #FUN-BB0001 add
           #LET g_sql = g_sql CLIPPED," ORDER BY rvw01,rvv01,rvv02,rvv06,rvv03"   #FUN-BB0001 add
           #TQC-C20081 mark END
         ELSE
           #FUN-BB0001 mark START
           #LET g_sql = g_sql CLIPPED," ORDER BY rvuplant,rvv06,rvv03, ",                #FUN-960141 add rvuplant  #FUN-9C0001
           #            g_sql CLIPPED," ORDER BY rvv06,rvv03, ",                          #FUN-9C0001
           #           " rvw11,rvw12,rvv01,rvv02,rvv04,rvv05,rvu03,rvw05 DESC "                             #MOD-B30671 mark 
           #           " rvw11,rvw12,a.pmm21,a.pmm20,a.rvv01,a.rvv02,a.rvv04,a.rvv05,a.rvu03,rvw05 DESC  "  #MOD-B30671 
           #FUN-BB0001 mark START
           #TQC-C20081 mark START
          ##FUN-BB0001 add START
           #LET g_sql = g_sql CLIPPED," UNION ALL " ,l_sql2             
           #LET g_sql = g_sql CLIPPED," ORDER BY rvv06,rvv03, ",
           #           " rvv01,rvv02,rvv04,rvv05 "
          ##FUN-BB0001 add END
          #TQC-C20081 mark END
           #TQC-C20081 add START
           #LET g_sql = g_sql CLIPPED," ORDER BY rvuplant,rvv06,rvv03, ",                #FUN-960141 add rvuplant  #FUN-9C0001
           #LET g_sql = g_sql CLIPPED," ORDER BY rvv06,rvv03, ",                         #MOD-CB0232 mark   #FUN-9C0001
            LET g_sql = g_sql CLIPPED," ORDER BY a.rvv06,a.rvv03, ",                     #MOD-CB0232 add
                      #" rvw11,rvw12,rvv01,rvv02,rvv04,rvv05,rvu03,rvw05 DESC "                             #MOD-B30671 mark
                       " rvw11,rvw12,a.pmm21,a.pmm20,a.rvv01,a.rvv02,a.rvv04,a.rvv05,a.rvu03,rvw05 DESC  "  #MOD-B30671
           #TQC-C20081 add START
         END IF
       ELSE
         IF summary_sw='1' THEN
           #LET g_sql = g_sql CLIPPED,"   AND rvv03 IN ('1','3') "                       #MOD-CB0232 mark
                      #" ORDER BY rvw01,rvv01,rvv02,rvv06,rvv03"               #FUN-9C0001  #TQC-C20081 mark
           #LET l_sql2 = l_sql2 CLIPPED,"   AND rvv03 IN ('1','3') "              #TQC-C20081 add #MOD-CB0232 mark
           #LET g_sql = g_sql," UNION ALL " ,l_sql2                               #TQC-C20081 add #MOD-CB0232 mark
           #LET g_sql = g_sql CLIPPED," ORDER BY rvw01,rvv01,rvv02,rvv06,rvv03"   #FUN-BB0001 add #MOD-BC0281 mark
           #LET g_sql = g_sql CLIPPED," ORDER BY rvv01,rvv02,rvv06,rvv03"         #MOD-BC0281 add #MOD-CB0232 mark
            LET g_sql = g_sql CLIPPED," ORDER BY a.rvv01,a.rvv02,a.rvv06,a.rvv03"        #MOD-CB0232 add  
         ELSE 
           #TQC-C20081 mark START
           #LET g_sql = #g_sql CLIPPED," ORDER BY rvuplant,rvv06,rvv03, ",      #FUN-960141 add rvuplant  #FUN-9C0001
           #            g_sql CLIPPED," ORDER BY rvv06,rvv03, ",                #FUN-9C0001 
           #            " rvw11,rvw12,rvv01,rvv02,rvv04,rvv05,rvu03 "
           #TQC-C20081 mark END
           #TQC-C20081 add START
           #LET g_sql = g_sql CLIPPED," UNION ALL " ,l_sql2                     #FUN-BB0001 add #MOD-CB0232 mark
           #LET g_sql = g_sql CLIPPED," ORDER BY rvv06,rvv03, ",                #MOD-CB0232 mark 
           #            " rvv01,rvv02,rvv04,rvv05 "                             #MOD-CB0232 mark
           #TQC-C20081 add END
            LET g_sql = g_sql CLIPPED," ORDER BY a.rvv06,a.rvv03, ",            #MOD-CB0232 add   
                        " a.pmm21,a.pmm20, ",                                   #MOD-CB0232 add
                        " a.rvv01,a.rvv02,a.rvv04,a.rvv05 "                     #MOD-CB0232 add
         END IF
       END IF
    
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql            #FUN-A50102 
      CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql    #FUN-A50102
      PREPARE p110_prepare FROM g_sql
      IF STATUS THEN
         CALL cl_err('prepare:',STATUS,1)
         LET g_success = 'N'
         RETURN
      END IF
    
      DECLARE p110_cs CURSOR WITH HOLD FOR p110_prepare

      CALL s_showmsg_init()   #No.FUN-710014
      FOREACH p110_cs INTO g_flag3,g_vendor,g_rvv09,g_vendor2,g_abbr,g_apa.apa18,  #FUN-BB0001 add g_flag3
                           g_apb.apb21,g_apb.apb22,g_apb.apb29,g_apb.apb04,
                           g_apb.apb05,g_apb.apb06,g_apb.apb07,
                           g_apb.apb23,g_apb.apb09,g_apb.apb24,
                           g_apb24t,   #TQC-8A0079 add
                           g_apb.apb12,g_apa.apa09,g_apa.apa11,           #No.TQC-740142
                           g_apa.apa15,g_apa.apa17,g_pmm02,g_apa.apa22,g_pmn122,
                           g_apa.apa52,l_gec031,g_apa.apa16,t_azi03,t_azi04,  #No.FUN-680029 新增l_gec031   #MOD-780215
                           g_rvw.*,
                           g_rvv25,g_rva04,g_rvu10,g_rvu15,g_rvv930      #No.MOD-520104 #FUN-670064
                           #,g_rvuplant    #FUN-960141    #FUN-9C0001 
         IF STATUS THEN
            LET g_success = 'N'
            CALL s_errmsg('','','p111(ckp#1):',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
        #MOD-B90190-----add-----start
         IF g_rvv09 > g_apa02 THEN
            CONTINUE FOREACH
         END IF
        #MOD-B90190-----add-------end
        #MOD-A20113---add---start---
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM apa_file,apb_file
          WHERE apb21 = g_apb.apb21
            AND apb22 = g_apb.apb22
            AND apa01 = apb01
            AND apa42 = 'N'
            AND apa00 <> '26'
            AND apb29 = '3'      #MOD-A30046 add
            AND apb09 = 0        #MOD-A30046 add
         IF l_cnt > 0 THEN
            CONTINUE FOREACH
         END IF
        #MOD-A20113---add---end---

        #CHI-AB0011 add --start--
        IF g_wc3 != ' 1=1' THEN
           LET l_cnt = 0
           LET g_sql="SELECT COUNT(*) FROM pmm_file ",
                     " WHERE ",g_wc3 CLIPPED,
                     "   AND pmm01 = '",g_apb.apb06,"'"
           PREPARE p110_precount FROM g_sql
           DECLARE p110_count CURSOR FOR p110_precount
           OPEN p110_count
           FETCH p110_count INTO l_cnt
           IF l_cnt = 0 THEN
              CONTINUE FOREACH
           END IF
        END IF
        #CHI-AB0011 add --end--

         IF cl_null(g_apb.apb06) THEN

          # LET g_sql = "SELECT rvu111,rvu115 FROM ",l_dbs CLIPPED,"rvu_file ",                 #FUN-A50102  mark
            LET g_sql = "SELECT rvu111,rvu115 FROM ",cl_get_target_table(l_azp01,'rvu_file'),   #FUN-A50102
                        " WHERE rvu01 = '",g_apb.apb21,"' "
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql                #FUN-A50102 
            CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql        #FUN-A50102
            PREPARE sel_rvu111_pre FROM g_sql
            EXECUTE sel_rvu111_pre INTO g_apa.apa11,g_apa.apa15
          # LET g_sql = "SELECT rva10 FROM ",l_dbs CLIPPED,"rva_file ",                         #FUN-A50102  mark
         #FUN-BB0001 add START
            SELECT rvu27 INTO l_rvu27 FROM rvu_file WHERE rvu01 = g_apb.apb21
            IF g_flag3 = '1' OR l_rvu27 = '1' OR cl_null(l_rvu27) OR l_rvu27 = ' ' THEN
         #FUN-BB0001 add END
               LET g_sql = "SELECT rva10 FROM ",cl_get_target_table(l_azp01,'rva_file'),           #FUN-A50102
                           " WHERE rva01 = '",g_apb.apb04,"' "
         #FUN-BB0001 add START
            ELSE
               LET g_sql = " SELECT rvu08 FROM ",cl_get_target_table(l_azp01,'rvu_file'),
                           " WHERE rvu01 = '",g_apb.apb21,"' "
            END IF
         #FUN-BB0001 add END         
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql                #FUN-A50102
            CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql        #FUN-A50102
            PREPARE sel_rva10_pre FROM g_sql
            EXECUTE sel_rva10_pre INTO g_pmm02
            LET g_apa.apa17 = ' '
            LET g_pmn122 = ' '
            #No.MOD-CA0227 --Begin
            IF g_aza.aza26 = '2' THEN
               IF NOT cl_null(g_vendor) THEN
                  LET g_sql = "SELECT pmc04,pmc03,pmc24 FROM ",cl_get_target_table(l_azp01,'pmc_file'), #FUN-A50102
                              " WHERE pmc01='",g_vendor,"' "
                  CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                  CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql
                  PREPARE sel_pmc04_pre1 FROM g_sql
                  EXECUTE sel_pmc04_pre1 INTO g_vendor2,g_abbr,g_apa.apa18
              END IF
            END IF
         #No.MOD-CA0227 --End
         ELSE
            IF g_aza.aza26 = '2' THEN
               IF NOT cl_null(g_vendor) THEN

                # LET g_sql = "SELECT pmc04,pmc03,pmc24 FROM ",l_dbs CLIPPED,"pmc_file ",               #FUN-A50102 mark
                  LET g_sql = "SELECT pmc04,pmc03,pmc24 FROM ",cl_get_target_table(l_azp01,'pmc_file'), #FUN-A50102
                              " WHERE pmc01='",g_vendor,"' "
                  CALL cl_replace_sqldb(g_sql) RETURNING g_sql                #FUN-A50102
                  CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql        #FUN-A50102
                  PREPARE sel_pmc04_pre FROM g_sql
                  EXECUTE sel_pmc04_pre INTO g_vendor2,g_abbr,g_apa.apa18
                  LET g_sql = "SELECT pmm20,pmm21,pmm44,pmm02,pmm12,pmm21,pmm22,pmm25,pmn122 ",   
                            # "  FROM ",l_dbs CLIPPED,"pmm_file,",l_dbs CLIPPED,"pmn_file ",    #FUN-A50102 mark
                              "  FROM ",cl_get_target_table(l_azp01,'pmm_file'),",",            #FUN-A50102
                                        cl_get_target_table(l_azp01,'pmn_file'),                #FUN-A50102
                              " WHERE pmn01=pmm01 ",
                              "   AND pmn01='",g_apb.apb06,"' ",
                              "   AND pmn02='",g_apb.apb07,"' "
                  CALL cl_replace_sqldb(g_sql) RETURNING g_sql         #FUN-A50102 
                  CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-A50102
                  PREPARE sel_pmm20_pre FROM g_sql
                  EXECUTE sel_pmm20_pre INTO g_apa.apa11,g_apa.apa15,g_apa.apa17,
                                             g_pmm02,l_pmm12,l_pmm21,l_pmm22,l_pmm25,g_pmn122
                  IF l_pmm25<>'2' AND l_pmm25<>'6' AND (NOT cl_null(l_pmm25)) THEN
                     CONTINUE FOREACH
                  END IF
 
                # LET g_sql = "SELECT gen03 FROM ",l_dbs CLIPPED,"gen_file ",                #FUN-A50102 mark
                  LET g_sql = "SELECT gen03 FROM ",cl_get_target_table(l_azp01,'gen_file'),  #FUN-A50102  
                              " WHERE gen01 = '",l_pmm12,"' "
                  CALL cl_replace_sqldb(g_sql) RETURNING g_sql                                #FUN-A50102
                  CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql                        #FUN-A50102
                  PREPARE sel_gen03_pre FROM g_sql
                  EXECUTE sel_gen03_pre INTO g_apa.apa22
                # LET g_sql = "SELECT gec03,gec031,gec04 FROM ",l_dbs CLIPPED,"gec_file ",                #FUN-A50102 
                  LET g_sql = "SELECT gec03,gec031,gec04 FROM ",cl_get_target_table(l_azp01,'gec_file'),  #FUN-A50102 
                              " WHERE gec01='",g_rvw.rvw03,"'  AND gec011='1'"
                  CALL cl_replace_sqldb(g_sql) RETURNING g_sql                    #FUN-A50102 
                  CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql            #FUN-A50102 
                  PREPARE sel_gec03_pre FROM g_sql
                  EXECUTE sel_gec03_pre INTO g_apa.apa52,l_gec031,g_apa.apa16
#No.MOD-B40197 --begin
                # LET g_sql = "SELECT azi03,azi04 FROM ",l_dbs CLIPPED,"azi_file ",                   #FUN-A50102 mark
#                  LET g_sql = "SELECT azi03,azi04 FROM ",cl_get_target_table(l_azp01,'azi_file'),     #FUN-A50102  
#                              " WHERE azi01 = '",g_rvw.rvw11,"' "
#                  CALL cl_replace_sqldb(g_sql) RETURNING g_sql               #FUN-A50102 
#                  CALL cl_parse_qry_Sql(g_sql,l_azp01) RETURNING g_sql       #FUN-A50102 
#                  PREPARE sel_azi03_pre FROM g_sql
#                  EXECUTE sel_azi03_pre INTO t_azi03,t_azi04
#No.MOD-B40197 --end
               END IF
              
              LET l_year = NULL      #MOD-C90027
              LET l_month = NULL     #MOD-C90027
              #當月起始日與截止日
              #CALL s_azm(YEAR(g_rvv09),MONTH(g_rvv09)) RETURNING l_correct,l_bdate,l_edate   #CHI-9A0021 add #CHI-A70005 mark
              #CHI-A70005 add --start--
              IF g_aza.aza63 = 'Y' THEN
                 CALL s_azmm(YEAR(g_rvv09),MONTH(g_rvv09),g_apz.apz02p,g_apz.apz02b) RETURNING l_correct,l_bdate,l_edate
              ELSE   
                 CALL s_yp(g_rvv09) RETURNING l_year,l_month                                  #MOD-C90027
                #CALL s_azm(YEAR(g_rvv09),MONTH(g_rvv09)) RETURNING l_correct,l_bdate,l_edate #MOD-C90027 mark
                 CALL s_azm(l_year,l_month) RETURNING l_correct,l_bdate,l_edate               #MOD-C90027 
              END IF
              #CHI-A70005 add --end--
    
              #大陸版應增加卡關,判斷若入庫單當月沒先立暫估帳款,不可跨月產生帳款!
               IF YEAR(g_rvv09)  < YEAR(g_apa02) OR
                 (YEAR(g_rvv09)  = YEAR(g_apa02) AND 
                  MONTH(g_rvv09) < MONTH(g_apa02)) THEN
                  LET l_cnt = 0
                  SELECT COUNT(*) INTO l_cnt FROM apb_file,apa_file
                   WHERE apb21 = g_apb.apb21
                     AND apb22 = g_apb.apb22
                     AND apa01 = apb01
                     AND (apa00 = '16'  OR apa00 = '26') #暫估應付資料
                     AND apa41 = 'Y'   #已確認
                     AND apa42 = 'N'   #未作廢
                     AND apa02 BETWEEN l_bdate AND l_edate
                     AND apb37 = l_azp01    #FUN-A20006
                  IF l_cnt = 0 THEN
                     CALL s_errmsg('apb21',g_apb.apb21,'','aap-121',1)
                     LET g_success = 'N'
                     RETURN
                  END IF
               END IF 
            ELSE

               LET g_sql = "SELECT pmm12,pmm20,pmm21,pmm22,pmm44,pmm02,pmn122 ",        
                         # "  FROM ",l_dbs CLIPPED,"pmm_file,",l_dbs CLIPPED,"pmn_file ",                   #FUN-A50102 mark
                           "  FROM ",cl_get_target_table(l_azp01,'pmm_file'),",",                           #FUN-A50102
                                     cl_get_target_table(l_azp01,'pmn_file'),                               #FUN-A50102
                           " WHERE pmm01 = '",g_apb.apb06,"' ",
                           "   AND pmn01 = pmm01 ",
                           "   AND pmn02 = '",g_apb.apb07,"' " 
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102
               CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql          #FUN-A50102  
               PREPARE sel_pmm12_pre FROM g_sql
               EXECUTE sel_pmm12_pre INTO l_pmm12,g_apa.apa11,g_apa.apa15,
                                          l_pmm22,g_apa.apa17,g_pmm02,g_pmn122
             # LET g_sql = "SELECT gen03 FROM ",l_dbs CLIPPED,"gen_file ",                                  #FUN-A50102 mark
               LET g_sql = "SELECT gen03 FROM ",cl_get_target_table(l_azp01,'gen_file'),                    #FUN-A50102   
                           " WHERE gen01 = '",l_pmm12,"' "
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql                       #FUN-A50102
               CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql               #FUN-A50102
               PREPARE sel_gen03_pre1 FROM g_sql
               EXECUTE sel_gen03_pre1 INTO g_apa.apa22
               IF g_rvw.rvw03 IS NOT NULL THEN LET g_apa.apa15=g_rvw.rvw03 END IF   #MOD-B30183 add
             # LET g_sql = "SELECT gec03,gec031,gec04 FROM ",l_dbs CLIPPED,"gec_file ",                     #FUN-A50102 mark
               LET g_sql = "SELECT gec03,gec031,gec04 FROM ",cl_get_target_table(l_azp01,'gec_file'),       #FUN-A50102  
                           " WHERE gec01='",g_apa.apa15,"' AND gec011='1'"
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102
               CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql          #FUN-A50102
               PREPARE sel_gec03_pre1 FROM g_sql
               EXECUTE sel_gec03_pre1 INTO g_apa.apa52,l_gec031,g_apa.apa16
#No.MOD-B40197 --begin
             # LET g_sql = "SELECT azi03,azi04 FROM ",l_dbs CLIPPED,"azi_file ",                       #FUN-A50102 mark
               LET g_sql = "SELECT azi03,azi04 FROM ",cl_get_target_table(l_azp01,'azi_file'),         #FUN-A50102
                           " WHERE azi01 ='",l_pmm22,"' "
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102
               CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql          #FUN-A50102
               PREPARE sel_azi03_pre1 FROM g_sql
               EXECUTE sel_azi03_pre1 INTO t_azi03,t_azi04
#No.MOD-B40197 --end
            END IF
         END IF
         #FUN-C80022--add--str
         IF purchas_sw = 1 THEN 
            IF g_pmm02 = 'SUB' THEN 
               CONTINUE FOREACH
            END IF 
         ELSE
            IF g_pmm02 != 'SUB' THEN
               CONTINUE FOREACH
            END IF
         END IF  
         #FUN-C80022--add--end
         #No.MOD-B80335  --Begin
        #IF g_aza.aza26 = '2' THEN        #MOD-B90242 mark
                 LET g_sql = "SELECT gec03,gec031,gec04 FROM ",cl_get_target_table(l_azp01,'gec_file'),
                       " WHERE gec01='",g_rvw.rvw03,"'  AND gec011='1'"
           CALL cl_replace_sqldb(g_sql) RETURNING g_sql
           CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql 
           PREPARE sel_gec03_pre_1 FROM g_sql
           EXECUTE sel_gec03_pre_1 INTO g_apa.apa52,l_gec031,g_apa.apa16
        #END IF                           #No.MOD-B90242 mark
         #No.MOD-B80335  --End
    
        #若未能抓取付款條件，如倉退單未對應相應的采購單，則根據付款廠商抓取付款條件。
         IF cl_null(g_apa.apa11) THEN                                                                                          
          # LET g_sql = "SELECT pmc17 FROM ",l_dbs CLIPPED,"pmc_file ",                  #FUN-A50102 mark
            LET g_sql = "SELECT pmc17 FROM ",cl_get_target_table(l_azp01,'pmc_file'),    #FUN-A50102    
                        " WHERE pmc01='",g_vendor2,"' "
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql                                 #FUN-A50102
            CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql                         #FUN-A50102  
            PREPARE sel_pmc17_pre1 FROM g_sql
            EXECUTE sel_pmc17_pre1 INTO g_apa.apa11
            IF cl_null(g_apa.apa11) THEN               
              #CALL cl_err(g_vendor2,'aap-604',1)                                        #MOD-C70196 mark
               CALL s_errmsg('',g_vendor2,'','aap-604',1)                                #MOD-C70196 add
               LET g_success = 'N'
               RETURN
            END IF                                                                                                            
         END IF    
    
        #根據發票號碼對發票金額合計作判斷，若小于0則表示退貨，此筆資料放棄處理。
         IF NOT cl_null(g_rvw.rvw01) THEN
            LET l_rvw05f_s=0
            SELECT SUM(rvw05f) INTO l_rvw05f_s FROM rvw_file
             WHERE rvw01=g_rvw.rvw01
            IF cl_null(l_rvw05f_s) THEN
               LET l_rvw05f_s = 0
            END IF
            IF l_rvw05f_s < 0 THEN
               CONTINUE FOREACH
            END IF
         END IF

    
         #先檢查此入庫單是否有產生過暫估應付資料,
         #若有產生的話,必須是已確認的,若尚未確認,則不可產生應付資料
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM apb_file,apa_file
          WHERE apb21 = g_apb.apb21
            AND apb22 = g_apb.apb22
            AND apa01 = apb01
            AND (apa00 = '16'  OR apa00 = '26') #暫估應付資料  #No.TQC-7B0083 add 26 #No.TQC-7C0172 修正字段錯誤aapp00->apa00
            AND apa41 !='Y'   #未確認
            AND apa42 = 'N'   #未作廢   #MOD-860037 add
            AND apb37 = l_azp01    #FUN-9C0001
         IF l_cnt > 0 THEN
            CALL s_errmsg('','','','aap-118',1)   #No.MOD-930166
            LET g_success = 'N'                   #No.MOD-930166
            RETURN                                #No.MOD-930166
         END IF
    
         IF g_success = "N" THEN
            LET g_totsuccess = "N"
            LET g_success = "Y"
         END IF

       #------------------No.MOD-B80120---------start
         IF g_rva04 = 'Y' THEN
            CONTINUE FOREACH
         END IF
       #------------------No.MOD-B80120---------end

         IF g_aza.aza63 = 'Y' THEN
            LET g_apa.apa521 = l_gec031
         END IF
    
         IF g_aza.aza26 = '2' AND g_apb.apb29 MATCHES '[23]' THEN
            SELECT rvw02,rvw03,rvw04,rvw05,rvw06
              INTO g_rvw.rvw02,g_rvw.rvw03,g_rvw.rvw04,g_rvw.rvw05,g_rvw.rvw06
              FROM rvw_file
             WHERE rvw08 = g_apb.apb21 AND rvw09 = g_apb.apb22
               AND rvw01 = g_rvw.rvw01    #No.MOD-7B0150
         END IF
    
         LET g_inv_no = g_rvw.rvw01   #No.TQC-740142
    
         LET l_cnt = 0
        #因為有可能已經產生了入庫單的暫估應付資料(apa00='16'or'26')，
        #所以要加上apa00='11'or'21'的過濾條件
         SELECT COUNT(*) INTO l_cnt FROM apb_file,apa_file
          WHERE apb21 = g_apb.apb21
            AND apb22 = g_apb.apb22   #MOD-630123
            AND apa01 = apb01
            AND (apa00 = '11' OR apa00 = '21')
            AND apa01 <> g_apa.apa01   #CHI-740008
            AND apa08 = g_inv_no      #No.TQC-740142
            AND apb37 = l_azp01       #FUN-9C0001
     
         IF l_cnt > 0 THEN
            CONTINUE FOREACH
         END IF
 
         IF g_apa.apa13 IS NULL THEN
            LET g_apa.apa13=g_aza.aza17
         END IF
    
         LET g_chr = ' '
        #-MOD-B50037-mark-
        #SELECT apa41 INTO g_chr FROM apa_file
        # WHERE apa08 = g_inv_no AND apa00='11' AND apa75='N' #NO:3447
        #   AND apa44 <> '-'
        #IF g_chr = 'Y' THEN
        #   CONTINUE FOREACH
        #END IF
        #-MOD-B50037-add-
         LET l_n1 = 0      #MOD-B50160
         LET l_n2 = 0      #MOD-B50160
         IF cl_null(g_apa01_t) OR g_apa01_t <> g_apa.apa01 THEN #MOD-B50160
            LET l_year = YEAR(g_rvw.rvw02)USING '&&&&'   #CHI-820005   Add

            IF g_aza.aza26 = '1' THEN 
               SELECT COUNT(*) INTO l_n1 
                 FROM apa_file 
                WHERE apa08 = g_inv_no  
                  AND apa05 = g_vendor 
                  AND YEAR(apa09) = l_year   #CHI-820005 

               SELECT COUNT(*) INTO l_n2  
                 FROM apk_file,apa_file 
                WHERE apk03 = g_inv_no 
                  AND apk171 !='23' AND apk171 != '24'  
                  AND apk01 = apa01 AND apa05 = g_vendor 
                  AND YEAR(apk05) = l_year     #CHI-820005   Add
            ELSE
               SELECT COUNT(*) INTO l_n1 
                 FROM apa_file 
                WHERE apa08 = g_inv_no 
                  AND YEAR(apa09) = l_year   #CHI-820005 
           
               SELECT COUNT(*) INTO l_n2 
                 FROM apk_file 
                WHERE apk03 = g_inv_no 
                  AND apk171 !='23' AND apk171 != '24'   
                  AND YEAR(apk05) = l_year     #CHI-820005   Add
            END IF  
            IF cl_null(l_n1) THEN LET l_n1 = 0 END IF #MOD-B50160 
            IF cl_null(l_n2) THEN LET l_n2 = 0 END IF #MOD-B50160 
        
            IF (l_n1+l_n2) > 0 THEN
               LET g_success ='N'                             #MOD-C70196 add
               CALL s_errmsg('','','','aap-034',1)            #MOD-C70196 add
               CONTINUE FOREACH
            END IF
         END IF     #MOD-B50160
        #-MOD-B50037-end-
 
         IF g_pmm02 = 'TAP' OR g_pmm02 = 'TRI' THEN    #MOD-660122   #FUN-650164 

              LET g_sql = "SELECT poz01,poz18,poz19 ",
                        # "  FROM ",l_dbs CLIPPED,"pmm_file,",l_dbs CLIPPED,"poz_file",      #FUN-A50102 mark
                          "  FROM ",cl_get_target_table(l_azp01,'pmm_file'),",",             #FUN-A50102
                                    cl_get_target_table(l_azp01,'poz_file'),                 #FUN-A50102
                          " WHERE pmm904 = poz01 ",
                          "   AND pmm01  = '",g_apb.apb06,"' ",
                          "   AND pmm901 = 'Y' ",
                          "   AND pmm905 = 'Y'"
              CALL cl_replace_sqldb(g_sql) RETURNING g_sql                     #FUN-A50102
              CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql             #FUN-A50102  
              PREPARE sel_poz01_pre FROM g_sql
              EXECUTE sel_poz01_pre INTO l_poz01,l_poz18,l_poz19
    
               LET l_c = 0
              IF l_poz19 = 'Y'  AND g_plant=l_poz18 THEN    #已設立中斷點

                # LET g_sql = "SELECT COUNT(*) FROM ",l_dbs CLIPPED,"poy_file ",                 #FUN-A50102 mark
                  LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_azp01,'poy_file'),   #FUN-A50102
                              " WHERE poy01 = '",l_poz01,"' ",
                              "   AND poy04 = '",l_poz18,"' "
                  CALL cl_replace_sqldb(g_sql) RETURNING g_sql                #FUN-A50102
                  CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql        #FUN-A50102
                  PREPARE sel_cou_poy FROM g_sql
                  EXECUTE sel_cou_poy INTO l_c
                 #FUN-9C0001--mod--end
              END IF 
             IF l_c = 0 THEN
                CONTINUE FOREACH
             END IF   #MOD-7C0052 add
         END IF
    
    
         IF g_rvw.rvw02 IS NOT NULL THEN
            LET g_apa.apa09 = g_rvw.rvw02
         END IF
    
         IF g_rvw.rvw03 IS NOT NULL THEN
            LET g_apa.apa15 = g_rvw.rvw03
         END IF
    
         IF g_rvw.rvw04 IS NOT NULL THEN
            LET g_apa.apa16 = g_rvw.rvw04
         END IF
    
         IF g_rvw.rvw11 IS NOT NULL THEN
            LET g_apa.apa13 = g_rvw.rvw11
         END IF
    
#No.TQC-B80136 --begin
         #IF g_apz.apz69 ='Y' THEN      TQC-C50212  mark
           #CALL s_curr3(g_apa.apa13,g_apa.apa02,g_apz.apz33) RETURNING g_apa.apa14    #MOD-CB0174 mark
           #SELECT azi07 INTO t_azi07 FROM azi_file where azi01 = g_apa.apa13          #MOD-CB0174 mark
           #LET g_apa.apa14 = cl_digcut(g_apa.apa14,t_azi07)                           #MOD-CB0174 mark
         #TQC-C50212--mark--str--
         #ELSE  
            #IF g_rvw.rvw12 IS NOT NULL THEN      
                LET g_apa.apa14 = g_rvw.rvw12   #MOD-CB0174 remark
            #END IF 
         #END IF 
         #TQC-C50212--mark--end--
#No.TQC-B80136 --end    
         IF g_apa.apa16 IS NULL THEN
            LET g_apa.apa16 = 0
         END IF
 
         IF t_azi03 IS NULL THEN
            LET t_azi03 = 0
         END IF
    
         IF t_azi04 IS NULL THEN
            LET t_azi04 = 0
         END IF
    
         IF g_pmn122 IS NULL THEN
            LET g_pmn122 = ' '
         END IF    #No:8841
    
         IF g_apb.apb23 IS NULL OR g_rvv25='Y' THEN    #若為樣品則單價為0
            LET g_apb.apb23 = 0
            LET g_rvw.rvw17 = 0  #MOD-960142 
         END IF
    
         IF enter_account = "N" THEN
            IF g_aza.aza26 = '2' THEN 
               IF g_rvw.rvw17 = 0 THEN
                  CONTINUE FOREACH 
               END IF
            ELSE
               IF g_apb.apb23 = 0 THEN
                  CONTINUE FOREACH
               END IF
            END IF  #No.MOD-940335  
         END IF
    
         IF g_vendor2 IS NULL THEN
            LET g_vendor2 = g_vendor
         END IF
    

         IF (summary_sw = '3' AND (l_azp01 != t_azp01 OR t_azp01 IS NULL)) OR 
             ( summary_sw = '2' AND                      
           ((t_vendor IS NULL OR g_vendor != t_vendor) OR      #廠商   #No.TQC-810090 add "("
            #(t_pmm20 IS NULL OR g_apa.apa11 != t_pmm20) OR     #付款條件  #CHI-CC0038 mark
            ((t_pmm20 IS NULL AND g_aza.aza26 <> '2') OR (g_apa.apa11 != t_pmm20 AND g_aza.aza26 <> '2')) OR     #付款條件 #CHI-CC0038
            (t_pmm21 IS NULL OR g_apa.apa15 != t_pmm21) OR     #稅別
            (t_rvw11 IS NULL OR g_apa.apa13 != t_rvw11) OR     #幣別
            (t_rvw12 IS NULL OR g_apa.apa14 != t_rvw12))) OR   #匯率   #No.TQC-810090 add ")"
          #FUN-C80022 mark--str
          # ( purchas_sw = 'Y' AND #FUN-C70052 add
          #  ((g_pmm02 = 'SUB' AND g_pmm02 != g_pmm02_t)OR #FUN-C70052 add
          #   (g_pmm02_t = 'SUB' AND g_pmm02 != 'SUB'))) OR #FUN-C70052 add 
          #FUN-C80022--mark--end
            (summary_sw = '1' AND g_inv_no != t_inv_no ) THEN
            #No.MOD-D60145  --Begin
            CALL p110_apa05('')
            IF NOT cl_null(g_errno) THEN
               LET g_success = 'N'
               CALL s_errmsg("apa05",g_vendor,'',g_errno,1)
               CONTINUE FOREACH
            END IF
            #No.MOD-D60145  --End
            IF g_apa.apa01 IS NOT NULL THEN
               CALL p110_upd_apa31()
               CALL p110_upd_apa57(t_azp01)   #FUN-9C0001 add 參數t_azp03
               CALL p110_upd_apa66()   #CHI-910031 add
               IF prepaid_off_sw = 'Y' THEN # 若要自動將預付款依 P/O# 帶出沖銷
                  CALL p110_prepaid_off()
               END IF
              #CALL p110_upd_apa57_2()         #MOD-A20035 add  #MOD-A90121 mark
            END IF
    
            LET g_apa.apa72=g_apa.apa14
            CALL p110_comp_oox(g_apa.apa01) RETURNING g_net
            LET g_apa.apa73 = g_apa.apa34 - g_apa.apa35 + g_net
    
            CALL p110_ins_apa()                  # Insert Head
            #FUN-C70052--add--str
           #LET g_pmm02_t = g_pmm02#FUN-C80022 mark
            #FUN-C70052--add--end
           #-MOD-B50160-add-
            IF cl_null(g_apa01_t) OR g_apa01_t <> g_apa.apa01 THEN
               LET g_apa01_t = g_apa.apa01
            END IF
           #-MOD-B50160-end-

            IF g_success = 'N' THEN
               CONTINUE FOREACH
            END IF
            LET l_apa100_t = g_apa.apa100
            LET l_apa01_t = g_apa.apa01
         ELSE
            IF l_azp01 <> l_apa100_t THEN
               UPDATE apa_file SET apa100 = ''
                WHERE apa01 = l_apa01_t
               IF SQLCA.sqlcode THEN
                 #CALL cl_err3("upd","apa_file",g_apa.apa01,g_apa.apa100,SQLCA.sqlcode,"","",1)    #MOD-C70196 mark
                  CALL s_errmsg('apa100',g_apa.apa100,'',SQLCA.sqlcode,1)                          #MOD-C70196 add
                  LET g_success ='N'
               END IF
            END IF
         END IF
    
         LET t_vendor = g_vendor
         LET t_inv_no = g_inv_no
         LET t_pmn122 = g_pmn122
         LET t_azp01 = l_azp01     #FUN-9C0001 
         LET t_azp03 = l_dbs       #FUN-9C0001
         LET t_pmm20  = g_apa.apa11
         LET t_pmm21  = g_apa.apa15
         LET t_rvw11  = g_apa.apa13
         LET t_rvw12  = g_apa.apa14
    
         IF cl_null(t_pmn122)  THEN
            LET t_pmn122=' '
         END IF
    
        #IF g_aza.aza26 = '2' THEN               #MOD-C60155 mark
         IF g_apb.apb29 MATCHES '[13]' THEN
            CALL p110_ins_apb()
         END IF
        #ELSE                                    #MOD-C60155 mark
        #   IF g_apb.apb29 MATCHES '[13]' THEN   #MOD-C60155 mark
        #      CALL p110_ins_apb()               #MOD-C60155 mark
        #   END IF                               #MOD-C60155 mark
        #END IF                                  #MOD-C60155 mark
    
         IF summary_sw = '2' OR g_apa.apa00 MATCHES '1*' THEN
            IF g_apa.apa01 IS NOT NULL THEN   #MOD-850126 add
             # IF (NOT cl_null(g_apb.apb04)) AND    #MOD-920117 add  #FUN-B50019
             #    (NOT cl_null(g_apb.apb05)) THEN   #MOD-920117 add  #FUN-B50019
                  CALL p110_ins_apk()
             # END IF                               #MOD-920117 add  #FUN-B50019
            END IF                            #MOD-850126 add
         END IF
    
         IF g_success = 'N' THEN
 
            CONTINUE FOREACH
         END IF
    
         LET t_apb04 = g_apb.apb04
         LET t_apb05 = g_apb.apb05

        #No.FUN-CB0048 ---start--- Add
         IF cl_null(g_apa01_s) THEN                        #第一筆,直接更新rvw18
            LET g_apa01_s = g_apa.apa01
            UPDATE rvw_file SET rvw18 = g_apa01_s
             WHERE rvw01 = g_rvw.rvw01
            LET g_apa34 = g_apa.apa34
            LET g_rvw01 = g_rvw.rvw01
         ELSE
            IF g_apa01_s != g_apa.apa01 THEN               #第N筆
               IF g_rvw.rvw01 != g_rvw01 THEN            #發票編號與舊值不一致,直接更新rvw18
                  LET g_apa01_s = g_apa.apa01
                  UPDATE rvw_file SET rvw18 = g_apa01_s
                   WHERE rvw01 = g_rvw.rvw01
                  LET g_apa34 = g_apa.apa34
                  LET g_rvw01 = g_rvw.rvw01
               ELSE
                  IF g_apa34 < g_apa.apa34 THEN          #發票編號一致,當前筆金額大於上一筆,更新rvw18
                     LET g_apa01_s = g_apa.apa01
                     UPDATE rvw_file SET rvw18 = g_apa01_s
                      WHERE rvw01 = g_rvw.rvw01
                     LET g_apa34 = g_apa.apa34
                     LET g_rvw01 = g_rvw.rvw01
                  END IF
               END IF
            END IF
         END IF
        #No.FUN-CB0048 ---end  --- Add

      END FOREACH
   END FOREACH     #FUN-9C0001 
   #IF g_totsuccess = 'N' THEN        #MOD-AA0003 mark
   #   LET g_success = 'N'            #MOD-AA0003 mark
   #END IF                            #MOD-AA0003 mark
 
   IF g_apa.apa01 IS NOT NULL THEN   #MOD-850126 add
      CALL p110_upd_apa31()          #TQC-790138 add
   END IF                            #MOD-850126 add
 
  #修改由于rvw10可改引起的同一張帳款編號下,檔案apb_file下，異動單號+項次的重復
   IF g_aza.aza26 = '2' THEN    #MOD-5B0060
   END IF    #MOD-5B0060
 
   SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_apa.apa13  #No.TQC-6B0066
 
   IF g_apa.apa01 IS NOT NULL THEN    #TQC-6C0032
      CALL p110_upd_apa57(l_azp01)   #luttb
      CALL p110_upd_apa66()   #CHI-910031 add
   END IF   #TQC-6C0032
 
   IF g_apa.apa01 IS NOT NULL THEN    #MOD-750101
      IF prepaid_off_sw = 'Y' THEN # 若要自動將預付款依 P/O# 帶出沖銷
         CALL p110_prepaid_off()
      END IF
     #CALL p110_upd_apa57_2()              #MOD-A20035 add   #MOD-A90121 mark
   END IF   #MOD-750101
 
   FOR l_n = 1 TO apa_nw.getLength()
       CALL p110_ins_apc(apa_nw[l_n].apa01)
   END FOR 
 
   IF begin_no IS NOT NULL THEN
      DISPLAY begin_no TO start_no
      DISPLAY end_no TO end_no
   ELSE
      LET g_success = 'N'   #FUN-560070
      CALL s_errmsg('apa01',begin_no,'','aap-129',1)
   END IF
  #-MOD-AA0003-add-
   IF g_totsuccess = 'N' THEN
      LET g_success = 'N'
   END IF
  #-MOD-AA0003-end-
END FUNCTION
 
FUNCTION p110_upd_apa31()
   DEFINE amt1,amt2,amt3,amt4      LIKE type_file.num20_6 #No.FUN-690028 DEC(20,6)  #FUN-4B0079
   DEFINE l_apa13                  LIKE apa_file.apa13   #MOD-850005
 
   SELECT SUM(apk08),SUM(apk07) INTO amt1,amt2
     FROM apk_file
    WHERE apk01 = g_apa.apa01
      AND apk171 = '23'
 
   IF amt1 IS NULL THEN
      LET amt1 = 0
      LET amt2 = 0
   END IF
 
   SELECT SUM(apk08),SUM(apk07) INTO amt3,amt4
     FROM apk_file
    WHERE apk01 = g_apa.apa01
      AND apk171 <> '23'
 
   IF amt3 IS NULL THEN
      LET amt3 = 0
      LET amt4 = 0
   END IF
 
   LET g_apa.apa31f = amt3 - amt1
   LET g_apa.apa31 = amt3 - amt1
   LET g_apa.apa32f = amt4 - amt2
   LET g_apa.apa32 = amt4 - amt2
 

   SELECT SUM(apk08f),SUM(apk07f) INTO g_apa.apa31f,g_apa.apa32f
     FROM apk_file
    WHERE apk01 = g_apa.apa01
 
   IF cl_null(g_apa.apa31f) THEN
      LET g_apa.apa31f = 0
   END IF

   IF cl_null(g_apa.apa32f) THEN
      LET g_apa.apa32f = 0
   END IF
 
   SELECT apa13 INTO l_apa13 FROM apa_file WHERE apa01=g_apa.apa01   
   SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=l_apa13
   
   LET g_apa.apa31 = cl_digcut(g_apa.apa31,g_azi04)
   LET g_apa.apa32 = cl_digcut(g_apa.apa32,g_azi04)
   LET g_apa.apa31f= cl_digcut(g_apa.apa31f,t_azi04)   #No.CHI-6A0004 l_azi-->t_azi
   LET g_apa.apa32f= cl_digcut(g_apa.apa32f,t_azi04)   #No.CHI-6A0004 l_azi-->t_azi
 
   LET g_apa.apa34f=g_apa.apa31f+g_apa.apa32f
   LET g_apa.apa34 =g_apa.apa31 +g_apa.apa32
   LET g_apa.apa73=g_apa.apa34
 
   UPDATE apa_file SET apa31f = g_apa.apa31f,
                       apa31 = g_apa.apa31,
                       apa32f = g_apa.apa32f,
                       apa32 = g_apa.apa32,
                       apa34f = g_apa.apa34f,
                       apa34 = g_apa.apa34,
                       apa73 = g_apa.apa73                         #A059
    WHERE apa01 = g_apa.apa01
   IF STATUS OR SQLCA.sqlerrd[3]=0 THEN

      CALL s_errmsg("apa01",g_apa.apa01,"update apa_file",SQLCA.sqlcode,0)
   END IF
 
END FUNCTION
 
FUNCTION p110_upd_apa57(m_azp01)   #FUN-9C0001 add l_azp03
 DEFINE l_trtype  LIKE apy_file.apyslip #No.FUN-690028 VARCHAR(5) #FUN-5B0089 add
 DEFINE l_apydmy3 LIKE apy_file.apydmy3 #FUN-5B0089 add
 DEFINE l_azp03   LIKE type_file.chr21  #FUN-9C0001 
 DEFINE m_azp01   LIKE azp_file.azp01   #FUN-9C0001
 DEFINE li_azp01   LIKE azp_file.azp01   #FUN-A20006

#FUN-A20006--add--str--
 LET g_sql = "SELECT DISTINCT apb37 FROM apb_file ",
             " WHERE apb01 = '",g_apa.apa01,"'"
 PREPARE sel_apb37_pre FROM g_sql
 DECLARE sel_apb37_cur CURSOR FOR sel_apb37_pre
 FOREACH sel_apb37_cur INTO li_azp01
#FUN-A20006--add--end
  #IF cl_null(m_azp01) THEN      #FUN-A20006
   IF cl_null(li_azp01) THEN      #FUN-A20006
      LET l_azp03 = NULL
   ELSE
     #LET g_plant_new = m_azp01  #FUN-A20006
      LET g_plant_new = li_azp01  #FUN-A20006
      CALL s_gettrandbs()
      LET l_azp03 = g_dbs_tra 
   END IF 

  LET g_sql = "SELECT SUM(apb24),SUM(apb10) FROM apb_file,",   #FUN-A20006
            #   l_azp03 CLIPPED,"rvv_file,",l_azp03 CLIPPED,"rvu_file ",   #FUN-A50102 mark
                cl_get_target_table(li_azp01,'rvv_file'),",",              #FUN-A50102
                cl_get_target_table(li_azp01,'rvu_file'),                  #FUN-A50102            
               " WHERE apb01 = '",g_apa.apa01,"' ",
               "   AND rvu01 = rvv01 AND rvuconf = 'Y' AND apb21 = rvv01 ",
               "   AND apb37 = '",li_azp01,"' ",   #FUN-A20006
               "   AND apb22 = rvv02 AND rvv03 = '1'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102
   CALL cl_parse_qry_sql(g_sql,li_azp01) RETURNING g_sql     #FUN-A50102 
   PREPARE sel_apb24_pre FROM g_sql
   EXECUTE sel_apb24_pre INTO f_amt1,g_amt1

 
   IF f_amt1 IS NULL THEN
      LET f_amt1 = 0
   END IF
 
   IF g_amt1 IS NULL THEN
      LET g_amt1 = 0
   END IF
 

   LET g_sql = "SELECT SUM(apb24),SUM(apb10) FROM apb_file,",
             #  l_azp03 CLIPPED,"rvv_file,",l_azp03 CLIPPED,"rvu_file ", #FUN-A50102 mark
                cl_get_target_table(li_azp01,'rvv_file'),",",            #FUN-A50102
                cl_get_target_table(li_azp01,'rvu_file'),                #FUN-A50102         
               " WHERE apb01 = '",g_apa.apa01,"' ",
               "   AND rvu01 = rvv01 AND rvuconf = 'Y' AND apb21 = rvv01 ",
               "   AND apb37 = '",li_azp01,"' ",
               "   AND apb22 = rvv02 AND rvv03 = '3' "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql          #FUN-A50102
   CALL cl_parse_qry_sql(g_sql,li_azp01) RETURNING g_sql #FUN-A50102
   PREPARE sel_apb24_pre1 FROM g_sql
   EXECUTE sel_apb24_pre1 INTO f_amt2,g_amt2
 
   IF f_amt2 IS NULL THEN
      LET f_amt2 = 0
   END IF
 
   IF g_amt2 IS NULL THEN
      LET g_amt2 = 0
   END IF
 

   LET g_apa.apa57f = f_amt1 + f_amt2
   LET g_apa.apa57 = g_amt1 + g_amt2
 
   LET g_apa.apa33f = g_apa.apa31f - g_apa.apa57f
   LET g_apa.apa33 = g_apa.apa31 - g_apa.apa57
 
   IF g_apa.apa31f <> g_apa.apa57f + g_apa.apa60f OR
      g_apa.apa31 <> g_apa.apa57 + g_apa.apa60  OR g_apa.apa31 = 0 THEN
      LET g_apa.apa56 = '1'
      LET g_apa.apa19 = g_apz.apz12
      LET g_apa.apa20 = g_apa.apa31f + g_apa.apa32f
   END IF

   #TQC-AB0200--------ADD----STR--------------
   IF g_apa.apa33 = 0 THEN
      LET g_apa.apa56 = '0'
   END IF
   #TQC-AB0200--------ADD----END-------------
 
  #FUN-A20006--mod-str--
  #UPDATE apa_file SET apa57f = g_apa.apa57f,
  #                    apa57  = g_apa.apa57,
  #                    apa33f = g_apa.apa33f,
  #                    apa33  = g_apa.apa33,
  #                    apa56  = g_apa.apa56,
  #                    apa19  = g_apa.apa19,
  #                    apa20  = g_apa.apa20
   UPDATE apa_file SET apa57f = apa57f+g_apa.apa57f,
                       apa57  = apa57+g_apa.apa57,
                       apa33f = apa33f+g_apa.apa33f,
                       apa33  = apa33+g_apa.apa33,
                      #apa56  = apa56+g_apa.apa56,       #MOD-C50181 mark
                      #apa19  = apa19+g_apa.apa19,       #MOD-C50181 mark
                       apa56  = g_apa.apa56,             #MOD-C50181 add
                       apa19  = g_apa.apa19,             #MOD-C50181 add
                       apa20  = apa20+g_apa.apa20
  #FUN-A20006--mod--end
    WHERE apa01 = g_apa.apa01
   IF STATUS OR SQLCA.sqlerrd[3]=0 THEN

      LET g_showmsg=g_apa.apa57f,"/",g_apa.apa57,"/",g_apa.apa33f,"/",
                    g_apa.apa33,"/",g_apa.apa56,"/",g_apa.apa19,"/",
                    g_apa.apa20
      CALL s_errmsg("apa57f,apa57,apa33f,apa33,apa56,apa19,apa20",g_showmsg,
                    "update apa_file",SQLCA.sqlcode,0)
   END IF
 END FOREACH #FUN-A20006 
   #產生分錄需抓api_file,所以要在產生分錄前insert api_file
   CALL p110_ins_api()   #FUN-680110 add
 
 #MOD-A20035---mark---start---
 #  LET l_trtype = trtype[1,g_doc_len]
 #  SELECT apydmy3 INTO l_apydmy3 FROM apy_file WHERE apyslip = l_trtype
 #  IF SQLCA.sqlcode THEN
 #     LET g_success = 'N'
 #     CALL s_errmsg("apyslip",l_trtype,"sel apy:",SQLCA.sqlcode,1)
 #  END IF
 #  IF l_apydmy3 = 'Y' THEN   #是否拋轉傳票
 #     CALL t110_g_gl(g_apa.apa00,g_apa.apa01,'0',m_azp01)  #No.FUN-680029 新增參數'0'  #FUN-9C0001 add m_azp01
 #     IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
 #        CALL t110_g_gl(g_apa.apa00,g_apa.apa01,'1',m_azp01)  #FUN-9C0001 add m_azp01
 #     END IF
 #  END IF
 #MOD-A20035---mark---end---
END FUNCTION

#MOD-A20035---add---start---
FUNCTION p110_upd_apa57_2()
 DEFINE l_trtype  LIKE apy_file.apyslip 
 DEFINE l_apydmy3 LIKE apy_file.apydmy3 

    LET l_trtype = trtype[1,g_doc_len]
    SELECT apydmy3 INTO l_apydmy3 FROM apy_file WHERE apyslip = l_trtype
    IF SQLCA.sqlcode THEN
       LET g_success = 'N'
       CALL s_errmsg("apyslip",l_trtype,"sel apy:",SQLCA.sqlcode,1)
    END IF
    IF l_apydmy3 = 'Y' THEN   #是否拋轉傳票
       CALL t110_g_gl(g_apa.apa00,g_apa.apa01,'0',l_azp01)  #No.FUN-680029 新增參數'0'  #FUN-9C0001 add l_azp01
       IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
          CALL t110_g_gl(g_apa.apa00,g_apa.apa01,'1',l_azp01)  #FUN-9C0001 add l_azp01
       END IF
    END IF
END FUNCTION
#MOD-A20035---add---end---

FUNCTION p110_upd_apa66()
   LET g_cnt = 0 
   SELECT COUNT(DISTINCT apb35) INTO g_cnt FROM apb_file
    WHERE apb01 = g_apa.apa01
   IF cl_null(g_cnt) THEN LET g_cnt = 0 END IF
   IF g_cnt = 1 THEN   #表示單身只有一個專案編號,可回寫單頭專案編號欄位
      SELECT DISTINCT apb35 INTO g_apa.apa66 
        FROM apb_file
       WHERE apb01 = g_apa.apa01
 
      UPDATE apa_file SET apa66 = g_apa.apa66
                    WHERE apa01 = g_apa.apa01
      IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
         LET g_success = 'N'
         CALL s_errmsg("apa01",g_apa.apa01,"upd apa:",SQLCA.sqlcode,1)
      END IF
   END IF
END FUNCTION
 
FUNCTION p110_ins_apa()
   DEFINE li_result LIKE type_file.num5    #No.FUN-690028 SMALLINT              #No.FUN-560002
   DEFINE l_trtype  LIKE apy_file.apyslip  #No;FUN-690028 VARCHAR(5)               #MOD-5C0107
   DEFINE l_rvv40   LIKE rvv_file.rvv40    #FUN-680110 add
   DEFINE l_sql STRING   #MOD-6C0029
 

   IF summary_sw = '1' THEN

      LET l_sql = "SELECT * FROM apa_file ",
                  "WHERE apa08 = '",g_inv_no,"' AND apa05='",g_vendor,"'",
                  " AND apa00='11' AND apa13='",g_apa.apa13,"'",
                  " AND apa11 = '",g_apa.apa11,"' AND apa41='N'",
                  " AND apa42='N'",
                  " AND apa63='0'"
   #ELSE  #FUN-9C0001
   END IF #FUN-9C0001
   
   IF summary_sw = '2' THEN   #FUN-9C0001
      LET l_sql = "SELECT * FROM apa_file ",
                  " WHERE apa02 = '",g_apa02,"' AND apa05='",g_vendor,"'",
                  "   AND apa00='11' AND apa08 = 'MISC'",
                  "   AND apa13='",g_apa.apa13,"' AND apa11 = '",g_apa.apa11,"'",
                  "   AND apa41='N' AND apa42='N' AND apa63='0'",
                  "   AND apa14 = '",g_apa.apa14,"' AND apa15 = '",g_apa.apa15,"'",
                  "   AND apa01[1,3] = '",trtype,"' AND apa21 = '",g_apa.apa21,"'",         #MOD-C30007 add
                  "   AND apa36 = '",g_apa.apa36,"' AND apa02 = '",g_apa.apa02,"'",         #MOD-C30007 add
                  "   AND apa22 = '",g_apa.apa22,"'"                                        #MOD-C30007 add
   END IF

   #FUN-9C0001--add--str--
   IF summary_sw = '3' THEN
      LET l_sql = "SELECT * FROM apa_file ",
                  "WHERE apa02 = '",g_apa02,"' AND apa05='",g_vendor,"'",
                  " AND apa00='11' AND apa08 = 'MISC'",
                  " AND apa13='",g_apa.apa13,"' AND apa11 = '",g_apa.apa11,"'",
                  " AND apa41='N' AND apa42='N' AND apa63='0'",
                  " AND apa100 = '",l_azp01,"' "
   END IF
   #FUN-9C0001--add--end
   PREPARE p110_p FROM l_sql
   DECLARE p110_c SCROLL CURSOR FOR p110_p
   OPEN p110_c
   FETCH FIRST p110_c INTO g_apa.*
  #IF NOT cl_null(g_apa.apa01) THEN LET g_apa01=g_apa.apa01 END IF   #CHI-C40006 mark #TQC-BA0092 add
   
  #-MOD-BA0043-mark-
  #LET g_apa.apa02 = g_apa02
  #IF NOT cl_null(g_apa21) THEN #MOD-990198   
  #   LET g_apa.apa21 = g_apa21       #96/07/17 modify   #MOD-6C0029
  #ELSE                                                                                                                             
  #                                                                                        
  # # LET g_sql = "SELECT pmm12 FROM ",l_dbs CLIPPED,"pmm_file,",l_dbs CLIPPED,"pmn_file ",        #FUN-A50102 mark
  #   LET g_sql = "SELECT pmm12 FROM ",cl_get_target_table(l_azp01,'pmm_file'),",",                #FUN-A50102
  #                                    cl_get_target_table(l_azp01,'pmm_file'),                    #FUN-A50102 
  #               " WHERE pmn01=pmm01 ",
  #               "   AND pmn01='",g_apb.apb06,"' ",
  #               "   AND pmn02='",g_apb.apb07,"' "
  #   CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
  #   CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql     #FUN-A50102
  #   PREPARE sel_pmm12_pre1 FROM g_sql
  #   EXECUTE sel_pmm12_pre1 INTO g_apa.apa21
  #END IF                
  #IF NOT cl_null(g_apa22) THEN                                                                                                     
  #   LET g_apa.apa22 = g_apa22
  #ELSE                                                                                                                             
  #                                                                                        
  # # LET g_sql = "SELECT gen03 FROM ",l_dbs CLIPPED,"gen_file ",               #FUN-A50102 mark
  #   LET g_sql = "SELECT gen03 FROM ",cl_get_target_table(l_azp01,'gen_file'), #FUN-A50102 
  #               " WHERE gen01 = (SELECT pmm12 ",
  #             # "                  FROM ",l_dbs CLIPPED,"pmm_file,",l_dbs CLIPPED,"pmn_file ",                                  #FUN-A50102 mark
  #               "                  FROM ",cl_get_target_table(l_azp01,'pmm_file'),",",cl_get_target_table(l_azp01,'pmn_file'),  #FUN-A50102   
  #               "                 WHERE pmn01=pmm01 ",
  #               "                   AND pmn01='",g_apb.apb06,"' ",
  #               "                   AND pmn02='",g_apb.apb07,"' )"
  #   CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
  #   CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql     #FUN-A50102
  #   PREPARE sel_gen03_pre2 FROM g_sql
  #   EXECUTE sel_gen03_pre2 INTO g_apa.apa22
  #END IF
 
  #LET g_apa.apa36 = g_apa36
 
  #IF g_apa.apa19 = g_apz.apz12 THEN
  #   LET g_apa.apa56 = '0'
  #   LET g_apa.apa19 = NULL
  #   LET g_apa.apa20 = 0
  #END IF
  #-MOD-BA0043-end-
   IF g_apa01 IS NULL OR (g_apa01 IS NOT NULL AND SQLCA.SQLCODE != 0)
      OR (g_apa01 IS NOT NULL AND g_apa01 != g_apa.apa01)              #MOD-A10175 add
     #FUN-C80022--mark--str
     #OR ( purchas_sw = 'Y' AND #FUN-C70052 add
     #       ((g_pmm02 = 'SUB' AND g_pmm02 != g_pmm02_t)OR #FUN-C70052 add
     #        (g_pmm02_t = 'SUB' AND g_pmm02 != 'SUB')))  #FUN-C70052 add
     #FUN-C80022--mark--end
      OR g_apa.apaprno > 0 THEN                                        #MOD-C40003 add
      LET g_apa.apa00 = '11'
      LET g_apa.apa02 = g_apa02    #MOD-BA0043
      LET g_apa.apa05 = g_vendor
      #CHI-A90002 add --start--
      CALL p110_apa05('')
      IF NOT cl_null(g_errno) THEN
         LET g_success = 'N'
         CALL s_errmsg("apa05",g_apa.apa05,'',g_errno,1)
         RETURN
      END IF
      #CHI-A90002 add --end--
      LET g_apa.apa06 = g_vendor2

    # LET g_sql = "SELECT pmc03 FROM ",l_dbs CLIPPED,"pmc_file ",               #FUN-A50102 mark
      LET g_sql = "SELECT pmc03 FROM ",cl_get_target_table(l_azp01,'pmc_file'), #FUN-A50102 
                  " WHERE pmc01='",g_apa.apa06,"' "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql         #FUN-A50102
      CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-A50102
      PREPARE sel_pmc03_pre FROM g_sql
      EXECUTE sel_pmc03_pre INTO g_apa.apa07
 
      IF summary_sw = '1' THEN
         LET g_apa.apa08 = g_inv_no
      ELSE
         LET g_apa.apa08 = 'MISC'
      END IF
 
      IF g_apa.apa07 IS NULL THEN
         LET g_apa.apa07 = 0
      END IF
 
      IF g_apa.apa08 IS NULL THEN
         LET g_apa.apa08 = 0
      END IF
 
      CALL s_paydate('a','',g_apa.apa09,g_apa.apa02,g_apa.apa11,g_apa.apa06)
           RETURNING g_apa.apa12,g_apa.apa64,g_apa.apa24
 
      IF cl_null(g_apa.apa14) THEN
         LET g_apa.apa14 = 1
         CALL s_curr3(g_apa.apa13,g_apa.apa02,g_apz.apz33) RETURNING g_apa.apa14 #FUN-640022
         SELECT azi07 INTO t_azi07 FROM azi_file where azi01 = g_apa.apa13   #MOD-940356
         LET g_apa.apa14 = cl_digcut(g_apa.apa14,t_azi07)                    #MOD-940356               
      END IF
 
      LET g_apa.apa72 = g_apa.apa14
 

    # LET g_sql = "SELECT gec06,gec08 FROM ",l_dbs CLIPPED,"gec_file ",               #FUN-A50102 mark
      LET g_sql = "SELECT gec06,gec08 FROM ",cl_get_target_table(l_azp01,'gec_file'), #FUN-A50102
                  " WHERE gec01 = '",g_apa.apa15,"' ",
                  "   AND gec011 = '1' "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql         #FUN-A50102
      CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-A50102
      PREPARE sel_gec06_pre FROM g_sql
      EXECUTE sel_gec06_pre INTO g_apa.apa172,g_apa.apa171

      IF cl_null(g_apa.apa17) THEN    #MOD-B90143 ADD
         LET g_apa.apa17 = '1'
      END IF                          #MOD-B90143 ADD 

      IF cl_null(g_apa.apa171) THEN
         LET g_apa.apa171 = '21'
      END IF
 
      IF cl_null(g_apa.apa172) THEN
         CASE
            WHEN g_apa.apa16 = 0
               LET g_apa.apa172 = '2'
            WHEN g_apa.apa16 = 100
               LET g_apa.apa172 = '3'
            OTHERWISE
               LET g_apa.apa172 = '1'
         END CASE
      END IF
 
      IF g_apa.apa19 = g_apz.apz12 THEN LET g_apa.apa19 = NULL END IF   #MOD-BA0043
      LET g_apa.apa20 = 0
     #-MOD-BA0043-add-
      IF NOT cl_null(g_apa21) THEN 
         LET g_apa.apa21 = g_apa21 
      ELSE                                                                                                                             
         LET g_sql = "SELECT pmm12 FROM ",cl_get_target_table(l_azp01,'pmm_file'),",",                #FUN-A50102
                                          cl_get_target_table(l_azp01,'pmn_file'),                    #FUN-A50102 
                     " WHERE pmn01=pmm01 ",
                     "   AND pmn01='",g_apb.apb06,"' ",
                     "   AND pmn02='",g_apb.apb07,"' "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql             
         CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql    
         PREPARE sel_pmm12_pre1 FROM g_sql
         EXECUTE sel_pmm12_pre1 INTO g_apa.apa21
      END IF                
      IF NOT cl_null(g_apa22) THEN                                                                                                     
         LET g_apa.apa22 = g_apa22
      ELSE                                                                                                                             
         LET g_sql = "SELECT gen03 FROM ",cl_get_target_table(l_azp01,'gen_file'), 
                     " WHERE gen01 = (SELECT pmm12 ",
                     "                  FROM ",cl_get_target_table(l_azp01,'pmm_file'),",",
                                               cl_get_target_table(l_azp01,'pmn_file'),  
                     "                 WHERE pmn01=pmm01 ",
                     "                   AND pmn01='",g_apb.apb06,"' ",
                     "                   AND pmn02='",g_apb.apb07,"' )"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql     
         CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql   
         PREPARE sel_gen03_pre2 FROM g_sql
         EXECUTE sel_gen03_pre2 INTO g_apa.apa22
      END IF
     #-MOD-BA0043-end-
      LET g_apa.apa31f = 0
      LET g_apa.apa31 = 0
      LET g_apa.apa32f = 0
      LET g_apa.apa32 = 0
      LET g_apa.apa33f = 0
      LET g_apa.apa33 = 0
      LET g_apa.apa34f = 0
      LET g_apa.apa34 = 0
 
      LET g_apa.apa73=0
 
      LET g_apa.apa35f = 0
      LET g_apa.apa35 = 0
      LET g_apa.apa36 = g_apa36   #MOD-BA0043
      LET g_apa.apa37f = 0    #MOD-B20088
      LET g_apa.apa37 = 0     #MOD-B20088
      LET g_apa.apa65f = 0
      LET g_apa.apa65 = 0
      LET g_apa.apa41 = 'N'
      LET g_apa.apa42 = 'N'
      LET g_apa.apa46 = g_rvw.rvw07       #yinhy130716
 
      IF g_flag2 = 'Y' THEN               #MOD-B10080
         LET g_apa.apa51 = g_apa51_o
         LET g_apa.apa54 = g_apa54        #MOD-B10080
         IF g_aza.aza63 = 'Y' THEN   #是否使用多帳套功能
            LET g_apa.apa511 = g_apa511_o
            LET g_apa.apa541 = g_apa541   #MOD-B10080
         END IF
      END IF                              #MOD-B10080
 
      LET g_apa.apa55 = '1'
      LET g_apa.apa56 = '0'
      LET g_apa.apa57f= 0
      LET g_apa.apa57 = 0
      LET g_apa.apa60f= 0
      LET g_apa.apa60 = 0
      LET g_apa.apa61f= 0
      LET g_apa.apa61 = 0
      LET g_apa.apa63 = '0'               #No.MOD-520104
      LET g_apa.apa74 = 'N'
      LET g_apa.apa75 = 'N'
      LET g_apa.apa100 = source           #No.TQC-740072
      LET g_apa.apaacti = 'Y'
      LET g_apa.apainpd = g_today
      LET g_apa.apauser = g_user
      LET g_apa.apagrup = g_grup
      LET g_apa.apadate = g_today
      LET g_apa.apa930=s_costcenter_stock_apa(g_apa.apa22,g_rvv930,g_apa.apa51)  #FUN-670064
     LET l_trtype = trtype[1,g_doc_len]   #MOD-5C0107
     SELECT apyapr INTO g_apa.apamksg FROM apy_file
        WHERE apyslip = l_trtype #MOD-5C0107
      CALL s_auto_assign_no("aap",trtype,g_apa.apa02,g_apa.apa00,"","","","","")
        RETURNING li_result,g_apa.apa01
      IF NOT li_result THEN
         LET g_success = 'N'
         CALL s_errmsg("apa01",g_apa.apa01,"auto_assign_no fail",'abm-621',1)
         RETURN
      END IF

    # LET g_sql = "SELECT rvu99 FROM ",l_dbs CLIPPED,"rvu_file ",               #FUN-A50102 mark
      LET g_sql = "SELECT rvu99,rvu21 FROM ",cl_get_target_table(l_azp01,'rvu_file'), #FUN-A50102   #TQC-BB0131 add rvu21
                  " WHERE rvu01 = '",g_apb.apb21,"' "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql          #FUN-A50102
      CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql  #FUN-A50102
      PREPARE sel_rvu99_pre FROM g_sql
      EXECUTE sel_rvu99_pre INTO g_apa.apa99, g_apa.apa76    #TQC-BB0131 add g_apa.apa76
 
      IF cl_null(g_apa.apa11) THEN 
       # LET g_sql = "SELECT pmc17 FROM ",l_dbs CLIPPED,"pmc_file",                 #FUN-A50102 mark
         LET g_sql = "SELECT pmc17 FROM ",cl_get_target_table(l_azp01,'pmc_file'),  #FUN-A50102   
                     " WHERE pmc01='",g_apa.apa06,"' "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql         #FUN-A50102
         CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-A50102
         PREPARE sel_pmc17_pre FROM g_sql
         EXECUTE sel_pmc17_pre INTO g_apa.apa11
         IF SQLCA.sqlcode = 100 THEN 
            LET g_success = 'N'
            CALL s_errmsg("apa11",g_apa.apa06,"pmc17 is null",'aap-604',1)
            RETURN
         END IF 
      END IF 
      
      LET g_apa.apaprno = 0   #MOD-830072
      LET g_apa.apa100 = l_azp01        #FUN-9C0001 
      LET g_apa.apalegal = g_legal      #FUN-980001 add
      LET g_apa.apa79 = '0'             #FUN-A40003 adda  #No.FUN-A60024
      
      SELECT apyvcode INTO g_apa.apa77 FROM apy_file WHERE apyslip = l_trtype
        IF cl_null(g_apa.apa77) THEN
           LET g_apa.apa77 = g_apz.apz63   #FUN-970108 add
        END IF 
      
      LET g_apa.apaoriu = g_user      #No.FUN-980030 10/01/04
      LET g_apa.apaorig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO apa_file VALUES(g_apa.*)
      IF STATUS THEN
         LET g_success = 'N'
         CALL s_errmsg("apa01",g_apa.apa01,"p110_ins_apa(ckp#1):",SQLCA.sqlcode,1)
      END IF
      IF begin_no IS NULL THEN
         LET begin_no = g_apa.apa01
      END IF
 
      LET end_no=g_apa.apa01
      
      CALL apa_nw.appendElement()
      LET apa_nw[apa_nw.getLength()].azp01 = l_azp01           #MOD-A90121
      LET apa_nw[apa_nw.getLength()].apa00 = g_apa.apa00       #MOD-A90121
      LET apa_nw[apa_nw.getLength()].apa01 = g_apa.apa01
 
   END IF
   LET g_apa01 = g_apa.apa01  #NO.MOD-5B0178
   LET g_pmm12 = g_apa21
   LET g_pmm13 = g_apa22
   LET g_pmn40 = ' '
   LET g_aps22 = ' '
   LET g_apb.apb01 = g_apa.apa01
   LET g_apb.apb02 = 0
   LET g_apb.apb13f = 0
   LET g_apb.apb13 = 0
   LET g_apb.apb14f = 0
   LET g_apb.apb14 = 0
   LET g_apb.apb15  = 0
   LET g_apb.apb930=s_costcenter_stock_apb(g_apa.apa930,g_rvv930,g_apa.apa51)  #FUN-670064
 
END FUNCTION
 
FUNCTION p110_ins_apb()
   DEFINE l_invoice   LIKE apa_file.apa08
   DEFINE l_depno     LIKE apa_file.apa22
   DEFINE l_d_actno   LIKE apa_file.apa51
   DEFINE l_c_actno   LIKE apa_file.apa54
   DEFINE l_pmk13     LIKE pmk_file.pmk13
   DEFINE l_aag05     LIKE aag_file.aag05   #No.TQC-5B0115
   DEFINE l_rvv32     LIKE rvv_file.rvv32   #MOD-5B0143
   DEFINE l_rvv33     LIKE rvv_file.rvv33   #MOD-5B0143
   DEFINE l_rvv23     LIKE rvv_file.rvv23   #MOD-780145 add
   DEFINE l_rvv40     LIKE rvv_file.rvv40   #MOD-780145 add
   DEFINE l_pmn401    LIKE pmn_file.pmn401  #No.FUN-680029
   DEFINE l_cnt       LIKE type_file.num5   #FUN-680110 add
   DEFINE l_gec04     LIKE gec_file.gec04   #TQC-8A0079 add
   DEFINE l_gec05     LIKE gec_file.gec05   #MOD-A80052
   DEFINE l_gec07     LIKE gec_file.gec07   #TQC-8A0079 add
   DEFINE l_pmn24     LIKE pmn_file.pmn24   #FUN-930165 add
   DEFINE l_apa32f    LIKE apa_file.apa32f  #MOD-A80052 
   DEFINE l_apb09     LIKE apb_file.apb09   #MOD-B60203
   DEFINE l_sumapb09  LIKE apb_file.apb09   #MOD-BA0074
   DEFINE l_apb10     LIKE apb_file.apb10   #MOD-BA0074
   DEFINE l_sumapb10  LIKE apb_file.apb10   #MOD-BA0074
   DEFINE l_diffamt   LIKE apb_file.apb10   #MOD-BA0074
   DEFINE l_apb24     LIKE apb_file.apb24   #MOD-B60203
   DEFINE l_flag      LIKE type_file.chr1   #MOD-B60203
   DEFINE l_azf141    LIKE azf_file.azf141  #FUN-B80058
 
   SELECT MAX(apb02)+1 INTO g_apb.apb02
     FROM apb_file
    WHERE apb01=g_apb.apb01
 
   IF g_apb.apb02 IS NULL THEN
      LET g_apb.apb02 = 1
   END IF
#No.MOD-B40197 --begin
   LET g_sql = "SELECT azi03,azi04 FROM ",cl_get_target_table(l_azp01,'azi_file'),     #FUN-A50102  
              #" WHERE azi01 = '",g_rvw.rvw11,"' "  #MOD-C50040 mark
               " WHERE azi01 = '",g_apa.apa13,"' "  #MOD-C50040
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql               #FUN-A50102 
   CALL cl_parse_qry_Sql(g_sql,l_azp01) RETURNING g_sql       #FUN-A50102 
   PREPARE sel_azi03_pre FROM g_sql
   EXECUTE sel_azi03_pre INTO t_azi03,t_azi04
#No.MOD-B40197 --end  
 
   LET g_apb.apb23 = cl_digcut(g_apb.apb23,t_azi03)   #MOD-780215
   LET g_apb.apb37 = l_azp01 
   IF g_apb.apb09 IS NULL THEN
      LET g_apb.apb09 = 0
   END IF
 
   LET g_apb.apb34 = 'N'
   #apb09=rvv87(計價數量)-rvv23(已請款批配量)
   #若此入庫單已產生過暫估資料，則rvv23已壓上，會造成apb09=0
   #故若要產生沖暫估資料則需將rvv23加回
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM apb_file,apa_file
    WHERE apb21 = g_apb.apb21
      AND apb22 = g_apb.apb22
      AND apa01 = apb01
      AND (apa00 = '16' OR apa00 = '26') #暫估應付資料
      AND apa41 ='Y'    #確認
      AND apa42 ='N'    #未作廢   #MOD-860037 add
      AND apb37=l_azp01   #FUN-A20006
   IF l_cnt > 0 THEN    #有暫估資料
      LET g_apb.apb34 = 'Y'
   END IF
   LET l_flag = 'N'   #MOD-B60203
 
  #-MOD-BA0074-add-
   SELECT apb09,apb10,apb24 INTO l_apb09,l_apb10,l_apb24 
     FROM apb_file,apa_file
    WHERE apb21 = g_apb.apb21
      AND apb22 = g_apb.apb22
      AND apa01 = apb01
      AND apa00 = '16' 
      AND apa41 ='Y'    #確認
      AND apa42 ='N'    #未作廢 
  #-MOD-BA0074-end-
   IF g_apb.apb29 = '3' THEN
      IF g_aza.aza26 = '2' THEN
         LET g_apb.apb23 = cl_digcut(g_rvw.rvw17,t_azi03)         #TQC-790162
         LET g_apb.apb09 = g_rvw.rvw10
         #金額不能重算..萬一有尾差
         LET g_apb.apb24 = cl_digcut(g_rvw.rvw05f,t_azi04)        #No.TQC-7B0083 
         LET g_apb.apb10 = cl_digcut(g_rvw.rvw05 ,g_azi04)        #No.TQC-7B0083 
         LET g_apb.apb11 = g_rvw.rvw01                            #MOD-C60155 add
      ELSE
         LET g_apb.apb23 = cl_digcut(g_apb.apb23,t_azi03)         #TQC-790162
      END IF
   ELSE
      IF g_aza.aza26 = '2' THEN
         LET g_apb.apb23 = cl_digcut(g_rvw.rvw17,t_azi03)   #MOD-780215
         LET g_apb.apb09 = g_rvw.rvw10
         #金額不能重算..萬一有尾差
         LET g_apb.apb24 = cl_digcut(g_rvw.rvw05f,t_azi04)  #No.TQC-7B0083 
         LET g_apb.apb10 = cl_digcut(g_rvw.rvw05 ,g_azi04)        #No.TQC-7B0083 
         LET g_apb.apb11 = g_rvw.rvw01                            #MOD-C60155 add
      ELSE
         LET g_apb.apb23 = cl_digcut(g_apb.apb23,t_azi03)   #MOD-780215
        #-MOD-B60203-add-
        #-MOD-BA0074-mark-
        #SELECT apb09,apb24 INTO l_apb09,l_apb24 
        #  FROM apb_file,apa_file
        # WHERE apb21 = g_apb.apb21
        #   AND apb22 = g_apb.apb22
        #   AND apa01 = apb01
        #   AND apa00 = '16' 
        #   AND apa41 ='Y'    #確認
        #   AND apa42 ='N'    #未作廢 
        #-MOD-BA0074-end-
         IF g_apb.apb34 = 'Y' AND l_apb09 = g_apb.apb09 THEN
            LET g_apb.apb24 = l_apb24
            LET l_flag = 'Y'
         END IF 
        #-MOD-B60203-end-
      END IF
   END IF   #TQC-610108
 
   IF g_apb.apb09 > 0 THEN
      IF g_apb.apb29 = '3' THEN
         LET g_apb.apb09 = g_apb.apb09 * -1
      END IF
   END IF
 
   #大陸版時,不能重算
  #IF g_aza.aza26 <> '2' THEN     #MOD-A70020 mark     #MOD-A80093 remark #MOD-B60203 mark
   IF g_aza.aza26 <> '2' AND l_flag = 'N' THEN    #MOD-B60203 
      #單價含稅時,不使用單價*數量=金額,改以含稅金額回推稅率,以避免小數位差的問題
      LET l_gec04 = 0   LET l_gec07 = ''
      IF cl_null(g_apb.apb06) THEN
        #LET g_sql = "SELECT gec04,gec07 ",                                               #MOD-A80052 mark
         LET g_sql = "SELECT gec04,gec05,gec07 ",                                         #MOD-A80052
                   # "  FROM ",l_dbs CLIPPED,"gec_file,",l_dbs CLIPPED,"rvu_file ",       #FUN-A50102 mark
                     "  FROM ",cl_get_target_table(l_azp01,'gec_file'),",",               #FUN-A50102
                               cl_get_target_table(l_azp01,'rvu_file'),                   #FUN-A50102 
                     " WHERE gec01 = rvu115 ",
                     "   AND rvu01 = '",g_apb.apb21,"' ",
                     "   AND gec011 = '1' "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
         CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql     #FUN-A50102
         PREPARE sel_gec04_pre FROM g_sql
        #EXECUTE sel_gec04_pre INTO l_gec04,l_gec07                                       #MOD-A80052 mark
         EXECUTE sel_gec04_pre INTO l_gec04,l_gec05,l_gec07                               #MOD-A80052
      ELSE
        #LET g_sql = "SELECT gec04,gec07 ",                                               #MOD-A80052 mark
         LET g_sql = "SELECT gec04,gec05,gec07 ",                                         #MOD-A80052
                # "  FROM ",l_dbs CLIPPED,"gec_file,",l_dbs CLIPPED,"pmm_file ",          #FUN-A50102 mark
                  "  FROM ",cl_get_target_table(l_azp01,'gec_file'),",",                  #FUN-A50102
                            cl_get_target_table(l_azp01,'pmm_file'),                      #FUN-A50102
                  " WHERE gec01 = pmm21 ",
                  "   AND pmm01 = '",g_apb.apb06,"' ",
                  "   AND gec011 = '1'"  
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql          #FUN-A50102
      CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql  #FUN-A50102

      PREPARE sel_gec04_pre1 FROM g_sql
     #EXECUTE sel_gec04_pre1 INTO l_gec04,l_gec07                                         #MOD-A80052 mark
      EXECUTE sel_gec04_pre1 INTO l_gec04,l_gec05,l_gec07                                 #MOD-A80052
      END IF
      IF cl_null(l_gec04) THEN LET l_gec04=0   END IF
      IF cl_null(l_gec07) THEN LET l_gec07='N' END IF
      LET g_apb24t= cl_digcut(g_apb24t,t_azi04)        #MOD-B90164 add
      IF l_gec07='Y' THEN
        #-MOD-A80052-add-
         IF l_gec05 = 'T' THEN
            LET g_sql = "SELECT rvv39t ",
                        "  FROM ",cl_get_target_table(l_azp01,'rvv_file'),
                        " WHERE rvv01 = '",g_apb.apb21,"' ", 
                        "   AND rvv02 = '",g_apb.apb22,"' "
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql     
            CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql 
            PREPARE sel_rvv39t_pre FROM g_sql
            EXECUTE sel_rvv39t_pre INTO g_apb24t 
            IF cl_null(g_apb24t) THEN LET g_apb24t=0 END IF
            LET l_apa32f = g_apb24t * (l_gec04/100)
            LET l_apa32f = cl_digcut(l_apa32f , t_azi04)
            LET g_apb.apb24 = g_apb24t - l_apa32f 
         ELSE
            LET g_apb.apb24 = g_apb24t / (1+l_gec04/100)
         END IF
        #-MOD-A80052-end-
        #LET g_apb.apb24 = g_apb24t / (1+l_gec04/100)      #MOD-A80052 mark
      ELSE
         LET g_apb.apb24 = g_apb.apb23 * g_apb.apb09  #No.TQC-7B0013  move here
      END IF

     #當異動類別(apb29)為3.倉退,且數量(apb09)為0時,金額直接抓rvv39
      IF g_apb.apb29 = '3' AND g_apb.apb09 = 0 THEN
       # LET g_sql = "SELECT rvv39 FROM ",l_dbs CLIPPED,"rvv_file ",               #FUN-A50102 mark
         LET g_sql = "SELECT rvv39 FROM ",cl_get_target_table(l_azp01,'rvv_file'), #FUN-A50102 
                     " WHERE rvv01='",g_apb.apb21,"' ",
                     "   AND rvv02='",g_apb.apb22,"' "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql            #FUN-A50102
         CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql    #FUN-A50102
         PREPARE sel_rvv39_pre FROM g_sql
         EXECUTE sel_rvv39_pre INTO g_apb.apb24
         IF cl_null(g_apb.apb24) THEN LET g_apb.apb24=0 END IF
         LET g_apb.apb24 = g_apb.apb24 * -1
      END IF
   END IF                      #MOD-A70020 mark     #MOD-A80093 remark
 
   LET g_apb.apb24 = cl_digcut(g_apb.apb24,t_azi04)   #MOD-780215
 
   LET g_apb.apb08 = g_apb.apb23 * g_apa.apa14
   LET g_apb.apb08 = cl_digcut(g_apb.apb08,g_azi03)         #No.CHI-6A0004 t_azi-->g_azi    #MOD-780215
 
   #大陸版時,不能重算
   IF g_aza.aza26 <> '2' THEN     #MOD-A70020 mark     #MOD-A80093 remark
      LET g_apb.apb10 = g_apb.apb24 * g_apa.apa14   #MOD-840632   #MOD-860221 mark回復
      LET g_apb.apb10 = cl_digcut(g_apb.apb10,g_azi04)      #MOD-CC0034 add
   END IF                         #MOD-A70020 mark     #MOD-A80093 remark
  #-MOD-BA0074-add-
   LET g_chkdiff = 'N'  
   LET l_diffamt = 0  
   LET l_sumapb09 = 0
   LET l_sumapb10 = 0
   SELECT SUM(apb09),SUM(apb10) INTO l_sumapb09,l_sumapb10
     FROM apa_file,apb_file
    WHERE apa01 = apb01 
      AND apa42 = 'N'
      AND apb01 <> g_apb.apb01
      AND apa00 <> '16' 
      AND apb21 = g_apb.apb21
      AND apb22 = g_apb.apb22
   IF cl_null(l_sumapb09) THEN LET l_sumapb09 = 0 END IF
   IF cl_null(l_sumapb10) THEN LET l_sumapb10 = 0 END IF
  #IF l_apb09 = l_sumapb09 + g_apb.apb09 THEN                          #MOD-C20104 mark   
   IF l_apb09 = l_sumapb09 + g_apb.apb09 AND g_aza.aza26 <> '2' THEN   #MOD-C20104                     
      LET l_diffamt = l_apb10 - l_sumapb10 - g_apb.apb10  
      CALL s_abs(l_diffamt) RETURNING l_diffamt
      LET g_apb.apb10 = g_apb.apb10 + l_diffamt
      IF g_apa.apa14 = 1 THEN
         LET g_apb.apb24 = g_apb.apb10
         LET g_apb.apb24 = cl_digcut(g_apb.apb24,t_azi04)  
      END IF
      LET g_chkdiff = 'Y'  
   END IF
  #-MOD-BA0074-end-
   LET g_apb.apb10 = cl_digcut(g_apb.apb10,g_azi04)         #No.CHI-6A0004 t_azi-->g_azi    #MOD-780215
  #若為倉退單則金額也需顯示為負數
   IF g_apb.apb29 = '3' THEN

      IF g_apb.apb10 > 0 THEN
         LET g_apb.apb10 = g_apb.apb10 * -1
      END IF
   END IF
 
   LET g_apb.apb081 = g_apb.apb08
   LET g_apb.apb101 = g_apb.apb10
 
   #若帳款人員,部門空白時,default採購人員,部門
   IF cl_null(g_apa.apa21) THEN
      IF cl_null(g_apb.apb06) THEN

         LET g_sql = "SELECT rvu07 ",
                   # "  FROM ",l_dbs CLIPPED,"rvu_file,",l_dbs CLIPPED,"apb_file ", #FUN-A50102 mark
                     "  FROM ",cl_get_target_table(l_azp01,'rvu_file'),",",         #FUN-A50102
                               cl_get_target_table(l_azp01,'apb_file'),             #FUN-A50102  
                     " WHERE apb01 = '",g_apa.apa01,"' ",
                     "   AND apb02 = '",g_apb.apb02,"' ",
                     "   AND apb21 = rvu01 ",
                     "   AND rvuconf = 'Y' "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql         #FUN-A50102
         CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-A50102
         PREPARE sel_rvu07_pre FROM g_sql
         EXECUTE sel_rvu07_pre INTO g_pmm12
      ELSE

    # LET g_sql = "SELECT pmm12 FROM ",l_dbs CLIPPED,"pmm_file,",l_dbs CLIPPED,"apb_file",       #FUN-A50102 mark
      LET g_sql = "SELECT pmm12 FROM ",cl_get_target_table(l_azp01,'pmm_file'),",",              #FUN-A50102
                                       cl_get_target_table(l_azp01,'apb_file'),                  #FUN-A50102 
                  " WHERE apb01 = '",g_apa.apa01,"' ",
                  "   AND apb02 = '",g_apb.apb02,"' ",
                  "   AND apb06 = pmm01 ",
                  "   AND pmm18 = 'Y' "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql         #FUN-A50102
      CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-A50102
      PREPARE sel_pmm12_pre2 FROM g_sql
      EXECUTE sel_pmm12_pre2 INTO g_pmm12 
      END IF
   END IF
 
   IF cl_null(g_apa.apa22) THEN
      IF cl_null(g_apb.apb06) THEN

         LET g_sql = "SELECT gen03 ",
                   # "  FROM ",l_dbs CLIPPED,"rvu_file,",l_dbs CLIPPED,"apb_file,", #FUN-A50102 mark
                   #           l_dbs CLIPPED,"gen_file ",                           #FUN-A50102 mark
                     "  FROM ",cl_get_target_table(l_azp01,'rvu_file'),",",         #FUN-A50102
                               cl_get_target_table(l_azp01,'apb_file'),",",         #FUN-A50102
                               cl_get_target_table(l_azp01,'gen_file'),             #FUN-A50102  
                     " WHERE apb01 = '",g_apa.apa01,"' ",
                     "   AND apb02 = '",g_apb.apb02,"' ",
                     "   AND apb21 = rvu01",
                     "   AND rvu07 = gen01",
                     "   AND rvuconf = 'Y'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql           #FUN-A50102
         CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql   #FUN-A50102 
         PREPARE sel_gen03_pre3 FROM g_sql
         EXECUTE sel_gen03_pre3 INTO g_pmm13 
      ELSE

    # LET g_sql = "SELECT gen03 FROM ",l_dbs CLIPPED,"pmm_file,",l_dbs CLIPPED,"apb_file,",#FUN-A50102 mark
    #                                  l_dbs CLIPPED,"gen_file ",                          #FUN-A50102 mark
      LET g_sql = "SELECT gen03 FROM ",cl_get_target_table(l_azp01,'pmm_file'),",",        #FUN-A50102
                                       cl_get_target_table(l_azp01,'apb_file'),",",        #FUN-A50102
                                       cl_get_target_table(l_azp01,'gen_file'),            #FUN-A50102 
                  " WHERE apb01 = '",g_apa.apa01,"' ",
                  "   AND apb02 = '",g_apb.apb02,"' ",
                  "   AND apb06 = pmm01 ",
                  "   AND pmm12 = gen01 ",
                  "   AND pmm18 = 'Y' "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql                #FUN-A50102 
      CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql        #FUN-A50102
      PREPARE sel_gen03_pre4 FROM g_sql
      EXECUTE sel_gen03_pre4 INTO g_pmm13
      END IF
   END IF
 
   LET g_apa.apa21 = g_pmm12
   LET g_apa.apa22 = g_pmm13
 
   LET g_apb.apb27 = ''   #MOD-8B0064 add
 
  IF cl_null(g_apb.apb06) THEN
 
     LET g_sql = "SELECT rvv031,rvv86,ima39,ima391,'','',' ','','' ",
               # "  FROM ",l_dbs CLIPPED,"rvv_file LEFT OUTER JOIN ",l_dbs CLIPPED,"ima_file ",     #FUN-A50102 mark
                 "  FROM ",cl_get_target_table(l_azp01,'rvv_file')," LEFT OUTER JOIN ",             #FUN-A50102
                           cl_get_target_table(l_azp01,'ima_file'),                                 #FUN-A50102
                 "                                 ON rvv31=ima01 ",
                 " WHERE rvv01='",g_apb.apb21,"' ",
                 "   AND rvv02='",g_apb.apb22,"' "
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
     CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql     #FUN-A50102
     PREPARE sel_rvv031_pre FROM g_sql
     EXECUTE sel_rvv031_pre INTO g_apb.apb27,g_apb.apb28,g_apb.apb25,l_pmn401,g_apb.apb26,
                                 l_pmk13,g_apb.apb35,g_apb.apb36,g_apb.apb31
  ELSE

   LET g_sql = "SELECT pmn041,pmn86,pmn40,pmn401,pmn67,pmk13,pmn122,pmn96,pmn98,pmn24",
             # " FROM ",l_dbs CLIPPED,"pmn_file LEFT OUTER JOIN ",l_dbs CLIPPED,"pmk_file",       #FUN-A50102 mark
               " FROM ",cl_get_target_table(l_azp01,'pmn_file'),                                  #FUN-A50102
               " LEFT OUTER JOIN ",cl_get_target_table(l_azp01,'pmk_file'),                       #FUN-A50102	
               "                                ON pmn24=pmk_file.pmk01 ",
               " WHERE pmn01='",g_apb.apb06,"' ",
               "   AND pmn02='",g_apb.apb07,"' "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql            #FUN-A50102
   CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql    #FUN-A50102
   PREPARE sel_pmn041_pre FROM g_sql
   EXECUTE sel_pmn041_pre INTO g_apb.apb27,g_apb.apb28,g_apb.apb25,l_pmn401,g_apb.apb26,
                               l_pmk13,g_apb.apb35,g_apb.apb36,g_apb.apb31,l_pmn24
  END IF
    IF g_apb.apb12[1,4]='MISC' AND NOT cl_null(l_pmn24) THEN    #MOD-950177  

     # LET g_sql = "SELECT pmk13 FROM ",l_dbs CLIPPED,"pmn_file,",               #FUN-A50102 mark
     #             " OUTER ",l_dbs CLIPPED,"pmk_file",                           #FUN-A50102 mark
       LET g_sql = "SELECT pmk13 FROM ",cl_get_target_table(l_azp01,'pmn_file'), #FUN-A50102
                  #" OUTER ",cl_get_target_table(l_azp01,'pmk_file'),            #FUN-A50102 #MOD-C80004 mark
                   " LEFT OUTER JOIN ",cl_get_target_table(l_azp01,'pmk_file'),  #MOD-C80004 add
                   "   ON pmn24 = pmk_file.pmk01 ",                              #MOD-C80004 add
                   " WHERE pmn01 = '",g_apb.apb06,"' ",
                   "   AND pmn02 = '",g_apb.apb07,"' ",
                   "   AND pmn24 = '",l_pmn24,"' " 
                  #"   AND pmn24 = pmk_file.pmk01 "              #MOD-C80004 mark
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql            #FUN-A50102
       CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql    #FUN-A50102
       PREPARE sel_pmk13_pre FROM g_sql
       EXECUTE sel_pmk13_pre INTO g_apb.apb26 
    END IF 
 
   IF g_aza.aza63 = 'Y' THEN
      LET g_apb.apb251 = l_pmn401
   END IF
  
   IF cl_null(g_apb.apb25) AND NOT cl_null(g_apb.apb31) THEN

    # LET g_sql = "SELECT azf14 FROM ",l_dbs CLIPPED,"azf_file ",                #FUN-A50102 mark
      LET g_sql = "SELECT azf14,azf141 FROM ",cl_get_target_table(l_azp01,'azf_file'),  #FUN-A50102	
                  " WHERE azf01='",g_apb.apb31,"' ",      #FUN-B80058 add azf141
                  "   AND azf02='2' AND azfacti='Y' "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql           #FUN-A50102
      CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql   #FUN-A50102
      PREPARE sel_azf14_pre FROM g_sql
      EXECUTE sel_azf14_pre INTO g_apb.apb25,l_azf141    #FUN-B80058 add azf141
      IF g_aza.aza63='Y' AND cl_null(g_apb.apb251) THEN
        #LET g_apb.apb251 = g_apb.apb25
        LET g_apb.apb251 = l_azf141      #FUN-B80058
      END IF
   END IF
 
   IF g_apa.apa51 = 'STOCK' THEN

    # LET g_sql = "SELECT rvv32,rvv33 FROM ",l_dbs CLIPPED,"rvv_file ",               #FUN-A50102 mark
      LET g_sql = "SELECT rvv32,rvv33 FROM ",cl_get_target_table(l_azp01,'rvv_file'), #FUN-A50102
                  " WHERE rvv01 = '",g_apb.apb21,"' ",
                  "   AND rvv02 = '",g_apb.apb22,"' "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql            #FUN-A50102
      CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql    #FUN-A50102 
      PREPARE sel_rvv32_pre FROM g_sql
      EXECUTE sel_rvv32_pre INTO l_rvv32,l_rvv33  
      CALL t110_stock_act(g_apb.apb12,l_rvv32,l_rvv33,'0',l_azp01)  #No.FUN-680029 新增參數'0'   #FUN-9C0041 add l_azp01
           RETURNING g_apb.apb25  #TQC-870024    #TQC-920018 mark回復
 
      IF g_aza.aza63 = 'Y' THEN
         CALL t110_stock_act(g_apb.apb12,l_rvv32,l_rvv33,'1',l_azp01)   #FUN-9C0041 add l_azp01
              RETURNING g_apb.apb251   #TQC-920018 
      END IF
   END IF

  #LET g_sql = "SELECT aag05 FROM ",l_dbs CLIPPED,"aag_file ",                #FUN-A50102 mark
   LET g_sql = "SELECT aag05 FROM ",cl_get_target_table(l_azp01,'aag_file'),  #FUN-A50102 
               " WHERE aag01 = '",g_apb.apb25,"' ",
               "   AND aag00 = '",g_bookno1,"' "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql          #FUN-A50102
   CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql  #FUN-A50102 
   PREPARE sel_aag05_pre FROM g_sql
   EXECUTE sel_aag05_pre INTO l_aag05
   IF l_aag05 = "Y" AND cl_null(g_apb.apb26) THEN
      LET g_apb.apb26 = g_apa.apa22
   END IF
   #No.MOD-B70287  --Begin
   IF cl_null(l_aag05) OR l_aag05 = 'N' THEN
      LET g_apb.apb26 = NULL
   END IF
   #No.MOD-B70287  --End
 
   IF cl_null(g_apb.apb26) THEN LET g_apb.apb26=' ' END IF #MOD-BA0018 
   IF cl_null(g_apb.apb27) THEN     # 帶出品名,單位
    # LET g_sql = "SELECT ima02,ima25 FROM ",l_dbs CLIPPED,"ima_file ",               #FUN-A50102 mark 
      LET g_sql = "SELECT ima02,ima25 FROM ",cl_get_target_table(l_azp01,'ima_file'), #FUN-A50102
                  " WHERE ima01 = '",g_apb.apb12,"' "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql         #FUN-A50102
      CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-A50102 
      PREPARE sel_ima02_pre FROM g_sql
      EXECUTE sel_ima02_pre INTO g_apb.apb27,g_apb.apb28
   END IF
 

   LET g_apb.apblegal = g_legal         #FUN-980001 add
   SELECT ima39 INTO g_apb.apb25 FROM ima_file WHERE ima01 = g_apb.apb12     #C20200507-13644#1 add 料件所属会计科目
   #TQC-C10017  --Begin
   IF cl_null(g_apb.apb25) THEN LET g_apb.apb25= ' ' END IF
   IF cl_null(g_apb.apb26) THEN LET g_apb.apb26= ' ' END IF
   IF cl_null(g_apb.apb27) THEN LET g_apb.apb27= ' ' END IF
   IF cl_null(g_apb.apb31) THEN LET g_apb.apb31= ' ' END IF
   IF cl_null(g_apb.apb35) THEN LET g_apb.apb35= ' ' END IF
   IF cl_null(g_apb.apb36) THEN LET g_apb.apb36= ' ' END IF
   IF cl_null(g_apb.apb930) THEN LET g_apb.apb930= ' ' END IF
   #TQC-C10017  --End
   INSERT INTO apb_file VALUES(g_apb.*)
   IF STATUS THEN
      LET g_success = 'N'
      LET g_showmsg=g_apb.apb01,"/",g_apb.apb02
      CALL s_errmsg("apb01,apb02",g_showmsg,"p110_ins_apb(ckp#1):",SQLCA.sqlcode,1)
   END IF
   IF summary_sw = '1' THEN
      IF g_rvw.rvw05 != 0 AND g_rvw.rvw05 IS NOT NULL THEN
         LET g_apa.apa31f= g_rvw.rvw05f
         LET g_apa.apa31 = g_rvw.rvw05
      ELSE
         IF g_apb.apb29='1' THEN                 #85-09-26
            LET g_apa.apa31f= g_apa.apa31f+ g_apb.apb24
            LET g_apa.apa31 = g_apa.apa31 + g_apb.apb10
         ELSE
            LET g_apa.apa31f= g_apa.apa31f- g_apb.apb24
            LET g_apa.apa31 = g_apa.apa31 - g_apb.apb10
         END IF
      END IF
 
      IF g_rvw.rvw06 != 0 AND g_rvw.rvw06 IS NOT NULL THEN
         LET g_apa.apa32f= g_rvw.rvw06f
         LET g_apa.apa32 = g_rvw.rvw06
      ELSE
         LET g_apa.apa32f= g_apa.apa31f* g_apa.apa16 / 100      # 四捨五入
         LET g_apa.apa32f= cl_digcut(g_apa.apa32f,t_azi04)   #MOD-780215
         LET g_apa.apa32 = g_apa.apa31 * g_apa.apa16 / 100      # 四捨五入
         LET g_apa.apa32 = cl_digcut(g_apa.apa32,g_azi04)   #No.CHI-6A0004 t_azi-->g_azi   #MOD-780215
      END IF
   END IF
 
   LET g_apa.apa34f= g_apa.apa31f+ g_apa.apa32f
   LET g_apa.apa34 = g_apa.apa31 + g_apa.apa32
 
   LET g_apa.apa73=g_apa.apa34
 
   UPDATE apa_file SET apa31f = g_apa.apa31f,
                       apa32f = g_apa.apa32f,
                       apa34f = g_apa.apa34f,
                       apa60f = g_apa.apa60f,
                       apa61f = g_apa.apa61f,
                       apa31 = g_apa.apa31,
                       apa32 = g_apa.apa32,
                       apa34 = g_apa.apa34,
                       apa60 = g_apa.apa60,
                       apa61 = g_apa.apa61,
                       apa56 = g_apa.apa56,
                       apa73 = g_apa.apa73             #A059
    WHERE apa01 = g_apa.apa01
 
   IF STATUS OR SQLCA.sqlerrd[3]=0 THEN    #TQC-630174

      LET g_success = 'N'
      CALL s_errmsg("apa01",g_apa.apa01,"upd apa:",SQLCA.sqlcode,1)
   END IF
 
   SELECT COUNT(*) INTO l_cnt FROM apa_file,apb_file
    WHERE apa01=apb01
      AND apb21=g_apb.apb21 AND apb22=g_apb.apb22
      AND (apa00='16' OR apa00='26')   #暫估應付OR暫估倉退   #MOD-7A0069 mod
      AND apa41 ='Y'    #確認  #No.TQC-7B0083
      AND apa42 ='N'    #未作廢   #MOD-860037 add
      AND apb37 = l_azp01   #FUN-A20006
  #重要信息:若是衝暫估的單子,則rvv88=rvv88-apb09/rvv23=rvv2+apb09 l_cnt >0
  #         正常請款單子,則rvv23=rvv23+apb09 l_cnt = 0
  ##l_cnt>0表示已經有做過暫估應付了，就不需將rvv40壓成N
   IF l_cnt = 0 THEN
      IF g_apb.apb09 < 0 THEN
         LET g_apb.apb09 = g_apb.apb09 * -1
      END IF
 
    # LET g_sql = "UPDATE ",l_dbs CLIPPED,"rvv_file SET rvv23 = (rvv23 + ?)  ",   #FUN-9C0001      #FUN-A50102 mark
      LET g_sql = "UPDATE ",cl_get_target_table(l_azp01,'rvv_file')," SET rvv23 = (rvv23 + ?)  ",  #FUN-A50102       
                  " WHERE rvv01 = ?  AND rvv02 = ?"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql          #FUN-A50102
      CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql  #FUN-A50102 
      PREPARE p110_ins_apb_p FROM g_sql
      EXECUTE p110_ins_apb_p USING g_apb.apb09,g_apb.apb21,g_apb.apb22
   ELSE
      IF g_apb.apb09 < 0 THEN
         LET g_apb.apb09 = g_apb.apb09 * -1
      END IF
    # LET g_sql = "UPDATE ",l_dbs CLIPPED,"rvv_file SET rvv23 = (rvv23 + ?), ",   #FUN-9C0001      #FUN-A50102 mark
      LET g_sql = "UPDATE ",cl_get_target_table(l_azp01,'rvv_file'), " SET rvv23 = (rvv23 + ?), ", #FUN-A50102 mark 
                  "                    rvv88 = (rvv88 - ?)  ", #no.5748非沖暫估
                  " WHERE rvv01 = ?  AND rvv02 = ?"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql          #FUN-A50102
      CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql  #FUN-A50102
      PREPARE p110_ins_apb_p1 FROM g_sql
      EXECUTE p110_ins_apb_p1 USING g_apb.apb09,g_apb.apb09,g_apb.apb21,g_apb.apb22
   END IF
   IF STATUS OR SQLCA.sqlerrd[3]=0 THEN    #TQC-630174
      LET g_success = 'N'
      LET g_showmsg=g_apb.apb21,"/",g_apb.apb22
      CALL s_errmsg("rvv01,rvv02",g_showmsg,"p110_ins_apb(ckp#2):",SQLCA.sqlcode,1)
   END IF   #FUN-680110 add
 
   IF g_apb.apb29 = '3' THEN
      IF g_aza.aza26 = '2' THEN
         IF (NOT cl_null(g_apb.apb04)) AND (NOT cl_null(g_apb.apb05)) THEN
            CALL p110_upd_rvb06()
         END IF
      ELSE
         IF (NOT cl_null(g_apb.apb04)) AND (NOT cl_null(g_apb.apb05)) THEN  #MOD-920117 add
            CALL p110_upd_rvb06()
         END IF                                                             #MOD-920117 add
      END IF
   ELSE
      CALL p110_upd_rvb06()
   END IF
 
END FUNCTION
 
FUNCTION p110_ins_apk()
   DEFINE l_apk      RECORD LIKE apk_file.*
   DEFINE l_n        LIKE type_file.num10   #No.FUN-690028 INTEGER
   DEFINE l_trtype   LIKE apy_file.apyslip  #FUN-990014
   DEFINE l_year    LIKE type_file.num5  #CHI-820005
 
   LET l_year = YEAR(g_rvw.rvw02)USING '&&&&'    #CHI-820005    Add

   SELECT COUNT(*) INTO l_n FROM apk_file
    WHERE apk01 = g_apa.apa01
      AND apk03 = g_inv_no
      AND apk03 <> ' '
      AND apk03 IS NOT NULL
      AND YEAR(apk05) = l_year     #CHI-820005   Add
 
   IF (g_aza.aza26 != '2' OR g_aza.aza46 = 'N') AND l_n > 0 THEN   #No.FUN-580006
      RETURN
   END IF
 
   INITIALIZE l_apk.* TO NULL
   LET l_apk.apk01 = g_apa.apa01
 
   #非大陸版功能, 或未使用稅控接口系統, 發票不需拆明細
   IF g_aza.aza26 != '2' OR g_aza.aza46 = 'N' THEN   #No.FUN-580006
      SELECT MAX(apk02) INTO l_apk.apk02
        FROM apk_file
       WHERE apk01 = g_apa.apa01
 
      IF l_apk.apk02 IS NULL THEN
         LET l_apk.apk02 = 0
      END IF
 
      LET l_apk.apk02 = l_apk.apk02+1
      LET l_apk.apk17 = g_apa.apa17
      LET l_apk.apk172 = g_apa.apa172
 
      DECLARE apk_curs CURSOR FOR
         SELECT rvw02,rvw03,rvw04,rvw11,rvw12,
                rvw07,SUM(rvw10),  #No:8086 補上rvw07,rvw10   #MOD-740035
                SUM(rvw05),SUM(rvw06),SUM(rvw05f),SUM(rvw06f)
           FROM rvw_file
          WHERE rvw01 = g_inv_no
          GROUP BY rvw02,rvw03,rvw04,rvw11,
                   rvw12,rvw07         #MOD-740035
 
      OPEN apk_curs
 
      FETCH apk_curs INTO l_apk.apk05,l_apk.apk11,l_apk.apk29,
                          l_apk.apk12,l_apk.apk13,l_apk.apk28,l_apk.apk30,
                          l_apk.apk08,l_apk.apk07,l_apk.apk08f,l_apk.apk07f
   ELSE
     #MOD-A30064---add---start---
      IF g_aza.aza26 = '2' THEN
         SELECT gec05 INTO l_apk.apk172
           FROM gec_file
          WHERE gec01 = g_apa.apa15
            AND gec011 = '1'
      END IF
     #MOD-A30064---add---end---
      LET l_apk.apk02=g_apb.apb02     #對應帳款單之項次
      SELECT rvw02,rvw04,rvw05,rvw06,rvw07,rvw10,rvw03,rvw11,rvw12,
             rvw05f,rvw06f
        INTO l_apk.apk05,l_apk.apk29,l_apk.apk08,l_apk.apk07,l_apk.apk28,
             l_apk.apk30,l_apk.apk11,l_apk.apk12,l_apk.apk13,l_apk.apk08f,
             l_apk.apk07f
        FROM rvw_file
       WHERE rvw01 = g_inv_no
         AND rvw08 = g_apb.apb21
         AND rvw09 = g_apb.apb22     #No.MOD-540169
 
      IF l_apk.apk29 > 0 THEN
         LET l_apk.apk172 = 'S'
      END IF
   END IF
 
   IF STATUS THEN
      LET l_apk.apk11 = g_apa.apa15  #稅別
      LET l_apk.apk29 = g_apa.apa16  #稅率
      LET l_apk.apk12 = g_apa.apa13  #幣別
      LET l_apk.apk13 = g_apa.apa14  #匯率
 
     #FUN-A60056--mod--str--
     #SELECT SUM(rvv39) INTO l_apk.apk08f FROM rvv_file
     # WHERE rvv01 = g_inv_no
      LET g_sql = "SELECT SUM(rvv39) FROM ",cl_get_target_table(g_apb.apb37,'rvv_file'),
                  " WHERE rvv01 = '",g_inv_no,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_apb.apb37) RETURNING g_sql
      PREPARE sel_rvv39 FROM g_sql
      EXECUTE sel_rvv39 INTO l_apk.apk08f
     #FUN-A60056--mod--end
 
      LET l_apk.apk07f = l_apk.apk08f * l_apk.apk29 / 100
 
     #FUN-A60056--mod--str--
     #SELECT rvu11,rvu13,rvu14,rvu15
     #  INTO l_apk.apk05,l_apk.apk08,l_apk.apk07,l_apk.apk03
     #  FROM rvu_file
     # WHERE rvu01 = g_inv_no {AND rvu10='Y'}
     #   AND rvuconf = 'Y'
      LET g_sql = "SELECT rvu11,rvu13,rvu14,rvu15 ",
                  "  FROM ",cl_get_target_table(g_apb.apb37,'rvu_file'),
                  " WHERE rvu01 = '",g_inv_no,"' ",
                  "   AND rvuconf = 'Y'"
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql
     CALL cl_parse_qry_sql(g_sql,g_apb.apb37) RETURNING g_sql
     PREPARE sel_rvu11 FROM g_sql
     EXECUTE sel_rvu11 INTO l_apk.apk05,l_apk.apk08,l_apk.apk07,l_apk.apk03
     #FUN-A60056--mod--end
      IF STATUS THEN
         LET l_apk.apk05 = g_rvv09
         LET l_apk.apk08 = g_apb.apb10
         LET l_apk.apk08f = g_apb.apb24
         LET l_apk.apk07 = 0
         LET l_apk.apk07f = 0
      END IF
   END IF
 
   IF l_apk.apk08 IS NULL THEN
      LET l_apk.apk08 = 0
   END IF
 
   IF l_apk.apk07 IS NULL THEN
      LET l_apk.apk07 = 0
   END IF
 
   IF l_apk.apk08f IS NULL THEN
      LET l_apk.apk08f = 0
   END IF
 
   IF l_apk.apk07f IS NULL THEN
      LET l_apk.apk07f = 0
   END IF
 
   LET l_apk.apk06 = l_apk.apk08 + l_apk.apk07
   LET l_apk.apk06f = l_apk.apk08f + l_apk.apk07f
 
   #no.A010依幣別取位
   LET l_apk.apk06 = cl_digcut(l_apk.apk06,g_azi04)
   LET l_apk.apk07 = cl_digcut(l_apk.apk07,g_azi04)
   LET l_apk.apk08 = cl_digcut(l_apk.apk08,g_azi04)
 
   SELECT azi04 INTO t_azi04 FROM azi_file      #No.CHI-6A0004 l_azi-->t_azi
    WHERE azi01 = l_apk.apk12
 
   LET l_apk.apk06f = cl_digcut(l_apk.apk06f,t_azi04)   #No.CHI-6A0004 l_azi-->t_azi
   LET l_apk.apk07f = cl_digcut(l_apk.apk07f,t_azi04)   #No.CHI-6A0004 l_azi-->t_azi
   LET l_apk.apk08f = cl_digcut(l_apk.apk08f,t_azi04)   #No.CHI-6A0004 l_azi-->t_azi
 
   LET l_apk.apk03   = g_inv_no
   LET l_apk.apk04   = g_apa.apa18
   LET l_apk.apk171 = ''
   SELECT gec08 INTO l_apk.apk171 FROM gec_file
   #WHERE gec01 = g_apa.apa15     #MOD-D30007 mark
    WHERE gec01 = l_apk.apk11     #MOD-D30007
      AND gec011 = '1'   #MOD-940260    
   IF l_apk.apk171 = '' OR cl_null(l_apk.apk171) THEN
      LET l_apk.apk171 = '21'
   END IF
   LET l_apk.apkuser = g_user
   LET l_apk.apkgrup = g_grup
   LET l_apk.apkdate = g_today
   LET l_apk.apkacti='Y'
   LET l_apk.apklegal = g_legal         #FUN-980001 add

   #No.TQC-BA0047  --Begin
  #TQC-B90062---s---
  #IF l_apk.apk06 = 0 THEN                                                   #MOD-C40221 mark
   IF l_apk.apk06 = 0 AND l_apk.apk171 <> 'XX' OR cl_null(l_apk.apk03) THEN  #MOD-C40221
      RETURN
   END IF
   #No.TQC-BA0047  --End
  #TQC-B90062---e---

  #IF l_apk.apk06 != 0 THEN                         #MOD-C40221 mark 
   IF l_apk.apk06 != 0 OR l_apk.apk171 = 'XX' THEN  #MOD-C40221
      LET l_trtype = trtype[1,g_doc_len]
      SELECT apyvcode INTO l_apk.apk32 FROM apy_file WHERE apyslip = l_trtype
        IF cl_null(l_apk.apk32) THEN
           LET l_apk.apk32 = g_apz.apz63   #FUN-970108 add
        END IF 
      LET l_apk.apkoriu = g_user      #No.FUN-980030 10/01/04
      LET l_apk.apkorig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO apk_file VALUES(l_apk.*)
      IF STATUS THEN
         LET g_success='N'
         LET g_showmsg=l_apk.apk01,"/",l_apk.apk02,"/",l_apk.apk03
         CALL s_errmsg("apk01,apk02,apk03",g_showmsg,"ins apk:",SQLCA.sqlcode,1)
      END IF
   END IF
   IF g_aza.aza26 = '2' AND g_apb.apb29 MATCHES '[23]' THEN
      LET l_apk.apk02=g_apb.apb02     #對應帳款單之項次
      LET l_apk.apk171='23'
      DECLARE p110_apk_curs2 CURSOR FOR
       SELECT rvw01,rvw02,rvw04,rvw05,rvw06,rvw07,rvw10,
              rvw03,rvw11,rvw12,rvw05f,rvw06f
         FROM rvw_file
        WHERE rvw08 = g_apb.apb21 AND rvw09 = g_apb.apb22
      FOREACH p110_apk_curs2
         INTO l_apk.apk03,l_apk.apk05,l_apk.apk29,l_apk.apk08,l_apk.apk07,
              l_apk.apk28,l_apk.apk30,
              l_apk.apk11,l_apk.apk12,l_apk.apk13,l_apk.apk08f,l_apk.apk07f
         SELECT COUNT(*) INTO l_n FROM apk_file
          WHERE apk03 = l_apk.apk03
         IF l_n > 0 THEN CONTINUE FOREACH END IF
         IF l_apk.apk08  IS NULL THEN LET l_apk.apk08 = 0 END IF
         IF l_apk.apk07  IS NULL THEN LET l_apk.apk07 = 0 END IF
         IF l_apk.apk08f IS NULL THEN LET l_apk.apk08f= 0 END IF
         IF l_apk.apk07f IS NULL THEN LET l_apk.apk07f= 0 END IF
         LET l_apk.apk08 = l_apk.apk08 * -1
         LET l_apk.apk07 = l_apk.apk07 * -1
         LET l_apk.apk08f= l_apk.apk08f* -1
         LET l_apk.apk07f= l_apk.apk07f* -1
         LET l_apk.apk06 = l_apk.apk08 +l_apk.apk07
         LET l_apk.apk06f= l_apk.apk08f+l_apk.apk07f
         IF l_apk.apk29 > 0 THEN LET l_apk.apk172 = 'S' END IF
         IF l_apk.apk06 = 0 THEN CONTINUE FOREACH END IF
         LET l_apk.apklegal = g_legal         #FUN-980001 add
         LET l_trtype = trtype[1,g_doc_len]
         SELECT apyvcode INTO l_apk.apk32 FROM apy_file WHERE apyslip = l_trtype
           IF cl_null(l_apk.apk32) THEN
              LET l_apk.apk32 = g_apz.apz63   #FUN-970108 add
           END IF 
         INSERT INTO apk_file VALUES(l_apk.*)
           IF STATUS THEN
              LET g_success='N'
              LET g_showmsg=l_apk.apk01,"/",l_apk.apk02,"/",l_apk.apk03
              CALL s_errmsg("apk01,apk02,apk03",g_showmsg,"ins apk #2:",SQLCA.sqlcode,1)
              CONTINUE FOREACH
         END IF
      END FOREACH
   END IF
 
END FUNCTION
 
#CHI-A90002 add --start--
FUNCTION p110_apa05(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1
   DEFINE l_pmc05   LIKE pmc_file.pmc05
   DEFINE l_pmcacti LIKE pmc_file.pmcacti

   SELECT pmc05,pmcacti
     INTO l_pmc05,l_pmcacti
     #FROM pmc_file WHERE pmc01 = g_apa.apa05   #MOD-D60145
     FROM pmc_file WHERE pmc01=g_vendor          #MOD-D60145

   LET g_errno = ' '

   CASE
      WHEN l_pmcacti = 'N'            LET g_errno = '9028'
      WHEN l_pmcacti MATCHES '[PH]'   LET g_errno = '9038'
     
      WHEN l_pmc05   = '0'            LET g_errno = 'aap-032'        
      WHEN l_pmc05   = '3'            LET g_errno = 'aap-033' 
 
      WHEN STATUS=100 LET g_errno = '100'
      WHEN SQLCA.SQLCODE != 0
         LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE

   IF NOT cl_null(g_errno) THEN
      RETURN
   END IF

   IF p_cmd='d' THEN
      RETURN
   END IF

END FUNCTION
#CHI-A90002 add --end--

FUNCTION p110_apa36(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
   DEFINE l_apr02 LIKE apr_file.apr02
   DEFINE l_aps   RECORD LIKE aps_file.*
   DEFINE l_depno     LIKE apa_file.apa22    #FUN-660117
   DEFINE l_d_actno   LIKE apa_file.apa51    #FUN-660117
   DEFINE l_c_actno   LIKE apa_file.apa54    #FUN-660117
   DEFINE l_e_actno   LIKE apa_file.apa511   #No.FUN-680029
   DEFINE l_f_actno   LIKE apa_file.apa541   #No.FUN-680029
   DEFINE l_apracti   LIKE apr_file.apracti  #MOD-CC0070 add
   DEFINE l_aptacti   LIKE apt_file.aptacti  #MOD-CC0070 add
 
   LET g_errno = ' '
 
  #SELECT apr02 INTO l_apr02 FROM apr_file #MOD-CC0070 mark
  #MOD-CC0070 add start -----
   SELECT apr02,apracti INTO l_apr02,l_apracti 
     FROM apr_file
  #MOD-CC0070 add end   -----
    WHERE apr01 = g_apa.apa36
 
   CASE
      WHEN SQLCA.SQLCODE = 100
         LET g_errno = 'aap-044'
      WHEN l_apracti = 'N' LET g_errno = 'ams-106'   #MOD-CC0070 add
      WHEN SQLCA.SQLCODE != 0
         LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
 
   IF NOT cl_null(g_errno) THEN
      LET l_apr02 = ''
   END IF
 
   DISPLAY l_apr02 TO apr02
 
   IF p_cmd = 'd' THEN
      RETURN
   END IF
 
   IF g_apz.apz13 = 'Y' THEN
      LET l_depno = g_apa.apa22
   ELSE
      LET l_depno = ' '
   END IF
 
   IF g_apz.apz13 = 'Y' THEN #No.TQC-770051
      SELECT * INTO l_aps.* FROM aps_file WHERE aps01 = l_depno
      IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","aps_file",l_depno,"","aap-053","","",1)   #No.FUN-660122
         RETURN
      END IF
   END IF #No.TQC-770051
 
  #SELECT apt03,apt04 INTO l_d_actno,l_c_actno FROM apt_file #MOD-CC0070 mark
  #MOD-CC0070 add start -----
   SELECT apt03,apt04,aptacti INTO l_d_actno,l_c_actno,l_aptacti
     FROM apt_file
  #MOD-CC0070 add end   -----
    WHERE apt01 = g_apa.apa36
      AND apt02 = l_depno
   #MOD-CC0070 add start -----
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-044'
        WHEN l_aptacti = 'N' LET g_errno = 'ams-106'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
   #MOD-CC0070 add end   -----
   IF SQLCA.sqlcode THEN
      LET l_d_actno = l_aps.aps21
      LET l_c_actno = l_aps.aps22
   END IF
   IF g_aza.aza63 = 'Y' THEN
      SELECT apt031,apt041 INTO l_e_actno,l_f_actno FROM apt_file
       WHERE apt01 = g_apa.apa36
         AND apt02 = l_depno
      IF SQLCA.sqlcode THEN
         LET l_e_actno = l_aps.aps211
         LET l_f_actno = l_aps.aps221
      END IF
   END IF
 
   IF g_apy.apydmy5 = 'Y' THEN
      LET g_apa.apa51 = '    '  #--有作預算控管則以單身科目為分錄科目,單頭須空白
   ELSE
      LET g_apa.apa51 = l_d_actno
      IF g_aza.aza63 = 'Y' THEN
         LET g_apa.apa511 = l_e_actno
      END IF
   END IF
   LET g_apa51_o = g_apa.apa51   #MOD-740489 add
   LET g_apa511_o= g_apa.apa511  #MOD-740489 add
 
  #LET g_apa.apa54 = l_c_actno   #MOD-B10080 mark
   LET g_apa54 = l_c_actno       #MOD-B10080
   IF g_aza.aza63 = 'Y' THEN
     #LET g_apa.apa541 = l_f_actno  #MOD-B10080 mark
      LET g_apa541 = l_f_actno      #MOD-B10080
   END IF
   LET g_flag2 = 'Y'             #MOD-B10080
 
END FUNCTION
 
FUNCTION p110_apa21(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
   DEFINE l_gen03   LIKE gen_file.gen03
   DEFINE l_genacti LIKE gen_file.genacti
 
   SELECT gen03,genacti INTO l_gen03,l_genacti
     FROM gen_file
    WHERE gen01 = g_apa.apa21
 
   LET g_errno = ' '
 
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-038'
        WHEN l_genacti = 'N'     LET g_errno = '9028'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
 
   IF NOT cl_null(g_errno) THEN
      RETURN
   END IF
 
   LET g_apa.apa22 = l_gen03
   DISPLAY BY NAME g_apa.apa22
 
END FUNCTION
 
FUNCTION p110_apa22(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
   DEFINE l_gemacti LIKE gem_file.gemacti
 
   SELECT gemacti INTO l_gemacti
     FROM gem_file
    WHERE gem01 = g_apa.apa22
 
   LET g_errno = ' '
 
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-039'
        WHEN l_gemacti = 'N'     LET g_errno = '9028'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
 
   IF NOT cl_null(g_errno) THEN
      RETURN
   END IF
 
END FUNCTION
 
FUNCTION p110_prepaid_off()
   DEFINE l_apa            RECORD LIKE apa_file.*
   DEFINE l_apv            RECORD LIKE apv_file.*
   DEFINE l_apc            RECORD LIKE apc_file.* #No.FUN-680027
   DEFINE l_cnt            LIKE type_file.num5    #No.FUN-690028 SMALLINT               #No.FUN-680027
   DEFINE l_n              LIKE type_file.num5    #No.FUN-690028 SMALLINT               #No.FUN-680027
   DEFINE l_apc13          LIKE apc_file.apc13    #No.FUN-680027
   DEFINE l_amt1f,l_amt1   LIKE type_file.num20_6 #No.FUN-690028 DEC(20,6)              #No.FUN-680027
   DEFINE l_amt2f,l_amt2   LIKE type_file.num20_6 #No.FUN-690028 DEC(20,6)              #No.FUN-680027
   DEFINE g_amt1f,g_amt1   LIKE type_file.num20_6 #No.FUN-690028 DEC(20,6)  #FUN-4B0079
   DEFINE g_amt2f,g_amt2   LIKE type_file.num20_6 #No.FUN-690028 DEC(20,6)  #FUN-4B0079
   DEFINE g_amt3f,g_amt3   LIKE type_file.num20_6 #No.MOD-B60198 add
   DEFINE g_amt4f,g_amt4   LIKE type_file.num20_6 #No.MOD-B60198 add
   DEFINE l_diff_apv02     LIKE apv_file.apv02    #No.MOD-590440
   DEFINE l_diff_apv04f    LIKE apv_file.apv04f   #No.MOD-590440
   DEFINE l_diff_apv04     LIKE apv_file.apv04    #No.MOD-590440
   DEFINE l_apk08          LIKE apk_file.apk08    #No.TQC-740288
   DEFINE l_apk08f         LIKE apk_file.apk08f   #No.TQC-740288
   DEFINE l_apk08_s        LIKE apk_file.apk08    #No.TQC-740288
   DEFINE l_apk08f_s       LIKE apk_file.apk08f   #No.TQC-740288
   DEFINE l_apv04f_sum     LIKE apv_file.apv04f   #No.MOD-920204
   DEFINE l_apv04_sum      LIKE apv_file.apv04    #No.MOD-920204
   DEFINE l_apv04f_z       LIKE apv_file.apv04f   #No.MOD-C30800
   DEFINE l_flag_off       LIKE type_file.chr1    #No:FUN-C80047 add
   DEFINE l_apa34f         LIKE apa_file.apa34f   #No:FUN-C80047 add
   DEFINE l_rvv36          LIKE rvv_file.rvv36    #MOD-D30007 add
   DEFINE l_rvv37          LIKE rvv_file.rvv37    #MOD-D30007 add
   DEFINE l_apb10          LIKE apb_file.apb10    #MOD-D30007 add
   DEFINE l_apb10_sum      LIKE apb_file.apb10    #MOD-D30007 add
   DEFINE l_apb24          LIKE apb_file.apb24    #MOD-D30007 add
   DEFINE l_apb24_sum      LIKE apb_file.apb24    #MOD-D30007 add
   DEFINE l_sql            STRING                 #MOD-D30007 add
 
   IF prepaid_off_sw = 'Y' THEN            # 若要自動將預付款依 P/O# 帶出沖銷
      LET l_apa34f = g_apa.apa34f #FUN-C80047 add
      DECLARE p110_kkk_c0 CURSOR FOR
         SELECT apa_file.*,apc_file.* FROM apa_file,apc_file #No.FUN-680027 新增apc_file
          WHERE apa06 = g_apa.apa06
            AND apc01 = apa01         #No.FUN-680027 add
            AND ((apa07=g_apa.apa07 AND apa06!='MISC') OR apa06='MISC')  #MOD-960081
            AND apa00 = "23"
            AND apa13 = g_apa.apa13   # 幣別必須相同
            AND apa41 = 'Y'
            AND apa42 != 'Y'
            AND apa34f > apa35f
            ORDER BY apa02   #FUN-C80047 add
 
      INITIALIZE l_apv.* TO NULL
      LET l_apv.apv02 = 0
 
      SELECT COUNT(*) INTO l_cnt FROM apa_file,apc_file
       WHERE apa06 = g_apa.apa06
         AND apa01 = apc01
         AND ((apa07=g_apa.apa07 AND apa06!='MISC') OR apa06='MISC')  #MOD-960081
         AND apa00 = "23"
         AND apa13 = g_apa.apa13
         AND apa41 = 'Y'
         AND apa42 != 'Y'
         AND apa34f > apa35f
 
      LET l_n = 0
      LET l_apk08_s = 0    #No.TQC-740288
      LET l_apk08f_s = 0   #No.TQC-740288
 
      LET l_flag_off = '' #FUN-C80047 add
      FOREACH p110_kkk_c0 INTO l_apa.*,l_apc.*  #No.FUN-680027 新增l_apc
         DELETE FROM x  #MOD-9A0174      
         INSERT INTO x (po_no,seq)     #MOD-940154 add
         SELECT apb06,apb07  #MOD-890100 add apb07            #MOD-940152
           FROM apb_file,apa_file      # 回讀原預付請款檔取PO#
          WHERE apa01 = l_apa.apa08
            AND apa01 = apb01
       
         LET g_cnt = 0                                      #MOD-D30164 add
         SELECT COUNT(*) INTO g_cnt FROM x
         IF cl_null(g_cnt) THEN LET g_cnt = 0 END IF        #MOD-D30164 add
         IF g_apz.apz61 != '2' THEN                         #FUN-C80047 add
            IF g_cnt = 0 THEN      # 如果原預付沒有指定 P/O #
               CALL s_errmsg("apa01",l_apa.apa08,"","aap-996",0)
               CONTINUE FOREACH
            END IF
 
            IF g_cnt > 0 THEN           # 如果原預付有指定 P/O #
               SELECT MAX(po_no) INTO g_msg FROM x
              #------------------------MOD-D30164-------------(S)
              #--MOD-D30164--mark
              ###FUN-C70049---ADD---STR
              #IF g_aza.aza26='2' THEN                                              
              #SELECT COUNT(*) INTO g_cnt FROM apb_file,x
              # WHERE apb01 = g_apa.apa01
              #   AND apb06 = po_no 
              #ELSE                                                    
              ###FUN-C70049--ADD--END                           
              #   SELECT COUNT(*) INTO g_cnt FROM apb_file,x     
              #    WHERE apb01 = g_apa.apa01
              #      AND apb06 = po_no
              #      AND apb07 = seq           
              #END IF                                             #FUN-C70049	
              #IF g_cnt = 0 THEN
              #   CONTINUE FOREACH
              #END IF
              #--MOD-D30164--mark
               LET g_cnt = 0               
               SELECT COUNT(*) INTO g_cnt FROM apb_file,x
                WHERE apb01 = g_apa.apa01
                  AND apb06 = po_no
                  AND apb07 = seq           
               IF cl_null(g_cnt) THEN LET g_cnt = 0 END IF        
               IF g_cnt = 0 THEN
                  LET g_cnt = 0
                  SELECT COUNT(*) INTO g_cnt FROM apb_file,x
                   WHERE apb01 = g_apa.apa01
                     AND apb06 = po_no
                  IF cl_null(g_cnt) THEN LET g_cnt = 0 END IF
                  IF g_cnt = 0 THEN
                     CONTINUE FOREACH
                  END IF
               END IF                                                
              #------------------------MOD-D30164-------------(E)
            END IF
         END IF #FUN-C80047 add
         LET l_apv.apv01 = g_apa.apa01   #No.TQC-740288
         LET l_apv.apv02 = l_apv.apv02 + 1
         LET l_apv.apv03 = l_apc.apc01
         LET l_apv.apv04f = l_apc.apc08 - l_apc.apc10
        #IF g_apz.apz27 = 'N' THEN                       #MOD-B40045 mark
         IF g_apz.apz27 = 'N' OR g_apz.apz62 = 'Y' THEN  #MOD-B40045
            LET l_apv.apv04 = l_apc.apc09 - l_apc.apc11
         ELSE
            LET l_apv.apv04 = l_apc.apc13
         END IF
        #yinhy130826  --Mark Begin  #未考虑税额
        ##-------------------MOD-D30007----------------(S)
        ##部份沖銷時，應為實際入庫單所對應的採購單金額
        # LET l_apb10_sum = 0          
        # LET l_apb24_sum = 0
        # LET l_sql = "SELECT rvv36,rvv37",
        #             "  FROM rvv_file",
        #             " WHERE rvv01 = '",g_apb.apb21,"' "
        # PREPARE p110_rvv_prep1 FROM l_sql 
        # DECLARE p110_rvv_cs1 CURSOR FOR p110_rvv_prep1
        # FOREACH p110_rvv_cs1 INTO l_rvv36,l_rvv37
        #    LET l_apb10 = 0          
        #    LET l_apb24 = 0
        #    SELECT apb10,apb24 INTO l_apb10,l_apb24
        #      FROM apb_file  
        #     WHERE apb06 = l_rvv36
        #       AND apb07 = l_rvv37
        #       AND apb01 = g_apa.apa01
        #    IF cl_null(l_apb10) THEN LET l_apb10 = 0 END IF
        #    IF cl_null(l_apb24) THEN LET l_apb24 = 0 END IF
        #    LET l_apb10_sum = l_apb10_sum + l_apb10
        #    LET l_apb24_sum = l_apb24_sum + l_apb24
        # END FOREACH
        # IF l_apb10 > 0 AND l_apb10_sum < l_apv.apv04f THEN
        #    LET l_apv.apv04f = l_apb10_sum
        # END IF
        # IF l_apb24 > 0 AND l_apb24_sum < l_apv.apv04 THEN
        #    LET l_apv.apv04 = l_apb24_sum
        # END IF
        ##-------------------MOD-D30007----------------(E)
        #yinhy130826  --Mark End  #未考虑税额  
         LET l_apv.apv05 = l_apc.apc02
 
        #str MOD-A10022 mod
        #IF l_apv.apv04f > l_apc.apc08 THEN
        #   LET l_apv.apv04f= l_apc.apc08
        #   LET l_apv.apv04 = l_apv.apv04f * l_apc.apc06
        #   LET l_apv.apv04 = cl_digcut(l_apv.apv04,g_azi04)    #No.CHI-6A0004 t_azi-->g_azi   #MOD-780215
        #END IF
        #-MOD-AC0230-add-
         LET l_apk08 = 0     #MOD-B30013
         LET l_apk08f = 0    #MOD-B30013
         #SELECT apk08,apk08f INTO l_apk08,l_apk08f           #MOD-BB0053 ---Mark
         SELECT SUM(apk08),SUM(apk08f) INTO l_apk08,l_apk08f  #MOD-BB0053
           FROM apk_file,gec_file                         #MOD-B40052 add gec_file
          WHERE apk01 = l_apa.apa08
            AND gec01 = apk11                             #MOD-B40052
            AND gec011 = '1'                              #MOD-B40052
           #AND (gec04 NOT IN ('4','X') OR gec08 <> 'XX') #MOD-B40052 #MOD-C60222 mark
            AND (gec05 NOT IN ('4','X') OR gec08 <> 'XX') #MOD-C60222 add
         IF cl_null(l_apk08) THEN
            LET l_apk08 = 0
         END IF
         IF cl_null(l_apk08f) THEN
            LET l_apk08f = 0
         END IF
         LET l_apk08_s = l_apk08_s+l_apk08
         LET l_apk08f_s = l_apk08f_s+l_apk08f
        #---------------MOD-C30800---------------start  #計算本次立帳已被撈出來沖帳的預付原幣
         LET l_apv04f_z = 0
        #SELECT apv04f INTO l_apv04f_z             #MOD-C70248 mark
         SELECT SUM(apv04f) INTO l_apv04f_z        #MOD-C70248 add
           FROM apv_file
          WHERE apv01 = l_apv.apv01
         IF cl_null(l_apv04f_z) THEN
            LET l_apv04f_z = 0
         END IF
        #--------------MOD-C30800------------------end
        #-MOD-AC0230-end-
        #若此次立帳金額小於預付金額,沖帳金額應寫入此次立帳金額
        #IF l_apv.apv04f > g_apa.apa34f THEN                    #MOD-AC0230 mark
        #IF l_apv.apv04f > g_apa.apa34f + l_apk08f_s THEN                #MOD-AC0230 #MOD-C30800 mark
         IF l_apv.apv04f > g_apa.apa34f + l_apk08f_s -l_apv04f_z THEN    #MOD-C30800 add
           #LET l_apv.apv04f= g_apa.apa34f                      #MOD-AC0230 mark 
           #LET l_apv.apv04f= g_apa.apa34f + l_apk08f_s                  #MOD-AC0230 #MOD-C30800 mark
            LET l_apv.apv04f= g_apa.apa34f + l_apk08f_s - l_apv04f_z     #MOD-C30800 add
            IF g_apz.apz61 = '2' THEN LET l_apv.apv04f = g_apa.apa34f END IF #FUN-C80047 add            
            LET l_apv.apv04 = l_apv.apv04f * l_apa.apa14  
            #No.yinhy131218  --Begin
            IF g_apz.apz27 = 'Y' AND l_apa.apa13 !=g_aza.aza17 THEN
               LET l_apv.apv04 = l_apv.apv04f * l_apa.apa72  
            END IF 	 
            #No.yinhy131218  --End         
            LET l_apv.apv04 = cl_digcut(l_apv.apv04,g_azi04)
            #FUN-C80047 add--str
            IF g_apz.apz61 = '2' THEN 
               LET l_flag_off = '1'
            END IF 
            #FUN-C80047--add--end
         END IF
        #end MOD-A10022 mod
        #CHI-A30035---add---start---
        #IF l_apa.apa34f > 0 THEN                            #MOD-A70131 mark
        #IF l_apa.apa34f > 0 AND g_apa.apa34f = 0 THEN       #MOD-A70131 add            #MOD-D30007 mark
         IF l_apa.apa34f > 0 AND g_apa.apa34f = 0 AND l_apv.apv04f > l_apa.apa34f THEN  #MOD-D30007 
            LET l_apv.apv04f= l_apa.apa34f
            LET l_apv.apv04 = l_apv.apv04f * l_apa.apa14
            #No.yinhy131218  --Begin
            IF g_apz.apz27 = 'Y' AND l_apa.apa13 !=g_aza.aza17 THEN
               LET l_apv.apv04 = l_apv.apv04f * l_apa.apa72  
            END IF 	 
            #No.yinhy131218  --End  
            LET l_apv.apv04 = cl_digcut(l_apv.apv04,g_azi04)
            #FUN-C80047 add--str
            IF g_apz.apz61 = '2' THEN
               LET l_flag_off = '2'
            END IF
            #FUN-C80047--add--end
         END IF
        #MOD-A30035---add---end---
        #str MOD-B60220 add
        #若此次立帳金額小於預付金額,但預付金額大於入庫單金額,應以入庫單金額為準
        #IF l_apv.apv04f > g_apa.apa34f AND l_apv.apv04f > g_apa.apa57f THEN                        #MOD-D30007 mark
         IF l_apv.apv04f > g_apa.apa34f AND l_apv.apv04f > g_apa.apa57f AND g_apa.apa34f <> 0 THEN  #MOD-D30007
            #LET l_apv.apv04f= g_apa.apa57f - g_apa.apa34f  #MOD-C30592 mark
            LET l_apv.apv04f= g_apa.apa34f                  #MOD-C30592
            LET l_apv.apv04 = l_apv.apv04f * l_apa.apa14
            #No.yinhy131218  --Begin
            IF g_apz.apz27 = 'Y' AND l_apa.apa13 !=g_aza.aza17 THEN
               LET l_apv.apv04 = l_apv.apv04f * l_apa.apa72  
            END IF 	 
            #No.yinhy131218  --End
            LET l_apv.apv04 = cl_digcut(l_apv.apv04,g_azi04)
            LET l_apk08_s = l_apv.apv04
            LET l_apk08f_s= g_apa.apa57f - g_apa.apa34f
            #FUN-C80047 add--str
            IF g_apz.apz61 = '2' THEN
               LET l_flag_off = '1'
            END IF
            #FUN-C80047--add--end
         END IF
        #end MOD-B60220 add
 
         LET l_apv.apvlegal = g_legal         #FUN-980001 add
         #FUN-C80047-add--str
         IF l_flag_off = '2' AND g_apz.apz61 = '2' THEN 
            RETURN
         END IF 
         #FUN-C80046-add--end
         INSERT INTO apv_file VALUES (l_apv.*)  #FUN-960141
         IF g_apz.apz61 = '2' THEN #FUN-C80047 add
            LET g_apa.apa34f = g_apa.apa34f - l_apv.apv04f #FUN-C80047 add
         END IF #FUN-C80047 add
         IF STATUS THEN
            LET g_showmsg=l_apv.apv01,"/",l_apv.apv02
            CALL s_errmsg("apv01,apv02",g_showmsg,"insert apv_file",SQLCA.sqlcode,0)
         END IF
 
         SELECT sum(aph05f),sum(aph05) INTO l_amt1f,l_amt1
           FROM aph_file,apf_file
          WHERE aph01 = l_apc.apc01
            AND aph17 = l_apc.apc02
            AND aph01 = apf01
            AND apf41 = 'Y'
            AND aph03 IN ('6','7','8','9')
 
         IF l_amt1f IS NULL THEN
            LET l_amt1f = 0
            LET l_amt1 = 0
         END IF
 
         SELECT sum(apv04f),sum(apv04) INTO l_amt2f,l_amt2
           FROM apv_file
          WHERE apv03 = l_apc.apc01
            AND apv05 = l_apc.apc02
 
         IF l_amt2f IS NULL THEN
            LET l_amt2f = 0
            LET l_amt2 = 0
         END IF
 
         LET l_amt1f = l_amt1f + l_amt2f
         LET l_amt1 = l_amt1 + l_amt2
 
         LET l_apc13 = l_apc.apc13-(l_apc.apc09-l_apc.apc11)
 
         LET l_amt1f = cl_digcut(l_amt1f,t_azi04)
         LET l_amt1 = cl_digcut(l_amt1,g_azi04)
         LET l_apc13 = cl_digcut(l_apc13,g_azi04)
 
         UPDATE apc_file SET apc10  = l_amt1f,
                             apc11  = l_amt1,
                             apc13  = apc09 - l_amt1 + l_apc13
          WHERE apc01 = l_apc.apc01
            AND apc02 = l_apc.apc02
         IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
            LET g_success = 'N'
            LET g_showmsg=l_apc.apc01,"/",l_apc.apc02
            CALL s_errmsg("apc01,apc02",g_showmsg,"upd prepaidapa23",SQLCA.sqlcode,1)
         END IF
 
         SELECT sum(aph05f),sum(aph05) INTO g_amt1f,g_amt1
           FROM aph_file,apf_file
          WHERE aph04 = l_apa.apa01
            AND aph01 = apf01
            AND apf41 = 'Y'
            AND aph03 IN ('6','7','8','9')
 
         IF g_amt1f IS NULL THEN
            LET g_amt1f = 0
            LET g_amt1 = 0
         END IF
 
         SELECT sum(apv04f),sum(apv04) INTO g_amt2f,g_amt2
           FROM apv_file
          WHERE apv03 = l_apa.apa01
 
         IF g_amt2f IS NULL THEN
            LET g_amt2f = 0
            LET g_amt2 = 0
         END IF
#-------------------------------No.MOD-B60198------------------------add
         SELECT SUM(oob09),SUM(oob10) INTO g_amt3f,g_amt3
           FROM oob_file,ooa_file
          WHERE oob01 = ooa01
            AND oob06 = l_apa.apa01
            AND oob03 = '2' AND oob04 = '9'
            AND ooaconf = 'Y'

         IF cl_null(g_amt3f) THEN
            LET g_amt3f = 0
            LET g_amt3 = 0
         END IF

         SELECT SUM(aqb04) INTO g_amt4
           FROM aqa_file,aqb_file
          WHERE aqa01 = aqb01
            AND aqa04='Y'
            AND aqaconf = 'Y'
            AND aqb02=l_apa.apa01

         IF cl_null(g_amt4) THEN
            LET g_amt4=0
            LET g_amt4f=0
            END IF
         LET g_amt4f=g_amt4/l_apa.apa14

         LET g_amt1f=g_amt1f+g_amt2f+g_amt3f+g_amt4f
         LET g_amt1=g_amt1+g_amt2+g_amt3+g_amt4
        #LET g_amt1f = g_amt1f + g_amt2f             #No.MOD-B60198 mark
        #LET g_amt1 = g_amt1 + g_amt2                #No.MOD-B60198 mark
#-------------------------------No.MOD-B60198------------------------end

         CALL p110_comp_oox(l_apa.apa01) RETURNING g_net
         UPDATE apa_file SET apa35f = g_amt1f,
                             apa35  = g_amt1,
                             apa73  = apa34 - g_amt1 + g_net
          WHERE apa01 = l_apa.apa01
         IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
            LET g_success = 'N'
            CALL s_errmsg("apa01",l_apa.apa01,"",SQLCA.sqlcode,1)
         END IF
 
        #-MOD-AC0230-mark-
        #SELECT apk08,apk08f INTO l_apk08,l_apk08f
        #  FROM apk_file
        # WHERE apk01 = l_apa.apa08
        #IF cl_null(l_apk08) THEN
        #   LET l_apk08 = 0
        #END IF
        #IF cl_null(l_apk08f) THEN
        #   LET l_apk08f = 0
        #END IF
        #LET l_apk08_s = l_apk08_s+l_apk08
        #LET l_apk08f_s = l_apk08f_s+l_apk08f
        #-MOD-AC0230-end-
        #FUN-C80047-add--str
        IF l_flag_off = '1' AND g_apz.apz61 = '2'  THEN 
           EXIT FOREACH
        END IF 
        #FUN-C80047-add--end

      END FOREACH   #No.MOD-640547
      #FUN-C80047 add--str
      IF g_apz.apz61 = '2' THEN 
         LET g_apa.apa34f = l_apa34f 
      END IF 
      #FUN-C80047--add--end
      LET l_diff_apv04 = 0
      SELECT SUM(apv04f),SUM(apv04)          
        INTO l_apv04f_sum,l_apv04_sum       
        FROM apv_file WHERE apv01 = l_apv.apv01
      IF cl_null(l_apv04_sum)  THEN LET l_apv04_sum = 0 END IF 
      IF cl_null(l_apv04f_sum) THEN LET l_apv04f_sum= 0 END IF 
     
     #-----------------------MOD-C70248---------------(S)
      IF l_apk08f_s > l_apv04f_sum THEN
         LET l_apk08f_s = l_apv04f_sum
         LET l_apk08_s = l_apv04_sum
      END IF
     #-----------------------MOD-C70248---------------(E)

      IF l_apv04_sum != cl_digcut(l_apv04f_sum*g_apa.apa14,g_azi04) THEN
         LET l_diff_apv04 = cl_digcut(l_apv04f_sum*g_apa.apa14,g_azi04) - l_apv04_sum
      END IF 
     
     #CHI-A30035---mark---start---
     #IF g_apa.apa31f = l_apv04f_sum THEN 
     #   LET l_diff_apv04 = l_diff_apv04 + g_apa.apa31-l_apv04_sum
     #END IF 
     #CHI-A30035---mark---end---
      IF l_diff_apv04 <> 0 THEN      #No.MOD-920204
         LET l_diff_apv02 = l_apv.apv02 + 1
         LET l_apv.apvlegal = g_legal         #FUN-980001
         INSERT INTO apv_file(apv01,apv02,apv03,apv04f,apv04,apvlegal) #FUN-980001 add apvlegal
                       VALUES(l_apv.apv01,l_diff_apv02,'DIFF',0,l_diff_apv04,l_apv.apvlegal) #FUN-980001 add apvlegal
         IF SQLCA.sqlcode THEN
            IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
               UPDATE apv_file SET apv04 = l_diff_apv04
                WHERE apv01=l_apv.apv01
                  AND apv03='DIFF'
               IF STATUS OR SQLCA.sqlerrd[3]=0 THEN    #TQC-630174
                  LET g_success = 'N'
                  LET g_showmsg=l_apv.apv01,"/","DIFF"
                  CALL s_errmsg("apv01,apv03",g_showmsg,"",SQLCA.sqlcode,1)
               END IF
            ELSE
               LET g_success = 'N'
               LET g_showmsg=l_apv.apv01,"/",l_diff_apv02
               CALL s_errmsg("apv01,apv02",g_showmsg,"insert diff",SQLCA.sqlcode,1)
            END IF
         END IF
      END IF
 
      SELECT SUM(apv04f),SUM(apv04)
        INTO g_apa.apa65f,g_apa.apa65
        FROM apv_file
       WHERE apv01 = g_apa.apa01
 
      IF cl_null(g_apa.apa65f) THEN
         LET g_apa.apa65f = 0
      END IF
 
      IF cl_null(g_apa.apa65) THEN
         LET g_apa.apa65 = 0
      END IF
 

#No.TQC-B60326 --begin 
#      LET g_apa.apa31f = g_apa.apa31f + l_apk08f_s
#     #CHI-A30035---modify---start---
#     #LET g_apa.apa31 = g_apa.apa31 + l_apk08_s
#      IF l_apv.apv04f = l_apk08f_s THEN
#         LET g_apa.apa31 = g_apa.apa31 + l_apk08_s + l_diff_apv04
#      ELSE
#         LET g_apa.apa31 = g_apa.apa31 + l_apk08_s
#      END IF
#     #CHI-A30035---modify---end---
      IF g_aza.aza26 <>'2' THEN 
         LET g_apa.apa31f = g_apa.apa31f + l_apk08f_s
         IF l_apv.apv04f = l_apk08f_s THEN
            LET g_apa.apa31 = g_apa.apa31 + l_apk08_s + l_diff_apv04
         ELSE
            LET g_apa.apa31 = g_apa.apa31 + l_apk08_s
         END IF
      END IF 
#No.TQC-B60326 --end 
      LET g_apa.apa34f= g_apa.apa31f+g_apa.apa32f-g_apa.apa65f
      LET g_apa.apa34 = g_apa.apa31 +g_apa.apa32 -g_apa.apa65
 
      LET g_apa.apa33f = g_apa.apa31f - g_apa.apa57f
      LET g_apa.apa33 = g_apa.apa31 - g_apa.apa57
 
      IF g_apa.apa31f <> g_apa.apa57f + g_apa.apa60f OR
         g_apa.apa31 <> g_apa.apa57 + g_apa.apa60  OR g_apa.apa31 = 0 THEN
         LET g_apa.apa56 = '1'
         LET g_apa.apa19 = g_apz.apz12
         LET g_apa.apa20 = g_apa.apa31f + g_apa.apa32f-g_apa.apa65f
      ELSE
         LET g_apa.apa56 = '0'
         LET g_apa.apa19 = NULL
         LET g_apa.apa20 = 0
      END IF
     
      #TQC-AB0200--------add-------str------------------
      IF g_apa.apa33 = 0  THEN
         LET g_apa.apa56 = '0'
      END IF
      #TQC-AB0200--------add-------end------------------ 
 
      IF g_apa.apa13 != g_aza.aza17 AND g_apa.apa65 != 0 THEN
         LET g_apa.apa34 = g_apa.apa34f * g_apa.apa14
         LET g_apa.apa34 = cl_digcut(g_apa.apa34,g_azi04)                 #No.CHI-6A0004 t_azi-->g_azi   #MOD-780215
      END IF
 
      CALL p110_comp_oox(g_apa.apa01) RETURNING g_net
      LET g_apa.apa73 = g_apa.apa34-g_apa.apa35 + g_net
 
      LET g_apa.apa31  = cl_digcut(g_apa.apa31 ,g_azi04)
      LET g_apa.apa31f = cl_digcut(g_apa.apa31f,t_azi04)
      LET g_apa.apa33  = cl_digcut(g_apa.apa33 ,g_azi04)
      LET g_apa.apa33f = cl_digcut(g_apa.apa33f,t_azi04)
      LET g_apa.apa34  = cl_digcut(g_apa.apa34 ,g_azi04)
      LET g_apa.apa34f = cl_digcut(g_apa.apa34f,t_azi04)
      LET g_apa.apa65  = cl_digcut(g_apa.apa65 ,g_azi04)
      LET g_apa.apa65f = cl_digcut(g_apa.apa65f,t_azi04)
 
      UPDATE apa_file SET apa31f = g_apa.apa31f,
                          apa31 = g_apa.apa31,
                          #-----TQC-710087---------
                          apa33f = g_apa.apa33f,
                          apa33 = g_apa.apa33,
                          apa56 = g_apa.apa56,
                          apa19 = g_apa.apa19,
                          apa20 = g_apa.apa20,
                          #-----END TQC-710087-----
                          apa34f = g_apa.apa34f,
                          apa34 = g_apa.apa34,
                          apa65f = g_apa.apa65f,
                          apa65 = g_apa.apa65,
                          apa73 = g_apa.apa73           #A059
        WHERE apa01 = g_apa.apa01
      IF STATUS OR SQLCA.sqlerrd[3]=0 THEN    #TQC-630174
         LET g_success = 'N'
         CALL s_errmsg("apa01",g_apa.apa01,"upd prepaidapa11",SQLCA.sqlcode,1)
      END IF
   END IF
 
END FUNCTION
 
FUNCTION p110_upd_rvb06()
   DEFINE l_qty    LIKE apb_file.apb09
   DEFINE l_qty1   LIKE apb_file.apb09          #No.MOD-520104
   DEFINE l_qty_rvv88        LIKE apb_file.apb09  #No.TQC-7B0083
   DEFINE l_qty_rvv23_rvv88  LIKE apb_file.apb09  #No.TQC-7B0083
   DEFINE l_rvb06  LIKE rvb_file.rvb06     #FUN-9C0001 

   #FUN-B50019 --begin
   IF cl_null(g_apb.apb04) OR cl_null(g_apb.apb05) THEN
      RETURN
   END IF
   #FUN-B50019 --end
   SELECT SUM(apb09) INTO l_qty
     FROM apb_file,apa_file
    WHERE apb04 = g_apb.apb04
      AND apb05 = g_apb.apb05
      AND apb01 = apa01
      AND apa00 = '11'
      AND apa42 != 'Y'
       AND apb29 = '1'  #No.8408   #No.MOD-520104 add apb29
 
   IF STATUS THEN
      LET g_showmsg=g_apb.apb04,"/",g_apb.apb05,"/","11","/","1"
      CALL s_errmsg("apb04,apb05,apa00,apb29",g_showmsg,"sum(apb09)",SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
 
   IF l_qty IS NULL THEN
      LET l_qty = 0
   END IF
 
   LET l_qty_rvv23_rvv88 = 0
   LET l_qty_rvv88       = 0
   SELECT SUM(apb09) INTO l_qty_rvv23_rvv88
     FROM apb_file,apa_file
    WHERE apb04 = g_apb.apb04
      AND apb05 = g_apb.apb05
      AND apb01 = apa01
      AND apa00 = '11'
      AND apa42 != 'Y'
      AND apb29 = '1'
      AND apb34 = 'Y'
   IF cl_null(l_qty_rvv23_rvv88) THEN LET l_qty_rvv23_rvv88 = 0 END IF
   SELECT SUM(apb09) INTO l_qty_rvv88
     FROM apb_file,apa_file
    WHERE apb04 = g_apb.apb04
      AND apb05 = g_apb.apb05
      AND apb01 = apa01
      AND apa00 = '16'
      AND apa42 != 'Y'
      AND apb29 = '1'
   IF cl_null(l_qty_rvv88) THEN LET l_qty_rvv88 = 0 END IF
 
   LET l_qty1 = 0

    LET l_rvb06 = l_qty-l_qty1+l_qty_rvv88-l_qty_rvv23_rvv88
   #LET g_sql = "UPDATE ",l_dbs CLIPPED,"rvb_file ",                #FUN-A50102 mark
    LET g_sql = "UPDATE ",cl_get_target_table(l_azp01,'rvb_file'),  #FUN-A50102
                "   SET rvb06 = '",l_rvb06,"' ",
                " WHERE rvb01 = '",g_apb.apb04,"' ",
                "   AND rvb02 = '",g_apb.apb05,"' "
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql          #FUN-A50102 
    CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql  #FUN-A50102 
    PREPARE upd_rvb06_pre FROM g_sql
    EXECUTE upd_rvb06_pre
   IF STATUS OR SQLCA.sqlerrd[3]=0 THEN    #TQC-630174
      LET g_showmsg=g_apb.apb04,"/",g_apb.apb05
      CALL s_errmsg("rvb01,rvb02",g_showmsg,"upd rvb06",SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
 
END FUNCTION
 
FUNCTION p110_chkdate()
  #DEFINE l_sql          varchar(1500)#No:FUN-690028 VARCHAR(1500) #MOD-B30649 mark
   DEFINE l_sql          STRING                #MOD-B30649
   DEFINE l_yy,l_mm      LIKE type_file.num5   #No.FUN-690028 SMALLINT#,
   DEFINE l_bdate        LIKE type_file.dat    #CHI-9A0021 add
   DEFINE l_edate        LIKE type_file.dat    #CHI-9A0021 add
   DEFINE l_correct      LIKE type_file.chr1   #CHI-9A0021 add
   DEFINE l_azw01        LIKE azw_file.azw01   #FUN-A60056 
   DEFINE l_wc2          STRING                #MOD-A70079
   DEFINE l_sql2         STRING                #FUN-BB0001 add
   DEFINE l_sql3         STRING                #MOD-D20116 add
   DEFINE l_year         LIKE type_file.num5   #MOD-C90027
   DEFINE l_month        LIKE type_file.num5   #MOD-C90027

#FUN-A60056--add--str--
   LET l_wc2= cl_replace_str(g_wc2,'azp','azw')
   LET l_sql = "SELECT azw01 FROM azw_file " ,
               " WHERE azwacti = 'Y' AND azw02 = '",g_legal,"'",
              #"   AND ",g_wc2 CLIPPED        #MOD-A70079 mark 
               "   AND ",l_wc2 CLIPPED        #MOD-A70079
   PREPARE sel_azw01 FROM l_sql
   DECLARE sel_azw CURSOR FOR sel_azw01
   FOREACH sel_azw INTO l_azw01
#FUN-A60056--add--end
     IF g_aza.aza26 = '2' THEN                                                                                                        
        LET l_sql = " SELECT UNIQUE YEAR(rvv09),MONTH(rvv09) ",
                   #"  FROM rvv_file,rvu_file,",   #FUN-A60056
                    "  FROM ",cl_get_target_table(l_azw01,'rvv_file'),",",   #FUN-A60056
                    "       ",cl_get_target_table(l_azw01,'rvu_file'),",",   #FUN-A60056
                    "       ",cl_get_target_table(l_azw01,'rva_file'),",",   #MOD-D20116 add
                    "       ",cl_get_target_table(l_azw01,'rvb_file'),",",   #MOD-D20116 add
                    "       ",cl_get_target_table(l_azw01,'pmm_file'),",",   #MOD-D20116 add
                    "       rvw_file ",
                    " WHERE ",g_wc CLIPPED,
                    "   AND ( YEAR(rvv09)  > YEAR('",g_apa02,"') ",
                    "    OR  (YEAR(rvv09)  = YEAR('",g_apa02,"') ",
                    "   AND   MONTH(rvv09) > MONTH('",g_apa02,"'))) ",
                    "   AND rvv87-rvv23-rvv88 > 0 ",
                    "   AND rvu01 = rvv01 AND rvuconf='Y' ",
                    "   AND rvv89 != 'Y' ",           #MOD-A50130 add
                    "   AND rvv25 != 'Y' ",           #MOD-A80230
                    "   AND rvu00 != '2' ",
                    "   AND rva00 = '1' ",            #MOD-D20116 add
                    "   AND rva01 = rvu02 ",          #MOD-D20116 add
                    "   AND rva01 = rvb01 ",          #MOD-D20116 add
                    "   AND rvb04 = pmm01 "           #MOD-D20116 add
       #--------------------MOD-D20116------------------------------------(S)
        LET l_sql3 = " SELECT UNIQUE YEAR(rvv09),MONTH(rvv09) ",
                     "  FROM ",cl_get_target_table(l_azw01,'rvv_file'),",",
                     "       ",cl_get_target_table(l_azw01,'rvu_file'),",",
                     "       ",cl_get_target_table(l_azw01,'rva_file'),",",
                     "       rvw_file ",
                     " WHERE ",g_wc CLIPPED,
                     "   AND ( YEAR(rvv09)  > YEAR('",g_apa02,"') ",
                     "    OR  (YEAR(rvv09)  = YEAR('",g_apa02,"') ",
                     "   AND   MONTH(rvv09) > MONTH('",g_apa02,"'))) ",
                     "   AND rvv87-rvv23-rvv88 > 0 ",
                     "   AND rvu01 = rvv01 AND rvuconf='Y' ",
                     "   AND rvv89 != 'Y' ",
                     "   AND rvv25 != 'Y' ",
                     "   AND rvu00 != '2' ",
                     "   AND rva00 = '2' ",
                     "   AND rva01 = rvu02 "
       #--------------------MOD-D20116------------------------------------(E)
     ELSE                                     
        LET l_year = NULL      #MOD-C90027
        LET l_month = NULL     #MOD-C90027
       #當月起始日與截止日
        #CALL s_azm(YEAR(g_apa02),MONTH(g_apa02)) RETURNING l_correct,l_bdate,l_edate   #CHI-9A0021 add #CHI-A70005 mark
        #CHI-A70005 add --start--
        IF g_aza.aza63 = 'Y' THEN
           CALL s_azmm(YEAR(g_apa02),MONTH(g_apa02),g_apz.apz02p,g_apz.apz02b) RETURNING l_correct,l_bdate,l_edate
        ELSE   
           CALL s_yp(g_apa02) RETURNING l_year,l_month                                  #MOD-C90027
          #CALL s_azm(YEAR(g_apa02),MONTH(g_apa02)) RETURNING l_correct,l_bdate,l_edate #MOD-C90027 mark
           CALL s_azm(l_year,l_month) RETURNING l_correct,l_bdate,l_edate               #MOD-C90027
        END IF
        #CHI-A70005 add --end--
                                                                                        
        LET l_sql = " SELECT UNIQUE YEAR(rvv09),MONTH(rvv09) ",
                   #FUN-A60056--mod--str--
                   #"  FROM rvv_file,rvu_file,rva_file,rvb_file,",
                    "  FROM ",cl_get_target_table(l_azw01,'rvv_file'),",",
                    "       ",cl_get_target_table(l_azw01,'rvu_file'),",",
                    "       ",cl_get_target_table(l_azw01,'rva_file'),",",
                    "       ",cl_get_target_table(l_azw01,'pmm_file'),",",          #MOD-D20116 add
                    "       ",cl_get_target_table(l_azw01,'rvb_file'),
                   #FUN-A60056--mod--end
                   #"       rvw_file ",                                 #MOD-A30022 mark 
                    "       LEFT OUTER JOIN rvw_file ON rvb22 = rvw01", #MOD-A30022 add  
                    " WHERE ",g_wc CLIPPED,
                    "   AND rvv09 NOT BETWEEN '",l_bdate,"' AND '",l_edate,"'",
                    "   AND rvv87-rvv23-rvv88 > 0 ", 
                    "   AND rvv04 = rvb01 AND rvv05 = rvb02",
                    "   AND rvv04 = rva01  ",
                    "   AND rvaconf !='X' ",        
                    "   AND rvb89 != 'Y' ",   #MOD-A50130 add
                    "   AND rvv25 != 'Y' ",   #MOD-A80230  
                    "   AND rvv89 != 'Y' ",   #MOD-B50074
                    "   AND rvu00 != '2' ",   #MOD-B60225 add
                    "   AND rvu01 = rvv01 AND rvuconf='Y' ",
                    "   AND (rvu27 = '1' OR rvu27 = ' ' OR rvu27 IS NULL) ",     #FUN-BB0001 add
                    "   AND rva00 = '1' ",                                       #MOD-D20116 add
                    "   AND rva01 = rvu02 ",                                     #MOD-D20116 add
                    "   AND rva01 = rvb01 ",                                     #MOD-D20116 add
                    "   AND rvb04 = pmm01 "                                      #MOD-D20116 add
    #FUN-BB0001 add START
        LET l_sql2 = " SELECT UNIQUE YEAR(rvv09),MONTH(rvv09) ",
                    "  FROM ",cl_get_target_table(l_azw01,'rvu_file'),",",
                    "       ",cl_get_target_table(l_azw01,'rvv_file'),"",
                    "       LEFT OUTER JOIN rvw_file ON rvv22 = rvw01",
                    " WHERE ",g_wc CLIPPED,
                    "   AND rvv09 NOT BETWEEN '",l_bdate,"' AND '",l_edate,"'",
                    "   AND rvv87-rvv23-rvv88 > 0 ",
                    "   AND rvv25 != 'Y' ",  
                    "   AND rvv89 != 'Y' ",
                    "   AND rvu00 != '2' ",
                    "   AND rvu01 = rvv01 AND rvuconf='Y' ",
                    "   AND rvu27  IN ('2','3','4') "
    #FUN-BB0001 add END 
       #--------------------MOD-D20116------------------------------------(S)
        LET l_sql3 = " SELECT UNIQUE YEAR(rvv09),MONTH(rvv09) ",
                     "  FROM ",cl_get_target_table(l_azw01,'rvv_file'),",",
                     "       ",cl_get_target_table(l_azw01,'rvu_file'),",",
                     "       ",cl_get_target_table(l_azw01,'rva_file'),",",
                     "       ",cl_get_target_table(l_azw01,'rvb_file'),
                     "       LEFT OUTER JOIN rvw_file ON rvb22 = rvw01",
                     " WHERE ",g_wc CLIPPED,
                     "   AND rvv09 NOT BETWEEN '",l_bdate,"' AND '",l_edate,"'",
                     "   AND rvv87-rvv23-rvv88 > 0 ",
                     "   AND rvv04 = rvb01 AND rvv05 = rvb02",
                     "   AND rvv04 = rva01  ",
                     "   AND rvaconf !='X' ",
                     "   AND rvb89 != 'Y' ",
                     "   AND rvv25 != 'Y' ",
                     "   AND rvv89 != 'Y' ",
                     "   AND rvu00 != '2' ",
                     "   AND rvu01 = rvv01 AND rvuconf='Y' ",
                     "   AND (rvu27 = '1' OR rvu27 = ' ' OR rvu27 IS NULL) ",
                     "   AND rva00 = '2' ",
                     "   AND rva01 = rvu02 "
       #--------------------MOD-D20116------------------------------------(E)
     END IF      #NO.MOD-830014
    #--------------------MOD-D20116---------------------(S)
     IF g_wc3 != ' 1=1' THEN
        LET l_sql = l_sql CLIPPED, ' AND ',g_wc3
     END IF
    #--------------------MOD-D20116---------------------(E)
     IF g_aza.aza26 = '2' THEN
        LET l_sql=l_sql CLIPPED," AND rvv03 = '1' ",
                                 " AND rvv01 = rvw08 AND rvv02 = rvw09 "       #No.MOD-540169
        LET l_sql3=l_sql3 CLIPPED," AND rvv03 = '1' ",                         #yinhy131106
                                 " AND rvv01 = rvw08 AND rvv02 = rvw09 "       #yinhy131106                         
    #FUN-C70073 mark START
    ##FUN-BB0001 add START
    #   LET l_sql2=l_sql2 CLIPPED," AND rvv03 = '1' ",
    #                            " AND rvv01 = rvw08 AND rvv02 = rvw09 "       #No.MOD-540169
    ##FUN-BB0001 add END
    #FUN-C70073 mark END
    #ELSE                                               #MOD-A30022 mark
    #   LET l_sql=l_sql CLIPPED," AND rvb22 = rvw01 "   #MOD-A30022 mark
     END IF
 
    #-MOD-B70100-add-
    #單價為0不立帳時,單價為0的入庫單不檢查
     IF enter_account='N' THEN
        LET l_sql = l_sql CLIPPED," AND rvv38 > 0 "
        IF NOT cl_null(l_sql2) THEN   #FUN-C70073 add
           LET l_sql2 = l_sql2 CLIPPED," AND rvv38 > 0 "   #FUN-BB0001 add
        END IF                        #FUN-C70073 add
     END IF   
    #-MOD-B70100-end-

     IF summary_sw = '1' THEN
       #-MOD-B30661-add-
        IF g_aza.aza26 = '2' THEN
           LET l_sql = l_sql CLIPPED,
                       "   AND rvw01 IS NOT NULL AND rvw01 != ' '",
                       "   AND rvv03 MATCHES '[13]'"
   #FUN-BB0001 add START
          #FUN-C70073 mark END
          #LET l_sql2 = l_sql2 CLIPPED,
          #            "   AND rvw01 IS NOT NULL AND rvw01 != ' '",
          #            "   AND rvv03 MATCHES '[13]'"
          #FUN-C70073 mark END
   #FUN-BB0001 add END
        ELSE 
       #-MOD-B30661-end-
           LET l_sql = l_sql CLIPPED,
                       "   AND rvb22 IS NOT NULL AND rvb22 != ' '",
                       "   AND rvv03 IN ('1','3') "
   #FUN-BB0001 add START
           LET l_sql2 = l_sql2 CLIPPED,
                       "   AND rvv22 IS NOT NULL AND rvv22 != ' '",
                       "   AND rvv03 IN ('1','3') "
   #FUN-BB0001 add END
        END IF      #MOD-B30661
     END IF
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql   #FUN-A60056
     CALL cl_parse_qry_sql(l_sql,l_azw01) RETURNING l_sql     #FUN-A60056 
     CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2           #FUN-BB0001 add
     CALL cl_parse_qry_sql(l_sql2,l_azw01) RETURNING l_sql2   #FUN-BB0001 add
     CALL cl_replace_sqldb(l_sql3) RETURNING l_sql3           #MOD-D20116 add
     CALL cl_parse_qry_sql(l_sql3,l_azw01) RETURNING l_sql3   #MOD-D20116 add
   #FUN-BB0001 add START
     IF NOT cl_null(l_sql2) THEN
        LET l_sql = l_sql CLIPPED , " UNION ALL ", l_sql2
     END IF
   #FUN-BB0001 add END
     LET l_sql = l_sql CLIPPED , " UNION ALL ", l_sql3  #MOD-D20116  add
     PREPARE p110_prechk FROM l_sql
     IF STATUS THEN
        CALL cl_err('Prepare chkdate: ',STATUS,1)
        LET l_flag='X' RETURN
     END IF
 
     DECLARE p110_chkdate CURSOR WITH HOLD FOR p110_prechk
 
     FOREACH p110_chkdate INTO l_yy,l_mm
        IF STATUS THEN CALL cl_err('foreach chkdate: ',STATUS,1)
           LET l_flag = 'X'
           EXIT FOREACH
        END IF
        LET l_flag = 'Y'
        EXIT FOREACH
     END FOREACH
  END FOREACH   #FUN-A60056 
END FUNCTION
 
FUNCTION p110_ins_api()
   DEFINE p_apa            RECORD LIKE apa_file.*
   DEFINE p_apb            RECORD LIKE apb_file.*
   DEFINE p_api            RECORD LIKE api_file.*
   DEFINE l_api            RECORD LIKE api_file.*  #No.FUN-680027 add
   DEFINE l_apc            RECORD LIKE apc_file.*  #No.FUN-680027 add
   DEFINE l_diff_api03     LIKE api_file.api03
   DEFINE l_diff_api05f    LIKE api_file.api05f
   DEFINE l_diff_api05     LIKE api_file.api05
   DEFINE l_diffamt        LIKE api_file.api05   #MOD-C20104
   DEFINE l_apa00          LIKE apa_file.apa00         #No.TQC-5B0220
   DEFINE l_apa13          LIKE apa_file.apa13
   DEFINE l_apa72          LIKE apa_file.apa72
   DEFINE l_apa73          LIKE apa_file.apa73
   DEFINE l_chkamt         LIKE apa_file.apa34f  #MOD-C20104
   DEFINE l_apa541         LIKE apa_file.apa541  #No.FUN-680029
   DEFINE l_apc13          LIKE apc_file.apc13   #No.FUN-680027 add
   DEFINE l_api03          LIKE api_file.api03   #MOD-C20104
   DEFINE l_api26          LIKE api_file.api26   #MOD-C20104
   DEFINE l_api05          LIKE api_file.api05   #No.FUN-680027
   DEFINE l_api05f         LIKE api_file.api05f  #No.FUN-680027
   DEFINE l_sumapi05f      LIKE api_file.api05f  #MOD-C20104
   DEFINE l_sumapi05       LIKE api_file.api05   #MOD-C20104
   DEFINE l_apa14          LIKE apa_file.apa14   #No.FUN-680027
   DEFINE l_amt            LIKE api_file.api05   #No.TQC-7B0083
   DEFINE l_amtf           LIKE api_file.api05f  #No.TQC-7B0083
   DEFINE l_apb10          LIKE api_file.api05   #No.TQC-7B0083
   DEFINE l_apb24          LIKE api_file.api05f  #No.TQC-7B0083
   DEFINE l_gec04          LIKE gec_file.gec04                                  
   DEFINE l_gec07          LIKE gec_file.gec07                                  
   DEFINE l_rvv38t         LIKE rvv_file.rvv38t                                 
   DEFINE l_rvw10          LIKE rvw_file.rvw10                                  
   DEFINE l_rvw12          LIKE rvw_file.rvw12                                  
   DEFINE l_apb24t         LIKE apb_file.apb24  
   DEFINE l_apb02          LIKE apb_file.apb02    #MOD-9C0144 add
   DEFINE l_apb09          LIKE apb_file.apb09    #MOD-9C0144 add
   DEFINE l_apb10_1        LIKE apb_file.apb10    #MOD-9C0144 add
   DEFINE l_apb24_1        LIKE apb_file.apb24    #MOD-9C0144 add
   DEFINE l_rvw01          STRING                #No.MOD-920204
   DEFINE l_apk03          LIKE apk_file.apk03   #No.MOD-920204
   DEFINE l_rvw03          LIKE rvw_file.rvw03   #MOD-980223 add         
   #No.CHI-A10006 add --start--
   DEFINE l_apa34          LIKE apa_file.apa34
   DEFINE l_apa34f         LIKE apa_file.apa34f
   DEFINE l_apa35          LIKE apa_file.apa35
   DEFINE l_apa35f         LIKE apa_file.apa35f
   #No.CHI-A10006 add --end--
   DEFINE l_apb21_o        LIKE apb_file.apb21   #MOD-C50137
   DEFINE l_apb22_o        LIKE apb_file.apb22   #MOD-C50137
   DEFINE l_sumapb09       LIKE apb_file.apb09   #MOD-C50137
   DEFINE l_othapb09       LIKE apb_file.apb09   #MOD-C90229 
   DEFINE l_sumapb24       LIKE apb_file.apb24   #MOD-C50137
   DEFINE l_sumapb10       LIKE apb_file.apb10   #MOD-C50137
   DEFINE l_oox07          LIKE oox_file.oox07   #yinhy130828
   DEFINE l_sumapi05_1     LIKE api_file.api05   #yinhy130828
   DEFINE l_sumapi05f_1    LIKE api_file.api05f  #yinhy130828
   DEFINE l_api40          LIKE api_file.api40   #CHI-E30030 add
   DEFINE l_cnt            LIKE type_file.num5   #C19102201-11486 add by sunxin  #add by xujw200423
   DEFINE l_apb23          LIKE apb_file.apb23   #C19102201-11486 add by sunxin  #add by xujw200423
   LET g_success = 'Y'
   LET g_sql = " SELECT apa_file.*,apb_file.* FROM apa_file,apb_file ",
               "  WHERE apa01 = apb01 ",
               "    AND apa01 ='",g_apa.apa01,"' ",
               "    AND apb34 = 'Y'   ",                    #No.TQC-7B0083
              #"  ORDER BY apa01,apb02 "              #MOD-C50137 mark
              #"  ORDER BY apa01,apb02,apb21,apb22 "  #MOD-C50137      #MOD-C90229 mark
               "  ORDER BY apa01,apb21,apb22,apb02 "  #MOD-C90229 
 
   PREPARE p110_preapi  FROM g_sql
   IF STATUS THEN
      LET g_showmsg=begin_no,"/",end_no,"/","UNAP"
      CALL s_errmsg("apa01,apa01,apa51",g_showmsg,"prepare",STATUS,0)
      RETURN
   END IF
 
   DECLARE p110_csapi CURSOR WITH HOLD FOR p110_preapi
 
   LET p_api.api02 = '2'
   LET p_api.api01 = g_apa.apa01   #No.TQC-7B0083
   LET l_apb21_o = ''   #MOD-C50137
   LET l_apb22_o = 0    #MOD-C50137
 
   FOREACH p110_csapi INTO p_apa.*,p_apb.*
      LET p_api.api01 = p_apa.apa01
      # 尋找該筆資料存在, 何筆暫估中.
      LET p_api.api26 = NULL
      LET p_api.api05f= NULL
      LET p_api.api05 = NULL
      LET p_api.api07 = NULL
      LET p_api.api04 = NULL
 
      IF g_aza.aza26 = '2' THEN    #使用功能別=2.大陸   #MOD-780145 add
        #---------------------MOD-C60155-------------mark
        #LET l_rvw01 = ''       
        #DECLARE p110_rvw01_cs CURSOR FOR 
        #  SELECT apk03 FROM apk_file 
        #   WHERE apk01 = p_apa.apa01
        #FOREACH p110_rvw01_cs INTO l_apk03
        #  IF cl_null(l_rvw01) THEN 
        #     LET l_rvw01 = "'",l_apk03 CLIPPED,"'"
        #  ELSE
        #     LET l_rvw01 = l_rvw01,",'",l_apk03 CLIPPED,"'"
        #  END IF
        #END FOREACH
        #IF cl_null(l_rvw01) THEN 
        #   LET l_rvw01 = "'",t_inv_no CLIPPED,"'"
        #END IF 
        #---------------------MOD-C60155-------------mark
        #LET g_sql = "SELECT apa00,apb01,apb02,apb09,apb23*rvw10,apb08*rvw10,apa22,apa54,apa541",  #No.MOD-9C0144 add          #MOD-AB0028 mark
        LET g_sql = "SELECT DISTINCT apa00,apb01,apb02,apb09,apb23*rvw10,apb08*rvw10,apa22,apa54,apa541",  #No.MOD-9C0144 add #MOD-AB0028  #MOD-C50054 mark  #yinhy130527还原
        #LET g_sql = "SELECT DISTINCT apa00,apb01,apb02,apb09,rvw05f,rvw05,apa22,apa54,apa541",    #MOD-C50054  #yinhy130527 mark
                     "      ,rvw10,rvw12,rvw03",  #MOD-980223 add   
                     "      ,apa34,apa34f,apa35,apa35f", #No.CHI-A10006 add
                     "  FROM apb_file,apa_file,rvw_file  ",
                     "WHERE apb21 = '",p_apb.apb21,"'",  #No.MOD-650120
                     "  AND apb22 = '",p_apb.apb22,"'",  #No.MOD-650120
                     "  AND apb21 = rvw08",              #No.TQC-760006
                     "  AND apb22 = rvw09",              #No.TQC-760006
                     "  AND rvw10 = ",p_apb.apb09,       #No.FUN-7B0024 add  
                    #"  AND rvw01 IN (",l_rvw01,") ",    #No.MOD-920204 #MOD-C60155 mark
                     "  AND rvw01 = '",p_apb.apb11,"'",  #MOD-C60155 add
                     "  AND apb01 = apa01",
                     "  AND apa42 = 'N'",   #未作廢      #MOD-860037 add
                     "  AND apa00 IN ('16','26') "       #No.TQC-7B0083
     #非大陸版的照原先的邏輯
      ELSE
         LET g_sql = "SELECT apa00,apb01,apb02,apb09,apb24,apb10,apa22,apa54,apa541", #No.FUN-680029 新增apa541      #MOD-9C0144 add apb02,apb09
                     "      ,apb09,apa14,apa15",  #MOD-980223 add            
                     "      ,apa34,apa34f,apa35,apa35f", #No.CHI-A10006 add
                     "  FROM apb_file,apa_file  ",
                     "WHERE apb21 = '",p_apb.apb21,"'",  #No.MOD-650120
                     "  AND apb22 = '",p_apb.apb22,"'",  #No.MOD-650120
                     "  AND apb01 = apa01",
                     "  AND apa42 = 'N'",   #未作廢      #MOD-860037 add
                     "  AND apa00 IN ('16','26') "       #No.TQC-7B0083
      END IF
      LET g_sql = g_sql , " AND apa41 = 'Y'  "      #NO.MOD-870055
      PREPARE p110_preapb00  FROM g_sql
      IF STATUS THEN
         LET g_showmsg=p_apb.apb21,"/",p_apb.apb22,"/","UNAP"
         CALL s_errmsg("apb21,apb22,apa08",g_showmsg,"prepare:",STATUS,0)
         CONTINUE FOREACH
      END IF
 
      DECLARE p110_csapb00 CURSOR WITH HOLD FOR p110_preapb00

      LET l_apb02 = ''     #MOD-9C0144 add
      LET l_apb09 = 0      #MOD-9C0144 add 
      FOREACH p110_csapb00 INTO l_apa00,p_api.api26,l_apb02,l_apb09,p_api.api05f,p_api.api05,p_api.api07,p_api.api04,l_apa541 #No.FUN-680029 新增l_apa541  #MOD-9C0144 add
                                ,l_rvw10,l_rvw12,l_rvw03   #MOD-980223 add   
                                ,l_apa34,l_apa34f,l_apa35,l_apa35f  #No.CHI-A10006 add
        #如果是退貨暫估的話，金額值變負數
         IF g_aza.aza63 = 'Y' THEN
            LET p_api.api041 = l_apa541
         END IF
         LET p_api.api03 = p_apb.apb02
         LET p_api.api06 = 'UNAP:',p_api.api26
      
         IF cl_null(p_apb.apb09) OR p_apb.apb09 = 0 THEN
            LET l_api.api05f = p_apb.apb24
            LET l_api.api05  = p_apb.apb10
         ELSE
            IF g_aza.aza26 <> '2' THEN   #MOD-C50054 add
               LET p_api.api05f = p_apb.apb23 * p_apb.apb09   #TQC-9C0102 mod
               LET p_api.api05  = p_apb.apb08 * p_apb.apb09   #TQC-9C0102 mod
            END IF                       #MOD-C50054 add
         END IF
      
       # LET g_sql = "SELECT gec04,gec07 FROM ",t_azp03 CLIPPED,"gec_file ",            #FUN-A50102 mark
         LET g_sql = "SELECT gec04,gec07 FROM ",cl_get_target_table(t_azp01,'gec_file'),#FUN-A50102  
                     " WHERE gec01 = '",l_rvw03,"' ",
                     "   AND gec011= '1'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102 
         CALL cl_parse_qry_sql(g_sql,t_azp01) RETURNING g_sql      #FUN-A50102
         PREPARE sel_gec04_pre2 FROM g_sql
         EXECUTE sel_gec04_pre2 INTO l_gec04,l_gec07
       # LET g_sql = "SELICT rvv38t FROM ",t_azp03 CLIPPED,"rvv_file ",                 #FUN-A50102 
        # LET g_sql = "SELICT rvv38t FROM ",cl_get_target_table(t_azp01,'rvv_file'),     #FUN-A50102 #No.TQC-B50144
         LET g_sql = "SELECT rvv38t FROM ",cl_get_target_table(t_azp01,'rvv_file'),     #TQC-B50144
                     " WHERE rvv01 = '",p_apb.apb21,"' ",
                     "   AND rvv02 = '",p_apb.apb22,"' "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql               #FUN-A50102
         CALL cl_parse_qry_sql(g_sql,t_azp01) RETURNING g_sql       #FUN-A50102
         PREPARE sel_rvv38t_pre FROM g_sql
         EXECUTE sel_rvv38t_pre INTO l_rvv38t
        #IF l_gec07 = 'Y' THEN                         #MOD-C50054 mark
         IF l_gec07 = 'Y' AND g_aza.aza26 <> '2' THEN  #MOD-C50054                                                 
            LET l_apb24t = l_rvv38t * l_rvw10                                    
            LET l_apb24t = cl_digcut(l_apb24t,t_azi04)                           
            LET p_api.api05f = l_apb24t/(1+l_gec04/100)                          
            LET p_api.api05  = p_api.api05f * l_rvw12  
         END IF
        #-MOD-BA0074-add-
         IF g_chkdiff = 'Y' THEN             
            LET p_api.api05f = p_apb.apb24  
            LET p_api.api05  = p_apb.apb10 
         END IF
        #-MOD-BA0074-end-
         LET l_apb10_1 = 0
         LET l_apb24_1 = 0
#        SELECT apb10,apb24 INTO l_apb10,l_apb24 FROM apb_file WHERE apb01=p_api.api26 AND apb02=l_apb02
         SELECT apb10,apb24 INTO l_apb10_1,l_apb24_1 FROM apb_file WHERE apb01=p_api.api26 AND apb02=l_apb02   #No.MOD-A70137
         IF g_aza.aza26 <> '2' THEN LET l_apb09 = p_apb.apb09 END IF        #MOD-BA0074
         IF l_rvw10 = l_apb09 OR l_rvw10 = l_apb09*-1 THEN   #No.MOD-AC0423 #CHI-B40052 mark #MOD-BA0074 remark
        #IF l_rvw10 = p_apb.apb09 OR l_rvw10 = p_apb.apb09*-1 THEN          #CHI-B40052      #MOD-BA0074
             LET p_api.api05f = l_apb24_1
             LET p_api.api05  = l_apb10_1
          #add by xujw200423--begin--
          #C19102201-11486 add by sunxin --start
         #暂估冲多次，有差异，数量不一致时，需要根据入库的数量*暂估单价重算暂估金额，若为最后一次冲暂估，则需要用总暂估金额-其他的已冲的金额
         ELSE
             LET l_cnt = 0
             #mark by lixwz200801 s---
             #SELECT COUNT(*) INTO l_cnt
             #  FROM api_file
             # WHERE api26 = p_api.api26
             #   AND api40 = l_apb02
             #mark by lixwz200801 e---
             #add by lixwz200801 s---
             select count(1) INTO l_cnt from apb_file,apa_file
              where apa01 =apb01 and apa00 ='11' and apb34='Y'
                and apb21 =p_apb.apb21  and apb22 =p_apb.apb22 AND apb01 <> p_apb.apb01
             #add by lixwz200801 e---
             IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF 
             IF l_cnt >= 1 THEN 
                IF l_apb21_o <> p_apb.apb21 OR l_apb22_o <> p_apb.apb22 OR cl_null(l_apb21_o) THEN  #MOD-C90229
                   LET l_sumapb09 = 0  
                END IF             
                SELECT SUM(apb09) INTO l_othapb09   #MOD-C90229 mod l_sumapb09 -> l_othapb09
                 FROM apa_file,apb_file
                WHERE apa01 = apb01 
                  AND apa42 = 'N' 
                  AND apa00 NOT IN ('16','26')
                  AND apb21 = p_apb.apb21
                  AND apb22 = p_apb.apb22 
                  AND apb01 <> p_apb.apb01      #MOD-C90229
	          AND apb34='Y'  #冲暂估的请款才计算  #add by lixwz200921
                IF cl_null(l_othapb09) THEN LET l_othapb09 = 0 END IF  #MOD-C90229 mod l_sumapb09 -> l_othapb09
                LET l_sumapb09 = l_sumapb09 + l_othapb09 + p_apb.apb09 #MOD-C90229
                
                IF l_sumapb09 = l_apb09 THEN 
                   SELECT apb01,apb02 INTO l_api26,l_api40 
                     FROM apa_file,apb_file
                    WHERE apa01 = apb01
                      AND apb21 = p_apb.apb21 
                      AND apb22 = p_apb.apb22  
                     #AND apa00 = '16'                     #MOD-F30090 mark
                      AND (apa00 = '16' OR apa00 = '26')   #MOD-F30090 add
                   #mark by lixwz200801 s---   
                   #SELECT SUM(api05f),SUM(api05) INTO l_sumapb24,l_sumapb10
                   #  FROM api_file
                   # WHERE api26 = p_api.api26
                   #   AND api40 = l_apb02
                   #mark by lixwz200801 e---
                   #add by lixwz200801 s---
                   select sum(apb24),sum(apb10) INTO l_sumapb24,l_sumapb10 from apb_file,apa_file
                     where apa01 =apb01 and apa00 ='11' and apb34='Y'
                     and apb21 =p_apb.apb21 and apb22 =p_apb.apb22 AND apb01 <> p_apb.apb01
                   #add by lixwz200801 e---
                 #--CHI-E30030 add end--
                  IF cl_null(l_sumapb24) THEN LET l_sumapb24 = 0 END IF
                  IF cl_null(l_sumapb10) THEN LET l_sumapb10 = 0 END IF
                  LET p_api.api05f = l_apb24_1 - l_sumapb24
                  LET p_api.api05  = l_apb10_1 - l_sumapb10
                ELSE 
                
                  LET l_apb23 = ''
                  LET l_apa13 = ''
                  LET l_apa72 = ''
                  LET l_apa73 = ''
                  LET l_apa14 = ''
                  SELECT apb23 INTO l_apb23 FROM apb_file WHERE apb01=p_api.api26 AND apb02=l_apb02
                  
                  SELECT apa13,apa72,apa73,apa14
                    INTO l_apa13,l_apa72,l_apa73,l_apa14
                    FROM apa_file
                   WHERE apa01=p_api.api26 AND apa41='Y' AND apa42='N'
                
                  EXECUTE sel_gec04_pre2 INTO l_gec04,l_gec07
                  
                  IF l_gec07 = 'Y'  AND g_aza.aza26 <> '2' THEN  #MOD-C50054                                                 
                     LET l_apb24t = l_apb23 * l_rvw10                                    
                     LET l_apb24t = cl_digcut(l_apb24t,t_azi04)                           
                     LET p_api.api05f = l_apb24t/(1+l_gec04/100)                          
                     LET p_api.api05  = p_api.api05f * l_apa14  
                  ELSE 
                     LET p_api.api05f = l_rvw10  * l_apb23                         
                     LET p_api.api05f = cl_digcut(p_api.api05f,t_azi04) 
                     LET p_api.api05  = p_api.api05f * l_apa14           
                     LET p_api.api05  = cl_digcut(p_api.api05,t_azi04) 
                  END IF
                END IF 
             #C20010801-11486 add by sunxin --start
             #冲暂估全部取暂估单价计算金额
             ELSE  
                  LET l_apb23 = ''
                  LET l_apa13 = ''
                  LET l_apa72 = ''
                  LET l_apa73 = ''
                  LET l_apa14 = ''
                  SELECT apb23 INTO l_apb23 FROM apb_file WHERE apb01=p_api.api26 AND apb02=l_apb02
                  
                  SELECT apa13,apa72,apa73,apa14
                    INTO l_apa13,l_apa72,l_apa73,l_apa14
                    FROM apa_file
                   WHERE apa01=p_api.api26 AND apa41='Y' AND apa42='N'
                
                  EXECUTE sel_gec04_pre2 INTO l_gec04,l_gec07
                  
                  IF l_gec07 = 'Y'  AND g_aza.aza26 <> '2' THEN  #MOD-C50054                                                 
                     LET l_apb24t = l_apb23 * l_rvw10                                    
                     LET l_apb24t = cl_digcut(l_apb24t,t_azi04)                           
                     LET p_api.api05f = l_apb24t/(1+l_gec04/100)                          
                     LET p_api.api05  = p_api.api05f * l_apa14  
                  ELSE 
                     LET p_api.api05f = l_rvw10  * l_apb23                         
                     LET p_api.api05f = cl_digcut(p_api.api05f,t_azi04) 
                     LET p_api.api05  = p_api.api05f * l_apa14           
                     LET p_api.api05  = cl_digcut(p_api.api05,t_azi04) 
                  END IF
             #C20010801-11486 add by sunxin --end
             END IF 
         #C19102201-11486 add by sunxin --end
         #add by xujw200423--end--
         END IF
        #----MOD-C60106----#
        #IF l_apa00 = '26' THEN
        #   IF p_api.api05f >0 THEN
        #      LET p_api.api05f =  p_api.api05f*(-1)
        #   END IF
        #   IF p_api.api05 >0 THEN
        #      LET p_api.api05  =  p_api.api05*(-1)
        #   END IF
        #END IF
        #----MOD-C60106----#

         IF STATUS THEN
            LET g_success = 'N'
            EXIT FOREACH
         END IF
        
         IF p_api.api26 IS NOT NULL AND p_api.api26 <> 'DIFF' THEN
            SELECT apa13,apa72,apa73,apa14
              INTO l_apa13,l_apa72,l_apa73,l_apa14
              FROM apa_file
             WHERE apa01=p_api.api26 AND apa41='Y' AND apa42='N'
           #-MOD-C20104-mark-
           #IF g_apz.apz27 = 'Y' AND g_aza.aza17 != l_apa13 THEN
           #   LET p_api.api05=p_api.api05f*l_apa72
           #END IF
           #IF g_apz.apz27 = 'N' AND g_aza.aza17 != l_apa13 THEN
           #   LET p_api.api05=p_api.api05f*l_apa14
           #END IF
           #-MOD-C20104-add-
            IF g_aza.aza17 != l_apa13 THEN 
               IF g_apz.apz27 = 'Y' THEN
                  LET p_api.api05=p_api.api05f*l_apa72
               ELSE
                  LET p_api.api05=p_api.api05f*l_apa14
               END IF
            END IF
           #-MOD-C20104-end-
         END IF
         IF p_api.api05f IS NULL THEN
            LET p_api.api05f = 0
         END IF
        
         IF p_api.api05 IS NULL THEN
            LET p_api.api05 = 0
         END IF
        
         #LET p_api.api05 = cl_digcut(p_api.api05 ,g_azi04)             #yinhy130828 mark
         #LET p_api.api05f= cl_digcut(p_api.api05f,t_azi04)             #yinhy130828 mark
        
        #-MOD-C50137-add- 
        #IF l_apb21_o <> p_apb.apb21 AND l_apb22_o <> p_apb.apb22 OR cl_null(l_apb21_o) THEN #MOD-C90229 mark
         IF l_apb21_o <> p_apb.apb21 OR l_apb22_o <> p_apb.apb22 OR cl_null(l_apb21_o) THEN  #MOD-C90229
            LET l_sumapb09 = 0  
         END IF                                                                              #MOD-C90229
         LET l_othapb09 = 0                                     #MOD-C90229
         SELECT SUM(apb09) INTO l_othapb09   #MOD-C90229 mod l_sumapb09 -> l_othapb09
              FROM apa_file,apb_file
             WHERE apa01 = apb01 
               AND apa42 = 'N' 
               AND apa00 NOT IN ('16','26')
               AND apb21 = p_apb.apb21
               AND apb22 = p_apb.apb22 
            AND apb01 <> p_apb.apb01      #MOD-C90229
         IF cl_null(l_othapb09) THEN LET l_othapb09 = 0 END IF  #MOD-C90229 mod l_sumapb09 -> l_othapb09
         LET l_sumapb09 = l_sumapb09 + l_othapb09 + p_apb.apb09 #MOD-C90229
           # IF l_apb09 = l_sumapb09 THEN   #MOD-D60139 mark     #mark by xujw200423
            IF l_apb09 = l_sumapb09 AND g_apz.apz27 = 'N' THEN   #MOD-D60139 add #add by xujw200423
               LET l_sumapb24 = 0
               LET l_sumapb10 = 0
          #mark by xujw200603--begin--
          #    #mark by xujw200423--begin--
          #    #--remark by lifang 200430 begin#
          #     #--CHI-E30030 mark start--
          #     SELECT SUM(apb24),SUM(apb10) INTO l_sumapb24,l_sumapb10
          #       FROM apa_file,apb_file
          #      WHERE apa01 = apb01
          #        AND apa42 = 'N'
          #        AND apa00 NOT IN ('16','26')
          #        AND apb21 = p_apb.apb21
          #        AND apb22 = p_apb.apb22
          #        AND ((apb01 = p_apb.apb01 AND apb02 <> p_apb.apb02)
          #             OR apb01 <> p_apb.apb01)
          #     --CHI-E30030 mark end--
          #    #mark by xujw200423--end--
          #   #--remark by lifang 200430 end#
          #mark by xujw200603--end--
          
          #remark by xujw200603--begin--
             #--mark by lifang 200430 begin#
             ##add by xujw200423--begin--
             ##--CHI-E30030 add start--
             SELECT apb01,apb02 INTO l_api26,l_api40
               FROM apa_file,apb_file
              WHERE apa01 = apb01
                AND apb21 = p_apb.apb21
                AND apb22 = p_apb.apb22
              #  AND apa00 = '16'                    #MOD-F30090 mark
                AND (apa00 = '16' OR apa00 = '26')   #MOD-F30090 add
             SELECT SUM(api05f),SUM(api05) INTO l_sumapb24,l_sumapb10
               FROM api_file
              WHERE api26 = l_api26
                AND api40 = l_api40
             ##--CHI-E30030 add end--   
             ##add by xujw200423--end--       
             #--mark by lifang 200430 end# 
           #remark by xujw200603--end--

               IF cl_null(l_sumapb24) THEN LET l_sumapb24 = 0 END IF
               IF cl_null(l_sumapb10) THEN LET l_sumapb10 = 0 END IF
               LET p_api.api05f = l_apb24_1 - l_sumapb24
               LET p_api.api05  = l_apb10_1 - l_sumapb10
            END IF
        #END IF    #MOD-C90229 mark 
        #-MOD-C50137-end- 
         #No.CHI-A10006 add --start--
         #IF l_apa34f - l_apa35f = p_api.api05f THEN
         IF l_apa34f - l_apa35f <= p_api.api05f THEN             #MOD-D80161
            IF g_apz.apz27 = 'Y' AND g_aza.aza17 != l_apa13 THEN #MOD-B40045 
               LET p_api.api05 = l_apa73                         #MOD-B40045
            ELSE                                                 #MOD-B40045
               LET p_api.api05 = l_apa34 - l_apa35
            END IF                                               #MOD-B40045
            LET p_api.api05f = l_apa34f - l_apa35f               #MOD-D80161
         END IF
         #No.CHI-A10006 add --end--
         
         
         LET p_api.api40 = 1         #CHI-E30030 mark    #remark by lifang 200430
        # LET p_api.api40 = l_apb02   #CHI-E30030 add    #mark by lifang 200430
         LET p_api.api40 = l_apb02   #CHI-E30030 add     #add by xujw200603
         LET p_api.api35 = p_apb.apb36
         LET p_api.api36 = p_apb.apb31
         LET p_api.apilegal = g_legal          #FUN-980001 add 
        #----MOD-C60106----#
         IF l_apa00 = '26' THEN
            IF p_api.api05f >0 THEN
               LET p_api.api05f =  p_api.api05f*(-1)
            END IF 
            IF p_api.api05 >0 THEN
               LET p_api.api05  =  p_api.api05*(-1)
            END IF
         END IF 
        #----MOD-C60106----#
        
        #No.yinhy130828  --Begin
        IF g_apz.apz27 = 'Y' AND g_aza.aza17 != g_apa.apa13 THEN
        	 SELECT oox07 INTO l_oox07 
             FROM oox_file WHERE oox00 = 'AP'
   	          AND oox03 = p_api.api26 AND oox041 = '1'
            ORDER BY oox01 DESC,oox02 DESC
            IF g_aza.aza26 = '2' AND NOT cl_null(l_oox07) THEN           
               LET p_api.api05 = p_api.api05f * l_oox07                
            END IF
         END IF
         #No.yinhy130828  --End
        
         LET p_api.api05 = cl_digcut(p_api.api05 ,g_azi04)     #MOD-D80161
         LET p_api.api05f= cl_digcut(p_api.api05f,t_azi04)     #MOD-D80161
         

         
         INSERT INTO api_file VALUES(p_api.*)
         IF SQLCA.sqlcode THEN
            CALL cl_err3('ins','api_file',p_api.api01,'','',SQLCA.sqlcode,'',1)
            LET g_success = 'N'
         END IF

      END FOREACH   #MOD-790033
      LET l_apb21_o = p_apb.apb21   #MOD-C50137 
      LET l_apb22_o = p_apb.apb22   #MOD-C50137
   END FOREACH   #MOD-790033
 
  #-MOD-C20104-add-
   IF g_apz.apz27 = 'Y' AND g_aza.aza17 != g_apa.apa13 THEN 
      LET l_sumapi05f = 0
      LET l_sumapi05 = 0
      LET l_chkamt = 0
      LET l_diffamt = 0
      LET l_apa73 = 0
      LET g_sql = "SELECT api26,SUM(api05f),SUM(api05) ",
                  "  FROM api_file ",
                  " WHERE api01 = '",g_apa.apa01,"'",
                  "   AND api02 = '2'",
                  " GROUP BY api26 ",
                  " ORDER BY api26 "
      PREPARE sel_api_pre FROM g_sql
      DECLARE sel_api_cur CURSOR FOR sel_api_pre
      FOREACH sel_api_cur INTO l_api26,l_sumapi05f,l_sumapi05
         IF cl_null(l_sumapi05f) THEN LET l_sumapi05f = 0 END IF
         IF cl_null(l_sumapi05) THEN LET l_sumapi05 = 0 END IF
         SELECT apa34f-apa35f,apa73 INTO l_chkamt,l_apa73
           FROM apa_file
          WHERE apa01 = l_api26
         IF cl_null(l_chkamt) THEN LET l_chkamt = 0 END IF
         IF cl_null(l_apa73) THEN LET l_apa73 = 0 END IF
         #No.yinhy130828  --Begin
         IF g_aza.aza26 = '2' THEN
           SELECT SUM(api05f),SUM(api05) INTO l_sumapi05f_1,l_sumapi05_1 FROM api_file
            WHERE api26 = l_api26
              AND api01 <> g_apa.apa01
              AND api02 = '2'
         END IF
         IF cl_null(l_sumapi05_1) THEN LET l_sumapi05_1 = 0 END IF
         IF cl_null(l_sumapi05f_1) THEN LET l_sumapi05f_1 = 0 END IF
         #No.yinhy130828  --End
         #IF (l_chkamt = l_sumapi05f AND l_apa73 <> l_sumapi05 ) THEN  
         IF (l_chkamt = (l_sumapi05f+l_sumapi05f_1) AND l_apa73 <>( l_sumapi05 + l_sumapi05_1)) THEN    #yinhy130828
            #LET l_diffamt = l_apa73 - l_sumapi05                   #yinhy130828
            LET l_diffamt = l_apa73 - l_sumapi05 - l_sumapi05_1     #yinhy130828
            LET g_sql=" SELECT api03 ",
                      "   FROM api_file ",
                      "  WHERE api01 = '",g_apa.apa01,"'",
                      "    AND api26 = '",l_api26,"'",
                      "    AND api02 = '2'",
                      "  ORDER BY api05 DESC "
            PREPARE p110_max_p FROM g_sql
            DECLARE p110_max_c SCROLL CURSOR FOR p110_max_p
            OPEN p110_max_c
            FETCH FIRST p110_max_c INTO l_api03
            UPDATE api_file SET api05 = api05 + l_diffamt
             WHERE api01 = g_apa.apa01
               AND api02 = '2'   
               AND api03 = l_api03
         END IF
      END FOREACH 
   END IF
  #-MOD-C20104-end-

   #衝暫估的diff值
   LET l_apb10=0
   LET l_apb24=0
   SELECT SUM(apb10),SUM(apb24) INTO l_apb10,l_apb24 FROM apb_file
    WHERE apb01=g_apa.apa01
      AND apb34='N'
   IF cl_null(l_apb10) THEN LET l_apb10=0 END IF
   IF cl_null(l_apb24) THEN LET l_apb24=0 END IF
   LET l_amt  = g_apa.apa31  - g_apa.apa60  - l_apb10 - g_apa.apa33
   LET l_amtf = g_apa.apa31f - g_apa.apa60f - l_apb24 - g_apa.apa33f
   SELECT MAX(api03)+1,SUM(api05f),SUM(api05)
     INTO l_diff_api03,l_diff_api05f,l_diff_api05
     FROM api_file WHERE api01 = p_api.api01
   IF cl_null(l_diff_api05f) THEN
      LET l_diff_api05f = 0
   END IF
   IF cl_null(l_diff_api05) THEN
      LET l_diff_api05 = 0
   END IF
   IF l_amt = l_diff_api05 AND l_amtf = l_diff_api05f THEN
   ELSE
      LET l_diff_api05 = l_amt - l_diff_api05
      LET l_diff_api05 = cl_digcut(l_diff_api05,g_azi04)   #No.MOD-650110   #MOD-780215
      LET l_diff_api05f= l_amtf- l_diff_api05f
      LET l_diff_api05f= cl_digcut(l_diff_api05f,t_azi04)   #No.MOD-650110   #MOD-780215
      IF g_apz.apz13 = 'Y' THEN                                                 
         SELECT * INTO g_aps.* FROM aps_file WHERE aps01 = g_apa.apa22          
      ELSE                                                                      
         SELECT * INTO g_aps.* FROM aps_file WHERE (aps01 = ' ' OR aps01 IS NULL)
      END IF 
      LET p_api.api03=l_diff_api03
      LET p_api.api04 =g_aps.aps44        #MOD-B40087 mark  #MOD-B80270 還原mark
      LET p_api.api041=g_aps.aps441       #MOD-B40087 mark  #MOD-B80270 還原mark
      LET p_api.api05f=l_diff_api05f
      LET p_api.api05=l_diff_api05
     #No.MOD-B80270  --Begin
     #-MOD-B40087-add-
     # IF p_api.api05 > 0 THEN
     #    LET p_api.api04  = g_aps.aps43 
     #    LET p_api.api041 = g_aps.aps431
     # END IF
     # IF p_api.api05 < 0 THEN
     #    LET p_api.api04  = g_aps.aps42 
     #    LET p_api.api041 = g_aps.aps421
     # END IF
     #-MOD-B40087-end-
     #No.MOD-B80270  --End
      LET p_api.api06='UNAP:DIFF'
      LET p_api.api26='DIFF'
      LET p_api.api40=NULL
 
      LET p_api.api35 = ' '
      LET p_api.api36 = ' '
      LET p_api.apilegal = g_legal          #FUN-980001 add 
      INSERT INTO api_file VALUES(p_api.*)
      IF SQLCA.sqlcode THEN
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
            UPDATE api_file SET api05 = l_diff_api05
             WHERE api01=p_api.api01
               AND api26='DIFF'
            IF SQLCA.sqlcode THEN
               LET g_success = 'N'
               LET g_showmsg=p_api.api01,"/","DIFF"
               CALL s_errmsg("api01,api26",g_showmsg,"",SQLCA.sqlcode,1)
            END IF
         ELSE
            LET g_success = 'N'
            LET g_showmsg=p_api.api01,"/",p_api.api02,"/",p_api.api03
            CALL s_errmsg("api01,api02,api03",g_showmsg,"insert api diff",SQLCA.sqlcode,1)
         END IF
      END IF
   END IF
END FUNCTION
 
#修改由于rvw10可改引起的同一張帳款編號下,檔案apb_file下，異動單號+項次的重復
FUNCTION p110_upd_apb()
   DEFINE l_apb  RECORD LIKE apb_file.*,
          l_i    LIKE type_file.num5,    #No.FUN-690028 SMALLINT,
          l_n    LIKE type_file.num5,    #No.FUN-690028 SMALLINT,
          l_max  LIKE type_file.num5     #No.FUN-690028 SMALLINT
   DECLARE p110_s_c CURSOR FOR
      SELECT apa01 FROM apa_file
       WHERE apa01 BETWEEN begin_no AND end_no
   FOREACH p110_s_c INTO g_apa.apa01
      IF STATUS THEN EXIT FOREACH END IF
      LET l_i = 1
      DECLARE p110_s1_c CURSOR FOR
         SELECT apb21,apb22,SUM(apb09),SUM(apb10),SUM(apb101),
                            SUM(apb14f),SUM(apb14),SUM(apb15),SUM(apb24)
           FROM apb_file
          WHERE apb01 = g_apa.apa01
          GROUP BY apb21,apb22
          ORDER BY apb21,apb22
      FOREACH p110_s1_c INTO l_apb.apb21,l_apb.apb22,l_apb.apb09,l_apb.apb10,l_apb.apb101,
                             l_apb.apb14f,l_apb.apb14,l_apb.apb15,l_apb.apb24
         IF STATUS THEN EXIT FOREACH END IF
         SELECT COUNT(*),MIN(apb02),MAX(apb02) INTO l_n,l_apb.apb02,l_max
           FROM apb_file
          WHERE apb01 = g_apa.apa01
            AND apb21 = l_apb.apb21
            AND apb22 = l_apb.apb22
         IF l_n > 1 THEN
            DELETE FROM apb_file
             WHERE apb01 = g_apa.apa01
               AND apb02 > l_apb.apb02
               AND apb21 = l_apb.apb21
               AND apb22 = l_apb.apb22
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               LET g_showmsg=g_apa.apa01,"/",l_apb.apb21,"/",l_apb.apb22
               CALL s_errmsg("apb01,apb21,apb22",g_showmsg,"delete apb_file",SQLCA.sqlcode,0)
               CONTINUE FOREACH
            END IF
         END IF
         UPDATE apb_file SET apb02 = l_i,
                             apb09 = l_apb.apb09,
                             apb10 = l_apb.apb10,
                             apb101= l_apb.apb101,
                             apb14f= l_apb.apb14f,
                             apb14 = l_apb.apb14,
                             apb15 = l_apb.apb15,
                             apb24 = l_apb.apb24
                       WHERE apb01 = g_apa.apa01
                         AND apb02 = l_apb.apb02
                         AND apb21 = l_apb.apb21
                         AND apb22 = l_apb.apb22
         IF STATUS OR SQLCA.sqlerrd[3]=0 THEN    #TQC-630174
            LET g_showmsg=g_apa.apa01,"/",l_apb.apb02,"/",l_apb.apb21,"/",l_apb.apb22
            CALL s_errmsg("apb01,apb02,apb21,apb22",g_showmsg,"up apb_file",SQLCA.sqlcode,0)
            CONTINUE FOREACH
         END IF
         UPDATE apk_file SET apk02 = l_i
                       WHERE apk01 = g_apa.apa01
                         AND apk02 BETWEEN l_apb.apb02 AND l_max
         IF STATUS OR SQLCA.sqlerrd[3]=0 THEN    #TQC-630174
            LET g_showmsg=g_apa.apa01,"/",l_apb.apb02,"/",l_max
            CALL s_errmsg("apk01,apk02,apk02",g_showmsg,"up apb_file",SQLCA.sqlcode,0)
            CONTINUE FOREACH
         END IF
         LET l_i = l_i + 1
      END FOREACH
   END FOREACH
END FUNCTION
 
FUNCTION p110_comp_oox(p_apv03)
DEFINE l_net     LIKE apv_file.apv04
DEFINE p_apv03   LIKE apv_file.apv03
DEFINE l_apa00   LIKE apa_file.apa00
 
    LET l_net = 0
    IF g_apz.apz27 = 'Y' THEN
       SELECT SUM(oox10) INTO l_net FROM oox_file
        WHERE oox00 = 'AP' AND oox03 = p_apv03
       IF cl_null(l_net) THEN
          LET l_net = 0
       END IF
    END IF
    SELECT apa00 INTO l_apa00 FROM apa_file WHERE apa01=p_apv03
    IF l_apa00 MATCHES '1*' THEN LET l_net = l_net * ( -1) END IF
 
    RETURN l_net
END FUNCTION
 
FUNCTION p110_ins_apc(p_apa01)
DEFINE p_apa01   LIKE apa_file.apa01
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_n       LIKE type_file.num5
DEFINE l_apc13   LIKE apc_file.apc13
DEFINE l_apa     RECORD LIKE apa_file.*
DEFINE l_apa20   LIKE apa_file.apa20     #MOD-CA0172
 
   SELECT * INTO l_apa.* FROM apa_file WHERE apa01 = p_apa01
   LET l_apa20 = l_apa.apa20                                                   #MOD-CA0172 add
   IF cl_null(l_apa20) THEN LET l_apa20 = 0 END IF                             #MOD-CA0172 add
 # LET g_sql = "SELECT count(*) FROM ",l_dbs CLIPPED,"pmb_file ",              #FUN-A50102 mark
   LET g_sql = "SELECT count(*) FROM ",cl_get_target_table(l_azp01,'pmb_file'),#FUN-A50102 
               " WHERE pmb01 = '",l_apa.apa11,"' "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql         #FUN-A50102
   CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-A50102
   PREPARE sel_cou_pmb FROM g_sql
   EXECUTE sel_cou_pmb INTO l_cnt
 
   IF NOT cl_null(l_apa.apa01) THEN
      IF l_cnt > 0 THEN
 
       # LET g_sql = "SELECT pmb02 FROM ",l_dbs CLIPPED,"pmb_file ",               #FUN-A50102 mark
         LET g_sql = "SELECT pmb02 FROM ",cl_get_target_table(l_azp01,'pmb_file'), #FUN-A50102
                     " WHERE pmb01 = '",l_apa.apa11,"' "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql            #FUN-A50102 
         CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql    #FUN-A50102
         PREPARE sel_pmb02_pre FROM g_sql
         EXECUTE sel_pmb02_pre INTO g_pmb.pmb02
         IF g_pmb.pmb02 = 1 THEN
            LET l_n = 1
            LET l_apc13 = 0
            LET g_sql = " SELECT pmb01,pmb03,pmb04,pmb05",
                      # "   FROM ",l_dbs CLIPPED,"pmb_file ",    #FUN-9C0001     #FUN-A50102 
                        "   FROM ",cl_get_target_table(l_azp01,'pmb_file'),      #FUN-A50102
                        "  WHERE pmb01 = '",l_apa.apa11,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql         #FUN-A50102
            CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-A50102
            PREPARE p110_p1 FROM g_sql
            DECLARE p110_c1 CURSOR FOR p110_p1
            FOREACH p110_c1 INTO g_pmb.pmb01,g_pmb.pmb03,
                                 g_pmb.pmb04,g_pmb.pmb05
               IF g_success = 'N' THEN
                  LET g_totsuccess = 'N'
                  LET g_success = 'Y'
               END IF
               LET g_apc.apc01 = l_apa.apa01
               LET g_apc.apc02 = g_pmb.pmb03
               LET g_apc.apc03 = g_pmb.pmb04
               CALL s_paydate('a','',l_apa.apa09,l_apa.apa02,g_apc.apc03,l_apa.apa06)
                    RETURNING g_apc.apc04,g_apc.apc05,g_temp
               LET g_apc.apc06 = l_apa.apa14
               LET g_apc.apc07 = l_apa.apa72
              #LET g_apc.apc08 = l_apa.apa34f*g_pmb.pmb05/100                  #No.MOD-B90002 mark
               LET g_apc.apc08 = (l_apa.apa34f + l_apa.apa65f)*g_pmb.pmb05/100 #No.MOD-B90002 add
              #LET g_apc.apc09 = l_apa.apa34*g_pmb.pmb05/100                   #No.MOD-B90002 mark
               LET g_apc.apc09 = (l_apa.apa34 + l_apa.apa65)*g_pmb.pmb05/100   #No.MOD-B90002 add
              #LET g_apc.apc10 = 0                                             #MOD-CA0172 mark
              #LET g_apc.apc11 = 0                                             #MOD-CA0172 mark
               LET g_apc.apc10 = l_apa.apa35f * g_pmb.pmb05/100                #MOD-CA0172 add
               LET g_apc.apc11 = l_apa.apa35 * g_pmb.pmb05/100                 #MOD-CA0172 add
               LET g_apc.apc12 = l_apa.apa08
               IF l_n = l_cnt THEN
                  LET g_apc.apc13 = l_apa.apa73-l_apc13
               ELSE
                  LET g_apc.apc13 = l_apa.apa73*g_pmb.pmb05/100
                  LET l_apc13 = l_apc13+g_apc.apc13
                  LET l_n = l_n+1
               END IF
              #LET g_apc.apc14 = 0                                  #No.MOD-B90002 mark
               LET g_apc.apc14 = l_apa.apa65f*g_pmb.pmb05/100       #No.MOD-B90002 add
              #LET g_apc.apc15 = 0                                  #No.MOD-B90002 mark
               LET g_apc.apc15 = l_apa.apa65*g_pmb.pmb05/100        #No.MOD-B90002 add
              #-------------------#MOD-CA0172-------------------(S)
              #LET g_apc.apc16 = 0                          #MOD-CA0172 mark
               IF l_apa20 >= (g_apc.apc08 - g_apc.apc10) THEN
                  LET g_apc.apc16 = g_apc.apc08 - g_apc.apc10
                  LET l_apa20 = l_apa20 - g_apc.apc16
               ELSE
                  LET g_apc.apc16 = l_apa20
                  LET l_apa20 = 0
               END IF
              #-------------------#MOD-CA0172-------------------(E)
               LET g_apc.apc08 = cl_digcut(g_apc.apc08,t_azi04)
               LET g_apc.apc09 = cl_digcut(g_apc.apc09,g_azi04)
               LET g_apc.apc13 = cl_digcut(g_apc.apc13,g_azi04)
               LET g_apc.apclegal = g_legal          #FUN-980001 add
               INSERT INTO apc_file VALUES(g_apc.*)
               IF STATUS THEN
                  LET g_success = 'N'
                  LET g_showmsg=g_apc.apc01,"/",g_apc.apc03
                  CALL s_errmsg('apc01,apc03','','',SQLCA.sqlcode,1)
                  CONTINUE FOREACH
               END IF
            END FOREACH
            IF g_totsuccess = 'N' THEN
               LET g_success = 'N'
            END IF
         END IF
         IF g_pmb.pmb02 = 2 THEN
            LET g_apc.apc01 = l_apa.apa01
            LET g_apc.apc02 = 1
            LET g_apc.apc03 = l_apa.apa11
            LET g_apc.apc04 = l_apa.apa12
            LET g_apc.apc05 = l_apa.apa64
            LET g_apc.apc06 = l_apa.apa14
            LET g_apc.apc07 = l_apa.apa72
           #LET g_apc.apc08 = l_apa.apa34f                    #No.MOD-B90002 mark
            LET g_apc.apc08 = l_apa.apa34f + l_apa.apa65f     #No.MOD-B90002 add
           #LET g_apc.apc09 = l_apa.apa34                     #No.MOD-B90002 mark
            LET g_apc.apc09 = l_apa.apa34 + l_apa.apa65       #No.MOD-B90002 add
           #LET g_apc.apc10 = 0                               #MOD-CA0172 mark
           #LET g_apc.apc11 = 0                               #MOD-CA0172 mark
            LET g_apc.apc10 = l_apa.apa35f                    #MOD-CA0172 add
            LET g_apc.apc11 = l_apa.apa35                     #MOD-CA0172 add
            LET g_apc.apc12 = l_apa.apa08
            LET g_apc.apc13 = l_apa.apa73
           #LET g_apc.apc14 = 0                  #No.MOD-B90002 mark
            LET g_apc.apc14 = l_apa.apa65f       #No.MOD-B90002 add
           #LET g_apc.apc15 = 0                  #No.MOD-B90002 mark
            LET g_apc.apc15 = l_apa.apa65        #No.MOD-B90002 add
           #-------------------#MOD-CA0172-------------------(S)
           #LET g_apc.apc16 = 0                          #MOD-CA0172 mark
            IF l_apa20 >= (g_apc.apc08 - g_apc.apc10) THEN
               LET g_apc.apc16 = g_apc.apc08 - g_apc.apc10
               LET l_apa20 = l_apa20 - g_apc.apc16
            ELSE
               LET g_apc.apc16 = l_apa20
               LET l_apa20 = 0
            END IF
           #-------------------#MOD-CA0172-------------------(E)
            LET g_apc.apc08 = cl_digcut(g_apc.apc08,t_azi04)
            LET g_apc.apc09 = cl_digcut(g_apc.apc09,g_azi04)
            LET g_apc.apc13 = cl_digcut(g_apc.apc13,g_azi04)
            LET g_apc.apclegal = g_legal          #FUN-980001 add
            INSERT INTO apc_file VALUES(g_apc.*)
            IF STATUS THEN
               LET g_success = 'N'
               LET g_showmsg=g_apc.apc01,"/",g_apc.apc03
               CALL s_errmsg('apc01,apc03','','',SQLCA.sqlcode,1)
            END IF
         END IF
      END IF
      IF l_cnt = 0 THEN

               LET g_apc.apc01 = l_apa.apa01
               LET g_apc.apc02 = 1
               LET g_apc.apc03 = l_apa.apa11
               LET g_apc.apc04 = l_apa.apa12
               LET g_apc.apc05 = l_apa.apa64
               LET g_apc.apc06 = l_apa.apa14
               LET g_apc.apc07 = l_apa.apa72
              #LET g_apc.apc08 = l_apa.apa34f                    #No.MOD-B90002 mark
               LET g_apc.apc08 = l_apa.apa34f + l_apa.apa65f     #No.MOD-B90002 add
              #LET g_apc.apc09 = l_apa.apa34                     #No.MOD-B90002 mark
               LET g_apc.apc09 = l_apa.apa34 + l_apa.apa65       #No.MOD-B90002 add
              #LET g_apc.apc10 = 0                               #MOD-CA0172 mark
              #LET g_apc.apc11 = 0                               #MOD-CA0172 mark
               LET g_apc.apc10 = l_apa.apa35f                    #MOD-CA0172 add
               LET g_apc.apc11 = l_apa.apa35                     #MOD-CA0172 add
               LET g_apc.apc12 = l_apa.apa08
               LET g_apc.apc13 = l_apa.apa73
              #LET g_apc.apc14 = 0                               #No.MOD-B90002 mark
               LET g_apc.apc14 = l_apa.apa65f                    #No.MOD-B90002 add
              #LET g_apc.apc15 = 0                               #No.MOD-B90002 mark
               LET g_apc.apc15 = l_apa.apa65                     #No.MOD-B90002 add
              #-------------------#MOD-CA0172-------------------(S)
              #LET g_apc.apc16 = 0                          #MOD-CA0172 mark
               IF l_apa20 >= (g_apc.apc08 - g_apc.apc10) THEN
                  LET g_apc.apc16 = g_apc.apc08 - g_apc.apc10
                  LET l_apa20 = l_apa20 - g_apc.apc16
               ELSE
                  LET g_apc.apc16 = l_apa20
                  LET l_apa20 = 0
               END IF
              #-------------------#MOD-CA0172-------------------(E)
               LET g_apc.apc08 = cl_digcut(g_apc.apc08,t_azi04)
               LET g_apc.apc09 = cl_digcut(g_apc.apc09,g_azi04)
               LET g_apc.apc13 = cl_digcut(g_apc.apc13,g_azi04)
               LET g_apc.apclegal = g_legal          #FUN-980001 add
               INSERT INTO apc_file VALUES(g_apc.*)
               IF STATUS THEN
                  LET g_success = 'N'
                  LET g_showmsg=g_apc.apc01,"/",g_apc.apc03
                  CALL s_errmsg('apc01,apc03',g_showmsg,'',SQLCA.sqlcode,1)
               END IF
      END IF
   END IF
 
END FUNCTION
#No.FUN-9C0077 程式精簡
#FUN-A70139
