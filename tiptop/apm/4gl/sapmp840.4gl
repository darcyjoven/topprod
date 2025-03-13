# Prog. Version..: '5.30.06-13.04.17(00010)'     #
#
# pattern name...: apmp840.4gl
# Descriptions...: 代採購三角貿易倉退單拋轉作業(正拋)
# Date & Author..: 01/11/16 By Tommy
# Modify ........: No.7709 03/08/06 Kammy 倉退不用判斷庫存不足
# Modify.........: No.7902 03/08/23 Kammy 幣別取位應用原幣幣別而非用各站的本幣
# Modify.........: No.8128 03/09/06 Kammy 1.流程抓取方式修改(poz_file,poy_file)
#                                         2.倉庫別帶流程代碼的 
# Modify.........: No.FUN-4C0011 04/12/01 By Mandy 單價金額位數改為dec(20,6)
# Modify.........: No.FUN-550060 05/05/30 By Will 單據編號放大
# Modify.........: NO.FUN-560043 05/06/29 By Smapmin 根據雙單位做調整,多角序號放大,單號放大
# Modify.........: NO.MOD-610117 06/01/24 By Pengu Line:840的地方CLOSE oeb_c1,應調整為CLOSE rvb_c1
# Modify.........: NO.FUN-620025 06/02/14 By day 流通版多角貿易修改
# Modify.........: NO.FUN-640167 06/04/18 BY yiting 出貨或入庫扣帳拋單時，中間廠都會詢問"這是新的倉儲批，是否新增? -->不用問，直接產生 
# Modify.........: No.FUN-660129 06/06/19 By ray cl_err --> cl_err3
# Modify.........: NO.MOD-650005 06/06/22 By Mandy 產生銷退時CALL p840_ohbins(i),銷退的單價目前取訂單,應取出貨單
# Modify.........: No.MOD-660122 06/06/30 By Rayven 當ima25與img09的單位一樣時，imgg21及imgg211所存的轉換率，也應該要一樣
# Modify.........: No.MOD-680058 06/08/18 By day 增加對ohb1005的預設
# Modify.........: NO.FUN-670007 06/09/04 BY yiting 1.判斷是否有中斷營運中心，如有，所設定營運中心之後不拋
#                                                   2.依站別抓取單別及倉庫資料
# Modify.........: No.FUN-680136 06/09/07 By Jackho 欄位類型修改
# Modify.........: No.FUN-690025 06/09/21 By jamie 改判斷狀況碼occ1004
# Modify.........: No.FUN-6B0044 06/11/13 By kim GP3.5 台虹保稅客製功能回收修改
# Modify.........: NO.TQC-690057 06/11/15 BY Claire img_file值要取自imd_file
# Modify.........: No.FUN-6B0065 06/11/21 By Ray atmi217并入aooi313(azf09,10,11,12,13取代tqe03,04,05,11,08)
# Modify.........: NO.TQC-6A0084 06/12/05 By Nicola 含稅金額、未稅金額調整
# Modify.........: No.MOD-690156 06/12/14 By Mandy add l_aza.aza50='Y'的判斷
# Modify.........: NO.MOD-6C0086 06/12/14 BY Claire 語法調整
# Modify.........: No.FUN-710030 07/01/23 By johnray 錯誤訊息匯總顯示修改
# Modify.........: NO.CHI-710059 07/02/02 BY jamie ogb14應為ogb917*ogb13
# Modify.........: NO.TQC-760054 07/06/06 By xufeng azf_file的index是azf_01(azf01,azf02),但是在抓‘中文說明’內容時，WHERE條件卻只有 azf01 = g_xxx
# Modify.........: No.CHI-770019 07/07/25 By Carrier 多單位:參考單位時,交易單位不寫入tlff
# Modify.........: NO.CHI-760003 07/08/14 BY wujie  當sma115='Y'時才需判斷ima906 
# Modify.........: NO.MOD-780191 07/08/29 BY yiting 拋轉時需檢核單別設定資料是否齊全
# Modify.........: No.MOD-780264 07/08/31 By Claire 未回寫呆滯日期 
# Modify.........: NO.TQC-790003 07/09/03 BY yiting insert into前給予預設值
# Modify.........: NO.TQC-790117 07/09/21 BY yiting 二站時會發生拋轉錯誤
# Modify.........: No.TQC-790177 07/09/29 By Carrier 去掉全型字符
# Modify.........: No.MOD-7B0182 07/11/21 By Claire 倉退產生的銷退單, 出貨單號要給值
# Modify.........: No.TQC-7B0083 07/11/23 By Carrier rvv88給default值
# Modify.........: No.TQC-7C0064 07/12/08 By Beryl   判斷單別在拋轉資料庫是否存在，如果不存在，則報錯，批處理運行不成功．提示user單據別無效或不存在其資料庫中
# Modify.........: NO.TQC-810029 08/01/09 BY yiting 有最終供應商時，最後一站產生的倉退單單別抓不到 
# Modify.........: No.MOD-820060 08/02/14 By Claire rvv87已於計算前給值
# Modify.........: No.FUN-7B0018 08/03/04 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.MOD-830002 08/03/18 By claire 原單頭的來源廠商(poz04:已不使用)改於單身第0站的上游廠商(poy03)
# Modify.........: No.FUN-830035 08/03/18 By Claire 倉退併單
# Modify.........: No.FUN-850100 08/05/19 By Nicola 批/序號管理第二階段
# Modify.........: No.MOD-870123 08/07/11 By claire 有最終供應商時,要清除殘值收貨/入庫單號
# Modify.........: No.MOD-880099 08/08/15 By claire 拋轉各站時,品名規格應不需重新抓取,以原始倉退單的品名為主
# Modify.........: No.FUN-8A0086 08/10/21 By baofei 完善FUN-710050的錯誤匯總的修改
# Modify.........: No.MOD-920265 09/02/20 By claire rvv930,ohb930應來源單號的值
# Modify.........: No.FUN-930104 09/03/23 By dxfwo   理由碼的分類改善
# Modify.........: No.MOD-940067 09/04/07 By chenyu poz04現在系統中沒有使用，給tlf19賦值時用oha04
# Modify.........: No.MOD-950136 09/05/13 By wujie  入庫單插入tlf19時，直接取rvu04的值。使tlf和入庫單一致。
# Modify.........: No.TQC-950010 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring()  
# Modify.........: No.FUN-940083 09/05/18 By zhaijie 調整批處理賦值
# Modify.........: No.CHI-960041 09/06/15 By Dido 轉換率抓取問題
# Modify.........: No.FUN-980006 09/08/14 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980081 09/08/21 By destiny 修改傳到s_mupimg里的參數
# Modify.........: No.TQC-980229 09/08/24 By sherry "倉退單號"欄位需要可以開窗選擇           
# Modify.........: No.FUN-980020 09/09/01 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-980059 09/09/09 By arman GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980092 09/09/17 By TSD.apple GP5.2 跨資料庫語法修改
# Modify.........: No.CHI-950020 09/10/06 By chenmoyan 將自定義欄位的值拋轉各站
# Modify.........: No.CHI-9B0008 09/11/11 By Dido 增加拋轉 tlf930
# Modify.........: No:TQC-9B0013 09/11/27 By Dido 單別於建檔刪除後,應控卡不可產生拋轉
# Modify.........: No.TQC-A10060 10/01/11 By wuxj   修改INSERT INTO加入oriu及orig這2個欄位 
# Modify.........: No:FUN-9C0071 10/01/14 By huangrh 精簡程式
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26*
# Modify.........: No.FUN-A50102 10/07/21 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:MOD-AB0122 10/11/16 By Smapmin 倉退單價來源應為收貨單
# Modify.........: No.FUN-AB0061 10/11/17 By chenying 銷退單加基礎單價字段ohb37
# Modify.........: No.FUN-AB0061 10/11/17 By shenyang 出貨單加基礎單價字段ogb37
# Modify.........: No.FUN-AA0023 10/11/22 By lixia 將apmp840拆開成apmp840及sapmp840
# Modify.........: No.FUN-AB0096 10/12/06 By vealxu 因新增ogb50，ohb71 not null欄位導致無法insert的問題修正
# Modify.........: No.FUN-AC0055 10/12/21 By suncx 取消預設ohb71值，新增oha55欄位預設值
# Modify.........: No.FUN-AC0055 10/12/21 By wangxin oga57,ogb50欄位預設值修正
# Modify.........: No.MOD-A90100 11/01/20 By Smapmin 批序號管理拋轉倉退單時各站都應產生批/序號內容
# Modify.........: No.FUN-AB0023 11/03/17 By Lilan EF整合功能(EasyFlow)
# Modify.........: No:FUN-B30211 11/03/30 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:MOD-B50099 11/05/13 By Summer 產生的銷退單,狀況碼沒有拋
# Modify.........: No:TQC-B60065 11/06/16 By shiwuying 增加虛擬類型rvu27
# Modify.........: No:FUN-B70074 11/07/20 By fengrui 添加行業別表的新增於刪除
# Modify.........: No.FUN-B90012 11/09/13 By xianghui 增加ICD行業功能
# Modify.........: No.TQC-B90236 11/10/26 By zhuhao 寫入apmt742的rvbs_file的rvbs09=-l,s_mupimg(的倒數第三個參數應該傳1)
# Modify.........: No.FUN-BB0084 11/11/24 By lixh1 增加數量欄位小數取位
# Modify.........: No:FUN-BB0083 11/12/22 By xujing 增加數量欄位小數取位
# Modify.........: No.FUN-BA0051 12/01/12 By jason 一批號多DATECODE功能
# Modify.........: No.FUN-BB0001 12/01/17 By pauline 新增rvv22,INSERT/UPDATE rvb22時,同時INSERT/UPDATE rvv22
# Modify.........: No:MOD-C30663 12/03/14 By ck2yuan tlfs07單位應寫img09
# Modify.........: No:FUN-C50097 12/06/13 By SunLM  對非空字段進行判斷ogb50,51,52 
# Modify.........: No.CHI-C80009 12/08/15 By Sakura 1.一批號多DATECODE功能時,FOREACH需多傳倉儲批2.CALL s_icdbin_multi時參數傳錯
# Modify.........: No.FUN-C50136 12/08/27 By xianghui 拋磚時如果做信用管控則需做信用管控處理
# Modify.........: No.CHI-C80042 12/08/30 By Vampire 多角入/出庫,正逆拋都要更新 ima73, ima74, ima29
# Modify.........: No.FUN-C80001 12/08/30 By bart 多角拋轉時，批號需一併拋轉sma96
# Modify.........: No.FUN-CB0087 12/12/21 By xianghui 庫存理由碼改善
# Modify.........: No:MOD-CC0289 12/12/31 By SunLM 插入tlfcost时候,根据ccz28参数(成本计算方式)
# Modify.........: No.TQC-D20050 13/02/26 By xianghui 理由碼調整
# Modify.........: No.TQC-D20047 13/02/27 By xianghui 理由碼調整
# Modify.........: No.TQC-D20067 13/03/01 By xianghui 理由碼調整
# Modify.........: No.TQC-D30020 13/03/07 By chenjing 修改無符合條件之三角貿易採單資料時手動錄入也提示有資料運行成功
# Modify.........: No:FUN-BC0062 13/03/08 By lixh1 當成本計算方式ccz28選擇'6'，過帳還原時控制不可過帳還原
# Modify.........: No.FUN-CC0157 13/03/20 By zm tlf920赋值(配合发出商品修改)
# Modify.........: No:FUN-D30099 13/03/29 By Elise 將asms230的sma96搬到apms010,欄位改為pod08
# Modify.........: No.TQC-D40064 13/06/19 By fengrui 理由碼調整

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_rva   RECORD LIKE rva_file.*
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
DEFINE l_oha   RECORD LIKE oha_file.*
DEFINE l_ohb   RECORD LIKE ohb_file.*
DEFINE l_rva   RECORD LIKE rva_file.*
DEFINE l_rvb   RECORD LIKE rvb_file.*
DEFINE l_rvu   RECORD LIKE rvu_file.*
DEFINE l_rvv   RECORD LIKE rvv_file.*
DEFINE g_pmm   RECORD LIKE pmm_file.*
DEFINE g_pmn   RECORD LIKE pmn_file.*
DEFINE tm      RECORD
               wc  LIKE type_file.chr1000      #No.FUN-680136 VARCHAR(600) 
               END RECORD
DEFINE g_poz   RECORD  LIKE poz_file.*         #流程代碼資料(單頭) No.8083
DEFINE g_poy   RECORD  LIKE poy_file.*         #流程代碼資料(單身) No.8083
DEFINE n_poy   RECORD  LIKE poy_file.*         #流程代碼資料(單身) #NO.FUN-670007
DEFINE p_pmm09         LIKE pmm_file.pmm09,    #廠商代號
       p_poy04         LIKE poc_file.poc03,    #工廠編號
       p_oea03         LIKE oea_file.oea03,    #客戶代號
       g_imd10         LIKE imd_file.imd10,    #倉儲類別
       g_imd11         LIKE imd_file.imd11,    #是否為可用倉儲
       g_imd12         LIKE imd_file.imd12,    #MRP倉否
       g_imd13         LIKE imd_file.imd13,    #保稅否
       g_imd14         LIKE imd_file.imd14,    #生產發料順序
       g_imd15         LIKE imd_file.imd15,    #銷售出貨順序
       p_imd01         LIKE imd_file.imd01     #倉庫別
DEFINE g_flow99        LIKE apa_file.apa99     #No.FUN-680136 VARCHAR(17)       #多角序號   #FUN-560043
DEFINE l_dbs_new       LIKE type_file.chr21    #No.FUN-680136 VARCHAR(21)    #New DataBase Name
DEFINE l_dbs_tra       LIKE type_file.chr21    #FUN-980092 
DEFINE s_dbs_source    LIKE type_file.chr21    #No.FUN-680136 VARCHAR(21)    #來源工廠
DEFINE l_aza  RECORD   LIKE aza_file.*
DEFINE l_azp  RECORD   LIKE azp_file.*
DEFINE n_azp  RECORD   LIKE azp_file.*         #FUN-670007
DEFINE s_azi  RECORD   LIKE azi_file.*
DEFINE l_azi  RECORD   LIKE azi_file.*
DEFINE n_azi  RECORD   LIKE azi_file.*         #FUN-670007
DEFINE g_sw            LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)
DEFINE g_argv1         LIKE oga_file.oga01 
DEFINE p_last          LIKE type_file.num5     #No.FUN-680136 SMALLINT            #流程之最後家數
DEFINE p_last_plant    LIKE azp_file.azp01     #No.FUN-680136 VARCHAR(10)
DEFINE p_first_plant   LIKE azp_file.azp01     #No.FUN-680136 VARCHAR(10)
DEFINE s_price         LIKE ogb_file.ogb13     #來源工廠單價
DEFINE s_pob11         LIKE pob_file.pob11     #記錄下游工廠計價方式
DEFINE s_pob12         LIKE pob_file.pob12     #記錄下游工廠計價方式
DEFINE g_pmm50         LIKE pmm_file.pmm50
DEFINE l_rva01         LIKE rva_file.rva01 
DEFINE g_oga01         LIKE oga_file.oga01    
DEFINE l_pmm01         LIKE pmm_file.pmm01    
DEFINE l_oayauno       LIKE oay_file.oayauno
DEFINE l_oay16         LIKE oay_file.oay16
DEFINE l_oay19         LIKE oay_file.oay19
DEFINE l_oay20         LIKE oay_file.oay20
DEFINE l_occ           RECORD LIKE occ_file.*
DEFINE l_azf10         LIKE azf_file.azf10
DEFINE l_azf10a        LIKE azf_file.azf10
DEFINE g_t1            LIKE poy_file.poy37        #No.FUN-550060  #No.FUN-680136 VARCHAR(05)
DEFINE oha_t1          LIKE poy_file.poy38        #No.FUN-680136 VARCHAR(5)
DEFINE rvu_t1          LIKE poy_file.poy38        #No.FUN-680136 VARCHAR(5)
DEFINE g_cnt           LIKE type_file.num10       #No.FUN-680136 INTEGER
DEFINE g_msg           LIKE ze_file.ze03          #No.FUN-680136 VARCHAR(72)
DEFINE g_flag          LIKE type_file.chr1        #No.FUN-680136 VARCHAR(1)
DEFINE g_ima906        LIKE ima_file.ima906       #FUN-560043
DEFINE g_ima918       LIKE ima_file.ima918     #MOD-A90100
DEFINE g_ima921       LIKE ima_file.ima921     #MOD-A90100
DEFINE l_rvbs         RECORD LIKE rvbs_file.*  #MOD-A90100
DEFINE l_plant_new     LIKE type_file.chr10       #FUN-980020    #
DEFINE g_InTransaction LIKE type_file.num5        #FUN-AA0023
DEFINE p_plant         LIKE azp_file.azp01        #FUN-AA0023
 
 
#FUN-AA0023--modify---str---
#MAIN
#   OPTIONS                                 #改變一些系統預設值
#        INPUT NO WRAP
#    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
# 
#   LET g_argv1 = ARG_VAL(1)
#
#   IF (NOT cl_user()) THEN
#      EXIT PROGRAM
#   END IF
#  
#   WHENEVER ERROR CALL cl_err_msg_log
#  
#   IF (NOT cl_setup("APM")) THEN
#      EXIT PROGRAM
#   END IF
# 
#   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
#
#   SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
#   SELECT * INTO g_pod.* FROM pod_file WHERE pod00 = '0'
#   IF cl_null(g_pod.pod01) THEN       #三角貿易使用匯率
#      LET g_pod.pod01='T'
#   END IF
# 
#   CREATE TEMP TABLE p840_file(
#        p_no      LIKE type_file.num5,  
#        pab_no    LIKE pmn_file.pmn01,
#        pab_item  LIKE type_file.num5,  
#        pab_price LIKE oeb_file.oeb13)
#
#   IF cl_null(g_argv1) THEN 
#      CALL p840_p1()
#   ELSE
#      LET tm.wc = " rvu01='",g_argv1,"' " 
#      OPEN WINDOW win WITH 6 ROWS,70 COLUMNS 
#      CALL p840_p2()
#      IF g_success = 'Y' THEN 
#         CALL cl_cmmsg(1)
#         COMMIT WORK
#      ELSE 
#         CALL cl_rbmsg(1)
#         ROLLBACK WORK
#      END IF
#      CLOSE WINDOW win
#   END IF
#   DROP TABLE p840_file
#
#   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
#END MAIN
FUNCTION p840(p_argv1,p_plant1,p_InTransaction)            
   DEFINE p_argv1            LIKE oga_file.oga01  
   DEFINE p_InTransaction    LIKE type_file.num5  
   DEFINE p_plant1           LIKE azp_file.azp01       
   DEFINE l_sql              STRING
 
   WHENEVER ERROR CONTINUE
  
   LET g_argv1 = p_argv1  
   LET p_plant = p_plant1

   LET g_InTransaction = p_InTransaction  #是否有事務
   IF cl_null(g_Intransaction) THEN 
      LET g_Intransaction = FALSE 
   END IF   
    
   LET l_sql = "SELECT * FROM ",cl_get_target_table(p_plant,'sma_file'), 
               " WHERE sma00='0'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql        
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql 
   PREPARE pre_sel_sma FROM l_sql
   EXECUTE pre_sel_sma INTO  g_sma.*

   LET l_sql = "SELECT * FROM ",cl_get_target_table(p_plant,'pod_file'), 
               " WHERE pod00 = '0'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql        
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql 
   PREPARE pre_sel_pod FROM l_sql
   EXECUTE pre_sel_pod INTO g_pod.*
   IF cl_null(g_pod.pod01) THEN           #三角貿易使用匯率
      LET g_pod.pod01='T'
   END IF

#  SELECT * INTO g_oaz.* FROM oaz_file WHERE oaz00 = '0'   #FUN-C50136
      
   IF NOT g_InTransaction THEN   #FUN-AA0023
      CREATE TEMP TABLE p840_file(
         p_no      LIKE type_file.num5,  
         pab_no    LIKE pmn_file.pmn01,
         pab_item  LIKE type_file.num5,  
         pab_price LIKE oeb_file.oeb13)  
   END IF
        
   #若有傳參數則不用輸入畫面
   IF cl_null(g_argv1) THEN 
      CALL p840_p1()
   ELSE
      LET tm.wc = " rvu01='",g_argv1,"' " 
      IF NOT g_InTransaction THEN   #FUN-AA0023
         OPEN WINDOW win WITH 6 ROWS,70 COLUMNS 
      END IF
      CALL p840_p2()
      IF NOT g_InTransaction THEN
         IF g_success = 'Y' THEN 
            CALL cl_cmmsg(1) 
            COMMIT WORK
         ELSE 
            CALL cl_rbmsg(1)
            ROLLBACK WORK
         END IF
         CLOSE WINDOW win
         DROP TABLE p840_file         
      END IF 
   END IF
END FUNCTION  
#FUN-AA0023--modify---end---
 
FUNCTION p840_p1()
 DEFINE l_ac LIKE type_file.num5    #No.FUN-680136 SMALLINT
 DEFINE l_i LIKE type_file.num5    #No.FUN-680136 SMALLINT
 DEFINE l_cnt LIKE type_file.num5    #No.FUN-680136 SMALLINT
 
 OPEN WINDOW p840_w WITH FORM "apm/42f/apmp840" 
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 CALL cl_ui_init()
 
 WHILE TRUE
    CONSTRUCT BY NAME tm.wc ON rvu01,rvu03 
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
 
      ON ACTION controlp                                                                                                            
         CASE                                                                                                                        
         WHEN INFIELD(rvu01)                                                                                                        
             CALL cl_init_qry_var()     
             LET g_qryparam.form = "q_rvu99"                                                                                        
             LET g_qryparam.state = "c"                                                                                             
             CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                     
             DISPLAY g_qryparam.multiret to rvu01  
             NEXT FIELD rvu01                                                                                                       
         END CASE                                                                                                                   
 
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
 
    IF NOT cl_sure(0,0) THEN 
       CONTINUE WHILE
    END IF
    CALL p840_p2()
    IF g_success = 'Y' THEN 
       COMMIT WORK
       CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
    ELSE
       ROLLBACK WORK
       CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
    END IF
 
    IF g_flag THEN
       CONTINUE WHILE
    ELSE
       EXIT WHILE
    END IF
 END WHILE
 
 CLOSE WINDOW p840_w
 
END FUNCTION
 
