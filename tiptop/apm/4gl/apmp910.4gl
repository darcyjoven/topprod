# Prog. Version..: '5.30.06-13.03.20(00010)'     #
#
# Pattern name...: apmp910.4gl
# Descriptions...: 採購變更單發出作業
# Input parameter: 1: 採購單號
#                  2: 變更序號
# Date & Author..: 93/12/17 By Wenni
# Modify.........: 95/08/17 By Danny (UPDATE pmm03 更動序號)
# Modify...2.0 版: 95/10/18 By Danny (UPDATE pmm40 總金額)
# Modify.........: 04/07/21 By Wiky Bugno.MOD-470041 修改INSERT INTO...
# Modify.........: No.MOD-520110 05/03/03 By ching 多角拋轉
# Modify.........: No.MOD-530190 05/03/22 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式
# Modify.........: No.MOD-540172 05/05/02 By kim 修改倉,儲,批 的Default
# Modify.........: No.FUN-550089 05/05/25 By Danny  採購含稅單價
# Modify.........: No.FUN-560106 05/06/19 By Elva  新增雙單位內容
# Modify.........: No.MOD-560140 05/08/08 By Rosayu 採購變更發出新增料件回寫採購單之pmn11不可為'' or null,否則apmp550凍結處理時會判斷pmn11欄位故將無法找出
# Modify.........: No.MOD-5C0074 05/12/20 By Nicola 採購單多角拋轉
# Modify.........: No.TQC-5C0075 05/12/20 By Nicola 使用cl_cmdrun_wait
# Modify.........: No.FUN-610018 06/01/09 By ice 採購含稅單價功能調整
# Modify.........: No.FUN-570138 06/03/08 By yiting 批次背景執行
# Modify.........: No.MOD-630075 06/04/03 By pengu pmn62（替代率）應該將pmn62預設為1
# Modify.........: No.FUN-640012 06/04/07 By kim GP3.0 匯率參數功能改善
# Modify.........: No.MOD-640484 06/04/17 By Claire 加強各錯誤訊息的顯示
# Modify.........: No.FUN-640201 06/04/18 By Claire 錯誤訊息修改為中文顯示
# Modify.........: No.FUN-660129 06/06/19 By cl cl_err --> cl_err3
# Modify.........: No.FUN-670061 06/07/17 By kim GP3.5 利潤中心
# Modify.........: NO.FUN-670007 06/08/08 BY yiting 三角拋轉不成功時，發出碼要為N
# Modify.........: NO.FUN-630026 06/08/08 BY rainy 未有應付資料的收貨/入庫資料均詢問是否同步修改單價資料
#                                                  已有應付資料的直接顯示訊息不可同步修改單價資料
# Modify.........: No.FUN-680136 06/09/07 By Jackho 欄位類型修改
# Modfiy.........: No.CHI-690043 06/11/21 By Sarah pmn_file增加pmn90(取出單價),INSERT INTO pmn_file前要增加LET pmn90=pmn31
# Modify.........: NO.FUN-670007 06/11/28 by yiting 三角代採流程從第0站開始
# Modify.........: NO.CHI-680014 06/12/04 by rainy INSERT INTO pmn_file 時，要對 pmn88/pmn88t處理
# Modify.........: NO.FUN-690129 06/12/05 by rainy 請購單號/項次(pnb90/91)要轉入採購單
# Modify.........: No.MOD-690092 06/12/07 By Claire稅前、含稅總金額取值方式同apmt540
# Modify.........: No.MOD-6A0045 06/12/07 By Claire多角貿易採購正拋會當掉
# Modify.........: No.MOD-6A0170 06/12/13 By pengu 若有更改數量或單價,應update pmn88 and pmn88t
# Modify.........: No.FUN-710030 07/01/23 By bnlent 錯誤信息匯整
# Modify.........: No.TQC-710086 07/01/23 By Ray 若有更改計價數量,應update pmn88 and pmn88t
# Modify.........: No.MOD-730011 07/03/09 By Claire 交貨日要自動算出 pmn34,pmn35 
# Modify.........: No.MOD-740444 07/04/24 By Claire 為多角貿易單據變更時,使用多角序號不使用採購單號 
# Modify.........: No.TQC-740254 07/04/25 By Nicola 價格管理判斷
# Modify.........: No.MOD-750086 07/05/17 By Claire g_success值給予恐會遭到之後的誤判
# Modify.........: No.MOD-750085 07/05/21 By Claire 調整 FUN0640201 以g_success='Y'為default
# Modify.........: No.TQC-750236 07/05/29 By Claire default pmn36=g_today 當發出成功時
# Modify.........: No.MOD-760015 07/06/05 By claire sma843價格更新參數要考慮最近單價=0
# Modify.........: No.MOD-770083 07/08/09 By claire 變更料號時,pmn09需重取值
# Modify.........: No.MOD-770034 07/08/09 By claire 調整條件語法
# Modify.........: No.TQC-780096 07/08/31 By rainy  primary key 複合key 處理 
# Modify.........: No.MOD-790013 07/09/04 By claire 有勾稽請購及採購時(sma32)當新增項次時, 要對請購單(pml16,pmk25)做'2',刪除時pml16='1'
# Modify.........: No.MOD-790092 07/09/17 By claire 發出時再確認採購單項次是否已結案(不為發出)
# Modify.........: No.MOD-730044 07/09/18 By claire 需考慮採購單位與料件採購資料的採購單位換算
# Modify.........: No.MOD-7A0174 07/10/26 By Carol 異動單價回寫收貨/入庫時應同時更新金額
# Modify.........: No.TQC-7B0134 07/11/26 By wujie 在采購單入庫后，進行價格變更，點擊“采購發出”功能鈕，彈出警告信息（apm-959)采購單（原始交貨/到廠／到庫日期）更新失敗，不能發出變更采購單
# Modify.........: No.MOD-780229 07/12/18 By pengu 更新請購單上的已轉改夠量時應考慮請購與採購單位的轉換率
# Modify.........: No.MOD-830092 08/03/12 By claire 更新請購單時,未考慮採購單來源
# Modify.........: No.FUN-830132 08/03/28 By hellen 行業別表拆分INSERT/DELETE
# Modify.........: No.FUN-840006 08/04/07 By hellen 項目管理，去掉預算編號相關欄位 pmn66
# Modify.........: No.MOD-840555 08/04/22 By claire 調整 MOD-830092
# Modify.........: No.MOD-850033 08/05/05 By claire 調整call axmp801的語法
# Modify.........: No.MOD-850262 08/05/27 By Smapmin 變更單價時,是否更改收貨/入庫資料依入庫單是否立帳為依據
# Modify.........: No.CHI-860042 08/07/22 By xiaofeizhu 加入一般采購和委外采購的判斷
# Modify.........: No.MOD-890011 08/09/02 By Smapmin 修改幣別位數取位
# Modify.........: No.FUN-870117 08/09/22 By jan 增加pmnilsk01 的處理
# Modify.........: No.FUN-890100 08/09/22 By hongmei 服飾業加入pnbislk01a,pnbislk01b制單號的發放邏輯
# Modify.........: No.MOD-8A0019 08/10/03 By Smapmin 回寫收貨/入庫金額時,取位有誤
# Modify.........: No.FUN-8A0086 08/10/17 By baofei  完善FUN-710050的錯誤匯總的修改
# Modify.........: No.MOD-8B0052 08/11/06 By sherry  變更數量時沒有回寫oeb28
# Modify.........: No.MOD-8B0062 08/11/10 By Smapmin 只修改品名時,無法回寫採購單
# Modify.........: No.MOD-8B0111 08/11/12 By Smapmin 回寫入庫金額時,若有存在已立帳單據不允許回寫,應該要將作廢AP單據排除
# Modify.........: No.MOD-8B0273 08/11/28 By chenyu 單價含稅時，未稅單價=未稅金額/計價數量
# Modify.........: No.MOD-8C0070 08/12/09 By Smapmin 更新ima53時要考慮sma114
# Modify.........: No.MOD-930089 09/03/09 By rainy 同時變更單頭幣別及單身單價時，是以新的單價*舊幣別回寫最近採購近價，應以新的單價*新的幣別回寫
# Modify.........: No.MOD-930271 09/03/27 By Smapmin 抓取請購單資料時,未考慮採購單來源
# Modify.........: No.MOD-940208 09/04/14 By chenyu 新增采購單項次的時候，沒有考慮料號是否保稅，直接給N
# Modify.........: No.MOD-940071 09/04/14 By Smapmin 於發出段再次檢核不可小於已收貨量
# Modify.........: No.MOD-940338 09/04/24 By Smapmin 稅率沒有抓到導致金額被清空
# Modify.........: No.TQC-950010 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring()  
# Modify.........: No.MOD-950229 09/05/26 By Smapmin 修改原來就存在的採購單資料時,pmm21/pmm43資料要重抓
# Modify.........: No.MOD-960355 09/06/30 By Smapmin 若有料件單位換算錯誤者, 卻仍可作採購單發出, 造成原發單處未變更,且多地亦未變更.
# Modify.........: No.MOD-960025 09/06/30 By Smapmin 修正MOD-730044
# Modify.........: No.MOD-970168 09/07/23 By Sabrina 更改pmn44取位設定，由azi04改抓azi03
# Modify.........: No.FUN-960130 09/08/21 By Sunyanchun 流通零售必要欄位賦值
# Modify.........: No.FUN-980006 09/08/21 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-980183 09/08/26 By xiaofeizhu 還原MOD-8B0273修改的內容
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980092 09/09/17 By TSD.Martin GP5.2 跨資料庫語法修改
# Modify.........: No.MOD-990199 09/09/29 By Smapmin 若有修改採購單幣別,單身的金額要重新計算,因為要重新取位的關係
# Modify.........: No.CHI-960033 09/10/10 By chenmoyan 加pmh22為條件者，再加pmh23=''
# Modify.........: No.FUN-9B0016 09/10/31 By sunyanchun post no
# Modify.........: No.TQC-9B0203 09/11/24 By douzh pmn58為NULL時賦初始值0
# Modify.........: No:MOD-9C0158 09/12/21 By Dido 若為apm-057詢問為多角時,應各站也需重新拋轉 
# Modify.........: No:FUN-9C0071 10/01/14 By huangrh 精簡程式
# Modify.........: No:TQC-A20018 10/02/05 By lilingyu call p801()第二個參數應該傳g_pmm.pmm905
# Modify.........: No:MOD-A20089 10/02/23 By Smapmin 變更發出後如果該請購單項次已結案，不應更新狀況碼pml16
# Modify.........: No:FUN-A30056 10/04/13 By Carrier call p801时,给是否IN TRANSACTION标志位
# Modify.........: No:MOD-A50191 10/05/30 By Smapmin 未將請購單的專案相關欄位帶到採購單
# Modify.........: No:CHI-A40022 10/06/03 By Summer 採購變更單沒變更單價,就不回寫ima_file相關的單價欄位
# Modify.........: No:MOD-A60039 10/06/08 By Smapmin 修正MOD-940208
# Modify.........: No:TQC-A70004 10/07/14 By yinhy pmn_file新增前補上 IF pmn012 IS NULL THEN LET pmn012=一個空格 
# Modify.........: No.FUN-A50102 10/07/20 By vealxu 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:MOD-A50209 10/07/27 By Smapmin 延續MOD-9C0158的修改
# Modify.........: No:MOD-A60114 10/07/27 By Smapmin 修正MOD-A50209
# Modify.........: No:MOD-A70123 10/07/27 By Smapmin 修正MOD-9C0158
# Modify.........: No:MOD-A70130 10/07/27 By Smapmin 數量不可小於已收貨量,要排除樣品的已收貨量
# Modify.........: No:FUN-A80142 10/09/03 By lilingyu 採購單變更改良
# Modify.........: No:MOD-A90026 10/09/13 By Smapmin 採購變更換料時，若庫存單位不同不會更新pmn08庫存單位
# Modify.........: No:MOD-AB0015 10/11/04 By Smapmin 回寫收貨/入庫/倉退單價時,日期大於成會關帳日才回寫
# Modify.........: No:TQC-AB0398 10/12/04 By lixh1   產生的pmn資料，vmi採購pmn89欄位賦值
# Modify.........: No:MOD-AC0332 10/12/27 By lilingyu 採購變更單單頭幣別更改後,變更發出,採購單的單身本幣單價pmn44沒有一起變化
# Modify.........: No:MOD-B10185 11/01/24 By Summer pmn44未依幣別取位
# Modify.........: No:FUN-B30211 11/03/30 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:MOD-B60113 11/06/15 By Summer 先判斷料號是否變更,再判斷單價是否變更
# Modify.........: No:CHI-B50016 11/07/07 By Summer 採購變更單Blanket PO數量控卡與回寫 
# Modify.........: No:MOD-B80242 11/08/31 By johung 採購發出變更的料號不存在pmh_file時需新增至pmh_file
#                                                   修正r.c2不過的錯誤
# Modify.........: No:MOD-B90060 11/09/08 By johung ima53/ima531更新後依本國幣取位
# Modify.........: No:CHI-B60078 11/10/11 By Summer 若採購變更有變更單價,雖有重拋收貨入庫段,但未更新最終站出貨單 
# Modify.........: No:FUN-BB0084 11/11/22 By lixh1 增加數量欄位小數取位
# Modify.........: No:FUN-910088 12/02/01 By chenjing 增加數量欄位小數取位
# Modify.........: No:FUN-C10002 12/02/02 By bart 作業編號pmn78帶預設值
# Modify.........: No:MOD-BA0091 12/02/09 By Summer 新增項次回寫採購單時,無法自動帶入內編母體料號 
# Modify.........: No:MOD-C30285 12/03/12 By linlin MISC料件變更交貨日，其到廠及到庫日期被清空
# Modify.........: No:MOD-C30568 12/03/12 By Vampire 在寫入pmh_file時，是取變更前料號
# Modify.........: No.TQC-C30173 12/03/14 By lixiang 服飾流通行業下變更單的處理(變更數量)
# Modify.........: No.MOD-C30372 12/03/15 By yuhuabao 更改單位轉率抓不到的報錯方式
# Modify.........: No:MOD-BB0264 12/06/07 By Vampire 在update pon21時,先抓取原本的pon21的值減掉變更前訂購量,再加上變更後數量
# Modify.........: No:MOD-C30823 12/06/11 By Vampire 透過採購變更單不會回寫到採購單的請購單號項次，不會回寫請購單狀況碼、轉採購量
# Modify.........: No:MOD-C40011 12/06/11 By Vampire WHERE條件請增加工單單號,ecm01=pmn41
# Modify.........: No:MOD-C80116 12/08/15 By SunLM  對pmn13超/短交限率,進行賦值
# Modify.........: No:MOD-C80164 12/09/17 By jt_chen 調整採購單變更單,採購變更發出,apm-411的控卡應再扣除退貨換貨量(pmn58)
# Modify.........: No:MOD-CA0214 12/11/26 By jt_chen 判斷變更前後請購單號、項次不同時,變更前請購單也須回寫已轉採購量與狀況碼
# Modify.........: No:MOD-CB0248 12/12/06 By jt_chen 增加判斷,排除項次為0的情況
# Modify.........: No:CHI-C30096 12/12/13 By Sakura 多角代採買為最終供應商，且最末站對供應商的採購單如果做採購變更單價時，
#                                                   應該要回寫前面幾站的訂單、採購單單價
# Modify.........: No.FUN-C30315 13/01/09 By Nina 只要程式有UPDATE ima_file 的任何一個欄位時,多加imadate=g_today
# Modify.........: No.FUN-C40009 13/01/10 By Nina 只要程式有UPDATE pmh_file 的任何一個欄位時,多加pmhdate=g_today
# Modify.........: No.TQC-D10083 13/01/22 By xianghui UPDATE pmm_file處去掉pmhdate字段
# Modify.........: No:MOD-CC0264 13/01/31 By jt_chen 新增時，增加判斷是否為委外採購單；(一般採購pmh22為1,委外pmh22為2)
# Modify.........: No:MOD-CC0122 13/02/01 By Elise (1) 計算pmn88及pmn88t的公式與apmt540不同,差在MOD-B10138|CHI-AC0016這兩張單的調整
#                                                  (2) p910_upd_sopo() 為多角才須進入，調整 IF 判斷式  
# Modify.........: No:MOD-CB0197 13/02/01 By Elise 調整為判斷變更單的,變更後有值則抓變更後的,變更後沒有值則抓變更前
# Modify.........: No:MOD-D20124 13/03/11 By Elise 採購變更單新增項次時，應先判斷是否有變更幣別，再依幣別計算 pmn88/pmn88t。
# Modify.........: No:MOD-D60153 13/06/19 By SunLM 调整CHI-C30096错误 or---> and
# Modify.........: No:TQC-D70073 13/07/22 By SunLM 临时表p801_file，且都链接了sapmp801，应该在临时表创建时同步新增一个栏位so_price2
# Modify.........: No:MOD-D70165 13/07/24 By SunLM  調用SUB函數對pmn13超/短交限率,進行賦值
# Modify.........: No:MOD-DB0141 13/11/21 By SunLM 应该使用出货单项次作为where更新条件

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
        g_argv1       LIKE pna_file.pna01,  # 採購單號
        g_argv2       LIKE pna_file.pna02,  # 變更序號
        g_pna01       LIKE pna_file.pna01,  # 採購單號
        g_pna02       LIKE pna_file.pna02,  # 變更序號
        g_pna04       LIKE pna_file.pna04,  # 變更日期
        g_pna08b      LIKE pna_file.pna08b, # NO:7203
        g_pna10b      LIKE pna_file.pna10b, #
        g_pna09b      LIKE pna_file.pna09b, #
        g_pna11b      LIKE pna_file.pna11b, #
        g_pna12b      LIKE pna_file.pna12b, #
        g_pmm09       LIKE pmm_file.pmm09,  # 供應廠商
        g_pmm22       LIKE pmm_file.pmm22,  # 幣別
        g_pmm42       LIKE pmm_file.pmm42,  # 匯率
        g_pmm21       LIKE pmm_file.pmm21,  # FUN-610018
        g_gec07       LIKE gec_file.gec07,  # 單價含稅否  #No.MOD-8B0273 add
        g_gec05       LIKE gec_file.gec05,  # 發票聯數    #MOD-CC0122 add
        g_pmm43       LIKE pmm_file.pmm43,  # 稅率 BugNo.7259
        g_pnb03       LIKE pnb_file.pnb03,  # 採購單項次
        g_pnb04b      like pnb_file.pnb04b, # 變更前料號  #mod-730011 add
        g_pnb04a      LIKE pnb_file.pnb04a, # 變更後料號
        g_pnb041a     LIKE pnb_file.pnb041a,# 變更後品名規格
        g_pnb07a      LIKE pnb_file.pnb07a, # 變更後單位
        g_pnb07b      LIKE pnb_file.pnb07b, # 變更前單位
        g_pnb83b      LIKE pnb_file.pnb83b, # 變更前單位二
        g_pnb83a      LIKE pnb_file.pnb83a, # 變更後單位二
        g_pnb84b      LIKE pnb_file.pnb84b, # 變更前單位二轉換率
        g_pnb84a      LIKE pnb_file.pnb84a, # 變更後單位二轉換率
        g_pnb85b      LIKE pnb_file.pnb85b, # 變更前單位二數量
        g_pnb85a      LIKE pnb_file.pnb85a, # 變更後單位二數量
        g_pnb80b      LIKE pnb_file.pnb80b, # 變更前單位一
        g_pnb80a      LIKE pnb_file.pnb80a, # 變更後單位一
        g_pnb81b      LIKE pnb_file.pnb81b, # 變更前單位一轉換率
        g_pnb81a      LIKE pnb_file.pnb81a, # 變更後單位一轉換率
        g_pnb82b      LIKE pnb_file.pnb82b, # 變更前單位一數量
        g_pnb82a      LIKE pnb_file.pnb82a, # 變更後單位一數量
        g_pnb86b      LIKE pnb_file.pnb86b, # 變更前計價單位
        g_pnb86a      LIKE pnb_file.pnb86a, # 變更後計價單位
        g_pnb87b      LIKE pnb_file.pnb87b, # 變更前計價數量
        g_pnb87a      LIKE pnb_file.pnb87a, # 變更後計價數量
        g_pnb20a_old  LIKE pnb_file.pnb20a, # 變更後訂購量
        g_pnb20b      LIKE pnb_file.pnb20b, # 變更前訂購量
        g_pnb20a      LIKE pnb_file.pnb20a, # 變更後訂購量
        g_pnb31b      LIKE pnb_file.pnb31b, # 變更前單價
        g_pnb31a      LIKE pnb_file.pnb31a, # 變更後單價
        g_pnb32a      LIKE pnb_file.pnb32a, # 變更後單價    No.FUN-550089
        g_pnb32b      LIKE pnb_file.pnb32b, # 變更前單價    No.FUN-550089
        g_qty         LIKE rvb_file.rvb87,  #MOD-7A0174-add
        g_amt         LIKE rvb_file.rvb87,  #MOD-7A0174-add
        g_amtt        LIKE rvb_file.rvb88,  #MOD-7A0174-add
        g_pnb33b      LIKE pnb_file.pnb33b, # 變更前原始交貨日期
        g_pnb33a      LIKE pnb_file.pnb33a, # 變更後原始交貨日期
        g_pnb90       LIKE pnb_file.pnb90,  # 請購單號  #FUN-690129
        g_pnb91       LIKE pnb_file.pnb91,  # 請購單序號 #FUN-690129
        g_pnb90b      LIKE pnb_file.pnb90,  # 變更前單號    #MOD-CA0214
        g_pnb91b      LIKE pnb_file.pnb91,  # 變更前項次    #MOD-CA0214
        g_pnbislk01b  LIKE pnbi_file.pnbislk01b, #No.FUN-870117 #No.FUN-890100
        g_pnbislk01a  LIKE pnbi_file.pnbislk01a, #No.FUN-870117 #No.FUN-890100
        g_ima53       LIKE ima_file.ima53,  # 最近採購單價(本幣)
        g_ima531      LIKE ima_file.ima531, # 市價(本幣)
        g_ima532      LIKE ima_file.ima532, # 市價最近異動日期
        g_ima44       LIKE ima_file.ima44,  #MOD-730044 #採購單位  
        g_ima908      LIKE ima_file.ima908, #MOD-730044 #計價單位  
        g_pmn31       LIKE pmn_file.pmn31,
        g_pmn31t      LIKE pmn_file.pmn31t, # BugNo.7259
        l_pmn09       LIKE pmn_file.pmn09,  # 97-03-21 add
        l_pmn44       LIKE pmn_file.pmn44,  # 97-03-21 add
        l_pmn08       LIKE pmn_file.pmn08,
        l_pmn011      LIKE pmn_file.pmn011,
         g_wc          string,  #No.FUN-580092 HCN
         g_sql         string    #No.FUN-580092 HCN
