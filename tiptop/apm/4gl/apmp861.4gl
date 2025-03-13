# Prog. Version..: '5.30.06-13.03.20(00010)'     #
#
# Pattern name...: apmp861.4gl    
# Descriptions...: 自動產生應收帳款副程式(多工廠)
# Date & Author..: 02/10/23 By Kammy
# Notes..........: copy from axmp861
# Modify.........: No.7801 03/08/18 Kammy oga53 應該不可在拋轉應收時再重算一次
# Modify.........: No.7942 03/08/22 Kammy Default apa74 = 'N'否則有些報表印不出
# Modify.........: No.8506 03/10/16 rdatem 傳 oma09
# Modify.........: No.9740 04/07/12 類別科目=STOCK時,依參數ccz07抓取對應會科
# Modify.........: No.FUN-4C0011 04/12/01 By Mandy 單價金額位數改為dec(20,6)
# Modify.........: No.MOD-540126 05/04/20 By kim 單身部份料號跟品名都是料號
# Modify.........: No.FUN-550060 05/05/30 By Will 單據編號放大
# Modify.........: NO.FUN-560043 05/06/29 By Smapmin 根據雙單位做調整,多角序號放大,單號放大
# Modify.........: No.MOD-620081 06/02/27 By pengu  原幣取位有誤, 於程式第981,983行處應為p_azi,不應是s_azi
# Modify.........: No.MOD-630038 06/03/09 By Mandy SQL語法錯誤
# Modify.........: No.FUN-630036 06/03/28 By pengu 拋轉如出現問題,作錯誤訊息的改善
# Modify.........: NO.FUN-640196 06/04/17 BY yiting 匯率以立帳日+參數抓取 
# Modify.........: No.MOD-660042 06/06/21 By Pengu 判斷若立帳對象為關係人時,實科目必須存入 對象代號
# Modify.........: No.FUN-670026 06/07/25 By Tracy 應收銷退合并
# Modify.........: No.FUN-680022 06/08/29 By Tracy s_rdatem()增加一個訂單日的參數 
# Modify.........: No.FUN-680136 06/09/07 By Jackho 欄位類型修改
# Modify.........: NO.FUN-660068 06/09/20 BY yiting 專案編號(pmn122) 寫入 應付(apa66)  ,只寫入本地端單據
# Modify.........: NO.FUN-670079 06/09/25 BY yiting 拋轉時apa12/apa64要先處理好應收款日及到期日
# Modify.........: NO.TQC-680089 06/09/25 BY yiting 判斷客戶編號若為關係人則將該客戶代號寫入關係人異動碼
# Modify.........: NO.FUN-6A0026 06/10/12 BY bnlent 多角貿易AP，AR拋轉應有兩帳套功能
# Modify.........: NO.FUN-690012 06/10/23 BY rainy  omb33<--oba11
# Modify.........: NO.TQC-6A0084 06/12/05 By Nicola 含稅金額、未稅金額調整
# Modify.........; NO.FUN-670007 06/12/20 BY yiting 1.3.5x版三角調整
#                                06/12/27 by Yiting 2.FUN-6A0026 要注意一下，加入了參數(0/1) 包在判斷式裡的東西要跟著變
# Modify.........: No.FUN-730033 07/03/27 By Carrier 會計科目加帳套
# Modify.........: NO.TQC-760097 07/06/21 BY yiting pmm901->pmm01
# Modify.........: No.MOD-780037 07/08/07 By claire ogb60需回寫
# Modify.........: No.TQC-760158 07/08/17 By claire 變數應由pmm01->pmm99
# Modify.........: No.CHI-760003 07/08/22 By wujie  新增多角貿易拋轉異動碼，摘要預設
# Modify.........: No.MOD-780090 07/09/06 By claire oma24回寫oga24需考慮ooz10的參數設定
# Modify.........: No.TQC-7B0083 07/11/23 By Carrier apb34給default值'N'
# Modify.........: No.TQC-7C0019 07/12/06 By zhangmin 產生的應收應付資料未同時產生多帳期資料
# Modify.........: No.TQC-7C0107 07/12/08 By Rayven 應付帳款無法拋轉
# Modify.........: No.MOD-7C0100 07/12/17 By claire aap-262訊息調整
# Modify.........: No.MOD-7C0183 07/12/26 By claire ins_omc omc08,omc09,omc13給值
# Modify.........: No.MOD-810015 08/01/03 By claire 單別於axri010建檔刪除後,應控卡不可產生拋轉
# Modify.........: No.MOD-810245 08/01/29 By claire oma59,oma59t,oma59x需四捨五入
# Modify.........: No.MOD-820015 08/02/12 By claire oma54,oma54t,oma54x應取p_azi.*(原幣)而非s_azi.*(本幣)
# Modify.........: No.MOD-820101 08/02/20 By claire apc08應取l_azi(原幣);apc09,apc13應取s_azi(本幣)
# Modify.........: No.MOD-820171 08/02/27 By claire 最終供應商的AP沒有(apa22)部門及採購單號(apb06,apb07,apb26)
# Modify.........: No.CHI-820013 08/02/28 By claire (1)關係人取值應先取設定檔(agli120)若空值時再判斷aag371的設定
#                                                   (2)帳別傳入值的調整
# Modify.........: No.MOD-830250 08/03/31 By claire 調整MOD-820171 
# Modify.........: No.MOD-840688 08/04/29 By chenl  修正付款客戶簡稱及收款客戶簡稱未能帶出的問題。
# Modify.........: No.MOD-860322 08/06/28 By claire 若沒有多帳別時,AP的npq未寫入                   
# Modify.........: No.TQC-870023 08/07/15 By lumx   給oma51,oma51f,oma65賦初值
# Modify.........: No.MOD-870216 08/07/17 By claire apa57應由apa31給值
# Modify.........: No.MOD-880021 08/08/07 By claire 邏輯調整
# Modify.........: No.MOD-880034 08/08/07 By claire 只納入入庫單據
# Modify.........: No.TQC-830015 08/03/13 By lumx 在做代采多角貿易應收/應付拋轉作業時產生應付時原幣金額重復扣稅 
# Modify.........: No.CHI-890007 08/09/08 By claire 調整omb16,omb16t的公式
# Modify.........: No.CHI-8A0026 08/10/22 By claire apb25,apb251 會科來源不取自pmn40,pmn401
# Modify.........: No.FUN-860013 08/10/27 By xiaofeizhu 以INSERT INTO的database 抓到的異動碼(aag15~aag37)寫入拋轉分錄中
# Modify.........: No.MOD-8A0240 08/10/30 By claire 以poy19取代pmm14使用
# Modify.........: No.MOD-8B0239 08/11/24 By sherry 如果是樣品則單價為0
# Modify.........: No.CHI-8C0034 09/01/13 By jamie 統一由s_def_npq_m取值，不重取aag15
# Modify.........: No.CHI-8C0039 09/02/12 By ve007 預設oma65,oma66 的值
# Modify.........: No.MOD-920190 09/02/13 By claire l_qty定義錯誤
# Modify.........: No.MOD-910100 09/02/23 By liuxqa 調整MOD-830250,在324行判斷p_pmm.pmm50是否為空，首先要給其賦值。
# Modify.........: No.MOD-940111 09/04/08 By Dido oma64 給予預設值 '0'
# Modify.........: No.CHI-930047 09/04/09 By Dido 比對 axmp841 改善尾差問題 CHI-870032
# Modify.........: No.MOD-940211 09/04/15 By Dido 調整 apa63 = '1''
# Modify.........: No.MOD-920266 09/04/26 By Dido apb930/omb930 給予預設值
# Modify.........: NO.CHI-920010 09/04/29 BY ve007 1.產生ap分錄底稿應要判斷單別是否有要拋總帳
                                                  #2.ap分錄底稿產生后，應要判斷底稿的正確性
                                                  #3.多角還原時，應判斷單據是否產生底稿在決定刪除
# Modify.........: No.MOD-950030 09/05/10 By Dido 預設 oma67 為 oga27
# Modify.........: No.TQC-950010 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring()
# Modify.........: No.MOD-960247 09/06/22 BY Dido 尾差金額取位;若為不申報 omb18 也應為 0
# Modify.........: No.MOD-960273 09/06/27 BY Dido 取消客戶分類科目抓取;oma64 給予預設值 '1'
# Modify.........: No.FUN-960141 09/06/30 By dongbg GP5.2修改:INSERT INTO時給xxxplant賦值
# Modify.........: No.MOD-970047 09/07/09 BY Dido omc08,omc09的金額依多帳期的收款比率來產生
# Modify.........: No:MOD-970186 09/07/22 BY Dido 逆拋 apa08 預設為 oga27 
# Mofify.........: No.FUN-980020 09/08/18 By douzh 集團架構調整
# Modify.........: No.MOD-980233 09/08/27 By Dido oma09 預設值應為 oma02
# Modify.........: No.FUN-980006 09/08/31 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-980276 09/09/02 By Dido s_chknpq3 傳遞參數應為當下營運中心(plant)
# Modify.........: No.FUN_980059 09/09/08 By arman   修改SUB傳入相關參數
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980025 09/09/23 By dxfwo GP集團架構修改,sub相關參數
# Modify.........: No.MOD-9A0097 09/10/16 By Dido 增加異動碼 5-10 
# Modify.........: No:MOD-9A0163 09/10/28 By Dido 調整不申報時比對發票金額檢核問題 
# Modify.........: No:TQC-9A0154 09/10/28 By Dido 未稅金額計算判斷調整 
# Modify.........: No.FUN-9A0099 09/10/29 By TSD.apple   GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No:CHI-9B0023 09/11/20 By Dido 參考 oea18 設定立帳與發票匯率 
# Modify.........: No:TQC-9B0013 09/11/27 By Dido 單別於建檔刪除後,應控卡不可產生拋轉
# Modify.........: No:MOD-A10031 10/01/07 By Dido omb17 計算邏輯調整 
# Modify.........: No.TQC-A10060 10/01/11 By wuxj   修改INSERT INTO加入oriu及orig這2個欄位
# Modify.........: No:FUN-9C0071 10/01/14 By huangrh 精簡程式
# Modify.........: No:CHI-9A0008 10/01/22 By Dido 正拋 apa08 預設為 rvb22 僅來源站 
# Modify.........: No:MOD-A20071 10/02/10 By Dido 無最終供應商無須抓取 pmm_file
# Modify.........: No:MOD-A20110 10/02/26 By Smapmin 修正MOD-950030
# Modify.........: No:MOD-A30020 10/03/04 By Smapmin 變數使用錯誤
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26* 
# Modify.........: No:MOD-A40029 10/04/07 By Smapmin 修改幣別位數取位
# Modify.........: No:MOD-A40028 10/04/07 By Smapmin  調整omb18,omb18t的公式
# Modify.........: No:MOD-A50182 10/05/30 By Smapmin 將CALL s_paydate()還原回CALL s_paydate_m()
# Modify.........: No:FUN-A60024 10/06/12 By wujie   新增apa79，预设值为0
# Modify.........: No.FUN-A50102 10/07/21 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:MOD-A70070 10/07/29 By Smapmin CHI-990020追單
# Modify.........: No:MOD-A50181 10/07/30 By Smapmin 修改出口報單號碼抓取
# Modify.........: No:TQC-A70127 10/08/04 By lilingyu insert apc_file时,报错:将NULL值插入到非空字段 
# Modify.........: No.FUN-950053 10/08/17 By vealxu 廠商基本資料的關係人設定搭配異動碼彈性設定
# Modify.........: No:FUN-AB0034 10/12/16 By wujie   oma73/oma73f预设0
# Modify.........: No:MOD-AC0419 10/12/30 By lilingyu 分錄單頭npp06沒有賦值,導致多角倉退拋磚時,來源營運中心的值無法抓取
# Modify.........: No:MOD-AC0337 11/01/18 By Smapmin 正拋時,apa09應抓取rvw02
# Modify.........: No:MOD-AC0129 11/01/18 By Smapmin 修改SQL語法
# Modify.........: No:CHI-AC0043 11/01/25 By Smapmin oga27要抓取下一站的資料
# Modify.........: No.FUN-AA0087 11/01/28 By chenmoyan 異動碼類型設定改善
# Modify.........: No.MOD-B10237 11/01/30 By lilingyu 多角拋轉的應收單據和應付單據的稅前金額不一致
# Modify.........: No:MOD-B20013 11/02/09 By Summer oma35~oma38要給oga35~oga38
# Modify.........: No:MOD-B20058 11/02/16 By Summer 考慮帳款關帳日
# Modify.........: No:MOD-B30012 11/03/07 By Summer 1.oba11依營運中心抓取 2.科目二的邏輯也要一併調整
#                                                   3.多角分錄底稿的部份by單身不同的會科做group之後產生貸方銷售收入的科目 
# Modify.........: No:MOD-B30200 11/03/18 By chenying 角代採正拋/逆拋有误---->l_p_dbs為空所致
# Modify.........: No:MOD-B30704 11/04/14 By Smapmin 產生帳款時,單頭金額與單身總金額不符
# Modify.........: No:MOD-B40190 11/04/25 By Summer 單價不含稅時,本幣未稅apa31/原幣未稅apa31f,不應將稅額也算進來
# Modify.........: No:MOD-B60121 11/06/15 By Summer apmp860無法產生最後一站的帳款
# Modify.........: NO.CHI-B40063 11/07/04 BY Summer 金額為0不產生分錄,整張帳款金額為0時不做分錄的檢核
# Modify.........: No:CHI-B50022 11/07/07 By Summer 多角代採正拋進項發票抓取規則 
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料
# Modify.........: NO:MOD-B80007 11/08/10 BY Summer 逆拋時oga08是預設為抓oga27,改為當oga27抓不到時,再抓rvb22 
# Modify.........: NO:MOD-BB0134 12/02/03 BY Summer MOD-AC0337抓apa09時應先給NULL再取值,避免存放99/12/31 
# Modify.........: NO:MOD-BB0279 12/02/03 BY Summer FUN-640196匯率以立帳日+參數抓取修改時mark漏了 
# Modify.........: No:CHI-BC0008 12/02/03 By Summer 調整AP尾差問題 
# Modify.........: No.MOD-C30815 12/03/22 By SunLM  單價含稅時,不使用單價*數量=金額,改以含稅金額回推稅率,以避免小數位差的問題
# Modify.........: No.MOD-C30909 12/03/30 By Vampire 調整 MOD-C30815修改錯誤
# Modify.........: No.MOD-C60074 12/06/20 By Vampire 應收應付出現分錄底稿借貸不平
# Modify.........: No:MOD-C60196 12/06/27 By Vampire CALL s_rdatem的第二個參數l_omc03調整為l_omc.omc03
# Modify.........: No:MOD-C70105 12/07/09 By SunLM   調整本幣原幣稅額誤差 
# Modify.........: No:MOD-C80072 12/09/03 By Vampire apb10為本幣金額應該用s_azi取位
# Modify.........: No:TQC-C90045 12/09/17 By SunLM   調整本幣原幣稅額税额算法,暂时还原MOD-C70105修改
# Modify.........: No:CHI-C60004 12/11/07 By Sakura 拋轉新增apa77欄位處理
# Modify.........: No:TQC-D30046 13/03/20 By SunLM 多角銷退的收入科目需要考慮oba11
# Modify.........: No.FUN-D40103 13/05/08 By fengrui 抓ime_file資料添加imeacti='Y'條件

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE p_oma RECORD LIKE oma_file.*
DEFINE p_omb RECORD LIKE omb_file.*
DEFINE p_oga RECORD LIKE oga_file.*
DEFINE p_ogb RECORD LIKE ogb_file.*
DEFINE p_rva RECORD LIKE rva_file.*   
DEFINE p_rvu RECORD LIKE rvu_file.*  
DEFINE s_rvv RECORD LIKE rvv_file.*    #來源廠入庫單身
DEFINE p_rvv RECORD LIKE rvv_file.*
DEFINE s_azi RECORD LIKE azi_file.*    #本幣用
DEFINE p_azi RECORD LIKE azi_file.*    #AR用
DEFINE l_azi RECORD LIKE azi_file.*    #AP用
DEFINE p_pmm RECORD LIKE pmm_file.*
DEFINE p_pmn RECORD LIKE pmn_file.*
DEFINE p_pma RECORD LIKE pma_file.*
DEFINE p_aza RECORD LIKE aza_file.*
DEFINE p_apz RECORD LIKE apz_file.*
DEFINE p_ooz RECORD LIKE ooz_file.*
DEFINE p_ool RECORD LIKE ool_file.*
DEFINE p_gec RECORD LIKE gec_file.*
DEFINE p_npp RECORD LIKE npp_file.*
DEFINE p_npq RECORD LIKE npq_file.*
DEFINE p_apa RECORD LIKE apa_file.*
DEFINE p_apb RECORD LIKE apb_file.*
DEFINE p_pmc RECORD LIKE pmc_file.*
DEFINE p_ooy RECORD LIKE ooy_file.*      #No.CHI-920010
DEFINE p_apy RECORD LIKE apy_file.*      #No.CHI-920010
DEFINE p_npptype LIKE npp_file.npptype        #No.FUN-6A0026
DEFINE p_oga01      LIKE oga_file.oga01
DEFINE p_rvu01      LIKE rvu_file.rvu01
DEFINE p_pmm01      LIKE pmm_file.pmm01        #TQC-760097
DEFINE p_pmm99      LIKE pmm_file.pmm99        #TQC-760158 add
#DEFINE un_gui_qty   LIKE ima_file.ima26        #No.FUN-680136 DEC(15,3) #FUN-A20044
DEFINE un_gui_qty   LIKE type_file.num15_3     #FUN-A20044
DEFINE p_apa31f     LIKE apa_file.apa31f       #記錄採購單身出貨金額(原幣)
DEFINE p_apa31      LIKE apa_file.apa31        #記錄採購單身出貨金額(本幣)
DEFINE exT          LIKE type_file.chr1        #No.FUN-680136 VARCHAR(1)                    #匯率採用方式 (S.銷售 C.海關)
DEFINE p_poy20      LIKE poy_file.poy20,       #營業額申報方式
       p_poy18      LIKE poy_file.poy18,       #AR部門
       p_poy19      LIKE poy_file.poy19        #AP部門
DEFINE p_poy16      LIKE poy_file.poy16        #AR帳款分類
DEFINE p_poy17      LIKE poy_file.poy17        #AP帳款分類
DEFINE p_poz011     LIKE poz_file.poz011       #AP帳款分類
DEFINE s_dbs        LIKE type_file.chr21       #No.FUN-680136 VARCHAR(21)                   #來源資料庫
DEFINE p_dbs        LIKE type_file.chr21       #No.FUN-680136 VARCHAR(21)                   #資料庫名稱
DEFINE p_dbs_tra    LIKE type_file.chr21       #No.FUN-980020                               #資料庫名稱
DEFINE g_buf        LIKE type_file.chr8        #No.FUN-680136 VARCHAR(8)
DEFINE p_poy12      LIKE poy_file.poy12        #發票別
DEFINE p_last_plant LIKE poy_file.poy04        #出貨工廠
DEFINE p_last_dbs   LIKE type_file.chr21       #No.FUN-680136 VARCHAR(21)
DEFINE p_flow99     LIKE apa_file.apa99        #No.FUN-680136 VARCHAR(17)   #FUN-560043
DEFINE g_sw         LIKE type_file.chr1        #No.FUN-680136 VARCHAR(1)
DEFINE l_sql        LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(600)
       l_sql1       LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(1200)
       l_sql2       LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(600)
       l_sql3       LIKE type_file.chr1000  #No.MOD-910100 add by liuxqa 
DEFINE g_ima906     LIKE ima_file.ima906   #FUN-560043
DEFINE p_oga24      LIKE oga_file.oga24    #MOD-780090 add
DEFINE p_i          LIKE type_file.num5    #FUN-670007
DEFINE p_poy02      LIKE poy_file.poy02    #FUN-670007
DEFINE p_poz18      LIKE poz_file.poz18    #FUN-670007
DEFINE g_bookno1    LIKE aza_file.aza81    #No.FUN-730033
DEFINE g_bookno2    LIKE aza_file.aza82    #No.FUN-730033
DEFINE g_flag       LIKE type_file.chr1    #No.FUN-730033
DEFINE p_aag371     LIKE aag_file.aag371   #CHI-820013
DEFINE p_plant      LIKE type_file.chr10   #FUN-980020
DEFINE ls_sql       LIKE type_file.chr1000 #No.FUN-980020
DEFINE s_plant      LIKE type_file.chr10   #CHI-AC0043
#DEFINE p_apa32f     LIKE apa_file.apa32f   #MOD-C70105 #記錄採購單身出貨稅額(原幣)
#DEFINE p_apa32      LIKE apa_file.apa32    #MOD-C70105 #記錄採購單身出貨稅額(本幣) 
#出貨單號,帳款日,資料庫名稱
DEFINE   g_msg           LIKE ze_file.ze03  #No.FUN-680136 VARCHAR(72)


