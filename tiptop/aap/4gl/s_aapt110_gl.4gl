# Prog. Version..: '5.30.07-13.06.06(00010)'     #
#
# Modify.........: NO.MOD-490217 04/09/10 by Yiting 料號欄位放大
# Modify ........: No.FUN-4B0079 04/11/30 By ching 單價,金額改成 DEC(20,6)
# Modify ........: No.MOD-530051 05/03/09 By kitty npq07f的金額有誤
# Modify ........: No.MOD-530420 05/03/31 By Nicola 借方科目為"STOCK"時，不取單身科目
# Modify ........: No.MOD-530463 05/03/31 By Nicola 借方科目為"UNAP"時，科目產生錯誤
# Modify ........: No.FUN-530041 05/06/01 By Smapmin 判斷分錄是否已存在
# Modify ........: No.MOD-560035 05/06/16 By ching  直接付款npq24,npq25給值
# Modify ........: No.MOD-570247 05/08/24 By Nicola npq21值修改
# Modify ........: No.FUN-580012 05/09/02 By Elva 新增紅衝功能
# Modify ........: No.MOD-580365 05/09/01 By Carrier add DIFF內容
# Modify.........: No.MOD-5B0213 05/11/23 By Smapmin 確認會產生待抵資料,分錄產生的參考單號要是待抵編號.
# Modify.........: No.MOD-5A0274 05/11/24 By Smapmin 判斷科目是否做異動碼控管
# Modify.........: No.TQC-5B0018 05/12/06 By Smapmin 分錄傳票摘要欄位當發票編號編號為"MISC"時,摘要請抓 "廠商+帳款編號"
# Modify.........: FUN-5C0015 05/12/20 BY GILL (1)多Update 異動碼5~10, 關係人
#                  (2)若該科目有設彈性異動碼(agli120),則default帶出
#                     彈性異動碼的設定值(call s_def_npq: 抓取異動碼default值)
# Modify.........: No.TQC-610108 06/03/02 By Smapmin 應將入庫與退貨一併產生到aapt110的單身
# Modify.........: No.TQC-630017 06/03/15 By Smapmin 單身科目空白時,單頭借方科目不可空白
# Modify.........: No.MOD-630111 06/03/31 By Smapmin 單別取位
# Modify.........: No.TQC-630188 06/04/09 By Smapmin 11類別,單身金額可以輸入負數
# Modify.........: No.MOD-630131 06/04/09 By Smapmin 12or15類別,未輸入單身時,單身合計金額等於單頭金額
# Modify.........: No.MOD-640262 06/04/11 By Smapmin 若有使用沖帳功能時,產生分錄時，應付帳款科目及兌換利益科目沒有塞入幣別及匯率資料
# Modify.........: No.FUN-660122 06/06/16 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-660117 06/06/21 By Rainy Char改為 Like
# Modify.........: No.MOD-660117 06/06/28 By Smapmin aapt210貸方科目為空白時,抓取單身科目
# Modify.........: No.FUN-670064 06/07/18 By kim GP3.5 利潤中心
# Modify.........: No.MOD-680030 06/08/07 By Smapmin 匯損會科有誤
# Modify.........: No.FUN-680029 06/08/16 By Rayven 新增參數:分錄底稿類型
# Modify.........: No.FUN-690028 06/09/12 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-690080 06/09/29 By ice 零用金管理
# Modify.........: No.MOD-6B0043 06/11/08 By Smapmin 沖帳金額的幣別匯率有誤
# Modify.........: No.MOD-680029 06/11/15 By Smapmin 修改幣別取位
# Modify.........: No.MOD-690079 06/11/15 By Smapmin 未抓取分錄底稿彈性摘要設定
# Modify.........: No.FUN-680110 06/11/22 By Sarah 當aapt110單身有沖暫估也有非沖暫估的資料時,產生出來的分錄有錯
# Modify.........: No.MOD-6B0088 06/12/07 By Smapmin 12類,借方為STOCK時,科目一律抓取ima39
# Modify.........: No.MOD-6B0036 06/12/07 By Smapmin 恢復TQC-610108的程式段
# Modify.........: No.MOD-680083 06/12/08 By Smapmin 延續TQC-630017做修正
# Modify.........: No.FUN-710014 07/01/16 By Carrier 錯誤訊息匯整
# Modify.........: No.MOD-730061 07/03/19 By Smapmin 關係人代碼已改為npq37
# Modify.........: No.FUN-730064 07/04/03 By bnlent 會計科目加帳套
# Modify.........: No.MOD-740489 07/05/08 By Sarah 沖暫估與本月入庫合併廠商產生時,分錄產生錯誤
# Modify.........: No.MOD-750025 07/05/15 By Smapmin 修改變數名稱
# Modify.........: No.MOD-750132 07/05/30 By Smapmin 調整關係人異動碼相關程式段
# Modify.........: No.CHI-760007 07/06/13 By Smapmin 增加預設關係人異動碼功能
# Modify.........: No.TQC-790128 07/09/26 By Judy 零用金報銷時如果單頭科目空白，單身多科目，
#                                                 多部門的時候，分錄底稿的部門不應該取單頭部門
# Modify.........: No.MOD-7A0069 07/10/15 By Sarah 當應付帳款單身資料有充暫估倉退資料時，產生的分錄會借貸不平
# Modify.........: No.MOD-7A0129 07/10/23 By Judy aag05='N'時,部門應為空白
# Modify.........: No.MOD-7A0173 07/10/26 By Smapmin 2*類的異動碼無法帶出預設值
# Modify.........: No.MOD-7A0204 07/11/01 By Smapmin 分錄中所沖銷的預付科目參考單號應為預付的待抵單號
# Modify.........: No.MOD-7B0049 07/11/12 By Smapmin 新增至分錄時,摘要要先清空再預設.
# Modify.........: No.TQC-7B0083 07/11/28 By Carrier 加入衝暫估內容
# Modify.........: No.TQC-7C0134 07/12/10 By Rayven 1.當為零用金時應該抓取apb33報銷明細說明，而不是apb27品名，否則單身會抓不到摘要，導致分錄底稿合并
#                                                   2.當報銷金額為0，為衝借款時即使單身為空，單頭借方科目不維護也允許生成分錄底稿
# Modify.........: No.TQC-7C0149 07/12/18 By Carrier 暫估資料分錄幣種取立暫估幣種
# Modify.........: No.FUN-810045 08/03/06 By Rainy  項目管理:WBS編碼放入異動碼9，費用原因(apb31)放入異動碼10
# Modify.........: No.MOD-830233 08/03/31 By Smapmin 摘要的預設值先依apz43的設定為主
# Modify.........: No.FUN-830161 08/04/16 By Carrier 項目預算修改
# Modify.........: No.MOD-840187 08/04/20 By Sarah 摘要沒依apz43產生
# Modify.........: No.MOD-840520 08/04/23 By Carrier 銀行付款時分錄幣種用立帳幣種和匯率
# Modify.........: No.MOD-860011 08/06/09 By Sarah 當apa51為MISC or UNAP時,CALL s_def_npq()改CALL s_def_npq5()
# Modify.........: No.MOD-890093 08/09/11 By Sarah 產生Pre-Paid段,當apz13='Y'且m_apa22為NULL時,增加判斷當l_npq.npq04='DIFF',直接以l_apa.apa22部門取得m_aps.*
# Modify.........: No.CHI-830037 08/10/16 By jan 將目前財務架構中使用關系人的地方,請統一使用"代碼",而非"簡稱"
# Modify.........: No.MOD-8B0092 08/11/10 By Sarah 當apa51/apa511為NULL時,npq05應抓單身的apb930
# Modify.........: No.MOD-8C0010 08/12/09 By Sarah 若單別設定為紅沖,aapt210單身科目輸入科目時應將此科目產生到借方
# Modify.........: No.MOD-8C0067 08/12/15 By Sarah 單身的科目若有做部門管理,產生分錄時npq05應抓單身的部門
# Modify.........: No.MOD-920060 09/02/06 By Sarah t110_gl_c4 CURSOR多抓apb25,判斷當單頭借方科目為空時,l_actno就等於單身apb25,否則就依原邏輯抓取
# Modify.........: No.MOD-920100 09/02/07 By Sarah 判斷aag23='Y'才寫入npq08
# Modify.........: No.MOD-930244 09/03/24 By Sarah 分錄資料來源若為api_file,需判斷是否有做重評價,若有先LET npq25=oox07,抓不到才LET npq25=api05/api05f
# Modify.........: No.MOD-940088 09/04/08 By lilingyu 產生異動碼后,沒有檢查其合法性,須再以call s_chk_aee來做檢查,若檢查不過則異動碼為空白
# Modify.........: No.MOD-940212 09/04/15 By lilingyu未考慮多次重評之情況時,要抓最近一次之重評匯率
# Modify.........: No.MOD-950096 09/05/12 By lilingyu 判斷當科目有做預算管理時,才需將費用原因寫入npq36
# Modify.........: No.MOD-950269 09/06/01 By Sarah t110_stock()段,FOREACH一進去需先清空l_actno,才會針對每一筆單身資料重新抓取STOCK科目
# Modify.........: No.MOD-960127 09/06/09 By Sarah t110_stock()段,大陸版紅沖單據應產生借方金額為負數的分錄
# Modify.........: No.MOD-960350 09/06/30 By Sarah 修正MOD-960127,多判斷單別為紅沖
# Modify.........: No.MOD-970273 09/07/30 By mike 目前會先判斷aph03 = "1"時,才為再判斷apz44來決定如何帶出摘要,請改為aph03="1" OR aph
# Modify.........: No.FUN-980001 09/08/10 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.MOD-980028 09/08/05 By Sarah 修正MOD-920060,直接抓單身科目來產生分錄,若單身科目是空的,那就照原先STOCK抓取科目的方式來產生分錄
# Modify.........: No.MOD-980030 09/08/05 By Sarah 沖暫估的請款作業,單頭借方會科與單身會科空白時也應可產生分錄底稿
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-9B0135 09/11/18 By Carrier aapt120单头借方科目为STOCK时,分录二的借方科目取得是apb25,并不是apb251
# Modify.........: No.MOD-9B0130 09/11/19 By Dido 新增借方時增加判斷若 npq06 變數為null 則預設為 1  
# Modify.........: No:MOD-9B0131 09/11/19 By Sarah 檢查aap-410段前增加判斷,當有沖暫估資料時就不卡關
# Modify.........: No:TQC-9B0197 09/11/24 By Sarah 借方科目STOCK時,單身異動類別若輸入空白,npq06不會帶出來
# Modify.........: No.FUN-9C0041 09/12/10 By lutingting t110_stock_act加傳參數營運中心,實現可跨庫抓取科目得功能 
# Modify.........: No.FUN-9C0072 09/12/16 By vealxu 精簡程式碼
# Modify.........: No:MOD-9C0112 09/12/18 By wujie 分錄底稿未帶出部門
# Modify.........: No.FUN-9C0001 09/12/24 By lutingting 加傳參數營運中心
# Modify.........: No.FUN-A30077 10/03/29 By Carrier 按余额类型产生分录aag24='Y'时,分录方向要按设定来处理
# Modify.........: No.FUN-A50102 10/06/02 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.MOD-A60160 10/06/25 By Dido 當重評無資料時,直接抓取原本立暫估匯率 
# Modify.........: No:CHI-A60012 10/06/30 By Summer 增加判斷若此應付為0時,應可產生借貸相同的的會計金額
# Modify.........: No.MOD-A70057 10/07/07 By Dido aapt210 預設 npq23 參考單號為 apa01 
# Modify.........: No.FUN-9A0036 10/07/27 By chenmoyan 勾選二套帳，分錄底稿二的匯率及本幣金額，應依帳別二進行換算
# Modify.........: No.FUN-A40033 10/07/27 By chenmoyan 二套帳時如果第二套帳幣別和本幣不相同，借貸不平衡產生匯損益時要切立科目
# Modify.........: No.FUN-A40067 10/07/27 By chenmoyan 處理二套帳中本幣金額取位
# Modify.........: No.FUN-950053 10/08/18 By vealxu 廠商基本資料的關係人設定搭配異動碼彈性設定
# Modify.........: No.MOD-A20047 10/10/05 By sabrina 將npq37的值移到CALL s_def_npq()後面
# Modify.........: No.CHI-A30003 10/10/19 By sabrina 若aag23='Y'時，npq08/npq35才需設定
# Modify.........: No:MOD-AB0195 10/11/19 By Dido temp table name 調整 
# Modify.........: No:TQC-AB0069 10/11/22 By yinhy 不勾選單項分錄時，應該不能出現負數
# Modify.........: No:MOD-AC0021 10/12/02 By Dido temp table 語法調整
# Modify.........: No:MOD-AC0049 10/12/07 By Dido 取消 npq25 取位 
# Modify.........: No:FUN-AC0001 11/12/07 By wujie npq05,npq08,npq35如果为null，给' '
# Modify.........: No:TQC-B10104 11/01/12 By Dido 產生 api_file 的 DIFF 匯兌分錄 
# Modify.........: No:MOD-B10093 11/01/13 By Dido 匯率需區分多借方與沖暫估之差異 
# Modify.........: No:FUN-AA0087 11/01/27 By Mengxw 異動碼類型的設定改善
# Modify.........: No:MOD-B30065 11/03/09 By Dido 沖漲時,npq21/npq22應為實際交易對象 
# Modify.........: No:MOD-B30089 11/03/10 By Sarah 產生分錄前要先清空npq05變數
# Modify.........: No:MOD-B40045 11/04/13 By Dido 沖帳如需重評,匯率抓取調整 
# Modify.........: No:MOD-B40087 11/04/18 By Dido 沖暫估 DIFF 科目以 api04 為主 
# Modify.........: No:MOD-B40233 11/04/26 By Dido 沖暫估 DIFF 原幣金額不可為 0,應為原值
# Modify.........: No:FUN-B40056 11/05/13 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料
# Modify.........: No:MOD-B70140 11/07/14 By Sarah 沖暫估 DIFF 匯率會是空的
# Modify.........: No:TQC-B80204 11/09/01 By guoch 科目二的币种和本币种一致时，分录中的数据和单子中的数据不一致的bug
# Modify.........: No:MOD-BA0042 11/10/06 By Dido 紅沖分錄借貸方與立帳相同金額呈現負數 
# Modify.........: No:MOD-BB0069 11/11/06 By Dido 若直接付款匯率與帳款不同時,應付帳款的原幣應與本幣相同 
# Modify.........: No:MOD-BB0100 11/11/08 By yinhy 產生MISC的稅額時，重複抓了apk的稅額
# Modify.........: No:MOD-BC0264 11/12/27 By yinhy 透過批處理作業拋轉時，核算項未依據agli120設置自動帶出
# Modify.........: No:MOD-C20009 12/02/03 By Dido STOCK 科目關係人抓取有誤 
# Modify.........: No:TQC-C20214 12/02/15 By Dido 語法調整 SELECT FIRST 改為 SELECT MIN 
# Modify.........: No:MOD-C30056 12/03/07 By Polly 在做完核算部份後需再將g_prog還原
# Modify.........: No:MOD-C40189 12/04/24 By yinhy 折讓類型分錄底稿摘要欄位借方科目摘要更改
# Modify.........: No.MOD-C50236 12/05/30 By yinhy 當apa51/apa511為NULL時,npq21應抓單身的apb32
# Modify.........: No.MOD-C80065 12/08/28 By Elise 取消 npq04 抓取
# Modify.........: No.MOD-C80028 12/09/28 By wangwei 退貨折讓作業若有差異分錄底稿產生錯誤
# Modify.........: No.MOD-CC0237 12/12/25 By Polly 大陸版紅沖單別時，當金額為負數時借貸方需要轉換
# Modify.........: No.MOD-CC0253 12/12/26 By Polly 抓取單身彈性摘要調整
# Modify.........: No.CHI-CC0022 13/01/22 By Polly 調整彃性摘要抓取設定
# Modify.........: No.MOD-D10289 13/02/01 By Polly 調整大陸版21類型分錄底稿調整
# Modify.........: No.MOD-D20101 13/02/20 By Polly 調整分錄摘要無法正常抓取問題
# Modify.........: No.FUN-D10065 13/03/07 By minpp 所有npq04的给值统一放在s_def_npq3（s_def_npq,s_def_npq5等）的后面
#                                                 判断若npq04 为空.则依原给值方式给值（9主机追单)
# Modify.........: No.MOD-D40069 13/04/11 By Lori t110_papb02_01照t110_gl_p41的GROUP BY為條件,判斷 g_aptype <> 13 時增加apb27條件,否則則組apb33,條件變數一律使用l_npq04
# Modify.........: No.MOD-D40097 13/04/15 By Lori 1.產生分錄段 s_aapt110_gl 中,判斷 apa33 <> 0 時,若為 aapt210 程式時,則將借貸相反;折讓差異處理則不做此段
#                                                 2.after field apb22 時,若退貨單數量(rvv17) > 0 時, apa58 不可為 3,應為 2 才對
# Modify.........: No.FUN-D40089 13/04/23 By lujh 批次審核的報錯,加show單據編號
# Modify.........: No.FUN-D40118 13/05/20 By zhangweib 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空
# Modify.........: No.CHI-D50043 13/05/30 By Polly 調整已拋轉總帳後不可重新產生分錄的控卡條件
# Modify.........: No.MOD-D50287 13/06/03 By Lori FOREACH t110_gl_c3處理aag05段將LET l_npq.npq05 = l_apa.apa22改為LET l_npq.npq05 = m_apa2
# Modify.........: No.FUN-D70028 13/07/08 By zhangweib 新增aapt140程序,產生分錄底稿時,沖帳資料抓取oov_file資料
# Modify.........: No.FUN-D80031 13/08/13 By yuhuabao aapt140調整npq21 npq22的取值方式為apb26
# Modify.........: No.FUN-D80049 13/08/16 By yuhuabao oov_file資料涵蓋10.帳扣和23.預付待抵 故aapt140分錄產生調整
# Modify.........: No.yinhy131015 13/10/15 By yinhy 增加apb33 IS NULL的条件
# Modify.........: No.yinhy131114 13/11/14 By yinhy 2類型紅沖分錄產生錯誤
# Modify.........: No:CHI-E30030 14/03/20 By yihsuan 將api40給 1
# Modify.........: 201104  20/11/04 by lifang 参照aapt330为D:票据转付时的科目取值逻辑

DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE g_ccz07          LIKE ccz_file.ccz01    #FUN-660117 #CHAR(1)
DEFINE l_npp            RECORD LIKE npp_file.*
DEFINE l_npq            RECORD LIKE npq_file.*
DEFINE g_chr            LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
DEFINE g_msg            LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(72)
DEFINE g_sql            LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(1000)
DEFINE l_sql            LIKE type_file.chr1000 #MOD-920100 add
DEFINE g_apydmy6        LIKE apy_file.apydmy6  #FUN-580012
DEFINE g_aptype         LIKE apa_file.apa00    #MOD-6B0088
DEFINE g_flag           LIKE type_file.chr1    #No.FUN-730064
DEFINE g_bookno         LIKE aza_file.aza81    #No.FUN-730064
DEFINE g_bookno1        LIKE aza_file.aza81    #No.FUN-730064
DEFINE g_bookno2        LIKE aza_file.aza82    #No.FUN-730064
DEFINE g_bookno3        LIKE aza_file.aza82    #No.FUN-D40118   Add
DEFINE l_npq24_o        LIKE npq_file.npq24    #No.TQC-7C0149
DEFINE l_npq25_o        LIKE npq_file.npq25    #No.TQC-7C0149
DEFINE ms_dbs           LIKE type_file.chr21   #FUN-9C0001
DEFINE ms_plant         LIKE azp_file.azp01    #FUN-9C0001
DEFINE g_npq25_1        LIKE npq_file.npq25    #No.FUN-9A0036
DEFINE g_azi04_2        LIKE azi_file.azi04    #FUN-A40067
 
FUNCTION t110_g_gl(p_aptype,p_apno,p_npptype,p_plant)  #No.FUN-680029 新增p_npptype   #FUN-9C0001 add p_plant
   DEFINE p_aptype	LIKE apa_file.apa00
   DEFINE p_apno	LIKE apa_file.apa01
   DEFINE p_npptype     LIKE npp_file.npptype  #No.FUN-680029
   DEFINE l_buf		LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(70)
   DEFINE l_n  		LIKE type_file.num5    #No.FUN-690028 SMALLINT
   DEFINE l_t1 		LIKE apy_file.apyslip  # No.FUN-690028 VARCHAR(5)     #FUN-580012
   DEFINE l_apa57       LIKE apa_file.apa57    #TQC-630188
   DEFINE l_apa51       LIKE apa_file.apa51    #TQC-630188
   DEFINE l_apa511      LIKE apa_file.apa511   #No.FUN-680029
   DEFINE l_cnt         LIKE type_file.num5    #MOD-9B0131 add
   DEFINE p_plant       LIKE azp_file.azp01    #FUN-9C0001 
   DEFINE l_apb24_1     LIKE apb_file.apb24   #CHI-A60012 add
   DEFINE l_apb24_3     LIKE apb_file.apb24   #CHI-A60012 add
   DEFINE l_apb29_1     LIKE apb_file.apb29   #CHI-A60012 add
   DEFINE l_apb29_3     LIKE apb_file.apb29   #CHI-A60012 add
   DEFINE l_13          LIKE type_file.chr1   #CHI-A60012 add 
   DEFINE l_apa02       LIKE apa_file.apa02   #No.TQC-B70021

   WHENEVER ERROR CALL cl_err_msg_log
 
   IF p_apno IS NULL THEN
      RETURN
   END IF
 
   #FUN-9C0001--add--str--
   IF cl_null(p_plant) THEN
      LET ms_dbs = NULL
   ELSE
      LET g_plant_new = p_plant
      CALL s_gettrandbs()
      LET ms_dbs = g_dbs_tra
   END IF 
   LET ms_plant = p_plant
   #FUN-9C0001--add--end

   LET g_aptype = p_aptype   #MOD-6B0088

   #CHI-A60012 add --start--
   #同時存在入庫、倉退,且應付為0時,可產生借貸相同的的會計金額,不卡aap-410
   LET l_13='N' LET l_apb24_1 = 0  LET l_apb24_3 = 0
   SELECT SUM(apb24),apb29 INTO l_apb24_1,l_apb29_1 FROM apb_file
    WHERE apb01=p_apno AND (apb34 = 'N' OR apb34 IS NULL) AND apb29 ='1' GROUP BY apb29
   SELECT SUM(apb24),apb29 INTO l_apb24_3,l_apb29_3 FROM apb_file
    WHERE apb01=p_apno AND (apb34 = 'N' OR apb34 IS NULL) AND apb29 ='3' GROUP BY apb29  
   IF cl_null(l_apb24_1) THEN LET l_apb24_1 = 0 END IF 
   IF cl_null(l_apb24_3) THEN LET l_apb24_3 = 0 END IF 
   IF l_apb29_1='1' AND l_apb29_3='3' AND l_apb24_1+l_apb24_3=0 THEN
      LET l_13 ='Y'
   END IF
   #CHI-A60012 add --end--
 
   IF p_aptype = '11' THEN
     #當有沖暫估資料時就不卡aap-410
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM api_file WHERE api01=p_apno
      IF l_cnt = 0 THEN
         IF p_npptype = '0' THEN  #No.FUN-680029
            LET l_apa51 = ''
            SELECT apa51 INTO l_apa51 FROM apa_file
              WHERE apa01 = p_apno
            LET l_apa57 = 0
            SELECT apa57 INTO l_apa57 FROM apa_file
              WHERE apa01 = p_apno
            IF (cl_null(l_apa51) OR l_apa51 = 'STOCK')  AND
              #(l_apa57 = 0 OR cl_null(l_apa57)) THEN  #CHI-A60012 mark
               ((l_apa57 = 0 OR cl_null(l_apa57)) AND l_13='N') THEN  #CHI-A60012
                DELETE FROM npp_file
                 WHERE nppsys = 'AP'
                   AND npp00 = 1
                   AND npp01  = p_apno
                   AND npp011 = 1
                   AND npptype = p_npptype  #No.FUN-680029
    
                DELETE FROM npq_file
                 WHERE npqsys = 'AP'
                   AND npq00 = 1
                   AND npq01  = p_apno
                   AND npq011 = 1
                   AND npqtype = p_npptype                  #No.FUN-710014

                DELETE FROM tic_file WHERE tic04 = p_apno   #FUN-B40056
   
               IF g_bgerr THEN
                  LET g_showmsg="AP","/","1","/",p_apno,"/","1","/",p_npptype
                  CALL s_errmsg("npqsys,npq00,npq01,npq011,npqtype",g_showmsg,"","aap-410",0)
               ELSE
                  CALL cl_err('','aap-410',0)
               END IF
               RETURN
            END IF
         ELSE
            LET l_apa511 = ''
            SELECT apa511 INTO l_apa511 FROM apa_file
              WHERE apa01 = p_apno
            LET l_apa57 = 0
            SELECT apa57 INTO l_apa57 FROM apa_file
              WHERE apa01 = p_apno
            IF (cl_null(l_apa511) OR l_apa511 = 'STOCK')  AND
              #(l_apa57 = 0 OR cl_null(l_apa57)) THEN  #CHI-A60012 mark
               ((l_apa57 = 0 OR cl_null(l_apa57)) AND l_13='N') THEN  #CHI-A60012
                DELETE FROM npp_file
                 WHERE nppsys = 'AP'
                   AND npp00 = 1
                   AND npp01  = p_apno
                   AND npp011 = 1
                   AND npptype = p_npptype  #No.FUN-680029
    
                DELETE FROM npq_file
                 WHERE npqsys = 'AP'
                   AND npq00 = 1
                   AND npq01  = p_apno
                   AND npq011 = 1
                   AND npqtype = p_npptype                  #No.FUN-710014
                DELETE FROM tic_file WHERE tic04 = p_apno   #FUN-B40056
   
               IF g_bgerr THEN
                  LET g_showmsg="AP","/","1","/",p_apno,"/","1","/",p_npptype
                  CALL s_errmsg("npqsys,npq00,npq01,npq011,npqtype",g_showmsg,"","aap-410",0)      
               ELSE
                  CALL cl_err('','aap-410',0)
               END IF
               RETURN
            END IF
         END IF
      END IF   #MOD-9B0131 add
   END IF
 
 
   #modify by danny 97/05/15 若已拋轉總帳, 不可重新產生分錄底稿
   SELECT COUNT(*) INTO l_n FROM npp_file 
    WHERE npp01 = p_apno
     #AND nppglno != ''                 #CHI-D50043 mark
      AND nppglno IS NOT NULL
      AND nppsys = 'AP'
      AND npp00 = 1
      AND npp011 = 1
      AND npptype = p_npptype  #No.FUN-680029 
   IF l_n > 0 THEN 
      IF g_bgerr THEN
         LET g_showmsg=p_apno,"/","AP","/","1","/","1","/",p_npptype
         CALL s_errmsg("npp01,nppsys,npp00,npp011,npptype",g_showmsg,"","aap-122",0)
      ELSE
         CALL cl_err(p_apno,'aap-122',1)
      END IF
      RETURN 
   END IF
   IF p_npptype = '0' THEN
      SELECT COUNT(*) INTO l_n FROM npq_file
       WHERE npqsys = 'AP'
         AND npq00 = 1
         AND npq01  = p_apno
         AND npq011 = 1
      IF l_n > 0 THEN
         IF NOT s_ask_entry(p_apno) THEN  #Genero
            RETURN
         END IF
      END IF
   END IF  #No.FUN-680029
 
   DELETE FROM npp_file 
    WHERE nppsys = 'AP'
      AND npp00 = 1
      AND npp01  = p_apno
      AND npp011 = 1 
      AND npptype = p_npptype  #No.FUN-680029
 
   DELETE FROM npq_file
    WHERE npqsys = 'AP'
      AND npq00 = 1
      AND npq01  = p_apno
      AND npq011 = 1 
      AND npqtype = p_npptype  #No.FUN-680029

   DELETE FROM tic_file WHERE tic04 = p_apno   #FUN-B40056
 
   LET l_t1 = s_get_doc_no(p_apno)                                         
   SELECT apydmy6 INTO g_apydmy6 FROM apy_file WHERE apyslip = l_t1         
   IF p_aptype[1,1] = '1' OR (g_aza.aza26='2' AND g_apydmy6='Y') THEN
      CALL t110_g_gl_1(p_aptype,p_apno,p_npptype) #No.FUN-680029 新增p_npptype
   ELSE
      CALL t110_g_gl_2(p_aptype,p_apno,p_npptype) #No.FUN-680029 新增p_npptype
   END IF
   CALL t110_gen_diff()    #FUN-A40033 
#No.TQC-B70021 --begin 
   SELECT apa02 INTO l_apa02 
     FROM apa_file 
    WHERE apa00 = p_aptype
      AND apa01 = p_apno
   CALL s_flows('3',p_aptype,p_apno,l_apa02,'N',p_npptype,TRUE)    
#No.TQC-B70021 --end
   CALL cl_getmsg('aap-055',g_lang) RETURNING g_msg
   MESSAGE g_msg CLIPPED
 
END FUNCTION
 
FUNCTION t110_g_gl_1(p_aptype,p_apno,p_npptype) #No.FUN-680029 新增p_npptype
   DEFINE p_aptype	LIKE apa_file.apa00
   DEFINE p_apno	LIKE apa_file.apa01
   DEFINE p_npptype     LIKE npp_file.npptype   #No.FUN-680029
   DEFINE l_amt		LIKE apb_file.apb24     #FUN-4B0079
   DEFINE l_amt_f	LIKE apb_file.apb24
   DEFINE l_actno       LIKE apa_file.apa51     # No.FUN-690028 VARCHAR(20)
   DEFINE l_actno2	LIKE apa_file.apa51     # No.FUN-690028 VARCHAR(20)
   DEFINE l_aag371      LIKE aag_file.aag371    #No:9189   #MOD-750132
   DEFINE amt1,amt2	LIKE npq_file.npq07     #FUN-4B0079
   DEFINE amt3,amt4	LIKE npq_file.npq07f    #MOD-530051
   DEFINE l_apa06       LIKE apa_file.apa06     #No:7871
   DEFINE l_aag05       LIKE aag_file.aag05
   DEFINE l_aag21       LIKE aag_file.aag21
   DEFINE l_aag23       LIKE aag_file.aag23
   DEFINE l_apa		RECORD LIKE apa_file.*
   DEFINE l_aph		RECORD LIKE aph_file.*
   DEFINE l_api		RECORD LIKE api_file.*
   DEFINE l_apb		RECORD LIKE apb_file.*   #FUN-680110 add
   DEFINE l_apb29       LIKE apb_file.apb29
   DEFINE l_pmc03       LIKE pmc_file.pmc03 
   DEFINE l_pmc903      LIKE pmc_file.pmc903
   DEFINE m_aps         RECORD LIKE aps_file.* #No.MOD-580365
   DEFINE m_apa22       LIKE apa_file.apa22    #No.MOD-580365
   DEFINE l_apydmy4     LIKE apy_file.apydmy4  #MOD-5B0213
   DEFINE l_apyslip     LIKE apy_file.apyslip  #MOD-5B0213
   DEFINE l_apa01       LIKE apa_file.apa01    #MOD-5B0213
   DEFINE l_cnt         LIKE type_file.num5    #No.FUN-690028 SMALLINT
   DEFINE l_cnt1        LIKE type_file.num5    #No.TQC-7B0083
   DEFINE l_apb25       LIKE apb_file.apb25
   DEFINE l_apb251      LIKE apb_file.apb251   #No.FUN-680029
   DEFINE l_apa22       LIKE apa_file.apa22
   DEFINE l_apa36       LIKE apa_file.apa36
   DEFINE l_api05       LIKE api_file.api05    #No.TQC-7B0083
   DEFINE l_api05f      LIKE api_file.api05f   #No.TQC-7B0083
   DEFINE l_npq04       LIKE npq_file.npq04    #CHI-CC0022 add
   DEFINE l_npq07       LIKE npq_file.npq07    #FUN-680110 add
   DEFINE l_npq07f      LIKE npq_file.npq07f   #FUN-680110 add
   DEFINE o_npq07       LIKE npq_file.npq07    #FUN-680110 add
   DEFINE o_npq07f      LIKE npq_file.npq07f   #FUN-680110 add
   DEFINE l_apb31       LIKE apb_file.apb31    #費用原因  #FUN-810045
   DEFINE l_apb35       LIKE apb_file.apb35    #專案      #FUN-810045
   DEFINE l_apb36       LIKE apb_file.apb36    #wbs       #FUN-810045
   DEFINE g_npq24       LIKE npq_file.npq24    #No.MOD-840520
   DEFINE g_npq25       LIKE npq_file.npq25    #No.MOD-840520
   DEFINE l_azi03       LIKE azi_file.azi03    #MOD-930244 add
   DEFINE l_apb930      LIKE apb_file.apb930   #MOD-8B0092 add
   DEFINE l_apb32       LIKE apb_file.apb32    #MOD-C50236 add
   DEFINE l_sql         STRING
   DEFINE l_count       LIKE type_file.num5
   DEFINE l_oox07   DYNAMIC ARRAY OF RECORD 
                 oox07  LIKE oox_file.oox07
                    END RECORD 
   DEFINE l_apb02       LIKE apb_file.apb02   #MOD-CC0253 add
   DEFINE l_apb24_1     LIKE apb_file.apb24   #CHI-A60012 add
   DEFINE l_apb24_3     LIKE apb_file.apb24   #CHI-A60012 add
   DEFINE l_apb26       LIKE apb_file.apb26   #CHI-CC0022 add
   DEFINE l_apb29_1     LIKE apb_file.apb29   #CHI-A60012 add
   DEFINE l_apb29_3     LIKE apb_file.apb29   #CHI-A60012 add
   DEFINE l_aaa03       LIKE aaa_file.aaa03   #FUN-A40067
   DEFINE p_prog        LIKE type_file.chr20  #MOD-C30056 add
   DEFINE l_aag44       LIKE aag_file.aag44   #No.FUN-D40118   Add
   DEFINE l_flag        LIKE type_file.chr1   #No.FUN-D40118   Add
	DEFINE l_apb12       LIKE apb_file.apb12
	DEFINE l_apb24       LIKE apb_file.apb24 
	DEFINE l_apb10       LIKE apb_file.apb10
   LET g_bookno3 = Null   #No.FUN-D40118   Add
 
   SELECT * INTO l_apa.* FROM apa_file WHERE apa01 = p_apno
   LET l_npq07=0  LET l_npq07f=0    #FUN-680110 add
   LET o_npq07=0  LET o_npq07f=0    #FUN-680110 add
   IF STATUS THEN RETURN END IF
   LET g_npq24 = l_apa.apa13
   LET g_npq25 = l_apa.apa14
   CALL s_get_bookno(YEAR(l_apa.apa02)) 
        RETURNING g_flag,g_bookno1,g_bookno2
   IF g_flag = '1' THEN
      #CALL cl_err(l_apa.apa02,'aoo-081',1)                       #FUN-D40089 mark
      CALL s_errmsg('','l_apa.apa02','l_apa.apa01','aoo-081',1)   #FUN-D40089 add
   END IF
   IF p_npptype = '0' THEN
      LET g_bookno = g_bookno1
   ELSE 
      LET g_bookno = g_bookno2
   END IF
 
   IF l_apa.apa42 = 'Y' THEN
      IF g_bgerr THEN
         #CALL s_errmsg("apa42","Y","apa42=Y","aap-165",0)          #FUN-D40089 mark
         CALL s_errmsg("apa42","apa42=Y",l_apa.apa01,"aap-165",1)   #FUN-D40089 add
      ELSE
         CALL cl_err("apa42=Y",'aap-165',0) 
      END IF
      RETURN
   END IF
 
   IF l_apa.apa74 = 'Y' THEN
      IF g_bgerr THEN
         #CALL s_errmsg("apa74","Y","apa74=Y","aap-333",0)          #FUN-D40089 mark
         CALL s_errmsg("apa74","apa74=Y",l_apa.apa01,"aap-333",1)   #FUN-D40089 add
      ELSE
         CALL cl_err('apa74=Y','aap-333',0)
      END IF
      RETURN 
   END IF
 
   IF p_npptype = '0' THEN  #No.FUN-680029
     #apa51為空時,檢查apb及api是否有資料,若無則報錯,不得產生
     IF cl_null(l_apa.apa51) THEN  #No.FUN-690080  #No.TQC-7B0083
         IF l_apa.apa31f <> 0 THEN #No.TQC-7C0134
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM apb_file WHERE apb01=p_apno
            IF l_cnt = 0 THEN
               SELECT COUNT(*) INTO l_cnt FROM api_file
                WHERE api01=p_apno AND api04 IS NOT NULL
               IF l_cnt = 0 THEN
                  IF g_bgerr THEN
                     CALL s_errmsg("apb01",p_apno,"","aap-805",0)
                  ELSE
                     CALL cl_err('','aap-805',0)
                  END IF
                  RETURN
               END IF
            ELSE     #MOD-980030 add
               DECLARE apb25_cs CURSOR FOR
                 SELECT apb25 FROM apb_file WHERE apb01=p_apno
               FOREACH apb25_cs INTO l_apb25
                  IF cl_null(l_apb25) THEN
                     CONTINUE FOREACH
                  ELSE
                     EXIT FOREACH
                  END IF
               END FOREACH
               SELECT COUNT(*) INTO l_cnt FROM api_file
                WHERE api01=p_apno AND api04 IS NOT NULL
               IF cl_null(l_apb25) AND l_cnt = 0 THEN   #MOD-980030
                  IF g_bgerr THEN
                     #CALL s_errmsg("apb25",l_apb25,"","aap-806",0)           #FUN-D40089 mark
                     CALL s_errmsg("apb25",l_apb25,l_apa.apa01,"aap-806",1)   #FUN-D40089 add
                  ELSE
                     CALL cl_err('','aap-806',0)
                  END IF
                  RETURN
               END IF
            END IF   #MOD-980030 add
         END IF #No.TQC-7C0134
      END IF
   ELSE
     IF cl_null(l_apa.apa511) THEN  #No.FUN-690080  #No.TQC-7B0083
         IF l_apa.apa31f <> 0 THEN #No.TQC-7C0134
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM apb_file WHERE apb01=p_apno
            IF l_cnt = 0 THEN
               SELECT COUNT(*) INTO l_cnt FROM api_file
                WHERE api01=p_apno AND api041 IS NOT NULL   #MOD-980030 mod
               IF l_cnt = 0 THEN
                  IF g_bgerr THEN
                     CALL s_errmsg("apb01",p_apno,"","aap-805",0)
                  ELSE
                     CALL cl_err('','aap-805',0)
                  END IF
                  RETURN
               END IF
            ELSE     #MOD-980030 add
               DECLARE apb251_cs CURSOR FOR
                 SELECT apb251 FROM apb_file WHERE apb01=p_apno
               FOREACH apb251_cs INTO l_apb251
                  IF cl_null(l_apb251) THEN
                     CONTINUE FOREACH
                  ELSE
                     EXIT FOREACH
                  END IF
               END FOREACH
               SELECT COUNT(*) INTO l_cnt FROM api_file
                WHERE api01=p_apno AND api041 IS NOT NULL
               IF cl_null(l_apb251) AND l_cnt = 0 THEN   #MOD-980030
                  IF g_bgerr THEN
                     #CALL s_errmsg("apb251",l_apb251,"","aap-806",0)     #FUN-D40089 mark
                     CALL s_errmsg("apb251",l_apb251,p_apno,"aap-806",0)  #FUN-D40089 add
                  ELSE
                     CALL cl_err('','aap-806',0)
                  END IF
                  RETURN
               END IF
            END IF   #MOD-980030 add
         END IF #No.TQC-7C0134
      END IF
   END IF
 
   INITIALIZE l_npp.* TO NULL
   INITIALIZE l_npq.* TO NULL
 
   LET l_npp.npptype = p_npptype  #No.FUN-680029
   LET l_npq.npqtype = p_npptype  #No.FUN-680029

  #No.FUN-D40118 ---Add--- Start
   IF l_npq.npqtype = '1' THEN
      LET g_bookno3 = g_bookno2
   ELSE
      LET g_bookno3 = g_bookno1
   END IF
  #No.FUN-D40118 ---Add--- End
 
   #-->單頭
   LET l_npp.nppsys = 'AP'
   LET l_npp.npp00 = 1
   LET l_npp.npp01 = l_apa.apa01 
   LET l_npp.npp011 = 1 
   LET l_npp.npp02 = l_apa.apa02
   LET l_npp.npp03 = NULL
   LET l_npp.npp05 = NULL
   LET l_npp.nppglno = NULL
 
   LET l_npp.npplegal = g_legal #FUN-980001 add
   INSERT INTO npp_file VALUES (l_npp.*)
   IF SQLCA.sqlcode THEN 
      IF g_bgerr THEN
         LET g_showmsg=l_npp.npp01,"/",l_npp.npp011,"/",l_npp.nppsys,"/",l_npp.npp00,"/",l_npp.npptype
         CALL s_errmsg("npp01,npp011,nppsys,npp00,npptype",g_showmsg,"insert npp_file",SQLCA.sqlcode,1)
      ELSE
         CALL cl_err3("ins","npp_file",l_npp.npp00,l_npp.npp01,SQLCA.sqlcode,"","insert npp_file",1)  #No.FUN-660122
      END IF
      LET g_success = 'N' 
   END IF
 
   #-->單身
   LET l_npq.npqsys = 'AP'
   LET l_npq.npq00 = 1
   LET l_npq.npq01 = l_apa.apa01 
   LET l_npq.npq011 = 1 
   LET l_npq.npq02 = 0  
   LET l_npq.npq21 = l_apa.apa06   #廠商編號
 LET l_apa01 = l_apa.apa01
 IF (p_aptype = '15' OR p_aptype = '17') THEN  #No.FUN-690080
    LET l_apyslip = s_get_doc_no(l_apa.apa01)   #MOD-630111
    SELECT apydmy4 INTO l_apydmy4 FROM apy_file
       WHERE apyslip=l_apyslip
    LET l_apa01[1,g_doc_len] = l_apydmy4   #MOD-630111
 END IF
   LET l_npq.npq23 = l_apa.apa01   #參考單號
   LET l_npq.npq24 = l_apa.apa13   #幣別
   LET l_npq.npq25 = l_apa.apa14   #匯率
   LET l_npq.npq22 = l_apa.apa07   #簡稱
   LET g_npq25_1=l_npq.npq25       #FUN-9A0036
 
   #-----------------------------------( Dr: Un-Invoice A/P )---------------------
   #--->MISC
   IF p_npptype = '0' THEN  #No.FUN-680029
      IF l_apa.apa51 = 'MISC' OR l_apa.apa51 = 'UNAP' THEN
         LET g_sql = " SELECT * FROM api_file ",
                     "  WHERE api01 = '",p_apno,"'",
                     "    AND (api04 IS NOT NULL AND api04 <> ' ')"
         PREPARE t110_gl_p1 FROM g_sql
         DECLARE t110_gl_c1 CURSOR FOR t110_gl_p1
         LET l_sql = "select oox07 from oox_file where oox00 = 'AP' ",
                     "   and oox03 = ? and oox041 = ? ",
                     "order by oox01 desc,oox02 desc"
         PREPARE t110_oox07 FROM l_sql
         DECLARE t110_oox07_cl CURSOR FOR t110_oox07
   
         LET l_npq24_o = l_npq.npq24  #No.TQC-7C0149
         LET l_npq25_o = l_npq.npq25  #No.TQC-7C0149
         FOREACH t110_gl_c1 INTO l_api.*
            IF STATUS THEN 
               EXIT FOREACH 
            END IF
   
            LET l_npq.npq02 = l_npq.npq02 + 1
            LET l_npq.npq03 = l_api.api04
           #LET l_npq.npq04 = l_api.api06          #FUN-D10065  mark
            LET l_npq.npq04 = NULL             #FUN-D10065  add
           #FUN-D10065---mark--str 
           #IF cl_null(l_npq.npq04) THEN
           #   LET l_npq.npq04 = l_apa.apa25
           #END IF
           #FUN-D10065---mark--end 
            IF NOT cl_null(l_api.api26) AND l_api.api26 <> 'DIFF' THEN
               SELECT apa13 INTO l_npq.npq24                    #MOD-930244
                 FROM apa_file
                WHERE apa01 = l_api.api26
               IF SQLCA.sqlcode THEN
                  LET l_npq.npq24 = l_npq24_o
               END IF
            END IF
            SELECT azi03 INTO l_azi03 FROM azi_file WHERE azi01 =l_npq.npq24
            IF cl_null(l_api.api05) THEN
               LET l_api.api05 =0
            END IF
            IF cl_null(l_api.api05f) THEN
               LET l_api.api05f =1
            END IF
            LET l_npq.npq25=''
            IF g_apz.apz27 = 'Y' THEN   #有做重評價
                    LET l_count = 1 
                    #FOREACH t110_oox07_cl USING l_api.api26,l_api.api40   #CHI-E30030 mark
                    FOREACH t110_oox07_cl USING l_api.api26,'1'           #CHI-E30030 add
                                          INTO l_oox07[l_count].*
                        IF STATUS THEN 
                           CALL cl_err('forach:',STATUS,1)
                           EXIT FOREACH
                        END IF         
                        LET l_npq.npq25 = l_oox07[l_count].oox07
                        LET l_count = l_count + 1
                        IF l_count = 2 THEN 
                           EXIT FOREACH 
                        END IF            
                    END FOREACH                                          
            END IF
            IF cl_null(l_npq.npq25) THEN
              #-MOD-B10093-add-
               IF l_api.api02 = '1' THEN  
                  LET l_npq.npq25 = l_apa.apa14   
               ELSE
              #-MOD-B10093-end-
                #str MOD-B70140 add
                 IF l_api.api26 = 'DIFF' THEN
                    LET l_npq.npq25 = 1
                 ELSE
                #end MOD-B70140 add
                 #-MOD-A60160-add-
                  SELECT apa14 INTO l_npq.npq25    
                    FROM apa_file
                   WHERE apa01 = l_api.api26
                 #-MOD-A60160-end-
                 END IF #MOD-B70140 add
               END IF                  #MOD-B10093
              #LET l_npq.npq25 =l_api.api05/l_api.api05f        #MOD-A60160 mark
              #LET l_npq.npq25 =cl_digcut(l_npq.npq25,l_azi03)  #MOD-AC0049 mark
            END IF
            LET g_npq25_1=l_npq.npq25       #FUN-9A0036
            LET l_npq.npq06 = '1'
            LET l_npq.npq07 = l_api.api05
            LET l_npq.npq07f= l_api.api05f
            LET l_aag05 = ' '
            LET l_aag21 = ' '
            LET l_aag23 = ' '
            LET l_aag371= ' '   #MOD-750132
   
            SELECT aag05,aag21,aag23,aag371 INTO l_aag05,l_aag21,l_aag23,l_aag371   #MOD-5A0274   #MOD-750132
              FROM aag_file
             WHERE aag01 = l_npq.npq03
               AND aag00 = g_bookno     #No.FUN-730064
   
            IF l_aag23 = 'Y' THEN
               LET l_npq.npq08 = l_api.api26    # 專案
               LET l_npq.npq35 = l_api.api35     #CHI-A30003 add
            ELSE
               LET l_npq.npq08 = NULL
               LET l_npq.npq35 = NULL            #CHI-A30003 add
            END IF
   
            LET o_npq07 = o_npq07 + l_npq.npq07    #FUN-680110 add   #MOD-7A0069 mod
            LET o_npq07f= o_npq07f+ l_npq.npq07f   #FUN-680110 add   #MOD-7A0069 mod
            IF l_npq.npq07 < 0 THEN
               LET l_npq.npq07 = l_npq.npq07 * -1
               LET l_npq.npq07f = l_npq.npq07f * -1
               IF l_npq.npq06 = '1' THEN 
                  LET l_npq.npq06 = '2'
               ELSE
                  LET l_npq.npq06 = '1'
               END IF
            END IF
   
            LET l_npq.npq05 = ''   #MOD-B30089 add
            IF l_aag05='Y' THEN
               IF g_aaz.aaz90='N' THEN
                  LET l_npq.npq05 = l_api.api07
               ELSE
                  LET l_npq.npq05 = l_api.api930   #MOD-8C0067
               END IF
            ELSE
               LET l_npq.npq05 = ''
            END IF
 
            LET l_npq.npq11 = l_api.api21
            LET l_npq.npq12 = l_api.api22
            LET l_npq.npq13 = l_api.api23
            LET l_npq.npq14 = l_api.api24
            LET l_npq.npq31 = l_api.api31
            LET l_npq.npq32 = l_api.api32
            LET l_npq.npq33 = l_api.api33
            LET l_npq.npq34 = l_api.api34
           #LET l_npq.npq35 = l_api.api35    #CHI-A30003 mark
            SELECT aag21 INTO l_aag21 FROM aag_file
             WHERE aag00 = g_bookno
               AND aag01 = l_npq.npq03               
            IF l_aag21 = 'Y' THEN             #MOD-950096 
               LET l_npq.npq36 = l_api.api36 
            END IF                            #MOD-950096    
           #LET l_npq.npq37 = l_api.api37     #MOD-A20047 mark
   
            IF l_npq.npq07 != 0 THEN 
               IF p_aptype[1,1] = '2' THEN
                  LET l_npq.npq07 = (-1)*l_npq.npq07                                  
                  LET l_npq.npq07f= (-1)*l_npq.npq07f 
               END IF
               CALL s_def_npq5(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno)   #No.FUN-730064  #MOD-860011
               RETURNING l_npq.*
               #FUN-D10065--add--str--
               IF cl_null(l_npq.npq04) THEN
                  LET l_npq.npq04 = l_api.api06
               END IF
               IF cl_null(l_npq.npq04) THEN
                  LET l_npq.npq04 = l_apa.apa25
               END IF
               #FUN-D10065--add--end--
               CALL s_def_npq31_npq34(l_npq.*,g_bookno)  RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34  #FUN-AA0087
               CALL t110_chk_aee(l_npq.*)
               RETURNING l_npq.*
               SELECT azi04 INTO t_azi04 FROM azi_file
                 WHERE azi01 = l_npq.npq24
#No.FUN-9A0036 --Begin
               IF p_npptype = '1' THEN
#FUN-A40067 --Begin
                  SELECT aaa03 INTO l_aaa03 FROM aaa_file
                   WHERE aaa01 = g_bookno2
                  SELECT azi04 INTO g_azi04_2 FROM azi_file
                   WHERE azi01 = l_aaa03
#FUN-A40067 --End
                  CALL s_newrate(g_bookno1,g_bookno2,l_npq.npq24,
                                 g_npq25_1,l_npp.npp02)
                  RETURNING l_npq.npq25
                # LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25  #TQC-B80204 mark
                # TQC-B80204 --begin
                  IF l_npq.npq25 = g_npq25_1 AND g_azi04_2 = g_azi04 THEN
                     LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)
                  ELSE
                     LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
                     LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2)
                  END IF
                # TQC-B80204 --end
                #  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2)#FUN-A40067  #TQC-B80204 mark
               ELSE
                  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)#FUN-A40067
               END IF
#No.FUN-9A0036 --End
               LET l_npq.npq07f = cl_digcut(l_npq.npq07f,t_azi04)
              #LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)#FUN-A40067
              #IF l_aag371 MATCHES '[23]' THEN                #FUN-950053 mark
               IF l_aag371 MATCHES '[234]' THEN               #FUN-950053 add  
                  LET l_npq.npq37 = l_api.api37         #MOD-A20047 add
                  #-->for 合併報表-關係人
                  SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903 FROM pmc_file
                   WHERE pmc01 = l_apa.apa05
                  IF cl_null(l_npq.npq37) THEN
                     IF l_pmc903 = 'Y' THEN
                        LET l_npq.npq37 = l_apa.apa05 CLIPPED   #No.CHI-830037  
                     END IF
                  END IF
               END IF
               LET l_npq.npqlegal = g_legal #FUN-980001 add
               #No.FUN-A30077  --Begin                                          
               CALL t110_entry_direction(g_bookno,l_npq.npq03,l_npq.npq06,      
                                         l_npq.npq07,l_npq.npq07f)              
                    RETURNING l_npq.npq06,l_npq.npq07,l_npq.npq07f              
               #No.FUN-A30077  --End 
#No.FUN-AC0001 --begin                                                          
               IF cl_null(l_npq.npq35) THEN LET l_npq.npq35 = ' ' END IF        
               IF cl_null(l_npq.npq05) THEN LET l_npq.npq05 = ' ' END IF        
               IF cl_null(l_npq.npq08) THEN LET l_npq.npq08 = ' ' END IF        
#No.FUN-AC0001 --end 
              #FUN-D40118 ---Add--- Start
               SELECT aag44 INTO l_aag44 FROM aag_file
                WHERE aag00 = g_bookno3
                  AND aag01 = l_npq.npq03
               IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
                  CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
                  IF l_flag = 'N'   THEN
                     LET l_npq.npq03 = ''
                  END IF
               END IF
              #FUN-D40118 ---Add--- End
               INSERT INTO npq_file VALUES (l_npq.*)
               MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',l_npq.npq07
               IF STATUS THEN 
                  IF g_bgerr THEN
                     LET g_showmsg=l_npq.npq01,"/",l_npq.npq011,"/",l_npq.npq02,"/",l_npq.npqsys,"/",l_npq.npq00,"/",l_npq.npqtype
                     CALL s_errmsg("npq01,npq011,npq02,npqsys,npq00,npqtype",g_showmsg,"t110_g_gl(ckp#1)",SQLCA.sqlcode,1)
                  ELSE
                     CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,STATUS,"","t110_g_gl(ckp#1)",1)  #No.FUN-660122
                  END IF
                  LET g_success = 'N'
                  EXIT FOREACH  #no.5573
               END IF
            END IF
            LET l_npq.npq24 = l_npq24_o    #No.TQC-7C0149
            LET l_npq.npq25 = l_npq25_o    #No.TQC-7C0149
            LET g_npq25_1=l_npq.npq25      #FUN-9A0036
         END FOREACH
      END IF
      IF l_apa.apa51 = 'UNAP' THEN
         CALL t110_unap_npq1(p_apno,p_aptype,g_bookno,l_apa.*,'0','1')
      END IF
   ELSE
      IF l_apa.apa511 = 'MISC' OR l_apa.apa511 = 'UNAP' THEN
         LET g_sql = " SELECT * FROM api_file ",
                     "  WHERE api01 = '",p_apno,"'",
                     "    AND (api041 IS NOT NULL AND api041 <> ' ')"
         PREPARE t110_gl_p11 FROM g_sql
         DECLARE t110_gl_c11 CURSOR FOR t110_gl_p11
         LET l_sql = "select oox07 from oox_file where oox00 = 'AP' ",
                     "   and oox03 = ? and oox041 = ? ",
                     "order by oox01 desc,oox02 desc"
         PREPARE t110_oox07_1 FROM l_sql
         DECLARE t110_oox07_cl_1 CURSOR FOR t110_oox07_1
   
         LET l_npq24_o = l_npq.npq24       #No.TQC-7C0149
         LET l_npq25_o = l_npq.npq25       #No.TQC-7C0149
         FOREACH t110_gl_c11 INTO l_api.*
            IF STATUS THEN 
               EXIT FOREACH 
            END IF
   
            LET l_npq.npq02 = l_npq.npq02 + 1
            LET l_npq.npq03 = l_api.api041
            LET l_npq.npq04 = NULL          #FUN-D10065  add
           #FUN-D10065---mark--str
           #LET l_npq.npq04 = l_api.api06    
           #IF cl_null(l_npq.npq04) THEN
           #   LET l_npq.npq04 = l_apa.apa25
           #END IF
           #FUN-D10065---mark---end
            IF NOT cl_null(l_api.api26) AND l_api.api26 <> 'DIFF' THEN
               SELECT apa13 INTO l_npq.npq24                    #MOD-930244
                 FROM apa_file
                WHERE apa01 = l_api.api26
               IF SQLCA.sqlcode THEN
                  LET l_npq.npq24 = l_npq24_o
               END IF
            END IF
            SELECT azi03 INTO l_azi03 FROM azi_file WHERE azi01 =l_npq.npq24
            IF cl_null(l_api.api05) THEN
               LET l_api.api05 =0
            END IF
            IF cl_null(l_api.api05f) THEN
               LET l_api.api05f =1
            END IF
            LET l_npq.npq25=''
            IF g_apz.apz27 = 'Y' THEN   #有做重評價
                LET l_count = 1 
                #FOREACH t110_oox07_cl_1 USING l_api.api26,l_api.api40   #CHI-E30030 mark
                FOREACH t110_oox07_cl_1 USING l_api.api26,'1'           #CHI-E30030 add
                                      INTO l_oox07[l_count].*
                    IF STATUS THEN 
                       CALL cl_err('forach:',STATUS,1)
                       EXIT FOREACH
                    END IF         
                    LET l_npq.npq25 = l_oox07[l_count].oox07
                    LET l_count = l_count + 1
                    IF l_count = 2 THEN 
                       EXIT FOREACH 
                    END IF            
                END FOREACH                                          
            END IF
            IF cl_null(l_npq.npq25) THEN
              #-MOD-B10093-add-
               IF l_api.api02 = '1' THEN  
                  LET l_npq.npq25 = l_apa.apa14   
               ELSE
              #-MOD-B10093-end-
                #str MOD-B70140 add
                 IF l_api.api26 = 'DIFF' THEN
                    LET l_npq.npq25 = 1
                 ELSE
                #end MOD-B70140 add
                 #-MOD-A60160-add-
                  SELECT apa14 INTO l_npq.npq25    
                    FROM apa_file
                   WHERE apa01 = l_api.api26
                 #-MOD-A60160-end-
                 END IF   #MOD-B70140 add
               END IF                  #MOD-B10093
              #LET l_npq.npq25 =l_api.api05/l_api.api05f        #MOD-A60160 mark
              #LET l_npq.npq25 =cl_digcut(l_npq.npq25,l_azi03)  #MOD-AC0049 mark
            END IF
            LET g_npq25_1=l_npq.npq25      #FUN-9A0036
            LET l_npq.npq06 = '1'
            LET l_npq.npq07 = l_api.api05
            LET l_npq.npq07f = l_api.api05f
            LET l_aag05 = ' '
            LET l_aag21 = ' '
            LET l_aag23 = ' '
            LET l_aag371 = ' '   #MOD-750132
   
            SELECT aag05,aag21,aag23,aag371 INTO l_aag05,l_aag21,l_aag23,l_aag371   #MOD-750132
              FROM aag_file
             WHERE aag01 = l_npq.npq03
               AND aag00 = g_bookno     #No.FUN-730064
   
            IF l_aag23 = 'Y' THEN
               LET l_npq.npq08 = l_api.api26
               LET l_npq.npq35 = l_api.api35   #CHI-A30003 add
            ELSE
               LET l_npq.npq08 = NULL
               LET l_npq.npq35 = NULL          #CHI-A30003 add
            END IF
   
   
            LET o_npq07 = o_npq07 + l_npq.npq07    #FUN-680110 add   #MOD-7A0069 mod
            LET o_npq07f= o_npq07f+ l_npq.npq07f   #FUN-680110 add   #MOD-7A0069 mod
            IF l_npq.npq07 < 0 THEN
               LET l_npq.npq07 = l_npq.npq07 * -1
               LET l_npq.npq07f = l_npq.npq07f * -1
               IF l_npq.npq06 = '1' THEN 
                  LET l_npq.npq06 = '2'
               ELSE
                  LET l_npq.npq06 = '1'
               END IF
            END IF
   
            LET l_npq.npq05 = ''   #MOD-B30089 add
            IF l_aag05='Y' THEN
               IF g_aaz.aaz90='N' THEN
                  LET l_npq.npq05 = l_api.api07
               ELSE
                  LET l_npq.npq05 = l_api.api930   #MOD-8C0067
               END IF
            ELSE
               LET l_npq.npq05 = ''
            END IF
   
            LET l_npq.npq11 = l_api.api21
            LET l_npq.npq12 = l_api.api22
            LET l_npq.npq13 = l_api.api23
            LET l_npq.npq14 = l_api.api24 
            LET l_npq.npq31 = l_api.api31
            LET l_npq.npq32 = l_api.api32
            LET l_npq.npq33 = l_api.api33
            LET l_npq.npq34 = l_api.api34
           #LET l_npq.npq35 = l_api.api35      #CHI-A30003 mark
            SELECT aag21 INTO l_aag21 FROM aag_file
             WHERE aag00 = g_bookno
               AND aag01 = l_npq.npq03               
            IF l_aag21 = 'Y' THEN             #MOD-950096 
               LET l_npq.npq36 = l_api.api36 
            END IF                            #MOD-950096    
           #LET l_npq.npq37 = l_api.api37     #MOD-A20047 mark
   
            IF l_npq.npq07 != 0 THEN 
               IF p_aptype[1,1] = '2' THEN
                  LET l_npq.npq07 = (-1)*l_npq.npq07                                  
                  LET l_npq.npq07f= (-1)*l_npq.npq07f 
               END IF
               CALL s_def_npq5(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno)   #No.FUN-730064  #MOD-860011
               RETURNING l_npq.*
               #FUN-D10065--add--str--
               IF cl_null(l_npq.npq04) THEN
                  LET l_npq.npq04 = l_api.api06
               END IF
               IF cl_null(l_npq.npq04) THEN
                  LET l_npq.npq04 = l_apa.apa25
               END IF
               #FUN-D10065--add--end--
               CALL s_def_npq31_npq34(l_npq.*,g_bookno) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34    #FUN-AA0087
               CALL t110_chk_aee(l_npq.*)
               RETURNING l_npq.*
               SELECT azi04 INTO t_azi04 FROM azi_file
                 WHERE azi01 = l_npq.npq24
#No.FUN-9A0036 --Begin
               IF p_npptype = '1' THEN
#FUN-A40067 --Begin
                  SELECT aaa03 INTO l_aaa03 FROM aaa_file
                   WHERE aaa01 = g_bookno2
                  SELECT azi04 INTO g_azi04_2 FROM azi_file
                   WHERE azi01 = l_aaa03
#FUN-A40067 --End
                  CALL s_newrate(g_bookno1,g_bookno2,l_npq.npq24,
                                 g_npq25_1,l_npp.npp02)
                  RETURNING l_npq.npq25
                # LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25  #TQC-B80204 mark
                # TQC-B80204 --begin
                  IF l_npq.npq25 = g_npq25_1 AND g_azi04_2 = g_azi04 THEN
                     LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)
                  ELSE
                     LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
                     LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2)
                  END IF
                # TQC-B80204 --end
                #  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2) #FUN-A40067 #TQC-B80204 mark
               ELSE
                  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04) #FUN-A40067
               END IF
#No.FUN-9A0036 --End
               LET l_npq.npq07f = cl_digcut(l_npq.npq07f,t_azi04)
#              LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)    #FUN-A40067
             # IF l_aag371 MATCHES '[23]' THEN                     #FUN-950053 mark
               IF l_aag371 MATCHES '[234]' THEN                    #FUN-950053 add  
                  LET l_npq.npq37 = l_api.api37         #MOD-A20047 add
                  #-->for 合併報表-關係人
                  SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903 FROM pmc_file
                   WHERE pmc01 = l_apa.apa05
                  IF cl_null(l_npq.npq37) THEN
                     IF l_pmc903 = 'Y' THEN
                        LET l_npq.npq37 = l_apa.apa05 CLIPPED   #No.CHI-830037
                     END IF
                  END IF
               END IF
               LET l_npq.npqlegal = g_legal #FUN-980001 add
               #No.FUN-A30077  --Begin                                          
               CALL t110_entry_direction(g_bookno,l_npq.npq03,l_npq.npq06,      
                                         l_npq.npq07,l_npq.npq07f)              
                    RETURNING l_npq.npq06,l_npq.npq07,l_npq.npq07f              
               #No.FUN-A30077  --End 
#No.FUN-AC0001 --begin                                                          
               IF cl_null(l_npq.npq35) THEN LET l_npq.npq35 = ' ' END IF        
               IF cl_null(l_npq.npq05) THEN LET l_npq.npq05 = ' ' END IF        
               IF cl_null(l_npq.npq08) THEN LET l_npq.npq08 = ' ' END IF        
#No.FUN-AC0001 --end 
              #FUN-D40118 ---Add--- Start
               SELECT aag44 INTO l_aag44 FROM aag_file
                WHERE aag00 = g_bookno3
                  AND aag01 = l_npq.npq03
               IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
                  CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
                  IF l_flag = 'N'   THEN
                     LET l_npq.npq03 = ''
                  END IF
               END IF
              #FUN-D40118 ---Add--- End
               INSERT INTO npq_file VALUES (l_npq.*)
                
                 
               MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',l_npq.npq07
               IF STATUS THEN 
                  IF g_bgerr THEN
                     LET g_showmsg=l_npq.npq01,"/",l_npq.npq011,"/",l_npq.npq02,"/",l_npq.npqsys,"/",l_npq.npq00,"/",l_npq.npqtype
                     CALL s_errmsg("npq01,npq011,npq02,npqsys,npq00,npqtype",g_showmsg,"t110_g_gl(ckp#1)",SQLCA.sqlcode,1)
                  ELSE
                     CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,STATUS,"","t110_g_gl(ckp#1)",1)
                  END IF
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF
            END IF
            LET l_npq.npq24 = l_npq24_o  #No.TQC-7C0149
            LET l_npq.npq25 = l_npq25_o  #No.TQC-7C0149
            LET g_npq25_1=l_npq.npq25    #9A0036
         END FOREACH
      END IF
      #UNAP除了api資料外,還要考慮apb_file & apb34 = 'N'的資料
      IF l_apa.apa51 = 'UNAP' THEN
         CALL t110_unap_npq1(p_apno,p_aptype,g_bookno,l_apa.*,'1','1')
      END IF
   END IF
   LET l_npq.npq04 = ''   #MOD-7B0049
 
   LET l_npq.npq11=''
   LET l_npq.npq12=''
   LET l_npq.npq13=''
   LET l_npq.npq14=''
   LET l_npq.npq31=''
   LET l_npq.npq32=''
   LET l_npq.npq33=''
   LET l_npq.npq34=''
   LET l_npq.npq35=''
   LET l_npq.npq36=''
   LET l_npq.npq37=''
 
   IF p_npptype = '0' THEN  #No.FUN-680029
      IF l_apa.apa51 = 'STOCK' THEN
         CALL t110_stock(p_apno,l_apa.apa66,p_npptype,p_aptype)  #no.6903 #No.FUN-680029 新增p_npptype  #MOD-960127 add p_aptype 
         CALL t110_unap_npq2(p_apno,p_aptype,g_bookno,l_apa.*,'0','1')  #No.TQC-7B0083
      END IF
   ELSE
      IF l_apa.apa511 = 'STOCK' THEN
         CALL t110_stock(p_apno,l_apa.apa66,p_npptype,p_aptype)  #no.6903 #No.FUN-680029 新增p_npptype  #MOD-960127 add p_aptype 
         CALL t110_unap_npq2(p_apno,p_aptype,g_bookno,l_apa.*,'1','1')  #No.TQC-7B0083
      END IF
   END IF
 
   LET l_npq.npq11=''
   LET l_npq.npq12=''
   LET l_npq.npq13=''
   LET l_npq.npq14=''
   LET l_npq.npq31=''
   LET l_npq.npq32=''
   LET l_npq.npq33=''
   LET l_npq.npq34=''
   LET l_npq.npq35=''
   LET l_npq.npq36=''
   LET l_npq.npq37=''
   LET l_npq.npq04=''   #MOD-7B0049
 
   #---->多借方多貸方
   IF p_npptype = '0' THEN  #No.FUN-680029
      IF cl_null(l_apa.apa51) THEN		# 9602 By roger
         IF g_aptype <> '13' THEN
            LET g_sql = "SELECT apb29,apb25,apb26,apb27,apb35,apb36,apb31,",   #FUN-810045 add apb35/apb36/apb31        #No.FUN-830161
                        "       apb930,apb32,",   #MOD-8B0092 add  #MOD-C50236 add apb32
                        "       SUM(apb10) apb10,SUM(apb24) apb24",  #MOD-920100 mod
                        "  FROM apb_file",
                        " WHERE apb01 = '",p_apno,"'",
                        "   AND (apb10 != 0 OR apb27 IS NOT NULL) ",
                        "   AND (apb34 IS NULL OR apb34 = 'N') ",
                        " GROUP BY apb29,apb25,apb26,apb27,apb35,apb36,apb31,apb930,apb32 "  #FUN-810045 add apb35/apb36/31  #No.FUN-830161  #MOD-8B0092 add apb930  #MOD-C50236 add apb32
         ELSE
            LET g_sql = "SELECT apb29,apb25,apb26,apb33,apb35,apb36,apb31,",    #FUN-810045 add apb35/apb36/apb31      #No.FUN-830161
                        "       apb930,apb32,",   #MOD-8B0092 add  ##MOD-C50236 add apb32
                        "       SUM(apb10) apb10,SUM(apb24) apb24",  #MOD-920100 mod
                        "  FROM apb_file",
                        " WHERE apb01 = '",p_apno,"'",
                        "   AND (apb10 != 0 OR apb33 IS NOT NULL) ",
                        "   AND (apb34 IS NULL OR apb34 = 'N') ",
                        " GROUP BY apb29,apb25,apb26,apb33,apb35,apb36,apb31,apb930,apb32 "   #FUN-810045 add apb36/31  #No.FUN-830161  #MOD-8B0092 add apb930  #MOD-C50236 add apb32
         END IF
        #DELETE FROM t110_gl_tmp   #MOD-AC0021 mark
         DROP TABLE t110_gl_tmp    #MOD-AC0021

         LET g_sql = g_sql CLIPPED," INTO TEMP t110_gl_tmp"
         PREPARE t110_gl_p401 FROM g_sql
         EXECUTE t110_gl_p401
 
         LET l_sql = "SELECT apb25 FROM t110_gl_tmp,aag_file",
                     " WHERE apb25=aag01",
                     "   AND aag00='",g_bookno,"'",
                     "   AND aag23='N'",
                     " ORDER BY apb25"
         PREPARE t110_gl_p402 FROM l_sql
         DECLARE t110_gl_c402 CURSOR FOR t110_gl_p402
         FOREACH t110_gl_c402 INTO l_apb25
            IF STATUS THEN EXIT FOREACH END IF
            UPDATE t110_gl_tmp SET apb35='',apb36='' WHERE apb25=l_apb25
         END FOREACH
 
         IF g_aptype <> '13' THEN
           #LET g_sql="SELECT apb29,apb25,apb26,apb27,apb35,apb36,apb31,",   #MOD-C80065 mark
            LET g_sql="SELECT apb29,apb25,apb26,apb35,apb36,apb31,",         #MOD-C80065
                      "       apb930,apb32,apb27,",                          #MOD-C50236 add apb32 #CHI-CC0022 add apb27
                      "       SUM(apb10),SUM(apb24)",
                      "  FROM t110_gl_tmp",
                     #" GROUP BY apb29,apb25,apb26,apb27,apb35,apb36,apb31,apb930,apb32 ",   #MOD-C50236 add apb32  #MOD-C80065 mark
                      " GROUP BY apb29,apb25,apb26,apb35,apb36,apb31,apb930,apb32,apb27 ",    #MOD-C50236 add apb32  #MOD-C80065 #CHI-CC0022 add apb27
                      " ORDER BY apb29,apb25,apb26 "             
         ELSE
           #LET g_sql="SELECT apb29,apb25,apb26,apb33,apb35,apb36,apb31,",  #MOD-C80065 mark 
            LET g_sql="SELECT apb29,apb25,apb26,apb35,apb36,apb31,",        #MOD-C80065
                      "       apb930,apb32,apb33,",                                           #MOD-C50236 add apb32 #CHI-CC0022 add apb33
                      "       SUM(apb10),SUM(apb24)",
                      "  FROM t110_gl_tmp",
                     #" GROUP BY apb29,apb25,apb26,apb33,apb35,apb36,apb31,apb930,apb32 ",    #MOD-C50236 add apb32  #MOD-C80065 mark
                      " GROUP BY apb29,apb25,apb26,apb35,apb36,apb31,apb930,apb32,apb33 ",    #MOD-C80065 #CHI-CC0022 add apb33
                      " ORDER BY apb29,apb25,apb26 "          
         END IF
         
         
         PREPARE t110_gl_p41 FROM g_sql
         DECLARE t110_gl_c41 CURSOR FOR t110_gl_p41
   
         FOREACH t110_gl_c41 INTO l_apb29,l_npq.npq03,l_npq.npq05,   #l_npq.npq04, #MOD-C80065 mark 
                                  l_apb35,l_apb36,l_apb31,                      #FUN-810045 add apb35/36/31  #No.FUN-830161
                                  l_apb930,l_apb32,l_npq04,                #MOD-8B0092 add #MOD-C50236 add apb32 #CHI-CC0022 add npq04
                                  l_npq.npq07,l_npq.npq07f
            IF STATUS THEN
               EXIT FOREACH
            END IF
   
            IF cl_null(l_actno) THEN 
               LET l_actno = l_apa.apa51 
            END IF
   
            LET l_npq.npq02 = l_npq.npq02 + 1
            LET l_npq.npq04 = NULL                 #MOD-D20101 add
   
            IF cl_null(l_npq.npq06) THEN
               LET l_npq.npq06 = '1'
            END IF
            IF l_apb29 = '1' THEN
               LET l_npq.npq06 = '1'
            END IF
   
            IF l_apb29 = '3' THEN
               IF g_aza.aza26='2' AND g_apydmy6='Y' THEN
                  LET l_npq.npq06 = '1'
               ELSE
                  LET l_npq.npq06 = '2'
               END IF   #MOD-8C0010 add
            END IF
          #MOD-C50236  --Begin
          IF g_aptype='13' AND NOT cl_null(l_apb32) THEN 
             LET l_npq.npq21 = l_apb32 
             LET l_sql = "SELECT gen02 ",
                         "  FROM ",cl_get_target_table(ms_plant,'gen_file'),
                         " WHERE gen01 = '",l_apb32,"' "
             CALL cl_replace_sqldb(l_sql) RETURNING l_sql 
             CALL cl_parse_qry_sql(l_sql,ms_plant) RETURNING l_sql 
             PREPARE sel_gen_cs4 FROM l_sql
             EXECUTE sel_gen_cs4 INTO l_npq.npq22     
          END IF 
          #MOD-C50236  --End
 
          IF l_npq.npq07 < 0 THEN
             IF l_apb29 = '3' THEN
                LET l_npq.npq07 = l_npq.npq07 * -1
                LET l_npq.npq07f = l_npq.npq07f * -1
             ELSE
                LET l_npq.npq07 = l_npq.npq07
                LET l_npq.npq07f = l_npq.npq07f
             END IF
          END IF
   
            SELECT aag05,aag21,aag23,aag371 INTO l_aag05,l_aag21,l_aag23,l_aag371   #MOD-750132
              FROM aag_file
             WHERE aag01 = l_npq.npq03
               AND aag00 = g_bookno     #No.FUN-730064
   
            LET l_apb26 = l_npq.npq05   #CHI-CC0022 add
            IF l_aag05 = 'Y' THEN
               IF g_aaz.aaz90='N' THEN
                  IF cl_null(l_npq.npq05) THEN
                     LET l_npq.npq05 = l_apa.apa22
                  END IF
               ELSE
                  LET l_npq.npq05 = l_apb930   #MOD-8B0092 mod #l_apa.apa930
               END IF
            ELSE
               LET l_npq.npq05 = ''
            END IF
   
            IF l_npq.npq07!=0 THEN 
               IF p_aptype[1,1] = '2' THEN
                  LET l_npq.npq07 = (-1)*l_npq.npq07                                  
                  LET l_npq.npq07f= (-1)*l_npq.npq07f 
               END IF                               
              #SELECT FIRST(apb02) FROM apb_file WHERE apb01 = l_npq.npq01   #TQC-C20214 mark
               SELECT MIN(apb02) FROM apb_file WHERE apb01 = l_npq.npq01     #TQC-C20214
              #---------------------MOD-CC0253--------------------------(S)
               LET l_apb02 = 0
               LET l_sql = " SELECT apb02 ",
                           "   FROM apb_file ",
                           "  WHERE apb01 = '",l_npq.npq01,"'",
                           "    AND apb29 = '",l_apb29,"'",
                           "    AND apb25 = '",l_npq.npq03,"'",
                          #"    AND apb26 = '",l_npq.npq05,"'",  #CHI-CC0022 mark
                           "    AND apb26 = '",l_apb26,"'",      #CHI-CC0022 add
                           "    AND apb31 = '",l_apb31,"'",
                           "    AND apb35 = '",l_apb35,"'",
                           "    AND apb36 = '",l_apb36,"'",
                           "    AND apb930 = '",l_apb930,"'" 
                          #"    AND apb32 = '",l_apb32,"'"                       #MOD-D20101 mark
               IF g_aptype = '13' AND NOT cl_null(l_apb32) THEN                  #MOD-D20101 add
                  LET l_sql = l_sql CLIPPED,"    AND apb32 = '",l_apb32,"'"      #MOD-D20101 add
               END IF   

               #MOD-D40069 add begin---
               IF g_aptype <> '13' THEN
                  LET l_sql = l_sql CLIPPED,"    AND apb27 = '",l_npq04,"'"
               ELSE
                  #LET l_sql = l_sql CLIPPED,"    AND apb33 = '",l_npq04,"'"                       #yinhy131015 mark
                  LET l_sql = l_sql CLIPPED,"    AND (apb33 = '",l_npq04,"' OR apb33 IS NULL)"     #yinhy131015
               END IF
               #MOD-D40069 add end-----
                                                         #MOD-D20101 add
               PREPARE t110_papb02_01 FROM l_sql
               DECLARE t110_capb02_01 SCROLL CURSOR FOR t110_papb02_01
               OPEN t110_capb02_01
               FETCH FIRST t110_capb02_01 INTO l_apb02
               CLOSE t110_capb02_01
              #---------------------MOD-CC0253--------------------------(E)
               LET p_prog = g_prog                       #MOD-C30056 add
              #No.MOD-BC0264  --Begin
               CASE g_prog
                  WHEN 'aapp110' LET g_prog = 'aapt110'
                  WHEN 'aapp111' LET g_prog = 'aapt210'
                  WHEN 'aapp115' LET g_prog = 'aapt160'
                  WHEN 'aapp117' LET g_prog = 'aapt260'
               END CASE
              #No.MOD-BC0264  --End
              #CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno)        #No.FUN-730064 #MOD-CC0253 mark
               CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,l_apb02,'',g_bookno)                  #MOD-CC0253
               RETURNING l_npq.* 
               #FUN-D10065--add--str--
               IF cl_null(l_npq.npq04) THEN
                  LET l_npq.npq04 = l_api.api06
               END IF
               IF cl_null(l_npq.npq04) THEN
                  LET l_npq.npq04 = l_apa.apa25
               END IF
               #FUN-D10065--add--end--
               IF cl_null(l_npq.npq04) THEN LET l_npq.npq04 = l_npq04 END IF                      #CHI-CC0022 add
               LET g_prog = p_prog                       #MOD-C30056 add
               CALL s_def_npq31_npq34(l_npq.*,g_bookno) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34   #FUN-AA0087                  
               CALL t110_chk_aee(l_npq.*)
               RETURNING l_npq.*

               SELECT azi04 INTO t_azi04 FROM azi_file
                 WHERE azi01 = l_npq.npq24
               LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)
             # IF l_aag371 MATCHES '[23]' THEN                 #FUN-950053 mark
               IF l_aag371 MATCHES '[234]' THEN                #FUN-950053 add   
                  #-->for 合併報表-關係人
                  SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903 FROM pmc_file
                   WHERE pmc01 = l_apa.apa05
                  IF cl_null(l_npq.npq37) THEN
                     IF l_pmc903 = 'Y' THEN
#                       LET l_npq.npq37 = l_pmc03 CLIPPED       #No.CHI-830037
                        LET l_npq.npq37 = l_apa.apa05 CLIPPED   #No.CHI-830037
                     END IF
                  END IF
               END IF
               IF l_aag23 = 'Y' THEN
                  LET l_npq.npq08 = l_apb35
                  LET l_npq.npq35 = l_apb36     #CHI-A30003 add
               ELSE
                  LET l_npq.npq08 = NULL
                  LET l_npq.npq35 = NULL        #CHI-A30003 add
               END IF
              #LET l_npq.npq35 = l_apb36        #CHI-A30003 mark
            SELECT aag21 INTO l_aag21 FROM aag_file
             WHERE aag00 = g_bookno
               AND aag01 = l_npq.npq03               
            IF l_aag21 = 'Y' THEN             #MOD-950096 
               LET l_npq.npq36 = l_apb31 
            END IF                            #MOD-950096    
               LET l_npq.npqlegal = g_legal #FUN-980001 add
               #No.FUN-A30077  --Begin                                          
               CALL t110_entry_direction(g_bookno,l_npq.npq03,l_npq.npq06,      
                                         l_npq.npq07,l_npq.npq07f)              
                    RETURNING l_npq.npq06,l_npq.npq07,l_npq.npq07f              
               #No.FUN-A30077  --End 
#No.FUN-AC0001 --begin                                                          
               IF cl_null(l_npq.npq35) THEN LET l_npq.npq35 = ' ' END IF        
               IF cl_null(l_npq.npq05) THEN LET l_npq.npq05 = ' ' END IF        
               IF cl_null(l_npq.npq08) THEN LET l_npq.npq08 = ' ' END IF        
#No.FUN-AC0001 --end 
              #FUN-D40118 ---Add--- Start
               SELECT aag44 INTO l_aag44 FROM aag_file
                WHERE aag00 = g_bookno3
                  AND aag01 = l_npq.npq03
               IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
                  CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
                  IF l_flag = 'N'   THEN
                     LET l_npq.npq03 = ''
                  END IF
               END IF
              #FUN-D40118 ---Add--- End
               INSERT INTO npq_file VALUES (l_npq.*)
               MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',l_npq.npq07
               IF STATUS THEN 
                  IF g_bgerr THEN
                     LET g_showmsg=l_npq.npq01,"/",l_npq.npq011,"/",l_npq.npq02,"/",l_npq.npqsys,"/",l_npq.npq00,"/",l_npq.npqtype
                     CALL s_errmsg("npq01,npq011,npq02,npqsys,npq00,npqtype",g_showmsg,"t110_g_gl(ckp#41)",SQLCA.sqlcode,1)
                  ELSE
                     CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,STATUS,"","t110_g_gl(ckp#41)",1)  #No.FUN-660122
                  END IF
                  LET g_success='N'
                  EXIT FOREACH #no.5573
               END IF
            END IF
         END FOREACH
         CALL t110_unap_npq2(p_apno,p_aptype,g_bookno,l_apa.*,'0','1')  #No.TQC-7B0083
      END IF
   ELSE
      IF cl_null(l_apa.apa511) THEN
         IF g_aptype <> '13' THEN
            LET g_sql = "SELECT apb29,apb251,apb26,apb27,apb35,apb36,apb31,",   #FUN-810045 add apb35/36/31        #No.FUN-830161
                        "       apb930,apb32,",   #MOD-8B0092 add   #MOD-C50236 add apb32
                        "       SUM(apb10) apb10,SUM(apb24) apb24",  #MOD-920100 mod
                        "  FROM apb_file ",
                        " WHERE apb01 = '",p_apno,"'",
                        "   AND (apb10 != 0 OR apb27 IS NOT NULL) ",
                        "   AND (apb34 IS NULL OR apb34 = 'N') ",
                        " GROUP BY apb29,apb251,apb26,apb27,apb35,apb36,apb31,apb930,apb32 "  #FUN-810045 add apb35/36/31  #No.FUN-830161  #MOD-8B0092 add apb930  #MOD-C50236 add apb32
         ELSE
            LET g_sql = "SELECT apb29,apb251,apb26,apb33,apb35,apb36,apb31,",           #FUN-810045 add apb35/36/31  #No.FUN-830161
                        "       apb930,apb32,",   #MOD-8B0092 add   #MOD-C50236 add apb32
                        "       SUM(apb10) apb10,SUM(apb24) apb24",  #MOD-920100 mod
                        "  FROM apb_file ",
                        " WHERE apb01 = '",p_apno,"'",
                        "   AND (apb10 != 0 OR apb33 IS NOT NULL) ",
                        "   AND (apb34 IS NULL OR apb34 = 'N') ",
                        " GROUP BY apb29,apb251,apb26,apb33,apb35,apb36,apb31,apb930,apb32 "  #FUN-810045 add apb35/36/31  #No.FUN-830161  #MOD-8B0092 add apb930 #MOD-C50236 add apb32
         END IF
        #DELETE FROM t110_gl_tmp1                              #MOD-AB0195 mod  #MOD-AC0021 mark
         DROP TABLE t110_gl_tmp1                                                #MOD-AC0021
         LET g_sql = g_sql CLIPPED," INTO TEMP t110_gl_tmp1"   #MOD-AB0195 mod 
         PREPARE t110_gl_p403 FROM g_sql
         EXECUTE t110_gl_p403
 
         LET l_sql = "SELECT apb251 FROM t110_gl_tmp1,aag_file", #MOD-AB0195 mod
                     " WHERE apb251=aag01",
                     "   AND aag00='",g_bookno,"'",
                     "   AND aag23='N'",
                     " ORDER BY apb251"
         PREPARE t110_gl_p404 FROM l_sql
         DECLARE t110_gl_c404 CURSOR FOR t110_gl_p404
         FOREACH t110_gl_c404 INTO l_apb251
            IF STATUS THEN EXIT FOREACH END IF
            UPDATE t110_gl_tmp1 SET apb35='',apb36='' WHERE apb251=l_apb251  #MOD-AB0195 mod
         END FOREACH
 
         IF g_aptype <> '13' THEN
           #LET g_sql="SELECT apb29,apb251,apb26,apb27,apb35,apb36,apb31,",  #MOD-C80065 mark
            LET g_sql="SELECT apb29,apb251,apb26,apb35,apb36,apb31,",        #MOD-C80065
                      "       apb930,apb32,apb33,"                     ,     #MOD-C50236 aad apb32 #CHI-CC0022 add apb33
                      "       SUM(apb10),SUM(apb24)",
                      "  FROM t110_gl_tmp1",                                 #MOD-AB0195 mod
                     #" GROUP BY apb29,apb251,apb26,apb27,apb35,apb36,apb31,apb930,apb32 ",  #MOD-C50236 add apb32  #MOD-C80065 mark
                      " GROUP BY apb29,apb251,apb26,apb35,apb36,apb31,apb930,apb32,apb33 ", #MOD-C50236 aad apb32  #MOD-C80065 #CHI-CC0022 add apb33
                      " ORDER BY apb29,apb251,apb26 "
         ELSE
           #LET g_sql="SELECT apb29,apb251,apb26,apb33,apb35,apb36,apb31,",  #MOD-C80065 mark
            LET g_sql="SELECT apb29,apb251,apb26,apb35,apb36,apb31,",        #MOD-C80065
                      "       apb930,apb32,apb33,",                          #MOD-C50236 aad apb32 #CHI-CC0022 add apb33
                      "       SUM(apb10),SUM(apb24)",
                      "  FROM t110_gl_tmp1",                                 #MOD-AB0195 mod
                     #" GROUP BY apb29,apb251,apb26,apb33,apb35,apb36,apb31,apb930,apb32 ",  #MOD-C50236 add apb32  #MOD-C80065 mark
                      " GROUP BY apb29,apb251,apb26,apb35,apb36,apb31,apb930,apb32,apb33 ",    #MOD-C80065 #CHI-CC0022 add apb33
                      " ORDER BY apb29,apb251,apb26 "
         END IF
         PREPARE t110_gl_p411 FROM g_sql
         DECLARE t110_gl_c411 CURSOR FOR t110_gl_p411
       
         FOREACH t110_gl_c411 INTO l_apb29,l_npq.npq03,l_npq.npq05,   #l_npq.npq04,  #MOD-C80065 mark
                                   l_apb35,l_apb36,l_apb31,                 #FUN-810045 add apb35/36/31  #No.FUN-830161
                                   l_apb930,l_apb32,l_npq04,             #MOD-8B0092 add  #MOD-C50236 add apb32 #CHI-CC0022 add npq04
                                   l_npq.npq07,l_npq.npq07f
            IF STATUS THEN
               EXIT FOREACH
            END IF
   
            IF cl_null(l_actno) THEN 
               LET l_actno = l_apa.apa511 
            END IF
   
            LET l_npq.npq02 = l_npq.npq02 + 1
            LET l_npq.npq04 = NULL                 #MOD-D20101 add
   
            IF cl_null(l_npq.npq06) THEN
               LET l_npq.npq06 = '1'
            END IF
            IF l_apb29 = '1' THEN
               LET l_npq.npq06 = '1'
            END IF
   
            IF l_apb29 = '3' THEN
               IF g_aza.aza26='2' AND g_apydmy6='Y' THEN
                  LET l_npq.npq06 = '1'
               ELSE
                  LET l_npq.npq06 = '2'
               END IF   #MOD-8C0010 add
            END IF
            #MOD-C50236  --Begin
            IF g_aptype = '13' AND NOT cl_null(l_apb32) THEN 
               LET l_npq.npq21 = l_apb32 
               LET l_sql = "SELECT gen02 ",
                           "  FROM ",cl_get_target_table(ms_plant,'gen_file'),
                           " WHERE gen01 = '",l_apb32,"' "
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql 
               CALL cl_parse_qry_sql(l_sql,ms_plant) RETURNING l_sql 
               PREPARE sel_gen_cs1 FROM l_sql
               EXECUTE sel_gen_cs1 INTO l_npq.npq22     
            END IF 
            #MOD-C50236  --End
   
            IF l_npq.npq07 < 0 THEN                                               
               IF l_apb29 = '3' THEN                                              
                  LET l_npq.npq07 = l_npq.npq07 * -1                              
                  LET l_npq.npq07f = l_npq.npq07f * -1                            
               ELSE                                                               
                  LET l_npq.npq07 = l_npq.npq07                                   
                  LET l_npq.npq07f = l_npq.npq07f                                 
               END IF                                                             
            END IF 
   
            SELECT aag05,aag21,aag23,aag371 INTO l_aag05,l_aag21,l_aag23,l_aag371   #MOD-750132
              FROM aag_file
             WHERE aag01 = l_npq.npq03
               AND aag00 = g_bookno     #No.FUN-730064
   
            IF l_aag05 = 'Y' THEN
               IF g_aaz.aaz90='N' THEN
                  IF cl_null(l_npq.npq05) THEN
                     LET l_npq.npq05 = l_apa.apa22
                  END IF
               ELSE
                  LET l_npq.npq05 = l_apb930   #MOD-8B0092 mod #l_apa.apa930
               END IF
            ELSE
               LET l_npq.npq05 = ''
            END IF
   
            IF l_npq.npq07!=0 THEN 
               IF p_aptype[1,1] = '2' THEN
                  LET l_npq.npq07 = (-1)*l_npq.npq07                                  
                  LET l_npq.npq07f= (-1)*l_npq.npq07f 
               END IF
              #--------------------MOD-CC0253--------------------(S)
               LET l_apb02 = 0
               LET l_sql = " SELECT apb02 ",
                           "   FROM apb_file ",
                           "  WHERE apb01 = '",l_npq.npq01,"'",
                           "    AND apb29 = '",l_apb29,"'",
                           "    AND apb25 = '",l_npq.npq03,"'",
                           "    AND apb26 = '",l_npq.npq05,"'",
                           "    AND apb35 = '",l_apb35,"'",
                           "    AND apb36 = '",l_apb36,"'",
                           "    AND apb31 = '",l_apb31,"'",
                           "    AND apb930 = '",l_apb930,"'" 
                          #"    AND apb32 = '",l_apb32,"'"                       #MOD-D20101 mark
               IF g_aptype = '13' AND NOT cl_null(l_apb32) THEN                  #MOD-D20101 add
                  LET l_sql = l_sql CLIPPED,"    AND apb32 = '",l_apb32,"'"      #MOD-D20101 add
               END IF                                                            #MOD-D20101 add
               PREPARE t110_papb02_02 FROM l_sql
               DECLARE t110_capb02_02 SCROLL CURSOR FOR t110_papb02_02
               OPEN t110_capb02_02
               FETCH FIRST t110_capb02_02 INTO l_apb02
               CLOSE t110_capb02_02
              #--------------------MOD-CC0253--------------------(E)
               LET p_prog = g_prog                       #MOD-C30056 add
              #No.MOD-BC0264  --Begin
               CASE g_prog
                  WHEN 'aapp110' LET g_prog = 'aapt110'
                  WHEN 'aapp111' LET g_prog = 'aapt210'
                  WHEN 'aapp115' LET g_prog = 'aapt160'
                  WHEN 'aapp117' LET g_prog = 'aapt260'
               END CASE
              #No.MOD-BC0264  --End
              #CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno)        #No.FUN-730064  #MOD-CC0253 mark
               CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,l_apb02,'',g_bookno)                   #MOD-CC0253
               RETURNING l_npq.*
               IF cl_null(l_npq.npq04) THEN LET l_npq.npq04 = l_npq04 END IF                      #CHI-CC0022 add
               LET g_prog = p_prog                       #MOD-C30056 add
               CALL s_def_npq31_npq34(l_npq.*,g_bookno) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34    #FUN-AA0087
               CALL t110_chk_aee(l_npq.*)
               RETURNING l_npq.*
               SELECT azi04 INTO t_azi04 FROM azi_file
                 WHERE azi01 = l_npq.npq24
#No.FUN-9A0036 --Begin
               IF p_npptype = '1' THEN
#FUN-A40067 --Begin
                  SELECT aaa03 INTO l_aaa03 FROM aaa_file
                   WHERE aaa01 = g_bookno2
                  SELECT azi04 INTO g_azi04_2 FROM azi_file
                   WHERE azi01 = l_aaa03
#FUN-A40067 --End
                  CALL s_newrate(g_bookno1,g_bookno2,l_npq.npq24,
                                 g_npq25_1,l_npp.npp02)
                  RETURNING l_npq.npq25
                # LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25  #TQC-B80204 mark
                # TQC-B80204 --begin
                  IF l_npq.npq25 = g_npq25_1 AND g_azi04_2 = g_azi04 THEN
                     LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)
                  ELSE
                     LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
                     LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2)
                  END IF
                # TQC-B80204 --end
                # LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2) #FUN-A40067 #TQC-B80204 mark
               ELSE
                  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
               END IF
#No.FUN-9A0036 --End
               LET l_npq.npq07f = cl_digcut(l_npq.npq07f,t_azi04)
#              LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)      #FUN-A40067
             # IF l_aag371 MATCHES '[23]' THEN                       #FUN-950053 mark
               IF l_aag371 MATCHES '[234]' THEN                      #FUN-950053 add     
                  #-->for 合併報表-關係人
                  SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903 FROM pmc_file
                   WHERE pmc01 = l_apa.apa05
                  IF cl_null(l_npq.npq37) THEN
                     IF l_pmc903 = 'Y' THEN
                        LET l_npq.npq37 = l_apa.apa05 CLIPPED   #No.CHI-830037
                     END IF
                  END IF
               END IF
               IF l_aag23 = 'Y' THEN
                  LET l_npq.npq08 = l_apb35
                  LET l_npq.npq35 = l_apb36  #CHI-A30003 add
               ELSE
                  LET l_npq.npq08 = NULL
                  LET l_npq.npq35 = NULL     #CHI-A30003 add
               END IF
              #LET l_npq.npq35 = l_apb36     #CHI-A30003 mark
            SELECT aag21 INTO l_aag21 FROM aag_file
             WHERE aag00 = g_bookno
               AND aag01 = l_npq.npq03               
            IF l_aag21 = 'Y' THEN             #MOD-950096 
               LET l_npq.npq36 = l_apb31 
            END IF                            #MOD-950096    
               LET l_npq.npqlegal = g_legal #FUN-980001 add
               #No.FUN-A30077  --Begin                                          
               CALL t110_entry_direction(g_bookno,l_npq.npq03,l_npq.npq06,      
                                         l_npq.npq07,l_npq.npq07f)              
                    RETURNING l_npq.npq06,l_npq.npq07,l_npq.npq07f              
               #No.FUN-A30077  --End 
#No.FUN-AC0001 --begin                                                          
               IF cl_null(l_npq.npq35) THEN LET l_npq.npq35 = ' ' END IF        
               IF cl_null(l_npq.npq05) THEN LET l_npq.npq05 = ' ' END IF        
               IF cl_null(l_npq.npq08) THEN LET l_npq.npq08 = ' ' END IF        
#No.FUN-AC0001 --end 
              #FUN-D40118 ---Add--- Start
               SELECT aag44 INTO l_aag44 FROM aag_file
                WHERE aag00 = g_bookno3
                  AND aag01 = l_npq.npq03
               IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
                  CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
                  IF l_flag = 'N'   THEN
                     LET l_npq.npq03 = ''
                  END IF
               END IF
              #FUN-D40118 ---Add--- End
               INSERT INTO npq_file VALUES (l_npq.*)
               MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',l_npq.npq07
               IF STATUS THEN 
                  #No.FUN-710014  --Begin
                  IF g_bgerr THEN
                     LET g_showmsg=l_npq.npq01,"/",l_npq.npq011,"/",l_npq.npq02,"/",l_npq.npqsys,"/",l_npq.npq00,"/",l_npq.npqtype
                     CALL s_errmsg("npq01,npq011,npq02,npqsys,npq00,npqtype",g_showmsg,"t110_g_gl(ckp#41)",SQLCA.sqlcode,1)
                  ELSE
                     CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,STATUS,"","t110_g_gl(ckp#41)",1)
                  END IF
                  LET g_success='N'
                  EXIT FOREACH #no.5573
               END IF
            END IF
         END FOREACH
         CALL t110_unap_npq2(p_apno,p_aptype,g_bookno,l_apa.*,'1','1')  #No.TQC-7B0083
      END IF
   END IF
 
   LET l_npq.npq11=''
   LET l_npq.npq12=''
   LET l_npq.npq13=''
   LET l_npq.npq14=''
   LET l_npq.npq31=''
   LET l_npq.npq32=''
   LET l_npq.npq33=''
   LET l_npq.npq34=''
   LET l_npq.npq35=''
   LET l_npq.npq36=''
   LET l_npq.npq37=''
   LET l_npq.npq04=''   #MOD-7B0049
 
   #---->單一借方
   IF p_npptype = '0' THEN  #No.FUN-680029 
      IF NOT cl_null(l_apa.apa51) AND l_apa.apa51 != 'UNAP' AND
         l_apa.apa51 != 'MISC' AND l_apa.apa51 != 'STOCK' THEN
         LET l_npq.npq02 = l_npq.npq02 + 1
            LET l_npq.npq03 = l_apa.apa51
         LET l_npq.npq06 = '1'
        #LET l_npq.npq04 = l_apa.apa25        #FUN-D10065  mark
         LET l_api05f = 0   LET l_api05 = 0
         SELECT SUM(apb101),SUM(apb24) INTO l_api05,l_api05f FROM apb_file
          WHERE apb01=l_apa.apa01 AND (apb34 = 'N' OR apb34 IS NULL ) 
         #C20201227-12628 add  by litty -s
         IF l_apa.apa36 = '103' THEN 
         	  SELECT SUM(apb101),SUM(apb24) INTO l_api05,l_api05f FROM apb_file
          WHERE apb01=l_apa.apa01 AND (apb34 = 'N' OR apb34 IS NULL ) AND apb12<>'MISC'
         END IF 
         #C20201227-12628 add  by litty -E 
         IF cl_null(l_api05f) THEN LET l_api05f = 0 END IF 
         IF cl_null(l_api05 ) THEN LET l_api05  = 0 END IF 
         SELECT COUNT(*) INTO l_cnt1 FROM apb_file
          WHERE apb01=l_apa.apa01
         IF cl_null(l_cnt1) THEN LET l_cnt1 = 0 END IF

         #CHI-A60012 add --start--
         #同時存在入庫、倉退,且應付為0時,可產生借貸相同的的會計金額
         #科目抓取條件不變,金額改為抓取入庫的原幣金額以正負區分借貸
         LET l_apb24_1 = 0  LET l_apb24_3 = 0
         SELECT SUM(apb24),apb29 INTO l_apb24_1,l_apb29_1 FROM apb_file
          WHERE apb01=l_apa.apa01 AND (apb34 = 'N' OR apb34 IS NULL) AND apb29 ='1' GROUP BY apb29
         SELECT SUM(apb24),apb29 INTO l_apb24_3,l_apb29_3 FROM apb_file
          WHERE apb01=l_apa.apa01 AND (apb34 = 'N' OR apb34 IS NULL) AND apb29 ='3'  GROUP BY apb29 
         IF cl_null(l_apb24_1) THEN LET l_apb24_1 = 0 END IF 
         IF cl_null(l_apb24_3) THEN LET l_apb24_3 = 0 END IF 
         IF l_apa.apa57=0 AND l_apb29_1='1' AND l_apb29_3='3' AND l_apb24_1+l_apb24_3=0 THEN
            LET l_apa.apa57 = l_apb24_1
            LET l_api05 = l_apb24_1  #借(本幣)
            LET l_api05f = l_apb24_1 #借(原幣)
            LET l_apa.apa33 = l_apb24_1 * -1  #貸(本幣)
            LET l_apa.apa33f = l_apb24_1 * -1 #貸(原幣)
         END IF
         #CHI-A60012 add --end--
 
         IF l_apa.apa57>0 THEN
            #-----MOD-630131---------
            IF p_aptype = '12' OR p_aptype = '15' OR p_aptype = '13' OR p_aptype = '17' THEN   #No.FUN-690080
               LET l_npq.npq07 = l_apa.apa31
               LET l_npq.npq07f = l_apa.apa31f
               IF p_aptype = '12' THEN
                  SELECT COUNT(*) INTO l_cnt1 FROM apb_file
                   WHERE apb01 = l_apa.apa01
                     AND apb34 = 'Y'
                  IF l_cnt1 > 0 THEN
                     LET l_npq.npq07 = l_api05
                     LET l_npq.npq07f = l_api05f
                  END IF 
               END IF
            ELSE
               IF l_api05f = 0 AND l_api05 = 0 AND l_cnt1 = 0 THEN
                  LET l_npq.npq07 = l_apa.apa31
                  LET l_npq.npq07f = l_apa.apa31f
               ELSE
                  LET l_npq.npq07 = l_api05
                  LET l_npq.npq07f = l_api05f
               END IF
            END IF   #MOD-630131
         ELSE
            LET l_npq.npq07 = l_apa.apa31 - l_api05f    #No.TQC-7B083
            LET l_npq.npq07f = l_apa.apa31f - l_api05f  #No.TQC-7B083
         END IF
 
         SELECT aag05,aag23,aag371 INTO l_aag05,l_aag23,l_aag371   #MOD-750132
           FROM aag_file
          WHERE aag01 = l_npq.npq03
            AND aag00 = g_bookno     #No.FUN-730064
         IF l_aag23='Y' THEN
            LET l_npq.npq08 = l_apa.apa66
         ELSE
            LET l_npq.npq08 = NULL
         END IF
 
         LET l_npq.npq05 = ''   #MOD-B30089 add
         IF l_aag05='Y' THEN
            IF g_aaz.aaz90='N' THEN
               LET l_npq.npq05 = l_apa.apa22
            ELSE
               LET l_npq.npq05 = l_apa.apa930
            END IF
         ELSE
            LET l_npq.npq05 = ''
         END IF
 
         IF p_aptype = '15' OR p_aptype = '17' THEN  LET l_npq.npq23 = l_apa01  END IF   #MOD-5B0213 #No.FUN-690080
         #IF l_npq.npq07 != 0 THEN  #mark by lixwz210302
 	 IF 1=1 THEN #add by lixwz210302
            IF p_aptype[1,1] = '2' THEN
               LET l_npq.npq07 = (-1)*l_npq.npq07                                  
               LET l_npq.npq07f= (-1)*l_npq.npq07f 
            END IF
            LET p_prog = g_prog                       #MOD-C30056 add
            #No.MOD-BC0264  --Begin
            CASE g_prog
                  WHEN 'aapp110' LET g_prog = 'aapt110'
                  WHEN 'aapp111' LET g_prog = 'aapt210'
                  WHEN 'aapp115' LET g_prog = 'aapt160'
                  WHEN 'aapp117' LET g_prog = 'aapt260'
            END CASE
            #No.MOD-BC0264  --End
            CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno)        #No.FUN-730064
            RETURNING l_npq.*
            #FUN-D10065--add--str--
            IF cl_null(l_npq.npq04) THEN
               LET l_npq.npq04 = l_apa.apa25
            END IF
            #FUN-D10065--add--end--
            LET g_prog = p_prog                       #MOD-C30056 add
            CALL s_def_npq31_npq34(l_npq.*,g_bookno) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34  #FUN-AA0087
               CALL t110_chk_aee(l_npq.*)
               RETURNING l_npq.*
            SELECT azi04 INTO t_azi04 FROM azi_file
              WHERE azi01 = l_npq.npq24
#No.FUN-9A0036 --Begin
            IF p_npptype = '1' THEN
#FUN-A40067 --Begin
               SELECT aaa03 INTO l_aaa03 FROM aaa_file
                WHERE aaa01 = g_bookno2
               SELECT azi04 INTO g_azi04_2 FROM azi_file
                WHERE azi01 = l_aaa03
#FUN-A40067 --End
               CALL s_newrate(g_bookno1,g_bookno2,l_npq.npq24,
                              g_npq25_1,l_npp.npp02)
               RETURNING l_npq.npq25
               # LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25  #TQC-B80204 mark
               # TQC-B80204 --begin
               IF l_npq.npq25 = g_npq25_1 AND g_azi04_2 = g_azi04 THEN
                  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)
               ELSE
                  LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
                  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2)
               END IF
               # TQC-B80204 --end
              # LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2) #FUN-A40067  #TQC-B80204 mark
            ELSE
               LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
            END IF
#No.FUN-9A0036 --End
            LET l_npq.npq07f = cl_digcut(l_npq.npq07f,t_azi04)
#           LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)      #FUN-A40067
          # IF l_aag371 MATCHES '[23]' THEN                       #FUN-950053 mark
            IF l_aag371 MATCHES '[234]' THEN                      #FUN-950053 add 
               #-->for 合併報表-關係人
               SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903 FROM pmc_file
                WHERE pmc01 = l_apa.apa05
               IF cl_null(l_npq.npq37) THEN
                  IF l_pmc903 = 'Y' THEN
                     LET l_npq.npq37 = l_apa.apa05 CLIPPED   #No.CHI-830037
                  END IF
               END IF
            END IF
            LET l_npq.npqlegal = g_legal #FUN-980001 add
            #No.FUN-A30077  --Begin                                          
            CALL t110_entry_direction(g_bookno,l_npq.npq03,l_npq.npq06,      
                                      l_npq.npq07,l_npq.npq07f)              
                 RETURNING l_npq.npq06,l_npq.npq07,l_npq.npq07f              
            #No.FUN-A30077  --End 
#No.FUN-AC0001 --begin                                                          
               IF cl_null(l_npq.npq35) THEN LET l_npq.npq35 = ' ' END IF        
               IF cl_null(l_npq.npq05) THEN LET l_npq.npq05 = ' ' END IF        
               IF cl_null(l_npq.npq08) THEN LET l_npq.npq08 = ' ' END IF        
#No.FUN-AC0001 --end 
           #FUN-D40118 ---Add--- Start
            SELECT aag44 INTO l_aag44 FROM aag_file
             WHERE aag00 = g_bookno3
               AND aag01 = l_npq.npq03
            IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
               CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
               IF l_flag = 'N'   THEN
                  LET l_npq.npq03 = ''
               END IF
            END IF
           #FUN-D40118 ---Add--- End
	    IF l_npq.npq07 != 0 THEN #add by lixwz210302 
            INSERT INTO npq_file VALUES (l_npq.*)  
	    END IF #add by lixwz210302
             
             #C200520-11911#1 adds
                 #aapt110生成分录时，外协单据（apa36=103），且单身存在有异动类型=仓退（apb29=3）and 料号=MISC（apb12=MISC）and 金额小于0（apb24/apb10<0）记录时 ,单身单独塞一行
                #C20201208-12628 add by litty-s
                LET l_apb29 = NULL
                LET l_apb12 = NULL
                LET l_apb24 = NULL
                LET l_apb10 = NULL
                #C20201208-12628 add by litty-e 
								DECLARE apb_cs CURSOR FOR
                 SELECT apb29,apb12,apb24,apb10 FROM apb_file WHERE apb01=p_apno
               FOREACH apb_cs INTO l_apb29,l_apb12,l_apb24,l_apb10
                  IF l_apa.apa36='103' AND l_apb29='3' AND l_apb12='MISC' AND l_apb24<0 AND l_apb10<0 THEN
                   LET l_npq.npq03=''
                   LET l_npq.npq05='' 
                   LET l_npq.npq06=''
                   LET l_npq.npq02=l_npq.npq02+1 
                   LET l_npq.npq07=l_apb24
                   LET l_npq.npq07f=l_apb24 
                   INSERT INTO npq_file VALUES (l_npq.*)
                  END IF
               END FOREACH                 
                #C200520-11911#1 adde  
                
            MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',l_npq.npq07
            IF STATUS THEN
               IF g_bgerr THEN
                  LET g_showmsg=l_npq.npq01,"/",l_npq.npq011,"/",l_npq.npq02,"/",l_npq.npqsys,"/",l_npq.npq00,"/",l_npq.npqtype
                  CALL s_errmsg("npq01,npq011,npq02,npqsys,npq00,npqtype",g_showmsg,"t110_g_gl(ckp#1)",SQLCA.sqlcode,1)
               ELSE
                  CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,STATUS,"","t110_g_gl(ckp#1)",1)  #No.FUN-660122
               END IF
               LET g_success='N' #no.5573
            END IF
         END IF
         CALL t110_unap_npq2(p_apno,p_aptype,g_bookno,l_apa.*,'0','1')  #No.TQC-7B0083
      END IF
   ELSE
      IF NOT cl_null(l_apa.apa511) AND l_apa.apa511 != 'UNAP' AND
         l_apa.apa511 != 'MISC' AND l_apa.apa511 != 'STOCK' THEN
         LET l_npq.npq02 = l_npq.npq02 + 1
            LET l_npq.npq03 = l_apa.apa511
         LET l_npq.npq06 = '1'
        #LET l_npq.npq04 = l_apa.apa25      #FUN-D10065 mark
 
         #apa51中的值要去掉衝暫估金額,衝暫估金額要獨立insert npq
         LET l_api05f = 0   LET l_api05 = 0
         SELECT SUM(apb101),SUM(apb24) INTO l_api05,l_api05f FROM apb_file
          WHERE apb01=l_apa.apa01 AND (apb34 = 'N' OR apb34 IS NULL)
         IF cl_null(l_api05f) THEN LET l_api05f = 0 END IF 
         IF cl_null(l_api05 ) THEN LET l_api05  = 0 END IF 
         SELECT COUNT(*) INTO l_cnt1 FROM apb_file
          WHERE apb01=l_apa.apa01
         IF cl_null(l_cnt1) THEN LET l_cnt1 = 0 END IF
 
         IF l_apa.apa57>0 THEN
            IF p_aptype = '12' OR p_aptype = '15' OR p_aptype = '13' OR p_aptype = '17' THEN  #No.FUN-690080
               LET l_npq.npq07 = l_apa.apa31 
               LET l_npq.npq07f = l_apa.apa31f
               IF p_aptype = '12' THEN
                  SELECT COUNT(*) INTO l_cnt1 FROM apb_file
                   WHERE apb01 = l_apa.apa01
                     AND apb34 = 'Y'
                  IF l_cnt1 > 0 THEN
                     LET l_npq.npq07 = l_api05
                     LET l_npq.npq07f = l_api05f
                  END IF 
               END IF
            ELSE
               IF l_api05f = 0 AND l_api05 = 0 AND l_cnt1 = 0 THEN
                  LET l_npq.npq07 = l_apa.apa31
                  LET l_npq.npq07f = l_apa.apa31f
               ELSE
                  LET l_npq.npq07 = l_api05
                  LET l_npq.npq07f = l_api05f
               END IF
            END IF 
         ELSE
            LET l_npq.npq07 = l_apa.apa31 - l_api05      #No.TQC-7B0083
            LET l_npq.npq07f = l_apa.apa31f - l_api05f   #No.TQC-7B0083
         END IF
 
         SELECT aag05,aag23,aag371 INTO l_aag05,l_aag23,l_aag371   #MOD-750132
           FROM aag_file
          WHERE aag01 = l_npq.npq03
            AND aag00 = g_bookno     #No.FUN-730064
         IF l_aag23='Y' THEN
            LET l_npq.npq08 = l_apa.apa66
         ELSE
            LET l_npq.npq08 = NULL
         END IF
 
         LET l_npq.npq05 = ''   #MOD-B30089 add
         IF l_aag05='Y' THEN
            IF g_aaz.aaz90='N' THEN
               LET l_npq.npq05 = l_apa.apa22
            ELSE
               LET l_npq.npq05 = l_apa.apa930
            END IF
         ELSE
            LET l_npq.npq05 = ''
         END IF
 
         IF p_aptype = '15' OR p_aptype = '17' THEN  LET l_npq.npq23 = l_apa01  END IF  #No.FUN-690080
         IF l_npq.npq07 != 0 THEN 
            IF p_aptype[1,1] = '2' THEN
               LET l_npq.npq07 = (-1)*l_npq.npq07                                  
               LET l_npq.npq07f= (-1)*l_npq.npq07f 
            END IF
            LET p_prog = g_prog                       #MOD-C30056 add 
            #No.MOD-BC0264  --Begin
            CASE g_prog
                  WHEN 'aapp110' LET g_prog = 'aapt110'
                  WHEN 'aapp111' LET g_prog = 'aapt210'
                  WHEN 'aapp115' LET g_prog = 'aapt160'
                  WHEN 'aapp117' LET g_prog = 'aapt260'
            END CASE
            #No.MOD-BC0264  --End
            CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno)        #No.FUN-730064
            RETURNING l_npq.*
            #FUN-D10065--add--str--
            IF cl_null(l_npq.npq04) THEN
               LET l_npq.npq04 = l_apa.apa25
            END IF
            #FUN-D10065--add--end--
            LET g_prog = p_prog                       #MOD-C30056 add
            CALL s_def_npq31_npq34(l_npq.*,g_bookno) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34     #FUN-AA0087
               CALL t110_chk_aee(l_npq.*)
               RETURNING l_npq.*
            SELECT azi04 INTO t_azi04 FROM azi_file
              WHERE azi01 = l_npq.npq24
#No.FUN-9A0036 --Begin
            IF p_npptype = '1' THEN
#FUN-A40067 --Begin
               SELECT aaa03 INTO l_aaa03 FROM aaa_file
                WHERE aaa01 = g_bookno2
               SELECT azi04 INTO g_azi04_2 FROM azi_file
                WHERE azi01 = l_aaa03
#FUN-A40067 --End
               CALL s_newrate(g_bookno1,g_bookno2,l_npq.npq24,
                              g_npq25_1,l_npp.npp02)
               RETURNING l_npq.npq25
               # LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25  #TQC-B80204 mark
              # TQC-B80204 --begin
               IF l_npq.npq25 = g_npq25_1 AND g_azi04_2 = g_azi04 THEN
                  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)
               ELSE
                  LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
                  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2)
               END IF
             # TQC-B80204 --end
             #  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2) #FUN-A40067  #TQC-B80204 mark
            ELSE
               LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
            END IF
#No.FUN-9A0036 --End
            LET l_npq.npq07f = cl_digcut(l_npq.npq07f,t_azi04)
#           LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)      #FUN-A40067
          # IF l_aag371 MATCHES '[23]' THEN                       #FUN-950053 mark
            IF l_aag371 MATCHES '[234]' THEN                      #FUN-950053 add  
               #-->for 合併報表-關係人
               SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903 FROM pmc_file
                WHERE pmc01 = l_apa.apa05
               IF cl_null(l_npq.npq37) THEN 
                  IF l_pmc903 = 'Y' THEN
                     LET l_npq.npq37 = l_apa.apa05 CLIPPED   #No.CHI-830037
                  END IF
               END IF
            END IF
            LET l_npq.npqlegal = g_legal #FUN-980001 add
            #No.FUN-A30077  --Begin                                          
            CALL t110_entry_direction(g_bookno,l_npq.npq03,l_npq.npq06,      
                                      l_npq.npq07,l_npq.npq07f)              
                 RETURNING l_npq.npq06,l_npq.npq07,l_npq.npq07f              
            #No.FUN-A30077  --End 
#No.FUN-AC0001 --begin                                                          
               IF cl_null(l_npq.npq35) THEN LET l_npq.npq35 = ' ' END IF        
               IF cl_null(l_npq.npq05) THEN LET l_npq.npq05 = ' ' END IF        
               IF cl_null(l_npq.npq08) THEN LET l_npq.npq08 = ' ' END IF        
#No.FUN-AC0001 --end 
           #FUN-D40118 ---Add--- Start
            SELECT aag44 INTO l_aag44 FROM aag_file
             WHERE aag00 = g_bookno3
               AND aag01 = l_npq.npq03
            IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
               CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
               IF l_flag = 'N'   THEN
                  LET l_npq.npq03 = ''
               END IF
            END IF
           #FUN-D40118 ---Add--- End
            INSERT INTO npq_file VALUES (l_npq.*)
            MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',l_npq.npq07
            IF STATUS THEN
               IF g_bgerr THEN
                  LET g_showmsg=l_npq.npq01,"/",l_npq.npq011,"/",l_npq.npq02,"/",l_npq.npqsys,"/",l_npq.npq00,"/",l_npq.npqtype
                  CALL s_errmsg("npq01,npq011,npq02,npqsys,npq00,npqtype",g_showmsg,"t110_g_gl(ckp#1)",SQLCA.sqlcode,1)
               ELSE
                  CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,STATUS,"","t110_g_gl(ckp#1)",1)
               END IF
               LET g_success='N'
            END IF
         END IF
         CALL t110_unap_npq2(p_apno,p_aptype,g_bookno,l_apa.*,'1','1')  #No.TQC-7B0083
      END IF
   END IF
 
   LET l_npq.npq11=''
   LET l_npq.npq12=''
   LET l_npq.npq13=''
   LET l_npq.npq14=''
   LET l_npq.npq31=''
   LET l_npq.npq32=''
   LET l_npq.npq33=''
   LET l_npq.npq34=''
   LET l_npq.npq35=''
   LET l_npq.npq36=''
   LET l_npq.npq37=''
   LET l_npq.npq23 = l_apa.apa01   #MOD-5B0213
   LET l_npq.npq04=''   #MOD-7B0049
 
   #-----------------------------------( Dr: VAT tax        )---------------------
   IF l_apa.apa08 ='MISC' THEN
     # No.MOD-BB0100  --Begin
     #  SELECT SUM(apk07),SUM(apk07f) INTO amt2,amt4 FROM apk_file     #No.MOD-530051
     #  WHERE apk01 = l_apa.apa01
     #    AND apk171 = '23'
 
     # IF cl_null(amt2) OR g_aza.aza26 = '2' THEN LET amt2=0 END IF #MOD-BA0042 add aza26
 
     # IF cl_null(amt4) OR g_aza.aza26 = '2' THEN LET amt4=0 END IF      #No:MOD-530051 #MOD-BA0042 add aza26
 
     # LET amt1=l_apa.apa32+amt2
     #  LET amt3=l_apa.apa32f+amt4                   #No.MOD-530051
      LET amt1=l_apa.apa32
      LET amt3=l_apa.apa32f
     # No.MOD-BB0100  --End
      IF p_npptype = '0' THEN  #No.FUN-680029 
         LET l_npq.npq03 = l_apa.apa52
      ELSE
         LET l_npq.npq03 = l_apa.apa521
      END IF
 
      IF amt1 <> 0 THEN
         LET l_npq.npq02 = l_npq.npq02 + 1
         LET l_npq.npq06 = '1'
         LET l_npq.npq07 = amt1
          LET l_npq.npq07f= amt3                  #No.MOD-530051
         SELECT aag05,aag23,aag371 INTO l_aag05,l_aag23,l_aag371 FROM aag_file   #CHI-760007
          WHERE aag01=l_npq.npq03
            AND aag00 = g_bookno     #No.FUN-730064
         IF l_aag23='Y' THEN 
            LET l_npq.npq08 = l_apa.apa66 
         ELSE 
            LET l_npq.npq08 = null
         END IF
 
         LET l_npq.npq05 = ''   #MOD-B30089 add
         IF l_aag05='Y' THEN
            IF g_aaz.aaz90='N' THEN
               LET l_npq.npq05 = l_apa.apa22
            ELSE
               LET l_npq.npq05 = l_apa.apa930
            END IF
         ELSE
            LET l_npq.npq05 = ''           
         END IF
 
         IF p_aptype[1,1] = '2' THEN
            LET l_npq.npq07 = (-1)*l_npq.npq07                                  
            LET l_npq.npq07f= (-1)*l_npq.npq07f 
         END IF
         LET p_prog = g_prog                       #MOD-C30056 add 
         #No.MOD-BC0264  --Begin
         CASE g_prog
                  WHEN 'aapp110' LET g_prog = 'aapt110'
                  WHEN 'aapp111' LET g_prog = 'aapt210'
                  WHEN 'aapp115' LET g_prog = 'aapt160'
                  WHEN 'aapp117' LET g_prog = 'aapt260'
         END CASE
         #No.MOD-BC0264  --End
         CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno)        #No.FUN-730064
         RETURNING l_npq.*
         #FUN-D10065--add--str--
            IF cl_null(l_npq.npq04) THEN
               LET l_npq.npq04 = l_apa.apa25
            END IF
            #FUN-D10065--add--end--
         LET g_prog = p_prog                       #MOD-C30056 add
         CALL s_def_npq31_npq34(l_npq.*,g_bookno) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34    #FUN-AA0087
               CALL t110_chk_aee(l_npq.*)
               RETURNING l_npq.*
         SELECT azi04 INTO t_azi04 FROM azi_file
           WHERE azi01 = l_npq.npq24
#No.FUN-9A0036 --Begin
            IF p_npptype = '1' THEN
#FUN-A40067 --Begin
               SELECT aaa03 INTO l_aaa03 FROM aaa_file
                WHERE aaa01 = g_bookno2
               SELECT azi04 INTO g_azi04_2 FROM azi_file
                WHERE azi01 = l_aaa03
#FUN-A40067 --End
               CALL s_newrate(g_bookno1,g_bookno2,l_npq.npq24,
                              g_npq25_1,l_npp.npp02)
               RETURNING l_npq.npq25
               # LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25  #TQC-B80204 mark
              # TQC-B80204 --begin
               IF l_npq.npq25 = g_npq25_1 AND g_azi04_2 = g_azi04 THEN
                  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)
               ELSE
                  LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
                  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2)
               END IF
              # TQC-B80204 --end
              # LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2) #FUN-A40067 #TQC-B80204 mark
            ELSE
               LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
            END IF
#No.FUN-9A0036 --End
         LET l_npq.npq07f = cl_digcut(l_npq.npq07f,t_azi04)
#        LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)         #FUN-A40067
       # IF l_aag371 MATCHES '[23]' THEN                          #FUN-950053 mark
         IF l_aag371 MATCHES '[234]' THEN                         #FUN-950053 add     
            #-->for 合併報表-關係人
            SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903
              FROM pmc_file
             WHERE pmc01 = l_apa.apa05
            IF cl_null(l_npq.npq37) THEN
               IF l_pmc903 = 'Y' THEN
                  LET l_npq.npq37 = l_apa.apa05 CLIPPED   #No.CHI-830037
               END IF
            END IF
         END IF
         LET l_npq.npqlegal = g_legal #FUN-980001 add
         #No.FUN-A30077  --Begin                                          
         CALL t110_entry_direction(g_bookno,l_npq.npq03,l_npq.npq06,      
                                   l_npq.npq07,l_npq.npq07f)              
              RETURNING l_npq.npq06,l_npq.npq07,l_npq.npq07f              
         #No.FUN-A30077  --End 
#No.FUN-AC0001 --begin                                                          
               IF cl_null(l_npq.npq35) THEN LET l_npq.npq35 = ' ' END IF        
               IF cl_null(l_npq.npq05) THEN LET l_npq.npq05 = ' ' END IF        
               IF cl_null(l_npq.npq08) THEN LET l_npq.npq08 = ' ' END IF        
#No.FUN-AC0001 --end 
        #FUN-D40118 ---Add--- Start
         SELECT aag44 INTO l_aag44 FROM aag_file
          WHERE aag00 = g_bookno3
            AND aag01 = l_npq.npq03
         IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
            CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET l_npq.npq03 = ''
            END IF
         END IF
        #FUN-D40118 ---Add--- End
         INSERT INTO npq_file VALUES (l_npq.*)
         IF STATUS THEN
            IF g_bgerr THEN
               LET g_showmsg=l_npq.npq01,"/",l_npq.npq011,"/",l_npq.npq02,"/",l_npq.npqsys,"/",l_npq.npq00,"/",l_npq.npqtype
               CALL s_errmsg("npq01,npq011,npq02,npqsys,npq00,npqtype",g_showmsg,"t110_g_gl(ckp#2)",SQLCA.sqlcode,1)
            ELSE
               CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,STATUS,"","t110_g_gl(ckp#2)",1)  #No.FUN-660122
            END IF
            LET g_success='N' 
         END IF
      END IF
 
      IF amt2 <> 0 THEN
         LET l_npq.npq02 = l_npq.npq02 + 1
         LET l_npq.npq06 = '2'
         LET l_npq.npq07 = amt2
         LET l_npq.npq07f= amt2
 
         SELECT aag05,aag23,aag371 INTO l_aag05,l_aag23,l_aag371 FROM aag_file   #CHI-760007
          WHERE aag01=l_npq.npq03
            AND aag00 = g_bookno     #No.FUN-730064
 
         IF l_aag23='Y' THEN 
            LET l_npq.npq08 = l_apa.apa66 
         ELSE 
            LET l_npq.npq08 = null
         END IF
 
         LET l_npq.npq05 = ''   #MOD-B30089 add
         IF l_aag05='Y' THEN
            IF g_aaz.aaz90='N' THEN
               LET l_npq.npq05 = l_apa.apa22
            ELSE
               LET l_npq.npq05 = l_apa.apa930
            END IF
         ELSE
            LET l_npq.npq05 = ''           
         END IF
 
         IF p_aptype[1,1] = '2' THEN
            LET l_npq.npq07 = (-1)*l_npq.npq07                                  
            LET l_npq.npq07f= (-1)*l_npq.npq07f 
         END IF
         LET p_prog = g_prog                       #MOD-C30056 add 
         #No.MOD-BC0264  --Begin
         CASE g_prog
                  WHEN 'aapp110' LET g_prog = 'aapt110'
                  WHEN 'aapp111' LET g_prog = 'aapt210'
                  WHEN 'aapp115' LET g_prog = 'aapt160'
                  WHEN 'aapp117' LET g_prog = 'aapt260'
         END CASE
         #No.MOD-BC0264  --End
         CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno)          #No.FUN-730064
         RETURNING l_npq.*
         #FUN-D10065--add--str--
         IF cl_null(l_npq.npq04) THEN
            LET l_npq.npq04 = ''
         END IF
         #FUN-D10065--add--end--
         LET g_prog = p_prog                       #MOD-C30056 add
         CALL s_def_npq31_npq34(l_npq.*,g_bookno) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34     #FUN-AA0087
               CALL t110_chk_aee(l_npq.*)
               RETURNING l_npq.*
         SELECT azi04 INTO t_azi04 FROM azi_file
           WHERE azi01 = l_npq.npq24
#No.FUN-9A0036 --Begin
            IF p_npptype = '1' THEN
#FUN-A40067 --Begin
               SELECT aaa03 INTO l_aaa03 FROM aaa_file
                WHERE aaa01 = g_bookno2
               SELECT azi04 INTO g_azi04_2 FROM azi_file
                WHERE azi01 = l_aaa03
#FUN-A40067 --End
               CALL s_newrate(g_bookno1,g_bookno2,l_npq.npq24,
                              g_npq25_1,l_npp.npp02)
               RETURNING l_npq.npq25
              # LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25  #TQC-B80204 mark
              # TQC-B80204 --begin
               IF l_npq.npq25 = g_npq25_1 AND g_azi04_2 = g_azi04 THEN
                  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)
               ELSE
                  LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
                  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2)
               END IF
              # TQC-B80204 --end
              # LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2) #FUN-A40067  #TQC-B80204 mark
            ELSE
               LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
            END IF
#No.FUN-9A0036 --End
         LET l_npq.npq07f = cl_digcut(l_npq.npq07f,t_azi04)
#        LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)         #FUN-A40067
       # IF l_aag371 MATCHES '[23]' THEN                          #FUN-950053 mark
         IF l_aag371 MATCHES '[234]' THEN                         #FUN-950053 add   
            #-->for 合併報表-關係人
            SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903
              FROM pmc_file
             WHERE pmc01 = l_apa.apa05
            IF cl_null(l_npq.npq37) THEN
               IF l_pmc903 = 'Y' THEN
                  LET l_npq.npq37 = l_apa.apa05 CLIPPED   #No.CHI-830037
               END IF
            END IF
         END IF
         LET l_npq.npqlegal = g_legal #FUN-980001 add
         #No.FUN-A30077  --Begin                                          
         CALL t110_entry_direction(g_bookno,l_npq.npq03,l_npq.npq06,      
                                   l_npq.npq07,l_npq.npq07f)              
              RETURNING l_npq.npq06,l_npq.npq07,l_npq.npq07f              
         #No.FUN-A30077  --End 
#No.FUN-AC0001 --begin                                                          
               IF cl_null(l_npq.npq35) THEN LET l_npq.npq35 = ' ' END IF        
               IF cl_null(l_npq.npq05) THEN LET l_npq.npq05 = ' ' END IF        
               IF cl_null(l_npq.npq08) THEN LET l_npq.npq08 = ' ' END IF        
#No.FUN-AC0001 --end 
        #FUN-D40118 ---Add--- Start
         SELECT aag44 INTO l_aag44 FROM aag_file
          WHERE aag00 = g_bookno3
            AND aag01 = l_npq.npq03
         IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
            CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET l_npq.npq03 = ''
            END IF
         END IF
        #FUN-D40118 ---Add--- End
         INSERT INTO npq_file VALUES (l_npq.*)
         IF STATUS THEN
            IF g_bgerr THEN
               LET g_showmsg=l_npq.npq01,"/",l_npq.npq011,"/",l_npq.npq02,"/",l_npq.npqsys,"/",l_npq.npq00,"/",l_npq.npqtype
               CALL s_errmsg("npq01,npq011,npq02,npqsys,npq00,npqtype",g_showmsg,"t110_g_gl(ckp#2)",SQLCA.sqlcode,1)
            ELSE
               CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,STATUS,"","t110_g_gl(ckp#2)",1)  #No.FUN-660122
            END IF
            LET g_success='N'
         END IF
      END IF
   END IF
 
   LET l_npq.npq11=''
   LET l_npq.npq12=''
   LET l_npq.npq13=''
   LET l_npq.npq14=''
   LET l_npq.npq31=''
   LET l_npq.npq32=''
   LET l_npq.npq33=''
   LET l_npq.npq34=''
   LET l_npq.npq35=''
   LET l_npq.npq36=''
   LET l_npq.npq37=''
 
   IF l_apa.apa08 <>'MISC' AND l_apa.apa32 > 0 THEN
      LET l_npq.npq02 = l_npq.npq02 + 1
      IF p_npptype = '0' THEN  #No.FUN-680029
         LET l_npq.npq03 = l_apa.apa52
      ELSE
         LET l_npq.npq03 = l_apa.apa521
      END IF
      LET l_npq.npq04 = NULL
      LET l_npq.npq06 = '1'
  
     #FUN-D10065---mark--str 
     #IF (p_aptype = '12' OR p_aptype = '13') AND g_apz.apz54 = '1' THEN  #No.FUN-690080
     #   LET l_npq.npq04 = l_apa.apa07 CLIPPED,' ',l_apa.apa08 CLIPPED,' ',
     #                     l_apa.apa09
     #END IF
     #FUN-D10065---mark--end
      LET l_npq.npq07 = l_apa.apa32
      LET l_npq.npq07f= l_apa.apa32f
      SELECT aag05,aag23,aag371 INTO l_aag05,l_aag23,l_aag371 FROM aag_file   #CHI-760007
       WHERE aag01=l_npq.npq03
         AND aag00 = g_bookno     #No.FUN-730064
      IF l_aag23='Y' THEN 
         LET l_npq.npq08 = l_apa.apa66 
      ELSE 
         LET l_npq.npq08 = null
      END IF
      LET l_npq.npq05 = ''   #MOD-B30089 add
      IF l_aag05='Y' THEN
         IF g_aaz.aaz90='N' THEN
            LET l_npq.npq05 = l_apa.apa22
         ELSE
            LET l_npq.npq05 = l_apa.apa930
         END IF
      ELSE
         LET l_npq.npq05 = ''           
      END IF
      IF l_npq.npq07!=0 THEN
         IF p_aptype[1,1] = '2' THEN
            LET l_npq.npq07 = (-1)*l_npq.npq07                                  
            LET l_npq.npq07f= (-1)*l_npq.npq07f 
         END IF
         LET p_prog = g_prog                       #MOD-C30056 add 
         #No.MOD-BC0264  --Begin
         CASE g_prog
                  WHEN 'aapp110' LET g_prog = 'aapt110'
                  WHEN 'aapp111' LET g_prog = 'aapt210'
                  WHEN 'aapp115' LET g_prog = 'aapt160'
                  WHEN 'aapp117' LET g_prog = 'aapt260'
         END CASE
         #No.MOD-BC0264  --End
         CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno)         #No.FUN-730064
         RETURNING l_npq.*
         #FUN-D10065--add--str--
         IF cl_null(l_npq.npq04) THEN
            IF (p_aptype = '12' OR p_aptype = '13') AND g_apz.apz54 = '1' THEN
               LET l_npq.npq04 = l_apa.apa07 CLIPPED,' ',l_apa.apa08 CLIPPED,' ',
                                 l_apa.apa09
            END IF
         END IF
         #FUN-D10065--add--end--
         LET g_prog = p_prog                       #MOD-C30056 add
         CALL s_def_npq31_npq34(l_npq.*,g_bookno) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34       #FUN-AA0087
           CALL t110_chk_aee(l_npq.*)
           RETURNING l_npq.*
         SELECT azi04 INTO t_azi04 FROM azi_file
           WHERE azi01 = l_npq.npq24
#No.FUN-9A0036 --Begin
            IF p_npptype = '1' THEN
#FUN-A40067 --Begin
               SELECT aaa03 INTO l_aaa03 FROM aaa_file
                WHERE aaa01 = g_bookno2
               SELECT azi04 INTO g_azi04_2 FROM azi_file
                WHERE azi01 = l_aaa03
#FUN-A40067 --End
               CALL s_newrate(g_bookno1,g_bookno2,l_npq.npq24,
                              g_npq25_1,l_npp.npp02)
               RETURNING l_npq.npq25
              # LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25  #TQC-B80204 mark
              # TQC-B80204 --begin
               IF l_npq.npq25 = g_npq25_1 AND g_azi04_2 = g_azi04 THEN
                  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)
               ELSE
                  LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
                  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2)
               END IF
              # TQC-B80204 --end
              # LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2) #FUN-A40067  #TQC-B80204  mark
            ELSE
               LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
            END IF
#No.FUN-9A0036 --End
         LET l_npq.npq07f = cl_digcut(l_npq.npq07f,t_azi04)
#        LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)         #FUN-A40067
       # IF l_aag371 MATCHES '[23]' THEN                          #FUN-950053 mark
         IF l_aag371 MATCHES '[234]' THEN                         #FUN-950053 add  
            #-->for 合併報表-關係人
            SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903
              FROM pmc_file
             WHERE pmc01 = l_apa.apa05
            IF cl_null(l_npq.npq37) THEN
               IF l_pmc903 = 'Y' THEN
                  LET l_npq.npq37 = l_apa.apa05 CLIPPED   #No.CHI-830037
               END IF
            END IF
         END IF
         LET l_npq.npqlegal = g_legal #FUN-980001 add
         #No.FUN-A30077  --Begin                                          
         CALL t110_entry_direction(g_bookno,l_npq.npq03,l_npq.npq06,      
                                   l_npq.npq07,l_npq.npq07f)              
              RETURNING l_npq.npq06,l_npq.npq07,l_npq.npq07f              
         #No.FUN-A30077  --End 
#No.FUN-AC0001 --begin                                                          
               IF cl_null(l_npq.npq35) THEN LET l_npq.npq35 = ' ' END IF        
               IF cl_null(l_npq.npq05) THEN LET l_npq.npq05 = ' ' END IF        
               IF cl_null(l_npq.npq08) THEN LET l_npq.npq08 = ' ' END IF        
#No.FUN-AC0001 --end 
        #FUN-D40118 ---Add--- Start
         SELECT aag44 INTO l_aag44 FROM aag_file
          WHERE aag00 = g_bookno3
            AND aag01 = l_npq.npq03
         IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
            CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET l_npq.npq03 = ''
            END IF
         END IF
        #FUN-D40118 ---Add--- End
         INSERT INTO npq_file VALUES (l_npq.*)
         MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',l_npq.npq07
         IF SQLCA.sqlcode THEN 
            IF g_bgerr THEN
               LET g_showmsg=l_npq.npq01,"/",l_npq.npq011,"/",l_npq.npq02,"/",l_npq.npqsys,"/",l_npq.npq00,"/",l_npq.npqtype
               CALL s_errmsg("npq01,npq011,npq02,npqsys,npq00,npqtype",g_showmsg,"t110_g_gl(ckp#2)",SQLCA.sqlcode,1)
            ELSE
               CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,SQLCA.sqlcode,"","t110_g_gl(ckp#2)",1)  #No.FUN-660122
            END IF
            LET g_success='N' #no.5573
         END IF
      END IF
   END IF
#-----------------------------------( Cr: VAT tax allowan)---------------------
   LET l_npq.npq11=''
   LET l_npq.npq12=''
   LET l_npq.npq13=''
   LET l_npq.npq14=''
   LET l_npq.npq31=''
   LET l_npq.npq32=''
   LET l_npq.npq33=''
   LET l_npq.npq34=''
   LET l_npq.npq35=''
   LET l_npq.npq36=''
   LET l_npq.npq37=''
   LET l_npq.npq04=''   #MOD-7B0049
   IF l_apa.apa61 > 0 THEN
      LET l_npq.npq02 = l_npq.npq02 + 1
      IF p_npptype = '0' THEN  #No.FUN-680029
         LET l_npq.npq03 = l_apa.apa52
      ELSE
         LET l_npq.npq03 = l_apa.apa521
      END IF
      LET l_npq.npq06 = '2'
      LET l_npq.npq07 = l_apa.apa61
      LET l_npq.npq07f= l_apa.apa61f
      SELECT aag05,aag23,aag371 INTO l_aag05,l_aag23,l_aag371 FROM aag_file   #CHI-760007
       WHERE aag01=l_npq.npq03
         AND aag00 = g_bookno     #No.FUN-730064
      IF l_aag23='Y' THEN 
         LET l_npq.npq08 = l_apa.apa66 
      ELSE 
         LET l_npq.npq08 = null
      END IF
      LET l_npq.npq05 = ''   #MOD-B30089 add
      IF l_aag05='Y' THEN
         IF g_aaz.aaz90='N' THEN
            LET l_npq.npq05 = l_apa.apa22
         ELSE
            LET l_npq.npq05 = l_apa.apa930
         END IF
      ELSE
         LET l_npq.npq05 = ''           
      END IF
      IF l_npq.npq07!=0 THEN
         IF p_aptype[1,1] = '2' THEN
            LET l_npq.npq07 = (-1)*l_npq.npq07                                  
            LET l_npq.npq07f= (-1)*l_npq.npq07f 
         END IF
         LET p_prog = g_prog                       #MOD-C30056 add
         #No.MOD-BC0264  --Begin
         CASE g_prog
                  WHEN 'aapp110' LET g_prog = 'aapt110'
                  WHEN 'aapp111' LET g_prog = 'aapt210'
                  WHEN 'aapp115' LET g_prog = 'aapt160'
                  WHEN 'aapp117' LET g_prog = 'aapt260'
         END CASE
         #No.MOD-BC0264  --End
         CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno)        #No.FUN-730064
         RETURNING l_npq.*
         LET g_prog = p_prog                       #MOD-C30056 add
         CALL s_def_npq31_npq34(l_npq.*,g_bookno) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34     #FUN-AA0087
               CALL t110_chk_aee(l_npq.*)
               RETURNING l_npq.*
         SELECT azi04 INTO t_azi04 FROM azi_file
           WHERE azi01 = l_npq.npq24
#No.FUN-9A0036 --Begin
            IF p_npptype = '1' THEN
#FUN-A40067 --Begin
               SELECT aaa03 INTO l_aaa03 FROM aaa_file
                WHERE aaa01 = g_bookno2
               SELECT azi04 INTO g_azi04_2 FROM azi_file
                WHERE azi01 = l_aaa03
#FUN-A40067 --End
               CALL s_newrate(g_bookno1,g_bookno2,l_npq.npq24,
                              g_npq25_1,l_npp.npp02)
               RETURNING l_npq.npq25
              # LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25  #TQC-B80204 mark
              # TQC-B80204 --begin
               IF l_npq.npq25 = g_npq25_1 AND g_azi04_2 = g_azi04 THEN
                  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)
               ELSE
                  LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
                  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2)
               END IF
              # TQC-B80204 --end
              # LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2) #FUN-A40067  #TQC-B80204 mark
            ELSE
               LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
            END IF
#No.FUN-9A0036 --End
         LET l_npq.npq07f = cl_digcut(l_npq.npq07f,t_azi04)
#        LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)         #FUN-A40067
       # IF l_aag371 MATCHES '[23]' THEN                          #FUN-950053 mark
         IF l_aag371 MATCHES '[234]' THEN                         #FUN-950053 add  
            #-->for 合併報表-關係人
            SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903
              FROM pmc_file
             WHERE pmc01 = l_apa.apa05
            IF cl_null(l_npq.npq37) THEN
               IF l_pmc903 = 'Y' THEN
                  LET l_npq.npq37 = l_apa.apa05 CLIPPED   #No.CHI-830037
               END IF
            END IF
         END IF
         LET l_npq.npqlegal = g_legal #FUN-980001 add
         #No.FUN-A30077  --Begin                                          
         CALL t110_entry_direction(g_bookno,l_npq.npq03,l_npq.npq06,      
                                   l_npq.npq07,l_npq.npq07f)              
              RETURNING l_npq.npq06,l_npq.npq07,l_npq.npq07f              
         #No.FUN-A30077  --End 
#No.FUN-AC0001 --begin                                                          
               IF cl_null(l_npq.npq35) THEN LET l_npq.npq35 = ' ' END IF        
               IF cl_null(l_npq.npq05) THEN LET l_npq.npq05 = ' ' END IF        
               IF cl_null(l_npq.npq08) THEN LET l_npq.npq08 = ' ' END IF        
#No.FUN-AC0001 --end 
        #FUN-D40118 ---Add--- Start
         SELECT aag44 INTO l_aag44 FROM aag_file
          WHERE aag00 = g_bookno3
            AND aag01 = l_npq.npq03
         IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
            CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET l_npq.npq03 = ''
            END IF
         END IF
        #FUN-D40118 ---Add--- End
         INSERT INTO npq_file VALUES (l_npq.*)
         MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',l_npq.npq07
         IF SQLCA.sqlcode THEN 
            IF g_bgerr THEN
               LET g_showmsg=l_npq.npq01,"/",l_npq.npq011,"/",l_npq.npq02,"/",l_npq.npqsys,"/",l_npq.npq00,"/",l_npq.npqtype
               CALL s_errmsg("npq01,npq011,npq02,npqsys,npq00,npqtype",g_showmsg,"t110_g_gl(ckp#2)",SQLCA.sqlcode,1)
            ELSE
               CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,SQLCA.sqlcode,"","t110_g_gl(ckp#2)",1)  #No.FUN-660122
            END IF
            LET g_success='N' #no.5573
         END IF
      END IF
   END IF
#-----------------------------------( Dr/Cr: Difference  )---------------------
   LET l_npq.npq11=''
   LET l_npq.npq12=''
   LET l_npq.npq13=''
   LET l_npq.npq14=''
   LET l_npq.npq31=''
   LET l_npq.npq32=''
   LET l_npq.npq33=''
   LET l_npq.npq34=''
   LET l_npq.npq35=''
   LET l_npq.npq36=''
   LET l_npq.npq37=''
   LET l_npq.npq04=''   #MOD-7B0049
 
   IF l_apa.apa57>0 AND l_apa.apa33 != 0 AND l_apa.apa56 != '3' THEN
      LET l_npq.npq02 = l_npq.npq02 + 1
      IF l_apa.apa56 = '2' THEN 
         IF p_npptype = '0' THEN  #No.FUN-680029
            LET l_npq.npq03 = l_apa.apa53
         ELSE
            LET l_npq.npq03 = l_apa.apa531
         END IF
      ELSE
         IF l_apa.apa56 != '1' THEN   #No.MOD-530463
            IF p_npptype = '0' THEN  #No.FUN-680029
               LET l_npq.npq03 = l_apa.apa51
            ELSE
               LET l_npq.npq03 = l_apa.apa511
            END IF
         END IF
      END IF
      IF l_apa.apa33 > 0
         THEN LET l_npq.npq06 = '1'
              LET l_npq.npq07  = l_apa.apa33
              LET l_npq.npq07f = l_apa.apa33f
         ELSE LET l_npq.npq06 = '2'
              LET l_npq.npq07 = l_apa.apa33  * -1
              LET l_npq.npq07f= l_apa.apa33f * -1
      END IF
      SELECT aag05,aag23,aag371 INTO l_aag05,l_aag23,l_aag371 FROM aag_file   #CHI-760007
       WHERE aag01=l_npq.npq03
         AND aag00 = g_bookno     #No.FUN-730064
      IF l_aag23='Y' THEN 
         LET l_npq.npq08 = l_apa.apa66 
      ELSE 
         LET l_npq.npq08 = null
      END IF
      LET l_npq.npq05 = ''   #MOD-B30089 add
      IF l_aag05='Y' THEN
         IF g_aaz.aaz90='N' THEN
            LET l_npq.npq05 = l_apa.apa22
         ELSE
            LET l_npq.npq05 = l_apa.apa930
         END IF
      ELSE
         LET l_npq.npq05 = ''           
      END IF
      IF l_npq.npq07!=0 THEN
         IF p_aptype[1,1] = '2' THEN
            LET l_npq.npq07 = (-1)*l_npq.npq07                                  
            LET l_npq.npq07f= (-1)*l_npq.npq07f 
         END IF
         LET p_prog = g_prog                       #MOD-C30056 add 
        #No.MOD-BC0264  --Begin
         CASE g_prog
                  WHEN 'aapp110' LET g_prog = 'aapt110'
                  WHEN 'aapp111' LET g_prog = 'aapt210'
                  WHEN 'aapp115' LET g_prog = 'aapt160'
                  WHEN 'aapp117' LET g_prog = 'aapt260'
         END CASE
         #No.MOD-BC0264  --End
         CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno)         #No.FUN-730064
         RETURNING l_npq.*
         CALL s_def_npq31_npq34(l_npq.*,g_bookno) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34      #FUN-AA0087
         CALL t110_chk_aee(l_npq.*)
         RETURNING l_npq.*
         LET g_prog = p_prog                       #MOD-C30056 add
         SELECT azi04 INTO t_azi04 FROM azi_file
           WHERE azi01 = l_npq.npq24
#No.FUN-9A0036 --Begin
            IF p_npptype = '1' THEN
#FUN-A40067 --Begin
               SELECT aaa03 INTO l_aaa03 FROM aaa_file
                WHERE aaa01 = g_bookno2
               SELECT azi04 INTO g_azi04_2 FROM azi_file
                WHERE azi01 = l_aaa03
#FUN-A40067 --End
               CALL s_newrate(g_bookno1,g_bookno2,l_npq.npq24,
                              g_npq25_1,l_npp.npp02)
               RETURNING l_npq.npq25
              # LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25  #TQC-B80204 mark
              # TQC-B80204 --begin
               IF l_npq.npq25 = g_npq25_1 AND g_azi04_2 = g_azi04 THEN
                  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)
               ELSE
                  LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
                  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2)
               END IF
              # TQC-B80204 --end
              # LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2) #FUN-A40067  #TQC-B80204 mark
            ELSE
               LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
            END IF
#No.FUN-9A0036 --End
         LET l_npq.npq07f = cl_digcut(l_npq.npq07f,t_azi04)
#        LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)         #FUN-A40067
       # IF l_aag371 MATCHES '[23]' THEN                          #FUN-950053 mark
         IF l_aag371 MATCHES '[234]' THEN                         #FUN-950053 add  
            #-->for 合併報表-關係人
            SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903
              FROM pmc_file
             WHERE pmc01 = l_apa.apa05
            IF cl_null(l_npq.npq37) THEN
               IF l_pmc903 = 'Y' THEN
                  LET l_npq.npq37 = l_apa.apa05 CLIPPED   #No.CHI-830037
               END IF
            END IF
         END IF
         LET l_npq.npqlegal = g_legal #FUN-980001 add
         #No.FUN-A30077  --Begin                                          
         CALL t110_entry_direction(g_bookno,l_npq.npq03,l_npq.npq06,      
                                   l_npq.npq07,l_npq.npq07f)              
              RETURNING l_npq.npq06,l_npq.npq07,l_npq.npq07f              
         #No.FUN-A30077  --End 
#No.FUN-AC0001 --begin                                                          
               IF cl_null(l_npq.npq35) THEN LET l_npq.npq35 = ' ' END IF        
               IF cl_null(l_npq.npq05) THEN LET l_npq.npq05 = ' ' END IF        
               IF cl_null(l_npq.npq08) THEN LET l_npq.npq08 = ' ' END IF        
#No.FUN-AC0001 --end 
        #FUN-D40118 ---Add--- Start
         SELECT aag44 INTO l_aag44 FROM aag_file
          WHERE aag00 = g_bookno3
            AND aag01 = l_npq.npq03
         IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
            CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET l_npq.npq03 = ''
            END IF
         END IF
        #FUN-D40118 ---Add--- End
         INSERT INTO npq_file VALUES (l_npq.*)
         MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',l_npq.npq07
         IF SQLCA.sqlcode THEN 
            IF g_bgerr THEN
               LET g_showmsg=l_npq.npq01,"/",l_npq.npq011,"/",l_npq.npq02,"/",l_npq.npqsys,"/",l_npq.npq00,"/",l_npq.npqtype
               CALL s_errmsg("npq01,npq011,npq02,npqsys,npq00,npqtype",g_showmsg,"t110_g_gl(ckp#3)",SQLCA.sqlcode,1)
            ELSE
               CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,SQLCA.sqlcode,"","t110_g_gl(ckp#3)",1)  #No.FUN-660122
            END IF
            LET g_success='N' #no.5573
         END IF
      END IF
   END IF
   IF p_npptype = '0' THEN
     #No.FUN-D70028 ---Add--- Start
      IF g_prog = 'aapt140' THEN
         LET g_sql = " SELECT oov03,oov04,oov04f,apa54,apa06,apa13,apa14,apa22",
#                    "   FROM oov_file LEFT OUTER JOIN apa_file ON oov_file.oov03 = apa_file.apa01 ", #FUN-D80049 mark
                     "   FROM oov_file,apa_file ",           #FUN-D80049 add
                     "  WHERE oov01 = '",p_apno,"'",
                     "    AND oov03 = apa01 ",               #FUN-D80049 add
                     #FUN-D80049 ---------- add --------- begin
                     " UNION ",
                     " SELECT oov03,oov04,oov04f,oma18,oma03,oma23,oma24,oma15 ",
                     "   FROM oov_file,oma_file",
                     "  WHERE oov01 = '",p_apno,"'",
                     "    AND oma01 = oov03 "
                     #FUN-D80049 ---------- add --------- end
      ELSE
     #No.FUN-D70028 ---Add--- End
         LET g_sql = " SELECT apv03,apv04,apv04f,apa54,apa06,apa13,apa14,apa22",
                     "   FROM apv_file LEFT OUTER JOIN apa_file ON apv_file.apv03 = apa_file.apa01 ", 
                     "  WHERE apv01 = '",p_apno,"'" 
      END IF   #No.FUN-D70028   Add
   ELSE
     #No.FUN-D70028 ---Add--- Start
      IF g_prog = 'aapt140' THEN
         LET g_sql = " SELECT oov03,oov04,oov04f,apa541,apa06,apa13,apa14,apa22",
#                    "   FROM oov_file LEFT OUTER JOIN apa_file ON oov_file.oov03 = apa_file.apa01 ", #FUN-D80049mark
                     "   FROM oov_file,apa_file ",                       #FUN-D80049 add
                     "  WHERE oov01 = '",p_apno,"'",
                     "    AND oov03 = apa01 ",                           #FUN-D80049 add
                     #FUN-D80049 ---------- add --------- end
                     " UNION ",
                     " SELECT oov03,oov04,oov04f,oma18,oma03,oma23,oma24,oma15 ",
                     "   FROM oov_file,oma_file ",
                     "  WHERE oov01 = '",p_apno,"'",
                     "    AND oov03 = oma01 "
                     #FUN-D80049 ---------- add --------- end
      ELSE
     #No.FUN-D70028 ---Add--- End
         LET g_sql = " SELECT apv03,apv04,apv04f,apa541,apa06,apa13,apa14,apa22",
                     "   FROM apv_file LEFT OUTER JOIN apa_file ON apv_file.apv03 = apa_file.apa01 ",
                     "  WHERE apv01 = '",p_apno,"'" 
      END IF   #No.FUN-D70028   Add
   END IF
   PREPARE t110_gl_p3 FROM g_sql
   DECLARE t110_gl_c3 CURSOR FOR t110_gl_p3
   FOREACH t110_gl_c3 INTO l_npq.npq04,l_npq.npq07,l_npq.npq07f,l_npq.npq03,
                           l_apa06,l_npq.npq24,l_npq.npq25,m_apa22     #No:7871
    
     IF STATUS THEN EXIT FOREACH END IF
     IF l_npq.npq07 IS NULL THEN CONTINUE FOREACH END IF
     LET l_npq.npq02 = l_npq.npq02 + 1
    #-MOD-B40045-add-
     IF g_apz.apz27 = 'Y' AND g_apz.apz62 = 'N' THEN
        SELECT apc07 INTO l_npq.npq25
          FROM apc_file
         WHERE apc01 = l_npq.npq04 
           AND apc02 = 1 
     END IF
    #-MOD-B40045-end-
     LET g_npq25_1=l_npq.npq25          #FUN-9A0036
     LET l_npq.npq06 = '2'
     IF l_npq.npq04 <> 'DIFF' THEN
       #-MOD-B30065-add-
        SELECT apa06,apa07 INTO l_npq.npq21,l_npq.npq22
          FROM apa_file
         WHERE apa01 = l_npq.npq04
       #-MOD-B30065-end-
        LET l_npq.npq23 = l_npq.npq04     
     END IF
     #取匯兌損溢科目                                                            
     IF g_apz.apz13 = 'Y' THEN   #按部門區分預設會計科目                        
        IF NOT cl_null(m_apa22) THEN                                            
           SELECT * INTO m_aps.* FROM aps_file WHERE aps01 = m_apa22            
           IF STATUS THEN                                                       
              IF g_bgerr THEN
                 #CALL s_errmsg("aps01",m_apa22,"sel aps",SQLCA.sqlcode,1)   #FUN-D40089 mark
                 CALL s_errmsg("aps01",m_apa22,p_apno,SQLCA.sqlcode,1)       #FUN-D40089 add 
              ELSE
                CALL cl_err3("sel","aps_file",m_apa22,"",STATUS,"","sel aps",1)  #No.FUN-660122
              END IF
              LET g_success = 'N' RETURN  
           END IF                                                               
        ELSE                                                                    
           INITIALIZE m_aps.* TO NULL                                           
           IF l_npq.npq04 = 'DIFF' THEN
              SELECT * INTO m_aps.* FROM aps_file WHERE aps01 = l_apa.apa22
              IF STATUS THEN
                 IF g_bgerr THEN
                    #CALL s_errmsg("aps01",l_apa.apa22,"sel aps",SQLCA.sqlcode,1)  #FUN-D40089 mark
                    CALL s_errmsg("aps01",l_apa.apa22,p_apno,SQLCA.sqlcode,1)      #FUN-D40089 add
                 ELSE
                   CALL cl_err3("sel","aps_file",l_apa.apa22,"",STATUS,"","sel aps",1)  #No.FUN-660122
                 END IF
                 LET g_success = 'N' RETURN
              END IF
           END IF
        END IF                                                                  
     ELSE                                                                       
        SELECT * INTO m_aps.* FROM aps_file WHERE aps01 = ' '                   
        IF STATUS THEN                                                          
           IF g_bgerr THEN
              #CALL s_errmsg("aps01","","sel aps",SQLCA.sqlcode,1)        #FUN-D40089 mark
              CALL s_errmsg("aps01","sel aps",p_apno,SQLCA.sqlcode,1)     #FUN-D40089 add
           ELSE
              CALL cl_err3("sel","aps_file","","",STATUS,"","sel aps",1)  #No.FUN-660122
           END IF
           LET g_success = 'N' RETURN
        END IF 
     END IF                                                                     
     IF l_npq.npq07 > 0 AND l_npq.npq04 = 'DIFF' THEN  #增加大于0否的判斷       
         LET l_npq.npq06 = '2'                                                  
         IF p_npptype = '0' THEN  #No.FUN-680029
            LET l_npq.npq03 = m_aps.aps43  #MOD-680030
         ELSE
            LET l_npq.npq03 = m_aps.aps431
         END IF
     END IF                                                                     
     IF l_npq.npq07 < 0 AND l_npq.npq04 = 'DIFF' THEN                           
        LET l_npq.npq06 = '1'                                                   
        LET l_npq.npq07 = l_npq.npq07 * (-1)                                    
        IF p_npptype = '0' THEN  #No.FUN-680029
           LET l_npq.npq03 = m_aps.aps42   #MOD-680030
        ELSE
           LET l_npq.npq03 = m_aps.aps421
        END IF
     END IF                                                                     
     IF cl_null(l_npq.npq03) AND l_npq.npq04 != 'DIFF' THEN
        CALL t110_gl_ins_npq(l_npq.npq02,l_npq.npq04,p_apno,l_npq.npq24,l_npq.npq25,l_npq.npq07,l_npq.npq07f,p_npptype)  #No.FUN-680029 新增p_npptype
        RETURNING l_npq.npq02
        CONTINUE FOREACH
     END IF
 
     SELECT aag05,aag23,aag371 INTO l_aag05,l_aag23,l_aag371 FROM aag_file   #CHI-760007
      WHERE aag01=l_npq.npq03
        AND aag00 = g_bookno     #No.FUN-730064
     IF l_aag23='Y' THEN 
        LET l_npq.npq08 = l_apa.apa66 
     ELSE 
        LET l_npq.npq08 = null
     END IF
     LET l_npq.npq05 = ''   #MOD-B30089 add
     IF l_aag05='Y' THEN
        IF g_aaz.aaz90='N' THEN
          #LET l_npq.npq05 = l_apa.apa22    #MOD-D50287 mark
           LET l_npq.npq05 = m_apa22        #MOD-D50287 add
        ELSE
           LET l_npq.npq05 = l_apa.apa930
        END IF
     ELSE
        LET l_npq.npq05 = ''           
     END IF
     LET l_npq.npq11=''
     LET l_npq.npq12=''
     LET l_npq.npq13=''
     LET l_npq.npq14=''
     LET l_npq.npq31=''
     LET l_npq.npq32=''
     LET l_npq.npq33=''
     LET l_npq.npq34=''
     LET l_npq.npq35=''
     LET l_npq.npq36=''
     LET l_npq.npq37=''
     IF l_npq.npq04 = 'DIFF' THEN   #MOD-6B0043
        LET l_npq.npq24 = g_aza.aza17   #MOD-640262
        LET l_npq.npq25 = 1   #MOD-640262
     END IF   #MOD-6B0043
     LET g_npq25_1=l_npq.npq25 #FUN-9A0036
     IF l_npq.npq07!=0 THEN
        IF p_aptype[1,1] = '2' THEN
           LET l_npq.npq07 = (-1)*l_npq.npq07                                  
           LET l_npq.npq07f= (-1)*l_npq.npq07f 
        END IF
        LET p_prog = g_prog                       #MOD-C30056 add
        #No.MOD-BC0264  --Begin
        CASE g_prog
                 WHEN 'aapp110' LET g_prog = 'aapt110'
                 WHEN 'aapp111' LET g_prog = 'aapt210'
                 WHEN 'aapp115' LET g_prog = 'aapt160'
                 WHEN 'aapp117' LET g_prog = 'aapt260'
        END CASE
        #No.MOD-BC0264  --End 
        CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno)        #No.FUN-730064
        RETURNING l_npq.*
        LET g_prog = p_prog                       #MOD-C30056 add
        CALL s_def_npq31_npq34(l_npq.*,g_bookno) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34   #FUN-AA0087
        CALL t110_chk_aee(l_npq.*)
        RETURNING l_npq.*
        SELECT azi04 INTO t_azi04 FROM azi_file
          WHERE azi01 = l_npq.npq24
#No.FUN-9A0036 --Begin
            IF p_npptype = '1' THEN
#FUN-A40067 --Begin
               SELECT aaa03 INTO l_aaa03 FROM aaa_file
                WHERE aaa01 = g_bookno2
               SELECT azi04 INTO g_azi04_2 FROM azi_file
                WHERE azi01 = l_aaa03
#FUN-A40067 --End
               CALL s_newrate(g_bookno1,g_bookno2,l_npq.npq24,
                              g_npq25_1,l_npp.npp02)
               RETURNING l_npq.npq25
              # LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25  #TQC-B80204 mark
              # TQC-B80204 --begin
               IF l_npq.npq25 = g_npq25_1 AND g_azi04_2 = g_azi04 THEN
                  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)
               ELSE
                  LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
                  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2)
               END IF
              # TQC-B80204 --end
              # LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2) #FUN-A40067  #TQC-B80204 mark
            ELSE
               LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
            END IF
#No.FUN-9A0036 --End
        LET l_npq.npq07f = cl_digcut(l_npq.npq07f,t_azi04)
#       LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)          #FUN-A40067
      # IF l_aag371 MATCHES '[23]' THEN                           #FUN-950053 mark
        IF l_aag371 MATCHES '[234]' THEN                          #FUN-950053 add   
            #-->for 合併報表-關係人
            SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903
              FROM pmc_file
             WHERE pmc01 = l_apa.apa05
            IF cl_null(l_npq.npq37) THEN
               IF l_pmc903 = 'Y' THEN
                  LET l_npq.npq37 = l_apa.apa05 CLIPPED   #No.CHI-830037
               END IF
            END IF
        END IF
        LET l_npq.npqlegal = g_legal #FUN-980001 add
        #No.FUN-A30077  --Begin                                          
        CALL t110_entry_direction(g_bookno,l_npq.npq03,l_npq.npq06,      
                                  l_npq.npq07,l_npq.npq07f)              
             RETURNING l_npq.npq06,l_npq.npq07,l_npq.npq07f              
        #No.FUN-A30077  --End 
#No.FUN-AC0001 --begin                                                          
               IF cl_null(l_npq.npq35) THEN LET l_npq.npq35 = ' ' END IF        
               IF cl_null(l_npq.npq05) THEN LET l_npq.npq05 = ' ' END IF        
               IF cl_null(l_npq.npq08) THEN LET l_npq.npq08 = ' ' END IF        
#No.FUN-AC0001 --end 
       #FUN-D40118 ---Add--- Start
        SELECT aag44 INTO l_aag44 FROM aag_file
         WHERE aag00 = g_bookno3
           AND aag01 = l_npq.npq03
        IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
           CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
           IF l_flag = 'N'   THEN
              LET l_npq.npq03 = ''
           END IF
        END IF
       #FUN-D40118 ---Add--- End
        INSERT INTO npq_file VALUES (l_npq.*)
        IF STATUS THEN 
           IF g_bgerr THEN
              LET g_showmsg=l_npq.npq01,"/",l_npq.npq011,"/",l_npq.npq02,"/",l_npq.npqsys,"/",l_npq.npq00,"/",l_npq.npqtype
              CALL s_errmsg("npq01,npq011,npq02,npqsys,npq00,npqtype",g_showmsg,"t110_g_gl(ckp#4)",SQLCA.sqlcode,1)
           ELSE
              CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,STATUS,"","t110_g_gl(ckp#4)",1)  #No.FUN-660122
           END IF
           LET g_success='N' EXIT FOREACH #no.5573
        END IF
     END IF
   END FOREACH

#-----------------------------------( 還款借方分錄產生   )---------------------
   LET l_npq.npq21 = l_apa.apa06   #廠商編號   #MOD-B30065
   LET l_npq.npq22 = l_apa.apa07   #簡稱       #MOD-B30065
   IF NOT cl_null(l_apa.apa101) AND l_apa.apa37 <> 0 THEN
      #去掉 apv04 > 0 的條件 有DIFF時，apv04可能小于0
      LET l_npq.npq04 = '' 
      IF p_npptype = '0' THEN
         SELECT nma05 INTO l_npq.npq03
           FROM nma_file
          WHERE nma01 = l_apa.apa101
      ELSE
         SELECT nma051 INTO l_npq.npq03
           FROM nma_file
          WHERE nma01 = l_apa.apa101
      END IF
      LET l_npq.npq07 = l_apa.apa37
      LET l_npq.npq07f= l_apa.apa37f
      LET l_npq.npq06 = '1'
      LET l_npq.npq24 = l_apa.apa13
      LET l_npq.npq02 = l_npq.npq02 + 1
   
      IF cl_null(l_npq.npq03) AND l_npq.npq04 != 'DIFF' THEN
         CALL t110_gl_ins_npq(l_npq.npq02,l_npq.npq04,p_apno,l_npq.npq24,l_npq.npq25,l_npq.npq07,l_npq.npq07f,p_npptype)  #No.FUN-680029 新增p_npptype
         RETURNING l_npq.npq02
      END IF
      MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',l_npq.npq07
      SELECT aag05,aag23,aag371 INTO l_aag05,l_aag23,l_aag371 FROM aag_file   #CHI-760007
       WHERE aag01=l_npq.npq03 
         AND aag00=g_bookno        #No.FUN-730064
      IF l_aag23='Y' THEN 
         LET l_npq.npq08 = l_apa.apa66 
      ELSE 
         LET l_npq.npq08 = null
      END IF
      LET l_npq.npq05 = ''   #MOD-B30089 add
      IF l_aag05='Y' THEN
         IF g_aaz.aaz90='N' THEN
            LET l_npq.npq05 = l_apa.apa22
         ELSE
            LET l_npq.npq05 = l_apa.apa930
         END IF
      ELSE
         LET l_npq.npq05 = ''           
      END IF
      LET l_npq.npq11=''
      LET l_npq.npq12=''
      LET l_npq.npq13=''
      LET l_npq.npq14=''
      LET l_npq.npq31=''
      LET l_npq.npq32=''
      LET l_npq.npq33=''
      LET l_npq.npq34=''
      LET l_npq.npq35=''
      LET l_npq.npq36=''
      LET l_npq.npq37=''
      LET l_npq.npq23 = l_apa.apa01  
      LET l_npq.npq24 = g_npq24
      LET l_npq.npq25 = g_npq25
      LET g_npq25_1=l_npq.npq25  #FUN-9A0036
      IF l_npq.npq07!=0 THEN
         IF p_aptype[1,1] = '2' THEN
            LET l_npq.npq07 = (-1)*l_npq.npq07                                  
            LET l_npq.npq07f= (-1)*l_npq.npq07f 
         END IF
         LET p_prog = g_prog                       #MOD-C30056 add  
        #No.MOD-BC0264  --Begin
         CASE g_prog
                  WHEN 'aapp110' LET g_prog = 'aapt110'
                  WHEN 'aapp111' LET g_prog = 'aapt210'
                  WHEN 'aapp115' LET g_prog = 'aapt160'
                  WHEN 'aapp117' LET g_prog = 'aapt260'
         END CASE
         #No.MOD-BC0264  --End
         CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno)        #No.FUN-730064
         RETURNING l_npq.*
         LET g_prog = p_prog                       #MOD-C30056 add
         CALL s_def_npq31_npq34(l_npq.*,g_bookno) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34   #FUN-AA0087
          CALL t110_chk_aee(l_npq.*)
          RETURNING l_npq.*
         SELECT azi04 INTO t_azi04 FROM azi_file
           WHERE azi01 = l_npq.npq24
#No.FUN-9A0036 --Begin
            IF p_npptype = '1' THEN
#FUN-A40067 --Begin
               SELECT aaa03 INTO l_aaa03 FROM aaa_file
                WHERE aaa01 = g_bookno2
               SELECT azi04 INTO g_azi04_2 FROM azi_file
                WHERE azi01 = l_aaa03
#FUN-A40067 --End
               CALL s_newrate(g_bookno1,g_bookno2,l_npq.npq24,
                              g_npq25_1,l_npp.npp02)
               RETURNING l_npq.npq25
              # LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25  #TQC-B80204 mark
              # TQC-B80204 --begin
               IF l_npq.npq25 = g_npq25_1 AND g_azi04_2 = g_azi04 THEN
                  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)
               ELSE
                  LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
                  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2)
               END IF
              # TQC-B80204 --end
              # LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2) #FUN-A40067 #TQC-B80204 mark
            ELSE
               LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
            END IF
#No.FUN-9A0036 --End
         LET l_npq.npq07f = cl_digcut(l_npq.npq07f,t_azi04)
#        LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)         #FUN-A40067
       # IF l_aag371 MATCHES '[23]' THEN                          #FUN-950053 mark
         IF l_aag371 MATCHES '[234]' THEN                         #FUN-950053 add 
            #-->for 合併報表-關係人
            SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903
              FROM pmc_file
             WHERE pmc01 = l_apa.apa05
            IF cl_null(l_npq.npq37) THEN
               IF l_pmc903 = 'Y' THEN
                  LET l_npq.npq37 = l_apa.apa05 CLIPPED   #No.CHI-830037
               END IF
            END IF
         END IF
         LET l_npq.npqlegal = g_legal #FUN-980001 add
         #No.FUN-A30077  --Begin                                          
         CALL t110_entry_direction(g_bookno,l_npq.npq03,l_npq.npq06,      
                                   l_npq.npq07,l_npq.npq07f)              
              RETURNING l_npq.npq06,l_npq.npq07,l_npq.npq07f              
         #No.FUN-A30077  --End 
#No.FUN-AC0001 --begin                                                          
               IF cl_null(l_npq.npq35) THEN LET l_npq.npq35 = ' ' END IF        
               IF cl_null(l_npq.npq05) THEN LET l_npq.npq05 = ' ' END IF        
               IF cl_null(l_npq.npq08) THEN LET l_npq.npq08 = ' ' END IF        
#No.FUN-AC0001 --end 
        #FUN-D40118 ---Add--- Start
         SELECT aag44 INTO l_aag44 FROM aag_file
          WHERE aag00 = g_bookno3
            AND aag01 = l_npq.npq03
         IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
            CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET l_npq.npq03 = ''
            END IF
         END IF
        #FUN-D40118 ---Add--- End
         INSERT INTO npq_file VALUES (l_npq.*)
         IF STATUS THEN 
            IF g_bgerr THEN
               LET g_showmsg=l_npq.npq01,"/",l_npq.npq011,"/",l_npq.npq02,"/",l_npq.npqsys,"/",l_npq.npq00,"/",l_npq.npqtype
               CALL s_errmsg("npq01,npq011,npq02,npqsys,npq00,npqtype",g_showmsg,"t110_g_gl(ckp#4)",SQLCA.sqlcode,1)
            ELSE
               CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,STATUS,"","t110_g_gl(ckp#4)",1)  #No.FUN-660122
            END IF
            LET g_success='N' #no.5573
         END IF
      END IF
   END IF
#-----------------------------------( Cr: 直接付款       )---------------------
   DECLARE t110_gl_c5 CURSOR FOR
           SELECT * FROM aph_file WHERE aph01=p_apno ORDER BY aph02
   FOREACH t110_gl_c5 INTO l_aph.*
      LET l_npq.npq11=''
      LET l_npq.npq12=''
      LET l_npq.npq13=''
      LET l_npq.npq14=''
      LET l_npq.npq31=''
      LET l_npq.npq32=''
      LET l_npq.npq33=''
      LET l_npq.npq34=''
      LET l_npq.npq35=''
      LET l_npq.npq36=''
      LET l_npq.npq37=''
      LET l_npq.npq23 = l_apa.apa01   #MOD-7A0204
      LET l_npq.npq02 = l_npq.npq02 + 1
      IF p_npptype = '0' THEN  #No.FUN-680029
         LET l_npq.npq03 = l_aph.aph04
      ELSE
         LET l_npq.npq03 = l_aph.aph041
      END IF
      IF l_aph.aph03 MATCHES '[6789]' THEN
         IF p_npptype = '0' THEN  #No.FUN-680029
            SELECT apa54 INTO l_npq.npq03 FROM apa_file WHERE apa01=l_aph.aph04
         ELSE
            SELECT apa541 INTO l_npq.npq03 FROM apa_file WHERE apa01=l_aph.aph04
         END IF
      END IF
      #--add by lifang 201104 begin# 应收票据转付科目错误调整
      IF l_aph.aph03 = 'D' THEN
         SELECT nmh26 INTO l_npq.npq03
          FROM nmh_file
         WHERE nmh01 = l_aph.aph04
      END IF
      #--add by lifang 201104 end#

      LET l_npq.npq04 = NULL
     #FUN-D10065--mark--str--
     #IF l_aph.aph03 = "1" OR l_aph.aph03 = "2" THEN #MOD-970273    
     #   CASE WHEN g_apz.apz44 = '1' 
     #             LET l_npq.npq04=l_apa.apa06 CLIPPED,' ',l_apa.apa07
     #        WHEN g_apz.apz44 = '2' 
     #             LET l_npq.npq04=l_apa.apa06 CLIPPED,' ',l_apa.apa07,' ',
     #                             l_aph.aph07
     #   END CASE
     #END IF
     #FUN-D10065--mark--end---
      LET l_npq.npq06 = '2'
      LET l_npq.npq07f= l_aph.aph05f
      LET l_npq.npq07 = l_aph.aph05
      IF l_aph.aph03 = 'B' THEN    #貸方科目
         IF l_aph.aph08 IS NOT NULL AND l_aph.aph08 <> ' ' THEN
            LET l_npq.npq21 = l_aph.aph08
            SELECT nma02 INTO l_npq.npq22 FROM nma_file 
             WHERE nma01 = l_aph.aph08
         ELSE
            LET l_npq.npq21 = l_apa.apa06
            LET l_npq.npq22 = l_apa.apa07
         END IF
      ELSE
         LET l_npq.npq21 = l_apa.apa06
         LET l_npq.npq22 = l_apa.apa07
      #--add by lifang 201109 begin#
       IF l_aph.aph03 = 'D' THEN
         SELECT nmh11,nmh30 INTO l_npq.npq21,l_npq.npq22   
          FROM nmh_file
         WHERE nmh01 = l_aph.aph04
       END IF
      #--add by lifang 201109 end#
      END IF
       LET l_npq.npq24 = l_aph.aph13  #MOD-560035
       LET l_npq.npq25 = l_aph.aph14  #MOD-560035
       LET g_npq25_1=l_npq.npq25      #FUN-9A0036
      IF l_npq.npq07 < 0 THEN
         LET l_npq.npq06 = '1'
         LET l_npq.npq07f= l_npq.npq07f * -1
         LET l_npq.npq07 = l_npq.npq07  * -1
      END IF
      #SELECT aag05,aag23 INTO l_aag05,l_aag23 FROM aag_file   #CHI-760007
      SELECT aag05,aag23,aag371 INTO l_aag05,l_aag23,l_aag371 FROM aag_file   #CHI-760007
       WHERE aag01=l_npq.npq03
         AND aag00=g_bookno        #No.FUN-730064
      IF l_aag23='Y' THEN 
         LET l_npq.npq08 = l_apa.apa66 
      ELSE 
         LET l_npq.npq08 = null
      END IF
      LET l_npq.npq05 = ''   #MOD-B30089 add
      IF l_aag05='Y' THEN
         IF g_aaz.aaz90='N' THEN
            IF cl_null(l_npq.npq05) THEN
               LET l_npq.npq05 = l_apa.apa22
            END IF
         ELSE
            LET l_npq.npq05 = l_apa.apa930
         END IF
      ELSE
         LET l_npq.npq05 = ''           
      END IF
      IF l_npq.npq07!=0 THEN
         IF p_aptype[1,1] = '2' THEN
            LET l_npq.npq07 = (-1)*l_npq.npq07                                  
            LET l_npq.npq07f= (-1)*l_npq.npq07f 
         END IF
         LET p_prog = g_prog                       #MOD-C30056 add 
        #No.MOD-BC0264  --Begin
         CASE g_prog
                  WHEN 'aapp110' LET g_prog = 'aapt110'
                  WHEN 'aapp111' LET g_prog = 'aapt210'
                  WHEN 'aapp115' LET g_prog = 'aapt160'
                  WHEN 'aapp117' LET g_prog = 'aapt260'
         END CASE
         #No.MOD-BC0264  --End
         CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno)        #No.FUN-730064
         RETURNING l_npq.*
          #FUN-D10065--add--str--
         IF cl_null(l_npq.npq04) THEN
            IF l_aph.aph03 = "1" OR l_aph.aph03 = "2" THEN
               CASE WHEN g_apz.apz44 = '1'
                         LET l_npq.npq04=l_apa.apa06 CLIPPED,' ',l_apa.apa07
                    WHEN g_apz.apz44 = '2'
                         LET l_npq.npq04=l_apa.apa06 CLIPPED,' ',l_apa.apa07,' ',
                                         l_aph.aph07
               END CASE
            END IF
         END IF
         #FUN-D10065--add--end--
         LET g_prog = p_prog                       #MOD-C30056 add
         CALL s_def_npq31_npq34(l_npq.*,g_bookno) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34    #FUN-AA0087
          CALL t110_chk_aee(l_npq.*)
          RETURNING l_npq.*
         SELECT azi04 INTO t_azi04 FROM azi_file
           WHERE azi01 = l_npq.npq24
#No.FUN-9A0036 --Begin
            IF p_npptype = '1' THEN
#FUN-A40067 --Begin
               SELECT aaa03 INTO l_aaa03 FROM aaa_file
                WHERE aaa01 = g_bookno2
               SELECT azi04 INTO g_azi04_2 FROM azi_file
                WHERE azi01 = l_aaa03
#FUN-A40067 --End
               CALL s_newrate(g_bookno1,g_bookno2,l_npq.npq24,
                              g_npq25_1,l_npp.npp02)
               RETURNING l_npq.npq25
              # LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25  #TQC-B80204 mark
              # TQC-B80204 --begin
               IF l_npq.npq25 = g_npq25_1 AND g_azi04_2 = g_azi04 THEN
                  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)
               ELSE
                  LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
                  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2)
               END IF
              # TQC-B80204 --end
              # LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2) #FUN-A40067  #TQC-B80204 mark
            ELSE
               LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
            END IF
#No.FUN-9A0036 --End
         LET l_npq.npq07f = cl_digcut(l_npq.npq07f,t_azi04)
#        LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)         #FUN-A40067
       # IF l_aag371 MATCHES '[23]' THEN                          #FUN-950053 mark
         IF l_aag371 MATCHES '[234]' THEN                         #FUN-950053 add 
            #-->for 合併報表-關係人
            SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903
              FROM pmc_file
             WHERE pmc01 = l_apa.apa05
            IF cl_null(l_npq.npq37) THEN
               IF l_pmc903 = 'Y' THEN
                  LET l_npq.npq37 = l_apa.apa05 CLIPPED   #No.CHI-830037
               END IF
            END IF
         END IF
         LET l_npq.npqlegal = g_legal #FUN-980001 add
         #No.FUN-A30077  --Begin                                          
         CALL t110_entry_direction(g_bookno,l_npq.npq03,l_npq.npq06,      
                                   l_npq.npq07,l_npq.npq07f)              
              RETURNING l_npq.npq06,l_npq.npq07,l_npq.npq07f              
         #No.FUN-A30077  --End 
#No.FUN-AC0001 --begin                                                          
               IF cl_null(l_npq.npq35) THEN LET l_npq.npq35 = ' ' END IF        
               IF cl_null(l_npq.npq05) THEN LET l_npq.npq05 = ' ' END IF        
               IF cl_null(l_npq.npq08) THEN LET l_npq.npq08 = ' ' END IF        
#No.FUN-AC0001 --end 
        #FUN-D40118 ---Add--- Start
         SELECT aag44 INTO l_aag44 FROM aag_file
          WHERE aag00 = g_bookno3
            AND aag01 = l_npq.npq03
         IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
            CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET l_npq.npq03 = ''
            END IF
         END IF
        #FUN-D40118 ---Add--- End
         INSERT INTO npq_file VALUES (l_npq.*)
         IF STATUS THEN 
            IF g_bgerr THEN
               LET g_showmsg=l_npq.npq01,"/",l_npq.npq011,"/",l_npq.npq02,"/",l_npq.npqsys,"/",l_npq.npq00,"/",l_npq.npqtype
               CALL s_errmsg("npq01,npq011,npq02,npqsys,npq00,npqtype",g_showmsg,"t110_g_gl(ckp#5)",SQLCA.sqlcode,1)
            ELSE
               CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,STATUS,"","t110_g_gl(ckp#5)",1)  #No.FUN-660122
            END IF
            LET g_success='N' EXIT FOREACH #no.5573
         END IF
      END IF
      LET l_apa.apa34f=l_apa.apa34f-l_aph.aph05f
      LET l_apa.apa34 =l_apa.apa34 -l_aph.aph05
     #-MOD-BB0069-add-
      IF l_apa.apa14 = 1 AND l_aph.aph14 <> l_apa.apa14 THEN  
         LET l_apa.apa34f = l_apa.apa34
      END IF
     #-MOD-BB0069-end-
   END FOREACH
#-----------------------------------( Cr: A/P            )---------------------
 #FUN-D10065---mark--str
 # CASE WHEN g_apz.apz55 = '1' AND l_apa.apa55 = '2' AND (p_aptype = '12' OR p_aptype = '13')  #No.FUN-690080
 #           LET l_npq.npq04 = l_apa.apa07 CLIPPED,' ',l_apa.apa64
 #      WHEN g_apz.apz43 = '1'
 #           LET l_npq.npq04 = l_apa.apa06 CLIPPED,' ',l_apa.apa07
 #      WHEN g_apz.apz43 = '2'
 #           IF l_apa.apa08 = 'MISC' THEN
 #              LET l_npq.npq04 = l_apa.apa06,' ',l_apa.apa07,' ',
 #                  l_apa.apa01
 #           ELSE
 #              LET l_npq.npq04 = l_apa.apa06,' ',l_apa.apa07,' ',
 #                  l_apa.apa08
 #           END IF
 #      OTHERWISE
 #           LET l_npq.npq04 = NULL
 # END CASE
 ##FUN-D10065---mark--end
   LET l_npq.npq04 = NULL #FUN-D10065 add
   LET l_npq.npq11=''
   LET l_npq.npq12=''
   LET l_npq.npq13=''
   LET l_npq.npq14=''
   LET l_npq.npq31=''
   LET l_npq.npq32=''
   LET l_npq.npq33=''
   LET l_npq.npq34=''
   LET l_npq.npq35=''
   LET l_npq.npq36=''
   LET l_npq.npq37=''
   LET l_npq.npq23 = l_apa.apa01   #MOD-7A0204
   IF p_npptype = '0' THEN  #No.FUN-680029
      LET l_npq.npq03 = l_apa.apa54
   ELSE
      LET l_npq.npq03 = l_apa.apa541
   END IF
   LET l_npq.npq06 = '2'             
   IF l_apa.apa56 = '3' THEN
      LET l_npq.npq07 = l_apa.apa34
      LET l_npq.npq07f= l_apa.apa34f
      LET l_npq.npq02 = l_npq.npq02 + 1
   ELSE
      IF l_apa.apa54 = 'MISC' THEN
         IF p_npptype = '0' THEN
            LET g_sql = " SELECT * FROM api_file ",
                        "  WHERE api01 = '",p_apno,"'",
                        "    AND api02 = '2'",
                        "    AND api00 = '",p_npptype,"'",
                        "    AND (api04 IS NOT NULL AND api04 <> ' ')"
         ELSE
            LET g_sql = " SELECT * FROM api_file ",
                        "  WHERE api01 = '",p_apno,"'",
                        "    AND api02 = '2'",
                        "    AND api00 = '",p_npptype,"'",
                        "    AND (api041 IS NOT NULL AND api041 <> ' ')"
         END IF
         PREPARE t110_gl_p2 FROM g_sql
         DECLARE t110_gl_c2 CURSOR FOR t110_gl_p2
         FOREACH t110_gl_c2 INTO l_api.*
             IF STATUS THEN EXIT FOREACH END IF
             LET l_npq.npq02 = l_npq.npq02 + 1
             LET l_npq.npq04 = NULL                 #MOD-D20101 add
             IF p_npptype = '0' THEN  #No.FUN-680029
                LET l_npq.npq03 = l_api.api04
             ELSE
                LET l_npq.npq03 = l_api.api041
             END IF
             LET l_npq.npq04 = NULL          #FUN-D10065  add
             LET l_npq.npq07 = l_api.api05
             LET l_npq.npq07f= l_api.api05f 
             SELECT aag05,aag21,aag23,aag371 INTO l_aag05,l_aag21,l_aag23,l_aag371   #CHI-760007
               FROM aag_file WHERE aag01=l_npq.npq03
                               AND aag00=g_bookno        #No.FUN-730064
             LET l_npq.npq05 = ''   #MOD-B30089 add
             IF l_aag05='Y' THEN
                IF g_aaz.aaz90='N' THEN
                   LET l_npq.npq05 = l_api.api07    #MOD-8C0067
                ELSE
                   LET l_npq.npq05 = l_api.api930   #MOD-8C0067
                END IF
             ELSE
                LET l_npq.npq05 = ''           
             END IF
             IF l_npq.npq07!=0 THEN
                IF p_aptype[1,1] = '2' THEN
                   LET l_npq.npq07 = (-1)*l_npq.npq07                                  
                   LET l_npq.npq07f= (-1)*l_npq.npq07f 
                END IF
                LET p_prog = g_prog                       #MOD-C30056 add 
                #No.MOD-BC0264  --Begin
                CASE g_prog
                          WHEN 'aapp110' LET g_prog = 'aapt110'
                          WHEN 'aapp111' LET g_prog = 'aapt210'
                          WHEN 'aapp115' LET g_prog = 'aapt160'
                          WHEN 'aapp117' LET g_prog = 'aapt260'
                END CASE
                #No.MOD-BC0264  --End
                CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno)       #No.FUN-730064
                RETURNING l_npq.*
                #FUN-D10065--add--str--
                IF cl_null(l_npq.npq04) THEN
                   CASE WHEN g_apz.apz55 = '1' AND l_apa.apa55 = '2' AND (p_aptype = '12' OR p_aptype = '13')
                             LET l_npq.npq04 = l_apa.apa07 CLIPPED,' ',l_apa.apa64
                        WHEN g_apz.apz43 = '1'
                             LET l_npq.npq04 = l_apa.apa06 CLIPPED,' ',l_apa.apa07
                        WHEN g_apz.apz43 = '2'
                             IF l_apa.apa08 = 'MISC' THEN
                                LET l_npq.npq04 = l_apa.apa06,' ',l_apa.apa07,' ',
                                                  l_apa.apa01
                             ELSE
                                LET l_npq.npq04 = l_apa.apa06,' ',l_apa.apa07,' ',
                                                  l_apa.apa08
                             END IF
                        OTHERWISE
                             LET l_npq.npq04 = NULL
                   END CASE
                END IF
                #FUN-D10065--add--end--
                LET g_prog = p_prog                       #MOD-C30056 add
                CALL s_def_npq31_npq34(l_npq.*,g_bookno) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34   #FUN-AA0087 
               CALL t110_chk_aee(l_npq.*)
               RETURNING l_npq.*
                SELECT azi04 INTO t_azi04 FROM azi_file
                  WHERE azi01 = l_npq.npq24
#No.FUN-9A0036 --Begin
            IF p_npptype = '1' THEN
#FUN-A40067 --Begin
               SELECT aaa03 INTO l_aaa03 FROM aaa_file
                WHERE aaa01 = g_bookno2
               SELECT azi04 INTO g_azi04_2 FROM azi_file
                WHERE azi01 = l_aaa03
#FUN-A40067 --End
               CALL s_newrate(g_bookno1,g_bookno2,l_npq.npq24,
                              g_npq25_1,l_npp.npp02)
               RETURNING l_npq.npq25
              # LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25  #TQC-B80204 mark
              # TQC-B80204 --begin
               IF l_npq.npq25 = g_npq25_1 AND g_azi04_2 = g_azi04 THEN
                  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)
               ELSE
                  LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
                  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2)
               END IF
              # TQC-B80204 --end
              # LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2) #FUN-A40067  #TQC-B80204 mark
            ELSE
               LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
            END IF
#No.FUN-9A0036 --End
                LET l_npq.npq07f = cl_digcut(l_npq.npq07f,t_azi04)
#               LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)  #FUN-A40067
              # IF l_aag371 MATCHES '[23]' THEN                   #FUN-950053 mark
                IF l_aag371 MATCHES '[234]' THEN                  #FUN-950053 add   
                   #-->for 合併報表-關係人
                   SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903
                     FROM pmc_file
                    WHERE pmc01 = l_apa.apa05
                   IF cl_null(l_npq.npq37) THEN
                      IF l_pmc903 = 'Y' THEN
                         LET l_npq.npq37 = l_apa.apa05 CLIPPED   #No.CHI-830037
                      END IF
                   END IF
                END IF
                LET l_npq.npqlegal = g_legal #FUN-980001 add
                #No.FUN-A30077  --Begin                                          
                CALL t110_entry_direction(g_bookno,l_npq.npq03,l_npq.npq06,      
                                          l_npq.npq07,l_npq.npq07f)              
                     RETURNING l_npq.npq06,l_npq.npq07,l_npq.npq07f              
                #No.FUN-A30077  --End 
#No.FUN-AC0001 --begin                                                          
               IF cl_null(l_npq.npq35) THEN LET l_npq.npq35 = ' ' END IF        
               IF cl_null(l_npq.npq05) THEN LET l_npq.npq05 = ' ' END IF        
               IF cl_null(l_npq.npq08) THEN LET l_npq.npq08 = ' ' END IF        
#No.FUN-AC0001 --end 
               #FUN-D40118 ---Add--- Start
                SELECT aag44 INTO l_aag44 FROM aag_file
                 WHERE aag00 = g_bookno3
                   AND aag01 = l_npq.npq03
                IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
                   CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
                   IF l_flag = 'N'   THEN
                      LET l_npq.npq03 = ''
                   END IF
                END IF
               #FUN-D40118 ---Add--- End
                INSERT INTO npq_file VALUES (l_npq.*)
                MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',
                            l_npq.npq06,' ',l_npq.npq07
                IF STATUS THEN 
                   IF g_bgerr THEN
                      LET g_showmsg=l_npq.npq01,"/",l_npq.npq011,"/",l_npq.npq02,"/",l_npq.npqsys,"/",l_npq.npq00,"/",l_npq.npqtype
                      CALL s_errmsg("npq01,npq011,npq02,npqsys,npq00,npqtype",g_showmsg,"t110_g_gl(ckp#1)",SQLCA.sqlcode,1)
                   ELSE
                      CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,STATUS,"","t110_g_gl(ckp#1)",1)  #No.FUN-6601222
                   END IF
                   LET g_success='N' EXIT FOREACH #no.5573
                END IF
             END IF
          END FOREACH
      ELSE
         IF g_aza.aza26='2' AND g_apydmy6='Y' THEN
            LET l_npq.npq07 = l_apa.apa34 - l_apa.apa35
            LET l_npq.npq07f= l_apa.apa34f- l_apa.apa35f
            LET l_npq.npq02 = l_npq.npq02 + 1
         ELSE
            LET l_npq.npq07 = l_apa.apa34
            LET l_npq.npq07f= l_apa.apa34f
            LET l_npq.npq02 = l_npq.npq02 + 1
         END IF   #MOD-8C0010 add
      END IF
   END IF
   LET l_npq.npq11=''
   LET l_npq.npq12=''
   LET l_npq.npq13=''
   LET l_npq.npq14=''
   LET l_npq.npq31=''
   LET l_npq.npq32=''
   LET l_npq.npq33=''
   LET l_npq.npq34=''
   LET l_npq.npq35=''
   LET l_npq.npq36=''
   LET l_npq.npq37=''
   LET l_npq.npq23=l_apa.apa01   #MOD-7A0204
   LET l_npq.npq24=l_apa.apa13   #MOD-640262
   LET l_npq.npq25=l_apa.apa14   #MOD-640262
   LET g_npq25_1=l_npq.npq25     #FUN-9A0036
   LET l_npq.npq04 = NULL #FUN-D10065 add
   IF l_apa.apa56 = '3' OR l_apa.apa54 != 'MISC' THEN
     MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',l_npq.npq07
   SELECT aag05,aag21,aag23,aag371 INTO l_aag05,l_aag21,l_aag23,l_aag371   #CHI-760007
     FROM aag_file WHERE aag01=l_npq.npq03
                     AND aag00=g_bookno        #No.FUN-730064
   IF l_aag23='Y' THEN 
      LET l_npq.npq08 = l_apa.apa66 
   ELSE 
      LET l_npq.npq08 = null
   END IF
   LET l_npq.npq05 = ''   #MOD-B30089 add
   IF l_aag05='Y' THEN
      IF g_aaz.aaz90='N' THEN
         IF cl_null(l_npq.npq05) THEN
            LET l_npq.npq05 = l_apa.apa22
         END IF
      ELSE
         LET l_npq.npq05 = l_apa.apa930
      END IF
   ELSE
      LET l_npq.npq05 = ''           
   END IF
         IF l_npq.npq07 < 0 THEN
            LET l_npq.npq07 = l_npq.npq07  * -1
            LET l_npq.npq07f= l_npq.npq07f * -1
            IF l_npq.npq06 = '1'
               THEN LET l_npq.npq06 = '2'
               ELSE LET l_npq.npq06 = '1'
            END IF
         END IF
     IF l_npq.npq07!=0 THEN
        IF p_aptype[1,1] = '2' THEN
           LET l_npq.npq07 = (-1)*l_npq.npq07                                  
           LET l_npq.npq07f= (-1)*l_npq.npq07f 
        END IF
        LET p_prog = g_prog                       #MOD-C30056 add 
        #No.MOD-BC0264  --Begin
        CASE g_prog
                  WHEN 'aapp110' LET g_prog = 'aapt110'
                  WHEN 'aapp111' LET g_prog = 'aapt210'
                  WHEN 'aapp115' LET g_prog = 'aapt160'
                  WHEN 'aapp117' LET g_prog = 'aapt260'
        END CASE
        #No.MOD-BC0264  --End
        CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno)           #No.FUN-730064
        RETURNING l_npq.*
        #FUN-D10065--add--str--
        IF cl_null(l_npq.npq04) THEN
           CASE WHEN g_apz.apz55 = '1' AND l_apa.apa55 = '2' AND (p_aptype = '12' OR p_aptype = '13')
                     LET l_npq.npq04 = l_apa.apa07 CLIPPED,' ',l_apa.apa64
                WHEN g_apz.apz43 = '1'
                     LET l_npq.npq04 = l_apa.apa06 CLIPPED,' ',l_apa.apa07
                WHEN g_apz.apz43 = '2'
                     IF l_apa.apa08 = 'MISC' THEN
                        LET l_npq.npq04 = l_apa.apa06,' ',l_apa.apa07,' ',
                                          l_apa.apa01
                     ELSE
                        LET l_npq.npq04 = l_apa.apa06,' ',l_apa.apa07,' ',
                                          l_apa.apa08
                     END IF
                OTHERWISE
                     LET l_npq.npq04 = NULL
           END CASE
        END IF
        #FUN-D10065--add--end--
        LET g_prog = p_prog                       #MOD-C30056 add
        CALL s_def_npq31_npq34(l_npq.*,g_bookno) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34   #FUN-AA0087
         CALL t110_chk_aee(l_npq.*)
         RETURNING l_npq.*
        SELECT azi04 INTO t_azi04 FROM azi_file
          WHERE azi01 = l_npq.npq24
#No.FUN-9A0036 --Begin
            IF p_npptype = '1' THEN
#FUN-A40067 --Begin
               SELECT aaa03 INTO l_aaa03 FROM aaa_file
                WHERE aaa01 = g_bookno2
               SELECT azi04 INTO g_azi04_2 FROM azi_file
                WHERE azi01 = l_aaa03
#FUN-A40067 --End
               CALL s_newrate(g_bookno1,g_bookno2,l_npq.npq24,
                              g_npq25_1,l_npp.npp02)
               RETURNING l_npq.npq25
              # LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25  #TQC-B80204 mark
              # TQC-B80204 --begin
               IF l_npq.npq25 = g_npq25_1 AND g_azi04_2 = g_azi04 THEN
                  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)
               ELSE
                  LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
                  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2)
               END IF
              # TQC-B80204 --end
              # LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2) #FUN-A40067  #TQC-B80204 mark
            ELSE
               LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
            END IF
#No.FUN-9A0036 --End
        LET l_npq.npq07f = cl_digcut(l_npq.npq07f,t_azi04)
#       LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)          #FUN-A40067
      # IF l_aag371 MATCHES '[23]' THEN                           #FUN-950053 mark
        IF l_aag371 MATCHES '[234]' THEN                          #FUN-950053 add  
           #-->for 合併報表-關係人
           SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903
             FROM pmc_file
            WHERE pmc01 = l_apa.apa05
           IF cl_null(l_npq.npq37) THEN
              IF l_pmc903 = 'Y' THEN
                 LET l_npq.npq37 = l_apa.apa05 CLIPPED   #No.CHI-830037
              END IF
           END IF
        END IF
        LET l_npq.npqlegal = g_legal #FUN-980001 add
        #No.FUN-A30077  --Begin                                          
        CALL t110_entry_direction(g_bookno,l_npq.npq03,l_npq.npq06,      
                                  l_npq.npq07,l_npq.npq07f)              
             RETURNING l_npq.npq06,l_npq.npq07,l_npq.npq07f              
        #No.FUN-A30077  --End 
#No.FUN-AC0001 --begin                                                          
               IF cl_null(l_npq.npq35) THEN LET l_npq.npq35 = ' ' END IF        
               IF cl_null(l_npq.npq05) THEN LET l_npq.npq05 = ' ' END IF        
               IF cl_null(l_npq.npq08) THEN LET l_npq.npq08 = ' ' END IF        
#No.FUN-AC0001 --end 
       #FUN-D40118 ---Add--- Start
        SELECT aag44 INTO l_aag44 FROM aag_file
         WHERE aag00 = g_bookno3
           AND aag01 = l_npq.npq03
        IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
           CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
           IF l_flag = 'N'   THEN
              LET l_npq.npq03 = ''
           END IF
        END IF
       #FUN-D40118 ---Add--- End
        INSERT INTO npq_file VALUES (l_npq.*)
        IF STATUS THEN 
           IF g_bgerr THEN
              LET g_showmsg=l_npq.npq01,"/",l_npq.npq011,"/",l_npq.npq02,"/",l_npq.npqsys,"/",l_npq.npq00,"/",l_npq.npqtype
              CALL s_errmsg("npq01,npq011,npq02,npqsys,npq00,npqtype",g_showmsg,"t110_g_gl(ckp#4)",SQLCA.sqlcode,1)
           ELSE
              CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,STATUS,"","t110_g_gl(ckp#4)",1)  #No.FUN-660122
           END IF
           LET g_success='N' #no.5573
        END IF
     END IF
   END IF
END FUNCTION
 
FUNCTION t110_g_gl_2(p_aptype,p_apno,p_npptype)  #No.FUN-680029 新增p_npptype
   DEFINE p_aptype	LIKE apa_file.apa00
   DEFINE p_apno	LIKE apa_file.apa01
   DEFINE p_npptype     LIKE npp_file.npptype    #No.FUN-680029
   DEFINE l_aag05       LIKE aag_file.aag05
   DEFINE l_aag23       LIKE aag_file.aag23
   DEFINE l_apa		RECORD LIKE apa_file.*
   DEFINE l_apb		RECORD LIKE apb_file.*   #FUN-680110 add
   DEFINE l_api		RECORD LIKE api_file.*   #No.FUN-680029
   DEFINE l_api05       LIKE api_file.api05    #No.TQC-7B0083
   DEFINE l_api05f      LIKE api_file.api05f   #No.TQC-7B0083
   DEFINE l_apb29       LIKE apb_file.apb29,
          l_aag21       LIKE aag_file.aag21,
         #l_aag181      LIKE aag_file.aag181,   #MOD-750132
          l_aag371      LIKE aag_file.aag371,   #MOD-750132
          l_pmc03       LIKE pmc_file.pmc03,
          l_pmc903      LIKE pmc_file.pmc903
   DEFINE l_npq07       LIKE npq_file.npq07,   #FUN-680110 add
          l_npq07f      LIKE npq_file.npq07f,  #FUN-680110 add
          o_npq07       LIKE npq_file.npq07,   #FUN-680110 add
          o_npq07f      LIKE npq_file.npq07f   #FUN-680110 add
   DEFINE l_apb31       LIKE apb_file.apb31,
          l_apb35       LIKE apb_file.apb35,
          l_apb36       LIKE apb_file.apb36,
          l_azi03       LIKE azi_file.azi03,   #MOD-930244 add
          l_apb930      LIKE apb_file.apb930   #MOD-8C0067 add
   DEFINE l_apb25       LIKE apb_file.apb25    #MOD-920100 add
   DEFINE l_apb251      LIKE apb_file.apb251   #MOD-920100 add
   DEFINE l_sql         STRING
   DEFINE l_count       LIKE type_file.num5
   DEFINE l_oox07   DYNAMIC ARRAY OF RECORD 
                 oox07  LIKE oox_file.oox07
                    END RECORD 
   DEFINE l_aaa03       LIKE aaa_file.aaa03    #FUN-A40067
   DEFINE p_prog        LIKE type_file.chr20  #MOD-C30056 add
   DEFINE l_aag44       LIKE aag_file.aag44    #No.FUN-D40118   Add
   DEFINE l_flag        LIKE type_file.chr1    #No.FUN-D40118   Add
  
   SELECT * INTO l_apa.* FROM apa_file WHERE apa01 = p_apno
   LET l_npq07=0  LET l_npq07f=0    #FUN-680110 add
   LET o_npq07=0  LET o_npq07f=0    #FUN-680110 add
   IF STATUS THEN RETURN END IF
   CALL s_get_bookno(YEAR(l_apa.apa02)) 
        RETURNING g_flag,g_bookno1,g_bookno2
   IF g_flag = '1' THEN
      #CALL cl_err(l_apa.apa02,'aoo-081',1)   #FUN-D40089  mark
      CALL s_errmsg('',l_apa.apa02,p_apno,'aoo-081',1)     #FUN-D40089  add
   END IF
   IF p_npptype = '0' THEN
      LET g_bookno = g_bookno1
   ELSE 
      LET g_bookno = g_bookno2
   END IF
   IF l_apa.apa56 = '3' THEN RETURN END IF
           #No.FUN-710014  --Begin
   IF l_apa.apa42 = 'Y' THEN 
      IF g_bgerr THEN
         #CALL s_errmsg("apa42","Y","apa42=Y","aap-165",0)     #FUN-D40089 mark
         CALL s_errmsg("apa42","apa42=Y",p_apno,"aap-165",0)   #FUN-D40089 add
      ELSE
         CALL cl_err("apa42=Y",'aap-165',0) 
      END IF
      RETURN 
   END IF
   INITIALIZE l_npp.* TO NULL
   INITIALIZE l_npq.* TO NULL
 
   LET l_npp.npptype = p_npptype  #No.FUN-680029
   LET l_npq.npqtype = p_npptype  #No.FUN-680029
#-----------------------------------( Dr: Un-Invoice ALW )---------------------
   #-->單頭
   LET l_npp.nppsys = 'AP'
   LET l_npp.npp00  = 1
   LET l_npp.npp01  = l_apa.apa01 
   LET l_npp.npp011 = 1 
   LET l_npp.npp02  = l_apa.apa02
   LET l_npp.npp03  = NULL
   LET l_npp.npp05  = NULL
   LET l_npp.nppglno= NULL
   LET l_npp.npplegal = g_legal #FUN-980001 add
   INSERT INTO npp_file VALUES (l_npp.*)
   IF SQLCA.sqlcode THEN 
      IF g_bgerr THEN
         LET g_showmsg=l_npp.npp01,"/",l_npp.npp011,"/",l_npp.nppsys,"/",l_npp.npp00,"/",l_npp.npptype
         CALL s_errmsg("npp01,npp011,nppsys,npp00,npptype",g_showmsg,"insert npp_file",SQLCA.sqlcode,1)
      ELSE
         CALL cl_err3("ins","npp_file",l_npp.npp00,l_npp.npp01,SQLCA.sqlcode,"","insert npp_file",1)  #No.FUN-660122
      END IF
      LET g_success = 'N' 
   END IF
   #-->單身
   LET l_npq.npqsys = 'AP'
   LET l_npq.npq00  = 1
   LET l_npq.npq011 = 1 
   LET l_npq.npq01 = l_apa.apa01
   LET l_npq.npq02 = 1
   IF p_npptype = '0' THEN  #No.FUN-680029
      LET l_npq.npq03 = l_apa.apa54       #85-09-30
   ELSE
      LET l_npq.npq03 = l_apa.apa541
   END IF
   #No.MOD-C40189  --Begin
   #LET l_npq.npq04 = NULL
  ##FUN-D10065---mark--str
  # CASE WHEN g_apz.apz43 = '1'
  #          LET l_npq.npq04 = l_apa.apa06 CLIPPED,' ',l_apa.apa07
  #     WHEN g_apz.apz43 = '2'
  #          IF l_apa.apa08 = 'MISC' THEN
  #             LET l_npq.npq04 = l_apa.apa06,' ',l_apa.apa07,' ',
  #                               l_apa.apa01
  #          ELSE
  #             LET l_npq.npq04 = l_apa.apa06,' ',l_apa.apa07,' ',
  #                               l_apa.apa08
  #          END IF
  #     OTHERWISE
  #          LET l_npq.npq04 = NULL
  #END CASE
  ##FUN-D10065--mark--end
   #No.MOD-C40189  --End
   LET l_npq.npq23 = l_apa.apa01       #MOD-A70057
   LET l_npq.npq04 = NULL #FUN-D10065 add
   LET l_npq.npq24 = l_apa.apa13       #幣別
 
   SELECT aag05,aag23,aag371 INTO l_aag05,l_aag23,l_aag371 FROM aag_file   #CHI-760007
    WHERE aag01=l_npq.npq03
      AND aag00=g_bookno        #No.FUN-730064
 
   IF l_aag23='Y' THEN 
      LET l_npq.npq08 = l_apa.apa66 
   ELSE 
      LET l_npq.npq08 = null
   END IF
 
   LET l_npq.npq05 = ''   #MOD-B30089 add
   IF l_aag05='Y' THEN
      IF g_aaz.aaz90='N' THEN
         LET l_npq.npq05 = l_apa.apa22
      ELSE
         LET l_npq.npq05 = l_apa.apa930
      END IF
   ELSE
      LET l_npq.npq05 = ''           
   END IF
 
   LET l_npq.npq06 = '1'
   LET l_npq.npq07 = l_apa.apa34
   LET l_npq.npq07f= l_apa.apa34f
   LET l_npq.npq25 = l_apa.apa14
   LET g_npq25_1=l_npq.npq25    #FUN-9A0036
 
   LET l_npq.npq21 = l_apa.apa06
 
   LET l_npq.npq22 = l_apa.apa07
 
   IF l_npq.npq07!=0 THEN                    
      LET p_prog = g_prog                          #MOD-C30056 add 
      #No.MOD-BC0264  --Begin
      CASE g_prog
          WHEN 'aapp110' LET g_prog = 'aapt110'
          WHEN 'aapp111' LET g_prog = 'aapt210'
          WHEN 'aapp115' LET g_prog = 'aapt160'
          WHEN 'aapp117' LET g_prog = 'aapt260'
      END CASE
      #No.MOD-BC0264  --End
      CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno)        #No.FUN-730064
      RETURNING l_npq.*
      #FUN-D10065--add--str--
      IF cl_null(l_npq.npq04) THEN
         CASE WHEN g_apz.apz43 = '1'
                   LET l_npq.npq04 = l_apa.apa06 CLIPPED,' ',l_apa.apa07
              WHEN g_apz.apz43 = '2'
                   IF l_apa.apa08 = 'MISC' THEN
                      LET l_npq.npq04 = l_apa.apa06,' ',l_apa.apa07,' ',
                                        l_apa.apa01
                   ELSE
                      LET l_npq.npq04 = l_apa.apa06,' ',l_apa.apa07,' ',
                                        l_apa.apa08
                   END IF
              OTHERWISE
                   LET l_npq.npq04 = NULL
         END CASE
      END IF
      #FUN-D10065--add--end--
      LET g_prog = p_prog                       #MOD-C30056 add
      CALL s_def_npq31_npq34(l_npq.*,g_bookno) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34   #FUN-AA0087
       CALL t110_chk_aee(l_npq.*)
       RETURNING l_npq.*
      SELECT azi04 INTO t_azi04 FROM azi_file
        WHERE azi01 = l_npq.npq24
#No.FUN-9A0036 --Begin
            IF p_npptype = '1' THEN
#FUN-A40067 --Begin
               SELECT aaa03 INTO l_aaa03 FROM aaa_file
                WHERE aaa01 = g_bookno2
               SELECT azi04 INTO g_azi04_2 FROM azi_file
                WHERE azi01 = l_aaa03
#FUN-A40067 --End
               CALL s_newrate(g_bookno1,g_bookno2,l_npq.npq24,
                              g_npq25_1,l_npp.npp02)
               RETURNING l_npq.npq25
              # LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25  #TQC-B80204 mark
              # TQC-B80204 --begin
               IF l_npq.npq25 = g_npq25_1 AND g_azi04_2 = g_azi04 THEN
                  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)
               ELSE
                  LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
                  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2)
               END IF
              # TQC-B80204 --end
              # LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2) #FUN-A40067  #TQC-B80204 mark
            ELSE
               LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
            END IF
#No.FUN-9A0036 --End
      LET l_npq.npq07f = cl_digcut(l_npq.npq07f,t_azi04)
#     LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)            #FUN-A40067
    # IF l_aag371 MATCHES '[23]' THEN                             #FUN-950053 mark
      IF l_aag371 MATCHES '[234]' THEN                            #FUN-950053 add
         #-->for 合併報表-關係人
         SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903
           FROM pmc_file
          WHERE pmc01 = l_apa.apa05
         IF cl_null(l_npq.npq37) THEN
            IF l_pmc903 = 'Y' THEN
               LET l_npq.npq37 = l_apa.apa05 CLIPPED   #No.CHI-830037
            END IF
         END IF
      END IF
      LET l_npq.npqlegal = g_legal #FUN-980001 add
      #No.FUN-A30077  --Begin                                          
      CALL t110_entry_direction(g_bookno,l_npq.npq03,l_npq.npq06,      
                                l_npq.npq07,l_npq.npq07f)              
           RETURNING l_npq.npq06,l_npq.npq07,l_npq.npq07f              
      #No.FUN-A30077  --End 
#No.FUN-AC0001 --begin                                                          
               IF cl_null(l_npq.npq35) THEN LET l_npq.npq35 = ' ' END IF        
               IF cl_null(l_npq.npq05) THEN LET l_npq.npq05 = ' ' END IF        
               IF cl_null(l_npq.npq08) THEN LET l_npq.npq08 = ' ' END IF        
#No.FUN-AC0001 --end 
     #FUN-D40118 ---Add--- Start
      SELECT aag44 INTO l_aag44 FROM aag_file
       WHERE aag00 = g_bookno3
         AND aag01 = l_npq.npq03
      IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
         CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET l_npq.npq03 = ''
         END IF
      END IF
     #FUN-D40118 ---Add--- End
      INSERT INTO npq_file VALUES (l_npq.*)
      MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',l_npq.npq07
      IF SQLCA.sqlcode THEN 
         IF g_bgerr THEN
            LET g_showmsg=l_npq.npq01,"/",l_npq.npq011,"/",l_npq.npq02,"/",l_npq.npqsys,"/",l_npq.npq00,"/",l_npq.npqtype
            CALL s_errmsg("npq01,npq011,npq02,npqsys,npq00,npqtype",g_showmsg,"t110_g_gl(ckp#5)",SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,SQLCA.sqlcode,"","t110_g_gl(ckp#5)",1)  #No.FUN-660122
         END IF
         LET g_success='N' #no.5573
      END IF
   END IF
#-----------------------------------( Dr/Cr: Diff        )---------------------
   IF l_apa.apa33 != 0 THEN
      LET l_npq.npq02 = l_npq.npq02 + 1
      IF p_npptype = '0' THEN  #No.FUN-680029
         LET l_npq.npq03 = l_apa.apa51
      ELSE
         LET l_npq.npq03 = l_apa.apa511
      END IF
      LET l_npq.npq04 = NULL
      IF l_apa.apa33 > 0 THEN
         LET l_npq.npq06 = '1'
         LET l_npq.npq07 = l_apa.apa33
         LET l_npq.npq07f= l_apa.apa33f
      ELSE 
         LET l_npq.npq06 = '2'
         LET l_npq.npq07 = l_apa.apa33 * -1
         LET l_npq.npq07f= l_apa.apa33f* -1
      END IF

      #MOD-D40097 add begin---
      IF p_aptype = '21' THEN
         IF l_npq.npq06 = '1' THEN 
            LET l_npq.npq06 = '2'
         ELSE 
            LET l_npq.npq06 = '1'
         END IF
      END IF
      #MOD-D40097 add end-----

      SELECT aag05,aag23,aag371 INTO l_aag05,l_aag23,l_aag371 FROM aag_file   #CHI-760007
       WHERE aag01=l_npq.npq03
         AND aag00=g_bookno        #No.FUN-730064
      IF l_aag23='Y' THEN 
         LET l_npq.npq08 = l_apa.apa66 
      ELSE 
         LET l_npq.npq08 = null
      END IF
      LET l_npq.npq05 = ''   #MOD-B30089 add
      IF l_aag05='Y' THEN
         IF g_aaz.aaz90='N' THEN
            LET l_npq.npq05 = l_apa.apa22
         ELSE
            LET l_npq.npq05 = l_apa.apa930
         END IF
      ELSE
         LET l_npq.npq05 = ''           
      END IF
      IF l_npq.npq07!=0 THEN                    
         LET p_prog = g_prog                          #MOD-C30056 add 
         #No.MOD-BC0264  --Begin
         CASE g_prog
                  WHEN 'aapp110' LET g_prog = 'aapt110'
                  WHEN 'aapp111' LET g_prog = 'aapt210'
                  WHEN 'aapp115' LET g_prog = 'aapt160'
                  WHEN 'aapp117' LET g_prog = 'aapt260'
         END CASE
         #No.MOD-BC0264  --End
         CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno)            #No.FUN-730064
         RETURNING l_npq.*
          #FUN-D10065---add---str
         IF cl_null(l_npq.npq04) THEN
            CASE WHEN g_apz.apz43 = '1'
                      LET l_npq.npq04 = l_apa.apa06 CLIPPED,' ',l_apa.apa07
                 WHEN g_apz.apz43 = '2'
                      IF l_apa.apa08 = 'MISC' THEN
                         LET l_npq.npq04 = l_apa.apa06,' ',l_apa.apa07,' ',
                                           l_apa.apa01
                      ELSE
                         LET l_npq.npq04 = l_apa.apa06,' ',l_apa.apa07,' ',
                                           l_apa.apa08
                      END IF
                 OTHERWISE
                      LET l_npq.npq04 = NULL
            END CASE
         END IF
         #FUN-D10065--add--end--
         LET g_prog = p_prog                       #MOD-C30056 add
         CALL s_def_npq31_npq34(l_npq.*,g_bookno) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34   #FUN-AA0087
          CALL t110_chk_aee(l_npq.*)
          RETURNING l_npq.*
         SELECT azi04 INTO t_azi04 FROM azi_file
           WHERE azi01 = l_npq.npq24
#No.FUN-9A0036 --Begin
            IF p_npptype = '1' THEN
#FUN-A40067 --Begin
               SELECT aaa03 INTO l_aaa03 FROM aaa_file
                WHERE aaa01 = g_bookno2
               SELECT azi04 INTO g_azi04_2 FROM azi_file
                WHERE azi01 = l_aaa03
#FUN-A40067 --End
               CALL s_newrate(g_bookno1,g_bookno2,l_npq.npq24,
                              g_npq25_1,l_npp.npp02)
               RETURNING l_npq.npq25
              # LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25  #TQC-B80204 mark
              # TQC-B80204 --begin
               IF l_npq.npq25 = g_npq25_1 AND g_azi04_2 = g_azi04 THEN
                  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)
               ELSE
                  LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
                  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2)
               END IF
              # TQC-B80204 --end
              # LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2) #FUN-A40067  #TQC-B80204 mark
            ELSE
               LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
            END IF
#No.FUN-9A0036 --End
         LET l_npq.npq07f = cl_digcut(l_npq.npq07f,t_azi04)
#        LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)         #FUN-A40067
       # IF l_aag371 MATCHES '[23]' THEN                          #FUN-950053 mark
         IF l_aag371 MATCHES '[234]' THEN                         #FUN-950053 add 
            #-->for 合併報表-關係人
            SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903
              FROM pmc_file
             WHERE pmc01 = l_apa.apa05
            IF cl_null(l_npq.npq37) THEN
               IF l_pmc903 = 'Y' THEN
                  LET l_npq.npq37 = l_apa.apa05 CLIPPED   #No.CHI-830037
               END IF
            END IF
         END IF
         LET l_npq.npqlegal = g_legal #FUN-980001 add
         #No.FUN-A30077  --Begin                                          
         CALL t110_entry_direction(g_bookno,l_npq.npq03,l_npq.npq06,      
                                   l_npq.npq07,l_npq.npq07f)              
              RETURNING l_npq.npq06,l_npq.npq07,l_npq.npq07f              
         #No.FUN-A30077  --End 
#No.FUN-AC0001 --begin                                                          
               IF cl_null(l_npq.npq35) THEN LET l_npq.npq35 = ' ' END IF        
               IF cl_null(l_npq.npq05) THEN LET l_npq.npq05 = ' ' END IF        
               IF cl_null(l_npq.npq08) THEN LET l_npq.npq08 = ' ' END IF        
#No.FUN-AC0001 --end 
        #FUN-D40118 ---Add--- Start
         SELECT aag44 INTO l_aag44 FROM aag_file
          WHERE aag00 = g_bookno3
            AND aag01 = l_npq.npq03
         IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
            CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET l_npq.npq03 = ''
            END IF
         END IF
        #FUN-D40118 ---Add--- End
         INSERT INTO npq_file VALUES (l_npq.*)
         MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',l_npq.npq07
         IF SQLCA.sqlcode THEN 
            IF g_bgerr THEN
               LET g_showmsg=l_npq.npq01,"/",l_npq.npq011,"/",l_npq.npq02,"/",l_npq.npqsys,"/",l_npq.npq00,"/",l_npq.npqtype
               CALL s_errmsg("npq01,npq011,npq02,npqsys,npq00,npqtype",g_showmsg,"t110_g_gl(ckp#3)",SQLCA.sqlcode,1)
            ELSE
               CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,SQLCA.sqlcode,"","t110_g_gl(ckp#3)",1)  #No.FUN-660122
            END IF
            LET g_success='N' #no.5573
         END IF
      END IF
   END IF
 
   IF p_npptype = '0' THEN
      IF l_apa.apa51 = 'MISC' OR l_apa.apa51 = 'UNAP' THEN
         LET g_sql = " SELECT * FROM api_file ",
                     "  WHERE api01 = '",p_apno,"'",
                     "    AND (api04 IS NOT NULL AND api04 <> ' ')"
         PREPARE t110_gl_p12 FROM g_sql
         DECLARE t110_gl_c12 CURSOR FOR t110_gl_p12
         LET l_sql = "select oox07 from oox_file where oox00 = 'AP' ",
                     "   and oox03 = ? and oox041 = ? ",
                     "order by oox01 desc,oox02 desc"
         PREPARE t110_oox071 FROM l_sql
         DECLARE t110_oox07_cl1 CURSOR FOR t110_oox071
   
         LET l_npq24_o = l_npq.npq24  #No.TQC-7C0149
         LET l_npq25_o = l_npq.npq25  #No.TQC-7C0149
         FOREACH t110_gl_c12 INTO l_api.*
            IF STATUS THEN 
               EXIT FOREACH 
            END IF
   
            LET l_npq.npq02 = l_npq.npq02 + 1
            LET l_npq.npq03 = l_api.api04
            LET l_npq.npq04 = NULL     #FUN-D10065  add
           #FUN-D10065--mark--str--
           #LET l_npq.npq04 = l_api.api06
   
           #IF cl_null(l_npq.npq04) THEN
           #   LET l_npq.npq04 = l_apa.apa25
           #END IF
           #FUN-D10065--mark--end--

            IF NOT cl_null(l_api.api26) AND l_api.api26 <> 'DIFF' THEN
               SELECT apa13 INTO l_npq.npq24                    #MOD-930244
                 FROM apa_file
                WHERE apa01 = l_api.api26
               IF SQLCA.sqlcode THEN
                  LET l_npq.npq24 = l_npq24_o
               END IF
            END IF
            SELECT azi03 INTO l_azi03 FROM azi_file WHERE azi01 =l_npq.npq24
            IF cl_null(l_api.api05) THEN
               LET l_api.api05 =0
            END IF
            IF cl_null(l_api.api05f) THEN
               LET l_api.api05f =1
            END IF
            LET l_npq.npq25=''
            IF g_apz.apz27 = 'Y' THEN   #有做重評價
                LET l_count = 1 
                #FOREACH t110_oox07_cl1 USING l_api.api26,l_api.api40   #CHI-E30030 mark
                FOREACH t110_oox07_cl1 USING l_api.api26,'1'           #CHI-E30030 add
                                      INTO l_oox07[l_count].*
                    IF STATUS THEN 
                       CALL cl_err('forach:',STATUS,1)
                       EXIT FOREACH
                    END IF         
                    LET l_npq.npq25 = l_oox07[l_count].oox07
                    LET l_count = l_count + 1
                    IF l_count = 2 THEN 
                       EXIT FOREACH 
                    END IF            
                END FOREACH                                          
            END IF
            IF cl_null(l_npq.npq25) THEN
              #-MOD-B10093-add-
               IF l_api.api02 = '1' THEN  
                  LET l_npq.npq25 = l_apa.apa14   
               ELSE
              #-MOD-B10093-end-
                #str MOD-B70140 add
                 IF l_api.api26 = 'DIFF' THEN
                    LET l_npq.npq25 = 1
                 ELSE
                #end MOD-B70140 add
                 #-MOD-A60160-add-
                  SELECT apa14 INTO l_npq.npq25    
                    FROM apa_file
                   WHERE apa01 = l_api.api26
                 #-MOD-A60160-end-
                 END IF   #MOD-B70140 add
               END IF                  #MOD-B10093
              #LET l_npq.npq25 =l_api.api05/l_api.api05f        #MOD-A60160 mark
              #LET l_npq.npq25 =cl_digcut(l_npq.npq25,l_azi03)  #MOD-AC0049 mark
            END IF
            LET g_npq25_1=l_npq.npq25    #FUN-9A0036
            LET l_npq.npq06 = '2'
            LET l_npq.npq07 = l_api.api05
            LET l_npq.npq07f = l_api.api05f
            LET l_aag05 = ' '
            LET l_aag21 = ' '
            LET l_aag23 = ' '
            LET l_aag371 = ' '   #MOD-750132
   
            SELECT aag05,aag21,aag23,aag371 INTO l_aag05,l_aag21,l_aag23,l_aag371   #MOD-5A0274   #MOD-750132
              FROM aag_file
             WHERE aag01 = l_npq.npq03
               AND aag00=g_bookno        #No.FUN-730064
   
            IF l_aag23 = 'Y' THEN
               LET l_npq.npq08 = l_api.api26    # 專案
               LET l_npq.npq35 = l_api.api35    #CHI-A30003 add
            ELSE
               LET l_npq.npq08 = NULL
               LET l_npq.npq35 = NULL           #CHI-A30003 add  
            END IF
   
            LET o_npq07 = o_npq07 + l_npq.npq07    #FUN-680110 add   #MOD-7A0069 mod
            LET o_npq07f= o_npq07f+ l_npq.npq07f   #FUN-680110 add   #MOD-7A0069 mod
            IF l_npq.npq07 < 0 THEN
               LET l_npq.npq07 = l_npq.npq07 * -1
               LET l_npq.npq07f = l_npq.npq07f * -1
               IF l_npq.npq06 = '2' THEN 
                  LET l_npq.npq06 = '1'
               ELSE
                  LET l_npq.npq06 = '2'
               END IF
            END IF
   
            LET l_npq.npq05 = ''   #MOD-B30089 add
            IF l_aag05='Y' THEN
               IF g_aaz.aaz90='N' THEN
                  LET l_npq.npq05 = l_api.api07
               ELSE
                 #LET l_npq.npq05 = l_apa.apa930   #MOD-8C0067 mark
                  LET l_npq.npq05 = l_api.api930   #MOD-8C0067
               END IF
            ELSE
               LET l_npq.npq05 = ''
            END IF
   
            LET l_npq.npq11 = l_api.api21
            LET l_npq.npq12 = l_api.api22
            LET l_npq.npq13 = l_api.api23
            LET l_npq.npq14 = l_api.api24
            LET l_npq.npq31 = l_api.api31
            LET l_npq.npq32 = l_api.api32
            LET l_npq.npq33 = l_api.api33
            LET l_npq.npq34 = l_api.api34
           #LET l_npq.npq35 = l_api.api35    #CHI-A30003 mark
            SELECT aag21 INTO l_aag21 FROM aag_file
             WHERE aag00 = g_bookno
               AND aag01 = l_npq.npq03               
            IF l_aag21 = 'Y' THEN             #MOD-950096 
               LET l_npq.npq36 = l_api.api36 
            END IF                            #MOD-950096    
            LET l_npq.npq37 = l_api.api37
   
            IF l_npq.npq07 != 0 THEN 
               IF p_aptype[1,1] = '1' THEN
                  LET l_npq.npq07 = (-1)*l_npq.npq07                                  
                  LET l_npq.npq07f= (-1)*l_npq.npq07f 
               END IF
               CALL s_def_npq5(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno)   #No.FUN-730064  #MOD-860011
               RETURNING l_npq.*
               #FUN-D10065--add--str--
               IF cl_null(l_npq.npq04) THEN
                  LET l_npq.npq04 = l_api.api06
               END IF
               IF cl_null(l_npq.npq04) THEN
                  LET l_npq.npq04 = l_apa.apa25
               END IF
               #FUN-D10065--add--end--
               CALL s_def_npq31_npq34(l_npq.*,g_bookno) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34   #FUN-AA0087
               CALL t110_chk_aee(l_npq.*)
               RETURNING l_npq.*
               SELECT azi04 INTO t_azi04 FROM azi_file
                 WHERE azi01 = l_npq.npq24
#No.FUN-9A0036 --Begin
            IF p_npptype = '1' THEN
#FUN-A40067 --Begin
               SELECT aaa03 INTO l_aaa03 FROM aaa_file
                WHERE aaa01 = g_bookno2
               SELECT azi04 INTO g_azi04_2 FROM azi_file
                WHERE azi01 = l_aaa03
#FUN-A40067 --End
               CALL s_newrate(g_bookno1,g_bookno2,l_npq.npq24,
                              g_npq25_1,l_npp.npp02)
               RETURNING l_npq.npq25
              # LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25  #TQC-B80204 mark
              # TQC-B80204 --begin
               IF l_npq.npq25 = g_npq25_1 AND g_azi04_2 = g_azi04 THEN
                  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)
               ELSE
                  LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
                  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2)
               END IF
              # TQC-B80204 --end
              # LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2) #FUN-A40067 #TQC-B80204 mark
            ELSE
               LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
            END IF
#No.FUN-9A0036 --End
               LET l_npq.npq07f = cl_digcut(l_npq.npq07f,t_azi04)
#              LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
             # IF l_aag371 MATCHES '[23]' THEN                    #FUN-950053 mark
               IF l_aag371 MATCHES '[234]' THEN                   #FUN-950053 add    
                  #-->for 合併報表-關係人
                  SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903 FROM pmc_file
                   WHERE pmc01 = l_apa.apa05
                  IF cl_null(l_npq.npq37) THEN
                     IF l_pmc903 = 'Y' THEN
                        LET l_npq.npq37 = l_apa.apa05 CLIPPED   #No.CHI-830037
                     END IF
                  END IF
               END IF
               LET l_npq.npqlegal = g_legal #FUN-980001 add
               #No.FUN-A30077  --Begin                                          
               CALL t110_entry_direction(g_bookno,l_npq.npq03,l_npq.npq06,      
                                         l_npq.npq07,l_npq.npq07f)              
                    RETURNING l_npq.npq06,l_npq.npq07,l_npq.npq07f              
               #No.FUN-A30077  --End 
#No.FUN-AC0001 --begin                                                          
               IF cl_null(l_npq.npq35) THEN LET l_npq.npq35 = ' ' END IF        
               IF cl_null(l_npq.npq05) THEN LET l_npq.npq05 = ' ' END IF        
               IF cl_null(l_npq.npq08) THEN LET l_npq.npq08 = ' ' END IF        
#No.FUN-AC0001 --end 
              #FUN-D40118 ---Add--- Start
               SELECT aag44 INTO l_aag44 FROM aag_file
                WHERE aag00 = g_bookno3
                  AND aag01 = l_npq.npq03
               IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
                  CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
                  IF l_flag = 'N'   THEN
                     LET l_npq.npq03 = ''
                  END IF
               END IF
              #FUN-D40118 ---Add--- End
               INSERT INTO npq_file VALUES (l_npq.*)
               MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',l_npq.npq07
               IF STATUS THEN 
                  IF g_bgerr THEN
                     LET g_showmsg=l_npq.npq01,"/",l_npq.npq011,"/",l_npq.npq02,"/",l_npq.npqsys,"/",l_npq.npq00,"/",l_npq.npqtype
                     CALL s_errmsg("npq01,npq011,npq02,npqsys,npq00,npqtype",g_showmsg,"t110_g_gl(ckp#1)",SQLCA.sqlcode,1)
                  ELSE
                     CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,STATUS,"","t110_g_gl(ckp#1)",1)
                  END IF
                  LET g_success = 'N'
                  EXIT FOREACH  #no.5573
               END IF
            END IF
            LET l_npq.npq24 = l_npq24_o    #No.TQC-7C0149
            LET l_npq.npq25 = l_npq25_o    #No.TQC-7C0149
            LET g_npq25_1=l_npq.npq25      #No.FUN-9A0036
         END FOREACH
      END IF
      #UNAP除了api資料外,還要考慮apb_file & apb34 = 'N'的資料
      IF l_apa.apa51 = 'UNAP' THEN
         CALL t110_unap_npq1(p_apno,p_aptype,g_bookno,l_apa.*,'0','2')
      END IF
   ELSE
      IF l_apa.apa511 = 'MISC' OR l_apa.apa511 = 'UNAP' THEN
         LET g_sql = " SELECT * FROM api_file ",
                     "  WHERE api01 = '",p_apno,"'",
                     "    AND (api041 IS NOT NULL AND api041 <> ' ')"
         PREPARE t110_gl_p13 FROM g_sql
         DECLARE t110_gl_c13 CURSOR FOR t110_gl_p13
         LET l_sql = "select oox07 from oox_file where oox00 = 'AP' ",
                     "   and oox03 = ? and oox041 = ? ",
                     "order by oox01 desc,oox02 desc"
         PREPARE t110_oox072 FROM l_sql
         DECLARE t110_oox07_cl2 CURSOR FOR t110_oox072
   
         LET l_npq24_o = l_npq.npq24  #No.TQC-7C0149
         LET l_npq25_o = l_npq.npq25  #No.TQC-7C0149
         FOREACH t110_gl_c13 INTO l_api.*
            IF STATUS THEN 
               EXIT FOREACH 
            END IF
   
            LET l_npq.npq02 = l_npq.npq02 + 1
            LET l_npq.npq03 = l_api.api041
            LET l_npq.npq04 = NULL      #FUN-D10065  add
           #FUN-D10065--mark--str--
           #LET l_npq.npq04 = l_api.api06
   
           #IF cl_null(l_npq.npq04) THEN
           #   LET l_npq.npq04 = l_apa.apa25
           #END IF
           #FUN-D10065---mark--end 
            IF NOT cl_null(l_api.api26) AND l_api.api26 <> 'DIFF' THEN
               SELECT apa13 INTO l_npq.npq24                    #MOD-930244
                 FROM apa_file
                WHERE apa01 = l_api.api26
               IF SQLCA.sqlcode THEN
                  LET l_npq.npq24 = l_npq24_o
               END IF
            END IF
            SELECT azi03 INTO l_azi03 FROM azi_file WHERE azi01 =l_npq.npq24
            IF cl_null(l_api.api05) THEN
               LET l_api.api05 =0
            END IF
            IF cl_null(l_api.api05f) THEN
               LET l_api.api05f =1
            END IF
            LET l_npq.npq25=''
            IF g_apz.apz27 = 'Y' THEN   #有做重評價
                LET l_count = 1 
                #FOREACH t110_oox07_cl2 USING l_api.api26,l_api.api40   #CHI-E30030 mark
                FOREACH t110_oox07_cl2 USING l_api.api26,'1'           #CHI-E30030 add
                                      INTO l_oox07[l_count].*
                    IF STATUS THEN 
                       CALL cl_err('forach:',STATUS,1)
                       EXIT FOREACH
                    END IF         
                    LET l_npq.npq25 = l_oox07[l_count].oox07
                    LET l_count = l_count + 1
                    IF l_count = 2 THEN 
                       EXIT FOREACH 
                    END IF            
                END FOREACH                                          
            END IF
            IF cl_null(l_npq.npq25) THEN
              #-MOD-B10093-add-
               IF l_api.api02 = '1' THEN  
                  LET l_npq.npq25 = l_apa.apa14   
               ELSE
              #-MOD-B10093-end-
                #str MOD-B70140 add
                 IF l_api.api26 = 'DIFF' THEN
                    LET l_npq.npq25 = 1
                 ELSE
                #end MOD-B70140 add
                 #-MOD-A60160-add-
                  SELECT apa14 INTO l_npq.npq25    
                    FROM apa_file
                   WHERE apa01 = l_api.api26
                 #-MOD-A60160-end-
                 END IF   #MOD-B70140 add
               END IF                  #MOD-B10093
              #LET l_npq.npq25 =l_api.api05/l_api.api05f        #MOD-A60160 mark
              #LET l_npq.npq25 =cl_digcut(l_npq.npq25,l_azi03)  #MOD-AC0049 mark
            END IF
            LET g_npq25_1=l_npq.npq25      #No.FUN-9A0036
            LET l_npq.npq06 = '2'
            LET l_npq.npq07 = l_api.api05
            LET l_npq.npq07f = l_api.api05f
            LET l_aag05 = ' '
            LET l_aag21 = ' '
            LET l_aag23 = ' '
            LET l_aag371 = ' '   #MOD-750132
   
            SELECT aag05,aag21,aag23,aag371 INTO l_aag05,l_aag21,l_aag23,l_aag371   #MOD-750132
              FROM aag_file
             WHERE aag01 = l_npq.npq03
               AND aag00=g_bookno        #No.FUN-730064
   
            IF l_aag23 = 'Y' THEN
               LET l_npq.npq08 = l_api.api26
               LET l_npq.npq35 = l_api.api35    #CHI-A30003 add
            ELSE
               LET l_npq.npq08 = NULL
               LET l_npq.npq35 = NULL           #CHI-A30003 add
            END IF
   
            LET o_npq07 = o_npq07 + l_npq.npq07    #FUN-680110 add   #MOD-7A0069 mod
            LET o_npq07f= o_npq07f+ l_npq.npq07f   #FUN-680110 add   #MOD-7A0069 mod
            IF l_npq.npq07 < 0 THEN
               LET l_npq.npq07 = l_npq.npq07 * -1
               LET l_npq.npq07f = l_npq.npq07f * -1
               IF l_npq.npq06 = '2' THEN 
                  LET l_npq.npq06 = '1'
               ELSE
                  LET l_npq.npq06 = '2'
               END IF
            END IF
   
            LET l_npq.npq05 = ''   #MOD-B30089 add
            IF l_aag05='Y' THEN
               IF g_aaz.aaz90='N' THEN
                  LET l_npq.npq05 = l_api.api07
               ELSE
                  LET l_npq.npq05 = l_api.api930   #MOD-8C0067
               END IF
            ELSE
               LET l_npq.npq05 = ''
            END IF
   
            LET l_npq.npq11 = l_api.api21
            LET l_npq.npq12 = l_api.api22
            LET l_npq.npq13 = l_api.api23
            LET l_npq.npq14 = l_api.api24
            LET l_npq.npq31 = l_api.api31
            LET l_npq.npq32 = l_api.api32
            LET l_npq.npq33 = l_api.api33
            LET l_npq.npq34 = l_api.api34
           #LET l_npq.npq35 = l_api.api35      #CHI-A30003 mark
            SELECT aag21 INTO l_aag21 FROM aag_file
             WHERE aag00 = g_bookno
               AND aag01 = l_npq.npq03               
            IF l_aag21 = 'Y' THEN             #MOD-950096 
               LET l_npq.npq36 = l_api.api36 
            END IF                            #MOD-950096    
            LET l_npq.npq37 = l_api.api37
   
            IF l_npq.npq07 != 0 THEN 
               IF p_aptype[1,1] = '1' THEN
                  LET l_npq.npq07 = (-1)*l_npq.npq07                                  
                  LET l_npq.npq07f= (-1)*l_npq.npq07f 
               END IF
               CALL s_def_npq5(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno)   #No.FUN-730064  #MOD-860011
               RETURNING l_npq.*
               #FUN-D10065--add--str--
               IF cl_null(l_npq.npq04) THEN
                  LET l_npq.npq04 = l_api.api06
               END IF
               IF cl_null(l_npq.npq04) THEN
                  LET l_npq.npq04 = l_apa.apa25
               END IF
               #FUN-D10065--add--end--
               CALL s_def_npq31_npq34(l_npq.*,g_bookno) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34    #FUN-AA0087
               CALL t110_chk_aee(l_npq.*)
               RETURNING l_npq.*
               SELECT azi04 INTO t_azi04 FROM azi_file
                 WHERE azi01 = l_npq.npq24
#No.FUN-9A0036 --Begin
            IF p_npptype = '1' THEN
#FUN-A40067 --Begin
               SELECT aaa03 INTO l_aaa03 FROM aaa_file
                WHERE aaa01 = g_bookno2
               SELECT azi04 INTO g_azi04_2 FROM azi_file
                WHERE azi01 = l_aaa03
#FUN-A40067 --End
               CALL s_newrate(g_bookno1,g_bookno2,l_npq.npq24,
                              g_npq25_1,l_npp.npp02)
               RETURNING l_npq.npq25
              # LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25  #TQC-B80204 mark
              # TQC-B80204 --begin
               IF l_npq.npq25 = g_npq25_1 AND g_azi04_2 = g_azi04 THEN
                  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)
               ELSE
                  LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
                  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2)
               END IF
              # TQC-B80204 --end
              # LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2) #FUN-A40067  #TQC-B80204 mark
            ELSE
               LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
            END IF
#No.FUN-9A0036 --End
               LET l_npq.npq07f = cl_digcut(l_npq.npq07f,t_azi04)
#              LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
             # IF l_aag371 MATCHES '[23]' THEN                    #FUN-950053 mark
               IF l_aag371 MATCHES '[234]' THEN                   #FUN-950053 add
                  #-->for 合併報表-關係人
                  SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903 FROM pmc_file
                   WHERE pmc01 = l_apa.apa05
                  IF cl_null(l_npq.npq37) THEN
                     IF l_pmc903 = 'Y' THEN
                        LET l_npq.npq37 = l_apa.apa05 CLIPPED   #No.CHI-830037
                     END IF
                  END IF
               END IF
               LET l_npq.npqlegal = g_legal #FUN-980001 add
               #No.FUN-A30077  --Begin                                          
               CALL t110_entry_direction(g_bookno,l_npq.npq03,l_npq.npq06,      
                                         l_npq.npq07,l_npq.npq07f)              
                    RETURNING l_npq.npq06,l_npq.npq07,l_npq.npq07f              
               #No.FUN-A30077  --End 
#No.FUN-AC0001 --begin                                                          
               IF cl_null(l_npq.npq35) THEN LET l_npq.npq35 = ' ' END IF        
               IF cl_null(l_npq.npq05) THEN LET l_npq.npq05 = ' ' END IF        
               IF cl_null(l_npq.npq08) THEN LET l_npq.npq08 = ' ' END IF        
#No.FUN-AC0001 --end 
              #FUN-D40118 ---Add--- Start
               SELECT aag44 INTO l_aag44 FROM aag_file
                WHERE aag00 = g_bookno3
                  AND aag01 = l_npq.npq03
               IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
                  CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
                  IF l_flag = 'N'   THEN
                     LET l_npq.npq03 = ''
                  END IF
               END IF
              #FUN-D40118 ---Add--- End
               INSERT INTO npq_file VALUES (l_npq.*)
               MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',l_npq.npq07
               IF STATUS THEN 
                  IF g_bgerr THEN
                     LET g_showmsg=l_npq.npq01,"/",l_npq.npq011,"/",l_npq.npq02,"/",l_npq.npqsys,"/",l_npq.npq00,"/",l_npq.npqtype
                     CALL s_errmsg("npq01,npq011,npq02,npqsys,npq00,npqtype",g_showmsg,"t110_g_gl(ckp#1)",SQLCA.sqlcode,1)
                  ELSE
                     CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,STATUS,"","t110_g_gl(ckp#1)",1)
                  END IF
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF
            END IF
            LET l_npq.npq24 = l_npq24_o   #No.TQC-7C0149
            LET l_npq.npq25 = l_npq25_o   #No.TQC-7C0149
            LET g_npq25_1=l_npq.npq25     #No.FUN-9A0036
         END FOREACH
      END IF
      #UNAP除了api資料外,還要考慮apb_file & apb34 = 'N'的資料
      IF l_apa.apa51 = 'UNAP' THEN
         CALL t110_unap_npq1(p_apno,p_aptype,g_bookno,l_apa.*,'1','2')
      END IF
   END IF
 
#-----------------------------------( Cr: ALW            )---------------------
   IF p_npptype = '0' THEN  #No.FUN-680029
      IF l_apa.apa51 = 'STOCK' THEN
         CALL t110_stock(p_apno,l_apa.apa66,p_npptype,p_aptype)  #No.FUN-680029 新增p_npptype  #MOD-960127 add p_aptype 
         CALL t110_unap_npq2(p_apno,p_aptype,g_bookno,l_apa.*,'0','2')   #No.TQC-7B0083
      END IF
      IF l_apa.apa51 !='STOCK' AND l_apa.apa51 != 'UNAP' AND                                                                     
         l_apa.apa51 != 'MISC' AND NOT cl_null(l_apa.apa51) THEN  #No.FUN-680029 
         LET l_npq.npq02 = l_npq.npq02 + 1
         LET l_npq.npq03 = l_apa.apa51         #85-09-30
         #No.MOD-C40189  --Begin
         #CASE WHEN g_apz.apz43 = '1' 
         #          LET l_npq.npq04 = l_apa.apa06 CLIPPED,' ',l_apa.apa07
         #     WHEN g_apz.apz43 = '2'
         #          IF l_apa.apa08 = 'MISC' THEN
         #             LET l_npq.npq04 = l_apa.apa06,' ',l_apa.apa07,' ',
         #                               l_apa.apa01
         #          ELSE
         #             LET l_npq.npq04 = l_apa.apa06,' ',l_apa.apa07,' ',
         #                               l_apa.apa08
         #          END IF
         #     OTHERWISE
         #          LET l_npq.npq04 = NULL
         #END CASE
         LET l_npq.npq04 = NULL      #FUN-D10065
         #No.MOD-C40189  --End
         #CASE WHEN g_apz.apz43 = '1' 
         #apa51中的值要去掉衝暫估金額,衝暫估金額要獨立insert npq
         LET l_api05f = 0   LET l_api05 = 0
         SELECT SUM(api05f),SUM(api05) INTO l_api05f,l_api05 FROM api_file
          WHERE api01=l_apa.apa01 AND api02 = '2'
         IF cl_null(l_api05f) THEN LET l_api05f = 0 END IF 
         IF cl_null(l_api05 ) THEN LET l_api05  = 0 END IF 
         LET l_npq.npq06 = '2'
         LET l_npq.npq07 = l_apa.apa31 - l_api05     #No.TQC-7B0083
         LET l_npq.npq07f= l_apa.apa31f - l_api05f   #No.TQC-7B0083
         SELECT aag05,aag23,aag371 INTO l_aag05,l_aag23,l_aag371 FROM aag_file   #CHI-760007
          WHERE aag01=l_npq.npq03
            AND aag00=g_bookno        #No.FUN-730064
         IF l_aag23='Y' THEN 
            LET l_npq.npq08 = l_apa.apa66 
         ELSE 
            LET l_npq.npq08 = null
         END IF
         LET l_npq.npq05 = ''   #MOD-B30089 add
         IF l_aag05='Y' THEN
            IF g_aaz.aaz90='N' THEN
               LET l_npq.npq05 = l_apa.apa22
            ELSE
               LET l_npq.npq05 = l_apa.apa930
            END IF
         ELSE
            LET l_npq.npq05 = ''           
         END IF
        #IF l_npq.npq07!=0 THEN                         #MOD-D40097 mark 
         IF l_npq.npq07 != 0 AND p_aptype <> '21' THEN  #MOD-D40097
            LET p_prog = g_prog                       #MOD-C30056 add   
            #No.MOD-BC0264  --Begin
            CASE g_prog
                  WHEN 'aapp110' LET g_prog = 'aapt110'
                  WHEN 'aapp111' LET g_prog = 'aapt210'
                  WHEN 'aapp115' LET g_prog = 'aapt160'
                  WHEN 'aapp117' LET g_prog = 'aapt260'
            END CASE
            #No.MOD-BC0264  --End
            CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno)         #No.FUN-730064
            RETURNING l_npq.*
            LET g_prog = p_prog                       #MOD-C30056 add
            CALL s_def_npq31_npq34(l_npq.*,g_bookno) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34  #FUN-AA0087
               CALL t110_chk_aee(l_npq.*)
               RETURNING l_npq.*
            SELECT azi04 INTO t_azi04 FROM azi_file
              WHERE azi01 = l_npq.npq24
#No.FUN-9A0036 --Begin
            IF p_npptype = '1' THEN
#FUN-A40067 --Begin
               SELECT aaa03 INTO l_aaa03 FROM aaa_file
                WHERE aaa01 = g_bookno2
               SELECT azi04 INTO g_azi04_2 FROM azi_file
                WHERE azi01 = l_aaa03
#FUN-A40067 --End
               CALL s_newrate(g_bookno1,g_bookno2,l_npq.npq24,
                              g_npq25_1,l_npp.npp02)
               RETURNING l_npq.npq25
              # LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25  #TQC-B80204 mark
              # TQC-B80204 --begin
               IF l_npq.npq25 = g_npq25_1 AND g_azi04_2 = g_azi04 THEN
                  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)
               ELSE
                  LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
                  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2)
               END IF
              # TQC-B80204 --end
              # LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2) #FUN-A40067 #TQC-B80204 mark
            ELSE
               LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
            END IF
#No.FUN-9A0036 --End
            LET l_npq.npq07f = cl_digcut(l_npq.npq07f,t_azi04)
#           LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)      #FUN-A40067
          # IF l_aag371 MATCHES '[23]' THEN                       #FUN-950053 mark
            IF l_aag371 MATCHES '[234]' THEN                      #FUN-950053 add 
               #-->for 合併報表-關係人
               SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903
                 FROM pmc_file
                WHERE pmc01 = l_apa.apa05
               IF cl_null(l_npq.npq37) THEN
                  IF l_pmc903 = 'Y' THEN
                     LET l_npq.npq37 = l_apa.apa05 CLIPPED   #No.CHI-830037
                  END IF
               END IF
            END IF
            LET l_npq.npqlegal = g_legal #FUN-980001 add
            #No.FUN-A30077  --Begin                                          
            CALL t110_entry_direction(g_bookno,l_npq.npq03,l_npq.npq06,      
                                      l_npq.npq07,l_npq.npq07f)              
                 RETURNING l_npq.npq06,l_npq.npq07,l_npq.npq07f              
            #No.FUN-A30077  --End 
#No.FUN-AC0001 --begin                                                          
               IF cl_null(l_npq.npq35) THEN LET l_npq.npq35 = ' ' END IF        
               IF cl_null(l_npq.npq05) THEN LET l_npq.npq05 = ' ' END IF        
               IF cl_null(l_npq.npq08) THEN LET l_npq.npq08 = ' ' END IF        
#No.FUN-AC0001 --end 
           #FUN-D40118 ---Add--- Start
            SELECT aag44 INTO l_aag44 FROM aag_file
             WHERE aag00 = g_bookno3
               AND aag01 = l_npq.npq03
            IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
               CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
               IF l_flag = 'N'   THEN
                  LET l_npq.npq03 = ''
               END IF
            END IF
           #FUN-D40118 ---Add--- End
            INSERT INTO npq_file VALUES (l_npq.*)
            MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',l_npq.npq07
            IF SQLCA.sqlcode THEN 
               IF g_bgerr THEN
                  LET g_showmsg=l_npq.npq01,"/",l_npq.npq011,"/",l_npq.npq02,"/",l_npq.npqsys,"/",l_npq.npq00,"/",l_npq.npqtype
                  CALL s_errmsg("npq01,npq011,npq02,npqsys,npq00,npqtype",g_showmsg,"t110_g_gl(ckp#6)",SQLCA.sqlcode,1)
               ELSE
                  CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,SQLCA.sqlcode,"","t110_g_gl(ckp#6)",1)  #No.FUN-660122
               END IF
               LET g_success='N' #no.5573
            END IF
         END IF
      CALL t110_unap_npq2(p_apno,p_aptype,g_bookno,l_apa.*,'0','2')   #No.TQC-7B0083
      END IF
      LET l_npq.npq04=''   #MOD-7B0049
      #---->多借方多貸方
      IF cl_null(l_apa.apa51) THEN
         LET g_sql="SELECT apb29,apb25,apb26,apb27,",
                   "       apb35,apb36,apb31,",
                   "       SUM(apb10) apb10,SUM(apb24) apb24,apb930",
                   "  FROM apb_file",
                   " WHERE apb01 = '",p_apno,"'",
                   "   AND (apb34 IS NULL OR apb34 = 'N')",
                   "   AND (apb10 != 0 OR apb27 IS NOT NULL)",
                   " GROUP BY apb29,apb25,apb26,apb27,apb35,apb36,apb31,apb930" 
    
        #DELETE FROM t110_gl_tmpmul                                #MOD-AB0195 mod  #MOD-AC0021 mark
         DROP TABLE t110_gl_tmpmul                                                  #MOD-AC0021
         LET g_sql = g_sql CLIPPED," INTO TEMP t110_gl_tmpmul"     #MOD-AB0195 mod
         PREPARE t110_gl_p405 FROM g_sql
         EXECUTE t110_gl_p405
 
         LET l_sql = "SELECT apb25 FROM t110_gl_tmpmul,aag_file",  #MOD-AB0195 mod
                     " WHERE apb25=aag01",
                     "   AND aag00='",g_bookno,"'",
                     "   AND aag23='N'",
                     " ORDER BY apb25"
         PREPARE t110_gl_p406 FROM l_sql
         DECLARE t110_gl_c406 CURSOR FOR t110_gl_p406
         FOREACH t110_gl_c406 INTO l_apb25
            IF STATUS THEN EXIT FOREACH END IF
            UPDATE t110_gl_tmpmul SET apb35='',apb36='' WHERE apb25=l_apb25   #MOD-AB0195 mod
         END FOREACH
 
         LET g_sql="SELECT apb29,apb25,apb26,apb27,",
                   "       apb35,apb36,apb31,",
                   "       SUM(apb10),SUM(apb24),apb930",
                   "  FROM t110_gl_tmpmul",                                   #MOD-AB0195 mod
                   " GROUP BY apb29,apb25,apb26,apb27,apb35,apb36,apb31,apb930",
                   " ORDER BY apb29,apb25,apb26"
         PREPARE t110_gl_p42 FROM g_sql
         DECLARE t110_gl_c42 CURSOR FOR t110_gl_p42
 
         FOREACH t110_gl_c42 INTO l_apb29,l_npq.npq03,l_npq.npq05,l_npq.npq04,
                                 #l_npq.npq15,l_apb35,l_apb36,l_apb31,           #FUN-810045 add apb35/36/31  #No.FUN-830161
                                  l_apb35,l_apb36,l_apb31,                       #FUN-810045 add apb35/36/31  #No.FUN-830161
                                  l_npq.npq07,l_npq.npq07f,l_apb930   #MOD-8C0067 add l_apb930
            IF STATUS THEN
               EXIT FOREACH
            END IF
    
            LET l_npq.npq02 = l_npq.npq02 + 1
    
            IF l_apb29 = '3' THEN
               LET l_npq.npq06 = '2'
            END IF
    
            IF l_npq.npq07 < 0 THEN
               IF l_apb29 = '3' THEN
                  LET l_npq.npq07 = l_npq.npq07 * -1
                  LET l_npq.npq07f = l_npq.npq07f * -1
               END IF
            END IF
    
            SELECT aag05,aag21,aag23,aag371 INTO l_aag05,l_aag21,l_aag23,l_aag371   #MOD-750132
              FROM aag_file
             WHERE aag01 = l_npq.npq03
               AND aag00=g_bookno        #No.FUN-730064
    
            IF l_aag05 = 'Y' THEN
               IF cl_null(l_npq.npq05) THEN
                  IF g_aaz.aaz90='N' THEN
                     LET l_npq.npq05 = l_apa.apa22
                  ELSE
                     LET l_npq.npq05 = l_apb930       #MOD-8C0067
                  END IF
               END IF
            ELSE
               LET l_npq.npq05 = ''
            END IF
    
            IF l_npq.npq07!=0 THEN
               LET p_prog = g_prog                       #MOD-C30056 add
               #No.MOD-BC0264  --Begin
               CASE g_prog
                  WHEN 'aapp110' LET g_prog = 'aapt110'
                  WHEN 'aapp111' LET g_prog = 'aapt210'
                  WHEN 'aapp115' LET g_prog = 'aapt160'
                  WHEN 'aapp117' LET g_prog = 'aapt260'
               END CASE
               #No.MOD-BC0264  --End
               CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno)             #No.FUN-730064
               RETURNING l_npq.*
               LET g_prog = p_prog                       #MOD-C30056 add
               CALL s_def_npq31_npq34(l_npq.*,g_bookno) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34   #FUN-AA0087
               CALL t110_chk_aee(l_npq.*)
               RETURNING l_npq.*
               SELECT azi04 INTO t_azi04 FROM azi_file
                 WHERE azi01 = l_npq.npq24
#No.FUN-9A0036 --Begin
            IF p_npptype = '1' THEN
#FUN-A40067 --Begin
               SELECT aaa03 INTO l_aaa03 FROM aaa_file
                WHERE aaa01 = g_bookno2
               SELECT azi04 INTO g_azi04_2 FROM azi_file
                WHERE azi01 = l_aaa03
#FUN-A40067 --End
               CALL s_newrate(g_bookno1,g_bookno2,l_npq.npq24,
                              g_npq25_1,l_npp.npp02)
               RETURNING l_npq.npq25
              # LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25  #TQC-B80204 mark
              # TQC-B80204 --begin
               IF l_npq.npq25 = g_npq25_1 AND g_azi04_2 = g_azi04 THEN
                  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)
               ELSE
                  LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
                  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2)
               END IF
              # TQC-B80204 --end
              # LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2) #FUN-A40067 #TQC-B80204 mark
            ELSE
               LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
            END IF
#No.FUN-9A0036 --End
               LET l_npq.npq07f = cl_digcut(l_npq.npq07f,t_azi04)
#              LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
             # IF l_aag371 MATCHES '[23]' THEN                    #FUN-950053 mark
               IF l_aag371 MATCHES '[234]' THEN                   #FUN-950053 add  
                  #-->for 合併報表-關係人
                  SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903 FROM pmc_file
                   WHERE pmc01 = l_apa.apa05
                  IF cl_null(l_npq.npq37) THEN
                     IF l_pmc903 = 'Y' THEN
                        LET l_npq.npq37 = l_apa.apa05 CLIPPED   #No.CHI-830037
                     END IF
                  END IF
               END IF
               IF l_aag23 = 'Y' THEN
                  LET l_npq.npq08 = l_apb35
                  LET l_npq.npq35 = l_apb36     #CHI-A30003 add
               ELSE
                  LET l_npq.npq08 = NULL
                  LET l_npq.npq35 = NULL        #CHI-A30003 add
               END IF
              #LET l_npq.npq35 = l_apb36        #CHI-A30003 mark
            SELECT aag21 INTO l_aag21 FROM aag_file
             WHERE aag00 = g_bookno
               AND aag01 = l_npq.npq03               
            IF l_aag21 = 'Y' THEN             #MOD-950096 
               LET l_npq.npq36 = l_apb31 
            END IF                            #MOD-950096    
               LET l_npq.npqlegal = g_legal #FUN-980001 add
               #No.FUN-A30077  --Begin                                          
               CALL t110_entry_direction(g_bookno,l_npq.npq03,l_npq.npq06,      
                                         l_npq.npq07,l_npq.npq07f)              
                    RETURNING l_npq.npq06,l_npq.npq07,l_npq.npq07f              
               #No.FUN-A30077  --End 
#No.FUN-AC0001 --begin                                                          
               IF cl_null(l_npq.npq35) THEN LET l_npq.npq35 = ' ' END IF        
               IF cl_null(l_npq.npq05) THEN LET l_npq.npq05 = ' ' END IF        
               IF cl_null(l_npq.npq08) THEN LET l_npq.npq08 = ' ' END IF        
#No.FUN-AC0001 --end 
              #FUN-D40118 ---Add--- Start
               SELECT aag44 INTO l_aag44 FROM aag_file
                WHERE aag00 = g_bookno3
                  AND aag01 = l_npq.npq03
               IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
                  CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
                  IF l_flag = 'N'   THEN
                     LET l_npq.npq03 = ''
                  END IF
               END IF
              #FUN-D40118 ---Add--- End
               INSERT INTO npq_file VALUES (l_npq.*)
               MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',l_npq.npq07
               IF STATUS THEN
                  IF g_bgerr THEN
                     LET g_showmsg=l_npq.npq01,"/",l_npq.npq011,"/",l_npq.npq02,"/",l_npq.npqsys,"/",l_npq.npq00,"/",l_npq.npqtype
                     CALL s_errmsg("npq01,npq011,npq02,npqsys,npq00,npqtype",g_showmsg,"t110_g_gl(ckp#42)",SQLCA.sqlcode,1)
                  ELSE
                     CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,SQLCA.sqlcode,"","t110_g_gl(ckp#42)",1) 
                  END IF
                  LET g_success='N'
                  EXIT FOREACH
               END IF
            END IF
         END FOREACH
         CALL t110_unap_npq2(p_apno,p_aptype,g_bookno,l_apa.*,'0','2')  #No.TQC-7B0083
      END IF
   ELSE
      IF l_apa.apa511 = 'STOCK' THEN
         CALL t110_stock(p_apno,l_apa.apa66,p_npptype,p_aptype)  #No.FUN-680029 新增p_npptype  #MOD-960127 add p_aptype 
         CALL t110_unap_npq2(p_apno,p_aptype,g_bookno,l_apa.*,'1','2')   #No.TQC-7B0083
      END IF
      IF l_apa.apa511 !='STOCK' AND l_apa.apa511 != 'UNAP' AND                                                                        
         l_apa.apa511 != 'MISC' AND NOT cl_null(l_apa.apa511) THEN  #No.FUN-680029
         LET l_npq.npq02 = l_npq.npq02 + 1
         LET l_npq.npq03 = l_apa.apa511 
         LET l_npq.npq04 = NULL #FUN-D10065 add
        #FUN-D10065--mark--str--
        #CASE WHEN g_apz.apz43 = '1' LET l_npq.npq04 =
        #                            l_apa.apa06 CLIPPED,' ',l_apa.apa07
        #     WHEN g_apz.apz43 = '2'
        #                  IF l_apa.apa08 = 'MISC' THEN
        #                     LET l_npq.npq04 = l_apa.apa06,' ',l_apa.apa07,' ',
        #                                       l_apa.apa01
        #                  ELSE
        #                     LET l_npq.npq04 = l_apa.apa06,' ',l_apa.apa07,' ',
        #                                       l_apa.apa08
        #                  END IF
        #     OTHERWISE              LET l_npq.npq04 = NULL
        #END CASE
        #FUN-D10065--mark--end--
         #apa51中的值要去掉衝暫估金額,衝暫估金額要獨立insert npq                
         LET l_api05f = 0   LET l_api05 = 0                                     
         SELECT SUM(api05f),SUM(api05) INTO l_api05f,l_api05 FROM api_file      
          WHERE api01=l_apa.apa01 AND api02 = '2'                               
         IF cl_null(l_api05f) THEN LET l_api05f = 0 END IF                      
         IF cl_null(l_api05 ) THEN LET l_api05  = 0 END IF                      
         LET l_npq.npq06 = '2'
         LET l_npq.npq07 = l_apa.apa31 - l_api05     #No.TQC-7B0083
         LET l_npq.npq07f= l_apa.apa31f - l_api05f   #No.TQC-7B0083
         SELECT aag05,aag23,aag371 INTO l_aag05,l_aag23,l_aag371 FROM aag_file   #CHI-760007
          WHERE aag01=l_npq.npq03
            AND aag00=g_bookno        #No.FUN-730064
         IF l_aag23='Y' THEN 
            LET l_npq.npq08 = l_apa.apa66 
         ELSE 
            LET l_npq.npq08 = null
         END IF
         LET l_npq.npq05 = ''   #MOD-B30089 add
         IF l_aag05='Y' THEN
            IF g_aaz.aaz90='N' THEN
               LET l_npq.npq05 = l_apa.apa22
            ELSE
               LET l_npq.npq05 = l_apa.apa930
            END IF
         ELSE
            LET l_npq.npq05 = ''           
         END IF
        #IF l_npq.npq07!=0 THEN                        #MOD-D40097 mark
         IF l_npq.npq07 != 0 AND p_aptype <> '21' THEN #MOD-D40097
            LET p_prog = g_prog                       #MOD-C30056 add   
            #No.MOD-BC0264  --Begin
            CASE g_prog
                  WHEN 'aapp110' LET g_prog = 'aapt110'
                  WHEN 'aapp111' LET g_prog = 'aapt210'
                  WHEN 'aapp115' LET g_prog = 'aapt160'
                  WHEN 'aapp117' LET g_prog = 'aapt260'
            END CASE
            #No.MOD-BC0264  --End
            CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno)         #No.FUN-730064
            RETURNING l_npq.*
            #FUN-D10065--add--str--
            IF cl_null(l_npq.npq04) THEN
               CASE WHEN g_apz.apz43 = '1' LET l_npq.npq04 =
                                       l_apa.apa06 CLIPPED,' ',l_apa.apa07
                    WHEN g_apz.apz43 = '2'
                         IF l_apa.apa08 = 'MISC' THEN
                            LET l_npq.npq04 = l_apa.apa06,' ',l_apa.apa07,' ',
                                              l_apa.apa01
                         ELSE
                            LET l_npq.npq04 = l_apa.apa06,' ',l_apa.apa07,' ',
                                              l_apa.apa08
                         END IF
                    OTHERWISE              LET l_npq.npq04 = NULL
               END CASE
            END IF
            #FUN-D10065--add--end--
            LET g_prog = p_prog                       #MOD-C30056 add
            CALL s_def_npq31_npq34(l_npq.*,g_bookno) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34   #FUN-AA0087
               CALL t110_chk_aee(l_npq.*)
               RETURNING l_npq.*
            SELECT azi04 INTO t_azi04 FROM azi_file
              WHERE azi01 = l_npq.npq24
#No.FUN-9A0036 --Begin
            IF p_npptype = '1' THEN
#FUN-A40067 --Begin
               SELECT aaa03 INTO l_aaa03 FROM aaa_file
                WHERE aaa01 = g_bookno2
               SELECT azi04 INTO g_azi04_2 FROM azi_file
                WHERE azi01 = l_aaa03
#FUN-A40067 --End
               CALL s_newrate(g_bookno1,g_bookno2,l_npq.npq24,
                              g_npq25_1,l_npp.npp02)
               RETURNING l_npq.npq25
              # LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25  #TQC-B80204 mark
              # TQC-B80204 --begin
               IF l_npq.npq25 = g_npq25_1 AND g_azi04_2 = g_azi04 THEN
                  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)
               ELSE
                  LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
                  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2)
               END IF
              # TQC-B80204 --end
              # LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2) #FUN-A40067 #TQC-B80204 mark
            ELSE
               LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
            END IF
#No.FUN-9A0036 --End
            LET l_npq.npq07f = cl_digcut(l_npq.npq07f,t_azi04)
#           LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)      #FUN-A40067
          # IF l_aag371 MATCHES '[23]' THEN                       #FUN-950053 mark
            IF l_aag371 MATCHES '[234]' THEN                      #FUN-950053 add 
               #-->for 合併報表-關係人
               SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903
                 FROM pmc_file
                WHERE pmc01 = l_apa.apa05
               IF cl_null(l_npq.npq37) THEN
                  IF l_pmc903 = 'Y' THEN
                     LET l_npq.npq37 = l_apa.apa05 CLIPPED   #No.CHI-830037
                  END IF
               END IF
            END IF
            LET l_npq.npqlegal = g_legal #FUN-980001 add
            #No.FUN-A30077  --Begin                                          
            CALL t110_entry_direction(g_bookno,l_npq.npq03,l_npq.npq06,      
                                      l_npq.npq07,l_npq.npq07f)              
                 RETURNING l_npq.npq06,l_npq.npq07,l_npq.npq07f              
            #No.FUN-A30077  --End 
#No.FUN-AC0001 --begin                                                          
               IF cl_null(l_npq.npq35) THEN LET l_npq.npq35 = ' ' END IF        
               IF cl_null(l_npq.npq05) THEN LET l_npq.npq05 = ' ' END IF        
               IF cl_null(l_npq.npq08) THEN LET l_npq.npq08 = ' ' END IF        
#No.FUN-AC0001 --end 
           #FUN-D40118 ---Add--- Start
            SELECT aag44 INTO l_aag44 FROM aag_file
             WHERE aag00 = g_bookno3
               AND aag01 = l_npq.npq03
            IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
               CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
               IF l_flag = 'N'   THEN
                  LET l_npq.npq03 = ''
               END IF
            END IF
           #FUN-D40118 ---Add--- End
            INSERT INTO npq_file VALUES (l_npq.*)
            MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',l_npq.npq07
            IF SQLCA.sqlcode THEN 
               IF g_bgerr THEN
                  LET g_showmsg=l_npq.npq01,"/",l_npq.npq011,"/",l_npq.npq02,"/",l_npq.npqsys,"/",l_npq.npq00,"/",l_npq.npqtype
                  CALL s_errmsg("npq01,npq011,npq02,npqsys,npq00,npqtype",g_showmsg,"t110_g_gl(ckp#6)",SQLCA.sqlcode,1)
               ELSE
                  CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,SQLCA.sqlcode,"","t110_g_gl(ckp#6)",1)  #No.FUN-660122
               END IF
               LET g_success='N'
            END IF
         END IF
         CALL t110_unap_npq2(p_apno,p_aptype,g_bookno,l_apa.*,'1','2')   #No.TQC-7B0083
      END IF
      LET l_npq.npq04=''   #MOD-7B0049
      #---->多借方多貸方
      IF cl_null(l_apa.apa511) THEN
         LET g_sql="SELECT apb29,apb251,apb26,apb27,",
                   "       apb35,apb36,apb31,",
                   "       SUM(apb10) apb10,SUM(apb24) apb24,apb930",
                   "  FROM apb_file",
                   " WHERE apb01 = '",p_apno,"'",
                   "   AND (apb34 IS NULL OR apb34 = 'N')",
                   "   AND (apb10 != 0 OR apb27 IS NOT NULL)",
                   " GROUP BY apb29,apb251,apb26,apb27,apb35,apb36,apb31,apb930" 
        
        #DELETE FROM t110_gl_tmpmul1                                #MOD-AB0195 mod  #MOD-AC0021 mark
         DROP TABLE t110_gl_tmpmul1                                                  #MOD-AC0021
         LET g_sql = g_sql CLIPPED," INTO TEMP t110_gl_tmpmul1"     #MOD-AB0195 mod
         PREPARE t110_gl_p407 FROM g_sql
         EXECUTE t110_gl_p407
 
         LET l_sql = "SELECT apb251 FROM t110_gl_tmpmul1,aag_file", #MOD-AB0195 mod
                     " WHERE apb251=aag01",
                     "   AND aag00='",g_bookno,"'",
                     "   AND aag23='N'",
                     " ORDER BY apb251"
         PREPARE t110_gl_p408 FROM l_sql
         DECLARE t110_gl_c408 CURSOR FOR t110_gl_p408
         FOREACH t110_gl_c408 INTO l_apb251
            IF STATUS THEN EXIT FOREACH END IF
            UPDATE t110_gl_tmpmul1 SET apb35='',apb36='' WHERE apb251=l_apb251 #MOD-AB0195 mod
         END FOREACH
 
         LET g_sql="SELECT apb29,apb251,apb26,apb27,",
                   "       apb35,apb36,apb31,",
                   "       SUM(apb10),SUM(apb24),apb930",
                   "  FROM t110_gl_tmpmul1",                                  #MOD-AB0195 mod
                   " GROUP BY apb29,apb251,apb26,apb27,apb35,apb36,apb31,apb930",
                   " ORDER BY apb29,apb251,apb26"
         PREPARE t110_gl_p421 FROM g_sql
         DECLARE t110_gl_c421 CURSOR FOR t110_gl_p421
 
         FOREACH t110_gl_c421 INTO l_apb29,l_npq.npq03,l_npq.npq05,l_npq.npq04,
                                   l_apb35,l_apb36,l_apb31,              #FUN-810045 add apb35/36/31  #No.FUN-830161
                                   l_npq.npq07,l_npq.npq07f,l_apb930   #MOD-8C0067 add l_apb930
            IF STATUS THEN
               EXIT FOREACH
            END IF
    
            LET l_npq.npq02 = l_npq.npq02 + 1
    
            IF l_apb29 = '3' THEN
               LET l_npq.npq06 = '2'
            END IF
    
            IF l_npq.npq07 < 0 THEN
               IF l_apb29 = '3' THEN
                  LET l_npq.npq07 = l_npq.npq07 * -1
                  LET l_npq.npq07f = l_npq.npq07f * -1
               END IF
            END IF
    
            SELECT aag05,aag21,aag23,aag371 INTO l_aag05,l_aag21,l_aag23,l_aag371   #MOD-750132
              FROM aag_file
             WHERE aag01 = l_npq.npq03
               AND aag00=g_bookno        #No.FUN-730064
    
 
            IF l_aag05 = 'Y' THEN
               IF cl_null(l_npq.npq05) THEN
                  IF g_aaz.aaz90='N' THEN
                     LET l_npq.npq05 = l_apa.apa22
                  ELSE
                     LET l_npq.npq05 = l_apb930       #MOD-8C0067
                  END IF
               END IF
            ELSE
               LET l_npq.npq05 = ''
            END IF
    
            IF l_npq.npq07!=0 THEN
               LET p_prog = g_prog                       #MOD-C30056 add
               #No.MOD-BC0264  --Begin
               CASE g_prog
                  WHEN 'aapp110' LET g_prog = 'aapt110'
                  WHEN 'aapp111' LET g_prog = 'aapt210'
                  WHEN 'aapp115' LET g_prog = 'aapt160'
                  WHEN 'aapp117' LET g_prog = 'aapt260'
               END CASE
               #No.MOD-BC0264  --End
               CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno)       #No.FUN-730064
               RETURNING l_npq.*
               LET g_prog = p_prog                       #MOD-C30056 add
               CALL s_def_npq31_npq34(l_npq.*,g_bookno) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34  #FUN-AA0087
               CALL t110_chk_aee(l_npq.*)
               RETURNING l_npq.*
               SELECT azi04 INTO t_azi04 FROM azi_file
                 WHERE azi01 = l_npq.npq24
#No.FUN-9A0036 --Begin
            IF p_npptype = '1' THEN
#FUN-A40067 --Begin
               SELECT aaa03 INTO l_aaa03 FROM aaa_file
                WHERE aaa01 = g_bookno2
               SELECT azi04 INTO g_azi04_2 FROM azi_file
                WHERE azi01 = l_aaa03
#FUN-A40067 --End
               CALL s_newrate(g_bookno1,g_bookno2,l_npq.npq24,
                              g_npq25_1,l_npp.npp02)
               RETURNING l_npq.npq25
              # LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25  #TQC-B80204 mark
              # TQC-B80204 --begin
               IF l_npq.npq25 = g_npq25_1 AND g_azi04_2 = g_azi04 THEN
                  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)
               ELSE
                  LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
                  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2)
               END IF
              # TQC-B80204 --end
              # LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2) #FUN-A40067  #TQC-B80204 mark
            ELSE
               LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
            END IF
#No.FUN-9A0036 --End
               LET l_npq.npq07f = cl_digcut(l_npq.npq07f,t_azi04)
#              LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
             # IF l_aag371 MATCHES '[23]' THEN                    #FUN-950053 mark
               IF l_aag371 MATCHES '[234]' THEN                   #FUN-950053 add  
                  #-->for 合併報表-關係人
                  SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903 FROM pmc_file
                   WHERE pmc01 = l_apa.apa05
                  IF cl_null(l_npq.npq37) THEN
                     IF l_pmc903 = 'Y' THEN
                        LET l_npq.npq37 = l_apa.apa05 CLIPPED   #No.CHI-830037
                     END IF
                  END IF
               END IF
               IF l_aag23 = 'Y' THEN
                  LET l_npq.npq08 = l_apb35
                  LET l_npq.npq35 = l_apb36     #CHI-A30003 add
               ELSE
                  LET l_npq.npq08 = NULL
                  LET l_npq.npq35 = NULL        #CHI-A30003 add
               END IF
              #LET l_npq.npq35 = l_apb36        #CHI-A30003 mark
            SELECT aag21 INTO l_aag21 FROM aag_file
             WHERE aag00 = g_bookno
               AND aag01 = l_npq.npq03               
            IF l_aag21 = 'Y' THEN             #MOD-950096 
               LET l_npq.npq36 = l_apb31 
            END IF                            #MOD-950096    
               LET l_npq.npqlegal = g_legal #FUN-980001 add
               #No.FUN-A30077  --Begin                                          
               CALL t110_entry_direction(g_bookno,l_npq.npq03,l_npq.npq06,      
                                         l_npq.npq07,l_npq.npq07f)              
                    RETURNING l_npq.npq06,l_npq.npq07,l_npq.npq07f              
               #No.FUN-A30077  --End 
#No.FUN-AC0001 --begin                                                          
               IF cl_null(l_npq.npq35) THEN LET l_npq.npq35 = ' ' END IF        
               IF cl_null(l_npq.npq05) THEN LET l_npq.npq05 = ' ' END IF        
               IF cl_null(l_npq.npq08) THEN LET l_npq.npq08 = ' ' END IF        
#No.FUN-AC0001 --end 
              #FUN-D40118 ---Add--- Start
               SELECT aag44 INTO l_aag44 FROM aag_file
                WHERE aag00 = g_bookno3
                  AND aag01 = l_npq.npq03
               IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
                  CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
                  IF l_flag = 'N'   THEN
                     LET l_npq.npq03 = ''
                  END IF
               END IF
              #FUN-D40118 ---Add--- End
               INSERT INTO npq_file VALUES (l_npq.*)
               MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',l_npq.npq07
               IF STATUS THEN
                  IF g_bgerr THEN
                     LET g_showmsg=l_npq.npq01,"/",l_npq.npq011,"/",l_npq.npq02,"/",l_npq.npqsys,"/",l_npq.npq00,"/",l_npq.npqtype
                     CALL s_errmsg("npq01,npq011,npq02,npqsys,npq00,npqtype",g_showmsg,"t110_g_gl(ckp#42)",SQLCA.sqlcode,1)
                  ELSE
                     CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,SQLCA.sqlcode,"","t110_g_gl(ckp#42)",1)  #No.FUN-660122
                  END IF
                  LET g_success='N'
                  EXIT FOREACH
               END IF
            END IF
         END FOREACH
         CALL t110_unap_npq2(p_apno,p_aptype,g_bookno,l_apa.*,'1','2')  #No.TQC-7B0083 
      END IF
   END IF
 
   LET l_npq.npq11=''
   LET l_npq.npq12=''
   LET l_npq.npq13=''
   LET l_npq.npq14=''
   LET l_npq.npq31=''
   LET l_npq.npq32=''
   LET l_npq.npq33=''
   LET l_npq.npq34=''
   LET l_npq.npq35=''
   LET l_npq.npq36=''
   LET l_npq.npq37=''
 
#-----------------------------------( Cr: VAT TAX        )---------------------
   IF l_apa.apa32 > 0 THEN
   LET l_npq.npq02 = l_npq.npq02 + 1
   IF p_npptype = '0' THEN  #No.FUN-680029
      LET l_npq.npq03 = l_apa.apa52
   ELSE
      LET l_npq.npq03 = l_apa.apa521
   END IF
   LET l_npq.npq06 = '2'       #No.TQC-7B0083
   LET l_npq.npq04 = NULL
   LET l_npq.npq07 = l_apa.apa32
   LET l_npq.npq07f= l_apa.apa32f
   SELECT aag05,aag23,aag371 INTO l_aag05,l_aag23,l_aag371 FROM aag_file   #CHI-760007
    WHERE aag01=l_npq.npq03
      AND aag00=g_bookno        #No.FUN-730064
   IF l_aag23='Y' THEN 
      LET l_npq.npq08 = l_apa.apa66 
   ELSE 
      LET l_npq.npq08 = null
   END IF
   LET l_npq.npq05 = ''   #MOD-B30089 add
   IF l_aag05='Y' THEN
      IF g_aaz.aaz90='N' THEN
         LET l_npq.npq05 = l_apa.apa22
      ELSE
         LET l_npq.npq05 = l_apa.apa930
      END IF
   ELSE
      LET l_npq.npq05 = ''           
   END IF
   IF l_npq.npq07!=0 THEN
      LET p_prog = g_prog                       #MOD-C30056 add 
      #No.MOD-BC0264  --Begin
      CASE g_prog
          WHEN 'aapp110' LET g_prog = 'aapt110'
          WHEN 'aapp111' LET g_prog = 'aapt210'
          WHEN 'aapp115' LET g_prog = 'aapt160'
          WHEN 'aapp117' LET g_prog = 'aapt260'
      END CASE
      #No.MOD-BC0264  --End
      CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno)         #No.FUN-730064
      RETURNING l_npq.*
      LET g_prog = p_prog                       #MOD-C30056 add
      CALL s_def_npq31_npq34(l_npq.*,g_bookno) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34   #FUN-AA0087
       CALL t110_chk_aee(l_npq.*)
       RETURNING l_npq.*
      SELECT azi04 INTO t_azi04 FROM azi_file
        WHERE azi01 = l_npq.npq24
#No.FUN-9A0036 --Begin
            IF p_npptype = '1' THEN
#FUN-A40067 --Begin
               SELECT aaa03 INTO l_aaa03 FROM aaa_file
                WHERE aaa01 = g_bookno2
               SELECT azi04 INTO g_azi04_2 FROM azi_file
                WHERE azi01 = l_aaa03
#FUN-A40067 --End
               CALL s_newrate(g_bookno1,g_bookno2,l_npq.npq24,
                              g_npq25_1,l_npp.npp02)
               RETURNING l_npq.npq25
              # LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25  #TQC-B80204 mark
              # TQC-B80204 --begin
               IF l_npq.npq25 = g_npq25_1 AND g_azi04_2 = g_azi04 THEN
                  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)
               ELSE
                  LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
                  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2)
               END IF
              # TQC-B80204 --end
              # LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2) #FUN-A40067 #TQC-B80204 mark
            ELSE
               LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
            END IF
#No.FUN-9A0036 --End
      LET l_npq.npq07f = cl_digcut(l_npq.npq07f,t_azi04)
#     LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)            #FUN-A40067
    # IF l_aag371 MATCHES '[23]' THEN                             #FUN-950053 mark 
      IF l_aag371 MATCHES '[234]' THEN                            #FUN-950053 add
         #-->for 合併報表-關係人
        #FUN-9C0001--mod--str--
        #SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903
        #  FROM pmc_file
        # WHERE pmc01 = l_apa.apa05
        #LET g_sql = "SELECT pmc03,pmc903 FROM ",ms_dbs CLIPPED,"pmc_file ",
         LET g_sql = "SELECT pmc03,pmc903 FROM ",cl_get_target_table(ms_plant,'pmc_file'),  #FUN-A50102
                     " WHERE pmc01 = '",l_apa.apa05,"' "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql  #FUN-A50102
         CALL cl_parse_qry_sql(ms_plant,g_sql) RETURNING g_sql   #FUN-A50102
         PREPARE sel_pmc03_pre FROM g_sql
         EXECUTE sel_pmc03_pre INTO l_pmc03,l_pmc903
        #FUN-9C0001--mod--end
         IF cl_null(l_npq.npq37) THEN
            IF l_pmc903 = 'Y' THEN
               LET l_npq.npq37 = l_apa.apa05 CLIPPED   #No.CHI-830037
            END IF
         END IF
      END IF
      LET l_npq.npqlegal = g_legal #FUN-980001 add
      #No.FUN-A30077  --Begin                                          
      CALL t110_entry_direction(g_bookno,l_npq.npq03,l_npq.npq06,      
                                l_npq.npq07,l_npq.npq07f)              
           RETURNING l_npq.npq06,l_npq.npq07,l_npq.npq07f              
      #No.FUN-A30077  --End 
#No.FUN-AC0001 --begin                                                          
               IF cl_null(l_npq.npq35) THEN LET l_npq.npq35 = ' ' END IF        
               IF cl_null(l_npq.npq05) THEN LET l_npq.npq05 = ' ' END IF        
               IF cl_null(l_npq.npq08) THEN LET l_npq.npq08 = ' ' END IF        
#No.FUN-AC0001 --end 
     #FUN-D40118 ---Add--- Start
      SELECT aag44 INTO l_aag44 FROM aag_file
       WHERE aag00 = g_bookno3
         AND aag01 = l_npq.npq03
      IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
         CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET l_npq.npq03 = ''
         END IF
      END IF
     #FUN-D40118 ---Add--- End
      INSERT INTO npq_file VALUES (l_npq.*)
      MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',l_npq.npq07
      IF SQLCA.sqlcode THEN 
         IF g_bgerr THEN
            LET g_showmsg=l_npq.npq01,"/",l_npq.npq011,"/",l_npq.npq02,"/",l_npq.npqsys,"/",l_npq.npq00,"/",l_npq.npqtype
            CALL s_errmsg("npq01,npq011,npq02,npqsys,npq00,npqtype",g_showmsg,"t110_g_gl(ckp#7)",SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,SQLCA.sqlcode,"","t110_g_gl(ckp#7)",1)  #No.FUN-660122
         END IF
         LET g_success='N' #no.5573
      END IF
   END IF
   END IF
#------------------------------------------------------------------------------
END FUNCTION
 
FUNCTION t110_stock(p_apa01,p_apa66,p_npptype,p_aptype)  #No.FUN-680029 新增p_npptype  #MOD-960127 add p_aptype 
  DEFINE p_apa01       LIKE apa_file.apa01
  DEFINE p_apa66       LIKE apa_file.apa66
  DEFINE p_npptype     LIKE npp_file.npptype  #No.FUN-680029 
  DEFINE p_aptype      LIKE apa_file.apa00    #MOD-960127 add
  DEFINE l_amt	       LIKE apb_file.apb24    #FUN-4B0079
  DEFINE l_amt_f       LIKE apb_file.apb24
  DEFINE l_apb29       LIKE apb_file.apb29    #FUN-660117
  DEFINE l_actno       LIKE apa_file.apa51    # No.FUN-690028 VARCHAR(20)
  DEFINE l_deptno      LIKE apb_file.apb26    #FUN-660117
  DEFINE l_apb12       LIKE apb_file.apb12    #NO.MOD-490217
  DEFINE l_apb08       LIKE apb_file.apb08    #FUN-4B0079
  DEFINE l_apb09       LIKE apb_file.apb09    #FUN-4B0079
  DEFINE l_ware        LIKE rvv_file.rvv32    #FUN-660117
  DEFINE l_loc         LIKE rvv_file.rvv33    #FUN-660117
  DEFINE l_aag05       LIKE aag_file.aag05
  DEFINE l_aag21       LIKE aag_file.aag21
  DEFINE l_aag23       LIKE aag_file.aag23
  DEFINE l_apb930      LIKE apb_file.apb930   #FUN-670064
  DEFINE l_aag371      LIKE aag_file.aag371   #CHI-760007
  DEFINE l_pmc03       LIKE pmc_file.pmc03    #CHI-760007
  DEFINE l_pmc903      LIKE pmc_file.pmc903   #CHI-760007
  DEFINE l_apa05       LIKE apa_file.apa05    #MOD-C20009
  DEFINE l_apb31       LIKE apb_file.apb31,   #費用原因
         l_apb35       LIKE apb_file.apb35,   #專案
         l_apb36       LIKE apb_file.apb36,   #WBS
         l_apb25       LIKE apb_file.apb25,   #科目      #MOD-920060 add
         l_apa51       LIKE apa_file.apa51,   #借方科目  #MOD-920060 add
         l_apb02       LIKE apb_file.apb02,   #項次      #MOD-920100 add
         l_apb21       LIKE apb_file.apb21,   #倉庫      #MOD-920100 add
         l_apb22       LIKE apb_file.apb22    #存放位置  #MOD-920100 add
  DEFINE l_aaa03       LIKE aaa_file.aaa03    #FUN-A40067
  DEFINE p_prog        LIKE type_file.chr20  #MOD-C30056 add
  DEFINE l_aag44       LIKE aag_file.aag44    #No.FUN-D40118   Add
  DEFINE l_flag        LIKE type_file.chr1    #No.FUN-D40118   Add
 
  IF p_npptype = '0' THEN
     LET g_sql="SELECT SUM(apb10) apb10,apb29,apb26,apb12,apb09,apb08,SUM(apb24) apb24,",
               "       apb930,apb35,apb36,apb31,apb25,",
               "       apb02,apb21,apb22",  #MOD-920100 add
               "  FROM apb_file",
               " WHERE apb01 = '",p_apa01,"' AND apb10 != 0",
               "   AND (apb34 IS NULL OR apb34 = 'N')",
               " GROUP BY apb29,apb26,apb12,apb09,apb08,apb930,apb35,apb36,",
                         "apb31,apb25,apb02,apb21,apb22"
  ELSE
     LET g_sql="SELECT SUM(apb10) apb10,apb29,apb26,apb12,apb09,apb08,SUM(apb24) apb24,",
               "       apb930,apb35,apb36,apb31,apb251 apb25,",
               "       apb02,apb21,apb22",  #MOD-920100 add
               "  FROM apb_file",
               " WHERE apb01 = '",p_apa01,"' AND apb10 != 0",
               "   AND (apb34 IS NULL OR apb34 = 'N')",
               " GROUP BY apb29,apb26,apb12,apb09,apb08,apb930,apb35,apb36,",
                         "apb31,apb251,apb02,apb21,apb22"
  END IF

 #DELETE FROM t110_gl_tmpstk                                #MOD-AB0195 mod  #MOD-AC0021 mark
  DROP TABLE t110_gl_tmpstk                                                  #MOD-AC0021
  LET g_sql = g_sql CLIPPED," INTO TEMP t110_gl_tmpstk"     #MOD-AB0195 mod
  PREPARE t110_gl_p409 FROM g_sql
  EXECUTE t110_gl_p409
 
  LET l_sql = "SELECT * FROM t110_gl_tmpstk"                #MOD-AB0195 mod
  PREPARE t110_gl_p400 FROM l_sql
  DECLARE t110_gl_c400 CURSOR FOR t110_gl_p400
  FOREACH t110_gl_c400 INTO l_amt,l_apb29,l_deptno,l_apb12,
                            l_apb09,l_apb08,l_amt_f,l_apb930,
                            l_apb35,l_apb36,l_apb31,l_apb25,
                            l_apb02,l_apb21,l_apb22
     IF STATUS THEN EXIT FOREACH END IF
     LET l_actno = ''   #MOD-950269 add
    #FUN-9C0001--mod--str--
    #SELECT rvv32,rvv33 INTO l_ware,l_loc
    #  FROM rvv_file
    # WHERE rvv01=l_apb21 AND rvv02=l_apb22
    #LET g_sql = "SELECT rvv32,rvv33 FROM ",ms_dbs CLIPPED,"rvv_file ",  #FUN-A50102
     LET g_sql = "SELECT rvv32,rvv33 FROM ",cl_get_target_table(ms_plant,'rvv_file'),   #FUN-A50102
                 " WHERE rvv01='",l_apb21,"' ",
                 "   AND rvv02='",l_apb22,"' "
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A50102
     CALL cl_parse_qry_sql(g_sql,ms_plant) RETURNING g_sql  #FUN-A50102     
     PREPARE sel_rvv32_pre FROM g_sql
     EXECUTE sel_rvv32_pre INTO l_ware,l_loc
    #FUN-9C0001--mod--end
     IF STATUS THEN 
        LET l_ware = ''
        LET l_loc  = ''
     END IF
    #當單頭借方科目為空時,才抓單身科目來產生分錄
     LET l_actno = l_apb25
     IF cl_null(l_actno) THEN
        LET l_actno = t110_stock_act(l_apb12,l_ware,l_loc,p_npptype,ms_plant)   #FUN-9C0041 add ms_plant
     END IF
     UPDATE t110_gl_tmpstk SET apb25=l_actno WHERE apb02=l_apb02   #MOD-AB0195 mod
     LET l_sql = "SELECT aag23 FROM aag_file",
                 " WHERE aag01='",l_actno,"'",
                 "   AND aag00='",g_bookno,"'"
     PREPARE t110_gl_p40a FROM l_sql
     DECLARE t110_gl_c40a CURSOR FOR t110_gl_p40a
     FOREACH t110_gl_c40a INTO l_aag23
        IF STATUS THEN EXIT FOREACH END IF
        IF l_aag23 = 'N' THEN
           UPDATE t110_gl_tmpstk SET apb35='',apb36='' WHERE apb02=l_apb02  #MOD-AB0195 mod
        END IF
     END FOREACH
  END FOREACH
 
  LET g_sql="SELECT SUM(apb10),apb29,apb25,apb26,SUM(apb24),",
            "       apb930,apb35,apb36,apb31",
            "  FROM t110_gl_tmpstk",                                 #MOD-AB0195 mod
            " GROUP BY apb29,apb25,apb26,apb930,apb35,apb36,apb31"
  PREPARE t110_gl_p4 FROM g_sql
  DECLARE t110_gl_c4 CURSOR FOR t110_gl_p4
  FOREACH t110_gl_c4 INTO l_amt,l_apb29,l_actno,l_deptno,
                          l_amt_f,l_apb930,l_apb35,l_apb36,l_apb31
     IF STATUS THEN EXIT FOREACH END IF
     #FUN-D80031 add --------- begin
     IF g_prog = 'aapt140' THEN
        LET l_npq.npq21 = l_deptno
        LET l_npq.npq22 = ''
        LET l_sql = "SELECT occ02 ",
                    "  FROM ",cl_get_target_table(ms_plant,'occ_file'),
                    " WHERE occ01 = '",l_deptno,"' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql
        CALL cl_parse_qry_sql(l_sql,ms_plant) RETURNING l_sql
        PREPARE sel_occ_cs1 FROM l_sql
        EXECUTE sel_occ_cs1 INTO l_npq.npq22
     END IF
     #FUN-D80031 add --------- end
     LET l_npq.npq02 = l_npq.npq02 + 1
     LET l_npq.npq03 = l_actno
     LET l_npq.npq04 = NULL
     IF cl_null(l_npq.npq06) THEN LET l_npq.npq06 = '1' END IF   #TQC-9B0197 add
     IF l_apb29 = '1' THEN LET l_npq.npq06 = '1' END IF
     IF l_apb29 = '3' THEN LET l_npq.npq06 = '2' END IF
     LET l_npq.npq07 = l_amt
     LET l_npq.npq07f= l_amt_f
 
     IF l_npq.npq07 < 0 THEN
        IF l_apb29 = '3' THEN
           LET l_npq.npq07 = l_npq.npq07 * -1
           LET l_npq.npq07f = l_npq.npq07f * -1
        ELSE
           LET l_npq.npq07 = l_npq.npq07
           LET l_npq.npq07f = l_npq.npq07f
        END IF
     END IF
     IF p_aptype[1,1] = '2' AND g_apydmy6='Y' THEN   #MOD-960350
        LET l_npq.npq06 = '1'
        LET l_npq.npq07 = (-1)*l_npq.npq07
        LET l_npq.npq07f= (-1)*l_npq.npq07f
     END IF
     SELECT aag05,aag23,aag371 INTO l_aag05,l_aag23,l_aag371 FROM aag_file   #CHI-760007
      WHERE aag01=l_npq.npq03
        AND aag00=g_bookno        #No.FUN-730064
     LET l_npq.npq05 = ''   #MOD-B30089 add
     IF l_aag05='Y' THEN
        IF g_aaz.aaz90='N' THEN
           LET l_npq.npq05 = l_deptno
        ELSE
           LET l_npq.npq05 = l_apb930
        END IF
#No.MOD-9C0112--begin
       IF cl_null(l_npq.npq05) THEN
          SELECT apa22 INTO l_npq.npq05 FROM apa_file WHERE apa01 =l_npq.npq01
       END IF
#No.MOD-9C0112--end

     ELSE
        LET l_npq.npq05 = ''           
     END IF
     IF l_npq.npq07!=0 THEN 
       #--------------------MOD-CC0253--------------------(S)
        LET l_apb02 = 0
        LET l_sql = " SELECT apb02 ",
                    "   FROM apb_file ",
                    "  WHERE apb01 = '",l_npq.npq01,"'",
                    "    AND apb29 = '",l_apb29,"'",
                    "    AND apb25 = '",l_npq.npq03,"'",
                    "    AND apb26 = '",l_deptno,"'",
                    "    AND apb35 = '",l_apb35,"'",
                    "    AND apb36 = '",l_apb36,"'",
                    "    AND apb31 = '",l_apb31,"'",
                    "    AND apb930 = '",l_apb930,"'"
        PREPARE t110_papb02_03 FROM l_sql
        DECLARE t110_capb02_03 SCROLL CURSOR FOR t110_papb02_03
        OPEN t110_capb02_03
        FETCH FIRST t110_capb02_03 INTO l_apb02
        CLOSE t110_capb02_03
       #--------------------MOD-CC0253--------------------(E)
        LET p_prog = g_prog                       #MOD-C30056 add 
        #No.MOD-BC0264  --Begin
        CASE g_prog
                  WHEN 'aapp110' LET g_prog = 'aapt110'
                  WHEN 'aapp111' LET g_prog = 'aapt210'
                  WHEN 'aapp115' LET g_prog = 'aapt160'
                  WHEN 'aapp117' LET g_prog = 'aapt260'
        END CASE
        #No.MOD-BC0264  --End
       #CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno)         #No.FUN-730064 #MOD-CC0253 mark
        CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,l_apb02,'',g_bookno)                   #MOD-CC0253
        RETURNING l_npq.*
        LET g_prog = p_prog                       #MOD-C30056 add
        CALL s_def_npq31_npq34(l_npq.*,g_bookno) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34    #FUN-AA0087
         CALL t110_chk_aee(l_npq.*)
         RETURNING l_npq.*
        SELECT azi04 INTO t_azi04 FROM azi_file
          WHERE azi01 = l_npq.npq24
#No.FUN-9A0036 --Begin
            IF p_npptype = '1' THEN
#FUN-A40067 --Begin
               SELECT aaa03 INTO l_aaa03 FROM aaa_file
                WHERE aaa01 = g_bookno2
               SELECT azi04 INTO g_azi04_2 FROM azi_file
                WHERE azi01 = l_aaa03
#FUN-A40067 --End
               CALL s_newrate(g_bookno1,g_bookno2,l_npq.npq24,
                              g_npq25_1,l_npp.npp02)
               RETURNING l_npq.npq25
              # LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25  #TQC-B80204 mark
              # TQC-B80204 --begin
               IF l_npq.npq25 = g_npq25_1 AND g_azi04_2 = g_azi04 THEN
                  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)
               ELSE
                  LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
                  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2)
               END IF
              # TQC-B80204 --end
              # LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2) #FUN-A40067 #TQC-B80204 mark
            ELSE
               LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
            END IF
#No.FUN-9A0036 --End
        LET l_npq.npq07f = cl_digcut(l_npq.npq07f,t_azi04)
#       LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)          #FUN-A40067
       #-MOD-C20009-add-
        SELECT apa05 INTO l_apa05 
          FROM apa_file 
         WHERE apa01 =l_npq.npq01
       #-MOD-C20009-end-
      # IF l_aag371 MATCHES '[23]' THEN                           #FUN-950053 mark
        IF l_aag371 MATCHES '[234]' THEN                          #FUN-950053 add 
           #-->for 合併報表-關係人
          #FUN-9C0001--MOD--STR--
          #SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903
          #  FROM pmc_file
          # WHERE pmc01 = l_deptno
          #LET g_sql = "SELECT pmc03,pmc903 FROM ",ms_dbs CLIPPED,"pmc_file ",  #FUN-A50102
           LET g_sql = "SELECT pmc03,pmc903 FROM ",cl_get_target_table(ms_plant,'pmc_file'),  #FUN-A50102
                      #" WHERE pmc01 = '",l_deptno,"' "   #MOD-C20009 mark
                       " WHERE pmc01 = '",l_apa05,"' "    #MOD-C20009
           CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A50102
           CALL cl_parse_qry_sql(g_sql,ms_plant) RETURNING g_sql  #FUN-A50102
           PREPARE sel_pmc03_pre1 FROM g_sql
           EXECUTE sel_pmc03_pre1 INTO l_pmc03,l_pmc903
          #FUN-9C0109--mod--end
           IF cl_null(l_npq.npq37) THEN
              IF l_pmc903 = 'Y' THEN
                #LET l_npq.npq37 = l_deptno CLIPPED   #No.CHI-830037 #MOD-C20009 mark
                 LET l_npq.npq37 = l_apa05            #MOD-C20009
              END IF
           END IF
        END IF
        IF l_aag23 = 'Y' THEN
           LET l_npq.npq08 = l_apb35
           LET l_npq.npq35 = l_apb36   #WBS     (存異動碼9)  #CHI-A30003 add
        ELSE
           LET l_npq.npq08 = NULL
           LET l_npq.npq35 = NULL     #CHI-A30003 add
        END IF
       #LET l_npq.npq35 = l_apb36   #WBS     (存異動碼9)    #CHI-A30003 mark
        SELECT aag21 INTO l_aag21 FROM aag_file
         WHERE aag00 = g_bookno
           AND aag01 = l_npq.npq03               
        IF l_aag21 = 'Y' THEN             #MOD-950096 
           LET l_npq.npq36 = l_apb31
        END IF                            #MOD-950096    
        LET l_npq.npqlegal = g_legal #FUN-980001 add
        #No.FUN-A30077  --Begin                                          
        CALL t110_entry_direction(g_bookno,l_npq.npq03,l_npq.npq06,      
                                  l_npq.npq07,l_npq.npq07f)              
             RETURNING l_npq.npq06,l_npq.npq07,l_npq.npq07f              
        #No.FUN-A30077  --End 
#No.FUN-AC0001 --begin                                                          
               IF cl_null(l_npq.npq35) THEN LET l_npq.npq35 = ' ' END IF        
               IF cl_null(l_npq.npq05) THEN LET l_npq.npq05 = ' ' END IF        
               IF cl_null(l_npq.npq08) THEN LET l_npq.npq08 = ' ' END IF        
#No.FUN-AC0001 --end 
       #FUN-D40118 ---Add--- Start
        SELECT aag44 INTO l_aag44 FROM aag_file
         WHERE aag00 = g_bookno3
           AND aag01 = l_npq.npq03
        IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
           CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
           IF l_flag = 'N'   THEN
              LET l_npq.npq03 = ''
           END IF
        END IF
       #FUN-D40118 ---Add--- End
        INSERT INTO npq_file VALUES (l_npq.*)
        MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',
                 l_npq.npq07
        IF STATUS THEN 
           IF g_bgerr THEN
              LET g_showmsg=l_npq.npq01,"/",l_npq.npq011,"/",l_npq.npq02,"/",l_npq.npqsys,"/",l_npq.npq00,"/",l_npq.npqtype
              CALL s_errmsg("npq01,npq011,npq02,npqsys,npq00,npqtype",g_showmsg,"t110_g_gl(ckp#1)",SQLCA.sqlcode,1)
           ELSE
              CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,STATUS,"","t110_g_gl(ckp#1)",1)  #No.FUN-660122
           END IF
           LET g_success='N' EXIT FOREACH  #no.5573
        END IF
     END IF
  END FOREACH
END FUNCTION
 
FUNCTION t110_stock_act(p_item,p_ware,p_loc,p_npptype,p_plant)  #No.FUN-680029 新增p_npptype   #FUN-9C0041 add p_plant
  DEFINE p_item    LIKE ima_file.ima01
  DEFINE p_ware    LIKE ime_file.ime01
  DEFINE p_loc     LIKE ime_file.ime02
  DEFINE l_actno   LIKE aag_file.aag01
  DEFINE p_npptype LIKE npp_file.npptype
  DEFINE p_plant   LIKE azp_file.azp01    #FUN-9C0041
  DEFINE li_dbs    LIKE type_file.chr21   #FUN-9C0041 
  DEFINE l_sql     LIKE type_file.chr1000 #FUN-9C0041

  IF cl_null(p_plant) THEN
     LET li_dbs = NULL
     LET g_plant_new = NULL  #FUN-A50102
  ELSE
     LET g_plant_new = p_plant
     CALL s_getdbs()
     LET li_dbs = g_dbs_new
  END IF 

  IF g_aptype = '12' THEN
     IF p_npptype = '0' THEN   
       #LET l_sql = "SELECT ima39 FROM ",li_dbs CLIPPED,"ima_file ",  #FUN-A50102
        LET l_sql = "SELECT ima39 FROM ",cl_get_target_table(g_plant_new,'ima_file'),  #FUN-A50102
                    " WHERE ima01='",p_item,"' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql   #FUN-A50102
        CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  #FUN-A50102
        PREPARE sel_ima39_pre FROM l_sql
        EXECUTE sel_ima39_pre INTO l_actno
     ELSE
       #LET l_sql = "SELECT ima391 FROM ",li_dbs CLIPPED,"ima_file ",  #FUN-A50102
        LET l_sql = "SELECT ima391 FROM ",cl_get_target_table(g_plant_new,'ima_file'),  #FUN-A50102
                    " WHERE ima01='",p_item,"' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql   #FUN-A50102
        CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  #FUN-A50102
        PREPARE sel_ima391_pre FROM l_sql
        EXECUTE sel_ima391_pre INTO l_actno
     END IF
  ELSE
     SELECT ccz07 INTO g_ccz07 FROM ccz_file WHERE ccz00='0'
     
     CASE WHEN g_ccz07='1' IF p_npptype = '0' THEN  #No.FUN-680029 
                             #LET l_sql = "SELECT ima39 FROM ",li_dbs CLIPPED,"ima_file ",  #FUN-A50102
                              LET l_sql = "SELECT ima39 FROM ",cl_get_target_table(g_plant_new,'ima_file'),   #FUN-A50102
                                          " WHERE ima01='",p_item,"' "
                              CALL cl_replace_sqldb(l_sql) RETURNING l_sql   #FUN-A50102
                              CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  #FUN-A50102
                              PREPARE sel_ima39_pre1 FROM l_sql
                              EXECUTE sel_ima39_pre1 INTO l_actno
                           ELSE
                             #LET l_sql = "SELECT ima391 FROM ",li_dbs CLIPPED,"ima_file ",  #FUN-A50102
                              LET l_sql = "SELECT ima391 FROM ",cl_get_target_table(g_plant_new,'ima_file'),   #FUN-A50102
                                          " WHERE ima01='",p_item,"' "
                              CALL cl_replace_sqldb(l_sql) RETURNING l_sql   #FUN-A50102
                              CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  #FUN-A50102
                              PREPARE sel_ima391_pre1 FROM l_sql
                              EXECUTE sel_ima391_pre1 INTO l_actno
                           END IF
          WHEN g_ccz07='2' IF p_npptype = '0' THEN  #No.FUN-680029
                             #FUN-A50102--mod--str--
                             #LET l_sql = "SELECT imz39 FROM ",li_dbs CLIPPED,"ima_file,",
                             #                                 li_dbs CLIPPED,"imz_file ",
                              LET l_sql = "SELECT imz39 ",
                                          "  FROM ",cl_get_target_table(g_plant_new,'ima_file'),
                                          "      ,",cl_get_target_table(g_plant_new,'imz_file'),
                             #FUN-A50102--mod--end
                                          " WHERE ima01='",p_item,"' AND ima06=imz01"
                              CALL cl_replace_sqldb(l_sql) RETURNING l_sql   #FUN-A50102
                              CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  #FUN-A50102
                              PREPARE sel_imz39_pre FROM l_sql
                              EXECUTE sel_imz39_pre INTO l_actno
                           ELSE
                             #FUN-A50102--mod--str--
                             #LET l_sql = "SELECT imz391 FROM ",li_dbs CLIPPED,"ima_file,",
                             #                                  li_dbs CLIPPED,"imz_file ",
                              LET l_sql = "SELECT imz391 ",
                                          "  FROM ",cl_get_target_table(g_plant_new,'ima_file'),
                                          "      ,",cl_get_target_table(g_plant_new,'imz_file'),
                             #FUN-A50102--mod--end
                                          " WHERE ima01='",p_item,"' AND ima06=imz01"
                              CALL cl_replace_sqldb(l_sql) RETURNING l_sql   #FUN-A50102
                              CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  #FUN-A50102
                              PREPARE sel_imz391_pre FROM l_sql
                              EXECUTE sel_imz391_pre INTO l_actno
                           END IF
          WHEN g_ccz07='3' IF p_npptype = '0' THEN  #No.FUN-680029
                             #LET l_sql = "SELECT imd08 FROM ",li_dbs CLIPPED,"imd_file ",  #FUN-A50102
                              LET l_sql = "SELECT imd08 FROM ",cl_get_target_table(g_plant_new,'imd_file'),   #FUN-A50102
                                          " WHERE imd01='",p_ware,"' "
                              CALL cl_replace_sqldb(l_sql) RETURNING l_sql   #FUN-A50102
                              CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  #FUN-A50102
                              PREPARE sel_imd08_pre FROM l_sql
                              EXECUTE sel_imd08_pre INTO l_actno
                           ELSE
                             #LET l_sql = "SELECT imd081 FROM ",li_dbs CLIPPED,"imd_file ", #FUN-A50102
                              LET l_sql = "SELECT imd081 FROM ",cl_get_target_table(g_plant_new,'imd_file'),   #FUN-A50102
                                          " WHERE imd01='",p_ware,"' "
                              CALL cl_replace_sqldb(l_sql) RETURNING l_sql   #FUN-A50102
                              CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  #FUN-A50102
                              PREPARE sel_imd081_pre FROM l_sql
                              EXECUTE sel_imd081_pre INTO l_actno
                           END IF
          WHEN g_ccz07='4' IF p_npptype = '0' THEN  #No.FUN-680029
                             #LET l_sql = "SELECT ime09 FROM ",li_dbs CLIPPED,"ime_file ",   #FUN-A50102
                              LET l_sql = "SELECT ime09 FROM ",cl_get_target_table(g_plant_new,'ime_file'),  #FUN-A50102
                                          " WHERE ime01='",p_ware,"' ",
                                          "   AND ime02='",p_loc,"' "
                              CALL cl_replace_sqldb(l_sql) RETURNING l_sql   #FUN-A50102
                              CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  #FUN-A50102
                              PREPARE sel_ime09_pre FROM l_sql
                              EXECUTE sel_ime09_pre INTO l_actno
                           ELSE
                             #LET l_sql = "SELECT ime091 FROM ",li_dbs CLIPPED,"ime_file ",   #FUN-A50102
                              LET l_sql = "SELECT ime091 FROM ",cl_get_target_table(g_plant_new,'ime_file'),  #FUN-A50102
                                          " WHERE ime01='",p_ware,"' ",
                                          "   AND ime02='",p_loc,"' "
                              CALL cl_replace_sqldb(l_sql) RETURNING l_sql   #FUN-A50102
                              CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  #FUN-A50102
                              PREPARE sel_ime091_pre FROM l_sql
                              EXECUTE sel_ime091_pre INTO l_actno
                           END IF
          OTHERWISE        LET l_actno='STOCK'
     END CASE
  END IF   #MOD-6B0088
  RETURN l_actno
END FUNCTION
 
FUNCTION t110_gl_ins_npq(l_npq02,l_npq04,p_apno,l_npq24,l_npq25,l_npq07,l_npq07f,p_npptype) #No.FUN-680029 新增p_npptype
  DEFINE p_apno        LIKE apa_file.apa01
  DEFINE p_aptype      LIKE apa_file.apa00
  DEFINE l_aag05       LIKE aag_file.aag05
  DEFINE l_aag23       LIKE aag_file.aag23
  DEFINE l_apa         RECORD LIKE apa_file.*
  DEFINE l_apb25       LIKE apb_file.apb25
  DEFINE l_apb24       LIKE apb_file.apb24
  DEFINE l_apb10       LIKE apb_file.apb10
  DEFINE l_apb26       LIKE apb_file.apb26    #MOD-8C0067 add
  DEFINE l_apb930      LIKE apb_file.apb930   #MOD-8C0067 add
  DEFINE l_npq02       LIKE npq_file.npq02
  DEFINE l_npq04       LIKE npq_file.npq04
  DEFINE l_npq24       LIKE npq_file.npq24
  DEFINE l_npq25       LIKE npq_file.npq25
  DEFINE l_npq07       LIKE npq_file.npq07
  DEFINE l_npq07f      LIKE npq_file.npq07f
  DEFINE s_npq07       LIKE npq_file.npq07
  DEFINE s_npq07f      LIKE npq_file.npq07f
  DEFINE l_apa31       LIKE apa_file.apa31
  DEFINE l_apa31f      LIKE apa_file.apa31f
  DEFINE p_npptype     LIKE npp_file.npptype  #No.FUN-680029 
  DEFINE l_cnt         LIKE type_file.num5    #No.FUN-690028 SMALLINT
  DEFINE l_cnt2        LIKE type_file.num5    #No.FUN-690028 SMALLINT
  DEFINE l_aag371      LIKE aag_file.aag371   #CHI-760007
  DEFINE l_pmc03       LIKE pmc_file.pmc03    #CHI-760007
  DEFINE l_pmc903      LIKE pmc_file.pmc903   #CHI-760007
  DEFINE l_apb31       LIKE apb_file.apb31,   #費用原因
         l_apb35       LIKE apb_file.apb35,   #專案
         l_apb36       LIKE apb_file.apb36    #wbs
  DEFINE l_aag21       LIKE aag_file.aag21    #MOD-950096
  DEFINE l_aaa03       LIKE aaa_file.aaa03    #FUN-A40067
  DEFINE p_prog        LIKE type_file.chr20  #MOD-C30056 add 
  DEFINE l_aag44       LIKE aag_file.aag44    #No.FUN-D40118   Add
  DEFINE l_flag        LIKE type_file.chr1    #No.FUN-D40118   Add
 
  LET l_npq.npqsys = 'AP'
  LET l_npq.npq00  = 1
  LET l_npq.npq011 = 1
  LET l_npq.npq02 = l_npq02 + 1
 #LET l_npq.npq04  = l_npq04      #FUN-D10065  mark
  LET l_npq.npq04 = NULL #FUN-D10065 add
  LET l_npq.npq24 = l_npq24
  SELECT azi04 INTO t_azi04 FROM azi_file
    WHERE azi01 = l_npq24
  LET l_npq.npq25 = l_npq25
  LET g_npq25_1=l_npq.npq25    #FUN-9A0036
  SELECT * INTO l_apa.* FROM apa_file WHERE apa01 = p_apno
  LET l_cnt = 0
  SELECT COUNT(*) INTO l_cnt FROM apb_file
   WHERE apb01 = (SELECT apa08 FROM apa_file WHERE apa01 = l_npq04)
 
  IF p_npptype = '0' THEN
     LET g_sql = " SELECT apb25,apb24,apb10,apb35,apb36,apb31,apb26,apb930 ",   #FUN-810045 add apb35/36/31  #MOD-8C0067 add apb26,apb930
                 "   FROM apb_file",
                 "  WHERE apb01 = (SELECT apa08 FROM apa_file ",
                 "  WHERE apa01 = '",l_npq04,"')"
  ELSE
     LET g_sql = " SELECT apb251,apb24,apb10,apb35,apb36,apb31,apb26,apb930 ",  #FUN-810045 add apb35/36/31  #MOD-8C0067 add apb26,apb930
                 "   FROM apb_file",
                 "  WHERE apb01 = (SELECT apa08 FROM apa_file ",
                 "  WHERE apa01 = '",l_npq04,"')"
  END IF
  PREPARE t110_gl_p6 FROM g_sql
  DECLARE t110_gl_c6 CURSOR FOR t110_gl_p6
  LET l_apa31 = 0
  LET l_apa31f = 0
  FOREACH t110_gl_c6 INTO l_apb25,l_apb24,l_apb10,l_apb35,l_apb36,l_apb31   #FUN-810045 add apb35/36/31
                         ,l_apb26,l_apb930   #MOD-8C0067 add l_apb26,l_apb930
     LET l_apa31 = l_apa31 + l_apb10   #MOD-680083
     LET l_apa31f= l_apa31f+ l_apb24   #MOD-680083
  END FOREACH
  LET l_cnt2 = 1
  LET s_npq07 = 0
  LET s_npq07f = 0
  FOREACH t110_gl_c6 INTO l_apb25,l_apb24,l_apb10,l_apb35,l_apb36,l_apb31    #FUN-810045 add apb35/36/31
                         ,l_apb26,l_apb930   #MOD-8C0067 add l_apb26,l_apb930
     IF l_cnt2 = l_cnt THEN
        LET l_npq.npq07 = l_npq07 - s_npq07
        LET l_npq.npq07f= l_npq07f- s_npq07f
     ELSE
        LET l_npq.npq07 = l_apb10 * (l_npq07/l_apa31)     #MOD-680083
        LET l_npq.npq07f= l_apb24 * (l_npq07f/l_apa31f)   #MOD-680083
     END IF
     LET l_npq.npq03 = l_apb25
     LET l_npq.npq06 = '2'
    MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',l_npq.npq07
    SELECT aag05,aag23,aag371 INTO l_aag05,l_aag23,l_aag371 FROM aag_file   #CHI-760007
     WHERE aag01=l_npq.npq03
       AND aag00=g_bookno        #No.FUN-730064
    LET l_npq.npq05 = ''   #MOD-B30089 add
    IF l_aag05='Y' THEN
       IF g_aaz.aaz90='N' THEN
          LET l_npq.npq05 = l_apb26       #MOD-8C0067
       ELSE
          LET l_npq.npq05 = l_apb930      #MOD-8C0067
       END IF
    ELSE
       LET l_npq.npq05 = ''
    END IF
    LET l_npq.npq11=''
    LET l_npq.npq12=''
    LET l_npq.npq13=''
    LET l_npq.npq14=''
    LET l_npq.npq31=''
    LET l_npq.npq32=''
    LET l_npq.npq33=''
    LET l_npq.npq34=''
    LET l_npq.npq35=''
    LET l_npq.npq36=''
    LET l_npq.npq37=''
    IF l_npq.npq07!=0 THEN
       IF p_aptype[1,1] = '2' THEN
          LET l_npq.npq07 = (-1)*l_npq.npq07
          LET l_npq.npq07f= (-1)*l_npq.npq07f
       END IF
       LET l_npq.npq07 = cl_digcut(l_npq.npq07,t_azi04)
       LET l_npq.npq07f = cl_digcut(l_npq.npq07f,g_azi04)
       LET p_prog = g_prog                       #MOD-C30056 add
       #No.MOD-BC0264  --Begin
       CASE g_prog
          WHEN 'aapp110' LET g_prog = 'aapt110'
          WHEN 'aapp111' LET g_prog = 'aapt210'
          WHEN 'aapp115' LET g_prog = 'aapt160'
          WHEN 'aapp117' LET g_prog = 'aapt260'
       END CASE
       #No.MOD-BC0264  --End
       CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno)        #No.FUN-730064
       RETURNING l_npq.*
       #FUN-D10065--add--str--
       IF cl_null(l_npq.npq04) THEN
          LET l_npq.npq04  = l_npq04
       END IF
       #FUN-D10065--add--end--
       LET g_prog = p_prog                       #MOD-C30056 add 
       CALL s_def_npq31_npq34(l_npq.*,g_bookno) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34      #FUN-AA0087
        CALL t110_chk_aee(l_npq.*)
        RETURNING l_npq.*
       SELECT azi04 INTO t_azi04 FROM azi_file
         WHERE azi01 = l_npq.npq24
#No.FUN-9A0036 --Begin
            IF p_npptype = '1' THEN
#FUN-A40067 --Begin
               SELECT aaa03 INTO l_aaa03 FROM aaa_file
                WHERE aaa01 = g_bookno2
               SELECT azi04 INTO g_azi04_2 FROM azi_file
                WHERE azi01 = l_aaa03
#FUN-A40067 --End
               CALL s_newrate(g_bookno1,g_bookno2,l_npq.npq24,
                              g_npq25_1,l_npp.npp02)
               RETURNING l_npq.npq25
              # LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25  #TQC-B80204 mark
              # TQC-B80204 --begin
               IF l_npq.npq25 = g_npq25_1 AND g_azi04_2 = g_azi04 THEN
                  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)
               ELSE
                  LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
                  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2)
               END IF
              # TQC-B80204 --end
              # LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2) #FUN-A40067  #TQC-B80204 mark
            ELSE
               LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
            END IF
#No.FUN-9A0036 --End
       LET l_npq.npq07f = cl_digcut(l_npq.npq07f,t_azi04)
#      LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)           #FUN-A40067
     # IF l_aag371 MATCHES '[23]' THEN                            #FUN-950053 mark
       IF l_aag371 MATCHES '[234]' THEN                           #FUN-950053 add 
          #-->for 合併報表-關係人
          SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903
            FROM pmc_file
           WHERE pmc01 = l_apa.apa05
          IF cl_null(l_npq.npq37) THEN
             IF l_pmc903 = 'Y' THEN
                LET l_npq.npq37 = l_apa.apa05 CLIPPED   #No.CHI-830037
             END IF
          END IF
       END IF
       IF l_aag23 = 'Y' THEN
          LET l_npq.npq08 = l_apb35
          LET l_npq.npq35 = l_apb36   #WBS     (存異動碼9)    #CHI-A30003 add
       ELSE
          LET l_npq.npq08 = NULL
          LET l_npq.npq35 = NULL     #CHI-A30003 add
       END IF
      #LET l_npq.npq35 = l_apb36   #WBS     (存異動碼9)     #CHI-A30003 mark
       SELECT aag21 INTO l_aag21 FROM aag_file
        WHERE aag00 = g_bookno
          AND aag01 = l_npq.npq03               
       IF l_aag21 = 'Y' THEN             #MOD-950096 
          LET l_npq.npq36 = l_apb31   #費用原因(存異動碼10)
       END IF                            #MOD-950096           
       LET l_npq.npqlegal = g_legal #FUN-980001 add
       #No.FUN-A30077  --Begin                                          
       CALL t110_entry_direction(g_bookno,l_npq.npq03,l_npq.npq06,      
                                 l_npq.npq07,l_npq.npq07f)              
            RETURNING l_npq.npq06,l_npq.npq07,l_npq.npq07f              
       #No.FUN-A30077  --End 
#No.FUN-AC0001 --begin                                                          
               IF cl_null(l_npq.npq35) THEN LET l_npq.npq35 = ' ' END IF        
               IF cl_null(l_npq.npq05) THEN LET l_npq.npq05 = ' ' END IF        
               IF cl_null(l_npq.npq08) THEN LET l_npq.npq08 = ' ' END IF        
#No.FUN-AC0001 --end 
      #FUN-D40118 ---Add--- Start
       SELECT aag44 INTO l_aag44 FROM aag_file
        WHERE aag00 = g_bookno3
          AND aag01 = l_npq.npq03
       IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
          CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
          IF l_flag = 'N'   THEN
             LET l_npq.npq03 = ''
          END IF
       END IF
      #FUN-D40118 ---Add--- End
       INSERT INTO npq_file VALUES (l_npq.*)
       IF STATUS THEN
          IF g_bgerr THEN
             LET g_showmsg=l_npq.npq01,"/",l_npq.npq011,"/",l_npq.npq02,"/",l_npq.npqsys,"/",l_npq.npq00,"/",l_npq.npqtype
             CALL s_errmsg("npq01,npq011,npq02,npqsys,npq00,npqtype",g_showmsg,"t110_g_gl(ckp#4)",SQLCA.sqlcode,1)
          ELSE
             CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,STATUS,"","t110_g_gl(ckp#4)",1)  #No.FUN-660122
          END IF
          LET g_success='N' EXIT FOREACH #no.5573
       END IF
    END IF
    LET l_npq.npq02 = l_npq.npq02 + 1
    LET l_cnt2 = l_cnt2 + 1
    LET s_npq07 = s_npq07 + l_npq.npq07
    LET s_npq07f = s_npq07f + l_npq.npq07f
  END FOREACH
  RETURN l_npq.npq02
END FUNCTION
 
FUNCTION t110_unap_npq1(p_apno,p_aptype,p_bookno,p_apa,p_npptype,p_type)
  DEFINE p_npptype   LIKE npp_file.npptype
  DEFINE p_apno      LIKE apa_file.apa01
  DEFINE p_aptype    LIKE apa_file.apa00
  DEFINE p_bookno    LIKE aaa_file.aaa01
  DEFINE p_apa       RECORD LIKE apa_file.*
  DEFINE p_type      LIKE type_file.chr1
  DEFINE l_apb       RECORD LIKE apb_file.*
  DEFINE l_aag05     LIKE aag_file.aag05
  DEFINE l_aag21     LIKE aag_file.aag21
  DEFINE l_aag23     LIKE aag_file.aag23
  DEFINE l_aag371    LIKE aag_file.aag371
  DEFINE l_pmc03     LIKE pmc_file.pmc03
  DEFINE l_pmc903    LIKE pmc_file.pmc903
  DEFINE l_aaa03     LIKE aaa_file.aaa03    #FUN-A40067
  DEFINE p_prog      LIKE type_file.chr20  #MOD-C30056 add
  DEFINE l_aag44       LIKE aag_file.aag44    #No.FUN-D40118   Add
  DEFINE l_flag        LIKE type_file.chr1    #No.FUN-D40118   Add
 
   LET g_sql = "SELECT * FROM apb_file",
               " WHERE apb01='",p_apno,"'",
               "   AND apb34='N'"
   PREPARE t110_gl_p1_1 FROM g_sql
   DECLARE t110_gl_c1_1 CURSOR FOR t110_gl_p1_1
   
   FOREACH t110_gl_c1_1 INTO l_apb.*   
      IF STATUS THEN 
         EXIT FOREACH 
      END IF
 
      LET l_npq.npq02 = l_npq.npq02 + 1
      IF p_npptype = '0' THEN
         LET l_npq.npq03 = l_apb.apb25
      ELSE
         LET l_npq.npq03 = l_apb.apb251
      END IF
     #LET l_npq.npq04 = p_apa.apa25    #FUN-D10065  mark
      LET l_npq.npq04 = NULL          #FUN-D10065  add
      IF p_aptype[1,1] = '1' THEN
         LET l_npq.npq06 = '1'
      ELSE
         LET l_npq.npq06 = '2'
      END IF
      LET l_npq.npq07 = l_apb.apb10
      LET l_npq.npq07f= l_apb.apb24
      LET l_aag05 = ' '
      LET l_aag21 = ' '
      LET l_aag23 = ' '
      LET l_aag371= ' '   #MOD-750132
   
      SELECT aag05,aag21,aag23,aag371 INTO l_aag05,l_aag21,l_aag23,l_aag371   #MOD-5A0274   #MOD-750132
        FROM aag_file
       WHERE aag01 = l_npq.npq03
         AND aag00 = p_bookno
   
      IF l_npq.npq07 < 0 THEN
         LET l_npq.npq07 = l_npq.npq07 * -1
         LET l_npq.npq07f = l_npq.npq07f * -1
         IF l_npq.npq06 = '1' THEN 
            LET l_npq.npq06 = '2'
         ELSE
            LET l_npq.npq06 = '1'
         END IF
      END IF
   
      LET l_npq.npq05 = ''   #MOD-B30089 add
      IF l_aag05='Y' THEN
         IF g_aaz.aaz90='N' THEN
            LET l_npq.npq05 = l_apb.apb26   #MOD-8C0067
         ELSE
            LET l_npq.npq05 = l_apb.apb930  #MOD-8C0067
         END IF
      ELSE
         LET l_npq.npq05 = ''
      END IF
         
      LET l_npq.npq11 = ''
      LET l_npq.npq12 = ''
      LET l_npq.npq13 = ''
      LET l_npq.npq14 = ''
      LET l_npq.npq31 = ''
      LET l_npq.npq32 = ''
      LET l_npq.npq33 = ''
      LET l_npq.npq34 = ''
      LET l_npq.npq35 = ''
      LET l_npq.npq36 = ''
      LET l_npq.npq37 = ''
 
      IF l_npq.npq07 != 0 THEN 
         IF p_type = '1' THEN
            IF p_aptype[1,1] = '2' THEN
               LET l_npq.npq07 = (-1)*l_npq.npq07                                  
               LET l_npq.npq07f= (-1)*l_npq.npq07f 
            END IF
         ELSE
            IF p_aptype[1,1] = '1' THEN
               LET l_npq.npq07 = (-1)*l_npq.npq07                                  
               LET l_npq.npq07f= (-1)*l_npq.npq07f 
            END IF
         END IF
         LET p_prog = g_prog                       #MOD-C30056 add
         #No.MOD-BC0264  --Begin
         CASE g_prog
                  WHEN 'aapp110' LET g_prog = 'aapt110'
                  WHEN 'aapp111' LET g_prog = 'aapt210'
                  WHEN 'aapp115' LET g_prog = 'aapt160'
                  WHEN 'aapp117' LET g_prog = 'aapt260'
         END CASE
         #No.MOD-BC0264  --End
       # CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno)       #No.FUN-730064  #No.FUN-A30077
         CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',p_bookno)       #No.FUN-730064  #No.FUN-A30077
         RETURNING l_npq.*
         #FUN-D10065--add--str--
         IF cl_null(l_npq.npq04) THEN
            LET l_npq.npq04 = p_apa.apa25
         END IF
         #FUN-D10065--add--end--
         LET g_prog = p_prog                       #MOD-C30056 add
         CALL s_def_npq31_npq34(l_npq.*,g_bookno) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34    #FUN-AA0087
         CALL t110_chk_aee(l_npq.*)
         RETURNING l_npq.*
         SELECT azi04 INTO t_azi04 FROM azi_file
           WHERE azi01 = l_npq.npq24
#No.FUN-9A0036 --Begin
            IF p_npptype = '1' THEN
#FUN-A40067 --Begin
               SELECT aaa03 INTO l_aaa03 FROM aaa_file
                WHERE aaa01 = g_bookno2
               SELECT azi04 INTO g_azi04_2 FROM azi_file
                WHERE azi01 = l_aaa03
#FUN-A40067 --End
               CALL s_newrate(g_bookno1,g_bookno2,l_npq.npq24,
                              g_npq25_1,l_npp.npp02)
               RETURNING l_npq.npq25
              # LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25  #TQC-B80204 mark
              # TQC-B80204 --begin
               IF l_npq.npq25 = g_npq25_1 AND g_azi04_2 = g_azi04 THEN
                  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)
               ELSE
                  LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
                  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2)
               END IF
              # TQC-B80204 --end
              # LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2) #FUN-A40067 #TQC-B80204 mark
            ELSE
               LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
            END IF
#No.FUN-9A0036 --End
         LET l_npq.npq07f = cl_digcut(l_npq.npq07f,t_azi04)
#        LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)         #FUN-A40067
       # IF l_aag371 MATCHES '[23]' THEN                          #FUN-950053 mark
         IF l_aag371 MATCHES '[234]' THEN                         #FUN-950053 add
            #-->for 合併報表-關係人
            SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903 FROM pmc_file
             WHERE pmc01 = p_apa.apa05
            IF cl_null(l_npq.npq37) THEN 
               IF l_pmc903 = 'Y' THEN
                  LET l_npq.npq37 = p_apa.apa05 CLIPPED   #No.CHI-830037
               END IF
            END IF
         END IF
         IF l_aag23 = 'Y' THEN
            LET l_npq.npq08 = l_apb.apb35
            LET l_npq.npq35 = l_apb.apb36   #WBS     (存異動碼9)    #CHI-A30003 add
         ELSE
            LET l_npq.npq08 = NULL
            LET l_npq.npq35 = NULL    #CHI-A30003 add 
         END IF
        #LET l_npq.npq35 = l_apb.apb36   #WBS     (存異動碼9)    #CHI-A30003 mark
 
         SELECT aag21 INTO l_aag21 FROM aag_file
        # WHERE aag00 = g_bookno     #No.FUN-A30077
          WHERE aag00 = p_bookno     #No.FUN-A30077
            AND aag01 = l_npq.npq03               
          IF l_aag21 = 'Y' THEN             #MOD-950096 
             LET l_npq.npq36 = l_apb.apb31   #費用原因(存異動碼10)  
          END IF                            #MOD-950096               
         LET l_npq.npqlegal = g_legal #FUN-980001 add
         #No.FUN-A30077  --Begin                                          
         CALL t110_entry_direction(p_bookno,l_npq.npq03,l_npq.npq06,      
                                   l_npq.npq07,l_npq.npq07f)              
              RETURNING l_npq.npq06,l_npq.npq07,l_npq.npq07f              
         #No.FUN-A30077  --End 
#No.FUN-AC0001 --begin                                                          
               IF cl_null(l_npq.npq35) THEN LET l_npq.npq35 = ' ' END IF        
               IF cl_null(l_npq.npq05) THEN LET l_npq.npq05 = ' ' END IF        
               IF cl_null(l_npq.npq08) THEN LET l_npq.npq08 = ' ' END IF        
#No.FUN-AC0001 --end 
        #FUN-D40118 ---Add--- Start
         SELECT aag44 INTO l_aag44 FROM aag_file
          WHERE aag00 = g_bookno3
            AND aag01 = l_npq.npq03
         IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
            CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET l_npq.npq03 = ''
            END IF
         END IF
       #FUN-D40118 ---Add--- End
         INSERT INTO npq_file VALUES (l_npq.*)
         MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',l_npq.npq07
         IF STATUS THEN 
            IF g_bgerr THEN
               LET g_showmsg=l_npq.npq01,"/",l_npq.npq011,"/",l_npq.npq02,"/",l_npq.npqsys,"/",l_npq.npq00,"/",l_npq.npqtype
               CALL s_errmsg("npq01,npq011,npq02,npqsys,npq00,npqtype",g_showmsg,"t110_g_gl(ckp#1)",SQLCA.sqlcode,1)
            ELSE
               CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,STATUS,"","t110_g_gl(ckp#1)",1)  #No.FUN-660122
            END IF
            LET g_success = 'N'
            EXIT FOREACH
         END IF
      END IF
   END FOREACH
END FUNCTION
 
FUNCTION t110_unap_npq2(p_apno,p_aptype,p_bookno,p_apa,p_npptype,p_type)
  DEFINE p_apno      LIKE apa_file.apa01
  DEFINE p_aptype    LIKE apa_file.apa00
  DEFINE p_bookno    LIKE aaa_file.aaa01
  DEFINE p_apa       RECORD LIKE apa_file.*
  DEFINE p_npptype   LIKE npp_file.npptype
  DEFINE p_type      LIKE type_file.chr1
  DEFINE l_api       RECORD
                     api02    LIKE api_file.api02,   #MOD-B10093
                     api04    LIKE api_file.api04,
                     api05    LIKE api_file.api05,
                     api05f   LIKE api_file.api05f,
                     api06    LIKE api_file.api06,
                     api07    LIKE api_file.api07,
                     api930   LIKE api_file.api930,   #MOD-8C0067 add
                     api21    LIKE api_file.api21,
                     api22    LIKE api_file.api22,
                     api23    LIKE api_file.api23,
                     api24    LIKE api_file.api24,
                     api26    LIKE api_file.api26,
                     api31    LIKE api_file.api31,
                     api32    LIKE api_file.api32,
                     api33    LIKE api_file.api33,
                     api34    LIKE api_file.api34,
                     api35    LIKE api_file.api35,
                     api36    LIKE api_file.api36,
                     api37    LIKE api_file.api37, 
                     api40    LIKE api_file.api40   #MOD-930244 add
                     END RECORD
  DEFINE l_aag05     LIKE aag_file.aag05
  DEFINE l_aag21     LIKE aag_file.aag21
  DEFINE l_aag23     LIKE aag_file.aag23
  DEFINE l_aag371    LIKE aag_file.aag371
  DEFINE l_pmc03     LIKE pmc_file.pmc03
  DEFINE l_pmc903    LIKE pmc_file.pmc903
  DEFINE l_azi03     LIKE azi_file.azi03   #MOD-930244 add
  DEFINE l_sql       STRING
  DEFINE l_count     LIKE type_file.num5
  DEFINE l_oox07   DYNAMIC ARRAY OF RECORD 
                 oox07  LIKE oox_file.oox07
                    END RECORD 
  DEFINE l_aaa03     LIKE aaa_file.aaa03      #FUN-A40067
  DEFINE l_aps       RECORD LIKE aps_file.*   #MOD-B10104
  DEFINE p_prog      LIKE type_file.chr20  #MOD-C30056 add
  DEFINE l_aag44       LIKE aag_file.aag44    #No.FUN-D40118   Add
  DEFINE l_flag        LIKE type_file.chr1    #No.FUN-D40118   Add
 
     IF p_npptype = '0' THEN
        LET g_sql = " SELECT api02,api04,SUM(api05),SUM(api05f),api06,api07,api930,api21,",   #MOD-8C0067 add api930 #MOD-B10093 add api02
                    "        api22,api23,api24,api26,api31,api32,api33,",        #No.TQC-7C0149 api26  #No.FUN-830161
                   #"        api34,api35,api36,api37,api40 ",  #MOD-930244 add api40   #CHI-E30030 mark
                    "        api34,api35,api36,api37,1 ",                              #CHI-E30030 add
                    "   FROM api_file ",
                    "  WHERE api01 = '",p_apno,"'",
                   #"    AND (api04 IS NOT NULL AND api04 <> ' ')",              #TQC-B10104 mark
                    "  GROUP BY api02,api04,api06,api07,api930,api21,api22,api23,api24,",   #MOD-8C0067 add api930 #MOD-B10093 add api02
                    "           api26,api31,api32,api33,api34,api35,",           #No.TQC-7C0149 api26  #No.FUN-830161
                    #"           api36,api37,api40 "  #MOD-930244 add api40   #CHI-E30030 mark
                    "           api36,api37,1 "                              #CHI-E30030 add
     ELSE
        LET g_sql = " SELECT api02,api041,SUM(api05),SUM(api05f),api06,api07,api930,api21,",   #MOD-8C0067 add api930 #MOD-B10093 add api02
                    "        api22,api23,api24,api26,api31,api32,api33,",        #No.TQC-7C0149 api26  #No.FUN-830161
                    "        api34,api35,api36,api37,api40 ",  #MOD-930244 add api40
                    "   FROM api_file ",
                    "  WHERE api01 = '",p_apno,"'",
                   #"    AND (api041 IS NOT NULL AND api041 <> ' ')",            #TQC-B10104 mark
                    "  GROUP BY api02,api041,api06,api07,api930,api21,api22,api23,api24,",     #No.TQC-7C0149 api26   #MOD-8C0067 add api930 #MOD-B10093 add api02
                    "           api26,api31,api32,api33,api34,api35,",            #No.FUN-830161
                    #"           api36,api37,api40 "  #MOD-930244 add api40   #CHI-E30030 mark
                    "           api36,api37,1 "                              #CHI-E30030 add
     END IF
     PREPARE t110_gl_p1x FROM g_sql
     DECLARE t110_gl_c1x CURSOR FOR t110_gl_p1x
         LET l_sql = "select oox07 from oox_file where oox00 = 'AP' ",
                     "   and oox03 = ? and oox041 = ? ",
                     "order by oox01 desc,oox02 desc"
         PREPARE t110_oox073 FROM l_sql
         DECLARE t110_oox07_cl3 CURSOR FOR t110_oox073
  
     LET l_npq24_o = l_npq.npq24  #No.TQC-7C0149
     LET l_npq25_o = l_npq.npq25  #No.TQC-7C0149
     FOREACH t110_gl_c1x INTO l_api.*
        IF STATUS THEN 
           EXIT FOREACH 
        END IF
   
        IF NOT cl_null(l_api.api26) AND l_api.api26 <> 'DIFF' THEN
           SELECT apa13 INTO l_npq.npq24                    #MOD-930244
             FROM apa_file
            WHERE apa01 = l_api.api26
           IF SQLCA.sqlcode THEN
              LET l_npq.npq24 = l_npq24_o
           END IF
       #-TQC-B10104-add-
        ELSE
           IF l_api.api26 = 'DIFF' THEN
             #-MOD-B40087-mark- 
             ##取匯兌損溢科目                                                            
             #IF g_apz.apz13 = 'Y' THEN   #按部門區分預設會計科目                        
             #   IF NOT cl_null(p_apa.apa22) THEN                                            
             #      SELECT * INTO l_aps.* FROM aps_file WHERE aps01 = p_apa.apa22            
             #      IF STATUS THEN                                                       
             #         IF g_bgerr THEN
             #            CALL s_errmsg("aps01",p_apa.apa22,"sel aps",SQLCA.sqlcode,1)
             #         ELSE
             #           CALL cl_err3("sel","aps_file",p_apa.apa22,"",STATUS,"","sel aps",1)  
             #         END IF
             #         LET g_success = 'N' RETURN  
             #      END IF                                                               
             #   ELSE                                                                    
             #      INITIALIZE l_aps.* TO NULL                                           
             #      IF l_npq.npq04 = 'DIFF' THEN
             #         SELECT * INTO l_aps.* FROM aps_file WHERE aps01 = p_apa.apa22
             #         IF STATUS THEN
             #            IF g_bgerr THEN
             #               CALL s_errmsg("aps01",p_apa.apa22,"sel aps",SQLCA.sqlcode,1)
             #            ELSE
             #              CALL cl_err3("sel","aps_file",p_apa.apa22,"",STATUS,"","sel aps",1)  
             #            END IF
             #            LET g_success = 'N' RETURN
             #         END IF
             #      END IF
             #   END IF                                                                  
             #ELSE                                                                       
             #   SELECT * INTO l_aps.* FROM aps_file WHERE aps01 = ' '                   
             #   IF STATUS THEN                                                          
             #      IF g_bgerr THEN
             #         CALL s_errmsg("aps01","","sel aps",SQLCA.sqlcode,1)
             #      ELSE
             #         CALL cl_err3("sel","aps_file","","",STATUS,"","sel aps",1)  
             #      END IF
             #      LET g_success = 'N' RETURN
             #   END IF 
             #END IF                                                                     
             #-MOD-B40087-end- 
             #LET l_api.api05f = 0     #MOD-B40233 mark 
             #IF l_api.api05 > 0 THEN  #增加大于0否的判斷 
              IF (l_api.api05 > 0 AND p_aptype[1,1]=1) OR (l_api.api05 < 0 AND p_aptype[1,1]=2)  THEN  #MOD-C80028      
                 LET l_npq.npq06 = '1'                                                  
                #-MOD-B40087-mark- 
                #IF p_npptype = '0' THEN  
                #   LET l_api.api04 = l_aps.aps43  
                #ELSE
                #   LET l_api.api04 = l_aps.aps431
                #END IF
                #-MOD-B40087-end- 
              END IF                                                                     
             #IF l_api.api05 < 0 THEN
              IF (l_api.api05 < 0 AND p_aptype[1,1]=1) OR (l_api.api05 > 0 AND p_aptype[1,1]=2)  THEN  #MOD-C80028                           
                 LET l_npq.npq06 = '2'                                                   
                #LET l_api.api05f = l_api.api05f * (-1)  #MOD-B40233      #MOD-C80028 mark 
                #LET l_api.api05 = l_api.api05 * (-1)                     #MOD-C80028 mark               
                #-MOD-B40087-mark- 
                #IF p_npptype = '0' THEN  
                #   LET l_api.api04 = l_aps.aps42
                #ELSE
                #   LET l_api.api04 = l_aps.aps421
                #END IF
                #-MOD-B40087-end- 
              END IF                                                                    
              #No.MOD-C80028  --Begin
              IF l_api.api05 < 0 THEN
                 LET l_api.api05f = l_api.api05f * (-1)
                 LET l_api.api05 = l_api.api05 * (-1)
              END IF
              #No.MOD-C80028  --End 
           END IF
       #-TQC-B10104-end-
        END IF
        LET l_npq.npq02 = l_npq.npq02 + 1
        LET l_npq.npq03 = l_api.api04
        LET l_npq.npq04 = NULL          #FUN-D10065  add
       #FUN-D10065--mark--str--
       #LET l_npq.npq04 = l_api.api06    
   
       #IF cl_null(l_npq.npq04) THEN
       #   LET l_npq.npq04 = p_apa.apa25
       #END IF
       #FUN-D10065--mark--end--
        SELECT azi03 INTO l_azi03 FROM azi_file WHERE azi01 =l_npq.npq24
        IF cl_null(l_api.api05) THEN
           LET l_api.api05 =0
        END IF
        IF cl_null(l_api.api05f) THEN
           LET l_api.api05f =1
        END IF
        LET l_npq.npq25=''
        IF g_apz.apz27 = 'Y' THEN   #有做重評價
                LET l_count = 1 
                #FOREACH t110_oox07_cl3 USING l_api.api26,l_api.api40   #CHI-E30030 mark
                FOREACH t110_oox07_cl3 USING l_api.api26,'1'           #CHI-E30030 add
                                      INTO l_oox07[l_count].*
                    IF STATUS THEN 
                       CALL cl_err('forach:',STATUS,1)
                       EXIT FOREACH
                    END IF         
                    LET l_npq.npq25 = l_oox07[l_count].oox07
                    LET l_count = l_count + 1
                    IF l_count = 2 THEN 
                       EXIT FOREACH 
                    END IF            
                END FOREACH                                          
        END IF
        IF cl_null(l_npq.npq25) THEN
          #-MOD-B10093-add-
           IF l_api.api02 = '1' THEN  
              LET l_npq.npq25 = p_apa.apa14   
           ELSE
          #-MOD-B10093-end-
            #str MOD-B70140 add
             IF l_api.api26 = 'DIFF' THEN
                LET l_npq.npq25 = 1
             ELSE
            #end MOD-B70140 add
             #-MOD-A60160-add-
              SELECT apa14 INTO l_npq.npq25    
                FROM apa_file
               WHERE apa01 = l_api.api26
             #-MOD-A60160-end-
             END IF   #MOD-B70140 add
           END IF                  #MOD-B10093
          #LET l_npq.npq25 =l_api.api05/l_api.api05f        #MOD-A60160 mark
          #LET l_npq.npq25 =cl_digcut(l_npq.npq25,l_azi03)  #MOD-AC0049 mark
        END IF
        LET g_npq25_1=l_npq.npq25            #No.FUN-9A0036
        IF l_api.api26 <> 'DIFF' THEN      #TQC-B10104
           IF p_aptype[1,1] = '1' THEN
              LET l_npq.npq06 = '1'
           ELSE
              LET l_npq.npq06 = '2'
           END IF
       #-TQC-B10104-add-
        ELSE
           LET l_npq.npq24 = g_aza.aza17   
           LET l_npq.npq25 = 1         
        END IF                            
       #-TQC-B10104-end-
        LET l_npq.npq07 = l_api.api05
        LET l_npq.npq07f= l_api.api05f
        LET l_aag05 = ' '
        LET l_aag21 = ' '
        LET l_aag23 = ' '
        LET l_aag371= ' '
   
        SELECT aag05,aag21,aag23,aag371 INTO l_aag05,l_aag21,l_aag23,l_aag371   #MOD-5A0274   #MOD-750132
          FROM aag_file
         WHERE aag01 = l_npq.npq03
           AND aag00 = p_bookno
   
        IF l_aag23 = 'Y' THEN
           LET l_npq.npq08 = l_api.api26    # 專案
           LET l_npq.npq35 = l_api.api35    #CHI-A30003 add
        ELSE
           LET l_npq.npq08 = NULL
           LET l_npq.npq35 = NULL           #CHI-A30003 add
        END IF
   
        IF l_npq.npq07 < 0 THEN
           LET l_npq.npq07 = l_npq.npq07 * -1
           LET l_npq.npq07f = l_npq.npq07f * -1
           IF l_npq.npq06 = '1' THEN 
              LET l_npq.npq06 = '2'
           ELSE
              LET l_npq.npq06 = '1'
           END IF
        END IF
   
        LET l_npq.npq05 = ''   #MOD-B30089 add
        IF l_aag05='Y' THEN
           IF g_aaz.aaz90='N' THEN
              LET l_npq.npq05 = l_api.api07
           ELSE
              LET l_npq.npq05 = l_api.api930   #MOD-8C0067
           END IF
        ELSE
           LET l_npq.npq05 = ''
        END IF
 
        LET l_npq.npq11 = l_api.api21
        LET l_npq.npq12 = l_api.api22
        LET l_npq.npq13 = l_api.api23
        LET l_npq.npq14 = l_api.api24
        LET l_npq.npq31 = l_api.api31
        LET l_npq.npq32 = l_api.api32
        LET l_npq.npq33 = l_api.api33
        LET l_npq.npq34 = l_api.api34
       #LET l_npq.npq35 = l_api.api35       #CHI-A30003 mark
        SELECT aag21 INTO l_aag21 FROM aag_file
        #WHERE aag00 = g_bookno   #No.FUN-A30077
         WHERE aag00 = p_bookno   #No.FUN-A30077
           AND aag01 = l_npq.npq03               
        IF l_aag21 = 'Y' THEN             #MOD-950096 
           LET l_npq.npq36 = l_api.api36 
        END IF                            #MOD-950096    
       #LET l_npq.npq37 = l_api.api37     #MOD-A20047 mark
   
        IF l_npq.npq07 != 0 THEN 
           IF p_type = '1' THEN  #1單據
              IF p_aptype[1,1] = '2' THEN
                 LET l_npq.npq07 = (-1)*l_npq.npq07                                  
                 LET l_npq.npq07f= (-1)*l_npq.npq07f 
               #No.yinhy131114  --Begin
               #----------------MOD-D10289-----------mark
               #----------------MOD-CC0237----------------(S)
                IF g_aza.aza26 = '2' AND g_apydmy6 = 'Y' THEN
                   IF l_npq.npq06 = '1' THEN
                      LET l_npq.npq06 = '2'
                   ELSE
                      LET l_npq.npq06 = '1'
                   END IF
                END IF
               ##----------------MOD-CC0237----------------(E)
               #----------------MOD-D10289-----------mark
               #No.yinhy131114  --End
              END IF
           ELSE
              IF p_aptype[1,1] = '1' THEN
                 LET l_npq.npq07 = (-1)*l_npq.npq07                                  
                 LET l_npq.npq07f= (-1)*l_npq.npq07f 
              END IF
           END IF
          LET p_prog = g_prog                       #MOD-C30056 add
          #No.MOD-BC0264  --Begin
          CASE g_prog
                  WHEN 'aapp110' LET g_prog = 'aapt110'
                  WHEN 'aapp111' LET g_prog = 'aapt210'
                  WHEN 'aapp115' LET g_prog = 'aapt160'
                  WHEN 'aapp117' LET g_prog = 'aapt260'
          END CASE
          #No.MOD-BC0264  --End
          #CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno)         #No.FUN-730064  #No.FUN-A30077
          CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',p_bookno)         #No.FUN-730064  #No.FUN-A30077
          RETURNING l_npq.*
          #FUN-D10065--add--str--
          IF cl_null(l_npq.npq04) THEN
             LET l_npq.npq04 = l_api.api06
          END IF
          IF cl_null(l_npq.npq04) THEN
             LET l_npq.npq04 = p_apa.apa25
          END IF
          #FUN-D10065--add--end--
          LET g_prog = p_prog                       #MOD-C30056 add
          CALL s_def_npq31_npq34(l_npq.*,g_bookno) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34    #FUN-AA0087
          LET l_npq.npq37 = l_api.api37         #MOD-A20047 add
          CALL t110_chk_aee(l_npq.*)
          RETURNING l_npq.*
          SELECT azi04 INTO t_azi04 FROM azi_file
           WHERE azi01 = l_npq.npq24
#No.FUN-9A0036 --Begin
            IF p_npptype = '1' THEN
#FUN-A40067 --Begin
               SELECT aaa03 INTO l_aaa03 FROM aaa_file
                WHERE aaa01 = g_bookno2
               SELECT azi04 INTO g_azi04_2 FROM azi_file
                WHERE azi01 = l_aaa03
#FUN-A40067 --End
               CALL s_newrate(g_bookno1,g_bookno2,l_npq.npq24,
                              g_npq25_1,l_npp.npp02)
               RETURNING l_npq.npq25
              # LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25  #TQC-B80204 mark
              # TQC-B80204 --begin
               IF l_npq.npq25 = g_npq25_1 AND g_azi04_2 = g_azi04 THEN
                  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)
               ELSE
                  LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
                  LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2)
               END IF
              # TQC-B80204 --end
              # LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2) #FUN-A40067 #TQC-B80204 mark
            ELSE
               LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
            END IF
#No.FUN-9A0036 --End

           LET l_npq.npq07f = cl_digcut(l_npq.npq07f,t_azi04)
#          LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)       #FUN-A40067
         # IF l_aag371 MATCHES '[23]' THEN                        #FUN-950053 mark
           IF l_aag371 MATCHES '[234]' THEN                       #FUN-950053 add
              #-->for 合併報表-關係人
              SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903 FROM pmc_file
               WHERE pmc01 = p_apa.apa05
              IF cl_null(l_npq.npq37) THEN
                 IF l_pmc903 = 'Y' THEN
                    LET l_npq.npq37 = p_apa.apa05 CLIPPED   #No.CHI-830037
                 END IF
              END IF
           END IF
           LET l_npq.npqlegal = g_legal #FUN-980001 add
           #No.FUN-A30077  --Begin                                          
           CALL t110_entry_direction(p_bookno,l_npq.npq03,l_npq.npq06,      
                                     l_npq.npq07,l_npq.npq07f)              
                RETURNING l_npq.npq06,l_npq.npq07,l_npq.npq07f              
           #No.FUN-A30077  --End 
#No.FUN-AC0001 --begin                                                          
               IF cl_null(l_npq.npq35) THEN LET l_npq.npq35 = ' ' END IF        
               IF cl_null(l_npq.npq05) THEN LET l_npq.npq05 = ' ' END IF        
               IF cl_null(l_npq.npq08) THEN LET l_npq.npq08 = ' ' END IF        
#No.FUN-AC0001 --end 
          #FUN-D40118 ---Add--- Start
           SELECT aag44 INTO l_aag44 FROM aag_file
            WHERE aag00 = g_bookno3
              AND aag01 = l_npq.npq03
           IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
              CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
              IF l_flag = 'N'   THEN
                 LET l_npq.npq03 = ''
              END IF
           END IF
          #FUN-D40118 ---Add--- End
           INSERT INTO npq_file VALUES (l_npq.*)
           MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',l_npq.npq07
           IF STATUS THEN 
              IF g_bgerr THEN
                 LET g_showmsg=l_npq.npq01,"/",l_npq.npq011,"/",l_npq.npq02,"/",l_npq.npqsys,"/",l_npq.npq00,"/",l_npq.npqtype
                 CALL s_errmsg("npq01,npq011,npq02,npqsys,npq00,npqtype",g_showmsg,"t110_g_gl(ckp#1)",SQLCA.sqlcode,1)
              ELSE
                 CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,STATUS,"","t110_g_gl(ckp#1)",1)  #No.FUN-660122
              END IF
              LET g_success = 'N'
              EXIT FOREACH
           END IF
        END IF
        LET l_npq.npq24 = l_npq24_o  #No.TQC-7C0149
        LET l_npq.npq25 = l_npq25_o  #No.TQC-7C0149
        LET g_npq25_1=l_npq.npq25    #No.FUN-9A0036
     END FOREACH
END FUNCTION
 
FUNCTION t110_chk_aee(l_npq)
DEFINE l_npq  RECORD    LIKE npq_file.*
 
   CALL s_chk_aee(l_npq.npq03,'1',l_npq.npq11,g_bookno)   
   IF NOT cl_null(g_errno) THEN 
      LET l_npq.npq11 = ''
   END IF   
   
   CALL s_chk_aee(l_npq.npq03,'2',l_npq.npq12,g_bookno)   
   IF NOT cl_null(g_errno) THEN 
      LET l_npq.npq12 = ''
   END IF   
   
   CALL s_chk_aee(l_npq.npq03,'3',l_npq.npq13,g_bookno)   
   IF NOT cl_null(g_errno) THEN 
      LET l_npq.npq13 = ''
   END IF   
   
   CALL s_chk_aee(l_npq.npq03,'4',l_npq.npq14,g_bookno)   
   IF NOT cl_null(g_errno) THEN 
      LET l_npq.npq14 = ''
   END IF   
   
   CALL s_chk_aee(l_npq.npq03,'5',l_npq.npq31,g_bookno)   
   IF NOT cl_null(g_errno) THEN 
      LET l_npq.npq31 = ''
   END IF   
   
   CALL s_chk_aee(l_npq.npq03,'6',l_npq.npq32,g_bookno)   
  IF NOT cl_null(g_errno) THEN 
      LET l_npq.npq32 = ''
   END IF   
   
   CALL s_chk_aee(l_npq.npq03,'7',l_npq.npq33,g_bookno)   
   IF NOT cl_null(g_errno) THEN 
      LET l_npq.npq33 = ''
   END IF   
   
   CALL s_chk_aee(l_npq.npq03,'8',l_npq.npq34,g_bookno)   
   IF NOT cl_null(g_errno) THEN 
      LET l_npq.npq34 = ''
   END IF   
   
   CALL s_chk_aee(l_npq.npq03,'9',l_npq.npq35,g_bookno)   
   IF NOT cl_null(g_errno) THEN 
      LET l_npq.npq35 = ''
   END IF   
      
   CALL s_chk_aee(l_npq.npq03,'10',l_npq.npq36,g_bookno) 
   IF NOT cl_null(g_errno) THEN 
      LET l_npq.npq36 = ''
   END IF   
   
   CALL s_chk_aee(l_npq.npq03,'99',l_npq.npq37,g_bookno)  
   IF NOT cl_null(g_errno) THEN 
      LET l_npq.npq37 = ''
   END IF   
   RETURN l_npq.*
END FUNCTION 
#NO.FUN-9C0072 精簡程式碼 

#No.FUN-A30077  --Begin
FUNCTION t110_entry_direction(p_bookno,p_npq03,p_npq06,p_npq07,p_npq07f)
   DEFINE p_bookno  LIKE aag_file.aag00
   DEFINE p_npq03   LIKE npq_file.npq03
   DEFINE p_npq06   LIKE npq_file.npq06
   DEFINE p_npq07   LIKE npq_file.npq07
   DEFINE p_npq07f  LIKE npq_file.npq07f
   DEFINE l_aag06   LIKE aag_file.aag06
   DEFINE l_aag42   LIKE aag_file.aag42

   IF g_apydmy6 = 'Y' THEN              #MOD-BA0042  
      RETURN p_npq06,p_npq07,p_npq07f   #MOD-BA0042
   END IF                               #MOD-BA0042
   IF cl_null(p_npq03) THEN
      RETURN p_npq06,p_npq07,p_npq07f
   END IF
   IF cl_null(p_npq06) OR p_npq06 NOT MATCHES '[12]' THEN
      RETURN p_npq06,p_npq07,p_npq07f
   END IF

   IF cl_null(p_npq07)  THEN LET p_npq07  = 0 END IF
   IF cl_null(p_npq07f) THEN LET p_npq07f = 0 END IF
   IF p_npq07 = 0 AND p_npq07f = 0 THEN
      RETURN p_npq06,p_npq07,p_npq07f
   END IF

   SELECT aag06,aag42 INTO l_aag06,l_aag42
     FROM aag_file
    WHERE aag00 = p_bookno
      AND aag01 = p_npq03
   IF cl_null(l_aag42) OR l_aag42 = 'N' THEN
      #No.TQC-AB0069  --Begin
      IF p_npq07 < 0 OR p_npq07f < 0 THEN
         IF p_npq06 = '1' THEN
            LET p_npq06 = '2'
         ELSE
            LET p_npq06 = '1'
         END IF
         LET p_npq07 = p_npq07 * -1
         LET p_npq07f= p_npq07f* -1 
      END IF
      #No.TQC-AB0069  --End
      RETURN p_npq06,p_npq07,p_npq07f
   END IF
   IF l_aag06 = '1' AND p_npq06 = '1' OR 
      l_aag06 = '2' AND p_npq06 = '2' THEN
      RETURN p_npq06,p_npq07,p_npq07f
   END IF
   IF p_npq06 = '1' THEN
      LET p_npq06 = '2'
   ELSE
      LET p_npq06 = '1'
   END IF
   LET p_npq07 = p_npq07 * -1
   LET p_npq07f= p_npq07f* -1
  
   RETURN p_npq06,p_npq07,p_npq07f
END FUNCTION
#No.FUN-A30077  --End  
#No.FUN-A40033 --Begin
FUNCTION t110_gen_diff()
DEFINE l_aaa   RECORD LIKE aaa_file.*
DEFINE l_npq1           RECORD LIKE npq_file.*
DEFINE l_sum_cr         LIKE npq_file.npq07
DEFINE l_sum_dr         LIKE npq_file.npq07
  DEFINE l_aag44       LIKE aag_file.aag44    #No.FUN-D40118   Add
  DEFINE l_flag        LIKE type_file.chr1    #No.FUN-D40118   Add

   IF l_npp.npptype = '1' THEN
      LET l_sum_cr = 0
      LET l_sum_dr = 0
      CALL s_get_bookno(YEAR(l_npp.npp02)) 
           RETURNING g_flag,g_bookno1,g_bookno2
      IF g_flag = '1' THEN
         CALL cl_err(l_npp.npp02,'aoo-081',1)
         RETURN
      END IF
      LET g_bookno = g_bookno2
      SELECT * INTO l_aaa.* FROM aaa_file WHERE aaa01 = g_bookno
      SELECT SUM(npq07) INTO l_sum_dr
        FROM npq_file
       WHERE npqtype = '1'
         AND npq00 = l_npp.npp00
         AND npq01 = l_npp.npp01
         AND npq011= l_npp.npp011
         AND npqsys= l_npp.nppsys
         AND npq06 = '1'
      SELECT SUM(npq07) INTO l_sum_cr
        FROM npq_file
       WHERE npqtype = '1'
         AND npq00 = l_npp.npp00
         AND npq01 = l_npp.npp01
         AND npq011= l_npp.npp011
         AND npqsys= l_npp.nppsys
         AND npq06 = '2'
      IF l_sum_dr <> l_sum_cr THEN
         SELECT MAX(npq02)+1 INTO l_npq1.npq02
           FROM npq_file
          WHERE npqtype = '1'
            AND npq00 = l_npp.npp00
            AND npq01 = l_npp.npp01
            AND npq011= l_npp.npp011
            AND npqsys= l_npp.nppsys
        
         LET l_npq1.npqtype = l_npp.npptype
         LET l_npq1.npq00 = l_npp.npp00
         LET l_npq1.npq01 = l_npp.npp01
         LET l_npq1.npq011= l_npp.npp011
         LET l_npq1.npqsys= l_npp.nppsys
         LET l_npq1.npq25 = 1
         LET l_npq1.npq07 = l_sum_dr-l_sum_cr
         LET l_npq1.npq24 = l_aaa.aaa03                                                                                             
         IF l_npq1.npq07 < 0 THEN
            LET l_npq1.npq03 = l_aaa.aaa11
            LET l_npq1.npq07 = l_npq1.npq07 * -1
            LET l_npq1.npq06 = '1'
         ELSE
            LET l_npq1.npq03 = l_aaa.aaa12
            LET l_npq1.npq06 = '2'
         END IF
         LET l_npq1.npq07f = l_npq1.npq07
         LET l_npq1.npqlegal = g_legal
#No.FUN-AC0001 --begin                                                          
               IF cl_null(l_npq.npq35) THEN LET l_npq.npq35 = ' ' END IF        
               IF cl_null(l_npq.npq05) THEN LET l_npq.npq05 = ' ' END IF        
               IF cl_null(l_npq.npq08) THEN LET l_npq.npq08 = ' ' END IF        
#No.FUN-AC0001 --end 
         #FUN-D10065--add--str--
         CALL s_def_npq3(g_bookno,l_npq1.npq03,g_prog,l_npq1.npq01,'','')
         RETURNING l_npq1.npq04
         #FUN-D10065--add--end--
        #FUN-D40118 ---Add--- Start
         SELECT aag44 INTO l_aag44 FROM aag_file
          WHERE aag00 = g_bookno2
            AND aag01 = l_npq.npq03
         IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
            CALL s_chk_ahk(l_npq1.npq03,g_bookno2) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET l_npq1.npq03 = ''
            END IF
         END IF
        #FUN-D40118 ---Add--- End
         INSERT INTO npq_file VALUES(l_npq1.*)
         IF STATUS THEN 
            IF g_bgerr THEN
               LET g_showmsg=l_npq1.npq01,"/",l_npq1.npq011,"/",l_npq1.npq02,"/",l_npq1.npqsys,"/",l_npq1.npq00,"/",l_npq1.npqtype
               CALL s_errmsg("npq01,npq011,npq02,npqsys,npq00,npqtype",g_showmsg,"t110_gen_diff()",SQLCA.sqlcode,1)
            ELSE
               CALL cl_err3("ins","npq_file",l_npq1.npq00,l_npq1.npq01,STATUS,"","t110_gen_diff()",1)  
            END IF
            LET g_success = 'N'
         END IF
      END IF
   END IF   
END FUNCTION
