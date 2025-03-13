# Prog. Version..: '5.30.10-13.11.15(00000)'     #
# Prog. Version... '5.20.01-09.03.15(00000)'     #
#
# Pattern name.... apmp801.4gl
# Descriptions.... 三角貿易採購單拋轉作業
# Date & Author... 01/11/07 By Tommy
# Modify.......... No.8083 03/08/28 Kammy 1.流程抓取方式修改(poz_file,poy_file)
#                                         2.若逆拋最終供應商的採購單性質為'REG'
# Modify.......... No.MOD-490455 Kammy 讀取進項稅別時，若只拋二站，會被卡住
# Modify.......... No.FUN-4C0011 04/12/01 By Mandy 單價金額位數改為dec(20,6)
# Modify.......... No.FUN-550060 05/05/30 By Will 單據編號放大
# Modify.......... NO.FUN-560043 05/06/28 By Smapmin 根據雙單位做調整,多角序號放大,單號放大
# Modify.......... No.FUN-570252 05/12/27 By Sarah 增加拋轉採購單特別說明與備註(當poz10=Y)
# Modify.......... No.FUN-620028 06/02/11 By Carrier 將apmp801拆開成apmp801及sapmp801
# Modify.......... No.FUN-620025 06/02/15 By cl 增加對訂單，采購單單別的獲取
# Modify.......... No.FUN-630006 06/03/06 By Nicola 預設pmm909="1"
#                                                   從axmp502執行有問題，show不同的錯誤訊息
# Modify.......... No.MOD-630099 06/03/24 By Mandy 代採,逆時,指定幣別有打勾,無指定最終流程供應商,拋到最終站時,單價/金額幣別取位有誤
# Modify.......... NO.TQC-640078 06/04/09 BY yiting 產生到第2/3站時，採購單單價有誤
# Modify.......... NO.TQC-650127 06/05/29 BY sam_lin [mrp計算否為Y] / [發票扣抵區分為可扣抵進貨及費用]
# Modify.......... NO.FUN-660051 06/06/19 By Nicola 單價取價增加‘依最終站單價反推'
# Modify.......... No.FUN-660129 06/06/23 By wujie  cl_err-->cl_err3
# Modify.......... NO.FUN-660168 06/06/23 By Nicola 逆推時，不同幣別單價抓取需考慮匯率
# Modify.......... No.MOD-670044 06/07/10 By Mandy pmn40會計科目改抓當站資料庫的ima39
# Modify.......... NO.FUN-670007 06/08/14 BY yiting 依照apmi000設定的站別抓拋轉資料
# Modify.......... No.FUN-670099 06/08/28 By Nicola 價格管理修改
# Modify.......... No.FUN-680136 06/09/15 By Jackho 欄位類型修改
# Modify.......... NO.TQC-680098 06/09/20 BY yiting 在單價逆推時不能直接拿g_flow傳入，要傳流程代碼才對
# Modify.......... NO.TQC-690065 06/10/30 BY Rayven 拋轉采購單時取價錯誤
# Modify.......... No.FUN-6B0065 06/11/21 By Ray atmi217并入aooi313(azf09,10,11,12,13取代tqe03,04,05,11,08)
# Modify.......... NO.TQC-6A0084 06/12/05 By Nicola 含稅金額、未稅金額調整
# Modify.......... NO.TQC-6B0136 06/12/05 By Nicola 逆推時，含稅金額、未稅金額調整
# Modify.......... NO.MOD-710074 07/01/31 BY claire 送貨客戶以來源的送貨客戶為主
# Modify.......... No.FUN-710030 07/02/07 By johnray 錯誤訊息匯總顯示修改
# Modify.......... NO.TQC-740104 07/04/18 by Yiting pmn90未處理，拋轉時給予和pmn31相同值 
# Modify.......... NO.TQC-740133 07/04/19 BY yiting pmn88t後少了逗點，造成insert 錯誤
# Modify.......... NO.MOD-740199 07/04/23 BY yiting 取l_pmm.pmm01時資料庫要傳入當站
# Modify.......... NO.MOD-740253 07/04/23 BY yiting 實際上並沒有拋轉成功，但本站卻回寫多角拋轉序號，造成以為拋轉成功，但卻查不到其它站別的單據
# Modify.......... NO.MOD-740393 07/04/23 BY yiting s_defprice1.4gl 與sapmp801裡呼叫傳遞參數不一，造成程式錯誤當出
# Modify.......... NO.MOD-740509 07/05/02 BY yiting s_defprice1.4gl傳入參數應為'1'
# Modify.......... NO.TQC-740335 07/05/09 BY yiting oeb1003被包含在分銷功能時才給'1',造成axmt810單身抓不出資料
# Modify.......... NO.TQC-760054 07/06/06 By xufeng azf_file的index是azf_01(azf01,azf02),但是在抓‘中文說明’內容時，WHERE條件卻只有 azf01 = g_xxx
# Modify.......... NO.MOD-760016 07/06/10 By claire MISC料號只判斷前四碼
# Modify.......... NO.TQC-760152 07/06/20 By Rayven 拋轉時沒有考慮稅種影響，訂單檢驗，分配，備，采用訂單匯率立帳沒有賦初值
# Modify.......... NO.MOD-770155 07/07/01 By claire 取號錯誤應改 g_success='N' 避免_flow99()寫入的多角序號
# Modify.......... NO.MOD-780030 07/08/08 By claire 備註的單號值不可取來源站應取各站的單號
# Modify.......... No.MOD-770098 07/08/10 By claire 重新拋轉已拋轉資料之oea06 版本未更新到  
# Modify.......... No.MOD-770111 07/08/10 By claire 最終站新增採購單備註時要判斷是否有最終供應商否則會有ins pmo -239的錯誤 
# Modify.......... NO.MOD-780218 07/08/20 BY yiting 取價方式為依來源站時，匯率抓取要依來源站匯率
# Modify.......... NO.MOD-780213 07/08/22 BY yiting upd pmn時發生錯誤
# Modify.......... NO.TQC-780078 07/08/23 BY claire TQC-640078調整
# Modify.......... NO.MOD-780027 07/08/24 By claire 變更單新項次無法拋轉
# Modify.......... No.TQC-780096 07/08/31 By rainy  primary key 複合key 處理 
# Modify.......... NO.TQC-790096 07/09/14 BY yiting 當站別只有二站時(0/1)，拋轉失敗但是沒有錯誤訊息
# Modify.......... No.FUN-7B0091 07/11/19 By Sarah oea65預設值給N
# Modify.......... No.TQC-7C0023 07/12/05 By Davidzv 增加是否進入FOREACH的判斷
# Modify.......... NO.TQC-7C0046 07/12/06 BY heather 使采購單號能開窗查詢
# Modify.......... NO.TQC-7C0064 07/12/08 BY Beryl 判斷單別在拋轉資料庫是否存在，如果不存在，則報錯，批處理運行不成功．提示user單據別無效或不存在其資料庫中
# Modify.......... NO.TQC-7C0146 07/12/19 BY claire poz04已無使用, 應取單身第0站的上游廠商
# Modify.......... NO.MOD-810016 08/01/02 BY claire l_flag先預設值, 以免殘留舊值
# Modify.......... NO.MOD-810056 08/01/07 BY claire 最終供應商採購單別應取設定第99站的poy35單別
# Modify.......... NO.MOD-7C0185 08/01/09 BY claire 來源站的料件需存在各站資料庫中
# Modify.......... NO.MOD-810209 08/01/25 BY claire 最後一站若無最終供應商不應再check採購單別
# Modify.......... NO.MOD-820150 08/02/25 BY lumx   當多角貿易代采買正拋時，在采購單中建立一筆采購單 然后變更采購單后采購發出時，報錯信息跳出兩次但是不明確，但是更改成功 
# Modify.......... NO.TQC-830048 08/03/25 By Mandy  程式重過
# Modify.......... NO.FUN-830132 08/03/28 By hellen 行業別表拆分INSERT/DELETE
# Modify.......... NO.MOD-840588 08/04/23 By claire (1)計價基準設定由最終供應商做單價逆推,調整問題
# Modify.......... NO.TQC-840058 08/04/23 BY cliare 調整FUN-710030
# Modify.......... NO.TQC-840065 08/04/28 By claire 計價基準設定由最終供應商做單價逆推,調整問題
# Modify.......... NO.MOD-850243 08/05/29 BY claire poy10未建檔給錯誤訊息
# Modify.......... No.MOD-860042 08/07/15 By Pengu INSERT oeb_file時oeb28應該要default 0
# Modify.......... No.MOD-890251 08/09/26 By claire MISC拋轉時只需確認是否存在一筆MISC開頭料件即可
# Modify.......... No.FUN-8A0086 08/10/21 By baofei 完善FUN-710050的錯誤匯總的修改
# Modify.......... No.MOD-8B0063 08/11/06 By claire 送貨地址(pmm10)給值下一站po
# Modify.......... No.MOD-8B0273 08/12/04 By chenyu 采購單單頭含稅時，未稅單價=未稅金額/計價數量
# Modify.......... No.MOD-910077 09/01/09 By claire 採購未稅含稅金額依幣別取位
# Modify.......... NO.MOD-830134 09/02/04 BY claire 給pmn38,pmm45變數值=g_pmm.pmm45
# Modify.......... No.FUN-920186 09/03/23 By lala  理由碼必須為銷售原因
# Modify.......... No.FUN-930148 09/03/26 By ve007 采購取價和定價
# Modify.......... No.TQC-950010 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring()       
# Modify.......... No.TQC-930026 09/05/19 By xiaofeizhu s_defprice1增加一個參數
# Modify.......... No.FUN-940083 09/05/21 By zhaijie調整批處理賦值
# Modify.......... No.MOD-950283 09/05/30 By Dido 訂單單身單價應以單頭 oea213 含稅否區分
# Modify.......... No.CHI-950040 09/06/04 By Dido 轉撥單價取價問題
# Modify.......... No.MOD-960228 09/06/19 By Dido IF g_bgerr THEN  都要有  LET g_success = 'N'
# Modify.......... No.MOD-970022 09/07/08 By Dido 增加更新訂單幣別匯率
# Modify.......... No.TQC-980024 09/08/04 By sherry 流程代碼開窗
# Modify.......... No.MOD-980009 09/08/05 By Dido 計價單位與計價數量調整
# Modify.......... No.FUN-980006 09/08/14 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.......... No.TQC-980183 09/08/26 By xiaofeizhu 還原MOD-8B0273修改的內容
# Modify.......... No.TQC-970182 09/08/27 By destiny 當apmp910調用時會重復begin work 
# Modify.......... No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.......... No.FUN-980020 09/09/01 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.......... No.FUN-8C0110 09/09/07 By chenmoyan 最終供應商的采購幣別以apmi000 99站的幣別為主，如無資料再抓供應商主檔的慣用幣別
# Modify.......... No.FUN-980059 09/09/08 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.......... No.MOD-990144 09/09/15 By Dido 採購單價若不為最終站才需要檢核
# Modify.......... No.FUN-980092 09/09/17 By TSD.Martin GP5.2 跨資料庫語法修改
# Modify.......... No.CHI-960078 09/09/17 By Dido oea09 超交率預設值給予 
# Modify.......... No.MOD-9A0102 09/10/15 By lilingyu A向B拋資料,未使用多單位的A的pmn82(單位一數量)為空,而接受資料的B使用了雙單位,它需要單位一的數量,這種情況導致拋轉失敗
# Modify.......... No.CHI-950020 09/10/16 By chenmoyan 將自定義欄位的值拋轉各站
# Modify.......... No.TQC-9C0066 09/12/10 By Dido 迴圈結束時增加 l_stu_p_h 變數清空 
# Modify.......... No.MOD-9C0426 09/12/29 By Dido 若來源站 pmn87 為 0,則最終供應商也應為 0
# Modify.......... No.FUN-9C0071 10/01/04 By huangrh 精簡程式
# Modify.........: No.FUN-A10036 10/01/13 By baofei 手動修改INSERT INTO xxx_file ，增加xxx_file xxxoriu, xxxorig這二個欄位
# Modify.......... No.FUN-A10099 10/01/18 By Carrier 集团架构功能时CALL此作业进行抛转,修改成可以CALL方式及TRANSACTION部分等
# Modify.......... No.TQC-A30054 10/03/10 By lilingyu "資料創建日"欄位未賦予初值
# Modify.........: No:FUN-A10123 10/03/12 By bnlent 手工收貨時流通零售業相關字段賦值與管控 
# Modify.........: No:FUN-A30056 10/04/13 By Carrier Transaction Standardize
# Modify.........: No:FUN-A50063 10/05/14 By bnlent 考慮aza50='Y'時，非空值需要賦值
# Modify.........: No:TQC-A60107 10/06/23 By Carrier 将s_defprice1变成s_defprice_new
# Modify.........: No.FUN-A50102 10/07/15 By vealxu 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.......... No.MOD-A80021 10/08/13 By Smapmin 銷售與庫存單位的轉換率有誤
# Modify.......... No.TQC-A80091 10/08/18 By houlia 拋轉時給欄位oea261，oea262，oea263賦值。
# Modify.........: No:FUN-A80102 10/08/18 By kim GP5.25號機管理
# Modify.........: No.FUN-AB0061 10/11/16 By vealxu 訂單、出貨單、銷退單加基礎單價字段(oeb37,ogb37,ohb37)
# Modify.........: No.TQC-AB0293 10/11/29 By chenying 拋轉失敗,ins_oeb時多了l_oea.oea261,l_oea.oea262,l_oea.oea263
# Modify.........: No.TQC-AB0293 10/11/30 By chenying 還原之前TQC-AB0293的修改
# Modify.........: No.FUN-AA0023 10/12/14 By lixia 細化axm-043的報錯信息,調撥時訂單倉庫賦值
# Modify.........: No.TQC-AC0257 10/12/22 By suncx s_defprice_new.4gl返回值新增兩個參數
# Modify.......... No.MOD-AC0416 11/01/05 By Smapmin 取價方式為依上一站時,第一站匯率抓取要依來源站匯率
# Modify.......... No.MOD-AC0421 11/01/05 By Smapmin oeb906依照obk_file的資料給值
# Modify.......... No.MOD-B30127 11/03/11 By lixia oeacont不應判斷 azw04='2'才給值
# Modify.......... No.FUN-B20060 11/04/07 By zhangll 增加oeb72賦值
# Modify.......... No.TQC-B80056 11/08/04 By lixia 增加廠商（客戶）編號有效行檢查
# Modify.......... No:MOD-B90179 11/10/11 By Summer 採購單單價有誤,原因是更新時update錯誤的plant 
# Modify.......... No:MOD-BA0172 11/12/27 By Summer oea14/oea15改抓oea03所對應的occ04以及occ04所對應的部門gen03 
# Modify.......... No:MOD-BC0204 11/12/27 By Summer 最終供應商幣別抓apmi000的99站設定,那匯率應該也要重抓 
# Modify.......... No:MOD-C10074 12/02/09 By Vampire oeb1006若為空時,default 100
# Modify.......... No:MOD-C50189 12/06/27 By Vampire 不使用計價單位時,代採逆拋,第二站採購單的計價單位沒有給值,計價單位、數量仍須抓單據單位、數量給值
# Modify.......... No:MOD-C70073 12/07/06 By Elise 送貨地址,帳單地址須改抓當站最終供應商的資料
# Modify.......... No:MOD-C70213 12/08/01 By Elise 變更版本pmm03調整為給g_pmm.pmm03
# Modify.......... No:CHI-C80060 12/08/27 By pauline 令oeb72預設值為null 
# Modify.........: No.FUN-C50136 12/08/27 By xianghui 拋磚時如果做信用管控則需做信用管控處理
# Modify.........: No.FUN-C80001 12/08/29 By bart 多角拋轉時，批號需一併拋轉sma96
# Modify.........: No:FUN-C90050 12/10/24 By Lori 預設單別/預設POS上傳單別改以s_get_defslip取得
# Modify.......... No:MOD-CA0190 13/02/01 By Elise 多角貿易計價方式為逆推時,回寫下游訂單單頭與單身需要l_plant_up
# Modify.......... No:CHI-CC0033 13/03/27 By jt_chen 兩角修改
# Modify.........: No:FUN-D30099 13/03/29 By Elise 將asms230的sma96搬到apms010,欄位改為pod08
# Modify.........: No:FUN-D20036 13/04/23 By Elise 多角拋轉增加拋轉超交率
# Modify.........: No:TQC-D40086 13/04/25 By SunLM  尾差調整 
# Modify.........: No:CHI-D60041 13/07/08 By jt_chen 匯率(oax01/pod01)需依據抓各站參數設定
# Modify.........: No:TQC-D70095 13/07/30 By Summer 修正FUN-D20036,若l_pmn13_max的值為空時給0 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_oea   RECORD LIKE oea_file.*
DEFINE g_oeb   RECORD LIKE oeb_file.*
DEFINE g_pmm   RECORD LIKE pmm_file.*
DEFINE g_pmn   RECORD LIKE pmn_file.*
DEFINE tm      RECORD
                  wc        LIKE type_file.chr1000,   #No.FUN-680136 VARCHAR(600)
                  pmm905    LIKE pmm_file.pmm905
               END RECORD
DEFINE g_poz   RECORD LIKE poz_file.*    #流程代碼資料(單頭) No.8083
DEFINE g_poy   RECORD LIKE poy_file.*    #流程代碼資料(單身) No.8083
DEFINE s_poy   RECORD LIKE poy_file.*    #來源流程資料(單身) No.8083
DEFINE n_poy   RECORD LIKE poy_file.*    #下一站流程資料(單身) #CHI-950040
DEFINE p_pmm09  LIKE pmm_file.pmm09,    #廠商代號
       p_oea03  LIKE oea_file.oea03,    #客戶代號
       p_poy04  LIKE poy_file.poy04,    #工廠編號
       p_poz03  LIKE poz_file.poz03,    #申報方式
       p_poy06  LIKE poy_file.poy06,    #付款條件
       p_poy07  LIKE poy_file.poy07,    #收款條件
       p_poy08  LIKE poy_file.poy08,    #SO稅別
       p_poy09  LIKE poy_file.poy09,    #PO稅別
       p_poy12  LIKE poy_file.poy12,    #發票別
       p_poy10  LIKE poy_file.poy10,    #銷售分類
       p_poy11  LIKE poy_file.poy11,    #倉庫別
       p_poy26  LIKE poy_file.poy26,    #是否計算業績
       p_poy27  LIKE poy_file.poy27,    #業績歸屬方
       p_poy28  LIKE poy_file.poy28,    #出貨理由碼
       p_poy29  LIKE poy_file.poy29,    #代送商編號
       p_poy33  LIKE poy_file.poy33,    #債權代碼
       p_poy45  LIKE poy_file.poy45,    #NO.FUN-670007 add  採購成本中心
       p_poy46  LIKE poy_file.poy46,    #NO.FUN-670007 add  訂單成本中心
       p_pox03  LIKE pox_file.pox03,    #計價基準
       p_pox05  LIKE pox_file.pox05,    #計價方式
       p_pox06  LIKE pox_file.pox06,    #計價比率
       p_azi01  LIKE azi_file.azi01,    #計價幣別 #下站#MOD-630099
       p_azi01t LIKE azi_file.azi01,    #計價幣別 #當站#MOD-630099
       p_cnt    LIKE type_file.num5     #No.FUN-680136 SMALLINT                #計價方式符合筆數 
  DEFINE g_flow99       LIKE oea_file.oea99       #No.FUN-680136 VARCHAR(17)       #多角序號   #FUN-560043
  DEFINE t_dbs          LIKE type_file.chr21      #No.FUN-680136 VARCHAR(21)  #來源工廠
  DEFINE s_dbs_new      LIKE type_file.chr21      #No.FUN-680136 VARCHAR(21)  #NO.FUN-670007
  DEFINE l_dbs_tra      LIKE type_file.chr21       #FUN-980092 
  DEFINE l_dbs_new      LIKE type_file.chr21      #No.FUN-680136 VARCHAR(21)  #New DataBase Name
  DEFINE l_dbs_next     LIKE type_file.chr21      #No.FUN-680136 VARCHAR(21)  #New DataBase Name
  DEFINE l_aza          RECORD LIKE aza_file.*  #New DataBase Global Parameter
  DEFINE l_aza_next     RECORD LIKE aza_file.*  #New DataBase Global Parameter  #FUN-670007
  DEFINE s_aza          RECORD LIKE aza_file.*  #FUN-670007
  DEFINE l_sma          RECORD LIKE sma_file.*  #FUN-620025
  DEFINE s_azp          RECORD LIKE azp_file.*
  DEFINE l_azp          RECORD LIKE azp_file.*
  DEFINE l_azi          RECORD LIKE azi_file.*
  DEFINE g_sw           LIKE type_file.chr1      #No.FUN-680136 VARCHAR(1)
  DEFINE p_last         LIKE type_file.num5      #No.FUN-680136 SMALLINT     #流程之最後家數
  DEFINE p_last_plant   LIKE azp_file.azp01      #No.FUN-680136 VARCHAR(10)
  DEFINE g_argv1        STRING   #No.FUN-630006
  DEFINE g_argv2        LIKE pmm_file.pmm905
  DEFINE p_row,p_col    LIKE type_file.num5    #No.FUN-680136 SMALLINT
  DEFINE g_cnt          LIKE type_file.num10      #No.FUN-680136 INTEGER
  DEFINE g_msg          LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(72)
  DEFINE g_flag         LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
  DEFINE g_t1           LIKE oay_file.oayslip  #No.FUN-680136 VARCHAR(05)
  DEFINE l_plant_new    LIKE type_file.chr10   #No.FUN-980020
  DEFINE l_plant_next   LIKE type_file.chr10   #No.FUN-980059
  DEFINE t_plant        LIKE type_file.chr10   #No.FUN-980020
  DEFINE g_sql          STRING                 #No.FUN-A10099
  DEFINE g_from_dbs     LIKE type_file.chr21   #No.FUN-A10099
  DEFINE g_from_dbs_tra LIKE type_file.chr21   #No.FUN-A10099
  DEFINE g_InTransaction     LIKE type_file.num5       #No.FUN-A30056
 
FUNCTION p801(p_argv1,p_argv2,p_InTransaction)            #No.FUN-A30056
   DEFINE l_time    LIKE type_file.chr8                   #計算被使用時間  #No.FUN-680136 VARCHAR(8)
   DEFINE p_argv1   STRING   #No.FUN-630006
   DEFINE p_argv2   LIKE pmm_file.pmm905
   DEFINE p_InTransaction     LIKE type_file.num5         #No.FUN-A30056
 
   WHENEVER ERROR CONTINUE
  
   LET g_argv1 = p_argv1
   LET tm.pmm905 = p_argv2

   #No.FUN-A30056  --Begin
   LET g_InTransaction = p_InTransaction
   IF cl_null(g_Intransaction) THEN LET g_Intransaction = FALSE END IF
   #No.FUN-A30056  --End

   #No.FUN-A10099   --Begin
   #多角拋轉來源資料所在的db,集團調撥atmt254時,來源采購單不一定在當前db中
   IF cl_null(g_from_plant) THEN
      LET g_from_plant = g_plant
   END IF
   LET g_plant_new = g_from_plant
   CALL s_getdbs()
   LET g_from_dbs = g_dbs_new
   CALL s_gettrandbs()
   LET g_from_dbs_tra = g_dbs_tra
   #No.FUN-A10099  --End
 
   SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
   SELECT * INTO g_pod.* FROM pod_file WHERE pod00 = '0'
   IF cl_null(g_pod.pod01) THEN       #三角貿易使用匯率
      LET g_pod.pod01='T'
   END IF
#  SELECT * INTO g_oaz.* FROM oaz_file WHERE oaz00 = '0'   #FUN-C50136
 
   LET t_dbs = s_dbstring(g_dbs  CLIPPED)
   LET t_plant = g_plant      #FUN-980020
   #若有傳參數則不用輸入畫面
   IF cl_null(g_argv1) THEN 
      CALL p801_p1()
      CLOSE WINDOW p801_w
   ELSE
      #-----No.FUN-630006-----
      IF tm.pmm905 = "A" THEN
         LET tm.wc = g_argv1
         LET tm.pmm905 = 'N'
         
         CALL p801_p2()
         IF NOT g_InTransaction THEN      #No.FUN-A30056
            CALL s_showmsg()       #No.FUN-710030
            IF g_success = 'Y' THEN 
               CALL cl_err("","abm-019",1)
               COMMIT WORK
            ELSE 
               CALL cl_err("","apm-100",1)
               ROLLBACK WORK
            END IF
            DROP TABLE p801_file
         END IF                           #No.FUN-A30056
      ELSE
         LET tm.wc = " pmm01='",g_argv1,"' "
         IF cl_null(tm.pmm905) THEN LET tm.pmm905='N' END IF
         
         CALL p801_p2()
         DISPLAY g_success
         DISPLAY INT_FLAG
         #No.FUN-A30056  --Begin
         IF NOT g_InTransaction THEN
            CALL s_showmsg()       #No.FUN-710030
            IF g_success = 'Y' THEN 
               CALL cl_cmmsg(1) 
               COMMIT WORK
            ELSE 
               CALL cl_rbmsg(1) 
               ROLLBACK WORK
            END IF
            DROP TABLE p801_file
         END IF                       #No.FUN-A10099
         #No.FUN-A30056  --End
      END IF   #No.FUN-630006
   END IF
 
END FUNCTION
 
FUNCTION p801_p1()
   DEFINE l_ac    LIKE type_file.num5    #No.FUN-680136 SMALLINT
   DEFINE l_i     LIKE type_file.num5    #No.FUN-680136 SMALLINT
   DEFINE l_cnt   LIKE type_file.num5    #No.FUN-680136 SMALLINT
 
   LET p_row = 3 LET p_col = 15
  
   OPEN WINDOW p801_w AT p_row,p_col WITH FORM "apm/42f/apmp801" 
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
   CALL cl_ui_init()
  
   CALL cl_opmsg('z')
   LET tm.pmm905='N'
   DISPLAY BY NAME tm.pmm905
 
   WHILE TRUE
      ERROR ''
 
      CONSTRUCT BY NAME tm.wc ON pmm01,pmm04,pmm904 
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
 
       ON ACTION controlp                                                       
          CASE                                                                  
             WHEN INFIELD(pmm01)                                                 
                CALL cl_init_qry_var()                                          
                LET g_qryparam.state = "c"
                LET g_qryparam.form = "q_pmm01a"                                   
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO pmm01
                NEXT FIELD pmm01
                
             WHEN INFIELD(pmm904)                                                 
                CALL cl_init_qry_var()                                          
                LET g_qryparam.state = "c"
                LET g_qryparam.form = "q_pmm904"                                   
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO pmm904
                NEXT FIELD pmm904
                
             OTHERWISE EXIT CASE                                                
          END CASE                                                              
 
            CONTINUE CONSTRUCT
 
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
        
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
        
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
 
         ON ACTION locale                    #genero
            LET g_action_choice = "locale"
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            EXIT CONSTRUCT
        
         ON ACTION exit              #加離開功能genero
            LET INT_FLAG = 1
            EXIT CONSTRUCT
      
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
      END CONSTRUCT
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmmuser', 'pmmgrup') #FUN-980030
      
      IF g_action_choice = "locale" THEN  #genero
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE 
      END IF
      
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         EXIT WHILE  
      END IF
 
      LET tm.pmm905='N'
 
      INPUT BY NAME tm.pmm905  WITHOUT DEFAULTS  
 
         AFTER FIELD pmm905
            IF NOT cl_null(tm.pmm905) THEN 
               IF tm.pmm905 NOT MATCHES '[YN]' THEN
                  NEXT FIELD pmm905
               END IF
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
     
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
      
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION exit  #加離開功能genero
            LET INT_FLAG = 1
            EXIT INPUT
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END INPUT
 
      IF INT_FLAG THEN 
         LET INT_FLAG=0
         EXIT WHILE
      END IF
 
      IF NOT cl_sure(0,0) THEN
         CONTINUE WHILE
      END IF
 
      CALL p801_p2()
 
      CALL s_showmsg()       #No.FUN-710030
      IF g_success = 'Y' THEN 
         COMMIT WORK
         CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
      ELSE
         ROLLBACK WORK
         CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
      END IF
 
      DROP TABLE p801_file
 
      IF g_flag THEN
         CONTINUE WHILE
      ELSE
         EXIT WHILE
      END IF
 
   END WHILE
 
END FUNCTION
 
