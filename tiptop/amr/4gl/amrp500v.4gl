# Prog. Version..: '5.30.06-13.04.01(00010)'     #
#
# Pattern name...: amrp500.4gl
# Descriptions...: MRP 計劃模擬
# Date & Author..: 96/05/25 By Roger
# Modify.........: 03/04/21 By Jiunn (No.7087)
#                  a.併 MRP計劃模擬與 MRP計劃模擬限定版
#                  b.整組替代, 調整為僅納入來源料號一起考慮, 而不處理set替代
#                  c.行動日需考慮行事曆中的假日
#                  d.BOM表需發放才能納入考慮
#                  f.不指定廠牌時不應使用
#                  g.備品處理
#                  i.摸擬料號來源皆要考慮補貨策略(ima37)
#                  l.工單跳號範圍(amri400),原 5.Net Change 改為 6, 工單跳號範圍設為 5
# Modify.........: 03/05/17 By Jiunn (No.7264) 帶出指定廠版與限定版別
# Modify.........: No:7868 03/08/28 Carolfix 修改 2段SQL
# Modify.........: No:8060 03/09/04 By Mandy "        msa01 MATCHES '",lot_no2,"')",==>應判斷lot_no2不為null才可加上此條
# Modify.........: No:8021 03/10/06 By Melody 在計算工單量時,未考慮到報廢量sfa063
# Modify.........: No:9032 04/01/08 By Melody 原程式 p500_mss043() 未考慮已開工單且完工結案數量
# Modify.........: NO.MOD-490217 04/09/10 by yiting 料號欄位放大
# Modify.........: NO.MOD-4B0153 04/11/23 by ching _rep() i,j,k 不必再 DEFINE
# Modify.........: NO.MOD-4B0227 04/11/30 by Carol FUNCTION err中,要將IF (NOT cl_user()) THEN至IF (NOT cl_setup("AMR"))程式段MARK起來!
# Modify.........: NO.MOD-510004 05/01/04 by ching EF簽核納入
# Modify.........: NO.MOD-520060 05/02/24 by ching lot_no2 空白不組入sql
# Modify.........: NO.MOD-520074 05/02/25 by ching 替代計算修正
# Modify.........: NO.MOD-530636 05/03/28 by Carol 畫面處理取替代料選項無法將MRP版本條件帶入,
# Modify.........: No.FUN-550055 05/05/25 By Will 單據編號放大
# Modify.........: No.FUN-550110 05/05/26 By ching 特性BOM功能修改
# Modify.........: No.FUN-560011 05/06/06 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.FUN-560221 05/06/24 By Carol 單號 type 改為 VARCHAR(16)
# Modify.........: No.FUN-560230 05/06/27 By Melody QPA->DEC(16,8)
# Modify.........: No.MOD-580322 05/08/30 By wujie  中文資訊修改進 ze_file
# Modify.. ......: No.MOD-560165 05/09/13 By pengu MRP計算MPS段寫法不正確,會導僅選料號來源為MPS單號時,MPS才納入
# Modify.........: No.MOD-570011 05/09/13 By pengu  1.p500_mss065( ) 只要是要計算的料號皆應計算其計劃產量
                                           #        2.修改p500_mss065( ) 有關限定版本時的sql
                                           #        3.p500_mss043()只要是要計算的料號皆應計算其計劃備料量
# Modify.........: No.MOD-580098 05/09/13 By pengu  當限定版本送貨地址下'*'條件時，pmm10,pmk10為null的資料不會被納入
# Modify.........: No.MOD-580099 05/09/13 By pengu  p500_mss044的l_sql若sfa28為為0則會出現error:ora-01476
# Modify.........: No.FUN-5B0006 05/11/04 By Sarah 將lot_type選項6.net change取消(因為ima92目前為預留功能,前端無相關處理)
# Modify.........: No.MOD-5C0053 05/12/23 By Pengu 當二個料件互為替代料時,MRP之替代數量會因料號計算順序造成誤判
# Modify.........: No.FUN-5C0040 05/12/09 By Claire prompt 顯示沒有功能,取消
# Modify.........: NO.FUN-5C0001 06/01/06 by Yiting 加上是否顯示執行過程選項及cl_progress_bar()
# Modify.........: No:EXT-610004 06/01/16 By pengu 二個料件互為替代料時,MRP之替代數量會因料號計算順序造成誤判.
# Modify.........: No.MOD-640418 06/04/11 By pengu 修改amr-917錯誤訊息的顯示方式
# Modify.........: No.FUN-640169 06/04/18 By Sarah sw欄位請抓取、寫入msr09(是否顯示執行過程)
# Modify.........: No.MOD-640289 06/04/21 By pengu 當驗退單尚未輸入,或驗退單已輸入但尚未確認時,供給量會不見
# Modify.........: No.MOD-660035 06/06/12 By Pengu 當有交期調整時，交期調整的數據怪怪的
# Modify.........: No.FUN-660110 06/06/23 By Sarah 檔掉工單性質屬於試產性工單(sfb02='15')
# Modify.........: No.TQC-660123 06/06/26 By Clinton 日期調整
# Modify.........: No.TQC-670075 06/08/07 By Pengu 下階料展出時單位換算率統一抓BOM單位對庫存單位換算率
# Modify.........: No.MOD-680009 06/08/16 By Pengu S委外加工"件,應該要考慮交期提前天數
# Modify.........: No.FUN-680082 06/09/07 By Dxfwo  欄位類型定義-改為LIKE
# Modify.........: No.FUN-670074 06/09/07 By kim plp/plm 量應該要考慮單位小數取位 同asfi301 處理  (amsp500 也是要考慮)
# Modify.........: No.FUN-690047 06/09/27 By Sarah 抓取請購單、採購單資料時,需將pml38='Y',pmn38='Y'條件加入
# Modify.........: No.FUN-6A0012 06/10/16 By Sarah 算受訂量時，合約數量不納入(串oea_file的條件加上oea00<>'0')
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.CHI-690067 06/10/31 By pengu 在算"計劃生產量"時，沒有扣除已經轉工單且工單已結案的量
# Modify.........: No.TQC-6A0052 06/12/11 By Claire 計算MPS,MRP
# Modify.........: No.MOD-6B0010 06/12/11 By Claire 不調整 TQC-6A0052
# Modify.........: No.CHI-690066 06/12/13 By rainy CALL s_daywk() 要判斷未設定或非工作日
# Modify.........: No.MOD-6A0141 07/03/12 By pengu p500_mss045_c1 CURSOR未考慮BOM的特性代碼
# Modify.........: No.TQC-770031 07/07/05 By chenl 當來源選擇“5．指定工單”時，提示信息應由"請錄入料號"(amr-917)改為"請錄入模擬工單號"(amr-025)
# Modify.........: No.TQC-740336 07/07/23 By pengu MRP最終計算PLM/PLP量時如果是P件應該根據採購單位和庫存單位做一個換算
#                                                  再考慮最小採購量和採購批量
# Modify.........: No.MOD-780282 07/08/31 By Pengu CREATE TEMP TABLE時應先建INDEX在INSERT資料
# Modify.........: No.TQC-790091 07/09/17 By Mandy Primary Key的關係,原本SQLCA.sqlcode重複的錯誤碼-239，在informix不適用
# Modify.........: No.MOD-790125 07/09/26 By Pengu fz_flag不應該是define type_file.num10應該是varchar(1)
# Modify.........: No.MOD-7B0015 07/11/05 By Pengu 調整l_ima50變數的資料型態
# Modify.........: No.FUN-710073 07/11/30 By jamie 1.UI將 '天' -> '天/生產批量'
#                                                  2.將程式有用到 'XX前置時間'改為乘以('XX前置時間' 除以 '生產單位批量(ima56)')
# Modify.........: No.MOD-7C0165 07/12/25 By Pengu 調整TEMP TABLE欄位的資料型態
# Modify.........: No.CHI-810015 08/01/17 By jamie 將FUN-710073修改部份還原
# Modify.........: No.MOD-810148 08/03/04 By Pengu 受訂量不應排除"33.訂單出至境外倉"/"34.訂單境外倉出貨"這兩種
# Modify.........: No.MOD-810052 08/03/05 By Pengu 工單有作取替代,且替代率不為1時，則下階工單備料量會異常
# Modify.........: No.MOD-830020 08/03/20 By Pengu 計畫產量應排除已完工入庫量
# Modify.........: No.MOD-830012 08/03/20 By Pengu 計算MPS計畫備料量的需求日時，應用未開工單量去推算
# Modify.........: No.MOD-850310 08/05/30 by claire 工單未備(A)  = 應發 - 已發 -代買 + 下階料報廢 - 超領,若 A  < 0 ,則 LET A = 0
# Modify.........: No.FUN-840194 08/06/23 By sherry 增加變動前置時間批量（ima061）
# Modify.........: No.MOD-850022 08/07/13 By Pengu 計算計畫備料量時未扣除非上班日
# Modify.........: No.MOD-840702 08/07/13 By Pengu 訂單、採購單及收貨單取消分倉模擬限制
# Modify.........: No.MOD-850146 08/07/13 By Pengu 計算替代料時會異常
# Modify.........: No.MOD-860096 08/07/13 By Pengu 獨立需求應排除未確認貨已結案的單子
# Modify.........: No.CHI-860042 08/07/22 By xiaofeizhu 加入一般采購和委外采購的判斷
# Modify.........: No.CHI-7B0021 08/07/29 By sherry 備料_mss044也加入限定版本
# Modify.........: No.MOD-880201 08/08/25 By chenl  1、修正當替代料的低階碼小于被替代料時，造成替代料的交期調整量計算錯誤的問題。
# Modify.........:                                  2、修正中間階為虛擬料，且虛擬料的下階有替代料時，替代量無法計算的問題。
# Modify.........: No.MOD-8A0046 08/10/06 By chenyu 修改取l_gfe03的sql語句
# Modify.........: No.FUN-8B0035 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910 
# Modify.........: No.MOD-8C0021 08/12/02 By chenyu 修改MOD-8A0046,mps_file-->mss_file
# Modify.........: No.MOD-8B0259 09/01/15 By chenl  將函數p500_mss045()改為遞歸函數。
# Modify.........: No.MOD-910082 09/01/15 By Smapmin  誤判BOM的階數
# Modify.........: No.MOD-910232 09/01/21 By Smapmin MRP允許交期調整天數的調整要考慮ima08='T'的
# Modify.........: No.MOD-910231 09/01/22 By Smapmin 筆數要從1開始累計才對
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.MOD-8C0200 09/02/03 By Pengu 在驗量應該要依據廠商抓取對應的廠牌
# Modify.........: No.TQC-920066 09/02/10 By chenl p500_mss045()函數中未對l_ac賦值。
# Modify.........: No.FUN-920183 09/03/19 By shiwuying MRP功能改善
# Modify.........: No.MOD-930312 09/04/02 By Smapmin 工單取消分倉模擬限制
# Modify.........: No.MOD-940282 09/04/21 By Smapmin 判斷ima08=M的地方,都要多考慮ima08=S/T
# Modify.........: No.MOD-940312 09/04/23 By Smapmin 抓取庫存量時,要用SUM(img10*img21)
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.FUN-940083 09/05/14 By dxfwo   原可收量計算(pmn20-pmn50+pmn55)全部改為(pmn20-pmn50+pmn55+pmn58)
# Modify.........: No.MOD-940415 09/05/21 By Pengu "X"虛擬件會被滾算進MRP
# Modify.........: No.MOD-960044 09/06/08 By mike 變量使用錯誤
# Modify.........: No.MOD-960299 09/06/25 By mike 回圈中若有使用DISPLAY請MARK    
# Modify.........: No.MOD-970076 09/07/16 By Smapmin 只是要撈料件單位而已，不用去關聯mss_file.關聯的話，會造成傳回多筆.
# Modify.........: No.MOD-970079 09/07/16 By Smapmin 備料檔的投料時距應參考sfa09
# Modify.........: No.MOD-970095 09/07/24 By Smapmin 交期調整重複做了二次
#                                                    下階備料廠牌欄位改抓sfa36
# Modify.........: No.CHI-970070 09/08/11 By Smapmin 計算備料時以工單單身之發料與庫存換算率計算與發料單call s_umfchk不同，建議調整為同一標準。
# Modify.........: No.FUN-980004 09/08/12 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-960033 09/10/10 By chenmoyan 加pmh22為條件者，再加pmh23=''
# Modify.........: No.CHI-9A0021 09/10/15 By Lilan 將程式段多餘的DISPLAY給MARK
# Modify.........: No:FUN-9A0068 09/10/23 by dxfwo VMI测试结果反馈及相关调整
# Modify.........: No:TQC-9A0127 09/10/26 by xiaofeizhu 標準SQL修改
# Modify.........: No:TQC-960003 09/10/27 By Smapmin 重新過單
# Modify.........: No:TQC-9B0008 09/11/02 By Carrier SQL STANDARDIZE
# Modify.........: No.FUN-960110 09/11/13 By jan 模擬料號來源 加一項 7.指定訂單
# Modify.........: No.FUN-940048 09/11/13 By jan 加入批次背景處理功能
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No:MOD-9C0082 09/12/08 By Smapmin 增加變動前置時間批量(ima061)
# Modify.........: No:MOD-9C0233 09/12/19 By jan mstlegel-->mstlegal
# Modify.........: No.MOD-9C0278 09/12/19 By chenmoyan 當mst07為null時，則mst07=一個空白
# Modify.........: No.MOD-9C0337 09/12/22 By lilingyu p500_44_cl outer寫法有誤,造成mss_file/mst_file中看不到資料
# Modify.........: No:FUN-9C0121 09/12/29 By shiwuying MRP改善
# Modify.........: No:FUN-A10010 10/01/13 By Smapmin 原先CALL err()的錯誤訊息顯示方式,改為訊息匯總方式呈現
# Modify.........: No:FUN-A10070 10/01/13 By shiwuying 更改欄位判斷
# Modify.........: No.FUN-9C0073 10/01/18 By chenls 程序精簡
# Modify.........: No.FUN-A20037 10/03/02 By lilingyu MRP抓取替代資料時,增加抓取規則替代的資料
# Modify.........: No.TQC-A30021 10/03/05 By lilingyu 欄位incl_mds若為NULL,賦值N 
# Modify.........: No:MOD-A30082 10/03/12 By Sarah 當g_bgjob='N'時才做畫面的refresh
# Modify.........: No:MOD-A40010 10/04/02 By Sarah 程式裡用到bmb18計算日期，請使用s_aday()考慮工作日
# Modify.........: No:FUN-A40023 10/04/07 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造 
#                                                 成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No:MOD-A50163 10/05/25 By Sarah 供需日期範圍應卡edate輸入不可小於bdate
# Modify.........: No:MOD-A50207 10/05/31 By Sarah CURSOR p500_mss045_c2的產生段已被MOD-8B0259移除,後面的錯誤訊息檢查也應移除
# Modify.........: No:MOD-A60108 10/06/17 By Sarah 若訂單是須簽收(oea65=Y)的話,則受訂量(mss041)須扣除已打到axmt628且未過帳的數量 
# Modify.........: No:FUN-A70034 10/07/08 By Carrier 平行工艺-分量损耗运用
# Modify.........: No:MOD-A70183 10/07/23 By Sarah FOR迴圈的最大值改為抓Dynamic Array的長度
# Modify.........: No:MOD-A80205 10/09/16 By Summer 計算筆數時要加上distinct
# Modify.........: No:FUN-A80102 10/09/16 By kim GP5.25號機管理
# Modify.........: No:FUN-A90057 10/09/16 By kim GP5.25號機管理
# Modify.........: No:MOD-AA0050 10/10/11 By sabrina FUNCTION p500_mss044_bom()段抓取l_bma05的sql時，應加上"and bma06=p_key2"條件 
# Modify.........: No:CHI-AA0010 10/11/04 By Summer 版本編號輸入值不可有-(減號)
# Modify.........: No:MOD-AB0089 10/11/10 By zhangll add bmaacti control
# Modify.........: No:MOD-AC0084 10/12/10 By zhangll 展下阶料时除去失效的元件
# Modify.........: No:MOD-AC0126 10/11/15 By zhangll 計算在制量時增加考慮報廢量
# Modify.........: No:MOD-B10030 11/01/05 By sabrina 若走簽收則用訂單數量扣除未出貨量 
# Modify.........: No:MOD-B30174 11/03/15 By Pengu 替代量未考慮替代日期與時俱日期的合理性
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No:FUN-B20060 11/04/08 By zhangll 1.如果模拟料号来源是'4.料号'，且来源号码录入的*，则不需要CALL p500_bom1( )将下阶料展开插入到part_tmp中，直接从ima_file插入
#                                                    2.如果模拟料号来源是'4.料号'，且来源号码不是*，则应按BOM展开以及工单备料档收集料号（目前程序是按BOM展开），因为工单备料有可能不存在BOM中
#                                                    3.oeb15交货日期，改为用产品结构指定有效日期oeb72
#                                                    4.M件半成品,如果BOM中设置为"3,展开",就不应该再产生半成品需求，应同虚拟件一样直接展下阶需求
#                                                    5.增加今天之前明细需求汇总功能，画面增加list条件选项
# Modify.........: No:MOD-B60175 11/06/15 By sabrina 不管是否有與APS整合，皆NEXT FIELD msr11 
# Modify.........: No:MOD-B70066 11/07/17 By Vampire 將cl_outnam()移到FOREACH low_level_code前面
# Modify.........: No:MOD-B90031 11/09/05 By lilingyu 修改匯總MDS [_mss042_1()]的sql問題
# Modify.........: No:MOD-BC0133 11/12/13 By destiny 修正FUN-B20060_3将oeb72改为oeb15
# Modify.........: No:MOD-BC0226 11/12/22 By ck2yuan 因資料大l_sql會被截斷,故將l_sql格式設為STRING
# Modify.........: No:MOD-C10042 12/01/05 By ck2yuan 若msp10為反向 條件應該也是AND 
# Modify.........: No:MOD-C10057 12/01/06 By ck2yuan 更改p500_mss041內sql語法,使其考慮獨立需求單別的限定條件
# Modify.........: No:TQC-C20053 12/02/06 By lilingyu mss13字段沒賦值導致系統-391錯誤
# Modify.........: No:TQC-C20222 12/02/20 By xujing  增加p500_declare() 中 insert mst09 
# Modify.........: No:TQC-C20273 12/02/20 By xujing  調整FUNCTION p500_mss041()中 p500_rpc_c語法問題
# Modfiy.........: No:TQC-C20274 12/02/20 By xianghui update mss_file時添加mss13
# Modify.........: No:MOD-C50252 12/05/31 By Carrier 计算倍数时工式调整
# Modify.........: No:MOD-C50171 12/06/01 By ck2yuan 交期調整應考慮最小採購(製造)量及採購(製造)批量
# Modify.........: No:MOD-C80131 12/08/16 By suncx 1、更改MRP版本號，沒有根據MRP版本號更新畫面默認信息 2、版本號沒有開窗
# Modify.........: No:MOD-C80133 12/08/17 By ck2yuan 避免傳入p500_ins_part_tmp兩次導致progress bar出錯,故兩個sql union後一次傳
# Modify.........: No:MOD-C80241 12/08/30 By suncx 按顧問意見，只取所下來源號碼的計畫批號回填msr919
# Modify.........: No:CHI-C80002 12/09/28 By bart 改善效能 
# Modify.........: No:MOD-CA0138 12/10/26 By Elise 過濾拆件式工單
# Modify.........: No:CHI-C50068 12/11/06 By bart 客製回收:計算交期延後
# Modify.........: No:MOD-CC0229 12/12/25 By suncx 計算下階料PLM 备料數量時，沒有做上階主料的單位換算，導致下階料數量計算錯誤
# Modify.........: No:MOD-D10184 13/01/21 By bart 背景執行參數少了納入MDS需求(incl_mds)、MDS版本(msr11)兩個欄位
# Modify.........: No:CHI-C80041 13/02/06 By bart 排除作廢
# Modify.........: No:MOD-D20082 13/02/19 By bart insrt mst_file前判斷是否已存在
# Modify.........: No:CHI-D40027 13/07/08 By lixh1 還原FUN-B20060_4的修改

IMPORT os   #No.FUN-9C0009  
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE msr              RECORD LIKE msr_file.*
DEFINE msl              RECORD LIKE msl_file.*
DEFINE mss              RECORD LIKE mss_file.*
DEFINE mst              RECORD LIKE mst_file.*
DEFINE msa              RECORD LIKE msa_file.*
DEFINE msb              RECORD LIKE msb_file.*
DEFINE bma              RECORD LIKE bma_file.*
DEFINE bmb              RECORD LIKE bmb_file.*
DEFINE bmb1             RECORD LIKE bmb_file.*
DEFINE bmb2             RECORD LIKE bmb_file.*
DEFINE bmb3             RECORD LIKE bmb_file.*
DEFINE bmb4             RECORD LIKE bmb_file.*
DEFINE bmd              RECORD LIKE bmd_file.*
DEFINE bon              RECORD LIKE bon_file.*     #FUN-A20037 
DEFINE g_ima01          LIKE ima_file.ima01        #FUN-A20037
DEFINE rpc              RECORD LIKE rpc_file.*
DEFINE ver_no           LIKE mps_file.mps_v     #NO.FUN-680082  VARCHAR(2)
DEFINE lot_type         LIKE type_file.chr1     #NO.FUN-680082  VARCHAR(1)
DEFINE lot_bm           LIKE type_file.num5     #NO.FUN-680082  SMALLINT
DEFINE lot_no1          LIKE ima_file.ima01     #FUN-560221
DEFINE lot_no2          LIKE ima_file.ima01     #FUN-560221
DEFINE past_date        LIKE type_file.dat      #NO.FUN-680082  DATE
DEFINE bdate,edate      LIKE type_file.dat      #NO.FUN-680082  DATE
DEFINE buk_type         LIKE type_file.chr1     #NO.FUN-680082  VARCHAR(1)    # Bucket Type
DEFINE buk_code         LIKE rpg_file.rpg01     #NO.FUN-680082  VARCHAR(4)    # Bucket code
DEFINE po_days          LIKE type_file.num10    #NO.FUN-680082  INTEGER    # Reschedule days
DEFINE wo_days          LIKE type_file.num10    #NO.FUN-680082  INTEGER    # Reschedule days
DEFINE incl_id          LIKE type_file.chr1     #NO.FUN-680082  VARCHAR(1)
DEFINE incl_mds         LIKE msr_file.incl_mds  #No.FUN-920183
DEFINE msr10            LIKE msr_file.msr10     #No.FUN-920183
DEFINE msr11            LIKE msr_file.msr11     #No.FUN-920183
DEFINE incl_so          LIKE type_file.chr1     #NO.FUN-680082  VARCHAR(1)
DEFINE msb_expl         LIKE type_file.chr1     #NO.FUN-680082  VARCHAR(1)    # msb_file explosing flag
DEFINE mss_expl         LIKE type_file.chr1     #NO.FUN-680082  VARCHAR(1)    # mss_file explosing flag
DEFINE sub_flag         LIKE type_file.chr1     #NO.FUN-680082  VARCHAR(1)    #
DEFINE qvl_flag         LIKE type_file.chr1     #NO.FUN-680082  VARCHAR(1)    #
DEFINE qvl_bml03        LIKE type_file.num5     #NO.FUN-680082  SMALLINT
DEFINE list             LIKE type_file.chr1     #FUN-B20060_5 add
DEFINE sw               LIKE type_file.chr1     #NO.FUN-680082  VARCHAR(1)    #NO.FUN-5C0001 ADD
DEFINE g_msp01          LIKE msp_file.msp01
DEFINE g_c_sql          STRING  #NO.FUN-5C0001 add
DEFINE g_sql            string  #No.FUN-580092 HCN
DEFINE g_sql1           string  #No.FUN-580092 HCN
DEFINE g_sql2           string  #No.FUN-580092 HCN
DEFINE g_sql3           string  #No.FUN-580092 HCN
DEFINE g_sql4           string  #No.FUN-580092 HCN
DEFINE g_sql5           string  #No.FUN-580092 HCN
DEFINE g_count          LIKE type_file.num5     #NO.FUN-680082  SMALLINT   #NO.FUN-5C0001 ADD
DEFINE g_sw             LIKE type_file.num5     #NO.FUN-680082  SMALLINT   #NO.FUN-5C0001 ADD
DEFINE g_sw_cnt1        LIKE type_file.num5     #NO.FUN-680082  smallint   #NO.FUN-5C0001 ADD
DEFINE g_sw_cnt2        LIKE type_file.num5     #NO.FUN-680082  SMALLINT   #NO.FUN-5C0001 ADD
DEFINE g_sw_tot         LIKE type_file.num5     #NO.FUN-680082  SMALLINT   #NO.FUN-5C0001 ADD
DEFINE g_cnt1           LIKE type_file.num5     #NO.FUN-680082  SMALLINT   #NO.FUN-5C0001 ADD
DEFINE needdate         LIKE type_file.dat      #NO.FUN-680082  DATE       # MRP Need Date
DEFINE i,j,k            LIKE type_file.num10    #NO.FUN-680082  INTEGER
DEFINE m                LIKE type_file.num10    #CHI-C50068
#DEFINE g_qty,g_nopen   LIKE type_file.num10    #NO.FUN-680082  INTEGER
DEFINE g_qty,g_nopen    LIKE sfb_file.sfb08     #NO.FUN-680082  DEC(15,3)
DEFINE g_mss00          LIKE type_file.num10    #NO.FUN-680082  INTEGER
DEFINE g_mss01          LIKE mss_file.mss01     #NO.MOD-490217
DEFINE g_mss03          LIKE type_file.dat      #NO.FUN-680082  DATE
DEFINE g_mst03          LIKE type_file.dat      #NO.FUN-680082  DATE
DEFINE g_mst04          LIKE type_file.dat      #NO.FUN-680082  DATE
DEFINE g_mst06          LIKE mst_file.mst06     #FUN-560221
DEFINE g_mst061         LIKE mst_file.mst061    #FUN-560221
DEFINE g_mst07          LIKE mst_file.mst07     #NO.MOD-490217
DEFINE g_mst08          LIKE mst_file.mst08     #FUN-560221     #DEC(15,3)
DEFINE g_argv1          LIKE mps_file.mps_v     #NO.FUN-680082  VARCHAR(2)
DEFINE g_err_cnt        LIKE type_file.num10    #NO.FUN-680082  INTEGER
DEFINE g_n              LIKE type_file.num10    #NO.FUN-680082  INTEGER
DEFINE g_x_1            LIKE type_file.chr20    #NO.FUN-680082  VARCHAR(6)
DEFINE g_ima16          LIKE type_file.num10    #NO.FUN-680082  INTEGER
DEFINE g_sub_qty        LIKE mst_file.mst08     #NO.FUN-680082  DEC(15,3)
DEFINE fz_flag          LIKE type_file.chr1     #NO.FUN-680082  VARCHAR(1)   #No.MOD-790125 modify
DEFINE g_sfa01          LIKE sfa_file.sfa01     #FUN-560221
DEFINE g_sfb05          LIKE sfb_file.sfb05     #NO.MOD-490217
DEFINE g_sfb13          LIKE type_file.dat      #NO.FUN-680082  DATE
DEFINE g_eff_date       LIKE type_file.dat      #NO.FUN-680082  DATE
DEFINE g_before_input_done   STRING
DEFINE   g_i            LIKE type_file.num5     #NO.FUN-680082  SMALLINT   #count/index for any purpose
DEFINE   g_msg          LIKE type_file.chr1000  #NO.FUN-680082  VARCHAR(72)
DEFINE g_change_lang     LIKE type_file.chr1     #FUN-940048
DEFINE g_msr919         LIKE msr_file.msr919    #FUN-A90057
DEFINE list_date        LIKE type_file.dat      #FUN-B20060_5 add 用於計算時距日
DEFINE po_days1         LIKE type_file.num10    #CHI-C50068
DEFINE wo_days1         LIKE type_file.num10    #CHI-C50068

MAIN
#     DEFINE   l_time   LIKE type_file.chr8          #No.FUN-6A0076
  #DEFINE   p_row,p_col LIKE type_file.num5     #NO.FUN-680082  SMALLINT #FUN-940048
   DEFINE   l_flag    LIKE type_file.chr1       #FUN-940048
 
   OPTIONS
       INPUT NO WRAP,
       FIELD ORDER FORM
   DEFER INTERRUPT
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET ver_no = ARG_VAL(1)
   LET lot_type = ARG_VAL(2)
   LET lot_bm = ARG_VAL(3)
   LET lot_no1 = ARG_VAL(4)
   LET lot_no2 = ARG_VAL(5)
   LET bdate = ARG_VAL(6)
   LET edate = ARG_VAL(7)
   LET buk_type = ARG_VAL(8)
   LET buk_code = ARG_VAL(9)
   LET po_days = ARG_VAL(10)
   LET wo_days = ARG_VAL(11)
   LET po_days1 = ARG_VAL(12)  #CHI-C50068
   LET wo_days1 = ARG_VAL(13)  #CHI-C50068
   LET incl_id = ARG_VAL(14)
   LET incl_so = ARG_VAL(15)
   LET msb_expl = ARG_VAL(16)
   LET mss_expl = ARG_VAL(17)
   LET sub_flag = ARG_VAL(18)
   LET qvl_flag = ARG_VAL(19)
   LET list = ARG_VAL(20)  #FUN-B20060_5 add
   LET incl_mds = ARG_VAL(21)  #MOD-D10184
   LET msr11 = ARG_VAL(22)  #MOD-D10184
   LET sw = ARG_VAL(23)    #FUN-B20060_5 18->19
   LET g_msp01 = ARG_VAL(24) #FUN-B20060_5 19->20
   LET g_bgjob = ARG_VAL(25)  #FUN-B20060_5 20->21
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AMR")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
 
   WHILE TRUE
      LET g_success = 'Y'       #FUN-940048
      IF g_bgjob = 'N' THEN    #FUN-940048
         CALL p500_ask()
         IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
         IF cl_sure(18,20) THEN
            CALL cl_wait()
            CALL s_showmsg_init()   #FUN-A10010
            CALL p500_mrp()
            CALL s_showmsg()        #FUN-A10010
            CALL cl_end2(1) RETURNING l_flag
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p500_w
               EXIT WHILE
            END IF 
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         CALL s_showmsg_init()   #FUN-A10010
         CALL p500_mrp()
         CALL s_showmsg()        #FUN-A10010
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF    
   END WHILE
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
END MAIN
 
FUNCTION p500_wc_default()
   SELECT * INTO msr.* FROM msr_file WHERE msr_v=ver_no
   IF STATUS=0
      THEN LET lot_type=msr.lot_type
           LET lot_bm  =msr.lot_bm
           LET lot_no1 =msr.lot_no1
           LET lot_no2 =msr.lot_no2
           LET bdate   =msr.bdate
           LET edate   =msr.edate
           LET buk_type=msr.buk_type
           LET buk_code=msr.buk_code
           LET po_days =msr.po_days
           LET wo_days =msr.wo_days
           LET po_days1 =msr.msr13  #CHI-C50068
           LET wo_days1 =msr.msr14  #CHI-C50068
           LET incl_id =msr.incl_id
           LET incl_mds=msr.incl_mds     #No.FUN-920183
#TQC-A30021 --begin--
           IF cl_null(incl_mds) THEN
              LET incl_mds = 'N'
           END IF 
#TQC-A30021 --end--
           LET msr10   =msr.msr10        #No.FUN-920183
           LET msr11   =msr.msr11        #No.FUN-920183
           LET incl_so =msr.incl_so
           LET msb_expl=msr.msb_expl
           LET mss_expl=msr.mss_expl
            LET sub_flag=msr.msr06       #MOD-530636
           LET qvl_flag=msr.msr07
           IF cl_null(qvl_flag) THEN
              LET qvl_flag='N'
           END IF
           LET list =msr.msr12   #FUN-B20060_5 add
           LET sw =msr.msr09   #FUN-640169 add
           LET g_msp01 =msr.msr08
      ELSE LET lot_type='1'
           LET lot_bm  =99
           LET incl_mds  = 'N'   #TQC-A30021
           LET lot_no1 ='*'
           LET lot_no2 =NULL
           LET bdate   =TODAY
           LET edate   =TODAY+30
           LET buk_type=g_sma.sma22
           LET po_days =0
           LET wo_days =0
           LET po_days1 =0  #CHI-C50068
           LET wo_days1 =0  #CHI-C50068
           LET incl_id='Y'
           LET incl_so='Y'
           LET msb_expl='Y'
           LET mss_expl='Y'
           LET sub_flag='Y'
           LET qvl_flag='N'
           LET list    ='Y'   #FUN-B20060_5 add
           LET sw      ='Y'   #FUN-640169 add
   END IF
END FUNCTION
 
FUNCTION p500_declare()         # DECLARE Insert Cursor
   DEFINE l_sql         STRING  #LIKE type_file.chr1000  #NO.FUN-680082  VARCHAR(600)
 
   LET l_sql="INSERT INTO mst_file(mst_v, mst01, mst02, mst03, mst04, mst05, mst06, ",
                                 " mst061,mst06_fz,mst07,mst08,mstplant,mstlegal,mst09) ",  #MOD-9C0233  #TQC-C20222 mst09
                         " VALUES (?,?,?,?,?,?,?,?,?,?,?,?, ?,?)"                 #FUN-980004   #TQC-C20222 
   PREPARE p500_p_ins_mst FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_mst',STATUS,1) END IF
   DECLARE p500_c_ins_mst CURSOR WITH HOLD FOR p500_p_ins_mst
   IF STATUS THEN CALL cl_err('dec ins_mst',STATUS,1) END IF
 