FUNCTION apmp861(t_rvu01,p_oma02,l_poy20,l_poy16,l_poy17,
                 l_plant,l_poy12,l_last_plant,                           #FUN-980020
                 l_poy18,l_poy19,l_poz011,l_pmm99,l_flow99,AR_t1,AP_t1,  #TQC-760158 pmm01->pmm99 
                 l_rvu01,l_oga01,l_plant_new)   #CHI-AC0043 add l_plant_new
  DEFINE t_rvu01      LIKE rvu_file.rvu01        #入庫單號(來源)
  DEFINE l_rvu01      LIKE rvu_file.rvu01        #入庫單號(各站)
  DEFINE l_oga01      LIKE oga_file.oga01        #入庫單號
  DEFINE p_oma02      LIKE oma_file.oma02        #立帳日期
  DEFINE l_dbs        LIKE type_file.chr21       #No.FUN-680136 VARCHAR(21)                   #資料庫名稱
  DEFINE l_dbs_tra    LIKE type_file.chr21       #No.FUN-980020 VARCHAR(21)                   #資料庫名稱
  DEFINE l_plant      LIKE type_file.chr10       #No.FUN-980020
  DEFINE l_poy20      LIKE poy_file.poy20,       #營業額申報方式
         l_poy18      LIKE poy_file.poy18,       #AR部門
         l_poy19      LIKE poy_file.poy19        #AP部門
  DEFINE l_poy16      LIKE poy_file.poy16        #AR帳款分類
  DEFINE l_poy17      LIKE poy_file.poy17        #AP帳款分類
  DEFINE l_poz011     LIKE poz_file.poz011       #1.正拋 2.逆拋
  DEFINE l_pmm01      LIKE pmm_file.pmm01        #採購單號    
  DEFINE l_poy12      LIKE poy_file.poy12        #發票別
  DEFINE l_pmm42      LIKE pmm_file.pmm42
  DEFINE l_pmm99      LIKE pmm_file.pmm99        #多角序號    #TQC-760158 
  DEFINE l_flow99     LIKE pmm_file.pmm99        #多角序號 
  DEFINE l_last_plant LIKE poy_file.poy04        #出貨工廠
  DEFINE AR_t1,AP_t1  LIKE type_file.chr5     #No.FUN-680136 VARCHAR(05)                   #No.FUN-550060 
  DEFINE li_result    LIKE type_file.num5     #FUN-560043  #No.FUN-680136 SMALLINT
  DEFINE l_poy02      LIKE poy_file.poy02     #FUN-670007
  DEFINE l_i          LIKE type_file.num5     #FUN-670007
  DEFINE l_poz18      LIKE poz_file.poz18     #FUN-670007
  DEFINE l_plant_new  LIKE type_file.chr10    #CHI-AC0043
  DEFINE l_oma54t     LIKE oma_file.oma54t    #CHI-B40063 add
  DEFINE l_apa34f     LIKE apa_file.apa34f    #CHI-B40063 add
 
  WHENEVER ERROR CONTINUE
  IF cl_null(t_rvu01) THEN RETURN END IF
  SELECT * INTO g_pod.* FROM pod_file WHERE pod00 = '0'
  IF cl_null(g_pod.pod01) THEN
     LET g_pod.pod01 = 'T'
  END IF
  LET p_plant = l_plant
  LET g_plant_new = p_plant CLIPPED
 
  CALL s_getdbs()              ##取得Base DB ->存在 g_dbs_new Global變數中
  LET l_dbs = g_dbs_new        ##將g_dbs_new的值給l_dbs,這樣后續的語法就都不用改了
  #MOD-B30200----add-----str----------
  IF cl_null(l_dbs) THEN
     SELECT azp03 INTO l_dbs FROM azp_file
       WHERE azp01 = g_plant
     LET l_dbs=s_dbstring(l_dbs CLIPPED)
  END IF  
  #MOD-B30200----add-----end----------
 
  CALL s_gettrandbs()          ##取得TRANS DB ->存在 g_dbs_new Global變數中
  LET l_dbs_tra = g_dbs_tra    ##將g_dbs_new的值給l_dbs,這樣后續的語法就都不用改了

  LET s_plant = l_plant_new   #CHI-AC0043

  IF l_dbs='@@' THEN LET l_dbs=' ' END IF
  LET p_flow99=l_flow99
  LET p_dbs=l_dbs
  LET p_dbs_tra =l_dbs_tra
  LET p_poy20 = l_poy20
  LET p_poy16 = l_poy16
  LET p_poy17 = l_poy17
  LET p_poy12 = l_poy12
  LET p_poy18 = l_poy18
  LET p_poy19 = l_poy19
  LET p_poz011= l_poz011
  LET p_pmm01 = l_pmm01 
  LET p_pmm99 = l_pmm99     #TQC-760158 
  LET p_oga01 = l_oga01
  LET p_rvu01 = l_rvu01
  LET p_last_plant = l_last_plant
  LET p_poy02 = l_poy02  #FUN-670007
  LET p_i     = l_i      #FUN-670007
  LET p_poz18 = l_poz18  #FUN-670007
 
  SELECT azp03 INTO p_last_dbs FROM azp_file
   WHERE azp01 =p_last_plant
  LET p_last_dbs = s_dbstring(p_last_dbs)  #TQC-950010 ADD   
  SELECT azp03 INTO s_dbs FROM azp_file
   WHERE azp01 = g_plant
  LET s_dbs = s_dbstring(s_dbs)   #TQC-950010 ADD 
 
  #讀取整體參數檔
  LET l_sql = "SELECT * ",
              #" FROM ",p_dbs CLIPPED,"aza_file ",
              " FROM ",cl_get_target_table(p_plant,'aza_file'), #FUN-A50102
              " WHERE aza01 = '0' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
  PREPARE aza_p1 FROM l_sql 
  IF SQLCA.SQLCODE THEN CALL cl_err('aza_p1',SQLCA.SQLCODE,1) END IF
  DECLARE aza_c1 CURSOR FOR aza_p1
  OPEN aza_c1
  FETCH aza_c1 INTO p_aza.* 
  CLOSE aza_c1
 
  #讀取幣別檔資料(本幣)
  LET l_sql = "SELECT * ",
              #" FROM ",p_dbs CLIPPED,"azi_file ",
              " FROM ",cl_get_target_table(p_plant,'azi_file'), #FUN-A50102
              " WHERE azi01 = '",p_aza.aza17,"' "      #幣別
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
  PREPARE azi_p2 FROM l_sql 
  IF SQLCA.SQLCODE THEN CALL cl_err('azi_p2',SQLCA.SQLCODE,1) END IF
  DECLARE azi_c2 CURSOR FOR azi_p2
  OPEN azi_c2
  FETCH azi_c2 INTO s_azi.* 
  CLOSE azi_c2
 
  #讀取應付帳款系統參數檔
  LET l_sql = "SELECT * ",
              #" FROM ",p_dbs CLIPPED,"apz_file ",
              " FROM ",cl_get_target_table(p_plant,'apz_file'), #FUN-A50102
              " WHERE apz00= '0' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
  PREPARE apz_p1 FROM l_sql 
  IF SQLCA.SQLCODE THEN CALL cl_err('apz_p1',SQLCA.SQLCODE,1) END IF
  DECLARE apz_c1 CURSOR FOR apz_p1
  OPEN apz_c1
  FETCH apz_c1 INTO p_apz.* 
  CLOSE apz_c1
  #讀取應收帳款系統參數檔
  LET l_sql = "SELECT * ",
              #" FROM ",p_dbs CLIPPED,"ooz_file ",
              " FROM ",cl_get_target_table(p_plant,'ooz_file'), #FUN-A50102
              " WHERE ooz00= '0' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
  PREPARE ooz_p1 FROM l_sql 
  IF SQLCA.SQLCODE THEN CALL cl_err('ooz_p1',SQLCA.SQLCODE,1) END IF
  DECLARE ooz_c1 CURSOR FOR ooz_p1
  OPEN ooz_c1
  FETCH ooz_c1 INTO p_ooz.* 
  CLOSE ooz_c1
 
  #讀取該入庫單單資料
  LET l_sql = "SELECT rvu_file.* ,rva_file.* ",
              #" FROM ",p_dbs_tra CLIPPED,"rvu_file,",p_dbs_tra CLIPPED,"rva_file ",#MOD-820171 #FUN-980020
              " FROM ",cl_get_target_table(p_plant,'rvu_file'),",", #FUN-A50102
                       cl_get_target_table(p_plant,'rva_file'),     #FUN-A50102
              " WHERE rvu01 = '",p_rvu01,"' ",  #入庫單號
              "   AND rvu02 = rva01 ",
              "   AND rvu00 = '1' ",    
              "   AND rvu08 = 'TAP'",
              "   AND rvu20 = 'Y' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-920032
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980020 自動加上plant的關聯條件 
  PREPARE rvu_p1 FROM l_sql 
  IF SQLCA.SQLCODE THEN CALL cl_err('rvu_p1',SQLCA.SQLCODE,1) END IF
  DECLARE rvu_c1 CURSOR FOR rvu_p1
  OPEN rvu_c1
  FETCH rvu_c1 INTO p_rvu.* , p_rva.*
  CLOSE rvu_c1
 
  #讀取該出貨單資料
  LET l_sql = "SELECT * ",
              #" FROM ",p_dbs_tra CLIPPED,"oga_file ",    #FUN-980020
              " FROM ",cl_get_target_table(p_plant,'oga_file'), #FUN-A50102
              " WHERE oga01 = '",p_oga01,"' ",     #出貨單號
              "   AND oga09='6' ",                 #單據別為代採買出貨單
              "   AND ogaconf='Y' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-920032
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980020 自動加上plant的關聯條件 
  PREPARE oga_p FROM l_sql
  IF SQLCA.SQLCODE THEN CALL cl_err('oga_p',SQLCA.SQLCODE,1) END IF
  DECLARE oga_c CURSOR FOR oga_p
  OPEN oga_c
  FETCH oga_c INTO p_oga.* 
  CLOSE oga_c
  #讀取幣別檔資料(出貨單幣別)
  LET l_sql = "SELECT * ",
              #" FROM ",p_dbs CLIPPED,"azi_file ",
              " FROM ",cl_get_target_table(p_plant,'azi_file'), #FUN-A50102
              " WHERE azi01 = '",p_oga.oga23,"' "      #幣別
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
  PREPARE azi_p1 FROM l_sql 
  IF SQLCA.SQLCODE THEN CALL cl_err('azi_p1',SQLCA.SQLCODE,1) END IF
  DECLARE azi_c1 CURSOR FOR azi_p1
  OPEN azi_c1
  FETCH azi_c1 INTO p_azi.* 
  CLOSE azi_c1
  
   #讀取AR,AP單別檔資料
   LET l_sql = "SELECT * ",
               #" FROM ",p_dbs CLIPPED,"ooy_file ",
               " FROM ",cl_get_target_table(p_plant,'ooy_file'), #FUN-A50102
               " WHERE ooyslip = '",AR_t1,"' "     
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
   PREPARE ooy_p1 FROM l_sql 
   IF STATUS THEN CALL cl_err('ooy_p1',STATUS,1) END IF
   DECLARE ooy_c1 CURSOR FOR ooy_p1
   OPEN ooy_c1
   FETCH ooy_c1 INTO p_ooy.* 
   CLOSE ooy_c1
   LET l_sql = "SELECT * ",
              #" FROM ",p_dbs CLIPPED,"apy_file ",
              " FROM ",cl_get_target_table(p_plant,'apy_file'), #FUN-A50102
              " WHERE apyslip = '",AP_t1,"' "      
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
  PREPARE apy_p1 FROM l_sql 
  IF STATUS THEN CALL cl_err('apy_p1',STATUS,1) END IF
  DECLARE apy_c1 CURSOR FOR apy_p1
  OPEN apy_c1
  FETCH apy_c1 INTO p_apy.* 
  CLOSE apy_c1
  
  SELECT aza81 INTO g_aza.aza81 FROM aza_file 
  INITIALIZE p_oma.* TO NULL
  LET p_oma.oma00 = '12'            #帳款類別
  
  IF p_oma02 IS NULL THEN
     LET p_oma.oma02 = p_oga.oga02  #帳款日期
  ELSE
     LET p_oma.oma02 = p_oma02      #帳款日期
  END IF
  IF p_dbs != s_dbs THEN            #FUN-670007
      CALL s_auto_assign_no('axr',AR_t1,p_oma.oma02,'12',"","",p_plant,"","") #FUN-980020
        RETURNING li_result,p_oma.oma01
      IF (NOT li_result) THEN 
         LET g_msg = p_plant CLIPPED,p_oma.oma01                       #TQC-9B0013
         CALL s_errmsg("oma01",p_oma.oma01,g_msg CLIPPED,"mfg3046",1)  #TQC-9B0013
         LET g_success ='N'
         RETURN
      END IF   
  END IF                            #FUN-670007
  LET p_oma.oma13 = p_poy16         #AR科目分類
  LET p_oma.oma16 = p_oga01
  #給予應收單頭值
   
  # 加判斷來源廠不用 default AR資料
  IF p_dbs != s_dbs THEN 
     CALL p861_oma(p_rvu01)
  END IF                      
 
  IF p_oga.oga23 =  p_aza.aza17 THEN
     LET p_oga.oga24 = 1
  END IF
  LET p_apa31f = 0
  LET p_apa31  = 0
  #LET p_apa32f = 0 #MOD-C70105 #TQC-C90045 mark
  #LET p_apa32 = 0 #MOD-C70105  #TQC-C90045 mark
  LET l_sql3 = "SELECT pmm50 FROM rvv_file,pmm_file WHERE rvv36=pmm01 ",
               " AND rvv01 = '",t_rvu01,"'"
  PREPARE pmm50_pre FROM l_sql3
  EXECUTE pmm50_pre INTO p_pmm.pmm50
  #讀取入庫單身檔(rvv_file)
  LET l_sql2 = "SELECT * FROM rvv_file ",
               " WHERE rvv01 = '",t_rvu01,"'"
  CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2 #MOD-B60121 add
  IF p_last_dbs != p_dbs OR                                #MOD-830250 
     (p_poz011 != '2' AND NOT cl_null(p_pmm.pmm50)) THEN   #MOD-830250  
     #LET l_sql2 = "SELECT * ",   #MOD-AC0129
     LET l_sql2 = "SELECT rvv_file.* ",   #MOD-AC0129
                  #"  FROM ",p_dbs_tra CLIPPED, "rvv_file, ",  #FUN-980020
                  #          p_dbs_tra CLIPPED, "rvu_file ",   #FUN-980020
                  "  FROM ",cl_get_target_table(p_plant,'rvv_file'),",", #FUN-A50102
                            cl_get_target_table(p_plant,'rvu_file'),     #FUN-A50102
                  " WHERE rvv01 = rvu01 ",
                  "   AND rvu00 = '1'   ",  #MOD-880034 add
                  "   AND rvu99 ='",p_flow99,"'"
     #MOD-B60121 add --start--
     CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
     CALL cl_parse_qry_sql(l_sql2,p_plant) RETURNING l_sql2
     #MOD-B60121 add --end--
  END IF                                                    #MOD-830250
 #MOD-B60121 mark --start--
 #CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2             #FUN-920032
 #CALL cl_parse_qry_sql(l_sql2,p_plant) RETURNING l_sql2 #FUN-980020 自動加上plant的關聯條件 
 #MOD-B60121 mark --end--
  PREPARE rvv_pre FROM l_sql2
  IF SQLCA.SQLCODE THEN CALL cl_err('rvv_pre',SQLCA.SQLCODE,1) END IF
  DECLARE rvv_cs CURSOR FOR rvv_pre  
  FOREACH rvv_cs INTO s_rvv.*
     IF p_last_dbs != p_dbs OR                                #MOD-A20071
        (p_poz011 != '2' AND NOT cl_null(p_pmm.pmm50)) THEN   #MOD-A20071
         #讀取採購單單頭檔資料(pmm_file)
         LET l_sql = "SELECT * ",
                     #" FROM ",p_dbs_tra CLIPPED,"pmm_file ",   #FUN-980020
                     " FROM ",cl_get_target_table(p_plant,'pmm_file'), #FUN-A50102
                     " WHERE pmm99 = '",p_pmm99,"' AND pmm18 <> 'X'"   #TQC-760158 
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-920032
            CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980020 自動加上plant的關聯條件 
         PREPARE pmm_p1 FROM l_sql 
         IF SQLCA.SQLCODE THEN CALL cl_err('pmm_p1',SQLCA.SQLCODE,1) END IF
         DECLARE pmm_c1 CURSOR FOR pmm_p1
         OPEN pmm_c1
         FETCH pmm_c1 INTO p_pmm.*
         CLOSE pmm_c1
         #匯率皆取立帳日為基準的匯率
         CALL s_currm(p_pmm.pmm22,p_oma.oma02,p_apz.apz33,p_plant)    #FUN-980020
                     RETURNING l_pmm42                                #NO.FUN-640196
         IF NOT cl_null(l_pmm42) THEN   #若抓不到取採購匯率
            LET p_pmm.pmm42=l_pmm42
         END IF
         #若幣別=系統參數之本幣, 則匯率=1
         IF p_pmm.pmm22 =  p_aza.aza17 THEN
            LET p_pmm.pmm42 = 1
         END IF
         #讀取幣別檔資料(採購幣別)
         LET l_sql = "SELECT * ",
                     #" FROM ",p_dbs CLIPPED,"azi_file ",
                     " FROM ",cl_get_target_table(p_plant,'azi_file'), #FUN-A50102
                     " WHERE azi01 = '",p_pmm.pmm22,"' "      #幣別
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
            CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
         PREPARE azi_p3 FROM l_sql 
         IF SQLCA.SQLCODE THEN CALL cl_err('azi_p3',SQLCA.SQLCODE,1) END IF
         DECLARE azi_c3 CURSOR FOR azi_p3
         OPEN azi_c3
         FETCH azi_c3 INTO l_azi.* 
         CLOSE azi_c3
      END IF          #MOD-A20071                
 
      #新增至出貨單身檔
      IF p_dbs != s_dbs THEN 
         CALL p861_omb()
         CALL p861_u_ogb60()   #MOD-780037
      END IF                
      #新增至應付帳款單身檔
      IF p_last_dbs != p_dbs OR 
         (p_poz011 != '2' AND NOT cl_null(p_pmm.pmm50)) THEN
         CALL s_auto_assign_no('aap',AP_t1,p_oma.oma02,'11',"","",p_plant,"","") #FUN-980020 p_dbs-->p_plant
           RETURNING li_result,p_apa.apa01
         IF (NOT li_result) THEN 
            LET g_msg = p_plant CLIPPED,p_apa.apa01                       #TQC-9B0013
            CALL s_errmsg("apa01",p_apa.apa01,g_msg CLIPPED,"mfg3046",1)  #TQC-9B0013
            LET g_success ='N'
            RETURN
         END IF   
 
         CALL p861_apb()
         CALL p861_u_rvb06()
         CALL p861_u_rvv23()
      END IF  
  END FOREACH
 
  IF p_dbs != s_dbs THEN   
     #新增至應收單頭檔---(必須在新增單身後, 如此才可得到總金額)
     CALL p861_ins_oma()
 
     #新增應收多帳期資料
     CALL p861_ins_omc()   #No.TQC-7C0019 
    
     #調整尾差(會將差異捲至單身金額最大筆)
     CALL p861_up_omb(p_oma.oma01)  #CHI-930047 add
 
     #新增至分錄底稿單頭檔
     #新增至分錄底稿單身檔
    IF p_ooy.ooydmy1 = 'Y' THEN                #No.CHI-920010
     CALL p861_ar_npp('0') 
     CALL p861_ar_npq('0')  
     IF g_success = 'N' THEN RETURN END IF                    #No.CHI-920010  
     #CHI-B40063 add --start--
     LET l_sql = "SELECT oma54t ",
                 " FROM ",cl_get_target_table(p_plant,'oma_file'), 
                 " WHERE oma01 = '",p_oma.oma01,"' "  
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql 
     PREPARE oma54t_sel FROM l_sql
     EXECUTE oma54t_sel INTO l_oma54t  
     #CHI-B40063 add --end--
     IF l_oma54t<>0 THEN   #CHI-B40063 add
        CALL s_chknpq3(p_oma.oma01,'AR',1,'0',p_plant,g_bookno1) #No.CHI-920010	#TQC-980276
        IF g_success = 'N' THEN RETURN END IF                    #No.CHI-920010   
     END IF  #CHI-B40063 add
     IF p_aza.aza63 = 'Y' THEN  #No.TQC-7C0107
         CALL p861_ar_npp('1')
         CALL p861_ar_npq('1')
         IF g_success = 'N' THEN RETURN END IF                    #No.CHI-920010 
         IF l_oma54t<>0 THEN   #CHI-B40063 add
            CALL s_chknpq3(p_oma.oma01,'AR',1,'1',p_plant,g_bookno1) #No.CHI-920010	#TQC-980276
            IF g_success = 'N' THEN RETURN END IF                    #No.CHI-920010 
         END IF  #CHI-B40063 add
     END IF
   END IF                                      #No.CHI-920010
  END IF    
  #轉應付系統--------------------
  #新增至分錄底稿單頭檔(AP)
  IF p_last_dbs != p_dbs OR   
    (p_poz011 != '2' AND NOT cl_null(p_pmm.pmm50)) THEN
     CALL p861_ap_apa()

     #調整尾差(會將差異捲至單身金額最大筆)
     CALL p861_up_apb(p_apa.apa01)  #CHI-BC0008 add
     
     #新增應付多帳期資料
     CALL p861_ins_apc()      #No: TQC-7C0019 
     IF p_apy.apydmy3 = 'Y' THEN        #No.CHI-920010
     CALL p861_ap_npp('0')    
     CALL p861_ap_npq('0')
     IF g_success = 'N' THEN RETURN END IF                    #No.CHI-920010 
     #CHI-B40063 add --start--
     LET l_sql = "SELECT apa34f ",
                 " FROM ",cl_get_target_table(p_plant,'apa_file'), 
                 " WHERE apa01 = '",p_apa.apa01,"' "  
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql 
     PREPARE apa34f_sel FROM l_sql
     EXECUTE apa34f_sel INTO l_apa34f  
     #CHI-B40063 add --end--
     IF l_apa34f<>0 THEN   #CHI-B40063 add
        CALL s_chknpq3(p_apa.apa01,'AP',1,'0',p_plant,g_bookno1) #No.CHI-920010	#TQC-980276
        IF g_success = 'N' THEN RETURN END IF                    #No.CHI-920010   
     END IF  #CHI-B40063 add
     IF p_aza.aza63 = 'Y' THEN  #No.TQC-7C0107
        CALL p861_ap_npp('1')
        CALL p861_ap_npq('1')
        IF g_success = 'N' THEN RETURN END IF                    #No.CHI-920010 
        IF l_apa34f<>0 THEN   #CHI-B40063 add
           CALL s_chknpq3(p_apa.apa01,'AP',1,'1',p_plant,g_bookno1) #No.CHI-920010	#TQC-980276
           IF g_success = 'N' THEN RETURN END IF                    #No.CHI-920010
        END IF  #CHI-B40063 add
     END IF
   END IF                                #No.CHI-920010                         
  END IF  
END FUNCTION
 
#----------------------------(產生出貨應收)----------------------------
FUNCTION p861_oma(p_oma01)
  DEFINE p_oma01   LIKE oma_file.oma01    #No.FUN-680136 VARCHAR(16)               #No.FUN-550060
  DEFINE s_pmm40   LIKE pmm_file.pmm40
  DEFINE l_occ03   LIKE occ_file.occ03    #客戶分類
  DEFINE l_gec     RECORD LIKE gec_file.*
  DEFINE l_sql       LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(600)
         l_sql1      LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(1200)
  DEFINE l_date    LIKE type_file.dat         #No.FUN-680136 DATE                 #NO.FUN-640196
  DEFINE l_oea18   LIKE oea_file.oea18    #CHI-9B0023
  DEFINE l_oea24   LIKE oea_file.oea24    #CHI-9B0023
 
   LET p_oma.oma50  =0 LET p_oma.oma50t =0
   LET p_oma.oma52  =0 LET p_oma.oma53  =0
   LET p_oma.oma54  =0 LET p_oma.oma54x =0
   LET p_oma.oma54t =0 LET p_oma.oma55  =0
   LET p_oma.oma56  =0 LET p_oma.oma56x =0
   LET p_oma.oma56t =0 LET p_oma.oma57  =0
   LET p_oma.oma59  =0 LET p_oma.oma59x =0
   LET p_oma.oma59t =0
   LET p_oma.oma61  =0       #bug no:A060
   LET p_oma.oma64 = '1'    		#MOD-960273
   LET p_oma.oma51  =0 
   LET p_oma.oma51f =0 
   LET p_oma.oma65  =1 
   LET p_oma.omaconf='Y'
   LET p_oma.omavoid='N'
   LET p_oma.omavoid2=null
   LET p_oma.omaprsw=0
   LET p_oma.omauser=g_user
   LET p_oma.omagrup=g_grup
   LET p_oma.omamodu=null
   LET p_oma.omadate=TODAY
   LET p_oma.oma65 = '1'         
   LET p_oma.oma66 = p_plant
   LET p_oma.oma00 = '12'            #帳款類別
   LET p_oma.oma03 = p_oga.oga03     #帳款客戶
   LET p_oma.oma032= p_oga.oga032    #帳款客戶簡稱
   LET p_oma.oma04 = p_oga.oga03     #發票客戶
   #讀取發票客戶統編,全名,地址
        LET l_sql = "SELECT occ11,occ18,occ231,occ37,occ03 ",
                    #" FROM ",p_dbs CLIPPED,"occ_file ",
                    " FROM ",cl_get_target_table(p_plant,'occ_file'), #FUN-A50102
                    " WHERE occ01 = '",p_oma.oma04,"' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
        PREPARE occ_p1 FROM l_sql 
        IF SQLCA.SQLCODE THEN CALL cl_err('occ_p1',SQLCA.SQLCODE,1) END IF
        DECLARE occ_c1 CURSOR FOR occ_p1
        OPEN occ_c1
        FETCH occ_c1 INTO  p_oma.oma042,p_oma.oma043,p_oma.oma044,
                           p_oma.oma40,l_occ03
        IF SQLCA.SQLCODE THEN
           LET g_msg = p_dbs CLIPPED,p_oma.oma04
           CALL cl_err(g_msg,'mfg4106',1)
           CLOSE occ_c1 LET g_success = 'N' RETURN
        END IF
        CLOSE occ_c1
   LET p_oma.oma05 = p_oga.oga05  #發票別 
   LET p_oma.oma06 = null         #AR帳款分類
   LET p_oma.oma07 = p_oga.oga07  #出貨是否計入未開發票
   LET p_oma.oma08 = p_oga.oga08  #內/外銷
   LET p_oma.oma09 = p_oma.oma02  #發票日期	#MOD-980233 modify null -> oma02
   LET p_oma.oma10 = null         #發票號碼
   LET p_oma.oma14 = p_oga.oga14  #人員編號
   LET p_oma.oma15 = p_poy18      #部門編號 No.8166
   
   LET p_oma.oma161= p_oga.oga161 #訂金應收比率
   LET p_oma.oma162= p_oga.oga162 #出貨應收比率
   LET p_oma.oma163= p_oga.oga163 #尾款應收比率
   LET p_oma.oma17  ='1'          #扣抵區分
   #讀取申報格式(依 oma21)
   #LET l_sql = "SELECT gec08,gec06 FROM ",p_dbs CLIPPED,"gec_file",
   LET l_sql = "SELECT gec08,gec06 FROM ",cl_get_target_table(p_plant,'gec_file'), #FUN-A50102
               " WHERE gec01 = '",p_oga.oga21,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
   PREPARE gec_pre FROM l_sql
   DECLARE gec_cs CURSOR FOR gec_pre
   OPEN gec_cs
   FETCH gec_cs INTO p_oma.oma171,p_oma.oma172
   IF SQLCA.SQLCODE THEN
      LET g_msg = p_dbs CLIPPED,p_oga.oga21
      CALL cl_err(g_msg,'mfg3044',1)
      LET g_success = 'N' CLOSE gec_cs RETURN
   END IF
   CLOSE gec_cs
   LET p_oma.oma173 = YEAR(p_oma.oma02)   #申報年度
   LET p_oma.oma174 = MONTH(p_oma.oma02)  #申報月份
   LET p_oma.oma175 = null        #申報流水號
   #讀取應收預設會計科目(依AR分類)
        LET l_sql = "SELECT *  ",
                    #" FROM ",p_dbs CLIPPED,"ool_file ",
                    " FROM ",cl_get_target_table(p_plant,'ool_file'), #FUN-A50102
                    " WHERE ool01 = '",p_oma.oma13,"' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
        PREPARE ool_p1 FROM l_sql 
        IF SQLCA.SQLCODE THEN CALL cl_err('ool_p1',SQLCA.SQLCODE,1) END IF
        DECLARE ool_c1 CURSOR FOR ool_p1
        OPEN ool_c1
        FETCH ool_c1 INTO  p_ool.*
        IF SQLCA.SQLCODE THEN 
           LET g_msg = p_dbs CLIPPED,p_oma.oma13
           CALL cl_err(g_dbs clipped,'axr-186',1) 
           LET g_success='N' CLOSE ool_c1 RETURN
        END IF
        CLOSE ool_c1
   IF p_oma.oma18 IS NULL THEN LET p_oma.oma18=p_ool.ool11 END IF
   IF p_aza.aza63= 'Y' THEN  #No.TQC-7C0107
 END IF
   IF p_oma.oma181 IS NULL THEN LET p_oma.oma181 =p_ool.ool111 END IF
 
   LET p_oma.oma19 = null           #待抵帳號
   LET p_oma.oma20  ='Y'            #分錄底稿是否可重新產生
   LET p_oma.oma21 = p_oga.oga21    #稅別
   LET p_oma.oma211= p_oga.oga211   #稅率
   LET p_oma.oma212= p_oga.oga212   #聯數
   LET p_oma.oma213= p_oga.oga213   #含稅否
   LET p_oma.oma23 = p_oga.oga23    #幣別
   #重新讀取立帳匯率
   IF p_oma.oma23 = p_aza.aza17 THEN
       LET p_oma.oma24 = 1       #立帳匯率
   ELSE 
       IF p_oga.oga021 IS NOT NULL THEN
           LET l_date = p_oga.oga021
       ELSE
           LET l_date = p_oma.oma02
       END IF
       IF p_oma.oma08 = '1' THEN  #內銷
          CALL s_currm(p_oga.oga23,l_date,p_ooz.ooz17,p_plant) RETURNING p_oma.oma24   #FUN-980020
       ELSE            #外銷
          CALL s_currm(p_oga.oga23,l_date,p_ooz.ooz63,p_plant) RETURNING p_oma.oma24   #FUN-980020
       END IF
   END IF
   LET l_oea18=''  LET l_oea24=''
   LET l_sql = "SELECT UNIQUE oea18,oea24 ",
               #" FROM ",p_dbs CLIPPED,"oea_file,",
               #"      ",p_dbs CLIPPED,"ogb_file ",
               " FROM ",cl_get_target_table(p_plant,'oea_file'),",", #FUN-A50102
               "      ",cl_get_target_table(p_plant,'ogb_file'),     #FUN-A50102
               " WHERE oea01 = ogb31 ",   
               "  AND ogb01 = '",p_oga.oga01,"'" 
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
   PREPARE oea18_pre FROM l_sql 
   IF SQLCA.SQLCODE THEN CALL cl_err('oea18_pre',SQLCA.SQLCODE,1) END IF
   DECLARE oea18_chk CURSOR FOR oea18_pre
   OPEN oea18_chk
   FETCH oea18_chk INTO l_oea18,l_oea24
      IF l_oea18 IS NOT NULL AND l_oea18='Y' THEN
         LET p_oma.oma24 = l_oea24
         LET p_oma.oma58 = l_oea24
      END IF
   IF cl_null(p_oma.oma24) THEN LET p_oma.oma24=1 END IF
   IF cl_null(p_oma.oma58) THEN LET p_oma.oma58=1 END IF
   CLOSE oea18_chk 
  # 立帳時讀取出貨匯率, 不用重新讀取
   LET p_oma.oma58 = p_oma.oma24    #海關匯率 
   LET p_oma.oma60 = p_oma.oma24    #bug no:A060
   LET p_oma.oma99 = p_flow99       #No.8166
   LET p_oma.oma25 = p_oga.oga25    #銷售分類一
   LET p_oma.oma26 = p_oga.oga26    #銷售分類二
   LET p_oma.oma32 = p_oga.oga32    #收款條件
   #計算應收款日(注意必須為多工廠) #No.8506
      CALL s_rdatem(p_oma.oma03,p_oma.oma32,p_oma.oma02,p_oma.oma09,
                    p_oma.oma02,p_plant) #FUN-980020
                    RETURNING p_oma.oma11,p_oma.oma12
   LET p_oma.oma33 = null          #拋轉傳票號
   LET p_oma.oma34 = null          #No Use
  #MOD-B20013 mod --start--
  #LET p_oma.oma35 = null          #No Use
  #LET p_oma.oma36 = null          #No Use
  #LET p_oma.oma37 = null          #No Use
  #LET p_oma.oma38 = null          #No Use
   LET p_oma.oma35 = p_oga.oga35 
   LET p_oma.oma36 = p_oga.oga36 
   LET p_oma.oma37 = p_oga.oga37
   LET p_oma.oma38 = p_oga.oga38
  #MOD-B20013 mod --end--
   #LET p_oma.oma39 = p_oga.oga27  #INVOICE NO    #MOD-A50181
   LET p_oma.oma39 = p_oga.oga39   #出口報單號碼  #MOD-A50181
   LET p_oma.oma52 = 0         
   LET p_oma.oma53 = 0
   CALL cl_digcut(p_oma.oma54x,p_azi.azi04) RETURNING p_oma.oma54x 
   LET p_oma.oma55 = 0               #原幣己沖金額
       CALL cl_digcut(p_oma.oma56 ,p_azi.azi04) RETURNING p_oma.oma56 
       CALL cl_digcut(p_oma.oma56t,p_azi.azi04) RETURNING p_oma.oma56t
       CALL cl_digcut(p_oma.oma56x,p_azi.azi04) RETURNING p_oma.oma56x
   LET p_oma.oma57 = 0               #本幣己沖金額
   LET p_oma.oma61 = p_oma.oma56t - p_oma.oma57    #bug no:A060
   #發票--------------------------------------------------------
   CASE p_poy20
     WHEN '1'    #全額申報
           LET p_oma.oma59 = 0
           LET p_oma.oma59x= 0
           LET p_oma.oma59t= 0
     WHEN '2'    #差額申報 (發票只立差額S/O-P/O之價格)
           #由單身sum其金額
           LET p_oma.oma59 = 0
           LET p_oma.oma59x= 0
           LET p_oma.oma59t= 0
     WHEN '3'    #不申報
           LET p_oma.oma59 = 0
           LET p_oma.oma59x= 0
           LET p_oma.oma59t= 0
     OTHERWISE EXIT CASE
   END CASE
   #LET l_sql = "SELECT occ07,occ02 FROM ",p_dbs CLIPPED,"occ_file ",
   LET l_sql = "SELECT occ07,occ02 FROM ",cl_get_target_table(p_plant,'occ_file'), #FUN-A50102
               " WHERE occ01 = ? "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
   PREPARE p861_sel_occ_prep FROM l_sql
   IF cl_null(p_oga.oga18) THEN
      EXECUTE p861_sel_occ_prep INTO p_oma.oma68,p_oma.oma69 USING p_oga.oga03
   ELSE
      EXECUTE p861_sel_occ_prep INTO p_oma.oma68,p_oma.oma69 USING p_oga.oga18
   END IF
END FUNCTION
 
