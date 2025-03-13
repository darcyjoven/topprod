# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Program name...: asfi301_sub.4gl
# Description....: 提供asfi301.4gl使用的sub routine
# Date & Author..: 07/03/22 by kim (FUN-730012)
# Modify.........: No.TQC-730022 07/03/28 rainy 流程自動化
# Modify.........: No.MOD-740060 07/04/26 By pengu 訂單轉工單判斷訂單是否已開立工單應排除5.再加工工單或8.重工委外工單
# Modify.........: No.FUN-740034 07/05/14 By kim 確認過帳不使用rowid,改用單號
# Modify.........: No.CHI-710050 07/06/04 By jamie 若單身備料皆為消耗性料件時,則提醒完工方式應為2.領料(事後領料)
# Modify.........: No.MOD-790106 07/09/28 By Pengu 將5716行的QLCA.SQLCODE判斷往上移
# Modify.........: No.FUN-810038 08/02/22 By kim GP5.1 ICD
# Modify.........: No.CHI-830025 08/02/22 By kim GP5.1 ICD
# Modify.........: No.CHI-830032 08/03/31 By kim GP5.1整合測試修改
# Modify.........: No.MOD-840274 08/04/20 By kim GP5.1顧問測試修改
# Modify.........: No.MOD-840419 08/04/21 By Pengu 委外工單確認後按委外採購,第一次不會顯示委外採購資訊
# Modify.........: No.MOD-860016 08/06/02 By claire 一對多的委外工單拋轉後的委外採購單, 簽核否依單別設定
# Modify.........: No.MOD-840586 08/07/10 By Pengu 工單來源為訂單時在確認時未考慮訂單與工單之間的單位換算率
# Modify.........: No.FUN-870117 08/07/25 by ve007 工單審核時判斷制程是否審核
# Modify.........: No.CHI-7B0034 08/07/31 By sherry 增加被替代料(sfa27)為Key值
# Modify.........: No.MOD-880016 08/08/04 By ve007 
# Modify.........: No.FUN-870092 08/08/14 By Mandy 平行加工
# Modify.........: No.MOD-890023 08/09/04 By chenyu ICD功能測試
# Modify.........: No.MOD-870265 08/10/02 By claire 單位換算率的變數定義小數位放大減少誤差值
# Modify.........: No.FUN-8A0143 08/10/30 By Carrier 取價時，應該把'作業編號'傳入，配合apmi264的功能
# Modify.........: No.MOD-8B0086 08/11/10 By chenyu 工單沒有取替代料號時，讓sfs27=sfa27
# Modify.........: No.MOD-8B0151 08/11/14 By Sarah 當錯誤訊息為asf-899時,需Return不可確認
# Modify.........: No.MOD-8B0273 08/11/28 By chenyu 生成委外采購單時，單價和金額算法邏輯改變
# Modify.........: No.TQC-8C0034 08/12/18 By Mandy 確認時,若整體設定為機器,改成卡機器or機器群組有一筆資料即可
# Modify.........: No.FUN-910077 09/02/17 By kim for ICD-工單確認時所產生的發料單要自動過帳
# Modify.........: No.FUN-920054 09/02/24 By jan isnert 發料底稿單頭(sfp_file) 時增加對sfpconf的賦值;修改SQL語法錯誤
# Modify.........: No.FUN-920190 09/02/26 By kim 接續FUN-920054的修改，處理ICD工單取消確認和作廢，連同相關單據的處理
# Modify.........: No.FUN-8C0081 09/03/06 By sabrina 將確認段(i301sub_firm1)拆成check段(i301sub_firm1_chk)、update段(i301sub_firm1_upd)
# Modify.........: No.FUN-930148 09/03/26 By ve007 采購取價和定價
# Modify.........: No.FUN-940008 09/04/20 By hongmei 工單確認后不回寫工單工藝首站的投入量ecm301 
# Modify.........: No.FUN-950021 09/05/26 By Carrier 其他作業呼叫時transaction會被打破，改寫此作業的transaction方式
# Modify.........: No.FUN-960130 09/08/13 By Sunyanchun 零售業的必要欄位賦值
# Modify.........: No.TQC-980183 09/08/26 By xiaofeizhu 還原MOD-8B0273修改的內容
# Modify.........: No.FUN-980008 09/08/18 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-960317 09/09/04 By Carrier 修正GP5.2 shell產生的問題
# Modify.........: No.MOD-990117 09/10/08 By Smapmin asfi301_icd開委外工單產生委外採購單時，若有委外代買料，採購單不會自動確認
# Modify.........: No.MOD-9A0044 09/10/12 By Pengu 取消aic-144的控管
# Modify.........: No.CHI-980013 09/11/02 By jan 程式調整(修改產生發料底稿單身sql條件)
# Modify.........: No.CHI-980072 09/11/03 By jan 送簽之前先檢查若工藝編號不存在于aeci100,則出錯返回
# Modify.........: No.FUN-9B0016 09/10/31 By sunyanchun post no
# Modify.........: No.FUN-980033 09/11/11 By jan asfi301_icd新增時,打線圖/PKG type可以不必輸入
# Modify.........: No.TQC-9B0079 09/11/19 By Carrier VMI 赋值
# Modify.........: No.TQC-9B0094 09/11/19 By Carrier 错误处理机制
# Modify.........: No.TQC-9B0199 09/11/24 By sherry 1、修正無法轉采購單的問題 
#                                                   2、開單自動審核時，不需要再開窗詢問
# Modify.........: No:MOD-9B0157 09/11/25 By lilingyu asfp200整批審核時,選擇多筆單身資料,仍然需一筆一筆的確認
# Modify.........: No.TQC-9B0203 09/11/25 By douzh pmn58為NULL時賦初始值0
# Modify.........: No:MOD-960340 09/11/27 By sabrina 調整IF l_sfb.sfb22[1,3] != 'MRP'的判斷式
# Modify.........: No:TQC-9B0214 09/11/25 By Sunyanchun  s_defprice --> s_defprice_new
# Modify.........: No.FUN-9C0072 10/01/11 By vealxu 精簡程式碼
# Modify.........: No.FUN-A20037 10/03/15 By lilingyu 替代碼sfa26加上"7,8,Z"的條件
# Modify.........: No.FUN-A20048 10/03/30 By liuxqa 审核时，须判断工单有无备置，有的话，更新sfb104.
# Modify.........: No:MOD-A30236 10/03/31 By Summer INSERT INTO pmn_file前,增加pmn44的給值
# Modify.........: No:FUN-A30027 10/05/11 By jan 修正程序BUG
# Modify.........: No:CHI-A50038 10/05/27 By Summer 1.在ICD行業別時,將產生委外採購單段搬到i301sub_firm1_upd()
#                                                   2.在ICD行業別且委外採購單是由工單確認段產生過來時,pmmmksg給值為'N'
# Modify.........: No:FUN-A50066 10/06/09 By jan sfa_file/sfai_file key值調整
# Modify.........: No.FUN-A60027 10/06/21 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.FUN-A60076 10/07/01 By vealxu 製造功能優化-平行制程
# Modify.........: No:MOD-A60021 10/06/07 By Pengu 不做刻號BIN管理的工單在確認後也應自動產生發料單
# Modify.........: No:MOD-A30143 10/07/23 By Pengu 重工工單與拆件式供單不應控管須建BOM
# Modify.........: No:MOD-A30091 10/07/23 By Pengu 無法產生datecode
# Modify.........: No:MOD-A80061 10/08/09 By lilingyu 函數i301sub_firm1_upd()裡update語句重複
# Modify.........: No:FUN-A80054 10/09/09 By jan GP5.25 工單間合拼
# Modify.........: No:MOD-A80196 10/09/24 By 修改MOD-730044。將pmn90=pmn31移到call s_defprice()後面 
# Modify.........: No:FUN-A30093 10/09/30 By jan 程式還原
# Modify.........: No:FUN-A80060 10/09/30 By jan GP5.25 工單間合拼
# Modify.........: No:FUN-AA0007 10/10/29 By jan ICD 行業，aicp046/aicp047 不需要在工單確認段產生發料單
# Modify.........: No.FUN-AB0054 10/11/12 By zhangll 倉庫營運中心權限控管審核段控管
# Modify.........: No.TQC-AB0302 10/11/30 By vealxu 取消審核，沒有任何錯誤提示，直接沒有反應
# Modify.........: No.TQC-AB0410 10/12/04 By chenying 委外工單產生委外採購單的含稅單價為空
# Modify.........: No.TQC-AC0077 10/12/08 By jan 走平行工藝不走製程BOM,ecm301由發料單回寫
# Modify.........: No.TQC-AC0142 10/12/13 By jan 倒扣料時更新首站的ecm301
# Modify.........: No.TQC-AC0293 10/12/30 By vealxu sfp01的開窗/檢查要排除smy73='Y'的單據
# Modify.........: No.TQC-AC0257 10/12/22 By suncx s_defprice_new.4gl返回值新增兩個參數`
# Modify.........: No.MOD-AC0336 10/12/29 By jan 重抓製程料號
# Modify.........: No:MOD-B10124 11/01/18 By sabrina 若pmm22為NULL，則不CALL s_curr3()
# Modify.........: No.TQC-B10206 11/01/24 By destiny 审核时应检查申请人是否存在
# Modify.........: No:MOD-B20049 11/02/14 By Smapmin 採購單單頭總金額取位錯誤
# Modify.........: No:FUN-B10056 11/02/28 By lixh1   確認時進行製程段檢查
# Modify.........: No:FUN-B20070 11/03/03 By jan 工單間合拼，工單確認還原後，工單備料和製程追蹤重新產生
# Modify.........: No:FUN-B30017 11/03/04 By jan 判斷上製程段是否存在應改成ecm_file判斷
# Modify.........: No:MOD-B30473 11/03/14 By sabrina 取消作廢時需考慮工單數量是否超過訂單數量
# Modify.........: No.MOD-B30414 11/03/14 by jan 確認是否是合拼工單的條件更改
# Modify.........: No.FUN-B30098 11/03/22 By lixh1 於工單刪除時,如果該工單的pbi no單身沒有其他工單,刪除此pbi的sfc_file
# Modify.........: No:FUN-9A0095 11/04/14 By abby MES功能追版
# Modify.........: No:FUN-AC0074 11/05/11 By jan 若有備置單不可取消確認
# Modify.........: No:FUN-B50106 11/05/18 By lixh1 改icb05為imaicd14
# Modify.........: No:FUN-B50046 11/05/23 By abby APS GP5.25追版str-------------------
# Modify.........: No:FUN-960103 09/07/03 By Duke 原平行加工改為鎖定製程設備
# Modify.........: No:FUN-9A0047 09/10/20 By Mandy 當外包(ecm52)='N'時,才需判斷aps-033=>整體參數資源型態設機器時,機器編號和資源群組編號(機器),至少要有一個欄位有值!
# Modify.........: No:FUN-B50046 11/05/23 By abby APS GP5.25追版end-------------------
# Modify.........: No:FUN-AB0001 11/05/26 By Lilan 因asfi510 新增EasyFlow整合功能影響INSERT INTO sfp_file
# Modify.........: No:MOD-B50243 11/06/02 By Vampire 當 sma27='13'時，UPDATE sfb251=g_today
# Modify.........: No.FUN-A70095 11/06/14 By lixh1 撈取報工單(shb_file)的所有處理作業,必須過濾是已確認的單據
# Modify.........: No.FUN-B70015 11/07/08 By yangxf 經營方式默認給值'1'經銷
# Modify.........: No.FUN-B20095 11/07/14 By lixh1 新增sfq012 
# Modify.........: No:MOD-B70068 11/07/18 By Vampire 增加判斷 sfe_file 的資料
# Modify.........: No:FUN-B70008 11/07/20 By Abby 做刪除時,若與APS連結時IF NOT cl_null(g_sma.sma901) AND (g_sma.sma901='Y') THEN 當sfb222 不為空白有值時,需由sfb01 串回vod_file,將vod37設成'N',vod38清空
# Modify.........: No:TQC-B70086 11/07/20 By Abby FUN-B20070 add 工單間合拼，工單確認還原後，工單備料和製程追蹤會重新產生,其在跑CALL s_schdat之前會先刪除ecm_file,若是有跟APS整合,也應先刪除vmn_file和vnm_file
# Modify.........: No:FUN-B70074 11/07/27 By lixh1 增加行業別TABLE(sfsi_file)的處理
# Modify.........: No.TQC-B80022 11/08/02 By jason INSERT INTO ecm_file給ecm66預設值'Y'
# Modify.........: No.TQC-B40088 11/08/15 By lilingyu 若被替代料的發料單位批量是1,但是出現小數的時候能夠審核通過
# Modify.........: No.TQC-B90018 11/08/15 By 單身主料已經被替代的情況下,審核時出現小於最少發料量的錯誤提示 
# Modify.........: No.CHI-B80096 11/09/02 By xianghui 對組成用量(ecm62)/底數(63)/ecm66(關鍵報工點否)的預設值處理
# Modify.........: No.TQC-B80230 11/11/14 By Carrier 生成SUB PO时,单身的批号字段pmn56 default为0
# Modify.........: No.FUN-BB0084 11/11/23 By lixh1 增加數量欄位小數取位
# Modify.........: No.FUN-BC0008 11/12/02 By zhangll s_cralc4整合成s_cralc,s_cralc增加傳參
# Modify.........: No.FUN-BB0084 11/12/14 By lixh1 增加數量欄位小數取位
# Modify.........: No:FUN-C10035 12/01/11 By Lilan因應MES與EF整合同時存在時的修改
# Modify.........: No:FUN-BC0107 12/02/07 By Jason　s_aic_auto_no多一傳入參數
# Modify.........: No:FUN-C10002 12/02/02 By bart 作業編號pmn78帶預設值
# Modify.........: No:TQC-C20114 12/02/10 By jason Turnkey工單目前無自動編碼功能,該段程式應該拿掉
# Modify.........: No.TQC-BC0117 12/02/10 By destiny 转委外采购时未将项目编号带出
# Modify.........: No.TQC-BB0271 12/02/13 By Carrier insert PO时,pmm909='5',pmm905 = 'N'
# Modify.........: No:TQC-C20142 12/02/14 By zhangll 审核增加QPA管控
# Modify.........: No.MOD-B80116 12/02/15 By bart ICD行業別，當料件沒有設定母體料號(imaicd01)時，工單無法確認
# Modify.........: No.TQC-C20423 12/02/23 By wuxj l_sfa26 新增9類型
# Modify.........: No:MOD-C30006 12/03/06 By ck2yuan 若是事後扣料會卡到平行製程的控
# Modify.........: No:MOD-C30392 12/03/13 By bart 反應工單的回貨批號不要加上.01
# Modify.........: No:FUN-C30234 12/03/22 By bart 取價先抓自己,沒有才抓BODY
# Modify.........: No:FUN-C30281 12/04/02 By bart 單身母批預設發料單的第一筆母批,抓不到則抓工單的idb14
# Modify.........: No:FUN-C30250 12/04/02 By bart 廠內工單自動產生發料單
# Modify.........: No:FUN-C30274 12/04/09 By jason 依參數決定委外採購自動發出否FOR ICD
# Modify.........: No:FUN-C40089 12/04/30 By bart 原先以參數sma112來判斷採購單價可否為0的程式,全部改成判斷採購價格條件(apmi110)的pnz08
# Modify.........: No:MOD-C50036 12/05/08 By ck2yuan 元件在委外採購時,應將sfa26 帶到pmn42
# Modify.........: No:FUN-C50076 12/05/18 By bart 更改錯誤訊息代碼mfg3525->axm-627
# Modify.........: No:MOD-C50126 12/05/21 By suncx 工單轉委外採購時，來源單號欄位應該賦值工單編號
# Modify.........: No:TQC-C60019 12/06/04 By Sarah ICD行業別時,工單刪除與作廢均應做刻號/BIN資料的刪除
# Modify.........: No:TQC-C60025 12/06/06 By Sarah 1.ICD行業別,移除sfbiicd04
#                                                  2.ICD行業別,發料單作廢時,工單的狀態碼應該要還原成1.開立
# Modify.........: No:MOD-C60181 12/06/20 By suncx 工藝委外時，料件為代買，首站委外時，審核更新ecm301
# Modify.........: No.CHI-C30107 12/06/21 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:TQC-C60175 12/06/21 By suncx 還原MOD-C60181
# Modify.........: No:TQC-C60207 12/06/28 By lixh1 審核時控管廠商是否可用
# Modify.........: No:FUN-C70014 12/07/05 By wangwei 新增RUN CARD發料作業
# Modify.........: No:TQC-C80185 12/09/14 By chenjing 審核時控管開工日期不可小於開單日期
# Modify.........: No:MOD-C90061 12/09/20 By Elise 替代碼為6不應管控實際qpa不能為0
# Modify.........: No:CHI-C90045 12/10/09 By bart 委外工單確認時，自動產生委外採購單,發料單自動扣帳確認,工單確認需連動
# Modify.........: No:FUN-CA0022 12/10/24 By bart 缺type參數
# Modify.........: No.CHI-C90006 12/11/13 By bart 失效判斷
# Modify.........: No.FUN-CC0077 12/12/11 By Nicola 拉出來另單過單
# Modify.........: No.FUN-CB0087 12/12/14 By fengrui 倉庫單據理由碼改善
# Modify.........: No.MOD-CB0227 13/01/11 By Elise 工單作廢還原，判斷此bom是否存在或是否已發放
# Modify.........: No:FUN-CC0122 13/01/18 By Nina 修正MES標準整合外的工單無拋轉至MES，但在進行工單變更時卻拋轉MES並回饋工單不存在，導致該類工單變更拋轉失敗
# Modify.........: No:CHI-C80041 13/02/06 By bart 排除作廢
# Modify.........: No:CHI-D20010 13/02/19 By minpp 增加i501sub_x(参数'1'
# Modify.........: No.MOD-D30027 13/03/05 By bart ICD一般料不自動產生採購單與發料單
# Modify.........: No:MOD-D20173 13/03/07 By bart 標準工時/標準機時乘上生產數量sfb08
# Modify.........: No:MOD-D30070 13/03/08 By bart 依SMA904傳給 s_curr3
# Modify.........: No:CHI-C50029 13/03/08 By Alberti 當下階料皆為消耗性料件時，提示訊息並修改單頭扣帳方式為2:事後扣帳
# Modify.........: No:DEV-D30045 13/03/26 By TSD.JIE 1.調整確認自動產生barcode
#                                                    2.調整取消確認自動作廢barcode
# Modify.........: No:MOD-D40083 13/04/15 By bart 修改計算訂單數量條件
# Modify.........: No:CHI-D40024 13/04/16 By bart i301sub_tmp改成 array的方式
# Modify.........: No.DEV-D30043 13/04/17 By TSD.JIE 調整條碼自動編號(s_gen_barcode2)與條碼手動編號(s_diy_barcode)產生先後順序
# Modify.........: No:FUN-D40042 13/04/17 By fengrui 轉採購時，工單備註sfb96入採購單備註pmn100
# Modify.........: No.DEV-D40015 13/04/18 By Nina (1)調整取消確認時條碼作廢的檢核與Transaction
#                                                 (2)在取消確認時呼叫條碼作廢段 
# Modify.........: No.MOD-D50063 13/05/08 By suncx 委外工單時，根據asmi300中設置的委外類型帶出sfb100的值，其他工單sfb100=1
# Modify.........: No.MOD-D50249 13/05/29 By suncx 提示asf-607錯誤時g_success應賦值為N
# Modify.........: No.MOD-D60141 13/06/26 By suncx 工單單身備料檔無作業編號未空的資料時，工藝首站作業編號必須存在與備料檔中
# Modify.........: No.160614 16/06/14 By guanyao 更改未转工单数量，已转工单数量
# Modify.........: No.2021112901 21/11/29 By jc 审核自动同步SCM

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_pmm22 LIKE pmm_file.pmm22     #FUN-810038
DEFINE g_pmm42 LIKE pmm_file.pmm42     #FUN-810038
DEFINE g_sfb   RECORD LIKE sfb_file.*  #FUN-9A0095
DEFINE g_pnz08 LIKE pnz_file.pnz08     #FUN-C40089
#CHI-D40024---begin
DEFINE g_pmm_tmp       DYNAMIC ARRAY OF RECORD
                pmm01  LIKE pmm_file.pmm01
       END RECORD 
DEFINE g_tmp_idx LIKE type_file.num5
#CHI-D40024---end
#{
#作用:lock cursor
#回傳值:無
#}
FUNCTION i301sub_lock_cl()
   DEFINE l_forupd_sql STRING

   LET l_forupd_sql = "SELECT * FROM sfb_file WHERE sfb01 = ? FOR UPDATE"
   LET l_forupd_sql=cl_forupd_sql(l_forupd_sql)

   DECLARE i301sub_cl CURSOR FROM l_forupd_sql
   
   #FUN-A80054--begin--add-------------
   IF NOT s_industry('std') THEN
      LET l_forupd_sql = "SELECT * FROM sfbi_file WHERE sfbi01 = ? FOR UPDATE"
      LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
      DECLARE i301sub_cl_ind CURSOR FROM l_forupd_sql
   END IF
   #FUN-A80054--end--add---------------
END FUNCTION
 
FUNCTION i301sub_firm1_chk(l_sfb01,p_inTransaction)      #FUN-8C0081   #No.FUN-950021
   DEFINE p_inTransaction    LIKE type_file.num5         #原來是否在transaction中     #No.FUN-950021 
   DEFINE l_vmn08  LIKE vmn_file.vmn08     #TQC-8C0034 add
   DEFINE l_ecm     RECORD LIKE ecm_file.* #FUN-870092 add
   DEFINE l_vlj_err LIKE type_file.chr1    #FUN-870092 add
   DEFINE l_sfb01 LIKE sfb_file.sfb01
   DEFINE l_sfb    RECORD LIKE sfb_file.*
   DEFINE l_pmn01  LIKE pmn_file.pmn01    #FUN-8C0081 mark
   DEFINE l_cause  LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)   #No:7315 add
   DEFINE l_qty    LIKE sfb_file.sfb08   #bugno:5512
   DEFINE l_oeb12  LIKE oeb_file.oeb12   #bugno:5512
   DEFINE l_cnt    LIKE type_file.num5   #No.FUN-680121 LIKE type_file.num5
   DEFINE l_cnt1   LIKE type_file.num5   #CHI-710050 add #No.FUN-680121 LIKE type_file.num5
   DEFINE l_ima55  LIKE ima_file.ima55
   DEFINE l_ima562 LIKE ima_file.ima562  #No.MOD-6C0105 add
   DEFINE l_oeb05  LIKE oeb_file.oeb05   #No.MOD-6C0105 add
   DEFINE l_factor LIKE ima_file.ima31_fac  #No.FUN-680121 DEC(16,8)
   DEFINE l_ima910 LIKE ima_file.ima910     #FUN-550112
   DEFINE l_sfa27  LIKE sfa_file.sfa27      #MOD-540194
   DEFINE l_sfa26  LIKE sfa_file.sfa26      #MOD-540194
   DEFINE l_sfbi   RECORD LIKE sfbi_file.*
   DEFINE l_ica04  LIKE ica_file.ica04      #FUN-810038
   DEFINE l_ima01  LIKE ima_file.ima01      #FUN-810038
   DEFINE l_imaicd01  LIKE imaicd_file.imaicd01      #FUN-810038
   DEFINE l_imx00   LIKE imx_file.imx00,        #No.FUN-870117
          l_ecu10   LIKE ecu_file.ecu10         #No.FUN-870117 
   DEFINE l_ecm03    LIKE ecm_file.ecm03         #CHI-980072
   DEFINE l_ecm012    LIKE ecm_file.ecm012   #FUN-A50066
   DEFINE l_sfa30    LIKE sfa_file.sfa30  #Add No.FUN-AB0054
   DEFINE l_flag     LIKE type_file.num5  #MOD-AC0336
   DEFINE l_ima571   LIKE ima_file.ima571 #MOD-AC0336
#TQC-B40088 --begin--
   DEFINE l_ima64       LIKE ima_file.ima64,
          l_ima641      LIKE ima_file.ima641,
          l_num_y       LIKE sfa_file.sfa05,     
          l_num_z       LIKE type_file.num20,
          l_sfa03       LIKE sfa_file.sfa03,
          l_sfa05       LIKE sfa_file.sfa05     
#TQC-B40088 --end--
   DEFINE l_sfa161  LIKE sfa_file.sfa161      #TQC-C20142 add
   DEFINE l_sfa11   LIKE sfa_file.sfa11       #TQC-C20142 add
   DEFINE l_cnt2    LIKE type_file.num5       #TQC-C60207 add
   DEFINE l_ecu02    LIKE ecu_file.ecu02
   DEFINE l_sfb86_cnt_n LIKE type_file.num5   #MOD-D60245 add
   DEFINE l_ecm03_par   LIKE ecm_file.ecm03_par   #add by sunyan 201221
 
   WHENEVER ERROR CALL cl_err_msg_log   #No.TQC-9B0094

   LET g_success='Y'
   IF cl_null(p_inTransaction) THEN
      LET p_inTransaction = FALSE
   END IF
#CHI-C30107 ----------------- add --------------------- begin
   SELECT * INTO l_sfb.* FROM sfb_file WHERE sfb01=l_sfb01 
   IF l_sfb.sfb87 = 'Y' THEN
      LET g_success='N' 
      CALL cl_err(l_sfb.sfb01,'9023',0) 
      RETURN
   END IF 
   IF l_sfb.sfb87 = 'X' THEN
      LET g_success='N' 
      CALL cl_err(l_sfb.sfb01,'9024',0)  
      RETURN
   END IF
   IF NOT cl_null(g_action_choice) THEN 
      IF g_b_confirm = 'Y' THEN ELSE
         IF NOT cl_confirm('axm-108') THEN
            LET g_success='N' 
            RETURN
          END IF
       END IF 
   END IF 
#CHI-C30107 ----------------- add --------------------- end
   SELECT * INTO l_sfb.* FROM sfb_file WHERE sfb01=l_sfb01  #FUN-730012
   IF cl_null(l_sfb.sfb01) THEN
      CALL cl_err('','-400',1)
      LET g_success='N'
      RETURN
   END IF
   LET l_cnt=0  #FUN-730012 add
   SELECT COUNT(*) INTO l_cnt FROM sfa_file WHERE sfa01 = l_sfb.sfb01
   IF l_cnt = 0 THEN
      CALL cl_err(l_sfb.sfb01,'mfg-009',0) #TQC-730022
      LET g_success='N' #FUN-730012 add
      RETURN
   END IF
   IF l_sfb.sfb87 = 'Y' THEN
      LET g_success='N' #FUN-730012 add
      CALL cl_err(l_sfb.sfb01,'9023',0)  #TQC-730022
      RETURN
   END IF #No.TQC-6C0114
   IF l_sfb.sfb87 = 'X' THEN
      LET g_success='N' #FUN-730012 add
      CALL cl_err(l_sfb.sfb01,'9024',0)  #TQC-730022
      RETURN
   END IF
   #Add No.FUN-AB0054
   IF NOT cl_null(l_sfb.sfb30) THEN
      IF NOT s_chk_ware(l_sfb.sfb30) THEN  #检查仓库是否属于当前门店
         LET g_success='N'
         RETURN
      END IF
   END IF
   #End Add No.FUN-AB0054

#TQC-C60207 ------------------Begin-----------------
   IF NOT cl_null(l_sfb.sfb82) THEN
      IF (l_sfb.sfb02=7 OR l_sfb.sfb02=8 ) THEN
         SELECT COUNT(*) INTO l_cnt2 FROM pmc_file
          WHERE pmc01 = l_sfb.sfb82
            AND pmcacti = 'Y'
      ELSE
         SELECT COUNT(*) INTO l_cnt2 FROM gem_file
          WHERE gem01 = l_sfb.sfb82
            AND gemacti = 'Y' 
      END IF
      IF cl_null(l_cnt2) THEN LET l_cnt2 = 0 END IF
      IF l_cnt2 = 0 THEN
         LET g_success='N'
         CALL cl_err(l_sfb.sfb82,'asf-683',1)
         RETURN
      END IF
   END IF         
#TQC-C60207 ------------------End-------------------

   #add by sunyan 201221---s
   SELECT DISTINCT ecm03_par INTO l_ecm03_par from ecm_file
    WHERE ecm01=l_sfb01
   IF l_ecm03 <>l_sfb.sfb05 THEN
     LET g_success='N'
      CALL cl_err(l_sfb.sfb01,'csf-318',0)
      RETURN
   END IF
   #add by sunyan 201221---e
#TQC-C80185--add--start--
   IF NOT cl_null(l_sfb.sfb81) AND NOT cl_null(l_sfb.sfb13) THEN
      IF l_sfb.sfb13 < l_sfb.sfb81 THEN
         CALL cl_err('','asf-607',1)
         LET g_success='N'   #MOD-D50249 add
         RETURN
      END IF
   END IF
#TQC-C80185--add--end--

#MOD-D60245 add start---------------------
   LET l_sfb86_cnt_n = 0
   SELECT COUNT(*) INTO l_sfb86_cnt_n FROM sfb_file
    WHERE sfb86 = l_sfb.sfb01 
      AND ( sfb86 IS NOT NULL AND sfb86 != ' ')
      AND sfb87 = 'N'
   IF cl_null(l_sfb86_cnt_n) THEN
      LET l_sfb86_cnt_n =  0
   END IF
   IF l_sfb86_cnt_n > 0 THEN 
      IF NOT cl_confirm("asf1054") THEN 
         LET g_success='N'
         RETURN
      END IF 
   END IF
#MOD-D60245 add end-----------------------

#TQC-B90018 --mark--begin--
##TQC-B40088 --begin--
#   DECLARE i301sub_sfa05 CURSOR FOR
#       SELECT sfa03,sfa05 FROM sfa_file  
#        WHERE sfa01=l_sfb.sfb01
#   FOREACH i301sub_sfa05 INTO l_sfa03,l_sfa05
#    
#     LET g_errno = ''
#     SELECT ima64,ima641 INTO l_ima64,l_ima641 FROM ima_file
#      WHERE ima01=l_sfa03
#     IF STATUS THEN 
#        LET l_ima64 = 0 
#        LET l_ima641 = 0 
#     END IF   
#     
#   #check最少發料數量
#     IF l_ima641 <>  0 AND l_sfa05 < l_ima641 THEN
#        LET g_errno = 'asf-100'
#     END IF
#     LET l_num_z=l_sfa05/l_ima64
#     LET l_num_y=l_sfa05-l_num_z*l_ima64
#     IF l_ima64 <> 0 AND (l_num_y) <> 0 THEN   
#        LET g_errno = 'asf-101'
#     END IF
#     IF NOT cl_null(g_errno) THEN 
#        CALL cl_err('',g_errno,0)
#        LET g_success = 'N'
#        RETURN 
#     END IF            
#   END FOREACH
##TQC-B40088 --end--
#TQC-B90018 --mark--end--

   #TQC-B10206--begin
   SELECT COUNT(*) INTO l_cnt FROM gen_file WHERE gen01=l_sfb.sfb44
   IF l_cnt=0 THEN 
      CALL cl_err(l_sfb.sfb44,'mfg1312',0)
      LET g_success='N'
      RETURN
   END IF 
   #TQC-B10206--end

   IF l_sfb.sfb93 = 'Y' THEN
      LET l_ecm03 = 0
      SELECT MIN(ecm03) INTO l_ecm03
        FROM ecm_file
       WHERE ecm01 = l_sfb.sfb01
      IF STATUS THEN LET l_ecm03 = 0 END IF
      IF cl_null(l_ecm03) OR l_ecm03 = 0 THEN
         CALL cl_err('','sdf-349',1)
         LET g_success='N'   #add by guanyao160803  
          RETURN 
      END IF
   END IF
   IF s_industry('slk') THEN        
      SELECT imx00 INTO l_imx00 FROM imx_file WHERE imx000= l_sfb.sfb05  #FUN-8C0081 add
      SELECT ecu10 INTO l_ecu10 FROM ecu_FILE
          WHERE ecu02 = l_sfb.sfb06   #FUN-8C0081 add
            AND ecu01 = l_imx00
            AND ecuacti = 'Y'  #CHI-C90006
      IF l_ecu10 !='Y'  THEN 
         LET g_success = 'N'   #FUN-950021
         CALL cl_err('','asf-425',1)
         RETURN   
      END IF 
   END IF 
   
  IF s_industry('icd') THEN
     #合理性檢查
     SELECT * INTO l_sfbi.* FROM sfbi_file WHERE sfbi01=l_sfb01
     CALL i301sub_ind_icd_chk('a',l_sfb.*,l_sfbi.*)  #檢查ICD的資料正確否,不正確則 let g_success= N
        RETURNING l_sfbi.*
     IF g_success = 'N' THEN RETURN END IF
 
     #當工單確認時，若單頭無母工單編號，則將單身料號的母體更改回單頭母體欄位
     IF cl_null(l_sfb.sfb86) THEN
        DECLARE upd_sfbiicd14_cs CURSOR FOR #CHI-830025
           #SELECT sfa03 FROM sfa_file  #FUN-CA0022
           # WHERE sfa01=l_sfb.sfb01    #FUN-CA0022
           SELECT sfb05 FROM sfb_file   #FUN-CA0022
            WHERE sfb01 = l_sfb.sfb01   #FUN-CA0022
        FOREACH upd_sfbiicd14_cs INTO l_ima01
            EXIT FOREACH
        END FOREACH
        IF NOT cl_null(l_ima01) THEN
           SELECT imaicd01 INTO l_imaicd01
             FROM imaicd_file
            WHERE imaicd00 = l_ima01
           
           LET l_sfbi.sfbiicd14 = l_imaicd01
           UPDATE sfbi_file SET sfbiicd14 = l_sfbi.sfbiicd14 WHERE sfbi01=l_sfb.sfb01 #MOD-840274
        END IF
     END IF
 

     #CHI-A50038 mark --start--
     #IF l_sfb.sfb02 MATCHES '[78]' AND l_sfb.sfb100 = '1' THEN  #一對一委外
     #   IF NOT p_inTransaction THEN   #No.FUN-950021
     #      BEGIN WORK
     #   END IF                        #No.FUN-950021
     #   CALL i301sub_ins_pmm(l_sfb.*) RETURNING l_pmn01
     #   IF g_success = 'Y' THEN 
     #      IF NOT p_inTransaction THEN   #No.FUN-950021
     #         COMMIT WORK 
     #      END IF                        #No.FUN-950021
     #   ELSE 
     #      IF NOT p_inTransaction THEN   #No.FUN-950021
     #         ROLLBACK WORK 
     #      END IF                        #No.FUN-950021
     #   END IF
     #END IF
     #
     #IF g_success = 'Y' THEN CALL i301sub_ind_icd_upd_pmm18(l_sfb.*) END IF   #委外採購自動確認
     #CHI-A50038 mark --end--

     IF g_success = 'N' THEN RETURN END IF
  END IF
   IF cl_null(l_sfb.sfb100) THEN
      CALL i301sub_sfb100(l_sfb.*) RETURNING l_sfb.sfb100  #TQC-730022
      IF cl_null(l_sfb.sfb100) THEN
          LET l_sfb.sfb100='1'
      END IF
      UPDATE sfb_file SET sfb100 = l_sfb.sfb100 WHERE sfb01=l_sfb.sfb01
      IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err3("upd","sfb_file",l_sfb.sfb01,"",STATUS,"","upd sfb100",1)  #No.FUN-660128 #FUN-730012
         LET g_success='N'
      END IF
   END IF
 
   DECLARE i301sub_chksfa26 CURSOR FOR
       SELECT sfa27,sfa26,sfa30,sfa11,sfa161 FROM sfa_file  #Mod No.FUN-AB0054 add sfa30 #TQC-C20142 add sfa11,sfa161
        WHERE sfa01=l_sfb.sfb01
   FOREACH i301sub_chksfa26 INTO l_sfa27,l_sfa26,l_sfa30,l_sfa11,l_sfa161  #Mod No.FUN-AB0054 add sfa30 #TQC-C20142 add sfa11,sfa161
   #  IF l_sfa26 NOT MATCHES '[0125]' THEN  #MOD-580229 012->0125  #FUN-A20037
    # IF l_sfa26 NOT MATCHES '[01257]' THEN                        #FUN-A20037  #TQC-C20423 --mark----
      IF l_sfa26 NOT MATCHES '[012579]' THEN                       #TQC-C20423  add 
        IF NOT i301sub_chk_sfa26(l_sfb.sfb01,l_sfa27,l_sfa26) THEN
           LET g_success='N' #FUN-730012 add
           RETURN
        END IF
      END IF
      #Add No.FUN-AB0054
      IF NOT cl_null(l_sfa30) THEN
         IF NOT s_chk_ware(l_sfa30) THEN  #检查仓库是否属于当前门店
            LET g_success='N'
            RETURN
         END IF
      END IF
      #End Add No.FUN-AB0054
      #TQC-C20142 add
       IF l_sfa11 != 'X' THEN
         IF NOT cl_null(l_sfa161) THEN
            IF l_sfa161 = 0 THEN
               IF l_sfa26 NOT MATCHES '[SUTZ6]' THEN  #MOD-C90061 add 6
                  CALL cl_err('','asf-106',0)
                  LET g_success='N'
                  RETURN
               END IF
            END IF
            IF l_sfa11 = 'S' THEN
               IF l_sfa161 > 0 THEN
                  CALL cl_err('','asf-605',0)
                  LET g_success='N'
                  RETURN
               END IF
            END IF
         END IF
      END IF
      #TQC-C20142 add--end
   END FOREACH

 # check max ecu02
 SELECT  ecu02 INTO l_ecu02 FROM ecu_file WHERE ecu01=l_sfb.sfb05 AND ecu10='Y' AND ROWNUM=1  ORDER BY ecu02 DESC