##--  declare cursor for update mss_file --##
   LET l_sql="UPDATE mss_file SET mss041=mss041+?",
             " WHERE mss_v=?",
             "   AND mss01=? AND mss02=? AND mss03=?"
   PREPARE p500_p_upd_mss041 FROM l_sql
   IF STATUS THEN CALL cl_err('pre upd_mss041',STATUS,1) END IF
 
   LET l_sql="UPDATE mss_file SET mss043=mss043+?",
             " WHERE mss_v=?",
             "   AND mss01=? AND mss02=? AND mss03=?"
   PREPARE p500_p_upd_mss043 FROM l_sql
   IF STATUS THEN CALL cl_err('pre upd_mss043',STATUS,1) END IF
  #MOD-D20082---begin
   LET l_sql="UPDATE mss_file SET mss043=mss043-?",
             " WHERE mss_v=?",
             "   AND mss01=? AND mss02=? AND mss03=?"
   PREPARE p500_p_upd_mss043_2 FROM l_sql
   IF STATUS THEN CALL cl_err('pre upd_mss043_2',STATUS,1) END IF
  #MOD-D20082---end 
   LET l_sql="UPDATE mss_file SET mss044=mss044+?",
             " WHERE mss_v=?",
             "   AND mss01=? AND mss02=? AND mss03=?"
   PREPARE p500_p_upd_mss044 FROM l_sql
   IF STATUS THEN CALL cl_err('pre upd_mss044',STATUS,1) END IF
   
   LET l_sql="UPDATE mss_file SET mss051=mss051+?",
             " WHERE mss_v=?",
             "   AND mss01=? AND mss02=? AND mss03=?"
   PREPARE p500_p_upd_mss051 FROM l_sql
   IF STATUS THEN CALL cl_err('pre upd_mss051',STATUS,1) END IF
 
   LET l_sql="UPDATE mss_file SET mss052=mss052+?",
             " WHERE mss_v=?",
             "   AND mss01=? AND mss02=? AND mss03=?"
   PREPARE p500_p_upd_mss052 FROM l_sql
   IF STATUS THEN CALL cl_err('pre upd_mss052',STATUS,1) END IF
 
   LET l_sql="UPDATE mss_file SET mss053=mss053+?",
             " WHERE mss_v=?",
             "   AND mss01=? AND mss02=? AND mss03=?"
   PREPARE p500_p_upd_mss053 FROM l_sql
   IF STATUS THEN CALL cl_err('pre upd_mss053',STATUS,1) END IF
 
   LET l_sql="UPDATE mss_file SET mss061=mss061+?,mss06_fz=mss06_fz+?",
             " WHERE mss_v=?",
             "   AND mss01=? AND mss02=? AND mss03=?"
   PREPARE p500_p_upd_mss061 FROM l_sql
   IF STATUS THEN CALL cl_err('pre upd_mss061',STATUS,1) END IF
 
   LET l_sql="UPDATE mss_file SET mss062=mss062+?,mss063=mss063+?,",
                                 "mss06_fz=mss06_fz+?",
             " WHERE mss_v=?",
             "   AND mss01=? AND mss02=? AND mss03=?"
   PREPARE p500_p_upd_mss062 FROM l_sql
   IF STATUS THEN CALL cl_err('pre upd_mss062',STATUS,1) END IF
 
   LET l_sql="UPDATE mss_file SET mss064=mss064+?,mss06_fz=mss06_fz+?",
             " WHERE mss_v=?",
             "   AND mss01=? AND mss02=? AND mss03=?"
   PREPARE p500_p_upd_mss064 FROM l_sql
   IF STATUS THEN CALL cl_err('pre upd_mss064',STATUS,1) END IF
 
   LET l_sql="UPDATE mss_file SET mss065=mss065+?",
             " WHERE mss_v=?",
             "   AND mss01=? AND mss02=? AND mss03=?"
   PREPARE p500_p_upd_mss065 FROM l_sql
   IF STATUS THEN CALL cl_err('pre upd_mss065',STATUS,1) END IF
 
   LET l_sql="UPDATE mss_file SET mss_v   =? ,",
                                " mss00   =? ,",
                                " mss01   =? ,",
                                " mss02   =? ,",
                                " mss03   =? ,",
                                " mss041  =? ,",
                                " mss043  =? ,",
                                " mss044  =? ,",
                                " mss051  =? ,",
                                " mss052  =? ,",
                                " mss053  =? ,",
                                " mss061  =? ,",
                                " mss062  =? ,",
                                " mss063  =? ,",
                                " mss064  =? ,",
                                " mss065  =? ,",
                                " mss06_fz=? ,",
                                " mss071  =? ,",
                                " mss072  =? ,",
                                " mss08   =? ,",
                                " mss09   =? ,",
                                " mss10   =? ,",
                                " mss11   =? ,",
                                " mss12   =? ,",
                                " mssplant =?,", #FUN-980004 add
                                " msslegal =?,", #FUN-980004 add  #FUN-940048
                                " mss13   =?  ", #TQC-C20274
                          " WHERE mss_v = ? AND mss01 = ? ",
                          "   AND mss02 = ? AND mss03 = ? "
   PREPARE p500_p_upd_mss FROM l_sql
   IF STATUS THEN CALL cl_err('pre upd_mss',STATUS,1) END IF
 
END FUNCTION
 
FUNCTION p500_mrp()
   IF cl_null(g_msp01) THEN
     LET g_sql = ' '
     LET g_sql1= ' '
     LET g_sql2= ' '
     LET g_sql3= ' '
     LET g_sql4= ' '
     LET g_sql5= ' '
   ELSE
     CALL p500_get_sql()          # 限制條件(倉庫, 單別, 指交地址)
   END IF
   LET g_msr919 =  NULL         #FUN-A90057
   CALL p500_ins_msr1()         # 版本記錄 begin
   CALL p500_del()              # 將原資料(mss,mst,msl,msk)清除
   CALL p500_c_buk_tmp()        # 產生時距檔
   CALL p500_c_part_tmp()       # 找出需 MRP 的料號
   CALL p500_declare()          # DECLARE Insert Cursor
   OPEN p500_c_ins_mst
   IF STATUS THEN CALL cl_err('open ins_mst',STATUS,1) END IF
   IF cl_null(g_msp01) THEN
     CALL p500_mss040()         # 彙總 安全庫存量
     FLUSH p500_c_ins_mst  # 將insert mst_file 的 cursor 寫入 database
   END IF
   CALL p500_mss041()           # 彙總 獨立需求
   FLUSH p500_c_ins_mst    # 將insert mst_file 的 cursor 寫入 database
   CALL p500_mss042()           # 彙總 受訂量
   FLUSH p500_c_ins_mst    # 將insert mst_file 的 cursor 寫入 database
 
   CALL p500_mss042_1()    # 彙總 MDS需求                              #No.FUN-920183
   FLUSH p500_c_ins_mst    # 將insert mst_file 的 cursor 寫入 database #No.FUN-920183
 
   CALL p500_mss046()           # 彙總 備品
   FLUSH p500_c_ins_mst    # 將insert mst_file 的 cursor 寫入 database
   CALL p500_mss043()           # 彙總 計劃備(MPS計劃 下階料)
   FLUSH p500_c_ins_mst    # 將insert mst_file 的 cursor 寫入 database
   CALL p500_mss044()           # 彙總 工單備(實際工單下階料)
   FLUSH p500_c_ins_mst    # 將insert mst_file 的 cursor 寫入 database
   CALL p500_c_part_tmp2()      # 找出需 MRP 的料號+廠商
   CALL p500_mss051()           # ---> 庫存量
   FLUSH p500_c_ins_mst    # 將insert mst_file 的 cursor 寫入 database
   CALL p500_mss052()           # ---> 在驗量
   FLUSH p500_c_ins_mst    # 將insert mst_file 的 cursor 寫入 database
   CALL p500_mss061()           # ---> 請購量
   FLUSH p500_c_ins_mst    # 將insert mst_file 的 cursor 寫入 database
   CALL p500_mss062_63()        # ---> 採購量
   FLUSH p500_c_ins_mst    # 將insert mst_file 的 cursor 寫入 database
   CALL p500_mss064()           # ---> 在製量
   FLUSH p500_c_ins_mst    # 將insert mst_file 的 cursor 寫入 database
   CALL p500_mss065()           # ---> 計劃產
   FLUSH p500_c_ins_mst    # 將insert mst_file 的 cursor 寫入 database
   CALL p500_plan()             # 提出規劃建議
   CLOSE p500_c_ins_mst
   CALL p500_ins_msr2()         # 版本記錄結束
   #FUN-A90057(S)
   IF g_sma.sma1421='Y' THEN
      CALL p500_upd_msr919()    #更新計畫批號
   END IF
END FUNCTION
 
FUNCTION p500_ask()
  DEFINE l_n LIKE type_file.num5     #NO.FUN-680082  SMALLINT
   DEFINE l_vld03       LIKE vld_file.vld03
   DEFINE l_vld04       LIKE vld_file.vld04
   DEFINE l_vld06       LIKE vld_file.vld06
   DEFINE l_vld14       LIKE vld_file.vld14
   DEFINE l_cnt         LIKE type_file.num5
   DEFINE lot_type_t    LIKE msr_file.lot_type
  DEFINE   lc_cmd      LIKE type_file.chr1000  #FUN-940048
  DEFINE   p_row,p_col LIKE type_file.num5     #FUN-940048
  DEFINE l_str         STRING              #CHI-AA0010 add

   LET p_row = 2 LET p_col = 23
   OPEN WINDOW p500_w AT p_row,p_col
        WITH FORM "amr/42f/amrp500"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()

   CALL p500_set_ui() #FUN-A80102