FUNCTION p801_p2()
   DEFINE l_oea       RECORD LIKE oea_file.*
   DEFINE l_oeb       RECORD LIKE oeb_file.*
   DEFINE l_pmm       RECORD LIKE pmm_file.*
   DEFINE l_pmn       RECORD LIKE pmn_file.*
   DEFINE l_occ       RECORD LIKE occ_file.*
   DEFINE l_pmc       RECORD LIKE pmc_file.*
   DEFINE l_pox       RECORD LIKE pox_file.*
   DEFINE l_pow       RECORD LIKE pow_file.*
   DEFINE l_gec       RECORD LIKE gec_file.*
   DEFINE l_ima       RECORD LIKE ima_file.*
   DEFINE l_pmo       RECORD LIKE pmo_file.*   #FUN-570252
   DEFINE l_sql       LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(1200)
   DEFINE l_sql1      LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(600)
   DEFINE l_sql2      STRING                 #No.FUN-670007 VARCHAR(1600)
   DEFINE i,l_i       LIKE type_file.num5    #No.FUN-680136 SMALLINT
   DEFINE o_pox05     LIKE pox_file.pox05     #計價方式
   DEFINE diff_azi    LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)  #若為Y表示單身計價方式有所不同
          l_cnt       LIKE type_file.num5,    #No.FUN-680136 SMALLINT
          azi_pox05   LIKE pox_file.pox05,   #記錄單頭該用之計價方式
          min_oeb15   LIKE oeb_file.oeb15    #記錄該訂單之最小預交日
   DEFINE l_j         LIKE type_file.num5,    #No.FUN-680136 SMALLINT
          l_msg       LIKE ze_file.ze03       #No.FUN-680136 VARCHAR(60)
   DEFINE l_occ02     LIKE occ_file.occ02,
          l_occ04     LIKE occ_file.occ04,     #負責業務員代號 #MOD-BA0172 add
          l_occ08     LIKE occ_file.occ08,
          l_occ11     LIKE occ_file.occ11,
          l_occ43     LIKE occ_file.occ43,
          l_occ44     LIKE occ_file.occ44,
          l_occ45     LIKE occ_file.occ45,
          l_azf10     LIKE azf_file.azf10,     #No.FUN-6B0065
          l_oea1013   LIKE oea_file.oea1013,
          l_oea1014   LIKE oea_file.oea1014,
          l_price     LIKE oeb_file.oeb13,
          l_no        LIKE type_file.num5,      #No.FUN-680136 SMALLINT
          l_no1       LIKE type_file.num5,      #No.FUN-680136 SMALLINT
          l_currm     LIKE pmm_file.pmm42,
          l_curr      LIKE pmm_file.pmm22       #No.FUN-680136 VARCHAR(04)
   DEFINE l_flag      LIKE type_file.num5       #MOD-810016 modify chr1       #No.FUN-680136 VARCHAR(1)
   DEFINE l_x         LIKE poy_file.poy37   #No.FUN-680136 VARCHAR(05)             #FUN-620025
   DEFINE l_oea_t1    LIKE poy_file.poy34   #No.FUN-680136 VARCHAR(05)             #FUN-620025
   DEFINE l_pmm_t1    LIKE poy_file.poy38   #No.FUN-680136 VARCHAR(05)             #FUN-620025
   DEFINE l_unit      LIKE gfe_file.gfe01   #No.FUN-680136  VARCHAR(04)   #FUN-620025
   DEFINE li_result   LIKE type_file.num5               #FUN-620025   #No.FUN-680136 SMALLINT
   DEFINE l_stu_p     LIKE type_file.chr1   #No.FUN-680136 VARCHAR(01)             #FUN-620025
   DEFINE l_stu_o     LIKE type_file.chr1   #No.FUN-680136 VARCHAR(01)             #FUN-620025
   DEFINE l_stu_p_h   LIKE type_file.chr1   #MOD-780027 add                           
   DEFINE l_stu_o_h   LIKE type_file.chr1   #MOD-780027 add
   DEFINE u_pmm       RECORD LIKE pmm_file.*   #No.FUN-660051
   DEFINE u_pmn       RECORD LIKE pmn_file.*   #No.FUN-660051
   DEFINE n_oea       RECORD LIKE oea_file.*   #No.FUN-660051
   DEFINE n_oeb       RECORD LIKE oeb_file.*   #No.FUN-660051
   DEFINE n_pmm       RECORD LIKE pmm_file.*   #No.FUN-660051
   DEFINE n_pmn       RECORD LIKE pmn_file.*   #No.FUN-660051
   DEFINE l_source    LIKE type_file.num5      #No.FUN-680136 SMALLINT                 #No.FUN-660051
   DEFINE l_poy04     LIKE poy_file.poy04      #No.FUN-660051
   DEFINE l_dbs_now_tra   LIKE type_file.chr21     #FUN-980092
   DEFINE l_dbs_up_tra    LIKE type_file.chr21     #FUN-980092
   DEFINE l_dbs_last_tra  LIKE type_file.chr21     #FUN-980092
   DEFINE l_dbs_now   LIKE type_file.chr21     #No.FUN-680136 VARCHAR(21)                 #No.FUN-660051
   DEFINE l_dbs_up    LIKE type_file.chr21     #No.FUN-680136 VARCHAR(21)                 #No.FUN-660051
   DEFINE l_dbs_last  LIKE type_file.chr21     #No.FUN-680136 VARCHAR(21)                 #No.FUN-660051
   DEFINE l_oea61     LIKE oea_file.oea61      #No.FUN-660051
   DEFINE l_oea1008   LIKE oea_file.oea1008    #No.FUN-660051
   DEFINE l_pmm40     LIKE pmm_file.pmm40      #No.FUN-660051
   DEFINE l_pmm40t    LIKE pmm_file.pmm40t     #No.FUN-660051
   DEFINE l_poy02     LIKE poy_file.poy02      #NO.FUN-670007
   DEFINE k           LIKE type_file.num5      #NO.FUN-670007
   DEFINE l_flag1     LIKE type_file.chr1      #No.TQC-7C0023
   DEFINE l_pmni      RECORD LIKE pmni_file.*  #No.FUN-830132
   DEFINE l_oebi      RECORD LIKE oebi_file.*  #No.FUN-830132
   DEFINE l_fac2      LIKE img_file.img21      #MOD-980009     #第二轉換率
   DEFINE l_qty2      LIKE img_file.img10      #MOD-980009     #第二數量
   DEFINE l_fac1      LIKE img_file.img21      #MOD-980009     #第一轉換率
   DEFINE l_qty1      LIKE img_file.img10      #MOD-980009     #第一數量
   DEFINE l_tot       LIKE img_file.img10      #MOD-980009     #計價數量
   DEFINE l_factor    LIKE ima_file.ima31_fac  #MOD-980009
   DEFINE l_plant     LIKE azp_file.azp01      #FUN-980006 add
   DEFINE l_legal     LIKE azw_file.azw02      #FUN-980006 add
   DEFINE l_plant_last  LIKE type_file.chr10   #FUN-980020
   DEFINE l_plant_up    LIKE type_file.chr10   #FUN-980020
   DEFINE l_poy05     LIKE poy_file.poy05      #FUN-8C0110
   DEFINE l_oaz201    LIKE oaz_file.oaz201     #CHI-960078
   DEFINE l_success   LIKE type_file.chr1      #No.FUN-A30056
   DEFINE l_plant_now LIKE azp_file.azp01      #FUN-A50102   
   DEFINE l_ruo14     LIKE ruo_file.ruo14      #FUN-AA0023
#  DEFINE l_oia07     LIKE oia_file.oia07      #FUN-C50136
   DEFINE l_pmn13_max LIKE pmn_file.pmn13      #FUN-D20036 add
   DEFINE l_pod01     LIKE pod_file.pod01      #CHI-D60041 add
 
   CALL cl_wait() 
   LET l_stu_p_h=' ' #MOD-780027 add
   LET l_stu_o_h=' ' #MOD-780027 add

   #No.FUN-A30056  --Begin
   IF NOT g_InTransaction THEN
      CREATE TEMP TABLE p801_file(
           p_no     LIKE type_file.num5,  
           so_no    LIKE pmm_file.pmm01,
           so_item  LIKE type_file.num5,  
           so_price LIKE oeb_file.oeb13,
           so_price2 LIKE pmn_file.pmn31t, #TQC-D40086 add
           so_curr  LIKE pmm_file.pmm22)
      DELETE FROM p801_file
   END IF
   #No.FUN-A30056  --End 
        
   #讀取符合條件之三角貿易採購單資料
  #LET l_sql= "SELECT * FROM pmm_file ",                            #No.FUN-A10099
  #LET l_sql= "SELECT * FROM ",g_from_dbs_tra CLIPPED,"pmm_file ",  #No.FUN-A10099    #FUN-A50102 mark
   LET l_sql= "SELECT * FROM ",cl_get_target_table(g_from_plant,'pmm_file'),          #FUN-A50102
              " WHERE pmm901='Y' ",
              "   AND pmm905='",tm.pmm905,"' ",
              "   AND pmm18 = 'Y' ",     #已確認之採購單才可轉
              "   AND pmm25 = '2' ",     #已發出之採購單才可轉
              "   AND pmm902='N' ",      #非最終採購單
              "   AND pmm906='Y' ",      #三角貿易來源採購單否
              "   AND ",tm.wc CLIPPED
 
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql                 #FUN-A50102
   CALL cl_parse_qry_sql(l_sql,g_from_plant) RETURNING l_sql    #FUN-A50102
   PREPARE p801_p1 FROM l_sql 
   IF SQLCA.sqlcode  THEN 
      CALL cl_err('prepare',STATUS,1)
      LET g_success = 'N'
      RETURN 
   END IF
 
   DECLARE p801_curs1 CURSOR FOR p801_p1
   IF SQLCA.sqlcode  THEN 
      CALL cl_err('declare',STATUS,1)
      LET g_success = 'N'
      RETURN 
   END IF
 
   #No.FUN-A30056  --Begin
   IF NOT g_InTransaction THEN
      LET g_success = 'Y'
      BEGIN WORK
      CALL s_showmsg_init()
   END IF
   #No.FUN-A30056  --End

   LET l_flag1 = 'Y'             #No.TQC-7C0023
   FOREACH p801_curs1 INTO g_pmm.*
      LET l_flag1 = 'N'    #No.TQC-7C0023
      IF SQLCA.sqlcode  THEN 
         IF g_bgerr THEN
            CALL s_errmsg("","","foreach",STATUS,1)
         ELSE
            CALL cl_err3("","","","",STATUS,"","foreach",1)
         END IF
         LET g_success = 'N'
         EXIT FOREACH 
      END IF
      IF g_success="N" THEN
         LET g_totsuccess="N"
         LET g_success="Y"
      END IF
 
      #讀取三角貿易流程代碼資料
      SELECT * INTO g_poz.* FROM poz_file
       WHERE poz01 = g_pmm.pmm904
         AND poz00 = '2'
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         IF g_bgerr THEN
            LET g_showmsg = g_pmm.pmm904,"/","2"
            CALL s_errmsg("poz01,poz00",g_showmsg,"","axm-318",1)
            CONTINUE FOREACH
         ELSE
            CALL cl_err3("sel","poz_file",g_pmm.pmm904,"2","axm-318","","",1)
            EXIT FOREACH
         END IF
      END IF
 
      IF g_poz.pozacti = 'N' THEN 
         LET g_success = 'N'
         IF g_bgerr THEN
            CALL s_errmsg("","",g_pmm.pmm904,"tri-009",1)
            CONTINUE FOREACH
         ELSE
            CALL cl_err3("","","","","tri-009","",g_pmm.pmm904,1)
            EXIT FOREACH
         END IF
      END IF
 
#NO.FUN-670007 --搬到抓取站別裡面去作業
#      #如果采用自動編號，則抓取單別資料
 
      CALL p801_flow99()                    #No.8083 取得多角序號
 
      CALL s_mtrade_last_plant(g_pmm.pmm904) 
                     RETURNING p_last,p_last_plant  #記錄最後一筆之家數
 
      #依流程代碼最多6層
      FOR i = 1 TO p_last
         INITIALIZE g_poy.* TO NULL     #FUN-670007
         INITIALIZE s_poy.* TO NULL     #FUN-670007
         CALL p801_azp(i)               #得到廠商/客戶代碼及database
         CALL p801_azi(p_azi01t)         #讀取幣別資料 #MOD-630099 mod#應讀取的是當站幣別的資料 
 
         LET l_plant = g_poy.poy04                  #FUN-980006 add
         CALL s_getlegal(l_plant) RETURNING l_legal #FUN-980006 add
         #新增訂單單頭檔(oea_file)(by 下游廠商,即P/O廠商)
         #新增之database為l_dbs_new
          INITIALIZE l_oea.* TO NULL
 
         #FUN-620025--begin--
         IF l_aza.aza50 = 'Y' THEN    
            IF NOT cl_null(p_poy29) THEN 
               LET l_oea.oea00 = '6'
            ELSE 
               LET l_oea.oea00 = '1'
            END IF
            LET l_oea.oea1001 = p_oea03     #客戶編號
            LET l_oea.oea1002 = p_poy33     #債權代碼
            LET l_oea.oea1003 = p_poy27     #業績歸屬方
            LET l_oea.oea1004 = p_poy29     #代送商 
            LET l_oea.oea1005 = p_poy26     #是否計算業績
            LET l_oea.oea1006 = 0           #折扣金額(未稅)
            LET l_oea.oea1007 = 0           #折扣金額(含稅)
            LET l_oea.oea1008 = 0           #訂單總含稅金額
            LET l_oea.oea1012 ='N'          #自提否 
            LET l_oea.oea1013 = 0           #重量
            LET l_oea.oea1014 = 0           #體積
         ELSE
            LET l_oea.oea00 = '1'
         END IF
 
      LET k = i + 1 
      #如果采用自動編號，則抓取單別資料
      IF g_pod.pod04 = 'N' THEN
         LET g_t1 = g_pmm.pmm01[1,g_doc_len] 
         CALL s_mutislip('3','2',g_t1,g_poz.poz01,i)   #多傳入一個站別參數
               RETURNING g_sw,l_oea_t1,l_x,l_x,l_x,l_x  #抓取單別資料(S/O) 
         #No.FUN-A10123 ...begin
         IF g_azw.azw04 = '2' THEN
            IF cl_null(l_oea_t1) THEN
              #CALL p801_def_no(l_dbs_tra,'axm','30') RETURNING l_oea_t1        #FUN-A50102 mark
               CALL p801_def_no(l_plant_new,'axm','30') RETURNING l_oea_t1      #FUN-A50102
            END IF
         END IF
         #No.FUN-A10123 ...end
         LET g_msg = l_dbs_tra CLIPPED,l_oea_t1 CLIPPED  #FUN-980092
         IF cl_null(l_oea_t1) THEN
             IF g_bgerr THEN
                CALL s_errmsg("","",g_msg,'apm1011',1)
             ELSE
                CALL cl_err3("","","","",'apm1011',"",g_msg,1)
             END IF
             LET g_success = 'N'
             EXIT FOREACH
         ELSE                                                                                                                   
             LET l_cnt = 0                                                                                                       
            #LET l_sql = "SELECT COUNT(*) FROM ",l_dbs_new,"oay_file ",                         #FUN-A50102 mark
             LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new,'oay_file'),   #FUN-A50102                                                       
                         " WHERE oayslip = '",l_oea_t1,"'"                                                                         
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql                 #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql     #FUN-A50102
             PREPARE oay_pre1 FROM l_sql                                                                                         
             EXECUTE oay_pre1 INTO l_cnt                                                                                         
             IF l_cnt = 0 THEN                                                                                                   
                LET g_msg = l_dbs_new CLIPPED,l_oea_t1 CLIPPED                                                                     
                IF g_bgerr THEN
                   CALL s_errmsg("","",g_msg,'axm-931',1)
                ELSE
                   CALL cl_err3("","","","",'axm-931',"",g_msg,1)                                                                 
                END IF
                LET g_success = 'N'                                                                                              
                EXIT FOREACH                                                                                                     
             END IF                                                                                                              
         END IF
         IF g_sw THEN
            LET g_success = 'N'
            EXIT FOREACH
         END IF
         IF i <> p_last THEN
             CALL s_mutislip('3','2',g_t1,g_poz.poz01,k)   #多傳入一個站別參數
                   RETURNING g_sw,l_x,l_pmm_t1,l_x,l_x,l_x  #抓取單別資料(P/O) 
             #No.FUN-A10123 ...begin
             IF g_azw.azw04 = '2' THEN
                IF cl_null(l_pmm_t1) THEN
                 # CALL p801_def_no(l_dbs_tra,'apm','2') RETURNING l_pmm_t1         #FUN-A50102 mark
                   CALL p801_def_no(l_plant_new,'apm','2') RETURNING l_pmm_t1       #FUN-A50102  
                END IF
             END IF
             #No.FUN-A10123 ...end
             LET g_msg = l_dbs_tra CLIPPED,l_pmm_t1 CLIPPED  #FUN-980092 
             IF cl_null(l_pmm_t1) THEN
                 IF g_bgerr THEN
                    CALL s_errmsg("","",g_msg,'apm1010',1)
                 ELSE
                    CALL cl_err3("","","","",'apm1010',"",g_msg,1)
                 END IF
                 LET g_success = 'N'
                 EXIT FOREACH
             END IF
             IF g_sw THEN
                LET g_success = 'N'
                IF g_bgerr THEN
                   CONTINUE FOREACH
                ELSE
                   EXIT FOREACH
                END IF
             END IF
         ELSE
             CALL s_mutislip('3','2',g_t1,g_poz.poz01,i)   #多傳入一個站別參數
                   RETURNING g_sw,l_x,l_pmm_t1,l_x,l_x,l_x  #抓取單別資料(P/O) 
             #No.FUN-A10123 ...begin
             IF g_azw.azw04 = '2' THEN
                IF cl_null(l_pmm_t1) THEN
                 # CALL p801_def_no(l_dbs_tra,'apm','2') RETURNING l_pmm_t1     #FUN-A50102 mark
                   CALL p801_def_no(l_plant_new,'apm','2') RETURNING l_pmm_t1   #FUN-A50102
                END IF
             END IF
             #No.FUN-A10123 ...end
             LET g_msg = l_dbs_tra CLIPPED,l_pmm_t1 CLIPPED  #FUN-980092 
             IF cl_null(l_pmm_t1) THEN
                 IF g_bgerr THEN
                    CALL s_errmsg("","",g_msg,'apm1010',1)
                 ELSE
                    CALL cl_err3("","","","",'apm1010',"",g_msg,1)
                 END IF
                 LET g_success = 'N'
                 EXIT FOREACH
             END IF
             IF g_sw THEN
                LET g_success = 'N'
                IF g_bgerr THEN
                   CONTINUE FOREACH
                ELSE
                   EXIT FOREACH
                END IF
             END IF
         END IF
      END IF
         IF g_pod.pod04='N' THEN
            CALL s_auto_assign_no("AXM",l_oea_t1,g_pmm.pmm04,"30","oea_file","oea01",l_plant_new,"","")   #FUN-980092 
                        RETURNING li_result,l_oea.oea01
            IF (NOT li_result) THEN                                                                                                       
               #No.FUN-A30056  --Begin 
               LET g_msg = l_plant_new CLIPPED,l_pmm_t1 CLIPPED             
               IF g_bgerr THEN
                  CALL s_errmsg("","",g_msg,'mfg3046',1)
               ELSE                                                                                   
                  CALL cl_err(l_oea_t1,'mfg3046',1)  #MOD-810209 add
               END IF
               #No.FUN-A30056  --End
               LET g_success='N' #MOD-770155 add
               RETURN
            END IF          
         ELSE
            LET l_oea.oea01 = g_pmm.pmm01
         END IF
 
         LET l_oea.oea02 = g_pmm.pmm04   #訂單日期.
         LET l_oea.oea03 = p_oea03       #帳款客戶編號
         LET l_oea.oea06 = g_pmm.pmm03   #修改版本  #MOD-770098 add
         CALL p801_oea03(l_plant_new,l_oea.oea03)   #FUN-980092  
               RETURNING l_occ02,l_occ04,l_occ08,l_occ11,l_occ43,l_occ44,l_occ45,#MOD-BA0172 add l_occ04 
                         l_oea.oea1010,l_oea.oea1009,l_oea.oea1011         #FUN-620025
         LET l_oea.oea032=l_occ02        #帳款客戶簡稱
         LET l_oea.oea033=l_occ11        #帳款客戶統一編號
            LET l_oea.oea04 =l_oea.oea03
         LET l_oea.oea05=p_poy12         #No.8083
         LET l_oea.oea07='N'             #出貨是否計入未開發票的銷貨待驗收入 
         LET l_oea.oea08='2'  
         LET l_sql1 = "SELECT oaz201 ",
                    # " FROM ",l_dbs_new CLIPPED,"oaz_file ",                   #FUN-A50102 mark
                      " FROM ",cl_get_target_table(l_plant_new,'oaz_file'),     #FUN-A50102
                      " WHERE oaz00='0' "
         CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1                  
         CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1    #FUN-A50102
         PREPARE oaz_p1 FROM l_sql1
         DECLARE oaz_c1 CURSOR FOR oaz_p1
         OPEN oaz_c1
         FETCH oaz_c1 INTO l_oaz201
         IF cl_null(l_oaz201) THEN LET l_oaz201=0 END IF
        #LET l_oea.oea09=  l_oaz201   #FUN-D20036 mark
        #FUN-D20036---add---S
         SELECT MAX(pmn13) INTO l_pmn13_max FROM pmn_file
          WHERE pmn01 = g_pmm.pmm01
         IF cl_null(l_pmn13_max) THEN LET l_pmn13_max = 0 END IF #TQC-D70095 add
         LET l_oea.oea09 = l_pmn13_max
        #FUN-D20036---add---E
         LET l_oea.oea10=g_pmm.pmm01     #客戶訂單單號
         LET l_oea.oea11='6'             #訂單來源(代採買三角貿易)
        #MOD-BA0172 mark --start--
        #LET l_oea.oea14=g_user
        #LET l_oea.oea15=g_grup
        #MOD-BA0172 mark --end--
        #MOD-BA0172 add --start--
         LET l_oea.oea14=l_occ04         #負責業務員
         LET l_oea.oea15=''              #部門
         IF NOT cl_null(l_oea.oea14) THEN
            LET l_sql = "SELECT gen03 ", 
                        " FROM ",cl_get_target_table(l_plant_new,'gen_file'),                                                   
                        " WHERE gen01 ='",l_oea.oea14,"'"                                                                     
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql
            PREPARE gen_p FROM l_sql
            EXECUTE gen_p INTO l_oea.oea15
            IF cl_null(l_oea.oea15) THEN LET l_oea.oea15='' END IF
         END IF
        #MOD-BA0172 add --end--
         LET l_oea.oea161=0              #訂金比例
         LET l_oea.oea162=100            #出貨比例
         LET l_oea.oea163=0              #尾款比例
         LET l_oea.oea17=l_oea.oea03     #收款客戶編號
         LET l_oea.oea20='Y'             #是否直送客戶
         LET l_oea.oea21= p_poy08        #稅別
         LET l_oea.oea31= l_occ44        #價格條件
         IF cl_null(p_poy10)  THEN
            LET g_success = 'N' 
            LET g_msg=l_dbs_tra CLIPPED,l_oea.oea01 CLIPPED  #FUN-980092
            CALL s_errmsg('','',g_msg CLIPPED,"mfg4100",1)
         END IF 
         LET l_oea.oea25= p_poy10        #No.8083 
         LET l_oea.oea32= p_poy07        #No.8083
         LET l_oea.oea18='N'             #TQC-760152
         LET l_oea.oea37='N'             #TQC-760152
 
         #讀取稅別資料
         LET l_sql1 = "SELECT * ",
                    # " FROM ",l_dbs_new CLIPPED,"gec_file ",                 #FUN-A50102 mark
                      " FROM ",cl_get_target_table(l_plant_new,'gec_file'),   #FUN-A50102
                      " WHERE gec01='",l_oea.oea21,"' ",
                      "   AND gec011='2' "    #依銷項
 
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1               #FUN-920032
         CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1   #FUN-A50102
         PREPARE gec_p2 FROM l_sql1
         IF STATUS THEN
            LET g_success = 'N'  #No.FUN-8A0086
            IF g_bgerr THEN
               CALL s_errmsg("","","gec_p2",STATUS,1)
            ELSE
               CALL cl_err3("","","","",STATUS,"","gec_p2",1)
            END IF
         END IF
 
         DECLARE gec_c2 CURSOR FOR gec_p2
 
         OPEN gec_c2
 
         FETCH gec_c2 INTO l_gec.*                          #No.8825
         IF NOT ( i = p_last AND cl_null(g_pmm.pmm50)) THEN #最終站不檢查
            IF SQLCA.SQLCODE THEN
               LET g_msg=l_dbs_new CLIPPED,l_oea.oea21 CLIPPED  #FUN-980092
               LET g_success = 'N'
               IF g_bgerr THEN
                  CALL s_errmsg("","",g_msg,"mfg3044",1)
               ELSE
                  CALL cl_err3("","","","","mfg3044","",g_msg,1)
               END IF
            END IF
            CLOSE gec_c2
         END IF
 
         IF l_gec.gec04 IS NULL THEN
            LET l_gec.gec04=0
         END IF
 
         LET l_oea.oea211 = l_gec.gec04   #稅率
         LET l_oea.oea212 = l_gec.gec05   #聯數
         LET l_oea.oea213 = l_gec.gec07   #含稅否
         LET l_oea.oea23 = p_azi01t       #幣別
 
         #判斷是否為本幣
         IF l_oea.oea23 <> l_aza.aza17 THEN
            #CHI-D60041 -- add start --
            CALL p801_pod01(l_plant_new)
               RETURNING l_pod01
            #CHI-D60041 -- add end --
            #注意database必須為s_azp.azp03
            CALL s_currm(l_oea.oea23,l_oea.oea02,l_pod01,l_plant_new)   #FUN-980020   #CHI-D60041 modify g_pod.pod01 -> l_pod01
               RETURNING l_oea.oea24
         ELSE
            LET l_oea.oea24=1
         END IF
 
         IF l_oea.oea24 IS NULL THEN
            LET l_oea.oea24 = 1
         END IF
 
         LET l_oea.oea49='1'            #狀態
         LET l_oea.oea50='N'            #CSD(CKD/SKD)
         LET l_oea.oea61=0              #訂單總未稅金額
         LET l_oea.oea62=0              #已出貨未稅金額
         LET l_oea.oea63=0              #被結案未稅金額
         LET l_oea.oea65='N'            #客戶出貨簽收否   #FUN-7B0091 add
         LET l_oea.oea72=g_today        #首次確認日
         LET l_oea.oea99=g_flow99       #多角序號 No.8083
         LET l_oea.oea901='Y'           #三角貿易否. 'Y'
 
         IF i = p_last THEN             #FUN-670007
            LET l_oea.oea902='Y'        #是否為最終訂單
         ELSE
            LET l_oea.oea902='N'
         END IF
 
         LET l_oea.oea903 = g_pmm.pmm903
         LET l_oea.oea904 = g_pmm.pmm904
         LET l_oea.oea905='Y'           #拋轉否
         LET l_oea.oea906='N'           #是否為三角貿易之起始訂單
         LET l_oea.oea911 = g_pmm.pmm911
         LET l_oea.oea912 = g_pmm.pmm912
         LET l_oea.oea913 = g_pmm.pmm913
         LET l_oea.oea914 = g_pmm.pmm914
         LET l_oea.oea915 = g_pmm.pmm915
         LET l_oea.oea916 = g_pmm.pmm916
         LET l_oea.oeamksg='N'          #是否簽核
         LET l_oea.oeasign=' '          #簽核等級
         LET l_oea.oeadays=0            #簽核完成天數
         LET l_oea.oeaprit=0            #簽核優先等級
         LET l_oea.oeasseq=0            #已簽人數
         LET l_oea.oeasmax=0            #應簽人數
         LET l_oea.oeaconf='Y'          #確認否
         LET l_oea.oeaprsw=0            #訂單列印次數
         LET l_oea.oeauser=g_user       #資料所有者
         LET l_oea.oeagrup=g_grup       #資料所有部門
         LET l_oea.oeamodu=null         #資料修改者
         LET l_oea.oeadate=null         #最近修改日
         LET l_oea.oeaud01 = g_pmm.pmmud01
         LET l_oea.oeaud02 = g_pmm.pmmud02
         LET l_oea.oeaud03 = g_pmm.pmmud03
         LET l_oea.oeaud04 = g_pmm.pmmud04
         LET l_oea.oeaud05 = g_pmm.pmmud05
         LET l_oea.oeaud06 = g_pmm.pmmud06
         LET l_oea.oeaud07 = g_pmm.pmmud07
         LET l_oea.oeaud08 = g_pmm.pmmud08
         LET l_oea.oeaud09 = g_pmm.pmmud09
         LET l_oea.oeaud10 = g_pmm.pmmud10
         LET l_oea.oeaud11 = g_pmm.pmmud11
         LET l_oea.oeaud12 = g_pmm.pmmud12
         LET l_oea.oeaud13 = g_pmm.pmmud13
         LET l_oea.oeaud14 = g_pmm.pmmud14
         LET l_oea.oeaud15 = g_pmm.pmmud15
         #No.FUN-A10123 ...begin
         #IF g_azw.azw04 = '2' THEN #MOD-B30127 mark
            LET l_oea.oea83 =  l_plant
            LET l_oea.oea84 =  l_plant
            LET l_oea.oeaconu = g_user
            LET l_oea.oeacont = TIME   
         #END IF                    #MOD-B30127 mark
         LET l_oea.oea85 = '2'
         #No.FUN-A10123 ...end
   
         #針對每一符合條件之採購單轉成該廠之S/O
         #新增採購單單頭檔(pmm_file)
         INITIALIZE l_pmm.* TO NULL
         LET l_pmm.* = g_pmm.*
         IF NOT ( i = p_last AND cl_null(g_pmm.pmm50))  #最終站不檢查  #MOD-810209 add
           OR  ( i = p_last AND NOT cl_null(g_pmm.pmm50))  THEN        #MOD-810209 add
         IF g_pod.pod04= 'N' THEN
            IF  i = p_last THEN
              LET l_pmm_t1=''     #MOD-810209 add    
              SELECT poy35 INTO l_pmm_t1
                FROM poy_file
               WHERE poy01 = g_poz.poz01
                 AND poy02 = 99
            END IF
            IF STATUS THEN  
               #No.FUN-A30056  --Begin
               IF g_bgerr THEN
                  LET g_showmsg = g_poz.poz01,'/99'
                  CALL s_errmsg('poy01,poy02',g_showmsg,'select poy35','apm1010',1)
               ELSE
                  CALL cl_err(l_pmm_t1,'apm1010',1)
               END IF
               #No.FUN-A30056  --End 
               LET g_success='N' 
               RETURN
            END IF     
            CALL s_auto_assign_no("APM",l_pmm_t1,g_pmm.pmm04,"2","pmm_file","pmm01",l_plant_new,"","")     #MOD-740199
               RETURNING li_result,l_pmm.pmm01
            IF (NOT li_result) THEN                                                                                                       
               #No.FUN-A30056  --Begin 
               IF g_bgerr THEN
                  LET g_msg = l_plant_new CLIPPED,l_pmm_t1 CLIPPED
                  CALL s_errmsg('','',g_msg,'mfg3046',1)
               ELSE                                                                                                   
                  CALL cl_err(l_pmm_t1,'mfg3046',1)  #MOD-810209 add
               END IF
               #No.FUN-A30056  --End
               LET g_success='N' #MOD-770155 add
               RETURN
            END IF           
         ELSE
            LET l_pmm.pmm01=g_pmm.pmm01
         END IF
         END IF         #MOD-810209 add
         LET l_pmm.pmm02= 'TAP'           #單據性質
   
         #No.8083 若為逆拋且有最終供應商，
         #則採購單為一般採購單
         IF g_poz.poz011 = '2' AND i = p_last THEN
            LET l_pmm.pmm02 = 'REG'
         END IF
   
        #LET l_pmm.pmm03=0                #更動序號  #MOD-C70213 mark
         LET l_pmm.pmm03=g_pmm.pmm03      #更動序號  #MOD-C70213
         LET l_pmm.pmm04=g_pmm.pmm04      #採購日期
         LET l_pmm.pmm05=null             #專案號碼
         LET l_pmm.pmm06=null             #預算號碼
         LET l_pmm.pmm07=null             #單據分類
         LET l_pmm.pmm08=null             #PBI 批號
         IF i = p_last THEN LET p_pmm09 = g_pmm.pmm50 END IF
         LET l_pmm.pmm09=p_pmm09          #供應廠商
         #說明, 送貨地址存訂單單號, 在P/O列印時可以此反抓S/O資料
        #MOD-C70073---mark-S---
        #LET l_pmm.pmm10=g_pmm.pmm10       #送貨地址  #MOD-8B0063 
        #LET l_pmm.pmm11=null              #帳單地址
        #MOD-C70073---mark-E---
         LET l_pmm.pmm12= g_pmm.pmm12      #採購員
         LET l_pmm.pmm13= g_pmm.pmm13      #採購部門
         LET l_pmm.pmm14= ' '              #收貨部門
         LET l_pmm.pmm15= g_user           #確認人
         LET l_pmm.pmm16= g_pmm.pmm16      #運送方式
         LET l_pmm.pmm17=null              #代理商
         LET l_pmm.pmm18='Y'               #確認碼
 
         #讀取廠商相關資料
         LET l_sql1 = "SELECT * ",
                    # " FROM ",l_dbs_new CLIPPED,"pmc_file ",               #FUN-A50102 mark
                      " FROM ",cl_get_target_table(l_plant_new,'pmc_file'), #FUN-A50102 
                      " WHERE pmc01='",l_pmm.pmm09,"'"
 
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1                 #FUN-920032
         CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1     #FUN-A50102
         PREPARE pmc_p1 FROM l_sql1
         IF STATUS THEN
            LET g_success = 'N'  #No.FUN-8A0086
            IF g_bgerr THEN
               CALL s_errmsg("","","pmc_p1",STATUS,1)
            ELSE
               CALL cl_err3("","","","",STATUS,"","pmc_p1",1)
            END IF
         END IF
 
         DECLARE pmc_c1 CURSOR FOR pmc_p1
 
         OPEN pmc_c1
         FETCH pmc_c1 INTO l_pmc.* 
 
         IF NOT ( i = p_last AND cl_null(g_pmm.pmm50)) THEN     #最終站不檢查
            IF SQLCA.SQLCODE = 100 THEN
               LET g_msg = l_dbs_tra CLIPPED,l_pmm.pmm09 CLIPPED #FUN-980092  
               LET g_success = 'N'
               IF g_bgerr THEN
                  CALL s_errmsg("","",g_msg,"mfg3001",1)
                  CONTINUE FOR
               ELSE
                  CALL cl_err3("","","","","mfg3001","",g_msg,1)
                  EXIT FOR
               END IF
            END IF
 
            CLOSE pmc_c1
 
            IF cl_null(l_pmc.pmc49) THEN
               LET g_msg = l_dbs_tra CLIPPED,l_pmm.pmm09 CLIPPED  #FUN-980092 
               LET g_success = 'N'
               IF g_bgerr THEN
                  CALL s_errmsg("","",g_msg,"tri-010",1)
                  CONTINUE FOR
               ELSE
                  CALL cl_err3("","","","","tri-010","",g_msg,1)
                  EXIT FOR
               END IF
            END IF
         END IF
   
         IF i <> p_last THEN
            LET l_pmm.pmm20=p_poy06         #付款方式.
            LET l_pmm.pmm21=p_poy09         #稅別.
         ELSE
            LET l_pmm.pmm20=l_pmc.pmc17     #付款方式. ???
            LET l_pmm.pmm21=l_pmc.pmc47     #稅別. ???
         END IF
 
         #因為必須以計價方式來判斷幣別,故先給訂單幣別,單身新增完後再給
         IF i <> p_last THEN
            LET l_pmm.pmm22 = p_azi01       #幣別???
         ELSE
            LET l_pmm.pmm22 = l_pmc.pmc22   #幣別???
         END IF

        #MOD-C70073---S---
         LET l_pmm.pmm10=l_pmc.pmc15       #送貨地址
         LET l_pmm.pmm11=l_pmc.pmc16       #帳單地址
        #MOD-C70073---E--- 
         LET l_pmm.pmm25= '2'            #狀況碼. '2'(發出採購單)
         LET l_pmm.pmm26=null            #理由碼. null ???
         LET l_pmm.pmm27=null            #狀況異動日期. null 
         LET l_pmm.pmm28=null            #會計分類. null
         LET l_pmm.pmm29=null            #會計科目. null ???
         LET l_pmm.pmm30='N'             #驗收單列印否 . 'N'
 
         #讀取會計年度, 期間 
         LET l_sql1 = " SELECT azn02,azn04 ",
                    # "   FROM ",l_dbs_new CLIPPED,"azn_file ",                 #FUN-A50102 mark
                      "   FROM ",cl_get_target_table(l_plant_new,'azn_file'),   #FUN-A50102
                      "  WHERE azn01='",l_pmm.pmm04,"' "
 
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1              #FUN-920032
         CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1   #FUN-A50102
         PREPARE azn_p1 FROM l_sql1
         IF STATUS THEN
            LET g_success = 'N'  #No.FUN-8A0086
            IF g_bgerr THEN
               CALL s_errmsg("","","azn_p1",STATUS,1)
            ELSE
               CALL cl_err3("","","","",STATUS,"","azn_p1",1)
            END IF
         END IF
 
         DECLARE azn_c1 CURSOR FOR azn_p1
 
         OPEN azn_c1
         FETCH azn_c1 INTO l_pmm.pmm31,l_pmm.pmm32
         CLOSE azn_c1
 
         LET l_pmm.pmm40=0                #總金額.  l_tot_pmm40
         LET l_pmm.pmm401=0               #代買總金額. 0
         LET l_pmm.pmm40t=0               #含稅總金額. 0   #FUN-620025  
         LET l_pmm.pmm41=l_pmc.pmc49      #價格條件. ???
         LET l_pmm.pmm42=1                #匯率. 在單身結束後再判斷
 
         #讀取稅別資料
         LET l_sql1 = "SELECT * ",
                    # "  FROM ",l_dbs_new CLIPPED,"gec_file ",                 #FUN-A50102 mark
                      "  FROM ",cl_get_target_table(l_plant_new,'gec_file'),   #FUN-A50102
                      " WHERE gec01='",l_pmm.pmm21,"' ",
                      "   AND gec011='1' "    #依進項
 
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1             #FUN-920032
         CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-A50102
         PREPARE gec_p1 FROM l_sql1
         IF STATUS THEN
            LET g_success = 'N'  #No.FUN-8A0086
            IF g_bgerr THEN
               CALL s_errmsg("","","gec_p1",STATUS,1)
            ELSE
               CALL cl_err3("","","","",STATUS,"","gec_p1",1)
            END IF
         END IF
 
         DECLARE gec_c1 CURSOR FOR gec_p1
 
         OPEN gec_c1
         FETCH gec_c1 INTO l_gec.*
 
         IF SQLCA.SQLCODE 
             AND NOT ( i = p_last AND cl_null(g_pmm.pmm50)) THEN #MOD-490455
            LET g_msg=l_dbs_tra CLIPPED,l_pmm.pmm21 CLIPPED  #FUN-980092 
            LET g_success = 'N'
            IF g_bgerr THEN
               CALL s_errmsg("","",g_msg,"mfg3044",1)
               CONTINUE FOREACH
            ELSE
               CALL cl_err3("","","","","mfg3044","",g_msg,1)
               EXIT FOREACH
            END IF
         END IF
 
         CLOSE gec_c1
 
         IF l_gec.gec04 IS NULL THEN
            LET l_gec.gec04=0
         END IF
   
         LET l_pmm.pmm43 = l_gec.gec04        #稅率
         LET l_pmm.pmm44 = '1'                #稅處理.1發票扣抵 ???  NO.TQC-650127
         LET l_pmm.pmm45 =g_pmm.pmm45         #可用                  #MOD-830134-modify
         LET l_pmm.pmm46 =0                   #預付比率
         LET l_pmm.pmm47 =0                   #預付金額. 
         LET l_pmm.pmm48=0               #已結帳金額
         LET l_pmm.pmm49='N'             #預付發票否(Y/N) 
         LET l_pmm.pmm99 = g_flow99      #多角序號        No.8083
         LET l_pmm.pmm50= g_pmm.pmm50    #最終流程供應商  No.6215
         LET l_pmm.pmm901='Y'
         IF i = p_last THEN
            LET l_pmm.pmm902 = 'Y'
         ELSE
            LET l_pmm.pmm902 = 'N'
         END IF
         LET l_pmm.pmm903=g_pmm.pmm903
         LET l_pmm.pmm904=g_pmm.pmm904
         LET l_pmm.pmm905='Y'
         LET l_pmm.pmm906='N'
         LET l_pmm.pmm911=g_pmm.pmm911
         LET l_pmm.pmm912=g_pmm.pmm912
         LET l_pmm.pmm913=g_pmm.pmm913
         LET l_pmm.pmm914=g_pmm.pmm914
         LET l_pmm.pmm915=g_pmm.pmm915
         LET l_pmm.pmm916=g_pmm.pmm916
         LET l_pmm.pmm909 = "1"              #No.FUN-630006
         LET l_pmm.pmmprsw = 'N'           #列印抑制. 'N' or 'Y' 
         LET l_pmm.pmmprno = 0             #已列印次數. 0
         LET l_pmm.pmmprdt = null          #最後列印日期.null
         LET l_pmm.pmmmksg = 'N'           #是否簽核. 'N' ???
         LET l_pmm.pmmsign = null          #簽核等級. null
         LET l_pmm.pmmdays = 0             #簽核完成天數. 0
         LET l_pmm.pmmprit = 0             #簽核優先等級. 0
         LET l_pmm.pmmsseq = 0             #已簽核順序. 0
         LET l_pmm.pmmsmax = 0             #應簽核順序. 0
         LET l_pmm.pmmacti = 'Y'           #資料有效碼. 'Y' 
         LET l_pmm.pmmuser = g_user        #資料所有者. g_user
         LET l_pmm.pmmgrup = g_grup        #資料所有部門. g_grup
         LET l_pmm.pmmmodu = null          #資料修改者. null
         LET l_pmm.pmmdate = null          #最近修改日. null
         LET l_pmm.pmmcrat = g_today       #TQC-A30054 
         #No.FUN-A10123 ...begin
         #IF g_azw.azw04 = '2' THEN    #MOD-B30127 mark
            LET l_pmm.pmm51 = g_pmm.pmm51
            LET l_pmm.pmm52 = g_pmm.pmm52
            LET l_pmm.pmm53 = g_pmm.pmm53
            LET l_pmm.pmmcond = g_today
            LET l_pmm.pmmcont = TIME 
            LET l_pmm.pmmconu = g_user
         #END IF                       #MOD-B30127 mark
         IF cl_null(l_pmm.pmm51) THEN LET l_pmm.pmm51 = '1' END IF
         #No.FUN-A10123 ...end
   
         #判斷幣別
         CALL p801_azi(l_pmm.pmm22)   #讀取幣別資料
 
         #pmm42匯率.
         #判斷是否為本幣
         IF l_pmm.pmm22 <> l_aza.aza17 THEN
            #CHI-D60041 -- add start --
            CALL p801_pod01(l_plant_new)
               RETURNING l_pod01
            #CHI-D60041 -- add end --
            #注意database必須為s_azp.azp03
            CALL s_currm(l_pmm.pmm22,l_pmm.pmm04,l_pod01,l_plant_new)  #FUN-980020   #CHI-D60041 modify g_pod.pod01 -> l_pod01
               RETURNING l_pmm.pmm42
         ELSE
            LET l_pmm.pmm42 = 1
         END IF
 
         IF l_pmm.pmm42 IS NULL THEN
            LET l_pmm.pmm42 = 1
         END IF
         
         LET l_cnt = 0
         LET diff_azi = 'N'
 
         #讀取採購單單身檔(pmn_file)
         LET l_sql = "SELECT *  ",
