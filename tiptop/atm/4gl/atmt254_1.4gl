# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: atmt254
# Descriptions...: 三角貿易採購單拋轉作業(跨工廠)
# Date & Author..: 06/03/04 By ice
# Modify.........: No.FUN-620054 06/03/22 By Ray 增加更新至pmn_file和pmm_file中的欄位(pmm909,pmn24,pmn25)
# Modify.........: No.FUN-660104 06/06/20 By cl  Error Message  調整 
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換
# Modify.........: NO.FUN-670007 06/08/30 by Yiting s_mutislip多傳參數(流程序號及站別)
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6B0065 06/11/21 By Ray atmi217并入aooi313(azf09,10,11,12,13取代tqe03,04,05,11,08)
# Modify.........: No.FUN-710033 07/01/29 By dxfwo 增加修改單身批處理錯誤統整功能
# Modify.........: NO.MOD-740512 07/05/02 by Yiting 因5.x版流程代碼己全部從第0站起頭，此寫法不適用於新版
# Modify.........: NO.TQC-750235 07/05/30 by kim sql變數定義長度不夠
# Modify.........: NO.CHI-750035 07/06/05 BY yiting poz04目前己不使用
# Modify.........: No.TQC-790002 07/09/03 By Sarah Primary Key：複合key在INSERT INTO table前需增加判斷，如果是NULL就給值blank(字串型態) or 0(數值型態)
# Modify.........: No.MOD-810181 08/01/22 By ve007 s_defprice()增加一個參數 
# Modify.........: No.FUN-7B0018 08/02/29 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-830087 08/03/24 By ve007  s_defprice()增加一個參數 debeug
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.FUN-930148 09/03/26 By ve007 采購取價和定價
# Modify.........: No.TQC-940185 09/04/30 By sherry BUG修正  
# Modify.........: No.TQC-940184 09/05/12 By mike 跨庫的SQL語句一律使用s_dbstring()的寫法  
# Modify.........: No.TQC-930026 09/05/19 By xiaofeizhu s_defprice1()增加一個參數
# Modify.........: No.FUN-870007 09/07/23 By Zhangyajun 流通零售功能修改
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980059 09/09/09 By arman   GP5.2架構,修改SUB相關傳入參數
# Modify.........: No.FUN-980094 09/09/15 By TSD.hoho GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-980093 09/09/23 By TSD.sar2436 GP5.2 跨資料庫語法修改
# Modify.........: NO.CHI-9B0005 09/11/05 By liuxqa substr 修改。
# Modify.........: NO.MOD-9C0155 09/12/17 By lilingyu oeb1003賦初值
# Modify.........: No.FUN-A10036 10/01/13 By baofei 手動修改INSERT INTO xxx_file ，增加xxx_file xxxoriu, xxxorig這二個欄位
# Modify.........: No.FUN-9C0073 10/01/18 By chenls 程序精簡
# Modify.........: No.FUN-A50102 10/06/09 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.TQC-A60130 10/08/04 By lilingyu 取價函數改成s_defprice_new()
# Modify.........: No.FUN-AB0061 10/11/16 By vealxu 訂單、出貨單、銷退單加基礎單價字段(oeb37,ogb37,ohb37)
# Modify.........: No.FUN-B20060 11/04/07 By zhangll 增加oeb72赋值
# Modify.........: No:CHI-B70039 11/08/04 By joHung 金額 = 計價數量 x 單價
# Modify.......... No:CHI-C80060 12/08/27 By pauline 令oeb72預設值為null 
# Modify.........: No:FUN-C90050 12/10/25 By Lori 預設單別/預設POS上傳單別改以s_get_defslip取得

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_oea   RECORD LIKE oea_file.*         #訂單
DEFINE g_oeb   RECORD LIKE oeb_file.*
DEFINE g_pmm   RECORD LIKE pmm_file.*         #采購單
DEFINE g_pmn   RECORD LIKE pmn_file.*
DEFINE tm RECORD
          wc          LIKE type_file.chr1000,          #No.FUN-680120 VARCHAR(600)
          pmm905      LIKE pmm_file.pmm905
       END RECORD,
       g_poz   RECORD LIKE poz_file.*,        #流程代碼資料(單頭) No.8083
       g_poy   RECORD LIKE poy_file.*,        #流程代碼資料(單身) No.8083
       s_poy   RECORD LIKE poy_file.*,        #來源流程資料(單身) No.8083
       p_pmm09        LIKE pmm_file.pmm09,    #廠商代號
       p_oea03        LIKE oea_file.oea03,    #客戶代號
       p_poy04        LIKE poy_file.poy04,    #工廠編號
       p_poz03        LIKE poz_file.poz03,    #申報方式
       p_poy06        LIKE poy_file.poy06,    #付款條件
       p_poy07        LIKE poy_file.poy07,    #收款條件
       p_poy08        LIKE poy_file.poy08,    #SO稅別
       p_poy09        LIKE poy_file.poy09,    #PO稅別
       p_poy12        LIKE poy_file.poy12,    #發票別
       p_poy10        LIKE poy_file.poy10,    #銷售分類
       p_poy26        LIKE poy_file.poy26,    #是否計算業績
       p_poy27        LIKE poy_file.poy27,    #業績歸屬方
       p_poy28        LIKE poy_file.poy28,    #出貨理由碼
       p_poy29        LIKE poy_file.poy29,    #代送商編號
       p_poy33        LIKE poy_file.poy33,    #債權代碼
       g_pmm905       LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)              #是否已拋轉
       p_pox03        LIKE pox_file.pox03,    #計價基準
       p_pox05        LIKE pox_file.pox05,    #計價方式
       p_pox06        LIKE pox_file.pox06,    #計價比率
       p_azi01        LIKE azi_file.azi01,    #計價幣別
       p_azi01t       LIKE azi_file.azi01,    #計價幣別
       p_cnt          LIKE type_file.num5,             #No.FUN-680120 SMALLINT              #計價方式符合筆數
       g_flow99       LIKE oea_file.oea99,             #No.FUN-680120 VARCHAR(17)               #多角序號
       t_dbs          LIKE type_file.chr21,            #No.FUN-680120 VARCHAR(21)               #來源工廠
       l_dbs_new      LIKE type_file.chr21,            #No.FUN-680120 VARCHAR(21)    #New DataBase Name
       l_dbs_tra      LIKE type_file.chr21,            #FUN-980093 add
       l_plant_new    LIKE type_file.chr21,            #No.FUN-980059 VARCHAR(21)    #New DataBase Name
       l_dbname       LIKE type_file.chr21,            #No.FUN-870007
       l_aza   RECORD LIKE aza_file.*,        #New DataBase Global Parameter
       l_sma   RECORD LIKE sma_file.*,
       s_azp   RECORD LIKE azp_file.*,
       l_azp   RECORD LIKE azp_file.*,
       l_azi   RECORD LIKE azi_file.*,
       g_sw           LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
       p_last         LIKE type_file.num5,             #No.FUN-680120 SMALLINT             #流程之最後家數
       p_last_plant   LIKE apm_file.apm08,             #No.FUN-680120 VARCHAR(10)
       g_argv1        LIKE oea_file.oea01,
       p_row,p_col    LIKE type_file.num5,          #No.FUN-680120 SMALLINT
       g_cnt          LIKE type_file.num10,         #No.FUN-680120 INTEGER
       g_msg          LIKE type_file.chr1000,       #No.FUN-680120 VARCHAR(72)
       g_flag         LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
       g_t1           LIKE oay_file.oayslip         #No.FUN-680120 VARCHAR(05)
DEFINE g_first_plant  LIKE poy_file.poy02           #No.FUN-870007
 