FUNCTION p840_p2()
  DEFINE l_pmm  RECORD LIKE pmm_file.*
  DEFINE l_pmn  RECORD LIKE pmn_file.*
  DEFINE l_occ  RECORD LIKE occ_file.*
  DEFINE l_pmc  RECORD LIKE pmc_file.*
  DEFINE l_pob  RECORD LIKE pob_file.*
  DEFINE l_poc  RECORD LIKE poc_file.*
  DEFINE l_gec  RECORD LIKE gec_file.*
  DEFINE l_ima  RECORD LIKE ima_file.*
  DEFINE l_sql  LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(1200)
  DEFINE l_sql1 LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(600)
  DEFINE l_sql2 LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(1600)
  DEFINE i,l_i  LIKE type_file.num5    #No.FUN-680136 SMALLINT
  DEFINE l_j    LIKE type_file.num5,   #No.FUN-680136 SMALLINT
         l_x    LIKE poy_file.poy38,   #No.FUN-680136 VARCHAR(5),                    #No.FUN-550060
         l_msg  LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(60)
  DEFINE l_oea62 LIKE oea_file.oea62
  DEFINE s_oea62 LIKE oea_file.oea62
  DEFINE l_occ02 LIKE occ_file.occ02,
         l_occ08 LIKE occ_file.occ08,
         l_occ11 LIKE occ_file.occ11,
         l_rvb29 LIKE rvb_file.rvb29,       #退貨量
         l_rvb31 LIKE rvb_file.rvb31        #可入庫量
  DEFINE l_poy02 LIKE poy_file.poy02   #NO.FUN-670007
  DEFINE l_c     LIKE type_file.num5   #No.FUN-680136 SMALLINT                  #NO.FUN-670007
  DEFINE k       LIKE type_file.num5   #NO.FUN-670007
  DEFINE l_cnt   LIKE type_file.num5   #NO.TQC-7C0064
  DEFINE l_flag  LIKE type_file.chr1   #TQC-D30020 add
  CALL cl_wait() 
 
  IF NOT g_InTransaction THEN  #FUN-AA0023
      LET g_success = 'Y'
      BEGIN WORK
  END IF
  #BEGIN WORK 
  #LET g_success='Y'
 
  DELETE FROM p840_file
 
  #讀取符合條件之三角貿易採單資料
  LET l_sql="SELECT rva_file.*,rvu_file.* ",
            # "  FROM rva_file,rvu_file ",
            "  FROM ",cl_get_target_table(p_plant,'rva_file'),",",#FUN-AA0023
                      cl_get_target_table(p_plant,'rvu_file'),#FUN-AA0023
            " WHERE rvuconf = 'Y' ",   #必須為已確認
	        "   AND rvu00 = '3' ",     #倉退單
            "   AND rvu08 = 'TAP' ",   #代採買採購性質
            "   AND rvu02 = rva01 ",
            "   AND (rvu20 = 'N' OR rvu20 is null OR rvu20 = '')",#未拋轉
            "   AND ",tm.wc CLIPPED
  CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #FUN-AA0023
  CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-AA0023
  PREPARE p840_p1 FROM l_sql 
  IF STATUS THEN CALL cl_err('pre1',STATUS,1) END IF
  DECLARE p840_curs1 CURSOR FOR p840_p1
  CALL s_showmsg_init()        #No.FUN-710030
  LET l_flag = 'N'             #TQC-D30020 add
  FOREACH p840_curs1 INTO g_rva.*,g_rvu.*
     LET l_flag = 'Y'            #TQC-D30020 add 
     IF SQLCA.SQLCODE <> 0 THEN
      LET g_success = 'N'  #No.FUN-8A0086 
      IF g_bgerr THEN
         CALL s_errmsg("","","foreach cursor p840_curs1",SQLCA.sqlcode,1)
      ELSE
         CALL cl_err3("","","","",SQLCA.sqlcode,"","foreach cursor p840_curs1",1)
      END IF
        EXIT FOREACH
     END IF
      IF g_success="N" THEN
         LET g_totsuccess="N"
         LET g_success="Y"
      END IF
     IF cl_null(g_rva.rva02) THEN 
        #只讀取第一筆採購單之資料
        # LET l_sql1= " SELECT pmm_file.* FROM pmm_file,rvb_file ",
        LET l_sql1= " SELECT pmm_file.* FROM ",cl_get_target_table(p_plant,'pmm_file'),",",
                                               cl_get_target_table(p_plant,'rvb_file'),#FUN-AA0023
                    "  WHERE pmm01 = rvb04 ",
                    "    AND rvb01 = '",g_rva.rva01,"'"
        CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1         #FUN-AA0023
        CALL cl_parse_qry_sql(l_sql1,p_plant) RETURNING l_sql1 #FUN-AA0023
        PREPARE pmm_pre FROM l_sql1
        DECLARE pmm_f CURSOR FOR pmm_pre
        OPEN pmm_f
        FETCH pmm_f INTO g_pmm.*
     ELSE
        #讀取該入庫單之採購單
       # SELECT * INTO g_pmm.*
       #   FROM pmm_file
       #  WHERE pmm01 = g_rva.rva02
        LET l_sql1 = "SELECT * FROM ",cl_get_target_table(p_plant,'pmm_file'),#FUN-AA0023
                     " WHERE pmm01 = '",g_rva.rva02,"'"
        CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1         #FUN-AA0023
        CALL cl_parse_qry_sql(l_sql1,p_plant) RETURNING l_sql1 #FUN-AA0023
        PREPARE pmm_pre1 FROM l_sql1
        EXECUTE pmm_pre1  INTO g_pmm.*
     END IF
     IF SQLCA.SQLCODE THEN
        LET g_success = 'N'
        IF g_bgerr THEN
           CALL s_errmsg("","","sel pmm:",SQLCA.sqlcode,1)
           CONTINUE FOREACH
        ELSE
           CALL cl_err3("","","","",SQLCA.sqlcode,"","sel pmm:",1)
           EXIT FOREACH
        END IF
     END IF
    #讀取每一筆單身收貨單的採購單號
     #FUN-AA0023--modify---str---
     #DECLARE rvv_f2 CURSOR FOR 
     #SELECT *   FROM rvv_file
     # WHERE rvv01 = g_rvu.rvu01
     LET l_sql = "SELECT *  FROM ",cl_get_target_table(p_plant,'rvv_file'),
                 " WHERE rvv01 = '",g_rvu.rvu01,"'"
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #FUN-AA0023
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-AA0023
     PREPARE rvv_pre FROM l_sql
     DECLARE rvv_f2 CURSOR FOR rvv_pre
     FOREACH rvv_f2 INTO g_rvv.*
     #取每筆單身採購單
     #DECLARE pmm_f2 CURSOR FOR 
     # SELECT * FROM pmm_file 
     #          WHERE pmm01 = g_rvv.rvv36 
     LET l_sql = "SELECT *  FROM ",cl_get_target_table(p_plant,'pmm_file'),
                 " WHERE pmm01 = '",g_rvv.rvv36,"'"
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #FUN-AA0023
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-AA0023
     PREPARE pmm_pre2 FROM l_sql
     DECLARE pmm_f2 CURSOR FOR pmm_pre2
     #FUN-AA0023--modify---end---
     OPEN  pmm_f2
     FETCH pmm_f2 INTO g_pmm.*
     IF g_pmm.pmm906 != 'Y' THEN #非起始採購單
        LET g_success = 'N'
        IF g_bgerr THEN
           CALL s_errmsg("","","sel pmm:",SQLCA.sqlcode,1)
           CONTINUE FOREACH
        ELSE
           CALL cl_err3("","","","",SQLCA.sqlcode,"","sel pmm:",1)
           EXIT FOREACH
        END IF
     END IF   
     LET g_pmm50 = g_pmm.pmm50
     #no.6158檢查各工廠關帳日(sma53)
     IF s_mchksma53(g_pmm.pmm904,g_rvu.rvu03) THEN
        LET g_success='N' EXIT FOREACH
     END IF
 
     END FOREACH   #FUN-830035 add
     IF g_success ='N' THEN EXIT FOREACH END IF   #FUN-830035 add
 
     #讀取三角貿易流程代碼資料
     #SELECT * INTO g_poz.*
     #  FROM poz_file
     # WHERE poz01=g_pmm.pmm904 AND poz00='2'
     LET l_sql = "SELECT * FROM ",cl_get_target_table(p_plant,'poz_file'),
                 " WHERE poz01 = '",g_pmm.pmm904,"'",
                 "   AND poz00='2'"
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #FUN-AA0023
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-AA0023
     PREPARE poz_pre1 FROM l_sql
     EXECUTE poz_pre1 INTO g_poz.*
     IF SQLCA.sqlcode THEN
        LET  g_success = 'N'
        IF g_bgerr THEN
           CALL s_errmsg("poz01",g_pmm.pmm904,"","axm-318",1)
           CONTINUE FOREACH
        ELSE
           CALL cl_err3("sel","poz_file",g_pmm.pmm904,"","axm-318","","",1)
           EXIT FOREACH
        END IF
     END IF
     #來源廠商已改為單身第0站的下游廠商編號
     # SELECT poy03 INTO g_poz.poz04 
     #  FROM poy_file
     # WHERE poy01 = g_pmm.pmm904 
     #   AND poy02 = 0
     LET l_sql = "SELECT poy03 FROM ",cl_get_target_table(p_plant,'poy_file'),
                 " WHERE poy01 = '",g_pmm.pmm904,"'",
                 "   AND poy02 = 0"
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #FUN-AA0023
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-AA0023
     PREPARE poy_pre1 FROM l_sql
     EXECUTE poy_pre1 INTO g_poz.poz04
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
     #no.6158抓取單別拋轉設定檔
     CALL p840_flow99()                           #No.8128 取得多角序號
     CALL s_mtrade_last_plant(g_pmm.pmm904) 
          RETURNING p_last,p_last_plant
     IF cl_null(p_last) THEN LET g_success = 'N' EXIT FOREACH END IF
 
     #依流程代碼最多6層
     FOR i = 1 TO p_last
         LET k = i + 1
         #得到廠商/客戶代碼及database
         CALL p840_azp(i)
#----移到站別資料之後做  加傳入流程代碼/站別參數
         LET g_t1 = s_get_doc_no(g_rvu.rvu01)        #No.FUN-550060
         CALL s_mutislip('2','2',g_t1,g_poz.poz01,i)                      
              RETURNING g_sw,oha_t1,l_x,l_x,l_x,l_x
         IF g_sw THEN 
            LET g_success = 'N' EXIT FOREACH 
         END IF 
         IF cl_null(oha_t1) THEN
             LET g_msg = l_dbs_new CLIPPED,oha_t1 CLIPPED
             IF g_bgerr THEN
                CALL s_errmsg("","","g_msg",'axm4019',1)
             ELSE
                CALL cl_err3("","","","",'axm4019',"","g_msg",1)
             END IF
             LET g_success = 'N'
             EXIT FOREACH
         ELSE                                                                                                                 
             LET l_cnt = 0                                                                                                     
             #LET l_sql = "SELECT COUNT(*) FROM ",l_dbs_new,"oay_file ", 
             LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new,'oay_file'), #FUN-A50102             
                         " WHERE oayslip = '",oha_t1,"'"                                                                       
 	         CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
             CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
             PREPARE oay_pre1 FROM l_sql                                                                                       
             EXECUTE oay_pre1 INTO l_cnt                                                                                       
             IF l_cnt = 0 THEN                                                                                                 
                LET g_msg = l_dbs_new CLIPPED,oha_t1 CLIPPED                                                                   
                IF g_bgerr THEN
                   CALL s_errmsg("","","g_msg",'axm-931',1)
                ELSE
                   CALL cl_err3("","","","",'axm-931',"","g_msg",1)            
                END IF                                                   
                LET g_success = 'N'                                                                                            
                EXIT FOREACH                                                                                                   
             END IF                                                                                                            
         END IF 
         IF i <> p_last THEN
             CALL s_mutislip('2','2',g_t1,g_poz.poz01,k)                      
                  RETURNING g_sw,l_x,rvu_t1,l_x,l_x,l_x
             IF g_sw THEN 
                LET g_success = 'N' EXIT FOREACH 
             END IF 
             IF cl_null(rvu_t1) THEN
                 LET g_msg = l_dbs_new CLIPPED,rvu_t1 CLIPPED
                 IF g_bgerr THEN
                    CALL s_errmsg("","","g_msg",'axm4019',1)
                 ELSE
                    CALL cl_err3("","","","",'axm4019',"","g_msg",1)
                 END IF
                 LET g_success = 'N'
                 EXIT FOREACH
             END IF 
         ELSE
            IF i = p_last AND NOT cl_null(g_pmm50) THEN
              LET rvu_t1=''  #MOD-870123 add
              #SELECT poy42 INTO rvu_t1
              #  FROM poy_file
              # WHERE poy01 = g_poz.poz01
              #   AND poy02 = 99
              LET l_sql = " SELECT poy42 FROM ",cl_get_target_table(p_plant,'poy_file'),
                          "  WHERE poy01 = '",g_poz.poz01,"'",
                          "    AND poy02 = 99 "
              CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #FUN-AA0023
              CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-AA0023
              PREPARE poy_pre2 FROM l_sql
              EXECUTE poy_pre2 INTO rvu_t1
            ELSE
             CALL s_mutislip('2','2',g_t1,g_poz.poz01,i)                      
                  RETURNING g_sw,l_x,rvu_t1,l_x,l_x,l_x
             IF g_sw THEN 
                LET g_success = 'N' EXIT FOREACH 
             END IF 
            END IF                         #no.TQC-810029 add
             IF cl_null(rvu_t1) THEN
                 LET g_msg = l_dbs_new CLIPPED,rvu_t1 CLIPPED
                 IF g_bgerr THEN
                    CALL s_errmsg("","","g_msg",'axm4019',1)
                 ELSE
                    CALL cl_err3("","","","",'axm4019',"","g_msg",1)
                 END IF
                 LET g_success = 'N'
                 EXIT FOREACH
             END IF 
         END IF
         CALL p840_chk99()            #No.8128
         CALL p840_azi(g_oea.oea23)   #讀取幣別資料

         #-----MOD-A90100---------
         LET l_sql2 = "INSERT INTO ",cl_get_target_table(l_plant_new,'rvbs_file'),  
                      "(rvbs00,rvbs01,rvbs02,rvbs021,rvbs022,rvbs03,",
                      " rvbs04,rvbs05,rvbs06,rvbs07,rvbs08,rvbs09,rvbs13,rvbsplant,rvbslegal) ",
                      " VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?) "
         CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2
         PREPARE ins_rvbs FROM l_sql2
         #-----END MOD-A90100-----
 
             CALL p840_p3(i)
     END FOR  {一個訂單流程代碼結束}
         #更新起始倉退單單頭檔之拋轉否='Y'
         #UPDATE rvu_file
         #   SET rvu20='Y'
         # WHERE rvu01=g_rvu.rvu01
         LET l_sql = "UPDATE ",cl_get_target_table(p_plant,'rvu_file'),
                     "   SET rvu20 = 'Y'",
                     " WHERE rvu01 = '",g_rvu.rvu01,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #FUN-AA0023
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN--AA0023
         PREPARE updrvu_pre1 FROM l_sql                                                                                       
         EXECUTE updrvu_pre1    
         IF SQLCA.SQLCODE <> 0 THEN
            LET g_success='N' 
            IF g_bgerr THEN
               CALL s_errmsg("rvu20",g_rvu.rvu01,"",SQLCA.sqlcode,1)
               CONTINUE FOREACH
            ELSE
               CALL cl_err3("upd","rvu_file",g_rvu.rvu01,"",SQLCA.sqlcode,"","",1)
               EXIT FOREACH
            END IF
         END IF
  END FOREACH
   IF l_flag = 'N' OR g_totsuccess="N" THEN     #TQC-D30020 add l_flag = 'N'
      LET g_success="N"
   END IF
END FUNCTION
 
FUNCTION p840_p3(i) 
   DEFINE i LIKE type_file.num5
   DEFINE l_oea62 LIKE oea_file.oea62
   DEFINE s_oea62 LIKE oea_file.oea62
   DEFINE l_occ02 LIKE occ_file.occ02,
          l_occ08 LIKE occ_file.occ08,
          l_occ11 LIKE occ_file.occ11,
          l_rvb29 LIKE rvb_file.rvb29,       #退貨量
          l_rvb31 LIKE rvb_file.rvb31        #可入庫量
   DEFINE l_sql2  LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(1600)
   DEFINE l_sql   STRING  #FUN-AA0023
   DEFINE l_ohbiicd028  LIKE ohbi_file.ohbiicd028    #FUN-B90012
   DEFINE l_ohbiicd029  LIKE ohbi_file.ohbiicd029    #FUN-B90012
 
     #新增銷退單單頭檔(oha_file)
     CALL p840_ohains()
 
     #若為逆拋只拋轉到銷退單，倉退單不拋..
     IF i <> p_last OR ( i = p_last AND NOT cl_null(g_pmm50) AND
                         g_poz.poz011 <> '2') THEN #No.7771
        #新增倉退單單頭檔(rvu_file)
        CALL p840_rvuins()
     END IF
 
     LET l_oea62=0
     #讀取入庫單身檔(rvv_file)
     #FUN-AA0023--modify---str---
     #DECLARE rvv_cus CURSOR FOR
     # SELECT * FROM rvv_file
     #  WHERE rvv01 = g_rvu.rvu01
     LET l_sql = "SELECT *  FROM ",cl_get_target_table(p_plant,'rvv_file'),
                 " WHERE rvv01 = '",g_rvu.rvu01,"'"
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #FUN-AA0023
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-AA0023
     PREPARE rvv_pre1 FROM l_sql
     DECLARE rvv_cus CURSOR FOR rvv_pre1
     FOREACH rvv_cus INTO g_rvv.* 
        IF SQLCA.SQLCODE <>0 THEN EXIT FOREACH END IF 

        #-----MOD-A90100---------
        LET l_sql = "SELECT * FROM ",cl_get_target_table (p_plant,'rvbs_file'),
                    " WHERE rvbs01 = '",g_rvu.rvu01,"'",
                    "   AND rvbs02 = ",g_rvv.rvv02
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql       
        CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
        PREPARE p840_g_rvbs_p FROM l_sql
        DECLARE p840_g_rvbs CURSOR FOR p840_g_rvbs_p
        #-----END MOD-A90100-----
        #FUN-B90012-add-str--
        IF s_industry('icd') THEN
           LET l_sql = "SELECT * FROM ",cl_get_target_table (p_plant,'idd_file'),
                       " WHERE idd10 = '",g_rvv.rvv01,"'",
                       "   AND idd11 =  ",g_rvv.rvv02
           CALL cl_replace_sqldb(l_sql) RETURNING l_sql
           CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
           PREPARE p840_g_idd_p FROM l_sql
           DECLARE p840_g_idd CURSOR FOR p840_g_idd_p
        END IF
        #FUN-B90012-add-end--



        # SELECT ima906 INTO g_ima906 FROM ima_file 
        #  WHERE ima01 = g_rvv.rvv31
        LET l_sql = "SELECT ima906 FROM ",cl_get_target_table(p_plant,'ima_file'),
                    " WHERE ima01 = '",g_rvv.rvv31,"'"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #FUN-AA0023
        CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-AA0023
        PREPARE ima906_pre1 FROM l_sql            
        EXECUTE ima906_pre1 INTO g_ima906
        #重新取得單身的流程序號
        #  SELECT pmm99 INTO g_pmm.pmm99 FROM pmm_file
        #   WHERE pmm01 = g_rvv.rvv36
        LET l_sql = "SELECT pmm99 FROM ",cl_get_target_table(p_plant,'pmm_file'),
                    " WHERE pmm01 = '",g_rvv.rvv36,"'"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #FUN-AA0023
        CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-AA0023
        PREPARE pmm99_pre1 FROM l_sql            
        EXECUTE pmm99_pre1 INTO g_pmm.pmm99
 
         #---- 新增銷退單單身檔(ohb_file)----
         CALL p840_ohbins(i)
         CALL p840_log(l_ohb.ohb04,l_ohb.ohb09,l_ohb.ohb091,
                       l_ohb.ohb092,l_ohb.ohb12,'5') 
 
         #若為逆拋只拋轉到銷退單，倉退單不拋..
         IF i <> p_last OR ( i = p_last AND NOT cl_null(g_pmm50) AND
                             g_poz.poz011 <> '2') THEN
            #---- 新增倉退單身檔(rvv_file)----
            CALL p840_rvvins(i)
            #---- 新增 tlf_file -----
            CALL p840_log(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,
                          l_rvv.rvv34,l_rvv.rvv17,'4')
	 END IF
   
         IF g_success='N' THEN EXIT FOREACH END IF
 
         IF i <> p_last OR ( i = p_last AND NOT cl_null(g_pmm50) AND 
                             g_poz.poz011 <> '2') THEN
            # 抓取來源收貨單的退貨量與可入庫量更新rvb..
            #SELECT rvb29,rvb31 INTO l_rvb29,l_rvb31 FROM rvb_file
            # WHERE rvb01 = g_rvv.rvv04 AND rvb02 = g_rvv.rvv05
            LET l_sql = "SELECT rvb29,rvb31 FROM ",cl_get_target_table(p_plant,'rvb_file'),
                        " WHERE rvb01 = '",g_rvv.rvv04,"'", 
                        "   AND rvb02 = '",g_rvv.rvv05,"'"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #FUN-AA0023
            CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-AA0023
            PREPARE rvb_pre1 FROM l_sql            
            EXECUTE rvb_pre1 INTO l_rvb29,l_rvb31
            IF cl_null(l_rvb29) THEN LET l_rvb29 = 0 END IF
            IF cl_null(l_rvb31) THEN LET l_rvb31 = 0 END IF
            #LET l_sql2="UPDATE ",l_dbs_tra CLIPPED,"rvb_file ",  #FUN-980092
            LET l_sql2="UPDATE ",cl_get_target_table(l_plant_new,'rvb_file'), #FUN-A50102
                       "   SET rvb29 = ?,",
                       "       rvb31 = ?",
                       " WHERE rvb01 = '",l_rvv.rvv04 ,"'",  #No.FUN-620025
                       "   AND rvb02 = ",g_rvv.rvv05
 	        CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
            CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
            PREPARE upd_rvb FROM l_sql2
            EXECUTE upd_rvb USING l_rvb29,l_rvb31
            #LET l_sql2="UPDATE ",l_dbs_tra CLIPPED,"pmn_file",  #FUN-980092
            LET l_sql2="UPDATE ",cl_get_target_table(l_plant_new,'pmn_file'), #FUN-A50102
                       " SET pmn58 = pmn58 + ? ",
                       " WHERE pmn01 = ? AND pmn02 = ? "
 	        CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
            CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
            PREPARE upd_pmn FROM l_sql2
            EXECUTE upd_pmn USING 
                 g_rvv.rvv17,
                 l_pmm01,g_rvv.rvv37          #No.FUN-620025
            IF SQLCA.sqlcode<>0 THEN
               LET g_success = 'N'
               IF g_bgerr THEN
                  CALL s_errmsg("","","upd pmn:",SQLCA.sqlcode,1)
                  CONTINUE FOREACH
               ELSE
                  CALL cl_err3("","","","",SQLCA.sqlcode,"","upd pmn:",1)
                  EXIT FOREACH
               END IF
            END IF
         END IF
 
	 #更新最終資料庫img及ima(幫銷退單做入帳的動作)
	 IF (i = p_last AND cl_null(g_pmm50)) OR 
	    (i = p_last AND g_poz.poz011 = '2') THEN # 逆拋拋至銷退單為止
            CALL s_mupimg(1,l_ohb.ohb04,l_ohb.ohb09,l_ohb.ohb091,
                            l_ohb.ohb092,g_rvv.rvv17*g_rvv.rvv35_fac,
                            #g_rvu.rvu03, l_plant_new,0,'','')  #FUN-980092    #MOD-A90100
                            #g_rvu.rvu03, l_plant_new,-1,l_oha.oha01,l_ohb.ohb03)  #FUN-980092    #MOD-A90100 #TQC-B90236 mark
                            g_rvu.rvu03, l_plant_new,1,l_oha.oha01,l_ohb.ohb03)  #FUN-980092    #MOD-A90100 #TQC-B90236
            IF g_sma.sma115 = 'Y' THEN  #No.CHI-760003 
               IF g_ima906 = '2' THEN
                  CALL s_mupimgg(1,l_ohb.ohb04,l_ohb.ohb09,l_ohb.ohb091,
                                  l_ohb.ohb092,g_rvv.rvv80,g_rvv.rvv82,
                                  g_rvu.rvu03, l_plant_new)  #FUN-980092
                  CALL s_mupimgg(1,l_ohb.ohb04,l_ohb.ohb09,l_ohb.ohb091,
                                  l_ohb.ohb092,g_rvv.rvv83,g_rvv.rvv85,
                                  g_rvu.rvu03, l_plant_new)    #FUN-980092
               END IF
               IF g_ima906 = '3' THEN
                  CALL s_mupimgg(1,l_ohb.ohb04,l_ohb.ohb09,l_ohb.ohb091,
                                  l_ohb.ohb092,g_rvv.rvv83,g_rvv.rvv85,
                                  g_rvu.rvu03, l_plant_new)  #FUN-980092
               END IF
            END IF #No.CHI-760003  
 
            CALL s_mudima(l_ohb.ohb04,l_plant_new)  #FUN-980092
	    IF g_success='N' THEN EXIT FOREACH END IF
         END IF
         IF l_aza.aza50 = 'Y' THEN     #使用分銷功能
            IF l_oha.oha05 = '4' THEN  #代送銷退單
               CALL p840_log(l_ohb.ohb04,l_ohb.ohb09,l_ohb.ohb091,
                             l_ohb.ohb092,l_ohb.ohb12,'1') 
               IF i = p_last THEN
                  CALL s_mupimg(-1,l_ohb.ohb04, l_ohb.ohb09,l_ohb.ohb091,l_ohb.ohb092,
                                #l_ohb.ohb12*l_ohb.ohb15_fac,l_oha.oha02,l_plant_new,0,'','')  #FUN-980092    #MOD-A90100
                                #l_ohb.ohb12*l_ohb.ohb15_fac,l_oha.oha02,l_plant_new,0,l_oha.oha01,l_ohb.ohb03)  #FUN-980092    #MOD-A90100  #TQC-B90236 mark
                                l_ohb.ohb12*l_ohb.ohb15_fac,l_oha.oha02,l_plant_new,1,l_oha.oha01,l_ohb.ohb03)  #FUN-980092    #MOD-A90100   #TQC-B90236
                  IF g_sma.sma115 = 'Y' THEN  #No.CHI-760003  
                     IF g_ima906 = '2' THEN
                        CALL s_mupimgg(-1,l_ohb.ohb04,l_ohb.ohb09,l_ohb.ohb091,l_ohb.ohb092,
                                       l_ohb.ohb910,l_ohb.ohb912, l_oha.oha02,l_plant_new)   #FUN-980092
                        CALL s_mupimgg(-1,l_ohb.ohb04,l_ohb.ohb09,l_ohb.ohb091,l_ohb.ohb092,
                                       l_ohb.ohb913,l_ohb.ohb915, l_oha.oha02,l_plant_new)   #FUN-980092
                     END IF
                     IF g_ima906 = '3' THEN
                        CALL s_mupimgg(-1,l_ohb.ohb04,l_ohb.ohb09,l_ohb.ohb091,l_ohb.ohb092,
                                       l_ohb.ohb913,l_ohb.ohb915, l_oha.oha02,l_plant_new)   #FUN-980092
                     END IF
                  END IF #No.CHI-760003  
                  CALL s_mudima(l_ohb.ohb04,l_plant_new)  #FUN-980092
               END IF
            END IF
         END IF 
     END FOREACH {rvv_cus}
 
     MESSAGE ""
END FUNCTION
 