#                    "  FROM pmn_file ",                            #No.FUN-A10099
#                    "  FROM ",g_from_dbs_tra CLIPPED,"pmn_file ",  #No.FUN-A10099   #FUN-A50102 mark
                     "  FROM ",cl_get_target_table(g_from_plant,'pmn_file'),         #FUN-A50102  
                     " WHERE pmn01 = '",g_pmm.pmm01,"' "
               
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql                        #FUN-A50102 
         CALL cl_parse_qry_sql(l_sql,g_from_plant) RETURNING l_sql           #FUN-A50102
         PREPARE pmn_per1 FROM l_sql
         DECLARE pmn_cus CURSOR FOR pmn_per1
 
         FOREACH pmn_cus INTO g_pmn.* 
            IF SQLCA.SQLCODE <> 0 THEN
               EXIT FOREACH 
            END IF 
 
            LET l_cnt = l_cnt + 1
 
            IF l_aza.aza50='N' THEN     #FUN-620025   
               #CHI-CC0033 -- add start --
               IF g_poz.poz12 ='Y' THEN
                  LET p_pox03 = '1'
                  LET p_pox05 = 'O'
                  LET p_pox06 = ''
                  LET p_cnt = 1

               ELSE
               #CHI-CC0033 -- add end --
                  #讀取該料號之計價方式(依流程代碼+生效日期+廠商)
                  CALL s_pox(g_pmm.pmm904,i,g_pmn.pmn33)
                   RETURNING p_pox03,p_pox05,p_pox06,p_cnt
 
                  IF p_cnt = 0 THEN
                     LET g_success = 'N'
                     IF g_bgerr THEN
                        CALL s_errmsg("","","","tri-007",1)
                        CONTINUE FOREACH
                     ELSE
                        CALL cl_err3("","","","","tri-007","","",1)
                        EXIT FOREACH
                     END IF
                  END IF
               END IF   #CHI-CC0033 add   
               IF l_cnt=1 THEN
                  LET min_oeb15 = g_pmn.pmn33
                  LET o_pox05 = p_pox05
               END IF   
 
               #判斷單身之計價方式是否有不同 
               IF o_pox05 <> p_pox05 THEN
                  LET diff_azi='Y'
               END IF
 
               LET o_pox05=p_pox05
 
               #記錄最小預計交貨日之計價方式(單頭幣別之依據)
               IF g_pmn.pmn33 < min_oeb15 THEN
                  LET min_oeb15 = g_pmn.pmn33
                  LET azi_pox05 = p_pox05
               END IF
            END IF                               #FUN-620025
 
            #新增採購單單身檔(pmn_file)
            INITIALIZE l_pmn.* TO NULL
            LET l_pmn.* = g_pmn.*
            LET l_pmn.pmn01=l_pmm.pmm01     #采購單號  #FUN-620025   
            LET l_pmn.pmn011=l_pmm.pmm02    #單據性質
            LET l_pmn.pmn02=g_pmn.pmn02     #項次
            LET l_pmn.pmn03=' '             #詢價單號
            LET l_pmn.pmn04=g_pmn.pmn04     #料件編號
            LET l_pmn.pmn041=g_pmn.pmn041   #品名規格
            LET l_pmn.pmn05=' '             #APS單據編號
            LET l_pmn.pmn06=' '             #廠商料件編號
            LET l_pmn.pmn07=g_pmn.pmn07     #採購單位
 
            #讀取料件基本資料
            IF l_pmn.pmn04[1,4] = 'MISC' THEN 
               LET g_cnt = 0
               LET l_sql1 = "SELECT COUNT(*) ",
                          # "  FROM ",l_dbs_new CLIPPED,"ima_file ",                       #FUN-A50102 mark
                            "  FROM ",cl_get_target_table(l_plant_new,'ima_file'),         #FUN-A50102    
                            " WHERE ima01 = 'MISC' " 
 
 	       CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1                 #FUN-920032
               CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1     #FUN-A50102
               PREPARE imamisc2_p1 FROM l_sql1
               IF STATUS THEN 
                  LET g_success = 'N'  #No.FUN-8A0086
                  IF g_bgerr THEN
                    CALL s_errmsg("","","imamisc2_p1",STATUS,1)
                  ELSE
                    CALL cl_err3("","","","",STATUS,"","imamisc2_p1",1)
                  END IF
               END IF
               DECLARE imamisc2_c1 CURSOR FOR imamisc2_p1
 
               OPEN imamisc2_c1
               FETCH imamisc2_c1 INTO g_cnt
               IF g_cnt = 0 THEN
                  LET g_msg=l_dbs_tra CLIPPED,l_pmn.pmn04 CLIPPED   #FUN-980092
                  IF g_bgerr THEN
                     CALL s_errmsg("","",g_msg,"aim-806",1)
                  ELSE
                     CALL cl_err3("","","","","aim-806","",g_msg,1)
                  END IF
                  LET g_success = 'N'
               END IF
            ELSE
            LET l_sql1 = "SELECT * ",
                       # "  FROM ",l_dbs_new CLIPPED,"ima_file ",                   #FUN-A50102 mark
                         "  FROM ",cl_get_target_table(l_plant_new,'ima_file'),      #FUN-A50102
                         " WHERE ima01='",l_pmn.pmn04,"' " 
 
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1                    #FUN-920032
         CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1        #FUN-A50102
            PREPARE ima_p1 FROM l_sql1
            IF STATUS THEN
               LET g_success = 'N'  #No.FUN-8A0086 
               IF g_bgerr THEN
                  CALL s_errmsg("","","pmn_p1",STATUS,1)
               ELSE
                  CALL cl_err3("","","","",STATUS,"","pmn_p1",1)
               END IF
            END IF
 
            DECLARE ima_c1 CURSOR FOR ima_p1
 
            OPEN ima_c1
            FETCH ima_c1 INTO l_ima.*
 
            IF SQLCA.SQLCODE THEN
               LET g_msg=l_dbs_tra CLIPPED,l_pmn.pmn04 CLIPPED  #FUN-980092 
               IF g_bgerr THEN
                  CALL s_errmsg("","",g_msg,"mfg3403",1)
               ELSE
                  CALL cl_err3("","","","","mfg3403","",g_msg,1)
               END IF
               LET g_success = 'N'
            END IF
 
            CLOSE ima_c1
            END IF    #MOD-890251 add
 
            LET l_pmn.pmn08=l_ima.ima25    #庫存單位
            IF l_pmn.pmn08 IS NULL OR l_pmn.pmn08=' ' THEN
               LET l_pmn.pmn08 = l_pmn.pmn07
            END IF
 
            #轉換因子. 
            LET g_sw = 0
            IF l_pmn.pmn04[1,4] = 'MISC' OR l_pmn.pmn07 = l_pmn.pmn08 THEN  #MOD-760016 modify
               LET l_pmn.pmn09=1
            ELSE
               CALL s_umfchkm(l_pmn.pmn04,l_pmn.pmn07,l_pmn.pmn08,l_plant_new)   #FUN-980092 
                    RETURNING g_sw,l_pmn.pmn09
            END IF
 
            IF g_sw THEN
               LET g_msg = l_dbs_tra CLIPPED,' ',l_pmn.pmn04 CLIPPED  #FUN-980092
               IF g_bgerr THEN
                  CALL s_errmsg("","",g_msg,"mfg1206",1)
               ELSE
                  CALL cl_err3("","","","","mfg1206","",g_msg,1)
               END IF
               LET g_success = 'N'
            END IF
 
            IF l_pmn.pmn09 IS NULL THEN
               LET l_pmn.pmn09 = 1
            END IF
 
            LET l_pmn.pmn10= null             #BUGNo.4757 pmn10改為NO USE
            LET l_pmn.pmn11='N'               #凍結碼
            LET l_pmn.pmn121=1                #轉換因子. 1
            LET l_pmn.pmn122=null             #No use. null
            LET l_pmn.pmn123=null             #廠牌. null
           #LET l_pmn.pmn13=0                 #超/短交限率 #FUN-D20036 mark
            LET l_pmn.pmn14=g_sma.sma886[1,1] #部份交貨(Y/N)
            LET l_pmn.pmn15=g_sma.sma886[2,2] #提前交貨(Y/N)
            LET l_pmn.pmn16=l_pmm.pmm25       #狀況碼 同單頭
            LET l_pmn.pmn18=null              #MRP需求日期
            LET l_pmn.pmn20=g_pmn.pmn20       #採購量
            LET l_pmn.pmn23=' '               #送貨地址
            LET l_pmn.pmn24=' '               #請購單號
            LET l_pmn.pmn25=' '               #請購單號項次
            LET l_pmn.pmnud01 = g_pmn.pmnud01
            LET l_pmn.pmnud02 = g_pmn.pmnud02
            LET l_pmn.pmnud03 = g_pmn.pmnud03
            LET l_pmn.pmnud04 = g_pmn.pmnud04
            LET l_pmn.pmnud05 = g_pmn.pmnud05
            LET l_pmn.pmnud06 = g_pmn.pmnud06
            LET l_pmn.pmnud07 = g_pmn.pmnud07
            LET l_pmn.pmnud08 = g_pmn.pmnud08
            LET l_pmn.pmnud09 = g_pmn.pmnud09
            LET l_pmn.pmnud10 = g_pmn.pmnud10
            LET l_pmn.pmnud11 = g_pmn.pmnud11
            LET l_pmn.pmnud12 = g_pmn.pmnud12
            LET l_pmn.pmnud13 = g_pmn.pmnud13
            LET l_pmn.pmnud14 = g_pmn.pmnud14
            LET l_pmn.pmnud15 = g_pmn.pmnud15
            IF ( i = p_last AND NOT cl_null(l_pmm.pmm50)) THEN
               IF l_sma.sma116 MATCHES '[02]' THEN    
                  #LET l_pmn.pmn86 = NULL      #MOD-C50189 mark
                  LET l_pmn.pmn86=l_pmn.pmn07  #MOD-C50189 add
                  LET l_pmn.pmn87=l_pmn.pmn20  #MOD-C50189 add
               ELSE
                  LET l_pmn.pmn86 = l_ima.ima908
               END IF
	    ELSE
               LET l_pmn.pmn86 = g_pmn.pmn86     #FUN-620025--move here
            END IF
            LET l_pmn.pmn30=g_pmn.pmn31*g_pmm.pmm42  #標準價格. (S/O本幣)
 
            #單價. 
            IF l_aza.aza50='Y' THEN
               IF l_sma.sma116<>'0' THEN
                  LET l_unit = l_pmn.pmn86
               ELSE
                  LET l_unit = l_pmn.pmn07
               END IF
               IF i <> p_last THEN
                     CALL s_fetch_price2(g_poy.poy03,l_pmn.pmn04,l_unit,l_pmm.pmm04,'4',l_plant_next,l_pmm.pmm22)  #No.FUN-980059