FUNCTION t254_p1_s1(p_pmm01,p_plant) #FUN-980093 add
   DEFINE p_pmm01       LIKE pmm_file.pmm01,
          p_dbs         LIKE type_file.chr21            #No.FUN-680120 VARCHAR(21)
   DEFINE l_oea  RECORD LIKE oea_file.*
   DEFINE l_oeb  RECORD LIKE oeb_file.*
   DEFINE l_pmm  RECORD LIKE pmm_file.*
   DEFINE l_pmn  RECORD LIKE pmn_file.*
   DEFINE l_occ  RECORD LIKE occ_file.*
   DEFINE l_pmc  RECORD LIKE pmc_file.*
   DEFINE l_pox  RECORD LIKE pox_file.*
   DEFINE l_pow  RECORD LIKE pow_file.*
   DEFINE l_gec  RECORD LIKE gec_file.*
   DEFINE l_ima  RECORD LIKE ima_file.*
   DEFINE l_pmo  RECORD LIKE pmo_file.*
   DEFINE l_sql         STRING #TQC-750235
   DEFINE l_sql1        STRING #TQC-750235
   DEFINE l_sql2        STRING #TQC-750235
   DEFINE i,l_i         LIKE type_file.num5          #No.FUN-680120 SMALLINT
   DEFINE o_pox05       LIKE pox_file.pox05     #計價方式
   DEFINE diff_azi      LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)    #若為Y表示單身計價方式有所不同
          l_cnt         LIKE type_file.num5,             #No.FUN-680120 SMALLINT
          azi_pox05     LIKE pox_file.pox05,   #記錄單頭該用之計價方式
          min_oeb15     LIKE oeb_file.oeb15    #記錄該訂單之最小預交日
   DEFINE l_j           LIKE type_file.num5,          #No.FUN-680120 SMALLINT
          l_msg         LIKE ima_file.ima02           #No.FUN-680120 VARCHAR(60)
   DEFINE l_occ02       LIKE occ_file.occ02,
          l_occ08       LIKE occ_file.occ08,
          l_occ11       LIKE occ_file.occ11,
          l_occ43       LIKE occ_file.occ43,
          l_occ44       LIKE occ_file.occ44,
          l_occ45       LIKE occ_file.occ45,
          l_occ41       LIKE occ_file.occ41,     #No.FUN-870007
          l_azf10       LIKE azf_file.azf10,     #No.FUN-6B0065
          l_oea1013     LIKE oea_file.oea1013,
          l_oea1014     LIKE oea_file.oea1014,
          l_price       LIKE oeb_file.oeb13,
          l_no          LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
          l_no1         LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
          l_currm       LIKE pmm_file.pmm42,
          l_curr        LIKE pmm_file.pmm22              # Prog. Version..: '5.30.06-13.03.12(04) #TQC-840066
   DEFINE l_flag        LIKE type_file.chr1          #No.FUN-680120 VARCHAR(01)
   DEFINE l_x           LIKE poy_file.poy36          # Prog. Version..: '5.30.06-13.03.12(05)                #FUN-620025
   DEFINE l_oea_t1      LIKE poy_file.poy36          # Prog. Version..: '5.30.06-13.03.12(05)              #FUN-620025
   DEFINE l_pmm_t1      LIKE poy_file.poy36          # Prog. Version..: '5.30.06-13.03.12(05)              #FUN-620025
   DEFINE l_unit        LIKE pmn_file.pmn07          # Prog. Version..: '5.30.06-13.03.12(04)               #FUN-620025 #TQC-840066
   DEFINE li_result     LIKE type_file.num5          #FUN-620025    #No.FUN-680120 SMALLINT
   DEFINE l_stu_p       LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)            #FUN-620025-cl
   DEFINE l_stu_o       LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)            #FUN-620025-cl
   DEFINE l_pmni        RECORD LIKE pmni_file.*      #No.FUN-7B0018
   DEFINE l_oebi        RECORD LIKE oebi_file.*      #No.FUN-7B0018
   DEFINE p_dbs_tra       LIKE azw_file.azw05        #FUN-980093 add
   DEFINE p_plant_new     LIKE azp_file.azp01        #FUN-980093 add
   DEFINE p_plant         LIKE azp_file.azp01        #FUN-980093 add
   
   WHENEVER ERROR CONTINUE  #No.FUN-870007
   DELETE FROM t254_file
 
   #改抓Transaction DB
     #LET g_plant_new = p_plant   #FUN-A50102
     #CALL s_getdbs()             #FUN-A50102
     #LET p_dbs = g_dbs_new       #FUN-A50102
     #LET p_plant_new = g_plant_new
     #CALL s_gettrandbs()         #FUN-A50102
     #LET p_dbs_tra = g_dbs_tra   #FUN-A50102
 
   LET t_dbs = p_dbs
   #讀取符合條件之三角貿易採購單資料
   #LET l_sql= "SELECT * FROM ",p_dbs_tra CLIPPED,"pmm_file ",  #FUN-980093 add
   LET l_sql= "SELECT * FROM ",cl_get_target_table(p_plant,'pmm_file'), #FUN-A50102
              " WHERE pmm901= 'Y' ",
              "   AND pmm905= 'N' ",
              "   AND pmm18 = 'Y' ",     #已確認之採購單才可轉
              "   AND pmm25 = '2' ",     #已發出之採購單才可轉
              "   AND pmm902='N' ",      #非最終採購單
	            "   AND pmm906='Y' ",      #三角貿易來源採購單否
              "   AND pmm01 = '",p_pmm01,"' "
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980093
   PREPARE t254_p1_pre FROM l_sql
   IF SQLCA.sqlcode  THEN
      CALL cl_err('prepare',STATUS,0)
      LET g_success = 'N'
      RETURN
   END IF
   DECLARE t254_p1_curs1 CURSOR FOR t254_p1_pre
   IF SQLCA.sqlcode  THEN
      CALL cl_err('declare',STATUS,0)
      LET g_success = 'N'
      RETURN
   END IF
   FOREACH t254_p1_curs1 INTO g_pmm.*
         IF g_success='N' THEN  
            LET g_totsuccess='N'  
            LET g_success="Y"   
         END IF 
      IF SQLCA.sqlcode  THEN
         CALL cl_err('foreach',STATUS,0)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      #讀取三角貿易流程代碼資料
      CALL t254_poz(p_plant) #FUN-980093 add
      IF g_success = 'N' THEN
         CONTINUE FOREACH  #No.FUN-710033
      END IF
      IF g_azw.azw04='2' THEN
         SELECT * INTO g_poy.* FROM poy_file
          WHERE poy01 = g_pmm.pmm904 
            AND poy02 = (SELECT MIN(poy02)+1 FROM poy_file 
                          WHERE poy01 = g_pmm.pmm904)
      ELSE
         SELECT * INTO g_poy.* FROM poy_file
         WHERE poy01 = g_pmm.pmm904 
           AND poy02 =(SELECT MIN(poy02) FROM poy_file WHERE poy01=g_pmm.pmm904)
      END IF
      IF g_poy.poy03 <> g_pmm.pmm09 THEN
         CALL s_errmsg('','','','apm-007',0) #No.FUN-710033  
         LET g_success = 'N'
         CONTINUE FOREACH      #No.FUN-710033  
      END IF
      #若不指定幣別，則不用對應流程代碼的幣別
      IF g_poz.poz09 = 'Y' THEN
         IF g_poy.poy05 <> g_pmm.pmm22 THEN
            CALL s_errmsg('','','','apm-008',1)  #No.FUN-710033 #No.FUN-870007 0->1   
            LET g_success = 'N'
            CONTINUE FOREACH        #No.FUN-710033
         END IF
      END IF
      IF g_poy.poy06 <> g_pmm.pmm20 THEN
         CALL s_errmsg('','','','apm-009',1)    #No.FUN-710033 #No.FUN-870007 0->1
         LET g_success = 'N'               
         CONTINUE FOREACH                       #No.FUN-710033   
      END IF
      IF g_poy.poy09 <> g_pmm.pmm21 THEN
         CALL s_errmsg('','','','apm-010',1)    #No.FUN-710033 #No.FUN-870007 0->1 
         LET g_success = 'N'
         CONTINUE FOREACH                       #No.FUN-710033 
      END IF
      #如果采用自動編號，則抓取單別資料
      CALL t254_pod(p_plant) #FUN-980093 add
      IF g_success = 'N' THEN
         CONTINUE FOREACH                       #No.FUN-710033 
      END IF
      LET g_pmm905 = g_pmm.pmm905
      CALL t254_flow99(p_plant)                         #No.8083 取得多角序號 #FUN-980093 add
      IF g_success = 'N' THEN
         CONTINUE FOREACH   #No.FUN-710033  
      END IF
      CALL s_mtrade_last_plant(g_pmm.pmm904)
         RETURNING p_last,p_last_plant                #記錄最後一筆之家數
      #依流程代碼最多6層
      SELECT MIN(poy02) INTO g_first_plant FROM poy_file WHERE poy01=g_pmm.pmm904
      FOR i=(g_first_plant+1) TO p_last
         CALL t254_azp_1(p_plant,i)                     #得到廠商/客戶代碼及database #FUN-980093 add
         CALL t254_azi(p_plant,p_azi01)                 #讀取幣別資料 #FUN-980093 add
         IF g_pod.pod04 = 'N' THEN
             LET g_t1 = g_pmm.pmm01[1,g_doc_len]
             CALL s_mutislip('3','2',g_t1,g_poz.poz01,i)
                 RETURNING g_sw,l_oea_t1,l_pmm_t1,l_x,l_x,l_x  #抓取單別資料
             IF g_sw THEN
                 LET g_success = 'N'
                 CONTINUE FOR       #No.FUN-710033  
             END IF
         END IF
         IF cl_null(l_oea_t1) OR cl_null(l_pmm_t1) THEN
                #LET l_sql ="SELECT rye03 FROM ",p_dbs CLIPPED,"rye_file",
               #FUN-C90050 mark begin---
               # LET l_sql ="SELECT rye03 FROM ",cl_get_target_table(p_plant,'rye_file'), #FUN-A50102
               #            " WHERE rye01 = ?",
               #            "   AND rye02 = ?",
               #            "   AND ryeacti = 'Y'"
               #CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-A50102
               #CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
               #PREPARE rye_cs FROM l_sql
               #EXECUTE rye_cs USING 'axm','30' INTO l_oea_t1
               #FUN-C90050 mark end-----

               CALL s_get_defslip('axm','30',p_plant,'N') RETURNING l_oea_t1    #FUN-C90050 add

               IF cl_null(l_oea_t1) THEN
                  CALL s_errmsg('','','','art-330',1)
                  LET g_success = 'N'
                  CONTINUE FOR
               END IF

              #EXECUTE rye_cs USING 'apm','2' INTO l_pmm_t1     #FUN-C90050 mark

               CALL s_get_defslip('apm','2',p_plant,'N') RETURNING l_pmm_t1    #FUN-C90050 add
               IF cl_null(l_pmm_t1) THEN
                  CALL s_errmsg('','','','art-330',1)
                  LET g_success = 'N'
                  CONTINUE FOR
                END IF
         END IF
         #新增訂單單頭檔(oea_file)(by 下游廠商,即P/O廠商)
         #新增之database為l_dbs_new
         INITIALIZE l_oea.* TO NULL
         IF l_aza.aza50 = 'Y' THEN
            IF NOT cl_null(p_poy29) THEN
               LET l_oea.oea00 = '6'
            ELSE
               LET l_oea.oea00 = '1'
            END IF
            LET l_oea.oea1001= p_oea03     #客戶編號
            LET l_oea.oea1002= p_poy33     #債權代碼
            LET l_oea.oea1003= p_poy27     #業績歸屬方
            LET l_oea.oea1004= p_poy29     #代送商
            LET l_oea.oea1005= p_poy26     #是否計算業績
            LET l_oea.oea1006= 0           #折扣金額(未稅)
            LET l_oea.oea1007= 0           #折扣金額(含稅)
            LET l_oea.oea1008= 0           #訂單總含稅金額
            LET l_oea.oea1012='N'          #自提否
            LET l_oea.oea1013= 0           #重量
            LET l_oea.oea1014= 0           #體積
         ELSE
            LET l_oea.oea00 = '1'
         END IF
           CALL s_auto_assign_no("AXM",l_oea_t1,g_pmm.pmm04,"30","oea_file","oea01",g_poy.poy04,"","")  #FUN-980094 add
   
              RETURNING li_result,l_oea.oea01
            IF (NOT li_result) THEN
               LET g_success = 'N'                 #No.FUN-870007
               CALL s_errmsg('','','','sub-145',1) #No.FUN-870007
               RETURN
            END IF
         LET l_oea.oea02 = g_pmm.pmm04   #訂單日期:
         LET l_oea.oea03 = p_oea03       #帳款客戶編號
         CALL t254_oea03(l_plant_new,l_oea.oea03)    #No.FUN-870007 #FUN-980093 add
            RETURNING l_occ02,l_occ08,l_occ11,l_occ43,l_occ44,l_occ45,
                      l_occ41,                                          #No.FUN-870007
                      l_oea.oea1010,l_oea.oea1009,l_oea.oea1011         #FUN-620025
         IF p_poy07 IS NULL THEN LET p_poy07 = l_occ45 END IF    #No.FUN-870007
         IF p_poy08 IS NULL THEN LET p_poy08 = l_occ41 END IF    #No.FUN-870007
         LET l_oea.oea032=l_occ02        #帳款客戶簡稱
         LET l_oea.oea033=l_occ11        #帳款客戶統一編號
            LET l_oea.oea04 =l_oea.oea03
         LET l_oea.oea05=p_poy12         #No.8083
         LET l_oea.oea07='N'             #出貨是否計入未開發票的銷貨待驗收入
         LET l_oea.oea08='2'
         LET l_oea.oea09=0
         LET l_oea.oea10=g_pmm.pmm01     #客戶訂單單號
         LET l_oea.oea11='6'             #訂單來源(代採買三角貿易)
         LET l_oea.oea14=g_user
         LET l_oea.oea15=g_grup
         LET l_oea.oea161=0              #訂金比例
         LET l_oea.oea162=100            #出貨比例
         LET l_oea.oea163=0              #尾款比例
         LET l_oea.oea17=l_oea.oea03     #收款客戶編號
         LET l_oea.oea20='Y'             #是否直送客戶
         LET l_oea.oea21= p_poy08        #稅別
         LET l_oea.oea31= l_occ44        #價格條件
         LET l_oea.oea25= p_poy10        #No.8083
         LET l_oea.oea32= p_poy07        #No.8083
         #讀取稅別資料
         LET l_sql1 = "SELECT * ",
                      #" FROM ",l_dbs_new CLIPPED,"gec_file ",
                      " FROM ",cl_get_target_table(l_plant_new,'gec_file'),  #FUN-A50102
                      " WHERE gec01='",l_oea.oea21,"' ",
                      "   AND gec011='2' "    #依銷項
 	     CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
         CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-A50102
         PREPARE gec_p2 FROM l_sql1
         IF STATUS THEN CALL cl_err('gec_p2',STATUS,0) END IF
         DECLARE gec_c2 CURSOR FOR gec_p2
         OPEN gec_c2
         FETCH gec_c2 INTO l_gec.*                          #No.8825
         IF NOT (i = p_last AND cl_null(g_pmm.pmm50)) THEN  #最終站不檢查
            IF SQLCA.SQLCODE THEN
               LET g_msg=l_dbs_new CLIPPED,l_oea.oea21 CLIPPED
              CALL cl_err(g_msg CLIPPED,'mfg3044',0)        
               CALL s_errmsg('','',g_msg CLIPPED,'mfg3044',1)  #No.FUN-710033   
               LET g_success = 'N'
               CONTINUE  FOREACH 
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
            #注意database必須為s_azp.azp03
            CALL s_currm(l_oea.oea23,l_oea.oea02,g_pod.pod01,l_plant_new) #FUN-980093 add
               RETURNING l_oea.oea24
         ELSE
            LET l_oea.oea24=1
         END IF
         IF l_oea.oea24 IS NULL THEN LET l_oea.oea24=1 END IF
         LET l_oea.oea49='1'            #狀態
         LET l_oea.oea50='N'            #CSD(CKD/SKD)
         LET l_oea.oea61=0              #訂單總未稅金額
         LET l_oea.oea62=0              #已出貨未稅金額
         LET l_oea.oea63=0              #被結案未稅金額
         LET l_oea.oea72=g_today        #首次確認日
         LET l_oea.oea99=g_flow99       #多角序號 No.8083
         LET l_oea.oea901='Y'           #三角貿易否: 'Y'
         IF i = p_last THEN
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
         LET g_oea.oeaoriu = g_user #FUN-980030
         LET g_oea.oeaorig = g_grup #FUN-980030
         LET g_data_plant = g_plant #FUN-980030
         LET l_oea.oeagrup=g_grup       #資料所有部門
         LET l_oea.oeamodu=null         #資料修改者
         LET l_oea.oeadate=null         #最近修改日
         LET l_oea.oea65='N'             #檢驗否
         LET l_oea.oeaplant = g_poy.poy04 
         SELECT azw02 INTO l_oea.oealegal FROM azw_file 
          WHERE azw01 = l_oea.oeaplant
         LET l_oea.oeacont = TIME
         LET l_oea.oea83 = g_poy.poy04 
         LET l_oea.oea84 = g_poy.poy04
         LET l_oea.oea85 = '2'
         LET l_oea.oeaconu = g_user
         #針對每一符合條件之採購單轉成該廠之S/O
         #新增採購單單頭檔(pmm_file)
         INITIALIZE l_pmm.* TO NULL
         LET l_pmm.* = g_pmm.*
           CALL s_auto_assign_no("APM",l_pmm_t1,g_pmm.pmm04,"2","pmm_file","pmm01",g_poy.poy04,"","")  #FUN-980094 add
              RETURNING li_result,l_pmm.pmm01
            IF (NOT li_result) THEN
               LET g_success = 'N'                 #No.FUN-870007
               CALL s_errmsg('','','','sub-145',1) #No.FUN-870007
               RETURN
            END IF
         LET l_pmm.pmm02= 'TAP'           #單據性質
 
         #No.8083 若為逆拋且有最終供應商，
         #則採購單為一般採購單
         IF g_poz.poz011 = '2' AND i = p_last THEN
            LET l_pmm.pmm02 = 'REG'
         END IF
 
         LET l_pmm.pmm03=0                #更動序號
         LET l_pmm.pmm04=g_pmm.pmm04      #採購日期
         LET l_pmm.pmm05=null             #專案號碼
         LET l_pmm.pmm06=null             #預算號碼
         LET l_pmm.pmm07=null             #單據分類
         LET l_pmm.pmm08=null             #PBI 批號
	       IF i = p_last THEN LET p_pmm09 = g_pmm.pmm50 END IF
         LET l_pmm.pmm09=p_pmm09          #供應廠商
         #說明, 送貨地址存訂單單號, 在P/O列印時可以此反抓S/O資料
         LET l_pmm.pmm10=null              #送貨地址
         LET l_pmm.pmm11=null              #帳單地址
         LET l_pmm.pmm12= g_pmm.pmm12      #採購員
         LET l_pmm.pmm13= g_pmm.pmm13      #採購部門
         LET l_pmm.pmm14= ' '              #收貨部門
         LET l_pmm.pmm15= g_user           #確認人
         LET l_pmm.pmm16= g_pmm.pmm16      #運送方式
         LET l_pmm.pmm17=null              #代理商
         LET l_pmm.pmm18='Y'               #確認碼
         LET l_pmm.pmmplant = p_poy04
         SELECT azw02 INTO l_pmm.pmmlegal FROM azw_file
          WHERE azw01 = l_pmm.pmmplant
         LET l_pmm.pmmcont = TIME
         LET l_pmm.pmmpos = 'N'
         LET l_pmm.pmmcrat = g_today
         LET l_pmm.pmm52  = p_poy04
         LET l_pmm.pmmconu = g_user
         LET l_pmm.pmmcond = g_today
         #讀取廠商相關資料
         LET l_sql1 = "SELECT * ",
                      #" FROM ",l_dbs_new CLIPPED,"pmc_file ",
                      " FROM ",cl_get_target_table(l_plant_new,'pmc_file'), #FUN-A50102
                      " WHERE pmc01='",l_pmm.pmm09,"'"
 	     CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
         CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-A50102
         PREPARE pmc_p1 FROM l_sql1
         IF STATUS THEN CALL cl_err('pmc_p1',STATUS,0) END IF
         DECLARE pmc_c1 CURSOR FOR pmc_p1
         OPEN pmc_c1
         FETCH pmc_c1 INTO l_pmc.*
	       IF NOT ( i = p_last AND cl_null(g_pmm.pmm50)) THEN     #最終站不檢查
            IF SQLCA.SQLCODE=100 THEN
               LET g_msg = l_dbs_new CLIPPED,l_pmm.pmm09 CLIPPED #No.8083
               CALL s_errmsg('','',g_msg CLIPPED,'mfg3001',1)    #No.FUN-710033
               LET g_success='N'  
               CONTINUE FOR     #No.FUN-710033              
            END IF
            CLOSE pmc_c1
            IF p_poy06 IS NULL THEN LET p_poy06 = l_pmc.pmc17 END IF  #No.FUN-870007
            IF p_poy09 IS NULL THEN LET p_poy09 = l_pmc.pmc47 END IF  #No.FUN-870007
            IF cl_null(l_pmc.pmc49) THEN
               LET g_msg = l_dbs_new CLIPPED,l_pmm.pmm09 CLIPPED
               CALL s_errmsg('','',g_msg CLIPPED,'tri-010',1) #No.FUN-710033
               LET g_success = 'N' 
               CONTINUE FOR   #No.FUN-710033
            END IF
         END IF
 
	 IF i <> p_last THEN
            LET l_pmm.pmm20=p_poy06         #付款方式:
            LET l_pmm.pmm21=p_poy09         #稅別:
         ELSE
            LET l_pmm.pmm20=l_pmc.pmc17     #付款方式: ???
            LET l_pmm.pmm21=l_pmc.pmc47     #稅別: ???
	       END IF
         #因為必須以計價方式來判斷幣別,故先給訂單幣別,單身新增完後再給
	       IF i <> p_last THEN
            LET l_pmm.pmm22 = p_azi01       #幣別???
         ELSE
            LET l_pmm.pmm22 = l_pmc.pmc22   #幣別???
	       END IF
         LET l_pmm.pmm25= '2'            #狀況碼: '2'(發出採購單)
         LET l_pmm.pmm26=null            #理由碼: null ???
         LET l_pmm.pmm27=null            #狀況異動日期: null
         LET l_pmm.pmm28=null            #會計分類: null
         LET l_pmm.pmm29=null            #會計科目: null ???
         LET l_pmm.pmm30='N'             #驗收單列印否 : 'N'
         #讀取會計年度, 期間
         LET l_sql1 = "SELECT azn02,azn04 ",
                      #" FROM ",l_dbs_new CLIPPED,"azn_file ",
                      " FROM ",cl_get_target_table(l_plant_new,'azn_file'), #FUN-A50102
                      " WHERE azn01='",l_pmm.pmm04,"' "
 	     CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
         CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-A50102
         PREPARE azn_p1 FROM l_sql1
         IF STATUS THEN CALL cl_err('azn_p1',STATUS,0) END IF
         DECLARE azn_c1 CURSOR FOR azn_p1
         OPEN azn_c1
         FETCH azn_c1 INTO l_pmm.pmm31,l_pmm.pmm32
         CLOSE azn_c1
         LET l_pmm.pmm40=0                #總金額:  l_tot_pmm40
         LET l_pmm.pmm401=0               #代買總金額: 0
         LET l_pmm.pmm40t=0               #含稅總金額: 0   #FUN-620025
         LET l_pmm.pmm41=l_pmc.pmc49      #價格條件: ???
         LET l_pmm.pmm42=1                #匯率: 在單身結束後再判斷
         #讀取稅別資料
         LET l_sql1 = "SELECT * ",
                      #" FROM ",l_dbs_new CLIPPED,"gec_file ",
                      " FROM ",cl_get_target_table(l_plant_new,'gec_file'), #FUN-A50102
                      " WHERE gec01='",l_pmm.pmm21,"' ",
                      "   AND gec011='1' "    #依進項
 	     CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
         CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-A50102
         PREPARE gec_p1 FROM l_sql1
         IF STATUS THEN 
         CALL s_errmsg('','','gec_p1',STATUS,0)   #No.FUN-710033 
         END IF
         DECLARE gec_c1 CURSOR FOR gec_p1
         OPEN gec_c1
         FETCH gec_c1 INTO l_gec.*
         IF SQLCA.SQLCODE
            AND  NOT ( i = p_last AND cl_null(g_pmm.pmm50)) THEN #MOD-490455
            LET g_msg=l_dbs_new CLIPPED,l_pmm.pmm21 CLIPPED
            CALL s_errmsg('','',g_msg CLIPPED,'mfg3044',1) #No.FUN-710033      
            LET g_success = 'N'
            CONTINUE FOREACH             #No.FUN-710033 
         END IF
         CLOSE gec_c1
         IF l_gec.gec04 IS NULL THEN
            LET l_gec.gec04=0
         END IF
 
         LET l_pmm.pmm43 = l_gec.gec04        #稅率
         LET l_pmm.pmm44 = '2'                #稅處理:2不可扣抵 ???
         LET l_pmm.pmm45 ='N'                 #可用/不可用
         LET l_pmm.pmm46 =0                   #預付比率
         LET l_pmm.pmm47 =0                   #預付金額:
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
         LET l_pmm.pmm909='4'            #No.FUN-620054
         LET l_pmm.pmm911=g_pmm.pmm911
         LET l_pmm.pmm912=g_pmm.pmm912
         LET l_pmm.pmm913=g_pmm.pmm913
         LET l_pmm.pmm914=g_pmm.pmm914
         LET l_pmm.pmm915=g_pmm.pmm915
         LET l_pmm.pmm916=g_pmm.pmm916
         LET l_pmm.pmmprsw='N'           #列印抑制: 'N' or 'Y'
         LET l_pmm.pmmprno=0             #已列印次數: 0
         LET l_pmm.pmmprdt=null          #最後列印日期:null
         LET l_pmm.pmmmksg='N'           #是否簽核: 'N' ???
         LET l_pmm.pmmsign=null          #簽核等級: null
         LET l_pmm.pmmdays=0             #簽核完成天數: 0
         LET l_pmm.pmmprit=0             #簽核優先等級: 0
         LET l_pmm.pmmsseq=0             #已簽核順序: 0
         LET l_pmm.pmmsmax=0             #應簽核順序: 0
         LET l_pmm.pmmacti='Y'           #資料有效碼: 'Y'
         LET l_pmm.pmmuser=g_user        #資料所有者: g_user
         LET l_pmm.pmmgrup=g_grup        #資料所有部門: g_grup
         LET l_pmm.pmmmodu=null          #資料修改者: null
         LET l_pmm.pmmdate=null          #最近修改日: null
         LET l_pmm.pmmcrat= g_today      #No.FUN-870007
         #判斷幣別
         CALL t254_azi(l_plant_new,l_pmm.pmm22)   #讀取幣別資料  #FUN-980093 add
         #pmm42匯率:
         #判斷是否為本幣
         IF l_pmm.pmm22 <> l_aza.aza17 THEN
            #注意database必須為s_azp.azp03
            CALL s_currm(l_pmm.pmm22,l_pmm.pmm04,g_pod.pod01,l_plant_new) #FUN-980093 add
               RETURNING l_pmm.pmm42
         ELSE
            LET l_pmm.pmm42 = 1
         END IF
         IF l_pmm.pmm42 IS NULL THEN LET l_pmm.pmm42=1 END IF
 
         LET l_cnt = 0
         LET diff_azi = 'N'
         #讀取採購單單身檔(pmn_file)
         LET l_sql = "SELECT *  ",
                     #"  FROM ",p_dbs_tra CLIPPED,"pmn_file ", #FUN-980093 add
                     "  FROM ",cl_get_target_table(p_plant,'pmn_file'), #FUM-A50102
                     " WHERE pmn01 = '",g_pmm.pmm01,"' "
 	     CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980093
         PREPARE pmn_per1 FROM l_sql
         DECLARE pmn_cus CURSOR FOR pmn_per1
         FOREACH pmn_cus INTO g_pmn.*
            IF SQLCA.SQLCODE <>0 THEN EXIT FOREACH END IF
            LET l_cnt=l_cnt+1
            IF l_aza.aza50='N' THEN     #FUN-620025-cl
               #讀取該料號之計價方式(依流程代碼+生效日期+廠商)
               CALL t254_s_pox(g_pmm.pmm904,i,g_pmn.pmn33,p_plant) #FUN-980093 add
                  RETURNING p_pox03,p_pox05,p_pox06,p_cnt
               IF p_cnt = 0 THEN
                  CALL cl_err('','tri-007',0)
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF
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
            END IF                               #FUN-620025-cl
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
            LET l_pmn.pmn73 = '4'
            LET l_pmn.pmn75 = g_pmn.pmn75
            LET l_pmn.pmn76 = g_pmn.pmn76
            LET l_pmn.pmn77 = g_pmn.pmn77
            #讀取料件基本資料
            LET l_sql1 = "SELECT * ",
                         #" FROM ",l_dbs_new CLIPPED,"ima_file ",
                         " FROM ",cl_get_target_table(l_plant_new,'ima_file'), #FUN-A50102
                         " WHERE ima01='",l_pmn.pmn04,"' "
 	        CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
            CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-A50102
            PREPARE ima_p1 FROM l_sql1
            IF STATUS THEN 
            CALL s_errmsg('','','pmn_p1',STATUS,1)  #No.FUN-710033   
            END IF
            DECLARE ima_c1 CURSOR FOR ima_p1
            OPEN ima_c1
            FETCH ima_c1 INTO l_ima.*
            IF SQLCA.SQLCODE THEN
              LET g_msg=l_dbs_new CLIPPED,l_pmn.pmn04 CLIPPED    
              CALL cl_err(g_msg CLIPPED,'mfg3403',0)         
               CALL s_errmsg('','',g_msg,'mfg3403',1)   #No.FUN-710033
               LET g_success = 'N'
               EXIT FOREACH      #No.FUN-710033 
            END IF
            CLOSE ima_c1
            LET l_pmn.pmn08=l_ima.ima25    #庫存單位
            IF l_pmn.pmn08 IS NULL OR l_pmn.pmn08=' ' THEN
               LET l_pmn.pmn08 = l_pmn.pmn07
            END IF
            #轉換因子:
            LET g_sw = 0
            IF l_pmn.pmn04 = 'MISC' OR l_pmn.pmn07 = l_pmn.pmn08 THEN
               LET l_pmn.pmn09=1
            ELSE
               CALL s_umfchkm(l_pmn.pmn04,l_pmn.pmn07,l_pmn.pmn08,l_plant_new)#FUN-980093 add
                  RETURNING g_sw,l_pmn.pmn09
            END IF
	          IF g_sw THEN
                          LET g_msg = l_plant_new CLIPPED,' ',l_pmn.pmn04 CLIPPED    #FUN-980093 add
             	           CALL cl_err(g_msg,'mfg1206',0)                  
                           CALL s_errmsg('','',g_msg,'mfg1206',1)    #No.FUN-710033      
               	           LET g_success = 'N'
                            EXIT FOREACH    #No.FUN-710033 
            END IF
            IF l_pmn.pmn09 IS NULL THEN
               LET l_pmn.pmn09 = 1
            END IF
            LET l_pmn.pmn10= null             #BUGNo:4757 pmn10改為NO USE
            LET l_pmn.pmn11='N'               #凍結碼
            LET l_pmn.pmn121=1                #轉換因子: 1
            LET l_pmn.pmn122=null             #No use: null
            LET l_pmn.pmn123=null             #廠牌: null
            LET l_pmn.pmn13=0                 #超/短交限率
            LET l_pmn.pmn14=g_sma.sma886[1,1] #部份交貨(Y/N)
            LET l_pmn.pmn15=g_sma.sma886[2,2] #提前交貨(Y/N)
            LET l_pmn.pmn16=l_pmm.pmm25       #狀況碼 同單頭
            LET l_pmn.pmn18=null              #MRP需求日期
            LET l_pmn.pmn20=g_pmn.pmn20       #採購量
            LET l_pmn.pmn23=' '               #送貨地址
            LET l_pmn.pmn24=g_pmn.pmn24       #請購單號
            LET l_pmn.pmn25=g_pmn.pmn25       #請購單號項次
            LET l_pmn.pmn86 = g_pmn.pmn86     #FUN-620025--move here
            LET l_pmn.pmn30=g_pmn.pmn31*g_pmm.pmm42  #標準價格: (S/O本幣)
            #單價:
            IF g_azw.azw04 = '2' THEN
               IF cl_null(l_pmn.pmn86) THEN LET l_pmn.pmn86=l_pmn.pmn07 END IF
               IF cl_null(l_pmn.pmn87) THEN LET l_pmn.pmn87=l_pmn.pmn20 END IF
               IF NOT ( i = p_last AND cl_null(g_pmm.pmm50)) THEN
                  CALL s_fetch_price3(g_pmm.pmm904,l_pmm.pmmplant,l_pmn.pmn04,l_pmn.pmn07,'0',i)
                       RETURNING g_success,l_price
                 IF g_success='N' THEN
                    CALL s_errmsg('','','s_fetch_price3:','art-331',1)
                    EXIT FOREACH
                 END IF 
                 LET l_pmn.pmn31 = cl_digcut(l_price,t_azi03)   
                 LET l_pmn.pmn31t = l_pmn.pmn31 * ( 1 + l_pmm.pmm43 / 100)    
                 LET l_pmn.pmn31t = cl_digcut(l_pmn.pmn31t,t_azi03)
               END IF    
            ELSE
            IF l_aza.aza50='Y' THEN
               IF l_sma.sma116<>'0' THEN
                  LET l_unit = l_pmn.pmn86
               ELSE
                  LET l_unit = l_pmn.pmn07
               END IF
               IF NOT ( i = p_last AND cl_null(g_pmm.pmm50)) THEN
                  IF g_azw.azw04 = '2' THEN
                     CALL s_fetch_price3(g_pmm.pmm904,l_pmm.pmmplant,l_pmn.pmn04,l_unit,'0',i)
                       RETURNING g_success,l_pmn.pmn31
                     IF g_success='N' THEN
                        LET g_success='N'
                     END IF
                  ELSE
                  CALL s_fetch_price2(p_pmm09,l_pmn.pmn04,l_unit,l_pmm.pmm04,'4',l_plant_new,l_pmm.pmm22)   #No.FUN-980059
                     RETURNING l_x,l_pmn.pmn31,g_success
                  END IF  #No.FUN-870007
               END IF
               IF g_success ='N' THEN
                  CALL s_errmsg('','','','axm-043',0)   #No.FUN-710033   
                  EXIT FOREACH                          #No.FUN-710033           
               END IF
               LET l_pmn.pmn31t= l_pmn.pmn31 * (1+ l_pmm.pmm43/100)
               IF cl_null(l_pmn.pmn86) THEN
                  LET l_pmn.pmn87=l_pmn.pmn20
               END IF
            ELSE
               #計價方式來判斷
               IF ( i = p_last AND NOT cl_null(l_pmm.pmm50)) THEN
                  LET l_pmm.pmm09=l_pmm.pmm50