WHILE TRUE
   LET ver_no  =''
   LET bdate   =NULL
   LET edate   =NULL
   LET g_bgjob = "N"
  INPUT BY NAME ver_no,lot_type,lot_bm,lot_no1,lot_no2,bdate,edate,
                buk_type,buk_code,po_days,wo_days,po_days1,wo_days1,  #CHI-C50068
                incl_id,incl_mds,msr10,msr11,incl_so,msb_expl,mss_expl, #No.FUN-920183
                sub_flag,qvl_flag,list,sw,g_msp01, #NO.FUN-5C0001  #FUN-B20060_5 add list
                g_bgjob   #FUN-940048
                WITHOUT DEFAULTS
     BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL p500_set_entry()
          CALL p500_set_no_entry()
          LET g_before_input_done = TRUE
          LET lot_type_t = lot_type          #No.FUN-920183
 
     AFTER FIELD ver_no
        IF ver_no IS NULL THEN NEXT FIELD ver_no END IF
        #CHI-AA0010 add --start--
        LET l_str =ver_no
        LET l_cnt = l_str.getIndexOf('-',1)
        IF l_cnt > 0 THEN
           CALL cl_err(ver_no,'amr-500',1)
           NEXT FIELD ver_no
        END IF
        #CHI-AA0010 add --end--
        #IF lot_type IS NULL THEN  #MOD-C80131 mark
           CALL p500_wc_default()
           DISPLAY BY NAME lot_type, lot_bm,   lot_no1 ,lot_no2  ,
                           bdate,    edate,
                           buk_type, buk_code,
                           po_days, wo_days,
                           po_days1, wo_days1,  #CHI-C50068
                           incl_id,incl_so,msb_expl,mss_expl,
                           incl_mds,msr10,msr11,             #No.FUN-920183 add
                           sub_flag, qvl_flag, list, sw, g_msp01   #FUN-640169 add sw  #FUN-B20060_5 add list
        #END IF   #MOD-C80131 mark
        LET msr10 = 'TP'    #No.FUN-9C0121 Add
          IF lot_type = '6' THEN
             CALL cl_set_comp_entry("lot_no1,lot_no2",FALSE)
          ELSE
             CALL cl_set_comp_entry("lot_no1,lot_no2",TRUE)
          END IF
     AFTER FIELD lot_type
        IF lot_type IS NULL THEN NEXT FIELD lot_type END IF
             CALL cl_qbe_init()
           IF lot_type = '6' THEN
              IF lot_type_t <> lot_type THEN
                 LET incl_mds = 'Y'
                 LET incl_so = 'N'
              END IF
              CALL cl_set_comp_entry("lot_no1,lot_no2",FALSE)
              CALL cl_set_comp_required("lot_no1",FALSE)
              LET lot_no1 = ''
              LET lot_no2 = ''
              DISPLAY BY NAME lot_no1,lot_no2
           ELSE
              IF lot_type_t <> lot_type THEN
                 LET incl_mds = 'N'
                 LET incl_so = 'Y'
              END IF
              CALL cl_set_comp_entry("lot_no1,lot_no2",TRUE)
              CALL cl_set_comp_required("lot_no1",TRUE)
           END IF
           DISPLAY BY NAME incl_mds,incl_so
           LET lot_type_t = lot_type
 
     BEFORE FIELD lot_no1
         CASE WHEN lot_type='1'  #ERROR "請輸入MPS計劃 編號!"
                   CALL cl_err('','amr-914','0')
              WHEN lot_type='2'  #ERROR "請輸入實際工單編號!"
                   CALL cl_err('','amr-915','0')
              WHEN lot_type='3'  #ERROR "請輸入訂單編號!"
                   CALL cl_err('','amr-916','0')
              WHEN lot_type='4'  #ERROR "請輸入料號!"
                   CALL cl_err('','amr-917','0')
              WHEN lot_type='5'  #ERROR "請輸入料號!"
                   CALL cl_err('','amr-025','0')
              WHEN lot_type='7'  #ERROR "請輸入訂單編號!"  #No.FUN-960110
                   CALL cl_err('','amr-916','0')           #No.FUN-960110
        END CASE
     AFTER FIELD lot_no1
     AFTER FIELD bdate
        IF bdate IS NULL THEN NEXT FIELD bdate END IF
     AFTER FIELD edate
        IF edate IS NULL THEN NEXT FIELD edate END IF
       #str MOD-A50163 add
        IF edate<bdate THEN
           CALL cl_err('','ams-820','0')
           NEXT FIELD edate
        END IF
       #end MOD-A50163 add
     BEFORE FIELD buk_type
        CALL p500_set_entry()
        
     AFTER FIELD buk_type
        CALL p500_set_no_entry()
        IF buk_type = '1' THEN
           CALL cl_set_comp_required("buk_code",TRUE)
        ELSE
           CALL cl_set_comp_required("buk_code",FALSE)
        END IF
     AFTER FIELD buk_code
        IF NOT cl_null(buk_code) THEN
           SELECT * FROM rpg_file WHERE rpg01 = buk_code
           IF STATUS THEN
              CALL cl_err('sel rpg:',STATUS,0) NEXT FIELD buk_code
           END IF
        END IF
     AFTER FIELD msb_expl
        IF msb_expl IS NULL THEN NEXT FIELD msb_expl END IF
     AFTER FIELD mss_expl
        IF mss_expl IS NULL THEN NEXT FIELD mss_expl END IF
 
 
        ON CHANGE incl_mds
           IF incl_mds = 'Y' AND incl_so = 'Y' THEN
              CALL cl_err('','amr-101',0)
              LET incl_so = 'N'
              DISPLAY BY NAME incl_mds,incl_so
           END IF

        ON CHANGE incl_so
           IF incl_mds = 'Y' AND incl_so = 'Y' THEN
              CALL cl_err('','amr-101',0)
              LET incl_mds = 'N'
              DISPLAY BY NAME incl_mds,incl_so
           END IF


        AFTER FIELD msr10,msr11
           IF NOT cl_null(msr10) AND NOT cl_null(msr11) THEN
              SELECT COUNT(*) INTO l_cnt
                FROM vld_file
               WHERE vld01 = msr10
                 AND vld02 = msr11
              IF l_cnt = 0 THEN
                 CALL cl_err('','amr-102',0)
                   #NEXT FIELD msr10     #MOD-B60175 mark
                    NEXT FIELD msr11     #MOD-B60175 add
              END IF
           END IF
 
     AFTER FIELD g_msp01
        IF NOT cl_null(g_msp01) THEN
          SELECT COUNT(*) INTO l_n FROM msp_file WHERE msp01 = g_msp01
          IF l_n=0 THEN
            CALL cl_err(g_msp01,100,0)
            NEXT FIELD g_msp01
          END IF
        END IF
     AFTER INPUT
        IF INT_FLAG THEN RETURN END IF
        IF NOT cl_null(g_msp01) THEN
           SELECT COUNT(*) INTO l_n FROM msp_file WHERE msp01 = g_msp01
           IF l_n=0 THEN
             CALL cl_err(g_msp01,100,0)
             NEXT FIELD g_msp01
           END IF
        END IF
        IF incl_mds = 'Y' AND (cl_null(msr10) OR cl_null(msr11)) THEN
           CALL cl_err('','amr-103',0)
           NEXT FIELD msr10
        END IF
        IF lot_type = '6' AND (cl_null(msr10) OR cl_null(msr11)) THEN
           CALL cl_err('','amr-103',0)
           NEXT FIELD msr10
        END IF
        IF cl_null(buk_code) AND buk_type = '1' THEN
           CALL cl_err('','amr-107',0)
           NEXT FIELD buk_code
        END IF
       #str MOD-A50163 add
        IF edate<bdate THEN
           CALL cl_err('','ams-820','0')
           NEXT FIELD bdate
        END IF
       #end MOD-A50163 add
     ON ACTION CONTROLP
           CASE
              #MOD-C80131 add begin---------------
              WHEN INFIELD(ver_no)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form="q_msr_v"
                 LET g_qryparam.default1 = ver_no
                 CALL cl_create_qry() RETURNING ver_no
                 DISPLAY BY NAME ver_no
                 NEXT FIELD ver_no
              #MOD-C80131 add end------------------
              WHEN INFIELD(msr10)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form="q_vld"
                 LET g_qryparam.default1 = msr10
                 LET g_qryparam.default2 = msr11
                 CALL cl_create_qry() RETURNING msr10,msr11
                 DISPLAY BY NAME msr10,msr11
                 NEXT FIELD msr10
              WHEN INFIELD(msr11)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form="q_vld"
                 LET g_qryparam.default1 = msr11
                 LET g_qryparam.default2 = msr11
                 CALL cl_create_qry() RETURNING msr10,msr11
                 DISPLAY BY NAME msr10,msr11
                 NEXT FIELD msr11
              WHEN INFIELD(buk_code)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form="q_rpg"
                 LET g_qryparam.default1 = buk_code
                 CALL cl_create_qry() RETURNING buk_code
                 DISPLAY BY NAME buk_code
                 NEXT FIELD buk_code
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
 
     ON ACTION locale                    #genero
        LET g_change_lang = TRUE    #FUN-940048
        CALL p500_set_ui()   #FUN-A80102
        EXIT INPUT                  #FUN-940048  
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
  END INPUT
  IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CLOSE WINDOW p500_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
  IF qvl_flag='Y'
     THEN LET qvl_bml03=1
     ELSE LET qvl_bml03=NULL
  END IF
  IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01 = "amrp500"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
         CALL cl_err('amrp500','9031',1)
      ELSE
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",ver_no CLIPPED,"'",
                      " '",lot_type CLIPPED,"'",
                      " '",lot_bm CLIPPED,"'",
                      " '",lot_no1 CLIPPED,"'",
                      " '",lot_no2 CLIPPED,"'",
                      " '",bdate CLIPPED,"'",
                      " '",edate CLIPPED,"'",
                      " '",buk_type CLIPPED,"'",
                      " '",buk_code CLIPPED,"'",
                      " '",po_days CLIPPED,"'",
                      " '",wo_days CLIPPED,"'",
                      " '",po_days1 CLIPPED,"'",  #CHI-C50068
                      " '",wo_days1 CLIPPED,"'",  #CHI-C50068
                      " '",incl_id CLIPPED,"'",
                      " '",incl_so CLIPPED,"'",
                      " '",msb_expl CLIPPED,"'",
                      " '",mss_expl CLIPPED,"'",
                      " '",sub_flag CLIPPED,"'",
                      " '",qvl_flag CLIPPED,"'",
                      " '",list CLIPPED,"'",  #FUN-B20060_5 add
                      " '",incl_mds CLIPPED,"'",  #MOD-D10184
                      " '",msr11 CLIPPED,"'",  #MOD-D10184
                      " '",sw CLIPPED,"'",
                      " '",g_msp01 CLIPPED,"'",
                      " '",g_bgjob CLIPPED,"'" 
         CALL cl_cmdat('amrp500',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p500_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
   EXIT WHILE
END WHILE
END FUNCTION
 
FUNCTION p500_set_entry()
   IF INFIELD(buk_type) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("buk_code",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION p500_set_no_entry()
   IF INFIELD(buk_type) OR (NOT g_before_input_done) THEN
      IF buk_type!='1' THEN
         LET buk_code = NULL
         DISPLAY BY NAME buk_code
         CALL cl_set_comp_entry("buk_code",FALSE)
      END IF
   END IF
 
END FUNCTION
 
 
FUNCTION p500_ins_msr1()
  DEFINE l_msr02   LIKE msr_file.msr02   #NO.FUN-680082  VARCHAR(8)
 
   CALL msg(" Start .....",'0')
   INITIALIZE msr.* TO NULL
   LET msr.msr_v    =ver_no
   LET msr.msr01    =TODAY
   LET l_msr02 = TIME
   LET msr.msr02    =l_msr02
   LET msr.msr05    =g_user
   LET msr.lot_type =lot_type
   LET msr.lot_bm   =lot_bm
   LET msr.lot_no1  =lot_no1
   LET msr.lot_no2  =lot_no2
   LET msr.bdate    =bdate
   LET msr.edate    =edate
   LET msr.buk_type =buk_type
   LET msr.buk_code =buk_code
   LET msr.po_days  =po_days
   LET msr.wo_days  =wo_days
   LET msr.msr13  =po_days1  #CHI-C50068
   LET msr.msr14  =wo_days1  #CHI-C50068
   LET msr.incl_id  =incl_id
   LET msr.incl_mds =incl_mds   #No.FUN-920183
   LET msr.msr10    =msr10      #No.FUN-920183
   LET msr.msr11    =msr11      #No.FUN-920183
   LET msr.incl_so  =incl_so
   LET msr.msb_expl =msb_expl
   LET msr.mss_expl =mss_expl
   LET msr.sub_flag =sub_flag
   LET msr.msr06    =sub_flag   #MOD-530636
   LET msr.msr07    =qvl_flag
   LET msr.msr12    =list  #FUN-B20060_5 add
   LET msr.msr09    =sw   #FUN-640169 add
   LET msr.msr08    =g_msp01
   DELETE FROM msr_file WHERE msr_v=ver_no
   IF STATUS THEN CALL err('del msr',STATUS,1) END IF
   INSERT INTO msr_file VALUES(msr.*)
   IF STATUS THEN CALL err('ins msr',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM END IF
END FUNCTION
 
FUNCTION p500_ins_msr2()
  DEFINE l_msr03    LIKE msr_file.msr03   #NO.FUN-680082  VARCHAR(8)
 
   CALL msg(" End .....",'0')
   LET l_msr03 = TIME
   LET msr.msr03=l_msr03
   LET msr.msr04=g_mss00
   UPDATE msr_file SET msr03=msr.msr03,
                       msr04=msr.msr04
    WHERE msr_v=ver_no
   IF STATUS THEN CALL err('upd msr',STATUS,1) END IF
   UPDATE sma_file SET sma21=TODAY WHERE sma00='0'
END FUNCTION
 
FUNCTION p500_del()
   CALL p500_del_mss()          # 將原資料(mss_file)清除
   CALL p500_del_mst()          # 將原資料(mst_file)清除
   CALL p500_del_msl()          # 將 Log  (msl_file)清除
   CALL p500_del_msk()          # 將時距日(msk_file)清除
END FUNCTION
 
FUNCTION p500_del_mss()
   DELETE FROM mss_file WHERE mss_v=ver_no
   IF STATUS THEN CALL err('del mss',STATUS,1) 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211  
     EXIT PROGRAM END IF
END FUNCTION
 
FUNCTION p500_del_mst()
   DEFINE l_mst_v     LIKE mst_file.mst_v  	#FUN-940048
   DEFINE l_mst01     LIKE mst_file.mst01 	#FUN-940048
   DEFINE l_mst02     LIKE mst_file.mst02 	#FUN-940048
   DEFINE l_mst03     LIKE mst_file.mst03 	#FUN-940048
   DEFINE l_mst04     LIKE mst_file.mst04 	#FUN-940048	
   DEFINE l_mst05     LIKE mst_file.mst05 	#FUN-940048	
   DEFINE l_mst06     LIKE mst_file.mst06 	#FUN-940048	
   DEFINE l_mst061    LIKE mst_file.mst061 	#FUN-940048
   DEFINE l_mst07     LIKE mst_file.mst07 	#FUN-940048

#FUN-A20037 --begin--
#   DECLARE del_mst_c CURSOR FOR
#      SELECT mst_v,mst01,mst02,mst03,mst04,mst05,mst06,mst061,mst07	 #FUN-940048
#        FROM mst_file WHERE mst_v=ver_no
#   FOREACH del_mst_c INTO l_mst_v,l_mst01,l_mst02,l_mst03,l_mst04,l_mst05,l_mst06,l_mst061,l_mst07	#FUN-940048
#     DELETE FROM mst_file WHERE mst_v = l_mst_v						   #FUN-940048
#                            AND mst01 = l_mst01	 AND mst02 = l_mst02   #FUN-940048
#                            AND mst03 = l_mst03	 AND mst04 = l_mst04   #FUN-940048
#                            AND mst05 = l_mst05	 AND mst06 = l_mst06   #FUN-940048
#                            AND mst061= l_mst061 AND mst07 = l_mst07   #FUN-940048
#     IF STATUS THEN CALL err('del mst',STATUS,1) EXIT PROGRAM END IF
#   END FOREACH
  
     DELETE FROM mst_file WHERE mst_v = ver_no  
     IF STATUS THEN CALL err('del mst',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
        EXIT PROGRAM END IF
#FUN-A20037 --end--   
END FUNCTION
 
FUNCTION p500_del_msl()
   DELETE FROM msl_file WHERE msl_v=ver_no
   IF STATUS THEN CALL err('del msl',STATUS,1) END IF
END FUNCTION
 
FUNCTION p500_del_msk()
   DELETE FROM msk_file WHERE msk_v=ver_no
   IF STATUS THEN CALL err('del msk',STATUS,1) END IF
END FUNCTION
 
FUNCTION p500_c_buk_tmp()       # 產生時距檔
  DEFINE d,d2   LIKE type_file.dat      #NO.FUN-680082  DATE
 
  #"產生時距檔(buk_tmp)!"
  LET g_msg=cl_getmsg('amr-010',g_lang)
 
  CALL msg(g_msg,'0')
 DROP TABLE buk_tmp
 
  CREATE TEMP TABLE buk_tmp(
    real_date LIKE type_file.dat,   
    plan_date LIKE type_file.dat)
 
  IF STATUS THEN
     CALL err('create buk_tmp:',STATUS,1) 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211 
     EXIT PROGRAM
  END IF
  CREATE INDEX buk_index ON buk_tmp(real_date)  #CHI-C80002
  
  CALL p500_list_date()   #计算list_date Add FUN-B20060_5
  CASE WHEN buk_type = '1' CALL rpg_buk() RETURN
       WHEN buk_type = '2' LET past_date = list_date-1  #FUN-B20060_5 bdate->list_date
       WHEN buk_type = '3' LET past_date = list_date-7  #FUN-B20060_5 bdate->list_date
       WHEN buk_type = '4' LET past_date = list_date-10 #FUN-B20060_5 bdate->list_date
       WHEN buk_type = '5' LET past_date = list_date-30 #FUN-B20060_5 bdate->list_date
       OTHERWISE           LET past_date = list_date-1  #FUN-B20060_5 bdate->list_date
  END CASE
  CALL p500_buk_date(past_date) RETURNING past_date
  FOR j = list_date TO edate  #FUN-B20060_5 bdate->list_date
     LET d=j
     CALL p500_buk_date(d) RETURNING d2
     INSERT INTO buk_tmp VALUES(d,d2)
     IF STATUS THEN CALL err('ins buk_tmp:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
        EXIT PROGRAM END IF
  END FOR
END FUNCTION
 
#Add FUN-B20060_5 --begin
#计算起始时距日基准 list_date
FUNCTION p500_list_date()
  DEFINE x      LIKE type_file.chr8

   IF list = 'N' AND bdate < g_today AND edate >= g_today THEN
      LET list_date = g_today
      #begin  以按周算为例,加此段则将本周今日之前的数值统计到本周时距日，否则将计入历史时距日
      #       若今日之前均计入历史时距日，而不需判断是否本周，则取消此段即可
      CASE 
           WHEN buk_type = '3' LET i=weekday(list_date) IF i=0 THEN LET i=7 END IF    #周
                               LET list_date = list_date - i + 1
           WHEN buk_type = '4' LET x = list_date USING 'yyyymmdd'   #旬
                               CASE WHEN x[7,8]<='10' LET x[7,8]='01'
                                    WHEN x[7,8]<='20' LET x[7,8]='11'
                                    OTHERWISE         LET x[7,8]='21'
                               END CASE
                               LET list_date = MDY(x[5,6],x[7,8],x[1,4])
           WHEN buk_type = '5' LET x = list_date USING 'yyyymmdd'   #月
                               LET x[7,8]='01'
                               LET list_date = MDY(x[5,6],x[7,8],x[1,4])
      END CASE
      IF list_date < bdate THEN
         LET list_date = bdate
      END IF
      #end
   ELSE
      LET list_date = bdate
   END IF

END FUNCTION
#FUN-B20060_5 --end

FUNCTION p500_buk_date(d)
  DEFINE d,d2   LIKE type_file.dat      #NO.FUN-680082  DATE
  DEFINE x      LIKE type_file.chr8     #NO.FUN-680082  VARCHAR(8)
  CASE WHEN buk_type = '3' LET i=weekday(d) IF i=0 THEN LET i=7 END IF
                           LET d2=d-i+1
       WHEN buk_type = '4' LET x = d USING 'yyyymmdd'
                           CASE WHEN x[7,8]<='10' LET x[7,8]='01'
                                WHEN x[7,8]<='20' LET x[7,8]='11'
                                OTHERWISE         LET x[7,8]='21'
                           END CASE
                           LET d2= MDY(x[5,6],x[7,8],x[1,4])
       WHEN buk_type = '5' LET x = d USING 'yyyymmdd'
                           LET x[7,8]='01'
                           LET d2= MDY(x[5,6],x[7,8],x[1,4])
       OTHERWISE           LET d2=d
  END CASE
  INSERT INTO msk_file(msk_v,msk_d) VALUES(ver_no, d2)
  RETURN d2
END FUNCTION
 
FUNCTION rpg_buk()
  DEFINE l_bucket ARRAY[36] OF LIKE type_file.num5     #NO.FUN-680082  SMALLINT
  DEFINE l_rpg    RECORD LIKE rpg_file.*
  DEFINE dd1,dd2  LIKE type_file.dat      #NO.FUN-680082  DATE
 
  SELECT * INTO l_rpg.* FROM rpg_file WHERE rpg01 = buk_code
  IF STATUS THEN CALL cl_err('sel rpg:',STATUS,1) RETURN END IF
 
  LET l_bucket[01]=l_rpg.rpg101 LET l_bucket[02]=l_rpg.rpg102
  LET l_bucket[03]=l_rpg.rpg103 LET l_bucket[04]=l_rpg.rpg104
  LET l_bucket[05]=l_rpg.rpg105 LET l_bucket[06]=l_rpg.rpg106
  LET l_bucket[07]=l_rpg.rpg107 LET l_bucket[08]=l_rpg.rpg108
  LET l_bucket[09]=l_rpg.rpg109 LET l_bucket[10]=l_rpg.rpg110
  LET l_bucket[11]=l_rpg.rpg111 LET l_bucket[12]=l_rpg.rpg112
  LET l_bucket[13]=l_rpg.rpg113 LET l_bucket[14]=l_rpg.rpg114
  LET l_bucket[15]=l_rpg.rpg115 LET l_bucket[16]=l_rpg.rpg116
  LET l_bucket[17]=l_rpg.rpg117 LET l_bucket[18]=l_rpg.rpg118
  LET l_bucket[19]=l_rpg.rpg119 LET l_bucket[20]=l_rpg.rpg120
  LET l_bucket[21]=l_rpg.rpg121 LET l_bucket[22]=l_rpg.rpg122
  LET l_bucket[23]=l_rpg.rpg123 LET l_bucket[24]=l_rpg.rpg124
  LET l_bucket[25]=l_rpg.rpg125 LET l_bucket[26]=l_rpg.rpg126
  LET l_bucket[27]=l_rpg.rpg127 LET l_bucket[28]=l_rpg.rpg128
  LET l_bucket[29]=l_rpg.rpg129 LET l_bucket[30]=l_rpg.rpg130
  LET l_bucket[31]=l_rpg.rpg131 LET l_bucket[32]=l_rpg.rpg132
  LET l_bucket[33]=l_rpg.rpg133 LET l_bucket[34]=l_rpg.rpg134
  LET l_bucket[35]=l_rpg.rpg135 LET l_bucket[36]=l_rpg.rpg136
  LET past_date=list_date-l_rpg.rpg101 #FUN-B20060_5 bdate->list_date
  INSERT INTO msk_file(msk_v,msk_d) VALUES(ver_no, past_date)
 
  LET dd1=list_date LET dd2=list_date  #FUN-B20060_5 bdate->list_date
  FOR i = 1 TO 36
     FOR j=1 TO l_bucket[i]
       INSERT INTO buk_tmp VALUES (dd1,dd2)
       LET dd1=dd1+1
     END FOR
     INSERT INTO msk_file(msk_v,msk_d) VALUES(ver_no, dd2)
     LET dd2=dd2+l_bucket[i]
  END FOR
END FUNCTION
 
FUNCTION p500_c_part_tmp()                      # 找出需 MRP 的料號
 #DEFINE l_sql          LIKE type_file.chr1000  #NO.FUN-680082  VARCHAR(3000   #MOD-BC0226 mark
  DEFINE l_sql          STRING                  #MOD-BC0226 add)
  DEFINE l_bmb03        LIKE bmb_file.bmb03     #NO.MOD-490217
  DEFINE l_sfa05        LIKE type_file.chr20    #NO.FUN-680082  VARCHAR(20)

  CREATE TEMP TABLE sub_tmp(
   sub_partno LIKE ima_file.ima01,     #No.MOD-7C0165 modify
   sub_wo_no  LIKE sfa_file.sfa01,
   sub_prodno LIKE type_file.chr1000,
   sub_qty    LIKE mps_file.mps041)

  CREATE INDEX sub_index ON sub_tmp(sub_partno,sub_wo_no,sub_prodno)  #CHI-C80002
  #"找出需 MRP 的料號檔(part_tmp)!"
  LET g_msg=cl_getmsg('amr-011',g_lang)
 
  CALL msg(g_msg,'0')
  DROP TABLE part_tmp
  CREATE TEMP TABLE part_tmp(
       partno LIKE ima_file.ima01)     #No.MOD-7C0165 modify
  IF STATUS THEN CALL err('create part_tmp:',STATUS,1) 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
     EXIT PROGRAM END IF
  CREATE UNIQUE INDEX part_tmp_i1 ON part_tmp(partno)
  IF STATUS THEN CALL err('index part_tmp:',STATUS,1) 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
     EXIT PROGRAM END IF
  CASE WHEN lot_type='1'
            IF sw = 'N' THEN
               #LET g_c_sql="SELECT COUNT(*)",  # 主件                    #MOD-A80205 mark 
                LET g_c_sql="SELECT COUNT(DISTINCT msb03)",  # 主件       #MOD-A80205 add 
                          "  FROM msa_file,msb_file,ima_file",
                          " WHERE (msa01 MATCHES '",lot_no1 CLIPPED,"'"
                IF NOT cl_null(lot_no2) THEN
                    LET g_c_sql = g_c_sql CLIPPED,
                                " OR msa01 MATCHES '",lot_no2 CLIPPED,"')"
                ELSE
                    LET g_c_sql = g_c_sql CLIPPED,')'
                END IF
                LET g_c_sql = g_c_sql CLIPPED,
                          "   AND msa03='N'",
                          "   AND msa05 <> 'X' ",  #CHI-C80041
                          "   AND msa01=msb01",
                          "   AND msb03=ima_file.ima01 AND ima37='2'"  #MOD-6B0010
                PREPARE p500_sw_p1 FROM g_c_sql
                DECLARE p500_sw_c1 CURSOR FOR p500_sw_p1
                OPEN p500_sw_c1
                FETCH p500_sw_c1 INTO g_sw_cnt1
 
                IF lot_bm>0 THEN
                   #LET g_c_sql="SELECT COUNT(*)",  # 下階料                #MOD-A80205 mark   
                    LET g_c_sql="SELECT COUNT(DISTINCT msb03)",  # 下階料   #MOD-A80205 add 
                              "  FROM msa_file,msb_file,bmb_file,ima_file",
                              " WHERE (msa01 MATCHES '",lot_no1 CLIPPED,"'"
                    IF NOT cl_null(lot_no2) THEN
                        LET g_c_sql = g_c_sql CLIPPED,
                                    " OR msa01 MATCHES '",lot_no2 CLIPPED,"')"
                    ELSE
                        LET g_c_sql = g_c_sql CLIPPED,')'
                    END IF
                    LET g_c_sql = g_c_sql CLIPPED,
                              "   AND msa03='N'",
                              "   AND msa05 <> 'X' ",  #CHI-C80041
                              "   AND msa01=msb01",
                              "   AND msb03=bmb01",
                              "   AND bmb04<=msb07",
                              "   AND (bmb05 IS NULL OR bmb05>msb07)",
                              "   AND bmb03 IS NOT NULL",
                              "   AND bmb03=ima01 AND ima37 ='2'"  #  #MOD-6B0010
                    PREPARE p500_sw_p2 FROM g_c_sql
                    DECLARE p500_sw_c2 CURSOR FOR p500_sw_p2
                    OPEN p500_sw_c2
                    FETCH p500_sw_c2 INTO g_sw_cnt2
                END IF
                LET g_sw_tot = g_sw_cnt1 + g_sw_cnt2
                IF g_sw_tot > 0 THEN
                    IF g_sw_tot > 10 THEN
                        LET g_sw = g_sw_tot /10
                        CALL cl_progress_bar(10)
                    ELSE
                        CALL cl_progress_bar(g_sw_tot)
                    END IF
                END IF
            END IF
 
            LET l_sql="SELECT DISTINCT msb03",  # 主件
                      "  FROM msa_file,msb_file,ima_file",
                      " WHERE (msa01 MATCHES '",lot_no1 CLIPPED,"'"
            IF NOT cl_null(lot_no2) THEN
                LET l_sql = l_sql CLIPPED,
                            " OR msa01 MATCHES '",lot_no2 CLIPPED,"')"
            ELSE
                LET l_sql = l_sql CLIPPED,')'
            END IF
            LET l_sql = l_sql CLIPPED,
                      "   AND msa03='N'",
                      "   AND msa05 <> 'X' ",  #CHI-C80041
                      "   AND msa01=msb01",
                      "   AND msb03=ima_file.ima01 AND ima37 ='2'"  #MOD-6B0010 modify
           #CALL p500_ins_part_tmp(l_sql)i                               #MOD-C80133 mark 
           #IF lot_bm=0 THEN EXIT CASE END IF                            #MOD-C80133 mark
           #LET l_sql="SELECT DISTINCT bmb03",  # 下階料                 #MOD-C80133 mark
            IF lot_bm<>0 THEN                                            #MOD-C80133 add
               LET l_sql=l_sql,"UNION SELECT DISTINCT bmb03",  # 下階料  #MOD-C80133 add
                         "  FROM msa_file,msb_file,bmb_file,ima_file",
                         " WHERE (msa01 MATCHES '",lot_no1 CLIPPED,"'"
               IF NOT cl_null(lot_no2) THEN
                   LET l_sql = l_sql CLIPPED,
                               " OR msa01 MATCHES '",lot_no2 CLIPPED,"')"
               ELSE
                   LET l_sql = l_sql CLIPPED,')'
               END IF
               LET l_sql = l_sql CLIPPED,
                         "   AND msa03='N'",
                         "   AND msa05 <> 'X' ",  #CHI-C80041
                         "   AND msa01=msb01",
                         "   AND msb03=bmb01",
                         "   AND bmb04<=msb07",
                         "   AND (bmb05 IS NULL OR bmb05>msb07)",
                         "   AND bmb03 IS NOT NULL",
                         "   AND bmb03=ima01 AND ima37 ='2'"  #MOD-6B0010 
            END IF                                            #MOD-C80133 add
            CALL p500_ins_part_tmp(l_sql)
       WHEN lot_type='2'
            IF sw = 'N' THEN
               #LET g_c_sql="SELECT COUNT(*)",  # 主件                    #MOD-A80205 mark 
                LET g_c_sql="SELECT COUNT(DISTINCT sfb05)",  # 主件       #MOD-A80205 add 
                          "  FROM sfb_file,ima_file",
                          " WHERE (sfb01 MATCHES '",lot_no1 CLIPPED,"'"
                IF NOT cl_null(lot_no2) THEN
                    LET g_c_sql = g_c_sql CLIPPED,
                                " OR sfb01 MATCHES '",lot_no2 CLIPPED,"')"
                ELSE
                    LET g_c_sql = g_c_sql CLIPPED,')'
                END IF
                LET g_c_sql = g_c_sql CLIPPED,
                          "   AND sfb04 < '8' AND sfb87 <> 'X'",
                          "   AND sfb05=ima01 AND ima37 ='2'",  #MOD-6B0010 
                          "   AND sfb02!='15'"   #FUN-660110 add
                PREPARE p500_sw_p3 FROM g_c_sql
                DECLARE p500_sw_c3 CURSOR FOR p500_sw_p3
                OPEN p500_sw_c3
                FETCH p500_sw_c3 INTO g_sw_cnt1
 
                IF lot_bm>0 THEN
                   #LET g_c_sql="SELECT COUNT(*) FROM sfa_file,sfb_file,ima_file",                   #MOD-A80205 mark    
                    LET g_c_sql="SELECT COUNT(DISTINCT sfb05) FROM sfa_file,sfb_file,ima_file",      #MOD-A80205 add 
                              " WHERE (sfb01 MATCHES '",lot_no1 CLIPPED,"'"
                    IF NOT cl_null(lot_no2) THEN
                        LET g_c_sql = g_c_sql CLIPPED,
                                " OR sfb01 MATCHES '",lot_no2 CLIPPED,"')"
                    ELSE
                        LET g_c_sql = g_c_sql CLIPPED,')'
                    END IF
                    LET g_c_sql = g_c_sql CLIPPED,
                                "   AND sfa05 IS NOT NULL AND sfb87 <> 'X'",
                                "   AND sfa01=sfb01 AND sfa05>sfa06 AND sfb04 <'8'",
                                "   AND sfa03=ima01 AND ima37 ='2'",  #MOD-6B0010 
                                "   AND sfb02!='15'"   #FUN-660110 add
                    PREPARE p500_sw_p4 FROM g_c_sql
                    DECLARE p500_sw_c4 CURSOR FOR p500_sw_p4
                    OPEN p500_sw_c4
                    FETCH p500_sw_c4 INTO g_sw_cnt2
                END IF
                LET g_sw_tot = g_sw_cnt1 + g_sw_cnt2
                IF g_sw_tot > 0 THEN
                    IF g_sw_tot > 10 THEN
                        LET g_sw = g_sw_tot /10
                        CALL cl_progress_bar(10)
                    ELSE
                        CALL cl_progress_bar(g_sw_tot)
                    END IF
                 END IF
            END IF
 
            LET l_sql="SELECT DISTINCT sfb05",  # 主件
                      "  FROM sfb_file,ima_file",
                      " WHERE (sfb01 MATCHES '",lot_no1 CLIPPED,"'" 
            IF NOT cl_null(lot_no2) THEN
                LET l_sql = l_sql CLIPPED,
                            " OR sfb01 MATCHES '",lot_no2 CLIPPED,"')"
            ELSE
                LET l_sql = l_sql CLIPPED,')'
            END IF
            LET l_sql = l_sql CLIPPED,
                      "   AND sfb04 < '8' AND sfb87 <> 'X'",
                      "   AND sfb05=ima01 AND ima37 ='2'",  #MOD-6B0010 
                      "   AND sfb02!='15'"   #FUN-660110 add
           #CALL p500_ins_part_tmp(l_sql)                                                         #MOD-C80133 mark  
           #IF lot_bm=0 THEN EXIT CASE END IF                                                     #MOD-C80133 mark  
            # 下階料
           #LET l_sql="SELECT DISTINCT sfa03 FROM sfa_file,sfb_file,ima_file",                    #MOD-C80133 mark
            IF lot_bm<>0 THEN                                                                     #MOD-C80133 add
               LET l_sql=l_sql," UNION SELECT DISTINCT sfa03 FROM sfa_file,sfb_file,ima_file",    #MOD-C80133 add
                         " WHERE (sfb01 MATCHES '",lot_no1 CLIPPED,"'" 
               IF NOT cl_null(lot_no2) THEN
                   LET l_sql = l_sql CLIPPED,
                               " OR sfb01 MATCHES '",lot_no2 CLIPPED,"')"
               ELSE
                   LET l_sql = l_sql CLIPPED,')'
               END IF
               LET l_sql = l_sql CLIPPED,
                         "   AND sfa05 IS NOT NULL AND sfb87 <> 'X'",
                         "   AND sfa01=sfb01 AND sfa05>sfa06 AND sfb04 < '8'",
                         "   AND sfa03=ima01 AND ima37 ='2'",  #MOD-6B0010 
                         "   AND sfb02!='15'"   #FUN-660110 add
            END IF                              #MOD-C80133 add
            CALL p500_ins_part_tmp(l_sql)
       WHEN lot_type='3'
            IF sw = 'N' THEN
               #LET g_c_sql="SELECT COUNT(*)",  # 主件                    #MOD-A80205 mark 
                LET g_c_sql="SELECT COUNT(DISTINCT oeb04)",  # 主件       #MOD-A80205 add 
                          "  FROM oeb_file, oea_file, ima_file",
                          " WHERE (oeb01 MATCHES '",lot_no1 CLIPPED,"'"
                IF NOT cl_null(lot_no2) THEN
                    LET g_c_sql = g_c_sql CLIPPED,
                                " OR oeb01 MATCHES '",lot_no2 CLIPPED,"')"
                ELSE
                    LET g_c_sql = g_c_sql CLIPPED,')'
                END IF
                LET g_c_sql = g_c_sql CLIPPED,
                          "   AND oeb12>oeb24",
                          "   AND oeb70='N'",
                          "   AND oeb01=oea01 AND oeaconf='Y'",
                          "   AND oeb04=ima01 AND ima37 ='2'",  #MOD-6B0010 
                          "   AND oea00<>'0'"   #FUN-6A0012 add
                PREPARE p500_sw_p5 FROM g_c_sql
                DECLARE p500_sw_c5 CURSOR FOR p500_sw_p5
                OPEN p500_sw_c5
                FETCH p500_sw_c5 INTO g_sw_cnt1
 
                LET g_sw_tot = g_sw_cnt1
                IF g_sw_tot > 0 THEN
                    IF g_sw_tot > 10 THEN
                        LET g_sw = g_sw_tot /10
                        CALL cl_progress_bar(10)
                    ELSE
                        CALL cl_progress_bar(g_sw_tot)
                    END IF
                 END IF
            END IF
 
            LET l_sql="SELECT DISTINCT oeb04",  # 主件
                      "  FROM oeb_file, oea_file, ima_file",
                      " WHERE (oeb01 MATCHES '",lot_no1 CLIPPED,"'"
            IF NOT cl_null(lot_no2) THEN
                LET l_sql = l_sql CLIPPED,
                            " OR oeb01 MATCHES '",lot_no2 CLIPPED,"')"
            ELSE
                LET l_sql = l_sql CLIPPED,')'
            END IF
            LET l_sql = l_sql CLIPPED,
                      "   AND oeb12>oeb24",
                      "   AND oeb70='N'",
                      "   AND oeb01=oea01 AND oeaconf='Y'",
                      "   AND oeb04=ima01 AND ima37 ='2'",  #MOD-6B0010 
                      "   AND oea00<>'0'"   #FUN-6A0012 add
            CALL p500_ins_part_tmp(l_sql)
       WHEN lot_type='4'
            IF sw = 'N' THEN
               #LET g_c_sql="SELECT COUNT(*)",  # 主件                    #MOD-A80205 mark 
                LET g_c_sql="SELECT COUNT(DISTINCT ima01)",  # 主件       #MOD-A80205 add 
                          "  FROM ima_file",
                          " WHERE ima37 ='2'",   #MOD-6B0010
                          "   AND imaacti='Y'",
                          "   AND (ima01 MATCHES '",lot_no1 CLIPPED,"'"
                IF NOT cl_null(lot_no2) THEN
                    LET g_c_sql = g_c_sql CLIPPED,
                                " OR ima01 MATCHES '",lot_no2 CLIPPED,"')"
                ELSE
                    LET g_c_sql = g_c_sql CLIPPED,')'
                END IF
                PREPARE p500_sw_p6 FROM g_c_sql
                DECLARE p500_sw_c6 CURSOR FOR p500_sw_p6
                OPEN p500_sw_c6
                FETCH p500_sw_c6 INTO g_sw_cnt1
 
                LET g_sw_tot = g_sw_cnt1
                IF g_sw_tot > 0 THEN
                    IF g_sw_tot > 10 THEN
                        LET g_sw = g_sw_tot /10
                        CALL cl_progress_bar(10)
                    ELSE
                        CALL cl_progress_bar(g_sw_tot)
                    END IF
                END IF
            END IF
 
            LET l_sql="SELECT DISTINCT ima01",  # 主件
                      "  FROM ima_file",
                      " WHERE ima37 = '2'",  #MOD-6B0010 
                      "   AND imaacti='Y'",
                      "   AND (ima01 MATCHES '",lot_no1 CLIPPED,"'"
            IF NOT cl_null(lot_no2) THEN
                LET l_sql = l_sql CLIPPED,
                            " OR ima01 MATCHES '",lot_no2 CLIPPED,"')"
            ELSE
                LET l_sql = l_sql CLIPPED,')'
            END IF
            CALL p500_ins_part_tmp(l_sql)
       WHEN lot_type='5'       # 工單跳號
            IF sw = 'N' THEN
               #LET g_c_sql="SELECT COUNT(*)",  # 主件                    #MOD-A80205 mark 
                LET g_c_sql="SELECT COUNT(DISTINCT sfb05)",  # 主件       #MOD-A80205 add 
                          "  FROM sfb_file,msf_file,ima_file",
                          " WHERE sfb01=msf02",
                          "   AND (msf01 MATCHES '",lot_no1 CLIPPED,"'"
                IF NOT cl_null(lot_no2) THEN
                    LET g_c_sql = g_c_sql CLIPPED,
                                " OR msf01 MATCHES '",lot_no2 CLIPPED,"')"
                ELSE
                    LET g_c_sql = g_c_sql CLIPPED,')'
                END IF
                LET g_c_sql = g_c_sql CLIPPED,
                          "   AND sfb04 < '8' AND sfb87 <> 'X'",
                          "   AND sfb05=ima01 AND ima37 = '2'",   #MOD-6B0010
                          "   AND sfb02!='15'"   #FUN-660110 add
                PREPARE p500_sw_p7 FROM g_c_sql
                DECLARE p500_sw_c7 CURSOR FOR p500_sw_p7
                OPEN p500_sw_c7
                FETCH p500_sw_c7 INTO g_sw_cnt1
 
                IF lot_bm>0 THEN
                   #LET g_c_sql="SELECT COUNT(*)",                     #MOD-A80205 mark
                    LET g_c_sql="SELECT COUNT(DISTINCT sfb05)",        #MOD-A80205 add
                              "  FROM sfa_file,sfb_file,msf_file,ima_file",
                              " WHERE sfb01=msf02",
                              "   AND (msf01 MATCHES '",lot_no1 CLIPPED,"'"
                    IF NOT cl_null(lot_no2) THEN
                        LET g_c_sql = g_c_sql CLIPPED,
                              " OR msf01 MATCHES '",lot_no2 CLIPPED,"')"
                    ELSE
                        LET g_c_sql = g_c_sql CLIPPED,')'
                    END IF
                    LET g_c_sql = g_c_sql CLIPPED,
                              "   AND sfa05 IS NOT NULL AND sfb87 <> 'X'",
                              "   AND sfa01=sfb01 AND sfa05>sfa06 AND sfb04 < '8'",
                              "   AND sfa03=ima01 AND ima37 = '2'",  #MOD-6B0010 mark
                              "   AND sfb02!='15'"   #FUN-660110 add
                    PREPARE p500_sw_p8 FROM g_c_sql
                    DECLARE p500_sw_c8 CURSOR FOR p500_sw_p8
                    OPEN p500_sw_c8
                    FETCH p500_sw_c8 INTO g_sw_cnt2
                END IF
                LET g_sw_tot = g_sw_cnt1 + g_sw_cnt2
                IF g_sw_tot > 0 THEN
                    IF g_sw_tot > 10 THEN
                        LET g_sw = g_sw_tot /10
                        CALL cl_progress_bar(10)
                    ELSE
                        CALL cl_progress_bar(g_sw_tot)
                    END IF
                END IF
            END IF
 
            LET l_sql="SELECT DISTINCT sfb05",  # 主件
                      "  FROM sfb_file,msf_file,ima_file",
                      " WHERE sfb01=msf02",
                      "   AND (msf01 MATCHES '",lot_no1 CLIPPED,"'"
            IF NOT cl_null(lot_no2) THEN
                LET l_sql = l_sql CLIPPED,
                            " OR msf01 MATCHES '",lot_no2 CLIPPED,"')"
            ELSE
                LET l_sql = l_sql CLIPPED,')'
            END IF
            LET l_sql = l_sql CLIPPED,
                      "   AND sfb04 < '8' AND sfb87 <> 'X'",
                      "   AND sfb05=ima01 AND ima37 = '2'",   #MOD-6B0010 
                      "   AND sfb02!='15'"   #FUN-660110 add
           #CALL p500_ins_part_tmp(l_sql)                         #MOD-C80133 mark 
           #IF lot_bm=0 THEN EXIT CASE END IF                     #MOD-C80133 mark 
            # 下階料
           #LET l_sql="SELECT DISTINCT sfa03",                    #MOD-C80133 mark
            IF lot_bm<>0 THEN                                     #MOD-C80133 add
               LET l_sql=l_sql," UNION SELECT DISTINCT sfa03",    #MOD-C80133 add
                         "  FROM sfa_file,sfb_file,msf_file,ima_file",
                         " WHERE sfb01=msf02",
                         "   AND (msf01 MATCHES '",lot_no1 CLIPPED,"'"
               IF NOT cl_null(lot_no2) THEN
                   LET l_sql = l_sql CLIPPED,
                               " OR msf01 MATCHES '",lot_no2 CLIPPED,"')"
               ELSE
                   LET l_sql = l_sql CLIPPED,')'
               END IF
               LET l_sql = l_sql CLIPPED,
                         "   AND sfa05 IS NOT NULL AND sfb87 <> 'X'",
                         "   AND sfa01=sfb01 AND sfa05>sfa06 AND sfb04 < '8'",
                         "   AND sfa03=ima01 AND ima37 = '2'",  #MOD-6B0010 
                         "   AND sfb02!='15'"   #FUN-660110 add
            END IF                              #MOD-C80133 add
            CALL p500_ins_part_tmp(l_sql)
       
       WHEN lot_type='7'
            IF sw = 'N' THEN
               #LET g_c_sql="SELECT COUNT(*)",  # 主件                    #MOD-A80205 mark 
                LET g_c_sql="SELECT COUNT(DISTINCT oeb04)",  # 主件       #MOD-A80205 add 
                          "  FROM oeb_file, oea_file, ima_file,msj_file",
                          " WHERE oeb01=msj02 ",
                          "   AND (msj01 MATCHES '",lot_no1 CLIPPED,"'"

                IF NOT cl_null(lot_no2) THEN
                    LET g_c_sql = g_c_sql CLIPPED,
                                " OR msj01 MATCHES '",lot_no2 CLIPPED,"')"
                ELSE
                    LET g_c_sql = g_c_sql CLIPPED,')'
                END IF
                LET g_c_sql = g_c_sql CLIPPED,
                          "   AND oeb12>oeb24",
                          "   AND oeb70='N'",
                          "   AND oeb01=oea01 AND oeaconf='Y'",
                          "   AND oeb04=ima01 AND ima37 ='2'",
                          "   AND oea00<>'0'"
                PREPARE p500_sw_p9 FROM g_c_sql
                DECLARE p500_sw_c9 CURSOR FOR p500_sw_p9
                OPEN p500_sw_c9
                FETCH p500_sw_c9 INTO g_sw_cnt1

                LET g_sw_tot = g_sw_cnt1
                IF g_sw_tot > 0 THEN
                    IF g_sw_tot > 10 THEN
                        LET g_sw = g_sw_tot /10
                        CALL cl_progress_bar(10)
                    ELSE
                        CALL cl_progress_bar(g_sw_tot)
                    END IF
                 END IF
            END IF

            LET l_sql="SELECT DISTINCT oeb04",  # 主件
                      "  FROM oeb_file, oea_file,msj_file,ima_file",
                      " WHERE oeb01 = msj02 ",
                      "   AND (msj01 MATCHES '",lot_no1 CLIPPED,"'"
            IF NOT cl_null(lot_no2) THEN
                LET l_sql = l_sql CLIPPED,
                            " OR msj01 MATCHES '",lot_no2 CLIPPED,"')"
            ELSE
                LET l_sql = l_sql CLIPPED,')'
            END IF

            LET l_sql = l_sql CLIPPED,
                      "   AND oeb12>oeb24",
                      "   AND oeb70='N'",
                      "   AND oeb01=oea01 AND oeaconf='Y'",
                      "   AND oeb04=ima01 AND ima37 ='2'",
                      "   AND oea00<>'0'"
            CALL p500_ins_part_tmp(l_sql)
      WHEN lot_type = '6'
           LET l_sql = " SELECT DISTINCT vmu23 ",
                       "   FROM vmu_file ",
                       "  WHERE vmu01 = '",msr10,"'",
                       "    AND vmu02 = '",msr11,"'"
           CALL p500_ins_part_tmp(l_sql)
  END CASE
END FUNCTION
 
FUNCTION p500_ins_part_tmp(p_sql)
   DEFINE p_sql         LIKE type_file.chr1000  #NO.FUN-680082  VARCHAR(3000)
   DEFINE l_ima08       LIKE type_file.chr1     #NO.FUN-680082  VARCHAR(1)
   DEFINE l_partno      LIKE oeo_file.oeo04   #NO.MOD-490217
   DEFINE l_ima910      LIKE ima_file.ima910   #FUN-550110
   DEFINE l_sql         STRING  #CHI-C80002
   
   LET p_sql = p_sql CLIPPED
   PREPARE p500_ins_tmp_p FROM p_sql
   DECLARE p500_ins_tmp_c CURSOR FOR p500_ins_tmp_p

   #CHI-C80002---begin
   LET l_sql = " INSERT INTO part_tmp VALUES(?) "
   PREPARE p500_ins_part_p1 FROM l_sql
   #CHI-C80002---end
   
   LET g_n=0
   LET g_count = 1 #NO.FUN-5C0001 ADD
   FOREACH p500_ins_tmp_c INTO l_partno
     IF STATUS THEN CALL err('ins_tmp_c:',STATUS,1)
         CALL cl_close_progress_bar() #NO.FUN-5C0001 ADD
         EXIT FOREACH
     END IF
     LET g_cnt1 = g_cnt1 + 1
     IF sw = 'Y' THEN
        IF g_bgjob = 'N' THEN   #MOD-A30082 add
           message l_partno
           CALL ui.Interface.refresh()
        END IF   #MOD-A30082 add
     END IF
     #INSERT INTO part_tmp VALUES(l_partno)  #CHI-C80002
     EXECUTE p500_ins_part_p1 USING l_partno  #CHI-C80002
     LET g_n=g_n+1 LET g_x_1=g_n USING '&&&&&&'
     IF g_x_1[5,6]='00' THEN
        IF g_bgjob = 'N' THEN   #MOD-A30082 add
           MESSAGE g_n
           CALL ui.Interface.refresh()
        END IF   #MOD-A30082 add
     END IF
     LET l_ima910=''
     SELECT ima910 INTO l_ima910 FROM ima_file WHERE ima01=l_partno
     IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF
     #--
     IF NOT (lot_type='4' AND (lot_no1 = '*' OR (lot_no2 IS NOT NULL AND lot_no2 = '*'))) THEN   #FUN-B20060_1 add
        IF lot_bm>0 THEN
           CALL p500_bom1(0,l_partno,l_ima910)  #FUN-550110
        END IF
     END IF    #FUN-B20060_1 add
     #FUN-B20060_2 add 工单备料收集料号
     IF lot_type='4' AND NOT((lot_no1 = '*' OR (lot_no2 IS NOT NULL AND lot_no2 = '*'))) THEN 
        CALL p500_workno(l_partno)
     END IF
     #FUN-B20060_2 add--end
     IF sw = 'N' THEN
        IF g_cnt1 <= g_sw_tot THEN #MOD-A80205 add
           IF g_sw_tot > 10 THEN  #筆數合計
               IF g_count = 10 AND g_cnt1= g_sw_tot THEN
                   CALL cl_progressing(" ")
               END IF
               IF (g_cnt1 mod g_sw) = 0 AND g_count < 10 THEN
                   CALL cl_progressing(" ")
                   LET g_count = g_count +1
               END IF
           ELSE
               CALL cl_progressing(" ")
           END IF
        END IF #MOD-A80205 add
     END IF
 
   END FOREACH
   IF STATUS THEN CALL err('ins_tmp_c:',STATUS,1) END IF
   DECLARE p500_ins_tmp_oeo CURSOR FOR
    SELECT oeo04 FROM part_tmp,ima_file,oeb_file,oea_file,oeo_file,oay_file
     WHERE oea01=oeb01 AND oeb01=oeo01 AND oeb03=oeo03
       AND oeo08='2' AND oeaconf='Y' AND oeb04=partno
       AND oea00<>'0'   #FUN-6A0012 add
      #AND oeb12>oeb24 AND oeb72 <= edate AND oeb70='N'  #FUN-B20060_3 oeb15->oeb72 #MOD-BC0133
       AND oeb12>oeb24 AND oeb15 <= edate AND oeb70='N'  #MOD-BC0133
#       AND oeo04=ima01 AND oeb01[1,3]=oayslip
       AND oeo04=ima01 AND oeb01 like oayslip || '-%'  #No.FUN-550055
       AND (oaytype <> '33' AND oaytype <> '34')
       AND imaacti='Y' AND ima37 = '2'  #MOD-6B0010 
   FOREACH p500_ins_tmp_oeo INTO l_partno
     IF STATUS THEN CALL cl_err('fore ins_tmp_oeo',STATUS,1) EXIT FOREACH END IF
     #INSERT INTO part_tmp VALUES(l_partno)  #CHI-C80002
     EXECUTE p500_ins_part_p1 USING l_partno  #CHI-C80002
     LET g_n=g_n+1 LET g_x_1=g_n USING '&&&&&&'
     IF g_x_1[5,6]='00' THEN
        IF g_bgjob = 'N' THEN   #MOD-A30082 add
           MESSAGE g_n
           CALL ui.Interface.refresh()
        END IF   #MOD-A30082 add
     END IF
   END FOREACH
   IF STATUS THEN CALL cl_err('fore ins_tmp_oeo',STATUS,1) END IF
   IF sub_flag='N' THEN RETURN END IF
   DECLARE p500_ins_tmp_set CURSOR FOR
    SELECT bob04 FROM part_tmp, bob_file, ima_file
     WHERE partno=bob01 AND bob04=ima01
       AND imaacti='Y' AND ima37 = '2'  #MOD-6B0010 
       AND bob10 <= edate AND (bob11 IS NULL OR bob11 > bdate)
   FOREACH p500_ins_tmp_set INTO l_partno
     IF STATUS THEN CALL cl_err('fore ins_tmp_set',STATUS,1) EXIT FOREACH END IF
     #INSERT INTO part_tmp VALUES(l_partno)  #CHI-C80002
     EXECUTE p500_ins_part_p1 USING l_partno  #CHI-C80002
     LET g_n=g_n+1 LET g_x_1=g_n USING '&&&&&&'
     IF g_x_1[5,6]='00' THEN
        IF g_bgjob = 'N' THEN   #MOD-A30082 add
           MESSAGE g_n
           CALL ui.Interface.refresh()
        END IF   #MOD-A30082 add
     END IF
   END FOREACH
   IF STATUS THEN CALL cl_err('fore ins_tmp_set',STATUS,1) END IF

   DECLARE p500_ins_tmp_c2 CURSOR FOR
     SELECT bmd04 FROM part_tmp, bmd_file, ima_file
           WHERE partno=bmd01 AND bmd04=ima01
             AND imaacti='Y' AND ima37 = '2'  #MOD-6B0010 
             AND bmd05<=edate AND (bmd06 IS NULL OR bmd06 > bdate)
             AND bmdacti = 'Y'                                           #CHI-910021
   FOREACH p500_ins_tmp_c2 INTO l_partno
     IF STATUS THEN CALL cl_err('fore ins_tmp_c2',STATUS,1) EXIT FOREACH END IF
     #INSERT INTO part_tmp VALUES(l_partno)  #CHI-C80002
     EXECUTE p500_ins_part_p1 USING l_partno  #CHI-C80002
     LET g_n=g_n+1 LET g_x_1=g_n USING '&&&&&&'
     IF g_x_1[5,6]='00' THEN
        IF g_bgjob = 'N' THEN   #MOD-A30082 add
           MESSAGE g_n
           CALL ui.Interface.refresh()
        END IF   #MOD-A30082 add
     END IF
   END FOREACH
   IF STATUS THEN CALL cl_err('fore ins_tmp_c2',STATUS,1) END IF
   
#FUN-A20037 --begin--
 DECLARE p500_ins_tmp_c3 CURSOR FOR 
 SELECT DISTINCT ima01 from ima_file,bon_file,bmb_file,part_tmp
  WHERE imaacti = 'Y' and ima37 = '2'
    AND partno = bon01 
    AND bmb03 = bon01 AND bmb16 = '7'
	  AND (bmb01 = bon02 or bon02 = '*') 
    AND bon09<=edate AND (bon10 IS NULL OR bon10 > bdate)
    AND bonacti = 'Y'
    AND ima251 = bon06
    AND ima022 BETWEEN bon04 AND bon05
    AND ima109 = bon07 
    AND ima54 = bon08 
    AND ima01 != bon01   	
                              
   FOREACH p500_ins_tmp_c3 INTO l_partno
     IF STATUS THEN 
        CALL cl_err('fore ins_tmp_c3',STATUS,1) 
        EXIT FOREACH 
     END IF
     DELETE FROM part_tmp WHERE partno = l_partno
     #INSERT INTO part_tmp VALUES(l_partno)  #CHI-C80002
     EXECUTE p500_ins_part_p1 USING l_partno  #CHI-C80002
     
     LET g_n=g_n+1 LET g_x_1=g_n USING '&&&&&&'
     IF g_x_1[5,6]='00' THEN
        IF g_bgjob = 'N' THEN   #MOD-A30082 add
           CALL ui.Interface.refresh()
        END IF   #MOD-A30082 add
     END IF
   END FOREACH
   IF STATUS THEN 
      CALL cl_err('fore ins_tmp_c3',STATUS,1) 
   END IF
#FUN-A20037 --end--   
END FUNCTION
 
FUNCTION p500_bom1(p_level,p_key,p_key2)  #FUN-550110
   DEFINE p_level     LIKE type_file.num5,    #NO.FUN-680082  SMALLINT
          p_key       LIKE bma_file.bma01,    #主件料件編號
          p_key2      LIKE ima_file.ima910,   #FUN-550110
          l_ac,i      LIKE type_file.num5,    #NO.FUN-680082  SMALLINT
          arrno       LIKE type_file.num5,    #NO.FUN-680082  SMALLINT     #BUFFER SIZE (可存筆數)
          sr DYNAMIC ARRAY OF RECORD          #每階存放資料
              bmb03 LIKE bmb_file.bmb03,      #元件料號
              bma01 LIKE bma_file.bma01,
              bma05 LIKE bma_file.bma05
          END RECORD,
          l_msg       LIKE type_file.chr1000, #NO.FUN-680082  VARCHAR(40)
          l_sql       LIKE type_file.chr1000  #NO.FUN-680082  VARCHAR(800)
    DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0035 
    DEFINE l_bmaacti   LIKE bma_file.bmaacti  #Add No.MOD-AB0089
 
    IF p_level > 20 THEN CALL cl_err('','mfg2733',1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
       EXIT PROGRAM END IF
    LET p_level = p_level + 1
    IF p_level > lot_bm THEN RETURN END IF
    #Add No.MOD-AB0089
    SELECT bmaacti INTO l_bmaacti
      FROM bma_file
     WHERE bma01 = p_key
       AND bma06 = p_key2
    IF cl_null(l_bmaacti) OR l_bmaacti='N' THEN
       RETURN
    END IF
    #End Add No.MOD-AB0089
    #CHI-C80002---begin
    LET l_sql= "INSERT INTO part_tmp VALUES(?) "
    PREPARE p500_ins_part_p3 FROM l_sql
    #CHI-C80002---end
    LET arrno = 600
    LET l_sql= "SELECT bmb03,bma01,bma05",
               "  FROM ima_file,bmb_file LEFT OUTER JOIN bma_file ON bmb03 = bma01",            #TQC-9A0127 Add 
               " WHERE bmb01='", p_key,"' ",                                                    #TQC-9A0127 Add
               "   AND bmb29 ='",p_key2,"' ",  #FUN-550110
               "   AND bmb04 <= '",edate,"' AND (bmb05 IS NULL OR bmb05 > '",bdate,"') ",  #Add No:MOD-AC0084
               "   AND bmb03=ima01 AND ima37 = '2'"   #MOD-6B0010 
    PREPARE p500_ppp FROM l_sql
    DECLARE p500_cur CURSOR FOR p500_ppp
    LET l_ac = 1
    FOREACH p500_cur INTO sr[l_ac].*  # 先將BOM單身存入BUFFER
       IF STATUS THEN CALL cl_err('fore p500_cur:',STATUS,1) EXIT FOREACH END IF
       LET l_ima910[l_ac]=''                                                                                                        
       SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03                                                   
       IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF                                                                
       LET l_ac = l_ac + 1                    # 但BUFFER不宜太大
       IF l_ac > arrno THEN EXIT FOREACH END IF
    END FOREACH
    IF STATUS THEN CALL cl_err('fore p500_cur:',STATUS,1) END IF
    FOR i = 1 TO l_ac-1               # 讀BUFFER傳給REPORT
        IF sw = 'Y' THEN
           IF g_bgjob = 'N' THEN   #MOD-A30082 add
              message p_level,' ',sr[i].bmb03 clipped
              CALL ui.Interface.refresh()
           END IF   #MOD-A30082 add
        END IF
        #INSERT INTO part_tmp VALUES(sr[i].bmb03)  #CHI-C80002
        EXECUTE p500_ins_part_p3 USING sr[i].bmb03  #CHI-C80002
        IF STATUS THEN CONTINUE FOR END IF
        LET g_n=g_n+1 LET g_x_1=g_n USING '&&&&&&'
        IF g_x_1[5,6]='00' THEN
           IF g_bgjob = 'N' THEN   #MOD-A30082 add
              MESSAGE g_n
              CALL ui.Interface.refresh()
           END IF   #MOD-A30082 add
        END IF
        IF sr[i].bma01 IS NOT NULL THEN
            IF cl_null(sr[i].bma05) THEN
               CALL cl_getmsg('amr-001',g_lang) RETURNING l_msg
               LET g_msg = sr[i].bma01,l_msg clipped
               CALL msg(g_msg,'amr-001')
               CONTINUE FOR
            END IF
           CALL p500_bom1(p_level,sr[i].bmb03,l_ima910[i])  #FUN-8B0035
        END IF
    END FOR
END FUNCTION

#FUN-B20060_2 add 工单备料收集料号
FUNCTION p500_workno(p_key)
DEFINE p_key       LIKE bma_file.bma01     #成品料件編號
DEFINE l_sql       STRING
DEFINE l_sfa03     LIKE sfa_file.sfa03

    #CHI-C80002---begin
    LET l_sql= "INSERT INTO part_tmp VALUES(?) "
    PREPARE p500_ins_part_p2 FROM l_sql
    #CHI-C80002---end
    LET l_sql= "SELECT sfa03 ",
               "  FROM sfb_file,sfa_file ",
               " WHERE sfb01=sfa01 ",
               "   AND sfb04 < '8'",
               "   AND sfb13<='",edate,"'",
               "   AND sfb23='Y' AND sfb87 <> 'X'",  #已備料工單 (取備料檔)
               "   AND sfb02!='15'",
               "   AND sfb05='", p_key,"' "

    PREPARE p500_ppp2 FROM l_sql
    DECLARE p500_cur2 CURSOR FOR p500_ppp2
    FOREACH p500_cur2 INTO l_sfa03
       IF STATUS THEN CALL cl_err('fore p500_cur2:',STATUS,1) EXIT FOREACH END IF
       IF sw = 'Y' THEN
          IF g_bgjob = 'N' THEN
             message l_sfa03 clipped
             CALL ui.Interface.refresh()
          END IF
       END IF
       #INSERT INTO part_tmp VALUES(l_sfa03)  #CHI-C80002
       EXECUTE p500_ins_part_p2 USING l_sfa03  #CHI-C80002
       IF STATUS THEN CONTINUE FOREACH END IF
       LET g_n=g_n+1 LET g_x_1=g_n USING '&&&&&&'
       IF g_x_1[5,6]='00' THEN
          IF g_bgjob = 'N' THEN
             MESSAGE g_n
             CALL ui.Interface.refresh()
          END IF
       END IF
    END FOREACH
    IF STATUS THEN CALL cl_err('fore p500_cur2:',STATUS,1) END IF

END FUNCTION
#FUN-B20060_2 add--end
 
FUNCTION p500_mss_0()   # mss_file 歸 0
   LET mss.mss_v =ver_no
   LET mss.mss041=0
   LET mss.mss043=0
   LET mss.mss044=0
   LET mss.mss051=0
   LET mss.mss052=0
   LET mss.mss053=0
   LET mss.mss061=0
   LET mss.mss062=0
   LET mss.mss063=0
   LET mss.mss064=0
   LET mss.mss065=0
   LET mss.mss06_fz=0
   LET mss.mss071=0
   LET mss.mss072=0
   LET mss.mss08 =0
   LET mss.mss09 =0
   LET mss.mss10 ='N'
   LET mss.mss11 =NULL
END FUNCTION
 
FUNCTION p500_mss040()  #  ---> 安全庫存需求
 
  #"_mss040(彙總安全庫存需求)!"
  LET g_msg=cl_getmsg('amr-012',g_lang)
 
  CALL msg(g_msg,'0')
   DECLARE p500_ima27_c CURSOR FOR
      SELECT ima01, ima27 FROM ima_file,part_tmp
       WHERE ima01=partno AND ima27 > 0
   CALL p500_mss_0()
   FOREACH p500_ima27_c INTO mss.mss01, mss.mss041
     IF STATUS THEN CALL err('p500_ima27_c',STATUS,1) RETURN END IF
     LET mss.mss02='-'
     LET mss.mss03=past_date
     IF mss.mss041 IS NULL THEN LET mss.mss041=0 END IF
     LET mss.mssplant=g_plant   #FUN-980004 add
     LET mss.msslegal=g_legal   #FUN-980004 add

#TQC-C20053 --begin--
    IF cl_null(mss.mss13) THEN
      LET mss.mss13 = 'N'
    END IF 
#TQC-C20053 --begin--

     INSERT INTO mss_file VALUES(mss.*)
     IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN 
         CALL cl_err('ins mss:',SQLCA.SQLCODE,1) 
     END IF

     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #TQC-790091 mod
        EXECUTE p500_p_upd_mss041 using mss.mss041,mss.mss_v,mss.mss01,
                                        mss.mss02,mss.mss03
        IF STATUS THEN CALL cl_err('upd mss:',STATUS,1) END IF
     END IF
     LET mst.mst_v=mss.mss_v    # 版本
     LET mst.mst01=mss.mss01    # 料號
     LET mst.mst02=mss.mss02    # 廠商
     LET mst.mst03=mss.mss03    # 日期
     LET mst.mst04=NULL         # 日期
     LET mst.mst05='40'         # 供需類別
     LET mst.mst06=NULL         # 單號
     LET mst.mst061=NULL        # 項次
     LET mst.mst06_fz=NULL      # 凍結否
     LET mst.mst07=NULL         # 追索料號(上階半/成品)
     LET mst.mst08=mss.mss041   # 數量
     LET mst.mstplant=g_plant   #FUN-980004 add
     LET mst.mstlegal=g_legal   #FUN-980004 add
     IF cl_null(mst.mst07) THEN
        LET mst.mst07=' '
     END IF
     IF cl_null(mst.mst09) THEN LET mst.mst09=' ' END IF  #TQC-C20222
        PUT p500_c_ins_mst FROM mst.*
        IF STATUS THEN CALL err('ins mst',STATUS,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
           EXIT PROGRAM 
        END IF
   END FOREACH
   IF STATUS THEN CALL err('p500_ima27_c',STATUS,1) RETURN END IF
END FUNCTION
 
FUNCTION p500_mss041()  # 彙總 獨立需求量
  DEFINE l_rpc02        LIKE rpc_file.rpc02  #FUN-560221
  DEFINE l_rpc12        LIKE type_file.dat      #NO.FUN-680082  DATE
  DEFINE l_sql          STRING               #MOD-C10057 add
  IF incl_id = 'N' THEN RETURN END IF
 
  #"_mss041(彙總受訂量)!"
  LET g_msg=cl_getmsg('amr-013',g_lang)
 
  CALL msg(g_msg,'0')
 #MOD-C10057 str -----------------
 #DECLARE p500_rpc_c CURSOR FOR
 #   SELECT rpc02, rpc01, rpc12, rpc13-rpc131 FROM rpc_file,part_tmp
 #    WHERE rpc01=partno AND rpc13>rpc131 AND rpc12 <= edate
 #      AND rpc18 = 'Y' AND rpc19 <> 'Y'      #No.MOD-860096 add
   LET l_sql =" SELECT rpc02, rpc01, rpc12, rpc13-rpc131 FROM rpc_file,part_tmp"

   IF NOT cl_null(g_sql1) THEN
      LET l_sql = l_sql CLIPPED, ",smy_file"
   END IF
   LET l_sql = l_sql CLIPPED,
               "  WHERE rpc01=partno AND rpc13>rpc131 AND rpc12 <= '",edate,    #TQC-C20273 '
               "'  AND rpc18 = 'Y' AND rpc19 <> 'Y'"                            #TQC-C20273 '
   IF NOT cl_null(g_sql1) THEN
      LET l_sql = l_sql CLIPPED, "   AND rpc02 like smyslip || '-%'",g_sql1 CLIPPED
    END IF

   PREPARE p500_rpc_p FROM l_sql
   DECLARE p500_rpc_c CURSOR FOR p500_rpc_p

 #MOD-C10057 end -----------------
  CALL p500_mss_0()
  FOREACH p500_rpc_c INTO l_rpc02, mss.mss01, l_rpc12, mss.mss041
     IF STATUS THEN CALL err('p500_rpc_c:',STATUS,1) RETURN END IF
     IF mss.mss041 <= 0 OR mss.mss041 IS NULL THEN CONTINUE FOREACH END IF
     LET mss.mss02='-'
     LET mss.mss03=past_date
     LET mss.mssplant=g_plant   #FUN-980004 add
     LET mss.msslegal=g_legal   #FUN-980004 add
     IF l_rpc12 >= list_date THEN  #FUN-B20060_5 bdate->list_date
        SELECT plan_date INTO mss.mss03 FROM buk_tmp WHERE real_date=l_rpc12
        IF STATUS THEN CONTINUE FOREACH END IF
     END IF

#TQC-C20053 --begin--
    IF cl_null(mss.mss13) THEN
      LET mss.mss13 = 'N'
    END IF
#TQC-C20053 --begin--

     INSERT INTO mss_file VALUES(mss.*)
     IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN 
         CALL cl_err('ins mss:',SQLCA.SQLCODE,1) 
     END IF

     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #TQC-790091 mod
        EXECUTE p500_p_upd_mss041 using mss.mss041,mss.mss_v,mss.mss01,
                                        mss.mss02,mss.mss03
        IF STATUS THEN CALL cl_err('upd mss:',STATUS,1) END IF
     END IF
     LET mst.mst_v=mss.mss_v    # 版本
     LET mst.mst01=mss.mss01    # 料號
     LET mst.mst02=mss.mss02    # 廠商
     LET mst.mst03=mss.mss03    # 日期
     LET mst.mst04=l_rpc12      # 日期
     LET mst.mst05='41'         # 供需類別
     LET mst.mst06=l_rpc02      # 單號
     LET mst.mst061=NULL        # 項次
     LET mst.mst06_fz=NULL      # 凍結否
     LET mst.mst07=NULL         # 追索料號(上階半/成品)
     LET mst.mst08=mss.mss041   # 數量
     LET mst.mstplant=g_plant   #FUN-980004 add
     LET mst.mstlegal=g_legal   #FUN-980004 add
     IF cl_null(mst.mst07) THEN
        LET mst.mst07=' '
     END IF
     IF cl_null(mst.mst09) THEN LET mst.mst09=' ' END IF  #TQC-C20222
     PUT p500_c_ins_mst FROM mst.*
     IF STATUS THEN CALL err('ins mst',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
        EXIT PROGRAM END IF
  END FOREACH
  IF STATUS THEN CALL err('p500_rpc_c:',STATUS,1) RETURN END IF
END FUNCTION
 
FUNCTION p500_mss042()  # 彙總 受訂量
  DEFINE l_oeb01        LIKE oeb_file.oeb01     #FUN-560221
  DEFINE l_oeb03        LIKE oeb_file.oeb03     #FUN-560221
 #DEFINE l_oeb72        LIKE oeb_file.oeb72     #FUN-560221  #FUN-B20060_3 oeb15->oeb72 #MOD-BC0133
  DEFINE l_oeb15        LIKE oeb_file.oeb15     #MOD-BC0133 
  DEFINE l_oea65        LIKE oea_file.oea65     #MOD-A60108 add #客戶出貨簽收否
  DEFINE l_qty          LIKE ogb_file.ogb12     #MOD-A60108 add #訂單打到axmt628且未過帳的數量
 #DEFINE l_sql          LIKE type_file.chr1000  #NO.FUN-680082  VARCHAR(3000   #MOD-BC0226 mark
  DEFINE l_sql          STRING                  #MOD-BC0226 add)
  DEFINE l_oeb12        LIKE oeb_file.oeb12     #MOD-B10030 add
 
  IF incl_so = 'N' THEN RETURN END IF
 
  #"_mss041(彙總受訂量)!"
  LET g_msg=cl_getmsg('amr-013',g_lang)
 
  CALL msg(g_msg,'0')
 
  ## 限定倉別 010710
  ## 限定出至境外倉訂單不納入
  # g_sql 限定倉別(imd_file), g_sql5 限定單據(oay_file)
 #LET l_sql = "SELECT oeb01, oeb03, oeb04, oeb72, (oeb12-oeb24)*oeb05_fac,oea65 ",  #MOD-A60108 add oea65 #FUN-B20060_3 oeb15->oeb72 #MOD-BC0133
  LET l_sql = "SELECT oeb01, oeb03, oeb04, oeb15, (oeb12-oeb24)*oeb05_fac,oea65 ",  #MOD-BC0133 
              "  FROM oeb_file,oea_file,part_tmp"
  IF NOT cl_null(g_sql5) THEN
    LET l_sql = l_sql CLIPPED, ",oay_file"
  END IF
  LET l_sql = l_sql CLIPPED,
              " WHERE oeb04=partno AND oeb12>oeb24 AND oeb70='N' ",
             #"   AND oeb72 <= '",edate,"' AND oeb01=oea01 AND oeaconf='Y'", #FUN-B20060_3 oeb15->oeb72 #MOD-BC0133
              "   AND oeb15 <= '",edate,"' AND oeb01=oea01 AND oeaconf='Y'", #MOD-BC0133
              "   AND oea00<>'0'"   #FUN-6A0012 add
  IF NOT cl_null(g_sql5) THEN
    LET l_sql = l_sql CLIPPED,
              "   AND oeb01 like oayslip || '-%'",   #No.FUN-550055
              g_sql5 CLIPPED
  END IF
 
  #FUN-A90057(S)
 #IF g_sma.sma1421='Y' THEN           #MOD-C80241 mark
  IF g_sma.sma1421='Y' AND lot_type MATCHES '[3467]' THEN      #MOD-C80241 add
     CALL p500_set_msr919(l_sql,'oeb919')  
  END IF
  #FUN-A90057(E)

  PREPARE p500_oeb_p FROM l_sql
  DECLARE p500_oeb_c CURSOR FOR p500_oeb_p
  CALL p500_mss_0()
 #FOREACH p500_oeb_c INTO l_oeb01,l_oeb03,mss.mss01,l_oeb72,mss.mss041,l_oea65  #MOD-A60108 add l_oea65 #FUN-B20060_3 oeb15->oeb72 #MOD-BC0133
  FOREACH p500_oeb_c INTO l_oeb01,l_oeb03,mss.mss01,l_oeb15,mss.mss041,l_oea65  #MOD-BC0133
     IF STATUS THEN CALL err('p500_oeb_c:',STATUS,1) RETURN END IF
    #str MOD-A60108 add
   ##若訂單是須簽收(oea65=Y)的話,則受訂量(mss041)須扣除已打到axmt628且未過帳的數量      #MOD-B10030 mark 
    #若訂單是須簽收(oea65=Y)的話,則用訂單axmt410的數量扣除axmt620已過帳的數量           #MOD-B10030 add
     IF l_oea65='Y' THEN
        LET l_qty = 0
        SELECT SUM(ogb12*ogb15_fac) INTO l_qty
          FROM ogb_file,oga_file
         WHERE ogb01=oga01
          #AND oga09='8'     AND ogapost!='Y'            #MOD-B10030 mark  
           AND oga09='2'     AND ogapost='Y'             #MOD-B10030 add 
           AND ogb31=l_oeb01 AND ogb32=l_oeb03
        IF cl_null(l_qty) THEN LET l_qty=0 END IF
       #MOD-B10030---add---start---
        SELECT oeb12 INTO l_oeb12 FROM oeb_file
         WHERE oeb01 = l_oeb01 AND oeb03 = l_oeb03
        IF cl_null(l_oeb12) THEN LET l_oeb12 = 0 END IF
       #MOD-B10030---add---end---
       #LET mss.mss041 = mss.mss041 - l_qty       #MOD-B10030 mark   
        LET mss.mss041 = l_oeb12 - l_qty          #MOD-B10030 add 
     END IF
    #end MOD-A60108 add
     IF mss.mss041 <= 0 OR mss.mss041 IS NULL THEN CONTINUE FOREACH END IF
     LET mss.mss02='-'
     LET mss.mss03=past_date
    #IF l_oeb72 >= list_date THEN #FUN-B20060_3 oeb15->oeb72 #FUN-B20060_5 bdate->list_date #MOD-BC0133
     IF l_oeb15 >= list_date THEN #MOD-BC0133 
       #SELECT plan_date INTO mss.mss03 FROM buk_tmp WHERE real_date=l_oeb72 #FUN-B20060_3 oeb15->oeb72 #MOD-BC0133
        SELECT plan_date INTO mss.mss03 FROM buk_tmp WHERE real_date=l_oeb15 #MOD-BC0133 
        IF STATUS THEN CONTINUE FOREACH END IF
     END IF
     LET mss.mssplant=g_plant   #FUN-980004 add
     LET mss.msslegal=g_legal   #FUN-980004 add

#TQC-C20053 --begin--
    IF cl_null(mss.mss13) THEN
      LET mss.mss13 = 'N'
    END IF
#TQC-C20053 --begin--

     INSERT INTO mss_file VALUES(mss.*)
     IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN 
         CALL cl_err('ins mss:',SQLCA.SQLCODE,1) 
     END IF

     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #TQC-790091 mod
        EXECUTE p500_p_upd_mss041 using mss.mss041,mss.mss_v,mss.mss01,
                                        mss.mss02,mss.mss03
        IF STATUS THEN CALL cl_err('upd mss:',STATUS,1) END IF
     END IF
     LET mst.mst_v=mss.mss_v    # 版本
     LET mst.mst01=mss.mss01    # 料號
     LET mst.mst02=mss.mss02    # 廠商
     LET mst.mst03=mss.mss03    # 日期
    #LET mst.mst04=l_oeb72      # 日期 #FUN-B20060_3 oeb15->oeb72 #MOD-BC0133
     LET mst.mst04=l_oeb15      # 日期 #MOD-BC0133 
     LET mst.mst05='42'         # 供需類別
     LET mst.mst06=l_oeb01      # 單號
     LET mst.mst061=l_oeb03     # 項次
     LET mst.mst06_fz=NULL      # 凍結否
     LET mst.mst07=NULL         # 追索料號(上階半/成品)
     LET mst.mst08=mss.mss041   # 數量
     LET mst.mstplant=g_plant   #FUN-980004 add
     LET mst.mstlegal=g_legal   #FUN-980004 add
     IF cl_null(mst.mst07) THEN
        LET mst.mst07=' '
     END IF
     IF cl_null(mst.mst09) THEN LET mst.mst09=' ' END IF  #TQC-C20222
     PUT p500_c_ins_mst FROM mst.*
     IF STATUS THEN CALL err('ins mst',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
        EXIT PROGRAM END IF
  END FOREACH
  IF STATUS THEN CALL err('p500_oeb_c:',STATUS,1) RETURN END IF
END FUNCTION
 
FUNCTION p500_mss042_1()  # 匯總 MDS需求
  DEFINE l_vlf01        LIKE vlf_file.vlf01
  DEFINE l_vlf02        LIKE vlf_file.vlf02
  DEFINE l_vlf04        LIKE vlf_file.vlf04
  DEFINE l_vlf10        LIKE vlf_file.vlf10
  DEFINE l_vlf11        LIKE vlf_file.vlf11
  DEFINE l_vlf24        LIKE vlf_file.vlf24
 #DEFINE l_sql          LIKE type_file.chr1000     #MOD-BC0226 mark
  DEFINE l_sql          STRING                #MOD-BC0226 add
  DEFINE l_vmu25        LIKE vmu_file.vmu25   #No.FUN-9C0121
  DEFINE l_cnt          LIKE vmu_file.vmu25   #No.FUN-9C0121
 
  IF incl_mds = 'N' THEN RETURN END IF
 
  LET g_msg=cl_getmsg('amr-013',g_lang)
 
  CALL msg(g_msg,'0')

# LET l_sql = "SELECT DISTINCT vmu01,vmu02,vmu23,vmu04,vmu24-vmu13,vmu26,vmu25 ",    #MOD-B90031
  LET l_sql = "SELECT          vmu01,vmu02,vmu23,vmu04,vmu24-vmu13,vmu26,vmu25 ",    #MOD-B90031
              "  FROM vmu_file,part_tmp",
              " WHERE vmu01 = '",msr10,"'",
              "   AND vmu02 = '",msr11,"'",
              "   AND vmu23 = partno ",
              "   AND vmu04 >= '",bdate,"'",
              "   AND vmu04 <= '",edate,"'"
  IF incl_id = 'N' THEN
     SELECT COUNT(*) INTO l_cnt FROM vmu_file
      WHERE vmu01 = msr10
        AND vmu02 = msr11
        AND vmu04 >= bdate
        AND vmu04 <= edate
        AND vmu25 = '2'
     IF l_cnt = 0 THEN
        LET l_sql = l_sql CLIPPED,
                    "   AND vmu25 <> '2' "
     END IF
  ELSE
     LET l_sql = l_sql CLIPPED,
                 "   AND vmu25 <> '2' "
  END IF
#No.FUN-9C0121 END -------
 
  PREPARE p500_oeb_p1 FROM l_sql
  DECLARE p500_oeb_c1 CURSOR FOR p500_oeb_p1
  
  CALL p500_mss_0()
  FOREACH p500_oeb_c1 INTO l_vlf01, l_vlf02, mss.mss01, l_vlf04, mss.mss041,l_vlf24,l_vmu25 #No.FUN-9C0121 Add l_vmu25
     IF STATUS THEN CALL err('p500_oeb_c:',STATUS,1) RETURN END IF
     IF mss.mss041 <= 0 OR mss.mss041 IS NULL THEN CONTINUE FOREACH END IF
     LET mss.mss02='-'
     LET mss.mss03=past_date
     IF l_vlf04 >= list_date THEN  #FUN-B20060_5 bdate->list_date
        SELECT plan_date INTO mss.mss03 FROM buk_tmp WHERE real_date=l_vlf04
        IF STATUS THEN CONTINUE FOREACH END IF
     END IF
     LET mss.mssplant=g_plant   #FUN-980004 add
     LET mss.msslegal=g_legal   #FUN-980004 add

#TQC-C20053 --begin--
    IF cl_null(mss.mss13) THEN
      LET mss.mss13 = 'N'
    END IF
#TQC-C20053 --begin--

     INSERT INTO mss_file VALUES(mss.*)
     IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN 
         CALL cl_err('ins mss:',SQLCA.SQLCODE,1) 
     END IF
     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
        EXECUTE p500_p_upd_mss041 using mss.mss041,mss.mss_v,mss.mss01,
                                        mss.mss02,mss.mss03
        IF STATUS THEN CALL cl_err('upd mss:',STATUS,1) END IF
     END IF
     LET mst.mst_v=mss.mss_v    # 版本
     LET mst.mst01=mss.mss01    # 料號
     LET mst.mst02=mss.mss02    # 厂商
     LET mst.mst03=mss.mss03    # 日期
     LET mst.mst04=l_vlf04      # 日期
     IF l_vmu25 = '2' THEN
        LET mst.mst05 = '41'
     ELSE
        LET mst.mst05='42'      # 供需類別
     END IF
     LET mst.mst06=l_vlf01,"_",l_vlf02
     LET mst.mst061=l_vlf24
     LET mst.mst06_fz=NULL      # 凍結否
     LET mst.mst07=NULL         # 追索料號(上階半/成品)
     LET mst.mst08=mss.mss041   # 數量
     LET mst.mstplant=g_plant   #FUN-980004 add
     LET mst.mstlegal=g_legal   #FUN-980004 add
     IF cl_null(mst.mst07) THEN
        LET mst.mst07=' '
     END IF
     IF cl_null(mst.mst09) THEN LET mst.mst09=' ' END IF  #TQC-C20222
     PUT p500_c_ins_mst FROM mst.*
     IF STATUS THEN CALL err('ins mst',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
        EXIT PROGRAM END IF
  END FOREACH
  IF STATUS THEN CALL err('p500_oeb_c1:',STATUS,1) RETURN END IF
END FUNCTION
 
FUNCTION p500_mss043()  # 彙總 計劃量 (MPS計劃 下階料)
  DEFINE l_ima59,l_ima60,l_ima61 LIKE ima_file.ima60     #NO.FUN-680082  DEC(9,3)
  DEFINE l_ima08        LIKE type_file.chr1     #NO.FUN-680082  VARCHAR(1)
 #DEFINE l_sql          LIKE type_file.chr1000  #NO.FUN-680082  VARCHAR(3000)   #MOD-BC0226  mark
  DEFINE l_sql          STRING                  #MOD-BC0226 add
  DEFINE l_sfb08        LIKE sfb_file.sfb08     #No:9032
  DEFINE l_sfb09        LIKE sfb_file.sfb09     #No:9032
  DEFINE l_ima910       LIKE ima_file.ima910    #FUN-550110
  DEFINE li_result      LIKE type_file.num5     #CHI-690066
 #DEFINE l_ima56        LIKE ima_file.ima56     #CHI-810015 mark #FUN-710073 add 
  DEFINE l_ima601       LIKE ima_file.ima601    #FUN-840194
  DEFINE l_ima50        LIKE ima_file.ima50     #No.MOD-850022 add
 
  IF msb_expl='N' THEN RETURN END IF
 
  #"_mss043(彙總MPS計劃 下階料需求量)!"
  LET g_msg=cl_getmsg('amr-014',g_lang)
 
  CALL msg(g_msg,'0')
 
  # g_sql3 限定單據(sma_file)
  LET l_sql = "SELECT msb_file.*,ima59,ima60,ima601,ima61 ",            #CHI-810015 mod  #FUN-710073 add ima56 #FUN-840194 add ima601 
              "  FROM msb_file,msa_file,part_tmp LEFT OUTER JOIN ima_file ON partno=ima01 ",         #TQC-9A0127 Add
              " WHERE msb01=msa01 AND msb04 <= '",edate,"' AND msa03='N' ",
              "   AND msb03=partno ",                                                                 #TQC-9A0127 Add 
              "   AND msa05 <> 'X' "  #CHI-C80041
       #--
 
  ## 加上限定單據
  IF NOT cl_null(g_sql3) THEN
    LET l_sql = l_sql CLIPPED,g_sql3 CLIPPED
  END IF
 
  #FUN-A90057(S)
 #IF g_sma.sma1421='Y' THEN   #MOD-C80241 mark
  IF g_sma.sma1421='Y' AND lot_type MATCHES '[146]' THEN      #MOD-C80241 add
     CALL p500_set_msr919(l_sql,'msb919')  
  END IF
  #FUN-A90057(E)

  PREPARE p500_msb_p FROM l_sql
  DECLARE p500_msb_c CURSOR FOR p500_msb_p
  CALL p500_mss_0()
  FOREACH p500_msb_c INTO msb.*, l_ima59,l_ima60,l_ima601,l_ima61      #CHI-810015拿掉,l_ima56  #FUN-710073 add l_ima56 #FUN-840194 add l_ima601 
     IF STATUS THEN CALL err('p500_msb_c:',STATUS,1) RETURN END IF
 
     IF l_ima60 IS NULL THEN LET l_ima60=0 END IF
     IF l_ima61 IS NULL THEN LET l_ima61=0 END IF
     IF cl_null(g_argv1) THEN
        IF g_bgjob = 'N' THEN   #MOD-A30082 add
           MESSAGE msb.msb01 CLIPPED,' ',msb.msb02 END IF
           CALL ui.Interface.refresh()
        END IF   #MOD-A30082 add
 
     SELECT SUM(sfb08) INTO l_sfb08 FROM sfb_file
      WHERE sfb22=msb.msb01 AND sfb221=msb.msb02
        AND sfb04 != '8' AND sfb87!='X'  #未結案者, 以開工量為準
        AND sfb02 != '15'   #FUN-660110 add
     IF l_sfb08 IS NULL THEN LET l_sfb08=0 END IF
     SELECT SUM(sfb09) INTO l_sfb09 FROM sfb_file
      WHERE sfb22=msb.msb01 AND sfb221=msb.msb02
        AND sfb04  = '8' AND sfb87!='X'   #已結案者, 以完工量為準
        AND sfb02 != '15'   #FUN-660110 add
     IF l_sfb09 IS NULL THEN LET l_sfb09=0 END IF
     LET g_qty = l_sfb08 + l_sfb09
 
     IF g_qty IS NULL THEN LET g_qty=0 END IF
     LET g_nopen = msb.msb05 - g_qty
     IF g_nopen <= 0 THEN CONTINUE FOREACH END IF
    
 
     LET l_ima50 = 0 
     LET l_ima50=l_ima59+l_ima60/l_ima601*g_nopen+l_ima61   #MOD-9C0082    
     LET msb.msb04=s_aday(msb.msb04,-1,l_ima50)  # 減採購/製造前置日數
##### ---------------------------------------
     LET g_eff_date=msb.msb07
 
     LET l_ima910=''
     SELECT ima910 INTO l_ima910 FROM ima_file WHERE ima01=msb.msb03
     IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF
     CALL p500_mss044_bom('43',0,msb.msb03,l_ima910,g_nopen)  #FUN-550110
  END FOREACH
END FUNCTION
 
FUNCTION p500_mss043_ins(p_bmb01)               #No.MOD-880201 add p_bmb01
DEFINE   p_bmb01         LIKE bmb_file.bmb01    #No.MOD-880201 
       IF cl_null(mss.mss02) THEN LET mss.mss02='-' END IF
       IF qvl_flag <> 'Y' THEN LET mss.mss02 = '-' END IF
       LET mss.mss03=past_date
       IF bmb.bmb18 IS NULL THEN LET bmb.bmb18 = 0 END IF
      #LET needdate=msb.msb04 + bmb.bmb18           #MOD-A40010 mark 
       LET needdate=s_aday(msb.msb04,1,bmb.bmb18)   #MOD-A40010
       IF needdate >= list_date THEN  #FUN-B20060_5 bdate->list_date
          SELECT plan_date INTO mss.mss03 FROM buk_tmp WHERE real_date=needdate
          IF STATUS THEN RETURN END IF
       END IF
       LET mss.mssplant=g_plant   #FUN-980004 add
       LET mss.msslegal=g_legal   #FUN-980004 add

#TQC-C20053 --begin--
    IF cl_null(mss.mss13) THEN
      LET mss.mss13 = 'N'
    END IF
#TQC-C20053 --begin--

       INSERT INTO mss_file VALUES(mss.*)
       IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN 
           CALL cl_err('ins mss:',SQLCA.SQLCODE,1) 
       END IF

       IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #TQC-790091 mod
        EXECUTE p500_p_upd_mss043 using mss.mss043,mss.mss_v,mss.mss01,
                                        mss.mss02,mss.mss03
        IF STATUS THEN CALL cl_err('upd mss:',STATUS,1) END IF
       END IF
       LET mst.mst_v=mss.mss_v  # 版本
       LET mst.mst01=mss.mss01  # 料號
       LET mst.mst02=mss.mss02  # 廠商
       LET mst.mst03=mss.mss03  # 日期
       LET mst.mst04=needdate   # 日期
       LET mst.mst05='43'       # 供需類別
       LET mst.mst06=msb.msb01  # 單號
       LET mst.mst061=msb.msb02 # 項次
       LET mst.mst06_fz=NULL    # 凍結否
       LET mst.mst07=p_bmb01    # 追索料號(上階半/成品)   #No.MOD-880201  
       LET mst.mst08=mss.mss043 # 數量
       LET mst.mstplant=g_plant   #FUN-980004 add
       LET mst.mstlegal=g_legal   #FUN-980004 add
     IF cl_null(mst.mst07) THEN
        LET mst.mst07=' '
     END IF
       IF cl_null(mst.mst09) THEN LET mst.mst09=' ' END IF  #TQC-C20222
       PUT p500_c_ins_mst FROM mst.*
       IF STATUS THEN CALL err('ins mst',STATUS,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
          EXIT PROGRAM END IF
END FUNCTION
 
FUNCTION p500_mss044()  # 彙總 備料量
   DEFINE l_qty       LIKE mst_file.mst08     #NO.FUN-680082  DEC(15,3)
   DEFINE l_sfa29     LIKE sfa_file.sfa29
  #DEFINE l_sql       LIKE type_file.chr1000  #NO.FUN-680082  VARCHAR(3000)  #MOD-BC0226  mark
   DEFINE l_sql       STRING                  #MOD-BC0226 add
   DEFINE l_sfa28     LIKE sfa_file.sfa28     #No.MOD-580099 add sfa28
   DEFINE l_ima910    LIKE ima_file.ima910    #FUN-550110
   DEFINE l_sfa12     LIKE sfa_file.sfa12,
          l_ima25     LIKE ima_file.ima25,
          l_cnt       LIKE type_file.num5,
          l_factor    LIKE ima_file.ima55_fac
 
     #注意: sfa_file 應增加限定廠商欄位 (sfa31)(儲位), 於備料產生時賦予
 
     LET g_msg ="_mss044(彙總備料量)!"
     LET g_msg=cl_getmsg('amr-015',g_lang)
 
     CALL msg(g_msg,'0')
 
     # g_sql1 限定單據(smy_file)
     #工單未備(A)  = 應發 - 已發 -代買 + 下階料報廢 - 超領
     #若 A  < 0 ,則 LET A = 0,同amrp500 之計算邏輯
     LET l_sql = "SELECT sfb01,sfa03,sfa36,sfb13,",   #MOD-970095
                 "       (sfa05-sfa06-sfa065+sfa063-sfa062),sfa12,sfb05,sfa29,sfa28,sfa09 ",  #MOD-850310   #MOD-970079 增加sfa09     #CHI-970070
                 "  FROM sfb_file,sfa_file,part_tmp"
 
 
     IF NOT cl_null(g_sql1) THEN
       LET l_sql = l_sql CLIPPED, ",smy_file"
     END IF
     LET l_sql = l_sql CLIPPED,
                 " WHERE sfb01=sfa01 AND sfa03=partno ",
                 "   AND sfb04 < '8'",
                 "   AND sfb13<='",edate,"' AND sfa05>sfa06+sfa065-sfa063 ",  #No:8021
                 "   AND sfb23='Y' AND sfb87 <> 'X'",  #已備料工單 (取備料檔)
                 "   AND sfb02!='15'"   #FUN-660110 add
     IF NOT cl_null(g_sql1) THEN
#       LET l_sql = l_sql CLIPPED, "   AND sfb01[1,3]=smyslip",
       LET l_sql = l_sql CLIPPED, "   AND sfb01 like smyslip || '-%'",  #No.FUN-550055
                                  g_sql1 CLIPPED
     END IF

     #FUN-A90057(S)
    #IF g_sma.sma1421='Y' THEN      #MOD-C80241 mark
     IF g_sma.sma1421='Y' AND lot_type MATCHES '[2456]' THEN      #MOD-C80241 add
        CALL p500_set_msr919(l_sql,'sfb919')  
     END IF
     #FUN-A90057(E)

     PREPARE p500_sfa_p1 FROM l_sql
     DECLARE p500_sfa_c1 CURSOR FOR p500_sfa_p1
 
     CALL p500_mss_0()
     FOREACH p500_sfa_c1 INTO g_sfa01,mss.mss01,mss.mss02,g_sfb13,mss.mss044,l_sfa12,   #CHI-970070
                              g_sfb05,l_sfa29,l_sfa28,bmb.bmb18                   #No.MOD-580099 add sfa28   #MOD-970079 bmb.bmb18
       IF STATUS THEN CALL err('p500_sfa_c1',STATUS,1) RETURN END IF
       LET l_ima25 = ''
       SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01=mss.mss01
       CALL s_umfchk(mss.mss01,l_sfa12,l_ima25) RETURNING l_cnt, l_factor
       IF l_cnt = 1 THEN
         IF STATUS THEN CALL cl_err(mss.mss01,'mfg3075',1) END IF
         LET l_factor = 1
       END IF
       LET mss.mss044 = mss.mss044 * l_factor
       IF mss.mss044<0 THEN LET mss.mss044=0  END IF #MOD-850310 add
      #計算工單備料量時不需再去除於替代率
 
       IF cl_null(g_argv1) THEN
          IF sw = 'Y' THEN
             IF g_bgjob = 'N' THEN   #MOD-A30082 add
                MESSAGE g_sfa01 CLIPPED
                CALL ui.Interface.refresh()
             END IF   #MOD-A30082 add
          END IF
       END IF
       IF l_sfa29 != g_sfb05 THEN LET g_sfb05 = l_sfa29 END IF
       CALL p500_mss044_ins(g_sfb05)     #No.MOD-880201 add g_sfb05
     END FOREACH
     IF STATUS THEN CALL err('p500_sfa_c1',STATUS,1) RETURN END IF
 
     LET l_sql = "SELECT sfb01,sfb13,sfb08,sfb05,sfb071 ",#未備料工單(取BOM檔)
                 "  FROM sfb_file"
     IF NOT cl_null(g_sql1) THEN
       LET l_sql = l_sql CLIPPED, ",smy_file "
     END IF
     LET l_sql = l_sql CLIPPED,
                 " WHERE sfb04 < '8' AND sfb13<='",edate,"' AND sfb23='N'",   #MOD-970079
                 "   AND sfb87 <> 'X'",
                 "   AND sfb02!='15'"   #FUN-660110 add
     IF NOT cl_null(g_sql1) THEN
       LET l_sql = l_sql CLIPPED, "AND sfb01 like smyslip || '-%'",  #No.FUN-550055
                                  g_sql1 CLIPPED
     END IF
 
     PREPARE p500_sfa_p2 FROM l_sql
     DECLARE p500_sfa_c2 CURSOR FOR p500_sfa_p2
 
     CALL p500_mss_0()
     FOREACH p500_sfa_c2 INTO g_sfa01,g_sfb13,l_qty,g_sfb05,g_eff_date
       IF STATUS THEN CALL err('p500_sfa_c2',STATUS,1) RETURN END IF
       IF cl_null(g_argv1) THEN
           IF sw ='Y' THEN
              IF g_bgjob = 'N' THEN   #MOD-A30082 add
                 MESSAGE g_sfa01 CLIPPED
                 CALL ui.Interface.refresh()
              END IF   #MOD-A30082 add
           END IF
       END IF
       LET l_ima910=''
       SELECT ima910 INTO l_ima910 FROM ima_file WHERE ima01=g_sfb05
       IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF
       CALL p500_mss044_bom('44',0,g_sfb05,l_ima910,l_qty)  #FUN-550110
     END FOREACH
     IF STATUS THEN CALL err('p500_sfa_c2',STATUS,1) RETURN END IF
END FUNCTION
 
FUNCTION p500_mss044_bom(p_sw,p_level,p_key,p_key2,p_qty)  #FUN-550110
#No.FUN-A70034  --Begin
   DEFINE l_total     LIKE sfa_file.sfa05     #总用量
   DEFINE l_QPA       LIKE bmb_file.bmb06     #标准QPA
   DEFINE l_ActualQPA LIKE bmb_file.bmb06     #实际QPA
#No.FUN-A70034  --End  
   DEFINE p_sw        LIKE mps_file.mps_v,    #NO.FUN-680082  VARCHAR(2)     # 43:mss043 44:mss044
          p_level     LIKE type_file.num5,    #NO.FUN-680082  SMALLINT
          p_key       LIKE bma_file.bma01,    #主件料件編號
          p_key2      LIKE ima_file.ima910,   #FUN-550110
          p_qty       LIKE bmb_file.bmb06,    #NO.FUN-680082  DEC(18,6)
          l_bmb01     LIKE bmb_file.bmb01,
          l_ac,i      LIKE type_file.num5,    #NO.FUN-680082  SMALLINT
          arrno       LIKE type_file.num5,    #NO.FUN-680082  SMALLINT    #BUFFER SIZE (可存筆數)
          sr DYNAMIC ARRAY OF RECORD          #每階存放資料
              bmb03   LIKE bmb_file.bmb03,    #元件料號
              bml04   LIKE bml_file.bml04,    #指定廠牌
              bmb06   LIKE bmb_file.bmb06,    #FUN-560230
              bmb18   LIKE bmb_file.bmb18,    #投料時距
          #   bmb19   LIKE bmb_file.bmb19,    #工单开立展开选项  #FUN-B20060_4 add   #CHI-D40027 mark
              ima08   LIKE type_file.chr1,    #NO.FUN-680082  VARCHAR(01)
              bmb10_fac LIKE bmb_file.bmb10_fac,
              ima55     LIKE ima_file.ima55,
              bmb10     LIKE bmb_file.bmb10,
              #No.FUN-A70034  --Begin
              bmb08     LIKE bmb_file.bmb08,
              bmb081    LIKE bmb_file.bmb081,
              bmb082    LIKE bmb_file.bmb082
              #No.FUN-A70034  --End  
          END RECORD,
          l_bma05     LIKE bma_file.bma05,
          l_msg       LIKE type_file.chr1000, #NO.FUN-680082  VARCHAR(40)
          l_sql       LIKE type_file.chr1000  #NO.FUN-680082  VARCHAR(1000)
    DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0035 
 
    IF p_level > 20 THEN CALL cl_err('','mfg2733',1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211 
      EXIT PROGRAM END IF
    LET p_level = p_level + 1 IF p_level > lot_bm THEN RETURN END IF
    SELECT bma05 INTO l_bma05 FROM bma_file WHERE bma01 = p_key
                                              AND bma06 = p_key2     #MOD-AA0050 add
    IF SQLCA.sqlcode THEN
       CALL cl_getmsg('amr-002',g_lang) RETURNING l_msg
       LET g_msg = p_key,l_msg clipped
       CALL msg(g_msg,'amr-002')
       RETURN
    END IF
    IF cl_null(l_bma05) THEN
       CALL cl_getmsg('amr-001',g_lang) RETURNING l_msg
       LET g_msg = p_key,l_msg clipped
       CALL msg(g_msg,'amr-001')
       RETURN
    END IF
    LET arrno = 600
    DECLARE p500_44_c1 CURSOR FOR
          #No.FUN-A70034  --Begin
         #SELECT bmb03,bml04,bmb06/bmb07*(1+bmb08/100),bmb18,ima08,bmb10_fac,
         #       ima55,bmb10
         #SELECT bmb03,bml04,bmb06/bmb07,bmb18,bmb19,ima08,bmb10_fac,  #FUN-B20060_4 add bmb19  #CHI-D40027 mark
          SELECT bmb03,bml04,bmb06/bmb07,bmb18,ima08,bmb10_fac,        #CHI-D40027 add
                 ima55,bmb10,bmb08,bmb081,bmb082
          #No.FUN-A70034  --End  
                 FROM ima_file,bmb_file LEFT OUTER JOIN bml_file ON bmb03=bml01 AND bmb01=bml02                      #TQC-9A0127 Add
                                                                                AND bml03 = qvl_bml03      #MOD-9C0337 add
                 WHERE bmb01=p_key AND bmb03=ima01
                   AND bmb29 =p_key2  #FUN-550110
                   AND bmb04<=g_eff_date AND (bmb05 IS NULL OR bmb05>g_eff_date)
    LET l_ac = 1
    FOREACH p500_44_c1 INTO sr[l_ac].*
       #先將BOM單身存入BUFFER
       IF STATUS THEN CALL cl_err('fore p500_44_c1:',STATUS,1) EXIT FOREACH END IF
       #No.FUN-A70034 --Begin
       #LET sr[l_ac].bmb06=sr[l_ac].bmb06*p_qty
       #No.FUN-A70034 --End  
 
       LET l_ima910[l_ac]=''
       SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03
       IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
       LET l_ac = l_ac + 1                    # 但BUFFER不宜太大
       IF l_ac > arrno THEN EXIT FOREACH END IF
    END FOREACH
   #IF STATUS THEN CALL cl_err('fore p500_cur:',STATUS,1) END IF
    IF STATUS THEN CALL cl_err('fore p500_44_c1:',STATUS,1) END IF  #FUN-B20060 mod
    FOR i = 1 TO l_ac-1               # 讀BUFFER傳給REPORT
      IF sw = 'Y' THEN
         IF g_bgjob = 'N' THEN   #MOD-A30082 add
            message p_level,' ',sr[i].bmb03 clipped
            CALL ui.Interface.refresh()
         END IF   #MOD-A30082 add
      END IF
       #No.FUN-A70034 --Begin
       CALL cralc_rate(p_key,sr[i].bmb03,p_qty,sr[i].bmb081,sr[i].bmb08,sr[i].bmb082, 
                       sr[i].bmb06,0)
            RETURNING l_total,l_QPA,l_ActualQPA
       LET sr[i].bmb06=l_total
       #No.FUN-A70034 --End  
       IF sr[i].ima08='X' THEN   #CHI-D40027 remark                 
      #IF sr[i].ima08='X' OR (sr[i].ima08='M' AND sr[i].bmb19='3') THEN  #Mod FUN-B20060_4  #CHI-D40027 mark
           #No.FUN-A70034  --Begin
           #CALL p500_mss044_bom(p_sw,p_level,sr[i].bmb03,l_ima910[i],sr[i].bmb06)  #FUN-550110#FUN-8B0035
           CALL p500_mss044_bom(p_sw,p_level,sr[i].bmb03,l_ima910[i],sr[i].bmb06)
           #No.FUN-A70034  --End  
       ELSE
           SELECT partno FROM part_tmp WHERE partno=sr[i].bmb03
           IF STATUS THEN CONTINUE FOR END IF
           LET mss.mss01=sr[i].bmb03
           LET mss.mss02=sr[i].bml04
           LET bmb.bmb18=sr[i].bmb18
           IF cl_null(sr[i].bmb10_fac) THEN  LET sr[i].bmb10_fac=1 END IF
           IF p_sw='43' THEN
## No:2423  modify 1998/09/04 -(統一單位為庫存單位)-------
              LET mss.mss043=sr[i].bmb06 * sr[i].bmb10_fac
              CALL p500_mss043_ins(p_key)   #No.MOD-880201 add p_key  
           ELSE
## No:2423  modify 1998/09/04 -(統一單位為庫存單位)-------
              LET mss.mss044=sr[i].bmb06 * sr[i].bmb10_fac
              CALL p500_mss044_ins(p_key)   #No.MOD-880201 add p_key
           END IF
       END IF
    END FOR
END FUNCTION
 
FUNCTION p500_mss044_ins(p_bmb01)   #No.MOD-880201 add p_bmb01
DEFINE   p_bmb01      LIKE bmb_file.bmb01  #No.MOD-880201
       IF cl_null(mss.mss02) THEN LET mss.mss02='-' END IF
       IF qvl_flag <> 'Y' THEN LET mss.mss02 = '-' END IF
       LET mss.mss03=past_date
       IF bmb.bmb18 IS NULL THEN LET bmb.bmb18 = 0 END IF
      #LET needdate=g_sfb13 + bmb.bmb18           #MOD-A40010 mark 
       LET needdate=s_aday(g_sfb13,1,bmb.bmb18)   #MOD-A40010
       IF needdate >= list_date THEN  #FUN-B20060_5 bdate->list_date
          SELECT plan_date INTO mss.mss03 FROM buk_tmp WHERE real_date=needdate
          IF STATUS THEN RETURN END IF
       END IF
       LET mss.mssplant=g_plant   #FUN-980004 add
       LET mss.msslegal=g_legal   #FUN-980004 add

#TQC-C20053 --begin--
    IF cl_null(mss.mss13) THEN
      LET mss.mss13 = 'N'
    END IF
#TQC-C20053 --begin--

       INSERT INTO mss_file VALUES(mss.*)
       IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN 
           CALL cl_err('ins mss:',SQLCA.SQLCODE,1) 
       END IF
       IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #TQC-790091 mod

        EXECUTE p500_p_upd_mss044 using mss.mss044,mss.mss_v,mss.mss01,
                                        mss.mss02,mss.mss03
        IF STATUS THEN CALL cl_err('upd mss:',STATUS,1) END IF
       END IF
       LET mst.mst_v=mss.mss_v  # 版本
       LET mst.mst01=mss.mss01  # 料號
       LET mst.mst02=mss.mss02  # 廠商
       LET mst.mst03=mss.mss03  # 日期
       LET mst.mst04=needdate   # 日期
       LET mst.mst05='44'       # 供需類別
       LET mst.mst06=g_sfa01    # 單號
       LET mst.mst061=NULL      # 項次
       LET mst.mst06_fz=NULL    # 凍結否
       LET mst.mst07=p_bmb01    # 追索料號(上階半/成品)   #No.MOD-880201 
       LET mst.mst08=mss.mss044 # 數量
       LET mst.mstplant=g_plant   #FUN-980004 add
       LET mst.mstlegal=g_legal   #FUN-980004 add
     IF cl_null(mst.mst07) THEN
        LET mst.mst07=' '
     END IF
       IF cl_null(mst.mst09) THEN LET mst.mst09=' ' END IF  #TQC-C20222
       PUT p500_c_ins_mst FROM mst.*
       IF STATUS THEN CALL err('ins mst',STATUS,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
          EXIT PROGRAM END IF
END FUNCTION
 
FUNCTION p500_mss046()  # 彙總 備品
  DEFINE l_oeb01        LIKE oeb_file.oeb01     #FUN-560221
  DEFINE l_oeb03        LIKE oeb_file.oeb03     #FUN-560221
 #DEFINE l_oeb72        LIKE oeb_file.oeb72     #FUN-560221 #FUN-B20060_3 oeb15->oeb72 #MOD-BC0133
  DEFINE l_oeb15        LIKE oeb_file.oeb15     #FUN-560221 #MOD-BC0133 
 #DEFINE l_sql          LIKE type_file.chr1000  #NO.FUN-680082  VARCHAR(3000)  #MOD-BC0226  mark
  DEFINE l_sql          STRING                  #MOD-BC0226 add
  DEFINE l_oeo05        LIKE oeo_file.oeo05,
         l_ima25        LIKE ima_file.ima25,
         l_factor       LIKE pml_file.pml09,    #NO.FUN-680082  DEC(16,8)
         l_cnt          LIKE type_file.num5     #NO.FUN-680082  SMALLINT
 
  IF incl_so = 'N' THEN RETURN END IF
 
  #LET g_msg ="_mss046(彙總備品)!"
  LET g_msg=cl_getmsg('amr-016',g_lang)
 
  CALL msg(g_msg,'0')
 
  # g_sql5 限定單據(oay_file)
 #LET l_sql = "SELECT oeb01, oeb03, oeo04, oeb72, oeo09, oeo05, ima25", #FUN-B20060_3 oeb15->oeb72 #MOD-BC0133
  LET l_sql = "SELECT oeb01, oeb03, oeo04, oeb15, oeo09, oeo05, ima25", #MOD-BC0133
              "  FROM oeb_file,oea_file,part_tmp,oeo_file,ima_file"
  IF NOT cl_null(g_sql5) THEN
    LET l_sql = l_sql CLIPPED, ",oay_file"
  END IF
  LET l_sql = l_sql CLIPPED,
              " WHERE oeb01=oeo01 AND oeb03=oeo03 AND oeo08='2'",
              "   AND oeb04=partno AND oeb12>oeb24 AND oeb70='N' ",
             #"   AND oeb72 <= '",edate,"' AND oeb01=oea01 AND oeaconf='Y'", #FUN-B20060_3 oeb15->oeb72 #MOD-BC0133
              "   AND oeb15 <= '",edate,"' AND oeb01=oea01 AND oeaconf='Y'", #MOD-BC0133 
              "   AND oeo04=ima01",
              "   AND oea00<>'0'"   #FUN-6A0012 add
  IF NOT cl_null(g_sql5) THEN
    LET l_sql = l_sql CLIPPED, "   AND oeb01 like oayslip || '-%'",  #No.FUN-550055
                               g_sql5 CLIPPED
  END IF
 
  PREPARE p500_oeo_p FROM l_sql
  DECLARE p500_oeo_c CURSOR FOR p500_oeo_p
  CALL p500_mss_0()
 #FOREACH p500_oeo_c INTO l_oeb01, l_oeb03, mss.mss01, l_oeb72, mss.mss041, #FUN-B20060_3 oeb15->oeb72 #MOD-BC0133
  FOREACH p500_oeo_c INTO l_oeb01, l_oeb03, mss.mss01, l_oeb15, mss.mss041, #MOD-BC0133
                          l_oeo05, l_ima25
     IF STATUS THEN CALL err('p500_oeb_c:',STATUS,1) RETURN END IF
     CALL s_umfchk(mss.mss01,l_oeo05,l_ima25) RETURNING l_cnt, l_factor
     IF l_cnt = 1 THEN
       IF STATUS THEN CALL cl_err(mss.mss01,'mgf3075',1) END IF
       LET l_factor = 1
     END IF
     LET mss.mss041 = mss.mss041 * l_factor
     IF mss.mss041 <= 0 OR mss.mss041 IS NULL THEN CONTINUE FOREACH END IF
     LET mss.mss02='-'
     LET mss.mss03=past_date
    #IF l_oeb72 >= list_date THEN #FUN-B20060_3 oeb15->oeb72  #FUN-B20060_5 bdate->list_date #MOD-BC0133
     IF l_oeb15 >= list_date THEN #MOD-BC0133 
       #SELECT plan_date INTO mss.mss03 FROM buk_tmp WHERE real_date=l_oeb72  #FUN-B20060_3 oeb15->oeb72 #MOD-BC0133
        SELECT plan_date INTO mss.mss03 FROM buk_tmp WHERE real_date=l_oeb15  #MOD-BC0133
        IF STATUS THEN CONTINUE FOREACH END IF
     END IF
     LET mss.mssplant=g_plant   #FUN-980004 add
     LET mss.msslegal=g_legal   #FUN-980004 add

#TQC-C20053 --begin--
    IF cl_null(mss.mss13) THEN
      LET mss.mss13 = 'N'
    END IF
#TQC-C20053 --begin--

     INSERT INTO mss_file VALUES(mss.*)
     IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN 
         CALL cl_err('ins mss:',SQLCA.SQLCODE,1) 
     END IF
     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #TQC-790091 mod

        EXECUTE p500_p_upd_mss041 using mss.mss041,mss.mss_v,mss.mss01,
                                        mss.mss02,mss.mss03
        IF STATUS THEN CALL cl_err('upd mss:',STATUS,1) END IF
     END IF
     LET mst.mst_v=mss.mss_v    # 版本
     LET mst.mst01=mss.mss01    # 料號
     LET mst.mst02=mss.mss02    # 廠商
     LET mst.mst03=mss.mss03    # 日期
    #LET mst.mst04=l_oeb72      # 日期 #FUN-B20060_3 oeb15->oeb72 #MOD-BC0133
     LET mst.mst04=l_oeb15      # 日期 #MOD-BC0133
     LET mst.mst05='46'         # 供需類別
     LET mst.mst06=l_oeb01      # 單號
     LET mst.mst061=l_oeb03     # 項次
     LET mst.mst06_fz=NULL      # 凍結否
     LET mst.mst07=NULL         # 追索料號(上階半/成品)
     LET mst.mst08=mss.mss041   # 數量
     LET mst.mstplant=g_plant   #FUN-980004 add
     LET mst.mstlegal=g_legal   #FUN-980004 add
     IF cl_null(mst.mst07) THEN
        LET mst.mst07=' '
     END IF
     IF cl_null(mst.mst09) THEN LET mst.mst09=' ' END IF  #TQC-C20222
     PUT p500_c_ins_mst FROM mst.*
     IF STATUS THEN CALL err('ins mst',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211 
        EXIT PROGRAM END IF
  END FOREACH
  IF STATUS THEN CALL err('p500_oeb_c:',STATUS,1) RETURN END IF
END FUNCTION
 
FUNCTION p500_c_part_tmp2()             # 找出需 MRP 的料號+廠商
 
  #LET g_msg ="找出需 MRP 的料號+廠商!"
  LET g_msg=cl_getmsg('amr-017',g_lang)
 
  CALL msg(g_msg,'0')
  DROP TABLE part_tmp2
  CREATE TEMP TABLE part_tmp2(
       partno LIKE ima_file.ima01,    #No.MOD-7C0165 modify
       ven_no LIKE mss_file.mss02)
  IF STATUS THEN CALL err('create part_tmp2:',STATUS,1) 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
     EXIT PROGRAM END IF
  CREATE UNIQUE INDEX part_tmp2_i1 ON part_tmp2(partno,ven_no)
  IF STATUS THEN CALL err('index part_tmp2:',STATUS,1) 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
     EXIT PROGRAM END IF
  INSERT INTO part_tmp2
         SELECT DISTINCT mss01,mss02 FROM mss_file
          WHERE mss_v=ver_no
            AND mss01 IS NOT NULL AND mss02 IS NOT NULL AND mss02 <> '-'
END FUNCTION
 
FUNCTION p500_mss051()  #  ---> 庫存量
   DEFINE l_img02       LIKE img_file.img02     #FUN-560221
   DEFINE l_img03       LIKE img_file.img03     #FUN-560221
  #DEFINE l_sql         LIKE type_file.chr1000  #NO.FUN-680082  VARCHAR(3000))  #MOD-BC0226  mark
   DEFINE l_sql         STRING                  #MOD-BC0226 add
 
  #"_mss051(彙總庫存量)!"
  LET g_msg=cl_getmsg('amr-018',g_lang)
 
  CALL msg(g_msg,'0')
 
   # g_sql 限定倉別(imd_file)
   LET l_sql = "SELECT img01, img02, img03, SUM(img10) ",  
               "  FROM img_file,part_tmp"
   IF NOT cl_null(g_sql) THEN
     LET l_sql = l_sql CLIPPED, ",imd_file"
   END IF
   LET l_sql = l_sql CLIPPED,
              " WHERE img01 = partno AND img24='Y' " 
   IF NOT cl_null(g_sql) THEN
     LET l_sql = l_sql CLIPPED, "   AND imd01=img02 ",  
                                g_sql CLIPPED
   END IF
   LET l_sql = l_sql CLIPPED," GROUP BY img01,img02,img03"
 
   PREPARE p500_img_p1 FROM l_sql
   DECLARE p500_img_c1 CURSOR FOR p500_img_p1
 
   CALL p500_mss_0()
   FOREACH p500_img_c1 INTO mss.mss01, l_img02, l_img03, mss.mss051
     IF STATUS THEN CALL err('p500_img_c1',STATUS,1) RETURN END IF
     LET mss.mss02=l_img03
     SELECT COUNT(*) INTO i FROM part_tmp2
      WHERE partno=mss.mss01 AND ven_no=mss.mss02
     IF i = 0 THEN LET mss.mss02='-' END IF
     IF cl_null(mss.mss02) THEN LET mss.mss02='-' END IF
     LET mss.mss03=past_date
     LET mss.mssplant=g_plant   #FUN-980004 add
     LET mss.msslegal=g_legal   #FUN-980004 add

#TQC-C20053 --begin--
    IF cl_null(mss.mss13) THEN
      LET mss.mss13 = 'N'
    END IF
#TQC-C20053 --begin--

     INSERT INTO mss_file VALUES(mss.*)
     IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN 
         CALL cl_err('ins mss:',SQLCA.SQLCODE,1) 
     END IF
     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #TQC-790091 mod

        EXECUTE p500_p_upd_mss051 using mss.mss051,mss.mss_v,mss.mss01,
                                        mss.mss02,mss.mss03
        IF STATUS THEN CALL cl_err('upd mss:',STATUS,1) END IF
     END IF
     LET mst.mst_v=mss.mss_v    # 版本
     LET mst.mst01=mss.mss01    # 料號
     LET mst.mst02=mss.mss02    # 廠商
     LET mst.mst03=mss.mss03    # 日期
     LET mst.mst04=NULL         # 日期
     LET mst.mst05='51'         # 供需類別
     LET mst.mst06=l_img02 CLIPPED,' ',l_img03  # 單號
     LET mst.mst061=NULL        # 項次
     LET mst.mst06_fz=NULL      # 凍結否
     LET mst.mst07=NULL         # 追索料號(上階半/成品)
     LET mst.mst08=mss.mss051   # 數量
     LET mst.mstplant=g_plant   #FUN-980004 add
     LET mst.mstlegal=g_legal   #FUN-980004 add
     IF cl_null(mst.mst07) THEN
        LET mst.mst07=' '
     END IF
     IF cl_null(mst.mst09) THEN LET mst.mst09=' ' END IF  #TQC-C20222
     PUT p500_c_ins_mst FROM mst.*
     IF STATUS THEN CALL err('ins mst',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
        EXIT PROGRAM END IF
   END FOREACH
   IF STATUS THEN CALL err('p500_img_c1',STATUS,1) RETURN END IF
END FUNCTION
 
FUNCTION p500_mss052()  #  ---> 在驗量
   DEFINE l_rvb01       LIKE rvb_file.rvb01      #FUN-560221
   DEFINE l_rvb02       LIKE rvb_file.rvb02      #FUN-560221
   DEFINE l_pmn09       LIKE pmn_file.pmn09      #採購單位/料件庫存單位的轉換率
##
   DEFINE l_pmn38       LIKE pmn_file.pmn38      #MPS/MRP可用   #FUN-690047 add
  #DEFINE l_sql         LIKE type_file.chr1000   #NO.FUN-680082  VARCHAR(3000)  #MOD-BC0226  mark
   DEFINE l_sql         STRING                   #MOD-BC0226 add
 
  #"_mss051(彙總在驗量)!"
  LET g_msg=cl_getmsg('amr-019',g_lang)
 
  CALL msg(g_msg,'0')
 
   # g_sql 限定倉別(imd_file) g_sql1 限定單據(smy_file)

   IF NOT cl_null(g_sql1) THEN
      LET l_sql = "SELECT rvb01,rvb02,rvb05, rva05, (rvb07-rvb29-rvb30),pmn09 ",   
                  "      ,pmn38 ", 
                  "  FROM rva_file,part_tmp,smy_file,rvb_file LEFT OUTER JOIN pmn_file ON rvb04=pmn01 AND rvb03=pmn02"  
   ELSE
      LET l_sql = "SELECT rvb01,rvb02,rvb05, rva05, (rvb07-rvb29-rvb30),pmn09 ",
                  "      ,pmn38 ",
                  "  FROM rva_file,part_tmp,rvb_file LEFT OUTER JOIN pmn_file ON rvb04=pmn01 AND rvb03=pmn02"
   END IF

   LET l_sql = l_sql CLIPPED,
               " WHERE rvb05=partno AND rvb01=rva01 ",
               "   AND rvb07 > (rvb29+rvb30) ",
               "   AND rvaconf ='Y'",
               "   AND rva10 <> 'SUB'"
   IF NOT cl_null(g_sql1) THEN
     LET l_sql = l_sql CLIPPED, "   AND rva01 like smyslip || '-%'",  #No.FUN-550055
                                g_sql1 CLIPPED
   END IF
 
   PREPARE p500_rvb_p1 FROM l_sql
   DECLARE p500_rvb_c1 CURSOR FOR p500_rvb_p1
 
   CALL p500_mss_0()
   FOREACH p500_rvb_c1 INTO l_rvb01,l_rvb02,
                            mss.mss01,mss.mss02,mss.mss052,l_pmn09,l_pmn38   #FUN-690047 add l_pmn38
     IF STATUS THEN CALL err('p500_rvb_c1',STATUS,1) RETURN END IF
     #當'MPS/MRP可用'(pmn38)為Y時,才做計算
     IF l_pmn38!='Y' THEN CONTINUE FOREACH END IF   #FUN-690047 add
 
     SELECT pmh07 INTO mss.mss02 FROM pmh_file
            WHERE pmh01=mss.mss01 AND pmh02=mss.mss02
              AND pmh21 = " "                                            
              AND pmh22 = '1'
              AND pmh23 = ' '                                             #No.CHI-960033
              AND pmhacti = 'Y'                                           #CHI-910021                                      
 
     SELECT COUNT(*) INTO i FROM part_tmp2
      WHERE partno=mss.mss01 AND ven_no=mss.mss02
     IF i = 0 THEN LET mss.mss02='-' END IF
     IF cl_null(mss.mss02) THEN LET mss.mss02='-' END IF
 
     IF cl_null(l_pmn09) THEN LET l_pmn09=1 END IF
     LET mss.mss052=mss.mss052*l_pmn09
 
     LET mss.mss03=past_date
     LET mss.mssplant=g_plant   #FUN-980004 add
     LET mss.msslegal=g_legal   #FUN-980004 add

#TQC-C20053 --begin--
    IF cl_null(mss.mss13) THEN
      LET mss.mss13 = 'N'
    END IF
#TQC-C20053 --begin--

     INSERT INTO mss_file VALUES(mss.*)
     IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN 
         CALL cl_err('ins mss:',SQLCA.SQLCODE,1) 
     END IF
     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #TQC-790091 mod

        EXECUTE p500_p_upd_mss052 using mss.mss052,mss.mss_v,mss.mss01,
                                        mss.mss02,mss.mss03
        IF STATUS THEN CALL cl_err('upd mss:',STATUS,1) END IF
     END IF
     LET mst.mst_v=mss.mss_v    # 版本
     LET mst.mst01=mss.mss01    # 料號
     LET mst.mst02=mss.mss02    # 廠商
     LET mst.mst03=mss.mss03    # 日期
     LET mst.mst04=NULL         # 日期
     LET mst.mst05='52'         # 供需類別
     LET mst.mst06=l_rvb01      # 單號
     LET mst.mst061=l_rvb02     # 項次
     LET mst.mst06_fz=NULL      # 凍結否
     LET mst.mst07=NULL         # 追索料號(上階半/成品)
     LET mst.mst08=mss.mss052   # 數量
     LET mst.mstplant=g_plant   #FUN-980004 add
     LET mst.mstlegal=g_legal   #FUN-980004 add
     IF cl_null(mst.mst07) THEN
        LET mst.mst07=' '
     END IF
     IF cl_null(mst.mst09) THEN LET mst.mst09=' ' END IF  #TQC-C20222
     PUT p500_c_ins_mst FROM mst.*
     IF STATUS THEN CALL err('ins mst',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
        EXIT PROGRAM END IF
   END FOREACH
   IF STATUS THEN CALL err('p500_rvb_c1',STATUS,1) RETURN END IF
END FUNCTION

  ##NO.FUN-A40023   --begin
#FUNCTION p500_mss053()  #  ---> 替代料庫存量
#  DEFINE l_img01       LIKE img_file.img01     #NO.MOD-490217
#  DEFINE l_img03       LIKE img_file.img03     #NO.FUN-680082  VARCHAR(20)
#  DEFINE l_sql         LIKE type_file.chr1000  #NO.FUN-680082  VARCHAR(3000)
#
#  #"_mss053(彙總替代料量)!"
#  LET g_msg=cl_getmsg('amr-020',g_lang)
#  CALL msg(g_msg,'0')
#
#  LET l_sql = " SELECT partno, img01, img03, SUM(img10*img21) ",    #MOD-940312
#              "   FROM img_file,part_tmp3,imd_file ",
#              "  WHERE img01=sub_no AND img24='Y' ",
#              "    AND img02=imd01 "
#  LET l_sql = l_sql CLIPPED,g_sql CLIPPED
#  LET l_sql = l_sql CLIPPED," GROUP BY partno,img01,img03 "
#  PREPARE p500_img_p2 FROM l_sql
#  DECLARE p500_img_c2 CURSOR FOR p500_img_p2
#
#  CALL p500_mss_0()
#  FOREACH p500_img_c2 INTO mss.mss01,l_img01,l_img03,mss.mss053
#    IF STATUS THEN CALL err('p500_img_c2',STATUS,1) RETURN END IF
#    LET mss.mss02='-'
#    LET mss.mss03=past_date
#    LET mss.mssplant=g_plant   #FUN-980004 add
#    LET mss.msslegal=g_legal   #FUN-980004 add
#    INSERT INTO mss_file VALUES(mss.*)
#    IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN 
#        CALL cl_err('ins mss:',SQLCA.SQLCODE,1) 
#    END IF
#    IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #TQC-790091 mod

#       EXECUTE p500_p_upd_mss053 using mss.mss053,mss.mss_v,mss.mss01,
#                                       mss.mss02,mss.mss03
#       IF STATUS THEN CALL cl_err('upd mss:',STATUS,1) END IF
#    END IF
#    LET mst.mst_v=mss.mss_v    # 版本
#    LET mst.mst01=mss.mss01    # 料號
#    LET mst.mst02=mss.mss02    # 廠商
#    LET mst.mst03=mss.mss03    # 日期
#    LET mst.mst04=NULL         # 日期
#    LET mst.mst05='53'         # 供需類別
#    LET mst.mst06=NULL         # 單號
#    LET mst.mst061=NULL        # 項次
#    LET mst.mst06_fz=NULL      # 凍結否
#    LET mst.mst07=l_img01      # 追索料號(替代料號)
#    LET mst.mst08=mss.mss053   # 數量
#    LET mst.mstplant=g_plant   #FUN-980004 add
#    LET mst.mstlegal=g_legal   #FUN-980004 add
#    IF cl_null(mst.mst07) THEN
#       LET mst.mst07=' '
#    END IF
#    PUT p500_c_ins_mst FROM mst.*
#    IF STATUS THEN CALL err('ins mst',STATUS,1) EXIT PROGRAM END IF
#  END FOREACH
#  IF STATUS THEN CALL err('p500_img_c2',STATUS,1) RETURN END IF
# END FUNCTION
  ##NO.FUN-A40023   --end
 
FUNCTION p500_mss061()  # 彙總 請購量
  DEFINE l_pml01        LIKE pml_file.pml01    #FUN-560221
  DEFINE l_pml02        LIKE pml_file.pml02    #FUN-560221
  DEFINE l_pml33        LIKE pml_file.pml33    #FUN-560221
  DEFINE l_pml35        LIKE pml_file.pml35    #TQC-660123
  DEFINE l_pml12        LIKE pml_file.pml12
  DEFINE l_pml09        LIKE pml_file.pml09
  DEFINE l_pmk25        LIKE pmk_file.pmk25    #FUN-560221
 #DEFINE l_sql          LIKE type_file.chr1000 #NO.FUN-680082  VARCHAR(3000)  #MOD-BC0226  mark
  DEFINE l_sql          STRING                 #MOD-BC0226 add
 
  IF g_sma.sma56='3' THEN RETURN END IF
 
  #"_mss061(彙總請購量)!"
  LET g_msg=cl_getmsg('amr-021',g_lang)
 
  CALL msg(g_msg,'0')
 
  #No.7087 03/04/21 By Jiunn Mod.A.a.12 -----
  # g_sql1 限定單據(smy_file) g_sql4 限定地址(pmk_file)
  # g_sql4 限定指送地點
 
  #TQC-660123
  #LET l_sql = "SELECT pml01,pml02,pml04,pml11,pml33,pml20-pml21,pml12, ",
  LET l_sql = "SELECT pml01,pml02,pml04,pml11,pml35,pml20-pml21,pml12, ",
              "       pmk25,pml09 ",
              "  FROM pml_file,pmk_file,part_tmp"
  IF NOT cl_null(g_sql1) THEN
    LET l_sql = l_sql CLIPPED, ",smy_file "
  END IF
  LET l_sql = l_sql CLIPPED,
              " WHERE pml04=partno AND pml20>pml21 ",
               #MOD-510004
              "   AND (pml16<='2' OR pml16='S' OR pml16='R' OR pml16='W') ",
              #--
              #TQC-660123
              #"   AND pml33<='",edate,"'",
              "   AND pml35<='",edate,"'",
              "   AND pml01=pmk01 AND pmk02<>'SUB' ",
              #"   AND pmk18 <> 'X'",  #CHI-C50068
			  "   AND pmk18 = 'Y'", #CHI-C50068 
              "   AND pml38 = 'Y'"    #FUN-690047 add  #可用/不可用
  IF NOT cl_null(g_sql1) THEN
#    LET l_sql = l_sql CLIPPED, "   AND pml01[1,3]=smyslip",
    LET l_sql = l_sql CLIPPED, "   AND pml01 like smyslip || '-%'",
                               g_sql1 CLIPPED
  END IF
  IF NOT cl_null(g_sql4) THEN
    LET l_sql = l_sql CLIPPED, g_sql4 CLIPPED
  END IF
 
  PREPARE p500_pml_p FROM l_sql
  DECLARE p500_pml_c CURSOR FOR p500_pml_p
  #No.7087 End.A.a.12 -----------------------
 
  CALL p500_mss_0()
  #TQC-660123
  #FOREACH p500_pml_c INTO l_pml01, l_pml02, mss.mss01, fz_flag, l_pml33,
  FOREACH p500_pml_c INTO l_pml01, l_pml02, mss.mss01, fz_flag, l_pml35,
                          mss.mss061, l_pml12, l_pmk25,l_pml09
     IF STATUS THEN CALL err('p500_pml_c',STATUS,1) RETURN END IF
     IF g_sma.sma56='2' AND l_pmk25 MATCHES '[X0]' THEN CONTINUE FOREACH END IF
     IF mss.mss061 <= 0 OR mss.mss061 IS NULL THEN CONTINUE FOREACH END IF
     LET mss.mss02=l_pml12
 
     IF cl_null(l_pml09) THEN LET l_pml09=1 END IF
     LET mss.mss061=mss.mss061*l_pml09
 
     SELECT pmh07 INTO mss.mss02 FROM pmh_file
            WHERE pmh01=mss.mss01 AND pmh02=mss.mss02
              AND pmh21 = " "                                             #CHI-860042                                               
              AND pmh22 = '1'                                             #CHI-860042
              AND pmh23 = ' '                                             #No.CHI-960033
              AND pmhacti = 'Y'                                           #CHI-910021
     SELECT COUNT(*) INTO i FROM part_tmp2
      WHERE partno=mss.mss01 AND ven_no=mss.mss02
     IF i = 0 THEN LET mss.mss02='-' END IF
     IF cl_null(mss.mss02) THEN LET mss.mss02='-' END IF
     LET mss.mss03=past_date
 
     #TQC-660123  
     #IF l_pml33 >= bdate THEN
     IF l_pml35 >= list_date THEN  #FUN-B20060_5 bdate->list_date
        #TQC-660123
        #SELECT plan_date INTO mss.mss03 FROM buk_tmp WHERE real_date=l_pml33
 
        SELECT plan_date INTO mss.mss03 FROM buk_tmp WHERE real_date=l_pml35
        IF STATUS THEN CONTINUE FOREACH END IF
#       IF STATUS THEN RETURN END IF
#       IF STATUS THEN CALL err('sel buk_tmp:',STATUS,1) END IF
     END IF
     IF fz_flag='Y'
        THEN LET mss.mss06_fz=mss.mss061
        ELSE LET mss.mss06_fz=0
     END IF
     LET mss.mssplant=g_plant   #FUN-980004 add
     LET mss.msslegal=g_legal   #FUN-980004 add

#TQC-C20053 --begin--
    IF cl_null(mss.mss13) THEN
      LET mss.mss13 = 'N'
    END IF
#TQC-C20053 --begin--

     INSERT INTO mss_file VALUES(mss.*)
    #IF STATUS AND STATUS<>-239 THEN CALL cl_err('ins mss:',STATUS,1) END IF #TQC-790091 mark
    #TQC-790091 mod---str---
     IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN 
         CALL cl_err('ins mss:',SQLCA.SQLCODE,1) 
     END IF
    #TQC-790091 mod---end---
    #IF SQLCA.SQLCODE=-239 THEN               #TQC-790091 mark
     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #TQC-790091 mod

        EXECUTE p500_p_upd_mss061 using mss.mss061,mss.mss06_fz,
                                        mss.mss_v,mss.mss01,
                                        mss.mss02,mss.mss03
        IF STATUS THEN CALL cl_err('upd mss:',STATUS,1) END IF
     END IF
     LET mst.mst_v=mss.mss_v    # 版本
     LET mst.mst01=mss.mss01    # 料號
     LET mst.mst02=mss.mss02    # 廠商
     LET mst.mst03=mss.mss03    # 日期
     #TQC-660123
     #LET mst.mst04=l_pml33      # 日期
     LET mst.mst04=l_pml35      # 日期
 
     LET mst.mst05='61'         # 供需類別
     LET mst.mst06=l_pml01      # 單號
     LET mst.mst061=l_pml02     # 項次
     LET mst.mst06_fz=fz_flag   # 凍結否
     LET mst.mst07=l_pml12      # 追索料號(上階半/成品)
     LET mst.mst08=mss.mss061   # 數量
     LET mst.mstplant=g_plant   #FUN-980004 add
     LET mst.mstlegal=g_legal   #FUN-980004 add
#No.MOD-9C0278 --Begin
     IF cl_null(mst.mst07) THEN
        LET mst.mst07=' '
     END IF
#No.MOD-9C0278 --End
     #INSERT INTO mst_file VALUES(mst.*)
     #No.TQC-9B0008  --Begin
     IF cl_null(mst.mst09) THEN LET mst.mst09=' ' END IF  #TQC-C20222
     PUT p500_c_ins_mst FROM mst.*
     #No.TQC-9B0008  --End  
     IF STATUS THEN CALL err('ins mst',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
        EXIT PROGRAM END IF
  END FOREACH
  IF STATUS THEN CALL err('p500_pml_c',STATUS,1) RETURN END IF
END FUNCTION
 
FUNCTION p500_mss062_63()       # 彙總 採購量
  DEFINE l_pmn01        LIKE pmn_file.pmn01     #FUN-560221
  DEFINE l_pmn02        LIKE pmn_file.pmn02     #FUN-560221
  DEFINE l_pmn33        LIKE pmn_file.pmn33     #FUN-560221
  DEFINE l_pmn35        LIKE pmn_file.pmn35     #TQC-660123
  DEFINE l_pmn16        LIKE pmn_file.pmn16     #FUN-560221
  DEFINE l_pmm09        LIKE pmm_file.pmm09     #FUN-560221
  DEFINE l_pmm25        LIKE pmm_file.pmm25     #FUN-560221
  DEFINE l_qty          LIKE pmn_file.pmn20     #FUN-560221
 #DEFINE l_sql          LIKE type_file.chr1000  #NO.FUN-680082  VARCHAR(3000)  #MOD-BC0226  mark
  DEFINE l_sql          STRING                  #MOD-BC0226 add

## No:     modify 1998/09/05 ---------
  DEFINE l_pmn09        LIKE pmn_file.pmn09     #採購單位/料件庫存單位的轉換率
##
 
  #"_mss062(彙總採購量)!"
  LET g_msg=cl_getmsg('amr-022',g_lang)
 
  CALL msg(g_msg,'0')
 
  #No.7087 03/04/21 By Jiunn Mod.A.a.13 -----
  # g_sql 限定倉別(imd_file) g_sql1 限定單據(smy_file) g_sql2 限定地址(pmm_file)
 
  #TQC-660123
  #LET l_sql = "SELECT pmn01, pmn02, pmn04, pmn11, pmn33, pmn20-pmn50+pmn55, ",
# LET l_sql = "SELECT pmn01, pmn02, pmn04, pmn11, pmn35, pmn20-pmn50+pmn55, ",        #No.FUN-940083  
  LET l_sql = "SELECT pmn01, pmn02, pmn04, pmn11, pmn35, pmn20-pmn50+pmn55+pmn58, ",  #No.FUN-940083
              "       pmn16, pmm09, pmm25, pmn09 ",
              "  FROM pmn_file,pmm_file,part_tmp"
 #-------------------No.MOD-840702 mark
 #IF NOT cl_null(g_sql) THEN
 #  LET l_sql = l_sql CLIPPED, ",imd_file"
 #END IF
 #-------------------No.MOD-840702 end
  IF NOT cl_null(g_sql1) THEN
    LET l_sql = l_sql CLIPPED, ",smy_file "
  END IF
  LET l_sql = l_sql CLIPPED,
#             " WHERE pmn04=partno AND pmn20>(pmn50-pmn55) ",        #No.FUN-9A0068 mark
              " WHERE pmn04=partno AND pmn20>(pmn50-pmn55-pmn58) ",  #No.FUN-9A0068 
               #MOD-510004
              "   AND (pmn16<='2' OR pmn16='S' OR pmn16='R' OR pmn16='W') ",
              #--
              #TQC-660123
              # "   AND pmn33<='",edate,"'",
              "   AND pmn35<='",edate,"'",
              "   AND pmn01=pmm01 AND pmm02<>'SUB' ",
              "   AND pmn38 ='Y'"    #FUN-690047 add  #可用/不可用
 #-------------------No.MOD-840702 mark
 #IF NOT cl_null(g_sql) THEN
 #  LET l_sql = l_sql CLIPPED, "   AND pmn52=imd01",
 #                             g_sql CLIPPED
 #END IF
 #-------------------No.MOD-840702 end
  IF NOT cl_null(g_sql1) THEN
#    LET l_sql = l_sql CLIPPED, "   AND pmm01[1,3]=smyslip",
    LET l_sql = l_sql CLIPPED, "   AND pmm01 like smyslip || '-%'",  #No.FUN-550055
                               g_sql1 CLIPPED
  END IF
  IF NOT cl_null(g_sql2) THEN
    LET l_sql = l_sql CLIPPED, g_sql2 CLIPPED
  END IF
 
  PREPARE p500_pmn_p FROM l_sql
  DECLARE p500_pmn_c CURSOR FOR p500_pmn_p
  #No.7087 End.A.a.13 -----------------------
 
  CALL p500_mss_0()
  # TQC-660123
  # FOREACH p500_pmn_c INTO l_pmn01, l_pmn02, mss.mss01, fz_flag, l_pmn33,
  FOREACH p500_pmn_c INTO l_pmn01, l_pmn02, mss.mss01, fz_flag, l_pmn35,
                          l_qty, l_pmn16, l_pmm09, l_pmm25,l_pmn09
     IF STATUS THEN CALL err('p500_pmn_c',STATUS,1) RETURN END IF
     IF g_sma.sma57='2' AND l_pmm25 MATCHES '[X0]' THEN CONTINUE FOREACH END IF
     IF l_qty <= 0 OR l_qty IS NULL THEN CONTINUE FOREACH END IF
     LET mss.mss02=l_pmm09
     SELECT pmh07 INTO mss.mss02 FROM pmh_file
            WHERE pmh01=mss.mss01 AND pmh02=mss.mss02
              AND pmh21 = " "                                             #CHI-860042                                               
              AND pmh22 = '1'                                             #CHI-860042
              AND pmh23 = ' '                                             #No.CHI-960033
              AND pmhacti = 'Y'                                           #CHI-910021
     SELECT COUNT(*) INTO i FROM part_tmp2
      WHERE partno=mss.mss01 AND ven_no=mss.mss02
     IF i = 0 THEN LET mss.mss02='-' END IF
     IF cl_null(mss.mss02) THEN LET mss.mss02='-' END IF
     LET mss.mss03=past_date
     #TQC-660123
     #IF l_pmn33 >= bdate THEN
     IF l_pmn35 >= list_date THEN  #FUN-B20060_5 bdate->list_date
        # TQC-660123
        # SELECT plan_date INTO mss.mss03 FROM buk_tmp WHERE real_date=l_pmn33
        SELECT plan_date INTO mss.mss03 FROM buk_tmp WHERE real_date=l_pmn35
        IF STATUS THEN CONTINUE FOREACH END IF
#       IF STATUS THEN RETURN END IF
#       IF STATUS THEN CALL err('sel buk_tmp:',STATUS,1) END IF
     END IF
     IF cl_null(l_pmn09) THEN LET l_pmn09=1 END IF
     LET l_qty=l_qty * l_pmn09
 
     #IF l_pmn16<'2'
      #MOD-510004
     IF (l_pmn16<'2' OR l_pmn16='S' OR l_pmn16='R' OR l_pmn16='W')
     #--
        THEN LET mss.mss062=l_qty LET mss.mss063=0
        ELSE LET mss.mss062=0     LET mss.mss063=l_qty
     END IF
 
     IF fz_flag='Y'
        THEN LET mss.mss06_fz=l_qty
        ELSE LET mss.mss06_fz=0
     END IF
     LET mss.mssplant=g_plant   #FUN-980004 add
     LET mss.msslegal=g_legal   #FUN-980004 add

#TQC-C20053 --begin--
    IF cl_null(mss.mss13) THEN
      LET mss.mss13 = 'N'
    END IF
#TQC-C20053 --begin--

     INSERT INTO mss_file VALUES(mss.*)
    #IF STATUS AND STATUS<>-239 THEN CALL cl_err('ins mss:',STATUS,1) END IF #TQC-790091 mark
    #TQC-790091 mod---str---
     IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN 
         CALL cl_err('ins mss:',SQLCA.SQLCODE,1) 
     END IF
    #TQC-790091 mod---end---
    #IF SQLCA.SQLCODE=-239 THEN               #TQC-790091 mark
     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #TQC-790091 mod

        EXECUTE p500_p_upd_mss062 using mss.mss062,mss.mss063,mss.mss06_fz,
                                        mss.mss_v,mss.mss01,
                                        mss.mss02,mss.mss03
        IF STATUS THEN CALL cl_err('upd mss:',STATUS,1) END IF
     END IF
     LET mst.mst_v=mss.mss_v    # 版本
     LET mst.mst01=mss.mss01    # 料號
     LET mst.mst02=mss.mss02    # 廠商
     LET mst.mst03=mss.mss03    # 日期
     #TQC-660123
     #LET mst.mst04=l_pmn33      # 日期
     LET mst.mst04=l_pmn35      # 日期
 
     #IF l_pmn16<'2'
      #MOD-510004
     IF (l_pmn16<'2' OR l_pmn16='S' OR l_pmn16='R' OR l_pmn16='W')
     #--
        THEN LET mst.mst05='62' # 供需類別 (在採)
        ELSE LET mst.mst05='63' # 供需類別 (在外)
     END IF
     LET mst.mst06=l_pmn01      # 單號
     LET mst.mst061=l_pmn02     # 項次
     LET mst.mst06_fz=fz_flag   # 凍結否
     LET mst.mst07=l_pmm09      # 追索料號(上階半/成品)
     LET mst.mst08=l_qty        # 數量
     LET mst.mstplant=g_plant   #FUN-980004 add
     LET mst.mstlegal=g_legal   #FUN-980004 add
#No.MOD-9C0278 --Begin
     IF cl_null(mst.mst07) THEN
        LET mst.mst07=' '
     END IF
#No.MOD-9C0278 --End
     #INSERT INTO mst_file VALUES(mst.*)
     #No.TQC-9B0008  --Begin
     IF cl_null(mst.mst09) THEN LET mst.mst09=' ' END IF  #TQC-C20222
     PUT p500_c_ins_mst FROM mst.*
     #No.TQC-9B0008  --End  
     IF STATUS THEN CALL err('ins mst',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
        EXIT PROGRAM END IF
  END FOREACH
  IF STATUS THEN CALL err('p500_pmn_c',STATUS,1) RETURN END IF
END FUNCTION
 
FUNCTION p500_mss064()  # 彙總 在製量
  DEFINE l_sfb01        LIKE sfb_file.sfb01    #FUN-560221
  DEFINE l_sfb15        LIKE sfb_file.sfb15    #FUN-560221
 #DEFINE l_sql          LIKE type_file.chr1000 #NO.FUN-680082  VARCHAR(3000)  #MOD-BC0226  mark
  DEFINE l_sql          STRING                 #MOD-BC0226 add
## No:     modify 1998/09/05 ---------
  DEFINE l_ima55_fac    LIKE ima_file.ima55_fac   #生產單位/庫存單位換算率
##
 
  #"_mss064(彙總在製量)!"
  LET g_msg=cl_getmsg('amr-023',g_lang)
 
  CALL msg(g_msg,'0')
 
  #No.7087 03/04/21 By Jiunn Add.A.a.16 -----
  # sql1 限定單據(smy_file)
#TQC-9A0127-Mark-Begin
# LET l_sql = "SELECT sfb01, sfb05, sfb41, sfb15, sfb08-sfb09,ima55_fac",
#             "  FROM sfb_file,part_tmp,OUTER ima_file"
# IF NOT cl_null(g_sql1) THEN
#   LET l_sql = l_sql CLIPPED, ",smy_file"
# END IF
#TQC-9A0127-Mark-End
#TQC-9A0127-Add-Begin
  IF NOT cl_null(g_sql1) THEN
    #LET l_sql = "SELECT sfb01, sfb05, sfb41, sfb15, sfb08-sfb09,ima55_fac",
     LET l_sql = "SELECT sfb01, sfb05, sfb41, sfb15, sfb08-sfb09-sfb12,ima55_fac",  #Mod No:MOD-AC0126
                 "  FROM part_tmp,smy_file,sfb_file LEFT OUTER JOIN ima_file ON sfb05=ima01"
  ELSE
    #LET l_sql = "SELECT sfb01, sfb05, sfb41, sfb15, sfb08-sfb09,ima55_fac",
     LET l_sql = "SELECT sfb01, sfb05, sfb41, sfb15, sfb08-sfb09-sfb12,ima55_fac",  #Mod No:MOD-AC0126
                 "  FROM part_tmp,sfb_file LEFT OUTER JOIN ima_file ON sfb05=ima01"   
  END IF
#TQC-9A0127-Add-End
  LET l_sql = l_sql CLIPPED,
              " WHERE sfb05=partno AND sfb08>sfb09 AND sfb04 < '8'",
#             "   AND sfb15<='",edate,"' AND ima_file.ima01=sfb_file.sfb05 AND sfb87 <> 'X'",             #TQC-9A0127 Mark
              "   AND sfb15<='",edate,"' AND sfb87 <> 'X'",                                               #TQC-9A0127 Add
              "   AND sfb02!='15'"   #FUN-660110 add
  IF NOT cl_null(g_sql1) THEN
#    LET l_sql = l_sql CLIPPED, "   AND sfb01[1,3]=smyslip",
    LET l_sql = l_sql CLIPPED, "   AND sfb01 like smyslip || '-%'",  #No.FUN-550055
                               g_sql1 CLIPPED
  END IF
 
  PREPARE p500_sfb_p FROM l_sql
  DECLARE p500_sfb_c CURSOR FOR p500_sfb_p
 
  CALL p500_mss_0()
  FOREACH p500_sfb_c INTO l_sfb01, mss.mss01, fz_flag, l_sfb15, mss.mss064,
                          l_ima55_fac
     IF STATUS THEN CALL err('p500_sfb_c',STATUS,1) RETURN END IF
     IF mss.mss064 <= 0 OR mss.mss064 IS NULL THEN CONTINUE FOREACH END IF
     LET mss.mss02='-'
     LET mss.mss03=past_date
     IF l_sfb15 >= list_date THEN #FUN-B20060_5 bdate->list_date
        SELECT plan_date INTO mss.mss03 FROM buk_tmp WHERE real_date=l_sfb15
        IF STATUS THEN CONTINUE FOREACH END IF
     END IF
     IF cl_null(l_ima55_fac) THEN LET l_ima55_fac=1 END IF
## No:2423  modify 1998/09/04 -(統一單位為庫存單位)-------
     LET mss.mss064=mss.mss064*l_ima55_fac
     IF fz_flag='Y'
        THEN
            LET mss.mss06_fz=mss.mss064
        ELSE
            LET mss.mss06_fz=0
     END IF
     LET mss.mssplant=g_plant   #FUN-980004 add
     LET mss.msslegal=g_legal   #FUN-980004 add

#TQC-C20053 --begin--
    IF cl_null(mss.mss13) THEN
      LET mss.mss13 = 'N'
    END IF
#TQC-C20053 --begin--

     INSERT INTO mss_file VALUES(mss.*)
     IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN 
         CALL cl_err('ins mss:',SQLCA.SQLCODE,1) 
     END IF
     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #TQC-790091 mod

        EXECUTE p500_p_upd_mss064 using mss.mss064,mss.mss06_fz,
                                        mss.mss_v,mss.mss01,
                                        mss.mss02,mss.mss03
        IF STATUS THEN CALL cl_err('upd mss:',STATUS,1) END IF
     END IF
     LET mst.mst_v=mss.mss_v    # 版本
     LET mst.mst01=mss.mss01    # 料號
     LET mst.mst02=mss.mss02    # 廠商
     LET mst.mst03=mss.mss03    # 日期
     LET mst.mst04=l_sfb15      # 日期
     LET mst.mst05='64'         # 供需類別
     LET mst.mst06=l_sfb01      # 單號
     LET mst.mst061=NULL        # 項次
     LET mst.mst06_fz=fz_flag   # 凍結否
     LET mst.mst07=NULL         # 追索料號(上階半/成品)
     LET mst.mst08=mss.mss064   # 數量
     LET mst.mstplant=g_plant   #FUN-980004 add
     LET mst.mstlegal=g_legal   #FUN-980004 add
     IF cl_null(mst.mst07) THEN
        LET mst.mst07=' '
     END IF
     IF cl_null(mst.mst09) THEN LET mst.mst09=' ' END IF  #TQC-C20222
     PUT p500_c_ins_mst FROM mst.*
     IF STATUS THEN CALL err('ins mst',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
        EXIT PROGRAM END IF
  END FOREACH
  IF STATUS THEN CALL err('p500_sfb_c',STATUS,1) RETURN END IF
END FUNCTION
 
FUNCTION p500_mss065()  # 彙總 計劃產出量
  DEFINE l_ima55_fac    LIKE ima_file.ima55_fac #生產單位/庫存單位換算率
 #DEFINE l_sql          LIKE type_file.chr1000  #NO.FUN-680082  VARCHAR(3000)  #MOD-BC0226  mark
  DEFINE l_sql          STRING                  #MOD-BC0226 add
  DEFINE l_sfb08        LIKE sfb_file.sfb08     #No.MOD-830020 add
  DEFINE l_sfb09        LIKE sfb_file.sfb09     #No.MOD-830020 add
 
  #"_mss065(彙總計劃產出量)!"
  LET g_msg=cl_getmsg('amr-024',g_lang)
 
  CALL msg(g_msg,'0')
  IF msb_expl='N' THEN RETURN END IF
 
  # sql1 限定單據(smy_file)
  LET l_sql = "SELECT msb_file.*,ima55_fac",
#             "  FROM msb_file,msa_file,part_tmp,OUTER ima_file"                                     #TQC-9A0127 Mark
              "  FROM msa_file,part_tmp,msb_file LEFT OUTER JOIN ima_file ON msb03=ima01"            #TQC-9A0127 Add   
  LET l_sql = l_sql CLIPPED,
              " WHERE msb03=partno ",                                                                #TQC-9A0127 Add 
              "   AND msb01=msa01 AND msb04 <= '",edate,"' AND msa03='N'",
              "   AND msa05 <> 'X' "  #CHI-C80041
 
 
  IF NOT cl_null(g_sql3) THEN
     LET l_sql = l_sql CLIPPED, g_sql3 CLIPPED
  END IF
 
 
  PREPARE p500_msb_p4 FROM l_sql
  DECLARE p500_msb_c4 CURSOR FOR p500_msb_p4
  CALL p500_mss_0()
  FOREACH p500_msb_c4 INTO msb.*,l_ima55_fac
     IF STATUS THEN CALL cl_err('msb_c4:',STATUS,1) RETURN END IF
 
     SELECT SUM(sfb08) INTO l_sfb08 FROM sfb_file
      WHERE sfb22=msb.msb01 AND sfb221=msb.msb02
        AND sfb04 != '8' AND sfb87!='X'  #未結案者, 以開工量為準
        AND sfb02 NOT IN ('11','15')     #MOD-CA0138 add 11   
     IF l_sfb08 IS NULL THEN LET l_sfb08=0 END IF
 
     SELECT SUM(sfb09) INTO l_sfb09 FROM sfb_file
      WHERE sfb22=msb.msb01 AND sfb221=msb.msb02
        AND sfb04  = '8' AND sfb87!='X'   #已結案者, 以完工量為準
        AND sfb02 NOT IN ('11','15')      #MOD-CA0138 add 11   
     IF l_sfb09 IS NULL THEN LET l_sfb09=0 END IF
 
     LET g_qty = l_sfb08 + l_sfb09
     LET mss.mss065=msb.msb05-g_qty
     IF mss.mss065 <= 0 OR mss.mss065 IS NULL THEN CONTINUE FOREACH END IF
 
     IF cl_null(l_ima55_fac) THEN LET l_ima55_fac=1 END IF
## No:2423  modify 1998/09/04 -(統一單位為庫存單位)-------
     LET mss.mss065=mss.mss065*l_ima55_fac
 
     LET mss.mss01=msb.msb03
     LET mss.mss02='-'
     LET mss.mss03=past_date
     IF msb.msb04 >= list_date THEN  #FUN-B20060_5 bdate->list_date
        SELECT plan_date INTO mss.mss03 FROM buk_tmp WHERE real_date=msb.msb04
        IF STATUS THEN CONTINUE FOREACH END IF
#       IF STATUS THEN RETURN END IF
#       IF STATUS THEN CALL err('sel buk_tmp:',STATUS,1) END IF
     END IF
     LET mss.mssplant=g_plant   #FUN-980004 add
     LET mss.msslegal=g_legal   #FUN-980004 add

#TQC-C20053 --begin--
    IF cl_null(mss.mss13) THEN
      LET mss.mss13 = 'N'
    END IF
#TQC-C20053 --begin--

     INSERT INTO mss_file VALUES(mss.*)
     IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN 
         CALL cl_err('ins mss:',SQLCA.SQLCODE,1) 
     END IF
     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #TQC-790091 mod

        EXECUTE p500_p_upd_mss065 using mss.mss065,mss.mss_v,mss.mss01,
                                        mss.mss02,mss.mss03
        IF STATUS THEN CALL cl_err('upd mss:',STATUS,1) END IF
     END IF
     LET mst.mst_v=mss.mss_v    # 版本
     LET mst.mst01=mss.mss01    # 料號
     LET mst.mst02=mss.mss02    # 廠商
     LET mst.mst03=mss.mss03    # 日期
     LET mst.mst04=msb.msb04    # 日期
     LET mst.mst05='65'         # 供需類別
     LET mst.mst06=msb.msb01    # 單號
     LET mst.mst061=msb.msb02   # 項次
     LET mst.mst06_fz=NULL      # 凍結否
     LET mst.mst07=NULL         # 追索料號(上階半/成品)
     LET mst.mst08=mss.mss065   # 數量
     LET mst.mstplant=g_plant   #FUN-980004 add
     LET mst.mstlegal=g_legal   #FUN-980004 add
     IF cl_null(mst.mst07) THEN
        LET mst.mst07=' '
     END IF
     IF cl_null(mst.mst09) THEN LET mst.mst09=' ' END IF  #TQC-C20222
     PUT p500_c_ins_mst FROM mst.*
     IF STATUS THEN CALL err('ins mst',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
        EXIT PROGRAM END IF
  END FOREACH
  IF STATUS THEN CALL cl_err('msb_c4:',STATUS,1) RETURN END IF
END FUNCTION
 
FUNCTION p500_plan()    # M.R.P. (M.R.P. By Lot)
  DEFINE l_x_mss_v   LIKE mss_file.mss_v
  DEFINE l_x_mss01   LIKE mss_file.mss01
  DEFINE l_x_mss02   LIKE mss_file.mss02
  DEFINE l_x_mss03   LIKE mss_file.mss03
  DEFINE l_name         LIKE type_file.chr20    #NO.FUN-680082  VARCHAR(20)   # External(Disk) file name
  DEFINE l_cmd          LIKE type_file.chr1000  #NO.FUN-680082  VARCHAR(30)
  DEFINE l_sql       STRING   #CHI-C80002
  
  DECLARE low_level_code CURSOR FOR
     SELECT ima16 FROM part_tmp,ima_file
         WHERE partno=ima01 AND imaacti='Y' AND ima08<>'X'
         GROUP BY ima16 ORDER BY ima16

  #CHI-C80002---begin
  #mss_v 模拟版本
  #mss01 料号
  #mss02 限定厂商编号
  #mss03 供需日期
  #ima16 低阶码                      /*每一料件应皆有其低阶码, 如果为产品结构 */
                                     /*中的最上阶, 其低阶码将被系统设定为 '0' */
                                     /*, 而非在产品结构中最上阶者, 其阶数将按 */
                                     /*其由最上阶往下累计最大者为其低阶码; 其 */
                                     /*它无产品结构者, 其阶数亦将被设定为 '0' */
                                     /*新增料件设定初始值为 '99', 日后可透过  */
                                     /*低阶码计算作业 而得其所在阶数          */
                                     /*系统维护                               */
  #sub_flag 是否处理取替代料   

  LET l_sql = " SELECT mss_v,mss01,mss02,mss03 FROM mss_file,ima_file ",
              " WHERE mss_v=? AND mss01=ima01 AND ima16=? "
  PREPARE p500_plan_p FROM l_sql
  DECLARE p500_plan_c CURSOR FOR p500_plan_p
  #CHI-C80002---end     
  LET g_n=0
  LET g_mss00=0

  CALL cl_outnam('amrp500') RETURNING l_name    #MOD-B70066 add 
  FOREACH low_level_code INTO g_ima16
     IF STATUS THEN CALL cl_err('low level:',STATUS,1) EXIT FOREACH END IF
     IF cl_null(g_argv1) THEN
        IF g_bgjob = 'N' THEN   #MOD-A30082 add
           MESSAGE "Low Level:",g_ima16,"       "
           CALL ui.Interface.refresh()
        END IF   #MOD-A30082 add
     END IF
     IF sub_flag='Y' THEN
       LET g_msg='_plan_sub:',g_ima16 USING '<<<' CALL msg(g_msg,'0')
       CALL p500_plan_sub()
       CALL p500_plan_sub_1()    #FUN-A20037 
     END IF
     LET g_msg='_plan:',g_ima16 USING '<<<' CALL msg(g_msg,'0')
     #CHI-C80002---begin mark
     #DECLARE p500_plan_c CURSOR FOR
     #  SELECT mss_v,mss01,mss02,mss03 FROM mss_file,ima_file
     #   WHERE mss_v=ver_no AND mss01=ima01 AND ima16=g_ima16
     #CHI-C80002---end
#    CALL cl_outnam('amrp500') RETURNING l_name    #bugno:5522   #MOD-B70066 mark
     START REPORT p500_rep TO l_name               #bugno:5522
 
     #FOREACH p500_plan_c INTO l_x_mss_v,l_x_mss01,l_x_mss02,l_x_mss03  #CHI-C80002
     FOREACH p500_plan_c USING ver_no,g_ima16 INTO l_x_mss_v,l_x_mss01,l_x_mss02,l_x_mss03  #CHI-C80002
        IF STATUS THEN CALL err('p500_plan_c',STATUS,1) EXIT FOREACH END IF
        SELECT * INTO mss.* FROM mss_file
        WHERE mss_v=l_x_mss_v AND mss01=l_x_mss01 AND mss02=l_x_mss02 AND mss03=l_x_mss03
        OUTPUT TO REPORT p500_rep(l_x_mss_v,l_x_mss01,l_x_mss02,l_x_mss03, mss.*,'Y')  #No.MOD-880201 add 'Y'
     END FOREACH
     IF STATUS THEN CALL err('p500_plan_c',STATUS,1) END IF
     FINISH REPORT p500_rep
     IF os.Path.chrwx(l_name CLIPPED,511) THEN END IF   #No.FUN-9C0009 
  END FOREACH
  IF STATUS THEN CALL cl_err('low level:',STATUS,1) END IF
END FUNCTION
 
REPORT p500_rep(p_mss_v,p_mss01,p_mss02,p_mss03, mss,l_chr)     #No.MOD-880201 add l_chr
  DEFINE p_mss_v   LIKE mss_file.mss_v
  DEFINE p_mss01   LIKE mss_file.mss01
  DEFINE p_mss02   LIKE mss_file.mss02
  DEFINE p_mss03   LIKE mss_file.mss03
  DEFINE bal            LIKE mst_file.mst08     #NO.FUN-680082  DEC(15,3)
  DEFINE qty2           LIKE mst_file.mst08     #NO.FUN-680082  DEC(15,3)
  DEFINE l_ima08        LIKE type_file.chr1     #NO.FUN-680082  VARCHAR(1)
  DEFINE l_ima45,l_ima46,l_ima47        LIKE ima_file.ima45   #NO.FUN-680082  DEC(12,3)
  DEFINE l_ima56,l_ima561,l_ima562      LIKE ima_file.ima56   #NO.FUN-680082  DEC(12,3)
  DEFINE l_ima50        LIKE ima_file.ima50     #NO.FUN-680082  SMALLINT  #No.MOD-7B0015 modify
  DEFINE l_ima59        LIKE ima_file.ima59     #NO.FUN-680082  DEC(9,3)
  DEFINE l_ima60        LIKE ima_file.ima60     #NO.FUN-680082  DEC(9,3)
  DEFINE l_ima601       LIKE ima_file.ima601    #NO.FUN-680082  DEC(9,3)  #No.FUN-840194
  DEFINE l_ima61        LIKE ima_file.ima61     #NO.FUN-680082  DEC(9,3)
  DEFINE l_ima72        LIKE type_file.num5     #NO.FUN-680082  SMALLINT
  DEFINE l_ima910       LIKE ima_file.ima910    #No.MOD-6A0141 add
  DEFINE l_ima25        LIKE ima_file.ima25
  DEFINE l_ima44        LIKE ima_file.ima44
  DEFINE l_ima55        LIKE ima_file.ima55
  DEFINE l_mss09        LIKE mss_file.mss09
  DEFINE rrr            DYNAMIC ARRAY OF RECORD
                        mss_v     LIKE mss_file.mss_v,
                        mss01     LIKE mss_file.mss01,
                        mss02     LIKE mss_file.mss02,
                        mss03     LIKE mss_file.mss03                                                                                     
                        END RECORD
  DEFINE mss            RECORD LIKE mss_file.*
  DEFINE sss            DYNAMIC ARRAY OF RECORD LIKE mss_file.*
  DEFINE l_gfe03        LIKE gfe_file.gfe03 #FUN-670074
  DEFINE l_chr          LIKE type_file.chr1 #No.MOD-880201 
  DEFINE bal1           LIKE mst_file.mst08   #MOD-C50171 add
  DEFINE bal2           LIKE mst_file.mst08   #CHI-C50068
  DEFINE l_ima721       LIKE ima_file.ima721  #CHI-C50068

  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY mss.mss01,mss.mss02,mss.mss03
  FORMAT
    BEFORE GROUP OF mss.mss01
      SELECT ima08,ima45,ima46,ima47,ima50+ima48+ima49+ima491,
                   ima56,ima561,ima562,
                   ima59,ima60,ima601,ima61,ima72,ima721,  #FUN-840194 add ima601  #CHI-C50068
                   ima25,ima44,ima55                   #No.TQC-740336 add
        INTO l_ima08,l_ima45,l_ima46,l_ima47,l_ima50,
                     l_ima56,l_ima561,l_ima562,
                     l_ima59,l_ima60,l_ima601,l_ima61,l_ima72,l_ima721,  #FUN-840194 add l_ima601  #CHI-C50068
                     l_ima25,l_ima44,l_ima55           #No.TQC-740336 add
       FROM ima_file
      WHERE ima01=mss.mss01
      IF l_ima45 IS NULL THEN LET l_ima45=0 END IF
      IF l_ima46 IS NULL THEN LET l_ima46=0 END IF
      IF l_ima47 IS NULL THEN LET l_ima47=0 END IF
      IF l_ima50 IS NULL THEN LET l_ima50=0 END IF
      IF l_ima56 IS NULL THEN LET l_ima56=0 END IF
      IF l_ima561 IS NULL THEN LET l_ima561=0 END IF
      IF l_ima562 IS NULL THEN LET l_ima562=0 END IF
      IF l_ima59 IS NULL THEN LET l_ima59=0 END IF
      IF l_ima60 IS NULL THEN LET l_ima60=0 END IF
      IF l_ima61 IS NULL THEN LET l_ima61=0 END IF
      IF l_ima72 IS NULL THEN LET l_ima72=0 END IF
      IF l_ima721 IS NULL THEN LET l_ima721=0 END IF  #CHI-C50068
      IF STATUS THEN
         LET l_ima45=0 LET l_ima46=0 LET l_ima47=0 LET l_ima50=0
         LET l_ima56=0 LET l_ima561=0 LET l_ima562=0
         LET l_ima59=0 LET l_ima60=0 LET l_ima61=0
      END IF
      IF l_ima08='M' OR l_ima08='S' OR l_ima08='T' THEN   #MOD-940282
         LET l_ima50=l_ima59+l_ima60/l_ima601*mss.mss09+l_ima61  #CHI-810015 mark還原 
         LET l_ima47=l_ima562
         LET l_ima45=l_ima56
         LET l_ima46=l_ima561
         LET l_ima44=l_ima55         #No.TQC-740336 add
      END IF
      IF l_ima08='P' THEN
         CASE WHEN po_days>0 LET l_ima72=po_days
              WHEN po_days=0 LET l_ima72=po_days
              WHEN po_days<0 LET l_ima72=l_ima72
         END CASE
         #CHI-C50068---begin
         CASE WHEN po_days1>0 LET l_ima721=po_days1
              WHEN po_days1=0 LET l_ima721=po_days1
              WHEN po_days1<0 LET l_ima721=l_ima721
         END CASE
         #CHI-C50068---end
      END IF
      IF l_ima08='M' OR l_ima08='S' OR l_ima08='T' THEN       #No.MOD-680009 modify   #MOD-910232
         CASE WHEN wo_days>0 LET l_ima72=wo_days
              WHEN wo_days=0 LET l_ima72=wo_days
              WHEN wo_days<0 LET l_ima72=l_ima72
         END CASE
         #CHI-C50068---begin
         CASE WHEN wo_days1>0 LET l_ima721=wo_days1
              WHEN wo_days1=0 LET l_ima721=wo_days1
              WHEN wo_days1<0 LET l_ima721=l_ima721
         END CASE
         #CHI-C50068---end
      END IF
    BEFORE GROUP OF mss.mss02
     #str MOD-A70183 mod
     #FOR i = 1 TO 100
     #   LET rrr[i].mss_v=NULL
     #   LET rrr[i].mss01=NULL
     #   LET rrr[i].mss02=NULL
     #   LET rrr[i].mss03=NULL
     #   INITIALIZE sss[i].* TO NULL
     #END FOR
      CALL rrr.clear()
      CALL sss.clear()
     #end MOD-A70183 mod
      LET i = 0
      LET g_n=g_n+1
      IF g_bgjob = 'N' THEN   #MOD-A30082 add
         MESSAGE g_n
         CALL ui.Interface.refresh()
      END IF   #MOD-A30082 add

    ON EVERY ROW
      IF l_chr = 'Y' THEN   #MOD-910231
         LET g_mss00=g_mss00+1
      END IF   #MOD-910231
      LET i = i+1

#     LET rrr[i].x_rowid=p_rowid  
      LET rrr[i].mss_v=p_mss_v
      LET rrr[i].mss01=p_mss01
      LET rrr[i].mss02=p_mss02
      LET rrr[i].mss03=p_mss03

      LET sss[i].*    =mss.*
      IF l_chr = 'Y' THEN   #MOD-910231
         LET sss[i].mss00=g_mss00
      END IF   #MOD-910231

    AFTER GROUP OF mss.mss02
      LET bal=0
     #FOR i = 1 TO 100              #MOD-A70183 mark
      FOR i = 1 TO sss.getLength()  #MOD-A70183
        IF sss[i].mss01 IS NULL THEN EXIT FOR END IF
        LET bal=bal
               +sss[i].mss051+sss[i].mss052+sss[i].mss053
               +sss[i].mss061+sss[i].mss062+sss[i].mss063
               +sss[i].mss064+sss[i].mss065
               -sss[i].mss041-sss[i].mss043-sss[i].mss044
               -sss[i].mss071+sss[i].mss072
        IF bal < 0 THEN
         #DISPLAY 'bal < 0 check-->',i #MOD-960299       
         #FOR j = i+1 TO 100             # 請/採購交期, 工單完工日調整   #MOD-A70183 mark
          FOR j = i+1 TO sss.getLength() # 請/採購交期, 工單完工日調整   #MOD-A70183
            IF sss[j].mss01 IS NULL THEN EXIT FOR END IF
            IF sss[j].mss03 > sss[i].mss03+l_ima72 THEN EXIT FOR END IF
            LET qty2=sss[j].mss061+sss[j].mss062+sss[j].mss063+sss[j].mss064
                    -sss[j].mss06_fz                    # 扣除Frozen凍結量
                    -sss[j].mss071+sss[j].mss072
            IF qty2 <= 0 THEN CONTINUE FOR END IF
            IF qty2 >= bal*-1
               THEN 
                   #MOD-C50171 -- add start --
                    LET bal1 = bal * -1
                    IF l_ima47 != 0 THEN                         # 採購/製造損耗率
                       LET bal1 = bal1 * (100+l_ima47)/100
                    END IF
                    IF l_ima45 != 0 THEN                         # 採購/製造倍量
                    #  LET k = (bal1 / l_ima45) + 0.999          #No.MOD-C50252
                       LET k = (bal1 / l_ima45) + 0.9999999      #No.MOD-C50252
                       LET bal1 = l_ima45 * k
                    END IF
                    IF bal1 < l_ima46 THEN               # 最小採購/製造量
                       LET bal1 = l_ima46
                    END IF
                    LET sss[j].mss071 = sss[j].mss071 + bal1
                    LET sss[i].mss072 = sss[i].mss072 + bal1
                    LET bal = bal + bal1
                   #MOD-C50171 -- add end --
                   #MOD-C50171 -- mark start --  
                   #LET sss[j].mss071=sss[j].mss071+bal*-1
                   #LET sss[i].mss072=sss[i].mss072+bal*-1
                   #LET bal=0
                   #MOD-C50171 -- mark end --
                    EXIT FOR
               ELSE LET sss[j].mss071=sss[j].mss071+qty2
                    LET sss[i].mss072=sss[i].mss072+qty2
                    LET bal=bal+qty2
            END IF
          END FOR
        END IF
        LET sss[i].mss08=bal
        IF sss[i].mss08 < 0 THEN                        #-> plan order
           LET sss[i].mss09=sss[i].mss08*-1
 
           LET l_mss09 = sss[i].mss09
           #若庫存單位與採購/生產單位不一樣時才推算數量
           IF l_ima25 != l_ima44 THEN      
              CALL p500_che_qty(mss.mss01,l_ima25,l_ima44,l_mss09)
                                RETURNING l_mss09
           END IF
           IF l_ima47 != 0 THEN                         # 採購/製造損耗率
              LET l_mss09 = l_mss09 * (100+l_ima47)/100
           END IF
           IF l_ima45 != 0 THEN                         # 採購/製造倍量
           #  LET k = (l_mss09 / l_ima45) + 0.999       #No.MOD-C50252
              LET k = (l_mss09 / l_ima45) + 0.9999999   #No.MOD-C50252
              LET l_mss09 = l_ima45 * k
           END IF
           IF l_mss09 < l_ima46 THEN               # 最小採購/製造量
              LET l_mss09 = l_ima46
           END IF
           IF l_ima25 != l_ima44 THEN
              CALL p500_che_qty(mss.mss01,l_ima44,l_ima25,l_mss09) 
                                RETURNING l_mss09
           END IF
          LET l_gfe03=NULL
          SELECT gfe03 INTO l_gfe03 FROM ima_file,gfe_file
                                   WHERE ima01=sss[i].mss01
                                     AND ima55=gfe01
          IF NOT cl_null(l_gfe03) THEN
             LET sss[i].mss09=cl_digcut(l_mss09,l_gfe03)
          ELSE                            #No.MOD-8A0046 add
             LET sss[i].mss09 = l_mss09   #No.MOD-8A0046 add  #從下面移上來
          END IF
 
           LET needdate=NULL

           IF needdate IS NULL THEN LET needdate=sss[i].mss03 END IF
 
           IF l_ima08='M' OR l_ima08='S' OR l_ima08='T' THEN   #MOD-940282
               LET l_ima50=l_ima59+l_ima60/l_ima601*sss[i].mss09+l_ima61    #CHI-810015 mark還原 
            END IF
           LET sss[i].mss11=s_aday(needdate,-1,l_ima50)  # 減採購/製造前置日數
            IF sss[i].mss11 > sss[i].mss03 THEN
               LET sss[i].mss11=sss[i].mss03
            END IF
 
        END IF
        LET l_ima910=''
        SELECT ima910 INTO l_ima910 FROM ima_file WHERE ima01=sss[i].mss01
        IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF
        IF l_chr = 'Y' THEN  #No.MOD-880201  
           IF sss[i].mss09>0 AND (l_ima08='M' OR l_ima08='S' OR l_ima08='T') THEN
              CALL p500_mss045(sss[i].mss00,sss[i].mss01,
                               sss[i].mss11,needdate,sss[i].mss09,l_ima910,0)       #No.MOD-6A0141 modify  #No.MOD-8B0259 add 0
           END IF
        END IF               #No.MOD-880201    
        LET bal=sss[i].mss08+sss[i].mss09
        EXECUTE p500_p_upd_mss using sss[i].*,rrr[i].*
        IF SQLCA.SQLCODE THEN
           IF g_bgjob = 'N' THEN   #MOD-A30082 add
              MESSAGE sss[i].mss01,' ',sss[i].mss03
              CALL ui.Interface.refresh()
              CALL err('plan:upd mss:',SQLCA.SQLCODE,1)
           END IF   #MOD-A30082 add
        END IF
      END FOR

      #CHI-C50068---begin
      #交期延後
      LET bal = 0
      FOR i = 1 TO sss.getLength() 
        IF sss[i].mss01 IS NULL THEN EXIT FOR END IF
        LET bal=bal
               +sss[i].mss051+sss[i].mss052+sss[i].mss053
               +sss[i].mss061+sss[i].mss062+sss[i].mss063
               +sss[i].mss064+sss[i].mss065
               -sss[i].mss041-sss[i].mss043-sss[i].mss044
               -sss[i].mss071+sss[i].mss072
            LET qty2=sss[i].mss061+sss[i].mss062+sss[i].mss063+sss[i].mss064
                    -sss[i].mss06_fz                    # 扣除Frozen凍結量
                    -sss[i].mss071                      
        IF bal > 0 AND qty2 > 0 AND bal-qty2 > 0 THEN  
          FOR j = i+1 TO sss.getLength() # 請/採購交期, 工單完工日調整 
            IF sss[j].mss01 IS NULL THEN EXIT FOR END IF
            IF sss[j].mss03 > sss[i].mss03+l_ima721 THEN EXIT FOR END IF
            LET bal2 = sss[j].mss08 - qty2 
            IF bal2 > 0 THEN CONTINUE FOR END IF
            IF qty2 >= bal2*-1
               THEN 
                    LET bal1 = bal2 * -1
                    IF l_ima47 != 0 THEN                         # 採購/製造損耗率
                       LET bal1 = bal1 * (100+l_ima47)/100
                    END IF
                    IF l_ima45 != 0 THEN                         # 採購/製造倍量
                       LET k = (bal1 / l_ima45) + 0.999
                       LET bal1 = l_ima45 * k
                    END IF
                    IF bal1 < l_ima46 THEN               # 最小採購/製造量
                       LET bal1 = l_ima46
                    END IF
                    IF bal1 > qty2 THEN
                       LET bal1 = qty2                   #可移動數量
                    END IF 
                    LET sss[i].mss071 = sss[i].mss071 + bal1
                    LET sss[j].mss072 = sss[j].mss072 + bal1
                    LET bal = bal - bal1
                    LET qty2 = qty2 - bal1
                    FOR m= i+1 TO j
                        LET sss[m].mss08=sss[m].mss08-bal1
                    END FOR

                    IF qty2 = 0 THEN  
                      EXIT FOR
                    END IF            
               ELSE LET sss[i].mss071=sss[i].mss071+qty2
                    LET sss[j].mss072=sss[j].mss072+qty2
                    LET bal=bal-qty2
                    FOR m= i+1 TO j
                        LET sss[m].mss08=sss[m].mss08-qty2
                    END FOR
                    LET qty2 = 0 
                    EXIT FOR
            END IF
          END FOR
        END IF
        LET sss[i].mss08=bal
        IF sss[i].mss08 < 0 THEN                        #-> plan order
           LET sss[i].mss09=sss[i].mss08*-1
 
           LET l_mss09 = sss[i].mss09
           #若庫存單位與採購/生產單位不一樣時才推算數量
           IF l_ima25 != l_ima44 THEN      
              CALL p500_che_qty(mss.mss01,l_ima25,l_ima44,l_mss09)
                                RETURNING l_mss09
           END IF
           IF l_ima47 != 0 THEN                         # 採購/製造損耗率
              LET l_mss09 = l_mss09 * (100+l_ima47)/100
           END IF
           IF l_ima45 != 0 THEN                         # 採購/製造倍量
              LET k = (l_mss09 / l_ima45) + 0.9999999
              LET l_mss09 = l_ima45 * k
           END IF
           IF l_mss09 < l_ima46 THEN               # 最小採購/製造量
              LET l_mss09 = l_ima46
           END IF
           IF l_ima25 != l_ima44 THEN
              CALL p500_che_qty(mss.mss01,l_ima44,l_ima25,l_mss09) 
                                RETURNING l_mss09
           END IF
          LET l_gfe03=NULL
          SELECT gfe03 INTO l_gfe03 FROM ima_file,gfe_file
                                   WHERE ima01=sss[i].mss01
                                     AND ima55=gfe01
          IF NOT cl_null(l_gfe03) THEN
             LET sss[i].mss09=cl_digcut(l_mss09,l_gfe03)
          ELSE                           
             LET sss[i].mss09 = l_mss09   
          END IF
 
           LET needdate=NULL

           IF needdate IS NULL THEN LET needdate=sss[i].mss03 END IF
 
           IF l_ima08='M' OR l_ima08='S' OR l_ima08='T' THEN   
               LET l_ima50=l_ima59+l_ima60/l_ima601*sss[i].mss09+l_ima61    
            END IF
           LET sss[i].mss11=s_aday(needdate,-1,l_ima50)  # 減採購/製造前置日數
            IF sss[i].mss11 > sss[i].mss03 THEN
               LET sss[i].mss11=sss[i].mss03
            END IF
 
        END IF
        LET l_ima910=''
        SELECT ima910 INTO l_ima910 FROM ima_file WHERE ima01=sss[i].mss01
        IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF
        
        IF l_chr = 'Y' THEN   
           IF sss[i].mss09>0 AND (l_ima08='M' OR l_ima08='S' OR l_ima08='T') THEN
              CALL p500_mss045(sss[i].mss00,sss[i].mss01,
                               sss[i].mss11,needdate,sss[i].mss09,l_ima910,0)       
           END IF
        END IF                

        LET bal=sss[i].mss08+sss[i].mss09
        EXECUTE p500_p_upd_mss using sss[i].*,rrr[i].*
        IF SQLCA.SQLCODE THEN
           IF g_bgjob = 'N' THEN   
              MESSAGE sss[i].mss01,' ',sss[i].mss03
              CALL ui.Interface.refresh()
              CALL err('plan:upd mss:',SQLCA.SQLCODE,1)
           END IF  
        END IF
      END FOR
      #CHI-C50068---end
END REPORT
 
FUNCTION p500_che_qty(p_part,p_unit1,p_unit2,p_qty)
   DEFINE p_part         LIKE ima_file.ima01
   DEFINE p_unit1        LIKE ima_file.ima25
   DEFINE p_unit2        LIKE ima_file.ima25
   DEFINE p_qty          LIKE mss_file.mss09
   DEFINE l_factor       LIKE ima_file.ima55_fac
   DEFINE l_cnt          LIKE type_file.num5
 
   CALL s_umfchk(p_part,p_unit1,p_unit2) RETURNING l_cnt, l_factor
   IF l_cnt = 1 THEN
     LET l_factor = 1
   END IF
   LET p_qty = p_qty * l_factor 
   RETURN p_qty
END FUNCTION
 
FUNCTION p500_mss045(p_mss00,p_ima01,p_opendate,p_needdate,p_qty,p_key2,p_n)     #No.MOD-6A0141 modify #No.MOD-8B0259 add p_n
#No.FUN-A70034  --Begin
  DEFINE l_total        LIKE sfa_file.sfa05
  DEFINE l_QPA          LIKE bmb_file.bmb06
  DEFINE l_ActualQPA    LIKE bmb_file.bmb06
#No.FUN-A70034  --End  
  DEFINE p_mss00        LIKE type_file.num10    #NO.FUN-680082  INTEGER
  DEFINE p_ima01        LIKE ima_file.ima01 #NO.MOD-490217
  DEFINE p_opendate     LIKE type_file.dat      #NO.FUN-680082  DATE
  DEFINE p_needdate     LIKE type_file.dat      #NO.FUN-680082  DATE
  DEFINE p_qty          LIKE mst_file.mst08     #NO.FUN-680082  DEC(15,3)
  DEFINE qty1,qty2,qty3,qty4   LIKE mst_file.mst08    #NO.FUN-680082  DEC(15,3)
  DEFINE l_ima08        LIKE type_file.chr1     #NO.FUN-680082  VARCHAR(1)
  DEFINE l_msg          LIKE type_file.chr1000  #NO.FUN-680082  VARCHAR(40)
  DEFINE l_bma05        LIKE bma_file.bma05
  DEFINE p_key2         LIKE ima_file.ima910    #No.MOD-6A0141 add
  DEFINE p_n            LIKE type_file.num5     #No.MOD-8B0259  #遞歸層階
  DEFINE l_sql          STRING                  #No.MOD-8B0259
  DEFINE sr             DYNAMIC ARRAY OF RECORD
             bmb        RECORD LIKE bmb_file.*,
             qty        LIKE mst_file.mst08,
             ima08      LIKE ima_file.ima08
                        END RECORD
  DEFINE l_ac           LIKE type_file.num5
  DEFINE i              LIKE type_file.num5
  DEFINE l_ima55_fac    LIKE ima_file.ima55_fac   #生產單位/庫存單位換算率
  DEFINE qty_n          LIKE mss_file.mss09      #MOD-CC0229 add
  IF p_n = 0 THEN   #No.MOD-8B0259
     IF mss_expl='N' THEN RETURN END IF            # 僅在多階 MRP 狀況下
       SELECT bma05 INTO l_bma05 FROM bma_file WHERE bma01 = p_ima01
                                                 AND bma06 = p_key2    #No.MOD-6A0141 add
       IF SQLCA.sqlcode THEN
          CALL cl_getmsg('amr-002',g_lang) RETURNING l_msg
          LET g_msg = p_ima01,l_msg clipped
          CALL msg(g_msg,'amr-002')
          RETURN
       END IF
       IF cl_null(l_bma05) THEN
          CALL cl_getmsg('amr-001',g_lang) RETURNING l_msg
          LET g_msg = p_ima01,l_msg clipped
          CALL msg(g_msg,'amr-001')
          RETURN
       END IF
  END IF  #No.MOD-8B0259
 
  LET l_sql = "SELECT bmb_file.*, ima08 FROM bmb_file, ima_file ",
              " WHERE bmb01='",p_ima01,"'",
              "   AND bmb03=ima01   ",
              "   AND bmb04<='",p_needdate,"'",
              "   AND (bmb05 IS NULL OR bmb05> '",p_needdate,"')"
  IF p_n = 0 THEN 
     LET l_sql = l_sql," AND bmb29='",p_key2,"'"
  END IF 
  PREPARE p500_mss045_prep FROM l_sql
  DECLARE p500_mss045_c1 CURSOR FOR p500_mss045_prep        
              
 
  CALL p500_mss_0()
  LET l_ac = 1 
  CALL sr.clear() 
  #MOD-CC0229 add begin-------------------------------------------
  SELECT ima55_fac INTO l_ima55_fac FROM ima_file WHERE ima01 = p_ima01
  IF cl_null(l_ima55_fac) THEN LET l_ima55_fac = 1 END IF 
  LET qty_n = p_qty / l_ima55_fac
  #MOD-CC0229 add end---------------------------------------------
  FOREACH p500_mss045_c1 INTO bmb1.*, l_ima08
    IF STATUS THEN CALL cl_err('45_c1:',STATUS,1) EXIT FOREACH END IF
 
    SELECT ima55_fac INTO l_ima55_fac FROM ima_file
     WHERE ima01=bmb1.bmb01   # 主件
    IF cl_null(l_ima55_fac) THEN LET l_ima55_fac=1 END IF
 
## No:2423  modify 1998/09/04 -(統一單位為庫存單位)-------
    #No.FUN-A70034  --Begin
    #LET qty1=p_qty*bmb1.bmb06/bmb1.bmb07*(1+bmb1.bmb08/100) 
    #         *bmb1.bmb10_fac
    #No.FUN-A70034  --End  
     LET sr[l_ac].bmb.* = bmb1.*
    #LET sr[l_ac].qty = qty1    #No.FUN-A70034
     LET sr[l_ac].ima08 = l_ima08
     LET l_ac = l_ac + 1
    
    
  END FOREACH    #No.MOD-8B0259 
  CALL sr.deleteElement(l_ac)
  LET l_ac = l_ac - 1   #MOD-910082
  
  
  FOR i = 1 TO l_ac      
      #No.FUN-A70034  --Begin
     #CALL cralc_rate(sr[i].bmb.bmb01,sr[i].bmb.bmb03,p_qty,sr[i].bmb.bmb081,sr[i].bmb.bmb08,   #MOD-CC0229 mark
      CALL cralc_rate(sr[i].bmb.bmb01,sr[i].bmb.bmb03,qty_n,sr[i].bmb.bmb081,sr[i].bmb.bmb08,   #MOD-CC0229  p_qty -> qty_n
                      sr[i].bmb.bmb082,sr[i].bmb.bmb06/sr[i].bmb.bmb07,0)
           RETURNING l_total,l_QPA,l_ActualQPA
      LET qty1 = l_total * sr[i].bmb.bmb10_fac
      LET sr[i].qty = qty1
      #No.FUN-A70034  --End  
      IF sr[i].ima08 !='X' THEN #MOD-960044  #CHI-D40027 remark
     #IF sr[i].ima08 !='X' AND NOT (sr[i].ima08='M' AND sr[i].bmb.bmb19='3') THEN #MOD-960044  #FUN-B20060_4 mod  #CHI-D40027 mark
         SELECT partno FROM part_tmp WHERE partno=sr[i].bmb.bmb03
         IF STATUS THEN CONTINUE FOR END IF
         LET bmb.* = sr[i].bmb.*
         CALL p500_mss045_ins(p_mss00,p_opendate,p_needdate,sr[i].qty,sr[i].bmb.bmb01)
         CONTINUE FOR 
      ELSE 
    	   IF p_n < 20 THEN 
    	      CALL p500_mss045(p_mss00,sr[i].bmb.bmb03,p_opendate,p_needdate,sr[i].qty,'',p_n+1)
    	   ELSE 
    	   	  CALL cl_err(bmb.bmb03,'amr-026',1)
    	   	 #CALL p500_mss045_ins(p_mss00,p_opendate,p_needdate,sr[i].qty,sr[i].bmb.bmb01)  #No.MOD-940415 mark
    	   END IF      	 
      END IF 
  END FOR 
 
 #IF STATUS THEN CALL err('p500_mss045_c2:',STATUS,1) RETURN END IF  #MOD-A50207 mark
END FUNCTION
 
FUNCTION p500_mss045_ins(p_mss00,p_opendate,p_needdate,p_qty,p_id)
  DEFINE p_mss00        LIKE type_file.num10    #NO.FUN-680082  INTEGER
  DEFINE p_qty          LIKE mst_file.mst08     #NO.FUN-680082  DEC(15,3)
  DEFINE p_opendate     LIKE type_file.dat      #NO.FUN-680082  DATE
  DEFINE p_needdate     LIKE type_file.dat      #NO.FUN-680082  DATE
  DEFINE p_id           LIKE ima_file.ima01 ## 98/06/23 Eric Add
  DEFINE l_cnt          LIKE type_file.num5  #MOD-D20082
                                             ## 解決虛擬料件回溯追蹤
 
       SELECT partno FROM part_tmp WHERE partno=bmb.bmb03
       IF STATUS THEN INSERT INTO part_tmp VALUES(bmb.bmb03) END IF
       LET mss.mss01=bmb.bmb03
       LET mss.mss02=NULL
       SELECT bml04 INTO mss.mss02 FROM bml_file        # 限定廠商
        WHERE (bml01=bmb.bmb03 AND bml02=bmb.bmb01 AND bml03=qvl_bml03
           OR bml01=bmb.bmb03 AND bml02='ALL' AND bml03=qvl_bml03)
       IF cl_null(mss.mss02) THEN LET mss.mss02='-' END IF
       LET mss.mss03=past_date
       IF bmb.bmb18 IS NULL THEN LET bmb.bmb18 = 0 END IF
      #LET needdate=p_opendate + bmb.bmb18           #MOD-A40010 mark 
       LET needdate=s_aday(p_opendate,1,bmb.bmb18)   #MOD-A40010
       IF needdate >= list_date THEN  #FUN-B20060_5 bdate->list_date
          SELECT plan_date INTO mss.mss03 FROM buk_tmp WHERE real_date=needdate
          IF STATUS THEN RETURN END IF
#         IF STATUS THEN CALL err('sel buk_tmp:',STATUS,1) END IF
       END IF
       LET mss.mss043=p_qty
       LET mss.mssplant=g_plant   #FUN-980004 add
       LET mss.msslegal=g_legal   #FUN-980004 add

#TQC-C20053 --begin--
    IF cl_null(mss.mss13) THEN
      LET mss.mss13 = 'N'
    END IF
#TQC-C20053 --begin--

       INSERT INTO mss_file VALUES(mss.*)
       IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN 
           CALL cl_err('ins mss:',SQLCA.SQLCODE,1) 
       END IF
       IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #TQC-790091 mod

        EXECUTE p500_p_upd_mss043 using mss.mss043,mss.mss_v,mss.mss01,
                                        mss.mss02,mss.mss03
        IF STATUS THEN CALL cl_err('upd mss:',STATUS,1) END IF
       END IF
       LET mst.mst_v=mss.mss_v  # 版本
       LET mst.mst01=mss.mss01  # 料號
       LET mst.mst02=mss.mss02  # 廠商
       LET mst.mst03=mss.mss03  # 日期
       LET mst.mst04=p_opendate # 日期
       LET mst.mst05='45'       # 供需類別
       LET mst.mst06=p_mss00    # 單號
       LET mst.mst061=NULL      # 項次
       LET mst.mst06_fz=NULL    # 凍結否
       LET mst.mst07=p_id       # 追索料號(上階半/成品) 98/06/23 Modif
       LET mst.mst08=mss.mss043 # 數量
       LET mst.mstplant=g_plant   #FUN-980004 add
       LET mst.mstlegal=g_legal   #FUN-980004 add
     IF cl_null(mst.mst07) THEN
        LET mst.mst07=' '
     END IF
     IF cl_null(mst.mst09) THEN LET mst.mst09=' ' END IF  #TQC-C20222
     #MOD-D20082---begin
     SELECT COUNT(*) 
       INTO l_cnt
       FROM mst_file
      WHERE mst_v = mst.mst_v
        AND mst01 = mst.mst01
        AND mst02 = mst.mst02
        AND mst05 = mst.mst05
        AND mst08 = mst.mst08
        AND mstplant = mst.mstplant
        AND mstlegal = mst.mstlegal
     IF l_cnt>0 THEN 
        UPDATE mst_file
           SET mst03 = mst.mst03,
               mst04 = mst.mst04
         WHERE mst_v = mst.mst_v
           AND mst01 = mst.mst01
           AND mst02 = mst.mst02
           AND mst05 = mst.mst05
           AND mst08 = mst.mst08
           AND mstplant = mst.mstplant
           AND mstlegal = mst.mstlegal
        IF STATUS THEN CALL err('upd mst',STATUS,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time 
           EXIT PROGRAM 
        END IF
        EXECUTE p500_p_upd_mss043_2 using mss.mss043,mss.mss_v,mss.mss01,
                                        mss.mss02,mss.mss03
        IF STATUS THEN CALL cl_err('upd mss:',STATUS,1) END IF
     ELSE 
     #MOD-D20082---end
       PUT p500_c_ins_mst FROM mst.*
       IF STATUS THEN CALL err('ins mst',STATUS,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
          EXIT PROGRAM END IF
     END IF  #MOD-D20082
END FUNCTION
 
FUNCTION p500_plan_sub()
  DEFINE l_short        LIKE mss_file.mss041     #NO.FUN-680082  DEC(15,3)
  DEFINE xx             LIKE mss_file.mss041     #NO.FUN-680082  DEC(15,3)
  DEFINE b1,b2,b3       LIKE mss_file.mss041     #NO.FUN-680082  DEC(15,3)
  DEFINE l_bal          LIKE mss_file.mss041     #NO.FUN-680082  DEC(15,3)
  DEFINE l_sql          STRING                   #CHI-C80002
  
  #bmd01   原始料件编号
  #bmd05   生效日期
  #bmd06   失效日期
  #bmdacti 资料有效码
  DECLARE p500_plan_sub_c CURSOR FOR
    SELECT UNIQUE mss01,mss03           # 找出有取替代的元件
      FROM mss_file, bmd_file, ima_file
     WHERE mss_v=ver_no AND mss01=bmd01 AND mss01=ima01 AND ima16=g_ima16
       AND bmd05<=edate AND (bmd06 IS NULL OR bmd06 > bdate)
       AND bmdacti = 'Y'                                           #CHI-910021
   #===============No:EXT-610004========================
     #原本以料件順序為基準計算料件之間的替代量，
     #現在改以時距日期的順序作為計算替代量參考基準
      #ORDER BY 1,2
       ORDER BY 2,1
   #===============No:EXT-610004========================

  #mst03 供需日期(依时距)
  #mst04 供需日期(实际)
  #mst06 来源单号
  #mst061 来源项次
  #mst07  来源料号 (上阶半/成品需求追索料号)
  #mst08  数量;型态 int -> dec(12,3) 
  #mst01  料号
  #mst0   供需类别      /*  40 : 安全库存量                      */
                        /*  41 : 独立需求                        */
                        /*  42 : 受订量/MDS需求量                */
                        /*  43 : 计划备料量 (MPS 计划下阶料展出) */
                        /*  44 : 工单备料量 (实际工单下阶料展出) */
                        /*  45 : PLM 备料量 (PLM 工单下阶料展出) */
                        /*  46 : 备品需求量                      */
                        /*  51 : 库存量                          */
                        /*  52 : 在验量                          */
                        /*  53 : 替代料库存量                    */
                        /*  61 : 请购量                          */
                        /*  62 : 在采量                          */
                        /*  63 : 在外量                          */
                        /*  64 : 在制量                          */
                        /*  65 : 计划产                          */

  #CHI-C80002---begin
  LET l_sql = " SELECT mst03,mst04,mst06,mst061,mst07,mst08 FROM mst_file ",
              " WHERE mst_v=? AND mst01=? AND mst02='-' AND mst03=? ",
              " AND mst05 IN ('43','44','45') ",
              " ORDER BY 1 DESC, 2, 5, 3 "
  PREPARE p500_plan_sub_p2 FROM l_sql
  DECLARE p500_plan_sub_c2 CURSOR FOR p500_plan_sub_p2

  LET l_sql = " SELECT bmd_file.* FROM bmd_file, ima_file ",
              " WHERE bmd01=? AND (bmd08=? OR bmd08='ALL') ",
              " AND bmd05<='",edate,"' AND (bmd06 IS NULL OR bmd06 > '",bdate,"') ",
              " AND bmd04=ima01 AND imaacti='Y' ",
              " AND bmdacti = 'Y' ",              
              " ORDER BY bmd03 "
  PREPARE p500_plan_sub_p3 FROM l_sql
  DECLARE p500_plan_sub_c3 CURSOR FOR p500_plan_sub_p3

  LET l_sql = " UPDATE sub_tmp SET sub_qty=sub_qty+? ",
              " WHERE sub_partno=? AND sub_wo_no=? AND sub_prodno=?"
  PREPARE p500_upd_sub_p1 FROM l_sql            
  #CHI-C80002---end
 
  #mss041  需求:受订量         40--安全库存 41--独立需求 42--受订
  #mss043  需求:计划备料量     43--MPS 计划下阶料展出  45--+PLM 工单下阶料展出
  #mss044  需求:工单备料量     44--实际工单下阶料展出  
  #mss051  供给:库存量
  #mss052  供给:在验量
  #mss053  供给:库存量 (替代料)
  #mss061  供给:请购量
  #mss062  供给:在采量 (采购单未发出)
  #mss063  供给:在外量 (采购单已发出)
  #mss064  供给:在制量 (确认工单预计完工)
  #mss065  供给:计划产 (MPS 计划预计生产)
  
  FOREACH p500_plan_sub_c INTO g_mss01,g_mss03
     IF STATUS THEN CALL err('fore1',STATUS,1) RETURN END IF
     SELECT SUM((mss041+mss043+mss044)   #需求 - 供給
               -(mss051+mss052+mss053+mss061+mss062+mss063+mss064+mss065))
       INTO l_short
       FROM mss_file
      WHERE mss_v=ver_no AND mss01=g_mss01 AND mss02='-' AND mss03<=g_mss03
     IF l_short IS NULL THEN LET l_short=0 END IF
     IF l_short<=0 THEN CONTINUE FOREACH END IF #若不足才找替代
     FLUSH p500_c_ins_mst    # 將insert mst_file 的 cursor 寫入 database
     FOREACH p500_plan_sub_c2 USING ver_no,g_mss01,g_mss03 INTO g_mst03,g_mst04,g_mst06,g_mst061,  #CHI-C80002
                                   g_mst07,g_mst08
       IF STATUS THEN CALL err('fore2',STATUS,1) EXIT FOREACH END IF
       #------------------------------------------ 取該料+工單已被計算部份
       SELECT SUM(sub_qty) INTO xx FROM sub_tmp
         WHERE sub_partno=g_mss01 AND sub_wo_no=g_mst06 AND sub_prodno=g_mst07
       IF xx IS NULL THEN LET xx=0 END IF
       #------------------------------------------ 取該料+工單已被計算部份
       IF l_short<g_mst08 THEN LET g_mst08=l_short END IF
#######################################      
       FOREACH p500_plan_sub_c3 USING g_mss01,g_mst07 INTO bmd.*  #CHI-C80002
         IF STATUS THEN CALL err('fore3',STATUS,1) EXIT FOREACH END IF
         SELECT SUM(mss051+mss052+mss061+mss062+mss063+mss064+mss065)
           INTO b1                                      # QOH/PR/PO 供給合計
           FROM mss_file
          WHERE mss_v=ver_no AND mss01=bmd.bmd04 AND mss02='-'
             AND mss03<=g_mss03 #MOD-520074
         SELECT SUM(mss041+mss043+mss044-mss053)
           INTO b2                                      # 需求(+替代需求)合計
           FROM mss_file
          WHERE mss_v=ver_no AND mss01=bmd.bmd04 AND mss02='-'
            AND mss03<=g_mss03
         IF b1 IS NULL THEN LET b1=0 END IF
         IF b2 IS NULL THEN LET b2=0 END IF
         LET l_bal=b1-b2
         IF l_bal<=0 THEN CONTINUE FOREACH END IF
        #------------ No:MOD-B30174  add
         IF bmd.bmd05 > g_mss03 OR  (bmd.bmd06 IS NOT NULL AND  bmd.bmd06 < g_mss03) THEN
            CONTINUE FOREACH 
         END IF
        #------------ No:MOD-B30174  end
         IF g_mst08*bmd.bmd07 > l_bal
            THEN LET g_sub_qty=l_bal
            ELSE LET g_sub_qty=g_mst08*bmd.bmd07
         END IF
         #-------------------------------- 統計該料+工單已被計算部份,存入sub_tmp
         EXECUTE p500_upd_sub_p1 USING g_sub_qty,g_mss01,g_mst06,g_mst07  #CHI-C80002
         IF SQLCA.SQLERRD[3]=0 THEN
            INSERT INTO sub_tmp (sub_partno, sub_wo_no, sub_prodno, sub_qty)
                                VALUES(g_mss01, g_mst06, g_mst07, g_sub_qty)
         END IF
         #---------------------------------------------------------------------
         CALL u_sub_1() # 更新替代件
         CALL u_sub_2() # 更新被替代件
         LET g_mst08=g_mst08-g_sub_qty/bmd.bmd07
         LET l_short=l_short-g_sub_qty/bmd.bmd07
         IF g_mst08 <= 0 THEN EXIT FOREACH END IF
       END FOREACH
######################################       
       IF STATUS THEN CALL err('fore3',STATUS,1) EXIT FOREACH END IF
       IF l_short <= 0 THEN EXIT FOREACH END IF
     END FOREACH
     IF STATUS THEN CALL err('fore2',STATUS,1) EXIT FOREACH END IF
  END FOREACH
  IF STATUS THEN CALL err('fore1',STATUS,1) END IF
END FUNCTION
 
FUNCTION u_sub_1()
 
   UPDATE mss_file SET mss053=mss053-g_sub_qty
    WHERE mss_v=ver_no AND mss01=bmd.bmd04
       AND mss02='-'    AND mss03=g_mss03 #MOD-520074
   IF SQLCA.SQLERRD[3]=0 THEN
      CALL p500_mss_0()
      LET mss.mss01=bmd.bmd04
      LET mss.mss02='-'
       LET mss.mss03=g_mss03 #MOD-520074
      LET mss.mss053=-g_sub_qty
      LET mss.mssplant=g_plant   #FUN-980004 add
      LET mss.msslegal=g_legal   #FUN-980004 add
#TQC-C20053 --begin--
    IF cl_null(mss.mss13) THEN
      LET mss.mss13 = 'N'
    END IF
#TQC-C20053 --begin--

      INSERT INTO mss_file VALUES (mss.*)
   END IF
   LET mst.mst01=bmd.bmd04
   LET mst.mst02='-'
    LET mst.mst03=g_mss03 #MOD-520074
   LET mst.mst04=g_mst04
   LET mst.mst05='53'
   LET mst.mst06=g_mst06
   LET mst.mst061=g_mst061
   LET mst.mst06_fz=NULL
   LET mst.mst07=g_mss01
   LET mst.mst08=-g_sub_qty
   LET mst.mstplant=g_plant   #FUN-980004 add
   LET mst.mstlegal=g_legal   #FUN-980004 add
     IF cl_null(mst.mst07) THEN
        LET mst.mst07=' '
     END IF
    IF cl_null(mst.mst09) THEN LET mst.mst09=' ' END IF  #TQC-C20222
    PUT p500_c_ins_mst FROM mst.*
END FUNCTION
 
FUNCTION u_sub_2()
 
   UPDATE mss_file SET mss053=mss053+g_sub_qty/bmd.bmd07
    WHERE mss_v=ver_no AND mss01=g_mss01
       AND mss02='-'    AND mss03=g_mss03 #MOD-520074
   IF SQLCA.SQLERRD[3]=0 THEN
      CALL p500_mss_0()
      LET mss.mss01=g_mss01
      LET mss.mss02='-'
       LET mss.mss03=g_mss03 #MOD-520074
      LET mss.mss053=g_sub_qty/bmd.bmd07
      LET mss.mssplant=g_plant   #FUN-980004 add
      LET mss.msslegal=g_legal   #FUN-980004 add
#TQC-C20053 --begin--
    IF cl_null(mss.mss13) THEN
      LET mss.mss13 = 'N'
    END IF
#TQC-C20053 --begin--

      INSERT INTO mss_file VALUES (mss.*)
   END IF
   LET mst.mst01=g_mss01
   LET mst.mst02='-'
    LET mst.mst03=g_mss03  #MOD-520074
   LET mst.mst04=g_mst04
   LET mst.mst05='53'
   LET mst.mst06=g_mst06
   LET mst.mst061=g_mst061
   LET mst.mst06_fz=NULL
   LET mst.mst07=bmd.bmd04
   LET mst.mst08=g_sub_qty/bmd.bmd07
   LET mst.mstplant=g_plant   #FUN-980004 add
   LET mst.mstlegal=g_legal   #FUN-980004 add
     IF cl_null(mst.mst07) THEN
        LET mst.mst07=' '
     END IF
    IF cl_null(mst.mst09) THEN LET mst.mst09=' ' END IF  #TQC-C20222
    PUT p500_c_ins_mst FROM mst.*
END FUNCTION

#FUN-A20037 --begin--
FUNCTION p500_plan_sub_1()
  DEFINE l_short        LIKE mss_file.mss041    
  DEFINE b1,b2,b3       LIKE mss_file.mss041     
  DEFINE l_bal          LIKE mss_file.mss041    
  DEFINE l_ima01        LIKE ima_file.ima01 
  DEFINE l_sql          STRING  #CHI-C80002
   
   DECLARE p500_paln_sub_ima01 CURSOR FOR 
   SELECT DISTINCT ima01 FROM ima_file,bon_file,bmb_file,part_tmp
    WHERE imaacti = 'Y' and ima37 = '2'
      AND partno = bon01 
      AND bmb03 = bon01 AND bmb16 = '7'
	    AND (bmb01 = bon02 or bon02 = '*') 
      AND bon09<=edate AND (bon10 IS NULL OR bon10 > bdate)
      AND bonacti = 'Y'
      AND ima251 = bon06
      AND ima022 BETWEEN bon04 AND bon05
      AND ima109 = bon07 
      AND ima54 = bon08 
      AND ima01 != bon01 
      
   DECLARE p500_plan_sub_c_4 CURSOR FOR   # 找出有取替代的元件
   SELECT unique mss01,mss03 FROM mss_file,ima_file,bon_file,bmb_file
    WHERE mss_v = ver_no                     
      AND mss01 = bon01 
      #AND mss01 in(select ima01 from ima_file)  #CHI-C80002
      AND EXISTS(select 1 from ima_file WHERE ima01 = mss01)  #CHI-C80002
      AND ima16 = g_ima16 
      AND bmb16 = '7' AND bmb03 = bon01          
      AND (bmb01 = bon02 OR bon02 = '*')
      AND bon09<=edate AND (bon10 IS NULL OR bon10 > bdate)
      AND bonacti = 'Y'
      ORDER BY 2,1                       

  #CHI-C80002---begin
  LET l_sql = " SELECT mst03,mst04,mst06,mst061,mst07,mst08 FROM mst_file ",   
              " WHERE mst_v=? AND mst01=? AND mst02='-' AND mst03=? ",
              " AND mst05 IN ('43','44','45') ",
              " ORDER BY 1 DESC, 2, 5, 3 "
  PREPARE p500_plan_sub_p5 FROM l_sql
  DECLARE p500_plan_sub_c5 CURSOR FOR p500_plan_sub_p5

  LET l_sql = " SELECT distinct bon_file.* FROM bon_file,ima_file,bmb_file,part_tmp ",
              " WHERE bmb03 = bon01 AND bmb16 = '7' ",
		      " AND (bmb01 = bon02 or bon02 = '*') ", 		  
              " AND bon01 = ? AND (bon02 = ? OR bon02 = '*') ",
              " AND bon09<='",edate,"' AND (bon10 IS NULL OR bon10 > '",bdate,"') ",
              " AND partno = ima01 ",
              " AND imaacti='Y' AND bonacti = 'Y' ",           
              " ORDER BY bon03 "
  PREPARE p500_plan_sub_p6 FROM l_sql
  DECLARE p500_plan_sub_c6 CURSOR FOR p500_plan_sub_p6          
  #CHI-C80002---end 
      
  FOREACH p500_plan_sub_c_4 INTO g_mss01,g_mss03
     IF STATUS THEN CALL err('foreach 4:',STATUS,1) RETURN END IF
     SELECT SUM((mss041+mss043+mss044)   #需求 - 供給
               -(mss051+mss052+mss053+mss061+mss062+mss063+mss064+mss065))
       INTO l_short FROM mss_file
      WHERE mss_v=ver_no 
        AND mss01=g_mss01 AND mss02='-' AND mss03<=g_mss03
     IF l_short IS NULL THEN LET l_short=0 END IF
     IF l_short<=0 THEN CONTINUE FOREACH END IF   #若不足才找替代
     
     FLUSH p500_c_ins_mst    # 將insert mst_file 的 cursor 寫入 database
     #CHI-C80002---begin mark
     #DECLARE p500_plan_sub_c5 CURSOR FOR
     #  SELECT mst03,mst04,mst06,mst061,mst07,mst08 FROM mst_file
     #   WHERE mst_v=ver_no AND mst01=g_mss01 AND mst02='-' AND mst03=g_mss03
     #     AND mst05 IN ('43','44','45')   #備料
     #   ORDER BY 1 DESC, 2, 5, 3
     #FOREACH p500_plan_sub_c5 INTO g_mst03,g_mst04,g_mst06,g_mst061,g_mst07,g_mst08
     #CHI-C80002---end
     FOREACH p500_plan_sub_c5 USING ver_no,g_mss01,g_mss03 INTO g_mst03,g_mst04,g_mst06,g_mst061,g_mst07,g_mst08  #CHI-C80002
       IF STATUS THEN CALL err('foreach 5:',STATUS,1) EXIT FOREACH END IF
       IF l_short<g_mst08 THEN LET g_mst08=l_short END IF  
       #CHI-C80002---begin mark
       #DECLARE p500_plan_sub_c6 CURSOR FOR
       # SELECT distinct bon_file.* FROM bon_file,ima_file,bmb_file,part_tmp
       #  WHERE bmb03 = bon01 AND bmb16 = '7'
	   #    AND (bmb01 = bon02 or bon02 = '*')   		  
       #    AND bon01 = g_mss01 AND (bon02 = g_mst07 OR bon02 = '*')
       #    AND bon09<=edate AND (bon10 IS NULL OR bon10 > bdate)
       #    AND partno = ima01
       #    AND imaacti='Y' AND bonacti = 'Y'              
       #    ORDER BY bon03      
       #FOREACH p500_plan_sub_c6 INTO bon.*
       #CHI-C80002---end
       FOREACH p500_plan_sub_c6 USING g_mss01,g_mst07 INTO bon.*  #CHI-C80002
         IF STATUS THEN 
            CALL err('fore6',STATUS,1) 
            EXIT FOREACH 
         END IF   
         FOREACH p500_paln_sub_ima01 INTO g_ima01     
            SELECT SUM(mss051+mss052+mss061+mss062+mss063+mss064+mss065) INTO b1                            
              FROM mss_file       # QOH/PR/PO 供給合計           
             WHERE mss_v=ver_no AND mss02 = '-' AND mss03<=g_mss03 
               AND mss01 = g_ima01 
                                        
            SELECT SUM(mss041+mss043+mss044-mss053) INTO b2 
              FROM mss_file                             # 需求(+替代需求)合計
             WHERE mss_v=ver_no AND mss02 = '-' AND mss03<=g_mss03
               AND mss01 = g_ima01       
             
            IF b1 IS NULL THEN LET b1=0 END IF
            IF b2 IS NULL THEN LET b2=0 END IF
            LET l_bal=b1-b2
            IF l_bal<=0 THEN CONTINUE FOREACH END IF
            IF g_mst08*bon.bon11 > l_bal THEN
               LET g_sub_qty=l_bal
            ELSE
            	 LET g_sub_qty=g_mst08*bon.bon11
            END IF
          #-------------------------------- 統計該料+工單已被計算部份,存入sub_tmp
           UPDATE sub_tmp SET sub_qty=sub_qty+g_sub_qty
            WHERE sub_partno=g_mss01 AND sub_wo_no=g_mst06 AND sub_prodno=g_mst07
           IF SQLCA.SQLERRD[3]=0 THEN
            INSERT INTO sub_tmp (sub_partno, sub_wo_no, sub_prodno, sub_qty)
                                VALUES(g_mss01, g_mst06, g_mst07, g_sub_qty)
           END IF
          #--------------------------------------------------------------------
           LET bmd.bmd04 =g_ima01 
           LET bmd.bmd07 = bon.bon11
           CALL u_sub_1() # 更新替代件
           CALL u_sub_2() # 更新被替代件
           LET g_mst08=g_mst08-g_sub_qty/bon.bon11
           LET l_short=l_short-g_sub_qty/bon.bon11
           IF g_mst08 <= 0 THEN EXIT FOREACH END IF
         END FOREACH   
       END FOREACH     
       IF STATUS THEN CALL err('fore6',STATUS,1) EXIT FOREACH END IF
       IF l_short <= 0 THEN EXIT FOREACH END IF
     END FOREACH
     IF STATUS THEN CALL err('fore5',STATUS,1) EXIT FOREACH END IF
  END FOREACH
  IF STATUS THEN CALL err('fore4',STATUS,1) END IF
END FUNCTION
#FUN-A20037 --end--

FUNCTION msg(p_msg,p_code)   # 非 Background 狀態, 才可顯示 message
   DEFINE p_msg         LIKE type_file.chr1000  #NO.FUN-680082  VARCHAR(80)    #FUN-560221
   DEFINE p_code        LIKE msl_file.msl04     #NO.FUN-680082  VARCHAR(10
   DEFINE l_time        LIKE type_file.chr8     #No.FUN-6A0076
   LET msl.msl_v=ver_no
   LET msl.msl01=TODAY
   LET l_time = TIME
   LET msl.msl02=l_time
   LET msl.msl03=p_msg
   LET msl.msl04=p_code
   LET msl.mslplant=g_plant #FUN-980004 add
   LET msl.msllegal=g_legal #FUN-980004 add
   INSERT INTO msl_file VALUES(msl.*)
   IF cl_null(g_argv1) THEN
      IF g_bgjob = 'N' THEN   #MOD-A30082 add
         MESSAGE p_msg CLIPPED
         CALL ui.Interface.refresh()
      END IF   #MOD-A30082 add
   END IF
END FUNCTION
 
FUNCTION err(p_msg,err_code,p_n)
   DEFINE p_msg         LIKE type_file.chr1000, #NO.FUN-680082  VARCHAR(80)
          err_code      LIKE ze_file. ze01,     #NO.FUN-680082  VARCHAR(7)
          err_coden     LIKE type_file.num10,   #NO.FUN-680082  INTEGER
          p_n           LIKE type_file.num5,    #NO.FUN-680082  SMALLINT
          l_errmsg      LIKE type_file.chr1000, #NO.FUN-680082  VARCHAR(70)
          l_sqlerrd ARRAY[6] OF LIKE type_file.num10,   #NO.FUN-680082  INTEGER
          l_chr         LIKE type_file.chr1,    #NO.FUN-680082  VARCHAR(1)
          l_time        LIKE type_file.chr8     #No.FUN-6A0076
 
    CALL s_errmsg('','',p_msg,err_code,p_n)
END FUNCTION
 
FUNCTION err_numchk(err_code)
   DEFINE err_code LIKE ze_file.ze01   #NO.FUN-680082  VARCHAR(7)
   DEFINE i        LIKE type_file.num5     #NO.FUN-680082  SMALLINT
   FOR i = 1 TO 7
      IF cl_null(err_code[i,i]) OR err_code[i,i] MATCHES "[-0123456789]" THEN
         CONTINUE FOR
      ELSE
         RETURN FALSE
      END IF
   END FOR
   RETURN TRUE
END FUNCTION
 
# 由MRP限定版本(msp_file)組出對應的 sql
FUNCTION p500_get_sql()
DEFINE l_msp RECORD LIKE msp_file.*
DEFINE l_n,l_n2,l_n3   LIKE type_file.num5     #NO.FUN-680082  SMALLINT    # 倉庫, 單據, 指送地址
DEFINE l_i             LIKE type_file.num5     #NO.FUN-680082  SMALLINT
DEFINE g_sw            LIKE type_file.chr1     #NO.FUN-680082  VARCHAR(1)
DEFINE l_star          LIKE type_file.chr1     #NO.FUN-680082  VARCHAR(1)    # 是否有星號
 
  LET l_n = 1
  LET l_n2= 1
  LET l_n3= 1
  DECLARE sel_msp_cur CURSOR FOR
   SELECT * FROM msp_file WHERE msp01 = g_msp01
  FOREACH sel_msp_cur INTO l_msp.*
    IF STATUS THEN CALL cl_err('for msp:',STATUS,0) EXIT FOREACH END IF
 
    # 倉別
    LET l_star='N'
    IF NOT cl_null(l_msp.msp03) THEN
      ## 先判斷有沒有星號
      FOR l_i=1 TO LENGTH(l_msp.msp03)
        IF l_msp.msp03[l_i,l_i]='*' THEN
          IF l_msp.msp10 = '0' THEN  #No.FUN-9C0121
             IF l_n=1 THEN
                LET g_sql = g_sql CLIPPED,
                            " AND (imd01 MATCHES '",l_msp.msp03 CLIPPED,"'" 
             ELSE
                LET g_sql = g_sql CLIPPED,
                            "  OR imd01 MATCHES '",l_msp.msp03 CLIPPED,"'" 
             END IF
          ELSE
             IF l_n=1 THEN
                LET g_sql = g_sql CLIPPED,
                            " AND (imd01 NOT MATCHES '",l_msp.msp03 CLIPPED,"'"
             ELSE
                LET g_sql = g_sql CLIPPED,
                           #"  OR imd01 NOT MATCHES '",l_msp.msp03 CLIPPED,"'"        #MOD-C10042 mark
                            "  AND imd01 NOT MATCHES '",l_msp.msp03 CLIPPED,"'"       #MOD-C10042 add
             END IF
          END IF
          LET l_star='Y'
          EXIT FOR
        END IF
      END FOR
 
      ## 若沒有星號
      IF l_star='N' THEN
        IF l_msp.msp10 = '0' THEN  #No.FUN-9C0121
           IF l_n=1 THEN
              LET g_sql = g_sql CLIPPED," AND (imd01 = '",l_msp.msp03 ,"'"
           ELSE
              LET g_sql = g_sql CLIPPED,"  OR imd01 = '",l_msp.msp03 ,"'" 
           END IF
        ELSE
           IF l_n=1 THEN
              LET g_sql = g_sql CLIPPED," AND (imd01 <> '",l_msp.msp03 ,"'"
           ELSE
             #LET g_sql = g_sql CLIPPED,"  OR imd01 <> '",l_msp.msp03 ,"'"      #MOD-C10042 mark
              LET g_sql = g_sql CLIPPED,"  AND imd01 <> '",l_msp.msp03 ,"'"     #MOD-C10042 add
           END IF
        END IF
      END IF
      LET l_n = l_n + 1
    END IF
 
    # 單據
    LET l_star='N'
    IF NOT cl_null(l_msp.msp04) THEN
      FOR l_i=1 TO LENGTH(l_msp.msp04)
        IF l_msp.msp04[l_i,l_i]='*' THEN
         IF l_msp.msp10 = '0' THEN  #No.FUN-9C0121
          IF l_n2=1 THEN
            LET g_sql1 = g_sql1 CLIPPED,
                         " AND (smyslip MATCHES '",l_msp.msp04 CLIPPED,"'"
            LET g_sql3 = g_sql3 CLIPPED,
                         " AND (msa01 MATCHES '",l_msp.msp04 CLIPPED,"'"
            LET g_sql5 = g_sql5 CLIPPED,
                         " AND (oayslip MATCHES '",l_msp.msp04 CLIPPED,"'"
          ELSE
            LET g_sql1 = g_sql1 CLIPPED,
                         "  OR smyslip MATCHES '",l_msp.msp04 CLIPPED,"'"
            LET g_sql3 = g_sql3 CLIPPED,
                         "  OR msa01  MATCHES '",l_msp.msp04 CLIPPED,"'"
            LET g_sql5 = g_sql5 CLIPPED,
                         "  OR oayslip MATCHES '",l_msp.msp04 CLIPPED,"'"
          END IF
         ELSE
          IF l_n2=1 THEN
            LET g_sql1 = g_sql1 CLIPPED,
                         " AND (smyslip NOT MATCHES '",l_msp.msp04 CLIPPED,"'"
            LET g_sql3 = g_sql3 CLIPPED,
                         " AND (msa01 NOT MATCHES '",l_msp.msp04 CLIPPED,"'"
            LET g_sql5 = g_sql5 CLIPPED,
                         " AND (oayslip NOT MATCHES '",l_msp.msp04 CLIPPED,"'"
          ELSE
            LET g_sql1 = g_sql1 CLIPPED,
                        #"  OR smyslip NOT MATCHES '",l_msp.msp04 CLIPPED,"'"           #MOD-C10042 mark
                         "  AND smyslip NOT MATCHES '",l_msp.msp04 CLIPPED,"'"          #MOD-C10042 add
            LET g_sql3 = g_sql3 CLIPPED,
                        #"  OR msa01 NOT MATCHES '",l_msp.msp04 CLIPPED,"'"             #MOD-C10042 mark
                         "  AND msa01 NOT MATCHES '",l_msp.msp04 CLIPPED,"'"            #MOD-C10042 add
            LET g_sql5 = g_sql5 CLIPPED,
                        #"  OR oayslip NOT MATCHES '",l_msp.msp04 CLIPPED,"'"           #MOD-C10042 mark
                         "  AND oayslip NOT MATCHES '",l_msp.msp04 CLIPPED,"'"          #MOD-C10042 add
          END IF
         END IF
          LET l_star='Y'
          EXIT FOR
        END IF
      END FOR
 
      IF l_star='N' THEN
       IF l_msp.msp10 = '0' THEN  #No.FUN-9C0121
        IF l_n2=1 THEN
          LET g_sql1 = g_sql1 CLIPPED," AND (smyslip = '",l_msp.msp04 ,"'"
          LET g_sql3 = g_sql3 CLIPPED," AND (msa01 like '",l_msp.msp04 ,"-%'"  #No.FUN-550055
          LET g_sql5 = g_sql5 CLIPPED," AND (oayslip = '",l_msp.msp04 ,"'"
        ELSE
          LET g_sql1 = g_sql1 CLIPPED,"  OR smyslip = '",l_msp.msp04 ,"'"
          LET g_sql3 = g_sql3 CLIPPED,"  OR msa01 like '",l_msp.msp04 ,"-%'"   #No.FUN-550055
          LET g_sql5 = g_sql5 CLIPPED,"  OR oayslip = '",l_msp.msp04 ,"'"
        END IF
       ELSE
        IF l_n2=1 THEN
          LET g_sql1 = g_sql1 CLIPPED," AND (smyslip != '",l_msp.msp04 ,"'"
          LET g_sql3 = g_sql3 CLIPPED," AND (msa01 NOT LIKE '",l_msp.msp04 ,"-%'"
          LET g_sql5 = g_sql5 CLIPPED," AND (oayslip != '",l_msp.msp04 ,"'"
        ELSE
         #LET g_sql1 = g_sql1 CLIPPED,"  OR smyslip != '",l_msp.msp04 ,"'"           #MOD-C10042 mark
          LET g_sql1 = g_sql1 CLIPPED,"  AND smyslip != '",l_msp.msp04 ,"'"          #MOD-C10042 add
         #LET g_sql3 = g_sql3 CLIPPED,"  OR msa01 NOT LIKE '",l_msp.msp04 ,"-%'"     #MOD-C10042 mark
          LET g_sql3 = g_sql3 CLIPPED,"  AND msa01 NOT LIKE '",l_msp.msp04 ,"-%'"    #MOD-C10042 add
         #LET g_sql5 = g_sql5 CLIPPED,"  OR oayslip != '",l_msp.msp04 ,"'"           #MOD-C10042 mark
          LET g_sql5 = g_sql5 CLIPPED,"  AND oayslip != '",l_msp.msp04 ,"'"          #MOD-C10042 add
        END IF
       END IF
      END IF
      LET l_n2 = l_n2 + 1
    END IF
 
    # 指送地址
    LET l_star='N'
    IF NOT cl_null(l_msp.msp05) THEN
#------No.MOD-580098 add判斷當msp05下'*'時的處理
      IF LENGTH(l_msp.msp05)=1 AND l_msp.msp05='*' THEN
         LET g_sql2 = NULL
         LET g_sql4 = NULL
      ELSE
 
      FOR l_i=1 TO LENGTH(l_msp.msp05)
        IF l_msp.msp05[l_i,l_i]='*' THEN
         IF l_msp.msp10 = '0' THEN   #No.FUN-9C0121
          IF l_n3=1 THEN
            LET g_sql2 = g_sql2 CLIPPED,
                         " AND (pmm10 MATCHES '",l_msp.msp05 CLIPPED,"'"
            LET g_sql4 = g_sql4 CLIPPED,
                         " AND (pmk10 MATCHES '",l_msp.msp05 CLIPPED,"'"
          ELSE
            LET g_sql2 = g_sql2 CLIPPED,
                         "  OR pmm10 MATCHES '",l_msp.msp05 CLIPPED,"'"
            LET g_sql4 = g_sql4 CLIPPED,
                         "  OR pmk10 MATCHES '",l_msp.msp05 CLIPPED,"'"
          END IF
         ELSE
          IF l_n3=1 THEN
            LET g_sql2 = g_sql2 CLIPPED,
                         " AND (pmm10 NOT MATCHES '",l_msp.msp05 CLIPPED,"'"
            LET g_sql4 = g_sql4 CLIPPED,
                         " AND (pmk10 NOT MATCHES '",l_msp.msp05 CLIPPED,"'"
          ELSE
            LET g_sql2 = g_sql2 CLIPPED,
                         "  OR pmm10 NOT MATCHES '",l_msp.msp05 CLIPPED,"'"
            LET g_sql4 = g_sql4 CLIPPED,
                         "  OR pmk10 NOT MATCHES '",l_msp.msp05 CLIPPED,"'"
          END IF
         END IF
          LET l_star='Y'
          EXIT FOR
        END IF
      END FOR
 
      IF l_star='N' THEN
       IF l_msp.msp10 = '0' THEN  #No.FUN-9C0121
        IF l_n3=1 THEN
          LET g_sql2 = g_sql2 CLIPPED," AND (pmm10 = '",l_msp.msp05 ,"'"
          LET g_sql4 = g_sql4 CLIPPED," AND (pmk10 = '",l_msp.msp05 ,"'"
        ELSE
          LET g_sql2 = g_sql2 CLIPPED,"  OR pmm10 = '",l_msp.msp05 ,"'"
          LET g_sql4 = g_sql4 CLIPPED,"  OR pmk10 = '",l_msp.msp05 ,"'"
        END IF
       ELSE
        IF l_n3=1 THEN
          LET g_sql2 = g_sql2 CLIPPED," AND (pmm10 != '",l_msp.msp05 ,"'"
          LET g_sql4 = g_sql4 CLIPPED," AND (pmk10 != '",l_msp.msp05 ,"'"
        ELSE
         #LET g_sql2 = g_sql2 CLIPPED,"  OR pmm10 != '",l_msp.msp05 ,"'"     #MOD-C10042 mark
          LET g_sql2 = g_sql2 CLIPPED,"  AND pmm10 != '",l_msp.msp05 ,"'"    #MOD-C10042 add
         #LET g_sql4 = g_sql4 CLIPPED,"  OR pmk10 != '",l_msp.msp05 ,"'"     #MOD-C10042 mark
          LET g_sql4 = g_sql4 CLIPPED,"  AND pmk10 != '",l_msp.msp05 ,"'"    #MOD-C10042 add 
        END IF
       END IF
      END IF
      LET l_n3=l_n3+1
    END IF
 END IF
 
  END FOREACH
 
  IF NOT cl_null(g_sql)  THEN LET g_sql  = g_sql  CLIPPED," )"  END IF
  IF NOT cl_null(g_sql1) THEN LET g_sql1 = g_sql1 CLIPPED," )" END IF
  IF NOT cl_null(g_sql2) THEN LET g_sql2 = g_sql2 CLIPPED," )" END IF
  IF NOT cl_null(g_sql3) THEN LET g_sql3 = g_sql3 CLIPPED," )" END IF
  IF NOT cl_null(g_sql4) THEN LET g_sql4 = g_sql4 CLIPPED," )" END IF
  IF NOT cl_null(g_sql5) THEN LET g_sql5 = g_sql5 CLIPPED," )" END IF
 
END FUNCTION


 
FUNCTION p500_plan1()    
  DEFINE l_x_mss_v      LIKE mss_file.mss_v
  DEFINE l_x_mss01      LIKE mss_file.mss01
  DEFINE l_x_mss02      LIKE mss_file.mss02
  DEFINE l_x_mss03      LIKE mss_file.mss03
  DEFINE l_name         LIKE type_file.chr20    
  DEFINE l_cmd          LIKE type_file.chr1000  
 
     DECLARE p500_plan_d CURSOR FOR
       SELECT mss_v,mss01,mss02,mss03 FROM mss_file
        WHERE mss_v=ver_no 
     CALL cl_outnam('amrp500') RETURNING l_name    
     START REPORT p500_rep TO l_name               
 
     FOREACH p500_plan_d INTO l_x_mss_v,l_x_mss01,l_x_mss02,l_x_mss03
        IF STATUS THEN CALL err('p500_plan_d',STATUS,1) EXIT FOREACH END IF
        SELECT * INTO mss.* FROM mss_file
        WHERE mss_v=l_x_mss_v AND mss01=l_x_mss01 AND mss02=l_x_mss02 AND mss03=l_x_mss03
        OUTPUT TO REPORT p500_rep(l_x_mss_v,l_x_mss01,l_x_mss02,l_x_mss03,mss.*,'N')
     END FOREACH
     IF STATUS THEN CALL err('p500_plan_d',STATUS,1) END IF
     FINISH REPORT p500_rep
     IF os.Path.chrwx(l_name CLIPPED,511) THEN END IF   #No.FUN-9C0009
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/18

#FUN-A80102(S)
FUNCTION p500_set_ui()
   CALL cl_set_comp_visible('msr10',FALSE)  #No.FUN-9C0121 Add
   
   IF g_sma.sma1421='Y' THEN
      CALL cl_set_comp_visible('msr919',TRUE)
   ELSE
      CALL cl_set_comp_visible('msr919',FALSE)
   END IF
END FUNCTION

FUNCTION p500_set_msr919(p_sql,p_fieldname)
   DEFINE p_sql,l_sql  STRING
   DEFINE p_fieldname  STRING
   DEFINE l_cnt        LIKE type_file.num5
   DEFINE l_oeb919     LIKE oeb_file.oeb919
   DEFINE l_str        STRING
   
   LET l_cnt = p_sql.getindexof('FROM',5)
   IF l_cnt > 0 THEN
      LET l_sql = "SELECT DISTINCT(",p_fieldname,") FROM "
                  #p_sql.substring(l_cnt + 4,p_sql.getlength()),   #MOD-C80241 mark
                  #" ORDER BY ",p_fieldname                        #MOD-C80241 mark
      #MOD-C80241  add begin----------------------
      CASE 
         WHEN lot_type='1' AND p_fieldname='msb919'
            LET l_sql = l_sql CLIPPED,p_sql.substring(l_cnt + 4,p_sql.getlength()),
                                     " AND (msb01 MATCHES '",lot_no1 CLIPPED,"'"
            IF NOT cl_null(lot_no2) THEN
                LET l_sql = l_sql CLIPPED," OR msb01 MATCHES '",lot_no2 CLIPPED,"')"
            ELSE
                LET l_sql = l_sql CLIPPED,')'
            END IF 
         WHEN lot_type='2' AND p_fieldname='sfb919'
            LET l_sql = l_sql CLIPPED,p_sql.substring(l_cnt + 4,p_sql.getlength()),
                                     " AND (sfb01 MATCHES '",lot_no1 CLIPPED,"'"
            IF NOT cl_null(lot_no2) THEN
                LET l_sql = l_sql CLIPPED," OR sfb01 MATCHES '",lot_no2 CLIPPED,"')"
            ELSE
                LET l_sql = l_sql CLIPPED,')'
            END IF 
         WHEN lot_type='3' AND p_fieldname='oeb919'
            LET l_sql = l_sql CLIPPED,p_sql.substring(l_cnt + 4,p_sql.getlength()),
                                     " AND (oeb01 MATCHES '",lot_no1 CLIPPED,"'"
            IF NOT cl_null(lot_no2) THEN
                LET l_sql = l_sql CLIPPED," OR oeb01 MATCHES '",lot_no2 CLIPPED,"')"
            ELSE
                LET l_sql = l_sql CLIPPED,')'
            END IF 
         WHEN lot_type='5' AND p_fieldname='sfb919'
            LET l_sql = l_sql CLIPPED," msf_file,",p_sql.substring(l_cnt + 4,p_sql.getlength()),
                                     " AND (msf01 MATCHES '",lot_no1 CLIPPED,"'"
            IF NOT cl_null(lot_no2) THEN
                LET l_sql = l_sql CLIPPED," OR msf01 MATCHES '",lot_no2 CLIPPED,"')"
            ELSE
                LET l_sql = l_sql CLIPPED,')'
            END IF
            LET l_sql = l_sql CLIPPED," AND msf02=sfb01"
         WHEN lot_type='7' AND p_fieldname='oeb919'
            LET l_sql = l_sql CLIPPED," msj_file,",p_sql.substring(l_cnt + 4,p_sql.getlength()),
                                     " AND (msj01 MATCHES '",lot_no1 CLIPPED,"'"
            IF NOT cl_null(lot_no2) THEN
                LET l_sql = l_sql CLIPPED," OR msj01 MATCHES '",lot_no2 CLIPPED,"')"
            ELSE
                LET l_sql = l_sql CLIPPED,')'
            END IF
            LET l_sql = l_sql CLIPPED," AND msj02=oeb01"
         OTHERWISE 
            LET l_sql = l_sql CLIPPED,p_sql.substring(l_cnt + 4,p_sql.getlength())
      END CASE 
      LET l_sql = l_sql CLIPPED," ORDER BY ",p_fieldname
      #MOD-C80241  add begin----------------------
      PREPARE p500_set_msr919_p FROM l_sql
      DECLARE p500_set_msr919_c CURSOR FOR p500_set_msr919_p
      FOREACH p500_set_msr919_c INTO l_oeb919
         LET g_msr919 = g_msr919 , l_oeb919 CLIPPED, ","
      END FOREACH
   END IF
END FUNCTION

FUNCTION p500_upd_msr919()
   DEFINE l_str        STRING
   DEFINE l_comeon     STRING
   DEFINE l_msr919     LIKE msr_file.msr919
   DEFINE l_cnt        LIKE type_file.num5

   LET l_str = g_msr919
   LET l_str = l_str.trim()
   IF l_str.getlength() > 0 THEN
      LET l_cnt = l_str.getlength()
      LET l_comeon = l_str.substring(l_cnt,l_cnt)
      IF  l_comeon=',' THEN
         LET l_str = l_str.substring(1,l_cnt-1)
      END IF
   END IF
   LET l_msr919 = l_str
   DISPLAY l_msr919 TO FORMONLY.msr919
   UPDATE msr_file SET msr919= l_msr919 WHERE msr_v = msr.msr_v
END FUNCTION
#FUN-A80102(E)