#                              RETURNING l_x,l_pmn.pmn31,g_success   #No.FUN-A30056
                               RETURNING l_x,l_pmn.pmn31,l_success   #No.FUN-A30056
                     IF l_success ='N' THEN    #No.FUN-A30056    
                        LET g_success = 'N'    #No.FUN-A30056
                        #FUN-AA0023
                        LET g_showmsg = l_plant_next,"+",g_poy.poy03,"+",l_pmn.pmn04,"+",l_pmn.pmn01,"+",l_pmm.pmm04,"+",l_pmm.pmm22
                        IF g_bgerr THEN
                           #CALL s_errmsg("","","","axm-043",1)
                           CALL s_errmsg("l_plant_next,g_poy.poy03,l_pmn.pmn04,l_pmn.pmn01,l_pmm.pmm04,l_pmm.pmm22",g_showmsg,"","axm-043",1)
                             #FUN-AA0023
                        ELSE
                           CALL cl_err3("","","","","axm-043","","",1)
                        END IF
                     END IF 
               END IF
               LET l_pmn.pmn31t= l_pmn.pmn31 * (1+ l_pmm.pmm43/100)
               IF cl_null(l_pmn.pmn86) THEN
                  LET l_pmn.pmn87=l_pmn.pmn20
               END IF
            ELSE
            #計價方式來判斷
               CASE p_pox05
                  WHEN '1'
                     IF p_pox03='1' THEN   #依來源工廠 
                        IF g_pmm.pmm22 = l_pmm.pmm22 THEN
                           LET l_pmn.pmn31 = g_pmn.pmn31 * p_pox06/100
                        END IF
                        IF g_pmm.pmm22 <> l_pmm.pmm22 THEN
                           LET l_price = g_pmn.pmn31 * g_pmm.pmm42 #換算回本幣
                           #CHI-D60041 -- add start --
                           CALL p801_pod01(g_from_plant)
                              RETURNING l_pod01
                           #CHI-D60041 -- add end --
                           ##已來源廠的匯率計算
                           CALL s_currm(l_pmm.pmm22,g_pmm.pmm04,
                           #            g_pod.pod01,t_plant) #NO.FUN-980020  #No.FUN-A10099
                                        l_pod01,g_from_plant)                #No.FUN-A10099   #CHI-D60041 modify g_pod.pod01 -> l_pod01
                                RETURNING l_currm
                           LET l_pmn.pmn31= l_price / l_currm * p_pox06 / 100
                        END IF
                        IF cl_null(l_azi.azi03) THEN 
                           LET l_azi.azi03=5
                        END IF
                        CALL cl_digcut(l_pmn.pmn31,l_azi.azi03) 
                                  RETURNING l_pmn.pmn31
                     ELSE
                        #依上游廠商計算, 先讀取S/O價格
                        IF i=1 THEN
                            IF g_pmm.pmm22 = l_pmm.pmm22 THEN
                                LET l_pmn.pmn31 = g_pmn.pmn31 * p_pox06/100
                            END IF
                            IF g_pmm.pmm22 <> l_pmm.pmm22 THEN
                                LET l_price = g_pmn.pmn31 * g_pmm.pmm42#換算回本幣
                                #CHI-D60041 -- add start --
                                CALL p801_pod01(g_from_plant)
                                   RETURNING l_pod01
                                #CHI-D60041 -- add end --
                                ##已來源廠的匯率計算
                                CALL s_currm(l_pmm.pmm22,g_pmm.pmm04,
                                            #g_pod.pod01,l_plant_new) #NO.FUN-980020   #MOD-AC0416
                                            l_pod01,g_from_plant) #NO.FUN-980020       #MOD-AC0416   #CHI-D60041 modify g_pod.pod01 -> l_pod01
                                    RETURNING l_currm
                                    LET l_pmn.pmn31= l_price/l_currm*p_pox06/100
                            END IF
                        ELSE
                            LET l_no = i-1
                            SELECT so_price,so_curr INTO l_price,l_curr
                              FROM p801_file
                             WHERE p_no = l_no
                               AND so_no = g_pmm.pmm01
                               AND so_item=g_pmn.pmn02
                            IF l_curr != l_pmm.pmm22 THEN
                                #CHI-D60041 -- add start --
                                CALL p801_pod01(l_plant_new)
                                   RETURNING l_pod01
                                #CHI-D60041 -- add end --
                                CALL s_currm(l_curr,g_pmm.pmm04,l_pod01,l_plant_new) #NO.FUN-980020   #CHI-D60041 modify g_pod.pod01 -> l_pod01 
                                     RETURNING l_currm
                                LET l_price =l_price * l_currm #換算回本幣
                                CALL s_currm(l_pmm.pmm22,g_pmm.pmm04,l_pod01,                         #CHI-D60041 modify g_pod.pod01 -> l_pod01
                                             l_plant_new) RETURNING l_currm  #NO.FUN-980020
                                LET l_pmn.pmn31 = l_price / l_currm
                                                 * p_pox06/100
                            ELSE
                                 LET l_pmn.pmn31= l_price*p_pox06/100
                            END IF
                        END IF  
                     END IF
                     CALL cl_digcut(l_pmn.pmn31,l_azi.azi03) 
                                    RETURNING l_pmn.pmn31
                  WHEN '2'
                     #讀取合乎料件條件之價格
                     CALL s_pow(g_pmm.pmm904,g_pmn.pmn04,n_poy.poy04,g_pmn.pmn33) #CHI-950040
                            RETURNING g_sw,l_pmn.pmn31
                      IF g_sw='N' THEN
                         IF g_pod.pod02 = 'N' AND i <> p_last THEN	#MOD-990144
                            LET g_success = 'N'	#MOD-960228 remark
                            IF g_bgerr THEN
                               CALL s_errmsg("","","sel pow.","axm-333",1)
                            ELSE
                               CALL cl_err3("","","","","axm-333","","sel pow.",1)
                            END IF
                         END IF
                         LET l_pmn.pmn31 =0 
                      END IF
                  WHEN '3'   #單價若為0, 則給0, 否則抓料件之固定價格
                      IF g_pmn.pmn31 <> 0 THEN        #no.6215
                         CALL s_pow(g_pmm.pmm904,g_pmn.pmn04,n_poy.poy04,g_pmn.pmn33)  #CHI-950040
                            RETURNING g_sw,l_pmn.pmn31
                         IF g_sw='N' THEN
                            IF g_pod.pod02 = 'N' AND i <> p_last THEN	#MOD-990144
                               IF g_bgerr THEN
                                  CALL s_errmsg("","","sel pow.","axm-333",1)
                               ELSE
                                  CALL cl_err3("","","","","axm-333","","sel pow.",1)
                               END IF
                               LET g_success = 'N'
                            END IF
                           LET l_pmn.pmn31 = 0
                         END IF
                      ELSE
                         LET l_pmn.pmn31 = 0
                      END IF
                #CHI-CC0033 -- add start --
                WHEN 'O'    #兩角的
                      LET l_pmn.pmn31 =g_pmn.pmn31
                #CHI-CC0033 -- add end --
               END CASE
               IF l_pmn.pmn31 IS NULL THEN LET l_pmn.pmn31 =0 END IF
               LET l_pmn.pmn31t=l_pmn.pmn31 * (1+l_pmm.pmm43/100) #no.7259
            END IF
 
            #若為最后一站有外購
            IF ( i = p_last AND NOT cl_null(l_pmm.pmm50)) THEN
               LET l_pmm.pmm09=l_pmm.pmm50
               LET l_poy05 = ' '                                                                                                    
               SELECT poy05 INTO l_poy05 FROM poy_file                                                                              
                WHERE poy01=g_poz.poz01                                                                                             
                  AND poy02=99                                                                                                      
               IF NOT cl_null(l_poy05) THEN                                                                                         
                  LET l_pmm.pmm22=l_poy05                                                                                           
                  #CHI-D60041 -- add start --
                  CALL p801_pod01(l_plant_new)
                     RETURNING l_pod01
                  #CHI-D60041 -- add end --
                  #MOD-BC0204 add --start--
                  CALL s_currm(l_pmm.pmm22,l_pmm.pmm04,l_pod01,l_plant_new)   #CHI-D60041 modify g_pod.pod01 -> l_pod01
                     RETURNING l_pmm.pmm42
                  #MOD-BC0204 add --end--
               END IF                                                                                                               
               #No.TQC-A60107  --Begin
               #CALL s_defprice1(l_pmn.pmn04, l_pmm.pmm09, l_pmm.pmm22, 
               #                 l_pmm.pmm04, l_pmn.pmn20,'',l_pmm.pmm21,
               #                 l_pmm.pmm43,l_plant_new,'1',g_pmn.pmn86,l_pmm.pmm41,l_pmm.pmm20,'') #NO.MOD-740509  #No.FUN-930148 add pmm41,pmm20,pmn86 #No.TQC-930026 Add ''
                CALL s_defprice_new(l_pmn.pmn04,l_pmm.pmm09,l_pmm.pmm22,
                                    l_pmm.pmm04,l_pmn.pmn20,'',l_pmm.pmm21,
                                    l_pmm.pmm43,'1',l_pmn.pmn86,'',
                                   l_pmm.pmm41,l_pmm.pmm20,l_plant_new)                
               #No.TQC-A60107  --End  
               RETURNING l_pmn.pmn31,l_pmn.pmn31t,
                         l_pmn.pmn73,l_pmn.pmn74   #TQC-AC0257 add
            END IF
 
            CALL cl_digcut(l_pmn.pmn31t,l_azi.azi03) RETURNING l_pmn.pmn31t #MOD-630099 add
            CALL cl_digcut(l_pmn.pmn31 ,l_azi.azi03) RETURNING l_pmn.pmn31  #MOD-630099 add
            LET l_pmn.pmn32=null
            LET l_pmn.pmn33=g_pmn.pmn33    #原始交貨日期
            LET l_pmn.pmn34=g_pmn.pmn34    #原始到廠日期
            LET l_pmn.pmn35=g_pmn.pmn35    #原始到庫日期
            LET l_pmn.pmn36=g_pmn.pmn36    #最近確認交貨日期
            LET l_pmn.pmn37=null           #最後一次到廠日期
            LET l_pmn.pmn38=g_pmm.pmm45    #可用/不可用    #MOD-830134-modify  #FUN-670007
            LET l_pmn.pmn40=l_ima.ima39                     #MOD-670044 pmn40會計科目改抓當站資料庫的ima39
            LET l_pmn.pmn41=null           #工單號碼
            LET l_pmn.pmn42='0'            #替代碼 
            LET l_pmn.pmn43=0              #作業序號
            LET l_pmn.pmn431=0             #下一站作業序號
            LET l_pmn.pmn44=l_pmn.pmn31 * l_pmm.pmm42  #本幣單價=單價*匯率 
            CALL cl_digcut(l_pmn.pmn44,l_azi.azi03) 
                 RETURNING l_pmn.pmn44
            LET l_pmn.pmn45=null           #NO.7190
            LET l_pmn.pmn46=null           #No Use
            LET l_pmn.pmn50=0              #交貨量
            LET l_pmn.pmn51=0              #在驗量
            LET l_pmn.pmn52=null           #倉庫
            LET l_pmn.pmn53=0              #入庫量
            LET l_pmn.pmn54=null           #儲位
            LET l_pmn.pmn55=0              #驗退量
           #IF g_sma.sma96 = 'Y' THEN      #FUN-C80001 #FUN-D30099 mark
            IF g_pod.pod08 = 'Y' THEN      #FUN-D30099
               LET l_pmn.pmn56=g_pmn.pmn56 #FUN-C80001
            ELSE                           #FUN-C80001
               LET l_pmn.pmn56=' '            #批號
            END IF                         #FUN-C80001
            LET l_pmn.pmn57=0              #超短交量
            LET l_pmn.pmn58=0              #倉退量
            LET l_pmn.pmn59=null           #退貨單號
            LET l_pmn.pmn60=null           #項次
            LET l_pmn.pmn61=l_pmn.pmn04    #被替代料號
            LET l_pmn.pmn62=1              #替代率
            LET l_pmn.pmn63='N'            #急料否
            LET l_pmn.pmn64='N'            #保稅否
            LET l_pmn.pmn65='1'            #代買性質
            IF ( i = p_last AND NOT cl_null(l_pmm.pmm50)) THEN
               IF cl_null(l_ima.ima44) THEN LET l_ima.ima44 = l_ima.ima25 END IF
               IF l_sma.sma115 = 'Y' THEN             
                  IF l_ima.ima906 = '1' THEN  #不使用雙單位
                     LET l_pmn.pmn83 = NULL
                     LET l_pmn.pmn84 = NULL
                     LET l_pmn.pmn85 = NULL
                  ELSE
                     LET l_pmn.pmn83 = l_ima.ima907
 #                   CALL s_du_umfchk(l_pmn.pmn04,'','','',l_ima.ima44,l_ima.ima907,l_ima.ima906)              #No.FUN-A10099
                     CALL s_du_umfchk1(l_pmn.pmn04,'','','',l_ima.ima44,l_ima.ima907,l_ima.ima906,l_plant_new) #No.FUN-A10099
                          RETURNING g_errno,l_pmn.pmn84
                     IF NOT cl_null(g_errno) THEN
                        #No.FUN-A30056  --Begin
                        IF g_bgerr THEN
                           CALL s_errmsg('','',l_pmn.pmn04,g_errno,1)
                        ELSE
                           CALL cl_err(l_ima.ima907,g_errno,1)  
                        END IF
                        #No.FUN-A30056  --End
                     END IF
                     LET l_pmn.pmn85  = 0
                  END IF
               
                  LET l_pmn.pmn80 = l_ima.ima44
                  LET l_pmn.pmn81 = 1
                  LET l_pmn.pmn82 = 0
                  LET l_fac2 = l_pmn.pmn84
                  LET l_qty2 = l_pmn.pmn85
                  LET l_fac1 = l_pmn.pmn81
                  LET l_qty1 = l_pmn.pmn82
               ELSE
                  LET l_fac1 = 1
                  LET l_qty1 = l_pmn.pmn20
               #  CALL s_umfchk(l_pmn.pmn04,l_pmn.pmn07,l_ima.ima44)               #No.FUN-A10099
                  CALL s_umfchkm(l_pmn.pmn04,l_pmn.pmn07,l_ima.ima44,l_plant_new)  #No.FUN-A10099
                        RETURNING g_cnt,l_fac1
                  IF g_cnt = 1 THEN
                     LET l_fac1 = 1
                  END IF
               END IF                
               IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
               IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
               IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
               IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
               
               IF l_sma.sma115 = 'Y' THEN
                  CASE l_ima.ima906
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
               #  CALL s_umfchk(l_pmn.pmn04,l_pmn.pmn07,l_pmn.pmn86)               #No.FUN-A10099
                  CALL s_umfchkm(l_pmn.pmn04,l_pmn.pmn07,l_pmn.pmn86,l_plant_new)  #No.FUN-A10099
                        RETURNING g_cnt,l_factor
               ELSE
               #  CALL s_umfchk(l_pmn.pmn04,l_ima.ima44,l_pmn.pmn86)               #No.FUN-A10099
                  CALL s_umfchkm(l_pmn.pmn04,l_ima.ima44,l_pmn.pmn86,l_plant_new)  #No.FUN-A10099
                        RETURNING g_cnt,l_factor
               END IF
               IF g_cnt = 1 THEN
                  LET l_factor = 1
               END IF
               IF g_pmn.pmn87 = 0 THEN
                  LET l_pmn.pmn87 = 0 
               ELSE
                  LET l_pmn.pmn87 = l_tot * l_factor
               END IF 
	    ELSE
               LET l_pmn.pmn80 = g_pmn.pmn80
               LET l_pmn.pmn81 = g_pmn.pmn81
               LET l_pmn.pmn82 = g_pmn.pmn82
               IF cl_null(l_pmn.pmn82) THEN 
                  LET l_pmn.pmn82 = 0 
               END IF 
               LET l_pmn.pmn83 = g_pmn.pmn83
               LET l_pmn.pmn84 = g_pmn.pmn84
               LET l_pmn.pmn85 = g_pmn.pmn85
               LET l_pmn.pmn87 = g_pmn.pmn87
            END IF 
            #No.FUN-A10123 ..begin
            #IF g_azw.azw04 = '2' THEN   #MOD-B30127 mark
               LET l_pmn.pmn72 = g_pmn.pmn72
               LET l_pmn.pmn73 = g_pmn.pmn73
               LET l_pmn.pmn74 = g_pmn.pmn74
               LET l_pmn.pmn75 = g_pmn.pmn75
               LET l_pmn.pmn76 = g_pmn.pmn76
               LET l_pmn.pmn77 = g_pmn.pmn77
            #END IF                      #MOD-B30127 mark
            IF cl_null(l_pmn.pmn73) THEN LET l_pmn.pmn73 = '4' END IF
            #No.FUN-A10123 ..end
            LET l_pmn.pmn919 = g_pmn.pmn919  #FUN-A80102
            #LET l_pmn.pmn88=l_pmn.pmn87*l_pmn.pmn31  #TQC-D40086 mark
            #LET l_pmn.pmn88t=l_pmn.pmn87*l_pmn.pmn31t  #TQC-D40086 mark
            #TQC-D40086 add begin--------------------------
            IF l_gec.gec07 = 'Y' THEN 
               LET l_pmn.pmn88t=l_pmn.pmn87*l_pmn.pmn31t
               LET l_pmn.pmn88 = l_pmn.pmn88t/(1+l_pmm.pmm43/100)
               LET l_pmn.pmn31 = l_pmn.pmn88/l_pmn.pmn87
               CALL cl_digcut(l_pmn.pmn31,l_azi.azi03)
                                RETURNING l_pmn.pmn31               
            ELSE 
               LET l_pmn.pmn88=l_pmn.pmn87*l_pmn.pmn31
               LET l_pmn.pmn88t = l_pmn.pmn88*(1+l_pmm.pmm43/100)
               LET l_pmn.pmn31t = l_pmn.pmn88t/l_pmn.pmn87
               CALL cl_digcut(l_pmn.pmn31t,l_azi.azi03)
                                RETURNING l_pmn.pmn31t               
            END IF    
            #TQC-D40086 add end----------------------------              
            CALL cl_digcut(l_pmn.pmn88,l_azi.azi04) RETURNING l_pmn.pmn88
            CALL cl_digcut(l_pmn.pmn88t,l_azi.azi04) RETURNING l_pmn.pmn88t
 
              SELECT poy46 INTO l_pmn.pmn930
                FROM poy_file
               WHERE poy01 = g_poz.poz01
                 AND poy02 = k
            LET l_pmn.pmn90 = l_pmn.pmn31    #NO.TQC-740104 
 
            CALL p801_iou(g_pmm.pmm99,tm.pmm905,'pmm')  #FUN-620025
                RETURNING l_stu_p                                 #FUN-620025
            IF cl_null(l_stu_p_h) THEN LET l_stu_p_h=l_stu_p END IF  #MOD-780027 add
            IF l_stu_p ='U' THEN LET l_stu_p_h='U' END IF            #MOD-780027 add
            IF NOT cl_null(g_pmm.pmm99) THEN  
             LET l_sql2 = "SELECT pmm01 ",                               
                        # " FROM ",l_dbs_tra CLIPPED,"pmm_file ",   #FUN-980092      #FUN-A50102 mark
                          " FROM ",cl_get_target_table(l_plant_new,'pmm_file'),      #FUN-A50102  
                          " WHERE pmm99= '",g_pmm.pmm99,"'"                   
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
             
             PREPARE pmm_p2 FROM l_sql2                                  
             IF SQLCA.SQLCODE THEN 
                #No.FUN-A30056  --Begin
                IF g_bgerr THEN
                   CALL s_errmsg('pmm99',g_pmm.pmm99,'select pmm01',SQLCA.sqlcode,1)
                ELSE
                   CALL cl_err('pmm_p1',SQLCA.sqlcode,1) 
                END IF
                #No.FUN-A30056  --End
             END IF
             DECLARE pmm_c2 CURSOR FOR pmm_p2                            
             OPEN pmm_c2                                                 
             FETCH pmm_c2 INTO l_pmn.pmn01                               
             CLOSE pmm_c2
            END IF                            
 
            #如果是最后一站且沒有委外，則不處理                   #FUN-620025
            IF ( i = p_last AND cl_null(g_pmm.pmm50)) THEN        #FUN-620025
               LET l_stu_p='A'                                    #FUN-620025
               LET l_stu_p_h='A'                                  #MOD-780027 add
            END IF                                                #FUN-620025
            IF l_stu_p='I' THEN       #FUN-620025
                IF NOT ( i = p_last AND cl_null(g_pmm.pmm50)) THEN
                    IF cl_null(l_pmn.pmn01) THEN LET l_pmn.pmn01 = ' ' END IF
                    IF cl_null(l_pmn.pmn02) THEN LET l_pmn.pmn02 = 0 END IF
                    LET l_pmn.pmn89 = 'N'                         #FUN-940083 add
                    #新增採購單身檔
                   #LET l_sql2 = "INSERT INTO ",l_dbs_tra CLIPPED,"pmn_file", #FUN-980092   #FUN-A50102 mark
                    LET l_sql2 = "INSERT INTO ",cl_get_target_table(l_plant_new,'pmn_file'),#FUN-A50102  
                                 "(pmn01 ,pmn011 ,pmn02 ,pmn03,",
                                 " pmn04 ,pmn041 ,pmn05 ,pmn06 ,",
                                 " pmn07 ,pmn08 ,pmn09 , pmn10,",
                                 " pmn11 ,pmn121 ,pmn122 ,pmn123 ,",
                                 " pmn13 ,pmn14 ,pmn15 ,pmn16 ,",
                                 " pmn18 ,pmn20 ,pmn23 ,pmn24,",
                                 " pmn25 ,pmn30 ,pmn31 ,pmn32 ,",
                                 " pmn33 ,pmn34 ,pmn35 ,pmn36,",
                                 " pmn37 ,pmn38 ,pmn40 ,pmn41,",
                                 " pmn42 ,pmn43 ,pmn431 ,pmn44,",
                                 " pmn45 ,pmn46 ,pmn50 ,pmn51,",
                                 " pmn52 ,pmn53 ,pmn54 ,pmn55,",
                                 " pmn56 ,pmn57 ,pmn58 ,pmn59,",
                                 " pmn60 ,pmn61 ,pmn62 ,pmn63,",
                                 " pmn64 ,pmn65 ,pmn31t ,pmn80,",  #FUN-560043
                                 " pmn81 ,pmn82 ,pmn83 ,pmn84,",   #FUN-560043
                                 " pmn85 ,pmn86 ,pmn87,pmn930," ,  #FUN-560043  #NO.FUN-670007 add pmn930
                                 " pmn88,pmn88t, " ,         #FUN-560043  #No.TQC-6A00840  #NO.TQC-740133 
                                 " pmn90,pmn89,pmnplant,pmnlegal,",
                                 " pmn72,pmn73,pmn74,pmn75,pmn76,pmn77,pmn919, ",  #No.FUN-A10123  #FUN-A80102
                                 " pmnud01,pmnud02,pmnud03,pmnud04,pmnud05,",   
                                 " pmnud06,pmnud07,pmnud08,pmnud09,pmnud10,",   
                                 " pmnud11,pmnud12,pmnud13,pmnud14,pmnud15)",   
                                 " VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                                 "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                                 "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                                 "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,",    #No.CHI-950020
                                 "         ?,?,?,?, ?,?,?, ",                       #No.FUN-A10123  #FUN-A80102
                                 "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,?, ?,?,?, ?,?)"    #FUN-560043  #No.TQC-6A0084 #FUN-940083 add ? #FUN-980006 add ?,? 
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2    #FUN-A50102
                    PREPARE ins_pmn FROM l_sql2
                    EXECUTE ins_pmn USING 
                                 l_pmn.pmn01 ,l_pmn.pmn011 ,l_pmn.pmn02 ,l_pmn.pmn03,
                                 l_pmn.pmn04 ,l_pmn.pmn041 ,l_pmn.pmn05 ,l_pmn.pmn06 ,
                                 l_pmn.pmn07 ,l_pmn.pmn08 ,l_pmn.pmn09 , l_pmn.pmn10,
                                 l_pmn.pmn11 ,l_pmn.pmn121 ,l_pmn.pmn122 ,l_pmn.pmn123 ,
                                 l_pmn.pmn13 ,l_pmn.pmn14 ,l_pmn.pmn15 ,l_pmn.pmn16 ,
                                 l_pmn.pmn18 ,l_pmn.pmn20 ,l_pmn.pmn23 ,l_pmn.pmn24,
                                 l_pmn.pmn25 ,l_pmn.pmn30 ,l_pmn.pmn31 ,l_pmn.pmn32 ,
                                 l_pmn.pmn33 ,l_pmn.pmn34 ,l_pmn.pmn35 ,l_pmn.pmn36,
                                 l_pmn.pmn37 ,l_pmn.pmn38 ,l_pmn.pmn40 ,l_pmn.pmn41,
                                 l_pmn.pmn42 ,l_pmn.pmn43 ,l_pmn.pmn431 ,l_pmn.pmn44,
                                 l_pmn.pmn45 ,l_pmn.pmn46 ,l_pmn.pmn50 ,l_pmn.pmn51,
                                 l_pmn.pmn52 ,l_pmn.pmn53 ,l_pmn.pmn54 ,l_pmn.pmn55,
                                 l_pmn.pmn56 ,l_pmn.pmn57 ,l_pmn.pmn58 ,l_pmn.pmn59,
                                 l_pmn.pmn60 ,l_pmn.pmn61 ,l_pmn.pmn62 ,l_pmn.pmn63,
                                 l_pmn.pmn64 ,l_pmn.pmn65 ,
                                 l_pmn.pmn31t,l_pmn.pmn80 ,l_pmn.pmn81 ,l_pmn.pmn82,
                                 l_pmn.pmn83 ,l_pmn.pmn84 ,l_pmn.pmn85 ,l_pmn.pmn86,
                                 l_pmn.pmn87 ,l_pmn.pmn930,l_pmn.pmn88,l_pmn.pmn88t,  #No.TQC-6A0084 
                                 l_pmn.pmn90 ,l_pmn.pmn89,l_plant,l_legal,  #NO.TQC-740104 #FUN-940083 add pmn89 #FUN-980006 add l_plant,l_legal 
                                 l_pmn.pmn72,l_pmn.pmn73,l_pmn.pmn74,l_pmn.pmn75,l_pmn.pmn76,l_pmn.pmn77,l_pmn.pmn919,  #No.FUN-A10123  #FUN-A80102
                                 l_pmn.pmnud01,l_pmn.pmnud02,l_pmn.pmnud03,     
                                 l_pmn.pmnud04,l_pmn.pmnud05,l_pmn.pmnud06,     
                                 l_pmn.pmnud07,l_pmn.pmnud08,l_pmn.pmnud09,     
                                 l_pmn.pmnud10,l_pmn.pmnud11,l_pmn.pmnud12,     
                                 l_pmn.pmnud13,l_pmn.pmnud14,l_pmn.pmnud15      
                    IF SQLCA.sqlcode<>0 THEN
                       LET g_success = 'N'
                       IF g_bgerr THEN
                          CALL s_errmsg("","","ins pmn.",SQLCA.sqlcode,1)
                       ELSE
                          CALL cl_err3("","","","",SQLCA.sqlcode,"","ins pmn.",1)
                       END IF
                    ELSE
                       IF NOT s_industry('std') THEN
                          INITIALIZE l_pmni.* TO NULL
                          LET l_pmni.pmni01 = l_pmn.pmn01
                          LET l_pmni.pmni02 = l_pmn.pmn02
                          IF NOT s_ins_pmni(l_pmni.*,l_plant_new) THEN   #FUN-980092 
                             LET g_success = "N"
                          END IF
                       END IF
                    END IF
                END IF
            ELSE
               #重新拋轉時,只針對訂單變更的欄位更新
               #更新採購單身檔
               IF l_stu_p='U' THEN                             #FUN-620025
                   IF NOT ( i = p_last AND cl_null(g_pmm.pmm50)) THEN
                       IF g_pod.pod04 = 'N' THEN
                           LET l_sql2 = "SELECT pmm01 ",
                                      # " FROM ",l_dbs_tra CLIPPED,"pmm_file ",                #FUN-A50102 mark
                                        " FROM ",cl_get_target_table(l_plant_new,'pmm_file'),  #FUN-A50102 
                                        " WHERE pmm99= '",g_pmm.pmm99,"'"
 	                   CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                           CALL cl_parse_qry_sql(l_sql2,l_plant_new)
                                RETURNING l_sql2 #FUN-980092
                           PREPARE pmm_p1 FROM l_sql2
                           IF SQLCA.SQLCODE THEN
                              #No.FUN-A30056  --Begin
                              IF g_bgerr THEN
                                 CALL s_errmsg('pmm99',g_pmm.pmm99,'pmm_p1',SQLCA.sqlcode,1)
                              ELSE
                                 CALL cl_err('pmm_p1',SQLCA.sqlcode,1) 
                              END IF
                              #No.FUN-A30056  --End
                           END IF
                           DECLARE pmm_c1 CURSOR FOR pmm_p1
                           OPEN pmm_c1
                           FETCH pmm_c1 INTO l_pmn.pmn01
                           CLOSE pmm_c1
                       END IF
                     # LET l_sql2="UPDATE ",l_dbs_tra CLIPPED,"pmn_file",  #FUN-980092   #FUN-A50102 mark
                       LET l_sql2="UPDATE ",cl_get_target_table(l_plant_new,'pmn_file'), #FUN-A50102 
                                  " SET pmn04 = ?,pmn041 = ? ,pmn07 = ? , ",
                                  "     pmn08 = ?,pmn09  = ? ,pmn20 = ? , ",
                                  "     pmn31 = ?,pmn33  = ? ,pmn34 = ? , ",
                                  "     pmn35 = ?,pmn36  = ? ,pmn44 = ? , ",
                                  "     pmn31t= ?,pmn80  = ? ,pmn81 = ? , ",   #FUN-560043
                                  "     pmn82 = ?,pmn83  = ? ,pmn84 = ? , ",   #FUN-560043
                                  "     pmn85 = ?,pmn86  = ? ,pmn87 = ? , ",     #FUN-560043   #NO.MOD-780213 少了一個逗號
                                  "     pmn88 = ?,pmn88t =? ",  #No.TQC-6A0084
                                  " WHERE pmn01=? AND pmn02=? "
                       CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                       CALL cl_parse_qry_sql(l_sql2,l_plant_new) 
                            RETURNING l_sql2 #FUN-980092
                       PREPARE upd_pmn FROM l_sql2
                       EXECUTE upd_pmn USING 
                                  l_pmn.pmn04 ,l_pmn.pmn041,l_pmn.pmn07 ,l_pmn.pmn08,
                                  l_pmn.pmn09 ,l_pmn.pmn20 ,l_pmn.pmn31 ,l_pmn.pmn33 ,
                                  l_pmn.pmn34 ,l_pmn.pmn35 ,l_pmn.pmn36 , l_pmn.pmn44,
                                  l_pmn.pmn31t,l_pmn.pmn80,l_pmn.pmn81,l_pmn.pmn82,   #FUN-560043
                                  l_pmn.pmn83,l_pmn.pmn84,l_pmn.pmn85,l_pmn.pmn86,    #FUN-560043
                                  l_pmn.pmn87,l_pmn.pmn88,l_pmn.pmn88t,   #FUN-560043  #No.TQC-6A0084
                                  l_pmn.pmn01 ,l_pmn.pmn02
                       IF SQLCA.sqlcode THEN
                          IF g_bgerr THEN
                             CALL s_errmsg("","","upd pmn.",SQLCA.sqlcode,1)
                          ELSE
                             CALL cl_err3("","","","",SQLCA.sqlcode,"","upd pmn.",1)
                          END IF
                           LET g_success = 'N'
                       END IF
                   END IF
               ELSE
                   IF l_stu_p='F' THEN                     #FUN-620025
                      IF g_bgerr THEN
                         CALL s_errmsg("","",g_pmm.pmm99,"apm-803",1)
                      ELSE
                         CALL cl_err3("","","","","apm-803","",g_pmm.pmm99,1)
                      END IF
                       LET g_success = 'N'                  #FUN-620025
                   END IF
               END IF
            END IF
          
            #採購單頭總金額
            #TQC-D40086 add begin--------
              #用單價*數量,容易造成尾差
              LET l_pmm.pmm40 = l_pmm.pmm40 + l_pmn.pmn88
              LET l_pmm.pmm40t= l_pmm.pmm40t + l_pmn.pmn88t
            #TQC-D40086 add end----------             
            #LET l_pmm.pmm40 = l_pmm.pmm40 + l_pmn.pmn31*l_pmn.pmn87  #No.TQC-6A0084 #TQC-D40086
                CALL cl_digcut(l_pmm.pmm40,l_azi.azi04) 
                               RETURNING l_pmm.pmm40
            #LET l_pmm.pmm40t = l_pmm.pmm40 * (1.00+l_pmm.pmm43 / 100.0)  #FUN-620025 #TQC-D40086
                CALL cl_digcut(l_pmm.pmm40t,l_azi.azi04) 
                               RETURNING l_pmm.pmm40t
   
               #新增訂單單身檔(oeb_file)(by 下游廠商,即P/O廠商)
               CALL p801_azi(p_azi01t)   #讀取當站幣別資料 #MOD-630099 add
         
              #讀取料件基本資料
              IF l_pmn.pmn04[1,4] = 'MISC' THEN 
                 LET g_cnt = 0
                 LET l_sql1 = "SELECT COUNT(*) ",
                            # "  FROM ",l_dbs_new CLIPPED,"ima_file ",                #FUN-A50102 mark
                              "  FROM ",cl_get_target_table(l_plant_new,'ima_file'),  #FUN-A50102
                              " WHERE ima01 = 'MISC' " 
 
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1              #FUN-920032
         CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1  #FUN-A50102
                 PREPARE imamisc_p1 FROM l_sql1
                 IF STATUS THEN 
                    LET g_success = 'N'  #No.FUN-8A0086
                    IF g_bgerr THEN
                      CALL s_errmsg("","","imamisc_p1",STATUS,1)
                    ELSE
                      CALL cl_err3("","","","",STATUS,"","imamisc_p1",1)
                    END IF
                 END IF
                 DECLARE imamisc_c1 CURSOR FOR imamisc_p1
 
                 OPEN imamisc_c1
                 FETCH imamisc_c1 INTO g_cnt
                 IF g_cnt = 0 THEN
                    LET g_msg=l_dbs_new CLIPPED,l_pmn.pmn04 CLIPPED
                    IF g_bgerr THEN
                       CALL s_errmsg("","",g_msg,"aim-806",1)
                    ELSE
                       CALL cl_err3("","","","","aim-806","",g_msg,1)
                    END IF
                    LET g_success = 'N'
                 END IF
              ELSE
              LET l_sql1 = "SELECT * ",
                         # "  FROM ",l_dbs_new CLIPPED,"ima_file ",               #FUN-A50102 mark
                           "  FROM ",cl_get_target_table(l_plant_new,'ima_file'), #FUN-A50102  
                           " WHERE ima01='",g_pmn.pmn04,"' " 
 
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1             #FUN-920032
         CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-A50102
              PREPARE ima_p11 FROM l_sql1
              IF STATUS THEN 
                 LET g_success = 'N'  #No.FUN-8A0086
                 IF g_bgerr THEN
                    CALL s_errmsg("","","pmn_p1",STATUS,1)
                 ELSE
                    CALL cl_err3("","","","",STATUS,"","pmn_p1",1)
                 END IF
              END IF
 
              DECLARE ima_c11 CURSOR FOR ima_p11
 
              OPEN ima_c11
              FETCH ima_c11 INTO l_ima.*
 
              IF SQLCA.SQLCODE THEN
                 LET g_msg=l_dbs_new CLIPPED,g_pmn.pmn04 CLIPPED
                 IF g_bgerr THEN
                    CALL s_errmsg("","",g_msg,"mfg3403",1)
                 ELSE
                    CALL cl_err3("","","","","mfg3403","",g_msg,1)
                 END IF
                 LET g_success = 'N'
              END IF
 
              CLOSE ima_c11
              END IF #MOD-890251 add
 
               INITIALIZE l_oeb.* TO NULL
               LET l_oeb.oeb01 = l_oea.oea01    #FUN-620025
               LET l_oeb.oeb03 = g_pmn.pmn02
               LET l_oeb.oeb04 = g_pmn.pmn04
               LET l_oeb.oeb05 = g_pmn.pmn07    #銷售單位同採購單位
               LET l_oeb.oebud01 = g_pmn.pmnud01
               LET l_oeb.oebud02 = g_pmn.pmnud02
               LET l_oeb.oebud03 = g_pmn.pmnud03
               LET l_oeb.oebud04 = g_pmn.pmnud04
               LET l_oeb.oebud05 = g_pmn.pmnud05
               LET l_oeb.oebud06 = g_pmn.pmnud06
               LET l_oeb.oebud07 = g_pmn.pmnud07
               LET l_oeb.oebud08 = g_pmn.pmnud08
               LET l_oeb.oebud09 = g_pmn.pmnud09
               LET l_oeb.oebud10 = g_pmn.pmnud10
               LET l_oeb.oebud11 = g_pmn.pmnud11
               LET l_oeb.oebud12 = g_pmn.pmnud12
               LET l_oeb.oebud13 = g_pmn.pmnud13
               LET l_oeb.oebud14 = g_pmn.pmnud14
               LET l_oeb.oebud15 = g_pmn.pmnud15 
               ##轉換因子#no.5079
               LET l_flag = 0                    #MOD-810016 add
               #IF l_oeb.oeb04[1,4] = 'MISC' OR l_oeb.oeb05 = g_pmn.pmn08 THEN  #MOD-760016 modify   #MOD-A80021
               IF l_oeb.oeb04[1,4] = 'MISC' OR l_oeb.oeb05 = l_ima.ima25 THEN  #MOD-760016 modify   #MOD-A80021
                   LET l_oeb.oeb05_fac = 1
               ELSE
                  #CALL s_umfchkm(l_oeb.oeb04,l_oeb.oeb05,g_pmn.pmn08,l_plant_new)  #FUN-980092    #MOD-A80021
                  CALL s_umfchkm(l_oeb.oeb04,l_oeb.oeb05,l_ima.ima25,l_plant_new)  #FUN-980092    #MOD-A80021
                  RETURNING l_flag,l_oeb.oeb05_fac
               END IF
               IF l_flag THEN
                  IF g_bgerr THEN
                     CALL s_errmsg("","",l_oeb.oeb04,"mfg1206",1)
                  ELSE
                     CALL cl_err3("","","","","mfg1206","",l_oeb.oeb04,1)
                  END IF
                  LET g_success = 'N'
               END IF
               IF cl_null(l_oeb.oeb05_fac) THEN 
                  LET l_oeb.oeb05_fac = 1
               END IF
               LET l_oeb.oeb06 = g_pmn.pmn041
               LET l_oeb.oeb08 =null    #出貨工廠
               IF l_aza.aza50='Y' THEN
                  IF NOT cl_null(p_poy11) THEN
                     LET l_oeb.oeb09=p_poy11
                  ELSE 
                     IF NOT cl_null(l_ima.ima35) THEN
                        LET l_oeb.oeb09=l_ima.ima35
                     ELSE
                        LET l_oeb.oeb09=null
                     END IF
                  END IF 
               ELSE
                 LET l_oeb.oeb09 =null    #出貨倉庫
               END IF
               LET l_oeb.oeb091=null    #出貨儲位
              #IF g_sma.sma96 = 'Y' THEN         #FUN-C80001 #FUN-D30099 mark
               IF g_pod.pod08 = 'Y' THEN         #FUN-D30099
                  LET l_oeb.oeb092=g_pmn.pmn56   #FUN-C80001
               ELSE                              #FUN-C80001
                  LET l_oeb.oeb092=null    #出貨批號
               END IF                            #FUN-C80001