#TQC-A60130 --begin--                  
#                  CALL s_defprice1(l_pmn.pmn04, l_pmm.pmm09, l_pmm.pmm22,
#                                   l_pmm.pmm04, l_pmn.pmn20,'',l_pmm.pmm21,
#                                   l_pmm.pmm43,l_pmm.pmmplant,'2',g_pmn.pmn86,l_pmm.pmm41,l_pmm.pmm20,'')    #No.FUN-870007
#                     RETURNING l_pmn.pmn31,l_pmn.pmn31t
                  CALL s_defprice1(l_pmn.pmn04,l_pmm.pmm09,l_pmm.pmm22,
                                   l_pmm.pmm04,l_pmn.pmn20,'',
                                   l_pmm.pmm21,l_pmm.pmm43,'2',
                                   g_pmn.pmn86,''         ,l_pmm.pmm41,
                                   l_pmm.pmm20,l_pmm.pmmplant) 
                     RETURNING l_pmn.pmn31,l_pmn.pmn31t
#TQC-A60130 --end--
               ELSE
                  CASE p_pox05
                     WHEN '1'
                        IF p_pox03='1' THEN   #依來源工廠
                           IF g_pmm.pmm22 = l_pmm.pmm22 THEN
                              LET l_pmn.pmn31 = g_pmn.pmn31 * p_pox06/100
                           END IF
                           IF g_pmm.pmm22 <> l_pmm.pmm22 THEN
                              LET l_price = g_pmn.pmn31 * g_pmm.pmm42 #換算回本幣
                              ##已來源廠的匯率計算
                              CALL s_currm(l_pmm.pmm22,g_pmm.pmm04,
                                           #g_pod.pod01,t_dbs) #FUN-980093 mark
                                           g_pod.pod01,p_plant_new) #FUN-980093 add
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
                                 ##已來源廠的匯率計算
                                 CALL s_currm(l_pmm.pmm22,g_pmm.pmm04,
                                              #g_pod.pod01,t_dbs) #FUN-980093 mark
                                              g_pod.pod01,p_plant_new) #FUN-980093 add
                                    RETURNING l_currm
                                 LET l_pmn.pmn31= l_price/l_currm*p_pox06/100
                              END IF
                           ELSE
                              LET l_no = i-1
                              SELECT so_price,so_curr INTO l_price,l_curr
                                FROM t254_file
                               WHERE p_no = l_no
                                 AND so_no = g_pmm.pmm01
                                 AND so_item=g_pmn.pmn02
                              IF l_curr != l_pmm.pmm22 THEN
                                 CALL s_currm(l_curr,g_pmm.pmm04,g_pod.pod01,p_plant_new) #FUN-980093 add
                                      RETURNING l_currm
                                 LET l_price =l_price * l_currm #換算回本幣
                                 #以來源廠的匯率來計算 no:6600
                                 CALL s_currm(l_pmm.pmm22,g_pmm.pmm04,g_pod.pod01,
                                              #t_dbs) RETURNING l_currm #FUN-980093 mark
                                              p_plant_new) RETURNING l_currm #FUN-980093 add
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
                        CALL s_pow(g_pmm.pmm904,g_pmn.pmn04,p_poy04,g_pmn.pmn33)
                           RETURNING g_sw,l_pmn.pmn31
                        IF g_sw='N' THEN
                           IF g_pod.pod02 = 'N' THEN
                              CALL s_errmsg('','','sel pow:','axm-333',0) #No.FUN-710033
                              LET g_success = 'N'
                              EXIT FOREACH   #No.FUN-710033       
                           END IF
                           LET l_pmn.pmn31 =0
                        END IF
                     WHEN '3'   #單價若為0, 則給0, 否則抓料件之固定價格
                        IF g_pmn.pmn31 <> 0 THEN        #no.6215
                           CALL s_pow(g_pmm.pmm904,g_pmn.pmn04,p_poy04,g_pmn.pmn33)
                              RETURNING g_sw,l_pmn.pmn31
                           IF g_sw='N' THEN
                              IF g_pod.pod02 = 'N' THEN
                                 CALL s_errmsg('','','sel pow:','axm-333',0) #No.FUN-710033       
                                 LET g_success = 'N'
                                 CONTINUE FOREACH  #No.FUN-710033
                              END IF
                              LET l_pmn.pmn31 = 0
                           END IF
                        ELSE
                           LET l_pmn.pmn31 = 0
                        END IF
                  END CASE
                  IF l_pmn.pmn31 IS NULL THEN LET l_pmn.pmn31 =0 END IF
                  LET l_pmn.pmn31t=l_pmn.pmn31 * (1+l_pmm.pmm43/100) #no.7259
               END IF
            END IF
            END IF   #No.FUN-870007
            LET l_pmn.pmn32=null
            LET l_pmn.pmn33=g_pmn.pmn33    #原始交貨日期
            LET l_pmn.pmn34=g_pmn.pmn34    #原始到廠日期
            LET l_pmn.pmn35=g_pmn.pmn35    #原始到庫日期
            LET l_pmn.pmn36=g_pmn.pmn36    #最近確認交貨日期
            LET l_pmn.pmn37=null           #最後一次到廠日期
            LET l_pmn.pmn38='N'            #可用/不可用
            LET l_pmn.pmn40=g_pmn.pmn40    #會計科目 no.7097
            LET l_pmn.pmn41=null           #工單號碼
            LET l_pmn.pmn42='0'            #替代碼
            LET l_pmn.pmn43=0              #作業序號
            LET l_pmn.pmn431=0             #下一站作業序號
            LET l_pmn.pmn44=l_pmn.pmn31 * l_pmm.pmm42  #本幣單價=單價*匯率
            CALL cl_digcut(l_pmn.pmn44,l_azi.azi03)
               RETURNING l_pmn.pmn44
            LET l_pmn.pmn45=null           #NO:7190
            LET l_pmn.pmn46=null           #No Use
            LET l_pmn.pmn50=0              #交貨量
            LET l_pmn.pmn51=0              #在驗量
            LET l_pmn.pmn52=null           #倉庫
            LET l_pmn.pmn53=0              #入庫量
            LET l_pmn.pmn54=null           #儲位
            LET l_pmn.pmn55=0              #驗退量
            LET l_pmn.pmn56=' '            #批號
            LET l_pmn.pmn57=0              #超短交量
            LET l_pmn.pmn58=0              #倉退量
            LET l_pmn.pmn59=null           #退貨單號
            LET l_pmn.pmn60=null           #項次
            LET l_pmn.pmn61=l_pmn.pmn04    #被替代料號
            LET l_pmn.pmn62=1              #替代率
            LET l_pmn.pmn63='N'            #急料否
            LET l_pmn.pmn64='N'            #保稅否
            LET l_pmn.pmn65='1'            #代買性質
            LET l_pmn.pmn80 = g_pmn.pmn80
            LET l_pmn.pmn81 = g_pmn.pmn81
            LET l_pmn.pmn82 = g_pmn.pmn82
            LET l_pmn.pmn83 = g_pmn.pmn83
            LET l_pmn.pmn84 = g_pmn.pmn84
            LET l_pmn.pmn85 = g_pmn.pmn85
            LET l_pmn.pmn87 = g_pmn.pmn87
            LET l_pmn.pmn88 = g_pmn.pmn88
            LET l_pmn.pmn88t = g_pmn.pmn88t
            #CALL t254_iou(g_pmm.pmm99,g_pmm.pmm905,l_plant_new,'oea')  #No.FUN-870007 #FUN-980093 add
            CALL t254_iou(g_pmm.pmm99,g_pmm.pmm905,l_plant_new,'oea_file','oea')  #FUN-A50102
               RETURNING l_stu_p                                  #FUN-620025-cl
            #如果是最后一站且沒有委外，則不處理                   #FUN-620025-cl
            IF ( i = p_last AND cl_null(g_pmm.pmm50)) THEN        #FUN-620025-cl
               LET l_stu_p='A'                                    #FUN-620025-cl
            END IF                                                #FUN-620025-cl
            IF l_stu_p='I' THEN                                   #FUN-620025-cl
               IF NOT ( i = p_last AND cl_null(g_pmm.pmm50)) THEN
                  IF cl_null(l_pmn.pmn02) THEN LET l_pmn.pmn02 = 0 END IF   #TQC-790002 add
                  #新增採購單身檔
                  #LET l_sql2="INSERT INTO ",l_dbs_tra CLIPPED,"pmn_file", #FUN-980093 add
                  LET l_sql2="INSERT INTO ",cl_get_target_table(l_plant_new,'pmn_file'), #FUN-A50102
                             "   (pmn01 ,pmn011 ,pmn02 ,pmn03,",
                             "    pmn04 ,pmn041 ,pmn05 ,pmn06 ,",
                             "    pmn07 ,pmn08 ,pmn09 , pmn10,",
                             "    pmn11 ,pmn121 ,pmn122 ,pmn123 ,",
                             "    pmn13 ,pmn14 ,pmn15 ,pmn16 ,",
                             "    pmn18 ,pmn20 ,pmn23 ,pmn24,",
                             "    pmn25 ,pmn30 ,pmn31 ,pmn32 ,",
                             "    pmn33 ,pmn34 ,pmn35 ,pmn36,",
                             "    pmn37 ,pmn38 ,pmn40 ,pmn41,",
                             "    pmn42 ,pmn43 ,pmn431 ,pmn44,",
                             "    pmn45 ,pmn46 ,pmn50 ,pmn51,",
                             "    pmn52 ,pmn53 ,pmn54 ,pmn55,",
                             "    pmn56 ,pmn57 ,pmn58 ,pmn59,",
                             "    pmn60 ,pmn61 ,pmn62 ,pmn63,",
                             "    pmn72 ,pmn73 ,pmn75 ,pmn76, pmn77,pmnplant,pmnlegal,", #No.FUN-870007
                             "    pmn64 ,pmn65 ,pmn31t ,pmn80,",  #FUN-560043
                             "    pmn81 ,pmn82 ,pmn83 ,pmn84,",   #FUN-560043
                             "    pmn85 ,pmn86 ,pmn87)" ,         #FUN-560043
                             " VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                             "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                             "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                             "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?, ",
                             "         ?,?,?,?, ?,?,?,                     ",   #No.FUN-870007
                             "         ?,?,? )"    #FUN-560043
 	              CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                  CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
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
                     l_pmn.pmn72 ,l_pmn.pmn73 ,l_pmn.pmn75 ,l_pmn.pmn76,   #No.FUN-870007
                     l_pmn.pmn77 ,l_pmn.pmnplant,l_pmn.pmnlegal,           #No.FUN-870007
                     l_pmn.pmn64 ,l_pmn.pmn65 ,l_pmn.pmn31t,l_pmn.pmn80 ,
                     l_pmn.pmn81 ,l_pmn.pmn82,l_pmn.pmn83 ,l_pmn.pmn84 ,
                     l_pmn.pmn85 ,l_pmn.pmn86,l_pmn.pmn87
                  IF SQLCA.sqlcode<>0 THEN
                     CALL s_errmsg('','','ins pmn:',SQLCA.sqlcode,1)  #No.FUN-710033  #No.FUN-870007 0->1 
                     LET g_success = 'N'
                     EXIT FOREACH                                     #No.FUN-710033 
                  END IF
                  IF NOT s_industry('std') THEN
                     INITIALIZE l_pmni.* TO NULL
                     LET l_pmni.pmni01 = l_pmn.pmn01
                     LET l_pmni.pmni02 = l_pmn.pmn02
                     IF NOT s_ins_pmni(l_pmni.*,l_plant_new) THEN  #FUN-980093 add
                        LET g_success='N'                                                                      #NO.FUN-710026
                        EXIT FOREACH                                                                       #NO.FUN-710026
                     END IF
                  END IF
               END IF
            ELSE
               #重新拋轉時,只針對訂單變更的欄位更新
               #更新採購單身檔
              IF l_stu_p='U' THEN                             #FUN-620025-cl 
               IF NOT ( i = p_last AND cl_null(g_pmm.pmm50)) THEN
                  IF g_pod.pod04 = 'N' THEN
                     LET l_sql2 = "SELECT pmm01 ",
                                  #" FROM ",l_dbs_tra CLIPPED,"pmm_file ", #FUN-980093 add
                                  " FROM ",cl_get_target_table(l_plant_new,'pmm_file'), #FUN-A50102
                                  " WHERE pmm99= ",g_pmm.pmm99
 	                 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                     CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980093
                     #PREPARE pmm_p1 FROM l_sql1   #TQC-940185 mark
                     PREPARE pmm_p1 FROM l_sql2    #TQC-940185 add 
                     IF SQLCA.SQLCODE THEN 
                     CALL s_errmsg('','','pmm_p1',SQLCA.sqlcode,1) #No.FUN-710033
                     END IF
                     DECLARE pmm_c1 CURSOR FOR pmm_p1
                     OPEN pmm_c1
                     FETCH pmm_c1 INTO l_pmn.pmn01
                     CLOSE pmm_c1
                  END IF
                  #LET l_sql2="UPDATE ",l_dbs_tra CLIPPED,"pmn_file", #FUN-980093 add
                  LET l_sql2="UPDATE ",cl_get_target_table(l_plant_new,'pmn_file'), #FUN-A50102
                             "   SET pmn04 = ?,pmn041 = ? ,pmn07 = ? , ",
                             "       pmn08 = ?,pmn09  = ? ,pmn20 = ? , ",
                             "       pmn31 = ?,pmn33  = ? ,pmn34 = ? , ",
                             "       pmn35 = ?,pmn36  = ? ,pmn44 = ? , ",
                             "       pmn31t= ?,pmn80  = ? ,pmn81 = ? , ",   #FUN-560043
                             "       pmn82 = ?,pmn83  = ? ,pmn84 = ? , ",   #FUN-560043
                             "       pmn85 = ?,pmn86  = ? ,pmn87 = ? ",     #FUN-560043
                             " WHERE pmn01=? AND pmn02=? "
 	              CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                  CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980093
                  PREPARE upd_pmn FROM l_sql2
                  EXECUTE upd_pmn USING
                          l_pmn.pmn04 ,l_pmn.pmn041,l_pmn.pmn07 ,l_pmn.pmn08,
                          l_pmn.pmn09 ,l_pmn.pmn20 ,l_pmn.pmn31 ,l_pmn.pmn33 ,
                          l_pmn.pmn34 ,l_pmn.pmn35 ,l_pmn.pmn36 , l_pmn.pmn44,
                          l_pmn.pmn31t,l_pmn.pmn80,l_pmn.pmn81,l_pmn.pmn82,   #FUN-560043
                          l_pmn.pmn83,l_pmn.pmn84,l_pmn.pmn85,l_pmn.pmn86,    #FUN-560043
                          l_pmn.pmn87,                                        #FUN-560043
                          l_pmn.pmn01 ,l_pmn.pmn02
                  IF SQLCA.sqlcode THEN
                     CALL s_errmsg('','','upd pmn:',SQLCA.sqlcode,1) #No.FUN-710033 #No.FUN-870007 0->1
                     LET g_success = 'N'
                     RETURN
                  END IF
               END IF
             ELSE                                                                                                               
               IF l_stu_p='F' THEN                     #FUN-620025-cl
                  CALL s_errmsg('','',g_pmm.pmm99,"apm-803",0)   #No.FUN-710033  
                  LET g_success = 'N'                  #FUN-620025-cl
                  RETURN
               END IF
             END IF
            END IF
 
            #採購單頭總金額
            IF g_sma.sma116 != '0' THEN
               LET l_pmm.pmm40 = l_pmm.pmm40 + l_pmn.pmn31*l_pmn.pmn87
            ELSE
               LET l_pmm.pmm40 = l_pmm.pmm40 + l_pmn.pmn31*l_pmn.pmn20
            END IF
            CALL cl_digcut(l_pmm.pmm40,l_azi.azi04)
               RETURNING l_pmm.pmm40
            LET l_pmm.pmm40t = l_pmm.pmm40 * (1.00+l_pmm.pmm43 / 100.0)  #FUN-620025
 
            #新增訂單單身檔(oeb_file)(by 下游廠商,即P/O廠商)
            INITIALIZE l_oeb.* TO NULL
            LET l_oeb.oeb01 = l_oea.oea01    #FUN-620025
            LET l_oeb.oeb03 = g_pmn.pmn02
            LET l_oeb.oeb04 = g_pmn.pmn04
            LET l_oeb.oeb05 = g_pmn.pmn07    #銷售單位同採購單位
            ##轉換因子#no:5079
            IF l_oeb.oeb04 = 'MISC' OR l_oeb.oeb05 = g_pmn.pmn08 THEN
               LET l_oeb.oeb05_fac = 1
            ELSE
               CALL s_umfchkm(l_oeb.oeb04,l_oeb.oeb05,g_pmn.pmn08,l_plant_new) #FUN-980093 add
                  RETURNING l_flag,l_oeb.oeb05_fac
            END IF
            IF l_flag THEN
               CALL s_errmsg('','',l_oeb.oeb04,'mfg1206',0)   #No.FUN-710033      
     	         LET g_success = 'N'
                 EXIT FOREACH             #No.FUN-710033   
            END IF
            IF cl_null(l_oeb.oeb05_fac) THEN
               LET l_oeb.oeb05_fac = 1
            END IF
            LET l_oeb.oeb06 = g_pmn.pmn041
            LET l_oeb.oeb08 =null    #出貨工廠
            LET l_oeb.oeb09 =null    #出貨倉庫
            LET l_oeb.oeb091=null    #出貨儲位
            LET l_oeb.oeb092=null    #出貨批號
            LET l_oeb.oeb12=g_pmn.pmn20
            LET l_oeb.oeb916 = g_pmn.pmn86   #FUN-620025--move here
            LET l_oeb.oeb917 = g_pmn.pmn87   #FUN-620025--move here
            IF l_oeb.oeb916 IS NULL THEN LET l_oeb.oeb916 = l_oeb.oeb05 END IF
            IF l_oeb.oeb917 IS NULL THEN LET l_oeb.oeb917 = l_oeb.oeb12 END IF
            LET l_oeb.oeb44 = g_pmm.pmm51
            LET l_oeb.oeb45 = ''
            LET l_oeb.oeb46 = ''
            LET l_oeb.oeb47 = 0
            LET l_oeb.oeb48 = '2'
            LET l_oeb.oeb1003 = '1'
            LET l_oeb.oebplant = l_oea.oeaplant
            LET l_oeb.oeblegal = l_oea.oealegal
            IF g_azw.azw04 = '2' THEN
               CALL s_fetch_price3(g_pmm.pmm904,l_oea.oeaplant,l_oeb.oeb04,l_oeb.oeb05,'1',i)
                    RETURNING g_success,l_oeb.oeb13
               IF g_success='N' THEN
                  CALL s_errmsg('','','s_fetch_price3:','art-331',1)
                  EXIT FOREACH
               END IF
               IF l_oea.oea213 = 'N' THEN              #表示不含稅
                  LET l_oeb.oeb14 = l_oeb.oeb917* l_oeb.oeb13
                  LET l_oeb.oeb14t= l_oeb.oeb14*(1+l_oea.oea211/100)
               ELSE
                  LET l_oeb.oeb13 = l_oeb.oeb13*(1+l_oea.oea211/100)
                  LET l_oeb.oeb14t= l_oeb.oeb917*l_oeb.oeb13
                  LET l_oeb.oeb14 = l_oeb.oeb14t/(1+l_oea.oea211/100)
               END IF
            ELSE
            #使用分銷功能，對訂單單價設置
            IF l_aza.aza50 = 'Y' THEN
               IF l_sma.sma116<>'0' THEN
                  LET l_unit = l_oeb.oeb916
               ELSE
                  LET l_unit = l_oeb.oeb05
               END IF
               IF g_azw.azw04 = '2' THEN
                  CALL s_fetch_price3(g_pmm.pmm904,l_pmm.pmmplant,l_oeb.oeb04,l_unit,'1',i)
                    RETURNING g_success,l_oeb.oeb13
               ELSE
               CALL s_fetch_price2(l_oea.oea1001,l_oeb.oeb04,l_unit,l_oea.oea02,'4',l_plant_new,l_oea.oea23)   #No.FUN-980059
                  RETURNING l_oeb.oeb1002,l_oeb.oeb13,g_success
               END IF #No.FUN-870007
               IF g_success ='N' THEN
                  CALL s_errmsg('','','',"axm-043",0)  #No.FUN-710033
               END IF
               IF cl_null(l_oeb.oeb916) THEN
                  LET l_oeb.oeb917=l_oeb.oeb12
               END IF
               IF l_oea.oea213 = 'N' THEN              #表示不含稅
                  LET l_oeb.oeb14 = l_oeb.oeb917* l_oeb.oeb13
                  LET l_oeb.oeb14t= l_oeb.oeb14*(1+l_oea.oea211/100)
               ELSE
                  LET l_oeb.oeb13 = l_oeb.oeb13*(1+l_oea.oea211/100)
                  LET l_oeb.oeb14t= l_oeb.oeb917*l_oeb.oeb13
                  LET l_oeb.oeb14 = l_oeb.oeb14t/(1+l_oea.oea211/100)
               END IF
               LET l_oeb.oeb1001 = p_poy28       #原因碼
               LET l_sql = "SELECT azf10  ",
                     #"  FROM ",p_dbs CLIPPED,"azf_file ",
                     "  FROM ",cl_get_target_table(p_plant,'azf_file'), #FUN-A50102
                     " WHERE azf01 = '",l_oeb.oeb1001,"' "
 	           CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
               CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
               PREPARE azf_pre FROM l_sql
               EXECUTE azf_pre INTO l_azf10
               IF l_azf10 ='Y'  THEN             #判斷原因碼是搭贈的話
                  LET l_oeb.oeb14=0
                  LET l_oeb.oeb14t=0
               END IF
               LET l_oeb.oeb1003 = '1'         #作業方式
               LET l_oeb.oeb1004 = ''          #提案編號
               LET l_oeb.oeb1005 = ''          #定訂價群組
               LET l_oeb.oeb1006 = 100         #折扣率  #FUN-620025-cl 
               LET l_oeb.oeb1007 = ''          #現金折扣單號
               LET l_oeb.oeb1008 = ''          #稅別
               LET l_oeb.oeb1009 = ''          #稅率
               LET l_oeb.oeb1010 = ''          #含稅否
               LET l_oeb.oeb1011 = ''          #非直營KAB
               #重量, 體積
               CALL s_weight_cubage(g_pmn.pmn04,g_pmn.pmn08,g_pmn.pmn20)
                  RETURNING l_oea1013,l_oea1014
               LET l_oea.oea1013 = l_oea.oea1013 + l_oea1013
               LET l_oea.oea1014 = l_oea.oea1014 + l_oea1014
            ELSE
               IF i = 1 THEN
                  LET l_oeb.oeb13=g_pmn.pmn31     #單價: 同上游採購單價
               ELSE
                  LET l_no1 = i-1
                  SELECT so_price INTO l_oeb.oeb13
                    FROM t254_file
                   WHERE p_no = l_no1
                     AND so_no = g_pmm.pmm01
                     AND so_item=g_pmn.pmn02
               END IF
               LET l_oeb.oeb17 = l_oeb.oeb13     #no.7150
               #未稅金額/含稅金額 : oeb14/oeb14t
               IF l_oea.oea213 = 'N' THEN