IF l_ecu02<>l_sfb.sfb06 THEN 
 CALL cl_err(l_sfb.sfb05,'csf-318',1) #TQC-730022
END IF  
   IF g_sma.sma26 !='1' THEN
      IF l_sfb.sfb93 = 'Y' AND l_sfb.sfb24 = 'Y' THEN
         LET l_cnt = 0
         SELECT count(*) INTO l_cnt FROM sfa_file
          WHERE sfa01 = l_sfb.sfb01
            AND (sfa08 !=' ' OR sfa08 !='' )
            AND sfa08 NOT IN (
                SELECT UNIQUE ecm04 FROM ecm_file
                 WHERE ecm01 = l_sfb.sfb01 )
         IF l_cnt > 0 THEN
            CALL cl_err(l_sfb.sfb01,'aim-801',1) #TQC-730022
            LET g_success='N' #FUN-730012 add
            RETURN
         END IF
        #MOD-D60141 add begin--------------------------
         LET l_ecm03 = 0
         SELECT MIN(ecm03) INTO l_ecm03
           FROM ecm_file
          WHERE ecm01 = l_sfb.sfb01
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM sfa_file
          WHERE sfa01 = l_sfb.sfb01
            AND (sfa08 = ' ' OR sfa08 = '' )
         IF l_cnt <= 0 THEN
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM sfa_file
             WHERE sfa01 = l_sfb.sfb01
               AND sfa08 IN (
                   SELECT ecm04 FROM ecm_file
                    WHERE ecm01 = l_sfb.sfb01 AND ecm03=l_ecm03)
            IF l_cnt <= 0 THEN
               CALL cl_err(l_sfb.sfb01,'asf1050',1)
               LET g_success='N'
               RETURN
            END IF 
         END IF
        #MOD-D60141 add end----------------------------
         #有跟APS串多控管以下
         IF NOT cl_null(g_sma.sma901) AND g_sma.sma901 = 'Y' THEN
             CALL s_showmsg_init()   
             DECLARE i301sub_chk_vlj CURSOR FOR
              SELECT *  
               FROM ecm_file
              WHERE ecm01 = l_sfb.sfb01
             LET l_vlj_err = 'N'
             FOREACH i301sub_chk_vlj INTO l_ecm.*
                 IF g_sma.sma917 = 1 THEN #機器編號
                     SELECT vmn08 INTO l_vmn08 
                       FROM vmn_file
                      WHERE vmn01  = l_sfb.sfb05
                        AND vmn02  = l_sfb.sfb01
                        AND vmn03  = l_ecm.ecm03
                        AND vmn04  = l_ecm.ecm04
                     IF l_ecm.ecm52 = 'N' THEN #FUN-9A0047 add if 判斷
                        IF cl_null(l_ecm.ecm05) AND cl_null(l_vmn08) THEN
                            #整體參數資源型態設機器時,機器編號和資源群組編號(機器),至少要有一個欄位有值!
                            CALL cl_getmsg('aps-033',g_lang) RETURNING g_showmsg 
                            LET g_showmsg = l_ecm.ecm03,'==>',g_showmsg
                            CALL s_errmsg('ecm03',g_showmsg,l_ecm.ecm01,STATUS,1)
                            LET l_vlj_err = 'Y'
                        END IF
                     END IF #FUN-9A0047 add
                 END IF
                 #FUN-960103 MARK --STR----------------------------------
                 #IF  l_ecm.ecm61 = 'Y' THEN #平行加工否 = 'Y'
                 #     SELECT COUNT(*) INTO l_cnt 
                 #       FROM vlj_file
                 #      WHERE vlj01 = l_ecm.ecm01
                 #        AND vlj02 = g_sma.sma917
                 #        AND vlj03 = l_ecm.ecm03
                 #        AND vlj05 <> 0
                 #     IF l_cnt <= 0 THEN
                 #         CALL cl_getmsg('aps-017',g_lang) RETURNING g_showmsg #該製程序的平行加工資料尚未維護!
                 #         LET g_showmsg = l_ecm.ecm03,'==>',g_showmsg
                 #         CALL s_errmsg('ecm03',g_showmsg,l_ecm.ecm01,STATUS,1)
                 #         LET l_vlj_err = 'Y'
                 #     END IF
                 #END IF
                 #FUN-960103 MARK --END------------------------------------
                 #FUN-960103 ADD --STR-------------------------------------
                  IF  l_ecm.ecm61 = 'Y' THEN #鎖定設備否 = 'Y'
                      SELECT COUNT(*) INTO l_cnt
                        FROM vne_file
                       WHERE vne01 = l_ecm.ecm01
                         AND vne02 = l_ecm.ecm01
                         AND vne03 = l_ecm.ecm03
                         AND vne05 <> ' '
                       IF l_cnt <= 0 THEN
                           CALL cl_getmsg('aps-771',g_lang) RETURNING g_showmsg
                           LET g_showmsg = l_ecm.ecm03,'==>',g_showmsg
                           CALL s_errmsg('ecm03',g_showmsg,l_ecm.ecm01,STATUS,1)
                           LET l_vlj_err = 'Y'
                       END IF
                  END IF

                 #FUN-960103 ADD --END-------------------------------------
             END FOREACH
             IF l_vlj_err = 'Y' THEN
                 CALL s_showmsg()   
                 LET g_success = 'N'
                 RETURN
             END IF
         END IF
      END IF
   END IF
 
  #No.B474 010507 by plum add 若此BOM尚未發放,不可用
  #FUN-A50066--begin--modify-------------------------
  #LET l_cnt=0
  #SELECT COUNT(*) INTO l_cnt FROM bma_file
  # WHERE bma01=l_sfb.sfb05
  #   AND bma06 = l_sfb.sfb95 #No.MOD-640245 add
  #IF l_cnt >0 AND l_sfb.sfb02 !=15 THEN   #NO:7112 此判斷應剔除 '15'試產性工單
  #   LET l_cnt=0
  #   SELECT COUNT(*) INTO l_cnt FROM bma_file
  #    WHERE bma05 IS NOT NULL AND bma05 <=l_sfb.sfb071
  #     AND bma01=l_sfb.sfb05
  #     AND bma06 = l_sfb.sfb95 #No.MOD-640245 add
  #   IF l_cnt =0 THEN
  #      CALL cl_err(l_sfb.sfb071,'abm-005',0)
  #      LET g_success='N' #FUN-730012 add
  #      RETURN
  #   END IF
  #   LET l_cnt=0
  #   SELECT COUNT(*) INTO l_cnt FROM bma_file
  #   WHERE bma05 IS NOT NULL AND bma05 <=l_sfb.sfb81
  #     AND bma01=l_sfb.sfb05
  #     AND bma06 = l_sfb.sfb95 #No.MOD-640245 add
  #   IF l_cnt =0 THEN
  #      CALL cl_err(l_sfb.sfb81,'abm-006',0)
  #      LET g_success='N' #FUN-730012 add
  #      RETURN
  #   END IF
  #END IF
   IF NOT i301sub_chk_sfb81(l_sfb.sfb93,l_sfb.sfb05,l_sfb.sfb95,l_sfb.sfb06,
                            l_sfb.sfb02,l_sfb.sfb071,l_sfb.sfb81) THEN
      LET g_success='N'
      RETURN
   END IF
  #FUN-A50066--end--modify----------------------------
 
  #No.+230 010629 add by linda check 若有產生製程檔時,其最後一站轉出單位
  #        必須與生產料號的生產單位相同
   IF i301sub_chk_ecm(l_sfb.sfb01,l_sfb.sfb24) THEN
      LET g_success='N' #FUN-730012 add
      RETURN
   END IF
 
#FUN-B10056 -------------------Begin---------------------
   IF (g_sma.sma541='Y' AND l_sfb.sfb93='Y' ) THEN
      IF g_success='Y' THEN
         CALL i700sub_chkbom(l_sfb.sfb01,'1')
         IF g_success = 'N' THEN
            RETURN
         END IF
      END IF            
   END IF
#FUN-B10056 -------------------End-----------------------
   #FUN-A50066--begin--add----------------
   #走平行工藝時，若首站製程序不需發料，則將標準產出量更新到ecm301
   IF (g_sma.sma542='Y' AND l_sfb.sfb93='Y' ) OR     #TQC-AC0077 
      (l_sfb.sfb93='Y' AND l_sfb.sfb39 = '2') THEN   #TQC-AC0142  #倒扣料時更新首站的ecm301
      DECLARE i301_upd_ecm301_c1 CURSOR FOR
              SELECT DISTINCT ecm012 FROM ecm_file
               WHERE ecm01=l_sfb.sfb01
                 AND ecm301=0
      FOREACH i301_upd_ecm301_c1 INTO l_ecm012
         IF g_sma.sma541='Y' THEN                      #MOD-C30006 add
            #若走平行工藝,須判斷如果本製程段無上製程段,
            #且為最小製程序,才需回寫 ecm301,否則由asft700回寫.   
            LET l_cnt = 0   
           #FUN-B30017--begin--modify----------
           #CALL s_schdat_sel_ima571(l_sfb.sfb01) RETURNING l_flag,l_ima571  #MOD-AC0336
           #SELECT COUNT(*) INTO l_cnt FROM ecu_file
           # WHERE ecu01=l_ima571    #MOD-AC0336
           #   AND ecu02=l_sfb.sfb06
           #   AND ecu015=l_ecm012
            SELECT COUNT(*) INTO l_cnt FROM ecm_file
             WHERE ecm01=l_sfb.sfb01
               AND ecm015=l_ecm012 
           #FUN-B30017--end--modify---------
            IF l_cnt > 0 THEN
               CONTINUE FOREACH
            END IF
         END IF                                        #MOD-C30006 add
         LET l_ecm03=NULL
         SELECT MIN(ecm03) INTO l_ecm03 FROM ecm_file
                                       WHERE ecm01=l_sfb.sfb01
                                         AND ecm012=l_ecm012
         IF l_ecm03 IS NOT NULL THEN
            LET l_cnt = 0
            IF l_sfb.sfb39 <> '2' THEN  #TQC-AC0142
               SELECT COUNT(*) INTO l_cnt FROM sfa_file
                                         WHERE sfa01=l_sfb.sfb01
                                           AND sfa012=l_ecm012
                                           AND sfa013=l_ecm03
            END IF  #TQC-AC0142
            IF l_cnt = 0 THEN #首製程無備料，表示不需發料 OR 倒扣料
               UPDATE ecm_file SET ecm301=ecm65
                             WHERE ecm01=l_sfb.sfb01
                               AND ecm012=l_ecm012
                               AND ecm03=l_ecm03
            END IF
         END IF
      END FOREACH   
   END IF
   #FUN-A50066--end--add-------------

   #check 總開工數 <= 訂單數量 (避免工單作廢後->取消作廢 造成總開工數 > 訂單量 )
   #select 總開工數
   SELECT SUM(sfb08) INTO l_qty FROM sfb_file
    WHERE sfb22 = l_sfb.sfb22 AND sfb221 = l_sfb.sfb221
      #AND (sfb04 <> '8' OR (sfb04 = '8' AND sfb08 = sfb09))  #MOD-D40083
      AND (sfb04 <> '8' OR (sfb04 = '8' AND sfb08 <= sfb09))  #MOD-D40083
      AND sfb02 !='5' AND sfb02 !='8'     #No.MOD-740060 add
      AND sfb87 !='X'
 
   LET l_cause = 'Y'
 
  #select 訂單數量
 
#--------------No.MOD-640197 modify
IF NOT cl_null(l_sfb.sfb22) AND NOT cl_null(l_sfb.sfb221) THEN  #No:MOD-960340 add
 #判斷來源若為MRP時不做check
  LET l_cnt=0   #MOD-B30414
  SELECT COUNT(*) INTO l_cnt FROM sfd_file WHERE sfd01=l_sfb.sfb85 AND sfd03=l_sfb.sfb01 AND (sfd07 IS NOT NULL AND sfd07<>' ') #MOD-B30414
  IF l_sfb.sfb22[1,3] != 'MRP' AND cl_null(l_sfb.sfb85) AND l_cnt > 0 THEN  #FUN-A80054 工單若需合拼，則也不需要檢查  #MOD-B30414
       SELECT oeb12,oeb05,ima55,(ima562+1) INTO l_oeb12,l_oeb05,l_ima55,l_ima562
        FROM oeb_file LEFT OUTER JOIN ima_file ON oeb04=ima01 
           WHERE oeb01 = l_sfb.sfb22 AND oeb03 = l_sfb.sfb221
           AND oeb70 = 'N'
 
      #check MPS 計劃的生產數量
      IF SQLCA.sqlcode OR cl_null(l_oeb12) THEN
          LET l_cause = 'N'
 
          SELECT msb05*ima55_fac INTO l_oeb12
            FROM msb_file LEFT OUTER JOIN ima_file ON msb03=ima01 ,msa_file
           WHERE msb01=l_sfb.sfb22 AND msb02=l_sfb.sfb221
             AND msb01=msa01 AND msa03 = 'N'
             AND msa05 <> 'X'  #CHI-C80041
          IF STATUS THEN LET l_oeb12 = 0 END IF
        ELSE
           CALL s_umfchk(l_sfb.sfb05,l_oeb05,l_ima55) RETURNING l_cnt,l_factor
           IF l_cnt = 1 THEN LET l_factor=1 END IF
            LET l_oeb12=l_oeb12*l_factor*l_ima562    
       END IF
       IF cl_null(l_qty)   THEN LET l_qty = 0 END IF
       IF cl_null(l_oeb12) THEN LET l_oeb12 = 0 END IF
       IF NOT cl_null(l_sfb.sfb22) AND NOT cl_null(l_sfb.sfb221) THEN
          IF l_qty > l_oeb12 THEN
             IF l_sfb.sfb02 NOT MATCHES '[58]' THEN    #MOD-740060 add
                IF s_industry('icd') THEN
                   IF l_cause = 'N' THEN
                      CALL cl_err(l_sfb.sfb01,'asf-011',1)
                      LET g_success='N'
                      RETURN
                   END IF
                   SELECT ica04 INTO l_ica04
                     FROM ica_file
                    WHERE ica00='0'
                   IF l_ica04 = 'Y' THEN
                      CALL cl_err(l_sfb.sfb01,'asf-005',1)
                      LET g_success='N'
                      RETURN
                   END IF
                ELSE
                   IF l_cause = 'Y' THEN
                      CALL cl_err(l_sfb.sfb01,'asf-005',1)  #TQC-730022
                   ELSE
                      CALL cl_err(l_sfb.sfb01,'asf-011',1)
                   END IF
                   LET g_success='N' #FUN-730012 add
                   RETURN
               END IF
 
             END IF             #MOD-740060 add
          END IF
       END IF
     ELSE
       IF l_oeb12 IS NULL THEN LET l_oeb12=0 END IF
       CALL s_umfchk(l_sfb.sfb05,l_oeb05,l_ima55) RETURNING l_cnt,l_factor
       IF l_cnt = 1 THEN LET l_factor=1 END IF
       LET l_oeb12=l_oeb12*l_factor*l_ima562
     END IF      #No.MOD-640197 end
    END IF      #No.MOD-960340 add 
 
    IF l_sfb.sfb39='1' THEN
       LET l_cnt=0
       SELECT COUNT(*) INTO l_cnt
         FROM sfa_file
        WHERE sfa01 = l_sfb.sfb01
 
       LET l_cnt1=0
       SELECT COUNT(*) INTO l_cnt1
         FROM sfa_file
        WHERE sfa01 = l_sfb.sfb01
          AND sfa11 = 'E'
 
       IF l_cnt <> 0 THEN
          IF l_cnt = l_cnt1 THEN
            #CHI-C50029 str add-----
             IF cl_confirm("asf-897") THEN
                LET l_sfb.sfb39 = '2'
                UPDATE sfb_file SET sfb39='2' WHERE sfb01=l_sfb.sfb01
                DISPLAY BY NAME l_sfb.sfb39
             ELSE
            #CHI-C50029 end add-----
                CALL cl_err('','asf-899',1)
                LET g_success='N'  #MOD-8B0151 add
                RETURN             #MOD-8B0151 add
             END IF             #CHI-C50029 add
          END IF
       END IF
    END IF
END FUNCTION      #FUN-8C0081 add
 
FUNCTION i301sub_firm1_upd(l_sfb01,l_action_choice,p_inTransaction)  #FUN-8C0081 add  #No.FUN-950021
  DEFINE p_inTransaction  LIKE type_file.num5    #No.FUN-950021
  DEFINE l_action_choice  STRING,
         l_sfb01          LIKE sfb_file.sfb01,
         l_sfbmksg        LIKE sfb_file.sfbmksg,
         l_sfb43          LIKE sfb_file.sfb43,
         l_sfb   RECORD   LIKE sfb_file.*,
         l_pmn01          LIKE pmn_file.pmn01,
         l_pmm18          LIKE pmm_file.pmm18,
         l_pmn02          LIKE pmn_file.pmn02,
         l_cnt            LIKE type_file.num5,
         l_ecm03          LIKE ecm_file.ecm03,
         l_ima55          LIKE ima_file.ima55,
         l_ecm57          LIKE ecm_file.ecm57,
         l_flag           LIKE type_file.num5,
         l_factorx        LIKE type_file.num26_10,
         l_ecm301         LIKE ecm_file.ecm301,
         l_ima56          LIKE ima_file.ima56,
         l_double         LIKE type_file.num10,
         l_mesg           LIKE type_file.chr1000
  DEFINE l_ica41          LIKE ica_file.ica41    #No:MOD-A60021 add
  DEFINE l_no             LIKE sfp_file.sfp01    #No:MOD-A60021 add
  DEFINE l_ica44          LIKE ica_file.ica44    #FUN-C30250
  DEFINE l_ica33          LIKE ica_file.ica33    #FUN-C30274 
  DEFINE l_imaicd04       LIKE imaicd_file.imaicd04  #MOD-D30027
  #2021112901 add----begin----
  DEFINE l_ret        RECORD
             success   LIKE type_file.chr1,
             code      LIKE type_file.chr10,
             msg       STRING
                       END RECORD
  ##2021112901 add----end----
  
   IF cl_null(p_inTransaction) THEN
      LET p_inTransaction = FALSE
   END IF
   LET g_success = 'Y'   #FUN-8C0081 add
   SELECT * INTO l_sfb.* FROM sfb_file WHERE sfb01=l_sfb01  #FUN-8C0081 add
 
   IF l_action_choice CLIPPED = "confirm" OR  #執行"確認"功能(非簽核模式呼叫)
      l_action_choice CLIPPED = "insert"
   THEN
      SELECT sfbmksg,sfb43 INTO l_sfbmksg,l_sfb43
        FROM sfb_file WHERE sfb01 = l_sfb01
      IF l_sfbmksg = "Y" THEN     #若簽核碼為'Y'且簽核狀況碼不為'1'已核准
         IF l_sfb43 != "1" THEN
            CALL cl_err('','aws-078',1)
            LET g_success = "N"
            RETURN
         END IF
      END IF