FUNCTION p861_omb()
 DEFINE l_gec  RECORD LIKE gec_file.*
 DEFINE p_price  LIKE ogb_file.ogb13,
        l_price  LIKE ogb_file.ogb13
 DEFINE l_oba11  LIKE oba_file.oba11   #FUN-690012
 DEFINE l_pmn31  LIKE pmn_file.pmn31   #FUN-670007
 DEFINE l_oba111 LIKE oba_file.oba111  #MOD-B30012 add
 
      #讀取入庫單單身檔資料(rvv_file)
      LET l_sql = "SELECT * ",
                  #" FROM ",p_dbs_tra CLIPPED,"rvv_file ",    #FUN-980020
                  " FROM ",cl_get_target_table(p_plant,'rvv_file'), #FUN-A50102
                  " WHERE rvv01 = '",p_rvu01,"' ",     #入庫單
                  "  AND rvv02 =",s_rvv.rvv02
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980020 自動加上plant的關聯條件 
      PREPARE rvv_p1 FROM l_sql 
      IF SQLCA.SQLCODE THEN CALL cl_err('rvv_p1',SQLCA.SQLCODE,1) END IF
      DECLARE rvv_c1 CURSOR FOR rvv_p1
      OPEN rvv_c1
      FETCH rvv_c1 INTO p_rvv.* 
      CLOSE rvv_c1
  #讀取出貨單身檔資料(ogb_file)
  LET l_sql = "SELECT * ",
              #" FROM ",p_dbs_tra CLIPPED,"ogb_file ",        #FUN-980020 
              " FROM ",cl_get_target_table(p_plant,'ogb_file'), #FUN-A50102
              " WHERE ogb01 = '",p_oga01,"' ",     #出貨單號
              "  AND ogb03 =",s_rvv.rvv02              #項次
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980020 自動加上plant的關聯條件 
  PREPARE ogb_p5 FROM l_sql 
  IF SQLCA.SQLCODE THEN CALL cl_err('ogb_p5',SQLCA.SQLCODE,1) END IF
  DECLARE ogb_c5 CURSOR FOR ogb_p5
  OPEN ogb_c5
  FETCH ogb_c5 INTO p_ogb.* 
  CLOSE ogb_c5
  SELECT ima906 INTO g_ima906 FROM ima_file 
         WHERE ima01 = p_ogb.ogb04
     LET p_omb.omb00 = p_oma.oma00   #帳款類別
     LET p_omb.omb01 = p_oma.oma01   #帳款編號
     LET p_omb.omb03 = p_ogb.ogb03   #項次
     LET p_omb.omb04 = p_ogb.ogb04   #產品編號
        LET p_omb.omb05 = p_ogb.ogb916   #計價單位   
        LET p_omb.omb12 = p_ogb.ogb917   #計價數量   
     LET p_omb.omb06 = p_ogb.ogb06   #品名規格
     LET p_omb.omb13 = p_ogb.ogb13   #原幣單價
     LET p_omb.omb14 = p_ogb.ogb14   #原幣未稅金額
     LET p_omb.omb14t= p_ogb.ogb14t  #原幣含稅金額
     LET p_omb.omb31 = p_ogb.ogb01   
     LET p_omb.omb32 = p_ogb.ogb03
     LET p_omb.omb15 = p_omb.omb13 *p_oma.oma24  #本幣單價
     #未稅金額/含稅金額 : oeb14/oeb14t
     
        LET p_omb.omb16 =p_omb.omb14  * p_oma.oma24
        LET p_omb.omb16t=p_omb.omb14t * p_oma.oma24
      
     CALL cl_digcut(p_omb.omb15,s_azi.azi03) RETURNING p_omb.omb15
     CALL cl_digcut(p_omb.omb16,s_azi.azi04) RETURNING p_omb.omb16
     CALL cl_digcut(p_omb.omb16t,s_azi.azi04)RETURNING p_omb.omb16t
     #發票單價必須依poy20來判斷
     CASE p_poy20
        WHEN '1'    #全額申報
           #出貨單價*出貨匯率
           LET p_omb.omb17 = p_ogb.ogb13*p_oma.oma58      #MOD-A10031
        WHEN '2'    #差額申報 (發票只立差額S/O-P/O之價格)
           IF cl_null(p_rvv.rvv38) THEN LET p_rvv.rvv38=0 END IF
           IF cl_null(p_pmm.pmm42) THEN LET p_pmm.pmm42=0 END IF
           #最終廠全額申報(因為無PO)
           IF p_last_dbs != p_dbs OR
              (p_poz011 != '2' AND NOT cl_null(p_pmm.pmm50))THEN
              LET p_omb.omb17 = p_ogb.ogb13*p_oma.oma58   #MOD-A10031
                              - p_rvv.rvv38*p_pmm.pmm42
           ELSE
              LET p_omb.omb17 = p_ogb.ogb13*p_oma.oma58   #MOD-A10031
           END IF
          
        WHEN '3'    #不申報
           LET p_omb.omb17 = 0
        OTHERWISE EXIT CASE
     END CASE
     #-----MOD-A40028---------
     #IF p_oma.oma213 = 'N'
     #   THEN LET p_omb.omb18 =p_omb.omb12*p_omb.omb17
     #        LET p_omb.omb18t=p_omb.omb18*(1+p_oma.oma211/100)
     #   ELSE LET p_omb.omb18t=p_omb.omb12*p_omb.omb17
     #        LET p_omb.omb18 =p_omb.omb18t/(1+p_oma.oma211/100)
     #END IF
     LET p_omb.omb18  = p_omb.omb14  * p_oma.oma58
     LET p_omb.omb18t = p_omb.omb14t * p_oma.oma58
     #-----END MOD-A40028-----
 
     CALL cl_digcut(p_omb.omb17,s_azi.azi03) RETURNING p_omb.omb17
     CALL cl_digcut(p_omb.omb18,s_azi.azi04) RETURNING p_omb.omb18
     CALL cl_digcut(p_omb.omb18t,s_azi.azi04)RETURNING p_omb.omb18t
     #若為負數則給0
     IF p_omb.omb17 <= 0 THEN	#MOD-960247
        LET p_omb.omb17=0
        LET p_omb.omb18=0
        LET p_omb.omb18t=0
     END IF
     LET p_omb.omb31 = p_ogb.ogb01    #出貨單號
     LET p_omb.omb32 = p_ogb.ogb03    #出貨項次
 
     #IF p_omb.omb00 = '12' THEN
     IF p_omb.omb00 ='12' OR p_omb.omb00 ='21' THEN #TQC-D30046 add
       LET l_oba11 = NULL 
      #MOD-B30012 mod --start--
      #SELECT oba11 INTO l_oba11
      # FROM oba_file,ima_file
      #WHERE oba01 = ima_file.ima131
      #  AND ima01 = p_omb.omb04
       LET l_sql = "SELECT oba11 ",
                   "  FROM ",cl_get_target_table( p_plant, 'oba_file' ),
                   "  LEFT OUTER JOIN ",cl_get_target_table( p_plant, 'ima_file' ),              
                   "    ON oba01 = ima131 ",
                   " WHERE ima01 = '",p_omb.omb04,"'"
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql
       CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
       PREPARE oba_p1 FROM l_sql 
      #MOD-B30012 mod --end--
       IF SQLCA.sqlcode THEN
          LET l_oba11 = NULL
          CALL cl_err3("sel","oba_file",p_omb.omb04,"",STATUS,"","sel oba",0)
       END IF
       #MOD-B30012 add --start--
       DECLARE oba_c1 CURSOR FOR oba_p1
       OPEN oba_c1
       FETCH oba_c1 INTO l_oba11
       CLOSE oba_c1
       #MOD-B30012 add --end--
       IF NOT cl_null(l_oba11) THEN
         LET p_omb.omb33 = l_oba11
       ELSE
         LET p_omb.omb33 = p_ool.ool41    #科目編號 銷貨成本
       END IF
     ELSE
         LET p_omb.omb33 = p_ool.ool41    #科目編號 銷貨成本
     END IF
    #LET p_omb.omb331 = p_ool.ool411  #No.FUN-6A0026 #MOD-B30012 mark
    #MOD-B30012 add --start--
    IF p_aza.aza63 ='Y' THEN 
       #IF p_omb.omb00 ='12' THEN
       IF p_omb.omb00 ='12' OR p_omb.omb00 ='21' THEN #TQC-D30046 add
          LET l_oba111 = NULL
          LET l_sql = "SELECT oba111 ",
                      "  FROM ",cl_get_target_table( p_plant, 'oba_file' ),
                      "  LEFT OUTER JOIN ",cl_get_target_table( p_plant, 'ima_file' ),              
                      "    ON oba01 = ima131 ",
                      " WHERE ima01 = '",p_omb.omb04,"'"
          CALL cl_replace_sqldb(l_sql) RETURNING l_sql
          CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
          PREPARE oba_p2 FROM l_sql 
          IF SQLCA.sqlcode THEN
             LET l_oba111 = NULL
             CALL s_errmsg("ima01",p_omb.omb04,"sel oba",SQLCA.sqlcode,0)
          END IF
          DECLARE oba_c2 CURSOR FOR oba_p2
          OPEN oba_c2
          FETCH oba_c2 INTO l_oba111
          CLOSE oba_c2
          IF NOT cl_null(l_oba111) THEN
             LET p_omb.omb331 = l_oba111
          ELSE
             LET p_omb.omb331 = p_ool.ool411    #科目編號 銷貨成本
          END IF
       ELSE 
          LET p_omb.omb331 = p_ool.ool411    #科目編號 銷貨成本
       END IF
    END IF
    #MOD-B30012 add --end--
     LET p_omb.omb34 = 0              #原幣已沖金額
     LET p_omb.omb34 = 0              #原幣已沖金額
     LET p_omb.omb35 = 0              #本幣已沖金額
     LET p_omb.omb36 = p_oma.oma24    #A060
     LET p_omb.omb37 = p_omb.omb16t - p_omb.omb35   #A060
 
     IF s_rvv.rvv25='Y' THEN  #No.9421   #MOD-8B0239 add 
         LET p_omb.omb13 = 0             #原幣單價
         LET p_omb.omb14 = 0             #原幣未稅金額
         LET p_omb.omb14t= 0             #原幣含稅金額
         LET p_omb.omb15 =0
         LET p_omb.omb16 =0
         LET p_omb.omb16t=0
         LET p_omb.omb17 =0
         LET p_omb.omb18 =0
         LET p_omb.omb18t=0
     END IF
 
     #單頭之發票金額
     LET p_oma.oma59 = p_oma.oma59 + p_omb.omb18    #本幣發票未稅金額
     LET p_oma.oma59t= p_oma.oma59t+ p_omb.omb18t   #本幣發票含稅金額
     LET p_oma.oma59x= p_oma.oma59t- p_oma.oma59    #本幣發票稅額
     LET p_oma.oma54 = p_oma.oma54+p_omb.omb14      #原幣應收未稅金額
     LET p_oma.oma54t= p_oma.oma54t+p_omb.omb14t    #原幣應收含稅金額
     LET p_oma.oma54x= p_oma.oma54t - p_oma.oma54   #原幣應收稅額
     LET p_oma.oma56 = p_oma.oma56+p_omb.omb16      #本幣應收未稅金額
     LET p_oma.oma56t= p_oma.oma56t+p_omb.omb16t    #本幣應收含稅金額
     LET p_oma.oma56x= p_oma.oma56t - p_oma.oma56   #本幣應收稅額
     CALL cl_digcut(p_oma.oma56 ,s_azi.azi04) RETURNING p_oma.oma56 
     CALL cl_digcut(p_oma.oma56t,s_azi.azi04) RETURNING p_oma.oma56t
     CALL cl_digcut(p_oma.oma56x,s_azi.azi04) RETURNING p_oma.oma56x
     LET p_oma.oma61 = p_oma.oma56t - p_oma.oma57     #bug no:A060
     #新增至單身檔
     IF p_ogb.ogb1005 = '2' THEN                 #表示返利
        LET p_omb.omb38 = '4'                    #出貨返利
        LET p_omb.omb39 = 'N'
        LET p_omb.omb04 = ''
        LET p_omb.omb05 = ''
        LET p_omb.omb06 = ''
        LET p_omb.omb12 = 0
        LET p_omb.omb13 = 0
        LET p_omb.omb15 = 0
        LET p_omb.omb17 = 0
        LET p_omb.omb14 = p_omb.omb14 * (-1)     #原幣未稅金額
        LET p_omb.omb14t = p_omb.omb14  * (1+p_oma.oma211/100)
        LET p_omb.omb16  = p_omb.omb14  * p_oma.oma24
        LET p_omb.omb16t = p_omb.omb14t * p_oma.oma24
        LET p_omb.omb18  = p_omb.omb14  * p_oma.oma58
        LET p_omb.omb18t = p_omb.omb14t * p_oma.oma58
        
        CALL cl_digcut(p_omb.omb14t,p_azi.azi04) RETURNING p_omb.omb14t  #MOD-820015 modify s_azi->p_azi
        CALL cl_digcut(p_omb.omb16, s_azi.azi04) RETURNING p_omb.omb16
        CALL cl_digcut(p_omb.omb16t,s_azi.azi04) RETURNING p_omb.omb16t
        CALL cl_digcut(p_omb.omb18, s_azi.azi04) RETURNING p_omb.omb18
        CALL cl_digcut(p_omb.omb18t,s_azi.azi04) RETURNING p_omb.omb18t
        LET p_oma.oma50 = p_oma.oma50  + p_omb.omb14   #MOD-A40029   oma14-->omb14
        LET p_oma.oma50t= p_oma.oma50t + p_omb.omb14t  #MOD-A40029   oma14-->omb14t
        LET p_oma.oma59 = p_oma.oma59  + p_omb.omb18   #本幣發票未稅金額
        LET p_oma.oma59t= p_oma.oma59t + p_omb.omb18t  #本幣發票含稅金額
        LET p_oma.oma59x= p_oma.oma59t - p_oma.oma59   #本幣發票稅額
        LET p_oma.oma54 = p_oma.oma54  + p_omb.omb14   #原幣應收未稅金額
        LET p_oma.oma54t= p_oma.oma54t + p_omb.omb14t  #原幣應收含稅金額
        LET p_oma.oma54x= p_oma.oma54t - p_oma.oma54   #原幣應收稅額
        LET p_oma.oma56 = p_oma.oma56  + p_omb.omb16   #本幣應收未稅金額
        LET p_oma.oma56t= p_oma.oma56t + p_omb.omb16t  #本幣應收含稅金額
        LET p_oma.oma56x= p_oma.oma56t - p_oma.oma56   #本幣應收稅額
        CALL cl_digcut(p_oma.oma50 ,p_azi.azi04) RETURNING p_oma.oma50   #MOD-A40029  s_azi-->p_azi
        CALL cl_digcut(p_oma.oma50t,p_azi.azi04) RETURNING p_oma.oma50t  #MOD-A40029  s_azi-->p_azi
        CALL cl_digcut(p_oma.oma56 ,s_azi.azi04) RETURNING p_oma.oma56 
        CALL cl_digcut(p_oma.oma56t,s_azi.azi04) RETURNING p_oma.oma56t
        CALL cl_digcut(p_oma.oma56x,s_azi.azi04) RETURNING p_oma.oma56x
     ELSE
        LET p_omb.omb38 = '2'                    #出貨單 
        LET p_omb.omb39 = p_ogb.ogb1012          #搭贈
        IF p_omb.omb39 = 'Y' THEN                #如為搭贈
           LET p_omb.omb14 = 0
           LET p_omb.omb14t= 0
           LET p_omb.omb16 = 0
           LET p_omb.omb16t= 0
           LET p_omb.omb18 = 0
           LET p_omb.omb18t= 0
        END IF
        #單頭之發票金額
        LET p_oma.oma50 = p_oma.oma50  + p_omb.omb14  #原幣應收未稅金額
        LET p_oma.oma50t= p_oma.oma50t + p_omb.omb14t #原幣應收未稅金額
        CALL cl_digcut(p_oma.oma50 ,p_azi.azi04) RETURNING p_oma.oma50   #MOD-A40029  s_azi-->p_azi
        CALL cl_digcut(p_oma.oma50t,p_azi.azi04) RETURNING p_oma.oma50t  #MOD-A40029  s_azi-->p_azi
     END IF
 
     LET p_omb.omb930 = p_ogb.ogb930  #出貨單身成本中心 #MOD-920266 
     CALL p861_ins_omb()
END FUNCTION
 
FUNCTION p861_ins_omb()
   DEFINE l_legal   LIKE azw_file.azw02 #FUN-980006 add
    #新增應收帳款單身檔
    #LET l_sql1="INSERT INTO ",p_dbs CLIPPED,"omb_file", 
    LET l_sql1="INSERT INTO ",cl_get_target_table(p_plant,'omb_file'), #FUN-A50102 
               "(omb00,omb01,omb03,omb04, ",
               " omb05,omb06,omb12,omb13,",
               " omb14,omb14t,omb15,omb16,",
               " omb16t,omb17,omb18,omb18t,",
               " omb31,omb32,omb33,omb331,omb34,",  #No.FUN-6A0026
               " omb38,omb39,",                  #No.FUN-670026
               " omb35,omb36,omb37,omb930,omblegal) ",   #,ombplant) ", #A060 #MOD-920266 add omb930 #FUN-960141 add ombplant   #FUN-960141 090824 del ombplant #FUN-980006 add omblegal
               " VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                        "?,?,?,?,? ,?,? ,?,?,?,?,?) "  #A060  #No.FUN-670026   #No.FUN-6A0026 #MOD-920266 #FUN-960141 add 1 ?   #FUN-960141 090824 del 1 ? #FUN-980006 add ? for omblegal  
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,p_plant) RETURNING l_sql1 #FUN-A50102
         CALL s_getlegal(p_plant) RETURNING l_legal #FUN-980006 add
           PREPARE ins_omb FROM l_sql1
           EXECUTE ins_omb USING 
                p_omb.omb00,p_omb.omb01,p_omb.omb03,p_omb.omb04, 
                p_omb.omb05,p_omb.omb06,p_omb.omb12,p_omb.omb13,
                p_omb.omb14,p_omb.omb14t,p_omb.omb15,p_omb.omb16,
                p_omb.omb16t,p_omb.omb17,p_omb.omb18,p_omb.omb18t,
                p_omb.omb31,p_omb.omb32,p_omb.omb33,p_omb.omb331,p_omb.omb34,   #No.FUN-6A0026
                p_omb.omb38,p_omb.omb39,         #No.FUN-670026
                p_omb.omb35,p_omb.omb36,p_omb.omb37,p_omb.omb930               #MOD-920266
                ,l_legal  #FUN-980006 add l_legal  
           IF SQLCA.sqlcode<>0 THEN
              CALL cl_err('ins omb:',SQLCA.sqlcode,1)
              LET g_success = 'N'
           END IF
END FUNCTION
 
FUNCTION p861_apb()
  DEFINE l_ccz07 LIKE ccz_file.ccz07     #No.9740
  DEFINE l_gec  RECORD LIKE gec_file.*,
         l_apt  RECORD LIKE apt_file.*,
         l_sql  LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(400)
  DEFINE l_sum   LIKE type_file.num20_6         #MOD-B10237
  DEFINE l_sum_1 LIKE type_file.num20_6         #MOD-B10237  
  DEFINE l_rvw06f LIKE rvw_file.rvw06f          #MOD-B10237
  
           
  IF cl_null(p_pmm.pmm42) THEN LET p_pmm.pmm42=1 END IF
  LET p_apa.apa16= p_pmm.pmm43    #稅率
  CALL s_currm(p_pmm.pmm22,p_oma.oma02,p_apz.apz33,p_plant) RETURNING p_apa.apa14  #FUN-980020
  #讀取稅別資料
  LET l_sql = "SELECT * ",
              #" FROM ",p_dbs CLIPPED,"gec_file ",
              " FROM ",cl_get_target_table(p_plant,'gec_file'), #FUN-A50102
              " WHERE gec01 = '",p_pmm.pmm21,"' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
  PREPARE gec_p1 FROM l_sql 
  IF SQLCA.SQLCODE THEN CALL cl_err('gec_p1',SQLCA.SQLCODE,1) END IF
  DECLARE gec_c1 CURSOR FOR gec_p1
  OPEN gec_c1
  FETCH gec_c1 INTO l_gec.*
  IF SQLCA.SQLCODE THEN
     LET g_msg = p_dbs CLIPPED,p_pmm.pmm21
     CALL cl_err(g_msg,'axm-142',1) 
     LET g_success='N' RETURN
  END IF
  IF p_gec.gec04 > 0 AND cl_null(p_gec.gec02) THEN
     CALL cl_err(g_msg CLIPPED,'tri-020',1)
     LET g_success='N' RETURN
  END IF
  CLOSE gec_c1
  #讀取入庫單單身檔資料(rvv_file)
  LET l_sql = "SELECT * ",
              #" FROM ",p_dbs_tra CLIPPED,"rvv_file ",       #FUN-980020
              " FROM ",cl_get_target_table(p_plant,'rvv_file'), #FUN-A50102
              " WHERE rvv01 = '",p_rvu01,"' ",     #入庫單
              "  AND rvv02 =",s_rvv.rvv02
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980020 自動加上plant的關聯條件 
  PREPARE rvv_p2 FROM l_sql 
  IF SQLCA.SQLCODE THEN CALL cl_err('rvv_p2',SQLCA.SQLCODE,1) END IF
  DECLARE rvv_c2 CURSOR FOR rvv_p2
  OPEN rvv_c2
  FETCH rvv_c2 INTO p_rvv.* 
  CLOSE rvv_c2
 
  #讀取應付帳款單身檔資料(apb_file)
  LET l_sql = "SELECT * ",
              #" FROM ",p_dbs_tra CLIPPED,"pmn_file ",   #FUN-980020
              " FROM ",cl_get_target_table(p_plant,'pmn_file'), #FUN-A50102
               " WHERE pmn01 = '",s_rvv.rvv36,"' ",  #訂單單號 No.MOD-4A0361
               "  AND pmn02 =",s_rvv.rvv37           #No.MOD-4A0361
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-920032
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980020 自動加上plant的關聯條件 
  PREPARE pmn_p2 FROM l_sql 
  IF SQLCA.SQLCODE THEN CALL cl_err('pmn_p2',SQLCA.SQLCODE,1) END IF
  DECLARE pmn_c2 CURSOR FOR pmn_p2
  OPEN pmn_c2
  FETCH pmn_c2 INTO p_pmn.* 
  CLOSE pmn_c2
 
     LET p_apb.apb01= p_apa.apa01    #帳款編號    No.8166
     LET p_apb.apb02= p_rvv.rvv02    #項次
     LET p_apb.apb03 = null          #no use
     LET p_apb.apb04 = p_rvv.rvv04   #驗收單號
     LET p_apb.apb05 = p_rvv.rvv05   #驗收項次
     LET p_apb.apb06 = p_pmn.pmn01   #採購單號
     LET p_apb.apb07 = p_pmn.pmn02   #採購項次
        #本幣單價(付款未稅)
        LET p_apb.apb08 = p_rvv.rvv38*p_pmm.pmm42
 
     LET p_apb.apb081= p_apb.apb08
        LET p_apb.apb09 = p_rvv.rvv87   #計價數量   
     #LET p_apb.apb10 = p_rvv.rvv38*p_pmm.pmm42*p_apb.apb09   #MOD-B30704 
     #LET p_apb.apb10 = cl_digcut(p_rvv.rvv38*p_apb.apb09,l_azi.azi04)*p_pmm.pmm42   #MOD-B30704  #MOD-C30815 mark
#MOD-C30815 add begin #本幣金額(付款未稅)
     IF l_gec.gec07 = 'Y' THEN 
        IF l_gec.gec05 = 'T' THEN 
           LET p_apb.apb10 = p_rvv.rvv39t * (1-p_pmm.pmm43/100) * p_pmm.pmm42
           LET p_apb.apb10 = cl_digcut(p_apb.apb10,s_azi.azi04)  #MOD-C80072 add
           #LET p_apb.apb10 = cl_digcut(p_apb.apb10,l_azi.azi04) #MOD-C80072 mark 
        ELSE 
           LET p_apb.apb10 = p_rvv.rvv39t / (1+p_pmm.pmm43/100) * p_pmm.pmm42
           LET p_apb.apb10 = cl_digcut(p_apb.apb10,s_azi.azi04)  #MOD-C80072 add
           #LET p_apb.apb10 = cl_digcut(p_apb.apb10,l_azi.azi04) #MOD-C80072 mark
        END IF 
     ELSE      	  
     	  LET p_apb.apb10 = p_rvv.rvv39*p_pmm.pmm42
     	  LET p_apb.apb10 = cl_digcut(p_apb.apb10,s_azi.azi04)  #MOD-C80072 add
     	  #LET p_apb.apb10 = cl_digcut(p_apb.apb10,l_azi.azi04) #MOD-C80072 mark
     END IF 	     	     
#MOD-C30815 add end     
     LET p_apb.apb101= p_apb.apb10   #no.6509
     LET p_apb.apb11 = null          #原發票號碼
     LET p_apb.apb12 = p_rvv.rvv31   #料號
     LET p_apb.apb13f = 0            #原幣折讓單價
     LET p_apb.apb13  = 0            #本幣折讓單價
     LET p_apb.apb14f = 0            #原幣折讓金額
     LET p_apb.apb14  = 0            #本幣折讓金額
     LET p_apb.apb15  = 0            #折讓數量
     LET p_apb.apb16  = 'N'          #本幣折讓金額
     LET p_apb.apb21  = p_rvu01      #入庫單號 
     LET p_apb.apb22  = s_rvv.rvv02  #入庫項次
     LET p_apb.apb34  = 'N'          #No.TQC-7B0083
        #原幣單價(付款未稅)
        LET p_apb.apb23 = p_rvv.rvv38
     #LET p_apb.apb24 = p_apb.apb23 * p_apb.apb09     #原幣金額(付款未稅) ##MOD-C30815 mark
#MOD-C30815 add begin #原幣金額(付款未稅)
     IF l_gec.gec07 = 'Y' THEN 
        IF l_gec.gec05 = 'T' THEN 
           LET p_apb.apb24 = p_rvv.rvv39t * (1-p_pmm.pmm43/100) 
           #LET p_apb.apb24 = cl_digcut(p_apb.apb10,l_azi.azi04) #MOD-C30909 mark 
           LET p_apb.apb24 = cl_digcut(p_apb.apb24,l_azi.azi04)  #MOD-C30909 add
        ELSE 
        	 LET p_apb.apb24 = p_rvv.rvv39t / (1+p_pmm.pmm43/100) 
           #LET p_apb.apb24 = cl_digcut(p_apb.apb10,l_azi.azi04) #MOD-C30909 mark
           LET p_apb.apb24 = cl_digcut(p_apb.apb24,l_azi.azi04)  #MOD-C30909 add
        END IF 
     ELSE      	  
     	  LET p_apb.apb24 = p_rvv.rvv39
     	  #LET p_apb.apb24 = cl_digcut(p_apb.apb10,l_azi.azi04) #MOD-C30909 mark
          LET p_apb.apb24 = cl_digcut(p_apb.apb24,l_azi.azi04)  #MOD-C30909 add
     END IF 	     	     
#MOD-C30815 add end     
        IF p_apz.apz13='N'  THEN   #系統參數設定是否設部門會計科目
           #讀取會計科目
           LET l_sql = "SELECT * ",
                       #" FROM ",p_dbs CLIPPED,"apt_file ",
                       " FROM ",cl_get_target_table(p_plant,'apt_file'), #FUN-A50102
                       " WHERE apt01 = '",p_poy17,"' " ,
                       " AND (apt02=' ' OR apt02 IS NULL) "
        ELSE
           #依帳款類別+部門
           LET l_sql = "SELECT * ",
                       #" FROM ",p_dbs CLIPPED,"apt_file ",
                       " FROM ",cl_get_target_table(p_plant,'apt_file'), #FUN-A50102
                       " WHERE apt01 = '",p_poy17,"' " ,
                       " AND apt02='",p_poy19,"' "         #MOD-8A0240
        END IF
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
        PREPARE apt_p2 FROM l_sql 
        IF SQLCA.SQLCODE THEN CALL cl_err('apt_p1',SQLCA.SQLCODE,1) END IF
        DECLARE apt_c2 CURSOR FOR apt_p2
        OPEN apt_c2
        FETCH apt_c2 INTO l_apt.* 
        IF SQLCA.SQLCODE THEN
           CALL cl_err(p_dbs clipped,'axr-186',1) 
           LET g_success='N' CLOSE apt_c2 RETURN
        END IF
        CLOSE apt_c2
     IF NOT cl_null(p_pmn.pmn40) THEN
        LET p_apb.apb25 = p_pmn.pmn40
     END IF  #CHI-8A0026
        IF l_apt.apt03 = 'STOCK' THEN
           LET p_apb.apb25 = ''            #會計科目
           #抓取參數設定axcs010
           LET l_sql = "SELECT ccz07 ",
                       #" FROM ",p_dbs CLIPPED,"ccz_file ",
                       " FROM ",cl_get_target_table(p_plant,'ccz_file'), #FUN-A50102
                       " WHERE ccz00 = '0' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
           PREPARE ccz_p1 FROM l_sql
           IF SQLCA.SQLCODE THEN CALL cl_err('ccz_p1',SQLCA.SQLCODE,1) END IF
           DECLARE ccz_c1 CURSOR FOR ccz_p1
           OPEN ccz_c1
           FETCH ccz_c1 INTO l_ccz07
           CLOSE ccz_c1
           #依參數抓取存貨科目
           CASE WHEN l_ccz07='1'
                     #LET l_sql="SELECT ima39 FROM ",p_dbs CLIPPED,"ima_file ",
                     LET l_sql="SELECT ima39 FROM ",cl_get_target_table(p_plant,'ima_file'), #FUN-A50102
                               " WHERE ima01='",p_rvv.rvv31,"'"
                WHEN l_ccz07='2'
                     LET l_sql="SELECT imz39 ",
                         #" FROM ",p_dbs CLIPPED,"ima_file,",
                         #         p_dbs CLIPPED,"imz_file ",
                         " FROM ",cl_get_target_table(p_plant,'ima_file'),",", #FUN-A50102
                                  cl_get_target_table(p_plant,'imz_file'),     #FUN-A50102
                         " WHERE ima01='",p_rvv.rvv31,"' AND ima06=imz01 "
                WHEN l_ccz07='3'
                     #LET l_sql="SELECT imd08 FROM ",p_dbs,"imd_file",
                     LET l_sql="SELECT imd08 FROM ",cl_get_target_table(p_plant,'imd_file'), #FUN-A50102
                         " WHERE imd01='",p_rvv.rvv32,"'"
                WHEN l_ccz07='4'
                     #LET l_sql="SELECT ime09 FROM ",p_dbs CLIPPED,"ime_file",
                     LET l_sql="SELECT ime09 FROM ",cl_get_target_table(p_plant,'ime_file'), #FUN-A50102
                         " WHERE ime01='",p_rvv.rvv32,"' ",
                           " AND ime02='",p_rvv.rvv33,"'",
                           " AND imeacti='Y' "  #FUN-D40103 add
          END CASE
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
          PREPARE stock_p1 FROM l_sql
          IF SQLCA.SQLCODE THEN CALL cl_err('stock_p1',SQLCA.SQLCODE,1) END IF
          DECLARE stock_c1 CURSOR FOR stock_p1
          OPEN stock_c1
          FETCH stock_c1 INTO p_apb.apb25
          CLOSE stock_c1
 
        ELSE
           LET p_apb.apb25 = l_apt.apt03
        END IF
     IF p_aza.aza63 = 'Y'  THEN  #No.TQC-7C0107
     IF NOT cl_null(p_pmn.pmn401) THEN
        LET p_apb.apb251 = p_pmn.pmn401
     END IF #CHI-8A0026
        IF l_apt.apt031 = 'STOCK' THEN
           LET p_apb.apb251 = ''            #會計科目
           #抓取參數設定axcs010
           LET l_sql = "SELECT ccz07 ",
                       #" FROM ",p_dbs CLIPPED,"ccz_file ",
                       " FROM ",cl_get_target_table(p_plant,'ccz_file'), #FUN-A50102
                       " WHERE ccz00 = '0' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
           PREPARE ccz_p11 FROM l_sql
           IF SQLCA.SQLCODE THEN CALL cl_err('ccz_p1',SQLCA.SQLCODE,1) END IF
           DECLARE ccz_c11 CURSOR FOR ccz_p11
           OPEN ccz_c11
           FETCH ccz_c11 INTO l_ccz07
           CLOSE ccz_c11
           #依參數抓取存貨科目
           CASE WHEN l_ccz07='1'
                     #LET l_sql="SELECT ima391 FROM ",p_dbs CLIPPED,"ima_file ",
                     LET l_sql="SELECT ima391 FROM ",cl_get_target_table(p_plant,'ima_file'), #FUN-A50102
                               " WHERE ima01='",p_rvv.rvv31,"'"
                WHEN l_ccz07='2'
                     LET l_sql="SELECT imz391 ",
                         #" FROM ",p_dbs CLIPPED,"ima_file,",
                         #         p_dbs CLIPPED,"imz_file ",
                         " FROM ",cl_get_target_table(p_plant,'ima_file'),",", #FUN-A50102
                                  cl_get_target_table(p_plant,'imz_file'),     #FUN-A50102
                         " WHERE ima01='",p_rvv.rvv31,"' AND ima06=imz01 "
                WHEN l_ccz07='3'
                     #LET l_sql="SELECT imd081 FROM ",p_dbs,"imd_file",
                     LET l_sql="SELECT imd081 FROM ",cl_get_target_table(p_plant,'imd_file'), #FUN-A50102
                         " WHERE imd01='",p_rvv.rvv32,"'"
                WHEN l_ccz07='4'
                     #LET l_sql="SELECT ime091 FROM ",p_dbs CLIPPED,"ime_file",
                     LET l_sql="SELECT ime091 FROM ",cl_get_target_table(p_plant,'ime_file'), #FUN-A50102
                         " WHERE ime01='",p_rvv.rvv32,"' ",
                           " AND ime02='",p_rvv.rvv33,"'",
                           " AND imeacti='Y' "  #FUN-D40103 add

          END CASE
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
          PREPARE stock_p11 FROM l_sql
          IF SQLCA.SQLCODE THEN CALL cl_err('stock_p1',SQLCA.SQLCODE,1) END IF
          DECLARE stock_c11 CURSOR FOR stock_p11
          OPEN stock_c11
          FETCH stock_c11 INTO p_apb.apb251
          CLOSE stock_c11
        ELSE
           LET p_apb.apb251 = l_apt.apt031
        END IF
  END IF
     LET p_apb.apb26 = p_rvu.rvu06   #部門
      LET p_apb.apb27 = p_rvv.rvv031   #品名 #MOD-540126
        LET p_apb.apb28 = p_rvv.rvv86   #計價單位   
     LET p_apb.apb29 = '1'           #異動類別
 
     CALL cl_digcut(p_apb.apb08,s_azi.azi03)  RETURNING p_apb.apb08
     CALL cl_digcut(p_apb.apb081,s_azi.azi03) RETURNING p_apb.apb081
     CALL cl_digcut(p_apb.apb10,s_azi.azi04)  RETURNING p_apb.apb10
     CALL cl_digcut(p_apb.apb101,s_azi.azi04) RETURNING p_apb.apb101 #no.6509
     CALL cl_digcut(p_apb.apb23,l_azi.azi03)  RETURNING p_apb.apb23
     CALL cl_digcut(p_apb.apb24,l_azi.azi04)  RETURNING p_apb.apb24
 
     IF p_rvv.rvv25='Y' THEN  #No.9421
        LET p_apb.apb23=0
        LET p_apb.apb24=0
        LET p_apb.apb08=0
        LET p_apb.apb081=0
        LET p_apb.apb10=0
        LET p_apb.apb101=0
        LET p_apb.apb23=0
        LET p_apb.apb24=0
        #----------------計算單頭金額-----------------------------
        #記錄採購出貨金額(原幣)
        LET p_apa31f= p_apa31f + 0
        #本幣採購出貨金額
        LET p_apa31 = p_apa31  + 0
        #LET p_apa32f= p_apa32f + 0 #MOD-C70105 #TQC-C90045 mark
        #LET p_apa32= p_apa32 + 0  #MOD-C70105  #TQC-C90045 mark      
     ELSE
        #----------------計算單頭金額-----------------------------
           #記錄採購出貨金額(原幣)