#                 LET l_oeb.oeb14=l_oeb.oeb12*l_oeb.oeb13    #CHI-B70039 mark
                  LET l_oeb.oeb14=l_oeb.oeb917*l_oeb.oeb13   #CHI-B70039
                  LET l_oeb.oeb14t=l_oeb.oeb14*(1+l_oea.oea211/100)
               ELSE
#                 LET l_oeb.oeb14t=l_oeb.oeb12*l_oeb.oeb13    #CHI-B70039 mark
                  LET l_oeb.oeb14t=l_oeb.oeb917*l_oeb.oeb13   #CHI-B70039
                  LET l_oeb.oeb14=l_oeb.oeb14t/(1+l_oea.oea211/100)
               END IF
            END IF
            END IF  #No.FUN-870007
            LET l_oeb.oeb15=g_pmn.pmn33
            LET l_oeb.oeb23=0          #待出貨數量
            LET l_oeb.oeb24=0          #已出貨數量
            LET l_oeb.oeb25=0          #已銷退數量
            LET l_oeb.oeb26=0          #被結案數量
            LET l_oeb.oeb70='N'        #結案否
            LET l_oeb.oeb901=0         #已包裝數
            LET l_oeb.oeb905=0         #no.7182
            LET l_oeb.oeb906='N'       #檢驗否
            CALL cl_digcut(l_oeb.oeb14,l_azi.azi04)
               RETURNING l_oeb.oeb14
            CALL cl_digcut(l_oeb.oeb14t,l_azi.azi04)
               RETURNING l_oeb.oeb14t
            LET l_oeb.oeb910 = g_pmn.pmn80
            LET l_oeb.oeb911 = g_pmn.pmn81
            LET l_oeb.oeb912 = g_pmn.pmn82
            LET l_oeb.oeb913 = g_pmn.pmn83
            LET l_oeb.oeb914 = g_pmn.pmn84
            LET l_oeb.oeb915 = g_pmn.pmn85
            IF cl_null(l_oeb.oeb05_fac) THEN LET l_oeb.oeb05_fac = 1 END IF
            IF cl_null(l_oeb.oeb12) THEN LET l_oeb.oeb12 = 0 END IF
            IF cl_null(l_oeb.oeb13) THEN LET l_oeb.oeb13 = 0 END IF
            IF cl_null(l_oeb.oeb14) THEN LET l_oeb.oeb14 = 0 END IF
            IF cl_null(l_oeb.oeb14T) THEN LET l_oeb.oeb14T = 0 END IF
            IF cl_null(l_oeb.oeb23) THEN LET l_oeb.oeb23 = 0 END IF
            IF cl_null(l_oeb.oeb24) THEN LET l_oeb.oeb24 = 0 END IF
            IF cl_null(l_oeb.oeb25) THEN LET l_oeb.oeb25 = 0 END IF
            IF cl_null(l_oeb.oeb26) THEN LET l_oeb.oeb26 = 0 END IF
            IF cl_null(l_oeb.oeb1003) THEN LET l_oeb.oeb1003 = '1' END IF  #MOD-9C0155
            IF cl_null(l_oeb.oeb37) OR l_oeb.oeb37 = 0 THEN LET l_oeb.oeb37 = l_oeb.oeb13 END IF    #FUN-AB0061 
            #新增訂單單身檔
            #CALL t254_iou(g_pmm.pmm99,g_pmm.pmm905,l_plant_new,'oea')  #No.FUN-870007 #FUN-980093 add
            CALL t254_iou(g_pmm.pmm99,g_pmm.pmm905,l_plant_new,'oea_file','oea') #FUN-A50102
                RETURNING l_stu_o                  #FUN-620025-cl
            IF l_stu_o='I' THEN                   #FUN-620025-cl
               #LET l_sql2="INSERT INTO ",l_dbs_tra CLIPPED,"oeb_file", #FUN-980093 add
               LET l_sql2="INSERT INTO ",cl_get_target_table(l_plant_new,'oeb_file'), #FUN-A50102
                          "( oeb01,oeb03,oeb04,oeb05,",
                          "  oeb05_fac,oeb06,oeb07,oeb08, ",
                          "  oeb09,oeb091,oeb092,oeb11, ",
                          "  oeb12,oeb13,oeb14,oeb14t, ",
                          "  oeb15,oeb16,oeb17,oeb18, ",
                          "  oeb19,oeb20,oeb21,oeb22, ",
                          "  oeb23,oeb24,oeb25,oeb26, ",
                          "  oeb44,oeb45,oeb46,oeb47, ",  #No.FUN-870007
                          "  oeb48,oebplant,oeblegal, ",  #No.FUN-870007
                          "  oeb70,oeb70d,oeb71,oeb72, ",
                          "  oeb901,oeb902,oeb903,oeb904,",
                          "  oeb905,oeb906,oeb907,oeb908,",
                          "  oeb909,oeb910,oeb911,oeb912,",   #FUN-560043
                          "  oeb913,oeb914,oeb915,oeb916,",   #FUN-560043
                          "  oeb917, oeb1001,oeb1002,oeb1003,", #FUN-620025
                          "  oeb1004,oeb1005,oeb1007,oeb1009,", #FUN-620025
                          "  oeb1010,oeb1011,oeb1008,oeb1012,", #FUN-620025-cl
                          "  oeb1006,oeb37)",                         #FUN-620025-cl    #FUN-AB0061 add oeb37
                          " VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                          "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                          "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",   #FUN-560043  #FUN-620025
                          "         ?,?,?,?, ?,?,?, ",                      #No.FUN-870007
                          "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?  )"  #FUN-620025-cl  #FUN-AB0061 add ?
 	           CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
               CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
               #Add FUN-B20060
              #CHI-C80060 mark START
              #IF cl_null(l_oeb.oeb72) AND NOT cl_null(l_oeb.oeb15) THEN
              #   LET l_oeb.oeb72 = l_oeb.oeb15
              #END IF
              #CHI-C80060 mark END
               #End Add FUN-B20060
              #CHI-C80060 add START
               IF cl_null(l_oeb.oeb72) THEN
                  LET l_oeb.oeb72 = NULL   
               END IF
              #CHI-C80060 add END
               PREPARE ins_oeb FROM l_sql2
               EXECUTE ins_oeb USING
                  l_oeb.oeb01,l_oeb.oeb03,l_oeb.oeb04,l_oeb.oeb05,
                  l_oeb.oeb05_fac,l_oeb.oeb06,l_oeb.oeb07,l_oeb.oeb08,
                  l_oeb.oeb09,l_oeb.oeb091,l_oeb.oeb092,l_oeb.oeb11,
                  l_oeb.oeb12,l_oeb.oeb13,l_oeb.oeb14,l_oeb.oeb14t,
                  l_oeb.oeb15,l_oeb.oeb16,l_oeb.oeb17,l_oeb.oeb18,
                  l_oeb.oeb19,l_oeb.oeb20,l_oeb.oeb21,l_oeb.oeb22,
                  l_oeb.oeb23,l_oeb.oeb24,l_oeb.oeb25,l_oeb.oeb26,
                  l_oeb.oeb44,l_oeb.oeb45,l_oeb.oeb46,l_oeb.oeb47,    #No.FUN-870007
                  l_oeb.oeb48,l_oeb.oebplant,l_oeb.oeblegal,          #No.FUN-870007
                  l_oeb.oeb70,l_oeb.oeb70d,l_oeb.oeb71,l_oeb.oeb72,
                  l_oeb.oeb901,l_oeb.oeb902,l_oeb.oeb903,l_oeb.oeb904,
                  l_oeb.oeb905,l_oeb.oeb906,l_oeb.oeb907,l_oeb.oeb908,
                  l_oeb.oeb909,l_oeb.oeb910,l_oeb.oeb911,l_oeb.oeb912,   #FUN-560043
                  l_oeb.oeb913,l_oeb.oeb914,l_oeb.oeb915,l_oeb.oeb916,   #FUN-560043
                  l_oeb.oeb917, l_oeb.oeb1001,l_oeb.oeb1002,l_oeb.oeb1003, #FUN-620025
                  l_oeb.oeb1004,l_oeb.oeb1005,l_oeb.oeb1007,l_oeb.oeb1009, #FUN-620025
                  l_oeb.oeb1010,l_oeb.oeb1011,l_oeb.oeb1008,l_oeb.oeb1012, #FUN-620025-cl 
                  l_oeb.oeb1006,l_oeb.oeb37                                #FUN-620025-cl    #FUN-AB0061 add l_oeb.oeb37 
 
               IF SQLCA.sqlcode<>0 THEN
                  CALL s_errmsg('','','ins oeb:',SQLCA.sqlcode,1)  #No.FUN-710033 
                  LET g_success = 'N'
                  EXIT FOREACH                                     #No.FUN-710033         
               ELSE
                  IF NOT s_industry('std') THEN
                     INITIALIZE l_oebi.* TO NULL
                     LET l_oebi.oebi01 = l_oeb.oeb01
                     LET l_oebi.oebi03 = l_oeb.oeb03
                     IF NOT s_ins_oebi(l_oebi.*,l_plant_new) THEN #FUN-980093 add
                        LET g_success = 'N'
                        EXIT FOREACH
                     END IF
                  END IF
               END IF
            ELSE
               IF l_stu_o='U' THEN                        #FUN-620025-cl  
                  IF g_pod.pod04='N' THEN
                     LET l_sql2 = "SELECT oea01 ",
                                  #" FROM ",l_dbs_tra CLIPPED,"oea_file ", #FUN-980093 add
                                  " FROM ",cl_get_target_table(l_plant_new,'oea_file'), #FUN-A50102
                                  " WHERE oea99= ",g_pmm.pmm99
                     CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                     CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980093
                     PREPARE oea_p1 FROM l_sql2        #TQC-940185 add
                     IF SQLCA.SQLCODE THEN 
                     CALL s_errmsg('','','oea_p1',SQLCA.sqlcode,1)  #No.FUN-710033      
                     END IF
                     DECLARE oea_c1 CURSOR FOR oea_p1
                     OPEN oea_c1
                     FETCH oea_c1 INTO l_oeb.oeb01
                     CLOSE oea_c1
                  END IF
                  #更新訂單單身檔
                  #LET l_sql2= " UPDATE ",l_dbs_tra CLIPPED,"oeb_file", #FUN-980093 add
                  LET l_sql2= " UPDATE ",cl_get_target_table(l_plant_new,'oeb_file'), #FUN-A50102
                              "    SET oeb04=?,oeb05=?,oeb06=?, oeb12=?, ",
                              "        oeb13=?,oeb14=?,oeb14t=?,oeb15=?, ",
                              "        oeb910=?,oeb911=?,oeb912=?,oeb913=?, ",   #FUN-560043
                              "        oeb914=?,oeb915=?,oeb916=?,oeb917=?, ",    #FUN-560043
                              "        oeb1001=?,oeb1002=?,oeb1003=?,oeb1004=?,", #FUN-620025
                              "        oeb1005=?,oeb1007=?,oeb1008=?,oeb1009=?,", #FUN-620025
                              "        oeb1010=?,oeb1011=?,oeb1012=?,oeb1006=? ", #FUN-620025-cl
                              "  WHERE oeb01 = ? AND oeb03 = ? "
 	              CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                  CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980093
                  PREPARE upd_oeb FROM l_sql2
                  EXECUTE upd_oeb USING
                     l_oeb.oeb04,l_oeb.oeb05,l_oeb.oeb06,l_oeb.oeb12,
                     l_oeb.oeb13,l_oeb.oeb14,l_oeb.oeb14t,l_oeb.oeb15,
                     l_oeb.oeb910,l_oeb.oeb911,l_oeb.oeb912,l_oeb.oeb913,   #FUN-560043
                     l_oeb.oeb914,l_oeb.oeb915,l_oeb.oeb916,l_oeb.oeb917,   #FUN-560043
                     l_oeb.oeb1001,l_oeb.oeb1002,l_oeb.oeb1003,l_oeb.oeb1004, #FUN-620025
                     l_oeb.oeb1005,l_oeb.oeb1007,l_oeb.oeb1008,l_oeb.oeb1009, #FUN-620025
                     l_oeb.oeb1010,l_oeb.oeb1011,l_oeb.oeb1012,l_oeb.oeb1006, #FUN-620025-cl
                     l_oeb.oeb01,l_oeb.oeb03
                  IF SQLCA.SQLCODE THEN
                     CALL s_errmsg('','','upd oeb:',SQLCA.sqlcode,1)  #No.FUN-710033  #No.FUN-870007 0->1 
                     LET g_success = 'N'
                     RETURN
                  END IF
               ELSE
                  IF l_stu_o='F' THEN                          #FUN-620025-cl
                     CALL s_errmsg('','',g_pmm.pmm99,"apm-803",1)   #No.FUN-710033 #No.FUN-870007 0->1
                     LET g_success = 'N'                       #FUN-620025-cl
                     EXIT FOREACH             #No.FUN-710033  
                  END IF                                                                                                           
               END IF
            END IF
            #新增至暫存檔中
            IF g_azw.azw04 <> '2' THEN  #No.FUN-870007
            INSERT INTO t254_file VALUES(i,g_pmm.pmm01,g_pmn.pmn02,
                                         l_pmn.pmn31,l_pmm.pmm22)
            IF SQLCA.sqlcode<>0 THEN
               CALL s_errmsg('','','ins p00_file:',SQLCA.sqlcode,0) #No.FUN-710033
               LET g_success = 'N'
               RETURN
            END IF
            END IF #No.FUN-870007
            #訂單單頭總金額
            LET l_oea.oea61 = l_oea.oea61 + l_oeb.oeb14
            CALL cl_digcut(l_oea.oea61,l_azi.azi04)
               RETURNING l_oea.oea61
            #在分銷系統中，訂單單頭未稅總金額
            IF l_aza.aza50 = 'Y' THEN
               LET l_oea.oea1008 = l_oea.oea1008 + l_oeb.oeb14t
                   CALL cl_digcut(l_oea.oea1008,l_azi.azi04)
                      RETURNING l_oea.oea1008
            END IF
         END FOREACH {oeb_cus}
 
         #新增採購單頭檔
         IF l_stu_p='I' THEN                           #FUN-620025-cl 
            IF NOT ( i = p_last AND cl_null(g_pmm.pmm50)) THEN
               #LET l_sql2="INSERT INTO ",l_dbs_tra CLIPPED,"pmm_file", #FUN-980093 add
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
                   " pmm51,pmm52,pmm53,pmmplant,pmmlegal,",     #No.FUN-870007
                   " pmmconu,pmmcond,pmmcont,pmmpos,",          #No.FUN-870007
                   " pmm99,pmm901,pmm902,",
                   " pmm903,pmm904,pmm905,pmm906, ",
                   " pmmprsw,pmmprno,pmmprdt,pmmmksg,",
                   " pmmsign,pmmdays,pmmprit,pmmsseq,",
                   " pmmsmax,pmmacti,pmmuser,pmmgrup,",
                   " pmmmodu,pmmdate,pmm40t,pmm909,pmmoriu,pmmorig) ",     #FUN-620025 #No.FUN-620054 #FUN-A10036
                   " VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                            "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                            "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                            "?,?,?,?, ?,?,?,?, ?,               ",        #No.FUN-870007
                            "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,?,?) "   #FUN-620025 #No.FUN-620054  #FUN-A10036
 	           CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
               CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
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
                  l_pmm.pmm51,l_pmm.pmm52,l_pmm.pmm53,l_pmm.pmmplant,l_pmm.pmmlegal,       #No.FUN-870007
                  l_pmm.pmmconu,l_pmm.pmmcond,l_pmm.pmmcont,l_pmm.pmmpos,                  #No.FUN-870007
                  l_pmm.pmm99,l_pmm.pmm901,l_pmm.pmm902,
                  l_pmm.pmm903,l_pmm.pmm904,l_pmm.pmm905,l_pmm.pmm906,
                  l_pmm.pmmprsw,l_pmm.pmmprno,l_pmm.pmmprdt,l_pmm.pmmmksg,
                  l_pmm.pmmsign,l_pmm.pmmdays,l_pmm.pmmprit,l_pmm.pmmsseq,
                  l_pmm.pmmsmax,l_pmm.pmmacti,l_pmm.pmmuser,l_pmm.pmmgrup,
                  l_pmm.pmmmodu,l_pmm.pmmdate,l_pmm.pmm40t,l_pmm.pmm909,g_user,g_grup    #FUN-620025 #No.FUN-620054  #FUN-A10036
                  IF SQLCA.sqlcode<>0 THEN
                     CALL s_errmsg ('','','ins pmm:',SQLCA.sqlcode,1) #No.FUN-710033 #No.FUN-870007 0->1   
                     LET g_success = 'N'
                     CONTINUE FOREACH   #No.FUN-710033
                  END IF
            END IF
         ELSE
            #更新採購單頭檔
            IF l_stu_p='U' THEN               #FUN-620025-cl
              IF NOT ( i = p_last AND cl_null(g_pmm.pmm50)) THEN
                 #LET l_sql2="UPDATE ",l_dbs_tra CLIPPED,"pmm_file", #FUN-980093 add
                 LET l_sql2="UPDATE ",cl_get_target_table(l_plant_new,'pmm_file'), #FUN-A50102
                            "  SET pmm03=?,pmm09=?,pmm10=?,pmm20=?,pmm21=?, ",
                            "      pmm22=?,pmm40=?,pmm42=?,pmm43=?,pmm40t=? ", #FUN-620025
                            " WHERE pmm99 = ? "
 	             CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                 CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980093
                 PREPARE upd_pmm FROM l_sql2
                 EXECUTE upd_pmm USING g_pmm.pmm03,l_pmm.pmm09,l_pmm.pmm10,
                    l_pmm.pmm20,l_pmm.pmm21,l_pmm.pmm22,l_pmm.pmm40,
                    l_pmm.pmm42,l_pmm.pmm43,l_pmm.pmm40t,   #FUN-620025
                    l_pmm.pmm99
                 IF SQLCA.SQLCODE THEN
                    CALL s_errmsg('','','upd pmm:',SQLCA.sqlcode,0) #No.FUN-710033  
                    LET g_success = 'N'
                    CONTINUE  FOREACH    #No.FUN-710033 
                 END IF
              END IF
           ELSE                                                     
              IF l_stu_p='F' THEN                          #FUN-620025-cl
                 CALL s_errmsg('','',g_pmm.pmm99,"apm-803",1)   #No.FUN-710033
                 LET g_success = 'N'                       #FUN-620025-cl
                 CONTINUE FOREACH          #No.FUN-710033 
              END IF                                                 
           END IF     
         END IF
         #start FUN-570252 拋轉採購單特別說明
         IF g_poz.poz10 = 'Y' THEN
            DECLARE pmo_cs CURSOR FOR
             SELECT * FROM pmo_file WHERE pmo01 = g_pmm.pmm01   #FUN-620025
            FOREACH pmo_cs INTO l_pmo.*
               #將特別說明寫入特別說明檔pmo_file
               IF l_stu_p='I' THEN                                    #FUN-620025-cl
                  #LET l_sql2 = "INSERT INTO ",l_dbs_tra CLIPPED,"pmo_file", #FUN-980093 add
                  LET l_sql2 = "INSERT INTO ",cl_get_target_table(l_plant_new,'pmo_file'), #FUN-A50102
                               " (pmo01,pmo02,pmo03,pmo04,pmo05,pmo06,pmoplant,pmolegal) ", #FUN-980093 add
                               " VALUES (?,?,?,?,?,?,?,?) " #FUN-980093 add ?,?
 	              CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                  CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
                  PREPARE ins_pmo FROM l_sql2
                  EXECUTE ins_pmo USING l_pmo.pmo01,l_pmo.pmo02,
                                        l_pmo.pmo03,l_pmo.pmo04,
                                        l_pmo.pmo05,l_pmo.pmo06,l_pmo.pmoplant,l_pmo.pmolegal #FUN-980093 add plant,legal
                  IF SQLCA.sqlcode<>0 THEN
                    LET g_msg = l_dbs_tra CLIPPED,"ins pmo"       
                    CALL cl_err(g_msg,SQLCA.sqlcode,0)      
                     CALL s_errmsg('','',g_msg,SQLCA.sqlcode,1)
                     LET g_success = 'N'
                     EXIT FOREACH    #No.FUN-710033       
                  END IF
               ELSE
                  IF l_stu_p='U' THEN  #FUN-620025-cl 
                    IF g_pod.pod04 = 'N' THEN
                       LET l_sql2 = "SELECT pmm01 ",
                                    #" FROM ",l_dbs_tra CLIPPED,"pmm_file ", #FUN-980093 add
                                    " FROM ",cl_get_target_table(l_plant_new,'pmm_file'), #FUN-A50102
                                    " WHERE pmm99= ",g_pmm.pmm99
 	                   CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                       CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980093
                       PREPARE pmo_p1 FROM l_sql2
                       IF SQLCA.SQLCODE THEN 
                       CALL s_errmsg('pmm99',g_pmm.pmm99,'pmo_p1',SQLCA.sqlcode,1) #No.FUN-710033   
                       END IF
                       DECLARE pmo_c1 CURSOR FOR pmo_p1
                       OPEN pmo_c1
                       FETCH pmo_c1 INTO l_pmo.pmo01
                       CLOSE pmo_c1
                    END IF
                    #LET l_sql2 = " UPDATE ",l_dbs_tra CLIPPED,"pmo_file",  #FUN-980093 add
                    LET l_sql2 = " UPDATE ",cl_get_target_table(l_plant_new,'pmo_file'), #FUN-A50102
                                 "    SET pmo06=? ",
                                 "  WHERE pmo01 = ? AND pmo02 = ? ",
                                 "    AND pmo03 = ? AND pmo04 = ? ",
                                 "    AND pmo05 = ? "
 	                CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                    CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980093
                    PREPARE upd_pmo FROM l_sql2
                    EXECUTE upd_pmo USING l_pmo.pmo06,
                                          l_pmo.pmo01,l_pmo.pmo02,l_pmo.pmo03,
                                          l_pmo.pmo04,l_pmo.pmo05
                    IF SQLCA.SQLCODE THEN
                      LET g_msg = l_dbs_tra CLIPPED,"upd pmo"    #FUN-980093 add     
                      CALL cl_err(g_msg,SQLCA.sqlcode,1)                             
                       CALL s_errmsg('','',g_msg,SQLCA.sqlcode,1) #No.FUN-710033
                       LET g_success = 'N'
                       EXIT FOREACH       #No.FUN-710033       
                    END IF
                 ELSE      
                    IF l_stu_p='F' THEN                       #FUN-620025-cl 
                       CALL s_errmsg('','',g_pmm.pmm99,"apm-803",0)  #No.FUN-710033 
                       LET g_success = 'N'                  #FUN-620025-cl
                       EXIT FOREACH      #No.FUN-710033    
                    END IF                                            
                 END IF                                         #FUN-620025-cl
               END IF
               #將特別說明寫入訂單備註檔oao_file
               IF l_stu_o='I' THEN                 #FUN-620025-cl  
                  #LET l_sql2 = "INSERT INTO ",l_dbs_new CLIPPED,"oao_file",
                  LET l_sql2 = "INSERT INTO ",cl_get_target_table(l_plant_new,'oao_file'), #FUN-A50102
                               " (oao01,oao03,oao04,oao05,oao06) ",
                               " VALUES (?,?,?,?,?) "
                  CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                  CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
                  PREPARE ins_oao FROM l_sql2
                  EXECUTE ins_oao USING l_pmo.pmo01,l_pmo.pmo03,
                                        l_pmo.pmo05,l_pmo.pmo04,
                                        l_pmo.pmo06
                  IF SQLCA.sqlcode<>0 THEN
                    LET g_msg = l_dbs_new CLIPPED,"ins oao"        
                    CALL cl_err(g_msg,SQLCA.sqlcode,0)             
                     CALL s_errmsg('','',g_msg,SQLCA.sqlcode,1) #No.FUN-710033
                     LET g_success = 'N'  
                     EXIT FOREACH         #No.FUN-710033
                  END IF
               ELSE
                  IF l_stu_o='U' THEN  #FUN-620025-cl
                     #LET l_sql2 = " UPDATE ",l_dbs_new CLIPPED,"oao_file",
                     LET l_sql2 = " UPDATE ",cl_get_target_table(l_plant_new,'oao_file'), #FUN-A50102
                                  "    SET oao06=? ",
                                  "  WHERE oao01 = ? AND oao03 = ? ",
                                  "    AND oao04 = ? AND oao05 = ? "
 	                 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                     CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
                     PREPARE upd_oao FROM l_sql2
                     EXECUTE upd_oao USING l_pmo.pmo06,
                                           l_pmo.pmo01,l_pmo.pmo03,
                                           l_pmo.pmo05,l_pmo.pmo04
                     IF SQLCA.SQLCODE THEN
                       LET g_msg = l_dbs_new CLIPPED,"upd oao"       
                       CALL cl_err(g_msg,SQLCA.sqlcode,0)            
                        CALL s_errmsg('','',g_msg,SQLCA.sqlcode,1)#No.FUN-710033     
                        LET g_success = 'N'
                        EXIT FOREACH    #No.FUN-710033
                     END IF
                  ELSE                                                                                                             
                     IF l_stu_o='F' THEN                       #FUN-620025-cl
                        CALL s_errmsg('','',g_pmm.pmm99,"apm-803",0)  #No.FUN-710033
                        LET g_success = 'N'                    #FUN-620025-cl
                        EXIT FOREACH        #No.FUN-710033
                     END IF                                      
                  END IF
               END IF
            END FOREACH
         END IF
 
         #新增訂單單頭檔
         IF l_stu_o='I' THEN               #FUN-620025-cl  
            #LET l_sql2="INSERT INTO ",l_dbs_tra CLIPPED,"oea_file",  #FUN-980093 add
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
                       "  oea34, oea35, oea36, oea38, ",
                       "  oea41, oea42, oea43, oea44, ",
                       "  oea45, oea46, oea47, oea48, ",
                       "  oea49, oea50, oea51, oea52, ",
                       "  oea53, oea54, oea55, oea56, ",
                       "  oea57, oea58, oea59, oea61, ",
                       "  oea62, oea63, oea71, oea72, ",
                       "  oea83, oea84, oea85, oeaplant,",   #No.FUN-870007
                       "  oealegal,oeaconu,oeacont,",        #No.FUN-870007
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
                       "  oea1012,oea1013,oea1014,oea65,oeaoriu,oeaorig ) ",   #FUN-A10036
                       " VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                       "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                       "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                       "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                       "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                       "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                       "         ?,?,?,?, ?,?,?,                    ", #No.FUN-870007
                       "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,?,? )"  #FUN-A10036
 	        CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
            CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980093
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
                l_oea.oea34, l_oea.oea35, l_oea.oea36, l_oea.oea38,
                l_oea.oea41, l_oea.oea42, l_oea.oea43, l_oea.oea44,
                l_oea.oea45, l_oea.oea46, l_oea.oea47, l_oea.oea48,
                l_oea.oea49, l_oea.oea50, l_oea.oea51, l_oea.oea52,
                l_oea.oea53, l_oea.oea54, l_oea.oea55, l_oea.oea56,
                l_oea.oea57, l_oea.oea58, l_oea.oea59, l_oea.oea61,
                l_oea.oea62, l_oea.oea63, l_oea.oea71, l_oea.oea72,
                l_oea.oea83, l_oea.oea84, l_oea.oea85, l_oea.oeaplant,    #No.FUN-870007
                l_oea.oealegal,l_oea.oeaconu,l_oea.oeacont,               #No.FUN-870007
                l_oea.oea99, l_oea.oea901,l_oea.oea902,l_oea.oea903,
                l_oea.oea904,l_oea.oea905,l_oea.oea906,l_oea.oea907,
                l_oea.oea908,l_oea.oea909,l_oea.oea911,l_oea.oea912,
                l_oea.oea913,l_oea.oea914,l_oea.oea915,l_oea.oea916,
                l_oea.oeamksg,l_oea.oeasign,l_oea.oeadays,l_oea.oeaprit,
                l_oea.oeasseq,l_oea.oeasmax,l_oea.oeahold,l_oea.oeaconf,
                l_oea.oeaprsw,l_oea.oeauser,l_oea.oeagrup,l_oea.oeamodu,
                l_oea.oeadate,l_oea.oea1001,l_oea.oea1002,l_oea.oea1003,
                l_oea.oea1004,l_oea.oea1005,l_oea.oea1006,l_oea.oea1007,
                l_oea.oea1008,l_oea.oea1009,l_oea.oea1010,l_oea.oea1011,
                l_oea.oea1012,l_oea.oea1013,l_oea.oea1014,l_oea.oea65,g_user,g_grup  #FUN-A10036
            IF SQLCA.sqlcode<>0 THEN
               CALL s_errmsg('','','ins oea:',SQLCA.sqlcode,1) #No.FUN-710033  #No.FUN-870007 0->1
               LET g_success = 'N'
               CONTINUE FOREACH          #No.FUN-710033 
            END IF
         ELSE
            IF l_stu_o='U' THEN  #FUN-620025-cl 
            #更新訂單單頭檔
              #LET l_sql2="UPDATE ",l_dbs_tra CLIPPED,"oea_file",  #FUN-980093 add
              LET l_sql2="UPDATE ",cl_get_target_table(l_plant_new,'oea_file'), #FUN-A50102
                         " SET  oea04=?,oea044=?,oea06=?,oea21=?,",
                         "     oea211=?,oea212=?,oea213=?,oea32=?, ",
                         "     oea61=?  ",
                         " WHERE oea99 = ? "
 	          CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
              CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980093
              PREPARE upd_oea FROM l_sql2
              EXECUTE upd_oea USING
                 l_oea.oea04,l_oea.oea044,l_oea.oea06,l_oea.oea21,
                 l_oea.oea211,l_oea.oea212,l_oea.oea213,l_oea.oea32,
                 l_oea.oea61, l_oea.oea99
              IF SQLCA.SQLCODE THEN
                 CALL s_errmsg('','','upd oea:',SQLCA.sqlcode,1) #No.FUN-710033 #No.FUN-870007 0->1   
                 LET g_success = 'N'
                 CONTINUE FOREACH   #No.FUN-710033
              END IF
            ELSE                                                                                                                   
              IF l_stu_o = 'F' THEN                      #FUN-620025-cl
                 CALL s_errmsg('','',g_pmm.pmm99,"apm-803",1) #No.FUN-710033    
                 LET g_success = 'N'                     #FUN-620025-cl
                 CONTINUE FOREACH             #No.FUN-710033
              END IF                                               
            END IF
         END IF
         #若單身之計價方式有所不同時, 提出警告訊息
         IF diff_azi='Y'  THEN
            LET l_msg = cl_getmsg('apm-303',g_lang)
            LET l_msg=l_msg CLIPPED,"(",g_pmm.pmm01,"+",p_poy04,"):"
            CALL cl_msgany(10,20,l_msg)
         END IF
      END FOR  {一個訂單流程代碼結束}
      #更新採購單檔之三角貿易拋轉否='Y',起始採購單否='Y'
      MESSAGE ''
      #LET l_sql = " UPDATE ",p_dbs_tra CLIPPED,"pmm_file ", #FUN-980093 add
      LET l_sql = " UPDATE ",cl_get_target_table(p_plant,'pmm_file'), #FUN-A50102
                  "    SET pmm905 = 'Y', ",
                  "        pmm906 = 'Y' ",
                  "  WHERE pmm01  = '",g_pmm.pmm01,"' "
 	  CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
      CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980093
      PREPARE upd_pmm2 FROM l_sql
      EXECUTE upd_pmm2
      IF SQLCA.SQLCODE <> 0 OR sqlca.sqlerrd[3]=0 THEN
         CALL s_errmsg('','','upd pmm',STATUS,1)   #No.FUN-710033 
         LET g_success='N'
         EXIT FOREACH
      END IF
   END FOREACH
      IF g_totsuccess="N" THEN
           LET g_success="N"
      END IF 