#FUN-AA0023--add--str--
              IF i = p_last AND (g_prog='artt256' OR g_prog='artt255') THEN
                 LET l_oeb.oeb08 = g_pmn.pmn77    #出貨工廠
                 LET l_sql = "SELECT ruo14 FROM ",cl_get_target_table(g_pmn.pmn77,'ruo_file'),",",
                                                     cl_get_target_table(g_pmn.pmn77,'imd_file'), 
                             " WHERE ruo01 = '",g_pmn.pmn75,"'",
                             "   AND ruoplant = '",g_pmn.pmn77,"'",
                             "   AND ruo14 = imd01 ",
                             "   AND ruo04 = imd20 "
                 CALL cl_replace_sqldb(l_sql) RETURNING l_sql		
                 CALL cl_parse_qry_sql(l_sql,g_pmn.pmn77) RETURNING l_sql 
                 PREPARE pre_sel1 FROM l_sql
                 EXECUTE pre_sel1 INTO l_ruo14
                 IF cl_null(l_ruo14) THEN #為空則在途歸屬撥入
                    LET l_sql = "SELECT rup09,rup10,rup11 FROM ",cl_get_target_table(g_pmn.pmn77,'rup_file'),
                                " WHERE rup01 = '",g_pmn.pmn75,"'",
                                "   AND rupplant = '",g_pmn.pmn77,"'",
                                "   AND rup02 = '",g_pmn.pmn76,"'"
                    CALL cl_replace_sqldb(l_sql) RETURNING l_sql		
                    CALL cl_parse_qry_sql(l_sql,g_pmn.pmn77) RETURNING l_sql 
                    PREPARE pre_sel2 FROM l_sql
                    EXECUTE pre_sel2 INTO l_oeb.oeb09,l_oeb.oeb091,l_oeb.oeb092
                 ELSE
                    LET l_oeb.oeb09 = l_ruo14 #出貨倉庫
                 END IF                 
              END IF
#FUN-AA0023--add--end--
               LET l_oeb.oeb12 = g_pmn.pmn20   
               LET l_oeb.oeb916 = g_pmn.pmn86   #FUN-620025--move here
               LET l_oeb.oeb917 = g_pmn.pmn87   #FUN-620025--move here
               #使用分銷功能，對訂單單價設置
               IF l_aza.aza50='Y' THEN
                  IF l_sma.sma116<>'0' THEN
                     LET l_unit = l_oeb.oeb916
                  ELSE
                     LET l_unit = l_oeb.oeb05
                  END IF
                  CALL s_fetch_price2(l_oea.oea1001,l_oeb.oeb04,l_unit,l_oea.oea02,'4',l_plant_new,l_oea.oea23)  #No.FUN-980059
                  # RETURNING l_oeb.oeb1002,l_oeb.oeb13,g_success      #No.FUN-A30056
                    RETURNING l_oeb.oeb1002,l_oeb.oeb13,l_success      #No.FUN-A30056
                  IF l_success ='N' THEN          #No.FUN-A30056
                     LET g_success = 'N'          #No.FUN-A30056
                     #No.FUN-A30056  --Begin
                     LET g_showmsg = l_plant_new,"+",l_oea.oea1001,"+",l_oeb.oeb04,"+",l_oea.oea01,"+",l_oea.oea02,"+",l_oea.oea23
                     IF g_bgerr THEN
                        #CALL s_errmsg('','','s_fetch_price2','axm-043',1)
                        CALL s_errmsg("l_plant_new,l_oea.oea1001,l_oeb.oeb04,l_oea.oea01,l_oea.oea02,l_oea.oea23",g_showmsg,"s_fetch_price2","axm-043",1)
                              #FUN-AA0023
                     ELSE
                        CALL cl_err('',"axm-043",1)
                     END IF
                     #No.FUN-A30056  --End
                  END IF  
                  IF cl_null(l_oeb.oeb916) THEN
                     LET l_oeb.oeb917=l_oeb.oeb12
                  END IF
                  IF l_oea.oea213 = 'N' THEN              #表示不含稅
                     LET l_oeb.oeb14 = l_oeb.oeb917* l_oeb.oeb13  #No.TQC-6A0084
                     LET l_oeb.oeb14t= l_oeb.oeb14*(1+l_oea.oea211/100)
                  ELSE
                     LET l_oeb.oeb13 = l_oeb.oeb13*(1+l_oea.oea211/100)
                     LET l_oeb.oeb14t= l_oeb.oeb917*l_oeb.oeb13  #No.TQC-6A0084
                     LET l_oeb.oeb14 = l_oeb.oeb14t/(1+l_oea.oea211/100)
                  END IF
                  LET l_oeb.oeb1001 = p_poy28       #原因碼
                  #No.FUN-A10099  --Begin
                  #SELECT azf10 INTO l_azf10 FROM azf_file
                  #  WHERE azf01 = l_oeb.oeb1001
                  #    AND azf02 = '2'      #No.TQC-760054
                  #    AND azf09 = '1'      #FUN-920186
                 #LET g_sql = " SELECT azf10 FROM ",l_dbs_new CLIPPED,"azf_file ",   #FUN-A50102 
                  LET g_sql = " SELECT azf10 FROM ",cl_get_target_table(l_plant_new,'azf_file'),   #FUN-A50102
                              "  WHERE azf01 = '",l_oeb.oeb1001,"'",
                              "    AND azf02 = '2' ",     #No.TQC-760054
                              "    AND azf09 = '1' "      #FUN-920186
                  CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
                  CALL cl_parse_qry_sql(g_sql,l_plant_new) RETURNING g_sql #FUN-A50102
                  PREPARE azf_p1 FROM g_sql
                  EXECUTE azf_p1 INTO l_azf10
                  #No.FUN-A10099  --End
                  IF l_azf10 ='Y'  THEN             #判斷原因碼是搭贈的話
                     LET l_oeb.oeb14=0
                     LET l_oeb.oeb14t=0
                  END IF
                  LET l_oeb.oeb1003 = '1'         #作業方式
                  LET l_oeb.oeb1004 = ''          #提案編號 
                  LET l_oeb.oeb1005 = ''          #定訂價群組
                  LET l_oeb.oeb1006 = 100         #折扣率
                  LET l_oeb.oeb1007 = ''          #現金折扣單號
                  LET l_oeb.oeb1008 = ''          #稅別
                  LET l_oeb.oeb1009 = ''          #稅率
                  LET l_oeb.oeb1010 = ''          #含稅否
                  LET l_oeb.oeb1011 = ''          #非直營KAB
                  LET l_oeb.oeb1012 = l_azf10     #是否搭贈     #No.FUN-6B0065
                  #重量, 體積
                  #No.FUN-A10099  --Begin
                  #CALL s_weight_cubage(l_oeb.oeb04,l_oeb.oeb05,l_oeb.oeb12)
                  #     RETURNING l_oea1013,l_oea1014
                  CALL s_weight_cubage1(l_oeb.oeb04,l_oeb.oeb05,l_oeb.oeb12,l_plant_new)
                       RETURNING l_oea1013,l_oea1014
                  #No.FUN-A10099  --End
                  LET l_oea.oea1013 = l_oea.oea1013 + l_oea1013
                  LET l_oea.oea1014 = l_oea.oea1014 + l_oea1014
               ELSE
                 IF i = 1 THEN   
                    IF l_oea.oea213 = 'Y' THEN
                       LET l_oeb.oeb13=g_pmn.pmn31t    #含稅單價. 同上游採購單價
                    ELSE
                       LET l_oeb.oeb13=g_pmn.pmn31     #未稅單價. 同上游採購單價
                    END IF
                 ELSE
                    LET l_no1 = i-1
                    IF l_oea.oea213 = 'Y' THEN  #TQC-D40086 add beg
                       SELECT so_price2 INTO l_oeb.oeb13
                         FROM p801_file
                        WHERE p_no = l_no1
                         AND so_no = g_pmm.pmm01
                         AND so_item=g_pmn.pmn02                       
                     ELSE #TQC-D40086 add end                      
                        SELECT so_price INTO l_oeb.oeb13
                          FROM p801_file
                         WHERE p_no = l_no1
                           AND so_no = g_pmm.pmm01
                           AND so_item=g_pmn.pmn02
                     END IF #TQC-D40086 add      
                 END IF
                 LET l_oeb.oeb17 = l_oeb.oeb13     #no.7150
 
                 CALL cl_digcut(l_oeb.oeb13,l_azi.azi03) 
                                   RETURNING l_oeb.oeb13
                 CALL cl_digcut(l_oeb.oeb17,l_azi.azi03) 
                                   RETURNING l_oeb.oeb17
                 #No.FUN-A10123 ...begin
                 #IF g_azw.azw04 = '2' THEN #MOD-B30127 mark
                    LET l_oeb.oeb44 = g_pmm.pmm51
                 #END IF                    #MOD-B30127 mark
                 LET l_oeb.oeb47 = 0
                 LET l_oeb.oeb48 = '1'
                 IF cl_null(l_oeb.oeb44) THEN LET l_oeb.oeb44 = '1' END IF
                 #No.FUN-A10123 ...end
 
                 #未稅金額/含稅金額 . oeb14/oeb14t
                 IF l_oea.oea213 = 'N' THEN
                    LET l_oeb.oeb14=l_oeb.oeb917*l_oeb.oeb13  #No.TQC-6A0084
                    LET l_oeb.oeb14t=l_oeb.oeb14*(1+l_oea.oea211/100)
                 ELSE 
                    LET l_oeb.oeb14t=l_oeb.oeb917*l_oeb.oeb13  #No.TQC-6A0084
                    LET l_oeb.oeb14=l_oeb.oeb14t/(1+l_oea.oea211/100)
                 END IF
               END IF
               IF cl_null(l_oeb.oeb1006) THEN LET l_oeb.oeb1006 = 100 END IF #MOD-C10074 add
               #No.FUN-A50063 ..begin
               IF cl_null(l_oeb.oeb44) THEN LET l_oeb.oeb44 = '1' END IF
               IF cl_null(l_oeb.oeb47) THEN LET l_oeb.oeb47 = 0 END IF
               IF cl_null(l_oeb.oeb48) THEN LET l_oeb.oeb48 = '1' END IF
               #No.FUN-A50063 ..end
                 LET l_oeb.oeb47 = 0
               LET l_oeb.oeb1003 = '1'         #作業方式   #NO.TQC-740335
               LET l_oeb.oeb15=g_pmn.pmn33
               LET l_oeb.oeb23=0          #待出貨數量
               LET l_oeb.oeb24=0          #已出貨數量
               LET l_oeb.oeb25=0          #已銷退數量
               LET l_oeb.oeb26=0          #被結案數量
               LET l_oeb.oeb28=0          #No.MOD-860042 add
               LET l_oeb.oeb70='N'        #結案否
               LET l_oeb.oeb901=0         #已包裝數
               LET l_oeb.oeb905=0         #no.7182
                CALL cl_digcut(l_oeb.oeb14,l_azi.azi04) 
                                 RETURNING l_oeb.oeb14
                CALL cl_digcut(l_oeb.oeb14t,l_azi.azi04) 
                                 RETURNING l_oeb.oeb14t
               LET l_oeb.oeb910 = g_pmn.pmn80
               LET l_oeb.oeb911 = g_pmn.pmn81
               LET l_oeb.oeb912 = g_pmn.pmn82
               IF cl_null(l_oeb.oeb912) THEN
                  LET l_oeb.oeb912 = 0 
               END IF 
               LET l_oeb.oeb913 = g_pmn.pmn83
               LET l_oeb.oeb914 = g_pmn.pmn84
               LET l_oeb.oeb915 = g_pmn.pmn85
               #-----MOD-AC0421---------
               #LET l_oeb.oeb906 = 'N'   #No.TQC-760152
               LET l_sql2 = "SELECT obk11 FROM ",cl_get_target_table(l_plant_new,'obk_file'),
                            " WHERE obk01 = '",l_oeb.oeb04,"'",
                            "   AND obk02 = '",l_oea.oea03,"'",
                            "   AND obk05 = '",l_oea.oea23,"'"   
	       CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2		
               CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2   
               PREPARE obk11_p1 FROM l_sql2
               EXECUTE obk11_p1 INTO l_oeb.oeb906
               IF cl_null(l_oeb.oeb906) THEN
                  LET l_oeb.oeb906 = 'N' 
               END IF
               #-----END MOD-AC0421-----
               LET l_oeb.oeb19  = 'N'   #No.TQC-760152