DEFINE   g_cnt        LIKE type_file.num10   #No.FUN-680136 INTEGER
DEFINE  g_pmm         RECORD LIKE pmm_file.*
DEFINE  g_cmd         LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(600)
DEFINE  l_flag        LIKE type_file.chr1     #No.FUN-570138  #No.FUN-680136 VARCHAR(1)
DEFINE  l_flag3       LIKE type_file.chr1,    #MOD-9C0158
        g_data        LIKE type_file.chr1,    #MOD-750085 add
        g_change_lang LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(01)               #No.FUN-570138 是否有做語言切換
        ls_date       STRING,                 #No.FUN-570138
        #-----MOD-A50209---------
        g_oga         DYNAMIC ARRAY OF RECORD
          dbs         LIKE type_file.chr21,  
          plant       LIKE type_file.chr21,   #MOD-B80242 add  
          oga01       LIKE oga_file.oga01   
                      END RECORD,
        g_dbs_old     LIKE type_file.chr21,
        #-----END MOD-A50209-----
        g_rvu         DYNAMIC ARRAY OF RECORD   #MOD-A70123
          rvu01       LIKE rvu_file.rvu01       #MOD-A70123
                      END RECORD                #MOD-A70123
DEFINE l_dbs_tra       LIKE type_file.chr21       #FUN-980092 
DEFINE l_plant_new     LIKE type_file.chr21       #FUN-980092 
DEFINE g_pnb34a        LIKE pnb_file.pnb34a       #FUN-A80142
DEFINE g_pnb35a        LIKE pnb_file.pnb35a       #FUN-A80142
DEFINE g_pnb36a        LIKE pnb_file.pnb36a       #FUN-A80142
DEFINE g_pnb20a_new    LIKE pnb_file.pnb20a     #MOD-BB0264 add
 
MAIN
 DEFINE l_rvu01       LIKE rvu_file.rvu01                   #MOD-9C0158
 #-----MOD-A50209---------
 DEFINE l_poz011      LIKE poz_file.poz011,
        l_poy04       LIKE poy_file.poy04,
        l_dbs         LIKE type_file.chr21,
        l_rvu99       LIKE rvu_file.rvu99,
        l_sql         STRING,
        l_oga01       LIKE oga_file.oga01,
        l_i           LIKE type_file.num5
 #-----END MOD-A50209-----
 DEFINE l_plant  LIKE type_file.chr21               #FUN-A50102 

   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   LET g_argv1 =ARG_VAL(1)             #採購單號
   LET g_argv2 =ARG_VAL(2)             #變更序號
   LET g_wc     = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob= "N"
   END IF

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   INITIALIZE g_bgjob_msgfile TO NULL
 
   IF NOT cl_null(g_argv1) THEN LET g_pna01=g_argv1 END IF
   IF NOT cl_null(g_argv2) THEN LET g_pna02=g_argv2 END IF
 
   IF cl_null(g_argv1) THEN
      WHILE TRUE
         IF g_bgjob= "N" THEN
            CALL p910_tm()
            IF cl_sure(18,20) THEN
               CALL p901_call_p801_init()  #No.FUN-A30056
               BEGIN WORK
               LET g_success = 'Y'   #MOD-750085 add
               CALL p910_p1()
               CALL p910_upd_pmm()
               #若無傳入值時
               CALL s_showmsg()    #No.FUN-710030
               IF g_success = 'Y' THEN
                  COMMIT WORK
                  CALL p910_apmp832_apmp822()   #MOD-A70123
                  CALL p910_axmp901_axmp900()   #MOD-A50209
                  CALL cl_end2(1) RETURNING l_flag
               ELSE
                  ROLLBACK WORK
                  CALL cl_end2(2) RETURNING l_flag
               END IF
               IF l_flag THEN
                  CONTINUE WHILE
               ELSE
                  CLOSE WINDOW p910_w
                  EXIT WHILE
               END IF
            ELSE
               CONTINUE WHILE
            END IF
            CLOSE WINDOW p910_w
         ELSE
            CALL p901_call_p801_init()  #No.FUN-A30056
            BEGIN WORK
            LET g_success = 'Y'   #MOD-750085 
            CALL p910_p1()
            CALL p910_upd_pmm()
            CALL s_showmsg()    #No.FUN-710030
            IF g_success = "Y" THEN
               COMMIT WORK
               CALL p910_apmp832_apmp822()   #MOD-A70123
               CALL p910_axmp901_axmp900()   #MOD-A50209
            ELSE
               ROLLBACK WORK
            END IF
            CALL cl_batch_bg_javamail(g_success)
            EXIT WHILE
         END IF
      END WHILE
    ELSE
      CALL cl_load_act_sys(NULL)  #FUN-630026
      SELECT   pna01,  pna02,  pna04,  pna08b,  pna10b,pna09b  ,  pna11b,  pna12b,  pmm09,  pmm22,  pmm42
        INTO g_pna01,g_pna02,g_pna04,g_pna08b,g_pna10b,g_pna09b,g_pna11b,g_pna12b,g_pmm09,g_pmm22,g_pmm42
        FROM pna_file,pmm_file
       WHERE pna01=g_argv1  # 採購單號
         AND pna02=g_argv2  # 採購變更序號
         AND pna01= pmm01   # 採購單號
         AND pna05 ='Y'
         AND pmm18 !='X'
         AND pnaconf != 'Y' #NO:7203
      CALL p901_call_p801_init()  #No.FUN-A30056
      BEGIN WORK
      LET g_success = 'Y'
      CALL s_showmsg_init()    #No.FUN-8A0086 
      CALL g_rvu.clear()   #MOD-A70123
      CALL g_oga.clear()   #MOD-A60114
      CALL p910_update_rtn()
      SELECT * INTO g_pmm.* FROM pmm_file WHERE pmm01 = g_pna01
      #若為代採三角貿易採購單重新拋轉
      IF g_pmm.pmm02 = 'TAP' AND g_pmm.pmm901 = 'Y' AND g_success='Y' THEN   #MOD-960355
        #CALL p801(g_pmm.pmm01,g_pmm.pmm901)  #TQC-A20018 
        #CALL p801(g_pmm.pmm01,g_pmm.pmm905)  #TQC-A20018  #No.FUN-A30056       
         CALL p801(g_pmm.pmm01,g_pmm.pmm905,TRUE)          #No.FUN-A30056
         IF l_flag3 = 1 THEN 
            #-----MOD-A50209--------- 
            LET l_poz011 = ''
            SELECT poz011 INTO l_poz011 FROM poz_file
              WHERE poz01 = g_pmm.pmm904   
            IF l_poz011 = '1' THEN 
            #-----END MOD-A50209----- 
               DECLARE rvu2_curs CURSOR FOR    
                 SELECT rvu01 FROM rvb_file,rva_file,rvu_file 
                  WHERE rvb04 = g_pna01 and rvb03 = g_pnb03 and rva01 = rvb01 and rvb01 = rvu02 
               LET l_i = 1   #MOD-A70123
               FOREACH rvu2_curs INTO l_rvu01    #入庫單號
                  #-----MOD-A70123---------
                  #LET g_cmd="apmp832 '",l_rvu01,"'"
                  #CALL cl_cmdrun_wait(g_cmd CLIPPED)
                  #LET g_cmd="apmp822 '",l_rvu01,"'"
                  #CALL cl_cmdrun_wait(g_cmd CLIPPED)
                  LET g_rvu[l_i].rvu01 = l_rvu01
                  LET l_i = l_i + 1 
                  #-----END MOD-A70123-----
               END FOREACH 
               CALL g_rvu.deleteElement(l_i)   #MOD-A70123
            #-----MOD-A50209---------
            ELSE
               LET l_poy04 = ''
               SELECT poy04 INTO l_poy04 FROM poy_file
                 WHERE poy01 = g_pmm.pmm904 
                   AND poy02 IN (SELECT MAX(poy02) FROM poy_file
                                   WHERE poy01 = g_pmm.pmm904
                                     AND poy02 <> '99')
               LET l_dbs = ''
               SELECT azp03 INTO l_dbs FROM azp_file 
                WHERE azp01 = l_poy04
               LET l_plant = l_poy04                 #FUN-A50102 add 
               DECLARE rvu2_curs_2 CURSOR FOR
                 SELECT rvu99 FROM rvb_file,rva_file,rvu_file
                  WHERE rvb04 = g_pna01 and rvb03 = g_pnb03 and rva01 = rvb01 and rvb01 = rvu02
               #CALL g_oga.clear()   #MOD-A60114
               LET l_i = 1
               FOREACH rvu2_curs_2 INTO l_rvu99   
                # LET l_sql = "SELECT oga01 FROM ",s_dbstring(l_dbs),"oga_file ",           #FUN-A50102 mark
                  LET l_sql = "SELECT oga01 FROM ",cl_get_target_table(l_plant,'oga_file'), #FUN-A50102                                                 
                              " WHERE oga99 = '",l_rvu99,"'"                                                                         
	          CALL cl_replace_sqldb(l_sql) RETURNING l_sql		
                  CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql          #FUN-A50102 add
                  PREPARE oga_pre_2 FROM l_sql                                                                                         
                  LET l_oga01 = ''
                  EXECUTE oga_pre_2 INTO l_oga01                                                                                         
                  LET g_oga[l_i].dbs = l_dbs
                  LET g_oga[l_i].plant = l_plant   #MOD-B80242 add
                  LET g_oga[l_i].oga01 = l_oga01
                  LET l_i = l_i + 1 
               END FOREACH
               CALL g_oga.deleteElement(l_i)
            END IF
            #-----END MOD-A50209-----
         END IF
         CALL p910_chk_pmm03()
      END IF
      CALL p910_upd_pmm()
      CALL s_showmsg()    #No.FUN-710030
      IF g_success = "Y" THEN
         COMMIT WORK
         CALL p910_apmp832_apmp822()   #MOD-A70123
         CALL p910_axmp901_axmp900()   #MOD-A50209
      ELSE
         ROLLBACK WORK
      END IF
  END IF

   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #NO.FUN-570138
END MAIN
 
 
FUNCTION p910_tm()
 DEFINE lc_cmd        LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(500)            #No.FUN-570138
 
   OPEN WINDOW p910_w WITH FORM "apm/42f/apmp910"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
 
   WHILE TRUE
      IF s_shut(0) THEN RETURN END IF
      CLEAR FORM
      CALL cl_opmsg('q')
      ERROR ""
 
      CONSTRUCT BY NAME g_wc ON pna01,pna04
 
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
        ON ACTION locale                    #genero
           LET g_change_lang = TRUE                  #NO.FUN-570138
           EXIT CONSTRUCT
 
        ON ACTION exit              #加離開功能genero
           LET INT_FLAG = 1
           EXIT CONSTRUCT
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END CONSTRUCT
 
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p910_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
 
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pnauser', 'pnagrup')
 
      LET g_bgjob = "N"          #->No.FUN-570138
      INPUT BY NAME g_bgjob WITHOUT DEFAULTS
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
       ON ACTION about         #BUG-4C0121
          CALL cl_about()      #BUG-4C0121
 
       ON ACTION help          #BUG-4C0121
          CALL cl_show_help()  #BUG-4C0121
          CALL cl_show_help()  #BUG-4C0121
 
 
        ON ACTION exit  #加離開功能genero
           LET INT_FLAG = 1
           EXIT INPUT
 
     END INPUT
 
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLOSE WINDOW p910_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     END IF
     IF g_bgjob = "Y" THEN
        SELECT zz08 INTO lc_cmd FROM zz_file
         WHERE zz01 = "apmp910"
        IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
           CALL cl_err('apmp910','9031',1) 
        ELSE
           LET g_wc=cl_replace_str(g_wc, "'", "\"")  #"
           LET lc_cmd = lc_cmd CLIPPED,
                        " '' ",
                        " '' ",
                        " '",g_wc CLIPPED ,"'",
                        " '",g_bgjob CLIPPED,"'"
           CALL cl_cmdat('apmp910',g_time,lc_cmd CLIPPED)
        END IF
        CLOSE WINDOW p910_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     END IF
   EXIT WHILE
END WHILE
 
END FUNCTION
 
FUNCTION p910_p1()
 DEFINE l_rvu01       LIKE rvu_file.rvu01                   #MOD-9C0158
 #-----MOD-A50209---------
 DEFINE l_poz011      LIKE poz_file.poz011,
        l_poy04       LIKE poy_file.poy04,
        l_dbs         LIKE type_file.chr21,
        l_rvu99       LIKE rvu_file.rvu99,
        l_sql         STRING,
        l_oga01       LIKE oga_file.oga01,
        l_i           LIKE type_file.num5
 #-----END MOD-A50209-----
 DEFINE l_plant       LIKE type_file.chr21           #FUN-A50102 add

      LET g_sql="SELECT pna01,pna02,pna04,pna08b,pna10b,pna09b,pna11b,pna12b,pmm09,pmm22,pmm42 ",   #No.FUN-610018
                "  FROM pna_file , pmm_file",
                " WHERE pna01 = pmm01 ",
                "   AND pna05 ='Y' ",    # 採購單號
                "   AND pnaconf IN ('N','n') ",          # 未發出
                "   AND pmm18 !='X' ",
                "   AND ", g_wc CLIPPED,
                " ORDER BY pna01"
      PREPARE p910_pr1 FROM g_sql
      IF sqlca.sqlcode THEN
         CALL cl_err('prepare1:',SQLCA.SQLCODE,1)
         LET g_success='N'   #TQC-750236 add
         RETURN              #TQC-750236 add 
      END IF
      DECLARE p910_cs1 CURSOR WITH HOLD FOR p910_pr1
      IF sqlca.sqlcode THEN
         CALL cl_err('declare:',SQLCA.SQLCODE,1)
         LET g_success='N'   #TQC-750236 add
         RETURN              #TQC-750236 add 
      END IF
      CALL cl_opmsg('z')
      CALL s_showmsg_init()     #No.FUN-710030
      CALL g_rvu.clear()   #MOD-A70123
      CALL g_oga.clear()   #MOD-A60114
      LET g_data = 'N'   #MOD-750085 add
      FOREACH p910_cs1 #INTO g_pna01,g_pna02,g_pna04,g_pmm09,g_pmm22,g_pmm42
                        INTO g_pna01,g_pna02,g_pna04,g_pna08b,g_pna10b,g_pna09b,g_pna11b,g_pna12b,g_pmm09,g_pmm22,g_pmm42
            IF g_success='N' THEN                                                                                                        
            LET g_totsuccess='N'                                                                                                      
            LET g_success="Y"                                                                                                         
            END IF                                                                                                                       
 
           IF SQLCA.SQLCODE THEN
              CALL s_errmsg('','','p910_cs1:',SQLCA.SQLCODE,0)
              LET g_totsuccess = 'N'   #MOD-750085 add
              EXIT FOREACH
           END IF
           CALL p910_update_rtn()
           IF  g_success = 'N' THEN RETURN END IF #TQC-750236 add
 
           SELECT * INTO g_pmm.* FROM pmm_file WHERE pmm01 = g_pna01
           #若為代採三角貿易採購單重新拋轉
           IF g_pmm.pmm02 = 'TAP' AND g_pmm.pmm901 = 'Y' THEN
             #CALL p801(g_pmm.pmm01,g_pmm.pmm901)  #TQC-A20018
             #CALL p801(g_pmm.pmm01,g_pmm.pmm905)  #TQC-A20018  #No.FUN-A30056  
              CALL p801(g_pmm.pmm01,g_pmm.pmm905,TRUE)          #No.FUN-A30056
              IF l_flag3 = 1 THEN 
                 #-----MOD-A50209--------- 
                 LET l_poz011 = ''
                 SELECT poz011 INTO l_poz011 FROM poz_file
                   WHERE poz01 = g_pmm.pmm904   
                 IF l_poz011 = '1' THEN 
                 #-----END MOD-A50209----- 
                    DECLARE rvu1_curs CURSOR FOR    
                      SELECT rvu01 FROM rvb_file,rva_file,rvu_file 
                       WHERE rvb04 = g_pna01 and rvb03 = g_pnb03 and rva01 = rvb01 and rvb01 = rvu02 
                    LET l_i = 1   #MOD-A70123
                    FOREACH rvu1_curs INTO l_rvu01    #入庫單號
                       #-----MOD-A70123---------
                       #LET g_cmd="apmp832 '",l_rvu01,"'"
                       #CALL cl_cmdrun_wait(g_cmd CLIPPED)
                       #LET g_cmd="apmp822 '",l_rvu01,"'"
                       #CALL cl_cmdrun_wait(g_cmd CLIPPED)
                       LET g_rvu[l_i].rvu01 = l_rvu01
                       LET l_i = l_i + 1 
                       #-----END MOD-A70123-----
                    END FOREACH 
                    CALL g_rvu.deleteElement(l_i)   #MOD-A70123
                 #-----MOD-A50209---------
                 ELSE
                    LET l_poy04 = ''
                    SELECT poy04 INTO l_poy04 FROM poy_file
                      WHERE poy01 = g_pmm.pmm904 
                        AND poy02 IN (SELECT MAX(poy02) FROM poy_file
                                        WHERE poy01 = g_pmm.pmm904
                                          AND poy02 <> '99')
                    LET l_dbs = ''
                    SELECT azp03 INTO l_dbs FROM azp_file 
                     WHERE azp01 = l_poy04
                    LET l_plant = l_poy04                     #FUN-A50102 add
                    DECLARE rvu2_curs_3 CURSOR FOR
                      SELECT rvu99 FROM rvb_file,rva_file,rvu_file
                       WHERE rvb04 = g_pna01 and rvb03 = g_pnb03 and rva01 = rvb01 and rvb01 = rvu02
                    #CALL g_oga.clear()   #MOD-A60114
                    LET l_i = 1
                    FOREACH rvu2_curs_3 INTO l_rvu99   
                     # LET l_sql = "SELECT oga01 FROM ",s_dbstring(l_dbs),"oga_file ",            #FUN-A50102 mark
                       LET l_sql = "SELECT oga01 FROM ",cl_get_target_table(l_plant,'oga_file'),  #FUN-A50102 add                                                  
                                   " WHERE oga99 = '",l_rvu99,"'"                                                                         
	               CALL cl_replace_sqldb(l_sql) RETURNING l_sql		
                       CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql                       #FUN-A50102
                       PREPARE oga_pre_3 FROM l_sql                                                                                         
                       LET l_oga01 = ''
                       EXECUTE oga_pre_3 INTO l_oga01                                                                                         
                       LET g_oga[l_i].dbs = l_dbs
                       LET g_oga[l_i].oga01 = l_oga01
                       LET l_i = l_i + 1 
                    END FOREACH
                    CALL g_oga.deleteElement(l_i)
                 END IF
                 #-----END MOD-A50209-----
              END IF
              CALL p910_chk_pmm03()
           END IF
           LET g_data = 'Y'   #MOD-750085 add
     END FOREACH
     IF g_data <> 'Y' THEN 
        LET g_success ='N' 
        CALL cl_err('',STATUS,1)
     END IF 
          IF g_totsuccess="N" THEN                                                                                                         
              LET g_success="N"                                                                                                             
          END IF                                                                                                                           
 
END FUNCTION
 