END FUNCTION
 
FUNCTION t254_azp_1(p_plant,l_i) #FUN-980093 add
   DEFINE p_dbs      LIKE type_file.chr21,            #No.FUN-680120 VARCHAR(21)
          l_source   LIKE type_file.num5,             #No.FUN-680120 SMALLINT #上一站
          l_i        LIKE type_file.num5,   #當站     #No.FUN-680120 SMALLINT
          l_next     LIKE type_file.num5,             #No.FUN-680120 SMALLINT #下一站
          l_sql      STRING, #TQC-750235 
          l_sql1     STRING, #TQC-750235
          n_poy      RECORD LIKE poy_file.*
DEFINE l_poy04 LIKE poy_file.poy04         #No.FUN-870007
   DEFINE p_dbs_tra       LIKE azw_file.azw05        #FUN-980093 add
   DEFINE p_plant_new     LIKE azp_file.azp01        #FUN-980093 add
   DEFINE p_plant         LIKE azp_file.azp01        #FUN-980093 add
 
   #--Begin FUN-980093 add----GP5.2 Modify #改抓Transaction DB
     LET g_plant_new = p_plant
     CALL s_getdbs()
     LET p_dbs = g_dbs_new
     LET p_plant_new = g_plant_new
     CALL s_gettrandbs()
     LET p_dbs_tra = g_dbs_tra
   #--End   FUN-980093 add-------------------------------------
 
 
   ##-------------取得上一站資料(帳款客戶)------------
   LET l_source = l_i - 1
    SELECT poy03,poy04 INTO p_oea03,l_poy04
        FROM poy_file
       WHERE poy01 = g_poz.poz01
         AND poy02 = l_source
      IF SQLCA.SQLCODE THEN 
         CALL cl_err3("sel","poy_file",g_poz.poz01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104 
         LET g_success = 'N'
         RETURN
      END IF
   SELECT azp03 INTO l_azp.azp03 FROM azp_file WHERE azp01 = l_poy04  #No.FUN-870007
   LET l_dbname = s_dbstring(l_azp.azp03 CLIPPED)                     #No.FUN-870007
   ##-------------取得當站資料庫(S/O)-----------------
   LET l_sql = " SELECT * FROM poy_file ",
               "  WHERE poy01 = '",g_poz.poz01,"' ",
               "    AND poy02 = ",l_i," "
   PREPARE poy_pre FROM l_sql
   EXECUTE poy_pre INTO g_poy.*
   IF SQLCA.SQLCODE THEN 
      CALL cl_err('poy_file',SQLCA.SQLCODE,0) 
      LET g_success = 'N'
      RETURN
   END IF
   SELECT * INTO l_azp.* FROM azp_file WHERE azp01 = g_poy.poy04
   LET l_dbs_new = s_dbstring(l_azp.azp03 CLIPPED) #TQC-940184    
   LET l_plant_new = g_poy.poy04           #No.FUN-980059
   LET g_plant_new = g_poy.poy04 #FUN-980093 add
   CALL s_gettrandbs() #FUN-980093 add
   LET l_dbs_tra = g_dbs_tra  #FUN-980093 add
   LET l_sql1 = "SELECT * ",                         #取得來源本幣
                #" FROM ",l_dbs_new CLIPPED,"aza_file ",
                " FROM ",cl_get_target_table(l_plant_new,'aza_file'), #FUN-A50102
                " WHERE aza01 = '0' "
   CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
   CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-A50102
   PREPARE aza_p1 FROM l_sql1
   IF SQLCA.SQLCODE THEN 
      CALL cl_err('aza_p1',SQLCA.SQLCODE,0)
      LET g_success = 'N'
      RETURN
   END IF
   DECLARE aza_c1 CURSOR FOR aza_p1
   OPEN aza_c1
   FETCH aza_c1 INTO l_aza.*
   CLOSE aza_c1
   LET l_sql1 = "SELECT * ",
                #" FROM ",l_dbs_new CLIPPED,"sma_file ",
                " FROM ",cl_get_target_table(l_plant_new,'sma_file'), #FUN-A50102
                " WHERE sma00= '0' "
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-A50102
   PREPARE sma_p1 FROM l_sql1
   IF SQLCA.SQLCODE THEN 
      CALL cl_err('sma_p1',SQLCA.sqlcode,0)
      LET g_success = 'N'
      RETURN
   END IF
   DECLARE sma_c1 CURSOR FOR sma_p1
   OPEN sma_c1
   FETCH sma_c1 INTO l_sma.*
   CLOSE sma_c1
   LET p_poy04  = g_poy.poy04
   LET p_azi01t = g_poy.poy05
   LET p_poy07  = g_poy.poy07    #收款條件
   LET p_poy08  = g_poy.poy08    #SO稅別
   LET p_poy10  = g_poy.poy10    #銷售分類
   LET p_poy12  = g_poy.poy12    #發票別
   LET p_poy26  = g_poy.poy26    #是否計算業績
   LET p_poy27  = g_poy.poy27    #業績歸屬方
   LET p_poy28  = g_poy.poy28    #原因碼
   LET p_poy29  = g_poy.poy29    #代送商
   LET p_poy33  = g_poy.poy33    #債權代碼
 
   ##-------------取得下一站資料(P/O)-----------------
   LET l_next = l_i + 1
   LET l_sql = " SELECT * ",               #取得當站流程設定
               "   FROM poy_file ",
               "  WHERE poy01 = '",g_poz.poz01,"' ",
               "    AND poy02 = ",l_next," "
   PREPARE poy1_pre FROM l_sql
   EXECUTE poy1_pre INTO n_poy.*
   IF SQLCA.SQLCODE AND SQLCA.SQLCODE != 100 THEN 
      CALL cl_err('poy_file',SQLCA.SQLCODE,0) 
      LET g_success = 'N'
      RETURN
   END IF
   IF SQLCA.SQLCODE != 100 THEN
      LET p_pmm09 = n_poy.poy03   #廠商代號
      LET p_azi01 = n_poy.poy05   #採購幣別
      LET p_poy06 = n_poy.poy06   #付款條件
      LET p_poy09 = n_poy.poy09   #PO稅別
   ELSE
      IF l_i = p_last AND NOT cl_null(g_pmm.pmm50) THEN
         LET p_pmm09 = g_pmm.pmm50
         LET l_sql1 = "SELECT pmc17,pmc22,pmc47 ", #慣用付款方式及稅別
                      #"  FROM ",l_dbs_new CLIPPED,"pmc_file ",
                      "  FROM ",cl_get_target_table(l_plant_new,'pmc_file'), #FUN-A50102
                      " WHERE pmc01 = '",g_pmm.pmm50,"'"
 	     CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
         CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-A50102
         PREPARE pmm_prepare FROM l_sql1
         IF STATUS THEN CALL cl_err('pmm_p1',STATUS,1) END IF
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
FUNCTION t254_curr(l_i,l_pmm01,l_pmm22)
  DEFINE l_i LIKE type_file.num5,          #No.FUN-680120 SMALLINT
         l_pmm01 LIKE pmm_file.pmm01,
         l_pmm22 LIKE pmm_file.pmm22,
         l_cnt LIKE type_file.num5,          #No.FUN-680120 SMALLINT
         l_azi01   LIKE azi_file.azi01,
         l_pox05   LIKE pox_file.pox05,  #計價方式
         l_pmn33   LIKE pmn_file.pmn33 ,
         min_pmn33 LIKE pmn_file.pmn33
     LET l_cnt = 0
     #讀取採購單單身檔(pmn_file)
     DECLARE pmn_cus3 CURSOR FOR
        SELECT pmn33
          FROM pmn_file
         WHERE pmn01 = l_pmm01
     FOREACH pmn_cus3 INTO l_pmn33
        IF SQLCA.SQLCODE <>0 THEN EXIT FOREACH END IF
        LET l_cnt=l_cnt+1
        #讀取該料號之計價方式(依流程代碼+生效日期+廠商)
        CALL s_pox(g_pmm.pmm904,l_i,g_pmn.pmn33)
          RETURNING p_pox03,p_pox05,p_pox06,p_cnt
        IF p_cnt = 0 THEN
           CALL cl_err('','tri-007',1)
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
FUNCTION t254_azi(p_plant,l_pmm22) #FUN-980093 add
   DEFINE p_dbs   LIKE type_file.chr21        #No.FUN-680120 VARCHAR(21)
   DEFINE l_sql1  STRING #TQC-750235
   DEFINE l_pmm22  LIKE pmm_file.pmm22
   DEFINE p_dbs_tra       LIKE azw_file.azw05        #FUN-980093 add
   DEFINE p_plant_new     LIKE azp_file.azp01        #FUN-980093 add
   DEFINE p_plant         LIKE azp_file.azp01        #FUN-980093 add
 
   #--Begin FUN-980093 add----GP5.2 Modify #改抓Transaction DB
   #  LET g_plant_new = p_plant  #FUN-A50102
   #  CALL s_getdbs()
   #  LET p_dbs = g_dbs_new
   #  LET p_plant_new = g_plant_new
   #  CALL s_gettrandbs()
   #  LET p_dbs_tra = g_dbs_tra
   #讀取l_dbs_new 之本幣資料
   LET l_sql1 = "SELECT * ",
                #" FROM ",p_dbs CLIPPED,"azi_file ",
                " FROM ",cl_get_target_table(p_plant,'azi_file'), #FUN-A50102
                " WHERE azi01='",l_pmm22,"' "
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,p_plant) RETURNING l_sql1 #FUN-A50102
   PREPARE azi_p1 FROM l_sql1
   IF STATUS THEN CALL cl_err('azi_p1',STATUS,0) END IF
   DECLARE azi_c1 CURSOR FOR azi_p1
   OPEN azi_c1
   FETCH azi_c1 INTO l_azi.*
   CLOSE azi_c1