FUNCTION p840_ogains()   #代送出貨單單頭
DEFINE li_result  LIKE type_file.num5    #No.FUN-680136 SMALLINT
DEFINE l_t        LIKE oay_file.oayslip  #No.FUN-680136 VARCHAR(5)
DEFINE l_occ02    LIKE occ_file.occ02
DEFINE l_occ11    LIKE occ_file.occ11
DEFINE l_tqk04    LIKE tqk_file.tqk04
DEFINE l_sql2     STRING                  #No.CHI-950020
DEFINE l_plant    LIKE azp_file.azp01    #FUN-980006 add
DEFINE l_legal    LIKE azw_file.azw02    #FUN-980006 add
 
      INITIALIZE l_oga.* TO NULL
           
      LET l_plant = g_poy.poy04  #FUN-980006 add 
      CALL s_getlegal(l_plant) RETURNING l_legal  #FUN-980006 add 
 
      #取得產生出貨單別
      LET l_t = s_get_doc_no(l_oha.oha01) 
      LET l_sql2 = "SELECT oayauno,oay16,oay19,oay20 ",
                   #" FROM ",l_dbs_new CLIPPED,"oay_file ",
                   " FROM ",cl_get_target_table(l_plant_new,'oay_file'), #FUN-A50102
                   " WHERE oayslip='",l_t,"' " 
 	  CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
      CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
      PREPARE oay_p1 FROM l_sql2
      IF STATUS THEN
         IF g_bgerr THEN
            CALL s_errmsg("","","",STATUS,1)
         ELSE
            CALL cl_err3("","","","",STATUS,"","",1)
         END IF
      END IF
      DECLARE oay_c1 CURSOR FOR oay_p1
      OPEN oay_c1
      FETCH oay_c1 INTO l_oayauno,l_oay16,l_oay19,l_oay20
      IF SQLCA.SQLCODE <> 0 OR cl_null(l_oay16) OR cl_null(l_oay19) 
         OR cl_null(l_oay20) THEN
         IF g_bgerr THEN
            CALL s_errmsg("","","","atm-394",1)
         ELSE
            CALL cl_err3("","","","","atm-394","","",1)
         END IF
         LET g_success='N'
         RETURN
      END IF
      CLOSE oay_c1
      LET l_sql2 = "SELECT azf10 ",
                   #" FROM ",l_dbs_new CLIPPED,"azf_file ",
                   " FROM ",cl_get_target_table(l_plant_new,'azf_file'), #FUN-A50102
                   " WHERE azf01 ='",l_oay19,"' ",
                   " AND   azf02='2'",      #No.FUN-930104
                   " AND   azf09='1'"       #No.FUN-930104
 	  CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
      CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
      PREPARE azf_p1 FROM l_sql2
      IF STATUS THEN
         IF g_bgerr THEN
            CALL s_errmsg("","","azf_p1",STATUS,1)
            CALL cl_err3("","","","",STATUS,"","azf_p1",1)
         END IF
      END IF
      DECLARE azf_c1 CURSOR FOR azf_p1
      OPEN azf_c1
      FETCH azf_c1 INTO l_azf10
      CLOSE azf_c1
      IF cl_null(l_azf10) THEN LET l_azf10='N' END IF
      CALL s_auto_assign_no("axm",l_oay16,l_oha.oha02,"","","",l_plant_new,"","")  #FUN-980092
      RETURNING li_result,g_oga01
      IF (NOT li_result) THEN 
         LET g_msg = l_plant_new CLIPPED,g_oga01
         CALL s_errmsg("oga01",g_oga01,g_msg CLIPPED,"mfg3046",1) 
         LET g_success ='N'
         RETURN
      END IF   
      LET l_oga.oga01 = g_oga01
 
      LET l_sql2 = "SELECT * ",
                   #" FROM ",l_dbs_new CLIPPED,"occ_file ",
                   " FROM ",cl_get_target_table(l_plant_new,'occ_file'), #FUN-A50102
                   " WHERE occ01='",l_oha.oha1014,"' " 
 	  CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
      CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
      PREPARE occ_p1 FROM l_sql2
      IF STATUS THEN
         IF g_bgerr THEN
            CALL s_errmsg("","","occ_p1",STATUS,1)
         ELSE
            CALL cl_err3("","","","",STATUS,"","occ_p1",1)
         END IF
      END IF
      DECLARE occ_c1 CURSOR FOR occ_p1
      OPEN occ_c1
      FETCH occ_c1 INTO l_occ.*
      IF SQLCA.SQLCODE <> 0 THEN
         LET g_success='N'
         RETURN
      END IF
      CLOSE occ_c1
      IF cl_null(l_occ.occ07) THEN LET l_occ.occ07='' END IF
      IF cl_null(l_occ.occ08) THEN LET l_occ.occ08='' END IF
      IF cl_null(l_occ.occ09) THEN LET l_occ.occ09='' END IF
      IF cl_null(l_occ.occ1005) THEN LET l_occ.occ1005='' END IF
      IF cl_null(l_occ.occ1006) THEN LET l_occ.occ1006='' END IF
      IF cl_null(l_occ.occ1023) THEN LET l_occ.occ1023='' END IF
      IF cl_null(l_occ.occ1022) THEN LET l_occ.occ1022='' END IF
      LET l_sql2 = "SELECT occ02,occ11 ",
                   #" FROM ",l_dbs_new CLIPPED,"occ_file ",
                   " FROM ",cl_get_target_table(l_plant_new,'occ_file'), #FUN-A50102
                   " WHERE occ01='",l_occ.occ07,"' " 
 	  CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
      CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
      PREPARE occ_p2 FROM l_sql2
      IF STATUS THEN
         IF g_bgerr THEN
            CALL s_errmsg("","","occ_p2",STATUS,1)
         ELSE
            CALL cl_err3("","","","",STATUS,"","occ_p2",1)
         END IF
      END IF
      DECLARE occ_c2 CURSOR FOR occ_p2
      OPEN occ_c2
      FETCH occ_c2 INTO l_occ02,l_occ11
      CLOSE occ_c2
      IF cl_null(l_occ02) THEN LET l_occ02='' END IF
      IF cl_null(l_occ11) THEN LET l_occ11='' END IF
                
      LET l_sql2 = "SELECT tqk04 ",
                   #" FROM ",l_dbs_new CLIPPED,"tqk_file ",
                   " FROM ",cl_get_target_table(l_plant_new,'tqk_file'), #FUN-A50102
                   " WHERE tqk01='",l_oha.oha1014,"' ",
                   "   AND tqk02='",l_oha.oha1002,"' ",
                   "   AND tqk03='",l_occ.occ1023,"' "
 	  CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
      CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
      PREPARE tqk_p2 FROM l_sql2
      IF STATUS THEN
         IF g_bgerr THEN
            CALL s_errmsg("","","tqk_p2",STATUS,1)
         ELSE
            CALL cl_err3("","","","",STATUS,"","tqk_p2",1)
         END IF
      END IF
      DECLARE tqk_c2 CURSOR FOR tqk_p2
      OPEN tqk_c2
      FETCH tqk_c2 INTO l_tqk04
      CLOSE tqk_c2
      IF cl_null(l_tqk04) THEN  LET l_tqk04=''  END IF
      LET l_oga.oga00  = '1'               #出貨別
      LET l_oga.oga01  = g_oga01           #出貨單號
      LET l_oga.oga02  = l_oha.oha02       #出貨日期
      LET l_oga.oga03  = l_occ.occ07       #客戶編號：代送商
      LET l_oga.oga032 = l_occ02           #客戶簡稱
      LET l_oga.oga033 = l_occ11           #帳款客戶統一編號
      LET l_oga.oga04  = l_occ.occ09       #代送商對應的送貨客戶編號
      LET l_oga.oga05  = l_occ.occ08       #代送商對應的客戶發票別
      LET l_oga.oga07  = 'N'               #出貨是否計入未開發票的銷貨待驗收入
      LET l_oga.oga08  = '1'               #內銷
      LET l_oga.oga09  = '2'               #單據別：一般出貨單
      LET l_oga.oga14  = l_oha.oha14       #人員編號
      LET l_oga.oga15  = l_oha.oha15       #部門編號
      LET l_oga.oga161 = 0                 #訂金應收比率
      LET l_oga.oga162 = 100               #出貨應收比率
      LET l_oga.oga163 = 0                 #尾款應收比率
      LET l_oga.oga18  = l_occ.occ1023     #代送商對應的帳款客戶編號
      LET l_oga.oga20  = 'Y'               #分錄底稿是否可重新產生
      LET l_oga.oga21  = l_oha.oha21       #稅別
      LET l_oga.oga211 = l_oha.oha211      #稅率 
      LET l_oga.oga212 = l_oha.oha212      #聯數
      LET l_oga.oga213 = l_oha.oha213      #含稅否
      LET l_oga.oga23  = l_oha.oha23       #幣別
      LET l_oga.oga24  = l_oha.oha24       #匯率
      LET l_oga.oga25  = l_oha.oha25       #銷售分類一
      LET l_oga.oga26  = l_oha.oha26       #銷售分類二
      LET l_oga.oga30  = 'N'               #包裝單確認碼
      LET l_oga.oga31  = l_oha.oha31       #價格條件編號
      LET l_oga.oga32  = l_tqk04           #收款條件編號
      LET l_oga.oga50  = 0                 #原幣出貨金額(未稅)
      LET l_oga.oga501 = 0                 #本幣出貨金額
      LET l_oga.oga51  = 0                 #原幣出貨金額(含稅)
      LET l_oga.oga511 = 0                 #本幣出貨金額
      LET l_oga.oga53  = 0                 #原幣應開發票未稅金額
      LET l_oga.oga54  = 0                 #原幣已開發票未稅金額
      LET l_oga.ogaconf = 'Y'              #確認否/作廢碼
      LET l_oga.ogapost = 'Y'              #出貨扣帳否
      LET l_oga.ogaprsw = 0                #列印次數
      LET l_oga.ogauser = g_user           #資料所有者
      LET l_oga.ogagrup = g_grup           #資料所有部門
      LET l_oga.ogadate = g_today          #最近修改日
      LET l_oga.oga1001 = l_oha.oha1014    #收款客戶編號
      LET l_oga.oga1002 = l_oay20          #債權
      LET l_oga.oga1003 = l_oha.oha1003    #業績歸屬方
      LET l_oga.oga1004 = ''               #代送商
      LET l_oga.oga1005 = l_oha.oha1005    #是否計算業績
      LET l_oga.oga1006 = 0                #折扣金額(未稅)
      LET l_oga.oga1007 = 0                #折扣金額(含稅)
      LET l_oga.oga1008 = 0                #出貨單總含稅金額
      LET l_oga.oga1009 = l_occ.occ1005    #客戶所屬渠道
      LET l_oga.oga1010 = l_occ.occ1006    #客戶所屬方
      LET l_oga.oga1011 = l_occ.occ1022    #開票客戶
      LET l_oga.oga1012 = l_oha.oha01      #代送銷退單單號
      LET l_oga.oga1013 = 'N'              #已打印提單否
      LET l_oga.oga1014 = 'Y'              #是否對應代送銷退單
      LET l_oga.oga1015 = '0'              #導物流狀況碼
      LET l_oga.oga52   = 0 
      LET l_oga.oga57 = '1'        #FUN-AC0055 add
      LET l_oga.ogaoriu = g_user   #TQC-A10060  add
      LET l_oga.ogaorig = g_grup   #TQC-A10060  add
      LET l_oga.ogaud01 = l_oha.ohaud01
      LET l_oga.ogaud02 = l_oha.ohaud02
      LET l_oga.ogaud03 = l_oha.ohaud03
      LET l_oga.ogaud04 = l_oha.ohaud04
      LET l_oga.ogaud05 = l_oha.ohaud05
      LET l_oga.ogaud06 = l_oha.ohaud06
      LET l_oga.ogaud07 = l_oha.ohaud07
      LET l_oga.ogaud08 = l_oha.ohaud08
      LET l_oga.ogaud09 = l_oha.ohaud09
      LET l_oga.ogaud10 = l_oha.ohaud10
      LET l_oga.ogaud11 = l_oha.ohaud11
      LET l_oga.ogaud12 = l_oha.ohaud12
      LET l_oga.ogaud13 = l_oha.ohaud13
      LET l_oga.ogaud14 = l_oha.ohaud14
      LET l_oga.ogaud15 = l_oha.ohaud15
 
      #LET l_sql2="INSERT INTO ",l_dbs_tra CLIPPED,"oga_file",   #FUN-980092
      LET l_sql2="INSERT INTO ",cl_get_target_table(l_plant_new,'oga_file'), #FUN-A50102  
                 "( oga00,oga01,oga02,oga03,   ",
                 "  oga032,oga033,oga04,oga05, ",
                 "  oga07,oga08,oga09,oga14,   ",
                 "  oga15,oga161,oga162,oga163,",
                 "  oga18,oga20,oga21,oga211,  ",
                 "  oga212,oga213,oga23,oga24, ",
                 "  oga25,oga26,oga30,oga31,   ",
                 "  oga32,oga50,oga501,oga51,  ",
                 "  oga511,oga53,oga54,ogaconf,",
                 "  ogapost,ogaprsw,ogauser,ogagrup, ",
                 "  ogadate,oga1001,oga1002,oga1003, ",
                 "  oga1004,oga1005,oga1006,oga1007, ",
                 "  oga1008,oga1009,oga1010,oga1011,ogaoriu,ogaorig, ",  #TQC-A10060 add ogaoriu,ogaorig
                 "  oga1012,oga1013,oga1014,oga1015,oga52,ogaplant,ogalegal, ", #FUN-980006 add ogaplant,ogalegal
                 "  ogaud01,ogaud02,ogaud03,ogaud04,ogaud05,",
                 "  ogaud06,ogaud07,ogaud08,ogaud09,ogaud10,",
                 "  ogaud11,ogaud12,ogaud13,ogaud14,ogaud15,oga57) ", #TQC-AC0055 add oga57
                 " VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                          "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                          "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,",    #No.CHI-950020
                          "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,?,?,",  #TQC-A10060 add ?,?
                          "?,?,?,?, ?,?,?,?, ?, ?,?,?)" #FUN-980006 add ?,?
 	       CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
           CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
           PREPARE ins_oga FROM l_sql2
           EXECUTE ins_oga USING 
                 l_oga.oga00,l_oga.oga01,l_oga.oga02,l_oga.oga03,  
                 l_oga.oga032,l_oga.oga033,l_oga.oga04,l_oga.oga05,
                 l_oga.oga07,l_oga.oga08,l_oga.oga09,l_oga.oga14,
                 l_oga.oga15,l_oga.oga161,l_oga.oga162,l_oga.oga163,
                 l_oga.oga18,l_oga.oga20,l_oga.oga21,l_oga.oga211,
                 l_oga.oga212,l_oga.oga213,l_oga.oga23,l_oga.oga24,
                 l_oga.oga25,l_oga.oga26,l_oga.oga30,l_oga.oga31,
                 l_oga.oga32,l_oga.oga50,l_oga.oga501,l_oga.oga51,
                 l_oga.oga511,l_oga.oga53,l_oga.oga54,l_oga.ogaconf,
		 l_oga.ogapost,l_oga.ogaprsw,l_oga.ogauser,l_oga.ogagrup,
		 l_oga.ogadate,l_oga.oga1001,l_oga.oga1002,l_oga.oga1003,
		 l_oga.oga1004,l_oga.oga1005,l_oga.oga1006,l_oga.oga1007,
		 l_oga.oga1008,l_oga.oga1009,l_oga.oga1010,l_oga.oga1011,
                 l_oga.ogaoriu,l_oga.ogaorig,     #TQC-A10060  add
		 l_oga.oga1012,l_oga.oga1013,l_oga.oga1014,l_oga.oga1015,
                 l_oga.oga52,l_plant,l_legal #FUN-980006 add l_plant,l_legal
                ,l_oga.ogaud01,l_oga.ogaud02,l_oga.ogaud03,l_oga.ogaud04,l_oga.ogaud05,
                 l_oga.ogaud06,l_oga.ogaud07,l_oga.ogaud08,l_oga.ogaud09,l_oga.ogaud10,
                 l_oga.ogaud11,l_oga.ogaud12,l_oga.ogaud13,l_oga.ogaud14,l_oga.ogaud15,l_oga.oga57 #TQC-AC0055 add l_oga.oga57
 
      IF SQLCA.sqlcode<>0 THEN
         IF g_bgerr THEN
            CALL s_errmsg("","","ins oga:",SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("","","","",SQLCA.sqlcode,"","ins oga:",1)
         END IF
         LET g_success = 'N'
         RETURN
      END IF
END FUNCTION
 
FUNCTION p840_ogbins()   #代送出貨單單身
   DEFINE l_sql1     LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(10000)
   DEFINE l_ogb03    LIKE ogb_file.ogb03
   DEFINE l_occ1027  LIKE occ_file.occ1027
   DEFINE l_occ01a   LIKE occ_file.occ01  
   DEFINE l_occ1004a LIKE occ_file.occ1004
   DEFINE l_unit     LIKE ohb_file.ohb916
   DEFINE l_ogb1002  LIKE ogb_file.ogb1002
   DEFINE l_ogb13    LIKE ogb_file.ogb13
   DEFINE l_ogb13t   LIKE ogb_file.ogb13
   DEFINE l_ogb14    LIKE ogb_file.ogb14
   DEFINE l_ogb14t   LIKE ogb_file.ogb14t
   DEFINE p_success  LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)
   DEFINE l_ogbi     RECORD LIKE ogbi_file.* #No.FUN-7B0018
   DEFINE l_sql2     STRING   #MOD-A90100
   DEFINE l_plant    LIKE azp_file.azp01     #FUN-980006 add
   DEFINE l_legal    LIKE azw_file.azw02     #FUN-980006 add
   DEFINE l_idd      RECORD LIKE idd_file.*  #FUN-B90012
   #DEFINE l_imaicd08 LIKE imaicd_file.imaicd08 #FUN-B90012 #FUN-BA0051 mark
   DEFINE l_flag     LIKE type_file.chr1     #FUN-B90012
   DEFINE l_ogbiicd028  LIKE ogbi_file.ogbiicd028 #FUN-B90012
   DEFINE l_ogbiicd029  LIKE ogbi_file.ogbiicd029 #FUN-B90012
#  DEFINE l_oia07    LIKE oia_file.oia07    #FUN-C50136 add
   DEFINE l_oga14    LIKE oga_file.oga14  #FUN-CB0087
   DEFINE l_oga15    LIKE oga_file.oga15  #FUN-CB0087


 
    INITIALIZE l_ogb.* TO NULL
 
    LET l_plant = g_poy.poy04  #FUN-980006 add 
    CALL s_getlegal(l_plant) RETURNING l_legal  #FUN-980006 add 
 
    LET l_sql1 = "SELECT MAX(ogb03)+1 ",
                 #" FROM ",l_dbs_tra CLIPPED,"ogb_file ",  #FUN-980092
                 " FROM ",cl_get_target_table(l_plant_new,'ogb_file'), #FUN-A50102
                 " WHERE ogb01='",g_oga01,"' "
 	CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
    CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-980092
    PREPARE ogb_p2 FROM l_sql1
    IF STATUS THEN
       IF g_bgerr THEN
          CALL s_errmsg("","","ogb_p2",STATUS,1)
       ELSE
          CALL cl_err3("","","","",STATUS,"","ogb_p2",1)
       END IF
    END IF
    DECLARE ogb_c2 CURSOR FOR ogb_p2
    OPEN ogb_c2
    FETCH ogb_c2 INTO l_ogb03
    CLOSE ogb_c2
    IF cl_null(l_ogb03) OR l_ogb03 = 0 THEN
       LET l_ogb03 = 1
    END IF  
    LET l_sql1 = "SELECT occ01,occ1004,occ1027 ",
                 #" FROM ",l_dbs_new CLIPPED,"occ_file ",
                 " FROM ",cl_get_target_table(l_plant_new,'occ_file'), #FUN-A50102
                 " WHERE occ01='",l_oha.oha1014,"' " 
 	CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
    CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-A50102
    PREPARE occ_p3 FROM l_sql1
    IF STATUS THEN
       IF g_bgerr THEN
          CALL s_errmsg("","","occ_p3",STATUS,1)
       ELSE
          CALL cl_err3("","","","",STATUS,"","occ_p3",1)
       END IF
    END IF
    DECLARE occ_c3 CURSOR FOR occ_p3
    OPEN occ_c3
    FETCH occ_c3 INTO l_occ01a,l_occ1004a,l_occ1027
    IF cl_null(l_occ01a) THEN 
       IF g_bgerr THEN
          CALL s_errmsg("","",l_occ01a,"mfg4106",1)
       ELSE
          CALL cl_err3("","","","","mfg4106","",l_occ01a,1)
       END IF
       LET g_success='N'   
       RETURN
    END IF
    IF l_occ1004a <> '1' THEN 
       IF g_bgerr THEN
          CALL s_errmsg("","",l_occ1004a,"atm-008",1)
       ELSE
          CALL cl_err3("","","","","atm-008","",l_occ1004a,1)
       END IF
       LET g_success='N'   
       RETURN
    END IF
    IF cl_null(l_occ1027) THEN LET l_occ1027='N' END IF
    IF l_occ1027 ='Y' THEN
       IF g_bgerr THEN
          CALL s_errmsg("","",l_oha.oha1014,"atm-255",1)
       ELSE
          CALL cl_err3("","","","","atm-255","",l_oha.oha1014,1)
       END IF
       LET g_success='N'   
       RETURN
    END IF
    CLOSE occ_c3
 
    #根據客戶+產品編號+單位+日期+定價類型取定價編號及單價  
    IF g_sma.sma116 = 'Y' THEN    #使用計價單位 
       LET l_unit = l_ohb.ohb916
    ELSE
       LET l_unit = l_ohb.ohb05
    END IF 
 
    CALL s_fetch_price2(l_oha.oha1014,l_ohb.ohb04,l_unit,l_oha.oha02,'1',l_plant_new,l_oha.oha23)  #No.FUN-980059
         RETURNING l_ogb1002,l_ogb13,p_success        
    IF p_success ='N' THEN                                             
       IF g_bgerr THEN
          CALL s_errmsg("","","fetch price","atm-256",1)
       ELSE
          CALL cl_err3("","","","","atm-256","","fetch price",1)
       END IF
       LET  g_success='N'
       RETURN                                              
    END IF 
         
    #根據單頭單價是否含稅 進行未稅、含稅金額的計算
    IF l_oha.oha213='N' THEN
       LET l_ogb14  = l_ogb13*l_ohb.ohb917   #CHI-710059 mod
       LET l_ogb13t = l_ogb13*(1+l_oha.oha211/100)
       LET l_ogb14t = l_ogb13t*l_ohb.ohb917  #CHI-710059 mod
    ELSE
       LET l_ogb13t = l_ogb13/(1+l_oha.oha211/100)
       LET l_ogb14  = l_ogb13t*l_ohb.ohb917  #CHI-710059 mod           
       LET l_ogb14t = l_ogb13 *l_ohb.ohb917  #CHI-710059 mod          
    END IF
 
    LET l_ogb.ogb01 = l_oga.oga01             #出貨單號
    LET l_ogb.ogb03 = l_ogb03                 #項次
    LET l_ogb.ogb04 = l_ohb.ohb04             #產品編號
    LET l_ogb.ogb05 = l_ohb.ohb05             #銷售單位
    LET l_ogb.ogb05_fac = l_ohb.ohb05_fac     #銷售/庫存單位換算率
    LET l_ogb.ogb910    = l_ohb.ohb910        #第一單位
    LET l_ogb.ogb911    = l_ohb.ohb911        #第一單位轉換率
    LET l_ogb.ogb912    = l_ohb.ohb912        #第一單位數量
    LET l_ogb.ogb913    = l_ohb.ohb913        #第二單位
    LET l_ogb.ogb914    = l_ohb.ohb914        #第二單位轉換率
    LET l_ogb.ogb915    = l_ohb.ohb915        #第二單位數量
    LET l_ogb.ogb916    = l_ohb.ohb916        #計價單位
    LET l_ogb.ogb917    = l_ohb.ohb917        #計價數量
    LET l_ogb.ogb06     = l_ohb.ohb06         #品名規格
    LET l_ogb.ogb07     = l_ohb.ohb07         #額外品名規格
    LET l_ogb.ogb08     = l_ohb.ohb08         #出貨工廠
    LET l_ogb.ogb09     = l_ohb.ohb09         #出貨倉庫
    LET l_ogb.ogb091    = l_ohb.ohb091        #出貨庫位
    LET l_ogb.ogb092    = l_ohb.ohb092        #出貨批號
    LET l_ogb.ogb11     = l_ohb.ohb11         #客戶產品編號
    LET l_ogb.ogb12     = l_ohb.ohb12         #出貨數量
    LET l_ogb.ogb12     = s_digqty(l_ogb.ogb12,l_ogb.ogb05) #FUN-BB0083 add
    LET l_ogb.ogb13     = l_ogb13             #原幣單價
    LET l_ogb.ogb14     = l_ogb14             #原幣稅前金額
    LET l_ogb.ogb14t    = l_ogb14t            #原幣含稅金額
    LET l_ogb.ogbud01   = l_ohb.ohbud01
    LET l_ogb.ogbud02   = l_ohb.ohbud02
    LET l_ogb.ogbud03   = l_ohb.ohbud03
    LET l_ogb.ogbud04   = l_ohb.ohbud04
    LET l_ogb.ogbud05   = l_ohb.ohbud05
    LET l_ogb.ogbud06   = l_ohb.ohbud06
    LET l_ogb.ogbud07   = l_ohb.ohbud07
    LET l_ogb.ogbud08   = l_ohb.ohbud08
    LET l_ogb.ogbud09   = l_ohb.ohbud09
    LET l_ogb.ogbud10   = l_ohb.ohbud10
    LET l_ogb.ogbud11   = l_ohb.ohbud11
    LET l_ogb.ogbud12   = l_ohb.ohbud12
    LET l_ogb.ogbud13   = l_ohb.ohbud13
    LET l_ogb.ogbud14   = l_ohb.ohbud14
    LET l_ogb.ogbud15   = l_ohb.ohbud15
    IF l_azf10 = 'Y' THEN     #No.FUN-6B0065
    LET l_ogb.ogb14     = 0                   #原幣稅前金額
    LET l_ogb.ogb14t    = 0                   #原幣含稅金額
    END IF
    LET l_ogb.ogb15     = l_ohb.ohb15         #庫存明細單位
    LET l_ogb.ogb15_fac = l_ohb.ohb15_fac     #銷售/庫存明細單位換算率
    LET l_ogb.ogb16     = l_ohb.ohb16         #數量
    LET l_ogb.ogb16     = s_digqty(l_ogb.ogb16,l_ogb.ogb15) #FUN-BB0083 add
    LET l_ogb.ogb17     = 'N'                 #多倉位出貨否
    LET l_ogb.ogb18     = l_ohb.ohb12         #預計出貨數量
    LET l_ogb.ogb60     = 0                   #已開發票數量  
    LET l_ogb.ogb63     = 0                   #銷退數量
    LET l_ogb.ogb64     = 0                   #銷退數量 (不需換貨出貨)
    LET l_ogb.ogb930    = l_ohb.ohb930        #MOD-920265 add
    LET l_ogb.ogb1001   = l_oay19             #原因碼
    IF cl_null(l_ogb.ogb1001) THEN LET l_ogb.ogb1001 = g_poy.poy28 END IF  #TQC-D40064 add
    LET l_ogb.ogb1002   = l_ogb1002           #定價編號
    LET l_ogb.ogb1003   = l_oha.oha02         #預計出貨日期
    LET l_ogb.ogb1004   = ''                  #提案編號
    LET l_ogb.ogb1005   = '1'                 #作業方式
    LET l_ogb.ogb1006   = l_ohb.ohb1003       #折扣率
    LET l_ogb.ogb1007   = ''                  #現金折扣單號
    LET l_ogb.ogb1008   = ''                  #稅別
    LET l_ogb.ogb1009   = ''                  #稅率
    LET l_ogb.ogb1010   = ''                  #含稅否
    LET l_ogb.ogb1011   = ''                  #非直營KAB
    LET l_ogb.ogb1012   = l_azf10             #搭增否     #No.FUN-6B0065
    LET l_ogb.ogb1014   = 'N'                 #保稅放行否  #FUN-6B0044
    IF cl_null(l_ogb.ogb37) OR l_ogb.ogb37=0 THEN    #FUN-AB0061           
       LET l_ogb.ogb37=l_ogb.ogb13                   #FUN-AB0061           
    END IF                               #FUN-AB0061  
    #FUN-AC0055 mark ---------------------begin-----------------------
    ##FUN-AB0096 -------add start---------
    #IF cl_null(l_ogb.ogb50) THEN
    #   LET l_ogb.ogb50 = '1'
    #END IF 
    ##FUN-AB0096 -------add end------------
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

     #TQC-D20047--add--str--
     LET l_sql1 = "SELECT aza115 FROM ",cl_get_target_table(l_plant_new,'aza_file')," WHERE aza01 = '0' "
     PREPARE aza115_pr FROM l_sql1
     EXECUTE aza115_pr INTO g_aza.aza115   
     #TQC-D20047--add--end--
     #FUN-CB0087--add--str--
     #IF g_aza.aza115='Y' THEN                            #TQC-D40064 mark
     IF g_aza.aza115='Y' AND cl_null(l_ogb.ogb1001) THEN  #TQC-D40064 add
        #TQC-D20050--mod--str--
        #SELECT oga14,oga15 INTO l_oga14,l_oga15 FROM oga_file WHERE oga01 = l_ogb.ogb01
        #CALL s_reason_code(l_ogb.ogb01,l_ogb.ogb31,'',l_ogb.ogb04,l_ogb.ogb09,l_oga14,l_oga15) RETURNING l_ogb.ogb1001
        LET l_sql1="SELECT oga14,oga15 FROM ",cl_get_target_table(l_plant_new,'oga_file')," WHERE oga01 ='",l_ogb.ogb01,"'"
        PREPARE ogb1001_pr FROM l_sql1
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
    #FUN-AC0055 mark ----------------------end------------------------
      #LET l_sql1="INSERT INTO ",l_dbs_tra CLIPPED,"ogb_file",   #FUN-980092
      LET l_sql1="INSERT INTO ",cl_get_target_table(l_plant_new,'ogb_file'), #FUN-A50102
                 "( ogb01,ogb03,ogb04,ogb05,         ",
                 "  ogb05_fac,ogb910,ogb911,ogb912,  ",
                 "  ogb913,ogb914,ogb915,ogb916,     ",
                 "  ogb917,ogb06,ogb07,ogb08,        ",
                 "  ogb09,ogb091,ogb092,ogb11,       ",
                 "  ogb12,ogb37,ogb13,ogb14,ogb14t,        ",#FUN-AB0061
                 "  ogb15,ogb15_fac,ogb16,           ",
                 "  ogb17,ogb18,ogb60,ogb63,         ",
                 "  ogb64,ogb1001,ogb1002,ogb1003,   ",
                 "  ogb1004,ogb1005,ogb1006,ogb1007,ogb1008, ",
                 "  ogb1009,ogb1010,ogb1011,ogb1012,ogb1014,ogb930,ogbplant,ogblegal, ",
                 "  ogbud01,ogbud02,ogbud03,ogbud04,ogbud05,",
                 "  ogbud06,ogbud07,ogbud08,ogbud09,ogbud10,",
                 "  ogbud11,ogbud12,ogbud13,ogbud14,ogbud15,ogb50,ogb51,ogb52,ogb53,ogb54,ogb55)",              #FUN-AB0096 add ogb50
                 " VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                          "?,?,?,?, ?,?,?,?, ?,?,?, ?,?,?,?,?,",#FUN-AB0061
                          "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,",  #No.CHI-950020
                          "?,?,?,?, ?,?,?,?,?, ?,?,?,?,? ,?, ?,?,?, ?,?,?, ?,?,?) "  #MOD-920265 add ?  #FUN-980006 add ?,? #FUN-AB0096 add? #FUN-C50097 ADD ???
 	       CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
           CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-A50102
           PREPARE ins_ogb FROM l_sql1
           EXECUTE ins_ogb USING 
                 l_ogb.ogb01,l_ogb.ogb03,l_ogb.ogb04,l_ogb.ogb05,  
                 l_ogb.ogb05_fac,l_ogb.ogb910,l_ogb.ogb911,l_ogb.ogb912,
                 l_ogb.ogb913,l_ogb.ogb914,l_ogb.ogb915,l_ogb.ogb916,
                 l_ogb.ogb917,l_ogb.ogb06,l_ogb.ogb07,l_ogb.ogb08,  
                 l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,l_ogb.ogb11,
                 l_ogb.ogb12,l_ogb.ogb37,l_ogb.ogb13,l_ogb.ogb14,l_ogb.ogb14t, #FUN-AB0061
                 l_ogb.ogb15,l_ogb.ogb15_fac,l_ogb.ogb16,         
                 l_ogb.ogb17,l_ogb.ogb18,l_ogb.ogb60,l_ogb.ogb63,  
                 l_ogb.ogb64,l_ogb.ogb1001,l_ogb.ogb1002,l_ogb.ogb1003,  
		 l_ogb.ogb1004,l_ogb.ogb1005,l_ogb.ogb1006,l_ogb.ogb1007,l_ogb.ogb1008,
		 l_ogb.ogb1009,l_ogb.ogb1010,l_ogb.ogb1011,l_ogb.ogb1012,l_ogb.ogb1014,l_ogb.ogb930,l_plant,l_legal #FUN-6B0044  #MOD-920265 add ogb930 #FUN-980006 add l_plant,l_legal
                ,l_ogb.ogbud01,l_ogb.ogbud02,l_ogb.ogbud03,l_ogb.ogbud04,l_ogb.ogbud05,
                 l_ogb.ogbud06,l_ogb.ogbud07,l_ogb.ogbud08,l_ogb.ogbud09,l_ogb.ogbud10,
                 l_ogb.ogbud11,l_ogb.ogbud12,l_ogb.ogbud13,l_ogb.ogbud14,l_ogb.ogbud15,
                 l_ogb.ogb50,l_ogb.ogb51,l_ogb.ogb52,l_ogb.ogb53,l_ogb.ogb54,l_ogb.ogb55   #FUN-AB0096 add ogb50 #FUN-C50097 ADD ogb50,51,52
 
           IF SQLCA.sqlcode<>0 THEN
              IF g_bgerr THEN
                 CALL s_errmsg("","","ins ogb:",SQLCA.sqlcode,1)
              ELSE
                 CALL cl_err3("","","","",SQLCA.sqlcode,"","ins ogb:",1)
              END IF
              LET g_success = 'N'
              RETURN
           ELSE
              IF NOT s_industry('std') THEN
                 INITIALIZE l_ogbi.* TO NULL
                 LET l_ogbi.ogbi01 = l_ogb.ogb01
                 LET l_ogbi.ogbi03 = l_ogb.ogb03
                 IF NOT s_ins_ogbi(l_ogbi.*,l_plant_new) THEN  #FUN-980092
                    LET g_success = 'N'
                    RETURN
                 END IF
              END IF