#CHI-C30107 ----------------- mark ---------------- begin
#     IF NOT cl_null(l_action_choice) THEN  #TQC-9B0199 add
#       IF g_b_confirm = 'Y' THEN ELSE   #MOD-9B0157
#        IF NOT cl_confirm('axm-108') THEN
#           LET g_success='N' #FUN-730012 add
#           RETURN
#        END IF
#       END IF  #MOD-9B0157
#     END IF  #TQC-9B0199 add
#CHI-C30107 ----------------- mark ---------------- end
   END IF
 
   LET g_success='Y'
 
   IF NOT p_inTransaction THEN  #No.FUN-950021
      BEGIN WORK
   END IF                       #No.FUN-950021
   
   CALL i301sub_lock_cl() #FUN-730012
   OPEN i301sub_cl USING l_sfb.sfb01
   IF STATUS THEN
      CALL cl_err("OPEN i301sub_cl:", STATUS, 1)
      CLOSE i301sub_cl
      IF NOT p_inTransaction THEN  #No.FUN-950021
         ROLLBACK WORK
      END IF                       #No.FUN-950021
      LET g_success='N' #FUN-730012 add
      RETURN
   END IF
 
   FETCH i301sub_cl INTO l_sfb.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err('lock sfb:',SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE i301sub_cl
      IF NOT p_inTransaction THEN  #No.FUN-950021
         ROLLBACK WORK
      END IF                       #No.FUN-950021
      LET g_success='N' #FUN-730012 add
      RETURN
   END IF

#FUN-A20048 --begin  检查备置档，更新sfb104栏位。
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt FROM sie_file WHERE sie05=l_sfb.sfb01
   IF l_cnt > 0 THEN
      UPDATE sfb_file SET sfb104='Y' WHERE sfb01=l_sfb.sfb01
      IF STATUS THEN
          CALL cl_err3("upd","sfb_file",l_sfb.sfb01,"",STATUS,"","upd sfb104",1)  #No.FUN-660128 #FUN-730012
          LET g_success='N'
      END IF
   ELSE 
      UPDATE sfb_file SET sfb104='N' WHERE sfb01=l_sfb.sfb01
      IF STATUS THEN
          CALL cl_err3("upd","sfb_file",l_sfb.sfb01,"",STATUS,"","upd sfb104",1)  #No.FUN-660128 #FUN-730012
          LET g_success='N'
      END IF
   END IF
#FUN-A20048 --end
 
   UPDATE sfb_file SET sfb87 = 'Y' WHERE sfb01=l_sfb.sfb01
   IF STATUS THEN
      CALL cl_err3("upd","sfb_file",l_sfb.sfb01,"",STATUS,"","upd sfb87",1)  #No.FUN-660128 #FUN-730012
      LET g_success='N'
   END IF

#MOD-A80061 --begin-- 
#   UPDATE sfb_file SET sfb87 = 'Y' WHERE sfb01=l_sfb.sfb01
#   IF STATUS THEN
#      CALL cl_err3("upd","sfb_file",l_sfb.sfb01,"",STATUS,"","upd sfb87",1)  #No.FUN-660128 #FUN-730012
#      LET g_success='N'
#   END IF
#MOD-A80061 --end--

   #已產生備料 and 工單狀態:1.確認生產工單(firm plan)
   IF g_sma.sma27 MATCHES '[13]' AND l_sfb.sfb23='Y' AND l_sfb.sfb04='1' THEN
   #  UPDATE sfb_file SET sfb04 = '2',sfb43='1' WHERE sfb01=l_sfb.sfb01  #FUN-8C0081 add sfb43   #MOD-B50243 mark
      UPDATE sfb_file SET sfb04 = '2',sfb43='1',sfb251=g_today WHERE sfb01=l_sfb.sfb01  #MOD-B50243 add
      IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err3("upd","sfb_file",l_sfb.sfb01,"",STATUS,"","upd sfb04",1)  #No.FUN-660128 #FUN-730012
           LET g_success='N'   #No.FUN-660128
      ELSE
         LET l_sfb.sfb04 ='2'                               #No.TQC-710006
         LET l_sfb.sfb43 = '1'   #FUN-8C0081 add
      END IF
      IF l_sfb.sfb02 MATCHES '[78]' AND l_sfb.sfb100='1' THEN   #委外工單 NO:6961 ,NO:7075
         DECLARE upd_pmn_cs CURSOR FOR
            SELECT pmn01,pmn02 FROM pmn_file WHERE pmn41=l_sfb.sfb01
 
         FOREACH upd_pmn_cs INTO l_pmn01,l_pmn02
              SELECT pmm18 INTO l_pmm18 FROM pmm_file   #NO:6961
               WHERE pmm01=l_pmn01
              IF l_pmm18='X' THEN CONTINUE FOREACH END IF
              #no.7231 參數設定單價不可為零
              #FUN-C40089---begin
              SELECT pnz08 INTO g_pnz08 FROM pnz_file,pmn_file,pmm_file
               WHERE pnz01=pmm41 AND pmm01=pmn01 AND pmn01=l_pmn01
              IF cl_null(g_pnz08) THEN 
                 LET g_pnz08 = 'Y'
              END IF 
              IF g_pnz08 = 'N' THEN 
              #IF g_sma.sma112= 'N' THEN 
              #FUN-C40089---end
                 LET l_cnt=0
                  IF s_industry('icd') THEN
                    #       一般代採買且作業群組為6.TKY的資料不受此限
                    SELECT COUNT(*) INTO l_cnt FROM pmn_file,pmni_file
                     WHERE pmn01  = l_pmn01
                       AND pmni01 = pmn01
                       AND pmni02 = pmn02
                       AND (pmn31 <=0 OR pmn44 <=0 )
                       #委外代採買　或 一般委外且作業群組<>'6'
                       AND (pmn65 = '2' OR
                            (pmn65 = '1' AND pmniicd03 NOT IN
                             (SELECT ecd01 FROM ecd_file WHERE ecdicd01 = '6')))
                 ELSE
                    SELECT COUNT(*) INTO l_cnt FROM pmn_file
                     WHERE pmn01 = l_pmn01
                       AND (pmn31 <=0 OR pmn44 <=0 )
                END IF
                 IF l_cnt > 0 THEN
                    CALL cl_err('Confirm PO:','axm-627',1)  #FUN-C50076
                    LET g_success ='N' EXIT FOREACH
                 END IF
              END IF
          END FOREACH
       ELSE
          IF l_sfb.sfb02 MATCHES '[78]' AND l_sfb.sfb100='2' THEN   #NO:6961,NO:7075
              LET l_cnt=0
              SELECT COUNT(*) INTO l_cnt
                FROM pmn_file
               WHERE pmn41=l_sfb.sfb01
              IF l_cnt >0 THEN
                   CALL cl_err(l_sfb.sfb01,'asf-933',0) LET g_success='N'
              ELSE
                 UPDATE sfb_file SET sfb87 = 'Y' WHERE sfb01=l_sfb.sfb01
                 IF STATUS THEN
                     CALL cl_err3("upd","sfb_file",l_sfb.sfb01,"",STATUS,"","upd sfb87:",1)  #No.FUN-660128
                     LET g_success='N'
                 END IF
              END IF
          END IF
       END IF
    END IF
    #FUN-9A0095-----start
     IF g_success = 'Y' AND g_aza.aza90 MATCHES "[Yy]" THEN
        # CALL aws_mescli()
        # 傳入參數: (1)程式代號
        #           (2)功能選項：insert(新增),update(修改),delete(刪除
        #           (3)Key
        # 新增工單
        IF l_sfb.sfb02 = '1' OR l_sfb.sfb02 = '5' OR  l_sfb.sfb02 = '13' THEN     #FUN-CC0122 add l_sfb.sfb02 = '5'
           CASE aws_mescli('asfi301','insert',l_sfb.sfb01)
              WHEN 1  #呼叫 MES 成功
                #MESSAGE 'CONFIRM O.K, INSERT MES O.K'         #FUN-C10035 mark
                 CALL cl_msg("CONFIRM O.K, INSERT MES O.K")    #FUN-C10035 add
              WHEN 2  #呼叫 MES 失敗
                LET g_success = 'N'
              OTHERWISE  #其他異常
                 LET g_success = 'N'
          END CASE
        END IF
     END IF
    #FUN-9A0095-------end
     IF g_success='Y' THEN
        #CHI-A50038 add --start--
        SELECT imaicd04 INTO l_imaicd04   #MOD-D30027
          FROM imaicd_file WHERE imaicd00= l_sfb.sfb05  #MOD-D30027
        #IF s_industry('icd') THEN   #MOD-D30027
        IF s_industry('icd') AND NOT cl_null(l_imaicd04) AND l_imaicd04 <> '9' THEN  #MOD-D30027
          #---------------------No:MOD-A60021 add
           IF NOT cl_null(l_action_choice) THEN   #FUN-AA0007
              LET l_cnt = 0 
              SELECT count(*) INTO l_cnt FROM sfq_file,sfp_file
               WHERE sfp01 = sfq01
                 AND sfq02 = l_sfb.sfb01
                 AND sfpconf != 'X'
           
              IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF 
              IF l_cnt = 0 THEN
                 SELECT ica33,ica41,ica44 INTO l_ica33,l_ica41,l_ica44 FROM ica_file WHERE ica00 = '0'   #FUN-C30250 #FUN-C30274 add ica33
                 IF l_sfb.sfb02 MATCHES '[78]' OR l_ica44 = 'Y' THEN     #FUN-C30250
                    # isnert 發料底稿單頭(sfp_file) 
                    IF g_success = 'Y' THEN CALL i301sub_ind_icd_ins_sfp(l_ica41,g_today,l_sfb.sfb81) RETURNING l_no END IF   
                 
                    # isnert 發料底稿單身(sfq_file)
                    IF g_success = 'Y' THEN CALL i301sub_ind_icd_ins_sfq(l_no,l_sfb.sfb01) END IF
                 
                    # isnert 發料底稿單身(sfs_file)
                    IF g_success = 'Y' THEN CALL i301sub_ind_icd_ins_sfs(l_no,l_sfb.sfb01) END IF
                 END IF   #FUN-C30250
              END IF
           END IF   #FUN-AA0007
           #---------------------No:MOD-A60021 end
           #CHI-C90045---begin
           IF g_success='Y' THEN
              CALL i301sub_icd_stock_post(l_sfb.sfb01) 
           END IF 
           #CHI-C90045---end
           IF l_sfb.sfb02 MATCHES '[78]' AND l_sfb.sfb100 = '1' AND g_success='Y' THEN  #一對一委外 #CHI-C90045
              CALL i301sub_ins_pmm(l_sfb.*) RETURNING l_pmn01  
           END IF

           IF g_success = 'Y' THEN CALL i301sub_ind_icd_upd_pmm18(l_sfb.*) END IF   #委外採購自動確認
           #FUN-C30274 --START--
           IF cl_null(l_ica33) THEN
              SELECT ica33 INTO l_ica33 FROM ica_file WHERE ica00 = '0'   
           END IF 
           IF g_success = 'Y' AND l_ica33 = 'Y'  THEN
              CALL i301sub_ind_icd_upd_pmm25(l_sfb.*)                               #委外採購自動發出
           END IF 
           #FUN-C30274 --END--
        END IF
        #CHI-A50038 add --end--

        IF l_sfb.sfbmksg = "Y" AND l_sfb.sfb87 = "N" THEN         #簽核模式
           CASE aws_efapp_formapproval()    #呼叫EF簽核功能
                WHEN 0   #呼叫EF簽核失敗
                   LET l_sfb.sfb87 = "N"
                   LET g_success = "N"
                   IF NOT p_inTransaction THEN  #No.FUN-950021
                      ROLLBACK WORK
                   END IF                       #No.FUN-950021
                   RETURN
                WHEN 2   #當最後一關有2個以上簽核者且此次簽核完成後尚未結案
                   LET l_sfb.sfb87 = "N"
                   IF NOT p_inTransaction THEN  #No.FUN-950021
                      ROLLBACK WORK
                   END IF                       #No.FUN-950021
                   RETURN
           END CASE
        END IF
        IF g_success ="Y" THEN
           LET l_sfb.sfb43 = "1"
           LET l_sfb.sfb87 = "Y"
           IF NOT p_inTransaction THEN  #No.FUN-950021
              COMMIT WORK
           END IF                       #No.FUN-950021
           CALL cl_flow_notify(l_sfb.sfb01,'Y')
           #2021112901 add----begin----
           IF cl_getscmparameter() THEN
             INITIALIZE l_ret TO NULL
             CALL cjc_zmx_json_sfb(l_sfb.sfb01) RETURNING l_ret.*
             IF l_ret.success = 'Y' THEN

             ELSE
                IF cl_null(l_ret.msg) THEN
                  LET l_ret.msg = "工单(",l_sfb.sfb01 CLIPPED,")同步失败"
                END IF
                CALL cl_err(l_ret.msg,'!',1)
             END IF
           END IF
           #2021112901 add----end----
        ELSE
           LET l_sfb.sfb87 = "N"
           LET g_success = "N"
           IF NOT p_inTransaction THEN  #No.FUN-950021
              ROLLBACK WORK
           END IF                       #No.FUN-950021
        END IF
     ELSE
        LET l_sfb.sfb87 = "N"
        LET g_success = "N"
        IF NOT p_inTransaction THEN  #No.FUN-950021
           ROLLBACK WORK
        END IF                       #No.FUN-950021
     END IF

   #DEV-D30045--add--begin
   #自動產生barcode
   IF g_success='Y' AND g_aza.aza131 = 'Y' THEN
      CALL i301sub_barcode_gen(l_sfb.sfb01,'N')
   END IF
   #DEV-D30045--add--end
END FUNCTION
 
FUNCTION i301sub_chk_sfa26(p_sfa01,p_sfa27,p_sfa26)
DEFINE l_cnt   LIKE type_file.num10   #No.FUN-680121 LIKE type_file.num10
DEFINE p_sfa01 LIKE sfa_file.sfa01
DEFINE p_sfa27 LIKE sfa_file.sfa27
DEFINE p_sfa26,l_sfa26 LIKE sfa_file.sfa26
DEFINE l_result        LIKE type_file.num5     #No.FUN-680121 LIKE type_file.num5
 
 LET l_result=TRUE
 LET l_cnt = 0
 CASE
    WHEN p_sfa26 MATCHES '[348]'                          #FUN-A20037 add 8
       SELECT COUNT(*) INTO l_cnt FROM sfa_file
          WHERE sfa01=p_sfa01
            AND sfa27=p_sfa27
            AND (sfa26='S' OR sfa26='U' OR sfa26 = 'Z')   #FUN-A20037 add 'Z'
    WHEN p_sfa26 MATCHES '[SUZ]'                          #FUN-A20037 ADD 'Z'  
       SELECT COUNT(*) INTO l_cnt FROM sfa_file
          WHERE sfa01=p_sfa01
            AND sfa27=p_sfa27
            AND (sfa26='3' OR sfa26='4' OR sfa26 = '8')   #FUN-A20037 add '8'
    WHEN p_sfa26 MATCHES '[6]' #MOD-5A0032改成 WHEN p_sfa26 MATCHES '[6]'
       SELECT COUNT(*) INTO l_cnt FROM sfa_file
          WHERE sfa01=p_sfa01
            AND sfa26='T'
    WHEN p_sfa26='T'
       SELECT COUNT(*) INTO l_cnt FROM sfa_file
          WHERE sfa01=p_sfa01
            AND (sfa26='5' OR sfa26='6')
    OTHERWISE
       LET l_cnt=0
  END CASE
  IF l_cnt=0 THEN
    CALL cl_err('chk sfa26','asf-304',1)
    LET l_result=FALSE
  END IF
  RETURN l_result
END FUNCTION
 
#No.+230 010629 add by linda check 最後一站轉出單位必須同sfb05之生產單位
FUNCTION i301sub_chk_ecm(p_sfb01,p_sfb24)
  DEFINE l_ecm03 LIKE ecm_file.ecm03,
         l_ecm58 LIKE ecm_file.ecm58,
         l_ima55 LIKE ima_file.ima55,
         p_sfb01 LIKE sfb_file.sfb01,
         p_sfb24 LIKE sfb_file.sfb24
 
   IF p_sfb24 ='N' THEN RETURN 0 END IF
   LET l_ecm03=''  LET l_ecm58=''
   DECLARE ecm_chk CURSOR FOR
      SELECT ecm03,ecm58
        FROM ecm_file
       WHERE ecm01 = p_sfb01
        ORDER BY ecm03 DESC
   FOREACH ecm_chk INTO l_ecm03,l_ecm58
     IF SQLCA.SQLCODE THEN
        CALL cl_err('ecm chk:',SQLCA.SQLCODE,0)
        EXIT FOREACH
     END IF
     EXIT FOREACH
   END FOREACH
   #讀取生產料號之生產單位
   SELECT ima55 INTO l_ima55
    FROM sfb_file,ima_file
    WHERE sfb05=ima01
     AND sfb01=p_sfb01
   IF l_ecm58 <> l_ima55 THEN
      CALL cl_err(l_ecm03,'mfg-054',0)
      RETURN 1
   END IF
   RETURN 0
END FUNCTION
#CHI-D40024---begin
#FUNCTION i301sub_create_tmp()
#   DROP TABLE i301sub_tmp
#   CREATE TEMP TABLE i301sub_tmp(
#   pmm01  LIKE pmm_file.pmm01)
#END FUNCTION
#CHI-D40024---end 
#若為委外，多張工單對一張採購單，則每張工單也要一併做確認
FUNCTION i301sub_firm1_other()
  DEFINE l_pmn01     LIKE pmn_file.pmn01
  DEFINE l_pmn41     LIKE pmn_file.pmn41
  DEFINE l_sfb       RECORD LIKE sfb_file.*
  DEFINE l_i         LIKE type_file.num5  #CHI-D40024
 
  #DECLARE i301sub_tmp_cs CURSOR FOR SELECT * FROM i301sub_tmp  #CHI-D40024
  #FOREACH i301sub_tmp_cs INTO l_pmn01  #CHI-D40024
  FOR l_i = 1 TO g_tmp_idx  #CHI-D40024
     DECLARE i301sub_pmn_cs CURSOR FOR
      #SELECT pmn41 FROM pmn_file WHERE pmn01=l_pmn01  #CHI-D40024
      SELECT pmn41 FROM pmn_file WHERE pmn01=g_pmm_tmp[l_i].pmm01  #CHI-D40024
     FOREACH i301sub_pmn_cs INTO l_pmn41
          IF l_pmn41 = l_sfb.sfb01 THEN CONTINUE FOREACH END IF
          SELECT * INTO l_sfb.* FROM sfb_file WHERE sfb01=l_pmn41
          IF STATUS THEN
             CALL cl_err3("sel","sfb_file",l_pmn41,"",STATUS,"","sel sfb(chk#1):",1)  #No.FUN-660128
             LET g_success='N'
             EXIT FOREACH
          END IF
          IF l_sfb.sfb87 = 'Y' THEN CONTINUE FOREACH END IF  #已確認
          UPDATE sfb_file SET sfb87 = 'Y' WHERE sfb01=l_sfb.sfb01
          IF STATUS THEN
             CALL cl_err3("upd","sfb_file",l_sfb.sfb01,"",STATUS,"","upd sfb(chk#2):",1)  #No.FUN-660128
             LET g_success='N'
             EXIT FOREACH
          END IF
          IF g_sma.sma27 MATCHES '[13]' AND l_sfb.sfb23 = 'Y'
             AND l_sfb.sfb04='1' THEN
          #  UPDATE sfb_file SET sfb04='2',sfb43='1' WHERE sfb01=l_sfb.sfb01  #FUN-8C0081 add sfb43   #MOD-B50243 mark
             UPDATE sfb_file SET sfb04='2',sfb43='1',sfb251=g_today WHERE sfb01=l_sfb.sfb01  #MOD-B50243 add
             IF STATUS THEN
                CALL cl_err3("upd","sfb_file",l_sfb.sfb01,"",STATUS,"","upd sfb(chk#3):",1)  #No.FUN-660128
                LET g_success='N'
                EXIT FOREACH
             END IF
          END IF
     END FOREACH
  #CHI-D40024---begin
     #IF g_success='N' THEN EXIT FOREACH END IF
  #END FOREACH  
     IF g_success='N' THEN EXIT FOR END IF
  END FOR  
  #CHI-D40024---end
END FUNCTION
 
FUNCTION i301sub_refresh(p_sfb01)
  DEFINE p_sfb01 LIKE sfb_file.sfb01
  DEFINE l_sfb RECORD LIKE sfb_file.*
 
  SELECT * INTO l_sfb.* FROM sfb_file WHERE sfb01=p_sfb01
  RETURN l_sfb.*
END FUNCTION
 
FUNCTION i301sub_sfb100(p_sfb)    #委外型態
    DEFINE p_sfb   RECORD LIKE sfb_file.*
    DEFINE l_smy57 LIKE smy_file.smy57
    DEFINE l_sfb01 LIKE sfb_file.sfb01   #FUN-640044 add
 
    LET g_errno=" "
    LET l_sfb01 = p_sfb.sfb01[1,g_doc_len]   #FUN-640044 add
    SELECT smy57 INTO l_smy57 FROM smy_file
         WHERE smyslip = l_sfb01       #FUN-640044
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg3045'
                                  LET l_smy57 = NULL
         OTHERWISE
    END CASE
    IF cl_null(g_errno) THEN
       LET p_sfb.sfb100 = l_smy57[6,6]
       IF p_sfb.sfb02 NOT MATCHES "[78]" THEN   #MOD-D50063 add
          LET p_sfb.sfb100='1'                  #MOD-D50063 add
       END IF                                   #MOD-D50063 add
       IF cl_null(p_sfb.sfb100) THEN LET p_sfb.sfb100='1' END IF
    END IF
    RETURN p_sfb.sfb100
END FUNCTION
 
#FUN-810038 由asfi301.4gl移過來
FUNCTION i301sub_ins_pmm(l_sfb)
   DEFINE l_pmm         RECORD LIKE pmm_file.*
   DEFINE l_pmn         RECORD LIKE pmn_file.*
   DEFINE l_sfa         RECORD LIKE sfa_file.*
   DEFINE l_umf         LIKE pmn_file.pmn09
   DEFINE l_sfa05       LIKE sfa_file.sfa05
   DEFINE l_ima55       LIKE ima_file.ima55
   DEFINE l_flag        LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
   DEFINE l_formid      LIKE oay_file.oayslip  #No.FUN-680121 VARCHAR(5) #MOD-590272
   DEFINE l_sfb         RECORD LIKE sfb_file.*    #FUN-810038
   DEFINE l_pmn01       LIKE pmn_file.pmn01       #FUN-810038
   DEFINE l_ima908      LIKE ima_file.ima908      #FUN-810038
   DEFINE l_mesg        LIKE type_file.chr1000    #FUN-810038
   DEFINE l_ima25       LIKE ima_file.ima25       #FUN-810038
   DEFINE l_ima44       LIKE ima_file.ima44       #FUN-810038
   DEFINE l_ima906      LIKE ima_file.ima906      #FUN-810038
   DEFINE l_ima907      LIKE ima_file.ima907      #FUN-810038
   DEFINE l_cnt1        LIKE type_file.num5       #FUN-810038
   DEFINE l_factor      LIKE ima_file.ima31_fac   #FUN-810038
   DEFINE l_ecdicd01    LIKE ecd_file.ecdicd01    #FUN-810038
   DEFINE l_imaicd01    LIKE imaicd_file.imaicd01 #FUN-810038
   DEFINE l_pmni        RECORD LIKE pmni_file.*   #FUN-810038
  #DEFINE l_sfbiicd04   LIKE sfbi_file.sfbiicd04  #FUN-810038   #TQC-C60025 mark
   DEFINE l_pmnislk01   LIKE pmni_file.pmnislk01  #NO.FUN-870117
   DEFINE l_task        LIKE sfb_file.sfb06       #No.FUN-8A0143
   DEFINE l_gec07       LIKE gec_file.gec07       #No.MOD-8B0273 add
   DEFINE l_sfbi        RECORD LIKE sfbi_file.*    #FUN-980033
 
   LET g_success = 'Y'
   SELECT MAX(pmn01) INTO l_pmn01 FROM pmn_file WHERE pmn41=l_sfb.sfb01
 
   #No.B356 避免有單頭無單身之採購單存在
   IF NOT cl_null(l_pmn01) THEN
      RETURN l_pmn01          #No.MOD-840419 modify
   ELSE
      SELECT pmm01 INTO l_pmn01 FROM pmm_file WHERE pmm01=l_sfb.sfb01
      IF NOT cl_null(l_pmn01) THEN
         LET g_success='N'
         RETURN l_pmn01          #No.MOD-840419 modify
   ELSE
      END IF
   END IF
 
   IF l_pmn01 IS NOT NULL THEN RETURN l_pmn01 END IF    #No.MOD-840419 add
   INITIALIZE l_pmm.* TO NULL
   LET l_pmm.pmm01 =l_sfb.sfb01
   LET l_pmm.pmm02 ='SUB'
   LET l_pmm.pmm04 =TODAY
   SELECT azn02,azn04 INTO l_pmm.pmm31,l_pmm.pmm32
     FROM azn_file WHERE azn01 = l_pmm.pmm04
 
   LET l_pmm.pmm09 =l_sfb.sfb82
   SELECT pmc15,pmc16,pmc17,pmc47,pmc22,pmc49
     INTO l_pmm.pmm10,l_pmm.pmm11,l_pmm.pmm20,l_pmm.pmm21,l_pmm.pmm22,
          l_pmm.pmm41
           FROM pmc_file
          WHERE pmc01=l_pmm.pmm09
   LET l_pmm.pmm12 =g_user
   SELECT gen03 INTO l_pmm.pmm13 FROM gen_file WHERE gen01= l_pmm.pmm12
   LET l_pmm.pmm18 ='N'
   LET l_pmm.pmm25 ='0'
 
   IF NOT cl_null(g_pmm22) AND s_industry('icd') THEN
      LET l_pmm.pmm22 = g_pmm22
      LET l_pmm.pmm42 = g_pmm42
   ELSE
      IF g_aza.aza17 = l_pmm.pmm22 THEN   #本幣
          LET l_pmm.pmm42 = 1
      ELSE
          IF NOT cl_null(l_pmm.pmm22) THEN           #MOD-B10124 add
             #CALL s_curr3(l_pmm.pmm22,l_pmm.pmm04,'S')  #MOD-D30070
             CALL s_curr3(l_pmm.pmm22,l_pmm.pmm04,g_sma.sma904)  #MOD-D30070
                 RETURNING l_pmm.pmm42
          END IF                                     #MOD-B10124 add
      END IF
   END IF
 
   SELECT gec04,gec07 INTO l_pmm.pmm43,l_gec07 FROM gec_file  #No.MOD-8B0273 add
          WHERE gec01= l_pmm.pmm21 AND gec011='1'
   IF SQLCA.SQLCODE THEN LET l_pmm.pmm43 = 0
   ELSE IF cl_null(l_pmm.pmm43) THEN LET l_pmm.pmm43 = 0 END IF END IF
   LET l_pmm.pmm30 = 'N' #MOD-530617
   LET l_pmm.pmm45 ='N'   #FUN-690047 modify #'Y'
   LET l_formid = s_get_doc_no(l_sfb.sfb01) #MOD-590272
  #    SELECT smyapr INTO l_pmm.pmmmksg FROM smy_file  #CHI-A50038 mark
  #    WHERE smyslip=l_formid                          #CHI-A50038 mark

   #CHI-A50038 add --start--
   IF s_industry('icd') THEN
      LET l_pmm.pmmmksg ='N'
   ELSE
      SELECT smyapr INTO l_pmm.pmmmksg FROM smy_file
      WHERE smyslip=l_formid
   END IF
   #CHI-A50038 add --end--

   LET l_pmm.pmmacti ='Y'
   LET l_pmm.pmmprsw ='Y'
   LET l_pmm.pmmuser =g_user
   LET l_pmm.pmmoriu = g_user #FUN-980030   #No.MOD-960317
   LET l_pmm.pmmorig = g_grup #FUN-980030   #No.MOD-960317
   LET g_data_plant = g_plant #FUN-980030
   LET l_pmm.pmmgrup =g_grup
   LET l_pmm.pmmdate =TODAY
#  LET l_pmm.pmm51 = ' '     #NO.FUN-960130   #NO.FUN-9B0016  #FUN-B70015  mark
   LET l_pmm.pmm51 = '1'     #FUN-B70015     
   LET l_pmm.pmmpos = 'N'    #NO.FUN-960130
   LET l_pmm.pmm05=l_sfb.sfb27 #TQC-BC0117 
   LET l_pmm.pmmplant = g_plant    #FUN-980008  add
   LET l_pmm.pmmlegal = g_legal    #FUN-980008  add
 
   #No.TQC-BB0271  --Begin
   LET l_pmm.pmm909 = '5'    #5.工单转入
   LET l_pmm.pmm905 = 'N'    #多角贸易抛转
   #No.TQC-BB0271  --End

   INSERT INTO pmm_file VALUES(l_pmm.*)
   IF STATUS THEN
     CALL cl_err3("ins","pmm_file",l_pmm.pmm01,"",STATUS,"","ins pmm:",1)  #No.FUN-660128
        LET g_success='N' RETURN l_pmn01 END IF     #No.MOD-840419 modify
 
   INITIALIZE l_pmn.* TO NULL
   LET l_pmn.pmn01 =l_sfb.sfb01
   LET l_pmn.pmn011='SUB'
   LET l_pmn.pmn02 =1
   LET l_pmn.pmn04 =l_sfb.sfb05
 
   SELECT ima02,ima44,ima25,ima55,ima15,ima908                                #MOD-730044 modify
     INTO l_pmn.pmn041,l_pmn.pmn07,l_pmn.pmn08,l_ima55,l_pmn.pmn64,l_ima908   #MOD-730044 modify
     FROM ima_file WHERE ima01=l_pmn.pmn04
   CALL s_umfchk(l_pmn.pmn04,l_pmn.pmn07,l_pmn.pmn08)
        RETURNING l_flag,l_pmn.pmn09      #取換算率(採購對庫存)
   IF l_flag=1 THEN
      #單位換算率抓不到
      LET l_mesg = NULL
      LET l_mesg =l_pmn.pmn04,"(pmn07/pmn08):"
      CALL cl_err(l_mesg,'abm-731',1)
      LET g_success ='N'
      RETURN l_pmn01          #No.MOD-840419 modify
   END IF
   LET l_pmn.pmn11 ='N'
   LET l_pmn.pmn13 =0
   CALL s_overate(l_pmn.pmn04) RETURNING l_pmn.pmn13  #MOD-7B0024
   LET l_pmn.pmn14 ='Y'
   LET l_pmn.pmn15 ='Y'
   LET l_pmn.pmn16 ='0'
 
  #NO.3524 add By Carol:取換算率(生管對採購)
   CALL s_umfchk(l_pmn.pmn04,l_ima55,l_pmn.pmn07)
        RETURNING l_flag,l_umf
   IF l_flag=1 THEN
      #單位換算率抓不到
      LET l_mesg=NULL
      LET l_mesg =l_pmn.pmn04,"(ima55/pmn07):"
      CALL cl_err(l_mesg,'abm-731',1)
      LET g_success ='N'
      RETURN l_pmn01          #No.MOD-840419 modify
   END IF
  #str TQC-C60025 mark
  #IF s_industry('icd') THEN
  #  #若l_sfb.sfb08沒有值,則取l_sfbi.sfbiicd04
  #  IF NOT cl_null(l_sfb.sfb08) THEN
  #     LET l_pmn.pmn20 =l_sfb.sfb08 * l_umf  #生管數量*換算率=應採購量
  #  ELSE
  #     SELECT sfbiicd04 INTO l_sfbiicd04
  #       FROM sfbi_file
  #      WHERE sfbi01=g_sfb.sfb01
  #     IF cl_null(l_sfbiicd04) OR l_sfbiicd04=0 THEN
  #        LET l_sfbiicd04=1
  #     END IF
  #     LET l_pmn.pmn20 =l_sfbiicd04 * l_umf  #生管數量*換算率=應採購量
  #  END IF
  #ELSE
  #end TQC-C60025 mark
      LET l_pmn.pmn20 =l_sfb.sfb08 * l_umf  #生管數量*換算率=應採購量
  #END IF   #TQC-C60025 mark
   LET l_pmn.pmn20 = s_digqty(l_pmn.pmn20,l_pmn.pmn07)   #FUN-BB0084
 
   LET l_pmn.pmn33 =l_sfb.sfb15
   LET l_pmn.pmn34 =l_sfb.sfb15
   LET l_pmn.pmn35 =l_sfb.sfb15
   LET l_pmn.pmn38 ='N'   #FUN-690047 modify  #'Y'
   LET l_pmn.pmn41 =l_sfb.sfb01
   LET l_pmn.pmn42 ='0'
   LET l_pmn.pmn43 =0
   LET l_pmn.pmn431=0
   LET l_pmn.pmn50 =0
   LET l_pmn.pmn51 =0
   LET l_pmn.pmn53 =0
   LET l_pmn.pmn55 =0
   LET l_pmn.pmn57 =0
   LET l_pmn.pmn61 =l_pmn.pmn04
   LET l_pmn.pmn62 =1
   LET l_pmn.pmn63 = 'N'   #00/05/19 modify
   LET l_pmn.pmn65 ='1'
   LET l_pmn.pmn75 =l_sfb.sfb01   #MOD-C50126 add
   LET l_pmn.pmn77 =g_plant       #MOD-C50126 add
   LET l_pmn.pmn122 = l_sfb.sfb27    #MOD-750080 add  #專案代號
   LET l_pmn.pmn96 = l_sfb.sfb271  #WBS代號
   LET l_pmn.pmn97 = l_sfb.sfb50   #活動
   LET l_pmn.pmn98 = l_sfb.sfb51   #理由碼
  #LET l_pmn.pmn90 =l_pmn.pmn31   #CHI-690043 add    #MOD-A80196 mark
   LET l_pmn.pmn100= l_sfb.sfb96   #FUN-D40042 備註
 
       IF g_sma.sma115 = 'Y' THEN
          SELECT ima25,ima44,ima906,ima907
            INTO l_ima25,l_ima44,l_ima906,l_ima907
            FROM ima_file WHERE ima01=l_pmn.pmn04
          IF SQLCA.sqlcode =100 THEN
             IF l_pmn.pmn04 MATCHES 'MISC*' THEN
                SELECT ima25,ima44,ima906,ima907
                  INTO l_ima25,l_ima44,l_ima906,l_ima907
                  FROM ima_file WHERE ima01='MISC'
             END IF
          END IF
          IF cl_null(l_ima44) THEN LET l_ima44 = l_ima25 END IF
          LET l_pmn.pmn80=l_pmn.pmn07
          LET l_factor = 1
          CALL s_umfchk(l_pmn.pmn04,l_pmn.pmn80,l_ima44)
               RETURNING l_cnt1,l_factor
          IF l_cnt1 = 1 THEN
             LET l_factor = 1
          END IF
          LET l_pmn.pmn81=l_factor
          LET l_pmn.pmn82=l_pmn.pmn20
          LET l_pmn.pmn83=l_ima907
          LET l_factor = 1
          CALL s_umfchk(l_pmn.pmn04,l_pmn.pmn83,l_ima44)
               RETURNING l_cnt1,l_factor
          IF l_cnt1 = 1 THEN
             LET l_factor = 1
          END IF
          LET l_pmn.pmn84=l_factor
          LET l_pmn.pmn85=0
          IF l_ima906 = '3' THEN
             LET l_factor = 1
             CALL s_umfchk(l_pmn.pmn04,l_pmn.pmn80,l_pmn.pmn83)
               RETURNING l_cnt1,l_factor
             IF l_cnt1 = 1 THEN
                LET l_factor = 1
             END IF
             LET l_pmn.pmn85=l_pmn.pmn82*l_factor
             LET l_pmn.pmn85=s_digqty(l_pmn.pmn85,l_pmn.pmn83)  #FUN-BB0084
          END IF
       END IF
       LET l_pmn.pmn86=l_pmn.pmn07
       LET l_pmn.pmn87=l_pmn.pmn20
      #LET l_pmn.pmn90=l_pmn.pmn31   #CHI-690043 add   #MOD-A80196 mark
 
       IF s_industry('icd') THEN
          SELECT sfbi_file.* ,ecdicd01 INTO l_sfbi.*,l_ecdicd01
            FROM sfbi_file LEFT OUTER JOIN ecd_file ON sfbiicd09=ecd01
           WHERE sfbi01=l_sfb.sfb01
       END IF
       IF s_industry('icd') AND l_ecdicd01 MATCHES '[23456]' THEN  
          CALL i301sub_icd_price(l_sfb.*,l_sfbi.*,l_ecdicd01,l_pmm.pmm04, 
                                 l_pmm.pmm22,l_pmm.pmm21,l_pmm.pmm43,l_pmn.pmn86,l_pmm.pmm41,l_pmm.pmm20)
          RETURNING l_pmn.pmn31,l_pmn.pmn31t
       ELSE
       LET l_task = l_sfb.sfb06
       IF cl_null(l_task) THEN LET l_task = ' ' END IF
       CALL s_defprice_new(l_pmn.pmn04,l_pmm.pmm09,l_pmm.pmm22,l_pmm.pmm04,
                       l_pmn.pmn87,l_task,l_pmm.pmm21,l_pmm.pmm43,"2",
                       l_pmn.pmn86,'',l_pmm.pmm41,l_pmm.pmm20,g_plant)
          #RETURNING l_pmn.pmn31,l_pmn.pmn31t                         #TQC-AC0257 mark
          RETURNING l_pmn.pmn31,l_pmn.pmn31t,l_pmn.pmn73,l_pmn.pmn74  #TQC-AC0257 add
       END IF #FUN-980033
       IF cl_null(l_pmn.pmn31) THEN
          LET l_pmn.pmn31=0
          LET l_pmn.pmn31t=0
       END IF
       #TQC-AB0410----add---------str---------------
       IF cl_null(l_pmn.pmn31t) THEN
          LET l_pmn.pmn31t=0
       END IF
       #TQC-AB0410----add---------end------------------  
       LET l_pmn.pmn90=l_pmn.pmn31                     #MOD-A80196 add 
 
       IF NOT (cl_null(l_pmn.pmn24) AND cl_null(l_pmn.pmn25)) THEN
          SELECT pml930 INTO l_pmn.pmn930 FROM pml_file
                                         WHERE pml01=l_pmn.pmn24
                                           AND pml02=l_pmn.pmn25
          IF SQLCA.sqlcode THEN
             LET l_pmn.pmn930=NULL
          END IF
       ELSE
          LET l_pmn.pmn930=s_costcenter(l_pmm.pmm13)
       END IF
 
        SELECT azi03,azi04 INTO t_azi03,t_azi04 FROM azi_file  #No.MOD-8B0273 add
         WHERE azi01 = l_pmm.pmm22  AND aziacti= 'Y'  #原幣
        LET l_pmn.pmn88 = cl_digcut(l_pmn.pmn31  * l_pmn.pmn87 ,t_azi04)
        LET l_pmn.pmn88t= cl_digcut(l_pmn.pmn31t * l_pmn.pmn87 ,t_azi04)
        LET l_pmn.pmn930 = l_sfb.sfb98    #No.FUN-870117
       IF cl_null(l_pmn.pmn02) THEN LET l_pmn.pmn02 = 0 END IF   #TQC-790002 add
       IF s_industry('icd') THEN
          CALL i301sub_ind_icd_ins_pmni(l_sfb.*,l_pmm.*,l_pmn.*)
             RETURNING l_pmn.*,l_pmni.*
       END IF
       IF s_industry('slk') THEN 
        SELECT sfcislk01 INTO l_pmni.pmnislk01  FROM  sfci_file
         WHERE sfci01 = l_sfb.sfb85 
       END IF                              
       #LET l_pmn.pmn73 = ' '   #NO.FUN-960130   #TQC-AC0257 mark
       IF cl_null(l_pmn.pmn73) THEN LET l_pmn.pmn73 = '4' END IF #TQC-AC0257 add
       
       LET l_pmn.pmnplant = g_plant    #FUN-980008  add
       LET l_pmn.pmnlegal = g_legal    #FUN-980008  add
       LET l_pmn.pmn89 = 'N'           #No.TQC-9B0079
       IF cl_null(l_pmn.pmn58) THEN LET l_pmn.pmn58 = 0 END IF  #TQC-9B0203 
       LET l_pmn.pmn44 = cl_digcut(l_pmn.pmn31*l_pmm.pmm42,g_azi03) #MOD-A30236 add
       IF cl_null(l_pmn.pmn012) THEN             #FUN-A60076 
          LET l_pmn.pmn012 = ' '                 #FUN-A60076 
       END IF                                    #FUN-A60076
      
       IF l_pmn.pmn56 IS NULL THEN LET l_pmn.pmn56 = ' ' END IF  #No.TQC-B80230
       CALL s_schdat_pmn78(l_pmn.pmn41,l_pmn.pmn012,l_pmn.pmn43,l_pmn.pmn18,   #FUN-C10002
                                       l_pmn.pmn32) RETURNING l_pmn.pmn78      #FUN-C10002
       INSERT INTO pmn_file VALUES(l_pmn.*)
       IF STATUS THEN
          CALL cl_err3("ins","pmn_file",l_pmn.pmn02,"",STATUS,"","ins pmn:",1)  #No.FUN-660128
          LET g_success='N'
          RETURN l_pmn01          #No.MOD-840419 modify
       ELSE
          IF SQLCA.SQLERRD[3]=0  THEN
             DELETE FROM pmm_file where pmm01=l_sfb.sfb01
             IF STATUS THEN
                CALL cl_err3("del","pmm_file",l_sfb.sfb01,"",STATUS,"","delete pmm:",1)  #No.FUN-660128
                LET g_success='N'
                RETURN l_pmn01          #No.MOD-840419 modify
             END IF
          ELSE
             IF NOT s_industry('std') THEN
                LET l_pmni.pmni01=l_pmn.pmn01
                LET l_pmni.pmni02=l_pmn.pmn02
                IF NOT s_ins_pmni(l_pmni.*,'') THEN
                   LET g_success='N'
                   RETURN l_pmn01          #No.MOD-840419 modify
                END IF
             END IF
          END IF
      END IF
   DECLARE i301_ins_pmn_c CURSOR FOR
         SELECT * FROM sfa_file
          WHERE sfa01=l_sfb.sfb01
             AND sfa065>0 AND sfa05 > 0 #MOD-470493(9785) sfa05>0產生採購單才有意義
   FOREACH i301_ins_pmn_c INTO l_sfa.*

      LET l_pmn.pmn02 =l_pmn.pmn02 + 1
      LET l_pmn.pmn04 =l_sfa.sfa03
      LET l_pmn.pmn42 =l_sfa.sfa26      #MOD-C50036 add
      SELECT ima02,ima44,ima25,ima55
        INTO l_pmn.pmn041,l_pmn.pmn07,l_pmn.pmn08,l_ima55
        FROM ima_file WHERE ima01=l_pmn.pmn04
      CALL s_umfchk(l_pmn.pmn04,l_pmn.pmn07,l_pmn.pmn08)
           RETURNING l_flag,l_pmn.pmn09      #取換算率(採購對庫存)
      IF l_flag=1 THEN
         #單位換算率抓不到
         LET l_mesg=NULL
         LET l_mesg =l_pmn.pmn04,"(pmn07/pmn08):"
         CALL cl_err(l_mesg,'abm-731',1)
 
         LET g_success ='N'
         RETURN l_pmn01          #No.MOD-840419 modify
      END IF
      CALL s_umfchk(l_pmn.pmn04,l_ima55,l_pmn.pmn07)
           RETURNING l_flag,l_umf            #取換算率(生管對採購)
      IF l_flag=1 THEN
         #單位換算率抓不到
         LET l_mesg=NULL
         LET l_mesg =l_pmn.pmn04,"(ima55/pmn07):"
         CALL cl_err(l_mesg,'abm-731',1)
 
         LET g_success ='N'
         RETURN l_pmn01          #No.MOD-840419 modify
      END IF
      LET l_pmn.pmn20 =l_sfa.sfa065 * l_umf
      LET l_pmn.pmn20 = s_digqty(l_pmn.pmn20,l_pmn.pmn07)  #FUN-BB0084
      LET l_pmn.pmn61 =l_pmn.pmn04
      LET l_pmn.pmn62 =1
      LET l_pmn.pmn65 ='2'
       IF g_sma.sma115 = 'Y' THEN
          SELECT ima44,ima906,ima907 INTO l_ima44,l_ima906,l_ima907
            FROM ima_file WHERE ima01=l_pmn.pmn04
          LET l_pmn.pmn80=l_pmn.pmn07
          LET l_factor = 1
          CALL s_umfchk(l_pmn.pmn04,l_pmn.pmn80,l_ima44)
               RETURNING l_cnt1,l_factor
          IF l_cnt1 = 1 THEN
             LET l_factor = 1
          END IF
          LET l_pmn.pmn81=l_factor
          LET l_pmn.pmn82=l_pmn.pmn20
          LET l_pmn.pmn83=l_ima907
          LET l_factor = 1
          CALL s_umfchk(l_pmn.pmn04,l_pmn.pmn83,l_ima44)
               RETURNING l_cnt1,l_factor
          IF l_cnt1 = 1 THEN
             LET l_factor = 1
          END IF
          LET l_pmn.pmn84=l_factor
          LET l_pmn.pmn85=0
          IF l_ima906 = '3' THEN
             LET l_factor = 1
             CALL s_umfchk(l_pmn.pmn04,l_pmn.pmn80,l_pmn.pmn83)
               RETURNING l_cnt1,l_factor
             IF l_cnt1 = 1 THEN
                LET l_factor = 1
             END IF
             LET l_pmn.pmn85=l_pmn.pmn82*l_factor
             LET l_pmn.pmn85=s_digqty(l_pmn.pmn85,l_pmn.pmn83)  #FUN-BB0084
          END IF
       END IF
       LET l_pmn.pmn86=l_pmn.pmn07
       LET l_pmn.pmn87=l_pmn.pmn20
      #LET l_pmn.pmn90=l_pmn.pmn31   #CHI-690043 add   #MOD-A80196 mark
       IF NOT (cl_null(l_pmn.pmn24) AND cl_null(l_pmn.pmn25)) THEN
          SELECT pml930 INTO l_pmn.pmn930 FROM pml_file
                                         WHERE pml01=l_pmn.pmn24
                                           AND pml02=l_pmn.pmn25
       ELSE
          LET l_pmn.pmn930=s_costcenter(l_pmm.pmm13)
       END IF
 
       IF g_sma.sma116 MATCHES '[13]' THEN    #No.FUN-610076
          LET l_pmn.pmn86=l_ima908
       END IF
       IF cl_null(l_pmn.pmn87) THEN LET l_pmn.pmn87 = 0 END IF
       LET l_factor = 1
       CALL s_umfchk(l_pmn.pmn04,l_pmn.pmn07,l_pmn.pmn86)
             RETURNING l_cnt1,l_factor
       IF l_cnt1 = 1 THEN
          LET l_factor = 1
       END IF
       LET l_pmn.pmn87 = l_pmn.pmn87  * l_factor
       LET l_pmn.pmn87 = s_digqty(l_pmn.pmn87,l_pmn.pmn86)   #FUN-BB0084
       LET l_task = l_sfa.sfa08
       IF cl_null(l_task) THEN 
          LET l_task = l_sfb.sfb06
       END IF
       IF cl_null(l_task) THEN LET l_task = ' ' END IF
       CALL s_defprice_new(l_pmn.pmn04,l_pmm.pmm09,l_pmm.pmm22,l_pmm.pmm04,
                        l_pmn.pmn87,l_task,l_pmm.pmm21,l_pmm.pmm43,"2",l_pmn.pmn86,'',l_pmm.pmm41,l_pmm.pmm20,g_plant)
          #RETURNING l_pmn.pmn31,l_pmn.pmn31t                          #TQC-AC0257 mark
          RETURNING l_pmn.pmn31,l_pmn.pmn31t,l_pmn.pmn73,l_pmn.pmn74   #TQC-AC0257 add
       IF cl_null(l_pmn.pmn31) THEN
          LET l_pmn.pmn31=0
          LET l_pmn.pmn31t=0
       END IF
       LET l_pmn.pmn90=l_pmn.pmn31                     #MOD-A80196 add 
 
       SELECT azi03,azi04 INTO t_azi03,t_azi04 FROM azi_file  #No.MOD-8B0273 add
        WHERE azi01 = l_pmm.pmm22  AND aziacti= 'Y'  #原幣
       LET l_pmn.pmn88 = cl_digcut(l_pmn.pmn31  * l_pmn.pmn87 ,t_azi04)
       LET l_pmn.pmn88t= cl_digcut(l_pmn.pmn31t * l_pmn.pmn87 ,t_azi04)
      IF cl_null(l_pmn.pmn02) THEN LET l_pmn.pmn02 = 0 END IF   #TQC-790002 add
      LET l_pmn.pmn930 = l_sfb.sfb98    #No.FUN-870117
       IF s_industry('slk') THEN 
        SELECT sfcislk01 INTO l_pmni.pmnislk01  FROM  sfci_file
         WHERE sfci01 = l_sfb.sfb85
       END IF                              
      #LET l_pmn.pmn73 = ' '   #NO.FUN-960130                   #TQC-AC0257 mark
      IF cl_null(l_pmn.pmn73) THEN LET l_pmn.pmn73 = '4' END IF #TQC-AC0257 add
      LET l_pmn.pmnplant = g_plant    #FUN-980008  add
      LET l_pmn.pmnlegal = g_legal    #FUN-980008  add
      LET l_pmn.pmn89 = 'N'           #No.TQC-9B0079
      IF cl_null(l_pmn.pmn58) THEN LET l_pmn.pmn58 = 0 END IF  #TQC-9B0203 
      LET l_pmn.pmn44 = cl_digcut(l_pmn.pmn31*l_pmm.pmm42,g_azi03) #MOD-A30236 add
      IF cl_null(l_pmn.pmn012) THEN        #FUN-A60076
         LET l_pmn.pmn012 = ' '            #FUN-A60076 
      END IF                               #FUN-A60076 
 
      IF l_pmn.pmn56 IS NULL THEN LET l_pmn.pmn56 = ' ' END IF  #No.TQC-B80230
      CALL s_schdat_pmn78(l_pmn.pmn41,l_pmn.pmn012,l_pmn.pmn43,l_pmn.pmn18,   #FUN-C10002
                                      l_pmn.pmn32) RETURNING l_pmn.pmn78      #FUN-C10002
      INSERT INTO pmn_file VALUES(l_pmn.*)
      IF STATUS THEN
        CALL cl_err('ins pmn:',STATUS,1)   #No.FUN-660128
        CALL cl_err3("ins","pmn_file",l_pmn.pmn01,l_pmn.pmn02,STATUS,"","ins pmn:",1)  #No.FUN-660128
      ELSE
         IF NOT s_industry('std') THEN
            LET l_pmni.pmni01=l_pmn.pmn01
            LET l_pmni.pmni02=l_pmn.pmn02
            LET l_cnt1=s_ins_pmni(l_pmni.*,'')
         END IF
      END IF      
   END FOREACH
   LET l_pmn01=l_sfb.sfb01
 
   #SELECT SUM(pmn31*pmn20),SUM(pmn31t*pmn20)   #MOD-B20049
   SELECT SUM(pmn88),SUM(pmn88t)   #MOD-B20049
     INTO l_pmm.pmm40,l_pmm.pmm40t
     FROM pmn_file
    WHERE pmn01 = l_sfb.sfb01
   LET l_pmm.pmm40 = cl_digcut(l_pmm.pmm40,t_azi04)   #MOD-B20049 g_azi04-->t_azi04
   LET l_pmm.pmm40t = cl_digcut(l_pmm.pmm40t,t_azi04)   #MOD-B20049 g_azi04-->t_azi04
   UPDATE pmm_file
      SET pmm40 = l_pmm.pmm40,
          pmm40t= l_pmm.pmm40t
    WHERE pmm01 = l_sfb.sfb01
    RETURN l_pmn01            #No.MOD-840419 add
END FUNCTION
 
#檢查ICD的資料正確否,不正確則 let g_success= N
FUNCTION i301sub_ind_icd_chk(p_cmd,l_sfb,l_sfbi)
   DEFINE l_ecd07     LIKE ecd_file.ecd07,
          l_ecdacti   LIKE ecd_file.ecdacti,
          l_ecdicd01  LIKE ecd_file.ecdicd01
   DEFINE p_cmd       LIKE type_file.chr1
   DEFINE l_sfb       RECORD LIKE sfb_file.*
   DEFINE l_sfbi      RECORD LIKE sfbi_file.*
   DEFINE l_cnt       LIKE type_file.num5
   DEFINE l_icr01     LIKE icr_file.icr01
   DEFINE l_icr02     LIKE icr_file.icr02
 
   IF NOT cl_null(l_sfbi.sfbiicd09) THEN
      SELECT ecd07,ecdicd01,ecdacti 
        INTO l_ecd07,l_ecdicd01,l_ecdacti
        FROM ecd_file
       WHERE ecd01 = l_sfbi.sfbiicd09
      CASE WHEN SQLCA.SQLCODE = 100
                CALL cl_err(l_sfbi.sfbiicd09,'aec-015',1)
                LET g_success = 'N' RETURN l_sfbi.*
           WHEN l_ecdacti <> 'Y'
                CALL cl_err(l_sfbi.sfbiicd09,'9028',1)
                LET g_success = 'N' RETURN l_sfbi.*
           WHEN l_ecdicd01 = '1'
                CALL cl_err(l_sfbi.sfbiicd09,'aic-127',1)
                LET g_success = 'N' RETURN l_sfbi.*
      END CASE
   END IF
 
   #除了作業群組=3.DS 或 4.ASS ,其餘作業群組不允工單確認後生產數量(sfb08)為空白
   IF cl_null(l_sfb.sfb08) THEN
      IF cl_null(l_sfbi.sfbiicd09) THEN
         CALL cl_err(l_sfb.sfb01,'aic-143',1)
         LET g_success = 'N'
         RETURN l_sfbi.*
      ELSE
         IF l_ecdicd01 NOT MATCHES '[34]' THEN
            CALL cl_err(l_sfb.sfb01,'aic-143',1)
            LET g_success = 'N'
            RETURN l_sfbi.*
         END IF
      END IF
   END IF
 
   IF l_ecdicd01 MATCHES '[46]' THEN
      #Date Code(sfbiicd07):若作業群組=4.ASS或6.TKY,且在料件備註檔
      #DateCode否(imaicd09)='Y',Wafer廠商(sfbiicd02)或Wafer廠別(sfbiicd03)或
      #廠商主檔中不存在,則無法產生DateCode,
      #出現錯誤訊息,並不允許確認
 
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM ima_file,imaicd_file
       WHERE ima01 = l_sfb.sfb05
         AND ima01=imaicd00
         AND imaicd09 = 'Y'
      IF l_cnt > 0 THEN
         IF cl_null(l_sfb.sfb82) THEN
            CALL cl_err(l_sfb.sfb01,'aic-145',1)
            LET g_success = 'N' RETURN l_sfbi.*
         END IF
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM pmc_file
          WHERE pmc01 = l_sfb.sfb82
         IF l_cnt = 0 THEN
            CALL cl_err(l_sfb.sfb01,'aic-145',1)
            LET g_success = 'N' RETURN l_sfbi.*
         END IF
      END IF
   END IF
   #部門廠商(sfb82):若工單性質=7.委外或8.委外重工,若該欄位為空白
   #則出現錯誤訊息,並不允許確認
   IF l_sfb.sfb02 MATCHES '[78]' THEN
      IF cl_null(l_sfb.sfb82) THEN
         CALL cl_err(l_sfb.sfb01,'aic-147',1)
         LET g_success = 'N' RETURN l_sfbi.*
      END IF
   END IF
 
  #IF p_cmd = 'a' THEN RETURN l_sfbi.* END IF   #No:MOD-A30091 mark
 
   #以上為正確性檢查處理邏輯
   #----------------------------------------------------------------------#
   #以下為產生/更新資料處理邏輯
 
   #Date Code(sfbiicd07): 若該料號若該料號之作業群組 = '4.ASS' or '6.TKY'
   #且在料件主檔DateCode否(imaicd09) ='Y',
   #傳參數至 cl_datecode(單據號碼，廠商sfb82，iBody，Wafer Site, Wafer廠商),
   #                                      (iBody:先用單頭sfbiicd14)
   #若產生失敗, 則不允許作生產確認
   
   #TQC-C20114 --START mark--
   #IF l_ecdicd01 MATCHES '[46]' THEN
   #   LET l_cnt = 0
   #   SELECT COUNT(*) INTO l_cnt FROM ima_file,imaicd_file
   #    WHERE ima01 = l_sfb.sfb05
   #      AND ima01 = imaicd00
   #      AND imaicd09 = 'Y'
   #   IF l_cnt > 0 THEN
   #      LET l_icr02='5'
   #      CALL s_aic_auto_no_set(l_icr02) RETURNING l_icr01
   #      IF cl_null(l_icr01) THEN
   #         LET g_success = 'N' RETURN l_sfbi.*
   #      END IF
   #      CALL s_aic_auto_no(l_icr01,l_icr02,l_sfb.sfb01,'')   #FUN-BC0107
   #           RETURNING l_sfbi.sfbiicd07
   #      IF l_sfbi.sfbiicd07 = 'Error' OR cl_null(l_sfbi.sfbiicd07) THEN
   #         #產生失敗(為Error或NULL)
   #         LET g_success = 'N' RETURN l_sfbi.*
   #      ELSE
   #         #產生成功,更新委外採購單的(pmniicd11)
   #         UPDATE pmni_file SET pmniicd11 = l_sfbi.sfbiicd07
   #          WHERE pmni01||pmni02 = (SELECT pmn01||pmn02 FROM pmn_file WHERE
   #          pmn41 = l_sfb.sfb01)
   #         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
   #            CALL cl_err('upd pmniicd11:',SQLCA.sqlcode,1)
   #            LET g_success = 'N' RETURN l_sfbi.*
   #         END IF
   #         #產生成功,更新工單的datecode(sfbiicd07)
   #         UPDATE sfbi_file SET sfbiicd07 = l_sfbi.sfbiicd07
   #          WHERE sfbi01 = l_sfb.sfb01
   #         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
   #            CALL cl_err('upd datecode(sfbiicd07):',SQLCA.sqlcode,1)
   #            LET g_success = 'N' RETURN l_sfbi.*
   #         END IF
   #      END IF
   #   END IF
   #END IF
   #TQC-C20114 --END mark--
   
   #產生生產備註資訊(ico_file)
   CALL i301sub_ind_icd_gen_ico(l_sfb.*,l_sfbi.*)
   IF g_success = 'N' THEN RETURN l_sfbi.* END IF
 
   #判斷是否有製程資訊(ecm_file)
   IF l_sfb.sfb02 MATCHES '[78]' AND l_ecdicd01 = '6' AND
      NOT cl_null(l_sfb.sfb06) THEN
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM ecm_file WHERE ecm01 = l_sfb.sfb01
      IF l_cnt = 0 THEN
         CALL cl_err(l_sfb.sfb01,'sdf-349',1)
         LET g_success = 'N' RETURN l_sfbi.*
      END IF
   END IF
 
   #回貨批號
   CALL i301sub_ind_icd_upd_sfbiicd13(l_sfb.*,l_sfbi.*) RETURNING l_sfbi.*
   RETURN l_sfbi.*   
END FUNCTION
 
#only for aicp046 call 工單確認
FUNCTION i301sub_ind_icd_set_pmm(p_pmm22,p_pmm42)
   DEFINE p_pmm22 LIKE pmm_file.pmm22
   DEFINE p_pmm42 LIKE pmm_file.pmm42
 
   LET g_pmm22=p_pmm22
   LET g_pmm42=p_pmm42
END FUNCTION
 
#若採購單上的必要欄位有值且取成功,則狀態='Y'(確認);反之='N'
FUNCTION i301sub_ind_icd_upd_pmm18(l_sfb)
   DEFINE l_pmm       RECORD LIKE pmm_file.*,
          l_pmn       RECORD LIKE pmn_file.*,
          l_pmhacti   LIKE pmh_file.pmhacti,
          l_pmh05     LIKE pmh_file.pmh05,
          l_ima906    LIKE ima_file.ima906,
          l_imaicd01  LIKE imaicd_file.imaicd01,
          l_ecdicd01  LIKE ecd_file.ecdicd01,
          l_i         LIKE type_file.num10,
          l_sfb       RECORD LIKE sfb_file.*,
          l_pmni      RECORD LIKE pmni_file.*
 
   IF l_sfb.sfb02 NOT MATCHES '[78]' THEN RETURN END IF
 
   SELECT DISTINCT pmm_file.* INTO l_pmm.* FROM pmm_file,pmn_file   #MOD-990117
    WHERE pmm01 = pmn01 AND pmn41 = l_sfb.sfb01
      AND pmm02 = 'SUB' AND pmm18 = 'N' AND pmmacti = 'Y'  #有效委外未確認
   IF SQLCA.sqlcode THEN RETURN END IF
 
   #判斷必KEY欄位
   IF cl_null(l_pmm.pmm02) OR cl_null(l_pmm.pmm04) OR
      cl_null(l_pmm.pmm09) OR cl_null(l_pmm.pmm18) OR
      cl_null(l_pmm.pmm20) OR cl_null(l_pmm.pmm21) OR
      cl_null(l_pmm.pmm22) OR cl_null(l_pmm.pmm25) OR
      cl_null(l_pmm.pmm30) OR cl_null(l_pmm.pmm45) OR
      cl_null(l_pmm.pmmmksg) OR cl_null(l_pmm.pmm02) THEN
      CALL cl_err('pmm_file','mfg6138','1')
      LET g_success = 'N' RETURN
   END IF
 
   DECLARE pmn_cs CURSOR FOR
    SELECT pmn_file.* FROM pmm_file,pmn_file
     WHERE pmm01 = pmn01 AND pmn41 = l_sfb.sfb01
       AND pmm02 = 'SUB' AND pmm18 = 'N' AND pmmacti = 'Y'  #有效委外未確認
   LET l_i = 0
   #判斷必KEY欄位
   FOREACH pmn_cs INTO l_pmn.*
      #重取單位使用方式/母體料號
      LET l_ima906 = NULL
      LET l_imaicd01 = NULL
      SELECT ima906,imaicd01 INTO l_ima906,l_imaicd01 FROM ima_file,imaicd_file
       WHERE ima01 = l_pmn.pmn04
         AND ima01=imaicd00
 
      SELECT * INTO l_pmni.* FROM pmni_file 
       WHERE pmni01=l_pmn.pmn01 
         AND pmni02=l_pmn.pmn02
 
      #重取作業群組
      LET l_ecdicd01 = NULL
      IF NOT cl_null(l_pmni.pmniicd03) THEN
         SELECT ecdicd01 INTO l_ecdicd01 FROM ecd_file
          WHERE ecd01 = l_pmni.pmniicd03
      END IF
      IF cl_null(l_pmn.pmn02) OR cl_null(l_pmn.pmn20) OR
         cl_null(l_pmn.pmn31) OR cl_null(l_pmn.pmn33) OR
         cl_null(l_pmn.pmn41) OR cl_null(l_pmn.pmn42) OR
         cl_null(l_pmn.pmn63) OR cl_null(l_pmn.pmn64) THEN
         CALL cl_err('pmn_file','mfg6138','1')
         LET g_success = 'N' RETURN
      END IF
      #雙單位的必KEY欄位資料判斷
      IF g_sma.sma115 = 'Y' THEN
         IF l_ima906 = '3' THEN
            IF cl_null(l_pmn.pmn83) OR cl_null(l_pmn.pmn85) OR
               cl_null(l_pmn.pmn80) OR cl_null(l_pmn.pmn82) THEN
               CALL cl_err('pmn_file','mfg6138','1')
               LET g_success = 'N' RETURN
            END IF
         END IF
      END IF
 
      #單位不同,轉換率,數量必KEY
      IF NOT cl_null(l_pmn.pmn80) THEN
         IF cl_null(l_pmn.pmn82) THEN
            CALL cl_err('pmn82','mfg6138','1')
            LET g_success = 'N' RETURN
         END IF
      END IF
      IF NOT cl_null(l_pmn.pmn86) THEN
         IF cl_null(l_pmn.pmn87) THEN
            CALL cl_err('pmn87','mfg6138','1')
            LET g_success = 'N' RETURN
         END IF
      END IF
 
      LET l_i = l_i + 1
   END FOREACH
 
   IF l_i = 0 THEN #無單身不可確認
      CALL cl_err('SUB PO','mfg-009',1)
      LET g_success = 'N' RETURN
   END IF
   #因應CHI-C30107修改了是否確認的詢問視窗位置,這邊要先將g_action_choice清空,免得彈出兩個axm-108的詢問窗
   LET g_action_choice=""          #TQC-C60025 add
   CALL t540sub_y_chk(l_pmm.*)          #CALL 原確認的 check 段
   LET g_action_choice="confirm"   #TQC-C60025 add
   IF g_success = "Y" THEN
      CALL t540sub_y_upd(l_pmm.pmm01,'')
   END IF
   IF g_success = 'N' THEN RETURN END IF
END FUNCTION
 
FUNCTION i301sub_ind_icd_ins_pmni(l_sfb,l_pmm,l_pmn)
   DEFINE l_sfb   RECORD LIKE sfb_file.*
   DEFINE l_sfbi  RECORD LIKE sfbi_file.*
   DEFINE l_pmn   RECORD LIKE pmn_file.*
   DEFINE l_pmni  RECORD LIKE pmni_file.*
   DEFINE l_ecdicd01 LIKE ecd_file.ecdicd01
   DEFINE l_imaicd01 LIKE imaicd_file.imaicd01
   DEFINE l_ima908   LIKE ima_file.ima908
   DEFINE l_pmm      RECORD LIKE pmm_file.*
 
   IF NOT cl_null(l_sfb.sfb22) AND NOT cl_null(l_sfb.sfb221) THEN
      LET l_pmni.pmniicd01 = l_sfb.sfb22    #--訂單單號
      LET l_pmni.pmniicd02 = l_sfb.sfb221   #--訂單項次
   END IF
 
   SELECT * INTO l_sfbi.*
     FROM sfbi_file
    WHERE sfbi01=l_sfb.sfb01
 
   LET l_pmni.pmniicd03 = l_sfbi.sfbiicd09   #--ICD作業編號
 
   DECLARE pmniicd04_cs CURSOR FOR
    SELECT pmniicd04 FROM pmm_file,pmn_file,pmni_file
     WHERE pmm01 = pmn01 
       AND pmm02 = 'WB2'
       AND pmni01= pmn01
       AND pmni02= pmn02
       AND pmniicd01 = l_sfb.sfb22
       AND pmniicd02 = l_sfb.sfb221
       AND pmm04 IN   #取採購日期最小的資料
           (SELECT MIN(pmm04) FROM pmm_file,pmn_file,pmni_file
             WHERE pmm01 = pmn01 AND pmm02 = 'WB2'
               AND pmni01= pmn01
               AND pmni02= pmn02
               AND pmniicd01 = l_sfb.sfb22
               AND pmniicd02 = l_sfb.sfb221)
   OPEN pmniicd04_cs
   FETCH pmniicd04_cs INTO l_pmni.pmniicd04 #--New Code
   CLOSE pmniicd04_cs
 
   SELECT oebiicd09,oebiicd05,oeb04
     INTO l_pmni.pmniicd05,                 #--Low yield
          l_pmni.pmniicd08,                 #--Multi die
          l_pmni.pmniicd15                  #--最終料號
     FROM oeb_file,oebi_file
    WHERE oeb01 = l_sfb.sfb22
      AND oeb03 = l_sfb.sfb221
      AND oebi01=oeb01
      AND oebi03=oeb03
 
   IF cl_null(l_pmni.pmniicd15)THEN
      LET l_pmni.pmniicd15 = l_sfbi.sfbiicd08
   END IF
 
   LET l_pmni.pmniicd06 = ' '                 #--metal layer
   LET l_pmni.pmniicd07 = 0                   #--FST片數
   SELECT ecdicd01 INTO l_ecdicd01 FROM ecd_file
    WHERE ecd01 = l_sfbi.sfbiicd09
   IF l_ecdicd01 = '2' THEN
      LET l_pmn.pmn85 = l_sfbi.sfbiicd06
      LET l_pmn.pmn85 = s_digqty(l_pmn.pmn85,l_pmn.pmn83)  #FUN-BB0084
      LET l_pmni.pmniicd09 = l_sfbi.sfbiicd06
 
      #取得GROSSDIE
      IF cl_null(l_pmn.pmn85) THEN
      #FUN-B50106 ----------Begin-------------------
      #  SELECT icb05 INTO l_pmn.pmn85   
      #    FROM icb_file,imaicd_file
      #   WHERE icb01 = imaicd01
      #     AND imaicd00 = l_sfb.sfb05
          CALL s_icdfun_imaicd14(l_sfb.sfb05)   RETURNING l_pmn.pmn85
          IF cl_null(l_pmn.pmn85) THEN LET l_pmn.pmn85 = 0 END IF
      #FUN-B50106 ----------End---------------------
          LET l_pmn.pmn85 = l_pmn.pmn85 * l_pmn.pmn20
          LET l_pmn.pmn85 = s_digqty(l_pmn.pmn85,l_pmn.pmn83)  #FUN-BB0084
      END IF
   ELSE
      LET l_pmni.pmniicd09 = l_pmn.pmn85
   END IF
   LET l_pmni.pmniicd10 = ' '                #--已轉完採購單否
   LET l_pmni.pmniicd11 = l_sfbi.sfbiicd07   #--Datecode
   LET l_pmni.pmniicd12 = l_sfbi.sfbiicd03   #--WAFER SITE
   LET l_pmni.pmniicd13 = 0                  #--已轉WAFER START採購單數量
   LET l_pmni.pmniicd14 = l_sfbi.sfbiicd14   #--內編母體
   DECLARE sfaiicd03_cs CURSOR FOR           #--母批
    SELECT sfaiicd03 FROM sfa_file,sfai_file 
     WHERE sfa01  = l_sfb.sfb01
       AND sfai01 = sfa01
       AND sfai03 = sfa03
       AND sfai08 = sfa08
       AND sfai12 = sfa12
       AND sfai27 = sfa27 #CHI-7B0034
       AND sfai012 = sfa012 #FUN-A50066
       AND sfai013 = sfa013 #FUN-A50066
     ORDER BY sfa08,sfa27,sfa26
   OPEN sfaiicd03_cs
   FETCH sfaiicd03_cs INTO l_pmni.pmniicd16
   LET l_pmni.pmniicd17 = l_sfbi.sfbiicd02   #--Wafer廠商
   LET l_pmni.pmniicd18 = l_sfbi.sfbiicd01   #--下階廠商
 
   #--未稅單價(pmn31)
   #--含稅單價(pmn31t)
   IF NOT cl_null(l_sfbi.sfbiicd09) THEN
      SELECT ecdicd01 INTO l_ecdicd01 FROM ecd_file
       WHERE ecd01 = l_sfbi.sfbiicd09
 
       SELECT imaicd01 INTO l_imaicd01
         FROM imaicd_file
        WHERE imaicd00 = l_pmn.pmn04
 
       SELECT ima908 INTO l_ima908 FROM ima_file
        WHERE ima01=l_imaicd01
 
       LET l_pmn.pmn31 = 0
       LET l_pmn.pmn31t = 0
 
       IF s_industry('icd') THEN
          SELECT sfbi_file.* ,ecdicd01 INTO l_sfbi.*,l_ecdicd01
            FROM sfbi_file LEFT OUTER JOIN ecd_file ON sfbiicd09=ecd01
           WHERE sfbi01=l_sfb.sfb01
       END IF
       IF s_industry('icd') AND l_ecdicd01 MATCHES '[23456]' THEN  
          CALL i301sub_icd_price(l_sfb.*,l_sfbi.*,l_ecdicd01,l_pmm.pmm04, 
                                 l_pmm.pmm22,l_pmm.pmm21,l_pmm.pmm43,l_pmn.pmn86,l_pmm.pmm41,l_pmm.pmm20)
          RETURNING l_pmn.pmn31,l_pmn.pmn31t
       ELSE
       CALL s_defprice_new(l_imaicd01,l_pmm.pmm09,l_pmm.pmm22,l_pmm.pmm04,
                       l_pmn.pmn20,l_pmni.pmniicd03,l_pmm.pmm21,
                      l_pmm.pmm43,'2',l_ima908,'',l_pmm.pmm41,l_pmm.pmm20,g_plant)
          #RETURNING l_pmn.pmn31,l_pmn.pmn31t                         #TQC-AC0257 mark
          RETURNING l_pmn.pmn31,l_pmn.pmn31t,l_pmn.pmn73,l_pmn.pmn74  #TQC-AC0257 add 
       END IF   #FUN-980033
       LET l_pmn.pmn90=l_pmn.pmn31                     #MOD-A80196 add 
   END IF
   RETURN l_pmn.*,l_pmni.*
END FUNCTION
 
#更新回貨批號(sfbiicd13)
FUNCTION i301sub_ind_icd_upd_sfbiicd13(l_sfb,l_sfbi)
  DEFINE l_sfa       RECORD LIKE sfa_file.*,
         l_int       LIKE type_file.num10,
         l_idl02     LIKE idl_file.idl02,
         l_sfb09     LIKE sfb_file.sfb09,
         l_ima55     LIKE ima_file.ima55,
         l_img09     LIKE img_file.img09,
         l_img10     LIKE img_file.img10,
         l_rvv32     LIKE rvv_file.rvv32,      #倉(rvv32)
         l_rvv33     LIKE rvv_file.rvv33,      #儲(rvv33)
         l_rvv34     LIKE rvv_file.rvv34,      #批(rvv34)
         l_rvv35     LIKE rvv_file.rvv35,      #單位(rvv35)
         l_rvv17     LIKE rvv_file.rvv17,      #數量(rvv17)
         l_sfb       RECORD LIKE sfb_file.*,
         l_sfbi      RECORD LIKE sfbi_file.*,
         l_cnt       LIKE type_file.num5,
         l_factor    LIKE ima_file.ima31_fac,
         l_sfai      RECORD LIKE sfai_file.*,
         l_msg       LIKE type_file.chr1000
 
  #料件狀態(imaicd04)=0-4時才做回貨批號
  LET l_cnt = 0
  SELECT COUNT(*) INTO l_cnt FROM imaicd_file
   WHERE imaicd00 = l_sfb.sfb05 
     AND imaicd04 IN ('0','1','2','3','4')
  IF l_cnt = 0 THEN RETURN l_sfbi.* END IF
 
  #若已有資料,就不再取回貨批號
  IF NOT cl_null(l_sfbi.sfbiicd13) THEN RETURN l_sfbi.* END IF
 
  DECLARE sfbiicd13_cs CURSOR FOR  #取第一筆備料的批號資料
   SELECT * FROM sfa_file WHERE sfa01 = l_sfb.sfb01
    ORDER BY sfa08,sfa27,sfa26
 
  OPEN sfbiicd13_cs
  FETCH sfbiicd13_cs INTO l_sfa.*
  IF SQLCA.sqlcode THEN
     CALL cl_err("fetch sfbiicd13_cs:", SQLCA.sqlcode, 1)
     CLOSE sfbiicd13_cs
     LET g_success = 'N' RETURN l_sfbi.*
  END IF
  CLOSE sfbiicd13_cs
 
  #若有入庫單/項次,先撈取入庫單/項 的倉,儲,批,數,量,單位,供後面比較
  IF NOT cl_null(l_sfbi.sfbiicd16) AND NOT cl_null(l_sfbi.sfbiicd17) THEN
     SELECT rvv32,rvv33,rvv34,rvv17,rvv35
       INTO l_rvv32,l_rvv33,l_rvv34,l_rvv17,l_rvv35
       FROM rvu_file,rvv_file
      WHERE rvu01 = rvv01 AND rvu00 = '1' AND rvuconf = 'Y'
        AND rvv01 = l_sfbi.sfbiicd16
        AND rvv02 = l_sfbi.sfbiicd17
  END IF
 
  SELECT * INTO l_sfai.*
    FROM sfai_file
   WHERE sfai01 = l_sfa.sfa01
     AND sfai03 = l_sfa.sfa03
     AND sfai08 = l_sfa.sfa08
     AND sfai12 = l_sfa.sfa12
     AND sfai27 = l_sfa.sfa27 #CHI-7B0034
     AND sfai012 = l_sfa.sfa012  #FUN-A50066
     AND sfai013 = l_sfa.sfa013  #FUN-A50066

  #MOD-C30392---begin mark   
  #若該料號分批作委外, 則須賦予回貨批號, 即發料批號+'.01',以此類推
  #CASE
  #   WHEN NOT cl_null(l_sfbi.sfbiicd16)  AND  #1 若入庫單號 <> 空白 且
  #        NOT cl_null(l_sfbi.sfbiicd17)  AND  #    入庫項次 <> 空白 且
  #        l_rvv32 = l_sfa.sfa30 AND           #  同倉儲批
  #        l_rvv33 = l_sfa.sfa31 AND
  #        l_rvv34 = l_sfai.sfaiicd03
  #        #比對回貨數量入庫數量是否和本工單之發料數是否相同
  #        IF l_sfa.sfa12 <> l_rvv35 THEN
  #           CALL s_umfchk(l_sfa.sfa03,l_rvv35,l_sfa.sfa12)
  #           RETURNING l_cnt,l_factor
  #           IF l_cnt = 1 THEN
  #              LET l_msg = l_rvv35,'/',l_sfa.sfa12
  #              CALL cl_err(l_msg,'abm-731',1)
  #              LET g_success = 'N' RETURN l_sfbi.*
  #           END IF
  #           LET l_rvv17 = l_rvv17 * l_factor
  #        END IF
  #        IF l_rvv17 = l_sfa.sfa05 THEN
  #           #1.1 若相同,則回貨批號 = 發料批號,
  #           LET l_sfbi.sfbiicd13 = l_sfai.sfaiicd03
  #        ELSE
  #           #1.2 若不同,則至回貨批號檔(idl_file)取目前最大號碼,
  #           SELECT MAX(idl02) INTO l_idl02 FROM idl_file
  #            WHERE idl01 = l_sfai.sfaiicd03
  #           IF cl_null(l_idl02) THEN
  #              #1.2.1 若取不到則從'01'開始編,
  #              LET l_idl02 = '01'
  #              LET l_sfbi.sfbiicd13 = l_sfai.sfaiicd03 CLIPPED,'.',l_idl02
  #              #取號後, 須回寫回貨批號檔(idl_file)  用發料批號串idl01
  #              INSERT INTO idl_file(idl01,idl02)
  #                     VALUES(l_sfai.sfaiicd03,l_idl02)
  #              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
  #                 CALL cl_err('ins idl_file:',SQLCA.sqlcode,1)
  #                 LET g_success = 'N' RETURN l_sfbi.*
  #              END IF
  #           ELSE
  #              #1.2.2 若取得到idl02,
  #              #      則回貨批號 = 回貨批號 + '.'+ to_str(MAX(idl02)+1)
  #              #取號後, 須回寫回貨批號檔(idl_file)  用發料批號串idl01
  #              LET l_int = l_idl02
  #              LET l_int = l_int + 1
  #              LET l_idl02 = l_int USING '&&'
  #              LET l_sfbi.sfbiicd13 = l_sfai.sfaiicd03 CLIPPED,'.',l_idl02
  #              UPDATE idl_file SET idl02 = l_idl02
  #               WHERE idl01 = l_sfai.sfaiicd03
  #              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
  #                 CALL cl_err('upd idl_file:',SQLCA.sqlcode,1)
  #                 LET g_success = 'N' RETURN l_sfbi.*
  #              END IF
  #           END IF
  #        END IF
  #   WHEN cl_null(l_sfbi.sfbiicd16) OR cl_null(l_sfbi.sfbiicd17) OR
  #        (NOT cl_null(l_sfbi.sfbiicd16) AND NOT cl_null(l_sfbi.sfbiicd17) AND
  #         NOT(l_rvv32 = l_sfa.sfa30 AND   #2 入庫單號 = 空白 OR 入庫項次=空白
  #             l_rvv33 = l_sfa.sfa31 AND   #  或雖入庫單號/項次 <> 空白
  #             l_rvv34 = l_sfai.sfaiicd03)) #  但不同倉儲批
  #
  #        #比對庫存該批號數量是否和本工單之發料數是否相同
  #        SELECT img09,img10 INTO l_img09,l_img10 FROM img_file
  #         WHERE img01 = l_sfa.sfa03 AND img02 = l_sfa.sfa30
  #           AND img03 = l_sfa.sfa31 AND img04 = l_sfai.sfaiicd03
  #        #若無庫存該批號數量, 則回貨批號 = 發料批號
  #        IF SQLCA.sqlcode = 100 OR l_img10 = 0 THEN
  #           LET l_sfbi.sfbiicd13 = l_sfai.sfaiicd03
  #        ELSE
  #           IF l_img10 = l_sfa.sfa05 THEN
  #              #2.1 若相同, 則回貨批號 = 發料批號
  #              LET l_sfbi.sfbiicd13 = l_sfai.sfaiicd03
  #           ELSE
  #              #2.2 若不同,則至回貨批號檔(idl_file)取目前最大號碼,
  #              SELECT MAX(idl02) INTO l_idl02 FROM idl_file
  #               WHERE idl01 = l_sfai.sfaiicd03
  #              IF cl_null(l_idl02) THEN
  #                 #2.2.1 若取不到則從'01'開始編,
  #                 LET l_idl02 = '01'
  #                 LET l_sfbi.sfbiicd13 = l_sfai.sfaiicd03 CLIPPED,'.',l_idl02
  #                 #取號後, 須回寫回貨批號檔(idl_file)  用發料批號串idl01
  #                 INSERT INTO idl_file(idl01,idl02)
  #                        VALUES(l_sfai.sfaiicd03,l_idl02)
  #                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
  #                    CALL cl_err('ins idl_file:',SQLCA.sqlcode,1)
  #                    LET g_success = 'N' RETURN l_sfbi.*
  #                 END IF
  #              ELSE
  #                 #2.2.2 若取得到idl02,
  #                 #      則回貨批號 = 回貨批號 + '.'+ to_str(MAX(idl02)+1)
  #                 LET l_int = l_idl02
  #                 LET l_int = l_int + 1
  #                 LET l_idl02 = l_int USING '&&'
  #                 LET l_sfbi.sfbiicd13 = l_sfai.sfaiicd03 CLIPPED,'.',l_idl02
  #                 #取號後, 須回寫回貨批號檔(idl_file)  用發料批號串idl01
  #                 UPDATE idl_file SET idl02 = l_idl02
  #                  WHERE idl01 = l_sfai.sfaiicd03
  #                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
  #                    CALL cl_err('upd idl_file:',SQLCA.sqlcode,1)
  #                    LET g_success = 'N' RETURN l_sfbi.*
  #                 END IF
  #              END IF
  #           END IF
  #        END IF
  #END CASE
  #MOD-C30392---end mark
  LET l_sfbi.sfbiicd13 = l_sfai.sfaiicd03#MOD-C30392
  #回寫update 回貨批號(sfbiicd13)
  UPDATE sfbi_file SET sfbiicd13 = l_sfbi.sfbiicd13
   WHERE sfbi01 = l_sfb.sfb01         #No:MOD-A30091 modify
  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
     CALL cl_err('upd sfbiicd13:',SQLCA.sqlcode,1)
     LET g_success = 'N' RETURN l_sfbi.*
  END IF
  RETURN l_sfbi.*  #FUN-A30027
END FUNCTION
 
#產生生產資訊(ico_file)
FUNCTION i301sub_ind_icd_gen_ico(l_sfb,l_sfbi)
   DEFINE l_ecdicd01 LIKE ecd_file.ecdicd01,
          l_ico    RECORD LIKE ico_file.*
   DEFINE l_cnt    LIKE type_file.num5
   DEFINE l_sfb    RECORD LIKE sfb_file.*
   DEFINE l_sfbi   RECORD LIKE sfbi_file.*
 
   #若已有資料則不新增(類別要為0,1,2,3,4任一)
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM ico_file
    WHERE ico01 =  l_sfb.sfb01
 
   IF l_cnt > 0 THEN
      #如果沒有ico03=0,1,2,3,4的資料,要再從icl_file copy資料吆
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM ico_file
       WHERE ico01 = l_sfb.sfb01
         AND ico03 IN ('0','1','2','3','4')
      IF l_cnt = 0 THEN
         CALL i301sub_ind_icd_gen_ico2(l_sfb.*,l_sfbi.*)
         IF g_success = 'N' THEN RETURN END IF
      END IF
   ELSE
      IF NOT cl_null(l_sfbi.sfbiicd09) THEN
         SELECT ecdicd01 INTO l_ecdicd01 FROM ecd_file
          WHERE ecd01 = l_sfbi.sfbiicd09
      END IF
 
      CASE
         WHEN NOT cl_null(l_sfb.sfb86)
         #1.若母工單號<>空白,複製該張母工單號生產資訊(ico_file)至本張工單
         #  若作業群組=4.ASS或6.TKY,且生產資訊檔中Date Code否(ico05) = Y,
         #  則將備註(ico06)中[DATECODE]字樣置換成Date Code(sfbiicd07)之值
              DECLARE ico_cs1 CURSOR FOR
               SELECT * FROM ico_file
                WHERE ico01 = l_sfb.sfb86
                  AND ico02 = 0
              FOREACH ico_cs1 INTO l_ico.*
                IF SQLCA.sqlcode THEN
                   CALL cl_err('foreach ico_cs1',SQLCA.sqlcode,0)
                   LET g_success = 'N'
                   RETURN
                END IF
                LET l_ico.ico01 = l_sfb.sfb01
                LET l_ico.icouser = g_user
                LET l_ico.icogrup = g_grup
                LET l_ico.icodate = g_today
                LET l_ico.icomodu = NULL
                LET l_ico.icoacti = 'Y'
                IF l_ecdicd01 MATCHES '[46]' AND l_ico.ico05 = 'Y' THEN
                   CALL cl_replace_str(l_ico.ico06,'[DATECODE]',
                                       l_sfbi.sfbiicd07)
                        RETURNING l_ico.ico06
                END IF
                LET l_ico.icooriu = g_user      #No.FUN-980030 10/01/04
                LET l_ico.icoorig = g_grup      #No.FUN-980030 10/01/04
                INSERT INTO ico_file VALUES(l_ico.*)
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                   CALL cl_err('ins ico_file:',SQLCA.sqlcode,1)
                   LET g_success = 'N' RETURN
                END IF
              END FOREACH
              #如果沒有ico03=0,1,2,3,4的資料,要再從icl_file copy資料吆
              LET l_cnt = 0
              SELECT COUNT(*) INTO l_cnt FROM ico_file
               WHERE ico01 = l_sfb.sfb01
                 AND ico03 IN ('0','1','2','3','4')
              IF l_cnt = 0 THEN
                 CALL i301sub_ind_icd_gen_ico2(l_sfb.*,l_sfbi.*)
                 IF g_success = 'N' THEN RETURN END IF
              END IF
 
         WHEN NOT cl_null(l_sfb.sfb22)
         #2.若訂單單號<>空白,複製該張定單單號生產資訊(ico_file)至本張工單
         #  若作業群組=4.ASS或6.TKY,若生產資訊檔中Date Code 否(ico05)=Y
         #  則將備註(ico06)中[DATECODE]字樣置換成Date Code(sfbiicd07)之值
              DECLARE ico_cs2 CURSOR FOR
               SELECT * FROM ico_file
                WHERE ico01 = l_sfb.sfb22
                  AND ico02 = l_sfb.sfb221
              FOREACH ico_cs2 INTO l_ico.*
                IF SQLCA.sqlcode THEN
                   CALL cl_err('foreach ico_cs2',SQLCA.sqlcode,0)
                   LET g_success = 'N'
                   RETURN
                END IF
                LET l_ico.ico01 = l_sfb.sfb01
                LET l_ico.ico02 = 0
                LET l_ico.icouser = g_user
                LET l_ico.icogrup = g_grup
                LET l_ico.icodate = g_today
                LET l_ico.icomodu = NULL
                LET l_ico.icoacti = 'Y'
                IF l_ecdicd01 MATCHES '[46]' AND l_ico.ico05 = 'Y' THEN
                   CALL cl_replace_str(l_ico.ico06,'[DATECODE]',
                                       l_sfbi.sfbiicd07)
                        RETURNING l_ico.ico06
                END IF
                INSERT INTO ico_file VALUES(l_ico.*)
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                   CALL cl_err('ins ico_file:',SQLCA.sqlcode,1)
                   LET g_success = 'N' RETURN
                END IF
              END FOREACH
              #如果沒有ico03=0,1,2,3,4的資料,要再從icl_file copy資料吆
              LET l_cnt = 0
              SELECT COUNT(*) INTO l_cnt FROM ico_file
               WHERE ico01 = l_sfb.sfb01
                 AND ico03 IN ('0','1','2','3','4')
              IF l_cnt = 0 THEN
                 CALL i301sub_ind_icd_gen_ico2(l_sfb.*,l_sfbi.*)
                 IF g_success = 'N' THEN RETURN END IF
              END IF
         OTHERWISE
              CALL i301sub_ind_icd_gen_ico2(l_sfb.*,l_sfbi.*)
      END CASE
   END IF
END FUNCTION
 
#由icl_file產生生產資訊(ico_file)
FUNCTION i301sub_ind_icd_gen_ico2(l_sfb,l_sfbi)
   DEFINE l_ecdicd01 LIKE ecd_file.ecdicd01,
          l_ico    RECORD LIKE ico_file.*,
          l_icl    RECORD LIKE icl_file.*,
          l_icl01  LIKE icl_file.icl01,
          l_sfb    RECORD LIKE sfb_file.*,
          l_sfbi   RECORD LIKE sfbi_file.*,
          l_cnt    LIKE type_file.num5
 
   IF NOT cl_null(l_sfbi.sfbiicd09) THEN
      SELECT ecdicd01 INTO l_ecdicd01 FROM ecd_file
       WHERE ecd01 = l_sfbi.sfbiicd09
   END IF
 
   #用料號串正背印檔(icl_file) ,
   #複製類別= [0. Logo],[1.正印],[2.背印],[3.正印備註],[4.背印備註];
   #若作業群組=4.ASS或6.TKY,若生產資訊檔中Date Code 否(ico05)=Y
   #則將備註(ico06)中[DATECODE]字樣置換成Date Code(sfbiicd07)之值
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM icl_file
    WHERE icl01 = l_sfb.sfb05 AND icl02 IN ('0','1','2','3','4')
 
   CASE
      WHEN l_cnt > 0
          #1.若用料號串icl_file有資料
           LET l_icl01 = l_sfb.sfb05
      WHEN l_cnt = 0
          #2.若用料號串icl_file沒有資料,改用母體料號(sfbiicd14)
           LET l_icl01 = l_sfbi.sfbiicd14
   END CASE
 
   DECLARE icl_cs CURSOR FOR
    SELECT * FROM icl_file
     WHERE icl01 = l_icl01 AND icl02 IN ('0','1','2','3','4')
   FOREACH icl_cs INTO l_icl.*
     IF SQLCA.sqlcode THEN
        CALL cl_err('foreach icl_cs',SQLCA.sqlcode,1)
        LET g_success = 'N'
        RETURN
     END IF
     INITIALIZE l_ico.* TO NULL
     LET l_ico.ico01 = l_sfb.sfb01
     LET l_ico.ico02 = 0
     LET l_ico.ico03 = l_icl.icl02
     LET l_ico.ico04 = l_icl.icl03
     LET l_ico.ico05 = l_icl.icl04
     LET l_ico.ico06 = l_icl.icl05
     LET l_ico.ico07 = NULL
     LET l_ico.icouser = g_user
     LET l_ico.icogrup = g_grup
     LET l_ico.icodate = g_today
     LET l_ico.icomodu = NULL
     LET l_ico.icoacti = 'Y'
     IF l_ecdicd01 MATCHES '[46]' AND l_ico.ico05 = 'Y' THEN
        CALL cl_replace_str(l_ico.ico06,'[DATECODE]',l_sfbi.sfbiicd07)
             RETURNING l_ico.ico06
     END IF
     LET l_ico.icooriu = g_user      #No.FUN-980030 10/01/04
     LET l_ico.icoorig = g_grup      #No.FUN-980030 10/01/04
     INSERT INTO ico_file VALUES(l_ico.*)
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
        CALL cl_err('ins ico_file:',SQLCA.sqlcode,1)
        LET g_success = 'N' RETURN
     END IF
   END FOREACH
END FUNCTION
 
#工單領料
FUNCTION i301sub_ind_icd_material_collect(p_sfb01,p_slip,p_sfp03,p_action_choice)
   DEFINE p_slip  STRING,
          p_sfb01 LIKE sfb_file.sfb01,
          p_sfp03 LIKE sfp_file.sfp03,
          l_no    LIKE sfp_file.sfp01
   DEFINE p_row,p_col  LIKE type_file.num5
   DEFINE li_result    LIKE type_file.num5
   DEFINE p_action_choice STRING
   DEFINE l_sfb   RECORD LIKE sfb_file.*
   DEFINE l_cnt   LIKE type_file.num5
   DEFINE l_msg   LIKE type_file.chr1000
   DEFINE l_smy73 LIKE smy_file.smy73      #TQC-AC0293 
   DEFINE l_sql   STRING                   #TQC-AC0293   	
 
   IF s_shut(0) THEN RETURN NULL END IF
 
   SELECT * INTO l_sfb.* FROM sfb_file WHERE sfb01 = p_sfb01
 
   IF l_sfb.sfb01 IS NULL THEN CALL cl_err(p_sfb01,-400,1) RETURN NULL END IF
   #不可作廢
   IF l_sfb.sfb87 = 'X' THEN CALL cl_err(p_sfb01,'9024',1) RETURN NULL END IF
   #不可未確認
   IF l_sfb.sfb87 = 'N' THEN CALL cl_err(p_sfb01,'aap-717',1) RETURN NULL END IF
   #不可未發放
   IF l_sfb.sfb04 = '1' THEN CALL cl_err(p_sfb01,'asf-381',1) RETURN NULL END IF
   #不可已結案
   IF l_sfb.sfb04 = '8' THEN CALL cl_err(p_sfb01,'9004',1) RETURN NULL END IF 
 
   IF cl_null(p_slip) THEN  #由asfi301串接p_slip=null,由aicp046串接p_slip<>null
      LET p_row = 10
      LET p_col = 35
 
      OPEN WINDOW asfi301d_w AT p_row,p_col
             WITH FORM "asf/42f/asfi301d"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
      CALL cl_ui_locale("asfi301d")
 
      INPUT p_slip WITHOUT DEFAULTS FROM smyslip
         AFTER FIELD smyslip
            IF NOT cl_null(p_slip) THEN
               LET l_cnt = 0
               CALL s_check_no("asf",p_slip,"","3","sfp_file","sfp01","") #FUN-CA0022 add 3
                    RETURNING li_result,p_slip
               DISPLAY p_slip TO smyslip
               IF (NOT li_result) THEN
                   NEXT FIELD smyslip
               END IF
              #TQC-AC0293 ------------add start-----------------
               LET l_sql = " SELECT smy73  FROM smy_file ",
                           "  WHERE smyslip ='",p_slip,"'" 
               PREPARE pre_smy FROM l_sql
               EXECUTE pre_smy INTO l_smy73
               IF l_smy73 = 'Y' THEN
                  CALL cl_err('','asf-874',0)
                  NEXT FIELD smyslip 
               END IF   
              #TQC-AC0293 ------------add end--------------------- 
            END IF
 
         ON ACTION CONTROLP
            LET l_sql = " (smy73 <> 'Y' OR smy73 is null) "                        #TQC-AC0293
            CALL smy_qry_set_par_where(l_sql)                   #TQC-AC0293
            CALL q_smy(FALSE,TRUE,p_slip,'asf','3') RETURNING p_slip
            DISPLAY p_slip TO smyslip
            NEXT FIELD smyslip
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG 
            CALL cl_cmdask()
 
      END INPUT
      CLOSE WINDOW asfi301d_w
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         RETURN NULL
      END IF
      IF NOT cl_null(p_action_choice) THEN
         IF NOT cl_confirm('afa-347') THEN
            RETURN NULL
         END IF
      END IF
         
 
   END IF
 
   BEGIN WORK
   LET g_success = 'Y'
   
   IF cl_null(p_sfp03) OR p_sfp03=0 THEN
      LET p_sfp03=g_today
   END IF
   # isnert 發料底稿單頭(sfp_file)
     CALL i301sub_ind_icd_ins_sfp(p_slip,p_sfp03,l_sfb.sfb81) RETURNING l_no
   
   # isnert 發料底稿單身(sfq_file)
   IF g_success = 'Y' THEN CALL i301sub_ind_icd_ins_sfq(l_no,l_sfb.sfb01) END IF
   
   # isnert 發料底稿單身(sfs_file)
   IF g_success = 'Y' THEN CALL i301sub_ind_icd_ins_sfs(l_no,l_sfb.sfb01) END IF
   
   IF g_success = 'Y' THEN
      COMMIT WORK        
   ELSE
      CALL cl_err('','abm-020',1)
      ROLLBACK WORK
   END IF
   
   #檢查有發料單存在否,若存在則自動過帳(這段先不做放到aicp046作),因為沒刻號/BIN資料所以過帳會失敗
   LET g_success='Y'
   RETURN l_no
   
END FUNCTION
 
# isnert 發料底稿單頭(sfp_file)
FUNCTION i301sub_ind_icd_ins_sfp(p_slip,p_sfp03,p_sfb81)        
    DEFINE p_slip       STRING,
           p_sfp03      LIKE sfp_file.sfp03
    DEFINE li_result    LIKE type_file.num5
    DEFINE l_sfp        RECORD LIKE sfp_file.*
    DEFINE p_sfb81      LIKE sfb_file.sfb81
 
    #取得單號
    CALL s_auto_assign_no("asf",p_slip,p_sfb81,"",
                          "sfp_file","sfp01","","","")
         RETURNING li_result,l_sfp.sfp01
    IF (NOT li_result) THEN
       LET g_success = 'N'
       RETURN l_sfp.sfp01
    END IF
    LET l_sfp.sfp02  =p_sfp03                                               
    LET l_sfp.sfp03  =p_sfp03
    LET l_sfp.sfp04  ='N'
    LET l_sfp.sfp05  ='N'
    LET l_sfp.sfp06  ='1'
    LET l_sfp.sfp09  ='N'
    LET l_sfp.sfpconf = 'N' #FUN-920054
    LET l_sfp.sfpuser=g_user
    LET l_sfp.sfpgrup=g_grup
    LET l_sfp.sfpdate=p_sfp03
    #FUN-AB0001--add---str---
    LET l_sfp.sfpmksg = 'N'          #是否簽核
    LET l_sfp.sfp15 = '0'            #簽核狀況
    LET l_sfp.sfp16 = g_user         #申請人
    #FUN-AB0001--add---end--- 

    LET l_sfp.sfpplant=g_plant  #FUN-980008 add
    LET l_sfp.sfplegal=g_legal  #FUN-980008 add
 
    LET l_sfp.sfporiu = g_user      #No.FUN-980030 10/01/04
    LET l_sfp.sfporig = g_grup      #No.FUN-980030 10/01/04
#    IF cl_null(l_sfp.sfpmksg) THEN  LET l_sfp.sfpmksg = 'N' END IF    #FUN-B50106
#    IF cl_null(l_sfp.sfp15) THEN  LET l_sfp.sfp15 = '0' END IF        #FUN-B50106
    INSERT INTO sfp_file VALUES (l_sfp.*)
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
       CALL cl_err('ins sfp:',SQLCA.sqlcode,1)
       LET g_success = 'N'
       RETURN l_sfp.sfp01
    END IF
    RETURN l_sfp.sfp01
END FUNCTION
 
# isnert 發料底稿單身(sfq_file)
FUNCTION i301sub_ind_icd_ins_sfq(p_no,l_sfb01)
   DEFINE p_no        LIKE sfp_file.sfp01
   DEFINE l_sfq       RECORD LIKE sfq_file.*
   DEFINE l_sfb01     LIKE sfb_file.sfb01
   DEFINE l_sfb08     LIKE sfb_file.sfb08
  #DEFINE l_sfbiicd04 LIKE sfbi_file.sfbiicd04   #TQC-C60025 mark
   DEFINE l_sfq04     LIKE sfq_file.sfq04        #CHI-830032
 
  #SELECT sfb08,sfbiicd04 INTO l_sfb08,l_sfbiicd04  #TQC-C60025 mark
   SELECT sfb08 INTO l_sfb08                        #TQC-C60025
     FROM sfb_file,sfbi_file
    WHERE sfb01  = l_sfb01
      AND sfbi01 = sfb01
 
   LET l_sfq.sfq01 = p_no
   LET l_sfq.sfq02 = l_sfb01
  #IF NOT cl_null(l_sfb08) THEN   #TQC-C60025 mark
      LET l_sfq.sfq03 = l_sfb08 #全數發料
  #str TQC-C60025 mark
  #ELSE
  #   LET l_sfq.sfq03 = l_sfbiicd04 #全數發料
  #END IF
  #end TQC-C60025 mark
   #取得第一筆備料單之作業編號,ICD只會有一筆備料
   DECLARE ind_icd_ins_sfq CURSOR FOR
      SELECT sfa08 FROM sfa_file,sfb_file
                  WHERE sfa01 = sfb01 
                    AND sfb01 = l_sfb01
   FOREACH ind_icd_ins_sfq INTO l_sfq.sfq04
      EXIT FOREACH
   END FOREACH 
   IF cl_null(l_sfq.sfq04) THEN
      LET l_sfq.sfq04 = ' '
   END IF
   LET l_sfq.sfq05 = g_today  #CHI-830032
   LET l_sfq.sfq06 = NULL
   LET l_sfq.sfqplant=g_plant  #FUN-980008 add
   LET l_sfq.sfqlegal=g_legal  #FUN-980008 add
 
   #FUN-B20095(S)
   IF cl_null(l_sfq.sfq012) THEN
      LET l_sfq.sfq012 = ' '
   END IF
   #FUN-B20095(E)
   #FUN-C70014 add begin---------------------
   IF cl_null(l_sfq.sfq014) THEN
      LET l_sfq.sfq014 = ' '      
   END IF 
   #FUN-C70014 add end-----------------------
   INSERT INTO sfq_file VALUES (l_sfq.*)
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err('ins sfq:',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
END FUNCTION
 
# isnert 發料底稿單身(sfs_file)
FUNCTION i301sub_ind_icd_ins_sfs(p_no,l_sfb01)
   DEFINE p_no  LIKE sfp_file.sfp01
   DEFINE l_sfb01 LIKE sfb_file.sfb01
   DEFINE l_sql STRING
   DEFINE l_sfa RECORD LIKE sfa_file.*
   DEFINE l_sfs RECORD LIKE sfs_file.*
   DEFINE l_sfsi RECORD LIKE sfsi_file.*    #FUN-B70074
   DEFINE l_gfe03 LIKE gfe_file.gfe03
   DEFINE l_imaicd04   LIKE imaicd_file.imaicd04,
          l_ima906     LIKE ima_file.ima906,
          l_qty        LIKE sfs_file.sfs05,
          l_factor     LIKE ima_file.ima31_fac
   DEFINE l_sfai       RECORD LIKE sfai_file.*
   DEFINE l_cnt        LIKE type_file.num5  #FUN-C30281
   DEFINE l_sfaa RECORD LIKE sfaa_file.*    #FUN-C30247
   DEFINE l_sfp07      LIKE sfp_file.sfp07  #FUN-CB0087 製造部門
   DEFINE l_sfp16      LIKE sfp_file.sfp16  #FUN-CB0087 申請人

   #FUN-C30274 --START mark--
   #LET l_sql = "SELECT * FROM sfa_file ",
               #" WHERE sfa01 = '",l_sfb01,"' ",
               #"   AND sfa05 > sfa06 ",
               #"   AND (sfa11 NOT IN ('E','X') OR sfa11 IS NULL)", #CHI-980013
               #"   AND (sfa05 - sfa065) > 0 ",  #應發-委外代買量>0
               #" ORDER BY sfa27,sfa03 "
   #FUN-C30274 --END mark--       
   #FUN-C30274 --END--   
   LET l_sql = "SELECT * FROM sfa_file,sfaa_file ",
               " WHERE sfa01 = '",l_sfb01,"' ",
               "   AND sfa05 > sfa06 ",
               "   AND (sfa11 NOT IN ('E','X') OR sfa11 IS NULL)", #CHI-980013
               "   AND (sfa05 - sfa065) > 0 ",  #應發-委外代買量>0
               "   AND sfa01 = sfaa01 AND sfa03 = sfaa03 ",
               "   AND sfa08 = sfaa08 AND sfa12 = sfaa12 ",
               "   AND sfa27 = sfaa27 AND sfa012 = sfaa012 ",
               "   AND sfa013 = sfaa013 ",
               " ORDER BY sfa27,sfa03 " 
   #FUN-C30274 --END--            
   PREPARE ins_sfs_pre FROM l_sql
   DECLARE ins_sfs_cs CURSOR FOR ins_sfs_pre
   LET l_sfs.sfs02 = 0
   FOREACH ins_sfs_cs INTO l_sfa.*,l_sfaa.*   #FUN-C30274 add l_sfaa.*
      LET l_gfe03 = NULL     LET l_factor = NULL
      LET l_ima906 = NULL    LET l_imaicd04 = NULL
 
      #取料件單位使用方式(ima906),料件狀態(imaicd04)
      SELECT ima906,imaicd04 INTO l_ima906,l_imaicd04
        FROM ima_file,imaicd_file 
       WHERE ima01 = l_sfa.sfa03
         AND imaicd00 = ima01
 
      #取料單位小數位數
      SELECT gfe03 INTO l_gfe03 FROM gfe_file WHERE gfe01=l_sfa.sfa12
      IF SQLCA.sqlcode OR cl_null(l_gfe03) THEN LET l_gfe03=0 END IF
 
      SELECT * INTO l_sfai.*
        FROM sfai_file
       WHERE sfai01 = l_sfa.sfa01 #FUN-920054 add l_sfa.
         AND sfai03 = l_sfa.sfa03 #FUN-920054 add l_sfa.
         AND sfai08 = l_sfa.sfa08 #FUN-920054 add l_sfa.
         AND sfai12 = l_sfa.sfa12 #FUN-920054 add l_sfa.
         AND sfai27 = l_sfa.sfa27 #FUN-920054 add l_sfa.
         AND sfai012= l_sfa.sfa012  #FUN-A50066
         AND sfai013= l_sfa.sfa013  #FUN-A50066
       
      IF l_sfai.sfaiicd06 = 'Y' THEN   #FUN-C30274 
         LET l_qty = l_sfaa.sfaa05     #FUN-C30274 
         LET l_sfs.sfs07=l_sfaa.sfaa30 #FUN-CA0022
         LET l_sfs.sfs08=l_sfaa.sfaa31 #FUN-CA0022 
         LET l_sfs.sfs09=l_sfaa.sfaa32 #FUN-CA0022 
      ELSE                             #FUN-C30274 
         LET l_sfa.sfa05 = l_sfa.sfa05 - l_sfa.sfa065
         LET l_qty = (l_sfa.sfa05 - l_sfa.sfa06)
         LET l_sfs.sfs07=l_sfa.sfa30   #FUN-CA0022
         LET l_sfs.sfs08=l_sfa.sfa31   #FUN-CA0022 
         LET l_sfs.sfs09=l_sfai.sfaiicd03 #FUN-CA0022 
      END IF                           #FUN-C30274 
      
      CALL i301sub_ind_icd_chk_ima64(l_sfa.sfa03, l_qty) RETURNING l_qty
      
      LET l_sfs.sfs01=p_no
      LET l_sfs.sfs02=l_sfs.sfs02+1
      LET l_sfs.sfs03=l_sfb01
      LET l_sfs.sfs04=l_sfa.sfa03
      LET l_sfs.sfs05=l_qty
      LET l_sfs.sfs06=l_sfa.sfa12
      LET l_sfs.sfs05=s_digqty(l_sfs.sfs05,l_sfs.sfs06)  #FUN-BB0084
      #LET l_sfs.sfs07=l_sfa.sfa30        #FUN-C30274 mark
      #LET l_sfs.sfs08=l_sfa.sfa31        #FUN-C30274 mark
      #LET l_sfs.sfs09=l_sfai.sfaiicd03   #FUN-C30274 mark
      #LET l_sfs.sfs07=l_sfaa.sfaa30       #FUN-C30274  #FUN-CA0022
      #LET l_sfs.sfs08=l_sfaa.sfaa31       #FUN-C30274  #FUN-CA0022
      #LET l_sfs.sfs09=l_sfaa.sfaa32       #FUN-C30274  #FUN-CA0022  
      LET l_sfs.sfs10=l_sfa.sfa08
      LET l_sfs.sfs26=NULL
      LET l_sfs.sfs27=NULL
      LET l_sfs.sfs28=NULL
    # IF l_sfa.sfa26 MATCHES '[SUT]' THEN   #FUN-A20037
      IF l_sfa.sfa26 MATCHES '[SUTZ]' THEN  #FUN-A20037
         LET l_sfs.sfs26=l_sfa.sfa26
         LET l_sfs.sfs27=l_sfa.sfa27
         LET l_sfs.sfs28=l_sfa.sfa28
      ELSE                            #No.MOD-8B0086 add
         LET l_sfs.sfs27=l_sfa.sfa27  #No.MOD-8B0086 add
      END IF
      IF l_sfs.sfs07 IS NULL THEN LET l_sfs.sfs07 = ' ' END IF
      IF l_sfs.sfs08 IS NULL THEN LET l_sfs.sfs08 = ' ' END IF
      IF l_sfs.sfs09 IS NULL THEN LET l_sfs.sfs09 = ' ' END IF
      LET l_sfs.sfs30 = NULL
      LET l_sfs.sfs31 = NULL
      LET l_sfs.sfs32 = NULL
      LET l_sfs.sfs33 = NULL
      LET l_sfs.sfs34 = NULL
      LET l_sfs.sfs35 = NULL
 
      #處理雙單位
      IF g_sma.sma115 = 'Y' THEN
         LET l_sfs.sfs30 = l_sfs.sfs06
         #與工單備料檔中的備料單位轉換
         CALL s_umfchk(l_sfs.sfs04,l_sfs.sfs06,l_sfa.sfa12)
            RETURNING g_errno,l_factor
         LET l_sfs.sfs31 = l_factor
         LET l_sfs.sfs32 = l_sfs.sfs05 / l_factor
         LET l_sfs.sfs32 = s_digqty(l_sfs.sfs32,l_sfs.sfs30)    #FUN-BB0084
 
         IF l_ima906 = '1' THEN  #不使用雙單位
            LET l_sfs.sfs33 = NULL
            LET l_sfs.sfs34 = NULL
            LET l_sfs.sfs35 = NULL
         ELSE
            LET l_sfs.sfs33 = l_sfai.sfaiicd02
            #與工單備料檔中的備料單位轉換
            CALL s_umfchk(l_sfs.sfs04,l_sfs.sfs33,l_sfa.sfa12)
               RETURNING g_errno,l_factor
            LET l_sfs.sfs34 = l_factor
            LET l_sfs.sfs35 = l_sfai.sfaiicd01 - l_sfai.sfaiicd04
            LET l_sfs.sfs35 = s_digqty(l_sfs.sfs35,l_sfs.sfs33)     #FUN-BB0084
         END IF
      END IF
      LET l_sfs.sfsplant=g_plant  #FUN-980008 add
      LET l_sfs.sfslegal=g_legal  #FUN-980008 add
      LET l_sfs.sfs012 = l_sfa.sfa012   #FUN-A60027 
      LET l_sfs.sfs013 = l_sfa.sfa013   #FUN-A60027
      LET l_sfs.sfs014 = ' '            #FUN-C70014 add
      
      #FUN-CB0087---add---str---
      IF g_aza.aza115 = 'Y' THEN
         SELECT sfp07,sfp16 INTO l_sfp07,l_sfp16 FROM sfp_file WHERE sfp01 = p_no 
         CALL s_reason_code(l_sfs.sfs01,l_sfs.sfs03,'',l_sfs.sfs04,l_sfs.sfs07,l_sfp07,l_sfp16) RETURNING l_sfs.sfs37
         IF cl_null(l_sfs.sfs37) THEN 
            CALL cl_err('','aim-425',1) 
            LET g_success = 'N'
            RETURN
         END IF
      END IF
      #FUN-CB0087---add---end--
      INSERT INTO sfs_file VALUES(l_sfs.*)
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err('ins sfs:',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
#FUN-B70074 -------------Begin---------------
      ELSE
         INITIALIZE l_sfsi.* TO NULL
         LET l_sfsi.sfsi01 = l_sfs.sfs01
         LET l_sfsi.sfsi02 = l_sfs.sfs02
         #FUN-C30281---begin
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM idb_file
         WHERE idb01=l_sfs.sfs04 AND idb02=l_sfs.sfs07
           AND idb03=l_sfs.sfs08 AND idb04=l_sfs.sfs09
           AND idb07=l_sfs.sfs01 AND idb08=l_sfs.sfs02

         IF l_cnt = 1 THEN
            SELECT idb14 INTO l_sfsi.sfsiicd029 FROM idb_file
             WHERE idb01=l_sfs.sfs04 AND idb02=l_sfs.sfs07
               AND idb03=l_sfs.sfs08 AND idb04=l_sfs.sfs09
               AND idb07=l_sfs.sfs01 AND idb08=l_sfs.sfs02
         ELSE
            SELECT idb14 INTO l_sfsi.sfsiicd029 FROM idb_file
             WHERE idb01=l_sfaa.sfaa03 AND idb02=l_sfaa.sfaa30
               AND idb03=l_sfaa.sfaa31 AND idb04=l_sfaa.sfaa32
               AND idb07=l_sfb01 AND idb08=1
         END IF 
         #FUN-C30281---end
         IF NOT s_ins_sfsi(l_sfsi.*,l_sfs.sfsplant) THEN
            LET g_success='N'
            RETURN
         END IF        
#FUN-B70074 -------------End-----------------
      END IF    
   END FOREACH
   IF l_sfs.sfs02 = 0 THEN
      CALL cl_err(l_sfb01,'asf-348',1)
      LET g_success = 'N'
   END IF
END FUNCTION
 
FUNCTION i301sub_ind_icd_chk_ima64(p_part, p_qty)
  DEFINE p_part         LIKE ima_file.ima01
  DEFINE p_qty          DEC(15,3)
  DEFINE l_ima108       LIKE ima_file.ima108
  DEFINE l_ima64        LIKE ima_file.ima64
  DEFINE l_ima641       LIKE ima_file.ima641
  DEFINE i              INTEGER
                                                                                
  SELECT ima108,ima64,ima641 INTO l_ima108,l_ima64,l_ima641 
    FROM ima_file WHERE ima01=p_part 
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

FUNCTION i301sub_icd_price(l_sfb,l_sfbi,l_ecdicd01,l_pmm04,l_pmm22,l_pmm21,l_pmm43,l_pmn86,l_pmm41,l_pmm20)
DEFINE     l_ecdicd01 LIKE ecd_file.ecdicd01,
           l_pmn31     LIKE pmn_file.pmn31,
           l_pmn31t    LIKE pmn_file.pmn31t,
           l_pmm21     LIKE pmm_file.pmm21,
           l_pmm22     LIKE pmm_file.pmm22,
           l_pmm43     LIKE pmm_file.pmm43,
           l_ecb06     LIKE ecb_file.ecb06,
           l_imaicd01  LIKE imaicd_file.imaicd01,
           l_pmn86     LIKE pmn_file.pmn86,
           l_pmm04     LIKE pmm_file.pmm04,
           l_pmm41     LIKE pmm_file.pmm41, 
           l_pmm20     LIKE pmm_file.pmm20,
           l_sfb       RECORD LIKE sfb_file.*,
           l_sfbi      RECORD LIKE sfbi_file.*,
           l_pmn73     LIKE pmn_file.pmn73,  #TQC-AC0257 ad
           l_pmn74     LIKE pmn_file.pmn74   #TQC-AC0257 ad
          


    CASE WHEN l_ecdicd01 = '2' OR l_ecdicd01 = '3'
             #FUN-C30234---begin
              LET l_imaicd01 = l_sfb.sfb05
              CALL s_defprice_new(l_imaicd01,l_sfb.sfb82,l_pmm22,
                              l_pmm04,l_sfb.sfb08,
                              l_sfbi.sfbiicd09,l_pmm21,
                              l_pmm43,'2',l_pmn86,'',l_pmm41,l_pmm20,g_plant) 
              RETURNING l_pmn31,l_pmn31t,l_pmn73,l_pmn74
              IF cl_null(l_pmn31) OR l_pmn31 = 0 THEN 
             #FUN-C30234---end
              #1 若料號之作業群組 = '2.CP' or '3.DS' ,
              #  則採購單價以母體料號取價,
             #IF g_sma.sma841 = '8' THEN #依Body取價     #MOD-B80116 mark 
                 SELECT imaicd01 INTO l_imaicd01 FROM imaicd_file
                  WHERE imaicd00 = l_sfb.sfb05
                #MOD-B80116---add---start---
                 IF cl_null(l_imaicd01) THEN
                    LET l_imaicd01 = l_sfb.sfb05
                 END IF
                #MOD-B80116---add---end---
             #MOD-B80116---mark---start---
             #ELSE                                    
             #   LET l_imaicd01 = l_sfb.sfb05
             #END IF
             #MOD-B80116---mark---end---
                 CALL s_defprice_new(l_imaicd01,l_sfb.sfb82,l_pmm22,
                                 l_pmm04,l_sfb.sfb08,
                                 l_sfbi.sfbiicd09,l_pmm21,
                                 l_pmm43,'2',l_pmn86,'',l_pmm41,l_pmm20,g_plant) 
                 RETURNING l_pmn31,l_pmn31t,l_pmn73,l_pmn74    #TQC-AC0257 add l_pmn73,l_pmn74
              END IF   #FUN-C30234
         WHEN l_ecdicd01 = '4' OR l_ecdicd01 = '5'
              CALL s_defprice_new(l_sfbi.sfbiicd08,l_sfb.sfb82,
                              l_pmm22,l_pmm04,l_sfb.sfb08,
                              l_sfbi.sfbiicd09,l_pmm21,
                              l_pmm43,'2',l_pmn86,'',l_pmm41,l_pmm20,g_plant)
              RETURNING l_pmn31,l_pmn31t,l_pmn73,l_pmn74    #TQC-AC0257 add l_pmn73,l_pmn74
         WHEN l_ecdicd01 = '6'
              DECLARE ecb_dec CURSOR FOR
               SELECT ecb06 FROM ecb_file
                WHERE ecb01 = l_sfb.sfb05 
                  AND ecb02 = l_sfb.sfb06
              FOREACH ecb_dec INTO l_ecb06
                CALL s_defprice_new(l_sfbi.sfbiicd08,l_sfb.sfb82,
                                l_pmm22,l_pmm04,l_sfb.sfb08,l_ecb06,l_pmm21,
                                l_pmm43,'2',l_pmn86,'',l_pmm41,l_pmm20,g_plant)
                RETURNING l_pmn31,l_pmn31t,l_pmn73,l_pmn74    #TQC-AC0257 add l_pmn73,l_pmn74
              END FOREACH
    END CASE
 
    RETURN l_pmn31,l_pmn31t
END FUNCTION

#FUN-A50066--begin--add---------------
FUNCTION i301sub_chk_sfb81(p_sfb93,p_sfb05,p_sfb95,p_sfb06,p_sfb02,p_sfb071,p_sfb81)
DEFINE l_cnt    LIKE type_file.num5
DEFINE p_sfb93  LIKE sfb_file.sfb93
DEFINE p_sfb05  LIKE sfb_file.sfb05
DEFINE p_sfb95  LIKE sfb_file.sfb95
DEFINE p_sfb06  LIKE sfb_file.sfb06
DEFINE p_sfb02  LIKE sfb_file.sfb02
DEFINE p_sfb071  LIKE sfb_file.sfb071
DEFINE p_sfb81  LIKE sfb_file.sfb81


   LET g_errno = ''
   IF g_sma.sma542 = 'Y' AND p_sfb93 = 'Y' THEN
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM bra_file
       WHERE bra01=p_sfb05
         AND bra06 = p_sfb95 
         AND bra011 = p_sfb06
      IF l_cnt >0 AND p_sfb02 !=15 AND p_sfb02 !=5 AND p_sfb02 !=8 AND p_sfb02 !=11 THEN    #MOD-A30143 modify
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM bra_file
          WHERE bra05 IS NOT NULL AND bra05 <=p_sfb071
            AND bra01=p_sfb05
            AND bra06 = p_sfb95 
            AND bra011 = p_sfb06
 
         IF l_cnt =0 THEN
              LET g_errno='abm-005'
              CALL cl_err(p_sfb071,g_errno,0) 
              RETURN 0
         END IF
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM bra_file
          WHERE bra05 IS NOT NULL AND bra05 <=p_sfb81
            AND bra01=p_sfb05
            AND bra06 = p_sfb95 
            AND bra011 = p_sfb06
 
         IF l_cnt =0 THEN
            LET g_errno='abm-006'
            CALL cl_err(p_sfb81,g_errno,0) 
            RETURN 0 
         END IF
      END IF
   ELSE
     LET l_cnt = 0
     SELECT COUNT(*) INTO l_cnt FROM bma_file
      WHERE bma01=p_sfb05
        AND bma06 = p_sfb95 
 
     IF l_cnt >0 AND p_sfb02 !=15 AND p_sfb02 !=5 AND p_sfb02 !=8 AND p_sfb02 !=11 THEN    #MOD-A30143 modify
        LET l_cnt = 0  
        SELECT COUNT(*) INTO l_cnt FROM bma_file
         WHERE bma05 IS NOT NULL AND bma05 <=p_sfb071
           AND bma01=p_sfb05
           AND bma06 = p_sfb95 
        
         IF l_cnt =0 THEN
            LET g_errno='abm-005'
            CALL cl_err(p_sfb071,g_errno,0) 
            RETURN 0
         END IF
         
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM bma_file
         WHERE bma05 IS NOT NULL AND bma05 <=p_sfb81
           AND bma01=p_sfb05
           AND bma06 = p_sfb95 
        
         IF l_cnt =0 THEN
             LET g_errno='abm-006'
             CALL cl_err(p_sfb81,g_errno,0) 
             RETURN 0
         END IF
     END IF 
   END IF  
   RETURN 1

END FUNCTION
#FUN-A50066--end--add--------------------------

#FUN-A80054--begin--add-----------------------
#p_inTransaction : IF p_inTransaction=FALSE 會在程式中呼叫BEGIN WORK
#p_ask_post : IF p_ask_post=TRUE 會詢問"是否執行刪除"
FUNCTION i301sub_r(p_sfb01,p_inTransaction,p_ask_post)
    DEFINE l_chr,l_sure    LIKE type_file.chr1,    
           l_sfb86_cnt_y   LIKE type_file.num5,  
           l_sfb01         LIKE sfb_file.sfb01,
           l_sfb86_cnt_n   LIKE type_file.num5  
    DEFINE l_r             LIKE type_file.num5 
    DEFINE l_sfb01_a       LIKE sfb_file.sfb01 
    DEFINE l_sfb01_b       LIKE sfb_file.sfb01
    DEFINE l_sfb96         LIKE sfb_file.sfb96 
    DEFINE l_n1,l_n,l_cnt  LIKE type_file.num5 
    DEFINE p_sfb01         LIKE sfb_file.sfb01
    DEFINE l_sfb           RECORD LIKE sfb_file.*
    DEFINE l_sfbi          RECORD LIKE sfbi_file.*
    DEFINE p_inTransaction LIKE type_file.num5 
    DEFINE p_ask_post      LIKE type_file.chr1 
    DEFINE g_msg           LIKE type_file.chr1000
    DEFINE l_sfd03         LIKE sfd_file.sfd03
    DEFINE l_sfb04         LIKE sfb_file.sfb04
 
   LET g_success = 'Y'
   IF s_shut(0) THEN LET g_success='N' RETURN END IF
   IF p_sfb01 IS NULL THEN CALL cl_err('',-400,0) LET g_success='N' RETURN END IF
  
   LET l_n = 0
   SELECT COUNT(*) INTO l_n FROM shm_file #若該工單已有runcard資料不可執行取消
    WHERE shm012=p_sfb01
   IF l_n>0 THEN  CALL cl_err('','asf-928',0) LET g_success='N' RETURN END IF
   #-->若該工單已開立成套發料資料不可執行 取消
   SELECT COUNT(*) INTO l_n FROM sfs_file
    WHERE sfs03=p_sfb01
   IF l_n>0 THEN  CALL cl_err('','asf-527',0) LET g_success='N' RETURN END IF
  #MOD-B70068 --- modify --- start ---
   SELECT COUNT(*) INTO l_n1 FROM sfe_file WHERE sfe01=g_sfb.sfb01
   IF l_n>0 OR l_n1>0 THEN  CALL cl_err('','asf-527',0)RETURN END IF
  #MOD-B70068 --- modify ---  end  ---
   SELECT * INTO l_sfb.* FROM sfb_file WHERE sfb01 = p_sfb01
   IF l_sfb.sfb87='Y'    THEN CALL cl_err('','aap-086',1) LET g_success='N' RETURN END IF
   IF l_sfb.sfb87 = 'X'  THEN CALL cl_err('','9024',0) LET g_success='N' RETURN END IF
   IF l_sfb.sfb04 >='2'  THEN CALL cl_err('','asf-902',0)LET g_success='N' RETURN END IF
   IF l_sfb.sfb081 > 0   THEN CALL cl_err('','asf-413',0) LET g_success='N' RETURN END IF
   IF l_sfb.sfb09  > 0   THEN CALL cl_err('','asf-413',0) LET g_success='N' RETURN END IF
 
   IF l_sfb.sfb87 = 'X' OR l_sfb.sfb43 = '9' THEN
      CALL cl_err('','9024',0)
      LET g_success='N'
      RETURN
   END IF
   IF l_sfb.sfb43 MATCHES '[Ss]' THEN
      CALL cl_err('','mfg3557',0)
      LET g_success='N'
      RETURN
   END IF
 
   LET l_n = 0
   SELECT COUNT(*) INTO l_n FROM pmn_file WHERE pmn41=p_sfb01
   IF l_n>0 THEN CALL cl_err('pmn.count','apm-196',0) LET g_success='N' RETURN END IF
 
  #CHECK是否有子工單
   LET l_sfb86_cnt_y = 0
   SELECT COUNT(*) INTO l_sfb86_cnt_y FROM sfb_file
    WHERE sfb86 = p_sfb01
      AND ( sfb86 IS NOT NULL AND sfb86 != ' ')
   IF cl_null(l_sfb86_cnt_y) THEN
      LET l_sfb86_cnt_y = 0
   END IF
   DECLARE i301sub_r_cs2 CURSOR WITH HOLD FOR
      SELECT sfb01 FROM sfb_file
       WHERE sfb86 = p_sfb01
         AND ( sfb86 IS NOT NULL AND sfb86 != ' ')
 
  #CHECK是否有未確認的子工單
   LET l_sfb86_cnt_n = 0
   SELECT COUNT(*) INTO l_sfb86_cnt_n FROM sfb_file
    WHERE sfb86 = p_sfb01
      AND ( sfb86 IS NOT NULL AND sfb86 != ' ')
      AND sfb87 = 'N'
   IF cl_null(l_sfb86_cnt_n) THEN
      LET l_sfb86_cnt_n =  0
   END IF
   DECLARE i301sub_r_cs CURSOR WITH HOLD FOR
      SELECT sfb01 FROM sfb_file WHERE sfb86 = p_sfb01
         AND ( sfb86 IS NOT NULL AND sfb86 != ' ')
         AND sfb87 = 'N'
      
   IF NOT p_inTransaction THEN
      BEGIN WORK
   END IF
 
   CALL i301sub_lock_cl()
   OPEN i301sub_cl USING p_sfb01
   IF STATUS THEN
      CALL cl_err("OPEN i301sub_cl:", STATUS, 1)
      CLOSE i301sub_cl
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF
      LET g_success='N'
      RETURN
   END IF
 
   FETCH i301sub_cl INTO l_sfb.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(p_sfb01,SQLCA.sqlcode,0)
      CLOSE i301sub_cl
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF
      LET g_success='N'
      RETURN
   END IF
 
   IF NOT s_industry('std') THEN
      OPEN i301sub_cl_ind USING p_sfb01
      IF STATUS THEN
         CALL cl_err("OPEN i301sub_cl_ind:", STATUS, 1)
         CLOSE i301sub_cl_ind
         IF NOT p_inTransaction THEN ROLLBACK WORK END IF
         LET g_success='N'
         RETURN
      END IF
 
      FETCH i301sub_cl_ind INTO l_sfbi.*
      IF SQLCA.sqlcode THEN
         CALL cl_err(p_sfb01,SQLCA.sqlcode,0)
         CLOSE i301sub_cl_ind
         IF NOT p_inTransaction THEN ROLLBACK WORK END IF
         LET g_success='N'
         RETURN
      END IF
   END IF

   IF p_ask_post='Y' THEN 
      IF NOT cl_delh(20,16) THEN
         IF NOT p_inTransaction THEN ROLLBACK WORK END IF
         LET g_success='N'
         RETURN
      END IF
   END IF

  #str TQC-C60019 add
   #ICD行業別時,工單刪除與作廢均應做刻號/BIN資料的刪除
   IF s_industry('icd') THEN
      IF NOT i301sub_del_idb(p_sfb01,'','','','','','','1') THEN
         LET g_success='N'
         RETURN
      END IF
   END IF
  #end TQC-C60019 add
         
   INITIALIZE g_doc.* TO NULL     
   LET g_doc.column1 = "sfb01"   
   LET g_doc.value1 = p_sfb01 
   CALL cl_del_doc()   
   IF l_sfb86_cnt_y > 0 THEN 
      CALL cl_init_qry_var()                                                                                      
      LET g_qryparam.form = "q_sfb86"                                                                               
      LET g_qryparam.arg1     = p_sfb01 
      LET g_qryparam.construct  = "N" 
      CALL cl_create_qry() RETURNING l_sfb01_b     
   ELSE
      CALL i301sub_chk_rela(p_sfb01,l_sfb.sfb86) RETURNING l_r  
      IF l_r = 2 THEN LET g_success='N' RETURN END IF 
   END IF 
   MESSAGE "Delete sfb,sfa!"
 
   #工單刪除時，check此工單是否有合拼工單
   LET l_cnt=0   #MOD-B30414
   SELECT COUNT(*) INTO l_cnt FROM sfd_file
    WHERE sfd01=l_sfb.sfb85 AND sfd03=l_sfb.sfb01
      AND (sfd07 IS NOT NULL AND sfd07<>' ') #MOD-B30414
   IF NOT cl_null(l_sfb.sfb85) AND l_cnt > 0 THEN  #MOD-B30414
      IF cl_confirm('asf-155') THEN
      #  CALL i301sub_r1(p_sfb01,l_sfb86_cnt_n,l_sfb86_cnt_y)               #FUN-B30098    
         CALL i301sub_r1(p_sfb01,l_sfb86_cnt_n,l_sfb86_cnt_y,l_sfb.sfb85)   #FUN-B30098
      ELSE
         LET g_success='N'
         RETURN
      END IF
   ELSE
     #CALL i301sub_r1(p_sfb01,l_sfb86_cnt_n,l_sfb86_cnt_y)                 #FUN-B30098
      CALL i301sub_r1(p_sfb01,l_sfb86_cnt_n,l_sfb86_cnt_y,l_sfb.sfb85)     #FUN-B30098 
   END IF
            
   CLEAR FORM
   INITIALIZE l_sfb.* TO NULL
   IF NOT s_industry('std') THEN
      INITIALIZE l_sfbi.* TO NULL   
   END IF
   #darcy:2023/05/15 add s---
   #还原atmt260 的tscud03
   update tsc_file set tscud03 = ''
    where tscud03 = p_sfb01
   if sqlca.sqlcode then
      let g_success = 'N'
      call cl_err('upd tsc',sqlca.sqlcode,1)
      rollback work
   end if
   #darcy:2023/05/15 add e---

   delete from tc_sfaa_file where tc_sfaa01 = p_sfb01  #darcy:2025/02/12 add 
 
   IF g_success = 'N' THEN
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF
   ELSE
      IF NOT p_inTransaction THEN COMMIT WORK END IF
      CALL cl_flow_notify(p_sfb01,'D')
   END IF
   CLOSE i301sub_cl
   IF NOT s_industry('std') THEN
      CLOSE i301sub_cl_ind
   END IF
 
END FUNCTION

FUNCTION i301sub_chk_rela(p_sfb01,p_sfb86)
  DEFINE l_cnt   LIKE type_file.num5
  DEFINE l_r     LIKE type_file.num5
  DEFINE l_cnt1  LIKE type_file.num5  
  DEFINE p_sfb01 LIKE sfb_file.sfb01
  DEFINE p_sfb86 LIKE sfb_file.sfb86
 
  LET l_r = 0
  IF cl_null(p_sfb01) THEN return l_r END IF
 
#IF g_action_choice = "void" THEN    #CHI-D20010
IF g_action_choice = "void" OR g_action_choice = "undo_void" THEN  #CHI-D20010
  IF cl_null(p_sfb86) THEN  #母單單號是空，表示可能為其他單的母單
    SELECT COUNT(*) INTO l_cnt FROM sfb_file
     WHERE sfb86 = p_sfb01 AND sfb87 <>'X'
  ELSE
    SELECT COUNT(*) INTO l_cnt FROM sfb_file
     WHERE sfb01 = p_sfb86 AND sfb87 <>'X'
  END IF
 
  IF l_cnt > 0 THEN
    IF cl_confirm("asf-080") THEN LET l_r = 1 ELSE LET l_r = 0 END IF
  ELSE
    LET l_r = 1
  END IF
ELSE    
    SELECT COUNT(*) INTO l_cnt1 FROM sfb_file
     WHERE sfb01 = p_sfb86 AND sfb87 <>'X'
  IF l_cnt1 > 0 THEN
     IF cl_confirm("asf-080") THEN LET l_r = 1 ELSE LET l_r = 2 END IF
  END IF
END IF
  RETURN l_r
END FUNCTION

#p_inTransaction : IF p_inTransaction=FALSE 會在程式中呼叫BEGIN WORK
#p_ask_post : IF p_ask_post=TRUE 會詢問"是否執行取消確認"
FUNCTION i301sub_firm2(p_sfb01,p_inTransaction,p_ask_post)
  DEFINE l_pmn01 LIKE pmn_file.pmn01
  DEFINE l_pmn02 LIKE pmn_file.pmn02
  DEFINE l_pmm18 LIKE pmm_file.pmm18
  DEFINE l_ecm03 LIKE ecm_file.ecm03 
  DEFINE l_cnt   LIKE type_file.num5  
  DEFINE l_pmn_cnt  LIKE type_file.num5 
  DEFINE l_sfb      RECORD LIKE sfb_file.*
  DEFINE l_sfbi     RECORD LIKE sfbi_file.*
  DEFINE p_sfb01    LIKE sfb_file.sfb01
  DEFINE p_inTransaction LIKE type_file.num5 
  DEFINE p_ask_post      LIKE type_file.chr1
  DEFINE l_ecm012        LIKE ecm_file.ecm012  #TQC-AC0077
  DEFINE l_flag          LIKE type_file.num5   #TQC-AC0336
  DEFINE l_ima571        LIKE ima_file.ima571  #TQC-AC0336
  DEFINE l_minopseq   LIKE type_file.num5   #FUN-B20070
  DEFINE l_btflg      LIKE type_file.chr1   #FUN-B20070
  DEFINE l_i          LIKE type_file.num5   #CHI-D40024
  DEFINE l_chk        LIKE type_file.chr1   #CHI-D40024
 
   LET g_success='Y'
   IF p_sfb01 IS NULL THEN CALL cl_err('',-400,0) LET g_success='N' RETURN END IF
 
   SELECT * INTO l_sfb.* FROM sfb_file WHERE sfb01 = p_sfb01
   IF NOT s_industry('std') THEN
      SELECT * INTO l_sfbi.* FROM sfbi_file WHERE sfbi01 = p_sfb01 
   END IF
   IF l_sfb.sfb87='N' THEN LET g_success='N' RETURN END IF
   IF l_sfb.sfb87 = 'X' OR l_sfb.sfb43 = '9' THEN
      CALL cl_err('','9024',0) 
      LET g_success='N'
      RETURN
   END IF
   IF l_sfb.sfb43 MATCHES '[Ss]' THEN
      CALL cl_err('','mfg3557',0)
      LET g_success='N'
      RETURN
   END IF
   
   IF (l_sfb.sfb02 = '7' OR l_sfb.sfb02 = '8') AND l_sfb.sfb100='1' THEN   
         SELECT COUNT(*) INTO l_pmn_cnt FROM pmn_file
           WHERE pmn41=p_sfb01
      IF l_pmn_cnt >0 THEN
         IF s_industry('icd') THEN
            IF NOT cl_confirm('aic-215') THEN
               LET g_success='N'
               RETURN
            END IF      
         ELSE
            CALL cl_err('','asf-986',1)
            LET g_success='N'
            RETURN
         END IF
      END IF
   ELSE
     #製程委外可以一對多, 故排除作廢即可
     SELECT COUNT(*) INTO l_pmn_cnt FROM pmn_file,pmm_file
       WHERE pmn41=p_sfb01
        AND pmn01=pmm01
        AND pmm18 <> 'X' 
     IF l_pmn_cnt >0 THEN
        IF s_industry('icd') THEN
           IF NOT cl_confirm('aic-215') THEN
              LET g_success='N'
              RETURN
           END IF      
        ELSE
           CALL cl_err('','asf-986',1)
           LET g_success='N'
           RETURN
        END IF
     END IF
   END IF

  #若該工單已有runcard資料不可執行確認還原
   SELECT COUNT(*) INTO l_cnt FROM shm_file
    WHERE shm012=p_sfb01
   IF l_cnt >0 THEN  CALL cl_err('','asf-937',0) LET g_success='N' RETURN END IF
   IF l_sfb.sfb93 = 'Y' THEN
      SELECT COUNT(*) INTO l_cnt FROM sgt_file
       WHERE sgt01 =p_sfb01
      IF l_cnt >0 THEN  CALL cl_err('','asf-796',0) LET g_success='N' RETURN END IF
   END IF  
   SELECT COUNT(*) INTO l_cnt FROM cci_file,ccj_file
    WHERE ccj04=p_sfb01 AND cci01=ccj01 AND cci02=ccj02
      AND ccifirm = 'Y'
   IF l_cnt >0 THEN  CALL cl_err('','aqc-024',0) LET g_success='N' RETURN END IF
 
   IF  l_sfb.sfb39='2' THEN
       LET l_cnt=0 
       SELECT COUNT(*) INTO l_cnt FROM sfv_file,sfu_file
        WHERE sfv11=p_sfb01
          AND sfv01 = sfu01
          AND sfuconf <> 'X'
       IF l_cnt > 0  THEN CALL cl_err('','asf-529',0) LET g_success='N' RETURN END IF 
   END IF
 
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt FROM snb_file
    WHERE snb01=p_sfb01
   IF l_cnt>0 THEN
      CALL cl_err('','asf-095',1)
      LET g_success='N'
      RETURN
   END IF

   #FUN-AC0074--begin--add----
    LET l_cnt = 0
    SELECT COUNT(*) INTO l_cnt
      FROM sie_file
     WHERE sie05=p_sfb01
    IF l_cnt > 0 THEN
       CALL cl_err('','axm-248',0)
       LET g_success = 'N'
       RETURN
    END IF
    #FUN-AC0074--end--add----

   IF NOT s_industry('icd') THEN
     #FUN-920190 ICD工單有發料仍可已取消確認
   # IF l_sfb.sfb04>='4' THEN RETURN END IF       #TQC-AB0302
     #TQC-AB0302 -----------------add start----------
     IF l_sfb.sfb04>='4' THEN
        CALL cl_err(l_sfb.sfb04,'asf-553',1)
        RETURN 
     END IF 
     #TQC-AB0302 -----------------add end-------------  
     #sfb04='3':列印,只警告仍可還原
     IF l_sfb.sfb04='3' THEN CALL cl_err(l_sfb.sfb03,'asf-002',1) END IF
   END IF
   IF l_sfb.sfb02 MATCHES '[78]'  AND l_sfb.sfb100='1' THEN    
      LET l_pmn01 = NULL
      SELECT MAX(pmn01) INTO l_pmn01 FROM pmn_file WHERE pmn41=p_sfb01
      IF l_pmn01 IS NULL THEN
         CALL cl_err('pmn01:','mfg3502',0) 
      END IF
   END IF
 
 
  IF NOT s_industry('icd') THEN
    SELECT COUNT(*) INTO l_cnt FROM sfq_file,sfp_file
     WHERE sfq02 = p_sfb01 AND sfq01 = sfp01 AND sfpconf != 'X'
    IF l_cnt > 0 THEN CALL cl_err('','asf-528',1) LET g_success='N' RETURN END IF
 
    SELECT COUNT(*) INTO l_cnt FROM sfs_file,sfp_file
     WHERE sfs03 = p_sfb01 AND sfs01 = sfp01 AND sfpconf !='X' 
    IF l_cnt > 0 THEN CALL cl_err('sel_sfs','asf-528',0) LET g_success='N' RETURN END IF
    SELECT COUNT(*) INTO l_cnt FROM sfe_file,sfp_file
     WHERE sfe01 = p_sfb01 AND sfe02 = sfp01 AND sfpconf != 'X'
    IF l_cnt > 0 THEN CALL cl_err('','asf-528',1) LET g_success='N' RETURN END IF
  END IF

 #IF g_sfb.sfb93='Y' THEN                       #FUN-9A0095 mark
  IF g_success='Y' AND g_sfb.sfb93='Y' THEN     #FUN-9A0095 add
      SELECT COUNT(*) INTO l_cnt FROM shb_file
       WHERE shb05 = p_sfb01
         AND shbconf = 'Y'    #FUN-A70095 
      IF l_cnt > 0 THEN
         CALL cl_err('','aqc-024',0)
         LET g_success='N'
         RETURN
      END IF
   END IF
  SELECT COUNT(*) INTO l_cnt FROM srf_file,srg_file
   WHERE srg16 = p_sfb01
     AND srf01 = srg01
     AND srfconf != 'X'
  IF l_cnt > 0 THEN
     LET g_success='N'
     CALL cl_err('','aqc-024',0)
     RETURN
  END IF
 
  IF NOT s_industry('icd') THEN
    # ICD工單有發料仍可已取消確認
    LET l_cnt = 0
    IF l_sfb.sfb02='7' THEN #委外工單
       SELECT COUNT(*) INTO l_cnt FROM pmm_file,pmn_file
                                 WHERE pmm01=pmn01
                                   AND pmmacti='Y'
                                   AND pmn41=p_sfb01
       IF SQLCA.sqlcode THEN
         LET l_cnt=0
       END IF
       IF l_cnt>0 THEN
          CALL cl_err('','asf-097',1)
          LET g_success='N'
          RETURN
       END IF
    END IF
  END IF
 

 IF s_industry('icd') THEN
   #存在已發出的採購單則不可取消確認
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
                   FROM pmm_file,pmn_file
                  WHERE pmm01=pmn01
                    AND pmn41=p_sfb01
                    AND pmm25='2'
   IF l_cnt>0 THEN
       LET g_success='N'
       CALL cl_err('','apm-337',1)
       RETURN
   END IF
 
   #存在非已作廢的委外收貨單資料則不可取消確認
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
                   FROM rva_file,rvb_file
                  WHERE rvb01=rva01
                    AND rvb34=p_sfb01
                    AND rvaconf <>'X'
   IF l_cnt>0 THEN
      LET g_success='N'
       CALL cl_err('','aic-216',1)
       RETURN
   END IF
 
   #存在非已作廢的工單完工入庫資料則不可取消確認
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
                   FROM sfu_file,sfv_file
                  WHERE sfu01=sfv01
                    AND sfv11=p_sfb01
                    AND sfuconf <>'X'
   IF l_cnt>0 THEN
       LET g_success='N'
       CALL cl_err('','aic-216',1)
       RETURN
   END IF
 END IF
  
 IF p_ask_post='Y' THEN
   IF NOT cl_confirm('axm-109') THEN LET g_success='N' RETURN END IF
 END IF
 #CALL i301sub_create_tmp()  #bug:4298  #CHI-D40024
 CALL g_pmm_tmp.clear()  #CHI-D40024
 LET g_tmp_idx = 0  #CHI-D40024
 
 IF NOT p_inTransaction THEN 
    BEGIN WORK
 END IF
 
   CALL i301sub_lock_cl()
   OPEN i301sub_cl USING p_sfb01
   IF STATUS THEN
      CALL cl_err("OPEN i301sub_cl:", STATUS, 1)
      CLOSE i301sub_cl
      IF NOT p_inTransaction THEN  ROLLBACK WORK END IF
      LET g_success='N'
      RETURN
   END IF
 
   FETCH i301sub_cl INTO l_sfb.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err('lock sfb:',SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE i301sub_cl 
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF
      LET g_success='N'
      RETURN
   END IF

   IF NOT s_industry('std') THEN
      OPEN i301sub_cl_ind USING p_sfb01
      IF STATUS THEN
         CALL cl_err("OPEN i301sub_cl_ind:", STATUS, 1)
         CLOSE i301sub_cl_ind
         IF NOT p_inTransaction THEN ROLLBACK WORK END IF
         LET g_success='N'
         RETURN
      END IF
 
      FETCH i301sub_cl_ind INTO l_sfbi.*          # 鎖住將被更改或取消的資料
      IF SQLCA.sqlcode THEN
         CALL cl_err('lock sfbi:',SQLCA.sqlcode,0)     # 資料被他人LOCK
         CLOSE i301sub_cl_ind 
         IF NOT p_inTransaction THEN ROLLBACK WORK END IF
         LET g_success='N'
         RETURN
      END IF   
    END IF
 
    IF s_industry('icd') THEN
       CALL i301sub_icd_undo_confirm(p_sfb01)
      IF g_success='N' THEN
         CLOSE i301sub_cl_ind
         IF NOT p_inTransaction THEN ROLLBACK WORK END IF
         RETURN
      END IF
   END IF

   LET l_cnt=0 
   SELECT COUNT(*) INTO l_cnt FROM sie_file WHERE sie05=p_sfb01
   IF l_cnt > 0 THEN
      UPDATE sfb_file SET sfb104='Y' WHERE sfb01=p_sfb01
   ELSE
      UPDATE sfb_file SET sfb104='N' WHERE sfb01=p_sfb01
   END IF
 
   IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
      LET g_success='N'
   END IF

   IF l_sfb.sfb04='2' OR   #已發放未列印
      l_sfb.sfb04='3' THEN #已發放已列印
      UPDATE sfb_file SET sfb04='1',sfb87='N',sfb43='0' WHERE sfb01=p_sfb01
   ELSE
     #str TQC-C60025 add
      IF s_industry('icd') AND l_sfb.sfb04='4' THEN
         UPDATE sfb_file SET sfb04='1',sfb87='N',sfb43='0' WHERE sfb01=p_sfb01
      ELSE
     #end TQC-C60025 add
         UPDATE sfb_file SET sfb87 = 'N',sfb43='0' WHERE sfb01=p_sfb01
      END IF   #TQC-C60025 add
   END IF
 
   IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
      LET g_success='N'
   END IF
 
   #第一站投入量[ecm301]改在工單確認還原時清為0
   #TQC-AC0077--begin--modify--------
   IF (g_sma.sma542='Y' AND l_sfb.sfb93='Y') OR
      (l_sfb.sfb93='Y' AND l_sfb.sfb39 = '2') THEN  #TQC-AC0142
      DECLARE i301_upd_ecm301_c2 CURSOR FOR
              SELECT DISTINCT ecm012 FROM ecm_file
               WHERE ecm01=l_sfb.sfb01
                 AND ecm301>0
      FOREACH i301_upd_ecm301_c2 INTO l_ecm012
         #若走平行工藝,須判斷如果本製程段無上製程段,
         LET l_cnt = 0   
        #FUN-B30017--begin--modify-----
        #CALL s_schdat_sel_ima571(l_sfb.sfb01) RETURNING l_flag,l_ima571  #MOD-AC0336
        #SELECT COUNT(*) INTO l_cnt FROM ecu_file
        # WHERE ecu01=l_ima571  #MOD-AC0336
        #   AND ecu02=l_sfb.sfb06
        #   AND ecu015=l_ecm012
         SELECT COUNT(*) INTO l_cnt FROM ecm_file
          WHERE ecm01=l_sfb.sfb01
            AND ecm015=l_ecm012 
        #FUN-B30017--end--modify---------
         IF l_cnt > 0 THEN
            CONTINUE FOREACH
         END IF

         LET l_ecm03=NULL
         SELECT MIN(ecm03) INTO l_ecm03 FROM ecm_file
                                       WHERE ecm01=l_sfb.sfb01
                                         AND ecm012=l_ecm012
         IF l_ecm03 IS NOT NULL THEN
            UPDATE ecm_file SET ecm301=0
             WHERE ecm01=p_sfb01
               AND ecm012=l_ecm012
               AND ecm03=l_ecm03
            IF STATUS THEN
               CALL cl_err3("upd","ecm_file",p_sfb01,l_ecm03,STATUS,"","upd ecm301",1)  
               LET g_success='N' 
            END IF
         END IF
      END FOREACH
   END IF
  #IF l_sfb.sfb93='Y' THEN
  #   LET l_ecm03=0
  #   SELECT MIN(ecm03) INTO l_ecm03
  #     FROM ecm_file
  #    WHERE ecm01=p_sfb01
  #   IF STATUS THEN LET l_ecm03=0 END IF
 
  #   UPDATE ecm_file SET ecm301=0
  #    WHERE ecm01=p_sfb01
  #      AND ecm03=l_ecm03
  #     IF STATUS THEN
  #         CALL cl_err3("upd","ecm_file",p_sfb01,l_ecm03,STATUS,"","upd ecm301",1)  
  #         LET g_success='N' 
  #   END IF
  #END IF
  #TQC-AC0077--end-modify-------

   IF g_success='Y' THEN                                      #FUN-9A0095 add 
     IF l_sfb.sfb02 MATCHES '[78]' AND l_sfb.sfb100='1' THEN 
        #DELETE FROM i301sub_tmp  #CHI-D40024
        CALL g_pmm_tmp.clear()  #CHI-D40024
        LET g_tmp_idx = 0  #CHI-D40024
        DECLARE upd_pmn1_cs CURSOR FOR
         SELECT pmn01,pmn02 FROM pmn_file WHERE pmn41=p_sfb01
        FOREACH upd_pmn1_cs INTO l_pmn01,l_pmn02
           SELECT pmm18 INTO l_pmm18 FROM pmm_file   #NO:6961
            WHERE pmm01=l_pmn01
           IF l_pmm18='X' THEN
               CONTINUE FOREACH
           END IF
          UPDATE pmm_file SET pmm25='0',pmm18='N'
           WHERE pmm01=l_pmn01
             AND pmm18<>'X'  
          IF STATUS OR SQLCA.sqlerrd[3] =0 THEN
             CALL cl_err3("upd","pmm_file",l_pmn01,"",STATUS,"","",1)  
             LET g_success='N' EXIT FOREACH 
          END IF
          #CHI-D40024---begin
          #LET l_cnt=0
          #SELECT * INTO l_cnt FROM i301sub_tmp WHERE pmm01 = l_pmn01
          #IF l_cnt = 0 THEN
          #   INSERT INTO i301sub_tmp VALUES(l_pmn01)
          #END IF
          LET l_chk = 'N'
          FOR l_i = 1 TO g_tmp_idx
             IF g_pmm_tmp[l_i].pmm01 = l_pmn01 THEN
                LET l_chk = 'Y'
                EXIT FOR 
             END IF 
          END FOR 
          IF l_chk = 'N' THEN
             LET g_tmp_idx = g_tmp_idx + 1
             LET g_pmm_tmp[g_tmp_idx].pmm01 = l_pmn01
          END IF 
          #CHI-D40024---end
          
          UPDATE pmn_file SET pmn16='0' WHERE pmn01=l_pmn01
             LET g_success='N' EXIT FOREACH 
        END FOREACH
        CALL i301sub_firm2_other(p_sfb01)
     ELSE
        LET l_cnt = 0
        SELECT COUNT(*) INTO l_cnt FROM pmn_file,pmm_file    #6961
         WHERE pmn41=p_sfb01
           AND pmm01=pmn01
           AND pmm18<>'X'         #作廢除外
         IF l_cnt >0 THEN
            CALL cl_err(p_sfb01,'asf-934',0) LET g_success='N'
         ELSE
            UPDATE sfb_file SET sfb87 = 'N' WHERE sfb01=p_sfb01
            IF STATUS OR SQLCA.sqlerrd[3] =0 THEN
               CALL cl_err3("upd","sfb_file",p_sfb01,"",STATUS,"","",1)  
               LET g_success='N'
            END IF
         END IF
     END IF
   END IF                                                                      #FUN-9A0095 add

  #FUN-9A0095 add begin -------------
  IF g_success = 'Y' AND g_aza.aza90 MATCHES "[Yy]" THEN
    # CALL aws_mescli()
    # 傳入參數: (1)程式代號
    #           (2)功能選項：insert(新增),update(修改),delete(刪除
    #           (3)Key
    # 新增工單
    IF l_sfb.sfb02 = '1' OR l_sfb.sfb02 = '5' OR l_sfb.sfb02 = '13' THEN       #FUN-CC0122 add l_sfb.sfb02 = '5'
       CASE aws_mescli('asfi301','delete',l_sfb.sfb01)
          WHEN 1  #呼叫 MES 成功
                #MESSAGE 'UNDOCONFIRM O.K, DELETE MES O.K'         #FUN-C10035 mark
                 CALL cl_msg("UNDOCONFIRM O.K, DELETE MES O.K")    #FUN-C10035 add
          WHEN 2  #呼叫 MES 失敗
                LET g_success = 'N'
          OTHERWISE  #其他異常
                LET g_success = 'N'
       END CASE
    END IF
  END IF
  #FUN-9A0095 add end ----------------

   IF s_industry('icd') THEN
      #取消確認時要將datecode(sfbiicd07)清空
      LET l_sfbi.sfbiicd07 = NULL
      UPDATE sfbi_file SET sfbiicd07 = l_sfbi.sfbiicd07 WHERE sfbi01=p_sfb01
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] =0 THEN
         CALL cl_err('update datecode to null',SQLCA.sqlcode,0) LET g_success='N'
      END IF
   END IF
   
   #FUN-B20070--begin--add------
   #工單間合拼，工單確認還原後，工單備料和製程追蹤重新產生
   LET l_cnt=0   #MOD-B30414
   SELECT COUNT(*) INTO l_cnt FROM sfd_file WHERE sfd01=l_sfb.sfb85 AND sfd03=l_sfb.sfb01 AND (sfd07 IS NOT NULL AND sfd07<>' ') #MOD-B30414
   IF NOT cl_null(l_sfb.sfb85) AND l_cnt > 0 AND g_success = 'Y' THEN  #MOD-B30414
      IF NOT cl_null(l_sfb.sfb06) THEN
         DELETE FROM ecm_file WHERE ecm01=l_sfb.sfb01
         IF SQLCA.sqlcode THEN LET g_success='N' CALL cl_err('del ecm',SQLCA.sqlcode,1)  END IF
         #TQC-B70086 add str----
         IF NOT cl_null(g_sma.sma901) and  (g_sma.sma901='Y') THEN
            DELETE FROM vmn_file WHERE vmn02=l_sfb.sfb01 
            IF SQLCA.sqlcode THEN LET g_success='N' CALL cl_err('del vmn',SQLCA.sqlcode,1)  END IF
            DELETE FROM vnm_file WHERE vnm01=l_sfb.sfb01
            IF SQLCA.sqlcode THEN LET g_success='N' CALL cl_err('del vnm',SQLCA.sqlcode,1)  END IF
         END IF
         #TQC-B70086 add end----
         CALL s_schdat(0,l_sfb.sfb13,l_sfb.sfb15,l_sfb.sfb071,l_sfb.sfb01,  
                       l_sfb.sfb06,l_sfb.sfb02,l_sfb.sfb05,l_sfb.sfb08,2)
         RETURNING l_cnt,l_sfb.sfb13,l_sfb.sfb15,l_sfb.sfb32,l_sfb.sfb24
         LET l_cnt=0
         SELECT count(*) INTO l_cnt FROM ecm_file WHERE ecm01 = l_sfb.sfb01                                                       
         IF l_cnt > 0 THEN LET l_sfb.sfb24 = 'Y' ELSE LET l_sfb.sfb24 = 'N' END IF  
         LET l_cnt=0                                                    
         SELECT count(*) INTO l_cnt FROM sfb_file                                                                                      
          WHERE sfb01=l_sfb.sfb01                                                                                                      
            AND (sfb13 IS NOT NULL AND sfb15 IS NOT NULL )                                                                             
         IF l_cnt > 0 THEN                                                                                                             
            UPDATE sfb_file SET sfb24=l_sfb.sfb24 WHERE sfb01=l_sfb.sfb01                                                                                                                                     
         ELSE                                                                                                                          
            UPDATE sfb_file SET sfb13=l_sfb.sfb13,                                                                                     
                                sfb15=l_sfb.sfb15,                                                                                     
                                sfb24=l_sfb.sfb24                                                                                      
             WHERE sfb01=l_sfb.sfb01                                                                                                   
         END IF
      END IF
      DELETE FROM sfa_file WHERE sfa01=l_sfb.sfb01
      IF SQLCA.sqlcode THEN LET g_success='N' CALL cl_err('del sfa',SQLCA.sqlcode,1) END IF
      CALL s_minopseq(l_sfb.sfb05,l_sfb.sfb06,l_sfb.sfb071) RETURNING l_minopseq                                                       
                                                                                                                                    
      CASE                                                                                                                             
        WHEN l_sfb.sfb02='13'     #預測工單展至尾階                                                                                   
             CALL s_cralc2(l_sfb.sfb01,l_sfb.sfb02,l_sfb.sfb05,'Y',                                                                   
                           l_sfb.sfb08,l_sfb.sfb071,'Y',g_sma.sma71,l_minopseq,                                                       
                           ' 1=1',l_sfb.sfb95)                                                                        
             RETURNING l_cnt                                                                                                          
        WHEN l_sfb.sfb02='15'     #試產性工單                                                                                         
             CALL s_cralc3(l_sfb.sfb01,l_sfb.sfb02,l_sfb.sfb05,'Y',                                                                   
                           l_sfb.sfb08,l_sfb.sfb071,'Y',g_sma.sma71,                                                                  
                           l_sfb.sfb07,g_sma.sma883,l_sfb.sfb95)                                                      
             RETURNING l_cnt                                                                                                          
        OTHERWISE                 #一般工單展單階                                                                                     
             IF l_sfb.sfb02 = 11 THEN                                                                                                  
                LET l_btflg = 'N'                                                                                                      
             ELSE                                                                                                                      
                LET l_btflg = 'Y'                                                                                                      
             END IF
             CALL s_cralc(l_sfb.sfb01,l_sfb.sfb02,l_sfb.sfb05,l_btflg,
                         #l_sfb.sfb08,l_sfb.sfb071,'Y',g_sma.sma71,l_minopseq,l_sfb.sfb95)
                          l_sfb.sfb08,l_sfb.sfb071,'Y',g_sma.sma71,l_minopseq,'',l_sfb.sfb95)      #FUN-BC0008 mod
             RETURNING l_cnt
       END CASE
   END IF
   #FUN-B20070--end--add---------

   #DEV-D40015--add--begin
   #自動作廢barcode
   IF g_success='Y' AND g_aza.aza131 = 'Y' THEN
      CALL i301sub_barcode_z(l_sfb.sfb01)
   END IF
   #DEV-D40015--add--end 

   IF g_success='Y' THEN
      IF NOT p_inTransaction THEN COMMIT WORK END IF
   ELSE
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF
   END IF
   CLOSE i301sub_cl
   IF NOT s_industry('std') THEN
      CLOSE i301sub_cl_ind
   END IF

END FUNCTION

#FUNCTION i301sub_x(p_sfb01,p_inTransaction,p_ask_post)       #CHI-D20010
FUNCTION i301sub_x(p_sfb01,p_inTransaction,p_ask_post,p_type) #CHI-D20010
   DEFINE l_oeaconf LIKE oea_file.oeaconf
   DEFINE l_pmm18   LIKE pmm_file.pmm18
   DEFINE l_pmm01   LIKE pmm_file.pmm01
   DEFINE l_cnt     LIKE type_file.num5
   DEFINE p_sfb01   LIKE sfb_file.sfb01
   DEFINE l_sfb     RECORD LIKE sfb_file.*
   DEFINE l_sfbi    RECORD LIKE sfbi_file.*
   DEFINE p_inTransaction LIKE type_file.num5 
   DEFINE p_ask_post      LIKE type_file.chr1
   DEFINE l_chr           LIKE sfb_file.sfb87
  #MOD-B30473---add---start---
   DEFINE l_oeb12   LIKE oeb_file.oeb12
   DEFINE l_oeb05   LIKE oeb_file.oeb05
   DEFINE l_ima55   LIKE ima_file.ima55
   DEFINE l_ima562  LIKE ima_file.ima562
   DEFINE l_factor  LIKE ima_file.ima31_fac
   DEFINE l_sfb08   LIKE sfb_file.sfb08
  #MOD-B30473---add---end---
   DEFINE l_flag    LIKE type_file.chr1  #CHI-D20010
   DEFINE p_type    LIKE type_file.chr1  #CHI-D20010
#str----add by guanyao160505
DEFINE l_sfb22     LIKE sfb_file.sfb22
DEFINE l_sfb221    LIKE sfb_file.sfb221
DEFINE l_sfb08_1     LIKE sfb_file.sfb08
DEFINE l_oea00     LIKE oea_file.oea00
#end----add by guanyao160505
#str----add by guanyao160612
    DEFINE l_ima55_fac_1  LIKE ima_file.ima55_fac
    DEFINE l_ima562_1     LIKE ima_file.ima562
#end----add by guanyao160612
#add by hehw 210305 ---s
DEFINE lh_sfb87        LIKE sfb_file.sfb87
DEFINE lh_oebud07      LIKE oeb_file.oebud07
DEFINE lh_oeb12        LIKE oeb_file.oeb12
#add by hehw 210305 ---e
DEFINE l_oeb12_d          LIKE oeb_file.oeb12  #add by darcy 2022年3月11日
   
   LET g_success = 'Y'
   IF s_shut(0) THEN LET g_success='N' RETURN END IF
 
   SELECT * INTO l_sfb.* FROM sfb_file WHERE sfb01 = p_sfb01
   IF cl_null(l_sfb.sfb01) THEN CALL cl_err('',-400,0) LET g_success='N' RETURN END IF 
 
  #-->確認不可作廢
   IF l_sfb.sfb87 = 'Y' THEN 
      CALL cl_err('',9023,0) 
      LET g_success='N'
      RETURN 
   END IF
 
   IF l_sfb.sfb43 MATCHES '[S1]' THEN
      CALL cl_err('','mfg3557',0)
      LET g_success='N'
      RETURN
   END IF
 
   IF NOT p_inTransaction THEN
      BEGIN WORK
   END IF
 
   CALL i301sub_lock_cl()
   OPEN i301sub_cl USING p_sfb01
   IF STATUS THEN
      CALL cl_err("OPEN i301sub_cl:", STATUS, 1)
      CLOSE i301sub_cl
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF
      LET g_success='N'
      RETURN
   END IF
 
   FETCH i301sub_cl INTO l_sfb.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(p_sfb01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE i301sub_cl LET g_success='N' 
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF
      LET g_success='N'
      RETURN
   END IF
 
   IF cl_null(p_sfb01) THEN CALL cl_err('',-400,0) RETURN END IF
   IF (l_sfb.sfb02=7 OR l_sfb.sfb02=8 ) AND l_sfb.sfb100='1' THEN 
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM pmn_file,pmm_file
       WHERE pmn41=p_sfb01
         AND pmm01=pmn01
         AND pmm25='1'         #有確認的採購單不能作廢
      IF l_cnt >0 THEN
         CALL cl_err(p_sfb01,'asf-935',0) 
         LET g_success='N' 
         CLOSE i301sub_cl 
         IF NOT p_inTransaction THEN ROLLBACK WORK END IF
         RETURN
      END IF
   END IF
 
   IF s_industry('icd') THEN
      CALL i301sub_icd_undo_confirm(p_sfb01)
      IF g_success='N' THEN
         CLOSE i301sub_cl
         IF NOT p_inTransaction THEN ROLLBACK WORK END IF
         RETURN
      END IF
   END IF

   #CHI-D20010---begin
   IF p_type = 1 THEN
      IF l_sfb.sfb87 ='X' THEN RETURN END IF
   ELSE
      IF l_sfb.sfb87 <>'X' THEN RETURN END IF
   END IF
   #CHI-D20010---end

   IF l_sfb.sfb87 = 'X' THEN  LET l_flag = 'X' ELSE LET l_flag = 'N' END IF #CHI-D20010
   
   IF p_ask_post = 'Y' THEN
     #IF NOT cl_void(0,0,l_sfb.sfb87) THEN LET g_success='N' RETURN END IF
      IF NOT cl_void(0,0,l_flag) THEN LET g_success='N' RETURN END IF  #CHI-D20010
   END IF
  #str TQC-C60019 add
   IF s_industry('icd') THEN
      #ICD行業別時,工單刪除與作廢均應做刻號/BIN資料的刪除
      IF NOT i301sub_del_idb(p_sfb01,'','','','','','','1') THEN
         LET g_success='N'
         RETURN
      END IF
   END IF
  #end TQC-C60019 add
   IF NOT i301sub_chk_rela(p_sfb01,l_sfb.sfb86) THEN  
      LET g_success='N' 
      CLOSE i301sub_cl
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF
      RETURN 
   END IF
   LET l_chr=l_sfb.sfb87
  #IF l_sfb.sfb87 ='N' THEN #CHI-D20010
   IF p_type = 1 THEN     #CHI-D20010
      LET l_sfb.sfb87='X'  
      LET l_sfb.sfb43 = '9' 
#str-----add by guanyao160505
      LET l_sfb22 = ''
      LET l_sfb221=''
      LET l_oea00 = ''
      SELECT sfb22,sfb221 INTO l_sfb22,l_sfb221 FROM sfb_file WHERE sfb01 = p_sfb01
      IF NOT cl_null(l_sfb22) AND NOT cl_null(l_sfb221) THEN 
         SELECT oea00 INTO l_oea00 FROM oea_file WHERE oea01 = l_sfb22
         IF l_oea00 = '0'  THEN 
            #str----add by guanyao160612
            LET l_ima562_1 = 0
            LET l_ima55_fac_1=0
            SELECT ima55_fac,((ima562+100)/100) INTO l_ima55_fac_1,l_ima562_1 FROM ima_file WHERE ima01 = l_sfb.sfb05
            IF cl_null(l_ima55_fac_1) OR l_ima55_fac_1 = 0 THEN 
               LET l_ima55_fac_1 = 1
            END IF
            IF cl_null(l_ima562_1) THEN 
               LET l_ima562_1 = 1
            END IF 
            LET l_sfb08_1 = l_sfb.sfb08*l_ima55_fac_1/l_ima562_1
            #end----add by guanyao160612
	    #darcy: mark 220411 s--- 
            #add by darcy2022-03-11 14:04:40 s---
            #SELECT oeb12 INTO l_oeb12_d FROM oeb_file WHERE oeb01 = l_sfb22 AND oeb03 = l_sfb221
            #LET l_sfb08_1 = IIF(l_sfb08_1>l_oeb12_d,l_oeb12_d,l_sfb08_1)
            #add by darcy2022-03-11 14:04:40 e---
            #UPDATE oeb_file SET oebud07 = (oebud07 -l_sfb08_1),
            #                    oebud09 = nvl(oebud09+l_sfb08_1,l_sfb08_1)  #add by guanyao160614
            # WHERE oeb01 = l_sfb22
            #   AND oeb03 = l_sfb221
            #IF SQLCA.SQLCODE THEN
            #   CALL cl_err3("upd","sfb_file",g_sfb.sfb01,"",SQLCA.sqlcode,"","update sfb",1)  
            #   LET g_success = 'N'
            #   RETURN 
            #END IF
	    #darcy: 220411 mark e--- 
         END IF 
      END IF 
#end-----add by guanyao160505
   ELSE
      SELECT oeaconf INTO l_oeaconf FROM oea_file
       WHERE oea01 = l_sfb.sfb22
      IF l_oeaconf !='Y' THEN
         #S/O:資料來源訂單未確認,不能將此張作廢的工單"取消作廢!
          CALL cl_err(l_sfb.sfb22,'asf-010',0)
          LET g_success='N' 
          CLOSE i301sub_cl
          IF NOT p_inTransaction THEN ROLLBACK WORK END IF
          RETURN
      END IF
     #MOD-B30473---add---start---
      IF NOT cl_null(l_sfb.sfb22) AND NOT cl_null(l_sfb.sfb221) THEN
         SELECT (oeb12-oeb905),oeb05 INTO l_oeb12,l_oeb05 FROM oeb_file
          WHERE oeb01 = l_sfb.sfb22 AND oeb03 = l_sfb.sfb221
         SELECT ima55,((100+ima562)/100) INTO l_ima55,l_ima562 FROM ima_file WHERE ima01 = l_sfb.sfb05
         LET l_cnt = 0
         LET l_factor = 1
         CALL s_umfchk(l_sfb.sfb05,l_oeb05,l_ima55) RETURNING l_cnt,l_factor
         IF l_cnt = 1 THEN LET l_factor=1 END IF
         IF cl_null(l_ima562) THEN LET l_ima562 = 1 END IF   
         LET l_oeb12 = l_oeb12 * l_factor * l_ima562
         SELECT SUM(sfb08) INTO l_sfb08 FROM sfb_file
          WHERE sfb22 = l_sfb.sfb22 AND sfb221 = l_sfb.sfb221
            AND sfb01 != l_sfb.sfb01
         IF (l_sfb08 + l_sfb.sfb08) > l_oeb12 THEN
            CALL cl_err('','asf-005',1)
            LET g_success = 'N'
            CLOSE i301sub_cl
            ROLLBACK WORK
            RETURN
         END IF
      END IF
     #MOD-B30473---add---end---
     #MOD-CB0227---add---S
      LET l_cnt=0 
      IF g_sma.sma542 = 'Y' AND l_sfb.sfb93='Y' THEN
         SELECT COUNT(*) INTO l_cnt FROM bra_file
          WHERE bra01=l_sfb.sfb05
            AND bra06=l_sfb.sfb95
            AND bra05 IS NOT NULL AND bra05 <=l_sfb.sfb071
      ELSE
         SELECT COUNT(*) INTO l_cnt FROM bma_file
          WHERE bma01=l_sfb.sfb05 
            AND bma06=l_sfb.sfb95
            AND bma05 IS NOT NULL AND bma05 <=l_sfb.sfb071
      END IF 
      IF l_cnt = 0 THEN
         IF NOT (l_sfb.sfb02='5' OR l_sfb.sfb02='8' OR l_sfb.sfb02='11') THEN
                 CALL cl_err(l_sfb.sfb05,'abm-005',1)
                 LET g_success = 'N'  
                 ROLLBACK WORK
                 RETURN 
         END IF 
      END IF 
     #MOD-CB0227---add---E
#str-----add by guanyao160505
      LET l_sfb22 = ''
      LET l_sfb221=''
      LET l_sfb08_1 = 0 
      LET l_oea00 = ''
      SELECT sfb22,sfb221 INTO l_sfb22,l_sfb221 FROM sfb_file WHERE sfb01 =p_sfb01
      IF NOT cl_null(l_sfb22) AND NOT cl_null(l_sfb221) THEN 
         SELECT oea00 INTO l_oea00 FROM oea_file WHERE oea01 = l_sfb22
         IF l_oea00 = '0'  THEN 
            #str----add by guanyao160612
            LET l_ima562_1 = 0
            LET l_ima55_fac_1=0
            SELECT ima55_fac,((ima562+100)/100) INTO l_ima55_fac_1,l_ima562_1 FROM ima_file WHERE ima01 = l_sfb.sfb05
            IF cl_null(l_ima55_fac_1) OR l_ima55_fac_1 = 0 THEN 
               LET l_ima55_fac_1 = 1
            END IF
            IF cl_null(l_ima562_1) THEN 
               LET l_ima562_1 = 1
            END IF 
            LET l_sfb08_1 = l_sfb.sfb08*l_ima55_fac_1/l_ima562_1
            #end----add by guanyao160612 
            #darcy: mark 220411 s---
	    #后面有更新，这里不更新oeb，会造成多次更新数量
            #add by darcy2022-03-11 14:04:40 s---
            #SELECT oeb12 INTO l_oeb12_d FROM oeb_file WHERE oeb01 = l_sfb22 AND oeb03 = l_sfb221
            #LET l_sfb08_1 = IIF(l_sfb08_1>l_oeb12_d,l_oeb12_d,l_sfb08_1)
            #add by darcy2022-03-11 14:04:40 e---
            #UPDATE oeb_file SET oebud07 = nvl((oebud07 +l_sfb08_1),l_sfb08_1),
            #                    oebud09 = nvl(oebud09-l_sfb08_1,-l_sfb08_1)   #add by guanyao160614
            # WHERE oeb01 = l_sfb22
            #   AND oeb03 = l_sfb221
            #IF SQLCA.SQLCODE THEN
            #   CALL cl_err3("upd","sfb_file",g_sfb.sfb01,"",SQLCA.sqlcode,"","update sfb",1)  
            #   LET g_success = 'N'
            #   RETURN 
            #END IF 
	    #darcy: mark 220411 e---
         END IF 
      END IF 
#end-----add by guanyao160505
      LET l_sfb.sfb87='N'
      LET l_sfb.sfb43 = '0' 
      END IF

      #add by hehw 210305 ---s
      LET lh_sfb87 = ' '
      SELECT sfb87 INTO lh_sfb87 FROM sfb_file WHERE sfb01 = p_sfb01 
      #add by hehw 210305 ---e 
      
      UPDATE sfb_file
         SET sfb87=l_sfb.sfb87,
             sfbmodu=g_user,
             sfbdate=g_today,
             sfb43=l_sfb.sfb43 
       WHERE sfb01  =p_sfb01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err3("upd","sfb_file",p_sfb01,"",SQLCA.sqlcode,"","",1) 
          LET l_sfb.sfb87=l_chr
          LET g_success='N'
      END IF

      #add by hehw 210305 ---s  #更新订单的oebud07
      IF lh_sfb87 = 'N' AND l_sfb.sfb87 = 'X' THEN   #作废
        IF NOT cl_null(l_sfb.sfb22) THEN
          
          LET l_ima562_1 = 0
          LET l_ima55_fac_1=0
          SELECT ima55_fac,((ima562+100)/100) INTO l_ima55_fac_1,l_ima562_1 
            FROM ima_file,sfb_file 
           WHERE ima01 = sfb05
             AND sfb01 = p_sfb01
          IF cl_null(l_ima55_fac_1) OR l_ima55_fac_1 = 0 THEN 
             LET l_ima55_fac_1 = 1
          END IF
          IF cl_null(l_ima562_1) THEN 
             LET l_ima562_1 = 1
          END IF 
          LET l_sfb08_1 = l_sfb.sfb08*l_ima55_fac_1/l_ima562_1

          #add by darcy2022-03-11 14:04:40 s---
          SELECT oeb12 INTO l_oeb12_d FROM oeb_file WHERE oeb01 = l_sfb22 AND oeb03 = l_sfb221
          LET l_sfb08_1 = IIF(l_sfb08_1>l_oeb12_d,l_oeb12_d,l_sfb08_1)
          #darcy:2022/05/13 s---
          #如果原工单数量小于工单数量,还原的时候,要还原原工单数量
          if l_sfb.sfbud08 < l_sfb08_1 then 
            let l_sfb08_1 = l_sfb.sfbud08
          end if
          #darcy:2022/05/13 e---
          #add by darcy2022-03-11 14:04:40 e---
          
          UPDATE oeb_file SET oebud07 = (oebud07 -l_sfb08_1),
                              oebud09 = nvl(oebud09+l_sfb08_1,l_sfb08_1)  
           WHERE oeb01 = l_sfb.sfb22
             AND oeb03 = l_sfb.sfb221
        END IF
      END IF
      IF lh_sfb87 = 'X' AND l_sfb.sfb87 = 'N' THEN   #取消作废
        IF NOT cl_null(l_sfb.sfb22) THEN
        
          LET l_ima562_1 = 0
          LET l_ima55_fac_1=0
          SELECT ima55_fac,((ima562+100)/100) INTO l_ima55_fac_1,l_ima562_1 
            FROM ima_file,sfb_file 
           WHERE ima01 = sfb05
             AND sfb01 = p_sfb01
          IF cl_null(l_ima55_fac_1) OR l_ima55_fac_1 = 0 THEN 
             LET l_ima55_fac_1 = 1
          END IF
          IF cl_null(l_ima562_1) THEN 
             LET l_ima562_1 = 1
          END IF 
          LET l_sfb08_1 = l_sfb.sfb08*l_ima55_fac_1/l_ima562_1
          #add by darcy2022-03-11 14:04:40 s---
          SELECT oeb12 INTO l_oeb12_d FROM oeb_file WHERE oeb01 = l_sfb22 AND oeb03 = l_sfb221
          LET l_sfb08_1 = IIF(l_sfb08_1>l_oeb12_d,l_oeb12_d,l_sfb08_1)
          #add by darcy2022-03-11 14:04:40 e---
          #darcy:2022/05/13 s---
          #如果原工单数量小于工单数量,还原的时候,要还原原工单数量
          if l_sfb.sfbud08 < l_sfb08_1 then 
            let l_sfb08_1 = l_sfb.sfbud08
          end if
          #darcy:2022/05/13 e---
          #UPDATE oeb_file SET oebud07 = (oebud07 +l_sfb08_1),                 #mark by hehw 210324
          #                    oebud09 = nvl(oebud09-l_sfb08_1,l_sfb08_1)      #mark by hehw 210324
          UPDATE oeb_file SET oebud07 = nvl((oebud07 + l_sfb08_1),l_sfb08_1),   #add by hehw 210324
                              oebud09 = nvl(oebud09 - l_sfb08_1,-l_sfb08_1)    #add by hehw 210324
           WHERE oeb01 = l_sfb.sfb22
             AND oeb03 = l_sfb.sfb221
        END IF
      END IF
      #add by hehw 210305 ---e
      
      IF (l_sfb.sfb02=7 OR l_sfb.sfb02=8) AND l_sfb.sfb100='1' THEN
         DECLARE i301sub_x_cs CURSOR FOR
          SELECT pmm01 FROM pmm_file,pmn_file
           WHERE pmn41=p_sfb01
             AND pmm01=pmn01
             AND (pmm18<>'Y' OR pmm25<>'2')
 
         FOREACH i301sub_x_cs INTO l_pmm01  #作廢委外採購單一併作廢,
             IF SQLCA.SQLCODE THEN       #若作廢還原,委外採購單不須還原
                CALL cl_err(l_sfb.sfb87,SQLCA.sqlcode,0)
                LET l_sfb.sfb87=l_chr
                LET g_success='N'
             END IF
             IF l_sfb.sfb87='X' THEN 
                LET l_pmm18='X'
                UPDATE pmm_file
                   SET pmm18=l_pmm18,
                       pmm25='9',
                       pmmmodu=g_user,
                       pmmdate=g_today
                 WHERE pmm01=l_pmm01
                 IF SQLCA.SQLCODE THEN
                    CALL cl_err3("upd","pmm_file",l_pmm01,"",SQLCA.sqlcode,"","",1) 
                    LET g_success='N'
                 END IF
                 UPDATE pmn_file SET pmn16='9'
                  WHERE pmn01 = l_pmm01
                 IF STATUS THEN
                    CALL cl_err3("upd","pmn_file",l_pmm01,"",STATUS,"","upd pmn16:",1) 
                    LET g_success='N' 
                 END IF
             END IF
         END FOREACH
      END IF
   CLOSE i301sub_cl
   #darcy:2023/05/15 add s---
   #还原atmt260 的tscud03
   update tsc_file set tscud03 = ''
    where tscud03 = p_sfb01
   if sqlca.sqlcode then
      let g_success = 'N'
      call cl_err('upd tsc',sqlca.sqlcode,1)
      rollback work
   end if
   #darcy:2023/05/15 add e---
   
   IF g_success= 'Y' THEN
     #FUN-9A0095 mark str--------------------------------------
     #IF g_aza.aza90 MATCHES "[Yy]" THEN 
     #   # 傳入參數: (1)程式代號
     #   #           (2)功能選項：insert(新增),update(修改),delete(刪除)
     #   #           (3)Key
     #   CASE aws_mescli('asfi301','delete',p_sfb01)
     #      WHEN 0  #無與 MES 整合
     #           MESSAGE 'INSERT O.K'
     #      WHEN 1  #呼叫 MES 成功
     #           MESSAGE 'INSERT O.K, INSERT MES O.K'
     #      WHEN 2  #呼叫 MES 失敗
     #           RETURN FALSE
     #   END CASE
     #END IF
     #FUN-9A0095 mark end--------------------------------------
 
      IF NOT p_inTransaction THEN COMMIT WORK END IF
      CALL cl_flow_notify(p_sfb01,'V')
   ELSE
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF
   END IF
END FUNCTION

FUNCTION i301sub_icd_undo_confirm(p_sfb01)
   DEFINE p_sfb01 LIKE sfb_file.sfb01
   DEFINE l_pmn01 LIKE pmn_file.pmn01
   DEFINE l_sfp01 LIKE sfp_file.sfp01
   DEFINE l_sfp06 LIKE sfp_file.sfp06
   DEFINE l_o_prog STRING
   
   LET g_success='Y'
   #將相關已存在已確認採購單,取消確認
   DECLARE i301sub_icd_upd_pmm1 CURSOR FOR
    SELECT DISTINCT pmm01 FROM pmm_file,pmn_file
     WHERE pmm01=pmn01
       AND pmm18='Y'
       AND pmm25<>'2'
       AND (pmn41=p_sfb01 OR pmm01=p_sfb01)
   FOREACH i301sub_icd_upd_pmm1 INTO l_pmn01
      IF cl_null(l_pmn01) THEN
         CONTINUE FOREACH
      END IF 
      CALL t540sub_z(l_pmn01,NULL,FALSE)
   END FOREACH
   
   IF g_success='N' THEN
      RETURN
   END IF
 
   LET g_success='Y'
   #將相關已存在未確認採購單,刪除
   DECLARE i301sub_icd_upd_pmm2 CURSOR FOR
    SELECT DISTINCT pmm01 FROM pmm_file,pmn_file
     WHERE pmm01=pmn01
       AND pmm18='N'
       AND (pmn41=p_sfb01 OR pmm01=p_sfb01)
   FOREACH i301sub_icd_upd_pmm2 INTO l_pmn01
      IF cl_null(l_pmn01) THEN
         CONTINUE FOREACH
      END IF 
      CALL t540sub_r(l_pmn01,NULL,FALSE)
   END FOREACH
 
   IF g_success='N' THEN
      RETURN
   END IF
   
   LET g_success='Y'
   #將相關已存在已過帳發料單,取消過帳
   DECLARE i301sub_icd_upd_sfp1 CURSOR FOR
    SELECT DISTINCT sfp01,sfp06 FROM sfp_file,sfe_file
     WHERE sfp01=sfe02
       AND sfp04='Y'
       AND sfe01=p_sfb01
   FOREACH i301sub_icd_upd_sfp1 INTO l_sfp01,l_sfp06
      IF cl_null(l_sfp01) THEN
         CONTINUE FOREACH
      END IF 
 
      LET l_o_prog = g_prog
      CASE l_sfp06
         WHEN "1" LET g_prog='asfi511'
         WHEN "2" LET g_prog='asfi512'
         WHEN "3" LET g_prog='asfi513'
         WHEN "4" LET g_prog='asfi514'
         WHEN "6" LET g_prog='asfi526'
         WHEN "7" LET g_prog='asfi527'
         WHEN "8" LET g_prog='asfi528'
         WHEN "9" LET g_prog='asfi529'
         WHEN "D" LET g_prog='asfi519'    #FUN-C70014 add
      END CASE
      
      IF g_success = "Y" THEN
         CALL i501sub_z('1',l_sfp01,NULL,FALSE)
      END IF
      LET g_prog = l_o_prog
 
   END FOREACH
 
   IF g_success='N' THEN
      RETURN
   END IF
 
   LET g_success='Y'
   #將相關已存在已確認發料單,取消確認
   DECLARE i301sub_icd_upd_sfp2 CURSOR FOR
    SELECT DISTINCT sfp01,sfp06 FROM sfp_file,sfs_file
     WHERE sfp01=sfs01
       AND sfpconf='Y'
       AND sfs03=p_sfb01
   FOREACH i301sub_icd_upd_sfp2 INTO l_sfp01,l_sfp06
      IF cl_null(l_sfp01) THEN
         CONTINUE FOREACH
      END IF 
      CALL i501sub_w(l_sfp01,NULL,FALSE)
   END FOREACH
   
   IF g_success='N' THEN
      RETURN
   END IF
 
   LET g_success='Y'
   #將相關已存在未確認發料單,作廢
   DECLARE i301sub_icd_upd_sfp3 CURSOR FOR
    SELECT DISTINCT sfp01,sfp06 FROM sfp_file,sfs_file
     WHERE sfp01=sfs01
       AND sfpconf='N'
       AND sfs03=p_sfb01
   FOREACH i301sub_icd_upd_sfp3 INTO l_sfp01,l_sfp06
      IF cl_null(l_sfp01) THEN
         CONTINUE FOREACH
      END IF 
      CALL i501sub_x(l_sfp01,NULL,FALSE,1)  #CHI-D20010 add'1'
   END FOREACH
 
END FUNCTION

#若為委外，多張工單對一張採購單，則每張工單也要一併做取消確認
FUNCTION i301sub_firm2_other(p_sfb01)
  DEFINE l_pmn01     LIKE pmn_file.pmn01
  DEFINE l_pmn41     LIKE pmn_file.pmn41
  DEFINE l_sfb       RECORD LIKE sfb_file.*
  DEFINE p_sfb01     LIKE sfb_file.sfb01
  DEFINE l_i         LIKE type_file.num5  #CHI-D40024
 
  #DECLARE i301sub_tmp1_cs CURSOR FOR SELECT * FROM i301sub_tmp  #CHI-D40024
  #FOREACH i301sub_tmp1_cs INTO l_pmn01  #CHI-D40024
  FOR l_i = 1 TO g_tmp_idx  #CHI-D40024
          DECLARE i301sub_pmn1_cs CURSOR FOR
           #SELECT pmn41 FROM pmn_file WHERE pmn01=l_pmn01 #CHI-D40024
           SELECT pmn41 FROM pmn_file WHERE pmn01=g_pmm_tmp[l_i].pmm01
          FOREACH i301sub_pmn1_cs INTO l_pmn41
               IF l_pmn41 = p_sfb01 THEN CONTINUE FOREACH END IF
               SELECT * INTO l_sfb.* FROM sfb_file WHERE sfb01=l_pmn41
               IF STATUS THEN
                  CALL cl_err3("sel","sfb_file",l_pmn41,"",STATUS,"","sel sfb(chk#1):",1)  
                  LET g_success='N'
                  EXIT FOREACH
               END IF
               IF l_sfb.sfb87 = 'N' THEN CONTINUE FOREACH END IF  #已取消確認
               IF l_sfb.sfb04 > '2' THEN
                  LET g_success='N'
                  CALL cl_err(l_sfb.sfb01,'asf-901',1) EXIT FOREACH
               END IF
               IF l_sfb.sfb04='2' THEN
                  UPDATE sfb_file SET sfb04='1',sfb87='N',sfb43='0'    
                   WHERE sfb01=l_sfb.sfb01
               ELSE
                  UPDATE sfb_file SET sfb87 = 'N',sfb43='0' WHERE sfb01=l_sfb.sfb01   
               END IF
               IF STATUS THEN
                  CALL cl_err('upd sfb(chk#2):',STATUS,1)
                  LET g_success='N'
                  EXIT FOREACH
               END IF
          END FOREACH
  #CHI-D40024---begin        
          #IF g_success='N' THEN EXIT FOREACH END IF
  #END FOREACH  
          IF g_success='N' THEN EXIT FOR END IF
  END FOR  
  #CHI-D40024---end
END FUNCTION

#FUNCTION i301sub_r1(p_sfb01,p_sfb86_cnt_n,p_sfb86_cnt_y)           #FUN-B30098
FUNCTION i301sub_r1(p_sfb01,p_sfb86_cnt_n,p_sfb86_cnt_y,p_sfb85)    #FUN-B30098
DEFINE l_sfb01    LIKE sfb_file.sfb01
DEFINE l_sfb01_a  LIKE sfb_file.sfb01
DEFINE l_n1,i,n   LIKE type_file.num5
DEFINE l_sfb96    LIKE sfb_file.sfb96
DEFINE p_sfb01    LIKE sfb_file.sfb01
DEFINE p_sfb86_cnt_n  LIKE type_file.num5
DEFINE p_sfb86_cnt_y  LIKE type_file.num5
DEFINE l_msg          LIKE type_file.chr1000
DEFINE l_sfd06        LIKE sfd_file.sfd06
DEFINE l_sfd01        DYNAMIC ARRAY OF LIKE sfd_file.sfd01
DEFINE l_sfd02        DYNAMIC ARRAY OF LIKE sfd_file.sfd02
DEFINE p_sfb85        LIKE sfb_file.sfb85   #FUN-B30098 
DEFINE l_cnt1         LIKE type_file.num5   #FUN-B30098
DEFINE l_cnt          LIKE type_file.num5   #FUN-B70008 add
#str----add by guanyao160505
DEFINE l_sfb22     LIKE sfb_file.sfb22
DEFINE l_sfb221    LIKE sfb_file.sfb221
DEFINE l_sfb08     LIKE sfb_file.sfb08
DEFINE l_oea00     LIKE oea_file.oea00
#end----add by guanyao160505
#str----add by guanyao160612
DEFINE l_sfb08_1      LIKE sfb_file.sfb08
DEFINE l_ima55_fac_1  LIKE ima_file.ima55_fac
DEFINE l_ima562_1     LIKE ima_file.ima562
#end----add by guanyao160612
DEFINE l_oeb12_d      LIKE oeb_file.oeb12 #add by darcy 220311

  #FUN-B70008---add----str---
   #SELECT sfb222 INTO g_sfb.sfb222  #darcy:2022/05/13 mark
   SELECT sfb222,sfbud08 INTO g_sfb.sfb222,g_sfb.sfbud08  #darcy:2022/05/13 add
     FROM sfb_file
    WHERE sfb01 = p_sfb01

   IF NOT cl_null(g_sfb.sfb222) THEN
       LET l_cnt = 0
       SELECT COUNT(*) INTO l_cnt
         FROM vod_file
        WHERE vod38 = p_sfb01
          AND vod03 = g_sfb.sfb222
       IF l_cnt > = 1 THEN
           UPDATE vod_file
              SET vod37 = 'N',
                  vod38 = ''
            WHERE vod38 = p_sfb01
              AND vod03 = g_sfb.sfb222
           IF STATUS THEN
                CALL cl_err3("UPDATE","vod_file",p_sfb01,"",STATUS,"","upd vod",1)
                ROLLBACK WORK RETURN
           END IF
       END IF
   END IF
  #FUN-B70008---add----end---
  #str-----add by guanyao160505
    LET l_sfb22 = ''
    LET l_sfb221=''
    LET l_sfb08 = 0 
    LET l_oea00 = ''
    SELECT sfb22,sfb221,sfb08 INTO l_sfb22,l_sfb221,l_sfb08 FROM sfb_file WHERE sfb01 = p_sfb01
    IF NOT cl_null(l_sfb22) AND NOT cl_null(l_sfb221) THEN 
       SELECT oea00 INTO l_oea00 FROM oea_file WHERE oea01 = l_sfb22
       IF l_oea00 = '0'  OR l_oea00 = '1' THEN     #add by hehw 210305 ---oea00 = 1
          #str----add by guanyao160612
          LET l_ima562_1 = 0
          LET l_ima55_fac_1=0
          SELECT ima55_fac,((ima562+100)/100) INTO l_ima55_fac_1,l_ima562_1 
            FROM ima_file,sfb_file 
           WHERE ima01 = sfb05
             AND sfb01 = p_sfb01
          IF cl_null(l_ima55_fac_1) OR l_ima55_fac_1 = 0 THEN 
             LET l_ima55_fac_1 = 1
          END IF
          IF cl_null(l_ima562_1) THEN 
             LET l_ima562_1 = 1
          END IF 
          LET l_sfb08_1 = l_sfb08*l_ima55_fac_1/l_ima562_1
          #end----add by guanyao160612 
          #add by darcy2022-03-11 14:04:40 s---
          SELECT oeb12 INTO l_oeb12_d FROM oeb_file WHERE oeb01 = l_sfb22 AND oeb03 = l_sfb221
          LET l_sfb08_1 = IIF(l_sfb08_1>l_oeb12_d,l_oeb12_d,l_sfb08_1)
          #add by darcy2022-03-11 14:04:40 e---
          #darcy:2022/05/13 s---
          #已工单原数量为主
          if l_sfb08_1 > g_sfb.sfbud08 then
            let l_sfb08_1 = g_sfb.sfbud08
          end if
          #darcy:2022/05/13 e---
          UPDATE oeb_file SET oebud07 = (oebud07 -l_sfb08_1),
                              oebud09 = nvl(oebud09+l_sfb08_1,l_sfb08_1)   #add by guanyao160614
           WHERE oeb01 = l_sfb22
             AND oeb03 = l_sfb221
          IF SQLCA.SQLCODE THEN
             CALL cl_err3("upd","sfb_file",g_sfb.sfb01,"",SQLCA.sqlcode,"","update sfb",1)  
             LET g_success = 'N'
             RETURN 
          END IF 
       END IF 
    END IF 
#end-----add by guanyao160505

   DELETE FROM sfb_file WHERE sfb01 = p_sfb01
   IF SQLCA.SQLERRD[3]=0 THEN 
      CALL cl_err3("del","sfb_file",p_sfb01,"",SQLCA.sqlcode,"","No sfb deleted",1)  
      LET g_success='N'
      RETURN 
  #FUN-9A0095 mark str----------------------
  #ELSE
  #   IF g_aza.aza90 MATCHES "[Yy]" THEN   
  #      CASE aws_mescli('asfi301','delete',p_sfb01)
  #        WHEN 0  #無與 MES 整合
  #             MESSAGE 'INSERT O.K'
  #        WHEN 1  #呼叫 MES 成功
  #             MESSAGE 'INSERT O.K, INSERT MES O.K'
  #        WHEN 2  #呼叫 MES 失敗
  #             RETURN FALSE
  #       END CASE
  #   END IF 
  #FUN-9A0095 mark end----------------------
   END IF
 
   DELETE FROM vnf_file where vnf01=p_sfb01
   DELETE FROM vmw_file where vmw01=p_sfb01
   #與APS連結時,需同時刪除vmn_file
   IF NOT cl_null(g_sma.sma901) AND (g_sma.sma901='Y') THEN
      DELETE FROM vmn_file
       WHERE vmn02 = p_sfb01
      #與APS串連時,需一併刪除平行加工資料vlj_file
      DELETE FROM vlj_file
       WHERE vlj01 = p_sfb01
      #與APS串連時,需一併刪除vnd_file,vne_file,vng_file,vnm_file
      DELETE FROM vnd_file
       WHERE vnd01 = p_sfb01
      DELETE FROM vne_file
       WHERE vne01 = p_sfb01
      DELETE FROM vng_file
       WHERE vng01 = p_sfb01
      DELETE FROM vnm_file
       WHERE vnm01 = p_sfb01
   END IF
 
   IF NOT s_industry('std') THEN
      IF NOT s_del_sfbi(p_sfb01,'') THEN
         LET g_success='N'
         RETURN
      END IF
   END IF
 
   DELETE FROM sfa_file WHERE sfa01 = p_sfb01
   IF STATUS THEN
      CALL cl_err3("del","sfa_file",p_sfb01,"",STATUS,"","del sfa",1) 
      LET g_success='N'
      RETURN
   END IF
   IF NOT s_industry('std') THEN
      IF NOT s_del_sfai(p_sfb01,'','','','','','','') THEN 
         LET g_success='N'
         RETURN
      END IF
   END IF

   #FUN-C30274 --START--
   IF s_industry('icd') THEN
      DELETE FROM sfaa_file WHERE sfaa01 = p_sfb01
      IF STATUS THEN
         CALL cl_err3("del","sfaa_file",p_sfb01,"",STATUS,"","del sfaa",1) 
         LET g_success='N'
         RETURN
      END IF
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt
       FROM idb_file WHERE idb07 = p_sfb01          
      IF l_cnt > = 1 THEN
         IF NOT s_icdinout_del(-1,p_sfb01,'','') THEN 
            LET g_success='N'
            RETURN
         END IF
      END IF    
   END IF
   #FUN-C30274 --END--
 
   DELETE FROM ecm_file WHERE ecm01 = p_sfb01
   IF STATUS THEN
      CALL cl_err3("del","ecm_file",p_sfb01,"",STATUS,"","del ecm",1) 
      LET g_success='N'
      RETURN
   END IF
 
   DECLARE edg_cus CURSOR FOR
     SELECT sfd01,sfd02 FROM sfd_file WHERE sfd03=p_sfb01 ORDER BY sfd01
   LET i=1
   FOREACH edg_cus INTO l_sfd01[i],l_sfd02[i]
     LET i=i+1
   END FOREACH

   DELETE FROM sfd_file WHERE sfd03 = p_sfb01
   IF STATUS THEN
      CALL cl_err3("del","sfd_file",p_sfb01,"",STATUS,"","del sfd",1) 
      LET g_success='N'
      RETURN
   END IF
#FUN-B30098 ------------------------Begin----------------------------------
   IF NOT cl_null(p_sfb85) THEN
      SELECT COUNT(*) INTO l_cnt1 FROM sfd_file
       WHERE sfd01 = p_sfb85
      IF l_cnt1 = 0 THEN
         DELETE FROM sfc_file WHERE sfc01 = p_sfb85
         IF STATUS THEN
            CALL cl_err3("del","sfc_file",p_sfb85,"",STATUS,"","del sfc",1)
            LET g_success='N'
            RETURN
         END IF
      END IF 
   END IF        
#FUN-B30098 ------------------------End------------------------------------


   FOR n=1 TO i-1
     DELETE FROM edg_file WHERE edg01=l_sfd01[n] AND edg02=l_sfd02[n]
     DELETE FROM edh_file WHERE edh01=l_sfd01[n] AND edh011=l_sfd02[n]
     IF STATUS THEN
        CALL cl_err3("del","edh_file",l_sfd01[n],"",STATUS,"","del edh",1) 
        LET g_success='N'
        RETURN
     END IF
     SELECT SUM(sfd05) INTO l_sfd06 FROM sfd_file WHERE sfd01=l_sfd01[n]
     UPDATE sfd_file SET sfd06=l_sfd06 WHERE sfd01=l_sfd01[n]
   END FOR
 
   DELETE FROM she_file WHERE she01 = p_sfb01
   IF STATUS THEN
      CALL cl_err3("del","she_file",p_sfb01,"",STATUS,"","del she",1) 
      LET g_success='N'
      RETURN
   END IF
#delete 備註檔
   DELETE FROM sfw_file WHERE sfw01 = p_sfb01
   IF STATUS THEN
      CALL cl_err3("del","sfw_file",p_sfb01,"",STATUS,"","del sfw",1) 
      LET g_success='N'
      RETURN
   END IF
 
   IF s_industry('icd') THEN
      DELETE FROM ico_file WHERE ico01 = p_sfb01
   END IF
#尚有未確認的子工單
   IF p_sfb86_cnt_n > 0 THEN
      FOREACH i301sub_r_cs INTO l_sfb01
        IF SQLCA.sqlcode THEN
           CALL cl_err('',SQLCA.sqlcode,0)
           LET g_success = 'N'
           EXIT FOREACH
        END IF
        IF NOT cl_confirm("asf-210") THEN EXIT FOREACH END IF 
        SELECT COUNT(*) INTO l_n1 FROM pmn_file                                   
         WHERE pmn41=l_sfb01
        IF l_n1 > 0 THEN CALL cl_err('','asf-119',0) EXIT FOREACH END IF
        MESSAGE "Delete sub WO !"
        #當有尚未確認的子工單時作廢
        UPDATE sfb_file SET sfb87 = 'X',
                            sfb43 = '9' 
         WHERE sfb01 = l_sfb01  
        IF SQLCA.sqlcode THEN
           CALL cl_err3("upd","sfb_file",l_sfb01,"",SQLCA.sqlcode,"","No sfb deleted_sub",1)  
           LET g_success = 'N'
        END IF
      END FOREACH
   END IF 
   IF p_sfb86_cnt_y > 0 THEN  #已子工單，要清空母工單單號,累加備注資料
         FOREACH i301sub_r_cs2 INTO l_sfb01_a
           IF SQLCA.sqlcode THEN
              CALL cl_err('',SQLCA.sqlcode,0)
              LET g_success = 'N'
              EXIT FOREACH
           END IF
           SELECT sfb96 INTO l_sfb96 FROM sfb_file WHERE sfb01 = l_sfb01_a
           IF NOT cl_null(l_sfb96) THEN
              LET l_sfb96 = l_sfb96 || ',' ||p_sfb01
           ELSE
              LET l_sfb96 = p_sfb01
           END IF
           UPDATE sfb_file SET sfb86 = '',
                               sfb96 = l_sfb96  
            WHERE sfb01 = l_sfb01_a
           IF STATUS THEN
              CALL cl_err3("upd","sfb_file",l_sfb01_a,"",STATUS,"","upd sfb_file",1)
              LET g_success = 'N'
           END IF
         END FOREACH
   END IF
   LET l_msg=TIME
   INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) 
          VALUES ('asfi301',g_user,g_today,l_msg,p_sfb01,'delete',g_plant,g_legal) 

END FUNCTION

#依照PBI單身的模數(sfd05)比例，檢查此PBI單的所有工單生產數量比例是否符合，若不符合的話修正,
#修正后重新產生備料及製程追蹤或Runcard製程追蹤
FUNCTION i301sub_sfb85(p_sfb85)
DEFINE l_minopseq   LIKE type_file.num5
DEFINE l_cnt,i      LIKE type_file.num5
DEFINE l_btflg      LIKE type_file.chr1
DEFINE l_sfb08      LIKE sfb_file.sfb08
DEFINE l_sfd05      LIKE sfd_file.sfd05
DEFINE l_sfb01      LIKE sfb_file.sfb01
DEFINE p_sfb85      LIKE sfb_file.sfb85
DEFINE l_sfb08_a,l_sfb08_b   LIKE sfb_file.sfb08
DEFINE l_sfd05_a,l_sfd05_b   LIKE sfd_file.sfd05
DEFINE l_qty        LIKE sfb_file.sfb08
DEFINE l_sfb        RECORD LIKE sfb_file.*

  DECLARE sfd05_curs CURSOR FOR
     SELECT sfb01,sfb08,sfd05,sfb08/sfd05 a FROM sfb_file,sfd_file
      WHERE sfd01=p_sfb85 AND sfd03=sfb01
        AND sfd05<>0
      ORDER BY a DESC
  LET i=1
  FOREACH sfd05_curs INTO l_sfb01,l_sfb08,l_sfd05,l_qty
    IF i > 1 THEN
       SELECT * INTO l_sfb.* FROM sfb_file WHERE sfb01=l_sfb01
       LET l_sfb08_b=l_sfb08_a/l_sfd05_a*l_sfd05
       IF l_sfb08_b <> l_sfb08 THEN
          IF NOT cl_confirm('asf-156') THEN LET g_success='N' RETURN END IF
          IF l_sfb08_b > s_trunc(l_sfb08_b,0) THEN
             LET l_sfb08_b=l_sfb08_b +1 
          END IF
          UPDATE sfb_file SET sfb08=l_sfb08_b WHERE sfb01=l_sfb.sfb01
          IF NOT cl_null(l_sfb.sfb06) THEN
             DELETE FROM ecm_file WHERE ecm01=l_sfb.sfb01
             IF SQLCA.sqlcode THEN LET g_success='N' CALL cl_err('del ecm',SQLCA.sqlcode,1) RETURN END IF
             CALL s_schdat(0,l_sfb.sfb13,l_sfb.sfb15,l_sfb.sfb071,l_sfb.sfb01,  
                    l_sfb.sfb06,l_sfb.sfb02,l_sfb.sfb05,l_sfb08_b,2)
             RETURNING l_cnt,l_sfb.sfb13,l_sfb.sfb15,l_sfb.sfb32,l_sfb.sfb24
             LET l_cnt=0
             SELECT count(*) INTO l_cnt FROM ecm_file WHERE ecm01 = l_sfb.sfb01                                                       
             IF l_cnt > 0 THEN LET l_sfb.sfb24 = 'Y' ELSE LET l_sfb.sfb24 = 'N' END IF  
             LET l_cnt=0                                                    
             SELECT count(*) INTO l_cnt FROM sfb_file                                                                                      
              WHERE sfb01=l_sfb.sfb01                                                                                                      
                AND (sfb13 IS NOT NULL AND sfb15 IS NOT NULL )                                                                             
             IF l_cnt > 0 THEN                                                                                                             
                UPDATE sfb_file SET sfb24=l_sfb.sfb24 WHERE sfb01=l_sfb.sfb01                                                                                                                                     
             ELSE                                                                                                                          
                UPDATE sfb_file SET sfb13=l_sfb.sfb13,                                                                                     
                                    sfb15=l_sfb.sfb15,                                                                                     
                                    sfb24=l_sfb.sfb24                                                                                      
                 WHERE sfb01=l_sfb.sfb01                                                                                                   
             END IF
          END IF
             DELETE FROM sfa_file WHERE sfa01=l_sfb.sfb01
             IF SQLCA.sqlcode THEN LET g_success='N' CALL cl_err('del sfa',SQLCA.sqlcode,1) RETURN END IF
             CALL s_minopseq(l_sfb.sfb05,l_sfb.sfb06,l_sfb.sfb071) RETURNING l_minopseq                                                       
                                                                                                                                    
             CASE                                                                                                                             
               WHEN l_sfb.sfb02='13'     #預測工單展至尾階                                                                                   
                    CALL s_cralc2(l_sfb.sfb01,l_sfb.sfb02,l_sfb.sfb05,'Y',                                                                   
                                  l_sfb08_b,l_sfb.sfb071,'Y',g_sma.sma71,l_minopseq,                                                       
                                  ' 1=1',l_sfb.sfb95)                                                                        
                    RETURNING l_cnt                                                                                                          
               WHEN l_sfb.sfb02='15'     #試產性工單                                                                                         
                    CALL s_cralc3(l_sfb.sfb01,l_sfb.sfb02,l_sfb.sfb05,'Y',                                                                   
                                 l_sfb08_b,l_sfb.sfb071,'Y',g_sma.sma71,                                                                  
                                 l_sfb.sfb07,g_sma.sma883,l_sfb.sfb95)                                                      
                    RETURNING l_cnt                                                                                                          
             OTHERWISE                 #一般工單展單階                                                                                     
                IF l_sfb.sfb02 = 11 THEN                                                                                                  
                   LET l_btflg = 'N'                                                                                                      
                ELSE                                                                                                                      
                   LET l_btflg = 'Y'                                                                                                      
                END IF
                CALL s_cralc(l_sfb.sfb01,l_sfb.sfb02,l_sfb.sfb05,l_btflg,                                                                 
                          #l_sfb08_b,l_sfb.sfb071,'Y',g_sma.sma71,l_minopseq,l_sfb.sfb95)                             
                           l_sfb08_b,l_sfb.sfb071,'Y',g_sma.sma71,l_minopseq,'',l_sfb.sfb95)     #FUN-BC0008 mod
                RETURNING l_cnt
             END CASE
       END IF
    ELSE
       LET l_sfb08_a=l_sfb08
       LET l_sfd05_a=l_sfd05
    END IF
    LET i=i+1
  END FOREACH
END FUNCTION

#需依據合拼版的資料更新備料和製程追蹤的資料
FUNCTION i301sub_selsfd(p_sfb85)
DEFINE p_sfb85    LIKE sfb_file.sfb85
DEFINE l_sfb02    LIKE sfb_file.sfb02
DEFINE l_sfd02    LIKE sfd_file.sfd02
DEFINE l_sfd03    LIKE sfd_file.sfd03
DEFINE l_sfd07    LIKE sfd_file.sfd07
DEFINE l_sfb05    LIKE sfb_file.sfb05
DEFINE l_sfb08    LIKE sfb_file.sfb08
DEFINE l_sfb071   LIKE sfb_file.sfb071
DEFINE l_sfb93    LIKE sfb_file.sfb93
DEFINE l_cnt,l_cnt1  LIKE type_file.num5
DEFINE l_ecm014      LIKE ecm_file.ecm014   #FUN-B20070
DEFINE l_ecm015      LIKE ecm_file.ecm015   #FUN-B20070

  DECLARE sfd_cs1 CURSOR FOR
     SELECT sfd03,sfd02,sfd07,sfb02,sfb05,sfb08,sfb071,sfb93 FROM sfd_file,sfb_file
      WHERE sfd01=p_sfb85
        AND sfd03=sfb01
  FOREACH sfd_cs1 INTO l_sfd03,l_sfd02,l_sfd07,l_sfb02,l_sfb05,l_sfb08,l_sfb071,l_sfb93
     IF SQLCA.SQLCODE THEN 
        CALL cl_err('sfd_cs1:',SQLCA.SQLCODE,1)
        LET g_success='N'
        EXIT FOREACH
     END IF
     #FUN-A80060--begin--add------------
     LET l_cnt = 0   LET l_cnt1=0
     SELECT count(*) INTO l_cnt FROM edg_file
      WHERE edg01=p_sfb85 AND edg02=l_sfd02
     SELECT count(*) INTO l_cnt1 FROM edh_file
      WHERE edh01=p_sfb85 AND edh011=l_sfd02
     IF l_cnt = 0 OR l_cnt1 = 0 THEN
        CALL cl_err(l_sfd03,'asf-168',1)
        LET g_success='N'
        EXIT FOREACH
     END IF
     #FUN-A80060--end--add--------------
     IF NOT cl_null(l_sfd07) AND l_sfd07 <> ' ' THEN
        #FUN-B20070--begin--add-----
        LET l_ecm014=''  LET l_ecm015=''
        DECLARE ecm_cs CURSOR FOR 
         SELECT DISTINCT ecm014,ecm015 FROM ecm_file
          WHERE ecm01=l_sfd03 AND ecm012=l_sfd07
        FOREACH ecm_cs INTO l_ecm014,l_ecm015
          EXIT FOREACH
        END FOREACH
         #FUN-B20070--end--add-----
        DELETE FROM ecm_file WHERE ecm01=l_sfd03 AND ecm012=l_sfd07
     ELSE
        LET l_ecm014='' LET l_ecm015=' '  #FUN-B20070
        DELETE FROM ecm_file WHERE ecm01=l_sfd03
     END IF
     IF SQLCA.sqlcode THEN CALL cl_err('del ecm',SQLCA.sqlcode,1) LET g_success='N' EXIT FOREACH END IF
     CALL i301sub_s_put(p_sfb85,l_sfd02,l_sfd07,l_sfd03,l_sfb02,l_sfb93,l_sfb08,l_ecm014,l_ecm015) #更新製程追蹤的資料 #FUN-B20070
     IF g_success = 'Y' THEN
        IF NOT cl_null(l_sfd07) AND l_sfd07 <> ' ' THEN
           DELETE FROM sfa_file WHERE sfa01=l_sfd03 AND sfa012=l_sfd07 
        ELSE
           DELETE FROM sfa_file WHERE sfa01=l_sfd03
        END IF
        CALL s_cralc6(l_sfd03,l_sfb02,l_sfb05,'Y',l_sfb08,l_sfb071,'Y',g_sma.sma71,   #更新備料資料
                      p_sfb85,l_sfd02,l_sfd07)
        IF g_success = 'N' THEN EXIT FOREACH END IF
     END IF
  END FOREACH
END FUNCTION

FUNCTION i301sub_s_put(p_edg01,p_edg02,p_sfd07,p_wono,p_wotype,p_sfb93,p_sfb08,p_ecm014,p_ecm015)  #FUN-B20070
DEFINE
    p_edg01  LIKE edg_file.edg01,
    p_edg02  LIKE edg_file.edg02,
    p_sfd07  LIKE sfd_file.sfd07,
    p_sfb93  LIKE sfb_file.sfb93,
    p_sfb08  LIKE sfb_file.sfb08,
    p_wono   LIKE sfb_file.sfb01,
    p_wotype LIKE sfb_file.sfb02,
    L_edg    RECORD LIKE edg_file.*,
    l_ecm    RECORD LIKE ecm_file.* 
DEFINE p_ecm015   LIKE ecm_file.ecm015  #FUN-B20070
DEFINE p_ecm014   LIKE ecm_file.ecm014  #FUN-B20070
DEFINE l_ecm012   LIKE ecm_file.ecm012  #CHI-B80096
DEFINE l_sfb08    LIKE sfb_file.sfb08   #CHI-B80096
 

    DECLARE c_put CURSOR FOR
         SELECT edg_file.* FROM edg_file
              WHERE edg01=p_edg01
                AND edg02=p_edg02
            ORDER BY edg01,edg02,edg03
    FOREACH c_put INTO l_edg.*
        IF SQLCA.sqlcode THEN LET g_success='N' EXIT FOREACH END IF
        INITIALIZE l_ecm.* TO NULL
        LET l_ecm.ecm01      =  p_wono
        LET l_ecm.ecm02      =  p_wotype
        #SELECT sfb05 INTO l_ecm.ecm03_par FROM sfb_file WHERE sfb01=p_wono  #MOD-D20173
        SELECT sfb05,sfb08 INTO l_ecm.ecm03_par,l_sfb08 FROM sfb_file WHERE sfb01=p_wono  #MOD-D20173
        LET l_ecm.ecm03      =  l_edg.edg03
        LET l_ecm.ecm04      =  l_edg.edg04
        LET l_ecm.ecm05      =  l_edg.edg05
        LET l_ecm.ecm06      =  l_edg.edg06
        LET l_ecm.ecm07      =  0
        LET l_ecm.ecm08      =  0
        LET l_ecm.ecm09      =  0
        LET l_ecm.ecm10      =  0
        LET l_ecm.ecm11      =  l_edg.edg11          #製程編號
        LET l_ecm.ecm13      =  l_edg.edg13          #固定工時(秒)
        #LET l_ecm.ecm14      =  l_edg.edg14          #標準工時(秒) #MOD-D20173
        LET l_ecm.ecm14      =  l_edg.edg14*l_sfb08  #標準工時(秒)  #MOD-D20173
        LET l_ecm.ecm15      =  l_edg.edg15          #固定機時(秒)
        #LET l_ecm.ecm16      =  l_edg.edg16          #標準機時(秒) #MOD-D20173
        LET l_ecm.ecm16      =  l_edg.edg16*l_sfb08  #標準機時(秒)  #MOD-D20173
        LET l_ecm.ecm49      =  l_edg.edg49          #製程人力
        LET l_ecm.ecm45      =  l_edg.edg45          #作業名稱
        LET l_ecm.ecm52      =  l_edg.edg52          #SUB 否
        LET l_ecm.ecm53      =  l_edg.edg53          #PQC 否
        LET l_ecm.ecm54      =  l_edg.edg54          #Check in 否
        LET l_ecm.ecm55      =  l_edg.edg55          #Check in Hold 否
        LET l_ecm.ecm56      =  l_edg.edg56          #Check Out Hold 否
        LET l_ecm.ecm65      =  0                    #CHI-B80096
        LET l_ecm.ecm291     =  0
        LET l_ecm.ecm292     =  0
        LET l_ecm.ecm301     =  0
        LET l_ecm.ecm302     =  0
        LET l_ecm.ecm303     =  0
        LET l_ecm.ecm311     =  0
        LET l_ecm.ecm312     =  0
        LET l_ecm.ecm313     =  0
        LET l_ecm.ecm314     =  0
        LET l_ecm.ecm315     =  0           #bonus
        LET l_ecm.ecm316     =  0           #bonus
        LET l_ecm.ecm321     =  0
        LET l_ecm.ecm322     =  0
        LET l_ecm.ecm58      = l_edg.edg58
        LET l_ecm.ecmacti    =  'Y'
        LET l_ecm.ecmuser    =  g_user
        LET l_ecm.ecmgrup    =  g_grup
        LET l_ecm.ecmmodu    =  ''
        LET l_ecm.ecmdate    =  g_today
        LET l_ecm.ecmplant   =  g_plant 
        LET l_ecm.ecmlegal   =  g_legal  
        IF s_industry('slk') THEN
          LET l_ecm.ecmslk01  = l_edg.edgslk01
          LET l_ecm.ecmslk02  = l_edg.edgslk02
          LET l_ecm.ecmslk03  = l_edg.edgslk03
          LET l_ecm.ecmslk04  = l_edg.edgslk04
        END IF
        LET l_ecm.ecm61 = 'N'
        LET l_ecm.ecm62 = l_edg.edg62
        LET l_ecm.ecm63 = l_edg.edg63
        LET l_ecm.ecm12 = l_edg.edg12
        LET l_ecm.ecm64 = l_edg.edg64
        LET l_ecm.ecm34 = l_edg.edg34
        LET l_ecm.ecm50 = l_edg.edg50
        LET l_ecm.ecm51 = l_edg.edg51
        LET l_ecm.ecm66 = l_edg.edg66 
        LET l_ecm.ecm015= p_ecm015    #FUN-B20070
        LET l_ecm.ecm014= p_ecm014    #FUN-B20070
        IF g_sma.sma541 = 'Y' AND p_sfb93 = 'Y' THEN
           LET l_ecm.ecm012 = p_sfd07
           DECLARE ecu012_cus CURSOR FOR
            SELECT ecu012 FROM ecu_file
             WHERE ecu01 = l_ecm.ecm03_par
               AND ecu02 = l_ecm.ecm11
               AND ecu015 = p_sfd07
               AND ecuacti = 'Y'  #CHI-C90006
            FOREACH ecu012_cus INTO l_ecm.ecm011
              EXIT FOREACH
            END FOREACH
        END IF
        IF cl_null(l_ecm.ecm012) THEN LET l_ecm.ecm012=' ' END IF  
        IF cl_null(l_ecm.ecm015) THEN LET l_ecm.ecm015=' ' END IF   #FUN-B20070
        #CHI-B80096-mark-str--
        #IF g_sma.sma541='Y' THEN
        #   CALL cralc_eck_rate(p_wono,l_ecm.ecm03,l_ecm.ecm012,p_sfb08,l_ecm.ecm12,l_ecm.ecm34,
        #                       l_ecm.ecm64,l_ecm.ecm62/l_ecm.ecm63,1)
        #   RETURNING l_ecm.ecm65 
        #ELSE
        #   LET l_ecm.ecm65 = 0
        #END IF
        #IF cl_null(l_ecm.ecm65) THEN LET l_ecm.ecm65=0 END IF
        #CHI-B80096-mark-end--
        IF cl_null(l_ecm.ecm66) THEN LET l_ecm.ecm66 = 'Y' END IF #TQC-B80022      
        IF cl_null(l_ecm.ecm62) OR l_ecm.ecm62 = 0 THEN LET l_ecm.ecm62 = 1 END IF   #CHI-B80096
        IF cl_null(l_ecm.ecm63) OR l_ecm.ecm63 = 0 THEN LET l_ecm.ecm63 = 1 END IF   #CHI-B80096
        INSERT INTO ecm_file VALUES(l_ecm.*)
        IF STATUS THEN
           CALL cl_err3("ins","ecm_file","","",STATUS,"","",0) 
           LET g_success = 'N'
           EXIT FOREACH
        END IF
    END FOREACH
    #CHI-B80096-add-str--
    IF g_success='Y' THEN
       SELECT sfb08 INTO l_sfb08 FROM sfb_file WHERE sfb01 = p_wono
       DECLARE ecm012_cs CURSOR FOR 
        SELECT DISTINCT ecm012 FROM ecm_file WHERE ecm01=p_wono AND (ecm015 IS NULL OR ecm015 =' ')
       FOREACH ecm012_cs INTO l_ecm012
          EXIT FOREACH
       END FOREACH 
       CALL s_schdat_output(l_ecm012,l_sfb08,p_wono)
    END IF
    #CHI-B80096-add-end--
END FUNCTION
#FUN-A80054--end--add-----------------------
#No.FUN-9C0072 精簡程式碼
#FUN-A30093

#FUN-C30274 --START--
FUNCTION i301sub_ind_icd_upd_pmm25(l_sfb)
DEFINE l_sfb      RECORD LIKE sfb_file.*
DEFINE l_pmm      RECORD LIKE pmm_file.*

   IF l_sfb.sfb02 NOT MATCHES '[78]' THEN RETURN END IF
 
   SELECT DISTINCT pmm_file.* INTO l_pmm.* FROM pmm_file,pmn_file   
    WHERE pmm01 = pmn01 AND pmn41 = l_sfb.sfb01
      AND pmm02 = 'SUB' AND pmm18 = 'Y' AND pmmacti = 'Y'  #有效委外未確認
   IF SQLCA.sqlcode THEN RETURN END IF

   CALL t540sub_issue(l_pmm.pmm01,FALSE)
   IF g_success = 'N' THEN 
      RETURN 
   END IF

END FUNCTION
#FUN-C30274 --END--
#NO.MOD-880016
#FUN-920190
#FUN-B50046

#str TQC-C60019 add
FUNCTION i301sub_del_idb(p_sfa01,p_sfa03,p_sfa08,p_sfa12,p_sfa27,p_sfa012,p_sfa013,p_type)
DEFINE p_sfa01   LIKE sfa_file.sfa01
DEFINE p_sfa03   LIKE sfa_file.sfa03
DEFINE p_sfa08   LIKE sfa_file.sfa08
DEFINE p_sfa12   LIKE sfa_file.sfa12
DEFINE p_sfa27   LIKE sfa_file.sfa27
DEFINE p_sfa012  LIKE sfa_file.sfa012
DEFINE p_sfa013  LIKE sfa_file.sfa013
DEFINE p_type    LIKE type_file.chr1   #1:整張工單刪除或作廢  #2.某筆備料單身的刪除
DEFINE l_sql     STRING
DEFINE l_sfaa    RECORD LIKE sfaa_file.*
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_flag    LIKE type_file.chr1
DEFINE l_flag1   LIKE type_file.num5

    IF p_type = '1' THEN
       LET l_sql = "SELECT * FROM sfaa_file",
                   " WHERE sfaa01 ='",p_sfa01 CLIPPED,"'"
    ELSE
       LET l_sql = "SELECT * FROM sfaa_file",
                   " WHERE sfaa01 ='",p_sfa01,"'",
                   "   AND sfaa03 ='",p_sfa03,"'",
                   "   AND sfaa08 ='",p_sfa08,"'",
                   "   AND sfaa12 ='",p_sfa12,"'",
                   "   AND sfaa27 ='",p_sfa27,"'",
                   "   AND sfaa012='",p_sfa012,"'",
                   "   AND sfaa013= ",p_sfa013
    END IF
    PREPARE i301sub_sfaa_pre FROM l_sql
    DECLARE i301sub_sfaa_cs CURSOR FOR i301sub_sfaa_pre

    LET l_flag = 'N'
    LET l_flag1 = 1
    FOREACH i301sub_sfaa_cs INTO l_sfaa.*
       #若已有idb_file詢問且一併刪除
       LET l_cnt = 0
       SELECT COUNT(*) INTO l_cnt FROM idb_file
        WHERE idb07 = l_sfaa.sfaa01
          AND idb08 = 1
          AND idb01 = l_sfaa.sfaa03
          AND idb02 = l_sfaa.sfaa30
          AND idb03 = l_sfaa.sfaa31
          AND idb04 = l_sfaa.sfaa32
       IF l_cnt > 0 THEN
          IF l_flag = 'N' THEN
             #此單號項次已有刻號/BIN明細資料,將一併刪除,是否確定執行此動作?
             IF NOT cl_confirm('aic-112') THEN
                CLOSE i301sub_sfaa_cs
                LET l_flag1 = 0
                EXIT FOREACH
             ELSE
                LET l_flag = 'Y'
             END IF
          END IF
          IF l_flag = 'Y' THEN
             IF NOT s_icdinout_del_2(-1,l_sfaa.sfaa01,1,'',l_sfaa.sfaa03,l_sfaa.sfaa30,l_sfaa.sfaa31,l_sfaa.sfaa32) THEN
                CLOSE i301sub_sfaa_cs
                LET l_flag1 = 0
                EXIT FOREACH
             END IF
          END IF
       END IF
    END FOREACH

    RETURN l_flag1    #成功回傳1,失敗回傳0

END FUNCTION
#end TQC-C60019 ad0
#TQC-C60175
#CHI-C90045---begin
FUNCTION i301sub_icd_stock_post(p_sfb01)
DEFINE l_sfp01   LIKE sfp_file.sfp01
DEFINE l_sfp     RECORD LIKE sfp_file.*
DEFINE l_o_prog  STRING
DEFINE p_sfb01   LIKE sfb_file.sfb01
 
   LET g_success='Y'
   BEGIN WORK
   #檢查有發料單存在否,若存在則自動過帳 
   DECLARE i301_bin_c2 CURSOR FOR
     SELECT DISTINCT sfp01 
       FROM sfp_file,sfs_file
      WHERE sfs03=p_sfb01
        AND sfp01=sfs01
        AND sfpconf='N'
   
   FOREACH i301_bin_c2 INTO l_sfp01
      IF NOT cl_null(l_sfp01) THEN
         CALL i501sub_y_chk(l_sfp01,NULL)   #TQC-C60079
         IF g_success = "Y" THEN
            CALL i501sub_y_upd(l_sfp01,NULL,TRUE)
              RETURNING l_sfp.*
         END IF

         LET l_o_prog = g_prog
         CASE l_sfp.sfp06
            WHEN "1" LET g_prog='asfi511'
            WHEN "2" LET g_prog='asfi512'
            WHEN "3" LET g_prog='asfi513'
            WHEN "4" LET g_prog='asfi514'
            WHEN "6" LET g_prog='asfi526'
            WHEN "7" LET g_prog='asfi527'
            WHEN "8" LET g_prog='asfi528'
            WHEN "9" LET g_prog='asfi529'
         END CASE
         
         IF g_success = "Y" THEN
            CALL i501sub_s('1',l_sfp.sfp01,TRUE,'N')
         END IF
         LET g_prog = l_o_prog
         
      END IF
   END FOREACH

END FUNCTION
#CHI-C90045---end
#FUN-CC0077


#DEV-D30045--add--begin
FUNCTION i301sub_barcode_gen(p_sfb01,p_ask)
   DEFINE p_sfb01   LIKE sfb_file.sfb01
   DEFINE p_ask     LIKE type_file.chr1
   DEFINE l_sfb     RECORD LIKE sfb_file.*
   DEFINE l_ima930  LIKE ima_file.ima930
   DEFINE l_ima932  LIKE ima_file.ima932
   DEFINE l_ima918  LIKE ima_file.ima918
   DEFINE l_ima919  LIKE ima_file.ima919
   DEFINE l_ima921  LIKE ima_file.ima921
   DEFINE l_ima922  LIKE ima_file.ima922
   DEFINE l_ima931  LIKE ima_file.ima931
   DEFINE l_count   LIKE type_file.num5
   DEFINE l_cnt     LIKE type_file.num5
   
   IF cl_null(p_sfb01) THEN
      CALL cl_err('',-400,0)
      LET g_success = 'N'
      RETURN
   END IF

   SELECT * INTO l_sfb.* FROM sfb_file WHERE sfb01 = p_sfb01

   #檢查是否符合產生時機點
   IF NOT s_gen_barcode_chktype('A',l_sfb.sfb01,'','') THEN
      RETURN
   END IF
   
   IF l_sfb.sfb87 = 'N' THEN
      CALL cl_err('','sfb-999',0)
      LET g_success = 'N'
      RETURN
   END IF
   
   IF l_sfb.sfb87 = 'X' THEN
      CALL cl_err('','sfb-998',0)
      LET g_success = 'N'
      RETURN
   END IF
   
   IF NOT s_tlfb_chk(l_sfb.sfb01) THEN
      LET g_success = 'N'
      RETURN
   END IF

   IF p_ask = 'Y' THEN
      IF NOT cl_confirm('azz1276') THEN
         LET g_success='N'
         RETURN
      END IF
   END IF
   
   LET g_success = 'Y'
   BEGIN WORK
   CALL s_showmsg_init()
   
   CALL i301sub_lock_cl() 

   OPEN i301sub_cl USING l_sfb.sfb01
   IF STATUS THEN
      CALL cl_err("OPEN i301sub_cl:", STATUS, 1)
      CLOSE i301sub_cl
      ROLLBACK WORK
      LET g_success='N' 
      RETURN
   END IF
 
   FETCH i301sub_cl INTO l_sfb.*          
   IF SQLCA.sqlcode THEN
      CALL cl_err('lock sfb:',SQLCA.sqlcode,0)     
      CLOSE i301sub_cl
      ROLLBACK WORK
      LET g_success='N' 
      RETURN
   END IF

   #DEV-D30043--mark--begin
   #IF NOT s_diy_barcode(l_sfb.sfb01,'','','A') THEN
   #   LET g_success = 'N'
   #END IF
   #
   #IF g_success = 'Y' THEN
   #   CALL s_gen_barcode2('A',l_sfb.sfb01,'','')
   #END IF
   #DEV-D30043--mark--end

   #DEV-D30043--add--begin
   IF g_success = 'Y' THEN
      CALL s_gen_barcode2('A',l_sfb.sfb01,'','')
   END IF

   IF g_success = 'Y' THEN
      IF NOT s_diy_barcode(l_sfb.sfb01,'','','A') THEN
         LET g_success = 'N'
      END IF
   END IF
   #DEV-D30043--add--end

   CALL s_showmsg()
   IF g_success='Y' THEN
      COMMIT WORK
      CALL cl_msgany(0,0,'aba-001')
   ELSE
      ROLLBACK WORK
      #CALL cl_msgany(0,0,'aba-002')    #DEV-D40015--mark
      CALL cl_err('','aba-002',0)       #DEV-D40015--mod
   END IF
END FUNCTION


FUNCTION i301sub_barcode_z(p_sfb01)
   DEFINE p_sfb01   LIKE sfb_file.sfb01
   DEFINE p_ask     LIKE type_file.chr1
   DEFINE l_sfb     RECORD LIKE sfb_file.*
   DEFINE l_ima930  LIKE ima_file.ima930
   DEFINE l_ima932  LIKE ima_file.ima932
   DEFINE l_ima918  LIKE ima_file.ima918
   DEFINE l_ima919  LIKE ima_file.ima919
   DEFINE l_ima921  LIKE ima_file.ima921
   DEFINE l_ima922  LIKE ima_file.ima922
   DEFINE l_ima931  LIKE ima_file.ima931
   DEFINE l_count   LIKE type_file.num5
   DEFINE l_cnt     LIKE type_file.num5
   
   IF cl_null(p_sfb01) THEN
      CALL cl_err('',-400,0)
      LET g_success = 'N'
      RETURN
   END IF

   SELECT * INTO l_sfb.* FROM sfb_file WHERE sfb01 = p_sfb01

   #檢查是否符合產生時機點
   IF NOT s_gen_barcode_chktype('A',l_sfb.sfb01,'','') THEN
      LET g_success  = 'Y'       #DEV-D40015 add
      RETURN
   END IF
   
   IF l_sfb.sfb87 = 'X' THEN
      CALL cl_err('','sfb-998',0)
      LET g_success = 'N'
      RETURN
   END IF
   
   IF NOT s_tlfb_chk2(l_sfb.sfb01) THEN
      LET g_success = 'N'
      RETURN
   END IF

   
  #LET g_success = 'Y'     #DEV-D40015 mark
  #BEGIN WORK              #DEV-D40015 mark
   CALL s_showmsg_init()
   
   CALL i301sub_lock_cl() 

   OPEN i301sub_cl USING l_sfb.sfb01
   IF STATUS THEN
      CALL cl_err("OPEN i301sub_cl:", STATUS, 1)
      CLOSE i301sub_cl
     #ROLLBACK WORK        #DEV-D40015 mark
      LET g_success='N' 
      RETURN
   END IF
 
   FETCH i301sub_cl INTO l_sfb.*          
   IF SQLCA.sqlcode THEN
      CALL cl_err('lock sfb:',SQLCA.sqlcode,0)     
      CLOSE i301sub_cl
     #ROLLBACK WORK        #DEV-D40015 mark
      LET g_success='N' 
      RETURN
   END IF


   IF g_success='Y' THEN
      CALL s_barcode_x2('A',l_sfb.sfb01,'','')
   END IF

   CALL s_showmsg()
   IF g_success='Y' THEN
     #COMMIT WORK          #DEV-D40015 mark   
      CALL cl_msgany(0,0,'aba-178')
   ELSE
     #ROLLBACK WORK        #DEV-D40015 mark
      CALL cl_msgany(0,0,'aba-179')
   END IF
END FUNCTION
#DEV-D30045--add--end