#           LET p_apa31f= p_apa31f + p_rvv.rvv38*p_rvv.rvv87                #MOD-B10237 
           #本幣採購出貨金額
#           LET p_apa31 = p_apa31  + p_rvv.rvv38*p_pmm.pmm42*p_rvv.rvv87    #MOD-B10237

#MOD-B10237 --begin--           
#MOD-C30815 add 不用含稅單價 * 計價數量 來算稅額,避免產生尾差,改用含稅推未稅(或者直接從rvv39,rvv39t取值)
          #LET l_sum = p_rvv.rvv38t * p_rvv.rvv87        #tax   #MOD-C30815 mark
          #LET l_sum_1 = p_rvv.rvv38 * p_rvv.rvv87       #untax #MOD-C30815 mark
          LET l_sum   = p_rvv.rvv39t #含稅金額 #MOD-C30815 add
          LET l_sum_1 = p_rvv.rvv39  #未稅金額 #MOD-C30815 add          
          CALL cl_digcut(l_sum,l_azi.azi04) RETURNING l_sum
          CALL cl_digcut(l_sum_1,l_azi.azi04) RETURNING l_sum_1          
          #LET  p_apa32f = p_apa32f + l_sum - l_sum_1 #MOD-C70105 #TQC-C90045 mark
          #LET  p_apa32  = p_apa32 + (l_sum - l_sum_1) *  p_pmm.pmm42  #MOD-C70105 #TQC-C90045 mark
          #LET  p_apa32  = cl_digcut(p_apa32,l_azi.azi04)   #MOD-C70105 #TQC-C90045 mark
   IF l_gec.gec07='Y' THEN
     IF l_gec.gec05 = 'T' THEN
        LET l_rvw06f = l_sum * (p_pmm.pmm43/100)
        LET l_rvw06f = cl_digcut(l_rvw06f,l_azi.azi04)
        LET l_sum = l_sum - l_rvw06f 
        LET l_sum = cl_digcut(l_sum,l_azi.azi04)  
        LET p_apa31f = p_apa31f + l_sum
        LET p_apa31  = p_apa31  + l_sum*p_pmm.pmm42        
     ELSE
        LET l_sum = l_sum / (1+ p_pmm.pmm43/100)
        LET l_sum = cl_digcut(l_sum,l_azi.azi04)  
        LET p_apa31f = p_apa31f + l_sum        
        LET p_apa31  = p_apa31  + l_sum*p_pmm.pmm42             
     END IF 
  ELSE
     #MOD-B40190 mod --start--
     #LET l_sum = l_sum_1*(1+p_pmm.pmm43/100)
     #LET l_sum = cl_digcut(l_sum,l_azi.azi04)  
     #LET p_apa31f = p_apa31f + l_sum
     #LET p_apa31  = p_apa31  + l_sum*p_pmm.pmm42         
      LET p_apa31f = p_apa31f + l_sum_1
      LET p_apa31  = p_apa31  + l_sum_1*p_pmm.pmm42
     #MOD-B40190 mod --end--
   END IF          
#MOD-B10237 --end--
     END IF
     CALL cl_digcut(p_apa31f,l_azi.azi04) RETURNING p_apa31f
     CALL cl_digcut(p_apa31,s_azi.azi04) RETURNING p_apa31
 
     LET p_apb.apb930 = p_rvv.rvv930  #MOD-920266
 
     #新增至單身檔
     CALL p861_ins_apb()
END FUNCTION
 
FUNCTION p861_ins_apb()
    DEFINE l_legal LIKE azw_file.azw02 #FUN-980006 add
    #新增應付帳款單身檔
    #LET l_sql1="INSERT INTO ",p_dbs CLIPPED,"apb_file",
   LET l_sql1="INSERT INTO ",cl_get_target_table(p_plant,'apb_file'), #FUN-A50102
               "(apb01 ,apb02,apb03,apb04, ",
               " apb05 ,apb06,apb07,apb08, ",
               " apb081,apb09,apb10,apb101,",
               " apb11 ,apb12,apb13f,apb13,",
               " apb14f,apb14,apb15,apb16, ",
               " apb21 ,apb22,apb23,apb24, ",
               " apb25 ,apb251,apb26,apb27,apb28, ",    #No.FUN-6A0026
               " apb29,apb34,apb930,apblegal) ", #No.TQC-7B0083 #MOD-920266 #FUN-960141 add apbplant   #FUN-960141 del apbplant 090824 #FUN-980006 add apblegal
               " VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
               "         ?,?,?,?, ?,?,?,?, ?,?,?,?,?, ?,?,?, ?)"   #No.FUN-6A0026  #No.TQC-7B0083 #MOD-920266 #FUN-960141 add 1 ?  #FUN-960141del 1? 090824 #FUN-980006 add ?
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,p_plant) RETURNING l_sql1 #FUN-A50102
         CALL s_getlegal(p_plant) RETURNING l_legal #FUN-980006 add
           PREPARE ins_apb FROM l_sql1
           EXECUTE ins_apb USING 
                p_apb.apb01 ,p_apb.apb02,p_apb.apb03,p_apb.apb04,
                p_apb.apb05 ,p_apb.apb06,p_apb.apb07,p_apb.apb08,
                p_apb.apb081,p_apb.apb09,p_apb.apb10,p_apb.apb101,
                p_apb.apb11,p_apb.apb12 ,p_apb.apb13f,p_apb.apb13,
                p_apb.apb14f,p_apb.apb14,p_apb.apb15,p_apb.apb16,
                p_apb.apb21,p_apb.apb22 ,p_apb.apb23,p_apb.apb24,
                p_apb.apb25,p_apb.apb251,p_apb.apb26 ,p_apb.apb27,p_apb.apb28,   #No.FUN-6A0026
                p_apb.apb29,p_apb.apb34,p_apb.apb930  #No.TQC-7B0083  #MOD-920266
                ,l_legal  #FUN-980006 add l_legal
           IF SQLCA.sqlcode<>0 THEN
              CALL cl_err('ins apb:',SQLCA.sqlcode,1)
              LET g_success = 'N'
           END IF
END FUNCTION
 
#更新rvb06(驗收單之已請款量)
FUNCTION p861_u_rvb06()
#DEFINE l_qty  LIKE ima_file.ima01      #No.FUN-680136 DECIMAL(12,3)  #MOD-920190  mark
 DEFINE l_qty  LIKE rvb_file.rvb06      #MOD-920190   

  #LET l_sql = " SELECT SUM(apb09) FROM ",p_dbs," apb_file ",
  LET l_sql = " SELECT SUM(apb09) FROM ",cl_get_target_table(p_plant,'apb_file'), #FUN-A50102
              "  WHERE apb04 = '",p_apb.apb04,"'",
              "    AND apb05 = ",p_apb.apb05
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
  PREPARE rvb06_pre FROM l_sql
  DECLARE sum_rvb06 CURSOR FOR rvb06_pre
  OPEN sum_rvb06 
  FETCH sum_rvb06 INTO l_qty
  CLOSE sum_rvb06
  IF cl_null(l_qty) THEN LET l_qty = 0 END IF

  #LET l_sql = " UPDATE ",p_dbs_tra," rvb_file SET rvb06 = ? ", #FUN-980020 
  LET l_sql = " UPDATE ",cl_get_target_table(p_plant,'rvb_file'), #FUN-A50102
              "    SET rvb06 = ? ",
              "  WHERE rvb01 = '",p_apb.apb04,"'",
              "    AND rvb02 = ",p_apb.apb05
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
  PREPARE upd_rvb06 FROM l_sql
  EXECUTE upd_rvb06 USING l_qty
  IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
     CALL cl_err('upd rvb06:',SQLCA.SQLCODE,1) LET g_success='N'
  END IF
END FUNCTION
 
#更新rvv23(入庫單之已請款匹配量)
FUNCTION p861_u_rvv23()
 DEFINE l_qty  LIKE rvv_file.rvv23      #MOD-920190 
 
  #LET l_sql = " SELECT SUM(apb09) FROM ",p_dbs," apb_file ", 
  LET l_sql = " SELECT SUM(apb09) FROM ",cl_get_target_table(p_plant,'apb_file'), #FUN-A50102   
              "  WHERE apb21 = '",p_apb.apb21,"'",
              "    AND apb22 = ",p_apb.apb22
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
  PREPARE rvv23_pre FROM l_sql
  DECLARE sum_rvv23 CURSOR FOR rvv23_pre
  OPEN sum_rvv23 
  FETCH sum_rvv23 INTO l_qty
  CLOSE sum_rvv23
  IF cl_null(l_qty) THEN LET l_qty = 0 END IF
 
  #LET l_sql = " UPDATE ",p_dbs_tra," rvv_file SET rvv23 = ? ",   #FUN-980020
  LET l_sql = " UPDATE ",cl_get_target_table(p_plant,'rvv_file'), #FUN-A50102
              "    SET rvv23 = ? ",
              "  WHERE rvv01 = '",p_apb.apb21,"'",
              "    AND rvv02 = ",p_apb.apb22
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
  PREPARE upd_rvv23 FROM l_sql
  EXECUTE upd_rvv23 USING l_qty
  IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
     CALL cl_err('upd rvv23:',SQLCA.SQLCODE,1) LET g_success='N'
  END IF
END FUNCTION
 
FUNCTION p861_ins_oma()
  DEFINE l_oga53 LIKE oga_file.oga53
  DEFINE l_legal LIKE azw_file.azw02 #FUN-980006 add

  #MOD-B20058 add --start--
  IF p_oma.oma02<=p_ooz.ooz09 THEN 
     LET g_msg = p_dbs CLIPPED,p_oma.oma01
     CALL cl_err(g_msg CLIPPED,'axr-164',1) 
     LET g_success ='N'
     RETURN
  END IF
  #MOD-B20058 add --end--
 
  IF p_oma.oma59 < 0 THEN
     LET p_oma.oma59 = 0 
  END IF
  IF p_oma.oma59t < 0 THEN
     LET p_oma.oma59t = 0 
  END IF
  IF p_oma.oma59x < 0 THEN
     LET p_oma.oma59x = 0 
  END IF
  IF cl_null(p_oma.oma50)  THEN LET p_oma.oma50 = 0 END IF
  IF cl_null(p_oma.oma50t) THEN LET p_oma.oma50t= 0 END IF
  IF cl_null(p_oma.oma52)  THEN LET p_oma.oma52 = 0 END IF
  IF cl_null(p_oma.oma53)  THEN LET p_oma.oma53 = 0 END IF
  IF cl_null(p_oma.oma54)  THEN LET p_oma.oma54 = 0 END IF
  IF cl_null(p_oma.oma54x) THEN LET p_oma.oma54x= 0 END IF
  IF cl_null(p_oma.oma54t) THEN LET p_oma.oma54t= 0 END IF
  IF cl_null(p_oma.oma55)  THEN LET p_oma.oma55 = 0 END IF
  IF cl_null(p_oma.oma56)  THEN LET p_oma.oma56 = 0 END IF
  IF cl_null(p_oma.oma56x) THEN LET p_oma.oma56x= 0 END IF
  IF cl_null(p_oma.oma56t) THEN LET p_oma.oma56t= 0 END IF
  IF cl_null(p_oma.oma57)  THEN LET p_oma.oma57 = 0 END IF
  IF cl_null(p_oma.oma58)  THEN LET p_oma.oma58 = 0 END IF
  IF cl_null(p_oma.oma59)  THEN LET p_oma.oma59 = 0 END IF
  IF cl_null(p_oma.oma59x) THEN LET p_oma.oma59x= 0 END IF
  IF cl_null(p_oma.oma59t) THEN LET p_oma.oma59t= 0 END IF
  LET p_oma.oma61 = p_oma.oma56t -p_oma.oma57           #bug no:A060 
  CALL cl_digcut(p_oma.oma59 ,s_azi.azi04) RETURNING p_oma.oma59  
  CALL cl_digcut(p_oma.oma59t,s_azi.azi04) RETURNING p_oma.oma59t  
  CALL cl_digcut(p_oma.oma59x,s_azi.azi04) RETURNING p_oma.oma59x  
  CALL cl_digcut(p_oma.oma54 ,p_azi.azi04) RETURNING p_oma.oma54   #MOD-A40029  s_azi-->p_azi
  CALL cl_digcut(p_oma.oma54t,p_azi.azi04) RETURNING p_oma.oma54t  #MOD-A40029  s_azi-->p_azi
  CALL cl_digcut(p_oma.oma54x,p_azi.azi04) RETURNING p_oma.oma54x  #MOD-A40029  s_azi-->p_azi
 
  #IF p_oma.oma00 = '12' AND g_oax.oax04 = 'Y' THEN   #MOD-A20110
  IF p_oma.oma00 = '12' THEN   #MOD-A20110
     LET p_oma.oma67 = p_oga.oga27
  END IF
 
   LET p_oma.oma66 = p_oga.ogaplant    #FUN-960141 090824 add 
 
    #新增應收帳款單頭檔
    #LET l_sql1="INSERT INTO ",p_dbs CLIPPED,"oma_file",
    LET l_sql1="INSERT INTO ",cl_get_target_table(p_plant,'oma_file'), #FUN-A50102
               "(oma00,oma01,oma02, ",
               " oma03,oma032,oma04,oma042,",
               " oma043,oma044,oma05,oma06,",
               " oma07,oma08,oma09,oma10,",
               " oma11,oma12,oma13,oma14,",
               " oma15,oma16,oma161,oma162,",
               " oma163,oma17,oma171,oma172,",
               " oma173,oma174,oma175,oma18,oma181,",     #No.FUN-6A0026
               " oma19,oma20,oma21,oma211,",
               " oma212,oma213,oma23,oma24,",
               " oma25,oma26,oma32,oma33,",
               " oma34,oma35,oma36,oma37,",
               " oma38,oma39,oma40,oma50,",
               " oma50t,oma52,oma53,oma54,",
               " oma54x,oma54t,oma55,oma56,",
               " oma56x,oma56t,oma57,oma58,",
               " oma59,oma59x,oma59t,oma60,oma61,",  #A060
               " oma67,oma68,oma69,",                #No.FUN-670026	#MOD-950030
               " oma99,omaconf,", 
               " omavoid,omavoid2,omaprsw,omauser,",
               " omagrup,omamodu,omadate,oma65,oma51,oma51f,oma64,", #modify by #TQC-870023  #MOD-940111
               " oma66,omalegal,omaoriu,omaorig,oma73,oma73f,oma74)", #TQC-A10060 add omaoriu,omaorig   #FUN-960141   #FUN-960141 090824 omaplant-->oma66 #FUN-980006 add omalegal FUN-AB0034 add oma73,oma73f,oma74
               " VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                        "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,?,",   #No.FUN-6A0026
                        "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,?,",   #FUN-960141 add 1 ?
                        "?,?,?,?, ?,?,?,?, ?,?,?,?,?,?, ?,?,?,?,",    #A060
                        "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?, ?,?,?,?,?,?) "  #No.FUN-670026 #TQC-A10060 add ?,?  #TQC-870023 #MOD-940111 #MOD-950030 #FUN-980006 add ? FUN-AB0034 add ???
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,p_plant) RETURNING l_sql1 #FUN-A50102
         CALL s_getlegal(p_plant) RETURNING l_legal #FUN-980006 add
           PREPARE ins_oma FROM l_sql1
#No.FUN-AB0034 --begin
         IF cl_null(p_oma.oma73) THEN LET p_oma.oma73 =0 END IF
         IF cl_null(p_oma.oma73f) THEN LET p_oma.oma73f =0 END IF
         IF cl_null(p_oma.oma74) THEN LET p_oma.oma74 ='1' END IF
#No.FUN-AB0034 --end
           EXECUTE ins_oma USING 
                p_oma.oma00,p_oma.oma01,p_oma.oma02,
                p_oma.oma03,p_oma.oma032,p_oma.oma04,p_oma.oma042,
                p_oma.oma043,p_oma.oma044,p_oma.oma05,p_oma.oma06,
                p_oma.oma07,p_oma.oma08,p_oma.oma09,p_oma.oma10,
                p_oma.oma11,p_oma.oma12,p_oma.oma13,p_oma.oma14,
                p_oma.oma15,p_oma.oma16,p_oma.oma161,p_oma.oma162,
                p_oma.oma163,p_oma.oma17,p_oma.oma171,p_oma.oma172,
                p_oma.oma173,p_oma.oma174,p_oma.oma175,p_oma.oma18,p_oma.oma181,    #No.FUN-6A0026
                p_oma.oma19,p_oma.oma20,p_oma.oma21,p_oma.oma211,
                p_oma.oma212,p_oma.oma213,p_oma.oma23,p_oma.oma24,
                p_oma.oma25,p_oma.oma26,p_oma.oma32,p_oma.oma33,
                p_oma.oma34,p_oma.oma35,p_oma.oma36,p_oma.oma37,
                p_oma.oma38,p_oma.oma39,p_oma.oma40,p_oma.oma50,
                p_oma.oma50t,p_oma.oma52,p_oma.oma53,p_oma.oma54,
                p_oma.oma54x,p_oma.oma54t,p_oma.oma55,p_oma.oma56,
                p_oma.oma56x,p_oma.oma56t,p_oma.oma57,p_oma.oma58,
                p_oma.oma59,p_oma.oma59x,p_oma.oma59t,p_oma.oma60,
                p_oma.oma61,p_oma.oma67,p_oma.oma68,p_oma.oma69,p_oma.oma99,    #bug no:A060 No.8166 #No.FUN-670026 #MOD-950030
                p_oma.omaconf,p_oma.omavoid,p_oma.omavoid2,p_oma.omaprsw,
                p_oma.omauser,p_oma.omagrup,p_oma.omamodu,p_oma.omadate,p_oma.oma65,p_oma.oma51,p_oma.oma51f,p_oma.oma64   #TQC-870023  #MOD-940111
                ,p_oma.oma66    #FUN-960141 090824 add
                ,l_legal,g_user,g_grup,p_oma.oma73,p_oma.oma73f,p_oma.oma74  #FUN-980006 add l_legal   #TQC-A10060  add g_user,g_grup   FUN-AB0034 add oma73,oma73f,oma74
            IF SQLCA.sqlcode<>0 THEN
               CALL cl_err('ins oma:',SQLCA.sqlcode,1)
               LET g_success = 'N'
            END IF
   
   LET p_oga24 = p_oga.oga24
   IF p_oga.oga23 <> p_aza.aza17  THEN  #同為本國幣別不UPDATE
      IF p_ooz.ooz10='Y' AND (p_oga.oga23 = p_oma.oma23)  THEN 
         LET p_oga24 = p_oma.oma24
      END IF 
   END IF 
   #更新出貨單頭檔
   #LET l_sql1="UPDATE ",p_dbs_tra CLIPPED,"oga_file",   #FUN-980020
   LET l_sql1="UPDATE ",cl_get_target_table(p_plant,'oga_file'), #FUN-A50102 
              " SET oga10 = ?  ,", #No.CHI-760003
              "     oga24 = ?  ",  #MOD-780090 add
              " WHERE oga01 = ? "
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
         CALL cl_parse_qry_sql(l_sql1,p_plant) RETURNING l_sql1 #FUN-980020 自動加上plant的關聯條件 
   PREPARE upd_oga FROM l_sql1
   EXECUTE upd_oga USING p_oma.oma01,p_oga24,p_oga01  #No.CHI-760003
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
       CALL cl_err('upd oga:',SQLCA.sqlcode,1)
       LET g_success = 'N'
   END IF
END FUNCTION
 
#----新增 A/R 分錄底稿單頭檔(npp_file)-------------
FUNCTION p861_ar_npp(p_npptype)      #No.FUN-6A0026  
    DEFINE p_npptype LIKE npp_file.npptype  #No.FUN-6A0026
    LET p_npp.npptype = p_npptype    #No.FUN-6A0026 
    LET p_npp.nppsys = 'AR'          #系統別
    LET p_npp.npp00 = 2              #類別 (1出貨 2應收)
    LET p_npp.npp01 = p_oma.oma01    #單號
    LET p_npp.npp011 = 1             #異動序號
    LET p_npp.npp02 =  p_oma.oma02   #異動日期 
    LET p_npp.npp03 =null            #傳票日期
    LET p_npp.npp04 =null            #No Use
    LET p_npp.npp05 =null            #拋轉種類
#   LET p_npp.npp06 =null            #工廠編號 no.7425    #MOD-AC0419 
    LET p_npp.npp06 = p_ooz.ooz02p                        #MOD-AC0419
    LET p_npp.npp07 =null            #帳別     no.7425
    LET p_npp.nppglno =null          #已拋轉傳票編號
    CALL s_get_bookno1(YEAR(p_oma.oma02),p_plant) RETURNING g_flag,g_bookno1,g_bookno2   #FUN-980020
    IF g_flag =  '1' THEN  #抓不到帳別
       CALL cl_err(p_dbs || ' ' || p_oma.oma02,'aoo-081',1)
       LET g_success = 'N'
    END IF
    LET p_npp.npp06 = p_plant     #MOD-AC0419    
    CALL p861_ins_npp()
END FUNCTION
 
FUNCTION p861_ins_npp()
    DEFINE l_legal LIKE azw_file.azw02 #FUN-980006 add
 
    #新增分錄底稿單頭檔
    #LET l_sql1="INSERT INTO ",p_dbs CLIPPED,"npp_file",  
   LET l_sql1="INSERT INTO ",cl_get_target_table(p_plant,'npp_file'), #FUN-A50102  
               "(nppsys,npp00,npp01,npp011, ",
               " npp02,npp03,npp04,npp05,",
               " npp06,npp07,nppglno,npptype,npplegal ) ",       #No.FUN-6A0026 #FUN-980006 add npplegal
               " VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?, ?) "         #No.FUN-6A0026  #FUN-980006 add ?
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1          #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,p_plant) RETURNING l_sql1 #FUN-A50102
         CALL s_getlegal(p_plant) RETURNING l_legal #FUN-980006 add
           PREPARE ins_npp FROM l_sql1
           EXECUTE ins_npp USING 
                 p_npp.nppsys,p_npp.npp00,p_npp.npp01,p_npp.npp011, 
                 p_npp.npp02,p_npp.npp03,p_npp.npp04,p_npp.npp05,
                 p_npp.npp06,p_npp.npp07,p_npp.nppglno,p_npp.npptype  #No.FUN-6A0026 
                ,l_legal  #FUN-980006 add l_legal
           IF SQLCA.sqlcode<>0 THEN
              CALL cl_err('ins npp:',SQLCA.sqlcode,1)
              LET g_success = 'N'
           END IF
END FUNCTION
 
#----預設 A/R 分錄底稿單身檔(npq_file)-------------
FUNCTION p861_def_npq()
        LET p_npq.npqsys = 'AR'          #系統別
        LET p_npq.npq00 = 2              #類別 (1出貨 2應收)
        LET p_npq.npq01 = p_oma.oma01    #單號
        LET p_npq.npq011 = 1             #異動序號
        LET p_npq.npq05 = p_oma.oma15    #部門 
        LET p_npq.npq08 = null           #專案編號
        LET p_npq.npq11 = null           #異動碼-1  
        LET p_npq.npq12 = null           #異動碼-2  
        LET p_npq.npq13 = null           #異動碼-3  
        LET p_npq.npq14 = null           #異動碼-4  
        LET p_npq.npq15 = null           #預算編號
        LET p_npq.npq21 = p_oma.oma03    #客戶編號
        LET p_npq.npq22 = p_oma.oma032   #客戶簡稱
        LET p_npq.npq23 = p_oma.oma01    #立沖單號
        LET p_npq.npq24 = p_oma.oma23    #原幣幣別
        LET p_npq.npq25 = p_oma.oma24    #匯率
        LET p_npq.npq26 = null           #No Use
        LET p_npq.npq27 = null           #No Use
        LET p_npq.npq28 = null           #No Use
        LET p_npq.npq29 = null           #No Use
        LET p_npq.npq30 = p_ooz.ooz02p   #No Use
        LET p_npq.npq02 = 0
        CALL p861_azp()
END FUNCTION
 
#----新增 A/R 分錄底稿單身檔(npq_file)-------------
FUNCTION p861_ar_npq(p_npqtype)             #No.FUN-6A0026  
   DEFINE p_npqtype LIKE npq_file.npqtype   #No.FUN-6A0026
   DEFINE l_aag   RECORD LIKE aag_file.*
   DEFINE l_sql   LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(300)
   DEFINE l_occ02 LIKE occ_file.occ02
   DEFINE l_occ37 LIKE occ_file.occ37   #No.MOD-660042 add
#MOD-B30012 add --start--
   DEFINE l_omb33    LIKE omb_file.omb33
   DEFINE l_omb331   LIKE omb_file.omb331
   DEFINE l_omb14    LIKE omb_file.omb14
   DEFINE l_omb16    LIKE omb_file.omb16
   #DEFINE l_cnt2     LIKE type_file.num5 #MOD-C60074 mark
   #DEFINE l_cnt3     LIKE type_file.num5 #MOD-C60074 mark
   #DEFINE l_sumoma54 LIKE oma_file.oma54 #MOD-C60074 mark
   #DEFINE l_sumoma56 LIKE oma_file.oma56 #MOD-C60074 mark