#             #FUN-C50136----add----str----
#             IF g_oaz.oaz96 ='Y' THEN
#                CALL s_ccc_oia07('D',l_oga.oga03) RETURNING l_oia07
#                IF l_oia07 = '0' THEN
#                   CALL s_ccc_oia(l_oga.oga03,'D',l_oga.oga01,0,l_plant_new)
#                END IF
#             END IF
#             #FUN-C50136----add----end----
           END IF

           #-----MOD-A90100---------
           LET l_sql2 = "SELECT ima918,ima921 FROM ",cl_get_target_table(l_plant_new,'ima_file'), 
                        " WHERE ima01 = '",l_ogb.ogb04,"'",
                        "   AND imaacti = 'Y'"
           CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
           CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 
           PREPARE ima_ogb FROM l_sql2
           EXECUTE ima_ogb INTO g_ima918,g_ima921
           
           IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
              FOREACH p840_g_rvbs INTO l_rvbs.*
                 IF STATUS THEN
                    CALL cl_err('rvbs',STATUS,1)
                 END IF
              
                 LET l_rvbs.rvbs00 = "axmt620"
                 LET l_rvbs.rvbs01 = l_ogb.ogb01
                 LET l_rvbs.rvbs06 = l_rvbs.rvbs06 
                 IF cl_null(l_rvbs.rvbs06) THEN
                    LET l_rvbs.rvbs06 = 0
                 END IF
                 LET l_rvbs.rvbs09 = -1
                 LET l_rvbs.rvbs13 = 0    
           
                 #新增批/序號資料檔
                 EXECUTE ins_rvbs USING l_rvbs.rvbs00,l_rvbs.rvbs01,l_rvbs.rvbs02,
                                        l_rvbs.rvbs021,l_rvbs.rvbs022,l_rvbs.rvbs03,
                                        l_rvbs.rvbs04,l_rvbs.rvbs05,l_rvbs.rvbs06,
                                        l_rvbs.rvbs07,l_rvbs.rvbs08,l_rvbs.rvbs09,
                                        l_rvbs.rvbs13,l_plant,l_legal  
           
                 IF STATUS OR SQLCA.SQLCODE THEN
                    IF g_bgerr THEN
                       LET g_showmsg = l_rvbs.rvbs01,"/",l_rvbs.rvbs03
                       CALL s_errmsg('rvbs01,rvbs03',g_showmsg,'ins rvbs:',SQLCA.sqlcode,1) 
                    ELSE
                       CALL cl_err3("","","","","apm-019","","ins rvbs:",1)
                    END IF
                    LET g_success='N'
                 END IF
              
                 CALL p840_imgs(l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,l_oga.oga02,l_rvbs.*)
           
              END FOREACH
           END IF
           #-----END MOD-A90100-----

           #FUN-B90012----add----str----
           IF s_industry('icd') THEN
              #FUN-BA0051 --START mark--
              #LET l_sql2 = "SELECT imaicd08 FROM ",cl_get_target_table(l_plant_new,'imaicd_file'),",",
              #                                     cl_get_target_table(l_plant_new,'ima_file'),
              #             " WHERE imaicd00 = '",l_ogb.ogb04,"'",
              #             "   AND imaicd00 = ima01 ",
              #             "   AND imaacti  = 'Y'   "
              #CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
              #CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2
              #PREPARE imaicd08_ogb FROM l_sql2
              #EXECUTE imaicd08_ogb INTO l_imaicd08
              #
              #IF l_imaicd08 = 'Y' THEN
              #FUN-BA0051 --END mark--
              IF s_icdbin_multi(l_ogb.ogb04,l_plant_new) THEN   #FUN-BA0051
                 FOREACH p840_g_idd INTO l_idd.*
                    IF STATUS THEN
                       CALL cl_err('idd',STATUS,1)
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
                           " WHERE ogbi01 = '",l_ogb.ogb01,"'",
                           "   AND ogbi03 = '",l_ogb.ogb03,"'"
              CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
              CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2
              PREPARE l_ogbi_p FROM l_sql2
              EXECUTE l_ogbi_p INTO l_ogbiicd028,l_ogbiicd029
              CALL s_icdpost(12,l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,l_ogb.ogb05,l_ogb.ogb12,
                             l_ogb.ogb01,l_ogb.ogb03,l_oga.oga02,'Y','','',l_ogbiicd029,l_ogbiicd028,l_plant_new) 
                   RETURNING l_flag
              IF l_flag = 0 THEN
                 LET g_success = 'N'
              END IF
           END IF
           #FUN-B90012----add----end---- 

    LET l_oga.oga50 = l_oga.oga50+l_ohb.ohb14
    LET l_oga.oga51 = l_oga.oga51+l_ohb.ohb14t
    LET l_oga.oga53 = l_oga.oga53+l_ohb.ohb14
    LET l_oga.oga501= l_oga.oga501+l_ohb.ohb14*l_oha.oha24
    LET l_oga.oga511= l_oga.oga511+l_ohb.ohb14t*l_oha.oha24
    LET l_oga.oga1008 =l_oga.oga1008 + l_ogb.ogb14t   #原幣出貨金額(含稅)
      #LET l_sql1="UPDATE ",l_dbs_tra CLIPPED,"oga_file",  #FUN-980092 
      LET l_sql1="UPDATE ",cl_get_target_table(l_plant_new,'oga_file'), #FUN-A50102
                 " SET oga50 = ?, oga51 = ?,oga53 = ?, ",                          
                 "     oga501 = ?, oga511 = ?,oga1008 = ? ",                          
                 " WHERE oga01 = ? "                   
 	  CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
      CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-980092
      PREPARE upd_oga1 FROM l_sql1                                    
      EXECUTE upd_oga1 USING l_oga.oga50,l_oga.oga51,l_oga.oga53,                                             
                             l_oga.oga501,l_oga.oga511,l_oga.oga1008,
                             l_oga.oga01
      IF SQLCA.sqlcode<>0 THEN                                       
      IF g_bgerr THEN
         CALL s_errmsg("","","upd oga:",SQLCA.sqlcode,1)
      ELSE
         CALL cl_err3("","","","",SQLCA.sqlcode,"","upd oga:",1)
      END IF
         LET g_success = 'N' 
         RETURN
      END IF                             
 
END FUNCTION
 
FUNCTION p840_azp(l_i)
  DEFINE l_i     LIKE type_file.num5,   #No.FUN-680136 SMALLINT
         l_next  LIKE type_file.num5,   #No.FUN-680136 SMALLINT
         l_sql1  LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(800)
 
     ##-------------取得當站資料庫(S/O)-----------------
     SELECT * INTO g_poy.* FROM poy_file
      WHERE poy01 = g_poz.poz01 AND poy02 = l_i      
     SELECT * INTO l_azp.* FROM azp_file WHERE azp01 = g_poy.poy04
 
     LET l_plant_new = l_azp.azp01   #FUN-980020
 
     LET g_plant_new = l_azp.azp01
     CALL s_gettrandbs()
     LET l_dbs_tra = g_dbs_tra
 
     IF l_i = 0 THEN   #首站
         LET p_first_plant = g_poy.poy04
         IF p_first_plant != g_plant THEN
        IF g_bgerr THEN
           CALL s_errmsg("","","","apm-012",1)
        ELSE
           CALL cl_err3("","","","","apm-012","","",1)
        END IF
        CLOSE WINDOW p840_w 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
         END IF
     END IF
     LET l_dbs_new = s_dbstring(l_azp.azp03)  #TQC-950010 ADD            
         LET l_sql1 = "SELECT * ",                         #取得來源本幣
                  #" FROM ",l_dbs_new CLIPPED,"aza_file ",
                  " FROM ",cl_get_target_table(l_plant_new,'aza_file'), #FUN-A50102
                  " WHERE aza01 = '0' "
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-A50102
     PREPARE aza_p1 FROM l_sql1
     IF SQLCA.sqlcode THEN
        IF g_bgerr THEN
           CALL s_errmsg("","","aza_p1",SQLCA.sqlcode,1)
        ELSE
           CALL cl_err3("","","","",SQLCA.sqlcode,"","aza_p1",1)
        END IF
     END IF
     DECLARE aza_c1  CURSOR FOR aza_p1
     OPEN aza_c1
     FETCH aza_c1 INTO l_aza.*
     CLOSE aza_c1
     LET p_poy04  = g_poy.poy04
     LET p_imd01  = g_poy.poy11
     LET p_pmm09  = g_poy.poy03
     IF cl_null(p_pmm09) THEN
         IF l_i = p_last AND NOT cl_null(g_pmm.pmm50) THEN
            LET p_pmm09 = g_pmm.pmm50
         ELSE
            LET p_pmm09 = ''            #廠商代號
         END IF
     END IF
END FUNCTION
 
#讀取幣別檔之資料
FUNCTION p840_azi(l_oga23)
   DEFINE l_sql1   LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(800)
   DEFINE l_oga23  LIKE oga_file.oga23
   DEFINE l_dbs    LIKE type_file.chr21   #FUN-670007
 
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
         CALL s_errmsg("","","azi_p1",STATUS,1)
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
         CALL s_errmsg("","","azi_p2",STATUS,1)
      ELSE
         CALL cl_err3("","","","",STATUS,"","azi_p2",1)
      END IF
   END IF
   DECLARE azi_c2 CURSOR FOR azi_p2
   OPEN azi_c2
   FETCH azi_c2 INTO l_azi.* 
   CLOSE azi_c2
END FUNCTION
 
 
FUNCTION p840_ohains()
   DEFINE l_sql   LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(1200)
   DEFINE l_sql1  LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(600)
   DEFINE l_sql2  LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(1600)
   DEFINE l_sql6  LIKE type_file.chr1000    #No.FUN-620025  #No.FUN-680136 VARCHAR(1600)
   DEFINE i,l_i   LIKE type_file.num5    #No.FUN-680136 SMALLINT
   DEFINE li_result   LIKE type_file.num5     #FUN-560043  #No.FUN-680136 SMALLINT
   DEFINE l_oga01 LIKE oga_file.oga01    #MOD-7B0182
   DEFINE l_plant    LIKE azp_file.azp01    #FUN-980006 add
   DEFINE l_legal    LIKE azw_file.azw02    #FUN-980006 add
   
   LET l_plant = g_poy.poy04  #FUN-980006 add 
   CALL s_getlegal(l_plant) RETURNING l_legal  #FUN-980006 add 
 
   #讀取該流程代碼之銷單資料
   LET l_sql1 = "SELECT * ",
                #" FROM ",l_dbs_tra CLIPPED,"oea_file ",   #FUN-980092
                " FROM ",cl_get_target_table(l_plant_new,'oea_file'), #FUN-A50102
                " WHERE oea99='",g_pmm.pmm99,"' " 
   CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
   CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-980092
   PREPARE oea_p1 FROM l_sql1
      IF STATUS THEN
         IF g_bgerr THEN
            CALL s_errmsg("","","oea_p1",STATUS,1)
         ELSE
            CALL cl_err3("","","","",STATUS,"","oea_p1",1)
         END IF
      END IF
   DECLARE oea_c1 CURSOR FOR oea_p1
   OPEN oea_c1
   FETCH oea_c1 INTO l_oea.*
   IF SQLCA.SQLCODE <> 0 THEN
      IF g_bgerr THEN
         CALL s_errmsg("","","fetch cursor oea_c1",SQLCA.sqlcode,1)
      ELSE
         CALL cl_err3("","","","",SQLCA.sqlcode,"","fetch cursor oea_c1",1)
      END IF
      LET g_success='N'
      RETURN
   END IF
   CLOSE oea_c1
   IF l_aza.aza50 = 'Y' THEN #MOD-690156 add if 判斷
       LET l_sql1 = "SELECT azf10 ",
                    #" FROM ",l_dbs_new CLIPPED,"azf_file ",
                    " FROM ",cl_get_target_table(l_plant_new,'azf_file'), #FUN-A50102
                    " WHERE azf01 ='",g_poy.poy31,"' ", 
                    " AND   azf02='2'"      #No.TQC-760054 
 	  CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
      CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-A50102
      PREPARE azf_p2 FROM l_sql1
      IF STATUS THEN
         IF g_bgerr THEN
            CALL s_errmsg("","","azf_p2",STATUS,1)
         ELSE
            CALL cl_err3("","","","",STATUS,"","azf_p2",1)
         END IF
      END IF
      DECLARE azf_c2 CURSOR FOR azf_p2
      OPEN azf_c2
      FETCH azf_c2 INTO l_azf10a
      CLOSE azf_c2
   END IF #MOD-690156 add
   IF cl_null(l_azf10a) THEN LET l_azf10a='N' END IF
   #新增銷退單單頭檔(oha_file)
    CALL s_auto_assign_no('axm',oha_t1,g_rvu.rvu03,"","","",l_plant_new,"","")  #FUN-980092
      RETURNING li_result,l_oha.oha01
    IF (NOT li_result) THEN 
       LET g_msg = l_plant_new CLIPPED,l_oha.oha01
       CALL s_errmsg("oha01",l_oha.oha01,g_msg CLIPPED,"mfg3046",1) 
       LET g_success ='N'
       RETURN
    END IF   
    LET l_sql1 = "SELECT oga01 ",
                #" FROM ",l_dbs_tra CLIPPED,"oga_file ",  #FUN-980092
                " FROM ",cl_get_target_table(l_plant_new,'oga_file'), #FUN-A50102
                " WHERE oga99 ='",g_rva.rva99,"' " ,
                " AND   oga09 ='6' "
                
 	CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
    CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-980092
    PREPARE oga_p1 FROM l_sql1
    IF STATUS THEN CALL cl_err('oga_p1',STATUS,1) END IF
    DECLARE oga_c1 CURSOR FOR oga_p1
    OPEN oga_c1
    FETCH oga_c1 INTO l_oga01
    CLOSE oga_c1
   
    IF cl_null(l_oga01) THEN LET l_oga01=' ' END IF     
    LET l_oha.oha16 = l_oga01
 
    LET l_oha.oha02 = g_rvu.rvu03        #出貨日期
    LET l_oha.oha03 = l_oea.oea03
    LET l_oha.oha032= l_oea.oea032
    LET l_oha.oha04 = l_oea.oea04
    LET l_oha.oha05 = '3'                #單據別(代採銷退)
    LET l_oha.oha08 = l_oea.oea08
    LET l_oha.oha09 = '1'
    LET l_oha.oha10 = null
    LET l_oha.oha14 = l_oea.oea14
    LET l_oha.oha15 = l_oea.oea15
    LET l_oha.oha21 = l_oea.oea21
    LET l_oha.oha211= l_oea.oea211
    LET l_oha.oha212= l_oea.oea212
    LET l_oha.oha213= l_oea.oea213
    LET l_oha.oha23 = l_oea.oea23
    CALL p840_azi(l_oea.oea23)   #讀取幣別資料
       #出貨時重新抓取匯率
       CALL s_currm(l_oha.oha23,l_oha.oha02,g_pod.pod01,l_plant_new)    #FUN-980020
           RETURNING l_oha.oha24
    #若出貨單頭之幣別=本幣幣別, 則匯率給1, (COI美金立帳, 99.03.05)
    IF l_oha.oha23 = l_aza.aza17 THEN
       LET l_oha.oha24=1
    END IF
    IF cl_null(l_oha.oha24) THEN LET l_oha.oha24=l_oea.oea24 END IF
    LET l_oha.oha25 = l_oea.oea25
    LET l_oha.oha26 = l_oea.oea26
    LET l_oha.oha31 = l_oea.oea31
    LET l_oha.oha41 = 'Y'
    LET l_oha.oha42 = 'Y'
    LET l_oha.oha43 = 'N'        
    LET l_oha.oha44 = 'Y'
    LET l_oha.oha45 = ''
    LET l_oha.oha46 = ''
    LET l_oha.oha47 = ''
    LET l_oha.oha48 = ''
    LET l_oha.oha50 = 0         #原幣銷退總未稅金額
    LET l_oha.oha53 = 0         #原幣銷退應開折讓未稅金額
    LET l_oha.oha54 = 0         #原幣銷退已開折讓未稅金額
    LET l_oha.oha55 = '1' #MOD-B50099 add
    LET l_oha.oha99 = g_flow99  #No.8128
    LET l_oha.ohaconf='Y'
    LET l_oha.ohapost='Y'
    LET l_oha.ohaprsw=0
    LET l_oha.ohauser=g_user
    LET l_oha.ohagrup=g_grup
    LET l_oha.ohaoriu=g_user   #TQC-A10060  add
    LET l_oha.ohaorig=g_grup   #TQC-A10060  add
    LET l_oha.ohamodu=null
    LET l_oha.ohadate=null
    IF l_aza.aza50 = 'Y'THEN     #使用分銷功能
       ##銷退單新增欄位設置                                                 
       IF l_oea.oea00 = '6' THEN    
          LET l_oha.oha05 = '4'  #代送銷售  
       END IF
       LET l_oha.oha1001 = l_oea.oea17         #收款客戶編號
       LET l_oha.oha1002 = l_oea.oea1002       #債權代碼     
       LET l_oha.oha1003 = l_oea.oea1003       #業績歸屬方   
       LET l_oha.oha1004 = g_poy.poy31         #退貨原因碼 
       LET l_oha.oha1005 = l_oea.oea1005       #是否計算業績 
       LET l_oha.oha1006 = 0                   #折扣金額(未稅)
       LET l_oha.oha1007 = 0                   #折扣金額(含稅)
       LET l_oha.oha1008 = 0                   #銷退單總含稅金額
       LET l_oha.oha1009 = l_oea.oea1009       #客戶所屬渠道    
       LET l_oha.oha1010 = l_oea.oea1010       #客戶所屬方      
       LET l_oha.oha1011 = l_oea.oea1011       #開票客戶        
       LET l_oha.oha1012 = ''                  #原始退單號      
       LET l_oha.oha1013 = ''                  #收料驗收單號    
       LET l_oha.oha1014 = l_oea.oea1004       #代送商          
       LET l_oha.oha1015 = 'N'                 #是否對應代送出貨
       LET l_oha.oha1016 = l_oea.oea1001       #帳款客戶編號    
       LET l_oha.oha1017 = '0'                 #導物流狀況碼    
       LET l_oha.oha1018 = ''                  #代送出貨單號    
    END IF 
    IF cl_null(l_oha.oha1004) THEN LET l_oha.oha1004 = g_poy.poy31 END IF  #TQC-D40064 add
    LET l_oha.ohaud01 = g_rvu.rvuud01
    LET l_oha.ohaud02 = g_rvu.rvuud02
    LET l_oha.ohaud03 = g_rvu.rvuud03
    LET l_oha.ohaud04 = g_rvu.rvuud04
    LET l_oha.ohaud05 = g_rvu.rvuud05
    LET l_oha.ohaud06 = g_rvu.rvuud06
    LET l_oha.ohaud07 = g_rvu.rvuud07
    LET l_oha.ohaud08 = g_rvu.rvuud08
    LET l_oha.ohaud09 = g_rvu.rvuud09
    LET l_oha.ohaud10 = g_rvu.rvuud10
    LET l_oha.ohaud11 = g_rvu.rvuud11
    LET l_oha.ohaud12 = g_rvu.rvuud12
    LET l_oha.ohaud13 = g_rvu.rvuud13
    LET l_oha.ohaud14 = g_rvu.rvuud14
    LET l_oha.ohaud15 = g_rvu.rvuud15
    IF cl_null(l_oha.oha57) THEN LET l_oha.oha57 = '1' END IF #FUN-AC0055 add
    #新增銷退單頭檔(oha_file)
        #LET l_sql2="INSERT INTO ",l_dbs_tra CLIPPED,"oha_file",   #FUN-980092
        LET l_sql2="INSERT INTO ",cl_get_target_table(l_plant_new,'oha_file'), #FUN-A50102
               "( oha01,oha02,oha03,oha032, ",
               "  oha04,oha05,oha08,oha09,",
               "  oha10,oha14,oha15,oha16,",
               "  oha21,oha211,oha212,oha213,",
               "  oha23,oha24,oha25,oha26,",
               "  oha31,oha41,oha42,oha43,",
               "  oha44,oha45,oha46,oha47,",
               "  oha48,oha50,oha53,oha54,oha55,", #MOD-B50099 add oha55
               "  ohaconf,ohapost,ohaprsw,ohauser, ",
	       "  ohagrup,ohamodu,ohadate,oha99,ohaoriu,ohaorig,   ",  #TQC-A10060  add ohaoriu,ohaorig
	       "  oha1001,oha1002,oha1003,oha1004, ",
	       "  oha1005,oha1006,oha1007,oha1008, ",
	       "  oha1009,oha1010,oha1011,oha1012, ",
	       "  oha1013,oha1014,oha1015,oha1016, ",
	       "  oha1017,oha1018,ohaplant,ohalegal, ",
               "  ohaud01,ohaud02,ohaud03,ohaud04,ohaud05,",                    
               "  ohaud06,ohaud07,ohaud08,ohaud09,ohaud10,",                    
               "  ohaud11,ohaud12,ohaud13,ohaud14,ohaud15,oha57)",   #FUN-AC0055 add oha57                    
               " VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                        "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                        "?,?,?,?, ?,?,?,?,  ",
                        "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,?,",#No.CHI-950020  #TQC-A10060 add ?,?
                        "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,  ?,? ,?,?,?,?) "  #No.FUN-620025 #FUN-980006 add ?,? #MOD-B50099 add ?
 	       CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
           CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
           PREPARE ins_oha FROM l_sql2
           EXECUTE ins_oha USING 
                 l_oha.oha01,l_oha.oha02,l_oha.oha03,l_oha.oha032, 
                 l_oha.oha04,l_oha.oha05,l_oha.oha08,l_oha.oha09,
                 l_oha.oha10,l_oha.oha14,l_oha.oha15,l_oha.oha16,
                 l_oha.oha21,l_oha.oha211,l_oha.oha212,l_oha.oha213,
                 l_oha.oha23,l_oha.oha24,l_oha.oha25,l_oha.oha26,
                 l_oha.oha31,l_oha.oha41,l_oha.oha42,l_oha.oha43,
                 l_oha.oha44,l_oha.oha45,l_oha.oha46,l_oha.oha47,
                 l_oha.oha48,l_oha.oha50,l_oha.oha53,l_oha.oha54,l_oha.oha55, #MOD-B50099 add l_oha.oha55
                 l_oha.ohaconf,l_oha.ohapost,l_oha.ohaprsw,l_oha.ohauser,
		 l_oha.ohagrup,l_oha.ohamodu,l_oha.ohadate,l_oha.oha99,
                 l_oha.ohaoriu,l_oha.ohaorig,                     #TQC-A10060  add
		 l_oha.oha1001,l_oha.oha1002,l_oha.oha1003,
                 l_oha.oha1004,l_oha.oha1005,l_oha.oha1006,  
                 l_oha.oha1007,l_oha.oha1008,l_oha.oha1009,
                 l_oha.oha1010,l_oha.oha1011,l_oha.oha1012,  
                 l_oha.oha1013,l_oha.oha1014,l_oha.oha1015,  
                 l_oha.oha1016,l_oha.oha1017,l_oha.oha1018,l_plant,l_legal #FUN-980006 add l_plant,l_legal  
                ,l_oha.ohaud01,l_oha.ohaud02,l_oha.ohaud03,l_oha.ohaud04,l_oha.ohaud05,
                 l_oha.ohaud06,l_oha.ohaud07,l_oha.ohaud08,l_oha.ohaud09,l_oha.ohaud10,
                 l_oha.ohaud11,l_oha.ohaud12,l_oha.ohaud13,l_oha.ohaud14,l_oha.ohaud15,l_oha.oha57  #FUN-AC0055 add oha57
              IF SQLCA.sqlcode<>0 THEN
                 IF g_bgerr THEN
                    CALL s_errmsg("","","ins oha:",SQLCA.sqlcode,1)
                 ELSE
                    CALL cl_err3("","","","",SQLCA.sqlcode,"","ins oha:",1)
                 END IF
                 LET g_success = 'N'
              END IF
 
     IF l_aza.aza50 = 'Y' AND l_oha.oha05 = '4'  THEN   #使用分銷功能,且有代送則生成出貨單
        CALL p840_ogains()     
     END IF
 