END FUNCTION
 
#讀取帳款客戶相關之資料
FUNCTION t254_oea03(p_plant,l_occ01) #FUN-980093 add
   DEFINE l_sql1  STRING, #TQC-750235
          l_dbs  LIKE type_file.chr21,         #No.FUN-680120 VARCHAR(21)
          l_occ01 LIKE occ_file.occ01,
          l_occ02 LIKE occ_file.occ02,
          l_occ08 LIKE occ_file.occ08,
          l_occ11 LIKE occ_file.occ11,
          l_occ41 LIKE occ_file.occ41,  #No.FUN-870007
          l_occ43 LIKE occ_file.occ43,
          l_occ44 LIKE occ_file.occ44,
          l_occ45 LIKE occ_file.occ45,
          l_occ1005 LIKE occ_file.occ1005,
          l_occ1006 LIKE occ_file.occ1006,
          l_occ1022 LIKE occ_file.occ1022
   DEFINE p_dbs_tra       LIKE azw_file.azw05        #FUN-980093 add
   DEFINE p_dbs           LIKE azp_file.azp03        #FUN-980093 add
   DEFINE p_plant_new     LIKE azp_file.azp01        #FUN-980093 add
   DEFINE p_plant         LIKE azp_file.azp01        #FUN-980093 add
 
   #改抓Transaction DB
   #  LET g_plant_new = p_plant   #FUN-A50102
   #  CALL s_getdbs()
   #  LET p_dbs = g_dbs_new
   #  LET p_plant_new = g_plant_new
   #  CALL s_gettrandbs()
   #  LET p_dbs_tra = g_dbs_tra
 
   LET l_occ02=''  LET l_occ08=' ' LET l_occ11=' '
   LET l_occ43=''  LET l_occ44=' ' LET l_occ45=' '
   LET l_occ1005=''
   LET l_occ1006=''
   LET l_occ1022=''
   LET l_sql1 = "SELECT occ02,occ08,occ11,occ43,occ44,occ45, ",
                "occ41,",  #No.FUN-870007
                "       occ1005,occ1006,occ1022              ", #FUN-620025
                #" FROM ",p_dbs CLIPPED,"occ_file ", #FUN-980093 add
                " FROM ",cl_get_target_table(p_plant,'occ_file'), #FUN-A50102
                " WHERE occ01='",l_occ01,"' "
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,p_plant) RETURNING l_sql1 #FUN-A50102
   PREPARE occ_p1 FROM l_sql1
   IF STATUS THEN CALL cl_err('occ_p1',STATUS,1) END IF
   DECLARE occ_c1 CURSOR FOR occ_p1
   OPEN occ_c1
   FETCH occ_c1 INTO  l_occ02,l_occ08,l_occ11,l_occ43,l_occ44,l_occ45,
                      l_occ41,  #No.FUN-870007
                      l_occ1005,l_occ1006,l_occ1022                   #FUN-620025
   IF SQLCA.SQLCODE THEN
      LET g_msg=p_dbs CLIPPED,l_occ01 CLIPPED #FUN-980093 add
      CALL cl_err(g_msg CLIPPED,'mfg4106',0)
      LET g_success = 'N'
   END IF
   IF cl_null(l_occ44) THEN
      LET g_msg=p_dbs CLIPPED,l_occ01 CLIPPED #FUN-980093 add
      CALL cl_err(g_msg CLIPPED,'tri-016',0)
      LET g_success = 'N'
   END IF
   CLOSE occ_c1
   RETURN l_occ02,l_occ08,l_occ11,l_occ43,l_occ44,l_occ45,
          l_occ41, #No.FUN-870007
          l_occ1005,l_occ1006,l_occ1022                   #FUN-620025