#MOD-B30012 add --end--

     CALL p861_def_npq()   #給分錄底稿單身檔預設值(每一單身共同之部份欄位)
     #讀取客戶簡稱
     LET l_occ02=''
     LET l_occ37=NULL     #No.MOD-660042 add
     SELECT occ02,occ37 INTO l_occ02,l_occ37   #No.MOD-660042 modify
       FROM occ_file
      WHERE occ01=p_oma.oma03
     IF sqlca.sqlcode <>0 THEN
        LET l_occ02 = p_oma.oma03
     END IF
     #讀取會計科目
     LET p_npq.npqtype = p_npqtype    #No.FUN-6A0026  
     IF p_npqtype = '0' THEN          #No.FUN-6A0026   
     LET l_sql = "SELECT * ",
                 #" FROM ",p_dbs CLIPPED,"aag_file ",
                 " FROM ",cl_get_target_table(p_plant,'aag_file'), #FUN-A50102
                 " WHERE aag01 = ? AND aag00 = ? "  #No.FUN-730033
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
     PREPARE aag_p3 FROM l_sql 
     IF SQLCA.SQLCODE THEN CALL cl_err('aag_p3',SQLCA.SQLCODE,1) END IF
     DECLARE aag_c3 CURSOR FOR aag_p3
     #------------ (Dr:應收 Cr:銷貨收入,稅) ------------
     #------ (Dr:應收) --------
     LET p_npq.npq02 = p_npq.npq02+1  #項次
     LET p_npq.npq03 = p_oma.oma18    #科目
     LET p_npq.npq04 = null           #CHI-760003 
     #讀會計科目
     OPEN aag_c3 USING p_npq.npq03,g_bookno1  #No.FUN-730033
     FETCH aag_c3 INTO l_aag.* 
     IF SQLCA.SQLCODE THEN 
        LET g_msg = p_dbs CLIPPED,cl_getmsg('apm-430',g_lang)
        LET g_msg = g_msg CLIPPED,p_npq.npq03
        CALL cl_err(g_msg CLIPPED,'aap-262',1) 
        LET g_success='N' CLOSE aag_c3 RETURN
     END IF
     CLOSE aag_c3
     #摘要 : 客戶+出貨廠別+原幣單價+立帳日期
     IF l_aag.aag05='Y' THEN
        LET p_npq.npq05 = p_oma.oma15    #NO:4742
     ELSE
        LET p_npq.npq05 = ''           
     END IF
     LET p_npq.npq06 = '1'
     LET p_npq.npq07f=p_oma.oma54t    #原幣金額
     LET p_npq.npq07 =p_oma.oma56t    #本幣金額
     CALL s_def_npq_m(p_npq.npq03,'axrt300',p_npq.*,p_npq.npq01,'','',g_bookno1,p_plant)  #CHI-820013 modify  #NO.FUN-980059
     RETURNING p_npq.*  
     CALL s_def_npq31_npq34_m(p_npq.*,g_bookno1,p_plant)       #FUN-AA0087
     RETURNING p_npq.npq31,p_npq.npq32,p_npq.npq33,p_npq.npq34 #FUN-AA0087
   ## 判斷應收客戶是否為關係人
   #CALL p861_occ37(p_npq.npq03,g_bookno1,p_oma.oma03,p_npq.npq37,p_dbs)
  CALL p861_occ37(p_npq.npq03,g_bookno1,p_oma.oma03,p_npq.npq37,p_dbs,p_plant)  #FUN-A50102 
   RETURNING p_npq.npq37
     #新增一筆分錄底稿單身檔
     CALL p861_ins_npq()                       #CHI-8C0034 mod
     LET p_npq.npq37 = NULL            #No.MOD-660042 add
     #----- (Cr:銷貨收入) ----
     #MOD-B30012 add --start--
     #LET l_sql = "SELECT omb33,SUM(omb14),SUM(omb16),COUNT(*) ",  #MOD-C60074 mark
     LET l_sql = "SELECT omb33,SUM(omb14),SUM(omb16) ",            #MOD-C60074 add
                 "  FROM ",cl_get_target_table( p_plant, 'omb_file' ),
                 " WHERE omb01='",p_oma.oma01,"'",
                 " GROUP BY omb33"
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
     PREPARE omb_p1 FROM l_sql
     DECLARE omb_c1 CURSOR FOR omb_p1 
     #MOD-C60074 mark start -----
     #LET l_cnt2 = 0 
     #LET l_cnt3 = 1 
     #LET l_sumoma54 = 0
     #LET l_sumoma56 = 0
     #FOREACH omb_c1 INTO l_omb33,l_omb14,l_omb16,l_cnt2
     #MOD-C60074 mark end   -----
     FOREACH omb_c1 INTO l_omb33,l_omb14,l_omb16 #MOD-C60074 add
        IF STATUS THEN EXIT FOREACH END IF
     #MOD-B30012 add --end--
        LET p_npq.npq02 = p_npq.npq02+1  #項次
       #LET p_npq.npq03 = p_ool.ool41    #科目 #MOD-B30012 mark
        LET p_npq.npq03 = l_omb33        #科目 #MOD-B30012
        LET p_npq.npq04 = null           #CHI-760003 
        #讀會計科目
        OPEN aag_c3 USING p_npq.npq03,g_bookno1  #No.FUN-730033
        FETCH aag_c3 INTO l_aag.* 
        IF SQLCA.SQLCODE THEN 
          CALL cl_err(p_dbs clipped,'aap-262',1)
           LET g_msg = g_msg CLIPPED,p_npq.npq03
           CALL cl_err(g_msg CLIPPED,'aap-262',1)
           LET g_success='N' CLOSE aag_c3 RETURN
        END IF
        CLOSE aag_c3
        #摘要:出貨廠別+原幣金額+立帳日期
        IF l_aag.aag05='Y' THEN
           LET p_npq.npq05 = p_oma.oma15    #NO:4742
        ELSE
           LET p_npq.npq05 = ''           
        END IF
        LET p_npq.npq06 = '2'
        #MOD-B30012 mod --start--
       #LET p_npq.npq07f =p_oma.oma54  #原幣金額
       #LET p_npq.npq07  =p_oma.oma56  #本幣金額
        LET l_omb14 = l_omb14 * (p_oma.oma162/100)
        LET l_omb14 = cl_digcut(l_omb14,p_azi.azi04)
        #LET l_sumoma54 = l_sumoma54 + l_omb14 #MOD-C60074 mark
        LET l_omb16 = l_omb16 * (p_oma.oma162/100)
        LET l_omb16 = cl_digcut(l_omb16,s_azi.azi04)
        #MOD-C60074 mark start -----
        #LET l_sumoma56 = l_sumoma56 + l_omb16
        #IF l_cnt2 = l_cnt3 THEN
        #   LET l_omb14 = l_omb14 + (l_sumoma54 - p_oma.oma54)
        #   LET l_omb16 = l_omb16 + (l_sumoma56 - p_oma.oma56)
        #END IF
        #MOD-C60074 mark start -----
        LET p_npq.npq07f =l_omb14  #原幣金額
        LET p_npq.npq07  =l_omb16  #本幣金額
        #LET l_cnt3 = l_cnt3 + 1 #MOD-C60074 mark
        #MOD-B30012 mod --end--
        CALL s_def_npq_m(p_npq.npq03,'axrt300',p_npq.*,p_npq.npq01,'','',g_bookno1,p_plant)  #CHI-820013 modify  #No.FUN-980059
        RETURNING p_npq.*  
        CALL s_def_npq31_npq34_m(p_npq.*,g_bookno1,p_plant)       #FUN-AA0087
        RETURNING p_npq.npq31,p_npq.npq32,p_npq.npq33,p_npq.npq34 #FUN-AA0087
        ## 判斷應收客戶是否為關係人
       #CALL p861_occ37(p_npq.npq03,g_bookno1,p_oma.oma03,p_npq.npq37,p_dbs) 
        CALL p861_occ37(p_npq.npq03,g_bookno1,p_oma.oma03,p_npq.npq37,p_dbs,p_plant)  #FUN-A50102
        RETURNING p_npq.npq37
        #新增一筆分錄底稿單身檔
        CALL p861_ins_npq()                      #CHI-8C0034 mod  
     END FOREACH #MOD-B30012 add
     #----- (Cr:稅) -------------------
     IF p_oma.oma54x > 0 THEN
         LET p_npq.npq02 = p_npq.npq02+1  #項次
         LET p_npq.npq03 = p_ool.ool28    #科目 銷項稅額
         LET p_npq.npq04 = null           #CHI-760003  
         #讀會計科目
         OPEN aag_c3 USING p_npq.npq03,g_bookno1  #No.FUN-730033
         FETCH aag_c3 INTO l_aag.* 
         CLOSE aag_c3
         IF l_aag.aag05='Y' THEN
            LET p_npq.npq05 = p_oma.oma15    #NO:4742
         ELSE
            LET p_npq.npq05 = ''           
         END IF
         LET p_npq.npq06 = '2'
         LET p_npq.npq07f =p_oma.oma54x  #原幣金額
         LET p_npq.npq07  =p_oma.oma56x  #本幣金額
         CALL s_def_npq_m(p_npq.npq03,'axrt300',p_npq.*,p_npq.npq01,'','',g_bookno1,p_plant)  #CHI-820013 modify  #No.FUN-980059
         RETURNING p_npq.*  
         CALL s_def_npq31_npq34_m(p_npq.*,g_bookno1,p_plant)       #FUN-AA0087
         RETURNING p_npq.npq31,p_npq.npq32,p_npq.npq33,p_npq.npq34 #FUN-AA0087
         ## 判斷應收客戶是否為關係人
         #CALL p861_occ37(p_npq.npq03,g_bookno1,p_oma.oma03,p_npq.npq37,p_dbs)
         CALL p861_occ37(p_npq.npq03,g_bookno1,p_oma.oma03,p_npq.npq37,p_dbs,p_plant)  #FUN-A50102
         RETURNING p_npq.npq37
         CALL p861_ins_npq()                      #CHI-8C0034 mod
     END IF
  END IF              #No.FUN-6A0026
     IF p_npqtype = '1' THEN   
     LET l_sql = "SELECT * ",
                 #" FROM ",p_dbs CLIPPED,"aag_file ",
                 " FROM ",cl_get_target_table(p_plant,'aag_file'), #FUN-A50102
                 " WHERE aag01 = ? AND aag00 = ? "  #No.FUN-730033
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
     PREPARE aag_p31 FROM l_sql 
     IF SQLCA.SQLCODE THEN CALL cl_err('aag_p3',SQLCA.SQLCODE,1) END IF
     DECLARE aag_c31 CURSOR FOR aag_p31
     #------------ (Dr:應收 Cr:銷貨收入,稅) ------------
     #------ (Dr:應收) --------
     LET p_npq.npq02 = p_npq.npq02+1  #項次
     LET p_npq.npq03 = p_oma.oma181    #科目
     #讀會計科目
     OPEN aag_c31 USING p_npq.npq03,g_bookno2  #No.FUN-730033
     FETCH aag_c31 INTO l_aag.* 
     IF SQLCA.SQLCODE THEN 
        LET g_msg = p_dbs CLIPPED,cl_getmsg('apm-430',g_lang)
        LET g_msg = g_msg CLIPPED,p_npq.npq03
        CALL cl_err(g_msg CLIPPED,'aap-262',1) 
        LET g_success='N' CLOSE aag_c31 RETURN
     END IF
     CLOSE aag_c31
     #摘要 : 客戶+出貨廠別+原幣單價+立帳日期
     IF l_aag.aag05='Y' THEN
        LET p_npq.npq05 = p_oma.oma15    #NO:4742
     ELSE
        LET p_npq.npq05 = ''           
     END IF
     LET p_npq.npq06 = '1'
     LET p_npq.npq07f=p_oma.oma54t    #原幣金額
     LET p_npq.npq07 =p_oma.oma56t    #本幣金額
   ##---------------- 判斷應收客戶是否為關係人
     CALL s_def_npq_m(p_npq.npq03,'axrt300',p_npq.*,p_npq.npq01,'','',g_bookno2,p_plant)  #CHI-820013 modify #No.FUN-980059
     RETURNING p_npq.*  
     CALL s_def_npq31_npq34_m(p_npq.*,g_bookno2,p_plant)       #FUN-AA0087
     RETURNING p_npq.npq31,p_npq.npq32,p_npq.npq33,p_npq.npq34 #FUN-AA0087
     ## 判斷應收客戶是否為關係人
     #CALL p861_occ37(p_npq.npq03,g_bookno2,p_oma.oma03,p_npq.npq37,p_dbs)
    CALL p861_occ37(p_npq.npq03,g_bookno2,p_oma.oma03,p_npq.npq37,p_dbs,p_plant)  #FUN-A50102 
     RETURNING p_npq.npq37
     #新增一筆分錄底稿單身檔
     CALL p861_ins_npq()                       #CHI-8C0034 mod
     LET p_npq.npq37 = NULL            #No.MOD-660042 add
     #----- (Cr:銷貨收入) ----
     #MOD-B30012 add --start--
     #LET l_sql = "SELECT omb331,SUM(omb14),SUM(omb16),COUNT(*) ", #MOD-C60074 mark 
     LET l_sql = "SELECT omb331,SUM(omb14),SUM(omb16) ",           #MOD-C60074 add
                 "  FROM ",cl_get_target_table( p_plant, 'omb_file' ),
                 " WHERE omb01='",p_oma.oma01,"'",
                 " GROUP BY omb331"
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
     PREPARE omb_p2 FROM l_sql
     DECLARE omb_c2 CURSOR FOR omb_p2 
     #MOD-C60074 mark start -----
     #LET l_cnt2 = 0 
     #LET l_cnt3 = 1 
     #LET l_sumoma54 = 0
     #LET l_sumoma56 = 0
     #FOREACH omb_c2 INTO l_omb331,l_omb14,l_omb16,l_cnt2
     #MOD-C60074 mark start -----
     FOREACH omb_c2 INTO l_omb331,l_omb14,l_omb16 #MOD-C60074 add
        IF STATUS THEN EXIT FOREACH END IF
     #MOD-B30012 add --end--
        LET p_npq.npq02 = p_npq.npq02+1  #項次
       #LET p_npq.npq03 = p_ool.ool411   #科目 #MOD-B30012 mark
        LET p_npq.npq03 = l_omb331       #科目 #MOD-B30012
        LET p_npq.npq04 = null           #單頭備注       #CHI-760003 
        #讀會計科目
        OPEN aag_c3 USING p_npq.npq03,g_bookno2  #No.FUN-730033
        FETCH aag_c3 INTO l_aag.* 
        IF SQLCA.SQLCODE THEN 
          LET g_msg = p_dbs CLIPPED,cl_getmsg('apm-434',g_lang)
           LET g_msg = g_msg CLIPPED,p_npq.npq03
           CALL cl_err(g_msg CLIPPED,'aap-262',1)
           LET g_success='N' CLOSE aag_c3 RETURN
        END IF
        CLOSE aag_c3
        #摘要:出貨廠別+原幣金額+立帳日期
        IF l_aag.aag05='Y' THEN
           LET p_npq.npq05 = p_oma.oma15    #NO:4742
        ELSE
           LET p_npq.npq05 = ''           
        END IF
        LET p_npq.npq06 = '2'
        #MOD-B30012 mod --start--
       #LET p_npq.npq07f =p_oma.oma54  #原幣金額
       #LET p_npq.npq07  =p_oma.oma56  #本幣金額
        LET l_omb14 = l_omb14 * (p_oma.oma162/100)
        LET l_omb14 = cl_digcut(l_omb14,p_azi.azi04)
        #LET l_sumoma54 = l_sumoma54 + l_omb14 #MOD-C60074 mark
        LET l_omb16 = l_omb16 * (p_oma.oma162/100)
        LET l_omb16 = cl_digcut(l_omb16,s_azi.azi04)
        #MOD-C60074 mark start -----
        #LET l_sumoma56 = l_sumoma56 + l_omb16
        #IF l_cnt2 = l_cnt3 THEN
        #   LET l_omb14 = l_omb14 + (l_sumoma54 - p_oma.oma54)
        #   LET l_omb16 = l_omb16 + (l_sumoma56 - p_oma.oma56)
        #END IF
        #MOD-C60074 mark end   -----
        LET p_npq.npq07f =l_omb14  #原幣金額
        LET p_npq.npq07  =l_omb16  #本幣金額
        #LET l_cnt3 = l_cnt3 + 1 #MOD-C60074 mark
        #MOD-B30012 mod --end--
    
        CALL s_def_npq_m(p_npq.npq03,'axrt300',p_npq.*,p_npq.npq01,'','',g_bookno2,p_plant)  #CHI-820013 modify #No.FUN-980059
        RETURNING p_npq.*  
        CALL s_def_npq31_npq34_m(p_npq.*,g_bookno2,p_plant)       #FUN-AA0087
        RETURNING p_npq.npq31,p_npq.npq32,p_npq.npq33,p_npq.npq34 #FUN-AA0087
        ## 判斷應收客戶是否為關係人
        #CALL p861_occ37(p_npq.npq03,g_bookno2,p_oma.oma03,p_npq.npq37,p_dbs) 
        CALL p861_occ37(p_npq.npq03,g_bookno2,p_oma.oma03,p_npq.npq37,p_dbs,p_plant) #FUN-A50102 
        RETURNING p_npq.npq37
        #新增一筆分錄底稿單身檔
        CALL p861_ins_npq()                       #CHI-8C0034 mod 
     END FOREACH #MOD-B30012 add
     #----- (Cr:稅) -------------------
     IF p_oma.oma54x > 0 THEN
         LET p_npq.npq02 = p_npq.npq02+1  #項次
         LET p_npq.npq03 = p_ool.ool281    #科目 銷項稅額
         #讀會計科目
         OPEN aag_c3 USING p_npq.npq03,g_bookno2  #No.FUN-730033
         FETCH aag_c3 INTO l_aag.* 
         CLOSE aag_c3
         IF l_aag.aag05='Y' THEN
            LET p_npq.npq05 = p_oma.oma15    #NO:4742
         ELSE
            LET p_npq.npq05 = ''           
         END IF
         LET p_npq.npq06 = '2'
         LET p_npq.npq07f =p_oma.oma54x  #原幣金額
         LET p_npq.npq07  =p_oma.oma56x  #本幣金額
         CALL s_def_npq_m(p_npq.npq03,'axrt300',p_npq.*,p_npq.npq01,'','',g_bookno2,p_plant)  #CHI-820013 modify  #No.FUN-980059
         RETURNING p_npq.*  
         CALL s_def_npq31_npq34_m(p_npq.*,g_bookno2,p_plant)       #FUN-AA0087
         RETURNING p_npq.npq31,p_npq.npq32,p_npq.npq33,p_npq.npq34 #FUN-AA0087
         ## 判斷應收客戶是否為關係人
         #CALL p861_occ37(p_npq.npq03,g_bookno2,p_oma.oma03,p_npq.npq37,p_dbs) 
         CALL p861_occ37(p_npq.npq03,g_bookno2,p_oma.oma03,p_npq.npq37,p_dbs,p_plant) #FUN-A50102 
         RETURNING p_npq.npq37
         CALL p861_ins_npq()                       #CHI-8C0034 mod
     END IF
   END IF
END FUNCTION
 
#新增分錄底稿單身檔
FUNCTION p861_ins_npq()                     #CHI-8C0034 mod
    DEFINE l_legal LIKE azw_file.azw02 #FUN-980006 add
 
    IF p_npq.npq07 = 0 THEN RETURN END IF   #CHI-B40063 add
    #新增分錄底稿單頭檔
    #LET l_sql1="INSERT INTO ",p_dbs CLIPPED,"npq_file", 
    LET l_sql1="INSERT INTO ",cl_get_target_table(p_plant,'npq_file'), #FUN-A50102  
               "(npqsys,npq00,npq01,npq011, ",
               " npq02,npq03,npq04,npq05,",
               " npq06,npq07f,npq07,npq08, ",
               " npq11,npq12,npq13,npq14,",
               " npq15,npq21,npq22,npq23,",
               " npq24,npq25,npq26,npq27,",
               " npq28,npq29,npq30,npq31,",		#MOD-9A0097 add npq31
               " npq32,npq33,npq34,npq35,",		#MOD-9A0097 add npq32,npq33,npq34,npq35
               " npq36,npq37,npqtype,npqlegal) ",       #NO.TQC-680089 ADD   #No.FUN-6A0026	#FUN-980006 add npqlegal	#MOD-9A0097 add npq36
               " VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
               "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
               "         ?,?,?,? ) "   #NO.TQC-680089 ADD ?   #No.FUN-6A0026	#FUN-980006 add ?	#MOD-9A0097 add 6?
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,p_plant) RETURNING l_sql1 #FUN-A50102
         CALL s_getlegal(p_plant) RETURNING l_legal #FUN-980006 add
           PREPARE ins_npq FROM l_sql1
           EXECUTE ins_npq USING 
                p_npq.npqsys,p_npq.npq00,p_npq.npq01,p_npq.npq011, 
                p_npq.npq02,p_npq.npq03,p_npq.npq04,p_npq.npq05,
                p_npq.npq06,p_npq.npq07f,p_npq.npq07,p_npq.npq08, 
                p_npq.npq11,p_npq.npq12,p_npq.npq13,p_npq.npq14,
                p_npq.npq15,p_npq.npq21,p_npq.npq22,p_npq.npq23,
                p_npq.npq24,p_npq.npq25,p_npq.npq26,p_npq.npq27,
                p_npq.npq28,p_npq.npq29,p_npq.npq30,p_npq.npq31,	#MOD-9A0097
                p_npq.npq32,p_npq.npq33,p_npq.npq34,p_npq.npq35,	#MOD-9A0097
                p_npq.npq36,p_npq.npq37,p_npq.npqtype,l_legal           #NO.TQC-680089	#No.FUN-6A0026	#FUN-980006 add l_legal	#MOD-9A0097 
        IF SQLCA.sqlcode<>0 THEN
              CALL cl_err('ins npq:',SQLCA.sqlcode,1)
              LET g_success = 'N'
        END IF
        CALL s_flows('3','',p_npq.npq01,p_npp.npp02,'N',p_npq.npqtype,TRUE)   #No.TQC-B70021  
END FUNCTION
 
#轉應付系統-------------------------
FUNCTION p861_ap_apa()
  DEFINE p_apt   RECORD LIKE apt_file.*   
  DEFINE g_t1    LIKE oay_file.oayslip #CHI-C60004 add
 
  #讀取廠商資料
  LET l_sql = "SELECT * ",
              #" FROM ",p_dbs CLIPPED,"pmc_file ", 
              " FROM ",cl_get_target_table(p_plant,'pmc_file'), #FUN-A50102
              " WHERE pmc01 = '",p_pmm.pmm09,"' " 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
  PREPARE pmc_p1 FROM l_sql 
  IF SQLCA.SQLCODE THEN CALL cl_err('pmc_p1',SQLCA.SQLCODE,1) END IF
  DECLARE pmc_c1 CURSOR FOR pmc_p1
  OPEN pmc_c1
  FETCH pmc_c1 INTO p_pmc.* 
  CLOSE pmc_c1
  #讀取稅別資料
  LET l_sql = "SELECT * ",
              #" FROM ",p_dbs CLIPPED,"gec_file ",
              " FROM ",cl_get_target_table(p_plant,'gec_file'), #FUN-A50102
              " WHERE gec01 = '",p_pmm.pmm21,"' " 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
  PREPARE gec_p3 FROM l_sql 
  IF SQLCA.SQLCODE THEN CALL cl_err('gec_p3',SQLCA.SQLCODE,1) END IF
  DECLARE gec_c3 CURSOR FOR gec_p3
  OPEN gec_c3
  FETCH gec_c3 INTO p_gec.* 
  CLOSE gec_c3
  #讀取 
 
        LET p_apa.apa00= '11'           #帳款性質(11請款發票)
        LET p_apa.apa01= p_apa.apa01    #帳款編號 
        LET p_apa.apa02= p_oma.oma02    #帳款日期 
        #MOD-B20058 add --start--
        IF p_apa.apa02<=p_apz.apz57 THEN 
           LET g_msg = p_dbs CLIPPED,p_apa.apa01
           CALL cl_err(g_msg CLIPPED,'aap-176',1) 
           LET g_success ='N'
           RETURN
        END IF
        #MOD-B20058 add --end--
        LET p_apa.apa05= p_pmm.pmm09    #送貨廠商編號
        LET p_apa.apa06= p_pmm.pmm09    #付款廠商編號
        LET p_apa.apa07= p_pmc.pmc03    #付款廠簡稱
       #-CHI-9A0008-add-
        IF p_poz011 = '1' THEN
           #LET l_sql = " SELECT rvb22 FROM ",p_dbs," rvb_file ",
           LET l_sql = " SELECT rvb22 FROM ",cl_get_target_table(p_plant,'rvb_file'), #FUN-A50102
                       "  WHERE rvb01 = '",p_rvv.rvv04,"'",
                       "    AND rvb02 = '",p_rvv.rvv05,"'"
           CALL cl_replace_sqldb(l_sql) RETURNING l_sql	
           CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
           PREPARE rvb22_p FROM l_sql
           DECLARE rvb22_c CURSOR FOR rvb22_p
           OPEN rvb22_c 
           FETCH rvb22_c INTO p_apa.apa08
           CLOSE rvb22_c
           #-----MOD-AC0337---------
           LET p_apa.apa09 = NULL #MOD-BB0134 add
           LET l_sql = " SELECT rvw02 FROM ",cl_get_target_table(p_plant,'rvw_file'),
                       "  WHERE rvw01 = '",p_apa.apa08,"'"
           CALL cl_replace_sqldb(l_sql) RETURNING l_sql	
           CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql 
           PREPARE rvw02_p FROM l_sql
           DECLARE rvw02_c CURSOR FOR rvw02_p
           OPEN rvw02_c 
           FETCH rvw02_c INTO p_apa.apa09
           CLOSE rvw02_c
           #-----END MOD-AC0337-----
        ELSE
           #LET l_sql = " SELECT oga27 FROM ",p_dbs_tra," oga_file ",   #FUN-980020
           #-----CHI-AC0043---------
           #LET l_sql = " SELECT oga27 FROM ",cl_get_target_table(p_plant,'oga_file'), #FUN-A50102
           #            "  WHERE oga01 = '",p_oga01,"'"
           LET l_sql = " SELECT oga27 FROM ",cl_get_target_table(s_plant,'oga_file'), 
                       "  WHERE oga99 = '",p_flow99,"'"
           #-----END CHI-AC0043-----
	   CALL cl_replace_sqldb(l_sql) RETURNING l_sql	         #FUN-920032
           CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980020 自動加上plant的關聯條件 
           PREPARE oga27_pre1 FROM l_sql
           DECLARE oga27_p1 CURSOR FOR oga27_pre1
           OPEN oga27_p1 
           FETCH oga27_p1 INTO p_apa.apa08
           CLOSE oga27_p1
           #MOD-B80007 add --start--
           IF cl_null(p_apa.apa08) THEN
              LET l_sql = " SELECT rvb22 FROM ",cl_get_target_table(p_plant,'rvb_file'), 
                          "  WHERE rvb01 = '",p_rvv.rvv04,"'",
                          "    AND rvb02 = '",p_rvv.rvv05,"'"
              CALL cl_replace_sqldb(l_sql) RETURNING l_sql	
              CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql 
              PREPARE rvb22_p2 FROM l_sql
              DECLARE rvb22_c2 CURSOR FOR rvb22_p2
              OPEN rvb22_c2 
              FETCH rvb22_c2 INTO p_apa.apa08
              CLOSE rvb22_c2
           END IF
           #MOD-B80007 add --end--
        END IF
       #-CHI-9A0008-end-
        IF cl_null(p_apa.apa09) THEN   #MOD-AC0337
           LET p_apa.apa09= p_apa.apa02    #發票日期
        END IF   #MOD-AC0337
        LET p_apa.apa11= p_pmm.pmm20    #付款方式
        #CALL s_paydate('a','',p_apa.apa09,p_apa.apa02,p_apa.apa11,     #MOD-A50182 mark   
        #                 p_apa.apa06)   #MOD-A50182 mark
        CALL s_paydate_m(p_plant,'a','',p_apa.apa09,p_apa.apa02,p_apa.apa11,     #MOD-A50182    
                         p_apa.apa06)   #MOD-A50182 
              RETURNING p_apa.apa12,p_apa.apa64,p_apa.apa24 
        LET p_apa.apa13= p_pmm.pmm22    #幣別     
        CALL s_currm(p_pmm.pmm22,p_oma.oma02,p_apz.apz33,p_plant) RETURNING p_apa.apa14  #FUN-980020
       #LET p_apa.apa14= p_pmm.pmm42    #匯率 #MOD-BB0279 mark
        LET p_apa.apa15= p_pmm.pmm21    #稅別
        LET p_apa.apa16= p_pmm.pmm43    #稅率
       #LET p_apa.apa17= '3'            #扣抵區分 3:不可扣抵進貨及費用 #CHI-B50022 mark
        LET p_apa.apa171= p_gec.gec08   #格式 22:載有稅額的其它憑證 no.7428
        LET p_apa.apa172= p_gec.gec06   #課稅別
        #CHI-B50022 add --start--
        IF p_apa.apa172 = '1' THEN
           LET p_apa.apa17= '1'
        ELSE
           LET p_apa.apa17= '3'
        END IF
        #CHI-B50022 add --end--
        LET p_apa.apa173 = null         #申報年度 no.7428
        LET p_apa.apa174 = null         #申報月份 no.7428
        LET p_apa.apa175= null          #申報流水編號
        LET p_apa.apa18 = p_pmc.pmc24   #廠商統一編號
        LET p_apa.apa19 = null          #留置原因
        LET p_apa.apa20 =0              #本幣留置金額
        LET p_apa.apa21 = p_pmm.pmm12   #請款人員
        LET p_apa.apa22 = p_poy19       #請款部門 No.8166
        #部門原則:   
        LET p_apa.apa23=null            #No Use
        LET p_apa.apa25 = null          #備註
        LET p_apa.apa31f= p_apa31f      #原幣未稅
        LET p_apa.apa31f= p_apa31f      #原幣未稅
        LET p_apa.apa32f= p_apa31f*p_apa.apa16/100    #原幣稅額 #MOD-C70105 #TQC-C90045 remark
        #LET p_apa.apa32f= p_apa32f  #MOD-C70105 #TQC-C90045 mark
        LET p_apa.apa34f= p_apa.apa31f+p_apa.apa32f  #原幣合計
        LET p_apa.apa31 = p_apa31   #本幣未稅
        LET p_apa.apa32 = p_apa31*p_apa.apa16/100  #本幣稅額 #MOD-C70105
        #LET p_apa.apa32 = p_apa32   #MOD-C70105 #TQC-C90045 mark
        LET p_apa.apa34 = p_apa.apa31+p_apa.apa32  #本幣合計
        CALL cl_digcut(p_apa.apa31f,l_azi.azi04) RETURNING p_apa.apa31f
        CALL cl_digcut(p_apa.apa32f,l_azi.azi04) RETURNING p_apa.apa32f
        CALL cl_digcut(p_apa.apa34f,l_azi.azi04) RETURNING p_apa.apa34f
        CALL cl_digcut(p_apa.apa31 ,s_azi.azi04) RETURNING p_apa.apa31 
        CALL cl_digcut(p_apa.apa32 ,s_azi.azi04) RETURNING p_apa.apa32 
        CALL cl_digcut(p_apa.apa34 ,s_azi.azi04) RETURNING p_apa.apa34 
        LET p_apa.apa73 = p_apa.apa34              #bug no:A059
        LET p_apa.apa33f= 0       #原幣差異
        LET p_apa.apa35f= 0       #原幣已付
        LET p_apa.apa33 = 0       #本幣差異
        LET p_apa.apa35 = 0       #本幣已付
        LET p_apa.apa36 = p_poy17 #帳款類別
        LET p_apa.apa41 = 'Y'     #確認碼
        LET p_apa.apa42 = 'N'     #結案碼
        LET p_apa.apa43 = null    #拋轉傳票日期
        LET p_apa.apa44 = null    #拋轉傳票編號
        LET p_apa.apa45 = null    #No Use 
        LET p_apa.apa46 = null    #No Use 
        IF p_apz.apz13='N'  THEN   #系統參數設定是否設部門會計科目
           #讀取會計科目
           LET l_sql = "SELECT * ",
                       #" FROM ",p_dbs CLIPPED,"apt_file ",
                       " FROM ",cl_get_target_table(p_plant,'apt_file'), #FUN-A50102
                       " WHERE apt01 = '",p_apa.apa36,"' " ,
                       " AND (apt02=' ' OR apt02 IS NULL) "
        ELSE
           #依帳款類別+部門
           LET l_sql = "SELECT * ",
                       #" FROM ",p_dbs CLIPPED,"apt_file ",
                       " FROM ",cl_get_target_table(p_plant,'apt_file'), #FUN-A50102
                       " WHERE apt01 = '",p_apa.apa36,"' " ,
                       " AND apt02='",p_apa.apa22,"' "
        END IF
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
        PREPARE apt_p1 FROM l_sql 
        IF SQLCA.SQLCODE THEN CALL cl_err('apt_p1',SQLCA.SQLCODE,1) END IF
        DECLARE apt_c1 CURSOR FOR apt_p1
        OPEN apt_c1
        FETCH apt_c1 INTO p_apt.* 
        CLOSE apt_c1
         LET p_apa.apa51 = p_apt.apt03 #未稅科目:
         LET p_apa.apa511 = p_apt.apt031 #FUN-6A0026
         LET p_apa.apa52 = p_gec.gec03  #稅額科目
         LET p_apa.apa521 = p_gec.gec031  #FUN-6A0026
         LET p_apa.apa53 = null   #差異科目
         LET p_apa.apa531 = null   #FUN-6A0026
         LET p_apa.apa54 = p_apt.apt04 #合計金額科目
         LET p_apa.apa541 = p_apt.apt041 #FUN-6A0026
         LET p_apa.apa55 = '1'     #轉應付帳款
         LET p_apa.apa56 = '0'     #差異處理 0:正常
         LET p_apa.apa57f = p_apa.apa34f   #原幣單身合計金額
         LET p_apa.apa57  = p_apa.apa31    #本幣單身合計金額  #MOD-870216
         LET p_apa.apa58  ='2'     #折讓性質 No.7769(退貨折讓)
         LET p_apa.apa59 = null    #自動產價格折讓單否
         LET p_apa.apa60f=0        #原幣折讓扣款金額(價差)
         LET p_apa.apa61f=0        #原幣折讓扣款稅額
         LET p_apa.apa60 =0        #本幣折讓扣款金額(價差)
         LET p_apa.apa61 =0        #本幣折讓扣款稅額
         LET p_apa.apa62 =null     #待抵預付帳款編號
         LET p_apa.apa63 = '1'     #簽核狀態      #MOD-940211 
         LET p_apa.apa65f = 0      #原幣直接沖帳金額
         LET p_apa.apa65  = 0      #本幣直接沖帳金額
         IF p_dbs = s_dbs THEN
             LET p_apa.apa66 = p_pmn.pmn122     #專案編號 #NO.FUN-660068
         ELSE
             LET p_apa.apa66 = NULL
         END IF
         LET p_apa.apa67 = null    #異動碼一
         LET p_apa.apa68 = null    #異動碼二
         LET p_apa.apa69 = null    #異動碼三
         LET p_apa.apa70 = null    #異動碼四
         LET p_apa.apa71 = null    #預算編號
         LET p_apa.apa72 = p_apa.apa14    #No.A059
         LET p_apa.apa74 = 'N'      #No Use (No.7942)
         LET p_apa.apa75 = 'N'      #No Use (No.6509)
         LET p_apa.apa99 = p_flow99 #No.8166
         LET p_apa.apainpd=g_today  #輸入日期
         LET p_apa.apamksg='N'      #是否簽核
         LET p_apa.apasign=null     #簽核等級
         LET p_apa.apadays=0        #簽核完成天數
         LET p_apa.apaprit=0        #簽核優先等級
         LET p_apa.apasmax=0        #應簽等級
         LET p_apa.apasseq=0        #已簽等級
         LET p_apa.apaprno=0        #列印次數
         LET p_apa.apaacti='Y'      #資料有效碼
         LET p_apa.apauser=g_user   #資料所有者
         LET p_apa.apagrup=g_grup   #資料所有群
         LET p_apa.apamodu=null     #資料更改者
         LET p_apa.apadate=null     #最近修改日
         LET p_apa.apa100=p_pmm.pmmplant   #FUN-960141 090824 add
         LET p_apa.apaoriu=g_user    #TQC-A10060  add
         LET p_apa.apaorig=g_grup    #TQC-A10060  add 
         LET p_apa.apa79 =0         #No.FUN-A60024   
        #CHI-C60004---add---START
         CALL s_get_doc_no(p_apa.apa01) RETURNING g_t1
         SELECT apyvcode INTO p_apa.apa77 FROM apy_file WHERE apyslip = g_t1
         IF cl_null(p_apa.apa77) THEN
            LET p_apa.apa77 = g_apz.apz63
         END IF
        #CHI-C60004---add-----END
    #新增應付款單頭檔
    #LET l_sql1="INSERT INTO ",p_dbs CLIPPED,"apa_file",
   LET l_sql1="INSERT INTO ",cl_get_target_table(p_plant,'apa_file'), #FUN-A50102
               "(apa00,apa01,apa02,apa05,",
               " apa06,apa07,apa08,apa09,",
               " apa11,apa12,apa13,apa14,",
               " apa15,apa16,apa17,apa171,",
               " apa172,apa173,apa174,apa175,",
               " apa18,apa19,apa20,",
               " apa21,apa22,apa23,apa24,",
               " apa25,apa31f,apa32f,apa33f,",
               " apa34f,apa35f,apa31,apa32,",
               " apa33,apa34,apa35,apa36,",
               " apa41,apa42,apa43,apa44,",
               " apa45,apa46,apa51,apa511,apa52,apa521,",  #FUN-6A0026
               " apa53,apa531,apa54,apa541,apa55,apa56,",  #FUN-6A0026
               " apa57f,apa57,apa58,apa59,",
               " apa60f,apa61f,apa60,",
               " apa61,apa62,apa63,",
               " apa64,apa65f,apa65,apa66,",
               " apa67,apa68,apa69,apa70,",
               " apa71,apa72,apa73,apa74,",
               " apa75,apa77,apa99,apainpd,apamksg,apasign,", #CHI-C60004 add apa77
               " apadays,apaprit,apasmax,apasseq,",
               " apaprno,apaacti,apauser,apagrup,apaoriu,apaorig,", #TQC-A10060  add apaoriu,apaorig
               " apamodu,apadate,apa100,apalegal) ",   #FUN-960141 add apaplant   #FUN-960141 090824  apaplant-->apa100 #FUN-980006 add apalegal
               " VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                        "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                        "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,",   #No.FUN-6A0026
                        "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,",   #No.FUN-6A0026
                        "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,?,?,",    ##TQC-A10060  add ?,?
                        "?,?,?,?, ?,?,?,?, ?,?,?) " #FUN-960141 add 1 ?  #FUN-980006 add ? #CHI-C60004 add ?
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,p_plant) RETURNING l_sql1 #FUN-A50102
         CALL s_getlegal(p_plant) RETURNING p_apa.apalegal #FUN-980006 add
           PREPARE inp861_apa FROM l_sql1
           EXECUTE inp861_apa USING 
                p_apa.apa00,p_apa.apa01,p_apa.apa02,p_apa.apa05,
                p_apa.apa06,p_apa.apa07,p_apa.apa08,p_apa.apa09,
                p_apa.apa11,p_apa.apa12,p_apa.apa13,p_apa.apa14,
                p_apa.apa15,p_apa.apa16,p_apa.apa17,p_apa.apa171,
                p_apa.apa172,p_apa.apa173,p_apa.apa174,p_apa.apa175,
                p_apa.apa18,p_apa.apa19,p_apa.apa20,
                p_apa.apa21,p_apa.apa22,p_apa.apa23,p_apa.apa24,
                p_apa.apa25,p_apa.apa31f,p_apa.apa32f,p_apa.apa33f,
                p_apa.apa34f,p_apa.apa35f,p_apa.apa31,p_apa.apa32,
                p_apa.apa33,p_apa.apa34,p_apa.apa35,p_apa.apa36,
                p_apa.apa41,p_apa.apa42,p_apa.apa43,p_apa.apa44,
                p_apa.apa45,p_apa.apa46,p_apa.apa51,p_apa.apa511,p_apa.apa52,p_apa.apa521,   #FUN-6A0026
                p_apa.apa53,p_apa.apa531,p_apa.apa54,p_apa.apa541,p_apa.apa55,p_apa.apa56,   #FUN-6A0026 
                p_apa.apa57f,p_apa.apa57,p_apa.apa58,p_apa.apa59,
                p_apa.apa60f,p_apa.apa61f,p_apa.apa60,
                p_apa.apa61,p_apa.apa62,p_apa.apa63,
                p_apa.apa64,p_apa.apa65f,p_apa.apa65,p_apa.apa66,
                p_apa.apa67,p_apa.apa68,p_apa.apa69,p_apa.apa70,
                p_apa.apa71,p_apa.apa72,p_apa.apa73,p_apa.apa74,
                p_apa.apa75,p_apa.apa77,p_apa.apa99,p_apa.apainpd,p_apa.apamksg, #CHI-C60004 add apa77
                p_apa.apasign,
                p_apa.apadays,p_apa.apaprit,p_apa.apasmax,p_apa.apasseq,
                p_apa.apaprno,p_apa.apaacti,p_apa.apauser,p_apa.apagrup,p_apa.apaoriu,p_apa.apaorig,  #TQC-A10060  add oriu,orig
                p_apa.apamodu,p_apa.apadate,p_apa.apa100  #FUN-960141 add apaplant   #FUN-960141 090824 apaplant-->apa100
                ,p_apa.apalegal  #FUN-980006 add l_legal
            IF SQLCA.sqlcode<>0 THEN
               LET g_msg = p_dbs CLIPPED,'ins_apa'      
               CALL cl_err(g_msg,SQLCA.sqlcode,1)
               LET g_success = 'N'
            END IF
