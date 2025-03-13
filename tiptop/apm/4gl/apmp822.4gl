# Prog. Version..: '5.30.06-13.04.17(00010)'     #

#
# Pattern name...: apmp822.4gl
# Descriptions...: 代采購三角貿易入庫單拋轉作業(正拋)
# Date & Author..: 01/11/12 By Tommy
# Note...........: 由 axmp900 改寫
# Modify.........: No.7902 03/08/23 Kammy 幣別取位應用原幣幣別而非用各站的本幣
# Modify.........: No.8106 03/08/28 Kammy 1.流程抓取方式修改(poz_file,poy_file)
#                                         2.倉庫別帶流程代碼的 
#                                         3.注意︰正拋收貨單不重新取號，以免
#                                                 分批入庫時會對不到收貨單
# Modify.........: No.FUN-4C0011 04/12/01 By Mandy 單價金額位數改為dec(20,6)
# Modify.........: No.MOD-530418 05/03/20 By ching 問句使用 cl_confirm2
# Modify.........: No.FUN-550060 05/05/30 By Will 單據編號放大
# Modify.........: NO.FUN-560043 05/06/29 By Smapmin 根據雙單位做調整,多角序號放大,單號放大
# Modify.........: No.FUN-5A0176 05/11/01 By Sarah UPDATE收貨單(rva_file)前,需先檢查對應的采購單的
#                                                  pmm901是否為Y,若否則需show err,let g_success='N'
# Modify.........: No.MOD-5B0170 05/11/18 By Rosayu SQL中rvb_file之前加多工廠
# Modify.........: No.FUN-620025 06/02/20 By Tracy 流通版多角貿易修改 
# Modify.........: NO.FUN-640167 06/04/18 BY yiting 出貨或入庫扣帳拋單時，中間廠都會詢問"這是新的倉儲批，是否新增? -->不用問，直接產生 
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: NO.MOD-650049 06/06/22 By Mandy FUN-5A0176所產生的BUG," WHERE pmm01 = '",l_rva.rva02,"'"===>不能用此rva02採購單單號,應重抓l_rva.rva01此張收貨單,在l_dbs_new相對應之採購單
# Modify.........: No.MOD-660122 06/06/30 By Rayven 當ima25與img09的單位一樣時，imgg21及imgg211所存的轉換率，也應該要一樣
# Modify.........: NO.FUN-670007 06/08/15 BY yiting 1.拋轉時判斷如果poz18 = 'Y',則拋轉至poz19所設營運中心之收貨單為止，其餘之後段不拋,poz18設定等於第一站時，則全拋
#                                                   2.依各站(apmi000)設定之資料抓取
# Modify.........: No.FUN-680136 06/09/07 By Jackho 欄位類型修改
# Modify.........: No.FUN-690025 06/09/21 By jamie 改判斷狀況碼occ1004
# Modify.........: No.FUN-6B0044 06/11/13 By kim GP3.5 台虹保稅客製功能回收修改
# Modify.........: NO.TQC-690057 06/11/15 BY Claire img_file值要取自imd_file
# Modify.........: No.FUN-6B0065 06/11/21 By Ray atmi217并入aooi313(azf09,10,11,12,13取代tqe03,04,05,11,08)
# Modify.........: NO.FUN-670007 06/11/30 BY Yiting poz05己無作用
# Modify.........: NO.TQC-6A0084 06/10/30 BY Nicola 含稅金額、未稅金額調整
# Modify.........: NO.MOD-6C0086 06/12/14 BY Claire 語法調整
# Modify.........: No.FUN-710030 07/01/22 By johnray 錯誤訊息匯總顯示修改
# Modify.........: NO.MOD-720052 07/02/07 BY Claire rvb10t取位
# Modify.........: No.TQC-740094 07/04/16 By Carrier 錯誤匯總功能-修改
# Modify.........: NO.FUN-750127 07/06/05 BY Yiting 錯誤訊息彙總功能之前要先判斷有沒有status
# Modify.........: NO.TQC-760054 07/06/06 By xufeng azf_file的index是azf_01(azf01,azf02),但是在抓‘中文說明’內容時，WHERE條件卻只有 azf01 = g_xxx
# Modify.........: No.CHI-770019 07/07/25 By Carrier 多單位:參考單位時,交易單位不寫入tlff
# Modify.........: NO.CHI-760003 07/08/14 By wujie  判斷ima906時若sma115='N'不需要判斷
# Modify.........: NO.MOD-780191 07/08/29 BY yiting 拋轉時需檢核單別設定資料是否齊全
# Modify.........: No.MOD-780264 07/08/31 By Claire 未回寫呆滯日期 
# Modify.........: NO.TQC-790003 07/09/03 BY yiting insert into前給予預設值
# Modify.........: No.FUN-790031 07/09/13 By Nicole 正Primary Key後,程式判斷錯誤訊息-239時必須改變做法
# Modify.........: NO.MOD-790154 07/10/08 BY claire 回寫ima74最近出庫日及ima73最近入庫日
# Modify.........: No.FUN-7B0091 07/11/19 By Sarah oga65預設值抓oea65
# Modify.........: No.TQC-7B0083 07/11/21 By Carrier rvv88給預設值
# Modify.........: No.TQC-7C0023 07/12/05 By Davidzv 增加是否進入FOREACH的判斷
# Modify.........: NO.TQC-7C0046 07/12/06 BY heather 使入庫單號能開窗查詢
# Modify.........: NO.MOD-7C0056 07/12/07 BY claire 輸入日期(oga69)未帶值
# Modify.........: NO.TQC-7C0064 07/12/08 BY Beryl 判斷單別在拋轉資料庫是否存在，如果不存在，則報錯，批處理運行不成功．提示user單據別無效或不存在其資料庫中
# Modify.........: NO.TQC-810029 08/01/09 BY yiting 最供終應商時，最後一站抓不到對應收貨/入庫單別
# Modify.........: NO.TQC-810048 08/01/15 BY Claire (1)待採正拋時,產生的收貨單單頭及單身的採購單號應同於來源站來非只取一個收貨單身第一筆資料
#                                                   (2)合併收貨時產生的出貨單,單頭訂單應空白,單身訂單不可取到訂單後就不依單身再重取訂單                                   
# Modify.........: No.FUN-7B0018 08/02/26 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.MOD-810179 08/03/18 By claire (1)對img09要重計轉換率(ogb15_fac,rvv35_fac)
#                                                   (2)第1站的SO,出貨單產生倉庫別來源取自p_imd01
# Modify.........: No.MOD-830002 08/03/18 By claire 原單頭的來源廠商(poz04:已不使用)改於單身第0站的上游廠商(poy03)
# Modify.........: No.MOD-830166 08/03/21 By Carol 計算rvv39前先給rvv87變數值
# Modify.........: No.FUN-830132 08/03/28 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-850100 08/05/19 By Nicola 批/序號管理第二階段
# Modify.........: No.MOD-870123 08/07/11 By claire 有最終供應商時,要清除殘值收貨/入庫單號
# Modify.........: No.MOD-880091 08/08/12 By cliare 勾選入庫單拋轉時單價重新計算(pod03),最終站的出貨單單價未重推
# Modify.........: No.MOD-890001 08/09/01 By cliare 最終站供應商簡稱未依DB重新抓取
# Modify.........: No.MOD-890010 08/09/02 By cliare 單價取錯,因入庫單的單身順序與收貨單單身順序不同
# Modify.........: No.MOD-8B0252 08/11/21 By cliare 收貨/入庫單別要以本站+1取得
# Modify.........: No.MOD-8B0264 08/11/25 By sherry INSERT INTO ogb_file時加入ogb930字段
# Modify.........: No.MOD-910012 09/01/05 By chenl  調整SQL語句。
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-930104 09/03/23 By dxfwo   理由碼的分類改善
# Modify.........: No.TQC-930155 09/04/06 By Sunyanchun 把DDL語句提到BEGIN WORK前
# Modify.........: No.MOD-940015 09/04/24 By chenl  入庫單插入tlf19時，直接取rvu04的值。使tlf和入庫單一致。
# Modify.........: No.MOD-940294 09/04/30 By Dido 拋轉序號管理資料增加 rvbs13 = 0 
# Modify.........: No.TQC-950010 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring()   
# Modify.........: No.FUN-940083 09/05/17 By zhaijie調整批處理的賦值
# Modify.........: No.MOD-980058 09/08/10 By Dido tlf111 日期傳遞錯誤
# Modify.........: No.FUN-980006 09/08/14 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.MOD-980099 09/08/22 By 非樣品才可更新 pmn_file ;依各站計算驗退量 
# Modify.........: No.TQC-980125 09/08/24 By lilingyu p822_ogains()里的l_sql2定義為string類型
# Modify.........: No.FUN-980020 09/09/01 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-980059 09/09/09 By arman GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980092 09/09/16 By TSD.apple GP5.2 跨資料庫語法修改
# Modify.........: No.MOD-990192 09/09/22 By Dido l_ima35 給予預設值調整 
# Modify.........: No.CHI-950020 09/10/06 By chenmoyan 將自定義欄位的值拋轉各站
# Modify.........: No.CHI-9B0008 09/11/11 By Dido 增加拋轉 tlf930
# Modify.........: No:TQC-9B0013 09/11/27 By Dido 單別於建檔刪除後,應控卡不可產生拋轉
# Modify.........: No.TQC-A10060 10/01/11 By wuxj   修改INSERT INTO加入oriu及orig這2個欄位
# Modify.........: No:FUN-9C0071 10/01/14 By huangrh 精簡程式
# Modify.........: No:MOD-A20033 10/02/05 By Dido 調整採購單序號
# Modify.........: No:FUN-A10123 10/03/12 By bnlent 手工收貨時流通零售業相關字段賦值與管控 
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26* 
# Modify.........: No.TQC-A50091 10/05/20 By lilingyu 當業態(azw04)為非流通行業時,oga85會出現NULL值,導致insert oga_file 報錯
# Modify.........: No.FUN-A50102 10/07/21 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-AB0061 10/11/16 By chenying 銷退單加基礎單價字段ohb37	
# Modify.........: No.FUN-AB0061 10/11/16 By shenyang 出貨單加基礎單價字段ogb37
# Modify.........: No.FUN-AB0096 10/12/07 By vealxu 因新增ogb50，ohb71 not null欄位導致無法insert的問題修正
# Modify.........: No:MOD-A90100 10/12/10 By Smapmin 轉換率抓取問題
# Modify.........: No:MOD-AB0219 10/12/10 By Smapmin 更新庫存量時,數量帶錯
#                                                    修正MOD-A90100
# Modify.........: No.FUN-AC0055 10/12/21 By suncx 取消預設ohb71值，新增oha55欄位預設值
# Modify.........: No.FUN-AC0055 10/12/21 By wangxin oga57,ogb50欄位無預設值修正
# Modify.........: No.TQC-A60075 10/12/21 By houlia 拋轉時正確給日期欄位賦值
# Modify.........: No:MOD-B10179 11/01/24 By Summer 若多角有設最終供應商且取價幣別與前一站不同,應在重新進入p822_ogbins時重取幣別
# Modify.........: No:MOD-B30584 11/03/17 By chenying 產生收貨單是，rvb90應給原採購單位
# Modify.........: No.FUN-AB0023 11/03/17 By Lilan EF整合功能(EasyFlow)
# Modify.........: No:CHI-B40011 11/04/19 By Smapmin FUN-980092修改不完全
# Modify.........: No:TQC-B40073 11/04/25 By shiwuying 增加审核时间ohacont
# Modify.........: No:TQC-B60065 11/06/16 By shiwuying 增加虛擬類型rvu27
# Modify.........: No:MOD-B60264 11/07/04 By Summer tlf19抓取單據上的廠商
# Modify.........: No:FUN-B70074 11/07/20 By fengrui 添加行業別表的新增於刪除
# Modify.........: No:CHI-B70039 11/08/17 By johung 金額 = 計價數量 x 單價
# Modify.........: No.FUN-B90012 11/09/28 By fengrui  增加ICD行業功能
# Modify.........: No.FUN-BA0051 11/11/09 By jason 一批號多DATECODE功能
# Modify.........: No:FUN-BB0084 11/11/25 By lixh1 增加數量欄位小數取
# Modify.........: No:FUN-910088 11/12/21 By chenjing 增加數量欄位小數取
# Modify.........: No.FUN-BB0001 12/01/11 By pauline 新增rvv22,INSERT/UPDATE rvb22時,同時INSERT/UPDATE rvv22
# Modify.........: No:MOD-C30663 12/03/14 By ck2yuan tlfs07單位應寫img09
# Modify.........: No:MOD-C30877 12/04/10 By ck2yuan 更新ima73 ima74應一併更新ima29
# Modify.........: No:FUN-C50097 12/06/13 By SunLM  對非空字段進行判斷ogb50,51,52
# Modify.........: No.CHI-C80009 12/08/15 By Sakura 1.一批號多DATECODE功能時,FOREACH需多傳倉儲批2.出貨時,tlff需給相關預設值
# Modify.........: No.FUN-C50136 12/08/27 By xianghui 拋磚時如果做信用管控則需要做信用管控處理
# Modify.........: No.FUN-C80001 12/08/29 By bart 多角拋轉時，批號需一併拋轉sma96
# Modify.........: No:FUN-C90050 12/10/24 By Lori 預設單別/預設POS上傳單別改以s_get_defslip取得
# Modify.........: No:MOD-CB0055 12/11/12 By jt_chen FUN-980006增加plant、legal缺少導致,補上l_plant,l_legal
# Modify.........: No.FUN-CB0087 12/12/20 By xianghui 庫存理由碼改善
# Modify.........: No:CHI-BB0003 12/12/26 By Summer 多角貿易計價方式為逆推時，從最後一站再回寫各站的單價 
# Modify.........: No:MOD-CC0289 12/12/31 By SunLM 插入tlfcost时候,根据ccz28参数(成本计算方式)
# Modify.........: No:MOD-D10029 13/01/31 By Elise 品名抓來源站拋轉只限MISC料,拋轉收貨/入庫單調整為一致
# Modify.........: No.TQC-D20050 13/02/26 By xianghui 理由碼調整
# Modify.........: No.TQC-D20047 13/02/26 By xianghui 理由碼調整
# Modify.........: No.TQC-D20067 13/03/01 By xianghui 理由碼調整
# Modify.........: No:FUN-BC0062 13/03/08 By lixh1 當成本計算方式ccz28選擇'6'，過帳還原時控制不可過帳還原
# Modify.........: No:MOD-C40162 13/03/13 By Elise 當ogaconf='Y',oga55要為1
# Modify.........: No.FUN-CC0157 13/03/20 By zm tlf920赋值(配合发出商品修改)
# Modify.........: No.CHI-CC0033 13/03/27 By jt_chen 兩角修改
# Modify.........: No:FUN-D30099 13/03/29 By Elise 將asms230的sma96搬到apms010,欄位改為pod08
# Modify.........: No:FUN-D20062 13/04/02 By jt_chen 季會決議：
#                                                    1.有效期限一併拋轉，已經存在的img有效期限就update
#                                                    2.不能BY流程，維持用參數決定
#                                                    3.用參數pod08決定是否update img18有效期限
# Modify.........: No.TQC-D40064 13/06/19 By fengrui 理由碼調整

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_rva   RECORD LIKE rva_file.*
DEFINE g_rvb   RECORD LIKE rvb_file.*
DEFINE g_rvu   RECORD LIKE rvu_file.*
DEFINE g_rvv   RECORD LIKE rvv_file.*
DEFINE g_oea   RECORD LIKE oea_file.*
DEFINE g_oeb   RECORD LIKE oeb_file.*
DEFINE g_oga   RECORD LIKE oga_file.*
DEFINE g_ogb   RECORD LIKE ogb_file.*
DEFINE g_ogd   RECORD LIKE ogd_file.*
DEFINE g_ofa   RECORD LIKE ofa_file.*
DEFINE g_ofb   RECORD LIKE ofb_file.*
DEFINE l_oea   RECORD LIKE oea_file.*
DEFINE l_oeb   RECORD LIKE oeb_file.*
DEFINE l_oga   RECORD LIKE oga_file.*
DEFINE l_ogb   RECORD LIKE ogb_file.*
DEFINE l_rva   RECORD LIKE rva_file.*
DEFINE l_rvb   RECORD LIKE rvb_file.*
DEFINE l_rvu   RECORD LIKE rvu_file.*
DEFINE l_rvv   RECORD LIKE rvv_file.*
DEFINE g_pmm   RECORD LIKE pmm_file.*
DEFINE g_pmn   RECORD LIKE pmn_file.*
DEFINE g_oan   RECORD LIKE oan_file.*
DEFINE tm RECORD
         wc  LIKE type_file.chr1000     #No.FUN-680136 VARCHAR(600) 
       END RECORD
DEFINE g_poz  RECORD LIKE poz_file.*    #流程代碼資料(單頭) No.8083
DEFINE g_poy  RECORD LIKE poy_file.*    #流程代碼資料(單身) No.8083
DEFINE s_poy  RECORD LIKE poy_file.*    #流程代碼資料(單身) No.8083  #FUN-670007
DEFINE p_pmm09  LIKE pmm_file.pmm09,    #廠商代號
       p_poy04  LIKE poc_file.poc03,    #工廠編號
       p_pox03  LIKE pox_file.pox03,    #計價基准
       p_pox05  LIKE pox_file.pox05,    #計價方式
       p_pox06  LIKE pox_file.pox06,    #計價比率
       p_imd01  LIKE imd_file.imd01,    #倉庫別
       s_imd01  LIKE imd_file.imd01,    #倉庫別
       g_imd10      LIKE imd_file.imd10,    #倉儲類別
       g_imd11      LIKE imd_file.imd11,    #是否為可用倉儲
       g_imd12      LIKE imd_file.imd12,    #MRP倉否
       g_imd13      LIKE imd_file.imd13,    #保稅否
       g_imd14      LIKE imd_file.imd14,    #生產發料順序
       g_imd15      LIKE imd_file.imd15,    #銷售出貨順序
       p_cnt    LIKE type_file.num5        #No.FUN-680136 SMALLINT    #計價方式符合筆數 
  DEFINE g_flow99        LIKE apa_file.apa99        #No.FUN-680136 VARCHAR(17)       #多角序號   #FUN-560043
  DEFINE t_dbs           LIKE type_file.chr21       #No.FUN-680136 VARCHAR(21)    #來源工廠
  DEFINE l_dbs_new       LIKE type_file.chr21       #No.FUN-680136 VARCHAR(21)    #New DataBase Name
  DEFINE l_dbs_tra       LIKE type_file.chr21       #FUN-980092 
  DEFINE s_dbs_new       LIKE type_file.chr21       #No.FUN-680136 VARCHAR(21)    #FUN-670007
  DEFINE s_dbs_source    LIKE type_file.chr21       #No.FUN-680136 VARCHAR(21)    #來源工廠
  DEFINE l_aza  RECORD LIKE aza_file.*
  DEFINE l_azp  RECORD LIKE azp_file.*
  DEFINE s_azp  RECORD LIKE azp_file.*       #FUN-670007
  DEFINE l_azi  RECORD LIKE azi_file.*
  DEFINE s_azi  RECORD LIKE azi_file.*
  DEFINE g_sw   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
  DEFINE g_argv1  LIKE oga_file.oga01
  DEFINE p_last LIKE type_file.num5          #No.FUN-680136 SMALLINT                #流程之最后家數
  DEFINE p_last_plant LIKE azp_file.azp01    #No.FUN-680136 VARCHAR(10)
  DEFINE p_first_plant  LIKE azp_file.azp01  #No.FUN-680136 VARCHAR(10)
  DEFINE g_pmm50  LIKE pmm_file.pmm50
  DEFINE g_t1     LIKE oay_file.oayslip                #No.FUN-550060  #No.FUN-680136 VARCHAR(05)
  DEFINE oga_t1   LIKE poy_file.poy38  #No.FUN-680136 VARCHAR(5)
  DEFINE rva_t1   LIKE poy_file.poy38  #No.FUN-680136 VARCHAR(5)
  DEFINE rvu_t1   LIKE poy_file.poy38  #No.FUN-680136 VARCHAR(5)
  DEFINE g_ima906   LIKE ima_file.ima906   #FUN-560043
 
DEFINE   g_cnt        LIKE type_file.num10   #No.FUN-680136 INTEGER
DEFINE   g_msg        LIKE ze_file.ze03      #No.FUN-680136 VARCHAR(72)
DEFINE   g_flag       LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
DEFINE   g_oay18      LIKE oay_file.oay18    #No.FUN-620025
DEFINE   g_oha01      LIKE oha_file.oha01    #No.FUN-620025
DEFINE   l_ohb        RECORD LIKE ohb_file.* #No.FUN-620025   
DEFINE   l_oha        RECORD LIKE oha_file.* #No.FUN-620025   
DEFINE   l_poy02      LIKE poy_file.poy02    #NO.FUN-670007
DEFINE   l_c          LIKE type_file.num5    #No.FUN-680137 SMALLINT  #NO.FUN-670007
DEFINE   l_ima29      LIKE ima_file.ima29    #MOD-790154 
DEFINE   g_fac        LIKE ogb_file.ogb15_fac, #MOD-810179 add
         g_unit       LIKE ogb_file.ogb15      #MOD-810179 add 
DEFINE g_ima918       LIKE ima_file.ima918     #No.FUN-850100
DEFINE g_ima921       LIKE ima_file.ima921     #No.FUN-850100
DEFINE l_rvbs         RECORD LIKE rvbs_file.*  #No.FUN-850100
DEFINE l_plant_new    LIKE type_file.chr10     #No.FUN-980020
DEFINE t_plant        LIKE type_file.chr10     #No.FUN-980020
 
MAIN
   OPTIONS                                #改變一些系統預設值
       INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   LET g_argv1 = ARG_VAL(1)

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 

   SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
   SELECT * INTO g_pod.* FROM pod_file WHERE pod00 = '0'
#  SELECT * INTO g_oaz.* FROM oaz_file WHERE oaz00 = '0'   #FUN-C50136
 
   IF cl_null(g_pod.pod01) THEN       #三角貿易使用匯率
      LET g_pod.pod01='T'
   END IF
 
   LET t_plant = g_plant                     #FUN-980020
   LET t_dbs = s_dbstring(g_dbs CLIPPED)     #TQC-950010 ADD  
 
   #若有傳參數則不用輸入畫面
   IF cl_null(g_argv1) THEN 
      CALL p822_p1()
   ELSE
      LET tm.wc = " rvu01='",g_argv1,"' " 
 
      OPEN WINDOW win WITH 6 ROWS,70 COLUMNS 
 
      CALL p822_p2()
 
      CALL s_showmsg()       #No.FUN-710030
 
      IF g_success = 'Y' THEN 
         CALL cl_cmmsg(1) COMMIT WORK
      ELSE 
         CALL cl_rbmsg(1) ROLLBACK WORK
      END IF
 
      DROP TABLE p822_file
 
      CLOSE WINDOW win
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION p822_p1()
   DEFINE l_ac  LIKE type_file.num5    #No.FUN-680136 SMALLINT
   DEFINE l_i   LIKE type_file.num5    #No.FUN-680136 SMALLINT
   DEFINE l_cnt LIKE type_file.num5    #No.FUN-680136 SMALLINT
 
   OPEN WINDOW p822_w WITH FORM "apm/42f/apmp822" 
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()
  
   WHILE TRUE
      ERROR ''
 
      CONSTRUCT BY NAME tm.wc ON rvu01,rvu03 
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
 
       ON ACTION controlp                                                       
          CASE                                                                  
             WHEN INFIELD(rvu01)                                                 
                CALL cl_init_qry_var()                                          
                LET g_qryparam.state = "c"
                LET g_qryparam.form = "q_rvu5"                                   
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO rvu01
                NEXT FIELD rvu01
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
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END CONSTRUCT
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('rvuuser', 'rvugrup') #FUN-980030
     
      IF g_action_choice = "locale" THEN  #genero
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE  
      END IF
  
      IF INT_FLAG THEN
         LET INT_FLAG = 0 
         EXIT WHILE  
      END IF
  
      IF NOT cl_sure(0,0) THEN CONTINUE WHILE  END IF
      CALL p822_p2()
  
      CALL s_showmsg()       #No.FUN-710030
      IF g_success = 'Y' THEN 
         COMMIT WORK
         CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
      ELSE
         ROLLBACK WORK
         CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
      END IF
 
      DROP TABLE p822_file
  
      IF g_flag THEN
         CONTINUE WHILE
      ELSE
         EXIT WHILE
      END IF
  
   END WHILE
   CLOSE WINDOW p822_w
END FUNCTION
 
FUNCTION p822_p2()
  DEFINE l_pmm  RECORD LIKE pmm_file.*
  DEFINE l_pmn  RECORD LIKE pmn_file.*
  DEFINE l_occ  RECORD LIKE occ_file.*
  DEFINE l_pmc  RECORD LIKE pmc_file.*
  DEFINE l_pob  RECORD LIKE pob_file.*
  DEFINE l_poc  RECORD LIKE poc_file.*
  DEFINE l_gec  RECORD LIKE gec_file.*
  DEFINE l_ima  RECORD LIKE ima_file.*
  DEFINE l_sql,l_sql1,l_sql2        STRING       #NO.FUN-910082
  DEFINE i,l_i      LIKE type_file.num5    #No.FUN-680136 SMALLINT
  DEFINE o_pox05    LIKE pox_file.pox05    #計價方式
  DEFINE diff_azi   LIKE type_file.chr1,   #No.FUN-680136 VARCHAR(1)     #若為Y表示單身計價方式有所不同
         l_cnt      LIKE type_file.num5,   #No.FUN-680136 SMALLINT
         azi_pox05  LIKE pox_file.pox05,   #記錄單頭該用之計價方式
         min_oeb15  LIKE oeb_file.oeb15    #記錄該訂單之最小預交日
  DEFINE l_j        LIKE type_file.num5,   #No.FUN-680136 SMALLINT
         l_msg      LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(60)
  DEFINE l_x        LIKE oay_file.oayslip  #No.FUN-680136 VARCHAR(5)     #No.FUN-550060
  DEFINE l_oea62 LIKE oea_file.oea62
  DEFINE s_oea62 LIKE oea_file.oea62
  DEFINE l_oeb24 LIKE oeb_file.oeb24 
  DEFINE l_occ02 LIKE occ_file.occ02,
         l_occ08 LIKE occ_file.occ08,
         l_occ11 LIKE occ_file.occ11,
         l_rvb29 LIKE rvb_file.rvb29,
         l_pmn50 LIKE pmn_file.pmn50
  DEFINE l_poy04 LIKE poy_file.poy04       #FUN-670007 
  DEFINE l_flag  LIKE type_file.chr1       #TQC-7C0023
  DEFINE k       LIKE type_file.num5       #MOD-8B0252
  #CHI-BB0003 add --start--
  DEFINE u_rvu       RECORD LIKE rvu_file.*  
  DEFINE u_rvv       RECORD LIKE rvv_file.* 
  DEFINE n_pmm       RECORD LIKE pmm_file.*
  DEFINE n_rvu       RECORD LIKE rvu_file.*  
  DEFINE n_rvv       RECORD LIKE rvv_file.* 
  DEFINE n_rva       RECORD LIKE rva_file.*  
  DEFINE n_rvb       RECORD LIKE rvb_file.*    
  DEFINE n_oga       RECORD LIKE oga_file.*  
  DEFINE n_ogb       RECORD LIKE ogb_file.*  
  DEFINE l_source    LIKE type_file.num5     
  DEFINE l_dbs_now   LIKE type_file.chr21    
  DEFINE l_dbs_up    LIKE type_file.chr21    
  DEFINE l_dbs_last  LIKE type_file.chr21    
  DEFINE l_oga50     LIKE oga_file.oga50
  DEFINE l_oga51     LIKE oga_file.oga51
  DEFINE l_oga52     LIKE oga_file.oga52
  DEFINE l_oga53     LIKE oga_file.oga53
  DEFINE l_oga1008   LIKE oga_file.oga1008
  DEFINE l_price     LIKE ogb_file.ogb13
  DEFINE l_currm     LIKE pmm_file.pmm42 
  DEFINE l_plant_now   LIKE azp_file.azp01
  DEFINE l_plant_last  LIKE type_file.chr10
  DEFINE l_plant_up    LIKE type_file.chr10
  #CHI-BB0003 add --end--
 
  CALL cl_wait() 
 
  CREATE TEMP TABLE p822_file(
       p_no     LIKE type_file.num5,  
       po_no    LIKE pmn_file.pmn01,
       po_item  LIKE type_file.num5,  
       po_price LIKE oeb_file.oeb13,
       po_curr  LIKE pmm_file.pmm22)
 
  BEGIN WORK           #NO.TQC-930155                                                                                               
  LET g_success='Y'    #NO.TQC-930155
 
  DELETE FROM p822_file
  CALL s_showmsg_init()        #No.FUN-710030  #No.TQC-740094
  #讀取符合條件之三角貿易采單資料
  LET l_sql="SELECT rva_file.*,rvu_file.* ",
            "  FROM rva_file,rvu_file ",
            " WHERE rvuconf = 'Y' ",   #必須為已確認入庫單
	    "   AND rvu00 = '1' ",     #入庫單
            "   AND rvu08 = 'TAP' ",   #代采買采購性質
            "   AND rvu02 = rva01 ",
            "   AND (rvu20 = 'N' OR rvu20 is null OR rvu20 = '') ", #未拋轉
            "   AND ",tm.wc CLIPPED
  PREPARE p822_p1 FROM l_sql 
  IF STATUS THEN 
      IF g_bgerr THEN
         CALL s_errmsg("","","pre1",SQLCA.sqlcode,1)
      ELSE
         CALL cl_err3("","","","",SQLCA.sqlcode,"","pre1",1)
      END IF
     LET g_success = 'N'
     RETURN 
  END IF
  DECLARE p822_curs1 CURSOR FOR p822_p1
  IF STATUS THEN 
      IF g_bgerr THEN
         CALL s_errmsg("","","declare",SQLCA.sqlcode,1)
      ELSE
         CALL cl_err3("","","","",SQLCA.sqlcode,"","declare",1)
      END IF
     LET g_success = 'N'
     RETURN 
  END IF
 
  LET l_flag = 'Y'     #TQC-7C0023
  FOREACH p822_curs1 INTO g_rva.*,g_rvu.*
     LET l_flag = 'N'    #TQC-7C0023
     IF SQLCA.SQLCODE THEN
        IF g_bgerr THEN
           CALL s_errmsg("","","foreach",SQLCA.sqlcode,1)
        ELSE
           CALL cl_err3("","","","",SQLCA.sqlcode,"","foreach",1)
        END IF
        LET g_success = 'N' 
        EXIT FOREACH
     END IF
     IF g_success="N" THEN
        LET g_totsuccess="N"
        LET g_success="Y"
     END IF
     IF cl_null(g_rva.rva02) THEN 
        #只讀取第一筆采購單之資料
        LET l_sql1= " SELECT pmm_file.* FROM pmm_file,rvb_file ",
                    "  WHERE pmm01 = rvb04 ",
                    "    AND rvb01 = '",g_rva.rva01,"'"
        PREPARE pmm_pre FROM l_sql1
        DECLARE pmm_f CURSOR FOR pmm_pre
        OPEN pmm_f
        FETCH pmm_f INTO g_pmm.*
     ELSE
        #讀取該入庫單之采購單
        SELECT * INTO g_pmm.*
          FROM pmm_file
         WHERE pmm01 = g_rva.rva02
     END IF
     IF SQLCA.SQLCODE THEN
        LET g_success= 'N'   #No.TQC-740094
        IF g_bgerr THEN
           CALL s_errmsg("","","sel pmm:",SQLCA.sqlcode,1)
           CONTINUE FOREACH
        ELSE
           CALL cl_err3("sel","pmm_file",g_rva.rva02,"",SQLCA.sqlcode,"","sel pmm:",1)
           EXIT FOREACH
        END IF
     END IF
     #no.6158檢查各工廠關帳日(sma53)
     IF s_mchksma53(g_pmm.pmm904,g_rvu.rvu03) THEN
        LET g_success='N' EXIT FOREACH
     END IF
     IF g_pmm.pmm906 != 'Y' THEN #非起始采購單
        LET g_success = 'N'
        IF g_bgerr THEN
           CALL s_errmsg("pmm906",g_pmm.pmm906,"sel pmm:","apm-991",1)  #No.TQC-740094
           CONTINUE FOREACH
        ELSE
           CALL cl_err3("","","","","apm-991","","sel pmm:",1)
           EXIT FOREACH
        END IF
     END IF   
     IF g_pmm.pmm905 != 'Y' THEN #采購單未拋轉 no.6114
        LET g_success = 'N'
        IF g_bgerr THEN
           CALL s_errmsg("pmm905",g_pmm.pmm905,"pmm905='N'","apm-992",1)  #No.TQC-740094
           CONTINUE FOREACH
        ELSE
           CALL cl_err3("","","","","apm-992","","pmm905='N'",1)
           EXIT FOREACH
        END IF
     END IF
     LET g_pmm50 = g_pmm.pmm50
     #讀取三角貿易流程代碼資料
     SELECT * INTO g_poz.* FROM poz_file
      WHERE poz01=g_pmm.pmm904 AND poz00='2'
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
     #來源廠商已改為單身第0站的下游廠商編號
      SELECT poy03 INTO g_poz.poz04 
       FROM poy_file
      WHERE poy01 = g_pmm.pmm904 
        AND poy02 = 0
     IF g_poz.pozacti = 'N' THEN 
        LET g_success = 'N'
        IF g_bgerr THEN
           CALL s_errmsg("pozacti",g_poz.pozacti,g_pmm.pmm904,"tri-009",1)  #No.TQC-740094
           CONTINUE FOREACH
        ELSE
           CALL cl_err3("","","","","tri-009","",g_pmm.pmm904,1)
           EXIT FOREACH
        END IF
     END IF
     IF g_poz.poz011='2' THEN
        LET g_success = 'N'
        IF g_bgerr THEN
           CALL s_errmsg("poz011","2","poz011=2:","apm-014",1)  #No.TQC-740094
           CONTINUE FOREACH
        ELSE
           CALL cl_err3("","","","","apm-014","","poz011=2:",1)
           RETURN
        END IF
     END IF
     CALL p822_flow99()                           #No.8106 取得多角序號
     CALL s_mtrade_last_plant(g_pmm.pmm904) 
          RETURNING p_last,p_last_plant
     IF cl_null(p_last) THEN LET g_success = 'N'
        EXIT FOREACH
     END IF
     SELECT poy04 INTO l_poy04
       FROM poy_file
      WHERE poy01 =g_poz.poz01
        AND poy02 = 0
     LET p_first_plant = l_poy04
 
     IF p_first_plant != g_plant THEN
        LET g_success= 'N'    #No.TQC-740094
        IF g_bgerr THEN
           CALL s_errmsg("poy04",p_first_plant,"","apm-012",1)  #No.TQC-740094
           CONTINUE FOREACH
        ELSE
           CALL cl_err3("","","","","apm-012","","",1)
           EXIT FOREACH
        END IF
     END IF
 
     LET s_oea62=0
     #依流程代碼最多6層
     FOR i = 1 TO p_last
           LET k = i + 1                  #MOD-8B0252
           #得到廠商/客戶代碼及database
           CALL p822_azp(i)
 
           #LET l_sql2 = "INSERT INTO ",l_dbs_tra CLIPPED,"rvbs_file",  #FUN-980092
           LET l_sql2 = "INSERT INTO ",cl_get_target_table(l_plant_new,'rvbs_file'), #FUN-A50102 
                        "(rvbs00,rvbs01,rvbs02,rvbs021,rvbs022,rvbs03,",
                        " rvbs04,rvbs05,rvbs06,rvbs07,rvbs08,rvbs09,rvbs13,rvbsplant,rvbslegal) ",   #MOD-940294 #FUN-980006 add rvbsplant,rvbslegal
                        " VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?, ? ,?,?) "                #MOD-940294 add ? #FUN-980006 add ?,?
 
 	       CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
           CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
           PREPARE ins_rvbs FROM l_sql2
 
               LET g_t1 = s_get_doc_no(g_rvu.rvu01)        #No.FUN-550060
               CALL s_mutislip('1','2',g_t1,g_poz.poz01,i)                     
                   RETURNING g_sw,oga_t1,l_x,l_x,l_x,l_x        #MOD-8B0252
               IF g_sw THEN 
                   LET g_success = 'N' EXIT FOREACH 
               END IF 
               #No.FUN-A10123 ...begin
               IF g_azw.azw04 ='2' THEN
                  IF cl_null(oga_t1) THEN
                     #CALL p822_def_no(l_dbs_tra,'axm','50') RETURNING oga_t1
                     CALL p822_def_no(l_plant_new,'axm','50') RETURNING oga_t1  #FUN-A50102
                  END IF
               END IF
               #No.FUN-A10123 ...end
               IF k <= p_last THEN
                 CALL s_mutislip('1','1',g_t1,g_poz.poz01,k)                      
                     RETURNING g_sw,l_x,rva_t1,rvu_t1,l_x,l_x 
                 IF g_sw THEN 
                     LET g_success = 'N'
                     EXIT FOREACH 
                 END IF 
                 #No.FUN-A10123 ...begin
                 IF g_azw.azw04 ='2' THEN
                    IF cl_null(rva_t1) THEN
                       #CALL p822_def_no(l_dbs_tra,'apm','3') RETURNING rva_t1
                       CALL p822_def_no(l_plant_new,'apm','3') RETURNING rva_t1   #FUN-A50102
                    END IF
                    IF cl_null(rvu_t1) THEN
                       #CALL p822_def_no(l_dbs_tra,'apm','7') RETURNING rvu_t1
                       CALL p822_def_no(l_plant_new,'apm','7') RETURNING rvu_t1   #FUN-A50102
                    END IF
                 END IF
                 #No.FUN-A10123 ...end
               END IF
               IF (i = p_last AND NOT cl_null(g_pmm50)) THEN
                   LET rva_t1=''  #MOD-870123 add
                   LET rvu_t1=''  #MOD-870123 add
                   SELECT poy37,poy38 INTO rva_t1,rvu_t1
                     FROM poy_file
                    WHERE poy01 = g_poz.poz01
                      AND poy02 = 99
                   IF STATUS THEN
                      LET g_msg = l_dbs_new CLIPPED
                      IF g_bgerr THEN
                         CALL s_errmsg("","","g_msg",'apm1016',1)
                      ELSE
                         CALL cl_err3("","","","",'apm1016',"","g_msg",1)
                      END IF
                      LET g_success = 'N' EXIT FOREACH 
                   END IF  
                   #No.FUN-A10123 ...begin
                   IF g_azw.azw04 ='2' THEN
                      IF cl_null(rva_t1) THEN
                         #CALL p822_def_no(l_dbs_tra,'apm','3') RETURNING rva_t1
                         CALL p822_def_no(l_plant_new,'apm','3') RETURNING rva_t1  #FUN-A50102
                      END IF
                      IF cl_null(rvu_t1) THEN
                         #CALL p822_def_no(l_dbs_tra,'apm','7') RETURNING rvu_t1
                         CALL p822_def_no(l_plant_new,'apm','7') RETURNING rvu_t1  #FUN-A50102
                      END IF
                   END IF
                   #No.FUN-A10123 ...end
               END IF                                      #no.TQC-810029
               IF cl_null(oga_t1) THEN
                   LET g_msg = l_dbs_new CLIPPED,oga_t1 CLIPPED
                   IF g_bgerr THEN
                      CALL s_errmsg("","","g_msg",'axm4012',1)
                   ELSE
                      CALL cl_err3("","","","",'axm4012',"","g_msg",1)
                   END IF
                   LET g_success = 'N'
                   EXIT FOREACH
               ELSE                                                                                                                   
                  LET l_cnt = 0                                                                                                       
                  #LET l_sql = "SELECT COUNT(*) FROM ",l_dbs_new,"oay_file ", 
                  LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new,'oay_file'), #FUN-A50102                  
                              " WHERE oayslip = '",oga_t1,"'"    
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                  CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
                  PREPARE oay_pre1 FROM l_sql                                                                                         
                  EXECUTE oay_pre1 INTO l_cnt                                                                                         
                  IF l_cnt = 0 THEN                                                                                                   
                     LET g_msg = l_dbs_new CLIPPED,oga_t1 CLIPPED                                                                     
                     IF g_bgerr THEN
                        CALL s_errmsg("","","g_msg",'axm-931',1)
                     ELSE
                        CALL cl_err3("","","","",'axm-931',"","g_msg",1)                                                                 
                     END IF
                     LET g_success = 'N'                                                                                              
                     EXIT FOREACH                                                                                                     
                  END IF                                                                                                              
               END IF 
              IF (i <> p_last AND cl_null(g_pmm50)) THEN  #MOD-8B0252 add
               IF cl_null(rva_t1) THEN
                   LET g_msg = l_dbs_new CLIPPED,rva_t1 CLIPPED
                   IF g_bgerr THEN
                      CALL s_errmsg("","","g_msg",'axm4013',1)
                   ELSE
                      CALL cl_err3("","","","",'axm4013',"","g_msg",1)
                   END IF
                   LET g_success = 'N'
                   EXIT FOREACH
               ELSE                                                                                                                   
                  LET l_cnt = 0                                                                                                       
                  #LET l_sql = "SELECT COUNT(*) FROM ",l_dbs_new,"smy_file ", 
                  LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new,'smy_file'), #FUN-A50102                                  
                              " WHERE smyslip = '",rva_t1,"'"  
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                  CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
                  PREPARE smy_pre1 FROM l_sql                                                                                         
                  EXECUTE smy_pre1 INTO l_cnt                                                                                         
                  IF l_cnt = 0 THEN                                                                                                   
                     LET g_msg = l_dbs_new CLIPPED,rva_t1 CLIPPED                                                                     
                     IF g_bgerr THEN
                        CALL s_errmsg("","","g_msg",'axm-931',1)
                     ELSE
                        CALL cl_err3("","","","",'axm-931',"","g_msg",1)                                                                 
                     END IF
                     LET g_success = 'N'                                                                                              
                     EXIT FOREACH                                                                                                     
                  END IF                                                                                                              
               END IF 
               IF cl_null(rvu_t1) THEN
                   LET g_msg = l_dbs_new CLIPPED,rvu_t1 CLIPPED
                   IF g_bgerr THEN
                      CALL s_errmsg("","","g_msg",'axm4016',1)
                   ELSE
                      CALL cl_err3("","","","",'axm4016',"","g_msg",1)
                   END IF
                   LET g_success = 'N'
                   EXIT FOREACH
               ELSE
                  LET l_cnt = 0                                                                                                       
                  #LET l_sql = "SELECT COUNT(*) FROM ",l_dbs_new,"smy_file ", 
                  LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new,'smy_file'), #FUN-A50102                                     
                              " WHERE smyslip = '",rvu_t1,"'"  
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                  CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
                  PREPARE smy_pre2 FROM l_sql                                                                                         
                  EXECUTE smy_pre2 INTO l_cnt                                                                                         
                  IF l_cnt = 0 THEN                                                                                                   
                     LET g_msg = l_dbs_new CLIPPED,rvu_t1 CLIPPED                                                                     
                     IF g_bgerr THEN
                        CALL s_errmsg("","","g_msg",'axm-931',1)
                     ELSE
                        CALL cl_err3("","","","",'axm-931',"","g_msg",1)                                                                 
                     END IF
                     LET g_success = 'N'                                                                                              
                     EXIT FOREACH                                                                                                     
                  END IF                                                                                                              
               END IF 
              END IF #MOD-8B0252 add
           CALL p822_chk99()                       #No.8106
           CALL p822_azi(g_oea.oea23)   #讀取幣別資料
           #讀取該料號之計價方式(依流程代碼+生效日期+廠商)
           IF g_aza.aza50!='Y' THEN              #No.FUN-620025 
              #CHI-CC0033 -- add start --
              IF g_poz.poz12 ='Y' THEN
                 LET p_pox03 = '1'
                 LET p_pox05 = 'O'
                 LET p_pox06 = ''
                 LET p_cnt = 1
              ELSE
              #CHI-CC0033 -- add end -- 
                 CALL s_pox(g_pmm.pmm904,i,g_rvu.rvu03)
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
           END IF                                #No.FUN-620025   
           LET l_sql1 = "SELECT oea01 ", 
                        #" FROM ",l_dbs_tra CLIPPED,"oea_file ",  #FUN-980092 
                        " FROM ",cl_get_target_table(l_plant_new,'oea_file'), #FUN-A50102                  
                        " WHERE oea99='",g_pmm.pmm99,"'"
           CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
           CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-980092
           PREPARE oea_p2 FROM l_sql1
           IF SQLCA.SQLCODE THEN 
              IF g_bgerr THEN
                 CALL s_errmsg("oea99",g_pmm.pmm99,"",SQLCA.sqlcode,1)  #No.TQC-740094
              ELSE
                 CALL cl_err3("","","","",SQLCA.sqlcode,"","",1)
              END IF
           END IF
           DECLARE oea_c2 CURSOR FOR oea_p2
           OPEN oea_c2	
           FETCH oea_c2 INTO g_oea.oea01
           IF SQLCA.SQLCODE <> 0 THEN   
              LET g_success='N'
              IF g_bgerr THEN
                 CALL s_errmsg("","","fetch cursor oea_c2:",SQLCA.sqlcode,1)
                 CONTINUE FOREACH
              ELSE
                 CALL cl_err3("","","","",SQLCA.sqlcode,"","fetch cursor oea_c2:",1)
                 RETURN
              END IF
           END IF
           CLOSE oea_c2
 
           CALL p822_p3(i)
     END FOR  {一個訂單流程代碼結束}

     #CHI-BB0003 add --start--
      #多角貿易計價方式為逆推時，從最後一站再回寫各站的單價
      IF NOT cl_null(g_pmm.pmm50) THEN    #要有最終供應商才需執行
         LET l_sql1 = "SELECT rvv_file.* ",
                      " FROM ",cl_get_target_table(g_from_plant,'rvu_file'),",", 
                               cl_get_target_table(g_from_plant,'rvv_file'),
                      " WHERE rvu01 = rvv01 ",
                      "   AND rvu99 = '",g_flow99,"'"
         
         CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1 
         CALL cl_parse_qry_sql(l_sql1,g_from_plant) RETURNING l_sql1 
         PREPARE rvv_gper FROM l_sql1
         DECLARE rvv_gcus CURSOR FOR rvv_gper
         
         FOR l_i = p_last TO 1 STEP -1
            
            LET l_oga50 = 0
            LET l_oga51 = 0
            LET l_oga52 = 0
            LET l_oga53 = 0
            LET l_oga1008 = 0
         
            FOREACH rvv_gcus INTO g_rvv.* 
               IF SQLCA.SQLCODE <> 0 THEN
                  EXIT FOREACH 
               END IF 
         
               CALL s_pox(g_pmm.pmm904,l_i,g_rvu.rvu03)
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
                  LET l_plant_now = g_plant
               ELSE
                  SELECT poy04 INTO l_poy04 FROM poy_file 
                   WHERE poy01 = g_poz.poz01
                     AND poy02 = l_source
                  SELECT azp03 INTO l_dbs_now FROM azp_file 
                   WHERE azp01 = l_poy04
                   LET l_plant_now = l_poy04
               END IF
               LET l_dbs_now = s_dbstring(l_dbs_now) 

               ##-------------取得當站資料庫(S/O)-----------------
               SELECT poy04 INTO l_poy04 FROM poy_file 
                WHERE poy01 = g_poz.poz01
                  AND poy02 = l_i
               SELECT azp03 INTO l_dbs_up FROM azp_file 
                WHERE azp01 = l_poy04
               LET l_plant_up = l_poy04
               LET l_dbs_up = s_dbstring(l_dbs_up)
               LET p_poy04 = l_poy04

               ##-------------取得終站資料庫(S/O)-----------------
               SELECT poy04 INTO l_poy04 FROM poy_file 
                WHERE poy01 = g_poz.poz01
                  AND poy02 = p_last
               SELECT azp03 INTO l_dbs_last FROM azp_file 
                WHERE azp01 = l_poy04
               LET l_plant_last = l_poy04
               LET l_dbs_last = s_dbstring(l_dbs_last) 

               IF p_pox03 = "1" OR p_pox03 = "2" THEN    #取價方式不為逆推，不需執行
                  CONTINUE FOR
               END IF
               #p_pox06要取對站的計算方式
               CALL s_pox(g_pmm.pmm904,l_i-1,g_rvu.rvu03)
                RETURNING p_pox03,p_pox05,p_pox06,p_cnt

               IF p_pox03 = "3" THEN   #判斷是依最終廠商取價還是下游廠商取價
                  LET l_sql1 = "SELECT rvu_file.*,rvv_file.* ",
                                "  FROM ",cl_get_target_table(l_plant_last,'rvu_file'),",",
                                         cl_get_target_table(l_plant_last,'rvv_file'),
                               " WHERE rvu01 = rvv01 ",
                               "   AND rvu99 = '",g_flow99,"'",
                               "   AND rvv02 = ",g_rvv.rvv02
               ELSE
                  LET l_sql1 = "SELECT rvu_file.*,rvv_file.* ",
                               "  FROM ",cl_get_target_table(l_plant_up,'rvu_file'),",", 
                                         cl_get_target_table(l_plant_up,'rvv_file'),
                               " WHERE rvu01 = rvv01 ",
                               "   AND rvu99 = '",g_flow99,"'",
                               "   AND rvv02 = ",g_rvv.rvv02
               END IF
         
               CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1
               CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1
               PREPARE rvv_uper FROM l_sql1
               DECLARE rvv_ucus CURSOR FOR rvv_uper
         
               OPEN rvv_ucus
               FETCH rvv_ucus INTO u_rvu.*,u_rvv.*
               CLOSE rvv_ucus
         
               LET l_sql1 = "SELECT rvu_file.*,rvv_file.* ",
                             "  FROM ",cl_get_target_table(l_plant_now,'rvu_file'),",", 
                                      cl_get_target_table(l_plant_now,'rvv_file'),
                            " WHERE rvu01 = rvv01 ",
                            "   AND rvu99 = '",g_flow99,"'",
                            "   AND rvv02 = ",g_rvv.rvv02
               
               CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1
               CALL cl_parse_qry_sql(l_sql1,l_plant_now) RETURNING l_sql1
               PREPARE rvv_nper FROM l_sql1
               DECLARE rvv_ncus CURSOR FOR rvv_nper
         
               OPEN rvv_ncus
               FETCH rvv_ncus INTO n_rvu.*,n_rvv.*
               CLOSE rvv_ncus
               
               LET l_sql1 = "SELECT * ",
                            "  FROM ",cl_get_target_table(l_plant_now,'pmm_file'), 
                            " WHERE pmm99='",g_pmm.pmm99,"' " 
               CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1
               CALL cl_parse_qry_sql(l_sql1,l_plant_now) RETURNING l_sql1
               PREPARE pmm_nper FROM l_sql1
               DECLARE pmm_ncus CURSOR FOR pmm_nper
               OPEN pmm_ncus
               FETCH pmm_ncus INTO n_pmm.*

              #計價方式來判斷
              CASE p_pox05
                 WHEN '1'
                       #單價*比率
                       #(換算匯率)
                       IF g_pmm.pmm22 = n_pmm.pmm22 THEN
                          LET n_rvv.rvv38 = u_rvv.rvv38 * p_pox06 /100
                       END IF
                       IF g_pmm.pmm22 <> n_pmm.pmm22 THEN  
                          LET l_price = u_rvv.rvv38 * g_pmm.pmm42 #先換算本幣
                          #依計價幣別抓來源工廠的匯率
                          IF p_pox03 = "3" THEN
                             CALL s_currm(n_pmm.pmm22,u_rvu.rvu03,g_pod.pod01,l_plant_last)
                                RETURNING l_currm
                          ELSE
                             CALL s_currm(n_pmm.pmm22,u_rvu.rvu03,g_pod.pod01,l_plant_up)
                                RETURNING l_currm
                          END IF
                          LET n_rvv.rvv38= l_price/l_currm * p_pox06/100
                       END IF
                       
                       LET l_sql1 = "SELECT * ",
                                    " FROM ",cl_get_target_table(l_plant_now,'azi_file'),
                                    " WHERE azi01='",n_pmm.pmm22,"' "
                       CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1
                       CALL cl_parse_qry_sql(l_sql1,l_plant_now) RETURNING l_sql1
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
                       CALL cl_digcut(n_rvv.rvv38,l_azi.azi03) RETURNING n_rvv.rvv38                       
                 WHEN '2'
                    #讀取合乎料件條件之價格
                    CALL s_pow(g_pmm.pmm904,n_rvb.rvb05,p_poy04,u_rvu.rvu03)
                           RETURNING g_sw,n_rvv.rvv38
                     IF g_sw='N' THEN
                        IF g_pod.pod02 = 'N' AND i <> p_last THEN
                           IF g_bgerr THEN
                              CALL s_errmsg("","","sel poc:","axm-333",1)
                           ELSE
                              CALL cl_err3("","","","","axm-333","","sel poc:",1)
                           END IF
                           LET g_success = 'N'
                        END IF
                        LET n_rvv.rvv38 =0 
                     END IF
                 WHEN '3'   #單價若為0, 則給0, 否則抓料件之固定價格
                     IF u_rvv.rvv38 <> 0 THEN
                        CALL s_pow(g_pmm.pmm904,n_rvb.rvb05,p_poy04,u_rvu.rvu03)
                           RETURNING g_sw,n_rvv.rvv38
                        IF g_sw='N' THEN
                           IF g_pod.pod02 = 'N' AND i <> p_last THEN
                              IF g_bgerr THEN
                                 CALL s_errmsg("","","sel poc:","axm-333",1)
                              ELSE
                                 CALL cl_err3("","","","","axm-333","","sel poc:",1)
                              END IF
                              LET g_success = 'N'
                           END IF
                           LET n_rvv.rvv38 =0
                        END IF
                     ELSE
                        LET n_rvv.rvv38 =0
                     END IF
              END CASE
              IF n_rvv.rvv38 IS NULL THEN LET n_rvv.rvv38 =0 END IF
              
              IF n_pmm.pmm43>0 THEN
                 LET n_rvv.rvv38t=n_rvv.rvv38*(1+n_pmm.pmm43/100)
              ELSE
                 IF n_pmm.pmm43=0 THEN
                    LET n_rvv.rvv38t=n_rvv.rvv38
                 END IF
              END IF
              CALL cl_digcut(n_rvv.rvv38t,l_azi.azi03) RETURNING n_rvv.rvv38t
              
              LET n_rvv.rvv39=n_rvv.rvv87*n_rvv.rvv38
              LET n_rvv.rvv39t=n_rvv.rvv87*n_rvv.rvv38t
               
              CALL cl_digcut(n_rvv.rvv39,l_azi.azi04) RETURNING n_rvv.rvv39
              CALL cl_digcut(n_rvv.rvv39t,l_azi.azi04) RETURNING n_rvv.rvv39t
               
              #回寫當站入庫單身
              LET l_sql2 = "UPDATE ",cl_get_target_table(l_plant_now,'rvv_file'),
                           "   SET rvv38 = ?,rvv38t = ? ,",
                           "       rvv39 = ?,rvv39t = ? ",
                           " WHERE rvv01=? AND rvv02=? "
              CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
              CALL cl_parse_qry_sql(l_sql2,l_plant_now) RETURNING l_sql2
              PREPARE upd_nrvv FROM l_sql2
              EXECUTE upd_nrvv USING n_rvv.rvv38,n_rvv.rvv38t,
                                     n_rvv.rvv39,n_rvv.rvv39t,
                                     n_rvv.rvv01,n_rvv.rvv02
              IF SQLCA.sqlcode THEN
                 IF g_bgerr THEN
                    CALL s_errmsg("","","upd nrvv:",SQLCA.sqlcode,1)
                 ELSE
                    CALL cl_err3("","","","",SQLCA.sqlcode,"","upd nrvv:",1)
                 END IF
                 LET g_success = 'N'
              END IF               
              
              LET n_rvb.rvb10=n_rvv.rvv38
              LET n_rvb.rvb10t=n_rvv.rvv38t
              LET n_rvb.rvb87=n_rvv.rvv87
              LET n_rvb.rvb88 =n_rvb.rvb87 * n_rvb.rvb10
              LET n_rvb.rvb88t=n_rvb.rvb87 * n_rvb.rvb10t
              CALL cl_digcut(n_rvb.rvb88,l_azi.azi04) RETURNING n_rvb.rvb88
              CALL cl_digcut(n_rvb.rvb88t,l_azi.azi04) RETURNING n_rvb.rvb88t
                            
               #回寫當站收貨單身
               LET l_sql2 = "UPDATE ",cl_get_target_table(l_plant_now,'rvb_file'),
                            "   SET rvb10 = ?,rvb10t = ? ,",
                            "       rvb88 = ?,rvb88t = ? ",
                            " WHERE rvb01=? AND rvb02=? "
               CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
               CALL cl_parse_qry_sql(l_sql2,l_plant_now) RETURNING l_sql2
               PREPARE upd_nrvb FROM l_sql2
               EXECUTE upd_nrvb USING n_rvb.rvb10,n_rvb.rvb10t,
                                      n_rvb.rvb88,n_rvb.rvb88t,
                                      n_rvb.rvb01,n_rvb.rvb02
               IF SQLCA.sqlcode THEN
                  IF g_bgerr THEN
                     CALL s_errmsg("","","upd nrvb:",SQLCA.sqlcode,1)
                  ELSE
                     CALL cl_err3("","","","",SQLCA.sqlcode,"","upd nrvb:",1)
                  END IF
                  LET g_success = 'N'
               END IF
               
               LET l_sql1 = "SELECT oga_file.*,ogb_file.* ",
                            "  FROM ",cl_get_target_table(l_plant_new,'oga_file'),",", 
                                      cl_get_target_table(l_plant_new,'ogb_file'),
                            " WHERE oga01 = ogb01 ",
                            "   AND oga99 = '",g_flow99,"'",
                            "   AND ogb03 = ",g_pmn.pmn02
               
               CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1
               CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1
               PREPARE ogb_nper FROM l_sql1
               DECLARE ogb_ncus CURSOR FOR ogb_nper
               
               OPEN ogb_ncus
               FETCH ogb_ncus INTO n_oga.*,n_ogb.*
               CLOSE ogb_ncus
               
               LET n_ogb.ogb13 = n_rvb.rvb10
               CALL cl_digcut(n_ogb.ogb13,l_azi.azi03) RETURNING n_ogb.ogb13
               
               IF n_oga.oga213 = 'N' THEN              #表示不含稅
                  LET n_ogb.ogb14 = n_ogb.ogb917* n_ogb.ogb13
                  LET n_ogb.ogb14t= n_ogb.ogb14*(1+n_oga.oga211/100)
               ELSE
                  LET n_ogb.ogb14t= n_ogb.ogb917*n_ogb.ogb13
                  LET n_ogb.ogb14 = n_ogb.ogb14t/(1+n_oga.oga211/100)
               END IF
              
               CALL cl_digcut(n_ogb.ogb14,l_azi.azi04) RETURNING n_ogb.ogb14
               CALL cl_digcut(n_ogb.ogb14t,l_azi.azi04) RETURNING n_ogb.ogb14t
              
               #回寫下游出貨單身
               LET l_sql2 = "UPDATE ",cl_get_target_table(l_plant_new,'ogb_file'),
                            "   SET ogb13 = ?, ogb14 = ?, ogb14t=? ",
                            " WHERE ogb01=? AND ogb03=? "
               CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
               CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1
               PREPARE upd_nogb FROM l_sql2
               EXECUTE upd_nogb USING n_ogb.ogb13,n_ogb.ogb14,n_ogb.ogb14t,
                                      n_ogb.ogb01,n_ogb.ogb03
               IF SQLCA.sqlcode THEN
                  IF g_bgerr THEN
                     CALL s_errmsg("","","upd nogb:",SQLCA.sqlcode,1)
                  ELSE
                     CALL cl_err3("","","","",SQLCA.sqlcode,"","upd nogb:",1)
                  END IF
                  LET g_success = 'N'
               END IF

               #出貨單頭總金額
               LET l_oga50 =l_oga50 + n_ogb.ogb14   #原幣出貨金額(未稅)
               CALL cl_digcut(l_oga50,l_azi.azi04) RETURNING l_oga50
               LET l_oga51 =l_oga51 + n_ogb.ogb14t  #原幣出貨金額(含稅)
               CALL cl_digcut(l_oga50,l_azi.azi04) RETURNING l_oga50
               
               LET l_oga52 = n_oga.oga50 * n_oga.oga161/100
               LET l_oga53 = n_oga.oga50 * (n_oga.oga162+n_oga.oga163)/100
               CALL cl_digcut(l_oga52,t_azi04) RETURNING l_oga52
               CALL cl_digcut(l_oga53,t_azi04) RETURNING l_oga53
               
               IF l_aza.aza50 = 'Y' THEN
                  LET l_oga1008 = l_oga1008 + n_ogb.ogb14t
                  CALL cl_digcut(l_oga1008,l_azi.azi04) RETURNING l_oga1008
               END IF
         
            END FOREACH 

            #回寫下游出貨單頭
            LET l_sql2 = "UPDATE ",cl_get_target_table(l_plant_new,'oga_file'),
                         "   SET oga50 = ?, oga51=?,",
                         "       oga52 = ?, oga53=?,",
                         "       oga1008 = ? ",
                         " WHERE oga01=? "
            DISPLAY l_sql2
            CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
            CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1
            PREPARE upd_noga FROM l_sql2
            EXECUTE upd_noga USING l_oga50,l_oga51,l_oga52,l_oga53,l_oga1008,n_oga.oga01
            IF SQLCA.sqlcode THEN
               IF g_bgerr THEN
                  CALL s_errmsg("","","upd noga:",SQLCA.sqlcode,1)
               ELSE
                  CALL cl_err3("","","","",SQLCA.sqlcode,"","upd noga:",1)
               END IF
               LET g_success = 'N'
            END IF
         
         END FOR
      END IF
     #CHI-BB0003 add --end--
 
     MESSAGE ""
 
     #更新起始入庫單之之拋轉否='Y'
     UPDATE rvu_file SET rvu20 = 'Y' 
       WHERE rvu01 = g_rvu.rvu01
     IF SQLCA.SQLCODE <> 0 OR sqlca.sqlerrd[3]=0 THEN
        LET g_success = 'N'
        IF g_bgerr THEN
           CALL s_errmsg("rvu01",g_rvu.rvu01,"upd rvu20",SQLCA.sqlcode,1)
           CONTINUE FOREACH
        ELSE
           CALL cl_err3("upd","rvu_file",g_rvu.rvu01,"",STATUS,"","upd rvu20",1)
           EXIT FOREACH
        END IF
     END IF
 
  END FOREACH     
   IF l_flag = 'Y' THEN 
       CALL cl_err('','mfg9089',1)
       LET g_success='N'
   END IF
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF
 
END FUNCTION
 
FUNCTION p822_p3(i)      #把原本的拋轉段切出來到p822_p3()
  DEFINE l_pmm  RECORD LIKE pmm_file.*
  DEFINE l_pmn  RECORD LIKE pmn_file.*
  DEFINE l_occ  RECORD LIKE occ_file.*
  DEFINE l_pmc  RECORD LIKE pmc_file.*
  DEFINE l_pob  RECORD LIKE pob_file.*
  DEFINE l_poc  RECORD LIKE poc_file.*
  DEFINE l_gec  RECORD LIKE gec_file.*
  DEFINE l_ima  RECORD LIKE ima_file.*
  DEFINE l_sql      LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(1200)
  DEFINE l_sql1     LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(600)
  DEFINE l_sql2     LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(1600)
  DEFINE i,l_i      LIKE type_file.num5    #No.FUN-680136 SMALLINT
  DEFINE o_pox05    LIKE pox_file.pox05    #計價方式
  DEFINE diff_azi   LIKE type_file.chr1,   #No.FUN-680136 VARCHAR(1)     #若為Y表示單身計價方式有所不同
         l_cnt      LIKE type_file.num5,   #No.FUN-680136 SMALLINT
         azi_pox05  LIKE pox_file.pox05,   #記錄單頭該用之計價方式
         min_oeb15  LIKE oeb_file.oeb15    #記錄該訂單之最小預交日
  DEFINE l_j        LIKE type_file.num5,   #No.FUN-680136 SMALLINT
         l_msg      LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(60)
  DEFINE l_x        LIKE oay_file.oayslip  #No.FUN-680136 VARCHAR(5)     #No.FUN-550060
  DEFINE l_oea62 LIKE oea_file.oea62
  DEFINE s_oea62 LIKE oea_file.oea62
  DEFINE l_oeb24 LIKE oeb_file.oeb24 
  DEFINE l_occ02 LIKE occ_file.occ02,
         l_occ08 LIKE occ_file.occ08,
         l_occ11 LIKE occ_file.occ11,
         l_rvb29 LIKE rvb_file.rvb29,
         l_pmn50 LIKE pmn_file.pmn50
 
   #新增出貨單單頭檔(oga_file)                                       #2.如果設定的中斷營運中心和首站相同，則全拋
   CALL p822_ogains()                                                 
   IF i <> p_last OR ( i = p_last AND NOT cl_null(g_pmm50)) THEN
      #新增收貨單單頭檔(rva_file)
      CALL p822_rvains()
          #新增入庫單單頭檔(rvu_file)
          CALL p822_rvuins()
   END IF
   IF g_success='N' THEN RETURN END IF     #FUN-670007

   LET l_oea62=0
   #讀取入庫單身檔(rvv_file)
   DECLARE rvv_cus CURSOR FOR
   SELECT * FROM rvv_file
    WHERE rvv01 = g_rvu.rvu01
   FOREACH rvv_cus INTO g_rvv.* 
      IF SQLCA.SQLCODE <>0 THEN EXIT FOREACH END IF 

      DECLARE p822_g_rvbs CURSOR FOR SELECT * FROM rvbs_file
                                      WHERE rvbs01 = g_rvu.rvu01
                                        AND rvbs02 = g_rvv.rvv02
       #FUN-B90012----add----str----                                 
       IF s_industry('icd') THEN
          DECLARE p822_idd CURSOR FOR SELECT * FROM idd_file 
                                           WHERE idd10 = g_rvu.rvu01
                                             AND idd11 = g_rvv.rvv02
       END IF 
       #FUN-B90012----add----str----
 
      SELECT ima906 INTO g_ima906 FROM ima_file 
       WHERE ima01 = g_rvv.rvv31
      #重新取得單身的流程序號
      SELECT pmm99 INTO g_pmm.pmm99 FROM pmm_file
       WHERE pmm01 = g_rvv.rvv36
      #---- 新增出貨單單身檔(ogb_file)----
      CALL p822_azi(l_oga.oga23)   #讀取幣別資料 #MOD-B10179 add
      CALL p822_ogbins(i)
      CALL p822_log(l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,
                    l_ogb.ogb092,l_ogb.ogb12,'1') 
      IF i <> p_last OR ( i = p_last AND NOT cl_null(g_pmm50)) THEN
         #---- 新增收貨單單身檔(rvb_file)----
         CALL p822_rvbins(i)
         CALL p822_log(l_rvb.rvb05,l_rvb.rvb36,l_rvb.rvb37,
                       l_rvb.rvb38,l_rvb.rvb07,'2')
         #---- 新增入庫單身檔(rvv_file)----
         CALL p822_rvvins(i)
         CALL p822_log(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,
                       l_rvv.rvv34,l_rvv.rvv17,'3')
         IF g_success='N' THEN EXIT FOREACH END IF
      END IF               #FUN-670007
 
      IF i <> p_last OR ( i = p_last AND NOT cl_null(g_pmm50)) THEN
         #因為目前沒有驗退單拋轉的動作，所以必須將
         #       pmn55(驗退量)重新計算 
         #LET l_sql2="SELECT SUM(rvb29) FROM ",l_dbs_tra CLIPPED, #FUN-980092
         #           "rvb_file,",l_dbs_tra CLIPPED,"rva_file",
         LET l_sql2="SELECT SUM(rvb29) FROM ",cl_get_target_table(l_plant_new,'rvb_file'),",", #FUN-A50102
                                              cl_get_target_table(l_plant_new,'rva_file'),     #FUN-A50102
                    " WHERE rvb04 = '",l_rvv.rvv36,"'",
                    "   AND rvb03 = ",l_rvv.rvv37,  #No.FUN-A10123 發現一個未成對的引號
                    "   AND rvaconf = 'Y' AND rvb01 = rva01 AND rvb35 ='N'"
	     CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2	
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
         PREPARE rvb29_pre FROM l_sql2
         DECLARE rvb29_cs CURSOR FOR rvb29_pre
         OPEN rvb29_cs
         FETCH rvb29_cs INTO l_rvb29
         IF cl_null(l_rvb29) THEN LET l_rvb29 = 0 END IF
         #LET l_sql2= "SELECT SUM(rvb07) FROM ",l_dbs_tra CLIPPED,
         #             " rva_file,",l_dbs_tra CLIPPED,"rvb_file", #FUN-980092 add
         LET l_sql2= "SELECT SUM(rvb07) FROM ",cl_get_target_table(l_plant_new,'rva_file'),",", #FUN-A50102
                                               cl_get_target_table(l_plant_new,'rvb_file'),     #FUN-A50102
                      " WHERE rvb04 ='",l_rvv.rvv36,"'",  #TQC-810048 modify
                      "   AND rvb03 =",g_rvv.rvv37,
                      "   AND rvb35 = 'N' AND rvaconf='Y'",
                      "   AND rva01 = rvb01 "
 	     CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
         PREPARE pmn50_pre FROM l_sql2
         DECLARE pmn50_cs CURSOR FOR pmn50_pre
         OPEN pmn50_cs 
         FETCH pmn50_cs INTO l_pmn50
         IF cl_null(l_pmn50) THEN LET l_pmn50 = 0 END IF
         #LET l_sql2="UPDATE ",l_dbs_tra CLIPPED,"pmn_file", #FUN-980092
         LET l_sql2="UPDATE ",cl_get_target_table(l_plant_new,'pmn_file'), #FUN-A50102
                    " SET pmn50 = ? ,",
                    "     pmn53 = pmn53 + ?, ",
                    "     pmn55 = ? ",
                    " WHERE pmn01 = ? AND pmn02 = ? "
         CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
         PREPARE upd_pmn FROM l_sql2
         IF g_rvv.rvv25 ='N' THEN				#MOD-980099
            EXECUTE upd_pmn USING l_pmn50,g_rvv.rvv17,l_rvb29,
                                  l_rvv.rvv36,g_rvv.rvv37  #TQC-810048 modify 
            IF SQLCA.sqlcode<>0 THEN
               LET g_success = 'N'
               IF g_bgerr THEN
                  LET g_showmsg=l_rva.rva02,"/",g_rvv.rvv37   #No.TQC-740094
                  CALL s_errmsg("pmn01,pmn02",g_showmsg,"upd pmn:",SQLCA.sqlcode,1)  #No.TQC-740094
                  CONTINUE FOREACH
               ELSE
                  CALL cl_err3("","","","",SQLCA.sqlcode,"","upd pmn:",1)
                  EXIT FOREACH
               END IF
            END IF
         END IF						#MOD-980099
      END IF
  
      IF g_aza.aza50='Y' THEN            #使用分銷功能
         IF l_oga.oga00 = '6' THEN       #代送出貨單
            CALL p822_log(l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,
                          l_ogb.ogb092,l_ogb.ogb12,'4')   
            IF i = p_last THEN       
               CALL s_mupimg(+1,l_ogb.ogb04, l_ogb.ogb09,l_ogb.ogb091,
                             l_ogb.ogb092,l_ogb.ogb12*l_ogb.ogb15_fac,
                             g_oga.oga02,l_plant_new,-1,l_ogb.ogb01,l_ogb.ogb03)  #No.FUN-850100  #FUN-980006 add l_dbs_new->poy04
               IF g_sma.sma115 = 'Y' THEN  #No.CHI-760003 
                  IF g_ima906 = '2' THEN         
                     CALL s_mupimgg(+1,l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,
                                    l_ogb.ogb092,l_ogb.ogb910,l_ogb.ogb912,   
                                    g_oga.oga02,l_plant_new)  #FUN-980092      
                     CALL s_mupimgg(+1,l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,
                                    l_ogb.ogb092,l_ogb.ogb913,l_ogb.ogb915, 
                                    g_oga.oga02,l_plant_new)  #FUN-980092      
                  END IF      
                  IF g_ima906 = '3' THEN         
                     CALL s_mupimgg(+1,l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,
                                    l_ogb.ogb092,l_ogb.ogb913,l_ogb.ogb915, 
                                    g_oga.oga02,l_plant_new)  #FUN-980092      
                  END IF      
               END IF #No.CHI-760003 
               #CALL s_mudima(l_ogb.ogb04,l_dbs_new)   #CHI-B40011
               CALL s_mudima(l_ogb.ogb04,l_plant_new)   #CHI-B40011
            END IF
         END IF
      END IF 
      #更新最終資料庫img及ima(幫出貨單做扣帳的動作)
      IF i = p_last AND cl_null(g_pmm50) THEN
         CALL s_mupimg(-1,l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,
                       #l_ogb.ogb092,g_rvv.rvv17*g_rvv.rvv35_fac,   #MOD-AB0219
                       l_ogb.ogb092,l_ogb.ogb12*l_ogb.ogb15_fac,   #MOD-AB0219
                       g_rvu.rvu03,l_plant_new,-1,l_ogb.ogb01,l_ogb.ogb03)  #No.FUN-850100 #FUN-980006 add l_dbs_new->poy04
         IF g_sma.sma115 = 'Y' THEN  #No.CHI-760003 
            IF g_ima906 = '2' THEN
               CALL s_mupimgg(-1,l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,
                              #l_ogb.ogb092,g_rvv.rvv80,g_rvv.rvv82,   #MOD-AB0219
                              l_ogb.ogb092,l_ogb.ogb910,l_ogb.ogb912,   #MOD-AB0219
                              g_rvu.rvu03, l_plant_new)  #FUN-980092
               CALL s_mupimgg(-1,l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,
                              #l_ogb.ogb092,g_rvv.rvv83,g_rvv.rvv85,   #MOD-AB0219
                              l_ogb.ogb092,l_ogb.ogb913,l_ogb.ogb915,   #MOD-AB0219
                              g_rvu.rvu03, l_plant_new)   #FUN-980092
            END IF
            IF g_ima906 = '3' THEN
               CALL s_mupimgg(-1,l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,
                              #l_ogb.ogb092,g_rvv.rvv83,g_rvv.rvv85,   #MOD-AB0219
                              l_ogb.ogb092,l_ogb.ogb913,l_ogb.ogb915,   #MOD-AB0219
                              g_rvu.rvu03, l_plant_new)  #FUN-980092
            END IF
         END IF #No.CHI-760003 
         #CALL s_mudima(l_ogb.ogb04,l_dbs_new)   #CHI-B40011
         CALL s_mudima(l_ogb.ogb04,l_plant_new)   #CHI-B40011
	     IF g_success='N' THEN EXIT FOREACH END IF
      END IF 
 
      #更新銷單之已出貨量
      LET l_oeb24 = l_oeb.oeb24 + g_rvv.rvv17 
      IF l_oeb24 IS NULL THEN LET l_oeb24=0 END IF
      #LET l_sql2="UPDATE ",l_dbs_tra CLIPPED,"oeb_file", #FUN-980092
      LET l_sql2="UPDATE ",cl_get_target_table(l_plant_new,'oeb_file'), #FUN-A50102
                 "   SET oeb24= ? ",
                 " WHERE oeb01 = ? AND oeb03 = ? "
 	  CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
      CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
      PREPARE upd_oeb2 FROM l_sql2
      EXECUTE upd_oeb2 USING 
              l_oeb24, g_oea.oea01,g_rvv.rvv37
      IF SQLCA.sqlcode<>0 THEN
         LET g_success = 'N'
         IF g_bgerr THEN
            LET g_showmsg=g_oea.oea01,"/",g_rvv.rvv37   #No.TQC-740094
            CALL s_errmsg("oeb01,oeb03",g_showmsg,"upd oeb24:",SQLCA.sqlcode,1)  #No.TQC-740094
            CONTINUE FOREACH
         ELSE
            CALL cl_err3("","","","",SQLCA.sqlcode,"","upd oeb24:",1)
            EXIT FOREACH
         END IF
      END IF
#     LET l_oea62 = l_oea62 + g_rvv.rvv17 * g_rvv.rvv38   #CHI-B70039 mark
      LET l_oea62 = l_oea62 + g_rvv.rvv87 * g_rvv.rvv38   #CHI-B70039
   END FOREACH {rvv_cus}
   #更新銷單已出貨未稅金額
   #LET l_sql2="UPDATE ",l_dbs_tra CLIPPED,"oea_file", #FUN-980092
   LET l_sql2="UPDATE ",cl_get_target_table(l_plant_new,'oea_file'), #FUN-A50102
              " SET oea62 = oea62 + ? ",
              " WHERE oea01 = ?  "
   CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
   CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
   PREPARE upd_oea2 FROM l_sql2
   EXECUTE upd_oea2 USING l_oea62,g_oea.oea01
   IF SQLCA.sqlcode<>0 THEN
      IF g_bgerr THEN
         CALL s_errmsg("oea01",g_rvv.rvv36,"upd oea62:",SQLCA.sqlcode,1)  #No.TQC-740094
      ELSE
         CALL cl_err3("","","","",SQLCA.sqlcode,"","upd oea62:",1)
      END IF
      LET g_success = 'N'
   END IF
END FUNCTION
 
FUNCTION p822_azp(l_i)
  DEFINE l_i     LIKE type_file.num5,   #No.FUN-680136 SMALLINT
         l_next  LIKE type_file.num5,   #No.FUN-680136 SMALLINT
         l_source LIKE type_file.num5,   #FUN-670007
         l_sql1  LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(800)
 
     ##-------------取得當站資料庫(rva/rvb/rvv/rvu)-----------------
     SELECT * INTO g_poy.* FROM poy_file
      WHERE poy01 = g_poz.poz01 AND poy02 = l_i      
     SELECT * INTO l_azp.* FROM azp_file WHERE azp01 = g_poy.poy04
     LET l_plant_new = l_azp.azp01            #FUN-980020 
     LET l_dbs_new = s_dbstring(l_azp.azp03)  #TQC-950010 ADD      
 
     LET g_plant_new = l_azp.azp01
     CALL s_gettrandbs()      
     LET l_dbs_tra = g_dbs_tra
 
     LET l_sql1 = "SELECT * ",                         #取得來源本幣
                  #" FROM ",l_dbs_new CLIPPED,"aza_file ",
                  " FROM ",cl_get_target_table(l_plant_new,'aza_file'), #FUN-A50102
                  " WHERE aza01 = '0' "
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-A50102
     PREPARE aza_p1 FROM l_sql1
     IF SQLCA.sqlcode THEN    #NO.FUN-750127 add
         IF g_bgerr THEN
             CALL s_errmsg("aza01","0","aza_p1",SQLCA.sqlcode,1)  #No.TQC-740094
         ELSE
             CALL cl_err3("","","","",SQLCA.sqlcode,"","aza_p1",1)
         END IF
     END IF                   #no.FUN-750127 add
     DECLARE aza_c1  CURSOR FOR aza_p1
     OPEN aza_c1
     FETCH aza_c1 INTO l_aza.*
     CLOSE aza_c1
     LET p_poy04  = g_poy.poy04
     LET p_imd01  = g_poy.poy11
     LET p_pmm09  = g_poy.poy03   #FUN-670007
     IF cl_null(p_pmm09) THEN
        IF l_i = p_last AND NOT cl_null(g_pmm.pmm50) THEN
           LET p_pmm09 = g_pmm.pmm50
        ELSE
           LET p_pmm09 = ''            #廠商代號
        END IF
     END IF
 
     ##-------------取得下一站資料(oga/ogb)----------------------
     LET l_next = l_i + 1
 
     SELECT * INTO s_poy.* FROM poy_file            
      WHERE poy01 = g_poz.poz01 AND poy02 = l_next
     SELECT * INTO s_azp.* FROM azp_file WHERE azp01 = s_poy.poy04
     LET s_dbs_new = s_dbstring(s_azp.azp03)  #TQC-950010 ADD   
     LET s_imd01 = s_poy.poy11
 
END FUNCTION
 
#讀取幣別檔之資料
FUNCTION p822_azi(l_oga23)
  DEFINE l_sql1 LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(800)
  DEFINE l_oga23  LIKE oga_file.oga23
   #讀取 l_dbs_new 之本幣資料
   LET l_sql1 = "SELECT * ",
                #" FROM ",l_dbs_new CLIPPED,"azi_file ",
                " FROM ",cl_get_target_table(l_plant_new,'azi_file'), #FUN-A50102
                " WHERE azi01='",l_aza.aza17,"' "
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-A50102
   PREPARE azi_p1 FROM l_sql1
    IF STATUS THEN
       IF g_bgerr THEN
          CALL s_errmsg("azi01",l_aza.aza17,"azi_p1",STATUS,1)  #No.TQC-740094
       ELSE
          CALL cl_err3("","","","",STATUS,"","azi_p1",1)
       END IF
    END IF
   DECLARE azi_c1 CURSOR FOR azi_p1
   OPEN azi_c1
   FETCH azi_c1 INTO s_azi.* 
   CLOSE azi_c1
   #讀取l_dbs_new 之原幣資料
   LET l_sql1 = "SELECT * ",
                #" FROM ",l_dbs_new CLIPPED,"azi_file ",
                " FROM ",cl_get_target_table(l_plant_new,'azi_file'), #FUN-A50102
                " WHERE azi01='",l_oga23,"' " 
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-A50102
   PREPARE azi_p2 FROM l_sql1
   IF STATUS THEN
      IF g_bgerr THEN
         CALL s_errmsg("azi01",l_oga23,"azi_p2",STATUS,1)  #No.TQC-740094
      ELSE
         CALL cl_err3("","","","",STATUS,"","azi_p2",1)
      END IF
   END IF
   DECLARE azi_c2 CURSOR FOR azi_p2
   OPEN azi_c2
   FETCH azi_c2 INTO l_azi.* 
   CLOSE azi_c2
END FUNCTION
 
FUNCTION p822_ogains()
  DEFINE l_sql   LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(1200)
  DEFINE l_sql1  LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(600)
  DEFINE l_sql2  STRING                                              #TQC-980125
  DEFINE i,l_i   LIKE type_file.num5    #No.FUN-680136 SMALLINT
  DEFINE li_result   LIKE type_file.num5     #FUN-560043  #No.FUN-680136 SMALLINT
  DEFINE l_plant  LIKE azp_file.azp01    #FUN-980006 add
  DEFINE l_legal  LIKE oga_file.ogalegal #FUN-980006 add
  #讀取該流程代碼之銷單資料
 
  LET l_plant = g_poy.poy04  #FUN-980006 add 
  CALL s_getlegal(l_plant) RETURNING l_legal  #FUN-980006 add
 
   LET l_sql1 = "SELECT * ",
                #" FROM ",l_dbs_tra CLIPPED,"oea_file ",  #FUN-980092
                " FROM ",cl_get_target_table(l_plant_new,'oea_file'), #FUN-A50102
                " WHERE oea99='",g_pmm.pmm99,"' " 
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
         CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-980092
   PREPARE oea_p1 FROM l_sql1
   IF STATUS THEN
      IF g_bgerr THEN
         CALL s_errmsg("oea99",g_pmm.pmm99,"oea_p1",STATUS,1)  #No.TQC-740094
      ELSE
         CALL cl_err3("","","","",STATUS,"","oea_p1",1)
      END IF
   END IF
   DECLARE oea_c1 CURSOR FOR oea_p1
   OPEN oea_c1
   FETCH oea_c1 INTO l_oea.*
   IF SQLCA.SQLCODE <> 0 THEN
      IF g_bgerr THEN
         CALL s_errmsg("oea01",g_pmm.pmm01,l_dbs_new,"asf-500",1)  #No.TQC-740094
      ELSE
         CALL cl_err3("","","","","asf-500","",l_dbs_new,1)
      END IF
      LET g_success='N'
      RETURN
   END IF
   CLOSE oea_c1
  #新增出貨單單頭檔(oga_file)
    LET l_oga.oga00 = '1'
        CALL s_auto_assign_no('axm',oga_t1,g_rvu.rvu03,"","","",l_plant_new,"","") #FUN-980092
          RETURNING li_result,l_oga.oga01
        IF (NOT li_result) THEN 
           LET g_msg = l_plant_new CLIPPED,l_oga.oga01
           CALL s_errmsg("oga01",l_oga.oga01,g_msg CLIPPED,"mfg3046",1) 
           LET g_success ='N'
           RETURN
        END IF   
    LET l_oga.oga011= null               #出貨通知單號
    LET l_oga.oga02 = g_rvu.rvu03        #出貨日期
    LET l_oga.oga021= g_rvu.rvu03        #結關日期
    LET l_oga.oga022= g_rvu.rvu03        #裝船日期
    LET l_oga.oga03 = l_oea.oea03
    LET g_poz.poz04 = l_oga.oga03 #MOD-B60264 add
    LET l_oga.oga032= l_oea.oea032
    LET l_oga.oga033= l_oea.oea033
    LET l_oga.oga04 = l_oea.oea04
    LET l_oga.oga044= l_oea.oea044
    LET l_oga.oga05 = l_oea.oea05
    LET l_oga.oga06 = l_oea.oea06
    LET l_oga.oga07 = l_oea.oea07
    LET l_oga.oga08 = l_oea.oea08
    LET l_oga.oga09 = '6'
    LET l_oga.oga10 = null
    LET l_oga.oga11 = null
    LET l_oga.oga12 = null
    LET l_oga.oga13 = null
    LET l_oga.oga14 = l_oea.oea14
    LET l_oga.oga15 = l_oea.oea15
    IF cl_null(g_rva.rva02) THEN 
       LET l_oga.oga16 = g_rva.rva02
    ELSE 
       LET l_oga.oga16 = l_oea.oea01
    END IF  
    LET l_oga.oga161= l_oea.oea161
    LET l_oga.oga162= l_oea.oea162
    LET l_oga.oga163= l_oea.oea163
    LET l_oga.oga18 = l_oea.oea17
    LET l_oga.oga19 = null
    LET l_oga.oga20 = 'Y'
    LET l_oga.oga21 = l_oea.oea21
    LET l_oga.oga211= l_oea.oea211
    LET l_oga.oga212= l_oea.oea212
    LET l_oga.oga213= l_oea.oea213
    LET l_oga.oga23 = l_oea.oea23
    LET l_oga.ogaud01 = l_oea.oeaud01
    LET l_oga.ogaud02 = l_oea.oeaud02
    LET l_oga.ogaud03 = l_oea.oeaud03
    LET l_oga.ogaud04 = l_oea.oeaud04
    LET l_oga.ogaud05 = l_oea.oeaud05
    LET l_oga.ogaud06 = l_oea.oeaud06
    LET l_oga.ogaud07 = l_oea.oeaud07
    LET l_oga.ogaud08 = l_oea.oeaud08
    LET l_oga.ogaud09 = l_oea.oeaud09
    LET l_oga.ogaud10 = l_oea.oeaud10
    LET l_oga.ogaud11 = l_oea.oeaud11
    LET l_oga.ogaud12 = l_oea.oeaud12
    LET l_oga.ogaud13 = l_oea.oeaud13
    LET l_oga.ogaud14 = l_oea.oeaud14
    LET l_oga.ogaud15 = l_oea.oeaud15
    CALL p822_azi(l_oga.oga23)   #讀取幣別資料
       #出貨時重新抓取匯率
       CALL s_currm(l_oga.oga23,l_oga.oga02,g_pod.pod01,l_plant_new)   #FUN-980020 
           RETURNING l_oga.oga24
    #若出貨單頭之幣別=本幣幣別, 則匯率給1, (COI美金立帳, 99.03.05)
    IF l_oga.oga23 = l_aza.aza17 THEN
       LET l_oga.oga24=1
    END IF
    IF cl_null(l_oga.oga24) THEN LET l_oga.oga24=l_oea.oea24 END IF
    LET l_oga.oga25 = l_oea.oea25
    LET l_oga.oga26 = l_oea.oea26
    LET l_oga.oga27 = g_oga.oga27
    LET l_oga.oga28 = l_oea.oea18
    LET l_oga.oga29 = 0
    LET l_oga.oga30 = 'N'
    LET l_oga.oga31 = l_oea.oea31
    LET l_oga.oga32 = l_oea.oea32
    LET l_oga.oga33 = l_oea.oea33
    LET l_oga.oga34 = 0
    LET l_oga.oga35 = g_oga.oga35
    LET l_oga.oga36 = g_oga.oga36
    LET l_oga.oga37 = g_oga.oga37
    LET l_oga.oga38 = g_oga.oga38
    LET l_oga.oga39 = g_oga.oga39
    LET l_oga.oga40 = l_oea.oea19
    LET l_oga.oga41 = l_oea.oea41
    LET l_oga.oga42 = l_oea.oea42
    LET l_oga.oga43 = l_oea.oea43
    LET l_oga.oga44 = l_oea.oea44
    LET l_oga.oga45 = l_oea.oea45
    LET l_oga.oga46 = l_oea.oea46
    LET l_oga.oga47 = g_oga.oga47
    LET l_oga.oga48 = g_oga.oga48
    LET l_oga.oga49 = g_oga.oga49
    LET l_oga.oga50 = 0
    LET l_oga.oga51 = 0             #CHI-CC0033 add 
    LET l_oga.oga52 = 0
    LET l_oga.oga53 = 0
    LET l_oga.oga54 = 0
    LET l_oga.oga65 = l_oea.oea65   #FUN-7B0091 add
    LET l_oga.oga69 = g_rvu.rvu03   #MOD-7C0056 add
    LET l_oga.oga99 = g_flow99      #No.8106
    LET l_oga.oga901='N'
    LET l_oga.oga905='Y'
    LET l_oga.oga906='N'
    LET l_oga.oga909='Y'
    LET l_oga.ogaconf='Y'
    LET l_oga.oga55='1' #MOD-C40162 add
    LET l_oga.ogapost='Y'
    LET l_oga.ogaprsw=0
    LET l_oga.ogauser=g_user
    LET l_oga.ogagrup=g_grup
    LET l_oga.ogaoriu=g_user   #TQC-A10060  add
    LET l_oga.ogaorig=g_grup   #TQC-A10060  add
    LET l_oga.ogamodu=null
    LET l_oga.ogadate=null
    IF g_aza.aza50='Y' THEN       
       LET l_oga.oga1001 = l_oea.oea1001
       LET l_oga.oga1002 = l_oea.oea1002
       LET l_oga.oga1003 = l_oea.oea1003
       LET l_oga.oga1004 = l_oea.oea1004
       LET l_oga.oga1005 = l_oea.oea1005
       LET l_oga.oga1006 = 0
       LET l_oga.oga1007 = 0
       LET l_oga.oga1008 = 0
       LET l_oga.oga1009 = l_oea.oea1009
       LET l_oga.oga1010 = l_oea.oea1010
       LET l_oga.oga1011 = l_oea.oea1011
       LET l_oga.oga1012 = ''
       LET l_oga.oga1013 = 'N'
       LET l_oga.oga1014 = 'N'
       LET l_oga.oga1015 = '0'
       IF l_oea.oea00='6' THEN
          LET l_oga.oga00='6'
       END IF       
    END IF            
    #No.FUN-A10123 ...begin
    IF g_azw.azw04 = '2' THEN
       LET l_oga.oga83 = l_oea.oea83
       LET l_oga.oga84 = l_oea.oea84
       LET l_oga.oga85 = l_oea.oea85
       LET l_oga.oga86 = l_oea.oea86
       LET l_oga.oga87 = l_oea.oea87
       LET l_oga.oga88 = l_oea.oea88
       LET l_oga.oga89 = l_oea.oea89
       LET l_oga.oga90 = l_oea.oea90
       LET l_oga.oga91 = l_oea.oea91
       LET l_oga.oga92 = l_oea.oea92
       LET l_oga.oga93 = l_oea.oea93
    #  LET l_oga.ogaconu = g_user      #TQC-A60075
    #  LET l_oga.ogacond = g_today     #TQC-A60075
    END IF
    LET l_oga.ogaconu = g_user      #TQC-A60075
    LET l_oga.ogacond = g_today     #TQC-A60075
    LET l_oga.oga94 = 'N'
    #No.FUN-A10123 ...end

#TQC-A50091 --begin--
   IF cl_null(l_oga.oga85) THEN
     LET l_oga.oga85 = '1'
   END IF 
#TQC-A50091 --end--

#FUN-AC0055 add ---------------------begin-----------------------
IF cl_null(l_oga.oga57) THEN
   LET l_oga.oga57= '1' 
END IF
#FUN-AC0055 add ----------------------end------------------------

    #新增出貨單頭檔(oga_file)
    #LET l_sql2="INSERT INTO ",l_dbs_tra CLIPPED,"oga_file",  #FUN-980092
    LET l_sql2="INSERT INTO ",cl_get_target_table(l_plant_new,'oga_file'), #FUN-A50102
               "( oga00,oga01,oga011,oga02, ",
               "  oga021,oga022,oga03,oga032,",
               "  oga033,oga04,oga044,oga05,",
               "  oga06,oga07,oga08,oga09,",
               "  oga10,oga11,oga12,oga13,",
               "  oga14,oga15,oga16,oga161,",
               "  oga162,oga163,oga17,oga18,",
               "  oga19,oga20,oga21,oga211,",
               "  oga212,oga213,oga23,oga24,",
               "  oga25,oga26,oga27,oga28,",
               "  oga29,oga30,oga31,oga32,",
               "  oga33,oga34,oga35,",
               "  oga36,oga37,oga38,oga39,",
               "  oga40,oga41,oga42,oga43,",
               "  oga44,oga45,oga46,oga47,",
               "  oga48,oga49,oga50,oga52,",
               "  oga53,oga54,oga65,oga99,",   #FUN-7B0091 add oga65
               "  oga69,",                     #MOD-7C0056 add
               "  oga83,oga84,oga85,oga86, ",  #No.FUN-A10123
               "  oga87,oga88,oga89,oga90, ",  #No.FUN-A10123
               "  oga91,oga92,oga93,oga94, ",  #No.FUN-A10123
               "  ogaconu,ogacond, ",          #No.FUN-A10123
               "  oga901,oga902,",
               "  oga903,oga904,oga905,oga906,",
               "  oga907,oga908,oga909,ogaconf,oga55,",   #MOD-C40162 add oga55
               "  oga1001,oga1002,oga1003,oga1004,oga1005,",
               "  oga1006,oga1007,oga1008,oga1009,oga1010,",
               "  oga1011,oga1012,oga1013,oga1014,oga1015,",
               "  ogapost,ogaprsw,ogauser,ogagrup,",
               "  ogamodu,ogadate,ogaplant,ogalegal,ogaoriu,ogaorig, ", #TQC-A10060 add ogaoriu,ogaorig
               "  ogaud01,ogaud02,ogaud03,ogaud04,ogaud05,",
               "  ogaud06,ogaud07,ogaud08,ogaud09,ogaud10,",
               "  ogaud11,ogaud12,ogaud13,ogaud14,ogaud15,oga57)",  #TQC-AC0055 add oga57
               " VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                        "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                        "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                        "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                        "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                        "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,",       #No.FUN-A10123
                        "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,?,",    #No.CHI-950020 #TQC-A10060 add ?,?
                        "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,",    #No.FUN-620025   
                        "?,?,?,?, ?,?,? ) "   #FUN-7B0091 add ?   #MOD-7C0065 add ? #FUN-980006 add ?,? #MOD-C40162 add ?
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
           PREPARE ins_oga FROM l_sql2
           EXECUTE ins_oga USING 
                        l_oga.oga00,l_oga.oga01,l_oga.oga011,l_oga.oga02, 
                        l_oga.oga021,l_oga.oga022,l_oga.oga03,l_oga.oga032,
                        l_oga.oga033,l_oga.oga04,l_oga.oga044,l_oga.oga05,
                        l_oga.oga06,l_oga.oga07,l_oga.oga08,l_oga.oga09,
                        l_oga.oga10,l_oga.oga11,l_oga.oga12,l_oga.oga13,
                        l_oga.oga14,l_oga.oga15,l_oga.oga16,l_oga.oga161,
                        l_oga.oga162,l_oga.oga163,l_oga.oga17,l_oga.oga18,
                        l_oga.oga19,l_oga.oga20,l_oga.oga21,l_oga.oga211,
                        l_oga.oga212,l_oga.oga213,l_oga.oga23,l_oga.oga24,
                        l_oga.oga25,l_oga.oga26,l_oga.oga27,l_oga.oga28,
                        l_oga.oga29,l_oga.oga30,l_oga.oga31,l_oga.oga32,
                        l_oga.oga33,l_oga.oga34,l_oga.oga35,
                        l_oga.oga36,l_oga.oga37,l_oga.oga38,l_oga.oga39,
                        l_oga.oga40,l_oga.oga41,l_oga.oga42,l_oga.oga43,
                        l_oga.oga44,l_oga.oga45,l_oga.oga46,l_oga.oga47,
                        l_oga.oga48,l_oga.oga49,l_oga.oga50,l_oga.oga52,
                        l_oga.oga53,l_oga.oga54,l_oga.oga65,l_oga.oga99,   #FUN-7B0091 add oga65
                        l_oga.oga69,                                       #MOD-7C0056
                        l_oga.oga83,l_oga.oga84,l_oga.oga85,l_oga.oga86,   #No.FUN-A10123
                        l_oga.oga87,l_oga.oga88,l_oga.oga89,l_oga.oga90,   #No.FUN-A10123
                        l_oga.oga91,l_oga.oga92,l_oga.oga93,l_oga.oga94,   #No.FUN-A10123
                        l_oga.ogaconu,l_oga.ogacond,                       #No.FUN-A10123
                        l_oga.oga901,l_oga.oga902,
                        l_oga.oga903,l_oga.oga904,l_oga.oga905,l_oga.oga906,
                        l_oga.oga907,l_oga.oga908,l_oga.oga909,l_oga.ogaconf,l_oga.oga55, #MOD-C40162 add l_oga.oga55
                        l_oga.oga1001,l_oga.oga1002,l_oga.oga1003,l_oga.oga1004,
                        l_oga.oga1005,l_oga.oga1006,l_oga.oga1007,l_oga.oga1008,
                        l_oga.oga1009,l_oga.oga1010,l_oga.oga1011,l_oga.oga1012,
                        l_oga.oga1013,l_oga.oga1014,l_oga.oga1015,
                        l_oga.ogapost,l_oga.ogaprsw,l_oga.ogauser,l_oga.ogagrup,
                        l_oga.ogamodu,l_oga.ogadate,l_plant,l_legal,l_oga.ogaoriu,l_oga.ogaorig  #TQC-A10060   #FUN-980006 add g_plant,g_legal
                       ,l_oga.ogaud01,l_oga.ogaud02,l_oga.ogaud03,l_oga.ogaud04,l_oga.ogaud05,
                        l_oga.ogaud06,l_oga.ogaud07,l_oga.ogaud08,l_oga.ogaud09,l_oga.ogaud10,
                        l_oga.ogaud11,l_oga.ogaud12,l_oga.ogaud13,l_oga.ogaud14,l_oga.ogaud15,l_oga.oga57 #TQC-AC0055 add l_oga_oga57
           IF SQLCA.sqlcode<>0 THEN
              IF g_bgerr THEN
                 CALL s_errmsg("oga01",l_oga.oga01,"ins oga:","apm-019",1)  #No.TQC-740094
              ELSE
                 CALL cl_err3("","","","","apm-019","","ins oga:",1)
              END IF
               LET g_success = 'N'
           END IF
           IF g_aza.aza50='Y' THEN                                                                                                  
               IF l_oea.oea00='6' THEN                                                                                               
                       CALL p822_ohains()            #使用分銷功能,且有代送則生成銷退>                                                    
               END IF    
           END IF                      
END FUNCTION
 
#出貨單身檔
FUNCTION p822_ogbins(p_i)
  DEFINE l_sql   LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(1200)
  DEFINE l_sql1  LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(600)
  DEFINE l_sql2  LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(1600)
  DEFINE l_sql3  LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(400)
  DEFINE l_sql4  LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(400)
  DEFINE p_i     LIKE type_file.num5    #No.FUN-680136 SMALLINT
  DEFINE l_no    LIKE type_file.num5    #No.FUN-680136 SMALLINT
  DEFINE l_price LIKE ogb_file.ogb13
  DEFINE i,l_i   LIKE type_file.num5    #No.FUN-680136 SMALLINT
  DEFINE l_msg   LIKE ze_file.ze03      #No.FUN-680136 VARCHAR(80)
  DEFINE l_chr   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
  DEFINE l_ima491 LIKE ima_file.ima491
  DEFINE l_ima02  LIKE ima_file.ima02
  DEFINE l_ima25  LIKE ima_file.ima25
#  DEFINE l_qoh    LIKE ima_file.ima262 #FUN-A20044  
  DEFINE l_qoh    LIKE type_file.num15_3 #FUN-A20044  
  DEFINE l_ima39  LIKE ima_file.ima39
  DEFINE l_ima86  LIKE ima_file.ima86
  DEFINE l_ima35  LIKE ima_file.ima35
  DEFINE l_ima36  LIKE ima_file.ima36
  DEFINE l_no1   LIKE type_file.num5,    #No.FUN-680136 SMALLINT
         l_currm LIKE pmm_file.pmm42,
         x_currm LIKE pmm_file.pmm42,
         l_curr  LIKE pmm_file.pmm22     #No.FUN-680136 VARCHAR(04)
  DEFINE l_ogbi  RECORD LIKE ogbi_file.* #No.FUN-7B0018
  DEFINE l_flag   SMALLINT     #MOD-810179 add
  DEFINE l_plant  LIKE azp_file.azp01    #FUN-980006 add
  DEFINE l_legal  LIKE oga_file.ogalegal #FUN-980006 add
  DEFINE l_ogbiicd028 LIKE ogbi_file.ogbiicd028   #FUN-B90012
  DEFINE l_ogbiicd029 LIKE ogbi_file.ogbiicd029   #FUN-B90012
  DEFINE l_idd        RECORD LIKE idd_file.*      #FUN-B90012
  #DEFINE l_imaicd08   LIKE imaicd_file.imaicd08   #FUN-B90012 #FUN-BA0051 mark
  DEFINE l_flag1      LIKE type_file.chr1         #FUN-B90012
# DEFINE l_oia07  LIKE oia_file.oia07    #FUN-C50136
  DEFINE l_oga14  LIKE oga_file.oga14    #FUN-CB0087
  DEFINE l_oga15  LIKE oga_file.oga15    #FUN-CB0087
  
     LET l_plant = g_poy.poy04  #FUN-980006 add 
     CALL s_getlegal(l_plant) RETURNING l_legal  #FUN-980006 add
 
     #重取訂單號碼(ogbins) 
      LET l_sql1 = "SELECT oea01 ",
                   #"  FROM ",l_dbs_tra CLIPPED,"oea_file ",  #FUN-980092
                   "  FROM ",cl_get_target_table(l_plant_new,'oea_file'), #FUN-A50102
                   " WHERE oea99= '",g_pmm.pmm99,"' "    
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
         CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-980092
     PREPARE oea_p9 FROM l_sql1
     IF STATUS THEN CALL cl_err('oea_p9',STATUS,1) END IF
     DECLARE oea_c9 CURSOR FOR oea_p9
     OPEN oea_c9
     FETCH oea_c9 INTO g_oea.oea01
     IF SQLCA.SQLCODE <> 0 THEN
        CALL cl_err(l_dbs_new,'asf-500',1) 
        LET g_success='N'
        RETURN
     END IF
     CLOSE oea_c1
 
     #讀取訂單單身檔(oeb_file)
     LET l_sql1 = "SELECT * ",
                  #"  FROM ",l_dbs_tra CLIPPED,"oeb_file ", #FUN-980092
                  "  FROM ",cl_get_target_table(l_plant_new,'oeb_file'), #FUN-A50102 
                  " WHERE oeb01='",g_oea.oea01,"' " ,
                  "   AND oeb03 =",g_rvv.rvv37
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-A50102
     PREPARE oeb_p1 FROM l_sql1
     IF STATUS THEN
        IF g_bgerr THEN
           LET g_showmsg= g_oea.oea01,"/",g_rvv.rvv37   #No.TQC-740094
           CALL s_errmsg("oeb01,oeb03",g_showmsg,"oeb_p1",STATUS,1)  #No.TQC-740094
        ELSE
           CALL cl_err3("","","","",STATUS,"","oeb_p1",1)
        END IF
     END IF
     DECLARE oeb_c1 CURSOR FOR oeb_p1
     OPEN oeb_c1
     FETCH oeb_c1 INTO l_oeb.*
     IF SQLCA.SQLCODE <> 0 THEN
        IF g_bgerr THEN
           LET g_showmsg= g_oea.oea01,"/",g_rvv.rvv37   #No.TQC-740094
           CALL s_errmsg("oeb01,oeb03",g_showmsg,l_dbs_new,"asf-500",1)  #No.TQC-740094
        ELSE
           CALL cl_err3("","","","","asf-500","",l_dbs_new,1)
        END IF
        LET g_success='N'
        RETURN
     END IF
     CLOSE oeb_c1
     #新增出貨單身檔[ogb_file]
     LET l_ogb.ogb01 = l_oga.oga01      #出貨單號
     LET l_ogb.ogb03 = g_rvv.rvv02      #項次
     LET l_ogb.ogb04 = l_oeb.oeb04      #產品編號
     LET l_ogb.ogb05 = l_oeb.oeb05      #銷售單位
     LET l_ogb.ogb05_fac= l_oeb.oeb05_fac  #換算率
     LET l_ogb.ogb06 = l_oeb.oeb06      #品名規格
     LET l_ogb.ogb07 = l_oeb.oeb07      #額外品名編號
     LET l_ogb.ogb08 = l_oeb.oeb08      #出貨工廠
     LET l_ogb.ogb09 = l_oeb.oeb09      #出貨倉庫
     LET l_ogb.ogb091= l_oeb.oeb091     #出貨儲位
     LET l_ogb.ogb092= l_oeb.oeb092     #出貨批號
     LET l_ogb.ogbud01 = l_oeb.oebud01
     LET l_ogb.ogbud02 = l_oeb.oebud02
     LET l_ogb.ogbud03 = l_oeb.oebud03
     LET l_ogb.ogbud04 = l_oeb.oebud04
     LET l_ogb.ogbud05 = l_oeb.oebud05
     LET l_ogb.ogbud06 = l_oeb.oebud06
     LET l_ogb.ogbud07 = l_oeb.oebud07
     LET l_ogb.ogbud08 = l_oeb.oebud08
     LET l_ogb.ogbud09 = l_oeb.oebud09
     LET l_ogb.ogbud10 = l_oeb.oebud10
     LET l_ogb.ogbud11 = l_oeb.oebud11
     LET l_ogb.ogbud12 = l_oeb.oebud12
     LET l_ogb.ogbud13 = l_oeb.oebud13
     LET l_ogb.ogbud14 = l_oeb.oebud14
     LET l_ogb.ogbud15 = l_oeb.oebud15
     CALL p822_ima(l_ogb.ogb04)
       RETURNING l_ima02,l_ima25,l_qoh,l_ima86,l_ima39,
                 l_ima35,l_ima36
     IF NOT cl_null(p_imd01) THEN          #MOD-810179 cancel mark
        #CALL p822_imd(p_imd01,l_dbs_new)   #MOD-810179 cancel mark
        CALL p822_imd(p_imd01,l_dbs_new,l_plant_new)   #FUN-A50102
        LET l_ogb.ogb09 = p_imd01          #MOD-810179 cancel mark
        LET l_ogb.ogb091= ' '
        LET l_ogb.ogb092= ' '
     ELSE
       IF cl_null(l_ima35) THEN
          LET l_ogb.ogb09 = g_rvv.rvv32
          LET l_ogb.ogb091= g_rvv.rvv33
          LET l_ogb.ogb092= g_rvv.rvv34
       ELSE
          LET l_ogb.ogb09 = l_ima35
          LET l_ogb.ogb091= l_ima36
          LET l_ogb.ogb092= ' '
       END IF
     END IF
    #IF g_sma.sma96 = 'Y' THEN         #FUN-C80001 #FUN-D30099 mark
     IF g_pod.pod08 = 'Y' THEN         #FUN-D30099
        LET l_ogb.ogb092= g_rvv.rvv34  #FUN-C80001
     END IF                            #FUN-C80001
     LET l_ogb.ogb11 = l_oeb.oeb11      #客戶產品編號
     LET l_ogb.ogb12 = g_rvv.rvv17      #實際出貨數量
     LET l_ogb.ogb12 = s_digqty(l_ogb.ogb12,l_ogb.ogb05)   #FUN-910088--add--
     LET l_ogb.ogb13 = l_oeb.oeb13      #原幣單價
     IF g_pod.pod03 = 'N' THEN
        LET l_ogb.ogb13 = l_oeb.oeb13      #原幣單價
        LET l_ogb.ogb37 = l_oeb.oeb37      #基础单价 #FUN-AB0061
     ELSE
        IF p_i = 1 THEN                    #MOD-880091 modify i->p_i
           LET l_ogb.ogb13=g_rvv.rvv38     #單價: 同上游采購單價
        ELSE
           LET l_no1 = p_i-1               #MOD-880091 modify i->p_i
           SELECT po_price INTO l_ogb.ogb13
             FROM p822_file
            WHERE p_no   = l_no1
              AND po_no  = l_rvb.rvb01
              AND po_item= g_rvv.rvv05     #MOD-890010
        END IF
     END IF
     IF cl_null(l_ogb.ogb37) OR l_ogb.ogb37=0 THEN    #FUN-AB0061           
        LET l_ogb.ogb37=l_ogb.ogb13                   #FUN-AB0061           
     END IF                                           #FUN-AB0061   
     LET l_ogb.ogb917 = g_rvv.rvv87   #No.TQC-6A0084
     LET l_ogb.ogb917 = s_digqty(l_ogb.ogb917,g_rvv.rvv86)   #FUN-910088--add--
 
     #未稅金額/含稅金額 : oeb14/oeb14t
     IF l_oga.oga213 = 'N' THEN
        LET l_ogb.ogb14=l_ogb.ogb917*l_ogb.ogb13  #No.TQC-6A0084
        LET l_ogb.ogb14t=l_ogb.ogb14*(1+l_oga.oga211/100)
     ELSE 
        LET l_ogb.ogb14t=l_ogb.ogb917*l_ogb.ogb13  #No.TQC-6A0084
        LET l_ogb.ogb14=l_ogb.ogb14t/(1+l_oga.oga211/100)
     END IF
     #LET l_ogb.ogb15 = l_oeb.oeb05   #MOD-A90100
     #LET l_ogb.ogb15=l_ima25   #MOD-A90100   #MOD-AB0219 mark
     #LET l_ogb.ogb15_fac = 1   #MOD-AB0219 mark
     #與庫存單位轉換率的計算
     #=====================================================
     #ogb15存放的是倉庫的單位(img09)，因此不管目前l_ogb.ogb15
     #是否為NULL都必須重新塞值給l_ogb.ogb15
     #=====================================================
      IF l_ogb.ogb09  IS NULL THEN LET l_ogb.ogb09  = ' ' END IF
      IF l_ogb.ogb091 IS NULL THEN LET l_ogb.ogb091 = ' ' END IF
      IF l_ogb.ogb092 IS NULL THEN LET l_ogb.ogb092 = ' ' END IF
     #-----MOD-AB0219---------取消mark 
     #-----MOD-A90100---------
     LET l_sql1 = "SELECT img09 ",                                 
                  #" FROM ",l_dbs_tra CLIPPED,"img_file ",  #FUN-980092  
                  " FROM ",cl_get_target_table(l_plant_new,'img_file'), #FUN-A50102
                  " WHERE img01 ='", l_ogb.ogb04,"' ",
                  "   AND img02 ='", l_ogb.ogb09,"' ",
                  "   AND img03 ='", l_ogb.ogb091,"' ",
                  "   AND img04 ='", l_ogb.ogb092,"' "
     CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-A50102
     PREPARE img_p1 FROM l_sql1
     IF SQLCA.SQLCODE THEN 
        CALL cl_err('img_p1',SQLCA.SQLCODE,1)
     END IF
     DECLARE img_c1 CURSOR FOR img_p1
     OPEN img_c1
     FETCH img_c1 INTO l_ogb.ogb15
 
     IF STATUS=0 THEN
     #-----END MOD-A90100-----
     #-----END MOD-AB0219-----取消mark
        IF l_ogb.ogb05 = l_ogb.ogb15 THEN
            LET l_ogb.ogb15_fac =1
        ELSE
            #檢查該銷售單位與倉庫的庫存單位是否可以轉換
            CALL s_umfchkm(l_ogb.ogb04,l_ogb.ogb05,l_ogb.ogb15,l_plant_new) #FUN-980092
                 RETURNING l_flag,l_ogb.ogb15_fac
            IF l_flag THEN
               LET g_msg=l_dbs_new CLIPPED,' ',l_ogb.ogb04
               CALL cl_err(g_msg,'mfg3075',1)
               LET g_success = 'N'
            END IF 
        END IF
     END IF   #MOD-A90100   #MOD-AB0219 取消mark
     IF cl_null(l_ogb.ogb15) THEN LET l_ogb.ogb15  = l_ogb.ogb05 END IF
     IF cl_null(l_ogb.ogb15_fac) THEN LET l_ogb.ogb15_fac = 1 END IF
 
     #銷售單位/庫存單位轉換率
     CALL s_umfchkm(l_ogb.ogb04,l_ogb.ogb05,l_ima25,l_plant_new)  #FUN-980092
          RETURNING l_flag,l_ogb.ogb05_fac
     IF l_flag THEN
        LET g_msg=l_dbs_new CLIPPED,' ',l_ogb.ogb04
        CALL cl_err(g_msg,'mfg3075',1)
        LET g_success = 'N'
     END IF 
 
     LET l_ogb.ogb16 = l_ogb.ogb12 * l_ogb.ogb15_fac
     LET l_ogb.ogb16 = s_digqty(l_ogb.ogb16,l_ogb.ogb15)    #FUN-910088--add--
     LET l_ogb.ogb17 = 'N'
     LET l_ogb.ogb18 = l_ogb.ogb12
     LET l_ogb.ogb19 =' '
     LET l_ogb.ogb20 =' '
     LET l_ogb.ogb31 = g_oea.oea01
     LET l_ogb.ogb32 = g_rvv.rvv37 
     LET l_ogb.ogb60 =0
     LET l_ogb.ogb63 =0
     LET l_ogb.ogb64 =0
     CALL cl_digcut(l_ogb.ogb14,l_azi.azi04) RETURNING l_ogb.ogb14
     CALL cl_digcut(l_ogb.ogb14t,l_azi.azi04)RETURNING l_ogb.ogb14t
     LET l_ogb.ogb910 = g_rvv.rvv80
     LET l_ogb.ogb911 = g_rvv.rvv81
     LET l_ogb.ogb912 = g_rvv.rvv82
     LET l_ogb.ogb913 = g_rvv.rvv83
     LET l_ogb.ogb914 = g_rvv.rvv84
     LET l_ogb.ogb915 = g_rvv.rvv85
     LET l_ogb.ogb916 = g_rvv.rvv86
     LET l_ogb.ogb930 = l_oeb.oeb930   #成本中心
     LET l_ogb.ogb1005 = '1' 
     IF g_aza.aza50='Y' THEN
        #LET l_ogb.ogb1001 = l_oeb.oeb1001  #TQC-D40064 mark
        LET l_ogb.ogb1002 = l_oeb.oeb1002
        LET l_ogb.ogb1003 = l_oeb.oeb15
        LET l_ogb.ogb1004 = l_oeb.oeb1004
        LET l_ogb.ogb1005 = l_oeb.oeb1003
        LET l_ogb.ogb1006 = l_oeb.oeb1006
        LET l_ogb.ogb1007 = ''
        LET l_ogb.ogb1008 = ''
        LET l_ogb.ogb1009 = ''
        LET l_ogb.ogb1010 = ''
        LET l_ogb.ogb1011 = ''
        LET l_ogb.ogb1012 = l_oeb.oeb1012 
        LET l_ogb.ogb1014 = 'N' #FUN-6B0044
 
        IF l_ogb.ogb1012='Y' THEN   #搭贈時金額為零
           LET l_ogb.ogb14 = 0
           LET l_ogb.ogb14t= 0
        END IF
 
        #單頭之含稅出貨總金額                                                                 
        LET l_oga.oga1008 =l_oga.oga1008 + l_ogb.ogb14t    #原幣出貨金額(含稅)
        #LET l_sql4="UPDATE ",l_dbs_tra CLIPPED,"oga_file", #FUN-980092
        LET l_sql4="UPDATE ",cl_get_target_table(l_plant_new,'oga_file'), #FUN-A50102
                   "   SET oga1008 = ? ",                                                        
                   " WHERE oga01 = ? "                                                  
 	 CALL cl_replace_sqldb(l_sql4) RETURNING l_sql4        #FUN-920032
     CALL cl_parse_qry_sql(l_sql4,l_plant_new) RETURNING l_sql4 #FUN-A50102
        PREPARE upd_oga1008 FROM l_sql4                                                   
        EXECUTE upd_oga1008
        USING l_oga.oga1008,l_oga.oga01                                 
        IF SQLCA.sqlcode<>0 THEN                                                           
           IF g_bgerr THEN
              CALL s_errmsg("oga01",l_oga.oga01,"upd oga:",SQLCA.sqlcode,1)  #No.TQC-740094
           ELSE
              CALL cl_err3("","","","",SQLCA.sqlcode,"","upd oga:",1)
           END IF
           LET g_success = 'N'                                                          
        END IF  
        IF l_oea.oea00='6' THEN  
           CALL p822_ohbins()                     #使用分銷功能,且有代送則生成銷退單
        END IF 
     END IF                
     LET l_ogb.ogb1001 = l_oeb.oeb1001                                      #TQC-D40064 add
     IF cl_null(l_ogb.ogb1001) THEN LET l_ogb.ogb1001 = g_poy.poy28 END IF  #TQC-D40064 add
     #No.FUN-A10123 ...begin
     IF g_azw.azw04 = '2' THEN
        LET l_ogb.ogb44 = l_oeb.oeb44
        LET l_ogb.ogb45 = l_oeb.oeb45
        LET l_ogb.ogb46 = l_oeb.oeb46
        LET l_ogb.ogb47 = l_oeb.oeb47
     END IF
     IF cl_null(l_ogb.ogb44) THEN
        LET l_ogb.ogb44 = ' '
     END IF
     IF cl_null(l_ogb.ogb47) THEN
        LET l_ogb.ogb47 = 0 
     END IF
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
     #FUN-AC0055 mark ---------------------begin-----------------------
     #FUN-AB0096 -----------add start------------
     #IF cl_null(l_ogb.ogb50) THEN
     #   LET l_ogb.ogb50 = '1'
     #END IF 
     ##FUN-AB0096 -----------add end-------------
     #FUN-AC0055 mark ----------------------end------------------------
     #No.FUN-A10123 ...end

     #TQC-D20047--add--str--
     LET l_sql2 = "SELECT aza115 FROM ",cl_get_target_table(l_plant_new,'aza_file')," WHERE aza01 = '0' "
     PREPARE aza115_pr FROM l_sql2
     EXECUTE aza115_pr INTO g_aza.aza115   
     #TQC-D20047--add--end--
     #FUN-CB0087--add--str--
     #IF g_aza.aza115='Y' THEN                            #TQC-D40064 mark
     IF g_aza.aza115='Y' AND cl_null(l_ogb.ogb1001) THEN  #TQC-D40064 add
        #TQC-D20050--mod--str--
        #SELECT oga14,oga15 INTO l_oga14,l_oga15 FROM oga_file WHERE oga01 = l_ogb.ogb01
        #CALL s_reason_code(l_ogb.ogb01,l_ogb.ogb31,'',l_ogb.ogb04,l_ogb.ogb09,l_oga14,l_oga15) RETURNING l_ogb.ogb1001
        LET l_sql2="SELECT oga14,oga15 FROM ",cl_get_target_table(l_plant_new,'oga_file')," WHERE oga01 ='",l_ogb.ogb01,"'"
        PREPARE ogb1001_pr FROM l_sql2
        EXECUTE ogb1001_pr INTO l_oga14,l_oga15
        CALL s_reason_code1(l_ogb.ogb01,l_ogb.ogb31,'',l_ogb.ogb04,l_ogb.ogb09,l_oga14,l_oga15,l_plant_new) RETURNING l_ogb.ogb1001
        #TQC-D20050--mod--end--
        IF cl_null(l_ogb.ogb1001) THEN
           CALL cl_err(l_ogb.ogb1001,'aim-425',1)
           LET g_success="N"
           RETURN
        END IF
     END IF
     #FUN-CB0087--add--end--
     #新增出貨單身檔
     #LET l_sql2="INSERT INTO ",l_dbs_tra CLIPPED,"ogb_file", #FUN-980092
     LET l_sql2="INSERT INTO ",cl_get_target_table(l_plant_new,'ogb_file'), #FUN-A50102
                "(ogb01,ogb03,ogb04,ogb05, ",
                " ogb05_fac,ogb06,ogb07,ogb08, ",
                " ogb09,ogb091,ogb092,ogb11, ",
                " ogb12,ogb37,ogb13,ogb14,ogb14t,",#FUN-AB0061
                " ogb15,ogb15_fac,ogb16,ogb17, ",
                " ogb18,ogb19,ogb20,ogb31,",
                " ogb32,ogb60,ogb63,ogb64,",
                " ogb44,ogb45,ogb46,ogb47,",  #No.FUN-A10123
                " ogb901,ogb902,ogb903,ogb904,",
                " ogb905,ogb906,ogb907,ogb908,",
                " ogb1001,ogb1002,ogb1003,ogb1004,ogb1005,ogb1006,",
                " ogb1007,ogb1008,ogb1009,ogb1010,ogb1011,ogb1012,",
                " ogb909,ogb910,ogb911,ogb912,",   #FUN-560043
                " ogb913,ogb914,ogb915,ogb916,",   #FUN-560043
                " ogb917,ogb50,ogb51,ogb52,ogb53,ogb54,ogb55,ogb1014,ogb930,ogbplant,ogblegal ,", #FUN-C50097 ADD ogb50,51,52,53,54,55
                " ogbud01,ogbud02,ogbud03,ogbud04,ogbud05,",                    
                " ogbud06,ogbud07,ogbud08,ogbud09,ogbud10,",                    
                " ogbud11,ogbud12,ogbud13,ogbud14,ogbud15 )",    
                " VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                "         ?,?,?,?, ?,?,?,?, ?,?,?,?,",          #No.FUN-620025 
                "         ?,?,?,?, ",                           #No.FUN-A10123
                "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,?,?,",    #No.CHI-950020    #FUN-AB0096 add ? #FUN-C50097 ADD ogb50,51,52 ?
                "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?, ?,?) "   #FUN-560043 #FUN-6B0044   #MOD-8B0264 add ? #FUN-980006 add ?.?#FUN-AB0061 
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
     PREPARE ins_ogb FROM l_sql2
     EXECUTE ins_ogb USING 
                l_ogb.ogb01,l_ogb.ogb03,l_ogb.ogb04,l_ogb.ogb05, 
                l_ogb.ogb05_fac,l_ogb.ogb06,l_ogb.ogb07,l_ogb.ogb08, 
                l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,l_ogb.ogb11, 
                l_ogb.ogb12,l_ogb.ogb37,l_ogb.ogb13,l_ogb.ogb14,l_ogb.ogb14t,#FUN-AB0061
                l_ogb.ogb15,l_ogb.ogb15_fac,l_ogb.ogb16,l_ogb.ogb17, 
                l_ogb.ogb18,l_ogb.ogb19,l_ogb.ogb20,l_ogb.ogb31,
                l_ogb.ogb32,l_ogb.ogb60,l_ogb.ogb63,l_ogb.ogb64,
                l_ogb.ogb44,l_ogb.ogb45,l_ogb.ogb46,l_ogb.ogb47,       #No.FUN-A10123
                l_ogb.ogb901,l_ogb.ogb902,l_ogb.ogb903,l_ogb.ogb904,
                l_ogb.ogb905,l_ogb.ogb906,l_ogb.ogb907,l_ogb.ogb908,
                l_ogb.ogb1001,l_ogb.ogb1002,l_ogb.ogb1003,l_ogb.ogb1004,
                l_ogb.ogb1005,l_ogb.ogb1006,l_ogb.ogb1007,l_ogb.ogb1008,l_ogb.ogb1009,
                l_ogb.ogb1010,l_ogb.ogb1011,l_ogb.ogb1012,
                l_ogb.ogb909,l_ogb.ogb910,l_ogb.ogb911,l_ogb.ogb912,   #FUN-560043
                l_ogb.ogb913,l_ogb.ogb914,l_ogb.ogb915,l_ogb.ogb916,   #FUN-560043
                l_ogb.ogb917,l_ogb.ogb50,l_ogb.ogb51,l_ogb.ogb52,l_ogb.ogb53,l_ogb.ogb54,l_ogb.ogb55,l_ogb.ogb1014     #FUN-560043 #FUN-6B0044 #FUN-C50097 ADD ogb50,51,52
                ,l_ogb.ogb930,l_plant,l_legal   #MOD-8B0264 add #FUN-980006 add g_plant,g_legal   #FUN-AB0096 add ogb50
               ,l_ogb.ogbud01,l_ogb.ogbud02,l_ogb.ogbud03,l_ogb.ogbud04,l_ogb.ogbud05,
                l_ogb.ogbud06,l_ogb.ogbud07,l_ogb.ogbud08,l_ogb.ogbud09,l_ogb.ogbud10,
                l_ogb.ogbud11,l_ogb.ogbud12,l_ogb.ogbud13,l_ogb.ogbud14,l_ogb.ogbud15
     IF SQLCA.sqlcode<>0 THEN
        IF g_bgerr THEN
           LET g_showmsg=l_ogb.ogb01,"/",l_ogb.ogb03       #No.TQC-740094
           CALL s_errmsg("ogb01,ogb03",g_showmsg,"ins ogb:",SQLCA.sqlcode,1)  #No.TQC-740094
        ELSE
           CALL cl_err3("","","","",SQLCA.sqlcode,"","ins ogb:",1)
        END IF
         LET g_success = 'N'
     ELSE
        IF NOT s_industry('std') THEN
           INITIALIZE l_ogbi.* TO NULL
           LET l_ogbi.ogbi01 = l_ogb.ogb01
           LET l_ogbi.ogbi03 = l_ogb.ogb03
           IF NOT s_ins_ogbi(l_ogbi.*,l_plant_new) THEN #FUN-980092
              LET g_success = 'N'
           END IF
        END IF
#       #FUN-C50136----add----str----
#       IF g_oaz.oaz96 ='Y' THEN
#          CALL s_ccc_oia07('D',l_oga.oga03) RETURNING l_oia07
#          IF l_oia07 = '0' THEN
#             CALL s_ccc_oia(l_oga.oga03,'D',l_oga.oga01,0,l_plant_new)
#          END IF
#       END IF
#       #FUN-C50136----add----end----
     END IF
 
     #LET l_sql2 = "SELECT ima918,ima921 FROM ",l_dbs_new CLIPPED,"ima_file",
     LET l_sql2 = "SELECT ima918,ima921 FROM ",cl_get_target_table(l_plant_new,'ima_file'), #FUN-A50102
                  " WHERE ima01 = '",l_ogb.ogb04,"'",
                  "   AND imaacti = 'Y'"
 
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
     PREPARE ima_ogb FROM l_sql2
 
     EXECUTE ima_ogb INTO g_ima918,g_ima921                                                                             
     
     IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
        
        FOREACH p822_g_rvbs INTO l_rvbs.*
           IF STATUS THEN
              CALL cl_err('rvbs',STATUS,1)
           END IF
        
           LET l_rvbs.rvbs00 = "axmt821"
     
           LET l_rvbs.rvbs01 = l_ogb.ogb01
        
           #LET l_rvbs.rvbs06 = l_rvbs.rvbs06 * l_ogb.ogb15_fac   #MOD-A90100
           LET l_rvbs.rvbs06 = l_rvbs.rvbs06   #MOD-A90100
     
           IF cl_null(l_rvbs.rvbs06) THEN
              LET l_rvbs.rvbs06 = 0
           END IF
     
           LET l_rvbs.rvbs09 = -1
           LET l_rvbs.rvbs13 = 0    #MOD-940294
 
           #新增批/序號資料檔
           EXECUTE ins_rvbs USING l_rvbs.rvbs00,l_rvbs.rvbs01,l_rvbs.rvbs02,
                                  l_rvbs.rvbs021,l_rvbs.rvbs022,l_rvbs.rvbs03,
                                  l_rvbs.rvbs04,l_rvbs.rvbs05,l_rvbs.rvbs06,
                                  l_rvbs.rvbs07,l_rvbs.rvbs08,l_rvbs.rvbs09, 
                                  l_rvbs.rvbs13,l_plant,l_legal    #MOD-940294 #FUN-980006 add l_plant,l_legal
     
           IF STATUS OR SQLCA.SQLCODE THEN
              LET g_showmsg = l_rvbs.rvbs01,"/",l_rvbs.rvbs03
              CALL s_errmsg('rvbs01,rvbs03',g_showmsg,'ins rvbs:',SQLCA.sqlcode,1) 
              LET g_success='N'
           END IF
        
           CALL p822_imgs(l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,l_oga.oga02,l_rvbs.*)
     
        END FOREACH
     END IF

     #FUN-B90012----add----str----
     IF s_industry('icd') THEN
        #FUN-BA0051 --START mark--
        #LET l_sql2 = "SELECT imaicd08 FROM ",cl_get_target_table(l_plant_new,'ima_file'),",",
        #                                     cl_get_target_table(l_plant_new,'imaicd_file'),
        #             " WHERE imaicd00 = '",l_ogb.ogb04,"' ",
        #             "   AND ima01 = imaicd00 ",
        #             "   AND imaacti = 'Y' "
        #CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
        #CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2
        #PREPARE imaicd08_ogb FROM l_sql2
        #EXECUTE imaicd08_ogb INTO l_imaicd08
        #   
        #IF l_imaicd08 = 'Y' THEN
        #FUN-BA0051 --END mark--
        IF s_icdbin_multi(l_ogb.ogb04,l_plant_new) THEN   #FUN-BA0051
           FOREACH p822_idd INTO l_idd.*
              IF STATUS THEN
                 CALL cl_err('idb',STATUS,1)
              END IF
              LET l_idd.idd10 = l_ogb.ogb01
              LET l_idd.idd11 = l_ogb.ogb03
        #CHI-C80009---add---START
              LET l_idd.idd02 = l_ogb.ogb09
              LET l_idd.idd03 = l_ogb.ogb091
              LET l_idd.idd04 = l_ogb.ogb092
        #CHI-C80009---add-----END
              CALL icd_idb(l_idd.*,l_plant_new)
           END FOREACH
        END IF
        
        LET l_sql2 = "SELECT ogbiicd028,ogbiicd029 FROM ",cl_get_target_table(l_plant_new,'ogbi_file'),
                     " WHERE ogbi01 = '",l_ogb.ogb01,"' ",
                     "   AND ogbi03 = '",l_ogb.ogb03,"' "
        CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
        CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2
        PREPARE imaicd_ogb_3 FROM l_sql2
        EXECUTE imaicd_ogb_3 INTO l_ogbiicd028,l_ogbiicd029
        
        CALL s_icdpost(12,l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,
                       l_ogb.ogb092,l_ogb.ogb05,l_ogb.ogb12,
                       l_oga.oga01,l_ogb.ogb03,l_oga.oga02,'Y','',''
                       ,l_ogbiicd029,l_ogbiicd028,l_plant_new)   
            RETURNING l_flag1
        IF l_flag1 = 0 THEN
           LET g_success = 'N'
        END IF
     END IF
     #FUN-B90012----add----end----
 
     #單頭之出貨金額
     LET l_oga.oga50 =l_oga.oga50 + l_ogb.ogb14   #原幣出貨金額(未稅)
     LET l_oga.oga51 =l_oga.oga51 + l_ogb.ogb14t  #原幣出貨金額(含稅)
     LET l_oga.oga52 = l_oga.oga50 * l_oga.oga161/100
     LET l_oga.oga53 = l_oga.oga50 * (l_oga.oga162+l_oga.oga163)/100
     #LET l_sql3="UPDATE ",l_dbs_tra CLIPPED,"oga_file",  #FUN-980092
     LET l_sql3="UPDATE ",cl_get_target_table(l_plant_new,'oga_file'), #FUN-A50102
                "   SET oga50 = ? ,",
                "       oga51 = ? ,",
                "       oga52 = ? ,",
                "       oga53 = ? ",
                " WHERE oga01 = ? "
 	 CALL cl_replace_sqldb(l_sql3) RETURNING l_sql3        #FUN-920032
     CALL cl_parse_qry_sql(l_sql3,l_plant_new) RETURNING l_sql3 #FUN-A50102
     PREPARE upd_oga50 FROM l_sql3
     EXECUTE upd_oga50 USING l_oga.oga50,l_oga.oga51,l_oga.oga52,
                             l_oga.oga53,l_oga.oga01
     IF SQLCA.sqlcode<>0 THEN
        IF g_bgerr THEN
           CALL s_errmsg("oga01",l_oga.oga01,"upd oga:",SQLCA.sqlcode,1)  #No.TQC-740094
        ELSE
           CALL cl_err3("","","","",SQLCA.sqlcode,"","upd oga:",1)
        END IF
         LET g_success = 'N'
     END IF
   #回寫最近出庫日 ima74
    LET l_sql1 = "SELECT ima29 ", 
                 #" FROM ",l_dbs_new CLIPPED,"ima_file ",  
                 " FROM ",cl_get_target_table(l_plant_new,'ima_file'), #FUN-A50102  
                 " WHERE ima01='",l_ogb.ogb04,"'"
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-A50102
    PREPARE ima_p1 FROM l_sql1
    IF SQLCA.SQLCODE THEN 
      IF g_bgerr THEN
         CALL s_errmsg("ima01",l_ogb.ogb04,"",SQLCA.sqlcode,1)  
      ELSE
         CALL cl_err3("","","","",SQLCA.sqlcode,"","",1)
      END IF
    END IF
    DECLARE ima_c1 CURSOR FOR ima_p1
    OPEN ima_c1	
    FETCH ima_c1 INTO l_ima29
    #--- NO:0721 異動日期需大於原來的異動日期才可 
    #必須判斷null,否則新料不會update
    IF (l_oga.oga02 > l_ima29 OR l_ima29 IS NULL)  THEN
       #LET l_sql2="UPDATE ",l_dbs_new CLIPPED,"ima_file",
       LET l_sql2="UPDATE ",cl_get_target_table(l_plant_new,'ima_file'), #FUN-A50102  
                  " SET ima74 = ? ",
                  "   , ima29 = ? ",     #MOD-C30877 add
                  " WHERE ima01 = ?  "
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
       PREPARE upd_ima1 FROM l_sql2
      #EXECUTE upd_ima1 USING l_oga.oga02,l_ogb.ogb04                 #MOD-C30877 mark
       EXECUTE upd_ima1 USING l_oga.oga02,l_oga.oga02,l_ogb.ogb04     #MOD-C30877 add
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
          IF g_bgerr THEN
             CALL s_errmsg('ima01',l_ogb.ogb04,'upd ima',STATUS,1)
          ELSE
             CALL cl_err('upd ima:',STATUS,1)
          END IF
          LET g_success='N'
       END IF
    END IF
END FUNCTION
 
#INSERT 收貨單頭
FUNCTION p822_rvains()
  DEFINE l_rvb04  LIKE rvb_file.rvb04   #MOD-650049 add
  DEFINE l_buf    LIKE type_file.chr1000            #MOD-650049 add  #No.FUN-680136 VARCHAR(100)
  DEFINE l_sql     LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(1200)
  DEFINE l_sql1    LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(600)
  DEFINE l_sql2    LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(1600)
  DEFINE i,l_i     LIKE type_file.num5    #No.FUN-680136 SMALLINT
  DEFINE li_result LIKE type_file.num5                 #No.FUN-620025  #No.FUN-680136 SMALLINT
  DEFINE l_pmm901  LIKE pmm_file.pmm901   #FUN-5A0176
  DEFINE l_x       LIKE oay_file.oayslip  #FUN-670007
  DEFINE l_plant  LIKE azp_file.azp01    #FUN-980006 add
  DEFINE l_legal  LIKE oga_file.ogalegal #FUN-980006 add
   
  LET l_plant = g_poy.poy04  #FUN-980006 add 
  CALL s_getlegal(l_plant) RETURNING l_legal  #FUN-980006 add
   
  #新增驗收單單頭檔(rva_file)
       CALL s_auto_assign_no('apm',rva_t1,g_rvu.rvu03,"","","",l_plant_new,"","")  #FUN-980092                                                       
       RETURNING li_result,l_rva.rva01   
       IF NOT li_result THEN                                                                                                            
          IF g_bgerr THEN
             LET g_msg = l_plant_new CLIPPED,l_rva.rva01                        #TQC-9B0013
             CALL s_errmsg("rva01",l_rva.rva01,g_msg CLIPPED,"mfg3046",1)       #TQC-9B0013
          ELSE
             CALL cl_err3("","","","","mfg3046","","",1)                        #TQC-9B0013
          END IF
          LET g_success = 'N'                                                                                                           
          RETURN                                                                                                                        
       END IF      
    LET l_rva.rva04 = 'N'                #是否為 L/C 收料
    #LET l_sql = " SELECT pmm01,pmm09 ",                     #No.FUN-A10123
    LET l_sql = " SELECT pmm01,pmm09,pmm51,pmm52,pmm53 ",    #No.FUN-A10123
   		  #"   FROM ",l_dbs_new CLIPPED,"pmm_file ",
   		   #"   FROM ",l_dbs_tra CLIPPED,"pmm_file ",  #FUN-980092
                "   FROM ",cl_get_target_table(l_plant_new,'pmm_file'), #FUN-A50102  
                "  WHERE pmm99 = '",g_pmm.pmm99,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
    PREPARE pmm_prepare1 FROM l_sql
    DECLARE pmm_curs1 CURSOR FOR pmm_prepare1
    OPEN pmm_curs1
    FETCH pmm_curs1 INTO l_rva.rva02,l_rva.rva05,l_rva.rva29,l_rva.rva30,l_rva.rva31  #No.FUN-A10123
    IF SQLCA.sqlcode THEN 
       IF g_bgerr THEN
          CALL s_errmsg("pmm01",g_pmm.pmm01,"fetch pmm_curs1",SQLCA.sqlcode,1)  #No.TQC-740094
       ELSE
          CALL cl_err3("","","","",SQLCA.sqlcode,"","fetch pmm_curs1",1)
       END IF
       LET l_rva.rva05 = ''
       LET g_success = 'N'
    END IF
    CLOSE pmm_curs1
    IF cl_null(g_rva.rva02) THEN LET l_rva.rva02=g_rva.rva02 END IF  #TQC-810048 add  #合併收貨單頭採購單號應為空白
    LET l_rva.rva06 = g_rvu.rvu03        #收貨日期
    LET l_rva.rva10 = g_pmm.pmm02        #采購類別
    LET l_rva.rvaprsw='Y'                #是否需列印驗收單 
    LET l_rva.rva21 = NULL
    LET l_rva.rva23 = NULL
    LET l_rva.rva99 = g_flow99           #No.8106
    LET l_rva.rvaconf= 'Y'
    LET l_rva.rvaacti= 'Y'
    LET l_rva.rvaprno= 0
    LET l_rva.rvauser= g_user
    LET l_rva.rvagrup= g_grup
    LET l_rva.rvaoriu=g_user   #TQC-A10060  add
    LET l_rva.rvaorig=g_grup   #TQC-A10060  add
    LET l_rva.rvamodu= null
    LET l_rva.rvadate= null
    LET l_rva.rva00 = '1'        #FUN-940083 add
    LET l_rva.rvaud01 = g_rva.rvaud01
    LET l_rva.rvaud02 = g_rva.rvaud02
    LET l_rva.rvaud03 = g_rva.rvaud03
    LET l_rva.rvaud04 = g_rva.rvaud04
    LET l_rva.rvaud05 = g_rva.rvaud05
    LET l_rva.rvaud06 = g_rva.rvaud06
    LET l_rva.rvaud07 = g_rva.rvaud07
    LET l_rva.rvaud08 = g_rva.rvaud08
    LET l_rva.rvaud09 = g_rva.rvaud09
    LET l_rva.rvaud10 = g_rva.rvaud10
    LET l_rva.rvaud11 = g_rva.rvaud11
    LET l_rva.rvaud12 = g_rva.rvaud12
    LET l_rva.rvaud13 = g_rva.rvaud13
    LET l_rva.rvaud14 = g_rva.rvaud14
    LET l_rva.rvaud15 = g_rva.rvaud15
    #No.FUN-A10123  ...begin
    IF g_azw.azw04 = '2' THEN
    #  LET l_rva.rvacrat = g_today   #TQC-A60075
    #  LET l_rva.rvacond = g_today   #TQC-A60075
       LET l_rva.rvaconu = g_user
    END IF
    LET l_rva.rvacrat = g_today      #TQC-A60075
    LET l_rva.rvacond = g_today      #TQC-A60075
    IF cl_null(l_rva.rva29) THEN LET l_rva.rva29 =' ' END IF  
    #No.FUN-A10123  ...end
    #新增收貨單頭
    #LET l_sql="INSERT INTO ",l_dbs_tra CLIPPED,"rva_file",  #FUN-980092
    LET l_sql="INSERT INTO ",cl_get_target_table(l_plant_new,'rva_file'), #FUN-A50102
              "(rva00,rva01,rva02,rva03,rva04  ,rva05  ,",    #FUN-940083 add rva00
              " rva06  ,rva07  ,rva08  ,rva09  ,rva10  ,",
              " rvaprsw,rva20  ,rva21  ,rva22  ,rva23  ,",
              " rva24  ,rva25  ,rva26  ,rva27  ,rva28  ,",
              " rva29  ,rva30  ,rva31  ,rvacrat  ,rvacond  ,rvaconu, ",  #No.FUN-A10123
              " rvaconf,rvaprno,rvaacti,rvauser,rvagrup,",
              " rvamodu,rvadate,rva99,rvaplant,rvalegal,rvaoriu,rvaorig ,",  #TQC-A10060  addrvaoriu,rvaorig
              " rvaud01,rvaud02,rvaud03,rvaud04,rvaud05,",
              " rvaud06,rvaud07,rvaud08,rvaud09,rvaud10,",
              " rvaud11,rvaud12,rvaud13,rvaud14,rvaud15 )",
              " VALUES( ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,",
              "         ?,?,?,?, ?,?,                     ",       #No.FUN-A10123
              "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,?,",    #No.CHI-950020  #TQC-A10060  add ?,?
              "         ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?, ?,?)" #FUN-980006 add ?,?
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
    PREPARE ins_rva FROM l_sql
    EXECUTE ins_rva USING 
              l_rva.rva00,                                   #FUN-940083 add rva00
              l_rva.rva01, l_rva.rva02 ,l_rva.rva03,l_rva.rva04,l_rva.rva05,
              l_rva.rva06, l_rva.rva07 ,l_rva.rva08,l_rva.rva09,l_rva.rva10,
              l_rva.rvaprsw,l_rva.rva20,l_rva.rva21,l_rva.rva22,l_rva.rva23,
              l_rva.rva24, l_rva.rva25 ,l_rva.rva26,l_rva.rva27,l_rva.rva28,
              l_rva.rva29, l_rva.rva30 ,l_rva.rva31,l_rva.rvacrat,l_rva.rvacond,l_rva.rvaconu,      #No.FUN-A10123
              l_rva.rvaconf,l_rva.rvaprno,l_rva.rvaacti,l_rva.rvauser,l_rva.rvagrup,
              l_rva.rvamodu,l_rva.rvadate,l_rva.rva99,l_plant,l_legal,l_rva.rvaoriu,l_rva.rvaorig   #FUN-980006 add l_plant,l_legal  #TQC-A10060 add oriu,orig
             ,l_rva.rvaud01,l_rva.rvaud02,l_rva.rvaud03,l_rva.rvaud04,l_rva.rvaud05,
              l_rva.rvaud06,l_rva.rvaud07,l_rva.rvaud08,l_rva.rvaud09,l_rva.rvaud10,
              l_rva.rvaud11,l_rva.rvaud12,l_rva.rvaud13,l_rva.rvaud14,l_rva.rvaud15
              #no.4475因為入庫單可能分批入庫所以若分批入庫時，收貨單重拋
    IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
        #LET l_sql="SELECT rvb04 FROM ",l_dbs_tra CLIPPED,"rvb_file ", #FUN-980092
        LET l_sql="SELECT rvb04 FROM ",cl_get_target_table(l_plant_new,'rvb_file'), #FUN-A50102
                  " WHERE rvb01 = '",l_rva.rva01,"'"     
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
        DECLARE sel_rvb04 CURSOR FROM l_sql 
        FOREACH sel_rvb04 INTO l_rvb04
          IF STATUS THEN LET l_pmm901='N' END IF
          EXIT FOREACH #只抓單身的第一筆採購單號來判斷就可
        END FOREACH
        CLOSE sel_rvb04
        #檢查對應之采購單是否為多角貿易(pmm901),若否則show err
        IF NOT cl_null(l_rvb04) THEN #MOD-650049 add if 判斷
            #LET l_sql="SELECT pmm901 FROM ",l_dbs_tra CLIPPED,"pmm_file ", #FUN-980092
            LET l_sql="SELECT pmm901 FROM ",cl_get_target_table(l_plant_new,'pmm_file'), #FUN-A50102
                      " WHERE pmm01 = '",l_rvb04,"'"     #MOD-650049 add
 	        CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
            CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
            DECLARE sel_pmm CURSOR FROM l_sql
            OPEN sel_pmm
            FETCH sel_pmm INTO l_pmm901
            IF STATUS THEN LET l_pmm901='N' END IF
        END IF
        IF l_pmm901!='Y' THEN    #pmm901:多角貿易否
            LET l_buf = l_dbs_new CLIPPED,'+',l_rva.rva01 CLIPPED #MOD-650049 add
           IF g_bgerr THEN
              CALL s_errmsg("pmm901","Y",l_buf,"apm-989",1)   #No.TQC-740094
           ELSE
              CALL cl_err3("","","","","apm-989","",l_buf,1)
           END IF
            LET g_success='N'
            RETURN
        END IF
        CLOSE sel_pmm
 
        #更新收貨單頭檔
        #LET l_sql="UPDATE ",l_dbs_tra CLIPPED,"rva_file", #FUN-980092
        LET l_sql="UPDATE ",cl_get_target_table(l_plant_new,'rva_file'), #FUN-A50102
                  "    SET  rva01 =? ,rva02 =?  ,rva03 =?  ,rva04 =? ,rva05 =?,",
                  " rva06 =? ,rva07 =?  ,rva08 =?  ,rva09 =? ,rva10 =?,",
                  " rvaprsw=?,rva20 =?  ,rva21 =?  ,rva22 =? ,rva23 =?,",
                  " rva24 =? ,rva25 =?  ,rva26 =?  ,rva27 =? ,rva28 =? ,",
                  " rvaconf=?,rvaprno=? ,rvaacti=? ,rvauser=?,rvagrup=?,",
                  " rvamodu=?,rvadate=? ,rva99 =?",
                  "  WHERE rva01=? " 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
        PREPARE upd_rva FROM l_sql
        EXECUTE upd_rva USING
                  l_rva.rva01, l_rva.rva02 ,l_rva.rva03,l_rva.rva04,l_rva.rva05,
                  l_rva.rva06, l_rva.rva07 ,l_rva.rva08,l_rva.rva09,l_rva.rva10,
                  l_rva.rvaprsw,l_rva.rva20,l_rva.rva21,l_rva.rva22,l_rva.rva23,
                  l_rva.rva24, l_rva.rva25 ,l_rva.rva26,l_rva.rva27,l_rva.rva28,
                  l_rva.rvaconf,l_rva.rvaprno,l_rva.rvaacti,l_rva.rvauser,
                  l_rva.rvagrup, 
                  l_rva.rvamodu,l_rva.rvadate,l_rva.rva99,  #以最新的多角序號為主
                  l_rva.rva01
 
        IF SQLCA.sqlcode THEN
           IF g_bgerr THEN
              CALL s_errmsg("rva01",l_rva.rva01,"upd rva:",SQLCA.sqlcode,1)  #No.TQC-740094
           ELSE
              CALL cl_err3("","","","",SQLCA.sqlcode,"","upd rva:",1)
           END IF
            LET g_success = 'N'
        END IF
    ELSE
        IF SQLCA.sqlcode<>0 THEN
           IF g_bgerr THEN
              CALL s_errmsg("","","ins rva:",SQLCA.sqlcode,1)
           ELSE
              CALL cl_err3("","","","",SQLCA.sqlcode,"","ins rva:",1)
           END IF
            LET g_success = 'N'
        END IF
    END IF
END FUNCTION
 
#收貨單身檔
FUNCTION p822_rvbins(p_i)
  DEFINE l_sql   LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(1200)
  DEFINE l_sql1  LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(600)
  DEFINE l_sql2  LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(1600)
  DEFINE p_i     LIKE type_file.num5    #No.FUN-680136 SMALLINT
  DEFINE l_no    LIKE type_file.num5    #No.FUN-680136 SMALLINT
  DEFINE l_price LIKE ogb_file.ogb13
  DEFINE i,l_i   LIKE type_file.num5    #No.FUN-680136 SMALLINT
  DEFINE l_msg   LIKE ze_file.ze03      #No.FUN-680136 VARCHAR(80)
  DEFINE l_chr   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
  DEFINE l_pmm   RECORD LIKE pmm_file.*
  DEFINE l_ima491 LIKE ima_file.ima491
  DEFINE l_ima02  LIKE ima_file.ima02
  DEFINE l_ima25  LIKE ima_file.ima25
#  DEFINE l_qoh    LIKE ima_file.ima262 #FUN-A20044    
  DEFINE l_qoh    LIKE type_file.num15_3 #FUN-A20044    
  DEFINE l_ima39  LIKE ima_file.ima39
  DEFINE l_ima86  LIKE ima_file.ima86
  DEFINE l_ima35  LIKE ima_file.ima35
  DEFINE l_ima36  LIKE ima_file.ima36
  DEFINE l_no1   LIKE type_file.num5,    #No.FUN-680136 SMALLINT
         l_currm LIKE pmm_file.pmm42,
         x_currm LIKE pmm_file.pmm42,
         l_curr  LIKE pmm_file.pmm22     #No.FUN-680136 VARCHAR(04)
  DEFINE l_rvbi  RECORD LIKE rvbi_file.* #No.FUN-7B0018
  DEFINE l_sma90 LIKE sma_file.sma90  #No.FUN-850100
  DEFINE l_plant  LIKE azp_file.azp01    #FUN-980006 add
  DEFINE l_legal  LIKE oga_file.ogalegal #FUN-980006 add
  DEFINE l_pmn07  LIKE pmn_file.pmn07     #FUN-B90012 
  DEFINE l_flag   LIKE type_file.chr1     #FUN-B90012
  DEFINE l_rvbiicd08 LIKE rvbi_file.rvbiicd08  #FUN-B90012
  DEFINE l_rvbiicd16 LIKE rvbi_file.rvbiicd16  #FUN-B90012
  #DEFINE l_imaicd08  LIKE imaicd_file.imaicd08 #FUN-B90012 #FUN-BA0051 mark
  DEFINE l_idd       RECORD LIKE idd_file.*    #FUN-B90012
 
  LET l_plant = g_poy.poy04  #FUN-980006 add 
  CALL s_getlegal(l_plant) RETURNING l_legal  #FUN-980006 add
     
     #讀取采購單頭檔(pmm_file)
     LET l_sql1 = "SELECT * ",
                  #" FROM ",l_dbs_tra CLIPPED,"pmm_file ",   #FUN-980092
                  " FROM ",cl_get_target_table(l_plant_new,'pmm_file'), #FUN-A50102
                  " WHERE pmm99='",g_pmm.pmm99,"' " 
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
         CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-980092
     PREPARE pmm_p1 FROM l_sql1
     IF STATUS THEN
        IF g_bgerr THEN
           CALL s_errmsg("pmm99",g_pmm.pmm99,"pmm_p1",STATUS,1)  #No.TQC-740094
        ELSE
           CALL cl_err3("","","","",STATUS,"","pmm_p1",1)
        END IF
     END IF
     DECLARE pmm_c1 CURSOR FOR pmm_p1
     OPEN pmm_c1
     FETCH pmm_c1 INTO l_pmm.*
     IF SQLCA.SQLCODE <> 0 THEN
        IF g_bgerr THEN
           CALL s_errmsg("pmm99",g_pmm.pmm99,l_dbs_new,"aap-006",1)  #No.TQC-740094
        ELSE
           CALL cl_err3("","","","","l_dbs_new","",l_dbs_new,1)
        END IF
        LET g_success='N'
        RETURN
     END IF
     CLOSE pmm_c1
     #讀取采購單身檔(pmn_file)
     LET l_sql1 = "SELECT * ",
                  #"  FROM ",l_dbs_tra CLIPPED,"pmn_file ",  #FUN-980092
                  "  FROM ",cl_get_target_table(l_plant_new,'pmn_file'), #FUN-A50102
                  " WHERE pmn01='",l_pmm.pmm01,"' " ,
                  "   AND pmn02 =",g_rvv.rvv37
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-A50102
     PREPARE pmn_p1 FROM l_sql1
     IF STATUS THEN 
        IF g_bgerr THEN
           LET g_showmsg=l_pmm.pmm01,"/",g_rvv.rvv37
           CALL s_errmsg("pmn01,pmn02",g_showmsg,"pmm_p1",STATUS,1)  #No.TQC-740094
        ELSE
           CALL cl_err('pmn_p1',STATUS,1)
        END IF
     END IF
     DECLARE pmn_c1 CURSOR FOR pmn_p1
     OPEN pmn_c1
     FETCH pmn_c1 INTO g_pmn.*
     IF SQLCA.SQLCODE <> 0 THEN
        IF g_bgerr THEN
           LET g_showmsg=l_pmm.pmm01,"/",g_rvv.rvv37  #No.TQC-740094
           CALL s_errmsg("pmn01,pmn02",g_showmsg,l_dbs_new,"aap-006",1)  #No.TQC-740094
        ELSE
           CALL cl_err3("","","","","aap-006","",l_dbs_new,1)
        END IF
        LET g_success='N'
        RETURN
     END IF
     CLOSE pmn_c1
     #抓取收貨單身檔
     SELECT * INTO g_rvb.* FROM rvb_file
       WHERE rvb01 = g_rvv.rvv04 AND rvb02 = g_rvv.rvv05
     #新增收貨單身檔[rvb_file]
     LET l_rvb.rvb01 = l_rva.rva01      #驗收單身檔
     LET l_rvb.rvb02 = g_rvb.rvb02      #驗收單項次
     LET l_rvb.rvb03 = g_rvb.rvb03      #采購單項次
     LET l_rvb.rvb04 = l_pmm.pmm01      #采購單號
     LET l_rvb.rvb05 = g_rvb.rvb05      #料件編號
     LET l_rvb.rvb06 = 0                #已請款量
     LET l_rvb.rvb07 = g_rvb.rvb07      #實收數量
     LET l_rvb.rvb08 = g_rvb.rvb08      #收貨數量
     LET l_rvb.rvb09 = 0                #允請款量
     LET l_rvb.rvbud01 = g_rvb.rvbud01
     LET l_rvb.rvbud02 = g_rvb.rvbud02
     LET l_rvb.rvbud03 = g_rvb.rvbud03
     LET l_rvb.rvbud04 = g_rvb.rvbud04
     LET l_rvb.rvbud05 = g_rvb.rvbud05
     LET l_rvb.rvbud06 = g_rvb.rvbud06
     LET l_rvb.rvbud07 = g_rvb.rvbud07
     LET l_rvb.rvbud08 = g_rvb.rvbud08
     LET l_rvb.rvbud09 = g_rvb.rvbud09
     LET l_rvb.rvbud10 = g_rvb.rvbud10
     LET l_rvb.rvbud11 = g_rvb.rvbud11
     LET l_rvb.rvbud12 = g_rvb.rvbud12
     LET l_rvb.rvbud13 = g_rvb.rvbud13
     LET l_rvb.rvbud14 = g_rvb.rvbud14
     LET l_rvb.rvbud15 = g_rvb.rvbud15
     LET l_rvb.rvb90   = g_pmn.pmn07    #MOD-B30584 add
     CALL p822_azi(l_pmm.pmm22)         #No.7902
     IF g_pod.pod03 = 'N' OR g_aza.aza50='Y' THEN    #No.FUN-620025          
        LET l_rvb.rvb10 = g_pmn.pmn31      #原幣單價
     ELSE
        #出貨必須重新計算價格, 因為分批出貨時, 有可能計價方式亦改變了
        #依計價方式來判斷價格
              CASE p_pox05
                 WHEN '1'
                    IF p_pox03='1' THEN   #依來源工廠 
                       #單價*比率
                       IF g_pmm.pmm22 = l_pmm.pmm22 THEN
                          LET l_rvb.rvb10 = g_rvv.rvv38 * p_pox06 /100
                       END IF
                       IF g_pmm.pmm22 <> l_pmm.pmm22 THEN  
                          LET l_price = g_rvv.rvv38 * g_pmm.pmm42 #先換算本幣
                          #依計價幣別抓來源工廠的匯率  no:3463
                          CALL s_currm(l_pmm.pmm22,g_rvu.rvu03, 
                                       g_pod.pod01,t_plant)      #FUN-980020
                               RETURNING l_currm
                          LET l_rvb.rvb10= l_price/l_currm * p_pox06/100  
                       END IF
                    ELSE
                       #依上游廠商計算, 先讀取S/O價格
                       IF p_i=1 THEN
                         #單價*比率
                         IF g_pmm.pmm22 = l_pmm.pmm22 THEN
                            LET l_rvb.rvb10 = g_rvv.rvv38 * p_pox06 /100
                         END IF
                         IF g_pmm.pmm22 <> l_pmm.pmm22 THEN  
                            LET l_price = g_rvv.rvv38 * g_pmm.pmm42 #先換算本幣
                            #依計價幣別抓來源工廠的匯率  no:3463
                            CALL s_currm(l_pmm.pmm22,g_rvu.rvu03,
                                         g_pod.pod01,t_plant)       #FUN-980020
                                  RETURNING l_currm
                            LET l_rvb.rvb10= l_price/l_currm * p_pox06/100  
                         END IF
                       ELSE
                          LET l_no = p_i-1
                          SELECT po_price,po_curr INTO l_price,l_curr
                            FROM p822_file
                           WHERE p_no = l_no
                             AND po_no = l_rvb.rvb01
                             AND po_item=l_rvb.rvb02
                          IF l_curr != l_pmm.pmm22 THEN
                             CALL s_currm(l_curr,l_pmm.pmm22,
                                          g_pod.pod01,t_plant)     #FUN-980020 
                              RETURNING x_currm
                             LET l_price = l_price * x_currm   #換算成本幣
                             #依計價幣別抓來源廠的匯率 no:3463
                             CALL s_currm(l_pmm.pmm22,g_rvu.rvu03,
                                          g_pod.pod01,t_plant)     #FUN-980020
                              RETURNING l_currm
                             LET l_rvb.rvb10 = l_price / l_currm * p_pox06/100
                          ELSE
                             #單價*比率
                             LET l_rvb.rvb10= l_price * p_pox06/100
                          END IF
                        END IF  
                    END IF
                    CALL cl_digcut(l_rvb.rvb10,l_azi.azi03) 
                          RETURNING l_rvb.rvb10
                 WHEN '2'
                    #讀取合乎料件條件之價格
                    CALL s_pow(g_pmm.pmm904,l_rvb.rvb05,p_poy04,g_rvu.rvu03)
                           RETURNING g_sw,l_rvb.rvb10
                     IF g_sw='N' THEN
                        IF g_bgerr THEN
                           CALL s_errmsg("","","sel poc:","axm-333",1)
                        ELSE
                           CALL cl_err3("","","","","axm-333","","sel poc:",1)
                        END IF
                       LET g_success = 'N'
                     END IF
                 WHEN '3'   #單價若為0, 則給0, 否則抓料件之固定價格
                     IF g_rvv.rvv38 <> 0 THEN     #no.6215
                        CALL s_pow(g_pmm.pmm904,l_rvb.rvb05,p_poy04,g_rvu.rvu03)
                           RETURNING g_sw,l_rvb.rvb10
                        IF g_sw='N' THEN
                           IF g_bgerr THEN
                              CALL s_errmsg("","","sel poc:","axm-333",1)
                           ELSE
                              CALL cl_err3("","","","","axm-333","","sel poc:",1)
                           END IF
                          LET g_success = 'N'
                        END IF
                     ELSE
                        LET l_rvb.rvb10 = 0
                     END IF
              END CASE
              IF l_rvb.rvb10 IS NULL THEN LET l_rvb.rvb10 =0 END IF
     END IF
     IF l_pmm.pmm43>0 THEN
        LET l_rvb.rvb10t=l_rvb.rvb10*(1+l_pmm.pmm43/100)
     ELSE 
        IF l_pmm.pmm43=0 THEN
           LET l_rvb.rvb10t=l_rvb.rvb10
        END IF
     END IF
     CALL cl_digcut(l_rvb.rvb10t,l_azi.azi03) RETURNING l_rvb.rvb10t #MOD-720052 add
     LET l_rvb.rvb11 = 0
     SELECT ima491 INTO l_ima491 FROM ima_file
      WHERE ima01 = l_rvb.rvb05
     IF cl_null(l_ima491) THEN LET l_ima491 = 0 END IF
     LET l_rvb.rvb13 = NULL
     LET l_rvb.rvb14 = NULL
     LET l_rvb.rvb15 = 0
     LET l_rvb.rvb16 = 0 
     LET l_rvb.rvb17 = NULL
     LET l_rvb.rvb18 = '30'
     LET l_rvb.rvb19 = '1'
     LET l_rvb.rvb20 = NULL
     LET l_rvb.rvb21 = NULL
     LET l_rvb.rvb27 = 0 
     LET l_rvb.rvb28 = 0 
     LET l_rvb.rvb29 = g_rvb.rvb29
     LET l_rvb.rvb30 = g_rvb.rvb30
     LET l_rvb.rvb31 = g_rvb.rvb31
     LET l_rvb.rvb35 = g_rvb.rvb35  #No.9421
 
     CALL p822_ima(l_rvb.rvb05)
       RETURNING l_ima02,l_ima25,l_qoh,l_ima86,l_ima39,
                 l_ima35,l_ima36
     IF NOT cl_null(p_imd01) THEN
        #CALL p822_imd(p_imd01,l_dbs_new)
        CALL p822_imd(p_imd01,l_dbs_new,l_plant_new)  #FUN-A50102
        LET l_rvb.rvb36 = p_imd01
        LET l_rvb.rvb37 = ' '
        LET l_rvb.rvb38 = ' '
     ELSE
       IF cl_null(l_ima35) THEN
          LET l_rvb.rvb36 = g_rvv.rvv32
          LET l_rvb.rvb37 = g_rvv.rvv33
          LET l_rvb.rvb38 = g_rvv.rvv34
       ELSE
          LET l_rvb.rvb36 = l_ima35
          LET l_rvb.rvb37 = l_ima36
          LET l_rvb.rvb38 = ' '
       END IF
     END IF
    #IF g_sma.sma96 = 'Y' THEN         #FUN-C80001 #FUN-D30099 mark
     IF g_pod.pod08 = 'Y' THEN         #FUN-D30099
        LET l_rvb.rvb38 = g_rvv.rvv34  #FUN-C80001
     END IF                            #FUN-C80001
     IF cl_null(l_rvb.rvb38) THEN LET l_rvb.rvb38 = ' ' END IF
 
     LET l_rvb.rvb39 = 'N'   #免驗
     LET l_rvb.rvb40 = NULL
     LET l_rvb.rvb41 = NULL
     LET l_rvb.rvb80 = g_rvb.rvb80
     LET l_rvb.rvb81 = g_rvb.rvb81
     LET l_rvb.rvb82 = g_rvb.rvb82
     LET l_rvb.rvb83 = g_rvb.rvb83
     LET l_rvb.rvb84 = g_rvb.rvb84
     LET l_rvb.rvb85 = g_rvb.rvb85
     LET l_rvb.rvb86 = g_rvb.rvb86
     LET l_rvb.rvb87 = g_rvb.rvb87
     LET l_rvb.rvb930 = g_pmn.pmn930  #NO.FUN-670007 採購成本中心
 
     LET l_rvb.rvb88=l_rvb.rvb87*l_rvb.rvb10
     LET l_rvb.rvb88t=l_rvb.rvb87*l_rvb.rvb10t
     LET l_rvb.rvb89 = 'N'              #FUN-940083
     #No.FUN-A10123 ..begin
     IF g_azw.azw04 = '2' THEN
        LET l_rvb.rvb42 = g_pmn.pmn73
        LET l_rvb.rvb43 = g_pmn.pmn74
        LET l_rvb.rvb44 = g_pmn.pmn75
        LET l_rvb.rvb45 = g_pmn.pmn76
     END IF
     IF cl_null(l_rvb.rvb42) THEN LET l_rvb.rvb42 = '4' END IF
     #No.FUN-A10123 ..end

    #MOD-D10029 add start -----
     IF g_rvv.rvv31[1,4] = 'MISC' THEN
        LET l_rvb.rvb051 = g_rvv.rvv031
     END IF
    #MOD-D10029 add end   -----
 
     #新增出貨單身檔
     #LET l_sql2="INSERT INTO ",l_dbs_tra CLIPPED,"rvb_file",  #FUN-980092
     LET l_sql2="INSERT INTO ",cl_get_target_table(l_plant_new,'rvb_file'), #FUN-A50102
                "(rvb01,rvb02,rvb03,rvb04,rvb05, ",
                " rvb06,rvb07,rvb08,rvb09,rvb10, ",
                " rvb10t,rvb11,rvb12,rvb13,rvb14,",                     #No.FUN-620025               
                " rvb15,rvb16,rvb17,rvb18,rvb19, ",
                " rvb20,rvb21,rvb22,rvb25,rvb26, ",
                " rvb27,rvb28,rvb29,rvb30,rvb31, ",
                " rvb32,rvb33,rvb34,rvb35,rvb36, ",
                " rvb37,rvb38,rvb39,rvb40,rvb41, ",
                " rvb42,rvb43,rvb44,rvb45,rvb051, ",  #No.FUN-A10123  #MOD-D10029 add rvb051,
                " rvb80,rvb81,rvb82,rvb83,rvb84, ",   #FUN-560043
                " rvb85,rvb86,rvb87,rvb88,rvb88t,",   #FUN-560043
                " rvb89,rvb90,rvb930,rvbplant,rvblegal,",           #CHI-9B0008  #MOD-B30584 add rvb90
                " rvbud01,rvbud02,rvbud03,rvbud04,rvbud05,",
                " rvbud06,rvbud07,rvbud08,rvbud09,rvbud10,",
                " rvbud11,rvbud12,rvbud13,rvbud14,rvbud15)",
                " VALUES( ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,",
                "         ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,",
                "         ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,",    #No.CHI-950020
                "         ?,?,?,?,                          ",    #No.FUN-A10123
                "         ?,?,?,?,?,  ?,?,?,?,    ?,?,?,?,?,",    #CHI-9B0008
                "         ?,?,?,?,?,  ?,?,?,?,?,  ?,? ) "         #FUN-560043 #No.FUN-620025  #No.TQC-6A0084 #FUN-940083 add ? 
                                                                  #FUN-980006 add ?,? #MOD-B30584 add ?  #MOD-D10029 add ,?

 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
     PREPARE ins_rvb FROM l_sql2
     EXECUTE ins_rvb USING 
                l_rvb.rvb01,l_rvb.rvb02,l_rvb.rvb03,l_rvb.rvb04,l_rvb.rvb05,
                l_rvb.rvb06,l_rvb.rvb07,l_rvb.rvb08,l_rvb.rvb09,l_rvb.rvb10,
                l_rvb.rvb10t,l_rvb.rvb11,l_rvb.rvb12,l_rvb.rvb13,l_rvb.rvb14,                     #No.FUN-620025
                l_rvb.rvb15,l_rvb.rvb16,l_rvb.rvb17,l_rvb.rvb18,l_rvb.rvb19,
                l_rvb.rvb20,l_rvb.rvb21,l_rvb.rvb22,l_rvb.rvb25,l_rvb.rvb26,
                l_rvb.rvb27,l_rvb.rvb28,l_rvb.rvb29,l_rvb.rvb30,l_rvb.rvb31,
                l_rvb.rvb32,l_rvb.rvb33,l_rvb.rvb34,l_rvb.rvb35,l_rvb.rvb36,
                l_rvb.rvb37,l_rvb.rvb38,l_rvb.rvb39,l_rvb.rvb40,l_rvb.rvb41,
                l_rvb.rvb42,l_rvb.rvb43,l_rvb.rvb44,l_rvb.rvb45,l_rvb.rvb051,   #No.FUN-A10123 #MOD-D10029 add l_rvb.rvb051,
                l_rvb.rvb80,l_rvb.rvb81,l_rvb.rvb82,l_rvb.rvb83,l_rvb.rvb84,    #FUN-560043
                l_rvb.rvb85,l_rvb.rvb86,l_rvb.rvb87,l_rvb.rvb88,l_rvb.rvb88t,   #FUN-560043  #No.TQC-6A0084 
                l_rvb.rvb89,l_rvb.rvb90,l_rvb.rvb930,l_plant,l_legal,     #FUN-940083 add rvb89 #FUN-980006 add l_plant,l_legal #CHI-9B0008 #MOD-B30584 add rvb90
                l_rvb.rvbud01,l_rvb.rvbud02,l_rvb.rvbud03,l_rvb.rvbud04,l_rvb.rvbud05,
                l_rvb.rvbud06,l_rvb.rvbud07,l_rvb.rvbud08,l_rvb.rvbud09,l_rvb.rvbud10,
                l_rvb.rvbud11,l_rvb.rvbud12,l_rvb.rvbud13,l_rvb.rvbud14,l_rvb.rvbud15
     #因為入庫單可能分批入庫所以若分批入庫時，收貨單重拋
     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN 
        #FUN-B90012--mark--start--
        #IF NOT s_industry('std') THEN
        #   INITIALIZE l_rvbi.* TO NULL
        #   LET l_rvbi.rvbi01 = l_rvb.rvb01
        #   LET l_rvbi.rvbi02 = l_rvb.rvb02
        #   IF NOT s_ins_rvbi(l_rvbi.*,l_plant_new) THEN  #FUN-980092
        #      LET g_success = 'N'
        #   END IF
        #END IF
        #FUN-B90012--mark---end---

 
         #更新出貨單身檔
          #LET l_sql2="UPDATE ",l_dbs_tra CLIPPED,"rvb_file",
          LET l_sql2="UPDATE ",cl_get_target_table(l_plant_new,'rvb_file'), #FUN-A50102
               "    SET  rvb01=?,rvb02=?,rvb03=?,rvb04=?,rvb05=?, ",
                     "   rvb06=?,rvb07=?,rvb08=?,rvb09=?,rvb10=?, ",
                     "   rvb11=?,rvb12=?,rvb13=?,rvb14=?,rvb15=?, ",
                     "   rvb16=?,rvb17=?,rvb18=?,rvb19=?,rvb20=?, ",
                     "   rvb21=?,rvb22=?,rvb25=?,rvb26=?,rvb27=?, ",
                     "   rvb28=?,rvb29=?,rvb30=?,rvb31=?,rvb32=?, ",
                     "   rvb33=?,rvb34=?,rvb35=?,rvb36=?,rvb37=?, ",
                     "   rvb38=?,rvb39=?,rvb40=?,rvb41=?,rvb80=?, ",   #FUN-560043
                     "   rvb81=?,rvb82=?,rvb83=?,rvb84=?,rvb85=?, ",   #FUN-560043
                     "   rvb86=?,rvb87=?,rvb88=?,rvb88t=?,rvb930=?, ",  #FUN-560043  #No:TQC-6A0084 #CHI-9B0008
                     "   rvbud01=?,rvbud02=?,rvbud03=?,rvbud04=?,rvbud05=?,",
                     "   rvbud06=?,rvbud07=?,rvbud08=?,rvbud09=?,rvbud10=?,",
                     "   rvbud11=?,rvbud12=?,rvbud13=?,rvbud14=?,rvbud15=?",
                     "  WHERE rvb01=? AND rvb02=? " 
 	  CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
      CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
          PREPARE upd_rvb FROM l_sql2
          EXECUTE upd_rvb USING 
                     l_rvb.rvb01,l_rvb.rvb02,l_rvb.rvb03,l_rvb.rvb04,l_rvb.rvb05,
                     l_rvb.rvb06,l_rvb.rvb07,l_rvb.rvb08,l_rvb.rvb09,l_rvb.rvb10,
                     l_rvb.rvb11,l_rvb.rvb12,l_rvb.rvb13,l_rvb.rvb14,l_rvb.rvb15,
                     l_rvb.rvb16,l_rvb.rvb17,l_rvb.rvb18,l_rvb.rvb19,l_rvb.rvb20,
                     l_rvb.rvb21,l_rvb.rvb22,l_rvb.rvb25,l_rvb.rvb26,l_rvb.rvb27,
                     l_rvb.rvb28,l_rvb.rvb29,l_rvb.rvb30,l_rvb.rvb31,l_rvb.rvb32,
                     l_rvb.rvb33,l_rvb.rvb34,l_rvb.rvb35,l_rvb.rvb36,l_rvb.rvb37,
                     l_rvb.rvb38,l_rvb.rvb39,l_rvb.rvb40,l_rvb.rvb41,l_rvb.rvb80,   #FUN-560043
                     l_rvb.rvb81,l_rvb.rvb82,l_rvb.rvb83,l_rvb.rvb84,l_rvb.rvb85,   #FUN-560043
                     l_rvb.rvb86,l_rvb.rvb87,l_rvb.rvb88,l_rvb.rvb88t,l_rvb.rvb930, #FUN-560043  #No:TQC-6A0084  #CHI-9B0008
                     l_rvb.rvbud01,l_rvb.rvbud02,l_rvb.rvbud03,l_rvb.rvbud04,l_rvb.rvbud05,
                     l_rvb.rvbud06,l_rvb.rvbud07,l_rvb.rvbud08,l_rvb.rvbud09,l_rvb.rvbud10,
                     l_rvb.rvbud11,l_rvb.rvbud12,l_rvb.rvbud13,l_rvb.rvbud14,l_rvb.rvbud15,
                     l_rvb.rvb01,l_rvb.rvb02
          IF SQLCA.sqlcode THEN
             LET g_showmsg = l_rvb.rvb01,"/",l_rvb.rvb02  #No.TQC-740094
             IF g_bgerr THEN
                CALL s_errmsg("rvb01,rvb02",g_showmsg,"upd rvb:",SQLCA.sqlcode,1)  #No.TQC-740094
             ELSE
                CALL cl_err3("","","","",SQLCA.sqlcode,"","upd rvb:",1)
             END IF
              LET g_success = 'N'
          END IF
     ELSE
          IF SQLCA.sqlcode<>0 THEN
             IF g_bgerr THEN
                CALL s_errmsg("","","ins rvb:",SQLCA.sqlcode,1)
             ELSE
                CALL cl_err3("","","","",SQLCA.sqlcode,"","ins rvb:",1)
             END IF
             LET g_success = 'N'
          #FUN-B90012--add--strat--
          ELSE
             IF NOT s_industry('std') THEN
                INITIALIZE l_rvbi.* TO NULL
                LET l_rvbi.rvbi01 = l_rvb.rvb01
                LET l_rvbi.rvbi02 = l_rvb.rvb02
                IF NOT s_ins_rvbi(l_rvbi.*,l_plant_new) THEN  
                   LET g_success = 'N'
                END IF
             END IF
          #FUN-B90012--add---end---
          END IF
     END IF
 
     #LET l_sql2 = "SELECT ima918,ima921 FROM ",l_dbs_new CLIPPED,"ima_file",
     LET l_sql2 = "SELECT ima918,ima921 FROM ",cl_get_target_table(l_plant_new,'ima_file'), #FUN-A50102
                  " WHERE ima01 = '",l_rvb.rvb05,"'",
                  "   AND imaacti = 'Y'"
     
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
     PREPARE ima_rvb FROM l_sql2
     
     EXECUTE ima_rvb INTO g_ima918,g_ima921                                                                             
     
     #LET l_sql2 = "SELECT sma90 FROM ",l_dbs_new CLIPPED,"sma_file",
     LET l_sql2 = "SELECT sma90 FROM ",cl_get_target_table(l_plant_new,'sma_file'), #FUN-A50102
                  " WHERE sma00 = '0'"
     
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
     PREPARE sma_rvb FROM l_sql2
     
     EXECUTE sma_rvb INTO l_sma90
     
     IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
        IF l_sma90 = "Y" THEN
        
           FOREACH p822_g_rvbs INTO l_rvbs.*
              IF STATUS THEN
                 CALL cl_err('rvbs',STATUS,1)
              END IF
     
              LET l_rvbs.rvbs00 = "apmt300"
           
              LET l_rvbs.rvbs01 = l_rvb.rvb01
           
              #LET l_rvbs.rvbs06 = l_rvbs.rvbs06 * l_ogb.ogb05_fac   #MOD-A90100
              LET l_rvbs.rvbs06 = l_rvbs.rvbs06   #MOD-A90100
        
              IF cl_null(l_rvbs.rvbs06) THEN
                 LET l_rvbs.rvbs06 = 0
              END IF
     
              LET l_rvbs.rvbs09 = 1
              LET l_rvbs.rvbs13 = 0    #MOD-940294
 
              #新增批/序號資料檔
              EXECUTE ins_rvbs USING l_rvbs.rvbs00,l_rvbs.rvbs01,l_rvbs.rvbs02,
                                     l_rvbs.rvbs021,l_rvbs.rvbs022,l_rvbs.rvbs03,
                                     l_rvbs.rvbs04,l_rvbs.rvbs05,l_rvbs.rvbs06,
                                     l_rvbs.rvbs07,l_rvbs.rvbs08,l_rvbs.rvbs09, 
                                     l_rvbs.rvbs13,l_plant,l_legal    #MOD-940294   #MOD-CB0055 add ,l_plant,l_legal
        
              IF STATUS OR SQLCA.SQLCODE THEN
                 LET g_showmsg = l_rvbs.rvbs01,"/",l_rvbs.rvbs03
                 CALL s_errmsg('rvbs01,rvbs03',g_showmsg,'ins rvbs:',SQLCA.sqlcode,1) 
                 LET g_success='N'
              END IF
           
              CALL p822_imgs(l_rvb.rvb36,l_rvb.rvb37,l_rvb.rvb38,l_rva.rva06,l_rvbs.*)	#MOD-980058
     
           END FOREACH
        END IF
     END IF

     #FUN-B90012----add----str----
     IF s_industry('icd') THEN 
        #FUN-BA0051 --START mark-- 
        #LET l_sql2 = "SELECT imaicd08 FROM ",cl_get_target_table(l_plant_new,'ima_file'),",",
        #                                     cl_get_target_table(l_plant_new,'imaicd_file'),
        #             " WHERE imaicd00 = '",l_rvb.rvb05,"' ",
        #             "   AND ima01 = imaicd00 ",
        #             "   AND imaacti = 'Y' "
        #CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
        #CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2
        #PREPARE imaicd_rvb FROM l_sql2
        #EXECUTE imaicd_rvb INTO l_imaicd08
        # 
        #IF l_imaicd08 = 'Y' THEN
        #FUN-BA0051 --END mark--
        IF s_icdbin_multi(l_rvb.rvb05,l_plant_new) THEN   #FUN-BA0051  
           FOREACH p822_idd INTO l_idd.* 
              IF STATUS THEN
                 CALL cl_err('ida',STATUS,1)
              END IF
              LET l_idd.idd10 = l_rvb.rvb01
              LET l_idd.idd11 = l_rvb.rvb02
           #CHI-C80009---add---START 
              LET l_idd.idd02 = l_rvb.rvb36
              LET l_idd.idd03 = l_rvb.rvb37
              LET l_idd.idd04 = l_rvb.rvb38
           #CHI-C80009---add-----END
              CALL icd_ida(1,l_idd.*,l_plant_new)
           END FOREACH
        END IF

        LET l_sql2 = "SELECT pmn07 FROM ",cl_get_target_table(l_plant_new,'pmn_file'),
                     " WHERE pmn01 = '",l_rvb.rvb04,"' ",
                     "   AND pmn02 = '",l_rvb.rvb03,"' "
        CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
        CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2
        PREPARE pmn07_pmn_1 FROM l_sql2
        EXECUTE pmn07_pmn_1 INTO l_pmn07
        
        LET l_sql2 = "SELECT rvbiicd08,rvbiicd16 FROM ",cl_get_target_table(l_plant_new,'rvbi_file'),
                     " WHERE rvbi01 = '",l_rvb.rvb01,"' ",
                     "   AND rvbi02 = '",l_rvb.rvb02,"' "
        CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
        CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2
        PREPARE rvbicd_rvb_1 FROM l_sql2
        EXECUTE rvbicd_rvb_1 INTO l_rvbiicd08,l_rvbiicd16
           
        CALL s_icdpost(13,l_rvb.rvb05,l_rvb.rvb36,l_rvb.rvb37,l_rvb.rvb38,
                           l_pmn07,l_rvb.rvb07,l_rvb.rvb01,l_rvb.rvb02,
                           l_rva.rva06,'Y','','',l_rvbiicd16,l_rvbiicd08,l_plant_new) 
                 RETURNING l_flag 
        IF l_flag = 0 THEN
           LET g_success = 'N'
        END IF
     END IF
     #FUN-B90012----add----end----
 
     #新增至暫存檔中 no.6234
     INSERT INTO p822_file VALUES(p_i,l_rvb.rvb01,l_rvb.rvb02,
                                  l_rvb.rvb10,l_pmm.pmm22)
     IF SQLCA.sqlcode<>0 THEN
        IF g_bgerr THEN
           LET g_showmsg = p_i,"/",l_rvb.rvb01
           CALL s_errmsg("p_no,po_no",g_showmsg,"ins p822_file:",SQLCA.sqlcode,1)
        ELSE
           CALL cl_err3("ins","p822_file",p_i,l_rvb.rvb01,SQLCA.sqlcode,"","ins p822_file:",1)
        END IF
         LET g_success = 'N'
     END IF
END FUNCTION
 
FUNCTION p822_rvuins()
  DEFINE l_sql  LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(1200)
  DEFINE l_sql1  LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(600)
  DEFINE l_sql2  LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(1600)
  DEFINE i,l_i    LIKE type_file.num5    #No.FUN-680136 SMALLINT
  DEFINE li_result LIKE type_file.num5    #FUN-560043  #No.FUN-680136 SMALLINT
  DEFINE l_x       LIKE oay_file.oayslip  #FUN-670007
  DEFINE l_plant  LIKE azp_file.azp01    #FUN-980006 add
  DEFINE l_legal  LIKE oga_file.ogalegal #FUN-980006 add
 
  LET l_plant = g_poy.poy04  #FUN-980006 add 
  CALL s_getlegal(l_plant) RETURNING l_legal  #FUN-980006 add
 
  #新增入庫單單頭檔(rvu_file)
    LET l_rvu.rvu00 = '1'                #異動別
        CALL s_auto_assign_no('apm',rvu_t1,g_rvu.rvu03,"","","",l_plant_new,"","") #FUN-980092
          RETURNING li_result,l_rvu.rvu01
        IF (NOT li_result) THEN 
           LET g_msg = l_plant_new CLIPPED,l_rvu.rvu01
           CALL s_errmsg("rvu01",l_rvu.rvu01,g_msg CLIPPED,"mfg3046",1) 
           LET g_success ='N'
           RETURN
        END IF   
    LET l_rvu.rvu02 = l_rva.rva01        #驗收單號 #No.FUN-620025
    LET l_rvu.rvu03 = g_rvu.rvu03        #異動日期
    LET l_rvu.rvuud01 = g_rvu.rvuud01
    LET l_rvu.rvuud02 = g_rvu.rvuud02
    LET l_rvu.rvuud03 = g_rvu.rvuud03
    LET l_rvu.rvuud04 = g_rvu.rvuud04
    LET l_rvu.rvuud05 = g_rvu.rvuud05
    LET l_rvu.rvuud06 = g_rvu.rvuud06
    LET l_rvu.rvuud07 = g_rvu.rvuud07
    LET l_rvu.rvuud08 = g_rvu.rvuud08
    LET l_rvu.rvuud09 = g_rvu.rvuud09
    LET l_rvu.rvuud10 = g_rvu.rvuud10
    LET l_rvu.rvuud11 = g_rvu.rvuud11
    LET l_rvu.rvuud12 = g_rvu.rvuud12
    LET l_rvu.rvuud13 = g_rvu.rvuud13
    LET l_rvu.rvuud14 = g_rvu.rvuud14
    LET l_rvu.rvuud15 = g_rvu.rvuud15
    #LET l_sql = " SELECT pmm09 ",
    LET l_sql = " SELECT pmm09,pmm51,pmm52,pmm53 ",        #No.FUN-A10123
 	       #"   FROM ",l_dbs_new CLIPPED,"pmm_file ",
                #"   FROM ",l_dbs_tra CLIPPED,"pmm_file ",  #FUN-980092
                "   FROM ",cl_get_target_table(l_plant_new,'pmm_file'), #FUN-A50102
                "  WHERE pmm99 = '",g_pmm.pmm99,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
    PREPARE pmm_prepare2 FROM l_sql
    DECLARE pmm_curs2 CURSOR FOR pmm_prepare2
    OPEN pmm_curs2
    FETCH pmm_curs2 INTO l_rvu.rvu04,l_rvu.rvu21,l_rvu.rvu22,l_rvu.rvu23    #供應廠商   #No.FUN-A10123
    IF SQLCA.sqlcode THEN 
       IF g_bgerr THEN
          CALL s_errmsg("pmm99",g_pmm.pmm99,"fetch pmm_curs2",SQLCA.sqlcode,1)  #No.TQC-740094
       ELSE
          CALL cl_err3("","","","",SQLCA.sqlcode,"","fetch pmm_curs2",1)
       END IF
       LET l_rva.rva05 = ''
       LET g_success = 'N'
    END IF
    CLOSE pmm_curs2
    LET l_sql = " SELECT pmc03 ",
 		        #"   FROM ",l_dbs_new CLIPPED,"pmc_file ",
                "   FROM ",cl_get_target_table(l_plant_new,'pmc_file'), #FUN-A50102
                "  WHERE pmc01 = '",l_rvu.rvu04,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
    PREPARE pmc_prepare2 FROM l_sql
    DECLARE pmc_curs2 CURSOR FOR pmc_prepare2
    OPEN pmc_curs2
    FETCH pmc_curs2 INTO l_rvu.rvu05     #供應廠商簡稱
    LET l_rvu.rvu06 = g_pmm.pmm13        #采購部門
    LET l_rvu.rvu07 = g_pmm.pmm15        #人員
    LET l_rvu.rvu08 = g_pmm.pmm02        #采購性質
    LET l_rvu.rvu09 = null
    LET l_rvu.rvu11 = null
    LET l_rvu.rvu12 = null
    LET l_rvu.rvu20 = 'Y'
    LET l_rvu.rvu99 = g_flow99           #No.8106
    LET l_rvu.rvuconf= 'Y'
    LET l_rvu.rvuacti= 'Y'
    LET l_rvu.rvuuser= g_user
    LET l_rvu.rvugrup= g_grup
    LET l_rvu.rvuoriu= g_user   #TQC-A10060  add
    LET l_rvu.rvuorig= g_grup   #TQC-A10060  add
    LET l_rvu.rvumodu= null
    LET l_rvu.rvudate= null
    #No.FUN-A10123 ...begin
    IF g_azw.azw04 = '2' THEN
    #  LET l_rvu.rvucrat = g_today     #TQC-A60075
    #  LET l_rvu.rvucond = g_today     #TQC-A60075
    #  LET l_rvu.rvucont = TIME        #TQC-A60075
       LET l_rvu.rvuconu = g_user
      #LET l_rvu.rvumksg = 'N'         #FUN-AB0023 mark
       LET l_rvu.rvu900 = '0'
       LET l_rvu.rvupos = 'N'
    END IF
    LET l_rvu.rvu17  = '1'            #簽核狀況:1.已核准  #FUN-AB0023 add
    LET l_rvu.rvumksg= 'N'            #是否簽核           #FUN-AB0023 add
    LET l_rvu.rvucrat = g_today       #TQC-A60075
    LET l_rvu.rvucond = g_today       #TQC-A60075
    LET l_rvu.rvucont = TIME          #TQC-A60075
    IF cl_null(l_rvu.rvu21) THEN LET l_rvu.rvu21 = ' ' END IF
    IF cl_null(l_rvu.rvumksg) THEN LET l_rvu.rvumksg = 'N' END IF
    IF cl_null(l_rvu.rvu900) THEN LET l_rvu.rvu900 = '0' END IF
    IF cl_null(l_rvu.rvupos) THEN LET l_rvu.rvupos = 'N' END IF
    LET l_rvu.rvu27 = '1'  #TQC-B60065
    #No.FUN-A10123 ...end
    #新增入庫單頭
    #LET l_sql="INSERT INTO ",l_dbs_tra CLIPPED,"rvu_file",  #FUN-980092
    LET l_sql="INSERT INTO ",cl_get_target_table(l_plant_new,'rvu_file'), #FUN-A50102
              "(rvu00  ,rvu01  ,rvu02  ,rvu03  ,rvu04  ,",
              " rvu05  ,rvu06  ,rvu07  ,rvu08  ,rvu09  ,",
              " rvu10  ,rvu11  ,rvu12  ,rvu13  ,rvu14  ,",
              " rvu15  ,rvu20  ,rvu99  ,rvuconf,rvuacti,",
              " rvu21  ,rvu22  ,rvu23  ,rvucrat,rvucond,", #No.FUN-A10123
              " rvucont,rvuconu,rvumksg,rvu900,rvupos,",   #No.FUN-A10123
              " rvu17  ,",                                 #FUN-AB0023 add
              " rvu27  ,",                                 #TQC-B60065
              " rvuuser,rvugrup,rvumodu,rvudate,rvuplant,rvulegal,rvuoriu,rvuorig,",  #TQC-A10060  add rvuoriu,rvuorig
              " rvuud01,rvuud02,rvuud03,rvuud04,rvuud05,",                      
              " rvuud06,rvuud07,rvuud08,rvuud09,rvuud10,",                      
              " rvuud11,rvuud12,rvuud13,rvuud14,rvuud15)",                      
              " VALUES( ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,",
              "         ?,?,?,?,?,  ?,?,?,?,?,             ",       #No.FUN-A10123
              "         ?,?,?,?,?,  ?,?,?,?,?,?,?,?, ?,?,?,?,?,",     #No.CHI-950020   #TQC-A10060  add ?,?
              "         ?,?,?,?,?,  ?,?,?,?, ?,?,?)"                  #FUN-980006 add ?,? #TQC-B60065 Add ?
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
    PREPARE ins_rvu FROM l_sql
    EXECUTE ins_rvu USING 
              l_rvu.rvu00,l_rvu.rvu01,l_rvu.rvu02,l_rvu.rvu03,l_rvu.rvu04,
              l_rvu.rvu05,l_rvu.rvu06,l_rvu.rvu07,l_rvu.rvu08,l_rvu.rvu09,
              l_rvu.rvu10,l_rvu.rvu11,l_rvu.rvu12,l_rvu.rvu13,l_rvu.rvu14,
              l_rvu.rvu15,l_rvu.rvu20,l_rvu.rvu99,l_rvu.rvuconf,l_rvu.rvuacti,
              l_rvu.rvu21,l_rvu.rvu22,l_rvu.rvu23,l_rvu.rvucrat,l_rvu.rvucond,     #No.FUN-A10123
              l_rvu.rvucont,l_rvu.rvuconu,l_rvu.rvumksg,l_rvu.rvu900,l_rvu.rvupos, #No.FUN-A10123
              l_rvu.rvu17,                                                         #FUN-AB0023 add
              l_rvu.rvu27,                                                         #TQC-B60065
              l_rvu.rvuuser,l_rvu.rvugrup,l_rvu.rvumodu,l_rvu.rvudate,l_plant,l_legal,l_rvu.rvuoriu,l_rvu.rvuorig  #TQC-A10060 oriu,orig   #FUN-980006 add l_plant,l_legal  
             ,l_rvu.rvuud01,l_rvu.rvuud02,l_rvu.rvuud03,l_rvu.rvuud04,l_rvu.rvuud05,
              l_rvu.rvuud06,l_rvu.rvuud07,l_rvu.rvuud08,l_rvu.rvuud09,l_rvu.rvuud10,
              l_rvu.rvuud11,l_rvu.rvuud12,l_rvu.rvuud13,l_rvu.rvuud14,l_rvu.rvuud15
    IF SQLCA.sqlcode<>0 THEN
       IF g_bgerr THEN
          CALL s_errmsg("rvu01",l_rvu.rvu01,"ins rvu:",SQLCA.sqlcode,1)  #No.TQC-740094
       ELSE
          CALL cl_err3("","","","",SQLCA.sqlcode,"","ins rvu:",1)
       END IF
        LET g_success = 'N'
    END IF
END FUNCTION
 
#入庫單單身檔
FUNCTION p822_rvvins(p_i)
  DEFINE l_sql  LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(1200)
  DEFINE l_sql1  LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(600)
  DEFINE l_sql2  LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(1600)
  DEFINE p_i     LIKE type_file.num5    #No.FUN-680136 SMALLINT
  DEFINE l_no    LIKE type_file.num5    #No.FUN-680136 SMALLINT
  DEFINE l_price LIKE ogb_file.ogb13
  DEFINE i,l_i    LIKE type_file.num5    #No.FUN-680136 SMALLINT
  DEFINE l_msg   LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(80)
  DEFINE l_chr   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
#  DEFINE l_qoh   LIKE ima_file.ima262 #FUN-A20044
  DEFINE l_qoh   LIKE type_file.num15_3 #FUN-A20044
  DEFINE l_ima86 LIKE ima_file.ima86
  DEFINE l_ima39 LIKE ima_file.ima39
  DEFINE l_ima35 LIKE ima_file.ima35
  DEFINE l_ima36 LIKE ima_file.ima36
  DEFINE l_rvvi  RECORD LIKE rvvi_file.*  #No.FUN-830132
  DEFINE l_plant  LIKE azp_file.azp01    #FUN-980006 add
  DEFINE l_legal  LIKE oga_file.ogalegal #FUN-980006 add
  DEFINE l_ima25 LIKE ima_file.ima25      #MOD-A90100
  DEFINE l_flag   SMALLINT     #MOD-A90100
  DEFINE l_img09 LIKE img_file.img09   #MOD-AB0219
  DEFINE l_rvviicd02  LIKE rvvi_file.rvviicd02  #FUN-B90012
  DEFINE l_rvviicd05  LIKE rvvi_file.rvviicd05  #FUN-B90012
  DEFINE l_flag1      LIKE type_file.chr1       #FUN-B90012
  DEFINE l_idd        RECORD LIKE idd_file.*    #FUN-B90012
  #DEFINE l_imaicd08   LIKE imaicd_file.imaicd08 #FUN-B90012 #FUN-BA0051 mark
  DEFINE l_rvu06        LIKE rvu_file.rvu06        #FUN-CB0087
  DEFINE l_rvu07        LIKE rvu_file.rvu07        #FUN-CB0087
 
  LET l_plant = g_poy.poy04  #FUN-980006 add 
  CALL s_getlegal(l_plant) RETURNING l_legal  #FUN-980006 add
   
     #讀取收貨單身檔(rvb_file)
     LET l_sql1 = "SELECT * ",
                  #" FROM ",l_dbs_tra CLIPPED,"rvb_file ",  #FUN-980092
                  " FROM ",cl_get_target_table(l_plant_new,'rvb_file'), #FUN-A50102
                  " WHERE rvb01='",l_rvb.rvb01,"' " ,
                  "  AND rvb02 =",l_rvb.rvb02
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-A50102
     PREPARE rvb_p1 FROM l_sql1
     IF STATUS THEN    #no.FUN-750127 add
       IF g_bgerr THEN
          LET g_showmsg=l_rvb.rvb01,"/",l_rvb.rvb02   #No.TQC-740094
          CALL s_errmsg("rvb01,rvb02",g_showmsg,"rvb_p1",STATUS,1)  #No.TQC-740094
       ELSE
          CALL cl_err3("","","","",STATUS,"","rvb_p1",1)
       END IF
     END IF           #no.FUN-750127 add
     DECLARE rvb_c1 CURSOR FOR rvb_p1
     OPEN rvb_c1
     FETCH rvb_c1 INTO l_rvb.*
     IF SQLCA.SQLCODE <> 0 THEN
      IF g_bgerr THEN
         LET g_showmsg=l_rvb.rvb01,"/",l_rvb.rvb02   #No.TQC-740094
         CALL s_errmsg("rvb01,rvb02",g_showmsg,l_dbs_new,"abx-003",1)  #No.TQC-740094
      ELSE
         CALL cl_err3("","","","","abx-003","",l_dbs_new,1)
      END IF
        LET g_success='N'
        RETURN
     END IF
     CLOSE oeb_c1
     #新增入庫單身檔[rvv_file]
     LET l_rvv.rvv01 = l_rvu.rvu01     #入庫單號
     LET l_rvv.rvv02 = g_rvv.rvv02     #項次
     LET l_rvv.rvv03 = '1'             #異動類別
     LET l_rvv.rvv04 = l_rvb.rvb01     #驗收單號 #No.FUN-620025
     LET l_rvv.rvv05 = g_rvv.rvv05     #項次
     LET l_sql = " SELECT pmm09 ",
                 #"   FROM ",l_dbs_tra CLIPPED,"pmm_file ",  #FUN-980092
                 "   FROM ",cl_get_target_table(l_plant_new,'pmm_file'), #FUN-A50102
                 "  WHERE pmm99 = '",g_pmm.pmm99,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
     PREPARE pmm_prepare3 FROM l_sql
     DECLARE pmm_curs3 CURSOR FOR pmm_prepare3
     OPEN pmm_curs3
     FETCH pmm_curs3 INTO l_rvv.rvv06      #供應廠商
     IF SQLCA.sqlcode THEN 
        IF g_bgerr THEN
           CALL s_errmsg("pmm99",g_pmm.pmm99,"fetch pmm_curs3",SQLCA.sqlcode,1)  #No.TQC-740094
        ELSE
           CALL cl_err3("","","","",SQLCA.sqlcode,"","fetch pmm_curs3",1)
        END IF
        LET l_rvv.rvv06 = ''
        LET g_success = 'N'
     END IF
     CLOSE pmm_curs3
     LET l_rvv.rvv09 = g_rvu.rvu03     #異動日期 
     LET l_rvv.rvv17 = g_rvv.rvv17     #數量
     LET l_rvv.rvv23 = 0               #已請款匹配量
     LET l_rvv.rvv88 = 0               #暫估數量  #No.TQC-7B0083
     LET l_rvv.rvv25 = g_rvv.rvv25  #No.9421
     LET l_rvv.rvv31 = g_rvv.rvv31     #料件編號
     CALL p822_ima(l_rvv.rvv31)
       #RETURNING l_rvv.rvv031,l_rvv.rvv35,l_qoh,l_ima86,l_ima39,   #MOD-A90100
       RETURNING l_rvv.rvv031,l_ima25,l_qoh,l_ima86,l_ima39,   #MOD-A90100
                 l_ima35,l_ima36

   #MOD-D10029 add start -----
    IF g_rvv.rvv31[1,4] = 'MISC' THEN  
       LET l_rvv.rvv031 = g_rvv.rvv031 
    END IF
   #MOD-D10029 add end   -----

     LET l_rvv.rvv32 = l_rvb.rvb36     #倉庫
     LET l_rvv.rvv33 = l_rvb.rvb37     #儲   
     LET l_rvv.rvv34 = l_rvb.rvb38     #批
     LET l_rvv.rvv35 = l_ogb.ogb05     #MOD-810179 
     LET l_rvv.rvv17 = s_digqty(l_rvv.rvv17,l_rvv.rvv35)  #FUN-BB0084

     #-----MOD-AB0219---------
     LET l_sql = "SELECT img09 ",                                 
                 " FROM ",l_dbs_new CLIPPED,"img_file ",    
                 " WHERE img01 ='", l_rvv.rvv31,"' ",
                 "   AND img02 ='", l_rvv.rvv32,"' ",
                 "   AND img03 ='", l_rvv.rvv33,"' ",
                 "   AND img04 ='", l_rvv.rvv34,"' "
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql
     PREPARE img_p2 FROM l_sql
     IF SQLCA.SQLCODE THEN 
        CALL cl_err('img_p2',SQLCA.SQLCODE,1)
     END IF
     DECLARE img_c2 CURSOR FOR img_p2
     OPEN img_c2
     FETCH img_c2 INTO l_img09   
     #-----END MOD-AB0219-----

     #-----MOD-A90100---------
     #IF l_ima25 = l_rvv.rvv35 THEN   #MOD-AB0219
     IF l_img09 = l_rvv.rvv35 THEN   #MOD-AB0219
        LET l_rvv.rvv35_fac = 1
     ELSE
        #CALL s_umfchkm(l_rvv.rvv31,l_rvv.rvv35,l_ima25,l_dbs_new)   #MOD-AB0219
        #CALL s_umfchkm(l_rvv.rvv31,l_rvv.rvv35,l_img09,l_dbs_new)   #MOD-AB0219    #FUN-C50136 mark
        CALL s_umfchkm(l_rvv.rvv31,l_rvv.rvv35,l_img09,l_plant_new)                 #FUN-C50136 
             RETURNING l_flag,l_rvv.rvv35_fac
        IF l_flag THEN
           LET g_msg=l_dbs_new CLIPPED,' ',l_rvv.rvv31
           CALL cl_err(g_msg,'mfg3075',1)
           LET g_success = 'N'
        END IF
     END IF
     #-----END MOD-A90100-----

     LET l_rvv.rvv36 = l_rvb.rvb04     #采購單號 #No.FUN-620025
    #LET l_rvv.rvv37 = g_rvv.rvv37     #采購序號 #MOD-A20033 mark
     LET l_rvv.rvv37 = l_rvb.rvb03     #采購序號 #MOD-A20033
 
    LET l_rvv.rvv38 = l_rvb.rvb10     #單價
    LET l_rvv.rvv87 = g_rvv.rvv87     #MOD-830166-add
    CALL cl_digcut(l_rvv.rvv38,l_azi.azi03) RETURNING l_rvv.rvv38
    LET l_rvv.rvv39 = l_rvv.rvv38 * l_rvv.rvv87   #金額  #No.TQC-6A0084
    CALL cl_digcut(l_rvv.rvv39,l_azi.azi04) RETURNING l_rvv.rvv39
    LET l_rvv.rvv80 = g_rvv.rvv80
    LET l_rvv.rvv81 = g_rvv.rvv81
    LET l_rvv.rvv82 = g_rvv.rvv82
    LET l_rvv.rvv83 = g_rvv.rvv83
    LET l_rvv.rvv84 = g_rvv.rvv84
    LET l_rvv.rvv85 = g_rvv.rvv85
    LET l_rvv.rvv86 = g_rvv.rvv86
    LET l_rvv.rvv87 = g_rvv.rvv87
    LET l_rvv.rvvud01 = g_rvv.rvvud01
    LET l_rvv.rvvud02 = g_rvv.rvvud02
    LET l_rvv.rvvud03 = g_rvv.rvvud03
    LET l_rvv.rvvud04 = g_rvv.rvvud04
    LET l_rvv.rvvud05 = g_rvv.rvvud05
    LET l_rvv.rvvud06 = g_rvv.rvvud06
    LET l_rvv.rvvud07 = g_rvv.rvvud07
    LET l_rvv.rvvud08 = g_rvv.rvvud08
    LET l_rvv.rvvud09 = g_rvv.rvvud09
    LET l_rvv.rvvud10 = g_rvv.rvvud10
    LET l_rvv.rvvud11 = g_rvv.rvvud11
    LET l_rvv.rvvud12 = g_rvv.rvvud12
    LET l_rvv.rvvud13 = g_rvv.rvvud13
    LET l_rvv.rvvud14 = g_rvv.rvvud14
    LET l_rvv.rvvud15 = g_rvv.rvvud15
    LET l_rvv.rvv22   = l_rvb.rvb22          #FUN-BB0001 add
    IF l_rvb.rvb10t >= 0 THEN
       LET l_rvv.rvv38t=l_rvb.rvb10t   
       CALL cl_digcut(l_rvv.rvv38t,l_azi.azi03) RETURNING l_rvv.rvv38t #MOD-720052 add
       LET l_rvv.rvv39t=l_rvv.rvv87*l_rvv.rvv38t 
       CALL cl_digcut(l_rvv.rvv39t,l_azi.azi04) RETURNING l_rvv.rvv39t #MOD-720052 add
    END IF   
    LET l_rvv.rvv930 = l_rvb.rvb930   #NO.FUN-670007 成本中心
    IF cl_null(l_rvv.rvv02) THEN LET l_rvv.rvv02 = 1 END IF
    LET l_rvv.rvv89 = 'N'   #NO.FUN-940083
    #No.FUN-A10123 ...begin
    IF g_azw.azw04 = '2' THEN
       LET l_rvv.rvv10 = l_rvb.rvb42
       LET l_rvv.rvv11 = l_rvb.rvb43
       LET l_rvv.rvv12 = l_rvb.rvb44
       LET l_rvv.rvv13 = l_rvb.rvb45
    END IF
    IF cl_null(l_rvv.rvv10) THEN LET l_rvv.rvv10 = '4' END IF
    LET l_rvv.rvv26 = g_poy.poy30  #TQC-D40064 add
    #No.FUN-A10123 ...end
    #FUN-CB0087--add--str--
    IF l_aza.aza115 ='Y' THEN
       IF cl_null(l_rvv.rvv26) THEN  #TQC-D20067 mark  #TQC-D40064 remark
          #TQC-D20050--mod--str--
          #SELECT rvu06,rvu07 INTO l_rvu06,l_rvu07 FROM rvu_file WHERE rvu01 = l_rvv.rvv01
          #CALL s_reason_code(l_rvv.rvv01,l_rvv.rvv04,'',l_rvv.rvv31,l_rvv.rvv32,l_rvu07,l_rvu06) RETURNING l_rvv.rvv26
          LET l_sql2="SELECT rvu06,rvu07 FROM ",cl_get_target_table(l_plant_new,'rvu_file')," WHERE rvu01 ='",l_rvv.rvv01,"'"
          PREPARE rvv26_pr FROM l_sql2
          EXECUTE rvv26_pr INTO l_rvu06,l_rvu07
          CALL s_reason_code1(l_rvv.rvv01,l_rvv.rvv04,'',l_rvv.rvv31,l_rvv.rvv32,l_rvu07,l_rvu06,l_plant_new) RETURNING l_rvv.rvv26
          #TQC-D20050--mod--end--
          IF cl_null(l_rvv.rvv26) THEN
             CALL cl_err(l_rvv.rvv26,'aim-425',1)
             LET g_success="N"
             RETURN
          END IF
       END IF  #TQC-D20067 mark  #TQC-D40064 remark
    END IF
    #FUN-CB0087--add--end--
    #新增出貨單身檔
    #LET l_sql2="INSERT INTO ",l_dbs_tra CLIPPED,"rvv_file",  #FUN-980092
    LET l_sql2="INSERT INTO ",cl_get_target_table(l_plant_new,'rvv_file'), #FUN-A50102
               "(rvv01,rvv02,rvv03,rvv04,rvv05, ",
               " rvv06,rvv09,rvv17,rvv18,rvv23, ",
               " rvv24,rvv25,rvv26,rvv31,rvv031, ",
               " rvv32,rvv33,rvv34,rvv35,rvv35_fac,",
               " rvv36,rvv37,rvv38,rvv39,rvv40, ",
               " rvv10,rvv11,rvv12,rvv13, ",         #No.FUN-A10123
               " rvv38t,rvv39t,rvv41,rvv42,rvv43, ",                   #No.FUN-620025
               " rvv80,rvv81,rvv82,rvv83,rvv84, ",   #FUN-560043
               " rvv85,rvv86,rvv87,rvv88,rvv89, ",   #FUN-560043
               " rvv930,rvvplant,rvvlegal, ",   #FUN-560043 #No.TQC-7B0083 add rvv88 #FUN-940083 add rvv89 #FUN-980006 add rvvplant,rvvlegal #CHI-9B0008
               " rvvud01,rvvud02,rvvud03,rvvud04,rvvud05,",
               " rvvud06,rvvud07,rvvud08,rvvud09,rvvud10,",
               " rvvud11,rvvud12,rvvud13,rvvud14,rvvud15,",
               " rvv22 )",                                   #FUN-BB0001 add rvv22
               " VALUES( ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "         ?,?,?,?,                                   ",    #No.FUN-A10123
               "         ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",    #No.CHI-950020
               "         ?,?,?,     ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,  ?) "    #FUN-560043  #No.FUN-620025  #No.TQC-7B0083 #FUN-940083 #FUN-980006 add  ?,? #CHI-9B0008 #FUN-BB0001 add ?
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
    PREPARE ins_rvv FROM l_sql2
    EXECUTE ins_rvv USING 
               l_rvv.rvv01,l_rvv.rvv02,l_rvv.rvv03,l_rvv.rvv04,l_rvv.rvv05,
               l_rvv.rvv06,l_rvv.rvv09,l_rvv.rvv17,l_rvv.rvv18,l_rvv.rvv23,
               l_rvv.rvv24,l_rvv.rvv25,l_rvv.rvv26,l_rvv.rvv31,l_rvv.rvv031,
               l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,l_rvv.rvv35,l_rvv.rvv35_fac,
               l_rvv.rvv36,l_rvv.rvv37,l_rvv.rvv38,l_rvv.rvv39,l_rvv.rvv40,
               l_rvv.rvv10,l_rvv.rvv11,l_rvv.rvv12,l_rvv.rvv13,                           #No.FUN-A10123
               l_rvv.rvv38t,l_rvv.rvv39t,l_rvv.rvv41,l_rvv.rvv42,l_rvv.rvv43,             #No.FUN-620025   
               l_rvv.rvv80,l_rvv.rvv81,l_rvv.rvv82,l_rvv.rvv83,l_rvv.rvv84,   #FUN-560043
               l_rvv.rvv85,l_rvv.rvv86,l_rvv.rvv87,l_rvv.rvv88,l_rvv.rvv89,   #FUN-560043
               l_rvv.rvv930,l_plant,l_legal,                                  #FUN-560043  #No.TQC-7B0083  add rvv88 #FUN-940083 add rvv89 #FUN-980006 add l_plant,l_legal   #CHI-9B0008
               l_rvv.rvvud01,l_rvv.rvvud02,l_rvv.rvvud03,l_rvv.rvvud04,l_rvv.rvvud05,
               l_rvv.rvvud06,l_rvv.rvvud07,l_rvv.rvvud08,l_rvv.rvvud09,l_rvv.rvvud10,
               l_rvv.rvvud11,l_rvv.rvvud12,l_rvv.rvvud13,l_rvv.rvvud14,l_rvv.rvvud15,
               l_rvv.rvv22       #FUN-BB0001 add rvv22
    IF SQLCA.sqlcode<>0 THEN 
       IF g_bgerr THEN
          LET g_showmsg = l_rvv.rvv01,"/",l_rvv.rvv02   #No.TQC-740094
          CALL s_errmsg("rvv01,rvv02",g_showmsg,"ins rvv:",SQLCA.sqlcode,1)  #No.TQC-740094
       ELSE
          CALL cl_err3("","","","",SQLCA.sqlcode,"","ins rvv:",1)
       END IF
       LET g_success = 'N'
    ELSE
       IF NOT s_industry('std') THEN
          INITIALIZE l_rvvi.* TO NULL
          LET l_rvvi.rvvi01 = l_rvv.rvv01
          LET l_rvvi.rvvi02 = l_rvv.rvv02
          IF NOT s_ins_rvvi(l_rvvi.*,l_plant_new) THEN  #FUN-980092
             LET g_success = 'N'
          END IF
       END IF
    END IF
 
    #LET l_sql2 = "SELECT ima918,ima921 FROM ",l_dbs_new CLIPPED,"ima_file",
    LET l_sql2 = "SELECT ima918,ima921 FROM ",cl_get_target_table(l_plant_new,'ima_file'), #FUN-A50102
                 " WHERE ima01 = '",l_rvv.rvv31,"'",
                 "   AND imaacti = 'Y'"
    
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
    PREPARE ima_rvv FROM l_sql2
    
    EXECUTE ima_rvv INTO g_ima918,g_ima921                                                                             
     
    IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
       
       FOREACH p822_g_rvbs INTO l_rvbs.*
          IF STATUS THEN
             CALL cl_err('rvbs',STATUS,1)
          END IF
    
          LET l_rvbs.rvbs00 = "apmt740"
       
          LET l_rvbs.rvbs01 = l_rvv.rvv01
       
          #LET l_rvbs.rvbs06 = l_rvbs.rvbs06 * l_rvv.rvv35_fac   #MOD-A90100
          LET l_rvbs.rvbs06 = l_rvbs.rvbs06    #MOD-A90100
    
          IF cl_null(l_rvbs.rvbs06) THEN
             LET l_rvbs.rvbs06 = 0
          END IF
    
          LET l_rvbs.rvbs09 = 1
          LET l_rvbs.rvbs13 = 0    #MOD-940294
 
          #新增批/序號資料檔
          EXECUTE ins_rvbs USING l_rvbs.rvbs00,l_rvbs.rvbs01,l_rvbs.rvbs02,
                                 l_rvbs.rvbs021,l_rvbs.rvbs022,l_rvbs.rvbs03,
                                 l_rvbs.rvbs04,l_rvbs.rvbs05,l_rvbs.rvbs06,
                                 l_rvbs.rvbs07,l_rvbs.rvbs08,l_rvbs.rvbs09, 
                                 l_rvbs.rvbs13,l_plant,l_legal    #MOD-940294   #MOD-CB0055 add ,l_plant,l_legal
    
          IF STATUS OR SQLCA.SQLCODE THEN
             LET g_showmsg = l_rvbs.rvbs01,"/",l_rvbs.rvbs03
             CALL s_errmsg('rvbs01,rvbs03',g_showmsg,'ins rvbs:',SQLCA.sqlcode,1) 
             LET g_success='N'
          END IF
    
          CALL p822_imgs(l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,l_rvu.rvu03,l_rvbs.*)	#MOD-980058
       
       END FOREACH
    END IF

    #FUN-B90012----add----str----
    IF s_industry('icd') THEN 
       #FUN-BA0051 --START mark--
       #LET l_sql2 = "SELECT imaicd08 FROM ",cl_get_target_table(l_plant_new,'ima_file'),",",
       #                                     cl_get_target_table(l_plant_new,'imaicd_file'),
       #             " WHERE imaicd00 = '",l_rvv.rvv31,"' ",
       #             "   AND ima01 = imaicd00 ",
       #             "   AND imaacti = 'Y' "
       #CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
       #CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2
       #PREPARE imaicd_rvv FROM l_sql2
       #EXECUTE imaicd_rvv INTO l_imaicd08
       #
       #IF l_imaicd08 = 'Y' THEN
       #FUN-BA0051 --END mark--
       IF s_icdbin_multi(l_rvv.rvv31,l_plant_new) THEN   #FUN-BA0051
          FOREACH p822_idd INTO l_idd.* 
             IF STATUS THEN
                CALL cl_err('ida',STATUS,1)
             END IF
             LET l_idd.idd10 = l_rvv.rvv01
             LET l_idd.idd11 = l_rvv.rvv02
          #CHI-C80009---add---START
             LET l_idd.idd02 = l_rvv.rvv32
             LET l_idd.idd03 = l_rvv.rvv33
             LET l_idd.idd04 = l_rvv.rvv34
          #CHI-C80009---add-----END
             CALL icd_ida(1,l_idd.*,l_plant_new)
          END FOREACH
       END IF

       LET l_sql2 = "SELECT rvviicd02,rvviicd05 FROM ",cl_get_target_table(l_plant_new,'rvvi_file'),
                    " WHERE rvvi01 = '",l_rvv.rvv01,"' ",
                    "   AND rvvi02 = '",l_rvv.rvv02,"' "
       CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
       CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2
       PREPARE rvvicd_rvv_1 FROM l_sql2
       EXECUTE rvvicd_rvv_1 INTO l_rvviicd02,l_rvviicd05
       
       CALL s_icdpost(11,l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,
                      l_rvv.rvv34,l_rvv.rvv35,l_rvv.rvv17,
                      l_rvv.rvv01,l_rvv.rvv02,
                      l_rvu.rvu03,'Y',l_rvv.rvv04,l_rvv.rvv05,
                      l_rvviicd05,l_rvviicd02,l_plant_new) 
           RETURNING l_flag1
       IF l_flag1 = 0 THEN
          LET g_success = 'N'
       END IF
           
    END IF
    #FUN-B90012----add----end----
 
   #回寫最近入庫日 ima73
    LET l_sql1 = "SELECT ima29 ", 
                 #" FROM ",l_dbs_new CLIPPED,"ima_file ",   
                 " FROM ",cl_get_target_table(l_plant_new,'ima_file'), #FUN-A50102     
                 " WHERE ima01='",l_rvv.rvv31,"'"
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-A50102
    PREPARE ima_p2 FROM l_sql1
    IF SQLCA.SQLCODE THEN 
      IF g_bgerr THEN
         CALL s_errmsg("ima01",l_rvv.rvv31,"",SQLCA.sqlcode,1)  
      ELSE
         CALL cl_err3("","","","",SQLCA.sqlcode,"","",1)
      END IF
    END IF
    DECLARE ima_c2 CURSOR FOR ima_p2
    OPEN ima_c2	
    FETCH ima_c2 INTO l_ima29
    #---  異動日期需大於原來的異動日期才可 
    #必須判斷null,否則新料不會update
    IF (g_rvu.rvu03 > l_ima29 OR l_ima29 IS NULL)  THEN
       #LET l_sql2="UPDATE ",l_dbs_new CLIPPED,"ima_file",
       LET l_sql2="UPDATE ",cl_get_target_table(l_plant_new,'ima_file'), #FUN-A50102
                  " SET ima73 = ? ",
                  "   , ima29 = ? ",     #MOD-C30877 add
                  " WHERE ima01 = ?  "
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
       PREPARE upd_ima2 FROM l_sql2
      #EXECUTE upd_ima2 USING g_rvu.rvu03,l_rvv.rvv31                 #MOD-C30877 mark
       EXECUTE upd_ima2 USING l_rvu.rvu03,l_rvu.rvu03,l_rvv.rvv31     #MOD-C30877 add
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
          IF g_bgerr THEN
             CALL s_errmsg('ima01',l_rvv.rvv31,'upd ima',STATUS,1)
          ELSE
             CALL cl_err('upd ima:',STATUS,1)
          END IF
          LET g_success='N'
       END IF
    END IF
END FUNCTION
 
FUNCTION p822_log(p_part,p_ware,p_loca,p_lot,p_qty,p_sta)
  DEFINE p_part      LIKE ima_file.ima01,       #料號
         p_ware      LIKE ogb_file.ogb09,       #倉
         p_loca      LIKE ogb_file.ogb091,      #儲
         p_lot       LIKE ogb_file.ogb092,      #批
         p_qty       LIKE ogb_file.ogb12 ,      #異動數量
         l_img       RECORD LIKE img_file.*,
         l_imgg      RECORD LIKE imgg_file.*,   #FUN-560043
         p_sta       LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(01)                  #1.出貨單 2.驗收單 3.入庫單
         l_flag      LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
         l_img09     LIKE img_file.img09,       #庫存單位
         l_img10     LIKE img_file.img10,       #庫存數量
         l_img26     LIKE img_file.img26,
         l_ima39     LIKE ima_file.ima39,
         l_ima86     LIKE ima_file.ima86,
         l_ima25     LIKE ima_file.ima25,
         l_ima35     LIKE ima_file.ima35,
         l_ima36     LIKE ima_file.ima36,
#         l_qoh       LIKE ima_file.ima262, #FUN-A20044    
         l_qoh       LIKE type_file.num15_3, #FUN-A20044    
         l_ima02     LIKE ima_file.ima02,
         l_sql1      LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(600)
         l_sql2      LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(1600)
         l_msg       LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(50)
         l_chr       LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
         l_n         LIKE type_file.num5,    #No.FUN-680136 SMALLINT
         p_unit      LIKE ima_file.ima25,    #No.FUN-620025                                                                         
         p_unit2     LIKE ima_file.ima25,    #No.FUN-620025  
         l_sql3      LIKE type_file.chr1000, #FUN-560043  #No.FUN-680136 VARCHAR(600)
         l_sql4      LIKE type_file.chr1000, #FUN-560043   #No.FUN-680136 VARCHAR(1600)
         l_n2        LIKE type_file.num5,    #FUN-560043  #No.FUN-680136 SMALLINT
         l_k,l_l     LIKE type_file.num5,    #No.FUN-680136 SMALLINT #FUN-560043
         l_sql5      LIKE type_file.chr1000, #FUN-560043  #No.FUN-680136 VARCHAR(1600)
         l_imgg10    LIKE imgg_file.imgg10,  #FUN-560043
         l_sw        LIKE type_file.num5     #No.FUN-680136 SMALLINT       #No.TQC-660122
  #       l_azp03     LIKE azp_file.azp03,   #No.TQC-660122   #FUN-B90012
  #       l_azp01     LIKE azp_file.azp01    #No.FUN-980059   #FUN-B90012
  DEFINE l_plant  LIKE azp_file.azp01        #FUN-980006 add
  DEFINE l_legal  LIKE oga_file.ogalegal     #FUN-980006 add
  DEFINE l_ccz28  LIKE ccz_file.ccz28  #MOD-CC0289 add
  DEFINE l_sql    STRING                     #FUN-D20062 add
 
  LET l_plant = g_poy.poy04  #FUN-980006 add 
  CALL s_getlegal(l_plant) RETURNING l_legal  #FUN-980006 add
 
  IF p_part[1,4]='MISC' THEN RETURN END IF  #No.8743
  IF p_loca IS NULL THEN LET p_loca=' ' END IF
  IF p_lot  IS NULL THEN LET p_lot =' ' END IF
 
  CALL p822_ima(p_part) RETURNING l_ima02,l_ima25,l_qoh,l_ima86,l_ima39,
                                       l_ima35,l_ima36
  LET l_sql1 = "SELECT COUNT(*) ",
               #" FROM ",l_dbs_tra CLIPPED,"img_file ",  #FUN-980092
               " FROM ",cl_get_target_table(l_plant_new,'img_file'), #FUN-A50102
               " WHERE img01='",p_part,"' ",
               "   AND img02='",p_ware,"'",
               "   AND img03='",p_loca,"'",
               "   AND img04='",p_lot,"'"
  CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
  CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-980092
  PREPARE img_pre1 FROM l_sql1
  IF STATUS THEN
     IF g_bgerr THEN
        LET g_showmsg=p_part,"/",p_ware,"/",p_loca,"/",p_lot   #No.TQC-740094
        CALL s_errmsg("img01,img02,img03,img04",g_showmsg,"img_pre",STATUS,1)  #No.TQC-740094
     ELSE
        CALL cl_err3("","","","",STATUS,"","img_pre",1)
     END IF
  END IF
  DECLARE img_cs CURSOR FOR img_pre1
  OPEN img_cs
  FETCH img_cs INTO l_n
  IF l_n = 0 THEN
     LET l_img.img01 = p_part
     LET l_img.img02 = p_ware
     LET l_img.img03 = p_loca
     LET l_img.img04 = p_lot
     IF cl_null(l_img.img04) THEN LET l_img.img04 = ' ' END IF
     LET l_img.img05 = l_rvv.rvv01            #No.FUN-620025
     LET l_img.img06 = g_rvv.rvv02
     LET l_img.img09 = l_ima25
     LET l_img.img10 = 0
     LET l_img.img13 = null   #No.7304
     LET l_img.img18 = g_lastdat
     LET l_img.img17 = g_today
     LET l_img.img20 = 1
     LET l_img.img21 = 1
     LET l_img.img22 = g_imd10
     LET l_img.img23 = g_imd11
     LET l_img.img24 = g_imd12
     LET l_img.img25 = g_imd13
     LET l_img.img27 = g_imd14
     LET l_img.img28 = g_imd15

    #LET l_sql2="INSERT INTO ",l_dbs_tra CLIPPED,"img_file", #FUN-980092
     LET l_sql2="INSERT INTO ",cl_get_target_table(l_plant_new,'img_file'), #FUN-A50102
                "(img01,img02,img03,img04,img05,img06,",
                " img09,img10,img13,img17,img18,", 
                " img20,img21,img22,img23,img24,", 
                " img25,img27,img28,imgplant,imglegal)",   #TQC-690057 add img27,img28 #FUN-980006 add imgplant,imglegal
                " VALUES( ?,?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?, ?,?)"  #TQC-690057 #FUN-980006 add  imgplant,imglegal
     CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
     PREPARE ins_img FROM l_sql2
     EXECUTE ins_img USING l_img.img01,l_img.img02,l_img.img03,l_img.img04,
                           l_img.img05,l_img.img06,
                           l_img.img09,l_img.img10,l_img.img13,l_img.img17,
                           l_img.img18,
                           l_img.img20,l_img.img21,l_img.img22,l_img.img23,
                           l_img.img24,l_img.img25,l_img.img27,l_img.img28,l_plant,l_legal  #TQC-690057 #FUN-980006 add l_plant,l_legal
     IF SQLCA.sqlcode<>0 THEN
        IF g_bgerr THEN
           LET g_showmsg=l_img.img01,"/",l_img.img02,"/",l_img.img03,"/",l_img.img03   #No.TQC-740094
           CALL s_errmsg("img01,img02,img03,img04",g_showmsg,"ins img:",SQLCA.sqlcode,1)  #No.TQC-740094
        ELSE
           CALL cl_err3("","","","",SQLCA.sqlcode,"","ins img:",1)
        END IF
        LET g_success = 'N'
     END IF
  #FUN-D20062 -- add start --
  ELSE
     IF g_pod.pod08 = 'Y' THEN
        LET l_sql = "SELECT img18 FROM img_file ",
                    " WHERE img01='",p_part,"' ",
                    "   AND img02='",p_ware,"'",
                    "   AND img03='",p_loca,"'",
                    "   AND img04='",p_lot,"'"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql
        PREPARE img18_pre FROM l_sql
        IF SQLCA.SQLCODE THEN
           IF g_bgerr THEN
              LET  g_showmsg=p_part,"/",p_ware,"/",p_loca,"/",p_lot
              CALL s_errmsg('img01,img02,img03,img04',g_showmsg,'img18_pre',SQLCA.SQLCODE,1)
           ELSE
             CALL cl_err('img18_pre',SQLCA.SQLCODE,1)
           END IF
        END IF

        DECLARE img18_cs CURSOR FOR img18_pre

        OPEN img18_cs
        FETCH img18_cs INTO l_img.img18
        IF SQLCA.SQLCODE <> 0 THEN
           IF g_bgerr THEN
              LET  g_showmsg=p_part,"/",p_ware,"/",p_loca,"/",p_lot
              CALL s_errmsg('img01,img02,img03,img04',g_showmsg,'img18_cs',SQLCA.sqlcode,1)
           ELSE
              CALL cl_err('img18_cs',SQLCA.sqlcode,1)
           END IF
           LET g_success='N'
        END IF
        CLOSE img18_cs
 
        LET l_sql= "UPDATE ",cl_get_target_table(l_plant_new,'img_file'),
                   " SET img18 = '",l_img.img18,"' ",
                   " WHERE img01='",p_part,"' ",
                   "   AND img02='",p_ware,"'",
                   "   AND img03='",p_loca,"'",
                   "   AND img04='",p_lot,"'"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql
        CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql
        PREPARE upd_img18 FROM l_sql
        EXECUTE upd_img18
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
           IF g_bgerr THEN
              LET  g_showmsg=p_part,"/",p_ware,"/",p_loca,"/",p_lot
              CALL s_errmsg('img01,img02,img03,img04',g_showmsg,'upd img18',SQLCA.sqlcode,1)
           ELSE
              CALL cl_err('upd img18:',STATUS,1)
           END IF
           LET g_success='N'
        END IF
     END IF
  #FUN-D20062 -- add end --
  END IF

  IF g_sma.sma115 = 'Y' THEN  #No.CHI-760003  
     IF g_ima906 = '2' OR g_ima906 = '3' THEN
        FOR l_k = 1 TO 2
          IF g_ima906='2' OR (g_ima906='3' AND l_k=1) THEN   #No.FUN-620025 
             LET l_sql3 = ''
             LET l_n2 = 0 
             LET l_sql3 = "SELECT COUNT(*) ",
                          #" FROM ",l_dbs_tra CLIPPED,"imgg_file ", #FUN-980092
                          " FROM ",cl_get_target_table(l_plant_new,'imgg_file'), #FUN-A50102
                          " WHERE imgg01='",p_part,"' ",
                          "   AND imgg02='",p_ware,"'",
                          "   AND imgg03='",p_loca,"'",
                          "   AND imgg04='",p_lot,"'"
             IF l_k = 1 AND g_ima906='2' THEN                  #No.FUN-620025  
                LET l_sql3 = l_sql3,"   AND imgg09='",g_rvv.rvv80,"'"
             ELSE
                LET l_sql3 = l_sql3,"   AND imgg09='",g_rvv.rvv83,"'"
             END IF
         
             CALL cl_replace_sqldb(l_sql3) RETURNING l_sql3        #FUN-920032
             CALL cl_parse_qry_sql(l_sql3,l_plant_new) RETURNING l_sql3 #FUN-980092
             PREPARE imgg_pre1 FROM l_sql3
             IF STATUS THEN
                IF g_bgerr THEN
                   CALL s_errmsg("","","imgg_pre",STATUS,1)
                ELSE
                   CALL cl_err3("","","","",SQLCA.sqlcode,"","imgg_pre",1)
                END IF
             END IF
             DECLARE imgg_cs CURSOR FOR imgg_pre1
             OPEN imgg_cs
             FETCH imgg_cs INTO l_n2
             IF l_n2 = 0 THEN
                LET l_imgg.imgg01 = p_part
                LET l_imgg.imgg02 = p_ware
                LET l_imgg.imgg03 = p_loca
                LET l_imgg.imgg04 = p_lot
                LET l_imgg.imgg05 = l_rvv.rvv01          #No.FUN-620025
                LET l_imgg.imgg06 = g_rvv.rvv02
                IF l_k = 1 AND g_ima906='2' THEN         #No.FUN-620025  
                   LET l_imgg.imgg09 = g_rvv.rvv80
                ELSE 
                   LET l_imgg.imgg09 = g_rvv.rvv83
                END IF
                LET l_imgg.imgg10 = 0
                LET l_imgg.imgg17 = g_today
                LET l_imgg.imgg18 = g_lastdat
               #LET l_azp03 = s_madd_img_catstr(l_azp.azp03)   #FUN-B90012
               #LET l_azp01 = s_madd_img_catstr(l_azp.azp01)   #FUN-B90012
               #CALL s_umfchk1(l_imgg.imgg01,l_imgg.imgg09,l_ima25,l_azp01)   #No.FUN-980059   #FUN-B90012
                CALL s_umfchk1(l_imgg.imgg01,l_imgg.imgg09,l_ima25,l_plant_new)   #FUN-B90012
                     RETURNING l_sw,l_imgg.imgg21
                IF l_sw = 1 THEN
                   IF g_bgerr THEN
                      CALL s_errmsg("","","","mfg3075",1)
                   ELSE
                      CALL cl_err3("","","","","mfg3075","","",1)
                   END IF
                   LET l_imgg.imgg21 = 1
                END IF
                LET l_imgg.imgg22 = 'S'
                LET l_imgg.imgg23 = 'Y'
                LET l_imgg.imgg24 = 'N'
                LET l_imgg.imgg25 = 'N'
               #CALL s_umfchk1(l_imgg.imgg01,l_imgg.imgg09,l_img.img09,l_azp01)    #No.FUN-980059  #FUN-B90012
                CALL s_umfchk1(l_imgg.imgg01,l_imgg.imgg09,l_img.img09,l_plant_new) #FUN-B90012 
                     RETURNING l_sw,l_imgg.imgg211
                IF l_sw = 1 THEN
                   IF g_bgerr THEN
                      CALL s_errmsg("","","","mfg3075",1)
                   ELSE
                      CALL cl_err3("","","","","mfg3075","","",1)
                   END IF
                   LET l_imgg.imgg211 = 1
                END IF
                IF cl_null(l_imgg.imgg02) THEN LET l_imgg.imgg02 = ' ' END IF
                IF cl_null(l_imgg.imgg03) THEN LET l_imgg.imgg03 = ' ' END IF
                IF cl_null(l_imgg.imgg04) THEN LET l_imgg.imgg04 = ' ' END IF
                IF cl_null(l_imgg.imgg211) THEN LET l_imgg.imgg211 = 0 END IF  #No.FUN-620025 by day
                IF cl_null(l_imgg.imgg21) THEN LET l_imgg.imgg21 = 0 END IF  #No.FUN-620025 by day
                #LET l_sql4="INSERT INTO ",l_dbs_tra CLIPPED,"imgg_file", #FUN-980092
                LET l_sql4="INSERT INTO ",cl_get_target_table(l_plant_new,'imgg_file'), #FUN-A50102
                  "(imgg01,imgg02,imgg03,imgg04,imgg05,",
                  " imgg06,imgg09,imgg10,imgg17,imgg18,", 
                  " imgg21,imgg22,imgg23,imgg24,imgg25,", 
                  " imgg211,imggplant,imgglegal)", #FUN-980006 add imggplant,imgglegal
                  " VALUES(","'",l_imgg.imgg01,"',","'",l_imgg.imgg02,"',","'",l_imgg.imgg03,"',","'",l_imgg.imgg04,"',",
                             "'",l_imgg.imgg05,"',",l_imgg.imgg06,",","'",l_imgg.imgg09,"',",l_imgg.imgg10,",",
                             "'",l_imgg.imgg17,"',","'",l_imgg.imgg18,"',",l_imgg.imgg21,",","'",l_imgg.imgg22,"',",
                             "'",l_imgg.imgg23,"',","'",l_imgg.imgg24,"',","'",l_imgg.imgg25,"',",l_imgg.imgg211,",'",l_plant,"',","'",l_legal,"')" #FUN-980006 add l_plant,l_legal
                CALL cl_replace_sqldb(l_sql4) RETURNING l_sql4        #FUN-920032
                CALL cl_parse_qry_sql(l_sql4,l_plant_new) RETURNING l_sql4 #FUN-A50102
                PREPARE ins_imgg FROM l_sql4
                EXECUTE ins_imgg 
                IF SQLCA.sqlcode<>0 THEN
                   IF g_bgerr THEN
                      LET g_showmsg=l_imgg.imgg01,"/",l_imgg.imgg02,"/",l_imgg.imgg03,"/",l_imgg.imgg04  #No.TQC-740094
                      CALL s_errmsg("imgg01,imgg02,imgg03,imgg04",g_showmsg,"ins imgg:",SQLCA.sqlcode,1)  #No.TQC-740094
                   ELSE
                      CALL cl_err3("","","","",SQLCA.sqlcode,"","ins imgg:",1)
                   END IF
                      LET g_success = 'N'
                   END IF
                END IF   
             END IF               #No.FUN-620025
          END FOR
     END IF
  END IF #No.CHI-760003  
   LET g_tlf.tlf01=p_part               #異動料件編號
   #----來源----
   IF p_sta = '1' OR p_sta='2' THEN
      IF p_sta = '1' THEN
         LET g_tlf.tlf02=50             #'Stock'
         LET g_tlf.tlf021=p_ware        #倉庫
         LET g_tlf.tlf022=p_loca        #儲位
         LET g_tlf.tlf023=p_lot         #批號
      ELSE
         LET g_tlf.tlf02=10
         LET g_tlf.tlf021=' '           #倉庫
         LET g_tlf.tlf022=' '           #儲位
         LET g_tlf.tlf023=' '           #批號
      END IF
      LET g_tlf.tlf020=l_azp.azp01
      IF cl_null(g_tlf.tlf023) THEN LET g_tlf.tlf023=' ' END IF
      LET g_tlf.tlf024=''              #異動后數量
      LET g_tlf.tlf025=l_ima25         #庫存單位(ima_file or img_file)
   ELSE
      IF p_sta = '4' THEN                        #代送銷退單        
         LET g_tlf.tlf02 = 731      
         LET g_tlf.tlf020 = ' '      
         LET g_tlf.tlf021 = ' '      
         LET g_tlf.tlf022 = ' '      
         LET g_tlf.tlf023 = ' '      
         LET g_tlf.tlf024 = 0        
         LET g_tlf.tlf025 = ' '           
         LET g_tlf.tlf026 = l_oha.oha01          #異動單號      
         LET g_tlf.tlf027 = l_ohb.ohb03          #異動項次           
      ELSE 
         LET g_tlf.tlf02=20
         LET g_tlf.tlf021=' '
         LET g_tlf.tlf022=' '
         LET g_tlf.tlf023=' '
         LET g_tlf.tlf024=' '
         LET g_tlf.tlf025=' '
      END IF                                     #No.FUN-620025   
   END IF
   CASE p_sta
      WHEN '1' #出貨單
        LET g_tlf.tlf026 = l_ogb.ogb01       #異動單號  no.6178
        LET g_tlf.tlf027 = l_ogb.ogb03       #異動項次  no.6178
      WHEN '2' #收貨單
        LET g_tlf.tlf026 = l_rvb.rvb04       #異動單號  no.6178
        LET g_tlf.tlf027 = l_rvb.rvb03       #異動項次  no.6178
      WHEN '3' #入庫單
        LET g_tlf.tlf026 = l_rvv.rvv04       #異動單號  no.6178
        LET g_tlf.tlf027 = l_rvv.rvv05       #異動項次  no.6178
   END CASE
   #---目的----
   IF p_sta = '3' OR p_sta = '2' THEN
      IF p_sta='3' THEN
         LET g_tlf.tlf03=50
         LET g_tlf.tlf035=l_ima25
      ELSE
         LET g_tlf.tlf03=20
         LET g_tlf.tlf035=''
      END IF
      LET g_tlf.tlf031=p_ware
      LET g_tlf.tlf032=p_loca
      LET g_tlf.tlf033=p_lot
      IF cl_null(g_tlf.tlf033) THEN LET g_tlf.tlf033=' ' END IF
      LET g_tlf.tlf034=''
   ELSE  
      IF p_sta = '4' THEN     
         LET g_tlf.tlf03  = 50      
         LET g_tlf.tlf030 = l_ohb.ohb08      
         LET g_tlf.tlf031 = p_ware      
         LET g_tlf.tlf032 = p_loca      
         LET g_tlf.tlf033 = p_lot      
         LET g_tlf.tlf034 = l_qoh
         LET g_tlf.tlf035 = l_ima25              #庫存單位(ima_file or img_file)          
         LET g_tlf.tlf036 = l_oha.oha01          #異動單號      
         LET g_tlf.tlf037 = l_ohb.ohb03          #異動項次      
      ELSE
         LET g_tlf.tlf03 =724
         LET g_tlf.tlf030=' '
         LET g_tlf.tlf031=' '                    #倉庫
         LET g_tlf.tlf032=' '                    #儲位
         LET g_tlf.tlf033=' '                    #批號
         LET g_tlf.tlf034=' '                    #異動后庫存數量
         LET g_tlf.tlf035=' '                    #庫存單位(ima_file or img_file)
      END IF                                     #No.FUN-620025 
   END IF
   CASE p_sta
      WHEN '1' #出貨單
        LET g_tlf.tlf036 = l_ogb.ogb31       #異動單號  no.6178
        LET g_tlf.tlf037 = l_ogb.ogb32       #異動項次  no.6178
      WHEN '2' #收貨單
        LET g_tlf.tlf036 = l_rvb.rvb01       #異動單號  no.6178
        LET g_tlf.tlf037 = l_rvb.rvb02       #異動項次  no.6178
      WHEN '3' #入庫單
        LET g_tlf.tlf036 = l_rvv.rvv01       #異動單號  no.6178
        LET g_tlf.tlf037 = l_rvv.rvv02       #異動項次  no.6178
   END CASE
   #-->異動數量
   LET g_tlf.tlf04= ' '                #工作站
   LET g_tlf.tlf05= ' '                #作業序號
   LET g_tlf.tlf06=g_rvu.rvu03         #發料日期
   LET g_tlf.tlf07=g_today             #異動資料產生日期  
   LET g_tlf.tlf08=TIME                #異動資料產生時:分:秒
   LET g_tlf.tlf09=g_user              #產生人
   LET g_tlf.tlf10=g_rvv.rvv17         #異動數量
   LET g_tlf.tlf11=g_rvv.rvv35
   LET g_tlf.tlf12=l_ogb.ogb15_fac     #MOD-810179
   CASE p_sta
        WHEN '1' LET g_tlf.tlf13='axmt620'
        WHEN '2' LET g_tlf.tlf13='apmt1101'
        WHEN '3' LET g_tlf.tlf13='apmt150'
        WHEN '4' LET g_tlf.tlf13='aomt800'  #No.FUN-620025
   END CASE
   LET g_tlf.tlf14=' '              #異動原因
 
   LET g_tlf.tlf17=' '              #非庫存性料件編號
   LET g_tlf.tlf18=l_qoh
   CASE p_sta
        WHEN '1' LET g_tlf.tlf19=g_poz.poz04   #no.6178 送貨客戶
        WHEN '2' LET g_tlf.tlf19=p_pmm09
        WHEN '3'
          IF NOT cl_null(l_rvu.rvu04) THEN 
             LET g_tlf.tlf19 = l_rvu.rvu04 
          ELSE 
             LET g_tlf.tlf19=p_pmm09 
          END IF 
        WHEN '4' LET g_tlf.tlf19=l_oha.oha1016 #No.FUN-620025
   END CASE
   LET g_tlf.tlf20= ' '     
   LET g_tlf.tlf60=l_ogb.ogb05_fac    #MOD-810179
   LET g_tlf.tlf62=l_rvv.rvv01    #參考單號(入庫)  #No.FUN-620025 
   LET g_tlf.tlf63=g_rvv.rvv02    #入庫項次
   CASE WHEN  g_tlf.tlf02=50 
              LET g_tlf.tlf902=g_tlf.tlf021
              LET g_tlf.tlf903=g_tlf.tlf022
              LET g_tlf.tlf904=g_tlf.tlf023
              LET g_tlf.tlf905=g_tlf.tlf026
              LET g_tlf.tlf906=g_tlf.tlf027
              LET g_tlf.tlf907=-1
        WHEN  g_tlf.tlf03=50 
              LET g_tlf.tlf902=g_tlf.tlf031
              LET g_tlf.tlf903=g_tlf.tlf032
              LET g_tlf.tlf904=g_tlf.tlf033
              LET g_tlf.tlf905=g_tlf.tlf036
              LET g_tlf.tlf906=g_tlf.tlf037
              LET g_tlf.tlf907=1
        OTHERWISE
              LET g_tlf.tlf902=' '
              LET g_tlf.tlf903=' '
              LET g_tlf.tlf904=' '
              LET g_tlf.tlf905=' '
              LET g_tlf.tlf906=' '
              LET g_tlf.tlf907=0
   END CASE
   LET g_tlf.tlf99 = g_flow99  #No.8106
   IF g_tlf.tlf902 IS NULL THEN LET g_tlf.tlf902 = ' ' END IF
   IF g_tlf.tlf903 IS NULL THEN LET g_tlf.tlf903 = ' ' END IF
   IF g_tlf.tlf904 IS NULL THEN LET g_tlf.tlf904 = ' ' END IF
   LET g_tlf.tlf61=s_get_doc_no(g_tlf.tlf905)   #FUN-560043
   CASE p_sta
      WHEN '1' #出貨單
        LET g_tlf.tlf930 = l_ogb.ogb930       
      WHEN '2' #收貨單
        LET g_tlf.tlf930 = l_rvb.rvb930       
      WHEN '3' #入庫單
        LET g_tlf.tlf930 = l_rvv.rvv930       
   END CASE
 
   IF (g_tlf.tlf02=50 OR g_tlf.tlf03=50) THEN
      IF NOT s_tlfidle(l_plant_new,g_tlf.*) THEN      #FUN-980092
         CALL cl_err('upd ima902:','9050',1)
         LET g_success='N'
      END IF
   END IF

    #TQC-D20047--add--str--
    LET l_sql2 = "SELECT aza115 FROM ",cl_get_target_table(l_plant_new,'aza_file')," WHERE aza01 = '0' "
    PREPARE aza115_pr2 FROM l_sql2
    EXECUTE aza115_pr2 INTO g_aza.aza115   
    #TQC-D20047--add--end--
    #FUN-CB0087--add--str--
    IF g_aza.aza115 ='Y' THEN
       IF cl_null(g_tlf.tlf14) THEN
          #CALL s_reason_code(g_tlf.tlf036,g_tlf.tlf026,'',g_tlf.tlf01,g_tlf.tlf031,'','') RETURNING g_tlf.tlf14               #TQC-D20050
          CALL s_reason_code1(g_tlf.tlf036,g_tlf.tlf026,'',g_tlf.tlf01,g_tlf.tlf031,'','',l_plant_new) RETURNING g_tlf.tlf14   #TQC-D20050
          IF cl_null(g_tlf.tlf14) THEN
             CALL cl_err(g_tlf.tlf14,'aim-425',1)
             LET g_success="N"
             RETURN
          END IF
       END IF
    END IF
    #FUN-CB0087--add--end-- 
#MOD-CC0289 add begin---------------------------------------------- 
    #依參考成本參數檔(ccz_file)中ccz28的值更新tlfcost的值  
    #當ccz28='1' OR '2'時,tlfcost=' '
    #當ccz28='3'時       ,tlfcost=批號 tlf904(tlf023/tlf033)
    #當ccz28='4'時       ,tlfcost=專案號 tlf20
    #當ccz28='5'時       ,tlfcost=倉庫
    SELECT ccz28 INTO l_ccz28 FROM ccz_file WHERE ccz00='0'
    CASE 
       WHEN l_ccz28='1' OR l_ccz28='2'
          LET g_tlf.tlfcost=' '
       WHEN l_ccz28='3'   #批號
          IF g_tlf.tlf904 IS NULL THEN LET g_tlf.tlf904=' ' END IF
          LET g_tlf.tlfcost=g_tlf.tlf904
       WHEN l_ccz28='4'   #專案編號
          IF g_tlf.tlf20 IS NULL THEN LET g_tlf.tlf20=' ' END IF
          LET g_tlf.tlfcost=g_tlf.tlf20
       WHEN l_ccz28='5'   #倉庫
          IF g_tlf.tlf901 IS NULL THEN LET g_tlf.tlf901=' ' END IF 
          LET g_tlf.tlfcost=g_tlf.tlf901                         
    END CASE
#MOD-CC0289 add end----------------------------------------------     

    #No.FUN-CC0157(S)
    CASE 
      WHEN g_tlf.tlf13 MATCHES 'axmt*' 
           CALL s_tlf920('1',g_tlf.tlf905) RETURNING g_tlf.tlf920
      WHEN g_tlf.tlf13 MATCHES 'aomt*' 
           CALL s_tlf920('2',g_tlf.tlf905) RETURNING g_tlf.tlf920
    END CASE
    #No.FUN-CC0157(E)

    #LET l_sql2="INSERT INTO ",l_dbs_tra CLIPPED,"tlf_file", #FUN-980092
    LET l_sql2="INSERT INTO ",cl_get_target_table(l_plant_new,'tlf_file'), #FUN-A50102
      "(tlf01,tlf020,tlf02,tlf021,tlf022,",
      " tlf023,tlf024,tlf025,tlf026,tlf027,",
      " tlf03,tlf031,tlf032,tlf033,tlf034,",
      " tlf035,tlf036,tlf037,tlf04,tlf05,",
      " tlf06,tlf07,tlf08,tlf09,tlf10,",
      " tlf11,tlf12,tlf13,tlf14,tlf15,",
      " tlf16,tlf17,tlf18,tlf19,tlf20,",
      " tlf60,tlf61,tlf62,tlf63,tlf99, ",
      " tlf902,tlf903,tlf904,tlf905,tlf906,",
      " tlf907,tlf930,tlfplant,tlflegal,tlfcost,tlf920)", #FUN-980006 add tlfplant,tlflegal #CHI-9B0008 #MOD-CC0289 add tlfcost #FUN-CC0157 add tlf920
      " VALUES( ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
      "         ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
      "         ?,?,?,?,?, ?,?,?,?,?,?) "       #FUN-980006 add ?,?  #CHI-9B0008 #MOD-CC0289 add tlfcost #FUN-CC0157 
    CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
    CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
    PREPARE ins_tlf FROM l_sql2
    EXECUTE ins_tlf USING 
       g_tlf.tlf01,g_tlf.tlf020,g_tlf.tlf02,g_tlf.tlf021,g_tlf.tlf022,
       g_tlf.tlf023,g_tlf.tlf024,g_tlf.tlf025,g_tlf.tlf026,g_tlf.tlf027,
       g_tlf.tlf03,g_tlf.tlf031,g_tlf.tlf032,g_tlf.tlf033,g_tlf.tlf034,
       g_tlf.tlf035,g_tlf.tlf036,g_tlf.tlf037,g_tlf.tlf04,g_tlf.tlf05,
       g_tlf.tlf06,g_tlf.tlf07,g_tlf.tlf08,g_tlf.tlf09,g_tlf.tlf10,
       g_tlf.tlf11,g_tlf.tlf12,g_tlf.tlf13,g_tlf.tlf14,g_tlf.tlf15,
       g_tlf.tlf16,g_tlf.tlf17,g_tlf.tlf18,g_tlf.tlf19,g_tlf.tlf20,
       g_tlf.tlf60,g_tlf.tlf61,g_tlf.tlf62,g_tlf.tlf63,g_tlf.tlf99,
       g_tlf.tlf902,g_tlf.tlf903,g_tlf.tlf904,g_tlf.tlf905,g_tlf.tlf906,
       g_tlf.tlf907,g_tlf.tlf930,l_plant,l_legal,g_tlf.tlfcost,g_tlf.tlf920  #FUN-980006 add l_plant,l_legal   #CHI-9B0008 #FUN-CC0157 add tlf920
   IF SQLCA.sqlcode<>0 THEN  #MOD-CC0289 add tlfcost
      IF g_bgerr THEN
         CALL s_errmsg("","","ins tlf:",SQLCA.sqlcode,1)
      ELSE
         CALL cl_err3("","","","",SQLCA.sqlcode,"","ins tlf:",1)
      END IF
      LET g_success = 'N'
   END IF
#FUN-BC0062 ------------Begin-----------		
   #計算異動加權平均成本		
   IF NOT s_tlf_mvcost(l_plant_new) THEN		
      IF g_bgerr THEN
         CALL s_errmsg("","","ins cfa:",SQLCA.sqlcode,1)
      ELSE
         CALL cl_err3("","","","",SQLCA.sqlcode,"","ins cfa:",1)
      END IF
      LET g_success = 'N'
   END IF		
#FUN-BC0062 ------------End-------------		

   IF g_sma.sma115 = 'Y' THEN  #No.CHI-760003  
   IF g_ima906 = '2' OR g_ima906 = '3' THEN
   FOR l_l = 1 TO 2
      IF l_l = 1 AND g_ima906 = '3' THEN 
         CONTINUE FOR
      END IF
   LET g_tlff.tlff01=p_part               #異動料件編號
   #----來源----
   IF p_sta = '1' OR p_sta='2' THEN
      IF p_sta = '1' THEN
         LET g_tlff.tlff02=50             #'Stock'
         LET g_tlff.tlff021=p_ware        #倉庫
         LET g_tlff.tlff022=p_loca        #儲位
         LET g_tlff.tlff023=p_lot         #批號
      ELSE
         LET g_tlff.tlff02=10
         LET g_tlff.tlff021=' '           #倉庫
         LET g_tlff.tlff022=' '           #儲位
         LET g_tlff.tlff023=' '           #批號
      END IF
      LET g_tlff.tlff020=l_azp.azp01
      IF cl_null(g_tlff.tlff023) THEN LET g_tlff.tlff023=' ' END IF
      LET g_tlff.tlff024=''              #異動后數量
      IF l_l = 1 THEN 
         LET g_tlff.tlff025 = g_rvv.rvv80
         LET g_tlff.tlff219=2             #No.FUN-620025
         LET g_tlff.tlff220=g_rvv.rvv80   #No.FUN-620025 
      ELSE 
         LET g_tlff.tlff025 = g_rvv.rvv83
         LET g_tlff.tlff219=1             #No.FUN-620025
         LET g_tlff.tlff220=g_rvv.rvv83   #No.FUN-620025 
      END IF
   ELSE
      IF p_sta = '4' THEN                        #代送銷退單
         LET g_tlff.tlff02  = 731               
         LET g_tlff.tlff021 = ''                 #倉庫  
         LET g_tlff.tlff022 = ''                 #儲位  
         LET g_tlff.tlff023 = ''                 #批號  
         LET g_tlff.tlff020 = '' 
         LET g_tlff.tlff024 = 0 
         IF l_l = 1 THEN         
            LET g_tlff.tlff025 = l_ohb.ohb910      
            LET g_tlff.tlff219 = 2             #No.FUN-620025                                                                            
            LET g_tlff.tlff220 = l_ohb.ohb910  #No.FUN-620025
         ELSE         
            LET g_tlff.tlff025 = l_ohb.ohb913      
            LET g_tlff.tlff219 = 1             #No.FUN-620025                                                                            
            LET g_tlff.tlff220 = l_ohb.ohb913  #No.FUN-620025            
         END IF  
      ELSE
         LET g_tlff.tlff02=20
         LET g_tlff.tlff021=' '
         LET g_tlff.tlff022=' '
         LET g_tlff.tlff023=' '
         LET g_tlff.tlff024=' '
         LET g_tlff.tlff025=' '
         IF l_l = 1 THEN                                                                         
            LET g_tlff.tlff219=2                                                                                        
            LET g_tlff.tlff220=g_rvv.rvv80                                                                            
         ELSE                                                                                                                          
            LET g_tlff.tlff219=1                                                                                  
            LET g_tlff.tlff220=g_rvv.rvv83                                                                             
         END IF                                              
      END IF                                     #No.FUN-620025 
   END IF
   CASE p_sta
      WHEN '1' #出貨單
        LET g_tlff.tlff026 = l_ogb.ogb01       #異動單號  
        LET g_tlff.tlff027 = l_ogb.ogb03       #異動項次  
      WHEN '2' #收貨單
        LET g_tlff.tlff026 = l_rvb.rvb04       #異動單號  
        LET g_tlff.tlff027 = l_rvb.rvb03       #異動項次  
      WHEN '3' #入庫單
        LET g_tlff.tlff026 = l_rvv.rvv04       #異動單號  
        LET g_tlff.tlff027 = l_rvv.rvv05       #異動項次  
      WHEN '4' #代送銷退單
        LET g_tlff.tlff026 = l_oha.oha01   
        LET g_tlff.tlff027 = l_ohb.ohb03  
   END CASE
   #---目的----
   IF p_sta = '3' OR p_sta = '2' THEN
      IF p_sta='3' THEN
         LET g_tlff.tlff03=50
         IF l_l = 1 THEN
            LET g_tlff.tlff035=g_rvv.rvv80
         ELSE
            LET g_tlff.tlff035=g_rvv.rvv83
         END IF 
      ELSE
         LET g_tlff.tlff03=20
         LET g_tlff.tlff035=''
      END IF
      LET g_tlff.tlff031=p_ware
      LET g_tlff.tlff032=p_loca
      LET g_tlff.tlff033=p_lot
      IF cl_null(g_tlff.tlff033) THEN LET g_tlff.tlff033=' ' END IF
      LET g_tlff.tlff034=''
   ELSE  
      IF p_sta = '4' THEN                        #代送銷退單    
         LET g_tlff.tlff03  = 50      
         LET g_tlff.tlff030 = ''      
         LET g_tlff.tlff031 = p_ware      
         LET g_tlff.tlff032 = p_loca      
         LET g_tlff.tlff033 = p_lot      
         LET g_tlff.tlff034 = l_qoh      
         IF l_l = 1 THEN         
            LET g_tlff.tlff035 = l_ohb.ohb910    #庫存單位(ima_file or img_file)      
         ELSE         
            LET g_tlff.tlff035 = l_ohb.ohb913      
         END IF                 
      ELSE 
         LET g_tlff.tlff03 =724
         LET g_tlff.tlff030=' '
         LET g_tlff.tlff031=' '                  #倉庫
         LET g_tlff.tlff032=' '                  #儲位
         LET g_tlff.tlff033=' '                  #批號
         LET g_tlff.tlff034=' '                  #異動后庫存數量
         LET g_tlff.tlff035=' '                  #庫存單位
      END IF                                     #No.FUN-620025  
   END IF
   CASE p_sta
      WHEN '1' #出貨單
        LET g_tlff.tlff036 = l_ogb.ogb31       #異動單號  no.6178
        LET g_tlff.tlff037 = l_ogb.ogb32       #異動項次  no.6178
      WHEN '2' #收貨單
        LET g_tlff.tlff036 = l_rvb.rvb01       #異動單號  no.6178
        LET g_tlff.tlff037 = l_rvb.rvb02       #異動項次  no.6178
      WHEN '3' #入庫單
        LET g_tlff.tlff036 = l_rvv.rvv01       #異動單號  no.6178
        LET g_tlff.tlff037 = l_rvv.rvv02       #異動項次  no.6178
      WHEN '4' #代送銷退單
        LET g_tlff.tlff036 = l_oha.oha01   
        LET g_tlff.tlff037 = l_ohb.ohb03  
   END CASE
   #-->異動數量
   LET g_tlff.tlff04= ' '                #工作站
   LET g_tlff.tlff05= ' '                #作業序號
   LET g_tlff.tlff06=g_rvu.rvu03         #發料日期
   LET g_tlff.tlff07=g_today             #異動資料產生日期  
   LET g_tlff.tlff08=TIME                #異動資料產生時:分:秒
   LET g_tlff.tlff09=g_user              #產生人
   IF l_l = 1 THEN
      LET g_tlff.tlff10=g_rvv.rvv82
      LET g_tlff.tlff11=g_rvv.rvv80
      LET g_tlff.tlff12=g_rvv.rvv81     #發料/庫存 換算率
      LET p_unit = g_tlff.tlff11        #No.FUN-620025    
   ELSE
      LET g_tlff.tlff10=g_rvv.rvv85
      LET g_tlff.tlff11=g_rvv.rvv83
      LET g_tlff.tlff12=g_rvv.rvv84     #發料/庫存 換算率
      LET p_unit2 = g_tlff.tlff11       #No.FUN-620025 
   END IF
      
   CASE p_sta
        WHEN '1' LET g_tlff.tlff13='axmt620'
        WHEN '2' LET g_tlff.tlff13='apmt1101'
        WHEN '3' LET g_tlff.tlff13='apmt150'
        WHEN '4' LET g_tlff.tlff13='aomt800'     #No.FUN-620025
   END CASE
   LET g_tlff.tlff14=' '              #異動原因
 
   LET g_tlff.tlff17=' '              #非庫存性料件編號
   IF l_l = 1 THEN
      SELECT imgg10 INTO l_imgg10 FROM imgg_file
             WHERE imgg01= p_part AND imgg02 = p_ware AND imgg03 = p_loca AND
                   imgg04 = p_lot AND imgg09 = g_rvv.rvv80
   ELSE
      SELECT imgg10 INTO l_imgg10 FROM imgg_file
             WHERE imgg01= p_part AND imgg02 = p_ware AND imgg03 = p_loca AND
                   imgg04 = p_lot AND imgg09 = g_rvv.rvv83
   END IF
   CASE p_sta
        WHEN '1' 
           IF l_l = 1 THEN
              LET l_imgg10 = l_imgg10 - g_rvv.rvv82
           ELSE 
              LET l_imgg10 = l_imgg10 - g_rvv.rvv85
           END IF
        WHEN '2' 
           IF l_l = 1 THEN
              LET l_imgg10 = l_imgg10 + g_rvv.rvv82
           ELSE 
              LET l_imgg10 = l_imgg10 + g_rvv.rvv85
           END IF
        WHEN '3' 
           IF l_l = 1 THEN
              LET l_imgg10 = l_imgg10 + g_rvv.rvv82
           ELSE 
              LET l_imgg10 = l_imgg10 + g_rvv.rvv85
           END IF
        WHEN '4' 
           IF l_l = 1 THEN
              LET l_imgg10 = l_imgg10 - l_ohb.ohb912
           ELSE 
              LET l_imgg10 = l_imgg10 - l_ohb.ohb915
           END IF
   END CASE 
   LET g_tlff.tlff18=l_imgg10
   CASE p_sta
        WHEN '1' LET g_tlff.tlff19=g_poz.poz04   #no.6178 送貨客戶
        WHEN '2' LET g_tlff.tlff19=p_pmm09
        WHEN '3'
          IF NOT cl_null(l_rvu.rvu04) THEN
             LET g_tlff.tlff19 = l_rvu.rvu04
          ELSE  
             LET g_tlff.tlff19=p_pmm09 
          END IF
        WHEN '4' LET g_tlff.tlff19=l_oha.oha1016 #No.FUN-620025
   END CASE
   LET g_tlff.tlff20= ' '     
   IF l_l = 1 THEN
      LET g_tlff.tlff60=g_rvv.rvv81
   ELSE
      LET g_tlff.tlff60=g_rvv.rvv84
   END IF
   LET g_tlff.tlff62=l_rvv.rvv01    #參考單號(入庫)   #No.FUN-620025
   LET g_tlff.tlff63=g_rvv.rvv02    #入庫項次
   CASE WHEN  g_tlff.tlff02=50 
              LET g_tlff.tlff902=g_tlff.tlff021
              LET g_tlff.tlff903=g_tlff.tlff022
              LET g_tlff.tlff904=g_tlff.tlff023
              LET g_tlff.tlff905=g_tlff.tlff026
              LET g_tlff.tlff906=g_tlff.tlff027
              LET g_tlff.tlff907=-1
        WHEN  g_tlff.tlff03=50 
              LET g_tlff.tlff902=g_tlff.tlff031
              LET g_tlff.tlff903=g_tlff.tlff032
              LET g_tlff.tlff904=g_tlff.tlff033
              LET g_tlff.tlff905=g_tlff.tlff036
              LET g_tlff.tlff906=g_tlff.tlff037
              LET g_tlff.tlff907=1
        OTHERWISE
#CHI-C80009---mark---START----------------------
#             LET g_tlff.tlff902=' '
#             LET g_tlff.tlff903=' '
#             LET g_tlff.tlff904=' '
#             LET g_tlff.tlff905=' '
#             LET g_tlff.tlff906=0
#             LET g_tlff.tlff907=0
#CHI-C80009---mark-----END----------------------
#CHI-C80009---add---START
              LET g_tlff.tlff902=g_tlff.tlff031
              LET g_tlff.tlff903=g_tlff.tlff032
              LET g_tlff.tlff904=g_tlff.tlff033
              LET g_tlff.tlff905=g_tlff.tlff036
              LET g_tlff.tlff906=g_tlff.tlff037
              LET g_tlff.tlff907=0 
#CHI-C 80009---add-----END
   END  CASE
   LET  g_tlff.tlff99 = g_flow99  #No.8106
   IF  g_tlff.tlff902 IS NULL THEN LET g_tlff.tlff902 = ' ' END IF
   IF  g_tlff.tlff903 IS NULL THEN LET g_tlff.tlff903 = ' ' END IF
   IF  g_tlff.tlff904 IS NULL THEN LET g_tlff.tlff904 = ' ' END IF
   LET  g_tlff.tlff61=s_get_doc_no(g_tlff.tlff905)
   CASE p_sta
       WHEN '1' #出貨單
         LET g_tlff.tlff930 = l_ogb.ogb930       
       WHEN '2' #收貨單
         LET g_tlff.tlff930 = l_rvb.rvb930       
       WHEN '3' #入庫單
        LET g_tlff.tlff930 = l_rvv.rvv930       
   END CASE
 
   IF g_tlff.tlff10 IS NULL OR g_tlff.tlff10 = 0 OR                                                                              
      g_tlff.tlff11 IS NULL  THEN                                                                                                
        CONTINUE FOR                                                                                                             
   END IF                                                                                                                        
   IF l_l = 1 THEN                                                                                                               
      LET p_unit = g_tlff.tlff11                                                                                                 
   ELSE                                                                                                                          
      LET p_unit2 = g_tlff.tlff11                                                                                                
   END IF                                                                                                                        
    IF cl_null(g_tlff.tlff012) THEN LET g_tlff.tlff012 = ' ' END IF      #FUN-B90012
    IF cl_null(g_tlff.tlff013) THEN LET g_tlff.tlff013 = 0   END IF      #FUN-B90012
    #LET l_sql5="INSERT INTO ",l_dbs_tra CLIPPED,"tlff_file",  #FUN-980092
    LET l_sql5="INSERT INTO ",cl_get_target_table(l_plant_new,'tlff_file'), #FUN-A50102
               "(tlff01,tlff020,tlff02,tlff021,tlff022,", 
               " tlff023,tlff024,tlff025,tlff026,tlff027,",
               " tlff03,tlff031,tlff032,tlff033,tlff034,",
               " tlff035,tlff036,tlff037,tlff04,tlff05,",
               " tlff06,tlff07,tlff08,tlff09,tlff10,",
               " tlff11,tlff12,tlff13,tlff14,tlff15,",
               " tlff16,tlff17,tlff18,tlff19,tlff20,",
               " tlff219,tlff220,tlff60,tlff61,tlff62,",            #No.FUN-620025
               " tlff63,tlff99,tlff902,tlff903,tlff904, ",
               " tlff905,tlff906,tlff907,tlff930,tlffplant,",       #FUN-980006 add tlffplant #CHI-9B0008
               " tlfflegal,tlff012,tlff013 )",                      #FUN-980006 add tlfflegal #FUN-B90012 add tlff012,tlff013
               " VALUES( ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "         ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
               "         ?,?,?,?,?, ?,?,?,?,?, ?,?,?) "             #No.FUN-620025 #FUN-980006 add ?,? #CHI-9B0008   #FUN-B90012
    CALL cl_replace_sqldb(l_sql5) RETURNING l_sql5        #FUN-920032
    CALL cl_parse_qry_sql(l_sql5,l_plant_new) RETURNING l_sql5 #FUN-A50102
    PREPARE ins_tlff FROM l_sql5
    EXECUTE ins_tlff USING 
       g_tlff.tlff01,g_tlff.tlff020,g_tlff.tlff02,g_tlff.tlff021,g_tlff.tlff022,
       g_tlff.tlff023,g_tlff.tlff024,g_tlff.tlff025,g_tlff.tlff026,g_tlff.tlff027,
       g_tlff.tlff03,g_tlff.tlff031,g_tlff.tlff032,g_tlff.tlff033,g_tlff.tlff034,
       g_tlff.tlff035,g_tlff.tlff036,g_tlff.tlff037,g_tlff.tlff04,g_tlff.tlff05,
       g_tlff.tlff06,g_tlff.tlff07,g_tlff.tlff08,g_tlff.tlff09,g_tlff.tlff10,
       g_tlff.tlff11,g_tlff.tlff12,g_tlff.tlff13,g_tlff.tlff14,g_tlff.tlff15,
       g_tlff.tlff16,g_tlff.tlff17,g_tlff.tlff18,g_tlff.tlff19,g_tlff.tlff20,
       g_tlff.tlff219,g_tlff.tlff220,g_tlff.tlff60,g_tlff.tlff61,g_tlff.tlff62,
       g_tlff.tlff63,g_tlff.tlff99,g_tlff.tlff902,g_tlff.tlff903,g_tlff.tlff904,
       g_tlff.tlff905,g_tlff.tlff906,g_tlff.tlff907,g_tlff.tlff930,l_plant,          #FUN-980006 add l_plant #CHI-9B0008 
       l_legal,g_tlff.tlff012,g_tlff.tlff013                                         #FUN-980006 add l_legal #FUN-B90012 add tlff012,tlff013
       IF SQLCA.sqlcode<>0 THEN
          IF g_bgerr THEN
             CALL s_errmsg("","","ins tlff:",SQLCA.sqlcode,1)
          ELSE
             CALL cl_err3("","","","",SQLCA.sqlcode,"","ins tlff:",1)
          END IF
          LET g_success = 'N'
       END IF 
   END FOR
   CALL s_tlff3(p_unit,p_unit2,l_plant_new)   #FUN-980092
   END IF
   END IF #No.CHI-760003 
END FUNCTION
 
FUNCTION p822_ima(p_part)
 DEFINE p_part  LIKE ima_file.ima01
 DEFINE l_ima02 LIKE ima_file.ima02
 DEFINE l_ima25 LIKE ima_file.ima25
# DEFINE l_qoh   LIKE ima_file.ima262 #FUN-A20044
 DEFINE l_qoh   LIKE type_file.num15_3 #FUN-A20044
 DEFINE l_ima86 LIKE ima_file.ima86
 DEFINE l_ima39 LIKE ima_file.ima39
 DEFINE l_ima35 LIKE ima_file.ima35
 DEFINE l_ima36 LIKE ima_file.ima36
 DEFINE l_sql1  LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(600)
 DEFINE l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk LIKE type_file.num15_3 #FUN-A20044  
     #抓取料件相關資料
#     LET l_sql1 = "SELECT ima02,ima25,ima261+ima262,ima86,ima39,", #FUN-A20044
     LET l_sql1 = "SELECT ima02,ima25,0,ima86,ima39,", #FUN-A20044
                  "       ima35,ima36 ",
                  #" FROM ",l_dbs_new CLIPPED,"ima_file ",
                  " FROM ",cl_get_target_table(l_plant_new,'ima_file'), #FUN-A50102
                  " WHERE ima01='",p_part,"' " 
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-A50102
     PREPARE ima_pre FROM l_sql1
     IF STATUS THEN
        IF g_bgerr THEN
           CALL s_errmsg("ima01",p_part,"",SQLCA.sqlcode,1)  #No.TQC-740094
        ELSE
           CALL cl_err3("","","","",SQLCA.sqlcode,"","",1)
        END IF
     END IF
     DECLARE ima_cs CURSOR FOR ima_pre
     OPEN ima_cs
     FETCH ima_cs INTO l_ima02,l_ima25,l_qoh,l_ima86,l_ima39,l_ima35,l_ima36 
        CALL s_getstock(p_part,g_plant)RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk #FUN-A20044     
           LET l_qoh = l_unavl_stk + l_avl_stk #FUN-A20044 
     IF SQLCA.SQLCODE <> 0 THEN
        IF g_bgerr THEN
           CALL s_errmsg("ima01",p_part,"","mfg1201",1)  #No.TQC-740094
        ELSE
           CALL cl_err(l_dbs_new,'mfg1201',1) #No.7176
        END IF
        LET g_success='N'
     END IF
     CLOSE ima_cs
     RETURN l_ima02,l_ima25,l_qoh,l_ima86,l_ima39,l_ima35,l_ima36
END FUNCTION
 
#FUNCTION p822_imd(p_imd01,p_dbs)
FUNCTION p822_imd(p_imd01,p_dbs,l_plant)  #FUN-A50102
  DEFINE p_imd01   LIKE imd_file.imd01,
         l_imd11   LIKE imd_file.imd11,
         p_dbs     LIKE type_file.chr21,  #No.FUN-680136 VARCHAR(21)
         l_plant   LIKE type_file.chr21,  #FUN-A50102
         l_sql     LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(400)
 
   LET g_errno=''
   #LET l_sql="SELECT imd10,imd11,imd12,imd13,imd14,imd15  FROM ",p_dbs CLIPPED,"imd_file",  #MOD-6C0086 modify
   LET l_sql="SELECT imd10,imd11,imd12,imd13,imd14,imd15  FROM ",cl_get_target_table(l_plant,'imd_file'), #FUN-A50102
             " WHERE imd01 = '",p_imd01,"'",
             "   AND imd10 = 'S' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
   PREPARE imd_pre FROM l_sql
   DECLARE imd_cs CURSOR FOR imd_pre
   OPEN imd_cs
   FETCH imd_cs INTO g_imd10,g_imd11,g_imd12,g_imd13,g_imd14,g_imd15
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg4020'
        WHEN g_imd11 ='N'         LET g_errno = 'mfg6080'    #TQC-690057 modify l_imd11->g_imd11
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF NOT cl_null(g_errno) THEN
      LET g_success = 'N'
      IF g_bgerr THEN
         CALL s_errmsg("imd01",p_imd01,p_dbs,g_errno,1)  #No.TQC-740094
      ELSE
         CALL cl_err3("","","","",g_errno,"",p_dbs,1)
      END IF
   END IF
   CLOSE imd_cs
END FUNCTION
 
#No.8106 取得多角序號
FUNCTION p822_flow99()
     
     IF cl_null(g_rvu.rvu99) THEN
        CALL s_flowauno('rvu',g_pmm.pmm904,g_rvu.rvu03)
             RETURNING g_sw,g_flow99
        IF g_sw THEN
           IF g_bgerr THEN
              CALL s_errmsg("","","","tri-011",1)
           ELSE
              CALL cl_err3("","","","","tri-011","","",1)
           END IF
           LET g_success = 'N' RETURN
        END IF
        UPDATE rvu_file SET rvu99 = g_flow99 WHERE rvu01 = g_rvu.rvu01
        IF SQLCA.SQLCODE THEN
           IF g_bgerr THEN
              CALL s_errmsg("rvu01",g_rvu.rvu01,"upd rvu99",SQLCA.sqlcode,1)
           ELSE
              CALL cl_err3("upd","rvu_file",g_rvu.rvu01,"",SQLCA.sqlcode,"","upd rvu99",1)
           END IF
           LET g_success = 'N' RETURN
        END IF
        UPDATE rva_file SET rva99 = g_flow99 WHERE rva01 = g_rvu.rvu02
        IF SQLCA.SQLCODE THEN
           IF g_bgerr THEN
              CALL s_errmsg("rva01",g_rvu.rvu02,"upd rva99",SQLCA.sqlcode,1)
           ELSE
              CALL cl_err3("upd","rva_file",g_rvu.rvu02,"",SQLCA.sqlcode,"","upd rva99",1)
           END IF
           LET g_success = 'N' RETURN
        END IF
        #馬上檢查是否有搶號
        LET g_cnt = 0 
        SELECT COUNT(*) INTO g_cnt FROM rvu_file 
         WHERE rvu99 = g_flow99 AND rvu00 = '1'
        IF g_cnt > 1 THEN
           IF g_bgerr THEN
              CALL s_errmsg("rvu99",g_flow99,"","tri-011",1)  #No.TQC-740094
           ELSE
              CALL cl_err3("","","","","tri-011","","",1)
           END IF
           LET g_success = 'N' RETURN
        END IF
     END IF
END FUNCTION 
 
#因為各單據的xxx99欄位在資料庫非Unique,
#所以為了安全還是給它檢查一下
FUNCTION p822_chk99()
  DEFINE l_sql LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(500)
 
     LET g_cnt = 0 
     #LET l_sql = " SELECT COUNT(*) FROM ",l_dbs_tra CLIPPED,"rva_file ", #FUN-980092
     LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new,'rva_file'), #FUN-A50102
                 "  WHERE rva99 ='",g_flow99,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
     PREPARE rvacnt_pre FROM l_sql
     DECLARE rvacnt_cs CURSOR FOR rvacnt_pre
     OPEN rvacnt_cs 
     FETCH rvacnt_cs INTO g_cnt                                #收貨單
     IF g_cnt > 0 THEN
        LET g_msg = l_dbs_new CLIPPED,'rva99 duplicate'
       IF g_bgerr THEN
          CALL s_errmsg("rva99",g_flow99,g_msg,"tri-011",1)  #No.TQC-740094
       ELSE
          CALL cl_err3("","","","","tri-011","",g_msg,1)
       END IF
        LET g_success = 'N'
     END IF
 
     #LET l_sql = " SELECT COUNT(*) FROM ",l_dbs_tra CLIPPED,"rvu_file ", #FUN-980092
     LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new,'rvu_file'), #FUN-A50102
                 "  WHERE rvu99 ='",g_flow99,"'",
                 "    AND rvu00 = '1' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
     PREPARE rvucnt_pre FROM l_sql
     DECLARE rvucnt_cs CURSOR FOR rvucnt_pre
     OPEN rvucnt_cs 
     FETCH rvucnt_cs INTO g_cnt                                #入庫單
     IF g_cnt > 0 THEN
        LET g_msg = l_dbs_new CLIPPED,'rvu99 duplicate'
        IF g_bgerr THEN
           CALL s_errmsg("rvu99",g_flow99,g_msg,"tri-011",1)  #No.TQC-740094
        ELSE
           CALL cl_err3("","","","","tri-011","",g_msg,1)
        END IF
        LET g_success = 'N'
     END IF
 
     #LET l_sql = " SELECT COUNT(*) FROM ",l_dbs_tra CLIPPED,"oga_file ",
     LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new,'oga_file'), #FUN-A50102
                 "  WHERE oga99 ='",g_flow99,"'",
                 "    AND oga09 = '6' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
     PREPARE ogacnt_pre FROM l_sql
     DECLARE ogacnt_cs CURSOR FOR ogacnt_pre
     OPEN ogacnt_cs 
     FETCH ogacnt_cs INTO g_cnt                                #出貨單
     IF g_cnt > 0 THEN
        LET g_msg = l_dbs_new CLIPPED,'oga99 duplicate'
        IF g_bgerr THEN
           CALL s_errmsg("oga99",g_flow99,g_msg,"tri-011",1)  #No.TQC-740094
        ELSE
           CALL cl_err3("","","","","tri-011","",g_msg,1)
        END IF
        LET g_success = 'N'
     END IF
END FUNCTION
FUNCTION p822_ohains()   
  DEFINE l_t            LIKE type_file.chr3,    #No.FUN-680136 VARCHAR(3)
         l_oayauno      LIKE oay_file.oayauno,
         l_oay17        LIKE oay_file.oay17,
         l_oay18        LIKE oay_file.oay18,
         l_oay20        LIKE oay_file.oay20,
         l_occ07        LIKE occ_file.occ07,
         l_occ08        LIKE occ_file.occ08,
         l_occ09        LIKE occ_file.occ09,
         l_occ1023      LIKE occ_file.occ1023,
         l_occ1005      LIKE occ_file.occ1005,
         l_occ1006      LIKE occ_file.occ1006,
         l_occ1022      LIKE occ_file.occ1022, 
         l_occ02        LIKE occ_file.occ02,
         l_occ11        LIKE occ_file.occ11, 
         l_sql          STRING,                 #No.CHI-950020
         l_sql1         LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(1200)
         l_sql2         LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(1200)
         l_sql3         LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(1200)
         li_result      LIKE type_file.num5      #No.FUN-680136 SMALLINT
   DEFINE l_plant  LIKE azp_file.azp01    #FUN-980006 add
   DEFINE l_legal  LIKE oga_file.ogalegal #FUN-980006 add
   
     LET l_plant = g_poy.poy04  #FUN-980006 add 
     CALL s_getlegal(l_plant) RETURNING l_legal  #FUN-980006 add
 
 
   INITIALIZE l_oha.* TO NULL                    #生成代送銷退單單頭  
   LET l_t = s_get_doc_no(l_oga.oga01)           #取得產生銷退單別 
   LET l_sql1 = "SELECT oayauno,oay17,oay18,oay20 ",                                                                                            
                #" FROM ",l_dbs_new CLIPPED,"oay_file ", 
                " FROM ",cl_get_target_table(l_plant_new,'oay_file'), #FUN-A50102                 
                " WHERE oayslip='",l_t,"'"                                                                            
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-A50102
   PREPARE oay_p2 FROM l_sql1                                                                                               
   IF SQLCA.SQLCODE THEN  
      IF g_bgerr THEN
         CALL s_errmsg("oayslip",l_t,"oay_p2",SQLCA.sqlcode,1)  #No.TQC-740094
      ELSE
         CALL cl_err3("","","","",SQLCA.sqlcode,"","oay_p2",1)
      END IF
   END IF                                                                                                                   
   DECLARE oay_c2 CURSOR FOR oay_p2                                                                                         
   OPEN oay_c2                                                                                                              
   FETCH oay_c2 INTO l_oayauno,l_oay17,l_oay18,l_oay20                                                                                            
   IF SQLCA.SQLCODE <> 0 THEN                                                                                               
      LET g_success='N'                                                                                                     
      RETURN                                                                                                                
   ELSE 
      LET g_oay18=l_oay18 
   END IF                                                                                                                   
   CLOSE oay_c2                
 
       CALL s_auto_assign_no("axm",l_oay17,l_oga.oga02,"","oha_file","oha01", 
                             l_plant_new,"","")                                                   
            RETURNING li_result,g_oha01                                                                                             
       IF NOT li_result THEN                                                                                                     
          IF g_bgerr THEN
             LET g_msg = l_plant_new CLIPPED,g_oha01                        #TQC-9B0013
             CALL s_errmsg("oha01",g_oha01,g_msg CLIPPED,"mfg3046",1)       #TQC-9B0013
          ELSE
             CALL cl_err3("","","","","mfg3046","","",1)                    #TQC-9B0013
          END IF
          LET g_success = 'N'         
          RETURN      
       END IF         
   LET l_sql2 = "SELECT occ07,occ08,occ09,occ1023,occ1005,occ1006,occ1022 ",                                  
                #" FROM ",l_dbs_new CLIPPED,"occ_file ",
                " FROM ",cl_get_target_table(l_plant_new,'occ_file'), #FUN-A50102           
                " WHERE occ01='",l_oga.oga1004,"'"                                                                                        
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
   PREPARE occ_p3 FROM l_sql2                                                                                                       
   IF SQLCA.SQLCODE THEN    
      IF g_bgerr THEN
         CALL s_errmsg("occ01",l_oga.oga1004,"occ_p3",SQLCA.sqlcode,1)  #No.TQC-740094
      ELSE
         CALL cl_err3("","","","",SQLCA.sqlcode,"","occ_p3",1)
      END IF
   END IF                                                                                                                           
   DECLARE occ_c3 CURSOR FOR occ_p3                                                                                                 
   OPEN occ_c3                                                                                                                     
   FETCH occ_c3 INTO l_occ07,l_occ08,l_occ09,l_occ1023,l_occ1005,l_occ1006,l_occ1022                                   
   IF SQLCA.SQLCODE <> 0 THEN                                                                                                       
      IF g_bgerr THEN
         CALL s_errmsg("occ01",l_oga.oga1004,"fetch occ07",SQLCA.sqlcode,1)  #No.TQC-740094
      ELSE
         CALL cl_err3("","","","",SQLCA.sqlcode,"","fetch occ07",1)
      END IF
      LET g_success='N'                                                                                                             
      RETURN   
   ELSE
      IF cl_null(l_occ07)   THEN LET l_occ07  =' ' END IF                                                                              
      IF cl_null(l_occ08)   THEN LET l_occ08  =' ' END IF                                                                              
      IF cl_null(l_occ09)   THEN LET l_occ09  =' ' END IF                                                                              
      IF cl_null(l_occ1005) THEN LET l_occ1005=' ' END IF                                                                              
      IF cl_null(l_occ1006) THEN LET l_occ1006=' ' END IF                                                                              
      IF cl_null(l_occ1023) THEN LET l_occ1023=' ' END IF                                                                              
      IF cl_null(l_occ1022) THEN LET l_occ1022=' ' END IF                                   
   END IF                                                                                                                           
   CLOSE occ_c3                           
 
   LET l_sql3 = "SELECT occ02,occ11 ",                                  
                #" FROM ",l_dbs_new CLIPPED,"occ_file ", 
                " FROM ",cl_get_target_table(l_plant_new,'occ_file'), #FUN-A50102                 
                " WHERE occ01='",l_occ07,"'"                                                                                        
 	 CALL cl_replace_sqldb(l_sql3) RETURNING l_sql3        #FUN-920032
     CALL cl_parse_qry_sql(l_sql3,l_plant_new) RETURNING l_sql3 #FUN-A50102
   PREPARE occ_p FROM l_sql3                                                                                                       
   IF SQLCA.SQLCODE THEN         
      IF g_bgerr THEN
         CALL s_errmsg("occ01",l_occ07,"occ_p",SQLCA.sqlcode,1)  #No.TQC-740094
      ELSE
         CALL cl_err3("","","","",SQLCA.sqlcode,"","occ_p",1)
      END IF
   END IF                                                                                                                           
   DECLARE occ_c CURSOR FOR occ_p                                                                                                 
   OPEN occ_c                                                                                                                     
   FETCH occ_c INTO l_occ02,l_occ11                                     
   IF SQLCA.SQLCODE <> 0 THEN                                                                                                       
      IF g_bgerr THEN
         CALL s_errmsg("occ01",l_occ07,"fetch occ02",SQLCA.sqlcode,1)  #No.TQC-740094
      ELSE
         CALL cl_err3("","","","",SQLCA.sqlcode,"","fetch occ02",1)
      END IF
      LET g_success='N'                                                                                                             
      RETURN   
   ELSE
      IF cl_null(l_occ02) THEN LET l_occ02=' ' END IF                
      IF cl_null(l_occ11) THEN LET l_occ11=' ' END IF                                                     
   END IF                                                                                                                           
   CLOSE occ_c                              
 
   LET l_oha.oha01   = g_oha01                   #銷退單號
   LET l_oha.oha02   = l_oga.oga02               #銷退日期
   LET l_oha.oha03   = l_occ07                   #帳款客戶編號
   LET l_oha.oha032  = l_occ02                   #帳款客戶簡稱
   LET l_oha.oha04   = l_oga.oga1004             #退貨客戶編號︰代送商
   LET l_oha.oha05   = '1'                       #銷退別
   LET l_oha.oha08   = '1'                       #內銷
   LET l_oha.oha09   = '1'                       #銷退處理方式︰銷退折讓
   LET l_oha.oha10   = ''                        #帳單編號
   LET l_oha.oha14   = l_oga.oga14               #人員編號
   LET l_oha.oha15   = l_oga.oga15               #部門編號
   LET l_oha.oha16   = ''                        #出貨單號
   LET l_oha.oha17   = ''                        # RMA單號
   LET l_oha.oha21   = l_oga.oga21               #稅別
   LET l_oha.oha211  = l_oga.oga211              #稅率 
   LET l_oha.oha212  = l_oga.oga212              #聯數
   LET l_oha.oha213  = l_oga.oga213              #含稅否
   LET l_oha.oha23   = l_oga.oga23               #幣別
   LET l_oha.oha24   = l_oga.oga24               #匯率
   LET l_oha.oha25   = l_oga.oga25               #銷售分類一
   LET l_oha.oha26   = l_oga.oga26               #銷售分類二
   LET l_oha.oha31   = l_oga.oga31               #價格條件編號
   LET l_oha.oha41   ='N'                        #三角貿易銷退單否
   LET l_oha.oha42   ='N'                        #是否入庫存    
   LET l_oha.oha43   ='N'                        #起始三角貿易銷退單否
   LET l_oha.oha44   ='N'                        #拋轉否
   LET l_oha.oha50   = 0                         #原幣銷退金額(未稅)
   LET l_oha.oha53   = 0                         #原幣應開發票未稅金額
   LET l_oha.oha54   = 0                         #原幣已開發票未稅金額
   LET l_oha.oha99   = g_flow99                  #流程代碼
   LET l_oha.ohaconf = 'Y'                       #確認否/作廢碼
   LET l_oha.ohapost = 'Y'                       #銷退扣帳否
   LET l_oha.ohaprsw = 0                         #列印次數
   LET l_oha.ohauser = g_user                    #資料所有者
   LET l_oha.ohagrup = g_grup                    #資料所有部門
   LET l_oha.ohadate = g_today                   #最近修改日
   LET l_oha.oha1001 = l_occ1023                 #收款客戶編號
   LET l_oha.oha1002 = l_oay20                   #債權
   LET l_oha.oha1003 = l_oga.oga1003             #業績歸屬方
   LET l_oha.oha1004 = l_oay18                   #退貨原因碼
   LET l_oha.oha1005 = l_oga.oga1005             #是否計算業績
   LET l_oha.oha1006 = 0                         #折扣金額(未稅)
   LET l_oha.oha1007 = 0                         #折扣金額(含稅)
   LET l_oha.oha1008 = 0                         #銷退單總含稅金額
   LET l_oha.oha1009 = l_occ1006                 #客戶所屬渠道
   LET l_oha.oha1010 = l_occ1005                 #客戶所屬方
   LET l_oha.oha1011 = l_occ1022                 #開票客戶
   LET l_oha.oha1012 = ''                        #原始退單號       
   LET l_oha.oha1013 = ''                        #收料驗收單號
   LET l_oha.oha1014 = ''                        #代送商
   LET l_oha.oha1015 = 'Y'                       #是否對應代送出貨
   LET l_oha.oha1016 = l_oga.oga1004             #出貨單代送商
   LET l_oha.oha1017 = 0                         #導物流狀況碼
   LET l_oha.oha1018 = l_oga.oga01               #代送出貨單號
   LET l_oha.ohaoriu = g_user   #TQC-A10060  add
   LET l_oha.ohaorig = g_grup   #TQC-A10060  add
   LET l_oha.ohaud01 = l_oga.ogaud01
   LET l_oha.ohaud02 = l_oga.ogaud02
   LET l_oha.ohaud03 = l_oga.ogaud03
   LET l_oha.ohaud04 = l_oga.ogaud04
   LET l_oha.ohaud05 = l_oga.ogaud05
   LET l_oha.ohaud06 = l_oga.ogaud06
   LET l_oha.ohaud07 = l_oga.ogaud07
   LET l_oha.ohaud08 = l_oga.ogaud08
   LET l_oha.ohaud09 = l_oga.ogaud09
   LET l_oha.ohaud10 = l_oga.ogaud10
   LET l_oha.ohaud11 = l_oga.ogaud11
   LET l_oha.ohaud12 = l_oga.ogaud12
   LET l_oha.ohaud13 = l_oga.ogaud13
   LET l_oha.ohaud14 = l_oga.ogaud14
   LET l_oha.ohaud15 = l_oga.ogaud15
   #No.FUN-A10123 ...begin
   IF g_azw.azw04 = '2' THEN
      LET l_oha.oha85 = l_oga.oga85
      LET l_oha.oha86 = l_oga.oga86
      LET l_oha.oha87 = l_oga.oga87
      LET l_oha.oha88 = l_oga.oga88
      LET l_oha.oha89 = l_oga.oga89
      LET l_oha.oha90 = l_oga.oga90
      LET l_oha.oha91 = l_oga.oga91
      LET l_oha.oha92 = l_oga.oga92
      LET l_oha.oha93 = l_oga.oga93
      LET l_oha.oha94 = l_oga.oga94
      LET l_oha.oha95 = l_oga.oga95
      LET l_oha.oha96 = l_oga.oga96
      LET l_oha.oha97 = l_oga.oga97
    # LET l_oha.ohaconu = g_user    #TQC-A60075
    # LET l_oha.ohacond = g_today   #TQC-A60075
   END IF 
   LET l_oha.ohaconu = g_user     #TQC-A60075
   LET l_oha.ohacond = g_today    #TQC-A60075
   LET l_oha.ohacont = g_time     #TQC-B40073
   IF cl_null(l_oha.oha85) THEN LET l_oha.oha85 = ' ' END IF
   IF cl_null(l_oha.oha94) THEN LET l_oha.oha94 = 'N' END IF
   IF cl_null(l_oha.oha57) THEN LET l_oha.oha57 = '1' END IF  #FUN-AC0055 add
   #No.FUN-A10123 ...end
 
   #LET l_sql="INSERT INTO ",l_dbs_tra CLIPPED,"oha_file ",  #FUN-980092
   LET l_sql="INSERT INTO ",cl_get_target_table(l_plant_new,'oha_file'), #FUN-A50102
               "( oha01,oha02,oha03,oha032,oha04, ",                                                                                      
               "  oha05,oha08,oha09,oha10,oha14,",                                                                                     
               "  oha15,oha16,oha17,oha21,oha211,",                                                                                      
               "  oha212,oha213,oha23,oha24,oha25,",                                                                                        
               "  oha26,oha31,oha41,oha42,oha43,",                                                                                        
               "  oha44,oha50,oha53,oha54,oha99,ohaconf,",                       
               "  oha85,oha86,oha87,oha88,oha89,oha90,",   #No.FUN-A10123                     
               "  oha91,oha92,oha93,oha94,oha95,oha96,",   #No.FUN-A10123                     
               "  oha97,ohaconu,ohacond,ohacont,",         #No.FUN-A10123 #TQC-B40073
               "  ohapost,ohaprsw,ohauser,ohagrup,",                       
               "  ohadate,oha1001,oha1002,oha1003,oha1004,",                       
               "  oha1005,oha1006,oha1007,oha1008,oha1009,",                       
               "  oha1010,oha1011,oha1012,oha1013,oha1014,",                       
               "  oha1015,oha1016,oha1017,oha1018,ohaplant,ohalegal,ohaoriu,ohaorig, ", #TQC-A10060 add ohaoriu,ohaorig
               "  ohaud01,ohaud02,ohaud03,ohaud04,ohaud05,",
               "  ohaud06,ohaud07,ohaud08,ohaud09,ohaud10,",
               "  ohaud11,ohaud12,ohaud13,ohaud14,ohaud15,oha57)",    #FUN-AC0055 add oha57
               "  VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",                                                                      
                         "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",                                                                      
                         "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,",    #No.FUN-A10123                                                                     
                         "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,",    #No.CHI-950020
                         "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,?,?,", #TQC-A10060  add ?,?
                         "?,?,?,?, ?,?, ?,?,?,?) "  #FUN-980006 add ohaplant,ohalegal #TQC-B40073
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
   PREPARE ins_oha FROM l_sql                                                                                                    
   EXECUTE ins_oha USING                                                                                                          
      l_oha.oha01,l_oha.oha02,l_oha.oha03,l_oha.oha032,l_oha.oha04,
      l_oha.oha05,l_oha.oha08,l_oha.oha09,l_oha.oha10,l_oha.oha14,
      l_oha.oha15,l_oha.oha16,l_oha.oha17,l_oha.oha21,l_oha.oha211,
      l_oha.oha212,l_oha.oha213,l_oha.oha23,l_oha.oha24,l_oha.oha25,
      l_oha.oha26,l_oha.oha31,l_oha.oha41,l_oha.oha42,l_oha.oha43,
      l_oha.oha44,l_oha.oha50,l_oha.oha53,l_oha.oha54,l_oha.oha99,l_oha.ohaconf,
      l_oha.oha85,l_oha.oha86,l_oha.oha87,l_oha.oha88,l_oha.oha89,l_oha.oha90,   #No.FUN-A10123                     
      l_oha.oha91,l_oha.oha92,l_oha.oha93,l_oha.oha94,l_oha.oha95,l_oha.oha96,   #No.FUN-A10123                     
      l_oha.oha97,l_oha.ohaconu,l_oha.ohacond,l_oha.ohacont,                     #No.FUN-A10123 #TQC-B40073
      l_oha.ohapost,l_oha.ohaprsw,l_oha.ohauser,l_oha.ohagrup,
      l_oha.ohadate,l_oha.oha1001,l_oha.oha1002,l_oha.oha1003,l_oha.oha1004,
      l_oha.oha1005,l_oha.oha1006,l_oha.oha1007,l_oha.oha1008,l_oha.oha1009,
      l_oha.oha1010,l_oha.oha1011,l_oha.oha1012,l_oha.oha1013,l_oha.oha1014,
      l_oha.oha1015,l_oha.oha1016,l_oha.oha1017,l_oha.oha1018,l_plant,l_legal,l_oha.ohaoriu,l_oha.ohaorig #TQC-A10060 add oriu,orig  #FUN-980006 add l_plant,l_legal
     ,l_oha.ohaud01,l_oha.ohaud02,l_oha.ohaud03,l_oha.ohaud04,l_oha.ohaud05,
      l_oha.ohaud06,l_oha.ohaud07,l_oha.ohaud08,l_oha.ohaud09,l_oha.ohaud10,
      l_oha.ohaud11,l_oha.ohaud12,l_oha.ohaud13,l_oha.ohaud14,l_oha.ohaud15,l_oha.oha57  #FUN-AC0055 add oha57
   IF SQLCA.sqlcode<>0 THEN                                                                                                     
      IF g_bgerr THEN
         CALL s_errmsg("oha01",l_oha.oha01,"ins oha:",SQLCA.sqlcode,1)  #No.TQC-740094
      ELSE
         CALL cl_err3("","","","",SQLCA.sqlcode,"","ins oha:",1)
      END IF
      LET g_success = 'N'                                                                                                       
   END IF            
 
END FUNCTION           
 
FUNCTION p822_ohbins() 
  DEFINE l_occ1027     LIKE occ_file.occ1027, 
         l_ohb13       LIKE ohb_file.ohb13,
         l_ohb13t      LIKE ohb_file.ohb13,
         l_ohb14       LIKE ohb_file.ohb14,
         l_ohb14t      LIKE ohb_file.ohb14,
         l_ohb1001     LIKE ohb_file.ohb1001,
         l_ohb03       LIKE ohb_file.ohb03,
         l_sql         LIKE type_file.chr1000,  #No.FUN-680136 VARCHAR(1200)
         l_sql2        LIKE type_file.chr1000,  #No.FUN-680136 VARCHAR(1200)
         l_sql3        LIKE type_file.chr1000,     #No.FUN-680136 VARCHAR(1200)
         l_sql4        LIKE type_file.chr1000,    #No.FUN-680136 VARCHAR(1200)
         l_sql5        LIKE type_file.chr1000,   #No.FUN-680136 VARCHAR(1200)
         l_azf10       LIKE azf_file.azf10,      #No.FUN-6B0065
         l_unit        LIKE ogb_file.ogb05
 
   DEFINE l_plant  LIKE azp_file.azp01    #FUN-980006 add
   DEFINE l_legal  LIKE oga_file.ogalegal #FUN-980006 add
   DEFINE l_ohbi   RECORD LIKE ohbi_file.* #FUN-B70074      
#  DEFINE l_oia07  LIKE oia_file.oia07    #FUN-C50136
   DEFINE l_oha14         LIKE oha_file.oha14   #FUN-CB0087
   DEFINE l_oha15         LIKE oha_file.oha15   #FUN-CB0087
   
   LET l_plant = g_poy.poy04  #FUN-980006 add 
   CALL s_getlegal(l_plant) RETURNING l_legal  #FUN-980006 add
#生成代送銷退單單身 
   LET l_sql3 = "SELECT azf10 ",                                                                                                  
                #" FROM ",l_dbs_new CLIPPED,"azf_file ", 
                " FROM ",cl_get_target_table(l_plant_new,'azf_file'), #FUN-A50102              
                " WHERE azf01='",g_oay18,"'",
                " AND   azf02='2'",       #No.TQC-760054  #No.FUN-930104
                " AND   azf09='2'"        #No.FUN-930104
 	 CALL cl_replace_sqldb(l_sql3) RETURNING l_sql3        #FUN-920032
     CALL cl_parse_qry_sql(l_sql3,l_plant_new) RETURNING l_sql3 #FUN-A50102
   PREPARE azf_p1 FROM l_sql3                                                                                                       
   IF SQLCA.SQLCODE THEN     
      IF g_bgerr THEN
         CALL s_errmsg("azf01",g_oay18,"azf_p1",SQLCA.sqlcode,1)  #No.TQC-740094
      ELSE
         CALL cl_err3("","","","",SQLCA.sqlcode,"","azf_p1",1)
      END IF
   END IF                                                                                                                           
   DECLARE azf_c1 CURSOR FOR azf_p1                                                                                                 
   OPEN azf_c1                                                                                                                      
   FETCH azf_c1 INTO l_azf10                                                                                                      
   IF SQLCA.SQLCODE <> 0  THEN                                                                                    
      IF g_bgerr THEN
         CALL s_errmsg("azf01",g_oay18,"fetch azf10:",SQLCA.sqlcode,1)  #No.TQC-740094
      ELSE
         CALL cl_err3("","","","",SQLCA.sqlcode,"","fetch azf10:",1)
      END IF
      LET g_success='N'                                                                                                             
      RETURN                                                                                                                        
   END IF                                                                                                                           
   CLOSE azf_c1     #No.FUN-6B0065
   INITIALIZE l_ohb.* TO NULL                    #產生銷退單身     
 
   LET l_sql4 = "SELECT MAX(ohb03)+1 ",                               
                #" FROM ",l_dbs_tra CLIPPED,"ohb_file ",     #FUN-980092 
                " FROM ",cl_get_target_table(l_plant_new,'ohb_file'), #FUN-A50102 
                " WHERE ohb01='",g_oha01,"'"                                                                                        
 	 CALL cl_replace_sqldb(l_sql4) RETURNING l_sql4     #FUN-920032
         CALL cl_parse_qry_sql(l_sql4,l_plant_new) RETURNING l_sql4 #FUN-980092
   PREPARE ohb_p1 FROM l_sql4                                                                                                       
   IF SQLCA.SQLCODE THEN    
      IF g_bgerr THEN
         CALL s_errmsg("ohb01",g_oha01,"ohb_p1",SQLCA.sqlcode,1)  #No.TQC-740094
      ELSE
         CALL cl_err3("","","","",SQLCA.sqlcode,"","ohb_p1",1)
      END IF
   END IF                                                                                                                           
   DECLARE ohb_c1 CURSOR FOR ohb_p1                                                                                                 
   OPEN ohb_c1                                                                                                                      
   FETCH ohb_c1 INTO l_ohb03                                                                                                        
   IF SQLCA.SQLCODE <> 0 THEN                                                                                                       
      IF g_bgerr THEN
         CALL s_errmsg("ohb01",g_oha01,"fetch ohb",SQLCA.sqlcode,1)  #No.TQC-740094
      ELSE
         CALL cl_err3("","","","",SQLCA.sqlcode,"","fetch ohb",1)
      END IF
      LET g_success='N'                                                                                                             
      RETURN                     
   ELSE
      IF cl_null(l_ohb03) OR l_ohb03 = 0 THEN                                                                                          
         LET l_ohb03 = 1                                                                                                               
      END IF                                                                                                      
   END IF                                                                                                                           
   CLOSE ohb_c1                  
 
   LET l_sql5 = "SELECT occ1027 ",                               
                #" FROM ",l_dbs_new CLIPPED,"occ_file ", 
                " FROM ",cl_get_target_table(l_plant_new,'occ_file'), #FUN-A50102               
                " WHERE occ01='",l_oga.oga1004,"' AND occ1004='1' "     #No.FUN-690025                                                                                      
 	 CALL cl_replace_sqldb(l_sql5) RETURNING l_sql5        #FUN-920032
     CALL cl_parse_qry_sql(l_sql5,l_plant_new) RETURNING l_sql5 #FUN-A50102
   PREPARE occ_p1 FROM l_sql5                                                                                                       
   IF SQLCA.SQLCODE THEN  
      IF g_bgerr THEN
         CALL s_errmsg("occ01",l_oga.oga1004,"occ_p1",SQLCA.sqlcode,1)  #No.TQC-740094
      ELSE
         CALL cl_err3("","","","",SQLCA.sqlcode,"","occ_p1",1)
      END IF
   END IF                                                                                                                           
   DECLARE occ_c1 CURSOR FOR occ_p1                                                                                                 
   OPEN occ_c1                                                                                                                      
   FETCH occ_c1 INTO l_occ1027                                                                                                        
   IF SQLCA.SQLCODE <> 0 OR l_occ1027 = 'Y' THEN                                                  
      IF g_bgerr THEN
         CALL s_errmsg("","","sel occ1027:",SQLCA.sqlcode,1)
      ELSE
         CALL cl_err3("","","","",SQLCA.sqlcode,"","sel occ1027:",1)
      END IF
      LET g_success='N'                                                                                                             
      RETURN                                                                                                                        
   END IF                                                                                                                           
   CLOSE occ_c1                  
    
   #根據客戶+產品編號+單位+日期+定價類型取定價編號及單價  
   IF g_sma.sma116!='0' THEN      
      LET l_unit=l_ogb.ogb916
   ELSE     
      LET l_unit=l_ogb.ogb05  
   END IF      
   CALL s_fetch_price2(l_oga.oga1004,l_ogb.ogb04,l_unit,l_oga.oga02,'1',   
                       l_plant_new,l_oga.oga23)             #No.FUN-980059
        RETURNING l_ohb1001,l_ohb13,g_success             
   IF g_success ='N' THEN                                                     
      IF g_bgerr THEN
         CALL s_errmsg("","","fetch price2","atm-257",1)
      ELSE
         CALL cl_err3("","","","","atm-257","","fetch price2",1)
      END IF
      RETURN                                                  
   END IF               
   #根據單頭單價是否含稅 進行未稅、含稅金額的計算    
   IF l_oga.oga213='N' THEN        
      LET l_ohb14 = l_ohb13*l_ogb.ogb12       
      LET l_ohb13t= l_ohb13*(1+l_oga.oga211/100)       
      LET l_ohb14t= l_ohb13t*l_ogb.ogb12    
   ELSE        
      LET l_ohb13t= l_ohb13/(1+l_oga.oga211/100)       
      LET l_ohb14 = l_ohb13t*l_ogb.ogb12               
      LET l_ohb14t= l_ohb13*l_ogb.ogb12          
   END IF    
   LET l_ohb.ohb01     = g_oha01                 #銷退單號     
   LET l_ohb.ohb03     = l_ohb03                 #項次     
   LET l_ohb.ohb04     = l_ogb.ogb04             #產品編號     
   LET l_ohb.ohb05     = l_ogb.ogb05             #銷售單位     
   LET l_ohb.ohb05_fac = l_ogb.ogb05_fac         #銷售/庫存單位換算率     
   LET l_ohb.ohb910    = l_ogb.ogb910            #第一單位     
   LET l_ohb.ohb911    = l_ogb.ogb911            #第一單位轉換率     
   LET l_ohb.ohb912    = l_ogb.ogb912            #第一單位數量     
   LET l_ohb.ohb913    = l_ogb.ogb913            #第二單位     
   LET l_ohb.ohb914    = l_ogb.ogb914            #第二單位轉換率     
   LET l_ohb.ohb915    = l_ogb.ogb915            #第二單位數量     
   LET l_ohb.ohb916    = l_ogb.ogb916            #計價單位     
   LET l_ohb.ohb917    = l_ogb.ogb917            #計價數量     
   LET l_ohb.ohb06     = l_ogb.ogb06             #品名規格     
   LET l_ohb.ohb07     = l_ogb.ogb07             #額外品名規格     
   LET l_ohb.ohb08     = l_ogb.ogb08             #銷退工廠     
   LET l_ohb.ohb09     = l_ogb.ogb09             #銷退倉庫     
   LET l_ohb.ohb091    = l_ogb.ogb091            #銷退庫位     
   LET l_ohb.ohb092    = l_ogb.ogb092            #銷退批號     
   LET l_ohb.ohb11     = l_ogb.ogb11             #客戶產品編號     
   LET l_ohb.ohb12     = l_ogb.ogb12             #銷退數量     
   LET l_ohb.ohb13     = l_ohb13                 #原幣單價     
   LET l_ohb.ohb14     = l_ohb14                 #原幣稅前金額     
   LET l_ohb.ohb14t    = l_ohb14t                #原幣含稅金額     
   LET l_ohb.ohb15     = l_ogb.ogb15             #庫存明細單位     
   LET l_ohb.ohb15_fac = l_ogb.ogb15_fac         #銷售/庫存明細單位換算率    
   LET l_ohb.ohb16     = l_ogb.ogb16             #數量    
   LET l_ohb.ohb30     = ''                      #原出貨發票號     
   LET l_ohb.ohb31     = ''                      #出貨單號     
   LET l_ohb.ohb32     = ''                      #出貨項次     
   LET l_ohb.ohb33     = ''                      #訂單單號       
   LET l_ohb.ohb34     = ''                      #訂單項次     
   LET l_ohb.ohb50     = g_oay18                 #退貨理由碼     
   IF cl_null(l_ohb.ohb50) THEN LET l_ohb.ohb50 = g_poy.poy31 END IF #TQC-D40064 add
   LET l_ohb.ohb60     = 0                       #已開折讓數量     
   LET l_ohb.ohb1001   = l_ohb1001               #定價編號    
   LET l_ohb.ohb1002   = l_oga.oga02             #預計銷退日期     
   LET l_ohb.ohb1003   = l_ogb.ogb1006           #折扣率
   LET l_ohb.ohb1004   = l_azf10                 #搭增否      #No.FUN-6B0065
   LET l_ohb.ohbud01   = l_ogb.ogbud01
   LET l_ohb.ohbud02   = l_ogb.ogbud02
   LET l_ohb.ohbud03   = l_ogb.ogbud03
   LET l_ohb.ohbud04   = l_ogb.ogbud04
   LET l_ohb.ohbud05   = l_ogb.ogbud05
   LET l_ohb.ohbud06   = l_ogb.ogbud06
   LET l_ohb.ohbud07   = l_ogb.ogbud07
   LET l_ohb.ohbud08   = l_ogb.ogbud08
   LET l_ohb.ohbud09   = l_ogb.ogbud09
   LET l_ohb.ohbud10   = l_ogb.ogbud10
   LET l_ohb.ohbud11   = l_ogb.ogbud11
   LET l_ohb.ohbud12   = l_ogb.ogbud12
   LET l_ohb.ohbud13   = l_ogb.ogbud13
   LET l_ohb.ohbud14   = l_ogb.ogbud14
   LET l_ohb.ohbud15   = l_ogb.ogbud15
 
   IF l_ohb.ohb1004='Y' THEN   #搭贈時金額為零
      LET l_ohb.ohb14 = 0
      LET l_ohb.ohb14t= 0
   END IF
   #No.FUN-A10123 ...begin
   IF g_azw.azw04 = '2' THEN
      LET l_ohb.ohb64 = l_ogb.ogb44
      LET l_ohb.ohb65 = l_ogb.ogb45
      LET l_ohb.ohb66 = l_ogb.ogb46
      LET l_ohb.ohb67 = l_ogb.ogb47
   END IF
   LET l_ohb.ohb68 = 'Y'
   IF cl_null(l_ohb.ohb64) THEN LET l_ohb.ohb64 = ' ' END IF
   IF cl_null(l_ohb.ohb67) THEN LET l_ohb.ohb67 = 0  END IF
   #No.FUN-A10123 ...end
 
   #FUN-AB0061----------add---------------str----------------
   IF cl_null(l_ohb.ohb37) OR l_ohb.ohb37 = 0 THEN
      LET l_ohb.ohb37 = l_ohb.ohb13
   END IF
   #FUN-AB0061----------add---------------end----------------
 
   #FUN-AC0055 mark --begin-------------  
   ##FUN-AB0096 -------add start------------
   #IF cl_null(l_ohb.ohb71) THEN
   #   LET l_ohb.ohb71 = '1'
   #END IF 
   ##FUN-AB0096 --------add end------------
   #FUN-AC0055 mark ---end--------------
   #FUN-CB0087--add--str--
   #IF l_aza.aza115 ='Y' AND l_aza.aza50 ='Y' THEN   #TQC-D20067 mark
   IF l_aza.aza115 ='Y' THEN   #TQC-D20067
      IF cl_null(l_ohb.ohb50) THEN  #TQC-D20067 mark  #TQC-D40064 remark
         #TQC-D20050--mod--str--
         #SELECT oha14,oha15 INTO l_oha14,l_oha15 FROM oha_file WHERE oha01 = l_ohb.ohb01
         #CALL s_reason_code(l_ohb.ohb01,l_ohb.ohb31,'',l_ohb.ohb04,l_ohb.ohb09,l_oha14,l_oha15) RETURNING l_ohb.ohb50
         LET l_sql="SELECT oha14,oha15 FROM ",cl_get_target_table(l_plant_new,'oha_file')," WHERE oha01 ='",l_ohb.ohb01,"'"
         PREPARE ogb50_pr FROM l_sql
         EXECUTE ogb50_pr INTO l_oha14,l_oha15
         CALL s_reason_code1(l_ohb.ohb01,l_ohb.ohb31,'',l_ohb.ohb04,l_ohb.ohb09,l_oha14,l_oha15,l_plant_new) RETURNING l_ohb.ohb50
         #TQC-D20050--mod--end--
         IF cl_null(l_ohb.ohb50) THEN
            CALL cl_err(l_ohb.ohb50,'aim-425',1)
            LET g_success="N"
            RETURN
         END IF
      END IF #TQC-D20067 mark  #TQC-D40064 remark
   END IF
   #FUN-CB0087--add--end-- 
   #LET l_sql="INSERT INTO ",l_dbs_tra CLIPPED,"ohb_file ",  #FUN-980020
   LET l_sql="INSERT INTO ",cl_get_target_table(l_plant_new,'ohb_file'), #FUN-A50102
               "( ohb01,ohb03,ohb04,ohb05,ohb05_fac, ",                                                                                
               "  ohb910,ohb911,ohb912,ohb913,ohb914,",                                                                                  
               "  ohb915,ohb916,ohb917,ohb06,ohb07,",                                                                                 
               "  ohb08,ohb09,ohb091,ohb092,ohb11,",                                                                                
               "  ohb12,ohb37,ohb13,ohb14,ohb14t,ohb15,",         #FUN-AB0061 add ohb37                                                                         
               "  ohb15_fac,ohb16,ohb30,ohb31,ohb32,",                                                                                
               "  ohb33,ohb34,ohb50,ohb60,ohb1001,",                                                                                
               "  ohb64,ohb65,ohb66,ohb67,ohb68,",          #No.FUN-A10123                                                                               
               #"  ohb1002,ohb1003,ohb1004,ohb71,ohbplant,ohblegal, ",  #FUN-980006 add ohbplant,ohblegal        #FUN-AB0096 add ohb71    
               "  ohb1002,ohb1003,ohb1004,ohbplant,ohblegal, ",        #FUN-AC0055 remove ohb71   
               "  ohbud01,ohbud02,ohbud03,ohbud04,ohbud05,",
               "  ohbud06,ohbud07,ohbud08,ohbud09,ohbud10,",
               "  ohbud11,ohbud12,ohbud13,ohbud14,ohbud15)",
               "  VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",                                                                     
                         "?,?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",   #FUN-AB0061 add ?                                                                  
                         "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,  ?,?,?,?",    #No.CHI-950020  #No.FUN-A10123
                         "?,?,?,?, ?,? ,?,?) "  #FUN-980006 add ?,?             #FUN-AB0096 add?                                                                                 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
   PREPARE ins_ohb FROM l_sql                                                                                                       
   EXECUTE ins_ohb USING                                                                                                            
      l_ohb.ohb01,l_ohb.ohb03,l_ohb.ohb04,l_ohb.ohb05,l_ohb.ohb05_fac,                                                                 
      l_ohb.ohb910,l_ohb.ohb911,l_ohb.ohb912,l_ohb.ohb913,l_ohb.ohb914,                                                                  
      l_ohb.ohb915,l_ohb.ohb916,l_ohb.ohb917,l_ohb.ohb06,l_ohb.ohb07,                                                                 
      l_ohb.ohb08,l_ohb.ohb09,l_ohb.ohb091,l_ohb.ohb092,l_ohb.ohb11,                                                                
      l_ohb.ohb12,l_ohb.ohb37,l_ohb.ohb13,l_ohb.ohb14,l_ohb.ohb14t,l_ohb.ohb15,      #FUN-AB0061 add ohb37                                                            
      l_ohb.ohb15_fac,l_ohb.ohb16,l_ohb.ohb30,l_ohb.ohb31,l_ohb.ohb32,                                                                
      l_ohb.ohb33,l_ohb.ohb34,l_ohb.ohb50,l_ohb.ohb60,l_ohb.ohb1001,                                                        
      l_ohb.ohb64,l_ohb.ohb65,l_ohb.ohb66,l_ohb.ohb67,l_ohb.ohb68,          #No.FUN-A10123                                                                               
      #l_ohb.ohb1002,l_ohb.ohb1003,l_ohb.ohb1004,l_ohb.ohb71,l_plant,l_legal #FUN-980006 add l_plant,l_legal      #FUN-AB0096 add l_ohb.ohb71                                                                   
      l_ohb.ohb1002,l_ohb.ohb1003,l_ohb.ohb1004,l_plant,l_legal #FUN-AC0055 remove l_ohb.ohb71                                                      
     ,l_ohb.ohbud01,l_ohb.ohbud02,l_ohb.ohbud03,l_ohb.ohbud04,l_ohb.ohbud05,
      l_ohb.ohbud06,l_ohb.ohbud07,l_ohb.ohbud08,l_ohb.ohbud09,l_ohb.ohbud10,
      l_ohb.ohbud11,l_ohb.ohbud12,l_ohb.ohbud13,l_ohb.ohbud14,l_ohb.ohbud15
   IF SQLCA.sqlcode<>0 THEN                                                                                                         
      IF g_bgerr THEN
         LET g_showmsg=l_ohb.ohb01,"/",l_ohb.ohb03   #No.TQC-740094
         CALL s_errmsg("ohb01,ohb03",g_showmsg,"ins ohb:",SQLCA.sqlcode,1)  #No.TQC-740094
      ELSE
         CALL cl_err3("","","","",SQLCA.sqlcode,"","ins ohb:",1)
      END IF
      LET g_success = 'N'    
#FUN-B70074--add--insert--
   ELSE
      IF NOT s_industry('std') THEN
         INITIALIZE l_ohbi.* TO NULL
         LET l_ohbi.ohbi01 = l_ohb.ohb01
         LET l_ohbi.ohbi03 = l_ohb.ohb03
         IF NOT s_ins_ohbi(l_ohbi.*,l_plant_new) THEN
            LET g_success = 'N'  
         END IF
      END IF 
#FUN-B70074--add--insert--
#    #FUN-C50136----add----str----
#    IF g_oaz.oaz96 ='Y' THEN
#       CALL s_ccc_oia07('G',l_oha.oha03) RETURNING l_oia07
#       IF l_oia07 = '0' THEN
#          CALL s_ccc_oia(l_oha.oha03,'G',l_oha.oha01,0,l_plant_new)
#       END IF
#    END IF
#    #FUN-C50136----add----end----
   END IF          
   LET l_oha.oha50  =l_oha.oha50  +l_ohb.ohb14    
   LET l_oha.oha53  =l_oha.oha53  +l_ohb.ohb14     
   LET l_oha.oha1008=l_oha.oha1008+l_ohb.ohb14t
 
   #LET l_sql2="UPDATE ",l_dbs_tra CLIPPED,"oha_file", #FUN-980092
  LET l_sql2="UPDATE ",cl_get_target_table(l_plant_new,'oha_file'), #FUN-A50102
              "   SET oha50  = ? ,",                                                                                     
              "       oha53  = ?, ",                                                                           
              "       oha1008= ? ",                                                                                      
              " WHERE oha01  = ?  "                                                                       
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
   PREPARE upd_oha FROM l_sql2                                                                                        
   EXECUTE upd_oha USING l_oha.oha50,l_oha.oha53,                                                                 
                         l_oha.oha1008,l_oha.oha01                                                                      
   IF SQLCA.sqlcode<>0 THEN                                                                                           
      IF g_bgerr THEN
         CALL s_errmsg("oha01",l_oha.oha01,"upd oha:",SQLCA.sqlcode,1)  #No.TQC-740094
      ELSE
         CALL cl_err3("","","","",SQLCA.sqlcode,"","upd oha:",1)
      END IF
      LET g_success = 'N'                                                                               
      RETURN     
   END IF                        
END FUNCTION         
 
FUNCTION p822_imgs(p_ware,p_loca,p_lot,p_date,p_rvbs)
   DEFINE p_rvbs   RECORD LIKE rvbs_file.*
   DEFINE p_ware   LIKE imgs_file.imgs02
   DEFINE p_loca   LIKE imgs_file.imgs03
   DEFINE p_lot    LIKE imgs_file.imgs04
   DEFINE p_date   LIKE tlfs_file.tlfs111
   DEFINE l_imgs   RECORD LIKE imgs_file.*
   DEFINE l_tlfs   RECORD LIKE tlfs_file.*
   DEFINE l_ima25  LIKE ima_file.ima25
   DEFINE l_sql1   LIKE type_file.chr1000
   DEFINE l_sql2   LIKE type_file.chr1000
   DEFINE l_n      LIKE type_file.num5
   DEFINE l_plant  LIKE azp_file.azp01    #FUN-980006 add
   DEFINE l_legal  LIKE oga_file.ogalegal #FUN-980006 add
   
     LET l_plant = g_poy.poy04  #FUN-980006 add 
     CALL s_getlegal(l_plant) RETURNING l_legal  #FUN-980006 add
 
   LET l_sql1 = "SELECT COUNT(*) ",
                #"  FROM ",l_dbs_tra CLIPPED,"imgs_file ", #FUN-980092
                "  FROM ",cl_get_target_table(l_plant_new,'imgs_file'), #FUN-A50102
                " WHERE imgs01='",p_rvbs.rvbs021,"' ",
                "   AND imgs02='",p_ware,"'",
                "   AND imgs03='",p_loca,"'",
                "   AND imgs04='",p_lot,"'",
                "   AND imgs05='",p_rvbs.rvbs03,"'",
                "   AND imgs06='",p_rvbs.rvbs04,"'",
                "   AND imgs11='",p_rvbs.rvbs08,"'"
  
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
         CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-980092
   PREPARE imgs_pre1 FROM l_sql1
   IF SQLCA.SQLCODE THEN
      IF g_bgerr THEN
         LET  g_showmsg=p_rvbs.rvbs021,"/",p_ware,"/",p_loca,"/",p_lot,"/",p_rvbs.rvbs03,"/",p_rvbs.rvbs04           
         CALL s_errmsg('imgs01,imgs02,imgs03,imgs04,imgs05,imgs06',g_showmsg,'imgs_pre',SQLCA.SQLCODE,1)
      ELSE
        CALL cl_err('imgs_pre',SQLCA.SQLCODE,1)
      END IF
   END IF
  
   DECLARE imgs_cs CURSOR FOR imgs_pre1
  
   OPEN imgs_cs
   FETCH imgs_cs INTO l_n
  
   IF l_n = 0 THEN
      LET l_imgs.imgs01 = p_rvbs.rvbs021
      LET l_imgs.imgs02 = p_ware
      LET l_imgs.imgs03 = p_loca
      LET l_imgs.imgs04 = p_lot
      LET l_imgs.imgs05 = p_rvbs.rvbs03
      LET l_imgs.imgs06 = p_rvbs.rvbs04
      LET l_imgs.imgs07 = l_ima25
      LET l_imgs.imgs08 = 0
      LET l_imgs.imgs09 = p_rvbs.rvbs05
      LET l_imgs.imgs10 = p_rvbs.rvbs07
      LET l_imgs.imgs11 = p_rvbs.rvbs08
  
      #LET l_sql2 = "INSERT INTO ",l_dbs_tra CLIPPED,"imgs_file", #FUN-980092
      LET l_sql2 = "INSERT INTO ",cl_get_target_table(l_plant_new,'imgs_file'), #FUN-A50102
                   "(imgs01,imgs02,imgs03,imgs04,imgs05,imgs06,",
                   " imgs07,imgs08,imgs09,imgs10,imgs11,imgsplant,imgslegal)", #FUN-980006 add imgsplant,imgslegal
                   " VALUES( ?,?,?,?,?,?, ?,?,?,?,?, ?,?)" #FUN-980006 add ?,?
  
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
      PREPARE ins_imgs FROM l_sql2
  
      EXECUTE ins_imgs USING l_imgs.imgs01,l_imgs.imgs02,l_imgs.imgs03,
                             l_imgs.imgs04,l_imgs.imgs05,l_imgs.imgs06,
                             l_imgs.imgs07,l_imgs.imgs08,l_imgs.imgs09,
                             l_imgs.imgs10,l_imgs.imgs11,l_plant,l_legal #FUN-980006 add l_plant,l_legal
      IF SQLCA.sqlcode<>0 THEN
         LET g_msg = l_dbs_new CLIPPED,'ins imgs'
         IF g_bgerr THEN
            LET g_showmsg=p_rvbs.rvbs021,"/",p_ware,"/",p_loca,"/",p_lot,"/",p_rvbs.rvbs03,"/",p_rvbs.rvbs04           
            CALL s_errmsg('imgs01,imgs02,imgs03,imgs04,imgs05,imgs06',g_showmsg,'imgs_ins',SQLCA.SQLCODE,1)
         ELSE
            CALL cl_err("imgs_ins",SQLCA.sqlcode,1)
         END IF
         LET g_success = 'N'
      END IF
   END IF  
 
   LET l_tlfs.tlfs01=p_rvbs.rvbs021       #異動料件編號
   LET l_tlfs.tlfs02=p_ware                #倉庫
   LET l_tlfs.tlfs03=p_loca                #儲位
   LET l_tlfs.tlfs04=p_lot                 #批號
   LET l_tlfs.tlfs05=p_rvbs.rvbs03         #序號
   LET l_tlfs.tlfs06=p_rvbs.rvbs04         #外部批號
  #MOD-C30663 str------
  #LET l_tlfs.tlfs07=l_ima25
   SELECT img09 INTO l_tlfs.tlfs07 FROM img_file
    WHERE img01 = l_tlfs.tlfs01 AND img02 = l_tlfs.tlfs02
      AND img03 = l_tlfs.tlfs03 AND img04 = l_tlfs.tlfs04
  #MOD-C30663 end------
   LET l_tlfs.tlfs08=p_rvbs.rvbs00
 
   CASE l_tlfs.tlfs08
      WHEN "apmt300"    #收貨單
         LET l_tlfs.tlfs09=0
      WHEN "apmt740"    #入庫單
         LET l_tlfs.tlfs09=1
      WHEN "axmt821"  #出貨單
         LET l_tlfs.tlfs09=-1
   END CASE
 
   LET l_tlfs.tlfs10=p_rvbs.rvbs01
   LET l_tlfs.tlfs11=p_rvbs.rvbs02
   LET l_tlfs.tlfs111=p_date
   LET l_tlfs.tlfs12=g_today
   LET l_tlfs.tlfs13=p_rvbs.rvbs06
   LET l_tlfs.tlfs14=p_rvbs.rvbs07
   LET l_tlfs.tlfs15=p_rvbs.rvbs08
 
   #LET l_sql2 = "INSERT INTO ",l_dbs_tra CLIPPED,"tlfs_file",
   LET l_sql2 = "INSERT INTO ",cl_get_target_table(l_plant_new,'tlfs_file'), #FUN-A50102
                "(tlfs01,tlfs02,tlfs03,tlfs04,tlfs05,tlfs06,tlfs07,",
                " tlfs08,tlfs09,tlfs10,tlfs11,tlfs12,tlfs13,tlfs14,",
                " tlfs15,tlfs111,tlfsplant,tlfslegal)", #FUN-980006 add tlfsplant,tlfslegal
                " VALUES( ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?)" #FUN-980006 add ?,?
 
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
   PREPARE ins_tlfs FROM l_sql2
 
   EXECUTE ins_tlfs USING l_tlfs.tlfs01,l_tlfs.tlfs02,l_tlfs.tlfs03,
                          l_tlfs.tlfs04,l_tlfs.tlfs05,l_tlfs.tlfs06,
                          l_tlfs.tlfs07,l_tlfs.tlfs08,l_tlfs.tlfs09,
                          l_tlfs.tlfs10,l_tlfs.tlfs11,l_tlfs.tlfs12,
                          l_tlfs.tlfs13,l_tlfs.tlfs14,l_tlfs.tlfs15,
                          l_tlfs.tlfs111,l_plant,l_legal #FUN-980006 add l_plant,l_legal
 
   IF SQLCA.sqlcode<>0 THEN
      IF g_bgerr THEN
        LET g_showmsg=l_tlfs.tlfs01,"/",l_tlfs.tlfs12
        CALL s_errmsg('tlfs01,tlfs06',g_showmsg,'ins tlfs:',SQLCA.sqlcode,1)
      ELSE
        CALL cl_err('ins tlfs:',SQLCA.sqlcode,1) 
      END IF
      LET g_success = 'N'
   END IF
   
END FUNCTION
#No:FUN-9C0071--------精簡程式-----
#No.FUN-A10123 ...begin
#FUNCTION p822_def_no(l_dbs,l_rye01,l_rye02)
FUNCTION p822_def_no(l_plant,l_rye01,l_rye02)  #FUN-A50102
#DEFINE l_dbs   LIKE azp_file.azp03
DEFINE l_plant LIKE azp_file.azp01  #FUN-A50102
DEFINE l_rye01 LIKE rye_file.rye01
DEFINE l_rye02 LIKE rye_file.rye02
DEFINE l_sql   STRING
DEFINE l_no    LIKE poy_file.poy38
 
   #LET l_sql = "SELECT rye03 FROM ",l_dbs CLIPPED,"rye_file",
   #FUN-C90050 mark begin---
   #LET l_sql = "SELECT rye03 FROM ",cl_get_target_table(l_plant,'rye_file'), #FUN-A50102
   #            " WHERE rye01 = ? AND rye02 = ? AND ryeacti='Y'"
   #CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
   #CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql      #FUN-A50102            
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
   #FUN-C90050 mark begin---
  
   #FUN-C90050 add begin---
   CALL s_get_defslip(l_rye01,l_rye02,l_plant,'N') RETURNING l_no    #UFN-C90050 add
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