END FUNCTION
 
#No.8083 取得多角序號
FUNCTION t254_flow99(p_plant) #FUN-980093 add
   DEFINE p_dbs   LIKE type_file.chr21,        #No.FUN-680120 VARCHAR(21)
          l_sql   LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
   DEFINE p_dbs_tra       LIKE azw_file.azw05        #FUN-980093 add
   DEFINE p_plant_new     LIKE azp_file.azp01        #FUN-980093 add
   DEFINE p_plant         LIKE azp_file.azp01        #FUN-980093 add
 
   #改抓Transaction DB
   #  LET g_plant_new = p_plant #FUN-A50102
   #  CALL s_getdbs()
   #  LET p_dbs = g_dbs_new
   #  LET p_plant_new = g_plant_new
   #  CALL s_gettrandbs()
   #  LET p_dbs_tra = g_dbs_tra
   
   IF NOT cl_null(g_pmm.pmm99) THEN   #若訂單重拋時，不重取序號
      LET g_flow99 = g_pmm.pmm99
   END IF
   IF cl_null(g_pmm.pmm99) AND g_pmm.pmm905='N' THEN
      CALL t254_s_flowauno('pmm',g_pmm.pmm904,g_pmm.pmm04,p_plant) #FUN-980093 add
         RETURNING g_sw,g_flow99
      IF g_sw THEN
         CALL cl_err('','tri-011',0)
         LET g_success = 'N' 
         RETURN
      END IF
      #LET l_sql = " UPDATE ",p_dbs_tra CLIPPED,"pmm_file SET pmm99 = '",g_flow99,"' ", #FUN-980093 add
      LET l_sql = " UPDATE ",cl_get_target_table(p_plant,'pmm_file')," SET pmm99 = '",g_flow99,"' ", #FUN-A50102
                  "                                WHERE pmm01 = '",g_pmm.pmm01,"' "
 	  CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
      CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980093
      PREPARE up_pmm_pre FROM l_sql
      EXECUTE up_pmm_pre
      IF SQLCA.SQLCODE THEN
         CALL cl_err('upd pmm99',SQLCA.SQLCODE,0)
         LET g_success = 'N' 
         RETURN
      END IF
      #馬上檢查是否有搶號
      LET g_cnt = 0
      LET l_sql = " SELECT COUNT(*) ",
                  "   FROM pmm_file ",
                  "  WHERE pmm99 = '",g_flow99,"' "
      PREPARE sel_pmm99 FROM l_sql
      EXECUTE sel_pmm99 INTO g_cnt 
      IF g_cnt > 1 THEN
         CALL cl_err('','tri-011',1)
         LET g_success = 'N' 
         RETURN
      END IF
   END IF