END FUNCTION
 
#----新增 A/P 分錄底稿單頭檔(npp_file)-------------
FUNCTION p861_ap_npp(p_npptype)   #No.FUN-6A0026
     DEFINE p_npptype LIKE npp_file.npptype   #No.FUN-6A0026
     LET p_npp.npptype = p_npptype    #No.FUN-6A0026
     LET p_npp.nppsys = 'AP'         #系統別
     LET p_npp.npp00 = 1             #類別 (1應付)
     LET p_npp.npp01 = p_apa.apa01   #單號
     LET p_npp.npp011 = 1            #異動序號
     LET p_npp.npp02 = p_apa.apa02   #異動日期 
     LET p_npp.npp03 =null           #傳票日期
     LET p_npp.npp04 =null           #No Use
     LET p_npp.npp05 =null           #拋轉種類
#    LET p_npp.npp06 =null           #工廠編號 no.7425   #MOD-AC0419 
     LET p_npp.npp06 = p_ooz.ooz02p                      #MOD-AC0419
     LET p_npp.npp07 =null           #帳別     no.7425
     LET p_npp.nppglno =null         #已拋轉傳票編號
     CALL s_get_bookno1(YEAR(p_apa.apa02),p_plant) RETURNING g_flag,g_bookno1,g_bookno2   #FUN-980020
     IF g_flag =  '1' THEN  #抓不到帳別
        CALL cl_err(p_dbs || ' ' || p_apa.apa02,'aoo-081',1)
        LET g_success = 'N'
     END IF
     CALL p861_ins_npp()
END FUNCTION
 
#----預設 A/P 分錄底稿單身檔(npq_file)-------------
FUNCTION p861_apdef_npq()
     LET p_npq.npqsys = 'AP'          #系統別
     LET p_npq.npq00 = 1              #類別 (1應付)
     LET p_npq.npq01 = p_apa.apa01    #單號
     LET p_npq.npq011 = 1             #異動序號
     LET p_npq.npq05 = p_apa.apa22    #部門 
     LET p_npq.npq08 = null           #專案編號
     LET p_npq.npq11 = null           #異動碼-1  
     LET p_npq.npq12 = null           #異動碼-2  
     LET p_npq.npq13 = null           #異動碼-3  
     LET p_npq.npq14 = null           #異動碼-4  
     LET p_npq.npq15 = null           #預算編號
     LET p_npq.npq21 = p_apa.apa06    #客戶編號/廠商編號
     LET p_npq.npq22 = p_apa.apa07    #客戶簡稱/廠商簡稱
     LET p_npq.npq23 = p_apa.apa01    #立沖單號
     LET p_npq.npq24 = p_apa.apa13    #原幣幣別
     LET p_npq.npq25 = p_apa.apa14    #匯率
     LET p_npq.npq26 = null           #No Use
     LET p_npq.npq27 = null           #No Use
     LET p_npq.npq28 = null           #No Use
     LET p_npq.npq29 = null           #No Use
     LET p_npq.npq30 = p_ooz.ooz02p   #No Use
     LET p_npq.npq02 = 0
END FUNCTION
 
#----新增 A/P 分錄底稿單身檔(npq_file)-------------
FUNCTION p861_ap_npq(p_npqtype)     #No.FUN-6A0026
  DEFINE p_npqtype LIKE npq_file.npqtype    #No.FUN-6A0026
  DEFINE p_aag  RECORD LIKE aag_file.*
  DEFINE l_amt         LIKE apb_file.apb24  #No.9201
  DEFINE l_amt_f       LIKE apb_file.apb24
  DEFINE l_actno       LIKE type_file.chr20   #No.FUN-680136 VARCHAR(20)
  DEFINE l_deptno      LIKE type_file.chr20   #No.FUN-680136 VARCHAR(20)
  DEFINE l_apb12       LIKE type_file.chr20   #No.FUN-680136 VARCHAR(20)
  DEFINE l_apb08       LIKE apb_file.apb08 #FUN-4C0011
  DEFINE l_apb09       LIKE apb_file.apb09 #No.FUN-680136 DEC(15,3)
  DEFINE l_ware,l_loc  LIKE rvv_file.rvv33 #No.FUN-680136 VARCHAR(10)
  DEFINE l_pmc903      LIKE pmc_file.pmc903   #No.MOD-660042 add
  DEFINE l_pmc03       LIKE pmc_file.pmc03    #No.CHI-820013 add
 
     CALL p861_apdef_npq()   #給分錄底稿單身檔預設值(每一單身共同之部份欄位)
     #讀取會計科目
  LET p_npq.npqtype = p_npqtype    #No.FUN-6A0026
 IF p_npqtype = '0' THEN               #No.FUN-6A0026
     LET l_sql = "SELECT * ",
                 #" FROM ",p_dbs CLIPPED,"aag_file ",
                 " FROM ",cl_get_target_table(p_plant,'aag_file'), #FUN-A50102
                 " WHERE aag01 = ? AND aag00 = ? "  #No.FUN-730033
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
     PREPARE aag_p1 FROM l_sql 
     IF SQLCA.SQLCODE THEN CALL cl_err('aag_p1',SQLCA.SQLCODE,1) END IF
     DECLARE aag_c1 CURSOR FOR aag_p1
     #-------( Dr: Un-Invoice A/P )---------------------
     IF cl_null(p_apa.apa51) OR p_apa.apa51 = 'STOCK' THEN
        LET l_sql=" SELECT apb10,apb25,apb26,apb12,apb09,apb08,",
                  "        apb24,rvv32,rvv33 ",
                  #"   FROM ",p_dbs CLIPPED,"apb_file, ",       
                  #"  OUTER ",p_dbs_tra CLIPPED,"rvv_file ",    #FUN-980020
                  "   FROM ",cl_get_target_table(p_plant,'apb_file'),",", #FUN-A50102    
                  "  OUTER ",cl_get_target_table(p_plant,'rvv_file'),     #FUN-A50102
                  "    WHERE apb01 = '",p_npp.npp01,"'",
                  "      AND apb10 != 0 ", 
                  "      AND apb21 = rvv_file.rvv01  AND apb22 = rvv_file.rvv02"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980020 自動加上plant的關聯條件 
        PREPARE apb_p1 FROM l_sql
        DECLARE apb_c CURSOR FOR apb_p1
        FOREACH apb_c INTO l_amt,l_actno,l_deptno,
                           l_apb12,l_apb09,l_apb08,l_amt_f,l_ware,l_loc
           IF SQLCA.SQLCODE THEN EXIT FOREACH END IF
           IF cl_null(l_actno) AND p_apa.apa51 = 'STOCK' THEN
              LET l_actno = s_stock_act(l_apb12,l_ware,l_loc,p_plant) #No.FUN-980025 
           END IF
           LET p_npq.npq02 = p_npq.npq02 + 1
           LET p_npq.npq03 = l_actno
           LET p_npq.npq04 = NULL
           LET p_npq.npq06 = '1'
           LET p_npq.npq07 = l_amt
           LET p_npq.npq07f= l_amt_f
           #依科目判斷部門之欄位給值
           OPEN aag_c1 USING p_npq.npq03,g_bookno1  #No.FUN-730033
           FETCH aag_c1 INTO p_aag.* 
           IF SQLCA.SQLCODE THEN
              LET g_msg = p_dbs CLIPPED,p_npq.npq03   #MOD-7C0100
              LET g_msg = g_msg CLIPPED,cl_getmsg('apm-431',g_lang)
              CALL cl_err(g_msg CLIPPED,'aap-262',1)
 
              LET g_success='N' CLOSE aag_c1 RETURN
           END IF
           CLOSE aag_c1
           IF p_aag.aag23='Y' THEN 
              LET p_npq.npq08 = p_apa.apa66 
           ELSE 
              LET p_npq.npq08 = null
           END IF
           IF p_aag.aag05='Y' THEN
              LET p_npq.npq05 = l_deptno
           ELSE
              LET p_npq.npq05 = ''           
           END IF
         CALL s_def_npq_m(p_npq.npq03,'aapt110',p_npq.*,p_npq.npq01,'','',g_bookno1,p_plant)  #CHI-820013  #No.FUN-980059
         RETURNING p_npq.*  
         CALL s_def_npq31_npq34_m(p_npq.*,g_bookno1,p_plant)       #FUN-AA0087
         RETURNING p_npq.npq31,p_npq.npq32,p_npq.npq33,p_npq.npq34 #FUN-AA0087
         ## 判斷應收廠商是否為關係人
         #CALL p861_pmc903(p_npq.npq03,g_bookno1,p_apa.apa06,p_npq.npq37,p_dbs)
        CALL p861_pmc903(p_npq.npq03,g_bookno1,p_apa.apa06,p_npq.npq37,p_dbs,p_plant)  #FUN-A50102
         RETURNING p_npq.npq37
         #新增一筆分錄底稿單身檔
         CALL p861_ins_npq()                       #CHI-8C0034 mod  
      END FOREACH
     ELSE
       LET p_npq.npq02 = p_npq.npq02+1  #項次
       LET p_npq.npq03 = p_apa.apa51    #科目
       LET p_npq.npq04 = null           #摘要
       LET p_npq.npq06 = '1'
       LET p_npq.npq07f = p_apa.apa31f  #原幣金額
       LET p_npq.npq07  = p_apa.apa31   #本幣金額
       #依科目判斷部門之欄位給值
       OPEN aag_c1 USING p_npq.npq03,g_bookno1  #No.FUN-730033
       FETCH aag_c1 INTO p_aag.* 
       CLOSE aag_c1
       IF p_aag.aag05='Y' THEN
          LET p_npq.npq05 = p_apa.apa22    #NO:4742
       ELSE
          LET p_npq.npq05 = ''           
       END IF
       CALL s_def_npq_m(p_npq.npq03,'aapt110',p_npq.*,p_npq.npq01,'','',g_bookno1,p_plant)  #CHI-820013  #No.FUN-980059
       RETURNING p_npq.*  
       CALL s_def_npq31_npq34_m(p_npq.*,g_bookno1,p_plant)       #FUN-AA0087
       RETURNING p_npq.npq31,p_npq.npq32,p_npq.npq33,p_npq.npq34 #FUN-AA0087
       ## 判斷應收廠商是否為關係人
       #CALL p861_pmc903(p_npq.npq03,g_bookno1,p_apa.apa06,p_npq.npq37,p_dbs) 
       CALL p861_pmc903(p_npq.npq03,g_bookno1,p_apa.apa06,p_npq.npq37,p_dbs,p_plant)  #FUN-A50102
       RETURNING p_npq.npq37
       #新增一筆分錄底稿單身檔
       CALL p861_ins_npq()                      #CHI-8C0034 mod
     END IF
     #------( Dr: VAT tax        )---------------------
     IF p_apa.apa32 >0 then   #有稅額時
        LET p_npq.npq02 = p_npq.npq02+1  #項次
        LET p_npq.npq03 = p_apa.apa52    #科目
        LET p_npq.npq06 = '1'
        LET p_npq.npq07f = p_apa.apa32f  #原幣金額
        LET p_npq.npq07  = p_apa.apa32   #本幣金額
        IF p_apz.apz54 = '1' THEN
           LET p_npq.npq04 = p_apa.apa07 CLIPPED,' ',p_apa.apa08 CLIPPED,' ',
                       p_apa.apa09
        END IF
        #依科目判斷部門之欄位給值
        OPEN aag_c1 USING p_npq.npq03,g_bookno1  #No.FUN-730033
        FETCH aag_c1 INTO p_aag.* 
        IF SQLCA.SQLCODE THEN
            LET g_msg = p_dbs CLIPPED,p_npq.npq03   #MOD-7C0100
            LET g_msg = g_msg CLIPPED,cl_getmsg('apm-431',g_lang)
            CALL cl_err(g_msg CLIPPED,'aap-262',1)
           LET g_success='N' CLOSE aag_c1 RETURN
        END IF
        CLOSE aag_c1
        IF p_aag.aag05='Y' THEN
           LET p_npq.npq05 = p_apa.apa22    #NO:4742
        ELSE
           LET p_npq.npq05 = ''           
        END IF
     CALL s_def_npq_m(p_npq.npq03,'aapt110',p_npq.*,p_npq.npq01,'','',g_bookno1,p_plant)  #CHI-820013 #No.FUN-980059
     RETURNING p_npq.*  
       CALL s_def_npq31_npq34_m(p_npq.*,g_bookno1,p_plant)       #FUN-AA0087
       RETURNING p_npq.npq31,p_npq.npq32,p_npq.npq33,p_npq.npq34 #FUN-AA0087
       ## 判斷應收廠商是否為關係人
       #CALL p861_pmc903(p_npq.npq03,g_bookno1,p_apa.apa06,p_npq.npq37,p_dbs) 
       CALL p861_pmc903(p_npq.npq03,g_bookno1,p_apa.apa06,p_npq.npq37,p_dbs,p_plant)  #FUN-A50102
       RETURNING p_npq.npq37
        #新增一筆分錄底稿單身檔
        CALL p861_ins_npq()                       #CHI-8C0034 mod
     END IF
     #-----------------( Cr: A/P            )---------------
     LET p_npq.npq02 = p_npq.npq02+1  #項次
     LET p_npq.npq03 = p_apa.apa54    #科目
     #摘要:出貨廠別+原幣金額+立帳日期
     LET p_npq.npq04 = p_last_plant
     LET p_npq.npq06 = '2'
     LET p_npq.npq07f = p_apa.apa34f  #原幣金額
     LET p_npq.npq07  = p_apa.apa34   #本幣金額
     #依科目判斷部門之欄位給值
     OPEN aag_c1 USING p_npq.npq03,g_bookno1  #No.FUN-730033
     FETCH aag_c1 INTO p_aag.* 
     IF SQLCA.SQLCODE THEN
        LET g_msg = p_dbs CLIPPED,cl_getmsg('apm-432',g_lang)
        LET g_msg = g_msg CLIPPED,p_npq.npq03
        CALL cl_err(g_msg CLIPPED,'aap-262',1)
        LET g_success='N' CLOSE aag_c1 RETURN
     END IF
     CLOSE aag_c1
     IF p_aag.aag05='Y' THEN
        LET p_npq.npq05 = p_apa.apa22    #NO:4742
     ELSE
        LET p_npq.npq05 = ''           
     END IF
     #依參數(apz43)判斷摘要
     CASE p_apz.apz43
          WHEN '0'  LET p_npq.npq04=null
          WHEN '1'  LET p_npq.npq04= p_apa.apa06 CLIPPED,' ',p_apa.apa07
          WHEN '2'  LET p_npq.npq04= p_apa.apa06 CLIPPED,' ',p_apa.apa07,' ',
                                 p_apa.apa08
          OTHERWISE LET p_npq.npq04=null
      END CASE
     #新增一筆分錄底稿單身檔
     CALL s_def_npq_m(p_npq.npq03,'aapt110',p_npq.*,p_npq.npq01,'','',g_bookno1,p_plant)  #No.FUN-980059  
     RETURNING p_npq.*  
     CALL s_def_npq31_npq34_m(p_npq.*,g_bookno1,p_plant)       #FUN-AA0087
     RETURNING p_npq.npq31,p_npq.npq32,p_npq.npq33,p_npq.npq34 #FUN-AA0087
     ## 判斷應收廠商是否為關係人
     #CALL p861_pmc903(p_npq.npq03,g_bookno1,p_apa.apa06,p_npq.npq37,p_dbs)
    CALL p861_pmc903(p_npq.npq03,g_bookno1,p_apa.apa06,p_npq.npq37,p_dbs,p_plant)  #FUN-A50102
     RETURNING p_npq.npq37
     CALL p861_ins_npq()                       #CHI-8C0034 mod
     LET p_npq.npq37 = NULL           
  END IF         #No.FUN-6A0026
     IF p_npqtype = '1'  THEN
     LET l_sql = "SELECT * ",
                 #" FROM ",p_dbs CLIPPED,"aag_file ",
                 " FROM ",cl_get_target_table(p_plant,'aag_file'), #FUN-A50102
                 " WHERE aag01 = ? AND aag00 = ? "  #No.FUN-730033
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
     PREPARE aag_p11 FROM l_sql 
     IF SQLCA.SQLCODE THEN CALL cl_err('aag_p1',SQLCA.SQLCODE,1) END IF
     DECLARE aag_c11 CURSOR FOR aag_p11
     #-------( Dr: Un-Invoice A/P )---------------------
     # 處理 STOCK的部份
     IF cl_null(p_apa.apa511) OR p_apa.apa511 = 'STOCK' THEN
        LET l_sql=" SELECT apb10,apb251,apb26,apb12,apb09,apb08,",
                  "        apb24,rvv32,rvv33 ",
                  #"   FROM ",p_dbs CLIPPED,"apb_file, ",
                  #"  OUTER ",p_dbs_tra CLIPPED,"rvv_file ",     #FUN-980020
                  "   FROM ",cl_get_target_table(p_plant,'apb_file'),",", #FUN-A50102
                  "  OUTER ",cl_get_target_table(p_plant,'rvv_file'),     #FUN-A50102
                  "    WHERE apb01 = '",p_npp.npp01,"'",
                  "      AND apb10 != 0 ", 
                  "      AND apb21 = rvv_file.rvv01  AND apb22 = rvv_file.rvv02"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980020 自動加上plant的關聯條件 
        PREPARE apb_p11 FROM l_sql
        DECLARE apb_c1 CURSOR FOR apb_p11
        FOREACH apb_c1 INTO l_amt,l_actno,l_deptno,
                           l_apb12,l_apb09,l_apb08,l_amt_f,l_ware,l_loc
           IF SQLCA.SQLCODE THEN EXIT FOREACH END IF
           IF cl_null(l_actno) AND p_apa.apa511 = 'STOCK' THEN
              LET l_actno = s_stock_act(l_apb12,l_ware,l_loc,p_plant) #No.FUN-980025
           END IF
           LET p_npq.npq02 = p_npq.npq02 + 1
           LET p_npq.npq03 = l_actno
           LET p_npq.npq04 = NULL
           LET p_npq.npq06 = '1'
           LET p_npq.npq07 = l_amt
           LET p_npq.npq07f= l_amt_f
           #依科目判斷部門之欄位給值
           OPEN aag_c11 USING p_npq.npq03,g_bookno2   #FUN-670007    #這時p_npqtype='1',aag_c1並不會被open,怎麼可以再用aag_c1去做??  #No.FUN-730033
           FETCH aag_c11 INTO p_aag.*       #FUN-670007
           IF SQLCA.SQLCODE THEN
              LET g_msg = p_dbs CLIPPED,p_npq.npq03   #MOD-7C0100
              LET g_msg = g_msg CLIPPED,cl_getmsg('apm-431',g_lang)
              CALL cl_err(g_msg CLIPPED,'aap-262',1)
 
              LET g_success='N' CLOSE aag_c11 RETURN   #FUN-670007
           END IF
           CLOSE aag_c11            #FUN-670007
           IF p_aag.aag23='Y' THEN 
              LET p_npq.npq08 = p_apa.apa66 
           ELSE 
              LET p_npq.npq08 = null
           END IF
           IF p_aag.aag05='Y' THEN
              LET p_npq.npq05 = l_deptno
           ELSE
              LET p_npq.npq05 = ''           
           END IF
           CALL s_def_npq_m(p_npq.npq03,'aapt110',p_npq.*,p_npq.npq01,'','',g_bookno2,p_plant)  #CHI-820013 #No.FUN-980059
           RETURNING p_npq.*  
           CALL s_def_npq31_npq34_m(p_npq.*,g_bookno2,p_plant)       #FUN-AA0087
           RETURNING p_npq.npq31,p_npq.npq32,p_npq.npq33,p_npq.npq34 #FUN-AA0087
       ## 判斷應收廠商是否為關係人
       #CALL p861_pmc903(p_npq.npq03,g_bookno2,p_apa.apa06,p_npq.npq37,p_dbs)
      CALL p861_pmc903(p_npq.npq03,g_bookno2,p_apa.apa06,p_npq.npq37,p_dbs,p_plant)  #FUN-A50102 
       RETURNING p_npq.npq37
         #新增一筆分錄底稿單身檔
         CALL p861_ins_npq()                      #CHI-8C0034 mod
      END FOREACH
     ELSE
       LET p_npq.npq02 = p_npq.npq02+1  #項次
       LET p_npq.npq03 = p_apa.apa511    #科目
       LET p_npq.npq04 = null           #摘要
       LET p_npq.npq06 = '1'
       LET p_npq.npq07f = p_apa.apa31f  #原幣金額
       LET p_npq.npq07  = p_apa.apa31   #本幣金額
       #依科目判斷部門之欄位給值
       OPEN aag_c11 USING p_npq.npq03,g_bookno2  #No.FUN-730033
       FETCH aag_c11 INTO p_aag.* 
       CLOSE aag_c11
       IF p_aag.aag05='Y' THEN
          LET p_npq.npq05 = p_apa.apa22    #NO:4742
       ELSE
          LET p_npq.npq05 = ''           
       END IF
       CALL s_def_npq_m(p_npq.npq03,'aapt110',p_npq.*,p_npq.npq01,'','',g_bookno2,p_plant)  #CHI-820013 #No.FUN-980059
       RETURNING p_npq.*  
       CALL s_def_npq31_npq34_m(p_npq.*,g_bookno2,p_plant)       #FUN-AA0087
       RETURNING p_npq.npq31,p_npq.npq32,p_npq.npq33,p_npq.npq34 #FUN-AA0087
       ## 判斷應收廠商是否為關係人
       #CALL p861_pmc903(p_npq.npq03,g_bookno2,p_apa.apa06,p_npq.npq37,p_dbs) 
       CALL p861_pmc903(p_npq.npq03,g_bookno2,p_apa.apa06,p_npq.npq37,p_dbs,p_plant)  #FUN-A50102
       RETURNING p_npq.npq37
       #新增一筆分錄底稿單身檔
       CALL p861_ins_npq()                       #CHI-8C0034 mod
     END IF
     #------( Dr: VAT tax        )---------------------
     IF p_apa.apa32 >0 then   #有稅額時
        LET p_npq.npq02 = p_npq.npq02+1  #項次
        LET p_npq.npq03 = p_apa.apa521    #科目
        LET p_npq.npq06 = '1'
        LET p_npq.npq07f = p_apa.apa32f  #原幣金額
        LET p_npq.npq07  = p_apa.apa32   #本幣金額
        IF p_apz.apz54 = '1' THEN
           LET p_npq.npq04 = p_apa.apa07 CLIPPED,' ',p_apa.apa08 CLIPPED,' ',
                       p_apa.apa09
        END IF
        #依科目判斷部門之欄位給值
        OPEN aag_c11 USING p_npq.npq03,g_bookno2  #No.FUN-730033
        FETCH aag_c11 INTO p_aag.* 
        IF SQLCA.SQLCODE THEN
            LET g_msg = p_dbs CLIPPED,p_npq.npq03   #MOD-7C0100
            LET g_msg = g_msg CLIPPED,cl_getmsg('apm-431',g_lang)
            CALL cl_err(g_msg CLIPPED,'aap-262',1)
           LET g_success='N' CLOSE aag_c11 RETURN   #FUN-670007
        END IF
        CLOSE aag_c11                   #FUN-670007
        IF p_aag.aag05='Y' THEN
           LET p_npq.npq05 = p_apa.apa22    #NO:4742
        ELSE
           LET p_npq.npq05 = ''           
        END IF
       CALL s_def_npq_m(p_npq.npq03,'aapt110',p_npq.*,p_npq.npq01,'','',g_bookno2,p_plant)  #CHI-820013  #No.FUN-980059
       RETURNING p_npq.*  
       CALL s_def_npq31_npq34_m(p_npq.*,g_bookno2,p_plant)       #FUN-AA0087
       RETURNING p_npq.npq31,p_npq.npq32,p_npq.npq33,p_npq.npq34 #FUN-AA0087
       ## 判斷應收廠商是否為關係人
       #CALL p861_pmc903(p_npq.npq03,g_bookno1,p_apa.apa06,p_npq.npq37,p_dbs) 
       CALL p861_pmc903(p_npq.npq03,g_bookno1,p_apa.apa06,p_npq.npq37,p_dbs,p_plant)  #FUN-A50102
       RETURNING p_npq.npq37
        #新增一筆分錄底稿單身檔
        CALL p861_ins_npq()                        #CHI-8C0034 mod
     END IF
     #-----------------( Cr: A/P            )---------------
     LET p_npq.npq02 = p_npq.npq02+1  #項次
     LET p_npq.npq03 = p_apa.apa541    #科目
     #摘要:出貨廠別+原幣金額+立帳日期
     LET p_npq.npq06 = '2'
     LET p_npq.npq07f = p_apa.apa34f  #原幣金額
     LET p_npq.npq07  = p_apa.apa34   #本幣金額
     #依科目判斷部門之欄位給值
     OPEN aag_c11 USING p_npq.npq03,g_bookno2  #No.FUN-730033
     FETCH aag_c11 INTO p_aag.* 
     IF SQLCA.SQLCODE THEN
        LET g_msg = p_dbs CLIPPED,cl_getmsg('apm-432',g_lang)
        LET g_msg = g_msg CLIPPED,p_npq.npq03
        CALL cl_err(g_msg CLIPPED,'aap-262',1)
        LET g_success='N' CLOSE aag_c11 RETURN   #FUN-670007
     END IF
     CLOSE aag_c11          #FUN-670007
     IF p_aag.aag05='Y' THEN
        LET p_npq.npq05 = p_apa.apa22    #NO:4742
     ELSE
        LET p_npq.npq05 = ''           
     END IF
 
     #依參數(apz43)判斷摘要
     CASE p_apz.apz43
          WHEN '0'  LET p_npq.npq04=null
          WHEN '1'  LET p_npq.npq04= p_apa.apa06 CLIPPED,' ',p_apa.apa07
          WHEN '2'  LET p_npq.npq04= p_apa.apa06 CLIPPED,' ',p_apa.apa07,' ',
                                 p_apa.apa08
          OTHERWISE LET p_npq.npq04=null
      END CASE
     #新增一筆分錄底稿單身檔
  #-------- 判斷廠商是否為關係人
      LET l_pmc903 = NULL
      SELECT pmc903 INTO l_pmc903 FROM pmc_file WHERE pmc01 = p_apa.apa06
      IF l_pmc903 MATCHES '[yY]' THEN
         LET p_npq.npq37 = p_apa.apa06
      END IF 
     CALL s_def_npq_m(p_npq.npq03,'aapt110',p_npq.*,p_npq.npq01,'','',g_bookno2,p_plant)  #CHI-820013  #No.FUN-980059
     RETURNING p_npq.*  
     CALL s_def_npq31_npq34_m(p_npq.*,g_bookno2,p_plant)       #FUN-AA0087
     RETURNING p_npq.npq31,p_npq.npq32,p_npq.npq33,p_npq.npq34 #FUN-AA0087
     ## 判斷應收廠商是否為關係人
     #CALL p861_pmc903(p_npq.npq03,g_bookno2,p_apa.apa06,p_npq.npq37,p_dbs)
    CALL p861_pmc903(p_npq.npq03,g_bookno2,p_apa.apa06,p_npq.npq37,p_dbs,p_plant)  #FUN-A50102
     RETURNING p_npq.npq37
     CALL p861_ins_npq()                        #CHI-8C0034 mod
     LET p_npq.npq37 = NULL            #No.MOD-660042 add
     END IF                            #MOD-880021