END FUNCTION
 
#銷退單身檔
FUNCTION p840_ohbins(p_i)
  DEFINE l_sql  LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(1200)
  DEFINE l_sql1  LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(600)
  DEFINE l_sql2  LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(1600)
  DEFINE l_sql3  LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(400)
  DEFINE l_sql8  LIKE type_file.chr1000 #No.FUN-620025  #No.FUN-680136 VARCHAR(1200)
  DEFINE p_i     LIKE type_file.num5     #No.FUN-680136 SMALLINT
  DEFINE l_no    LIKE type_file.num5     #No.FUN-680136 SMALLINT
  DEFINE l_price LIKE ogb_file.ogb13
  DEFINE i,l_i    LIKE type_file.num5    #No.FUN-680136 SMALLINT
  DEFINE l_msg   LIKE type_file.chr1000  #No.FUN-680136 VARCHAR(80)
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
  DEFINE l_plant    LIKE azp_file.azp01    #FUN-980006 add
  DEFINE l_legal    LIKE azw_file.azw02    #FUN-980006 add
  DEFINE l_ohbi   RECORD LIKE ohbi_file.* #FUN-B70074 add
  DEFINE l_idd    RECORD LIKE idd_file.*  #FUN-B90012
  #DEFINE l_imaicd08 LIKE imaicd_file.imaicd08 #FUN-B90012 #FUN-BA0051 mark
  DEFINE l_flag   LIKE type_file.chr1     #FUN-B90012
  DEFINE l_ohbiicd028 LIKE ohbi_file.ohbiicd028 #FUN-B90012
  DEFINE l_ohbiicd029 LIKE ohbi_file.ohbiicd029 #FUN-B90012
# DEFINE l_oia07    LIKE oia_file.oia07    #FUN-C50136 add
  DEFINE l_ima29  LIKE ima_file.ima29     #CHI-C80042 add
  DEFINE l_oha14         LIKE oha_file.oha14   #FUN-CB0087
  DEFINE l_oha15         LIKE oha_file.oha15   #FUN-CB0087
   
    LET l_plant = g_poy.poy04  #FUN-980006 add 
    CALL s_getlegal(l_plant) RETURNING l_legal  #FUN-980006 add 
 
     #讀取訂單單身檔(oeb_file)
     LET l_sql1 = "SELECT * ",
                  #"  FROM ",l_dbs_tra CLIPPED,"oeb_file,", #FUN-980092 
                  #          l_dbs_tra CLIPPED,"oea_file ",
                  "  FROM ",cl_get_target_table(l_plant_new,'oeb_file'),",", #FUN-A50102
                            cl_get_target_table(l_plant_new,'oea_file'),     #FUN-A50102
                  " WHERE oeb01= oea01 ",             #FUN-830035 add
                  "   AND oea99='",g_pmm.pmm99,"' ",  #FUN-830035 add
                  "   AND oeb03=",g_rvv.rvv37
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-A50102
     PREPARE oeb_p1 FROM l_sql1
     IF STATUS THEN
        IF g_bgerr THEN
           CALL s_errmsg("","","oeb_p1",STATUS,1)
        ELSE
           CALL cl_err3("","","","",STATUS,"","oeb_p1",1)
        END IF
     END IF
     DECLARE oeb_c1 CURSOR FOR oeb_p1
     OPEN oeb_c1
     FETCH oeb_c1 INTO l_oeb.*
     IF SQLCA.SQLCODE <> 0 THEN
        LET g_success='N'
        RETURN
     END IF
     CLOSE oeb_c1
     #新增銷退單身檔[ohb_file]
     LET l_ohb.ohb01 = l_oha.oha01      #銷退單號
     LET l_ohb.ohb03 = g_rvv.rvv02      #項次
     LET l_ohb.ohb04 = g_rvv.rvv31      #產品編號
     LET l_ohb.ohb05 = l_oeb.oeb05      #銷售單位
     LET l_ohb.ohb05_fac= l_oeb.oeb05_fac  #換算率
     LET l_ohb.ohb06 = l_oeb.oeb06      #品名規格
     LET l_ohb.ohb07 = l_oeb.oeb07      #額外品名編號
     LET l_ohb.ohb08 = l_oeb.oeb08      #出貨工廠
     LET l_ohb.ohb09 = l_oeb.oeb09      #出貨倉庫
     LET l_ohb.ohb091= l_oeb.oeb091     #出貨儲位
     LET l_ohb.ohb092= l_oeb.oeb092     #出貨批號
     LET l_ohb.ohbud01 = g_rvv.rvvud01
     LET l_ohb.ohbud02 = g_rvv.rvvud02
     LET l_ohb.ohbud03 = g_rvv.rvvud03
     LET l_ohb.ohbud04 = g_rvv.rvvud04
     LET l_ohb.ohbud05 = g_rvv.rvvud05
     LET l_ohb.ohbud06 = g_rvv.rvvud06
     LET l_ohb.ohbud07 = g_rvv.rvvud07
     LET l_ohb.ohbud08 = g_rvv.rvvud08
     LET l_ohb.ohbud09 = g_rvv.rvvud09
     LET l_ohb.ohbud10 = g_rvv.rvvud10
     LET l_ohb.ohbud11 = g_rvv.rvvud11
     LET l_ohb.ohbud12 = g_rvv.rvvud12
     LET l_ohb.ohbud13 = g_rvv.rvvud13
     LET l_ohb.ohbud14 = g_rvv.rvvud14
     LET l_ohb.ohbud15 = g_rvv.rvvud15
     IF g_prog <> 'artt255' AND  g_prog <> 'artt256' THEN  #FUN-AA0023
        IF NOT cl_null(p_imd01) THEN
           #CALL p840_imd(p_imd01,l_dbs_new)
           CALL p840_imd(p_imd01,l_dbs_new,l_plant_new)  #FUN-A50102
           LET l_ohb.ohb09 = p_imd01
           LET l_ohb.ohb091= ' '
           LET l_ohb.ohb092= ' '
        ELSE
          CALL p840_ima(l_ohb.ohb04)
             RETURNING l_ima02,l_ima25,l_qoh,l_ima86,l_ima39,
                       l_ima35,l_ima36
          IF cl_null(l_ima35) THEN
             LET l_ohb.ohb09 = g_rvv.rvv32
             LET l_ohb.ohb091= g_rvv.rvv33
             LET l_ohb.ohb092= g_rvv.rvv34
          ELSE
             LET l_ohb.ohb09 = l_ima35
             LET l_ohb.ohb091= l_ima36
             LET l_ohb.ohb092= ' '
          END IF
        END IF
     END IF #FUN-AA0023
    #IF g_sma.sma96 = 'Y' THEN          #FUN-C80001 #FUN-D30099 mark
     IF g_pod.pod08 = 'Y' THEN          #FUN-D30099 
        LET l_ohb.ohb092= g_rvv.rvv34   #FUN-C80001
     END IF                             #FUN-C80001
     IF cl_null(l_ohb.ohb09) THEN LET l_ohb.ohb09 = ' ' END IF
     IF cl_null(l_ohb.ohb091) THEN LET l_ohb.ohb091 = ' ' END IF
     IF cl_null(l_ohb.ohb092) THEN LET l_ohb.ohb092 = ' ' END IF
 
     LET l_ohb.ohb11 = l_oeb.oeb11      #客戶產品編號
     LET l_ohb.ohb12 = g_rvv.rvv17      #實際出貨數量
     #讀取出貨單身檔(ogb_file)
     LET l_sql1 = "SELECT ogb13,ogb01,ogb03,ogb930 ",  #MOD-7B0182 modify  #MOD-920265 add ogb930
                  #"  FROM ",l_dbs_tra CLIPPED,"oga_file,",  #FUN-980092
                  #          l_dbs_tra CLIPPED,"ogb_file ",
                  "  FROM ",cl_get_target_table(l_plant_new,'oga_file'),",", #FUN-A50102
                            cl_get_target_table(l_plant_new,'ogb_file'),     #FUN-A50102
                  " WHERE oga99='",g_rva.rva99,"' " ,
                  "   AND oga01=ogb01 ",
                  "   AND oga09='6' ",     #MOD-7B0182 add #表示代採買
                  "   AND ogb31='",l_oeb.oeb01,"' " ,  #FUN-830035 
                  "   AND ogb32= ",g_rvv.rvv37
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-980092
     PREPARE ogb_p1 FROM l_sql1
     IF STATUS THEN
        LET g_success='N' #No.FUN-8A0086
        IF g_bgerr THEN
           CALL s_errmsg("","","ogb_p1",STATUS,1)
        ELSE
           CALL cl_err3("","","","",STATUS,"","ogb_p1",1)
        END IF
     END IF
     DECLARE ogb_c1 CURSOR FOR ogb_p1
     FOREACH ogb_c1 INTO l_oeb.oeb13,l_ohb.ohb31,l_ohb.ohb32,l_ohb.ohb930  #MOD-7B0182 modify   #MOD-920265 ogb930
         IF SQLCA.SQLCODE <> 0 THEN
            LET g_success='N'
            IF g_bgerr THEN
               CALL s_errmsg("","","ogb_cl",SQLCA.sqlcode,1)
            ELSE
               CALL cl_err3("","","","",SQLCA.sqlcode,"","ogb_cl",1)
            END IF
            RETURN
         END IF
         EXIT FOREACH #只取一筆就離開
     END FOREACH
     CLOSE ogb_c1
     LET l_ohb.ohb13 = l_oeb.oeb13      #原幣單價
     LET l_ohb.ohb37 = l_oeb.oeb37      #FUN-AB0061
 
     LET l_ohb.ohb917 = g_rvv.rvv87   #No.TQC-6A0084
 
     #未稅金額/含稅金額 : oeb14/oeb14t
     IF l_oha.oha213 = 'N' THEN
        LET l_ohb.ohb14=l_ohb.ohb917*l_ohb.ohb13  #No.TQC-6A0084
        LET l_ohb.ohb14t=l_ohb.ohb14*(1+l_oha.oha211/100)
     ELSE 
        LET l_ohb.ohb14t=l_ohb.ohb917*l_ohb.ohb13  #No.TQC-6A0084
        LET l_ohb.ohb14=l_ohb.ohb14t/(1+l_oha.oha211/100)
     END IF
     IF l_azf10a = 'Y' THEN          #No.FUN-6B0065
        LET l_ohb.ohb14=0
        LET l_ohb.ohb14t=0
     END IF
     LET l_ohb.ohb15 = l_oeb.oeb05
     LET l_ohb.ohb15_fac = 1
     LET l_ohb.ohb16 = l_ohb.ohb12
     LET l_ohb.ohb30 = ''              #原出貨發票號 oma10
     IF cl_null(l_ohb.ohb31) THEN LET l_ohb.ohb31='' END IF     #MOD-7B0182
     IF cl_null(l_ohb.ohb32) THEN LET l_ohb.ohb32='' END IF     #MOD-7B0182
     LET l_ohb.ohb33 = l_oeb.oeb01   #No.FUN-830035
     LET l_ohb.ohb34 = g_rvv.rvv37
     LET l_ohb.ohb50 = ''              #退貨理由碼
     LET l_ohb.ohb60 =0
     CALL cl_digcut(l_ohb.ohb14,l_azi.azi04) RETURNING l_ohb.ohb14
     CALL cl_digcut(l_ohb.ohb14t,l_azi.azi04)RETURNING l_ohb.ohb14t
     LET l_ohb.ohb910 = g_rvv.rvv80
     LET l_ohb.ohb911 = g_rvv.rvv81
     LET l_ohb.ohb912 = g_rvv.rvv82
     LET l_ohb.ohb913 = g_rvv.rvv83
     LET l_ohb.ohb914 = g_rvv.rvv84
     LET l_ohb.ohb915 = g_rvv.rvv85
     LET l_ohb.ohb916 = g_rvv.rvv86
     IF l_aza.aza50 = 'Y'THEN     #使用分銷功能
        #銷退單單身新增欄位設置
        LET l_ohb.ohb50   = g_poy.poy31         #退貨原因碼 
        LET l_ohb.ohb1001 = l_oeb.oeb1002       #定價編碼
        LET l_ohb.ohb1002 = ''                  #提案編號
        LET l_ohb.ohb1003 = l_oeb.oeb1006       #折扣率
        LET l_ohb.ohb1004 = l_azf10a            #搭增否     #No.FUN-6B0065
     END IF
     IF cl_null(l_ohb.ohb50) THEN LET l_ohb.ohb50 = g_poy.poy31 END IF  #TQC-D40064 add
     LET l_ohb.ohb1005 = l_oeb.oeb1003   #No.MOD-680058 
     #新增銷退單身檔
     #LET l_sql2="INSERT INTO ",l_dbs_tra CLIPPED,"ohb_file",  #FUN-980092
     #FUN-AB0061----------add---------------str----------------
     IF cl_null(l_ohb.ohb37) OR l_ohb.ohb37 = 0 THEN
        LET l_ohb.ohb37 = l_ohb.ohb13
     END IF
     #FUN-AB0061----------add---------------end----------------
     #FUN-AB0096 --------add start---------
     #IF cl_null(l_ohb.ohb71) THEN   #FUN-AC0055 mark
     #   LET l_ohb.ohb71 = '1' 
     #END IF 
     #FUN-AB0096 --------add end----------- 
     #FUN-CB0087--add--str--
     #IF l_aza.aza115 ='Y' AND l_aza.aza50 ='Y' THEN
     IF l_aza.aza115 ='Y' THEN    #TQC-D20067
        IF cl_null(l_ohb.ohb50) THEN
           #TQC-D20050--mod--str--
           #SELECT oha14,oha15 INTO l_oha14,l_oha15 FROM oha_file WHERE oha01 = l_ohb.ohb01
           #CALL s_reason_code(l_ohb.ohb01,l_ohb.ohb31,'',l_ohb.ohb04,l_ohb.ohb09,l_oha14,l_oha15) RETURNING l_ohb.ohb50
           LET l_sql2="SELECT oha14,oha15 FROM ",cl_get_target_table(l_plant_new,'oha_file')," WHERE oha01 ='",l_ohb.ohb01,"'"
           PREPARE ohb50_pr FROM l_sql2
           EXECUTE ohb50_pr INTO l_oha14,l_oha15
           CALL s_reason_code1(l_ohb.ohb01,l_ohb.ohb31,'',l_ohb.ohb04,l_ohb.ohb09,l_oha14,l_oha15,l_plant_new) RETURNING l_ohb.ohb50
           #TQC-D20050--mod--end--
           IF cl_null(l_ohb.ohb50) THEN
              CALL cl_err(l_ohb.ohb50,'aim-425',1)
              LET g_success="N"
              RETURN
           END IF
        END IF
     END IF
     #FUN-CB0087--add--end--
     
     LET l_sql2="INSERT INTO ",cl_get_target_table(l_plant_new,'ohb_file'), #FUN-A50102
      "(ohb01,ohb03,ohb04,ohb05, ",
      " ohb05_fac,ohb06,ohb07,ohb08, ",
      " ohb09,ohb091,ohb092,ohb11, ",
      " ohb12,ohb37,ohb13,ohb14,ohb14t,",     #FUN-AB0061 add ohb37
      " ohb15,ohb15_fac,ohb16,ohb30, ",
      " ohb31,ohb32,ohb33,ohb34,",
      " ohb50,ohb51,ohb60,ohb910,",   #FUN-560043
      " ohb911,ohb912,ohb913,ohb914,ohb930,",   #FUN-560043  #MOD-920265 add ohb930
      " ohb915,ohb916,ohb917,ohb1001,ohb1002,ohb1003,ohb1004,ohb1005,ohbplant,ohblegal, ",
      " ohbud01,ohbud02,ohbud03,ohbud04,ohbud05,",
      " ohbud06,ohbud07,ohbud08,ohbud09,ohbud10,",
      #" ohbud11,ohbud12,ohbud13,ohbud14,ohbud15,ohb71)",    #FUN-AB0096 add ohb71
      " ohbud11,ohbud12,ohbud13,ohbud14,ohbud15)",           #FUN-AC0055 remove ohb71
      " VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,?,",     #FUN-AB0061 add ?
      "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,",              #CHI-950020
      "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?, ?, ?,?) "   #FUN-560043 #No.FUN-620025 #No.MOD-680058  #MOD-920265 add ? #FUN-980006 add ?,?   #FUN-AB0096 add ?
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
     PREPARE ins_ohb FROM l_sql2
     EXECUTE ins_ohb USING 
       l_ohb.ohb01,l_ohb.ohb03,l_ohb.ohb04,l_ohb.ohb05, 
       l_ohb.ohb05_fac,l_ohb.ohb06,l_ohb.ohb07,l_ohb.ohb08, 
       l_ohb.ohb09,l_ohb.ohb091,l_ohb.ohb092,l_ohb.ohb11, 
       l_ohb.ohb12,l_ohb.ohb37,l_ohb.ohb13,l_ohb.ohb14,l_ohb.ohb14t,   #FUN-AB0061 add ohb37
       l_ohb.ohb15,l_ohb.ohb15_fac,l_ohb.ohb16,l_ohb.ohb30, 
       l_ohb.ohb31,l_ohb.ohb32,l_ohb.ohb33,l_ohb.ohb34,
       l_ohb.ohb50,l_ohb.ohb51,l_ohb.ohb60,l_ohb.ohb910,   #FUN-560043
       l_ohb.ohb911,l_ohb.ohb912,l_ohb.ohb913,l_ohb.ohb914,l_ohb.ohb930,    #FUN-560043   #MOD-920265 add ohb930 
       l_ohb.ohb915,l_ohb.ohb916,l_ohb.ohb917,l_ohb.ohb1001,l_ohb.ohb1002,  #No.FUN-620025
       l_ohb.ohb1003,l_ohb.ohb1004,l_ohb.ohb1005,l_plant,l_legal         #No.FUN-620025 #No.MOD-680058 #FUN-980006 add l_plant,l_legal
      ,l_ohb.ohbud01,l_ohb.ohbud02,l_ohb.ohbud03,l_ohb.ohbud04,l_ohb.ohbud05,
       l_ohb.ohbud06,l_ohb.ohbud07,l_ohb.ohbud08,l_ohb.ohbud09,l_ohb.ohbud10,
       #l_ohb.ohbud11,l_ohb.ohbud12,l_ohb.ohbud13,l_ohb.ohbud14,l_ohb.ohbud15,l_ohb.ohb71   #FUN-AB0096 add l_ohb.ohb71
       l_ohb.ohbud11,l_ohb.ohbud12,l_ohb.ohbud13,l_ohb.ohbud14,l_ohb.ohbud15  #FUN-AC0055 remove l_ohb.ohb71
       IF SQLCA.sqlcode<>0 THEN
          IF g_bgerr THEN
             CALL s_errmsg("","","ins ohb:","apm-019",1)
          ELSE
             CALL cl_err3("","","","","apm-019","","ins ohb:",1)
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
#         #FUN-C50136----add----str----
#         IF g_oaz.oaz96 ='Y' THEN
#            CALL s_ccc_oia07('G',l_oha.oha03) RETURNING l_oia07
#            IF l_oia07 = '0' THEN
#               CALL s_ccc_oia(l_oha.oha03,'G',l_oha.oha01,0,l_plant_new)
#            END IF
#         END IF
#         #FUN-C50136----add----end----
       END IF


     #-----MOD-A90100---------
     LET l_sql2 = "SELECT ima918,ima921 FROM ",cl_get_target_table(l_plant_new,'ima_file'), 
                  " WHERE ima01 = '",l_ohb.ohb04,"'",
                  "   AND imaacti = 'Y'"
     CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
     CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 
     PREPARE ima_ohb FROM l_sql2
     EXECUTE ima_ohb INTO g_ima918,g_ima921

     IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
        FOREACH p840_g_rvbs INTO l_rvbs.*
           IF STATUS THEN
              CALL cl_err('rvbs',STATUS,1)
           END IF
        
           LET l_rvbs.rvbs00 = "axmt840"
           LET l_rvbs.rvbs01 = l_ohb.ohb01
           LET l_rvbs.rvbs06 = l_rvbs.rvbs06 
           IF cl_null(l_rvbs.rvbs06) THEN
              LET l_rvbs.rvbs06 = 0
           END IF
           LET l_rvbs.rvbs09 = -1
           LET l_rvbs.rvbs13 = 0    

           #新增批/序號資料檔
           EXECUTE ins_rvbs USING l_rvbs.rvbs00,l_rvbs.rvbs01,l_rvbs.rvbs02,
                                  l_rvbs.rvbs021,l_rvbs.rvbs022,l_rvbs.rvbs03,
                                  l_rvbs.rvbs04,l_rvbs.rvbs05,l_rvbs.rvbs06,
                                  l_rvbs.rvbs07,l_rvbs.rvbs08,l_rvbs.rvbs09,
                                  l_rvbs.rvbs13,l_plant,l_legal  
     
           IF STATUS OR SQLCA.SQLCODE THEN
              IF g_bgerr THEN
                 LET g_showmsg = l_rvbs.rvbs01,"/",l_rvbs.rvbs03
                 CALL s_errmsg('rvbs01,rvbs03',g_showmsg,'ins rvbs:',SQLCA.sqlcode,1) 
              ELSE
                 CALL cl_err3("","","","","apm-019","","ins rvbs:",1)
              END IF
              LET g_success='N'
           END IF
        
           CALL p840_imgs(l_ohb.ohb09,l_ohb.ohb091,l_ohb.ohb092,l_oha.oha02,l_rvbs.*)

        END FOREACH
     END IF
     #-----END MOD-A90100-----

     #FUN-B90012----add----str----
     IF s_industry('icd') THEN
        #FUN-BA0051 --START mark--
        #LET l_sql2 = "SELECT imaicd08 FROM ",cl_get_target_table(l_plant_new,'imaicd_file'),",",
        #                                     cl_get_target_table(l_plant_new,'ima_file'),
        #             " WHERE imaicd00 = '",l_ogb.ogb04,"'",
        #             "   AND imaicd00 = ima01 ",
        #             "   AND imaacti  = 'Y'   "
        #CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
        #CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2
        #PREPARE imaicd08_ohb FROM l_sql2
        #EXECUTE imaicd08_ohb INTO l_imaicd08
        #
        #IF l_imaicd08 = 'Y' THEN
        #FUN-BA0051 --END mark--
       #IF s_icdbin_multi(l_ogb.ogb04,l_plant_new) THEN   #FUN-BA0051 #CHI-C80009 mark
        IF s_icdbin_multi(l_ohb.ohb04,l_plant_new) THEN   #FUN-BA0051 #CHI-C80009 add
           FOREACH p840_g_idd INTO l_idd.*
              IF STATUS THEN
                 CALL cl_err('idd',STATUS,1)
              END IF
              LET l_idd.idd10 = l_ohb.ohb01
              LET l_idd.idd11 = l_ohb.ohb03
        #CHI-C80009---add---START
              LET l_idd.idd02 = l_ohb.ohb09
              LET l_idd.idd03 = l_ohb.ohb091
              LET l_idd.idd04 = l_ohb.ohb092
        #CHI-C80009---add-----END
              CALL icd_ida(1,l_idd.*,l_plant_new)
           END FOREACH
        END IF
        LET l_sql2 = "SELECT ohbiicd028,ohbiicd029 FROM ",cl_get_target_table(l_plant_new,'ohbi_file'),
                     " WHERE ohbi01 = '",l_ohb.ohb01,"'",
                     "   AND ohbi03 = '",l_ohb.ohb03,"'"
        CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
        CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2
        PREPARE l_ohbi_p3 FROM l_sql2
        EXECUTE l_ohbi_p3 INTO l_ohbiicd028,l_ohbiicd029
        CALL s_icdpost(11,l_ohb.ohb04,l_ohb.ohb09,l_ohb.ohb091,l_ohb.ohb092,l_ohb.ohb05,l_ohb.ohb12,l_ohb.ohb01,
                       l_ohb.ohb03,l_oha.oha02,'Y',l_ohb.ohb31,l_ohb.ohb32,l_ohbiicd029,l_ohbiicd028,l_plant_new)  
             RETURNING l_flag
        IF l_flag = 0 THEN
           LET g_success = 'N'
        END IF
     END IF
     #FUN-B90012----add----end----

     #新增至暫存檔中
     INSERT INTO p840_file VALUES(p_i,l_ohb.ohb01,l_ohb.ohb03,
                                         l_ohb.ohb13)
     IF SQLCA.sqlcode<>0 THEN
        IF g_bgerr THEN
           LET g_showmsg = p_i,"/",l_ohb.ohb01,"/",l_ohb.ohb03,"/",l_ohb.ohb13
           CALL s_errmsg("p_no,pab_no,pab_item,pab_price",g_showmsg,"ins p840_file:",SQLCA.sqlcode,1)
        ELSE
           CALL cl_err3("ins","p840_file",p_i,l_ohb.ohb01,SQLCA.sqlcode,"","",1)
        END IF
        LET g_success = 'N'
     END IF
     #單頭之銷退金額
     LET l_oha.oha50 =l_oha.oha50 + l_ohb.ohb14   #原幣銷退金額(未稅)
     #LET l_sql3="UPDATE ",l_dbs_tra CLIPPED,"oha_file",  #FUN-980092
     LET l_sql3="UPDATE ",cl_get_target_table(l_plant_new,'oha_file'), #FUN-A50102
                "   SET oha50 = ? ",
                " WHERE oha01 = ? "
 	 CALL cl_replace_sqldb(l_sql3) RETURNING l_sql3        #FUN-920032
     CALL cl_parse_qry_sql(l_sql3,l_plant_new) RETURNING l_sql3 #FUN-980092
     PREPARE upd_oha50 FROM l_sql3
     EXECUTE upd_oha50 USING l_oha.oha50,l_oha.oha01
     IF SQLCA.sqlcode<>0 THEN
        IF g_bgerr THEN
           CALL s_errmsg("","","upd oha:",SQLCA.sqlcode,1)
        ELSE
           CALL cl_err3("","","","",SQLCA.sqlcode,"","upd oha:",1)
        END IF
        LET g_success = 'N'
     END IF
     IF l_aza.aza50 = 'Y'THEN     #使用分銷功能
        LET l_oha.oha1008 = l_oha.oha1008 + l_ohb.ohb14t   #原幣銷退金額(含稅)           
        #LET l_sql8="UPDATE ",l_dbs_tra CLIPPED,"oha_file", #FUN-980092 
        LET l_sql8="UPDATE ",cl_get_target_table(l_plant_new,'oha_file'), #FUN-A50102       
                   "   SET oha1008 = ? ",                                            
                   " WHERE oha01 = ? "                                             
 	    CALL cl_replace_sqldb(l_sql8) RETURNING l_sql8        #FUN-920032
        CALL cl_parse_qry_sql(l_sql8,l_plant_new) RETURNING l_sql8 #FUN-980092
        PREPARE upd_oha1008 FROM l_sql8                                              
        EXECUTE upd_oha1008 USING l_oha.oha1008,l_oha.oha01                            
        IF SQLCA.sqlcode<>0 THEN                                                   
           IF g_bgerr THEN
              CALL s_errmsg("","","upd oha:",SQLCA.sqlcode,1)
           ELSE
              CALL cl_err3("","","","",SQLCA.sqlcode,"","upd oha:",1)
           END IF
           LET g_success = 'N'                                                     
        END IF
     END IF
 
     #CHI-C80042 add start -----
     #回寫最近入庫日 ima73
     LET l_sql = "SELECT ima29 FROM ",cl_get_target_table(l_plant_new,'ima_file'),
                  " WHERE ima01='",l_ohb.ohb04,"'"
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql
     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql
     PREPARE ima_p3 FROM l_sql
     IF SQLCA.SQLCODE THEN
       IF g_bgerr THEN
          CALL s_errmsg("ima01",l_ohb.ohb04,"",SQLCA.sqlcode,1)
       ELSE
          CALL cl_err3("","","","",SQLCA.sqlcode,"","",1)
       END IF
     END IF
     DECLARE ima_c3 CURSOR FOR ima_p3
     OPEN ima_c3
     FETCH ima_c3 INTO l_ima29
     #異動日期需大於原來的異動日期才可
     #必須判斷null,否則新料不會update
     IF (l_oha.oha02 > l_ima29 OR l_ima29 IS NULL) THEN
        LET l_sql = "UPDATE ",cl_get_target_table(l_plant_new,'ima_file'),
                    " SET ima73 = ? , ima29 = ? WHERE ima01 = ?  "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql
        CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql
        PREPARE upd_ima3 FROM l_sql
        EXECUTE upd_ima3 USING l_oha.oha02,l_oha.oha02,l_ohb.ohb04
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
           IF g_bgerr THEN
              CALL s_errmsg('ima01',l_ohb.ohb04,'upd ima',STATUS,1)
           ELSE
              CALL cl_err('upd ima:',STATUS,1)
           END IF
           LET g_success='N'
        END IF
     END IF
     #CHI-C80042 add end   -----

     IF l_aza.aza50 = 'Y' AND l_oha.oha05 = '4'  THEN   #使用分銷功能,且有代送則生成出貨單
        CALL p840_ogbins()     
     END IF