# --抓各站設定的訂單成本中心--
              SELECT poy45 INTO l_oeb.oeb930
                FROM poy_file
               WHERE poy01 = g_poz.poz01
                 AND poy02 = i
              IF g_aza.aza50 ='N' THEN LET l_oeb.oeb1003 = '1' END IF
              LET l_oeb.oeb16 = g_pmn.pmn33
              LET l_oeb.oeb919 = g_pmn.pmn919  #FUN-A80102
               #新增訂單單身檔
               CALL p801_iou(g_pmm.pmm99,tm.pmm905,'oea')   #FUN-620025
                  RETURNING l_stu_o                  #FUN-620025
              IF cl_null(l_stu_o_h) THEN LET l_stu_o_h=l_stu_o END IF  #MOD-780027 add
              IF l_stu_o ='U' THEN LET l_stu_o_h='U' END IF            #MOD-780027 add
              IF NOT cl_null(g_pmm.pmm99) THEN   
                LET l_sql2 = "SELECT oea01 ",                          
                           # " FROM ",l_dbs_tra CLIPPED,"oea_file ",  #FUN-980092    #FUN-A50102 mark
                             " FROM ",cl_get_target_table(l_plant_new,'oea_file'),   #FUN-A50102  
                             " WHERE oea99= '",g_pmm.pmm99,"'"              
                CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                CALL cl_parse_qry_sql(l_sql2,l_plant_new) 
                     RETURNING l_sql2 #FUN-980092
                PREPARE oea_p2 FROM l_sql2                             
                IF SQLCA.SQLCODE THEN 
                   #No.FUN-A30056  --Begin
                   IF g_bgerr THEN
                      CALL s_errmsg('oea99',g_pmm.pmm99,'select oea',SQLCA.sqlcode,1)
                   ELSE
                      CALL cl_err('oea_p1',SQLCA.sqlcode,1)
                   END IF
                   #No.FUN-A30056  --End
                END IF
                DECLARE oea_c2 CURSOR FOR oea_p2                       
                OPEN oea_c2                                            
                FETCH oea_c2 INTO l_oeb.oeb01                          
                CLOSE oea_c2                                           
              END IF    
               IF l_stu_o='I' THEN                   #FUN-620025
                 # LET l_sql2="INSERT INTO ",l_dbs_tra CLIPPED,"oeb_file",  #FUN-980092     #FUN-A50102 mark
                   LET l_sql2="INSERT INTO ",cl_get_target_table(l_plant_new,'oeb_file'),   #FUN-A50102
                              "( oeb01,oeb03,oeb04,oeb05,",
                              "  oeb05_fac,oeb06,oeb07,oeb08, ",
                              "  oeb09,oeb091,oeb092,oeb11, ",
                              "  oeb12,oeb37,oeb13,oeb14,oeb14t, ",    #FUN-AB0061 add oeb37
                              "  oeb15,oeb16,oeb17,oeb18, ",
                              "  oeb19,oeb20,oeb21,oeb22, ",
                              "  oeb23,oeb24,oeb25,oeb26, ",
                              "  oeb28,oeb44,oeb47,oeb48,", #No.MOD-860042 add #No.FUN-A10123
                              "  oeb70,oeb70d,oeb71,oeb72, ",
                              "  oeb901,oeb902,oeb903,oeb904,",
                              "  oeb905,oeb906,oeb907,oeb908,",
                              "  oeb909,oeb910,oeb911,oeb912,",   #FUN-560043
                              "  oeb913,oeb914,oeb915,oeb916,",   #FUN-560043
                              "  oeb917,oeb919, oeb1001,oeb1002,oeb1003,", #FUN-620025  #FUN-A80102
                              "  oeb1004,oeb1005,oeb1007,oeb1009,", #FUN-620025
                              "  oeb1010,oeb1011,oeb1008,oeb1012,", #FUN-620025   
                              "  oeb1006,oeb930,oebplant,oeblegal,",
                              "  oebud01,oebud02,oebud03,oebud04,oebud05,",     
                              "  oebud06,oebud07,oebud08,oebud09,oebud10,",     
                              "  oebud11,oebud12,oebud13,oebud14,oebud15)",     
                              " VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                              "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,  ?,?,?,?, ",    #No.FUN-A10123 add ???    #FUN-AB0061 add ?
                              "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,",     #No.CHI-9
                              "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,?,",   #FUN-560043  #FUN-620025  #FUN-A80102
                              "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,?)"         #FUN-620025   #No.MOD-860042 modify #FUN-980006 add ?,?
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2               #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2   #FUN-A50102
                    PREPARE ins_oeb FROM l_sql2
                   #FUN-AB0061 -----------add start---------------
                    IF cl_null(l_oeb.oeb37) OR l_oeb.oeb37 = 0 THEN
                       LET l_oeb.oeb37 = l_oeb.oeb13
                    END IF
                   #FUN-AB0061 ----------add end-----------------
                    #Add FUN-B20060
                   #CHI-C80060 mark START
                   #IF cl_null(l_oeb.oeb72) AND NOT cl_null(l_oeb.oeb15) THEN
                   #   LET l_oeb.oeb72 = l_oeb.oeb15
                   #END IF
                   #CHI-C80060 mark END
                   #CHI-C80060 add START 
                    IF cl_null(l_oeb.oeb72) THEN
                       LET l_oeb.oeb72 = NULL   
                    END IF
                   #CHI-C80060 add END
                    #End Add FUN-B20060
                    EXECUTE ins_oeb USING 
                              l_oeb.oeb01,l_oeb.oeb03,l_oeb.oeb04,l_oeb.oeb05,
                              l_oeb.oeb05_fac,l_oeb.oeb06,l_oeb.oeb07,l_oeb.oeb08, 
                              l_oeb.oeb09,l_oeb.oeb091,l_oeb.oeb092,l_oeb.oeb11, 
                              l_oeb.oeb12,l_oeb.oeb37,l_oeb.oeb13,l_oeb.oeb14,l_oeb.oeb14t,     #FUN-AB0061 add l_oeb.oeb37
                              l_oeb.oeb15,l_oeb.oeb16,l_oeb.oeb17,l_oeb.oeb18, 
                              l_oeb.oeb19,l_oeb.oeb20,l_oeb.oeb21,l_oeb.oeb22, 
                              l_oeb.oeb23,l_oeb.oeb24,l_oeb.oeb25,l_oeb.oeb26, 
                              l_oeb.oeb28,l_oeb.oeb44,l_oeb.oeb47,l_oeb.oeb48, #No.MOD-860042 add  #No.FUN-A10123
                              l_oeb.oeb70,l_oeb.oeb70d,l_oeb.oeb71,l_oeb.oeb72, 
                              l_oeb.oeb901,l_oeb.oeb902,l_oeb.oeb903,l_oeb.oeb904,
                              l_oeb.oeb905,l_oeb.oeb906,l_oeb.oeb907,l_oeb.oeb908,
                              l_oeb.oeb909,l_oeb.oeb910,l_oeb.oeb911,l_oeb.oeb912,   #FUN-560043
                              l_oeb.oeb913,l_oeb.oeb914,l_oeb.oeb915,l_oeb.oeb916,   #FUN-560043
                              l_oeb.oeb917,l_oeb.oeb919, l_oeb.oeb1001,l_oeb.oeb1002,l_oeb.oeb1003, #FUN-620025  #FUN-A80102
                              l_oeb.oeb1004,l_oeb.oeb1005,l_oeb.oeb1007,l_oeb.oeb1009, #FUN-620025
                              l_oeb.oeb1010,l_oeb.oeb1011,l_oeb.oeb1008,l_oeb.oeb1012, #FUN-620025
                              l_oeb.oeb1006,l_oeb.oeb930,l_plant,l_legal                               #FUN-620025 #FUN-980006 add l_plant,l_legal
                             ,l_oeb.oebud01,l_oeb.oebud02,l_oeb.oebud03,
                              l_oeb.oebud04,l_oeb.oebud05,l_oeb.oebud06,
                              l_oeb.oebud07,l_oeb.oebud08,l_oeb.oebud09,
                              l_oeb.oebud10,l_oeb.oebud11,l_oeb.oebud12,
                              l_oeb.oebud13,l_oeb.oebud14,l_oeb.oebud15
                    IF SQLCA.sqlcode<>0 THEN
                       LET g_success = 'N'	#MOD-960228 remark
                       IF g_bgerr THEN
                          LET g_showmsg = l_oeb.oeb01,"/",l_oeb.oeb03
                          CALL s_errmsg("oeb01,oeb03",g_showmsg,l_dbs_tra,SQLCA.sqlcode,1)  #FUN-980092 
                       ELSE
                          CALL cl_err3("ins","oeb_file",l_oeb.oeb01,l_oeb.oeb03,SQLCA.sqlcode,"",l_dbs_tra,0)  #FUN-980092 
                       END IF
                    ELSE
                       IF NOT s_industry('std') THEN
                          INITIALIZE l_oebi.* TO NULL
                          LET l_oebi.oebi01 = l_oeb.oeb01
                          LET l_oebi.oebi03 = l_oeb.oeb03
                          IF NOT s_ins_oebi(l_oebi.*,l_plant_new) THEN #FUN-980092 
                             LET g_success = "N"
                          END IF
                       END IF
                    END IF
               ELSE
                   IF l_stu_o='U' THEN                        #FUN-620025
                       IF g_pod.pod04='N' THEN
                           LET l_sql2 = "SELECT oea01 ",
                                      # " FROM ",l_dbs_tra CLIPPED,"oea_file ",                 #FUN-A50102 mark
                                        " FROM ",cl_get_target_table(l_plant_new,'oea_file'),   #FUN-A50102
                                        " WHERE oea99= '",g_pmm.pmm99,"'"
 
                           CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                           CALL cl_parse_qry_sql(l_sql2,l_plant_new) 
                                RETURNING l_sql2 #FUN-980092
                           PREPARE oea_p1 FROM l_sql2
                      IF SQLCA.SQLCODE THEN   #MOD-820150
                          LET g_success = 'N'  #No.FUN-8A0086
                          IF g_bgerr THEN
                             CALL s_errmsg("","","oea_p1",SQLCA.sqlcode,1)
                          ELSE
                             CALL cl_err3("","","","",SQLCA.sqlcode,"","oea_p1",1)
                          END IF
                      END IF #MOD-820150
                           DECLARE oea_c1 CURSOR FOR oea_p1
                           OPEN oea_c1
                           FETCH oea_c1 INTO l_oeb.oeb01
                           CLOSE oea_c1
                       END IF
                       #更新訂單單身檔
                      #LET l_sql2="UPDATE ",l_dbs_tra CLIPPED,"oeb_file", #FUN-980092       #FUN-A50102 mark
                       LET l_sql2="UPDATE ",cl_get_target_table(l_plant_new,'oeb_file'),    #FUN-A50102
                                  " SET oeb04=?,oeb05=?,oeb06=?, oeb12=?, ",
                                  "     oeb13=?,oeb14=?,oeb14t=?,oeb15=?,oeb906=?, ",   #MOD-AC0421 add oeb906
                                  "     oeb910=?,oeb911=?,oeb912=?,oeb913=?, ",   #FUN-560043
                                  "     oeb914=?,oeb915=?,oeb916=?,oeb917=?, ",    #FUN-560043
                                  "     oeb1001=?,oeb1002=?,oeb1003=?,oeb1004=?,", #FUN-620025
                                  "     oeb1005=?,oeb1007=?,oeb1008=?,oeb1009=?,", #FUN-620025
                                  "     oeb1010=?,oeb1011=?,oeb1012=?,oeb1006=? ", #FUN-620025
                                  " WHERE oeb01 = ? AND oeb03 = ? "
 	               CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                       CALL cl_parse_qry_sql(l_sql2,l_plant_new) 
                            RETURNING l_sql2 #FUN-980092
                       PREPARE upd_oeb FROM l_sql2
                       EXECUTE upd_oeb USING 
                                  l_oeb.oeb04,l_oeb.oeb05,l_oeb.oeb06,l_oeb.oeb12,
                                  l_oeb.oeb13,l_oeb.oeb14,l_oeb.oeb14t,l_oeb.oeb15,l_oeb.oeb906,   #MOD-AC0421 add oeb906 
                                  l_oeb.oeb910,l_oeb.oeb911,l_oeb.oeb912,l_oeb.oeb913,   #FUN-560043
                                  l_oeb.oeb914,l_oeb.oeb915,l_oeb.oeb916,l_oeb.oeb917,   #FUN-560043 
                                  l_oeb.oeb1001,l_oeb.oeb1002,l_oeb.oeb1003,l_oeb.oeb1004, #FUN-620025
                                  l_oeb.oeb1005,l_oeb.oeb1007,l_oeb.oeb1008,l_oeb.oeb1009, #FUN-620025
                                  l_oeb.oeb1010,l_oeb.oeb1011,l_oeb.oeb1012,l_oeb.oeb1006, #FUN-620025
                                  l_oeb.oeb01,l_oeb.oeb03
                       IF SQLCA.SQLCODE THEN
                          IF g_bgerr THEN
                             CALL s_errmsg("","","upd oeb",SQLCA.sqlcode,1)
                          ELSE
                             CALL cl_err3("","","","",SQLCA.sqlcode,"","upd oeb",1)
                          END IF
                           LET g_success = 'N'
                       END IF
                   ELSE
                       IF l_stu_o='F' THEN                          #FUN-620025
                          IF g_bgerr THEN
                             CALL s_errmsg("","",g_pmm.pmm99,"apm-803",1)
                          ELSE
                             CALL cl_err3("","","","","apm-803","",g_pmm.pmm99,0)
                          END IF
                           LET g_success = 'N'                       #FUN-620025
                       END IF
                   END IF
               END IF
              #新增至暫存檔中
               INSERT INTO p801_file VALUES(i,g_pmm.pmm01,g_pmn.pmn02,
                                         l_pmn.pmn31,l_pmn.pmn31t,l_pmm.pmm22) #TQC-D40086 add pmn31t
                 IF SQLCA.sqlcode<>0 THEN
                    IF g_bgerr THEN
                       LET g_showmsg = i,"/",g_pmm.pmm01,"/",g_pmn.pmn02,"/",l_pmn.pmn31,"/",l_pmm.pmm22
                       CALL s_errmsg("p_no,so_no,so_item,so_price,so_curr",g_showmsg,"ins p00_file.",SQLCA.sqlcode,1)
                    ELSE
                       CALL cl_err3("ins","p801_file",g_pmm.pmm01,g_pmn.pmn02,SQLCA.sqlcode,"","ins p00_file.",1)
                    END IF
                   LET g_success = 'N'
                 END IF
        
              #訂單單頭總金額
              LET l_oea.oea61 = l_oea.oea61 + l_oeb.oeb14 
                  CALL cl_digcut(l_oea.oea61,l_azi.azi04) 
                                 RETURNING l_oea.oea61
              #在分銷系統中，訂單單頭未稅總金額
              #IF l_aza.aza50 = 'Y' THEN #TQC-D40086 mark
                 IF cl_null(l_oea.oea1008) THEN LET l_oea.oea1008 = 0 END IF #TQC-D40086 add
                 LET l_oea.oea1008 = l_oea.oea1008 + l_oeb.oeb14t
                     CALL cl_digcut(l_oea.oea1008,l_azi.azi04)
                                    RETURNING l_oea.oea1008
              #END IF #TQC-D40086 mark
           END FOREACH {oeb_cus}
 
           #新增採購單頭檔
           IF l_stu_p_h='I' THEN                         #MOD-780027
               IF NOT ( i = p_last AND cl_null(g_pmm.pmm50)) THEN
                #  LET l_sql2="INSERT INTO ",l_dbs_tra CLIPPED,"pmm_file",  #FUN-980092   #FUN-A50102 mark
                   LET l_sql2="INSERT INTO ",cl_get_target_table(l_plant_new,'pmm_file'), #FUN-A50102 
                              "( pmm01, ",
                              " pmm02,pmm03,pmm04,pmm05,",
                              " pmm06,pmm07,pmm08,pmm09,",
                              " pmm10,pmm11,pmm12,pmm13,",
                              " pmm14,pmm15,pmm16,pmm17,",
                              " pmm18,pmm20,pmm21,pmm22,",
                              " pmm25,pmm26,pmm27,pmm28,",
                              " pmm29,pmm30,pmm31,pmm32,",
                              " pmm40,pmm401,pmm41,pmm42,",
                              " pmm43,pmm44,pmm45,pmm46,",
                              " pmm47,pmm48,pmm49,pmm50,",
                              " pmm51,pmm52,pmm53,pmmcond,",  #No.FUN-A10123
                              " pmmcont,pmmconu,",            #No.FUN-A10123
                              " pmm99,pmm901,pmm902,",
                              " pmm903,pmm904,pmm905,pmm906, ",
                              " pmmprsw,pmmprno,pmmprdt,pmmmksg,",
                              " pmmsign,pmmdays,pmmprit,pmmsseq,",
                              " pmmsmax,pmmacti,pmmuser,pmmgrup,",
                              " pmmmodu,pmmdate,pmm40t,pmmplant,pmmlegal, ",
                              " pmmud01,pmmud02,pmmud03,pmmud04,pmmud05,",
                              " pmmud06,pmmud07,pmmud08,pmmud09,pmmud10,",
                              " pmmud11,pmmud12,pmmud13,pmmud14,pmmud15,pmmoriu,pmmorig,pmmcrat)", #FUN-A10036  #TQC-A30054 add pmmcrat
                              " VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                              "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                              "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                              "?,?,?,?, ?,?,                      ", #No.FUN-A10123
                              "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,",   #No.CHI-950020
                              "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?, ?,?,?,?, ?) "   #FUN-620025 #FUN-980006 add pmmplant,pmmlegal  #FUN-A10036  #TQC-A30054 add ?
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2              #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2  #FUN-A50102 
                   PREPARE ins_pmm FROM l_sql2
                   EXECUTE ins_pmm USING l_pmm.pmm01,
                                         l_pmm.pmm02,l_pmm.pmm03,l_pmm.pmm04,l_pmm.pmm05,
                                         l_pmm.pmm06,l_pmm.pmm07,l_pmm.pmm08,l_pmm.pmm09,
                                         l_pmm.pmm10,l_pmm.pmm11,l_pmm.pmm12,l_pmm.pmm13,
                                         l_pmm.pmm14,l_pmm.pmm15,l_pmm.pmm16,l_pmm.pmm17,
                                         l_pmm.pmm18,l_pmm.pmm20,l_pmm.pmm21,l_pmm.pmm22,
                                         l_pmm.pmm25,l_pmm.pmm26,l_pmm.pmm27,l_pmm.pmm28,
                                         l_pmm.pmm29,l_pmm.pmm30,l_pmm.pmm31,l_pmm.pmm32,
                                         l_pmm.pmm40,l_pmm.pmm401,l_pmm.pmm41,l_pmm.pmm42,
                                         l_pmm.pmm43,l_pmm.pmm44,l_pmm.pmm45,l_pmm.pmm46,
                                         l_pmm.pmm47,l_pmm.pmm48,l_pmm.pmm49,l_pmm.pmm50,
                                         l_pmm.pmm51,l_pmm.pmm52,l_pmm.pmm53,l_pmm.pmmcond,  #No.FUN-A10123
                                         l_pmm.pmmcont,l_pmm.pmmconu,                        #No.FUN-A10123
                                         l_pmm.pmm99,l_pmm.pmm901,l_pmm.pmm902,
                                         l_pmm.pmm903,l_pmm.pmm904,l_pmm.pmm905,l_pmm.pmm906,
                                         l_pmm.pmmprsw,l_pmm.pmmprno,l_pmm.pmmprdt,l_pmm.pmmmksg,
                                         l_pmm.pmmsign,l_pmm.pmmdays,l_pmm.pmmprit,l_pmm.pmmsseq,
                                         l_pmm.pmmsmax,l_pmm.pmmacti,l_pmm.pmmuser,l_pmm.pmmgrup,
                                         l_pmm.pmmmodu,l_pmm.pmmdate,l_pmm.pmm40t,l_plant,l_legal    #FUN-620025  #FUN-980006 add l_plant,l_legal
                                        ,l_pmm.pmmud01,l_pmm.pmmud02,
                                         l_pmm.pmmud03,l_pmm.pmmud04,
                                         l_pmm.pmmud05,l_pmm.pmmud06,
                                         l_pmm.pmmud07,l_pmm.pmmud08,
                                         l_pmm.pmmud09,l_pmm.pmmud10,
                                         l_pmm.pmmud11,l_pmm.pmmud12,
                                         l_pmm.pmmud13,l_pmm.pmmud14,
                                         l_pmm.pmmud15,g_user,g_grup #FUN-A10036
                                        ,l_pmm.pmmcrat           #TQC-A30054 add  
                  IF SQLCA.sqlcode<>0 THEN
                     IF g_bgerr THEN
                        CALL s_errmsg("","","ins pmm.",SQLCA.sqlcode,1)
                     ELSE
                        CALL cl_err3("","","","",SQLCA.sqlcode,"","ins pmm.",1)
                     END IF
                      LET g_success = 'N'
                  END IF
               END IF
           ELSE
              #更新採購單頭檔
              IF l_stu_p_h='U' THEN              #MOD-780027  
                  IF NOT ( i = p_last AND cl_null(g_pmm.pmm50)) THEN
                   #  LET l_sql2="UPDATE ",l_dbs_tra CLIPPED,"pmm_file",  #FUN-980092        #FUN-A50102 mark
                      LET l_sql2="UPDATE ",cl_get_target_table(l_plant_new,'pmm_file'),      #FUN-A50102
                                 "  SET pmm03=?,pmm09=?,pmm10=?,pmm20=?,pmm21=?, ",
                                 "      pmm22=?,pmm40=?,pmm42=?,pmm43=?,pmm40t=? ", #FUN-620025
                                 " WHERE pmm99 = ? "                                #FUN-620025
 	              CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                      CALL cl_parse_qry_sql(l_sql2,l_plant_new) 
                           RETURNING l_sql2 #FUN-980092
                      PREPARE upd_pmm FROM l_sql2
                      EXECUTE upd_pmm USING g_pmm.pmm03,l_pmm.pmm09,l_pmm.pmm10,
                                            l_pmm.pmm20,l_pmm.pmm21,l_pmm.pmm22,l_pmm.pmm40,
                                            l_pmm.pmm42,l_pmm.pmm43,l_pmm.pmm40t,   #FUN-620025
                                            l_pmm.pmm99                             #FUN-620025
                      IF SQLCA.SQLCODE THEN
                         IF g_bgerr THEN
                            CALL s_errmsg("","","upd pmm.",SQLCA.sqlcode,1)
                         ELSE
                            CALL cl_err3("","","","",SQLCA.sqlcode,"","upd pmm.",1)
                         END IF
                         LET g_success = 'N'
                      END IF
                   END IF
               ELSE
                   IF l_stu_p_h='F' THEN                        #FUN-620025  #MOD-780027 modify
                      IF g_bgerr THEN
                         CALL s_errmsg("","",g_pmm.pmm99,"apm-803",1)
                      ELSE
                         CALL cl_err3("","","","","apm-803","",g_pmm.pmm99,1)
                      END IF
                       LET g_success = 'N'                      #FUN-620025
                   END IF
               END IF
           END IF     
          # 拋轉採購單特別說明
           IF g_poz.poz10 = 'Y' THEN
              #No.FUN-A10099  --Begin
              #DECLARE pmo_cs CURSOR FOR
              # SELECT * FROM pmo_file WHERE pmo01 = g_pmm.pmm01   #FUN-620025
            # LET g_sql = " SELECT * FROM ",g_from_dbs_tra CLIPPED,"pmo_file",               #FUN-A50102 mark
              LET g_sql = " SELECT * FROM ",cl_get_target_table(g_from_plant,'pmo_file'),    #FUN-A50102 
                          "  WHERE pmo01 = '",g_pmm.pmm01,"'"   #FUN-620025
              CALL cl_replace_sqldb(g_sql) RETURNING g_sql               #FUN-A50102 
              CALL cl_parse_qry_sql(g_sql,g_from_plant) RETURNING g_sql  #FUN-A50102
              PREPARE p801_px1 FROM g_sql
              DECLARE pmo_cs CURSOR FOR p801_px1
              #No.FUN-A10099  --End
               FOREACH pmo_cs INTO l_pmo.*
                   #將特別說明寫入特別說明檔pmo_file
                   IF l_stu_p_h='I' THEN                #FUN-620025  #MOD-780027 modify
                    #最終站時, 要判斷是否需拋最終供應商再ins pmo_file 
	             IF NOT ( i = p_last AND cl_null(g_pmm.pmm50)) THEN  #MOD-770111 add
                     # LET l_sql2 = "INSERT INTO ",l_dbs_tra CLIPPED,"pmo_file",  #FUN-980092       #FUN-A50102 mark
                       LET l_sql2 = "INSERT INTO ",cl_get_target_table(l_plant_new,'pmo_file'),     #FUN-A50102 
                                    " (pmo01,pmo02,pmo03,pmo04,pmo05,pmo06,pmoplant,pmolegal) ", #FUN-980006 add pmoplant,pmolegal
                                    " VALUES (?,?,?,?,?,? ,?,?) " #FUN-980006 add ?,?
                      CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                      CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2   #FUN-A50102 mark
                       PREPARE ins_pmo FROM l_sql2
                       EXECUTE ins_pmo USING l_pmm.pmm01,l_pmo.pmo02,  #MOD-780030
                                             l_pmo.pmo03,l_pmo.pmo04,
                                             l_pmo.pmo05,l_pmo.pmo06,l_plant,l_legal #FUN-980006 add l_plant,l_legal
                       IF SQLCA.sqlcode<>0 THEN
                           LET g_msg = l_dbs_tra CLIPPED,"ins pmo"  #FUN-980092 
                          IF g_bgerr THEN
                             CALL s_errmsg("","",g_msg,SQLCA.sqlcode,1)
                          ELSE
                             CALL cl_err3("","","","",SQLCA.sqlcode,"",g_msg,1)
                          END IF
                           LET g_success = 'N'
                       END IF
                   ELSE
                       IF l_stu_p_h='U' AND i <> 1 THEN  #FUN-670007  #MOD-780027 modify
                           IF g_pod.pod04 = 'N' THEN
                               LET l_sql2 = "SELECT pmm01 ",
                                          # " FROM ",l_dbs_tra CLIPPED,"pmm_file ",  #FUN-980092   #FUN-A50102 mark
                                            " FROM ",cl_get_target_table(l_plant_new,'pmm_file'),  #FUN-A50102  
                                            " WHERE pmm99= '",g_pmm.pmm99,"'"
 	                       CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                               CALL cl_parse_qry_sql(l_sql2,l_plant_new) 
                                    RETURNING l_sql2 #FUN-980092
                               PREPARE pmo_p1 FROM l_sql2
                              IF SQLCA.SQLCODE THEN
                                 LET g_success = 'N'  #No.FUN-8A0086
                                 IF g_bgerr THEN
                                    CALL s_errmsg("","","pmo_p1",SQLCA.sqlcode,1)
                                 ELSE
                                    CALL cl_err3("","","","",SQLCA.sqlcode,"","pmo_p1",1)
                                 END IF
                              END IF
                               DECLARE pmo_c1 CURSOR FOR pmo_p1
                               OPEN pmo_c1
                               FETCH pmo_c1 INTO l_pmo.pmo01
                               CLOSE pmo_c1
                           END IF
                          #LET l_sql2 = " UPDATE ",l_dbs_tra CLIPPED,"pmo_file", #FUN-980092    #FUN-A50102 mark
                           LET l_sql2 = " UPDATE ",cl_get_target_table(l_plant_new,'pmo_file'), #FUN-A50102
                                        "    SET pmo06=? ",
                                        "  WHERE pmo01 = ? AND pmo02 = ? ",
                                        "    AND pmo03 = ? AND pmo04 = ? ",
                                        "    AND pmo05 = ? "
                           CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                           CALL cl_parse_qry_sql(l_sql2,l_plant_new) 
                                RETURNING l_sql2 #FUN-980092
                           PREPARE upd_pmo FROM l_sql2
                           EXECUTE upd_pmo USING l_pmo.pmo06,
                                                 l_pmo.pmo01,l_pmo.pmo02,l_pmo.pmo03,
                                                 l_pmo.pmo04,l_pmo.pmo05
                           IF SQLCA.SQLCODE THEN
                               LET g_msg = l_dbs_tra CLIPPED,"upd pmo"  #FUN-980092 
                              IF g_bgerr THEN
                                 CALL s_errmsg("","",g_msg,SQLCA.sqlcode,1)
                              ELSE
                                 CALL cl_err3("","","","",SQLCA.sqlcode,"",g_msg,1)
                              END IF
                               LET g_success = 'N'
                           END IF
                       ELSE
                           IF l_stu_p_h='F' THEN                   #FUN-620025   #MOD-780027 modify
                              IF g_bgerr THEN
                                 CALL s_errmsg("","",g_pmm.pmm99,"apm-803",1)
                              ELSE
                                 CALL cl_err3("","","","","apm-803","",g_pmm.pmm99,1)
                              END IF
                               LET g_success = 'N'                  #FUN-620025
                           END IF 
                       END IF                                         #FUN-620025
                   END IF
                  END IF    #MOD-770111 add
                   #將特別說明寫入訂單備註檔oao_file
                   IF l_stu_o_h='I' THEN                 #FUN-620025    #MOD-780027 modify
                      #LET l_sql2 = "INSERT INTO ",l_dbs_new CLIPPED,"oao_file",                #FUN-A50102 mark
                       LET l_sql2 = "INSERT INTO ",cl_get_target_table(l_plant_new,'oao_file'), #FUN-A50102 
                                    " (oao01,oao03,oao04,oao05,oao06) ",
                                    " VALUES (?,?,?,?,?) "
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2                 #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2     #FUN-A50102 
                       PREPARE ins_oao FROM l_sql2
                       EXECUTE ins_oao USING l_oea.oea01,l_pmo.pmo03,  #MOD-780030
                                             l_pmo.pmo05,l_pmo.pmo04,
                                             l_pmo.pmo06
                       IF SQLCA.sqlcode<>0 THEN
                           LET g_msg = l_dbs_new CLIPPED,"ins oao"
                          IF g_bgerr THEN
                             CALL s_errmsg("","",g_msg,SQLCA.sqlcode,1)
                          ELSE
                             CALL cl_err3("","","","",SQLCA.sqlcode,"",g_msg,1)
                          END IF
                           LET g_success = 'N'
                       END IF
                   ELSE  
                       IF l_stu_o_h='U' THEN  #FUN-620025      #MOD-780027 modify
                         LET l_sql2 = "SELECT oea01 ",
                                    # " FROM ",l_dbs_tra CLIPPED,"oea_file ",   #FUN-980092    #FUN-A50102 mark
                                      " FROM ",cl_get_target_table(l_plant_new,'oea_file'),    #FUN-A50102
                                      " WHERE oea99= '",g_pmm.pmm99,"'"
 	                 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                         CALL cl_parse_qry_sql(l_sql2,l_plant_new) 
                              RETURNING l_sql2 #FUN-980092
                         PREPARE oao_p1 FROM l_sql2
                         IF SQLCA.SQLCODE THEN
                            #No.FUN-A30056  --Begin
                            IF g_bgerr THEN
                               CALL s_errmsg('oea99',g_pmm.pmm99,'pmo_p1',SQLCA.sqlcode,1)
                            ELSE
                               CALL cl_err('pmo_p1',SQLCA.sqlcode,1) 
                            END IF
                            #No.FUN-A30056  --End
                         END IF
                         DECLARE oao_c1 CURSOR FOR oao_p1
                         OPEN oao_c1
                         FETCH oao_c1 INTO l_pmo.pmo01
                         CLOSE pmo_c1
                         # LET l_sql2 = " UPDATE ",l_dbs_new CLIPPED,"oao_file",                #FUN-A50102 mark
                           LET l_sql2 = " UPDATE ",cl_get_target_table(l_plant_new,'oao_file'), #FUN-A50102 	 
                                        "    SET oao06=? ",
                                        "  WHERE oao01 = ? AND oao03 = ? ",
                                        "    AND oao04 = ? AND oao05 = ? "
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2              #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2  #FUN-A50102
                           PREPARE upd_oao FROM l_sql2
                           EXECUTE upd_oao USING l_pmo.pmo06,
                                                 l_pmo.pmo01,l_pmo.pmo03,
                                                 l_pmo.pmo05,l_pmo.pmo04
                           IF SQLCA.SQLCODE THEN
                               LET g_msg = l_dbs_new CLIPPED,"upd oao"
                              IF g_bgerr THEN
                                 CALL s_errmsg("","",g_msg,SQLCA.sqlcode,1)
                              ELSE
                                 CALL cl_err3("","","","",SQLCA.sqlcode,"",g_msg,1)
                              END IF
                               LET g_success = 'N'
                           END IF
                       ELSE
                           IF l_stu_o_h='F' THEN                     #FUN-620025   #MOD-780027 modify
                              IF g_bgerr THEN
                                 CALL s_errmsg("","",g_pmm.pmm99,"apm-803",1)
                              ELSE
                                 CALL cl_err3("","","","","apm-803","",g_pmm.pmm99,1)
                              END IF
                               LET g_success = 'N'                    #FUN-620025
                           END IF
                       END IF
                   END IF
               END FOREACH
           END IF
 
           #新增訂單單頭檔
           LET l_oea.oea261 =0    #No:TQC-A80091
           LET l_oea.oea262 =0    #No:TQC-A80091
           LET l_oea.oea263 =0    #No:TQC-A80091
           IF l_stu_o_h='I' THEN               #FUN-620025  #MOD-780027 modify
            #  LET l_sql2="INSERT INTO ",l_dbs_tra CLIPPED,"oea_file", #FUN-980092    #FUN-A50102 mark
               LET l_sql2="INSERT INTO ",cl_get_target_table(l_plant_new,'oea_file'), #FUN-A50102 
                          "( oea00,oea01,oea02,oea03,",
                          "  oea032,oea033,oea04,oea044, ",
                          "  oea05, oea06, oea07, oea08, ",
                          "  oea09, oea10, oea11, oea12, ",
                          "  oea14, oea15, oea161,oea162, ",
                          "  oea163,oea17, oea18, oea19, ",
                          "  oea20, oea21, oea211,oea212, ",
                          "  oea213,oea23, oea24, oea25, ",
                          "  oea26, oea27, oea28, oea29, ",
                          "  oea30, oea31, oea32, oea33, ",
                          "  oea34, oea35, oea36, oea37,oea38, ",  #No.TQC-760152 add oea37
                          "  oea41, oea42, oea43, oea44, ",
                          "  oea45, oea46, oea47, oea48, ",
                          "  oea49, oea50, oea51, oea52, ",
                          "  oea53, oea54, oea55, oea56, ",
                          "  oea57, oea58, oea59, oea61, ",
                          "  oea62, oea63, oea65, oea71, oea72, ",   #FUN-7B0091 add oea65
                          "  oea83, oea84,oea85,oeaconu,oeacont,",   #No.FUN-A10123
                          "  oea99, oea901,oea902,oea903,",
                          "  oea904,oea905,oea906,oea907,",
                          "  oea908,oea909,oea911,oea912,",
                          "  oea913,oea914,oea915,oea916,",
                          "  oeamksg,oeasign,oeadays,oeaprit,",
                          "  oeasseq,oeasmax,oeahold,oeaconf,",
                          "  oeaprsw,oeauser,oeagrup,oeamodu,",
                          "  oeadate,oea1001,oea1002,oea1003,",
                          "  oea1004,oea1005,oea1006,oea1007,",
                          "  oea1008,oea1009,oea1010,oea1011,",
                          "  oea1012,oea1013,oea1014,oeaplant,oealegal, ",
                          "  oeaud01,oeaud02,oeaud03,oeaud04,oeaud05,",
                          "  oeaud06,oeaud07,oeaud08,oeaud09,oeaud10,",
                          "  oeaud11,oeaud12,oeaud13,oeaud14,oeaud15,oeaoriu,oeaorig,oea261,oea262,oea263)", #FUN-A10036  #TQC-A80091
                          " VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                          "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                          "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                          "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                          "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                          "?,?,?,?, ?,                        ",  #No.FUN-A10123
                          "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                          "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,",     #No.CHI-950020
                          "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?, ?, ?,?,?,?,?,?,?)" #FUN-620025 #No.TQC-760152 add ?   #FUN-7B0091 add ? #FUN-980006 add ?,?   #FUN-A10036  #TQC-A80091 add ?,?,?
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2               #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2   #FUN-A50102
               PREPARE ins_oea FROM l_sql2
               EXECUTE ins_oea USING 
                           l_oea.oea00,l_oea.oea01,l_oea.oea02,l_oea.oea03,
                           l_oea.oea032,l_oea.oea033,l_oea.oea04,l_oea.oea044, 
                           l_oea.oea05, l_oea.oea06, l_oea.oea07, l_oea.oea08, 
                           l_oea.oea09, l_oea.oea10, l_oea.oea11, l_oea.oea12, 
                           l_oea.oea14, l_oea.oea15, l_oea.oea161,l_oea.oea162, 
                           l_oea.oea163,l_oea.oea17, l_oea.oea18, l_oea.oea19, 
                           l_oea.oea20, l_oea.oea21, l_oea.oea211,l_oea.oea212, 
                           l_oea.oea213,l_oea.oea23, l_oea.oea24, l_oea.oea25, 
                           l_oea.oea26, l_oea.oea27, l_oea.oea28, l_oea.oea29, 
                           l_oea.oea30, l_oea.oea31, l_oea.oea32, l_oea.oea33, 
                           l_oea.oea34, l_oea.oea35, l_oea.oea36, l_oea.oea37,l_oea.oea38,   #No.TQC-760152 add oea37
                           l_oea.oea41, l_oea.oea42, l_oea.oea43, l_oea.oea44, 
                           l_oea.oea45, l_oea.oea46, l_oea.oea47, l_oea.oea48, 
                           l_oea.oea49, l_oea.oea50, l_oea.oea51, l_oea.oea52, 
                           l_oea.oea53, l_oea.oea54, l_oea.oea55, l_oea.oea56, 
                           l_oea.oea57, l_oea.oea58, l_oea.oea59, l_oea.oea61, 
                           l_oea.oea62, l_oea.oea63, l_oea.oea65, l_oea.oea71, l_oea.oea72,  #FUN-7B0091 add oea65
                           l_oea.oea83, l_oea.oea84,l_oea.oea85,l_oea.oeaconu,l_oea.oeacont,   #No.FUN-A10123
                           l_oea.oea99, l_oea.oea901,l_oea.oea902,l_oea.oea903,
                           l_oea.oea904,l_oea.oea905,l_oea.oea906,l_oea.oea907,
                           l_oea.oea908,l_oea.oea909,l_oea.oea911,l_oea.oea912,
                           l_oea.oea913,l_oea.oea914,l_oea.oea915,l_oea.oea916,
                           l_oea.oeamksg,l_oea.oeasign,l_oea.oeadays,l_oea.oeaprit,
                           l_oea.oeasseq,l_oea.oeasmax,l_oea.oeahold,l_oea.oeaconf,
                           l_oea.oeaprsw,l_oea.oeauser,l_oea.oeagrup,l_oea.oeamodu,
                           l_oea.oeadate,l_oea.oea1001,l_oea.oea1002,l_oea.oea1003,   #FUN-620025
                           l_oea.oea1004,l_oea.oea1005,l_oea.oea1006,l_oea.oea1007,   #FUN-620025
                           l_oea.oea1008,l_oea.oea1009,l_oea.oea1010,l_oea.oea1011,   #FUN-620025
                           l_oea.oea1012,l_oea.oea1013,l_oea.oea1014,l_plant,l_legal                  #FUN-620025 #FUN-980006 add l_plant,l_legal
                          ,l_oea.oeaud01,l_oea.oeaud02,l_oea.oeaud03,
                           l_oea.oeaud04,l_oea.oeaud05,l_oea.oeaud06,
                           l_oea.oeaud07,l_oea.oeaud08,l_oea.oeaud09,
                           l_oea.oeaud10,l_oea.oeaud11,l_oea.oeaud12,
                           l_oea.oeaud13,l_oea.oeaud14,l_oea.oeaud15,g_user,g_grup,l_oea.oea261,l_oea.oea262,l_oea.oea263  #FUN-A10036   #TQC-A80091 add l_oea.oea261,l_oea.oea262,l_oea.oea263