END FUNCTION
 
#若應收金額-應付金額 <>發票金額, 則將差額調整至最後一筆項次
FUNCTION p861_adj()
   DEFINE l_oga53 LIKE oga_file.oga53
   DEFINE l_amt   LIKE oma_file.oma59,
          l_adj   LIKE oma_file.oma59,
          l_omb   RECORD LIKE omb_file.*,
          l_oma   RECORD LIKE oma_file.*,
          l_sql   LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(600)
   LET l_amt = p_oma.oma56 - p_apa.apa31 
   LET l_adj = l_amt - p_oma.oma59
   #調整金額=應收-應付
   IF l_adj <> 0 THEN
      LET l_sql = "SELECT * ",
                  #" FROM ",p_dbs CLIPPED,"omb_file ", 
                  " FROM ",cl_get_target_table(p_plant,'omb_file'), #FUN-A50102      
                  " WHERE omb01 ='",p_oma.oma01,"' ",
                  "  ORDER BY omb03 DESC "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
      PREPARE omb1_p1 FROM l_sql 
      IF SQLCA.SQLCODE THEN CALL cl_err('omb1_p1',SQLCA.SQLCODE,1) END IF
      DECLARE omb1_c1 CURSOR FOR omb1_p1
      OPEN omb1_c1
      FETCH omb1_c1 INTO l_omb.* 
      CLOSE omb1_c1
      
      #更新應收單身
      LET l_omb.omb18=l_omb.omb18+l_adj
      LET l_omb.omb18t=l_omb.omb18t+l_adj 
      #LET l_sql="UPDATE ",p_dbs CLIPPED,"omb_file",
      LET l_sql="UPDATE ",cl_get_target_table(p_plant,'omb_file'), #FUN-A50102     
               " SET omb18 = ? ,omb18t = ? ",
               " WHERE omb01 = ? AND omb03 = ? "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
      PREPARE upd_omb3 FROM l_sql 
      EXECUTE upd_omb3 USING 
                  l_omb.omb18,l_omb.omb18t,l_omb.omb01,l_omb.omb03
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err('upd omb3:',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
      
      #更新應收單身
      LET p_oma.oma59=p_oma.oma59+l_adj
      LET p_oma.oma59t=p_oma.oma59t+l_adj
      #LET l_sql="UPDATE ",p_dbs CLIPPED,"oma_file",  
      LET l_sql="UPDATE ",cl_get_target_table(p_plant,'oma_file'), #FUN-A50102      
               " SET oma59 = ?,oma59t = ? ",
               " WHERE oma01 = ? " 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
      PREPARE upd_oma3 FROM l_sql 
      EXECUTE upd_oma3 USING 
                  p_oma.oma59,p_oma.oma59t,p_oma.oma01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err('upd oma3:',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
      #更新出貨單頭檔
      LET l_oga53 = p_oma.oma59/p_oga.oga24    #原幣發票金額
      CALL cl_digcut(l_oga53,p_azi.azi04) RETURNING l_oga53
      IF l_oga53 IS NULL THEN LET l_oga53=0 END IF
      #LET l_sql="UPDATE ",p_dbs_tra CLIPPED,"oga_file",      #FUN-980020
      LET l_sql="UPDATE ",cl_get_target_table(p_plant,'oga_file'), #FUN-A50102 
              " SET oga53 =?",
              " WHERE oga01 = ? "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980020 自動加上plant的關聯條件 
     PREPARE upd_oga3 FROM l_sql 
     EXECUTE upd_oga3 USING l_oga53,p_oga01
     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err('upd oga3:',SQLCA.sqlcode,1)
         LET g_success = 'N'
     END IF
   END IF
END FUNCTION
 
FUNCTION p861_azp()
 
     LET p_npq.npq30=p_plant
END FUNCTION
 
#更新ogb60(已開發票數量)
FUNCTION p861_u_ogb60()
  IF cl_null(p_ogb.ogb917) THEN LET p_ogb.ogb917 = 0 END IF
 
  #LET l_sql = " UPDATE ",p_dbs_tra," ogb_file SET ogb60 = ? ", #FUN-980020
  LET l_sql = " UPDATE ",cl_get_target_table(p_plant,'ogb_file'), #FUN-A50102
              "    SET ogb60 = ? ",
              "  WHERE ogb01 = '",p_ogb.ogb01,"'",
              "    AND ogb03 = ",p_ogb.ogb03
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980020 自動加上plant的關聯條件 
  PREPARE upd_ogb60 FROM l_sql
  EXECUTE upd_ogb60 USING p_ogb.ogb917
  IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
     CALL cl_err('upd ogb60:',SQLCA.SQLCODE,1) LET g_success='N' 
  END IF
END FUNCTION
 
FUNCTION p861_ins_omc()
DEFINE l_omc        RECORD LIKE omc_file.*
DEFINE l_oas        RECORD LIKE oas_file.*
DEFINE l_omc03      LIKE omc_file.omc03
DEFINE l_oas02      LIKE oas_file.oas02
DEFINE l_sql        STRING
DEFINE l_n          LIKE type_file.num5          #No.FUN-680123 SMALLINT
DEFINE l_omc08      LIKE omc_file.omc08          #No.MOD-740428
DEFINE l_omc09      LIKE omc_file.omc09          #No.MOD-740428
DEFINE l_omc02      LIKE omc_file.omc02          #No.MOD-740428
DEFINE l_legal LIKE azw_file.azw02 #FUN-980006 add
 
  #LET l_sql="SELECT DISTINCT(oas02) FROM ",p_dbs CLIPPED,"oas_file ",
  LET l_sql="SELECT DISTINCT(oas02) FROM ",cl_get_target_table(p_plant,'oas_file'), #FUN-A50102
            " WHERE oas01='",p_oma.oma32,"' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
  PREPARE ins_omc_p1 FROM l_sql
  EXECUTE ins_omc_p1 INTO l_oas02
 
  INITIALIZE l_omc.* TO NULL
 
  #LET l_sql="INSERT INTO ",p_dbs CLIPPED,"omc_file",
  LET l_sql="INSERT INTO ",cl_get_target_table(p_plant,'omc_file'), #FUN-A50102
            "(omc01,omc02,omc03,omc04,omc05,omc06,omc07,",
            " omc08,omc09,omc10,omc11,omc12,omc13,omc14,",
            " omc15,omclegal)", #FUN-9A0099 
            " VALUES( ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?, ?) " #FUN-960141 add 1 ?  #FUN-960141 090819 DEL 1 ? #FUN-980006 add ?
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
         CALL s_getlegal(p_plant) RETURNING l_legal #FUN-980006 add
  PREPARE ins_omc FROM l_sql
 
  IF l_oas02='1' THEN
     LET l_n=1
     #LET l_sql=" SELECT * FROM ",p_dbs CLIPPED,"oas_file ",
     LET l_sql=" SELECT * FROM ",cl_get_target_table(p_plant,'oas_file'), #FUN-A50102
               "  WHERE oas01='",p_oma.oma32,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
     PREPARE p300_omc_p  FROM l_sql   
     DECLARE p300_omc_cs CURSOR FOR p300_omc_p
     FOREACH p300_omc_cs INTO l_oas.*
       LET l_omc.omc01=p_oma.oma01
       LET l_omc.omc02=l_n
       LET l_omc.omc03=l_oas.oas04
       #CALL s_rdatem(p_oma.oma03,l_omc03,p_oma.oma02,p_oma.oma09,p_oma.oma02,g_plant)  #FUN-980020 #MOD-C60196 mark
       CALL s_rdatem(p_oma.oma03,l_omc.omc03,p_oma.oma02,p_oma.oma09,p_oma.oma02,g_plant)  #MOD-C60196 add
            RETURNING l_omc.omc04,l_omc.omc05
       LET l_omc.omc06=p_oma.oma24
       LET l_omc.omc07=p_oma.oma60
       LET l_omc.omc08=p_oma.oma54t*(l_oas.oas05/100)	
       CALL cl_digcut(l_omc.omc08,p_azi.azi04) RETURNING l_omc.omc08 
       LET l_omc.omc09=p_oma.oma56t*(l_oas.oas05/100)	
       CALL cl_digcut(l_omc.omc09,s_azi.azi04) RETURNING l_omc.omc09 
       LET l_omc.omc10=0
       LET l_omc.omc11=0
       LET l_omc.omc12=p_oma.oma10
       LET l_omc.omc13=l_omc.omc09-l_omc.omc11 #MOD-7C0183 modify
       LET l_omc.omc14=0
       LET l_omc.omc15=0
       EXECUTE ins_omc USING l_omc.omc01,l_omc.omc02,l_omc.omc03,l_omc.omc04,
                             l_omc.omc05,l_omc.omc06,l_omc.omc07,l_omc.omc08,
                             l_omc.omc09,l_omc.omc10,l_omc.omc11,l_omc.omc12,
                             l_omc.omc13,l_omc.omc14,l_omc.omc15   #,l_omc.omcplant #FUN-960141 add omcplant   #FUN-960141 090819 del omcplant
                             ,l_legal  #FUN-980006 add l_legal
       IF SQLCA.sqlcode THEN
          CALL s_errmsg('oma01',l_omc.omc01,"insert omc_file",SQLCA.sqlcode,1)                                 #NO.FUN-710050  
          LET g_success='N'
          EXIT FOREACH
       ELSE
       	  LET l_n=l_n+1
       END IF       
     END FOREACH
  END IF
  IF l_oas02='2' OR cl_null(l_oas02) THEN
     LET l_omc.omc01=p_oma.oma01
     LET l_omc.omc02=1
     LET l_omc.omc03=p_oma.oma32
     LET l_omc.omc04=p_oma.oma11
     LET l_omc.omc05=p_oma.oma12
     LET l_omc.omc06=p_oma.oma24
     LET l_omc.omc07=p_oma.oma60
     LET l_omc.omc08=p_oma.oma54t  #MOD-7C0183 modify
     LET l_omc.omc09=p_oma.oma56t  #MOD-7C0183 modify
     LET l_omc.omc10=0
     LET l_omc.omc11=0
     LET l_omc.omc12=p_oma.oma10
     LET l_omc.omc13=l_omc.omc09-l_omc.omc11 #MOD-7C0183 modify
     LET l_omc.omc14=0
     LET l_omc.omc15=0
     EXECUTE ins_omc USING l_omc.omc01,l_omc.omc02,l_omc.omc03,l_omc.omc04,
                           l_omc.omc05,l_omc.omc06,l_omc.omc07,l_omc.omc08,
                           l_omc.omc09,l_omc.omc10,l_omc.omc11,l_omc.omc12,
                           l_omc.omc13,l_omc.omc14,l_omc.omc15  #,l_omc.omcplant #FUN-960141 add omcplant   #FUN-960141 del omcplant
                           ,l_legal  #FUN-980006 add l_legal
     IF SQLCA.sqlcode THEN
        CALL s_errmsg('omc01',l_omc.omc01,"insert omc_file",SQLCA.sqlcode,1)                           #NO.FUN-710050   
        LET g_success='N'
     END IF
  END IF
END FUNCTION
 
FUNCTION p861_ins_apc()
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_n       LIKE type_file.num5
DEFINE l_apc13   LIKE apc_file.apc13
DEFINE l_pmb     RECORD LIKE pmb_file.*
DEFINE l_apc     RECORD LIKE apc_file.*
DEFINE ll_sql    STRING
DEFINE l_temp    LIKE apa_file.apa24
DEFINE l_legal LIKE azw_file.azw02 #FUN-980006 add
 
   #LET ll_sql="SELECT count(*) FROM ",p_dbs CLIPPED,"pmb_file ",
   LET ll_sql="SELECT count(*) FROM ",cl_get_target_table(p_plant,'pmb_file'), #FUN-A50102
             " WHERE pmb01='",p_apa.apa11,"' "
 	 CALL cl_replace_sqldb(ll_sql) RETURNING ll_sql        #FUN-920032
     CALL cl_parse_qry_sql(ll_sql,p_plant) RETURNING ll_sql #FUN-A50102
   PREPARE ins_apc_1 FROM ll_sql
   EXECUTE ins_apc_1 INTO l_cnt 
 
   IF NOT cl_null(p_apa.apa01) THEN
      #LET ll_sql="INSERT INTO ",p_dbs CLIPPED,"apc_file", 
      LET ll_sql="INSERT INTO ",cl_get_target_table(p_plant,'apc_file'), #FUN-A50102
                "(apc01,apc02,apc03,apc04,apc05,apc06,apc07,",
                " apc08,apc09,apc10,apc11,apc12,apc13,apc14,",
                " apc15,apc16,apclegal)",  #,apcplant)", #FUN-960141 add apcplant   #FUN-960141 del apcplant #FUN-980006 add apclegal
                " VALUES( ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,? ,?) " #FUN-960141 add 1 ?  #FUN-960141 090824 del 1 ?  #FUN-980006 add ?
 	 CALL cl_replace_sqldb(ll_sql) RETURNING ll_sql        #FUN-920032
     CALL cl_parse_qry_sql(ll_sql,p_plant) RETURNING ll_sql #FUN-A50102
         CALL s_getlegal(p_plant) RETURNING l_legal #FUN-980006 add
      PREPARE ins_apc FROM ll_sql
 
      IF l_cnt > 0 THEN
         #LET ll_sql="SELECT pmb02 FROM ",p_dbs CLIPPED,"pmb_file ",
         LET ll_sql="SELECT pmb02 FROM ",cl_get_target_table(p_plant,'pmb_file'), #FUN-A50102
                   " WHERE pmb01='",p_apa.apa11,"' "
 	 CALL cl_replace_sqldb(ll_sql) RETURNING ll_sql        #FUN-920032
     CALL cl_parse_qry_sql(ll_sql,p_plant) RETURNING ll_sql #FUN-A50102
         PREPARE pmb_pre FROM ll_sql
         EXECUTE pmb_pre INTO l_pmb.pmb02 
         IF l_pmb.pmb02 = 1 THEN
            LET l_n = 1
            LET l_apc13 = 0
            LET ll_sql = " SELECT pmb01,pmb03,pmb04,pmb05",
                        #"   FROM ",p_dbs CLIPPED,"pmb_file ",
                        "   FROM ",cl_get_target_table(p_plant,'pmb_file'), #FUN-A50102
                        "  WHERE pmb01 = '",p_apa.apa11,"'"
 	 CALL cl_replace_sqldb(ll_sql) RETURNING ll_sql        #FUN-920032
     CALL cl_parse_qry_sql(ll_sql,p_plant) RETURNING ll_sql #FUN-A50102
            PREPARE p110_p1 FROM ll_sql
            DECLARE p110_c1 CURSOR FOR p110_p1
            FOREACH p110_c1 INTO l_pmb.pmb01,l_pmb.pmb03,
                                 l_pmb.pmb04,l_pmb.pmb05
               IF g_success = 'N' THEN
                  LET g_totsuccess = 'N'
                  LET g_success = 'Y'
               END IF
               LET l_apc.apc01 = p_apa.apa01
               LET l_apc.apc02 = l_pmb.pmb03
               LET l_apc.apc03 = l_pmb.pmb04
               #CALL s_paydate('a','',p_apa.apa09,p_apa.apa02,l_apc.apc03,p_apa.apa06)   #MOD-A50182 mark
               #     RETURNING l_apc.apc04,l_apc.apc05,l_temp   #MOD-A50182 mark
               CALL s_paydate_m(p_plant,'a','',p_apa.apa09,p_apa.apa02,l_apc.apc03,p_apa.apa06)   #MOD-A50182
                    RETURNING l_apc.apc04,l_apc.apc05,l_temp   #MOD-A50182
               LET l_apc.apc06 = p_apa.apa14
               LET l_apc.apc07 = p_apa.apa72
               LET l_apc.apc08 = p_apa.apa34f*l_pmb.pmb05/100
               LET l_apc.apc09 = p_apa.apa34*l_pmb.pmb05/100
               LET l_apc.apc10 = 0
               LET l_apc.apc11 = 0
               LET l_apc.apc12 = p_apa.apa08
               IF l_n = l_cnt THEN
                  LET l_apc.apc13 = p_apa.apa73-l_apc13
               ELSE
                  LET l_apc.apc13 = p_apa.apa73*l_pmb.pmb05/100
                  LET l_apc13 = l_apc13+l_apc.apc13
                  LET l_n = l_n+1
               END IF
               LET l_apc.apc14 = 0
               LET l_apc.apc15 = 0
               LET l_apc.apc16 = 0
               LET l_apc.apc08 = cl_digcut(l_apc.apc08,l_azi.azi04) #MOD-820101 modify t_azi04)
               LET l_apc.apc09 = cl_digcut(l_apc.apc09,s_azi.azi04) #MOD-820101 modify g_azi04)
               LET l_apc.apc13 = cl_digcut(l_apc.apc13,s_azi.azi04) #MOD-820101 modify g_azi04)
#TQC-A70127 --begin--
               IF cl_null(l_apc.apc03) THEN 
                  LET l_apc.apc03 = ' ' 
               END IF 
#TQC-A70127 --end--               
               EXECUTE ins_apc USING l_apc.apc01,l_apc.apc02,l_apc.apc03,
                                     l_apc.apc04,l_apc.apc05,l_apc.apc06,
                                     l_apc.apc07,l_apc.apc08,l_apc.apc09,
                                     l_apc.apc10,l_apc.apc11,l_apc.apc12,
                                     l_apc.apc13,l_apc.apc14,l_apc.apc15
                                     ,l_apc.apc16   #,l_apc.apcplant #FUN-960141 add apcplant  #FUN-960141 090824 del apcplant
                                     ,l_legal  #FUN-980006 add l_legal
               IF STATUS THEN
                  LET g_success = 'N'
                  LET g_showmsg=l_apc.apc01,"/",l_apc.apc03
                  CALL s_errmsg('apc01,apc03','','',SQLCA.sqlcode,1)
                  CONTINUE FOREACH
               END IF
            END FOREACH
            IF g_totsuccess = 'N' THEN
               LET g_success = 'N'
            END IF
         END IF
         IF l_pmb.pmb02 = 2 THEN
            LET l_apc.apc01 = p_apa.apa01
            LET l_apc.apc02 = 1
            LET l_apc.apc03 = p_apa.apa11
            LET l_apc.apc04 = p_apa.apa12
            LET l_apc.apc05 = p_apa.apa64
            LET l_apc.apc06 = p_apa.apa14
            LET l_apc.apc07 = p_apa.apa72
            LET l_apc.apc08 = p_apa.apa34f
            LET l_apc.apc09 = p_apa.apa34
            LET l_apc.apc10 = 0
            LET l_apc.apc11 = 0
            LET l_apc.apc12 = p_apa.apa08
            LET l_apc.apc13 = p_apa.apa73
            LET l_apc.apc14 = 0
            LET l_apc.apc15 = 0
            LET l_apc.apc16 = 0
            LET l_apc.apc08 = cl_digcut(l_apc.apc08,l_azi.azi04) #MOD-820101 modify t_azi04)
            LET l_apc.apc09 = cl_digcut(l_apc.apc09,s_azi.azi04) #MOD-820101 modify g_azi04)
            LET l_apc.apc13 = cl_digcut(l_apc.apc13,s_azi.azi04) #MOD-820101 modify g_azi04)
#TQC-A70127 --begin--
               IF cl_null(l_apc.apc03) THEN 
                  LET l_apc.apc03 = ' ' 
               END IF 
#TQC-A70127 --end--               
            EXECUTE ins_apc USING l_apc.apc01,l_apc.apc02,l_apc.apc03,
                                  l_apc.apc04,l_apc.apc05,l_apc.apc06,
                                  l_apc.apc07,l_apc.apc08,l_apc.apc09,
                                  l_apc.apc10,l_apc.apc11,l_apc.apc12,
                                  l_apc.apc13,l_apc.apc14,l_apc.apc15
                                  ,l_apc.apc16   #,l_apc.apcplant #FUN-960141 add apcplant   #FUN-960141  090819 del apcplant
                                  ,l_legal  #FUN-980006 add l_legal
            IF STATUS THEN
               LET g_success = 'N'
               LET g_showmsg=l_apc.apc01,"/",l_apc.apc03
               CALL s_errmsg('apc01,apc03','','',SQLCA.sqlcode,1)
            END IF
         END IF
      END IF
      IF l_cnt = 0 THEN
         LET l_apc.apc01 = p_apa.apa01
         LET l_apc.apc02 = 1
         LET l_apc.apc03 = p_apa.apa11
         LET l_apc.apc04 = p_apa.apa12
         LET l_apc.apc05 = p_apa.apa64
         LET l_apc.apc06 = p_apa.apa14
         LET l_apc.apc07 = p_apa.apa72
         LET l_apc.apc08 = p_apa.apa34f
         LET l_apc.apc09 = p_apa.apa34
         LET l_apc.apc10 = 0
         LET l_apc.apc11 = 0
         LET l_apc.apc12 = p_apa.apa08
         LET l_apc.apc13 = p_apa.apa73
         LET l_apc.apc14 = 0
         LET l_apc.apc15 = 0
         LET l_apc.apc16 = 0
         LET l_apc.apc08 = cl_digcut(l_apc.apc08,l_azi.azi04) #MOD-820101 modify t_azi04)
         LET l_apc.apc09 = cl_digcut(l_apc.apc09,s_azi.azi04) #MOD-820101 modify g_azi04)
         LET l_apc.apc13 = cl_digcut(l_apc.apc13,s_azi.azi04) #MOD-820101 modify g_azi04)
#TQC-A70127 --begin--
               IF cl_null(l_apc.apc03) THEN 
                  LET l_apc.apc03 = ' ' 
               END IF 
#TQC-A70127 --end--            
         EXECUTE ins_apc USING l_apc.apc01,l_apc.apc02,l_apc.apc03,
                               l_apc.apc04,l_apc.apc05,l_apc.apc06,
                               l_apc.apc07,l_apc.apc08,l_apc.apc09,
                               l_apc.apc10,l_apc.apc11,l_apc.apc12,
                               l_apc.apc13,l_apc.apc14,l_apc.apc15,
                               l_apc.apc16  #,l_apc.apcplant #FUN-960141 add apcplant  #FUN-960141 090824 mark
                               ,l_legal  #FUN-980006 add l_legal
         IF STATUS THEN
            LET g_success = 'N'
            LET g_showmsg=l_apc.apc01,"/",l_apc.apc03
            CALL s_errmsg('apc01,apc03',g_showmsg,'',SQLCA.sqlcode,1)
         END IF
      END IF
   END IF
 
END FUNCTION

#FUNCTION p861_occ37(l_npq03,l_bookno,l_oma03,l_npq37,l_dbs) 
FUNCTION p861_occ37(l_npq03,l_bookno,l_oma03,l_npq37,l_dbs,l_plant)  #FUN-A50102
   DEFINE l_npq03  LIKE npq_file.npq03,   #科目 
          l_bookno LIKE aza_file.aza81,   #帳別
          l_oma03  LIKE oma_file.oma03,   #客戶編號
          l_npq37  LIKE npq_file.npq37,   #關係人
          l_dbs    LIKE type_file.chr21,  #資料庫名稱
          l_plant  LIKE type_file.chr21,  #FUN-A50102
          l_occ02  LIKE occ_file.occ02,   #客戶簡稱
          l_occ37  LIKE occ_file.occ37    #是否為關係人
 
   ## 判斷應收客戶是否為關係人
   LET p_aag371=' '
   LET l_sql = "SELECT aag371 ",
               #" FROM ",l_dbs CLIPPED,"aag_file ",
               " FROM ",cl_get_target_table(l_plant,'aag_file'), #FUN-A50102
               " WHERE aag01 = '",l_npq03,"'",
               "   AND aag00 = '",l_bookno,"' "
 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
   PREPARE aag_p91 FROM l_sql 
   IF SQLCA.SQLCODE THEN
      LET g_showmsg=l_dbs,"/",l_npq03,"/",l_bookno
      CALL s_errmsg("poy04,aag01,aag00",g_showmsg,"aag_p91",SQLCA.sqlcode,0)
   END IF
   DECLARE aag_c91 CURSOR FOR aag_p91
   OPEN aag_c91
   FETCH aag_c91 INTO p_aag371
   CLOSE aag_c91
    #IF p_aag371 MATCHES '[23]' THEN                #FUN-950053 mark
     IF p_aag371 MATCHES '[234]' THEN               #FUN-950053 add 
        #-->for 合併報表-關係人
        IF cl_null(l_npq37) THEN
           #讀取客戶簡稱
           LET l_occ02=''
           LET l_occ37=NULL     
           LET l_sql = "SELECT occ02,occ37 ",
                       #" FROM ",l_dbs CLIPPED,"occ_file ",
                       " FROM ",cl_get_target_table(l_plant,'occ_file'), #FUN-A50102
                       " WHERE occ01 = '",l_oma03,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
           PREPARE occ_p91 FROM l_sql 
           IF SQLCA.SQLCODE THEN
              LET g_showmsg=l_dbs,"/",l_oma03
              CALL s_errmsg("poy04,oma03",g_showmsg,"occ_p91",SQLCA.sqlcode,0)
           END IF
           DECLARE occ_c91 CURSOR FOR occ_p91
           OPEN occ_c91
           FETCH occ_c91 INTO l_occ02,l_occ37
           CLOSE occ_c91
           IF l_occ37='Y' THEN
              LET l_npq37=l_oma03
           END IF
        END IF
     END IF
     RETURN  l_npq37
END FUNCTION
 
 
## 判斷應收廠商是否為關係人
#FUNCTION p861_pmc903(l_npq03,l_bookno,l_apa06,l_npq37,l_dbs)
FUNCTION p861_pmc903(l_npq03,l_bookno,l_apa06,l_npq37,l_dbs,l_plant)  #FUN-A50102
   DEFINE l_npq03  LIKE npq_file.npq03,   #科目 
          l_bookno LIKE aza_file.aza81,   #帳別
          l_apa06  LIKE apa_file.apa06,   #廠商編號
          l_npq37  LIKE npq_file.npq37,   #關係人
          l_dbs    LIKE type_file.chr21,  #資料庫名稱
          l_plant  LIKE type_file.chr21,  #FUN-A50102
          l_pmc03  LIKE pmc_file.pmc03,   #廠商簡稱
          l_pmc903 LIKE pmc_file.pmc903   #是否為關係人
 
   ## 判斷應收廠商是否為關係人
     LET p_aag371=' '
     LET l_sql = "SELECT aag371 ",
                 #" FROM ",l_dbs CLIPPED,"aag_file ",
                 " FROM ",cl_get_target_table(l_plant,'aag_file'), #FUN-A50102
                 " WHERE aag01 = '",l_npq03,"'",
                 "   AND aag00 = '",l_bookno,"' "
 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
     PREPARE aag_p93 FROM l_sql 
     IF SQLCA.SQLCODE THEN
        LET g_showmsg=l_dbs,"/",l_npq03,"/",l_bookno
        CALL s_errmsg("poy04,aag01,aag00",g_showmsg,"aag_p93",SQLCA.sqlcode,0)
     END IF
     DECLARE aag_c93 CURSOR FOR aag_p93
     OPEN aag_c93
     FETCH aag_c93 INTO p_aag371
     CLOSE aag_c93
    #IF p_aag371 MATCHES '[23]' THEN                #FUN-950053 mark
     IF p_aag371 MATCHES '[234]' THEN               #FUN-950053 add 
        #-->for 合併報表-關係人
        IF cl_null(l_npq37) THEN
           LET l_pmc903 = NULL
           LET l_pmc03 = NULL
           LET l_sql = "SELECT pmc903,pmc03 ",
                       #" FROM ",l_dbs CLIPPED,"pmc_file ",
                       " FROM ",cl_get_target_table(l_plant,'pmc_file'), #FUN-A50102
                       " WHERE pmc01 = '",l_apa06,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
           PREPARE pmc_p91 FROM l_sql 
           IF SQLCA.SQLCODE THEN
              LET g_showmsg=l_dbs,"/",l_apa06
              CALL s_errmsg("poy04,apa06",g_showmsg,"pmc_p91",SQLCA.sqlcode,0)
           END IF
           DECLARE pmc_c91 CURSOR FOR pmc_p91
           OPEN pmc_c91
           FETCH pmc_c91 INTO l_pmc903,l_pmc03
           CLOSE pmc_c91
           IF l_pmc903 MATCHES '[yY]' THEN
              LET l_npq37 = l_apa06
           END IF 
        END IF
     END IF
   
     RETURN l_npq37
 
END FUNCTION 
 
FUNCTION p861_up_omb(p_oma01) 
# copy from axr/s_up_omb.4gl  
  DEFINE p_oma01 LIKE oma_file.oma01
  DEFINE m_oma  RECORD LIKE oma_file.*
  DEFINE m_azi04  LIKE azi_file.azi04     
  DEFINE l_oma   RECORD LIKE oma_file.*
  DEFINE l_omb   RECORD LIKE omb_file.*
  DEFINE l_omb14  LIKE omb_file.omb14,
         l_omb14t LIKE omb_file.omb14t,
         l_omb16  LIKE omb_file.omb16,
         l_omb16t LIKE omb_file.omb16t,
         l_omb18  LIKE omb_file.omb18,
         l_omb18t LIKE omb_file.omb18t 
  DEFINE diff_omb14  LIKE omb_file.omb14,
         diff_omb14t LIKE omb_file.omb14t,
         diff_omb16  LIKE omb_file.omb16,
         diff_omb16t LIKE omb_file.omb16t,
         diff_omb18  LIKE omb_file.omb18,
         diff_omb18t LIKE omb_file.omb18t 
  DEFINE l_diff_omb14  LIKE omb_file.omb14,        #No.FUN-680123 DEC(15,2),
         l_diff_omb14t LIKE omb_file.omb14t,       #No.FUN-680123 DEC(15,2),
         l_diff_omb16  LIKE omb_file.omb16,        #No.FUN-680123DEC(15,2),
         l_diff_omb16t LIKE omb_file.omb16t,       #No.FUN-680123 DEC(15,2),
         l_diff_omb18  LIKE omb_file.omb18,        #No.FUN-680123 DEC(15,2),
         l_diff_omb18t LIKE omb_file.omb18t        #No.FUN-680123 DEC(15,2)
  DEFINE l_total  LIKE omb_file.omb14,
         l_qty    LIKE omb_file.omb14, 
         l_a      LIKE omb_file.omb14, 
         t_a      LIKE omb_file.omb14, 
         s_oma54  LIKE oma_file.oma54, 
         s_oma54t LIKE oma_file.oma54t, 
         s_oma56  LIKE oma_file.oma56, 
         s_oma56t LIKE oma_file.oma56t, 
         s_oma59  LIKE oma_file.oma59, 
         s_oma59t LIKE oma_file.oma59t, 
         l_x      LIKE omb_file.omb14  
  DEFINE l_flag    LIKE type_file.chr1,         #No.FUN-680123 VARCHAR(1), #FUN-580086
         l_oma59   LIKE oma_file.oma59,         #FUN-580086
         l_oma59x  LIKE oma_file.oma59x,        #FUN-580086
         l_oma59t  LIKE oma_file.oma59t         #FUN-580086
  DEFINE l_cnt       LIKE type_file.num5         #No.TQC-5B0175  #No.FUN-680123 SMALLINT
  DEFINE l_oot05     LIKE oot_file.oot05   #No.TQC-5B0175 本幣未稅 
  DEFINE l_oot05t    LIKE oot_file.oot05t  #No.TQC-5B0175
  DEFINE l_omc01     LIKE omc_file.omc01   #MOD-7B0020
  DEFINE l_omc02     LIKE omc_file.omc02   #MOD-7B0020
 
  IF cl_null(p_oma01) THEN RETURN  END IF
  #LET l_sql="SELECT * FROM ",p_dbs," oma_file ", 
  LET l_sql="SELECT * FROM ",cl_get_target_table(p_plant,'oma_file'), #FUN-A50102  
            " WHERE oma01='",p_oma01,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
  PREPARE p861_prep91 FROM l_sql
  DECLARE p861_curs91 CURSOR FOR p861_prep91
  OPEN p861_curs91
  FETCH p861_curs91 INTO m_oma.*
  IF STATUS THEN 
     CALL cl_err3("sel","oma_file",p_oma01,"",STATUS,"","sel oma:",1)    #No.FUN-660116
     RETURN  
  END IF
  IF m_oma.oma02<=g_ooz.ooz09 THEN CALL cl_err('','axr-164',0) RETURN  END IF
  #若出貨比率不為 100% 或不為出貨應收 則不適用此functiion
  IF m_oma.oma162 <> 100 OR
    (m_oma.oma00<> '12' AND m_oma.oma00<>'14' AND m_oma.oma00<> '21')  #MOD-870214
       THEN RETURN  END IF
 
  LET l_sql="SELECT SUM(omb14),SUM(omb14*oma24),SUM(omb14*oma58),SUM(omb14t*oma58) ",	#TQC-9A0154 add omb14t*oma58
            #"  FROM ",p_dbs," omb_file,",p_dbs," oma_file ", 
            "  FROM ",cl_get_target_table(p_plant,'omb_file'),",", #FUN-A50102 
                      cl_get_target_table(p_plant,'oma_file'),     #FUN-A50102    
            " WHERE omb01='",m_oma.oma01,"' AND omb01=oma01"
  CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
  CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
  PREPARE p861_prep93 FROM l_sql
  DECLARE p861_curs93 CURSOR FOR p861_prep93
  OPEN p861_curs93
  FETCH p861_curs93 INTO l_omb14,l_omb16,l_omb18,l_omb18t 				#TQC-9A0154 add omb18t
 
  IF cl_null(l_omb14) THEN LET l_omb14 = 0 END IF
  IF cl_null(l_omb16) THEN LET l_omb16 = 0 END IF
  IF cl_null(l_omb18) THEN LET l_omb18 = 0 END IF
  CALL cl_digcut(l_omb14,p_azi.azi04) RETURNING l_omb14  
  CALL cl_digcut(l_omb16,s_azi.azi04) RETURNING l_omb16  
  CALL cl_digcut(l_omb18,s_azi.azi04) RETURNING l_omb18  
  IF m_oma.oma213='N' THEN
     LET l_oma59 = l_omb18
     LET l_oma59x=l_oma59*m_oma.oma211/100
     CALL cl_digcut(l_oma59x,s_azi.azi04) RETURNING l_oma59x  #MOD-880036 
     LET l_oma59t=l_oma59+l_oma59x
     IF l_oma59t <> m_oma.oma56t THEN     						#MOD-9A0163 
        IF cl_confirm("axr-007") THEN
     #外加稅
           LET m_oma.oma50 = l_omb14 
           LET m_oma.oma50t = m_oma.oma50 * (1+m_oma.oma211/100)
           CALL cl_digcut(m_oma.oma50t,p_azi.azi04) RETURNING m_oma.oma50t  #MOD-880036 mark
           LET m_oma.oma54 = m_oma.oma50
           LET m_oma.oma54x=m_oma.oma54*m_oma.oma211/100
           CALL cl_digcut(m_oma.oma54x,p_azi.azi04) RETURNING m_oma.oma54x  #MOD-880036
           LET m_oma.oma54t=m_oma.oma54+m_oma.oma54x
           LET m_oma.oma56 = l_omb16 
           LET m_oma.oma56x=m_oma.oma56*m_oma.oma211/100
           CALL cl_digcut(m_oma.oma56x,s_azi.azi04) RETURNING m_oma.oma56x  #MOD-880036 
           LET m_oma.oma56t=m_oma.oma56+m_oma.oma56x
           IF l_oma59t <> m_oma.oma59t AND p_poy20 <> '3' THEN		#MOD-9A0163 
              LET m_oma.oma59 = l_omb18 
              LET m_oma.oma59x=m_oma.oma59*m_oma.oma211/100
              CALL cl_digcut(m_oma.oma59x,s_azi.azi04) RETURNING m_oma.oma59x  #MOD-880036
              LET m_oma.oma59t=m_oma.oma59+m_oma.oma59x
              LET m_oma.oma56 = cl_digcut(m_oma.oma56,s_azi.azi04)
              LET m_oma.oma56x = cl_digcut(m_oma.oma56x,s_azi.azi04)
              LET m_oma.oma56t = cl_digcut(m_oma.oma56t,s_azi.azi04)
              LET m_oma.oma59 = cl_digcut(m_oma.oma59,s_azi.azi04)
              LET m_oma.oma59x = cl_digcut(m_oma.oma59x,s_azi.azi04)
              LET m_oma.oma59t = cl_digcut(m_oma.oma59t,s_azi.azi04)
           END IF							#MOD-9A0163
        END IF
     END IF
  ELSE
     LET l_oma59t = l_omb18t				#TQC-9A0154
     LET l_oma59x=l_oma59t*m_oma.oma211/(100+m_oma.oma211)
     CALL cl_digcut(l_oma59x,s_azi.azi04) RETURNING l_oma59x  #MOD-880036
     LET l_oma59 =l_oma59t-l_oma59x
     IF l_oma59 <> m_oma.oma56 THEN				    						#MOD-9A0163 
        IF cl_confirm("axr-007") THEN
        #內含稅
           LET m_oma.oma50t= l_omb14 
           LET m_oma.oma50  = m_oma.oma50t*100/(100+m_oma.oma211)    #No.MOD-520040
           CALL cl_digcut(m_oma.oma50,p_azi.azi04) RETURNING m_oma.oma50  #MOD-880036
           CALL cl_digcut(m_oma.oma54t,p_azi.azi04) RETURNING m_oma.oma54t  #MOD-880036
           LET m_oma.oma54x=m_oma.oma54t*m_oma.oma211/(100+m_oma.oma211)
           CALL cl_digcut(m_oma.oma54x,p_azi.azi04) RETURNING m_oma.oma54x  #MOD-880036 mark
           LET m_oma.oma54 =m_oma.oma54t-m_oma.oma54x
           CALL cl_digcut(m_oma.oma56t,s_azi.azi04) RETURNING m_oma.oma56t   #MOD-880036
           LET m_oma.oma56x=m_oma.oma56t*m_oma.oma211/(100+m_oma.oma211)
           CALL cl_digcut(m_oma.oma56x,s_azi.azi04) RETURNING m_oma.oma56x  #MOD-880036 
           LET m_oma.oma56 =m_oma.oma56t-m_oma.oma56x
           IF l_oma59 <> m_oma.oma59 AND p_poy20 <> '3' THEN     	#MOD-9A0163 
              LET m_oma.oma59x=m_oma.oma59t*m_oma.oma211/(100+m_oma.oma211)
              CALL cl_digcut(m_oma.oma59x,s_azi.azi04) RETURNING m_oma.oma59x  #MOD-880036
              LET m_oma.oma59 =m_oma.oma59t-m_oma.oma59x
              LET m_oma.oma56 = cl_digcut(m_oma.oma56,s_azi.azi04)
              LET m_oma.oma56x = cl_digcut(m_oma.oma56x,s_azi.azi04)
              LET m_oma.oma56t = cl_digcut(m_oma.oma56t,s_azi.azi04)
              LET m_oma.oma59 = cl_digcut(m_oma.oma59,s_azi.azi04)
              LET m_oma.oma59x = cl_digcut(m_oma.oma59x,s_azi.azi04)
              LET m_oma.oma59t = cl_digcut(m_oma.oma59t,s_azi.azi04)
           END IF							#MOD-9A0163
        END IF
     END IF
  END IF
 
  LET s_oma54 = m_oma.oma54
  LET s_oma54t= m_oma.oma54t
  LET s_oma56 = m_oma.oma56
  LET s_oma56t= m_oma.oma56t
  LET s_oma59 = m_oma.oma59
  LET s_oma59t= m_oma.oma59t
  IF cl_null(s_oma54)  THEN LET s_oma54 =0 END IF   #MOD-A70070
  IF cl_null(s_oma54t) THEN LET s_oma54t=0 END IF   #MOD-A70070
  IF cl_null(s_oma56)  THEN LET s_oma56 =0 END IF   #MOD-A70070
  IF cl_null(s_oma56t) THEN LET s_oma56t=0 END IF   #MOD-A70070
  IF cl_null(s_oma59)  THEN LET s_oma59 =0 END IF   #MOD-A70070
  IF cl_null(s_oma59t) THEN LET s_oma59t=0 END IF   #MOD-A70070
 
  #確認的帳單才會扣除發票待扺金額
  IF m_oma.omaconf = 'Y' THEN
     LET l_sql="SELECT COUNT(*),SUM(oot05),SUM(oot05t)",
               #"  FROM ",p_dbs," oot_file ", 
               "  FROM ",cl_get_target_table(p_plant,'oot_file'), #FUN-A50102         
               " WHERE oot03='",m_oma.oma01,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
     PREPARE p861_prep94 FROM l_sql
     DECLARE p861_curs94 CURSOR FOR p861_prep94
     OPEN p861_curs94
     FETCH p861_curs94 INTO l_cnt,l_oot05,l_oot05t
 
     IF l_cnt > 0 THEN
        IF cl_null(l_oot05)  THEN LET l_oot05  = 0 END IF
        IF cl_null(l_oot05t) THEN LET l_oot05t = 0 END IF
        LET s_oma59 = m_oma.oma59 + l_oot05
        LET s_oma59t= m_oma.oma59t + l_oot05t
     END IF
  END IF
 
  #讀取單身之金額加總
  LET l_sql="SELECT SUM(omb14),SUM(omb14t),SUM(omb16),SUM(omb16t),SUM(omb18),SUM(omb18t)",
            #"  FROM ",p_dbs," omb_file ",
            "  FROM ",cl_get_target_table(p_plant,'omb_file'), #FUN-A50102      
            " WHERE omb01='",m_oma.oma01,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
  PREPARE p861_prep95 FROM l_sql
  DECLARE p861_curs95 CURSOR FOR p861_prep95
  OPEN p861_curs95
  FETCH p861_curs95 INTO l_omb14,l_omb14t,l_omb16,l_omb16t,l_omb18,l_omb18t

  IF cl_null(l_omb14)  THEN LET l_omb14 = 0 END IF   #MOD-A70070
  IF cl_null(l_omb14t) THEN LET l_omb14t= 0 END IF   #MOD-A70070
  IF cl_null(l_omb16)  THEN LET l_omb16 = 0 END IF   #MOD-A70070
  IF cl_null(l_omb16t) THEN LET l_omb16t= 0 END IF   #MOD-A70070
  IF cl_null(l_omb18)  THEN LET l_omb18 = 0 END IF   #MOD-A70070
  IF cl_null(l_omb18t) THEN LET l_omb18t= 0 END IF   #MOD-A70070
 
  LET diff_omb14 = s_oma54 - l_omb14 
  LET diff_omb14t= s_oma54t- l_omb14t
  LET diff_omb16 = s_oma56 - l_omb16 
  LET diff_omb16t= s_oma56t- l_omb16t
  LET diff_omb18 = s_oma59 - l_omb18 
  LET diff_omb18t= s_oma59t- l_omb18t
  LET l_diff_omb14t= diff_omb14t
  LET l_diff_omb16t= diff_omb16t
  LET l_diff_omb18t= diff_omb18t
  #LET l_sql="SELECT * FROM ",p_dbs," omb_file ", 
  LET l_sql="SELECT * FROM ",cl_get_target_table(p_plant,'omb_file'), #FUN-A50102      
            " WHERE omb01='",m_oma.oma01,"'",
            " ORDER BY omb14t DESC "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
  PREPARE p861_prep96 FROM l_sql
  DECLARE p861_curs96 CURSOR FOR p861_prep96
  FOREACH p861_curs96 INTO l_omb.* 
      IF SQLCA.SQLCODE <> 0 THEN EXIT FOREACH END IF
      LET l_flag = 'N'    #MOD-6C0102
      IF m_oma.oma211 > 0 THEN   #MOD-A70070
         #IF g_aza.aza26 ='2' THEN   #MOD-A30020
         IF p_aza.aza26 ='2' THEN   #MOD-A30020
            LET l_diff_omb16=l_omb.omb16t-l_omb.omb16*(1+m_oma.oma211/100)
            IF l_diff_omb16t+l_diff_omb16>=0.06 OR l_diff_omb16t+l_diff_omb16<=-0.06 THEN
               IF l_diff_omb16t+l_diff_omb16<=-0.06 THEN
                  LET diff_omb14t=-(0.05+l_diff_omb16)/m_oma.oma24
                  LET diff_omb16t=-(0.05+l_diff_omb16)
                  LET diff_omb18t=-diff_omb14t*m_oma.oma58
               ELSE
                  LET diff_omb14t=(0.05-l_diff_omb16)/m_oma.oma24
                  LET diff_omb16t=0.05-l_diff_omb16
                  LET diff_omb18t=diff_omb14t*m_oma.oma58
               END IF
               LET l_flag = 'Y' 
            ELSE
               LET diff_omb14t=l_diff_omb14t
               LET diff_omb16t=l_diff_omb16t
               LET diff_omb18t=l_diff_omb18t
            END IF
         END IF
      END IF   #MOD-A70070
      CALL cl_digcut(diff_omb14 ,p_azi.azi04) RETURNING diff_omb14
      CALL cl_digcut(diff_omb14t,p_azi.azi04) RETURNING diff_omb14t
      CALL cl_digcut(diff_omb16 ,s_azi.azi04) RETURNING diff_omb16
      CALL cl_digcut(diff_omb16t,s_azi.azi04) RETURNING diff_omb16t
      CALL cl_digcut(diff_omb18, s_azi.azi04) RETURNING diff_omb18
      CALL cl_digcut(diff_omb18t,s_azi.azi04) RETURNING diff_omb18t
       #LET l_sql = " UPDATE ",p_dbs," omb_file SET omb14 = omb14+ ? ", 
       LET l_sql = " UPDATE ",cl_get_target_table(p_plant,'omb_file'), #FUN-A50102    
                   "    SET omb14 = omb14+ ? ",   
                   " ,omb14t = omb14t+ ?,omb16 = omb16+ ? ",
                   " ,omb16t = omb16t+ ?,omb18 = omb18+ ?,omb18t = omb18t+ ? ",
                   "  WHERE omb01 = '",l_omb.omb01,"'",
                   "    AND omb03 = '",l_omb.omb03,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
      PREPARE upd_omb91 FROM l_sql
      EXECUTE upd_omb91 USING diff_omb14,diff_omb14t,diff_omb16,diff_omb16t,
                              diff_omb18,diff_omb18t
      IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
         LET g_success='N'
         CALL cl_err3("upd","omb_file",l_omb.omb01,l_omb.omb03,SQLCA.sqlcode,"","upd omb err:",0)   #No.FUN-660116
      END IF
      IF l_flag = 'N' THEN
         EXIT FOREACH
      END IF
      LET l_diff_omb14t=l_diff_omb14t-diff_omb14t
      LET l_diff_omb16t=l_diff_omb16t-diff_omb16t
      LET l_diff_omb18t=l_diff_omb18t-diff_omb18t
  END FOREACH
  IF cl_null(m_oma.oma50)  THEN LET m_oma.oma50  = 0 END IF
  IF cl_null(m_oma.oma50t)  THEN LET m_oma.oma50t = 0 END IF
  IF cl_null(m_oma.oma54)  THEN LET m_oma.oma54  = 0 END IF
  IF cl_null(m_oma.oma54x)  THEN LET m_oma.oma54x = 0 END IF
  IF cl_null(m_oma.oma54t)  THEN LET m_oma.oma54t = 0 END IF
  IF cl_null(m_oma.oma56)  THEN LET m_oma.oma56  = 0 END IF
  IF cl_null(m_oma.oma56x)  THEN LET m_oma.oma56x = 0 END IF
  IF cl_null(m_oma.oma56t)  THEN LET m_oma.oma56t = 0 END IF
  IF cl_null(m_oma.oma59)  THEN LET m_oma.oma59  = 0 END IF
  IF cl_null(m_oma.oma59x)  THEN LET m_oma.oma59x = 0 END IF
  IF cl_null(m_oma.oma59t)  THEN LET m_oma.oma59t = 0 END IF
 
  #LET l_sql = " UPDATE ",p_dbs," oma_file SET oma50 = ? ", 
LET l_sql = " UPDATE ",cl_get_target_table(p_plant,'oma_file'), #FUN-A50102
              "  SET oma50 = ? ",   
              " ,oma50t = ?,oma54 = ? ",
              " ,oma54x = ?,oma54t = ?,oma56 = ? ",
              " ,oma56x = ?,oma56t = ?,oma61 = ? ",
              " ,oma59  = ?,oma59x = ?,oma59t= ? ",
              "  WHERE oma01 = '",m_oma.oma01,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
  PREPARE upd_omb92 FROM l_sql
  EXECUTE upd_omb92 USING m_oma.oma50,m_oma.oma50t,m_oma.oma54,
                          m_oma.oma54x,m_oma.oma54t,m_oma.oma56,
                          m_oma.oma56x,m_oma.oma56t,m_oma.oma56t,
                          m_oma.oma59,m_oma.oma59x,m_oma.oma59t
  IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
     CALL cl_err3("upd","oma_file",m_oma.oma01,"",SQLCA.sqlcode,"","upd oma:",0)   #No.FUN-660116
     LET g_success='N'
  ELSE
     LET p_oma.oma50  = m_oma.oma50  LET p_oma.oma50t = m_oma.oma50t
     LET p_oma.oma54  = m_oma.oma54  LET p_oma.oma54x = m_oma.oma54x
     LET p_oma.oma54t = m_oma.oma54t LET p_oma.oma56  = m_oma.oma56 
     LET p_oma.oma56x = m_oma.oma56x LET p_oma.oma56t = m_oma.oma56t
     LET p_oma.oma61  = m_oma.oma56t LET p_oma.oma59  = m_oma.oma59 
     LET p_oma.oma59x = m_oma.oma59x LET p_oma.oma59t = m_oma.oma59t 
  END IF
  #LET l_sql="SELECT omc01,omc02 FROM ",p_dbs," omc_file ", 
  LET l_sql="SELECT omc01,omc02 FROM ",cl_get_target_table(p_plant,'omc_file'), #FUN-A50102  
            " WHERE omc01='",m_oma.oma01,"'",
            " ORDER BY omc08 DESC "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
  PREPARE p861_prep97 FROM l_sql
  DECLARE p861_curs97 CURSOR FOR p861_prep97
  OPEN p861_curs97
  FETCH p861_curs97 INTO l_omc01,l_omc02 
  #LET l_sql = " UPDATE ",p_dbs," omc_file SET omc08 = ? ", 
  LET l_sql = " UPDATE ",cl_get_target_table(p_plant,'omc_file'), #FUN-A50102
              "    SET omc08 = ? ",   
              " ,omc09 = ? ",
              "  WHERE omc01 = '",l_omc01,"'",
              "    AND omc02 = '",l_omc02,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
  PREPARE upd_omb93 FROM l_sql
  EXECUTE upd_omb93 USING m_oma.oma54t,m_oma.oma56t
  IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
     CALL cl_err3("upd","omc_file",l_omc01,l_omc02,SQLCA.sqlcode,"","upd omc:",0)   
     LET g_success='N'
  END IF
END FUNCTION

#CHI-BC0008 add --start--
FUNCTION p861_up_apb(p_apa01) 
  DEFINE p_apa01 LIKE apa_file.apa01
  DEFINE m_apa  RECORD LIKE apa_file.*
  DEFINE m_apb  RECORD LIKE apb_file.*
  DEFINE diff_apb24  LIKE apb_file.apb24,
         diff_apb10  LIKE apb_file.apb10,
         s_apa31     LIKE apa_file.apa31,
         s_apa31f    LIKE apa_file.apa31f,
         l_apb10     LIKE apb_file.apb10,
         l_apb24     LIKE apb_file.apb24
  DEFINE l_cnt       LIKE type_file.num5    
 
  IF cl_null(p_apa01) THEN RETURN  END IF
  LET l_sql="SELECT * FROM ",cl_get_target_table( p_plant, 'apa_file' ),  
            " WHERE apa01='",p_apa01,"'"
  CALL cl_replace_sqldb(l_sql) RETURNING l_sql      
  CALL cl_parse_qry_sql( l_sql, p_plant ) RETURNING l_sql 
  PREPARE p861_prep82 FROM l_sql
  DECLARE p861_curs82 CURSOR FOR p861_prep82
  OPEN p861_curs82
  FETCH p861_curs82 INTO m_apa.*
  IF STATUS THEN 
     CALL cl_err3("sel","apa_file",p_apa01,"",STATUS,"","sel apa:",1) 
     RETURN  
  END IF
 
  IF m_apa.apa02<=g_apz.apz57 THEN CALL cl_err('','aap-176',0) RETURN  END IF
 
  IF (m_apa.apa00<> '11'  AND m_apa.apa00<> '21') 
       THEN RETURN  END IF
 
 
  LET l_sql="SELECT SUM(apb24),SUM(apb24*apa14) ",
            "  FROM ",cl_get_target_table( p_plant, 'apb_file' ),",", 
                      cl_get_target_table( p_plant, 'apa_file' ),     
            " WHERE apb01='",m_apa.apa01,"' AND apb01=apa01"
  CALL cl_replace_sqldb(l_sql) RETURNING l_sql        
  CALL cl_parse_qry_sql( l_sql, p_plant ) RETURNING l_sql 
  PREPARE p861_prep83 FROM l_sql
  DECLARE p861_curs83 CURSOR FOR p861_prep83
  OPEN p861_curs83
  FETCH p861_curs83 INTO l_apb24,l_apb10
 
  IF cl_null(l_apb24) THEN LET l_apb24 = 0 END IF
  IF cl_null(l_apb10) THEN LET l_apb10 = 0 END IF
  CALL cl_digcut(l_apb24,l_azi.azi04) RETURNING l_apb24
  CALL cl_digcut(l_apb10,s_azi.azi04) RETURNING l_apb10
 
  LET l_sql="SELECT  SUM(apb24),SUM(apb10)",
            "  FROM ",cl_get_target_table( p_plant, 'apb_file' ), 
            " WHERE apb01='",m_apa.apa01,"'"
  CALL cl_replace_sqldb(l_sql) RETURNING l_sql       
  CALL cl_parse_qry_sql( l_sql, p_plant ) RETURNING l_sql  
  PREPARE p861_prep84 FROM l_sql
  DECLARE p861_curs84 CURSOR FOR p861_prep84
  OPEN p861_curs84
  FETCH p861_curs84 INTO s_apa31f,s_apa31
 
  LET diff_apb24 = l_apb24 - s_apa31f  
  LET diff_apb10 = l_apb10 - s_apa31   
  
  IF diff_apb24 <> 0  OR diff_apb10 <> 0 THEN 
     LET l_sql="SELECT * FROM ",cl_get_target_table( p_plant, 'apb_file' ),  
               " WHERE apb01='",m_apa.apa01,"'",
               " ORDER BY  apb24 DESC "
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql        
     CALL cl_parse_qry_sql( l_sql, p_plant ) RETURNING l_sql 
     PREPARE p861_prep86 FROM l_sql
     DECLARE p861_curs86 CURSOR FOR p861_prep86
     FOREACH p861_curs86 INTO m_apb.* 
       IF SQLCA.SQLCODE <> 0 THEN EXIT FOREACH END IF
 
       #更新差異至單身最大筆
        LET l_sql = " UPDATE ",cl_get_target_table( p_plant, 'apb_file' )," SET apb24 = apb24+ ? ",  
                    " ,apb10 = apb10+ ? ,apb101 = apb101+ ? ",  
                    "  WHERE apb01 = '",m_apb.apb01,"'",
                    "    AND apb02 = '",m_apb.apb02,"'"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql       
        CALL cl_parse_qry_sql( l_sql, p_plant ) RETURNING l_sql 
        PREPARE upd_apb81 FROM l_sql
        EXECUTE upd_apb81 USING diff_apb24,diff_apb10,diff_apb10 
        IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err3("upd","apb_file",p_apa01,m_apb.apb02,SQLCA.sqlcode,"","upd apb:",1)   
           LET g_success='N'
        END IF
        EXIT FOREACH
     END FOREACH
   
     LET p_apa.apa31f = p_apa.apa31f + diff_apb24  
     LET p_apa.apa31  = p_apa.apa31  + diff_apb10 
     LET p_apa.apa34f = p_apa.apa34f + diff_apb24  
     LET p_apa.apa34  = p_apa.apa34  + diff_apb10 
     LET p_apa.apa73  = p_apa.apa73  + diff_apb10 
 
     #更新差異至單頭
     LET l_sql = " UPDATE ",cl_get_target_table( p_plant, 'apa_file' )," SET apa31 = ? ",
                 " ,apa34 = apa34+ ? ,apa31f = ? , apa34f = apa34f+ ?",
                 " ,apa57 = ? , apa57f = ?  , apa73 = apa73+ ? ",
                 "  WHERE apa01 = '",p_apa01,"'"
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql        
     CALL cl_parse_qry_sql( l_sql, p_plant ) RETURNING l_sql 
     PREPARE upd_apa92 FROM l_sql
     EXECUTE upd_apa92 USING l_apb10,diff_apb10,l_apb24,diff_apb24
                            ,l_apb10,l_apb24,diff_apb10
     IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
        CALL cl_err3("upd","apa_file",p_apa01,"",SQLCA.sqlcode,"","upd apa:",1)
        LET g_success='N'
     END IF 
  END IF
END FUNCTION
#CHI-BC0008 add --end--
#No:FUN-9C0071--------精簡程式-----