END FUNCTION
 
FUNCTION p840_rvuins()
  DEFINE l_sql  LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(1200)
  DEFINE l_sql1  LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(600)
  DEFINE l_sql2  LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(1600)
  DEFINE i,l_i    LIKE type_file.num5    #No.FUN-680136 SMALLINT
  DEFINE li_result LIKE type_file.num5     #FUN-560043  #No.FUN-680136 SMALLINT
  DEFINE l_plant    LIKE azp_file.azp01    #FUN-980006 add
  DEFINE l_legal    LIKE azw_file.azw02    #FUN-980006 add
 
    LET l_plant = g_poy.poy04  #FUN-980006 add 
    CALL s_getlegal(l_plant) RETURNING l_legal  #FUN-980006 add 
 
  #新增入庫單單頭檔(rvu_file)
    LET l_rvu.rvu00 = '3'                #異動別
    CALL s_auto_assign_no('apm',rvu_t1,g_rvu.rvu03,"","","",l_plant_new,"","")
      RETURNING li_result,l_rvu.rvu01
    IF (NOT li_result) THEN 
       LET g_msg = l_plant_new CLIPPED,l_rvu.rvu01
       CALL s_errmsg("rvu01",l_rvu.rvu01,g_msg CLIPPED,"mfg3046",1) 
       LET g_success ='N'
       RETURN
    END IF   
    LET l_sql1 = "SELECT rva01 ",
                 #" FROM ",l_dbs_tra CLIPPED,"rva_file ",   #FUN-980092
                 " FROM ",cl_get_target_table(l_plant_new,'rva_file'), #FUN-A50102 
                 " WHERE rva99='",g_rva.rva99,"' " 
 	CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
    CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-A50102
    PREPARE rva_p1 FROM l_sql1
    IF STATUS THEN
      IF g_bgerr THEN
         CALL s_errmsg("","","rva_p1",STATUS,1)
      ELSE
         CALL cl_err3("","","","",STATUS,"","rva_p1",1)
      END IF
    END IF
    DECLARE rva_c1 CURSOR FOR rva_p1
    OPEN rva_c1
    FETCH rva_c1 INTO l_rva01
    IF SQLCA.SQLCODE <> 0 THEN
       LET g_success='N'
       RETURN
    END IF
    CLOSE rva_c1      
    LET l_rvu.rvu02 = l_rva01            #驗收單號   #No.FUN-620025
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
    LET l_sql = " SELECT pmm09,pmm01 ",  #No.FUN-620025
               #"   FROM ",l_dbs_tra CLIPPED,"pmm_file ",  #FUN-980092
                "   FROM ",cl_get_target_table(l_plant_new,'pmm_file'), #FUN-A50102
                "  WHERE pmm99 = '",g_pmm.pmm99,"'"   #No.FUN-620025
 	CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
    PREPARE pmm_prepare2 FROM l_sql
    DECLARE pmm_curs2 CURSOR FOR pmm_prepare2
    OPEN pmm_curs2
    FETCH pmm_curs2 INTO l_rvu.rvu04,l_pmm01      #供應廠商  #No.FUN-620025
    IF SQLCA.sqlcode THEN 
       IF g_bgerr THEN
          CALL s_errmsg("","","fetch pmm_curs2",SQLCA.sqlcode,1)
       ELSE
          CALL cl_err3("","","","",SQLCA.sqlcode,"","fetch pmm_curs2",1)
       END IF
       LET l_rva.rva05 = ''
       LET g_success = 'N'
    END IF
    CLOSE pmm_curs2
    SELECT pmc03 INTO l_rvu.rvu05        #廠商簡稱
     FROM pmc_file
    WHERE pmc01 = l_rvu.rvu04 
    LET l_rvu.rvu06 = g_pmm.pmm13        #採購部門
    LET l_rvu.rvu07 = g_pmm.pmm12        #人員
    LET l_rvu.rvu08 = g_pmm.pmm02        #採購性質
    LET l_rvu.rvu09 = null
    LET l_rvu.rvu11 = null
    LET l_rvu.rvu12 = null
    LET l_rvu.rvu20 = 'Y'                #已拋轉 no.4475
    LET l_rvu.rvu99 = g_flow99           #No.8128
    LET l_rvu.rvuconf= 'Y'
    LET l_rvu.rvuacti= 'Y'
    LET l_rvu.rvuuser= g_user
    LET l_rvu.rvugrup= g_grup
    LET l_rvu.rvuoriu= g_user       #TQC-A10060  add
    LET l_rvu.rvuorig= g_grup       #TQC-A10060  add
    LET l_rvu.rvumodu= null
    LET l_rvu.rvudate= null
    LET l_rvu.rvu111 = g_rvu.rvu111        #付款方式
    LET l_rvu.rvu112 = g_rvu.rvu112        #價格條件
    LET l_rvu.rvu113 = g_rvu.rvu113        #幣別
    LET l_rvu.rvu114 = g_rvu.rvu114        #匯率
    LET l_rvu.rvu115 = g_rvu.rvu115        #稅別
    LET l_rvu.rvu116 = g_rvu.rvu116        #退貨方式
    LET l_rvu.rvu17  = '1'                 #簽核狀況:1.已核准  #FUN-AB0023 add
    LET l_rvu.rvumksg= 'N'                 #是否簽核           #FUN-AB0023 add
    LET l_rvu.rvu27 = '1'                  #TQC-B60065
    #新增倉退單頭
     #LET l_sql="INSERT INTO ",l_dbs_tra CLIPPED,"rvu_file",  #FUN-980092
     LET l_sql="INSERT INTO ",cl_get_target_table(l_plant_new,'rvu_file'), #FUN-A50102
      "(rvu00  ,rvu01  ,rvu02  ,rvu03  ,rvu04  ,",
      " rvu05  ,rvu06  ,rvu07  ,rvu08  ,rvu09  ,",
      " rvu10  ,rvu11  ,rvu12  ,rvu13  ,rvu14  ,",
      " rvu15  ,rvu20  ,rvu99  ,rvuconf,rvuacti,",
      " rvu17  ,rvumksg,",                                   #FUN-AB0023 add
      " rvu27  ,",                                           #TQC-B60065
      " rvuuser,rvugrup,rvumodu,rvudate,rvu111,rvu112,rvu113,rvu114,rvu115,rvu116,rvuplant,rvulegal,",
      " rvuud01,rvuud02,rvuud03,rvuud04,rvuud05,",
      " rvuud06,rvuud07,rvuud08,rvuud09,rvuud10,",
      " rvuud11,rvuud12,rvuud13,rvuud14,rvuud15,rvuoriu,rvuorig)",    #TQC-A10060  add rvuoriu,rvuorig
      " VALUES( ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,",
      "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,?,",             #No.CHI-950020
      "         ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?)"  #TQC-A10060  add ?,?  #FUN-940083 #FUN-980006 add ?,? #TQC-B60065 add ?
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
     PREPARE ins_rvu FROM l_sql
     EXECUTE ins_rvu USING 
         l_rvu.rvu00,l_rvu.rvu01,l_rvu.rvu02,l_rvu.rvu03,l_rvu.rvu04,
         l_rvu.rvu05,l_rvu.rvu06,l_rvu.rvu07,l_rvu.rvu08,l_rvu.rvu09,
         l_rvu.rvu10,l_rvu.rvu11,l_rvu.rvu12,l_rvu.rvu13,l_rvu.rvu14,
         l_rvu.rvu15,l_rvu.rvu20,l_rvu.rvu99,l_rvu.rvuconf,l_rvu.rvuacti,
         l_rvu.rvu17,l_rvu.rvumksg,                                      #FUN-AB0023 add
         l_rvu.rvu27,                                                    #TQC-B60065
         l_rvu.rvuuser,l_rvu.rvugrup,l_rvu.rvumodu,l_rvu.rvudate,
         l_rvu.rvu111,l_rvu.rvu112,l_rvu.rvu113,l_rvu.rvu114,             #FUN-940083
         l_rvu.rvu115,l_rvu.rvu116,l_plant,l_legal                                        #FUN-940083 #FUN-980006 add l_plant,l_legal
        ,l_rvu.rvuud01,l_rvu.rvuud02,l_rvu.rvuud03,l_rvu.rvuud04,l_rvu.rvuud05,
         l_rvu.rvuud06,l_rvu.rvuud07,l_rvu.rvuud08,l_rvu.rvuud09,l_rvu.rvuud10,
         l_rvu.rvuud11,l_rvu.rvuud12,l_rvu.rvuud13,l_rvu.rvuud14,l_rvu.rvuud15
        ,l_rvu.rvuoriu,l_rvu.rvuorig                      #TQC-A10060   add
        IF SQLCA.sqlcode<>0 THEN
           IF g_bgerr THEN
              CALL s_errmsg("","","ins rvu:",SQLCA.sqlcode,1)
           ELSE
              CALL cl_err3("","","","",SQLCA.sqlcode,"","ins rvu:",1)
           END IF
         LET g_success = 'N'
        END IF
END FUNCTION
 
#入庫單單身檔
FUNCTION p840_rvvins(p_i)
  DEFINE l_sql  LIKE type_file.chr1000   #No.FUN-680136 VARCHAR(1200)
  DEFINE l_sql1  LIKE type_file.chr1000  #No.FUN-680136 VARCHAR(600)
  DEFINE l_sql2  LIKE type_file.chr1000  #No.FUN-680136 VARCHAR(1600)
  DEFINE p_i     LIKE type_file.num5     #No.FUN-680136 SMALLINT
  DEFINE l_no    LIKE type_file.num5     #No.FUN-680136 SMALLINT
  DEFINE l_price LIKE ogb_file.ogb13
  DEFINE i,l_i    LIKE type_file.num5    #No.FUN-680136 SMALLINT
  DEFINE l_msg   LIKE type_file.chr1000  #No.FUN-680136 VARCHAR(80)
  DEFINE l_chr   LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)