END FUNCTION
 
FUNCTION t254_pod(p_plant) #FUN-980093 add
   DEFINE p_dbs   LIKE type_file.chr21,          #No.FUN-680120 VARCHAR(21)
          l_sql   LIKE type_file.chr1000         #No.FUN-680120 VARCHAR(100)
   DEFINE p_dbs_tra       LIKE azw_file.azw05        #FUN-980093 add
   DEFINE p_plant_new     LIKE azp_file.azp01        #FUN-980093 add
   DEFINE p_plant         LIKE azp_file.azp01        #FUN-980093 add
 
   #改抓Transaction DB
   #  LET g_plant_new = p_plant  #FUN-A50102
   #  CALL s_getdbs()
   #  LET p_dbs = g_dbs_new
   #  LET p_plant_new = g_plant_new
   #  CALL s_gettrandbs()
   #  LET p_dbs_tra = g_dbs_tra
   
   #LET l_sql = " SELECT * FROM ",p_dbs CLIPPED,"pod_file "
   LET l_sql = " SELECT * FROM ",cl_get_target_table(p_plant,'pod_file') #FUN-A50102
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
   PREPARE sel_pod FROM l_sql
   EXECUTE sel_pod INTO g_pod.*
   IF SQLCA.SQLCODE THEN
      CALL cl_err('sel pod',SQLCA.SQLCODE,0)
      LET g_success='N' 
      RETURN
  END IF
     
END FUNCTION
 
FUNCTION t254_poz(p_plant) #FUN-980093 add
   DEFINE p_dbs   LIKE type_file.chr21            #No.FUN-680120 VARCHAR(21)
   DEFINE p_plant LIKE azp_file.azp01  #FUN-980093 add
   
   SELECT * INTO g_poz.* 
     FROM poz_file
    WHERE poz01 = g_pmm.pmm904
      AND poz00 = '2' 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","poz_file",g_pmm.pmm904,"","axm-318","","",1)  #No.FUN-660104
      LET g_success = 'N'
      RETURN
   END IF
   IF g_poz.pozacti = 'N' THEN
      CALL cl_err(g_pmm.pmm904,'tri-009',0)
      LET g_success = 'N'
      RETURN
   END IF
END FUNCTION     
 
FUNCTION t254_s_flowauno(p_file,p_flow,p_date,p_plant) #FUN-980093 add
   DEFINE p_file          LIKE type_file.chr3,               #No.FUN-680120 VARCHAR(3)                   #檔名
          p_date          LIKE type_file.dat,              #No.FUN-680120 DATE                      #單據日期
          p_flow          LIKE type_file.chr8,             #No.FUN-680120 VARCHAR(8)                    #流程代碼
          p_flow_o        LIKE type_file.chr8,             #No.FUN-680120 VARCHAR(8)                    #流程代碼
          p_dbs           LIKE type_file.chr21,            #No.FUN-680120 VARCHAR(21)
          l_i             LIKE type_file.num5,          #No.FUN-680120 SMALLINT
          l_sql           LIKE type_file.chr1000,       #No.FUN-680120 VARCHAR(200)
          g_flowauno_mxno LIKE pmm_file.pmm99,
          g_forupd_sql    STRING,  #SELECT ... FOR UPDATE SQL
          l_slip99        LIKE bnb_file.bnb06,     #No.FUN-680120 VARCHAR(17)                    #多角序號   #FUN-560043
          l_buf           LIKE type_file.chr1000,  #FUN-560043        #No.FUN-680120 VARCHAR(13)
          l_mxno          LIKE type_file.chr8,             #No.FUN-680120 VARCHAR(08)
          l_date          LIKE aab_file.aab02,               #No.FUN-680120  VARCHAR(06)
          l_date1         LIKE aab_file.aab02,              # Prog. Version..: '5.30.06-13.03.12(04) #TQC-840066
          g_message       LIKE type_file.chr1000,       #No.FUN-680120  VARCHAR(70)
          g_year          LIKE type_file.num5,          #No.FUN-680120  SMALLINT
          g_month         LIKE type_file.num5           #No.FUN-680120  SMALLINT
   DEFINE p_dbs_tra       LIKE azw_file.azw05        #FUN-980093 add
   DEFINE p_plant_new     LIKE azp_file.azp01        #FUN-980093 add
   DEFINE p_plant         LIKE azp_file.azp01        #FUN-980093 add
 
   #改抓Transaction DB
   #  LET g_plant_new = p_plant  #FUN-A50102
   #  CALL s_getdbs()
   #  LET p_dbs = g_dbs_new
   #  LET p_plant_new = g_plant_new
   #  CALL s_gettrandbs()
   #  LET p_dbs_tra = g_dbs_tra
   
   LET p_flow_o=p_flow
   FOR l_i = 1 TO 8
      IF p_flow[l_i,l_i] IS NULL  THEN 
         LET p_flow[l_i,l_i] = ' ' 
      END IF
   END FOR
   # 為了避免搶號,因此在 select poz_file時便作 lock,待取得單號後再release #
   CALL cl_getmsg('mfg8889',g_lang) RETURNING g_message
   MESSAGE g_message
   LET g_forupd_sql = "SELECT * FROM poz_file WHERE poz01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE pozauno_cl CURSOR FROM g_forupd_sql
   OPEN pozauno_cl USING p_flow_o     # MOD-510143
   IF SQLCA.sqlcode = "-243" THEN
      CALL cl_err('poz01:read poz:',SQLCA.sqlcode,1)
      CLOSE pozauno_cl 
      RETURN -1,''
   END IF
   FETCH pozauno_cl INTO g_poz.*      # 鎖住將的資料
   IF SQLCA.sqlcode = "-243" THEN
      CALL cl_err('poz01:read poz:',SQLCA.sqlcode,1)
      CLOSE pozauno_cl 
      RETURN -1,''
   END IF
   LET l_sql = " SELECT azn02,azn04 ",
               #"   FROM ",p_dbs CLIPPED,"azn_file ",
               "   FROM ",cl_get_target_table(p_plant,'azn_file'), #FUN-A50102
               "  WHERE azn01 = '",p_date,"' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
   PREPARE azn_pre FROM l_sql
   EXECUTE azn_pre INTO g_year,g_month
   IF SQLCA.sqlcode THEN 
      LET g_year  = YEAR(p_date)
      LET g_month = MONTH(p_date)
   END IF
   IF g_poz.poz11 = '1' THEN    #依流水
      CASE p_file
         WHEN 'oga'             #出貨單
             LET l_sql = " SELECT MAX(oga99) ",
                         #"   FROM ",p_dbs_tra CLIPPED,"oga_file ", #FUN-980093 add
                         "   FROM ",cl_get_target_table(p_plant,'oga_file'), #FUN-A50102
                         " WHERE oga99[1,8] = '",p_flow,"' "   #CHI-9B0005 mod
         WHEN 'pmm'             #採購單
             LET l_sql = " SELECT MAX(pmm99) ",
                         #"   FROM ",p_dbs_tra CLIPPED,"pmm_file ", #FUN-980093 add
                         "   FROM ",cl_get_target_table(p_plant,'pmm_file'), #FUN-A50102
                         "  WHERE pmm99[1,8] = '",p_flow,"' "  #CHI-9B0005 mod
         OTHERWISE EXIT CASE
      END CASE
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
       CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980093
      PREPARE pmm99_pre1 FROM l_sql
      EXECUTE pmm99_pre1 INTO g_flowauno_mxno
      IF SQLCA.sqlcode THEN
         CALL cl_err('max(pmm99)',SQLCA.sqlcode,0)
         CLOSE pozauno_cl 
         RETURN -1,''
      END IF
   ELSE                         #依年度期別
      LET l_date = g_year USING '&&&&',g_month USING '&&'
      LET l_date1[1,2]=l_date[3,4]  
      LET l_date1[3,4]=l_date[5,6]
      LET l_buf = p_flow,'-',l_date1 CLIPPED #TQC-840066
      CASE p_file
         WHEN 'oga'             #出貨單
            LET l_sql = " SELECT MAX(oga99) ",
                        #"   FROM ",p_dbs_tra CLIPPED,"oga_file ", #FUN-980093 add
                        "   FROM ",cl_get_target_table(p_plant,'oga_file'), #FUN-A50102
                        "  WHERE oga99[1,13] = '",l_buf,"' "  #CHI-9B0005 mod
         WHEN 'pmm'             #採購單
            LET l_sql = " SELECT MAX(pmm99) ",
                        #"   FROM ",p_dbs_tra CLIPPED,"pmm_file ", #FUN-980093 add
                        "   FROM ",cl_get_target_table(p_plant,'pmm_file'), #FUN-A50102
                        "  WHERE pmm99[1,13] = '",l_buf,"' "     #CHI-9B0005 mod
         OTHERWISE EXIT CASE
      END CASE    
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
      CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980093
      PREPARE pmm99_pre2 FROM l_sql
      EXECUTE pmm99_pre2 INTO g_flowauno_mxno
      IF SQLCA.sqlcode THEN
         CALL cl_err('max(pmm99)',SQLCA.sqlcode,0)
         CLOSE pozauno_cl 
         RETURN -1,''
      END IF
   END IF   
   LET l_mxno = g_flowauno_mxno[10,17]
   LET l_slip99[1,8] = p_flow_o
   IF cl_null(l_slip99[10,17]) THEN
      IF g_poz.poz11 = '1' THEN                       #依流水號
         IF cl_null(l_mxno) THEN                      #最大編號未曾指定
            LET l_mxno = '00000000'
         END IF
         LET l_slip99[10,17]=(l_mxno+1) USING '&&&&&&&&'
      ELSE                                            #依年月
         IF cl_null(l_mxno) THEN                      #最大編號未曾指定
            LET l_buf = g_year USING '&&&&',g_month USING '&&'
            LET l_mxno[1,2]=l_buf[3,4]
            LET l_mxno[3,4]=l_buf[5,6]
            LET l_mxno[5,8]='0000'
         END IF
         LET l_slip99[10,17]=l_mxno[1,4],(l_mxno[5,8]+1) USING '&&&&'
      END IF
   END IF
   LET l_slip99[9,9]='-'
   CLOSE pozauno_cl 
   RETURN 0,l_slip99
END FUNCTION
 
FUNCTION t254_s_pox(p_pmm904,p_i,p_pmn33,p_plant) #FUN-980093 add
   DEFINE p_pmm904   LIKE pmm_file.pmm904,
          p_i        LIKE type_file.num5,      #No.FUN-680120 SMALLINT
          p_pmn33    LIKE pmn_file.pmn33,
          p_dbs      LIKE type_file.chr21,     #No.FUN-680120 VARCHAR(21)
          p_pox03    LIKE pox_file.pox03,
          p_pox05    LIKE pox_file.pox05,
          p_pox06    LIKE pox_file.pox06,
          l_sql      LIKE type_file.chr1000,       #No.FUN-680120 VARCHAR(300)
          l_cnt      LIKE type_file.num5,          #No.FUN-680120 SMALLINT
          l_pox      RECORD LIKE pox_file.*
   DEFINE p_dbs_tra       LIKE azw_file.azw05        #FUN-980093 add
   DEFINE p_plant_new     LIKE azp_file.azp01        #FUN-980093 add
   DEFINE p_plant         LIKE azp_file.azp01        #FUN-980093 add
 
   #改抓Transaction DB
   #  LET g_plant_new = p_plant  #FUN-A50102
   #  CALL s_getdbs()
   #  LET p_dbs = g_dbs_new
   #  LET p_plant_new = g_plant_new
   #  CALL s_gettrandbs()
   #  LET p_dbs_tra = g_dbs_tra
          
   #判斷料號之計價方式(依流程代碼+預定交貨日)
   #讀取最近一筆之生效日期
   LET l_sql = " SELECT * ",
               #"   FROM ",p_dbs CLIPPED,"pox_file ",
               "   FROM ",cl_get_target_table(p_plant,'pox_file'), #FUN-A50102
               "  WHERE pox01 =  '",p_pmm904,"' ",      #流程代碼
               "    AND pox02 <= '",p_pmn33,"' ",       #預定交貨日
               "    AND pox04 =  ",p_i," ",             #站別
               "  ORDER BY pox02 DESC "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
   PREPARE t254_pox FROM l_sql
   DECLARE pox_p1 CURSOR FOR t254_pox
   LET l_cnt = 0 
   FOREACH pox_p1 INTO l_pox.*
      LET l_cnt = l_cnt + 1
      IF SQLCA.SQLCODE <> 0 THEN 
         CALL cl_err('sel pox:',STATUS,0) 
         EXIT FOREACH
      END IF
      LET p_pox03 = l_pox.pox03    #計價基準
      LET p_pox05 = l_pox.pox05    #計價方式
      LET p_pox06 = l_pox.pox06    #計價比率
      EXIT FOREACH
   END FOREACH
   RETURN p_pox03,p_pox05,p_pox06,l_cnt
END FUNCTION
 
#插入更新前對當前數據庫中的流程序號進行判斷
#FUNCTION t254_iou(p_pmm99,p_pmm905,p_plant,p_table)  #FUN-980093 add
FUNCTION t254_iou(p_pmm99,p_pmm905,p_plant,p_table,p_table1)   #FUN-A50102
DEFINE p_pmm99  LIKE pmm_file.pmm99,
       p_pmm905 LIKE pmm_file.pmm905
DEFINE p_stu    LIKE type_file.chr1,      #No.FUN-680120 VARCHAR(1)
       p_dbs    LIKE type_file.chr21,     #No.FUN-680120 VARCHAR(31)
       p_sql    LIKE type_file.chr1000,   #No.FUN-680120 VARCHAR(1000)
       p_table  LIKE apm_file.apm08,      #No.FUN-680120 VARCHAR(10)
       p_table1 LIKE apm_file.apm08,      #No.FUN-A50102 VARCHAR(10)
       p_n      LIKE type_file.num5       #No.FUN-680120 SMALLINT
   DEFINE p_dbs_tra       LIKE azw_file.azw05        #FUN-980093 add
   DEFINE p_plant_new     LIKE azp_file.azp01        #FUN-980093 add
   DEFINE p_plant         LIKE azp_file.azp01        #FUN-980093 add
 
   #改抓Transaction DB
     #LET g_plant_new = p_plant
     #CALL s_getdbs()            #FUN-A50102
     #LET p_dbs = g_dbs_new      #FUN-A50102
     #LET p_plant_new = g_plant_new
     #CALL s_gettrandbs()        #FUN-A50102
     #LET p_dbs_tra = g_dbs_tra  #FUN-A50102
 
  IF NOT cl_null(p_pmm99) THEN
     LET p_sql = " SELECT COUNT(*) ",
                 #" FROM ",p_dbs_tra CLIPPED,p_table CLIPPED,"_file ", #FUN-980093 add
                 " FROM ",cl_get_target_table(p_plant,p_table), #FUN-A50102
                 " WHERE ",p_table1 CLIPPED,"99='",p_pmm99,"'" 
 	 CALL cl_replace_sqldb(p_sql) RETURNING p_sql        #FUN-920032
     CALL cl_parse_qry_sql(p_sql,p_plant) RETURNING p_sql #FUN-980093
     PREPARE iou_p1 FROM p_sql
     IF STATUS THEN CALL cl_err('iou_p1',STATUS,1) END IF
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
           LET p_stu='F'
        END IF
     END IF 
  ELSE
     LET p_stu='I'
  END IF
  
   RETURN p_stu
 
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/18