#                          l_oea.oeaud13,l_oea.oeaud14,l_oea.oeaud15 #TQC-AB0293 add #TQC-AB0293 mark   
               IF SQLCA.sqlcode<>0 THEN
                  IF g_bgerr THEN
                     CALL s_errmsg("oea01",l_oea.oea01,l_dbs_tra,SQLCA.sqlcode,1)  #FUN-980092 
                  ELSE
                     CALL cl_err3("ins","oea_file",l_oea.oea01,"",SQLCA.sqlcode,"",l_dbs_tra,0)   #FUN-980092 
                  END IF
                   LET g_success = 'N'
#              #FUN-C50136----add----str----
#              ELSE
#                 IF g_oaz.oaz96 ='Y' THEN
#                    CALL s_ccc_oia07('A',l_oea.oea03) RETURNING l_oia07
#                    IF l_oia07 = '0' THEN
#                       CALL s_ccc_oia(l_oea.oea03,'A',l_oea.oea01,0,l_plant_new)
#                    END IF
#                 END IF
#              #FUN-C50136----add----end----
               END IF
           ELSE
               IF l_stu_o_h='U' THEN  #FUN-620025   #MOD-780027 modify
                   #更新訂單單頭檔
                #  LET l_sql2="UPDATE ",l_dbs_tra CLIPPED,"oea_file",  #FUN-980092     #FUN-A50102 mark
                   LET l_sql2="UPDATE ",cl_get_target_table(l_plant_new,'oea_file'),   #FUN-A50102
                              " SET  oea04=?,oea044=?,oea06=?,oea21=?,",
                              "     oea211=?,oea212=?,oea213=?,oea32=?, ",
                              "     oea61=?,oea23=?,oea24=?,  ",	#MOD-970022
                              "     oea1008 = ?",  # TQC-D40086 add 1008 
                              " WHERE oea99 = ? "
 	           CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                   CALL cl_parse_qry_sql(l_sql2,l_plant_new) 
                        RETURNING l_sql2 #FUN-980092
                   PREPARE upd_oea FROM l_sql2
                   EXECUTE upd_oea USING 
                              l_oea.oea04,l_oea.oea044,l_oea.oea06,l_oea.oea21,
                              l_oea.oea211,l_oea.oea212,l_oea.oea213,l_oea.oea32, 
                              l_oea.oea61,l_oea.oea23,l_oea.oea24,l_oea.oea1008,l_oea.oea99	#MOD-970022 # TQC-D40086 add 1008
                   IF SQLCA.SQLCODE THEN
                      IF g_bgerr THEN
                         CALL s_errmsg("","","upd oea.",SQLCA.sqlcode,1)
                      ELSE
                         CALL cl_err3("","","","",SQLCA.sqlcode,"","upd oea.",1)
                      END IF
                       LET g_success = 'N'
                   END IF
               ELSE 
                   IF l_stu_o_h = 'F' THEN                    #FUN-620025  #MOD-780027 modify
                      IF g_bgerr THEN
                         CALL s_errmsg("","",g_pmm.pmm99,"apm-803",1)
                      ELSE
                         CALL cl_err3("","","","","apm-803","",g_pmm.pmm99,1)
                      END IF
                       LET g_success = 'N'                     #FUN-620025
                   END IF
               END IF
           END IF
           #若單身之計價方式有所不同時, 提出警告訊息
           IF diff_azi='Y'  THEN
              LET l_msg = cl_getmsg('apm-303',g_lang)
              LET l_msg=l_msg CLIPPED,"(",g_pmm.pmm01,"+",p_poy04,")."
              CALL cl_msgany(10,20,l_msg)
           END IF
      END FOR  {一個訂單流程代碼結束}
      
      #多角貿易計價方式為逆推時，從最後一站再回寫各站的單價
      IF NOT cl_null(g_pmm.pmm50) THEN    #要有最終供應商才需執行
         LET l_sql1 = "SELECT pmn_file.* ",
         #            " FROM pmm_file,pmn_file ",                   #No.FUN-A10099
         #            " FROM ",g_from_dbs_tra CLIPPED,"pmm_file,",  #No.FUN-A10099     #FUN-A50102 mark
         #                     g_from_dbs_tra CLIPPED,"pmn_file ",  #No.FUN-A10099     #FUN-A50102 mark
                      " FROM ",cl_get_target_table(g_from_plant,'pmm_file'),",",       #FUN-A50102 
                               cl_get_target_table(g_from_plant,'pmn_file'),           #FUN-A50102   
                      " WHERE pmm01 = pmn01 ",
                      "   AND pmm99 = '",g_flow99,"'"
         
         CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1                #FUN-A50102 
         CALL cl_parse_qry_sql(l_sql1,g_from_plant) RETURNING l_sql1   #FUN-A50102	
         PREPARE pmn_gper FROM l_sql1
         DECLARE pmn_gcus CURSOR FOR pmn_gper
         
         FOR l_i = p_last TO 1 STEP -1
            
            LET l_oea61 = 0
            LET l_oea1008 = 0
            LET l_pmm40 = 0
            LET l_pmm40t = 0
         
            FOREACH pmn_gcus INTO g_pmn.* 
               IF SQLCA.SQLCODE <> 0 THEN
                  EXIT FOREACH 
               END IF 
         
               CALL s_pox(g_pmm.pmm904,l_i,g_pmn.pmn33)  #NO.TQC-680098
                RETURNING p_pox03,p_pox05,p_pox06,p_cnt
               IF p_cnt = 0 THEN
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
               IF l_source = 0 THEN  #來源站
                  LET l_dbs_now = g_dbs
                  LET l_plant_now = g_plant               #FUN-A50102 
               ELSE
                  SELECT poy04 INTO l_poy04 FROM poy_file 
                   WHERE poy01 = g_poz.poz01
                     AND poy02 = l_source
                  SELECT azp03 INTO l_dbs_now FROM azp_file 
                   WHERE azp01 = l_poy04
                   LET l_plant_now = l_poy04             #FUN-A50102 
               END IF
               LET l_dbs_now = s_dbstring(l_dbs_now)  #TQC-950010 ADD     
 
               LET g_plant_new = l_poy04 
               CALL s_gettrandbs()
               LET l_dbs_now_tra = g_dbs_tra      #TRAN DB
               
               ##-------------取得當站資料庫(S/O)-----------------
               SELECT poy04 INTO l_poy04 FROM poy_file 
                WHERE poy01 = g_poz.poz01
                  AND poy02 = l_i
               SELECT azp03 INTO l_dbs_up FROM azp_file 
                WHERE azp01 = l_poy04
               LET l_plant_up = l_poy04             #FUN-980020 
               LET l_dbs_up = s_dbstring(l_dbs_up)  #TQC-950010 ADD       
               LET p_poy04 = l_poy04
               
               LET g_plant_new = l_plant_up
               CALL s_gettrandbs()
               LET l_dbs_up_tra = g_dbs_tra      #TRAN DB
            
               ##-------------取得終站資料庫(S/O)-----------------
               SELECT poy04 INTO l_poy04 FROM poy_file 
                WHERE poy01 = g_poz.poz01
                  AND poy02 = p_last
               SELECT azp03 INTO l_dbs_last FROM azp_file 
                WHERE azp01 = l_poy04
               LET l_plant_last = l_poy04
               LET l_dbs_last = s_dbstring(l_dbs_last)  #TQC-950010 ADD     
         
               LET g_plant_new = l_plant_last 
               CALL s_gettrandbs()
               LET l_dbs_last_tra = g_dbs_tra      #TRAN DB
 
               IF p_pox03 = "1" OR p_pox03 = "2" THEN    #取價方式不為逆推，不需執行
                  CONTINUE FOR
               END IF
               CALL s_pox(g_pmm.pmm904,l_i-1,g_pmn.pmn33)  
                RETURNING p_pox03,p_pox05,p_pox06,p_cnt
         
               CALL s_pox(g_pmm.pmm904,l_i-1,g_pmn.pmn33)  
                RETURNING p_pox03,p_pox05,p_pox06,p_cnt
 
         
               IF p_pox03 = "3" THEN   #判斷是依最終廠商取價還是下游廠商取價
                  LET l_sql1 = "SELECT pmm_file.*,pmn_file.* ",
                             # "  FROM ",l_dbs_last_tra CLIPPED,"pmm_file,",          #FUN-A50102 mark
                             #           l_dbs_last_tra CLIPPED,"pmn_file ",          #FUN-A50102 mark
                               "  FROM ",cl_get_target_table(l_plant_last,'pmm_file'),",", #FUN-A50102 
                                         cl_get_target_table(l_plant_last,'pmn_file'),     #FUN-A50102 
                               " WHERE pmm01 = pmn01 ",
                               "   AND pmm99 = '",g_flow99,"'",
                               "   AND pmn02 = ",g_pmn.pmn02
               ELSE
                  LET l_sql1 = "SELECT pmm_file.*,pmn_file.* ",
                             # "  FROM ",l_dbs_up_tra CLIPPED,"pmm_file,",            #FUN-A50102 mark
                             #           l_dbs_up_tra CLIPPED,"pmn_file ",            #FUN-A50102 mark
                               "  FROM ",cl_get_target_table(l_plant_up,'pmm_file'),",",   #FUN-A50102  
                                         cl_get_target_table(l_plant_up,'pmn_file'),       #FUN-A50102
                               " WHERE pmm01 = pmn01 ",
                               "   AND pmm99 = '",g_flow99,"'",
                               "   AND pmn02 = ",g_pmn.pmn02
               END IF
         
 	       CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
               CALL cl_parse_qry_sql(l_sql1,l_plant_new) 
                    RETURNING l_sql1 #FUN-980092
               PREPARE pmn_uper FROM l_sql1
               DECLARE pmn_ucus CURSOR FOR pmn_uper
         
               OPEN pmn_ucus
               FETCH pmn_ucus INTO u_pmm.*,u_pmn.*
               CLOSE pmn_ucus
         
               LET l_sql1 = "SELECT pmm_file.*,pmn_file.* ",
                          # "  FROM ",l_dbs_now_tra CLIPPED,"pmm_file,",           #FUN-A50102 mark
                          #           l_dbs_now_tra CLIPPED,"pmn_file ",           #FUN-A50102 mark
                          # "  FROM ",cl_get_target_table(l_plant_new,'pmm_file'),",", #FUN-A50102 #MOD-B90179 mark
                          #           cl_get_target_table(l_plant_new,'pmn_file'),     #FUN-A50102 #MOD-B90179 mark
                            "  FROM ",cl_get_target_table(l_plant_now,'pmm_file'),",",             #MOD-B90179
                                      cl_get_target_table(l_plant_now,'pmn_file'),                 #MOD-B90179 
                            " WHERE pmm01 = pmn01 ",
                            "   AND pmm99 = '",g_flow99,"'",
                            "   AND pmn02 = ",g_pmn.pmn02
               
               CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
              #CALL cl_parse_qry_sql(l_sql1,l_plant_new) #MOD-B90179 mark 
               CALL cl_parse_qry_sql(l_sql1,l_plant_now) #MOD-B90179 
                    RETURNING l_sql1 #FUN-980092
               PREPARE pmn_nper FROM l_sql1
               DECLARE pmn_ncus CURSOR FOR pmn_nper
         
               OPEN pmn_ncus
               FETCH pmn_ncus INTO n_pmm.*,n_pmn.*
               CLOSE pmn_ncus
         
               #計價方式來判斷
               CASE p_pox05
                  WHEN '1'
                     IF u_pmm.pmm22 = n_pmm.pmm22 THEN
                        LET n_pmn.pmn31 = u_pmn.pmn31 * p_pox06/100
                     END IF
                     IF g_pmm.pmm22 <> l_pmm.pmm22 THEN
                        LET l_price = u_pmn.pmn31 * u_pmm.pmm42 #換算回本幣
                        IF p_pox03 = "3" THEN
                           #CHI-D60041 -- add start --
                           CALL p801_pod01(l_plant_last)
                              RETURNING l_pod01
                           #CHI-D60041 -- add end --
                           CALL s_currm(n_pmm.pmm22,u_pmm.pmm04,l_pod01,l_plant_last)  #FUN-980020    #CHI-D60041 modify g_pod.pod01 -> l_pod01
                              RETURNING l_currm
                        ELSE
                           #CHI-D60041 -- add start --
                           CALL p801_pod01(l_plant_up)
                              RETURNING l_pod01
                           #CHI-D60041 -- add end --
                           CALL s_currm(n_pmm.pmm22,u_pmm.pmm04,l_pod01,l_plant_up)    #FUN-980020    #CHI-D60041 modify g_pod.pod01 -> l_pod01
                              RETURNING l_currm
                        END IF
                        LET n_pmn.pmn31= l_price / l_currm * p_pox06 / 100
                     END IF
         
                     LET l_sql1 = "SELECT * ",
                                # " FROM ",l_dbs_now CLIPPED,"azi_file ",                #FUN-A50102 mark
                                  " FROM ",cl_get_target_table(l_plant_now,'azi_file'),  #FUN-A50102         
                                  " WHERE azi01='",n_pmm.pmm22,"' "
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1              #FUN-920032
         CALL cl_parse_qry_sql(l_sql1,l_plant_now) RETURNING l_sql1  #FUN-A50102
                     PREPARE azi_np1 FROM l_sql1
                       IF STATUS THEN   #TQC-840058 add
                        LET g_success = 'N'  #No.FUN-8A0086
                        IF g_bgerr THEN
                           CALL s_errmsg("","","azi_np1",STATUS,1)
                        ELSE
                           CALL cl_err3("","","","",STATUS,"","azi_np1",1)
                        END IF
                       END IF           #TQC-840058 add
                     DECLARE azi_nc1 CURSOR FOR azi_np1
                     OPEN azi_nc1
                     FETCH azi_nc1 INTO l_azi.* 
                     CLOSE azi_nc1
         
                     IF cl_null(l_azi.azi03) THEN 
                        LET l_azi.azi03=5
                     END IF
                     CALL cl_digcut(n_pmn.pmn31,l_azi.azi03) RETURNING n_pmn.pmn31
                  WHEN '2'
                     #讀取合乎料件條件之價格
                     CALL s_pow(g_pmm.pmm904,u_pmn.pmn04,p_poy04,u_pmn.pmn33)
                            RETURNING g_sw,n_pmn.pmn31
                      IF g_sw='N' THEN
                         IF g_pod.pod02 = 'N' AND i <> p_last THEN	#MOD-990144
                            IF g_bgerr THEN
                               CALL s_errmsg("","","sel pow.","axm-333",1)
                            ELSE
                               CALL cl_err3("","","","","axm-333","","sel pow.",1)
                            END IF
                            LET g_success = 'N'
                         END IF
                         LET n_pmn.pmn31 =0 
                      END IF
                  WHEN '3'   #單價若為0, 則給0, 否則抓料件之固定價格
                      IF u_pmn.pmn31 <> 0 THEN        #no.6215
                         CALL s_pow(g_pmm.pmm904,u_pmn.pmn04,p_poy04,u_pmn.pmn33)
                            RETURNING g_sw,n_pmn.pmn31
                         IF g_sw='N' THEN
                            IF g_pod.pod02 = 'N' AND i <> p_last THEN	#MOD-990144
                               IF g_bgerr THEN
                                  CALL s_errmsg("","","sel pow.","axm-333",1)
                               ELSE
                                  CALL cl_err3("","","","","axm-333","","sel pow.",1)
                               END IF
                               LET g_success = 'N'
                            END IF
                           LET n_pmn.pmn31 = 0
                         END IF
                      ELSE
                         LET n_pmn.pmn31 = 0
                      END IF
               END CASE
         
               IF n_pmn.pmn31 IS NULL THEN
                  LET n_pmn.pmn31 = 0
               END IF
               LET n_pmn.pmn31t = n_pmn.pmn31 * (1+n_pmm.pmm43/100)
         
               LET n_pmn.pmn44 = n_pmn.pmn31 * n_pmm.pmm42  #本幣單價=單價*匯率 
               CALL cl_digcut(n_pmn.pmn44,l_azi.azi03) RETURNING n_pmn.pmn44
 
               LET n_pmn.pmn88 = n_pmn.pmn87*n_pmn.pmn31
               LET n_pmn.pmn88t = n_pmn.pmn87*n_pmn.pmn31t
               CALL cl_digcut(n_pmn.pmn88,l_azi.azi04) RETURNING n_pmn.pmn88
               CALL cl_digcut(n_pmn.pmn88t,l_azi.azi04) RETURNING n_pmn.pmn88t
 
               #回寫當站採購單身
              #LET l_sql2 = "UPDATE ",l_dbs_tra CLIPPED,"pmn_file",  #FUN-980092    #FUN-A50102 mark
              #LET l_sql2 = "UPDATE ",cl_get_target_table(l_plant_new,'pmn_file'),  #FUN-A50102 #MOD-B90179 mark
               LET l_sql2 = "UPDATE ",cl_get_target_table(l_plant_now,'pmn_file'),              #MOD-B90179 
                            "   SET pmn31 = ?,pmn31t = ? ,pmn44 = ?,",
                            "       pmn88 = ?,pmn88t = ? ",   #No.TQC-6B0136
                            " WHERE pmn01=? AND pmn02=? "
 	       CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
              #CALL cl_parse_qry_sql(l_sql2,l_plant_new) #MOD-B90179 mark
               CALL cl_parse_qry_sql(l_sql2,l_plant_now) #MOD-B90179 
                    RETURNING l_sql2 #FUN-980092
               PREPARE upd_npmn FROM l_sql2
               EXECUTE upd_npmn USING n_pmn.pmn31,n_pmn.pmn31t,n_pmn.pmn44,
                                      n_pmn.pmn88,n_pmn.pmn88t,   #No.TQC-6B0136
                                      n_pmn.pmn01,n_pmn.pmn02
               IF SQLCA.sqlcode THEN
                  IF g_bgerr THEN
                     CALL s_errmsg("","","upd npmn.",SQLCA.sqlcode,1)
                  ELSE
                     CALL cl_err3("","","","",SQLCA.sqlcode,"","upd npmn.",1)
                  END IF
                  LET g_success = 'N'
               END IF
         
               #採購單頭總金額
               LET l_pmm40 = l_pmm40 + n_pmn.pmn31*n_pmn.pmn87  #No.TQC-6A0084
               CALL cl_digcut(l_pmm40,l_azi.azi04) RETURNING l_pmm40
               LET l_pmm40t = l_pmm40 * (1.00+n_pmm.pmm43 / 100.0)
               CALL cl_digcut(l_pmm40t,l_azi.azi04) RETURNING l_pmm40t
         
               LET l_sql1 = "SELECT oea_file.*,oeb_file.* ",
                          # "  FROM ",l_dbs_up_tra CLIPPED,"oea_file,",             #FUN-A50102 mark
                          #           l_dbs_up_tra CLIPPED,"oeb_file ",             #FUN-A50102 mark
                           #"  FROM ",cl_get_target_table(l_plant_new,'oea_file'),",",  #FUN-A50102 #MOD-CA0190 mark
                           #          cl_get_target_table(l_plant_new,'oeb_file'),      #FUN-A50102 #MOD-CA0190 mark
                            "  FROM ",cl_get_target_table(l_plant_up,'oea_file'),",",  #MOD-CA0190 add
                                      cl_get_target_table(l_plant_up,'oeb_file'),      #MOD-CA0190 add
                            " WHERE oea01 = oeb01 ",
                            "   AND oea99 = '",g_flow99,"'",
                            "   AND oeb03 = ",g_pmn.pmn02
               
               CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
               CALL cl_parse_qry_sql(l_sql1,l_plant_new) 
                    RETURNING l_sql1 #FUN-980092
               PREPARE oeb_nper FROM l_sql1
               DECLARE oeb_ncus CURSOR FOR oeb_nper
               
               OPEN oeb_ncus
               FETCH oeb_ncus INTO n_oea.*,n_oeb.*
               CLOSE oeb_ncus
               
               LET n_oeb.oeb13 = n_pmn.pmn31
               LET n_oeb.oeb17 = n_oeb.oeb13
               
               CALL cl_digcut(n_oeb.oeb13,l_azi.azi03) RETURNING n_oeb.oeb13
               CALL cl_digcut(n_oeb.oeb17,l_azi.azi03) RETURNING n_oeb.oeb17
               
               IF n_oea.oea213 = 'N' THEN              #表示不含稅
                  LET n_oeb.oeb14 = n_oeb.oeb917* n_oeb.oeb13  #No.TQC-6A0084
                  LET n_oeb.oeb14t= n_oeb.oeb14*(1+n_oea.oea211/100)
               ELSE
                  LET n_oeb.oeb13 = n_oeb.oeb13*(1+n_oea.oea211/100)
                  LET n_oeb.oeb14t= n_oeb.oeb917*n_oeb.oeb13  #No.TQC-6A0084
                  LET n_oeb.oeb14 = n_oeb.oeb14t/(1+n_oea.oea211/100)
               END IF
               
               CALL cl_digcut(n_oeb.oeb14,l_azi.azi04) RETURNING n_oeb.oeb14
               CALL cl_digcut(n_oeb.oeb14t,l_azi.azi04) RETURNING n_oeb.oeb14t
               
               #回寫下游訂單單身
              #LET l_sql2 = "UPDATE ",l_dbs_up_tra CLIPPED,"oeb_file",             #FUN-A50102 mark
              #LET l_sql2 = "UPDATE ",cl_get_target_table(l_plant_new,'oeb_file'), #FUN-A50102 #MOD-CA0190 mark
               LET l_sql2 = "UPDATE ",cl_get_target_table(l_plant_up,'oeb_file'),   #MOD-CA0190 add
                            "   SET oeb13 = ?, oeb17 = ? , oeb14 = ?, oeb14t=? ",
                            " WHERE oeb01=? AND oeb03=? "
 	       CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
               CALL cl_parse_qry_sql(l_sql1,l_plant_new) 
                    RETURNING l_sql1 #FUN-980092
               PREPARE upd_noeb FROM l_sql2
               EXECUTE upd_noeb USING n_oeb.oeb13,n_oeb.oeb17,n_oeb.oeb14,n_oeb.oeb14t,
                                      n_oeb.oeb01,n_oeb.oeb03
               IF SQLCA.sqlcode THEN
                  IF g_bgerr THEN
                     CALL s_errmsg("","","upd noeb.",SQLCA.sqlcode,1)
                  ELSE
                     CALL cl_err3("","","","",SQLCA.sqlcode,"","upd noeb.",1)
                  END IF
                  LET g_success = 'N'
               END IF
               
               LET l_oea61 = l_oea61 + n_oeb.oeb14 
               CALL cl_digcut(l_oea61,l_azi.azi04) RETURNING l_oea61
               
               #IF l_aza.aza50 = 'Y' THEN  # TQC-D40086 
                  IF cl_null(l_oea.oea1008) THEN LET l_oea.oea1008 = 0 END IF #TQC-D40086 add
                  LET l_oea1008 = l_oea1008 + n_oeb.oeb14t
                  CALL cl_digcut(l_oea1008,l_azi.azi04) RETURNING l_oea1008
               #END IF  # TQC-D40086 add 1008
         
            END FOREACH 
            
            #回寫下游訂單單頭
           #LET l_sql2 = "UPDATE ",l_dbs_up_tra CLIPPED,"oea_file",              #FUN-A50102 mark
           #LET l_sql2 = "UPDATE ",cl_get_target_table(l_plant_new,'oea_file'),  #FUN-A50102 #MOD-CA0190 mark
            LET l_sql2 = "UPDATE ",cl_get_target_table(l_plant_up,'oea_file'),    #MOD-CA0190 add
                         "   SET oea61 = ?, oea1008=?",
                         " WHERE oea01=? "
            DISPLAY l_sql2
 	    CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
            CALL cl_parse_qry_sql(l_sql1,l_plant_new) 
                 RETURNING l_sql1 #FUN-980092
            PREPARE upd_noea FROM l_sql2
            EXECUTE upd_noea USING l_oea61,l_oea1008,n_oea.oea01
            IF SQLCA.sqlcode THEN
               IF g_bgerr THEN
                  CALL s_errmsg("","","upd noea.",SQLCA.sqlcode,1)
               ELSE
                  CALL cl_err3("","","","",SQLCA.sqlcode,"","upd noea.",1)
               END IF
               LET g_success = 'N'
            END IF
         
            #回寫當站採購單頭
           #LET l_sql2 = "UPDATE ",l_dbs_now_tra CLIPPED,"pmm_file",  #FUN-980092  #FUN-A50102 mark
           #LET l_sql2 = "UPDATE ",cl_get_target_table(l_plant_new,'pmm_file'),    #FUN-A50102 #MOD-B90179 mark
            LET l_sql2 = "UPDATE ",cl_get_target_table(l_plant_now,'pmm_file'),                #MOD-B90179
                         "   SET pmm40 = ?, pmm40t=?",
                         " WHERE pmm01=? "
 	    CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
           #CALL cl_parse_qry_sql(l_sql1,l_plant_new) #MOD-B90179 mark 
            CALL cl_parse_qry_sql(l_sql1,l_plant_now) #MOD-B90179
                 RETURNING l_sql1 #FUN-980092
            PREPARE upd_npmm FROM l_sql2
            EXECUTE upd_npmm USING l_pmm40,l_pmm40t,n_pmm.pmm01
            IF SQLCA.sqlcode THEN
               IF g_bgerr THEN
                  CALL s_errmsg("","","upd npmm.",SQLCA.sqlcode,1)
               ELSE
                  CALL cl_err3("","","","",SQLCA.sqlcode,"","upd npmm.",1)
               END IF
               LET g_success = 'N'
            END IF
         
         END FOR
      END IF
      
      #更新採購單檔之三角貿易拋轉否='Y',起始採購單否='Y'
      MESSAGE ''