#  DEFINE l_qoh   LIKE ima_file.ima262 #FUN-A20044
  DEFINE l_qoh   LIKE type_file.num15_3 #FUN-A20044
  DEFINE l_ima86 LIKE ima_file.ima86
  DEFINE l_ima39 LIKE ima_file.ima39
  DEFINE l_ima35 LIKE ima_file.ima35
  DEFINE l_ima36 LIKE ima_file.ima36
  DEFINE l_rvvi  RECORD LIKE rvvi_file.* #No.FUN-7B0018
  DEFINE l_plant    LIKE azp_file.azp01    #FUN-980006 add
  DEFINE l_legal    LIKE azw_file.azw02    #FUN-980006 add
  DEFINE l_img09 LIKE img_file.img09     #CHI-960041
  DEFINE l_sw    LIKE type_file.num5     #CHI-960041
  DEFINE l_flag  LIKE type_file.chr1     #FUN-B90012
  DEFINE l_idd   RECORD LIKE idd_file.*  #FUN-B90012
  #DEFINE l_imaicd08 LIKE imaicd_file.imaicd08 #FUN-B90012 #FUN-BA0051 mark
  DEFINE l_rvviicd02 LIKE rvvi_file.rvviicd02 #FUN-B90012
  DEFINE l_rvviicd05 LIKE rvvi_file.rvviicd05 #FUN-B90012
  DEFINE l_ima29 LIKE ima_file.ima29   #CHI-C80042 add
  DEFINE l_rvu06        LIKE rvu_file.rvu06        #FUN-CB0087
  DEFINE l_rvu07        LIKE rvu_file.rvu07        #FUN-CB0087
  
      LET l_plant = g_poy.poy04  #FUN-980006 add 
      CALL s_getlegal(l_plant) RETURNING l_legal  #FUN-980006 add 
 
     #新增入庫單身檔[rvv_file]
     LET l_rvv.rvv01 = l_rvu.rvu01     #入庫單號
     LET l_rvv.rvv02 = g_rvv.rvv02     #項次
     LET l_rvv.rvv03 = '3'             #異動類別
     LET l_rvv.rvv04 = l_rva01         #驗收單號   #No.FUN-620025
     LET l_rvv.rvv05 = g_rvv.rvv05     #項次
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
     LET l_sql = " SELECT pmm01,pmm09 ",  #FUN-830035 add pmm01
                 #"   FROM ",l_dbs_tra CLIPPED,"pmm_file ",  #FUN-980092
                 "   FROM ",cl_get_target_table(l_plant_new,'pmm_file'), #FUN-A50102
                 "  WHERE pmm99 = '",g_pmm.pmm99,"'"   #No.FUN-620025
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
     PREPARE pmm_prepare3 FROM l_sql
     DECLARE pmm_curs3 CURSOR FOR pmm_prepare3
     OPEN pmm_curs3
     FETCH pmm_curs3 INTO l_pmm01,l_rvv.rvv06      #供應廠商  #FUN-830035 add l_pmm01
     IF SQLCA.sqlcode THEN 
        IF g_bgerr THEN
           CALL s_errmsg("","","fetch pmm_curs3",SQLCA.sqlcode,1)
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
     LET l_rvv.rvv25 = 'N'             #樣品否
     LET l_rvv.rvv26 = g_rvv.rvv26     #理由碼
     IF l_aza.aza50 = 'Y' THEN LET l_rvv.rvv26 = g_poy.poy30 END IF  #No.FUN-620025
     IF cl_null(l_aza.aza50) THEN LET l_rvv.rvv26 = g_poy.poy30 END IF #TQC-D40064 add
     LET l_rvv.rvv31 = g_rvv.rvv31     #料件編號
     LET l_rvv.rvv031 = g_rvv.rvv031   #MOD-880099 品名以來源單據為主
     LET l_rvv.rvv35 = g_rvv.rvv35     #CHI-C80009 add   
     IF NOT cl_null(p_imd01) THEN
        #CALL p840_imd(p_imd01,l_dbs_new)
        CALL p840_imd(p_imd01,l_dbs_new,l_plant_new)  #FUN-A50102
        LET l_rvv.rvv32 = p_imd01
        LET l_rvv.rvv33 = ' '
        LET l_rvv.rvv34 = ' '
     ELSE
       CALL p840_ima(l_rvv.rvv31)
          RETURNING l_rvv.rvv031,l_rvv.rvv35,l_qoh,l_ima86,l_ima39,
                    l_ima35,l_ima36
       LET l_rvv.rvv17 = s_digqty(l_rvv.rvv17,l_rvv.rvv35)     #FUN-BB0084
       LET l_rvv.rvv031 = g_rvv.rvv031   #MOD-880099 品名以來源單據為主
       IF cl_null(l_ima35) THEN
          LET l_rvv.rvv32 = g_rvv.rvv32
          LET l_rvv.rvv33 = g_rvv.rvv33
          LET l_rvv.rvv34 = g_rvv.rvv34
       ELSE
          LET l_rvv.rvv32 = l_ima35
          LET l_rvv.rvv33 = l_ima36
          LET l_rvv.rvv34 = ' '
       END IF
     END IF
    #IF g_sma.sma96 = 'Y' THEN         #FUN-C80001 #FUN-D30099 mark
     IF g_pod.pod08 = 'Y' THEN         #FUN-D30099
        LET l_rvv.rvv34 = g_rvv.rvv34  #FUN-C80001
     END IF                            #FUN-C80001
     IF cl_null(l_rvv.rvv32) THEN LET l_rvv.rvv32 = ' ' END IF
     IF cl_null(l_rvv.rvv33) THEN LET l_rvv.rvv33 = ' ' END IF
     IF cl_null(l_rvv.rvv34) THEN LET l_rvv.rvv34 = ' ' END IF
     IF l_rvv.rvv31[1,4] <> 'MISC' THEN 
        LET l_sql = "SELECT img09 ",
                    #" FROM ",l_dbs_tra CLIPPED,"img_file ",  #FUN-980092
                    " FROM ",cl_get_target_table(l_plant_new,'img_file'), #FUN-A50102
                    " WHERE img01='",l_rvv.rvv31,"' ",
                    "   AND img02='",l_rvv.rvv32,"'",
                    "   AND img03='",l_rvv.rvv33,"'",
                    "   AND img04='",l_rvv.rvv34,"'"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql		#FUN-920032
        CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
        PREPARE img_p FROM l_sql
        IF STATUS THEN
           IF g_bgerr THEN
              CALL s_errmsg("","","img_pre",STATUS,1)
           ELSE
              CALL cl_err3("","","","",STATUS,"","img_pre",1)
           END IF
        END IF
        DECLARE img_c CURSOR FOR img_p
        OPEN img_c
        FETCH img_c INTO l_img09
        IF STATUS THEN
           LET g_success='N'
           IF g_bgerr THEN
              CALL s_errmsg("","","sel img09:",STATUS,1)
           ELSE
              CALL cl_err3("","","","",STATUS,"","sel img09:",1)
           END IF
        END IF
        CLOSE img_c
       
        CALL s_umfchk1(l_rvv.rvv31,l_rvv.rvv35,l_img09,l_plant_new)    #No.FUN-980059
             RETURNING l_sw,l_rvv.rvv35_fac
        IF l_sw = 1 THEN
           IF g_bgerr THEN
              CALL s_errmsg("","","","mfg3075",1)
           ELSE
              CALL cl_err3("","","","","mfg3075","","",1)
           END IF
           LET l_rvv.rvv35_fac = 1
        END IF
     ELSE
        LET l_rvv.rvv35_fac = 1
     END IF
     LET l_rvv.rvv36 = l_pmm01         #採購單號    #No.FUN-620025
     LET l_rvv.rvv37 = g_rvv.rvv37     #採購序號
     LET l_rvv.rvv87 = g_rvv.rvv87  #MOD-820060 add
     # --- 倉退單價
     #LET l_sql1 = "SELECT pmn31,pmn31t,pmn930 FROM ",l_dbs_tra CLIPPED,"pmn_file",  #FUN-980092 
     #LET l_sql1 = "SELECT pmn31,pmn31t,pmn930 FROM ",cl_get_target_table(l_plant_new,'pmn_file'), #FUN-A50102    #MOD-AB0122
     LET l_sql1 = "SELECT pmn930 FROM ",cl_get_target_table(l_plant_new,'pmn_file'), #FUN-A50102    #MOD-AB0122
                  " WHERE pmn01 = '",l_pmm01,"'",       #No.FUN-620025
                  "   AND pmn02 = ",g_rvv.rvv37
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-980092
     PREPARE pmn31_pre FROM l_sql1
     DECLARE pmn31_cs CURSOR FOR pmn31_pre
     OPEN pmn31_cs 
     #FETCH pmn31_cs INTO l_rvv.rvv38,l_rvv.rvv38t,l_rvv.rvv930   #No.FUN-620025  #MOD-920265 add rvv930   #MOD-AB0122
     FETCH pmn31_cs INTO l_rvv.rvv930   #No.FUN-620025  #MOD-920265 add rvv930   #MOD-AB0122
     IF STATUS THEN
        LET g_success='N'
        IF g_bgerr THEN
           CALL s_errmsg("","","sel pmn31:",STATUS,1)
        ELSE
           CALL cl_err3("","","","",STATUS,"","sel pmn31:",1)
        END IF
     END IF
     CLOSE pmn31_cs

     #-----MOD-AB0122---------
     LET l_sql1 = "SELECT rvb10,rvb10t,rvb22 FROM ",cl_get_target_table(l_plant_new,'rvb_file'),   #FUN-BB0001 add rvb22
                  " WHERE rvb01 = '",l_rvv.rvv04,"'",      
                  "   AND rvb02 = ",l_rvv.rvv05
     CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1     
     CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 
     PREPARE rvb10_pre FROM l_sql1
     DECLARE rvb10_cs CURSOR FOR rvb10_pre
     OPEN rvb10_cs 
     FETCH rvb10_cs INTO l_rvv.rvv38,l_rvv.rvv38t,l_rvv.rvv22  #FUN-BB0001 add rvv22  
     IF STATUS THEN
        LET g_success='N'
        IF g_bgerr THEN
           CALL s_errmsg("","","sel rvb10:",STATUS,1)
        ELSE
           CALL cl_err3("","","","",STATUS,"","sel rvb10:",1)
        END IF
     END IF
     CLOSE rvb10_cs
     #-----END MOD-AB0122-----
 
   IF cl_null(l_rvv.rvv38) THEN LET l_rvv.rvv38=0 END IF
   CALL cl_digcut(l_rvv.rvv38,l_azi.azi03) RETURNING l_rvv.rvv38
   LET l_rvv.rvv39 = l_rvv.rvv38 * l_rvv.rvv87   #金額  #No.TQC-6A0084
   CALL cl_digcut(l_rvv.rvv39,l_azi.azi04) RETURNING l_rvv.rvv39
 
   IF cl_null(l_rvv.rvv38t) THEN LET l_rvv.rvv38t=0 END IF
   CALL cl_digcut(l_rvv.rvv38t,l_azi.azi03) RETURNING l_rvv.rvv38t
   LET l_rvv.rvv39t = l_rvv.rvv38t * l_rvv.rvv87   #金額  #No.TQC-6A0084
   CALL cl_digcut(l_rvv.rvv39t,l_azi.azi04) RETURNING l_rvv.rvv39t
 
     LET l_rvv.rvv80 = g_rvv.rvv80
     LET l_rvv.rvv81 = g_rvv.rvv81
     LET l_rvv.rvv82 = g_rvv.rvv82
     LET l_rvv.rvv83 = g_rvv.rvv83
     LET l_rvv.rvv84 = g_rvv.rvv84
     LET l_rvv.rvv85 = g_rvv.rvv85
     LET l_rvv.rvv86 = g_rvv.rvv86
     LET l_rvv.rvv89 = 'N'          #FUN-940083 add
    IF cl_null(l_rvv.rvv02) THEN LET l_rvv.rvv02 = 1 END IF
     #FUN-CB0087--add--str--
     IF l_aza.aza115 ='Y' THEN
        IF cl_null(l_rvv.rvv26) THEN  #TQC-D20067  mark  #TQC-D40064 remark
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
        END IF   #TQC-D20067  mark  #TQC-D40064 remark
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
      " rvv41,rvv42,rvv43,rvv80,rvv81,rvv82, ",   #FUN-560043
      " rvv83,rvv84,rvv85,rvv86,rvv87,rvv38t,rvv39t,rvv88,rvv930,rvv89,rvvplant,rvvlegal,",
      " rvvud01,rvvud02,rvvud03,rvvud04,rvvud05,",
      " rvvud06,rvvud07,rvvud08,rvvud09,rvvud10,",
      " rvvud11,rvvud12,rvvud13,rvvud14,rvvud15,",
      " rvv22  )",           #FUN-BB0001 add
      " VALUES( ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
      "         ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",             #No.CHI-950020
      "         ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",   #FUN-560043 #No.FUN-620025  #No.TQC-7B0083  #MOD-920265 add ? #FUN-940083 
      "         ?,?,?,?) "   #FUN-980006 add ?,?  #FUN-BB0001 add ?
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
     PREPARE ins_rvv FROM l_sql2
     EXECUTE ins_rvv USING 
       l_rvv.rvv01,l_rvv.rvv02,l_rvv.rvv03,l_rvv.rvv04,l_rvv.rvv05,
       l_rvv.rvv06,l_rvv.rvv09,l_rvv.rvv17,l_rvv.rvv18,l_rvv.rvv23,
       l_rvv.rvv24,l_rvv.rvv25,l_rvv.rvv26,l_rvv.rvv31,l_rvv.rvv031,
       l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,l_rvv.rvv35,l_rvv.rvv35_fac,
       l_rvv.rvv36,l_rvv.rvv37,l_rvv.rvv38,l_rvv.rvv39,l_rvv.rvv40,
       l_rvv.rvv41,l_rvv.rvv42,l_rvv.rvv43,l_rvv.rvv80,l_rvv.rvv81,   #FUN-560043
       l_rvv.rvv82,l_rvv.rvv83,l_rvv.rvv84,l_rvv.rvv85,l_rvv.rvv86,   #FUN-560043
       l_rvv.rvv87,l_rvv.rvv38t,l_rvv.rvv39t,l_rvv.rvv88,l_rvv.rvv930, #FUN-560043  #No.FUN-620025  #No.TQC-7B0083  #MOD-920265 add rvv930
       l_rvv.rvv89,l_plant,l_legal                                                     #FUN-940083 add rvv89 #FUN-980006 add l_plant,l_legal
      ,l_rvv.rvvud01,l_rvv.rvvud02,l_rvv.rvvud03,l_rvv.rvvud04,l_rvv.rvvud05,
       l_rvv.rvvud06,l_rvv.rvvud07,l_rvv.rvvud08,l_rvv.rvvud09,l_rvv.rvvud10,
       l_rvv.rvvud11,l_rvv.rvvud12,l_rvv.rvvud13,l_rvv.rvvud14,l_rvv.rvvud15,
       l_rvv.rvv22                   #FUN-BB0001 add
       IF SQLCA.sqlcode<>0 THEN
          IF g_bgerr THEN
             CALL s_errmsg("","","ins rvv:",SQLCA.sqlcode,1)
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
       #-----MOD-A90100---------
       LET l_sql2 = "SELECT ima918,ima921 FROM ",cl_get_target_table(l_plant_new,'ima_file'), 
                    " WHERE ima01 = '",l_rvv.rvv31,"'",
                    "   AND imaacti = 'Y'"
       CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
       CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 
       PREPARE ima_rvv FROM l_sql2
       EXECUTE ima_rvv INTO g_ima918,g_ima921
        
       IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
          FOREACH p840_g_rvbs INTO l_rvbs.*
             IF STATUS THEN
                CALL cl_err('rvbs',STATUS,1)
             END IF
       
             LET l_rvbs.rvbs00 = "apmt742"
             LET l_rvbs.rvbs01 = l_rvv.rvv01
             LET l_rvbs.rvbs06 = l_rvbs.rvbs06 
             IF cl_null(l_rvbs.rvbs06) THEN
                LET l_rvbs.rvbs06 = 0
             END IF
