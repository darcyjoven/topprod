# Prog. Version..: '5.30.06-13.04.19(00010)'     #
#
# Pattern name...: axcp500.4gl
# Descriptions...: 庫存及在製成本計算作業
# Date & Author..: 96/02/24 By Roger
# Remark.........: 舊客戶調整:單位換算(請執行axcp112, 再修改本程式:
#                                      將'select tlf10'改為'sel tlf10*tlf60')
#                  modify by Ostrich 010503 將select tlf10'改為'sel tlf10*tlf60'
# 暫時以sfp02 取套數 應為sfp03(發料日)
# V2.0版注意:1.沒有smy53,smy54
#            2.tlf21,tlf211,tlf212 未定義為成本/日期 (請設ccz06='N')
# 註:xx代表中文"開"字
# Modify.........: 03/05/07 By Jiunn (No.7088)
#                  a.尾差調整
#                  b.聯產品
#                  c.工單重工定義 sfb02(5:一般重工 8:委外重工)
#                  d.多倉出貨, 銷貨收入重覆計算問題
#                  e.當 ccz05='2', 且本月無投料, 會造成本月人工工時轉出為零問題
#                  f.當 ccz05='3', 加快成本計算作業
# Modify.........: No:6820 03/10/08 888行附近為g_tlf，應修正為q_tlf(g_tlf的變數是錯誤的)
# Modify.........: No:7888 03/08/22 Melody wip_c3 CURSOR 需排除不計成本倉
# Modify.........: No:8179 03/09/10 Melody 若系統設定不走聯產品,會導致委外以外的工單,抓不到ccg,程式兩處的邏輯須調
# Modify.........: No:6914 03/10/08 Melody p500_ccc44_cost()中 IF l_qty=0 THEN ...建議改為 IF g_ccc.ccc11 = 0 AND g_ccc.ccc21 = 0 THEN...
# Modify.........: No:8741 03/11/28 Melody 2003/11/18 產品會議決議內容修改
# Modify.........: No:9614 04/05/31 Melody 應加上 AND apb01 = apa01 AND apa00 = '11'
# Modify.........: No:8196 03/09/15 Melody ORA...OUTER沒改
# Modify.........: No:8327 03/09/15 Apple IF g_smydmy1='N' THEN  ->
#                                         IF g_smydmy1='N' OR g_smydmy1 IS NULL THEN
# Modify.........: No:A102 03/12/22 Danny 增加先進先出計算方式
# Modify.........: No:BUG-470041 04/07/19 By Wiky Bugno.MOD-470041 修改INSERT INTO...
# Modify.........: No:9767 04/07/19 Carol 將 TIPTOP GP 中的  g_sql,g_wc 改為 STRING
# Modify.........: No:9768 04/07/19 Carol FUNCTION wip_ccg20() 計算工時...應加上 cci_file 確認碼的判斷
# Modify.........: No.MOD-490217 04/09/10 By yiting 料號欄位使用like方式
# Modify.........: No.MOD-4A0263 04/10/20 By Mandy 在INSERT INTO ccc_file之前做NOT NULL欄位的判斷
# Modify.........: No.MOD-4A0278 04/10/21 By ching 代買料應算入工單投入
# Modify.........: No.MOD-4A0185 04/10/26 By ching 聯成本尾差修改
# Modify.........: No.MOD-4B0055 04/11/11 By Carol 1.參數勾選聯產品,且又有委外工單時,針對委外工單入庫部份,
#                                                    系統算不到其入庫成本,導致在製有轉出量及金額,但庫存成本只有本期入庫量,但沒有本期入庫金額
#                                                    -->因出在 axcp500   p500_ccg_cost( )段,只針對一般及重工工單做處理,委外完全不管
#                                                  2.有關聯產品小數尾差部份,針對 ccc_file還是會有問題,
#                                                    因為入庫金額有變更,理論上應該要重算一次月加權平均單價,且後面的期末結存及結存調整,
#                                                    及所有的領用成本都會變動,後續會有影響,所以可能要先拿掉!!
# Modify.........: No.MOD-4B0205 04/11/22 By ching 拆件調整修改
# Modify.........: No.MOD-4C0005 04/12/01 By Carol 單價/金額欄位放大(20),位數改為dec(20,6)
# Modify.........: No.MOD-530032 05/03/09 By ching remove BEGIN WORK
# Modify.........: No.MOD-530234 05/03/24 By pengu 1877行,處理聯產品時,l_sql只有800不夠用,放大為1000
# Modify.........: No.MOD-530850 05/03/31 By Will 增加料件的開窗
# Modify.........: No.MOD-540129 05/04/20 By kim 修改p500_can_upd()段
# Modify.........: No.FUN-550025 05/05/16 By vivien 單據編號格式放大
# Modify.........: No.FUN-560011 05/06/07 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.MOD-540206 05/06/16 By kim 增加詢問"計算前是否先刪除舊統計資料"功能
# Modify.........: No.FUN-570212 05/07/20 By ching 增加相同作業編號sum(sfa161)轉出
# Modify.........: No.MOD-570372 05/07/27 By kim 執行"計算前是否先刪除舊統計資料"時,請一併將TLF_FILE 相關欄位清除0;修正p500_del()BUG
# Modify.........: No.MOD-580322 05/08/31 By wujie 中文資訊修改進 ze_file
# Modify.........: No.MOD-580096 05/09/13 By pengu 在做DELETE FROM cce_file WHERE條件應再加上 cce04=g_ima01
# Modify.........: No.FUN-5B0076 05/11/23 By Sarah INSERT INTO ccy_file處理段,將g_msg編ze_file資料
# Modify.........: No.FUN-5B0076 05/11/23 By Sarah 將SQL句中的like改成MATCHES
# Modify.........: No.FUN-5B0080 05/11/23 By Sarah SQL 改寫,提升執行效能
# Modify.........: No.MOD-5C0023 05/12/05 By Claire cci01 組sql條件錯誤
# Modify.........: No.TQC-5C0010 05/12/05 By Claire 拆件式工單成本計算時,未將非成本資料庫排除
# Modify.........: No.MOD-5C0105 05/12/20 By Carol 1.成本計算時會排除數量為0的tlf會影響兩個部份 a.銷退則讓 b.倉退則讓 的tlf無法算到
# Modify.........: No.FUN-5C0001 06/01/06 by Yiting 加上是否顯示執行過程選項及cl_progress_bar()
# Modify.........: No.FUN-610080 06/02/08 By Sarah 3.0新功能,增加判斷是不是重複性生產料件(g_ima911)
# Modify.........: No.MOD-620042 06/02/15 By Claire l_cjp06,l_s_cpj06 重新定義
# Modify.........: No.MOD-620063 06/02/22 By Carol p500_del() delete cch_file SQL加條件
# Modify.........: No.MOD-620064 06/02/23 By Claire DELETE FROM cce_file WHERE條件應再加上 cce04=g_ima01
# Modify.........: No.TQC-620151 06/02/27 By Sarah 3.0新功能增加部份,數值變數增加INITIALIZE為0,否則計算會有問題
# Modify.........: No.MOD-630010 06/03/02 By Claire 將ORDER BY 25,1  改為 order by sfa27,sfa01
# Modify.........: No.FUN-5C0099 06/03/09 By Sarah p500_ccc63_cost()段針對銷貨收入[減項]本幣未稅金額的計算應多考慮，銷退折讓未立帳者，可抓取出貨單身之折讓金額
# Modify.........: No.FUN-570153 06/03/14 By yiting 批次作業修改
# Modify.........: No.FUN-630059 06/03/21 By ching asrt300報工未入庫應計算
# Modify.........: No.TQC-630124 06/04/07 By Claire 區分oracle及informix語法
# Modify.........: No.FUN-640045 06/04/08 By Sarah 執行成本要素更新作業(axcp333)未打勾,仍會出現axcp333的視窗
# Modify.........: No.FUN-640153 06/04/11 By Sarah INSERT INTO ccc_file出現錯誤訊息-239,請針對此訊息對於錯誤的料號應明示
# Modify.........: No.FUN-620062 06/04/27 By Sarah 將當初被MOD-4B0055所mark掉的MOD-4A0185段回復
# Modify.........: No.FUN-630019 06/05/22 By Sarah 若雜收之單位與庫存單位不符時,取雜收單價時,單價亦應考慮異動/庫存轉換率,不然,成本計算會有誤(ccc44_cost add inb13 / s_umfchk(inb04,inb08,ima25))
# Modify.........: No.FUN-650001 06/05/24 By Sarah 增加計算入庫細項資料 
# Modify.........: No.MOD-660010 06/06/05 By Claire 重工工單無開帳金額不應跳出
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-660184 06/06/26 By Sarah 3.1成本改善
# Modify.........: No.FUN-660197 06/06/29 By Sarah 增加抓下階料報廢數(cch311) 
# Modify.........: No.FUN-670009 06/07/10 By Sarah 3.1成本改善:axc_借還料(借還料視同雜收發模式)
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-660086 06/07/12 By Sarah 3.1成本改善:聯產品成本計算改善
# Modify.........: No.FUN-670058 06/07/17 By Sarah 拆件入庫改為入庫,不歸領用(退料)(增加p500_reshare2() 抓拆拆件入庫,重計)
# Modify.........: No.FUN-670100 06/07/26 By Sarah 1.借還料之本月入庫金額計算有誤
#                                                  2.入庫細項─調整入庫金額(ccc22a5~ccc22e5)抓axct002之當月調整金額(ccb22a~ccb22e)
#                                                  3.p500_reshare2()裡CALL p500_ccc_upd()前增加CALL p500_ckp_ccc()判斷NOT NULL
# Modify.........: No.FUN-680007 06/08/02 By Sarah 增加p500_cct2ccg(),在算完p500_reshare2()之後,將cct_file,ccu_file寫入ccg_file,cch_file
# Modify.........: No.MOD-680027 06/08/08 By pengu DEFINE qty1,qty2  INTEGER 調整為DEFINE qty1,qty2  LIKE tlf_file.tlf10
# Modify.........: No.MOD-680021 06/08/17 By pengu 調整delete SQL條件寫法
# Modify.........: No.FUN-680079 06/08/30 By Sarah 修改FUNCTION p500_cct2ccg()裡l_ccg.ccg21,l_ccg.ccg31計算方法
# Modify.........: No.TQC-680154 06/08/30 By Sarah 將p500_reshare()搬到endrework()前面
# Modify.........: No.FUN-660154 06/09/01 By Sarah wip_ccg21.ccg21= wip_ccg31.ccg31  when sfb39='2'
# Modify.........: No.FUN-680122 06/09/05 By zdyllq 類型轉換 
# Modify.........: No.TQC-690005 06/09/07 By Ray 本月期初在制金額<>上月期末在制金額
# Modify.........: No.FUN-690068 06/09/18 By Sarah 成本加入"訂單出貨"(ccc81,ccc82,ccc82a~ccc82e)
# Modify.........: No.FUN-6A0146 06/10/27 By bnlent l_time轉g_time
# Modify.........: No.CHI-6C0013 06/12/07 By Sarah 當庫存單位與銷售單位不同時,ccc63(銷貨收入金額)應該要一樣
# Modify.........: No.TQC-6C0017 06/12/12 By Sarah 拆件式工單測試改善
# Modify.........: No.MOD-690052 06/12/13 By pengu 修改sql語法
# Modify.........: No.MOD-6C0068 06/12/13 By Sarah p500_ccc_ins()段增加判斷,若mccg.ccg92,mccg.ccg32為Null的話,要給予0的預設值
# Modify.........: No.MOD-6C0146 06/12/28 By Sarah 
# 1.取期初在製開帳數量,判斷ccf04='' OR ccf04 IS NULL會取不到值,因為投入量會設定ccf04=' DL+OH+SUB'
# 2.新增欄位工單入庫數(ccc213)是本月入庫數(ccc21)的明細,故需排除重工的部份,否則將形成數量含重工,但金額不含的不一致現象
# 3.針對聯產品改寫的部份需排除非成本倉的資料,否則資料核對錯誤
# 4.計算主件轉出數量亦需排除非成本倉的資料,否則資料核對錯誤
# Modify.........: No.MOD-720011 07/02/08 By pengu 若有做借入時數字(ccc214雜入)數量會Double
# Modify.........: No.MOD-710176 07/03/02 By Sarah 增加期末金額(ccc92,ccc92a~ccc92e)依ccz26取位
# Modify.........: No.MOD-710063 07/03/02 By Sarah 當工單是分批入庫時，入庫明細的委外入庫、生產入庫的金額都會累加
# Modify.........: No.MOD-730049 07/03/15 By pengu 程式段三處有GROUP BY 1的語法要改掉,否則會抓不到資料
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.MOD-720031 07/04/03 By pengu wip_ccg21()計算每張工單的投入數量,應該要考慮生產單位與庫存單位不同
# Modify.........: No.MOD-740382 07/04/27 By Sarah 借還料成本計算,若採原數償還時異動成本為0,抓不到成本
# Modify.........: No.MOD-740166 07/04/27 By Sarah 入庫細項計算時，生產入庫(ccc22a3)金額計算需排除委外工單、委外重工工單
# Modify.........: No.FUN-750002 07/05/02 By kim 更新 tlf_file "異動成本"先依 axcs010(成本參數)成本金額小數位數(ccz26) 取位後再更新 tlf_file
# Modify.........: No.FUN-740253 07/05/03 By Sarah 拆件入庫的異動不應該歸為"本月入庫"ccc21，應該比照以前版本作為"工單領用"ccc31的減項(取當月加權平均單位成本)才對!
# Modify.........: No.FUN-740259 07/05/03 By Sarah 生產入庫金額(ccc223,ccc22a3~ccc22e3)應加入ccg32,ccg32a~ccg32e本月因工單被強制結案而轉出的在製成本金額
# Modify.........: No.FUN-740258 07/05/08 By Sarah 當該月工單無入庫量,但工單下階元件有報廢量時,將本月轉出金額清為0
# Modify.........: No.MOD-750117 07/05/25 By Carol p500_del()拆件式工單的舊資料清除SQL跟cch_file的處理相同
# Modify.........: No.MOD-750124 07/05/31 By Carol 聯產品的判斷改用ima905='Y'的檢查
# Modify.........: No.TQC-760081 07/06/08 By pengu 調整MOD-750117
# Modify.........: No.FUN-770032 07/07/10 By Sarah 成本計算增加廠對廠直/間接調撥,撥出廠寫入雜發,撥入廠寫入雜收
# Modify.........: No.MOD-770051 07/07/11 By Sarah 修正FUN-740259修改後問題(入庫細項金額會Double)
# Modify.........: No.TQC-780064 07/08/21 By Sarah 分攤方式-標准工時段寫法修正(958行)
# Modify.........: No.TQC-790100 07/09/17 BY Joe 修正Primary Key後, 程式判斷錯誤訊息時必須改變做法
# Modify.........: No.TQC-790122 07/09/21 By Mandy ora中文刪除
# Modify.........: No.TQC-790127 07/09/23 By chenl 將FUN-650001增加內容移動至end foreach前。
# Modify.........: No.MOD-780053 07/09/28 By Carol 調整p500_ccc44_cost()雜收相關資料當月某料件正負相抵時,使得ccc21或ccc11=0,但tlf10不為0時的取不到對應單價的狀況
# Modify.........: No.MOD-7A0166 07/10/31 By Pengu 在計算元件轉出時應該要在乘上發料單位/庫存單位換算率
# Modify.........: No.CHI-7B0022 07/11/15 By Sarah 
# 1.只要有拆件式的領用,計算出來的金額都會double
# 2.拆件式工單拆出數量與金額在寫入ccg_file,cch_file時,應寫入投入數量與金額,而非轉出數量與金額
# 3.聯產品的計算有誤,應在每個要判斷g_ima905的地方重新抓值才能正確判斷
# 4.計算成本時應考慮新增的暫估帳款性質(apa00=16,26)
# Modify.........: No.MOD-7B0238 07/11/28 By Pengu 入庫明細會沿用上期的值
# Modify.........: No.TQC-7C0126 07/12/10 By Carrier 1.SELECT apb時,用絕對值  2.去除衝暫估單據,否則有重復
# Modify.........: No.MOD-7C0125 07/12/18 By chenl 修正p_sw='4'時的重復判斷。
# Modify.........: No.MOD-7C0126 07/12/18 By Lifeng 1.把下階料報廢統計SQL從FOREACH中拉出來放到外面建立臨時表
#                                                   2.對一些計算子函數加事務管控 
#                                                   3.修正后台無法運行的錯誤。
# Modify.........: No.FUN-7C0083 07/12/25 By Sarah 組合單成本計算，將B與C組合成A的話，A的異動成本必須來自B+C
# Modify.........: No.FUN-7C0028 08/01/30 By Sarah 
# 5.1成本改善：1.改為依年度+月份+料號+計算類別+類別編號計算
#              2.製費劃分為五種，分攤方式改為1.實際工時 2.標準工時 3.標準機時 4.產出數量*分攤係數
#              3.新增tlfc_file記錄依"成本計算類別"的異動成本,在每一個有異動tlf_file的地方,寫完tlf_file之後,INSERT(OR UPDATE)tlfc_file
#              4.ccb_file,ccc_file,cce_file,ccf_file,ccg_file,cch_file,ccl_file,cct_file,ccu_file,cxa_file,cxb_file,cxc_file,cxd_file寫入成本計算類型、製費三、製費四、製費五
#              5.增加處理倉庫調撥aimt324的成本,由axct501寫入單價,成本計算時寫入雜項入庫(入庫明細寫入調整入庫)
#              6.在成本計算前,依選擇之成本計算方式,先更新該計算年月的所有tlfcost值,再做成本計算 p500_tlfcost_upd()
# Modify.........: No.MOD-7B0231 08/03/18 By Pengu 銷貨收入應排除出至境外倉的資料
# Modify.........: No.TQC-830042 08/03/21 By wujie p500_reshare中增加對ima905='N'的處理
# Modify.........: No.MOD-820051 08/03/23 By Pengu 再算本月投入量時，當工單有用分站發料時其投入量會異常
# Modify.........: No.MOD-840082 08/04/19 By Pengu 入庫細項中採購入庫金額會與本月入庫金額與採購入庫金額不符
# Modify.........: No.MOD-840460 08/04/21 By Sarah p500_tlf21_upd()在將金額寫入ccc欄位前,增加先做取位再加進去
# Modify.........: No.MOD-840432 08/04/21 By Sarah p500_ins_tlfc(),改成判斷若已有tlfc_file資料存在,則先刪除再做新增
# Modify.........: No.MOD-840402 08/04/22 By Sarah 調整p500_ccc44_cost()段抓不到不同種類單價顯示的訊息
# Modify.........: No.MOD-840314 08/04/22 By Sarah 1.p500_tlf21_upd()在算重工工單時,計算amtf,amtg,amth算錯 2.p500_ccc_ccc26()在抓cch資料時,SUM(cch22h*-1)誤寫成SUM(cch2h*-1),造成重工領出金額皆為0
# Modify.........: No.MOD-850185 08/05/22 By claire 語法調整sfq04 IS NOT NULL OR sfq04 !=' ' 要改為用AND 
# Modify.........: No.MOD-850192 08/05/22 By claire 語法調整 unique (sfv04) informix 要改寫 unique sfv04,但oracle都可
# Modify.........: No.MOD-840461 08/04/25 By Sarah 個別認定成本計算問題
# Modify.........: No.MOD-860140 08/06/16 By Sarah 將p500_ccg4_cost()端中抓SUM(sfv09)的SQL改成與p500_ccg2_cost()段一樣,改抓SUM(tlf10)
# Modify.........: No.FUN-840151 08/06/23 By Sherry 增加成本倉庫群組 (imd09)
# Modify.........: No.MOD-860183 08/06/26 By Sarah l_sfv09要寫入cce_file前,要先乘以轉換率ima55_fac,換算成庫存數量再寫入
# Modify.........: No.MOD-850148 08/07/13 By Pengu 委外入庫明細應排除委外重工部分
# Modify.........: No.MOD-850154 08/07/13 By Pengu 計算應收金額時應加上apa42='N'之條件(即排除作廢之ap)
# Modify.........: No.MOD-870111 08/07/16 By Sarah 若有報廢數(cch311),且工單結案,則應該要把報廢納入在本月轉出(cch31)內
# Modify.........: No.MOD-880061 08/08/07 By chenl 將oga00='7'即寄銷訂單排除在計算範圍內，另將oga65='Y'，即需客戶簽收的單據排除在計算範圍內,oga09='9'即客戶驗退單也必須排除計算範圍。
# Modify.........: No.TQC-880013 08/08/08 By lumx  增加判斷l_ccu.ccu31為NULL則給0，否則后續LET g_ccc.ccc31 =g_ccc.ccc31 +l_ccu.ccu31這一句會導致g_ccc.ccc31的值被清掉
# Modify.........: No.MOD-880198 08/08/26 By Sarah 拆件式工單在寫入ccc_file時,是CALL p500_ccc_upd(),但當料件除了拆件入庫外沒做其他動作的話,會無法UPDATE ccc_file,所以判斷若UPDATE ccc_file失敗即INSERT ccc_file
# Modify.........: No.MOD-880241 08/09/03 By Pengu select錯誤訊息時應加上執行者作為條件
# Modify.........: No.MOD-880040 08/09/18 By Pengu 重複性生產的工單入庫量不會寫入ccc213
# Modify.........: No.MOD-8A0219 08/10/24 By sherry 計算被替代料在制成本轉出的時候會有問題
# Modify.........: No.MOD-8B0143 08/11/14 By Sarah 1.UPDATE ccc_file前,先CALL p500_ckp_ccc()
#                                                  2.wip_c3抓出的tlf相關數值變數,需判斷若為NULL則給預設值0
# Modify.........: No.MOD-8A0285 08/11/15 By Pengu 只計算某顆主件的月加權平均成本時,其再製本月投入數量、金額會Double
# Modify.........: No.MOD-8C0031 08/12/05 By chenyu 本月工單投入量ccg21算法改變
# Modify.........: No.MOD-8C0062 08/12/05 By sherry 對ccc62a~ccc62e,ccc65,ccc66a~ccc66e,ccc82a~ccce進行取位
# Modify.........: No.MOD-8C0072 08/12/08 By chenyu 如果當月工單無入庫，但是結案，應該轉出
# Modify.........: No.MOD-8C0284 08/12/29 By sherry p500_tlf21_upd()函數里面沒有考慮是否是雜收，導致入庫金額不匹配
# Modify.........: No.MOD-910079 09/01/08 By liuxqa 1.計算方式為：先進先出時，insert into cax_file時，沒有cxa010,cax011這兩個欄位，應加上。
#                                                   2.后測試發現q_tlf.tlfcost沒有在程式中定義，但是程序卻有用到，應加上。
# Modify.........: No.MOD-910152 09/01/14 By wujie  insert tlfc時，雜收的應該排除
# Modify.........: No.MOD-910162 09/01/15 By chenyu cxa096,7,8這三個欄位如果為空，要等于0
# Modify.........: No.MOD-910175 09/01/15 By Pengu 計價單位與庫存單位不一樣時銷貨收入會與應收帳款金額不一致
# Modify.........: No.MOD-890070 09/01/15 By chenl 修正因重工工單導致的計算月平均單價為負數的情況。
# Modify.........: No.MOD-910002 09/01/17 By Pengu 重複計算某月成本時，拆件式工單會有累加情形發生
# Modify.........: No.FUN-890031 09/01/17 By Pengu  計算前是否先刪除舊資料，預設為Y
# Modify.........: No.MOD-910215 09/01/19 By Pengu 生產領用金額無法產生
# Modify.........: No.MOD-910214 09/02/01 By chenyu p500_last0()中select語句會出現-284的錯誤
# Modify.........: No.MOD-920009 09/02/02 By Pengu 程式沒有g_cct.cct04這個變數，應該是l_cct.cct04才對
# Modify.........: No.MOD-920010 09/02/02 By Pengu wipx_c2_24 CURSOR的where 條件ccu04 != ' DL+OH+SU'少了一個B
# Modify.........: No.CHI-910041 09/02/03 By jan tlf21,tlf221,tlf222,tlf2231,tlf2232,tlf224,tlf2241,tlf2242,tlf2243,tlf211,tlf212,tlf65替換成
#............................................... tlf21x,tlf221x,tlf222x,tlf2231x,tlf2232x,tlf224x,tlf2241x,tlf2242x,tlf2243x,tlf211x,tlf212x,tlf65x 
#............................................... 將帳務標准版的成本(ccz28選的項目)回寫 tlf21~tlf65 
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.MOD-920071 09/02/05 By chenl 排除調撥單記錄到cxa_file
# Modify.........: No.MOD-920107 09/02/07 By claire k定義調整
# Modify.........: No.MOD-8C0136 09/02/07 By Pengu 計算結存調整時應該是要取完位候在進行計算
# Modify.........: No.MOD-8C0084 09/02/07 By Pengu p500_cct2ccg()中的l_ccg.*與l_cch.*未給初始值
# Modify.........: No.MOD-8C0074 09/02/07 By Pengu 在wip_32()中增加判斷l_cch.cch11與l_cch.cch21是否為NULL
# Modify.........: No.MOD-920085 09/02/09 By chenyu 先進先出算法下，期末金額不能和加權平均算法一樣算
# Modify.........: No.MOD-920189 09/02/16 By chenyu 盤盈虧的，沒有區分先進先出還是加權平均
# Modify.........: No.MOD-920222 09/02/16 By Pengu 製費二~五的轉出金額未計算出
# Modify.........: No.MOD-930168 09/03/16 By chenyu MOD-8C0031修改的算法有誤
# Modify.........: No.MOD-930237 09/03/25 By chenyu 1.先進先出算法的問題
#                                                   2.倉退的情況沒有考慮
# Modify.........: No.MOD-940063 09/04/16 By chenl 1.調整sql語句。
# Modify.........:                                 2.調整公式。
# Modify.........: No.CHI-940027 09/04/23 By ve007 制費分為5大類
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.CHI-910019 09/05/20 By Pengu 部份的退貨折讓成本會無法抓取到AP的金額因程式段只抓apa58=2
# Modify.........: No.MOD-940352 09/05/20 By Pengu 入庫段有排除調撥單的部份出庫卻沒有
# Modify.........: No.MOD-950040 09/05/20 By Pengu 倉退應是用應付金額update tlf21
# Modify.........: No.MOD-950252 09/05/26 By Pengu 調整再至轉出的公式
# Modify.........: No.TQC-950184 09/05/31 By xiaofeizhu 調整的p500()中l_sw,l_cnt1,l_sw_tot,l_count的定義
# Modify.........: No.MOD-970029 09/07/03 By xiaofeizhu 調整p500_last0()中,一旦有料號開賬導致其他料號無法生成cxa_file的問題
# Modify.........: No.TQC-970279 09/07/27 By xiaofeizhu 修改UPDATE ccc_file處的SQL語法錯誤
# Modify.........: No.MOD-970288 09/08/12 By mike 應將l_c22與l_c21移到最后
# Modify.........: No.FUN-980009 09/08/20 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.CHI-970021 09/08/20 By jan 1.拿掉caa_file的join,where條件，2.caa04-->caa041
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-990056 09/09/07 By xiaofeizhu axcp500的函數ccc22_cost()中遺漏了對amtf/amtg/amth的清空
# Modify.........: No.MOD-990062 09/07/07 By Carrier wipx_3()中的c23f/c23g/c23h清0
# Modify.........: No.MOD-9A0063 09/10/09 By liuxqa 計算拆件式工單的投入錯誤。
# Modify.........: No.TQC-9A0019 09/10/09 By liuxqa 修正FUN-7C0028.
# Modify.........: No.MOD-9A0073 09/10/13 By Pengu 當月有聯產品生產也有委外加工時，若委外未入庫即結案則金額不會算到
# Modify.........: No.CHI-9A0021 09/10/15 By Lilan 將YEAR/MONTH的語法改成用BETWEEN語法
# Modify.........: No.TQC-9B0021 09/11/05 By Carrier SQL STANDARDIZE
# Modify.........: No:MOD-9A0151 09/11/06 By Pengu INF版執行時會出現trx_prep發生語法錯誤訊息
# Modify.........: No:MOD-990223 09/11/10 By Pengu 調撥單卻出現雜收無金額(axct500)的訊息
# Modify.........: No.FUN-980031 09/11/11 By jan 因cae08項次有調整，所以此作業中相關判斷邏輯也做調整
# Modify.........: No:MOD-990057 09/11/12 By sabrina 調整MOD-890070的修改
# Modify.........: No:MOD-9A0029 09/11/12 By sabrina 拆件式工單結案會出現結存還有數量
# Modify.........: No:CHI-990065 09/11/12 By sabrina 出至境外倉不應寫到銷退金額
# Modify.........: No:MOD-9B0138 09/11/24 By sabrina 調撥資料不會被納入入庫細項
# Modify.........: No:MOD-980104 09/11/25 By sabrina 拆件式供單若未結案則會沒有在製的人工製費
# Modify.........: No:MOD-980105 09/11/25 By sabrina 變數未給default值
# Modify.........: No:MOD-990009 09/11/25 By sabrina 若該料當月有聯產品入且又有委外重工時，重工入會沒有金額
# Modify.........: No:MOD-970102 09/11/26 By sabrina 調撥單不會被算到
# Modify.........: No:MOD-960062 09/11/27 By sabrina 在計算約當數時不應抓取到上月的約當量
# Modify.........: No:TQC-970003 09/12/01 By jan 批次成本修改
# Modify.........: No:FUN-9B0118 09/12/03 By Carrier add cdc11
# Modify.........: No:TQC-9C0020 09/12/03 By Carrier UNION ORDER BY 问题处理
# Modify.........: No:FUN-9C0009 09/12/03 By dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No:TQC-9C0074 09/12/10 By jan 修改sql語句
# Modify.........: No:MOD-9C0395 09/12/24 By Pengu 計算批次成本時，會產生數量金額均為0的ccc_file資料
# Modify.........: No:FUN-9C0073 10/01/11 By chenls 程序精簡
# Modify.........: No:MOD-A10068 10/01/13 By Pengu ccc62f~ccc62h未取位
# Modify.........: No:MOD-A10036 10/01/13 By Pengu 參數設定人工製費一年月輸入時，若ccj05=0則人工製費會算不出來
# Modify.........: No:CHI-980045 10/03/09 By kim 銷退成本視參數設定列入庫成本
# Modify.........: No:TQC-A30126 10/03/24 By kim ccz32勾選"出貨成本"時，需以單價做為出貨成本計，目前沒考慮數量
# Modify.........: No:MOD-A30165 10/03/23 By Carrier wip2_4 SELECT 字段错误
# Modify.........: No:FUN-A20037 10/04/02 By lilingyu 替代碼sfa26加上"7,8,Z"的條件
# Modify.........: No:FUN-A40023 10/03/19 By dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造 
#                                                 成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No:MOD-A30220 10/03/29 By Sarah 將組合單與拆解單寫入入庫細項-雜項入庫
# Modify.........: No.FUN-A50075 10/05/24 By lutingting GP5.2 AXC模組TABLE重新分類,相關INSERT語法修改
# Modify.........: No:MOD-A60053 10/06/08 By Sarah 數值變數使用前應先歸零,計算後須判斷若為Null要給預設值
# Modify.........: No:MOD-A60192 10/07/02 By Sarah 計算銷貨收入時應該要將oga00='2'換貨出貨的部分排除掉
# Modify.........: No:MOD-A70092 10/07/12 By Sarah 雜項入庫會漏寫入庫細項數量
# Modify.........: No:TQC-A80010 10/08/03 By xiaofeizhu 一顆自制料由于無法進入tlf_temp,計算該料時g_ima01為null,所以下階領原材料有算不到的問題
# Modify.........: No:FUN-A70120 10/08/03 BY alex 調整rowid為type_file.row_id
# Modify.........: No:MOD-A80020 10/08/06 By wujie 修正仓退时数量应为负数的问题
# Modify.........: No:FUN-A20017 10/10/22 By jan 1.重工須產生入庫細項明細ccc22a2,ccc22a3  2.cce尾差調整需納入委外聯產品
# Modify.........: No.FUN-AA0059 10/11/01 By chenying 料號開窗控管
# Modify.........: No:FUN-AA0025 10/10/25 By wujie 新增工单分录结转的检查
# Modify.........: No:MOD-AA0026 10/11/09 By sabrina 若當月有聯產品入庫，則委外工單位入庫強制結案時，入庫明細沒有金額
# Modify.........: No.FUN-AB0025 10/11/10 By vealxu 全系統增加料件管控
# Modify.........: No:MOD-A90131 10/11/15 By sabrina 入庫細項的生產入庫不應包含重工入庫金額
# Modify.........: No:MOD-AB0126 10/11/15 By sabrina 重工入庫金額也不該放入入庫細項金額中的委外入庫 
# Modify.........: No:CHI-A90033 10/11/25 By Summer 若委外工單入庫未立帳須抓採購單上金額
# Modify.........: No:CHI-A30027 10/11/25 By Summer 未維護實際工時時，人工製費會無法轉出
# Modify.........: No:CHI-990044 10/12/10 By Summer 在製調整人工製費金額因依據ccz05設定做分攤
# Modify.........: No:CHI-9B0024 10/12/10 By Summer 應該使用ima12做為抓取存貨科目的依據
# Modify.........: No:MOD-AC0300 10/12/24 By Carrier 工单当月投入量逻辑修改:截止至目前的最大投入套数-截止至上月为止的最大投入套数
# Modify.........: No:MOD-AC0153 10/12/17 By Pengu 重工聯產品調整會被寫到入庫明細
# Modify.........: No:MOD-B10009 11/01/26 By Summer 為維護雜項單價維護的訊息應排除aimt306/aimt309的單據
# Modify.........: No:FUN-AB0089 11/02/25 By shenyang  修改本月平均單價
# Modify.........: No:MOD-B30004 11/03/01 By wujie     删除主件时对应的元件资料也要删除
# Modify.........: No:MOD-B30061 11/03/08 By sabrina 在update cch_file前要先將不該為null的欄位給值 
# Modify.........: No:TQC-B30129 11/03/15 By elva 增加artt256,artt215的成本处理
# Modify.........: No:MOD-B30206 11/03/17 By huangtao FUN-AB0025對g_wc加上ima120的條件，但相關temp table未對增加ima120欄位
# Modify.........: No:MOD-B30205 11/03/17 By lixh1    單價調整
# Modify.........: No:MOD-B30528 11/03/17 By Pengu 專案成本會出現違反唯一限制的錯誤
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:MOD-B30085 11/04/07 By wujie   通过ccg31计算cch31时，未考虑ima55_fac的换算
# Modify.........: No.FUN-B40029 11/04/13 By xianghui 修改substr
# Modify.........: No:MOD-B50048 11/05/09 By sabrina l_fac長度應與inb08_fac一樣 
# Modify.........: No:MOD-B50225 11/05/26 By zhangll 修正IF條件
# Modify.........: No:MOD-B60033 11/06/03 By Pengu 專案成本時，元件在製不會依專案寫入cch_file
# Modify.........: No:MOD-B70143 11/07/15 By lilingyu 在axct500中補單價之後,再過賬還原修改杂收單,再審核,tlf221,tlf21x,tlf221x金金額會清空
# Modify.........: No:MOD-B50081 11/07/17 By Pengu 在算聯產品分攤比例時應排除代買料
# Modify.........: No:MOD-B40029 11/07/17 By Pengu 委外加工費，應依委外入庫單判斷是否有應付若沒有則抓入庫單金額
# Modify.........: No:MOD-B20005 11/07/17 By Pengu 委外聯產品分攤錯誤
# Modify.........: No:MOD-B10151 11/07/17 By Pengu 當月只有雜收且做倉退時，ccc_file會沒有資料
# Modify.........: No:MOD-B10173 11/07/17 By Pengu 分倉成本若有上期開帳則ccc_file會多一筆資料
# Modify.........: No:MOD-B60127 11/07/17 By Summer l_sfv_rate變數型態改為num26_10 
# Modify.........: No:MOD-B30728 11/03/31 By sabrina 取工時資料應考慮ccifirm='Y'
# Modify.........: No:MOD-B50083 11/07/17 By Summer tlf10與tlf60轉換率造成小數尾差。需使用ROUND做取位後再SUM 
# Modify.........: No:CHI-B30076 11/08/10 By lixh1  修正tlf_file,tlfc_file各項成本費用的計算
# Modify.........: No:FUN-B90029 11/11/01 By jason 增加當站下線成本處理
# Modify.........: No:MOD-BB0074 11/11/12 By johung 背景程式start_date給預設值TODAY/start_time給TIME
# Modify.........: No:FUN-BB0038 11/11/21 By elva 修改借贷方科目
# Modify.........: No:MOD-C10137 11/01/16 By yinhy 修正若上個月有成本但是全為0，銷退不抓取開賬單價的問題
# Modify.........: No:MOD-B90018 12/01/16 By Vampire 委外聯產品入庫金額均無計算到，修正IF判斷
# Modify.........: No:MOD-B90058 12/01/16 By Vampire 將l_bdate01改為l_bdate，l_edate01改為l_edate
# Modify.........: No:FUN-BB0063 12/02/13 By bart 成本考慮委外倉退金額
# Modify.........: No:MOD-C20112 12/02/13 By ck2yuan p500_tsdf_tlf_c1裡的SQL，將g_tlf.tlfcost改為g_tlfcost
# Modify.........: No:MOD-C20103 12/02/14 By ck2yuan 抓取pmm22,pmm42應考慮無採購單收貨 rva00=2
# Modify.........: No:MOD-C20108 12/02/14 By ck2yuan 計算銷售成本時 (出貨)，如果oga65='Y'就不計算
# Modify.........: No:MOD-B80246 12/02/15 By bart 聯產品委外加工費算不到
# Modify.........: No:MOD-B90037 12/02/15 By bart 製程委外加工廢會算不到
# Modify.........: No:MOD-B90237 12/02/15 By bart 聯產品分配率在計算重工入庫時少寫了sfv04=cjp04，造成分攤數可能因為多筆入庫單而倍增 
# Modify.........: No:MOD-C20130 12/02/16 By ck2yuan 5.1以後計算人工,製費成本流程不走axcp300,故不用抓取cck_file
# Modify.........: No:FUN-BC0062 12/02/20 By lilingyu 成本計算類型(axcs010)不可選擇【6.移動加權平均成本】
# Modify.........: No:MOD-C30658 12/03/14 By fengrui 抓取npp_file資料行數的WHERE條件中添加日期條件
# Modify.........: No:MOD-C30756 12/03/16 By ck2yuan 驗退的部分因為沒有入庫也沒有收到款項，不會有金額的問題，因此不應計入
# Modify.........: No:MOD-C20087 12/03/19 By Elise 修正單跑一個料件時，會把所有cch04 = ' DL+OH+SUB'的cch_file砍掉的問題
# Modify.........: No:MOD-C30809 12/03/20 By ck2yuan 修改MOD-C20108 Bug,若撈不到值會延續上一筆的l_oga56
# Modify.........: No:MOD-C30891 12/04/02 By Elise 除了cl_used以外，有用到g_time的都應mark掉改用t_time
# Modify.........: No:MOD-C40032 12/04/05 By ck2yuan 5.1針對委外工單產生入庫明細處理(TQC-980002)但5.3未加上
# Modify.........: No:MOD-C30060 12/04/11 By yinhy p500_chk()中l_sql缺少年月條件，否則當月計算成本，但憑證是上月的也會報錯
# Modify.........: No:MOD-C40187 12/04/24 By ck2yuan 聯產品寫到cce_file金額應依ccz26取位
# Modify.........: No:FUN-C50009 12/05/03 By bart 當行業別為ICD時，計算加工費那一段要把tlf委外入庫入非成本倉的資料抓進來算。
# Modify.........: No:MOD-C50078 12/05/11 By ck2yuan lb_cce.cce22加總後可能剛好為0,應判斷只有cce22a~cce22h有一個不為0就要調尾差
# Modify.........: No:MOD-C50138 12/06/01 By ck2yuan 下階料有相同料分不同作業編號，工單完工部分入庫時，計算轉出有誤
# Modify.........: No:MOD-C50084 12/06/01 By ck2yuan 人工製費金額的抓取不需再by成本中心一個一個抓，因為在axcp311已攤到axcq311，抓axcq31
#                                                    委外工單在sum(rvv17)時應判斷rvu00='1'，排除驗退
# Modify.........: No:MOD-C50200 12/06/18 By Elise 當站下線以退料計，故當站不作轉出
# Modify.........: No:TQC-C60173 12/06/21 By zm 1.委外仓退数量未体现在主件转出中  2.委外仓退金额已扣减在加工费中,其材料金额不应重复扣减
# Modify.........: No:MOD-C60140 12/06/28 By ck2yuan 分倉成本計算產生ccc_file有空白類別問題
# Modify.........: No:MOD-C70002 12/07/03 By ck2yuan 取完axct500值後continue ,tlf沒有被update axct500的成本
# Modify.........: No:MOD-C70092 12/07/09 By ck2yuan 計算分配比率的sql有誤,應要排除非成本倉
# Modify.........: No:FUN-C70014 12/07/09 By wangwei 新增RUN CARD發料作業
# Modify.........: No:MOD-C70111 12/07/10 By wujie  MOD-B30004删除CCH的修改应放在if判断内
# Modify.........: No:MOD-C70249 12/07/25 By ck2yuan 處理aimt324的部分 多加入處理aimt325
# Modify.........: No:MOD-C70272 12/07/27 By ck2yuan 委外工單入庫後倉退,金額應僅呈現在委外入庫的金額欄
# Modify.........: No:MOD-C80036 12/08/06 By yinhy 成本計算時，將未審核和作廢的工單也抓出來了
# Modify.........: No:MOD-C80123 12/08/17 By ck2yuan TQC-B30129修改錯誤
# Modify.........: No:CHI-C80002 12/10/05 By bart 改善效能 1.NOT IN 改為 NOT EXISTS 2.declare cursor 移到foreach外面
# Modify.........: No:MOD-C90098 12/09/12 By yinhy 去掉p500_cct2ccg()中ccu_c1中ccu07
# Modify.........: No:MOD-CA0185 12/11/06 By Elise 修正tlf21_c
# Modify.........: No:MOD-CA0177 12/11/06 By Elise 取消走專案成本多update部分
# Modify.........: No:MOD-CB0054 12/11/07 By wujie ccc63_cost()中，若走开票流程oaz92 =‘Y'，则只抓omb资料，且票据日期要在当前成会期间
# Modify.........: No:MOD-CB0035 12/11/05 By wujie 元件料件为DL+OH+SUB的时候应控制转出金额不能大于期初+投入金额，
#                                                  否则会造成在axcr004的在制下阶部分在制中人工、制费余额是负数。以上来源是广盛锦祥cxcp500的修改
# Modify.........: No:MOD-CB0127 12/11/14 By wujie 对MOD-CB0035追加cch32的处理
# Modify.........: No:FUN-C80092 12/12/04 By xujing 添加根據g_bgjob條件 update ckkacti
# Modify.........: No:FUN-C80092 12/12/04 By xujing 成本相關作業程式日誌
# Modify.........: No:FUN-CC0002 12/12/05 By zm 当站报废可以依参数设置当月转出
# Modify.........: No:TQC-CC0131 12/12/26 By wujie 将委外加工费从材料金额中扣除
# Modify.........: No:TQC-CC0145 12/12/28 By wujie 增加抓取折让性质为空，apa58 is null的资料
# Modify.........: No:CHI-C80041 13/01/03 By bart 1.增加作廢功能 2.刪除單頭
# Modify.........: No:CHI-AA0002 13/01/10 By Alberti 重工退料轉出改成依當月入庫比例計算
# Modify.........: No:MOD-D10018 13/01/10 By Alberti QPA為負,計算後cch31轉出數量應該為正
# Modify.........: No:CHI-B10036 13/01/10 By Alberti 當相同料有分站發料，或是部分取替代時，工單轉出量會異常
# Modify.........: No:FUN-D10031 13/01/21 By wujie 沒有考慮某個料既是元件又是另一個元件的替代料的情況，在wip_32()追加考慮這種情況的處理
# Modify.........: No:CHI-B90013 13/01/22 By Alberti 銷貨收入應取未稅金額
# Modify.........: No:MOD-C70153 13/01/28 By Alberti  銷退不折讓不換貨時，銷貨收入應扣掉銷退的金額
# Modify.........: No:CHI-A70023 13/01/30 By Alberti 調整成品替代的銷貨收入
# Modify.........: No:CHI-D10020 13/02/18 By bart 預計修改方式為成本計算時，改抓工單之已發套數-sum(前期已發)
# Modify.........: No:MOD-D20053 13/02/19 By bart rvv34可不用在指定
# Modify.........: No:MOD-D20045 13/02/19 By bart 在算 ccc21時，aimp701 未考慮 正負值(u_sign)
# Modify.........: No:FUN-D20078 13/02/26 By xujing 倉退單過帳寫tlf時,區分一般倉退和委外倉退,同時修正成本計算及相關查詢報表邏輯
# Modify.........: No.TQC-D30002 13/01/01 By xujing 處理委外倉退問題  remark TQC-CC0131的程式段
# Modify.........: No:MOD-C90065 13/03/05 By Alberti 修正CHI-B10036 錯誤
# Modify.........: No:MOD-C90111 13/03/06 By Alberti p500_ccg2_cost()中聯產品分攤的分母,不應入庫量減去驗退量
# Modify.........: No:MOD-D30034 13/03/06 By bart 排除非成本倉判斷
# Modify.........: No:MOD-D30152 13/03/15 By wujie 使用回收料功能时，只有投入没有转出
# Modify.........: No:MOD-D40085 13/04/16 By ck2yuan 進入p500_tlf28()，先update tlf28=''
# Modify.........: No:MOD-D50062 13/05/08 By wujie p500_ccc22_cost()中抓出货单时增加axmt650，axmt820,axmt821
# Modify.........: No:MOD-D50120 13/05/14 By suncx l_cch.cch04 = ' ADJUST'時少了制費三、四、五的賦值
# Modify.........: No:MOD-D50142 13/05/16 By suncx 沒有考慮ADJUST，需要排除ADJUST
# Modify.........: No:MOD-D50220 13/05/27 By wujie FUN-7C0028将CCC92错写成ccc12
# Modify.........: No:FUN-D40103 13/05/09 By lixh1 增加儲位有效性檢查
# Modify.........: No:FUN-D60130 13/06/28 By xianghui 有已结案工单委外仓退的单据,则产生一张该料的加工费调整单,成本计算前删
# Modify.........: No:FUN-D70038 13/07/08 By bart asms270的sma129='N'時，依CHI-D10020修改方式抓取，sma129="Y"時，維持產程式抓取方式
# Modify.........: No:MOD-DA0096 13/10/16 By suncx 使用先進先出算法時,重复衝銷
# Modify.........: No:MOD-DB0067 13/11/08 By suncx 完善FUN-D10031的處理
# Modify.........: No:MOD-E50052 14/02/25 By SunLM 注记:MOD-E50052,委外仓退折让金额不排除,待讨论
# Modify.........: No:140225     14/02/25 By SunLM 计算工单工艺委外未发料,但已经有委外入库,委外工费成本
# Modify.........: No:MOD-E40023 14/04/03 By SunLM 對cch32f、cch32g、cch32h、cch92f、cch92g、cch92h为null给赋值0
# Modify.........: No.130530001  14/04/09 By SunLM daiyy 联产品分摊比率调整 测试中,待确定,请等待
# Modify.........: No.140422              By SunLM 當材料為代買料入庫時候,因為前端未產生發料單,所以要直接賦值
# Modify.........: No.kuangxj    150319   By kuangxj回收p_sser-流水号:2015030336 ，修正拆件式工单人工制费没有数量
# Modify.........: No.2015080089 15/08/21 By kuangxj 当ccg32f,ccg32g,ccg32h为null,导致ccc22f为空,最后导致ccc23为空,期末库存金额不对,数额对
# Modify.........: No:MOD-L30003 21/03/16 By Dido 排除工單類型7.委外工單8.重工委外工單，避免加工費重複計算 #add by liy210707
IMPORT os   #No.FUN-9C0009  
DATABASE ds

GLOBALS "../../config/top.global"
 
DEFINE yy               LIKE ccz_file.ccz01,   #No.FUN-680122SMALLINT, #TQC-790122
       mm               LIKE ccz_file.ccz02,   #No.FUN-680122SMALLINT,
       type             LIKE type_file.chr1,   #FUN-7C0028 add
       choice           LIKE type_file.chr1,   #No.FUN-680122CHAR(01),
       choice1          LIKE type_file.chr1,   #No.FUN-680122CHAR(01), #MOD-540206
       sw               LIKE type_file.chr1,   #No.FUN-680122CHAR(01),  #NO.FUN-5C0001 ADD
       last_yy          LIKE ccz_file.ccz01,   #No.FUN-680122SMALLINT,
       last_mm          LIKE ccz_file.ccz02,   #No.FUN-680122SMALLINT,
       g_cost_v         LIKE ccp_file.ccp03,   #No.FUN-680122CHAR(4),
       g_ima57_t        LIKE ima_file.ima57,
       g_ima57          LIKE ima_file.ima57,
       g_ima01          LIKE ima_file.ima01,   #No.MOD-490217
       g_ima01_t        LIKE ima_file.ima01,   #No.MOD-490217
       g_tlfcost        LIKE tlf_file.tlfcost, #FUN-7C0028 add
       g_tlfcost_t      LIKE tlf_file.tlfcost, #MOD-840461 add
       g_misc           LIKE type_file.num5,   #No.FUN-680122CHAR(01),
       g_sql            STRING,                #No:9767
       g_sql1           STRING,                #FUN-610080
       g_wc             STRING,                #No:9767
       amt                       LIKE ccc_file.ccc22,      #No.MOD-530234
       amta,amtb,amtc,amtd,amte  LIKE ccc_file.ccc22a,     #No.MOD-530234
       amtf,amtg,amth            LIKE ccc_file.ccc22a,     #FUN-7C0028 add
       g_cck  RECORD LIKE cck_file.*,
       g_cdb  RECORD LIKE cdb_file.*,                      #FUN-7C0028 add
       g_ccc  RECORD LIKE ccc_file.*,
       g_cch  RECORD LIKE cch_file.*,
       g_ccu  RECORD LIKE ccu_file.*,
       g_ccs  RECORD LIKE ccs_file.*,
       g_sfb  RECORD LIKE sfb_file.*,
       mccg   RECORD LIKE ccg_file.*,
       mcct   RECORD LIKE cct_file.*,
       mccu   RECORD LIKE ccu_file.*,
       g_cca23a     LIKE cca_file.cca23a, #使用此變數, 請考慮清楚(dennon lai)
       g_ccd03          LIKE ccd_file.ccd03,         #No.FUN-680122CHAR(1),                #zzz
       g_ima16          LIKE ima_file.ima16,
       g_ima905         LIKE ima_file.ima905,
       g_tothour        LIKE cck_file.cck05,
       g_totdl          LIKE cck_file.cck03,
       g_totoh          LIKE cck_file.cck03,
       g_totoh1         LIKE cck_file.cck03, #FUN-7C0028 add
       g_totoh2         LIKE cck_file.cck03, #FUN-7C0028 add
       g_totoh3         LIKE cck_file.cck03, #FUN-7C0028 add
       g_totoh4         LIKE cck_file.cck03, #FUN-7C0028 add
       g_totoh5         LIKE cck_file.cck03, #FUN-7C0028 add
       q_tlf_rowid      LIKE type_file.row_id,   #chr18, FUN-A70120
       q_tlf RECORD
             tlf01      LIKE tlf_file.tlf01,     #料號
             tlf06      LIKE tlf_file.tlf06,     #單據日期
             tlf07      LIKE tlf_file.tlf07,     #產生日期
             tlf10      LIKE tlf_file.tlf10,     #異動數量
             tlf020     LIKE tlf_file.tlf020,    #來源廠商
             tlf02      LIKE tlf_file.tlf02,     #來源狀況
             tlf021     LIKE tlf_file.tlf021,    #倉庫別
             tlf022     LIKE tlf_file.tlf022,    #存放位置
             tlf023     LIKE tlf_file.tlf023,    #批號
             tlf026     LIKE tlf_file.tlf026,    #
             tlf027     LIKE tlf_file.tlf027,    #
             tlf030     LIKE tlf_file.tlf030,    #目的廠商
             tlf03      LIKE tlf_file.tlf03,     #目的狀況
             tlf031     LIKE tlf_file.tlf031,    #倉庫別
             tlf032     LIKE tlf_file.tlf032,    #存放位置
             tlf033     LIKE tlf_file.tlf033,    #批號
             tlf036     LIKE tlf_file.tlf036,    #
             tlf037     LIKE tlf_file.tlf037,    #
             tlf13      LIKE tlf_file.tlf13,     #
             tlf62      LIKE tlf_file.tlf62,     #工單單號
             tlf60      LIKE tlf_file.tlf60,     # No.7088.A.d
             tlf08      LIKE tlf_file.tlf08,     #No.A102
             tlf905     LIKE tlf_file.tlf905,    #No.A102
             tlf906     LIKE tlf_file.tlf906,    #No.A102
             tlf21x     LIKE tlf_file.tlf21x,     #No.A102  #CHI-910041 tlf21-->tlf21x
             tlf221x     LIKE tlf_file.tlf221x,    #No.A102 #CHI-910041
             tlf222x     LIKE tlf_file.tlf222x,    #No.A102 #CHI-910041
             tlf2231x    LIKE tlf_file.tlf2231x,   #No.A102 #CHI-910041
             tlf2232x    LIKE tlf_file.tlf2232x,   #No.A102 #CHI-910041
             tlf224x     LIKE tlf_file.tlf224x,    #No.A102 #CHI-910041
             tlf2241x    LIKE tlf_file.tlf2241x,   #FUN-7C0028 add #CHI-910041
             tlf2242x    LIKE tlf_file.tlf2242x,   #FUN-7C0028 add #CHI-910041
             tlf2243x    LIKE tlf_file.tlf2243x,   #FUN-7C0028 add #CHI-910041
             tlfcost    LIKE tlf_file.tlfcost    #MOD-910079 add by liuxqa
             END RECORD,
       g_ima08          LIKE ima_file.ima08,
       g_ima911         LIKE ima_file.ima911,   #FUN-610080 重複性生產料件(Y/N)
       g_bdate          LIKE type_file.dat,          #No.FUN-680122DATE,
       g_edate          LIKE type_file.dat,          #No.FUN-680122DATE,
       qty,qty2         LIKE tlf_file.tlf10,         #No.FUN-680122DEC(15,3),
       up,amt2          LIKE tlf_file.tlf21,         #No.FUN-680122DEC(20,6),     #MOD-4C0005
#      g_make_qty       LIKE ima_file.ima26,         #No.FUN-680122DEC(15,3),
#      g_make_qty2      LIKE ima_file.ima26,         #No.FUN-680122DEC(15,3),
       g_make_qty       LIKE type_file.num15_3,      ###GP5.2  #NO.FUN-A40023
       g_make_qty2      LIKE type_file.num15_3,      ###GP5.2  #NO.FUN-A40023
       g_make_qty3      LIKE type_file.num15_3,      #NO.TQC-C60173
       g_shb114         LIKE shb_file.shb114,        #FUN-B90029
       g_sfb99          LIKE sfb_file.sfb99,
       xxx              LIKE smy_file.smyslip,       #No.FUN-680122CHAR(05),     #No.FUN-550025
       xxx1             LIKE tlf_file.tlf026,        #No.FUN-680122CHAR(16),     #No.FUN-550025
       xxx2             LIKE tlf_file.tlf027,        #No.FUN-680122SMALLINT,
       u_sign           LIKE type_file.num5,         #No.FUN-680122SMALLINT,       # 1:入 -1:退
       u_flag           LIKE type_file.chr1,         #No.FUN-680122 VARCHAR(1)
       no_tot,p1        LIKE type_file.num10,        #No.FUN-680122INTEGER,
       no_ok,no_ok2     LIKE type_file.num10,        #No.FUN-680122INTEGER,
       start_date       LIKE type_file.dat,          #No.FUN-680122DATE,
       start_time       LIKE ccy_file.ccy02,         #No.FUN-680122CHAR(5),
       t_time           LIKE type_file.chr8,         #No.FUN-680122CHAR(8),
       g_smydmy1        LIKE type_file.chr1,         #No.FUN-680122CHAR(01),
       l_cmd            LIKE type_file.chr1000,      #No.FUN-680122CHAR(500),
       g_smy53          LIKE smy_file.smy53,
       g_smy54          LIKE smy_file.smy54, #98.09.28 Star Chang Type
       g_sw             LIKE type_file.chr1          #No.FUN-680122 VARCHAR(01)             #No.A102
DEFINE g_chr            LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
DEFINE g_cnt            LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE g_msg            LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(60)   #FUN-5B0076
DEFINE g_msg1           LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(60)   #FUN-5B0076 add
DEFINE g_msg2           LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(60)   #FUN-5B0076 add
DEFINE g_msg3           LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(60)   #FUN-5B0076 add
DEFINE g_flag           LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
DEFINE g_change_lang    LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)    #FUN-570153
DEFINE g_cka00          LIKE cka_file.cka00          #FUN-C80092
DEFINE g_cka09          LIKE cka_file.cka09          #FUN-C80092
DEFINE g_sfb02          LIKE sfb_file.sfb02 #MOD-DA0096
 
MAIN
   DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680122 SMALLINT
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc    = ARG_VAL(1)
   LET yy      = ARG_VAL(2)
   LET mm      = ARG_VAL(3)
   LET type    = ARG_VAL(4)   #FUN-7C0028 add
   LET choice  = ARG_VAL(5)
   LET choice1 = ARG_VAL(6)
   LET g_bgjob = ARG_VAL(7)
 
   IF cl_null(g_bgjob) THEN LET g_bgjob = 'N' END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818 #No.FUN-6A0146
 
   WHILE TRUE
      IF s_shut(0) THEN EXIT WHILE END IF

#FUN-BC0062 --begin--
       IF g_ccz.ccz28 = '6' THEN
          CALL cl_err('','axc-026',1)
          EXIT WHILE
       END IF
#FUN-BC0062 --end--

      LET g_flag='Y'
      IF g_bgjob = 'N' THEN
         CALL p500_ask()
         IF cl_sure(20,20) THEN 
            LET start_date=TODAY
            LET t_time = TIME
            LET start_time=t_time
            CALL cl_wait() LET g_success = 'Y'
           #FUN-C80092---add---str---
            LET g_cka09 = "yy=",yy,";mm=",mm,";type='",type,"';choice='",choice,"';",
                          "choice1='",choice1,"';sw='",sw,"';g_bgjob='",g_bgjob,"'"
            CALL s_log_ins(g_prog,yy,mm,g_wc,g_cka09) RETURNING g_cka00
           #FUN-C80092---add---end---
            CALL p500_chk()     #No.FUN-AA0025
            CALL p500_del() 
            IF g_success='Y' THEN
               CALL p500() 
               ERROR ''
            END IF
            #no.4201可直接執行axcp333
            IF g_success='Y' THEN
               IF choice = 'Y' THEN   #FUN-640045 add
                  IF g_bgjob = 'N' THEN #NO.FUN-570153 
                      MESSAGE "execute axcp333...."
                      CALL ui.Interface.refresh()
                  END IF
                  LET l_cmd = 'axcp333 "',g_wc CLIPPED,'" ',yy,' ',mm
                  CALL cl_cmdrun_wait(l_cmd)
                  MESSAGE ""
               END IF   #FUN-640045 add
               IF g_sma.sma43 = '1' THEN
                  IF g_bgjob = 'N' THEN #NO.FUN-570153 
                      MESSAGE "execute gxcp200...."
                      CALL ui.Interface.refresh() 
                  END IF
                  LET l_cmd = 'gxcp200  ',yy,' ',mm
                  CALL cl_cmdrun_wait(l_cmd)  #FUN-660216 add
               END IF
            END IF
            IF g_success='Y' THEN
               CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
               CALL p500_out()
               CALL s_log_upd(g_cka00,'Y')          #FUN-C80092 add
            ELSE
               CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
               CALL s_log_upd(g_cka00,'N')          #FUN-C80092 add
            END IF
 
            IF g_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p500_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p500_w
      ELSE
         LET start_date = TODAY   #MOD-BB0074 add
         LET start_time = TIME    #MOD-BB0074 add
         LET g_success = 'Y' #No.MOD-7C0126 
        #FUN-C80092---add---str---
         LET g_cka09 = "yy=",yy,";mm=",mm,";type='",type,"';choice='",choice,"';",
                       "choice1='",choice1,"';sw='",sw,"';g_bgjob='",g_bgjob,"'"
         CALL s_log_ins(g_prog,yy,mm,g_wc,g_cka09) RETURNING g_cka00
        #FUN-C80092---add---end--- 
         CALL p500_del() 
         IF g_success='Y' THEN
            CALL p500() 
         END IF
         #no.4201可直接執行axcp333
         IF g_success='Y' THEN
            LET l_cmd = 'axcp333 "',g_wc CLIPPED,'" ',yy,' ',mm,' Y'
            CALL cl_cmdrun_wait(l_cmd)
            IF g_sma.sma43 = '1' THEN
               LET l_cmd = 'gxcp200  ',yy,' ',mm
               CALL cl_cmdrun_wait(l_cmd)  #FUN-660216 add
            END IF
         END IF
         IF g_success='Y' THEN 
            CALL p500_out() 
            CALL s_log_upd(g_cka00,'Y')          #FUN-C80092 add
         ELSE                                    #FUN-C80092 add
            CALL s_log_upd(g_cka00,'N')          #FUN-C80092 add
         END IF
         CALL cl_batch_bg_javamail(g_success)
        
         EXIT PROGRAM
      END IF
   END WHILE
 
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818 #No.FUN-6A0146
END MAIN
 
FUNCTION p500_ask()
   DEFINE c              LIKE cre_file.cre08            #No.FUN-680122CHAR(10)
   DEFINE p_row,p_col    LIKE type_file.num5        #FUN-570153        #No.FUN-680122 SMALLINT
   DEFINE lc_cmd         LIKE type_file.chr1000        #No.FUN-680122CHAR(500)     #FUN-570153
 
   LET p_row = 5 LET p_col = 20
 
   OPEN WINDOW p500_w AT p_row,p_col WITH FORM "axc/42f/axcp500"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
   LET yy     = g_ccz.ccz01 
   LET mm     = g_ccz.ccz02
   LET type   = g_ccz.ccz28   #FUN-7C0028 add
   LET choice = 'N'
   LET choice1= 'Y'  #MOD-540206   #No.FUN-890031 add
   LET sw     = 'Y'           #NO.FUN-5C0001 ADD
   DISPLAY BY NAME yy,mm,type,choice,choice1,sw  #NO.FUN-5C0001 ADD  #FUN-7C0028
WHILE TRUE
 
   CONSTRUCT BY NAME g_wc ON ima01,ima57,ima08,ima06,ima09,ima10,ima11,ima12
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ima01)
#FUN-AA0059---------mod------------str-----------------
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_ima"
#              LET g_qryparam.state = "c"
#              LET g_qryparam.default1 = g_ima01
#              CALL cl_create_qry() RETURNING g_qryparam.multiret
               CALL q_sel_ima(TRUE, "q_ima","",g_ima01,"","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end------------------
               DISPLAY g_qryparam.multiret TO ima01
               NEXT FIELD ima01
            OTHERWISE
               EXIT CASE
         END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()        # Command execution
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION locale
         LET g_change_lang = TRUE                  #FUN-570153
         EXIT CONSTRUCT
 
      ON ACTION exit                            #加離開功能
         LET INT_FLAG = 1
         EXIT CONSTRUCT
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
 
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
 
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p500_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
 
 
 # LET g_wc=g_wc CLIPPED," AND ima01 NOT LIKE 'MISC*'"       #FUN-AB0025 mark
   LET g_wc=g_wc CLIPPED," AND ima01 NOT LIKE 'MISC*' AND (ima120 = '1' OR ima120 = ' ' OR ima120 IS NULL) "   #FUN-AB0025
   LET g_bgjob = 'N'    #NO.FUN-570153 
 
   INPUT BY NAME yy,mm,type,choice,choice1,sw,g_bgjob WITHOUT DEFAULTS #NO.FUN-570153  #FUN-7C0028 add type
      AFTER FIELD yy
         IF cl_null(yy) THEN
            NEXT FIELD yy
         END IF
 
      AFTER FIELD mm
         IF NOT cl_null(mm) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = yy
            IF g_azm.azm02 = 1 THEN
               IF mm > 12 OR mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD mm
               END IF
            ELSE
               IF mm > 13 OR mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD mm
               END IF
            END IF
         END IF
         IF cl_null(mm) THEN
            NEXT FIELD mm
         END IF
  
      AFTER FIELD type     #成本計算類型
         IF type IS NULL OR type NOT MATCHES "[12345]" THEN
            NEXT FIELD type
         END IF
 
      AFTER FIELD choice   #執行成本要素更新作業(axcp330)
         IF choice NOT MATCHES '[YN]' THEN
            NEXT FIELD choice
         END IF
 
      AFTER FIELD choice1  #計算前是否先刪除舊統計資料
         IF choice1 NOT MATCHES '[YN]' THEN
            NEXT FIELD choice1
         END IF
 
      AFTER FIELD sw       #是否顯示執行過程
         IF sw NOT MATCHES '[YN]' THEN
            NEXT FIELD sw
         END IF
 
      ON CHANGE g_bgjob
         IF g_bgjob = "Y" THEN
            LET sw = "N"
            DISPLAY BY NAME sw
            CALL cl_set_comp_entry("sw",FALSE)
         ELSE
            CALL cl_set_comp_entry("sw",TRUE)
         END IF
 
      AFTER INPUT
         IF INT_FLAG THEN
            LET INT_FLAG = 0                    #FUN-570153
            CLOSE WINDOW p500_w                 #FUN-570153
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
            EXIT PROGRAM                        #FUN-570153
         END IF
         IF yy*12+mm < g_ccz.ccz01*12+g_ccz.ccz02 THEN
            CALL cl_err('','axc-196','1')
           #ERROR "計算年度期別不可小於現行年期!"
            NEXT FIELD yy
         END IF
         SELECT ccp03 INTO g_cost_v FROM ccp_file WHERE ccp01=yy AND ccp02=mm
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION exit                            #加離開功能
         LET INT_FLAG = 1
         EXIT INPUT
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
 
      ON ACTION locale                #FUN-570153
         LET g_change_lang = TRUE     #FUN-570153
         EXIT INPUT                   #FUN-570153
 
   END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p500_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
 
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01 = 'axcp500'
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
             CALL cl_err('axcp500','9031',1)   
         ELSE
            LET g_wc = cl_replace_str(g_wc,"'","\"")
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",g_wc CLIPPED,"'",
                         " '",yy CLIPPED,"'",
                         " '",mm CLIPPED,"'",
                         " '",type CLIPPED,"'",   #FUN-7C0028 add
                         " '",choice CLIPPED,"'",
                         " '",choice1 CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'"
           #CALL cl_cmdat('axcp500',g_time,lc_cmd CLIPPED) #MOD-C30891 mark
            CALL cl_cmdat('axcp500',t_time,lc_cmd CLIPPED) #MOD-C30891 
         END IF
         CLOSE WINDOW p500_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION p500()
   DEFINE l_sw       LIKE type_file.num10  #TQC-950184                                                                              
   DEFINE l_cnt1     LIKE type_file.num10  #TQC-950184                                                                              
   DEFINE l_sw_tot   LIKE type_file.num10  #TQC-950184                                                                              
   DEFINE l_count    LIKE type_file.num10  #TQC-950184
   DEFINE l_cac03    LIKE cac_file.cac03
   DEFINE l_cak03    LIKE cak_file.cak03
   DEFINE l_cae041   LIKE cae_file.cae041  #CHI-970021
   DEFINE l_cae03    LIKE cae_file.cae03
   DEFINE l_cae04    LIKE cae_file.cae04
   DEFINE l_cae05    LIKE cae_file.cae05
   DEFINE l_cae07    LIKE cae_file.cae07
   DEFINE l_cae08    LIKE cae_file.cae08
   DEFINE l_ima58    LIKE ima_file.ima58
   DEFINE l_ima912   LIKE ima_file.ima912
   DEFINE l_cxz01    LIKE cxz_file.cxz01
   DEFINE l_cxz02    LIKE cxz_file.cxz02
   DEFINE l_cxz03    LIKE cxz_file.cxz03
   DEFINE l_srk02    LIKE srk_file.srk02
   DEFINE srl05_sum  LIKE srl_file.srl05
   DEFINE l_index_dl LIKE cae_file.cae07        #No.FUN-680122DEC(15,5)
   DEFINE l_index_oh LIKE cae_file.cae07        #No.FUN-680122DEC(15,5)
   DEFINE dl_t       LIKE cae_file.cae07        #No.FUN-680122DEC(15,5)
   DEFINE oh_t       LIKE cae_file.cae07        #No.FUN-680122DEC(15,5)
   DEFINE l_qty      LIKE type_file.num10       #No.FUN-680122INT
   DEFINE l_sum      LIKE type_file.num20_6     #No.FUN-680122DEC(20,6)
   DEFINE lr_cxz     RECORD LIKE cxz_file.*     #CHI-970021
   DEFINE lr_cai     RECORD LIKE cai_file.*     #CHI-970021
   DEFINE l_cxz08    LIKE cxz_file.cxz08        #CHI-970021
   DEFINE srl09_sum  LIKE srl_file.srl05        #FUN-980031
   DEFINE l_bdate    LIKE type_file.dat         #CHI-9A0021 add
   DEFINE l_edate    LIKE type_file.dat         #CHI-9A0021 add
   DEFINE l_correct  LIKE type_file.chr1        #CHI-9A0021 add
 
   CALL p500_get_date() IF g_success = 'N' THEN RETURN END IF
   #-->取上期結存轉本月期初
   CALL p500_last0()
   #-->依選擇之成本計算方式,先更新該計算年月的所有tlfcost值
   CALL p500_tlfcost_upd()
 
  #當月起始日與截止日
   CALL s_azm(yy,mm) RETURNING l_correct,l_bdate,l_edate   #CHI-9A0021 add
   SELECT * INTO g_oaz.* FROM oaz_file     #No.MOD-CB0054
 
   ############Lifeng 優化############### 
   #下面這個句子從wip_32函數中提出來，整個程序中只用一次，而且和其他表沒有關系，
   #沒必要每次都在FOREACH中循環查詢
   DROP TABLE sfl_temp
   DROP INDEX sfl_temp_index
   SELECT sfl02,sfl03,SUM(sfl_file.sfl07) sfl07 FROM sfk_file,sfl_file
    WHERE sfk02 BETWEEN l_bdate AND l_edate       #CHI-9A002
      AND sfkpost='Y' 
      AND sfk01=sfl01 GROUP BY sfl02,sfl03 
     INTO TEMP sfl_temp 
   CREATE UNIQUE INDEX sfl_temp_index ON sfl_temp(sfl02,sfl03)
   #####################################  
 
   #FUN-CC0002(S) 当站报废
   IF g_ccz.ccz45='2' THEN    #当月转出
      DROP TABLE shb_temp
      DROP INDEX shb_temp_index
      CREATE TEMP TABLE shb_temp(
             shb05     LIKE shb_file.shb05,    #工单号
             shb081    LIKE shb_file.shb081,   #作业编号
             shb06     LIKE ecm_file.ecm03,    #工艺序
             shb112    LIKE shb_file.shb112)   #当站报废量
      CREATE UNIQUE INDEX shb_temp_index ON shb_temp(shb05,shb081,shb06)                        
      INSERT INTO shb_temp 
      SELECT shb05,shb081,shb06,SUM(shb112) shb112   
        FROM shb_file
       WHERE shb03 BETWEEN l_bdate AND l_edate       
         AND shbconf='Y'
         AND shb112>0 
       GROUP BY shb05,shb081,shb06 
   END IF
  #FUN-CC0002(E)
  #MOD-DA0096 add begin-------------
   DROP TABLE tlf_temp01
   CREATE TEMP TABLE tlf_temp01(
          tlf905 LIKE tlf_file.tlf905,
          tlf906 LIKE tlf_file.tlf906)
   CREATE UNIQUE INDEX tlf_temp01_index ON tlf_temp01(tlf905,tlf906)
  #MOD-DA0096 add end---------------
   
   DROP TABLE tlf_temp0
   LET g_sql = "SELECT ima57,ima01,ccd03,ima16,ima08,ima06,",
               " ima09,ima10,ima11,ima12,ima905,ima911,tlfcost ",      #tlf 
               ",ima120 ",                                                                     #MOD-B30206 add
               #TQC-A80010--Mark--Begin--#
#               "  FROM ima_file LEFT OUTER JOIN ccd_file ON ima57=ccd_file.ccd01, tlf_file ",
#               "  WHERE ",g_wc CLIPPED,
#               "   AND ima01 = tlf01",
               #TQC-A80010--Mark--End--#
               #TQC-A80010--Add--Begin--#
               "  FROM ima_file LEFT OUTER JOIN ccd_file ON ima57=ccd_file.ccd01 ",
               "                LEFT OUTER JOIN tlf_file ON ima01=tlf_file.tlf01 ",
               "  WHERE ",g_wc CLIPPED,
               #TQC-A80010--Add--End--#               
               "   AND tlf06 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
               #"   AND tlf902 NOT IN (SELECT jce02 FROM jce_file)", #JIT #CHI-C80002
               "   AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = tlf902)",  #CHI-C80002
               "   AND tlf907 != 0 ",
               " GROUP BY ima57,ima01,ccd03,ima905,ima911,ima16,ima08,ima06,ima09,ima10,ima11,ima12,tlfcost ",   #No:MOD-9A0151 modify
               ",ima120 ",                                                                     #MOD-B30206 add 
               " UNION  ",  #ccb_file
               "SELECT ima57,ima01,ccd03,ima16,ima08,ima06,",
               " ima09,ima10,ima11,ima12,ima905,ima911,ccb07 ",
               ",ima120 ",                                                                     #MOD-B30206 add
               "  FROM ima_file LEFT OUTER JOIN ccd_file ON ima57=ccd_file.ccd01, ccb_file ",
               "  WHERE ",g_wc CLIPPED,  
               " AND ccb02= ",yy," AND ccb03= ",mm,
               " AND ccb06='",type,"'",
               " AND ima01 = ccb01",
               " GROUP BY ima57,ima01,ccd03,ima905,ima911,ima16,ima08,ima06,ima09,ima10,ima11,ima12,ccb07 ",     #No:MOD-9A0151 modify 
               ",ima120 ",                                                                     #MOD-B30206 add
               " UNION  ",
               "SELECT ima57,ima01,ccd03,ima16,ima08,ima06,",
               " ima09,ima10,ima11,ima12,ima905,ima911,' ' ",      #tlf 
               ",ima120 ",                                                                     #MOD-B30206 add
               "  FROM ima_file LEFT OUTER JOIN ccd_file ON ima57=ccd_file.ccd01, ccj_file,sfb_file",
               "  WHERE ",g_wc CLIPPED,
                  " AND ima01 = sfb05",
                  " AND ccj01 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
                  " AND ccj04 = sfb01",
               " GROUP BY ima57,ima01,ccd03,ima905,ima911,ima16,ima08,ima06,ima09,ima10,ima11,ima12,' ' ",          #No:MOD-9A0151 modify 
               ",ima120 ",                                                                     #MOD-B30206 add
               " UNION  ",
               "SELECT ima57,ima01,ccd03,ima16,ima08,ima06,",
               " ima09,ima10,ima11,ima12,ima905,ima911,' ' ",  # 
               ",ima120 ",                                                                     #MOD-B30206 add
               "  FROM ima_file LEFT OUTER JOIN ccd_file ON ima57=ccd_file.ccd01, ccj_file,sfb_file,sfa_file ",
               "  WHERE ",g_wc CLIPPED,
                  " AND ima01 = sfa03",
                  " AND ccj01 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
                  " AND ccj04 = sfb01 ",
                  " AND sfb01 = sfa01",
                  " GROUP BY ima57,ima01,ccd03,ima905,ima911,ima16,ima08,ima06,ima09,ima10,ima11,ima12,' ' ",        #No:MOD-9A0151 modify
                  ",ima120 ",                                                                  #MOD-B30206 add
                  " UNION  ",
                  "SELECT ima57,ima01,ccd03,ima16,ima08,ima06,",
                  " ima09,ima10,ima11,ima12,ima905,ima911,ccg07 ",   #ccg
                  ",ima120 ",                                                                  #MOD-B30206 add
                  "  FROM ima_file LEFT OUTER JOIN ccd_file ON ima57=ccd_file.ccd01, ccg_file ",
                  " WHERE ",g_wc CLIPPED,
                  "   AND ima01 = ccg04 ",
                  "   AND ccg02= ",last_yy," AND ccg03= ",last_mm,
                  "   AND ccg06='",type,"'",
                  "   AND (ccg91  !=0  OR  ccg92  !=0 ",
                  "    OR  ccg92a !=0  OR  ccg92b !=0 ",
                  "    OR  ccg92c !=0  OR  ccg92d !=0 ",
                  "    OR  ccg92e !=0  OR  ccg92f !=0 ",
                  "    OR  ccg92g !=0  OR  ccg92h !=0) ",
                  " GROUP BY ima57,ima01,ccd03,ima905,ima911,ima16,ima08,ima06,ima09,ima10,ima11,ima12,ccg07 ",      #No:MOD-9A0151 modify
                  ",ima120 ",                                                                   #MOD-B30206 add
                  " UNION  ",
                  "SELECT ima57,ima01,ccd03,ima16,ima08,ima06,",
                  " ima09,ima10,ima11,ima12,ima905,ima911,cch07 ",   #ccg
                  ",ima120 ",                                                                   #MOD-B30206 add
                  "  FROM ima_file LEFT OUTER JOIN ccd_file ON ima57=ccd_file.ccd01, cch_file ",
                  " WHERE ",g_wc CLIPPED,
                  "   AND ima01 = cch04 ",
                  "   AND cch02= ",last_yy," AND cch03= ",last_mm,
                  "   AND cch06='",type,"'",
                  "   AND (cch91  !=0  OR  cch92  !=0 ",
                  "    OR  cch92a !=0  OR  cch92b !=0 ",
                  "    OR  cch92c !=0  OR  cch92d !=0 ",
                  "    OR  cch92e !=0  OR  cch92f !=0 ",
                  "    OR  cch92g !=0  OR  cch92h !=0) ",
                  " GROUP BY ima57,ima01,ccd03,ima905,ima911,ima16,ima08,ima06,ima09,ima10,ima11,ima12,cch07 ",      #No:MOD-9A0151 modify
                  ",ima120 ",                                                                   #MOD-B30206 add
                  #darcy:2023/11/09 add s---
                  # 没有期末金额只有数量的在制也要计算料号
                  " UNION  ",
                  "SELECT ima57,ima01,ccd03,ima16,ima08,ima06,",
                  " ima09,ima10,ima11,ima12,ima905,ima911,ccg07 ",   #ccg
                  ",ima120 ",                                                                   #MOD-B30206 add
                  "  FROM ima_file LEFT OUTER JOIN ccd_file ON ima57=ccd_file.ccd01, cch_file ,ccg_file",
                  " WHERE ",g_wc CLIPPED,
                  "   AND ima01 = ccg04 ",
                  "   AND ccg02=cch02 and ccg03=cch03 and ccg01 = cch01 ",
                  "   AND cch02= ",last_yy," AND cch03= ",last_mm,
                  "   AND cch06='",type,"'",
                  "   AND (cch91  !=0  OR  cch92  !=0 ",
                  "    OR  cch92a !=0  OR  cch92b !=0 ",
                  "    OR  cch92c !=0  OR  cch92d !=0 ",
                  "    OR  cch92e !=0  OR  cch92f !=0 ",
                  "    OR  cch92g !=0  OR  cch92h !=0) ",
                  " GROUP BY ima57,ima01,ccd03,ima905,ima911,ima16,ima08,ima06,ima09,ima10,ima11,ima12,ccg07 ",      #No:MOD-9A0151 modify
                  ",ima120 ", 
                  #darcy:2023/11/09 add e---
                  " UNION  ",
                  "SELECT ima57,ima01,ccd03,ima16,ima08,ima06,",
                  " ima09,ima10,ima11,ima12,ima905,ima911,cca07 ",   #ccg
                  ",ima120 ",                                                                   #MOD-B30206 add
                  "  FROM ima_file LEFT OUTER JOIN ccd_file ON ima57=ccd_file.ccd01,cca_file ",
                  " WHERE ",g_wc CLIPPED,
                  "   AND ima01 = cca01 ",
                  "   AND cca02= ",last_yy," AND cca03= ",last_mm,
                  "   AND cca06='",type,"'",
                  " GROUP BY ima57,ima01,ccd03,ima905,ima911,ima16,ima08,ima06,ima09,ima10,ima11,ima12,cca07 ",      #No:MOD-9A0151 modify
                  ",ima120 ",                                                                   #MOD-B30206 add
                  " UNION  ",
                  "SELECT ima57,ima01,ccd03,ima16,ima08,ima06,",
                  " ima09,ima10,ima11,ima12,ima905,ima911,ccf07 ",   #ccf Wip
                  ",ima120 ",                                                                   #MOD-B30206 add
                  "  FROM ima_file LEFT OUTER JOIN ccd_file ON ima57=ccd_file.ccd01,ccf_file,sfb_file ",
                  " WHERE ",g_wc CLIPPED,
                  "   AND ccf01 = sfb01 ",
                  "   AND ima01 = sfb05 ",
                  "   AND ccf02= ",last_yy," AND ccf03= ",last_mm,
                  "   AND ccf06='",type,"'",
                  "   AND (ccf11  !=0  OR  ccf12  !=0 ",
                  "    OR  ccf12a !=0  OR  ccf12b !=0 ",
                  "    OR  ccf12c !=0  OR  ccf12d !=0 ",
                  "    OR  ccf12e !=0  OR  ccf12f !=0 ",
                  "    OR  ccf12g !=0  OR  ccf12h !=0) ",
                  " GROUP BY ima57,ima01,ccd03,ima905,ima911,ima16,ima08,ima06,ima09,ima10,ima11,ima12,ccf07 ",      #No:MOD-9A0151 modify
                  ",ima120 ",                                                                   #MOD-B30206 add
                  " UNION  ",
                  "SELECT ima57,ima01,ccd03,ima16,ima08,ima06,",
                  " ima09,ima10,ima11,ima12,ima905,ima911,ccl07 ",   #ccl Wip 
                  ",ima120 ",                                                                   #MOD-B30206 add
                  "  FROM ima_file LEFT OUTER JOIN ccd_file ON ima57=ccd_file.ccd01,ccl_file,sfb_file ",
                  " WHERE ",g_wc CLIPPED,
                  "   AND ccl01 = sfb01 ",
                  "   AND ima01 = sfb05 ",
                  "   AND ccl02= ",yy," AND ccl03= ",mm,
                  "   AND ccl06='",type,"'",
                  " GROUP BY ima57,ima01,ccd03,ima905,ima911,ima16,ima08,ima06,ima09,ima10,ima11,ima12,ccl07 ",      #No:MOD-9A0151 modify
                  ",ima120 ",                                                                   #MOD-B30206 add 
                  " UNION  ",
                  "SELECT ima57,ima01,ccd03,ima16,ima08,ima06,",
                  " ima09,ima10,ima11,ima12,ima905,ima911,' ' ",
                  ",ima120 ",                                                                   #MOD-B30206 add
                  "  FROM ima_file LEFT OUTER JOIN ccd_file ON ima57=ccd_file.ccd01,srf_file,srg_file ",
                  " WHERE ",g_wc CLIPPED,
                  "   AND ima01 = srg03 ",
                  "   AND srf01 = srg01 ",
                  "   AND srfconf='Y'   ",
                  "   AND srf02 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
                  " GROUP BY ima57,ima01,ccd03,ima905,ima911,ima16,ima08,ima06,ima09,ima10,ima11,ima12,' ' ",         #No:MOD-9A0151 modify
                  ",ima120 ",                                                                   #MOD-B30206 add
                  " UNION  ",                                                                                                       
                  "SELECT ima57,ima01,ccd03,ima16,ima08,ima06,",                                                                    
                  " ima09,ima10,ima11,ima12,ima905,ima911,cct07 ",
                  ",ima120 ",                                                                   #MOD-B30206 add
                  "  FROM ima_file LEFT OUTER JOIN ccd_file ON ima57=ccd_file.ccd01,cct_file ",
                  " WHERE ",g_wc CLIPPED,
                  "   AND ima01 = cct04 ",
                  "   AND cct02 = '",last_yy,"' AND cct03= '",last_mm,"'",
                  "   AND cct06='",type,"'",
                  "   AND (cct91  !=0  OR  cct92  !=0 ",
                  "    OR  cct92a !=0  OR  cct92b !=0 ",
                  "    OR  cct92c !=0  OR  cct92d !=0 ",
                  "    OR  cct92e !=0  OR  cct92f !=0 ",
                  "    OR  cct92g !=0  OR  cct92h !=0) ",
                  " GROUP BY ima57,ima01,ccd03,ima905,ima911,ima16,ima08,ima06,ima09,ima10,ima11,ima12,cct07 ",     #No:MOD-9A0151 modify
                  ",ima120 ",                                                                   #MOD-B30206 add
                  " UNION  ",                                                                                                       
                  "SELECT ima57,ima01,ccd03,ima16,ima08,ima06,",
                  " ima09,ima10,ima11,ima12,ima905,ima911,ccu07 ",
                  ",ima120 ",                                                                   #MOD-B30206 add
                  "  FROM ima_file LEFT OUTER JOIN ccd_file ON ima57=ccd_file.ccd01,ccu_file ",                                                                             
                  " WHERE ",g_wc CLIPPED,
                  "   AND ima01 = ccu04 ",
                  "   AND ccu02 = '",last_yy,"' AND ccu03= '",last_mm,"'",
                  "   AND ccu06='",type,"'",
                  "   AND (ccu91  !=0  OR  ccu92  !=0 ",
                  "    OR  ccu92a !=0  OR  ccu92b !=0 ",
                  "    OR  ccu92c !=0  OR  ccu92d !=0 ",
                  "    OR  ccu92e !=0  OR  ccu92f !=0 ",
                  "    OR  ccu92g !=0  OR  ccu92h !=0) ",
                  " GROUP BY ima57,ima01,ccd03,ima905,ima911,ima16,ima08,ima06,ima09,ima10,ima11,ima12,ccu07 "    #No:MOD-9A0151 modify
                 ,",ima120 "                                                                     #MOD-B30206 add

                  #140225 add begin------------计算工单工艺委外                                                           
                  ,
                  " UNION  ",
                  "SELECT ima57,ima01,ccd03,ima16,ima08,ima06,",
                  " ima09,ima10,ima11,ima12,ima905,ima911,' ', ",
                  " ima120 ",  
                  " FROM ima_file LEFT OUTER JOIN ccd_file ON ima57=ccd_file.ccd01,rvu_file,rvv_file,sfb_file ",
                  " WHERE ",g_wc CLIPPED,
                  " AND ima01 = rvv31 AND rvv01 = rvu01 ", 
                  " AND rvu03 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
                  " AND rvv18 = sfb01 AND rvuconf = 'Y' AND sfb93 = 'Y' ",
                  " AND (NOT rvu00 IN ('2','3') AND rvu08 ='SUB')" ,
                  " GROUP BY ima57,ima01,ccd03,ima905,ima911,ima16,ima08,ima06,ima09,ima10,ima11,ima12,' ' ",         #No:MOD-9A0151 modify
                  ",ima120 "
                  #140225 add end--------------  
 
   CASE
      WHEN type = '1' OR type = '2' OR type = '3'
      LET g_sql = g_sql CLIPPED, " UNION ",
                 "SELECT ima57,ima01,ccd03,ima16,ima08,ima06,",
                 " ima09,ima10,ima11,ima12,ima905,ima911,tlfcost ",  #No.TQC-970003  #No.MOD-9A0151 modify
                 ",ima120 ",                                                                     #MOD-B30206 add
                 "  FROM tlf_file,sfb_file, ima_file LEFT OUTER JOIN ccd_file ",
                 "    ON ima57 = ccd_file.ccd01 ",
                 " WHERE ",g_wc CLIPPED,
                 "   AND (sfb38 >='",g_bdate,"'",  #no.5241
                 "    OR  sfb38 IS NULL ) ",
                 "   AND ima01 = sfb05 ",
                 "   AND tlf06 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
                 "   AND tlf62 = sfb01",
                #"   and substr(tlf13,1,5) = 'asfi5'",
                 "   and tlf13[1,5] = 'asfi5'",    #FUN-B40029
                 " GROUP BY ima57,ima01,ccd03,ima905,ima911,ima16,ima08,ima06,ima09,ima10,ima11,ima12,tlfcost "    #No.MOD-9A0151 modify
                 ,",ima120 "                                                                     #MOD-B30206 add
      WHEN type = '4'
      LET g_sql = g_sql CLIPPED, " UNION ",
                 "SELECT ima57,ima01,ccd03,ima16,ima08,ima06,",
                 " ima09,ima10,ima11,ima12,ima905,ima911,sfb27 ",  #No.TQC-970003  #No.MOD-9A0151 modify
                 ",ima120 ",                                                                     #MOD-B30206 add
                 "  FROM tlf_file,sfb_file, ima_file LEFT OUTER JOIN ccd_file ",
                 "    ON ima57 = ccd_file.ccd01 ",
                 " WHERE ",g_wc CLIPPED,
                 "   AND (sfb38 >='",g_bdate,"'",  #no.5241
                 "    OR  sfb38 IS NULL ) ",
                 "   AND ima01 = sfb05 ",
                 "   AND tlf06 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
                 "   AND tlf62 = sfb01",
                #"   and substr(tlf13,1,5) = 'asfi5'",
                 "   and tlf13[1,5] = 'asfi5'",    #FUN-B40029
                 " GROUP BY ima57,ima01,ccd03,ima905,ima911,ima16,ima08,ima06,ima09,ima10,ima11,ima12,sfb27 "   #No.MOD-9A0151 modify
                 ,",ima120 "                                                                     #MOD-B30206 add

      WHEN type = '5'
      LET g_sql = g_sql CLIPPED, " UNION ",
                 "SELECT ima57,ima01,ccd03,ima16,ima08,ima06,",
                 " ima09,ima10,ima11,ima12,ima905,ima911,imd09 ",  #No.TQC-970003      #No.MOD-9A0151 modify
                 ",ima120 ",                                                                     #MOD-B30206 add
                 "  FROM tlf_file,sfb_file,imd_file,ima_file LEFT OUTER JOIN ccd_file ",
                 "    ON ima57 = ccd_file.ccd01 ",
                 " WHERE ",g_wc CLIPPED,
                 "   AND (sfb38 >='",g_bdate,"'",  #no.5241
                 "    OR  sfb38 IS NULL ) ",
                 "   AND ima01 = sfb05 ",
                 "   AND tlf06 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
                 "   AND tlf62 = sfb01",
                 "   AND imd01 = sfb30 ",
                #"   and substr(tlf13,1,5) = 'asfi5'",
                 "   and tlf13[1,5] = 'asfi5'",    #FUN-B40029
                 " GROUP BY ima57,ima01,ccd03,ima905,ima911,ima16,ima08,ima06,ima09,ima10,ima11,ima12,imd09 "   #No.MOD-9A0151 modify
                 ,",ima120 "                                                                     #MOD-B30206 add
   END CASE
   LET g_sql = g_sql CLIPPED,
                  " INTO TEMP tlf_temp0 WITH NO LOG "
   PREPARE p500_trx_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('trx_prep:',STATUS,1)
      IF sw = 'N' THEN
         CALL cl_progressing(" ")
      END IF
      RETURN
   END IF
   EXECUTE p500_trx_prep
   DROP TABLE tlf_temp
   SELECT *
     FROM tlf_temp0 WHERE 1=1
    GROUP BY ima57,ima01,ccd03,ima16,ima08,ima06,ima09,ima10,ima11,ima12,ima905,ima911,tlfcost   #FUN-610080 加ima911   #FUN-7C0028 add tlfcost
     ,ima120                                                                                     #MOD-B30206 add
     INTO TEMP tlf_temp
 
   LET no_tot = sqlca.sqlerrd[3]
   IF g_bgjob= 'N' THEN  #NO.FUN-570153 
      DISPLAY BY NAME no_tot
   END IF
 
   # 依成本階數由下往上累算成本, 當月有入聯產品的主件要先算到
   LET g_sql = "SELECT UNIQUE ima57,ima01,ccd03,ima16,ima905 ",     #zzz
               "       ,ima911,tlfcost ",   #FUN-610080    #FUN-7C0028 add tlfcost
               "  FROM tlf_temp",
               " ORDER BY ima57 DESC,ima905 DESC,ima16,ima01,tlfcost "   #FUN-7C0028 add tlfcost
 
   SELECT COUNT(*) INTO l_sw_tot FROM tlf_temp
   IF sw = 'N' THEN
       LET l_count = 1
       IF l_sw_tot>0 THEN
           IF l_sw_tot > 10 THEN
              LET l_sw = l_sw_tot /10
              CALL cl_progress_bar(10)
           ELSE
              CALL cl_progress_bar(l_sw_tot)
           END IF
       END IF
    END IF
 
   #產生產品成本項目分攤資料(cxz_file)  (ima911='Y' )
   DELETE FROM cxz_file WHERE 1=1
   DELETE FROM cai_file WHERE cai02 = yy AND cai03 = mm   #CHI-970021
 
   LET g_sql1= "SELECT UNIQUE ima57,ima01,ccd03,ima16,ima911,tlfcost ",   #FUN-7C0028 add tlfcost
               "  FROM tlf_temp ",
               " WHERE ima911='Y' ",
               " ORDER BY ima01 "  # 依成本階數由下往上累算成本
   PREPARE p500_p0 FROM g_sql1
   DECLARE p500_c0 CURSOR WITH HOLD FOR p500_p0

   #CHI-C80002---begin
   LET g_sql1= " SELECT UNIQUE srk02 FROM srk_file,srl_file ",
               " WHERE srk01=srl01 AND srk02=srl02 AND srl04=? ",
               " AND srk01 BETWEEN '",l_bdate,"' AND '",l_edate,"'",
               " AND srkfirm <> 'X' "  #CHI-C80041
   PREPARE p500_srk_p1 FROM g_sql1
   DECLARE p500_srk_c1 CURSOR FOR p500_srk_p1

   LET g_sql1= " SELECT cak03 FROM cak_file ",
               " WHERE cak01=(SELECT ima131 FROM ima_file WHERE ima01=?) ",
               " AND cak02=? "
   PREPARE p500_cak_p1 FROM g_sql1   
   DECLARE p500_cak_c1 CURSOR FOR p500_cak_p1

   LET g_sql1= " SELECT cae03,cae04,cae05,cae07,cae041,cae08 FROM cae_file ",
               " WHERE cae01=? AND cae02=? AND cae03=?  AND cae04=? ",
               " ORDER BY cae041,cae08 "         
   PREPARE p500_cae_p1 FROM g_sql1
   DECLARE p500_cae_c1 CURSOR FOR p500_cae_p1        
   #CHI-C80002---end
   
   FOREACH p500_c0 INTO g_ima57,g_ima01,g_ccd03,g_ima16,g_ima911,g_tlfcost   #FUN-7C0028 add g_tlfcost
    IF g_tlfcost IS NULL THEN LET g_tlfcost = ' ' END IF     #No:MOD-B30528 add
    #CHI-C80002---begin mark
    #DECLARE p500_srk_c1 CURSOR  FOR   #抓料號成本中心
    #  SELECT UNIQUE srk02 FROM srk_file,srl_file
    #   WHERE srk01=srl01 AND srk02=srl02 AND srl04=g_ima01
    #     AND srk01 BETWEEN l_bdate AND l_edate     #CHI-9A0021
    #FOREACH p500_srk_c1 INTO l_srk02
    #CHI-C80002---end
    FOREACH p500_srk_c1 USING g_ima01 INTO l_srk02  #CHI-C80002
     #CHI-C80002---begin mark
     #DECLARE p500_cak_c1 CURSOR FOR
     # SELECT cak03 FROM cak_file
     #  WHERE cak01=(SELECT ima131 FROM ima_file WHERE ima01=g_ima01)
     #    AND cak02=l_srk02
     #FOREACH p500_cak_c1 INTO l_cak03 #抓成本項目
     #CHI-C80002---end
     FOREACH p500_cak_c1 USING g_ima01,l_srk02 INTO l_cak03  #CHI-C80002
           #抓 成本中心,項目 ,成本 ,單位成本,分類 ,分攤方式
        LET l_index_dl = 0  #CHI-970021
        LET l_index_oh = 0  #CHI-970021
      #CHI-C80002---begin mark
      #DECLARE p500_cae_c1 CURSOR FOR
      #     SELECT cae03,cae04,cae05,cae07,cae041,cae08 FROM cae_file         #CHI-970021
      #      WHERE cae01=yy AND cae02=mm AND cae03=l_srk02  AND cae04=l_cak03
      #      ORDER BY cae041,cae08   #CHI-970021
      #  FOREACH p500_cae_c1 INTO l_cae03,l_cae04,l_cae05,l_cae07,l_cae041,l_cae08 #CHI-970021
      #CHI-C80002---end
      FOREACH p500_cae_c1 USING yy,mm,l_srk02,l_cak03 INTO l_cae03,l_cae04,l_cae05,l_cae07,l_cae041,l_cae08  #CHI-C80002
       
       IF l_cae07 IS NULL THEN LET l_cae07 = 0 END IF
          LET dl_t = 0                        #CHI-970021
          LET oh_t = 0                        #CHI-970021
 
 
       CASE l_cae08 #分攤方式
        WHEN '1' #實際工時
          SELECT SUM(srl05) INTO srl05_sum FROM srl_file,srk_file  #FUN-980031
           WHERE srl02=l_cae03 AND srl04=g_ima01
                 AND srl01 BETWEEN l_bdate AND l_edate   #CHI-9A0021
                 AND srl01 = srk01    #FUN-980031
                 AND srl02 = srk02    #FUN-980031
                 AND srkfirm = 'Y'    #FUN-980031
          IF srl05_sum IS NULL THEN LET srl05_sum = 0 END IF   #TQC-620151
              CASE l_cae041  #CHI-970021
                 WHEN '1'# LET l_index_dl=srl05_sum #CHI-970021
                           LET dl_t=l_cae07*srl05_sum
                 OTHERWISE    #NO.CHI-940027
                           LET oh_t=l_cae07*srl05_sum
              END CASE
        WHEN '2' #標準工時
          SELECT SUM(srl06) INTO l_qty FROM srl_file,srk_file   #TQC-780064 mod #FUN-980031
           WHERE srl01 BETWEEN l_bdate AND l_edate         #CHI-9A0021
             AND srl02=l_cae03  AND srl04=g_ima01
             AND srl01 = srk01 AND srl02 = srk02 AND srkfirm = 'Y'   #FUN-980031
          IF l_qty IS NULL THEN LET l_qty = 0 END IF   #TQC-620151
          #統計總標準工時
          SELECT ima58 INTO l_ima58 FROM ima_file    #FUN-980031
           WHERE ima01=g_ima01
          IF l_ima58  IS NULL THEN LET l_ima58 = 0  END IF   #TQC-620151
	      CASE l_cae041  #CHI-970021
                WHEN '1' #LET l_index_dl=l_qty*l_ima58	     #CHI-970021
                          LET  dl_t=l_qty*l_ima58*l_cae07        #CHI-970021工
                OTHERWISE    #NO.CHI-940027
					  LET  oh_t=l_qty*l_ima58*l_cae07        #CHI-970021
                END CASE
            WHEN '3' #標準機時
                 SELECT SUM(srl06) INTO l_qty FROM srl_file,srk_file   #FUN-980031
                  #WHERE srl01 BETWEEN l_bdate01 AND l_edate01      #CHI-9A0021 #MOD-B90058 mark
                  WHERE srl01 BETWEEN l_bdate AND l_edate           #MOD-B90058 add
                    AND srl02=l_cae03  AND srl04=g_ima01
                    AND srl01 = srk01 AND srl02 = srk02 AND srkfirm = 'Y'   #FUN-980031
                 IF l_qty IS NULL THEN LET l_qty = 0 END IF
                 #統計總標準工時
                 SELECT ima912 INTO l_ima912 FROM ima_file
                  WHERE ima01=g_ima01
                 IF l_ima912 IS NULL THEN LET l_ima912 = 0 END IF
                 CASE l_cae041
                   WHEN '1'   LET  dl_t=l_qty*l_ima912*l_cae07
                   OTHERWISE  LET  oh_t=l_qty*l_ima912*l_cae07
                 END CASE
           WHEN '4'          #產出數量  #FUN-980031 3-->4
               SELECT SUM(srl06) INTO l_qty  FROM srl_file,srk_file      #FUN-980031
                WHERE srl02=l_cae03 AND srl04=g_ima01
                  AND srl01 BETWEEN l_bdate AND l_edate    #CHI-9A0021
                  AND srl01 = srk01 AND srl02 = srk02 AND srkfirm = 'Y'   #FUN-980031
               IF l_qty IS NULL THEN LET l_qty = 0 END IF   #TQC-620151
               SELECT cac03 INTO l_cac03 FROM cac_file
                WHERE cac01=l_cae03 AND cac02=l_cae04
               IF l_cac03 IS NULL THEN LET l_cac03 = 0  END IF   #TQC-620151
	        CASE l_cae041   #CHI-970021
                  WHEN '1' #LET l_index_dl=l_qty*l_cac03	   #CHI-970021
                            LET dl_t=l_qty*l_cac03*l_cae07   #CHI-970021
                  OTHERWISE    #NO.CHI-940027
	                LET oh_t=l_qty*l_cac03*l_cae07   #CHI-970021
                END CASE
            WHEN '5' #實際機時
              SELECT SUM(srl09) INTO srl09_sum FROM srl_file,srk_file
               WHERE srl02=l_cae03 AND srl04=g_ima01
                 #AND srl01 BETWEEN l_bdate01 AND l_edate01   #CHI-9A0021 #MOD-B90058 mark
                 AND srl01 BETWEEN l_bdate AND l_edate    #MOD-B90058 add
                 AND srl01 = srk01 AND srl02 = srk02 AND srkfirm = 'Y'
              IF srl09_sum IS NULL THEN LET srl09_sum = 0 END IF
               CASE l_cae041
                 WHEN '1'   LET dl_t=l_cae07*srl09_sum
                 OTHERWISE  LET oh_t=l_cae07*srl09_sum 
               END CASE
          END CASE
           LET l_index_dl = l_index_dl + dl_t
           LET l_index_oh = l_index_oh + oh_t        
           LET lr_cxz.cxz01 = g_ima01
           LET lr_cxz.cxz02 = l_cae03
           LET lr_cxz.cxz03 = l_cae04
           LET lr_cxz.cxz04 = dl_t
           LET lr_cxz.cxz05 = oh_t
           LET lr_cxz.cxz06 = l_index_dl
           LET lr_cxz.cxz07 = l_index_oh
           LET lr_cxz.cxz08 = l_cae041 
          #LET lr_cxz.cxzplant =  g_plant    #FUN-A50075
           LET lr_cxz.cxzlegal =  g_legal
           INSERT INTO cxz_file VALUES(lr_cxz.*)
      END FOREACH
      #更新人工/制費指標總數
      IF l_index_dl > 0 OR l_index_oh > 0 THEN
         UPDATE cxz_file SET cxz06 = l_index_dl ,
                             cxz07 = l_index_oh
                       WHERE cxz01 = g_ima01
                         AND cxz02 = l_cae03
                         AND cxz03 = l_cae04
      END IF
     END FOREACH
    END FOREACH
   END FOREACH
   #darcy:2024/10/09 add s---
   insert into cxz_darcy select * from cxz_file
   #darcy:2024/10/09 add e---
   #產生成本項目分析資料
   DECLARE p500_cxz_c1 CURSOR FOR
     SELECT cxz01,cxz02,cxz03,cxz08,SUM(cxz04+cxz05) FROM cxz_file #CHI-970021 add cxz08
      GROUP BY cxz01,cxz02,cxz03,cxz08   #CHI-970021 add czx08
      ORDER BY cxz01,cxz02,cxz03,cxz08   #CHI-970021 add
   FOREACH p500_cxz_c1 INTO l_cxz01,l_cxz02,l_cxz03,l_cxz08,l_sum  #CHI-970021 add l_cxz08
     IF l_sum IS NULL THEN LET l_sum = 0 END IF   #TQC-620151
     LET lr_cai.cai01 = l_cxz01
     LET lr_cai.cai02 = yy
     LET lr_cai.cai03 = mm
     LET lr_cai.cai04 = l_cxz01
     LET lr_cai.cai05 = l_cxz02
     LET lr_cai.cai06 = l_cxz03
     LET lr_cai.cai07 = l_sum
     LET lr_cai.cai08 = l_cxz08	
    #LET lr_cai.caiplant = 	g_plant    #FUN-A50075	
     LET lr_cai.cailegal = 	g_legal
     INSERT INTO cai_file VALUES(lr_cai.*)  
   END FOREACH
 
   PREPARE p500_p1 FROM g_sql
   DECLARE p500_c1 CURSOR WITH HOLD FOR p500_p1
   LET g_ima57_t=NULL
   LET no_ok=0
   LET g_tothour=0 LET g_totdl =0 LET g_totoh =0
   LET g_totoh1 =0 LET g_totoh2=0 LET g_totoh3=0 LET g_totoh4=0 LET g_totoh5=0   #FUN-7C0028 add
   FOREACH p500_c1 INTO g_ima57,g_ima01,g_ccd03,g_ima16,g_ima905,g_ima911,g_tlfcost   #FUN-610080   #FUN-7C0028 add g_tlfcost
      IF SQLCA.sqlcode THEN
         CALL cl_err('#?',STATUS,1)   
         LET g_success='N'
         IF sw = 'N' THEN
            CALL cl_progressing(" ")
         END IF
         RETURN
      END IF
      IF g_tlfcost IS NULL THEN LET g_tlfcost = ' ' END IF     #No:MOD-B30528 add
      BEGIN WORK            #No.MOD-7C0126   
      LET l_cnt1 = l_cnt1 + 1  #NO.FUN-5C0001 ADD
      #-->成本階不同, 對於 rework 部份, 進行第二次處理
      IF g_ima57 != g_ima57_t AND g_ima57_t IS NOT NULL THEN
         LET g_ima01_t  = g_ima01
         LET g_tlfcost_t= g_tlfcost   #MOD-840461 add
         CALL p500_reshare()        #計算前一階聯產品入庫分攤   #FUN-660086 add   #TQC-680154 modify
         CALL p500_rework()
         LET g_ima01  = g_ima01_t
         LET g_tlfcost= g_tlfcost_t   #MOD-840461 add
      END IF
      LET g_ima57_t = g_ima57
      LET g_misc = 'Y'
      LET no_ok=no_ok+1
      IF g_bgjob = 'N' THEN  #NO.FUN-570153 
         DISPLAY no_ok,g_ima57 TO no_ok,p1
      END IF
      INITIALIZE g_ccc.* TO NULL     #No:MOD-980105 add
      SELECT * INTO g_ccc.* FROM ccc_file
         WHERE ccc01 = g_ima01 AND ccc02 = yy AND ccc03 = mm
           AND ccc07 = type    AND ccc08 = g_tlfcost   #FUN-7C0028 add
      #-->將 g_ccc.* 歸 0
      CALL p500_ccc_0()
      CALL p500_last()
 
      #-->成本階為99 表示為Purchase part 不須處理 WIP 在製成本
      IF g_ima57 !='99' THEN
         IF g_ima911='N' THEN
            CALL p500_wip()     # 處理 WIP 在製成本 (工單性質=1/7)
         ELSE
            CALL p500_wip2()    # 處理產品WIP 在製成本
         END IF
      END IF
      #CHI-980045(S)
      #更新tlf28
      IF g_ccz.ccz31 MATCHES '[23]' THEN
         CALL p500_tlf28()         
      END IF
      #CHI-980045(E)
      CALL p500_tlf()           # 由 tlf_file 計算各類入出庫數量, 採購成本
      CALL p500_ccb_cost()      # 加上入庫調整金額
      IF g_ima57!='99' THEN
         IF g_ima911='N' THEN
            CALL p500_ccg_cost()     # 加上WIP入庫金額
         ELSE
            CALL p500_ccg3_cost()    # 加上WIP入庫金額
         END IF
      END IF
      CALL p500_ccc_tot('1')    # 計算所有出庫成本及結存
      CALL p500_ccc_ins()       # Insert ccc_file
      CALL p500_can_upd()       # 加上銷貨收入調整金額   #No:8741
      IF sw = 'N' THEN
          IF l_sw_tot > 10 THEN  #筆數合計
             IF l_count = 10 AND l_cnt1 = l_sw_tot THEN
                 CALL cl_progressing(" ")
             END IF
             IF (l_cnt1 mod l_sw) = 0 AND l_count < 10 THEN  #分割完的倍數時才呼
                  CALL cl_progressing(" ")
                  LET l_count = l_count + 1
             END IF
          ELSE
              CALL cl_progressing(" ")
          END IF
      END IF
      COMMIT WORK   #No.MOD-7C0126   
   END FOREACH
   IF g_ima01_t IS NULL THEN LET g_ima01_t = 0 END IF
   IF g_ima57_t IS NULL THEN LET g_ima57_t = 0 END IF
   CALL p500_reshare()     # 對於 聯產品入庫分攤 部份, 進行第二次處理   #FUN-660086 add   #TQC-680154 modify
   BEGIN WORK              #No.MOD-7C0126  
   CALL p500_rework()      # 對於 rework 部份, 進行第二次處理
   COMMIT WORK             #No.MOD-7C0126 
   CALL p500_reshare2()    # 對於 拆件式入庫分攤 部份, 進行處理         #FUN-670058 add
   CALL p500_cct2ccg()     # 將cct_file,ccu_file寫入ccg_file,cch_file   #FUN-680007 add
  #FUN-C80092---add---str---
   IF NOT p500_ckk_upd() THEN
      LET g_success = 'N'
      RETURN
   END IF
  #FUN-C80092---add---end---
   UPDATE ccz_file SET ccz01 = yy,ccz02 = mm WHERE ccz00 = '0'
   IF STATUS THEN
      CALL cl_err3("upd","ccz_file","","",STATUS,"","upd ccz:",1)   #No.FUN-660127
      LET g_success='N' RETURN
   END IF
   DROP TABLE sfl_temp 
   DROP INDEX sfl_temp_index
   DROP TABLE shb_temp         #FUN-CC0002
   DROP INDEX shb_temp_index   #FUN-CC0002
END FUNCTION
 
FUNCTION p500_rework()
   DEFINE l_ccd03       LIKE ccd_file.ccd03         #No.FUN-680122CHAR(1)
   SELECT ccd03 INTO l_ccd03 FROM ccd_file WHERE ccd01=g_ima57_t
   IF l_ccd03='Y' THEN
      CALL p500_rework1()  # 先算 WIP 及 完成品入庫
      CALL p500_rework2()  # 再算所有出庫成本及結存
      CALL p500_wipx0()    # 記錄WIP-拆件式工單 在製成本 (工單性質=11)
                           # 因為要取重工後單價
   END IF
END FUNCTION
 
FUNCTION p500_rework1()
   LET g_sql = "SELECT UNIQUE ima01,tlfcost FROM tlf_temp",   #MOD-840461
               "  WHERE ",g_wc CLIPPED," AND ima57=",g_ima57_t
              ," ORDER BY ima01,tlfcost"                      #MOD-840461 add
   PREPARE p500_rework_p1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('rework1 prep:',status,1)
   END IF
   DECLARE p500_rework_c1 CURSOR WITH HOLD FOR p500_rework_p1
   LET no_ok2=0
   FOREACH p500_rework_c1 INTO g_ima01,g_tlfcost   #MOD-840461 add g_tlfcost
      IF SQLCA.sqlcode THEN
         CALl cl_err('p500_rework',SQLCA.sqlcode,0)
         EXIT FOREACH
      END IF
      INITIALIZE g_ccc.* TO NULL     #No:MOD-980105 add
      SELECT * INTO g_ccc.* FROM ccc_file
             WHERE ccc01=g_ima01 AND ccc02=yy AND ccc03=mm
               AND ccc07=type    AND ccc08=g_tlfcost   #FUN-7C0028 add
      IF STATUS THEN CALL p500_ccc_0() END IF
      LET no_ok2=no_ok2+1
      IF g_bgjob = 'N' THEN  #NO.FUN-570153 
          DISPLAY no_ok2,g_ima57_t TO no_ok2,p3
      END IF
      CALL p500_wip_rework()    # 處理 WIP 重工成本 (重工sfb99='Y')
   END FOREACH
   CLOSE p500_rework_c1
END FUNCTION
 
FUNCTION p500_rework2()
   LET g_sql = "SELECT UNIQUE ima01,tlfcost FROM tlf_temp",   #MOD-840461
               "  WHERE ",g_wc CLIPPED," AND ima57 = ",g_ima57_t
              ," ORDER BY ima01,tlfcost"                      #MOD-840461 add
   PREPARE p500_rework2_p1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('rework2 prep:',status,1)
      IF sw = 'N' THEN
         CALL cl_progressing(" ")
      END IF
      RETURN
   END IF
   DECLARE p500_rework2_c1 CURSOR WITH HOLD FOR p500_rework2_p1
   LET no_ok2=0
   FOREACH p500_rework2_c1 INTO g_ima01,g_tlfcost   #MOD-840461 add g_tlfcost
      INITIALIZE g_ccc.* TO NULL     #No:MOD-980105 add
      SELECT * INTO g_ccc.* FROM ccc_file
             WHERE ccc01=g_ima01 AND ccc02=yy AND ccc03=mm
               AND ccc07=type    AND ccc08=g_tlfcost   #FUN-7C0028 add
      IF STATUS THEN CALL p500_ccc_0() END IF
      LET no_ok2=no_ok2+1
      IF g_bgjob = 'N' THEN  #NO.FUN-570153 
          DISPLAY no_ok2,g_ima57_t TO no_ok2,p3
      END IF 
      CALL p500_ccg2_cost()     # 加上WIP重工入庫金額
      CALL p500_ccc_tot('2')    # 計算所有出庫成本及結存
      CALL p500_ccc_upd()       # Update ccc_file
   END FOREACH
   CLOSE p500_rework2_c1
END FUNCTION
 
FUNCTION p500_reshare()
 
   IF g_sma.sma104 = 'N' AND type <> '3' THEN RETURN END IF   #使用聯產品否 #TQC-970003
 
   LET g_sql = "SELECT UNIQUE ima01,tlfcost FROM tlf_temp",   #MOD-840461
               " WHERE ",g_wc CLIPPED," AND ima57 = ",g_ima57_t
              ," ORDER BY ima01,tlfcost"                      #MOD-840461 add
   PREPARE p500_reshare_p1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('p500_reshare_p1:',status,1)
      IF sw = 'N' THEN
         CALL cl_progressing(" ")
      END IF
      RETURN
   END IF
   DECLARE p500_reshare_c1 CURSOR WITH HOLD FOR p500_reshare_p1
   LET no_ok2=0
   FOREACH p500_reshare_c1 INTO g_ima01,g_tlfcost   #MOD-840461 add g_tlfcost
      #重新抓取ima905
      SELECT ima905 INTO g_ima905 FROM ima_file WHERE ima01=g_ima01   #CHI-7B0022 add
      IF cl_null(g_ima905) THEN LET g_ima905 ='N' END IF              #CHI-7B0022 add
         IF g_ima905 ='N' AND type  <> '3' THEN                       #TQC-970003 add
            CONTINUE FOREACH
         END IF
      INITIALIZE g_ccc.* TO NULL     #No:MOD-980105 add
      SELECT * INTO g_ccc.* FROM ccc_file
       WHERE ccc01=g_ima01 AND ccc02=yy AND ccc03=mm
         AND ccc07=type    AND ccc08=g_tlfcost   #FUN-7C0028 add
      IF STATUS THEN CALL p500_ccc_0() END IF
      LET no_ok2=no_ok2+1
      IF g_bgjob = 'N' THEN  #NO.FUN-570153
         DISPLAY no_ok2,g_ima57_t TO no_ok2,p3
      END IF
      CALL p500_ccg4_cost()     # 計算聯產品入庫分攤
      CALL p500_ccc_tot('3')    # 計算所有出庫成本及結存
      CALL p500_ccc_upd()       # Update ccc_file
   END FOREACH
   CLOSE p500_reshare_c1
END FUNCTION
 
FUNCTION p500_reshare2()
 
   LET g_sql = "SELECT UNIQUE ima01,tlfcost FROM tlf_temp",   #MOD-840461
               " WHERE ",g_wc CLIPPED,
               #"   AND ima01 IN (SELECT ccu04 FROM ccu_file ",  #CHI-C80002
               #"                  WHERE ccu31 < 0           ",  #CHI-C80002
               "   AND EXISTS(SELECT 1 FROM ccu_file ",  #CHI-C80002
               "                  WHERE ccu04= ima01 AND ccu31 < 0 ",  #CHI-C80002
               "                    AND ccu02=",yy,
               "                    AND ccu03=",mm, 
               "                    AND ccu06='",type,"')"    #FUN-7C0028 add
              ," ORDER BY ima01,tlfcost"                      #MOD-840461 add
   PREPARE p500_reshare2_p1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('p500_reshare_p1:',status,1)
      IF sw = 'N' THEN
         CALL cl_progressing(" ")
      END IF
      RETURN
   END IF
   DECLARE p500_reshare2_c1 CURSOR WITH HOLD FOR p500_reshare2_p1
   LET no_ok2=0
   FOREACH p500_reshare2_c1 INTO g_ima01,g_tlfcost   #MOD-840461 add g_tlfcost
      INITIALIZE g_ccc.* TO NULL     #No:MOD-980105 add
      SELECT * INTO g_ccc.* FROM ccc_file
       WHERE ccc01=g_ima01 AND ccc02=yy AND ccc03=mm
         AND ccc07=type    AND ccc08=g_tlfcost   #FUN-7C0028 add
      IF STATUS THEN CALL p500_ccc_0() END IF
      LET no_ok2=no_ok2+1
      IF g_bgjob = 'N' THEN  #NO.FUN-570153
         DISPLAY no_ok2,g_ima57_t TO no_ok2,p3
      END IF
      CALL p500_ccg5_cost()     # 計算拆件式入庫分攤
      CALL p500_ccc_tot('4')    # 計算所有出庫成本及結存   #FUN-740253 modify 3->4
      CALL p500_ckp_ccc()       #FUN-670100 add CHECK ccc_file做NOT NULL欄位的判斷
      CALL p500_ccc_upd()       # Update ccc_file
   END FOREACH
   CLOSE p500_reshare_c1
END FUNCTION
 
FUNCTION p500_cct2ccg()
   DEFINE l_sql STRING
   DEFINE l_cct RECORD LIKE cct_file.*
   DEFINE l_ccu RECORD LIKE ccu_file.*
   DEFINE l_ccg RECORD LIKE ccg_file.*
   DEFINE l_cch RECORD LIKE cch_file.*
   DEFINE l_gfe03 LIKE gfe_file.gfe03   #FUN-680079 add
   DEFINE l_sfb38 LIKE sfb_file.sfb38   #No:MOD-9A0029 add
 
   LET l_sql="SELECT cct_file.* FROM cct_file,ima_file",
             " WHERE cct02=? AND cct03=?",
             "   AND cct06=? ", 
             "   AND cct04 =ima01",
             "   AND ",g_wc CLIPPED
   PREPARE cct_prep1 FROM l_sql
   IF STATUS THEN
      CALL cl_err('cct_prep1',status,1)
      RETURN
   END IF
   DECLARE cct_c1 CURSOR FOR cct_prep1
   IF STATUS THEN
      CALL cl_err('cct_c1',status,1)
      RETURN
   END IF
   LET l_sql="SELECT * FROM ccu_file",
             " WHERE ccu01=? ",
             "   AND ccu02=? AND ccu03=?"
            #,"   AND ccu06=? AND ccu07=?"   #FUN-7C0028 add  #MOD-C90098 mark
            ,"   AND ccu06=? "               #MOD-C90098
   PREPARE ccu_prep1 FROM l_sql
   IF STATUS THEN
      CALL cl_err('ccu_prep1',status,1)
      RETURN
   END IF
   DECLARE ccu_c1 CURSOR FOR ccu_prep1
   IF STATUS THEN
      CALL cl_err('ccu_c1',status,1)
      RETURN
   END IF
 
   FOREACH cct_c1 USING yy,mm,type INTO l_cct.*
      IF sw = 'Y' THEN
          IF g_bgjob = 'N' THEN #NO.FUN-570153 
              MESSAGE l_cct.cct01
              CALL ui.Interface.refresh()
          END IF
      END IF
      INITIALIZE l_ccg.* TO NULL     #No.MOD-8C0084 add
      LET l_ccg.ccg01  =l_cct.cct01
      LET l_ccg.ccg02  =yy
      LET l_ccg.ccg03  =mm
      LET l_ccg.ccg06  =l_cct.cct06   #FUN-7C0028 add
     #LET l_ccg.ccg07  =' '           #MOD-C60140 mark
      LET l_ccg.ccg07  =g_tlfcost     #MOD-C60140 add
      LET l_ccg.ccg04  =l_cct.cct04
      LET l_ccg.ccg11  =l_cct.cct11
      LET l_ccg.ccg12  =l_cct.cct12
      LET l_ccg.ccg12a =l_cct.cct12a
      LET l_ccg.ccg12b =l_cct.cct12b
      LET l_ccg.ccg12c =l_cct.cct12c
      LET l_ccg.ccg12d =l_cct.cct12d
      LET l_ccg.ccg12e =l_cct.cct12e
      LET l_ccg.ccg12f =l_cct.cct12f   #FUN-7C0028 add
      LET l_ccg.ccg12g =l_cct.cct12g   #FUN-7C0028 add
      LET l_ccg.ccg12h =l_cct.cct12h   #FUN-7C0028 add
      LET l_ccg.ccg20  =l_cct.cct20
     LET l_sfb38 = NULL   #No:MOD-9A0029 add
     SELECT sfb08,sfb38 INTO l_ccg.ccg21,l_sfb38 FROM sfb_file WHERE sfb01 = l_cct.cct01   #FUN-680079 #No:MOD-9A0029 modify
     #將拆件式的轉出金額改加到投入金額
      LET l_ccg.ccg22  =l_cct.cct22  + l_cct.cct32
      LET l_ccg.ccg22a =l_cct.cct22a + l_cct.cct32a
      LET l_ccg.ccg22b =l_cct.cct22b + l_cct.cct32b
      LET l_ccg.ccg22c =l_cct.cct22c + l_cct.cct32c
      LET l_ccg.ccg22d =l_cct.cct22d + l_cct.cct32d
      LET l_ccg.ccg22e =l_cct.cct22e + l_cct.cct32e
      LET l_ccg.ccg22f =l_cct.cct22f + l_cct.cct32f   #FUN-7C0028 add
      LET l_ccg.ccg22g =l_cct.cct22g + l_cct.cct32g   #FUN-7C0028 add
      LET l_ccg.ccg22h =l_cct.cct22h + l_cct.cct32h   #FUN-7C0028 add
      LET l_ccg.ccg23  =l_cct.cct23  
      LET l_ccg.ccg23a =l_cct.cct23a 
      LET l_ccg.ccg23b =l_cct.cct23b
      LET l_ccg.ccg23c =l_cct.cct23c 
      LET l_ccg.ccg23d =l_cct.cct23d 
      LET l_ccg.ccg23e =l_cct.cct23e
      LET l_ccg.ccg23f =l_cct.cct23f   #FUN-7C0028 add
      LET l_ccg.ccg23g =l_cct.cct23g   #FUN-7C0028 add
      LET l_ccg.ccg23h =l_cct.cct23h   #FUN-7C0028 add
         #按照比例算出轉出數量
         LET l_ccg.ccg31  = l_ccg.ccg21 * l_cct.cct32 / l_cct.cct22
         SELECT gfe03 INTO l_gfe03 FROM gfe_file
          WHERE gfe01=(SELECT ima25 FROM ima_file WHERE ima01=l_cct.cct04)
         IF cl_null(l_gfe03) THEN LET l_gfe03=0 END IF
         CALL cl_digcut(l_ccg.ccg31,g_ccz.ccz26) RETURNING l_ccg.ccg31
      #將拆件式的轉出數量改加到投入數量
      LET l_ccg.ccg21  = l_ccg.ccg21 + l_ccg.ccg31   #CHI-7B0022 add
      LET l_ccg.ccg31  = 0                           #CHI-7B0022 add
      #將拆件式的轉出金額改加到投入金額
      LET l_ccg.ccg32  =0   #l_cct.cct32    #CHI-7B0022 mod
      LET l_ccg.ccg32a =0   #l_cct.cct32a   #CHI-7B0022 mod
      LET l_ccg.ccg32b =0   #l_cct.cct32b   #CHI-7B0022 mod
      LET l_ccg.ccg32c =0   #l_cct.cct32c   #CHI-7B0022 mod
      LET l_ccg.ccg32d =0   #l_cct.cct32d   #CHI-7B0022 mod
      LET l_ccg.ccg32e =0   #l_cct.cct32e   #CHI-7B0022 mod
      LET l_ccg.ccg32f =0                   #FUN-7C0028 add
      LET l_ccg.ccg32g =0                   #FUN-7C0028 add
      LET l_ccg.ccg32h =0                   #FUN-7C0028 add
      LET l_ccg.ccg41  =l_cct.cct41
      IF l_sfb38 >= g_bdate AND l_sfb38 <= g_edate THEN       #工單成會結案 
         IF cl_null(l_ccg.ccg311) THEN LET l_ccg.ccg311=0 END IF   #FUN-CC0002
         LET l_ccg.ccg41 = (l_ccg.ccg11+l_ccg.ccg21+l_ccg.ccg31+l_ccg.ccg311) * -1    #FUN-CC0002 add ccg311
    #     LET l_ccg.ccg41 = (l_ccg.ccg11+l_ccg.ccg21+l_ccg.ccg31) * -1    #FUN-CC0002 mark 
      END IF
      LET l_ccg.ccg42  =l_cct.cct42 
      LET l_ccg.ccg42a =l_cct.cct42a 
      LET l_ccg.ccg42b =l_cct.cct42b
      LET l_ccg.ccg42c =l_cct.cct42c
      LET l_ccg.ccg42d =l_cct.cct42d 
      LET l_ccg.ccg42e =l_cct.cct42e
      LET l_ccg.ccg42f =l_cct.cct42f   #FUN-7C0028 add
      LET l_ccg.ccg42g =l_cct.cct42g   #FUN-7C0028 add
      LET l_ccg.ccg42h =l_cct.cct42h   #FUN-7C0028 add
      IF cl_null(l_ccg.ccg311) THEN LET l_ccg.ccg311=0 END IF                          #FUN-CC0002
      LET l_ccg.ccg91  =l_ccg.ccg11+l_ccg.ccg21+l_ccg.ccg31+l_ccg.ccg41+l_ccg.ccg311    #TQC-6C0017   #FUN-CC0002 add ccg311
   #   LET l_ccg.ccg91  =l_ccg.ccg11+l_ccg.ccg21+l_ccg.ccg31+l_ccg.ccg41    #TQC-6C0017   #FUN-CC0002 mark 
      LET l_ccg.ccg92  =l_cct.cct92 
      LET l_ccg.ccg92a =l_cct.cct92a 
      LET l_ccg.ccg92b =l_cct.cct92b
      LET l_ccg.ccg92c =l_cct.cct92c
      LET l_ccg.ccg92d =l_cct.cct92d 
      LET l_ccg.ccg92e =l_cct.cct92e
      LET l_ccg.ccg92f =l_cct.cct92f   #FUN-7C0028 add
      LET l_ccg.ccg92g =l_cct.cct92g   #FUN-7C0028 add
      LET l_ccg.ccg92h =l_cct.cct92h   #FUN-7C0028 add
      LET l_ccg.ccguser=l_cct.cctuser 
      LET l_ccg.ccgdate=l_cct.cctdate
      LET l_ccg.ccgtime=l_cct.ccttime
     #LET l_ccg.ccgplant=g_plant  #FUN-980009 add    #FUN-A50075
      LET l_ccg.ccglegal=g_legal  #FUN-980009 add
 
      LET l_sql = "DELETE FROM ccg_file",
                  " WHERE ccg01='",l_ccg.ccg01,"'",
                  "   AND ccg02=",yy,
                  "   AND ccg03=",mm,
                  "   AND ccg06='",type,"'",        #FUN-7C0028 add
                  #"   AND ccg04 IN(SELECT ima01 FROM ima_file",  #CHI-C80002
                  #"                 WHERE ",g_wc CLIPPED,")"  #CHI-C80002
                  "   AND EXISTS(SELECT 1 FROM ima_file",  #CHI-C80002
                  "               WHERE ima01 = ccg04 AND ",g_wc CLIPPED,")" #CHI-C80002
      PREPARE delccg_prep FROM l_sql
      IF SQLCA.sqlcode THEN
         CALL cl_err('delccgi_prep:',status,1)
         CALL cl_batch_bg_javamail('N')          #FUN-570153
         CALL s_log_upd(g_cka00,'N')          #FUN-C80092 add
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      EXECUTE delccg_prep
      LET l_ccg.ccgoriu = g_user      #No.FUN-980030 10/01/04
      LET l_ccg.ccgorig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO ccg_file VALUES(l_ccg.*)
      IF STATUS THEN
         CALL cl_err3("ins","ccg_file",l_ccg.ccg01,l_ccg.ccg02,STATUS,"","cct2ccg:",1)   #No.FUN-660127
         CALL cl_batch_bg_javamail('N')          #FUN-570153
         CALL s_log_upd(g_cka00,'N')          #FUN-C80092 add
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
 
      DELETE FROM cce_file
       WHERE cce01=l_ccg.ccg01 AND cce02=yy AND cce03=mm AND cce04=g_ima01  #No.MOD-580096
         AND cce06=type        AND cce07=g_tlfcost   #FUN-7C0028 add
 
      DELETE FROM cch_file
       WHERE cch01=l_ccg.ccg01 AND cch02=yy AND cch03=mm
         AND cch06=type        AND cch07=g_tlfcost   #FUN-7C0028 add
 
      #FOREACH ccu_c1 USING l_ccg.ccg01,yy,mm,type,g_tlfcost INTO l_ccu.*   #FUN-7C0028 add type,g_tlfcost #MOD-C90098 mark
       FOREACH ccu_c1 USING l_ccg.ccg01,yy,mm,type INTO l_ccu.*             #MOD-C90098 去掉g_tlfcost
         INITIALIZE l_cch.* TO NULL     #No.MOD-8C0084 add
         LET l_cch.cch01  =l_ccu.ccu01
         LET l_cch.cch02  =yy
         LET l_cch.cch03  =mm
         LET l_cch.cch06  =l_ccu.ccu06   #FUN-7C0028 add
         LET l_cch.cch07  =l_ccu.ccu07   #FUN-7C0028 add
         LET l_cch.cch04  =l_ccu.ccu04
         LET l_cch.cch05  =l_ccu.ccu05
         LET l_cch.cch11  =l_ccu.ccu11
         LET l_cch.cch12  =l_ccu.ccu12
         LET l_cch.cch12a =l_ccu.ccu12a
         LET l_cch.cch12b =l_ccu.ccu12b
         LET l_cch.cch12c =l_ccu.ccu12c
         LET l_cch.cch12d =l_ccu.ccu12d
         LET l_cch.cch12e =l_ccu.ccu12e
         LET l_cch.cch12f =l_ccu.ccu12f   #FUN-7C0028 add
         LET l_cch.cch12g =l_ccu.ccu12g   #FUN-7C0028 add
         LET l_cch.cch12h =l_ccu.ccu12h   #FUN-7C0028 add
         LET l_cch.cch21  =l_ccu.ccu21
        #將拆件式的轉出金額改加到投入金額
         LET l_cch.cch22  =l_ccu.ccu22  + l_ccu.ccu32
         LET l_cch.cch22a =l_ccu.ccu22a + l_ccu.ccu32a
         LET l_cch.cch22b =l_ccu.ccu22b + l_ccu.ccu32b
         LET l_cch.cch22c =l_ccu.ccu22c + l_ccu.ccu32c
         LET l_cch.cch22d =l_ccu.ccu22d + l_ccu.ccu32d
         LET l_cch.cch22e =l_ccu.ccu22e + l_ccu.ccu32e
         LET l_cch.cch22f =l_ccu.ccu22f + l_ccu.ccu32f   #FUN-7C0028 add
         LET l_cch.cch22g =l_ccu.ccu22g + l_ccu.ccu32g   #FUN-7C0028 add
         LET l_cch.cch22h =l_ccu.ccu22h + l_ccu.ccu32h   #FUN-7C0028 add
         #將拆件式的轉出數量改加到投入數量
         LET l_cch.cch21  =l_ccu.ccu21 + l_ccu.ccu31   #CHI-7B0022 add
         LET l_cch.cch31  =0   #l_ccu.ccu31            #CHI-7B0022 mod
         #將拆件式的轉出金額改加到投入金額
         LET l_cch.cch32  =0   #l_ccu.ccu32    #CHI-7B0022 mod
         LET l_cch.cch32a =0   #l_ccu.ccu32a   #CHI-7B0022 mod
         LET l_cch.cch32b =0   #l_ccu.ccu32b   #CHI-7B0022 mod
         LET l_cch.cch32c =0   #l_ccu.ccu32c   #CHI-7B0022 mod
         LET l_cch.cch32d =0   #l_ccu.ccu32d   #CHI-7B0022 mod
         LET l_cch.cch32e =0   #l_ccu.ccu32e   #CHI-7B0022 mod
         LET l_cch.cch32f =0                   #FUN-7C0028 add
         LET l_cch.cch32g =0                   #FUN-7C0028 add
         LET l_cch.cch32h =0                   #FUN-7C0028 add
         LET l_cch.cch311 =0
         LET l_cch.cch41  =l_ccu.ccu41
         LET l_cch.cch42  =l_ccu.ccu42
         LET l_cch.cch42a =l_ccu.ccu42a
         LET l_cch.cch42b =l_ccu.ccu42b
         LET l_cch.cch42c =l_ccu.ccu42c
         LET l_cch.cch42d =l_ccu.ccu42d
         LET l_cch.cch42e =l_ccu.ccu42e
         LET l_cch.cch42f =l_ccu.ccu42f   #FUN-7C0028 add
         LET l_cch.cch42g =l_ccu.ccu42g   #FUN-7C0028 add 
         LET l_cch.cch42h =l_ccu.ccu42h   #FUN-7C0028 add
         LET l_cch.cch53  =0
         LET l_cch.cch54  =0 
         LET l_cch.cch54a =0 
         LET l_cch.cch54b =0
         LET l_cch.cch54c =0 
         LET l_cch.cch54d =0 
         LET l_cch.cch54e =0
         LET l_cch.cch54f =0   #FUN-7C0028 add
         LET l_cch.cch54g =0   #FUN-7C0028 add
         LET l_cch.cch54h =0   #FUN-7C0028 add
         LET l_cch.cch55  =0
         LET l_cch.cch56  =0 
         LET l_cch.cch56a =0 
         LET l_cch.cch56b =0
         LET l_cch.cch56c =0 
         LET l_cch.cch56d =0 
         LET l_cch.cch56e =0
         LET l_cch.cch56f =0   #FUN-7C0028 add
         LET l_cch.cch56g =0   #FUN-7C0028 add
         LET l_cch.cch56h =0   #FUN-7C0028 add
         LET l_cch.cch57  =0
         LET l_cch.cch58  =0 
         LET l_cch.cch58a =0 
         LET l_cch.cch58b =0
         LET l_cch.cch58c =0 
         LET l_cch.cch58d =0 
         LET l_cch.cch58e =0
         LET l_cch.cch58f =0   #FUN-7C0028 add
         LET l_cch.cch58g =0   #FUN-7C0028 add
         LET l_cch.cch58h =0   #FUN-7C0028 add
         LET l_cch.cch59  =0
         LET l_cch.cch60  =0 
         LET l_cch.cch60a =0 
         LET l_cch.cch60b =0
         LET l_cch.cch60c =0 
         LET l_cch.cch60d =0 
         LET l_cch.cch60e =0
         LET l_cch.cch60f =0   #FUN-7C0028 add
         LET l_cch.cch60g =0   #FUN-7C0028 add
         LET l_cch.cch60h =0   #FUN-7C0028 add
         LET l_cch.cch91  =l_ccu.ccu91
         LET l_cch.cch92  =l_ccu.ccu92
         LET l_cch.cch92a =l_ccu.ccu92a
         LET l_cch.cch92b =l_ccu.ccu92b
         LET l_cch.cch92c =l_ccu.ccu92c
         LET l_cch.cch92d =l_ccu.ccu92d
         LET l_cch.cch92e =l_ccu.ccu92e
         LET l_cch.cch92f =l_ccu.ccu92f   #FUN-7C0028 add
         LET l_cch.cch92g =l_ccu.ccu92g   #FUN-7C0028 add
         LET l_cch.cch92h =l_ccu.ccu92h   #FUN-7C0028 add
         LET l_cch.cchuser=l_ccu.ccuuser
         LET l_cch.cchdate=l_ccu.ccudate
         LET l_cch.cchtime=l_ccu.ccutime
        #LET l_cch.cchplant = g_plant  #FUN-980009 add    #FUN-A50075
         LET l_cch.cchlegal = g_legal  #FUN-980009 add
         LET l_cch.cchoriu = g_user      #No.FUN-980030 10/01/04
         LET l_cch.cchorig = g_grup      #No.FUN-980030 10/01/04
         INSERT INTO cch_file VALUES (l_cch.*)
         IF SQLCA.SQLCODE AND (NOT cl_sql_dup_value(SQLCA.SQLCODE)) THEN
            CALL cl_err3("ins","cch_file",l_cch.cch01,l_cch.cch02,STATUS,"","ins_ccu2cch:",1)   #No.FUN-660127
         END IF
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
            UPDATE cch_file SET cch_file.*=l_cch.*
             WHERE cch01=l_ccg.ccg01 AND cch02=yy AND cch03=mm
               AND cch04=l_cch.cch04
               AND cch06=l_cch.cch06 AND cch07=l_cch.cch07   #FUN-7C0028 add
            IF STATUS THEN 
              CALL cl_err3("upd","cch_file",l_ccg.ccg01,yy,STATUS,"","upd_ccu2cch:",1)   #No.FUN-660127
            END IF
         END IF
      END FOREACH
      CLOSE ccu_c1
   END FOREACH
   CLOSE cct_c1
 
END FUNCTION
#end FUN-680007 add
 
FUNCTION p500_wipx0()
   LET g_sql = "SELECT UNIQUE ima01,tlfcost FROM tlf_temp",   #MOD-840461
               "  WHERE ",g_wc CLIPPED," AND ima57 = ",g_ima57_t
              ," ORDER BY ima01,tlfcost"                      #MOD-840461 add
   PREPARE p500_wipx0_p1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('wipx0 prep:',status,1)
      IF sw = 'N' THEN
         CALL cl_progressing(" ")
      END IF
      RETURN
   END IF
   DECLARE p500_wipx0_c1 CURSOR WITH HOLD FOR p500_wipx0_p1
   FOREACH p500_wipx0_c1 INTO g_ima01,g_tlfcost   #MOD-840461 add g_tlfcost
      INITIALIZE g_ccc.* TO NULL     #No:MOD-980105 add
      SELECT * INTO g_ccc.* FROM ccc_file
       WHERE ccc01=g_ima01 AND ccc02=yy AND ccc03=mm
         AND ccc07=type    AND ccc08=g_tlfcost   #FUN-7C0028 add
      IF STATUS THEN CALL p500_ccc_0() END IF
      CALL p500_wipx()
   END FOREACH
END FUNCTION
 
FUNCTION p500_get_date()
   DEFINE l_correct     LIKE type_file.chr1           #No.FUN-680122CHAR(1)
   CALL s_azm(yy,mm) RETURNING l_correct, g_bdate, g_edate #得出起始日與截止日
   IF l_correct != '0' THEN LET g_success = 'N' RETURN END IF
   IF mm = 1 THEN
      IF g_aza.aza02 = '1' THEN
         LET last_mm = 12 LET last_yy = yy - 1
      ELSE 
         LET last_mm = 13 LET last_yy = yy - 1
      END IF
   ELSE 
      LET last_mm = mm - 1 LET last_yy = yy
   END IF
END FUNCTION
 
FUNCTION p500_ccc_0()
   LET g_ccc.ccc01  = g_ima01
   LET g_ccc.ccc02  = yy
   LET g_ccc.ccc03  = mm
   LET g_ccc.ccc07  = type        #FUN-7C0028 add
   LET g_ccc.ccc08  = g_tlfcost   #FUN-7C0028 add
   LET g_ccc.ccc04  = g_ima57
   LET g_ccc.ccc11  = 0
   LET g_ccc.ccc12  = 0 LET g_ccc.ccc12a= 0
   LET g_ccc.ccc12b = 0 LET g_ccc.ccc12c= 0
   LET g_ccc.ccc12d = 0 LET g_ccc.ccc12e= 0
   LET g_ccc.ccc12f = 0 LET g_ccc.ccc12g= 0 LET g_ccc.ccc12h= 0  #FUN-7C0028 add
   LET g_ccc.ccc21  = 0
   LET g_ccc.ccc22  = 0 LET g_ccc.ccc22a= 0
   LET g_ccc.ccc22b = 0 LET g_ccc.ccc22c= 0
   LET g_ccc.ccc22d = 0 LET g_ccc.ccc22e= 0
   LET g_ccc.ccc22f = 0 LET g_ccc.ccc22g= 0 LET g_ccc.ccc22h= 0  #FUN-7C0028 add
   LET g_ccc.ccc25  = 0
   LET g_ccc.ccc26  = 0 LET g_ccc.ccc26a= 0
   LET g_ccc.ccc26b = 0 LET g_ccc.ccc26c= 0
   LET g_ccc.ccc26d = 0 LET g_ccc.ccc26e= 0
   LET g_ccc.ccc26f = 0 LET g_ccc.ccc26g= 0 LET g_ccc.ccc26h= 0  #FUN-7C0028 add
   LET g_ccc.ccc27  = 0
   LET g_ccc.ccc28  = 0 LET g_ccc.ccc28a= 0
   LET g_ccc.ccc28b = 0 LET g_ccc.ccc28c= 0
   LET g_ccc.ccc28d = 0 LET g_ccc.ccc28e= 0
   LET g_ccc.ccc28f = 0 LET g_ccc.ccc28g= 0 LET g_ccc.ccc28h= 0  #FUN-7C0028 add
   LET g_ccc.ccc23  = 0 LET g_ccc.ccc23a= 0
   LET g_ccc.ccc23b = 0 LET g_ccc.ccc23c= 0
   LET g_ccc.ccc23d = 0 LET g_ccc.ccc23e= 0
   LET g_ccc.ccc23f = 0 LET g_ccc.ccc23g= 0 LET g_ccc.ccc23h= 0  #FUN-7C0028 add
   LET g_ccc.ccc31  = 0 LET g_ccc.ccc32 = 0
   LET g_ccc.ccc41  = 0 LET g_ccc.ccc42 = 0
   LET g_ccc.ccc43  = 0 LET g_ccc.ccc44 = 0
   LET g_ccc.ccc51  = 0 LET g_ccc.ccc52 = 0
   LET g_ccc.ccc61  = 0 LET g_ccc.ccc63 = 0
   LET g_ccc.ccc62  = 0 LET g_ccc.ccc62a= 0
   LET g_ccc.ccc62b = 0 LET g_ccc.ccc62c= 0
   LET g_ccc.ccc62d = 0 LET g_ccc.ccc62e= 0
   LET g_ccc.ccc62f = 0 LET g_ccc.ccc62g= 0 LET g_ccc.ccc62h= 0  #FUN-7C0028 add
   LET g_ccc.ccc64  = 0 LET g_ccc.ccc65 = 0
   LET g_ccc.ccc66  = 0 LET g_ccc.ccc66a= 0
   LET g_ccc.ccc66b = 0 LET g_ccc.ccc66c= 0
   LET g_ccc.ccc66d = 0 LET g_ccc.ccc66e= 0
   LET g_ccc.ccc66f = 0 LET g_ccc.ccc66g= 0 LET g_ccc.ccc66h= 0  #FUN-7C0028 add
   LET g_ccc.ccc71  = 0 LET g_ccc.ccc72 = 0
   LET g_ccc.ccc81  = 0
   LET g_ccc.ccc82  = 0 LET g_ccc.ccc82a = 0
   LET g_ccc.ccc82b = 0 LET g_ccc.ccc82c = 0
   LET g_ccc.ccc82d = 0 LET g_ccc.ccc82e = 0
   LET g_ccc.ccc82f = 0 LET g_ccc.ccc82g= 0 LET g_ccc.ccc82h= 0  #FUN-7C0028 add
   LET g_ccc.ccc91  = 0
   LET g_ccc.ccc92  = 0 LET g_ccc.ccc92a= 0
   LET g_ccc.ccc92b = 0 LET g_ccc.ccc92c= 0
   LET g_ccc.ccc92d = 0 LET g_ccc.ccc92e= 0
   LET g_ccc.ccc92f = 0 LET g_ccc.ccc92g= 0 LET g_ccc.ccc92h= 0  #FUN-7C0028 add
   LET g_ccc.ccc93  = 0 LET g_ccc.ccc93a= 0
   LET g_ccc.ccc93b = 0 LET g_ccc.ccc93c= 0
   LET g_ccc.ccc93d = 0 LET g_ccc.ccc93e= 0
   LET g_ccc.ccc93f = 0 LET g_ccc.ccc93g= 0 LET g_ccc.ccc93h= 0  #FUN-7C0028 add
   LET g_ccc.cccuser=g_user
   LET g_ccc.cccdate=TODAY
   LET t_time = TIME
   LET g_ccc.ccctime=t_time
   LET g_ccc.ccc211 = 0 LET g_ccc.ccc212 = 0
   LET g_ccc.ccc213 = 0 LET g_ccc.ccc214 = 0
   LET g_ccc.ccc215 = 0
   LET g_ccc.ccc216 = 0 #CHI-980045
   LET g_ccc.ccc221 = 0 LET g_ccc.ccc22a1= 0
   LET g_ccc.ccc22b1= 0 LET g_ccc.ccc22c1= 0
   LET g_ccc.ccc22d1= 0 LET g_ccc.ccc22e1= 0
   LET g_ccc.ccc22f1= 0 LET g_ccc.ccc22g1= 0 LET g_ccc.ccc22h1= 0  #FUN-7C0028 add
   LET g_ccc.ccc222 = 0 LET g_ccc.ccc22a2= 0
   LET g_ccc.ccc22b2= 0 LET g_ccc.ccc22c2= 0
   LET g_ccc.ccc22d2= 0 LET g_ccc.ccc22e2= 0
   LET g_ccc.ccc22f2= 0 LET g_ccc.ccc22g2= 0 LET g_ccc.ccc22h2= 0  #FUN-7C0028 add
   LET g_ccc.ccc223 = 0 LET g_ccc.ccc22a3= 0
   LET g_ccc.ccc22b3= 0 LET g_ccc.ccc22c3= 0
   LET g_ccc.ccc22d3= 0 LET g_ccc.ccc22e3= 0
   LET g_ccc.ccc22f3= 0 LET g_ccc.ccc22g3= 0 LET g_ccc.ccc22h3= 0  #FUN-7C0028 add
   LET g_ccc.ccc224 = 0 LET g_ccc.ccc22a4= 0
   LET g_ccc.ccc22b4= 0 LET g_ccc.ccc22c4= 0
   LET g_ccc.ccc22d4= 0 LET g_ccc.ccc22e4= 0
   LET g_ccc.ccc22f4= 0 LET g_ccc.ccc22g4= 0 LET g_ccc.ccc22h4= 0  #FUN-7C0028 add
   LET g_ccc.ccc225 = 0 LET g_ccc.ccc22a5= 0
   LET g_ccc.ccc22b5= 0 LET g_ccc.ccc22c5= 0
   LET g_ccc.ccc22d5= 0 LET g_ccc.ccc22e5= 0
   LET g_ccc.ccc22f5= 0 LET g_ccc.ccc22g5= 0 LET g_ccc.ccc22h5= 0  #FUN-7C0028 add
   #CHI-980045(S)
   LET g_ccc.ccc226 = 0 LET g_ccc.ccc22a6= 0
   LET g_ccc.ccc22b6= 0 LET g_ccc.ccc22c6= 0
   LET g_ccc.ccc22d6= 0 LET g_ccc.ccc22e6= 0
   LET g_ccc.ccc22f6= 0 LET g_ccc.ccc22g6= 0 LET g_ccc.ccc22h6= 0
   #CHI-980045(E)
END FUNCTION
 
FUNCTION p500_last0()            # 取上期結存轉本月期初
   DEFINE l_cca      RECORD LIKE cca_file.*
   DEFINE l_sql      STRING       #No.FUN-680122CHAR(600)
   DEFINE l_ima01    LIKE ima_file.ima01
   DEFINE l_ccf      RECORD LIKE ccf_file.*
   DEFINE l_cxa      RECORD LIKE cxa_file.*      #No.A102
   DEFINE l_cxb      RECORD LIKE cxb_file.*      #No.A102
   DEFINE l_cxd      RECORD LIKE cxd_file.*      #No.A102
   DEFINE m_cxd      RECORD                      #No.A102
                     cxd08    LIKE cxd_file.cxd08,
                     cxd09    LIKE cxd_file.cxd09,
                     cxd091   LIKE cxd_file.cxd091,
                     cxd092   LIKE cxd_file.cxd092,
                     cxd093   LIKE cxd_file.cxd093,
                     cxd094   LIKE cxd_file.cxd094,
                     cxd095   LIKE cxd_file.cxd095,
                     cxd096   LIKE cxd_file.cxd096,   #FUN-7C0028 add
                     cxd097   LIKE cxd_file.cxd097,   #FUN-7C0028 add
                     cxd098   LIKE cxd_file.cxd098    #FUN-7C0028 add
                     END RECORD
   DEFINE l_flag     LIKE type_file.chr1                      #No.A102        #No.FUN-680122 VARCHAR(1)
   DEFINE l_cnt      LIKE type_file.num5                      #No.A102        #No.FUN-680122 SMALLINT
   DEFINE l_errmsg   LIKE type_file.chr1000        #No.FUN-680122CHAR(256)   #FUN-640153 add
   DEFINE l_ccc08    LIKE ccc_file.ccc08           #No.MOD-910214 add
   DEFINE l_count    LIKE type_file.num5           #MOD-970029
 
   IF g_sma.sma43 = '1' THEN
      #刪除異動檔本月異動資料
      LET l_sql = "DELETE FROM cxa_file",
                  " WHERE cxa02 = ",yy," AND cxa03 = ",mm,
                  "   AND cxa010='",type,"'",   #FUN-7C0028 add
                  #"   AND cxa01 IN(SELECT ima01 FROM ima_file",  #CHI-C80002
                  #" WHERE ",g_wc CLIPPED,")"  #CHI-C80002  
                  "   AND EXISTS(SELECT 1 FROM ima_file",  #CHI-C80002
                  "              WHERE ima01 = cxa01 AND ",g_wc CLIPPED,")"  #CHI-C80002
      PREPARE last0_del_cxa FROM l_sql
      IF SQLCA.sqlcode THEN
         CALL cl_err('last0 del_cxa:',STATUS,1) 
         CALL cl_batch_bg_javamail('N')          #FUN-570153
         CALL s_log_upd(g_cka00,'N')          #FUN-C80092 add
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      EXECUTE last0_del_cxa
 
      LET l_sql = "DELETE FROM cxc_file",
                  " WHERE cxc02 = ",yy," AND cxc03 = ",mm,
                  "   AND cxc010='",type,"'",   #FUN-7C0028 add
                  #"   AND cxc01 IN(SELECT ima01 FROM ima_file",  #CHI-C80002
                  #" WHERE ",g_wc CLIPPED,")"  #CHI-C80002
                  "   AND EXISTS(SELECT 1 FROM ima_file",  #CHI-C80002
                  " WHERE ima01 = cxc01 AND ",g_wc CLIPPED,")"  #CHI-C80002
      PREPARE last0_del_cxc FROM l_sql
      IF SQLCA.sqlcode THEN
         CALL cl_err('last0 del_cxc:',STATUS,1) 
         CALL cl_batch_bg_javamail('N')          #FUN-570153
         CALL s_log_upd(g_cka00,'N')          #FUN-C80092 add
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      EXECUTE last0_del_cxc
 
      #先進先出成本期初資料
      #將開帳資料轉到本月期初
      LET l_sql="SELECT cxd_file.* FROM cxd_file,ima_file",
                " WHERE cxd02 = ",last_yy," AND cxd03=",last_mm,
                "   AND cxd010='",type,"'",   #FUN-7C0028 add
                "   AND cxd01 = ima01 ",
                "   AND ",g_wc CLIPPED,
                " ORDER BY cxd01,cxd02,cxd03,cxd04 "
      PREPARE last0_cxd_pre FROM l_sql
      IF STATUS THEN
         CALL cl_err('last0 cxd_pre',STATUS,1) RETURN
      END IF
      DECLARE last0_cxd_curs CURSOR FOR last0_cxd_pre
 
      LET l_flag = 'N'
      LET l_cxa.cxa05 = TIME
      FOREACH last0_cxd_curs INTO l_cxd.*
         IF STATUS THEN
            CALL cl_err('last0 cxd_curs',STATUS,1) RETURN
         END IF
         LET l_cxa.cxa01 = l_cxd.cxd01
         LET l_cxa.cxa010= l_cxd.cxd010   #FUN-7C0028 add
         LET l_cxa.cxa011= l_cxd.cxd011   #FUN-7C0028 add
         LET l_cxa.cxa02 = yy
         LET l_cxa.cxa03 = mm
         LET l_cxa.cxa04 = l_cxd.cxd05
         CALL cl_autotime(l_cxa.cxa05,'M',1) RETURNING l_cxa.cxa05
         LET l_cxa.cxa06 = l_cxd.cxd06
         LET l_cxa.cxa07 = l_cxd.cxd07
         LET l_cxa.cxa08 = l_cxd.cxd08
         LET l_cxa.cxa09 = l_cxd.cxd09
         LET l_cxa.cxa091= l_cxd.cxd091
         LET l_cxa.cxa092= l_cxd.cxd092
         LET l_cxa.cxa093= l_cxd.cxd093
         LET l_cxa.cxa094= l_cxd.cxd094
         LET l_cxa.cxa095= l_cxd.cxd095
         LET l_cxa.cxa10 = 0
         LET l_cxa.cxa11 = 0
         LET l_cxa.cxa111= 0
         LET l_cxa.cxa112= 0
         LET l_cxa.cxa113= 0
         LET l_cxa.cxa114= 0
         LET l_cxa.cxa115= 0
         LET l_cxa.cxa15 = 'N'
         IF cl_null(l_cxa.cxa096) THEN LET l_cxa.cxa096 = 0 END IF
         IF cl_null(l_cxa.cxa097) THEN LET l_cxa.cxa097 = 0 END IF
         IF cl_null(l_cxa.cxa098) THEN LET l_cxa.cxa098 = 0 END IF
        #LET l_cxa.cxaplant=g_plant #FUN-980009 add    #FUN-A50075
         LET l_cxa.cxalegal=g_legal #FUN-980009 add
         INSERT INTO cxa_file VALUES (l_cxa.*)
         IF STATUS THEN
            CALL cl_err3("ins","cxa_file",l_cxa.cxa01,l_cxa.cxa02,STATUS,"","last0 ins cxa:",1)   #No.FUN-660127
            CALL cl_batch_bg_javamail('N')          #FUN-570153
            CALL s_log_upd(g_cka00,'N')          #FUN-C80092 add
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
            EXIT PROGRAM
         END IF
         LET l_flag = 'Y'
      END FOREACH
 
         #將月結檔上月期末轉到本月期初
         LET l_sql="SELECT cxb_file.* FROM cxb_file,ima_file",
                   " WHERE cxb02 = ",last_yy," AND cxb03=",last_mm,
                   "   AND cxb010='",type,"'",   #FUN-7C0028 add
                   "   AND cxb01 = ima01 ",
                   "   AND ",g_wc CLIPPED
         PREPARE last0_cxb_pre FROM l_sql
         IF STATUS THEN
            CALL cl_err('last0 cxb_pre',STATUS,1) RETURN
         END IF
         DECLARE last0_cxb_curs CURSOR FOR last0_cxb_pre
 
         FOREACH last0_cxb_curs INTO l_cxb.*
            IF STATUS THEN
               CALL cl_err('last0 cxb_curs',STATUS,1) RETURN
            END IF
            LET l_count = 0
            SELECT COUNT(*) INTO l_count FROM cxd_file
             WHERE cxd01 = l_cxb.cxb01
               AND cxd02 = l_cxb.cxb02
               AND cxd03 = l_cxb.cxb03
               AND cxd010 = l_cxb.cxb010
               AND cxd011 = l_cxb.cxb011
            IF l_count > 0 THEN
               CONTINUE FOREACH
            END IF
            LET l_cxa.cxa01 = l_cxb.cxb01
            LET l_cxa.cxa010= l_cxb.cxb010   #FUN-7C0028 add
            LET l_cxa.cxa011= l_cxb.cxb011   #FUN-7C0028 add
            LET l_cxa.cxa02 = yy
            LET l_cxa.cxa03 = mm
            LET l_cxa.cxa04 = l_cxb.cxb04
            LET l_cxa.cxa05 = l_cxb.cxb05
            LET l_cxa.cxa06 = l_cxb.cxb06
            LET l_cxa.cxa07 = l_cxb.cxb07
            LET l_cxa.cxa08 = l_cxb.cxb08
            LET l_cxa.cxa09 = l_cxb.cxb09
            LET l_cxa.cxa091= l_cxb.cxb091
            LET l_cxa.cxa092= l_cxb.cxb092
            LET l_cxa.cxa093= l_cxb.cxb093
            LET l_cxa.cxa094= l_cxb.cxb094
            LET l_cxa.cxa095= l_cxb.cxb095
            LET l_cxa.cxa10 = 0
            LET l_cxa.cxa11 = 0
            LET l_cxa.cxa111= 0
            LET l_cxa.cxa112= 0
            LET l_cxa.cxa113= 0
            LET l_cxa.cxa114= 0
            LET l_cxa.cxa115= 0
            LET l_cxa.cxa15 = 'N'
            IF cl_null(l_cxa.cxa096) THEN LET l_cxa.cxa096 = 0 END IF
            IF cl_null(l_cxa.cxa097) THEN LET l_cxa.cxa097 = 0 END IF
            IF cl_null(l_cxa.cxa098) THEN LET l_cxa.cxa098 = 0 END IF
           #LET l_cxa.cxaplant=g_plant #FUN-980009 add    #FUN-A50075
            LET l_cxa.cxalegal=g_legal #FUN-980009 add
            INSERT INTO cxa_file VALUES (l_cxa.*)
            IF STATUS THEN
               CALL cl_err3("ins","cxa_file",l_cxa.cxa01,l_cxa.cxa02,STATUS,"","last0 ins cxa#2:",1)   #No.FUN-660127
               CALL cl_batch_bg_javamail('N')          #FUN-570153
               CALL s_log_upd(g_cka00,'N')          #FUN-C80092 add
               CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
               EXIT PROGRAM
            END IF
         END FOREACH
   END IF
 
   LET l_sql = "DELETE FROM ccc_file",
               " WHERE ccc02=",yy," AND ccc03=",mm,
               " AND ccc07='",type,"'",   #FUN-7C0028 add
               #" AND ccc01 IN(SELECT ima01 FROM ima_file",  #CHI-C80002
               #"               WHERE ",g_wc CLIPPED,")"  #CHI-C80002
               " AND EXISTS(SELECT 1 FROM ima_file",  #CHI-C80002
               "            WHERE ima01 = ccc01 AND ",g_wc CLIPPED,")"  #CHI-C80002
   PREPARE last0_del_prep FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('last0 delp:',status,1)
      CALL cl_batch_bg_javamail('N')          #FUN-570153
      CALL s_log_upd(g_cka00,'N')          #FUN-C80092 add
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
 
   EXECUTE last0_del_prep
 
   LET l_sql = "SELECT ima01,ccc08 FROM ccc_file,ima_file",    #No.MOD-910214 add ccc08
               " WHERE ccc02=",last_yy," AND ccc03=",last_mm,
               " AND ccc07='",type,"'",   #FUN-7C0028 add
               " AND ccc01=ima01 ",
               " AND ",g_wc CLIPPED
   IF g_sma.sma43 = '1' THEN
      LET l_sql = l_sql CLIPPED,
                  " UNION ",
                  "SELECT ima01,cxd011 FROM cxd_file,ima_file",  #No.MOD-910214 add cxd011
                  " WHERE cxd02=",last_yy," AND cxd03=",last_mm,
                  " AND cxd010='",type,"'",   #FUN-7C0028 add
                  " AND cxd01=ima01 ",
                  " AND ",g_wc CLIPPED
   ELSE
      LET l_sql = l_sql CLIPPED,
                  " UNION ",
                  "SELECT ima01,cca07 FROM cca_file,ima_file",   #No.MOD-910214 add cca07
                  " WHERE cca02=",last_yy," AND cca03=",last_mm,
                  " AND cca06='",type,"'",   #FUN-7C0028 add
                  " AND cca01=ima01 ",
                  " AND ",g_wc CLIPPED
   END IF
   #end
 
   PREPARE last0_prep FROM l_sql
   IF STATUS THEN
      CALL cl_err('last0 prep:',status,1)
      CALL cl_batch_bg_javamail('N')          #FUN-570153
      CALL s_log_upd(g_cka00,'N')          #FUN-C80092 add
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   DECLARE last0_cs CURSOR FOR last0_prep
   #-->庫存成本期初
   FOREACH last0_cs INTO l_ima01,l_ccc08   #No.MOD-910214 add
      CALL p500_ccc_0()
      IF l_ccc08 IS NULL THEN LET l_ccc08 = ' ' END IF #No:MOD-B10173 add
      LET g_ccc.ccc08 = l_ccc08   #No:MOD-B10173 add
      SELECT * INTO g_ccc.* FROM ccc_file WHERE ccc01 = l_ima01
         AND ccc02=last_yy AND ccc03=last_mm
         AND ccc07=type    #FUN-7C0028 add
         AND ccc08=l_ccc08    #No.MOD-910214 add
      IF sw = 'Y' THEN
         IF g_bgjob = 'N' THEN #NO.FUN-570153 
            MESSAGE g_ccc.ccc01
            CALL ui.Interface.refresh()
         END IF
      END IF
      #-->取期初帳轉本月期初(讀不到沒影響)
      IF g_sma.sma43 = '1' THEN
         SELECT COUNT(*),SUM(cxd08),SUM(cxd09),SUM(cxd091),SUM(cxd092),
                         SUM(cxd093),SUM(cxd094),SUM(cxd095)
                        ,SUM(cxd096),SUM(cxd097),SUM(cxd098)   #FUN-7C0028 add
           INTO l_cnt,m_cxd.*
           FROM cxd_file
          WHERE cxd01 =l_ima01 AND cxd02=last_yy AND cxd03=last_mm
            AND cxd010=type    #FUN-7C0028 add
            AND cxd011=l_ccc08 #No.MOD-910214 add
         IF l_cnt = 0 THEN LET STATUS = 100 END IF
      ELSE
         SELECT * INTO l_cca.* FROM cca_file
          WHERE cca01=g_ccc.ccc01 AND cca02=last_yy AND cca03=last_mm
            AND cca06=type        #FUN-7C0028 add
            AND cca07=l_ccc08     #No.MOD-910214 add
      END IF
      IF STATUS=100 THEN #無帳數
         LET g_ccc.ccc11=g_ccc.ccc91
         LET g_ccc.ccc12=g_ccc.ccc92
         LET g_ccc.ccc12a=g_ccc.ccc92a
         LET g_ccc.ccc12b=g_ccc.ccc92b
         LET g_ccc.ccc12c=g_ccc.ccc92c
         LET g_ccc.ccc12d=g_ccc.ccc92d
         LET g_ccc.ccc12e=g_ccc.ccc92e
         LET g_ccc.ccc12f=g_ccc.ccc92f   #FUN-7C0028 add
         LET g_ccc.ccc12g=g_ccc.ccc92g   #FUN-7C0028 add
         LET g_ccc.ccc12h=g_ccc.ccc92h   #FUN-7C0028 add
      ELSE
         IF STATUS=0 THEN
            IF g_sma.sma43 = '1' THEN
               LET g_ccc.ccc01 =l_ima01
               LET g_ccc.ccc91 =m_cxd.cxd08
               LET g_ccc.ccc92 =m_cxd.cxd09
               LET g_ccc.ccc92a=m_cxd.cxd091
               LET g_ccc.ccc92b=m_cxd.cxd092
               LET g_ccc.ccc92c=m_cxd.cxd093
               LET g_ccc.ccc92d=m_cxd.cxd094
               LET g_ccc.ccc92e=m_cxd.cxd095
               LET g_ccc.ccc92f=m_cxd.cxd096   #FUN-7C0028 add
               LET g_ccc.ccc92g=m_cxd.cxd097   #FUN-7C0028 add
               LET g_ccc.ccc92h=m_cxd.cxd098   #FUN-7C0028 add
               LET g_ccc.ccc23 =m_cxd.cxd09 / m_cxd.cxd08
               LET g_ccc.ccc23a=m_cxd.cxd091/ m_cxd.cxd08
               LET g_ccc.ccc23b=m_cxd.cxd092/ m_cxd.cxd08
               LET g_ccc.ccc23c=m_cxd.cxd093/ m_cxd.cxd08
               LET g_ccc.ccc23d=m_cxd.cxd094/ m_cxd.cxd08
               LET g_ccc.ccc23e=m_cxd.cxd095/ m_cxd.cxd08
               LET g_ccc.ccc23f=m_cxd.cxd096/ m_cxd.cxd08   #FUN-7C0028 add
               LET g_ccc.ccc23g=m_cxd.cxd097/ m_cxd.cxd08   #FUN-7C0028 add
               LET g_ccc.ccc23h=m_cxd.cxd098/ m_cxd.cxd08   #FUN-7C0028 add
               LET g_ccc.ccc11 =g_ccc.ccc91
               LET g_ccc.ccc12 =g_ccc.ccc92
               LET g_ccc.ccc12a=g_ccc.ccc92a
               LET g_ccc.ccc12b=g_ccc.ccc92b
               LET g_ccc.ccc12c=g_ccc.ccc92c
               LET g_ccc.ccc12d=g_ccc.ccc92d
               LET g_ccc.ccc12e=g_ccc.ccc92e
               LET g_ccc.ccc12f=g_ccc.ccc92f   #FUN-7C0028 add
               LET g_ccc.ccc12g=g_ccc.ccc92g   #FUN-7C0028 add
               LET g_ccc.ccc12h=g_ccc.ccc92h   #FUN-7C0028 add
            ELSE
               LET g_ccc.ccc01 =l_ima01
               LET g_ccc.ccc91 =l_cca.cca11
               LET g_ccc.ccc92 =l_cca.cca12
               LET g_ccc.ccc92a=l_cca.cca12a
               LET g_ccc.ccc92b=l_cca.cca12b
               LET g_ccc.ccc92c=l_cca.cca12c
               LET g_ccc.ccc92d=l_cca.cca12d
               LET g_ccc.ccc92e=l_cca.cca12e
#No.MOD-D50220 --begin
#               LET g_ccc.ccc12f=l_cca.cca12f   #FUN-7C0028 add
#               LET g_ccc.ccc12g=l_cca.cca12g   #FUN-7C0028 add
#               LET g_ccc.ccc12h=l_cca.cca12h   #FUN-7C0028 add
               LET g_ccc.ccc92f=l_cca.cca12f   #FUN-7C0028 add
               LET g_ccc.ccc92g=l_cca.cca12g   #FUN-7C0028 add
               LET g_ccc.ccc92h=l_cca.cca12h   #FUN-7C0028 add
#No.MOD-D50220 --end
               LET g_ccc.ccc23 =l_cca.cca23
               LET g_ccc.ccc23a=l_cca.cca23a
               LET g_ccc.ccc23b=l_cca.cca23b
               LET g_ccc.ccc23c=l_cca.cca23c
               LET g_ccc.ccc23d=l_cca.cca23d
               LET g_ccc.ccc23e=l_cca.cca23e
               LET g_ccc.ccc23f=l_cca.cca23f   #FUN-7C0028 add
               LET g_ccc.ccc23g=l_cca.cca23g   #FUN-7C0028 add
               LET g_ccc.ccc23h=l_cca.cca23h   #FUN-7C0028 add
               LET g_ccc.ccc11 =g_ccc.ccc91
               LET g_ccc.ccc12 =g_ccc.ccc92
               LET g_ccc.ccc12a=g_ccc.ccc92a
               LET g_ccc.ccc12b=g_ccc.ccc92b
               LET g_ccc.ccc12c=g_ccc.ccc92c
               LET g_ccc.ccc12d=g_ccc.ccc92d
               LET g_ccc.ccc12e=g_ccc.ccc92e
               LET g_ccc.ccc12f=g_ccc.ccc92f   #FUN-7C0028 add
               LET g_ccc.ccc12g=g_ccc.ccc92g   #FUN-7C0028 add
               LET g_ccc.ccc12h=g_ccc.ccc92h   #FUN-7C0028 add
            END IF
            #end No.A102
         ELSE
            CALL cl_err('last0:',sqlca.sqlcode,1)
         END IF
      END IF
      LET g_ccc.ccc02 = yy
      LET g_ccc.ccc03 = mm
      SELECT ima57 INTO g_ccc.ccc04 FROM ima_file WHERE ima01=g_ccc.ccc01
      LET g_ccc.ccc21 = 0
      LET g_ccc.ccc22 = 0 LET g_ccc.ccc22a= 0
      LET g_ccc.ccc22b= 0 LET g_ccc.ccc22c= 0
      LET g_ccc.ccc22d= 0 LET g_ccc.ccc22e= 0
      LET g_ccc.ccc22f= 0 LET g_ccc.ccc22g= 0 LET g_ccc.ccc22h= 0   #FUN-7C0028 add
      LET g_ccc.ccc25 = 0
      LET g_ccc.ccc26 = 0 LET g_ccc.ccc26a= 0
      LET g_ccc.ccc26b= 0 LET g_ccc.ccc26c= 0
      LET g_ccc.ccc26d= 0 LET g_ccc.ccc26e= 0
      LET g_ccc.ccc26f= 0 LET g_ccc.ccc26g= 0 LET g_ccc.ccc26h= 0   #FUN-7C0028 add
      LET g_ccc.ccc27 = 0
      LET g_ccc.ccc28 = 0 LET g_ccc.ccc28a= 0
      LET g_ccc.ccc28b= 0 LET g_ccc.ccc28c= 0
      LET g_ccc.ccc28d= 0 LET g_ccc.ccc28e= 0
      LET g_ccc.ccc28f= 0 LET g_ccc.ccc28g= 0 LET g_ccc.ccc28h= 0   #FUN-7C0028 add
      LET g_ccc.ccc31 = 0 LET g_ccc.ccc32 = 0
      LET g_ccc.ccc41 = 0 LET g_ccc.ccc42 = 0
      LET g_ccc.ccc43 = 0 LET g_ccc.ccc44 = 0
      LET g_ccc.ccc51 = 0 LET g_ccc.ccc52 = 0
      LET g_ccc.ccc61 = 0 LET g_ccc.ccc63 = 0
      LET g_ccc.ccc62 = 0 LET g_ccc.ccc62a= 0
      LET g_ccc.ccc62b= 0 LET g_ccc.ccc62c= 0
      LET g_ccc.ccc62d= 0 LET g_ccc.ccc62e= 0
      LET g_ccc.ccc62f= 0 LET g_ccc.ccc62g= 0 LET g_ccc.ccc62h= 0   #FUN-7C0028 add
      LET g_ccc.ccc64 = 0 LET g_ccc.ccc65 = 0
      LET g_ccc.ccc66 = 0 LET g_ccc.ccc66a= 0
      LET g_ccc.ccc66b= 0 LET g_ccc.ccc66c= 0
      LET g_ccc.ccc66d= 0 LET g_ccc.ccc66e= 0
      LET g_ccc.ccc66f= 0 LET g_ccc.ccc66g= 0 LET g_ccc.ccc66h= 0   #FUN-7C0028 add
      LET g_ccc.ccc71 = 0 LET g_ccc.ccc72 = 0
      LET g_ccc.ccc81 = 0
      LET g_ccc.ccc82 = 0 LET g_ccc.ccc82a= 0
      LET g_ccc.ccc82b= 0 LET g_ccc.ccc82c= 0
      LET g_ccc.ccc82d= 0 LET g_ccc.ccc82e= 0
      LET g_ccc.ccc82f= 0 LET g_ccc.ccc82g= 0 LET g_ccc.ccc82h= 0   #FUN-7C0028 add
      LET g_ccc.ccc93 = 0 LET g_ccc.ccc93a= 0
      LET g_ccc.ccc93b= 0 LET g_ccc.ccc93c= 0
      LET g_ccc.ccc93d= 0 LET g_ccc.ccc93e= 0
      LET g_ccc.ccc93f= 0 LET g_ccc.ccc93g= 0 LET g_ccc.ccc93h= 0   #FUN-7C0028 add
      LET g_ccc.cccuser=g_user
      LET g_ccc.cccdate=TODAY
      LET g_ccc.ccctime=TIME
      LET g_ccc.ccc01 = l_ima01
      LET g_ccc.ccc211 = 0 LET g_ccc.ccc212 = 0
      LET g_ccc.ccc213 = 0 LET g_ccc.ccc214 = 0
      LET g_ccc.ccc215 = 0
      LET g_ccc.ccc216 = 0 #CHI-980045
      LET g_ccc.ccc221 = 0 LET g_ccc.ccc22a1= 0
      LET g_ccc.ccc22b1= 0 LET g_ccc.ccc22c1= 0
      LET g_ccc.ccc22d1= 0 LET g_ccc.ccc22e1= 0
      LET g_ccc.ccc22f1= 0 LET g_ccc.ccc22g1= 0 LET g_ccc.ccc22h1= 0   #FUN-7C0028 add
      LET g_ccc.ccc222 = 0 LET g_ccc.ccc22a2= 0
      LET g_ccc.ccc22b2= 0 LET g_ccc.ccc22c2= 0
      LET g_ccc.ccc22d2= 0 LET g_ccc.ccc22e2= 0
      LET g_ccc.ccc22f2= 0 LET g_ccc.ccc22g2= 0 LET g_ccc.ccc22h2= 0   #FUN-7C0028 add
      LET g_ccc.ccc223 = 0 LET g_ccc.ccc22a3= 0
      LET g_ccc.ccc22b3= 0 LET g_ccc.ccc22c3= 0
      LET g_ccc.ccc22d3= 0 LET g_ccc.ccc22e3= 0
      LET g_ccc.ccc22f3= 0 LET g_ccc.ccc22g3= 0 LET g_ccc.ccc22h3= 0   #FUN-7C0028 add
      LET g_ccc.ccc224 = 0 LET g_ccc.ccc22a4= 0
      LET g_ccc.ccc22b4= 0 LET g_ccc.ccc22c4= 0
      LET g_ccc.ccc22d4= 0 LET g_ccc.ccc22e4= 0
      LET g_ccc.ccc22f4= 0 LET g_ccc.ccc22g4= 0 LET g_ccc.ccc22h4= 0   #FUN-7C0028 add
      LET g_ccc.ccc225 = 0 LET g_ccc.ccc22a5= 0
      LET g_ccc.ccc22b5= 0 LET g_ccc.ccc22c5= 0
      LET g_ccc.ccc22d5= 0 LET g_ccc.ccc22e5= 0
      LET g_ccc.ccc22f5= 0 LET g_ccc.ccc22g5= 0 LET g_ccc.ccc22h5= 0   #FUN-7C0028 add
      #CHI-980045(S)
      LET g_ccc.ccc226 = 0 LET g_ccc.ccc22a6= 0
      LET g_ccc.ccc22b6= 0 LET g_ccc.ccc22c6= 0
      LET g_ccc.ccc22d6= 0 LET g_ccc.ccc22e6= 0
      LET g_ccc.ccc22f6= 0 LET g_ccc.ccc22g6= 0 LET g_ccc.ccc22h6= 0
      #CHI-980045(E)
      CALL p500_ckp_ccc() #MOD-4A0263 CHECK ccc_file做NOT NULL欄位的判斷
      LET g_ccc.cccoriu = g_user      #No.FUN-980030 10/01/04
      LET g_ccc.cccorig = g_grup      #No.FUN-980030 10/01/04
      LET g_ccc.ccclegal = g_legal    #FUN-A50075
      INSERT INTO ccc_file VALUES (g_ccc.*)
      IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
         UPDATE ccc_file SET ccc_file.*=g_ccc.*             #TQC-970279       
            WHERE ccc01=g_ccc.ccc01 AND ccc02=g_ccc.ccc02
              AND ccc03=g_ccc.ccc03
              AND ccc07=g_ccc.ccc07 AND ccc08=g_ccc.ccc08   #FUN-7C0028 add
         IF STATUS THEN
            LET l_errmsg = ''
            LET l_errmsg = l_ima01,'last0 upd:'
            CALL cl_err3("upd","ccc_file",g_ccc.ccc01,g_ccc.ccc02,sqlca.sqlcode,"","",1)   #No.FUN-660127
         END IF
      ELSE
         IF SQLCA.sqlcode != 0 THEN
            LET l_errmsg = ''
            LET l_errmsg = l_ima01,'last0 ins:'
             CALL cl_err3("ins","ccc_file",g_ccc.ccc01,g_ccc.ccc02,sqlca.sqlcode,"","",1)   #No.FUN-660127
         END IF
      END IF
   END FOREACH
 
   #-->在製成本(上階)期初
   LET l_sql="SELECT ccg_file.* FROM ccg_file,ima_file",
             " WHERE ccg02=? AND ccg03=?",
             " AND ccg06=?",   #FUN-7C0028 add
             " AND ccg07=?",   #MOD-C60140 add
             " AND (ccg91<>0 OR ccg92a<>0 OR ccg92b<>0 OR ccg92c<>0 OR",
             "     ccg92d<>0 OR ccg92e<>0 OR ccg92f<>0 OR ccg92g<>0 OR ccg92h<>0) ",   #FUN-7C0028 add ccg92f,g,h
             " AND ccg04 =ima01",
             " AND ",g_wc CLIPPED
   PREPARE last0_prep1 FROM l_sql
   IF STATUS THEN
      CALL cl_err('last0 prep c1',status,1)
      RETURN
   END IF
   DECLARE last0_c1 CURSOR FOR last0_prep1
   IF STATUS THEN
      CALL cl_err('last0 dcl c1',status,1)
      RETURN
   END IF
   #-->在製成本(下階)期初
   LET l_sql="SELECT * FROM cch_file",
             " WHERE cch01=? ",
             "   AND cch02=",last_yy," AND cch03=",last_mm clipped
            ,"   AND cch06='",type,"'"    #FUN-7C0028 add
   PREPARE last0_prep2 FROM l_sql
   IF STATUS THEN
      CALL cl_err('last0 prep2',status,1)
      RETURN
   END IF
   DECLARE last0_c2 CURSOR FOR last0_prep2
   IF STATUS THEN
      CALL cl_err('last0 dcl c2',status,1)
      RETURN
   END IF
 
  #FOREACH last0_c1 USING last_yy,last_mm,type INTO mccg.*     #FUN-7C0028 add type   #MOD-C60140 mark
   FOREACH last0_c1 USING last_yy,last_mm,type,g_tlfcost INTO mccg.*                  #MOD-C60140
      IF sw = 'Y' THEN
          IF g_bgjob = 'N' THEN #NO.FUN-570153 
              MESSAGE mccg.ccg01
              CALL ui.Interface.refresh()
          END IF
      END IF
      LET mccg.ccg02=yy
      LET mccg.ccg03=mm
      LET mccg.ccg11=mccg.ccg91
      LET mccg.ccg12=mccg.ccg92
      LET mccg.ccg12a=mccg.ccg92a
      LET mccg.ccg12b=mccg.ccg92b
      LET mccg.ccg12c=mccg.ccg92c
      LET mccg.ccg12d=mccg.ccg92d
      LET mccg.ccg12e=mccg.ccg92e
      LET mccg.ccg12f=mccg.ccg92f   #FUN-7C0028 add
      LET mccg.ccg12g=mccg.ccg92g   #FUN-7C0028 add
      LET mccg.ccg12h=mccg.ccg92h   #FUN-7C0028 add
      LET mccg.ccg20=0
      LET mccg.ccg21=0
      LET mccg.ccg22=0  LET mccg.ccg22a=0 LET mccg.ccg22b=0
      LET mccg.ccg22c=0 LET mccg.ccg22d=0 LET mccg.ccg22e=0
      LET mccg.ccg22f=0 LET mccg.ccg22g=0 LET mccg.ccg22h=0   #FUN-7C0028 add
      LET mccg.ccg23=0  LET mccg.ccg23a=0 LET mccg.ccg23b=0
      LET mccg.ccg23c=0 LET mccg.ccg23d=0 LET mccg.ccg23e=0
      LET mccg.ccg23f=0 LET mccg.ccg23g=0 LET mccg.ccg23h=0   #FUN-7C0028 add
      LET mccg.ccg31=0
      LET mccg.ccg32=0  LET mccg.ccg32a=0 LET mccg.ccg32b=0
      LET mccg.ccg32c=0 LET mccg.ccg32d=0 LET mccg.ccg32e=0
      LET mccg.ccg32f=0 LET mccg.ccg32g=0 LET mccg.ccg32h=0   #FUN-7C0028 add
      LET mccg.ccg41=0
      LET mccg.ccg42=0  LET mccg.ccg42a=0 LET mccg.ccg42b=0
      LET mccg.ccg42c=0 LET mccg.ccg42d=0 LET mccg.ccg42e=0
      LET mccg.ccg42f=0 LET mccg.ccg42g=0 LET mccg.ccg42h=0   #FUN-7C0028 add
 
      LET mccg.ccguser=g_user LET mccg.ccgdate=TODAY LET mccg.ccgtime=TIME
      LET mccg.ccg06=mccg.ccg06  LET mccg.ccg07=mccg.ccg07    #No.MOD-910214 add
     #LET mccg.ccgplant=g_plant  #FUN-980009 add    #FUN-A50075
      LET mccg.ccglegal=g_legal  #FUN-980009 add
      LET l_sql = "DELETE FROM ccg_file",
                  " WHERE ccg01='",mccg.ccg01,"' AND ccg02=",yy,
                  "   AND ccg03=",mm,
                  "   AND ccg06='",type,"'",   #FUN-7C0028 add
                  #"   AND ccg04 IN(SELECT ima01 FROM ima_file",  #CHI-C80002
                  #" WHERE ",g_wc CLIPPED,")"  #CHI-C80002
                  "   AND EXISTS(SELECT 1 FROM ima_file",  #CHI-C80002
                  " WHERE ima01 = ccg04 AND ",g_wc CLIPPED,")"  #CHI-C80002
      PREPARE last0_delccg_prep FROM l_sql
      IF SQLCA.sqlcode THEN
         CALL cl_err('last0 delccg:',status,1)
         CALL cl_batch_bg_javamail('N')          #FUN-570153
         CALL s_log_upd(g_cka00,'N')          #FUN-C80092 add
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      EXECUTE last0_delccg_prep
      LET mccg.ccgoriu = g_user      #No.FUN-980030 10/01/04
      LET mccg.ccgorig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO ccg_file VALUES(mccg.*)
      IF STATUS THEN
         CALL cl_err3("ins","ccg_file",mccg.ccg01,mccg.ccg02,STATUS,"","last0 ins ccg:",1)   #No.FUN-660127
         CALL cl_batch_bg_javamail('N')          #FUN-570153
         CALL s_log_upd(g_cka00,'N')          #FUN-C80092 add
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
 
      DELETE FROM cce_file
       WHERE cce01=mccg.ccg01 AND cce02=yy AND cce03=mm AND cce04=g_ima01  #No.MOD-580096
         AND cce06=mccg.ccg06 
 
      DELETE FROM cch_file
         WHERE cch01=mccg.ccg01 AND cch02=yy AND cch03=mm
           AND cch06=mccg.ccg06
 
      FOREACH last0_c2 USING mccg.ccg01 INTO g_cch.*
         LET g_cch.cch02=  yy
         LET g_cch.cch03=  mm
         LET g_cch.cch11=  g_cch.cch91
         LET g_cch.cch12=  g_cch.cch92
         LET g_cch.cch12a= g_cch.cch92a
         LET g_cch.cch12b= g_cch.cch92b
         LET g_cch.cch12c= g_cch.cch92c
         LET g_cch.cch12d= g_cch.cch92d
         LET g_cch.cch12e= g_cch.cch92e
         LET g_cch.cch12f= g_cch.cch92f   #FUN-7C0028 add
         LET g_cch.cch12g= g_cch.cch92g   #FUN-7C0028 add
         LET g_cch.cch12h= g_cch.cch92h   #FUN-7C0028 add
         LET g_cch.cch21=0
         LET g_cch.cch22=0  LET g_cch.cch22a=0 LET g_cch.cch22b=0
         LET g_cch.cch22c=0 LET g_cch.cch22d=0 LET g_cch.cch22e=0
         LET g_cch.cch22f=0 LET g_cch.cch22g=0 LET g_cch.cch22h=0   #FUN-7C0028 add
         LET g_cch.cch31=0
         LET g_cch.cch311=0   #FUN-660197 add
         LET g_cch.cch32=0  LET g_cch.cch32a=0 LET g_cch.cch32b=0
         LET g_cch.cch32c=0 LET g_cch.cch32d=0 LET g_cch.cch32e=0
         LET g_cch.cch32f=0 LET g_cch.cch32g=0 LET g_cch.cch32h=0   #FUN-7C0028 add
         LET g_cch.cch41=0
         LET g_cch.cch42=0  LET g_cch.cch42a=0 LET g_cch.cch42b=0
         LET g_cch.cch42c=0 LET g_cch.cch42d=0 LET g_cch.cch42e=0
         LET g_cch.cch42f=0 LET g_cch.cch42g=0 LET g_cch.cch42h=0   #FUN-7C0028 add
         LET g_cch.cch53=0
         LET g_cch.cch54=0  LET g_cch.cch54a=0 LET g_cch.cch54b=0
         LET g_cch.cch54c=0 LET g_cch.cch54d=0 LET g_cch.cch54e=0
         LET g_cch.cch54f=0 LET g_cch.cch54g=0 LET g_cch.cch54h=0   #FUN-7C0028 add
         LET g_cch.cchdate = g_today
         LET g_cch.cch06=g_cch.cch06 LET g_cch.cch07=g_cch.cch07    #No.MOD-910214 add
        #LET g_cch.cchplant=g_plant  #FUN-980009 add    #FUN-A50075
         LET g_cch.cchlegal=g_legal  #FUN-980009 add
         LET g_cch.cchoriu = g_user      #No.FUN-980030 10/01/04
         LET g_cch.cchorig = g_grup      #No.FUN-980030 10/01/04
         INSERT INTO cch_file VALUES (g_cch.*)
         IF SQLCA.SQLCODE AND (NOT cl_sql_dup_value(SQLCA.SQLCODE)) THEN
            CALL cl_err3("ins","cch_file",g_cch.cch01,g_cch.cch02,STATUS,"","last0 ins cch(2):",1)   #No.FUN-660127
         END IF
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
           #MOD-B30061---add---start---
            IF cl_null(g_cch.cch31) THEN LET g_cch.cch31 = 0 END IF
            IF cl_null(g_cch.cch32) THEN LET g_cch.cch32 = 0 END IF
            IF cl_null(g_cch.cch32a) THEN LET g_cch.cch32a = 0 END IF
            IF cl_null(g_cch.cch32b) THEN LET g_cch.cch32b = 0 END IF
            IF cl_null(g_cch.cch32c) THEN LET g_cch.cch32c = 0 END IF
            IF cl_null(g_cch.cch32d) THEN LET g_cch.cch32d = 0 END IF
            IF cl_null(g_cch.cch32e) THEN LET g_cch.cch32e = 0 END IF
            IF cl_null(g_cch.cch91) THEN LET g_cch.cch91 = 0 END IF
            IF cl_null(g_cch.cch92) THEN LET g_cch.cch92 = 0 END IF
            IF cl_null(g_cch.cch92a) THEN LET g_cch.cch92a = 0 END IF
            IF cl_null(g_cch.cch92b) THEN LET g_cch.cch92b = 0 END IF
            IF cl_null(g_cch.cch92c) THEN LET g_cch.cch92c = 0 END IF
            IF cl_null(g_cch.cch92d) THEN LET g_cch.cch92d = 0 END IF
            IF cl_null(g_cch.cch92e) THEN LET g_cch.cch92e = 0 END IF
           #MOD-B30061---add---end---
           #MOD-E40023 add begin----------------
           IF cl_null(g_cch.cch32f) THEN LET g_cch.cch32f = 0 END IF
           IF cl_null(g_cch.cch32g) THEN LET g_cch.cch32g = 0 END IF
           IF cl_null(g_cch.cch32h) THEN LET g_cch.cch32h = 0 END IF
           IF cl_null(g_cch.cch92f) THEN LET g_cch.cch92f = 0 END IF
           IF cl_null(g_cch.cch92g) THEN LET g_cch.cch92g = 0 END IF
           IF cl_null(g_cch.cch92h) THEN LET g_cch.cch92h = 0 END IF
           #MOD-E40023 add end-------------------           
            UPDATE cch_file SET cch_file.*=g_cch.*
               WHERE cch01=mccg.ccg01  AND cch02=yy AND cch03=mm
                 AND cch04=g_cch.cch04
                 AND cch06=g_cch.cch06 AND cch07=g_cch.cch07  #FUN-7C0028 add
            IF STATUS THEN 
              CALL cl_err3("upd","cch_file",mccg.ccg01,yy,STATUS,"","last0 upd cch(2):",1)   #No.FUN-660127
            END IF
         END IF
      END FOREACH
      CLOSE last0_c2
   END FOREACH
   CLOSE last0_c1
END FUNCTION
 
FUNCTION p500_last()            # 取上期結存轉本月期初
   DEFINE l_cnt        LIKE type_file.num5          #No.FUN-680122 SMALLINT
   DEFINE l_ccc11      LIKE ccc_file.ccc11
   DEFINE l_ccc12      LIKE ccc_file.ccc12
   DEFINE l_ccc12a     LIKE ccc_file.ccc12a
   DEFINE l_ccc12b     LIKE ccc_file.ccc12b
   DEFINE l_ccc12c     LIKE ccc_file.ccc12c
   DEFINE l_ccc12d     LIKE ccc_file.ccc12d
   DEFINE l_ccc12e     LIKE ccc_file.ccc12e
   DEFINE l_ccc12f     LIKE ccc_file.ccc12f   #FUN-7C0028 add
   DEFINE l_ccc12g     LIKE ccc_file.ccc12g   #FUN-7C0028 add
   DEFINE l_ccc12h     LIKE ccc_file.ccc12h   #FUN-7C0028 add
 
      SELECT ccc91,ccc92,ccc92a,ccc92b,ccc92c,ccc92d,ccc92e,
                         ccc92f,ccc92g,ccc92h,ccc05   #FUN-7C0028 add ccc92f,g,h
        INTO g_ccc.ccc11,g_ccc.ccc12,g_ccc.ccc12a,g_ccc.ccc12b,
             g_ccc.ccc12c,g_ccc.ccc12d,g_ccc.ccc12e,
             g_ccc.ccc12f,g_ccc.ccc12g,g_ccc.ccc12h,g_ccc.ccc05   #FUN-7C0028 add ccc.ccc12f,g,h
        FROM ccc_file           # 取上期結存轉本月期初(讀不到沒影響)
       WHERE ccc01=g_ima01 AND ccc02=last_yy AND ccc03=last_mm
         AND ccc07=type    AND ccc08=g_tlfcost   #FUN-7C0028 add
       IF g_ccc.ccc11 = 0 THEN
          LET g_ccc.ccc12 = 0
          LET g_ccc.ccc12a= 0
          LET g_ccc.ccc12b= 0
          LET g_ccc.ccc12c= 0
          LET g_ccc.ccc12d= 0
          LET g_ccc.ccc12e= 0
          LET g_ccc.ccc12f= 0   #FUN-7C0028 add
          LET g_ccc.ccc12g= 0   #FUN-7C0028 add
          LET g_ccc.ccc12h= 0   #FUN-7C0028 add
      END IF
      IF g_sma.sma43 = '1' THEN
         SELECT COUNT(*),SUM(cxd08),SUM(cxd09),SUM(cxd091),SUM(cxd092),
                         SUM(cxd093),SUM(cxd094),SUM(cxd095)
                        ,SUM(cxd096),SUM(cxd097),SUM(cxd098)   #FUN-7C0028 add
           INTO l_cnt,l_ccc11,l_ccc12,l_ccc12a,l_ccc12b,
                              l_ccc12c,l_ccc12d,l_ccc12e
                             ,l_ccc12f,l_ccc12g,l_ccc12h       #FUN-7C0028 add
           FROM cxd_file           # 取期初帳轉本月期初(讀不到沒影響)
          WHERE cxd01 =g_ima01 AND cxd02 =last_yy AND cxd03=last_mm
            AND cxd010=type    AND cxd011=g_tlfcost   #FUN-7C0028 add
         IF l_cnt > 0 THEN
            LET g_ccc.ccc11 = l_ccc11
            LET g_ccc.ccc12 = l_ccc12
            LET g_ccc.ccc12a= l_ccc12a
            LET g_ccc.ccc12b= l_ccc12b
            LET g_ccc.ccc12c= l_ccc12c
            LET g_ccc.ccc12d= l_ccc12d
            LET g_ccc.ccc12e= l_ccc12e
            LET g_ccc.ccc12f= l_ccc12f   #FUN-7C0028 add
            LET g_ccc.ccc12g= l_ccc12g   #FUN-7C0028 add
            LET g_ccc.ccc12h= l_ccc12h   #FUN-7C0028 add
         END IF
      ELSE
         SELECT cca11,cca12,cca12a,cca12b,cca12c,cca12d,cca12e,
                            cca12f,cca12g,cca12h,                    #FUN-7C0028 add
                            cca23a
           INTO g_ccc.ccc11,g_ccc.ccc12,g_ccc.ccc12a,g_ccc.ccc12b,
                            g_ccc.ccc12c,g_ccc.ccc12d,g_ccc.ccc12e,
                            g_ccc.ccc12f,g_ccc.ccc12g,g_ccc.ccc12h,  #FUN-7C0028 add
                            g_cca23a   
           FROM cca_file           # 取期初帳轉本月期初(讀不到沒影響)
           WHERE cca01=g_ima01 AND cca02=last_yy AND cca03=last_mm
             AND cca06=type    AND cca07=g_tlfcost   #FUN-7C0028 add
      END IF
      IF cl_null(g_ccc.ccc11)  THEN LET g_ccc.ccc11 = 0 END IF
      IF cl_null(g_ccc.ccc12)  THEN LET g_ccc.ccc12 = 0 END IF
      IF cl_null(g_ccc.ccc12a) THEN LET g_ccc.ccc12a= 0 END IF
      IF cl_null(g_ccc.ccc12b) THEN LET g_ccc.ccc12b= 0 END IF
      IF cl_null(g_ccc.ccc12c) THEN LET g_ccc.ccc12c= 0 END IF
      IF cl_null(g_ccc.ccc12d) THEN LET g_ccc.ccc12d= 0 END IF
      IF cl_null(g_ccc.ccc12e) THEN LET g_ccc.ccc12e= 0 END IF
      IF cl_null(g_ccc.ccc12f) THEN LET g_ccc.ccc12f= 0 END IF  #FUN-7C0028 add
      IF cl_null(g_ccc.ccc12g) THEN LET g_ccc.ccc12g= 0 END IF  #FUN-7C0028 add
      IF cl_null(g_ccc.ccc12h) THEN LET g_ccc.ccc12h= 0 END IF  #FUN-7C0028 add
      IF cl_null(g_ccc.ccc05)  THEN LET g_ccc.ccc05 = 0 END IF
      IF cl_null(g_cca23a)     THEN LET g_cca23a    = 0 END IF
END FUNCTION
 
FUNCTION p500_tlf()             # 由 tlf_file 計算各類入出庫數量
   DEFINE l_ima57              LIKE ima_file.ima57      #No.FUN-680122SMALLINT
   DEFINE l_sfb38              LIKE sfb_file.sfb38
   DEFINE l_sfb02              LIKE sfb_file.sfb02
   DEFINE l_tlf66              LIKE tlf_file.tlf66      #No:8741
   DEFINE l_flag               LIKE type_file.chr1      #No.A102        #No.FUN-680122 VARCHAR(1)
   DEFINE l_pmm02              LIKE pmm_file.pmm02      #FUN-650001 add
   DEFINE l_tlf62              LIKE tlf_file.tlf62      #MOD-710063 add
   DEFINE l_ccc23              LIKE ccc_file.ccc23,     #FUN-660184 add
          l_ccc23a             LIKE ccc_file.ccc23a,    #FUN-660184 add
          l_ccc23b             LIKE ccc_file.ccc23b,    #FUN-660184 add
          l_ccc23c             LIKE ccc_file.ccc23c,    #FUN-660184 add
          l_ccc23d             LIKE ccc_file.ccc23d,    #FUN-660184 add
          l_ccc23e             LIKE ccc_file.ccc23e,    #FUN-660184 add
          l_ccc23f             LIKE ccc_file.ccc23f,    #FUN-7C0028 add
          l_ccc23g             LIKE ccc_file.ccc23g,    #FUN-7C0028 add
          l_ccc23h             LIKE ccc_file.ccc23h,    #FUN-7C0028 add
          l_rva00              LIKE rva_file.rva00,     #MOD-C20103 add
          l_pmm22              LIKE pmm_file.pmm22,     #FUN-660184 add
          l_pmm42              LIKE pmm_file.pmm42,     #FUN-660184 add
          l_rva06              LIKE rva_file.rva06,     #FUN-660184 add
          x_flag               LIKE type_file.chr1,                   #FUN-660184 add        #No.FUN-680122 VARCHAR(1)
          l_rvv                RECORD LIKE rvv_file.*,  #FUN-660184 add
          l_apa44              LIKE apa_file.apa44,     #FUN-660184 add
          l_apb29              LIKE apb_file.apb29,     #No.MOD-A80020
          amt_1,amt_2,amtx     LIKE type_file.num20_6,        #No.FUN-680122DEC(20,6),               #FUN-660184 add
          l_amt,l_amt1,l_amt2  LIKE tlf_file.tlf21,     #FUN-660184 add
          l_amt3,l_amt4,l_amt5 LIKE tlf_file.tlf21,     #FUN-660184 add
          l_amt6,l_amt7,l_amt8 LIKE tlf_file.tlf21,     #FUN-7C002. add
          l_apb12              LIKE apb_file.apb12,     #FUN-660184 add
          l_apb09              LIKE apb_file.apb09,     #FUN-660184 add
          l_rvu08              LIKE rvu_file.rvu08,     #FUN-660184 add
          l_ccg32a             LIKE ccg_file.ccg32a,    #FUN-660184 add
          l_ccg32b             LIKE ccg_file.ccg32b,    #FUN-660184 add
          l_ccg32c             LIKE ccg_file.ccg32c,    #FUN-660184 add
          l_ccg32d             LIKE ccg_file.ccg32d,    #FUN-660184 add
          l_ccg32e             LIKE ccg_file.ccg32e,    #FUN-660184 add
          l_ccg32f             LIKE ccg_file.ccg32f,    #FUN-7C0028 add
          l_ccg32g             LIKE ccg_file.ccg32g,    #FUN-7C0028 add
          l_ccg32h             LIKE ccg_file.ccg32h     #FUN-7C0028 add
   DEFINE l_azf08              LIKE azf_file.azf08      #FUN-690068 add
   DEFINE l_smydmy2            LIKE smy_file.smydmy2    #No.MOD-920071
   DEFINE l_tlf28              LIKE tlf_file.tlf28      #CHI-980045
   DEFINE l_tlf902             LIKE tlf_file.tlf902     #CHI-A70023 add
   DEFINE l_tlf903             LIKE tlf_file.tlf903     #CHI-A70023 add
   DEFINE l_tlf904             LIKE tlf_file.tlf904     #CHI-A70023 add
   DEFINE l_rvu08_1            LIKE rvu_file.rvu08      #No.TQC-CC0131
   DEFINE l_rvu00              LIKE rvu_file.rvu00       #FUN-D60130
   DEFINE l_oga65              LIKE oga_file.oga65      #yinhy140328
   
   IF g_bgjob = 'N' THEN #NO.FUN-570153 
       MESSAGE '_tlf ...'
       CALL ui.Interface.refresh()
   END IF
    LET g_sql = 
        " SELECT tlf_file.rowid, ",
        "        tlf01,tlf06,tlf07,tlf10*tlf60, ",
        "        tlf020,tlf02,tlf021,tlf022,tlf023,tlf026,tlf027, ",
        "        tlf030,tlf03,tlf031,tlf032,tlf033,tlf036,tlf037, ",
        "        tlf13,tlf62,tlf60,tlf08,tlf905,tlf906,tlf21,",
        "        tlf221,tlf222,tlf2231,tlf2232,tlf224,",
        "        tlf2241,tlf2242,tlf2243,tlfcost,",
        "        sfb38,sfb99,ima57,sfb02,tlf66,tlf28",           #NO:8741  #CHI-980045
        "       ,tlf902,tlf903,tlf904",                          #CHI-A70023 add
        "   FROM tlf_file LEFT OUTER JOIN ",
        "   (select sfb38,sfb99,ima57,sfb02,sfb01 ",
        "      from sfb_file,ima_file ",
        "     where sfb05 = ima01) tmp ON tlf62=tmp.sfb01",
        "  WHERE tlf01 = '",g_ima01,"'",
        "    AND ((tlf02 BETWEEN 50 AND 59) OR (tlf03 BETWEEN 50 AND 59)) ",
        "    AND NOT (tlf02 = 651 OR tlf03 = 651)  ",
        "    AND tlf06 BETWEEN '",g_bdate,"' AND '", g_edate,"'",
        #"    AND tlf902 NOT IN(SELECT jce02 FROM jce_file)  ",  #CHI-C80002
        "    AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = tlf902)  ", #CHI-C80002
        "    AND tlf907 != 0 ",
        "    AND tlfcost = '",g_tlfcost,"'",
        "  ORDER BY tlf13,tlf62 "
    PREPARE p500_c2_pre FROM g_sql
    DECLARE p500_c2 CURSOR WITH HOLD FOR p500_c2_pre

   #CHI-C80002---begin
   LET g_sql = " SELECT apa44,apb29,SUM(ABS(apb101)) ",   
               " FROM apb_file,apa_file ",
               " WHERE apb21=? AND apb22=? AND apb01=apa01 ",
               " AND (apa00 = '11' OR apa00='16') AND apa75 != 'Y' ",   
               " AND apa42 = 'N' ",
               " AND apa02 BETWEEN '",g_bdate,"' AND '", g_edate,"'", 
               " AND apb34 <> 'Y' ",       
               " GROUP BY apa44,apb29 "
   PREPARE apa_cursor_p1 FROM g_sql
   DECLARE apa_cursor_1 CURSOR FOR apa_cursor_p1

   LET g_sql = " SELECT apb12,SUM(ABS(apb09)) ",
               " FROM apb_file,apa_file ",
               " WHERE apb21=? AND apb22=? AND apb01=apa01 ",
               " AND (apa00 = '21' OR apa00='26') AND apa75 != 'Y' ",
               " AND (apa58 = '2' OR apa58 = '3'  OR apa58 IS NULL) ",    #No.TQC-CC0145
               " AND apa42 = 'N' ",
               " AND apa02 BETWEEN '",g_bdate,"' AND '", g_edate,"'",
               " AND apb34 <> 'Y' ",         
               " GROUP BY apb12 "
   PREPARE apa_cursor_p2_1 FROM g_sql
   DECLARE apa_cursor2_1 CURSOR FOR apa_cursor_p2_1
         
   LET g_sql = " SELECT apa44,SUM(ABS(apb101)) ",
               " FROM apb_file,apa_file ",
               " WHERE apb21=? AND apb22=? AND apb01=apa01 ",
               " AND (apa00 = '21' OR apa00='26') AND apa75 != 'Y' ",
               " AND (apa58 = '2' OR apa58 = '3'  OR apa58 IS NULL) ",    #No.TQC-CC0145
               " AND apa42 = 'N' ",
               " AND apa02 BETWEEN '",g_bdate,"' AND '", g_edate,"'",
               " AND apb34 <> 'Y' ",
               " GROUP BY apa44 "
   PREPARE apa_cursor_p1_1 FROM g_sql
   DECLARE apa_cursor1_1 CURSOR FOR apa_cursor_p1_1

   LET g_sql = " SELECT alk72,SUM(ale09) ",
               " FROM ale_file ,alk_file ",
               " WHERE ale16=? AND ale17=? AND ale01=alk01 ",
               "   AND alkfirm <> 'X' ",  #CHI-C80041
               " GROUP BY alk72 "
   PREPARE ale_cursor_p1 FROM g_sql
   DECLARE ale_cursor_1 CURSOR FOR ale_cursor_p1
   #CHI-C80002---end
 
   LET l_tlf62 = ' '   #MOD-710063 add
   #FOREACH p500_c2 INTO q_tlf_rowid, q_tlf.*, l_sfb38, g_sfb99, l_ima57,l_sfb02,l_tlf66,l_tlf28  #No:8741 #CHI-980045   #CHI-A70023 mark
   FOREACH p500_c2 INTO q_tlf_rowid, q_tlf.*, l_sfb38, g_sfb99, l_ima57,l_sfb02,l_tlf66,l_tlf28,l_tlf902,l_tlf903,l_tlf904 #CHI-A70023 add
      IF STATUS THEN
         CALL cl_err('fore tlf!',STATUS,1) LET g_success = 'N' EXIT FOREACH   
      END IF
      IF cl_null(q_tlf.tlf02) AND cl_null(q_tlf.tlf03) THEN
         CONTINUE FOREACH
      END IF
      IF q_tlf.tlf13 MATCHES 'asf*' AND
        (YEAR(q_tlf.tlf06)*12 + MONTH(q_tlf.tlf06) >
         YEAR(l_sfb38)    *12 + MONTH(l_sfb38)    ) THEN
         CALL cl_getmsg('axc-521',g_lang) RETURNING g_msg1
         CALL cl_getmsg('axc-520',g_lang) RETURNING g_msg2
         CALL cl_getmsg('axc-501',g_lang) RETURNING g_msg3
         LET g_msg=g_msg1 CLIPPED,g_ima01 CLIPPED,' ',
                   g_msg2 CLIPPED,q_tlf.tlf62,g_msg3 CLIPPED,l_sfb38
 
         LET t_time = TIME
        #LET g_time=t_time #MOD-C30891 mark
        #FUN-A50075--mod--str--ccy_file拿掉legal以及plant
        #INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04,ccyplant,ccylegal)   #No.MOD-470041 #FUN-980009 add ccyplant,ccylegal
        #              VALUES(TODAY,g_time,g_user,g_msg,g_plant,g_legal) #FUN-980009 add g_plant,g_legal
         INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04)
                      #VALUES(TODAY,g_time,g_user,g_msg) #MOD-C30891 mark
                       VALUES(TODAY,t_time,g_user,g_msg) #MOD-C30891
        #FUN-A50075--mod--end
      END IF
      LET xxx=NULL
#-------------------------------------------------------------->出庫
      IF (q_tlf.tlf02 = 50 OR q_tlf.tlf02 = 57)  THEN
         CALL s_get_doc_no(q_tlf.tlf026) RETURNING xxx
         LET xxx1=q_tlf.tlf026 LET xxx2=q_tlf.tlf027
         LET u_sign=-1
      END IF
#-------------------------------------------------------------->入庫
      IF (q_tlf.tlf03 = 50 OR q_tlf.tlf03 = 57)  THEN
         CALL s_get_doc_no(q_tlf.tlf036) RETURNING xxx
         IF xxx IS NULL THEN CONTINUE FOREACH END IF
         LET l_smydmy2=''
         SELECT smydmy2 INTO l_smydmy2 FROM smy_file WHERE smyslip=xxx
         LET xxx1=q_tlf.tlf036 LET xxx2=q_tlf.tlf037
         LET u_sign=1
         IF g_sma.sma43 = '1' AND l_smydmy2 != '4' THEN       #MOD-970102 modify
            IF q_tlf.tlf13 = 'apmt230' THEN
               LET l_flag = 'Y' ELSE LET l_flag = 'N'
            END IF
            IF cl_null(q_tlf.tlf2241x) THEN LET q_tlf.tlf2241x = 0 END IF  #CHI-910041
            IF cl_null(q_tlf.tlf2242x) THEN LET q_tlf.tlf2242x = 0 END IF  #CHI-910041
            IF cl_null(q_tlf.tlf2243x) THEN LET q_tlf.tlf2243x = 0 END IF  #CHI-910041
            INSERT INTO cxa_file(cxa01,cxa02,cxa03,cxa04,cxa05,cxa06,cxa07,
                                 cxa08,cxa09,cxa091,cxa092,cxa093,cxa094,
                                 cxa095,cxa096,cxa097,cxa098,   #FUN-7C0028 add cxa096,7,8
                                 cxa010,cxa011,                 #No.MOD-910079 add by liuxqa 
                                 cxa10,cxa11,cxa111,cxa112,cxa113,
                                 cxa114,cxa115,cxa15,cxalegal) #FUN-980009 add cxaplant,cxalegal   #FUN-A50075 拿掉PLANT
                          VALUES(q_tlf.tlf01,yy,mm,q_tlf.tlf06,q_tlf.tlf08,
                                 q_tlf.tlf036,q_tlf.tlf037,q_tlf.tlf10,
                                 q_tlf.tlf21x,q_tlf.tlf221x,q_tlf.tlf222x,    #CHI-910041 
                                 q_tlf.tlf2231x,q_tlf.tlf2232x,q_tlf.tlf224x, #CHI-910041
                                 q_tlf.tlf2241x,q_tlf.tlf2242x,q_tlf.tlf2243x,  #FUN-7C0028 add #CHI-910041
                                 type,g_tlfcost,                               #No.MOD-910079 add by liuxqa
                                 0,0,0,0,0,0,0,l_flag,g_legal) #FUN-980009 add g_plant,g_legal   #FUN-A50075 del plant
            IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
               CALL cl_err3("ins","cxa_file",q_tlf.tlf01,yy,STATUS,"","ins cxa #2",0)   #No.FUN-660127
               LET g_success = 'N' RETURN 
            END IF
         END IF
         #end
      END IF
#-------------------------------------------------------------->二階段調撥(出)
      IF (q_tlf.tlf02 = 50 AND q_tlf.tlf03 = 57)  THEN
         CALL s_get_doc_no(q_tlf.tlf026) RETURNING xxx
         LET xxx1=q_tlf.tlf026 LET xxx2=q_tlf.tlf027
         LET u_sign=-1
      END IF
#-------------------------------------------------------------->取成會分類
      IF xxx IS NULL THEN CONTINUE FOREACH END IF
      LET u_flag='' LET g_smydmy1=''
      SELECT smydmy2,smydmy1,smy53,smy54 INTO u_flag,g_smydmy1,g_smy53,g_smy54
        FROM smy_file WHERE smyslip=xxx
      IF STATUS THEN            # V2.0版沒有smy53,smy54
         SELECT smydmy2,smydmy1 INTO u_flag,g_smydmy1
           FROM smy_file WHERE smyslip=xxx
      END IF
      #140422 add begin----------------
      IF q_tlf.tlf02 = 50 AND q_tlf.tlf03 =18 THEN 
         LET g_smydmy1 = 'Y'
         LET u_flag = 3
      END IF 
      #140422 add end------------------
      IF g_smydmy1='N' OR g_smydmy1 IS NULL THEN CONTINUE FOREACH END IF  #No:8327
 
#u_sign 不再重給值
     #IF q_tlf.tlf13='aimp880' THEN LET u_flag='6' END IF  #TQC-B30129
      IF (q_tlf.tlf13='aimp880' OR q_tlf.tlf13='artt215') THEN LET u_flag='6' END IF  #TQC-B30129
      IF u_flag NOT MATCHES "[123456]" OR u_flag IS NULL THEN   #FUN-770032 
         CONTINUE FOREACH
      END IF
#--------------------------------------------------------------
      IF u_flag='3' AND (g_sfb99 IS NULL OR g_sfb99 = ' ' OR g_sfb99 = 'N') AND
        #q_tlf.tlf13 NOT MATCHES 'aimt3*' AND    #No.6820  #TQC-B30129
        #(q_tlf.tlf13 NOT MATCHES 'aimt3*' OR q_tlf.tlf13 <> 'artt256') AND    #No.6820  #TQC-B30129   #MOD-C80123 mark
         (q_tlf.tlf13 NOT MATCHES 'aimt3*' AND q_tlf.tlf13 <> 'artt256') AND   #MOD-C80123 add 
         (q_tlf.tlf13 <> 'apmt1072') AND  #FUN-BB0063 add
         g_ima57_t <= l_ima57 THEN
         CALL cl_getmsg('axc-521',g_lang) RETURNING g_msg1
         CALL cl_getmsg('axc-520',g_lang) RETURNING g_msg2
         CALL cl_getmsg('axc-502',g_lang) RETURNING g_msg3
 
         LET g_msg=g_msg1 CLIPPED,g_ima01 CLIPPED,' ',
                   g_msg2 CLIPPED,q_tlf.tlf62,g_msg3 CLIPPED
 
         LET t_time = TIME
        #LET g_time=t_time #MOD-C30891 mark
#FUN-A50075--mod--str-- ccy_file拿掉plant以及legal
#        INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04,ccyplant,ccylegal)   #No.MOD-470041 #FUN-980009 add ccyplant,ccylegal
#                      VALUES(TODAY,g_time,g_user,g_msg,g_plant,g_legal) #FUN-980009 add g_plant,g_legal
         INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04)
                      #VALUES(TODAY,g_time,g_user,g_msg) #MOD-C30891 mark
                       VALUES(TODAY,t_time,g_user,g_msg) #MOD-C30891 
#FUN-A50075--MOD--END
         LET g_sfb99 = 'Y'
      END IF
      IF q_tlf.tlf13[1,5]='asfi5' AND g_sfb99='Y' AND l_ima57<g_ima57_t THEN
         LET g_sfb99='N'
      END IF
 
     IF g_sfb99 IS NULL THEN LET g_sfb99=' ' END IF   #FUN-7C0028 add
 
     #FUN-D60130 add-----------str
     #先抓rvu08,以判斷是不是委外
     LET l_rvu08=NULL
     SELECT rvu08 INTO l_rvu08 FROM rvu_file 
      WHERE rvu01=q_tlf.tlf905
     IF cl_null(l_rvu08) THEN LET l_rvu08=' ' END IF
     #FUN-D60130 add-----------end

    #增加條件判斷計算非[銷退則讓][倉退則讓]才時排除數量為0的tlf
     IF q_tlf.tlf13 != 'aomt800' AND (q_tlf.tlf13 NOT MATCHES 'apmt107*' ) 
        AND NOT (q_tlf.tlf13 ='asft6201' AND l_rvu08 ='SUB' AND g_sfb99 !='Y')  THEN   #FUN-D60130
        IF q_tlf.tlf10 = 0 THEN CONTINUE FOREACH END IF
     END IF
     
 
#-------------------------------------------------------------->分類統計
       CASE WHEN q_tlf.tlf13[1,4]='axmt' OR q_tlf.tlf13 = 'aomt800'   #銷貨領出
                #當在出貨單單身的原因碼ogb1001┐
                #    銷退單單身的原因碼ohb50  ┘
                #在aooi301裡面"是否列入銷售費用(azf08)"為Y的話,
                #需將數量、成本寫入ccc81,ccc82,ccc82a~ccc82e裡
                 IF q_tlf.tlf13[1,4]='axmt' THEN   #銷貨單
                    SELECT azf08 INTO l_azf08
                      FROM ogb_file,azf_file
                     WHERE ogb01=q_tlf.tlf905 AND ogb03=q_tlf.tlf906 
                       AND ogb1001=azf01      AND azf02='2'
                    #add by yinhy 140328 begin---
                    SELECT oga65 INTO l_oga65
                      FROM oga_file
                     WHERE oga01 = q_tlf.tlf905
                    #add by yinhy 140328 end-----
                    IF SQLCA.SQLCODE THEN LET l_azf08 = 'N' END IF
                    IF l_azf08 = 'Y' THEN
                       LET g_ccc.ccc81=g_ccc.ccc81+q_tlf.tlf10*u_sign
                    ELSE
                       IF l_oga65 = 'N' OR cl_null(l_oga65) THEN      #yinhy140328
                          LET g_ccc.ccc61=g_ccc.ccc61+q_tlf.tlf10*u_sign
                          #CALL p500_ccc63_cost(u_sign,l_tlf66)   #No:8741  #CHI-A70023 mark
                          CALL p500_ccc63_cost(u_sign,l_tlf66,l_tlf902,l_tlf903,l_tlf904) #CHI-A70023 add
                          IF u_sign = 1 THEN
                             LET g_ccc.ccc64=g_ccc.ccc64+q_tlf.tlf10*u_sign
                          END IF  
                       END IF         #yinhy140328 
                    END IF
                 END IF
                 IF q_tlf.tlf13 = 'aomt800' THEN   #銷退單
                    SELECT azf08 INTO l_azf08
                      FROM ohb_file,azf_file
                     WHERE ohb01=q_tlf.tlf905 AND ohb03=q_tlf.tlf906
                       AND ohb50=azf01        AND azf02='2'
                    IF SQLCA.SQLCODE THEN LET l_azf08 = 'N' END IF
                    #CHI-980045(S) #若銷退視為"銷退入庫"項時,數量就不歸到銷貨出貨或樣品出貨                    
                    IF (g_ccz.ccz31 MATCHES '[23]') AND (l_tlf28='S') THEN  
                       LET g_ccc.ccc21 =g_ccc.ccc21 +q_tlf.tlf10*u_sign
                       LET u_flag = 1  #成會分類=1.入庫
                       #MOD-C70153 str add-----
                        SELECT SUM(ohb14*oha24) INTO l_amt  #本幣未稅金額
                          FROM oha_file,ohb_file
                         WHERE oha01=ohb01
                           AND oha01=xxx1 AND ohb03=xxx2
                           AND oha09='3'
                           AND ohaconf='Y'
                           AND ohapost='Y'

                        IF l_amt IS NULL THEN LET l_amt=0 END IF
                        LET l_amt = l_amt * -1
                        LET g_ccc.ccc63 = g_ccc.ccc63 + l_amt
                      #MOD-C70153 end add-----
                    ELSE
                    #CHI-980045(E)
                       IF l_azf08 = 'Y' THEN
                          LET g_ccc.ccc81=g_ccc.ccc81+q_tlf.tlf10*u_sign
                       ELSE
                          LET g_ccc.ccc61=g_ccc.ccc61+q_tlf.tlf10*u_sign
                          #CALL p500_ccc63_cost(u_sign,l_tlf66)   #No:8741  #CHI-A70023 mark
                          CALL p500_ccc63_cost(u_sign,l_tlf66,l_tlf902,l_tlf903,l_tlf904) #CHI-A70023 add
                          IF u_sign = 1 THEN
                             LET g_ccc.ccc64=g_ccc.ccc64+q_tlf.tlf10*u_sign
                          END IF
                       END IF
                    END IF
                 END IF
                #end FUN-690068 modify
            WHEN q_tlf.tlf13='aimt301' OR q_tlf.tlf13='aimt311'
#No.+304 報廢異動(aimt303,aimt313)應列入雜發異動中
              OR q_tlf.tlf13 = 'aimt303' OR q_tlf.tlf13 = 'aimt313'
                 LET g_ccc.ccc41=g_ccc.ccc41+q_tlf.tlf10*u_sign
           #增加"廠對廠直接調撥"(aimt720),撥出部份(tlf02=50,tlf03=57),
           #    "兩階段營運中心間調撥"(aimp700)撥出部份
           #寫入雜發
            WHEN (q_tlf.tlf13 = 'aimt720' AND q_tlf.tlf02=50 AND q_tlf.tlf03=57)
              OR  q_tlf.tlf13 = 'aimp700'
                 LET g_ccc.ccc41=g_ccc.ccc41+q_tlf.tlf10*u_sign
            #FUN-B90029(S)
            WHEN q_tlf.tlf13='asft700'   #工單發料
                 LET g_ccc.ccc31=g_ccc.ccc31+q_tlf.tlf10*u_sign
            #FUN-B90029(E)                 
            WHEN q_tlf.tlf13[1,5]='asfi5'   #工單發料
                 IF g_sfb99='Y' THEN        #重工領出
                    LET g_ccc.ccc25=g_ccc.ccc25+q_tlf.tlf10*u_sign
                 ELSE                       #一般工單領出
                    LET g_ccc.ccc31=g_ccc.ccc31+q_tlf.tlf10*u_sign
                 END IF
            WHEN q_tlf.tlf13[1,5]='asft6'   #工單入庫
                 IF q_tlf.tlf02 = 65 OR q_tlf.tlf03 = 65 THEN # 拆件工單
                 ELSE
                    IF g_sfb99='Y' THEN     #重工入庫
                       LET g_ccc.ccc27=g_ccc.ccc27+q_tlf.tlf10*u_sign
                    ELSE                    #一般入庫
                       LET g_ccc.ccc21=g_ccc.ccc21+q_tlf.tlf10*u_sign
                       CALL p500_ccc22_cost()
                    END IF
                 END IF
            WHEN q_tlf.tlf13[1,5]='asri2'   #重覆行生產發退料
                 LET g_ccc.ccc31=g_ccc.ccc31+q_tlf.tlf10*u_sign
            WHEN q_tlf.tlf13[1,5]='asrt3'   #重覆行生產入庫
                 LET g_ccc.ccc21=g_ccc.ccc21+q_tlf.tlf10*u_sign
            WHEN q_tlf.tlf13 = 'aimt302' OR q_tlf.tlf13 = 'aimt312'
                    LET g_ccc.ccc21=g_ccc.ccc21+q_tlf.tlf10
                    LET g_ccc.ccc43=g_ccc.ccc43+q_tlf.tlf10
                    CALL p500_ccc22_cost()
            WHEN q_tlf.tlf13 = 'aimt306' OR q_tlf.tlf13 = 'aimt309'   #借還料   
                    LET g_ccc.ccc21=g_ccc.ccc21+q_tlf.tlf10*u_sign
                    LET g_ccc.ccc43=g_ccc.ccc43+q_tlf.tlf10*u_sign
                    CALL p500_ccc22_cost()
           #增加"廠對廠直接調撥"(aimt720),撥入部份(tlf02=57,tlf03=50),
           #    "兩階段營運中心間調撥"(aimp701)撥入部份
           #寫入雜收
            WHEN (q_tlf.tlf13 = 'aimt720' AND q_tlf.tlf02=57 AND q_tlf.tlf03=50)
              OR  q_tlf.tlf13 = 'aimp701'
                 LET g_ccc.ccc21=g_ccc.ccc21+q_tlf.tlf10*u_sign  #MOD-D20045
                 LET g_ccc.ccc43=g_ccc.ccc43+q_tlf.tlf10*u_sign  #MOD-D20045
                 CALL p500_ccc22_cost()
           #增加"產品組合包裝維護作業"(atmt260)
           #    "產品組合拆解維護作業"(atmt261)
            WHEN (q_tlf.tlf13 = 'atmt260' )
                 AND u_sign=1
                 LET g_ccc.ccc21=g_ccc.ccc21+q_tlf.tlf10*u_sign
                 LET g_ccc.ccc43=g_ccc.ccc43+q_tlf.tlf10*u_sign
                 CALL p500_ccc22_cost()
            WHEN (q_tlf.tlf13 = 'atmt260' )
                 AND u_sign=-1
                 LET g_ccc.ccc41=g_ccc.ccc41+q_tlf.tlf10*u_sign
            WHEN (q_tlf.tlf13 = 'atmt261' )
                 AND u_sign=-1
                 LET g_ccc.ccc21=g_ccc.ccc21+q_tlf.tlf10*u_sign
                 LET g_ccc.ccc43=g_ccc.ccc43+q_tlf.tlf10*u_sign
                 CALL p500_ccc22_cost()
            WHEN (q_tlf.tlf13 = 'atmt261' )
                 AND u_sign=1
                 LET g_ccc.ccc41=g_ccc.ccc41+q_tlf.tlf10*u_sign
           #增加"倉庫間直接調撥作業"(aimt324)
           #WHEN q_tlf.tlf13 = 'aimt324'     #倉庫調撥  #TQC-B30129
            WHEN (q_tlf.tlf13 = 'aimt324' OR q_tlf.tlf13 = 'aimt325' OR q_tlf.tlf13 = 'artt256')     #倉庫調撥  #TQC-B30129  #MOD-C70249 add aimt325
                 LET g_ccc.ccc21=g_ccc.ccc21+q_tlf.tlf10*u_sign
                 LET g_ccc.ccc43=g_ccc.ccc43+q_tlf.tlf10*u_sign
                 CALL p500_ccc22_cost()
            WHEN u_flag='1'                 #一般工單入庫,採購入,倉退
                 LET g_ccc.ccc21=g_ccc.ccc21+q_tlf.tlf10*u_sign
                 CALL p500_ccc22_cost()
            WHEN u_flag='5'                 #調整
                 LET g_ccc.ccc51=g_ccc.ccc51+q_tlf.tlf10*u_sign
            WHEN u_flag='6'                 #盤差
                 LET g_ccc.ccc71=g_ccc.ccc71+q_tlf.tlf10*u_sign
            OTHERWISE CONTINUE FOREACH
       END CASE
       CALL p500_tlf15_upd()
 
        IF u_flag='1' OR q_tlf.tlf13 = 'aimt324'     #No:MOD-9B0138 modify                #一般工單入庫,採購入,倉退
                      OR q_tlf.tlf13 = 'aimt325'     #MOD-C70249 add
                      OR q_tlf.tlf13 = 'artt256'     #TQC-B30129
                      OR q_tlf.tlf13 = 'aimt302' OR  q_tlf.tlf13='aimt312'                #MOD-A70092 add
                      OR q_tlf.tlf13 = 'aimt306' OR  q_tlf.tlf13='aimt309'  #借還料       #MOD-A70092 add
                      OR (q_tlf.tlf13= 'aimt720' AND q_tlf.tlf02=57 AND q_tlf.tlf03=50)   #MOD-A70092 add
                      OR q_tlf.tlf13 = 'aimp701' THEN                                     #MOD-A70092 add
       #FUN-D60130 mark-----str
       #   #先抓rvu08,以判斷是不是委外
       #   LET l_rvu08=NULL
       #   SELECT rvu08 INTO l_rvu08 FROM rvu_file 
       #    WHERE rvu01=q_tlf.tlf036
       #   IF cl_null(l_rvu08) THEN LET l_rvu08=' ' END IF
       #FUN-D60130 mark-----end
           CASE 
              #採購入庫
              WHEN q_tlf.tlf13 =  'apmt150' OR
                   q_tlf.tlf13 =  'apmt1072' OR
                   q_tlf.tlf13 =  'apmt230'   #委外代採買入庫   #FUN-7C0083 add
                   LET g_ccc.ccc211=g_ccc.ccc211+q_tlf.tlf10*u_sign
                  #MOD-C70272 str add-----
                   IF NOT cl_null(q_tlf.tlf62 ) AND q_tlf.tlf13 = 'apmt1072' AND l_sfb02 = '7' THEN
                      EXIT CASE
                   END IF
                  #MOD-C70272 end add-----
                   #-->發票請款立帳
                   LET l_apa44 = ''
                   LET l_apb29 = ''         #No.MOD-A80020
                   LET amt_1 = 0 LET amt_2 = 0 LET x_flag = 'N'
                   #CHI-C80002---begin mark
                   #DECLARE apa_cursor_1 CURSOR FOR
                   ##配合成本分攤aapt900 apb10->apb101
                   # SELECT apa44,apb29,SUM(ABS(apb101))       #No.MOD-A80020
                   #  FROM apb_file,apa_file
                   # WHERE apb21=xxx1 AND apb22=xxx2 AND apb01=apa01
                   #   AND (apa00 = '11' OR apa00='16') AND apa75 != 'Y'   #CHI-7B0022
                   #   AND apa42 = 'N'
                   #   AND apa02 BETWEEN g_bdate AND g_edate
                   #   AND apb34 <> 'Y'             #No.TQC-7C0126
                   #  GROUP BY apa44,apb29    #No.MOD-A80020
                   #CHI-C80002---end
                   LET amtx = 0
                   #FOREACH apa_cursor_1 INTO l_apa44,l_apb29,amtx   #No.MOD-A80020 #CHI-C80002
                   FOREACH apa_cursor_1 USING xxx1,xxx2 INTO l_apa44,l_apb29,amtx  #CHI-C80002
#No.MOD-A80020 --begin
                      IF l_apb29 = '3' THEN
                         LET amtx = amtx * -1
                      END IF
#No.MOD-A80020 --end
                      LET amt_1 = amt_1 + amtx  LET x_flag = 'Y'
                   END FOREACH
                   IF amt_1 IS NULL THEN LET amt_1 = 0 END IF
                   #-->扣除折讓部份(退貨)
                   IF g_sma.sma43 = '1' THEN
                      #CHI-C80002---begin mark
                      #DECLARE apa_cursor2_1 CURSOR FOR
                      # SELECT apb12,SUM(ABS(apb09))  #No.TQC-7C0126
                      #   FROM apb_file,apa_file
                      #  WHERE apb21=xxx1 AND apb22=xxx2 AND apb01=apa01
                      #    AND (apa00 = '21' OR apa00='26') AND apa75 != 'Y'
                      #    AND (apa58 = '2' OR apa58 = '3')
                      #    AND apa42 = 'N'
                      #    AND apa02 BETWEEN g_bdate AND g_edate
                      #    AND apb34 <> 'Y'             #No.TQC-7C0126
                      #  GROUP BY apb12
                      #FOREACH apa_cursor2_1 INTO l_apb12,l_apb09
                      #CHI-C80002---end
                      FOREACH apa_cursor2_1 USING xxx1,xxx2 INTO l_apb12,l_apb09  #CHI-C80002
                         CALL p500_upd_cxa09(l_apb12,l_apb09,1)     #倉退
                              RETURNING amtx,l_amt1,l_amt2,l_amt3,l_amt4,l_amt5
                                            ,l_amt6,l_amt7,l_amt8   #FUN-7C0028 add
                         LET amt_2 = amt_2 + amtx LET x_flag = 'Y'
                         LET l_apa44 = 'FIFO'
                      END FOREACH
                   ELSE
                      #CHI-C80002---begin mark
                      #DECLARE apa_cursor1_1 CURSOR FOR
                      # SELECT apa44,SUM(ABS(apb101))  #No.TQC-7C0126
                      #  FROM apb_file,apa_file
                      # WHERE apb21=xxx1 AND apb22=xxx2 AND apb01=apa01
                      #   AND (apa00 = '21' OR apa00='26') AND apa75 != 'Y'
                      #   AND (apa58 = '2' OR apa58 = '3')
                      #   AND apa42 = 'N'
                      #   AND apa02 BETWEEN g_bdate AND g_edate
                      #   AND apb34 <> 'Y'             #No.TQC-7C0126
                      #  GROUP BY apa44
                      #CHI-C80002---end
                      LET amtx = 0
                      #FOREACH apa_cursor1_1 INTO l_apa44,amtx  #CHI-C80002
                      FOREACH apa_cursor1_1 USING xxx1,xxx2 INTO l_apa44,amtx  #CHI-C80002
                          LET amt_2 = amt_2 + amtx LET x_flag = 'Y'
                      END FOREACH
                   END IF
                   IF amt_2 IS NULL THEN LET amt_2 = 0 END IF
                   LET amt = amt_1-amt_2
                   #-->不決定正負數
                   IF amt < 0 THEN LET amt = amt * -1 END IF
                   IF x_flag = 'N' THEN
                      #CHI-C80002---begin
                      #DECLARE ale_cursor_1 CURSOR FOR
                      #SELECT alk72,SUM(ale09)  #INTO amt
                      #  FROM ale_file ,alk_file
                      # WHERE ale16=xxx1 AND ale17=xxx2 AND ale01=alk01
                      # GROUP BY alk72
                      #CHI-C80002---end
                      LET amtx = 0
                      #FOREACH ale_cursor_1 INTO l_apa44,amtx  #CHI-C80002
                      FOREACH ale_cursor_1 USING xxx1,xxx2 INTO l_apa44,amtx  #CHI-C80002
                         LET amt = amt + amtx LET x_flag = 'Y'
                      END FOREACH
                      #供月中暫估成本使用
                      IF x_flag = 'N' THEN
                         SELECT * INTO l_rvv.* FROM rvv_file
                          WHERE rvv01=xxx1 AND rvv02=xxx2
                            AND rvv25 != 'Y'
                         IF STATUS = 0 THEN
                            #直接取 P/O 上的匯率
                            SELECT rva00 INTO l_rva00 FROM rva_file WHERE rva01=l_rvv.rvv04   #MOD-C20103 add
                            IF l_rva00 <> '2'THEN                                             #MOD-C20103 add
                               SELECT pmm22,rva06,pmm42 INTO l_pmm22,l_rva06,l_pmm42
                                 FROM rvb_file,pmm_file,rva_file
                                WHERE rvb01=l_rvv.rvv04 AND rvb02=l_rvv.rvv05
                                  AND pmm01=rvb04 AND rva01 = rvb01
                                  AND rvaconf <> 'X' AND pmm18 <> 'X'
                               IF STATUS <> 0 THEN
                                  LET l_pmm22=' '
                                  LET l_pmm42= 1
                               END IF
                            #MOD-C20103 str  add------
                            ELSE
                               SELECT rva113,rva06,rva114 INTO l_pmm22,l_rva06,l_pmm42
                                 FROM rvb_file,rva_file
                                WHERE rvb01=l_rvv.rvv04 AND rvb02=l_rvv.rvv05
                                  AND rva01 = rvb01 AND rvaconf <> 'X'
                               IF STATUS <> 0 THEN
                                  LET l_pmm22=' '
                                  LET l_pmm42= 1
                               END IF
                            END IF
                            #MOD-C20103 end  add------
                            IF l_pmm42 IS NULL THEN LET l_pmm42=1 END IF
                            LET amt=l_rvv.rvv39*l_pmm42
                         END IF
                         IF amt IS NULL THEN LET amt=0 END IF
                      END IF
                   END IF
#No.TQC-CC0131 --begin
#                   LET g_ccc.ccc22a1=g_ccc.ccc22a1+amt*u_sign
                   LET g_ccc.ccc22a1=g_ccc.ccc22a1+amt*u_sign       #TQC-D30002 add
#TQC-D30002---mark---str---
#                  LET l_rvu08_1=NULL
#                  SELECT rvu08 INTO l_rvu08_1 FROM rvu_file
#                   WHERE rvu01=q_tlf.tlf905
#                  IF l_rvu08_1 <> 'SUB' THEN 
#                     LET g_ccc.ccc22a1=g_ccc.ccc22a1+amt*u_sign
#                  END IF
#No.TQC-CC0131 --end
#TQC-D30002---mark---end---
                  #end FUN-660184 add
              #委外入庫
              WHEN q_tlf.tlf13 =  'asft6201' AND l_rvu08='SUB'   #FUN-660184
                   AND g_sfb99 != 'Y'   #No.MOD-850148 add  #排除委外重工入庫
                   LET g_ccc.ccc212=g_ccc.ccc212+q_tlf.tlf10*u_sign
                   ###若工單分批入庫時，同樣的工單會重覆計算到，
                   ###所以需增加判斷，讓一張工單只會計算一次
                   IF q_tlf.tlf62 != l_tlf62 THEN
                      LET l_ccg32a = 0
                      LET l_ccg32b = 0
                      LET l_ccg32c = 0
                      LET l_ccg32d = 0
                      LET l_ccg32e = 0
                      LET l_ccg32f = 0   #FUN-7C0028 add
                      LET l_ccg32g = 0   #FUN-7C0028 add
                      LET l_ccg32h = 0   #FUN-7C0028 add
                      #抓工單上階在製成本,本月轉出ccg32a*(-1)~ccg32h*(-1)寫入ccc22a2~ccc22h2
                      SELECT SUM(ccg32a*-1),SUM(ccg32b*-1),SUM(ccg32c*-1),
                             SUM(ccg32d*-1),SUM(ccg32e*-1)
                            ,SUM(ccg32f*-1),SUM(ccg32g*-1),SUM(ccg32h*-1)   #FUN-7C0028 add
                        INTO l_ccg32a,l_ccg32b,l_ccg32c,l_ccg32d,l_ccg32e
                            ,l_ccg32f,l_ccg32g,l_ccg32h   #FUN-7C0028 add
                        FROM ccg_file
                       WHERE ccg04=g_ima01 AND ccg02=yy AND ccg03=mm
                         AND ccg01=q_tlf.tlf62 
                         AND ccg06=type
                         AND ccg07=g_tlfcost   #MOD-C60140 add
                      IF cl_null(l_ccg32a) THEN LET l_ccg32a = 0 END IF
                      IF cl_null(l_ccg32b) THEN LET l_ccg32b = 0 END IF
                      IF cl_null(l_ccg32c) THEN LET l_ccg32c = 0 END IF
                      IF cl_null(l_ccg32d) THEN LET l_ccg32d = 0 END IF
                      IF cl_null(l_ccg32e) THEN LET l_ccg32e = 0 END IF
                      IF cl_null(l_ccg32f) THEN LET l_ccg32f = 0 END IF   #FUN-7C0028 add
                      IF cl_null(l_ccg32g) THEN LET l_ccg32g = 0 END IF   #FUN-7C0028 add
                      IF cl_null(l_ccg32h) THEN LET l_ccg32h = 0 END IF   #FUN-7C0028 add
                   END IF   #MOD-710063 add
                   #FUN-D60130 add------str 
                   LET l_rvu00 =NULL 
                   SELECT rvu00 INTO l_rvu00 FROM rvu_file
                    WHERE rvu01=q_tlf.tlf905
                   IF l_rvu00 ='3' THEN     
                      CALL p500_ins_ccb(q_tlf.tlf905,q_tlf.tlf62)   
                   END IF
                   #FUN-D60130 add------end
              #生產入庫
              WHEN ((q_tlf.tlf13[1,5]='asft6' AND g_sfb99!='Y') OR                    #工單入庫
                    (q_tlf.tlf13[1,5]='asrt3')) AND l_rvu08 !='SUB'   #重覆行生產入庫   
                   LET g_ccc.ccc213=g_ccc.ccc213+q_tlf.tlf10*u_sign
                   ###若工單分批入庫時，同樣的工單會重覆計算到，
                   ###所以需增加判斷，讓一張工單只會計算一次
                   IF q_tlf.tlf62 != l_tlf62 THEN
                      IF g_sma.sma104 = 'N' OR g_ima905 ='N' THEN  #MOD-750124 modify
                         LET l_ccg32a = 0
                         LET l_ccg32b = 0
                         LET l_ccg32c = 0
                         LET l_ccg32d = 0
                         LET l_ccg32e = 0
                         LET l_ccg32f = 0   #FUN-7C0028 add
                         LET l_ccg32g = 0   #FUN-7C0028 add
                         LET l_ccg32h = 0   #FUN-7C0028 add
                         #抓工單上階在製成本,本月轉出ccg32a*(-1)~ccg32h*(-1)寫入ccc22a3~ccc22h3
                         SELECT SUM(ccg32a*-1),SUM(ccg32b*-1),SUM(ccg32c*-1),
                                SUM(ccg32d*-1),SUM(ccg32e*-1)
                               ,SUM(ccg32f*-1),SUM(ccg32g*-1),SUM(ccg32h*-1)   #FUN-7C0028 add
                           INTO l_ccg32a,l_ccg32b,l_ccg32c,l_ccg32d,l_ccg32e
                               ,l_ccg32f,l_ccg32g,l_ccg32h   #FUN-7C0028 add
                           FROM ccg_file
                          WHERE ccg04=g_ima01 AND ccg02=yy AND ccg03=mm
                            AND ccg01=q_tlf.tlf62 
                            AND ccg06=type 
                            AND ccg07=g_tlfcost   #MOD-C60140 add
                         IF cl_null(l_ccg32a) THEN LET l_ccg32a = 0 END IF
                         IF cl_null(l_ccg32b) THEN LET l_ccg32b = 0 END IF
                         IF cl_null(l_ccg32c) THEN LET l_ccg32c = 0 END IF
                         IF cl_null(l_ccg32d) THEN LET l_ccg32d = 0 END IF
                         IF cl_null(l_ccg32e) THEN LET l_ccg32e = 0 END IF
                         IF cl_null(l_ccg32f) THEN LET l_ccg32f = 0 END IF   #FUN-7C0028 add
                         IF cl_null(l_ccg32g) THEN LET l_ccg32g = 0 END IF   #FUN-7C0028 add
                         IF cl_null(l_ccg32h) THEN LET l_ccg32h = 0 END IF   #FUN-7C0028 add
                      END IF
                     #end FUN-660184 add
                   END IF   #MOD-710063 add
              #雜項入庫
              WHEN q_tlf.tlf13='aimt302' OR q_tlf.tlf13='aimt312'
                OR q_tlf.tlf13='aimt306' OR q_tlf.tlf13='aimt309'  #借還料   #FUN-670009 add
                OR (q_tlf.tlf13 = 'aimt720' AND q_tlf.tlf02=57 AND q_tlf.tlf03=50)   #FUN-770032 add
                OR q_tlf.tlf13 = 'aimp701'                                           #FUN-770032 add
                #增加"廠對廠直接調撥"(aimt720),撥入部份(tlf02=57,tlf03=50),
                #    "兩階段營運中心間調撥"(aimp701)撥入部份
                #寫入雜收
 
                   LET g_ccc.ccc214=g_ccc.ccc214+q_tlf.tlf10*u_sign
              WHEN (q_tlf.tlf13='atmt260' )
                   AND u_sign=1
                   LET g_ccc.ccc214=g_ccc.ccc214+q_tlf.tlf10*u_sign  #MOD-A30220 mod ccc215->ccc214
                   CALL p500_get_atmt26(u_sign)
                   RETURNING amt,amta,amtb,amtc,amtd,amte,amtf,amtg,amth
                   LET g_ccc.ccc22a4=g_ccc.ccc22a4+(amta*u_sign)  #MOD-A30220 mod ccc22a5->ccc22a4
                   LET g_ccc.ccc22b4=g_ccc.ccc22b4+(amtb*u_sign)  #MOD-A30220 mod ccc22b5->ccc22b4
                   LET g_ccc.ccc22c4=g_ccc.ccc22c4+(amtc*u_sign)  #MOD-A30220 mod ccc22c5->ccc22c4
                   LET g_ccc.ccc22d4=g_ccc.ccc22d4+(amtd*u_sign)  #MOD-A30220 mod ccc22d5->ccc22d4
                   LET g_ccc.ccc22e4=g_ccc.ccc22e4+(amte*u_sign)  #MOD-A30220 mod ccc22e5->ccc22e4
                   LET g_ccc.ccc22f4=g_ccc.ccc22f4+(amtf*u_sign)  #MOD-A30220 mod ccc22f5->ccc22f4
                   LET g_ccc.ccc22g4=g_ccc.ccc22g4+(amtg*u_sign)  #MOD-A30220 mod ccc22g5->ccc22g4
                   LET g_ccc.ccc22h4=g_ccc.ccc22h4+(amth*u_sign)  #MOD-A30220 mod ccc22h5->ccc22h4
              WHEN (q_tlf.tlf13='atmt261' )
                   AND u_sign=-1
                   LET g_ccc.ccc214=g_ccc.ccc214+q_tlf.tlf10*u_sign  #MOD-A30220 mod ccc215->ccc214
                   CALL p500_get_atmt26(u_sign)
                   RETURNING amt,amta,amtb,amtc,amtd,amte,amtf,amtg,amth
                   LET g_ccc.ccc22a4=g_ccc.ccc22a4+(amta*u_sign)  #MOD-A30220 mod ccc22a5->ccc22a4
                   LET g_ccc.ccc22b4=g_ccc.ccc22b4+(amtb*u_sign)  #MOD-A30220 mod ccc22b5->ccc22b4
                   LET g_ccc.ccc22c4=g_ccc.ccc22c4+(amtc*u_sign)  #MOD-A30220 mod ccc22c5->ccc22c4
                   LET g_ccc.ccc22d4=g_ccc.ccc22d4+(amtd*u_sign)  #MOD-A30220 mod ccc22d5->ccc22d4
                   LET g_ccc.ccc22e4=g_ccc.ccc22e4+(amte*u_sign)  #MOD-A30220 mod ccc22e5->ccc22e4
                   LET g_ccc.ccc22f4=g_ccc.ccc22f4+(amtf*u_sign)  #MOD-A30220 mod ccc22f5->ccc22f4
                   LET g_ccc.ccc22g4=g_ccc.ccc22g4+(amtg*u_sign)  #MOD-A30220 mod ccc22g5->ccc22g4
                   LET g_ccc.ccc22h4=g_ccc.ccc22h4+(amth*u_sign)  #MOD-A30220 mod ccc22h5->ccc22h4
             #WHEN q_tlf.tlf13 = 'aimt324'     #倉庫調撥  #TQC-B30129
              WHEN (q_tlf.tlf13 = 'aimt324' OR q_tlf.tlf13 = 'aimt325' OR q_tlf.tlf13 = 'artt256')    #倉庫調撥  #TQC-B30129 #MOD-C70249 add aimt325
                   LET g_ccc.ccc215=g_ccc.ccc215+q_tlf.tlf10*u_sign
                   CALL p500_ccc44_cost()
                        RETURNING l_ccc23,l_ccc23a,l_ccc23b,
                                  l_ccc23c,l_ccc23d,l_ccc23e,
                                  l_ccc23f,l_ccc23g,l_ccc23h
                   LET g_ccc.ccc22a5=g_ccc.ccc22a5+(q_tlf.tlf10*l_ccc23a*u_sign)
                   LET g_ccc.ccc22b5=g_ccc.ccc22b5+(q_tlf.tlf10*l_ccc23b*u_sign)
                   LET g_ccc.ccc22c5=g_ccc.ccc22c5+(q_tlf.tlf10*l_ccc23c*u_sign)
                   LET g_ccc.ccc22d5=g_ccc.ccc22d5+(q_tlf.tlf10*l_ccc23d*u_sign)
                   LET g_ccc.ccc22e5=g_ccc.ccc22e5+(q_tlf.tlf10*l_ccc23e*u_sign)
                   LET g_ccc.ccc22f5=g_ccc.ccc22f5+(q_tlf.tlf10*l_ccc23f*u_sign)
                   LET g_ccc.ccc22g5=g_ccc.ccc22g5+(q_tlf.tlf10*l_ccc23g*u_sign)
                   LET g_ccc.ccc22h5=g_ccc.ccc22h5+(q_tlf.tlf10*l_ccc23h*u_sign)
              #CHI-980045(S)
              WHEN q_tlf.tlf13 = 'aomt800'    #銷退入庫
                   AND u_sign=1
                   AND g_ccz.ccz31 MATCHES '[23]'
                   
                   LET g_ccc.ccc216=g_ccc.ccc216+q_tlf.tlf10*u_sign

                   CALL p500_ccc22_cost()
                   
              #CHI-980045(E)
           END CASE
        END IF
       LET l_tlf62 = q_tlf.tlf62   #MOD-710063 add
   END FOREACH
   CLOSE p500_c2
END FUNCTION
 
FUNCTION p500_ccc22_cost()
   DEFINE l_pmm02       LIKE pmm_file.pmm02,     #No.FUN-680122 VARCHAR(3),
          l_rva00       LIKE rva_file.rva00,     #MOD-C20103 add
          l_pmm22       LIKE pmm_file.pmm22,
          l_pmm42       LIKE pmm_file.pmm42,
          l_ccc23       LIKE ccc_file.ccc23,
          l_ccc23a      LIKE ccc_file.ccc23a,
          l_ccc23b      LIKE ccc_file.ccc23b,
          l_ccc23c      LIKE ccc_file.ccc23c,
          l_ccc23d      LIKE ccc_file.ccc23d,
          l_ccc23e      LIKE ccc_file.ccc23e,
          l_ccc23f      LIKE ccc_file.ccc23f,    #FUN-7C0028 add
          l_ccc23g      LIKE ccc_file.ccc23g,    #FUN-7C0028 add
          l_ccc23h      LIKE ccc_file.ccc23h,    #FUN-7C0028 add
          l_rva06       LIKE rva_file.rva06,
          l_exrate1,l_exrate2     LIKE pmm_file.pmm42,
          l_c23a,l_c23b,l_c23c    LIKE ccc_file.ccc23,
          x_flag        LIKE type_file.chr1,            #No.FUN-680122 VARCHAR(1)
          l_rvv         RECORD LIKE rvv_file.*,
          l_apa44       LIKE apa_file.apa44,
          l_apb29       LIKE apb_file.apb29,      #No.MOD-A80020
           amt_1,amt_2,amtx   LIKE tlf_file.tlf21,      #No.FUN-680122DEC(20,6),                      #MOD-4C0005
          l_qty         LIKE tlf_file.tlf10
   DEFINE l_amt,l_amt1,l_amt2    LIKE tlf_file.tlf21    #No.A102
   DEFINE l_amt3,l_amt4,l_amt5   LIKE tlf_file.tlf21    #No.A102
   DEFINE l_amt6,l_amt7,l_amt8   LIKE tlf_file.tlf21    #FUN-7C0028 add
   DEFINE l_apb12                LIKE apb_file.apb12    #No.A102
   DEFINE l_apb09                LIKE apb_file.apb09    #No.A102
   DEFINE l_tlf907               LIKE tlf_file.tlf907   #FUN-7C0083 add
   DEFINE l_ccz32_flag           LIKE ccz_file.ccz32      #CHI-980045
   DEFINE l_ogb01                LIKE ogb_file.ogb01      #CHI-980045
   DEFINE l_ogb03                LIKE ogb_file.ogb03      #CHI-980045
   DEFINE lo_tlf06               LIKE tlf_file.tlf06      #CHI-980045

   IF q_tlf.tlf13 MATCHES 'asf*' THEN RETURN END IF
   #工單入庫成本應由WIP轉入,故加工費於 wip_2_22() 計算時歸入投入成本,再轉入庫
   IF q_tlf.tlf13 matches 'apmt107*' THEN
     #TQC-C60173 (S) 委外退库的tlf036记录的是收货单号,改为直接从入库单抓
     # LET l_pmm02=NULL
     # SELECT pmm02 INTO l_pmm02 FROM pmm_file WHERE pmm01=q_tlf.tlf036
     #         AND pmm18 <> 'X'
     # IF l_pmm02='SUB' THEN RETURN END IF               #-->委外退庫亦由WIP轉出
       LET l_pmm02=NULL
       SELECT rvu08 INTO l_pmm02 FROM rvu_file WHERE rvu01=q_tlf.tlf905
       IF l_pmm02='SUB' THEN RETURN END IF               #-->委外退庫亦由WIP轉出
     #TQC-C60173 Mark(E) 
   END IF   
   LET amt=0 LET amta = 0 LET amtb = 0 LET amtc = 0 LET amtd = 0 LET amte = 0
   LET amtf=0 LET amtg = 0 LET amth = 0                                        #MOD-990056
   IF g_ccz.ccz03='2' THEN              # 實際成本制
      CASE WHEN q_tlf.tlf13 MATCHES 'aimt30*'                   #雜項入zzz
                OR q_tlf.tlf13 MATCHES 'aimt31*'                #no.5150
                #1.人工維護 2.當月(包含開帳) 3.上月單價
                CALL p500_ccc44_cost() RETURNING l_ccc23,l_ccc23a,l_ccc23b,
                                                 l_ccc23c,l_ccc23d,l_ccc23e
                                                ,l_ccc23f,l_ccc23g,l_ccc23h   #FUN-7C0028 add
                #因為後面會針對amt~amte等值*u_sign,所以將本段的*u_sign拿掉,以免重複乘
                LET amt=l_ccc23 * q_tlf.tlf10
                LET amta=l_ccc23a * q_tlf.tlf10
                LET amtb=l_ccc23b * q_tlf.tlf10
                LET amtc=l_ccc23c * q_tlf.tlf10
                LET amtd=l_ccc23d * q_tlf.tlf10
                LET amte=l_ccc23e * q_tlf.tlf10
                LET amtf=l_ccc23f * q_tlf.tlf10   #FUN-7C0028 add
                LET amtg=l_ccc23g * q_tlf.tlf10   #FUN-7C0028 add
                LET amth=l_ccc23h * q_tlf.tlf10   #FUN-7C0028 add
                LET g_ccc.ccc44 = g_ccc.ccc44 + amt*u_sign
#MOD-B30205 --------------------------Begin----------------------------------
               #LET g_ccc.ccc22a4=g_ccc.ccc22a4+amta*u_sign   #FUN-660184 add
                LET g_ccc.ccc22a4=g_ccc.ccc22a4+amta*u_sign
                LET g_ccc.ccc22b4=g_ccc.ccc22b4+amtb*u_sign
                LET g_ccc.ccc22c4=g_ccc.ccc22c4+amtc*u_sign
                LET g_ccc.ccc22d4=g_ccc.ccc22d4+amtd*u_sign
                LET g_ccc.ccc22e4=g_ccc.ccc22e4+amte*u_sign
                LET g_ccc.ccc22f4=g_ccc.ccc22f4+amtf*u_sign
                LET g_ccc.ccc22g4=g_ccc.ccc22g4+amtg*u_sign
                LET g_ccc.ccc22h4=g_ccc.ccc22h4+amth*u_sign
#MOD-B30205 --------------------------End------------------------------------
           WHEN q_tlf.tlf13 = 'aimt720' OR #調撥入zzz
                q_tlf.tlf13 = 'aimp701'
                #抓調撥單價
                CALL p500_ccc44_cost() RETURNING l_ccc23,l_ccc23a,l_ccc23b,
                                                 l_ccc23c,l_ccc23d,l_ccc23e
                                                ,l_ccc23f,l_ccc23g,l_ccc23h   #FUN-7C0028 add
                LET amt  = l_ccc23 * q_tlf.tlf10    #FUN-770032 mod g_ccc.ccc->l_ccc 
                LET amta = l_ccc23a * q_tlf.tlf10   #FUN-770032 mod g_ccc.ccc->l_ccc
                LET amtb = l_ccc23b * q_tlf.tlf10   #FUN-770032 mod g_ccc.ccc->l_ccc
                LET amtc = l_ccc23c * q_tlf.tlf10   #FUN-770032 mod g_ccc.ccc->l_ccc
                LET amtd = l_ccc23d * q_tlf.tlf10   #FUN-770032 mod g_ccc.ccc->l_ccc
                LET amte = l_ccc23e * q_tlf.tlf10   #No.MOD-990062 add 
                LET amtf = l_ccc23f * q_tlf.tlf10   #FUN-7C0028 add
                LET amtg = l_ccc23g * q_tlf.tlf10   #FUN-7C0028 add
                LET amth = l_ccc23h * q_tlf.tlf10   #FUN-7C0028 add
                LET g_ccc.ccc44 = g_ccc.ccc44 + amt*u_sign   #FUN-770032 add
#MOD-B30205 ------------------------------Begin--------------------------------
               #LET g_ccc.ccc22a4=g_ccc.ccc22a4+amta*u_sign  #FUN-770032 add
                LET g_ccc.ccc22a4=g_ccc.ccc22a4+amta*u_sign
                LET g_ccc.ccc22b4=g_ccc.ccc22b4+amtb*u_sign
                LET g_ccc.ccc22c4=g_ccc.ccc22c4+amtc*u_sign
                LET g_ccc.ccc22d4=g_ccc.ccc22d4+amtd*u_sign
                LET g_ccc.ccc22e4=g_ccc.ccc22e4+amte*u_sign
                LET g_ccc.ccc22f4=g_ccc.ccc22f4+amtf*u_sign
                LET g_ccc.ccc22g4=g_ccc.ccc22g4+amtg*u_sign
                LET g_ccc.ccc22h4=g_ccc.ccc22h4+amth*u_sign
#MOD-B30205 ------------------------------End----------------------------------
           WHEN (q_tlf.tlf13 = 'atmt260' )
                AND u_sign=1
                SELECT tlf907 INTO l_tlf907 FROM tlf_file
                 WHERE tlf01=q_tlf.tlf01 AND tlf13=q_tlf.tlf13
                   AND tlf06=q_tlf.tlf06
                   AND tlf905=q_tlf.tlf905 AND tlf906=q_tlf.tlf906
                CALL p500_get_atmt26(l_tlf907)
                RETURNING amt,amta,amtb,amtc,amtd,amte,amtf,amtg,amth
                LET g_ccc.ccc44 = g_ccc.ccc44 + amt*u_sign
           WHEN (q_tlf.tlf13 = 'atmt261' )
                AND u_sign=-1
                SELECT tlf907 INTO l_tlf907 FROM tlf_file
                 WHERE tlf01=q_tlf.tlf01 AND tlf13=q_tlf.tlf13
                   AND tlf06=q_tlf.tlf06
                   AND tlf905=q_tlf.tlf905 AND tlf906=q_tlf.tlf906
                CALL p500_get_atmt26(l_tlf907)
                RETURNING amt,amta,amtb,amtc,amtd,amte,amtf,amtg,amth
                LET g_ccc.ccc44 = g_ccc.ccc44 + amt*u_sign
          #WHEN q_tlf.tlf13 = 'aimt324'     #倉庫調撥  #TQC-B30129
           WHEN (q_tlf.tlf13 = 'aimt324' OR q_tlf.tlf13 = 'aimt325' OR q_tlf.tlf13 = 'artt256')     #倉庫調撥  #TQC-B30129  #MOD-C70249 add aimt325
                CALL p500_ccc44_cost()
                     RETURNING l_ccc23,l_ccc23a,l_ccc23b,
                               l_ccc23c,l_ccc23d,l_ccc23e,
                               l_ccc23f,l_ccc23g,l_ccc23h
                LET amt=l_ccc23 * q_tlf.tlf10
                LET amta=l_ccc23a * q_tlf.tlf10
                LET amtb=l_ccc23b * q_tlf.tlf10
                LET amtc=l_ccc23c * q_tlf.tlf10
                LET amtd=l_ccc23d * q_tlf.tlf10
                LET amte=l_ccc23e * q_tlf.tlf10
                LET amtf=l_ccc23f * q_tlf.tlf10   #FUN-7C0028 add
                LET amtg=l_ccc23g * q_tlf.tlf10   #FUN-7C0028 add
                LET amth=l_ccc23h * q_tlf.tlf10   #FUN-7C0028 add
                LET g_ccc.ccc44 = g_ccc.ccc44 + amt*u_sign
           #CHI-980045(S)
           WHEN q_tlf.tlf13 = 'aomt800'     #銷退入庫
                AND u_sign= 1
                AND g_ccz.ccz31 MATCHES '[23]'

                LET l_ccz32_flag = FALSE
                IF g_ccz.ccz32 ='1' THEN
                   LET l_ogb01 =NULL
                   LET l_ogb03 =NULL
                   SELECT ohb31,ohb32 INTO l_ogb01,l_ogb03
                                      FROM ohb_file
                                     WHERE ohb01 = q_tlf.tlf026
                                       AND ohb03 = q_tlf.tlf027
                   IF NOT cl_null(l_ogb01) AND NOT cl_null(l_ogb03) THEN
                      SELECT tlf06,tlf221/tlf10/tlf60,tlf222/tlf10/tlf60,     #TQC-A30126
                                   tlf2231/tlf10/tlf60,tlf2232/tlf10/tlf60,   #TQC-A30126
                                   tlf224/tlf10/tlf60,tlf2241/tlf10/tlf60,    #TQC-A30126
                                   tlf2242/tlf10/tlf60,tlf2243/tlf10/tlf60    #TQC-A30126
                        INTO lo_tlf06,l_ccc23a,l_ccc23b,l_ccc23c,l_ccc23d,
                             l_ccc23e,l_ccc23f,l_ccc23g,l_ccc23h
                        FROM tlf_file
                       WHERE tlf026 = l_ogb01
                         AND tlf027 = l_ogb03
                         AND (tlf13  = 'axmt620' OR tlf13  = 'axmt650' OR tlf13  = 'axmt820' OR tlf13  = 'axmt821')   #No.MOD-D50062 add axmt650,axmt820,axmt821
                         AND tlf10 <> 0  #TQC-A30126
                      #判斷是否為當月出貨當月銷退,如果是的話只能抓上個月成本,並以訊息提示
                      IF (lo_tlf06 >= g_bdate) AND (lo_tlf06 <= g_edate) THEN
                         LET l_ccz32_flag = FALSE
                         LET g_msg = cl_getmsg('agl-422',g_lang),l_ogb01,
                                     ' ',cl_getmsg('axc-526',g_lang)
                        #FUN-A50075--mod--str-- ccy_file拿掉plant以及Legal
                        #INSERT INTO ccy_file (ccy01,ccy02,ccy03,ccy04,ccyplant,ccylegal)
                        #              VALUES (TODAY,g_time,g_user,g_msg,g_plant,g_legal)
                         INSERT INTO ccy_file (ccy01,ccy02,ccy03,ccy04)
                                      #VALUES (TODAY,g_time,g_user,g_msg) #MOD-C30891 mark
                                       VALUES (TODAY,t_time,g_user,g_msg) #MOD-C30891
                        #FUN-A50075--mod--end
                      ELSE
                         LET l_ccz32_flag = TRUE
                      END IF
                   END IF
                END IF
                
                #抓上個月成本
                IF NOT l_ccz32_flag THEN
                   SELECT ccc23a,ccc23b,ccc23c,ccc23d,ccc23e,ccc23f,
                          ccc23g,ccc23h
                     INTO l_ccc23a,l_ccc23b,l_ccc23c,l_ccc23d,l_ccc23e,l_ccc23f,
                          l_ccc23g,l_ccc23h
                     FROM ccc_file
                    WHERE ccc01 = g_ima01
                      AND ccc02 = last_yy
                      AND ccc03 = last_mm
                      AND ccc07 = type
                      AND ccc08 = g_tlfcost
                   IF SQLCA.sqlcode THEN
                      LET l_ccz32_flag = FALSE
                   ELSE
                      LET l_ccz32_flag = TRUE
                   END IF   
                END IF
                #No.MOD-C10137  --Begin 
                IF cl_null(l_ccc23a) THEN LET l_ccc23a = 0 END IF
                IF cl_null(l_ccc23b) THEN LET l_ccc23b = 0 END IF
                IF cl_null(l_ccc23c) THEN LET l_ccc23c = 0 END IF
                IF cl_null(l_ccc23d) THEN LET l_ccc23d = 0 END IF
                IF cl_null(l_ccc23e) THEN LET l_ccc23e = 0 END IF
                IF cl_null(l_ccc23f) THEN LET l_ccc23f = 0 END IF
                IF cl_null(l_ccc23g) THEN LET l_ccc23g = 0 END IF
                IF cl_null(l_ccc23h) THEN LET l_ccc23h = 0 END IF
                IF l_ccc23a = 0 AND l_ccc23b = 0 AND l_ccc23c = 0 AND 
                   l_ccc23d = 0 AND l_ccc23e = 0 AND l_ccc23f = 0 AND 
                   l_ccc23g = 0 AND l_ccc23h = 0 THEN
                   LET l_ccz32_flag = FALSE 
                END IF
                #No.MOD-C10137  --End 
                
                #上個月成本抓不到則抓上期開帳成本
                IF NOT l_ccz32_flag THEN
                   SELECT cca23a,cca23b,cca23c,cca23d,cca23e,cca23f,
                          cca23g,cca23h
                     INTO l_ccc23a,l_ccc23b,l_ccc23c,l_ccc23d,l_ccc23e,l_ccc23f,
                          l_ccc23g,l_ccc23h
                     FROM cca_file
                    WHERE cca01 = g_ima01
                      AND cca02 = last_yy
                      AND cca03 = last_mm
                      AND cca06 = type
                      AND cca07 = g_tlfcost
                   IF SQLCA.sqlcode THEN
                      LET l_ccz32_flag = FALSE
                   ELSE
                      LET l_ccz32_flag = TRUE
                   END IF   
                END IF
                
                LET amta = q_tlf.tlf10*l_ccc23a*u_sign
                LET amtb = q_tlf.tlf10*l_ccc23b*u_sign
                LET amtc = q_tlf.tlf10*l_ccc23c*u_sign
                LET amtd = q_tlf.tlf10*l_ccc23d*u_sign
                LET amte = q_tlf.tlf10*l_ccc23e*u_sign
                LET amtf = q_tlf.tlf10*l_ccc23f*u_sign
                LET amtg = q_tlf.tlf10*l_ccc23g*u_sign
                LET amth = q_tlf.tlf10*l_ccc23h*u_sign
                LET amt  = amta+amtb+amtc+amtd+amte+amtf+amtg+amth
                
                LET g_ccc.ccc22a6 = g_ccc.ccc22a6+(amta)
                LET g_ccc.ccc22b6 = g_ccc.ccc22b6+(amtb)
                LET g_ccc.ccc22c6 = g_ccc.ccc22c6+(amtc)
                LET g_ccc.ccc22d6 = g_ccc.ccc22d6+(amtd)
                LET g_ccc.ccc22e6 = g_ccc.ccc22e6+(amte)
                LET g_ccc.ccc22f6 = g_ccc.ccc22f6+(amtf)
                LET g_ccc.ccc22g6 = g_ccc.ccc22g6+(amtg)
                LET g_ccc.ccc22h6 = g_ccc.ccc22h6+(amth)
           #CHI-980045(E)

           OTHERWISE
                #-->發票請款立帳
                LET l_apa44 = ''
                LET l_apb29 = ''   #No.MOD-A80020
                LET amt_1 = 0 LET amt_2 = 0 LET x_flag = 'N'
                DECLARE apa_cursor CURSOR FOR
#配合成本分攤aapt900 apb10->apb101
                 SELECT apa44,apb29,SUM(ABS(apb101))    #No.MOD-A80020
                  FROM apb_file,apa_file
                 WHERE apb21=xxx1 AND apb22=xxx2 AND apb01=apa01
                   AND (apa00 = '11' OR apa00='16') AND apa75 != 'Y'   #CHI-7B0022 mark
                   AND apa42 = 'N'
                   AND apa02 BETWEEN g_bdate AND g_edate
                   AND apb34 <> 'Y'             #No.TQC-7C0126
                  GROUP BY apa44,apb29     #No.MOD-A80020
                LET amtx = 0
                FOREACH apa_cursor INTO l_apa44,l_apb29,amtx   #No.MOD-A80020
#No.MOD-A80020 --begin
                   IF l_apb29 = '3' THEN
                      LET amtx = amtx * -1
                   END IF
#No.MOD-A80020 --end
                   LET amt_1 = amt_1 + amtx  LET x_flag = 'Y'
                END FOREACH
                IF amt_1 IS NULL THEN LET amt_1 = 0 END IF
                #-->扣除折讓部份(退貨)
                IF g_sma.sma43 = '1' THEN
                   DECLARE apa_cursor2 CURSOR FOR
                    SELECT apb12,SUM(ABS(apb09))  #No.TQC-7C0126
                      FROM apb_file,apa_file
                     WHERE apb21=xxx1 AND apb22=xxx2 AND apb01=apa01
                       AND (apa00 = '21' OR apa00='26') AND apa75 != 'Y'
                       AND (apa58 = '2' OR apa58 = '3'  OR apa58 IS NULL)       #No.TQC-CC0145
                       AND apa42 = 'N'
                       AND apa02 BETWEEN g_bdate AND g_edate
                       AND apb34 <> 'Y'             #No.TQC-7C0126
                     GROUP BY apb12
                   FOREACH apa_cursor2 INTO l_apb12,l_apb09
                      CALL p500_upd_cxa09(l_apb12,l_apb09,1)     #倉退
                           RETURNING amtx,l_amt1,l_amt2,l_amt3,l_amt4,l_amt5
                                         ,l_amt6,l_amt7,l_amt8   #FUN-7C0028 add
                      LET amt_2 = amt_2 + amtx LET x_flag = 'Y'
                      LET l_apa44 = 'FIFO'
                   END FOREACH
                ELSE
                   DECLARE apa_cursor1 CURSOR FOR
#配合成本分攤aapt900 apb10->apb101
                    SELECT apa44,SUM(ABS(apb101))  #No.TQC-7C0126
                     FROM apb_file,apa_file
                    WHERE apb21=xxx1 AND apb22=xxx2 AND apb01=apa01
                      AND (apa00 = '21' OR apa00='26') AND apa75 != 'Y'
                      AND (apa58 = '2' OR apa58 = '3'  OR apa58 IS NULL)       #No.TQC-CC0145
                      AND apa42 = 'N'
                      AND apa02 BETWEEN g_bdate AND g_edate
                      AND apb34 <> 'Y'             #No.TQC-7C0126
                     GROUP BY apa44    #No.MOD-940063
                   LET amtx = 0
                   FOREACH apa_cursor1 INTO l_apa44,amtx
                       LET amt_2 = amt_2 + amtx LET x_flag = 'Y'
                   END FOREACH
                END IF
                #end
                IF amt_2 IS NULL THEN LET amt_2 = 0 END IF
                LET amt = amt_1-amt_2
                #-->不決定正負數
                IF amt < 0 THEN LET amt = amt * -1 END IF
                IF x_flag = 'N' THEN
                   DECLARE ale_cursor CURSOR FOR
                   SELECT alk72,SUM(ale09)  #INTO amt
                     FROM ale_file ,alk_file
                    WHERE ale16=xxx1 AND ale17=xxx2 AND ale01=alk01
                      AND alkfirm <> 'X'   #CHI-C80041
                    GROUP BY  alk72 #No.MOD-940063
                   LET amtx = 0
                   FOREACH ale_cursor INTO l_apa44,amtx
                      LET amt = amt + amtx LET x_flag = 'Y'
                   END FOREACH
                   #供月中暫估成本使用
                   IF x_flag = 'N' THEN
                      SELECT * INTO l_rvv.* FROM rvv_file
                       WHERE rvv01=xxx1 AND rvv02=xxx2
                         AND rvv25 != 'Y'
                      IF STATUS = 0 THEN
                         #直接取 P/O 上的匯率
                         SELECT rva00 INTO l_rva00 FROM rva_file WHERE rva01=l_rvv.rvv04   #MOD-C20103 add
                         IF l_rva00 <> '2'THEN                                             #MOD-C20103 add
                            SELECT pmm22,rva06,pmm42 INTO l_pmm22,l_rva06,l_pmm42
                              FROM rvb_file,pmm_file,rva_file
                             WHERE rvb01=l_rvv.rvv04 AND rvb02=l_rvv.rvv05
                               AND pmm01=rvb04 AND rva01 = rvb01
                               AND rvaconf <> 'X' AND pmm18 <> 'X'
                            IF STATUS <> 0 THEN
                               LET l_pmm22=' '
                               LET l_pmm42= 1
                            END IF
                         #MOD-C20103 str  add------
                         ELSE
                            SELECT rva113,rva06,rva114 INTO l_pmm22,l_rva06,l_pmm42
                              FROM rvb_file,rva_file
                             WHERE rvb01=l_rvv.rvv04 AND rvb02=l_rvv.rvv05
                               AND rva01 = rvb01 AND rvaconf <> 'X'
                            IF STATUS <> 0 THEN
                               LET l_pmm22=' '
                               LET l_pmm42= 1
                            END IF
                         END IF
                         #MOD-C20103 end  add------
                         IF l_pmm42 IS NULL THEN LET l_pmm42=1 END IF
                         LET amt=l_rvv.rvv39*l_pmm42
                      END IF
                      IF amt IS NULL THEN LET amt=0 END IF
                   END IF
                END IF
                IF (l_apa44 IS NULL OR l_apa44 = ' ') THEN
                   LET l_apa44 = 'UNAP'
                END IF
                #進料退出, 調整金額
                LET amta = amt
      END CASE
      IF amt IS NULL THEN LET amt=0 END IF
      IF amta IS NULL THEN LET amta=0 END IF
      IF amtb IS NULL THEN LET amtb=0 END IF
      IF amtc IS NULL THEN LET amtc=0 END IF
      IF amtd IS NULL THEN LET amtd=0 END IF
      IF amte IS NULL THEN LET amte=0 END IF
      IF amtf IS NULL THEN LET amtf=0 END IF   #FUN-7C0028 add
      IF amtg IS NULL THEN LET amtg=0 END IF   #FUN-7C0028 add
      IF amth IS NULL THEN LET amth=0 END IF   #FUN-7C0028 add
      LET g_ccc.ccc22 =g_ccc.ccc22 +amt*u_sign
      LET g_ccc.ccc22a=g_ccc.ccc22a+amta*u_sign
      LET g_ccc.ccc22b=g_ccc.ccc22b+amtb*u_sign
      LET g_ccc.ccc22c=g_ccc.ccc22c+amtc*u_sign
      LET g_ccc.ccc22d=g_ccc.ccc22d+amtd*u_sign
      LET g_ccc.ccc22e=g_ccc.ccc22e+amte*u_sign
      LET g_ccc.ccc22f=g_ccc.ccc22f+amtf*u_sign   #FUN-7C0028 add
      LET g_ccc.ccc22g=g_ccc.ccc22g+amtg*u_sign   #FUN-7C0028 add
      LET g_ccc.ccc22h=g_ccc.ccc22h+amth*u_sign   #FUN-7C0028 add
   END IF
   #--->更新
   LET t_time = TIME
  #LET g_time=t_time #MOD-C30891 mark
 
#雜收不update tlf_file 由axct500 認定
   IF q_tlf.tlf13 != 'aimt302' and q_tlf.tlf13 != 'aimt312' THEN
      LET amt=cl_digcut(amt ,g_ccz.ccz26)    #FUN-750002
      LET amta=cl_digcut(amta,g_ccz.ccz26)   #FUN-750002
      LET amtb=cl_digcut(amtb,g_ccz.ccz26)   #FUN-750002
      LET amtc=cl_digcut(amtc,g_ccz.ccz26)   #FUN-750002
      LET amtd=cl_digcut(amtd,g_ccz.ccz26)   #FUN-750002
      LET amte=cl_digcut(amte,g_ccz.ccz26)   #FUN-750002
      LET amtf=cl_digcut(amtf,g_ccz.ccz26)   #FUN-7C0028 add
      LET amtg=cl_digcut(amtg,g_ccz.ccz26)   #FUN-7C0028 add
      LET amth=cl_digcut(amth,g_ccz.ccz26)   #FUN-7C0028 add
      UPDATE tlf_file SET tlf21x=amt,    #CHI-910041 tlf21-->tlf21x
                          tlf221x=amta,  #CHI-910041
                          tlf222x=amtb,  #CHI-910041
                          tlf2231x=amtc, #CHI-910041
                          tlf2232x=amtd, #CHI-910041
                          tlf224x=amte,  #CHI-910041
                          tlf2241x=amtf,   #FUN-7C0028 add #CHI-910041
                          tlf2242x=amtg,   #FUN-7C0028 add #CHI-910041
                          tlf2243x=amth,   #FUN-7C0028 add #CHI-910041
                          tlf211x=TODAY,#CHI-910041
                         #tlf212x=g_time,#CHI-910041 #MOD-C30891 mark
                          tlf212x=t_time,#MOD-C30891 
                          tlf65x=l_apa44 #CHI-910041
             WHERE rowid=q_tlf_rowid    #zzz
      IF STATUS THEN 
         CALL cl_err3("upd","tlf_file","","",STATUS,"","upd tlf21x:",1)   #No.FUN-660127   #CHI-910041 tlf21-->tlf21x
      END IF
    IF type = g_ccz.ccz28 THEN
      UPDATE tlf_file SET tlf21=amt, 
                          tlf221=amta,
                          tlf222=amtb,
                          tlf2231=amtc,
                          tlf2232=amtd,
                          tlf224=amte,
                          tlf2241=amtf,
                          tlf2242=amtg,
                          tlf2243=amth,
                          tlf211=TODAY,
                         #tlf212=g_time, #MOD-C30891 mark
                          tlf212=t_time, #MOD-C30891 
                          tlf65=l_apa44 
             WHERE rowid=q_tlf_rowid
        IF SQLCA.sqlerrd[3]=0 THEN
           CALL cl_err3("upd","tlf_file","","",'100',"","upd tlf21:",1)
        END IF
     END IF
 
      #新增tlfc_file記錄依 "成本計算類別"  的異動成本
      CALL p500_ins_tlfc(q_tlf_rowid)   #FUN-7C0028 add
   END IF
   IF g_sma.sma43 = '1' AND q_tlf.tlf13 NOT MATCHES 'apmt107*' THEN
      IF cl_null(amtf) THEN LET amtf = 0 END IF
      IF cl_null(amtg) THEN LET amtg = 0 END IF
      IF cl_null(amth) THEN LET amth = 0 END IF
      UPDATE cxa_file SET cxa09  = amt,
                          cxa091 = amta,
                          cxa092 = amtb,
                          cxa093 = amtc,
                          cxa094 = amtd,
                          cxa095 = amte,
                          cxa096 = amtf,   #FUN-7C0028 add
                          cxa097 = amtg,   #FUN-7C0028 add
                          cxa098 = amth    #FUN-7C0028 add
       WHERE cxa01 = q_tlf.tlf01
         AND cxa04 = q_tlf.tlf06  AND cxa05 = q_tlf.tlf08
         AND cxa06 = q_tlf.tlf905 AND cxa07 = q_tlf.tlf906
         AND cxa010= type         AND cxa011= q_tlf.tlfcost   #FUN-7C0028 add
      IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("upd","cxa_file",q_tlf.tlf01,q_tlf.tlf06,STATUS,"","upd cxa06",0)   #No.FUN-660127
               LET g_success = 'N'
      END IF
   END IF
   LET l_apa44 = '' LET x_flag = ''
END FUNCTION
 
FUNCTION p500_ccc44_cost() #雜入成本
   DEFINE l_qty LIKE tlf_file.tlf10,
          l_inb13  LIKE inb_file.inb13,
   #FUN-AB0089--add--begin
          l_inb132 LIKE inb_file.inb132,
          l_inb133 LIKE inb_file.inb133,
          l_inb134 LIKE inb_file.inb134,
          l_inb135 LIKE inb_file.inb135,
          l_inb136 LIKE inb_file.inb136,
          l_inb137 LIKE inb_file.inb137,
          l_inb138 LIKE inb_file.inb138,
   #FUN-AB0089--add--end
          l_inb04  LIKE inb_file.inb04,    #FUN-630019 add
          l_inb08  LIKE inb_file.inb08,    #FUN-630019 add
          l_ima25  LIKE ima_file.ima25,    #FUN-630019 add
          l_sw     LIKE type_file.chr1,    #No.FUN-680122CHAR(1),               #FUN-630019 add
         #l_fac    LIKE type_file.num20_6, #No:FUN-680122DEC(16,8),             #FUN-630019 add #MOD-B50048 mark
          l_fac    LIKE inb_file.inb08_fac,      #MOD-B50048 add 
          l_imp09  LIKE imp_file.imp09,    #FUN-670009 add
          l_cxk04  LIKE cxk_file.cxk04,    #FUN-770032 add
          l_imn091 LIKE imn_file.imn091,   #FUN-7C0028 add
          l_ccc23  LIKE ccc_file.ccc23,
          l_ccc23a LIKE ccc_file.ccc23a,
          l_ccc23b LIKE ccc_file.ccc23b,
          l_ccc23c LIKE ccc_file.ccc23c,
          l_ccc23d LIKE ccc_file.ccc23d,
          l_ccc23e LIKE ccc_file.ccc23e,
          l_ccc23f LIKE ccc_file.ccc23f,   #FUN-7C0028 add
          l_ccc23g LIKE ccc_file.ccc23g,   #FUN-7C0028 add
          l_ccc23h LIKE ccc_file.ccc23h    #FUN-7C0028 add
 
   LET l_qty = g_ccc.ccc11+g_ccc.ccc21
   #--->(2)先取本月單價
#預防雜收相關資料當月某料件正負相抵時,使得ccc21或ccc11=0,但tlf10不為0時
#取不到對應單價的狀況
   IF q_tlf.tlf13 MATCHES 'aimt30*'             
      OR q_tlf.tlf13 MATCHES 'aimt31*'  THEN
      IF q_tlf.tlf13 !='aimt306' AND q_tlf.tlf13 != 'aimt309' THEN    #No:MOD-B10009 add
         IF g_ccc.ccc11 = 0 AND g_ccc.ccc21 = 0 AND q_tlf.tlf10 = 0 THEN   #MOD-780053 modify
            LET l_ccc23 =0 LET l_ccc23a=0 LET l_ccc23b=0
            LET l_ccc23c=0 LET l_ccc23d=0 LET l_ccc23e=0
            LET l_ccc23f=0 LET l_ccc23g=0 LET l_ccc23h=0   #FUN-7C0028 add
         ELSE
            #雜入成本(抓axct500雜項單價) 
       #FUN-AB0089--mark--begin
       #    SELECT inb13,inb04,inb08 INTO l_inb13,l_inb04,l_inb08   #FUN-630019 add inb04,inb08 
       #      FROM inb_file
       #     WHERE inb01 = xxx1 AND inb03 = xxx2
       #    IF cl_null(l_inb13) THEN LET l_inb13 = 0 END IF
       #    IF cl_null(l_inb04) THEN LET l_inb04 = ' ' END IF
       #    IF cl_null(l_inb08) THEN LET l_inb08 = ' ' END IF
       #    SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01=l_inb04
       #    IF STATUS THEN LET l_ima25 = ' '  END IF
       #    CALL s_umfchk(l_inb04,l_inb08,l_ima25) RETURNING l_sw,l_fac
       #    IF l_sw THEN
       #       LET l_inb13 = 0
       #    ELSE
       #       LET l_inb13 = l_inb13 / l_fac
       #    END IF
       #    LET l_ccc23a=l_inb13 LET l_ccc23b=0
       #    LET l_ccc23c=0 LET l_ccc23d=0 LET l_ccc23e=0
       #    LET l_ccc23f=0 LET l_ccc23g=0 LET l_ccc23h=0   #FUN-7C0028 add
       #    LET l_ccc23=l_ccc23a+l_ccc23b+l_ccc23c+l_ccc23d+l_ccc23e
       #                        +l_ccc23f+l_ccc23g+l_ccc23h   #FUN-7C0028 add
      #FUN-AB0089--mark--end
      #FUN-AB0089--add--begin
           SELECT inb13,inb132,inb133,inb134,inb135,inb136,inb137,inb138,inb04,inb08
              INTO l_inb13,l_inb132,l_inb133,l_inb134,l_inb135,l_inb136,l_inb137,l_inb138,l_inb04,l_inb08
              FROM inb_file
              WHERE inb01 = xxx1 AND inb03 = xxx2
           IF cl_null(l_inb13 ) THEN LET l_inb13  = 0 END IF
           IF cl_null(l_inb132) THEN LET l_inb132 = 0 END IF
           IF cl_null(l_inb133) THEN LET l_inb133 = 0 END IF
           IF cl_null(l_inb134) THEN LET l_inb134 = 0 END IF
           IF cl_null(l_inb135) THEN LET l_inb135 = 0 END IF
           IF cl_null(l_inb136) THEN LET l_inb136 = 0 END IF
           IF cl_null(l_inb137) THEN LET l_inb137 = 0 END IF
           IF cl_null(l_inb138) THEN LET l_inb138 = 0 END IF
           IF cl_null(l_inb04) THEN LET l_inb04 = ' ' END IF
           IF cl_null(l_inb08) THEN LET l_inb08 = ' ' END IF
           SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01=l_inb04
           IF STATUS THEN LET l_ima25 = ' '  END IF
           CALL s_umfchk(l_inb04,l_inb08,l_ima25) RETURNING l_sw,l_fac
           IF l_sw THEN
              LET l_inb13  = 0
              LET l_inb132 = 0
              LET l_inb133 = 0
              LET l_inb134 = 0
              LET l_inb135 = 0
              LET l_inb136 = 0
              LET l_inb137 = 0
              LET l_inb138 = 0
           ELSE
              LET l_inb13  = l_inb13  / l_fac
              LET l_inb132 = l_inb132 / l_fac
              LET l_inb133 = l_inb133 / l_fac
              LET l_inb134 = l_inb134 / l_fac
              LET l_inb135 = l_inb135 / l_fac
              LET l_inb136 = l_inb136 / l_fac
              LET l_inb137 = l_inb137 / l_fac
              LET l_inb138 = l_inb138 / l_fac
           END IF
           LET l_ccc23a=l_inb13
           LET l_ccc23b = l_inb132
           LET l_ccc23c = l_inb133
           LET l_ccc23d = l_inb134
           LET l_ccc23e = l_inb135
           LET l_ccc23f = l_inb136
           LET l_ccc23g = l_inb137
           LET l_ccc23h = l_inb138
           LET l_ccc23=l_ccc23a+l_ccc23b+l_ccc23c+l_ccc23d+l_ccc23e +l_ccc23f+l_ccc23g+l_ccc23h


      #FUN-AB0089--add--end   
            #將訊息從下面搬上來
            IF STATUS OR cl_null(l_ccc23) OR l_ccc23 = 0 THEN
              #LET g_msg="料號:",g_ccc.ccc01 CLIPPED,' ',
              #          "無雜收單價請輸入雜收單價:(axct500)"
               CALL cl_getmsg('axc-521',g_lang) RETURNING g_msg1
               CALL cl_getmsg('axc-503',g_lang) RETURNING g_msg2
               LET g_msg=g_msg1 CLIPPED,g_ccc.ccc01 CLIPPED,' ',
                         g_msg2 CLIPPED,":(axct500)"   #MOD-840402 add ":(axct500)"
         
               LET t_time = TIME
              #LET g_time=t_time #MOD-C30891 mark
              #FUN-A50075--MOD--STR-- ccy_file拿掉legal以及plant
              #INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04,ccyplant,ccylegal)   #No.MOD-470041 #FUN-980009 add ccyplant,ccylegal
              #              VALUES(TODAY,g_time,g_user,g_msg,g_plant,g_legal) #FUN-980009 add g_plant,g_legal
               INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04)
                            #VALUES(TODAY,g_time,g_user,g_msg) #MOD-C30891 mark
                             VALUES(TODAY,t_time,g_user,g_msg) #MOD-C30891
              #FUN-A50075--mod--end
            END IF
         END IF
      END IF    #No:MOD-B10009 add
   END IF       #No:MOD-990223 add
 
   #將下面這段抓借還料aimt306,aimt309的異動成本部份獨立出來,
   #           不然當碰到原數償還時,ccc11與ccc21會是0,這樣永遠都進不來這段
   #借還料
   IF q_tlf.tlf13 = 'aimt306' THEN   #借料
      LET l_imp09 = 0
      LET l_ccc23a= 0
      SELECT imp09 INTO l_imp09 FROM imp_file
       WHERE imp01 = q_tlf.tlf036    #借料單號
         AND imp02 = q_tlf.tlf037    #借料項次
      IF cl_null(l_imp09) THEN LET l_imp09 = 0 END IF
      LET l_ccc23a=l_imp09 LET l_ccc23b=0
      LET l_ccc23c=0 LET l_ccc23d=0 LET l_ccc23e=0
      LET l_ccc23f=0 LET l_ccc23g=0 LET l_ccc23h=0   #FUN-7C0028 add
      LET l_ccc23=l_ccc23a+l_ccc23b+l_ccc23c+l_ccc23d+l_ccc23e
                          +l_ccc23f+l_ccc23g+l_ccc23h   #FUN-7C0028 add
 
      #將訊息從下面搬上來
      IF STATUS OR cl_null(l_ccc23) OR l_ccc23 = 0 THEN
        #LET g_msg="料號:",g_ccc.ccc01 CLIPPED,' ',
        #          "無借料單預計單位成本請輸入借料單預計單位成本:(aimt306)"
         CALL cl_getmsg('axc-521',g_lang) RETURNING g_msg1
         CALL cl_getmsg('axc-512',g_lang) RETURNING g_msg2
         LET g_msg=g_msg1 CLIPPED,g_ccc.ccc01 CLIPPED,' ',
                   g_msg2 CLIPPED,":(aimt306)"   #MOD-840402 add ":(aimt306)"
      
         LET t_time = TIME
        #LET g_time=t_time #MOD-C30891 mark
        #FUN-A50075--mod--str-- ccy_file 拿掉plant以及 legal
        #INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04,ccyplant,ccylegal)   #No.MOD-470041 #FUN-980009 add ccyplant,ccylegal
        #              VALUES(TODAY,g_time,g_user,g_msg,g_plant,g_legal) #FUN-980009 add g_plant,g_legal
         INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04)
                      #VALUES(TODAY,g_time,g_user,g_msg) #MOD-C30891 mark
                       VALUES(TODAY,t_time,g_user,g_msg) #MOD-C30891
        #FUN-A50075--mod--end
      END IF
   END IF
   IF q_tlf.tlf13 = 'aimt309' THEN   #還料
      LET l_imp09 = 0
      LET l_ccc23a= 0
      SELECT imp09 INTO l_imp09 FROM imp_file
       WHERE imp01 = q_tlf.tlf036    #借料單號
         AND imp02 = q_tlf.tlf037    #借料項次
      IF cl_null(l_imp09) THEN LET l_imp09 = 0 END IF
      LET l_ccc23a=l_imp09 LET l_ccc23b=0
      LET l_ccc23c=0 LET l_ccc23d=0 LET l_ccc23e=0
      LET l_ccc23f=0 LET l_ccc23g=0 LET l_ccc23h=0   #FUN-7C0028 add
      LET l_ccc23=l_ccc23a+l_ccc23b+l_ccc23c+l_ccc23d+l_ccc23e
                          +l_ccc23f+l_ccc23g+l_ccc23h   #FUN-7C0028 add
 
     #將訊息從下面搬上來
     IF STATUS OR cl_null(l_ccc23) OR l_ccc23 = 0 THEN
       #LET g_msg="料號:",g_ccc.ccc01 CLIPPED,' ',
       #          "無借料單預計單位成本請輸入借料單預計單位成本:(aimt309)"
        CALL cl_getmsg('axc-521',g_lang) RETURNING g_msg1
        CALL cl_getmsg('axc-512',g_lang) RETURNING g_msg2
        LET g_msg=g_msg1 CLIPPED,g_ccc.ccc01 CLIPPED,' ',
                  g_msg2 CLIPPED,":(aimt309)"   #MOD-840402 add ":(aimt309)"
 
        LET t_time = TIME
       #LET g_time=t_time #MOD-C30891 mark
       #FUN-A50075--mod--str--ccy_file拿掉plant以及legal
       #INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04,ccyplant,ccylegal)   #No.MOD-470041 #FUN-980009 add ccyplant,ccylegal
       #              VALUES(TODAY,g_time,g_user,g_msg,g_plant,g_legal) #FUN-980009 add g_plant,g_legal
        INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04)
                     #VALUES(TODAY,g_time,g_user,g_msg) #MOD-C30891 mark
                      VALUES(TODAY,t_time,g_user,g_msg) #MOD-C30891 
       #FUN-A50075--mod--end
     END IF
   END IF
   #"廠對廠直接調撥"(aimt720),撥入部份(tlf02=57,tlf03=50)與
   #"兩階段營運中心間調撥"(aimp701)撥入部份的單價抓cxk04調撥單價
   IF (q_tlf.tlf13 = 'aimt720' AND q_tlf.tlf02=57 AND q_tlf.tlf03=50) OR
       q_tlf.tlf13 = 'aimp701' THEN   
      LET l_cxk04 = 0
      LET l_ccc23a= 0
      SELECT cxk04 INTO l_cxk04 FROM cxk_file   #調撥單價
       WHERE cxk01 = q_tlf.tlf01                #調撥料號
      IF cl_null(l_cxk04) THEN LET l_cxk04 = 0 END IF
      LET l_ccc23a=l_cxk04 LET l_ccc23b=0
      LET l_ccc23c=0 LET l_ccc23d=0 LET l_ccc23e=0
      LET l_ccc23f=0 LET l_ccc23g=0 LET l_ccc23h=0   #FUN-7C0028 add
      LET l_ccc23=l_ccc23a+l_ccc23b+l_ccc23c+l_ccc23d+l_ccc23e
                          +l_ccc23f+l_ccc23g+l_ccc23h   #FUN-7C0028 add
 
     #將訊息從下面搬上來
     IF STATUS OR cl_null(l_ccc23) OR l_ccc23 = 0 THEN
       #LET g_msg="料號:",g_ccc.ccc01 CLIPPED,' ',
       #          "無調撥單價請輸入調撥單價:(axct900)"
        CALL cl_getmsg('axc-521',g_lang) RETURNING g_msg1
        CALL cl_getmsg('axc-513',g_lang) RETURNING g_msg2
        LET g_msg=g_msg1 CLIPPED,g_ccc.ccc01 CLIPPED,' ',
                  g_msg2 CLIPPED,":(axct900)"   #MOD-840402 add ":(axct900)"
 
        LET t_time = TIME
       #LET g_time=t_time #MOD-C30891 mark
       #FUN-A50075--mod--str-- ccy_file拿掉plant以及legal
       #INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04,ccyplant,ccylegal)   #No.MOD-470041 #FUN-980009 add ccyplant,ccylegal
       #              VALUES(TODAY,g_time,g_user,g_msg,g_plant,g_legal) #FUN-980009 add g_plant,g_legal
        INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04)
                     #VALUES(TODAY,g_time,g_user,g_msg) #MOD-C30891 mark
                      VALUES(TODAY,t_time,g_user,g_msg) #MOD-C30891
       #FUN-A50075--mod--end
     END IF
   END IF
   #"倉庫間直接調撥作業"(aimt324)單價抓axct501的imn091調撥單價
  #IF q_tlf.tlf13 = 'aimt324' THEN  #TQC-B30129
   IF (q_tlf.tlf13 = 'aimt324' OR q_tlf.tlf13 = 'aimt325' OR q_tlf.tlf13 = 'artt256') THEN  #TQC-B30129  #MOD-C70249 add aimt325
      LET l_imn091= 0
      LET l_ccc23a= 0
      SELECT imn091 INTO l_imn091 FROM imn_file   #調撥單價
       WHERE imn01 = q_tlf.tlf905 AND imn02 = q_tlf.tlf906
         AND imn03 = q_tlf.tlf01                  #調撥料號
     #MOD-C70249 str add ------
      IF cl_null(l_imn091) OR l_imn091 = 0 THEN
         SELECT imn091 INTO l_imn091 FROM imn_file,imm_file
          WHERE imm01=imn01 and imm11=q_tlf.tlf905
            AND imn02 = q_tlf.tlf906 AND imn03 = q_tlf.tlf01
      END IF
     #MOD-C70249 end add ------
      IF cl_null(l_imn091) THEN LET l_imn091 = 0 END IF
      LET l_ccc23a=l_imn091 LET l_ccc23b=0
      LET l_ccc23c=0 LET l_ccc23d=0 LET l_ccc23e=0
      LET l_ccc23f=0 LET l_ccc23g=0 LET l_ccc23h=0   #FUN-7C0028 add
      LET l_ccc23=l_ccc23a+l_ccc23b+l_ccc23c+l_ccc23d+l_ccc23e
                          +l_ccc23f+l_ccc23g+l_ccc23h   #FUN-7C0028 add
 
     #將訊息從下面搬上來
     IF STATUS OR cl_null(l_ccc23) OR l_ccc23 = 0 THEN
       #LET g_msg="料號:",g_ccc.ccc01 CLIPPED,' ',
       #          "無調撥單價請輸入調撥單價:(axct501)"
        CALL cl_getmsg('axc-521',g_lang) RETURNING g_msg1
        CALL cl_getmsg('axc-513',g_lang) RETURNING g_msg2
        LET g_msg=g_msg1 CLIPPED,g_ccc.ccc01 CLIPPED,' ',
                  g_msg2 CLIPPED,":(axct501)"   #MOD-840402 add ":(axct501)"
 
        LET t_time = TIME
       #LET g_time=t_time #MOD-C30891 mark
       #FUN-A50075--mod--str-- ccy_file 拿掉plant以及拿掉legal
       #INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04,ccyplant,ccylegal)   #No.MOD-470041 #FUN-980009 add ccyplant,ccylegal
       #              VALUES(TODAY,g_time,g_user,g_msg,g_plant,g_legal) #FUN-980009 add g_plant,g_legal
        INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04)
                     #VALUES(TODAY,g_time,g_user,g_msg) #MOD-C30891 mark
                      VALUES(TODAY,t_time,g_user,g_msg) #MOD-C30891 
       #FUN-A50075--mod--end
     END IF
   END IF
 
 
   RETURN l_ccc23,l_ccc23a,l_ccc23b,l_ccc23c,l_ccc23d,l_ccc23e
                 ,l_ccc23f,l_ccc23g,l_ccc23h   #FUN-7C0028 add
END FUNCTION
 
#FUNCTION p500_ccc63_cost(l_tlf907,l_tlf66)  #銷貨收入  #No:8741            #CHI-A70023 mark
FUNCTION p500_ccc63_cost(l_tlf907,l_tlf66,l_tlf902,l_tlf903,l_tlf904)      #CHI-A70023 add
DEFINE l_ogb12   LIKE ogb_file.ogb12  #MOD-520070
DEFINE l_tlf907  LIKE tlf_file.tlf907
DEFINE l_tlf902  LIKE tlf_file.tlf902          #CHI-A70023 add
DEFINE l_tlf903  LIKE tlf_file.tlf903          #CHI-A70023 add
DEFINE l_tlf904  LIKE tlf_file.tlf904          #CHI-A70023 add
#DEFINE l_qty     LIKE ima_file.ima26           #No.FUN-680122DEC(15,3)
DEFINE l_qty     LIKE type_file.num15_3        ###GP5.2  #NO.FUN-A40023
DEFINE l_amt     LIKE type_file.num20_6        #No.FUN-680122DEC(20,6)            #MOD-4C0005
DEFINE l_unit    LIKE azj_file.azj03           #No.FUN-680122DEC(20,10)
DEFINE l_tlf66   LIKE tlf_file.tlf66  #No:8741
DEFINE l_oga00   LIKE oga_file.oga00           #No.MOD-7B0231 add
DEFINE l_oga65   LIKE oga_file.oga65           #No.MOD-880061
DEFINE l_oga09   LIKE oga_file.oga09           #No.MOD-880061
DEFINE l_ogb917  LIKE ogb_file.ogb917          #No.MOD-910175 add
 
   IF l_tlf66='Y' THEN RETURN END IF   #No:8741 已註記為多倉出貨(僅第一筆ogc資料需做以下處理) 
   #排除是出至境外倉的資料
   IF q_tlf.tlf13[1,4]='axmt' THEN  
      LET l_oga00 = NULL
      SELECT oga00,oga65,oga09 INTO l_oga00,l_oga65,l_oga09 FROM oga_file  #No.MOD-880061 add oga65,l_oga65;oga09,l_oga09
       WHERE oga01=xxx1
      IF l_oga00='2' OR l_oga00='3' OR l_oga00='7' OR  #No.MOD-880061 add l_oga00='7'  #MOD-A60192 add l_oga00='2'
         l_oga09='9' OR l_oga65='Y' THEN               #No.MOD-880061 add l_oga09='9',l_oga65='Y'
         RETURN
      END IF
   END IF
   LET amt=0
   IF l_tlf907 = -1 THEN
    #--------------No:CHI-A70023 add
    #若是成品替代出貨則呼叫s_ogc_amt_1()計算銷貨收入
     IF l_tlf66 = 'X' THEN                  
         CALL s_ogc_amt_1(g_ccc.ccc01,xxx1,xxx2,l_tlf902,l_tlf903,l_tlf904,'') RETURNING l_amt
         LET g_ccc.ccc63 = g_ccc.ccc63 + l_amt
      ELSE
     #--------------No:CHI-A70023 end
#-------------------------------------------------------------------------
#先取omb_file,若與該出貨單數量有差異,再取ogb_file(2003/11/18產品會
#-------------------------------------------------------------------------
#No.MOD-CB0054 --begin
         IF g_oaz.oaz92 ='N' THEN
            SELECT SUM(omb12),SUM(omb16) INTO l_qty,l_amt
              FROM omb_file,oma_file
             WHERE omb31=xxx1 AND omb32=xxx2 AND oma00 MATCHES '1*'
               AND oma01 = omb01 AND omaconf='Y'
            
            SELECT ogb917 INTO l_ogb917 FROM ogb_file,oga_file 
                          WHERE ogb01 = xxx1 AND ogb03 = xxx2
                            AND ogb01=oga01 AND ogapost = 'Y'
         ELSE 
            SELECT SUM(omb12),SUM(omb16) INTO l_qty,l_amt
              FROM omb_file,oma_file,azn_file,omf_file
             WHERE omb31=omf11 AND omb32=omf12 AND oma00 MATCHES '1*'
               AND oma01 = omb01 AND omaconf='Y'
               AND azn04 = g_sma.sma52
               AND azn01 = oma02
               AND omf04 = oma01
               AND omf00 = xxx1
               AND omf21 = xxx2
         END IF  
#No.MOD-CB0054 --end
 
      IF l_qty IS NULL THEN LET l_qty=0 END IF
      IF l_amt IS NULL THEN LET l_amt=0 END IF
      IF cl_null(l_ogb917) THEN LET l_ogb917 = 0 END IF   #No.MOD-910175 add
      LET g_ccc.ccc63 = g_ccc.ccc63 + l_amt
 
      IF l_qty<l_ogb917 AND g_oaz.oaz92 ='N' THEN     #No.MOD-CB0054 add oaz92 = N 

         #--------------No:CHI-B90013 modify
        # SELECT ogb13*oga24 INTO l_unit FROM oga_file,ogb_file #原出貨單本幣單價
         SELECT (ogb14*oga24/ogb917) INTO l_unit FROM oga_file,ogb_file #原出貨單本幣單價
          WHERE oga01=ogb01 AND oga01=xxx1 AND ogb03=xxx2
         #--------------No:CHI-B90013 end
 
         LET l_ogb12=0
         SELECT COUNT(*) INTO g_cnt
          FROM oga_file,ogb_file
          WHERE oga01=ogb01
            AND oga01=xxx1
            AND ogb03=xxx2
            AND ogb17='Y'
         IF g_cnt > 0 THEN
            SELECT ogb917 INTO l_ogb12        
             FROM oga_file,ogb_file
             WHERE oga01=ogb01
               AND oga01=xxx1
               AND ogb03=xxx2
            IF cl_null(l_ogb12) THEN LET l_ogb12=0 END IF
            LET g_ccc.ccc63 = g_ccc.ccc63 + (l_ogb12    -l_qty)*l_unit
         ELSE
            LET g_ccc.ccc63 = g_ccc.ccc63 + (l_ogb917-l_qty)*l_unit   
         END IF
 
       END IF
     END IF            #No:CHI-A70023 add
   ELSE
#No.MOD-CB0054 --begin
      IF g_oaz.oaz92 ='N' THEN 
         SELECT SUM(omb16) INTO l_amt #本幣未稅金額
           FROM omb_file,oma_file
          WHERE omb31=xxx1 AND omb32=xxx2 AND oma00 MATCHES '2*'
            AND oma01 = omb01               #MOD-5C0105 modify 要將數量(omb12)=0的銷退金額也應納入計算
            AND omaconf='Y'                #MOD-4A0183
      ELSE 
         SELECT SUM(omb16) INTO l_amt #本幣未稅金額
           FROM omb_file,oma_file,azn_file,omf_file
          WHERE omb31=omf11 AND omb32=omf12 AND oma00 MATCHES '2*'
            AND oma01 = omb01               #MOD-5C0105 modify 要將數量(omb12)=0的銷退金額也應納入計算
            AND omaconf='Y'                #MOD-4A0183
            AND azn04 = g_sma.sma52
            AND azn01 = oma02
            AND omf04 = oma01
            AND omf00 = xxx1
            AND omf21 = xxx2
            
      END IF 
#No.MOD-CB0054 --end
      IF l_amt IS NULL THEN LET l_amt=0 END IF
      IF l_amt = 0 AND g_oaz.oaz92 = 'N' THEN   #No.MOD-CB0054 add oaz92 =N
         #針對銷貨收入[減項]本幣未稅金額的計算應多考慮，
         #銷退折讓未立帳者，可抓取出貨單身之折讓金額
         SELECT COUNT(*) INTO g_cnt
           FROM omb_file,oma_file
          WHERE omb31=xxx1 AND omb32=xxx2 AND oma00 MATCHES '2*'
            AND oma01 = omb01 AND omaconf='Y' AND omb12 != 0
         IF g_cnt=0 THEN
            SELECT SUM(ohb14*oha24) INTO l_amt  #本幣未稅金額
              FROM oha_file,ohb_file
             WHERE oha01=ohb01
               AND oha01=xxx1 AND ohb03=xxx2 
               #AND (oha09='1' OR oha09='4' OR oha09='5')                #MOD-C70153 mark
               AND (oha09='1' OR oha09='4' OR oha09='5' OR oha09='3')   #MOD-C70153   
               AND ohaconf='Y'
               AND ohapost='Y'
         END IF
      END IF
      IF l_amt IS NULL THEN LET l_amt=0 END IF
      LET l_amt = l_amt * -1
      LET g_ccc.ccc63 = g_ccc.ccc63 + l_amt
   END IF
   IF l_tlf907 = 1 THEN #銷貨退回
      LET l_amt = l_amt * -1
      LET g_ccc.ccc65 = g_ccc.ccc65 + l_amt
   END IF
 
END FUNCTION
 
FUNCTION p500_can_upd()         # 加上銷貨收入調整金額
    DEFINE l_amt LIKE can_file.can06         #No.FUN-680122DEC(20,6)       #MOD-4C0005
 
    SELECT SUM(can06) INTO l_amt FROM can_file  #MOD-540129
    WHERE can01=g_ima01 AND can02=yy AND can03=mm
   IF l_amt IS NULL THEN LET l_amt=0 END IF
   LET g_ccc.ccc63 = g_ccc.ccc63 + l_amt
 
END FUNCTION
 
FUNCTION p500_ccb_cost()        # 加上入庫調整金額
   DEFINE l_ccb         RECORD LIKE ccb_file.*
 
   SELECT SUM(ccb22),SUM(ccb22a),SUM(ccb22b),SUM(ccb22c),SUM(ccb22d),SUM(ccb22e),
                     SUM(ccb22f),SUM(ccb22g),SUM(ccb22h)   #FUN-7C0028 add
     INTO l_ccb.ccb22, l_ccb.ccb22a,l_ccb.ccb22b,
          l_ccb.ccb22c,l_ccb.ccb22d,l_ccb.ccb22e,
          l_ccb.ccb22f,l_ccb.ccb22g,l_ccb.ccb22h           #FUN-7C0028 add
     FROM ccb_file
    WHERE ccb01=g_ima01 AND ccb02=yy AND ccb03=mm
      AND ccb06=type    AND ccb07=g_tlfcost   #FUN-7C0028 add
   IF l_ccb.ccb22 IS NULL THEN
      LET l_ccb.ccb22 =0 LET l_ccb.ccb22a=0 LET l_ccb.ccb22b=0
      LET l_ccb.ccb22c=0 LET l_ccb.ccb22d=0 LET l_ccb.ccb22e=0
      LET l_ccb.ccb22f=0 LET l_ccb.ccb22g=0 LET l_ccb.ccb22h=0   #FUN-7C0028 add
   END IF
   LET g_ccc.ccc22 =g_ccc.ccc22 +l_ccb.ccb22
   LET g_ccc.ccc22a=g_ccc.ccc22a+l_ccb.ccb22a
   LET g_ccc.ccc22b=g_ccc.ccc22b+l_ccb.ccb22b
   LET g_ccc.ccc22c=g_ccc.ccc22c+l_ccb.ccb22c
   LET g_ccc.ccc22d=g_ccc.ccc22d+l_ccb.ccb22d
   LET g_ccc.ccc22e=g_ccc.ccc22e+l_ccb.ccb22e
   LET g_ccc.ccc22f=g_ccc.ccc22f+l_ccb.ccb22f    #FUN-7C0028 add
   LET g_ccc.ccc22g=g_ccc.ccc22g+l_ccb.ccb22g    #FUN-7C0028 add
   LET g_ccc.ccc22h=g_ccc.ccc22h+l_ccb.ccb22h    #FUN-7C0028 add
   #入庫細項─調整入庫金額(ccc22a5~ccc22e5)
   LET g_ccc.ccc225 =g_ccc.ccc225 +l_ccb.ccb22
   LET g_ccc.ccc22a5=g_ccc.ccc22a5+l_ccb.ccb22a
   LET g_ccc.ccc22b5=g_ccc.ccc22b5+l_ccb.ccb22b
   LET g_ccc.ccc22c5=g_ccc.ccc22c5+l_ccb.ccb22c
   LET g_ccc.ccc22d5=g_ccc.ccc22d5+l_ccb.ccb22d
   LET g_ccc.ccc22e5=g_ccc.ccc22e5+l_ccb.ccb22e
   LET g_ccc.ccc22f5=g_ccc.ccc22f5+l_ccb.ccb22f   #FUN-7C0028 add
   LET g_ccc.ccc22g5=g_ccc.ccc22g5+l_ccb.ccb22g   #FUN-7C0028 add
   LET g_ccc.ccc22h5=g_ccc.ccc22h5+l_ccb.ccb22h   #FUN-7C0028 add
END FUNCTION
 
FUNCTION p500_ccg_cost()        # 加上WIP入庫金額
   DEFINE l_ccg       RECORD LIKE ccg_file.*
   DEFINE le_ccg      RECORD LIKE ccg_file.*
   DEFINE l_sfv09     LIKE sfv_file.sfv09
   DEFINE l_ccg31     LIKE ccg_file.ccg31
  #DEFINE l_sfv_rate  LIKE col_file.col08         #No:FUN-680122DEC(9,5) #MOD-B60127 mark
   DEFINE l_sfv_rate  LIKE type_file.num26_10     #MOD-B60127 add
   DEFINE l_cjp_rate  LIKE rvv_file.rvv17
   DEFINE l_s_cjp_rate LIKE rvv_file.rvv17
   DEFINE l_ccg01     LIKE ccg_file.ccg01
   DEFINE l_reccg31   LIKE ccg_file.ccg31
   DEFINE l_sfb02     LIKE sfb_file.sfb02   #MOD-4B0055 add
   DEFINE l_sql       LIKE type_file.chr1000           #MOD-530234        #No.FUN-680122CHAR(2000)
 #將MOD-4A0185回復
   DEFINE la_cce    RECORD LIKE cce_file.*
   DEFINE lb_cce    RECORD LIKE cce_file.*
   DEFINE l_cnt1    LIKE type_file.num10           #No.FUN-680122INTEGER
   DEFINE l_cnt2    LIKE type_file.num10           #No.FUN-680122INTEGER
 #將MOD-4A0185回復
 
 
   LET l_ccg.ccg32 =0 LET l_ccg.ccg32a=0 LET l_ccg.ccg32b=0
   LET l_ccg.ccg32c=0 LET l_ccg.ccg32d=0 LET l_ccg.ccg32e=0
   LET l_ccg.ccg32f=0 LET l_ccg.ccg32g=0 LET l_ccg.ccg32h=0   #FUN-7C0028 add
 
   LET le_ccg.ccg32=0  LET le_ccg.ccg32a=0 LET le_ccg.ccg32b=0
   LET le_ccg.ccg32c=0 LET le_ccg.ccg32d=0 LET le_ccg.ccg32e=0
   LET le_ccg.ccg32f=0 LET le_ccg.ccg32g=0 LET le_ccg.ccg32h=0   #FUN-7C0028 add
   LET l_ccg31=0       LET l_sfv09=0
 
   #重新抓取ima905
   SELECT ima905 INTO g_ima905 FROM ima_file WHERE ima01=g_ima01   #CHI-7B0022 add
   IF cl_null(g_ima905) THEN LET g_ima905 ='N' END IF              #CHI-7B0022 add
  #IF g_sma.sma104 = 'N' OR g_ima905 ='N' AND type <> '3' THEN  # 使用聯產品否 #MOD-750124 modify #TQC-970003 
   IF (g_sma.sma104 = 'N' OR g_ima905 ='N') AND type <> '3' THEN  # 使用聯產品否 #MOD-750124 modify #TQC-970003  #MOD-B50225 mod
     SELECT SUM(ccg32 *-1),SUM(ccg32a*-1),SUM(ccg32b*-1),
            SUM(ccg32c*-1),SUM(ccg32d*-1),SUM(ccg32e*-1)
           ,SUM(ccg32f*-1),SUM(ccg32g*-1),SUM(ccg32h*-1)   #FUN-7C0028 add
       INTO l_ccg.ccg32, l_ccg.ccg32a,l_ccg.ccg32b,
            l_ccg.ccg32c,l_ccg.ccg32d,l_ccg.ccg32e
           ,l_ccg.ccg32f,l_ccg.ccg32g,l_ccg.ccg32h   #FUN-7C0028 add
       FROM ccg_file, sfb_file
      WHERE ccg04=g_ima01 AND ccg02=yy AND ccg03=mm
        AND ccg06=type    
        AND ccg07=g_tlfcost   #MOD-C60140 add
        AND ccg01=sfb01 AND sfb02 != '13' AND sfb02 != '11'
        AND (sfb99 IS NULL OR sfb99 = ' ' OR sfb99='N' ) #OR sfb02 = '7')
     IF l_ccg.ccg32 IS NULL THEN
        LET l_ccg.ccg32 =0 LET l_ccg.ccg32a=0 LET l_ccg.ccg32b=0
        LET l_ccg.ccg32c=0 LET l_ccg.ccg32d=0 LET l_ccg.ccg32e=0
        LET l_ccg.ccg32f=0 LET l_ccg.ccg32g=0 LET l_ccg.ccg32h=0   #FUN-7C0028 add
     END IF
     
     #add by 2015080089 begin
     IF cl_null(l_ccg.ccg32f) THEN 
        LET l_ccg.ccg32f = 0
     END IF    
     IF cl_null(l_ccg.ccg32g) THEN 
        LET l_ccg.ccg32g = 0
     END IF
     IF cl_null(l_ccg.ccg32h) THEN 
        LET l_ccg.ccg32h = 0
     END IF          
     #add by 2015080089  end 
     
     LET g_ccc.ccc22 =g_ccc.ccc22 +l_ccg.ccg32
     LET g_ccc.ccc22a=g_ccc.ccc22a+l_ccg.ccg32a
     LET g_ccc.ccc22b=g_ccc.ccc22b+l_ccg.ccg32b
     LET g_ccc.ccc22c=g_ccc.ccc22c+l_ccg.ccg32c
     LET g_ccc.ccc22d=g_ccc.ccc22d+l_ccg.ccg32d
     LET g_ccc.ccc22e=g_ccc.ccc22e+l_ccg.ccg32e
     LET g_ccc.ccc22f=g_ccc.ccc22f+l_ccg.ccg32f   #FUN-7C0028 add
     LET g_ccc.ccc22g=g_ccc.ccc22g+l_ccg.ccg32g   #FUN-7C0028 add
     LET g_ccc.ccc22h=g_ccc.ccc22h+l_ccg.ccg32h   #FUN-7C0028 add
 
    #將原來在p500_tlf()段寫入委外與生產的入庫細項部份搬來這邊做
 
     #----- 生產入庫 -----
     SELECT SUM(ccg32 *-1),SUM(ccg32a*-1),SUM(ccg32b*-1),
            SUM(ccg32c*-1),SUM(ccg32d*-1),SUM(ccg32e*-1)
           ,SUM(ccg32f*-1),SUM(ccg32g*-1),SUM(ccg32h*-1)   #FUN-7C0028 add
       INTO l_ccg.ccg32, l_ccg.ccg32a,l_ccg.ccg32b,
            l_ccg.ccg32c,l_ccg.ccg32d,l_ccg.ccg32e
           ,l_ccg.ccg32f,l_ccg.ccg32g,l_ccg.ccg32h   #FUN-7C0028 add
       FROM ccg_file, sfb_file
      WHERE ccg04=g_ima01 AND ccg02=yy AND ccg03=mm
        AND ccg06=type   
        AND ccg07=g_tlfcost   #MOD-C60140 add
        AND ccg01=sfb01 AND sfb02 != '13' AND sfb02 != '11'
        AND (sfb99 IS NULL OR sfb99 = ' ' OR sfb99='N' )
        AND sfb02 NOT IN ('7','8')   #非委外
     IF l_ccg.ccg32 IS NULL THEN
        LET l_ccg.ccg32 =0 LET l_ccg.ccg32a=0 LET l_ccg.ccg32b=0
        LET l_ccg.ccg32c=0 LET l_ccg.ccg32d=0 LET l_ccg.ccg32e=0
        LET l_ccg.ccg32f=0 LET l_ccg.ccg32g=0 LET l_ccg.ccg32h=0   #FUN-7C0028 add
     END IF
 
     LET g_ccc.ccc223 =g_ccc.ccc223 +l_ccg.ccg32
     LET g_ccc.ccc22a3=g_ccc.ccc22a3+l_ccg.ccg32a
     LET g_ccc.ccc22b3=g_ccc.ccc22b3+l_ccg.ccg32b
     LET g_ccc.ccc22c3=g_ccc.ccc22c3+l_ccg.ccg32c
     LET g_ccc.ccc22d3=g_ccc.ccc22d3+l_ccg.ccg32d
     LET g_ccc.ccc22e3=g_ccc.ccc22e3+l_ccg.ccg32e
     LET g_ccc.ccc22f3=g_ccc.ccc22f3+l_ccg.ccg32f   #FUN-7C0028 add
     LET g_ccc.ccc22g3=g_ccc.ccc22g3+l_ccg.ccg32g   #FUN-7C0028 add
     LET g_ccc.ccc22h3=g_ccc.ccc22h3+l_ccg.ccg32h   #FUN-7C0028 add
 
     #----- 委外入庫 -----
     SELECT SUM(ccg32 *-1),SUM(ccg32a*-1),SUM(ccg32b*-1),
            SUM(ccg32c*-1),SUM(ccg32d*-1),SUM(ccg32e*-1)
           ,SUM(ccg32f*-1),SUM(ccg32g*-1),SUM(ccg32h*-1)   #FUN-7C0028 add
       INTO l_ccg.ccg32, l_ccg.ccg32a,l_ccg.ccg32b,
            l_ccg.ccg32c,l_ccg.ccg32d,l_ccg.ccg32e
           ,l_ccg.ccg32f,l_ccg.ccg32g,l_ccg.ccg32h   #FUN-7C0028 add
       FROM ccg_file, sfb_file
      WHERE ccg04=g_ima01 AND ccg02=yy AND ccg03=mm
        AND ccg06=type 
        AND ccg07=g_tlfcost   #MOD-C60140 add
        AND ccg01=sfb01 AND sfb02 != '13' AND sfb02 != '11'
        AND (sfb99 IS NULL OR sfb99 = ' ' OR sfb99='N' )
        AND sfb02  IN ('7','8')   #委外
     IF l_ccg.ccg32 IS NULL THEN
        LET l_ccg.ccg32 =0 LET l_ccg.ccg32a=0 LET l_ccg.ccg32b=0
        LET l_ccg.ccg32c=0 LET l_ccg.ccg32d=0 LET l_ccg.ccg32e=0
        LET l_ccg.ccg32f=0 LET l_ccg.ccg32g=0 LET l_ccg.ccg32h=0   #FUN-7C0028 add
     END IF
 
     LET g_ccc.ccc222 =g_ccc.ccc222 +l_ccg.ccg32
     LET g_ccc.ccc22a2=g_ccc.ccc22a2+l_ccg.ccg32a
     LET g_ccc.ccc22b2=g_ccc.ccc22b2+l_ccg.ccg32b
     LET g_ccc.ccc22c2=g_ccc.ccc22c2+l_ccg.ccg32c
     LET g_ccc.ccc22d2=g_ccc.ccc22d2+l_ccg.ccg32d
     LET g_ccc.ccc22e2=g_ccc.ccc22e2+l_ccg.ccg32e
     LET g_ccc.ccc22f2=g_ccc.ccc22f2+l_ccg.ccg32f   #FUN-7C0028 add
     LET g_ccc.ccc22g2=g_ccc.ccc22g2+l_ccg.ccg32g   #FUN-7C0028 add
     LET g_ccc.ccc22h2=g_ccc.ccc22h2+l_ccg.ccg32h   #FUN-7C0028 add
   ELSE
 
     LET l_sql = "SELECT ccg01,ccg32,ccg32a,ccg32b,ccg32c,ccg32d,ccg32e,",
                 "                   ccg32f,ccg32g,ccg32h,",
		 "       ccg31,sfb02,SUM(sfv09)",
                 "  FROM ccg_file,sfb_file,sfu_file,sfv_file",
                 "  WHERE ccg02=",yy ," AND ccg03=",mm,
                 "    AND ccg06='",type,"'",
                 "    AND ccg07='",g_tlfcost,"'",   #MOD-C60140 add
		 "    AND sfv04='",g_ima01 CLIPPED,"'",
                 "    AND sfv11=sfb01 AND ccg01=sfb01",
                 "    AND sfb02 IN (1,5) ",
		 "    AND (sfb99 IS NULL OR sfb99=' ' OR sfb99='N')",
                 "    AND sfu01=sfv01 AND sfupost='Y'",
                 "    AND YEAR(sfu02)=",yy,
		 "    AND MONTH(sfu02)=",mm,
                 "   AND tlfcost = '",g_tlfcost,"'",                   #TQC-970003
                 "  GROUP BY ccg01,ccg32,ccg32a,ccg32b,ccg32c,ccg32d,ccg32e,ccg32f,ccg32g,ccg32h,ccg31,sfb02",
		 "  UNION ",
                 "SELECT ccg01,ccg32,ccg32a,ccg32b,ccg32c,ccg32d,ccg32e,",
                 "                   ccg32f,ccg32g,ccg32h,",
		 "       ccg31,sfb02,SUM(rvv17)",
                 "  FROM ccg_file,sfb_file,rvu_file,rvv_file",
                 "  WHERE ccg02=",yy ," AND ccg03=",mm,
                 "    AND ccg06='",type,"'",
                 "    AND ccg07='",g_tlfcost,"'",   #MOD-C60140 add
		 "    AND rvv31='",g_ima01 CLIPPED,"'",
                 "    AND rvv18=sfb01 AND ccg01=sfb01",
                 #"    AND rvv34 = '",g_tlfcost,"'",                      #TQC-970003   #MOD-D20053
                 "    AND sfb02 IN (7,8) ",
		 "    AND (sfb99 IS NULL OR sfb99=' ' OR sfb99='N')",
                 "    AND rvu01=rvv01 AND rvuconf='Y'",
                 "    AND YEAR(rvu03)=",yy," AND MONTH(rvu03)=",mm,
                 "    AND rvu00 = '1'",                                 #MOD-C50084 add
                 "  GROUP BY ccg01,ccg32,ccg32a,ccg32b,ccg32c,ccg32d,ccg32e,ccg32f,ccg32g,ccg32h,ccg31,sfb02"
 
     PREPARE p500_ccg_p2 FROM l_sql
 
   END IF
END FUNCTION
 
FUNCTION p500_ccg2_cost()       # 加上WIP重工入庫金額
   DEFINE l_ccg       RECORD LIKE ccg_file.*
   DEFINE le_ccg      RECORD LIKE ccg_file.*
   DEFINE l_sfv09     LIKE sfv_file.sfv09
   DEFINE l_ccg31     LIKE ccg_file.ccg31
  #DEFINE l_sfv_rate  LIKE col_file.col08         #No:FUN-680122DEC(9,5) #MOD-B60127 mark
   DEFINE l_sfv_rate  LIKE type_file.num26_10     #MOD-B60127 add
   DEFINE l_cjp_rate  LIKE rvv_file.rvv17
   DEFINE l_s_cjp_rate LIKE rvv_file.rvv17
   DEFINE l_ccg01     LIKE ccg_file.ccg01
   DEFINE l_reccg31   LIKE ccg_file.ccg31
   DEFINE l_sql       LIKE type_file.chr1000       #No.FUN-680122CHAR(800)
   DEFINE l_ima55_fac LIKE ima_file.ima55_fac      #MOD-860183 add
   DEFINE l_sfb02     LIKE sfb_file.sfb02
   DEFINE l_qty1      LIKE ccg_file.ccg31
  #DEFINE l_qty2      LIKE ccg_file.ccg31          #MOD-C90111 mark 
   DEFINE l_bdate     LIKE type_file.dat           #CHI-9A0021 add
   DEFINE l_edate     LIKE type_file.dat           #CHI-9A0021 add
   DEFINE l_correct   LIKE type_file.chr1          #CHI-9A0021 add
   #FUN-A20017--begin--add-----
   DEFINE la_cce    RECORD LIKE cce_file.*
   DEFINE lb_cce    RECORD LIKE cce_file.*
   DEFINE l_cnt1    LIKE type_file.num10 
   DEFINE l_cnt2    LIKE type_file.num10
   #FUN-A20017--end--add---
   #No.130530001 ---begin---
   DEFINE l_ccg04     LIKE ccg_file.ccg04 
   DEFINE l_qty1_1    LIKE ccg_file.ccg31
   DEFINE l_qty1_2    LIKE ccg_file.ccg31
   DEFINE l_qty2_1    LIKE ccg_file.ccg31
   DEFINE l_qty2_2    LIKE ccg_file.ccg31      
   DEFINE l_reccg31_1   LIKE ccg_file.ccg31    
   DEFINE l_reccg31_2   LIKE ccg_file.ccg31     
   DEFINE l_s_cjp_rate1 LIKE rvv_file.rvv17
   DEFINE l_s_cjp_rate2 LIKE rvv_file.rvv17
   DEFINE l_sfv09_1      LIKE sfv_file.sfv09 
   DEFINE l_qty2      LIKE ccg_file.ccg31
   
   INITIALIZE l_ccg04 TO NULL 
   LET l_qty1_1 = 0  LET l_qty1_2 = 0 
   LET l_qty2_1 = 0  LET l_qty2_2 = 0 
   LET l_reccg31_1 = 0  LET l_reccg31_2 = 0
   LET l_s_cjp_rate1 = 0 LET l_s_cjp_rate2 = 0 
   LET l_sfv09_1 = 0 
   #No.130530001 ---end---
    
   LET l_ccg.ccg32 =0 LET l_ccg.ccg32a=0 LET l_ccg.ccg32b=0
   LET l_ccg.ccg32c=0 LET l_ccg.ccg32d=0 LET l_ccg.ccg32e=0
   LET l_ccg.ccg32f=0 LET l_ccg.ccg32g=0 LET l_ccg.ccg32h=0   #FUN-7C0028 add
 
   LET le_ccg.ccg32=0  LET le_ccg.ccg32a=0 LET le_ccg.ccg32b=0
   LET le_ccg.ccg32c=0 LET le_ccg.ccg32d=0 LET le_ccg.ccg32e=0
   LET le_ccg.ccg32f=0 LET le_ccg.ccg32g=0 LET le_ccg.ccg32h=0   #FUN-7C0028 add
   LET l_ccg31=0       LET l_sfv09=0
 
   #重新抓取ima905
   SELECT ima905 INTO g_ima905 FROM ima_file WHERE ima01=g_ima01   #CHI-7B0022 add
   IF cl_null(g_ima905) THEN LET g_ima905 ='N' END IF              #CHI-7B0022 add
   IF (g_sma.sma104 = 'N' OR g_ima905 ='N') AND type <> '3' THEN  # 使用聯產品否 #MOD-750124 modify  #No.TQC-970003
#FUN-A20017--begin--add 入庫明細--
#因要by工單抓所以select sum 改 foreach
#     SELECT SUM(ccg32 *-1),SUM(ccg32a*-1),SUM(ccg32b*-1),
#            SUM(ccg32c*-1),SUM(ccg32d*-1),SUM(ccg32e*-1)
#           ,SUM(ccg32f*-1),SUM(ccg32g*-1),SUM(ccg32h*-1)   #FUN-7C0028 add
#       INTO l_ccg.ccg32, l_ccg.ccg32a,l_ccg.ccg32b,
#            l_ccg.ccg32c,l_ccg.ccg32d,l_ccg.ccg32e
#           ,l_ccg.ccg32f,l_ccg.ccg32g,l_ccg.ccg32h   #FUN-7C0028 add
#       FROM ccg_file, sfb_file
#      WHERE ccg04=g_ima01 AND ccg02=yy AND ccg03=mm
#        AND ccg06=type  
#        AND ccg01=sfb01 AND sfb02 != '13' AND sfb02 != '11' AND sfb99 = 'Y'
     DECLARE p500_ccg2_c0 CURSOR FOR
      SELECT DISTINCT ccg01 FROM ccg_file, sfb_file
       WHERE ccg04=g_ima01 AND ccg02=yy AND ccg03=mm
         AND ccg06=type  
         AND ccg07=g_tlfcost   #MOD-C60140 add
         AND ccg01=sfb01 AND sfb02 != '13' AND sfb02 != '11' AND sfb99 = 'Y'
     FOREACH p500_ccg2_c0 INTO l_ccg01
       SELECT SUM(ccg32 *-1),SUM(ccg32a*-1),SUM(ccg32b*-1),
              SUM(ccg32c*-1),SUM(ccg32d*-1),SUM(ccg32e*-1)
             ,SUM(ccg32f*-1),SUM(ccg32g*-1),SUM(ccg32h*-1)   #FUN-7C0028 add
         INTO l_ccg.ccg32, l_ccg.ccg32a,l_ccg.ccg32b,
              l_ccg.ccg32c,l_ccg.ccg32d,l_ccg.ccg32e
             ,l_ccg.ccg32f,l_ccg.ccg32g,l_ccg.ccg32h   #FUN-7C0028 add
         FROM ccg_file, sfb_file
        WHERE ccg04=g_ima01 AND ccg02=yy AND ccg03=mm
          AND ccg06=type  
          AND ccg07=g_tlfcost   #MOD-C60140 add
          AND ccg01=sfb01 AND sfb02 != '13' AND sfb02 != '11' AND sfb99 = 'Y'
          AND ccg01 = l_ccg01
#FUN-A20017--end--mod------
     IF l_ccg.ccg32 IS NULL THEN
        LET l_ccg.ccg32 =0 LET l_ccg.ccg32a=0 LET l_ccg.ccg32b=0
        LET l_ccg.ccg32c=0 LET l_ccg.ccg32d=0 LET l_ccg.ccg32e=0
        LET l_ccg.ccg32f=0 LET l_ccg.ccg32g=0 LET l_ccg.ccg32h=0   #FUN-7C0028 add
     END IF
     LET g_ccc.ccc28 =g_ccc.ccc28 +l_ccg.ccg32
     LET g_ccc.ccc28a=g_ccc.ccc28a+l_ccg.ccg32a
     LET g_ccc.ccc28b=g_ccc.ccc28b+l_ccg.ccg32b
     LET g_ccc.ccc28c=g_ccc.ccc28c+l_ccg.ccg32c
     LET g_ccc.ccc28d=g_ccc.ccc28d+l_ccg.ccg32d
     LET g_ccc.ccc28e=g_ccc.ccc28e+l_ccg.ccg32e
     LET g_ccc.ccc28f=g_ccc.ccc28f+l_ccg.ccg32f   #FUN-7C0028 add
     LET g_ccc.ccc28g=g_ccc.ccc28g+l_ccg.ccg32g   #FUN-7C0028 add
     LET g_ccc.ccc28h=g_ccc.ccc28h+l_ccg.ccg32h   #FUN-7C0028 add
    #MOD-AB0126---mark---start---
    ##FUN-A20017--begin--add-----
    ##當使用聯產品時，要計算生產入庫的入庫細項金額
    #SELECT sfb02 INTO l_sfb02 FROM sfb_file WHERE sfb01 = l_ccg01
    #  IF l_sfb02 ! ='7' AND l_sfb02 != '8' THEN  #委外工單的部分，不要計算進來
    #    #------------------------No:MOD-A90131 mark
    #    #內製重工工單入庫金額不應放在入庫細項上
    #    #LET g_ccc.ccc22a3=g_ccc.ccc22a3+l_ccg.ccg32a
    #    #LET g_ccc.ccc22b3=g_ccc.ccc22b3+l_ccg.ccg32b
    #    #LET g_ccc.ccc22c3=g_ccc.ccc22c3+l_ccg.ccg32c
    #    #LET g_ccc.ccc22d3=g_ccc.ccc22d3+l_ccg.ccg32d
    #    #LET g_ccc.ccc22e3=g_ccc.ccc22e3+l_ccg.ccg32e
    #    #LET g_ccc.ccc22f3=g_ccc.ccc22f3+l_ccg.ccg32f   #FUN-7C0028 add
    #    #LET g_ccc.ccc22g3=g_ccc.ccc22g3+l_ccg.ccg32g   #FUN-7C0028 add
    #    #LET g_ccc.ccc22h3=g_ccc.ccc22h3+l_ccg.ccg32h   #FUN-7C0028 add
    #    #------------------------No:MOD-A90131 end
    #  #No.TQC-980002  --Begin
    #  ELSE
    #     LET g_ccc.ccc22a2=g_ccc.ccc22a2+l_ccg.ccg32a
    #     LET g_ccc.ccc22b2=g_ccc.ccc22b2+l_ccg.ccg32b
    #     LET g_ccc.ccc22c2=g_ccc.ccc22c2+l_ccg.ccg32c
    #     LET g_ccc.ccc22d2=g_ccc.ccc22d2+l_ccg.ccg32d
    #     LET g_ccc.ccc22e2=g_ccc.ccc22e2+l_ccg.ccg32e
    #     LET g_ccc.ccc22f2=g_ccc.ccc22f2+l_ccg.ccg32f   #FUN-7C0028 add
    #     LET g_ccc.ccc22g2=g_ccc.ccc22g2+l_ccg.ccg32g   #FUN-7C0028 add
    #     LET g_ccc.ccc22h2=g_ccc.ccc22h2+l_ccg.ccg32h   #FUN-7C0028 add
    #  #No.TQC-980002  --End  
    #  END IF                                                                     #MOD-740166 add
    ##FUN-A20017--end--add--------
    #MOD-AB0126---mark---end---
     END FOREACH
   ELSE
     #先判斷是否為無入庫量,有金額的情況(工單強制結案)
     DECLARE p500_ccg2_c1 CURSOR FOR
      SELECT DISTINCT ccg01 FROM ccg_file, sfb_file
       WHERE ccg02=yy   AND ccg03=mm AND ccg01=sfb01 AND ccg04=g_ima01
         AND ccg06=type
         AND ccg07=g_tlfcost   #MOD-C60140 add
         AND ccg31=0 AND ccg32 <> 0    # 無入庫量有金額
         AND sfb02 IN (1,5,7,8)            # 一般, 重工(聯產品目前無委外重工)   #No:MOD-990009 add 7,8
         AND sfb99='Y'
     FOREACH p500_ccg2_c1 INTO l_ccg01
       SELECT SUM(ccg32 *-1),SUM(ccg32a*-1),SUM(ccg32b*-1),
              SUM(ccg32c*-1),SUM(ccg32d*-1),SUM(ccg32e*-1),
              SUM(ccg32f*-1),SUM(ccg32g*-1),SUM(ccg32h*-1),ccg01   #FUN-7C0028 add ccg32f,g,h
         INTO l_ccg.ccg32, l_ccg.ccg32a,l_ccg.ccg32b,
              l_ccg.ccg32c,l_ccg.ccg32d,l_ccg.ccg32e,
              l_ccg.ccg32f,l_ccg.ccg32g,l_ccg.ccg32h,l_ccg01  #FUN-7C0028 add ccg32f,g,h
         FROM ccg_file, sfb_file
        WHERE ccg04=g_ima01 AND ccg02=yy AND ccg03=mm
          AND ccg06=type  
          AND ccg07=g_tlfcost   #MOD-C60140 add
          AND ccg01=sfb01 AND sfb02 != '13' AND sfb02 != '11'
          AND sfb99='Y'
          AND ccg01=l_ccg01 #WO
        GROUP BY ccg01
       IF l_ccg.ccg32 IS NULL THEN
         LET l_ccg.ccg32 =0 LET l_ccg.ccg32a=0 LET l_ccg.ccg32b=0
         LET l_ccg.ccg32c=0 LET l_ccg.ccg32d=0 LET l_ccg.ccg32e=0
         LET l_ccg.ccg32f=0 LET l_ccg.ccg32g=0 LET l_ccg.ccg32h=0   #FUN-7C0028 add
       END IF
       IF NOT cl_null(l_ccg01) THEN
         LET l_sfv09=0     #入庫量=0
         INSERT INTO cce_file
            (cce01 ,cce02 ,cce03 ,cce04 ,cce05 ,cce06 ,cce07 ,          #FUN-7C0028 add cce06,07
             cce11 ,cce12 ,
             cce12a,cce12b,cce12c,cce12d,cce12e,cce12f,cce12g,cce12h,   #FUN-7C0028 add cce12f,g,h
             cce20 ,cce21 ,cce22 ,
             cce22a,cce22b,cce22c,cce22d,cce22e,cce22f,cce22g,cce22h,   #FUN-7C0028 add cce22f,g,h
             cce91 ,cce92 ,
             cce92a,cce92b,cce92c,cce92d,cce92e,cce92f,cce92g,cce92h,   #FUN-7C0028 add cce92f,g,h
            #cceuser,ccedate,ccetime,cceplant,ccelegal,cceoriu,cceorig) #No.MOD-470041 #FUN-980009 add cceplant,ccelegal   #FUN-A50075
             cceuser,ccedate,ccetime,ccelegal,cceoriu,cceorig)          #FUN-A50075 del plant
           VALUES(l_ccg01,yy,mm,g_ima01,' ',type,g_tlfcost,   #FUN-7C0028 add type,g_tlfcost
                  0,0,0,0,0,0,0,0,0,0,                        #FUN-7C0028 add 0,0,0
                  0,l_sfv09,l_ccg.ccg32,
                  l_ccg.ccg32a,l_ccg.ccg32b,l_ccg.ccg32c,l_ccg.ccg32d,
                  l_ccg.ccg32e,l_ccg.ccg32f,l_ccg.ccg32g,l_ccg.ccg32h,   #FUN-7C0028 add ccg32f,g,h
                  0,0,0,0,0,0,0,0,0,0,                        #FUN-7C0028 add 0,0,0
                 #g_user,TODAY,g_time,g_plant,g_legal, g_user, g_grup) #FUN-980009 add g_plant,g_legal      #No.FUN-980030 10/01/04  insert columns oriu, orig   #FUN-A50075 mark
                 #g_user,TODAY,g_time,g_legal, g_user, g_grup) #FUN-980009 add g_plant,g_legal      #No.FUN-980030 10/01/04  insert columns oriu, orig   #FUN-A50075 del plant #MOD-C30891 mark
                  g_user,TODAY,t_time,g_legal, g_user, g_grup) #FUN-980009 add g_plant,g_legal      #MOD-C30891  
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
           UPDATE cce_file
              SET cce21=l_sfv09,
                  cce22=l_ccg.ccg32,
                  cce22a=l_ccg.ccg32a,
                  cce22b=l_ccg.ccg32b,
                  cce22c=l_ccg.ccg32c,
                  cce22d=l_ccg.ccg32d,
                  cce22e=l_ccg.ccg32e,
                  cce22f=l_ccg.ccg32f,   #FUN-7C0028 add
                  cce22g=l_ccg.ccg32g,   #FUN-7C0028 add
                  cce22h=l_ccg.ccg32h,   #FUN-7C0028 add
                  cceuser=g_user,
                  ccedate=TODAY,
                 #ccetime=g_time #MOD-C30891 mark
                  ccetime=t_time #MOD-C30891 
            WHERE cce01=l_ccg01 AND cce02=yy AND cce03=mm AND cce04=g_ima01
              AND cce06=type    AND cce07=g_tlfcost   #FUN-7C0028 add
           IF SQLCA.SQLCODE THEN
             CALL cl_err3("upd","cce_file",l_ccg01,yy,SQLCA.SQLCODE,"","ins cce_file:",1)   #No.FUN-660127
             LET g_success='N'
           END IF
         END IF
       END IF
       LET g_ccc.ccc28 =g_ccc.ccc28 +l_ccg.ccg32   #本月投入金額=+在製轉出金額
       LET g_ccc.ccc28a=g_ccc.ccc28a+l_ccg.ccg32a
       LET g_ccc.ccc28b=g_ccc.ccc28b+l_ccg.ccg32b
       LET g_ccc.ccc28c=g_ccc.ccc28c+l_ccg.ccg32c
       LET g_ccc.ccc28d=g_ccc.ccc28d+l_ccg.ccg32d
       LET g_ccc.ccc28e=g_ccc.ccc28e+l_ccg.ccg32e
       LET g_ccc.ccc28f=g_ccc.ccc28f+l_ccg.ccg32f   #FUN-7C0028 add
       LET g_ccc.ccc28g=g_ccc.ccc28g+l_ccg.ccg32g   #FUN-7C0028 add
       LET g_ccc.ccc28h=g_ccc.ccc28h+l_ccg.ccg32h   #FUN-7C0028 add
       LET g_ccc.ccc28=g_ccc.ccc28a+g_ccc.ccc28b+g_ccc.ccc28c+g_ccc.ccc28d+
                       g_ccc.ccc28e+g_ccc.ccc28f+g_ccc.ccc28g+g_ccc.ccc28h   #FUN-7C0028 add ccc28f,g,h
      #MOD-AB0126---mark---start---
      ##FUN-A20017--begin--add 入庫明細--
      ##當使用聯產品時,要計算生產入庫的入庫細項金額
      #SELECT sfb02 INTO l_sfb02 FROM sfb_file WHERE sfb01 = l_ccg01
      #IF l_sfb02 ! ='7' AND l_sfb02 != '8' THEN   #委外工單的部分，不要計算進來
      #  #------------------------No:MOD-A90131 mark
      #  #內製重工工單入庫金額不應放在入庫細項上
      #  #LET g_ccc.ccc22a3=g_ccc.ccc22a3+l_ccg.ccg32a
      #  #LET g_ccc.ccc22b3=g_ccc.ccc22b3+l_ccg.ccg32b
      #  #LET g_ccc.ccc22c3=g_ccc.ccc22c3+l_ccg.ccg32c
      #  #LET g_ccc.ccc22d3=g_ccc.ccc22d3+l_ccg.ccg32d
      #  #LET g_ccc.ccc22e3=g_ccc.ccc22e3+l_ccg.ccg32e
      #  #LET g_ccc.ccc22f3=g_ccc.ccc22f3+l_ccg.ccg32f   #FUN-7C0028 add
      #  #LET g_ccc.ccc22g3=g_ccc.ccc22g3+l_ccg.ccg32g   #FUN-7C0028 add
      #  #LET g_ccc.ccc22h3=g_ccc.ccc22h3+l_ccg.ccg32h   #FUN-7C0028 add
      #  #------------------------No:MOD-A90131 end
      ##No.TQC-980002  --Begin
      #ELSE
      #   LET g_ccc.ccc22a2=g_ccc.ccc22a2+l_ccg.ccg32a
      #   LET g_ccc.ccc22b2=g_ccc.ccc22b2+l_ccg.ccg32b
      #   LET g_ccc.ccc22c2=g_ccc.ccc22c2+l_ccg.ccg32c
      #   LET g_ccc.ccc22d2=g_ccc.ccc22d2+l_ccg.ccg32d
      #   LET g_ccc.ccc22e2=g_ccc.ccc22e2+l_ccg.ccg32e
      #   LET g_ccc.ccc22f2=g_ccc.ccc22f2+l_ccg.ccg32f   #FUN-7C0028 add
      #   LET g_ccc.ccc22g2=g_ccc.ccc22g2+l_ccg.ccg32g   #FUN-7C0028 add
      #   LET g_ccc.ccc22h2=g_ccc.ccc22h2+l_ccg.ccg32h   #FUN-7C0028 add
      ##No.TQC-980002  --End  
      #END IF
      ##FUN-A20017--end--add----
      #MOD-AB0126---mark---end---
     END FOREACH
 
     LET l_ccg.ccg32 =0 LET l_ccg.ccg32a=0 LET l_ccg.ccg32b=0
     LET l_ccg.ccg32c=0 LET l_ccg.ccg32d=0 LET l_ccg.ccg32e=0
     LET l_ccg.ccg32f=0 LET l_ccg.ccg32g=0 LET l_ccg.ccg32h=0   #FUN-7C0028 add
 
     LET le_ccg.ccg32=0  LET le_ccg.ccg32a=0 LET le_ccg.ccg32b=0
     LET le_ccg.ccg32c=0 LET le_ccg.ccg32d=0 LET le_ccg.ccg32e=0
     LET le_ccg.ccg32f=0 LET le_ccg.ccg32g=0 LET le_ccg.ccg32h=0   #FUN-7C0028 add
     LET l_ccg31=0       LET l_sfv09=0
 
    #當月起始日與截止日
     CALL s_azm(yy,mm) RETURNING l_correct,l_bdate,l_edate   #CHI-9A0021 add
 
    # 聯產品
    #改成下段效能改善,以台端為例改前4hr,改後可至10分鐘左右就可
     DECLARE p500_ccg2_c2 CURSOR FOR
      SELECT ccg01,ccg32,ccg32a,ccg32b,ccg32c,ccg32d,ccg32e,ccg32f,ccg32g,ccg32h,  #FUN-7C0028 add ccg32f,g,h
             ccg31,SUM(tlf10)
        FROM ccg_file,sfb_file,tlf_file
       WHERE ccg02=yy    AND ccg03=mm
         AND ccg06=type
         AND ccg07=g_tlfcost   #MOD-C60140 add
         AND tlf62=sfb01 AND ccg01=sfb01 AND tlf01=g_ima01
         AND sfb02 IN (1,5,7,8) AND (sfb99='Y')  #No:MOD-990009 add 7,8
         AND tlf907 <> 0                         #No:MOD-990009 add
         AND tlf06 BETWEEN l_bdate AND l_edate   #CHI-9A0021
         AND tlf13 MATCHES 'asft6*'   #FUN-5B0076
         #排除非成本庫的資料
         #AND tlf902 NOT IN(SELECT jce02 FROM jce_file)   #MOD-6C0146 add #CHI-C80002
         AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = tlf902)  #CHI-C80002
         AND tlfcost = g_tlfcost   #FUN-7C0028 add
       GROUP BY ccg01,ccg32,ccg32a,ccg32b,ccg32c,ccg32d,ccg32e,ccg32f,ccg32g,ccg32h,ccg31   #FUN-7C0028 add ccg32f,g,h  
 
     FOREACH p500_ccg2_c2 INTO l_ccg01,le_ccg.ccg32,le_ccg.ccg32a,le_ccg.ccg32b,
                               le_ccg.ccg32c,le_ccg.ccg32d,le_ccg.ccg32e,
                               le_ccg.ccg32f,le_ccg.ccg32g,le_ccg.ccg32h,   #FUN-7C0028 add
                               l_ccg31,l_sfv09
       #本月轉出金額
       IF le_ccg.ccg32 IS NULL THEN
          LET le_ccg.ccg32 =0 LET le_ccg.ccg32a=0 LET le_ccg.ccg32b=0
          LET le_ccg.ccg32c=0 LET le_ccg.ccg32d=0 LET le_ccg.ccg32e=0
          LET le_ccg.ccg32f=0 LET le_ccg.ccg32g=0 LET le_ccg.ccg32h=0   #FUN-7C0028 add
          LET l_ccg31=0       LET l_sfv09=0
       END IF
       IF cl_null(l_ccg31) THEN LET l_ccg31=0 END IF
       IF cl_null(l_sfv09) THEN LET l_sfv09=0 END IF

       #No.130530001 ---begin---
       SELECT sfb05 INTO l_ccg04 FROM sfb_file WHERE sfb01 = l_ccg01
       LET l_sfv09_1 = l_sfv09 
       #No.130530001 ---end---
 
       #工單重新sum(sfv09)成品轉出量(sum入庫單,不sum ccg以免有cce>ccg數量的情況)
       LET l_reccg31=0
       SELECT sfb02 INTO l_sfb02 FROM sfb_file WHERE sfb01 = l_ccg01
       IF l_sfb02 MATCHES "[78]" THEN
          LET l_qty1 = 0 
         #LET l_qty2 = 0        #MOD-C90111 mark
          LET l_qty2 = 0        #No.130530001
          #SELECT SUM(rvv17) INTO l_qty1 FROM rvv_file,rvu_file 
          SELECT SUM(rvv17) INTO l_qty1_1 FROM rvv_file,rvu_file   #No.130530001 主产品数量
                   WHERE rvv18 = l_ccg01 AND rvv01=rvu01
                     AND rvu08 = 'SUB' AND rvu00 = '1' 
                     AND rvuconf = 'Y'  
                     #AND rvu03 BETWEEN l_bdate01 AND l_edate01   #CHI-9A0021 #MOD-B90058 mark
                     AND rvu03 BETWEEN l_bdate AND l_edate        #MOD-B90058 add 
                     #AND rvv32 NOT IN(SELECT jce02 FROM jce_file)  #CHI-C80002
                     AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = rvv32)  #CHI-C80002
                     AND rvv31 = l_ccg04  #No.130530001
        #MOD-C90111 str mark-----
        # SELECT SUM(rvv17) INTO l_qty2 FROM rvv_file,rvu_file 
        #          WHERE rvv18 = l_ccg01 AND rvv01=rvu01
        #            AND rvu08 = 'SUB' AND rvu00 = '2' 
        #            AND rvuconf = 'Y'  
        #            #AND rvu03 BETWEEN l_bdate01 AND l_edate01   #CHI-9A0021 #MOD-B90058 mark
        #            AND rvu03 BETWEEN l_bdate AND l_edate        #MOD-B90058 add
        #            #AND rvv32 NOT IN(SELECT jce02 FROM jce_file)  #CHI-C80002
        #            AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = rvv32)  #CHI-C80002
        #MOD-C90111 end mark-----            
          #No.130530001 ---begin---
          #联产品数量，单位转换率
          SELECT SUM(rvv17) INTO l_qty1_2
            FROM rvv_file,rvu_file
           WHERE rvv18 = l_ccg01 AND rvv01=rvu01
             AND rvu08 = 'SUB' AND rvu00 = '1' 
             AND rvuconf = 'Y'  
             AND rvu03 BETWEEN l_bdate AND l_edate        #MOD-B90058 add 
             #AND rvv32 NOT IN(SELECT jce02 FROM jce_file) 
             AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = rvv32)  #CHI-C80002
             AND rvv31 = l_ccg04
             AND rvv31 <> l_ccg04
           #No.130530001 ---end---
          #No.130530001 ---begin--- 
          #SELECT SUM(rvv17) INTO l_qty2 FROM rvv_file,rvu_file 
          SELECT SUM(rvv17) INTO l_qty2_1 FROM rvv_file,rvu_file   #No.130530001 主产品数量
                   WHERE rvv18 = l_ccg01 AND rvv01=rvu01
                     AND rvu08 = 'SUB' AND rvu00 = '2' 
                     AND rvuconf = 'Y'  
                     #AND rvu03 BETWEEN l_bdate01 AND l_edate01   #CHI-9A0021 #MOD-B90058 mark
                     AND rvu03 BETWEEN l_bdate AND l_edate        #MOD-B90058 add 
                     #AND rvv32 NOT IN(SELECT jce02 FROM jce_file) 
                     AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = rvv32)  #CHI-C80002
                     AND rvv31 = l_ccg04  #No.130530001
          
          #联产品数量，单位转换率
          SELECT SUM(rvv17) INTO l_qty2_2
            FROM rvv_file,rvu_file
           WHERE rvv18 = l_ccg01 AND rvv01=rvu01
             AND rvu08 = 'SUB' AND rvu00 = '2' 
             AND rvuconf = 'Y'  
             AND rvu03 BETWEEN l_bdate AND l_edate        #MOD-B90058 add 
             #AND rvv32 NOT IN(SELECT jce02 FROM jce_file) 
             AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = rvv32)  #CHI-C80002
             AND rvv31 = l_ccg04
             AND rvv31 <> l_ccg04
           IF cl_null(l_qty1_1) THEN LET l_qty1_1 = 0 END IF 
           IF cl_null(l_qty1_2) THEN LET l_qty1_2 = 0 END IF 
           IF cl_null(l_qty2_1) THEN LET l_qty2_1 = 0 END IF 
           IF cl_null(l_qty2_1) THEN LET l_qty2_1 = 0 END IF 
           LET l_qty1 = l_qty1_1 + l_qty1_2
           LET l_qty2 = l_qty2_1 + l_qty2_2
           #No.130530001 ---end---
           
          IF cl_null(l_qty1) THEN LET l_qty1 = 0 END IF
         #IF cl_null(l_qty2) THEN LET l_qty2 = 0 END IF        #MOD-C90111 mark
         #LET l_reccg31 = l_qty1 - l_qty2                      #MOD-C90111 mark
         # LET l_reccg31 = l_qty1                               #MOD-C90111 add  #No.130530001 mark
          IF cl_null(l_qty2) THEN LET l_qty2 = 0 END IF    #No.130530001 add
          LET l_reccg31 = l_qty1 - l_qty2   #No.130530001 add
       ELSE
          #SELECT SUM(sfv09) INTO l_reccg31 FROM sfv_file,sfu_file
          SELECT SUM(sfv09) INTO l_reccg31_1 FROM sfv_file,sfu_file  #No.130530001 主产品数量
           WHERE sfv11=l_ccg01 AND sfv01=sfu01 AND sfupost='Y'
             AND sfu02 BETWEEN l_bdate AND l_edate    #CHI-9A0021
             #排除非成本庫的資料
             #AND sfv05 NOT IN(SELECT jce02 FROM jce_file)   #MOD-6C0146 add #CHI-C80002
             AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = sfv05)  #CHI-C80002
             AND sfv04 = l_ccg04  #No.130530001
           #No.130530001 ---begin---
           #联产品入库数量，有单位转换率
          SELECT SUM(sfv09) INTO l_reccg31_2 FROM sfv_file,sfu_file
           WHERE sfv11=l_ccg01 AND sfv01=sfu01 AND sfupost='Y'   #TQC-620151
              AND sfu02 BETWEEN l_bdate AND l_edate   #CHI-9A0021
              #排除非成本庫的資料
              #AND sfv05 NOT IN(SELECT jce02 FROM jce_file)   #MOD-6C0146 add
              AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = sfv05)  #CHI-C80002
              AND sfv04 <> l_ccg04
           IF cl_null(l_reccg31_1) THEN LET l_reccg31_1 = 0 END IF 
           IF cl_null(l_reccg31_2) THEN LET l_reccg31_2 = 0 END IF 
           LET l_reccg31 = l_reccg31_1 + l_reccg31_2
           #No.130530001 ---end---             
       END IF               #No:MOD-990009 add
       IF cl_null(l_reccg31) THEN LET l_reccg31=0 END IF
       LET l_ccg31=l_reccg31*-1
 
       CASE g_ccz.ccz13
         WHEN '1'    # 完工比例
           #LET l_sfv_rate=l_sfv09/l_ccg31
           LET l_sfv_rate=l_sfv09_1/l_ccg31  #No.130530001
         WHEN '2'    # 依分配例
##No.130530001 mark begin-----------
#           # 入庫*比例/SUM(入庫*比例)*要分攤的金額
#           LET l_s_cjp_rate=0 #MOD-620042  06=0    #SUM(入庫*比例)
#           SELECT SUM(sfv09*cjp06) INTO l_s_cjp_rate     #MOD-620042 06
#             FROM cjp_file,sfb_file,sfu_file,sfv_file
#            WHERE cjp01=sfb05 AND cjp02=yy AND cjp03=mm
#              AND sfb01=l_ccg01
#              AND sfu01=sfv01 AND sfupost='Y' AND sfv11=sfb01
#              AND sfu02 BETWEEN l_bdate AND l_edate    #CHI-9A0021
#              AND cjp04 = sfv04           #MOD-B90237 add
#              #AND sfv05 NOT IN(SELECT jce02 FROM jce_file)           #MOD-C70092 add #CHI-C80002
#              AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = sfv05)  #CHI-C80002
#           LET l_cjp_rate=0   #MOD-620042 06=0      #該聯產品分配率
#           SELECT SUM(cjp06*sfv09) INTO l_cjp_rate  #MOD-620042 06
#             FROM cjp_file,sfb_file,sfu_file,sfv_file
#            WHERE cjp01=sfb05 AND cjp02=yy AND cjp03=mm
#              AND sfb01=l_ccg01 AND cjp04=g_ima01
#              AND sfu01=sfv01 AND sfupost='Y' AND sfv11=sfb01
#              AND sfu02 BETWEEN l_bdate AND l_edate    #CHI-9A0021
#              AND sfv04=cjp04
#              #AND sfv05 NOT IN(SELECT jce02 FROM jce_file)           #MOD-C70092 add #CHI-C80002
#              AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = sfv05)  #CHI-C80002
##No.130530001 mark end-----------------
              #No.130530001 ---begin---
             #抓取产成品数量
             SELECT SUM(sfv09) INTO l_s_cjp_rate1 #MOD-620042 06
               FROM sfu_file,sfv_file
              WHERE sfu01=sfv01 AND sfupost='Y' AND sfv11=l_ccg01
                AND sfu02 BETWEEN l_bdate AND l_edate   #CHI-9A0021
                #AND sfv05 NOT IN(SELECT jce02 FROM jce_file)  
                AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = sfv05)  #CHI-C80002
                AND sfv04 = l_ccg04
             #联产品入库数量，
             SELECT SUM(sfv09*cjp06/100) INTO l_s_cjp_rate2 FROM sfv_file,sfu_file,cjp_file
              WHERE sfv11=l_ccg01 AND sfv01=sfu01 AND sfupost='Y'   #TQC-620151
                AND sfu02 BETWEEN l_bdate AND l_edate   #CHI-9A0021
                 #AND sfv05 NOT IN(SELECT jce02 FROM jce_file)   #MOD-6C0146 add
                 AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = sfv05)  #CHI-C80002
                 AND sfv04 <> l_ccg04
                 AND cjp01 = l_ccg04 
                 AND cjp02 = yy AND cjp03=mm
                 AND sfv04 = cjp04
             IF cl_null(l_s_cjp_rate1) THEN LET l_s_cjp_rate1 = 0 END IF 
             IF cl_null(l_s_cjp_rate2) THEN LET l_s_cjp_rate2 = 0 END IF 
             LET l_s_cjp_rate = l_s_cjp_rate1 + l_s_cjp_rate2
             IF l_ccg04 = g_ima01 THEN 
                 SELECT SUM(sfv09) INTO l_cjp_rate #MOD-620042 06
                   FROM sfu_file,sfv_file
                  WHERE sfu01=sfv01 AND sfupost='Y' AND sfv11=l_ccg01
                    AND sfu02 BETWEEN l_bdate AND l_edate   #CHI-9A0021
                    #AND sfv05 NOT IN(SELECT jce02 FROM jce_file)  
                    AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = sfv05)  #CHI-C80002
                    AND sfv04 = g_ima01
             ELSE 
                   #联产品入库数量，
                 SELECT SUM(sfv09*cjp06/100) INTO l_cjp_rate FROM sfv_file,sfu_file,cjp_file
                  WHERE sfv11=l_ccg01 AND sfv01=sfu01 AND sfupost='Y'   #TQC-620151
                    AND sfu02 BETWEEN l_bdate AND l_edate   #CHI-9A0021
                    #AND sfv05 NOT IN(SELECT jce02 FROM jce_file)   #MOD-6C0146 add
                    AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = sfv05)  #CHI-C80002
                    AND sfv04 <> l_ccg04
                    AND cjp01 = l_ccg04 
                    AND cjp02 = yy AND cjp03=mm
                    AND sfv04 = cjp04
                    AND sfv04 = g_ima01
             END IF 
             #No.130530001 ---end---
           LET l_sfv_rate=(l_cjp_rate/l_s_cjp_rate)*-1   #MOD-620042
         OTHERWISE
           #LET l_sfv_rate = l_sfv09/l_ccg31
           LET l_sfv_rate=l_sfv09_1/l_ccg31  #No.130530001
       END CASE
       IF cl_null(l_sfv_rate) THEN LET l_sfv_rate=-1 END IF
       LET l_ccg.ccg32a = l_ccg.ccg32a + (le_ccg.ccg32a * l_sfv_rate)
       LET l_ccg.ccg32b = l_ccg.ccg32b + (le_ccg.ccg32b * l_sfv_rate)
       LET l_ccg.ccg32c = l_ccg.ccg32c + (le_ccg.ccg32c * l_sfv_rate)
       LET l_ccg.ccg32d = l_ccg.ccg32d + (le_ccg.ccg32d * l_sfv_rate)
       LET l_ccg.ccg32e = l_ccg.ccg32e + (le_ccg.ccg32e * l_sfv_rate)
       LET l_ccg.ccg32f = l_ccg.ccg32f + (le_ccg.ccg32f * l_sfv_rate)   #FUN-7C0028 add
       LET l_ccg.ccg32g = l_ccg.ccg32g + (le_ccg.ccg32g * l_sfv_rate)   #FUN-7C0028 add
       LET l_ccg.ccg32h = l_ccg.ccg32h + (le_ccg.ccg32h * l_sfv_rate)   #FUN-7C0028 add

      #MOD-C40187 -- add start --
       LET l_ccg.ccg32a = cl_digcut(l_ccg.ccg32a,g_ccz.ccz26)
       LET l_ccg.ccg32b = cl_digcut(l_ccg.ccg32b,g_ccz.ccz26)
       LET l_ccg.ccg32c = cl_digcut(l_ccg.ccg32c,g_ccz.ccz26)
       LET l_ccg.ccg32d = cl_digcut(l_ccg.ccg32d,g_ccz.ccz26)
       LET l_ccg.ccg32e = cl_digcut(l_ccg.ccg32e,g_ccz.ccz26)
       LET l_ccg.ccg32f = cl_digcut(l_ccg.ccg32f,g_ccz.ccz26)
       LET l_ccg.ccg32g = cl_digcut(l_ccg.ccg32g,g_ccz.ccz26)
       LET l_ccg.ccg32h = cl_digcut(l_ccg.ccg32h,g_ccz.ccz26)
      #MOD-C40187 -- add end --
 
       LET le_ccg.ccg32 = le_ccg.ccg32a + le_ccg.ccg32b + le_ccg.ccg32c +
                          le_ccg.ccg32d + le_ccg.ccg32e
                         +le_ccg.ccg32f + le_ccg.ccg32g + le_ccg.ccg32h   #FUN-7C0028 add
       LET l_ccg.ccg32  = l_ccg.ccg32a + l_ccg.ccg32b + l_ccg.ccg32c +
                          l_ccg.ccg32d + l_ccg.ccg32e + l_ccg.ccg32
                         +l_ccg.ccg32f + l_ccg.ccg32g + l_ccg.ccg32h      #FUN-7C0028 add
 
       LET g_ccc.ccc28  = g_ccc.ccc28 +l_ccg.ccg32
       LET g_ccc.ccc28a = g_ccc.ccc28a+l_ccg.ccg32a
       LET g_ccc.ccc28b = g_ccc.ccc28b+l_ccg.ccg32b
       LET g_ccc.ccc28c = g_ccc.ccc28c+l_ccg.ccg32c
       LET g_ccc.ccc28d = g_ccc.ccc28d+l_ccg.ccg32d
       LET g_ccc.ccc28e = g_ccc.ccc28e+l_ccg.ccg32e
       LET g_ccc.ccc28f = g_ccc.ccc28f+l_ccg.ccg32f   #FUN-7C0028 add
       LET g_ccc.ccc28g = g_ccc.ccc28g+l_ccg.ccg32g   #FUN-7C0028 add
       LET g_ccc.ccc28h = g_ccc.ccc28h+l_ccg.ccg32h   #FUN-7C0028 add
       LET g_ccc.ccc28  = g_ccc.ccc28a+g_ccc.ccc28b+g_ccc.ccc28c+
                          g_ccc.ccc28d+g_ccc.ccc28e
                         +g_ccc.ccc28f+g_ccc.ccc28g+g_ccc.ccc28h   #FUN-7C0028 add
      #MOD-AB0126---mark---start---
      ##FUN-A20017--begin--add 入庫明細--
      ##當使用聯產品的時候,要計算生產入庫的入庫細項明細金額
      #SELECT sfb02 INTO l_sfb02 FROM sfb_file WHERE sfb01 = l_ccg01
      #IF l_sfb02 ! ='7' AND l_sfb02 != '8' THEN   #委外工單的部分,不需要計算進來
      #  #------------------------No:MOD-A90131 mark
      #  #內製重工工單入庫金額不應放在入庫細項上
      #  #LET g_ccc.ccc22a3=g_ccc.ccc22a3+l_ccg.ccg32a
      #  #LET g_ccc.ccc22b3=g_ccc.ccc22b3+l_ccg.ccg32b
      #  #LET g_ccc.ccc22c3=g_ccc.ccc22c3+l_ccg.ccg32c
      #  #LET g_ccc.ccc22d3=g_ccc.ccc22d3+l_ccg.ccg32d
      #  #LET g_ccc.ccc22e3=g_ccc.ccc22e3+l_ccg.ccg32e
      #  #LET g_ccc.ccc22f3=g_ccc.ccc22f3+l_ccg.ccg32f   #FUN-7C0028 add
      #  #LET g_ccc.ccc22g3=g_ccc.ccc22g3+l_ccg.ccg32g   #FUN-7C0028 add
      #  #LET g_ccc.ccc22h3=g_ccc.ccc22h3+l_ccg.ccg32h   #FUN-7C0028 add
      #  #------------------------No:MOD-A90131 end
      ##No.TQC-980002  --Begin
      #ELSE
      #   LET g_ccc.ccc22a2=g_ccc.ccc22a2+l_ccg.ccg32a
      #   LET g_ccc.ccc22b2=g_ccc.ccc22b2+l_ccg.ccg32b
      #   LET g_ccc.ccc22c2=g_ccc.ccc22c2+l_ccg.ccg32c
      #   LET g_ccc.ccc22d2=g_ccc.ccc22d2+l_ccg.ccg32d
      #   LET g_ccc.ccc22e2=g_ccc.ccc22e2+l_ccg.ccg32e
      #   LET g_ccc.ccc22f2=g_ccc.ccc22f2+l_ccg.ccg32f   #FUN-7C0028 add
      #   LET g_ccc.ccc22g2=g_ccc.ccc22g2+l_ccg.ccg32g   #FUN-7C0028 add
      #   LET g_ccc.ccc22h2=g_ccc.ccc22h2+l_ccg.ccg32h   #FUN-7C0028 add
      ##No.TQC-980002  --End  
      #END IF
      ##FUN-A20017--end--add----
      #MOD-AB0126---mark---end---
       IF NOT cl_null(l_ccg01) THEN
         #l_sfv09要寫入cce_file前,要先乘以轉換率ima55_fac,換算成庫存數量再寫入
          LET l_ima55_fac=0
          SELECT ima55_fac INTO l_ima55_fac FROM ima_file
           WHERE ima01=g_ima01
          IF cl_null(l_ima55_fac) OR l_ima55_fac=0 THEN LET l_ima55_fac=1 END IF
          LET l_sfv09 = l_sfv09 * l_ima55_fac
          INSERT INTO cce_file
             (cce01 ,cce02 ,cce03 ,cce04 ,cce05 ,cce06 ,cce07 ,          #FUN-7C0028 add cce06,07
              cce11 ,cce12 ,
              cce12a,cce12b,cce12c,cce12d,cce12e,cce12f,cce12g,cce12h,   #FUN-7C0028 add cce12f,g,h
              cce20 ,cce21 ,cce22 ,
              cce22a,cce22b,cce22c,cce22d,cce22e,cce22f,cce22g,cce22h,   #FUN-7C0028 add cce22f,g,h
              cce91 ,cce92 ,
              cce92a,cce92b,cce92c,cce92d,cce92e,cce92f,cce92g,cce92h,   #FUN-7C0028 add cce92f,g,h
             #cceuser,ccedate,ccetime,cceplant,ccelegal,cceoriu,cceorig) #No.MOD-470041 #FUN-980009 add cceplant,ccelegal    #FUN-A50075 mark
              cceuser,ccedate,ccetime,ccelegal,cceoriu,cceorig) #No.MOD-470041 #FUN-980009 add cceplant,ccelegal   #FUN-A50075 del plant
            VALUES(l_ccg01,yy,mm,g_ima01,' ',type,g_tlfcost,   #FUN-7C0028 add type,g_tlfcost
                   0,0,0,0,0,0,0,0,0,0,                        #FUN-7C0028 add 0,0,0
                   0,l_sfv09,l_ccg.ccg32,
                   l_ccg.ccg32a,l_ccg.ccg32b,l_ccg.ccg32c,l_ccg.ccg32d,
                   l_ccg.ccg32e,l_ccg.ccg32f,l_ccg.ccg32g,l_ccg.ccg32h,   #FUN-7C0028 add ccg32f,g,h
                   0,0,0,0,0,0,0,0,0,0,                        #FUN-7C0028 add 0,0,0
                  #g_user,TODAY,g_time,g_plant,g_legal, g_user, g_grup) #FUN-980009 add g_plant,g_legal      #No.FUN-980030 10/01/04  insert columns oriu, orig   #FUN-A50075 mark
                  #g_user,TODAY,g_time,g_legal, g_user, g_grup) #FUN-980009 add g_plant,g_legal      #No.FUN-980030 10/01/04  insert columns oriu, orig    #FUN-A50075 del plant #MOD-C30891 mark
                   g_user,TODAY,t_time,g_legal, g_user, g_grup) #FUN-980009 add g_plant,g_legal      #MOD-C30891  
          IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
             UPDATE cce_file
              SET cce21=l_sfv09,
                  cce22=l_ccg.ccg32,
                  cce22a=l_ccg.ccg32a,
                  cce22b=l_ccg.ccg32b,
                  cce22c=l_ccg.ccg32c,
                  cce22d=l_ccg.ccg32d,
                  cce22e=l_ccg.ccg32e,
                  cce22f=l_ccg.ccg32f,   #FUN-7C0028 add
                  cce22g=l_ccg.ccg32g,   #FUN-7C0028 add
                  cce22h=l_ccg.ccg32h,   #FUN-7C0028 add
                  cceuser=g_user,
                  ccedate=TODAY,
                 #ccetime=g_time #MOD-C30891 mark
                  ccetime=t_time #MOD-C30891 
              WHERE cce01=l_ccg01 AND cce02=yy AND cce03=mm
                AND cce04=g_ima01
                AND cce06=type    AND cce07=g_tlfcost   #FUN-7C0028 add
             IF SQLCA.SQLCODE THEN
                 CALL cl_err3("upd","cce_file",l_ccg01,yy,SQLCA.SQLCODE,"","ins cce_file:",1)   #No.FUN-660127
                 LET g_success='N'
             END IF
          END IF
       END IF
#FUN-A20017--begin--add---
#有關聯產品小數尾差的部分,針對ccc_file還是有問題，因為入爐金額有變更,理論上應該
#要重新計算以次月加權平均單價，且后面的期末結存及結存調整及所有的領用成本都會變動，
#后續會有影響,所有先拿掉
       IF type = '1' or type = '2' THEN  
          IF l_sfb02 ! ='7' AND l_sfb02 != '8' THEN
             SELECT COUNT( unique sfv04 ) INTO l_cnt1 
                FROM ccg_file,sfb_file,sfu_file,sfv_file
               WHERE ccg01=l_ccg01
                 AND ccg02=yy   AND ccg03=mm
                 AND ccg06=type
                 AND ccg07=g_tlfcost   #MOD-C60140 add
                 AND sfv11=sfb01
                 AND ccg01=sfb01
                 AND sfb02 IN (1,5) AND (sfb99='Y')
                 AND sfu01=sfv01 AND sfupost='Y'
                 #AND sfu02 BETWEEN l_bdate01 AND l_edate01  #MOD-B90058 mark
                 AND sfu02 BETWEEN l_bdate AND l_edate       #MOD-B90058 add
          ELSE
            #聯產品也要算
            SELECT COUNT( unique rvv31) INTO l_cnt1
                FROM ccg_file,sfb_file,rvu_file,rvv_file
               WHERE ccg01 =l_ccg01 AND ccg02 = yy AND ccg03 = mm
                 AND ccg06=type
                 AND ccg07=g_tlfcost   #MOD-C60140 add
                 AND rvv18=sfb01 AND ccg01=sfb01
                 #AND rvv34 = g_tlfcost
                 AND sfb02 IN (7,8)
                 AND (sfb99 ='Y')
                 AND rvu01=rvv01 AND rvuconf='Y'
                 #AND rvu03 BETWEEN l_bdate01 AND l_edate01 #MOD-B90058 mark
                 AND rvu03 BETWEEN l_bdate AND l_edate      #MOD-B90058 add
          END IF
       END IF     
        SELECT COUNT(*) INTO l_cnt2
          FROM cce_file
         WHERE cce01=l_ccg01
           AND cce02=yy   AND cce03=mm
#          AND cce06=type AND cce07=g_tlfcost
           AND cce06=type      
        IF l_cnt1=l_cnt2 and l_cnt1<>0 AND l_cnt2 <> 0 THEN
           INITIALIZE la_cce.* TO NULL
           INITIALIZE lb_cce.* TO NULL
           SELECT SUM(cce22a),SUM(cce22b),SUM(cce22c),SUM(cce22d),SUM(cce22e)
                 ,SUM(cce22f),SUM(cce22g),SUM(cce22h)   #FUN-7C0028 add
             INTO la_cce.cce22a, la_cce.cce22b, la_cce.cce22c,
                  la_cce.cce22d, la_cce.cce22e
                 ,la_cce.cce22f, la_cce.cce22g, la_cce.cce22h   #FUN-7C0028 add
            FROM cce_file
           WHERE cce01=l_ccg01
             AND cce02=yy   AND cce03=mm
#            AND cce06=type AND cce07=g_tlfcost   #FUN-7C0028 add #TQC-970003  mark
             AND cce06=type                       #TQC-970003 add
           IF cl_null(la_cce.cce22a) THEN LET la_cce.cce22a=0 END IF
           IF cl_null(la_cce.cce22b) THEN LET la_cce.cce22b=0 END IF
           IF cl_null(la_cce.cce22c) THEN LET la_cce.cce22d=0 END IF
           IF cl_null(la_cce.cce22d) THEN LET la_cce.cce22e=0 END IF
           IF cl_null(la_cce.cce22e) THEN LET la_cce.cce22e=0 END IF
           IF cl_null(la_cce.cce22f) THEN LET la_cce.cce22f=0 END IF   #FUN-7C0028 add
           IF cl_null(la_cce.cce22g) THEN LET la_cce.cce22g=0 END IF   #FUN-7C0028 add
           IF cl_null(la_cce.cce22h) THEN LET la_cce.cce22h=0 END IF   #FUN-7C0028 add
           LET la_cce.cce22=la_cce.cce22a+ la_cce.cce22b+ la_cce.cce22c+
                            la_cce.cce22d+ la_cce.cce22e
                           +la_cce.cce22f+ la_cce.cce22g+ la_cce.cce22h   #FUN-7C0028 add
           LET lb_cce.cce22a=le_ccg.ccg32a*-1 - la_cce.cce22a
           LET lb_cce.cce22b=le_ccg.ccg32b*-1 - la_cce.cce22b
           LET lb_cce.cce22c=le_ccg.ccg32c*-1 - la_cce.cce22c
           LET lb_cce.cce22d=le_ccg.ccg32d*-1 - la_cce.cce22d
           LET lb_cce.cce22e=le_ccg.ccg32e*-1 - la_cce.cce22e
           LET lb_cce.cce22f=le_ccg.ccg32f*-1 - la_cce.cce22f   #FUN-7C0028 add
           LET lb_cce.cce22g=le_ccg.ccg32g*-1 - la_cce.cce22g   #FUN-7C0028 add
           LET lb_cce.cce22h=le_ccg.ccg32h*-1 - la_cce.cce22h   #FUN-7C0028 add
           LET lb_cce.cce22=lb_cce.cce22a+ lb_cce.cce22b+ lb_cce.cce22c+
                            lb_cce.cce22d+ lb_cce.cce22e
                           +lb_cce.cce22f+ lb_cce.cce22g+ lb_cce.cce22h   #FUN-7C0028 add
          #IF lb_cce.cce22 <> 0 THEN       #MOD-C50078 mark
          #MOD-C50078 str add-----
           IF lb_cce.cce22a <> 0 OR lb_cce.cce22b <> 0 OR lb_cce.cce22c <> 0 OR lb_cce.cce22d <> 0 OR
              lb_cce.cce22e <> 0 OR lb_cce.cce22f <> 0 OR lb_cce.cce22g <> 0 OR lb_cce.cce22h <> 0 THEN
          #MOD-C50078 end add-----
             LET g_ccc.ccc28  = g_ccc.ccc28 +lb_cce.cce22
             LET g_ccc.ccc28a = g_ccc.ccc28a+lb_cce.cce22a
             LET g_ccc.ccc28b = g_ccc.ccc28b+lb_cce.cce22b
             LET g_ccc.ccc28c = g_ccc.ccc28c+lb_cce.cce22c
             LET g_ccc.ccc28d = g_ccc.ccc28d+lb_cce.cce22d
             LET g_ccc.ccc28e = g_ccc.ccc28e+lb_cce.cce22e
             LET g_ccc.ccc28f = g_ccc.ccc28f+lb_cce.cce22f   #FUN-7C0028 add
             LET g_ccc.ccc28g = g_ccc.ccc28g+lb_cce.cce22g   #FUN-7C0028 add
             LET g_ccc.ccc28h = g_ccc.ccc28h+lb_cce.cce22h   #FUN-7C0028 add
             LET g_ccc.ccc28  = g_ccc.ccc28a+g_ccc.ccc28b+g_ccc.ccc28c+
                                g_ccc.ccc28d+g_ccc.ccc28e
                               +g_ccc.ccc28f+g_ccc.ccc28g+ g_ccc.ccc28h   #FUN-7C0028 add

            #-------------No:MOD-AC0153 mark
            #LET g_ccc.ccc223 =g_ccc.ccc223 +lb_cce.cce22
            #LET g_ccc.ccc22a3=g_ccc.ccc22a3+lb_cce.cce22a
            #LET g_ccc.ccc22b3=g_ccc.ccc22b3+lb_cce.cce22b
            #LET g_ccc.ccc22c3=g_ccc.ccc22c3+lb_cce.cce22c
            #LET g_ccc.ccc22d3=g_ccc.ccc22d3+lb_cce.cce22d
            #LET g_ccc.ccc22e3=g_ccc.ccc22e3+lb_cce.cce22e
            #LET g_ccc.ccc22f3=g_ccc.ccc22f3+lb_cce.cce22f  #FUN-7C0028 add
            #LET g_ccc.ccc22g3=g_ccc.ccc22g3+lb_cce.cce22g  #FUN-7C0028 add
            #LET g_ccc.ccc22h3=g_ccc.ccc22h3+lb_cce.cce22h  #FUN-7C0028 add
            #-------------No:MOD-AC0153 end

             UPDATE cce_file
              SET cce22  = cce22  + lb_cce.cce22,
                  cce22a = cce22a + lb_cce.cce22a,
                  cce22b = cce22b + lb_cce.cce22b,
                  cce22c = cce22c + lb_cce.cce22c,
                  cce22d = cce22d + lb_cce.cce22d,
                  cce22e = cce22e + lb_cce.cce22e,
                  cce22f = cce22f + lb_cce.cce22f,   #FUN-7C0028 add
                  cce22g = cce22g + lb_cce.cce22g,   #FUN-7C0028 add
                  cce22h = cce22h + lb_cce.cce22h,   #FUN-7C0028 add
                  cceuser= g_user,
                  ccedate= TODAY,
                 #ccetime= g_time #MOD-C30891 mark
                  ccetime= t_time #MOD-C30891 
              WHERE cce01=l_ccg01 AND cce02=yy AND cce03=mm
                AND cce04=g_ima01
                AND cce06=type AND cce07=g_tlfcost   #FUN-7C0028 add
              IF SQLCA.SQLCODE THEN
                  CALL cl_err3("upd","cce_file",l_ccg01,yy,SQLCA.SQLCODE,"","upd cce_file:",1)   
                  LET g_success='N'
              END IF
           END IF
        END IF

#FUN-A20017--end--add----------------
 
       LET le_ccg.ccg32=0  LET le_ccg.ccg32a=0 LET le_ccg.ccg32b=0
       LET le_ccg.ccg32c=0 LET le_ccg.ccg32d=0 LET le_ccg.ccg32e=0
       LET le_ccg.ccg32f=0 LET le_ccg.ccg32g=0 LET le_ccg.ccg32h=0   #FUN-7C0028 add
       LET l_ccg.ccg32 =0  LET l_ccg.ccg32a =0 LET l_ccg.ccg32b =0
       LET l_ccg.ccg32c=0  LET l_ccg.ccg32d =0 LET l_ccg.ccg32e =0
       LET l_ccg.ccg32f=0  LET l_ccg.ccg32g=0  LET l_ccg.ccg32h=0    #FUN-7C0028 add
       LET l_sfv09=0       LET l_ccg31=0
     END FOREACH
   END IF
END FUNCTION
 
FUNCTION p500_ccg3_cost()        # 加上WIP入庫金額
   DEFINE l_ccg       RECORD LIKE ccg_file.*
   DEFINE le_ccg      RECORD LIKE ccg_file.*
   DEFINE l_sfv09     LIKE sfv_file.sfv09
   DEFINE l_ccg31     LIKE ccg_file.ccg31
  #DEFINE l_sfv_rate  LIKE col_file.col08         #No:FUN-680122DEC(9,5) #MOD-B60127 mark
   DEFINE l_sfv_rate  LIKE type_file.num26_10     #MOD-B60127 add
   DEFINE l_cjp_rate  LIKE rvv_file.rvv17
   DEFINE l_s_cjp_rate LIKE rvv_file.rvv17
   DEFINE l_ccg01     LIKE ccg_file.ccg01
   DEFINE l_reccg31   LIKE ccg_file.ccg31
   DEFINE l_sfb02     LIKE sfb_file.sfb02       #MOD-4B0055 add
   DEFINE l_sql       LIKE type_file.chr1000    #MOD-530234        #No.FUN-680122CHAR(2000)
   DEFINE l_cnt       LIKE type_file.num5       #FUN-630059        #No.FUN-680122 SMALLINT
   DEFINE l_ima55_fac LIKE ima_file.ima55_fac   #MOD-860183 add
   DEFINE l_bdate     LIKE type_file.dat        #CHI-9A0021 add
   DEFINE l_edate     LIKE type_file.dat        #CHI-9A0021 add
   DEFINE l_correct   LIKE type_file.chr1       #CHI-9A0021 add
   #No.130530001 ---begin---
   DEFINE l_ccg04     LIKE ccg_file.ccg04       
   DEFINE l_reccg31_1   LIKE ccg_file.ccg31    
   DEFINE l_reccg31_2   LIKE ccg_file.ccg31     
   DEFINE l_s_cjp_rate1 LIKE rvv_file.rvv17
   DEFINE l_s_cjp_rate2 LIKE rvv_file.rvv17
   DEFINE l_sfv09_1      LIKE sfv_file.sfv09
   
   INITIALIZE l_ccg04 TO NULL 
   LET l_reccg31_1 = 0  LET l_reccg31_2 = 0
   LET l_s_cjp_rate1 = 0 LET l_s_cjp_rate2 = 0 
   LET l_sfv09_1 = 0 
   #No.130530001 ---end---
    
   LET l_ccg.ccg32 =0  LET l_ccg.ccg32a=0  LET l_ccg.ccg32b=0
   LET l_ccg.ccg32c=0  LET l_ccg.ccg32d=0  LET l_ccg.ccg32e=0
   LET l_ccg.ccg32f=0  LET l_ccg.ccg32g=0  LET l_ccg.ccg32h=0   #FUN-7C0028 add
 
   LET le_ccg.ccg32 =0 LET le_ccg.ccg32a=0 LET le_ccg.ccg32b=0
   LET le_ccg.ccg32c=0 LET le_ccg.ccg32d=0 LET le_ccg.ccg32e=0
   LET le_ccg.ccg32f=0 LET le_ccg.ccg32g=0 LET le_ccg.ccg32h=0   #FUN-7C0028 add
   LET l_ccg31=0       LET l_sfv09=0
 
  #當月起始日與截止日
   CALL s_azm(yy,mm) RETURNING l_correct,l_bdate,l_edate   #CHI-9A0021 add

   #重新抓取ima905
   SELECT ima905 INTO g_ima905 FROM ima_file WHERE ima01=g_ima01   #CHI-7B0022 add
   IF cl_null(g_ima905) THEN LET g_ima905 ='N' END IF              #CHI-7B0022 add
   IF (g_sma.sma104 = 'N' OR g_ima905 ='N') AND type <> '3' THEN
     SELECT SUM(ccg32 *-1),SUM(ccg32a*-1),SUM(ccg32b*-1),
            SUM(ccg32c*-1),SUM(ccg32d*-1),SUM(ccg32e*-1)
           ,SUM(ccg32f*-1),SUM(ccg32g*-1),SUM(ccg32h*-1)   #FUN-7C0028 add
       INTO l_ccg.ccg32, l_ccg.ccg32a,l_ccg.ccg32b,
            l_ccg.ccg32c,l_ccg.ccg32d,l_ccg.ccg32e
           ,l_ccg.ccg32f,l_ccg.ccg32g,l_ccg.ccg32h   #FUN-7C0028 add
       FROM ccg_file
      WHERE ccg04=g_ima01 AND ccg02=yy AND ccg03=mm
        AND ccg06=type 
        AND ccg07=g_tlfcost   #MOD-C60140 add
     IF l_ccg.ccg32 IS NULL THEN
        LET l_ccg.ccg32 =0 LET l_ccg.ccg32a=0 LET l_ccg.ccg32b=0
        LET l_ccg.ccg32c=0 LET l_ccg.ccg32d=0 LET l_ccg.ccg32e=0
        LET l_ccg.ccg32f=0 LET l_ccg.ccg32g=0 LET l_ccg.ccg32h=0   #FUN-7C0028 add
     END IF
     LET g_ccc.ccc22 =g_ccc.ccc22 +l_ccg.ccg32
     LET g_ccc.ccc22a=g_ccc.ccc22a+l_ccg.ccg32a
     LET g_ccc.ccc22b=g_ccc.ccc22b+l_ccg.ccg32b
     LET g_ccc.ccc22c=g_ccc.ccc22c+l_ccg.ccg32c
     LET g_ccc.ccc22d=g_ccc.ccc22d+l_ccg.ccg32d
     LET g_ccc.ccc22e=g_ccc.ccc22e+l_ccg.ccg32e
     LET g_ccc.ccc22f=g_ccc.ccc22f+l_ccg.ccg32f   #FUN-7C0028 add
     LET g_ccc.ccc22g=g_ccc.ccc22g+l_ccg.ccg32g   #FUN-7C0028 add
     LET g_ccc.ccc22h=g_ccc.ccc22h+l_ccg.ccg32h   #FUN-7C0028 add
   ELSE
     LET l_ccg.ccg32 =0  LET l_ccg.ccg32a=0  LET l_ccg.ccg32b=0
     LET l_ccg.ccg32c=0  LET l_ccg.ccg32d=0  LET l_ccg.ccg32e=0
     LET l_ccg.ccg32f=0  LET l_ccg.ccg32g=0  LET l_ccg.ccg32h=0   #FUN-7C0028 add
 
     LET le_ccg.ccg32 =0 LET le_ccg.ccg32a=0 LET le_ccg.ccg32b=0
     LET le_ccg.ccg32c=0 LET le_ccg.ccg32d=0 LET le_ccg.ccg32e=0
     LET le_ccg.ccg32f=0 LET le_ccg.ccg32g=0 LET le_ccg.ccg32h=0   #FUN-7C0028 add
     LET l_ccg31=0       LET l_sfv09=0
 
     #找聯產品入庫料號,計算聯產品轉出成本
     LET l_sql = "SELECT ccg01,ccg32,ccg32a,ccg32b,ccg32c,ccg32d,ccg32e,",   #TQC-620151
                 "       ccg32f,ccg32g,ccg32h,",   #FUN-7C0028 add
		 "       ccg31,SUM(sfv09)",
                 "  FROM ccg_file,sfu_file,sfv_file",
                 "  WHERE ccg02=",yy ," AND ccg03=",mm,
                 "    AND ccg06='",type,"'",
                 "    AND ccg07='",g_tlfcost,"'",         #MOD-C60140 add
		 "    AND sfv04='",g_ima01 CLIPPED,"'",   #TQC-620151
                 "    AND ccg01=sfv11 AND sfu01=sfv01 AND sfupost='Y'",
                 "    AND sfu02 BETWEEN '",l_bdate,"' AND '",l_edate,"'",
                 #排除非成本庫的資料
                 #"    AND sfv05 NOT IN(SELECT jce02 FROM jce_file)",   #MOD-6C0146 add #CHI-C80002
                 "    AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = sfv05)", #CHI-C80002
                 "  GROUP BY ccg01,ccg32,ccg32a,ccg32b,ccg32c,ccg32d,ccg32e,ccg32f,ccg32g,ccg32h,ccg31"   #TQC-620151   #FUN-7C0028 add ccg32f,g,h
 
     PREPARE p500_ccg3_p1 FROM l_sql
     DECLARE p500_ccg3_c1 CURSOR FOR p500_ccg3_p1
 
     LET l_cnt=0 #FUN-630059
     FOREACH p500_ccg3_c1 INTO l_ccg01,le_ccg.ccg32,le_ccg.ccg32a,le_ccg.ccg32b,
                               le_ccg.ccg32c,le_ccg.ccg32d,le_ccg.ccg32e,
                               le_ccg.ccg32f,le_ccg.ccg32g,le_ccg.ccg32h,   #FUN-7C0028 add
                               l_ccg31,l_sfv09
       LET l_cnt=l_cnt+1  #FUN-630059
       #本月轉出金額
       IF le_ccg.ccg32 IS NULL THEN
          LET le_ccg.ccg32 =0 LET le_ccg.ccg32a=0 LET le_ccg.ccg32b=0
          LET le_ccg.ccg32c=0 LET le_ccg.ccg32d=0 LET le_ccg.ccg32e=0
          LET le_ccg.ccg32f=0 LET le_ccg.ccg32g=0 LET le_ccg.ccg32h=0   #FUN-7C0028 add
          LET l_ccg31=0       LET l_sfv09=0
       END IF
       IF cl_null(l_ccg31) THEN LET l_ccg31=0 END IF
       IF cl_null(l_sfv09) THEN LET l_sfv09=0 END IF

       #No.130530001 ---begin---
       SELECT sfb05 INTO l_ccg04 FROM sfb_file WHERE sfb01 = l_ccg01
       LET l_sfv09_1 = l_sfv09 
       #No.130530001 ---end---
 
       #工單重新sum(sfv09)成品轉出量(sum入庫單,不sum ccg以免有cce>ccg數量的情況)
       LET l_reccg31=0
       #SELECT SUM(sfv09) INTO l_reccg31 FROM sfv_file,sfu_file
      #产成品完工数量
       SELECT SUM(sfv09) INTO l_reccg31_1 FROM sfv_file,sfu_file  #No.130530001       
        WHERE sfv11=l_ccg01 AND sfv01=sfu01 AND sfupost='Y'   #TQC-620151
          AND sfu02 BETWEEN l_bdate AND l_edate   #CHI-9A0021
          #排除非成本庫的資料
          #AND sfv05 NOT IN(SELECT jce02 FROM jce_file)   #MOD-6C0146 add #CHI-C80002
          AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = sfv05)  #CHI-C80002
          AND sfv04 = l_ccg04   #No.130530001
      #No.130530001 ---begin---
      #联产品入库数量，有单位转换率
      SELECT SUM(sfv09) INTO l_reccg31_2 FROM sfv_file,sfu_file
       WHERE sfv11=l_ccg01 AND sfv01=sfu01 AND sfupost='Y'   #TQC-620151
          AND sfu02 BETWEEN l_bdate AND l_edate   #CHI-9A0021
          #排除非成本庫的資料
          #AND sfv05 NOT IN(SELECT jce02 FROM jce_file)   #MOD-6C0146 add
          AND sfv04 <> l_ccg04
          AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = sfv05)  #CHI-C80002
       IF cl_null(l_reccg31_1) THEN LET l_reccg31_1 = 0 END IF 
       IF cl_null(l_reccg31_2) THEN LET l_reccg31_2 = 0 END IF 
       LET l_reccg31 = l_reccg31_1 + l_reccg31_2
      #No.130530001 ---end---          
       IF cl_null(l_reccg31) THEN LET l_reccg31=0 END IF
       LET l_ccg31=l_reccg31*-1
 
       CASE g_ccz.ccz13
         WHEN '1'    # 完工比例
           #LET l_sfv_rate=l_sfv09/l_ccg31
           LET l_sfv_rate =l_sfv09_1/l_ccg31  #No.130530001
         WHEN '2'    # 依分配例
           # 入庫*比例/SUM(入庫*比例)*要分攤的金額
           LET l_s_cjp_rate=0  #MOD-620042 06=0    #SUM(入庫*比例)
           #No.130530001 ---begin---
           #抓取产成品数量
           SELECT SUM(sfv09) INTO l_s_cjp_rate1 #MOD-620042 06
             FROM sfu_file,sfv_file
            WHERE sfu01=sfv01 AND sfupost='Y' AND sfv11=l_ccg01
              AND sfu02 BETWEEN l_bdate AND l_edate   #CHI-9A0021
              #AND sfv05 NOT IN(SELECT jce02 FROM jce_file)  
              AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = sfv05)  #CHI-C80002
              AND sfv04 = l_ccg04
                 #联产品入库数量，
           SELECT SUM(sfv09*cjp06/100) INTO l_s_cjp_rate2 FROM sfv_file,sfu_file,cjp_file
            WHERE sfv11=l_ccg01 AND sfv01=sfu01 AND sfupost='Y'   #TQC-620151
              AND sfu02 BETWEEN l_bdate AND l_edate   #CHI-9A0021
               #AND sfv05 NOT IN(SELECT jce02 FROM jce_file)   #MOD-6C0146 add
               AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = sfv05)  #CHI-C80002
               AND sfv04 <> l_ccg04
               AND cjp01 = l_ccg04 
               AND cjp02 = yy AND cjp03=mm
               AND sfv04 = cjp04
           IF cl_null(l_s_cjp_rate1) THEN LET l_s_cjp_rate1 = 0 END IF 
           IF cl_null(l_s_cjp_rate2) THEN LET l_s_cjp_rate2 = 0 END IF 
           LET l_s_cjp_rate = l_s_cjp_rate1 + l_s_cjp_rate2
           IF l_ccg04 = g_ima01 THEN 
               SELECT SUM(sfv09) INTO l_cjp_rate #MOD-620042 06
                 FROM sfu_file,sfv_file
                WHERE sfu01=sfv01 AND sfupost='Y' AND sfv11=l_ccg01
                  AND sfu02 BETWEEN l_bdate AND l_edate   #CHI-9A0021
                 # AND sfv05 NOT IN(SELECT jce02 FROM jce_file)  
                  AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = sfv05)  #CHI-C80002
                  AND sfv04 = g_ima01
           ELSE 
                 #联产品入库数量，有单位转换率
               SELECT SUM(sfv09*cjp06/100) INTO l_cjp_rate FROM sfv_file,sfu_file,cjp_file
                WHERE sfv11=l_ccg01 AND sfv01=sfu01 AND sfupost='Y'   #TQC-620151
                  AND sfu02 BETWEEN l_bdate AND l_edate   #CHI-9A0021
                  #AND sfv05 NOT IN(SELECT jce02 FROM jce_file)   #MOD-6C0146 add
                  AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = sfv05)  #CHI-C80002
                  AND sfv04 <> l_ccg04
                  AND cjp01 = l_ccg04 
                  AND cjp02 = yy AND cjp03=mm
                  AND sfv04 = cjp04
                  AND sfv04 = g_ima01
           END IF 
           #No.130530001 ---end---    
           #No.130530001 ---mark begin---                   
#           SELECT SUM(sfv09*cjp06) INTO l_s_cjp_rate #MOD-620042 06
#             FROM cjp_file,sfu_file,sfv_file
#            WHERE cjp01=g_ima01 AND cjp02=yy AND cjp03=mm
#              AND sfv04=cjp04
#              AND sfu01=sfv01 AND sfupost='Y' AND sfv11=g_ima01
#              AND sfu02 BETWEEN l_bdate AND l_edate   #CHI-9A0021
#              #AND sfv05 NOT IN(SELECT jce02 FROM jce_file)           #MOD-C70092 add #CHI-C80002
#              AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = sfv05)  #CHI-C80002
#           LET l_cjp_rate=0  #MOD-620042 06=0      #該聯產品分配率
#           SELECT SUM(cjp06*sfv09) INTO l_cjp_rate #MOD-620042 06
#             FROM cjp_file,sfu_file,sfv_file
#            WHERE cjp01=g_ima01 AND cjp02=yy AND cjp03=mm
#              AND sfv04=cjp04 AND cjp04=l_ccg01
#              AND sfu01=sfv01 AND sfupost='Y' AND sfv11=g_ima01
#              AND sfu02 BETWEEN l_bdate AND l_edate   #CHI-9A0021
#              #AND sfv05 NOT IN(SELECT jce02 FROM jce_file)           #MOD-C70092 add #CHI-C80002
#              AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = sfv05)  #CHI-C80002
           #No.130530001 ---mark end---  
           LET l_sfv_rate=(l_cjp_rate/l_s_cjp_rate)*-1 #MOD-620042
         OTHERWISE
           #LET l_sfv_rate = l_sfv09/l_ccg31
           LET l_sfv_rate =l_sfv09_1/l_ccg31  #No.130530001
       END CASE
       IF cl_null(l_sfv_rate) THEN LET l_sfv_rate=-1 END IF
       LET l_ccg.ccg32a = l_ccg.ccg32a + (le_ccg.ccg32a * l_sfv_rate)
       LET l_ccg.ccg32b = l_ccg.ccg32b + (le_ccg.ccg32b * l_sfv_rate)
       LET l_ccg.ccg32c = l_ccg.ccg32c + (le_ccg.ccg32c * l_sfv_rate)
       LET l_ccg.ccg32d = l_ccg.ccg32d + (le_ccg.ccg32d * l_sfv_rate)
       LET l_ccg.ccg32e = l_ccg.ccg32e + (le_ccg.ccg32e * l_sfv_rate)
       LET l_ccg.ccg32f = l_ccg.ccg32f + (le_ccg.ccg32f * l_sfv_rate)   #FUN-7C0028 add
       LET l_ccg.ccg32g = l_ccg.ccg32g + (le_ccg.ccg32g * l_sfv_rate)   #FUN-7C0028 add
       LET l_ccg.ccg32h = l_ccg.ccg32h + (le_ccg.ccg32g * l_sfv_rate)   #FUN-7C0028 add

      #MOD-C40187 -- add start --
       LET l_ccg.ccg32a = cl_digcut(l_ccg.ccg32a,g_ccz.ccz26)
       LET l_ccg.ccg32b = cl_digcut(l_ccg.ccg32b,g_ccz.ccz26)
       LET l_ccg.ccg32c = cl_digcut(l_ccg.ccg32c,g_ccz.ccz26)
       LET l_ccg.ccg32d = cl_digcut(l_ccg.ccg32d,g_ccz.ccz26)
       LET l_ccg.ccg32e = cl_digcut(l_ccg.ccg32e,g_ccz.ccz26)
       LET l_ccg.ccg32f = cl_digcut(l_ccg.ccg32f,g_ccz.ccz26)
       LET l_ccg.ccg32g = cl_digcut(l_ccg.ccg32g,g_ccz.ccz26)
       LET l_ccg.ccg32h = cl_digcut(l_ccg.ccg32h,g_ccz.ccz26)
      #MOD-C40187 -- add end --
 
       LET le_ccg.ccg32 = le_ccg.ccg32a + le_ccg.ccg32b + le_ccg.ccg32c +
                          le_ccg.ccg32d + le_ccg.ccg32e
                         +le_ccg.ccg32f + le_ccg.ccg32g + le_ccg.ccg32h   #FUN-7C0028 add
       LET l_ccg.ccg32  = l_ccg.ccg32a + l_ccg.ccg32b + l_ccg.ccg32c +
                          l_ccg.ccg32d + l_ccg.ccg32e + l_ccg.ccg32
                         +l_ccg.ccg32f + l_ccg.ccg32g + l_ccg.ccg32h   #FUN-7C0028 add
 
       LET g_ccc.ccc22  = g_ccc.ccc22 +l_ccg.ccg32
       LET g_ccc.ccc22a = g_ccc.ccc22a+l_ccg.ccg32a
       LET g_ccc.ccc22b = g_ccc.ccc22b+l_ccg.ccg32b
       LET g_ccc.ccc22c = g_ccc.ccc22c+l_ccg.ccg32c
       LET g_ccc.ccc22d = g_ccc.ccc22d+l_ccg.ccg32d
       LET g_ccc.ccc22e = g_ccc.ccc22e+l_ccg.ccg32e
       LET g_ccc.ccc22f = g_ccc.ccc22f+l_ccg.ccg32f   #FUN-7C0028 add
       LET g_ccc.ccc22g = g_ccc.ccc22g+l_ccg.ccg32g   #FUN-7C0028 add
       LET g_ccc.ccc22h = g_ccc.ccc22h+l_ccg.ccg32h   #FUN-7C0028 add
       LET g_ccc.ccc22  = g_ccc.ccc22a+g_ccc.ccc22b+g_ccc.ccc22c+
                          g_ccc.ccc22d+g_ccc.ccc22e
                         +g_ccc.ccc22f+g_ccc.ccc22g+g_ccc.ccc22h   #FUN-7C0028 add
       IF NOT cl_null(l_ccg01) THEN
         #l_sfv09要寫入cce_file前,要先乘以轉換率ima55_fac,換算成庫存數量再寫入
          LET l_ima55_fac=0
          SELECT ima55_fac INTO l_ima55_fac FROM ima_file
           WHERE ima01=g_ima01
          IF cl_null(l_ima55_fac) OR l_ima55_fac=0 THEN LET l_ima55_fac=1 END IF
          LET l_sfv09 = l_sfv09 * l_ima55_fac
          INSERT INTO cce_file
             (cce01 ,cce02 ,cce03 ,cce04 ,cce05 ,cce06 ,cce07 ,          #FUN-7C0028 add cce06,07
              cce11 ,cce12 ,
              cce12a,cce12b,cce12c,cce12d,cce12e,cce12f,cce12g,cce12h,   #FUN-7C0028 add cce12f,g,h
              cce20 ,cce21 ,cce22 ,
              cce22a,cce22b,cce22c,cce22d,cce22e,cce22f,cce22g,cce22h,   #FUN-7C0028 add cce22f,g,h
              cce91 ,cce92 ,
              cce92a,cce92b,cce92c,cce92d,cce92e,cce92f,cce92g,cce92h,   #FUN-7C0028 add cce92f,g,h
             #cceuser,ccedate,ccetime,cceplant,ccelegal,cceoriu,cceorig) #No.MOD-470041 #FUN-980009 add cceplant,ccelegal    #FUN-A50075 
              cceuser,ccedate,ccetime,ccelegal,cceoriu,cceorig)          #FUN-A50075 del plant
            VALUES(l_ccg01,yy,mm,g_ima01,' ',type,g_tlfcost,   #FUN-7C0028 add type,g_tlfcost
                   0,0,0,0,0,0,0,0,0,0,                        #FUN-7C0028 add 0,0,0
                   0,l_sfv09,l_ccg.ccg32,
                   l_ccg.ccg32a,l_ccg.ccg32b,l_ccg.ccg32c,l_ccg.ccg32d,
                   l_ccg.ccg32e,l_ccg.ccg32f,l_ccg.ccg32g,l_ccg.ccg32h,   #FUN-7C0028 add ccg32f,g,h
                   0,0,0,0,0,0,0,0,0,0,                        #FUN-7C0028 add 0,0,0
                  #g_user,TODAY,g_time,g_plant,g_legal, g_user, g_grup) #FUN-980009 add g_plant,g_legal      #No.FUN-980030 10/01/04  insert columns oriu, orig  #FUN-A50075 mark
                  #g_user,TODAY,g_time,g_legal, g_user, g_grup)         #FUN-A50075 del plant #MOD-C30891 mark
                   g_user,TODAY,t_time,g_legal, g_user, g_grup)         #MOD-C30891 mark 
          IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
             UPDATE cce_file
                SET cce21 =l_sfv09,
                    cce22 =l_ccg.ccg32,
                    cce22a=l_ccg.ccg32a,
                    cce22b=l_ccg.ccg32b,
                    cce22c=l_ccg.ccg32c,
                    cce22d=l_ccg.ccg32d,
                    cce22e=l_ccg.ccg32e,
                    cce22f=l_ccg.ccg32f,   #FUN-7C0028 add
                    cce22g=l_ccg.ccg32g,   #FUN-7C0028 add
                    cce22g=l_ccg.ccg32h,   #FUN-7C0028 add
                    cceuser=g_user,
                    ccedate=TODAY,
                   #ccetime=g_time #MOD-C30891 mark
                    ccetime=t_time #MOD-C30891
              WHERE cce01=l_ccg01 AND cce02=yy AND cce03=mm
                AND cce04=g_ima01
                AND cce06=type    AND cce07=g_tlfcost   #FUN-7C0028 add
             IF SQLCA.SQLCODE THEN
                 CALL cl_err3("upd","cce_file",l_ccg01,yy,SQLCA.SQLCODE,"","ins cce_file:",1)   #No.FUN-660127
                 LET g_success='N'
             END IF
          END IF
       END IF
 
       LET le_ccg.ccg32 =0 LET le_ccg.ccg32a=0 LET le_ccg.ccg32b=0
       LET le_ccg.ccg32c=0 LET le_ccg.ccg32d=0 LET le_ccg.ccg32e=0
       LET le_ccg.ccg32f=0 LET le_ccg.ccg32g=0 LET le_ccg.ccg32h=0   #FUN-7C0028 add
       LET l_ccg.ccg32  =0 LET l_ccg.ccg32a =0 LET l_ccg.ccg32b =0
       LET l_ccg.ccg32c =0 LET l_ccg.ccg32d =0 LET l_ccg.ccg32e =0
       LET l_ccg.ccg32f=0  LET l_ccg.ccg32g=0  LET l_ccg.ccg32h=0   #FUN-7C0028 add
       LET l_sfv09=0       LET l_ccg31=0
     END FOREACH
     IF l_cnt=0 THEN
        SELECT SUM(ccg32 *-1),SUM(ccg32a*-1),SUM(ccg32b*-1),
               SUM(ccg32c*-1),SUM(ccg32d*-1),SUM(ccg32e*-1)
              ,SUM(ccg32f*-1),SUM(ccg32g*-1),SUM(ccg32h*-1)   #FUN-7C0028 add
          INTO l_ccg.ccg32, l_ccg.ccg32a,l_ccg.ccg32b,
               l_ccg.ccg32c,l_ccg.ccg32d,l_ccg.ccg32e
              ,l_ccg.ccg32f,l_ccg.ccg32g,l_ccg.ccg32h   #FUN-7C0028 add
          FROM ccg_file
         WHERE ccg04=g_ima01 AND ccg02=yy AND ccg03=mm
           AND ccg06=type
        IF l_ccg.ccg32 IS NULL THEN
           LET l_ccg.ccg32 =0 LET l_ccg.ccg32a=0 LET l_ccg.ccg32b=0
           LET l_ccg.ccg32c=0 LET l_ccg.ccg32d=0 LET l_ccg.ccg32e=0
           LET l_ccg.ccg32f=0 LET l_ccg.ccg32g=0 LET l_ccg.ccg32h=0   #FUN-7C0028 add
        END IF
        LET g_ccc.ccc22 =g_ccc.ccc22 +l_ccg.ccg32
        LET g_ccc.ccc22a=g_ccc.ccc22a+l_ccg.ccg32a
        LET g_ccc.ccc22b=g_ccc.ccc22b+l_ccg.ccg32b
        LET g_ccc.ccc22c=g_ccc.ccc22c+l_ccg.ccg32c
        LET g_ccc.ccc22d=g_ccc.ccc22d+l_ccg.ccg32d
        LET g_ccc.ccc22e=g_ccc.ccc22e+l_ccg.ccg32e
        LET g_ccc.ccc22f=g_ccc.ccc22f+l_ccg.ccg32f   #FUN-7C0028 add
        LET g_ccc.ccc22g=g_ccc.ccc22g+l_ccg.ccg32g   #FUN-7C0028 add
        LET g_ccc.ccc22h=g_ccc.ccc22h+l_ccg.ccg32h   #FUN-7C0028 add
     END IF
   END IF
END FUNCTION
 
FUNCTION p500_tlf15_upd()       #更新會計科目
   DEFINE l_invno,actno_d,actno_c       LIKE ima_file.ima39            #No.FUN-680122CHAR(24)
   DEFINE l_ware,l_loc                  LIKE tlf_file.tlf021           #No.FUN-680122CHAR(10)
   #FUN-BB0038 --begin 
   DEFINE actno_d1,actno_d2             LIKE tlf_file.tlf15 
   DEFINE actno_c1,actno_c2             LIKE tlf_file.tlf15
   DEFINE l_ool01                       LIKE ool_file.ool01  
   DEFINE l_tlf14                       LIKE tlf_file.tlf14
   DEFINE l_tlf19                       LIKE tlf_file.tlf19
   DEFINE l_ooz08                       LIKE ooz_file.ooz08
   #FUN-BB0038 --end 
   
    
   #FUN-BB0038 --begin   
 #  IF g_smy53='N' OR g_smy53 IS NULL THEN RETURN END IF
 #
 #  IF q_tlf.tlf02 = 50
 #     THEN LET l_ware=q_tlf.tlf021 LET l_loc=q_tlf.tlf022
 #     ELSE LET l_ware=q_tlf.tlf031 LET l_loc=q_tlf.tlf032
 #  END IF
 #  CASE WHEN g_ccz.ccz07='1' SELECT ima39 INTO l_invno FROM ima_file
 #                             WHERE ima01=q_tlf.tlf01
 #       WHEN g_ccz.ccz07='2' SELECT imz39 INTO l_invno FROM ima_file,imz_file
 #                             WHERE ima01=q_tlf.tlf01 AND ima12=imz01      #No.CHI-9B0024 modify ima06->ima12
 #       WHEN g_ccz.ccz07='3' SELECT imd08 INTO l_invno FROM imd_file
 #                             WHERE imd01=l_ware
 #       WHEN g_ccz.ccz07='4' SELECT ime09 INTO l_invno FROM ime_file
 #                             WHERE ime01=l_ware AND ime02=l_loc
 #  END CASE
 #  IF q_tlf.tlf03 = 50   #NO:3508
 #     THEN LET actno_d=l_invno LET actno_c=g_smy54
 #     ELSE LET actno_d=g_smy54 LET actno_c=l_invno
 #  END IF
 #  UPDATE tlf_file SET tlf15=actno_d,
 #                      tlf16=actno_c
 #              WHERE rowid=q_tlf_rowid
 
 
  #IF NOT (q_tlf.tlf13='axmt620' OR q_tlf.tlf13='axmt650' OR q_tlf.tlf13='axmt628' OR q_tlf.tlf13='aomt800') THEN 
   IF NOT (q_tlf.tlf13[1,5]='axmt6' OR q_tlf.tlf13 = 'aomt800') THEN
      RETURN 
   END IF
   LET actno_d1 = NULL	LET actno_d2 = NULL
   LET actno_c1 = NULL	LET actno_c2 = NULL
   SELECT tlf14,tlf19 INTO l_tlf14,l_tlf19 FROM tlf_file WHERE rowid=q_tlf_rowid
   SELECT azf14,azf141 INTO actno_d1,actno_d2 FROM azf_file WHERE azf01=l_tlf14 and azf02='2' and azfacti='Y'
   IF cl_null(actno_d1) THEN 
      #SELECT oba16,oba161 INTO actno_d1,actno_d2 FROM oba_file WHERE oba01 IN (SELECT ima131 FROM ima_file WHERE ima01=q_tlf.tlf01)  #CHI-C80002
      SELECT oba16,oba161 INTO actno_d1,actno_d2 FROM oba_file WHERE EXISTS(SELECT 1 FROM ima_file WHERE ima131 = oba01 AND ima01=q_tlf.tlf01)  #CHI-C80002
   END IF
   IF cl_null(actno_d1) THEN 
      SELECT occ67 INTO l_ool01 FROM occ_file WHERE occ01=l_tlf19
      IF NOT cl_null(l_ool01) THEN
         SELECT ool43,ool431 INTO actno_d1,actno_d2 FROM ool_file WHERE ool01 = l_ool01
      ELSE
         SELECT ooz08 INTO l_ooz08 FROM ooz_file WHERE ooz00='0'
         SELECT ool43,ool431 INTO actno_d1,actno_d2 FROM ool_file WHERE ool01 =l_ooz08
      END IF
   END IF
   LET l_ware=q_tlf.tlf031 LET l_loc=q_tlf.tlf032
   CASE WHEN g_ccz.ccz07='1' SELECT ima39,ima391 INTO actno_c1,actno_c2 FROM ima_file
                              WHERE ima01=q_tlf.tlf01
        WHEN g_ccz.ccz07='2' SELECT imz39,imz391 INTO actno_c1,actno_c2 FROM ima_file,imz_file
                              WHERE ima01=q_tlf.tlf01 AND ima12=imz01     
        WHEN g_ccz.ccz07='3' SELECT imd08,imd081 INTO actno_c1,actno_c2 FROM imd_file
                              WHERE imd01=l_ware
        WHEN g_ccz.ccz07='4' SELECT ime09,ime091 INTO actno_c1,actno_c2 FROM ime_file
                              WHERE ime01=l_ware AND ime02=l_loc
                               AND imeacti = 'Y'    #FUN-D40103
   END CASE 
   IF g_aza.aza63 ='Y' THEN
      UPDATE tlf_file SET tlf15=actno_d1,tlf151=actno_d2,
                          tlf16=actno_c1,tlf161=actno_c2 WHERE rowid=q_tlf_rowid
   ELSE
      UPDATE tlf_file SET tlf15=actno_d1,
                          tlf16=actno_c1 WHERE rowid=q_tlf_rowid
   END IF

   #FUN-BB0038 --end

   IF STATUS THEN 
      CALL cl_err3("upd","tlf_file","","",STATUS,"","upd tlf15:",1)   #No.FUN-660127
   END IF
END FUNCTION
 
FUNCTION p500_ccg4_cost()        # 加上WIP入庫金額
   DEFINE l_ccg       RECORD LIKE ccg_file.*
   DEFINE le_ccg      RECORD LIKE ccg_file.*
   DEFINE l_sfv09     LIKE sfv_file.sfv09
   DEFINE l_ccg31     LIKE ccg_file.ccg31
  #DEFINE l_sfv_rate  LIKE col_file.col08         #No:FUN-680122DEC(9,5) #MOD-B60127 mark
   DEFINE l_sfv_rate  LIKE type_file.num26_10     #MOD-B60127 add
   DEFINE l_cjp_rate  LIKE rvv_file.rvv17
   DEFINE l_s_cjp_rate LIKE rvv_file.rvv17
   DEFINE l_ccg01     LIKE ccg_file.ccg01
   DEFINE l_reccg31   LIKE ccg_file.ccg31
   DEFINE l_sfb02     LIKE sfb_file.sfb02   #MOD-4B0055 add
   DEFINE l_sql2      STRING                #MOD-530234        #No.FUN-680122CHAR(2000) 
   DEFINE l_sfv04     LIKE sfv_file.sfv04
   DEFINE l_sfv07     LIKE sfv_file.sfv07
   DEFINE l_sfv41     LIKE sfv_file.sfv41
   DEFINE l_imd09     LIKE imd_file.imd09
 #將MOD-4A0185回復
   DEFINE la_cce    RECORD LIKE cce_file.*
   DEFINE lb_cce    RECORD LIKE cce_file.*
   DEFINE l_cnt1    LIKE type_file.num10           #No.FUN-680122INTEGER
   DEFINE l_cnt2    LIKE type_file.num10           #No.FUN-680122INTEGER
   DEFINE l_ima55_fac LIKE ima_file.ima55_fac      #MOD-860183 add
   DEFINE l_bdate     LIKE type_file.dat           #CHI-9A0021 add
   DEFINE l_edate     LIKE type_file.dat           #CHI-9A0021 add
   DEFINE l_correct   LIKE type_file.chr1          #CHI-9A0021 add
   #No.130530001 ---begin---
   DEFINE l_ccg04     LIKE ccg_file.ccg04       
   DEFINE l_reccg31_1   LIKE ccg_file.ccg31    
   DEFINE l_reccg31_2   LIKE ccg_file.ccg31     
   DEFINE l_s_cjp_rate1 LIKE rvv_file.rvv17
   DEFINE l_s_cjp_rate2 LIKE rvv_file.rvv17
   DEFINE l_sfv09_1      LIKE sfv_file.sfv09
   
   INITIALIZE l_ccg04 TO NULL 
   LET l_reccg31_1 = 0  LET l_reccg31_2 = 0
   LET l_s_cjp_rate1 = 0 LET l_s_cjp_rate2 = 0 
   LET l_sfv09_1 = 0 
   #No.130530001 ---end--- 
   
   LET l_ccg.ccg32 =0 LET l_ccg.ccg32a=0 LET l_ccg.ccg32b=0
   LET l_ccg.ccg32c=0 LET l_ccg.ccg32d=0 LET l_ccg.ccg32e=0
   LET l_ccg.ccg32f=0 LET l_ccg.ccg32g=0 LET l_ccg.ccg32h=0   #FUN-7C0028 add
 
   LET le_ccg.ccg32=0  LET le_ccg.ccg32a=0 LET le_ccg.ccg32b=0
   LET le_ccg.ccg32c=0 LET le_ccg.ccg32d=0 LET le_ccg.ccg32e=0
   LET le_ccg.ccg32f=0 LET le_ccg.ccg32g=0 LET le_ccg.ccg32h=0   #FUN-7C0028 add
   LET l_ccg31=0       LET l_sfv09=0
 
   #先判斷是否為無入庫量,有金額的情況(工單強制結案)
   DECLARE p500_ccg4_c1 CURSOR FOR
    SELECT DISTINCT ccg01 FROM ccg_file, sfb_file
     WHERE ccg02=yy   AND ccg03=mm AND ccg01=sfb01 AND ccg04=g_ima01
       AND ccg06=type
       AND ccg07=g_tlfcost   #MOD-C60140 add
       AND ccg31=0 AND ccg32 <> 0    # 無入庫量有金額
       AND sfb02 IN (1,5,7,8)            # 一般, 重工(聯產品目前無委外重工) #No.MOD-9A0073 modify
       AND (sfb99 IS NULL OR sfb99=' ' OR sfb99='N')
   FOREACH p500_ccg4_c1 INTO l_ccg01
     SELECT SUM(ccg32 *-1),SUM(ccg32a*-1),SUM(ccg32b*-1),
            SUM(ccg32c*-1),SUM(ccg32d*-1),SUM(ccg32e*-1),
            SUM(ccg32f*-1),SUM(ccg32g*-1),SUM(ccg32h*-1),ccg01   #FUN-7C0028 add ccg32f,g,h
       INTO l_ccg.ccg32, l_ccg.ccg32a,l_ccg.ccg32b,
            l_ccg.ccg32c,l_ccg.ccg32d,l_ccg.ccg32e,
            l_ccg.ccg32f,l_ccg.ccg32g,l_ccg.ccg32h,l_ccg01   #FUN-7C0028 add ccg32f,g,h
       FROM ccg_file, sfb_file
      WHERE ccg04=g_ima01 AND ccg02=yy AND ccg03=mm
        AND ccg06=type
        AND ccg07=g_tlfcost   #MOD-C60140 add
        AND ccg01=sfb01   AND sfb02 != '13' AND sfb02 != '11'
        AND (sfb99 IS NULL OR sfb99 = ' ' OR sfb99='N' ) #OR sfb02 = '7')
        AND ccg01=l_ccg01 #WO
      GROUP BY ccg01
     IF l_ccg.ccg32 IS NULL THEN
        LET l_ccg.ccg32 =0 LET l_ccg.ccg32a=0 LET l_ccg.ccg32b=0
        LET l_ccg.ccg32c=0 LET l_ccg.ccg32d=0 LET l_ccg.ccg32e=0
        LET l_ccg.ccg32f=0 LET l_ccg.ccg32g=0 LET l_ccg.ccg32h=0   #FUN-7C0028 add
     END IF
     IF NOT cl_null(l_ccg01) THEN
        LET l_sfv09=0     #入庫量=0
        INSERT INTO cce_file
           (cce01 ,cce02 ,cce03 ,cce04 ,cce05 ,cce06 ,cce07 ,          #FUN-7C0028 add cce06,07
            cce11 ,cce12 ,
            cce12a,cce12b,cce12c,cce12d,cce12e,cce12f,cce12g,cce12h,   #FUN-7C0028 add cce12f,g,h
            cce20 ,cce21 ,cce22 ,
            cce22a,cce22b,cce22c,cce22d,cce22e,cce22f,cce22g,cce22h,   #FUN-7C0028 add cce22f,g,h
            cce91 ,cce92 ,
            cce92a,cce92b,cce92c,cce92d,cce92e,cce92f,cce92g,cce92h,   #FUN-7C0028 add cce92f,g,h
           #cceuser,ccedate,ccetime,cceplant,ccelegal,cceoriu,cceorig) #No.MOD-470041 #FUN-980009 add cceplant,ccelegal
            cceuser,ccedate,ccetime,ccelegal,cceoriu,cceorig) #FUN-A50075 del plant
          VALUES(l_ccg01,yy,mm,g_ima01,' ',type,g_tlfcost,   #FUN-7C0028 add type,g_tlfcost
                 0,0,0,0,0,0,0,0,0,0,                        #FUN-7C0028 add 0,0,0
                 0,l_sfv09,l_ccg.ccg32,
                 l_ccg.ccg32a,l_ccg.ccg32b,l_ccg.ccg32c,l_ccg.ccg32d,
                 l_ccg.ccg32e,l_ccg.ccg32f,l_ccg.ccg32g,l_ccg.ccg32h,   #FUN-7C0028 add ccg32f,g,h
                 0,0,0,0,0,0,0,0,0,0,                        #FUN-7C0028 add 0,0,0
                #g_user,TODAY,g_time,g_plant,g_legal, g_user, g_grup) #FUN-980009 add g_plant,g_legal      #No.FUN-980030 10/01/04  insert columns oriu, orig
                #g_user,TODAY,g_time,g_legal, g_user, g_grup) #FUN-A50075 del plant #MOD-C30891 mark
                 g_user,TODAY,t_time,g_legal, g_user, g_grup) #MOD-C30891 
       IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
         UPDATE cce_file
            SET cce21=l_sfv09,
                cce22=l_ccg.ccg32,
                cce22a=l_ccg.ccg32a,
                cce22b=l_ccg.ccg32b,
                cce22c=l_ccg.ccg32c,
                cce22d=l_ccg.ccg32d,
                cce22e=l_ccg.ccg32e,
                cce22f=l_ccg.ccg32f,   #FUN-7C0028 add
                cce22g=l_ccg.ccg32g,   #FUN-7C0028 add
                cce22h=l_ccg.ccg32h,   #FUN-7C0028 add
                cceuser=g_user,
                ccedate=TODAY,
               #ccetime=g_time #MOD-C30891 mark
                ccetime=t_time #MOD-C30891 
          WHERE cce01=l_ccg01 AND cce02=yy AND cce03=mm AND cce04=g_ima01
            AND cce06=type    AND cce07=g_tlfcost   #FUN-7C0028 add
         IF SQLCA.SQLCODE THEN
           CALL cl_err3("upd","cce_file",l_ccg01,yy,SQLCA.SQLCODE,"","ins cce_file:",1)   #No.FUN-660127
           LET g_success='N'
         END IF
       END IF
     END IF
     LET g_ccc.ccc22 =g_ccc.ccc22 +l_ccg.ccg32   #本月投入金額=+在製轉出金額
     LET g_ccc.ccc22a=g_ccc.ccc22a+l_ccg.ccg32a
     LET g_ccc.ccc22b=g_ccc.ccc22b+l_ccg.ccg32b
     LET g_ccc.ccc22c=g_ccc.ccc22c+l_ccg.ccg32c
     LET g_ccc.ccc22d=g_ccc.ccc22d+l_ccg.ccg32d
     LET g_ccc.ccc22e=g_ccc.ccc22e+l_ccg.ccg32e
     LET g_ccc.ccc22f=g_ccc.ccc22f+l_ccg.ccg32f   #FUN-7C0028 add
     LET g_ccc.ccc22g=g_ccc.ccc22g+l_ccg.ccg32g   #FUN-7C0028 add
     LET g_ccc.ccc22h=g_ccc.ccc22h+l_ccg.ccg32h   #FUN-7C0028 add
     LET g_ccc.ccc22=g_ccc.ccc22a+g_ccc.ccc22b+g_ccc.ccc22c+
                     g_ccc.ccc22d+g_ccc.ccc22e
                    +g_ccc.ccc22f+g_ccc.ccc22g+g_ccc.ccc22h   #FUN-7C0028 add
    #----------No:MOD-AA0026 add
     LET l_sfb02 =NULL
     SELECT sfb02 INTO l_sfb02 FROM sfb_file WHERE sfb01=l_ccg01
     IF l_sfb02 MATCHES'[78]' THEN
        LET g_ccc.ccc22a2=g_ccc.ccc22a2+l_ccg.ccg32a
        LET g_ccc.ccc22b2=g_ccc.ccc22b2+l_ccg.ccg32b
        LET g_ccc.ccc22c2=g_ccc.ccc22c2+l_ccg.ccg32c
        LET g_ccc.ccc22d2=g_ccc.ccc22d2+l_ccg.ccg32d
        LET g_ccc.ccc22e2=g_ccc.ccc22e2+l_ccg.ccg32e
        LET g_ccc.ccc22f2=g_ccc.ccc22f2+l_ccg.ccg32f   #FUN-7C0028 add
        LET g_ccc.ccc22g2=g_ccc.ccc22g2+l_ccg.ccg32g   #FUN-7C0028 add
        LET g_ccc.ccc22h2=g_ccc.ccc22h2+l_ccg.ccg32h   #FUN-7C0028 add
     ELSE
    #----------No:MOD-AA0026 end
        #入庫細項金額也應加入工單強制結案之ccg32,ccg32a~ccg32e
        LET g_ccc.ccc223 =g_ccc.ccc223 +l_ccg.ccg32
        LET g_ccc.ccc22a3=g_ccc.ccc22a3+l_ccg.ccg32a
        LET g_ccc.ccc22b3=g_ccc.ccc22b3+l_ccg.ccg32b
        LET g_ccc.ccc22c3=g_ccc.ccc22c3+l_ccg.ccg32c
        LET g_ccc.ccc22d3=g_ccc.ccc22d3+l_ccg.ccg32d
        LET g_ccc.ccc22e3=g_ccc.ccc22e3+l_ccg.ccg32e
        LET g_ccc.ccc22f3=g_ccc.ccc22f3+l_ccg.ccg32f   #FUN-7C0028 add
        LET g_ccc.ccc22g3=g_ccc.ccc22g3+l_ccg.ccg32g   #FUN-7C0028 add
        LET g_ccc.ccc22h3=g_ccc.ccc22h3+l_ccg.ccg32h   #FUN-7C0028 add
     END IF     #MOD-AA0026 add
   END FOREACH
 
   LET l_ccg.ccg32 =0 LET l_ccg.ccg32a=0 LET l_ccg.ccg32b=0
   LET l_ccg.ccg32c=0 LET l_ccg.ccg32d=0 LET l_ccg.ccg32e=0
   LET l_ccg.ccg32f=0 LET l_ccg.ccg32g=0 LET l_ccg.ccg32h=0   #FUN-7C0028 add
 
   LET le_ccg.ccg32=0  LET le_ccg.ccg32a=0 LET le_ccg.ccg32b=0
   LET le_ccg.ccg32c=0 LET le_ccg.ccg32d=0 LET le_ccg.ccg32e=0
   LET le_ccg.ccg32f=0 LET le_ccg.ccg32g=0 LET le_ccg.ccg32h=0   #FUN-7C0028 add
   LET l_ccg31=0       LET l_sfv09=0
 
  #當月起始日與截止日
   CALL s_azm(yy,mm) RETURNING l_correct,l_bdate,l_edate   #CHI-9A0021 add

   #CHI-C80002---begin
   LET l_sql2= " SELECT unique sfv04,sfv07 ",
               " FROM ccg_file,sfb_file,sfu_file,sfv_file ",
               " WHERE ccg01=? ",
               " AND ccg02=",yy," AND ccg03=",mm,
               " AND ccg06='",type,"'", 
               " AND ccg07='",g_tlfcost,"'",
               " AND sfv11=sfb01 ",
               " AND ccg01=sfb01 ",
               " AND sfb02 IN (1,5) AND (sfb99 IS NULL OR sfb99=' ' OR sfb99='N') ",
               " AND sfu01=sfv01 AND sfupost='Y' ",
               " AND sfu02 BETWEEN '",l_bdate,"' AND '",l_edate,"'" 
   PREPARE p500_tlfcost_p1 FROM l_sql2
   DECLARE p500_ccg4_tlfcost1 CURSOR FOR p500_tlfcost_p1
           
   LET l_sql2= " SELECT unique rvv31,rvv34 ", 
               " FROM ccg_file,sfb_file,rvu_file,rvv_file ",
               " WHERE ccg01 =? ",
               " AND ccg02 =",yy," AND ccg03=",mm,
               " AND ccg06='",type,"'", 
               " AND ccg07='",g_tlfcost,"'",
               " AND rvv18=sfb01 AND ccg01=sfb01 ",
               " AND sfb02 IN (7,8) ",
	           " AND (sfb99 IS NULL OR sfb99=' ' OR sfb99='N') ",
               " AND rvu01=rvv01 AND rvuconf='Y' ",
               " AND rvu03 BETWEEN '",l_bdate,"' AND '",l_edate,"'"
   PREPARE p500_tlfcost_p11 FROM l_sql2
   DECLARE p500_ccg4_tlfcost11 CURSOR FOR p500_tlfcost_p11
   
   LET l_sql2= " SELECT unique sfv04,sfv41 ",
               " FROM ccg_file,sfb_file,sfu_file,sfv_file ",
               " WHERE ccg01=? ",
               " AND ccg02=",yy," AND ccg03=",mm,
               " AND ccg06='",type,"'",
               " AND ccg07='",g_tlfcost,"'",
               " AND sfv11=sfb01 ",
               " AND ccg01=sfb01 ",
               " AND sfb02 IN (1,5) AND (sfb99 IS NULL OR sfb99=' ' OR sfb99='N') ",
               " AND sfu01=sfv01 AND sfupost='Y' ",
               " AND sfu02 BETWEEN '",l_bdate,"' AND '",l_edate,"'"
   PREPARE p500_tlfcost_p2 FROM l_sql2            
   DECLARE p500_ccg4_tlfcost2 CURSOR FOR p500_tlfcost_p2

   LET l_sql2= " SELECT unique sfv04,imd09 ",
               " FROM ccg_file,sfb_file,sfu_file,sfv_file,imd_file ",
               " WHERE ccg01=? ",
               " AND ccg02=",yy," AND ccg03=",mm,
               " AND ccg06='",type,"'",
               " AND ccg07='",g_tlfcost,"'",
               " AND sfv11=sfb01 ",
               " AND ccg01=sfb01 ",
               " AND imd01 = sfv05 ",
               " AND sfb02 IN (1,5) AND (sfb99 IS NULL OR sfb99=' ' OR sfb99='N') ",
               " AND sfu01=sfv01 AND sfupost='Y' ",
               " AND sfu02 BETWEEN '",l_bdate,"' AND '",l_edate,"'"
   PREPARE p500_tlfcost_p3 FROM l_sql2  
   DECLARE p500_ccg4_tlfcost3 CURSOR FOR p500_tlfcost_p3
             
   LET l_sql2= " SELECT unique rvv31,imd09 ",  
               " FROM ccg_file,sfb_file,rvu_file,rvv_file,imd_file ",
               " WHERE ccg01 =? ", 
               " AND ccg02 =",yy," AND ccg03=",mm,
               " AND ccg06='",type,"'",
               " AND ccg07='",g_tlfcost,"'",
               " AND rvv18=sfb01 AND ccg01=sfb01 ",
               " AND sfb02 IN (7,8) ",
               " AND (sfb99 IS NULL OR sfb99=' ' OR sfb99='N') ",
               " AND imd01 = rvv32 ",
               " AND rvu01=rvv01 AND rvuconf='Y' ",
               " AND rvu03 BETWEEN '",l_bdate,"' AND '",l_edate,"'"
   PREPARE p500_tlfcost_p31 FROM l_sql2  
   DECLARE p500_ccg4_tlfcost31 CURSOR FOR p500_tlfcost_p31
   #CHI-C80002---end
   
  #抓SUN(sfv09)段改成與p500_ccg2_cost()段一樣,改抓SUM(tlf10)
     LET l_sql2= "SELECT ccg01,ccg32,ccg32a,ccg32b,ccg32c,ccg32d,ccg32e,",
                 "                   ccg32f,ccg32g,ccg32h,",
                 "       ccg31,sfb02,SUM(tlf10)",
                 "  FROM ccg_file,sfb_file,tlf_file",
                 " WHERE ccg02=",yy," AND ccg03=",mm,
                 "   AND tlf62=sfb01 AND ccg01=sfb01 AND tlf01='",g_ima01,"'",
                 "   AND sfb02 IN (1,5)",
                 "   AND (sfb99 IS NULL OR sfb99=' ' OR sfb99='N')",
                 "   AND YEAR(tlf06)=",yy,
                 "   AND MONTH(tlf06)=",mm,
                 "   AND ccg06='",type,"'",                           #TQC-970003
                 "   AND ccg07='",g_tlfcost,"'",                      #MOD-C60140 add
                 "   AND tlfcost = '",g_tlfcost,"'",                  #TQC-970003
                 "   AND tlf13 LIKE 'asft6%'",
                 #"   AND tlf902 NOT IN(SELECT jce02 FROM jce_file)", #CHI-C80002
                 "   AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = tlf902)",  #CHI-C80002
                 "  GROUP BY ccg01,ccg32,ccg32a,ccg32b,ccg32c,ccg32d,ccg32e,ccg32f,ccg32g,ccg32h,ccg31,sfb02",
		 "  UNION ",
                 "SELECT ccg01,ccg32,ccg32a,ccg32b,ccg32c,ccg32d,ccg32e,",
                 "                   ccg32f,ccg32g,ccg32h,",
		         "       ccg31,sfb02,SUM(rvv17)",
                 "  FROM ccg_file,sfb_file,rvu_file,rvv_file",
                 "  WHERE ccg02=",yy ," AND ccg03=",mm,
                 "    AND ccg06='",type,"'",
                 "    AND ccg07='",g_tlfcost,"'",                      #MOD-C60140 add
		         "    AND rvv31='",g_ima01 CLIPPED,"'",
                 "    AND rvv18=sfb01 AND ccg01=sfb01",
                 #"    AND rvv34 = '",g_tlfcost,"'",                      #TQC-970003  #MOD-D20053
                 "    AND sfb02 IN (7,8) ",
		         "    AND (sfb99 IS NULL OR sfb99=' ' OR sfb99='N')",
                 "    AND rvu01=rvv01 AND rvuconf='Y'",
                 "    AND YEAR(rvu03)=",yy," AND MONTH(rvu03)=",mm,
                 "    AND rvu00 = '1'",                                #MOD-C50084 add
                 "    AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = rvv32)",  #MOD-D30034
                 "  GROUP BY ccg01,ccg32,ccg32a,ccg32b,ccg32c,ccg32d,ccg32e,ccg32f,ccg32g,ccg32h,ccg31,sfb02"
 
     PREPARE p500_ccg4_p2 FROM l_sql2
   DECLARE p500_ccg4_c2 CURSOR FOR p500_ccg4_p2
 
   FOREACH p500_ccg4_c2 INTO l_ccg01,le_ccg.ccg32,le_ccg.ccg32a,le_ccg.ccg32b,
                             le_ccg.ccg32c,le_ccg.ccg32d,le_ccg.ccg32e,
                             le_ccg.ccg32f,le_ccg.ccg32g,le_ccg.ccg32h,   #FUN-7C0028 add
                             l_ccg31,l_sfb02,l_sfv09   #MOD-4B0055 add l_sfb02
     #本月轉出金額
     IF le_ccg.ccg32 IS NULL THEN
        LET le_ccg.ccg32 =0 LET le_ccg.ccg32a=0 LET le_ccg.ccg32b=0
        LET le_ccg.ccg32c=0 LET le_ccg.ccg32d=0 LET le_ccg.ccg32e=0
        LET le_ccg.ccg32f=0 LET le_ccg.ccg32g=0 LET le_ccg.ccg32h=0   #FUN-7C0028 add
        LET l_ccg31=0       LET l_sfv09=0
     END IF
     IF cl_null(l_ccg31) THEN LET l_ccg31=0 END IF
     IF cl_null(l_sfv09) THEN LET l_sfv09=0 END IF
       #No.130530001 ---begin---
       SELECT sfb05 INTO l_ccg04 FROM sfb_file WHERE sfb01 = l_ccg01
       LET l_sfv09_1 = l_sfv09 
       #No.130530001 ---end--- 
     #工單重新sum(sfv09)成品轉出量(sum入庫單,不sum ccg以免有cce>ccg數量的情況)
     LET l_reccg31=0
 
 #應加上委外入庫 的判斷
     IF l_sfb02 MATCHES '[78]' THEN
        SELECT SUM(rvv17) INTO l_reccg31 FROM rvu_file,rvv_file,pmn_file    #No:MOD-B50081 add pmn_file
         WHERE rvv18=l_ccg01 AND rvu01=rvv01 AND rvuconf='Y'
           AND rvv36 = pmn01 AND rvv37 = pmn02 AND pmn65 <>'2'              #No:MOD-B50081 add
           AND rvu03 BETWEEN l_bdate AND l_edate   #CHI-9A0021
           AND rvu00 = '1'                         #MOD-C50084 add
          #AND rvv31 = g_ima01                     #No:MOD-B20005 mark
           #排除非成本庫的資料
           #AND rvv32 NOT IN(SELECT jce02 FROM jce_file)   #MOD-6C0146 add #CHI-C80002
           AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = rvv32)  #CHI-C80002
           AND rvv31 = l_ccg04  #No.130530001
          #No.130530001 ---begin---
        SELECT SUM(rvv17) INTO l_reccg31_2 FROM rvu_file,rvv_file,pmn_file   #No:MOD-B50081 add pmn_file
         WHERE rvv18=l_ccg01 AND rvu01=rvv01 AND rvuconf='Y'
           AND rvv36 = pmn01 AND rvv37 = pmn02 AND pmn65 <>'2'              #No:MOD-B50081 add
           AND rvu03 BETWEEN l_bdate AND l_edate   #CHI-9A0021
           AND rvu00 = '1'                         #MOD-C50084 add
          #AND rvv31 = g_ima01                     #No:MOD-B20005 mark
           #排除非成本庫的資料
           #AND rvv32 NOT IN(SELECT jce02 FROM jce_file)   #MOD-6C0146 add
           AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = rvv32)  #CHI-C80002
           AND rvv31 <> l_ccg04
          #No.130530001 ---end---           
     ELSE
        #SELECT SUM(sfv09) INTO l_reccg31 FROM sfv_file,sfu_file
        SELECT SUM(sfv09) INTO l_reccg31_1 FROM sfv_file,sfu_file  #No.130530001
         WHERE sfv11=l_ccg01 AND sfv01=sfu01 AND sfupost='Y'
           AND sfu02 BETWEEN l_bdate AND l_edate   #CHI-9A0021
           #排除非成本庫的資料
           #AND sfv05 NOT IN(SELECT jce02 FROM jce_file)   #MOD-6C0146 add #CHI-C80002
           AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = sfv05)  #CHI-C80002
           AND sfv04 = l_ccg04   #No.130530001
       #No.130530001 ---begin---
       #联产品入库数量，有单位转换率
       SELECT SUM(sfv09) INTO l_reccg31_2 FROM sfv_file,sfu_file
        WHERE sfv11=l_ccg01 AND sfv01=sfu01 AND sfupost='Y'   #TQC-620151
           AND sfu02 BETWEEN l_bdate AND l_edate   #CHI-9A0021
           #排除非成本庫的資料
           #AND sfv05 NOT IN(SELECT jce02 FROM jce_file)   #MOD-6C0146 add
           AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = sfv05)  #CHI-C80002
           AND bmm01 = l_ccg04
           AND sfv04 <> l_ccg04
        #No.130530001 ---end---           
     END IF
     #No.130530001 ---begin---
     IF cl_null(l_reccg31_1) THEN LET l_reccg31_1 = 0 END IF 
     IF cl_null(l_reccg31_2) THEN LET l_reccg31_2 = 0 END IF 
     LET l_reccg31 = l_reccg31_1 + l_reccg31_2
     #No.130530001 ---end--- 
     IF cl_null(l_reccg31) THEN LET l_reccg31=0 END IF
     LET l_ccg31=l_reccg31*-1
 
     CASE g_ccz.ccz13
       WHEN '1'    # 完工比例
         #LET l_sfv_rate=l_sfv09/l_ccg31
         LET l_sfv_rate=l_sfv09_1/l_ccg31  #No.130530001
       WHEN '2'    # 依分配例
         # 入庫*比例/SUM(入庫*比例)*要分攤的金額
         LET l_s_cjp_rate=0  #MOD-620042 06=0    #SUM(入庫*比例)
 #委外入庫部份要特別處理
         IF l_sfb02 MATCHES '[78]' THEN
#No.130530001 mark begin-----------------
#            SELECT SUM(rvv17*cjp06) INTO l_s_cjp_rate #MOD-620042 06
#              FROM cjp_file,sfb_file,rvu_file,rvv_file
#             WHERE cjp01=sfb05 AND cjp02=yy AND cjp03=mm
#               AND rvv31=cjp04 AND sfb01=l_ccg01
#               AND rvu01=rvv01 AND rvuconf='Y' AND rvv18=sfb01
#               AND rvu03 BETWEEN l_bdate AND l_edate    #CHI-9A0021
#               AND rvu00 = '1'                          #MOD-C50084 add
#               #AND rvv32 NOT IN(SELECT jce02 FROM jce_file)   #MOD-C70092 add #CHI-C80002 
#               AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = rvv32) #CHI-C80002 
#            LET l_cjp_rate=0  #MOD-620042 06=0      #該聯產品分配率
#            SELECT SUM(cjp06*rvv17) INTO l_cjp_rate #MOD-620042 06
#              FROM cjp_file,sfb_file,rvu_file,rvv_file
#             WHERE cjp01=sfb05 AND cjp02=yy AND cjp03=mm
#               AND rvv31=cjp04 AND sfb01=l_ccg01 AND cjp04=g_ima01
#               AND rvu01=rvv01 AND rvuconf='Y' AND rvv18=sfb01
#               AND rvu03 BETWEEN l_bdate AND l_edate    #CHI-9A0021
#               AND rvu00 = '1'                          #MOD-C50084 add
#               #AND rvv32 NOT IN(SELECT jce02 FROM jce_file)   #MOD-C70092 add #CHI-C80002
#               AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = rvv32)  #CHI-C80002
#No.130530001 mark end-------------
            #No.130530001 ---begin---
            #产成品数量
            SELECT SUM(rvv17) INTO l_s_cjp_rate1
              FROM cjp_file,sfb_file,rvu_file,rvv_file
             WHERE cjp01=sfb05 AND cjp02=yy AND cjp03=mm
               AND rvv31=cjp04 AND sfb01=l_ccg01
               AND rvu01=rvv01 AND rvuconf='Y' AND rvv18=sfb01
               AND rvu03 BETWEEN l_bdate AND l_edate    #CHI-9A0021
               AND rvu00 = '1'                          #MOD-C50084 add
               #AND rvv32 NOT IN(SELECT jce02 FROM jce_file)   #MOD-C70092 add
               AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = rvv32)  #CHI-C80002
               AND rvv31 = l_ccg04
            #联产品数量
            SELECT SUM(rvv17*cjp06/100) INTO l_s_cjp_rate2 
              FROM rvu_file,rvv_file,pmn_file,cpj_file 
             WHERE rvv18=l_ccg01 AND rvu01=rvv01 AND rvuconf='Y'
               AND rvv36 = pmn01 AND rvv37 = pmn02 AND pmn65 <>'2'  
               AND rvu03 BETWEEN l_bdate AND l_edate
               AND rvu00 = '1'                 
               #AND rvv32 NOT IN(SELECT jce02 FROM jce_file)  
               AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = rvv32)  #CHI-C80002
               AND rvv31 <> l_ccg04
               AND cjp01 = l_ccg04
               AND rvv31 = cjp04 
               AND cjp02 = yy AND cjp03=mm
            IF cl_null(l_s_cjp_rate1) THEN LET l_s_cjp_rate1 = 0 END IF 
            IF cl_null(l_s_cjp_rate2) THEN LET l_s_cjp_rate2 = 0 END IF 
            LET l_s_cjp_rate = l_s_cjp_rate1 + l_s_cjp_rate2
            IF g_ima01 = l_ccg04 THEN 
               SELECT SUM(rvv17) INTO l_cjp_rate
                 FROM cjp_file,sfb_file,rvu_file,rvv_file
                WHERE cjp01=sfb05 AND cjp02=yy AND cjp03=mm
                  AND rvv31=cjp04 AND sfb01=l_ccg01
                  AND rvu01=rvv01 AND rvuconf='Y' AND rvv18=sfb01
                  AND rvu03 BETWEEN l_bdate AND l_edate    #CHI-9A0021
                  AND rvu00 = '1'                          #MOD-C50084 add
                  #AND rvv32 NOT IN(SELECT jce02 FROM jce_file)   #MOD-C70092 add
                  AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = rvv32)  #CHI-C80002
                  AND rvv31 = l_ccg04
            ELSE 
            	 SELECT SUM(rvv17*cjp06/100) INTO l_cjp_rate 
                 FROM rvu_file,rvv_file,pmn_file,cpj_file 
                WHERE rvv18=l_ccg01 AND rvu01=rvv01 AND rvuconf='Y'
                  AND rvv36 = pmn01 AND rvv37 = pmn02 AND pmn65 <>'2'  
                  AND rvu03 BETWEEN l_bdate AND l_edate
                  AND rvu00 = '1'                 
                  #AND rvv32 NOT IN(SELECT jce02 FROM jce_file)  
                  AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = rvv32)  #CHI-C80002
                  AND rvv31 <> l_ccg04
                  AND cjp01 = l_ccg04
                  AND rvv31 = cjp04 
                  AND rvv31 = g_ima01
                  AND cjp02 = yy AND cjp03=mm
            END IF 
            #No.130530001 ---end---
         ELSE
##No.130530001 ---add begin--------------         
#            SELECT SUM(sfv09*cjp06) INTO l_s_cjp_rate #MOD-620042 06
#              FROM cjp_file,sfb_file,sfu_file,sfv_file
#             WHERE cjp01=sfb05 AND cjp02=yy AND cjp03=mm
#               AND sfv04=cjp04 AND sfb01=l_ccg01
#               AND sfu01=sfv01 AND sfupost='Y' AND sfv11=sfb01
#               AND sfu02 BETWEEN l_bdate AND l_edate  #CHI-9A0021
#               #AND sfv05 NOT IN(SELECT jce02 FROM jce_file)           #MOD-C70092 add #CHI-C80002
#               AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = sfv05)  #CHI-C80002
#            LET l_cjp_rate=0    #MOD-620042 06=0      #該聯產品分配率
#            SELECT SUM(cjp06*sfv09) INTO l_cjp_rate #MOD-620042 06
#              FROM cjp_file,sfb_file,sfu_file,sfv_file
#             WHERE cjp01=sfb05 AND cjp02=yy AND cjp03=mm
#               AND sfv04=cjp04 AND sfb01=l_ccg01 AND cjp04=g_ima01
#               AND sfu01=sfv01 AND sfupost='Y' AND sfv11=sfb01
#               AND sfu02 BETWEEN l_bdate AND l_edate   #CHI-9A0021 
#               #AND sfv05 NOT IN(SELECT jce02 FROM jce_file)           #MOD-C70092 add #CHI-C80002
#               AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = sfv05)  #CHI-C80002
#No.130530001 ---add end---------------
             #No.130530001 ---begin---
            LET l_s_cjp_rate=0  #MOD-620042 06=0    #SUM(入庫*比例)
             #抓取产成品数量
             SELECT SUM(sfv09) INTO l_s_cjp_rate1 #MOD-620042 06
               FROM sfu_file,sfv_file
              WHERE sfu01=sfv01 AND sfupost='Y' AND sfv11=l_ccg01
                AND sfu02 BETWEEN l_bdate AND l_edate   #CHI-9A0021
                #AND sfv05 NOT IN(SELECT jce02 FROM jce_file)  
                AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = sfv05)  #CHI-C80002
                AND sfv04 = l_ccg04
             #联产品入库数量，有单位转换率
             SELECT SUM(sfv09*cjp06/100) INTO l_s_cjp_rate2 FROM sfv_file,sfu_file,cjp_file
              WHERE sfv11=l_ccg01 AND sfv01=sfu01 AND sfupost='Y'   #TQC-620151
                AND sfu02 BETWEEN l_bdate AND l_edate   #CHI-9A0021
                 #AND sfv05 NOT IN(SELECT jce02 FROM jce_file)   #MOD-6C0146 add
                 AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = sfv05)  #CHI-C80002
                 AND sfv04 <> l_ccg04
                 AND cjp01 = l_ccg04 
                 AND cjp02 = yy AND cjp03=mm
                 AND sfv04 = cjp04
             IF cl_null(l_s_cjp_rate1) THEN LET l_s_cjp_rate1 = 0 END IF 
             IF cl_null(l_s_cjp_rate2) THEN LET l_s_cjp_rate2 = 0 END IF 
             LET l_s_cjp_rate = l_s_cjp_rate1 + l_s_cjp_rate2
             IF l_ccg04 = g_ima01 THEN 
                 SELECT SUM(sfv09) INTO l_cjp_rate #MOD-620042 06
                   FROM sfu_file,sfv_file
                  WHERE sfu01=sfv01 AND sfupost='Y' AND sfv11=l_ccg01
                    AND sfu02 BETWEEN l_bdate AND l_edate   #CHI-9A0021
                    #AND sfv05 NOT IN(SELECT jce02 FROM jce_file)  
                    AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = sfv05)  #CHI-C80002
                    AND sfv04 = g_ima01
             ELSE 
                   #联产品入库数量，有单位转换率
                 SELECT SUM(sfv09*cjp06/100) INTO l_cjp_rate FROM sfv_file,sfu_file,cjp_file
                  WHERE sfv11=l_ccg01 AND sfv01=sfu01 AND sfupost='Y'   #TQC-620151
                    AND sfu02 BETWEEN l_bdate AND l_edate   #CHI-9A0021
                    #AND sfv05 NOT IN(SELECT jce02 FROM jce_file)   #MOD-6C0146 add
                    AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = sfv05)  #CHI-C80002
                    AND sfv04 <> l_ccg04
                    AND cjp01 = l_ccg04 
                    AND cjp02 = yy AND cjp03=mm
                    AND sfv04 = cjp04
                    AND sfv04 = g_ima01
             END IF 
             #No.130530001 ---end---
         END IF   #MOD-4B0055
         IF cl_null(l_cjp_rate) THEN LET l_cjp_rate = 0 END IF
         LET l_sfv_rate=(l_cjp_rate/l_s_cjp_rate)*-1  #MOD-620042
       OTHERWISE
         #LET l_sfv_rate=l_sfv09/l_ccg31               #TQC-970003
         LET l_sfv_rate=l_sfv09_1/l_ccg31  #No.130530001
     END CASE
     IF cl_null(l_sfv_rate) THEN LET l_sfv_rate=-1 END IF
     LET l_ccg.ccg32a = l_ccg.ccg32a + (le_ccg.ccg32a * l_sfv_rate)
     LET l_ccg.ccg32b = l_ccg.ccg32b + (le_ccg.ccg32b * l_sfv_rate)
     LET l_ccg.ccg32c = l_ccg.ccg32c + (le_ccg.ccg32c * l_sfv_rate)
     LET l_ccg.ccg32d = l_ccg.ccg32d + (le_ccg.ccg32d * l_sfv_rate)
     LET l_ccg.ccg32e = l_ccg.ccg32e + (le_ccg.ccg32e * l_sfv_rate)
     LET l_ccg.ccg32f = l_ccg.ccg32f + (le_ccg.ccg32f * l_sfv_rate)   #FUN-7C0028 add
     LET l_ccg.ccg32g = l_ccg.ccg32g + (le_ccg.ccg32g * l_sfv_rate)   #FUN-7C0028 add
     LET l_ccg.ccg32h = l_ccg.ccg32h + (le_ccg.ccg32h * l_sfv_rate)   #FUN-7C0028 add
 
    #MOD-C40187 -- add start --
     LET l_ccg.ccg32a = cl_digcut(l_ccg.ccg32a,g_ccz.ccz26)
     LET l_ccg.ccg32b = cl_digcut(l_ccg.ccg32b,g_ccz.ccz26)
     LET l_ccg.ccg32c = cl_digcut(l_ccg.ccg32c,g_ccz.ccz26)
     LET l_ccg.ccg32d = cl_digcut(l_ccg.ccg32d,g_ccz.ccz26)
     LET l_ccg.ccg32e = cl_digcut(l_ccg.ccg32e,g_ccz.ccz26)
     LET l_ccg.ccg32f = cl_digcut(l_ccg.ccg32f,g_ccz.ccz26)
     LET l_ccg.ccg32g = cl_digcut(l_ccg.ccg32g,g_ccz.ccz26)
     LET l_ccg.ccg32h = cl_digcut(l_ccg.ccg32h,g_ccz.ccz26)
    #MOD-C40187 -- add end --

     LET le_ccg.ccg32 = le_ccg.ccg32a + le_ccg.ccg32b + le_ccg.ccg32c +
                        le_ccg.ccg32d + le_ccg.ccg32e
                       +le_ccg.ccg32f + le_ccg.ccg32g + le_ccg.ccg32h   #FUN-7C0028 add
     LET l_ccg.ccg32  = l_ccg.ccg32a + l_ccg.ccg32b + l_ccg.ccg32c +
                        l_ccg.ccg32d + l_ccg.ccg32e + l_ccg.ccg32
                       +l_ccg.ccg32f + l_ccg.ccg32g + l_ccg.ccg32h   #FUN-7C0028 add
 
     LET g_ccc.ccc22  = g_ccc.ccc22 +l_ccg.ccg32
     LET g_ccc.ccc22a = g_ccc.ccc22a+l_ccg.ccg32a
     LET g_ccc.ccc22b = g_ccc.ccc22b+l_ccg.ccg32b
     LET g_ccc.ccc22c = g_ccc.ccc22c+l_ccg.ccg32c
     LET g_ccc.ccc22d = g_ccc.ccc22d+l_ccg.ccg32d
     LET g_ccc.ccc22e = g_ccc.ccc22e+l_ccg.ccg32e
     LET g_ccc.ccc22f = g_ccc.ccc22f+l_ccg.ccg32f   #FUN-7C0028 add
     LET g_ccc.ccc22g = g_ccc.ccc22g+l_ccg.ccg32g   #FUN-7C0028 add
     LET g_ccc.ccc22h = g_ccc.ccc22h+l_ccg.ccg32h   #FUN-7C0028 add
     LET g_ccc.ccc22  = g_ccc.ccc22a+g_ccc.ccc22b+g_ccc.ccc22c+
                        g_ccc.ccc22d+g_ccc.ccc22e
                       +g_ccc.ccc22f+g_ccc.ccc22g+g_ccc.ccc22h   #FUN-7C0028 add
 
     #當使用聯產品時,要計算生產入庫的入庫細項金額
     IF l_sfb02 ! ='7' AND l_sfb02 != '8' THEN   #委外工單的部份,不需計算進來   #MOD-740166 add
        LET g_ccc.ccc22a3=g_ccc.ccc22a3+l_ccg.ccg32a
        LET g_ccc.ccc22b3=g_ccc.ccc22b3+l_ccg.ccg32b
        LET g_ccc.ccc22c3=g_ccc.ccc22c3+l_ccg.ccg32c
        LET g_ccc.ccc22d3=g_ccc.ccc22d3+l_ccg.ccg32d
        LET g_ccc.ccc22e3=g_ccc.ccc22e3+l_ccg.ccg32e
        LET g_ccc.ccc22f3=g_ccc.ccc22f3+l_ccg.ccg32f   #FUN-7C0028 add
        LET g_ccc.ccc22g3=g_ccc.ccc22g3+l_ccg.ccg32g   #FUN-7C0028 add
        LET g_ccc.ccc22h3=g_ccc.ccc22h3+l_ccg.ccg32h   #FUN-7C0028 add
    #MOD-C40032 str add-----
     ELSE
        LET g_ccc.ccc22a2=g_ccc.ccc22a2+l_ccg.ccg32a
        LET g_ccc.ccc22b2=g_ccc.ccc22b2+l_ccg.ccg32b
        LET g_ccc.ccc22c2=g_ccc.ccc22c2+l_ccg.ccg32c                            
        LET g_ccc.ccc22d2=g_ccc.ccc22d2+l_ccg.ccg32d
        LET g_ccc.ccc22e2=g_ccc.ccc22e2+l_ccg.ccg32e
        LET g_ccc.ccc22f2=g_ccc.ccc22f2+l_ccg.ccg32f
        LET g_ccc.ccc22g2=g_ccc.ccc22g2+l_ccg.ccg32g
        LET g_ccc.ccc22h2=g_ccc.ccc22h2+l_ccg.ccg32h
    #MOD-C40032 end add-----
     END IF                                                                     #MOD-740166 add
 
     IF NOT cl_null(l_ccg01) THEN
       #l_sfv09要寫入cce_file前,要先乘以轉換率ima55_fac,換算成庫存數量再寫入
        LET l_ima55_fac=0
        SELECT ima55_fac INTO l_ima55_fac FROM ima_file
         WHERE ima01=g_ima01
        IF cl_null(l_ima55_fac) OR l_ima55_fac=0 THEN LET l_ima55_fac=1 END IF
        LET l_sfv09 = l_sfv09 * l_ima55_fac
        INSERT INTO cce_file
           (cce01 ,cce02 ,cce03 ,cce04 ,cce05 ,cce06 ,cce07 ,          #FUN-7C0028 add cce06,07
            cce11 ,cce12 ,
            cce12a,cce12b,cce12c,cce12d,cce12e,cce12f,cce12g,cce12h,   #FUN-7C0028 add cce12f,g,h
            cce20 ,cce21 ,cce22 ,
            cce22a,cce22b,cce22c,cce22d,cce22e,cce22f,cce22g,cce22h,   #FUN-7C0028 add cce22f,g,h
            cce91 ,cce92 ,
            cce92a,cce92b,cce92c,cce92d,cce92e,cce92f,cce92g,cce92h,   #FUN-7C0028 add cce92f,g,h
           #cceuser,ccedate,ccetime,cceplant,ccelegal,cceoriu,cceorig) #No.MOD-470041 #FUN-980009 add cceplant,ccelegal
            cceuser,ccedate,ccetime,ccelegal,cceoriu,cceorig) #FUN-A50075 del plant
          VALUES(l_ccg01,yy,mm,g_ima01,' ',type,g_tlfcost,   #FUN-7C0028 add type,g_tlfcost
                 0,0,0,0,0,0,0,0,0,0,                        #FUN-7C0028 add 0,0,0
                 0,l_sfv09,l_ccg.ccg32,
                 l_ccg.ccg32a,l_ccg.ccg32b,l_ccg.ccg32c,l_ccg.ccg32d,
                 l_ccg.ccg32e,l_ccg.ccg32f,l_ccg.ccg32g,l_ccg.ccg32h,   #FUN-7C0028 add ccg32f,g,h
                 0,0,0,0,0,0,0,0,0,0,                        #FUN-7C0028 add 0,0,0
                #g_user,TODAY,g_time,g_plant,g_legal, g_user, g_grup) #FUN-980009 add g_plant,g_legal      #No.FUN-980030 10/01/04  insert columns oriu, orig
                #g_user,TODAY,g_time,g_legal, g_user, g_grup) #FUN-A50075 del plant #MOD-C30891 mark
                 g_user,TODAY,t_time,g_legal, g_user, g_grup) #MOD-C30891
        IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
           UPDATE cce_file
            SET cce21=l_sfv09,
                cce22=l_ccg.ccg32,
                cce22a=l_ccg.ccg32a,
                cce22b=l_ccg.ccg32b,
                cce22c=l_ccg.ccg32c,
                cce22d=l_ccg.ccg32d,
                cce22e=l_ccg.ccg32e,
                cce22f=l_ccg.ccg32f,   #FUN-7C0028 add
                cce22g=l_ccg.ccg32g,   #FUN-7C0028 add
                cce22h=l_ccg.ccg32h,   #FUN-7C0028 add
                cceuser=g_user,
                ccedate=TODAY,
               #ccetime=g_time #MOD-C30891 mark
                ccetime=t_time #MOD-C30891 
            WHERE cce01=l_ccg01 AND cce02=yy AND cce03=mm
              AND cce04=g_ima01
              AND cce06=type    AND cce07=g_tlfcost   #FUN-7C0028 add
           IF SQLCA.SQLCODE THEN
               CALL cl_err3("upd","cce_file",l_ccg01,yy,SQLCA.SQLCODE,"","ins cce_file:",1)   #No.FUN-660127
               LET g_success='N'
           END IF
        END IF
 
#將MOD-4A0185回復
#有關聯產品小數尾差部份,針對 ccc_file還是會有問題,
#因為入庫金額有變更,理論上應該要重算一次月加權平均單價,且後面的期末結存及結存調>
#及所有的領用成本都會變動,後續會有影響,所以先拿掉
       IF type = '1' or type = '2' THEN                  #TQC-970003
          IF l_sfb02 ! ='7' AND l_sfb02 != '8' THEN      #FUN-A20017 
             SELECT COUNT( unique sfv04 ) INTO l_cnt1      #MOD-850192
               FROM ccg_file,sfb_file,sfu_file,sfv_file
              WHERE ccg01=l_ccg01
                AND ccg02=yy   AND ccg03=mm
                AND ccg06=type 
                AND ccg07=g_tlfcost   #MOD-C60140 add
                AND sfv11=sfb01
                AND ccg01=sfb01
                AND sfb02 IN (1,5) AND (sfb99 IS NULL OR sfb99=' ' OR sfb99='N')
                AND sfu01=sfv01 AND sfupost='Y'
                AND sfu02 BETWEEN l_bdate AND l_edate  #CHI-9A0021
          #FUN-A20017--begin--add--聯產品也要算
         ELSE
          SELECT COUNT( unique rvv31) INTO l_cnt1     
            FROM ccg_file,sfb_file,rvu_file,rvv_file
           WHERE ccg01 =l_ccg01 AND ccg02 = yy AND ccg03 = mm
             AND ccg06=type
             AND ccg07=g_tlfcost   #MOD-C60140 add    
             AND rvv18=sfb01 AND ccg01=sfb01
            #AND rvv34 = g_tlfcost
             AND sfb02 IN (7,8)
             AND (sfb99 IS NULL OR sfb99=' ' OR sfb99='N')
             AND rvu01=rvv01 AND rvuconf='Y'
             AND rvu03 BETWEEN l_bdate AND l_edate
        END IF
        #FUN-A20017--end--add----
       END IF                                        #TQC-970003

       IF type = '3'  THEN
          IF l_sfb02 ! ='7' AND l_sfb02 != '8' THEN #FUN-A20017
             #CHI-C80002---begin mark
             #DECLARE p500_ccg4_tlfcost1 CURSOR FOR SELECT unique sfv04,sfv07 
             #  FROM ccg_file,sfb_file,sfu_file,sfv_file
             # WHERE ccg01=l_ccg01
             #   AND ccg02=yy   AND ccg03=mm
             #   AND ccg06=type 
             #   AND ccg07=g_tlfcost   #MOD-C60140 add
             #   AND sfv11=sfb01
             #   AND ccg01=sfb01
             #   AND sfb02 IN (1,5) AND (sfb99 IS NULL OR sfb99=' ' OR sfb99='N')
             #   AND sfu01=sfv01 AND sfupost='Y'
             #   AND sfu02 BETWEEN l_bdate AND l_edate  #CHI-9A0021
             #CHI-C80002---end
               LET l_cnt1 = 0 
               #FOREACH p500_ccg4_tlfcost1 INTO l_sfv04,l_sfv07  #CHI-C80002
               FOREACH p500_ccg4_tlfcost1 USING l_ccg01 INTO l_sfv04,l_sfv07  #CHI-C80002
                   LET l_cnt1 = l_cnt1+1        
               END FOREACH
          ELSE
          #FUN-A20017--begin--add---
          #聯產品也要算
          #CHI-C80002---begin
          #DECLARE p500_ccg4_tlfcost11 CURSOR FOR 
          # SELECT unique rvv31,rvv34     
          #   FROM ccg_file,sfb_file,rvu_file,rvv_file
          #  WHERE ccg01 =l_ccg01 AND ccg02 = yy AND ccg03 = mm
          #    AND ccg06=type
          #    AND ccg07=g_tlfcost   #MOD-C60140 add
          #    AND rvv18=sfb01 AND ccg01=sfb01
          #    AND sfb02 IN (7,8)
	      #      AND (sfb99 IS NULL OR sfb99=' ' OR sfb99='N')
          #    AND rvu01=rvv01 AND rvuconf='Y'
          #    AND rvu03 BETWEEN l_bdate AND l_edate
          #CHI-C80002---end
          LET l_cnt1 = 0 
          #FOREACH p500_ccg4_tlfcost11 INTO l_sfv04,l_sfv07  #CHI-C80002
          FOREACH p500_ccg4_tlfcost11 USING l_ccg01 INTO l_sfv04,l_sfv07  #CHI-C80002
             LET l_cnt1 = l_cnt1+1        
          END FOREACH 
        END IF
        #FUN-A20017--end--add-----
        END IF

       IF type = '4'  THEN
          IF l_sfb02 ! ='7' AND l_sfb02 != '8' THEN  #FUN-A20017
             #CHI-C80002---begin mark
             #DECLARE p500_ccg4_tlfcost2 CURSOR FOR SELECT unique sfv04,sfv41 
             #  FROM ccg_file,sfb_file,sfu_file,sfv_file
             # WHERE ccg01=l_ccg01
             #   AND ccg02=yy   AND ccg03=mm
             #   AND ccg06=type #modify by sam 
             #   AND ccg07=g_tlfcost   #MOD-C60140 add
             #   AND sfv11=sfb01
             #   AND ccg01=sfb01
             #   AND sfb02 IN (1,5) AND (sfb99 IS NULL OR sfb99=' ' OR sfb99='N')
             #   AND sfu01=sfv01 AND sfupost='Y'
             #   AND sfu02 BETWEEN l_bdate AND l_edate      #CHI-9A0021
             #CHI-C80002---end
               LET l_cnt1 = 0 
               #FOREACH p500_ccg4_tlfcost2 INTO l_sfv04,l_sfv41  #CHI-C80002
               FOREACH p500_ccg4_tlfcost2 USING l_ccg01 INTO l_sfv04,l_sfv41  #CHI-C80002
                   LET l_cnt1 = l_cnt1+1        
               END FOREACH
           #FUN-A20017--begin--聯產品也要算
          ELSE
            #CHI-C80002---begin mark
            #DECLARE p500_ccg4_tlfcost21 CURSOR FOR 
            # SELECT unique rvv31,rvv34     
            #   FROM ccg_file,sfb_file,rvu_file,rvv_file
            #  WHERE ccg01 =l_ccg01 AND ccg02 = yy AND ccg03 = mm
            #    AND ccg06=type
            #    AND ccg07=g_tlfcost   #MOD-C60140 add
            #    AND rvv18=sfb01 AND ccg01=sfb01
            #    AND sfb02 IN (7,8)
            #    AND (sfb99 IS NULL OR sfb99=' ' OR sfb99='N')
            #    AND rvu01=rvv01 AND rvuconf='Y'
            #    AND rvu03 BETWEEN l_bdate AND l_edate
            #CHI-C80002---end
            LET l_cnt1 = 0 
            #FOREACH p500_ccg4_tlfcost21 INTO l_sfv04,l_sfv07  #CHI-C80002
            FOREACH p500_ccg4_tlfcost11 USING l_ccg01 INTO l_sfv04,l_sfv07  #CHI-C80002
                LET l_cnt1 = l_cnt1+1        
            END FOREACH
          END IF
          #FUN-A20017--end--add----
        END IF

       IF type = '5'  THEN
          IF l_sfb02 ! ='7' AND l_sfb02 != '8' THEN  #FUN-A20017
             #CHI-C80002---begin mark
             #DECLARE p500_ccg4_tlfcost3 CURSOR FOR SELECT unique sfv04,imd09 
             #  FROM ccg_file,sfb_file,sfu_file,sfv_file,imd_file
             # WHERE ccg01=l_ccg01
             #   AND ccg02=yy   AND ccg03=mm
             #   AND ccg06=type #modify by sam 
             #   AND ccg07=g_tlfcost   #MOD-C60140 add
             #   AND sfv11=sfb01
             #   AND ccg01=sfb01
             #   AND imd01 = sfv05
             #   AND sfb02 IN (1,5) AND (sfb99 IS NULL OR sfb99=' ' OR sfb99='N')
             #   AND sfu01=sfv01 AND sfupost='Y'
             #   AND sfu02 BETWEEN l_bdate AND l_edate      #CHI-9A0021
             #CHI-C80002---end
               LET l_cnt1 = 0 
               #FOREACH p500_ccg4_tlfcost3 INTO l_sfv04,l_imd09  #CHI-C80002
               FOREACH p500_ccg4_tlfcost3 USING l_ccg01 INTO l_sfv04,l_imd09  #CHI-C80002
                   LET l_cnt1 = l_cnt1+1        
               END FOREACH
          ELSE
        #FUN-A20017--begin--add--聯產品也要算
            #CHI-C80002---begin mark
            #DECLARE p500_ccg4_tlfcost31 CURSOR FOR 
            # SELECT unique rvv31,imd09     
            #   FROM ccg_file,sfb_file,rvu_file,rvv_file,imd_file
            #  WHERE ccg01 =l_ccg01 AND ccg02 = yy AND ccg03 = mm
            #    AND ccg06=type
            #    AND ccg07=g_tlfcost   #MOD-C60140 add
            #    AND rvv18=sfb01 AND ccg01=sfb01
            #    AND sfb02 IN (7,8)
            #    AND (sfb99 IS NULL OR sfb99=' ' OR sfb99='N')
            #    AND imd01 = rvv32
            #    AND rvu01=rvv01 AND rvuconf='Y'
            #    AND rvu03 BETWEEN l_bdate AND l_edate
            #CHI-C80002---end
            LET l_cnt1 = 0 
            #FOREACH p500_ccg4_tlfcost31 INTO l_sfv04,l_imd09  #CHI-C80002
            FOREACH p500_ccg4_tlfcost31 USING l_ccg01 INTO l_sfv04,l_imd09  #CHI-C80002
               LET l_cnt1 = l_cnt1+1        
            END FOREACH
          END IF
        #FUN-A20017--end--add----- 
        END IF
 
        SELECT COUNT(*) INTO l_cnt2
          FROM cce_file
         WHERE cce01=l_ccg01
           AND cce02=yy   AND cce03=mm
           AND cce06=type                                        #TQC-970003 
        IF l_cnt1=l_cnt2 and l_cnt1<>0 AND l_cnt2 <> 0 THEN
           INITIALIZE la_cce.* TO NULL
           INITIALIZE lb_cce.* TO NULL
           SELECT SUM(cce22a),SUM(cce22b),SUM(cce22c),SUM(cce22d),SUM(cce22e)
                 ,SUM(cce22f),SUM(cce22g),SUM(cce22h)   #FUN-7C0028 add
             INTO la_cce.cce22a, la_cce.cce22b, la_cce.cce22c, 
                  la_cce.cce22d, la_cce.cce22e
                 ,la_cce.cce22f, la_cce.cce22g, la_cce.cce22h   #FUN-7C0028 add
            FROM cce_file
           WHERE cce01=l_ccg01
             AND cce02=yy   AND cce03=mm
             AND cce06=type                       #TQC-970003 add
           IF cl_null(la_cce.cce22a) THEN LET la_cce.cce22a=0 END IF
           IF cl_null(la_cce.cce22b) THEN LET la_cce.cce22b=0 END IF
           IF cl_null(la_cce.cce22c) THEN LET la_cce.cce22d=0 END IF
           IF cl_null(la_cce.cce22d) THEN LET la_cce.cce22e=0 END IF
           IF cl_null(la_cce.cce22e) THEN LET la_cce.cce22e=0 END IF
           IF cl_null(la_cce.cce22f) THEN LET la_cce.cce22f=0 END IF   #FUN-7C0028 add
           IF cl_null(la_cce.cce22g) THEN LET la_cce.cce22g=0 END IF   #FUN-7C0028 add
           IF cl_null(la_cce.cce22h) THEN LET la_cce.cce22h=0 END IF   #FUN-7C0028 add
           LET la_cce.cce22=la_cce.cce22a+ la_cce.cce22b+ la_cce.cce22c+
                            la_cce.cce22d+ la_cce.cce22e
                           +la_cce.cce22f+ la_cce.cce22g+ la_cce.cce22h   #FUN-7C0028 add
           LET lb_cce.cce22a=le_ccg.ccg32a*-1 - la_cce.cce22a
           LET lb_cce.cce22b=le_ccg.ccg32b*-1 - la_cce.cce22b
           LET lb_cce.cce22c=le_ccg.ccg32c*-1 - la_cce.cce22c
           LET lb_cce.cce22d=le_ccg.ccg32d*-1 - la_cce.cce22d
           LET lb_cce.cce22e=le_ccg.ccg32e*-1 - la_cce.cce22e
           LET lb_cce.cce22f=le_ccg.ccg32f*-1 - la_cce.cce22f   #FUN-7C0028 add
           LET lb_cce.cce22g=le_ccg.ccg32g*-1 - la_cce.cce22g   #FUN-7C0028 add
           LET lb_cce.cce22h=le_ccg.ccg32h*-1 - la_cce.cce22h   #FUN-7C0028 add
           LET lb_cce.cce22=lb_cce.cce22a+ lb_cce.cce22b+ lb_cce.cce22c+
                            lb_cce.cce22d+ lb_cce.cce22e
                           +lb_cce.cce22f+ lb_cce.cce22g+ lb_cce.cce22h   #FUN-7C0028 add
          #IF lb_cce.cce22 <> 0 THEN       #MOD-C50078 mark
          #MOD-C50078 str add-----
           IF lb_cce.cce22a <> 0 OR lb_cce.cce22b <> 0 OR lb_cce.cce22c <> 0 OR lb_cce.cce22d <> 0 OR
              lb_cce.cce22e <> 0 OR lb_cce.cce22f <> 0 OR lb_cce.cce22g <> 0 OR lb_cce.cce22h <> 0 THEN
          #MOD-C50078 end add-----
             LET g_ccc.ccc22  = g_ccc.ccc22 +lb_cce.cce22
             LET g_ccc.ccc22a = g_ccc.ccc22a+lb_cce.cce22a
             LET g_ccc.ccc22b = g_ccc.ccc22b+lb_cce.cce22b
             LET g_ccc.ccc22c = g_ccc.ccc22c+lb_cce.cce22c
             LET g_ccc.ccc22d = g_ccc.ccc22d+lb_cce.cce22d
             LET g_ccc.ccc22e = g_ccc.ccc22e+lb_cce.cce22e
             LET g_ccc.ccc22f = g_ccc.ccc22f+lb_cce.cce22f   #FUN-7C0028 add
             LET g_ccc.ccc22g = g_ccc.ccc22g+lb_cce.cce22g   #FUN-7C0028 add
             LET g_ccc.ccc22h = g_ccc.ccc22h+lb_cce.cce22h   #FUN-7C0028 add
             LET g_ccc.ccc22  = g_ccc.ccc22a+g_ccc.ccc22b+g_ccc.ccc22c+
                                g_ccc.ccc22d+g_ccc.ccc22e
                               +g_ccc.ccc22f+g_ccc.ccc22g+ g_ccc.ccc22h   #FUN-7C0028 add

            #---------------No:MOD-AC0153 add
             IF l_sfb02 ! ='7' AND l_sfb02 != '8' THEN   #委外工單的部份,不需計算進來  
                LET g_ccc.ccc22a3=g_ccc.ccc22a3+lb_cce.cce22a
                LET g_ccc.ccc22b3=g_ccc.ccc22b3+lb_cce.cce22b
                LET g_ccc.ccc22c3=g_ccc.ccc22c3+lb_cce.cce22c
                LET g_ccc.ccc22d3=g_ccc.ccc22d3+lb_cce.cce22d
                LET g_ccc.ccc22e3=g_ccc.ccc22e3+lb_cce.cce22e
                LET g_ccc.ccc22f3=g_ccc.ccc22f3+lb_cce.cce22f 
                LET g_ccc.ccc22g3=g_ccc.ccc22g3+lb_cce.cce22g 
                LET g_ccc.ccc22h3=g_ccc.ccc22h3+lb_cce.cce22h 
             ELSE
                LET g_ccc.ccc22a2=g_ccc.ccc22a2+lb_cce.cce22a
                LET g_ccc.ccc22b2=g_ccc.ccc22b2+lb_cce.cce22b
                LET g_ccc.ccc22c2=g_ccc.ccc22c2+lb_cce.cce22c
                LET g_ccc.ccc22d2=g_ccc.ccc22d2+lb_cce.cce22d
                LET g_ccc.ccc22e2=g_ccc.ccc22e2+lb_cce.cce22e
                LET g_ccc.ccc22f2=g_ccc.ccc22f2+lb_cce.cce22f
                LET g_ccc.ccc22g2=g_ccc.ccc22g2+lb_cce.cce22g
                LET g_ccc.ccc22h2=g_ccc.ccc22h2+lb_cce.cce22h
             END IF                        
            #---------------No:MOD-AC0153 end

             UPDATE cce_file
              SET cce22  = cce22  + lb_cce.cce22,
                  cce22a = cce22a + lb_cce.cce22a,
                  cce22b = cce22b + lb_cce.cce22b,
                  cce22c = cce22c + lb_cce.cce22c,
                  cce22d = cce22d + lb_cce.cce22d,
                  cce22e = cce22e + lb_cce.cce22e,
                  cce22f = cce22f + lb_cce.cce22f,   #FUN-7C0028 add
                  cce22g = cce22g + lb_cce.cce22g,   #FUN-7C0028 add
                  cce22h = cce22h + lb_cce.cce22h,   #FUN-7C0028 add
                  cceuser= g_user,
                  ccedate= TODAY,
                 #ccetime= g_time #MOD-C30891 mark
                  ccetime= t_time #MOD-C30891 
              WHERE cce01=l_ccg01 AND cce02=yy AND cce03=mm
                AND cce04=g_ima01
                AND cce06=type AND cce07=g_tlfcost   #FUN-7C0028 add
              IF SQLCA.SQLCODE THEN
                  CALL cl_err3("upd","cce_file",l_ccg01,yy,SQLCA.SQLCODE,"","upd cce_file:",1)   #No.FUN-660127
                  LET g_success='N'
              END IF
           END IF
        END IF
#將MOD-4A0185回復
     END IF
 
     LET le_ccg.ccg32=0  LET le_ccg.ccg32a=0 LET le_ccg.ccg32b=0
     LET le_ccg.ccg32c=0 LET le_ccg.ccg32d=0 LET le_ccg.ccg32e=0
     LET le_ccg.ccg32f=0 LET le_ccg.ccg32g=0 LET le_ccg.ccg32h=0   #FUN-7C0028 add
     LET l_ccg.ccg32 =0  LET l_ccg.ccg32a =0 LET l_ccg.ccg32b =0
     LET l_ccg.ccg32c=0  LET l_ccg.ccg32d =0 LET l_ccg.ccg32e =0
     LET l_ccg.ccg32f=0  LET l_ccg.ccg32g=0  LET l_ccg.ccg32h=0   #FUN-7C0028 add
     LET l_sfv09=0       LET l_ccg31=0
   END FOREACH
END FUNCTION
 
FUNCTION p500_ccg5_cost()      # 加上WIP入庫金額
   DEFINE l_ccu       RECORD LIKE ccu_file.*
 
   INITIALIZE l_ccu.* TO NULL
   SELECT SUM(ccu31 *-1),
          SUM(ccu32 *-1),SUM(ccu32a*-1),SUM(ccu32b*-1),
          SUM(ccu32c*-1),SUM(ccu32d*-1),SUM(ccu32e*-1)
         ,SUM(ccu32f*-1),SUM(ccu32g*-1),SUM(ccu32h*-1)   #FUN-7C0028 add
     INTO l_ccu.ccu31,
          l_ccu.ccu32, l_ccu.ccu32a,l_ccu.ccu32b,
          l_ccu.ccu32c,l_ccu.ccu32d,l_ccu.ccu32e
         ,l_ccu.ccu32f,l_ccu.ccu32g,l_ccu.ccu32h   #FUN-7C0028 add
     FROM ccu_file, sfb_file
    WHERE ccu04=g_ima01 AND ccu02=yy AND ccu03=mm
      AND ccu06=type    AND ccu07=g_tlfcost    #FUN-7C0028 add
      AND ccu01=sfb01 AND sfb02 = '11' AND sfb99 = 'Y'
   IF l_ccu.ccu31 IS NULL THEN
      LET l_ccu.ccu31 =0 
   END IF
   IF l_ccu.ccu32 IS NULL THEN
      LET l_ccu.ccu32 =0 LET l_ccu.ccu32a=0 LET l_ccu.ccu32b=0
      LET l_ccu.ccu32c=0 LET l_ccu.ccu32d=0 LET l_ccu.ccu32e=0
      LET l_ccu.ccu32f=0 LET l_ccu.ccu32g=0 LET l_ccu.ccu32h=0   #FUN-7C0028 add
   END IF
   LET g_ccc.ccc31 =g_ccc.ccc31 +l_ccu.ccu31   #本月工單領用數量
   LET g_ccc.ccc32 =g_ccc.ccc32 +l_ccu.ccu32   #本月轉出金額(a+b+c+d+e+f+g+h)
END FUNCTION
 
FUNCTION p500_ccc_tot(p_sw)     # 計算所有出庫成本及結存
  DEFINE p_sw   LIKE type_file.chr1           #No.FUN-680122CHAR(1)
  DEFINE l_ccc92   LIKE ccc_file.ccc92        #No.MOD-920085 add
  DEFINE l_totqty    LIKE cxa_file.cxa08,
         l_totamt    LIKE cxa_file.cxa09,
         l_totamta   LIKE cxa_file.cxa091,
         l_totamtb   LIKE cxa_file.cxa092,
         l_totamtc   LIKE cxa_file.cxa093,
         l_totamtd   LIKE cxa_file.cxa094,
         l_totamte   LIKE cxa_file.cxa095,
         l_totamtf   LIKE cxa_file.cxa096,
         l_totamtg   LIKE cxa_file.cxa097,
         l_totamth   LIKE cxa_file.cxa098,
         l_sql       STRING,
         l_cxa       RECORD LIKE cxa_file.*
 
  LET g_sw = p_sw               #No.A102
  #--> 1:第一階段,先不處理重工 2:第二階段,處理重工
  IF p_sw='2' THEN CALL p500_ccc_ccc26() END IF
  CALL p500_ccc_ccc23()
  IF (p_sw='1' AND g_ccd03='N') OR (p_sw='2') OR (p_sw='3') OR (p_sw='4') THEN   #FUN-660086 add (p_sw='3')   #FUN-740253 add p_sw='4'
     IF p_sw != '4' THEN   #FUN-740253 add  #因為ccg5_cost()才計算完ccc32,不需清為0
        LET g_ccc.ccc32 = 0 # 工單領料
        LET g_ccc.ccc42 = 0 # 雜項領料
        LET g_ccc.ccc52 = 0 # 其他調整
        LET g_ccc.ccc62 = 0 # 銷貨成本
        LET g_ccc.ccc72 = 0 # 盤點盈虧
        LET g_ccc.ccc82 = 0 # 訂單成本   #FUN-690068 add
 
        LET g_ccc.ccc62a= 0 # 銷貨成本-材料
        LET g_ccc.ccc62b= 0 # 銷貨成本-人工
        LET g_ccc.ccc62c= 0 # 銷貨成本-製費一
        LET g_ccc.ccc62d= 0 # 銷貨成本-加工
        LET g_ccc.ccc62e= 0 # 銷貨成本-製費二
        LET g_ccc.ccc62f= 0 # 銷貨成本-製費三   #FUN-7C0028 add
        LET g_ccc.ccc62g= 0 # 銷貨成本-製費四   #FUN-7C0028 add
        LET g_ccc.ccc62h= 0 # 銷貨成本-製費五   #FUN-7C0028 add
        LET g_ccc.ccc66 = 0 # 銷退成本
        LET g_ccc.ccc66a= 0 # 銷退成本-材料
        LET g_ccc.ccc66b= 0 # 銷退成本-人工
        LET g_ccc.ccc66c= 0 # 銷退成本-製費一
        LET g_ccc.ccc66d= 0 # 銷退成本-加工
        LET g_ccc.ccc66e= 0 # 銷退成本-製費二
        LET g_ccc.ccc66f= 0 # 銷退成本-製費三   #FUN-7C0028 add
        LET g_ccc.ccc66g= 0 # 銷退成本-製費四   #FUN-7C0028 add
        LET g_ccc.ccc66h= 0 # 銷退成本-製費五   #FUN-7C0028 add
        LET g_ccc.ccc82a= 0 # 訂單成本-材料
        LET g_ccc.ccc82b= 0 # 訂單成本-人工
        LET g_ccc.ccc82c= 0 # 訂單成本-製費一
        LET g_ccc.ccc82d= 0 # 訂單成本-加工
        LET g_ccc.ccc82e= 0 # 訂單成本-製費二
        LET g_ccc.ccc82f= 0 # 訂單成本-製費三   #FUN-7C0028 add
        LET g_ccc.ccc82g= 0 # 訂單成本-製費四   #FUN-7C0028 add
        LET g_ccc.ccc82h= 0 # 訂單成本-製費五   #FUN-7C0028 add
           CALL p500_tlf21_upd()
        END IF                #CHI-7B0022 add
  END IF
 
  #重算金額欄位依ccz26取位
  CALL cl_digcut(g_ccc.ccc12a,g_ccz.ccz26) RETURNING g_ccc.ccc12a
  CALL cl_digcut(g_ccc.ccc12b,g_ccz.ccz26) RETURNING g_ccc.ccc12b
  CALL cl_digcut(g_ccc.ccc12c,g_ccz.ccz26) RETURNING g_ccc.ccc12c
  CALL cl_digcut(g_ccc.ccc12d,g_ccz.ccz26) RETURNING g_ccc.ccc12d
  CALL cl_digcut(g_ccc.ccc12e,g_ccz.ccz26) RETURNING g_ccc.ccc12e
  CALL cl_digcut(g_ccc.ccc12f,g_ccz.ccz26) RETURNING g_ccc.ccc12f   #FUN-7C0028 add
  CALL cl_digcut(g_ccc.ccc12g,g_ccz.ccz26) RETURNING g_ccc.ccc12g   #FUN-7C0028 add
  CALL cl_digcut(g_ccc.ccc12h,g_ccz.ccz26) RETURNING g_ccc.ccc12h   #FUN-7C0028 add
  LET g_ccc.ccc12  = g_ccc.ccc12a + g_ccc.ccc12b + g_ccc.ccc12c + g_ccc.ccc12d + g_ccc.ccc12e
                    +g_ccc.ccc12f + g_ccc.ccc12g + g_ccc.ccc12h   #FUN-7C0028 add
 
  CALL cl_digcut(g_ccc.ccc22a,g_ccz.ccz26) RETURNING g_ccc.ccc22a
  CALL cl_digcut(g_ccc.ccc22b,g_ccz.ccz26) RETURNING g_ccc.ccc22b
  CALL cl_digcut(g_ccc.ccc22c,g_ccz.ccz26) RETURNING g_ccc.ccc22c
  CALL cl_digcut(g_ccc.ccc22d,g_ccz.ccz26) RETURNING g_ccc.ccc22d
  CALL cl_digcut(g_ccc.ccc22e,g_ccz.ccz26) RETURNING g_ccc.ccc22e
  CALL cl_digcut(g_ccc.ccc22f,g_ccz.ccz26) RETURNING g_ccc.ccc22f   #FUN-7C0028 add
  CALL cl_digcut(g_ccc.ccc22g,g_ccz.ccz26) RETURNING g_ccc.ccc22g   #FUN-7C0028 add
  CALL cl_digcut(g_ccc.ccc22h,g_ccz.ccz26) RETURNING g_ccc.ccc22h   #FUN-7C0028 add
  LET g_ccc.ccc22  = g_ccc.ccc22a + g_ccc.ccc22b + g_ccc.ccc22c + g_ccc.ccc22d + g_ccc.ccc22e
                    +g_ccc.ccc22f + g_ccc.ccc22g + g_ccc.ccc22h   #FUN-7C0028 add
 
  CALL cl_digcut(g_ccc.ccc26a,g_ccz.ccz26) RETURNING g_ccc.ccc26a
  CALL cl_digcut(g_ccc.ccc26b,g_ccz.ccz26) RETURNING g_ccc.ccc26b
  CALL cl_digcut(g_ccc.ccc26c,g_ccz.ccz26) RETURNING g_ccc.ccc26c
  CALL cl_digcut(g_ccc.ccc26d,g_ccz.ccz26) RETURNING g_ccc.ccc26d
  CALL cl_digcut(g_ccc.ccc26e,g_ccz.ccz26) RETURNING g_ccc.ccc26e
  CALL cl_digcut(g_ccc.ccc26f,g_ccz.ccz26) RETURNING g_ccc.ccc26f   #FUN-7C0028 add
  CALL cl_digcut(g_ccc.ccc26g,g_ccz.ccz26) RETURNING g_ccc.ccc26g   #FUN-7C0028 add
  CALL cl_digcut(g_ccc.ccc26h,g_ccz.ccz26) RETURNING g_ccc.ccc26h   #FUN-7C0028 add
  LET g_ccc.ccc26  = g_ccc.ccc26a + g_ccc.ccc26b + g_ccc.ccc26c + g_ccc.ccc26d + g_ccc.ccc26e
                    +g_ccc.ccc26f + g_ccc.ccc26g + g_ccc.ccc26h   #FUN-7C0028 add
 
  CALL cl_digcut(g_ccc.ccc28a,g_ccz.ccz26) RETURNING g_ccc.ccc28a
  CALL cl_digcut(g_ccc.ccc28b,g_ccz.ccz26) RETURNING g_ccc.ccc28b
  CALL cl_digcut(g_ccc.ccc28c,g_ccz.ccz26) RETURNING g_ccc.ccc28c
  CALL cl_digcut(g_ccc.ccc28d,g_ccz.ccz26) RETURNING g_ccc.ccc28d
  CALL cl_digcut(g_ccc.ccc28e,g_ccz.ccz26) RETURNING g_ccc.ccc28e
  CALL cl_digcut(g_ccc.ccc28f,g_ccz.ccz26) RETURNING g_ccc.ccc28f   #FUN-7C0028 add
  CALL cl_digcut(g_ccc.ccc28g,g_ccz.ccz26) RETURNING g_ccc.ccc28g   #FUN-7C0028 add
  CALL cl_digcut(g_ccc.ccc28h,g_ccz.ccz26) RETURNING g_ccc.ccc28h   #FUN-7C0028 add
  LET g_ccc.ccc28  = g_ccc.ccc28a + g_ccc.ccc28b + g_ccc.ccc28c + g_ccc.ccc28d + g_ccc.ccc28e
                    +g_ccc.ccc28f + g_ccc.ccc28g + g_ccc.ccc28h   #FUN-7C0028 add
 
  CALL cl_digcut(g_ccc.ccc32,g_ccz.ccz26) RETURNING g_ccc.ccc32
  CALL cl_digcut(g_ccc.ccc42,g_ccz.ccz26) RETURNING g_ccc.ccc42
  CALL cl_digcut(g_ccc.ccc44,g_ccz.ccz26) RETURNING g_ccc.ccc44
  CALL cl_digcut(g_ccc.ccc52,g_ccz.ccz26) RETURNING g_ccc.ccc52
  CALL cl_digcut(g_ccc.ccc62,g_ccz.ccz26) RETURNING g_ccc.ccc62
  CALL cl_digcut(g_ccc.ccc63,g_ccz.ccz26) RETURNING g_ccc.ccc63
  CALL cl_digcut(g_ccc.ccc72,g_ccz.ccz26) RETURNING g_ccc.ccc72
  CALL cl_digcut(g_ccc.ccc82,g_ccz.ccz26) RETURNING g_ccc.ccc82   #FUN-690068 add
  
  CALL cl_digcut(g_ccc.ccc62a,g_ccz.ccz26) RETURNING g_ccc.ccc62a                                                                   
  CALL cl_digcut(g_ccc.ccc62b,g_ccz.ccz26) RETURNING g_ccc.ccc62b                                                                   
  CALL cl_digcut(g_ccc.ccc62c,g_ccz.ccz26) RETURNING g_ccc.ccc62c                                                                   
  CALL cl_digcut(g_ccc.ccc62d,g_ccz.ccz26) RETURNING g_ccc.ccc62d                                                                   
  CALL cl_digcut(g_ccc.ccc62e,g_ccz.ccz26) RETURNING g_ccc.ccc62e                                                                   
  CALL cl_digcut(g_ccc.ccc62f,g_ccz.ccz26) RETURNING g_ccc.ccc62f  #No:MOD-A10068 add                                                                  
  CALL cl_digcut(g_ccc.ccc62g,g_ccz.ccz26) RETURNING g_ccc.ccc62g  #No:MOD-A10068 add                                                                  
  CALL cl_digcut(g_ccc.ccc62h,g_ccz.ccz26) RETURNING g_ccc.ccc62h  #No:MOD-A10068 add                                                                  
  LET g_ccc.ccc62  = g_ccc.ccc62a + g_ccc.ccc62b + g_ccc.ccc62c + g_ccc.ccc62d + g_ccc.ccc62e                                       
                     + g_ccc.ccc62f + g_ccc.ccc62g + g_ccc.ccc62h     #No:MOD-A10068 add                                     
                                                                                                                                    
  CALL cl_digcut(g_ccc.ccc65,g_ccz.ccz26) RETURNING g_ccc.ccc65                                                                     
                                                                                                                                    
  CALL cl_digcut(g_ccc.ccc66a,g_ccz.ccz26) RETURNING g_ccc.ccc66a                                                                   
  CALL cl_digcut(g_ccc.ccc66b,g_ccz.ccz26) RETURNING g_ccc.ccc66b                                                                   
  CALL cl_digcut(g_ccc.ccc66c,g_ccz.ccz26) RETURNING g_ccc.ccc66c                                                                   
  CALL cl_digcut(g_ccc.ccc66d,g_ccz.ccz26) RETURNING g_ccc.ccc66d                                                                   
  CALL cl_digcut(g_ccc.ccc66e,g_ccz.ccz26) RETURNING g_ccc.ccc66e                                                                   
  CALL cl_digcut(g_ccc.ccc66f,g_ccz.ccz26) RETURNING g_ccc.ccc66f  #No:MOD-A10068 add                                                                  
  CALL cl_digcut(g_ccc.ccc66g,g_ccz.ccz26) RETURNING g_ccc.ccc66g  #No:MOD-A10068 add                                                                  
  CALL cl_digcut(g_ccc.ccc66h,g_ccz.ccz26) RETURNING g_ccc.ccc66h  #No:MOD-A10068 add                                                                  
  LET g_ccc.ccc66  = g_ccc.ccc66a + g_ccc.ccc66b + g_ccc.ccc66c + g_ccc.ccc66d + g_ccc.ccc66e                                       
                     + g_ccc.ccc66f + g_ccc.ccc66g + g_ccc.ccc66h    #No:MOD-A10068 add                                     
                                                                                                                                    
  CALL cl_digcut(g_ccc.ccc82a,g_ccz.ccz26) RETURNING g_ccc.ccc82a                                                                   
  CALL cl_digcut(g_ccc.ccc82b,g_ccz.ccz26) RETURNING g_ccc.ccc82b                                                                   
  CALL cl_digcut(g_ccc.ccc82c,g_ccz.ccz26) RETURNING g_ccc.ccc82c                                                                   
  CALL cl_digcut(g_ccc.ccc82d,g_ccz.ccz26) RETURNING g_ccc.ccc82d                                                                   
  CALL cl_digcut(g_ccc.ccc82e,g_ccz.ccz26) RETURNING g_ccc.ccc82e                                                                   
  CALL cl_digcut(g_ccc.ccc82f,g_ccz.ccz26) RETURNING g_ccc.ccc82f  #No:MOD-A10068 add                                                                  
  CALL cl_digcut(g_ccc.ccc82g,g_ccz.ccz26) RETURNING g_ccc.ccc82g  #No:MOD-A10068 add                                                                  
  CALL cl_digcut(g_ccc.ccc82h,g_ccz.ccz26) RETURNING g_ccc.ccc82h  #No:MOD-A10068 add                                                                  
  LET g_ccc.ccc82  = g_ccc.ccc82a + g_ccc.ccc82b + g_ccc.ccc82c + g_ccc.ccc82d + g_ccc.ccc82e      
                     + g_ccc.ccc82f + g_ccc.ccc82g + g_ccc.ccc82h    #No:MOD-A10068 add                                     
  CALL cl_digcut(g_ccc.ccc22a1,g_ccz.ccz26) RETURNING g_ccc.ccc22a1
  CALL cl_digcut(g_ccc.ccc22b1,g_ccz.ccz26) RETURNING g_ccc.ccc22b1
  CALL cl_digcut(g_ccc.ccc22c1,g_ccz.ccz26) RETURNING g_ccc.ccc22c1
  CALL cl_digcut(g_ccc.ccc22d1,g_ccz.ccz26) RETURNING g_ccc.ccc22d1
  CALL cl_digcut(g_ccc.ccc22e1,g_ccz.ccz26) RETURNING g_ccc.ccc22e1
  CALL cl_digcut(g_ccc.ccc22f1,g_ccz.ccz26) RETURNING g_ccc.ccc22f1   #FUN-7C0028 add
  CALL cl_digcut(g_ccc.ccc22g1,g_ccz.ccz26) RETURNING g_ccc.ccc22g1   #FUN-7C0028 add
  CALL cl_digcut(g_ccc.ccc22h1,g_ccz.ccz26) RETURNING g_ccc.ccc22h1   #FUN-7C0028 add
  LET g_ccc.ccc221 = g_ccc.ccc22a1 + g_ccc.ccc22b1 + g_ccc.ccc22c1 + g_ccc.ccc22d1 + g_ccc.ccc22e1
                    +g_ccc.ccc22f1 + g_ccc.ccc22g1 + g_ccc.ccc22h1   #FUN-7C0028 add
 
  CALL cl_digcut(g_ccc.ccc22a2,g_ccz.ccz26) RETURNING g_ccc.ccc22a2
  CALL cl_digcut(g_ccc.ccc22b2,g_ccz.ccz26) RETURNING g_ccc.ccc22b2
  CALL cl_digcut(g_ccc.ccc22c2,g_ccz.ccz26) RETURNING g_ccc.ccc22c2
  CALL cl_digcut(g_ccc.ccc22d2,g_ccz.ccz26) RETURNING g_ccc.ccc22d2
  CALL cl_digcut(g_ccc.ccc22e2,g_ccz.ccz26) RETURNING g_ccc.ccc22e2
  CALL cl_digcut(g_ccc.ccc22f2,g_ccz.ccz26) RETURNING g_ccc.ccc22f2   #FUN-7C0028 add
  CALL cl_digcut(g_ccc.ccc22g2,g_ccz.ccz26) RETURNING g_ccc.ccc22g2   #FUN-7C0028 add
  CALL cl_digcut(g_ccc.ccc22h2,g_ccz.ccz26) RETURNING g_ccc.ccc22h2   #FUN-7C0028 add
  LET g_ccc.ccc222 = g_ccc.ccc22a2 + g_ccc.ccc22b2 + g_ccc.ccc22c2 + g_ccc.ccc22d2 + g_ccc.ccc22e2
                    +g_ccc.ccc22f2 + g_ccc.ccc22g2 + g_ccc.ccc22h2   #FUN-7C0028 add
 
  CALL cl_digcut(g_ccc.ccc22a3,g_ccz.ccz26) RETURNING g_ccc.ccc22a3
  CALL cl_digcut(g_ccc.ccc22b3,g_ccz.ccz26) RETURNING g_ccc.ccc22b3
  CALL cl_digcut(g_ccc.ccc22c3,g_ccz.ccz26) RETURNING g_ccc.ccc22c3
  CALL cl_digcut(g_ccc.ccc22d3,g_ccz.ccz26) RETURNING g_ccc.ccc22d3
  CALL cl_digcut(g_ccc.ccc22e3,g_ccz.ccz26) RETURNING g_ccc.ccc22e3
  CALL cl_digcut(g_ccc.ccc22f3,g_ccz.ccz26) RETURNING g_ccc.ccc22f3   #FUN-7C0028 add
  CALL cl_digcut(g_ccc.ccc22g3,g_ccz.ccz26) RETURNING g_ccc.ccc22g3   #FUN-7C0028 add
  CALL cl_digcut(g_ccc.ccc22h3,g_ccz.ccz26) RETURNING g_ccc.ccc22h3   #FUN-7C0028 add
  LET g_ccc.ccc223 = g_ccc.ccc22a3 + g_ccc.ccc22b3 + g_ccc.ccc22c3 + g_ccc.ccc22d3 + g_ccc.ccc22e3
                    +g_ccc.ccc22f3 + g_ccc.ccc22g3 + g_ccc.ccc22h3   #FUN-7C0028 add
 
  CALL cl_digcut(g_ccc.ccc22a4,g_ccz.ccz26) RETURNING g_ccc.ccc22a4
  CALL cl_digcut(g_ccc.ccc22b4,g_ccz.ccz26) RETURNING g_ccc.ccc22b4
  CALL cl_digcut(g_ccc.ccc22c4,g_ccz.ccz26) RETURNING g_ccc.ccc22c4
  CALL cl_digcut(g_ccc.ccc22d4,g_ccz.ccz26) RETURNING g_ccc.ccc22d4
  CALL cl_digcut(g_ccc.ccc22e4,g_ccz.ccz26) RETURNING g_ccc.ccc22e4
  CALL cl_digcut(g_ccc.ccc22f4,g_ccz.ccz26) RETURNING g_ccc.ccc22f4   #FUN-7C0028 add
  CALL cl_digcut(g_ccc.ccc22g4,g_ccz.ccz26) RETURNING g_ccc.ccc22g4   #FUN-7C0028 add
  CALL cl_digcut(g_ccc.ccc22h4,g_ccz.ccz26) RETURNING g_ccc.ccc22h4   #FUN-7C0028 add
  LET g_ccc.ccc224 = g_ccc.ccc22a4 + g_ccc.ccc22b4 + g_ccc.ccc22c4 + g_ccc.ccc22d4 + g_ccc.ccc22e4
                    +g_ccc.ccc22f4 + g_ccc.ccc22g4 + g_ccc.ccc22h4   #FUN-7C0028 add
 
  CALL cl_digcut(g_ccc.ccc22a5,g_ccz.ccz26) RETURNING g_ccc.ccc22a5
  CALL cl_digcut(g_ccc.ccc22b5,g_ccz.ccz26) RETURNING g_ccc.ccc22b5
  CALL cl_digcut(g_ccc.ccc22c5,g_ccz.ccz26) RETURNING g_ccc.ccc22c5
  CALL cl_digcut(g_ccc.ccc22d5,g_ccz.ccz26) RETURNING g_ccc.ccc22d5
  CALL cl_digcut(g_ccc.ccc22e5,g_ccz.ccz26) RETURNING g_ccc.ccc22e5
  CALL cl_digcut(g_ccc.ccc22f5,g_ccz.ccz26) RETURNING g_ccc.ccc22f5   #FUN-7C0028 add
  CALL cl_digcut(g_ccc.ccc22g5,g_ccz.ccz26) RETURNING g_ccc.ccc22g5   #FUN-7C0028 add
  CALL cl_digcut(g_ccc.ccc22h5,g_ccz.ccz26) RETURNING g_ccc.ccc22h5   #FUN-7C0028 add
  LET g_ccc.ccc225 = g_ccc.ccc22a5 + g_ccc.ccc22b5 + g_ccc.ccc22c5 + g_ccc.ccc22d5 + g_ccc.ccc22e5
                    +g_ccc.ccc22f5 + g_ccc.ccc22g5 + g_ccc.ccc22h5   #FUN-7C0028 add
 
  #CHI-980045(S)
  IF g_ccz.ccz31 MATCHES '[23]' THEN
     CALL cl_digcut(g_ccc.ccc22a6,g_ccz.ccz26) RETURNING g_ccc.ccc22a6
     CALL cl_digcut(g_ccc.ccc22b6,g_ccz.ccz26) RETURNING g_ccc.ccc22b6
     CALL cl_digcut(g_ccc.ccc22c6,g_ccz.ccz26) RETURNING g_ccc.ccc22c6
     CALL cl_digcut(g_ccc.ccc22d6,g_ccz.ccz26) RETURNING g_ccc.ccc22d6
     CALL cl_digcut(g_ccc.ccc22e6,g_ccz.ccz26) RETURNING g_ccc.ccc22e6
     CALL cl_digcut(g_ccc.ccc22f6,g_ccz.ccz26) RETURNING g_ccc.ccc22f6
     CALL cl_digcut(g_ccc.ccc22g6,g_ccz.ccz26) RETURNING g_ccc.ccc22g6
     CALL cl_digcut(g_ccc.ccc22h6,g_ccz.ccz26) RETURNING g_ccc.ccc22h6
     LET g_ccc.ccc226 = g_ccc.ccc22a6 + g_ccc.ccc22b6 + g_ccc.ccc22c6 + g_ccc.ccc22d6 + g_ccc.ccc22e6
                       +g_ccc.ccc22f6 + g_ccc.ccc22g6 + g_ccc.ccc22h6
  END IF
  #CHI-980045(E)

  IF type = '2' THEN          #先進先出算法
     LET l_sql="SELECT * FROM cxa_file",
               " WHERE cxa01='",g_ccc.ccc01 CLIPPED,"'",
               "   AND cxa02=",g_ccc.ccc02," AND cxa03=",g_ccc.ccc03,
               "   AND cxa010='",g_ccc.ccc07,"' "
     PREPARE ccctot_pre FROM l_sql
     DECLARE ccctot_cur CURSOR FOR ccctot_pre
     LET l_totqty=0     LET l_totamt=0
     LET l_totamta=0    LET l_totamtb=0
     LET l_totamtc=0    LET l_totamtd=0
     LET l_totamte=0    LET l_totamtg=0
     LET l_totamtf=0    LET l_totamth=0
     LET g_ccc.ccc91=0  LET g_ccc.ccc92=0
     LET g_ccc.ccc92a=0 LET g_ccc.ccc92b=0 LET g_ccc.ccc92c=0
     LET g_ccc.ccc92d=0 LET g_ccc.ccc92e=0 LET g_ccc.ccc92f=0
     LET g_ccc.ccc92g=0 LET g_ccc.ccc92h=0
     FOREACH ccctot_cur INTO l_cxa.*
        IF cl_null(l_cxa.cxa08) THEN LET l_cxa.cxa08=0 END IF
        IF cl_null(l_cxa.cxa09) THEN LET l_cxa.cxa09=0 END IF
        IF cl_null(l_cxa.cxa10) THEN LET l_cxa.cxa10=0 END IF
        IF cl_null(l_cxa.cxa091) THEN LET l_cxa.cxa091=0 END IF
        IF cl_null(l_cxa.cxa092) THEN LET l_cxa.cxa092=0 END IF
        IF cl_null(l_cxa.cxa093) THEN LET l_cxa.cxa093=0 END IF
        IF cl_null(l_cxa.cxa094) THEN LET l_cxa.cxa094=0 END IF
        IF cl_null(l_cxa.cxa095) THEN LET l_cxa.cxa095=0 END IF
        IF cl_null(l_cxa.cxa096) THEN LET l_cxa.cxa096=0 END IF
        IF cl_null(l_cxa.cxa097) THEN LET l_cxa.cxa097=0 END IF
        IF cl_null(l_cxa.cxa098) THEN LET l_cxa.cxa098=0 END IF
        LET g_ccc.ccc91=g_ccc.ccc91+(l_cxa.cxa08-l_cxa.cxa10)
        LET g_ccc.ccc92a=g_ccc.ccc92a+(l_cxa.cxa08-l_cxa.cxa10)*(l_cxa.cxa091/l_cxa.cxa08)
        LET g_ccc.ccc92b=g_ccc.ccc92b+(l_cxa.cxa08-l_cxa.cxa10)*(l_cxa.cxa092/l_cxa.cxa08)
        LET g_ccc.ccc92c=g_ccc.ccc92c+(l_cxa.cxa08-l_cxa.cxa10)*(l_cxa.cxa093/l_cxa.cxa08)
        LET g_ccc.ccc92d=g_ccc.ccc92d+(l_cxa.cxa08-l_cxa.cxa10)*(l_cxa.cxa094/l_cxa.cxa08)
        LET g_ccc.ccc92e=g_ccc.ccc92e+(l_cxa.cxa08-l_cxa.cxa10)*(l_cxa.cxa095/l_cxa.cxa08)
        LET g_ccc.ccc92f=g_ccc.ccc92f+(l_cxa.cxa08-l_cxa.cxa10)*(l_cxa.cxa096/l_cxa.cxa08)
        LET g_ccc.ccc92g=g_ccc.ccc92g+(l_cxa.cxa08-l_cxa.cxa10)*(l_cxa.cxa097/l_cxa.cxa08)
        LET g_ccc.ccc92h=g_ccc.ccc92h+(l_cxa.cxa08-l_cxa.cxa10)*(l_cxa.cxa098/l_cxa.cxa08)
        LET g_ccc.ccc92 =g_ccc.ccc92 +(l_cxa.cxa08-l_cxa.cxa10)*(l_cxa.cxa09/l_cxa.cxa08)
        LET l_totqty=l_totqty+l_cxa.cxa08
        LET l_totamt=l_totamt+l_cxa.cxa09
        LET l_totamta=l_totamta+l_cxa.cxa091
        LET l_totamtb=l_totamtb+l_cxa.cxa092
        LET l_totamtc=l_totamtc+l_cxa.cxa093
        LET l_totamtd=l_totamtd+l_cxa.cxa094
        LET l_totamte=l_totamte+l_cxa.cxa095
        LET l_totamtf=l_totamtf+l_cxa.cxa096
        LET l_totamtg=l_totamtg+l_cxa.cxa097
        LET l_totamth=l_totamth+l_cxa.cxa098
     END FOREACH
     IF cl_null(g_ccc.ccc91) THEN LET g_ccc.ccc91 = 0 END IF
     IF cl_null(g_ccc.ccc92a) THEN LET g_ccc.ccc92a = 0 END IF
     IF cl_null(g_ccc.ccc92b) THEN LET g_ccc.ccc92b = 0 END IF
     IF cl_null(g_ccc.ccc92c) THEN LET g_ccc.ccc92c = 0 END IF
     IF cl_null(g_ccc.ccc92d) THEN LET g_ccc.ccc92d = 0 END IF
     IF cl_null(g_ccc.ccc92e) THEN LET g_ccc.ccc92e = 0 END IF
     IF cl_null(g_ccc.ccc92f) THEN LET g_ccc.ccc92f = 0 END IF
     IF cl_null(g_ccc.ccc92g) THEN LET g_ccc.ccc92g = 0 END IF
     IF cl_null(g_ccc.ccc92h) THEN LET g_ccc.ccc92h = 0 END IF
     CALL cl_digcut(g_ccc.ccc92a,g_ccz.ccz26) RETURNING g_ccc.ccc92a
     CALL cl_digcut(g_ccc.ccc92b,g_ccz.ccz26) RETURNING g_ccc.ccc92b
     CALL cl_digcut(g_ccc.ccc92c,g_ccz.ccz26) RETURNING g_ccc.ccc92c
     CALL cl_digcut(g_ccc.ccc92d,g_ccz.ccz26) RETURNING g_ccc.ccc92d
     CALL cl_digcut(g_ccc.ccc92e,g_ccz.ccz26) RETURNING g_ccc.ccc92e
     CALL cl_digcut(g_ccc.ccc92f,g_ccz.ccz26) RETURNING g_ccc.ccc92f
     CALL cl_digcut(g_ccc.ccc92g,g_ccz.ccz26) RETURNING g_ccc.ccc92g
     CALL cl_digcut(g_ccc.ccc92h,g_ccz.ccz26) RETURNING g_ccc.ccc92h
     IF cl_null(g_ccc.ccc92) THEN LET g_ccc.ccc92 = 0 END IF
     LET g_ccc.ccc92 = g_ccc.ccc92a + g_ccc.ccc92b + g_ccc.ccc92c + g_ccc.ccc92d
                      +g_ccc.ccc92e + g_ccc.ccc92f + g_ccc.ccc92g + g_ccc.ccc92h
     CALL cl_digcut(g_ccc.ccc92,g_ccz.ccz26) RETURNING g_ccc.ccc92
     LET g_ccc.ccc23 =l_totamt/l_totqty
     LET g_ccc.ccc23a=l_totamta/l_totqty
     LET g_ccc.ccc23b=l_totamtb/l_totqty
     LET g_ccc.ccc23c=l_totamtc/l_totqty
     LET g_ccc.ccc23d=l_totamtd/l_totqty
     LET g_ccc.ccc23e=l_totamte/l_totqty
     LET g_ccc.ccc23f=l_totamtf/l_totqty
     LET g_ccc.ccc23g=l_totamtg/l_totqty
     LET g_ccc.ccc23h=l_totamth/l_totqty
     LET l_ccc92 = g_ccc.ccc12 + g_ccc.ccc22 + g_ccc.ccc26 + g_ccc.ccc28 +
                   g_ccc.ccc32 + g_ccc.ccc42 + g_ccc.ccc52 + g_ccc.ccc62 +
                   g_ccc.ccc72 + g_ccc.ccc82
     LET g_ccc.ccc93 = g_ccc.ccc92 - l_ccc92
     CALL cl_digcut(g_ccc.ccc93,g_ccz.ccz26) RETURNING g_ccc.ccc93
  ELSE
     LET g_ccc.ccc91 = g_ccc.ccc11 + g_ccc.ccc21 + g_ccc.ccc25 + g_ccc.ccc27 +
         g_ccc.ccc31 + g_ccc.ccc41 + g_ccc.ccc51 + g_ccc.ccc61 + g_ccc.ccc71 +
         g_ccc.ccc81   #FUN-690068 add
     LET g_ccc.ccc92 = g_ccc.ccc12 + g_ccc.ccc22 + g_ccc.ccc26 + g_ccc.ccc28 +
         g_ccc.ccc32 + g_ccc.ccc42 + g_ccc.ccc52 + g_ccc.ccc62 + g_ccc.ccc72 +
         g_ccc.ccc82   #FUN-690068 add
     LET g_ccc.ccc92a= g_ccc.ccc91 * g_ccc.ccc23a
     LET g_ccc.ccc92b= g_ccc.ccc91 * g_ccc.ccc23b
     LET g_ccc.ccc92c= g_ccc.ccc91 * g_ccc.ccc23c
     LET g_ccc.ccc92d= g_ccc.ccc91 * g_ccc.ccc23d
     LET g_ccc.ccc92e= g_ccc.ccc91 * g_ccc.ccc23e
     LET g_ccc.ccc92f= g_ccc.ccc91 * g_ccc.ccc23f   #FUN-7C0028 add
     LET g_ccc.ccc92g= g_ccc.ccc91 * g_ccc.ccc23g   #FUN-7C0028 add
     LET g_ccc.ccc92h= g_ccc.ccc91 * g_ccc.ccc23h   #FUN-7C0028 add
     # 以下這段是為了使金額平衡
    #應該是要金額先取完位候在進行尾差調整
     CALL cl_digcut(g_ccc.ccc92 ,g_ccz.ccz26) RETURNING g_ccc.ccc92 
     CALL cl_digcut(g_ccc.ccc92a,g_ccz.ccz26) RETURNING g_ccc.ccc92a
     CALL cl_digcut(g_ccc.ccc92b,g_ccz.ccz26) RETURNING g_ccc.ccc92b
     CALL cl_digcut(g_ccc.ccc92c,g_ccz.ccz26) RETURNING g_ccc.ccc92c
     CALL cl_digcut(g_ccc.ccc92d,g_ccz.ccz26) RETURNING g_ccc.ccc92d
     CALL cl_digcut(g_ccc.ccc92e,g_ccz.ccz26) RETURNING g_ccc.ccc92e
     LET g_ccc.ccc92a= g_ccc.ccc92 - g_ccc.ccc92b - g_ccc.ccc92c
                                   - g_ccc.ccc92f - g_ccc.ccc92g - g_ccc.ccc92h   #FUN-7C0028 add
                                   - g_ccc.ccc92d - g_ccc.ccc92e
     #----------------------------- 將金額更新回 tlf21x, 以便以後製表方便
     #差異成本存入
     LET g_ccc.ccc93 = g_ccc.ccc91 * g_ccc.ccc23a
     CALL cl_digcut(g_ccc.ccc93,g_ccz.ccz26) RETURNING g_ccc.ccc93   #No.MOD-8C0136 add
     LET g_ccc.ccc93 = g_ccc.ccc93 - g_ccc.ccc92a
   
     LET g_ccc.ccc92a= g_ccc.ccc91 * g_ccc.ccc23a
     LET g_ccc.ccc92b= g_ccc.ccc91 * g_ccc.ccc23b
     LET g_ccc.ccc92c= g_ccc.ccc91 * g_ccc.ccc23c
     LET g_ccc.ccc92d= g_ccc.ccc91 * g_ccc.ccc23d
     LET g_ccc.ccc92e= g_ccc.ccc91 * g_ccc.ccc23e
     LET g_ccc.ccc92f= g_ccc.ccc91 * g_ccc.ccc23f   #FUN-7C0028 add
     LET g_ccc.ccc92g= g_ccc.ccc91 * g_ccc.ccc23g   #FUN-7C0028 add
     LET g_ccc.ccc92h= g_ccc.ccc91 * g_ccc.ccc23h   #FUN-7C0028 add
     CALL cl_digcut(g_ccc.ccc92a,g_ccz.ccz26) RETURNING g_ccc.ccc92a
     CALL cl_digcut(g_ccc.ccc92b,g_ccz.ccz26) RETURNING g_ccc.ccc92b
     CALL cl_digcut(g_ccc.ccc92c,g_ccz.ccz26) RETURNING g_ccc.ccc92c
     CALL cl_digcut(g_ccc.ccc92d,g_ccz.ccz26) RETURNING g_ccc.ccc92d
     CALL cl_digcut(g_ccc.ccc92e,g_ccz.ccz26) RETURNING g_ccc.ccc92e
     CALL cl_digcut(g_ccc.ccc92f,g_ccz.ccz26) RETURNING g_ccc.ccc92f   #FUN-7C0028 add
     CALL cl_digcut(g_ccc.ccc92g,g_ccz.ccz26) RETURNING g_ccc.ccc92g   #FUN-7C0028 add
     CALL cl_digcut(g_ccc.ccc92h,g_ccz.ccz26) RETURNING g_ccc.ccc92h   #FUN-7C0028 add
     LET g_ccc.ccc92 = g_ccc.ccc92a + g_ccc.ccc92b + g_ccc.ccc92c +
                       g_ccc.ccc92d + g_ccc.ccc92e
                      +g_ccc.ccc92f + g_ccc.ccc92g + g_ccc.ccc92h   #FUN-7C0028 add
  END IF       #No.MOD-920085 add
 
END FUNCTION
 
FUNCTION p500_ccc_ccc26()
DEFINE l_ccc25  LIKE ccc_file.ccc25
DEFINE l_ccc26  LIKE ccc_file.ccc26
DEFINE l_ccc26a LIKE ccc_file.ccc26a
DEFINE l_ccc26b LIKE ccc_file.ccc26b
DEFINE l_ccc26c LIKE ccc_file.ccc26c
DEFINE l_ccc26d LIKE ccc_file.ccc26d
DEFINE l_ccc26e LIKE ccc_file.ccc26e
DEFINE l_ccc26f LIKE ccc_file.ccc26f   #FUN-7C0028 add
DEFINE l_ccc26g LIKE ccc_file.ccc26g   #FUN-7C0028 add
DEFINE l_ccc26h LIKE ccc_file.ccc26h   #FUN-7C0028 add
 
  SELECT SUM(cch22a*-1),SUM(cch22b*-1),SUM(cch22c*-1),
         SUM(cch22d*-1),SUM(cch22e*-1),
         SUM(cch22f*-1),SUM(cch22g*-1),SUM(cch22h*-1),   #FUN-7C0028 add   #MOD-840314 mod
         SUM(cch22 *-1),SUM(cch21*-1)
    INTO g_ccc.ccc26a, g_ccc.ccc26b, g_ccc.ccc26c,
         g_ccc.ccc26d, g_ccc.ccc26e,
         g_ccc.ccc26f, g_ccc.ccc26g, g_ccc.ccc26h,      #FUN-7C0028 add
         g_ccc.ccc26,l_ccc25
    FROM cch_file
   WHERE cch04=g_ccc.ccc01 AND cch02=yy AND cch03=mm AND cch05='R'
     AND cch06=type        AND cch07=g_tlfcost   #FUN-7C0028 add
  IF cl_null(g_ccc.ccc26a) THEN
     LET g_ccc.ccc26 = 0 LET g_ccc.ccc26a= 0 LET g_ccc.ccc26b= 0 
     LET g_ccc.ccc26c= 0 LET g_ccc.ccc26d= 0 LET g_ccc.ccc26e= 0
     LET g_ccc.ccc26f= 0 LET g_ccc.ccc26g= 0 LET g_ccc.ccc26h= 0  #FUN-7C0028 add
  END IF
  # 98.08.12 Star For 拆件式
  # 拆件式的領出
  LET l_ccc26  = 0 LET l_ccc26a = 0 LET l_ccc26b = 0
  LET l_ccc26c = 0 LET l_ccc26d = 0 LET l_ccc26e = 0
  LET l_ccc26f = 0 LET l_ccc26g = 0 LET l_ccc26h = 0    #FUN-7C0028 add
  SELECT SUM(ccu22 *-1),SUM(ccu22a*-1),SUM(ccu22b*-1),
         SUM(ccu22c*-1),SUM(ccu22d*-1),SUM(ccu22e*-1),
         SUM(ccu22f*-1),SUM(ccu22g*-1),SUM(ccu22h*-1)   #FUN-7C0028 add
    INTO l_ccc26,  l_ccc26a, l_ccc26b,
         l_ccc26c, l_ccc26d, l_ccc26e,
         l_ccc26f, l_ccc26g, l_ccc26h    #FUN-7C0028 add
    FROM ccu_file
   WHERE ccu04=g_ccc.ccc01 AND ccu02=yy AND ccu03=mm AND ccu05='R'
     AND ccu06=type        AND ccu07=g_tlfcost   #FUN-7C0028 add
  IF l_ccc26a IS NULL THEN
     LET l_ccc26 = 0 LET l_ccc26a= 0 LET l_ccc26b= 0
     LET l_ccc26c= 0 LET l_ccc26d= 0 LET l_ccc26e= 0
     LET l_ccc26f= 0 LET l_ccc26g= 0 LET l_ccc26h= 0  #FUN-7C0028 add
  END IF
 
  LET g_ccc.ccc26  = g_ccc.ccc26  + l_ccc26
  LET g_ccc.ccc26a = g_ccc.ccc26a + l_ccc26a
  LET g_ccc.ccc26b = g_ccc.ccc26b + l_ccc26b
  LET g_ccc.ccc26c = g_ccc.ccc26c + l_ccc26c
  LET g_ccc.ccc26d = g_ccc.ccc26d + l_ccc26d
  LET g_ccc.ccc26e = g_ccc.ccc26e + l_ccc26e
  LET g_ccc.ccc26f = g_ccc.ccc26f + l_ccc26f   #FUN-7C0028 add
  LET g_ccc.ccc26g = g_ccc.ccc26g + l_ccc26g   #FUN-7C0028 add
  LET g_ccc.ccc26h = g_ccc.ccc26h + l_ccc26h   #FUN-7C0028 add
END FUNCTION
 
#---->重工領部份
FUNCTION p500_ccc_ccc23()
# DEFINE qty    LIKE ima_file.ima26           #No.FUN-680122DEC(15,3)
  DEFINE qty    LIKE type_file.num15_3        ###GP5.2  #NO.FUN-A40023
  DEFINE l_c23,l_c23a,l_c23b,l_c23c,l_c23d,l_c23e LIKE ccc_file.ccc23
  DEFINE l_c23f,l_c23g,l_c23h                     LIKE ccc_file.ccc23   #FUN-7C0028 add
 
  LET l_c23 = g_ccc.ccc23
  LET l_c23a = g_ccc.ccc23a
  LET l_c23b = g_ccc.ccc23b
  LET l_c23c = g_ccc.ccc23c
  LET l_c23d = g_ccc.ccc23d
  LET l_c23e = g_ccc.ccc23e
  LET l_c23f = g_ccc.ccc23f   #FUN-7C0028 add
  LET l_c23g = g_ccc.ccc23g   #FUN-7C0028 add
  LET l_c23h = g_ccc.ccc23h   #FUN-7C0028 add
  LET qty=g_ccc.ccc11+g_ccc.ccc21+g_ccc.ccc25+g_ccc.ccc27
  IF qty=0 THEN                 # get unit cost from last month
     # 98.08.19 Star 若因重工領或入而將數量清為零
     IF (g_ccc.ccc11+g_ccc.ccc21+g_ccc.ccc27) != 0 THEN
        LET g_ccc.ccc23a=(g_ccc.ccc12a+g_ccc.ccc22a+g_ccc.ccc28a)
                        /(g_ccc.ccc11+g_ccc.ccc21+g_ccc.ccc27)
        LET g_ccc.ccc23b=(g_ccc.ccc12b+g_ccc.ccc22b+g_ccc.ccc28b)
                        /(g_ccc.ccc11+g_ccc.ccc21+g_ccc.ccc27)
        LET g_ccc.ccc23c=(g_ccc.ccc12c+g_ccc.ccc22c+g_ccc.ccc28c)
                        /(g_ccc.ccc11+g_ccc.ccc21+g_ccc.ccc27)
        LET g_ccc.ccc23d=(g_ccc.ccc12d+g_ccc.ccc22d+g_ccc.ccc28d)
                        /(g_ccc.ccc11+g_ccc.ccc21+g_ccc.ccc27)
        LET g_ccc.ccc23e=(g_ccc.ccc12e+g_ccc.ccc22e+g_ccc.ccc28e)
                        /(g_ccc.ccc11+g_ccc.ccc21+g_ccc.ccc27)
        LET g_ccc.ccc23f=(g_ccc.ccc12f+g_ccc.ccc22f+g_ccc.ccc28f)
                        /(g_ccc.ccc11+g_ccc.ccc21+g_ccc.ccc27)
        LET g_ccc.ccc23g=(g_ccc.ccc12g+g_ccc.ccc22g+g_ccc.ccc28g)
                        /(g_ccc.ccc11+g_ccc.ccc21+g_ccc.ccc27)
        LET g_ccc.ccc23h=(g_ccc.ccc12h+g_ccc.ccc22h+g_ccc.ccc28h)
                        /(g_ccc.ccc11+g_ccc.ccc21+g_ccc.ccc27)
        LET g_ccc.ccc23=g_ccc.ccc23a+g_ccc.ccc23b+g_ccc.ccc23c
                       +g_ccc.ccc23d+g_ccc.ccc23e
                       +g_ccc.ccc23f+g_ccc.ccc23g+g_ccc.ccc23h   #FUN-7C0028 add
     END IF  # 99.01.05 Star 無論如何, 若沒單價則取xx帳或上期
     IF g_ccc.ccc23 = 0 THEN
        #-->先取期初xx帳再取上月
        SELECT cca23a,cca23b,cca23c,cca23d,cca23e,cca23f,cca23g,cca23h,cca23  #FUN-7C0028 add cca23f,g,h
          INTO g_ccc.ccc23a,g_ccc.ccc23b,g_ccc.ccc23c,
               g_ccc.ccc23d,g_ccc.ccc23e,
               g_ccc.ccc23f,g_ccc.ccc23g,g_ccc.ccc23h,   #FUN-7C0028 add
               g_ccc.ccc23
          FROM cca_file
         WHERE cca01=g_ccc.ccc01 AND cca02=last_yy AND cca03=last_mm
           AND cca06=type        AND cca07=g_tlfcost   #FUN-7C0028 add
        IF STATUS OR g_ccc.ccc23 IS NULL THEN
           SELECT ccc23a,ccc23b,ccc23c,ccc23d,ccc23e,ccc23f,ccc23g,ccc23h,ccc23   #FUN-7C0028 add ccc23f,g,h
             INTO g_ccc.ccc23a,g_ccc.ccc23b,g_ccc.ccc23c,
                  g_ccc.ccc23d,g_ccc.ccc23e,
                  g_ccc.ccc23f,g_ccc.ccc23g,g_ccc.ccc23h,   #FUN-7C0028 add
                  g_ccc.ccc23
             FROM ccc_file
            WHERE ccc01=g_ccc.ccc01 AND ccc02=last_yy AND ccc03=last_mm
              AND ccc07=type        AND ccc08=g_tlfcost   #FUN-7C0028 add
            IF STATUS OR g_ccc.ccc23 IS NULL THEN
               LET g_ccc.ccc23a=0 LET g_ccc.ccc23b=0 LET g_ccc.ccc23c=0
               LET g_ccc.ccc23d=0 LET g_ccc.ccc23e=0 LET g_ccc.ccc23=0
               LET g_ccc.ccc23f=0 LET g_ccc.ccc23g=0 LET g_ccc.ccc23h=0   #FUN-7C0028 add
           END IF
        END IF
     END IF
     IF g_ccc.ccc23 = 0 THEN
        LET g_ccc.ccc23a = l_c23a
        LET g_ccc.ccc23b = l_c23b
        LET g_ccc.ccc23c = l_c23c
        LET g_ccc.ccc23d = l_c23d
        LET g_ccc.ccc23e = l_c23e
        LET g_ccc.ccc23f = l_c23f   #FUN-7C0028 add
        LET g_ccc.ccc23g = l_c23g   #FUN-7C0028 add
        LET g_ccc.ccc23h = l_c23h   #FUN-7C0028 add
        LET g_ccc.ccc23  = l_c23
     END IF
  ELSE                          # 平均單位成本計算
     IF qty != 0 THEN      #MOD-990057 取消mark
        LET g_ccc.ccc23a=(g_ccc.ccc12a+g_ccc.ccc22a+g_ccc.ccc26a+g_ccc.ccc28a)/qty
        LET g_ccc.ccc23b=(g_ccc.ccc12b+g_ccc.ccc22b+g_ccc.ccc26b+g_ccc.ccc28b)/qty
        LET g_ccc.ccc23c=(g_ccc.ccc12c+g_ccc.ccc22c+g_ccc.ccc26c+g_ccc.ccc28c)/qty
        LET g_ccc.ccc23d=(g_ccc.ccc12d+g_ccc.ccc22d+g_ccc.ccc26d+g_ccc.ccc28d)/qty
        LET g_ccc.ccc23e=(g_ccc.ccc12e+g_ccc.ccc22e+g_ccc.ccc26e+g_ccc.ccc28e)/qty
        LET g_ccc.ccc23f=(g_ccc.ccc12f+g_ccc.ccc22f+g_ccc.ccc26f+g_ccc.ccc28f)/qty   #FUN-7C0028 add
        LET g_ccc.ccc23g=(g_ccc.ccc12g+g_ccc.ccc22g+g_ccc.ccc26g+g_ccc.ccc28g)/qty   #FUN-7C0028 add
        LET g_ccc.ccc23h=(g_ccc.ccc12h+g_ccc.ccc22h+g_ccc.ccc26h+g_ccc.ccc28h)/qty   #FUN-7C0028 add
        LET g_ccc.ccc23=g_ccc.ccc23a+g_ccc.ccc23b+g_ccc.ccc23c+
                        g_ccc.ccc23d+g_ccc.ccc23e
                       +g_ccc.ccc23f+g_ccc.ccc23g+g_ccc.ccc23h   #FUN-7C0028 add
     ELSE #雜入,拆件入,但被重工領出者
     END IF
  END IF
END FUNCTION
 
FUNCTION p500_tlf21_upd()                       #zzz
   DEFINE l_ima57                LIKE ima_file.ima57                #No.FUN-680122 SMALLINT
   DEFINE l_sfb38                LIKE type_file.dat                 #No.FUN-680122 DATE
   DEFINE l_sfb01                LIKE sfb_file.sfb01
   DEFINE l_tlf10                LIKE tlf_file.tlf10                #No.FUN-680122DEC(15,3)
   DEFINE l_c21,l_c22,l_c23                   LIKE oeb_file.oeb13   #No.FUN-680122 DEC(20,6)  #MOD-4C0005
   DEFINE l_c23a,l_c23b,l_c23c,l_c23d,l_c23e  LIKE oeb_file.oeb13   #No.FUN-680122 DEC(20,6)  #MOD-4C0005
   DEFINE l_c23f,l_c23g,l_c23h                LIKE oeb_file.oeb13   #FUN-7C0028 add
   DEFINE l_c22a,l_c22b,l_c22c,l_c22d,l_c22e  LIKE oeb_file.oeb13   #No.FUN-680122 DEC(20,6)  #MOD-4C0005
   DEFINE l_c22f,l_c22g,l_c22h                LIKE oeb_file.oeb13   #FUN-7C0028 add
   DEFINE l_oha09                LIKE oha_file.oha09
   DEFINE l_tlf62                LIKE tlf_file.tlf62
   DEFINE l_tlf907               LIKE tlf_file.tlf907
   DEFINE l_sfb02                LIKE sfb_file.sfb02      #No.7088.A.b
   DEFINE l_amt,l_amt1,l_amt2    LIKE tlf_file.tlf21      #No.A102
   DEFINE l_amt3,l_amt4,l_amt5   LIKE tlf_file.tlf21      #No.A102
   DEFINE l_amt6,l_amt7,l_amt8   LIKE tlf_file.tlf21      #FUN-7C0028 add
   DEFINE l_azf08                LIKE azf_file.azf08      #FUN-690068 add
   DEFINE l_sre11                LIKE sre_file.sre11      #FUN-7C0028 add
   DEFINE l_srm04                LIKE srm_file.srm04      #FUN-7C0028 add
   DEFINE l_amta,l_amtb,l_amtc   LIKE ccc_file.ccc22a     #MOD-840460 add
   DEFINE l_amtd,l_amte          LIKE ccc_file.ccc22a     #MOD-840460 add
   DEFINE l_amtf,l_amtg,l_amth   LIKE ccc_file.ccc22a     #MOD-840460 add
   DEFINE l_tlf28                LIKE tlf_file.tlf28      #CHI-980045
   DEFINE l_oga65                LIKE oga_file.oga65      #MOD-C20108 add
 
   LET g_sql ="SELECT tlf_file.rowid,tlf01,tlf06,tlf07,tlf10*tlf60,",
              "       tlf020,tlf02,tlf021,tlf022,tlf023,tlf026,tlf027,",
              "       tlf030,tlf03,tlf031,tlf032,tlf033,tlf036,tlf037,",
              "       tlf13,tlf62,tlf60,tlf08,tlf905,tlf906,tlf21,",
              "       tlf221,tlf222,tlf2231,tlf2232,tlf224,",
              "       tlf2241,tlf2242,tlf2243,tlfcost,tlf28,",  #CHI-980045 add tlf28
              "       sfb38,sfb99,ima57,sfb01,tlf907,sfb02 ",
              "  FROM tlf_file LEFT OUTER JOIN ",
              "   (select sfb38,sfb99,ima57,sfb01,sfb02  ",
              "      from sfb_file,ima_file ",
              "     where sfb05 = ima01 ) tmp ON tlf62 = tmp.sfb01",
              " WHERE tlf01 = '",g_ima01,"' ",
              "   AND ((tlf02 BETWEEN 50 AND 59) OR (tlf03 BETWEEN 50 AND 59))",
              "   AND tlf06 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
              #"   AND tlf902 NOT IN(SELECT jce02 FROM jce_file) ",  #CHI-C80002
              "   AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = tlf902) ",  #CHI-C80002  #MOD-CA0185 mod
              "   AND tlf907 != 0 ",
              "   AND tlfcost = '",g_tlfcost,"'"
   IF g_sma.sma43 = '1' THEN
      LET g_sql = g_sql CLIPPED," ORDER BY tlf01,tlf06,tlf08 "
   END IF
   PREPARE tlf21_pre FROM g_sql
   IF STATUS THEN
      CALL cl_err('tlf21_pre',STATUS,1) LET g_success = 'N' RETURN
   END IF
   DECLARE tlf21_c CURSOR WITH HOLD FOR tlf21_pre
   FOREACH tlf21_c INTO q_tlf_rowid, q_tlf.*, l_tlf28, l_sfb38, g_sfb99, l_ima57,l_sfb01,  #CHI-980045 add tlf28
                        l_tlf907,l_sfb02             # No.7088.A.b
      IF STATUS THEN
         CALL cl_err('fore tlf!',STATUS,1) LET g_success = 'N' EXIT FOREACH
      END IF
      IF cl_null(q_tlf.tlf02) AND cl_null(q_tlf.tlf03) THEN
         CONTINUE FOREACH
      END IF
      IF q_tlf.tlf13 = 'aimt302' OR q_tlf.tlf13 = 'aimt312' THEN                                                                    
         CALL p500_ins_tlfc(q_tlf_rowid)           #No.FUN-AA0025
         CONTINUE FOREACH                                                                                                           
      END IF             
      #CHI-980045(S)
      IF (g_ccz.ccz31 MATCHES '[23]') AND (l_tlf28 = 'S') THEN
         CONTINUE FOREACH
      END IF
      #CHI-980045(E)
      LET g_sfb02 = l_sfb02 #MOD-DA0096 add
      #--------------------------------------------------------->出庫
      IF (q_tlf.tlf02 = 50 OR q_tlf.tlf02 = 57)  THEN
        CALL s_get_doc_no(q_tlf.tlf026) RETURNING xxx
        LET xxx1=q_tlf.tlf026 LET xxx2=q_tlf.tlf027
        LET u_sign=-1
      END IF
      #--------------------------------------------------------->入庫
      IF (q_tlf.tlf03 = 50 OR q_tlf.tlf03 = 57)  THEN
        CALL s_get_doc_no(q_tlf.tlf036) RETURNING xxx
        LET xxx1=q_tlf.tlf036 LET xxx2=q_tlf.tlf037
        LET u_sign=1
      END IF
      #--------------------------------------------------------->二階段調撥(出)
       IF (q_tlf.tlf02 = 50 AND q_tlf.tlf03 = 57)  THEN
        CALL s_get_doc_no(q_tlf.tlf026) RETURNING xxx
          LET xxx1=q_tlf.tlf026 LET xxx2=q_tlf.tlf027
          LET u_sign=-1
       END IF
      #--------------------------------------------------------->二階段調撥(出)
       IF (q_tlf.tlf03 = 50 AND q_tlf.tlf02 = 57)  THEN
        CALL s_get_doc_no(q_tlf.tlf036) RETURNING xxx
          LET xxx1=q_tlf.tlf036 LET xxx2=q_tlf.tlf037
          LET u_sign=1
       END IF
      #--------------------------------------------------------->取成會分類
      IF xxx IS NULL THEN CONTINUE FOREACH END IF
      LET u_flag='' LET g_smydmy1=''
      SELECT smydmy2,smydmy1 INTO u_flag,g_smydmy1
        FROM smy_file WHERE smyslip=xxx
      #140422 add begin----------------
      IF q_tlf.tlf02 = 50 AND q_tlf.tlf03 =18 THEN 
         LET g_smydmy1 = 'Y'
         LET u_flag = 3
      END IF 
      #140422 add end------------------     
      IF g_smydmy1='N' OR g_smydmy1 IS NULL THEN CONTINUE FOREACH END IF  #No:8327
     #IF q_tlf.tlf13='aimp880' THEN LET u_flag='6' END IF  #TQC-B30129
      IF (q_tlf.tlf13='aimp880' OR q_tlf.tlf13='artt215') THEN LET u_flag='6' END IF  #TQC-B30129
      IF u_flag NOT MATCHES "[123456]" OR u_flag IS NULL THEN
         CONTINUE FOREACH
      END IF
 
## 98.12.28 Star 銷退單若處理方式為 2.不折讓, 要換貨再出貨 則不扣除當月銷貨成本
## 991209 Star 此為GVC 做法...
##----------------------------------------------------------------------------
      IF q_tlf.tlf13[1,5]='asfi5' AND g_sfb99='Y' AND l_ima57<g_ima57_t THEN
         LET g_sfb99='N'
      END IF
      # 當 sfb99 is null, 就表示非W/O類, 不必特別判斷
      LET amt =0 LET amta=0 LET amtb=0 LET amtc=0 LET amtd=0 LET amte=0
      LET amtf=0 LET amtg=0 LET amth=0    #FUN-7C0028 add
 
 
       #重新抓取ima905
       SELECT ima905 INTO g_ima905 FROM ima_file WHERE ima01=g_ima01   #CHI-7B0022 add
       IF cl_null(g_ima905) THEN LET g_ima905 ='N' END IF              #CHI-7B0022 add
 
       CASE WHEN q_tlf.tlf13='aimt301' OR q_tlf.tlf13='aimt311' #雜出
#報廢異動(aimt303,aimt313)應列入雜發異動中
              OR q_tlf.tlf13 = 'aimt303' OR q_tlf.tlf13 = 'aimt313'
              CALL p500_ins_tlfc(q_tlf_rowid)           #No.FUN-AA0025 
#雜發依參數ccz08決定取價方式
              IF g_ccz.ccz08 = '1' THEN       #1.系統認定 2.人工認定(axct500)
                 IF g_sma.sma43 = '1' THEN
                    CALL p500_upd_cxa09(q_tlf.tlf01,q_tlf.tlf10,1)
                    RETURNING l_amt,l_amt1,l_amt2,l_amt3,l_amt4,l_amt5
                                   ,l_amt6,l_amt7,l_amt8   #FUN-7C0028 add
                    LET amta=amta + l_amt1
                    LET amtb=amtb + l_amt2
                    LET amtc=amtc + l_amt3
                    LET amtd=amtd + l_amt4
                    LET amte=amte + l_amt5
                    LET amtf=amtf + l_amt6   #FUN-7C0028 add
                    LET amtg=amtg + l_amt7   #FUN-7C0028 add
                    LET amth=amth + l_amt8   #FUN-7C0028 add
                 ELSE
                    LET amta=amta + (q_tlf.tlf10*g_ccc.ccc23a)
                    LET amtb=amtb + (q_tlf.tlf10*g_ccc.ccc23b)
                    LET amtc=amtc + (q_tlf.tlf10*g_ccc.ccc23c)
                    LET amtd=amtd + (q_tlf.tlf10*g_ccc.ccc23d)
                    LET amte=amte + (q_tlf.tlf10*g_ccc.ccc23e)
                    LET amtf=amtf + (q_tlf.tlf10*g_ccc.ccc23f)   #FUN-7C0028 add
                    LET amtg=amtg + (q_tlf.tlf10*g_ccc.ccc23g)   #FUN-7C0028 add
                    LET amth=amth + (q_tlf.tlf10*g_ccc.ccc23h)   #FUN-7C0028 add
                 END IF
                 LET amt=amta+amtb+amtc+amtd+amte+amtf+amtg+amth   #FUN-7C0028 add amtf,g,h
                #在將金額加到ccc之前,需先做取位
                 CALL cl_digcut(amt*l_tlf907,g_ccz.ccz26) RETURNING l_amt
                 LET g_ccc.ccc42 = g_ccc.ccc42 + l_amt
              ELSE
          #FUN-AB0089--mark
          #      SELECT inb14 INTO amta FROM inb_file
          #       WHERE inb01 = xxx1
          #         AND inb03 = xxx2
          #      IF cl_null(amta) THEN LET amta = 0 END IF
          #      LET amt=amta+amtb+amtc+amtd+amte+amtf+amtg+amth   #FUN-7C0028 add amtf,g,h
          #FUN-AB0089--mark
          #FUN-AB0089--add--begin
                 SELECT inb13 *inb09,inb132*inb09,inb133*inb09,inb134*inb09,
                        inb135*inb09,inb136*inb09,inb137*inb09,inb138*inb09
                 INTO amta,amtb,amtc,amtd,amte,amtf,amtg,amth 
                 FROM inb_file
                 WHERE inb01 = xxx1
                    AND inb03 = xxx2
                 LET amta = cl_digcut(amta,g_ccz.ccz26)
                 LET amtb = cl_digcut(amtb,g_ccz.ccz26)
                 LET amtc = cl_digcut(amtc,g_ccz.ccz26)
                 LET amtd = cl_digcut(amtd,g_ccz.ccz26)
                 LET amte = cl_digcut(amte,g_ccz.ccz26)
                 LET amtf = cl_digcut(amtf,g_ccz.ccz26)
                 LET amtg = cl_digcut(amtg,g_ccz.ccz26)
                 LET amth = cl_digcut(amth,g_ccz.ccz26)
                 LET amt=amta+amtb+amtc+amtd+amte+amtf+amtg+amth  
          #FUN-AB0089--add--end
                #在將金額加到ccc之前,需先做取位
                 CALL cl_digcut(amt*l_tlf907,g_ccz.ccz26) RETURNING l_amt
                 LET g_ccc.ccc42 = g_ccc.ccc42 + l_amt
                #CONTINUE FOREACH         #MOD-C70002 mark
              END IF
           #FUN-B90029(S)
           WHEN q_tlf.tlf13='asft700'
                 #FUN-B90029 --START mark--
                 #SELECT shd07*shd08 INTO amta FROM shd_file
                 # WHERE shd01 = xxx1
                 #   AND shd02 = xxx2
                 #IF cl_null(amta) THEN LET amta = 0 END IF
                 #FUN-B90029 --END mark--
                 #FUN-B90029 --START--
                 SELECT shd07*shd08,shd07*shd082,shd07*shd083,
                        shd07*shd084,shd07*shd085,shd07*shd086,
                        shd07*shd087,shd07*shd088
                  INTO amta,amtb,amtc,amtd,amte,amtf,amtg,amth
                   FROM shd_file
                  WHERE shd01 = xxx1
                    AND shd02 = xxx2
                 IF cl_null(amta) THEN LET amta = 0 END IF
                 IF cl_null(amtb) THEN LET amtb = 0 END IF
                 IF cl_null(amtc) THEN LET amtc = 0 END IF
                 IF cl_null(amtd) THEN LET amtd = 0 END IF
                 IF cl_null(amte) THEN LET amte = 0 END IF
                 IF cl_null(amtf) THEN LET amtf = 0 END IF
                 IF cl_null(amtg) THEN LET amtg = 0 END IF
                 IF cl_null(amth) THEN LET amth = 0 END IF
                 #FUN-B90029 --END--
                 LET amt=amta+amtb+amtc+amtd+amte+amtf+amtg+amth
                #在將金額加到ccc之前,需先做取位
                 CALL cl_digcut(amt*l_tlf907,g_ccz.ccz26) RETURNING l_amt
                 LET g_ccc.ccc32 = g_ccc.ccc32 + l_amt
           #FUN-B90029(E)   
           #增加"廠對廠直接調撥"(aimt720),撥出部份(tlf02=50,tlf03=57),
           #    "兩階段營運中心間調撥"(aimp700)撥出部份
           #寫入雜發
            WHEN (q_tlf.tlf13 = 'aimt720' AND q_tlf.tlf02=50 AND q_tlf.tlf03=57)
              OR  q_tlf.tlf13 = 'aimp700'
                 LET amta=amta + (q_tlf.tlf10*g_ccc.ccc23a)
                 LET amtb=amtb + (q_tlf.tlf10*g_ccc.ccc23b)
                 LET amtc=amtc + (q_tlf.tlf10*g_ccc.ccc23c)
                 LET amtd=amtd + (q_tlf.tlf10*g_ccc.ccc23d)
                 LET amte=amte + (q_tlf.tlf10*g_ccc.ccc23e)
                 LET amtf=amtf + (q_tlf.tlf10*g_ccc.ccc23f)   #FUN-7C0028 add
                 LET amtg=amtg + (q_tlf.tlf10*g_ccc.ccc23g)   #FUN-7C0028 add
                 LET amth=amth + (q_tlf.tlf10*g_ccc.ccc23h)   #FUN-7C0028 add
                 LET amt=amta+amtb+amtc+amtd+amte+amtf+amtg+amth   #FUN-7C0028 add amtf,g,h
                #在將金額加到ccc之前,需先做取位
                 CALL cl_digcut(amt*l_tlf907,g_ccz.ccz26) RETURNING l_amt
                 LET g_ccc.ccc42 = g_ccc.ccc42 + l_amt
 
            #no.6723原本拆件式的程式段放在最下面會Run 不到這段，
            #       所以放在所有tlf13[1,5]='asft6'的前面
            WHEN q_tlf.tlf13[1,5]='asft6' AND             #拆件重工入庫
                 (q_tlf.tlf02 = 65 OR q_tlf.tlf03 = 65)
                 IF l_ima57<=g_ima57_t THEN               # 子階領父階
                    IF g_sma.sma43 = '1' THEN
                       CALL p500_get_tlf21(q_tlf.tlf01,q_tlf.tlf10,'4',1)
                       RETURNING l_amt,l_amt1,l_amt2,l_amt3,l_amt4,l_amt5
                                      ,l_amt6,l_amt7,l_amt8   #FUN-7C0028 add
                       LET amta=amta + l_amt1
                       LET amtb=amtb + l_amt2
                       LET amtc=amtc + l_amt3
                       LET amtd=amtd + l_amt4
                       LET amte=amte + l_amt5
                       LET amtf=amtf + l_amt6   #FUN-7C0028 add
                       LET amtg=amtg + l_amt7   #FUN-7C0028 add
                       LET amth=amth + l_amt8   #FUN-7C0028 add
                    ELSE
                       LET amta=amta + (q_tlf.tlf10*g_ccc.ccc23a)
                       LET amtb=amtb + (q_tlf.tlf10*g_ccc.ccc23b)
                       LET amtc=amtc + (q_tlf.tlf10*g_ccc.ccc23c)
                       LET amtd=amtd + (q_tlf.tlf10*g_ccc.ccc23d)
                       LET amte=amte + (q_tlf.tlf10*g_ccc.ccc23e)
                       LET amtf=amtf + (q_tlf.tlf10*g_ccc.ccc23f)   #FUN-7C0028 add
                       LET amtg=amtg + (q_tlf.tlf10*g_ccc.ccc23g)   #FUN-7C0028 add
                       LET amth=amth + (q_tlf.tlf10*g_ccc.ccc23h)   #FUN-7C0028 add
                    END IF
                    #end
                 ELSE
#應取其單價,因為ccu32可能是兩筆以上彙總而得
                     SELECT -ccu32a/ccu31,-ccu32b/ccu31,-ccu32c/ccu31,
                            -ccu32d/ccu31,-ccu32e/ccu31
                           ,-ccu32f/ccu31,-ccu32g/ccu31,-ccu32h/ccu31   #FUN-7C0028 add
                       INTO l_c23a,l_c23b,l_c23c,l_c23d,l_c23e,l_c23f,l_c23g,l_c23h   #FUN-7C0028 add l_c23f,g,h
                       FROM ccu_file
                       WHERE ccu01=q_tlf.tlf62
                         AND ccu02=yy AND ccu03=mm
                         AND ccu04=q_tlf.tlf01
                         AND ccu06=type        #FUN-7C0028 add
                         ANd ccu07=g_tlfcost   #FIM-7C0028 add
                    LET amta=amta - (l_c23a*q_tlf.tlf10)
                    LET amtb=amtb - (l_c23b*q_tlf.tlf10)
                    LET amtc=amtc - (l_c23c*q_tlf.tlf10)
                    LET amtd=amtd - (l_c23d*q_tlf.tlf10)
                    LET amte=amte - (l_c23e*q_tlf.tlf10)
                    LET amtf=amtf - (l_c23f*q_tlf.tlf10)   #FUN-7C0028 add
                    LET amtg=amtg - (l_c23g*q_tlf.tlf10)   #FUN-7C0028 add
                    LET amth=amth - (l_c23h*q_tlf.tlf10)   #FUN-7C0028 add
                 END IF
                 LET amt=amta+amtb+amtc+amtd+amte+amtf+amtg+amth   #FUN-7C0028 add amtf,g,h
            WHEN q_tlf.tlf13[1,5]='asft6' AND g_sfb99='N' # 製造入庫
            #要存明細的入庫金額
            IF NOT cl_null(q_tlf.tlf62) THEN
               LET l_c23 = 0  LET l_c22 = 0 LET l_c21 = 0
               LET l_c22a= 0  LET l_c22b= 0 LET l_c22c= 0 
               LET l_c22d= 0  LET l_c22e= 0
               LET l_c22f= 0  LET l_c22g= 0 LET l_c22h= 0    #FUN-7C0028 add
               #IF NOT (l_sfb02<>7 AND l_sfb02<>8 AND g_ima905 = 'Y'  ) THEN #No:8179  #MOD-750124 modify   #MOD-B90018 mark
               IF NOT (g_ima905 = 'Y') THEN     #MOD-B90018 add                 
               SELECT ccg31,ccg32,ccg32a,ccg32b,ccg32c,ccg32d,ccg32e
                                   ,ccg32f,ccg32g,ccg32h   #FUN-7C0028 add
                   INTO l_c21,l_c22,l_c22a,l_c22b,l_c22c,l_c22d,l_c22e
                                   ,l_c22f,l_c22g,l_c22h   #FUN-7C0028 add
                   FROM ccg_file
                  WHERE ccg01=q_tlf.tlf62 AND ccg04=q_tlf.tlf01
                    AND ccg02=yy   AND ccg03=mm
                    AND ccg06=type
                    AND ccg07=g_tlfcost   #MOD-C60140 add
               ELSE
                 SELECT cce21,cce22,cce22a,cce22b,cce22c,cce22d,cce22e
                                   ,cce22f,cce22g,cce22h   #FUN-7C0028 add
                   INTO l_c21,l_c22,l_c22a,l_c22b,l_c22c,l_c22d,l_c22e
                                   ,l_c22f,l_c22g,l_c22h   #FUN-7C0028 add
                   FROM cce_file
                  WHERE cce01=q_tlf.tlf62 AND cce04=q_tlf.tlf01
                    AND cce02=yy   AND cce03=mm
                    AND cce06=type AND cce07=g_tlfcost   #FUN-7C0028 add
               END IF
               IF l_c21 IS NULL THEN LET l_c21 = 0 END IF
               IF l_c22 IS NULL THEN LET l_c22 = 0 END IF
               IF l_c22a IS NULL THEN LET l_c22a = 0 END IF
               IF l_c22b IS NULL THEN LET l_c22b = 0 END IF
               IF l_c22c IS NULL THEN LET l_c22c = 0 END IF
               IF l_c22d IS NULL THEN LET l_c22d = 0 END IF
               IF l_c22e IS NULL THEN LET l_c22e = 0 END IF
               IF l_c22f IS NULL THEN LET l_c22f = 0 END IF   #FUN-7C0028 add
               IF l_c22g IS NULL THEN LET l_c22g = 0 END IF   #FUN-7C0028 add
               IF l_c22h IS NULL THEN LET l_c22h = 0 END IF   #FUN-7C0028 add
               IF l_c21 != 0 THEN
                  LET l_c23 = l_c22 / l_c21
                  LET l_c23a= l_c22a/ l_c21
                  LET l_c23b= l_c22b/ l_c21
                  LET l_c23c= l_c22c/ l_c21
                  LET l_c23d= l_c22d/ l_c21
                  LET l_c23e= l_c22e/ l_c21
                  LET l_c23f= l_c22f/ l_c21   #FUN-7C0028 add
                  LET l_c23g= l_c22g/ l_c21   #FUN-7C0028 add
                  LET l_c23h= l_c22h/ l_c21   #FUN-7C0028 add
               ELSE
                  LET l_c23 = 0
                  LET l_c23a= 0
                  LET l_c23b= 0
                  LET l_c23c= 0
                  LET l_c23d= 0
                  LET l_c23e= 0
                  LET l_c23f= 0   #FUN-7C0028 add
                  LET l_c23g= 0   #FUN-7C0028 add
                  LET l_c23h= 0   #FUN-7C0028 add
               END IF
               IF l_c21 != 0 THEN
                  LET amta=amta + (q_tlf.tlf10*l_c22a/ l_c21)
                  LET amtb=amtb + (q_tlf.tlf10*l_c22b/ l_c21)
                  LET amtc=amtc + (q_tlf.tlf10*l_c22c/ l_c21)
                  LET amtd=amtd + (q_tlf.tlf10*l_c22d/ l_c21)
                  LET amte=amte + (q_tlf.tlf10*l_c22e/ l_c21)
                  LET amtf=amtf + (q_tlf.tlf10*l_c22f/ l_c21)   #FUN-7C0028 add
                  LET amtg=amtg + (q_tlf.tlf10*l_c22g/ l_c21)   #FUN-7C0028 add
                  LET amth=amth + (q_tlf.tlf10*l_c22h/ l_c21)   #FUN-7C0028 add
               ELSE
                  LET amta=amta + (q_tlf.tlf10*l_c23a)
                  LET amtb=amtb + (q_tlf.tlf10*l_c23b)
                  LET amtc=amtc + (q_tlf.tlf10*l_c23c)
                  LET amtd=amtd + (q_tlf.tlf10*l_c23d)
                  LET amte=amte + (q_tlf.tlf10*l_c23e)
                  LET amtf=amtf + (q_tlf.tlf10*l_c23f)   #FUN-7C0028 add
                  LET amtg=amtg + (q_tlf.tlf10*l_c23g)   #FUN-7C0028 add
                  LET amth=amth + (q_tlf.tlf10*l_c23h)   #FUN-7C0028 add
               END IF
               LET amt=amta+amtb+amtc+amtd+amte+amtf+amtg+amth   #FUN-7C0028 add amtf,g,h
            END IF
         WHEN q_tlf.tlf13[1,5]='asfi5' AND g_sfb99='Y'       # 重工入庫
              AND l_ima57>g_ima57_t                          # 子階領父階
              IF NOT cl_null(q_tlf.tlf62) THEN
                 LET l_c23 = 0  LET l_c22 = 0 LET l_c21 = 0
                 LET l_c22a= 0  LET l_c22b= 0 LET l_c22c= 0
                 LET l_c22d= 0  LET l_c22e= 0
                 LET l_c22f= 0  LET l_c22g= 0 LET l_c22h= 0   #FUN-7C0028 add
                 SELECT cch21,cch22,cch22a,cch22b,cch22c,cch22d,cch22e
                                   ,cch22f,cch22g,cch22h   #FUN-7C0028 add
                      INTO l_c21,l_c22,l_c22a,l_c22b,l_c22c,l_c22d,l_c22e
                                      ,l_c22f,l_c22g,l_c22h   #FUN-7C0028 add
                      FROM cch_file
                     WHERE cch01 = q_tlf.tlf62 AND cch04 = q_tlf.tlf01
                       AND cch02 = yy   AND cch03 = mm
                       AND cch06 = type AND cch07 = g_tlfcost   #FUN-7C0028 add
                    IF l_c21 IS NULL THEN LET l_c21 = 0 END IF
                    IF l_c22 IS NULL THEN LET l_c22 = 0 END IF
                    IF l_c22a IS NULL THEN LET l_c22a = 0 END IF
                    IF l_c22b IS NULL THEN LET l_c22b = 0 END IF
                    IF l_c22c IS NULL THEN LET l_c22c = 0 END IF
                    IF l_c22d IS NULL THEN LET l_c22d = 0 END IF
                    IF l_c22e IS NULL THEN LET l_c22e = 0 END IF
                    IF l_c22f IS NULL THEN LET l_c22f = 0 END IF   #FUN-7C0028 add
                    IF l_c22g IS NULL THEN LET l_c22g = 0 END IF   #FUN-7C0028 add
                    IF l_c22h IS NULL THEN LET l_c22h = 0 END IF   #FUN-7C0028 add
                    IF l_c21 != 0 THEN
                       LET l_c23 = l_c22 / l_c21
                       LET l_c23a= l_c22a/ l_c21
                       LET l_c23b= l_c22b/ l_c21
                       LET l_c23c= l_c22c/ l_c21
                       LET l_c23d= l_c22d/ l_c21
                       LET l_c23e= l_c22e/ l_c21
                       LET l_c23f= l_c22f/ l_c21   #FUN-7C0028 add
                       LET l_c23g= l_c22g/ l_c21   #FUN-7C0028 add
                       LET l_c23h= l_c22h/ l_c21   #FUN-7C0028 add
                    ELSE
                       LET l_c23 = 0
                       LET l_c23a= 0
                       LET l_c23b= 0
                       LET l_c23c= 0
                       LET l_c23d= 0
                       LET l_c23e= 0
                       LET l_c23f= 0   #FUN-7C0028 add
                       LET l_c23g= 0   #FUN-7C0028 add
                       LET l_c23h= 0   #FUN-7C0028 add
                    END IF
                    IF l_c21 != 0 THEN
                       LET amta=amta + (q_tlf.tlf10*l_c22a/ l_c21)
                       LET amtb=amtb + (q_tlf.tlf10*l_c22b/ l_c21)
                       LET amtc=amtc + (q_tlf.tlf10*l_c22c/ l_c21)
                       LET amtd=amtd + (q_tlf.tlf10*l_c22d/ l_c21)
                       LET amte=amte + (q_tlf.tlf10*l_c22e/ l_c21)
                       LET amtf=amtf + (q_tlf.tlf10*l_c22f/ l_c21)   #FUN-7C0028 add
                       LET amtg=amtg + (q_tlf.tlf10*l_c22g/ l_c21)   #FUN-7C0028 add
                       LET amth=amth + (q_tlf.tlf10*l_c22h/ l_c21)   #FUN-7C0028 add
                    ELSE
                       LET amta=amta + (q_tlf.tlf10*l_c23a)
                       LET amtb=amtb + (q_tlf.tlf10*l_c23b)
                       LET amtc=amtc + (q_tlf.tlf10*l_c23c)
                       LET amtd=amtd + (q_tlf.tlf10*l_c23d)
                       LET amte=amte + (q_tlf.tlf10*l_c23e)
                       LET amtf=amtf + (q_tlf.tlf10*l_c23f)   #FUN-7C0028 add
                       LET amtg=amtg + (q_tlf.tlf10*l_c23g)   #FUN-7C0028 add
                       LET amth=amth + (q_tlf.tlf10*l_c23h)   #FUN-7C0028 add
                    END IF
                    LET amt=amta+amtb+amtc+amtd+amte+amtf+amtg+amth   #FUN-7C0028 add amtf,g,h
                 END IF
         WHEN q_tlf.tlf13[1,5]='asft6' AND g_sfb99='Y'       # 重工入庫
              AND NOT (q_tlf.tlf02 = 65 OR q_tlf.tlf03 = 65) # 非拆件工單
                 IF NOT cl_null(q_tlf.tlf62) THEN
                    LET l_c23 = 0  LET l_c22 = 0 LET l_c21 = 0
                    LET l_c22a= 0  LET l_c22b= 0 LET l_c22c= 0
                    LET l_c22d= 0  LET l_c22e= 0
                    LET l_c22f= 0  LET l_c22g= 0 LET l_c22h=0   #FUN-7C0028 add
                    #IF NOT (l_sfb02<>7 AND l_sfb02<>8 AND g_ima905='Y')     THEN #No:8179  #MOD-750124 modify   #MOD-B90018 mark
                    IF NOT (g_ima905 = 'Y') THEN     #MOD-B90018 add
                    SELECT ccg31,ccg32,ccg32a,ccg32b,ccg32c,ccg32d,ccg32e
                                        ,ccg32f,ccg32g,ccg32h   #FUN-7C0028 add
                        INTO l_c21,l_c22,l_c22a,l_c22b,l_c22c,l_c22d,l_c22e
                                        ,l_c22f,l_c22g,l_c22h   #FUN-7C0028 add
                        FROM ccg_file
                       WHERE ccg01=q_tlf.tlf62 AND ccg04=q_tlf.tlf01
                         AND ccg02=yy   AND ccg03=mm
                         AND ccg06=type
                         AND ccg07=g_tlfcost   #MOD-C60140 add
                    ELSE
                      SELECT cce21,cce22,cce22a,cce22b,cce22c,cce22d,cce22e
                                        ,cce22f,cce22g,cce22h   #FUN-7C0028 add
                        INTO l_c21,l_c22,l_c22a,l_c22b,l_c22c,l_c22d,l_c22e
                                        ,l_c22f,l_c22g,l_c22h   #FUN-7C0028 add
                        FROM cce_file
                       WHERE cce01=q_tlf.tlf62 AND cce04=q_tlf.tlf01
                         AND cce02=yy   AND cce03=mm
                         AND cce06=type AND cce07=g_tlfcost   #FUN-7C0028 add
                    END IF
                    IF l_c21 IS NULL THEN LET l_c21 = 0 END IF
                    IF l_c22 IS NULL THEN LET l_c22 = 0 END IF
                    IF l_c22a IS NULL THEN LET l_c22a = 0 END IF
                    IF l_c22b IS NULL THEN LET l_c22b = 0 END IF
                    IF l_c22c IS NULL THEN LET l_c22c = 0 END IF
                    IF l_c22d IS NULL THEN LET l_c22d = 0 END IF
                    IF l_c22e IS NULL THEN LET l_c22e = 0 END IF
                    IF l_c22f IS NULL THEN LET l_c22f = 0 END IF   #FUN-7C0028 add
                    IF l_c22g IS NULL THEN LET l_c22g = 0 END IF   #FUN-7C0028 add
                    IF l_c22h IS NULL THEN LET l_c22h = 0 END IF   #FUN-7C0028 add
                    IF l_c21 != 0 THEN
                       LET l_c23 = l_c22 / l_c21
                       LET l_c23a= l_c22a/ l_c21
                       LET l_c23b= l_c22b/ l_c21
                       LET l_c23c= l_c22c/ l_c21
                       LET l_c23d= l_c22d/ l_c21
                       LET l_c23e= l_c22e/ l_c21
                       LET l_c23f= l_c22f/ l_c21   #FUN-7C0028 add
                       LET l_c23g= l_c22g/ l_c21   #FUN-7C0028 add
                       LET l_c23h= l_c22h/ l_c21   #FUN-7C0028 add
                    ELSE
                       LET l_c23 = 0
                       LET l_c23a= 0
                       LET l_c23b= 0
                       LET l_c23c= 0
                       LET l_c23d= 0
                       LET l_c23e= 0
                       LET l_c23f= 0   #FUN-7C0028 add
                       LET l_c23g= 0   #FUN-7C0028 add
                       LET l_c23h= 0   #FUN-7C0028 add
                    END IF
                    IF l_c21 != 0 THEN
                       LET amta=amta + (q_tlf.tlf10*l_c22a/ l_c21)
                       LET amtb=amtb + (q_tlf.tlf10*l_c22b/ l_c21)
                       LET amtc=amtc + (q_tlf.tlf10*l_c22c/ l_c21)
                       LET amtd=amtd + (q_tlf.tlf10*l_c22d/ l_c21)
                       LET amte=amte + (q_tlf.tlf10*l_c22e/ l_c21)
                       LET amtf=amtf + (q_tlf.tlf10*l_c22f/ l_c21)   #FUN-7C0028 add   #MOD-840314 mod
                       LET amtg=amtg + (q_tlf.tlf10*l_c22g/ l_c21)   #FUN-7C0028 add   #MOD-840314 mod
                       LET amth=amth + (q_tlf.tlf10*l_c22h/ l_c21)   #FUN-7C0028 add   #MOD-840314 mod
                    ELSE
                       LET amta=amta + (q_tlf.tlf10*l_c23a)
                       LET amtb=amtb + (q_tlf.tlf10*l_c23b)
                       LET amtc=amtc + (q_tlf.tlf10*l_c23c)
                       LET amtd=amtd + (q_tlf.tlf10*l_c23d)
                       LET amte=amte + (q_tlf.tlf10*l_c23e)
                       LET amtf=amtf + (q_tlf.tlf10*l_c23f)   #FUN-7C0028 add
                       LET amtg=amtg + (q_tlf.tlf10*l_c23g)   #FUN-7C0028 add
                       LET amth=amth + (q_tlf.tlf10*l_c23h)   #FUN-7C0028 add
                    END IF
                    LET amt=amta+amtb+amtc+amtd+amte+amtf+amtg+amth   #FUN-7C0028 add amtf,g,h
                 END IF
            WHEN q_tlf.tlf13[1,5]='asfi5' AND g_sfb99='Y' # 重工領出
                 IF g_sma.sma43 = '1' THEN
                    IF u_sign = 1 THEN     #退料
                       CALL p500_get_tlf21(q_tlf.tlf01,q_tlf.tlf10,'1',1)
                       RETURNING l_amt,l_amt1,l_amt2,l_amt3,l_amt4,l_amt5
                                      ,l_amt6,l_amt7,l_amt8   #FUN-7C0028 add 
                    ELSE                   #領料
                       CALL p500_upd_cxa09(q_tlf.tlf01,q_tlf.tlf10,1)
                       RETURNING l_amt,l_amt1,l_amt2,l_amt3,l_amt4,l_amt5
                                      ,l_amt6,l_amt7,l_amt8   #FUN-7C0028 add
                    END IF
                    LET amta=amta + l_amt1
                    LET amtb=amtb + l_amt2
                    LET amtc=amtc + l_amt3
                    LET amtd=amtd + l_amt4
                    LET amte=amte + l_amt5
                    LET amtf=amtf + l_amt6   #FUN-7C0028 add
                    LET amtg=amtg + l_amt7   #FUN-7C0028 add
                    LET amth=amth + l_amt8   #FUN-7C0028 add
                 ELSE
                    SELECT ccc12a+ccc22a, ccc12b+ccc22b, ccc12c+ccc22c,
                           ccc12d+ccc22d, ccc12e+ccc22e, 
                           ccc12f+ccc22f, ccc12g+ccc22g, ccc12h+ccc22h,   #FUN-7C0028 add
                           ccc12 +ccc22 , ccc11 +ccc21
                      INTO l_c22a,l_c22b,l_c22c,l_c22d,l_c22e,l_c22f,l_c22g,l_c22h,   #FUN-7C0028 add l_c22f,g,h
                           l_c22,l_c21
                      FROM ccc_file
                     WHERE ccc01=q_tlf.tlf01 AND ccc02=yy AND ccc03=mm
                       AND ccc07=type        AND ccc08=g_tlfcost   #FUN-7C0028 add
                    IF g_ccc.ccc11 + g_ccc.ccc21 = 0
                       THEN LET l_c23a=0 LET l_c23b=0 LET l_c23c=0
                            LET l_c23d=0 LET l_c23e=0 LET l_c23 =0
                            LET l_c23f=0 LET l_c23g=0 LET l_c23h=0   #FUN-7C0028 add
                       ELSE
                       LET l_c23 =(g_ccc.ccc12 +g_ccc.ccc22 )/
                                  (g_ccc.ccc11+g_ccc.ccc21)
                       LET l_c23a=(g_ccc.ccc12a+g_ccc.ccc22a)/
                                  (g_ccc.ccc11+g_ccc.ccc21)
                       LET l_c23b=(g_ccc.ccc12b+g_ccc.ccc22b)/
                                  (g_ccc.ccc11+g_ccc.ccc21)
                       LET l_c23c=(g_ccc.ccc12c+g_ccc.ccc22c)/
                                  (g_ccc.ccc11+g_ccc.ccc21)
                       LET l_c23d=(g_ccc.ccc12d+g_ccc.ccc22d)/
                                  (g_ccc.ccc11+g_ccc.ccc21)
                       LET l_c23e=(g_ccc.ccc12e+g_ccc.ccc22e)/
                                  (g_ccc.ccc11+g_ccc.ccc21)
                       LET l_c23f=(g_ccc.ccc12f+g_ccc.ccc22f)/
                                  (g_ccc.ccc11+g_ccc.ccc21)
                       LET l_c23g=(g_ccc.ccc12g+g_ccc.ccc22g)/
                                  (g_ccc.ccc11+g_ccc.ccc21)
                       LET l_c23h=(g_ccc.ccc12h+g_ccc.ccc22h)/
                                  (g_ccc.ccc11+g_ccc.ccc21)
                    END IF
                    IF l_c23a=0 AND l_c23b=0 AND l_c23c=0 AND l_c23d=0 AND
                       l_c23e=0 AND l_c23f=0 AND l_c23g=0 AND l_c23h=0 THEN
                       SELECT cca23a,cca23b,cca23c,cca23d,cca23e,
                              cca23f,cca23g,cca23h,cca23   #FUN-7C0028 add cca23f,g,h
                         INTO l_c23a,l_c23b,l_c23c,l_c23d,l_c23e,
                              l_c23f,l_c23g,l_c23h,l_c23   #FUN-7C0028 add l_c23f,g,h
                         FROM cca_file
                        WHERE cca01=q_tlf.tlf01
                          AND cca02=last_yy AND cca03=last_mm
                          AND cca06=type    AND cca07=g_tlfcost   #FUN-7C0028 add
                       # 98.08.16 Star 若上期仍無單價, 則取上期xx帳單價
                        IF SQLCA.sqlcode
                           OR (l_c23a = 0 AND l_c23b = 0 AND l_c23c = 0 AND
                               l_c23d = 0 
                           AND l_c23f = 0 AND l_c23g = 0 AND l_c23h = 0) THEN   #FUN-7C0028 add
                           SELECT ccc23a,ccc23b,ccc23c,ccc23d,ccc23e,
                                  ccc23f,ccc23g,ccc23h,ccc23   #FUN-7C0028 add ccc23f,g,h 
                             INTO l_c23a,l_c23b,l_c23c,l_c23d,l_c23e,
                                  l_c23f,l_c23g,l_c23h,l_c23   #FUN-7C0028 add l_c23f,g,h
                             FROM ccc_file
                            WHERE ccc01=q_tlf.tlf01
                              AND ccc02=last_yy AND ccc03=last_mm
                              AND ccc07=type    AND ccc08=g_tlfcost   #FUN-7C0028 add
                        END IF
                    END IF
                    IF g_ccc.ccc11 + g_ccc.ccc21 = 0 THEN
                       LET amta=amta + (q_tlf.tlf10*l_c23a)
                       LET amtb=amtb + (q_tlf.tlf10*l_c23b)
                       LET amtc=amtc + (q_tlf.tlf10*l_c23c)
                       LET amtd=amtd + (q_tlf.tlf10*l_c23d)
                       LET amte=amte + (q_tlf.tlf10*l_c23e)
                       LET amtf=amtf + (q_tlf.tlf10*l_c23f)   #FUN-7C0028 add
                       LET amtg=amtg + (q_tlf.tlf10*l_c23g)   #FUN-7C0028 add
                       LET amth=amth + (q_tlf.tlf10*l_c23h)   #FUN-7C0028 add
                    ELSE
                       LET amta=amta + (q_tlf.tlf10*(g_ccc.ccc12a+g_ccc.ccc22a)/
                                                    (g_ccc.ccc11+g_ccc.ccc21))
                       LET amtb=amtb + (q_tlf.tlf10*(g_ccc.ccc12b+g_ccc.ccc22b)/
                                                    (g_ccc.ccc11+g_ccc.ccc21))
                       LET amtc=amtc + (q_tlf.tlf10*(g_ccc.ccc12c+g_ccc.ccc22c)/
                                                    (g_ccc.ccc11+g_ccc.ccc21))
                       LET amtd=amtd + (q_tlf.tlf10*(g_ccc.ccc12d+g_ccc.ccc22d)/
                                                    (g_ccc.ccc11+g_ccc.ccc21))
                       LET amte=amte + (q_tlf.tlf10*(g_ccc.ccc12e+g_ccc.ccc22e)/
                                                    (g_ccc.ccc11+g_ccc.ccc21))
                       LET amtf=amtf + (q_tlf.tlf10*(g_ccc.ccc12f+g_ccc.ccc22f)/
                                                    (g_ccc.ccc11+g_ccc.ccc21))
                       LET amtg=amtg + (q_tlf.tlf10*(g_ccc.ccc12g+g_ccc.ccc22g)/
                                                    (g_ccc.ccc11+g_ccc.ccc21))
                       LET amth=amth + (q_tlf.tlf10*(g_ccc.ccc12h+g_ccc.ccc22h)/
                                                    (g_ccc.ccc11+g_ccc.ccc21))
                    END IF
                 END IF
                 LET amt=amta+amtb+amtc+amtd+amte+amtf+amtg+amth   #FUN-7C0028 add amtf,g,h
            WHEN q_tlf.tlf13[1,5]='asfi5'             #一般工單出
                 IF g_sma.sma43 = '1' THEN
                    IF u_sign = 1 THEN     #退料
                       CALL p500_get_tlf21(q_tlf.tlf01,q_tlf.tlf10,'1',1)
                       RETURNING l_amt,l_amt1,l_amt2,l_amt3,l_amt4,l_amt5
                                      ,l_amt6,l_amt7,l_amt8   #FUN-7C0028 add
                    ELSE                   #領料
                       CALL p500_upd_cxa09(q_tlf.tlf01,q_tlf.tlf10,1)
                       RETURNING l_amt,l_amt1,l_amt2,l_amt3,l_amt4,l_amt5
                                      ,l_amt6,l_amt7,l_amt8   #FUN-7C0028 add
                    END IF
                    LET amta=amta + l_amt1
                    LET amtb=amtb + l_amt2
                    LET amtc=amtc + l_amt3
                    LET amtd=amtd + l_amt4
                    LET amte=amte + l_amt5
                    LET amtf=amtf + l_amt6   #FUN-7C0028 add
                    LET amtg=amtg + l_amt7   #FUN-7C0028 add
                    LET amth=amth + l_amt8   #FUN-7C0028 add
                 ELSE
                    LET amta=amta + (q_tlf.tlf10*g_ccc.ccc23a)
                    LET amtb=amtb + (q_tlf.tlf10*g_ccc.ccc23b)
                    LET amtc=amtc + (q_tlf.tlf10*g_ccc.ccc23c)
                    LET amtd=amtd + (q_tlf.tlf10*g_ccc.ccc23d)
                    LET amte=amte + (q_tlf.tlf10*g_ccc.ccc23e)
                    LET amtf=amtf + (q_tlf.tlf10*g_ccc.ccc23f)   #FUN-7C0028 add
                    LET amtg=amtg + (q_tlf.tlf10*g_ccc.ccc23g)   #FUN-7C0028 add
                    LET amth=amth + (q_tlf.tlf10*g_ccc.ccc23h)   #FUN-7C0028 add
                 END IF
                 LET amt=amta+amtb+amtc+amtd+amte+amtf+amtg+amth   #FUN-7C0028 add amtf,g,h
                #在將金額加到ccc之前,需先做取位
                 CALL cl_digcut(amt*l_tlf907,g_ccz.ccz26) RETURNING l_amt
                 LET g_ccc.ccc32 = g_ccc.ccc32 + l_amt
            WHEN q_tlf.tlf13[1,5]='asrt3'             #重覆性生產入庫
                 IF NOT cl_null(q_tlf.tlf62) THEN
                    IF g_ima905 = 'N' THEN                             #MOD-750124 modify   #FUN-7C0028 mod
                       SELECT ccg31*-1,ccg32*-1,
                              ccg32a*-1,ccg32b*-1,ccg32c*-1,
                              ccg32d*-1,ccg32e*-1
                             ,ccg32f*-1,ccg32g*-1,ccg32h*-1   #FUN-7C0028 add
                         INTO l_c21,l_c22,l_c22a,l_c22b,l_c22c,l_c22d,l_c22e
                                         ,l_c22f,l_c22g,l_c22h   #FUN-7C0028 add
                         FROM ccg_file
                        WHERE ccg01=q_tlf.tlf62 AND ccg04=q_tlf.tlf01
                          AND ccg02=yy   AND ccg03=mm
                          AND ccg06=type
                          AND ccg07=g_tlfcost   #MOD-C60140 add
 
                       #取得完工數量(sre11)
                       SELECT SUM(sre11) INTO l_sre11 FROM sre_file
                        WHERE sre01=yy AND sre02=mm AND sre04=g_ima01
                       IF l_sre11 IS NULL THEN LET l_sre11 = 0 END IF
                       #取得約當數量(srm04)
                       SELECT srm04 INTO l_srm04 FROM srm_file
                        WHERE srm01=yy AND srm02=mm AND srm03=g_ima01
                       IF l_srm04 IS NULL THEN LET l_srm04 = 0 END IF
 
                       #重覆性生產數量 = 完工數量 + 約當數量
                       LET l_c21 = l_sre11 + l_srm04
                    ELSE
                       SELECT cce21,cce22,cce22a,cce22b,cce22c,cce22d,cce22e
                                         ,cce22f,cce22g,cce22h   #FUN-7C0028 add
                         INTO l_c21,l_c22,l_c22a,l_c22b,l_c22c,l_c22d,l_c22e
                                         ,l_c22f,l_c22g,l_c22h   #FUN-7C0028 add
                         FROM cce_file
                        WHERE cce01=q_tlf.tlf62 AND cce04=q_tlf.tlf01
                          AND cce02=yy   AND cce03=mm
                          AND cce06=type AND cce07=g_tlfcost   #FUN-7C0028 add
                    END IF
                    IF l_c21 != 0 THEN
                       LET l_c23 = l_c22 / l_c21
                       LET l_c23a= l_c22a/ l_c21
                       LET l_c23b= l_c22b/ l_c21
                       LET l_c23c= l_c22c/ l_c21
                       LET l_c23d= l_c22d/ l_c21
                       LET l_c23e= l_c22e/ l_c21
                       LET l_c23f= l_c22f/ l_c21   #FUN-7C0028 add
                       LET l_c23g= l_c22g/ l_c21   #FUN-7C0028 add
                       LET l_c23h= l_c22h/ l_c21   #FUN-7C0028 add
                    ELSE
                       LET l_c23 = 0
                       LET l_c23a= 0
                       LET l_c23b= 0
                       LET l_c23c= 0
                       LET l_c23d= 0
                       LET l_c23e= 0
                       LET l_c23f= 0   #FUN-7C0028 add
                       LET l_c23g= 0   #FUN-7C0028 add
                       LET l_c23h= 0   #FUN-7C0028 add
                    END IF
                    IF l_c21 != 0 THEN
                       LET amta=amta + (q_tlf.tlf10*l_c22a/ l_c21)
                       LET amtb=amtb + (q_tlf.tlf10*l_c22b/ l_c21)
                       LET amtc=amtc + (q_tlf.tlf10*l_c22c/ l_c21)
                       LET amtd=amtd + (q_tlf.tlf10*l_c22d/ l_c21)
                       LET amte=amte + (q_tlf.tlf10*l_c22e/ l_c21)
                       LET amtf=amtf + (q_tlf.tlf10*l_c22f/ l_c21)   #FUN-7C0028 add
                       LET amtg=amtg + (q_tlf.tlf10*l_c22g/ l_c21)   #FUN-7C0028 add
                       LET amth=amth + (q_tlf.tlf10*l_c22h/ l_c21)   #FUN-7C0028 add
                    ELSE
                       LET amta=amta + (q_tlf.tlf10*l_c23a)
                       LET amtb=amtb + (q_tlf.tlf10*l_c23b)
                       LET amtc=amtc + (q_tlf.tlf10*l_c23c)
                       LET amtd=amtd + (q_tlf.tlf10*l_c23d)
                       LET amte=amte + (q_tlf.tlf10*l_c23e)
                       LET amtf=amtf + (q_tlf.tlf10*l_c23f)   #FUN-7C0028 add
                       LET amtg=amtg + (q_tlf.tlf10*l_c23g)   #FUN-7C0028 add
                       LET amth=amth + (q_tlf.tlf10*l_c23h)   #FUN-7C0028 add
                    END IF
                    LET amt=amta+amtb+amtc+amtd+amte+amtf+amtg+amth   #FUN-7C0028 add amtf,g,h
                 END IF
            WHEN q_tlf.tlf13[1,5]='asri2'             #重覆性生產發退領料
                 IF g_sma.sma43 = '1' THEN
                    IF u_sign = 1 THEN     #退料
                       CALL p500_get_tlf21(q_tlf.tlf01,q_tlf.tlf10,'1',1)
                       RETURNING l_amt,l_amt1,l_amt2,l_amt3,l_amt4,l_amt5
                                      ,l_amt6,l_amt7,l_amt8   #FUN-7C0028 add
                    ELSE                   #領料
                       CALL p500_upd_cxa09(q_tlf.tlf01,q_tlf.tlf10,1)
                       RETURNING l_amt,l_amt1,l_amt2,l_amt3,l_amt4,l_amt5
                                      ,l_amt6,l_amt7,l_amt8   #FUN-7C0028 add
                    END IF
                    LET amta=amta + l_amt1
                    LET amtb=amtb + l_amt2
                    LET amtc=amtc + l_amt3
                    LET amtd=amtd + l_amt4
                    LET amte=amte + l_amt5
                    LET amtf=amtf + l_amt6   #FUN-7C0028 add
                    LET amtg=amtg + l_amt7   #FUN-7C0028 add
                    LET amth=amth + l_amt8   #FUN-7C0028 add
                 ELSE
                    LET amta=amta + (q_tlf.tlf10*g_ccc.ccc23a)
                    LET amtb=amtb + (q_tlf.tlf10*g_ccc.ccc23b)
                    LET amtc=amtc + (q_tlf.tlf10*g_ccc.ccc23c)
                    LET amtd=amtd + (q_tlf.tlf10*g_ccc.ccc23d)
                    LET amte=amte + (q_tlf.tlf10*g_ccc.ccc23e)
                    LET amtf=amtf + (q_tlf.tlf10*g_ccc.ccc23f)   #FUN-7C0028 add
                    LET amtg=amtg + (q_tlf.tlf10*g_ccc.ccc23g)   #FUN-7C0028 add
                    LET amth=amth + (q_tlf.tlf10*g_ccc.ccc23h)   #FUN-7C0028 add
                 END IF
                 LET amt=amta+amtb+amtc+amtd+amte+amtf+amtg+amth   #FUN-7C0028 add amtf,g,h
                #在將金額加到ccc之前,需先做取位
                 CALL cl_digcut(amt*l_tlf907,g_ccz.ccz26) RETURNING l_amt
                 LET g_ccc.ccc32 = g_ccc.ccc32 + l_amt
            WHEN (q_tlf.tlf13 = 'atmt260' )
                 AND u_sign=-1
                 SELECT tlf907 INTO l_tlf907 FROM tlf_file
                  WHERE tlf01=q_tlf.tlf01 AND tlf13=q_tlf.tlf13
                    AND tlf06=q_tlf.tlf06
                    AND tlf905=q_tlf.tlf905 AND tlf906=q_tlf.tlf906
                 CALL p500_get_atmt26(l_tlf907)
                 RETURNING amt,amta,amtb,amtc,amtd,amte,amtf,amtg,amth
                #在將金額加到ccc之前,需先做取位
                 CALL cl_digcut(amt*u_sign,g_ccz.ccz26) RETURNING l_amt
                 LET g_ccc.ccc42 = g_ccc.ccc42 + l_amt
            WHEN (q_tlf.tlf13 = 'atmt261')
                 AND u_sign=1
                 SELECT tlf907 INTO l_tlf907 FROM tlf_file
                  WHERE tlf01=q_tlf.tlf01 AND tlf13=q_tlf.tlf13
                    AND tlf06=q_tlf.tlf06
                    AND tlf905=q_tlf.tlf905 AND tlf906=q_tlf.tlf906
                 CALL p500_get_atmt26(l_tlf907)
                 RETURNING amt,amta,amtb,amtc,amtd,amte,amtf,amtg,amth
                #在將金額加到ccc之前,需先做取位
                 CALL cl_digcut(amt*u_sign,g_ccz.ccz26) RETURNING l_amt
                 LET g_ccc.ccc42 = g_ccc.ccc42 + l_amt
            WHEN u_flag='5'
                 LET amta=amta + (q_tlf.tlf10*g_ccc.ccc23a)
                 LET amtb=amtb + (q_tlf.tlf10*g_ccc.ccc23b)
                 LET amtc=amtc + (q_tlf.tlf10*g_ccc.ccc23c)
                 LET amtd=amtd + (q_tlf.tlf10*g_ccc.ccc23d)
                 LET amte=amte + (q_tlf.tlf10*g_ccc.ccc23e)
                 LET amtf=amtf + (q_tlf.tlf10*g_ccc.ccc23f)   #FUN-7C0028 add
                 LET amtg=amtg + (q_tlf.tlf10*g_ccc.ccc23g)   #FUN-7C0028 add
                 LET amth=amth + (q_tlf.tlf10*g_ccc.ccc23h)   #FUN-7C0028 add
                 LET amt=amta+amtb+amtc+amtd+amte+amtf+amtg+amth   #FUN-7C0028 add amtf,g,h
                #在將金額加到ccc之前,需先做取位
                 CALL cl_digcut(amt*l_tlf907,g_ccz.ccz26) RETURNING l_amt
                 LET g_ccc.ccc52 = g_ccc.ccc52 + l_amt
            WHEN q_tlf.tlf13[1,5]='axmt6' OR q_tlf.tlf13 = 'aomt800' #銷售
                 LET l_oga65 = 'N'                                          #MOD-C30809 add
                 SELECT oga65 INTO l_oga65 FROM oga_file WHERE oga01=xxx1   #MOD-C20108 add
                 IF l_oga65 ='Y' THEN CONTINUE FOREACH END IF               #MOD-C20108 add            
                 IF g_sma.sma43 = '1' THEN
                    IF u_sign = 1 THEN     #銷退
                       CALL p500_get_tlf21(q_tlf.tlf01,q_tlf.tlf10,'2',1)
                       RETURNING l_amt,l_amt1,l_amt2,l_amt3,l_amt4,l_amt5
                                      ,l_amt6,l_amt7,l_amt8   #FUN-7C0028 add
                    ELSE                   #銷售
                       CALL p500_upd_cxa09(q_tlf.tlf01,q_tlf.tlf10,1)
                       RETURNING l_amt,l_amt1,l_amt2,l_amt3,l_amt4,l_amt5
                                      ,l_amt6,l_amt7,l_amt8   #FUN-7C0028 add
                    END IF
                    LET amta=amta + l_amt1
                    LET amtb=amtb + l_amt2
                    LET amtc=amtc + l_amt3
                    LET amtd=amtd + l_amt4
                    LET amte=amte + l_amt5
                    LET amtf=amtf + l_amt6   #FUN-7C0028 add
                    LET amtg=amtg + l_amt7   #FUN-7C0028 add
                    LET amth=amth + l_amt8   #FUN-7C0028 add
                 ELSE
                    LET amta=amta + (q_tlf.tlf10*g_ccc.ccc23a)
                    LET amtb=amtb + (q_tlf.tlf10*g_ccc.ccc23b)
                    LET amtc=amtc + (q_tlf.tlf10*g_ccc.ccc23c)
                    LET amtd=amtd + (q_tlf.tlf10*g_ccc.ccc23d)
                    LET amte=amte + (q_tlf.tlf10*g_ccc.ccc23e)
                    LET amtf=amtf + (q_tlf.tlf10*g_ccc.ccc23f)   #FUN-7C0028 add
                    LET amtg=amtg + (q_tlf.tlf10*g_ccc.ccc23g)   #FUN-7C0028 add
                    LET amth=amth + (q_tlf.tlf10*g_ccc.ccc23h)   #FUN-7C0028 add
                 END IF
                 LET amt=amta+amtb+amtc+amtd+amte+amtf+amtg+amth   #FUN-7C0028 add amtf,g,h
 
                #當q_tlf.tlf13[1,5]='axmt6' OR q_tlf.tlf13 = 'aomt800'時,
                #其在出貨單單身的原因碼ogb1001┐
                #    銷退單單身的原因碼ohb50  ┘在aooi301裡面"是否列入銷售費用(azf08)"為Y的話,
                #需將數量、成本寫入ccc81,ccc82,ccc82a~ccc82h裡
                 IF q_tlf.tlf13[1,4]='axmt' THEN   #銷貨單
                    SELECT azf08 INTO l_azf08
                      FROM ogb_file,azf_file
                     WHERE ogb01=q_tlf.tlf905 AND ogb03=q_tlf.tlf906 
                       AND ogb1001=azf01      AND azf02='2'
                    IF SQLCA.SQLCODE THEN LET l_azf08 = 'N' END IF
                   #在將金額加到ccc之前,需先做取位
                    CALL cl_digcut(amt*l_tlf907,g_ccz.ccz26) RETURNING l_amt
                    CALL cl_digcut(amta*l_tlf907,g_ccz.ccz26) RETURNING l_amta
                    CALL cl_digcut(amtb*l_tlf907,g_ccz.ccz26) RETURNING l_amtb
                    CALL cl_digcut(amtc*l_tlf907,g_ccz.ccz26) RETURNING l_amtc
                    CALL cl_digcut(amtd*l_tlf907,g_ccz.ccz26) RETURNING l_amtd
                    CALL cl_digcut(amte*l_tlf907,g_ccz.ccz26) RETURNING l_amte
                    CALL cl_digcut(amtf*l_tlf907,g_ccz.ccz26) RETURNING l_amtf
                    CALL cl_digcut(amtg*l_tlf907,g_ccz.ccz26) RETURNING l_amtg
                    CALL cl_digcut(amth*l_tlf907,g_ccz.ccz26) RETURNING l_amth
                    IF l_azf08 = 'Y' THEN
                       LET g_ccc.ccc82  = g_ccc.ccc82  + l_amt   #(amt*l_tlf907)                       #MOD-840460 mod 
                       LET g_ccc.ccc82a = g_ccc.ccc82a + l_amta  #(amta*l_tlf907)                      #MOD-840460 mod
                       LET g_ccc.ccc82b = g_ccc.ccc82b + l_amtb  #(amtb*l_tlf907)                      #MOD-840460 mod 
                       LET g_ccc.ccc82c = g_ccc.ccc82c + l_amtc  #(amtc*l_tlf907)                      #MOD-840460 mod  
                       LET g_ccc.ccc82d = g_ccc.ccc82d + l_amtd  #(amtd*l_tlf907)                      #MOD-840460 mod 
                       LET g_ccc.ccc82e = g_ccc.ccc82e + l_amte  #(amte*l_tlf907)                      #MOD-840460 mod 
                       LET g_ccc.ccc82f = g_ccc.ccc82f + l_amtf  #(amtf*l_tlf907)   #FUN-7C0028 add    #MOD-840460 mod 
                       LET g_ccc.ccc82g = g_ccc.ccc82g + l_amtg  #(amtg*l_tlf907)   #FUN-7C0028 add    #MOD-840460 mod 
                       LET g_ccc.ccc82h = g_ccc.ccc82h + l_amth  #(amth*l_tlf907)   #FUN-7C0028 add    #MOD-840460 mod 
                    ELSE
                       LET g_ccc.ccc62  = g_ccc.ccc62  + l_amt   #(amt*l_tlf907)                       #MOD-840460 mod 
                       LET g_ccc.ccc62a = g_ccc.ccc62a + l_amta  #(amta*l_tlf907)                      #MOD-840460 mod 
                       LET g_ccc.ccc62b = g_ccc.ccc62b + l_amtb  #(amtb*l_tlf907)                      #MOD-840460 mod 
                       LET g_ccc.ccc62c = g_ccc.ccc62c + l_amtc  #(amtc*l_tlf907)                      #MOD-840460 mod 
                       LET g_ccc.ccc62d = g_ccc.ccc62d + l_amtd  #(amtd*l_tlf907)                      #MOD-840460 mod 
                       LET g_ccc.ccc62e = g_ccc.ccc62e + l_amte  #(amte*l_tlf907)                      #MOD-840460 mod 
                       LET g_ccc.ccc62f = g_ccc.ccc62f + l_amtf  #(amtf*l_tlf907)   #FUN-7C0028 add    #MOD-840460 mod 
                       LET g_ccc.ccc62g = g_ccc.ccc62g + l_amtg  #(amtg*l_tlf907)   #FUN-7C0028 add    #MOD-840460 mod 
                       LET g_ccc.ccc62h = g_ccc.ccc62h + l_amth  #(amth*l_tlf907)   #FUN-7C0028 add    #MOD-840460 mod 
                    END IF
                 END IF
                 IF q_tlf.tlf13 = 'aomt800' THEN   #銷退單
                    SELECT azf08 INTO l_azf08
                      FROM ohb_file,azf_file
                     WHERE ohb01=q_tlf.tlf905 AND ohb03=q_tlf.tlf906
                       AND ohb50=azf01        AND azf02='2'
                    IF SQLCA.SQLCODE THEN LET l_azf08 = 'N' END IF
                   #在將金額加到ccc之前,需先做取位
                    CALL cl_digcut(amt*l_tlf907,g_ccz.ccz26) RETURNING l_amt
                    CALL cl_digcut(amta*l_tlf907,g_ccz.ccz26) RETURNING l_amta
                    CALL cl_digcut(amtb*l_tlf907,g_ccz.ccz26) RETURNING l_amtb
                    CALL cl_digcut(amtc*l_tlf907,g_ccz.ccz26) RETURNING l_amtc
                    CALL cl_digcut(amtd*l_tlf907,g_ccz.ccz26) RETURNING l_amtd
                    CALL cl_digcut(amte*l_tlf907,g_ccz.ccz26) RETURNING l_amte
                    CALL cl_digcut(amtf*l_tlf907,g_ccz.ccz26) RETURNING l_amtf
                    CALL cl_digcut(amtg*l_tlf907,g_ccz.ccz26) RETURNING l_amtg
                    CALL cl_digcut(amth*l_tlf907,g_ccz.ccz26) RETURNING l_amth
                    IF l_azf08 = 'Y' THEN
                       LET g_ccc.ccc82  = g_ccc.ccc82  + l_amt   #(amt*l_tlf907)                      #MOD-840460 mod
                       LET g_ccc.ccc82a = g_ccc.ccc82a + l_amta  #(amta*l_tlf907)                     #MOD-840460 mod
                       LET g_ccc.ccc82b = g_ccc.ccc82b + l_amtb  #(amtb*l_tlf907)                     #MOD-840460 mod
                       LET g_ccc.ccc82c = g_ccc.ccc82c + l_amtc  #(amtc*l_tlf907)                     #MOD-840460 mod
                       LET g_ccc.ccc82d = g_ccc.ccc82d + l_amtd  #(amtd*l_tlf907)                     #MOD-840460 mod
                       LET g_ccc.ccc82e = g_ccc.ccc82e + l_amte  #(amte*l_tlf907)                     #MOD-840460 mod
                       LET g_ccc.ccc82f = g_ccc.ccc82f + l_amtf  #(amtf*l_tlf907)   #FUN-7C0028 add   #MOD-840460 mod
                       LET g_ccc.ccc82g = g_ccc.ccc82g + l_amtg  #(amtg*l_tlf907)   #FUN-7C0028 add   #MOD-840460 mod
                       LET g_ccc.ccc82h = g_ccc.ccc82h + l_amth  #(amth*l_tlf907)   #FUN-7C0028 add   #MOD-840460 mod
                    ELSE
                       LET g_ccc.ccc62  = g_ccc.ccc62  + l_amt   #(amt*l_tlf907)                      #MOD-840460 mod
                       LET g_ccc.ccc62a = g_ccc.ccc62a + l_amta  #(amta*l_tlf907)                     #MOD-840460 mod
                       LET g_ccc.ccc62b = g_ccc.ccc62b + l_amtb  #(amtb*l_tlf907)                     #MOD-840460 mod
                       LET g_ccc.ccc62c = g_ccc.ccc62c + l_amtc  #(amtc*l_tlf907)                     #MOD-840460 mod
                       LET g_ccc.ccc62d = g_ccc.ccc62d + l_amtd  #(amtd*l_tlf907)                     #MOD-840460 mod
                       LET g_ccc.ccc62e = g_ccc.ccc62e + l_amte  #(amte*l_tlf907)                     #MOD-840460 mod
                       LET g_ccc.ccc62f = g_ccc.ccc62f + l_amtf  #(amtf*l_tlf907)   #FUN-7C0028 add   #MOD-840460 mod
                       LET g_ccc.ccc62g = g_ccc.ccc62g + l_amtg  #(amtg*l_tlf907)   #FUN-7C0028 add   #MOD-840460 mod
                       LET g_ccc.ccc62h = g_ccc.ccc62h + l_amth  #(amth*l_tlf907)   #FUN-7C0028 add   #MOD-840460 mod
                    END IF
                 END IF
 
                 # 99.01.05 Star 儲存銷退成本
                #在將金額加到ccc之前,需先做取位
                 CALL cl_digcut(amt*l_tlf907,g_ccz.ccz26) RETURNING l_amt
                 CALL cl_digcut(amta*l_tlf907,g_ccz.ccz26) RETURNING l_amta
                 CALL cl_digcut(amtb*l_tlf907,g_ccz.ccz26) RETURNING l_amtb
                 CALL cl_digcut(amtc*l_tlf907,g_ccz.ccz26) RETURNING l_amtc
                 CALL cl_digcut(amtd*l_tlf907,g_ccz.ccz26) RETURNING l_amtd
                 CALL cl_digcut(amte*l_tlf907,g_ccz.ccz26) RETURNING l_amte
                 CALL cl_digcut(amtf*l_tlf907,g_ccz.ccz26) RETURNING l_amtf
                 CALL cl_digcut(amtg*l_tlf907,g_ccz.ccz26) RETURNING l_amtg
                 CALL cl_digcut(amth*l_tlf907,g_ccz.ccz26) RETURNING l_amth
                 IF l_tlf907 = 1 AND q_tlf.tlf13 = 'aomt800' THEN    #No:CHI-990065 modify
                    LET g_ccc.ccc66 = g_ccc.ccc66 + l_amt     #(amt*l_tlf907)                      #MOD-840460 mod
                    LET g_ccc.ccc66a = g_ccc.ccc66a + l_amta  #(amta*l_tlf907)                     #MOD-840460 mod
                    LET g_ccc.ccc66b = g_ccc.ccc66b + l_amtb  #(amtb*l_tlf907)                     #MOD-840460 mod
                    LET g_ccc.ccc66c = g_ccc.ccc66c + l_amtc  #(amtc*l_tlf907)                     #MOD-840460 mod
                    LET g_ccc.ccc66d = g_ccc.ccc66d + l_amtd  #(amtd*l_tlf907)                     #MOD-840460 mod
                    LET g_ccc.ccc66e = g_ccc.ccc66e + l_amte  #(amte*l_tlf907)                     #MOD-840460 mod
                    LET g_ccc.ccc66f = g_ccc.ccc66f + l_amtf  #(amtf*l_tlf907)   #FUN-7C0028 add   #MOD-840460 mod
                    LET g_ccc.ccc66g = g_ccc.ccc66g + l_amtg  #(amtg*l_tlf907)   #FUN-7C0028 add   #MOD-840460 mod
                    LET g_ccc.ccc66h = g_ccc.ccc66h + l_amth  #(amth*l_tlf907)   #FUN-7C0028 add   #MOD-840460 mod
                 END IF
            WHEN u_flag='6'
                 IF g_sma.sma43 = '1' THEN
                    IF u_sign = 1 THEN
                       CALL p500_get_tlf21(q_tlf.tlf01,q_tlf.tlf10,'5',1)
                       RETURNING l_amt,l_amt1,l_amt2,l_amt3,l_amt4,l_amt5
                                      ,l_amt6,l_amt7,l_amt8
                    ELSE
                       CALL p500_upd_cxa09(q_tlf.tlf01,q_tlf.tlf10,1)
                       RETURNING l_amt,l_amt1,l_amt2,l_amt3,l_amt4,l_amt5
                                      ,l_amt6,l_amt7,l_amt8
                    END IF
                    LET amta=amta + l_amt1
                    LET amtb=amtb + l_amt2
                    LET amtc=amtc + l_amt3
                    LET amtd=amtd + l_amt4
                    LET amte=amte + l_amt5
                    LET amtf=amtf + l_amt6
                    LET amtg=amtg + l_amt7
                    LET amth=amth + l_amt8
                 ELSE
                    LET amta=amta + (q_tlf.tlf10*g_ccc.ccc23a)
                    LET amtb=amtb + (q_tlf.tlf10*g_ccc.ccc23b)
                    LET amtc=amtc + (q_tlf.tlf10*g_ccc.ccc23c)
                    LET amtd=amtd + (q_tlf.tlf10*g_ccc.ccc23d)
                    LET amte=amte + (q_tlf.tlf10*g_ccc.ccc23e)
                    LET amtf=amtf + (q_tlf.tlf10*g_ccc.ccc23f)   #FUN-7C0028 add
                    LET amtg=amtg + (q_tlf.tlf10*g_ccc.ccc23g)   #FUN-7C0028 add
                    LET amth=amth + (q_tlf.tlf10*g_ccc.ccc23h)   #FUN-7C0028 add
                 END IF        #No.MOD-920189 add
                 LET amt=amta+amtb+amtc+amtd+amte+amtf+amtg+amth   #FUN-7C0028 add amtf,g,h
                #在將金額加到ccc之前,需先做取位
                 CALL cl_digcut(amt*l_tlf907,g_ccz.ccz26) RETURNING l_amt
                 LET g_ccc.ccc72 = g_ccc.ccc72 + l_amt
            OTHERWISE CONTINUE FOREACH
       END CASE
       LET t_time = TIME
      #LET g_time=t_time #MOD-C30891 mark
       LET amt=cl_digcut(amt ,g_ccz.ccz26) #FUN-750002
       LET amta=cl_digcut(amta,g_ccz.ccz26) #FUN-750002
       LET amtb=cl_digcut(amtb,g_ccz.ccz26) #FUN-750002
       LET amtc=cl_digcut(amtc,g_ccz.ccz26) #FUN-750002
       LET amtd=cl_digcut(amtd,g_ccz.ccz26) #FUN-750002
       LET amte=cl_digcut(amte,g_ccz.ccz26) #FUN-750002
       LET amtf=cl_digcut(amtf,g_ccz.ccz26) #FUN-7C0028 add
       LET amtg=cl_digcut(amtg,g_ccz.ccz26) #FUN-7C0028 add
       LET amth=cl_digcut(amth,g_ccz.ccz26) #FUN-7C0028 add
       UPDATE tlf_file SET tlf21x  =amt,  #CHI-910041 tlf21-->tlf21x
                           tlf221x =amta, #CHI-910041
                           tlf222x =amtb, #CHI-910041
                           tlf2231x=amtc, #CHI-910041
                           tlf2232x=amtd, #CHI-910041
                           tlf224x =amte, #CHI-910041
                           tlf2241x=amtf,   #FUN-7C0028 add #CHI-910041
                           tlf2242x=amtg,   #FUN-7C0028 add #CHI-910041
                           tlf2243x=amth,   #FUN-7C0028 add #CHI-910041
                           tlf211x =TODAY,   #CHI-910041
                          #tlf212x =g_time  #CHI-910041 #MOD-C30891 mark
                           tlf212x =t_time  #CHI-910041 #MOD-C30891 
               WHERE rowid=q_tlf_rowid
       IF STATUS THEN 
          CALL cl_err3("upd","tlf_file","","",STATUS,"","upd tlf21x:",1)   #No.FUN-660127
       END IF
    IF type = g_ccz.ccz28 THEN
      UPDATE tlf_file SET tlf21=amt, 
                          tlf221=amta,
                          tlf222=amtb,
                          tlf2231=amtc,
                          tlf2232=amtd,
                          tlf224=amte,
                          tlf2241=amtf,
                          tlf2242=amtg,
                          tlf2243=amth,
                          tlf211=TODAY,
                         #tlf212=g_time #MOD-C30891 mark
                          tlf212=t_time #MOD-C30891 
             WHERE rowid=q_tlf_rowid
        IF SQLCA.sqlerrd[3]=0 THEN
           CALL cl_err3("upd","tlf_file","","",'100',"","upd tlf21:",1)
        END IF
     END IF
 
       #新增tlfc_file記錄依 "成本計算類別"  的異動成本
       CALL p500_ins_tlfc(q_tlf_rowid)   #FUN-7C0028 add
 
       IF g_sma.sma43 = '1' THEN
          IF cl_null(amtf) THEN LET amtf = 0 END IF
          IF cl_null(amtg) THEN LET amtg = 0 END IF
          IF cl_null(amth) THEN LET amth = 0 END IF
          UPDATE cxa_file SET cxa09  = amt,
                              cxa091 = amta,
                              cxa092 = amtb,
                              cxa093 = amtc,
                              cxa094 = amtd,
                              cxa095 = amte,
                              cxa096 = amtf,   #FUN-7C0028 add
                              cxa097 = amtg,   #FUN-7C0028 add
                              cxa098 = amth    #FUN-7C0028 add
           WHERE cxa01 = q_tlf.tlf01
             AND cxa04 = q_tlf.tlf06  AND cxa05 = q_tlf.tlf08
             AND cxa06 = q_tlf.tlf905 AND cxa07 = q_tlf.tlf906
             AND cxa010= type         AND cxa011= g_tlfcost   #FUN-7C0028 add
          IF STATUS THEN
             CALL cl_err3("upd","cxa_file",q_tlf.tlf01,q_tlf.tlf06,STATUS,"","upd cxa06 #2",0)   #No.FUN-660127
             LET g_success = 'N'
          END IF
       END IF
   END FOREACH
   CLOSE tlf21_c
END FUNCTION
 
FUNCTION p500_ins_tlfc(p_tlf_rowid)
   DEFINE p_tlf_rowid           LIKE type_file.row_id,    #chr18, FUN-A70120
          l_cnt                 LIKE type_file.num5,
          l_tlf                 RECORD LIKE tlf_file.*,
          l_tlfc                RECORD LIKE tlfc_file.*
   DEFINE l_inb14               LIKE inb_file.inb14       #MOD-B70143 
   DEFINE l_inb                 RECORD LIKE inb_file.*    #CHI-B30076
 
   SELECT * INTO l_tlf.* FROM tlf_file WHERE rowid=p_tlf_rowid
 
   #先判斷資料是否已存在tlfc_file
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM tlfc_file 
    WHERE tlfc01  =l_tlf.tlf01  AND tlfc02  =l_tlf.tlf02
      AND tlfc03  =l_tlf.tlf03  AND tlfc06  =l_tlf.tlf06
      AND tlfc13  =l_tlf.tlf13
      AND tlfc902 =l_tlf.tlf902 AND tlfc903 =l_tlf.tlf903
      AND tlfc904 =l_tlf.tlf904 AND tlfc905 =l_tlf.tlf905
      AND tlfc906 =l_tlf.tlf906 AND tlfc907 =l_tlf.tlf907
      AND tlfctype=type         AND tlfccost=l_tlf.tlfcost
 
   IF l_cnt > 0 THEN    #若原先已存在tlfc_file,需先刪除
      DELETE FROM tlfc_file
       WHERE tlfc01  =l_tlf.tlf01  AND tlfc02  =l_tlf.tlf02
         AND tlfc03  =l_tlf.tlf03  AND tlfc06  =l_tlf.tlf06
         AND tlfc13  =l_tlf.tlf13
         AND tlfc902 =l_tlf.tlf902 AND tlfc903 =l_tlf.tlf903
         AND tlfc904 =l_tlf.tlf904 AND tlfc905 =l_tlf.tlf905
         AND tlfc906 =l_tlf.tlf906 AND tlfc907 =l_tlf.tlf907
         AND tlfctype=type         AND tlfccost=l_tlf.tlfcost    #MOD-840461
   END IF
                                                                                                                         
#No.FUN-AA0025 --begin
#      IF l_tlf.tlf13 = 'aimt302' OR l_tlf.tlf13 = 'aimt312' THEN                                                                    
#         RETURN
#      END IF                                                                                                                        
#No.FUN-AA0025 --end

#MOD-B70143 --begin--
      IF l_tlf.tlf13 = 'aimt302' OR l_tlf.tlf13 = 'aimt312' THEN
      #  LET l_inb14 = NULL                        #CHI-B30076  
      #  SELECT inb14 INTO l_inb14 FROM inb_file   #CHI-B30076
         SELECT * INTO l_inb.* FROM inb_file       #CHI-B30076   
          WHERE inb01 = l_tlf.tlf905 AND inb03 = l_tlf.tlf906
      #CHI-B30076 -------------Begin--------------------------
      #  IF cl_null(l_inb14) THEN LET l_inb14 = 0 END IF
      #  CALL cl_digcut(l_inb14,g_ccz.ccz26) RETURNING l_inb14
      #  LET l_tlf.tlf21  = l_inb14
      #  LET l_tlf.tlf221 = l_inb14
      #  LET l_tlf.tlf21x = l_inb14
      #  LET l_tlf.tlf221x= l_inb14
      #  UPDATE tlf_file SET tlf21  = l_inb14,
      #                      tlf221 = l_inb14,
      #                      tlf21x = l_inb14,
      #                      tlf221x= l_inb14
         LET l_tlf.tlf21   = cl_digcut(l_inb.inb14,g_ccz.ccz26)
         LET l_tlf.tlf21x  = cl_digcut(l_inb.inb14,g_ccz.ccz26)
         
         LET l_tlf.tlf221  = cl_digcut(l_inb.inb09*l_inb.inb13 ,g_ccz.ccz26) #材料成本      
         LET l_tlf.tlf222  = cl_digcut(l_inb.inb09*l_inb.inb132,g_ccz.ccz26) #人工成本      
         LET l_tlf.tlf2231 = cl_digcut(l_inb.inb09*l_inb.inb133,g_ccz.ccz26) #製費一成本     
         LET l_tlf.tlf2232 = cl_digcut(l_inb.inb09*l_inb.inb134,g_ccz.ccz26) #加工成本      
         LET l_tlf.tlf224  = cl_digcut(l_inb.inb09*l_inb.inb135,g_ccz.ccz26) #製費二成本             
         LET l_tlf.tlf2241 = cl_digcut(l_inb.inb09*l_inb.inb136,g_ccz.ccz26) #製費三成本     
         LET l_tlf.tlf2242 = cl_digcut(l_inb.inb09*l_inb.inb137,g_ccz.ccz26) #製費四成本     
         LET l_tlf.tlf2243 = cl_digcut(l_inb.inb09*l_inb.inb138,g_ccz.ccz26) #製費五成本     
         
         LET l_tlf.tlf221x = cl_digcut(l_inb.inb09*l_inb.inb13 ,g_ccz.ccz26) #材料成本 
         LET l_tlf.tlf222x = cl_digcut(l_inb.inb09*l_inb.inb132,g_ccz.ccz26) #人工成本 
         LET l_tlf.tlf2231x= cl_digcut(l_inb.inb09*l_inb.inb133,g_ccz.ccz26) #製費一成本
         LET l_tlf.tlf2232x= cl_digcut(l_inb.inb09*l_inb.inb134,g_ccz.ccz26) #加工成本 
         LET l_tlf.tlf224x = cl_digcut(l_inb.inb09*l_inb.inb135,g_ccz.ccz26) #製費二成本
         LET l_tlf.tlf2241x= cl_digcut(l_inb.inb09*l_inb.inb136,g_ccz.ccz26) #製費三成本
         LET l_tlf.tlf2242x= cl_digcut(l_inb.inb09*l_inb.inb137,g_ccz.ccz26) #製費四成本
         LET l_tlf.tlf2243x= cl_digcut(l_inb.inb09*l_inb.inb138,g_ccz.ccz26) #製費五成本
         UPDATE tlf_file SET tlf21   = l_tlf.tlf21   ,
                             tlf221  = l_tlf.tlf221  ,
                             tlf21x  = l_tlf.tlf21x  ,
                             tlf221x = l_tlf.tlf221x ,
                             tlf222  = l_tlf.tlf222  ,
                             tlf2231 = l_tlf.tlf2231 ,
                             tlf2232 = l_tlf.tlf2232 ,
                             tlf224  = l_tlf.tlf224  ,
                             tlf2241 = l_tlf.tlf2241 ,
                             tlf2242 = l_tlf.tlf2242 ,
                             tlf2243 = l_tlf.tlf2243 ,
                             tlf222x = l_tlf.tlf222x ,
                             tlf2231x= l_tlf.tlf2231x,
                             tlf2232x= l_tlf.tlf2232x,
                             tlf224x = l_tlf.tlf224x ,
                             tlf2241x= l_tlf.tlf2241x,
                             tlf2242x= l_tlf.tlf2242x,
                             tlf2243x= l_tlf.tlf2243x
      #CHI-B30076 -------------End----------------------------
          WHERE tlf905 = l_tlf.tlf905
            AND tlf906 = l_tlf.tlf906
         IF STATUS THEN
            CALL cl_err3("upd","tlf_file",l_tlf.tlf905,l_tlf.tlf906,STATUS,"","upd tlf21x",1)
         END IF
      END IF
#MOD-B70143 --end--      

      LET l_tlfc.tlfc01   = l_tlf.tlf01         #異動料件編號
      LET l_tlfc.tlfc02   = l_tlf.tlf02         #來源狀況
      LET l_tlfc.tlfc026  = l_tlf.tlf026        #單據編號
      LET l_tlfc.tlfc027  = l_tlf.tlf027        #單據項次
      LET l_tlfc.tlfc03   = l_tlf.tlf03         #目的狀況
      LET l_tlfc.tlfc036  = l_tlf.tlf036        #單據編號
      LET l_tlfc.tlfc037  = l_tlf.tlf037        #單據項次
      LET l_tlfc.tlfc06   = l_tlf.tlf06         #單據日期
      LET l_tlfc.tlfc07   = l_tlf.tlf07         #產生日期
      LET l_tlfc.tlfc08   = l_tlf.tlf08         #異動資料產生時間
      LET l_tlfc.tlfc09   = l_tlf.tlf09         #異動資料發出者
      LET l_tlfc.tlfc13   = l_tlf.tlf13         #異動命令代號
      LET l_tlfc.tlfc15   = l_tlf.tlf15         #借方會計科目
      LET l_tlfc.tlfc151  = l_tlf.tlf151        #借方會計科目二
      LET l_tlfc.tlfc16   = l_tlf.tlf16         #貸方會計科目
      LET l_tlfc.tlfc161  = l_tlf.tlf161        #貸方會計科目二
      LET l_tlfc.tlfc211  = l_tlf.tlf211x        #成會計算日期  #CHI-910041
      LET l_tlfc.tlfc212  = l_tlf.tlf212x        #成會計算時間  #CHI-910041
      LET l_tlfc.tlfc2131 = 0                   #No Use
      LET l_tlfc.tlfc2132 = 0                   #No Use
      LET l_tlfc.tlfc214  = 0                   #No Use
      LET l_tlfc.tlfc215  = 0                   #No Use
      LET l_tlfc.tlfc2151 = 0                   #No Use
      LET l_tlfc.tlfc216  = 0                   #No Use
      LET l_tlfc.tlfc2171 = 0                   #No Use
      LET l_tlfc.tlfc2172 = 0                   #No Use
      LET l_tlfc.tlfc21   = l_tlf.tlf21x         #成會異動成本  #CHI-910041 tlf21-->tlf21x
      LET l_tlfc.tlfc221  = l_tlf.tlf221x        #材料成本   #CHI-910041
      LET l_tlfc.tlfc222  = l_tlf.tlf222x        #人工成本   #CHI-910041
      LET l_tlfc.tlfc2231 = l_tlf.tlf2231x       #製費一成本 #CHI-910041
      LET l_tlfc.tlfc2232 = l_tlf.tlf2232x       #加工成本   #CHI-910041
      LET l_tlfc.tlfc224  = l_tlf.tlf224x       #製費二成本  #CHI-910041
      LET l_tlfc.tlfc2241 = l_tlf.tlf2241x       #製費三成本 #CHI-910041
      LET l_tlfc.tlfc2242 = l_tlf.tlf2242x       #製費四成本 #CHI-910041
      LET l_tlfc.tlfc2243 = l_tlf.tlf2243x       #製費五成本 #CHI-910041
      LET l_tlfc.tlfc225  = 0                   #No Use
      LET l_tlfc.tlfc2251 = 0                   #No Use
      LET l_tlfc.tlfc226  = 0                   #No Use
      LET l_tlfc.tlfc2271 = 0                   #No Use
      LET l_tlfc.tlfc2272 = 0                   #No Use
      LET l_tlfc.tlfc229  = 0                   #No Use
      LET l_tlfc.tlfc230  = 0                   #No Use
      LET l_tlfc.tlfc231  = 0                   #No Use
      LET l_tlfc.tlfc902  = l_tlf.tlf902        #倉庫
      LET l_tlfc.tlfc903  = l_tlf.tlf903        #儲位
      LET l_tlfc.tlfc904  = l_tlf.tlf904        #批號
      LET l_tlfc.tlfc905  = l_tlf.tlf905        #單號
      LET l_tlfc.tlfc906  = l_tlf.tlf906        #項次
      LET l_tlfc.tlfc907  = l_tlf.tlf907        #入出庫碼
      LET l_tlfc.tlfctype = type                #成本計算類型
      LET l_tlfc.tlfccost = l_tlf.tlfcost       #成本計算類型編號
     #LET l_tlfc.tlfcplant=g_plant #FUN-980009 add    #FUN-A50075
      LET l_tlfc.tlfclegal=g_legal #FUN-980009 add 
      LET l_tlfc.tlfc15 =l_tlf.tlf15    #FUN-BB0038
      LET l_tlfc.tlfc16 =l_tlf.tlf16    #FUN-BB0038
      LET l_tlfc.tlfc151 =l_tlf.tlf151  #FUN-BB0038
      LET l_tlfc.tlfc161 =l_tlf.tlf161  #FUN-BB0038

 
      INSERT INTO tlfc_file VALUES(l_tlfc.*)
      IF STATUS THEN
         CALL cl_err3("ins","tlfc_file",l_tlfc.tlfctype,l_tlfc.tlfccost,STATUS,"","ins_tlfc:",1)
      END IF
 
END FUNCTION
 
FUNCTION p500_get_tlf21(p_tlf01,p_tlf10,p_chr,p_flag)
   DEFINE l_sql                 LIKE type_file.chr1000  #No.FUN-680122CHAR(300)
   DEFINE p_chr                 LIKE type_file.chr1     #No.FUN-680122CHAR(01)
   DEFINE p_tlf01               LIKE tlf_file.tlf01
   DEFINE p_tlf10               LIKE tlf_file.tlf10
   DEFINE p_flag                LIKE type_file.chr1     #0.單價 1.金額 #No.FUN-680122 VARCHAR(1)
   DEFINE l_tlf21x,l_tlf221x     LIKE tlf_file.tlf21x  #CHI-910041 tlf21-->tlf21x
   DEFINE l_tlf222x,l_tlf2231x    LIKE tlf_file.tlf222x  #CHI-910041
   DEFINE l_tlf2232x,l_tlf224x    LIKE tlf_file.tlf2232x #CHI-910041
   DEFINE l_tlf2241x             LIKE tlf_file.tlf2241x   #FUN-7C0028 add #CHI-910041
   DEFINE l_tlf2242x             LIKE tlf_file.tlf2242x   #FUN-7C0028 add #CHI-910041
   DEFINE l_tlf2243x             LIKE tlf_file.tlf2243x   #FUN-7C0028 add #CHI-910041
   DEFINE l_tlf10               LIKE tlf_file.tlf10
   DEFINE l_amt,l_amt1,l_amt2   LIKE tlf_file.tlf21
   DEFINE l_amt3,l_amt4,l_amt5  LIKE tlf_file.tlf21
   DEFINE l_amt6,l_amt7,l_amt8  LIKE tlf_file.tlf21     #FUN-7C0028 add
   DEFINE l_up,l_up1,l_up2      LIKE ccc_file.ccc23
   DEFINE l_up3,l_up4,l_up5     LIKE ccc_file.ccc23
   DEFINE l_up6,l_up7,l_up8     LIKE ccc_file.ccc23     #FUN-7C0028 add
 
   LET l_tlf21x = 0   #CHI-910041 tlf21-->tlf21x
 
   CASE p_chr
     WHEN '1'    #領退(取最近一筆發料單價)
       LET l_sql = "SELECT tlf21x,tlf221x,tlf222x,tlf2231x,",  #CHI-910041 
                   "       tlf2232x,tlf224x,tlf2241x,tlf2242x,tlf2243x,(tlf10*tlf60)",   #FUN-7C0028 add tlf2241,2242,2243 #CHI-910041
                   "  FROM tlf_file ",
                   " WHERE tlf01 = '",p_tlf01,"'",
                   "   AND tlf62 = '",q_tlf.tlf62,"'",
                   "   AND tlf13 MATCHES 'asfi5*' ",
                   "   AND tlf02 = 50 ",
                   "   AND tlf03 = 60 ",
                   "   AND tlf06 <= '",q_tlf.tlf06,"'",
                   "   AND tlfcost= '",g_tlfcost,"'",   #FUN-7C0028 add
                   " ORDER BY tlf06 DESC,tlf08 DESC "
     WHEN '2'    #銷退(取最近一筆銷售單價)
       LET l_sql = "SELECT tlf21x,tlf221x,tlf222x,tlf2231x,",  #CHI-910041 tlf21-->tlf21x
                   "       tlf2232x,tlf224x,tlf2241x,tlf2242x,tlf2243x,(tlf10*tlf60) ",   #FUN-7C0028 add tlf2241,2242,2243#CHI-910041
                   "  FROM tlf_file ",
                   " WHERE tlf01 = '",p_tlf01,"'",
                   "   AND tlf13 MATCHES 'axmt6*' ",
                   "   AND tlf02 = 50 ",
                   "   AND tlf03 = 724 ",
                   "   AND tlf06 <= '",q_tlf.tlf06,"'"
                  ,"   AND tlfcost= '",g_tlfcost,"'"    #FUN-7C0028 add
       IF NOT cl_null(q_tlf.tlf62) THEN
          LET l_sql = l_sql CLIPPED," AND tlf62 = '",q_tlf.tlf62,"'"
       END IF
       LET l_sql = l_sql CLIPPED," ORDER BY tlf06 DESC,tlf08 DESC "
     WHEN '3'    #拆件材料入(取最近採購入庫成本)
       LET l_sql = "SELECT tlf21x,tlf221x,tlf222x,tlf2231x,",  #CHI-910041 
                   "       tlf2232x,tlf224x,tlf2241x,tlf2242x,tlf2243x,(tlf10*tlf60) ",   #FUN-7C0028 add tlf2241,2242,2243 #CHI-910041
                   "  FROM tlf_file ",
                   " WHERE tlf01 = '",p_tlf01,"'",
                   "   AND (tlf02 = 20 OR tlf02 = 25) ",
                   "   AND tlf03 = 50 ",
                   "   AND tlf905 != '",q_tlf.tlf905,"'",
                   "   AND tlf13 != 'apmt230' ",            #排除代買
                   "   AND tlf06 <= '",q_tlf.tlf06,"'",
                   "   AND tlfcost= '",g_tlfcost,"'",   #FUN-7C0028 add
                   " ORDER BY tlf06 DESC,tlf08 DESC "
     WHEN '4'    #拆件半成品入(取最近工單入庫成本)
       LET l_sql = "SELECT tlf21x,tlf221x,tlf222x,tlf2231x,",   #CHI-910041 
                   "       tlf2232x,tlf224x,tlf2241x,tlf2242x,tlf2243x,(tlf10*tlf60) ",   #FUN-7C0028 add tlf2241,2242,2243 #CHI-910041
                   "  FROM tlf_file ",
                   " WHERE tlf01 = '",p_tlf01,"'",
                   "   AND (tlf02 >= 60 AND tlf02 <= 69) ",
                   "   AND tlf03 = 50 ",
                   "   AND tlf62 != '",q_tlf.tlf62,"'",
                   "   AND tlf06 <= '",q_tlf.tlf06,"'",
                   "   AND tlfcost= '",g_tlfcost,"'",   #FUN-7C0028 add
                   " ORDER BY tlf06 DESC,tlf08 DESC "
     WHEN '5'    #盤盈
       LET l_sql = "SELECT tlf21,tlf221,tlf222,tlf2231,",
                   "       tlf2232,tlf224,tlf2241,tlf2242,tlf2243,(tlf10*tlf60) ",
                   "  FROM tlf_file ",
                   " WHERE tlf01 = '",p_tlf01,"'",
                   "   AND (tlf03 = 50 OR tlf03 = 57) ",
                  #"   AND tlf13 NOT IN('aimp880','aimt324') ",  #TQC-B30129
                   "   AND tlf13 NOT IN('aimp880','aimt324','aimt325','artt256','artt215') ",  #TQC-B30129  #MOD-C70249 add aimt325
                   "   AND tlf06 <= '",q_tlf.tlf06,"'",
                   "   AND tlf08 <= '",q_tlf.tlf08,"'",
                   "   AND tlf21 IS NOT NULL",
                   "   AND tlf907 = '1'",
                   "   AND tlfcost= '",g_tlfcost,"'",
                   " ORDER BY tlf06 DESC,tlf08 DESC "
   END CASE
 
   PREPARE tlf_pre FROM l_sql
   IF STATUS THEN
      CALL cl_err('tlf_pre',STATUS,0) LET g_success = 'N' RETURN 0,0,0,0,0,0
   END IF
   DECLARE tlf_curs CURSOR FOR tlf_pre
 
   OPEN tlf_curs
   IF STATUS THEN
      CALL cl_err('tlf_curs',STATUS,0) LET g_success = 'N' RETURN 0,0,0,0,0,0
   END IF
   FETCH tlf_curs INTO l_tlf21x,l_tlf221x,l_tlf222x,l_tlf2231x,l_tlf2232x,  #CHI-910041 
                       l_tlf224x,l_tlf2241x,l_tlf2242x,l_tlf2243x,l_tlf10   #FUN-7C0028 add l_tlf2241,2242,2243#CHI-910041
   IF p_chr MATCHES '[234]' AND STATUS = 100 THEN    #取不到單價時, 採標準成本
      IF p_chr MATCHES '[34]' THEN
         CALL cl_getmsg('axc-522',g_lang) RETURNING g_msg1 #拆件式工單:
         CALL cl_getmsg('axc-505',g_lang) RETURNING g_msg2
         LET g_msg=g_msg1 CLIPPED,g_sfb.sfb01,g_msg2 CLIPPED,
                   "(",p_tlf01 CLIPPED,")"
 
         LET t_time = TIME
        #LET g_time=t_time #MOD-C30891 mark
        #FUN-A50075--mod--str-- ccy_file拿掉 plantl以及egal
        #INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04,ccyplant,ccylegal)   #No.MOD-470041  #FUN-980009 add ccyplant,ccylegal
        #              VALUES(TODAY,g_time,g_user,g_msg,g_plant,g_legal) #FUN-980009 add g_plant,g_legal
         INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04)
                      #VALUES(TODAY,g_time,g_user,g_msg) #MOD-C30891 mark
                       VALUES(TODAY,t_time,g_user,g_msg) #MOD-C30891 
        #FUN-A50075--mod--end
      END IF
      SELECT stb07,stb08,stb09,0,stb09a,0,0,0,1   #FUN-7C0028 add 0,0,0
        INTO l_tlf221x,l_tlf222x,l_tlf2231x,l_tlf2232x,l_tlf224x,   #CHI-910041
             l_tlf2241x,l_tlf2242x,l_tlf2243x,l_tlf10   #FUN-7C0028 add l_tlf2241,2242,2243 #CHI-910041
        FROM stb_file
       WHERE stb01 = p_tlf01 AND stb02 = yy AND stb03 = mm
      LET l_tlf21x = l_tlf221x + l_tlf222x + l_tlf2231x + l_tlf2232x + l_tlf224x   #CHI-910041 tlf21-->tlf21x#CHI-910041
                             + l_tlf2241x+ l_tlf2242x + l_tlf2243x   #FUN-7C0028 add #CHI-910041
      IF cl_null(l_tlf21x) OR l_tlf21x = 0 THEN    #CHI-910041 tlf21-->tlf21x
         CALL cl_getmsg('axc-506',g_lang) RETURNING g_msg1
         LET g_msg = p_tlf01,g_msg1 CLIPPED
 
         LET t_time = TIME
        #LET g_time=t_time #MOD-C30891 mark
        #FUN-A50075--mod--str-- ccy_file拿掉plant以及legal
        #INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04,ccyplant,ccylegal)   #No.MOD-470041 #FUN-980009 add ccyplant,ccylegal
        #              VALUES(TODAY,g_time,g_user,g_msg,g_plant,g_legal)  #FUN-980009 add g_plant,g_legal
         INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04)
                      #VALUES(TODAY,g_time,g_user,g_msg) #MOD-C30891 mark
                       VALUES(TODAY,t_time,g_user,g_msg) #MOD-C30891 
        #FUN-A50075--mod--end
      END IF
   END IF
 
   IF cl_null(l_tlf21x)   THEN LET l_tlf21x  = 0 END IF   #CHI-910041 tlf21-->tlf21x
   IF cl_null(l_tlf221x)  THEN LET l_tlf221x = 0 END IF   #CHI-910041
   IF cl_null(l_tlf222x)  THEN LET l_tlf222x = 0 END IF   #CHI-910041
   IF cl_null(l_tlf2231x) THEN LET l_tlf2231x= 0 END IF   #CHI-910041
   IF cl_null(l_tlf2232x) THEN LET l_tlf2232x= 0 END IF   #CHI-910041
   IF cl_null(l_tlf224x)  THEN LET l_tlf224x = 0 END IF   #CHI-910041
   IF cl_null(l_tlf2241x) THEN LET l_tlf2241x= 0 END IF   #FUN-7C0028 add #CHI-910041
   IF cl_null(l_tlf2242x) THEN LET l_tlf2242x= 0 END IF   #FUN-7C0028 add #CHI-910041
   IF cl_null(l_tlf2243x) THEN LET l_tlf2243x= 0 END IF   #FUN-7C0028 add #CHI-910041
   IF cl_null(l_tlf10)   THEN LET l_tlf10  = 0 END IF
 
   LET l_amt = (l_tlf21x/l_tlf10)   * p_tlf10    #CHI-910041 tlf21-->tlf21x
   LET l_amt1= (l_tlf221x/l_tlf10)  * p_tlf10    #CHI-910041
   LET l_amt2= (l_tlf222x/l_tlf10)  * p_tlf10    #CHI-910041
   LET l_amt3= (l_tlf2231x/l_tlf10) * p_tlf10    #CHI-910041
   LET l_amt4= (l_tlf2232x/l_tlf10) * p_tlf10    #CHI-910041
   LET l_amt5= (l_tlf224x/l_tlf10)  * p_tlf10    #CHI-910041
   LET l_amt6= (l_tlf2241x/l_tlf10) * p_tlf10   #FUN-7C0028 add #CHI-910041
   LET l_amt7= (l_tlf2242x/l_tlf10) * p_tlf10   #FUN-7C0028 add #CHI-910041
   LET l_amt8= (l_tlf2243x/l_tlf10) * p_tlf10   #FUN-7C0028 add #CHI-910041
 
   LET l_up = (l_tlf21x/l_tlf10)     #CHI-910041 tlf21-->tlf21x
   LET l_up1= (l_tlf221x/l_tlf10)  #CHI-910041
   LET l_up2= (l_tlf222x/l_tlf10)  #CHI-910041
   LET l_up3= (l_tlf2231x/l_tlf10) #CHI-910041
   LET l_up4= (l_tlf2232x/l_tlf10) #CHI-910041
   LET l_up5= (l_tlf224x/l_tlf10)  #CHI-910041
   LET l_up6= (l_tlf2241x/l_tlf10)   #FUN-7C0028 add #CHI-910041
   LET l_up7= (l_tlf2242x/l_tlf10)   #FUN-7C0028 add #CHI-910041
   LET l_up8= (l_tlf2243x/l_tlf10)   #FUN-7C0028 add #CHI-910041
 
   IF p_chr NOT MATCHES '[34]' THEN
      IF cl_null(l_amt6) THEN LET l_amt6 = 0 END IF
      IF cl_null(l_amt7) THEN LET l_amt7 = 0 END IF
      IF cl_null(l_amt8) THEN LET l_amt8 = 0 END IF
      UPDATE cxa_file SET cxa09  = l_amt,
                          cxa091 = l_amt1,
                          cxa092 = l_amt2,
                          cxa093 = l_amt3,
                          cxa094 = l_amt4,
                          cxa095 = l_amt5,
                          cxa096 = l_amt6,   #FUN-7C0028 add
                          cxa097 = l_amt7,   #FUN-7C0028 add
                          cxa098 = l_amt8    #FUN-7C0028 add
       WHERE cxa01 = p_tlf01
         AND cxa04 = q_tlf.tlf06  AND cxa05 = q_tlf.tlf08
         AND cxa06 = q_tlf.tlf905 AND cxa07 = q_tlf.tlf906
         AND cxa010= type         AND cxa011= g_tlfcost   #FUN-7C0028 add
      IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("upd","cxa_file",p_tlf01,q_tlf.tlf06,STATUS,"","upd cxa07",0)   #No.FUN-660127
         LET g_success = 'N'
      END IF
   END IF
   IF p_flag = 0 THEN
      RETURN l_up,l_up1,l_up2,l_up3,l_up4,l_up5,l_up6,l_up7,l_up8   #FUN-7C0028 add l_up6,l_up7,l_up
   ELSE
      RETURN l_amt,l_amt1,l_amt2,l_amt3,l_amt4,l_amt5,l_amt6,l_amt7,l_amt8   #FUN-7C0028 add l_amt6,l_amt7,l_amt8
   END IF
END FUNCTION
 
FUNCTION p500_upd_cxa09(p_part,p_qty,p_flag)
   DEFINE  l_cxa                  RECORD LIKE cxa_file.*
   DEFINE  l_qty,m_qty            LIKE tlf_file.tlf10
   DEFINE  l_up                   LIKE tlf_file.tlf21
   DEFINE  l_amt,l_amt1,l_amt2    LIKE tlf_file.tlf21
   DEFINE  l_amt3,l_amt4,l_amt5   LIKE tlf_file.tlf21
   DEFINE  l_amt6,l_amt7,l_amt8   LIKE tlf_file.tlf21   #FUN-7C0028 add
   DEFINE  p_amt,p_amt1,p_amt2    LIKE tlf_file.tlf21
   DEFINE  p_amt3,p_amt4,p_amt5   LIKE tlf_file.tlf21
   DEFINE  p_amt6,p_amt7,p_amt8   LIKE tlf_file.tlf21   #FUN-7C0028 add
   DEFINE  p_up,p_up1,p_up2       LIKE tlf_file.tlf21
   DEFINE  p_up3,p_up4,p_up5      LIKE tlf_file.tlf21
   DEFINE  p_up6,p_up7,p_up8      LIKE tlf_file.tlf21   #FUN-7C0028 add
   DEFINE  p_qty,t_qty            LIKE tlf_file.tlf10
   DEFINE  p_part                 LIKE tlf_file.tlf01
   DEFINE  p_flag                 LIKE type_file.num5       #No.FUN-680122SMALLINT               #0.單價 1.金額
   DEFINE  l_seq                  LIKE type_file.num5       #No.FUN-680122 SMALLINT
   DEFINE  l_sql                  LIKE type_file.chr1000    #No.FUN-680122 VARCHAR(300)
   DEFINE  l_flag                 LIKE type_file.chr1       #No.FUN-680122 VARCHAR(1)
   DEFINE  l_n                    LIKE type_file.num10      #MOD-DA0096
 
   IF q_tlf.tlf03 = 64 THEN     #委外代買
      LET l_flag = 'Y' ELSE LET l_flag = 'N'
   END IF
   LET l_sql = "SELECT cxa_file.* ",
               "  FROM cxa_file ",
               " WHERE cxa01 = '",p_part,"'",
               "   AND cxa02 = ",yy," AND cxa03 = ",mm
              ,"   AND cxa010='",type,"'"        #FUN-7C0028 add
              ,"   AND cxa011='",g_tlfcost,"'"   #FUN-7C0028 add
   IF l_flag = 'Y' THEN
      LET l_sql = l_sql CLIPPED," AND cxa06 = '",q_tlf.tlf036,"'",
                                " AND cxa07 =  ",q_tlf.tlf037
   ELSE
      LET l_sql = l_sql CLIPPED,
                  " AND cxa08 > cxa10 ",
                  " AND (cxa15 = 'N' OR cxa15 = ' ' OR  cxa15 IS NULL) "
   END IF
   LET l_sql = l_sql CLIPPED," ORDER BY cxa02,cxa03,cxa04,cxa05,cxa06,cxa07 "
   PREPARE cxa_pre FROM l_sql
   IF STATUS THEN
      CALL cl_err('cxa_pre',STATUS,0) LET g_success = 'N' 
      RETURN 0,0,0,0,0,0,0,0,0   #FUN-7C0028 add 0,0,0
   END IF
   DECLARE cxa_curs CURSOR FOR cxa_pre

   #CHI-C80002---begin
   LET l_sql = " INSERT INTO cxc_file ",
               " (cxc01,cxc02,cxc03,cxc04,cxc05,cxc06,cxc07, ",
               " cxc08,cxc09,cxc091,cxc092,cxc093,cxc094,cxc095, ",
               " cxc096,cxc097,cxc098,cxc010,cxc011, ",
               " cxc10,cxc11,cxclegal) ",
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?) "
   PREPARE cxc_ins_p1 FROM l_sql  

   LET l_sql = " UPDATE cxa_file SET cxa10 = cxa10 + ?,",
               "                cxa11 = cxa11 + ?, ",
               "                cxa111= cxa111+ ?, ",
               "                cxa112= cxa112+ ?, ",
               "                cxa113= cxa113+ ?, ",
               "                cxa114= cxa114+ ?, ",
               "                cxa115= cxa115+ ?, ",
               "                cxa116= cxa116+ ?, ",  
               "                cxa117= cxa117+ ?, ",   
               "                cxa118= cxa118+ ? ",    
               " WHERE cxa01=? AND cxa010=? AND cxa011=? ",
               " AND cxa02=? AND cxa03=?   AND cxa04=? ",
               " AND cxa05=? AND cxa06=?   AND cxa07=? " 
   PREPARE cxa_upd_p1 FROM l_sql            
   #CHI-C80002---end
 
   LET m_qty = 0
   LET t_qty = 0
   LET l_qty = 0
   LET p_amt = 0 LET p_amt1= 0 LET p_amt2= 0
   LET p_amt3= 0 LET p_amt4= 0 LET p_amt5= 0
   LET p_amt6= 0 LET p_amt7= 0 LET p_amt8= 0   #FUN-7C0028 add
   LET p_up  = 0 LET p_up1 = 0 LET p_up2 = 0
   LET p_up3 = 0 LET p_up4 = 0 LET p_up5 = 0
   LET p_up6 = 0 LET p_up7 = 0 LET p_up8 = 0   #FUN-7C0028 add
   LET l_seq = 0
   FOREACH cxa_curs INTO l_cxa.*
     IF STATUS THEN
        CALL cl_err('cxa_curs',STATUS,0) LET g_success = 'N'
        RETURN 0,0,0,0,0,0,0,0,0  #FUN-7C0028 add 0,0,0 #No.MOD-930237 add #少加一個0
     END IF
     IF cl_null(l_cxa.cxa08) THEN LET l_cxa.cxa08 = 0 END IF
     IF cl_null(l_cxa.cxa09) THEN LET l_cxa.cxa09 = 0 END IF
     IF cl_null(l_cxa.cxa091) THEN LET l_cxa.cxa091 = 0 END IF
     IF cl_null(l_cxa.cxa092) THEN LET l_cxa.cxa092 = 0 END IF
     IF cl_null(l_cxa.cxa093) THEN LET l_cxa.cxa093 = 0 END IF
     IF cl_null(l_cxa.cxa094) THEN LET l_cxa.cxa094 = 0 END IF
     IF cl_null(l_cxa.cxa095) THEN LET l_cxa.cxa095 = 0 END IF
     IF cl_null(l_cxa.cxa10) THEN LET l_cxa.cxa10 = 0 END IF
     LET l_seq = l_seq + 1
     LET m_qty = (l_cxa.cxa08 - l_cxa.cxa10) - (p_qty - t_qty)
     IF m_qty > 0 THEN
        LET l_qty = p_qty - t_qty
     ELSE
        LET l_qty = l_cxa.cxa08 - l_cxa.cxa10
     END IF
     LET t_qty = t_qty + l_qty
     LET l_up = l_cxa.cxa09 / l_cxa.cxa08
     IF cl_null(l_up) THEN LET l_up = 0 END IF
     LET l_amt = l_qty * (l_cxa.cxa09 / l_cxa.cxa08)   #No.MOD-930237 add
     LET l_amt1= l_qty * (l_cxa.cxa091 / l_cxa.cxa08)
     LET l_amt2= l_qty * (l_cxa.cxa092 / l_cxa.cxa08)
     LET l_amt3= l_qty * (l_cxa.cxa093 / l_cxa.cxa08)
     LET l_amt4= l_qty * (l_cxa.cxa094 / l_cxa.cxa08)
     LET l_amt5= l_qty * (l_cxa.cxa095 / l_cxa.cxa08)
     LET l_amt6= l_qty * (l_cxa.cxa096 / l_cxa.cxa08)   #FUN-7C0028 add
     LET l_amt7= l_qty * (l_cxa.cxa097 / l_cxa.cxa08)   #FUN-7C0028 add
     LET l_amt8= l_qty * (l_cxa.cxa098 / l_cxa.cxa08)   #FUN-7C0028 add
     LET p_amt = p_amt + l_amt
     LET p_amt1= p_amt1+ l_amt1
     LET p_amt2= p_amt2+ l_amt2
     LET p_amt3= p_amt3+ l_amt3
     LET p_amt4= p_amt4+ l_amt4
     LET p_amt5= p_amt5+ l_amt5
     LET p_amt6= p_amt6+ l_amt6   #FUN-7C0028 add
     LET p_amt7= p_amt7+ l_amt7   #FUN-7C0028 add
     LET p_amt8= p_amt8+ l_amt8   #FUN-7C0028 add
 
     LET p_up  = l_cxa.cxa09  / l_cxa.cxa08
     LET p_up1 = l_cxa.cxa091 / l_cxa.cxa08
     LET p_up2 = l_cxa.cxa092 / l_cxa.cxa08
     LET p_up3 = l_cxa.cxa093 / l_cxa.cxa08
     LET p_up4 = l_cxa.cxa094 / l_cxa.cxa08
     LET p_up5 = l_cxa.cxa095 / l_cxa.cxa08
     LET p_up6 = l_cxa.cxa096 / l_cxa.cxa08   #FUN-7C0028 add
     LET p_up7 = l_cxa.cxa097 / l_cxa.cxa08   #FUN-7C0028 add
     LET p_up8 = l_cxa.cxa098 / l_cxa.cxa08   #FUN-7C0028 add
     #MOD-DA0096 add begin----------------------
     LET l_n=0
     IF g_sfb99 = 'Y' AND g_sfb02='11' THEN
        SELECT COUNT(*) INTO l_n FROM tlf_temp01
         WHERE tlf905=q_tlf.tlf905 AND tlf906=q_tlf.tlf906
        IF cl_null(l_n) THEN LET l_n=0 END IF
     END IF
     #MOD-DA0096 add end------------------------
 
    #IF p_flag = 1 THEN
     IF p_flag = 1 AND l_n = 0 THEN #MOD-DA0096 add l_n = 0
        #產生沖銷明細
        #CHI-C80002---begin mark
        #INSERT INTO cxc_file
        #   (cxc01,cxc02,cxc03,cxc04,cxc05,cxc06,cxc07,
        #    cxc08,cxc09,cxc091,cxc092,cxc093,cxc094,cxc095,
        #    cxc096,cxc097,cxc098,cxc010,cxc011,   #FUN-7C0028 add
        #   #cxc10,cxc11,cxcplant,cxclegal) #FUN-980009 add cxcplant,cxclegal   #FUN-A50075 mark
        #    cxc10,cxc11,cxclegal)          #FUN-A50075 del plant
        #   VALUES(l_cxa.cxa01,l_cxa.cxa02,l_cxa.cxa03,q_tlf.tlf905,
        #          q_tlf.tlf906,l_cxa.cxa06,l_cxa.cxa07,l_qty,l_amt,
        #          l_amt1,l_amt2,l_amt3,l_amt4,l_amt5,
        #          l_amt6,l_amt7,l_amt8,type,q_tlf.tlfcost,   #FUN-7C0028 add
        #         #l_up,l_seq,g_plant,g_legal) #FUN-980009 add g_plant,g_legal
        #          l_up,l_seq,g_legal)         #FUN-A50075 del plant 
        #CHI-C80002---end
        #CHI-C80002---begin
        EXECUTE cxc_ins_p1 USING l_cxa.cxa01,l_cxa.cxa02,l_cxa.cxa03,q_tlf.tlf905,
                  q_tlf.tlf906,l_cxa.cxa06,l_cxa.cxa07,l_qty,l_amt,
                  l_amt1,l_amt2,l_amt3,l_amt4,l_amt5,
                  l_amt6,l_amt7,l_amt8,type,q_tlf.tlfcost,
                  l_up,l_seq,g_legal
        #CHI-C80002---end
        IF NOT cl_sql_dup_value(SQLCA.SQLCODE) THEN   #No.MOD-920071 
           #CHI-C80002---begin mark
           #UPDATE cxa_file SET cxa10 = cxa10 + l_qty,
           #                    cxa11 = cxa11 + l_amt,
           #                    cxa111= cxa111+ l_amt1,
           #                    cxa112= cxa112+ l_amt2,
           #                    cxa113= cxa113+ l_amt3,
           #                    cxa114= cxa114+ l_amt4,
           #                    cxa115= cxa115+ l_amt5,
           #                    cxa116= cxa116+ l_amt6,   #FUN-7C0028 add
           #                    cxa117= cxa117+ l_amt7,   #FUN-7C0028 add
           #                    cxa118= cxa118+ l_amt8    #FUN-7C0028 add
           # WHERE cxa01=l_cxa.cxa01 AND cxa010=l_cxa.cxa010 AND cxa011=l_cxa.cxa011
           #   AND cxa02=l_cxa.cxa02 AND cxa03=l_cxa.cxa03   AND cxa04=l_cxa.cxa04
           #   AND cxa05=l_cxa.cxa05 AND cxa06=l_cxa.cxa06   AND cxa07=l_cxa.cxa07
           #CHI-C80002---end
           #CHI-C80002---begin
           EXECUTE cxa_upd_p1 USING l_qty,l_amt,l_amt1,l_amt2,l_amt3,l_amt4,l_amt5,l_amt6,l_amt7,l_amt8,
                                    l_cxa.cxa01,l_cxa.cxa010,l_cxa.cxa011,l_cxa.cxa02,l_cxa.cxa03,
                                    l_cxa.cxa04,l_cxa.cxa05,l_cxa.cxa06,l_cxa.cxa07
           #CHI-C80002---end
           IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
              CALL cl_err3("upd","cxa_file",l_cxa.cxa01,l_cxa.cxa02,STATUS,"","upd cxa10/11",0)   #No.FUN-660127
              LET g_success = 'N'
              RETURN 0,0,0,0,0,0,0,0,0   #FUN-7C0028 add 0,0,0
           END IF
        END IF
     END IF
     IF m_qty > 0 THEN
        IF g_sfb99 = 'Y' AND g_sfb02='11' THEN                      #MOD-DA0096 add
           INSERT INTO tlf_temp01 VALUES(q_tlf.tlf905,q_tlf.tlf906) #MOD-DA0096 add
        END IF                                                      #MOD-DA0096 add
        EXIT FOREACH
     END IF
   END FOREACH
   IF p_flag = 0 THEN
      RETURN p_up,p_up1,p_up2,p_up3,p_up4,p_up5,p_up6,p_up7,p_up8   #FUN-7C0028 add p_up6,p_up7,p_up8
   ELSE
      RETURN p_amt,p_amt1,p_amt2,p_amt3,p_amt4,p_amt5,p_amt6,p_amt7,p_amt8   #FUN-7C0028 add p_amt6,p_amt7,p_amt8
   END IF
END FUNCTION
 
#insert cxc for 倉退
FUNCTION p500_upd_cxa09_2(p_part,p_qty,p_tlf21,p_flag)
   DEFINE  l_cxa                  RECORD LIKE cxa_file.*
   DEFINE  l_qty,m_qty            LIKE tlf_file.tlf10
   DEFINE  l_up                   LIKE tlf_file.tlf21
   DEFINE  p_tlf21                LIKE tlf_file.tlf21
   DEFINE  l_amt,l_amt1,l_amt2    LIKE tlf_file.tlf21
   DEFINE  l_amt3,l_amt4,l_amt5   LIKE tlf_file.tlf21
   DEFINE  l_amt6,l_amt7,l_amt8   LIKE tlf_file.tlf21
   DEFINE  p_amt,p_amt1,p_amt2    LIKE tlf_file.tlf21
   DEFINE  p_amt3,p_amt4,p_amt5   LIKE tlf_file.tlf21
   DEFINE  p_amt6,p_amt7,p_amt8   LIKE tlf_file.tlf21
   DEFINE  p_up,p_up1,p_up2       LIKE tlf_file.tlf21
   DEFINE  p_up3,p_up4,p_up5      LIKE tlf_file.tlf21
   DEFINE  p_up6,p_up7,p_up8      LIKE tlf_file.tlf21
   DEFINE  p_qty,t_qty            LIKE tlf_file.tlf10
   DEFINE  p_part                 LIKE tlf_file.tlf01
   DEFINE  p_flag                 LIKE type_file.num5           #No.FUN-680122SMALLINT            
   DEFINE  l_seq                 LIKE type_file.num5           #No.FUN-680122 SMALLINT
   DEFINE  l_sql                  LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(300)
   DEFINE  l_flag                 LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
   LET l_flag = 'N'
   LET l_sql = "SELECT cxa_file.* ",
               "  FROM cxa_file ",
               " WHERE cxa01 = '",p_part,"'",
               "   AND cxa02 = ",yy," AND cxa03 = ",mm,
               " AND cxa08 > cxa10",
               "   AND cxa010='",type,"'",       #FUN-7C0028 add
               "   AND cxa011='",g_tlfcost,"'",  #FUN-7C0028 add
               " AND (cxa15 = 'N' OR cxa15 = ' ' OR  cxa15 IS NULL)",
               " ORDER BY cxa02,cxa03,cxa04,cxa05,cxa06,cxa07 "
   PREPARE cxa_pre1 FROM l_sql
   IF STATUS THEN
      CALL cl_err('cxa_pre',STATUS,0) LET g_success = 'N' 
      RETURN 0,0,0,0,0, 0,0,0,0
   END IF
   DECLARE cxa_curs1 CURSOR FOR cxa_pre1

   #CHI-C80002---begin
   LET l_sql = " INSERT INTO cxc_file(cxc01,cxc02,cxc03,cxc04,cxc05,cxc06,cxc07, ",
               "                      cxc08,cxc09,cxc091,cxc092,cxc093,cxc094,cxc095, ",
               "                      cxc096,cxc097,cxc098,cxc010,cxc011, ",
               "                      cxc10,cxc11,cxclegal) ",
               "               VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?) "
   PREPARE cxc_ins_p2 FROM l_sql 

   LET l_sql = " UPDATE cxa_file SET cxa10 = cxa10 + ?, ",
               "                 cxa11 = cxa11 + ?, ",
               "                 cxa111= cxa111+ ?, ",
               "                 cxa112= cxa112+ ?, ",
               "                 cxa113= cxa113+ ?, ",
               "                 cxa114= cxa114+ ?, ",
               "                 cxa115= cxa115+ ?, ",
               "                 cxa116= cxa116+ ?, ",
               "                 cxa117= cxa117+ ?, ",
               "                 cxa118= cxa118+ ? ",
               " WHERE cxa01=? AND cxa010=? AND cxa011=? ",
               " AND cxa02=? AND cxa03=?   AND cxa04=? ",
               " AND cxa05=? AND cxa06=?   AND cxa07=? "
   PREPARE cxa_upd_p2 FROM l_sql
   #CHI-C80002---end
 
   LET m_qty = 0
   LET t_qty = 0
   LET l_qty = 0
   LET p_amt = 0 LET p_amt1= 0 LET p_amt2= 0
   LET p_amt3= 0 LET p_amt4= 0 LET p_amt5= 0
   LET p_amt6= 0 LET p_amt7= 0 LET p_amt8= 0
   LET p_up  = 0 LET p_up1 = 0 LET p_up2 = 0
   LET p_up3 = 0 LET p_up4 = 0 LET p_up5 = 0
   LET p_up6 = 0 LET p_up7 = 0 LET p_up8 = 0
   LET l_seq = 0
   FOREACH cxa_curs1 INTO l_cxa.*
     IF STATUS THEN
        CALL cl_err('cxa_curs',STATUS,0) LET g_success = 'N'
        RETURN 0,0,0,0,0, 0,0,0,0
     END IF
     IF cl_null(l_cxa.cxa08) THEN LET l_cxa.cxa08 = 0 END IF
     IF cl_null(l_cxa.cxa09) THEN LET l_cxa.cxa09 = 0 END IF
     IF cl_null(l_cxa.cxa091) THEN LET l_cxa.cxa091 = 0 END IF
     IF cl_null(l_cxa.cxa092) THEN LET l_cxa.cxa092 = 0 END IF
     IF cl_null(l_cxa.cxa093) THEN LET l_cxa.cxa093 = 0 END IF
     IF cl_null(l_cxa.cxa094) THEN LET l_cxa.cxa094 = 0 END IF
     IF cl_null(l_cxa.cxa095) THEN LET l_cxa.cxa095 = 0 END IF
     IF cl_null(l_cxa.cxa096) THEN LET l_cxa.cxa096 = 0 END IF
     IF cl_null(l_cxa.cxa097) THEN LET l_cxa.cxa097 = 0 END IF
     IF cl_null(l_cxa.cxa098) THEN LET l_cxa.cxa098 = 0 END IF
     IF cl_null(l_cxa.cxa10) THEN LET l_cxa.cxa10 = 0 END IF
     LET l_seq = l_seq + 1
     LET m_qty = (l_cxa.cxa08 - l_cxa.cxa10) - (p_qty - t_qty)
     IF m_qty > 0 THEN
        LET l_qty = p_qty - t_qty
     ELSE
        LET l_qty = l_cxa.cxa08 - l_cxa.cxa10
     END IF
     LET t_qty = t_qty + l_qty
 
     LET l_up = p_tlf21 / p_qty
     IF cl_null(l_up) THEN LET l_up = 0 END IF
     LET l_amt = l_up*l_qty
     LET l_amt1= l_up*l_qty
     LET l_amt2= 0 LET l_amt3= 0 LET l_amt4= 0 LET l_amt5= 0
     LET l_amt6= 0 LET l_amt7= 0 LET l_amt8= 0
     LET p_amt = p_amt + l_amt
     LET p_amt1= p_amt1+ l_amt1
     LET p_amt2= p_amt2+ l_amt2
     LET p_amt3= p_amt3+ l_amt3
     LET p_amt4= p_amt4+ l_amt4
     LET p_amt5= p_amt5+ l_amt5
     LET p_amt6= p_amt6+ l_amt6
     LET p_amt7= p_amt7+ l_amt7
     LET p_amt8= p_amt8+ l_amt8
     LET p_up  = p_tlf21/l_qty
     LET p_up1 = p_tlf21/l_qty
     LET p_up2 = 0
     LET p_up3 = 0
     LET p_up4 = 0
     LET p_up5 = 0
     LET p_up6 = 0
     LET p_up7 = 0
     LET p_up8 = 0
     IF p_flag = 1 THEN
        #產生沖銷明細
        #CHI-C80002---begin mark
        #INSERT INTO cxc_file(cxc01,cxc02,cxc03,cxc04,cxc05,cxc06,cxc07,
        #                     cxc08,cxc09,cxc091,cxc092,cxc093,cxc094,cxc095,
        #                     cxc096,cxc097,cxc098,cxc010,cxc011,   #FUN-7C0028 add
        #                    #cxc10,cxc11,cxcplant,cxclegal) #FUN-980009 add cxcplant,cxclegal   #FUN-A50075 mark
        #                     cxc10,cxc11,cxclegal)          #FUN-A50075
        #              VALUES(l_cxa.cxa01,l_cxa.cxa02,l_cxa.cxa03,q_tlf.tlf905,
        #                     q_tlf.tlf906,l_cxa.cxa06,l_cxa.cxa07,l_qty,l_amt,
        #                     l_amt1,l_amt2,l_amt3,l_amt4,l_amt5,
        #                     l_amt6,l_amt7,l_amt8,type,q_tlf.tlfcost,   #FUN-7C0028 add
        #                    #l_up,l_seq,g_plant,g_legal) #FUN-980009 add g_plant,g_legal   #FUN-A50075
        #                     l_up,l_seq,g_legal) #FUN-A50075
        #CHI-C80002---end
        #CHI-C80002---begin
        EXECUTE cxc_ins_p2 USING l_cxa.cxa01,l_cxa.cxa02,l_cxa.cxa03,q_tlf.tlf905,
                                 q_tlf.tlf906,l_cxa.cxa06,l_cxa.cxa07,l_qty,l_amt,
                                 l_amt1,l_amt2,l_amt3,l_amt4,l_amt5,
                                 l_amt6,l_amt7,l_amt8,type,q_tlf.tlfcost,
                                 l_up,l_seq,g_legal
        #CHI-C80002---end
        IF SQLCA.SQLCODE=0 THEN
           #CHI-C80002---begin mark
           #UPDATE cxa_file SET cxa10 = cxa10 + l_qty,
           #                    cxa11 = cxa11 + l_amt,
           #                    cxa111= cxa111+ l_amt1,
           #                    cxa112= cxa112+ l_amt2,
           #                    cxa113= cxa113+ l_amt3,
           #                    cxa114= cxa114+ l_amt4,
           #                    cxa115= cxa115+ l_amt5,
           #                    cxa116= cxa116+ l_amt6,   #FUN-7C0028 add
           #                    cxa117= cxa117+ l_amt7,   #FUN-7C0028 add
           #                    cxa118= cxa118+ l_amt8    #FUN-7C0028 add
           # WHERE cxa01=l_cxa.cxa01 AND cxa010=l_cxa.cxa010 AND cxa011=l_cxa.cxa011
           #   AND cxa02=l_cxa.cxa02 AND cxa03=l_cxa.cxa03   AND cxa04=l_cxa.cxa04
           #   AND cxa05=l_cxa.cxa05 AND cxa06=l_cxa.cxa06   AND cxa07=l_cxa.cxa07
           #CHI-C80002---end
           #CHI-C80002---begin
           EXECUTE cxa_upd_p2 USING l_qty,l_amt,l_amt1,l_amt2,l_amt3,l_amt4,l_amt5,l_amt6,l_amt7,l_amt8,
                                    l_cxa.cxa01,l_cxa.cxa010,l_cxa.cxa011,l_cxa.cxa02,l_cxa.cxa03,
                                    l_cxa.cxa04,l_cxa.cxa05,l_cxa.cxa06,l_cxa.cxa07
           #CHI-C80002---end
           IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
              CALL cl_err3("upd","cxa_file",l_cxa.cxa01,l_cxa.cxa02,STATUS,"","upd cxa10/11",0)   #No.FUN-660127
              LET g_success = 'N'
              RETURN 0,0,0,0,0, 0,0,0,0
           END IF
        END IF
     END IF
     IF m_qty >= 0 THEN
        EXIT FOREACH
     END IF
   END FOREACH
   IF p_flag = 0 THEN
      RETURN p_up,p_up1,p_up2,p_up3,p_up4,p_up5,p_up6,p_up7,p_up8   #FUN-7C0028
   ELSE
      RETURN p_amt,p_amt1,p_amt2,p_amt3,p_amt4,p_amt5,p_amt6,p_amt7,p_amt8   #FUN-7C0028
   END IF
 
END FUNCTION
 
FUNCTION p500_get_atmt26(p_tlf907)
   DEFINE p_tlf907   LIKE tlf_file.tlf907,
          l_sql      STRING,
          l_flag     LIKE tlf_file.tlf907,
          l_tlf      RECORD LIKE tlf_file.*,
          l_ccc23    LIKE ccc_file.ccc23,
          l_ccc23a   LIKE ccc_file.ccc23a,
          l_ccc23b   LIKE ccc_file.ccc23b,
          l_ccc23c   LIKE ccc_file.ccc23c,
          l_ccc23d   LIKE ccc_file.ccc23d,
          l_ccc23e   LIKE ccc_file.ccc23e,
          l_ccc23f   LIKE ccc_file.ccc23f,   #FUN-7C0028 add
          l_ccc23g   LIKE ccc_file.ccc23g,   #FUN-7C0028 add
          l_ccc23h   LIKE ccc_file.ccc23h    #FUN-7C0028 add
 
   #--->子件單價
   #-->先取本月月平均單價，抓不到再取上月月平均單價
   LET l_ccc23 =0
   LET l_ccc23a=0
   LET l_ccc23b=0
   LET l_ccc23c=0
   LET l_ccc23d=0
   LET l_ccc23e=0
   LET l_ccc23f=0   #FUN-7C0028 add
   LET l_ccc23g=0   #FUN-7C0028 add
   LET l_ccc23h=0   #FUN-7C0028 add
   LET amt     =0
   LET amta    =0
   LET amtb    =0
   LET amtc    =0
   LET amtd    =0
   LET amte    =0
   LET amtf    =0   #FUN-7C0028 add
   LET amtg    =0   #FUN-7C0028 add
   LET amth    =0   #FUN-7C0028 add
 
   #-->取本月月平均單價
   SELECT ccc23,ccc23a,ccc23b,ccc23c,ccc23d,ccc23e
               ,ccc23f,ccc23g,ccc23h   #FUN-7C0028 add
     INTO l_ccc23,l_ccc23a,l_ccc23b,l_ccc23c,l_ccc23d,l_ccc23e
                 ,l_ccc23f,l_ccc23g,l_ccc23h   #FUN-7C0028 add
     FROM ccc_file
    WHERE ccc01=g_ima01 AND ccc02=yy AND ccc03=mm
   IF STATUS OR cl_null(l_ccc23) OR l_ccc23 =0 THEN
     ##-->抓不就到取上月開帳
      #-->抓不就到取上月月平均單價
      SELECT ccc23,ccc23a,ccc23b,ccc23c,ccc23d,ccc23e
                  ,ccc23f,ccc23g,ccc23h   #FUN-7C0028 add
        INTO l_ccc23,l_ccc23a,l_ccc23b,l_ccc23c,l_ccc23d,l_ccc23e
                    ,l_ccc23f,l_ccc23g,l_ccc23h   #FUN-7C0028 add
        FROM ccc_file
       WHERE ccc01=g_ima01 AND ccc02=last_yy AND ccc03=last_mm
   END IF
 
  #例：組合單 將A <= B + C  (組合的子件)
  #    拆解單 將A => B , C  (拆解出的子件)
  #    B 10個 單價4 (月加權)
  #    C 10個 單價6 (月加權)
  #    組合成A 10個 異動成本 = 10*4 + 10*6 = 100
  #    ==>A 的異動成本必須來自 B + C
 
   #抓子件的tlf資料,加總起來後當成A的異動成本
   IF q_tlf.tlf13='atmt260' THEN
      LET l_sql = "SELECT tlf_file.* ",
                  "  FROM tsd_file,tlf_file",
                  " WHERE tsd01 = tlf905 AND tsd02 = tlf906 AND tsd03 = tlf01",
                  "   AND tlf905= ?",
                  "   AND tlf13 = ?",
                  "   AND tlf907= ?"
                 ,"   AND tlfcost=?"   #FUN-7C0028 add
   END IF
   IF q_tlf.tlf13='atmt261' THEN
      LET l_sql = "SELECT tlf_file.* ",
                  "  FROM tsf_file,tlf_file",
                  " WHERE tsf01 = tlf905 AND tsf02 = tlf906 AND tsf03 = tlf01",
                  "   AND tlf905= ?",
                  "   AND tlf13 = ?",
                  "   AND tlf907= ?"
                 ,"   AND tlfcost=?"   #FUN-7C0028 add
   END IF
   DECLARE p500_tsdf_tlf_c1 CURSOR FROM l_sql
 
   IF (q_tlf.tlf13='atmt260' AND p_tlf907 = -1) OR     #組合的子件
      (q_tlf.tlf13='atmt261' AND p_tlf907 =  1) THEN   #拆解出的子件
      LET amta=amta + (q_tlf.tlf10*l_ccc23a)
      LET amtb=amtb + (q_tlf.tlf10*l_ccc23b)
      LET amtc=amtc + (q_tlf.tlf10*l_ccc23c)
      LET amtd=amtd + (q_tlf.tlf10*l_ccc23d)
      LET amte=amte + (q_tlf.tlf10*l_ccc23e)
      LET amtf=amtf + (q_tlf.tlf10*l_ccc23f)   #FUN-7C0028 add
      LET amtg=amtg + (q_tlf.tlf10*l_ccc23g)   #FUN-7C0028 add
      LET amth=amth + (q_tlf.tlf10*l_ccc23h)   #FUN-7C0028 add
   ELSE
      IF q_tlf.tlf13='atmt260' THEN LET l_flag = -1 END IF
      IF q_tlf.tlf13='atmt261' THEN LET l_flag =  1 END IF
 
      FOREACH p500_tsdf_tlf_c1 USING q_tlf.tlf905,q_tlf.tlf13,l_flag,g_tlfcost INTO l_tlf.*   #FUN-7C0028 add g_tlfcost 
         IF SQLCA.sqlcode THEN
            CALL cl_err('p500_tsdf_tlf_c1',SQLCA.sqlcode,0)   
            EXIT FOREACH
         END IF
 
         LET l_ccc23a=0  LET l_ccc23b=0  LET l_ccc23c=0
         LET l_ccc23d=0  LET l_ccc23e=0
         LET l_ccc23f=0  LET l_ccc23g=0  LET l_ccc23h=0   #FUN-7C0028 add
 
         SELECT ccc23a,ccc23b,ccc23c,ccc23d,ccc23e
                      ,ccc23f,ccc23g,ccc23h   #FUN-7C0028 add 
           INTO l_ccc23a,l_ccc23b,l_ccc23c,l_ccc23d,l_ccc23e 
                        ,l_ccc23f,l_ccc23g,l_ccc23h   #FUN-7C0028 add
           FROM ccc_file
          WHERE ccc01=l_tlf.tlf01 AND ccc02=yy AND ccc03=mm
           #AND ccc07=type        AND ccc08=g_tlf.tlfcost   #FUN-7C0028 add   #FUN-7C0028 add  #MOD-C20112 mark
            AND ccc07=type        AND ccc08=g_tlfcost       #MOD-C20112 add
         LET amta=amta + (l_tlf.tlf10*l_ccc23a)
         LET amtb=amtb + (l_tlf.tlf10*l_ccc23b)
         LET amtc=amtc + (l_tlf.tlf10*l_ccc23c)
         LET amtd=amtd + (l_tlf.tlf10*l_ccc23d)
         LET amte=amte + (l_tlf.tlf10*l_ccc23e)
         LET amtf=amtf + (l_tlf.tlf10*l_ccc23f)   #FUN-7C0028 add
         LET amtg=amtg + (l_tlf.tlf10*l_ccc23g)   #FUN-7C0028 add
         LET amth=amth + (l_tlf.tlf10*l_ccc23h)   #FUN-7C0028 add
      END FOREACH
   END IF
 
   LET amt =amta+amtb+amtc+amtd+amte+amtf+amtg+amth   #FUN-7C0028 add amtf+amtg+amth
 
   RETURN amt,amta,amtb,amtc,amtd,amte,amtf,amtg,amth
 
END FUNCTION
 
FUNCTION p500_ccc_ins() # Insert ccc_file
 DEFINE amtx                        LIKE omb_file.omb16         #No.FUN-680122DEC(20,6),   #MOD-4C0005
 DEFINE l_ccc23,l_ccc23a,l_ccc23b   LIKE ccc_file.ccc23
 DEFINE l_ccc23c,l_ccc23d,l_ccc23e  LIKE ccc_file.ccc23
 DEFINE l_ccc23f,l_ccc23g,l_ccc23h  LIKE ccc_file.ccc23   #FUN-7C0028 add
 DEFINE l_errmsg                    LIKE type_file.chr1000        #No.FUN-680122CHAR(256)   #FUN-640153 add
 DEFINE l_ccg92                     LIKE ccg_file.ccg92       #No:MOD-9C0395 add
 DEFINE l_ccg32                     LIKE ccg_file.ccg32       #No:MOD-9C0395 add
 
 
 
  IF cl_null(mccg.ccg92) THEN LET mccg.ccg92 = 0 END IF   #MOD-6C0068 add
  IF cl_null(mccg.ccg32) THEN LET mccg.ccg32 = 0 END IF   #MOD-6C0068 add
 
  LET l_ccg92 = 0 
  LET l_ccg32 = 0 
  SELECT ccg32,ccg92 INTO l_ccg32,l_ccg92 FROM ccg_file
           WHERE ccg04 = g_ccc.ccc01 
             and ccg02 = g_ccc.ccc02 and ccg03 = g_ccc.ccc03
             and ccg06 = g_ccc.ccc07 and ccg07 = g_ccc.ccc08
  IF cl_null(l_ccg32) THEN LET l_ccg32 = 0 END IF  
  IF cl_null(l_ccg92) THEN LET l_ccg92 = 0 END IF  

  IF g_ccc.ccc11=0 AND g_ccc.ccc12=0 AND
     g_ccc.ccc21=0 AND g_ccc.ccc22=0 AND
     g_ccc.ccc25=0 AND g_ccc.ccc26=0 AND
     g_ccc.ccc27=0 AND g_ccc.ccc28=0 AND g_ccc.ccc23=0 AND
     g_ccc.ccc31=0 AND g_ccc.ccc32=0 AND
     g_ccc.ccc41=0 AND g_ccc.ccc42=0 AND
     g_ccc.ccc51=0 AND g_ccc.ccc52=0 AND
     g_ccc.ccc61=0 AND g_ccc.ccc62=0 AND g_ccc.ccc63=0 AND
     g_ccc.ccc71=0 AND g_ccc.ccc72=0 AND
     g_ccc.ccc81=0 AND g_ccc.ccc82=0 AND   #FUN-690068 add
     g_ccc.ccc91=0 AND g_ccc.ccc92=0
 #防止工單未入庫即結案或只有在製
     AND l_ccg92 = 0 AND l_ccg32 = 0        #No:MOD-9C0395 modify
     AND g_ccc.ccc43= 0 AND g_ccc.ccc211 = 0 #No:MOD-B10151 add
   THEN LET SQLCA.SQLCODE=0            # 若無異動量/成本則不必 Insert
   ELSE
      CALL p500_ckp_ccc() #MOD-8B0143 CHECK ccc_file做NOT NULL欄位的判斷
      UPDATE ccc_file SET ccc_file.*=g_ccc.*
          WHERE ccc01=g_ima01 AND ccc02=yy AND ccc03=mm
            AND ccc07=type    AND ccc08=g_tlfcost   #FUN-7C0028 add
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
         CALL p500_ckp_ccc() #MOD-4A0263 CHECK ccc_file做NOT NULL欄位的判斷
         LET g_ccc.cccoriu = g_user      #No.FUN-980030 10/01/04
         LET g_ccc.cccorig = g_grup      #No.FUN-980030 10/01/04
         LET g_ccc.ccclegal = g_legal    #FUN-A50075
         INSERT INTO ccc_file VALUES (g_ccc.*)
      END IF
  END IF
  IF SQLCA.SQLCODE THEN
     LET l_errmsg = ''
     LET l_errmsg = g_ima01,'ins ccc_file :'
      CALL cl_err3("ins","ccc_file",g_ccc.ccc01,g_ccc.ccc02,SQLCA.SQLCODE,"","",1)   #No.FUN-660127
     LET g_success='N'
  END IF
END FUNCTION
 
FUNCTION p500_ccc_upd() # UPDATE ccc_file
  DEFINE l_errmsg   LIKE type_file.chr1000        #MOD-880198 add
 
  CALL p500_ckp_ccc() #MOD-8B0143 CHECK ccc_file做NOT NULL欄位的判斷
  UPDATE ccc_file SET * = g_ccc.*
        WHERE ccc01 = g_ima01 AND ccc02 = yy AND ccc03 = mm
          AND ccc07 = type    AND ccc08 = g_tlfcost   #FUN-7C0028 add
  IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
     CALL p500_ckp_ccc() #MOD-4A0263 CHECK ccc_file做NOT NULL欄位的判斷
     IF g_ccc.ccc11=0 AND g_ccc.ccc12=0 AND
        g_ccc.ccc21=0 AND g_ccc.ccc22=0 AND
        g_ccc.ccc25=0 AND g_ccc.ccc26=0 AND
        g_ccc.ccc27=0 AND g_ccc.ccc28=0 AND g_ccc.ccc23=0 AND
        g_ccc.ccc31=0 AND g_ccc.ccc32=0 AND
        g_ccc.ccc41=0 AND g_ccc.ccc42=0 AND
        g_ccc.ccc51=0 AND g_ccc.ccc52=0 AND
        g_ccc.ccc61=0 AND g_ccc.ccc62=0 AND g_ccc.ccc63=0 AND
        g_ccc.ccc71=0 AND g_ccc.ccc72=0 AND
        g_ccc.ccc81=0 AND g_ccc.ccc82=0 AND   #FUN-690068 add
        g_ccc.ccc91=0 AND g_ccc.ccc92=0
      THEN 
         LET SQLCA.SQLCODE=0            # 若無異動量/成本則不必 Insert
      ELSE
         LET g_ccc.cccoriu = g_user      #No.FUN-980030 10/01/04
         LET g_ccc.cccorig = g_grup      #No.FUN-980030 10/01/04
         LET g_ccc.ccclegal = g_legal    #FUN-A50075
         INSERT INTO ccc_file VALUES (g_ccc.*)
      END IF    #No:MOD-9C0395 add
  END IF
  IF SQLCA.SQLCODE THEN
     LET l_errmsg = ''
     LET l_errmsg = g_ima01,'ins ccc_file :'
     CALL cl_err3("ins","ccc_file",g_ccc.ccc01,g_ccc.ccc02,SQLCA.SQLCODE,"","",1)
     LET g_success='N'
  END IF
END FUNCTION
 
FUNCTION p500_mccg_0()
   LET mccg.ccg01=g_sfb.sfb01
   LET mccg.ccg02=yy
   LET mccg.ccg03=mm
   LET mccg.ccg04=g_sfb.sfb05
   LET mccg.ccg06=type        #FUN-7C0028 add
  #LET mccg.ccg07=' '         #MOD-C60140 mark
   LET mccg.ccg07=g_tlfcost   #MOD-C60140 add
   LET mccg.ccg11=0
   LET mccg.ccg12=0  LET mccg.ccg12a=0 LET mccg.ccg12b=0
   LET mccg.ccg12c=0 LET mccg.ccg12d=0 LET mccg.ccg12e=0
   LET mccg.ccg12f=0 LET mccg.ccg12g=0 LET mccg.ccg12h=0   #FUN-7C0028 add
   LET mccg.ccg20=0
   LET mccg.ccg21=0
   LET mccg.ccg22=0  LET mccg.ccg22a=0 LET mccg.ccg22b=0
   LET mccg.ccg22c=0 LET mccg.ccg22d=0 LET mccg.ccg22e=0
   LET mccg.ccg22f=0 LET mccg.ccg22g=0 LET mccg.ccg22h=0   #FUN-7C0028 add
   LET mccg.ccg23=0  LET mccg.ccg23a=0 LET mccg.ccg23b=0
   LET mccg.ccg23c=0 LET mccg.ccg23d=0 LET mccg.ccg23e=0
   LET mccg.ccg23f=0 LET mccg.ccg23g=0 LET mccg.ccg23h=0   #FUN-7C0028 add
   LET mccg.ccg31=0
   LET mccg.ccg32=0  LET mccg.ccg32a=0 LET mccg.ccg32b=0
   LET mccg.ccg32c=0 LET mccg.ccg32d=0 LET mccg.ccg32e=0
   LET mccg.ccg32f=0 LET mccg.ccg32g=0 LET mccg.ccg32h=0   #FUN-7C0028 add
   LET mccg.ccg41=0
   LET mccg.ccg42=0  LET mccg.ccg42a=0 LET mccg.ccg42b=0
   LET mccg.ccg42c=0 LET mccg.ccg42d=0 LET mccg.ccg42e=0
   LET mccg.ccg42f=0 LET mccg.ccg42g=0 LET mccg.ccg42h=0   #FUN-7C0028 add
 
  #盤點盈虧
 
   LET mccg.ccg91=0
   LET mccg.ccg311=0   #FUN-CC0002
   LET mccg.ccg92=0  LET mccg.ccg92a=0 LET mccg.ccg92b=0
   LET mccg.ccg92c=0 LET mccg.ccg92d=0 LET mccg.ccg92e=0
   LET mccg.ccg92f=0 LET mccg.ccg92g=0 LET mccg.ccg92h=0   #FUN-7C0028 add
   LET t_time = TIME
   LET mccg.ccguser=g_user LET mccg.ccgdate=TODAY LET mccg.ccgtime=t_time
END FUNCTION
 
FUNCTION p500_cch_0()           # 依上月期末轉本月期初, 其餘歸零
   LET g_cch.cch02=  yy
   LET g_cch.cch03=  mm
   LET g_cch.cch11=  g_cch.cch91
   LET g_cch.cch12=  g_cch.cch92
   LET g_cch.cch12a= g_cch.cch92a
   LET g_cch.cch12b= g_cch.cch92b
   LET g_cch.cch12c= g_cch.cch92c
   LET g_cch.cch12d= g_cch.cch92d
   LET g_cch.cch12e= g_cch.cch92e
   LET g_cch.cch12f= g_cch.cch92f   #FUN-7C0028 add
   LET g_cch.cch12g= g_cch.cch92g   #FUN-7C0028 add
   LET g_cch.cch12h= g_cch.cch92h   #FUN-7C0028 add
   LET g_cch.cch21=0
   LET g_cch.cch22=0  LET g_cch.cch22a=0 LET g_cch.cch22b=0
   LET g_cch.cch22c=0 LET g_cch.cch22d=0 LET g_cch.cch22e=0
   LET g_cch.cch22f=0 LET g_cch.cch22g=0 LET g_cch.cch22h=0   #FUN-7C0028 add
   LET g_cch.cch31=0
   LET g_cch.cch311=0   #FUN-660197 add
   LET g_cch.cch32=0  LET g_cch.cch32a=0 LET g_cch.cch32b=0
   LET g_cch.cch32c=0 LET g_cch.cch32d=0 LET g_cch.cch32e=0
   LET g_cch.cch32f=0 LET g_cch.cch32g=0 LET g_cch.cch32h=0   #FUN-7C0028 add
   LET g_cch.cch41=0
   LET g_cch.cch42=0  LET g_cch.cch42a=0 LET g_cch.cch42b=0
   LET g_cch.cch42c=0 LET g_cch.cch42d=0 LET g_cch.cch42e=0
   LET g_cch.cch42f=0 LET g_cch.cch42g=0 LET g_cch.cch42h=0   #FUN-7C0028 add
   LET g_cch.cch91=0
   LET g_cch.cch92=0  LET g_cch.cch92a=0 LET g_cch.cch92b=0
   LET g_cch.cch92c=0 LET g_cch.cch92d=0 LET g_cch.cch92e=0
   LET g_cch.cch92f=0 LET g_cch.cch92g=0 LET g_cch.cch92h=0   #FUN-7C0028 add
   #-->累計投入
   LET g_cch.cch51 = g_cch.cch51
   LET g_cch.cch52 = g_cch.cch52  
   LET g_cch.cch52a= g_cch.cch52a
   LET g_cch.cch52b= g_cch.cch52b 
   LET g_cch.cch52c= g_cch.cch52c
   LET g_cch.cch52d= g_cch.cch52d 
   LET g_cch.cch52e= g_cch.cch52e
   LET g_cch.cch52f= g_cch.cch52f   #FUN-7C0028 add
   LET g_cch.cch52g= g_cch.cch52g   #FUN-7C0028 add
   LET g_cch.cch52h= g_cch.cch52h   #FUN-7C0028 add
   IF cl_null(g_cch.cch51)  THEN LET g_cch.cch51  = 0 END IF
   IF cl_null(g_cch.cch52)  THEN LET g_cch.cch52  = 0 END IF
   IF cl_null(g_cch.cch52a) THEN LET g_cch.cch52a = 0 END IF
   IF cl_null(g_cch.cch52b) THEN LET g_cch.cch52b = 0 END IF
   IF cl_null(g_cch.cch52c) THEN LET g_cch.cch52c = 0 END IF
   IF cl_null(g_cch.cch52d) THEN LET g_cch.cch52d = 0 END IF
   IF cl_null(g_cch.cch52e) THEN LET g_cch.cch52e = 0 END IF
   IF cl_null(g_cch.cch52f) THEN LET g_cch.cch52f = 0 END IF   #FUN-7C0028 add
   IF cl_null(g_cch.cch52g) THEN LET g_cch.cch52g = 0 END IF   #FUN-7C0028 add
   IF cl_null(g_cch.cch52h) THEN LET g_cch.cch52h = 0 END IF   #FUN-7C0028 add
   #-->累計轉出
   LET g_cch.cch53 = g_cch.cch53
   LET g_cch.cch54 = g_cch.cch54  
   LET g_cch.cch54a= g_cch.cch54a
   LET g_cch.cch54b= g_cch.cch54b 
   LET g_cch.cch54c= g_cch.cch54c
   LET g_cch.cch54d= g_cch.cch54d 
   LET g_cch.cch54e= g_cch.cch54e
   LET g_cch.cch54f= g_cch.cch54f   #FUN-7C0028 add
   LET g_cch.cch54g= g_cch.cch54g   #FUN-7C0028 add
   LET g_cch.cch54h= g_cch.cch54h   #FUN-7C0028 add
   IF cl_null(g_cch.cch53)  THEN LET g_cch.cch53  = 0 END IF
   IF cl_null(g_cch.cch54)  THEN LET g_cch.cch54  = 0 END IF
   IF cl_null(g_cch.cch54a) THEN LET g_cch.cch54a = 0 END IF
   IF cl_null(g_cch.cch54b) THEN LET g_cch.cch54b = 0 END IF
   IF cl_null(g_cch.cch54c) THEN LET g_cch.cch54c = 0 END IF
   IF cl_null(g_cch.cch54d) THEN LET g_cch.cch54d = 0 END IF
   IF cl_null(g_cch.cch54e) THEN LET g_cch.cch54e = 0 END IF
   IF cl_null(g_cch.cch54f) THEN LET g_cch.cch54f = 0 END IF   #FUN-7C0028 add
   IF cl_null(g_cch.cch54g) THEN LET g_cch.cch54g = 0 END IF   #FUN-7C0028 add
   IF cl_null(g_cch.cch54h) THEN LET g_cch.cch54h = 0 END IF   #FUN-7C0028 add
   #-->累計超領退
   LET g_cch.cch55 = g_cch.cch55
   LET g_cch.cch56 = g_cch.cch56  
   LET g_cch.cch56a= g_cch.cch56a
   LET g_cch.cch56b= g_cch.cch56b
   LET g_cch.cch56c= g_cch.cch56c
   LET g_cch.cch56d= g_cch.cch56d
   LET g_cch.cch56e= g_cch.cch56e
   LET g_cch.cch56f= g_cch.cch56f   #FUN-7C0028 add
   LET g_cch.cch56g= g_cch.cch56g   #FUN-7C0028 add
   LET g_cch.cch56h= g_cch.cch56h   #FUN-7C0028 add
   IF cl_null(g_cch.cch55)  THEN LET g_cch.cch55  = 0 END IF
   IF cl_null(g_cch.cch56)  THEN LET g_cch.cch56  = 0 END IF
   IF cl_null(g_cch.cch56a) THEN LET g_cch.cch56a = 0 END IF
   IF cl_null(g_cch.cch56b) THEN LET g_cch.cch54b = 0 END IF
   IF cl_null(g_cch.cch56c) THEN LET g_cch.cch56c = 0 END IF
   IF cl_null(g_cch.cch56d) THEN LET g_cch.cch56d = 0 END IF
   IF cl_null(g_cch.cch56e) THEN LET g_cch.cch56e = 0 END IF
   IF cl_null(g_cch.cch56f) THEN LET g_cch.cch56f = 0 END IF   #FUN-7C0028 add
   IF cl_null(g_cch.cch56g) THEN LET g_cch.cch56g = 0 END IF   #FUN-7C0028 add
   IF cl_null(g_cch.cch56h) THEN LET g_cch.cch56h = 0 END IF   #FUN-7C0028 add
   LET g_cch.cch57= 0
   LET g_cch.cch58=0  LET g_cch.cch58a=0 LET g_cch.cch58b=0
   LET g_cch.cch58c=0 LET g_cch.cch58d=0 LET g_cch.cch58e=0
   LET g_cch.cch58f=0 LET g_cch.cch58g=0 LET g_cch.cch58h=0   #FUN-7C0028 add
   LET g_cch.cch59=0
   LET g_cch.cch60=0  LET g_cch.cch60a=0 LET g_cch.cch60b=0
   LET g_cch.cch60c=0 LET g_cch.cch60d=0 LET g_cch.cch60e=0
   LET g_cch.cch60f=0 LET g_cch.cch60g=0 LET g_cch.cch60h=0   #FUN-7C0028 add
END FUNCTION
 
FUNCTION p500_cch_01()          # 全部歸零
   LET g_cch.cch02 =yy
   LET g_cch.cch03 =mm
   LET g_cch.cch11 =0
   LET g_cch.cch12 =0 LET g_cch.cch12a=0 LET g_cch.cch12b=0
   LET g_cch.cch12c=0 LET g_cch.cch12d=0 LET g_cch.cch12e=0
   LET g_cch.cch12f=0 LET g_cch.cch12g=0 LET g_cch.cch12h=0   #FUN-7C0028 add
   LET g_cch.cch21 =0
   LET g_cch.cch22 =0 LET g_cch.cch22a=0 LET g_cch.cch22b=0
   LET g_cch.cch22c=0 LET g_cch.cch22d=0 LET g_cch.cch22e=0
   LET g_cch.cch22f=0 LET g_cch.cch22g=0 LET g_cch.cch22h=0   #FUN-7C0028 add
   LET g_cch.cch31 =0
   LET g_cch.cch311=0      #FUN-660197 add
   LET g_cch.cch32 =0 LET g_cch.cch32a=0 LET g_cch.cch32b=0
   LET g_cch.cch32c=0 LET g_cch.cch32d=0 LET g_cch.cch32e=0
   LET g_cch.cch32f=0 LET g_cch.cch32g=0 LET g_cch.cch32h=0   #FUN-7C0028 add
   LET g_cch.cch41 =0
   LET g_cch.cch42 =0 LET g_cch.cch42a=0 LET g_cch.cch42b=0
   LET g_cch.cch42c=0 LET g_cch.cch42d=0 LET g_cch.cch42e=0
   LET g_cch.cch42f=0 LET g_cch.cch42g=0 LET g_cch.cch42h=0   #FUN-7C0028 add
   LET g_cch.cch51 =0
   LET g_cch.cch52 =0 LET g_cch.cch52a=0 LET g_cch.cch52b=0
   LET g_cch.cch52c=0 LET g_cch.cch52d=0 LET g_cch.cch52e=0
   LET g_cch.cch52f=0 LET g_cch.cch52g=0 LET g_cch.cch52h=0   #FUN-7C0028 add
   LET g_cch.cch53 =0
   LET g_cch.cch54 =0 LET g_cch.cch54a=0 LET g_cch.cch54b=0
   LET g_cch.cch54c=0 LET g_cch.cch54d=0 LET g_cch.cch54e=0
   LET g_cch.cch54f=0 LET g_cch.cch54g=0 LET g_cch.cch54h=0   #FUN-7C0028 add
   LET g_cch.cch55 =0
   LET g_cch.cch56 =0 LET g_cch.cch56a=0 LET g_cch.cch56b=0
   LET g_cch.cch56c=0 LET g_cch.cch56d=0 LET g_cch.cch56e=0
   LET g_cch.cch56f=0 LET g_cch.cch56g=0 LET g_cch.cch56h=0   #FUN-7C0028 add
   LET g_cch.cch57 =0
   LET g_cch.cch58 =0 LET g_cch.cch58a=0 LET g_cch.cch58b=0
   LET g_cch.cch58c=0 LET g_cch.cch58d=0 LET g_cch.cch58e=0
   LET g_cch.cch58f=0 LET g_cch.cch58g=0 LET g_cch.cch58h=0   #FUN-7C0028 add
   LET g_cch.cch59 =0
   LET g_cch.cch60 =0 LET g_cch.cch60a=0 LET g_cch.cch60b=0
   LET g_cch.cch60c=0 LET g_cch.cch60d=0 LET g_cch.cch60e=0
   LET g_cch.cch60f=0 LET g_cch.cch60g=0 LET g_cch.cch60h=0   #FUN-7C0028 add
   LET g_cch.cch91 =0
   LET g_cch.cch92 =0 LET g_cch.cch92a=0 LET g_cch.cch92b=0
   LET g_cch.cch92c=0 LET g_cch.cch92d=0 LET g_cch.cch92e=0
   LET g_cch.cch92f=0 LET g_cch.cch92g=0 LET g_cch.cch92h=0   #FUN-7C0028 add
END FUNCTION
 
FUNCTION wip_del()
   DEFINE wo_no         LIKE ccg_file.ccg01         #No.FUN-680122CHAR(16)      #No.FUN-550025
 
   DECLARE p110_wip_del_c1 CURSOR FOR
       SELECT ccg01 FROM ccg_file
        WHERE ccg04=g_ima01 AND ccg02=yy AND ccg03=mm
          AND ccg06=type
          AND ccg07=g_tlfcost   #MOD-C60140 add
   FOREACH p110_wip_del_c1 INTO wo_no
     IF SQLCA.sqlcode THEN
       CALL cl_err('p110_wip_del_c1',SQLCA.sqlcode,0)   
        EXIT FOREACH
     END IF
     DELETE FROM cch_file WHERE cch01=wo_no AND cch02=yy AND cch03=mm
                            AND cch06=type
     DELETE FROM ccg_file WHERE ccg01=wo_no AND ccg02=yy AND ccg03=mm
                            AND ccg06=type 
     DELETE FROM cce_file WHERE cce01=wo_no AND cce02=yy AND cce03=mm
                            AND cce04=g_ima01 #MOD-620064
                            AND cce06=type
   END FOREACH
   CLOSE p110_wip_del_c1
END FUNCTION
 
FUNCTION wip_del2()
   DEFINE wo_no         LIKE ccg_file.ccg01         #No.FUN-680122CHAR(16)   #FUN-660197 VARCHAR(10)->CHAR(16)
   DECLARE p110_wip_del_c2 CURSOR FOR
       SELECT ccg01 FROM ccg_file, sfb_file
             WHERE ccg04=g_ima01 AND ccg02=yy AND ccg03=mm
               AND ccg06=type  
               AND ccg07=g_tlfcost   #MOD-C60140 add
               AND ccg01=sfb01   AND sfb02 != '13'
               AND sfb02!='11'   AND sfb99='Y'
   FOREACH p110_wip_del_c2 INTO wo_no
     IF SQLCA.sqlcode THEN
       CALL cl_err('p110_wip_del_c2',SQLCA.sqlcode,0)   
        EXIT FOREACH
     END IF
     DELETE FROM cch_file WHERE cch01=wo_no AND cch02=yy AND cch03=mm
                            AND cch06=type 
     DELETE FROM ccg_file WHERE ccg01=wo_no AND ccg02=yy AND ccg03=mm
                            AND ccg06=type
   END FOREACH
   CLOSE p110_wip_del_c2
END FUNCTION
 
FUNCTION p500_wip()     # 處理 WIP 在製成本 (工單性質=1/7)
   DEFINE l_sql STRING   #FUN-7C0028 add
   DEFINE l_imd09   LIKE imd_file.imd09   #MOD-C60140 add
 
   IF g_bgjob = 'N' THEN  #NO.FUN-570135 
      MESSAGE '_wip ...'
      CALL ui.Interface.refresh()
   END IF
 
   CALL wip_del()       # 先 delete ccg_file, cch_file 該主件相關資料
 
   LET l_sql="SELECT * FROM sfb_file",
             " WHERE sfb05 ='",g_ima01,"'",
             "   AND sfb02!= '13' AND sfb02 != '11'",
             "   AND (sfb99 IS NULL OR sfb99 = ' ' OR sfb99='N')",
             "   AND (sfb38 IS NULL OR sfb38 >='",g_bdate,"')",  # 工單成會結案日
             "   AND (sfb81 IS NULL OR sfb81 <='",g_edate,"')",   # 工單xx立日期
             "   AND sfb87 = 'Y' "                                #MOD-C80036
   LET l_sql=l_sql," ORDER BY sfb01"
   DECLARE wip_c1 CURSOR FROM l_sql
 
   FOREACH wip_c1 INTO g_sfb.*
     IF SQLCA.sqlcode THEN
       CALL cl_err('wip_c1',SQLCA.sqlcode,0)   
        EXIT FOREACH
     END IF
    #MOD-C60140 -- add start --
    #wip_c1會抓到該料的所有工單，但可能成本庫別不一樣，計算分倉成本時遇不同成本庫別要return，避免多算
#    IF type = '5' THEN
#       IF cl_null(g_sfb.sfb30) THEN
#          CONTINUE FOREACH
#       ELSE
#          SELECT imd09 INTO l_imd09 FROM imd_file
#           WHERE imd01 = g_sfb.sfb30
#          IF l_imd09 <> g_tlfcost THEN
#             CONTINUE FOREACH
#          END IF
#       END IF
#    END IF
    #MOD-C60140 -- add end --
     IF sw = 'Y' THEN
         IF g_bgjob = 'N' THEN  #NO.FUN-570135 
             MESSAGE 'wo:',g_sfb.sfb01," #1"
             CALL ui.Interface.refresh()
         END IF
     END IF
     CALL wip_1()       # 計算每張工單的 WIP-主件 部份 成本 (ccg)
     IF sw = 'Y' THEN
         IF g_bgjob = 'N' THEN  #NO.FUN-570135 
             MESSAGE 'wo:',g_sfb.sfb01," #2"
             CALL ui.Interface.refresh()
         END IF
     END IF
     CALL wip_2()       # 計算每張工單的 WIP-元件 投入 成本 (cch)
     IF sw = 'Y' THEN
         IF g_bgjob = 'N' THEN  #NO.FUN-570135 
             MESSAGE 'wo:',g_sfb.sfb01," #3"
             CALL ui.Interface.refresh()
         END IF
     END IF
     CALL wip_3()       # 計算每張工單的 WIP-元件 轉出 成本 (cch)
     IF sw = 'Y' THEN
         IF g_bgjob = 'N' THEN  #NO.FUN-570135 
             MESSAGE 'wo:',g_sfb.sfb01," #4"
             CALL ui.Interface.refresh()
         END IF
     END IF
     CALL wip_4()       # 計算每張工單的 WIP-主件 SUM  成本 (ccg)
   END FOREACH
   CLOSE wip_c1
END FUNCTION
 
FUNCTION p500_wip2()     # 計算產品在製成本(料,工,費)投入,轉出
   IF g_bgjob = 'N' THEN  #NO.FUN-570135 
       MESSAGE '_wip ...'
       CALL ui.Interface.refresh()
   END IF 
 
   #刪除當月產品WIP
   DELETE FROM cch_file WHERE cch01=g_ima01 AND cch02=yy AND cch03=mm
                          AND cch06=type
   DELETE FROM ccg_file WHERE ccg01=g_ima01 AND ccg02=yy AND ccg03=mm
                          AND ccg06=type
   DELETE FROM cce_file WHERE cce01=g_ima01 AND cce02=yy AND cce03=mm
                          AND cce04=g_ima01 #MOD-620064
                          AND cce06=type
 
   IF sw = 'Y' THEN
       IF g_bgjob = 'N' THEN  #NO.FUN-570135 
           MESSAGE 'Product No:',g_ima01," #1"
           CALL ui.Interface.refresh()
       END IF
   END IF
   CALL wip2_1()       # 計算產品WIP主件  ccg
   IF sw = 'Y' THEN
       IF g_bgjob = 'N' THEN  #NO.FUN-570135 
           MESSAGE 'Product No:',g_ima01," #2"
           CALL ui.Interface.refresh()
       END IF
   END IF
   CALL wip2_2()       # 計算產品WIP元件 投入 cch
   IF sw = 'Y' THEN
       IF g_bgjob = 'N' THEN  #NO.FUN-570135 
           MESSAGE 'Product No:',g_ima01," #3"
           CALL ui.Interface.refresh()
       END IF
   END IF
   CALL wip2_3()       # 計算產品WIP元件 轉出/期末 cch
   IF sw = 'Y' THEN
       IF g_bgjob = 'N' THEN  #NO.FUN-570135 
           MESSAGE 'Product No:',g_ima01," #4"
           CALL ui.Interface.refresh()
       END IF
   END IF
   CALL wip2_4()       # 計算產品WIP主件 SUM cch  (ccg)
END FUNCTION
 
FUNCTION p500_wip_rework()      # 處理 WIP-Rework 在製成本 (重工sfb99='Y')
   DEFINE l_sql STRING   #FUN-7C0028 add
   DEFINE l_imd09   LIKE imd_file.imd09   #MOD-C60140 add
 
   IF g_bgjob = 'N' THEN  #NO.FUN-570135 
       MESSAGE '_wip_rework ...'
       CALL ui.Interface.refresh()
   END IF
   CALL wip_del2()      # 先 delete ccg_file, cch_file 該主件相關資料
   LET l_sql="SELECT * FROM sfb_file",
             " WHERE sfb05 ='",g_ima01,"'",
             "   AND sfb99 = 'Y'",
             "   AND sfb02 != '13' AND sfb02 != '11'",
             "   AND (sfb38 IS NULL OR sfb38 >='",g_bdate,"')",  # 工單成會結案日
             "   AND (sfb81 IS NULL OR sfb81 <='",g_edate,"')",   # 工單xx立日期
             "   AND sfb87 = 'Y' "                                #MOD-C80036
   LET l_sql=l_sql," ORDER BY sfb01"
   DECLARE p500_r_wip_c1 CURSOR FROM l_sql
 
   FOREACH p500_r_wip_c1 INTO g_sfb.*
    #MOD-C60140 -- add start --
    #wip_c1會抓到該料的所有工單，但可能成本庫別不一樣，計算分倉成本時遇不同成本庫別要return，避免多算
     IF type = '5' THEN
        IF cl_null(g_sfb.sfb30) THEN
           CONTINUE FOREACH
        ELSE
           SELECT imd09 INTO l_imd09 FROM imd_file
            WHERE imd01 = g_sfb.sfb30
           IF l_imd09 <> g_tlfcost THEN
              CONTINUE FOREACH
           END IF
        END IF
     END IF
    #MOD-C60140 -- add end --
     CALL wip_1()       # 計算每張工單的 WIP-主件 部份 成本 (ccg)
     CALL wip_2()       # 計算每張工單的 WIP-元件 投入 成本 (cch)
     CALL wip_3()       # 計算每張工單的 WIP-元件 轉出 成本 (cch)
     CALL wip_4()       # 計算每張工單的 WIP-主件 SUM  成本 (ccg)
   END FOREACH
   CLOSE p500_r_wip_c1
END FUNCTION
 
FUNCTION wip_1()        # 計算每張工單的 WIP-主件 部份 成本 (ccg)
   CALL p500_mccg_0()   # 將 mccg 歸 0
   LET mccg.ccg01 =g_sfb.sfb01
   LET mccg.ccg02 =yy
   LET mccg.ccg03 =mm
   LET mccg.ccg04 =g_sfb.sfb05
   LET mccg.ccg06 =type        #FUN-7C0028 add
  #LET mccg.ccg07 =' '	#TQC-970003   #MOD-C60140 mark
   LET mccg.ccg07 =g_tlfcost          #MOD-C60140 add
  #LET mccg.ccgplant=g_plant  #FUN-980009 add    #FUN-A50075
   LET mccg.ccglegal=g_legal  #FUN-980009 add
 
   SELECT ccg91 INTO mccg.ccg11 FROM ccg_file   # WIP 主件 上期期末轉本期期初
      WHERE ccg01=g_sfb.sfb01 AND ccg02=last_yy AND ccg03=last_mm
        AND ccg06=type
        AND ccg07=g_tlfcost   #MOD-C60140 add
   SELECT ccf11 INTO mccg.ccg11 FROM ccf_file   # WIP 主件 上期期末轉本期期初
      WHERE ccf01=g_sfb.sfb01 AND ccf02=last_yy AND ccf03=last_mm
        AND ccf06=type    
        AND ccf04 = ' DL+OH+SUB'           #MOD-6C0146
   CALL wip_ccg20()     # 工時統計
   CALL wip_ccg31()     # 計算每張工單的 WIP-主件 轉出數量
   LET mccg.ccgoriu = g_user      #No.FUN-980030 10/01/04
   LET mccg.ccgorig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO ccg_file VALUES (mccg.*)
   IF STATUS THEN 
    CALL cl_err3("ins","ccg_file",mccg.ccg01,mccg.ccg02,STATUS,"","ins ccg:",1)   #No.FUN-660127
   RETURN END IF
END FUNCTION
 
FUNCTION wip2_1()        # 計算產品WIP主件  (ccg)
   CALL p500_mccg_0()   # 將 mccg 歸 0
   LET mccg.ccg01 =g_ima01
   LET mccg.ccg02 =yy
   LET mccg.ccg03 =mm
   LET mccg.ccg04 =g_ima01
   LET mccg.ccg06 =type        #FUN-7C0028 add
  #LET mccg.ccg07 =' '         #MOD-C60140 mark
   LET mccg.ccg07 =g_tlfcost   #MOD-C60140 add
 
   LET mccg.ccg11 =0    #期初數量
   SELECT SUM(srl05) INTO mccg.ccg20 FROM srk_file,srl_file   #工時統計
    WHERE srl04 = g_ima01 AND srk01 BETWEEN g_bdate AND g_edate
      AND srk01 = srl01 AND srk02 = srl02
      AND srkfirm <> 'X'  #CHI-C80041
   IF cl_null(mccg.ccg20) THEN LET mccg.ccg20=0 END IF
   LET mccg.ccg31 =0    #轉出數量
  #LET mccg.ccgplant = g_plant #FUN-980009 add    #FUN-A50075
   LET mccg.ccglegal = g_legal #FUN-980009 add
   LET mccg.ccgoriu = g_user      #No.FUN-980030 10/01/04
   LET mccg.ccgorig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO ccg_file VALUES (mccg.*)
   IF STATUS THEN 
    CALL cl_err3("ins","ccg_file",mccg.ccg01,mccg.ccg02,STATUS,"","ins ccg:",1)   #No.FUN-660127
   RETURN END IF
END FUNCTION
 
FUNCTION wip_ccg20()    # 工時統計
   SELECT SUM(ccj05) INTO mccg.ccg20 FROM ccj_file,cci_file  # 工時統計No:9768
      WHERE ccj04=g_sfb.sfb01 AND ccj01 BETWEEN g_bdate AND g_edate
        AND cci01 = ccj01 AND cci02 = ccj02 AND ccifirm = 'Y'     #No:9768
   IF mccg.ccg20 IS NULL THEN LET mccg.ccg20=0 END IF
END FUNCTION
 
FUNCTION wip_ccg31()    # 計算每張工單的 WIP-主件 轉出數量
   #No.130530001 ---begin---
   DEFINE l_sql31    STRING
   DEFINE l_make_qty_1    LIKE tlf_file.tlf10
   DEFINE l_make_qty_2    LIKE tlf_file.tlf10
   DEFINE l_make_qty2_1   LIKE tlf_file.tlf10
   DEFINE l_make_qty2_2   LIKE tlf_file.tlf10
   DEFINE l_make_qty3_1   LIKE tlf_file.tlf10
   DEFINE l_make_qty3_2   LIKE tlf_file.tlf10
   
   LET l_make_qty_1 = 0 
   LET l_make_qty_2 = 0 
   LET l_make_qty2_1 = 0 
   LET l_make_qty2_2 = 0 
   LET l_make_qty3_1 = 0 
   LET l_make_qty3_2 = 0 
   #No.130530001 ---end---

   #SELECT SUM(tlf10*tlf60) INTO g_make_qty FROM tlf_file      # 當月成品入庫量
   SELECT SUM(tlf10*tlf60) INTO l_make_qty_1 FROM tlf_file      #No.130530001
             WHERE tlf62=g_sfb.sfb01 AND tlf06 BETWEEN g_bdate AND g_edate
               AND (tlf03 = 50)
               AND tlf13 MATCHES 'asft6*'
               #排除非成本庫的資料
               #AND tlf902 NOT IN(SELECT jce02 FROM jce_file)   #MOD-6C0146 add #CHI-C80002
               AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = tlf902)  #CHI-C80002
               AND (tlf01 = g_sfb.sfb05)   #No.130530001
   #No.130530001 ---begin---
   SELECT SUM(tlf10*tlf60) INTO l_make_qty_2 FROM tlf_file
             WHERE tlf62=g_sfb.sfb01 AND tlf06 BETWEEN g_bdate AND g_edate
               AND (tlf03 = 50)
               AND tlf13 MATCHES 'asft6*'
               #排除非成本庫的資料
               #AND tlf902 NOT IN(SELECT jce02 FROM jce_file)   #MOD-6C0146 add
               AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = tlf902)  #CHI-C80002
               AND  tlf01 <> g_sfb.sfb05
   IF cl_null(l_make_qty_1) THEN LET l_make_qty_1 = 0 END IF 
   IF cl_null(l_make_qty_2) THEN LET l_make_qty_2 = 0 END IF 
   LET g_make_qty = l_make_qty_1 + l_make_qty_2
   #No.130530001 ---end---               
   IF g_make_qty IS NULL THEN LET g_make_qty=0 END IF
   #SELECT SUM(tlf10*tlf60) INTO g_make_qty2 FROM tlf_file     # 當月成品退庫量
   SELECT SUM(tlf10*tlf60) INTO l_make_qty2_1 FROM tlf_file   #No.130530001
             WHERE tlf62=g_sfb.sfb01 AND tlf06 BETWEEN g_bdate AND g_edate
               AND (tlf02 = 50)
               AND tlf13 MATCHES 'asft6*'
               #排除非成本庫的資料
               #AND tlf902 NOT IN(SELECT jce02 FROM jce_file)   #MOD-6C0146 add #CHI-C80002
               AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = tlf902)  #CHI-C80002
               AND (tlf01 = g_sfb.sfb05)
   #No.130530001 ---begin---
    SELECT SUM(tlf10*tlf60) INTO l_make_qty2_2 FROM tlf_file
             WHERE tlf62=g_sfb.sfb01 AND tlf06 BETWEEN g_bdate AND g_edate
               AND (tlf02 = 50)
               AND tlf13 MATCHES 'asft6*'
               #排除非成本庫的資料
               #AND tlf902 NOT IN(SELECT jce02 FROM jce_file)   #MOD-6C0146 add
               AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = tlf902)  #CHI-C80002
               AND  tlf01 <> g_sfb.sfb05
   IF cl_null(l_make_qty2_1) THEN LET l_make_qty2_1 = 0 END IF 
   IF cl_null(l_make_qty2_2) THEN LET l_make_qty2_2 = 0 END IF 
   LET g_make_qty2 = l_make_qty2_1 + l_make_qty2_2
   #No.130530001 ---end---               
   IF g_make_qty2 IS NULL THEN LET g_make_qty2=0 END IF

#FUN-D20078---mark---start---
#  #TQC-C60173(S) 委外仓退
#  LET g_make_qty3=0
#  SELECT SUM(tlf10*tlf60) INTO g_make_qty3 FROM tlf_file,rvu_file   
#   WHERE tlf62=g_sfb.sfb01 AND tlf06 BETWEEN g_bdate AND g_edate
#     AND tlf02 = 50
#     AND tlf13 ='apmt1072'
#     AND tlf905 = rvu01    
#     AND rvu08 = 'SUB'
#     AND rvu00 = '3'
#     #AND tlf902 NOT IN(SELECT jce02 FROM jce_file)   #MOD-6C0146 add #CHI-C80002
#     AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = tlf902) #CHI-C80002
#     AND tlf01 = g_sfb.sfb05
#  IF g_make_qty3 IS NULL THEN LET g_make_qty3=0 END IF
#  LET g_make_qty2 = g_make_qty2+g_make_qty3
#  #TQC-C60173(E)
#FUN-D20078---mark---end---

#No.130530001 ---begin---
#如果有此段逻辑就加上,如果存在FUN-D20078的调整，则忽视下面的调整
   #TQC-C60173(S) 委外仓退
#   LET g_make_qty3=0
#   #SELECT SUM(tlf10*tlf60) INTO g_make_qty3 FROM tlf_file,rvu_file
#   SELECT SUM(tlf10*tlf60) INTO l_make_qty3_1 FROM tlf_file,rvu_file  #No.130530001
#    WHERE tlf62=g_sfb.sfb01 AND tlf06 BETWEEN g_bdate AND g_edate
#      AND tlf02 = 50
#      AND tlf13 ='apmt1072'
#      AND tlf905 = rvu01
#      AND rvu08 = 'SUB'
#      AND rvu00 = '3'
#      #AND tlf902 NOT IN(SELECT jce02 FROM jce_file) 
#      AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = tlf902) #CHI-C80002 
#      AND tlf01 = g_sfb.sfb05
#   #No.130530001 ---begin---
#   SELECT SUM(tlf10*tlf60) INTO l_make_qty3_2 FROM tlf_file,rvu_file
#    WHERE tlf62=g_sfb.sfb01 AND tlf06 BETWEEN g_bdate AND g_edate
#      AND tlf02 = 50
#      AND tlf13 ='apmt1072'
#      AND tlf905 = rvu01
#      AND rvu08 = 'SUB'
#      AND rvu00 = '3'
#      #AND tlf902 NOT IN(SELECT jce02 FROM jce_file)
#      AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = tlf902) #CHI-C80002  
#      AND tlf01 <> g_sfb.sfb05
#   IF g_make_qty3 IS NULL THEN LET g_make_qty3=0 END IF
#   LET g_make_qty2 = g_make_qty2+g_make_qty3
   #No.130530001 ---end---
#No.130530001 ---end---   

   LET g_make_qty=g_make_qty2-g_make_qty        # 轉出以負數表示
   LET mccg.ccg31=g_make_qty
   #FUN-B90029(S)
   LET g_shb114=0 
   SELECT SUM(tlf10*tlf60) INTO g_shb114 FROM tlf_file      # 當月當站下線量
    WHERE tlf62=g_sfb.sfb01 
      AND tlf06 BETWEEN g_bdate AND g_edate
      AND tlf13 = 'asft700'
   IF g_shb114 IS NULL THEN LET g_shb114=0 END IF
   #FUN-B90029(E)

   #FUN-CC0002(S)
   IF g_ccz.ccz45='2' THEN 
      SELECT -1*SUM(shb112) INTO mccg.ccg311 FROM shb_file
       WHERE shb05=g_sfb.sfb01 
         AND shb03 BETWEEN g_bdate AND g_edate       
         AND shbconf='Y'
         AND shb112>0 
      IF cl_null(mccg.ccg311) THEN LET mccg.ccg311=0 END IF
   END IF
   #FUN-CC0002(E)
END FUNCTION
 
FUNCTION wip_ccg21()    # 計算每張工單的 WIP-主件 投入數量
   DEFINE qty1,qty2     LIKE tlf_file.tlf10
   DEFINE l_cn          LIKE type_file.num5
   DEFINE l_ima55_fac   LIKE ima_file.ima55_fac     #No.MOD-720031 add
   DEFINE #l_sql         LIKE type_file.chr1000
          l_sql         STRING     #No.FUN-910082
   DEFINE l_sfa08       LIKE sfa_file.sfa08
   DEFINE l_num         LIKE sfq_file.sfq03
   DEFINE l_num1        LIKE sfq_file.sfq03
   DEFINE l_num6        LIKE sfq_file.sfq03
   DEFINE l_n           DYNAMIC ARRAY OF RECORD
            k           LIKE ccg_file.ccg21  #MOD-920107 modify type_file.num5
                        END RECORD
   DEFINE i,m,n         LIKE type_file.num5
   #No.MOD-AC0300  --Begin                                                      
   DEFINE t_qty1        LIKE sfq_file.sfq03     #截止至目前为止成套发料数,作业编号为' '
   DEFINE t_qty6        LIKE sfq_file.sfq03     #截止至目前为止成套退料数,作业编号为' '
   DEFINE t_num1        LIKE sfq_file.sfq03     #截止至目前为止成套发料数,作业编号不为' '
   DEFINE t_num6        LIKE sfq_file.sfq03     #截止至目前为止成套退料数,作业编号不为' '
   DEFINE lm_qty1       LIKE sfq_file.sfq03     #截止至上期为止成套发料数,作业编号为' '
   DEFINE lm_qty6       LIKE sfq_file.sfq03     #截止至上期为止成套退料数,作业编号为' '
   DEFINE lm_num1       LIKE sfq_file.sfq03     #截止至上期为止成套发料数,作业编号不为' '
   DEFINE lm_num6       LIKE sfq_file.sfq03     #截止至上期为止成套退料数,作业编号不为' '
   DEFINE lm_edate      LIKE type_file.dat      #上期截止日期                   
   DEFINE t_n           DYNAMIC ARRAY OF RECORD                                 
                        k    LIKE ccg_file.ccg21                                
                        END RECORD                                              
   DEFINE lm_n          DYNAMIC ARRAY OF RECORD                                 
                        k    LIKE ccg_file.ccg21                                
                        END RECORD                                              
   #No.MOD-AC0300  --End       
   DEFINE l_ccg21       LIKE ccg_file.ccg21     #CHI-D10020
   DEFINE l_sfb081      LIKE sfb_file.sfb081    #CHI-D10020
   
   IF g_sfb.sfb39='2' THEN   #領料及事後扣帳系統(Pull List 與 Backflush System)
      LET mccg.ccg21=mccg.ccg31*-1
   ELSE
      IF mccg.ccg11 + mccg.ccg21 = 0 THEN LET qty1 = g_sfb.sfb08 END IF
      #No.MOD-AC0300  --Begin
      LET lm_edate = g_bdate -1

      ##把' '也當作是一個特殊的作業編號
      #SELECT SUM(sfq03) INTO qty1 FROM sfq_file, sfp_file
      # WHERE sfq02=mccg.ccg01 AND sfq01=sfp01 AND sfp06=('1','D') AND sfp04='Y'          #FUN-C70014
      #   AND (sfp03 >= g_bdate AND sfp03 <= g_edate) AND sfq04 = ' '
      #SELECT SUM(sfq03) INTO qty2 FROM sfq_file, sfp_file
      # WHERE sfq02=mccg.ccg01 AND sfq01=sfp01 AND sfp06='6' AND sfp04='Y'
      #   AND (sfp03 >= g_bdate AND sfp03 <= g_edate) AND sfq04 = ' '
      #IF qty1 IS NULL THEN LET qty1=0 END IF
      #IF qty2 IS NULL THEN LET qty2=0 END IF
      #把' '也当作是一个特殊的作业编号                                          
      #截止至目前为止的套数   
      IF g_sma.sma129 = 'Y' THEN   #FUN-D70038
#FUN-D70038---begin  remark
#CHI-D10020---begin mark       
         SELECT SUM(sfq03) INTO t_qty1 FROM sfq_file, sfp_file                     
          WHERE sfq02=mccg.ccg01 AND sfq01=sfp01 AND sfp06  IN('1','D') AND sfp04='Y'      #FUN-C70014 add sfp06 in 'D'   
            AND sfp03 <= g_edate AND sfq04 = ' '                                   
         SELECT SUM(sfq03) INTO t_qty6 FROM sfq_file, sfp_file                     
          WHERE sfq02=mccg.ccg01 AND sfq01=sfp01 AND sfp06='6' AND sfp04='Y'       
            AND sfp03 <= g_edate AND sfq04 = ' '                                   
         IF t_qty1 IS NULL THEN LET t_qty1=0 END IF                                
         IF t_qty6 IS NULL THEN LET t_qty6=0 END IF                                
                                                                                
         #截止至上期为止的套数                                                     
         SELECT SUM(sfq03) INTO lm_qty1 FROM sfq_file, sfp_file                    
          WHERE sfq02=mccg.ccg01 AND sfq01=sfp01 AND sfp06 IN('1','D') AND sfp04='Y'          #FUN-C70014 add sfp06 in 'D'
            AND sfp03 <= lm_edate AND sfq04 = ' '                                  
         SELECT SUM(sfq03) INTO lm_qty6 FROM sfq_file, sfp_file                    
          WHERE sfq02=mccg.ccg01 AND sfq01=sfp01 AND sfp06='6' AND sfp04='Y'       
            AND sfp03 <= lm_edate AND sfq04 = ' '                                  
         IF lm_qty1 IS NULL THEN LET lm_qty1=0 END IF                              
         IF lm_qty6 IS NULL THEN LET lm_qty6=0 END IF
 
         LET l_sql = "SELECT DISTINCT sfa08 FROM sfa_file",
                     " WHERE sfa01 = '",mccg.ccg01,"'"
         PREPARE sfa08_pre FROM l_sql
         DECLARE sfa08_cur CURSOR FOR sfa08_pre
         LET i = 1
         FOREACH sfa08_cur INTO l_sfa08
            IF SQLCA.sqlcode THEN
               CALL cl_err('sfa08_cur:',SQLCA.sqlcode,0)
               LET g_success = 'N'
               RETURN
            END IF
 
            #SELECT SUM(sfq03) INTO l_num1 FROM sfq_file, sfp_file
            # WHERE sfq02=mccg.ccg01 AND sfq01=sfp01 AND sfp06='1' AND sfp04='Y'
            #   AND (sfp03 >= g_bdate AND sfp03 <= g_edate) AND sfq04 = l_sfa08
            #SELECT SUM(sfq03) INTO l_num6 FROM sfq_file, sfp_file
            # WHERE sfq02=mccg.ccg01 AND sfq01=sfp01 AND sfp06='6' AND sfp04='Y'
            #   AND (sfp03 >= g_bdate AND sfp03 <= g_edate) AND sfq04 = l_sfa08
            #IF cl_null(l_num1) THEN LET l_num1 = 0 END IF
            #IF cl_null(l_num6) THEN LET l_num6 = 0 END IF
            #IF l_sfa08 = ' ' THEN
            #   LET l_num1 = 0
            #   LET l_num6 = 0
            #END IF

            SELECT SUM(sfq03) INTO t_num1 FROM sfq_file, sfp_file                  
             WHERE sfq02=mccg.ccg01 AND sfq01=sfp01 AND sfp06 IN('1','D') AND sfp04='Y'        #FUN-C70014 add sfp06 in 'D'
               AND sfp03 <= g_edate AND sfq04 = l_sfa08                            
            SELECT SUM(sfq03) INTO t_num6 FROM sfq_file, sfp_file                  
             WHERE sfq02=mccg.ccg01 AND sfq01=sfp01 AND sfp06='6' AND sfp04='Y'    
               AND sfp03 <= g_edate AND sfq04 = l_sfa08                            
            IF cl_null(t_num1) THEN LET t_num1 = 0 END IF                          
            IF cl_null(t_num6) THEN LET t_num6 = 0 END IF                          
            IF l_sfa08 = ' ' THEN                                                  
               LET t_num1 = 0                                                      
               LET t_num6 = 0                                                      
            END IF                                                                 
                                                                                
            SELECT SUM(sfq03) INTO lm_num1 FROM sfq_file, sfp_file                 
             WHERE sfq02=mccg.ccg01 AND sfq01=sfp01 AND sfp06 IN('1','D') AND sfp04='Y'    #FUN-C70014 add sfp06 in 'D'
               AND sfp03 <= lm_edate AND sfq04 = l_sfa08                           
            SELECT SUM(sfq03) INTO lm_num6 FROM sfq_file, sfp_file                 
             WHERE sfq02=mccg.ccg01 AND sfq01=sfp01 AND sfp06='6' AND sfp04='Y'    
               AND sfp03 <= lm_edate AND sfq04 = l_sfa08                           
            IF cl_null(lm_num1) THEN LET lm_num1 = 0 END IF                        
            IF cl_null(lm_num6) THEN LET lm_num6 = 0 END IF                        
            IF l_sfa08 = ' ' THEN
               LET lm_num1 = 0                                                     
               LET lm_num6 = 0                                                     
            END IF
 
            #把所有的發料套數-退料套數放進一個動態數組里面
            #LET l_n[i].k = (qty1+l_num1)-(qty2+l_num6)
                                                                                
            LET t_n[i].k = (t_qty1+t_num1)-(t_qty6+t_num6)                         
            LET lm_n[i].k = (lm_qty1+lm_num1)-(lm_qty6+lm_num6)                    
                                                        
            LET i = i + 1
         END FOREACH
         LET i = i - 1
 
         #相當于對i個數進行排序，用冒泡排序來完成，把最大的數放在最后
         #FOR m = 1 TO i-1
         #   FOR n = m TO i      #No.MOD-930168 add
         #      IF l_n[m].k > l_n[n].k THEN
         #         LET l_num = l_n[m].k
         #         LET l_n[m].k = l_n[n].k
         #         LET l_n[n].k = l_num
         #      END IF
         #   END FOR
         #END FOR
 
         FOR m = 1 TO i-1                                                          
            FOR n = m TO i                                                         
               IF t_n[m].k > t_n[n].k THEN                                         
                  LET l_num = t_n[m].k                                             
                  LET t_n[m].k = t_n[n].k                                          
                  LET t_n[n].k = l_num                                             
               END IF                                                              
            END FOR                                                                
         END FOR                                                                   
                                                                                
         FOR m = 1 TO i-1                                                          
            FOR n = m TO i                                                         
               IF lm_n[m].k > lm_n[n].k THEN                                       
                  LET l_num = lm_n[m].k                                            
                  LET lm_n[m].k = lm_n[n].k                                        
                  LET lm_n[n].k = l_num                                            
               END IF                                                              
            END FOR                                                                
         END FOR 
#CHI-D10020---end
#FUN-D70038---end
      ELSE  #FUN-D70038
         #CHI-D10020---begin
         LET l_sfb081 = 0
         SELECT sfb081 INTO l_sfb081
           FROM sfb_file
          WHERE sfb01 = mccg.ccg01
         LET l_ccg21 = 0
         SELECT SUM(ccg21) INTO l_ccg21
           FROM ccg_file
          WHERE ccg01 = mccg.ccg01
            AND ((ccg02 = yy AND ccg03 < mm)
            OR (ccg02 < yy))
         IF cl_null(l_sfb081) THEN LET l_sfb081 = 0 END IF
         IF cl_null(l_ccg21) THEN LET l_ccg21 = 0 END IF
         #CHI-D10020---end
      END IF  #FUN-D70038
      LET l_ima55_fac=0
      SELECT ima55_fac INTO l_ima55_fac FROM ima_file
       WHERE ima01=mccg.ccg04
      IF cl_null(l_ima55_fac) OR l_ima55_fac=0 THEN  LET l_ima55_fac=1 END IF
      #IF i = 0 THEN
      #   LET mccg.ccg21 = (qty1-qty2)*l_ima55_fac
      #ELSE
      #   LET mccg.ccg21 = l_n[i].k * l_ima55_fac
      #END IF
      IF g_sma.sma129 = 'Y' THEN   #FUN-D70038
      #FUN-D70038---begin remark
         #CHI-D10020---begin mark
         IF i = 0 THEN                                                             
            LET mccg.ccg21 = (t_qty1 - t_qty6 - (lm_qty1 - lm_qty6))*l_ima55_fac   
         ELSE                                                                      
            LET mccg.ccg21 = (t_n[i].k -lm_n[i].k) * l_ima55_fac                   
         END IF
         #CHI-D10020---end
      #FUN-D70038---end
      ELSE  #FUN-D70038
         LET mccg.ccg21 = (l_sfb081-l_ccg21)*l_ima55_fac  #CHI-D10020
      END IF  #FUN-D70038
      #No.MOD-AC0300  --End  
   END IF   #FUN-660154 add
   IF g_sfb.sfb38 >= g_bdate AND g_sfb.sfb38 <= g_edate AND   #工單成會結案
      mccg.ccg21 != (mccg.ccg11+mccg.ccg31) * -1 THEN         #則轉出視為投入
      CALL cl_getmsg('axc-520',g_lang) RETURNING g_msg1
      CALL cl_getmsg('axc-507',g_lang) RETURNING g_msg2
      LET g_msg=g_msg1 CLIPPED,g_sfb.sfb01,g_msg2 CLIPPED,
                mccg.ccg21 USING '------&','<-',(mccg.ccg11+mccg.ccg31) USING '------&)'
 
      LET t_time = TIME
     #LET g_time=t_time #MOD-C30891 mark
     #FUN-A50075--mod--str--ccy_file拿掉plant以及legal
     #INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04,ccyplant,ccylegal) #No.MOD-470041 #FUN-980009 add ccyplant,ccylegal
     #              VALUES(TODAY,g_time,g_user,g_msg,g_plant,g_legal) #FUN-980009 add g_plant,g_legal
      INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04)
                   #VALUES(TODAY,g_time,g_user,g_msg) #MOD-C30891 mark
                    VALUES(TODAY,t_time,g_user,g_msg) #MOD-C30891 
     #FUN-A50075--mod--end
      IF cl_null(mccg.ccg311) THEN LET mccg.ccg311=0 END IF   #FUN-CC0002
      LET mccg.ccg41 = (mccg.ccg11+mccg.ccg21+mccg.ccg31+mccg.ccg311) * -1   #FUN-CC0002 add ccg311
   #   LET mccg.ccg41 = (mccg.ccg11+mccg.ccg21+mccg.ccg31) * -1   #FUN-CC0002 mark 
   ELSE
      # 98.09.08 Star 投入套數小於轉出.. 需勾稽
      IF (mccg.ccg11 + mccg.ccg21) < mccg.ccg31*-1 THEN
         CALL cl_getmsg('axc-520',g_lang) RETURNING g_msg1
         CALL cl_getmsg('axc-508',g_lang) RETURNING g_msg2
         LET g_msg=g_msg1 CLIPPED,g_sfb.sfb01,g_msg2 CLIPPED,
                   mccg.ccg21 USING '------&','<-',(mccg.ccg11+mccg.ccg31) USING '------&)'
 
         LET t_time = TIME
        #LET g_time=t_time #MOD-C30891 mark
        #FUN-A50075--mod--str--ccy_file拿掉plant以及legal
        #INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04,ccyplant,ccylegal) #No.MOD-470041 #FUN-980009 add ccyplant,ccylegal
        #              VALUES(TODAY,g_time,g_user,g_msg,g_plant,g_legal) #FUN-980009 add g_plant,g_legal
         INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04)
                      #VALUES(TODAY,g_time,g_user,g_msg) #MOD-C30891 mark
                       VALUES(TODAY,t_time,g_user,g_msg) #MOD-C30891 
        #FUN-A50075--mod--end
      END IF
   END IF
END FUNCTION
 
FUNCTION wip_2()        # 計算每張工單的 WIP-元件'期初,本期投入'成本 (cch)
   CALL wip_2_1()       # step 1. WIP-元件 上期期末轉本期期初
   CALL wip_2_21()      # step 2-1. WIP-元件 本期投入材料 (依工單發料/退料檔)
   CALL wip_ccg21()     #           計算每張工單的 WIP-主件 投入數量 -> 有爭議
   CALL wip_2_22()      # step 2-2. WIP-元件 本期投入人工製費
   CALL wip_2_23()      # step 2-3. WIP-元件 本期投入調整成本
END FUNCTION
 
FUNCTION wip2_2()       # 計算產品WIP元件 投入成本 (cch)
   CALL wip2_2_1()      # step 1. WIP元件 期初
   CALL wip2_2_21()     # step 2-1. WIP元件 本期投入材料 (依發料/退料檔)
   LET mccg.ccg21=0     #           WIP主件 投入數量 0
   CALL wip2_2_22()     # step 2-2. WIP元件 本期投入人工製費
   CALL wip2_2_23()     # step 2-3. WIP元件 本期投入調整成本
END FUNCTION
 
FUNCTION wip_2_1()      #  1. WIP-元件 上期期末轉本期期初
   DEFINE l_ccf         RECORD LIKE ccf_file.*
   DECLARE wip_c2 CURSOR FOR
     SELECT * FROM cch_file
      WHERE cch01=g_sfb.sfb01 AND cch02=last_yy AND cch03=last_mm
        AND cch06=type
   FOREACH wip_c2 INTO g_cch.*
     CALL p500_cch_0()  # 上期期末轉本期期初, 將 cch 歸 0
     LET g_cch.cchdate = g_today
    #LET g_cch.cchplant=g_plant #FUN-980009 add    #FUN-A50075
     LET g_cch.cchlegal=g_legal #FUN-980009 add
     LET g_cch.cchoriu = g_user      #No.FUN-980030 10/01/04
     LET g_cch.cchorig = g_grup      #No.FUN-980030 10/01/04
     INSERT INTO cch_file VALUES (g_cch.*)
     IF STATUS THEN 
        CALL cl_err3("ins","cch_file",g_cch.cch01,g_cch.cch02,STATUS,"","ins cch(1):",1)   #No.FUN-660127
     END IF
   END FOREACH
   CLOSE wip_c2
 
   DECLARE wip_c2_ccf CURSOR FOR        # WIP-元件 期初xx帳轉本期期初
     SELECT * FROM ccf_file
      WHERE ccf01=g_sfb.sfb01 AND ccf02=last_yy AND ccf03=last_mm
        AND ccf06=type  
        AND (ccf04!=' ' AND ccf04 IS NOT NULL)
   FOREACH wip_c2_ccf INTO l_ccf.*
     IF SQLCA.sqlcode THEN
       CALL cl_err('wip_c2_ccf',SQLCA.sqlcode,0)   
        EXIT FOREACH
     END IF
     CALL p500_cch_01() # 將 cch 歸 0
     LET g_cch.cch01 =g_sfb.sfb01
     LET g_cch.cch02 =yy
     LET g_cch.cch03 =mm
     LET g_cch.cch04 =l_ccf.ccf04
     LET g_cch.cch05 =l_ccf.ccf05
     LET g_cch.cch06 =l_ccf.ccf06   #FUN-7C0028 add
     LET g_cch.cch07 =l_ccf.ccf07   #FUN-7C0028 add
     LET g_cch.cch11 =l_ccf.ccf11
     LET g_cch.cch12 =l_ccf.ccf12
     LET g_cch.cch12a=l_ccf.ccf12a
     LET g_cch.cch12b=l_ccf.ccf12b
     LET g_cch.cch12c=l_ccf.ccf12c
     LET g_cch.cch12d=l_ccf.ccf12d
     LET g_cch.cch12e=l_ccf.ccf12e
     LET g_cch.cch12f=l_ccf.ccf12f   #FUN-7C0028 add
     LET g_cch.cch12g=l_ccf.ccf12g   #FUN-7C0028 add
     LET g_cch.cch12h=l_ccf.ccf12h   #FUN-7C0028 add
     LET g_cch.cch91 =l_ccf.ccf11
     LET g_cch.cch92 =l_ccf.ccf12
     LET g_cch.cch92a=l_ccf.ccf12a
     LET g_cch.cch92b=l_ccf.ccf12b
     LET g_cch.cch92c=l_ccf.ccf12c
     LET g_cch.cch92d=l_ccf.ccf12d
     LET g_cch.cch92e=l_ccf.ccf12e
     LET g_cch.cch92f=l_ccf.ccf12f   #FUN-7C0028 add
     LET g_cch.cch92g=l_ccf.ccf12g   #FUN-7C0028 add
     LET g_cch.cch92h=l_ccf.ccf12h   #FUN-7C0028 add
     LET g_cch.cchdate = g_today
    #LET g_cch.cchplant=g_plant #FUN-980009 add   #FUN-A50075
     LET g_cch.cchlegal=g_legal #FUN-980009 add
     INSERT INTO cch_file VALUES (g_cch.*)
     IF SQLCA.SQLCODE AND (NOT cl_sql_dup_value(SQLCA.SQLCODE)) THEN
        CALL cl_err3("ins","cch_file",g_cch.cch01,g_cch.cch02,STATUS,"","wip_2_1() ins cch:",1)   #No.FUN-660127
     END IF
     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
       #MOD-B30061---add---start---
        IF cl_null(g_cch.cch31) THEN LET g_cch.cch31 = 0 END IF
        IF cl_null(g_cch.cch32) THEN LET g_cch.cch32 = 0 END IF
        IF cl_null(g_cch.cch32a) THEN LET g_cch.cch32a = 0 END IF
        IF cl_null(g_cch.cch32b) THEN LET g_cch.cch32b = 0 END IF
        IF cl_null(g_cch.cch32c) THEN LET g_cch.cch32c = 0 END IF
        IF cl_null(g_cch.cch32d) THEN LET g_cch.cch32d = 0 END IF
        IF cl_null(g_cch.cch32e) THEN LET g_cch.cch32e = 0 END IF
        IF cl_null(g_cch.cch91) THEN LET g_cch.cch91 = 0 END IF
        IF cl_null(g_cch.cch92) THEN LET g_cch.cch92 = 0 END IF
        IF cl_null(g_cch.cch92a) THEN LET g_cch.cch92a = 0 END IF
        IF cl_null(g_cch.cch92b) THEN LET g_cch.cch92b = 0 END IF
        IF cl_null(g_cch.cch92c) THEN LET g_cch.cch92c = 0 END IF
        IF cl_null(g_cch.cch92d) THEN LET g_cch.cch92d = 0 END IF
        IF cl_null(g_cch.cch92e) THEN LET g_cch.cch92e = 0 END IF
        
       #MOD-B30061---add---end---
        #MOD-E40023 add begin----------------
        IF cl_null(g_cch.cch32f) THEN LET g_cch.cch32f = 0 END IF
        IF cl_null(g_cch.cch32g) THEN LET g_cch.cch32g = 0 END IF
        IF cl_null(g_cch.cch32h) THEN LET g_cch.cch32h = 0 END IF
        IF cl_null(g_cch.cch92f) THEN LET g_cch.cch92f = 0 END IF
        IF cl_null(g_cch.cch92g) THEN LET g_cch.cch92g = 0 END IF
        IF cl_null(g_cch.cch92h) THEN LET g_cch.cch92h = 0 END IF
        #MOD-E40023 add end-------------------
        UPDATE cch_file SET cch_file.*=g_cch.*
         WHERE cch01=g_sfb.sfb01 AND cch02=yy AND cch03=mm
           AND cch04=l_ccf.ccf04
           AND cch06=l_ccf.ccf06 AND cch07=l_ccf.ccf07   #FUN-7C0028 add
        IF STATUS THEN 
           CALL cl_err3("upd","cch_file",g_sfb.sfb01,yy,STATUS,"","upd cch(2):",1)   #No.FUN-660127
        END IF
     END IF
   END FOREACH
   CLOSE wip_c2_ccf
END FUNCTION
 
FUNCTION wip2_2_1()      #  1. WIP-元件 上期期末轉本期期初
   DEFINE l_ccf         RECORD LIKE ccf_file.*
   DECLARE wip2_c2 CURSOR FOR
     SELECT * FROM cch_file
      WHERE cch01=g_ima01 AND cch02=last_yy AND cch03=last_mm
        AND cch06=type 
   FOREACH wip2_c2 INTO g_cch.*
     CALL p500_cch_0()  # 上期期末轉本期期初, 將 cch 歸 0
     LET g_cch.cchdate = g_today
    #LET g_cch.cchplant=g_plant #FUN-980009 add    #FUN-A50075
     LET g_cch.cchlegal=g_legal #FUN-980009 add
     LET g_cch.cchoriu = g_user      #No.FUN-980030 10/01/04
     LET g_cch.cchorig = g_grup      #No.FUN-980030 10/01/04
     INSERT INTO cch_file VALUES (g_cch.*)
     IF STATUS THEN 
        CALL cl_err3("ins","cch_file",g_cch.cch01,g_cch.cch02,STATUS,"","ins cch(1):",1)   #No.FUN-660127
     END IF
   END FOREACH
   CLOSE wip2_c2
 
   DECLARE wip2_c2_ccf CURSOR FOR        # WIP-元件 期初xx帳轉本期期初
     SELECT * FROM ccf_file
      WHERE ccf01=g_ima01 AND ccf02=last_yy AND ccf03=last_mm
        AND ccf06=type  
        AND (ccf04!=' ' AND ccf04 IS NOT NULL)
   FOREACH wip2_c2_ccf INTO l_ccf.*
     IF SQLCA.sqlcode THEN
       CALL cl_err('wip2_c2_ccf',SQLCA.sqlcode,0)   
        EXIT FOREACH
     END IF
     CALL p500_cch_01() # 將 cch 歸 0
     LET g_cch.cch01 =g_ima01
     LET g_cch.cch02 =yy
     LET g_cch.cch03 =mm
     LET g_cch.cch04 =l_ccf.ccf04
     LET g_cch.cch05 =l_ccf.ccf05
     LET g_cch.cch06 =l_ccf.ccf06   #FUN-7C0028 add
     LET g_cch.cch07 =l_ccf.ccf07   #FUN-7C0028 add
     LET g_cch.cch11 =l_ccf.ccf11
     LET g_cch.cch12 =l_ccf.ccf12
     LET g_cch.cch12a=l_ccf.ccf12a
     LET g_cch.cch12b=l_ccf.ccf12b
     LET g_cch.cch12c=l_ccf.ccf12c
     LET g_cch.cch12d=l_ccf.ccf12d
     LET g_cch.cch12e=l_ccf.ccf12e
     LET g_cch.cch12f=l_ccf.ccf12f   #FUN-7C0028 add
     LET g_cch.cch12g=l_ccf.ccf12g   #FUN-7C0028 add
     LET g_cch.cch12h=l_ccf.ccf12h   #FUN-7C0028 add
     LET g_cch.cch91 =l_ccf.ccf11
     LET g_cch.cch92 =l_ccf.ccf12
     LET g_cch.cch92a=l_ccf.ccf12a
     LET g_cch.cch92b=l_ccf.ccf12b
     LET g_cch.cch92c=l_ccf.ccf12c
     LET g_cch.cch92d=l_ccf.ccf12d
     LET g_cch.cch92e=l_ccf.ccf12e
     LET g_cch.cch92f=l_ccf.ccf12f   #FUN-7C0028 add
     LET g_cch.cch92g=l_ccf.ccf12g   #FUN-7C0028 add
     LET g_cch.cch92h=l_ccf.ccf12h   #FUN-7C0028 add
     LET g_cch.cchdate = g_today
    #LET g_cch.cchplant=g_plant #FUN-980009 add    #FUN-A50075
     LET g_cch.cchlegal=g_legal #FUN-980009 add
     INSERT INTO cch_file VALUES (g_cch.*)
     IF SQLCA.SQLCODE AND (NOT cl_sql_dup_value(SQLCA.SQLCODE)) THEN
        CALL cl_err3("ins","cch_file",g_cch.cch01,g_cch.cch02,STATUS,"","wip2_2_1() ins cch:",1)   #No.FUN-660127
     END IF
     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
       #MOD-B30061---add---start---
        IF cl_null(g_cch.cch31) THEN LET g_cch.cch31 = 0 END IF
        IF cl_null(g_cch.cch32) THEN LET g_cch.cch32 = 0 END IF
        IF cl_null(g_cch.cch32a) THEN LET g_cch.cch32a = 0 END IF
        IF cl_null(g_cch.cch32b) THEN LET g_cch.cch32b = 0 END IF
        IF cl_null(g_cch.cch32c) THEN LET g_cch.cch32c = 0 END IF
        IF cl_null(g_cch.cch32d) THEN LET g_cch.cch32d = 0 END IF
        IF cl_null(g_cch.cch32e) THEN LET g_cch.cch32e = 0 END IF
        IF cl_null(g_cch.cch91) THEN LET g_cch.cch91 = 0 END IF
        IF cl_null(g_cch.cch92) THEN LET g_cch.cch92 = 0 END IF
        IF cl_null(g_cch.cch92a) THEN LET g_cch.cch92a = 0 END IF
        IF cl_null(g_cch.cch92b) THEN LET g_cch.cch92b = 0 END IF
        IF cl_null(g_cch.cch92c) THEN LET g_cch.cch92c = 0 END IF
        IF cl_null(g_cch.cch92d) THEN LET g_cch.cch92d = 0 END IF
        IF cl_null(g_cch.cch92e) THEN LET g_cch.cch92e = 0 END IF
       #MOD-B30061---add---end---
        #MOD-E40023 add begin----------------
        IF cl_null(g_cch.cch32f) THEN LET g_cch.cch32f = 0 END IF
        IF cl_null(g_cch.cch32g) THEN LET g_cch.cch32g = 0 END IF
        IF cl_null(g_cch.cch32h) THEN LET g_cch.cch32h = 0 END IF
        IF cl_null(g_cch.cch92f) THEN LET g_cch.cch92f = 0 END IF
        IF cl_null(g_cch.cch92g) THEN LET g_cch.cch92g = 0 END IF
        IF cl_null(g_cch.cch92h) THEN LET g_cch.cch92h = 0 END IF
        #MOD-E40023 add end-------------------       
        UPDATE cch_file SET cch_file.*=g_cch.*
         WHERE cch01=g_ima01     AND cch02=yy AND cch03=mm
           AND cch04=l_ccf.ccf04
           AND cch06=l_ccf.ccf06 AND cch07=l_ccf.ccf07   #FUN-7C0028 add
        IF STATUS THEN 
           CALL cl_err3("upd","cch_file",g_ima01,yy,STATUS,"","upd cch(2):",1)   #No.FUN-660127
        END IF
     END IF
   END FOREACH
   CLOSE wip2_c2_ccf
END FUNCTION
 
FUNCTION wip_2_21()      #  2-1. WIP-元件 本期投入材料 (依工單發料/退料檔)
   DEFINE l_ima08          LIKE ima_file.ima08     #No.FUN-680122CHAR(1)
   DEFINE l_ima57          LIKE ima_file.ima57     #No.FUN-680122SMALLINT
   DEFINE l_tlf01          LIKE tlf_file.tlf01     #No.MOD-490217
   DEFINE l_tlf02,l_tlf03  LIKE type_file.num5     #No.FUN-680122SMALLINT
   DEFINE l_tlf10          LIKE tlf_file.tlf10     #No.FUN-680122DEC(15,3)
   DEFINE l_tlf13          LIKE tlf_file.tlf13
   DEFINE l_tlfcost        LIKE tlf_file.tlfcost
#  DEFINE l_c21                                    LIKE ima_file.ima26      #No.FUN-680122DEC(15,5)
   DEFINE l_c21                                    LIKE type_file.num15_3   ###GP5.2  #NO.FUN-A40023
   DEFINE l_c22,l_c22a,l_c22b,l_c22c,l_c22d,l_c22e LIKE type_file.num20_6   #No.FUN-680122DEC(20,6) # No.7088.A.a #MOD-4C0005
   DEFINE l_c22f,l_c22g,l_c22h                     LIKE type_file.num20_6   #FUN-7C0028 add
   DEFINE l_c23,l_c23a,l_c23b,l_c23c,l_c23d,l_c23e LIKE type_file.num20_6   #No.FUN-680122DEC(20,6) # No.7088.A.a #MOD-4C0005
   DEFINE l_c23f,l_c23g,l_c23h                     LIKE type_file.num20_6   #FUN-7C0028 add
   DEFINE l_tlf62                                  LIKE tlf_file.tlf62
   DEFINE l_sfa161                                 LIKE sfa_file.sfa161
   DEFINE l_tlf21x,l_tlf221x,l_tlf222x,l_tlf2231x     LIKE tlf_file.tlf21  #CHI-910041 tlf21-->tlf21x
   DEFINE l_tlf2232x,l_tlf224x                       LIKE tlf_file.tlf21      #No.A102   #CHI-910041
   DEFINE l_tlf2241x,l_tlf2242x,l_tlf2243x            LIKE tlf_file.tlf21      #FUN-7C0028 add #CHI-910041
   DEFINE l_zero                                   LIKE type_file.num5           #No.FUN-680122SMALLINT # 尾差判斷
   DEFINE l_tlf036          LIKE tlf_file.tlf036   #FUN-B90029
   DEFINE l_tlf037          LIKE tlf_file.tlf037   #FUN-B90029
   DEFINE l_cnt             LIKE type_file.num10   #FUN-B90029 
   DECLARE wip_c3 CURSOR FOR    
     #SELECT tlf01,tlfcost,ima08,ima57,tlf02,tlf03,tlf13,SUM(tlf10*tlf60*tlf907*-1),    #TQC-970003 #MOD-B50083 mark
      SELECT tlf01,tlfcost,ima08,ima57,tlf02,tlf03,tlf13,tlf036,tlf037,SUM(ROUND((tlf10*tlf60*tlf907*-1),3)),     #MOD-B50083 add #FUN-B90029 add tlf036,tlf037
             SUM(tlf21*tlf907*-1),SUM(tlf221*tlf907*-1),SUM(tlf222*tlf907*-1),
             SUM(tlf2231*tlf907*-1),SUM(tlf2232*tlf907*-1),SUM(tlf224*tlf907*-1)
            ,SUM(tlf2241*tlf907*-1),SUM(tlf2242*tlf907*-1),SUM(tlf2243*tlf907*-1)
              FROM tlf_file,ima_file
             WHERE tlf62=g_sfb.sfb01 AND tlf06 BETWEEN g_bdate AND g_edate
               AND ((tlf02=50 AND ( tlf03 BETWEEN 60 AND 69 OR tlf03 =18)) OR
                    (tlf03=50 AND tlf02 BETWEEN 60 AND 69))
               AND tlf01=ima01 AND tlf10<>0
               #AND tlf13 LIKE    'asfi5%' #                   #FUN-B00029 mark
               AND (tlf13 LIKE 'asfi5%' OR tlf13 ='asft700')   #FUN-B90029
               #AND tlf902 NOT IN(SELECT jce02 FROM jce_file) #No:7888 #CHI-C80002
               AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = tlf902)  #CHI-C80002
               AND tlf907 != 0 
             GROUP BY tlf01,tlfcost,ima08,ima57,tlf02,tlf03,tlf13,tlf036,tlf037  #TQC-970003 #FUN-B90029 add tlf036,tlf037
             ORDER BY tlf13 #FUN-B90029 當站下線最後算
   FOREACH wip_c3 INTO l_tlf01,l_tlfcost,l_ima08,l_ima57,l_tlf02,l_tlf03,l_tlf13,l_tlf036,l_tlf037,l_tlf10,	#No.TQC-970003 #FUN-B90029 add tlf036,tlf037
                       l_tlf21x,l_tlf221x,l_tlf222x,l_tlf2231x,l_tlf2232x,l_tlf224x   #No.A102  #CHI-910041 tlf21-->tlf21x#CHI-910041
                      ,l_tlf2241x,l_tlf2242x,l_tlf2243x  #FUN-7C0028 add#CHI-910041
     IF SQLCA.sqlcode THEN
       CALL cl_err('wip_c3',SQLCA.sqlcode,0)   
        EXIT FOREACH
     END IF
     IF cl_null(l_tlf10)   THEN LET l_tlf10  =0 END IF
     IF cl_null(l_tlf21x)   THEN LET l_tlf21x  =0 END IF   #CHI-910041 tlf21-->tlf21x
     IF cl_null(l_tlf221x)  THEN LET l_tlf221x =0 END IF  #CHI-910041
     IF cl_null(l_tlf222x)  THEN LET l_tlf222x =0 END IF  #CHI-910041
     IF cl_null(l_tlf2231x) THEN LET l_tlf2231x=0 END IF  #CHI-910041
     IF cl_null(l_tlf2232x) THEN LET l_tlf2232x=0 END IF  #CHI-910041
     IF cl_null(l_tlf224x)  THEN LET l_tlf224x =0 END IF  #CHI-910041
     IF cl_null(l_tlf2241x) THEN LET l_tlf2241x=0 END IF  #CHI-910041
     IF cl_null(l_tlf2242x) THEN LET l_tlf2242x=0 END IF  #CHI-910041
     IF cl_null(l_tlf2243x) THEN LET l_tlf2243x=0 END IF  #CHI-910041
     IF l_ima08 IS NULL THEN LET l_ima08='P' END IF
     IF l_tlf13 != 'asft700' THEN             #FUN-B90029  #若是當站下線則不定義為重工
     IF l_tlf01=g_sfb.sfb05 THEN LET l_ima08='R' END IF #主/元料號同表重工
     IF l_ima57 = g_ima57_t THEN LET l_ima08='R' END IF #成本階相等表重工
     IF l_ima57 < g_ima57_t THEN LET l_ima08='W' END IF #成本階較低表上階重工
     END IF   #FUN-B90029   
     LET l_c23=0
     LET l_c23a=0 LET l_c23b=0 LET l_c23c=0 LET l_c23d=0 LET l_c23e=0
     LET l_c23f=0 LET l_c23g=0 LET l_c23h=0    #FUN-7C0028 add
 
     LET l_zero = 0
     CASE                        # 取發料單價
        WHEN l_ima08 MATCHES '[RW]' # (本階重工者取重工前庫存月平均)
           IF g_sma.sma43 = '1' THEN
              CALL p500_upd_cxa09(l_tlf01,l_tlf10,0)
                   RETURNING l_c23,l_c23a,l_c23b,l_c23c,l_c23d,l_c23e
                                  ,l_c23f,l_c23g,l_c23h   #FUN-7C0028 add
           ELSE
              SELECT ccc12a+ccc22a, ccc12b+ccc22b, ccc12c+ccc22c,
                     ccc12d+ccc22d, ccc12e+ccc22e,
                     ccc12f+ccc22f, ccc12g+ccc22g, ccc12h+ccc22h,  #FUN-7C0028 add
                     ccc12 +ccc22 , ccc11 +ccc21
                INTO l_c22a,l_c22b,l_c22c,l_c22d,l_c22e,
                     l_c22f,l_c22g,l_c22h,  #FUN-7C0028 add
                     l_c22,l_c21
                FROM ccc_file
               WHERE ccc01=l_tlf01 AND ccc02=yy AND ccc03=mm
                 AND ccc07=type    AND ccc08=l_tlfcost  
                    # (上階重工者取上月庫存月平均)
              IF l_ima08='W' OR STATUS OR l_c21 = 0 OR l_c21 IS NULL THEN
                 LET l_c23a=0 LET l_c23b=0 LET l_c23c=0
                 LET l_c23d=0 LET l_c23e=0 LET l_c23 =0
                 LET l_c23f=0 LET l_c23g=0 LET l_c23h=0   #FUN-7C0028 add
              ELSE
                 LET l_zero = 1
                 LET l_c23a=l_c22a/l_c21
                 LET l_c23b=l_c22b/l_c21
                 LET l_c23c=l_c22c/l_c21
                 LET l_c23d=l_c22d/l_c21
                 LET l_c23e=l_c22e/l_c21
                 LET l_c23f=l_c22f/l_c21   #FUN-7C0028 add
                 LET l_c23g=l_c22g/l_c21   #FUN-7C0028 add
                 LET l_c23h=l_c22h/l_c21   #FUN-7C0028 add
                 LET l_c23 =l_c22 /l_c21
              END IF
              #------------------ (無單價再取上月庫存月平均)
              IF l_c23a=0 AND l_c23b=0 AND l_c23c=0 AND l_c23d=0 AND l_c23e=0
                          AND l_c23f=0 AND l_c23g=0 AND l_c23h=0 THEN   #FUN-7C0028 add l_c23f,g,h
                 SELECT cca23a,cca23b,cca23c,cca23d,cca23e,
                        cca23f,cca23g,cca23h,cca23   #FUN-7C0028 add cca23f,g,h
                   INTO l_c23a,l_c23b,l_c23c,l_c23d,l_c23e,
                        l_c23f,l_c23g,l_c23h,l_c23   #FUN-7C0028 add l_c23f,g,h
                   FROM cca_file
                  WHERE cca01=l_tlf01 AND cca02=last_yy AND cca03=last_mm
                    AND cca06=type    AND cca07=l_tlfcost 
                 # 98.08.16 Star 若上期仍無單價, 則取上期xx帳單價
                 IF SQLCA.sqlcode OR
                    (l_c23a=0 AND l_c23b=0 AND l_c23c=0 AND l_c23d=0
                              AND l_c23f=0 AND l_c23g=0 AND l_c23h=0) THEN   #FUN-7C0028 add l_c23f,g,h
                    SELECT ccc23a,ccc23b,ccc23c,ccc23d,ccc23e,
                           ccc23f,ccc23g,ccc23h,ccc23   #FUN-7C0028 add ccc23f,g,h
                      INTO l_c23a,l_c23b,l_c23c,l_c23d,l_c23e,
                           l_c23f,l_c23g,l_c23h,l_c23   #FUN-7C0028 add l_c23f,g,h
                      FROM ccc_file
                     WHERE ccc01=l_tlf01 AND ccc02=last_yy AND ccc03=last_mm
                       AND ccc07=type    AND ccc08=l_tlfcost
                    IF STATUS THEN
                       CALL cl_getmsg('axc-509',g_lang) RETURNING g_msg1
                       LET g_msg=l_tlf01,g_msg1 CLIPPED
 
                       LET t_time = TIME
                      #LET g_time=t_time #MOD-C30891 mark
                      #FUN-A50075--mod--str--ccy_file拿掉plant以及legal
                      #INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04,ccyplant,ccylegal) #No.MOD-470041 #FUN-980009 add ccyplant,ccylegal
                      #              VALUES(TODAY,g_time,g_user,g_msg,g_plant,g_legal) #FUN-980009 add g_plant,g_legal
                       INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04)
                                    #VALUES(TODAY,g_time,g_user,g_msg) #MOD-C30891 mark
                                     VALUES(TODAY,t_time,g_user,g_msg) #MOD-C30891 
                      #FUN-A50075--mod--end
                       LET l_c23a=0
                       LET l_c23 = l_c23a
                    END IF
                 END IF
              END IF
           END IF
           #-------------------------------------------------------------
      OTHERWISE                   # (取當月庫存月平均檔)
           IF g_sma.sma43 = '1' THEN
              CALL p500_upd_cxa09(l_tlf01,l_tlf10,0)
                   RETURNING l_c23,l_c23a,l_c23b,l_c23c,l_c23d,l_c23e
                                  ,l_c23f,l_c23g,l_c23h   #FUN-7C0028 add
           ELSE
              SELECT ccc23a,ccc23b,ccc23c,ccc23d,ccc23e,
                     ccc23f,ccc23g,ccc23h,ccc23   #FUN-7C0028 add ccc23f,g,h
                INTO l_c23a,l_c23b,l_c23c,l_c23d,l_c23e,
                     l_c23f,l_c23g,l_c23h,l_c23   #FUN-7C0028 add l_c23f,g,h
                FROM ccc_file
               WHERE ccc01=l_tlf01 AND ccc02=yy AND ccc03=mm
                 AND ccc07=type    AND ccc08=l_tlfcost
           END IF
     END CASE
 
     #FUN-B90029(S)
     IF l_tlf13 = 'asft700' THEN
        SELECT COUNT(*) INTO l_cnt FROM shd_file WHERE shd01=l_tlf036 AND shd02=l_tlf037
        IF l_cnt > 0 THEN
           #FUN-B90029 --START mark--
           #SELECT shd08 INTO l_c23a FROM shd_file WHERE shd01=l_tlf036 AND shd02=l_tlf037   
           #IF l_c23a IS NULL THEN LET l_c23a = 0 END IF                                     
           #LET l_c23b = 0
           #LET l_c23c = 0
           #LET l_c23d = 0
           #LET l_c23e = 0
           #LET l_c23f = 0
           #LET l_c23g = 0
           #LET l_c23h = 0
           #FUN-B90029 --END mark--
           #FUN-B90029 --START--
           SELECT shd08,shd082,shd083,shd084,shd085,shd086,shd087,shd088 
            INTO l_c23a,l_c23b,l_c23c,l_c23d,l_c23e,l_c23f,l_c23g,l_c23h                            
             FROM shd_file WHERE shd01=l_tlf036 AND shd02=l_tlf037                            
           IF l_c23a IS NULL THEN LET l_c23a = 0 END IF
           IF l_c23b IS NULL THEN LET l_c23b = 0 END IF  
           IF l_c23c IS NULL THEN LET l_c23c = 0 END IF  
           IF l_c23d IS NULL THEN LET l_c23d = 0 END IF  
           IF l_c23e IS NULL THEN LET l_c23e = 0 END IF  
           IF l_c23f IS NULL THEN LET l_c23f = 0 END IF  
           IF l_c23g IS NULL THEN LET l_c23g = 0 END IF  
           IF l_c23h IS NULL THEN LET l_c23h = 0 END IF  
           #FUN-B90029 --END--           
        END IF
     END IF
     #FUN-B90029(E)
 
     CALL p500_cch_01() # 將 cch 歸 0
     LET g_cch.cch01 =g_sfb.sfb01
     LET g_cch.cch04 =l_tlf01
     LET g_cch.cch06 =type        #FUN-7C0028 add
     LET g_cch.cch07 =l_tlfcost
     IF l_ima08 = 'W' THEN LET l_ima08='R' END IF
     LET g_cch.cch05 =l_ima08
     LET g_cch.cch21 =l_tlf10
 
     IF l_zero = 1 THEN
        LET g_cch.cch22a=l_tlf10*l_c22a/l_c21
        LET g_cch.cch22b=l_tlf10*l_c22b/l_c21
        LET g_cch.cch22c=l_tlf10*l_c22c/l_c21
        LET g_cch.cch22d=l_tlf10*l_c22d/l_c21
        LET g_cch.cch22e=l_tlf10*l_c22e/l_c21
        LET g_cch.cch22f=l_tlf10*l_c22f/l_c21   #FUN-7C0028 add
        LET g_cch.cch22g=l_tlf10*l_c22g/l_c21   #FUN-7C0028 add 
        LET g_cch.cch22h=l_tlf10*l_c22h/l_c21   #FUN-7C0028 add 
     ELSE
       IF g_sma.sma43 = '1' THEN
          LET g_cch.cch22a=l_tlf221x   #CHI-910041
          LET g_cch.cch22b=l_tlf222x   #CHI-910041
          LET g_cch.cch22c=l_tlf2231x  #CHI-910041
          LET g_cch.cch22d=l_tlf2232x  #CHI-910041
          LET g_cch.cch22e=l_tlf224x   #CHI-910041
          LET g_cch.cch22f=l_tlf2241x   #FUN-7C0028 add #CHI-910041
          LET g_cch.cch22g=l_tlf2242x   #FUN-7C0028 add #CHI-910041
          LET g_cch.cch22h=l_tlf2243x   #FUN-7C0028 add #CHI-910041
       ELSE
          LET g_cch.cch22a=l_tlf10*l_c23a
          LET g_cch.cch22b=l_tlf10*l_c23b
          LET g_cch.cch22c=l_tlf10*l_c23c
          LET g_cch.cch22d=l_tlf10*l_c23d
          LET g_cch.cch22e=l_tlf10*l_c23e
          LET g_cch.cch22f=l_tlf10*l_c23f   #FUN-7C0028 add
          LET g_cch.cch22g=l_tlf10*l_c23g   #FUN-7C0028 add
          LET g_cch.cch22h=l_tlf10*l_c23h   #FUN-7C0028 add
       END IF
     END IF
     LET g_cch.cch22 =g_cch.cch22a+g_cch.cch22b+g_cch.cch22c+
                      g_cch.cch22d+g_cch.cch22e
                     +g_cch.cch22f+g_cch.cch22g+g_cch.cch22h   #FUN-7C0028 add
 
     #-->本期超領退 modify by apple
#超領退應為 asfi512&asfi527
     IF l_tlf13 = 'asfi512' OR l_tlf13 = 'asfi527' THEN
        LET g_cch.cch57 =l_tlf10
 
        IF l_zero = 1 THEN
           LET g_cch.cch58a=l_tlf10*l_c22a/l_c21
           LET g_cch.cch58b=l_tlf10*l_c22b/l_c21
           LET g_cch.cch58c=l_tlf10*l_c22c/l_c21
           LET g_cch.cch58d=l_tlf10*l_c22d/l_c21
           LET g_cch.cch58e=l_tlf10*l_c22e/l_c21
           LET g_cch.cch58f=l_tlf10*l_c22f/l_c21   #FUN-7C0028 add
           LET g_cch.cch58g=l_tlf10*l_c22g/l_c21   #FUN-7C0028 add
           LET g_cch.cch58h=l_tlf10*l_c22h/l_c21   #FUN-7C0028 add
        ELSE
          IF g_sma.sma43 = '1' THEN
             LET g_cch.cch58a=l_tlf221x   #CHI-910041
             LET g_cch.cch58b=l_tlf222x   #CHI-910041
             LET g_cch.cch58c=l_tlf2231x  #CHI-910041
             LET g_cch.cch58d=l_tlf2232x  #CHI-910041 
             LET g_cch.cch58e=l_tlf224x   #CHI-910041
             LET g_cch.cch58f=l_tlf2241x   #FUN-7C0028 add#CHI-910041
             LET g_cch.cch58g=l_tlf2242x   #FUN-7C0028 add#CHI-910041
             LET g_cch.cch58h=l_tlf2243x   #FUN-7C0028 add#CHI-910041
          ELSE
             LET g_cch.cch58a=l_tlf10*l_c23a
             LET g_cch.cch58b=l_tlf10*l_c23b
             LET g_cch.cch58c=l_tlf10*l_c23c
             LET g_cch.cch58d=l_tlf10*l_c23d
             LET g_cch.cch58e=l_tlf10*l_c23e
             LET g_cch.cch58f=l_tlf10*l_c23f   #FUN-7C0028 add
             LET g_cch.cch58g=l_tlf10*l_c23g   #FUN-7C0028 add
             LET g_cch.cch58h=l_tlf10*l_c23h   #FUN-7C0028 add
          END IF
        END IF
        LET g_cch.cch58 =g_cch.cch58a+g_cch.cch58b+g_cch.cch58c+
                         g_cch.cch58d+g_cch.cch58e
                        +g_cch.cch58f+g_cch.cch58g+g_cch.cch58h   #FUN-7C0028 add
 
        #-->累計超領退
         LET g_cch.cch55  = g_cch.cch57
         LET g_cch.cch56  = g_cch.cch58
         LET g_cch.cch56a = g_cch.cch58a
         LET g_cch.cch56b = g_cch.cch58b
         LET g_cch.cch56c = g_cch.cch58c
         LET g_cch.cch56d = g_cch.cch58d
         LET g_cch.cch56e = g_cch.cch58e
         LET g_cch.cch56f = g_cch.cch58f   #FUN-7C0028 add
         LET g_cch.cch56g = g_cch.cch58g   #FUN-7C0028 add
         LET g_cch.cch56h = g_cch.cch58h   #FUN-7C0028 add
     END IF
 
     #-->累計投入  modify by apple
     LET g_cch.cch51  =g_cch.cch51 +g_cch.cch21
     LET g_cch.cch52a =g_cch.cch52a+g_cch.cch22a
     LET g_cch.cch52b =g_cch.cch52b+g_cch.cch22b
     LET g_cch.cch52c =g_cch.cch52c+g_cch.cch22c
     LET g_cch.cch52d =g_cch.cch52d+g_cch.cch22d
     LET g_cch.cch52e =g_cch.cch52e+g_cch.cch22e
     LET g_cch.cch52f =g_cch.cch52f+g_cch.cch22f   #FUN-7C0028 add
     LET g_cch.cch52g =g_cch.cch52g+g_cch.cch22g   #FUN-7C0028 add
     LET g_cch.cch52h =g_cch.cch52h+g_cch.cch22h   #FUN-7C0028 add
     LET g_cch.cch52  =g_cch.cch52a+g_cch.cch52b+g_cch.cch52c+
                       g_cch.cch52d+g_cch.cch52e
                      +g_cch.cch52f+g_cch.cch52g+g_cch.cch52h   #FUN-7C0028 add
 
     LET g_cch.cchdate = g_today
    #LET g_cch.cchplant=g_plant #FUN-980009 add   #FUN-A50075
     LET g_cch.cchlegal=g_legal #FUN-980009 add
     LET g_cch.cchoriu = g_user      #No.FUN-980030 10/01/04
     LET g_cch.cchorig = g_grup      #No.FUN-980030 10/01/04
     INSERT INTO cch_file VALUES(g_cch.*)
     IF SQLCA.SQLCODE AND (NOT cl_sql_dup_value(SQLCA.SQLCODE)) THEN
        CALL cl_err3("ins","cch_file",g_cch.cch01,g_cch.cch02,STATUS,"","wip_2_21() ins cch:",1)   #No.FUN-660127
        LET g_msg=g_cch.cch01,g_cch.cch04
        CALL cl_err3("ins","cch_file",g_cch.cch01,g_cch.cch02,STATUS,"","",1)   #No.FUN-660127
     END IF
     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
        UPDATE cch_file SET cch05=g_cch.cch05,
                            cch21=cch21+g_cch.cch21,
                            cch22=cch22+g_cch.cch22,
                            cch22a=cch22a+g_cch.cch22a,
                            cch22b=cch22b+g_cch.cch22b,
                            cch22c=cch22c+g_cch.cch22c,
                            cch22d=cch22d+g_cch.cch22d,
                            cch22e=cch22e+g_cch.cch22e,
                            cch22f=cch22f+g_cch.cch22f,   #FUN-7C0028 add
                            cch22g=cch22g+g_cch.cch22g,   #FUN-7C0028 add
                            cch22h=cch22h+g_cch.cch22h,   #FUN-7C0028 add
                            cch51=cch51  +g_cch.cch21,    #modify by apple
                            cch52=cch52  +g_cch.cch22,
                            cch52a=cch52a+g_cch.cch22a,
                            cch52b=cch52b+g_cch.cch22b,
                            cch52c=cch52c+g_cch.cch22c,
                            cch52d=cch52d+g_cch.cch22d,
                            cch52e=cch52e+g_cch.cch22e,
                            cch52f=cch52f+g_cch.cch52f,   #FUN-7C0028 add
                            cch52g=cch52g+g_cch.cch52g,   #FUN-7C0028 add
                            cch52h=cch52h+g_cch.cch52h,   #FUN-7C0028 add
                            cch55 =cch55  +g_cch.cch55,    #modify by apple
                            cch56 =cch56  +g_cch.cch56,
                            cch56a=cch56a+g_cch.cch56a,
                            cch56b=cch56b+g_cch.cch56b,
                            cch56c=cch56c+g_cch.cch56c,
                            cch56d=cch56d+g_cch.cch56d,
                            cch56e=cch56e+g_cch.cch56e,
                            cch56f=cch56f+g_cch.cch56f,   #FUN-7C0028 add
                            cch56g=cch56g+g_cch.cch56g,   #FUN-7C0028 add
                            cch56h=cch56h+g_cch.cch56h,   #FUN-7C0028 add
                            cch57 =cch57+g_cch.cch57,     #modify by apple
                            cch58 =cch58+g_cch.cch58,
                            cch58a=cch58a+g_cch.cch58a,
                            cch58b=cch58b+g_cch.cch58b,
                            cch58c=cch58c+g_cch.cch58c,
                            cch58d=cch58d+g_cch.cch58d,
                            cch58e=cch58e+g_cch.cch58e,
                            cch58f=cch58f+g_cch.cch58f,   #FUN-7C0028 add
                            cch58g=cch58g+g_cch.cch58g,   #FUN-7C0028 add
                            cch58h=cch58h+g_cch.cch58h    #FUN-7C0028 add
            WHERE cch01=g_sfb.sfb01 AND cch02=yy AND cch03=mm
              AND cch04=l_tlf01
              AND cch06=type        AND cch07=l_tlfcost
     END IF
   END FOREACH
   CLOSE wip_c3
END FUNCTION
 
FUNCTION wip2_2_21()     #  2-1. WIP元件 本期投入材料 (依發料/退料檔)
   DEFINE l_ima08           LIKE ima_file.ima08    #No.FUN-680122CHAR(1)
   DEFINE l_ima57           LIKE ima_file.ima57    #No.FUN-680122SMALLINT
   DEFINE l_tlf01           LIKE tlf_file.tlf01    #No.MOD-490217
   DEFINE l_tlf02,l_tlf03   LIKE tlf_file.tlf02    #No.FUN-680122SMALLINT
   DEFINE l_tlf10           LIKE tlf_file.tlf10    #No.FUN-680122DEC(15,3)
   DEFINE l_tlf13           LIKE tlf_file.tlf13
   DEFINE l_tlfcost         LIKE tlf_file.tlfcost
#  DEFINE l_c21                                    LIKE ima_file.ima26      #No.FUN-680122DEC(15,5)
   DEFINE l_c21                                    LIKE type_file.num15_3   ###GP5.2  #NO.FUN-A40023
   DEFINE l_c22,l_c22a,l_c22b,l_c22c,l_c22d,l_c22e LIKE type_file.num20_6   #No.FUN-680122DEC(20,6) # No.7088.A.a #MOD-4C0005
   DEFINE l_c22f,l_c22g,l_c22h                     LIKE type_file.num20_6   #FUN-7C0028 add
   DEFINE l_c23,l_c23a,l_c23b,l_c23c,l_c23d,l_c23e LIKE type_file.num20_6   #No.FUN-680122DEC(20,6) # No.7088.A.a #MOD-4C0005
   DEFINE l_c23f,l_c23g,l_c23h                     LIKE type_file.num20_6   #FUN-7C0028 add
   DEFINE l_tlf62                                  LIKE tlf_file.tlf62
   DEFINE l_sfa161                                 LIKE sfa_file.sfa161
   DEFINE l_tlf21x,l_tlf221x,l_tlf222x,l_tlf2231x      LIKE tlf_file.tlf21  #CHI-910041 tlf21-->tlf21x
   DEFINE l_tlf2232x,l_tlf224x                       LIKE tlf_file.tlf21      #No.A102 #CHI-910041
   DEFINE l_tlf2241x,l_tlf2242x,l_tlf2243x            LIKE tlf_file.tlf21      #No.A102#CHI-910041
   DEFINE l_zero                                   LIKE type_file.num5      #No.FUN-680122SMALLINT # 尾差判斷
 
   DECLARE wip2_c3 CURSOR FOR    
     #SELECT tlf01,tlfcost,ima08,ima57,tlf02,tlf03,tlf13,SUM(tlf10*tlf60*tlf907*-1),               #MOD-B50083 mark
      SELECT tlf01,tlfcost,ima08,ima57,tlf02,tlf03,tlf13,SUM(ROUND((tlf10*tlf60*tlf907*-1),3)),    #MOD-B50083 add
             SUM(tlf21*tlf907*-1),SUM(tlf221*tlf907*-1),SUM(tlf222*tlf907*-1),
             SUM(tlf2231*tlf907*-1),SUM(tlf2232*tlf907*-1),SUM(tlf224*tlf907*-1)
            ,SUM(tlf2241*tlf907*-1),SUM(tlf2242*tlf907*-1),SUM(tlf2243*tlf907*-1)
              FROM tlf_file,ima_file
             WHERE tlf62=g_ima01 AND tlf06 BETWEEN g_bdate AND g_edate
               AND ((tlf02=50 AND ( tlf03 BETWEEN 60 AND 69 OR tlf03 =18)) OR
                    (tlf03=50 AND tlf02 BETWEEN 60 AND 69))
               AND tlf01=ima01 AND tlf10<>0
               AND tlf13 LIKE    'asri2%'   #
               #AND tlf902 NOT IN(SELECT jce02 FROM jce_file) #No:7888 #CHI-C80002
               AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = tlf902) #CHI-C80002
               AND tlf907 != 0 
             GROUP BY tlf01,tlfcost,ima08,ima57,tlf02,tlf03,tlf13	 
   FOREACH wip2_c3 INTO l_tlf01,l_tlfcost,l_ima08,l_ima57,l_tlf02,l_tlf03,l_tlf13,l_tlf10, #No.TQC-970003
                        l_tlf21x,l_tlf221x,l_tlf222x,l_tlf2231x,l_tlf2232x,l_tlf224x   #No.A102 ##CHI-910041 
                       ,l_tlf2241x,l_tlf2242x,l_tlf2243x   #FUN-7C0028 add #CHI-910041
     IF SQLCA.sqlcode THEN
       CALL cl_err('wip2_c3',SQLCA.sqlcode,0)   
        EXIT FOREACH
     END IF
     IF l_ima08 IS NULL THEN LET l_ima08='P' END IF
     IF l_tlf01=g_ima01 THEN LET l_ima08='R' END IF     #主/元料號同表重工
     IF l_ima57 = g_ima57_t THEN LET l_ima08='R' END IF #成本階相等表重工
     IF l_ima57 < g_ima57_t THEN LET l_ima08='W' END IF #成本階較低表上階重工
     LET l_c23=0
     LET l_c23a=0 LET l_c23b=0 LET l_c23c=0 LET l_c23d=0 LET l_c23e=0
     LET l_c23f=0 LET l_c23g=0 LET l_c23h=0   #FUN-7C0028 add
     #抓當期材料單價
     SELECT ccc23a,ccc23b,ccc23c,ccc23d,ccc23e,
            ccc23f,ccc23g,ccc23h,ccc23   #FUN-7C0028 add ccc23f,g,h
       INTO l_c23a,l_c23b,l_c23c,l_c23d,l_c23e,
            l_c23f,l_c23g,l_c23h,l_c23   #FUN-7C0028 add l_c23f,g,h
       FROM ccc_file
      WHERE ccc01=l_tlf01 AND ccc02=yy AND ccc03=mm
        AND ccc07=type    AND ccc08=l_tlfcost
 
     CALL p500_cch_01() # 將 cch 歸 0
     LET g_cch.cch01  =g_ima01
     LET g_cch.cch04  =l_tlf01
     LET g_cch.cch06  =type        #FUN-7C0028 add
     LET g_cch.cch07  =l_tlfcost
     IF l_ima08 = 'W' THEN LET l_ima08='R' END IF
     LET g_cch.cch05  =l_ima08
     LET g_cch.cch21  =l_tlf10
     LET g_cch.cch22a =l_tlf10*l_c23a
     LET g_cch.cch22b =l_tlf10*l_c23b
     LET g_cch.cch22c =l_tlf10*l_c23c
     LET g_cch.cch22d =l_tlf10*l_c23d
     LET g_cch.cch22e =l_tlf10*l_c23e
     LET g_cch.cch22f =l_tlf10*l_c23f   #FUN-7C0028 add
     LET g_cch.cch22g =l_tlf10*l_c23g   #FUN-7C0028 add
     LET g_cch.cch22h =l_tlf10*l_c23h   #FUN-7C0028 add
     LET g_cch.cch22  =g_cch.cch22a+g_cch.cch22b+g_cch.cch22c+
                       g_cch.cch22d+g_cch.cch22e
                      +g_cch.cch22f+g_cch.cch22g+g_cch.cch22h   #FUN-7C0028 add
 
     #-->本期超領退 modify by apple
     LET g_cch.cch51  =g_cch.cch51 +g_cch.cch21
     LET g_cch.cch52a =g_cch.cch52a+g_cch.cch22a
     LET g_cch.cch52b =g_cch.cch52b+g_cch.cch22b
     LET g_cch.cch52c =g_cch.cch52c+g_cch.cch22c
     LET g_cch.cch52d =g_cch.cch52d+g_cch.cch22d
     LET g_cch.cch52e =g_cch.cch52e+g_cch.cch22e
     LET g_cch.cch52f =g_cch.cch52f+g_cch.cch22f   #FUN-7C0028 add
     LET g_cch.cch52g =g_cch.cch52g+g_cch.cch22g   #FUN-7C0028 add
     LET g_cch.cch52h =g_cch.cch52h+g_cch.cch22h   #FUN-7C0028 add
     LET g_cch.cch52  =g_cch.cch52a+g_cch.cch52b+g_cch.cch52c+
                       g_cch.cch52d+g_cch.cch52e
                      +g_cch.cch52f+g_cch.cch52g+g_cch.cch52h   #FUN-7C0028 add
 
     LET g_cch.cchdate = g_today
    #LET g_cch.cchplant=g_plant #FUN-980009 add   #FUN-A50075
     LET g_cch.cchlegal=g_legal #FUN-980009 add
     LET g_cch.cchoriu = g_user      #No.FUN-980030 10/01/04
     LET g_cch.cchorig = g_grup      #No.FUN-980030 10/01/04
     INSERT INTO cch_file VALUES(g_cch.*)
     IF SQLCA.SQLCODE AND (NOT cl_sql_dup_value(SQLCA.SQLCODE)) THEN
        CALL cl_err3("ins","cch_file",g_cch.cch01,g_cch.cch02,STATUS,"","wip2_2_21() ins cch:",1)   #No.FUN-660127
        LET g_msg=g_cch.cch01,g_cch.cch04
        CALL cl_err3("ins","cch_file",g_cch.cch01,g_cch.cch02,STATUS,"","",1)   #No.FUN-660127
     END IF
     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
        UPDATE cch_file SET cch05 =g_cch.cch05,
                            cch21 =cch21 +g_cch.cch21,
                            cch22 =cch22 +g_cch.cch22,
                            cch22a=cch22a+g_cch.cch22a,
                            cch22b=cch22b+g_cch.cch22b,
                            cch22c=cch22c+g_cch.cch22c,
                            cch22d=cch22d+g_cch.cch22d,
                            cch22e=cch22e+g_cch.cch22e,
                            cch22f=cch22f+g_cch.cch22f,   #FUN-7C0028 add
                            cch22g=cch22g+g_cch.cch22g,   #FUN-7C0028 add
                            cch22h=cch22h+g_cch.cch22h,   #FUN-7C0028 add 
                            cch51 =cch51 +g_cch.cch21,    #modify by apple
                            cch52 =cch52 +g_cch.cch22,
                            cch52a=cch52a+g_cch.cch22a,
                            cch52b=cch52b+g_cch.cch22b,
                            cch52c=cch52c+g_cch.cch22c,
                            cch52d=cch52d+g_cch.cch22d,
                            cch52e=cch52e+g_cch.cch22e,
                            cch52f=cch52f+g_cch.cch22f,   #FUN-7C0028 add
                            cch52g=cch52g+g_cch.cch22g,   #FUN-7C0028 add
                            cch52h=cch52h+g_cch.cch22h,   #FUN-7C0028 add 
                            cch55 =cch55 +g_cch.cch55,    #modify by apple
                            cch56 =cch56 +g_cch.cch56,
                            cch56a=cch56a+g_cch.cch56a,
                            cch56b=cch56b+g_cch.cch56b,
                            cch56c=cch56c+g_cch.cch56c,
                            cch56d=cch56d+g_cch.cch56d,
                            cch56e=cch56e+g_cch.cch56e,
                            cch56f=cch56f+g_cch.cch56f,   #FUN-7C0028 add
                            cch56g=cch56g+g_cch.cch56g,   #FUN-7C0028 add
                            cch56h=cch56h+g_cch.cch56h,   #FUN-7C0028 add 
                            cch57 =cch57 +g_cch.cch57,     #modify by apple
                            cch58 =cch58 +g_cch.cch58,
                            cch58a=cch58a+g_cch.cch58a,
                            cch58b=cch58b+g_cch.cch58b,
                            cch58c=cch58c+g_cch.cch58c,
                            cch58d=cch58d+g_cch.cch58d,
                            cch58e=cch58e+g_cch.cch58e,
                            cch58f=cch58f+g_cch.cch58f,   #FUN-7C0028 add
                            cch58g=cch58g+g_cch.cch58g,   #FUN-7C0028 add
                            cch58h=cch58h+g_cch.cch58h    #FUN-7C0028 add 
            WHERE cch01=g_ima01 AND cch02=yy AND cch03=mm
              AND cch04=l_tlf01
              AND cch06=type    AND cch07=l_tlfcost
     END IF
   END FOREACH
   CLOSE wip2_c3
END FUNCTION
 
FUNCTION wip_2_22()      #  2-2. WIP-元件 本期投入人工製費
  DEFINE  l_cch22b  LIKE cch_file.cch22b
  DEFINE  l_cch22c  LIKE cch_file.cch22c
  DEFINE  l_cch22e  LIKE cch_file.cch22e     #FUN-7C0028 add
  DEFINE  l_cch22f  LIKE cch_file.cch22f     #FUN-7C0028 add
  DEFINE  l_cch22g  LIKE cch_file.cch22g     #FUN-7C0028 add
  DEFINE  l_cch22h  LIKE cch_file.cch22h     #FUN-7C0028 add
  DEFINE  l_ecm04   LIKE ecm_file.ecm04
  DEFINE  l_ccg20   LIKE ccg_file.ccg20
  DEFINE  l_dept    LIKE cre_file.cre08      #No.FUN-680122CHAR(10)
  DEFINE  l_sql     LIKE type_file.chr1000   #No.FUN-680122CHAR(400) 
  DEFINE  l_ccj02   LIKE ccj_file.ccj02
  DEFINE  l_ccj05   LIKE ccj_file.ccj05
  DEFINE  l_cdc05_1 LIKE cdc_file.cdc05      #FUN-7C0028 add
  DEFINE  l_cdc05_2 LIKE cdc_file.cdc05      #FUN-7C0028 add
  DEFINE  l_cdc05_3 LIKE cdc_file.cdc05      #FUN-7C0028 add
  DEFINE  l_cdc05_4 LIKE cdc_file.cdc05      #FUN-7C0028 add
  DEFINE  l_cdc05_5 LIKE cdc_file.cdc05      #FUN-7C0028 add
  DEFINE  l_cdc05_6 LIKE cdc_file.cdc05      #FUN-7C0028 add
  DEFINE  x_flag    LIKE type_file.chr1      #No:CHI-A90033 add
  DEFINE  l_tlf13   LIKE tlf_file.tlf13      #No:CHI-A90033 add
  DEFINE  l_tlf905  LIKE tlf_file.tlf905     #No:CHI-A90033 add
  DEFINE  l_tlf906  LIKE tlf_file.tlf906     #No:CHI-A90033 add
  DEFINE  l_pmm42   LIKE pmm_file.pmm42      #No:CHI-A90033 add
  DEFINE  l_rvv     RECORD LIKE rvv_file.*   #No:CHI-A90033 add
  DEFINE  l_rvu114  LIKE rvu_file.rvu114     #FUN-BB0063
  DEFINE  l_rvv39   LIKE rvv_file.rvv39      #FUN-BB0063
  DEFINE  l_tlf01   LIKE tlf_file.tlf01      #No:MOD-B80246 add
  DEFINE  l_cnt     LIKE type_file.num5      #No:MOD-B80246 add
  DEFINE     l_wc_jce   STRING               #FUN-C50009
  
   CALL p500_cch_01()   # 將 cch 歸 0
   LET g_cch.cch01 =g_sfb.sfb01
   LET g_cch.cch04 =' DL+OH+SUB'        # 料號為 ' DL+OH+SUB'
   LET g_cch.cch05 ='P'
   LET g_cch.cch06 =type        #FUN-7C0028 add
   LET g_cch.cch07 =g_tlfcost   #FUN-7C0028 add
   LET g_cch.cch21 =mccg.ccg20
  #MOD-C50084 -- mark start --
  ##------------------------------------------------------------
  ##-->依年月
  #IF g_ccz.ccz06 = '1' THEN
 
  #  #人工、製費一、製費二、製費三、製費四、製費五金額改抓cdc_file
  #   LET l_cdc05_1=0  LET l_cdc05_2=0  LET l_cdc05_3=0
  #   LET l_cdc05_4=0  LET l_cdc05_5=0  LET l_cdc05_6=0
 
  #   CALL wip_2_22_cdc(yy,mm,' ',g_sfb.sfb01) 
  #        RETURNING l_cdc05_1,l_cdc05_2,l_cdc05_3,
  #                  l_cdc05_4,l_cdc05_5,l_cdc05_6
 
  #   #工單投入工時
  #   SELECT SUM(ccj05) INTO l_ccj05 FROM cci_file,ccj_file
  #    WHERE cci01 = ccj01
  #      AND cci02 = ccj02
  #      AND cci01 BETWEEN g_bdate AND g_edate
  #      AND ccj04 = g_sfb.sfb01
  #      AND ccifirm = 'Y'         #MOD-B30728 add
  #   #-->總時數
  #  #------------------No:MOD-A10036 mark
  #  #LET g_tothour = g_tothour + mccg.ccg20
  #  #IF l_ccj05 > 0 THEN
  #  #   IF g_tothour >= l_ccj05 THEN
  #  #    #No.MOD-940063--begin-- #并單處理，請查詢TQC-940024
  #  #    #LET g_cch.cch22b=l_cdc05_1 - g_totdl    # 人工成本
  #  #    #LET g_cch.cch22c=l_cdc05_2 - g_totoh1   # 製費一成本
  #  #    #LET g_cch.cch22e=l_cdc05_3 - g_totoh2   # 製費二成本
  #  #    #LET g_cch.cch22f=l_cdc05_4 - g_totoh3   # 製費三成本
  #  #    #LET g_cch.cch22g=l_cdc05_5 - g_totoh4   # 製費四成本
  #  #    #LET g_cch.cch22h=l_cdc05_6 - g_totoh5   # 製費五成本
  #  #------------------No:MOD-A10036 end

  #  #------------------No:MOD-A10036 add
  #        LET g_cch.cch22b=l_cdc05_1   # 人工成本
  #        LET g_cch.cch22c=l_cdc05_2   # 製費一成本
  #        LET g_cch.cch22e=l_cdc05_3   # 製費二成本
  #        LET g_cch.cch22f=l_cdc05_4   # 製費三成本
  #        LET g_cch.cch22g=l_cdc05_5   # 製費四成本
  #        LET g_cch.cch22h=l_cdc05_6   # 製費五成本
  #  #------------------No:MOD-A10036 end

  #        LET g_tothour = 0
  #        LET g_totdl   = 0
  #        LET g_totoh1  = 0   #FUN-7C0028 add
  #        LET g_totoh2  = 0   #FUN-7C0028 add
  #        LET g_totoh3  = 0   #FUN-7C0028 add
  #        LET g_totoh4  = 0   #FUN-7C0028 add
  #        LET g_totoh5  = 0   #FUN-7C0028 add
  #  #------------------No:MOD-A10036 mark
  #  #   ELSE
  #  #     LET g_cch.cch22b=mccg.ccg20*l_cdc05_1/l_ccj05  # 人工成本
  #  #     LET g_cch.cch22c=mccg.ccg20*l_cdc05_2/l_ccj05  # 製費一成本
  #  #     LET g_cch.cch22e=mccg.ccg20*l_cdc05_3/l_ccj05  # 製費二成本
  #  #     LET g_cch.cch22f=mccg.ccg20*l_cdc05_4/l_ccj05  # 製費三成本
  #  #     LET g_cch.cch22g=mccg.ccg20*l_cdc05_5/l_ccj05  # 製費四成本
  #  #     LET g_cch.cch22h=mccg.ccg20*l_cdc05_6/l_ccj05  # 製費五成本
  #  #   END IF
  #  #END IF
  #  #------------------No:MOD-A10036 end
  #   IF cl_null(g_cch.cch22b) THEN LET g_cch.cch22b= 0 END IF
  #   IF cl_null(g_cch.cch22c) THEN LET g_cch.cch22c= 0 END IF
  #   IF cl_null(g_cch.cch22e) THEN LET g_cch.cch22e= 0 END IF   #FUN-7C0028 add
  #   IF cl_null(g_cch.cch22f) THEN LET g_cch.cch22f= 0 END IF   #FUN-7C0028 add
  #   IF cl_null(g_cch.cch22g) THEN LET g_cch.cch22g= 0 END IF   #FUN-7C0028 add
  #   IF cl_null(g_cch.cch22h) THEN LET g_cch.cch22h= 0 END IF   #FUN-7C0028 add
  #   #-->人工、製費一、製費二、製費三、製費四、製費五
  #   LET g_totdl  = g_totdl  + g_cch.cch22b
  #   LET g_totoh1 = g_totoh1 + g_cch.cch22c   #FUN-7C0028 add
  #   LET g_totoh2 = g_totoh2 + g_cch.cch22e   #FUN-7C0028 add
  #   LET g_totoh3 = g_totoh3 + g_cch.cch22f   #FUN-7C0028 add
  #   LET g_totoh4 = g_totoh4 + g_cch.cch22g   #FUN-7C0028 add
  #   LET g_totoh5 = g_totoh5 + g_cch.cch22h   #FUN-7C0028 add
  #END IF
  #
  ##-->依成本中心
  #IF g_ccz.ccz06 = '2' THEN
 
#成本中心以axct200-ccj02為主
  #   DECLARE wip_sum_ccj CURSOR FOR
  #    SELECT ccj02,SUM(ccj05) FROM cci_file,ccj_file
  #     WHERE cci01 = ccj01
  #       AND cci02 = ccj02
  #       AND cci01 BETWEEN g_bdate AND g_edate
  #       AND ccj04 = g_sfb.sfb01
  #       AND ccifirm = 'Y'         #MOD-B30728 add
  #     GROUP BY ccj02
 
  #   LET g_cch.cch22b = 0  LET g_cch.cch22c = 0
  #   LET g_cch.cch22e = 0  LET g_cch.cch22f = 0   #FUN-7C0028 add
  #   LET g_cch.cch22g = 0  LET g_cch.cch22h = 0   #FUN-7C0028 add
  #   FOREACH wip_sum_ccj INTO l_ccj02,l_ccj05
  #     IF SQLCA.sqlcode THEN
  #        CALL cl_err('wip_sum_ccj',SQLCA.sqlcode,0)   
  #        EXIT FOREACH
  #     END IF
 
  #    #人工、製費一、製費二、製費三、製費四、製費五金額改抓cdc_file
  #     LET l_cdc05_1=0  LET l_cdc05_2=0  LET l_cdc05_3=0
  #     LET l_cdc05_4=0  LET l_cdc05_5=0  LET l_cdc05_6=0
 
  #     CALL wip_2_22_cdc(yy,mm,l_ccj02,g_sfb.sfb01) 
  #          RETURNING l_cdc05_1,l_cdc05_2,l_cdc05_3,
  #                    l_cdc05_4,l_cdc05_5,l_cdc05_6
  #    #應并單處理，該問題請查詢TQC-940024
 
  #     LET g_cch.cch22b=g_cch.cch22b+l_cdc05_1  # 人工成本
  #     LET g_cch.cch22c=g_cch.cch22c+l_cdc05_2  # 製費一成本
  #     LET g_cch.cch22e=g_cch.cch22e+l_cdc05_3  # 製費二成本
  #     LET g_cch.cch22f=g_cch.cch22f+l_cdc05_4  # 製費三成本
  #     LET g_cch.cch22g=g_cch.cch22g+l_cdc05_5  # 製費四成本
  #     LET g_cch.cch22h=g_cch.cch22h+l_cdc05_6  # 製費五成本
  #   END FOREACH
  #   IF cl_null(g_cch.cch22b) THEN LET g_cch.cch22b= 0 END IF
  #   IF cl_null(g_cch.cch22c) THEN LET g_cch.cch22c= 0 END IF
  #   IF cl_null(g_cch.cch22e) THEN LET g_cch.cch22e= 0 END IF   #FUN-7C0028 add
  #   IF cl_null(g_cch.cch22f) THEN LET g_cch.cch22f= 0 END IF   #FUN-7C0028 add
  #   IF cl_null(g_cch.cch22g) THEN LET g_cch.cch22g= 0 END IF   #FUN-7C0028 add
  #   IF cl_null(g_cch.cch22h) THEN LET g_cch.cch22h= 0 END IF   #FUN-7C0028 add
  #END IF
 
  ##-->依製程序區分
  #IF g_ccz.ccz06 = '3' OR g_ccz.ccz06 = '4' THEN
  #   IF g_ccz.ccz06 = '3' THEN
  #      LET l_sql = "SELECT unique ecm04 FROM ecm_file,sfb_file",
  #                  "  WHERE ecm01 = '",g_sfb.sfb01,"'",
  #                  "    AND ecm01 = sfb01  "
  #   ELSE
  #      LET l_sql = "SELECT unique ecm06 FROM ecm_file,sfb_file",
  #                  "  WHERE ecm01 = '",g_sfb.sfb01,"'",
  #                  "    AND ecm01 = sfb01  "
  #   END IF
 
  #   PREPARE wip_pre_ecm FROM l_sql
  #   DECLARE wip_cur_ecm  CURSOR FOR wip_pre_ecm
  #   FOREACH wip_cur_ecm INTO l_dept
  #       IF SQLCA.sqlcode THEN
  #          CALL cl_err('wip_cur_ecm',SQLCA.sqlcode,0)
  #          EXIT FOREACH
  #       END IF
 
  #       SELECT sum(ccj05) INTO l_ccg20 FROM cci_file,ccj_file
  #        WHERE ccj04 = g_sfb.sfb01
  #          AND cci01 = ccj01 AND cci02 = ccj02
  #          AND cci01 BETWEEN g_bdate AND g_edate
  #          AND cci02 = l_dept
  #          AND ccifirm = 'Y'         #MOD-B30728 add
  #        IF cl_null(l_ccg20) THEN LET l_ccg20 = 0 END IF
 
  #       #MOD-C20130 str mark-----
  #       #LET l_cch22b=l_ccg20*g_cck.cck03/g_cck.cck05       # 人工成本
  #       #LET l_cch22c=l_ccg20*g_cck.cck04/g_cck.cck05       # 製費成本
  #       #IF l_cch22b IS NULL THEN LET l_cch22b = 0 END IF
  #       #IF l_cch22c IS NULL THEN LET l_cch22c = 0 END IF
  #       #LET g_cch.cch22b=g_cch.cch22b + l_cch22b
  #       #LET g_cch.cch22c=g_cch.cch22c + l_cch22c
  #       #MOD-C20130 end mark-----
 
  #       #人工、製費一、製費二、製費三、製費四、製費五金額改抓cdc_file
  #        LET l_cdc05_1=0  LET l_cdc05_2=0  LET l_cdc05_3=0
  #        LET l_cdc05_4=0  LET l_cdc05_5=0  LET l_cdc05_6=0
 
  #        CALL wip_2_22_cdc(yy,mm,l_dept,g_sfb.sfb01) 
  #             RETURNING l_cdc05_1,l_cdc05_2,l_cdc05_3,
  #                       l_cdc05_4,l_cdc05_5,l_cdc05_6
 
  #        LET l_cch22b=l_ccg20*l_cdc05_1/l_ccj05       # 人工成本
  #        LET l_cch22c=l_ccg20*l_cdc05_2/l_ccj05       # 製費一成本
  #        LET l_cch22e=l_ccg20*l_cdc05_3/l_ccj05       # 製費二成本
  #        LET l_cch22f=l_ccg20*l_cdc05_4/l_ccj05       # 製費三成本
  #        LET l_cch22g=l_ccg20*l_cdc05_5/l_ccj05       # 製費四成本
  #        LET l_cch22h=l_ccg20*l_cdc05_6/l_ccj05       # 製費五成本
 
  #        IF cl_null(l_cch22b) THEN LET l_cch22b= 0 END IF
  #        IF cl_null(l_cch22c) THEN LET l_cch22c= 0 END IF
  #        IF cl_null(l_cch22e) THEN LET l_cch22e= 0 END IF
  #        IF cl_null(l_cch22f) THEN LET l_cch22f= 0 END IF
  #        IF cl_null(l_cch22g) THEN LET l_cch22g= 0 END IF
  #        IF cl_null(l_cch22h) THEN LET l_cch22h= 0 END IF
 
  #        LET g_cch.cch22b=g_cch.cch22b+l_cch22b  # 人工成本
  #        LET g_cch.cch22c=g_cch.cch22c+l_cch22c  # 製費一成本
  #        LET g_cch.cch22e=g_cch.cch22e+l_cch22e  # 製費二成本
  #        LET g_cch.cch22f=g_cch.cch22f+l_cch22f  # 製費三成本
  #        LET g_cch.cch22g=g_cch.cch22g+l_cch22g  # 製費四成本
  #        LET g_cch.cch22h=g_cch.cch22h+l_cch22h  # 製費五成本
  #   END FOREACH
  #END IF
  #MOD-C50084 -- mark end -- 
 
  #MOD-C50084 -- start -- 
  #人工、製費一、製費二、製費三、製費四、製費五金額抓cdc_file
   LET l_cdc05_1=0  LET l_cdc05_2=0  LET l_cdc05_3=0
   LET l_cdc05_4=0  LET l_cdc05_5=0  LET l_cdc05_6=0
  
   CALL wip_2_22_cdc(yy,mm,g_sfb.sfb01) 
        RETURNING l_cdc05_1,l_cdc05_2,l_cdc05_3,
                  l_cdc05_4,l_cdc05_5,l_cdc05_6
  
   LET g_cch.cch22b = l_cdc05_1 # 人工成本
   LET g_cch.cch22c = l_cdc05_2 # 製費一成本
   LET g_cch.cch22e = l_cdc05_3 # 製費二成本
   LET g_cch.cch22f = l_cdc05_4 # 製費三成本 
   LET g_cch.cch22g = l_cdc05_5 # 製費四成本  
   LET g_cch.cch22h = l_cdc05_6 # 製費五成本   
  #MOD-C50084 -- end --
 
   LET x_flag = 'N'    #No:CHI-A90033 add
  #----------------No:MOD-B40029 modify
  #LET l_sql=
  #"SELECT SUM(ABS(apb101))            ",
  #"  FROM pmn_file,apb_file,apa_file,rvv_file  ",# 委外退貨
  #"   WHERE pmn41='",g_sfb.sfb01,"' AND pmn04='",g_sfb.sfb05,"' ",  # 剔除代買料
  #"     AND pmn01=apb06 AND pmn02=apb07 AND apb29 = '1' ",
  #"     AND apb21=rvv01 AND apb22=rvv02  ",
  #"     AND apb01 = apa01 AND (apa00 = '11' OR apa00='16')  ",
  #"     AND apa02 BETWEEN '",g_bdate,"' AND '",g_edate,"'   ",
  #"     AND rvv09 BETWEEN '",g_bdate,"' AND '",g_edate,"' ",
  #"     AND apa42 = 'N'    ",
  #"     AND apb34 <> 'Y'   " 

   LET l_sql=
   "SELECT SUM(ABS(apb101))                     ",
   "  FROM apa_file,apb_file,pmn_file  ",                  #No:MOD-B80246 add pmn_file
  #---------No:MOD-B80246 modify
  #"  WHERE apb12='",g_sfb.sfb05,"'  ", # 剔除代買料
   "  WHERE pmn41 = '",g_sfb.sfb01,"' AND pmn04 ='",g_sfb.sfb05,"' ", # 剔除代買料
   "     AND pmn01=apb06 AND pmn02=apb07 ",
  #---------No:MOD-B80246 end
   "     AND apb29 = '1' ",
   "     AND apb21=? AND apb22=?                ",
   "     AND apb01 = apa01 AND (apa00 = '11' OR apa00='16')  ",
   "     AND apa02 BETWEEN '",g_bdate,"' AND '",g_edate,"'   ",
   "     AND apa42 = 'N' ",      
   "     AND apb34 <> 'Y'                          "
  #----------------No:MOD-B40029 end
   PREPARE amt1a_pre FROM l_sql
   DECLARE amt1a_cs CURSOR FOR amt1a_pre
  #------------------No:MOD-B40029 mark
  #OPEN amt1a_cs
  #FETCH amt1a_cs INTO amt
  #IF NOT cl_null(amt)  THEN LET x_flag = 'Y' END IF    #No:CHI-A90033 add
  #CLOSE amt1a_cs
  #------------------No:MOD-B40029 end
 
 
  #----------------No:MOD-B40029 modify
  #LET l_sql=
  #"SELECT SUM(ABS(apb101))            ",
  #"  FROM pmn_file,apb_file,apa_file,rvv_file  ",# 委外退貨
  #"   WHERE pmn41='",g_sfb.sfb01,"' AND pmn04='",g_sfb.sfb05,"' ",  # 剔除代買料
  #"     AND pmn01=apb06 AND pmn02=apb07 AND apb29 = '3' ",
  #"     AND apb21=rvv01 AND apb22=rvv02  ",
  #"     AND rvv09 BETWEEN '",g_bdate,"' AND '",g_edate,"' ",
  #"     AND apb01 = apa01  ",
  #"     AND apa42 = 'N'    ",
  #"     AND (apa58 = '2'  OR apa58 ='3')  ",   #No:CHI-910019 modify 
  #"     AND apb34 <> 'Y'   " 

   LET l_sql=
   "SELECT SUM(ABS(apb101))            ",
   "  FROM apb_file,apa_file,pmn_file  ",# 委外退貨      #No:MOD-B80246 add pmn_file
  #---------No:MOD-B80246 modify
  #"  WHERE apb12='",g_sfb.sfb05,"'  ", # 剔除代買料
   "  WHERE pmn41 = '",g_sfb.sfb01,"' AND pmn04 ='",g_sfb.sfb05,"' ", # 剔除代買料
   "     AND pmn01=apb06 AND pmn02=apb07 ",
  #---------No:MOD-B80246 end
   "     AND apb29 = '3' ",
   "     AND apb21=? AND apb22=?  ",
   "     AND apa02 BETWEEN '",g_bdate,"' AND '",g_edate,"'   ",
   "     AND apb01 = apa01  ",
   "     AND apa42 = 'N'    ",
   "     AND (apa58 = '2'  OR apa58 ='3'  OR apa58 IS NULL)  ",   #No.TQC-CC0145
   "     AND apb34 <> 'Y'   " 
  #----------------No:MOD-B40029 end
 
   PREPARE amt2a_pre FROM l_sql
   DECLARE amt2a_cs CURSOR FOR amt2a_pre
  #------------------No:MOD-B40029 mark
  #OPEN amt2a_cs
  #FETCH amt2a_cs INTO amt2
  #IF NOT cl_null(amt2) THEN LET x_flag = 'Y' END IF    #No:CHI-A90033 add
  #CLOSE amt2a_cs
  #------------------No:MOD-B40029 end
 
 #-----------------------No:MOD-B40029 mark
  #IF amt  IS NULL THEN LET amt =0 END IF
  #IF amt2 IS NULL THEN LET amt2=0 END IF
  #LET g_cch.cch22d = amt - amt2                                # 委外加工成本
  #----------------------No:CHI-A90033 add
  #IF x_flag = 'N' THEN   
 #-----------------------No:MOD-B40029 end
       #FUN-C50009---begin
       IF NOT s_industry('icd') THEN
          #LET l_wc_jce = "   AND tlf902 NOT IN (SELECT jce02 FROM jce_file)"  #CHI-C80002
          LET l_wc_jce = "   AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = tlf902)"  #CHI-C80002
       ELSE
          LET l_wc_jce = "   AND 1=1"
       END IF
       #FUN-C50009---end
       LET l_sql = " SELECT tlf01,tlf905,tlf906,tlf13 FROM tlf_file ",     #No:MOD-B80246 add tlf01
                 #-------------No:MOD-B80246 modify
                 #"  WHERE tlf01 = '",g_sfb.sfb05,"'",
                 #"   AND tlf62 = '",g_sfb.sfb01,"'",
                  "  WHERE tlf62 = '",g_sfb.sfb01,"'",
                 #-------------No:MOD-B80246 end
                  "   AND tlf06 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
                  #"   AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",  #FUN-C50009
                  l_wc_jce CLIPPED,  #FUN-C50009
                  "   AND tlf907 != 0 ",
                  "   AND (tlf13 = 'apmt230' OR tlf13 = 'asft6201') " ,      #No:MOD-B90037 add ,
                 #---------------------No:MOD-B90037 add
                 #製程委外
                  " UNION ",
                  " SELECT rvv31,rvv01,rvv02,'apmt730' FROM rvv_file,rvu_file,sfb_file ",
                  "   WHERE rvv01 = rvu01 AND rvv18 = sfb01 ",
                  "     AND rvuconf = 'Y' ",
                  "     AND rvu03 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
                  "     AND sfb01 = '",g_sfb.sfb01,"'",
                  "     AND sfb93 = 'Y' ",  
                  "     AND sfb02 NOT IN ('7','8') ",    #MOD-L30003
                 #"     AND (NOT rvu00 = '3' AND rvu08 ='SUB')"  #FUN-BB0063 add 排除委外倉退金額(apmt732)         #MOD-C30756 mark
                  "     AND (NOT rvu00 IN ('2','3') AND rvu08 ='SUB')",  #FUN-BB0063 add 排除委外倉退金額(apmt732)  #MOD-C30756 add
                 #---------------------No:MOD-B90037 end
                 #"     AND NOT (rvu00 IN ('2','3') AND rvu08 ='SUB' AND rvu116<> '3')"  #No.14021301 #委外仓退折让金额不排除,待讨论                 
                 #MOD-E50052-Start-Add
                 #製程委外倉退,委外仓退折让金额应该加入，否则当月加工费算出有误axcq100和axcq700不平
                  " UNION ",
                  " SELECT rvv31,rvv01,rvv02,'apmt732' FROM rvv_file,rvu_file,sfb_file ",   
                  "   WHERE rvv01 = rvu01 AND rvv18 = sfb01 ",
                  "     AND rvuconf = 'Y' ",
                  "     AND rvu03 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
                  "     AND sfb01 = '",g_sfb.sfb01,"'",
                  "     AND sfb93 = 'Y' ", 
                  "     AND sfb02 NOT IN ('7','8') ",    #MOD-L30003 
                  "     AND (rvu00 = '3' AND rvu08 ='SUB')" 
                 #MOD-E50052-End-Add                 
      PREPARE atm3a_pre FROM l_sql
      DECLARE atm3a_cs CURSOR FOR atm3a_pre
      LET amt  = 0
      FOREACH atm3a_cs INTO l_tlf01,l_tlf905,l_tlf906,l_tlf13   #No:MOD-B80246 add tlf01
         IF l_tlf13 = 'asft6201' AND g_sfb.sfb02 NOT MATCHES '[78]' THEN 
            CONTINUE FOREACH
         END IF
        #------------------No:MOD-B80246 add
        #排除委外待買料
         LET l_cnt = 0 
         SELECT COUNT(*) INTO l_cnt FROM sfa_file WHERE sfa01 = g_sfb.sfb01 
                         AND sfa03 = l_tlf01 AND sfa065 > 0 
         IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
         IF l_cnt > 0 THEN
            CONTINUE FOREACH    
         END IF
        #------------------No:MOD-B80246 end
        #-------------No:MOD-B40029 add
         LET x_flag = 'N'   
         LET amt  = NULL
         OPEN amt1a_cs USING l_tlf905,l_tlf906
         FETCH amt1a_cs INTO amt
         IF NOT cl_null(amt) THEN 
            LET x_flag = 'Y'
         ELSE
            LET amt = 0
         END IF    
         CLOSE amt1a_cs

         LET amt2 = NULL 
         OPEN amt2a_cs USING l_tlf905,l_tlf906
         FETCH amt2a_cs INTO amt2
         IF NOT cl_null(amt2) THEN 
            LET x_flag = 'Y' 
         ELSE
            LET amt2 = 0
         END IF    
         CLOSE amt2a_cs
         LET amt = amt - amt2                                # 委外加工成本
         IF x_flag = 'N' THEN
        #-------------No:MOD-B40029 end
            LET amt2 = 0
            SELECT * INTO l_rvv.* FROM rvv_file
             WHERE rvv01=l_tlf905 AND rvv02=l_tlf906
               AND rvv25 != 'Y'
            IF STATUS = 0 THEN
               SELECT pmm42 INTO l_pmm42
                 FROM rvb_file,pmm_file,rva_file
                WHERE rvb01=l_rvv.rvv04 AND rvb02=l_rvv.rvv05
                  AND pmm01=rvb04 AND rva01 = rvb01
                  AND rvaconf <> 'X' AND pmm18 <> 'X'
               IF STATUS <> 0 THEN
                  LET l_pmm42= 1
               END IF
               IF l_pmm42 IS NULL THEN LET l_pmm42=1 END IF
               LET amt2=l_rvv.rvv39*l_pmm42
            END IF
            IF amt2 IS NULL THEN LET amt2=0 END IF
            LET amt = amt + amt2
         END IF    #No:MOD-B40029 add
         LET g_cch.cch22d = g_cch.cch22d + amt       # 委外加工成本  #No:MOD-B40029 add
      END FOREACH
     #LET g_cch.cch22d = amt                        # 委外加工成本  #No:MOD-B40029 mark
  #END IF                                  #No:MOD-B40029 mark
  #----------------------No:CHI-A90033 end
#FUN-D20078----mark----strat---
#  #FUN-BB0063(S)
#  #處理委外倉退
#  LET l_sql="SELECT rvv39 ,rvu114,pmm42 FROM rvu_file,rvv_file ",
#            "  LEFT OUTER JOIN pmm_file ON (pmm01=rvv36) ",
#            " WHERE rvu01=rvv01 AND rvuconf='Y' ",
#            "   AND rvu03 BETWEEN '",g_bdate,"' AND '",g_edate,"' ",
#            "   AND rvu00='3' AND rvu08='SUB' ",
#            "   AND rvv18='",g_sfb.sfb01,"' "
#  PREPARE atm4a_pre FROM l_sql
#  DECLARE amt4a_cs CURSOR FOR atm4a_pre
#  FOREACH amt4a_cs INTO l_rvv39 ,l_rvu114,l_pmm42
#     CASE 
#        WHEN l_pmm42 IS NOT NULL
#            LET l_rvv39  = l_rvv39  * l_pmm42
#        WHEN l_rvu114 IS NOT NULL
#            LET l_rvv39  = l_rvv39  * l_rvu114
#        OTHERWISE
#            LET l_rvv39  = l_rvv39  * 1
#     END CASE
#  END FOREACH
#  IF cl_null(l_rvv39) THEN LET l_rvv39 = 0 END IF   #TQC-BC0137 add
#  LET g_cch.cch22d = g_cch.cch22d - l_rvv39 
#  #FUN-BB0063(E)
#FUN-D20078----mark----end---
   #-------------------------------------------------------------
   LET g_cch.cch52d = g_cch.cch52d + g_cch.cch22d
   LET g_cch.cch52  = g_cch.cch52a+g_cch.cch52b+g_cch.cch52c+
                      g_cch.cch52d+g_cch.cch52e
                     +g_cch.cch52f+g_cch.cch52g+g_cch.cch52h   #FUN-7C0028 add
 
   LET g_cch.cch22 =g_cch.cch22b+g_cch.cch22c+g_cch.cch22d
                   +g_cch.cch22e+g_cch.cch22f+g_cch.cch22g+g_cch.cch22h   #FUN-7C0028 add
   IF g_cch.cch22 = 0 THEN LET g_cch.cch21 = 0 RETURN END IF
   LET g_cch.cchdate = g_today
  #LET g_cch.cchplant=g_plant #FUN-980009 add    #FUN-A50075
   LET g_cch.cchlegal=g_legal #FUN-980009 add
   LET g_cch.cchoriu = g_user      #No.FUN-980030 10/01/04
   LET g_cch.cchorig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO cch_file VALUES(g_cch.*)
   IF STATUS THEN                     # 可能有上期轉入資料造成重複
      UPDATE cch_file SET cch21 =cch21 +g_cch.cch21,
                          cch22 =cch22 +g_cch.cch22,
                          cch22b=cch22b+g_cch.cch22b,
                          cch22c=cch22c+g_cch.cch22c,
                          cch22d=cch22d+g_cch.cch22d,
                          cch22e=cch22e+g_cch.cch22e,   #FUN-7C0028 add
                          cch22f=cch22f+g_cch.cch22f,   #FUN-7C0028 add
                          cch22g=cch22g+g_cch.cch22g,   #FUN-7C0028 add
                          cch22h=cch22h+g_cch.cch22h,   #FUN-7C0028 add
                          cch52d=cch52d+g_cch.cch22d,
                          cch52 =g_cch.cch52
       WHERE cch01=g_cch.cch01 AND cch02=yy AND cch03=mm
         AND cch04=g_cch.cch04
         AND cch06=type        AND cch07=g_tlfcost   #FUN-7C0028 add
   END IF
END FUNCTION
 
#FUNCTION wip_2_22_cdc(p_cdc01,p_cdc02,p_cdc03,p_cdc041)   #MOD-C50084 mark
FUNCTION wip_2_22_cdc(p_cdc01,p_cdc02,p_cdc041)            #MOD-C50084     
   DEFINE p_cdc01   LIKE cdc_file.cdc01
   DEFINE p_cdc02   LIKE cdc_file.cdc02
   DEFINE p_cdc03   LIKE cdc_file.cdc03
   DEFINE p_cdc041  LIKE cdc_file.cdc041
   DEFINE l_sql     STRING
   DEFINE l_cdc05_1 LIKE cdc_file.cdc05
   DEFINE l_cdc05_2 LIKE cdc_file.cdc05
   DEFINE l_cdc05_3 LIKE cdc_file.cdc05
   DEFINE l_cdc05_4 LIKE cdc_file.cdc05
   DEFINE l_cdc05_5 LIKE cdc_file.cdc05
   DEFINE l_cdc05_6 LIKE cdc_file.cdc05
 
   LET l_sql="SELECT SUM(cdc05) FROM cdc_file ",
            #" WHERE cdc01=? AND cdc02=? AND cdc03 =? AND cdc04=? AND cdc041=?" ,    #MOD-C50084 mark
             " WHERE cdc01=? AND cdc02=? AND cdc04=? AND cdc041=?" ,                 #MOD-C50084
             "   AND cdc11 = '",type,"'"              #No.FUN-9B0118
   DECLARE wip_2_22_cdc_c1 CURSOR FROM l_sql
   #人工
  #OPEN wip_2_22_cdc_c1 USING p_cdc01,p_cdc02,p_cdc03,'1',p_cdc041   #MOD-C50084 mark
   OPEN wip_2_22_cdc_c1 USING p_cdc01,p_cdc02,'1',p_cdc041           #MOD-C50084
   FETCH wip_2_22_cdc_c1 INTO l_cdc05_1
   CLOSE wip_2_22_cdc_c1
   #製費一
  #OPEN wip_2_22_cdc_c1 USING p_cdc01,p_cdc02,p_cdc03,'2',p_cdc041   #MOD-C50084 mark
   OPEN wip_2_22_cdc_c1 USING p_cdc01,p_cdc02,'2',p_cdc041           #MOD-C50084
   FETCH wip_2_22_cdc_c1 INTO l_cdc05_2
   CLOSE wip_2_22_cdc_c1
   #製費二
  #OPEN wip_2_22_cdc_c1 USING p_cdc01,p_cdc02,p_cdc03,'3',p_cdc041   #MOD-C50084 mark
   OPEN wip_2_22_cdc_c1 USING p_cdc01,p_cdc02,'3',p_cdc041           #MOD-C50084
   FETCH wip_2_22_cdc_c1 INTO l_cdc05_3
   CLOSE wip_2_22_cdc_c1
   #製費三
  #OPEN wip_2_22_cdc_c1 USING p_cdc01,p_cdc02,p_cdc03,'4',p_cdc041   #MOD-C50084 mark
   OPEN wip_2_22_cdc_c1 USING p_cdc01,p_cdc02,'4',p_cdc041           #MOD-C50084
   FETCH wip_2_22_cdc_c1 INTO l_cdc05_4
   CLOSE wip_2_22_cdc_c1
   #製費四
  #OPEN wip_2_22_cdc_c1 USING p_cdc01,p_cdc02,p_cdc03,'5',p_cdc041   #MOD-C50084 mark
   OPEN wip_2_22_cdc_c1 USING p_cdc01,p_cdc02,'5',p_cdc041           #MOD-C50084
   FETCH wip_2_22_cdc_c1 INTO l_cdc05_5
   CLOSE wip_2_22_cdc_c1
   #製費五
  #OPEN wip_2_22_cdc_c1 USING p_cdc01,p_cdc02,p_cdc03,'6',p_cdc041   #MOD-C50084 mark
   OPEN wip_2_22_cdc_c1 USING p_cdc01,p_cdc02,'6',p_cdc041           #MOD-C50084
   FETCH wip_2_22_cdc_c1 INTO l_cdc05_6
   CLOSE wip_2_22_cdc_c1
 
   IF cl_null(l_cdc05_1) THEN LET l_cdc05_1= 0 END IF
   IF cl_null(l_cdc05_2) THEN LET l_cdc05_2= 0 END IF
   IF cl_null(l_cdc05_3) THEN LET l_cdc05_3= 0 END IF
   IF cl_null(l_cdc05_4) THEN LET l_cdc05_4= 0 END IF
   IF cl_null(l_cdc05_5) THEN LET l_cdc05_5= 0 END IF
   IF cl_null(l_cdc05_6) THEN LET l_cdc05_6= 0 END IF
 
   RETURN l_cdc05_1,l_cdc05_2,l_cdc05_3,l_cdc05_4,l_cdc05_5,l_cdc05_6
 
END FUNCTION
 
FUNCTION wip2_2_22()     #  2-2. WIP-元件 本期投入人工製費
  DEFINE  l_cch22b  LIKE cch_file.cch22b
  DEFINE  l_cch22c  LIKE cch_file.cch22c
  DEFINE  l_ecm04   LIKE ecm_file.ecm04
  DEFINE  l_ccg20   LIKE ccg_file.ccg20
  DEFINE  l_dept    LIKE cre_file.cre08          #No.FUN-680122CHAR(10)
  DEFINE  l_sql     LIKE type_file.chr1000       #No.FUN-680122CHAR(400) 
  DEFINE  l_ccj02   LIKE ccj_file.ccj02
  DEFINE  l_ccj05   LIKE ccj_file.ccj05
 
   CALL p500_cch_01()   # 將 cch 歸 0
   LET g_cch.cch01 =g_ima01
   LET g_cch.cch04 =' DL+OH+SUB'        # 料號為 ' DL+OH+SUB'
   LET g_cch.cch05 ='P'
   LET g_cch.cch06 =type        #FUN-7C0028 add
   LET g_cch.cch07 =g_tlfcost   #FUN-7C0028 add
   LET g_cch.cch21 =mccg.ccg20
 
   SELECT SUM(cxz04),SUM(cxz05) INTO g_cch.cch22b,g_cch.cch22c
     FROM cxz_file WHERE cxz01=g_ima01
   IF cl_null(g_cch.cch22b) THEN LET g_cch.cch22b= 0 END IF
   IF cl_null(g_cch.cch22c) THEN LET g_cch.cch22c= 0 END IF
   IF cl_null(g_cch.cch22e) THEN LET g_cch.cch22e= 0 END IF   #FUN-7C0028 add
   IF cl_null(g_cch.cch22f) THEN LET g_cch.cch22f= 0 END IF   #FUN-7C0028 add
   IF cl_null(g_cch.cch22g) THEN LET g_cch.cch22g= 0 END IF   #FUN-7C0028 add
   IF cl_null(g_cch.cch22h) THEN LET g_cch.cch22h= 0 END IF   #FUN-7C0028 add
 
 
 
   LET l_sql=
   "SELECT SUM(ABS(apb101))                     ",
   "  FROM pmn_file,apa_file,apb_file,rvv_file  ",
   "  WHERE pmn04='",g_ima01,"'                ", # 剔除代買料
   "     AND pmn01=apb06 AND pmn02=apb07 AND apb29 = '1' ",
   "     AND apb21=rvv01 AND apb22=rvv02                 ",
   "     AND apb01 = apa01 AND (apa00 = '11' OR apa00='16')  ",
   "     AND apa02 BETWEEN '",g_bdate,"' AND '",g_edate,"'   ",
   "     AND rvv09 BETWEEN '",g_bdate,"' AND '",g_edate,"'   ",
   "     AND apa42 = 'N' ",             #No.MOD-850154 add
   "     AND apb34 <> 'Y'                          "
   PREPARE amt1_pre FROM l_sql
   DECLARE amt1_cs CURSOR FOR amt1_pre
   OPEN amt1_cs
   FETCH amt1_cs INTO amt
   CLOSE amt1_cs
 
   LET l_sql=
   "SELECT SUM(ABS(apb101))            ",
   "  FROM pmn_file,apb_file,apa_file,rvv_file  ",# 委外退貨
   "   WHERE pmn04='",g_ima01,"'             ", # 剔除代買料
   "     AND pmn01=apb06 AND pmn02=apb07 AND apb29 = '3' ",
   "     AND apb21=rvv01 AND apb22=rvv02  ",
   "     AND rvv09 BETWEEN '",g_bdate,"' AND '",g_edate,"' ",
   "     AND apb01 = apa01  ",
   "     AND apa42 = 'N'    ",
   "     AND (apa58 = '2'  OR apa58 ='3'  OR apa58 IS NULL)  ",   #No.CHI-910019 add   #No.TQC-CC0145
   "     AND apb34 <> 'Y'   " 
 
   PREPARE amt2_pre FROM l_sql
   DECLARE amt2_cs CURSOR FOR amt2_pre
   OPEN amt2_cs
   FETCH amt2_cs INTO amt2
   CLOSE amt2_cs
 
   IF amt  IS NULL THEN LET amt =0 END IF
   IF amt2 IS NULL THEN LET amt2=0 END IF
   LET g_cch.cch22d = amt - amt2                                # 委外加工成本
 
   LET g_cch.cch52d = g_cch.cch52d+g_cch.cch22d
   LET g_cch.cch52  = g_cch.cch52a+g_cch.cch52b+g_cch.cch52c+
                      g_cch.cch52d+g_cch.cch52e
                     +g_cch.cch52f+g_cch.cch52g+g_cch.cch52h   #FUN-7C0028 add
 
   LET g_cch.cch22 =g_cch.cch22b+g_cch.cch22c+g_cch.cch22d
                   +g_cch.cch22f+g_cch.cch22g+g_cch.cch22h   #FUN-7C0028 add
   IF g_cch.cch22 = 0 THEN LET g_cch.cch21 = 0 RETURN END IF
   LET g_cch.cchdate = g_today
  #LET g_cch.cchplant=g_plant #FUN-980009 add    #FUN-A50075
   LET g_cch.cchlegal=g_legal #FUN-980009 add
   LET g_cch.cchoriu = g_user      #No.FUN-980030 10/01/04
   LET g_cch.cchorig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO cch_file VALUES(g_cch.*)
   IF STATUS THEN                     # 可能有上期轉入資料造成重複
      UPDATE cch_file SET cch21 =cch21+g_cch.cch21,
                          cch22 =cch22+g_cch.cch22,
                          cch22b=cch22b+g_cch.cch22b,
                          cch22c=cch22c+g_cch.cch22c,
                          cch22d=cch22d+g_cch.cch22d,
                          cch22e=cch22e+g_cch.cch22e,   #FUN-7C0028 add
                          cch22f=cch22f+g_cch.cch22f,   #FUN-7C0028 add
                          cch22g=cch22g+g_cch.cch22g,   #FUN-7C0028 add
                          cch22h=cch22h+g_cch.cch22h,   #FUN-7C0028 add
                          cch52d=cch52d+g_cch.cch22d,
                          cch52 =g_cch.cch52
          WHERE cch01=g_cch.cch01 AND cch02=yy AND cch03=mm
            AND cch04=g_cch.cch04
            AND cch06=type        AND cch07=g_tlfcost   #FUN-7C0028 add
           IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
              CALL cl_err3("upd","cch_file",g_cch.cch01,yy,STATUS,"","upd cch_file",1)   #No.FUN-660127
              LET g_success = 'N' RETURN
           END IF
   END IF
END FUNCTION
 
FUNCTION wip_2_23()     #  2-3. WIP-元件 本期投入調整成本
   CALL p500_cch_01()   # 將 cch 歸 0
   LET g_cch.cch01 =g_sfb.sfb01
   LET g_cch.cch04 =' ADJUST'   # 料號為 ' ADJUST'
   LET g_cch.cch05 ='P'
   LET g_cch.cch06 =type        #FUN-7C0028 add
   LET g_cch.cch07 =g_tlfcost   #FUN-7C0028 add
   #---------------------------- (970109 roger) 使調整成本歸入半成品
   LET g_chr=''
   SELECT MAX(ccl05) INTO g_chr FROM ccl_file
    WHERE ccl01=g_sfb.sfb01 AND ccl02=yy AND ccl03=mm AND ccl05='M'
      AND ccl06=type        AND ccl07=g_tlfcost   #FUN-7C0028 add
   IF g_chr='M' THEN LET g_cch.cch05 ='M' END IF
   #--------------------------------------------------------------------------
   LET g_cch.cch21 =mccg.ccg21
   SELECT SUM(ccl21),
          SUM(ccl22a), SUM(ccl22b), SUM(ccl22c), SUM(ccl22d), SUM(ccl22e)
         ,SUM(ccl22f), SUM(ccl22g), SUM(ccl22h)   #FUN-7C0028 add
     INTO g_cch.cch21,
          g_cch.cch22a,g_cch.cch22b,g_cch.cch22c,g_cch.cch22d,g_cch.cch22e
         ,g_cch.cch22f,g_cch.cch22g,g_cch.cch22h  #FUN-7C0028 add
     FROM ccl_file
    WHERE ccl01=g_sfb.sfb01 AND ccl02=yy AND ccl03=mm
      AND ccl06=type        AND ccl07=g_tlfcost   #FUN-7C0028 add
   IF g_cch.cch21  IS NULL THEN LET g_cch.cch21 = 0 END IF
   IF g_cch.cch22a IS NULL THEN
      LET g_cch.cch22a = 0 LET g_cch.cch22b = 0 LET g_cch.cch22c = 0
      LET g_cch.cch22d = 0 LET g_cch.cch22e = 0
      LET g_cch.cch22f = 0 LET g_cch.cch22g = 0 LET g_cch.cch22h = 0   #FUN-7C0028 add
   END IF
   LET g_cch.cch22 =g_cch.cch22a+g_cch.cch22b+g_cch.cch22c
                                +g_cch.cch22d+g_cch.cch22e
                                +g_cch.cch22f+g_cch.cch22g+g_cch.cch22h   #FUN-7C0028 add
   IF g_cch.cch22 = 0 THEN LET g_cch.cch21 = 0 RETURN END IF
   LET g_cch.cchdate = g_today
  #LET g_cch.cchplant=g_plant #FUN-980009 add    #FUN-A50075
   LET g_cch.cchlegal=g_legal #FUN-980009 add
   LET g_cch.cchoriu = g_user      #No.FUN-980030 10/01/04
   LET g_cch.cchorig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO cch_file VALUES(g_cch.*)
     IF STATUS THEN                     # 可能有上期轉入資料造成重複
        UPDATE cch_file SET cch21=cch21+g_cch.cch21,
                            cch22=cch22+g_cch.cch22,
                            cch22a=cch22a+g_cch.cch22a,
                            cch22b=cch22b+g_cch.cch22b,
                            cch22c=cch22c+g_cch.cch22c,
                            cch22d=cch22d+g_cch.cch22d,
                            cch22e=cch22e+g_cch.cch22e, 
                            cch22f=cch22f+g_cch.cch22f,   #FUN-7C0028 add
                            cch22g=cch22g+g_cch.cch22g,   #FUN-7C0028 add
                            cch22h=cch22h+g_cch.cch22h    #FUN-7C0028 add
            WHERE cch01=g_cch.cch01 AND cch02=yy AND cch03=mm
              AND cch04=g_cch.cch04
              AND cch06=type        AND cch07=g_tlfcost   #FUN-7C0028 add
     END IF
END FUNCTION
 
FUNCTION wip2_2_23()    #  2-3. WIP-元件 本期投入調整成本
   CALL p500_cch_01()   # 將 cch 歸 0
   LET g_cch.cch01 =g_ima01
   LET g_cch.cch04 =' ADJUST'   # 料號為 ' ADJUST'
   LET g_cch.cch05 ='P'
   LET g_cch.cch06 =type        #FUN-7C0028 add
   LET g_cch.cch07 =g_tlfcost   #FUN-7C0028 add
   #---------------------------- (970109 roger) 使調整成本歸入半成品
   LET g_chr=''
   SELECT MAX(ccl05) INTO g_chr FROM ccl_file
    WHERE ccl01=g_ima01 AND ccl02=yy AND ccl03=mm AND ccl05='M'
      AND ccl06=type    AND ccl07=g_tlfcost   #FUN-7C0028 add
   IF g_chr='M' THEN LET g_cch.cch05 ='M' END IF
   #--------------------------------------------------------------------------
   LET g_cch.cch21 =mccg.ccg21
   SELECT SUM(ccl21),
          SUM(ccl22a), SUM(ccl22b), SUM(ccl22c), SUM(ccl22d), SUM(ccl22e)
         ,SUM(ccl22f), SUM(ccl22g), SUM(ccl22h)   #FUN-7C0028 add
     INTO g_cch.cch21,
          g_cch.cch22a,g_cch.cch22b,g_cch.cch22c,g_cch.cch22d,g_cch.cch22e
         ,g_cch.cch22f,g_cch.cch22g,g_cch.cch22h  #FUN-7C0028 add
     FROM ccl_file
    WHERE ccl01=g_ima01 AND ccl02=yy AND ccl03=mm
      AND ccl06=type    AND ccl07=g_tlfcost   #FUN-7C0028 add
   IF g_cch.cch21  IS NULL THEN LET g_cch.cch21 = 0 END IF
   IF g_cch.cch22a IS NULL THEN
      LET g_cch.cch22a = 0 LET g_cch.cch22b = 0 LET g_cch.cch22c = 0
      LET g_cch.cch22d = 0 LET g_cch.cch22e = 0
      LET g_cch.cch22f = 0 LET g_cch.cch22g = 0 LET g_cch.cch22h = 0   #FUN-7C0028 add
   END IF
   LET g_cch.cch22 =g_cch.cch22a+g_cch.cch22b+g_cch.cch22c
                                +g_cch.cch22d+g_cch.cch22e
                                +g_cch.cch22f+g_cch.cch22g+g_cch.cch22h   #FUN-7C0028 add
   IF g_cch.cch22 = 0 THEN LET g_cch.cch21 = 0 RETURN END IF
   LET g_cch.cchdate = g_today
  #LET g_cch.cchplant=g_plant #FUN-980009 add    #FUN-A50075
   LET g_cch.cchlegal=g_legal #FUN-980009 add
   LET g_cch.cchoriu = g_user      #No.FUN-980030 10/01/04
   LET g_cch.cchorig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO cch_file VALUES(g_cch.*)
   IF STATUS THEN                     # 可能有上期轉入資料造成重複
      UPDATE cch_file SET cch21=cch21+g_cch.cch21,
                          cch22=cch22+g_cch.cch22,
                          cch22a=cch22a+g_cch.cch22a,
                          cch22b=cch22b+g_cch.cch22b,
                          cch22c=cch22c+g_cch.cch22c,
                          cch22d=cch22d+g_cch.cch22d,
                          cch22e=cch22e+g_cch.cch22e, 
                          cch22f=cch22f+g_cch.cch22f,   #FUN-7C0028 add
                          cch22g=cch22g+g_cch.cch22g,   #FUN-7C0028 add
                          cch22h=cch22h+g_cch.cch22h    #FUN-7C0028 add
          WHERE cch01=g_cch.cch01 AND cch02=yy AND cch03=mm
            AND cch04=g_cch.cch04
            AND cch06=type        AND cch07=g_tlfcost   #FUN-7C0028 add
   END IF
END FUNCTION
 
#------------------------------------------------------------------------
# 以下計算 WIP-元件 本期轉出成本
# 若為實際成本制, 則標準 QPA 由工單備料檔讀出, 不計算標準差異
#------------------------------------------------------------------------
FUNCTION wip_3()        # step 3. WIP-元件 本期轉出成本
   IF g_ccz.ccz04='2' THEN CALL wip_32() END IF
END FUNCTION
 
FUNCTION wip2_3()       # step 3. 計算產品WIP元件 轉出/期末 cch
   DEFINE l_sql    STRING,
          l_sre11  LIKE sre_file.sre11,
          l_srm04  LIKE srm_file.srm04,
          l_srm05  LIKE srm_file.srm05,
          l_srm06  LIKE srm_file.srm06,
          l_ccg    RECORD LIKE ccg_file.*,
          l_cch    RECORD LIKE cch_file.*
 
   #取得產品完工數量(sre_file)
   SELECT SUM(sre11) INTO l_sre11 FROM sre_file
    WHERE sre01=yy AND sre02=mm AND sre04=g_ima01
   IF l_sre11 IS NULL THEN LET l_sre11 = 0 END IF   #TQC-620151
   #取得產品完工比率資料(srm_file)
   SELECT srm04,srm05,srm06 INTO l_srm04,l_srm05,l_srm06 FROM srm_file
    WHERE srm01=yy AND srm02=mm AND srm03=g_ima01
   IF l_srm04 IS NULL THEN LET l_srm04 = 0 END IF
   IF l_srm05 IS NULL THEN LET l_srm05 = 0 END IF
   IF l_srm06 IS NULL THEN LET l_srm06 = 0 END IF
   #取得投入cch_file
   LET l_sql="SELECT cch_file.*,ccg_file.* FROM cch_file,ccg_file ",
             " WHERE ccg01=? AND ccg02=? AND ccg03=? ",
             "   AND ccg06=?             ",   #FUN-7C0028 add
             "   AND ccg01=cch01 AND ccg02=cch02 AND ccg03=cch03 ",
             "   AND ccg06=cch06                 ", 
             " ORDER BY cch04 "
   DECLARE wip2_3_c1 CURSOR FROM l_sql
   FOREACH wip2_3_c1 USING g_ima01,yy,mm,type INTO l_cch.*, l_ccg.*   #FUN-7C0028 add type,g_tlfcost
     IF g_ccz.ccz05='3' THEN     #期末無結存
        LET l_cch.cch91  =0                                #期末數量
        LET l_cch.cch92  =0                                #期末金額
        LET l_cch.cch92a =0
        LET l_cch.cch92b =0
        LET l_cch.cch92c =0
        LET l_cch.cch92d =0
        #tianry add 161213
        LET l_cch.cch92d =(l_cch.cch12d+l_cch.cch22d)*l_srm04/(l_sre11+l_srm04)
        #tianry add end
        LET l_cch.cch92e =0
        LET l_cch.cch92f =0   #FUN-7C0028 add
        LET l_cch.cch92g =0   #FUN-7C0028 add
        LET l_cch.cch92h =0   #FUN-7C0028 add
        LET l_cch.cch31  =(l_cch.cch11 +l_cch.cch21) *-1   #轉出數量
        LET l_cch.cch32  =(l_cch.cch12 +l_cch.cch22) *-1   #轉出金額
        LET l_cch.cch32a =(l_cch.cch12a+l_cch.cch22a)*-1
        LET l_cch.cch32b =(l_cch.cch12b+l_cch.cch22b)*-1
        LET l_cch.cch32c =(l_cch.cch12c+l_cch.cch22c)*-1
     #   LET l_cch.cch32d =(l_cch.cch12d+l_cch.cch22d)*-1
        #tianry add 161213
        LET l_cch.cch32d =(l_cch.cch12d+l_cch.cch22d-l_cch.cch92d)*-1
        #tianry add end 
        LET l_cch.cch32e =(l_cch.cch12e+l_cch.cch22e)*-1
        LET l_cch.cch32f =(l_cch.cch12f+l_cch.cch22f)*-1   #FUN-7C0028 add
        LET l_cch.cch32g =(l_cch.cch12g+l_cch.cch22g)*-1   #FUN-7C0028 add
        LET l_cch.cch32h =(l_cch.cch12h+l_cch.cch22h)*-1   #FUN-7C0028 add
     ELSE                #依入庫量,約當量
        LET l_cch.cch91  =(l_cch.cch11 +l_cch.cch21) *l_srm04/(l_sre11+l_srm04)     #期末數量
        LET l_cch.cch92  =(l_cch.cch12 +l_cch.cch22) *l_srm04/(l_sre11+l_srm04)     #期末金額
        LET l_cch.cch92a =(l_cch.cch12a+l_cch.cch22a)*l_srm04/(l_sre11+l_srm04)
        LET l_cch.cch92b =(l_cch.cch12b+l_cch.cch22b)*
                           (l_srm04*(l_srm05/100))/
                           (l_sre11+l_srm04*(l_srm05/100))   #TQC-620151
        LET l_cch.cch92c =(l_cch.cch12c+l_cch.cch22c)*
                           (l_srm04*(l_srm06/100))/
                           (l_sre11+l_srm04*(l_srm06/100))   #TQC-620151
        LET l_cch.cch92d =(l_cch.cch12d+l_cch.cch22d)*l_srm04/(l_sre11+l_srm04)  
        LET l_cch.cch92e =(l_cch.cch12e+l_cch.cch22e)*l_srm04/(l_sre11+l_srm04)
        LET l_cch.cch92f =(l_cch.cch12f+l_cch.cch22f)*l_srm04/(l_sre11+l_srm04)   #FUN-7C0028 add
        LET l_cch.cch92g =(l_cch.cch12g+l_cch.cch22g)*l_srm04/(l_sre11+l_srm04)   #FUN-7C0028 add
        LET l_cch.cch92h =(l_cch.cch12h+l_cch.cch22h)*l_srm04/(l_sre11+l_srm04)   #FUN-7C0028 add
        LET l_cch.cch92  = l_cch.cch92a+l_cch.cch92b+l_cch.cch92c+
                           l_cch.cch92d+l_cch.cch92e
                          +l_cch.cch92f+l_cch.cch92g+l_cch.cch92h   #FUN-7C0028 add
        LET l_cch.cch31  =(l_cch.cch11 +l_cch.cch21 -l_cch.cch91) *-1                #轉出數量
        LET l_cch.cch32  =(l_cch.cch12 +l_cch.cch22 -l_cch.cch92) *-1                #轉出金額
        LET l_cch.cch32a =(l_cch.cch12a+l_cch.cch22a-l_cch.cch92a)*-1
        LET l_cch.cch32b =(l_cch.cch12b+l_cch.cch22b-l_cch.cch92b)*-1
        LET l_cch.cch32c =(l_cch.cch12c+l_cch.cch22c-l_cch.cch92c)*-1
        LET l_cch.cch32d =(l_cch.cch12d+l_cch.cch22d-l_cch.cch92d)*-1
        LET l_cch.cch32e =(l_cch.cch12e+l_cch.cch22e-l_cch.cch92e)*-1
        LET l_cch.cch32f =(l_cch.cch12f+l_cch.cch22f-l_cch.cch92f)*-1   #FUN-7C0028 add
        LET l_cch.cch32g =(l_cch.cch12g+l_cch.cch22g-l_cch.cch92g)*-1   #FUN-7C0028 add
        LET l_cch.cch32h =(l_cch.cch12h+l_cch.cch22h-l_cch.cch92h)*-1   #FUN-7C0028 add
        LET l_cch.cch32  = l_cch.cch32a+l_cch.cch32b+l_cch.cch32c+
                           l_cch.cch32d+l_cch.cch32e
                          +l_cch.cch32f+l_cch.cch32g+l_cch.cch32h   #FUN-7C0028 add
     END IF
     #更新cch_file
    #MOD-B30061---add---start---
     IF cl_null(l_cch.cch31) THEN LET l_cch.cch31 = 0 END IF
     IF cl_null(l_cch.cch32) THEN LET l_cch.cch32 = 0 END IF
     IF cl_null(l_cch.cch32a) THEN LET l_cch.cch32a = 0 END IF
     IF cl_null(l_cch.cch32b) THEN LET l_cch.cch32b = 0 END IF
     IF cl_null(l_cch.cch32c) THEN LET l_cch.cch32c = 0 END IF
     IF cl_null(l_cch.cch32d) THEN LET l_cch.cch32d = 0 END IF
     IF cl_null(l_cch.cch32e) THEN LET l_cch.cch32e = 0 END IF
     IF cl_null(l_cch.cch91) THEN LET l_cch.cch91 = 0 END IF
     IF cl_null(l_cch.cch92) THEN LET l_cch.cch92 = 0 END IF
     IF cl_null(l_cch.cch92a) THEN LET l_cch.cch92a = 0 END IF
     IF cl_null(l_cch.cch92b) THEN LET l_cch.cch92b = 0 END IF
     IF cl_null(l_cch.cch92c) THEN LET l_cch.cch92c = 0 END IF
     IF cl_null(l_cch.cch92d) THEN LET l_cch.cch92d = 0 END IF
     IF cl_null(l_cch.cch92e) THEN LET l_cch.cch92e = 0 END IF
    #MOD-B30061---add---end---
     #MOD-E40023 add begin----------------
     IF cl_null(l_cch.cch32f) THEN LET l_cch.cch32f = 0 END IF
     IF cl_null(l_cch.cch32g) THEN LET l_cch.cch32g = 0 END IF
     IF cl_null(l_cch.cch32h) THEN LET l_cch.cch32h = 0 END IF
     IF cl_null(l_cch.cch92f) THEN LET l_cch.cch92f = 0 END IF
     IF cl_null(l_cch.cch92g) THEN LET l_cch.cch92g = 0 END IF
     IF cl_null(l_cch.cch92h) THEN LET l_cch.cch92h = 0 END IF
     #MOD-E40023 add end-------------------    
     UPDATE cch_file SET * = l_cch.*
      WHERE cch01=l_cch.cch01 AND cch02=yy AND cch03=mm AND cch04=l_cch.cch04
        AND cch06=type        AND cch07=l_cch.cch07
   END FOREACH
END FUNCTION
 
FUNCTION wip_32()       # step 3. WIP-元件 本期轉出成本 (實際成本制)
   DEFINE l_ccg RECORD LIKE ccg_file.*
   DEFINE l_cch RECORD LIKE cch_file.*
   DEFINE l_sfa RECORD LIKE sfa_file.*
   DEFINE cost,costa,costb,costc,costd,coste  LIKE azj_file.azj03   #No.FUN-680122DEC(20,10)
   DEFINE costf,costg,costh                   LIKE azj_file.azj03   #FUN-7C0028 add
   DEFINE last_cch RECORD LIKE cch_file.*
   DEFINE last_qty      LIKE ccg_file.ccg31          #No.FUN-680122DEC(15,3)
   DEFINE l_sub_qty     LIKE ccg_file.ccg31          #No.FUN-680122DEC(15,3)
   DEFINE ccg31_tot     LIKE ccg_file.ccg31          #No.FUN-680122DEC(15,3)
   DEFINE cch31_tot     LIKE ccg_file.ccg31          #No.FUN-680122DEC(15,3)
   DEFINE l_sfe16       LIKE sfe_file.sfe16          #No.FUN-680122DEC(15,3)    # 超領數量
   DEFINE l_sfv09       LIKE sfv_file.sfv09          #No.FUN-680122DEC(15,3)
   DEFINE l_unit        LIKE type_file.num20_6       #No.FUN-680122DEC(20,6)    #MOD-4C0005
   DEFINE l_cnt         LIKE type_file.num5          #No.FUN-680122 SMALLINT
   #DEFINE l_sql         LIKE type_file.chr1000       #No.FUN-680122CHAR(800) #FUN-B90029 mark 
   DEFINE l_sql         STRING                       #FUN-B90029
   DEFINE l_cch31       LIKE cch_file.cch31
   DEFINE l_unissue     LIKE sfa_file.sfa05
   DEFINE l_oldccg01    LIKE ccg_file.ccg01
   DEFINE l_sfm03       LIKE sfm_file.sfm03
   DEFINE l_sfm04       LIKE sfm_file.sfm04
   DEFINE l_sfm05       LIKE sfm_file.sfm05
   DEFINE l_sfm06,l_woqty   LIKE sfm_file.sfm07
   DEFINE l_dif,l_chg   LIKE sfm_file.sfm07
   DEFINE l_sfb08       LIKE sfb_file.sfb08
   DEFINE l_ccj06       LIKE ccj_file.ccj06
   DEFINE l_ccj05       LIKE ccj_file.ccj05
   DEFINE l_sharerate   LIKE fid_file.fid03         #No.FUN-680122DEC(8,3)
   DEFINE l_adjrate     LIKE fid_file.fid03         #No:CHI-990044 add
   DEFINE l_cch31_rate  LIKE fid_file.fid03         #No:CHI-990044 add
   DEFINE l_old_cch04   LIKE cch_file.cch04         #TQC-970003
   DEFINE l_old_cch07   LIKE cch_file.cch07         #No:CHI-B10036 add
   DEFINE l_sum_cch31   LIKE cch_file.cch31         #TQC-970003
   DEFINE l_cnt2        LIKE type_file.num5         #TQC-970003
   DEFINE l_sum_cch11   LIKE cch_file.cch11         #TQC-970003
   DEFINE l_sum_cch21   LIKE cch_file.cch21         #TQC-970003
   DEFINE l_ima55_fac   LIKE ima_file.ima55_fac     #No.MOD-B30085 
   DEFINE l_old_sfa08   LIKE sfa_file.sfa08         #MOD-C50138 add 
   DEFINE l_cnt3        LIKE type_file.num5         #FUN-CC0002
   DEFINE l_qty         LIKE tlf_file.tlf10         #FUN-CC0002
   DEFINE l_shb112      LIKE shb_file.shb112        #FUN-CC0002
   DEFINE l_ecm03       LIKE ecm_file.ecm03         #FUN-CC0002
   DEFINE l_cch31n      LIKE cch_file.cch31         #No.FUN-D10031 
   DEFINE l_cnt4        LIKE type_file.num5         #MOD-DB0067
   DEFINE l_tt          LIKE sfa_file.sfa05      #tianry add 161213
   # 98.09.15 Star 原替代料轉出判斷, 若被替代料無投入記錄, 則其替代料無法轉出.
   # 故在此先處理此部份
   DECLARE wip_32_c1SUB CURSOR FOR
     SELECT sfa_file.*, ccg_file.*
       FROM sfa_file,ccg_file
      WHERE ccg01=g_sfb.sfb01 AND ccg02=yy AND ccg03=mm
        AND ccg06=type
        AND sfa01=ccg01
        AND sfa26 IN ('3','4','8')    #FUN-A20037 add 8
        #AND sfa03 NOT IN         #CHI-C80002
        AND NOT EXISTS            #CHI-C80002
    #(SELECT cch04 FROM cch_file  #CHI-C80002
    (SELECT 1 FROM cch_file       #CHI-C80002
      WHERE cch01=g_sfb.sfb01 AND cch02=yy AND cch03=mm
        AND cch04 = sfa03         #CHI-C80002
        AND cch06=type)
      ORDER BY sfa26                    #先處理非替代料
   DELETE FROM sub_tmp
   IF STATUS=-206 THEN
      CREATE TEMP TABLE sub_tmp(
          tmp01         LIKE sfa_file.sfa03,    # 替代料號    #FUN-560011
          tmp03         LIKE tlf_file.tlfcost,  #No.TQC-970003
          tmp02         LIKE cch_file.cch31)    # 替代轉出量
      CREATE INDEX sub_tmp_index ON sub_tmp(tmp01,tmp03)  #CHI-C80002
   END IF
   FOREACH wip_32_c1SUB INTO l_sfa.*,l_ccg.*
     IF l_sfa.sfa161 IS NULL THEN LET l_sfa.sfa161 = 0 END IF
     IF cl_null(l_cch.cch11) THEN LET l_cch.cch11 = 0 END IF  #No.MOD-8C0074 add 
     IF cl_null(l_cch.cch21) THEN LET l_cch.cch21 = 0 END IF  #No.MOD-8C0074 add 
#No.MOD-B30085 --begin
     LET l_ima55_fac=0
     SELECT ima55_fac INTO l_ima55_fac FROM ima_file
      WHERE ima01=mccg.ccg04
     IF cl_null(l_ima55_fac) OR l_ima55_fac=0 THEN  LET l_ima55_fac=1 END IF
     LET l_cch.cch31 =mccg.ccg31*l_sfa.sfa161*l_sfa.sfa13/l_ima55_fac   # 以標準 QPA 計算轉出量  #No.MOD-7A0166 add sfa13
#No.MOD-B30085 --end
     #-------- (970113 roger) 特別處理'被替代料(sfa26=3/4)及'替代料(sfa26=S/U)'
     LET l_sub_qty = 0 - (l_cch.cch31*-1)
     CALL p500_sub(l_sfa.sfa01,l_sfa.sfa03,l_sub_qty)
   END FOREACH
 
   #-->取生產量
     LET l_sql = " SELECT sfm03,sfm04,sfm05,sfm06 FROM sfm_file  ",
                 " WHERE  sfm01 =  ?  AND sfm10 = '1'",
                 "   and  sfm03 <='",g_edate,"'",
                 "  ORDER BY sfm03,sfm04"
     PREPARE wip_32_presfm FROM l_sql
     DECLARE wip_32_sfmcur CURSOR FOR wip_32_presfm

   #CHI-C80002---begin
   LET l_sql = " SELECT UNIQUE ccj06 FROM ccj_file ,cci_file ",
               " WHERE ccj04=? ",                 
               " AND ccj01=cci01 AND ccj02=cci02 ",
               " AND ccifirm = 'Y' "
   PREPARE wip_32_ccj_p1 FROM l_sql
   DECLARE ccj_curs CURSOR FOR wip_32_ccj_p1
   
   LET l_sql = " SELECT * FROM cch_file ",
               " WHERE cch01=? AND (cch02*12+cch03) < (?*12+?) ",
               " AND cch04=? ",
               " AND cch06=? ",
               " AND cch07=? ",
               " ORDER BY cch02 DESC,cch03 DESC "
   PREPARE wip_32_p2 FROM l_sql
   DECLARE wip_32_c2 CURSOR FOR wip_32_p2
   #CHI-C80002---end
 
  #--->如果有料號當期沒有投入但有產出則要有一筆負值
#--genero修改
   LET l_sql = 
              " SELECT sfa_file.*,cch_file.*, ccg_file.*  ",
              "   FROM sfa_file,cch_file,ccg_file",                       #No.TQC-9C0020
              "  WHERE sfa01= ?  ",
              "    AND cch_file.cch02=? ",
              "    AND cch_file.cch03=? ",
              "    AND cch_file.cch06=? ",   #FUN-7C0028 add
              "    AND ccg_file.ccg02 =? ",
              "    AND ccg_file.ccg03 =? ",
              "    AND ccg_file.ccg06 =? ",   #FUN-7C0028 add
              "    AND sfa01 = ccg_file.ccg01 ",                          #No.TQC-9C0020
              "    AND cch_file.cch01=sfa01 AND cch_file.cch04=sfa03 ",   #No.TQC-9C0020
              "  UNION ",
              " SELECT sfa_file.*,cch_file.*, ccg_file.* ",
              "   FROM cch_file,sfa_file,ccg_file",                      #No.TQC-9C0020
              "  WHERE cch01= ? ",
              "    AND cch02= ? ",
              "    AND cch03= ? ",
              "    AND cch06= ? ",   #FUN-7C0028 add
              "    AND cch01 = ccg01 AND cch02 = ccg02 ",                #No.TQC-9C0020
              "    AND cch03 = ccg03 AND cch06 = ccg06  ",               #No.TQC-9C0020
              "    AND cch01=sfa01 ",                                    #No.TQC-9C0020
              "    AND (cch04=' DL+OH+SUB' OR cch04 = ' ADJUST') ",
              #FUN-B90029(S)
              "  UNION ",
              " SELECT sfa_file.*,cch_file.*, ccg_file.* ",     
              "   FROM cch_file, shd_file,shb_file,ccg_file,sfa_file ",           #TQC-630124
              "  WHERE cch01= ? ",
              "    AND cch02= ? ",
              "    AND cch03= ? ",
              "    AND cch06= ? ",
              "    AND cch01=sfa01 ",
              "    AND cch01=shb05 ",
              "    AND shb01=shd01 ",
              "    AND shd06=cch04 ",
              "    AND cch01 = ccg01 ",
              "    AND cch02 = ccg02 ",
              "    AND cch03 = ccg03 ",
              "    AND cch06 = ccg06 ",
              #FUN-B90029(E)
              "  ORDER BY 26,25 "       #No.TQC-9C0020
   DECLARE wip_32_c1 CURSOR FROM l_sql
#--genero修改
   LET l_oldccg01 = ' '
   LET l_old_cch04 = ' '
   LET l_old_cch07 = NULL   #No:CHI-B10036 add
   LET l_sum_cch11 = 0
   LET l_sum_cch21 = 0
   LET l_sum_cch31 = 0

   FOREACH wip_32_c1
     USING g_sfb.sfb01,yy,mm,type,
           yy,mm,type,
           g_sfb.sfb01,yy,mm,type,
           g_sfb.sfb01,yy,mm,type    #FUN-B90029
     INTO l_sfa.*,l_cch.*, l_ccg.*
   #IF l_old_cch04 <> l_cch.cch04 AND l_cch.cch04 != ' DL+OH+SUB' THEN    #MOD-C50138 mark
   #MOD-C50138 -- start --
   #IF (l_old_cch04 <> l_cch.cch04 OR (l_old_cch04 = l_cch.cch04 AND l_old_sfa08 <> l_sfa.sfa08))    #MOD-C90065 mark  #No.FUN-D10031 add ()
    IF (l_old_cch04 <> l_cch.cch04 OR (l_old_cch04 = l_cch.cch04 AND l_old_sfa08 <> l_sfa.sfa08))    #MOD-C90065 add   
       AND l_cch.cch04 != ' DL+OH+SUB' THEN
   #MOD-C50138 -- end -- 
       LET l_sum_cch11 = 0
       LET l_sum_cch21 = 0
       LET l_sum_cch31 = 0
    END IF
     IF l_sfa.sfa161 IS NULL THEN LET l_sfa.sfa161 = 0 END IF
     #-->modify by apple(取本月之報廢量)
      IF l_ccg.ccg01 != l_oldccg01 THEN
         LET l_chg = 0    LET l_cnt = 0
         LET l_woqty = 0   #MOD-A60053 add
         FOREACH wip_32_sfmcur USING l_ccg.ccg01
                                INTO l_sfm03,l_sfm04,l_sfm05,l_sfm06
             LET l_dif = 0    #MOD-A60053 add
             LET l_dif = l_sfm06 - l_sfm05
             IF cl_null(l_dif) THEN LET l_dif = 0 END IF   #MOD-A60053 add
             LET l_chg = l_chg + l_dif
             LET l_cnt = l_cnt + 1
         END FOREACH
         SELECT sfb08 INTO l_sfb08 FROM sfb_file WHERE sfb01 = l_ccg.ccg01
         IF cl_null(l_sfb08) THEN LET l_sfb08 = 0 END IF
         LET l_woqty = l_sfb08 - l_chg
      END IF
      LET l_oldccg01 = l_ccg.ccg01
      #-->未發需求
       IF l_sfa.sfa05 = 0 AND l_woqty != 0 AND l_cch.cch21=0
          AND l_cch.cch22=0 AND l_cch.cch12=0 THEN CONTINUE FOREACH
       END IF
       LET l_unissue = 0    #MOD-A60053 add
       LET l_unissue = l_sfa.sfa05 - l_sfa.sfa06
       IF cl_null(l_unissue) THEN LET l_unissue = 0 END IF
 
     SELECT SUM(sfa161) INTO l_sfa.sfa161 FROM sfa_file
      WHERE sfa01=l_sfa.sfa01
        AND sfa03=l_sfa.sfa03
        AND sfa12=l_sfa.sfa12
     IF l_sfa.sfa161 IS NULL THEN LET l_sfa.sfa161 = 0 END IF
 
     #-->元件轉出取整數(四捨五入)
     LET l_cch31 = 0   #MOD-A60053 add
#No.MOD-B30085 --begin
     LET l_ima55_fac=0
     SELECT ima55_fac INTO l_ima55_fac FROM ima_file
      WHERE ima01=mccg.ccg04
     IF cl_null(l_ima55_fac) OR l_ima55_fac=0 THEN  LET l_ima55_fac=1 END IF
     LET l_cch31 =mccg.ccg31*l_sfa.sfa161*l_sfa.sfa13/l_ima55_fac   # 以標準 QPA 計算轉出量    #No:MOD-7A0166 add sfa13
#No.MOD-B30085 --end
     IF cl_null(l_cch31) THEN LET l_cch31 = 0 END IF   #MOD-A60053 add
     LET l_cch.cch31 =l_cch31
 
     LET l_sharerate = 0   #MOD-A60053 add
    #IF l_cch.cch04 = ' DL+OH+SUB' THEN                              #CHI-990044 mark
     IF l_cch.cch04 = ' DL+OH+SUB' OR l_cch.cch04 = ' ADJUST' THEN   #No:CHI-990044 modify
        CASE WHEN g_ccz.ccz05='1'
                  SELECT SUM(ccg31) INTO ccg31_tot FROM ccg_file #TOT入庫
                   WHERE ccg01=g_sfb.sfb01 AND (ccg02*12+ccg03)<=(yy*12+mm)
                     AND ccg06=type 
                  IF ccg31_tot IS NULL THEN LET ccg31_tot = 0 END IF
                  DROP TABLE axcp500_tmp
                  # 約當量需相同
                  #CHI-C80002---begin mark
                  #DECLARE ccj_curs CURSOR FOR
                  # SELECT UNIQUE ccj06 FROM ccj_file ,cci_file
                  #  WHERE ccj04=g_sfb.sfb01                         #MOD-960062 add
                  #    AND ccj01=cci01 AND ccj02=cci02
                  #    AND ccifirm = 'Y'
                  #FOREACH ccj_curs INTO l_ccj06 END FOREACH
                  #CHI-C80002---end
                  FOREACH ccj_curs USING g_sfb.sfb01 INTO l_ccj06 END FOREACH  #CHI-C80002
                  IF l_ccj06 IS NULL THEN LET l_ccj06 = 0 END IF
                  IF l_ccj06 = 0 THEN LET l_ccj06 = mccg.ccg31*-1 END IF
                  # IF 本張工單的約當量為零(若製程為工單獨立定義的)
                  LET l_sharerate = mccg.ccg31 / l_ccj06
                  IF l_sharerate IS NULL THEN LET l_sharerate = 0 END IF
                  IF l_sharerate > 0 THEN LET l_sharerate = 0 END IF
                  IF l_sharerate <-1 THEN LET l_sharerate = -1 END IF
                  IF cl_null(l_cch.cch31) THEN LET l_cch.cch31 = 0 END IF
                  LET l_adjrate = l_sharerate    #No:CHI-990044 add
             WHEN g_ccz.ccz05='2'
#No.MOD-B30085 --begin
                  LET l_ima55_fac=0
                  SELECT ima55_fac INTO l_ima55_fac FROM ima_file
                   WHERE ima01=mccg.ccg04
                  IF cl_null(l_ima55_fac) OR l_ima55_fac=0 THEN  LET l_ima55_fac=1 END IF
                  LET l_cch.cch31 = ((l_cch.cch11+l_cch.cch21)*
                                     mccg.ccg31/(mccg.ccg11+mccg.ccg21-g_shb114))/l_ima55_fac  #FUN-B90029
                                     #mccg.ccg31/(mccg.ccg11+mccg.ccg21))/l_ima55_fac #FUN-B90029 mark                                     
#No.MOD-B30085 --end
                  #FUN-CC0002(S)
                  IF g_ccz.ccz45='2' THEN 
                     LET l_cch.cch311 = ((l_cch.cch11+l_cch.cch21)*-1*mccg.ccg311/(mccg.ccg11+mccg.ccg21-g_shb114))/l_ima55_fac  
                  END IF
                  #FUN-CC0002(E)
                  #LET l_sharerate = mccg.ccg31 / (mccg.ccg11 + mccg.ccg21)    #No:CHI-A30027 add #FUN-B90029 mark
                  LET l_sharerate = mccg.ccg31 / (mccg.ccg11 + mccg.ccg21-g_shb114)    #No:CHI-A30027 add  #FUN-B90029
                  LET l_adjrate = mccg.ccg31/(mccg.ccg11+mccg.ccg21)    #No:CHI-990044 add
                  IF cl_null(l_cch.cch31) THEN LET l_cch.cch31 = 0 END IF
             WHEN g_ccz.ccz05='3'
 
                  IF mccg.ccg31 <> 0 THEN
                    LET l_cch.cch31 = (l_cch.cch11+l_cch.cch21)*-1
                    LET l_sharerate = -1         #No:CHI-A30027 add
                  #  LET l_sharerate = mccg.ccg31 / (mccg.ccg11 + mccg.ccg21-g_shb114)   #tianry add 161213
                    LET l_adjrate = -1    #No:CHI-990044 add
                  ELSE
                    LET l_cch.cch31 = 0
                    LET l_sharerate = 0          #No:CHI-A30027 add
                    LET l_adjrate = 0    #No:CHI-990044 add
                  END IF
        END CASE
     END IF
     IF l_cch.cch04 = ' ADJUST'    THEN
        LET l_sfa.sfa161 = 1
#No.MOD-B30085 --begin
        LET l_ima55_fac=0
        SELECT ima55_fac INTO l_ima55_fac FROM ima_file
         WHERE ima01=mccg.ccg04
        IF cl_null(l_ima55_fac) OR l_ima55_fac=0 THEN  LET l_ima55_fac=1 END IF
        LET l_cch31_rate = mccg.ccg31/(mccg.ccg11+mccg.ccg21)    #No:CHI-990044 add
        LET l_cch.cch31 = 0   #MOD-A60053 add
        LET l_cch.cch31 =(l_cch.cch11+l_cch.cch21)*l_cch31_rate/l_ima55_fac                 #No:MOD-7A0166 add sfa13   #No:CHI-990044 modify
#No.MOD-B30085 --end
        IF cl_null(l_cch.cch31) THEN LET l_cch.cch31 = 0 END IF   #MOD-A60053 add
     END IF

     LET l_cnt2 = 0   #MOD-A60053 add
     SELECT COUNT(*) INTO l_cnt2
       FROM cch_file
      WHERE cch01 = l_cch.cch01
        AND cch02 = l_cch.cch02
        AND cch03 = l_cch.cch03
        AND cch04 = l_cch.cch04
        AND cch06 = l_cch.cch06
        AND (cch11+cch21) > 0 

     IF cl_null(l_cnt2) THEN LET l_cnt2 = 1 END IF

    #IF l_old_cch04 = l_cch.cch04 AND l_cch31*-1 >= l_sum_cch31*-1 THEN     #TQC-970003   #MOD-C50138 mark
     IF (l_old_cch04 = l_cch.cch04 AND l_cch.cch07 <> l_old_cch07 ) AND l_cch31*-1 >= l_sum_cch31*-1 THEN   #CHI-B10036 add  
    #MOD-C50138 -- start --
     #IF l_old_cch04 = l_cch.cch04 AND l_old_sfa08 = l_sfa.sfa08     #CHI-B10036 mark
       # AND l_cch31*-1 >= l_sum_cch31*-1 THEN                       #CHI-B10036 mark
    #MOD-C50138 -- end --
        LET l_cch.cch31 = l_cch31 - l_sum_cch31 
        IF l_sfa.sfa11<>'S' THEN        #No.MOD-D30152 --begin
          #MOD-C50200 -- add start --
           IF l_cch.cch11 + l_cch.cch21 < 0 THEN    
              LET l_cch.cch31 = 0
           ELSE      
          #MOD-C50200 -- add end --
              IF l_cch.cch31 *-1 > (l_cch.cch11+l_cch.cch21) THEN
                 LET l_cch.cch31 = (l_cch.cch11+l_cch.cch21)*-1
              END IF
           END IF   #MOD-C50200 add
        END IF                          #No.MOD-D30152 --end
        LET l_sum_cch31 = l_sum_cch31 + l_cch.cch31
        LET l_sum_cch11 = l_sum_cch11 + l_cch.cch11
        LET l_sum_cch21 = l_sum_cch21 + l_cch.cch21
        LET l_cnt2 = l_cnt2 -1
     END IF
    #IF l_old_cch04 = l_cch.cch04 AND l_cch31*-1 < l_sum_cch31*-1 THEN      #TQC-970003   #MOD-C50138 mark
    #MOD-C50138 -- start --
     #IF l_old_cch04 = l_cch.cch04 AND l_old_sfa08 = l_sfa.sfa08            #CHI-B10036 mark
      #  AND l_cch31*-1 < l_sum_cch31*-1 THEN                               #CHI-B10036 mark
    #MOD-C50138 -- end --
     IF (l_old_cch04 = l_cch.cch04 AND l_cch.cch07 != l_old_cch07) AND l_cch31*-1 < l_sum_cch31*-1 THEN      #CHI-B10036 add
        LET l_cch.cch31 = 0
        LET l_cnt2 = l_cnt2 -1
     END IF  
    #IF (l_old_cch04 = ' ' OR (l_cch.cch04 != l_old_cch04  AND l_cch.cch07 <> l_old_cch07)) AND l_cch.cch04 <> ' DL+OH+SUB' THEN  #CHI-B10036 add  #MOD-C90065 mark
    #IF (l_old_cch04 = ' ' OR l_cch.cch04 != l_old_cch04) AND l_cch.cch04 <> ' DL+OH+SUB' AND l_sfa.sfa11<>'S' THEN   #MOD-C90065 add    #No.MOD-D30152 add <> 'S'  #MOD-D50142 mark
     IF (l_old_cch04 = ' ' OR l_cch.cch04 != l_old_cch04) AND l_cch.cch04 <> ' DL+OH+SUB' AND l_cch.cch04 <> ' ADJUST' AND l_sfa.sfa11<>'S' THEN #MOD-D50142 add l_cch.cch04 <> ' ADJUST' 
    #IF l_old_cch04 = ' ' AND l_cch.cch04 <> ' DL+OH+SUB' THEN             #CHI-B10036 mark
       #MOD-C50200 -- add start --
        IF l_cch.cch11 + l_cch.cch21 < 0 THEN
           LET l_cch.cch31 = 0
        ELSE
       #MOD-C50200 -- add end --
           IF (l_cch.cch11+l_cch.cch21) < l_cch.cch31*-1 THEN
           #-------------No:CHI-AA0002 add
            IF l_cch.cch11 + l_cch.cch21 < 0 THEN
              #LET l_cch.cch31 = l_cch.cch31 *-1         #MOD-D10018 mark
            ELSE
           #-------------No:CHI-AA0002 end
               LET l_cch.cch31 = (l_cch.cch11+l_cch.cch21)*-1
            END IF      #No:CHI-AA0002 add
           END IF
        END IF   #MOD-C50200 add
        LET l_sum_cch11 = l_sum_cch11 + l_cch.cch11
        LET l_sum_cch21 = l_sum_cch21 + l_cch.cch21
        LET l_sum_cch31 = l_sum_cch31 + l_cch.cch31
     END IF
     IF l_cch.cch04 != ' DL+OH+SUB' THEN 
        LET l_old_cch04 = l_cch.cch04
     END IF
     LET l_old_sfa08 = l_sfa.sfa08   #MOD-C50138 add

     #-------- (970113 roger) 特別處理'被替代料(sfa26=3/4)及'替代料(sfa26=S/U)'
     IF l_sfa.sfa26 MATCHES '[348]' AND l_cnt2 = 1        #FUN-A20037 add 8
        AND (l_sum_cch11+l_sum_cch21) < l_cch31*-1 AND l_cch.cch04 != ' DL+OH+SUB' THEN
        LET l_sub_qty = l_cch31 - l_sum_cch31 
        CALL p500_sub(l_cch.cch01,l_cch.cch04,l_sub_qty)
     END IF
     IF l_sfa.sfa26 MATCHES '[SUZ]' AND   #FUN-A20037 add Z
        l_cch.cch04 != ' DL+OH+SUB' THEN #MOD-4A0185
       #MOD-DB0067 add begin-----------------------------
       #sfa26為SUZ替代料時，如果工單備料中同時存在與此替代料相同的非替代料，則去cch_file中cch31，否则取sub_tmp中tmp02
       #算元件时，会加上替代料的料，所以直接取cch_file中cch31就可以
        LET l_cnt4 = 0
        SELECT COUNT(*) INTO l_cnt4 FROM sfa_file 
         WHERE sfa01 = l_sfa.sfa01
           AND sfa26 NOT IN ('3','4','8','S','U','Z')
           AND sfa03 = l_sfa.sfa03
        IF l_cnt4 <= 0 THEN 
       #MOD-DB0067 add end ------------------------------
           LET l_cch.cch31 = 0
          #SELECT tmp02 INTO l_cch.cch31 FROM sub_tmp WHERE tmp01=l_cch.cch04  and tmp03 = l_cch.cch07
           SELECT SUM(tmp02) INTO l_cch.cch31 FROM sub_tmp WHERE tmp01=l_cch.cch04  and tmp03 = l_cch.cch07   #MOD-DB0067 add SUM()
           IF l_cch.cch31 IS NULL THEN LET l_cch.cch31 = 0 END IF
       #MOD-DB0067 add begin-----------------------------
        ELSE 
           SELECT cch31 INTO l_cch.cch31 FROM cch_file 
            WHERE cch01 = l_cch.cch01 AND cch02 = l_cch.cch02
              AND cch03 = l_cch.cch03 AND cch04 = l_cch.cch04
              AND cch06 = l_cch.cch06 AND cch07 = l_cch.cch07
           IF l_cch.cch31 IS NULL THEN LET l_cch.cch31 = 0 END IF
        END IF 
       #MOD-DB0067 add end ------------------------------
     END IF

#No.FUN-D10031 --begin
#处理某料既是元件又是替代料（sfa03）的情况，按目前的逻辑先走sfa26=S的那一笔替代料，然后再走元件，cch31前者会被后者覆盖，应该累加
     IF l_old_cch04 = l_cch.cch04 AND l_old_sfa08 = l_sfa.sfa08 AND
        l_sfa.sfa26 NOT MATCHES '[348SUZ]' AND l_cnt2 = 1  AND l_cch.cch04 != ' DL+OH+SUB' THEN
        LET l_cch31n = 0
       #SELECT tmp02 INTO l_cch31n FROM sub_tmp WHERE tmp01=l_cch.cch04  and tmp03 = l_cch.cch07
        SELECT SUM(tmp02) INTO l_cch31n FROM sub_tmp WHERE tmp01=l_cch.cch04  and tmp03 = l_cch.cch07  #MOD-DB0067 add SUM()
        IF l_cch.cch31 IS NULL THEN LET l_cch.cch31 = 0 END IF
        IF l_cch31n IS NULL THEN LET l_cch31n = 0 END IF #MOD-E40023
        LET l_cch.cch31 = l_cch.cch31 + l_cch31n
     END IF     
#No.FUN-D10031 --end

     LET qty2= mccg.ccg11+ mccg.ccg21
     LET qty =l_cch.cch11+l_cch.cch21
 
     ## 若拆件式工單用退料方式入庫, 則.
     IF (l_cch.cch11+l_cch.cch21) < 0 AND l_sfa.sfa11<>'S' THEN    #No.MOD-D30152 add <> 'S'
        LET l_cch.cch31 = l_cch.cch31 * -1
     END IF
 
     ## 若期初+本期無投入,..
     IF (l_cch.cch11+l_cch.cch21) = 0 THEN
        LET l_cch.cch31 = 0
     END IF
 
     SELECT sfl07 INTO l_cch.cch311 FROM sfl_temp   #No.MOD-7C0126 
      WHERE sfl02=g_sfb.sfb01 AND sfl03=l_cch.cch04 #No.MOD-7C0126 
 
     IF cl_null(l_cch.cch311) THEN LET l_cch.cch311=0 END IF
     #FUN-CC0002(S)
     IF g_ccz.ccz45='2' THEN   #当站报废当月转出
       LET l_cnt3=0 
       SELECT COUNT(*) INTO l_cnt3 FROM shb_temp
        WHERE shb05 = g_sfb.sfb01
       IF l_cnt3>0 AND l_cch.cch04<>' DL+OH+SUB' THEN 
          LET l_shb112 = 0        
          IF l_sfa.sfa08=' ' THEN 
             SELECT SUM(shb112) INTO l_shb112 FROM shb_temp
              WHERE shb05 = g_sfb.sfb01
          ELSE
             DECLARE ecm_cur CURSOR FOR
             SELECT ecm03 FROM ecm_file
              WHERE ecm01 = g_sfb.sfb01
                AND ecm04 = l_sfa.sfa08
             FOREACH ecm_cur INTO l_ecm03
               LET l_qty=0       
               SELECT SUM(shb112) INTO l_qty FROM shb_temp
                WHERE shb05 = g_sfb.sfb01
                  AND shb06 >= l_ecm03
               LET l_shb112 = l_shb112+l_qty 
             END FOREACH
          END IF
          IF cl_null(l_shb112) THEN LET l_shb112=0 END IF
          LET l_shb112 = l_shb112 * l_sfa.sfa161 * l_sfa.sfa13
          LET l_cch.cch311 = l_cch.cch311+l_shb112     
        END IF
     END IF
     #FUN-CC0002(E)

     LET l_cch.cch311 = l_cch.cch311 * -1
 
     ### 若生產 = 完工入庫套數 則下階料全數轉出 99.02.24 Star
     IF mccg.ccg11+mccg.ccg21+mccg.ccg31 = 0 AND mccg.ccg31 != 0 THEN
    #當有報廢數量cch311時,轉出數量cch31=上月結存cch11+本月投入cch21+報廢量cch311
        LET l_cch.cch31 = (l_cch.cch11+l_cch.cch21) * -1                #MOD-870111 mark
        LET l_cch.cch31 = (l_cch.cch11+l_cch.cch21+l_cch.cch311) * -1   #MOD-870111 
     END IF
 
     ### 98.04.03 Star  依上列判斷決定本月轉出數量後, 再計算下列金額
     IF l_cch.cch04=' DL+OH+SUB' AND g_ccz.ccz05='1' THEN
        LET l_cch.cch31 =(l_cch.cch11+l_cch.cch21)   * l_sharerate
        LET l_cch.cch32b=(l_cch.cch12b+l_cch.cch22b) * l_sharerate
        LET l_cch.cch32c=(l_cch.cch12c+l_cch.cch22c) * l_sharerate
        # Star For 製程委外, 有可能為製程中某一站委外, 則按比率轉出
        LET l_cch.cch32d=(l_cch.cch12d+l_cch.cch22d) * l_sharerate
        LET l_cch.cch32e=(l_cch.cch12e+l_cch.cch22e) * l_sharerate
        LET l_cch.cch32f=(l_cch.cch12f+l_cch.cch22f) * l_sharerate
        LET l_cch.cch32g=(l_cch.cch12g+l_cch.cch22g) * l_sharerate
        LET l_cch.cch32h=(l_cch.cch12h+l_cch.cch22h) * l_sharerate
     ELSE
        IF l_sfa.sfa11<>'S' THEN       #No.MOD-D30152 
          #MOD-C50200 -- add start --
           IF l_cch.cch11 + l_cch.cch21 < 0 THEN
              LET l_cch.cch31 = 0
           ELSE
          #MOD-C50200 -- add end --
              IF l_cch.cch31 * -1 > (l_cch.cch11 + l_cch.cch21 + l_cch.cch311) THEN
              #-------------No:CHI-AA0002 add
               IF l_cch.cch11 + l_cch.cch21 < 0 THEN
                  LET l_cch.cch31 = l_cch.cch31 *-1
               ELSE
              #-------------No:CHI-AA0002 end
                 LET l_cch.cch31 = (l_cch.cch11 + l_cch.cch21 + l_cch.cch311) * -1
               END IF    #No:CHI-AA0002 add
              END IF
           END IF   #MOD-C50200 add
        END IF                        #No.MOD-D30152  
        LET cost =0 LET costa=0 LET costb=0 LET costc=0 LET costd=0 LET coste=0
        LET costf=0 LET costg=0 LET costh=0   #FUN-7C0028 add
        #tianry add 161213
        LET l_tt= mccg.ccg31 / (mccg.ccg11 + mccg.ccg21-g_shb114)   #tianry add 161213
        #tianry add end 
        IF qty!=0 THEN
           LET cost = (l_cch.cch12 +l_cch.cch22 )/qty
           LET costa= (l_cch.cch12a+l_cch.cch22a)/qty
           LET costb= (l_cch.cch12b+l_cch.cch22b)/qty
           LET costc= (l_cch.cch12c+l_cch.cch22c)/qty
           LET costd= (l_cch.cch12d+l_cch.cch22d)/qty
           LET coste= (l_cch.cch12e+l_cch.cch22e)/qty
           LET costf= (l_cch.cch12f+l_cch.cch22f)/qty   #FUN-7C0028 add
           LET costg= (l_cch.cch12g+l_cch.cch22g)/qty   #FUN-7C0028 add
           LET costh= (l_cch.cch12h+l_cch.cch22h)/qty   #FUN-7C0028 add
          #加上報廢量cch311
           LET l_cch.cch32a=(l_cch.cch31+l_cch.cch311)*(l_cch.cch12a+l_cch.cch22a)/qty
           LET l_cch.cch32a=(l_cch.cch31+l_cch.cch311)*(l_cch.cch12a+l_cch.cch22a)/qty
           LET l_cch.cch32b=(l_cch.cch31+l_cch.cch311)*(l_cch.cch12b+l_cch.cch22b)/qty
           LET l_cch.cch32c=(l_cch.cch31+l_cch.cch311)*(l_cch.cch12c+l_cch.cch22c)/qty
           LET l_cch.cch32d=(l_cch.cch31+l_cch.cch311)*(l_cch.cch12d+l_cch.cch22d)/qty
           LET l_cch.cch32e=(l_cch.cch31+l_cch.cch311)*(l_cch.cch12e+l_cch.cch22e)/qty
           LET l_cch.cch32f=(l_cch.cch31+l_cch.cch311)*(l_cch.cch12f+l_cch.cch22f)/qty   #FUN-7C0028 add
           LET l_cch.cch32g=(l_cch.cch31+l_cch.cch311)*(l_cch.cch12g+l_cch.cch22g)/qty   #FUN-7C0028 add
           LET l_cch.cch32h=(l_cch.cch31+l_cch.cch311)*(l_cch.cch12h+l_cch.cch22h)/qty   #FUN-7C0028 add
       #------------------------No:CHI-A30027 add
        ELSE
           LET l_cch.cch32a=(l_cch.cch12a+l_cch.cch22a) * l_sharerate
           #tianry add 161213
           IF g_ccz.ccz05='3' THEN
              LET l_cch.cch32b=(l_cch.cch12b+l_cch.cch22b) * l_sharerate
           ELSE
               LET l_cch.cch32b=(l_cch.cch12b+l_cch.cch22b) * l_tt  
           END IF
           #tianry add 161213
           LET l_cch.cch32c=(l_cch.cch12c+l_cch.cch22c) * l_sharerate
           IF g_ccz.ccz05='3' THEN
              LET l_cch.cch32d=(l_cch.cch12d+l_cch.cch22d) * l_tt
           ELSE
              LET l_cch.cch32d=(l_cch.cch12d+l_cch.cch22d) * l_sharerate
           END IF
           LET l_cch.cch32e=(l_cch.cch12e+l_cch.cch22e) * l_sharerate
           LET l_cch.cch32f=(l_cch.cch12f+l_cch.cch22f) * l_sharerate
           LET l_cch.cch32g=(l_cch.cch12g+l_cch.cch22g) * l_sharerate
           LET l_cch.cch32h=(l_cch.cch12h+l_cch.cch22h) * l_sharerate
       #------------------------No:CHI-A30027 end
        END IF
       #------------------No:CHI-990044 add
        IF l_cch.cch04 = ' ADJUST' THEN
           IF qty = 0 THEN
              LET cost = (l_cch.cch12 +l_cch.cch22 )
              LET costa= (l_cch.cch12a+l_cch.cch22a)
              LET costb= (l_cch.cch12b+l_cch.cch22b)
              LET costc= (l_cch.cch12c+l_cch.cch22c)
              LET costd= (l_cch.cch12d+l_cch.cch22d)
              LET coste= (l_cch.cch12e+l_cch.cch22e)
             #MOD-D50120 add begin-----------------------
              LET costf= (l_cch.cch12f+l_cch.cch22f)
              LET costg= (l_cch.cch12g+l_cch.cch22g)
              LET costh= (l_cch.cch12h+l_cch.cch22h)
             #MOD-D50120 add end-------------------------
           END IF

           LET l_cch.cch32a=(l_cch.cch12a+l_cch.cch22a) * l_cch31_rate
           LET l_cch.cch32b=(l_cch.cch12b+l_cch.cch22b) * l_adjrate
           LET l_cch.cch32c=(l_cch.cch12c+l_cch.cch22c) * l_adjrate
           LET l_cch.cch32d=(l_cch.cch12d+l_cch.cch22d) * l_adjrate
           LET l_cch.cch32e=(l_cch.cch12e+l_cch.cch22e) * l_cch31_rate
          #MOD-D50120 add begin-----------------------
           LET l_cch.cch32f=(l_cch.cch12f+l_cch.cch22f) * l_adjrate
           LET l_cch.cch32g=(l_cch.cch12g+l_cch.cch22g) * l_adjrate
           LET l_cch.cch32h=(l_cch.cch12h+l_cch.cch22h) * l_adjrate
          #MOD-D50120 add end-------------------------
        END IF   
       #------------------No:CHI-990044 end
        #------------- (970109 roger) 成品淨退庫時, 若當期無單位成本, 則取前期
        IF mccg.ccg31 > 0 AND cost=0 THEN
           #CHI-C80002---begin mark
           #DECLARE wip_32_c2 CURSOR FOR
           #  SELECT * FROM cch_file
           #   WHERE cch01=l_cch.cch01 AND (cch02*12+cch03) < (yy*12+mm)
           #     AND cch04=l_cch.cch04
           #     AND cch06=type        AND cch07=l_cch.cch07
           #   ORDER BY cch02 DESC,cch03 DESC
           #FOREACH wip_32_c2 INTO last_cch.*
           #CHI-C80002---end
           FOREACH wip_32_c2 USING l_cch.cch01,yy,mm,l_cch.cch04,type,l_cch.cch07 INTO last_cch.*  #CHI-C80002
             LET last_qty =last_cch.cch11+last_cch.cch21
             IF last_qty!=0 THEN
                LET cost = (last_cch.cch12 +last_cch.cch22 )/last_qty
                LET costa= (last_cch.cch12a+last_cch.cch22a)/last_qty
                LET costb= (last_cch.cch12b+last_cch.cch22b)/last_qty
                LET costc= (last_cch.cch12c+last_cch.cch22c)/last_qty
                LET costd= (last_cch.cch12d+last_cch.cch22d)/last_qty
                LET coste= (last_cch.cch12e+last_cch.cch22e)/last_qty
                LET costf= (last_cch.cch12f+last_cch.cch22f)/last_qty   #FUN-7C0028 add
                LET costg= (last_cch.cch12g+last_cch.cch22g)/last_qty   #FUN-7C0028 add
                LET costh= (last_cch.cch12h+last_cch.cch22h)/last_qty   #FUN-7C0028 add
               #加上報廢量cch311
                LET l_cch.cch32 =(l_cch.cch31+l_cch.cch311)*
                                 (last_cch.cch12 +last_cch.cch22 )/last_qty
                LET l_cch.cch32a=(l_cch.cch31+l_cch.cch311)*
                                 (last_cch.cch12a+last_cch.cch22a)/last_qty
                LET l_cch.cch32b=(l_cch.cch31+l_cch.cch311)*
                                 (last_cch.cch12b+last_cch.cch22b)/last_qty
                LET l_cch.cch32c=(l_cch.cch31+l_cch.cch311)*
                                 (last_cch.cch12c+last_cch.cch22c)/last_qty
                LET l_cch.cch32d=(l_cch.cch31+l_cch.cch311)*
                                 (last_cch.cch12d+last_cch.cch22d)/last_qty
                LET l_cch.cch32e=(l_cch.cch31+l_cch.cch311)*
                                 (last_cch.cch12e+last_cch.cch22e)/last_qty
                LET l_cch.cch32f=(l_cch.cch31+l_cch.cch311)*
                                 (last_cch.cch12f+last_cch.cch22f)/last_qty
                LET l_cch.cch32g=(l_cch.cch31+l_cch.cch311)*
                                 (last_cch.cch12g+last_cch.cch22g)/last_qty
                LET l_cch.cch32h=(l_cch.cch31+l_cch.cch311)*
                                 (last_cch.cch12h+last_cch.cch22h)/last_qty
             END IF
             IF cost <> 0 THEN
                CALL cl_getmsg('axc-520',g_lang) RETURNING g_msg1
                CALL cl_getmsg('axc-510',g_lang) RETURNING g_msg2
                LET g_msg=g_msg1 CLIPPED,l_cch.cch01," ",l_cch.cch04 CLIPPED,
                          g_msg2 CLIPPED
 
                LET t_time = TIME
               #LET g_time=t_time #MOD-C30891 mark
               #FUN-A50075--mod--str--ccy_file del plant&legal
               #INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04,ccyplant,ccylegal) #No.MOD-470041 #FUN-980009 add ccyplant,ccylegal
               #              VALUES(TODAY,g_time,g_user,g_msg,g_plant,g_legal) #FUN-980009 add g_plant,g_legal
                INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04)
                             #VALUES(TODAY,g_time,g_user,g_msg) #MOD-C30891 mark
                              VALUES(TODAY,t_time,g_user,g_msg) #MOD-C30891 
               #FUN-A50075--mod--end
                EXIT FOREACH
             END IF
           END FOREACH
        END IF
     END IF
     IF l_cch.cch04=' DL+OH+SUB' THEN
        IF g_sfb.sfb24 = 'N' THEN
           LET l_cch.cch32d=l_cch.cch22d*-1
        END IF
     END IF
     #-->
     #若本期僅發生加工費且完工入庫了. 應要全數轉出,造成有入庫數量但無金額
     # 000921 By Star For 若本期僅發生加工費且完工入庫了. 應要全數轉出
     IF (g_sfb.sfb38 >= g_bdate AND g_sfb.sfb38 <= g_edate)
     OR (mccg.ccg11+mccg.ccg21+mccg.ccg31 = 0 AND mccg.ccg31 != 0
     AND l_cch.cch04 = ' DL+OH+SUB') THEN
    #當有報廢數量cch311時,轉出數量cch31=上月結存cch11+本月投入cch21+報廢量cch311
        LET l_cch.cch31 =(l_cch.cch11 +l_cch.cch21 )*-1               #MOD-870111 mark
        LET l_cch.cch31 =(l_cch.cch11 +l_cch.cch21+l_cch.cch311)*-1   #MOD-870111
        LET l_cch.cch32 =(l_cch.cch12 +l_cch.cch22 )*-1
        LET l_cch.cch32a=(l_cch.cch12a+l_cch.cch22a)*-1
        LET l_cch.cch32b=(l_cch.cch12b+l_cch.cch22b)*-1
        LET l_cch.cch32c=(l_cch.cch12c+l_cch.cch22c)*-1
        LET l_cch.cch32d=(l_cch.cch12d+l_cch.cch22d)*-1
        LET l_cch.cch32e=(l_cch.cch12e+l_cch.cch22e)*-1
        LET l_cch.cch32f=(l_cch.cch12f+l_cch.cch22f)*-1   #FUN-7C0028 add
        LET l_cch.cch32g=(l_cch.cch12g+l_cch.cch22g)*-1   #FUN-7C0028 add
        LET l_cch.cch32h=(l_cch.cch12h+l_cch.cch22h)*-1   #FUN-7C0028 add
     END IF
     LET l_cch.cch32 =l_cch.cch32a+l_cch.cch32b+l_cch.cch32c+
                      l_cch.cch32d+l_cch.cch32e
                     +l_cch.cch32f+l_cch.cch32g+l_cch.cch32h   #FUN-7C0028 add
 
     #當該月工單無入庫量,但工單下階元件有報廢量時,將本月轉出金額清為0
     IF l_cch.cch31 = 0 AND l_cch.cch311 != 0                  #No.MOD-8C0072 add
     AND (g_sfb.sfb38 > g_edate OR g_sfb.sfb38 IS NULL) THEN   #No.MOD-8C0072 add
        LET l_cch.cch32a= 0
        LET l_cch.cch32b= 0
        LET l_cch.cch32c= 0
        LET l_cch.cch32d= 0
        LET l_cch.cch32e= 0
        LET l_cch.cch32f= 0   #FUN-7C0028 add
        LET l_cch.cch32g= 0   #FUN-7C0028 add
        LET l_cch.cch32h= 0   #FUN-7C0028 add
        LET l_cch.cch32 = 0
     END IF
 
#差異成本歸屬方式參數化(ccz09)
     IF g_ccz.ccz09 = 'N' THEN
       ## 若當期未轉出即結案 , 則歸差異成本
        IF (g_sfb.sfb38 >= g_bdate AND g_sfb.sfb38 <= g_edate)
           AND mccg.ccg31 = 0 THEN
           LET l_cch.cch41 = l_cch.cch31
           LET l_cch.cch42 = l_cch.cch32
           LET l_cch.cch42a = l_cch.cch32a
           LET l_cch.cch42b = l_cch.cch32b
           LET l_cch.cch42c = l_cch.cch32c
           LET l_cch.cch42d = l_cch.cch32d
           LET l_cch.cch42e = l_cch.cch32e
           LET l_cch.cch42f = l_cch.cch32f   #FUN-7C0028 add
           LET l_cch.cch42g = l_cch.cch32g   #FUN-7C0028 add
           LET l_cch.cch42h = l_cch.cch32h   #FUN-7C0028 add
           LET l_cch.cch31 = 0
           LET l_cch.cch32 = 0
           LET l_cch.cch32a= 0
           LET l_cch.cch32b= 0
           LET l_cch.cch32c= 0
           LET l_cch.cch32d= 0
           LET l_cch.cch32e= 0
           LET l_cch.cch32f= 0   #FUN-7C0028 add
           LET l_cch.cch32g= 0   #FUN-7C0028 add
           LET l_cch.cch32h= 0   #FUN-7C0028 add
        END IF
     END IF

#No.MOD-CB0035 --begin     目的：使得人工、制费金额转出的时候不会大于期初+投入
     IF l_cch.cch12b+l_cch.cch22b+l_cch.cch32b<0  AND l_cch.cch04 = ' DL+OH+SUB' THEN #人工
         LET l_cch.cch32b=(l_cch.cch12b+l_cch.cch22b)*-1
     END IF
     IF l_cch.cch12c+l_cch.cch22c+l_cch.cch32c<0  AND l_cch.cch04 = ' DL+OH+SUB' THEN  #制费一
         LET l_cch.cch32c=(l_cch.cch12c+l_cch.cch22c)*-1
     END IF
     IF l_cch.cch12d+l_cch.cch22d+l_cch.cch32d<0  AND l_cch.cch04 = ' DL+OH+SUB' THEN  #加工费
         LET l_cch.cch32d=(l_cch.cch12d+l_cch.cch22d)*-1
     END IF
     IF l_cch.cch12e+l_cch.cch22e+l_cch.cch32e<0  AND l_cch.cch04 = ' DL+OH+SUB' THEN  #制费二
         LET l_cch.cch32e=(l_cch.cch12e+l_cch.cch22e)*-1
     END IF
     IF l_cch.cch12f+l_cch.cch22f+l_cch.cch32f<0  AND l_cch.cch04 = ' DL+OH+SUB' THEN  #制费三
         LET l_cch.cch32f=(l_cch.cch12f+l_cch.cch22f)*-1 
     END IF 
     IF l_cch.cch12g+l_cch.cch22g+l_cch.cch32g<0  AND l_cch.cch04 = ' DL+OH+SUB' THEN  #制费四 
         LET l_cch.cch32g=(l_cch.cch12g+l_cch.cch22g)*-1 
     END IF
     IF l_cch.cch12h+l_cch.cch22h+l_cch.cch32h<0  AND l_cch.cch04 = ' DL+OH+SUB' THEN  #制费五  
         LET l_cch.cch32h=(l_cch.cch12h+l_cch.cch22h)*-1  
     END IF 
#No.MOD-CB0035 --end 
#No.MOD-CB0127 --begin
     LET l_cch.cch32 =l_cch.cch32a+l_cch.cch32b+l_cch.cch32c+
                      l_cch.cch32d+l_cch.cch32e+
                      l_cch.cch32f+l_cch.cch32g+l_cch.cch32h 
#No.MOD-CB0127 --end 
 
   #-------------------------- 4. WIP-元件 本期結存成本
     LET l_cch.cch91 =l_cch.cch11 +l_cch.cch21 +l_cch.cch31 +l_cch.cch41
                     +l_cch.cch59 +l_cch.cch311   #FUN-660197 add l_cch.cch311
     LET l_cch.cch92 =l_cch.cch12 +l_cch.cch22 +l_cch.cch32 +l_cch.cch42
                     +l_cch.cch60
     LET l_cch.cch92a=l_cch.cch12a+l_cch.cch22a+l_cch.cch32a+l_cch.cch42a
                     +l_cch.cch60a
     LET l_cch.cch92b=l_cch.cch12b+l_cch.cch22b+l_cch.cch32b+l_cch.cch42b
                     +l_cch.cch60b
     LET l_cch.cch92c=l_cch.cch12c+l_cch.cch22c+l_cch.cch32c+l_cch.cch42c
                     +l_cch.cch60c
     LET l_cch.cch92d=l_cch.cch12d+l_cch.cch22d+l_cch.cch32d+l_cch.cch42d
                     +l_cch.cch60d
     LET l_cch.cch92e=l_cch.cch12e+l_cch.cch22e+l_cch.cch32e+l_cch.cch42e
                     +l_cch.cch60e
     LET l_cch.cch92f=l_cch.cch12f+l_cch.cch22f+l_cch.cch32f+l_cch.cch42f
                     +l_cch.cch60f
     LET l_cch.cch92g=l_cch.cch12g+l_cch.cch22g+l_cch.cch32g+l_cch.cch42g
                     +l_cch.cch60g
     LET l_cch.cch92h=l_cch.cch12h+l_cch.cch22h+l_cch.cch32h+l_cch.cch42h
                     +l_cch.cch60h
 
     #-->累計轉出 = 累計發料 - 期末在製
     LET l_cch.cch53  =  l_cch.cch91  - l_cch.cch51
     LET l_cch.cch54  =  l_cch.cch92  - l_cch.cch52
     LET l_cch.cch54a =  l_cch.cch92a - l_cch.cch52a
     LET l_cch.cch54b =  l_cch.cch92b - l_cch.cch52b
     LET l_cch.cch54c =  l_cch.cch92c - l_cch.cch52c
     LET l_cch.cch54d =  l_cch.cch92d - l_cch.cch52d
     LET l_cch.cch54e =  l_cch.cch92e - l_cch.cch52e
     LET l_cch.cch54f =  l_cch.cch92f - l_cch.cch52f   #FUN-7C0028 add
     LET l_cch.cch54g =  l_cch.cch92g - l_cch.cch52g   #FUN-7C0028 add
     LET l_cch.cch54h =  l_cch.cch92h - l_cch.cch52h   #FUN-7C0028 add
 
    #MOD-B30061---add---start---
     IF cl_null(l_cch.cch31) THEN LET l_cch.cch31 = 0 END IF
     IF cl_null(l_cch.cch32) THEN LET l_cch.cch32 = 0 END IF
     IF cl_null(l_cch.cch32a) THEN LET l_cch.cch32a = 0 END IF
     IF cl_null(l_cch.cch32b) THEN LET l_cch.cch32b = 0 END IF
     IF cl_null(l_cch.cch32c) THEN LET l_cch.cch32c = 0 END IF
     IF cl_null(l_cch.cch32d) THEN LET l_cch.cch32d = 0 END IF
     IF cl_null(l_cch.cch32e) THEN LET l_cch.cch32e = 0 END IF
     IF cl_null(l_cch.cch91) THEN LET l_cch.cch91 = 0 END IF
     IF cl_null(l_cch.cch92) THEN LET l_cch.cch92 = 0 END IF
     IF cl_null(l_cch.cch92a) THEN LET l_cch.cch92a = 0 END IF
     IF cl_null(l_cch.cch92b) THEN LET l_cch.cch92b = 0 END IF
     IF cl_null(l_cch.cch92c) THEN LET l_cch.cch92c = 0 END IF
     IF cl_null(l_cch.cch92d) THEN LET l_cch.cch92d = 0 END IF
     IF cl_null(l_cch.cch92e) THEN LET l_cch.cch92e = 0 END IF
    #MOD-B30061---add---end---
     #MOD-E40023 add begin----------------
     IF cl_null(l_cch.cch32f) THEN LET l_cch.cch32f = 0 END IF
     IF cl_null(l_cch.cch32g) THEN LET l_cch.cch32g = 0 END IF
     IF cl_null(l_cch.cch32h) THEN LET l_cch.cch32h = 0 END IF
     IF cl_null(l_cch.cch92f) THEN LET l_cch.cch92f = 0 END IF
     IF cl_null(l_cch.cch92g) THEN LET l_cch.cch92g = 0 END IF
     IF cl_null(l_cch.cch92h) THEN LET l_cch.cch92h = 0 END IF
     #MOD-E40023 add end-------------------    
     UPDATE cch_file SET * = l_cch.*
      WHERE cch01=l_cch.cch01 AND cch02=yy AND cch03=mm AND cch04=l_cch.cch04
        AND cch06=type        AND cch07=l_cch.cch07
     IF STATUS THEN 
      CALL cl_err3("upd","cch_file",l_cch.cch01,yy,STATUS,"","upd cch.*:",1)   #No.FUN-660127
     RETURN END IF
     IF l_cch.cch11 =0 AND l_cch.cch12a=0 AND l_cch.cch12b=0 AND
        l_cch.cch12 =0 AND l_cch.cch12c=0 AND l_cch.cch12d=0 AND
        l_cch.cch12e=0 AND l_cch.cch12f=0 AND l_cch.cch12g=0 AND l_cch.cch12h=0 AND   #FUN-7C0028 add
        l_cch.cch21 =0 AND l_cch.cch22a=0 AND l_cch.cch22b=0 AND
        l_cch.cch22 =0 AND l_cch.cch22c=0 AND l_cch.cch22d=0 AND
        l_cch.cch22e=0 AND l_cch.cch22f=0 AND l_cch.cch22g=0 AND l_cch.cch22h=0 AND   #FUN-7C0028 add
        l_cch.cch31 =0 AND l_cch.cch32a=0 AND l_cch.cch32b=0 AND
        l_cch.cch32 =0 AND l_cch.cch32c=0 AND l_cch.cch32d=0 AND
        l_cch.cch32e=0 AND l_cch.cch32f=0 AND l_cch.cch32g=0 AND l_cch.cch32h=0 AND   #FUN-7C0028 add
        l_cch.cch41 =0 AND l_cch.cch42a=0 AND l_cch.cch42b=0 AND
        l_cch.cch42 =0 AND l_cch.cch42c=0 AND l_cch.cch42d=0 AND
        l_cch.cch42e=0 AND l_cch.cch42f=0 AND l_cch.cch42g=0 AND l_cch.cch42h=0 AND   #FUN-7C0028 add
        l_cch.cch59 =0 AND l_cch.cch60a=0 AND l_cch.cch60b=0 AND
        l_cch.cch60 =0 AND l_cch.cch60c=0 AND l_cch.cch60d=0 AND
        l_cch.cch60e=0 AND l_cch.cch60f=0 AND l_cch.cch60g=0 AND l_cch.cch60h=0 AND   #FUN-7C0028 add
        l_cch.cch91 =0 AND l_cch.cch92a=0 AND l_cch.cch92b=0 AND
        l_cch.cch92 =0 AND l_cch.cch92c=0 AND l_cch.cch92d=0 AND
        l_cch.cch92e=0 AND l_cch.cch92f=0 AND l_cch.cch92g=0 AND l_cch.cch92h=0 THEN  #FUN-7C0028 add
        DELETE FROM cch_file
        WHERE cch01=l_cch.cch01 AND cch02=yy AND cch03=mm AND cch04=l_cch.cch04
          AND cch06=type        AND cch07=l_cch.cch07
     END IF
   END FOREACH
   CLOSE wip_32_c1
END FUNCTION
 
FUNCTION p500_sub(p_sfa01,p_sfa27,p_sub_qty)
   DEFINE p_sfa01         LIKE type_file.chr20       #No.FUN-680122CHAR(20)
   DEFINE p_sfa27         LIKE sfa_file.sfa27        #No.MOD-490217
   DEFINE p_sub_qty       LIKE cch_file.cch31        #No.FUN-680122DEC(15,3)
   DEFINE l_sfa           RECORD LIKE sfa_file.*
   DEFINE l_cch           RECORD LIKE cch_file.*
   DEFINE l_sql           STRING  #CHI-C80002

   #CHI-C80002---begin
   LET l_sql = " INSERT INTO sub_tmp VALUES(?,?,?) "
   PREPARE p500_ins_sub_p1 FROM l_sql
   #CHI-C80002---end
   DECLARE p500_sub_c1 CURSOR FOR
     SELECT * FROM sfa_file, cch_file
      WHERE sfa01=p_sfa01 AND sfa27=p_sfa27 AND sfa26 IN ('S','U','Z')  #FUN-A20037 add Z
        AND sfa01=cch01   AND cch02=yy AND cch03=mm AND sfa03=cch04
        AND cch06=type  
      ORDER BY sfa03
   FOREACH p500_sub_c1 INTO l_sfa.*, l_cch.*
     LET p_sub_qty = p_sub_qty * l_sfa.sfa28
     IF ((l_cch.cch11+l_cch.cch21) >= p_sub_qty*-1) OR
        (l_cch.cch11 IS NULL AND l_cch.cch21 IS NULL) THEN
        LET l_cch.cch31 = p_sub_qty
        #INSERT INTO sub_tmp VALUES(l_sfa.sfa03,l_cch.cch07,l_cch.cch31)  #No.TQC-970003 #CHI-C80002
        EXECUTE p500_ins_sub_p1 USING l_sfa.sfa03,l_cch.cch07,l_cch.cch31 #CHI-C80002
        IF STATUS THEN 
         CALL cl_err3("ins","sub_tmp","","",STATUS,"","ins sub_tmp",1)   #No.FUN-660127
        END IF
        EXIT FOREACH
     ELSE 
        LET l_cch.cch31 = (l_cch.cch11+l_cch.cch21)*-1
        #INSERT INTO sub_tmp VALUES(l_sfa.sfa03,l_cch.cch07,l_cch.cch31)  #No.TQC-970003 #CHI-C80002
        EXECUTE p500_ins_sub_p1 USING l_sfa.sfa03,l_cch.cch07,l_cch.cch31 #CHI-C80002
        IF STATUS THEN 
         CALL cl_err3("ins","sub_tmp","","",STATUS,"","ins sub_tmp",1)   #No.FUN-660127
        END IF
        IF cl_null(l_cch.cch11) THEN LET l_cch.cch11 = 0 END IF
        IF cl_null(l_cch.cch21) THEN LET l_cch.cch21 = 0 END IF
        LET p_sub_qty = p_sub_qty + (l_cch.cch11+l_cch.cch21)
        LET p_sub_qty = p_sub_qty / l_sfa.sfa28
     END IF
   END FOREACH
   CLOSE p500_sub_c1
END FUNCTION
 
FUNCTION wip_4()        # 計算每張工單的 WIP-主件 成本 (ccg)
 SELECT SUM(cch12),SUM(cch12a),SUM(cch12b),SUM(cch12c),SUM(cch12d),SUM(cch12e),
                   SUM(cch12f),SUM(cch12g),SUM(cch12h),   #FUN-7C0028 add
        SUM(cch22),SUM(cch22a),SUM(cch22b),SUM(cch22c),SUM(cch22d),SUM(cch22e),
                   SUM(cch22f),SUM(cch22g),SUM(cch22h),   #FUN-7C0028 add
        SUM(cch32),SUM(cch32a),SUM(cch32b),SUM(cch32c),SUM(cch32d),SUM(cch32e),
                   SUM(cch32f),SUM(cch32g),SUM(cch32h),   #FUN-7C0028 add
        SUM(cch42),SUM(cch42a),SUM(cch42b),SUM(cch42c),SUM(cch42d),SUM(cch42e),
                   SUM(cch42f),SUM(cch42g),SUM(cch42h),   #FUN-7C0028 add
        SUM(cch92),SUM(cch92a),SUM(cch92b),SUM(cch92c),SUM(cch92d),SUM(cch92e)
                  ,SUM(cch92f),SUM(cch92g),SUM(cch92h)    #FUN-7C0028 add
   INTO mccg.ccg12,mccg.ccg12a,mccg.ccg12b,mccg.ccg12c,mccg.ccg12d,mccg.ccg12e,
                   mccg.ccg12f,mccg.ccg12g,mccg.ccg12h,   #FUN-7C0028 add
        mccg.ccg22,mccg.ccg22a,mccg.ccg22b,mccg.ccg22c,mccg.ccg22d,mccg.ccg22e,
                   mccg.ccg22f,mccg.ccg22g,mccg.ccg22h,   #FUN-7C0028 add
        mccg.ccg32,mccg.ccg32a,mccg.ccg32b,mccg.ccg32c,mccg.ccg32d,mccg.ccg32e,
                   mccg.ccg32f,mccg.ccg32g,mccg.ccg32h,   #FUN-7C0028 add
        mccg.ccg42,mccg.ccg42a,mccg.ccg42b,mccg.ccg42c,mccg.ccg42d,mccg.ccg42e,
                   mccg.ccg42f,mccg.ccg42g,mccg.ccg42h,   #FUN-7C0028 add
        mccg.ccg92,mccg.ccg92a,mccg.ccg92b,mccg.ccg92c,mccg.ccg92d,mccg.ccg92e
                  ,mccg.ccg92f,mccg.ccg92g,mccg.ccg92h    #FUN-7C0028 add
   FROM cch_file
  WHERE cch01=g_sfb.sfb01 AND cch02=yy AND cch03=mm
    AND cch06=type 
 IF mccg.ccg12 IS NULL THEN
    LET mccg.ccg12 = 0 LET mccg.ccg12a= 0 LET mccg.ccg12b= 0
    LET mccg.ccg12c= 0 LET mccg.ccg12d= 0 LET mccg.ccg12e= 0
    LET mccg.ccg12f= 0 LET mccg.ccg12g= 0 LET mccg.ccg12h= 0   #FUN-7C0028 add
    LET mccg.ccg22 = 0 LET mccg.ccg22a= 0 LET mccg.ccg22b= 0
    LET mccg.ccg22c= 0 LET mccg.ccg22d= 0 LET mccg.ccg22e= 0
    LET mccg.ccg22f= 0 LET mccg.ccg22g= 0 LET mccg.ccg22h= 0   #FUN-7C0028 add
    LET mccg.ccg32 = 0 LET mccg.ccg32a= 0 LET mccg.ccg32b= 0
    LET mccg.ccg32c= 0 LET mccg.ccg32d= 0 LET mccg.ccg32e= 0
    LET mccg.ccg32f= 0 LET mccg.ccg32g= 0 LET mccg.ccg32h= 0   #FUN-7C0028 add
    LET mccg.ccg42 = 0 LET mccg.ccg42a= 0 LET mccg.ccg42b= 0
    LET mccg.ccg42c= 0 LET mccg.ccg42d= 0 LET mccg.ccg42e= 0
    LET mccg.ccg42f= 0 LET mccg.ccg42g= 0 LET mccg.ccg42h= 0   #FUN-7C0028 add
    LET mccg.ccg92 = 0 LET mccg.ccg92a= 0 LET mccg.ccg92b= 0
    LET mccg.ccg92c= 0 LET mccg.ccg92d= 0 LET mccg.ccg92e= 0
    LET mccg.ccg92f= 0 LET mccg.ccg92g= 0 LET mccg.ccg92h= 0   #FUN-7C0028 add
 END IF
 #--->取半成品
 SELECT SUM(cch22),SUM(cch22a),SUM(cch22b),SUM(cch22c),SUM(cch22d),SUM(cch22e)
                  ,SUM(cch22f),SUM(cch22g),SUM(cch22h)   #FUN-7C0028 add   #No.MOD-A80020
   INTO mccg.ccg23,mccg.ccg23a,mccg.ccg23b,mccg.ccg23c,mccg.ccg23d,mccg.ccg23e
                  ,mccg.ccg23f,mccg.ccg23g,mccg.ccg23h   #FUN-7C0028 add
   FROM cch_file
  WHERE cch01=g_cch.cch01 AND cch02=g_cch.cch02 AND cch03=g_cch.cch03
    AND cch06=type
    AND cch05 IN ('M','R')
 IF mccg.ccg23 IS NULL THEN
    LET mccg.ccg23 = 0 LET mccg.ccg23a= 0 LET mccg.ccg23b= 0
    LET mccg.ccg23c= 0 LET mccg.ccg23d= 0 LET mccg.ccg23e= 0
    LET mccg.ccg23f= 0 LET mccg.ccg23g= 0 LET mccg.ccg23h= 0   #FUN-7C0028 add
 END IF
 LET mccg.ccg22 =mccg.ccg22 -mccg.ccg23
 LET mccg.ccg22a=mccg.ccg22a-mccg.ccg23a
 LET mccg.ccg22b=mccg.ccg22b-mccg.ccg23b
 LET mccg.ccg22c=mccg.ccg22c-mccg.ccg23c
 LET mccg.ccg22d=mccg.ccg22d-mccg.ccg23d
 LET mccg.ccg22e=mccg.ccg22e-mccg.ccg23e
 LET mccg.ccg22f=mccg.ccg22f-mccg.ccg23f   #FUN-7C0028 add
 LET mccg.ccg22g=mccg.ccg22g-mccg.ccg23g   #FUN-7C0028 add
 LET mccg.ccg22h=mccg.ccg22h-mccg.ccg23h   #FUN-7C0028 add
 IF cl_null(mccg.ccg311) THEN LET mccg.ccg311=0 END IF    #FUN-CC0002
 LET mccg.ccg91 =mccg.ccg11 + mccg.ccg21 + mccg.ccg31 + mccg.ccg41 + mccg.ccg311     #FUN-CC0002 add ccg311
# LET mccg.ccg91 =mccg.ccg11 + mccg.ccg21 + mccg.ccg31 + mccg.ccg41    #FUN-CC0002 mark 
 LET t_time = TIME
 LET mccg.ccguser=g_user LET mccg.ccgdate=TODAY LET mccg.ccgtime=t_time
 UPDATE ccg_file SET ccg_file.* = mccg.*
        WHERE ccg01=mccg.ccg01 AND ccg02=mccg.ccg02 AND ccg03=mccg.ccg03
          AND ccg06=type
          AND ccg07=g_tlfcost   #MOD-C60140 add
 IF STATUS THEN 
  CALL cl_err3("upd","ccg_file",mccg.ccg01,mccg.ccg02,STATUS,"","upd ccg.*:",1)   #No.FUN-660127
 RETURN END IF
     SELECT COUNT(*) INTO g_cnt FROM cch_file
        WHERE cch01=mccg.ccg01 AND cch02=yy AND cch03=mm
          AND cch06=type
     IF g_cnt=0 AND
        mccg.ccg11 =0 AND mccg.ccg12 =0 AND mccg.ccg12a=0 AND
        mccg.ccg12b=0 AND mccg.ccg12c=0 AND mccg.ccg12d=0 AND
        mccg.ccg12e=0 AND mccg.ccg12f=0 AND mccg.ccg12g=0 AND mccg.ccg12h=0 AND   #FUN-7C0028 add
        mccg.ccg20 =0 AND
        mccg.ccg21 =0 AND mccg.ccg22 =0 AND mccg.ccg22a=0 AND
        mccg.ccg22b=0 AND mccg.ccg22c=0 AND mccg.ccg22d=0 AND
        mccg.ccg22e=0 AND mccg.ccg22f=0 AND mccg.ccg22g=0 AND mccg.ccg22h=0 AND   #FUN-7C0028 add
        mccg.ccg23 =0 AND mccg.ccg23a=0 AND mccg.ccg23b=0 AND
        mccg.ccg23c=0 AND mccg.ccg23d=0 AND
        mccg.ccg23e=0 AND mccg.ccg23f=0 AND mccg.ccg23g=0 AND mccg.ccg23h=0 AND   #FUN-7C0028 add
        mccg.ccg31 =0 AND mccg.ccg32 =0 AND mccg.ccg32a=0 AND
        mccg.ccg32b=0 AND mccg.ccg32c=0 AND mccg.ccg32d=0 AND
        mccg.ccg32e=0 AND mccg.ccg32f=0 AND mccg.ccg32g=0 AND mccg.ccg32h=0 AND   #FUN-7C0028 add
        mccg.ccg41 =0 AND mccg.ccg42 =0 AND mccg.ccg42a=0 AND
        mccg.ccg42b=0 AND mccg.ccg42c=0 AND mccg.ccg42d=0 AND
        mccg.ccg42e=0 AND mccg.ccg42f=0 AND mccg.ccg42g=0 AND mccg.ccg42h=0 AND   #FUN-7C0028 add
        mccg.ccg91 =0 AND mccg.ccg92 =0 AND mccg.ccg92a=0 AND
        mccg.ccg92b=0 AND mccg.ccg92c=0 AND mccg.ccg92d=0 AND
        mccg.ccg92e=0 AND mccg.ccg92f=0 AND mccg.ccg92g=0 AND mccg.ccg92h=0 THEN  #FUN-7C0028 add
        DELETE FROM ccg_file
        WHERE ccg01=mccg.ccg01 AND ccg02=yy AND ccg03=mm
          AND ccg06=type 
        DELETE FROM cce_file
         WHERE cce01=mccg.ccg01 AND cce02=yy AND cce03=mm
           AND cce04=g_ima01 #MOD-620064
           AND cce06=type    
     END IF
END FUNCTION
 
FUNCTION wip2_4()        # 計算產品WIP主件 SUM cch  (ccg)
 SELECT SUM(cch12),SUM(cch12a),SUM(cch12b),SUM(cch12c),SUM(cch12d),SUM(cch12e),
                   SUM(cch12f),SUM(cch12g),SUM(cch12h),   #FUN-7C0028 add
        SUM(cch22),SUM(cch22a),SUM(cch22b),SUM(cch22c),SUM(cch22d),SUM(cch22e),
                   SUM(cch22f),SUM(cch22g),SUM(cch22h),   #FUN-7C0028 add
        SUM(cch32),SUM(cch32a),SUM(cch32b),SUM(cch32c),SUM(cch32d),SUM(cch32e),
                   SUM(cch32f),SUM(cch32g),SUM(cch32h),   #FUN-7C0028 add
        SUM(cch42),SUM(cch42a),SUM(cch42b),SUM(cch42c),SUM(cch42d),SUM(cch42e),
                   SUM(cch42f),SUM(cch42g),SUM(cch42h),   #FUN-7C0028 add
        SUM(cch92),SUM(cch92a),SUM(cch92b),SUM(cch92c),SUM(cch92d),SUM(cch92e)
                  ,SUM(cch92f),SUM(cch92g),SUM(cch92h)    #FUN-7C0028 add
   INTO mccg.ccg12,mccg.ccg12a,mccg.ccg12b,mccg.ccg12c,mccg.ccg12d,mccg.ccg12e,
                   mccg.ccg12f,mccg.ccg12g,mccg.ccg12h,   #FUN-7C0028 add
        mccg.ccg22,mccg.ccg22a,mccg.ccg22b,mccg.ccg22c,mccg.ccg22d,mccg.ccg22e,
                   mccg.ccg22f,mccg.ccg22g,mccg.ccg22h,   #FUN-7C0028 add
        mccg.ccg32,mccg.ccg32a,mccg.ccg32b,mccg.ccg32c,mccg.ccg32d,mccg.ccg32e,
                   mccg.ccg32f,mccg.ccg32g,mccg.ccg32h,   #FUN-7C0028 add
        mccg.ccg42,mccg.ccg42a,mccg.ccg42b,mccg.ccg42c,mccg.ccg42d,mccg.ccg42e,
                   mccg.ccg42f,mccg.ccg42g,mccg.ccg42h,   #FUN-7C0028 add
        mccg.ccg92,mccg.ccg92a,mccg.ccg92b,mccg.ccg92c,mccg.ccg92d,mccg.ccg92e
                  ,mccg.ccg92f,mccg.ccg92g,mccg.ccg92h    #FUN-7C0028 add
   FROM cch_file
  WHERE cch01=g_ima01 AND cch02=yy AND cch03=mm
    AND cch06=type
 IF mccg.ccg12 IS NULL THEN
    LET mccg.ccg12 = 0 LET mccg.ccg12a= 0 LET mccg.ccg12b= 0
    LET mccg.ccg12c= 0 LET mccg.ccg12d= 0 LET mccg.ccg12e= 0
    LET mccg.ccg12f= 0 LET mccg.ccg12g= 0 LET mccg.ccg12h= 0   #FUN-7C0028 add
    LET mccg.ccg22 = 0 LET mccg.ccg22a= 0 LET mccg.ccg22b= 0
    LET mccg.ccg22c= 0 LET mccg.ccg22d= 0 LET mccg.ccg22e= 0
    LET mccg.ccg22f= 0 LET mccg.ccg22g= 0 LET mccg.ccg22h= 0   #FUN-7C0028 add
    LET mccg.ccg32 = 0 LET mccg.ccg32a= 0 LET mccg.ccg32b= 0
    LET mccg.ccg32c= 0 LET mccg.ccg32d= 0 LET mccg.ccg32e= 0
    LET mccg.ccg32f= 0 LET mccg.ccg32g= 0 LET mccg.ccg32h= 0   #FUN-7C0028 add
    LET mccg.ccg42 = 0 LET mccg.ccg42a= 0 LET mccg.ccg42b= 0
    LET mccg.ccg42c= 0 LET mccg.ccg42d= 0 LET mccg.ccg42e= 0
    LET mccg.ccg42f= 0 LET mccg.ccg42g= 0 LET mccg.ccg42h= 0   #FUN-7C0028 add
    LET mccg.ccg92 = 0 LET mccg.ccg92a= 0 LET mccg.ccg92b= 0
    LET mccg.ccg92c= 0 LET mccg.ccg92d= 0 LET mccg.ccg92e= 0
    LET mccg.ccg92f= 0 LET mccg.ccg92g= 0 LET mccg.ccg92h= 0   #FUN-7C0028 add
 END IF
 #--->取半成品
 SELECT SUM(cch22),SUM(cch22a),SUM(cch22b),SUM(cch22c),SUM(cch22d),SUM(cch22e)
                 #,SUM(cch22f),SUM(cch12g),SUM(cch12h)   #FUN-7C0028 add  #No.MOD-A30165
                  ,SUM(cch22f),SUM(cch22g),SUM(cch22h)   #FUN-7C0028 add  #No.MOD-A30165
   INTO mccg.ccg23,mccg.ccg23a,mccg.ccg23b,mccg.ccg23c,mccg.ccg23d,mccg.ccg23e
                  ,mccg.ccg23f,mccg.ccg23g,mccg.ccg23h   #FUN-7C0028 add
   FROM cch_file
  WHERE cch01=g_cch.cch01 AND cch02=g_cch.cch02 AND cch03=g_cch.cch03
    AND cch06=type 
    AND cch05 MATCHES '[MR]'
 IF mccg.ccg23 IS NULL THEN
    LET mccg.ccg23 = 0 LET mccg.ccg23a= 0 LET mccg.ccg23b= 0
    LET mccg.ccg23c= 0 LET mccg.ccg23d= 0 LET mccg.ccg23e= 0
    LET mccg.ccg23f= 0 LET mccg.ccg23g= 0 LET mccg.ccg23h= 0   #FUN-7C0028 add
 END IF
 LET mccg.ccg22 =mccg.ccg22 -mccg.ccg23
 LET mccg.ccg22a=mccg.ccg22a-mccg.ccg23a
 LET mccg.ccg22b=mccg.ccg22b-mccg.ccg23b
 LET mccg.ccg22c=mccg.ccg22c-mccg.ccg23c
 LET mccg.ccg22d=mccg.ccg22d-mccg.ccg23d
 LET mccg.ccg22e=mccg.ccg22e-mccg.ccg23e
 LET mccg.ccg22f=mccg.ccg22f-mccg.ccg23f   #FUN-7C0028 add
 LET mccg.ccg22g=mccg.ccg22g-mccg.ccg23g   #FUN-7C0028 add
 LET mccg.ccg22h=mccg.ccg22h-mccg.ccg23h   #FUN-7C0028 add
 IF cl_null(mccg.ccg311) THEN LET mccg.ccg311=0 END IF   #FUN-CC0002
 LET mccg.ccg91 =mccg.ccg11 + mccg.ccg21 + mccg.ccg31 + mccg.ccg41 + mccg.ccg311  #FUN-CC0002 add ccg311
# LET mccg.ccg91 =mccg.ccg11 + mccg.ccg21 + mccg.ccg31 + mccg.ccg41    #FUN-CC0002 mark 
 LET t_time = TIME
 LET mccg.ccguser=g_user LET mccg.ccgdate=TODAY LET mccg.ccgtime=t_time
 UPDATE ccg_file SET ccg_file.* = mccg.*
        WHERE ccg01=mccg.ccg01 AND ccg02=mccg.ccg02 AND ccg03=mccg.ccg03
          AND ccg06=type   
 IF STATUS THEN 
  CALL cl_err3("upd","ccg_file",mccg.ccg01,mccg.ccg02,STATUS,"","upd ccg.*:",1)   #No.FUN-660127
 RETURN END IF
 SELECT COUNT(*) INTO g_cnt FROM cch_file
    WHERE cch01=mccg.ccg01 AND cch02=yy AND cch03=mm
      AND cch06=type     
 IF g_cnt=0 AND
    mccg.ccg11 =0 AND mccg.ccg12 =0 AND mccg.ccg12a=0 AND
    mccg.ccg12b=0 AND mccg.ccg12c=0 AND mccg.ccg12d=0 AND
    mccg.ccg12e=0 AND mccg.ccg12f=0 AND mccg.ccg12g=0 AND mccg.ccg12h=0 AND   #FUN-7C0028 add
    mccg.ccg20 =0 AND
    mccg.ccg21 =0 AND mccg.ccg22 =0 AND mccg.ccg22a=0 AND
    mccg.ccg22b=0 AND mccg.ccg22c=0 AND mccg.ccg22d=0 AND
    mccg.ccg22e=0 AND mccg.ccg22f=0 AND mccg.ccg22g=0 AND mccg.ccg22h=0 AND   #FUN-7C0028 add
    mccg.ccg23 =0 AND mccg.ccg23a=0 AND mccg.ccg23b=0 AND
    mccg.ccg23c=0 AND mccg.ccg23d=0 AND
    mccg.ccg23e=0 AND mccg.ccg23f=0 AND mccg.ccg23g=0 AND mccg.ccg23h=0 AND   #FUN-7C0028 add
    mccg.ccg31 =0 AND mccg.ccg32 =0 AND mccg.ccg32a=0 AND
    mccg.ccg32b=0 AND mccg.ccg32c=0 AND mccg.ccg32d=0 AND
    mccg.ccg32e=0 AND mccg.ccg32f=0 AND mccg.ccg32g=0 AND mccg.ccg32h=0 AND   #FUN-7C0028 add
    mccg.ccg41 =0 AND mccg.ccg42 =0 AND mccg.ccg42a=0 AND
    mccg.ccg42b=0 AND mccg.ccg42c=0 AND mccg.ccg42d=0 AND
    mccg.ccg42e=0 AND mccg.ccg42f=0 AND mccg.ccg42g=0 AND mccg.ccg42h=0 AND   #FUN-7C0028 add
    mccg.ccg91 =0 AND mccg.ccg92 =0 AND mccg.ccg92a=0 AND
    mccg.ccg92b=0 AND mccg.ccg92c=0 AND mccg.ccg92d=0 AND
    mccg.ccg92e=0 AND mccg.ccg92f=0 AND mccg.ccg92g=0 AND mccg.ccg92h=0 THEN  #FUN-7C0028 add
    DELETE FROM ccg_file
    WHERE ccg01=mccg.ccg01 AND ccg02=yy AND ccg03=mm
      AND ccg06=type  
    DELETE FROM cce_file
     WHERE cce01=mccg.ccg01 AND cce02=yy AND cce03=mm
       AND cce04=g_ima01 #MOD-620064                        
       AND cce06=type
 END IF
END FUNCTION
 
#98.08.27 Star 記錄拆件式工單的投入及拆件轉出
FUNCTION p500_wipx()     # 處理 WIP 在製成本 (工單性質=1/7)
   DEFINE l_cnt LIKE type_file.num5          #No.FUN-680122 SMALLINT
   DEFINE l_sql STRING                       #FUN-7C0028 add
  
   IF g_bgjob = 'N' THEN  #NO.FUN-570135 
      MESSAGE '_wipx ...'
      CALL ui.Interface.refresh()
   END IF
   CALL wipx_del()       # 先 delete cct_file, ccu_file 該主件相關資料
   LET l_sql="SELECT * FROM sfb_file",
             " WHERE sfb05 ='",g_ima01,"'",
             "   AND sfb02 ='11'",
             "   AND (sfb38 IS NULL OR sfb38 >='",g_bdate,"')",  # 工單成會結案日
             "   AND (sfb81 IS NULL OR sfb81 <='",g_edate,"')",   # 工單xx立日期
             "   AND sfb87 = 'Y' "                                #MOD-C80036
   LET l_sql=l_sql," ORDER BY sfb01"
   DECLARE wipx_c1 CURSOR FROM l_sql
   LET l_cnt = 0
   FOREACH wipx_c1 INTO g_sfb.*
     IF SQLCA.sqlcode THEN
       CALL cl_err('wipx_c1',SQLCA.sqlcode,0)   
        EXIT FOREACH
     END IF
     LET l_cnt =l_cnt + 1
     CALL wipx_1()       # 計算每張工單的 WIP-主件 部份 成本 (cct)
     CALL wipx_2()       # 計算每張工單的 WIP-元件 投入 成本 (ccu)
     CALL wipx_3()       # 計算每張工單的 WIP-元件 轉出 成本 (ccu)
     CALL wipx_4()       # 計算每張工單的 WIP-主件 SUM  成本 (cct)
   END FOREACH
   CLOSE wipx_c1
   IF l_cnt > 0 THEN
      CALL p500_ccc_tot('2')    # 計算所有出庫成本及結存
      CALL p500_ccc_upd()       # Update ccc_file
   END IF
END FUNCTION
 
FUNCTION wipx_del()
   DEFINE wo_no         LIKE oea_file.oea01           #No.FUN-680122CHAR(16)   #FUN-660197 VARCHAR(10)->CHAR(16)
   DECLARE p110_wipx_del_c1 CURSOR FOR
       SELECT cct01 FROM cct_file
        WHERE cct04=g_ima01 AND cct02=yy AND cct03=mm
          AND cct06=type
   FOREACH p110_wipx_del_c1 INTO wo_no
     IF SQLCA.sqlcode THEN
       CALL cl_err('p110_wipx_del_c1',SQLCA.sqlcode,0)   
        EXIT FOREACH
     END IF
     DELETE FROM ccu_file WHERE ccu01=wo_no AND ccu02=yy AND ccu03=mm
                            AND ccu06=type
     DELETE FROM cct_file WHERE cct01=wo_no AND cct02=yy AND cct03=mm
                            AND cct06=type
     DELETE FROM cce_file WHERE cce01=wo_no AND cce02=yy AND cce03=mm
                            AND cce06=type
          
   END FOREACH
   CLOSE p110_wipx_del_c1
END FUNCTION
 
FUNCTION wipx_1()        # 計算每張拆件式工單的 WIP-主件 部份 成本 (cct)
   CALL p500_mcct_0()   # 將 mcct 歸 0
   LET mcct.cct01 =g_sfb.sfb01
   LET mcct.cct02 =yy
   LET mcct.cct03 =mm
   LET mcct.cct04 =g_sfb.sfb05
   LET mcct.cct06 =type        #FUN-7C0028 add
   LET mcct.cct07 =' ' 
  #LET mcct.cctplant=g_plant  #FUN-980009 add     #FUN-A50075
   LET mcct.cctlegal=g_legal  #FUN-980009 add
 
   CALL wipx_cct20()     # 工時統計
   LET mcct.cctoriu = g_user      #No.FUN-980030 10/01/04
   LET mcct.cctorig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO cct_file VALUES (mcct.*)
   IF STATUS THEN 
    CALL cl_err3("ins","cct_file",mcct.cct01,mcct.cct02,STATUS,"","ins cct.*:",1)   #No.FUN-660127
   RETURN END IF
END FUNCTION
 
FUNCTION wipx_cct20()    # 工時統計
   SELECT SUM(ccj05) INTO mcct.cct20 FROM ccj_file      # 工時統計
      WHERE ccj04=g_sfb.sfb01 AND ccj01 BETWEEN g_bdate AND g_edate
   IF mcct.cct20 IS NULL THEN LET mcct.cct20=0 END IF
END FUNCTION
 
FUNCTION wipx_2()    # 計算每張拆件式工單的 WIP-元件'期初,本期投入'成本 (ccu)
   CALL wipx_2_1()   # step 1. WIP-元件 上期期末轉本期期初
   CALL wipx_2_21()  # step 2-1. WIP-元件 本期投入材料 (依拆件式工單發料/退料檔)
   CALL wipx_2_22()  # step 2-2. WIP-元件 本期投入人工製費
   CALL wipx_2_23()  # step 2-3. WIP-元件 本期投入調整成本
END FUNCTION
 
FUNCTION wipx_2_1()      #  1. WIP-元件 上期期末轉本期期初
   DEFINE l_ccf         RECORD LIKE ccf_file.*
   DECLARE wipx_c2 CURSOR FOR SELECT * FROM ccu_file
     WHERE ccu01=g_sfb.sfb01 AND ccu02=last_yy AND ccu03=last_mm
       AND ccu06=type 
   FOREACH wipx_c2 INTO g_ccu.*
     CALL p500_ccu_0()  # 上期期末轉本期期初, 將 ccu 歸 0
    #LET g_ccu.ccuplant=g_plant  #FUN-980009 add    #FUN-A50075
     LET g_ccu.cculegal=g_legal  #FUN-980009 add
     LET g_ccu.ccuoriu = g_user      #No.FUN-980030 10/01/04
     LET g_ccu.ccuorig = g_grup      #No.FUN-980030 10/01/04
     INSERT INTO ccu_file VALUES (g_ccu.*)
     IF STATUS THEN 
      CALL cl_err3("ins","ccu_file",g_ccu.ccu01,g_ccu.ccu02,STATUS,"","ins ccu(1):",1)   #No.FUN-660127
     END IF
   END FOREACH
   CLOSE wipx_c2
 
   DECLARE wipx_c2_ccf CURSOR FOR        # WIP-元件 期初xx帳轉本期期初
    SELECT * FROM ccf_file
     WHERE ccf01=g_sfb.sfb01 AND ccf02=last_yy AND ccf03=last_mm
       AND ccf06=type  
       AND (ccf04!=' ' AND ccf04 IS NOT NULL)
   FOREACH wipx_c2_ccf INTO l_ccf.*
     IF SQLCA.sqlcode THEN
       CALL cl_err('wipx_c2_ccf',SQLCA.sqlcode,0)   
        EXIT FOREACH
     END IF
     CALL p500_ccu_01() # 將 ccu 歸 0
     LET g_ccu.ccu01 =g_sfb.sfb01
     LET g_ccu.ccu02 =yy 
     LET g_ccu.ccu03 =mm
     LET g_ccu.ccu04 =l_ccf.ccf04
     LET g_ccu.ccu05 =l_ccf.ccf05
     LET g_ccu.ccu06 =l_ccf.ccf06   #FUN-7C0028 add
     LET g_ccu.ccu07 =l_ccf.ccf07   #FUN-7C0028 add
     LET g_ccu.ccu11 =l_ccf.ccf11
     LET g_ccu.ccu12 =l_ccf.ccf12
     LET g_ccu.ccu12a=l_ccf.ccf12a
     LET g_ccu.ccu12b=l_ccf.ccf12b
     LET g_ccu.ccu12c=l_ccf.ccf12c
     LET g_ccu.ccu12d=l_ccf.ccf12d
     LET g_ccu.ccu12e=l_ccf.ccf12e
    #LET g_ccu.ccuplant=g_plant  #FUN-980009 add    #FUN-A50075
     LET g_ccu.cculegal=g_legal  #FUN-980009 add
     INSERT INTO ccu_file VALUES (g_ccu.*)
     IF SQLCA.SQLCODE AND (NOT cl_sql_dup_value(SQLCA.SQLCODE)) THEN
        CALL cl_err3("ins","ccu_file",g_ccu.ccu01,g_ccu.ccu02,STATUS,"","wipx_2_1() ins ccu:",1)   #No.FUN-660127
     END IF
     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
        UPDATE ccu_file SET ccu_file.*=g_ccu.*
         WHERE ccu01=g_sfb.sfb01 AND ccu02=yy AND ccu03=mm
           AND ccu04=l_ccf.ccf04
           AND ccu06=l_ccf.ccf06 AND ccu07=l_ccf.ccf07    #FUN-7C0028 add
        IF STATUS THEN 
         CALL cl_err3("upd","ccu_file",g_sfb.sfb01,yy,STATUS,"","upd ccu(2):",1)   #No.FUN-660127
        END IF
     END IF
   END FOREACH
   CLOSE wipx_c2_ccf
END FUNCTION
 
FUNCTION wipx_2_21()   #  2-1. WIP-元件 本期投入拆件品(依拆件式工單發料/退料檔)
   DEFINE l_ima08            LIKE ima_file.ima08   #No.FUN-680122CHAR(1)
   DEFINE l_ima57            LIKE ima_file.ima57   #No.FUN-680122SMALLINT
   DEFINE l_tlf01            LIKE tlf_file.tlf01   #No.MOD-490217
   DEFINE l_tlf02,l_tlf03    LIKE tlf_file.tlf02   #No.FUN-680122SMALLINT
   DEFINE l_tlf10            LIKE tlf_file.tlf10   #No.FUN-680122DEC(15,3)
   DEFINE l_tlfcost          LIKE tlf_file.tlfcost #No.TQC-970003
   DEFINE l_c21                                    LIKE cae_file.cae07       #No.FUN-680122DEC(15,5)
   DEFINE l_c22,l_c22a,l_c22b,l_c22c,l_c22d,l_c22e LIKE type_file.num20_6    #No.FUN-680122DEC(20,6) # No.7088.A.a #MOD-4C0005
   DEFINE l_c22f,l_c22g,l_c22h                     LIKE type_file.num20_6    #FUN-7C0028 add
   DEFINE l_c23,l_c23a,l_c23b,l_c23c,l_c23d,l_c23e LIKE type_file.num20_6    #No.FUN-680122DEC(20,6) # No.7088.A.a #MOD-4C0005
   DEFINE l_c23f,l_c23g,l_c23h                     LIKE type_file.num20_6    #FUN-7C0028 add
   DEFINE l_tlf62                                  LIKE tlf_file.tlf62
   DEFINE l_sfa161                                 LIKE sfa_file.sfa161
   DEFINE l_zero                                   LIKE type_file.num5       #No.FUN-680122SMALLINT
   DEFINE l_tlf21x,l_tlf221x,l_tlf222x                LIKE tlf_file.tlf21       #No.A102 #CHI-910041 tlf21-->tlf21x
   DEFINE l_tlf2231x,l_tlf2232x,l_tlf224x             LIKE tlf_file.tlf21       #No.A102  #CHI-910041
   DEFINE l_tlf2241x,l_tlf2242x,l_tlf2243x            LIKE tlf_file.tlf21       #FUN-7C0028 add #CHI-910041
 
   DECLARE wipx_c3 CURSOR FOR
   #SELECT tlf01,ima08,ima57,tlf02,tlf03,tlfcost,SUM(tlf10*tlf60*tlf907*-1),               #MOD-B50083 mark
    SELECT tlf01,ima08,ima57,tlf02,tlf03,tlfcost,SUM(ROUND((tlf10*tlf60*tlf907*-1),3)),    #MOD-B50083 add
           SUM(tlf21*tlf907*-1),SUM(tlf221*tlf907*-1),SUM(tlf222*tlf907*-1),
           SUM(tlf2231*tlf907*-1),SUM(tlf2232*tlf907*-1),SUM(tlf224*tlf907*-1)
          ,SUM(tlf2241*tlf907*-1),SUM(tlf2242*tlf907*-1),SUM(tlf2243*tlf907*-1)
      FROM tlf_file LEFT OUTER JOIN ima_file ON tlf01=ima_file.ima01
     WHERE tlf62=g_sfb.sfb01 AND tlf06 BETWEEN g_bdate AND g_edate
       AND ((tlf02=50 AND tlf03 BETWEEN 60 AND 69) OR
           (tlf03=50 AND tlf02 BETWEEN 60 AND 69))
       AND tlf13 NOT LIKE 'asft6%' 
       #AND tlf902 NOT IN(SELECT jce02 FROM jce_file)  #CHI-C80002
       AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = tlf902) #CHI-C80002
       AND tlf907 != 0 
     GROUP BY tlf01,ima08,ima57,tlf02,tlf03,tlfcost #TQC-970003
   FOREACH wipx_c3 INTO l_tlf01,l_ima08,l_ima57,l_tlf02,l_tlf03,l_tlfcost,l_tlf10,	 #TQC-970003 add l_tlfcost
                        l_tlf21x,l_tlf221x,l_tlf222x,l_tlf2231x,l_tlf2232x,l_tlf224x   #No.A102 #CHI-910041
                       ,l_tlf2241x,l_tlf2242x,l_tlf2243x   #FUN-7C0028 add #CHI-910041
     IF SQLCA.sqlcode THEN
       CALL cl_err('wipx_c3',SQLCA.sqlcode,0)   
        EXIT FOREACH
     END IF
     IF l_ima08 IS NULL THEN LET l_ima08='P' END IF
     IF l_tlf01=g_sfb.sfb05 THEN LET l_ima08='R' END IF #主/元料號同表重工
     IF l_ima57 = g_ima57_t THEN LET l_ima08='R' END IF #成本階相等表重工
     IF l_ima57 < g_ima57_t THEN LET l_ima08='W' END IF #成本階較低表上階重工
     LET l_c23=0
     LET l_c23a=0 LET l_c23b=0 LET l_c23c=0 LET l_c23d=0 LET l_c23e=0
     LET l_c23f=0 LET l_c23g=0 LET l_c23h=0   #FUN-7C0028 add
     LET l_c21 = 0     LET l_c22 = 0    LET l_c22a = 0    LET l_c22b = 0
     LET l_c22c = 0    LET l_c22d = 0   LET l_c22e = 0    LET l_c22f = 0
     LET l_c22g = 0    LET l_c22h = 0  
     LET l_zero = 0
     CASE                        # 取發料單價
      WHEN l_ima08 MATCHES '[W]' # (上階重工者取上月庫存月平均)
           IF g_sma.sma43 = '1' THEN
              CALL p500_upd_cxa09(l_tlf01,l_tlf10,0)
                   RETURNING l_c23,l_c23a,l_c23b,l_c23c,l_c23d,l_c23e
                                  ,l_c23f,l_c23g,l_c23h   #FUN-7C0028 add
           ELSE
              SELECT ccc23a,ccc23b,ccc23c,ccc23d,ccc23e,
                     ccc23f,ccc23g,ccc23h,ccc23   #FUN-7C0028 add ccc23f,g,h
                INTO l_c23a,l_c23b,l_c23c,l_c23d,l_c23e,
                     l_c23f,l_c23g,l_c23h,l_c23   #FUN-7C0028 add l_c23f,g,h
                FROM ccc_file
               WHERE ccc01=l_tlf01 AND ccc02=last_yy AND ccc03=last_mm
                 AND ccc07=type    AND ccc08=l_tlfcost
              CALL cl_getmsg('axc-522',g_lang) RETURNING g_msg1
              CALL cl_getmsg('axc-511',g_lang) RETURNING g_msg2
              LET g_msg=g_msg1 CLIPPED,g_sfb.sfb01,g_msg2 CLIPPED
 
              LET t_time = TIME
             #LET g_time=t_time #MOD-C30891 mark
             #FUN-A50075--mod--str--ccy_file del plant&legal
             #INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04,ccyplant,ccylegal) #No.MOD-470041 #FUN-980009 add ccyplant,ccylegal
             #              VALUES(TODAY,g_time,g_user,g_msg,g_plant,g_legal) #FUN-980009 add g_plant,g_legal
              INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04)
                           #VALUES(TODAY,g_time,g_user,g_msg) #MOD-C30891 mark
                            VALUES(TODAY,t_time,g_user,g_msg) #MOD-C30891 
             #FUN-A50075--mod--end
           END IF
      WHEN l_ima08 MATCHES '[R]' # (本階重工者取重工前庫存月平均)
           IF g_sma.sma43 = '1' THEN
              CALL p500_upd_cxa09(l_tlf01,l_tlf10,0)
                   RETURNING l_c23,l_c23a,l_c23b,l_c23c,l_c23d,l_c23e
                                  ,l_c23f,l_c23g,l_c23h   #FUN-7C0028 add
           ELSE
              SELECT ccc12a+ccc22a, ccc12b+ccc22b, ccc12c+ccc22c,
                     ccc12d+ccc22d, ccc12e+ccc22e,
                     ccc12f+ccc22f, ccc12g+ccc22g, ccc12h+ccc22h,   #FUN-7C0028 add
                     ccc12 +ccc22 , ccc11 +ccc21
                INTO l_c22a,l_c22b,l_c22c,l_c22d,l_c22e #MOD-970288  
                                ,l_c22f,l_c22g,l_c22h   #FUN-7C0028 add
                                ,l_c22,l_c21 #MOD-970288     
                FROM ccc_file
               WHERE ccc01=l_tlf01 AND ccc02=yy AND ccc03=mm
                 AND ccc07=type    AND ccc08=l_tlfcost
              IF l_c21 = 0 OR l_c21 IS NULL THEN
                 LET l_c23a=0 LET l_c23b=0 LET l_c23c=0
                 LET l_c23d=0 LET l_c23e=0 LET l_c23 =0
                 LET l_c23f=0 LET l_c23g=0 LET l_c23h=0   #FUN-7C0028 add
              ELSE 
                 LET l_c23a=l_c22a/l_c21
                 LET l_c23b=l_c22b/l_c21
                 LET l_c23c=l_c22c/l_c21
                 LET l_c23d=l_c22d/l_c21
                 LET l_c23e=l_c22e/l_c21
                 LET l_c23f=l_c22f/l_c21   #FUN-7C0028 add
                 LET l_c23g=l_c22g/l_c21   #FUN-7C0028 add
                 LET l_c23h=l_c22h/l_c21   #FUN-7C0028 add
                 LET l_c23 =l_c22 /l_c21
                 LET l_zero = 1
              END IF
              IF l_c23a = 0 AND l_c23b = 0 AND l_c23c = 0 AND l_c23d = 0 THEN
                  SELECT cca23a,cca23b,cca23c,cca23d,cca23e,
                         cca23f,cca23g,cca23h,cca23   #FUN-7C0028 add cca23f,g,h
                    INTO l_c23a,l_c23b,l_c23c,l_c23d,l_c23e,
                         l_c23f,l_c23g,l_c23h,l_c23   #FUN-7C0028 add l_c23f,g,h
                    FROM cca_file
                   WHERE cca01=l_tlf01 AND cca02=last_yy AND cca03=last_mm
                     AND cca06=type    AND cca07=l_tlfcost
                 # 98.08.16 Star 若上期仍無單價, 則取上期xx帳單價
                  IF SQLCA.sqlcode OR
                     (l_c23a=0 AND l_c23b=0 AND l_c23c=0 AND l_c23d=0
                               AND l_c23f=0 AND l_c23g=0 AND l_c23h=0) THEN   #FUN-7C0028 add
                    SELECT ccc23a,ccc23b,ccc23c,ccc23d,ccc23e,
                           ccc23f,ccc23g,ccc23h,ccc23   #FUN-7C0028 add ccc23f,g,h
                      INTO l_c23a,l_c23b,l_c23c,l_c23d,l_c23e,
                           l_c23f,l_c23g,l_c23h,l_c23   #FUN-7C0028 add l_c23f,g,h
                      FROM ccc_file
                     WHERE ccc01=l_tlf01 AND ccc02=last_yy AND ccc03=last_mm
                       AND ccc07=type    AND ccc08=l_tlfcost
                  END IF
              END IF
           END IF
      OTHERWISE                   # (取當月庫存月平均檔)
           IF g_sma.sma43 = '1' THEN
              CALL p500_upd_cxa09(l_tlf01,l_tlf10,0)
                   RETURNING l_c23,l_c23a,l_c23b,l_c23c,l_c23d,l_c23e
                                  ,l_c23f,l_c23g,l_c23h   #FUN-7C0028 add
           ELSE
              SELECT ccc23a,ccc23b,ccc23c,ccc23d,ccc23e,
                     ccc23f,ccc23g,ccc23h,ccc23   #FUN-7C0028 add ccc23f,g,h
                INTO l_c23a,l_c23b,l_c23c,l_c23d,l_c23e,
                     l_c23f,l_c23g,l_c23h,l_c23   #FUN-7C0028 add l_c23f,g,h
                FROM ccc_file
               WHERE ccc01=l_tlf01 AND ccc02=yy AND ccc03=mm
                 AND ccc07=type    AND ccc08=l_tlfcost 
           END IF
     END CASE
     CALL p500_ccu_01() # 將 ccu 歸 0
     LET g_ccu.ccu01 =g_sfb.sfb01
     LET g_ccu.ccu04 =l_tlf01
     LET g_ccu.ccu06 =type        #FUN-7C0028 add
     LET g_ccu.ccu07 =l_tlfcost 
     IF l_ima08 = 'W' THEN LET l_ima08='R' END IF
     LET g_ccu.ccu05 =l_ima08
     LET g_ccu.ccu21 =l_tlf10
      
     IF l_zero = 1 THEN
        LET g_ccu.ccu22a=l_tlf10*l_c22a/l_c21
        LET g_ccu.ccu22b=l_tlf10*l_c22b/l_c21
        LET g_ccu.ccu22c=l_tlf10*l_c22c/l_c21
        LET g_ccu.ccu22d=l_tlf10*l_c22d/l_c21
        LET g_ccu.ccu22e=l_tlf10*l_c22e/l_c21
        LET g_ccu.ccu22f=l_tlf10*l_c22f/l_c21   #FUN-7C0028 add
        LET g_ccu.ccu22g=l_tlf10*l_c22g/l_c21   #FUN-7C0028 add
        LET g_ccu.ccu22h=l_tlf10*l_c22h/l_c21   #FUN-7C0028 add   #No.MOD-9A0063 mod
     ELSE
       IF g_sma.sma43 = '1' THEN
          LET g_ccu.ccu22a=l_tlf221x  #CHI-910041
          LET g_ccu.ccu22b=l_tlf222x  #CHI-910041
          LET g_ccu.ccu22c=l_tlf2231x #CHI-910041
          LET g_ccu.ccu22d=l_tlf2232x #CHI-910041
          LET g_ccu.ccu22e=l_tlf224x  #CHI-910041
          LET g_ccu.ccu22f=l_tlf2241x   #FUN-7C0028 add #CHI-910041
          LET g_ccu.ccu22g=l_tlf2242x   #FUN-7C0028 add #CHI-910041
          LET g_ccu.ccu22h=l_tlf2243x   #FUN-7C0028 add #CHI-910041
       ELSE
          LET g_ccu.ccu22a=l_tlf10*l_c23a
          LET g_ccu.ccu22b=l_tlf10*l_c23b
          LET g_ccu.ccu22c=l_tlf10*l_c23c
          LET g_ccu.ccu22d=l_tlf10*l_c23d
          LET g_ccu.ccu22e=l_tlf10*l_c23e
          LET g_ccu.ccu22f=l_tlf10*l_c23f   #FUN-7C0028 add
          LET g_ccu.ccu22g=l_tlf10*l_c23g   #FUN-7C0028 add
          LET g_ccu.ccu22h=l_tlf10*l_c23h   #FUN-7C0028 add
       END IF
     END IF
     LET g_ccu.ccu22 =g_ccu.ccu22a+g_ccu.ccu22b+g_ccu.ccu22c+
                      g_ccu.ccu22d+g_ccu.ccu22e
                     +g_ccu.ccu22f+g_ccu.ccu22g+g_ccu.ccu22h   #FUN-7C0028 add
 
     #判斷有無結案, 若結案則歸差異成本
     IF g_sfb.sfb38 IS NOT NULL AND g_sfb.sfb38 >= g_bdate
     AND g_sfb.sfb38 <= g_edate THEN
        LET g_ccu.ccu41 = (g_ccu.ccu11 + g_ccu.ccu21 + g_ccu.ccu31)*-1
        LET g_ccu.ccu42 = (g_ccu.ccu12 + g_ccu.ccu22 + g_ccu.ccu32 )*-1
        LET g_ccu.ccu42a= (g_ccu.ccu12a+ g_ccu.ccu22a+ g_ccu.ccu32a)*-1
        LET g_ccu.ccu42b= (g_ccu.ccu12b+ g_ccu.ccu22b+ g_ccu.ccu32b)*-1
        LET g_ccu.ccu42c= (g_ccu.ccu12c+ g_ccu.ccu22c+ g_ccu.ccu32c)*-1
        LET g_ccu.ccu42d= (g_ccu.ccu12d+ g_ccu.ccu22d+ g_ccu.ccu32d)*-1
        LET g_ccu.ccu42e= (g_ccu.ccu12e+ g_ccu.ccu22e+ g_ccu.ccu32e)*-1
        LET g_ccu.ccu42f= (g_ccu.ccu12f+ g_ccu.ccu22f+ g_ccu.ccu32f)*-1   #FUN-7C0028 add
        LET g_ccu.ccu42g= (g_ccu.ccu12g+ g_ccu.ccu22g+ g_ccu.ccu32g)*-1   #FUN-7C0028 add
        LET g_ccu.ccu42h= (g_ccu.ccu12h+ g_ccu.ccu22h+ g_ccu.ccu32h)*-1   #FUN-7C0028 add
        LET g_ccu.ccu91 = 0
        LET g_ccu.ccu92a= 0
        LET g_ccu.ccu92b= 0
        LET g_ccu.ccu92c= 0
        LET g_ccu.ccu92d= 0
        LET g_ccu.ccu92e= 0
        LET g_ccu.ccu92f= 0   #FUN-7C0028 add
        LET g_ccu.ccu92g= 0   #FUN-7C0028 add
        LET g_ccu.ccu92h= 0   #FUN-7C0028 add
     ELSE
        LET g_ccu.ccu91 = g_ccu.ccu11 + g_ccu.ccu21 + g_ccu.ccu31
        LET g_ccu.ccu92 = g_ccu.ccu12 + g_ccu.ccu22 + g_ccu.ccu32
        LET g_ccu.ccu92a= g_ccu.ccu12a+ g_ccu.ccu22a+ g_ccu.ccu32a
        LET g_ccu.ccu92b= g_ccu.ccu12b+ g_ccu.ccu22b+ g_ccu.ccu32b
        LET g_ccu.ccu92c= g_ccu.ccu12c+ g_ccu.ccu22c+ g_ccu.ccu32c
        LET g_ccu.ccu92d= g_ccu.ccu12d+ g_ccu.ccu22d+ g_ccu.ccu32d
        LET g_ccu.ccu92e= g_ccu.ccu12e+ g_ccu.ccu22e+ g_ccu.ccu32e
        LET g_ccu.ccu92f= g_ccu.ccu12f+ g_ccu.ccu22f+ g_ccu.ccu32f   #FUN-7C0028 add
        LET g_ccu.ccu92g= g_ccu.ccu12g+ g_ccu.ccu22g+ g_ccu.ccu32g   #FUN-7C0028 add
        LET g_ccu.ccu92h= g_ccu.ccu12h+ g_ccu.ccu22h+ g_ccu.ccu32h   #FUN-7C0028 add   #No.TQC-9A0019 mod
        LET g_ccu.ccu41 = 0
        LET g_ccu.ccu42a= 0
        LET g_ccu.ccu42b= 0
        LET g_ccu.ccu42c= 0
        LET g_ccu.ccu42d= 0
        LET g_ccu.ccu42e= 0
        LET g_ccu.ccu42f= 0   #FUN-7C0028 add
        LET g_ccu.ccu42g= 0   #FUN-7C0028 add
        LET g_ccu.ccu42h= 0   #FUN-7C0028 add
     END IF
 
    #LET g_ccu.ccuplant=g_plant  #FUN-980009 add    #FUN-A50075
     LET g_ccu.cculegal=g_legal  #FUN-980009 add
     LET g_ccu.ccuoriu = g_user      #No.FUN-980030 10/01/04
     LET g_ccu.ccuorig = g_grup      #No.FUN-980030 10/01/04
     INSERT INTO ccu_file VALUES(g_ccu.*)
     IF SQLCA.SQLCODE AND (NOT cl_sql_dup_value(SQLCA.SQLCODE)) THEN
        CALL cl_err3("ins","ccu_file",g_ccu.ccu01,g_ccu.ccu02,STATUS,"","wipx_2_21() ins ccu:",1)   #No.FUN-660127
     END IF
     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
        UPDATE ccu_file SET ccu21=ccu21+g_ccu.ccu21,
                            ccu22=ccu22+g_ccu.ccu22,
                            ccu22a=ccu22a+g_ccu.ccu22a,
                            ccu22b=ccu22b+g_ccu.ccu22b,
                            ccu22c=ccu22c+g_ccu.ccu22c,
                            ccu22d=ccu22d+g_ccu.ccu22d,
                            ccu22e=ccu22e+g_ccu.ccu22e,
                            ccu22f=ccu22f+g_ccu.ccu22f,   #FUN-7C0028 add
                            ccu22g=ccu22g+g_ccu.ccu22g,   #FUN-7C0028 add
                            ccu22h=ccu22h+g_ccu.ccu22h    #FUN-7C0028 add
            WHERE ccu01=g_sfb.sfb01 AND ccu02=yy AND ccu03=mm
              AND ccu04=l_tlf01
              AND ccu06=type        AND ccu07=l_tlfcost 
     END IF
   END FOREACH
   CLOSE wipx_c3
END FUNCTION
 
FUNCTION wipx_2_22()     #  2-2. WIP-元件 本期投入人工製費
   DEFINE l_dept    LIKE cre_file.cre08      #No.FUN-680122 VARCHAR(10)
   DEFINE l_ccj05   LIKE ccj_file.ccj05      #FUN-7C0028 add
   DEFINE l_cdc05_1 LIKE cdc_file.cdc05      #FUN-7C0028 add
   DEFINE l_cdc05_2 LIKE cdc_file.cdc05      #FUN-7C0028 add
   DEFINE l_cdc05_3 LIKE cdc_file.cdc05      #FUN-7C0028 add
   DEFINE l_cdc05_4 LIKE cdc_file.cdc05      #FUN-7C0028 add
   DEFINE l_cdc05_5 LIKE cdc_file.cdc05      #FUN-7C0028 add
   DEFINE l_cdc05_6 LIKE cdc_file.cdc05      #FUN-7C0028 add
 
   CALL p500_ccu_01()   # 將 ccu 歸 0
   LET g_ccu.ccu01 =g_sfb.sfb01
   LET g_ccu.ccu04 =' DL+OH+SUB'        # 料號為 ' DL+OH+SUB'
   LET g_ccu.ccu05 ='P'
   LET g_ccu.ccu06 =type        #FUN-7C0028 add
   LET g_ccu.ccu07 =g_tlfcost   #FUN-7C0028 add
  #MOD-C50084 -- mark start --
  #LET g_ccu.ccu21 =mcct.cct20
  # IF g_ccz.ccz06 = '1' THEN
  #    LET l_dept = ' '
  # ELSE 
  #    LET l_dept = g_sfb.sfb98
  # END IF
  ##人工、製費一、製費二、製費三、製費四、製費五金額改抓cdc_file
  # LET l_cdc05_1=0  LET l_cdc05_2=0  LET l_cdc05_3=0
  # LET l_cdc05_4=0  LET l_cdc05_5=0  LET l_cdc05_6=0
 
  # CALL wip_2_22_cdc(yy,mm,l_dept,g_sfb.sfb01) 
  #      RETURNING l_cdc05_1,l_cdc05_2,l_cdc05_3,
  #                l_cdc05_4,l_cdc05_5,l_cdc05_6
 
  # #工單投入工時
  # SELECT SUM(ccj05) INTO l_ccj05 FROM cci_file,ccj_file
  #  WHERE cci01 = ccj01
  #    AND cci02 = ccj02
  #    AND cci01 BETWEEN g_bdate AND g_edate
  #    ANd cci02 = l_dept
  #    AND ccj04 = g_sfb.sfb01
  #    AND ccifirm = 'Y'         #MOD-B30728 add
 
  ##---------------No:MOD-A10036 modify
  ##IF l_ccj05 > 0 THEN
  #   #LET g_ccu.ccu22b=mcct.cct20*l_cdc05_1/l_ccj05       # 人工成本
  #   #LET g_ccu.ccu22c=mcct.cct20*l_cdc05_2/l_ccj05       # 製費一成本
  #   #LET g_ccu.ccu22e=mcct.cct20*l_cdc05_3/l_ccj05       # 製費二成本
  #   #LET g_ccu.ccu22f=mcct.cct20*l_cdc05_4/l_ccj05       # 製費三成本
  #   #LET g_ccu.ccu22g=mcct.cct20*l_cdc05_5/l_ccj05       # 製費四成本
  #   #LET g_ccu.ccu22h=mcct.cct20*l_cdc05_6/l_ccj05       # 製費五成本
  #    LET g_ccu.ccu22b=l_cdc05_1    # 人工成本
  #    LET g_ccu.ccu22c=l_cdc05_2    # 製費一成本
  #    LET g_ccu.ccu22e=l_cdc05_3    # 製費二成本
  #    LET g_ccu.ccu22f=l_cdc05_4    # 製費三成本
  #    LET g_ccu.ccu22g=l_cdc05_5    # 製費四成本
  #    LET g_ccu.ccu22h=l_cdc05_6    # 製費五成本
  ##END IF
  ##---------------No:MOD-A10036 end
  #MOD-C50084 -- mark end --

  #MOD-C50084 -- start --
   #人工、製費一、製費二、製費三、製費四、製費五金額改抓cdc_file
    LET l_cdc05_1=0  LET l_cdc05_2=0  LET l_cdc05_3=0
    LET l_cdc05_4=0  LET l_cdc05_5=0  LET l_cdc05_6=0

    CALL wip_2_22_cdc(yy,mm,g_sfb.sfb01)
         RETURNING l_cdc05_1,l_cdc05_2,l_cdc05_3,
                   l_cdc05_4,l_cdc05_5,l_cdc05_6
    LET g_ccu.ccu22b=l_cdc05_1    # 人工成本
    LET g_ccu.ccu22c=l_cdc05_2    # 製費一成本
    LET g_ccu.ccu22e=l_cdc05_3    # 製費二成本
    LET g_ccu.ccu22f=l_cdc05_4    # 製費三成本
    LET g_ccu.ccu22g=l_cdc05_5    # 製費四成本
    LET g_ccu.ccu22h=l_cdc05_6    # 製費五成本
  #MOD-C50084 -- end --

   LET g_ccu.ccu22 =g_ccu.ccu22b+g_ccu.ccu22c+g_ccu.ccu22d
                   +g_ccu.ccu22e+g_ccu.ccu22f+g_ccu.ccu22g+g_ccu.ccu22h   #FUN-7C0028 add
   IF g_ccu.ccu22 = 0 THEN LET g_ccu.ccu21 = 0 RETURN END IF 
   LET g_ccu.ccudate = g_today
  #LET g_ccu.ccuplant=g_plant  #FUN-980009 add     #FUN-A50075
   LET g_ccu.cculegal=g_legal  #FUN-980009 add
   LET g_ccu.ccuoriu = g_user      #No.FUN-980030 10/01/04
   LET g_ccu.ccuorig = g_grup      #No.FUN-980030 10/01/04
   LET g_ccu.ccu21 = mcct.cct20     #add by kuangxj150319
   INSERT INTO ccu_file VALUES(g_ccu.*)
   IF STATUS THEN                     # 可能有上期轉入資料造成重複
      UPDATE ccu_file SET ccu21=ccu21+g_ccu.ccu21,
                          ccu22=ccu22+g_ccu.ccu22,
                          ccu22b=ccu22b+g_ccu.ccu22b,
                          ccu22c=ccu22c+g_ccu.ccu22c,
                          ccu22d=ccu22d+g_ccu.ccu22d
                         ,ccu22e=ccu22e+g_ccu.ccu22e,   #FUN-7C0028 add
                          ccu22f=ccu22f+g_ccu.ccu22f,   #FUN-7C0028 add
                          ccu22g=ccu22g+g_ccu.ccu22g,   #FUN-7C0028 add
                          ccu22h=ccu22h+g_ccu.ccu22h    #FUN-7C0028 add
       WHERE ccu01=g_ccu.ccu01 AND ccu02=yy AND ccu03=mm
         AND ccu04=g_ccu.ccu04
         AND ccu06=type        AND ccu07=g_tlfcost   #FUN-7C0028 add
   END IF
END FUNCTION
 
FUNCTION wipx_2_23()     #  2-3. WIP-元件 本期投入調整成本
   CALL p500_ccu_01()   # 將 ccu 歸 0
   LET g_ccu.ccu01 =g_sfb.sfb01
   LET g_ccu.ccu04 =' ADJUST'   # 料號為 ' ADJUST'
   LET g_ccu.ccu05 ='P'
   LET g_ccu.ccu06 =type        #FUN-7C0028 add
   LET g_ccu.ccu07 =g_tlfcost   #FUN-7C0028 add
   #---------------------------- (970109 roger) 使調整成本歸入半成品
   LET g_chr=''
   SELECT MAX(ccl05) INTO g_chr FROM ccl_file
    WHERE ccl01=g_sfb.sfb01 AND ccl02=yy AND ccl03=mm AND ccl05='M'
      AND ccl06=type        AND ccl07=g_tlfcost   #FUN-7C0028 add
   IF g_chr='M' THEN LET g_ccu.ccu05 ='M' END IF
   #--------------------------------------------------------------------------
   LET g_ccu.ccu21 =mcct.cct21
   SELECT SUM(ccl21),
          SUM(ccl22a), SUM(ccl22b), SUM(ccl22c), SUM(ccl22d), SUM(ccl22e)
         ,SUM(ccl22f), SUM(ccl22g), SUM(ccl22h)    #FUN-7C0028 add
     INTO g_ccu.ccu21,
          g_ccu.ccu22a,g_ccu.ccu22b,g_ccu.ccu22c,g_ccu.ccu22d,g_ccu.ccu22e
         ,g_ccu.ccu22f,g_ccu.ccu22g,g_ccu.ccu22h   #FUN-7C0028 add
     FROM ccl_file
    WHERE ccl01=g_sfb.sfb01 AND ccl02=yy AND ccl03=mm
      AND ccl06=type        AND ccl07=g_tlfcost   #FUN-7C0028 add
   IF g_ccu.ccu21  IS NULL THEN LET g_ccu.ccu21 = 0 END IF
   IF g_ccu.ccu22a IS NULL THEN
      LET g_ccu.ccu22a = 0 LET g_ccu.ccu22b = 0 LET g_ccu.ccu22c = 0
      LET g_ccu.ccu22d = 0 LET g_ccu.ccu22e = 0
      LET g_ccu.ccu22f = 0 LET g_ccu.ccu22g = 0 LET g_ccu.ccu22h = 0   #FUN-7C0028 add
   END IF
   LET g_ccu.ccu22 =g_ccu.ccu22a+g_ccu.ccu22b+g_ccu.ccu22c
                                +g_ccu.ccu22d+g_ccu.ccu22e
                                +g_ccu.ccu22f+g_ccu.ccu22g+g_ccu.ccu22h   #FUN-7C0028 add
   IF g_ccu.ccu22 = 0 THEN LET g_ccu.ccu21 = 0 RETURN END IF
    #MOD-4B0205
   LET g_ccu.ccu91  = g_ccu.ccu21
   LET g_ccu.ccu92a = g_ccu.ccu22a
   LET g_ccu.ccu92b = g_ccu.ccu22b
   LET g_ccu.ccu92c = g_ccu.ccu22c
   LET g_ccu.ccu92d = g_ccu.ccu22d
   LET g_ccu.ccu92e = g_ccu.ccu22e
   LET g_ccu.ccu92f = g_ccu.ccu22f   #FUN-7C0028 add
   LET g_ccu.ccu92g = g_ccu.ccu22g   #FUN-7C0028 add
   LET g_ccu.ccu92h = g_ccu.ccu22h   #FUN-7C0028 add
   LET g_ccu.ccu92  = g_ccu.ccu22
   #--
 
  #LET g_ccu.ccuplant=g_plant  #FUN-980009 add    #FUN-A50075
   LET g_ccu.cculegal=g_legal  #FUN-980009 add
   LET g_ccu.ccuoriu = g_user      #No.FUN-980030 10/01/04
   LET g_ccu.ccuorig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO ccu_file VALUES(g_ccu.*)
   IF STATUS THEN                     # 可能有上期轉入資料造成重複
      UPDATE ccu_file SET ccu21=ccu21+g_ccu.ccu21,
                          ccu22=ccu22+g_ccu.ccu22,
                          ccu22a=ccu22a+g_ccu.ccu22a,
                          ccu22b=ccu22b+g_ccu.ccu22b,
                          ccu22c=ccu22c+g_ccu.ccu22c,
                          ccu22d=ccu22d+g_ccu.ccu22d,
                          ccu22e=ccu22e+g_ccu.ccu22e,
                          ccu22f=ccu22f+g_ccu.ccu22f,   #FUN-7C0028 add
                          ccu22g=ccu22g+g_ccu.ccu22g,   #FUN-7C0028 add
                          ccu22h=ccu22h+g_ccu.ccu22h,   #FUN-7C0028 add
                          ccu91a=ccu92a+g_ccu.ccu92a,   #MOD-4B0205
                          ccu92b=ccu92b+g_ccu.ccu92b,   #MOD-4B0205
                          ccu92c=ccu92c+g_ccu.ccu92c,   #MOD-4B0205
                          ccu92d=ccu92d+g_ccu.ccu92d,   #MOD-4B0205
                          ccu92e=ccu92e+g_ccu.ccu92e,   #MOD-4B0205
                          ccu92f=ccu92f+g_ccu.ccu92f,   #FUN-7C0028 add
                          ccu92g=ccu92g+g_ccu.ccu92g,   #FUN-7C0028 add
                          ccu92h=ccu92h+g_ccu.ccu92g,   #FUN-7C0028 add
                          ccu92 =ccu92 +g_ccu.ccu92     #MOD-4B0205
       WHERE ccu01=g_ccu.ccu01 AND ccu02=yy AND ccu03=mm
         AND ccu04=g_ccu.ccu04
         AND ccu06=type        AND ccu07=g_tlfcost   #FUN-7C0028 add
   END IF
END FUNCTION
 
#------------------------------------------------------------------------
# 以下計算 WIP(拆件式)-元件 本期拆出成本
#------------------------------------------------------------------------
FUNCTION wipx_3()        # step 3. WIP-元件 本期轉出成本
   DEFINE l_ima08           LIKE ima_file.ima08     #No.FUN-680122CHAR(1)
   DEFINE l_ima57           LIKE ima_file.ima57     #No.FUN-680122SMALLINT
   DEFINE l_tlf01           LIKE tlf_file.tlf01     #No.MOD-490217
   DEFINE l_tlf02,l_tlf03   LIKE type_file.num5     #No.FUN-680122SMALLINT
   DEFINE l_tlf10           LIKE tlf_file.tlf10     #No.FUN-680122DEC(15,3)
   DEFINE l_c21             LIKE cae_file.cae07     #No.FUN-680122DEC(15,5)
   DEFINE l_tlfcost         LIKE tlf_file.tlfcost   #No.TQC-970003
   DEFINE l_c22,l_c22a,l_c22b,l_c22c,l_c22d,l_c22e  LIKE type_file.num20_6   #No.FUN-680122DEC(20,6)  #MOD-4C0005
   DEFINE l_c22f,l_c22g,l_c22h                      LIKE type_file.num20_6   #FUN-7C0028 add
   DEFINE l_c23,l_c23a,l_c23b,l_c23c,l_c23d,l_c23e  LIKE type_file.num20_6   #No.FUN-680122DEC(20,6)  #MOD-4C0005
   DEFINE l_c23f,l_c23g,l_c23h                      LIKE type_file.num20_6   #FUN-7C0028 add
   DEFINE l_tlf62                                   LIKE tlf_file.tlf62
   DEFINE l_sfa161                                  LIKE sfa_file.sfa161
 
   DECLARE wipx_c3x CURSOR FOR     #
    #SELECT tlf01,ima08,ima57,tlf02,tlf03,tlfcost,SUM(tlf10*tlf60*tlf907*-1)                #MOD-B50083 mark
     SELECT tlf01,ima08,ima57,tlf02,tlf03,tlfcost,SUM(ROUND((tlf10*tlf60*tlf907*-1),3))     #MOD-B50083 add
      FROM tlf_file LEFT OUTER JOIN ima_file ON tlf01=ima_file.ima01
     WHERE tlf62=g_sfb.sfb01 AND tlf06 BETWEEN g_bdate AND g_edate
       AND ((tlf02=50 AND tlf03 BETWEEN 60 AND 69) OR
           (tlf03=50 AND tlf02 BETWEEN 60 AND 69))
       AND tlf13 LIKE 'asft6%'
       #AND tlf902 NOT IN(SELECT jce02 FROM jce_file)  #CHI-C80002
       AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = tlf902)  #CHI-C80002
       AND tlf907 != 0 
     GROUP BY tlf01,ima08,ima57,tlf02,tlf03,tlfcost   #TQC-970003
   FOREACH wipx_c3x INTO l_tlf01,l_ima08,l_ima57,l_tlf02,l_tlf03,l_tlfcost,l_tlf10	#TQC-970003
     IF SQLCA.sqlcode THEN
       CALL cl_err('wipx_c3x',SQLCA.sqlcode,0)   
        EXIT FOREACH
     END IF
     IF l_ima57 = 99 OR l_ima57 = 98
     THEN LET l_ima08 = 'P' ELSE LET l_ima08 = 'M'
     END IF
     LET l_c23=0
     LET l_c23a=0 LET l_c23b=0 LET l_c23c=0 LET l_c23d=0 LET l_c23e=0
     LET l_c23f=0 LET l_c23g=0 LET l_c23h=0  #No.MOD-990062 
 
     IF g_sma.sma43 = '1' THEN
        IF l_ima08 = 'P' THEN            #(取最近採購入庫成本)
           CALL p500_get_tlf21(l_tlf01,l_tlf10,'3',0)
                RETURNING l_c23,l_c23a,l_c23b,l_c23c,l_c23d,l_c23e
                               ,l_c23f,l_c23g,l_c23h   #FUN-7C0028 add
        ELSE                             #(取最近工單入庫成本)
           CALL p500_get_tlf21(l_tlf01,l_tlf10,'4',0)
                RETURNING l_c23,l_c23a,l_c23b,l_c23c,l_c23d,l_c23e
                               ,l_c23f,l_c23g,l_c23h   #FUN-7C0028 add
        END IF
     ELSE
        # (取當月庫存月平均檔) 拆出元件取本月算出加權平均單價
        SELECT  ccc23a,ccc23b,ccc23c,ccc23d,ccc23e,
                ccc23f,ccc23g,ccc23h,ccc23   #FUN-7C0028 add ccc23f,g,h
          INTO l_c23a,l_c23b,l_c23c,l_c23d,l_c23e,
               l_c23f,l_c23g,l_c23h,l_c23    #FUN-7C0028 add l_c23f,g,h
          FROM ccc_file
         WHERE ccc01=l_tlf01 AND ccc02=yy AND ccc03=mm
           AND ccc07=type    AND ccc08=l_tlfcost
        IF SQLCA.SQLCODE!=0 THEN
           SELECT  ccc23a,ccc23b,ccc23c,ccc23d,ccc23e,
                   ccc23f,ccc23g,ccc23h,ccc23   #FUN-7C0028 add ccc23f,g,h
             INTO l_c23a,l_c23b,l_c23c,l_c23d,l_c23e,
                  l_c23f,l_c23g,l_c23h,l_c23    #FUN-7C0028 add l_c23f,g,h
             FROM ccc_file
            WHERE ccc01=l_tlf01 AND ccc02=last_yy AND ccc03=last_mm
              AND ccc07=type    AND ccc08=l_tlfcost
           IF cl_null(l_c23a) THEN LET l_c23a=0 END IF
           IF cl_null(l_c23b) THEN LET l_c23b=0 END IF
           IF cl_null(l_c23c) THEN LET l_c23c=0 END IF
           IF cl_null(l_c23d) THEN LET l_c23d=0 END IF
           IF cl_null(l_c23e) THEN LET l_c23e=0 END IF
           IF cl_null(l_c23f) THEN LET l_c23f=0 END IF
           IF cl_null(l_c23g) THEN LET l_c23g=0 END IF
           IF cl_null(l_c23h) THEN LET l_c23h=0 END IF
           IF cl_null(l_c23)  THEN LET l_c23 =0 END IF
           CALL cl_getmsg('axc-522',g_lang) RETURNING g_msg1
           CALL cl_getmsg('axc-511',g_lang) RETURNING g_msg2
           LET g_msg=g_msg1 CLIPPED,g_sfb.sfb01,g_msg2 CLIPPED,
                     "(",l_tlf01 CLIPPED,")"
 
           LET t_time = TIME
          #LET g_time=t_time #MOD-C30891 mark
          #FUN-A50075--mod--str-- ccy_file del plant&legal
          #INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04,ccyplant,ccylegal) #No.MOD-470041 #FUN-980009 add ccyplant,ccylegal
          #              VALUES(TODAY,g_time,g_user,g_msg,g_plant,g_legal) #FUN-980009 add g_plant,g_legal
           INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04)
                        #VALUES(TODAY,g_time,g_user,g_msg) #MOD-C30891 mark
                         VALUES(TODAY,t_time,g_user,g_msg) #MOD-C30891 
          #FUN-A50075--mod--end
        END IF
     END IF
     CALL p500_ccu_01() # 將 ccu 歸 0
     LET g_ccu.ccu01 =g_sfb.sfb01
     LET g_ccu.ccu04 =l_tlf01
 
     LET g_ccu.ccu05 =l_ima08
     LET g_ccu.ccu06 =type        #FUN-7C0028 add
     LET g_ccu.ccu07 =l_tlfcost   #FUN-7C0028 add
     LET g_ccu.ccu31 =l_tlf10
     LET g_ccu.ccu32a=l_tlf10*l_c23a
     LET g_ccu.ccu32b=l_tlf10*l_c23b
     LET g_ccu.ccu32c=l_tlf10*l_c23c
     LET g_ccu.ccu32d=l_tlf10*l_c23d
     LET g_ccu.ccu32e=l_tlf10*l_c23e
     LET g_ccu.ccu32f=l_tlf10*l_c23f   #FUN-7C0028 add
     LET g_ccu.ccu32g=l_tlf10*l_c23g   #FUN-7C0028 add
     LET g_ccu.ccu32h=l_tlf10*l_c23h   #FUN-7C0028 add
     LET g_ccu.ccu32 =g_ccu.ccu32a+g_ccu.ccu32b+g_ccu.ccu32c+
                      g_ccu.ccu32d+g_ccu.ccu32e
                     +g_ccu.ccu32f+g_ccu.ccu32g+g_ccu.ccu32h   #FUN-7C0028 add
    #LET g_ccu.ccuplant=g_plant  #FUN-980009 add    #FUN-A50075
     LET g_ccu.cculegal=g_legal  #FUN-980009 add
     LET g_ccu.ccuoriu = g_user      #No.FUN-980030 10/01/04
     LET g_ccu.ccuorig = g_grup      #No.FUN-980030 10/01/04
     INSERT INTO ccu_file VALUES(g_ccu.*)
     IF SQLCA.SQLCODE AND (NOT cl_sql_dup_value(SQLCA.SQLCODE)) THEN
        CALL cl_err3("ins","ccu_file",g_ccu.ccu01,g_ccu.ccu02,STATUS,"","wipx_2_21() ins ccu:",1)   #No.FUN-660127
     END IF
     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
        UPDATE ccu_file SET ccu31=ccu31+g_ccu.ccu31,
                            ccu32=ccu32+g_ccu.ccu32,
                            ccu32a=ccu32a+g_ccu.ccu32a,
                            ccu32b=ccu32b+g_ccu.ccu32b,
                            ccu32c=ccu32c+g_ccu.ccu32c,
                            ccu32d=ccu32d+g_ccu.ccu32d,
                            ccu32e=ccu32e+g_ccu.ccu32e,
                            ccu32f=ccu32f+g_ccu.ccu32f,   #FUN-7C0028 add
                            ccu32g=ccu32g+g_ccu.ccu32g,   #FUN-7C0028 add
                            ccu32h=ccu32h+g_ccu.ccu32h    #FUN-7C0028 add
            WHERE ccu01=g_sfb.sfb01 AND ccu02=yy AND ccu03=mm
              AND ccu04=l_tlf01
              AND ccu06=type        AND ccu07=l_tlfcost
     END IF
   END FOREACH
   CLOSE wipx_c3x
   CALL wipx_2_24()   #整理該歸期未或差異
END FUNCTION
 
FUNCTION wipx_2_24()   #整理該歸期未或差異
 
   DECLARE wipx_c2_24 CURSOR FOR
    SELECT ccu_file.* FROM ccu_file
     WHERE ccu01=g_sfb.sfb01 AND ccu02 = yy AND ccu03 = mm
       AND ccu06=type 
   FOREACH wipx_c2_24 INTO mccu.*
     IF SQLCA.sqlcode THEN
       CALL cl_err('wipx_c2_24',SQLCA.sqlcode,0)   
        EXIT FOREACH
     END IF
     #判斷有無結案, 若結案則歸差異成本
     IF g_sfb.sfb38 IS NOT NULL AND g_sfb.sfb38 >= g_bdate
     AND g_sfb.sfb38 <= g_edate THEN
        LET mccu.ccu41 = (mccu.ccu11 + mccu.ccu21 + mccu.ccu31 )*-1
        LET mccu.ccu42 = (mccu.ccu12 + mccu.ccu22 + mccu.ccu32 )*-1
        LET mccu.ccu42a= (mccu.ccu12a+ mccu.ccu22a+ mccu.ccu32a)*-1
        LET mccu.ccu42b= (mccu.ccu12b+ mccu.ccu22b+ mccu.ccu32b)*-1
        LET mccu.ccu42c= (mccu.ccu12c+ mccu.ccu22c+ mccu.ccu32c)*-1
        LET mccu.ccu42d= (mccu.ccu12d+ mccu.ccu22d+ mccu.ccu32d)*-1
        LET mccu.ccu42e= (mccu.ccu12e+ mccu.ccu22e+ mccu.ccu32e)*-1
        LET mccu.ccu42f= (mccu.ccu12f+ mccu.ccu22f+ mccu.ccu32f)*-1   #FUN-7C0028 add
        LET mccu.ccu42g= (mccu.ccu12g+ mccu.ccu22g+ mccu.ccu32g)*-1   #FUN-7C0028 add
        LET mccu.ccu42h= (mccu.ccu12h+ mccu.ccu22h+ mccu.ccu32h)*-1   #FUN-7C0028 add
        LET mccu.ccu91 = 0
        LET mccu.ccu92 = 0
        LET mccu.ccu92a= 0
        LET mccu.ccu92b= 0
        LET mccu.ccu92c= 0
        LET mccu.ccu92d= 0
        LET mccu.ccu92e= 0
        LET mccu.ccu92f= 0   #FUN-7C0028 add
        LET mccu.ccu92g= 0   #FUN-7C0028 add
        LET mccu.ccu92h= 0   #FUN-7C0028 add
     ELSE
        LET mccu.ccu91 = mccu.ccu11 + mccu.ccu21 + mccu.ccu31
        LET mccu.ccu92 = mccu.ccu12 + mccu.ccu22 + mccu.ccu32
        LET mccu.ccu92a= mccu.ccu12a+ mccu.ccu22a+ mccu.ccu32a
        LET mccu.ccu92b= mccu.ccu12b+ mccu.ccu22b+ mccu.ccu32b
        LET mccu.ccu92c= mccu.ccu12c+ mccu.ccu22c+ mccu.ccu32c
        LET mccu.ccu92d= mccu.ccu12d+ mccu.ccu22d+ mccu.ccu32d
        LET mccu.ccu92e= mccu.ccu12e+ mccu.ccu22e+ mccu.ccu32e
        LET mccu.ccu92f= mccu.ccu12f+ mccu.ccu22f+ mccu.ccu32f   #FUN-7C0028 add
        LET mccu.ccu92g= mccu.ccu12g+ mccu.ccu22g+ mccu.ccu32g   #FUN-7C0028 add
        LET mccu.ccu92h= mccu.ccu12h+ mccu.ccu22h+ mccu.ccu32h   #FUN-7C0028 add
        LET mccu.ccu41 = 0
        LET mccu.ccu42 = 0
        LET mccu.ccu42a= 0
        LET mccu.ccu42b= 0
        LET mccu.ccu42c= 0
        LET mccu.ccu42d= 0
        LET mccu.ccu42e= 0
        LET mccu.ccu42f= 0   #FUN-7C0028 add
        LET mccu.ccu42g= 0   #FUN-7C0028 add
        LET mccu.ccu42h= 0   #FUN-7C0028 add
     END IF
 
     UPDATE ccu_file SET ccu41 = mccu.ccu41,
                         ccu42 = mccu.ccu42 ,
                         ccu42a= mccu.ccu42a,
                         ccu42b= mccu.ccu42b,
                         ccu42c= mccu.ccu42c,
                         ccu42d= mccu.ccu42d,
                         ccu42e= mccu.ccu42e,
                         ccu42f= mccu.ccu42f,   #FUN-7C0028 add
                         ccu42g= mccu.ccu42g,   #FUN-7C0028 add
                         ccu42h= mccu.ccu42h,   #FUN-7C0028 add
                         ccu91 = mccu.ccu91,
                         ccu92 = mccu.ccu92 ,
                         ccu92a= mccu.ccu92a,
                         ccu92b= mccu.ccu92b,
                         ccu92c= mccu.ccu92c,
                         ccu92d= mccu.ccu92d,
                         ccu92e= mccu.ccu92e,
                         ccu92f= mccu.ccu92f,   #FUN-7C0028 add
                         ccu92g= mccu.ccu92g,   #FUN-7C0028 add
                         ccu92h= mccu.ccu92h    #FUN-7C0028 add
      WHERE ccu01 = g_sfb.sfb01 AND ccu02 = yy AND ccu03 = mm
        AND ccu04 = mccu.ccu04
        AND ccu06 = type        AND ccu07 = mccu.ccu07
   END FOREACH
   CLOSE wipx_c2_24
END FUNCTION
 
FUNCTION wipx_4()        # 計算每張拆件式工單的 WIP-主件 成本 (cct)
 SELECT SUM(ccu12),SUM(ccu12a),SUM(ccu12b),SUM(ccu12c),SUM(ccu12d),SUM(ccu12e),
                   SUM(ccu12f),SUM(ccu12g),SUM(ccu12h),   #FUN-7C0028 add
        SUM(ccu22),SUM(ccu22a),SUM(ccu22b),SUM(ccu22c),SUM(ccu22d),SUM(ccu22e),
                   SUM(ccu22f),SUM(ccu22g),SUM(ccu22h),   #FUN-7C0028 add
        SUM(ccu32),SUM(ccu32a),SUM(ccu32b),SUM(ccu32c),SUM(ccu32d),SUM(ccu32e),
                   SUM(ccu32f),SUM(ccu32g),SUM(ccu32h),   #FUN-7C0028 add
        SUM(ccu42),SUM(ccu42a),SUM(ccu42b),SUM(ccu42c),SUM(ccu42d),SUM(ccu42e),
                   SUM(ccu42f),SUM(ccu42g),SUM(ccu42h),   #FUN-7C0028 add
        SUM(ccu92),SUM(ccu92a),SUM(ccu92b),SUM(ccu92c),SUM(ccu92d),SUM(ccu92e)
                  ,SUM(ccu92f),SUM(ccu92g),SUM(ccu92h)    #FUN-7C0028 add
   INTO mcct.cct12,mcct.cct12a,mcct.cct12b,mcct.cct12c,mcct.cct12d,mcct.cct12e,
                   mcct.cct12f,mcct.cct12g,mcct.cct12h,   #FUN-7C0028 add
        mcct.cct22,mcct.cct22a,mcct.cct22b,mcct.cct22c,mcct.cct22d,mcct.cct22e,
                   mcct.cct22f,mcct.cct22g,mcct.cct22h,   #FUN-7C0028 add
        mcct.cct32,mcct.cct32a,mcct.cct32b,mcct.cct32c,mcct.cct32d,mcct.cct32e,
                   mcct.cct32f,mcct.cct32g,mcct.cct32h,   #FUN-7C0028 add
        mcct.cct42,mcct.cct42a,mcct.cct42b,mcct.cct42c,mcct.cct42d,mcct.cct42e,
                   mcct.cct42f,mcct.cct42g,mcct.cct42h,   #FUN-7C0028 add
        mcct.cct92,mcct.cct92a,mcct.cct92b,mcct.cct92c,mcct.cct92d,mcct.cct92e
                  ,mcct.cct92f,mcct.cct92g,mcct.cct92h    #FUN-7C0028 add
   FROM ccu_file
  WHERE ccu01=g_sfb.sfb01 AND ccu02=yy AND ccu03=mm
    AND ccu06=type
 IF mcct.cct12 IS NULL THEN
    LET mcct.cct12 = 0 LET mcct.cct12a= 0 LET mcct.cct12b= 0
    LET mcct.cct12c= 0 LET mcct.cct12d= 0 LET mcct.cct12e= 0
    LET mcct.cct12f= 0 LET mcct.cct12g= 0 LET mcct.cct12h= 0   #FUN-7C0028 add
    LET mcct.cct22 = 0 LET mcct.cct22a= 0 LET mcct.cct22b= 0
    LET mcct.cct22c= 0 LET mcct.cct22d= 0 LET mcct.cct22e= 0
    LET mcct.cct22f= 0 LET mcct.cct22g= 0 LET mcct.cct22h= 0   #FUN-7C0028 add
    LET mcct.cct32 = 0 LET mcct.cct32a= 0 LET mcct.cct32b= 0
    LET mcct.cct32c= 0 LET mcct.cct32d= 0 LET mcct.cct32e= 0
    LET mcct.cct32f= 0 LET mcct.cct32g= 0 LET mcct.cct32h= 0   #FUN-7C0028 add
    LET mcct.cct42 = 0 LET mcct.cct42a= 0 LET mcct.cct42b= 0
    LET mcct.cct42c= 0 LET mcct.cct42d= 0 LET mcct.cct42e= 0
    LET mcct.cct42f= 0 LET mcct.cct42g= 0 LET mcct.cct42h= 0   #FUN-7C0028 add
    LET mcct.cct92 = 0 LET mcct.cct92a= 0 LET mcct.cct92b= 0
    LET mcct.cct92c= 0 LET mcct.cct92d= 0 LET mcct.cct92e= 0
    LET mcct.cct92f= 0 LET mcct.cct92g= 0 LET mcct.cct92h= 0   #FUN-7C0028 add
 END IF
 LET t_time = TIME
 LET mcct.cctuser=g_user LET mcct.cctdate=TODAY LET mcct.ccttime=t_time
 UPDATE cct_file SET cct_file.* = mcct.*
  WHERE cct01=mcct.cct01 AND cct02=mcct.cct02 AND cct03=mcct.cct03
    AND cct06=type  
 IF STATUS THEN 
  CALL cl_err3("upd","cct_file",mcct.cct01,mcct.cct02,STATUS,"","upd cct.*:",1)   #No.FUN-660127
 RETURN END IF
    SELECT COUNT(*) INTO g_cnt FROM ccu_file
     WHERE ccu01=mcct.cct01 AND ccu02=yy AND ccu03=mm
       AND ccu06=type
    IF g_cnt=0 AND
       mcct.cct11 =0 AND mcct.cct12 =0 AND mcct.cct12a=0 AND
       mcct.cct12b=0 AND mcct.cct12c=0 AND mcct.cct12d=0 AND
       mcct.cct12e=0 AND mcct.cct12f=0 AND mcct.cct12g=0 AND mcct.cct12h=0 AND   #FUN-7C0028 add
       mcct.cct20 =0 AND
       mcct.cct21 =0 AND mcct.cct22 =0 AND mcct.cct22a=0 AND
       mcct.cct22b=0 AND mcct.cct22c=0 AND mcct.cct22d=0 AND
       mcct.cct22e=0 AND mcct.cct22f=0 AND mcct.cct22g=0 AND mcct.cct22h=0 AND   #FUN-7C0028 add
       mcct.cct23 =0 AND mcct.cct23a=0 AND mcct.cct23b=0 AND
       mcct.cct23c=0 AND mcct.cct23d=0 AND
       mcct.cct23e=0 AND mcct.cct23f=0 AND mcct.cct23g=0 AND mcct.cct23h=0 AND   #FUN-7C0028 add
       mcct.cct31 =0 AND mcct.cct32 =0 AND mcct.cct32a=0 AND
       mcct.cct32b=0 AND mcct.cct32c=0 AND mcct.cct32d=0 AND
       mcct.cct32e=0 AND mcct.cct32f=0 AND mcct.cct32g=0 AND mcct.cct32h=0 AND   #FUN-7C0028 add
       mcct.cct41 =0 AND mcct.cct42 =0 AND mcct.cct42a=0 AND
       mcct.cct42b=0 AND mcct.cct42c=0 AND mcct.cct42d=0 AND
       mcct.cct42e=0 AND mcct.cct42f=0 AND mcct.cct42g=0 AND mcct.cct42h=0 AND   #FUN-7C0028 add
       mcct.cct91 =0 AND mcct.cct92 =0 AND mcct.cct92a=0 AND
       mcct.cct92b=0 AND mcct.cct92c=0 AND mcct.cct92d=0 AND
       mcct.cct92e=0 AND mcct.cct92f=0 AND mcct.cct92g=0 AND mcct.cct92h=0 THEN  #FUN-7C0028 add
       DELETE FROM cct_file
       WHERE cct01=mcct.cct01 AND cct02=yy AND cct03=mm
         AND cct06=type 
    END IF
END FUNCTION
 
FUNCTION p500_mcct_0()
   LET mcct.cct01=g_sfb.sfb01
   LET mcct.cct02=yy
   LET mcct.cct03=mm
   LET mcct.cct04=g_sfb.sfb05
   LET mcct.cct11=0
   LET mcct.cct12=0  LET mcct.cct12a=0 LET mcct.cct12b=0
   LET mcct.cct12c=0 LET mcct.cct12d=0 LET mcct.cct12e=0
   LET mcct.cct12f=0 LET mcct.cct12g=0 LET mcct.cct12h=0   #FUN-7C0028 add
   LET mcct.cct20=0
   LET mcct.cct21=0
   LET mcct.cct22=0  LET mcct.cct22a=0 LET mcct.cct22b=0
   LET mcct.cct22c=0 LET mcct.cct22d=0 LET mcct.cct22e=0
   LET mcct.cct22f=0 LET mcct.cct22g=0 LET mcct.cct22h=0   #FUN-7C0028 add
   LET mcct.cct23=0  LET mcct.cct23a=0 LET mcct.cct23b=0
   LET mcct.cct23c=0 LET mcct.cct23d=0 LET mcct.cct23e=0
   LET mcct.cct23f=0 LET mcct.cct23g=0 LET mcct.cct23h=0   #FUN-7C0028 add
   LET mcct.cct31=0
   LET mcct.cct32=0  LET mcct.cct32a=0 LET mcct.cct32b=0
   LET mcct.cct32c=0 LET mcct.cct32d=0 LET mcct.cct32e=0
   LET mcct.cct32f=0 LET mcct.cct32g=0 LET mcct.cct32h=0   #FUN-7C0028 add
   LET mcct.cct41=0
   LET mcct.cct42=0  LET mcct.cct42a=0 LET mcct.cct42b=0
   LET mcct.cct42c=0 LET mcct.cct42d=0 LET mcct.cct42e=0
   LET mcct.cct42f=0 LET mcct.cct42g=0 LET mcct.cct42h=0   #FUN-7C0028 add
   # 98.08.20 Star 盤點盈虧
   LET mcct.cct52=0  LET mcct.cct52a=0 LET mcct.cct52b=0
   LET mcct.cct52c=0 LET mcct.cct52d=0 LET mcct.cct52e=0
   LET mcct.cct53=0  LET mcct.cct53a=0 LET mcct.cct53b=0
   LET mcct.cct53c=0 LET mcct.cct53d=0 LET mcct.cct53e=0
   LET mcct.cct91=0
   LET mcct.cct92=0  LET mcct.cct92a=0 LET mcct.cct92b=0
   LET mcct.cct92c=0 LET mcct.cct92d=0 LET mcct.cct92e=0
   LET mcct.cct92f=0 LET mcct.cct92g=0 LET mcct.cct92h=0   #FUN-7C0028 add
   LET t_time = TIME
   LET mcct.cctuser=g_user LET mcct.cctdate=TODAY LET mcct.ccttime=t_time
END FUNCTION
 
FUNCTION p500_ccu_0()           # 依上月期末轉本月期初, 其餘歸零
   LET g_ccu.ccu02=yy
   LET g_ccu.ccu03=mm
   LET g_ccu.ccu11=  g_ccu.ccu91
   LET g_ccu.ccu12=  g_ccu.ccu92
   LET g_ccu.ccu12a= g_ccu.ccu92a
   LET g_ccu.ccu12b= g_ccu.ccu92b
   LET g_ccu.ccu12c= g_ccu.ccu92c
   LET g_ccu.ccu12d= g_ccu.ccu92d
   LET g_ccu.ccu12e= g_ccu.ccu92e
   LET g_ccu.ccu12f= g_ccu.ccu92f   #FUN-7C0028 add
   LET g_ccu.ccu12g= g_ccu.ccu92g   #FUN-7C0028 add
   LET g_ccu.ccu12h= g_ccu.ccu92h   #FUN-7C0028 add
   LET g_ccu.ccu21=0
   LET g_ccu.ccu22=0  LET g_ccu.ccu22a=0 LET g_ccu.ccu22b=0
   LET g_ccu.ccu22c=0 LET g_ccu.ccu22d=0 LET g_ccu.ccu22e=0
   LET g_ccu.ccu22f=0 LET g_ccu.ccu22g=0 LET g_ccu.ccu22h=0   #FUN-7C0028 add
   LET g_ccu.ccu31=0
   LET g_ccu.ccu32=0  LET g_ccu.ccu32a=0 LET g_ccu.ccu32b=0
   LET g_ccu.ccu32c=0 LET g_ccu.ccu32d=0 LET g_ccu.ccu32e=0
   LET g_ccu.ccu32f=0 LET g_ccu.ccu32g=0 LET g_ccu.ccu32h=0   #FUN-7C0028 add
   LET g_ccu.ccu41=0
   LET g_ccu.ccu42=0  LET g_ccu.ccu42a=0 LET g_ccu.ccu42b=0
   LET g_ccu.ccu42c=0 LET g_ccu.ccu42d=0 LET g_ccu.ccu42e=0
   LET g_ccu.ccu42f=0 LET g_ccu.ccu42g=0 LET g_ccu.ccu42h=0   #FUN-7C0028 add
   # 98.08.20 Star 盤點盈虧
   LET g_ccu.ccu51=0
   LET g_ccu.ccu52=0  LET g_ccu.ccu52a=0 LET g_ccu.ccu52b=0
   LET g_ccu.ccu52c=0 LET g_ccu.ccu52d=0 LET g_ccu.ccu52e=0
   LET g_ccu.ccu91=0
   LET g_ccu.ccu92=0  LET g_ccu.ccu92a=0 LET g_ccu.ccu92b=0
   LET g_ccu.ccu92c=0 LET g_ccu.ccu92d=0 LET g_ccu.ccu92e=0
   LET g_ccu.ccu92f=0 LET g_ccu.ccu92g=0 LET g_ccu.ccu92h=0   #FUN-7C0028 add
END FUNCTION
 
FUNCTION p500_ccu_01()          # 全部歸零
   LET g_ccu.ccu02=yy
   LET g_ccu.ccu03=mm
   LET g_ccu.ccu11=0
   LET g_ccu.ccu12=0  LET g_ccu.ccu12a=0 LET g_ccu.ccu12b=0
   LET g_ccu.ccu12c=0 LET g_ccu.ccu12d=0 LET g_ccu.ccu12e=0
   LET g_ccu.ccu12f=0 LET g_ccu.ccu12g=0 LET g_ccu.ccu12h=0   #FUN-7C0028 add
   LET g_ccu.ccu21=0
   LET g_ccu.ccu22=0  LET g_ccu.ccu22a=0 LET g_ccu.ccu22b=0
   LET g_ccu.ccu22c=0 LET g_ccu.ccu22d=0 LET g_ccu.ccu22e=0
   LET g_ccu.ccu22f=0 LET g_ccu.ccu22g=0 LET g_ccu.ccu22h=0   #FUN-7C0028 add
   LET g_ccu.ccu31=0
   LET g_ccu.ccu32=0  LET g_ccu.ccu32a=0 LET g_ccu.ccu32b=0
   LET g_ccu.ccu32c=0 LET g_ccu.ccu32d=0 LET g_ccu.ccu32e=0
   LET g_ccu.ccu32f=0 LET g_ccu.ccu32g=0 LET g_ccu.ccu32h=0   #FUN-7C0028 add
   LET g_ccu.ccu41=0
   LET g_ccu.ccu42=0  LET g_ccu.ccu42a=0 LET g_ccu.ccu42b=0
   LET g_ccu.ccu42c=0 LET g_ccu.ccu42d=0 LET g_ccu.ccu42e=0
   LET g_ccu.ccu42f=0 LET g_ccu.ccu42g=0 LET g_ccu.ccu42h=0   #FUN-7C0028 add
   LET g_ccu.ccu51=0
   LET g_ccu.ccu52=0  LET g_ccu.ccu52a=0 LET g_ccu.ccu52b=0
   LET g_ccu.ccu52c=0 LET g_ccu.ccu52d=0 LET g_ccu.ccu52e=0
   LET g_ccu.ccu91=0
   LET g_ccu.ccu92=0  LET g_ccu.ccu92a=0 LET g_ccu.ccu92b=0
   LET g_ccu.ccu92c=0 LET g_ccu.ccu92d=0 LET g_ccu.ccu92e=0
   LET g_ccu.ccu92f=0 LET g_ccu.ccu92g=0 LET g_ccu.ccu92h=0   #FUN-7C0028 add
END FUNCTION
 
FUNCTION p500_out()
    DEFINE l_cmd        LIKE type_file.chr1000       #No.FUN-680122CHAR(30)
    DEFINE l_name       LIKE type_file.chr20         #No.FUN-680122CHAR(20)
    DEFINE l_ccy        RECORD LIKE ccy_file.*
    DEFINE n            LIKE type_file.num10         #No.FUN-680122INTEGER
    CALL cl_outnam('axcp500') RETURNING l_name
    DECLARE p500_co CURSOR FOR
       SELECT DISTINCT * FROM ccy_file    #No.MOD-880241 add distinct
        WHERE ccy01>start_date OR (ccy01=start_date AND ccy02>=start_time)
          AND ccy03 = g_user       #No.MOD-880241 add 
    START REPORT p500_rep TO l_name
    LET l_ccy.ccy04=start_date,' ',start_time,' begin...'
    OUTPUT TO REPORT p500_rep(l_ccy.*)
    LET n=0
    FOREACH p500_co INTO l_ccy.*
      LET n=n+1
      OUTPUT TO REPORT p500_rep(l_ccy.*)
    END FOREACH
    LET l_ccy.ccy04=TODAY,' ',TIME,' end  ...'
    OUTPUT TO REPORT p500_rep(l_ccy.*)
    FINISH REPORT p500_rep
    IF n>0 THEN
       CALL cl_prt(l_name,' ','1',g_len)
    ELSE
        IF os.Path.chrwx(l_name CLIPPED,511) THEN END IF   #No.FUN-9C0009
    END IF
    CLOSE p500_co
END FUNCTION
 
REPORT p500_rep(l_ccy)
   DEFINE l_ccy         RECORD LIKE ccy_file.*
   OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
   FORMAT ON EVERY ROW PRINT l_ccy.ccy04 CLIPPED
END REPORT
 
FUNCTION p500_ckp_ccc()
IF cl_null(g_ccc.ccc08)  THEN LET g_ccc.ccc08  = ' ' END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc11)  THEN LET g_ccc.ccc11  = 0 END IF
IF cl_null(g_ccc.ccc12)  THEN LET g_ccc.ccc12  = 0 END IF
IF cl_null(g_ccc.ccc12a) THEN LET g_ccc.ccc12a = 0 END IF
IF cl_null(g_ccc.ccc12b) THEN LET g_ccc.ccc12b = 0 END IF
IF cl_null(g_ccc.ccc12c) THEN LET g_ccc.ccc12c = 0 END IF
IF cl_null(g_ccc.ccc12d) THEN LET g_ccc.ccc12d = 0 END IF
IF cl_null(g_ccc.ccc12e) THEN LET g_ccc.ccc12e = 0 END IF
IF cl_null(g_ccc.ccc12f) THEN LET g_ccc.ccc12f = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc12g) THEN LET g_ccc.ccc12g = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc12h) THEN LET g_ccc.ccc12h = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc21)  THEN LET g_ccc.ccc21  = 0 END IF
IF cl_null(g_ccc.ccc22)  THEN LET g_ccc.ccc22  = 0 END IF
IF cl_null(g_ccc.ccc22a) THEN LET g_ccc.ccc22a = 0 END IF
IF cl_null(g_ccc.ccc22b) THEN LET g_ccc.ccc22b = 0 END IF
IF cl_null(g_ccc.ccc22c) THEN LET g_ccc.ccc22c = 0 END IF
IF cl_null(g_ccc.ccc22d) THEN LET g_ccc.ccc22d = 0 END IF
IF cl_null(g_ccc.ccc22e) THEN LET g_ccc.ccc22e = 0 END IF
IF cl_null(g_ccc.ccc22f) THEN LET g_ccc.ccc22f = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc22g) THEN LET g_ccc.ccc22g = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc22h) THEN LET g_ccc.ccc22h = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc23)  THEN LET g_ccc.ccc23  = 0 END IF
IF cl_null(g_ccc.ccc23a) THEN LET g_ccc.ccc23a = 0 END IF
IF cl_null(g_ccc.ccc23b) THEN LET g_ccc.ccc23b = 0 END IF
IF cl_null(g_ccc.ccc23c) THEN LET g_ccc.ccc23c = 0 END IF
IF cl_null(g_ccc.ccc23d) THEN LET g_ccc.ccc23d = 0 END IF
IF cl_null(g_ccc.ccc23e) THEN LET g_ccc.ccc23e = 0 END IF
IF cl_null(g_ccc.ccc23f) THEN LET g_ccc.ccc23f = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc23g) THEN LET g_ccc.ccc23g = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc23h) THEN LET g_ccc.ccc23h = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc25)  THEN LET g_ccc.ccc25  = 0 END IF
IF cl_null(g_ccc.ccc26)  THEN LET g_ccc.ccc26  = 0 END IF
IF cl_null(g_ccc.ccc26a) THEN LET g_ccc.ccc26a = 0 END IF
IF cl_null(g_ccc.ccc26b) THEN LET g_ccc.ccc26b = 0 END IF
IF cl_null(g_ccc.ccc26c) THEN LET g_ccc.ccc26c = 0 END IF
IF cl_null(g_ccc.ccc26d) THEN LET g_ccc.ccc26d = 0 END IF
IF cl_null(g_ccc.ccc26e) THEN LET g_ccc.ccc26e = 0 END IF
IF cl_null(g_ccc.ccc26f) THEN LET g_ccc.ccc26f = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc26g) THEN LET g_ccc.ccc26g = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc26h) THEN LET g_ccc.ccc26h = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc27)  THEN LET g_ccc.ccc27  = 0 END IF
IF cl_null(g_ccc.ccc28)  THEN LET g_ccc.ccc28  = 0 END IF
IF cl_null(g_ccc.ccc28a) THEN LET g_ccc.ccc28a = 0 END IF
IF cl_null(g_ccc.ccc28b) THEN LET g_ccc.ccc28b = 0 END IF
IF cl_null(g_ccc.ccc28c) THEN LET g_ccc.ccc28c = 0 END IF
IF cl_null(g_ccc.ccc28d) THEN LET g_ccc.ccc28d = 0 END IF
IF cl_null(g_ccc.ccc28e) THEN LET g_ccc.ccc28e = 0 END IF
IF cl_null(g_ccc.ccc28f) THEN LET g_ccc.ccc28f = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc28g) THEN LET g_ccc.ccc28g = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc28h) THEN LET g_ccc.ccc28h = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc31)  THEN LET g_ccc.ccc31  = 0 END IF
IF cl_null(g_ccc.ccc32)  THEN LET g_ccc.ccc32  = 0 END IF
IF cl_null(g_ccc.ccc41)  THEN LET g_ccc.ccc41  = 0 END IF
IF cl_null(g_ccc.ccc42)  THEN LET g_ccc.ccc42  = 0 END IF
IF cl_null(g_ccc.ccc43)  THEN LET g_ccc.ccc43  = 0 END IF
IF cl_null(g_ccc.ccc44)  THEN LET g_ccc.ccc44  = 0 END IF
IF cl_null(g_ccc.ccc51)  THEN LET g_ccc.ccc51  = 0 END IF
IF cl_null(g_ccc.ccc52)  THEN LET g_ccc.ccc52  = 0 END IF
IF cl_null(g_ccc.ccc61)  THEN LET g_ccc.ccc61  = 0 END IF
IF cl_null(g_ccc.ccc62)  THEN LET g_ccc.ccc62  = 0 END IF
IF cl_null(g_ccc.ccc62a) THEN LET g_ccc.ccc62a = 0 END IF
IF cl_null(g_ccc.ccc62b) THEN LET g_ccc.ccc62b = 0 END IF
IF cl_null(g_ccc.ccc62c) THEN LET g_ccc.ccc62c = 0 END IF
IF cl_null(g_ccc.ccc62d) THEN LET g_ccc.ccc62d = 0 END IF
IF cl_null(g_ccc.ccc62e) THEN LET g_ccc.ccc62e = 0 END IF
IF cl_null(g_ccc.ccc62f) THEN LET g_ccc.ccc62f = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc62g) THEN LET g_ccc.ccc62g = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc62h) THEN LET g_ccc.ccc62h = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc63)  THEN LET g_ccc.ccc63  = 0 END IF
IF cl_null(g_ccc.ccc64)  THEN LET g_ccc.ccc64  = 0 END IF
IF cl_null(g_ccc.ccc65)  THEN LET g_ccc.ccc65  = 0 END IF
IF cl_null(g_ccc.ccc66)  THEN LET g_ccc.ccc66  = 0 END IF
IF cl_null(g_ccc.ccc66a) THEN LET g_ccc.ccc66a = 0 END IF
IF cl_null(g_ccc.ccc66b) THEN LET g_ccc.ccc66b = 0 END IF
IF cl_null(g_ccc.ccc66c) THEN LET g_ccc.ccc66c = 0 END IF
IF cl_null(g_ccc.ccc66d) THEN LET g_ccc.ccc66d = 0 END IF
IF cl_null(g_ccc.ccc66e) THEN LET g_ccc.ccc66e = 0 END IF
IF cl_null(g_ccc.ccc66f) THEN LET g_ccc.ccc66f = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc66g) THEN LET g_ccc.ccc66g = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc66h) THEN LET g_ccc.ccc66h = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc71)  THEN LET g_ccc.ccc71  = 0 END IF
IF cl_null(g_ccc.ccc72)  THEN LET g_ccc.ccc72  = 0 END IF
IF cl_null(g_ccc.ccc81)  THEN LET g_ccc.ccc81  = 0 END IF
IF cl_null(g_ccc.ccc82)  THEN LET g_ccc.ccc82  = 0 END IF
IF cl_null(g_ccc.ccc82a) THEN LET g_ccc.ccc82a = 0 END IF
IF cl_null(g_ccc.ccc82b) THEN LET g_ccc.ccc82b = 0 END IF
IF cl_null(g_ccc.ccc82c) THEN LET g_ccc.ccc82c = 0 END IF
IF cl_null(g_ccc.ccc82d) THEN LET g_ccc.ccc82d = 0 END IF
IF cl_null(g_ccc.ccc82e) THEN LET g_ccc.ccc82e = 0 END IF
IF cl_null(g_ccc.ccc82f) THEN LET g_ccc.ccc82f = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc82g) THEN LET g_ccc.ccc82g = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc82h) THEN LET g_ccc.ccc82h = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc91)  THEN LET g_ccc.ccc91  = 0 END IF
IF cl_null(g_ccc.ccc92)  THEN LET g_ccc.ccc92  = 0 END IF
IF cl_null(g_ccc.ccc92a) THEN LET g_ccc.ccc92a = 0 END IF
IF cl_null(g_ccc.ccc92b) THEN LET g_ccc.ccc92b = 0 END IF
IF cl_null(g_ccc.ccc92c) THEN LET g_ccc.ccc92c = 0 END IF
IF cl_null(g_ccc.ccc92d) THEN LET g_ccc.ccc92d = 0 END IF
IF cl_null(g_ccc.ccc92e) THEN LET g_ccc.ccc92e = 0 END IF
IF cl_null(g_ccc.ccc92f) THEN LET g_ccc.ccc92f = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc92g) THEN LET g_ccc.ccc92g = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc92h) THEN LET g_ccc.ccc92h = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc93)  THEN LET g_ccc.ccc93  = 0 END IF
IF cl_null(g_ccc.ccc93a) THEN LET g_ccc.ccc93a = 0 END IF
IF cl_null(g_ccc.ccc93b) THEN LET g_ccc.ccc93b = 0 END IF
IF cl_null(g_ccc.ccc93c) THEN LET g_ccc.ccc93c = 0 END IF
IF cl_null(g_ccc.ccc93d) THEN LET g_ccc.ccc93d = 0 END IF
IF cl_null(g_ccc.ccc93e) THEN LET g_ccc.ccc93e = 0 END IF
IF cl_null(g_ccc.ccc93f) THEN LET g_ccc.ccc93f = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc93g) THEN LET g_ccc.ccc93g = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc93h) THEN LET g_ccc.ccc93h = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc211)  THEN LET g_ccc.ccc211 = 0 END IF
IF cl_null(g_ccc.ccc212)  THEN LET g_ccc.ccc212 = 0 END IF
IF cl_null(g_ccc.ccc213)  THEN LET g_ccc.ccc213 = 0 END IF
IF cl_null(g_ccc.ccc214)  THEN LET g_ccc.ccc214 = 0 END IF
IF cl_null(g_ccc.ccc215)  THEN LET g_ccc.ccc215 = 0 END IF
IF cl_null(g_ccc.ccc221)  THEN LET g_ccc.ccc221 = 0 END IF
IF cl_null(g_ccc.ccc22a1) THEN LET g_ccc.ccc22a1= 0 END IF
IF cl_null(g_ccc.ccc22b1) THEN LET g_ccc.ccc22b1= 0 END IF
IF cl_null(g_ccc.ccc22c1) THEN LET g_ccc.ccc22c1= 0 END IF
IF cl_null(g_ccc.ccc22d1) THEN LET g_ccc.ccc22d1= 0 END IF
IF cl_null(g_ccc.ccc22e1) THEN LET g_ccc.ccc22e1= 0 END IF
IF cl_null(g_ccc.ccc22f1) THEN LET g_ccc.ccc22f1= 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc22g1) THEN LET g_ccc.ccc22g1= 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc22h1) THEN LET g_ccc.ccc22h1= 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc222)  THEN LET g_ccc.ccc222 = 0 END IF
IF cl_null(g_ccc.ccc22a2) THEN LET g_ccc.ccc22a2= 0 END IF
IF cl_null(g_ccc.ccc22b2) THEN LET g_ccc.ccc22b2= 0 END IF
IF cl_null(g_ccc.ccc22c2) THEN LET g_ccc.ccc22c2= 0 END IF
IF cl_null(g_ccc.ccc22d2) THEN LET g_ccc.ccc22d2= 0 END IF
IF cl_null(g_ccc.ccc22e2) THEN LET g_ccc.ccc22e2= 0 END IF
IF cl_null(g_ccc.ccc22f2) THEN LET g_ccc.ccc22f2= 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc22g2) THEN LET g_ccc.ccc22g2= 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc22h2) THEN LET g_ccc.ccc22h2= 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc223)  THEN LET g_ccc.ccc223 = 0 END IF
IF cl_null(g_ccc.ccc22a3) THEN LET g_ccc.ccc22a3= 0 END IF
IF cl_null(g_ccc.ccc22b3) THEN LET g_ccc.ccc22b3= 0 END IF
IF cl_null(g_ccc.ccc22c3) THEN LET g_ccc.ccc22c3= 0 END IF
IF cl_null(g_ccc.ccc22d3) THEN LET g_ccc.ccc22d3= 0 END IF
IF cl_null(g_ccc.ccc22e3) THEN LET g_ccc.ccc22e3= 0 END IF
IF cl_null(g_ccc.ccc22f3) THEN LET g_ccc.ccc22f3= 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc22g3) THEN LET g_ccc.ccc22g3= 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc22h3) THEN LET g_ccc.ccc22h3= 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc224)  THEN LET g_ccc.ccc224 = 0 END IF
IF cl_null(g_ccc.ccc22a4) THEN LET g_ccc.ccc22a4= 0 END IF
IF cl_null(g_ccc.ccc22b4) THEN LET g_ccc.ccc22b4= 0 END IF
IF cl_null(g_ccc.ccc22c4) THEN LET g_ccc.ccc22c4= 0 END IF
IF cl_null(g_ccc.ccc22d4) THEN LET g_ccc.ccc22d4= 0 END IF
IF cl_null(g_ccc.ccc22e4) THEN LET g_ccc.ccc22e4= 0 END IF
IF cl_null(g_ccc.ccc22f4) THEN LET g_ccc.ccc22f4= 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc22g4) THEN LET g_ccc.ccc22g4= 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc22h4) THEN LET g_ccc.ccc22h4= 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc225)  THEN LET g_ccc.ccc225 = 0 END IF
IF cl_null(g_ccc.ccc22a5) THEN LET g_ccc.ccc22a5= 0 END IF
IF cl_null(g_ccc.ccc22b5) THEN LET g_ccc.ccc22b5= 0 END IF
IF cl_null(g_ccc.ccc22c5) THEN LET g_ccc.ccc22c5= 0 END IF
IF cl_null(g_ccc.ccc22d5) THEN LET g_ccc.ccc22d5= 0 END IF
IF cl_null(g_ccc.ccc22e5) THEN LET g_ccc.ccc22e5= 0 END IF
IF cl_null(g_ccc.ccc22f5) THEN LET g_ccc.ccc22f5= 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc22g5) THEN LET g_ccc.ccc22g5= 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc22h5) THEN LET g_ccc.ccc22h5= 0 END IF   #FUN-7C0028 add
#CHI-980045(S) 
IF cl_null(g_ccc.ccc226)  THEN LET g_ccc.ccc226 = 0 END IF
IF cl_null(g_ccc.ccc22a6) THEN LET g_ccc.ccc22a6= 0 END IF
IF cl_null(g_ccc.ccc22b6) THEN LET g_ccc.ccc22b6= 0 END IF
IF cl_null(g_ccc.ccc22c6) THEN LET g_ccc.ccc22c6= 0 END IF
IF cl_null(g_ccc.ccc22d6) THEN LET g_ccc.ccc22d6= 0 END IF
IF cl_null(g_ccc.ccc22e6) THEN LET g_ccc.ccc22e6= 0 END IF
IF cl_null(g_ccc.ccc22f6) THEN LET g_ccc.ccc22f6= 0 END IF
IF cl_null(g_ccc.ccc22g6) THEN LET g_ccc.ccc22g6= 0 END IF
IF cl_null(g_ccc.ccc22h6) THEN LET g_ccc.ccc22h6= 0 END IF
#CHI-980045(E)
END FUNCTION
 
FUNCTION p500_tlfcost_upd()
 
  #依選擇之成本計算方式,先更新該計算年月的所有tlfcost值
  #當type='1' OR '2'時,tlfcost=' '
  #當type='3'時       ,tlfcost=批號 tlf904
  #當type='4'時       ,tlfcost=專案號 tlf20
  #當type='5'時       ,tlfcost=倉庫 tlf902
  CASE
     WHEN type='1' OR type='2'
        UPDATE tlf_file SET tlfcost=' '
                      WHERE tlf06 BETWEEN g_bdate AND g_edate
     WHEN type='3'   #批號
        UPDATE tlf_file SET tlfcost=tlf904
                      WHERE tlf06 BETWEEN g_bdate AND g_edate
     WHEN type='4'   #專案編號
        UPDATE tlf_file SET tlfcost=tlf20
                      WHERE tlf06 BETWEEN g_bdate AND g_edate
       #---------------No:MOD-B60033 mark
       #UPDATE tlf_file SET tlfcost=tlf904
       #              WHERE tlf06 BETWEEN g_bdate AND g_edate
       #       AND ((tlf02=50 AND ( tlf03 BETWEEN 60 AND 69 OR tlf03 =18) ) OR
       #            (tlf03=50 AND tlf02 BETWEEN 60 AND 69))
       #       AND tlf13 MATCHES 'asfi5*' #工單發退料者
       #---------------No:MOD-B60033 end
       #MOD-CA0177---mark---S
       #UPDATE tlf_file SET tlfcost=tlf904
       # WHERE tlf06 BETWEEN g_bdate AND g_edate
       #   AND tlf13 MATCHES 'asft6*'
       #MOD-CA0177---mark---E
     WHEN type='5'   #倉庫
        UPDATE tlf_file SET tlfcost=tlf901 #FUN-840151
                      WHERE tlf06 BETWEEN g_bdate AND g_edate
  END CASE
  IF STATUS THEN
     CALL cl_err3("upd","tlf_file","","",STATUS,"","upd tlf:",1)
     LET g_success='N' RETURN
  END IF
  #將tlfcost是NULL的資料UPDATE成' '
  UPDATE tlf_file SET tlfcost=' '
                WHERE tlf06 BETWEEN g_bdate AND g_edate AND tlfcost IS NULL
  IF STATUS THEN
     CALL cl_err3("upd","tlf_file","","",STATUS,"","upd tlf:",1)
     LET g_success='N' RETURN
  END IF
 
END FUNCTION
 
 #先刪除舊統計資料
FUNCTION p500_del()
  DEFINE   l_sql    STRING #MOD-540206
 
  IF g_success='Y' AND choice1='Y' THEN

     #FUN-D60130 add--------------------str
     LET l_sql="DELETE FROM ccb_file WHERE",
               " ccb02=",yy," AND ccb03=",mm,
               " AND ccb06='",type,"'", 
               " AND ccb23 = '4' ",  
               " AND EXISTS( SELECT 1 FROM ima_file ",  
               " WHERE ima01 = ccb01 AND ",g_wc,")"   
     PREPARE p500_ch1_s0 FROM l_sql
     EXECUTE p500_ch1_s0
     IF STATUS THEN
        LET g_success='N'
        CALL cl_err("ccb_file ","axc-005",1)
        RETURN
     END IF
     #FUN-D60130 add--------------------end

     LET l_sql="DELETE FROM cch_file WHERE",
               " cch02=",yy," AND cch03=",mm,
               " AND cch06='",type,"'",   
               #" AND cch01 IN (SELECT ccg01 FROM ccg_file  ",  #CHI-C80002
               #" WHERE ccg02=",yy," AND ccg03=",mm,  #CHI-C80002
               " AND EXISTS(SELECT 1 FROM ccg_file  ",  #CHI-C80002
               " WHERE ccg01 = cch01 AND ccg02=",yy," AND ccg03=",mm, #CHI-C80002
               " AND ccg06 ='",type,"'",
               #"   AND ccg04 IN ( SELECT ima01 FROM ima_file ",  #CHI-C80002
               #" WHERE ",g_wc,"))"  #CHI-C80002
               " AND EXISTS( SELECT 1 FROM ima_file ",  #CHI-C80002
               " WHERE ima01 = ccg04 AND ",g_wc,"))"   #CHI-C80002
     PREPARE p500_ch1_s1 FROM l_sql
     EXECUTE p500_ch1_s1
     IF STATUS THEN
        LET g_success='N'
        CALL cl_err("cch_file ","axc-005",1)
        RETURN
     END IF
     LET l_sql="DELETE FROM ccg_file WHERE",
               " ccg02=",yy," AND ccg03=",mm,
               " AND ccg06='",type,"'",       #FUN-7C0028 add
               #" AND ccg04 IN (SELECT ima01 FROM ima_file WHERE ",  #CHI-C80002
               " AND EXISTS(SELECT 1 FROM ima_file WHERE ima01 = ccg04 AND ",  #CHI-C80002
               g_wc,")"
     PREPARE p500_ch1_s2 FROM l_sql
     EXECUTE p500_ch1_s2
     IF STATUS THEN
        LET g_success='N'
        CALL cl_err("ccg_file ","axc-005",1)
        RETURN
     END IF
     LET l_sql="DELETE FROM ccc_file WHERE",
               " ccc02=",yy," AND ccc03=",mm,
               " AND ccc07='",type,"'",   #FUN-7C0028 add
               #" AND ccc01 IN (SELECT ima01 FROM ima_file WHERE ",  #CHI-C80002
               " AND EXISTS(SELECT 1 FROM ima_file WHERE ima01 = ccc01 AND ",  #CHI-C80002
               g_wc,")"
     PREPARE p500_ch1_s3 FROM l_sql
     EXECUTE p500_ch1_s3
     IF STATUS THEN
        LET g_success='N'
        CALL cl_err("ccc_file ","axc-005",1)
        RETURN
     END IF
 
     LET l_sql="DELETE FROM ccu_file WHERE",  # 拆件式工單在製元件
               " ccu02=",yy," AND ccu03=",mm,
               " AND ccu06='",type,"'",      
               #" AND ccu01 IN (SELECT cct01 FROM cct_file",  #CHI-C80002
               #" WHERE cct02=",yy," AND cct03=",mm,  #CHI-C80002
               " AND EXISTS(SELECT 1 FROM cct_file",  #CHI-C80002
               " WHERE cct01 = ccu01 AND cct02=",yy," AND cct03=",mm,  #CHI-C80002
               "   AND cct06 ='",type,"'",
               #"   AND cct04 IN ( SELECT ima01 FROM ima_file ",  #CHI-C80002
               #" WHERE ",g_wc,"))"  #CHI-C80002
               "   AND EXISTS( SELECT 1 FROM ima_file ",  #CHI-C80002
               " WHERE ima01 = cct04 AND ",g_wc,"))"  #CHI-C80002
     PREPARE p500_ch1_s4 FROM l_sql
     EXECUTE p500_ch1_s4
     IF STATUS THEN
        LET g_success='N'
        CALL cl_err("ccu_file ","axc-005",1)
        RETURN
     END IF
 
     LET l_sql="DELETE FROM cct_file WHERE",  # 拆件式工單在製主件
               " cct02=",yy," AND cct03=",mm,
               " AND cct06='",type,"'",       #FUN-7C0028 add
               #" AND cct04 IN (SELECT ima01 FROM ima_file WHERE ",  #CHI-C80002
               " AND EXISTS(SELECT 1 FROM ima_file WHERE ima01 = cct04 AND ",  #CHI-C80002
               g_wc,")"
      PREPARE p500_ch1_s6 FROM l_sql #MOD-570372
      EXECUTE p500_ch1_s6            #MOD-570372
     IF STATUS THEN
        LET g_success='N'
        CALL cl_err("cct_file ","axc-005",1)
        RETURN
     END IF
 
     LET l_sql="DELETE FROM cce_file WHERE",  # 聯產品轉出
               " cce02=",yy," AND cce03=",mm,
               " AND cce06='",type,"'",       #FUN-7C0028 add
               #" AND cce04 IN (SELECT ima01 FROM ima_file WHERE ",  #CHI-C80002
               " AND EXISTS(SELECT 1 FROM ima_file WHERE ima01 = cce04 AND ",  #CHI-C80002
               g_wc,")"
     PREPARE p500_ch1_s5 FROM l_sql
     EXECUTE p500_ch1_s5
     IF STATUS THEN
        LET g_success='N'
        CALL cl_err("cce_file ","axc-005",1)
        RETURN
     END IF
#  END IF        #No.MOD-C70111 mark
  
#No.MOD-B30004 --begin
  LET l_sql="DELETE FROM cch_file WHERE",
            " cch02=",yy," AND cch03=",mm,
            " AND cch06='",type,"'",
            #" AND (cch01 IN ( SELECT ccg01 FROM ima_file,ccg_file WHERE ccg04 = ima01 and ", #CHI-C80002
            " AND ( EXISTS( SELECT 1 FROM ima_file,ccg_file WHERE ccg01 = cch01 AND ccg04 = ima01 and ", #CHI-C80002
           #g_wc,") OR cch04= ' DL+OH+SUB' OR cch04=' ADJUST')"  #MOD-C20087 mark
            g_wc,"))"                                            #MOD-C20087
  PREPARE p500_ch1_s8 FROM l_sql
  EXECUTE p500_ch1_s8
  IF STATUS THEN
     LET g_success='N'
     CALL cl_err("cch_file ","axc-005",1)
     RETURN
  END IF
#No.MOD-B30004 --end
  END IF        #No.MOD-C70111 add
  
  IF g_success='Y' THEN
     CALL p500_get_date() IF g_success = 'N' THEN RETURN END IF
     LET l_sql="DELETE FROM tlfc_file WHERE",  #成本計算類型異動成本記錄檔
               " tlfc06 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
               " AND tlfctype='",type,"'",
               #" AND tlfc01 IN (SELECT ima01 FROM ima_file WHERE ", #CHI-C80002
               " AND EXISTS(SELECT 1 FROM ima_file WHERE ima01 = tlfc01 AND ",  #CHI-C80002
               g_wc,")"
     #刪除時需排除雜收,因為是從axct500寫入,這邊不可刪除
     #雜發依參數ccz08決定,若ccz08='1'時,DELETE tlfc_file要將雜發刪除
     #                    若ccz08='2'時,DELETE tlfc_file不將雜發刪除
     IF g_ccz.ccz08 = '1' THEN       #1.系統認定 2.人工認定(axct501)
        LET l_sql=l_sql,
                  " AND tlfc13!='aimt302' AND tlfc13!='aimt312'"   #雜收
     ELSE
        LET l_sql=l_sql,
                  " AND tlfc13!='aimt302' AND tlfc13!='aimt312'",  #雜收
                  " AND tlfc13!='aimt301' AND tlfc13!='aimt311'"   #雜發
     END IF
     PREPARE p500_ch1_s7 FROM l_sql
     EXECUTE p500_ch1_s7
     IF STATUS THEN
        LET g_success='N'
        CALL cl_err("tlfc_file ","axc-005",1)
        RETURN
     END IF
  END IF
END FUNCTION
#No.FUN-9C0073 ------------------By chenls 10/01/12

#CHI-980045(S)
#檢查成會分類是否歸為"銷退入項"
#期初數量+本月入庫數量<重工領料數量時,銷退.退料才視為入項
FUNCTION p500_tlf28()
   DEFINE l_cca11   LIKE cca_file.cca11
   DEFINE l_inqty1  LIKE tlf_file.tlf10
   DEFINE l_outqty1 LIKE tlf_file.tlf10
   DEFINE l_inqty2  LIKE tlf_file.tlf10
   DEFINE l_outqty2 LIKE tlf_file.tlf10

#MOD-D40085 str add-----
   UPDATE tlf_file SET tlf28 = ''
                 WHERE tlf01 = g_ima01
                   AND tlf13 = 'aomt800'
                   AND tlf06 BETWEEN g_bdate AND g_edate
                   AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = tlf902) 
                   AND tlf907 = 1
#MOD-D40085 end add-----


   IF g_ccz.ccz31 ='1' OR cl_null(g_ccz.ccz31) THEN RETURN END IF


   IF g_ccz.ccz31 ='2' THEN
      LET l_cca11 = NULL
      SELECT cca11 INTO l_cca11 FROM cca_file
                               WHERE cca01=g_ima01
                                 AND cca02=last_yy
                                 AND cca03=last_mm
                                 AND cca06=type
                                 AND cca07=g_tlfcost
      IF l_cca11 IS NULL THEN LET l_cca11 = 0 END IF
      
      #入庫數
      LET l_inqty1 = NULL
      SELECT SUM(tlf10) INTO l_inqty1 FROM tlf_file
                               WHERE tlf01=g_ima01
                                 AND tlf13='asft6201'
                                 AND tlf06 BETWEEN g_bdate AND g_edate
                                 #AND tlf902 NOT IN (SELECT jce02 FROM jce_file)  #CHI-C80002
                                 AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = tlf902)  #CHI-C80002
                                 AND tlf907 = 1
      IF l_inqty1 IS NULL THEN LET l_inqty1 = 0 END IF
      
      #退庫數
      LET l_outqty1 = NULL
      SELECT SUM(tlf10) INTO l_outqty1 FROM tlf_file
                               WHERE tlf01=g_ima01
                                 AND tlf13='apmt1072'
                                 AND tlf06 BETWEEN g_bdate AND g_edate
                                 #AND tlf902 NOT IN (SELECT jce02 FROM jce_file)  #CHI-C80002
                                 AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = tlf902)  #CHI-C80002
                                 AND tlf907 = -1
      IF l_outqty1 IS NULL THEN LET l_outqty1 = 0 END IF
         
      #發料量
      LET l_inqty2 = NULL
      SELECT SUM(tlf10) INTO l_inqty2 FROM tlf_file
                               WHERE tlf01=g_ima01
                                 AND tlf13 LIKE 'asfi51%'
                                 AND tlf06 BETWEEN g_bdate AND g_edate
                                 #AND tlf902 NOT IN (SELECT jce02 FROM jce_file)  #CHI-C80002
                                 AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = tlf902)  #CHI-C80002
                                 AND tlf907 = -1
      IF l_inqty2 IS NULL THEN LET l_inqty2 = 0 END IF

      #退料量
      LET l_outqty2 = NULL
      SELECT SUM(tlf10) INTO l_outqty2 FROM tlf_file
                               WHERE tlf01=g_ima01
                                 AND tlf13 LIKE 'asfi52%'
                                 AND tlf06 BETWEEN g_bdate AND g_edate
                                 #AND tlf902 NOT IN (SELECT jce02 FROM jce_file)  #CHI-C80002
                                 AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = tlf902)  #CHI-C80002
                                 AND tlf907 = 1
      IF l_outqty2 IS NULL THEN LET l_outqty2 = 0 END IF
      
      IF l_cca11 + (l_inqty1 - l_outqty1) >= (l_inqty2 - l_outqty2) THEN
         RETURN
      END IF
   END IF
   
   UPDATE tlf_file SET tlf28 = 'S'
                 WHERE tlf01 = g_ima01
                   AND tlf13 = 'aomt800'
                   AND tlf06 BETWEEN g_bdate AND g_edate
                   #AND tlf902 NOT IN (SELECT jce02 FROM jce_file)  #CHI-C80002
                   AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = tlf902)  #CHI-C80002
                   AND tlf907 = 1

END FUNCTION
#CHI-980045(E)
#No.FUN-AA0025 --begin
FUNCTION p500_chk()
DEFINE l_sql       STRING
DEFINE l_n         LIKE type_file.num5

      LET	l_n = 0
      CALL p500_get_date() IF g_success = 'N' THEN RETURN END IF #MOD-C30658 add
      LET l_sql = " SELECT COUNT(*) FROM npp_file",
                  "  WHERE nppsys  = 'CA'",
                  "    AND npp011  = '1'",
                  "    AND npp00 >= 2 AND npp00 <= 7 ",
                  "    AND npp00 <> 6 ",
                  "    AND nppglno IS NOT NULL ",
                  "    AND YEAR(npp02) = ",yy,       #MOD-C30060
                  "    AND MONTH(npp02) = ",mm,      #MOD-C30060
                  "    AND npp03 BETWEEN '",g_bdate,"' AND '",g_edate ,"' "  #MOD-C30658 add

      PREPARE npq_pre FROM l_sql
      DECLARE npq_cs CURSOR FOR npq_pre
      OPEN npq_cs
      FETCH npq_cs INTO l_n
      CLOSE npq_cs
            
      IF l_n >0 THEN  
         CALL cl_err('','axm-275',1)
         LET g_success ='N'
         RETURN  
      END IF
END FUNCTION
#No.FUN-AA0025 --end

#FUN-C80092---add---str---
FUNCTION p500_ckk_upd()
DEFINE l_n    LIKE type_file.num5

   LET l_n = 0
   SELECT COUNT(*) INTO l_n FROM ckk_file
       WHERE ckk03 = yy AND ckk04 = mm
         AND ckk06 = type AND ckkacti = 'Y'
   IF NOT cl_null(g_bgjob) AND l_n > 0 THEN
      IF g_bgjob = 'N' THEN
         IF cl_confirm("axc-400") THEN
            UPDATE ckk_file SET ckkacti = 'N'
                          WHERE   ckk03 = yy
                            AND   ckk04 = mm
                            AND   ckk06 = type
            IF STATUS THEN RETURN FALSE END IF
         END IF
      ELSE
         UPDATE ckk_file SET ckkacti = 'N'
                       WHERE   ckk03 = yy
                         AND   ckk04 = mm
                         AND   ckk06 = type
         IF STATUS THEN RETURN FALSE END IF
      END IF
   END IF
RETURN TRUE
END FUNCTION
#FUN-C80092---add---end---

#FUN-D60130 add-----------------str
FUNCTION p500_ins_ccb(p_tlf905,p_tlf62)  
DEFINE l_sfb28   LIKE sfb_file.sfb28,
       l_sfb38   LIKE sfb_file.sfb38,
       l_rvv39   LIKE rvv_file.rvv39,
       l_rvv39_s LIKE rvv_file.rvv39,
       l_rvu114  LIKE rvu_file.rvu114,
       l_pmm42   LIKE pmm_file.pmm42
DEFINE p_tlf905  LIKE tlf_file.tlf905 
DEFINE p_tlf62   LIKE tlf_file.tlf62
DEFINE l_sql     STRING       
DEFINE l_cnt     LIKE type_file.num5

   LET l_rvv39 = 0
   LET l_rvv39_s = 0
   LET l_sql="SELECT rvv39,rvu114,pmm42 FROM rvu_file,rvv_file ",
             "  LEFT OUTER JOIN pmm_file ON (pmm01=rvv36) ",
             " WHERE rvu01=rvv01 AND rvuconf='Y' ",
             "   AND rvu03 BETWEEN '",g_bdate,"' AND '",g_edate,"' ",
             "   AND rvu00='3' AND rvu08='SUB' ",
             "   AND rvv18='",p_tlf62,"' ",
             "   AND rvu01='",p_tlf905,"' "
   PREPARE atm4a_pre FROM l_sql
   DECLARE amt4a_cs CURSOR FOR atm4a_pre
   FOREACH amt4a_cs INTO l_rvv39 ,l_rvu114,l_pmm42
      CASE
         WHEN l_pmm42 IS NOT NULL
             LET l_rvv39  = l_rvv39  * l_pmm42
         WHEN l_rvu114 IS NOT NULL
             LET l_rvv39  = l_rvv39  * l_rvu114
         OTHERWISE
             LET l_rvv39  = l_rvv39  * 1
      END CASE
      IF cl_null(l_rvv39) THEN LET l_rvv39=0 END IF #TQC-BC0137 add
      LET l_rvv39_s = l_rvv39_s + l_rvv39 
   END FOREACH
   IF cl_null(l_rvv39_s) THEN LET l_rvv39_s = 0 END IF   

  
   SELECT sfb28,sfb38 INTO l_sfb28,l_sfb38 
     FROM sfb_file 
    WHERE sfb01 = p_tlf62

   LET l_rvv39_s = -1*l_rvv39_s 
   #IF l_sfb28='3' AND l_sfb38 <= g_edate THEN   #141013jiangxt mark
   IF l_sfb28='3' AND l_sfb38 < g_edate THEN     #141013jiangxt
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM ccb_file 
       WHERE ccb01 = g_ima01
         AND ccb02 = yy
         AND ccb03 = mm
         AND ccb04 = p_tlf905
         AND ccb06 = type
         AND ccb07 = g_tlfcost
      IF l_cnt = 0 THEN   
         INSERT INTO ccb_file(ccb01,ccb02,ccb03,ccb04,ccb05,ccb06,ccb07, 
                                ccb22,ccb22a,ccb22b,ccb22c,ccb22d,ccb22e,
                                ccbacti,ccbuser,ccbgrup,ccbmodu,ccbdate,ccblegal,ccboriu,ccborig,ccb23)  
          VALUES(g_ima01,yy,mm,p_tlf905,'',type,g_tlfcost,
                 l_rvv39_s,0,0,0,l_rvv39_s,0,
                 'Y',g_user,g_grup,'',g_today,g_legal, g_user, g_grup,'4')                       
      END IF
   END IF 
END FUNCTION 
#FUN-D60130 add-----------------end