##應該移到最後整個拋轉程式都成功了才update---
      #No.FUN-A10099  --Begin
      #UPDATE pmm_file SET pmm905 = 'Y',
      #                    pmm906 = 'Y'
      # WHERE pmm01 = g_pmm.pmm01
     #LET g_sql = " UPDATE ",g_from_dbs_tra CLIPPED,"pmm_file",             #FUN-A50102 mark
      LET g_sql = " UPDATE ",cl_get_target_table(g_from_plant,'pmm_file'),  #FUN-A50102 
                  "    SET pmm905 = 'Y',",
                  "        pmm906 = 'Y' ",
                  "  WHERE pmm01 = '",g_pmm.pmm01,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102
      CALL cl_parse_qry_sql(g_sql,g_from_plant) RETURNING g_sql #FUN-A50102
      PREPARE p801_upd_pmm FROM g_sql
      EXECUTE p801_upd_pmm
      #No.FUN-A10099  --End
      IF SQLCA.SQLCODE <> 0 OR sqlca.sqlerrd[3]=0 THEN
         LET g_success='N'
         IF g_bgerr THEN
            CALL s_errmsg("pmm01",g_pmm.pmm01,"upd pmm",STATUS,1)
            CONTINUE FOREACH
         ELSE
            CALL cl_err3("upd","pmm_file",g_pmm.pmm01,"",STATUS,"","upd pmm",1)
            EXIT FOREACH
         END IF
      END IF
      LET l_stu_p_h = ' '          #TQC-9C0066
      LET l_stu_o_h = ' '          #TQC-9C0066
   END FOREACH 
   IF l_flag1 = 'Y' THEN
      #No.FUN-A30056  --Begin
      IF g_bgerr THEN
         CALL s_errmsg('','','','mfg1006',1)
      ELSE
         CALL cl_err('','mfg1006',1)
      END IF
      #No.FUN-A30056  --End
      LET g_success='N' 
   END IF
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF
 
 
END FUNCTION
 
FUNCTION p801_azp(l_i)
  DEFINE l_source    LIKE type_file.num5,    #No.FUN-680136 SMALLINT, #上一站
         l_i         LIKE type_file.num5,    #當站  #No.FUN-680136 SMALLINT
         l_next      LIKE type_file.num5,    #No.FUN-680136 SMALLINT, #下一站
         l_sql1      LIKE type_file.chr1000  #No.FUN-680136 VARCHAR(800)
 
      LET l_source = l_i -1   
      SELECT poy03 INTO p_oea03 
        FROM poy_file
       WHERE poy01 = g_poz.poz01
         AND poy02 = l_source
     ##-------------取當站資料庫(SO)-----------------
     SELECT * INTO g_poy.* FROM poy_file
      WHERE poy01 = g_poz.poz01 AND poy02 = l_i
     SELECT * INTO l_azp.* FROM azp_file WHERE azp01 = g_poy.poy04
     LET l_plant_new = l_azp.azp01             #FUN-980020
     LET l_dbs_new = s_dbstring(l_azp.azp03)   #TQC-950010 ADD    
 
     LET g_plant_new = l_azp.azp01
     CALL s_gettrandbs()      
     LET l_dbs_tra = g_dbs_tra
 
     LET l_sql1 = "SELECT * ",                         #取得來源本幣
                # " FROM ",l_dbs_new CLIPPED,"aza_file ",               #FUN-A50102 mark
                  " FROM ",cl_get_target_table(l_plant_new,'aza_file'), #FUN-A50102  
                  " WHERE aza01 = '0' "
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1                  #FUN-920032
         CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1      #FUN-A50102 
     PREPARE aza_p1 FROM l_sql1
     IF SQLCA.SQLCODE THEN
        IF g_bgerr THEN
           CALL s_errmsg("","","aza_p1",SQLCA.sqlcode,1)
        ELSE
           CALL cl_err3("","","","",SQLCA.sqlcode,"","aza_p1",1)
        END IF
        LET g_success='N'   #MOD-840588 add
     END IF
     DECLARE aza_c1  CURSOR FOR aza_p1
     OPEN aza_c1
     FETCH aza_c1 INTO l_aza.*
     CLOSE aza_c1
     LET l_sql1 = "SELECT * ",
                # " FROM ",l_dbs_new CLIPPED,"sma_file ",                  #FUN-A50102 mark
                  " FROM ",cl_get_target_table(l_plant_new,'sma_file'),    #FUN-A50102
                  " WHERE sma00= '0' "
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1              #FUN-920032
         CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1  #FUN-A50102
     PREPARE sma_p1 FROM l_sql1
     IF SQLCA.SQLCODE THEN
        IF g_bgerr THEN
           CALL s_errmsg("","","sma_p1",SQLCA.sqlcode,1)
        ELSE
           CALL cl_err3("","","","",SQLCA.sqlcode,"","sma_p1",1)
        END IF
        LET g_success='N'   #MOD-840588 add
     END IF
     DECLARE sma_c1 CURSOR FOR sma_p1
     OPEN sma_c1
     FETCH sma_c1 INTO l_sma.*
     CLOSE sma_c1
     LET p_poy04  = g_poy.poy04
     LET p_azi01t = g_poy.poy05    #當站幣別 #MOD-630099 做備註而以,並沒有改程式
     LET p_poy07  = g_poy.poy07    #收款條件
     LET p_poy08  = g_poy.poy08    #SO稅別
     LET p_poy10  = g_poy.poy10    #銷售分類
     LET p_poy12  = g_poy.poy12    #發票別
     LET p_poy11  = g_poy.poy11    #倉庫別
     LET p_poy26  = g_poy.poy26    #是否計算業績
     LET p_poy27  = g_poy.poy27    #業績歸屬方
     LET p_poy28  = g_poy.poy28    #原因碼
     LET p_poy29  = g_poy.poy29    #代送商
     LET p_poy33  = g_poy.poy33    #債權代碼
 
     ##-------------取得下一站資料(P/O)-----------------
      LET l_next = l_i + 1      
      SELECT * INTO n_poy.* FROM poy_file               #取得當站流程設定
       WHERE poy01 = g_poz.poz01 AND poy02 = l_next 
      IF SQLCA.SQLCODE != 100 THEN
         LET p_pmm09 = n_poy.poy03   #廠商代號
         IF g_poz.poz09 = 'Y' THEN    #指定幣別        #FUN-670007
             LET p_azi01 = n_poy.poy05   #採購幣別#下站#MOD-630099 做備註而以,並沒有
         END IF                                        #FUN-670007
         LET p_poy06 = n_poy.poy06   #付款條件  
         LET p_poy09 = n_poy.poy09   #PO稅別   
         IF g_poz.poz09 = 'Y' THEN    #指定幣別
             LET p_azi01t= g_poy.poy05 #流程幣別
         END IF
#----取得下一站的ds
         SELECT azp03 INTO l_dbs_next FROM azp_file WHERE azp01 =n_poy.poy04
           LET l_plant_next = n_poy.poy04       #No.FUN-980059
           LET l_dbs_next =s_dbstring(l_dbs_next)    #TQC-950010 ADD       
           IF SQLCA.sqlcode =100 THEN
              LET l_dbs_next =l_dbs_new
           END IF
      ELSE
         LET l_dbs_next =l_dbs_new     #No.TQC-690065
         IF l_i = p_last AND NOT cl_null(g_pmm.pmm50) THEN
            LET p_pmm09 = g_pmm.pmm50       
            LET l_sql1 = "SELECT pmc17,pmc22,pmc47 ", #慣用付款方式及稅別
                       # "  FROM ",l_dbs_new CLIPPED,"pmc_file ",               #FUN-A50102 mark
                         "  FROM ",cl_get_target_table(l_plant_new,'pmc_file'),   #FUN-A50102
                         " WHERE pmc01 = '",g_pmm.pmm50,"'"
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1             #FUN-920032
         CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1   #FUN-A50102
            PREPARE pmm_prepare FROM l_sql1
            IF STATUS THEN
               IF g_bgerr THEN
                  CALL s_errmsg("","","pmm_p1",STATUS,1)
               ELSE
                  CALL cl_err3("","","","",STATUS,"","pmm_p1",1)
               END IF
               LET g_success='N'   #MOD-840588 add
            END IF
            DECLARE pmm_p1_curs CURSOR FOR pmm_prepare
            OPEN pmm_p1_curs
            FETCH pmm_p1_curs INTO p_poy06,p_azi01,p_poy09
            IF SQLCA.sqlcode THEN
               LET p_poy06 = ''
               LET p_azi01 = ''
               LET p_poy09 = ''
            END IF
            CLOSE pmm_p1_curs
         ELSE
            LET p_pmm09 = ''            #廠商代號
            LET p_azi01 = ''            #採購幣別
            LET p_poy06 = ''            #付款條件
            LET p_poy09 = ''            #PO稅別
         END IF
      END IF
 
      IF g_poz.poz09 = 'N' THEN         #使用來源幣別
         LET p_azi01 = g_pmm.pmm22
         LET p_azi01t= g_pmm.pmm22
      END IF
 
END FUNCTION
 
#確定單頭所使用之幣別 ,匯率
FUNCTION p801_curr(l_i,l_pmm01,l_pmm22)
  DEFINE l_i LIKE type_file.num5,    #No.FUN-680136 SMALLINT
         l_pmm01 LIKE pmm_file.pmm01,
         l_pmm22 LIKE pmm_file.pmm22,
         l_cnt LIKE type_file.num5,    #No.FUN-680136 SMALLINT
         l_azi01   LIKE azi_file.azi01,
         l_pox05   LIKE pox_file.pox05,  #計價方式
         l_pmn33   LIKE pmn_file.pmn33 ,
         min_pmn33 LIKE pmn_file.pmn33 
     LET l_cnt = 0
     #讀取採購單單身檔(pmn_file)
     #No.FUN-A10099  --Begin
     #DECLARE pmn_cus3 CURSOR FOR
     #   SELECT pmn33
     #     FROM pmn_file
     #    WHERE pmn01 = l_pmm01
    #LET g_sql = "SELECT pmn33 FROM ",g_from_dbs_tra CLIPPED,"pmn_file",            #FUN-A50102 mark
     LET g_sql = "SELECT pmn33 FROM ",cl_get_target_table(g_from_plant,'pmn_file'), #FUN-A50102 
                 " WHERE pmn01 = '",l_pmm01,"'"
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql               #FUN-A50102
     CALL cl_parse_qry_sql(g_sql,g_from_plant) RETURNING g_sql  #FUN-A50102 
     PREPARE p801_px2 FROM g_sql
     DECLARE pmn_cus3 CURSOR FOR p801_px2
     #No.FUN-A10099  --End
     FOREACH pmn_cus3 INTO l_pmn33
        IF SQLCA.SQLCODE <>0 THEN EXIT FOREACH END IF 
        LET l_cnt=l_cnt+1
        #讀取該料號之計價方式(依流程代碼+生效日期+廠商)
        CALL s_pox(g_pmm.pmm904,l_i,g_pmn.pmn33)
          RETURNING p_pox03,p_pox05,p_pox06,p_cnt
        IF p_cnt = 0 THEN
           IF g_bgerr THEN
              CALL s_errmsg("","","tri-007",SQLCA.sqlcode,1)
           ELSE
              CALL cl_err3("","","","",SQLCA.sqlcode,"","tri-007",1)
           END IF
           LET g_success = 'N'
           EXIT FOREACH
        END IF
        IF l_cnt=1 THEN
           LET min_pmn33 = l_pmn33
           LET l_pox05 = p_pox05
        END IF   
        #記錄最小預計交貨日之計價方式(單頭幣別之依據)
        IF g_pmn.pmn33 < min_pmn33 THEN
           LET min_pmn33 = g_pmn.pmn33
           LET l_pox05 = p_pox05
        END IF
     END FOREACH
     RETURN l_azi01
END FUNCTION
 
#讀取幣別檔之資料
FUNCTION p801_azi(l_pmm22)
  DEFINE l_sql1 LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(800)
  DEFINE l_pmm22  LIKE pmm_file.pmm22
 
   #讀取l_dbs_new 之本幣資料
   LET l_sql1 = "SELECT * ",
              # " FROM ",l_dbs_new CLIPPED,"azi_file ",                 #FUN-A50102 mark
                " FROM ",cl_get_target_table(l_plant_new,'azi_file'),   #FUN-A50102 
                " WHERE azi01='",l_pmm22,"' "
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1                 #FUN-920032
         CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1     #FUN-A50102 
   PREPARE azi_p1 FROM l_sql1
   IF STATUS THEN
      IF g_bgerr THEN
         CALL s_errmsg("","","azi_p1",STATUS,1)
      ELSE
         CALL cl_err3("","","","",STATUS,"","azi_p1",1)
      END IF
      LET g_success='N'   #MOD-840588 add
   END IF
   DECLARE azi_c1 CURSOR FOR azi_p1
   OPEN azi_c1
   FETCH azi_c1 INTO l_azi.* 
   CLOSE azi_c1
END FUNCTION
 
#讀取帳款客戶相關之資料
FUNCTION p801_oea03(l_plant,l_occ01)
  DEFINE l_sql1 LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(800)
         l_dbs  LIKE type_file.chr21,   #No.FUN-680136 VARCHAR(21)
         l_occ01 LIKE occ_file.occ01,
         l_occ02 LIKE occ_file.occ02,
         l_occ04 LIKE occ_file.occ04,   #MOD-BA0172 add
         l_occ08 LIKE occ_file.occ08,
         l_occ11 LIKE occ_file.occ11,
         l_occ43 LIKE occ_file.occ43,
         l_occ44 LIKE occ_file.occ44,
         l_occ45 LIKE occ_file.occ45,
         l_occ1005 LIKE occ_file.occ1005,
         l_occ1006 LIKE occ_file.occ1006,
         l_occ1022 LIKE occ_file.occ1022
  DEFINE l_plant   LIKE azp_file.azp01 
  DEFINE l_dbs_tra LIKE type_file.chr21 
 
   IF cl_null(l_plant) THEN 
      LET l_dbs = NULL 
      LET l_dbs_tra = NULL 
   ELSE 
      LET g_plant_new = l_plant CLIPPED
      CALL s_getdbs()
      LET l_dbs = g_dbs_new          #BASE DB
      
      CALL s_gettrandbs()
      LET l_dbs_tra = g_dbs_tra      #TRAN DB
   END IF 
 
   LET l_occ02=''  LET l_occ08=' ' LET l_occ11=' '
   LET l_occ43=''  LET l_occ44=' ' LET l_occ45=' '
   LET l_occ1005=''   
   LET l_occ04=''  #MOD-BA0172 add
   LET l_occ1006=''
   LET l_occ1022=''
   LET l_sql1 = "SELECT occ02,occ04,occ08,occ11,occ43,occ44,occ45, ", #MOD-BA0172 add occ04
                "       occ1005,occ1006,occ1022              ",  #FUN-620025 
              # " FROM ",l_dbs CLIPPED,"occ_file ",              #FUN-A50102 mark
                " FROM ",cl_get_target_table(l_plant,'occ_file'),#FUN-A50102  
                " WHERE occ01='",l_occ01,"' ",
                "   AND occacti = 'Y' "       #TQC-B80056
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
         CALL cl_parse_qry_sql(l_sql1,l_plant) RETURNING l_sql1#FUN-A50102
   PREPARE occ_p1 FROM l_sql1
   IF STATUS THEN
      LET g_success = 'N'  #No.FUN-8A0086
      IF g_bgerr THEN
         CALL s_errmsg("","","occ_p1",STATUS,1)
      ELSE
         CALL cl_err3("","","","",STATUS,"","occ_p1",1)
      END IF
   END IF
   DECLARE occ_c1 CURSOR FOR occ_p1
   OPEN occ_c1
   FETCH occ_c1 INTO  l_occ02,l_occ04,l_occ08,l_occ11,l_occ43,l_occ44,l_occ45, #MOD-BA0172 add occ04
                      l_occ1005,l_occ1006,l_occ1022                   #FUN-620025
   IF SQLCA.SQLCODE THEN
      LET g_msg=l_dbs CLIPPED,l_occ01 CLIPPED
      IF g_bgerr THEN
         CALL s_errmsg("","",g_msg,"mfg4106",1)
      ELSE
         CALL cl_err3("","","","","mfg4106","",g_msg,1)
      END IF
      LET g_success = 'N'
   END IF
   IF cl_null(l_occ44) THEN
      LET g_msg=l_dbs CLIPPED,l_occ01 CLIPPED
      IF g_bgerr THEN
         CALL s_errmsg("","",g_msg,"tri-016",1)
      ELSE
         CALL cl_err3("","","","","tri-016","",g_msg,1)
      END IF
      LET g_success = 'N'
   END IF
   IF cl_null(l_occ04) THEN LET l_occ04='' END IF #MOD-BA0172 add
   CLOSE occ_c1
   RETURN l_occ02,l_occ04,l_occ08,l_occ11,l_occ43,l_occ44,l_occ45, #MOD-BA0172 add occ04
          l_occ1005,l_occ1006,l_occ1022                   #FUN-620025
END FUNCTION
 
#No.8083 取得多角序號
FUNCTION p801_flow99()
     
     IF NOT cl_null(g_pmm.pmm99) THEN   #若訂單重拋時，不重取序號
        LET g_flow99 = g_pmm.pmm99 
     END IF
     IF cl_null(g_pmm.pmm99) AND tm.pmm905='N' THEN
        CALL s_flowauno('pmm',g_pmm.pmm904,g_pmm.pmm04)
             RETURNING g_sw,g_flow99
        IF g_sw THEN
           IF g_bgerr THEN
              CALL s_errmsg("","","","tri-011",1)
           ELSE
              CALL cl_err3("","","","","tri-011","","",1)
           END IF
           LET g_success = 'N' RETURN
        END IF
#若不先回寫流程代碼, 會造成當計價方式為"依最終供應商逆推時, 會得不到資料
       #No.FUN-A10099  --Begin
       #UPDATE pmm_file SET pmm99 = g_flow99 WHERE pmm01 = g_pmm.pmm01
       #LET g_sql = " UPDATE ",g_from_dbs_tra CLIPPED,"pmm_file",           #FUN-A50102 mark
        LET g_sql = " UPDATE ",cl_get_target_table(g_from_plant,'pmm_file'),#FUN-A50102 
                    "    SET pmm99 = '",g_flow99,"'",
                    "  WHERE pmm01 = '",g_pmm.pmm01,"'"
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102
        CALL cl_parse_qry_sql(g_sql,g_from_plant) RETURNING g_sql #FUN-A50102
        PREPARE p801_upd_pmm_p2 FROM g_sql
        EXECUTE p801_upd_pmm_p2
       #No.FUN-A10099  --End  
        IF SQLCA.SQLCODE THEN
           IF g_bgerr THEN
              CALL s_errmsg("pmm01",g_pmm.pmm01,"upd pmm99",SQLCA.sqlcode,1)
           ELSE
              CALL cl_err3("upd","pmm_file",g_pmm.pmm01,"",SQLCA.SQLCODE,"","upd pmm99",1)
           END IF
           LET g_success = 'N' RETURN
        END IF
        #馬上檢查是否有搶號
        LET g_cnt = 0 
       #No.FUN-A10099  --Begin
       #SELECT COUNT(*) INTO g_cnt FROM pmm_file WHERE pmm99 = g_flow99
       #LET g_sql = " SELECT COUNT(*) FROM ",g_from_dbs_tra CLIPPED,"pmm_file",            #FUN-A50102 mark
        LET g_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(g_from_plant,'pmm_file'), #FUN-A50102  
                    "  WHERE pmm99 = '",g_flow99,"'"
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102 
        CALL cl_parse_qry_sql(g_sql,g_from_plant) RETURNING g_sql #FUN-A50102 
        PREPARE p801_px3 FROM g_sql
        EXECUTE p801_px3 INTO g_cnt
       #No.FUN-A10099  --End
        IF g_cnt > 1 THEN
           IF g_bgerr THEN
              CALL s_errmsg("","","","tri-011",1)
           ELSE
              CALL cl_err3("","","","","tri-011","","",1)
           END IF
           LET g_success = 'N' RETURN
        END IF
     END IF
END FUNCTION 
 
#插入更新前對當前數據庫中的流程序號進行判斷
FUNCTION p801_iou(p_pmm99,p_pmm905,p_table) 
DEFINE p_pmm99  LIKE pmm_file.pmm99,
       p_pmm905 LIKE pmm_file.pmm905
DEFINE p_stu    LIKE type_file.chr1,     #No.FUN-680136 VARCHAR(01)
       p_dbs    LIKE type_file.chr21,    #No.FUN-680136 VARCHAR(31)
       p_dbs_tra    LIKE type_file.chr21,  #FUN-980092  
       p_sql    LIKE type_file.chr1000,  #No.FUN-680136 VARCHAR(1000)
       p_table  LIKE zta_file.zta02,     #No.FUN-680136 VARCHAR(10)
       p_n      LIKE type_file.num5      #No.FUN-680136 SMALLINT
DEFINE p_plant  LIKE azp_file.azp01 
DEFINE l_table  STRING
 
  IF NOT cl_null(p_pmm99) THEN
     IF cl_null(p_plant) THEN 
        LET p_dbs = NULL 
        LET p_dbs_tra = NULL 
     ELSE 
        LET g_plant_new = p_plant CLIPPED
        CALL s_getdbs()
        LET p_dbs = g_dbs_new          #BASE DB
        
        CALL s_gettrandbs()
        LET p_dbs_tra = g_dbs_tra      #TRAN DB
     END IF 
     LET l_table = p_table CLIPPED,"_file"
     IF p_table='oea'THEN
        LET p_sql = " SELECT COUNT(*) ",
                  # " FROM ",p_dbs_tra CLIPPED,p_table CLIPPED,"_file,",  #FUN-980092       #FUN-A50102 mark
                  #   p_dbs_tra CLIPPED,"oeb_file",                                         #FUN-A50102 mark
                    " FROM ",cl_get_target_table(l_plant_new,l_table),",",                      #FUN-A50102
                             cl_get_target_table(l_plant_new,'oeb_file'),                       #FUN-A50102   
                    " WHERE ",p_table CLIPPED,"99='",p_pmm99,"'",
                    "   AND oea01= oeb01",
                    "   AND oeb03= '",g_pmn.pmn02,"'"
     ELSE
        IF p_table='pmm' THEN
          LET p_sql = " SELECT COUNT(*) ",
                    # " FROM ",p_dbs_tra CLIPPED,p_table CLIPPED,"_file, ",               #FUN-A50102  mark
                    #   p_dbs_tra CLIPPED,"pmn_file",                                     #FUN-A50102  mark 
                      " FROM ",cl_get_target_table(l_plant_new,l_table),",",                  #FUN-A50102 
                               cl_get_target_table(l_plant_new,'pmn_file'),                   #FUN-A50102
                      " WHERE ",p_table CLIPPED,"99='",p_pmm99,"'",
                      "   AND pmm01=pmn01",
                      "   AND pmn02= '",g_pmn.pmn02,"'"
        END IF
     END IF
 	 CALL cl_replace_sqldb(p_sql) RETURNING p_sql          #FUN-920032
         CALL cl_parse_qry_sql(p_sql,l_plant_new) RETURNING p_sql  #FUN-A50102
     PREPARE iou_p1 FROM p_sql                                                  
          IF STATUS THEN
             LET g_success = 'N'  #No.FUN-8A0086
             IF g_bgerr THEN
                CALL s_errmsg("","","iou_p1",STATUS,1)
             ELSE
                CALL cl_err3("","","","",STATUS,"","iou_p1",1)
             END IF
          END IF
     DECLARE iou_c1 CURSOR FOR iou_p1                                           
     OPEN iou_c1                                                                
     FETCH iou_c1 INTO p_n                                                      
     CLOSE iou_c1
     IF p_n=0 AND p_pmm905='N' THEN     #判斷插入條件                           
        LET p_stu='I'                                                           
     ELSE                                                                       
        IF p_n=1 AND p_pmm905='Y' THEN  #判斷更新條件                           
           LET p_stu='U'                                                        
        ELSE                                                                    
          IF p_n=0 AND p_pmm905='Y' THEN  #判斷更新條件                           
             LET p_stu='I'                                                        
          ELSE 
             LET p_stu='F'                                                        
          END IF 
        END IF                                                                  
     END IF                                                                     
  ELSE
     LET p_stu='I'
  END IF
   
  display  'p_stu->',p_stu
 
   RETURN p_stu
 
END FUNCTION
 
#No.FUN-9C0071--------------------- 精簡程式----------------------------
#No.FUN-A10123 ...begin
#FUNCTION p801_def_no(l_dbs,l_rye01,l_rye02)         #FUN-A50102 mark
FUNCTION p801_def_no(l_plant,l_rye01,l_rye02)  
DEFINE l_dbs   LIKE azp_file.azp03
DEFINE l_rye01 LIKE rye_file.rye01
DEFINE l_rye02 LIKE rye_file.rye02
DEFINE l_sql   STRING
DEFINE l_no    LIKE poy_file.poy38
DEFINE l_plant LIKE azp_file.azp01
 
  #LET l_sql = "SELECT rye03 FROM ",l_dbs CLIPPED,"rye_file",                 #FUN-A50102 mark
   #FUN-C90050 mark begin---
   #LET l_sql = "SELECT rye03 FROM ",cl_get_target_table(l_plant,'rye_file'),  #FUN-A50102 
   #            " WHERE rye01 = ? AND rye02 = ? AND ryeacti='Y'"
   #CALL cl_replace_sqldb(l_sql) RETURNING l_sql            #FUN-A50102
   #CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql    #FUN-A50102 
   #PREPARE rye03_pre FROM l_sql
   #EXECUTE rye03_pre USING l_rye01,l_rye02 INTO l_no
   #IF SQLCA.sqlcode THEN
   #   IF g_bgerr THEN
   #      CALL s_errmsg('sel rye03',l_rye01,'rye_file',SQLCA.sqlcode,1)
   #   ELSE
   #      CALL cl_err3("sel","rye_file",l_rye01,l_rye02,'SQLCA.sqlcode',"","",1)
   #   END IF
   #   LET g_success = 'N'
   #   RETURN ''
   #END IF
   #FUN-C90050 mark end-----
   
   #FUN-C90050 add begin---
   CALL s_get_defslip(l_rye01,l_rye02,l_plant,'N') RETURNING l_no    
   IF cl_null(l_no) THEN
      IF g_bgerr THEN
         CALL s_errmsg('','','sel rye03','art-330',1)
      ELSE
         CALL cl_err3("sel","rye_file",l_rye01,l_rye02,'SQLCA.sqlcode',"","",1)
      END IF
      LET g_success = 'N'
      RETURN ''
   END IF
   #FUN-C90050 add end-----
   RETURN l_no
END FUNCTION
#No.FUN-A10123 ...end
#CHI-D60041 -- add start --
FUNCTION p801_pod01(p_plant)
DEFINE l_sql      STRING
DEFINE p_plant    LIKE type_file.chr10
DEFINE l_pod01    LIKE pod_file.pod01

   LET l_sql = "SELECT pod01 ",
               " FROM ",cl_get_target_table(p_plant,'pod_file'),
               " WHERE pod00 = '0'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
   PREPARE pod01_p FROM l_sql
   IF SQLCA.SQLCODE THEN CALL cl_err('pod01_p',SQLCA.SQLCODE,1) END IF
   DECLARE pod01_c CURSOR FOR pod01_p
   OPEN pod01_c
   FETCH pod01_c INTO l_pod01
   CLOSE pod01_c

   IF cl_null(l_pod01) THEN       #三角貿易使用匯率
      LET l_pod01='T'
   END IF

   RETURN l_pod01

END FUNCTION
#CHI-D60041 -- add end --