#             LET l_rvbs.rvbs09 = 1         #TQC-B90236 mark
             LET l_rvbs.rvbs09 = -1         #TQC-B90236 
             LET l_rvbs.rvbs13 = 0    
       
             #新增批/序號資料檔
             EXECUTE ins_rvbs USING l_rvbs.rvbs00,l_rvbs.rvbs01,l_rvbs.rvbs02,
                                    l_rvbs.rvbs021,l_rvbs.rvbs022,l_rvbs.rvbs03,
                                    l_rvbs.rvbs04,l_rvbs.rvbs05,l_rvbs.rvbs06,
                                    l_rvbs.rvbs07,l_rvbs.rvbs08,l_rvbs.rvbs09,
                                    l_rvbs.rvbs13,l_plant,l_legal   

             IF STATUS OR SQLCA.SQLCODE THEN
                IF g_bgerr THEN
                   LET g_showmsg = l_rvbs.rvbs01,"/",l_rvbs.rvbs03
                   CALL s_errmsg('rvbs01,rvbs03',g_showmsg,'ins rvbs:',SQLCA.sqlcode,1) 
                ELSE
                   CALL cl_err3("","","","","apm-019","","ins rvbs:",1)
                END IF
                LET g_success='N'
             END IF

             CALL p840_imgs(l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,l_rvu.rvu03,l_rvbs.*)	
          
          END FOREACH
       END IF
       #-----END MOD-A90100-----
       #FUN-B90012----add----str----
       IF s_industry('icd') THEN
          #FUN-BA0051 --START mark--
          #LET l_sql2 = "SELECT imaicd08 FROM ",cl_get_target_table(l_plant_new,'imaicd_file'),",",
          #                                     cl_get_target_table(l_plant_new,'ima_file'),
          #             " WHERE imaicd00 = '",l_rvv.rvv31,"'",
          #             "   AND imaicd00 = ima01 ",
          #             "   AND imaacti  = 'Y'   "
          #CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
          #CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2
          #PREPARE imaicd08_rvv FROM l_sql2
          #EXECUTE imaicd08_rvv INTO l_imaicd08
          #
          #IF l_imaicd08 = 'Y' THEN
          #FUN-BA0051 --END mark--
          IF s_icdbin_multi(l_rvv.rvv31,l_plant_new) THEN   #FUN-BA0051
             FOREACH p840_g_idd INTO l_idd.*
                IF STATUS THEN
                   CALL cl_err('idd',STATUS,1)
                END IF
                LET l_idd.idd10 = l_rvv.rvv01
                LET l_idd.idd11 = l_rvv.rvv02
             #CHI-C80009---add---START
                LET l_idd.idd02 = l_rvv.rvv32
                LET l_idd.idd03 = l_rvv.rvv33
                LET l_idd.idd04 = l_rvv.rvv34
             #CHI-C80009---add-----END
                CALL icd_idb(l_idd.*,l_plant_new)    
             END FOREACH
          END IF
          LET l_sql2 = "SELECT rvviicd02,rvviicd05 FROM ",cl_get_target_table(l_plant_new,'rvvi_file'),
                       " WHERE rvvi01 = '",l_rvv.rvv01,"'",
                       "   AND rvvi02 = '",l_rvv.rvv02,"'"
          CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
          CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2
          PREPARE l_rvvi_p FROM l_sql2
          EXECUTE l_rvvi_p INTO l_rvviicd02,l_rvviicd05

          CALL s_icdpost(12,l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,l_rvv.rvv35,l_rvv.rvv17,l_rvv.rvv01,   
                         l_rvv.rvv02,l_rvu.rvu03,'Y',l_rvv.rvv04,l_rvv.rvv05,l_rvviicd05,l_rvviicd02,l_plant_new)
               RETURNING l_flag
          IF l_flag = 0 THEN
             LET g_success = 'N'
          END IF
       END IF
       #FUN-B90012----add----end----
       #CHI-C80042 add start -----
       #回寫最近出庫日 ima74
       LET l_sql = "SELECT ima29 FROM ",cl_get_target_table(l_plant_new,'ima_file'),
                    " WHERE ima01='",l_rvv.rvv31,"'"
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql
       CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql
       PREPARE ima_p1 FROM l_sql
       IF SQLCA.SQLCODE THEN
         IF g_bgerr THEN
            CALL s_errmsg("ima01",l_rvv.rvv31,"",SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("","","","",SQLCA.sqlcode,"","",1)
         END IF
       END IF
       DECLARE ima_c1 CURSOR FOR ima_p1
       OPEN ima_c1
       FETCH ima_c1 INTO l_ima29
       #異動日期需大於原來的異動日期才可
       #必須判斷null,否則新料不會update
       IF (l_rvu.rvu03 > l_ima29 OR l_ima29 IS NULL)  THEN
          LET l_sql = "UPDATE ",cl_get_target_table(l_plant_new,'ima_file'),
                      " SET ima74 = ? , ima29 = ? WHERE ima01 = ?  "
          CALL cl_replace_sqldb(l_sql) RETURNING l_sql
          CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql
          PREPARE upd_ima1 FROM l_sql
          EXECUTE upd_ima1 USING l_rvu.rvu03,l_rvu.rvu03,l_rvv.rvv31
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
             IF g_bgerr THEN
                CALL s_errmsg('ima01',l_rvv.rvv31,'upd ima',STATUS,1)
             ELSE
                CALL cl_err('upd ima:',STATUS,1)
             END IF
             LET g_success='N'
          END IF
       END IF
       #CHI-C80042 add end  -----
END FUNCTION
 
FUNCTION p840_log(p_part,p_ware,p_loca,p_lot,p_qty,p_sta)
  DEFINE p_part      LIKE ima_file.ima01,       #料號
         p_ware      LIKE ogb_file.ogb09,       #倉
         p_loca      LIKE ogb_file.ogb091,      #儲
         p_lot       LIKE ogb_file.ogb092,      #批
         p_qty       LIKE ogb_file.ogb12 ,      #異動數量
         l_img       RECORD LIKE img_file.*,
         l_imgg      RECORD LIKE imgg_file.*,   #FUN-560043
         p_sta       LIKE type_file.chr1,     #No.FUN-680136 VARCHAR(01),                  #4.倉退單 5.銷退單
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
         p_unit      LIKE ima_file.ima25,  #No.FUN-620025
         p_unit2     LIKE ima_file.ima25,  #No.FUN-620025
         l_sql1      LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(600)
         l_sql2      LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(1600)
         l_msg       LIKE type_file.chr1000,  #No.FUN-680136 VARCHAR(50)
         l_chr       LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
         l_n         LIKE type_file.num5,    #No.FUN-680136 SMALLINT
         l_sql3      LIKE type_file.chr1000,  #FUN-560043  #No.FUN-680136 VARCHAR(600)
         l_sql4      LIKE type_file.chr1000, #FUN-560043  #No.FUN-680136 VARCHAR(1600)
         l_sql5      LIKE type_file.chr1000, #FUN-560043  #No.FUN-680136 VARCHAR(1600)
         l_n2        LIKE type_file.num5,      #FUN-560043  #No.FUN-680136 SMALLINT
         l_k,l_l     LIKE type_file.num5,    #NO.FUN-680136 SMALLINT    #FUN-560043
         l_imgg10    LIKE imgg_file.imgg10,   #FUN-560043
         l_sw        LIKE type_file.num5,    #NO.FUN-680136 SMALLINT            #No.TQC-660122
         l_azp03     LIKE azp_file.azp03, #No.TQC-660122
         l_azp01     LIKE azp_file.azp01, #No.FUN-980059
         p_plant     LIKE type_file.chr21    #NO.FUN-680136 VARCHAR(21)             #FUN-670007
  DEFINE l_plant    LIKE azp_file.azp01    #FUN-980006 add
  DEFINE l_legal    LIKE azw_file.azw02    #FUN-980006 add
  DEFINE l_ccz28    LIKE ccz_file.ccz28  #MOD-CC0289 add
 
  LET l_plant = g_poy.poy04  #FUN-980006 add 
  CALL s_getlegal(l_plant) RETURNING l_legal  #FUN-980006 add 
 
  IF p_part[1,4]='MISC' THEN RETURN END IF  #No.8743
  IF p_loca IS NULL THEN LET p_loca=' ' END IF
  IF p_lot  IS NULL THEN LET p_lot =' ' END IF
 
  CALL p840_ima(p_part) RETURNING l_ima02,l_ima25,l_qoh,l_ima86,l_ima39,
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
           CALL s_errmsg("","","img_pre",STATUS,1)
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
        LET l_img.img05 = g_rvv.rvv01
        LET l_img.img06 = g_rvv.rvv02
        LET l_img.img09 = l_ima25
        LET l_img.img10 = 0
        LET l_img.img13 = null      #No.7304
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
        #LET l_sql2="INSERT INTO ",l_dbs_tra CLIPPED,"img_file",  #FUN-980092
        LET l_sql2="INSERT INTO ",cl_get_target_table(l_plant_new,'img_file'), #FUN-A50102
          "(img01,img02,img03,img04,img05,img06,",
          " img09,img10,img13,img17,img18,", 
          " img20,img21,img22,img23,img24,", 
          " img25,img27,img28,imgplant,imglegal)",   #TQC-690057 add img27,img28 #FUN-980006 add imgplant,imglegal
          " VALUES( ?,?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?, ?,?)"  #TQC-690057 #FUN-980006 add ?,?
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
                 CALL s_errmsg("","","ins img:",SQLCA.sqlcode,1)
              ELSE
                 CALL cl_err3("","","","",SQLCA.sqlcode,"","ins img:",1)
              END IF
              LET g_success = 'N'
           END IF
  END IF   
 
  IF g_sma.sma115 = 'Y' THEN  #No.CHI-760003 
  IF g_ima906 = '2' THEN    #No.FUN-620025
  FOR l_k = 1 TO 2
  LET l_sql3 = "SELECT COUNT(*) ",
               #" FROM ",l_dbs_tra CLIPPED,"imgg_file ",  #FUN-980092
               " FROM ",cl_get_target_table(l_plant_new,'imgg_file'), #FUN-A50102
               " WHERE imgg01='",p_part,"' ",
               "   AND imgg02='",p_ware,"'",
               "   AND imgg03='",p_loca,"'",
               "   AND imgg04='",p_lot,"'"
  IF l_k = 1 THEN
     LET l_sql3 = l_sql3,"   AND imgg09='",g_rvv.rvv80,"'"
  ELSE
     LET l_sql3 = l_sql3,"   AND imgg09='",g_rvv.rvv83,"'"
  END IF
  CALL cl_replace_sqldb(l_sql3) RETURNING l_sql3        #FUN-920032
  CALL cl_parse_qry_sql(l_sql3,l_plant_new) RETURNING l_sql3 #FUN-980092
  PREPARE imgg_pre1 FROM l_sql3
  IF STATUS THEN
      IF g_bgerr THEN
         CALL s_errmsg("","","imgg_pre",SQLCA.sqlcode,1)
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
        LET l_imgg.imgg05 = g_rvv.rvv01
        LET l_imgg.imgg06 = g_rvv.rvv02
        IF l_k = 1 THEN
           LET l_imgg.imgg09 = g_rvv.rvv80
        ELSE
           LET l_imgg.imgg09 = g_rvv.rvv83
        END IF
        LET l_imgg.imgg10 = 0
        LET l_imgg.imgg17 = g_today
        LET l_imgg.imgg18 = g_lastdat
        LET l_azp03 = s_madd_img_catstr(l_azp.azp03)
        CALL s_umfchk1(l_imgg.imgg01,l_imgg.imgg09,l_ima25,l_plant_new)  #FUN-980092 
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
        CALL s_umfchk1(l_imgg.imgg01,l_imgg.imgg09,l_img.img09,l_plant_new)  #FUN-980092 
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
        #LET l_sql4="INSERT INTO ",l_dbs_tra CLIPPED,"imgg_file",  #FUN-980092
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
              CALL s_errmsg("","","ins imgg:",SQLCA.sqlcode,1)
           ELSE
              CALL cl_err3("","","","",SQLCA.sqlcode,"","ins imgg:",1)
           END IF
              LET g_success = 'N'
           END IF
  END IF 
  END FOR
  END IF
  IF g_ima906 = '3' THEN
     LET l_sql3 = "SELECT COUNT(*) ",
               #" FROM ",l_dbs_tra CLIPPED,"imgg_file ",   #FUN-980092
               " FROM ",cl_get_target_table(l_plant_new,'imgg_file'), #FUN-A50102
               " WHERE imgg01='",p_part,"' ",
               "   AND imgg02='",p_ware,"'",
               "   AND imgg03='",p_loca,"'",
               "   AND imgg04='",p_lot,"'"
     LET l_sql3 = l_sql3,"   AND imgg09='",g_rvv.rvv83,"'"
  
 	 CALL cl_replace_sqldb(l_sql3) RETURNING l_sql3        #FUN-920032
     CALL cl_parse_qry_sql(l_sql3,l_plant_new) RETURNING l_sql3 #FUN-980092
     PREPARE imgg_pre2 FROM l_sql3
     IF STATUS THEN
        IF g_bgerr THEN
           CALL s_errmsg("","","imgg_pre",STATUS,1)
        ELSE
           CALL cl_err3("","","","",STATUS,"","imgg_pre",1)
        END IF
     END IF
     DECLARE imgg_cs2 CURSOR FOR imgg_pre2
     OPEN imgg_cs2
     FETCH imgg_cs2 INTO l_n2
     IF l_n2 = 0 THEN
        CALL cl_getmsg('axm-995',g_lang) RETURNING l_msg
        LET l_msg ="(",l_dbs_tra CLIPPED,"-",p_part CLIPPED,'-',p_ware CLIPPED,")",
                    l_msg CLIPPED
        LET INT_FLAG = 0  ######add for prompt bug
     PROMPT l_msg FOR CHAR l_chr
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
     ON ACTION about         
        CALL cl_about()      
 
     ON ACTION help          
        CALL cl_show_help()  
 
     ON ACTION controlg      
        CALL cl_cmdask()     
      
     END PROMPT
     IF l_chr MATCHES '[Nn]' THEN LET g_success = 'N' RETURN END IF 
     IF l_chr MATCHES '[Yy]' THEN
        LET l_imgg.imgg01 = p_part
        LET l_imgg.imgg02 = p_ware
        LET l_imgg.imgg03 = p_loca
        LET l_imgg.imgg04 = p_lot
        LET l_imgg.imgg05 = g_rvv.rvv01
        LET l_imgg.imgg06 = g_rvv.rvv02
        LET l_imgg.imgg09 = g_rvv.rvv83
        LET l_imgg.imgg10 = 0
        LET l_imgg.imgg17 = g_today
        LET l_imgg.imgg18 = g_lastdat
        CALL s_umfchk1(l_imgg.imgg01,l_imgg.imgg09,l_ima25,l_plant_new)  #FUN-980092 
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
        CALL s_umfchk1(l_imgg.imgg01,l_imgg.imgg09,l_img.img09,l_plant_new)  #FUN-980092 
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
        #LET l_sql4="INSERT INTO ",l_dbs_tra CLIPPED,"imgg_file",  #FUN-980020
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
        PREPARE ins_imgg2 FROM l_sql4
        EXECUTE ins_imgg2 
           IF SQLCA.sqlcode<>0 THEN
              IF g_bgerr THEN
                 CALL s_errmsg("","","ins imgg:",SQLCA.sqlcode,1)
              ELSE
                 CALL cl_err3("","","","",SQLCA.sqlcode,"","ins imgg:",1)
              END IF
              LET g_success = 'N'
           END IF
     END IF
  END IF
  END IF
  END IF #No.CHI-760003  
   #----來源----
   LET g_tlf.tlf01=p_part              #異動料件編號
   IF p_sta = '4' THEN
      LET g_tlf.tlf02=50               #'Stock'
      LET g_tlf.tlf021=p_ware          #倉庫
      LET g_tlf.tlf022=p_loca          #儲位
      LET g_tlf.tlf020=l_azp.azp01
      LET g_tlf.tlf023=p_lot           #批號
      IF cl_null(g_tlf.tlf023) THEN LET g_tlf.tlf023=' ' END IF
      LET g_tlf.tlf024=''              #異動後數量
      LET g_tlf.tlf025=l_ima25         #庫存單位(ima_file or img_file)
   ELSE 
     IF p_sta = '1' THEN    
        LET g_tlf.tlf02  = 50
        LET g_tlf.tlf020 = l_ogb.ogb08
        LET g_tlf.tlf021 = p_ware
        LET g_tlf.tlf022 = p_loca
        LET g_tlf.tlf023 = p_lot
        LET g_tlf.tlf024 = 0  
        LET g_tlf.tlf025 = l_ima25
     ELSE
        LET g_tlf.tlf02=731
        LET g_tlf.tlf021=' '
        LET g_tlf.tlf022=' '
        LET g_tlf.tlf023=' '
        LET g_tlf.tlf024=' '
        LET g_tlf.tlf025=' '
     END IF  
   END IF
   CASE p_sta
     WHEN '4' #倉退
          LET g_tlf.tlf026=l_rvv.rvv01        #異動單號
          LET g_tlf.tlf027=l_rvv.rvv02        #異動項次
     WHEN '5' #銷退
          LET g_tlf.tlf026=l_ohb.ohb01        #異動單號
          LET g_tlf.tlf027=l_ohb.ohb03        #異動項次 
     WHEN '1' #代送
          LET g_tlf.tlf026=l_oga.oga01      #異動單號
          LET g_tlf.tlf027=l_ogb.ogb03      #異動項次 
   END CASE
   #---目的----
   IF p_sta = '5' THEN
      LET g_tlf.tlf03=50
      LET g_tlf.tlf035=l_ima25
      LET g_tlf.tlf031=p_ware
      LET g_tlf.tlf032=p_loca
      LET g_tlf.tlf033=p_lot
      IF cl_null(g_tlf.tlf033) THEN LET g_tlf.tlf033=' ' END IF
      LET g_tlf.tlf034=''
   ELSE 
     IF p_sta = '1' THEN    #代送
        LET g_tlf.tlf03  = 724 
        LET g_tlf.tlf030 = ' '
        LET g_tlf.tlf031 = ''
        LET g_tlf.tlf032 = ''
        LET g_tlf.tlf033 = ''
        LET g_tlf.tlf034 = ''
        LET g_tlf.tlf035 = ''                #
     ELSE 
        LET g_tlf.tlf03=31  
        LET g_tlf.tlf030=' '
        LET g_tlf.tlf031=' '            #倉庫
        LET g_tlf.tlf032=' '            #儲位
        LET g_tlf.tlf033=' '            #批號
        LET g_tlf.tlf034=' '            #異動後庫存數量
        LET g_tlf.tlf035=' '            #庫存單位(ima_file or img_file)
     END IF
   END IF
   CASE p_sta
     WHEN '4' #倉退
          LET g_tlf.tlf036=l_rvv.rvv04        #異動單號 no.6178
          LET g_tlf.tlf037=l_rvv.rvv05        #異動項次 no.6178
     WHEN '5' #銷退
          LET g_tlf.tlf036=l_ohb.ohb01        #異動單號
          LET g_tlf.tlf037=l_ohb.ohb03        #異動項次 
     WHEN '1' #代送
          LET g_tlf.tlf036=g_tlf.tlf026       #異動單號
          LET g_tlf.tlf037=g_tlf.tlf027       #異動項次
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
   LET g_tlf.tlf12=g_rvv.rvv35_fac
   CASE p_sta
        WHEN '4' LET g_tlf.tlf13='apmt1072'
        WHEN '5' LET g_tlf.tlf13='aomt800'
        WHEN '1' LET g_tlf.tlf13='axmt620'   #No.FUN-620025
   END CASE
   LET g_tlf.tlf14=' '              #異動原因
 
   LET g_tlf.tlf17=' '              #非庫存性料件編號
   LET g_tlf.tlf18=l_qoh
   CASE p_sta
        WHEN '4'                                                                
          IF NOT cl_null(l_rvu.rvu04) THEN                                      
             LET g_tlf.tlf19 = l_rvu.rvu04                                      
          ELSE                                                                  
             LET g_tlf.tlf19=p_pmm09                                            
          END IF                                                                
        WHEN '5' LET g_tlf.tlf19=l_oha.oha04   #no.6178  #No.MOD-940067 add
        WHEN '1' LET g_tlf.tlf19=l_oga.oga03   #No.FUN-620025
   END CASE
   LET g_tlf.tlf20= ' '     
   LET g_tlf.tlf60=g_rvv.rvv35_fac
   LET g_tlf.tlf62=l_rvv.rvv01    #參考單號(入庫)   
   LET g_tlf.tlf63=l_rvv.rvv02    #入庫項次
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
   LET g_tlf.tlf99 = g_flow99  #No.8128
   IF g_tlf.tlf902 IS NULL THEN LET g_tlf.tlf902 = ' ' END IF
   IF g_tlf.tlf903 IS NULL THEN LET g_tlf.tlf903 = ' ' END IF
   IF g_tlf.tlf904 IS NULL THEN LET g_tlf.tlf904 = ' ' END IF
   LET g_tlf.tlf61=s_get_doc_no(g_tlf.tlf905)   #FUN-560043
   CASE p_sta
        WHEN '4' 
          LET g_tlf.tlf930 = l_rvv.rvv930 
        WHEN '5' 
          LET g_tlf.tlf930 = l_ohb.ohb930 
        WHEN '1' 
          LET g_tlf.tlf930 = l_ogb.ogb930   
   END CASE
 
   IF (g_tlf.tlf02=50 OR g_tlf.tlf03=50) THEN
      IF NOT s_tlfidle(l_plant_new,g_tlf.*) THEN        #FUN-980092
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
       IF cl_null(g_tlf.tlf14) THEN     #TQC-D20067  mark  #TQC-D40064 remark
          #CALL s_reason_code(g_tlf.tlf036,g_tlf.tlf026,'',g_tlf.tlf01,g_tlf.tlf031,'','') RETURNING g_tlf.tlf14              #TQC-D20050
          CALL s_reason_code1(g_tlf.tlf036,g_tlf.tlf026,'',g_tlf.tlf01,g_tlf.tlf031,'','',l_plant_new) RETURNING g_tlf.tlf14  #TQC-D20050
          IF cl_null(g_tlf.tlf14) THEN
             CALL cl_err(g_tlf.tlf14,'aim-425',1)
             LET g_success="N"
             RETURN
          END IF
       END IF  #TQC-D20067  mark  #TQC-D40064 remark
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

    #LET l_sql2="INSERT INTO ",l_dbs_tra CLIPPED,"tlf_file",  #FUN-980092
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
      " tlf907,tlf930,tlfplant,tlflegal,tlfcost,tlf920)", #MOD-CC0289 add tlfcost    #CHI-9B0008 #FUN-CC0157 add tlf920
      " VALUES( ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
      "         ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
      "         ?,?,?,?,?, ?,?,?,?,?,? ) "    #FUN-980006 add ?,?  #CHI-9B0008 #MOD-CC0289 add tlfcost #FUN-CC0157 
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
       g_tlf.tlf907,g_tlf.tlf930,l_plant,l_legal,g_tlf.tlfcost,g_tlf.tlf920  #FUN-980006 add l_plant,l_legal  #CHI-9B0008 #FUN-CC0157 
    IF SQLCA.sqlcode<>0 THEN #MOD-CC0289 add tlfcost
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
   LET g_tlff.tlff01=p_part              #異動料件編號
   IF p_sta = '4' THEN
      LET g_tlff.tlff02=50               #'Stock'
      LET g_tlff.tlff021=p_ware          #倉庫
      LET g_tlff.tlff022=p_loca          #儲位
      LET g_tlff.tlff020=l_azp.azp01
      LET g_tlff.tlff023=p_lot           #批號
      IF cl_null(g_tlff.tlff023) THEN LET g_tlff.tlff023=' ' END IF
      LET g_tlff.tlff024=''              #異動後數量
      IF l_l = 1 THEN
         LET g_tlff.tlff025=g_rvv.rvv80  #庫存單位       
         LET g_tlff.tlff219 = 2             #No.FUN-620025
         LET g_tlff.tlff220 = g_rvv.rvv80   #No.FUN-620025
      ELSE 
         LET g_tlff.tlff025=g_rvv.rvv83  #庫存單位       
         LET g_tlff.tlff219 = 1             #No.FUN-620025
         LET g_tlff.tlff220 = g_rvv.rvv83   #No.FUN-620025
      END IF
   ELSE
     IF p_sta = '1' THEN
        LET g_tlff.tlff02  = 50            #'Stock'
        LET g_tlff.tlff021 = p_ware        #倉庫
        LET g_tlff.tlff022 = p_loca        #儲位
        LET g_tlff.tlff023 = p_lot         #批號
        LET g_tlff.tlff020 = l_ogb.ogb08   #
        LET g_tlff.tlff024 = ''            #異動後數量
        IF l_l = 1 THEN 
           LET g_tlff.tlff025=l_ogb.ogb910 #庫存單位(ima_file or img_file)
           LET g_tlff.tlff219 = 2             #No.FUN-620025
           LET g_tlff.tlff220 = l_ogb.ogb910  #No.FUN-620025
        ELSE
           LET g_tlff.tlff025=l_ogb.ogb913
           LET g_tlff.tlff219 = 1             #No.FUN-620025
           LET g_tlff.tlff220 = l_ogb.ogb913  #No.FUN-620025
        END IF
     ELSE
        LET g_tlff.tlff02=731
        LET g_tlff.tlff021=' '
        LET g_tlff.tlff022=' '
        LET g_tlff.tlff023=' '
        LET g_tlff.tlff024=' '
        LET g_tlff.tlff025=' '
        IF l_l = 1 THEN   #0025  by day
           LET g_tlff.tlff219 = 2             
           LET g_tlff.tlff220 = l_ohb.ohb910  
        ELSE 
           LET g_tlff.tlff219 = 1             
           LET g_tlff.tlff220 = l_ohb.ohb913  
        END IF
     END IF
   END IF
   CASE p_sta
     WHEN '4' #倉退
          LET g_tlff.tlff026=l_rvv.rvv01        #異動單號
          LET g_tlff.tlff027=l_rvv.rvv02        #異動項次
     WHEN '5' #銷退
          LET g_tlff.tlff026=l_ohb.ohb01        #異動單號
          LET g_tlff.tlff027=l_ohb.ohb03        #異動項次 
     WHEN '1' #代送
          LET g_tlff.tlff026=l_oga.oga01         #異動單號
          LET g_tlff.tlff027=l_ogb.ogb03         #異動項次
   END CASE
   #---目的----
   IF p_sta = '5' THEN
      LET g_tlff.tlff03=50
      LET g_tlff.tlff035=l_ima25
      LET g_tlff.tlff031=p_ware
      LET g_tlff.tlff032=p_loca
      LET g_tlff.tlff033=p_lot
      IF cl_null(g_tlff.tlff033) THEN LET g_tlff.tlff033=' ' END IF
      LET g_tlff.tlff034=''
   ELSE  
     IF p_sta = '1' THEN
        LET g_tlff.tlff03  = 724 
        LET g_tlff.tlff030 = ''
        LET g_tlff.tlff031 = ''
        LET g_tlff.tlff032 = ''
        LET g_tlff.tlff033 = ''
        LET g_tlff.tlff034 = ''
        LET g_tlff.tlff035 = ''       
     ELSE
        LET g_tlff.tlff03=31  
        LET g_tlff.tlff030=' '
        LET g_tlff.tlff031=' '            #倉庫
        LET g_tlff.tlff032=' '            #儲位
        LET g_tlff.tlff033=' '            #批號
        LET g_tlff.tlff034=' '            #異動後庫存數量
        LET g_tlff.tlff035=' '            #庫存單位
     END IF
   END IF
   CASE p_sta
     WHEN '4' #倉退
          LET g_tlff.tlff036=l_rvv.rvv04        #異動單號 
          LET g_tlff.tlff037=l_rvv.rvv05        #異動項次 
     WHEN '5' #銷退
          LET g_tlff.tlff036=l_ohb.ohb01        #異動單號
          LET g_tlff.tlff037=l_ohb.ohb03        #異動項次 
     WHEN '1' 
          LET g_tlff.tlff036=g_tlff.tlff026     #異動單號
          LET g_tlff.tlff037=g_tlff.tlff027     #異動項次
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
      LET g_tlff.tlff12=g_rvv.rvv81
   ELSE
      LET g_tlff.tlff10=g_rvv.rvv85         
      LET g_tlff.tlff11=g_rvv.rvv83    
      LET g_tlff.tlff12=g_rvv.rvv84
   END IF
   IF l_l = 1 THEN
      LET p_unit = g_tlff.tlff11
   ELSE
      LET p_unit2 = g_tlff.tlff11
   END IF 
   CASE p_sta
        WHEN '4' LET g_tlff.tlff13='apmt1072'
        WHEN '5' LET g_tlff.tlff13='aomt800'
        WHEN '1' LET g_tlff.tlff13='axmt620'   #No.FUN-620025
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
        WHEN '4' 
           IF l_l = 1 THEN
              LET l_imgg10 = l_imgg10 - g_rvv.rvv82
           ELSE 
              LET l_imgg10 = l_imgg10 - g_rvv.rvv85
           END IF
        WHEN '5' 
           IF l_l = 1 THEN
              LET l_imgg10 = l_imgg10 + g_rvv.rvv82
           ELSE 
              LET l_imgg10 = l_imgg10 + g_rvv.rvv85
           END IF
        WHEN '1'
           IF l_l = 1 THEN 
              LET l_imgg10 = l_imgg10 - l_ogb.ogb912      
           ELSE
              LET l_imgg10 = l_imgg10 - l_ogb.ogb915      
           END IF
   END CASE 
   LET g_tlff.tlff18=l_imgg10
   CASE p_sta
        WHEN '4' LET g_tlff.tlff19=p_pmm09       
        WHEN '5' LET g_tlff.tlff19=g_poz.poz04 
        WHEN '1' LET g_tlff.tlff19=l_oga.oga04  #No.FUN-620025
   END CASE
   LET g_tlff.tlff20= ' '     
   IF l_l = 1 THEN
      LET g_tlff.tlff60=g_rvv.rvv81
   ELSE
      LET g_tlff.tlff60=g_rvv.rvv84
   END IF
   LET g_tlff.tlff62=l_rvv.rvv01    #參考單號(入庫)   
   LET g_tlff.tlff63=l_rvv.rvv02    #入庫項次
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
              LET g_tlff.tlff902=' '
              LET g_tlff.tlff903=' '
              LET g_tlff.tlff904=' '
              LET g_tlff.tlff905=' '
              LET g_tlff.tlff906=' '
              LET g_tlff.tlff907=0
   END CASE
   LET g_tlff.tlff99 = g_flow99  
   IF g_tlff.tlff902 IS NULL THEN LET g_tlff.tlff902 = ' ' END IF
   IF g_tlff.tlff903 IS NULL THEN LET g_tlff.tlff903 = ' ' END IF
   IF g_tlff.tlff904 IS NULL THEN LET g_tlff.tlff904 = ' ' END IF
   LET g_tlff.tlff61=s_get_doc_no(g_tlff.tlff905)
   CASE p_sta
        WHEN '4' 
          LET g_tlff.tlff930 = l_rvv.rvv930 
        WHEN '5' 
          LET g_tlff.tlff930 = l_ohb.ohb930 
        WHEN '1' 
          LET g_tlff.tlff930 = l_ogb.ogb930   
   END CASE
 
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
      " tlff60,tlff61,tlff62,tlff63,tlff99, ",
      " tlff902,tlff903,tlff904,tlff905,tlff906,",
      " tlff907,tlff219,tlff220,tlff930,tlffplant,",    #No.FUN-620025 #FUN-980006 add tlffplant  #CHI-9B0008   
      " tlfflegal,tlff012,tlff013)",                    #FUN-980006 add tlfflegal  #FUN-B90012 add tlff012,tlff013 
      " VALUES( ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
      "         ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
      "         ?,?,?,?,?, ?,?,?,?,?, ?,?,?) "          #No.FUN-620025 #FUN-980006 add ?,?  #CHI-9B0008  #FUN-B90012 add ?,?
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
       g_tlff.tlff60,g_tlff.tlff61,g_tlff.tlff62,g_tlff.tlff63,g_tlff.tlff99,
       g_tlff.tlff902,g_tlff.tlff903,g_tlff.tlff904,g_tlff.tlff905,g_tlff.tlff906,
       g_tlff.tlff907,g_tlff.tlff219,g_tlff.tlff220,g_tlff.tlff930,l_plant,         #No.FUN-620025 #FUN-980006 add l_plant   #CHI-9B0008
       l_legal,g_tlff.tlff012,g_tlff.tlff013                                        #FUN-980006 add l_legal   #FUN-B90012   add tlff012,tlff013
       IF SQLCA.sqlcode<>0 THEN
          IF g_bgerr THEN
             CALL s_errmsg("","","ins tlff:",SQLCA.sqlcode,1)
          ELSE
             CALL cl_err3("","","","",SQLCA.sqlcode,"","ins tlff:",1)
          END IF
          LET g_success = 'N'
       END IF
  END FOR
  CALL s_tlff3(p_unit,p_unit2,l_plant_new) #FUN-980092 
  END IF
  END IF #No.CHI-760003   
END FUNCTION
 
FUNCTION p840_ima(p_part)
 DEFINE p_part  LIKE ima_file.ima01
 DEFINE l_ima02 LIKE ima_file.ima02
 DEFINE l_ima25 LIKE ima_file.ima25
# DEFINE l_qoh   LIKE ima_file.ima262 #FUN-A20044
 DEFINE l_qoh,l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk   LIKE type_file.num15_3  #FUN-A20044
 DEFINE l_ima86 LIKE ima_file.ima86
 DEFINE l_ima39 LIKE ima_file.ima39
 DEFINE l_ima35 LIKE ima_file.ima35
 DEFINE l_ima36 LIKE ima_file.ima36
 DEFINE l_sql1  LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(600)
 DEFINE p_plant LIKE type_file.chr21    #No.FUN-680136 VARCHAR(21)             #FUN-670007
 
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
           CALL s_errmsg("","","ima_pre",STATUS,1)
        ELSE
           CALL cl_err3("","","","",STATUS,"","ima_pre",1)
        END IF
     END IF
     DECLARE ima_cs CURSOR FOR ima_pre
     OPEN ima_cs
     FETCH ima_cs INTO l_ima02,l_ima25,l_qoh,l_ima86,l_ima39,l_ima35,l_ima36 
        CALL s_getstock(p_part,g_plant)RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk #FUN-A20044
           LET l_qoh = l_unavl_stk + l_avl_stk #FUN-A20044
     IF SQLCA.SQLCODE <> 0 THEN
        LET g_success='N'
     END IF
     CLOSE ima_cs
     RETURN l_ima02,l_ima25,l_qoh,l_ima86,l_ima39,l_ima35,l_ima36
END FUNCTION
 
#FUNCTION p840_imd(p_imd01,p_dbs)
FUNCTION p840_imd(p_imd01,p_dbs,l_plant)   #FUN-A50102
  DEFINE p_imd01   LIKE imd_file.imd01,
         l_imd11   LIKE imd_file.imd11,
         l_plant   LIKE type_file.chr21,     #FUN-A50102
         p_dbs     LIKE type_file.chr21,  #No.FUN-680136 VARCHAR(21)
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
         CALL s_errmsg("","",p_dbs,g_errno,1)
      ELSE
         CALL cl_err3("","","","",g_errno,"",p_dbs,1)
      END IF
   END IF
   CLOSE imd_cs
END FUNCTION
 
#No.8128 取得多角序號
FUNCTION p840_flow99()
     DEFINE  l_sql   STRING   #FUN-AA0023
     
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
        #FUN-AA0023--modify--str--
        #UPDATE rvu_file SET rvu99 = g_flow99 WHERE rvu01 = g_rvu.rvu01
        LET l_sql = "UPDATE ",cl_get_target_table(p_plant,'rvu_file'),
                    "   SET rvu99 = '",g_flow99,"'",
                    " WHERE rvu01 = '",g_rvu.rvu01,"'"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
        PREPARE pre_uprvu99 FROM l_sql
        EXECUTE pre_uprvu99
        #FUN-AA0023--modify--end--
        IF SQLCA.SQLCODE THEN
        IF g_bgerr THEN
           CALL s_errmsg("rvu01",g_rvu.rvu01,"upd rvu99",SQLCA.sqlcode,1)
        ELSE
           CALL cl_err3("upd","rvu_file",g_rvu.rvu01,"",SQLCA.sqlcode,"","upd rvu99",1)
        END IF
           LET g_success = 'N' RETURN
        END IF
        #馬上檢查是否有搶號
        LET g_cnt = 0 
        #FUN-AA0023--modify--str--
        #SELECT COUNT(*) INTO g_cnt FROM rvu_file 
        # WHERE rvu99 = g_flow99 AND rvu00 = '3'
        LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(p_plant,'rvu_file'),
                    " WHERE rvu99 = '",g_flow99,"'",
                    "   AND rvu00 = '3' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
        PREPARE pre_selrvu99 FROM l_sql
        EXECUTE pre_selrvu99 INTO g_cnt
        #FUN-AA0023--modify--end--
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
 
#因為各單據的xxx99欄位在資料庫非Unique,
#所以為了安全還是給它檢查一下
FUNCTION p840_chk99()
  DEFINE l_sql LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(500)
 
     LET g_cnt = 0 
 
     #LET l_sql = " SELECT COUNT(*) FROM ",l_dbs_tra CLIPPED,"rvu_file ",  #FUN-980092
     LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new,'rvu_file'), #FUN-A50102
                 "  WHERE rvu99 ='",g_flow99,"'",
                 "    AND rvu00 = '3' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
     PREPARE rvucnt_pre FROM l_sql
     DECLARE rvucnt_cs CURSOR FOR rvucnt_pre
     OPEN rvucnt_cs 
     FETCH rvucnt_cs INTO g_cnt                                #倉退單
     IF g_cnt > 0 THEN
        LET g_msg = l_dbs_tra CLIPPED,'rvu99 duplicate'
        IF g_bgerr THEN
           CALL s_errmsg("","",g_msg,"tri-011",1)
        ELSE
           CALL cl_err3("","","","","tri-011","",g_msg,1)
        END IF
        LET g_success = 'N'
     END IF
 
     #LET l_sql = " SELECT COUNT(*) FROM ",l_dbs_tra CLIPPED,"oha_file ", #FUN-980092
     LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new,'oha_file'), #FUN-A50102
                 "  WHERE oha99 ='",g_flow99,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
     PREPARE ohacnt_pre FROM l_sql
     DECLARE ohacnt_cs CURSOR FOR ohacnt_pre
     OPEN ohacnt_cs 
     FETCH ohacnt_cs INTO g_cnt                                #銷退單
     IF g_cnt > 0 THEN
        LET g_msg = l_dbs_tra CLIPPED,'oha99 duplicate'
        IF g_bgerr THEN
           CALL s_errmsg("","",g_msg,"tri-011",1)
        ELSE
           CALL cl_err3("","","","","tri-011","",g_msg,1)
        END IF
        LET g_success = 'N'
     END IF
END FUNCTION
#-----MOD-A90100---------
FUNCTION p840_imgs(p_ware,p_loca,p_lot,p_date,p_rvbs)
   DEFINE p_rvbs   RECORD LIKE rvbs_file.*
   DEFINE p_ware   LIKE imgs_file.imgs02
   DEFINE p_loca   LIKE imgs_file.imgs03
   DEFINE p_lot    LIKE imgs_file.imgs04
   DEFINE p_date   LIKE tlfs_file.tlfs111
   DEFINE l_imgs   RECORD LIKE imgs_file.*
   DEFINE l_tlfs   RECORD LIKE tlfs_file.*
   DEFINE l_ima25  LIKE ima_file.ima25
   DEFINE l_sql1   STRING 
   DEFINE l_sql2   STRING
   DEFINE l_n      LIKE type_file.num5
   DEFINE l_plant  LIKE azp_file.azp01    
   DEFINE l_legal  LIKE oga_file.ogalegal #

   LET l_plant = g_poy.poy04   
   CALL s_getlegal(l_plant) RETURNING l_legal  

   LET l_sql1 = "SELECT COUNT(*) ",
                "  FROM ",cl_get_target_table(l_plant_new,'imgs_file'),
                " WHERE imgs01='",p_rvbs.rvbs021,"' ",
                "   AND imgs02='",p_ware,"'",
                "   AND imgs03='",p_loca,"'",
                "   AND imgs04='",p_lot,"'",
                "   AND imgs05='",p_rvbs.rvbs03,"'",
                "   AND imgs06='",p_rvbs.rvbs04,"'",
                "   AND imgs11='",p_rvbs.rvbs08,"'"
   CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1	
   CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 
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
  
      LET l_sql2 = "INSERT INTO ",cl_get_target_table(l_plant_new,'imgs_file'),
                   "(imgs01,imgs02,imgs03,imgs04,imgs05,imgs06,",
                   " imgs07,imgs08,imgs09,imgs10,imgs11,imgsplant,imgslegal)",
                   " VALUES( ?,?,?,?,?,?, ?,?,?,?,?,?,?)"
  
      CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2	
      CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 
      PREPARE ins_imgs FROM l_sql2
  
      EXECUTE ins_imgs USING l_imgs.imgs01,l_imgs.imgs02,l_imgs.imgs03,
                             l_imgs.imgs04,l_imgs.imgs05,l_imgs.imgs06,
                             l_imgs.imgs07,l_imgs.imgs08,l_imgs.imgs09,
                             l_imgs.imgs10,l_imgs.imgs11,l_plant,
                             l_legal
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

   LET l_tlfs.tlfs01=p_rvbs.rvbs021        #異動料件編號
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
      WHEN "apmt742"    #倉退單
         LET l_tlfs.tlfs09=-1
      WHEN "axmt840"    #銷退單
         LET l_tlfs.tlfs09=1
   END CASE

   LET l_tlfs.tlfs10=p_rvbs.rvbs01
   LET l_tlfs.tlfs11=p_rvbs.rvbs02
   LET l_tlfs.tlfs111=p_date
   LET l_tlfs.tlfs12=g_today
   LET l_tlfs.tlfs13=p_rvbs.rvbs06
   LET l_tlfs.tlfs14=p_rvbs.rvbs07
   LET l_tlfs.tlfs15=p_rvbs.rvbs08

   LET l_sql2 = "INSERT INTO ",cl_get_target_table(l_plant_new,'tlfs_file'),
                "(tlfs01,tlfs02,tlfs03,tlfs04,tlfs05,tlfs06,tlfs07,",
                " tlfs08,tlfs09,tlfs10,tlfs11,tlfs12,tlfs13,tlfs14,",
                " tlfs15,tlfs111,tlfsplant,tlfslegal)",
                " VALUES( ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?)"

   CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2	
   CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 
   PREPARE ins_tlfs FROM l_sql2

   EXECUTE ins_tlfs USING l_tlfs.tlfs01,l_tlfs.tlfs02,l_tlfs.tlfs03,
                          l_tlfs.tlfs04,l_tlfs.tlfs05,l_tlfs.tlfs06,
                          l_tlfs.tlfs07,l_tlfs.tlfs08,l_tlfs.tlfs09,
                          l_tlfs.tlfs10,l_tlfs.tlfs11,l_tlfs.tlfs12,
                          l_tlfs.tlfs13,l_tlfs.tlfs14,l_tlfs.tlfs15,
                          l_tlfs.tlfs111,l_plant,l_legal

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
#-----END MOD-A90100-----
#No:FUN-9C0071--------精簡程式-----