FUNCTION p910_update_rtn()
  DEFINE
         l_pnb03   LIKE pnb_file.pnb03,   # 採購單項次
         l_pmn04   LIKE pmn_file.pmn04,   # 料件編號
         l_pmn09   LIKE pmn_file.pmn09,   # 轉換因子
         l_pmn43   LIKE pmn_file.pmn43,   #No.TQC-740254
         l_pmn44   LIKE pmn_file.pmn44,   # 本幣單價
         l_pmn35   LIKE pmn_file.pmn35,   # 原始到庫日期
         l_pmn50   LIKE pmn_file.pmn50,   # 交貨量
         l_ima37   LIKE ima_file.ima37,   # 補貨策略碼
         l_sql     LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(900)
         l_pmm     RECORD LIKE pmm_file.*,
         l_pmn16   LIKE pmn_file.pmn16,   # 單身狀況碼  #MOD-790092 add
         l_cnt     LIKE type_file.num5   #FUN-630026  #No.FUN-680136 SMALLINT
  DEFINE l_rvb01   LIKE rvb_file.rvb01
  DEFINE l_rvb02   LIKE rvb_file.rvb02
  DEFINE l_rvv01   LIKE rvv_file.rvv01
  DEFINE l_rvv02   LIKE rvv_file.rvv02
  DEFINE l_flag2   LIKE type_file.chr1
  DEFINE l_rvb07   LIKE rvb_file.rvb07   #MOD-940071
  DEFINE l_pmn02   LIKE pmn_file.pmn02,
         l_pmn87   LIKE pmn_file.pmn87,
         l_pmn31   LIKE pmn_file.pmn31,
         l_pmn31t  LIKE pmn_file.pmn31t,
         l_azi04   LIKE azi_file.azi04,
         l_azi03   LIKE azi_file.azi03,   #MOD-CC0122 add
         l_tot     LIKE pmn_file.pmn88,
         l_tott    LIKE pmn_file.pmn88t
  DEFINE l_rva06   LIKE rva_file.rva06,   #MOD-AB0015
         l_rvu03   LIKE rvu_file.rvu03    #MOD-AB0015
  DEFINE l_pmn68   LIKE pmn_file.pmn68    #MOD-BB0264 add
  DEFINE l_pmn69   LIKE pmn_file.pmn69    #MOD-BB0264 add
  DEFINE l_pmn62   LIKE pmn_file.pmn62    #MOD-BB0264 add
  DEFINE l_pmn70   LIKE pmn_file.pmn70    #MOD-BB0264 add
  DEFINE l_pmn70a  LIKE pmn_file.pmn70    #MOD-BB0264 add
  DEFINE l_pon21   LIKE pon_file.pon21    #MOD-BB0264 add
  DEFINE l_pon07   LIKE pon_file.pon07    #MOD-BB0264 add
  DEFINE l_flag    LIKE type_file.num5    #MOD-BB0264 add
  DEFINE l_pmn41   LIKE pmn_file.pmn41    #MOD-C40011 add
  DEFINE l_pmn04chk LIKE pmn_file.pmn04   #MOD-CB0197 add
 
   IF g_success = 'N'  THEN
      RETURN  
   END IF 
    IF g_bgjob = 'N' THEN
       MESSAGE 'update:',g_pna01,'-',g_pna02
    END IF
 
   {ckp#1}
   #==>更改採購變更單單頭:未發出--->已發出
     UPDATE pna_file SET pnaconf = 'Y'
      WHERE pna01 = g_pna01  # 採購單號
        AND pna02 = g_pna02  # 變更序號
         IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
            LET g_success = 'N'
            CALL cl_err3("upd","pna_file",g_pna01,g_pna02,"apm-950","","",1)  #No.FUN-660129
            RETURN
         END IF
   #單頭變更
   SELECT * INTO l_pmm.*
     FROM pmm_file
    WHERE pmm01 = g_pna01

   #MOD-CC0122 add start -----
   SELECT gec07,gec05 INTO g_gec07,g_gec05
       FROM gec_file
      WHERE gec01 = l_pmm.pmm21
        AND gec011='1'  #進項
   IF SQLCA.sqlcode THEN               
      LET g_success = 'N'
      CALL cl_err3("sel","gec_file","","",SQLCA.sqlcode,"","",1) 
      RETURN
   END IF
   #MOD-CC0122 add end  -----

   #幣別
   IF NOT cl_null(g_pna08b) THEN
       LET l_pmm.pmm22 = g_pna08b
       IF g_aza.aza17 = l_pmm.pmm22 THEN   #本幣
           LET l_pmm.pmm42 = 1
       ELSE
           CALL s_curr3(l_pmm.pmm22,l_pmm.pmm04,g_sma.sma904) #FUN-640012
                RETURNING l_pmm.pmm42
       END IF
       DECLARE p910_cur1 CURSOR FOR
          SELECT pmn02,pmn87,pmn31,pmn31t
            FROM pmn_file
           WHERE pmn01 = g_pna01
       FOREACH p910_cur1 INTO l_pmn02,l_pmn87,l_pmn31,l_pmn31t
         #SELECT azi04 INTO l_azi04 FROM azi_file               #MOD-CC0122 mark
          SELECT azi03,azi04 INTO l_azi03,l_azi04 FROM azi_file #MOD-CC0122 add
            WHERE azi01 = g_pna08b 
          LET l_tot = cl_digcut(l_pmn87 * l_pmn31,l_azi04)
          LET l_tott= cl_digcut(l_pmn87 * l_pmn31t,l_azi04)
          #MOD-CC0122 add start -----
          SELECT pmm43 INTO g_pmm43 FROM pmm_file WHERE pmm01=g_pna01
          IF g_gec07 = 'N' THEN
             LET l_tott = l_tot * ( 1 + g_pmm43/100)
             LET l_tott = cl_digcut(l_tott,l_azi04)
          ELSE
             IF g_gec05 = 'T' THEN
                LET l_pmn31  = l_pmn31t* ( 1 - g_pmm43/100)
                LET l_pmn31  = cl_digcut(l_pmn31,l_azi03)
                LET l_tot  = l_tott * ( 1 - g_pmm43/100)
                LET l_tot  = cl_digcut(l_tot,l_azi04)
             ELSE
                LET l_tot  = l_tott / ( 1 + g_pmm43/100)
                LET l_tot  = cl_digcut(l_tot,l_azi04)
             END IF
          END IF
          #MOD-CC0122 add end   -----
          UPDATE pmn_file SET pmn88  = l_tot,
                              pmn88t = l_tott
               WHERE pmn01 = g_pna01
                 AND pmn02 = l_pmn02
          IF SQLCA.sqlcode THEN
             LET g_success = 'N'
             CALL cl_err3("upd","pmn_file",g_pna01,l_pmn02,SQLCA.sqlcode,"","",1) 
             RETURN
          END IF
       END FOREACH
   END IF
   LET g_pmm42 = l_pmm.pmm42   #MOD-930089 add
   #MOD-B10185 add --start--
   DECLARE p910_cur3 CURSOR FOR
          SELECT pmn02,pmn31 
            FROM pmn_file
           WHERE pmn01 = g_pna01
   FOREACH p910_cur3 INTO l_pmn02,l_pmn31
      LET l_pmn44=cl_digcut(l_pmn31*g_pmm42,g_azi03) 
      UPDATE pmn_file SET pmn44 = l_pmn44 
       WHERE pmn01 = g_pna01
         AND pmn02 = l_pmn02
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         CALL cl_err3("upd","pmn_file",g_pna01,l_pmn44,SQLCA.sqlcode,"","",1)
         RETURN
      END IF
   END FOREACH
   #MOD-B10185 add --end--

#MOD-B10185 mark --start--
##MOD-AC0332 --begin--
#   UPDATE pmn_file SET pmn44 = pmn31 * g_pmm42
#    WHERE pmn01 = g_pna01
##MOD-AC0332 --end--
#MOD-B10185 mark --end--

   #付款條件
   IF NOT cl_null(g_pna10b) THEN
       LET l_pmm.pmm20 = g_pna10b
       SELECT pma06
         INTO l_pmm.pmm46
         FROM pma_file
        WHERE pma01 = l_pmm.pmm20
   END IF
   IF NOT cl_null(g_pna09b) THEN LET l_pmm.pmm41 = g_pna09b END IF #價格條件
   IF NOT cl_null(g_pna11b) THEN LET l_pmm.pmm10 = g_pna11b END IF #送貨地址
   IF NOT cl_null(g_pna12b) THEN LET l_pmm.pmm11 = g_pna12b END IF #發票地址
   UPDATE pmm_file
      SET pmm10 = l_pmm.pmm10,
          pmm11 = l_pmm.pmm11,
          pmm20 = l_pmm.pmm20,
          pmm22 = l_pmm.pmm22,
          pmm41 = l_pmm.pmm41,
          pmm42 = l_pmm.pmm42,
          pmm43 = l_pmm.pmm43,
          pmm46 = l_pmm.pmm46
    WHERE pmm01 = g_pna01
   IF SQLCA.sqlcode THEN
       LET g_success = 'N'
       CALL cl_err3("upd","pmm_file",g_pna01,"","apm-951","","",1)  #No.FUN-660129
       RETURN
   END IF
   #單身變更
   DECLARE p910_cur2 CURSOR FOR
                 SELECT pnb07a,pnb07b,pnb04a,pnb041a,
                        pnb03,pnb20b,pnb20a,pnb31a,pnb31b,
                        pnb33a,pnb33b,pnb32a,pnb32b,          #No.FUN-550089
                        pnb80a,pnb80b,pnb81a,pnb81b,pnb82a,pnb82b,
                        pnb83a,pnb83b,pnb84a,pnb84b,pnb85a,pnb85b,
                        pnb86a,pnb86b,pnb87a,pnb87b,pnb90,pnb91   #FUN-690129 add 90/91
                        ,pnb04b   #MOD-730011 modify 
                       ,pnb34a,pnb35a,pnb36a          #FUN-A80142 add 
                   FROM pnb_file
                  WHERE pnb01 = g_pna01 AND pnb02 = g_pna02
   FOREACH p910_cur2 INTO g_pnb07a,g_pnb07b,g_pnb04a,g_pnb041a,
                          g_pnb03,g_pnb20b,g_pnb20a,g_pnb31a,g_pnb31b,
                          g_pnb33a,g_pnb33b,g_pnb32a,g_pnb32b,  #No.FUN-550089
                          g_pnb80a,g_pnb80b,g_pnb81a,g_pnb81b,g_pnb82a,g_pnb82b,
                          g_pnb83a,g_pnb83b,g_pnb84a,g_pnb84b,g_pnb85a,g_pnb85b,
                          g_pnb86a,g_pnb86b,g_pnb87a,g_pnb87b,g_pnb90,g_pnb91     #FUN-690129 add 90/91
                          ,g_pnb04b  #MOD-730011 modify   
                         ,g_pnb34a,g_pnb35a,g_pnb36a       #FUN-A80142 add 
   IF s_industry('slk') THEN
     SELECT pnbislk01a,pnbislk01b INTO g_pnbislk01a,g_pnbislk01b
       FROM pnbi_file
      WHERE pnbi01 = g_pna01 AND pnbi02 = g_pna02 AND pnbi03 = g_pnb03
   END IF
   IF g_success='N' THEN                                                                                                        
      LET g_totsuccess='N'                                                                                                      
      LET g_success="Y"                                                                                                         
   END IF                                                                                                                       
 
   IF SQLCA.SQLCODE THEN
      LET g_success = 'N'
      CALL s_errmsg('','','Foreach p910_cur2 :',SQLCA.SQLCODE,1)
      EXIT FOREACH
   END IF
   
   SELECT pmn24,pmn25 INTO g_pnb90b,g_pnb91b                                       #MOD-CA0214 add 取得目前該採購單變更前的請購單號、項次
     FROM pmn_file WHERE pmn01 = g_pna01 AND pmn02 = g_pnb03                       #MOD-CA0214 add

   SELECT pmn16 INTO l_pmn16
     FROM pmn_file
    WHERE pmn01 = g_pna01
      AND pmn02 = g_pnb03
      IF l_pmn16 != '2' THEN
         LET g_success = 'N'
         CALL cl_err(g_pnb03,'apm-222',1)
         RETURN 
      END IF
 
   #==>不可小於已收貨量(rvb07)(不管是否已確認)
   SELECT SUM(rvb07-rvb29-pmn58) INTO l_rvb07 FROM rvb_file,rva_file,pmn_file   #MOD-C80164 add -pmn58、pmn_file   
    WHERE rvb01 = rva01
      AND rvaconf != 'X'
      AND rvb04 = g_pna01
      AND rvb03 = g_pnb03
      AND rvb35 = 'N'   #MOD-A70130
      AND rvb04 = pmn01 #MOD-C80164 add
      AND rvb03 = pmn02 #MOD-C80164 add
   IF g_pnb20a < l_rvb07 THEN
       LET g_success = 'N'
       CALL s_errmsg('','',l_rvb07,'apm-411',1)
       RETURN
   END IF
   SELECT pmn04,pmn09,pmn31,pmn31t,pmn44,pmn35,pmn50,pmn43,pmn68,pmn69,pmn62,pmn70,pmn41                #No.FUN-550089   #No.TQC-740254 #MOD-BB0264 pmn68,pmn69,pmn62,pmn70 #MOD-C40011 add pmn41
     INTO l_pmn04,l_pmn09,g_pmn31,g_pmn31t,l_pmn44,l_pmn35,l_pmn50,l_pmn43,l_pmn68,l_pmn69,l_pmn62,l_pmn70,l_pmn41  #No.FUN-550089   #No.TQC-740254i #MOD-BB0264 l_pmn68,l_pmn69,l_pmn62,l_pmn70 #MOD-C40011 add l_pmn41
     FROM pmn_file
    WHERE pmn01=g_pna01 AND pmn02 =g_pnb03
 
     #判斷若為新增的項次,則變更前的值為NULL modi by kitty
   IF status=100 THEN
     IF cl_null(g_pnb20b) THEN LET g_pnb20b=0 END IF
     IF cl_null(g_pnb82b) THEN LET g_pnb82b=0 END IF
     IF cl_null(g_pnb85b) THEN LET g_pnb85b=0 END IF
     IF cl_null(g_pnb31b) THEN LET g_pnb31b=0 END IF
     IF cl_null(g_pnb32b) THEN LET g_pnb32b=0 END IF    #No.FUN-550089
     LET l_pmn04 = g_pnb04a
     LET l_pmn50 = 0
     LET l_pmn35 = g_pna04
     LET g_pmn31 = g_pnb31a
     LET g_pmn31t= g_pnb32a         #No.FUN-550089
     #---取庫存單位
     SELECT ima25 INTO l_pmn08 FROM ima_file WHERE ima01=g_pnb04a
     #---取採購性質,請購單號,預算編號
     SELECT pmm02 INTO l_pmn011 FROM pmm_file
      WHERE pmm01=g_pna01
     #---取換算率
     CALL s_umfchk(g_pnb04a,g_pnb07a,l_pmn08) RETURNING l_flag,l_pmn09
     IF l_flag=1 THEN
         ### ------單位換算率抓不到------#####
#        CALL s_errmsg('pmm01','g_pna01','pnb07a/pmn08: ','abm-731',1)           #MOD-C30372 mark
         LET g_showmsg = g_pna01,"/",g_pnb03                                     #MOD-C30372 add
         CALL s_errmsg('pmm01,pnb03',g_showmsg,'pnb07a/pmn08: ','abm-731',1)     #MOD-C30372 add
         LET g_success ='N'
     END IF
 #判斷如單價有變更，則(1)如未轉應付則詢問是否同步變更收貨/入庫資料
 #                    (2)如已轉應付，則直接顯示訊息不可同步變更收貨/入庫資料
    ELSE
      IF NOT cl_null(g_pnb31a) AND g_pnb31a <> g_pnb31b THEN 
        DECLARE rva_curs CURSOR FOR    
          SELECT rvb01,rvb02 FROM rvb_file 
            WHERE rvb04 = g_pna01 AND rvb03 = g_pnb03
        FOREACH rva_curs INTO l_rvb01,l_rvb02    #收貨單號-項次
          DECLARE rvv_curs CURSOR FOR
            SELECT rvv01,rvv02 FROM rvv_file
              WHERE rvv04 = l_rvb01 AND rvv05 = l_rvb02 
          LET l_flag2 = 0 
          FOREACH rvv_curs INTO l_rvv01,l_rvv02  #入庫單號-項次
            LET l_cnt = 0 
            SELECT COUNT(*) INTO l_cnt FROM apb_file,apa_file
               WHERE apa01=apb01 AND apb21 = l_rvv01 AND apb22 = l_rvv02
                 AND apa42 <> 'Y'
            IF l_cnt > 0 THEN  #有應付資料
               LET g_showmsg = l_rvv01,"/",l_rvv02
               CALL s_errmsg('apb21,apb22',g_showmsg,'','apm-058',1)   #MOD-8B0111
               LET l_flag2 = 1
            END IF
          END FOREACH
          IF l_flag2 = 0 THEN 
             IF cl_confirm('apm-057') THEN
                SELECT azi04 INTO t_azi04 FROM azi_file     
                 WHERE azi01 = l_pmm.pmm22    #MOD-8A0019   g_pmm.pmm22-->l_pmm.pmm22
                   AND aziacti= 'Y'  #原幣
                LET g_qty = 0
                LET g_amt = 0
                LET g_amtt = 0
                SELECT rvb87 INTO g_qty FROM rvb_file
                 WHERE rvb01 = l_rvb01  
                   AND rvb02 = l_rvb02
                IF cl_null(g_qty) THEN LET g_qty = 0 END IF
                LET g_amt = cl_digcut(g_pnb31a * g_qty,t_azi04)
                LET g_amtt= cl_digcut(g_pnb32a * g_qty,t_azi04) 
                IF cl_null(g_amt) THEN LET g_amt = 0 END IF
                IF cl_null(g_amtt) THEN LET g_amtt = 0 END IF
                #-----MOD-AB0015---------
                LET l_rva06 = NULL
                SELECT rva06 INTO l_rva06 FROM rva_file
                  WHERE rva01 = l_rvb01
                IF l_rva06 > g_sma.sma53 THEN
                #-----END MOD-AB0015-----
                    UPDATE rvb_file SET rvb10  = g_pnb31a,
                                        rvb10t = g_pnb32a,   
                                        rvb88  = g_amt,        
                                        rvb88t = g_amtt        
                      WHERE rvb01 = l_rvb01  
                        AND rvb02 = l_rvb02
                    IF SQLCA.SQLCODE THEN
                       LET g_showmsg = l_rvb01,"/",l_rvb02
                       CALL s_errmsg('rvb01,rvb02',g_showmsg,'Update rvb10 Error',SQLCA.SQLCODE,0)
                       LET g_success='N'
                    END IF
                #-----MOD-AB0015---------
                ELSE
                   LET g_showmsg = l_rvb01
                   CALL s_errmsg('rvb01',g_showmsg,'','apm1050',1)
                END IF
                #-----END MOD-AB0015-----
                FOREACH rvv_curs INTO l_rvv01,l_rvv02
                   LET g_qty = 0
                   LET g_amt = 0
                   LET g_amtt = 0
                   SELECT rvv87 INTO g_qty FROM rvv_file
                    WHERE rvv01 = l_rvv01  
                      AND rvv02 = l_rvv02
                   IF cl_null(g_qty) THEN LET g_qty = 0 END IF
                   LET g_amt = cl_digcut(g_pnb31a * g_qty,t_azi04)
                   LET g_amtt= cl_digcut(g_pnb32a * g_qty,t_azi04) 
                   IF cl_null(g_amt) THEN LET g_amt = 0 END IF
                   IF cl_null(g_amtt) THEN LET g_amtt = 0 END IF
                   #-----MOD-AB0015---------
                   LET l_rvu03 = NULL
                   SELECT rvu03 INTO l_rvu03 FROM rvu_file
                     WHERE rvu01 = l_rvv01
                   IF l_rvu03 > g_sma.sma53 THEN
                   #-----END MOD-AB0015-----
                      UPDATE rvv_file SET rvv38  = g_pnb31a,
                                          rvv38t = g_pnb32a,      
                                          rvv39  = g_amt,         
                                          rvv39t = g_amtt         
                       WHERE rvv01 = l_rvv01 
                         AND rvv02 = l_rvv02
                      IF SQLCA.SQLCODE THEN
                         LET g_showmsg = l_rvv01,"/",l_rvv02
                         CALL s_errmsg('rvv01,rvv02',g_showmsg,'Update rvv38 Error',SQLCA.SQLCODE,0)
                         LET g_success='N'
                      END IF
                      LET l_flag3 = 1      #MOD-9C0158
                   #-----MOD-AB0015---------
                   ELSE
                      LET g_showmsg = l_rvv01
                      CALL s_errmsg('rvv01',g_showmsg,'','apm1051',1)
                   END IF
                   #-----END MOD-AB0015-----
                END FOREACH
             END IF
          END IF
        END FOREACH 
      END IF
    END IF
 
    #MOD-CB0197 add start -----
    IF cl_null(g_pnb04a) THEN
       LET l_pmn04chk = g_pnb04b
    ELSE
       LET l_pmn04chk = g_pnb04a
    END IF
    #MOD-CB0197 add end   -----

   SELECT ima53,ima531,ima532,ima37
     INTO g_ima53,g_ima531,g_ima532,l_ima37
     FROM ima_file
   #WHERE ima01=l_pmn04    #MOD-CB0197 mark
    WHERE ima01=l_pmn04chk #MOD-CB0197 add
    #---計算金額及本幣單價
    LET l_pmn44=cl_digcut(g_pnb31a*g_pmm42,g_azi03)     #MOD-970168 add
 
      #為期間採購料件更新最近期間採購日期
      IF NOT cl_null(g_pnb04a) OR l_pmn04 != g_pnb04a THEN
         IF l_ima37 = '5' THEN # 補貨策略為期間採購
               UPDATE ima_file SET ima881 = l_pmn35,
                                   imadate = g_today     #FUN-C30315 add
               WHERE ima01 = g_pnb04a
               IF SQLCA.SQLERRD[3] = 0 THEN
                  LET g_success = 'N'
                  CALL s_errmsg('ima01','g_pnb04a','Update#1 ima881 Error','apm-952',0)
                  CONTINUE FOREACH
               END IF
            ELSE                   #表新增項次,以此次單據日期為採購日96-05-16
               IF g_pnb04a[1,4] <> 'MISC'
                  THEN
                  UPDATE ima_file SET ima881 = g_pna04,
                                      imadate = g_today     #FUN-C30315 add
                  WHERE ima01 = g_pnb04a
                  IF SQLCA.SQLERRD[3] = 0 THEN
                     LET g_success = 'N'
                     CALL s_errmsg('ima01','g_pnb04a','Update#1.1 ima881 Error','apm-952',0)
                     CONTINUE FOREACH
                  END IF
               END IF
            END IF
      END IF
      #MOD-BB0264 ----- add start -----   
      IF NOT cl_null(l_pmn68) THEN
         SELECT pon07 INTO l_pon07 FROM pon_file WHERE pon01 = l_pmn68 AND pon02 = l_pmn69
       
         IF cl_null(g_pnb07a) THEN
            LET g_pnb07a = g_pnb07b
         END IF
      
         CALL s_umfchk(g_pnb90,g_pnb07a,l_pon07) RETURNING l_flag,l_pmn70a
      
         IF l_flag THEN
            CALL cl_err(g_pnb07a,'abm-731',1) #單位換算率抓不到
            LET g_success = 'N'
            CONTINUE FOREACH
         END IF
      
         SELECT pon21 INTO l_pon21 FROM pon_file
          WHERE pon01 = l_pmn68 AND pon02 = l_pmn69
         LET g_pnb20a_new = l_pon21 - (g_pnb20b/l_pmn62*l_pmn70) + (g_pnb20a/l_pmn62*l_pmn70a)
      END IF
      #MOD-BB0264 ----- add end  -----
       LET g_pnb20a_old = g_pnb20a
      #-->modify by kitty 96/04/18
       IF g_pnb20a IS NULL OR g_pnb20a = '' THEN LET g_pnb20a=g_pnb20b END IF
       IF g_pnb82a IS NULL OR g_pnb82a = '' THEN LET g_pnb82a=g_pnb82b END IF
       IF g_pnb85a IS NULL OR g_pnb85a = '' THEN LET g_pnb85a=g_pnb85b END IF
      #-->料件編號,變更前訂購量,在外量,供應廠商,採購單項次
       #CALL up_price(l_pmn04,l_pmn50,l_pmn43)   #No.TQC-740254 #MOD-C40011 mark
       CALL up_price(l_pmn04,l_pmn50,l_pmn43,l_pmn41)   #MOD-C40011 add
       IF g_success = 'N' THEN EXIT FOREACH END IF
#CHI-C30096---add---START
       SELECT * INTO g_pmm.* FROM pmm_file WHERE pmm01 = g_pna01
       #IF (g_pmm.pmm02 <> 'TRI' OR g_pmm.pmm02 <> 'TAP')  AND g_pmm.pmm901 = 'Y' THEN #MOD-D60153 mark
       IF (g_pmm.pmm02 <> 'TRI' AND g_pmm.pmm02 <> 'TAP')  AND g_pmm.pmm901 = 'Y' THEN #MOD-D60153 add  
          CALL p910_upd_sopo()
          IF g_success = 'N' THEN EXIT FOREACH END IF
       END IF
#CHI-C30096---add-----END
   END FOREACH
          IF g_totsuccess="N" THEN                                                                                                         
              LET g_success="N"                                                                                                             
          END IF                                                                                                                           
 
END FUNCTION
 
#FUNCTION up_price(p_part,p_pmn50,p_pmn43)   #No.TQC-740254 #MOD-C40011 mark
FUNCTION up_price(p_part,p_pmn50,p_pmn43,p_pmn41) #MOD-C40011 add
   DEFINE
      p_part       LIKE pmn_file.pmn04,   # 料件編號
      p_qty        LIKE pnb_file.pnb20b,  # 變更前數量
      p_price      LIKE pmn_file.pmn31,   # 本幣單價
      pt_price     LIKE pmn_file.pmn31t,  # 本幣含稅單價  FUN-610018
      p_pmn50      LIKE pmn_file.pmn50,   # 交貨量
      p_pmn43      LIKE pmn_file.pmn43,   #No.TQC-740254
      l_ecm04      LIKE ecm_file.ecm04,   #No.TQC-740254
      p_pmm09      LIKE pmm_file.pmm09,   # 供應廠商
      p_pnb03      LIKE pnb_file.pnb03,   # 採購單項次
      l_new        LIKE pmn_file.pmn31,   # 更新後 Price
      lt_new       LIKE pmn_file.pmn31,   # 更新後 Tax Price FUN-610018
      l_curr       LIKE pmm_file.pmm22,   #No.FUN-680136 VARCHAR(4)          # 更新後 Currency
      l_date       LIKE type_file.dat,     #No.FUN-680136 DATE
      l_qty        LIKE ima_file.ima31_fac,#No.FUN-680136 DEC(16,8)
      l_qty_o      LIKE ima_file.ima31_fac,#MOD-CA0214 變更前
      l_pmn07      LIKE pmn_file.pmn07,      #採購單位
      l_unitrate   LIKE pmn_file.pmn121,  
      l_sw         LIKE type_file.num10,               
      l_rate       LIKE pmm_file.pmm42,
      l_pml21      LIKE pml_file.pml21,   #No.+401 add
      l_pml21_o    LIKE pml_file.pml21,   #MOD-CA0214 add
      l_pmn24      LIKE pmn_file.pmn24,
      l_pmn25      LIKE pmn_file.pmn25,
      l_pmn04      LIKE pmn_file.pmn04,
      l_pmn121     LIKE pmn_file.pmn121,
      l_flag       LIKE type_file.chr1,
      l_pmm42      LIKE pmm_file.pmm42,
      l_pml09      LIKE pml_file.pml09,
      l_pmh12      LIKE pmh_file.pmh12,   # 最近採購單價(本幣)
      l_pmh17      LIKE pmh_file.pmh17,   #No.FUN-610018
      l_pmh18      LIKE pmh_file.pmh18,   #No.FUN-610018
      l_pmh19      LIKE pmh_file.pmh19,   #No.FUN-610018
      ln_pmh17     LIKE pmh_file.pmh17,   #No.FUN-610018
      ln_pmh18     LIKE pmh_file.pmh18,   #No.FUN-610018
      l_pmh13      LIKE pmh_file.pmh13,   # 採購幣別
      l_pmh14      LIKE pmh_file.pmh14,   # 匯率
      l_price1     LIKE ima_file.ima53,   # 最近採購單價(本幣)
      l_price2     LIKE ima_file.ima531,  # 市價(本幣)
      l_ima35      LIKE ima_file.ima35,   #MOD-540172
      l_ima36      LIKE ima_file.ima36,   #MOD-540172
      l_pmn        RECORD LIKE pmn_file.*, #MOD-540172
      l_pml07      LIKE pml_file.pml07,    #FUN-690129
      l_ima49      LIKE ima_file.ima49,    #MOD-730011
      l_ima491     LIKE ima_file.ima491,   #MOD-730011
      l_pnb04      LIKE pnb_file.pnb04a,   #MOD-770083 add
      l_pnb07      LIKE pnb_file.pnb07a,   #MOD-770083 add
      l_tot        LIKE pmn_file.pmn44    #MOD-8A0019
   DEFINE l_pmni   RECORD LIKE pmni_file.* #No.FUN-830132
   DEFINE l_pmh24  LIKE pmh_file.pmh24     #TQC-AB0398
   DEFINE l_pmc914 LIKE pmc_file.pmc914    #TQC-AB0398
   DEFINE l_pmn68  LIKE pmn_file.pmn68 #CHI-B50016 add
   DEFINE l_pmn69  LIKE pmn_file.pmn69 #CHI-B50016 add
   DEFINE l_pmh    RECORD LIKE pmh_file.*  #MOD-B80242 add
   DEFINE l_ima926 LIKE ima_file.ima926    #MOD-B80242 add
   DEFINE l_oeb05  LIKE oeb_file.oeb05     #FUN-BB0084
   DEFINE l_pmnslk02  LIKE pmnslk_file.pmnslk02   #TQC-C30173 add
   DEFINE l_pmnslk04  LIKE pmnslk_file.pmnslk04   #TQC-C30173 add
   DEFINE l_pmnslk20  LIKE pmnslk_file.pmnslk20   #TQC-C30173 add
   DEFINE l_pmnslk88  LIKE pmnslk_file.pmnslk88   #TQC-C30173 add
   DEFINE l_pmnslk88t LIKE pmnslk_file.pmnslk88t #TQC-C30173 add
   DEFINE l_cnt    LIKE type_file.num5     #MOD-C30823 add
   DEFINE l_pml16  LIKE pml_file.pml16     #MOD-C30823 add
   DEFINE p_pmn41  LIKE pmn_file.pmn41     #MOD-C40011 add
   DEFINE l_ima07  LIKE ima_file.ima07     #MOD-C80116 add
   DEFINE l_pmm22  LIKE pmm_file.pmm22     #MOD-D20124 add
 
   LET l_price1 =0
   LET l_price2 =0
 
   IF p_pmn43 = 0 OR cl_null(p_pmn43) THEN
      LET l_ecm04 = " "
   ELSE
      SELECT ecm04 INTO l_ecm04 FROM ecm_file
       WHERE ecm03 = p_pmn43
         AND ecm01 = p_pmn41 #MOD-C40011 add
   END IF
 
   IF (NOT cl_null(g_pnb31a) AND g_pnb31a != g_pnb31b OR
       NOT cl_null(g_pnb32a) AND g_pnb32a != g_pnb32b) THEN  # 變更單價  FUN-610018
      LET p_price = g_pnb31a   # 變更後的單價
      LET pt_price = g_pnb32a  # 變更後的單價  FUN-610018
   ELSE
      LET p_price = g_pnb31b   # 變更前的單價
      LET pt_price = g_pnb32b  # 變更前的單價  FUN-610018
   END IF
 
   IF (NOT cl_null(g_pnb31a) AND g_pnb31a != g_pnb31b OR                        
       NOT cl_null(g_pnb32a) AND g_pnb32a != g_pnb32b OR     # 變更單價  
       NOT cl_null(g_pnb86a) AND g_pnb86a != g_pnb86b ) THEN # 變更單位  
        LET l_pmn07 = g_pnb86b
        IF NOT cl_null(l_pmn07) THEN 
         IF NOT cl_null(g_pnb86a) THEN 
           LET l_pmn07 = g_pnb86a
         END IF 
        END IF 
        IF g_pnb04a[1,4] <> 'MISC' AND NOT cl_null(g_pnb04a) AND p_part != g_pnb04a THEN # 有變更料號
           SELECT ima44,ima908 INTO g_ima44,g_ima908 FROM ima_file
             WHERE ima01=g_pnb04a
        ELSE
           SELECT ima44,ima908 INTO g_ima44,g_ima908 FROM ima_file
             WHERE ima01=p_part
        END IF
        IF cl_null(g_ima908) THEN LET g_ima908 = g_ima44  END IF
        IF g_sma.sma116 MATCHES '[13]' THEN   
           LET g_ima44 = g_ima908
        END IF   
        IF NOT cl_null(l_pmn07) AND l_pmn07 <> g_ima44 THEN
           LEt l_unitrate = 1
           IF g_pnb04a[1,4] <> 'MISC' AND NOT cl_null(g_pnb04a) AND p_part != g_pnb04a THEN # 有變更料號
              CALL s_umfchk(g_pnb04a,l_pmn07,g_ima44)  
                RETURNING l_sw,l_unitrate
           ELSE
              CALL s_umfchk(p_part,l_pmn07,g_ima44)  
                RETURNING l_sw,l_unitrate
           END IF
           IF l_sw THEN
              #單位換算率抓不到 ---#
#              CALL cl_err(p_part,'abm-731',1)                                        #MOD-C30372 mark
              LET g_showmsg = g_pna01,"/",g_pnb03                                     #MOD-C30372 add
              CALL s_errmsg('pna01,pnb03',g_showmsg,'pnb07a/pmn08: ','abm-731',1)     #MOD-C30372 add
              IF NOT cl_confirm('lib-005') THEN 
                 LET g_success = 'N'
                 RETURN
              END IF
           END IF
           LET p_price  = p_price /l_unitrate
           LET pt_price = pt_price/l_unitrate
        END IF
   END IF

#MOD-B90060 -- begin --
   SELECT azi03 INTO g_azi03 FROM azi_file
      WHERE azi01 = g_aza.aza17  AND aziacti matches'[Yy]'
#MOD-B90060 -- end -- 

   SELECT pmm02 INTO l_pmn011 FROM pmm_file WHERE pmm01=g_pna01 AND pmm18 !='X'   #MOD-8C0070
 
   #-->採購單發出時,更新料件主檔最近單價方式
   CASE  g_sma.sma843
      WHEN '1'   #無條件更新
         IF l_pmn011 = 'SUB' AND
            g_sma.sma114 = 'N' THEN
            LET l_price1 = g_ima53
         ELSE
            LET l_price1 = p_price*g_pmm42
            LET l_price1 = cl_digcut(l_price1,g_azi03)   #MOD-B90060 add
         END IF   #MOD-8C0070
      WHEN '2'   #較低時更新
         IF l_pmn011 = 'SUB' AND
            g_sma.sma114 = 'N' THEN
            LET l_price1 = g_ima53
         ELSE
            IF cl_null(g_ima53) THEN
                LET g_ima53 = 0
            END IF
            IF (p_price*g_pmm42 < g_ima53) OR (g_ima53=0) THEN   #MOD-760015 modify
               LET l_price1 = p_price*g_pmm42
               LET l_price1 = cl_digcut(l_price1,g_azi03)   #MOD-B90060 add
               #-->單價為零則保持原狀況
               IF l_price1 <= 0 THEN LET l_price1 = g_ima53 END IF
            ELSE
               LET l_price1 = g_ima53
            END IF
         END IF   #MOD-8C0070
      OTHERWISE
         LET l_price1 = g_ima53
   END CASE
 
   #-->採購單發出時,更新料件主檔市價方式
   CASE  g_sma.sma844
      WHEN '1'   # 無條件更新
             LET l_price2 = p_price*g_pmm42
             LET l_price2 = cl_digcut(l_price2,g_azi03)   #MOD-B90060 add
             LET l_date   = g_today
      WHEN '2'   # 較低時更新
             IF cl_null(g_ima531) THEN
                 LET g_ima531 = 0
             END IF
             IF (p_price*g_pmm42 < g_ima531) OR (g_ima531=0) THEN   #MOD-760015 modify
                LET l_price2 = p_price*g_pmm42
                LET l_price2 = cl_digcut(l_price2,g_azi03)   #MOD-B90060 add
                LET l_date   = g_today
                IF l_price2 <=0 THEN
                   LET l_price2 = g_ima531
                   LET l_date   = g_ima532
                END IF
             ELSE
                LET l_price2 = g_ima531
                LET l_date   = g_ima532
             END IF
      OTHERWISE  #不更新
         LET l_price2 = g_ima531
         LET l_date   = g_ima532
   END CASE
   {ckp#2}
   #==>更新料件主檔
  #IF NOT cl_null(g_pnb31a) AND g_pnb31b != g_pnb31a THEN #CHI-A40022 add #MOD-B60113 mark 
   IF g_pnb04a[1,4] <> 'MISC' AND NOT cl_null(g_pnb04a) AND p_part != g_pnb04a THEN # 有變更料號
      UPDATE ima_file SET ima53  = l_price1, # 最近採購單價
                          ima531 = l_price2, # 市價
                          ima532 = l_date,   # 市價最近異動日期
                          imadate = g_today     #FUN-C30315 add
                    WHERE ima01  = g_pnb04a
      IF SQLCA.SQLERRD[3] = 0 THEN
         LET g_success = 'N'
         CALL cl_err3("upd","ima_file",g_pnb04a,"","mfg0151","","(apmp910:ckp#2)",1)  #No.FUN-660129
         RETURN
      END IF
   ELSE # 沒有變更料號
      IF NOT cl_null(g_pnb31a) AND g_pnb31b != g_pnb31a THEN #MOD-B60113 add 
         IF p_part[1,4] <> 'MISC' THEN   #No.B453 add
            UPDATE ima_file SET ima53  = l_price1, # 最近採購單價
                                ima531 = l_price2, # 市價
                                ima532 = l_date ,  # 市價最近異動日期
                                imadate = g_today     #FUN-C30315 add
             WHERE ima01 = p_part
            IF SQLCA.SQLERRD[3] = 0 THEN
               LET g_success = 'N'
               CALL cl_err3("upd","ima_file",p_part,"","mfg0151","","(apmp910:ckp#2)",1)  #No.FUN-660129
               RETURN
            END IF
         END IF   #No.B453 add
      END IF #MOD-B60113 add
   END IF
  #END IF #CHI-A40022 add #MOD-B60113 mark
  UPDATE pmm_file SET pmm03 = g_pna02
                   #  pmhdate = g_today     #FUN-C40009 add  #TQC-D10083 mark
   WHERE pmm01 = g_pna01
  IF SQLCA.SQLCODE THEN
     LET g_success = 'N'
     CALL cl_err3("upd","pmm_file",g_pna01,"",SQLCA.sqlcode,"","UPDATE pmm03",1)  #No.FUN-660129
     RETURN
  END IF
  IF SQLCA.SQLERRD[3] = 0 THEN
     LET g_success = 'N'
     CALL cl_err('(apmp910:ckp#2.3)','mfg9328',1)   #MOD-640484  #FUN-640201
     RETURN
  END IF
#------- 判斷是否為新增的序號,若是則insert,否則update -----
   IF cl_null(g_pnb04a) THEN    #原有項次變更料號資料 
    SELECT ima49,ima491 INTO l_ima49,l_ima491 FROM ima_file WHERE ima01=g_pnb04b
   ELSE 
    SELECT ima49,ima491 INTO l_ima49,l_ima491 FROM ima_file WHERE ima01=g_pnb04a
   END IF 
    LET l_pmn.pmn33 = g_pnb33a   
    LET l_pmn.pmn34 = l_pmn.pmn33 + l_ima49
    LET l_pmn.pmn35 = l_pmn.pmn34 + l_ima491
    LET l_pmn.pmn34 = l_pmn.pmn33 + l_ima49
    CALL s_wkday(l_pmn.pmn34) RETURNING l_flag,l_date
    LET l_pmn.pmn34 = l_date
    LET l_pmn.pmn35 = l_pmn.pmn34 + l_ima491
    CALL s_wkday(l_pmn.pmn35) RETURNING l_flag,l_date
    LET l_pmn.pmn35 = l_date
    LET l_pmn.pmn36 = g_today      #TQC-750236 add
  LET g_cnt=0
  SELECT COUNT(*) INTO g_cnt FROM pmn_file
   WHERE pmn01=g_pna01 AND pmn02=g_pnb03
   #MOD-C30285 add --start--
   IF cl_null(l_pmn.pmn34)   THEN
      LET  l_pmn.pmn34 = l_pmn.pmn33
    END IF
   IF cl_null(l_pmn.pmn35)   THEN
      LET  l_pmn.pmn35 = l_pmn.pmn33
   END IF
   #MOD-C30285 add --end--  
 IF g_cnt=0 THEN
  #FUN-910088--add--start--
    IF NOT cl_null(g_pnb07a) AND cl_null(g_pnb20a) THEN
       LET g_pnb20a = s_digqty(g_pnb20b,g_pnb07a)
    END IF
    IF NOT cl_null(g_pnb80a) AND cl_null(g_pnb82a) THEN
       LET g_pnb82a = s_digqty(g_pnb82a,g_pnb80a) 
    END IF
    IF NOT cl_null(g_pnb83a) AND cl_null(g_pnb85a) THEN
       LET g_pnb85a = s_digqty(g_pnb85a,g_pnb83a)
    END IF
    IF NOT cl_null(g_pnb86a) AND cl_null(g_pnb87a) THEN
       LET g_pnb87a = s_digqty(g_pnb87a,g_pnb86a)
    END IF
  #FUN-910088--add--end--
    #---取庫存單位
    SELECT ima25 INTO l_pmn08 FROM ima_file WHERE ima01=g_pnb04a
    #---取採購性質
    SELECT pmm02 INTO l_pmn011 FROM pmm_file WHERE pmm01=g_pna01 AND pmm18 !='X'
    #---取換算率
    CALL s_umfchk(g_pnb04a,g_pnb07a,l_pmn08) RETURNING l_flag,l_pmn09
    IF l_flag=1 THEN
       #### -------單位換算率抓不到-------####
#      CALL cl_err('pnb07a/pmn08: ','abm-731',1)                               #MOD-C30372 mark
       LET g_showmsg = g_pna01,"/",g_pnb03                                     #MOD-C30372 add
       CALL s_errmsg('pna01,pnb03',g_showmsg,'pnb07a/pmn08: ','abm-731',1)     #MOD-C30372 add
       LET g_success ='N'
    END IF
    #---計算本幣單價
    LET l_pmn44=cl_digcut(g_pnb31a*g_pmm42,g_azi03)     #MOD-970168 add
    SELECT pmm21,pmm43 INTO g_pmm21,g_pmm43 FROM pmm_file WHERE pmm01=g_pna01  #No.FUN-610018
    IF SQLCA.SQLCODE THEN LET g_pmm43=0.0 ELSE IF cl_null(g_pmm43) THEN
        LET g_pmm43=0.0 END
    IF END IF
    LET l_ima35=''
    LET l_ima36=''
    SELECT ima35,ima36 INTO l_ima35,l_ima36 FROM ima_file WHERE
    ima01=g_pnb04a
    LET l_pmn.pmn01 = g_pna01
    LET l_pmn.pmn011= l_pmn011
    LET l_pmn.pmn02 = g_pnb03
    LET l_pmn.pmn03 = ''
    LET l_pmn.pmn04 = g_pnb04a
    LET l_pmn.pmn041= g_pnb041a
    LET l_pmn.pmn05 = ''
    LET l_pmn.pmn06 = ''
    LET l_pmn.pmn07 = g_pnb07a
    LET l_pmn.pmn08 = l_pmn08
    LET l_pmn.pmn09 = l_pmn09
    LET l_pmn.pmn10 = ''
    LET l_pmn.pmn11 = 'N' #MOD-560140
    #-----MOD-A50191---------
    LET l_pmn.pmn122 = ''
    LET l_pmn.pmn96 = ''
    LET l_pmn.pmn97 = ''
    #SELECT pml07 INTO l_pml07 FROM pml_file
    SELECT pml07,pml12,pml121,pml122 
      INTO l_pml07,l_pmn.pmn122,l_pmn.pmn96,l_pmn.pmn97 FROM pml_file
    #-----END MOD-A50191-----
     WHERE pml01 = g_pnb90
       AND pml02 = g_pnb91
    CALL s_umfchk(l_pmn.pmn04,l_pmn.pmn07,l_pml07)
         RETURNING l_flag,l_pmn.pmn121
    IF l_flag THEN         
       LET l_pmn.pmn121=1
    END IF
    #LET l_pmn.pmn122= ''   #MOD-A50191
    LET l_pmn.pmn123= ''
    #MOD-D70165 mark beg--------
    #LET l_pmn.pmn13 = 0
    #MOD-C80116 add beg----
#    LET l_ima07=' '
#    SELECT ima07 INTO l_ima07 FROM ima_file
#     WHERE ima01=l_pmn.pmn04
#    CASE l_ima07
#         WHEN 'A' LET l_pmn.pmn13=g_sma.sma341/100
#         WHEN 'B' LET l_pmn.pmn13=g_sma.sma342/100
#         WHEN 'C' LET l_pmn.pmn13=g_sma.sma343/100
#         OTHERWISE LET l_pmn.pmn13=0
#    END CASE   	
    #MOD-C80116 add end----  
    #MOD-D70165 mark end--------
    CALL s_overate(l_pmn.pmn04) RETURNING l_pmn.pmn13  #MOD-D70165 add  
    LET l_pmn.pmn14 = 'Y'
    LET l_pmn.pmn15 = 'Y'
    LET l_pmn.pmn16 = '2'
    LET l_pmn.pmn18 = ''
    LET l_pmn.pmn20 = g_pnb20a
    LET l_pmn.pmn80 = g_pnb80a
    LET l_pmn.pmn81 = g_pnb81a
    LET l_pmn.pmn82 = g_pnb82a
    LET l_pmn.pmn83 = g_pnb83a
    LET l_pmn.pmn84 = g_pnb84a
    LET l_pmn.pmn85 = g_pnb85a
    LET l_pmn.pmn86 = g_pnb86a
    LET l_pmn.pmn87 = g_pnb87a
    LET l_pmn.pmn23 = ''
    LET l_pmn.pmn24 = g_pnb90
    LET l_pmn.pmn25 = g_pnb91
    LET l_pmn.pmn30 = 0
    LET l_pmn.pmn31 = g_pnb31a
    LET l_pmn.pmn31t= g_pnb32a                #No.FUN-550089
    LET l_pmn.pmn32 = 0
    LET l_pmn.pmn33 = g_pnb33a
    LET l_pmn.pmn38 = 'Y'
    LET l_pmn.pmn40 = ''
    LET l_pmn.pmn41 = ''
    LET l_pmn.pmn42 = '0'
    LET l_pmn.pmn43 = 0
    LET l_pmn.pmn431= 0
    LET l_pmn.pmn44 = l_pmn44
    LET l_pmn.pmn45 = 0
    LET l_pmn.pmn46 = 0
    LET l_pmn.pmn50 = 0
    LET l_pmn.pmn51 = 0
    LET l_pmn.pmn52 = l_ima35
    LET l_pmn.pmn53 = 0
    LET l_pmn.pmn54 = l_ima36
    LET l_pmn.pmn55 = 0
    LET l_pmn.pmn56 = ' '
    LET l_pmn.pmn57 = 0
    LET l_pmn.pmn58 = 0
    LET l_pmn.pmn59 = ''
    LET l_pmn.pmn60 = NULL #MOD-540172
    LET l_pmn.pmn61 = g_pnb04a
    LET l_pmn.pmn62 = 1    #No.MOD-630075 modify 
    LET l_pmn.pmn63 = 'N'
    #SELECT ima15 into l_pmn.pmn64 FROM pmn_file   #MOD-A60039
    SELECT ima15 INTO l_pmn.pmn64 FROM ima_file   #MOD-A60039
     WHERE ima01 = l_pmn.pmn04
    IF cl_null(l_pmn.pmn64) THEN
       LET l_pmn.pmn64 = 'N'
    END IF
    LET l_pmn.pmn65 = '1'
    LET l_pmn.pmn67 = ''
    LET l_pmn.pmn68 = ''
    LET l_pmn.pmn69 = ''
    LET l_pmn.pmn70 = NULL #MOD-540172
    LET l_pmn.pmn71 = ''
 
    IF l_pmn.pmn20 IS NULL THEN LET l_pmn.pmn20=0 END IF
    IF l_pmn.pmn82 IS NULL THEN LET l_pmn.pmn82=0 END IF
    IF l_pmn.pmn85 IS NULL THEN LET l_pmn.pmn85=0 END IF
    IF l_pmn.pmn31 IS NULL THEN LET l_pmn.pmn31=0 END IF
    IF l_pmn.pmn31t IS NULL THEN LET l_pmn.pmn31t=0 END IF      #No.FUN-550089
    IF l_pmn.pmn42 IS NULL THEN LET l_pmn.pmn42='0' END IF
    IF l_pmn.pmn50 IS NULL THEN LET l_pmn.pmn50=0 END IF
    IF l_pmn.pmn51 IS NULL THEN LET l_pmn.pmn51=0 END IF
    IF l_pmn.pmn53 IS NULL THEN LET l_pmn.pmn53=0 END IF
    IF l_pmn.pmn55 IS NULL THEN LET l_pmn.pmn55=0 END IF
    IF l_pmn.pmn57 IS NULL THEN LET l_pmn.pmn57=0 END IF
    IF l_pmn.pmn61 IS NULL THEN LET l_pmn.pmn61=' ' END IF
    IF l_pmn.pmn62 IS NULL THEN LET l_pmn.pmn62=1 END IF        #No.MOD-630075 modify
    LET l_pmn.pmn90 = l_pmn.pmn31   #CHI-690043 add
 
    SELECT pmn930 INTO l_pmn.pmn930 FROM pmn_file
                                   WHERE pmn01=g_pna01
                                     AND pmn02=g_pnb03
    IF SQLCA.sqlcode THEN
       LET l_pmn.pmn930=NULL
    END IF
   
  #MOD-D20124 add start -----
   SELECT pmm22 INTO l_pmm22 FROM pmm_file WHERE pmm01 = g_pna01
  #MOD-D20124 add end   -----

    SELECT azi04 INTO t_azi04 FROM azi_file     
     WHERE azi01 = l_pmm22  AND aziacti= 'Y'      #MOD-D20124 add
    #WHERE azi01 = g_pmm.pmm22  AND aziacti= 'Y'  #原幣 #MOD-D20124 mark

    LET l_pmn.pmn88 = cl_digcut(l_pmn.pmn31  * l_pmn.pmn87 ,t_azi04)
    LET l_pmn.pmn88t= cl_digcut(l_pmn.pmn31t * l_pmn.pmn87 ,t_azi04) 
    IF cl_null(l_pmn.pmn01) THEN LET l_pmn.pmn01 = ' ' END IF
    IF cl_null(l_pmn.pmn02) THEN LET l_pmn.pmn02 = 0 END IF
    LET l_pmn.pmn73 = ' '   #NO.FUN-960130    #NO.FUN-9B0016
    LET l_pmn.pmnplant = g_plant #FUN-980006 add
    LET l_pmn.pmnlegal = g_legal #FUN-980006 add
    IF cl_null(l_pmn.pmn58) THEN LET l_pmn.pmn58 = 0 END IF    #TQC-9B0203
    IF cl_null(l_pmn.pmn012) THEN LET l_pmn.pmn012 = ' ' END IF    #TQC-A70004
#TQC-AB0398   ---begin---
    SELECT pmh24 INTO l_pmh24 FROM pmh_file
       WHERE pmh01 = l_pmn.pmn04
         AND pmh02 = g_pmm09
         AND pmh13 = g_pmm22
         AND pmh21 = " "
         AND pmh22 = '1'
         AND pmh23 = ' '
         AND pmhacti = 'Y'
    IF NOT cl_null(l_pmh24) THEN
       LET l_pmn.pmn89=l_pmh24
    ELSE
       SELECT pmc914 INTO l_pmc914 FROM pmc_file
         WHERE pmc01 = g_pmm09
       IF l_pmc914 = 'Y' THEN
          LET l_pmn.pmn89 = 'Y'
       ELSE
          LET l_pmn.pmn89 = 'N'
       END IF
    END IF
#TQC-AB0398  ---end---
    CALL s_schdat_pmn78(l_pmn.pmn41,l_pmn.pmn012,l_pmn.pmn43,l_pmn.pmn18,   #FUN-C10002
                                    l_pmn.pmn32) RETURNING l_pmn.pmn78      #FUN-C10002
    INSERT INTO pmn_file VALUES (l_pmn.*)
     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
        LET g_success = 'N'
        CALL cl_err3("ins","pmn_file",l_pmn.pmn01,"","apm-954","","(cpmp910:ins)",1)  #No.FUN-660129
        RETURN
     ELSE
        IF NOT s_industry('std') THEN
           INITIALIZE l_pmni.* TO NULL
           LET l_pmni.pmni01 = l_pmn.pmn01
           LET l_pmni.pmni02 = l_pmn.pmn02
           LET l_pmni.pmnislk01 = g_pnbislk01a  #No.FUN-870117
           #MOD-BA0091 add --start--
           #由料串到ima_file 找出imaicd01給pmniicd14
           SELECT imaicd01 INTO l_pmni.pmniicd14
             FROM imaicd_file
            WHERE imaicd00=l_pmn.pmn04
           #MOD-BA0091 add --end--
           IF NOT s_ins_pmni(l_pmni.*,'') THEN
              LET g_success = 'N'
              RETURN
           END IF
        END IF
     END IF
 ELSE
   SELECT pmm21,pmm43 INTO g_pmm21,g_pmm43 FROM pmm_file WHERE pmm01=g_pna01   #MOD-950229
  {ckp#3}
  LET l_pnb04 = p_part
  IF NOT cl_null(g_pnb04a) THEN 
     LET l_pnb04 = g_pnb04a
  END IF 
 
  LET l_pnb07 = g_pnb07b
  IF NOT cl_null(g_pnb07a) THEN 
     LET l_pnb07 = g_pnb07a
  END IF 
 
  SELECT ima25 INTO l_pmn08 FROM ima_file WHERE ima01=l_pnb04
  #---取換算率
  CALL s_umfchk(l_pnb04,l_pnb07,l_pmn08) RETURNING l_flag,l_pmn09
  IF l_flag=1 THEN
#     CALL cl_err('pnb07/pmn08: ','abm-731',1)                                #MOD-C30372 mark
      LET g_showmsg = g_pna01,"/",g_pnb03                                     #MOD-C30372 add
      CALL s_errmsg('pmm01,pnb03',g_showmsg,'pnb07a/pmn08: ','abm-731',1)     #MOD-C30372 add
      LET g_success ='N'
  END IF
  #--->更新pmn_file
  #--->有變更料號的情況下,新料號須再做更新
  IF NOT cl_null(g_pnb04a) OR   #MOD-8B0062
     NOT cl_null(g_pnb041a) THEN   #MOD-8B0062
      IF cl_null(g_pnb04a) THEN LET g_pnb04a=p_part END IF  #No.B453 add
      UPDATE pmn_file SET pmn041 = g_pnb041a, # 品名規格
                          pmn08  = l_pmn08,   # 庫存單位    #MOD-A90026
                          pmn09  = l_pmn09,   # 庫存轉換率  #MOD-770083
                          pmn04  = g_pnb04a   # 料件編號
       WHERE pmn01 = g_pna01
         AND pmn02 = g_pnb03       # 採購單項次
 
      IF SQLCA.SQLCODE THEN
         LET g_success = 'N'
         CALL cl_err3("upd","pmn_file",g_pna01,g_pnb03,SQLCA.sqlcode,"","(apmp910:ckp#3)",1)  #No.FUN-660129
         RETURN
      END IF
 
      IF SQLCA.SQLERRD[3] = 0 THEN
         LET g_success = 'N'
         CALL cl_err('(apmp910:ckp#3.1)','apm-955',1)   #FUN-640201
         RETURN
      END IF
   END IF
 
   #---> 變更採購單位
   IF NOT cl_null(g_pnb07a) AND g_pnb07b != g_pnb07a THEN
      IF g_sma.sma31 = 'Y' THEN
         SELECT pmn04,pmn24,pmn25,pmn121 # 請購單號,請購單號項次
           INTO l_pmn04,l_pmn24,l_pmn25,l_pmn121
           FROM pmn_file
          WHERE pmn01=g_pna01  # 採購單號
            AND pmn02=g_pnb03  # 採購單項次
      
         IF SQLCA.SQLCODE THEN
            LET g_success = 'N'
            CALL cl_err3("sel","pmn_file",g_pna01,g_pnb03,SQLCA.sqlcode,"","pmn:ckp",1) 
            RETURN
         END IF
 
         SELECT pmm909 INTO g_pmm.pmm909 FROM pmm_file WHERE pmm01 = g_pna01   #MOD-930271
         IF l_pmn24 IS NOT NULL AND l_pmn24 != ' '
            AND l_pmn25 IS NOT NULL 
            AND (g_pmm.pmm909 = '1' OR g_pmm.pmm909 = '2') THEN   #MOD-930271 
             SELECT pml07 INTO l_pml07 FROM pml_file
                    WHERE pml01=l_pmn24 AND pml02 = l_pmn25
             IF SQLCA.SQLCODE THEN
                LET g_success = 'N'
                CALL cl_err3("sel","pml_file",l_pmn24,l_pmn25,SQLCA.sqlcode,"","pml:ckp",1)  
                RETURN
             END IF
             CALL s_umfchk(l_pmn04,g_pnb07a,l_pml07)
                RETURNING l_flag,l_pmn121                #取換算率
             IF l_flag=1 THEN
                LET g_success = 'N'
                CALL cl_err('pml07/pmn07:','abm-731',1)   
                RETURN
             END IF
         END IF
      END IF
      UPDATE pmn_file SET pmn07 = g_pnb07a,   # 採購單位
                          pmn121 = l_pmn121,   #採購單位與請購單為換算率 #No.MOD-780229 add
                          pmn09  = l_pmn09    # 庫存轉換率  #MOD-770083
       WHERE pmn01 = g_pna01
         AND pmn02 = g_pnb03       # 採購單項次
 
      IF SQLCA.SQLERRD[3] = 0 THEN
         LET g_success = 'N'
         CALL cl_err3("upd","pmn_file",g_pna01,g_pnb03,"apm-956","","(apmp910:ckp#3.2)",1)  #No.FUN-660129
         RETURN
      END IF
   END IF
{ckp#6}
   IF NOT cl_null(g_pnb33a) THEN
       IF cl_null(g_pnb33b) THEN #NO:6949
           UPDATE pmn_file SET pmn33 = g_pnb33a,
                               pmn34 = l_pmn.pmn34,   #到廠日
                               pmn35 = l_pmn.pmn35    #到庫日
            WHERE pmn01 = g_pna01
              AND pmn02 = g_pnb03                 # 採購單項次
            IF SQLCA.SQLCODE THEN
               LET g_success = 'N'
               CALL cl_err('(apmp910:ckp#6)',SQLCA.SQLCODE,1)
               RETURN
            END IF
 
            IF SQLCA.SQLERRD[3] = 0 THEN
               LET g_success = 'N'
               CALL cl_err('(apmp910:ckp#6.1)','apm-959',1)  #FUN-640201
               RETURN
            END IF
       ELSE
           IF g_pnb33a != g_pnb33b THEN # 變更原始交貨日期
               UPDATE pmn_file SET pmn33 = g_pnb33a,
                                   pmn34 = l_pmn.pmn34,   #到廠日
                                   pmn35 = l_pmn.pmn35    #到庫日
                WHERE pmn01 = g_pna01
                  AND pmn02 = g_pnb03       # 採購單項次
                IF SQLCA.SQLCODE THEN
                   LET g_success = 'N'
                   CALL cl_err('(apmp910:ckp#6)',SQLCA.SQLCODE,1)
                   RETURN
                END IF
          
                IF SQLCA.SQLERRD[3] = 0 THEN
                   LET g_success = 'N'
                   CALL cl_err('(apmp910:ckp#6.1)','apm-959',1)  #FUN-640201
                   RETURN
                END IF
           END IF
       END IF
    END IF
{ckp#7}
   IF NOT cl_null(g_pnb80a) AND g_pnb80b != g_pnb80a THEN
      UPDATE pmn_file SET pmn80 = g_pnb80a    # 採購單位
       WHERE pmn01 = g_pna01
         AND pmn02 = g_pnb03       # 採購單項次
 
      IF SQLCA.SQLERRD[3] = 0 THEN
         LET g_success = 'N'
         CALL cl_err3("upd","pmn_file",g_pna01,g_pnb03,"apm-956","","(apmp910:ckp#7)",1)  #No.FUN-660129
         RETURN
      END IF
   END IF
{ckp#8}
   IF NOT cl_null(g_pnb81a) AND g_pnb81b != g_pnb81a THEN
      UPDATE pmn_file SET pmn81 = g_pnb81a    # 採購單位
       WHERE pmn01 = g_pna01
         AND pmn02 = g_pnb03       # 採購單項次
 
      IF SQLCA.SQLERRD[3] = 0 THEN
         LET g_success = 'N'
         CALL cl_err3("upd","pmn_file",g_pna01,g_pnb03,"apm-960","","(apmp910:ckp#8)",1)  #No.FUN-660129
         RETURN
      END IF
   END IF
{ckp#9}
   IF NOT cl_null(g_pnb82a) AND g_pnb82b != g_pnb82a THEN
      UPDATE pmn_file SET pmn82 = g_pnb82a    # 採購單位
       WHERE pmn01 = g_pna01
         AND pmn02 = g_pnb03       # 採購單項次
 
      IF SQLCA.SQLERRD[3] = 0 THEN
         LET g_success = 'N'
         CALL cl_err3("upd","pmn_file",g_pna01,g_pnb03,"apm-957","","(apmp910:ckp#9)",1)  #No.FUN-660129
         RETURN
      END IF
   END IF
{ckp#10}
   IF NOT cl_null(g_pnb83a) AND g_pnb83b != g_pnb83a THEN
      UPDATE pmn_file SET pmn83 = g_pnb83a    # 採購單位
       WHERE pmn01 = g_pna01
         AND pmn02 = g_pnb03       # 採購單項次
 
      IF SQLCA.SQLERRD[3] = 0 THEN
         LET g_success = 'N'
         CALL cl_err3("upd","pmn_file",g_pna01,g_pnb03,"apm-956","","(apmp910:ckp#10)",1)  #No.FUN-660129
         RETURN
      END IF
   END IF
{ckp#11}
   IF NOT cl_null(g_pnb84a) AND g_pnb84b != g_pnb84a THEN
      UPDATE pmn_file SET pmn84 = g_pnb84a    # 採購單位
       WHERE pmn01 = g_pna01
         AND pmn02 = g_pnb03       # 採購單項次
 
      IF SQLCA.SQLERRD[3] = 0 THEN
         LET g_success = 'N'
         CALL cl_err3("upd","pmn_file",g_pna01,g_pnb03,"apm-960","","(apmp910:ckp#11)",1)  #No.FUN-660129
         RETURN
      END IF
   END IF
{ckp#12}
   IF NOT cl_null(g_pnb85a) AND g_pnb85b != g_pnb85a THEN
      UPDATE pmn_file SET pmn85 = g_pnb85a    # 採購單位
       WHERE pmn01 = g_pna01
         AND pmn02 = g_pnb03       # 採購單項次
 
      IF SQLCA.SQLERRD[3] = 0 THEN
         LET g_success = 'N'
         CALL cl_err3("upd","pmn_file",g_pna01,g_pnb03,"apm-957","","(apmp910:ckp#11)",1)  #No.FUN-660129
         RETURN
      END IF
   END IF
   IF s_industry('slk') THEN
   IF NOT cl_null(g_pnbislk01a) AND g_pnbislk01b != g_pnbislk01a THEN
      UPDATE pmni_file SET pmnislk01 = g_pnbislk01a    # 制單號
       WHERE pmni01 = g_pna01
         AND pmni02 = g_pnb03
                                                                                                                                    
      IF SQLCA.SQLERRD[3] = 0 THEN
         LET g_success = 'N'
         CALL cl_err3("upd","pmni_file",g_pna01,g_pnb03,"apm-957","","",1)
         RETURN
      END IF
   END IF
   END IF
{ckp#13}
   IF NOT cl_null(g_pnb86a) AND g_pnb86b != g_pnb86a THEN
      UPDATE pmn_file SET pmn86 = g_pnb86a    # 採購單位
       WHERE pmn01 = g_pna01
         AND pmn02 = g_pnb03       # 採購單項次
 
      IF SQLCA.SQLERRD[3] = 0 THEN
         LET g_success = 'N'
         CALL cl_err3("upd","pmn_file",g_pna01,g_pnb03,"apm-956","","(apmp910:ckp#13)",1)  #No.FUN-660129
         RETURN
      END IF
   END IF

#FUN-A80142 --begin--
    IF NOT cl_null(g_pnb34a) OR NOT cl_null(g_pnb35a) OR NOT cl_null(g_pnb36a) THEN
       UPDATE pmn_file 
          SET pmn122 = g_pnb34a,
              pmn96  = g_pnb35a,
              pmn97  = g_pnb36a
        WHERE pmn01  = g_pna01
          AND pmn02  = g_pnb03
     
      IF SQLCA.SQLERRD[3] = 0 THEN
         LET g_success = 'N'
         CALL cl_err3("upd","pmn_file",g_pna01,g_pnb03,"apm-362","","(apmp910:FUN-A80142)",1)  
         RETURN
      END IF                    
    END IF 
#FUN-A80142 --end--
   
{ckp#14}
   IF NOT cl_null(g_pnb87a) AND g_pnb87b != g_pnb87a THEN
      UPDATE pmn_file SET pmn87 = g_pnb87a    # 採購單位
       WHERE pmn01 = g_pna01
         AND pmn02 = g_pnb03       # 採購單項次
 
      IF SQLCA.SQLERRD[3] = 0 THEN
         LET g_success = 'N'
         CALL cl_err3("upd","pmn_file",g_pna01,g_pnb03,"apm-957","","(apmp910:ckp#14)",1)  #No.FUN-660129
         RETURN
      ELSE
         CALL p910_up_pmn88()
         IF g_success = 'N' THEN
            CALL cl_err('(apmp910:ckp#5)','mfg9328',1)
            RETURN 
         END IF
      END IF
   END IF
#將原本UPDATE"單價"與"數量"的地方，移至最後面UPDATE
#因為要同時UPDATE"pmn88"與"pmn88t"需用到最新的計價數量值
{ckp#4}
   IF NOT cl_null(g_pnb20a) AND g_pnb20a != g_pnb20b THEN  # 變更訂購量
      UPDATE pmn_file SET pmn20 = g_pnb20a_old # 變更後訂購量
       WHERE pmn01 = g_pna01
         AND pmn02 = g_pnb03       # 採購單項次
 
      IF SQLCA.SQLERRD[3] = 0 THEN
         LET g_success = 'N'
         CALL cl_err3("upd","pmn_file",g_pna01,g_pnb03,"apm-957","","(apmp910:ckp#4)",1)  #No.FUN-660129
         RETURN
      ELSE
         #CHI-B50016 add --start--
         SELECT pmn68,pmn69 INTO l_pmn68,l_pmn69
           FROM pmn_file 
          WHERE pmn01 = g_pna01
            AND pmn02 = g_pnb03
         IF SQLCA.sqlcode THEN LET l_pmn68 = '' END IF
         IF NOT cl_null(l_pmn68) THEN
            #UPDATE pon_file SET pon21 = g_pnb20a_old  #MOD-BB0264 mark 
            UPDATE pon_file SET pon21 = g_pnb20a_new   #MOD-BB0264 add
             WHERE pon01 = l_pmn68 
               AND pon02 = l_pmn69
            IF SQLCA.sqlerrd[3] = 0 THEN
               LET g_success = 'N'
               CALL cl_err3("upd","pon_file",l_pmn68,l_pmn69,SQLCA.sqlcode,"","pmn68 update pon21",1)  
               RETURN
            END IF 
         END IF 
         #CHI-B50016 add --end--
         CALL p910_up_pmn88()
         IF g_success = 'N' THEN
            CALL cl_err('(apmp910:ckp#5)','mfg9328',1)     #No.TQC-710086
            RETURN 
         END IF
     #TQC-C30173--add--begin--
         IF s_industry("slk") AND g_azw.azw04= '2' THEN
            SELECT pmnslk02,pmnslk04 INTO l_pmnslk02,l_pmnslk04 FROM pmnslk_file,pmni_file
               WHERE pmnslk01=pmni01 AND pmnslk02=pmnislk03 AND pmnslk04=pmnislk02
                 AND pmni01 = g_pna01 AND pmni02 = g_pnb03       # 採購單項次
            SELECT SUM(pmn20),SUM(pmn88),SUM(pmn88t) INTO l_pmnslk20,l_pmnslk88,l_pmnslk88t FROM pmn_file,pmni_file
               WHERE pmn01=pmni01 AND pmn02=pmni02 AND pmni01=g_pna01
                 AND pmnislk02=l_pmnslk04 AND pmnislk03=l_pmnslk02
            UPDATE pmnslk_file SET pmnslk20=l_pmnslk20,
                                   pmnslk88=l_pmnslk88,
                                   pmnslk88t=l_pmnslk88t
                WHERE pmnslk01=g_pna01
                  AND pmnslk02=l_pmnslk02
                  AND pmnslk04=l_pmnslk04
            IF SQLCA.SQLERRD[3] = 0 THEN
               LET g_success = 'N'
               CALL cl_err3("upd","pmnslk_file",g_pna01,g_pnb03,"apm-957","","(apmp910:ckp#4)",1)
               RETURN
            END IF
         END IF
     #TQC-C30173--add--end---
      END IF
   END IF

   #MOD-C30823 add start -----
   #---> 變更請購單號,請購單號項次
   IF NOT cl_null(g_pnb90) AND NOT cl_null(g_pnb91) THEN
      UPDATE pmn_file SET pmn24 = g_pnb90, pmn25 = g_pnb91 WHERE pmn01=g_pna01 AND pmn02=g_pnb03
      IF SQLCA.SQLERRD[3] = 0 THEN
         LET g_success = 'N'
         CALL cl_err3("upd","pmn_file",g_pna01,g_pnb03,"apm1077","","",1)
         RETURN
      END IF
   END IF
   #MOD-C30823 add end -----
{ckp#5}
   IF NOT cl_null(g_pnb31a) AND
      (g_pnb31a != g_pnb31b OR g_pnb32a != g_pnb32b) THEN  # 變更單價  #No.FUN-550089
      SELECT pmm43 INTO g_pmm43 FROM pmm_file WHERE pmm01=g_pna01
      IF SQLCA.SQLCODE THEN LET g_pmm43 = 0.0 ELSE
          IF cl_null(g_pmm43) THEN LET g_pmm43 = 0.0 END IF END IF
 
      UPDATE pmn_file SET pmn31=g_pnb31a,pmn31t=g_pnb32a      #No.FUN-550089
       WHERE pmn01 = g_pna01
         AND pmn02 = g_pnb03       # 採購單項次
 
      IF SQLCA.SQLCODE THEN
         LET g_success = 'N'
         CALL cl_err3("upd","pmn_file",g_pna01,g_pnb03,SQLCA.sqlcode,"","(apmp910:ckp#5)",1)  #No.FUN-660129
         RETURN
      END IF
 
      IF SQLCA.SQLERRD[3] = 0 THEN
         LET g_success = 'N'
         CALL cl_err('(apmp910:ckp#5.1)','apm-958',1)   #FUN-640201
         RETURN
      ELSE
         CALL p910_up_pmn88()
         IF g_success = 'N' THEN
            CALL cl_err('(apmp910:ckp#5)','mfg9328',1)
            RETURN 
         END IF
      END IF
      SELECT pmm42 INTO l_pmm42 FROM pmm_file     #update本幣單價
       WHERE pmm01=g_pna01
      LET l_tot = cl_digcut(g_pnb31a*l_pmm42,g_azi03)    #MOD-970168 add
      UPDATE pmn_file SET pmn44=l_tot
       WHERE pmn01=g_pna01 AND pmn02=g_pnb03
 
   END IF
 END IF
   #--->當有使用請購系統且更改採購數量時, 須更新請購的已轉採購數量
   #IF g_sma.sma31 = 'Y' AND                               #MOD-C30823 mark
   IF (NOT cl_null(g_pnb90) AND NOT cl_null(g_pnb91)) OR   #MOD-C30823 add
      (g_sma.sma31 = 'Y' AND                               #MOD-C30823 add
      NOT cl_null(g_pnb20a) AND g_pnb20b != g_pnb20a) THEN #MOD-C30823 add )
         SELECT pmn24,pmn25 # 請購單號,請購單號項次
           INTO l_pmn24,l_pmn25
           FROM pmn_file
          WHERE pmn01=g_pna01  # 採購單號
            AND pmn02=g_pnb03  # 採購單項次
 
             IF SQLCA.SQLCODE THEN
                LET g_success = 'N'
                CALL cl_err3("sel","pmn_file",g_pna01,g_pnb03,SQLCA.sqlcode,"","pmn:ckp",1)  #No.FUN-660129
                RETURN
             END IF
         SELECT pmm909 INTO g_pmm.pmm909 FROM pmm_file WHERE pmm01 = g_pna01  #MOD-830092 add  #MOD-840555 modify
      IF g_pmm.pmm909 <>'3' THEN     #MOD-8B0052 add   
         IF l_pmn24 IS NOT NULL AND l_pmn24 != ' '
            AND l_pmn25 IS NOT NULL
            AND (g_pmm.pmm909 = '1' OR g_pmm.pmm909 = '2')      #MOD-830092 add
         THEN
             SELECT SUM(pmn20*pmn121) INTO l_qty FROM pmn_file
                                    WHERE pmn24 = l_pmn24
                                      AND pmn25 = l_pmn25
                                      AND pmn16<>'9'        #取消(Cancel)
                          IF SQLCA.SQLCODE THEN
                             LET g_success = 'N'
                             CALL cl_err('pml:ckp',SQLCA.SQLCODE,1) 
                             RETURN
                          END IF
             #MOD-CA0214 -- add start --
            #IF NOT cl_null(g_pnb90b) AND NOT cl_null(g_pnb91b)                          #MOD-CB0248 mark
            # AND l_pmn24 <> g_pnb90b OR l_pmn25 <> g_pnb91b THEN                        #MOD-CB0248 mark
             IF NOT cl_null(g_pnb90b) AND (NOT cl_null(g_pnb91b) OR g_pnb91b > 0) THEN   #MOD-CB0248 add
                IF l_pmn24 <> g_pnb90b OR l_pmn25 <> g_pnb91b THEN                       #MOD-CB0248 add
                   SELECT SUM(pmn20*pmn121) INTO l_qty_o FROM pmn_file
                                          WHERE pmn24 = g_pnb90b
                                            AND pmn25 = g_pnb91b
                                            AND pmn16<>'9'        #取消(Cancel)
                                IF SQLCA.SQLCODE THEN
                                   LET g_success = 'N'
                                   CALL cl_err('pml:ckp',SQLCA.SQLCODE,1)
                                   RETURN
                                END IF
                   IF cl_null(l_qty_o) THEN LET l_qty_o = 0 END IF
                END IF   #MOD-CB0248 add
             END IF
             #MOD-CA0214 -- add end --
             SELECT pml09 INTO l_pml09 FROM pml_file
                                     WHERE pml01=l_pmn24
                                       AND pml02=l_pmn25
                          IF SQLCA.SQLCODE THEN
                             LET g_success = 'N'
                             CALL cl_err3("sel","pml_file",l_pmn24,l_pmn25,SQLCA.sqlcode,"","pml:ckp",1)  #No.FUN-660129
                             RETURN
                          END IF
             IF l_pml09 IS NULL OR l_pml09 = 0 THEN LET l_pml09 = 1 END IF
 
           LET l_pml21 = l_qty                         #No.MOD-780229 add
           LET l_pml21_o = l_qty_o                     #MOD-CA0214 add
        #FUN-BB0084 ------------Begin-------------
           SELECT pml07 INTO l_pml07 FROM pml_file
            WHERE pml01 = l_pmn24
              AND pml02 = l_pmn25  
           LET l_pml21 = s_digqty(l_pml21,l_pml07) 
        #FUN-BB0084 ------------End---------------
           IF g_sma.sma32='Y' THEN 
             UPDATE pml_file SET pml21 = l_pml21,      # 已轉採購數量
                                 pml16 = '2'           # 狀況碼
                           WHERE pml01 = l_pmn24       # 請購單號
                             AND pml02 = l_pmn25       # 請購單號項次
                             AND pml16 NOT IN ('0','6','7','8','9')   #MOD-A20089
           ELSE
             #MOD-C30823 add start -----
             IF l_pml21 = 0 THEN
                LET l_pml16 = 1
             ELSE
                LET l_pml16 = 2
             END IF
             #MOD-C30823 add end -----
             UPDATE pml_file SET pml21 = l_pml21       # 已轉採購數量
                                ,pml16 = l_pml16       # 狀況碼       #MOD-C30823 add
                           WHERE pml01 = l_pmn24       # 請購單號
                             AND pml02 = l_pmn25       # 請購單號項次
             IF SQLCA.SQLERRD[3] = 0 THEN
                LET g_success = 'N'
                CALL cl_err3("upd","pml_file",l_pmn24,l_pmn25,"apm-961","","pml:ckp#1",1)  #No.FUN-660129
                RETURN
             END IF
             #MOD-CA0214 -- add start --
            #IF NOT cl_null(g_pnb90b) AND NOT cl_null(g_pnb91b)                          #MOD-CB0248 mark
            # AND l_pmn24 <> g_pnb90b OR l_pmn25 <> g_pnb91b THEN                        #MOD-CB0248 mark
             IF NOT cl_null(g_pnb90b) AND (NOT cl_null(g_pnb91b) OR g_pnb91b > 0) THEN   #MOD-CB0248 add
                IF l_pmn24 <> g_pnb90b OR l_pmn25 <> g_pnb91b THEN                       #MOD-CB0248 add
                   IF l_pml21_o = 0 THEN
                      LET l_pml16 = 1
                   ELSE
                      LET l_pml16 = 2
                   END IF
                   UPDATE pml_file SET pml21 = l_pml21_o     # 原請購單號,已轉採購數量
                                      ,pml16 = l_pml16       # 狀況碼
                                 WHERE pml01 = g_pnb90b      # 變更前請購單號
                                   AND pml02 = g_pnb91b      # 變更前請購單號項次
                   IF SQLCA.SQLERRD[3] = 0 THEN
                      LET g_success = 'N'
                      CALL cl_err3("upd","pml_file",g_pnb90b,g_pnb91b,"apm-961","","pml:ckp#1",1)
                      RETURN
                   END IF
                END IF   #MOD-CB0248 add
             END IF
             #MOD-CA0214 -- add end --
           END IF   #MOD-790013

           IF g_sma.sma32='Y' AND NOT cl_null(l_pmn.pmn24) THEN 
              UPDATE pmk_file SET pmk25 = '2'
               WHERE pmk01 = l_pmn.pmn24
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","pmk_file",l_pmn24,"",SQLCA.sqlcode,"","pmn24 update pmk25",1)
                 LET g_success = 'N'
              END IF
           #MOD-C30823 add start -----
           ELSE
              SELECT COUNT(*) INTO l_cnt FROM pml_file WHERE pml01=l_pmn24 AND pml16 = '2'
              IF l_cnt = 0 THEN
                 UPDATE pmk_file SET pmk25 = '1' WHERE pmk01 = l_pmn24
              ELSE
                 UPDATE pmk_file SET pmk25 = '2' WHERE pmk01 = l_pmn24
              END IF
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","pml_file",l_pmn24,"",SQLCA.sqlcode,"","",1)
                 LET g_success = 'N'
                 RETURN
              END IF
           #MOD-C30823 add end -----
              #MOD-CA0214 -- add start --
             #IF NOT cl_null(g_pnb90b) AND NOT cl_null(g_pnb91b)                          #MOD-CB0248 mark
             # AND l_pmn24 <> g_pnb90b OR l_pmn25 <> g_pnb91b THEN                        #MOD-CB0248 mark
              IF NOT cl_null(g_pnb90b) AND (NOT cl_null(g_pnb91b) OR g_pnb91b > 0) THEN   #MOD-CB0248 add
                 IF l_pmn24 <> g_pnb90b OR l_pmn25 <> g_pnb91b THEN                       #MOD-CB0248 add
                    SELECT COUNT(*) INTO l_cnt FROM pml_file WHERE pml01=g_pnb90b AND pml16 = '2'
                    IF l_cnt = 0 THEN
                       UPDATE pmk_file SET pmk25 = '1' WHERE pmk01 = g_pnb90b
                    ELSE
                       UPDATE pmk_file SET pmk25 = '2' WHERE pmk01 = g_pnb90b
                    END IF
                    IF SQLCA.sqlcode THEN
                       CALL cl_err3("upd","pml_file",g_pnb90b,"",SQLCA.sqlcode,"","",1)
                       LET g_success = 'N'
                       RETURN
                    END IF
                 END IF   #MOD-CB0248 add
              END IF
              #MOD-CA0214 -- add end --
           END IF 
        END IF
    ELSE 
    	 IF NOT cl_null(l_pmn24) AND NOT cl_null(l_pmn25) THEN
    	    SELECT SUM(pmn20/pmn62*pmn121) INTO l_qty FROM pmn_file
    	     WHERE pmn24=l_pmn24 AND pmn25=l_pmn25
    	       AND pmn16<>'9'
    	    IF STATUS OR cl_null(l_qty) THEN LET l_qty=0 END IF
         #FUN-BB0084 -------------Begin--------------  
            SELECT oeb05 INTO l_oeb05 FROM oeb_file
             WHERE oeb01 = l_pmn24 AND oeb03=l_pmn25  
            LET l_qty = s_digqty(l_qty,l_oeb05)    
         #FUN-BB0084 -------------End----------------
    	    UPDATE oeb_file SET oeb28=l_qty
             WHERE oeb01=l_pmn24 AND oeb03=l_pmn25
    	 END IF
         #MOD-CA0214 -- add start --
        #IF NOT cl_null(g_pnb90b) AND NOT cl_null(g_pnb91b)                              #MOD-CB0248 mark
        # AND l_pmn24 <> g_pnb90b OR l_pmn25 <> g_pnb91b THEN                            #MOD-CB0248 mark
         IF NOT cl_null(g_pnb90b) AND (NOT cl_null(g_pnb91b) OR g_pnb91b > 0) THEN       #MOD-CB0248 add
            IF l_pmn24 <> g_pnb90b OR l_pmn25 <> g_pnb91b THEN                           #MOD-CB0248 add
               SELECT SUM(pmn20/pmn62*pmn121) INTO l_qty FROM pmn_file
                WHERE pmn24=g_pnb90b AND pmn25= g_pnb91b
                  AND pmn16<>'9'
               IF STATUS OR cl_null(l_qty) THEN LET l_qty=0 END IF
               UPDATE oeb_file SET oeb28=l_qty
                WHERE oeb01=g_pnb90b AND oeb03= g_pnb91b
            END IF   #MOD-CB0248 add
         END IF
         ##MOD-CA0214 -- add end --
     END IF	         
   END IF
#==>如存在[料件/供應商檔]中則更新其最近採購單價
IF NOT cl_null(g_pnb04a) AND p_part != g_pnb04a THEN  # 變更料號
   IF l_pmn011 <> 'SUB' THEN                       #No.CHI-860042  
      SELECT pmh12,pmh17,pmh18,pmh19,pmh13,pmh14   #No.FUN-610018
        INTO l_pmh12,l_pmh17,l_pmh18,l_pmh19,l_pmh13,l_pmh14
        FROM pmh_file
       WHERE pmh01 = g_pnb04a   # 料件編號--變更後
         AND pmh02 = g_pmm09    # 供應廠商
         AND pmh13 = g_pmm22    # 幣別
         AND pmh21 = " " AND pmh22 ="1"                          #No.CHI-860042  
         AND pmh23 = ' '                                         #No.CHI-960033
   ELSE
     SELECT pmh12,pmh17,pmh18,pmh19,pmh13,pmh14                  #No.CHI-860042
        INTO l_pmh12,l_pmh17,l_pmh18,l_pmh19,l_pmh13,l_pmh14     #No.CHI-860042
        FROM pmh_file                                            #No.CHI-860042
       WHERE pmh01 = g_pnb04a   # 料件編號--變更後               #No.CHI-860042
         AND pmh02 = g_pmm09    # 供應廠商                       #No.CHI-860042
         AND pmh13 = g_pmm22    # 幣別                           #No.CHI-860042
         AND pmh21 = l_ecm04 AND pmh22 ="2"                      #No.CHI-860042
         AND pmh23 = ' '                                         #No.CHI-960033
   END IF       	                                         #No.CHI-860042
ELSE
    IF p_part[1,4] <> 'MISC' THEN   #No.B453 add
       IF l_pmn011 <> 'SUB' THEN                                 #No.CHI-860042
          SELECT pmh12,pmh17,pmh18,pmh19,pmh13,pmh14
            INTO l_pmh12,l_pmh17,l_pmh18,l_pmh19,l_pmh13,l_pmh14
            FROM pmh_file
           WHERE pmh01 = p_part     # 料件編號--變更前
             AND pmh02 = g_pmm09    # 供應廠商
             AND pmh13 = g_pmm22    # 幣別
             AND pmh21 = " " AND pmh22 ="1"                      #No.CHI-860042
             AND pmh23 = ' '                                         #No.CHI-960033
       ELSE
          SELECT pmh12,pmh17,pmh18,pmh19,pmh13,pmh14             #No.CHI-860042
            INTO l_pmh12,l_pmh17,l_pmh18,l_pmh19,l_pmh13,l_pmh14 #No.CHI-860042
            FROM pmh_file                                        #No.CHI-860042
           WHERE pmh01 = p_part     # 料件編號--變更前           #No.CHI-860042
             AND pmh02 = g_pmm09    # 供應廠商                   #No.CHI-860042
             AND pmh13 = g_pmm22    # 幣別                       #No.CHI-860042
             AND pmh21 = l_ecm04 AND pmh22 ="2"                  #No.CHI-860042
             AND pmh23 = ' '                                         #No.CHI-960033
       END IF           	                                 #No.CHI-860042       
     END IF   #No.B453 add       
END IF
 
   IF SQLCA.SQLCODE = 0 THEN
      CASE # 採購單發出時,更新料件供應商最近單價方式
         WHEN g_sma.sma842 = '1'
            LET l_new = p_price
            LET lt_new = pt_price   #No.FUN-610018
            LET ln_pmh17 = g_pmm21  #No.FUN-610018
            LET ln_pmh18 = g_pmm43  #No.FUN-610018
            LET l_curr= g_pmm22
            LET l_rate= g_pmm42
 
         WHEN g_sma.sma842 = '2' AND g_pmm22 != l_curr
            IF (p_price*g_pmm42 < l_pmh12*l_pmh14) OR
               (pt_price*g_pmm42 < l_pmh19*l_pmh14) THEN
               LET l_new = p_price
               LET lt_new = pt_price   #No.FUN-610018
               LET ln_pmh17 = g_pmm21  #No.FUN-610018
               LET ln_pmh18 = g_pmm43  #No.FUN-610018
               LET l_curr= g_pmm22
               LET l_rate= g_pmm42
            ELSE
               LET l_new = l_pmh12
               LET lt_new = l_pmh19    #No.FUN-610018
               LET ln_pmh17 = l_pmh17  #No.FUN-610018
               LET ln_pmh18 = l_pmh18  #No.FUN-610018
               LET ln_pmh17 = l_pmh17  #No.FUN-610018
               LET ln_pmh18 = l_pmh18  #No.FUN-610018
               LET l_curr= l_pmh13
               LET l_rate= l_pmh14
            END IF
 
         WHEN g_sma.sma842 = '2' AND g_pmm22 = l_curr
            IF (p_price < l_pmh12) OR (pt_price < l_pmh19) THEN  #No.FUN-610018
               LET l_new = p_price
               LET lt_new = pt_price   #No.FUN-610018
               LET ln_pmh17 = g_pmm21  #No.FUN-610018
               LET ln_pmh18 = g_pmm43  #No.FUN-610018
               LET l_curr= g_pmm22
               LET l_rate= g_pmm42
            ELSE
               LET l_new = l_pmh12
               LET lt_new = l_pmh19    #No.FUN-610018
               LET ln_pmh17 = l_pmh17  #No.FUN-610018
               LET ln_pmh18 = l_pmh18  #No.FUN-610018
               LET l_curr= l_pmh13
               LET l_rate= l_pmh14
            END IF
 
        OTHERWISE
            LET l_new = l_pmh12
            LET lt_new = l_pmh19    #No.FUN-610018
            LET ln_pmh17 = l_pmh17  #No.FUN-610018
            LET ln_pmh18 = l_pmh18  #No.FUN-610018
            LET l_curr= l_pmh13
            LET l_rate= l_pmh14
      END CASE
 
{ckp#7}
#--->更新[供應商料件對應資料]檔
IF NOT cl_null(g_pnb04a) AND p_part != g_pnb04a THEN  # 變更料號
   IF l_pmn011 <> 'SUB' THEN                                     #No.CHI-860042
      UPDATE pmh_file SET pmh12 = l_new,
                          pmh17 = ln_pmh17, #No.FUN-610018
                          pmh18 = ln_pmh18, #No.FUN-610018
                          pmh19 = lt_new,   #No.FUN-610018
                          pmh13 = l_curr,
                          pmh14 = l_rate,
                          pmhdate = g_today     #FUN-C40009 add
       WHERE pmh01 = g_pnb04a   # 料件編號--變更後
         AND pmh02 = g_pmm09    # 供應廠商
         AND pmh13 = g_pmm22    # 幣別
         AND pmh21 = " " AND pmh22 ="1"                           #No.CHI-860042
         AND pmh23 = ' '                                          #No.CHI-960033
   ELSE                                                           #No.CHI-860042
       UPDATE pmh_file SET pmh12 = l_new,                         #No.CHI-860042
                          pmh17 = ln_pmh17,                       #No.CHI-860042
                          pmh18 = ln_pmh18,                       #No.CHI-860042
                          pmh19 = lt_new,                         #No.CHI-860042
                          pmh13 = l_curr,                         #No.CHI-860042
                          pmh14 = l_rate,                         #No.CHI-860042
                          pmhdate = g_today                       #FUN-C40009 add
       WHERE pmh01 = g_pnb04a   # 料件編號--變更後                #No.CHI-860042
         AND pmh02 = g_pmm09    # 供應廠商                        #No.CHI-860042
         AND pmh13 = g_pmm22    # 幣別                            #No.CHI-860042
         AND pmh21 = l_ecm04 AND pmh22 ="2"                       #No.CHI-860042
         AND pmh23 = ' '                                          #No.CHI-960033
   END IF         	                                          #No.CHI-860042
 
    IF SQLCA.SQLCODE THEN
       LET g_success = 'N'
       CALL cl_err3("upd","pmh_file",g_pnb04a,"",SQLCA.sqlcode,"","(apmp910:ckp#7)",1)  #No.FUN-660129
    END IF
 
    IF SQLCA.SQLERRD[3] = 0 THEN
       LET g_success = 'N'
       CALL cl_err('(apmp910:ckp#7.1)','apm-962',1) #FUN-640201
       RETURN
    END IF
 ELSE
    IF p_part[1,4] <> 'MISC' THEN   #No.B453 add
     IF l_pmn011 <> 'SUB' THEN                                     #No.CHI-860042
       UPDATE pmh_file SET pmh12 = l_new,
                           pmh19 = lt_new,  #No.FUN-610018
                           pmh13 = l_curr,
                           pmh14 = l_rate,
                           pmhdate = g_today     #FUN-C40009 add
        WHERE pmh01 = p_part     # 料件編號
          AND pmh02 = g_pmm09    # 供應廠商
          AND pmh13 = g_pmm22    # 幣別
          AND pmh21 = " " AND pmh22 ="1"                           #No.CHI-860042  
          AND pmh23 = ' '                                          #No.CHI-960033
      ELSE                                                         #No.CHI-860042  
        UPDATE pmh_file SET pmh12 = l_new,                         #No.CHI-860042
                           pmh19 = lt_new,                         #No.CHI-860042
                           pmh13 = l_curr,                         #No.CHI-860042
                           pmh14 = l_rate,                         #No.CHI-860042
                           pmhdate = g_today                       #FUN-C40009 add
        WHERE pmh01 = p_part     # 料件編號                        #No.CHI-860042
          AND pmh02 = g_pmm09    # 供應廠商                        #No.CHI-860042  
          AND pmh13 = g_pmm22    # 幣別                            #No.CHI-860042
          AND pmh21 = l_ecm04 AND pmh22 ="2"                       #No.CHI-860042
          AND pmh23 = ' '                                          #No.CHI-960033
      END IF                                                       #No.CHI-860042    
 
        IF SQLCA.SQLCODE THEN
           LET g_success = 'N'
           CALL cl_err3("upd","pmh_file",p_part,"",SQLCA.sqlcode,"","(apmp910:ckp#7.2)",1)  #No.FUN-660129
        END IF
 
        IF SQLCA.SQLERRD[3] = 0 THEN
           LET g_success = 'N'
           CALL cl_err('(apmp910:ckp#7.3)','apm-962',1)  #FUN-640201
           RETURN
        END IF
     END IF   #No.B453 add
 END IF
#MOD-B80242 -- begin --
    ELSE
      #LET l_pmh.pmh01=p_part  #MOD-C30568 mark
      LET l_pmh.pmh01=g_pnb04a #MOD-C30568 add
      LET l_pmh.pmh02=g_pmm09
      LET l_pmh.pmh03='N'
      IF g_sma.sma102 = 'Y' THEN
         SELECT ima926 INTO l_ima926 FROM ima_file
          WHERE ima01 = p_part
         IF l_ima926 ='Y' THEN
            LET l_pmh.pmh05='1'
         ELSE
            LET l_pmh.pmh05='0'
         END IF
      ELSE
         LET l_pmh.pmh05='0'
      END IF
      LET l_pmh.pmh06=NULL
      LET l_pmh.pmh10=NULL
      LET l_pmh.pmh11=0
      LET l_pmh.pmh12=p_price
      LET l_pmh.pmh19=pt_price
      LET l_pmh.pmh17=g_pmm21
      LET l_pmh.pmh18=g_pmm43
      LET l_pmh.pmh13=g_pmm22
      LET l_pmh.pmh14=g_pmm42
      LET l_pmh.pmh21=l_ecm04
      IF l_pmn011 <> 'SUB' THEN   #MOD-CC0264 add
         LET l_pmh.pmh22="1"
      #MOD-CC0264 -- add start --
      ELSE
         LET l_pmh.pmh22="2"
      END IF
      #MOD-CC0264 -- add end --
      LET l_pmh.pmh23 = ' '
      LET l_pmh.pmhacti='Y'
      LET l_pmh.pmhuser=g_user
      LET l_pmh.pmhgrup=g_grup
      LET l_pmh.pmhdate = g_today
      SELECT ima100,ima24,ima101,ima102
        INTO l_pmh.pmh09,l_pmh.pmh08,l_pmh.pmh15,l_pmh.pmh16
        FROM ima_file
       #WHERE ima01=p_part  #MOD-C30568 mark
       WHERE ima01=g_pnb04a #MOD-C30568 add
      IF cl_null(l_pmh.pmh13) THEN LET l_pmh.pmh13=' ' END IF
      LET l_pmh.pmhoriu = g_user
      LET l_pmh.pmhorig = g_grup
      LET l_pmh.pmh25 = 'N'
      INSERT INTO pmh_file VALUES (l_pmh.*)
      IF STATUS THEN
         LET g_success='N'
         IF g_bgerr THEN
            LET g_showmsg = l_pmh.pmh01,"/",l_pmh.pmh02,"/",l_pmh.pmh13,"/",l_pmh.pmh21,"/",l_pmh.pmh22
            CALL s_errmsg("pmh01,pmh02,pmh13,pmh21,pmh22",g_showmsg,"(apmp554:ins#)",SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("ins","pmh_file","","",STATUS,"","(apmp554:ins#)",1)
         END IF
      END IF
#MOD-B80242 -- end --
   END IF
END FUNCTION

#CHI-C30096---add---START
FUNCTION p910_upd_sopo()     
   DEFINE l_sql1         STRING
   DEFINE l_sql2         STRING 
   DEFINE l_plant        LIKE azp_file.azp01
   DEFINE l_pmn          RECORD LIKE pmn_file.*
   DEFINE l_currm        LIKE pmm_file.pmm42
   DEFINE l_price        LIKE oeb_file.oeb13
   DEFINE g_sw           LIKE type_file.chr1
   DEFINE l_last         LIKE type_file.num5
   DEFINE l_last_plant   LIKE azp_file.azp01
   DEFINE l_oea61        LIKE oea_file.oea61
   DEFINE l_oea1008      LIKE oea_file.oea1008
   DEFINE l_pmm40        LIKE pmm_file.pmm40
   DEFINE l_pmm40t       LIKE pmm_file.pmm40t
   DEFINE i,l_i          LIKE type_file.num5
   DEFINE l_pox03        LIKE pox_file.pox03    #計價基準
   DEFINE l_pox05        LIKE pox_file.pox05    #計價方式
   DEFINE l_pox06        LIKE pox_file.pox06    #計價比率
   DEFINE l_poy04        LIKE poy_file.poy04    #營運中心
   DEFINE l_cnt          LIKE type_file.num5
   DEFINE l_plant_now    LIKE azp_file.azp01
   DEFINE l_plant_up     LIKE type_file.chr10
   DEFINE l_plant_last   LIKE type_file.chr10
   DEFINE l_source       LIKE type_file.num5
   DEFINE l_dbs_up       LIKE type_file.chr21
   DEFINE l_dbs_last     LIKE type_file.chr21
   DEFINE l_dbs_now      LIKE type_file.chr21
   DEFINE u_pmm          RECORD LIKE pmm_file.*
   DEFINE u_pmn          RECORD LIKE pmn_file.*
   DEFINE u_oea          RECORD LIKE oea_file.*
   DEFINE u_oeb          RECORD LIKE oeb_file.*
   DEFINE n_pmm          RECORD LIKE pmm_file.*
   DEFINE n_pmn          RECORD LIKE pmn_file.*
   DEFINE l_azi          RECORD LIKE azi_file.*
   DEFINE l_poz          RECORD LIKE poz_file.*    #流程代碼資料(單頭)
      
      CALL s_mtrade_last_plant(g_pmm.pmm904) 
           RETURNING l_last,l_last_plant  #記錄最後一筆之家數

      #讀取三角貿易流程代碼資料
      SELECT * INTO l_poz.* FROM poz_file
       WHERE poz01 = g_pmm.pmm904
         AND poz00 = '2'
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
            LET g_showmsg = g_pmm.pmm904,"/","2"
            CALL s_errmsg("poz01,poz00",g_showmsg,"","axm-318",1)
      END IF
   
      #多角貿易計價方式為逆推時，從最後一站再回寫各站的單價
      IF NOT cl_null(g_pmm.pmm50) THEN    #要有最終供應商才需執行
         LET l_sql1 = "SELECT pmn_file.* ",
                      " FROM pmm_file,pmn_file ",
                      " WHERE pmm01 = pmn01 ",
                      "   AND pmm99 = '",g_pmm.pmm99,"'"
         
         CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1
         PREPARE pmn_gper FROM l_sql1
         DECLARE pmn_gcus CURSOR FOR pmn_gper
         
         FOR l_i = l_last TO 1 STEP -1
            
            LET l_oea61 = 0
            LET l_oea1008 = 0
            LET l_pmm40 = 0
            LET l_pmm40t = 0
         
            FOREACH pmn_gcus INTO l_pmn.* 
               IF SQLCA.SQLCODE <> 0 THEN
                  EXIT FOREACH 
               END IF 
         
               CALL s_pox(g_pmm.pmm904,l_i,l_pmn.pmn33)
                    RETURNING l_pox03,l_pox05,l_pox06,l_cnt
               IF l_cnt = 0 THEN
                  LET g_success = 'N'
                  IF g_bgerr THEN
                     CALL s_errmsg("","","s_pox1","tri-007",1)
                     CONTINUE FOREACH
                  ELSE
                     CALL cl_err3("","","","","tri-007","","s_pox1",1)
                     EXIT FOREACH
                  END IF
               END IF
         
               ##-------------取得上站資料------------
               LET l_source = l_i - 1
               SELECT poy04 INTO l_poy04 FROM poy_file 
                WHERE poy01 = l_poz.poz01
                  AND poy02 = l_source
               SELECT azp03 INTO l_dbs_up FROM azp_file   
                WHERE azp01 = l_poy04
                LET l_plant_up = l_poy04
               LET l_dbs_up = s_dbstring(l_dbs_up)
               
               ##-------------取得當站資料庫(S/O)-----------------
               SELECT poy04 INTO l_poy04 FROM poy_file 
                WHERE poy01 = g_pmm.pmm904
                  AND poy02 = l_i
               SELECT azp03 INTO l_dbs_now FROM azp_file 
                WHERE azp01 = l_poy04
               LET l_plant_now = l_poy04
               LET l_dbs_now = s_dbstring(l_dbs_now)
            
               ##-------------取得第終站資料庫(S/O)-----------------
               SELECT poy04 INTO l_poy04 FROM poy_file 
                WHERE poy01 = l_poz.poz01
                  AND poy02 = l_last 
               SELECT azp03 INTO l_dbs_last FROM azp_file 
                WHERE azp01 = l_poy04
               LET l_plant_last = l_poy04
               LET l_dbs_last = s_dbstring(l_dbs_last)
 
               IF l_pox03 = "1" OR l_pox03 = "2" THEN    #取價方式不為逆推，不需執行
                  CONTINUE FOR
               END IF
         
               CALL s_pox(g_pmm.pmm904,l_i-1,l_pmn.pmn33)  
                    RETURNING l_pox03,l_pox05,l_pox06,l_cnt
         
               IF l_pox03 = "3" THEN   #判斷是依最終廠商取價還是下游廠商取價
                  LET l_plant_new = l_plant_last 
                  LET l_sql1 = "SELECT pmm_file.*,pmn_file.* ",
                               "  FROM ",cl_get_target_table(l_plant_new,'pmm_file'),",",
                                         cl_get_target_table(l_plant_new,'pmn_file'),
                               " WHERE pmm01 = pmn01 ",
                               "   AND pmm99 = '",g_pmm.pmm99,"'",
                               "   AND pmn02 = ",l_pmn.pmn02
               ELSE
                  LET l_plant_new = l_plant_now
                  LET l_sql1 = "SELECT pmm_file.*,pmn_file.* ",
                               "  FROM ",cl_get_target_table(l_plant_new,'pmm_file'),",",
                                         cl_get_target_table(l_plant_new,'pmn_file'),
                               " WHERE pmm01 = pmn01 ",
                               "   AND pmm99 = '",g_pmm.pmm99,"'",
                               "   AND pmn02 = ",l_pmn.pmn02
               END IF
 	       CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1
               CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1
               PREPARE pmn_uper FROM l_sql1
               DECLARE pmn_ucus CURSOR FOR pmn_uper
         
               OPEN pmn_ucus
               FETCH pmn_ucus INTO n_pmm.*,n_pmn.*
               CLOSE pmn_ucus
         
               LET l_sql1 = "SELECT pmm_file.*,pmn_file.* ",
                            "  FROM ",cl_get_target_table(l_plant_up,'pmm_file'),",",
                                      cl_get_target_table(l_plant_up,'pmn_file'),
                            " WHERE pmm01 = pmn01 ",
                            "   AND pmm99 = '",g_pmm.pmm99,"'",
                            "   AND pmn02 = ",l_pmn.pmn02
               
               CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1
               CALL cl_parse_qry_sql(l_sql1,l_plant_up) RETURNING l_sql1
               PREPARE pmn_nper FROM l_sql1
               DECLARE pmn_ncus CURSOR FOR pmn_nper
         
               OPEN pmn_ncus
               FETCH pmn_ncus INTO u_pmm.*,u_pmn.*
               CLOSE pmn_ncus
         
               #計價方式來判斷
               IF l_pox05 = '1' THEN  #按比率
                  IF n_pmm.pmm22 = u_pmm.pmm22 THEN
                     LET u_pmn.pmn31 = n_pmn.pmn31 * l_pox06/100
                  END IF
                  IF g_pmm.pmm22 <> u_pmm.pmm22 THEN
                     LET l_price = n_pmn.pmn31 * n_pmm.pmm42 #換算回本幣
                     IF l_pox03 = "3" THEN                   #依最終廠商單價(逆推)
                        SELECT * INTO g_pod.* FROM pod_file WHERE pod00 = '0' #代採三角貿易使用匯率
                        CALL s_currm(u_pmm.pmm22,n_pmm.pmm04,g_pod.pod01,l_plant_now)
                           RETURNING l_currm
                     ELSE
                         CALL s_currm(u_pmm.pmm22,n_pmm.pmm04,g_pod.pod01,l_plant_up)
                            RETURNING l_currm
                     END IF
                     LET u_pmn.pmn31= l_price / l_currm * l_pox06 / 100
                  END IF
         
                  LET l_sql1 = "SELECT * ",
                               " FROM ",cl_get_target_table(l_plant_up,'azi_file'),         
                               " WHERE azi01='",n_pmm.pmm22,"' "
 	          CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1
                  CALL cl_parse_qry_sql(l_sql1,l_plant_up) RETURNING l_sql1
                  PREPARE azi_np1 FROM l_sql1
                  IF STATUS THEN
                     LET g_success = 'N'
                     IF g_bgerr THEN
                        CALL s_errmsg("","","azi_np1",STATUS,1)
                     ELSE
                        CALL cl_err3("","","","",STATUS,"","azi_np1",1)
                     END IF
                  END IF

                  DECLARE azi_nc1 CURSOR FOR azi_np1
                  OPEN azi_nc1
                  FETCH azi_nc1 INTO l_azi.* 
                  CLOSE azi_nc1
                  IF cl_null(l_azi.azi03) THEN 
                     LET l_azi.azi03=5
                  END IF
                  CALL cl_digcut(u_pmn.pmn31,l_azi.azi03) RETURNING u_pmn.pmn31
               END IF 
         
               IF u_pmn.pmn31 IS NULL THEN
                  LET u_pmn.pmn31 = 0
               END IF
               LET u_pmn.pmn31t = u_pmn.pmn31 * (1+u_pmm.pmm43/100)
         
               LET u_pmn.pmn44 = u_pmn.pmn31 * u_pmm.pmm42  #本幣單價=單價*匯率 
               CALL cl_digcut(u_pmn.pmn44,l_azi.azi03) RETURNING u_pmn.pmn44
 
               LET u_pmn.pmn88 = u_pmn.pmn87 * u_pmn.pmn31
               LET u_pmn.pmn88t = u_pmn.pmn87 * u_pmn.pmn31t
               CALL cl_digcut(u_pmn.pmn88,l_azi.azi04) RETURNING u_pmn.pmn88
               CALL cl_digcut(u_pmn.pmn88t,l_azi.azi04) RETURNING u_pmn.pmn88t
 
               #回寫當站採購單身
               LET l_sql2 = "UPDATE ",cl_get_target_table(l_plant_up,'pmn_file'),
                            "   SET pmn31 = ?,pmn31t = ? ,pmn44 = ?,",
                            "       pmn88 = ?,pmn88t = ? ",
                            " WHERE pmn01=? AND pmn02=? "
 	       CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
               CALL cl_parse_qry_sql(l_sql2,l_plant_up) RETURNING l_sql2
               PREPARE upd_npmn FROM l_sql2
               EXECUTE upd_npmn USING u_pmn.pmn31,u_pmn.pmn31t,u_pmn.pmn44,
                                      u_pmn.pmn88,u_pmn.pmn88t,
                                      u_pmn.pmn01,u_pmn.pmn02
               IF SQLCA.sqlcode THEN
                  IF g_bgerr THEN
                     CALL s_errmsg("","","upd upmn.",SQLCA.sqlcode,1)
                  ELSE
                     CALL cl_err3("","","","",SQLCA.sqlcode,"","upd upmn.",1)
                  END IF
                  LET g_success = 'N'
               END IF
         
               #採購單頭總金額
               LET l_pmm40 = l_pmm40 + u_pmn.pmn31 * u_pmn.pmn87
               CALL cl_digcut(l_pmm40,l_azi.azi04) RETURNING l_pmm40
               LET l_pmm40t = l_pmm40 * (1.00+u_pmm.pmm43 / 100.0)
               CALL cl_digcut(l_pmm40t,l_azi.azi04) RETURNING l_pmm40t
         
               LET l_sql1 = "SELECT oea_file.*,oeb_file.* ",
                            "  FROM ",cl_get_target_table(l_plant_now,'oea_file'),",",
                                      cl_get_target_table(l_plant_now,'oeb_file'),
                            " WHERE oea01 = oeb01 ",
                            "   AND oea99 = '",g_pmm.pmm99,"'",
                            "   AND oeb03 = ",l_pmn.pmn02
               
               CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1
               CALL cl_parse_qry_sql(l_sql1,l_plant_now) RETURNING l_sql1
               PREPARE oeb_nper FROM l_sql1
               DECLARE oeb_ncus CURSOR FOR oeb_nper
               
               OPEN oeb_ncus
               FETCH oeb_ncus INTO u_oea.*,u_oeb.*
               CLOSE oeb_ncus
               
               LET u_oeb.oeb13 = u_pmn.pmn31
               LET u_oeb.oeb17 = u_oeb.oeb13
               
               CALL cl_digcut(u_oeb.oeb13,l_azi.azi03) RETURNING u_oeb.oeb13
               CALL cl_digcut(u_oeb.oeb17,l_azi.azi03) RETURNING u_oeb.oeb17
               
               IF u_oea.oea213 = 'N' THEN              #表示不含稅
                  LET u_oeb.oeb14 = u_oeb.oeb917* u_oeb.oeb13
                  LET u_oeb.oeb14t= u_oeb.oeb14*(1+u_oea.oea211/100)
               ELSE
                  LET u_oeb.oeb13 = u_oeb.oeb13*(1+u_oea.oea211/100)
                  LET u_oeb.oeb14t= u_oeb.oeb917*u_oeb.oeb13
                  LET u_oeb.oeb14 = u_oeb.oeb14t/(1+u_oea.oea211/100)
               END IF
               
               CALL cl_digcut(u_oeb.oeb14,l_azi.azi04) RETURNING u_oeb.oeb14
               CALL cl_digcut(u_oeb.oeb14t,l_azi.azi04) RETURNING u_oeb.oeb14t
               
               #回寫下游訂單單身
               LET l_sql2 = "UPDATE ",cl_get_target_table(l_plant_now,'oeb_file'),
                            "   SET oeb13 = ?, oeb17 = ? , oeb14 = ?, oeb14t=? ",
                            " WHERE oeb01=? AND oeb03=? "
 	       CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
               CALL cl_parse_qry_sql(l_sql1,l_plant_up) RETURNING l_sql1
               PREPARE upd_noeb FROM l_sql2
               EXECUTE upd_noeb USING u_oeb.oeb13,u_oeb.oeb17,u_oeb.oeb14,u_oeb.oeb14t,
                                      u_oeb.oeb01,u_oeb.oeb03
               IF SQLCA.sqlcode THEN
                  IF g_bgerr THEN
                     CALL s_errmsg("","","upd uoeb.",SQLCA.sqlcode,1)
                  ELSE
                     CALL cl_err3("","","","",SQLCA.sqlcode,"","upd uoeb.",1)
                  END IF
                  LET g_success = 'N'
               END IF
               
               LET l_oea61 = l_oea61 + u_oeb.oeb14 
               CALL cl_digcut(l_oea61,l_azi.azi04) RETURNING l_oea61
               
            END FOREACH 
            
            #回寫下游訂單單頭
            LET l_sql2 = "UPDATE ",cl_get_target_table(l_plant_now,'oea_file'),
                         "   SET oea61 = ?, oea1008=?",
                         " WHERE oea01=? "
            DISPLAY l_sql2
 	    CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
            CALL cl_parse_qry_sql(l_sql1,l_plant_up) RETURNING l_sql1
            PREPARE upd_uoea FROM l_sql2
            EXECUTE upd_uoea USING l_oea61,l_oea1008,u_oea.oea01
            IF SQLCA.sqlcode THEN
               IF g_bgerr THEN
                  CALL s_errmsg("","","upd uoea.",SQLCA.sqlcode,1)
               ELSE
                  CALL cl_err3("","","","",SQLCA.sqlcode,"","upd uoea.",1)
               END IF
               LET g_success = 'N'
            END IF
         
            #回寫當站採購單頭
            LET l_sql2 = "UPDATE ",cl_get_target_table(l_plant_up,'pmm_file'),
                         "   SET pmm40 = ?, pmm40t=?",
                         " WHERE pmm01=? "
            CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
            CALL cl_parse_qry_sql(l_sql1,l_plant_up) RETURNING l_sql1
            PREPARE upd_upmm FROM l_sql2
            EXECUTE upd_upmm USING l_pmm40,l_pmm40t,u_pmm.pmm01
            IF SQLCA.sqlcode THEN
               IF g_bgerr THEN
                  CALL s_errmsg("","","upd upmm.",SQLCA.sqlcode,1)
               ELSE
                  CALL cl_err3("","","","",SQLCA.sqlcode,"","upd upmm.",1)
               END IF
               LET g_success = 'N'
            END IF
         
         END FOR
      END IF
END FUNCTION       
#CHI-C30096---add-----END
 
FUNCTION p910_upd_pmm()
 DEFINE l_total  LIKE pmn_file.pmn31,  #MOD-530190
        lt_total LIKE pmm_file.pmm40t  #No.FUN-610018
 DEFINE l_azi01  LIKE azi_file.azi01   #MOD-890011
 
  
   IF g_success='N' THEN
      CALL cl_err(' ','mfg9089',1)
      RETURN
   END IF
 
  SELECT SUM(pmn88),SUM(pmn88t)              #MOD-690092
    INTO l_total,lt_total
    FROM pmn_file
   WHERE pmn01=g_pna01
  SELECT pmm22 INTO l_azi01 FROM pmm_file WHERE pmm01 = g_pna01
  SELECT azi04 INTO t_azi04 FROM azi_file     
   WHERE azi01 = l_azi01  AND aziacti= 'Y'
  LET l_total= cl_digcut(l_total,t_azi04)
  LET lt_total= cl_digcut(lt_total,t_azi04)
  UPDATE pmm_file SET pmm03 = g_pna02,
                      pmm40 = l_total,
                      pmm40t = lt_total  #No.FUN-610018
   WHERE pmm01 = g_pna01
  IF SQLCA.SQLCODE THEN
     LET g_success = 'N'
     CALL cl_err3("upd","pmm_file",g_pna02,"",SQLCA.sqlcode,"","UPDATE pmm03",1)  #No.FUN-660129
     RETURN
  END IF
  IF SQLCA.SQLERRD[3] = 0 THEN
     LET g_success = 'N'
     CALL cl_err('(apmp910:ckp#99)','apm-963',1)   #FUN-640201
     RETURN
  END IF
END FUNCTION
 
FUNCTION p910_chk_pmm03()
  DEFINE l_dbs_new      LIKE type_file.chr21   #No.FUN-680136 VARCHAR(21)    #New DataBase Name
  DEFINE l_azp03        LIKE azp_file.azp03
  DEFINE l_last         LIKE type_file.num5    #No.FUN-680136 SMALLINT     #流程之最後家數
  DEFINE i              LIKE type_file.num5    #No.FUN-680136 SMALLINT
  DEFINE l_plant        LIKE azp_file.azp01    #No.FUN-680136 VARCHAR(10)
  DEFINE l_sql          LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(1000)
  DEFINE l_pmm904       LIKE pmm_file.pmm904
  DEFINE l_pmm03        LIKE pmm_file.pmm03
 
  LET l_pmm904=''
  LET l_azp03=''
  LET l_dbs_new=''
  LET l_last=''
  LET l_plant=' '
  LET l_pmm03=0
  SELECT pmm904 INTO l_pmm904 FROM pmm_file WHERE pmm01=g_pna01
  SELECT MAX(poy02) INTO l_last FROM poy_file WHERE poy01=l_pmm904
 
  #依流程代碼最多6層
  FOR i = 0 TO l_last - 1     #FUN-670007 
       IF g_success='N' THEN                                                                                                        
          LET g_totsuccess='N'                                                                                                      
          LET g_success="Y"                                                                                                         
       END IF                                                                                                                       
 
      SELECT poy04 INTO l_plant FROM poy_file
       WHERE poy01 = l_pmm904  AND poy02 = i
      SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01=l_plant
      LET l_dbs_new = s_dbstring(l_azp03)    #TQC-950010 ADD 
 
     LET g_plant_new = l_plant
     LET l_plant_new = g_plant_new 
     CALL s_gettrandbs()      
     LET l_dbs_tra = g_dbs_tra
 
      LET l_sql  = "SELECT pmm03 ",
                 # "  FROM ",l_dbs_tra CLIPPED,"pmm_file ",   #FUN-980092    #FUN-A50102 mark
                   "  FROM ",cl_get_target_table(l_plant_new,'pmm_file'),    #FUN-A50102    
                   " WHERE pmm99='",g_pmm.pmm99,"' "  #MOD-770034 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
 
      PREPARE pmm03_p1 FROM l_sql
      DECLARE pmm03_c1 CURSOR FOR pmm03_p1
      OPEN pmm03_c1
      FETCH pmm03_c1 INTO l_pmm03
      CLOSE pmm03_c1
      IF l_pmm03 <> g_pna02 THEN
         CALL s_errmsg('','',l_plant,'tri-031',0)
         UPDATE pna_file set pnaconf = 'N' 
          WHERE pna01 = 'g_pna01'  
         IF SQLCA.sqlcode THEN
             CALL s_errmsg('pna01','g_pna01','',SQLCA.sqlcode,1)
             LET g_success = 'N'
         END IF
      END IF
  END FOR
          IF g_totsuccess="N" THEN                                                                                                         
              LET g_success="N"                                                                                                             
          END IF                                                                                                                           
 
END FUNCTION
 
#在update完數量、單價與含稅單價後,update總金額與含稅總金額
FUNCTION p910_up_pmn88()
 DEFINE l_pmn87    LIKE pmn_file.pmn87,
        l_pmn31    LIKE pmn_file.pmn31,
        l_pmn31t   LIKE pmn_file.pmn31t,
        l_tot      LIKE pmn_file.pmn88,   #MOD-8A0019
        l_tott     LIKE pmn_file.pmn88t   #MOD-8A0019
 
     SELECT pmn87,pmn31,pmn31t INTO l_pmn87,l_pmn31,l_pmn31t
         FROM pmn_file
         WHERE pmn01 = g_pna01
           AND pmn02 = g_pnb03
     SELECT pmm21,pmm43 INTO g_pmm21,g_pmm43 FROM pmm_file   #MOD-950229 add
       WHERE pmm01 = g_pna01
    #SELECT azi04 INTO t_azi04 FROM azi_file               #MOD-CC0122 mark
     SELECT azi03,azi04 INTO t_azi03,t_azi04 FROM azi_file #MOD-CC0122 add
       WHERE azi01 IN 
         (SELECT pmm22 FROM pmm_file where pmm01=g_pna01)
     LET l_tot = cl_digcut(l_pmn87 * l_pmn31,t_azi04)
     LET l_tott = cl_digcut(l_pmn87 * l_pmn31t,t_azi04)
     #MOD-CC0122 add start -----
     SELECT gec07,gec05 INTO g_gec07,g_gec05
         FROM gec_file
        WHERE gec01 = g_pmm21
          AND gec011='1'  #進項
     IF SQLCA.sqlcode THEN               
        LET g_success = 'N'
        CALL cl_err3("sel","gec_file","","",SQLCA.sqlcode,"","",1) 
        RETURN
     END IF

     IF g_gec07 = 'N' THEN
        LET l_tott = l_tot * ( 1 + g_pmm43/100)
        LET l_tott = cl_digcut(l_tott,t_azi04)
     ELSE
        IF g_gec05 = 'T' THEN
           LET l_pmn31  = l_pmn31t* ( 1 - g_pmm43/100)
           LET l_pmn31  = cl_digcut(l_pmn31,t_azi03)
           LET l_tot  = l_tott * ( 1 - g_pmm43/100)
           LET l_tot  = cl_digcut(l_tot,t_azi04)
        ELSE
           LET l_tot  = l_tott / ( 1 + g_pmm43/100)
           LET l_tot  = cl_digcut(l_tot,t_azi04)
        END IF
     END IF
     #MOD-CC0122 add end   -----
     UPDATE pmn_file SET pmn88  = l_tot,
                         pmn88t = l_tott
          WHERE pmn01 = g_pna01
            AND pmn02 = g_pnb03
 
     IF SQLCA.SQLCODE THEN
        LET g_success = 'N'
        RETURN 
     END IF
     IF SQLCA.SQLERRD[3] = 0 THEN
        LET g_success = 'N'
        RETURN 
     END IF
END FUNCTION
#No:FUN-9C0071--------精簡程式-----
#No.FUN-A30056  --Begin                                                         
FUNCTION p901_call_p801_init()                                                  
   DROP TABLE p801_file;                                                        
   CREATE TEMP TABLE p801_file(                                                 
        p_no     LIKE type_file.num5,                                           
        so_no    LIKE pmm_file.pmm01,                                           
        so_item  LIKE type_file.num5,                                           
        so_price LIKE oeb_file.oeb13,
        so_price2 LIKE pmn_file.pmn31t, #TQC-D70073                                           
        so_curr  LIKE pmm_file.pmm22);                                          
   DELETE FROM p801_file;                                                       
END FUNCTION                                                                    
#No.FUN-A30056  --End 

#-----MOD-A70123---------
FUNCTION p910_apmp832_apmp822()   
   DEFINE l_i LIKE   type_file.num5,
          l_j LIKE   type_file.num5

   IF l_flag3 <> '1' OR cl_null(l_flag3) THEN 
      RETURN
   END IF
   IF g_rvu.getLength() = 0 THEN 
      RETURN
   END IF

   LET l_i = g_rvu.getLength()
   FOR l_j = 1 TO l_i
       LET g_cmd="apmp832 '",g_rvu[l_j].rvu01,"'"
       CALL cl_cmdrun_wait(g_cmd CLIPPED)
       LET g_cmd="apmp822 '",g_rvu[l_j].rvu01,"'"
       CALL cl_cmdrun_wait(g_cmd CLIPPED)
   END FOR
END FUNCTION
#-----END MOD-A70123-----

#-----MOD-A50209---------
FUNCTION p910_axmp901_axmp900()   
   DEFINE l_i LIKE   type_file.num5,
          l_j LIKE   type_file.num5
   DEFINE l_oeb      RECORD LIKE oeb_file.* #CHI-B60078 add
   DEFINE l_cnt      LIKE   type_file.num5  #CHI-B60078 add 
   DEFINE l_ogb03    LIKE ogb_file.ogb03    #CHI-B60078 add
   DEFINE l_ogb31    LIKE ogb_file.ogb31    #CHI-B60078 add
   DEFINE l_ogb32    LIKE ogb_file.ogb32    #CHI-B60078 add
   DEFINE l_oga21    LIKE oga_file.oga21 #MOD-DB0141
   DEFINE l_oga23    LIKE oga_file.oga23   #MOD-DB0141
   DEFINE l_oga211   LIKE oga_file.oga211 #MOD-DB0141
   DEFINE l_oga213   LIKE oga_file.oga213 #MOD-DB0141
   DEFINE l_ogb917   LIKE ogb_file.ogb917, #MOD-DB0141
          l_ogb14,l_ogb14t LIKE ogb_file.ogb14,
          l_oga50,l_oga51 LIKE oga_file.oga50,
          l_oga011   LIKE oga_file.oga011

   IF l_flag3 <> '1' OR cl_null(l_flag3) THEN 
      RETURN
   END IF
   #-----MOD-A60114---------
   IF g_oga.getLength() = 0 THEN 
      RETURN
   END IF
   #-----END MOD-A60114-----

   LET g_dbs_old = g_dbs
   LET g_dbs = g_oga[1].dbs 
   CALL cl_ins_del_sid(2,'')               #MOD-B80242 add
   CLOSE DATABASE
   DATABASE g_dbs
   CALL cl_ins_del_sid(1,g_oga[1].plant)   #MOD-B80242 add
   LET l_i = g_oga.getLength()
   FOR l_j = 1 TO l_i
       LET g_cmd="axmp901 '",g_oga[l_j].oga01,"' '6' "
       CALL cl_cmdrun_wait(g_cmd CLIPPED)
       SELECT oga21,oga23,oga211,oga213 INTO l_oga21,l_oga23,l_oga211,l_oga213 FROM oga_file
        WHERE oga01 = g_oga[l_j].oga01
       #CHI-B60078 add --start--
#MOD-DB0141 mark begin---------       
#       DECLARE ogb_curs CURSOR FOR
#         SELECT ogb03,ogb31,ogb32 FROM ogb_file 
#          WHERE ogb01 = g_oga[l_j].oga01 
#       FOREACH ogb_curs INTO l_ogb03,l_ogb31,l_ogb32
#          SELECT oeb_file.* INTO l_oeb.* 
#            FROM oeb_file 
#           WHERE oeb01 = l_ogb31 
#             AND oeb03 = l_ogb32 
#
#          UPDATE ogb_file 
#             SET ogb13  = l_oeb.oeb13 , 
#                 ogb14  = l_oeb.oeb14 , 
#                 ogb14t = l_oeb.oeb14t
#           WHERE ogb01 = g_oga[l_j].oga01 
#             #AND ogb32 = l_ogb03
#             AND ogb03 = l_ogb03 #MOD-DB0141
#MOD-DB0141 mark end---------------
#MOD-DB0141 add begin---------------更新出货单单身单价和金额
       DECLARE ogb_curs CURSOR FOR
         SELECT ogb03,ogb31,ogb32,ogb917 FROM ogb_file 
          WHERE ogb01 = g_oga[l_j].oga01 
       FOREACH ogb_curs INTO l_ogb03,l_ogb31,l_ogb32,l_ogb917
          SELECT oeb_file.* INTO l_oeb.* 
            FROM oeb_file 
           WHERE oeb01 = l_ogb31 
             AND oeb03 = l_ogb32
         SELECT azi04 INTO t_azi04 FROM azi_file
          WHERE azi01=l_oga23 AND aziacti ='Y'             
         IF l_oga213 = 'N' THEN
            LET l_ogb14 = l_ogb917 * l_oeb.oeb13
            LET l_ogb14t = l_ogb14 * ( 1 + l_oga211/100)
            LET l_ogb14t = cl_digcut(l_ogb14t,t_azi04) 
         ELSE
            LET l_ogb14t = l_ogb917 * l_oeb.oeb13
            LET l_ogb14 = l_ogb14t / ( 1 + l_oga211/100)
            LET l_ogb14 = cl_digcut(l_ogb14t,t_azi04)             
         END IF 
         UPDATE ogb_file 
             SET ogb13  = l_oeb.oeb13 , 
                 ogb14  = l_ogb14 , 
                 ogb14t = l_ogb14t
           WHERE ogb01 = g_oga[l_j].oga01 
             #AND ogb32 = l_ogb03
             AND ogb03 = l_ogb03 #MOD-DB0141                                           
#MOD-DB0141 add end-----------------             
          IF SQLCA.SQLCODE THEN
             LET g_success = 'N'
             EXIT FOREACH
          END IF
#MOD-DB0141 add begin---------------
          SELECT SUM(ogb14),SUM(ogb14t) INTO l_oga50,l_oga51 FROM ogb_file WHERE ogb01 = g_oga[l_j].oga01
          CALL cl_digcut(l_oga50,t_azi04) RETURNING l_oga50
          CALL cl_digcut(l_oga51,t_azi04) RETURNING l_oga51  
          IF cl_null(l_oga50) THEN LET l_oga50 = 0 END IF
          IF cl_null(l_oga51) THEN LET l_oga51 = 0 END IF
          UPDATE oga_file SET oga51 = l_oga51,
                              oga50 = l_oga50
          WHERE oga01 =  g_oga[l_j].oga01   
          IF SQLCA.SQLCODE THEN
             LET g_success = 'N'
             EXIT FOREACH
          END IF                                 
#MOD-DB0141 add end-----------------  
#MOD-DB0141 add begin---------------
#如果存在出通单，则更新对应出通单的资料
          SELECT oga011 INTO l_oga011 FROM oga_file WHERE oga01 = g_oga[l_j].oga01
          SELECT COUNT(*) INTO l_cnt  FROM oga_file
           WHERE oga01 = l_oga011
             AND oga09 = '5'
             AND ogaconf <> 'X'
          IF l_cnt > 0 THEN 
             DECLARE ogb_curs2 CURSOR FOR
               SELECT ogb03,ogb31,ogb32,ogb917 FROM ogb_file 
                WHERE ogb01 = l_oga011 
             FOREACH ogb_curs2 INTO l_ogb03,l_ogb31,l_ogb32,l_ogb917
                SELECT oeb_file.* INTO l_oeb.* 
                  FROM oeb_file 
                 WHERE oeb01 = l_ogb31 
                   AND oeb03 = l_ogb32
               SELECT azi04 INTO t_azi04 FROM azi_file
                WHERE azi01=l_oga23 AND aziacti ='Y'             
               IF l_oga213 = 'N' THEN
                  LET l_ogb14 = l_ogb917 * l_oeb.oeb13
                  LET l_ogb14t = l_ogb14 * ( 1 + l_oga211/100)
                  LET l_ogb14t = cl_digcut(l_ogb14t,t_azi04) 
               ELSE
                  LET l_ogb14t = l_ogb917 * l_oeb.oeb13
                  LET l_ogb14 = l_ogb14t / ( 1 + l_oga211/100)
                  LET l_ogb14 = cl_digcut(l_ogb14t,t_azi04)             
               END IF 
               UPDATE ogb_file 
                   SET ogb13  = l_oeb.oeb13 , 
                       ogb14  = l_ogb14 , 
                       ogb14t = l_ogb14t
                 WHERE ogb01 = l_oga011 
                   #AND ogb32 = l_ogb03
                   AND ogb03 = l_ogb03 #MOD-DB0141                                           
      #MOD-DB0141 add end-----------------             
                IF SQLCA.SQLCODE THEN
                   LET g_success = 'N'
                   EXIT FOREACH
                END IF
      #MOD-DB0141 add begin---------------
                SELECT SUM(ogb14),SUM(ogb14t) INTO l_oga50,l_oga51 FROM ogb_file WHERE ogb01 = l_oga011
                CALL cl_digcut(l_oga50,t_azi04) RETURNING l_oga50
                CALL cl_digcut(l_oga51,t_azi04) RETURNING l_oga51  
                IF cl_null(l_oga50) THEN LET l_oga50 = 0 END IF
                IF cl_null(l_oga51) THEN LET l_oga51 = 0 END IF
                UPDATE oga_file SET oga51 = l_oga51,
                                    oga50 = l_oga50
                WHERE oga01 =  l_oga011   
                IF SQLCA.SQLCODE THEN
                   LET g_success = 'N'
                   EXIT FOREACH
                END IF
             END FOREACH                  
          END IF      
#MOD-DB0141 add end-----------------  
         
       END FOREACH
       #CHI-B60078 add --end--

       LET g_cmd="axmp900 '",g_oga[l_j].oga01,"' '6' "
       CALL cl_cmdrun_wait(g_cmd CLIPPED)
   END FOR
   CALL cl_ins_del_sid(2,'')
   CLOSE DATABASE
   LET g_dbs = g_dbs_old
   DATABASE g_dbs
   CALL cl_ins_del_sid(1,g_plant)          #MOD-B80242 add
END FUNCTION
#-----END MOD-A50209-----
