# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Program name...: s_auto_assign_no2.4gl
# Descriptions...: 依照系統別、單別自動編號  FUN-A30020
# Date & Author..: 10/02/22 by saki 翻寫
# Modify.........: No.FUN-A50068 10/05/25 By Cockroach 添加POS上傳自動編號相關
# Modify.........: No.FUN-A60044 10/07/21 By Cockroach '依TIME'編號目前只用於APC模組POS上傳
# Modify.........: No:FUN-A70130 10/08/06 By shiwuying AXM/ATM/ARM/ALM/ART单别统一整合的oay_file
# Modify.........: No.FUN-A80044 10/08/06 By Hiko 宣告變數不參考zld_file
# Modify.........: No.FUN-AA0046 10/10/22 By huangtao 取消用不到的模組判斷
# Modify.........: No.MOD-AB0108 10/11/11 By lilingyu ps_plant未轉化為大寫,導致從azw_file選不出資料而報錯
# Modify.........: No.TQC-AC0209 10/12/20 By huangrh  artt262的自動編碼錯誤
# Modify.........: No.TQC-AC0360 10/12/25 By sabrina  ps_lip.trim()取出來不會是數字 
# Modify.........: No.TQC-B10012 11/01/05 By huangrh  artt210產生的單據代號重複
# Modify.........: No.TQC-AC0124 11/01/06 By huangtao artt615 產生的編號重複
# Modify.........: No.FUN-B20022 11/02/11 By wangxin 自動編號選擇毫秒時調整 
# Modify.........: No.FUN-B50026 11/05/06 By zhangll 抓流水号最大号时按符合编码原则及码长来抓取
# Modify.........: No.TQC-B80251 11/08/31 By lilingyu 變量li_plantlen引用到範圍外,導致程式當出
# Modify.........: No.TQC-B70154 11/07/28 By Polly 修正資料鎖住的代碼為-263
# Modify.........: No:CHI-B90041 11/10/06 By johung 加上取單別檔資料
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
# Modify.........: No:FUN-BA0015 12/01/17 By pauline 增加aza105,aza106盤點單邊碼原則欄位 
# Modify.........: No:FUN-BB0036 11/11/14 By lilingyu 增加合併報表【大陸版】的自動編號單別GGL
# Modify.........: No:MOD-C30079 12/03/08 By wujie 检查单据重复性时考虑帐别
#                                                  有传入帐别时，取aznn的资料
# Modify.........: No:MOD-C60084 12/06/12 By ck2yuan 盤點標籤依照aza106編碼
# Modify.........: No:FUN-C80045 12/08/17 By nanbing 如果g_prog='apcp200' 不走385-558的鎖sql
# Modify.........: No:MOD-D10012 13/01/04 By Polly 當屬於財務組時，ps_plant改用azw09抓取
# Modify.........: No:CHI-C90040 13/02/21 By Elise (1) aoos010系統參數設定的自動編號方式增加一個「5.依年期」
#                                                  (2) 原本依年月或依年月日都是抓azn04(期別),修正為不再判斷aoos020會計期間設定，直接依系統日期編號
#                                                  (3) 增加「5.依年期」的抓取邏輯
# Modify.........: No:TQC-CB0045 13/02/26 By Polly 取消aac_file lock cursor
# Modify.........: No:TQC-D10002 13/03/05 By jt_chen 調整AXM模組抓取oay_file
# Modify.........: No.DEV-D30026 13/03/18 By Nina GP5.3 追版:DEV-CB0009為GP5.25 的單號

DATABASE ds
 
GLOBALS "../../config/top.global" 

DEFINE   g_aac          RECORD LIKE aac_file.* 
DEFINE   g_fah          RECORD LIKE fah_file.*
DEFINE   g_forupd_sql   STRING
 
# Descriptions...: 自動編號
# Date & Author..: 10/02/22 by saki 翻寫
# Input Parameter: ps_sys      系統別
#                  ps_slip     單號
#                  pd_date     日期
#                  ps_type     單據性質
#                  ps_tab      單據編號是否重複要檢查的table名稱
#                  ps_fld      單據編號對應要檢查的key欄位名稱
#                  ps_plant    Plant Code
#                  ps_runcard  RUNCARD
#                  ps_smy      備用
# Return Code....: li_result   結果(TRUE/FALSE)
#                  ls_no       單據編號
# Memo...........: CALL s_auto_assign_no("apm",g_pmw.pmw01,g_pmw.pmw06,"","pmw_file","pmw01","","","","","","")
#                  要使用多工廠必須傳ps_plant，若為runcard，則ps_runcard需傳"Y"
#                  總帳使用，ps_smy需傳帳別
# New Adding.....: 10/05/22 By Cockroach 新增POS上傳自動編號
#                  與系統標準自動編號區分參數為g_prog，
#                  若g_prog為"apcp200"則認為是POS上傳作業採用的自動編號方式
#                  那自動編號原則相關參數去ryz_file表裡去，相關設置在apcs010作業中
#                  POS上傳添加第5種編碼方式:5-按時間，即按年月日時分秒毫秒為自動編號單號
#                  POS編號不影響系統標準自動編號生成 

FUNCTION s_auto_assign_no(ps_sys,ps_slip,ps_date,ps_type,ps_tab,ps_fld,
                          ps_plant,ps_runcard,ps_smy)
   DEFINE   ps_sys          LIKE smu_file.smu03 	#No.FUN-680147 VARCHAR(10) #No.TQC-6A0079
   DEFINE   ps_slip         STRING
   DEFINE   ps_date         LIKE type_file.dat    	#No.FUN-680147 DATE
   DEFINE   ps_type         STRING
   DEFINE   ps_tab          STRING
   DEFINE   ps_fld          STRING
   DEFINE   ps_dbs          STRING
   DEFINE   ps_plant        LIKE type_file.chr20        #FUN-980094
   DEFINE   ps_runcard      LIKE type_file.chr1   	#No.FUN-680147 VARCHAR(1)
   DEFINE   ps_smy          STRING
   DEFINE   li_auno_flag    LIKE type_file.num5         # 是否要自動編號
   DEFINE   li_sn_cnt       LIKE type_file.num5         # 流水號碼數
   DEFINE   li_no_cnt       LIKE type_file.num5         # 單號碼數
   DEFINE   ls_doc          STRING                      # 單別
   DEFINE   ls_sn           STRING                      # 單號
   DEFINE   ls_plantcode    STRING                      # PlantCode
   DEFINE   lc_legalcode    LIKE azw_file.azw02         # LegalCode
   DEFINE   lc_doc          LIKE type_file.chr10        #NO.FUN-960081
   DEFINE   lc_sn           LIKE type_file.chr10        # 單號 	#No.FUN-680147 VARCHAR(10) #No.TQC-6A0079
   #DEFINE   lc_max_no       LIKE zld_file.zld19         # 最大單據編號 	#No.FUN-680147 VARCHAR(16)
   DEFINE   lc_max_no       LIKE type_file.chr50         #FUN-A80044
   DEFINE   ls_max_sn       STRING                      # 最大流水號
   DEFINE   li_year         LIKE azn_file.azn02         # 年度
   DEFINE   li_month        LIKE azn_file.azn04         # 期別
   DEFINE   li_week         LIKE azn_file.azn05         # 週別
   DEFINE   lc_method       LIKE type_file.chr1         # 舊編號方式 只是為了取單號前的lock動作在翻新時不要修改而留, 新的編號方式變數為lc_method_type
   DEFINE   ls_date         STRING
   #DEFINE   ls_time         LIKE type_file.chr20        #FUN-A50068 ADD #FUN-B20022 mark
   DEFINE   ls_time         LIKE type_file.chr50        #FUN-A50068 ADD  #FUN-B20022 add
   DEFINE   lc_buf          LIKE apr_file.apr02         #MOD-590151 10->12 	#No.FUN-680147 VARCHAR(10)
   DEFINE   lc_msg          LIKE adj_file.adj02         #No.FUN-680147 VARCHAR(255)
   DEFINE   li_i            LIKE type_file.num10  	#No.FUN-680147 INTEGER
   DEFINE   ls_format       STRING
   DEFINE   ls_sql          STRING
   DEFINE   l_sql           STRING                          #FUN-A50068 ADD
   DEFINE   li_cnt          LIKE type_file.num10  	#No.FUN-680147 INTEGER
   DEFINE   li_result       LIKE type_file.num5   	#No.FUN-680147 SMALLINT
   DEFINE   ls_no           STRING
   DEFINE   lc_progname     LIKE gaz_file.gaz03
   DEFINE   ls_max_pre      STRING
   DEFINE   li_max_num      LIKE type_file.num20
   DEFINE   li_max_comp     LIKE type_file.num20
   DEFINE   lc_plantadd     LIKE aza_file.aza97
   DEFINE   li_plantlen     LIKE aza_file.aza98
   DEFINE   lc_doc_set      LIKE aza_file.aza41
   DEFINE   lc_sn_set       LIKE aza_file.aza42
   DEFINE   lc_method_type  LIKE aza_file.aza101
   DEFINE   li_add_zero     LIKE type_file.num5
   DEFINE   lc_dockind      LIKE doc_file.dockind
   DEFINE   lc_docauno      LIKE doc_file.docauno
   DEFINE   lc_gee06        LIKE gee_file.gee06
   DEFINE   lc_gee07        LIKE gee_file.gee07
   DEFINE   lc_gee08        LIKE gee_file.gee08
   DEFINE   ls_slip_table   STRING
   DEFINE   ls_slip_field   STRING
   DEFINE   ls_slip_bookno  STRING
   DEFINE   ls_opencurs_msg STRING
   DEFINE   ls_lockdata_msg STRING
   DEFINE   ls_smy          LIKE aznn_file.aznn00   #No.MOD-C30079 
   DEFINE   l_azw09         LIKE azw_file.azw09   #MOD-D10012 add
   DEFINE   l_azp01         LIKE azp_file.azp01   #MOD-D10012 add
    
   WHENEVER ERROR CALL cl_err_msg_log

   LET ls_max_pre = '999999999999'
   LET li_max_num = 0
   LET li_max_comp = 0
   LET ls_smy = ps_smy   #No.MOD-C30079     
   IF cl_null(ps_plant) THEN
      LET ps_plant = g_plant
      LET ps_dbs = g_dbs
   END IF

   LET ps_plant = UPSHIFT(ps_plant)               #MOD-AB0108

   LET ls_plantcode = ps_plant
   SELECT azw02,azw09 INTO lc_legalcode,l_azw09         #MOD-D10012 add azw09
     FROM azw_file 
    WHERE azw01 = ps_plant
   IF (SQLCA.SQLCODE) THEN
      CALL cl_err_msg("", "lib-605", ps_plant, 1)
      RETURN FALSE,ps_slip
   END IF

   LET ps_sys = UPSHIFT(ps_sys) CLIPPED
   IF ps_sys = "AGL" OR ps_sys = "GGL" THEN
      IF (g_aza.aza102 IS NULL) OR (g_aza.aza103 IS NULL) THEN
         CALL cl_get_progname("aoos010",g_lang) RETURNING lc_progname
         CALL cl_err_msg("","sub-140",lc_progname CLIPPED,0)
         RETURN FALSE,ps_slip
      END IF
   ELSE
    #FUN-BA0015 add START
      IF ps_sys = "AIM" AND (ps_type = "5" OR ps_type = "I") THEN #庫存盤點單或在製盤點單
         IF (g_aza.aza41 IS NULL) OR (g_aza.aza105 IS NULL) THEN
            CALL cl_get_progname("aoos010",g_lang) RETURNING lc_progname
            CALL cl_err_msg("","sub-140",lc_progname CLIPPED,0)
             RETURN FALSE,ps_slip
        END IF
      ELSE 
    #FUN-BA0015 add END
         IF (g_aza.aza41 IS NULL) OR (g_aza.aza42 IS NULL) THEN
            CALL cl_get_progname("aoos010",g_lang) RETURNING lc_progname
            CALL cl_err_msg("","sub-140",lc_progname CLIPPED,0)
            RETURN FALSE,ps_slip
         END IF
      END IF  #FUN-BA0015 add
   END IF

  #-----------------------MOD-D10012-----------------------------(S)
   IF ps_sys = 'AGL' OR ps_sys = 'GGL' OR ps_sys = 'AAP' OR
      ps_sys = 'GAP' OR ps_sys = 'AFA' OR ps_sys = 'GFA' OR
      ps_sys = 'ANM' OR ps_sys = 'GNM' OR ps_sys = 'AXR' OR
      ps_sys = 'GXR' OR ps_sys = 'AMD' OR ps_sys = 'GIS' THEN
      SELECT azp01 INTO l_azp01 FROM azp_file
       WHERE azp03 = l_azw09
      LET ps_plant = l_azp01
   END IF
  #-----------------------MOD-D10012-----------------------------(E)

   CASE
      # 傳票模組單據編號設定, plantcode依照財務模組設定的legalcode
      WHEN ps_sys = "AGL" OR ps_sys = "GGL"
         LET ls_plantcode = lc_legalcode
         LET ls_sql = "SELECT aza99,aza100,aza102,aza103,aza104",
                      "  FROM ",cl_get_target_table(ps_plant,"aza_file"),
                      " WHERE aza01 = '0'"
      # 財務模組單據編號設定
      WHEN ps_sys = "AAP" OR ps_sys = "GAP" OR
           ps_sys = "AFA" OR ps_sys = "GFA" OR
           ps_sys = "ANM" OR ps_sys = "GNM" OR
           ps_sys = "AXR" OR ps_sys = "GXR" OR
           ps_sys = "AMD" OR ps_sys = "GIS"
         LET ls_plantcode = lc_legalcode
         LET ls_sql = "SELECT aza99,aza100,aza41,aza42,aza101",
                      "  FROM ",cl_get_target_table(ps_plant,"aza_file"),
                      " WHERE aza01 = '0'"
      # 製造模組單據編號設定
      OTHERWISE
         IF g_prog='apcp200' THEN                              #FUN-A50068
            LET ls_sql = "SELECT ryz07,ryz03,ryz04,ryz05,ryz06",
                         "  FROM ",cl_get_target_table(ps_plant,"ryz_file"),
                         " WHERE ryz01 = '0'"
         ELSE
       #FUN-BA0015 add START
           IF ps_sys = "AIM" AND (ps_type = "5" OR ps_type = "I") THEN  #盤點單
               LET ls_sql = "SELECT aza97,aza98,aza41,aza105,aza106",
                            "  FROM ",cl_get_target_table(ps_plant,"aza_file"),
                            " WHERE aza01 = '0'"
           ELSE
       #FUN-BA0015 add END
              LET ls_sql = "SELECT aza97,aza98,aza41,aza42,aza101",  #製造非盤點單
                           "  FROM ",cl_get_target_table(ps_plant,"aza_file"),
                           " WHERE aza01 = '0'"
           END IF   #FUN-BA0015 add
         END IF
   END CASE
   LET ls_sql = cl_replace_sqldb(ls_sql)
   PREPARE assign_aza_pre FROM ls_sql
   EXECUTE assign_aza_pre INTO lc_plantadd,li_plantlen,lc_doc_set,lc_sn_set,lc_method_type
   IF lc_plantadd = "Y" THEN
      IF ls_plantcode.getLength() < li_plantlen THEN
         LET li_add_zero = li_plantlen - ls_plantcode.getLength()
         FOR li_i = 1 TO li_add_zero
             LET ls_plantcode = ls_plantcode,"0"
         END FOR
      ELSE
         LET ls_plantcode = ls_plantcode.subString(1,li_plantlen)
      END IF
   ELSE
      LET ls_plantcode = ""
   END IF
   CASE lc_doc_set
      WHEN "1"   LET g_doc_len = 3
      WHEN "2"   LET g_doc_len = 4
      WHEN "3"   LET g_doc_len = 5
   END CASE
   CASE lc_sn_set
      WHEN "1"   LET g_no_ep = g_doc_len + 1 + 8
      WHEN "2"   LET g_no_ep = g_doc_len + 1 + 9
      WHEN "3"   LET g_no_ep = g_doc_len + 1 + 10
   END CASE
  #IF g_prog='apcp200' AND lc_method='5' THEN   #FUN-A50068   #FUN-A60044 MARK
   IF g_prog='apcp200' AND lc_method_type='5' THEN   #FUN-A50068
      LET g_no_ep = g_doc_len + 1 + 14
   END IF
   # 加入Plant Code以後的單號起訖調整
   IF lc_plantadd = "Y" THEN
      LET g_no_sp = g_doc_len + 2
      LET g_sn_sp = g_doc_len + 2 + li_plantlen
      LET g_no_ep = g_no_ep + li_plantlen
   ELSE
      LET g_no_sp = g_doc_len + 2
      LET g_sn_sp = g_no_sp
   END IF
 
   LET li_sn_cnt = g_no_ep - g_sn_sp + 1
   LET li_no_cnt = g_no_ep - g_no_sp + 1
 
   LET ps_slip = ps_slip.trimRight()
 
   # Check是否要自動編號，若沒有就回到主程式/ 抓單別對應的單據性質
   LET li_auno_flag = TRUE
   LET ls_sql = "SELECT dockind,docauno FROM ",cl_get_target_table(ps_plant,"doc_file"),
                " WHERE docsys = '",ps_sys CLIPPED,"'",
                "   AND docslip = '",ps_slip.subString(1,g_doc_len),"'",
                "   AND docacti = 'Y'"
   LET ls_sql = cl_replace_sqldb(ls_sql)
   PREPARE aunoset_pre FROM ls_sql
   EXECUTE aunoset_pre INTO lc_dockind,lc_docauno
   IF cl_null(lc_docauno) THEN
      IF g_bgerr THEN                                                                                                      
         CALL s_errmsg('','','',"mfg3045",0)                                                                      
      ELSE                                                                                                                 
         CALL cl_err(ps_slip,"mfg3045",0)                                                                                  
      END IF                                                                                                               
      RETURN FALSE,ps_slip
   END IF
   IF lc_docauno = "N" THEN
      LET li_auno_flag = FALSE
      IF (ps_slip.getLength() <> g_no_ep) OR
         (NOT cl_chk_data_continue(ps_slip)) THEN
         IF g_bgerr THEN                                                                                                      
            CALL s_errmsg('','','',"sub-141",0)                                                                      
         ELSE                                                                                                                 
            CALL cl_err(ps_slip,"sub-141",0)                                                                                  
         END IF                                                                                                               
         RETURN FALSE,ps_slip
      ELSE
         RETURN TRUE,ps_slip
      END IF
   END IF

   # 取得取號的Table與Field (aooi800共用設定)
   LET ls_sql = "SELECT gee06,gee07,gee08 FROM gee_file",
                " WHERE gee01 = '",ps_sys CLIPPED,"' AND gee02 = '",lc_dockind CLIPPED,"'",
                "   AND gee03 = '0'"
   PREPARE aunosql_pre FROM ls_sql
   EXECUTE aunosql_pre INTO lc_gee06,lc_gee07,lc_gee08
   LET ls_slip_table = lc_gee06 CLIPPED
   LET ls_slip_field = lc_gee07 CLIPPED
   LET ls_slip_bookno = lc_gee08 CLIPPED

   # 例外的取號Table與Field (Ex. Runcard, 無法依照aooi800上所設定的例外狀況)
   CASE
      WHEN (((ps_sys = "ASF") OR (ps_sys = "CSF") OR 
             (ps_sys = "ASR") OR (ps_sys = "CSR")) AND (ps_runcard = "Y"))
         LET ls_slip_table = "shm_file"
         LET ls_slip_field = "shm01"
#FUN-BB0036 --begin--
#      WHEN (((ps_sys = "AGL") OR (ps_sys = "CGL")) AND (ps_runcard = "2"))
#         LET ls_slip_table = "axi_file"
#         LET ls_slip_field = "axi01"
#         LET ls_slip_bookno = "axi00"
      WHEN g_sys = "GGL" AND ps_runcard = "2"
          LET ls_slip_table = "asj_file"
          LET ls_slip_field = "asj01"
          LET ls_slip_bookno= "asj00"
      WHEN ps_sys = "AGL" AND ps_runcard = "2"
          LET ls_slip_table = "axi_file"
          LET ls_slip_field = "axi01"
          LET ls_slip_bookno= "axi00"
#FUN-BB0036 --end--
   END CASE

   # 如果要自動編號，但傳進的單據編號是完整的，就直接檢查編號是否重複、連續性就回傳
   IF (li_auno_flag) THEN
      IF ps_slip.getLength() = g_no_ep THEN
         CALL cl_chk_data_continue(ps_slip) RETURNING li_result
         IF NOT li_result THEN
            IF g_bgerr THEN                                                                                                      
               CALL s_errmsg('','','',"sub-141",0)                                                                               
            ELSE                                                                                                                 
               CALL cl_err(ps_slip,"sub-141",0)                                                                                  
            END IF                                                                                                               
            RETURN li_result,ps_slip
         END IF
 
         # 編號重複檢查
         LET ls_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(ps_plant,ls_slip_table),
                      " WHERE ",ls_slip_field," = '",ps_slip.trim(),"'"
#No.MOD-C30079 --begin
         IF NOT cl_null(lc_gee08) AND NOT cl_null(ls_smy) THEN 
         	  LET ls_sql = ls_sql,"  AND ",lc_gee08,"='",ls_smy,"'" 
         END IF 
#No.MOD-C30079 --end
         LET ls_sql = cl_replace_sqldb(ls_sql)
         PREPARE repeat_chk_pre FROM ls_sql
         EXECUTE repeat_chk_pre INTO li_cnt
         IF li_cnt > 0 THEN
            IF g_bgerr THEN                                                                                                      
               CALL s_errmsg('','','',"sub-144",0)                                                                               
            ELSE                                                                                                                 
               CALL cl_err(ps_slip,"sub-144",0)                                                                                  
            END IF                                                                                                               
            RETURN FALSE,ps_slip
         END IF
 
         RETURN TRUE,ps_slip
      END IF
   END IF
 
   # 自動編號前的check、預設動作
   LET lc_max_no = NULL
   LET ls_max_sn = NULL
   LET ls_doc = ps_slip.subString(1,g_doc_len)
   LET lc_doc = ls_doc
   IF cl_null(lc_doc) THEN                                                      
      IF g_bgerr THEN                                                           
         CALL s_errmsg(ps_fld,ps_slip,'',"sub-141",1)                           
      ELSE                                                                      
         CALL cl_err(ps_slip,"sub-141",1)                                       
      END IF                                                                    
      RETURN FALSE,ps_slip                                                      
   END IF                                                                       

   SELECT azn02,azn04,azn05 INTO li_year,li_month,li_week
     FROM azn_file WHERE azn01 = ps_date
#No.MOD-C30079 --begin
   IF NOT cl_null(ls_slip_bookno) THEN
      SELECT aznn02,aznn04,aznn05 INTO li_year,li_month,li_week
        FROM aznn_file WHERE aznn01 = ps_date AND aznn00 = ls_smy 
   END IF
#No.MOD-C30079 --end
   IF STATUS THEN 
      IF g_bgerr THEN                                                                                                      
         CALL s_errmsg('','','',"sub-142",0)                                                                               
      ELSE                                                                                                                 
         CALL cl_err(ps_slip,"sub-142",0)                                                                                  
      END IF                                                                                                               
      RETURN FALSE,ps_slip
   END IF
 
   # 避免搶號，因此在 select 時便作 lock，待取得單號後再release
   CALL cl_getmsg("mfg8889",g_lang) RETURNING lc_msg
   CALL cl_msg(lc_msg)
   IF g_prog != 'apcp200' THEN #FUN-C80045
   # Lock單別設定檔,若增加模組或單別設定檔時,修改下列程式碼
   CASE
      WHEN ((ps_sys = "AAP") OR (ps_sys = "CAP"))
         LET g_forupd_sql = "SELECT apydmy2 FROM ",cl_get_target_table(ps_plant,"apy_file"),
                            " WHERE apyslip = ? AND apyacti = 'Y' FOR UPDATE "
         LET ls_opencurs_msg = "open apy_file auno_lock_cl:"
         LET ls_lockdata_msg = "apydmy2: read apy_file:"
      WHEN (ps_sys = "ABM") OR (ps_sys = "CBM") OR
           (ps_sys = "AEM") OR (ps_sys = "CEM") OR
           (ps_sys = "AIM") OR (ps_sys = "CIM") OR
           (ps_sys = "APM") OR (ps_sys = "CPM") OR
           (ps_sys = "AQC") OR (ps_sys = "CQC") OR
       #   (ps_sys = "ART") OR (ps_sys = "CRT") OR              #FUN-AA0046 mark   
           (ps_sys = "ASF") OR (ps_sys = "CSF") OR
           (ps_sys = "ASR") OR (ps_sys = "CSR")
         LET g_forupd_sql = "SELECT smydmy5 FROM ",cl_get_target_table(ps_plant,"smy_file"),
                            " WHERE smyslip = ? FOR UPDATE "
         LET ls_opencurs_msg = "open smy_file auno_lock_cl:"
         LET ls_lockdata_msg = "smydmy5: read smy_file:"
         #CHI-B90041 -- begin --
         LET ls_sql = "SELECT * FROM ",cl_get_target_table(ps_plant,"smy_file"),
                      " WHERE smyslip = '",lc_doc,"' AND UPPER(smysys) = '",ps_sys,"'"
         LET ls_sql = cl_replace_sqldb(ls_sql)
         PREPARE slipset_smy_pre1 FROM ls_sql
         EXECUTE slipset_smy_pre1 INTO g_smy.*
         #CHI-B90041 -- end --
      WHEN (ps_sys = "ABX") OR (ps_sys = "CBX")
         LET g_forupd_sql = "SELECT bna04 FROM ",cl_get_target_table(ps_plant,"bna_file"),
                            " WHERE bna01 = ? FOR UPDATE"
         LET ls_opencurs_msg = "open bna_file auno_lock_cl:"
         LET ls_lockdata_msg = "bna04: read bna_file:"
         #CHI-B90041 -- begin --
         LET ls_sql = "SELECT * FROM ",cl_get_target_table(ps_plant,"bna_file"),
                      " WHERE bna01 = '",lc_doc,"'"
         LET ls_sql = cl_replace_sqldb(ls_sql)
         PREPARE slipset_bna_pre1 FROM ls_sql
         EXECUTE slipset_bna_pre1 INTO g_bna.*
         #CHI-B90041 -- end --
      WHEN (ps_sys = "ACO") OR (ps_sys = "CCO")
         LET g_forupd_sql = "SELECT coykind FROM ",cl_get_target_table(ps_plant,"coy_file"),
                            " WHERE coyslip = ? FOR UPDATE"
         LET ls_opencurs_msg = "open coy_file auno_lock_cl:"
         LET ls_lockdata_msg = "coykind: read coy_file:"
         #CHI-B90041 -- begin --
         LET ls_sql = "SELECT * FROM ",cl_get_target_table(ps_plant,"coy_file"),
                      " WHERE coyslip = '",lc_doc,"'"
         LET ls_sql = cl_replace_sqldb(ls_sql)
         PREPARE slipset_coy_pre1 FROM ls_sql
         EXECUTE slipset_coy_pre1 INTO g_coy.*
         #CHI-B90041 -- end --
      WHEN (ps_sys = "AFA") OR (ps_sys = "CFA")
         LET g_forupd_sql = "SELECT fahdmy5 FROM ",cl_get_target_table(ps_plant,"fah_file"),
                            " WHERE fahslip = ? FOR UPDATE"
         LET ls_opencurs_msg = "open fah_file auno_lock_cl:"
         LET ls_lockdata_msg = "fahdmy5: read fah_file:"
         #CHI-B90041 -- begin --
         LET ls_sql = "SELECT * FROM ",cl_get_target_table(ps_plant,"fah_file"),
                      " WHERE fahslip = '",lc_doc,"'"
         LET ls_sql = cl_replace_sqldb(ls_sql)
         PREPARE slipset_fah_pre1 FROM ls_sql
         EXECUTE slipset_fah_pre1 INTO g_fah.*
         #CHI-B90041 -- end --
      WHEN (ps_sys = "AGL") OR (ps_sys = "CGL")
        #-------------------------TQC-CB0045-----------------mark
        #LET g_forupd_sql = "SELECT aac06 FROM ",cl_get_target_table(ps_plant,"aac_file"),
        #                   " WHERE aac01 = ? FOR UPDATE"
        #LET ls_opencurs_msg = "open aac_file auno_lock_cl:"
        #LET ls_lockdata_msg = "aac06: read aac_file:"
        #-------------------------TQC-CB0045-----------------mark
        #CHI-B90041 -- begin --
         LET ls_sql = "SELECT * FROM ",cl_get_target_table(ps_plant,"aac_file"),
                      " WHERE aac01 = '",lc_doc,"'"
         LET ls_sql = cl_replace_sqldb(ls_sql)
         PREPARE chkno_aac_pre1 FROM ls_sql
         EXECUTE chkno_aac_pre1 INTO g_aac.*
        #CHI-B90041 -- end --
      WHEN (ps_sys = "ANM") OR (ps_sys = "CNM")
         LET g_forupd_sql = "SELECT nmydmy2 FROM ",cl_get_target_table(ps_plant,"nmy_file"),
                            " WHERE nmyslip = ? FOR UPDATE "
         LET ls_opencurs_msg = "open nmy_file auno_lock_cl:"
         LET ls_lockdata_msg = "nmydmy2: read nmy_file:"
         #CHI-B90041 -- begin --
         LET ls_sql = "SELECT * FROM ",cl_get_target_table(ps_plant,"nmy_file"),
                      " WHERE nmyslip = '",lc_doc,"'"
         LET ls_sql = cl_replace_sqldb(ls_sql)
         PREPARE slipset_nmy_pre1 FROM ls_sql
         EXECUTE slipset_nmy_pre1 INTO g_nmy.*
         #CHI-B90041 -- end --
      #-----TQC-B90211---------
      #WHEN (ps_sys = "APY") OR (ps_sys = "CPY") OR
      #     (ps_sys = "GPY") OR (ps_sys = "CGPY")
      #   LET g_forupd_sql = " SELECT cplkind FROM ",cl_get_target_table(ps_plant,"cpl_file"),
      #                      "  WHERE cplslip = ? FOR UPDATE "
      #   LET ls_opencurs_msg = "open cpl_file auno_lock_cl:"
      #   LET ls_lockdata_msg = "cplkind: read cpl_file:"
      #   #CHI-B90041 -- begin --
      #   LET ls_sql = "SELECT * FROM ",cl_get_target_table(ps_plant,"cpl_file"),
      #                " WHERE cplslip = '",lc_doc,"'"
      #   LET ls_sql = cl_replace_sqldb(ls_sql)
      #   PREPARE slipset_cpl_pre1 FROM ls_sql
      #   EXECUTE slipset_cpl_pre1 INTO g_cpl.*
      #   #CHI-B90041 -- end --
      #-----END TQC-B90211-----
      WHEN (ps_sys = "ARM") OR (ps_sys = "CRM") OR
           (ps_sys = "AXM") OR (ps_sys = "CXM")
        OR (ps_sys = "ALM") OR (ps_sys = "CLM")    #No.FUN-A70130 Add
        OR (ps_sys = "ART") OR (ps_sys = "CRT")    #No.FUN-A70130 Add
         LET g_forupd_sql = "SELECT oaydmy6 FROM ",cl_get_target_table(ps_plant,"oay_file"),
                            " WHERE oayslip = ? FOR UPDATE"
         LET ls_opencurs_msg = "open oay_file auno_lock_cl:"
         LET ls_lockdata_msg = "oaydmy6: read oay_file:"
         #CHI-B90041 -- begin --
         LET ls_sql = "SELECT * FROM ",cl_get_target_table(ps_plant,"oay_file"),
                      " WHERE oayslip = '",lc_doc,"'"
         LET ls_sql = cl_replace_sqldb(ls_sql)
         PREPARE slipset_oay_pre1 FROM ls_sql
         EXECUTE slipset_oay_pre1 INTO g_oay.*
         #CHI-B90041 -- end --
     #No.FUN-A70130 -BEGIN-----
     #WHEN (ps_sys = "ALM") OR (ps_sys = "CLM") 
     #   LET g_forupd_sql = "SELECT lrkdmy1 FROM ",cl_get_target_table(ps_plant,"lrk_file"),
     #                      " WHERE lrkslip = ? FOR UPDATE "
     #   LET ls_opencurs_msg = "open lrk_file auno_lock_cl:"
     #   LET ls_lockdata_msg = "lrkdmy1: read lrk_file:"
     #No.FUN-A70130 -END-------
      WHEN (ps_sys = "AXR") OR (ps_sys = "CXR")
         LET g_forupd_sql = "SELECT ooykind FROM ",cl_get_target_table(ps_plant,"ooy_file"),
                            " WHERE ooyslip = ? FOR UPDATE"
         LET ls_opencurs_msg = "open ooy_file auno_lock_cl:"
         LET ls_lockdata_msg = "ooykind: read ooy_file:"
         #CHI-B90041 -- begin --
         LET ls_sql = "SELECT * FROM ",cl_get_target_table(ps_plant,"ooy_file"),
                      " WHERE ooyslip = '",lc_doc,"'"
         LET ls_sql = cl_replace_sqldb(ls_sql)
         PREPARE slipset_ooy_pre1 FROM ls_sql
         EXECUTE slipset_ooy_pre1 INTO g_ooy.*
         #CHI-B90041 -- end --
      WHEN (ps_sys = "AXS") OR (ps_sys = "CXS")
         LET g_forupd_sql = "SELECT osydmy1 FROM ",cl_get_target_table(ps_plant,"osy_file"),
                            " WHERE osyslip = ? FOR UPDATE"
         LET ls_opencurs_msg = "open osy_file auno_lock_cl:"
         LET ls_lockdata_msg = "osydmy1: read osy_file:"
         #CHI-B90041 -- begin --
         LET ls_sql = "SELECT * FROM ",cl_get_target_table(ps_plant,"osy_file"),
                      " WHERE osyslip = '",lc_doc,"'"
         LET ls_sql = cl_replace_sqldb(ls_sql)
         PREPARE slipset_osy_pre1 FROM ls_sql
         EXECUTE slipset_osy_pre1 INTO g_osy.*
         #CHI-B90041 -- end --
      #No:DEV-D30026--add--begin
      WHEN (ps_sys = "ABA") OR (ps_sys = "CBA")
         LET g_forupd_sql = "SELECT ibetype FROM ",cl_get_target_table(ps_plant,"ibe_file"),
                            " WHERE ibeslip = ? FOR UPDATE"
         LET ls_opencurs_msg = "open ibe_file auno_lock_cl:"
         LET ls_lockdata_msg = "ibetype: read ibe_file:"

         LET ls_sql = "SELECT * FROM ",cl_get_target_table(ps_plant,"ibe_file"),
                      " WHERE ibeslip = '",lc_doc,"'"
         LET ls_sql = cl_replace_sqldb(ls_sql)
         PREPARE slipset_ibe_pre1 FROM ls_sql
         EXECUTE slipset_ibe_pre1 INTO g_ibe.*
      #No:DEV-D30026--add--add
   END CASE
   IF NOT cl_null(g_forupd_sql) THEN
      LET g_forupd_sql = cl_replace_sqldb(g_forupd_sql)
      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
      DECLARE auno_lock_cl CURSOR FROM g_forupd_sql
      OPEN auno_lock_cl USING lc_doc
     #IF SQLCA.sqlcode = "-243" THEN       #No.TQC-B70154 mark
      IF SQLCA.sqlcode = "-263" THEN       #No.TQC-B70154 add
         IF g_bgerr THEN
            CALL s_errmsg('','',ls_opencurs_msg,SQLCA.sqlcode,0)
         ELSE
            CALL cl_err(ls_opencurs_msg,SQLCA.sqlcode,1)
         END IF
         CLOSE auno_lock_cl
         RETURN FALSE,ps_slip
      END IF
      FETCH auno_lock_cl INTO lc_method
     #IF SQLCA.sqlcode = "-243" THEN       #No.TQC-B70154 mark
      IF SQLCA.sqlcode = "-263" THEN       #No.TQC-B70154 add
         IF g_bgerr THEN
            CALL s_errmsg('','',ls_lockdata_msg,SQLCA.sqlcode,0)
         ELSE
            CALL cl_err(ls_lockdata_msg,SQLCA.sqlcode,1)
         END IF
         CLOSE auno_lock_cl
         RETURN FALSE,ps_slip
      END IF
   END IF
   END IF #FUN-C80045 add
   LET ls_sn = s_get_serial_no(ps_sys,ps_slip,ps_plant)  

   #自動編號
   #取出自動編號方式
   CASE
      WHEN ps_sys = "AGL" OR ps_sys = "GGL"
         LET lc_method = g_aza.aza104
      OTHERWISE
         IF g_prog='apcp200' THEN                              #FUN-A50068
            LET lc_method = lc_method_type
         ELSE
            IF ps_sys = "AIM" AND (ps_type = "5" OR ps_type = "I") THEN     #MOD-C60084 add
               LET lc_method = g_aza.aza106                                 #MOD-C60084 add
            ELSE                                                            #MOD-C60084 add
               LET lc_method = g_aza.aza101
            END IF                                                          #MOD-C60084 add
         END IF
   END CASE

   #依照自動編號方式取得最大號LIKE根據
   CASE
      WHEN (lc_method = "1")   #依流水號
         LET lc_buf = lc_doc CLIPPED,"-",ls_plantcode
         #FUN-B50026 add
         FOR li_i = 1 TO li_sn_cnt
             LET lc_buf = lc_buf,"_"
         END FOR
         #FUN-B50026 add-end
      WHEN (lc_method = "2")   #依年月
        #LET ls_date = li_year USING "&&&&",li_month USING "&&"              #CHI-C90040 mark
         LET ls_date = YEAR(ps_date) USING "&&&&",MONTH(ps_date) USING "&&"  #CHI-C90040
         LET ls_date = ls_date.subString(3,6)
         LET lc_buf = lc_doc CLIPPED,"-",ls_plantcode,ls_date
         #FUN-B50026 add
         FOR li_i = 1 TO li_sn_cnt - 4
             LET lc_buf = lc_buf,"_"
         END FOR
         #FUN-B50026 add-end
      WHEN (lc_method = "3")   #依年週
         LET ls_date = li_year USING "&&&&",li_week USING "&&"
         LET ls_date = ls_date.subString(3,6)
         LET lc_buf = lc_doc CLIPPED,"-",ls_plantcode,ls_date
         #FUN-B50026 add
         FOR li_i = 1 TO li_sn_cnt - 4
             LET lc_buf = lc_buf,"_"
         END FOR
         #FUN-B50026 add-end
      WHEN (lc_method = "4")   #依年月日
        #LET ls_date = li_year USING "&&&&",li_month USING "&&",  #CHI-C90040 mark 
        #              DAY(ps_date) USING "&&"                    #CHI-C90040 mark
         LET ls_date = YEAR(ps_date) USING "&&&&",MONTH(ps_date) USING "&&",DAY(ps_date) USING "&&"   #CHI-C90040
         LET ls_date = ls_date.subString(3,8)
         LET lc_buf = lc_doc CLIPPED,"-",ls_plantcode,ls_date
         #FUN-B50026 add
         FOR li_i = 1 TO li_sn_cnt - 6
             LET lc_buf = lc_buf,"_"
         END FOR
         #FUN-B50026 add-end
      WHEN (lc_method = "5")   #依TIME                 #FUN-A50068 ADD
         IF g_prog='apcp200' THEN                      #CHI-C90040 add
           #No.FUN-A70130 -BEGIN-----
           ##LET l_sql="SELECT to_char(systimestamp,'yymmddhh24missff') FROM dual"  #FUN-A60044 MARK
           # LET l_sql="SELECT to_char(systimestamp,'yymmddhh24missff2') FROM dual"
           # PREPARE systimestamp_pre FROM l_sql
           ##EXECUTE systimestamp_pre INTO ls_time USING "&&&&&&&&&&&&&&"  #FUN-A60044 MARK
           # EXECUTE systimestamp_pre INTO ls_time
           # LET ls_time=ls_time  USING "&&&&&&&&&&&&&&"
             LET ls_time =CURRENT YEAR TO FRACTION(4)
             LET ls_time = ls_time[1,4],ls_time[6,7],ls_time[9,10],ls_time[12,13],ls_time[15,16],ls_time[18,19],ls_time[21,22]  
           #No.FUN-A70130 -END-------
             LET lc_buf = lc_doc CLIPPED,"-",ls_plantcode,ls_time
             RETURN TRUE,lc_buf        #FUN-A60044 ADD #當為POS上傳並且設置為第5種時直接回傳,只check單別

     #CHI-C90040---add---S
         ELSE
            LET ls_date = li_year USING "&&&&",li_month USING "&&"
            LET ls_date = ls_date.subString(3,6)
            LET lc_buf = lc_doc CLIPPED,"-",ls_plantcode,ls_date
            FOR li_i = 1 TO li_sn_cnt - 4
                LET lc_buf = lc_buf,"_"
            END FOR
         END IF
     #CHI-C90040---add---E

   END CASE
   #FUN-B50026 add
    # 組單據編號，runcard的部份另外組
    IF ps_runcard = "Y" THEN 
       LET lc_buf = lc_buf CLIPPED,"-00"
    END IF
   #FUN-B50026 add--end
   LET ls_sql = "SELECT MAX(",ls_slip_field,")",
                "  FROM ",cl_get_target_table(ps_plant,ls_slip_table),
               #" WHERE ",ls_slip_field," LIKE '",lc_buf CLIPPED,"%'"  #FUN-B50026 mark
                " WHERE ",ls_slip_field," LIKE '",lc_buf CLIPPED,"'"   #FUN-B50026 add

   #例外編號條件: Ex. 帳別,Runcard...
   IF NOT cl_null(ls_slip_bookno) THEN
      LET ls_sql = ls_sql," AND ",ls_slip_bookno," = '",ps_smy,"'"
   END IF
   CASE
     #No.FUN-A70130 -BEGIN----- 重新取單據性質
     #WHEN (ps_sys = "ALM") OR (ps_sys = "CLM") 
     #   CASE
     #      WHEN lc_dockind = "39"
     #         LET ls_sql = ls_sql," AND lru00 = '1'"
     #      WHEN lc_dockind = "40"
     #         LET ls_sql = ls_sql," AND lru00 = '2'"
     #      WHEN lc_dockind = "41"
     #         LET ls_sql = ls_sql," AND lru00 = '3'"
     #      WHEN lc_dockind = "42"
     #         LET ls_sql = ls_sql," AND lru00 = '4'"
     #   END CASE
     #WHEN (ps_sys = "ART") OR (ps_sys = "CRT")
     #   CASE
     #      WHEN lc_dockind = "5"
     #         LET ls_sql = ls_sql," AND ruk00 = '1' AND rukplant = '",ps_plant CLIPPED,"'"
     #      WHEN lc_dockind = "6"
     #         LET ls_sql = ls_sql," AND ruk00 = '2' AND rukplant = '",ps_plant CLIPPED,"'"
     #      WHEN lc_dockind = "7"
     #         LET ls_sql = ls_sql," AND rum00 = '1' AND rumplant = '",ps_plant CLIPPED,"'"
     #      WHEN lc_dockind = "8"
     #         LET ls_sql = ls_sql," AND rum00 = '2' AND rumplant = '",ps_plant CLIPPED,"'"
     #      WHEN lc_dockind = "9"
     #         LET ls_sql = ls_sql," AND rxm00 = '1' AND rxmplant = '",ps_plant CLIPPED,"'"
     #      WHEN lc_dockind = "A"
     #         LET ls_sql = ls_sql," AND rxm00 = '2' AND rxmplant = '",ps_plant CLIPPED,"'"
     #      WHEN lc_dockind = "B"
     #         LET ls_sql = ls_sql," AND rxp00 = '1' AND rxpplant = '",ps_plant CLIPPED,"'"
     #      WHEN lc_dockind = "C"
     #         LET ls_sql = ls_sql," AND rxp00 = '2' AND rxpplant = '",ps_plant CLIPPED,"'"
     #      WHEN lc_dockind = "G"
     #         LET ls_sql = ls_sql," AND ruq00 = '1' AND ruqplant = '",ps_plant CLIPPED,"'"
     #      WHEN lc_dockind = "H"
     #         LET ls_sql = ls_sql," AND ruq00 = '2' AND ruqplant = '",ps_plant CLIPPED,"'"
     #      WHEN lc_dockind = "J"
     #         LET ls_sql = ls_sql," AND ruw00 = '1' AND ruwplant = '",ps_plant CLIPPED,"'"
     #      WHEN lc_dockind = "L"
     #         LET ls_sql = ls_sql," AND ruw00 = '2' AND ruwplant = '",ps_plant CLIPPED,"'"
     #      WHEN lc_dockind = "R"
     #         LET ls_sql = ls_sql," AND rxr00 = '1' AND rxrplant = '",ps_plant CLIPPED,"'"
     #      WHEN lc_dockind = "S"
     #         LET ls_sql = ls_sql," AND rxr00 = '2' AND rxrplant = '",ps_plant CLIPPED,"'"
     #   END CASE
      WHEN (ps_sys = "ALM") OR (ps_sys = "CLM")
         CASE
            WHEN lc_dockind = "N4"
               LET ls_sql = ls_sql," AND lru00 = '1'"
            WHEN lc_dockind = "N5"
               LET ls_sql = ls_sql," AND lru00 = '2'"
            WHEN lc_dockind = "N6"
               LET ls_sql = ls_sql," AND lru00 = '3'"
            WHEN lc_dockind = "N7"
               LET ls_sql = ls_sql," AND lru00 = '4'"
         END CASE
      WHEN (ps_sys = "ART") OR (ps_sys = "CRT")
         CASE
            WHEN lc_dockind = "I3"
               LET ls_sql = ls_sql," AND ruk00 = '1' AND rukplant = '",ps_plant CLIPPED,"'"
            WHEN lc_dockind = "I4"
               LET ls_sql = ls_sql," AND ruk00 = '2' AND rukplant = '",ps_plant CLIPPED,"'"
            WHEN lc_dockind = "I5"
               LET ls_sql = ls_sql," AND rum00 = '1' AND rumplant = '",ps_plant CLIPPED,"'"
            WHEN lc_dockind = "I6"
               LET ls_sql = ls_sql," AND rum00 = '2' AND rumplant = '",ps_plant CLIPPED,"'"
            WHEN lc_dockind = "D1"
               LET ls_sql = ls_sql," AND rxm00 = '1' AND rxmplant = '",ps_plant CLIPPED,"'"
            WHEN lc_dockind = "D2"
               LET ls_sql = ls_sql," AND rxm00 = '2' AND rxmplant = '",ps_plant CLIPPED,"'"
            WHEN lc_dockind = "D3"
               LET ls_sql = ls_sql," AND rxp00 = '1' AND rxpplant = '",ps_plant CLIPPED,"'"
            WHEN lc_dockind = "D4"
               LET ls_sql = ls_sql," AND rxp00 = '2' AND rxpplant = '",ps_plant CLIPPED,"'"
            WHEN lc_dockind = "J2"
#               LET ls_sql = ls_sql," AND ruq00 = '1' AND ruqplant = '",ps_plant CLIPPED,"'"   #No.TQC-AC0209
               LET ls_sql = ls_sql," AND ruq00 = '1' "                                         #No.TQC-AC0209
            WHEN lc_dockind = "J3"
#               LET ls_sql = ls_sql," AND ruq00 = '2' AND ruqplant = '",ps_plant CLIPPED,"'"   #No.TQC-AC0209
               LET ls_sql = ls_sql," AND ruq00 = '2' "                                         #No.TQC-AC0209
            WHEN lc_dockind = "J4"
#               LET ls_sql = ls_sql," AND ruw00 = '1' AND ruwplant = '",ps_plant CLIPPED,"'"   #TQC-B10012
               LET ls_sql = ls_sql," AND ruw00 = '1' "                                         #TQC-B10012  
            WHEN lc_dockind = "J5"
#               LET ls_sql = ls_sql," AND ruw00 = '2' AND ruwplant = '",ps_plant CLIPPED,"'"   #TQC-B10012
               LET ls_sql = ls_sql," AND ruw00 = '2' "                                         #TQC-B10012
            WHEN lc_dockind = "F1"
#               LET ls_sql = ls_sql," AND rxr00 = '1' AND rxrplant = '",ps_plant CLIPPED,"'"    #TQC-AC0124
                LET ls_sql = ls_sql," AND rxr00 = '1' "                                          #TQC-AC0124
            WHEN lc_dockind = "F2"
#               LET ls_sql = ls_sql," AND rxr00 = '2' AND rxrplant = '",ps_plant CLIPPED,"'"     #TQC-AC0124
                LET ls_sql = ls_sql," AND rxr00 = '2' "                                           #TQC-AC0124
         END CASE
     #No.FUN-A70130 -END-------
   END CASE

   LET ls_sql = cl_replace_sqldb(ls_sql)
   PREPARE auto_no_pre FROM ls_sql
   EXECUTE auto_no_pre INTO lc_max_no

   # 找出資料庫中最大的單據編號後，計算新的單據編號
   LET ls_max_sn = lc_max_no[g_sn_sp,g_no_ep]

   # 流水號空值代表自動編號 
   IF cl_null(ps_slip.subString(g_sn_sp,g_no_ep)) THEN
      LET ls_format = ""
      CASE
         WHEN (lc_method = "1")   #依流水號
            FOR li_i = 1 TO li_sn_cnt
                LET ls_format = ls_format,"&"
            END FOR
            IF ((ls_max_sn IS NULL) OR (ls_max_sn = " ")) THEN  #最大流水號未曾指定
               LET ls_max_sn = 0
            END IF
            LET li_max_num = ls_max_pre.subString(1,li_sn_cnt)  #最大編號值
            LET li_max_comp = ls_max_sn + 1
            IF li_max_comp > li_max_num THEN
               CALL cl_err("","sub-518",1)
            ELSE
               LET lc_sn = (ls_max_sn + 1) USING ls_format
            END IF
         WHEN (lc_method = "2")   #依年月
           #LET ls_date = li_year USING "&&&&",li_month USING "&&"              #CHI-C90040 mark
            LET ls_date = YEAR(ps_date) USING "&&&&",MONTH(ps_date) USING "&&"  #CHI-C90040
            LET ls_date = ls_date.subString(3,6)
            FOR li_i = 1 TO li_sn_cnt - 4
                LET ls_format = ls_format,"&"
            END FOR
            IF ((ls_max_sn IS NULL) OR (ls_max_sn = " ")) THEN  #最大流水號未曾指定
               LET ls_max_sn = 0
            ELSE
               LET ls_max_sn = ls_max_sn.subString(5,li_sn_cnt) #扣除年月週固定編號後的流水號
            END IF
            LET li_max_num = ls_max_pre.subString(1,(li_sn_cnt-4))  #最大編號值
            LET li_max_comp = ls_max_sn + 1
            IF li_max_comp > li_max_num THEN
               CALL cl_err("","sub-518",1)
            ELSE
               LET lc_sn = ls_date,(ls_max_sn + 1) USING ls_format
            END IF
         WHEN (lc_method = "3")   #依年週
            LET ls_date = li_year USING "&&&&",li_week USING "&&"
            LET ls_date = ls_date.subString(3,6)
            FOR li_i = 1 TO li_sn_cnt - 4
                LET ls_format = ls_format,"&"
            END FOR
            IF ((ls_max_sn IS NULL) OR (ls_max_sn = " ")) THEN  #最大流水號未曾指定
               LET ls_max_sn = 0
            ELSE
               LET ls_max_sn = ls_max_sn.subString(5,li_sn_cnt) #扣除年月週固定編號後的流水號
            END IF
            LET li_max_num = ls_max_pre.subString(1,(li_sn_cnt-4))  #最大編號值
            LET li_max_comp = ls_max_sn + 1
            IF li_max_comp > li_max_num THEN
               CALL cl_err("","sub-518",1)
            ELSE
               LET lc_sn = ls_date,(ls_max_sn + 1) USING ls_format
            END IF
         WHEN (lc_method = "4")   #依年月日
           #LET ls_date = li_year USING "&&&&",li_month USING "&&",   #CHI-C90040 mark 
           #              DAY(ps_date) USING "&&"                     #CHI-C90040 mark
            LET ls_date = YEAR(ps_date) USING "&&&&",MONTH(ps_date) USING "&&",DAY(ps_date) USING "&&"   #CHI-C90040
            LET ls_date = ls_date.subString(3,8)
            FOR li_i = 1 TO li_sn_cnt - 6
                LET ls_format = ls_format,"&"
            END FOR
            IF ((ls_max_sn IS NULL) OR (ls_max_sn = " ")) THEN  #最大流水號未曾指定
                LET ls_max_sn = 0
            ELSE
                LET ls_max_sn = ls_max_sn.subString(7,li_sn_cnt) #扣除年月週固定編號後的流水號
            END IF
            LET li_max_num = ls_max_pre.subString(1,(li_sn_cnt-6))  #最大編號值
            LET li_max_comp = ls_max_sn + 1
            IF li_max_comp > li_max_num THEN
               CALL cl_err("","sub-518",1)
            ELSE
               LET lc_sn = ls_date,(ls_max_sn + 1) USING ls_format
            END IF
         WHEN (lc_method = "5")   #依TIME    #FUN-A50068 ADD
            IF g_prog='apcp200' THEN         #CHI-C90040 add
              #No.FUN-A70130 -BEGIN-----
              # LET l_sql="select to_char(systimestamp,'yymmddhh24missff2') from dual"  #FUN-A60044
              # PREPARE systimestamp_pre1 FROM l_sql
              # EXECUTE systimestamp_pre1 INTO ls_time 
              ##LET lc_sn = ls_time USING "&&&&&&&&&&&&&&"
                LET ls_time =CURRENT YEAR TO FRACTION(4)
                LET ls_time = ls_time[1,4],ls_time[6,7],ls_time[9,10],ls_time[12,13],ls_time[15,16],ls_time[18,19],ls_time[21,22]
              #No.FUN-A70130 -END-------

        #CHI-C90040---add---S
            ELSE
               LET ls_date = li_year USING "&&&&",li_month USING "&&"
               LET ls_date = ls_date.subString(3,6)
               FOR li_i = 1 TO li_sn_cnt - 4
                   LET ls_format = ls_format,"&"
               END FOR
               IF ((ls_max_sn IS NULL) OR (ls_max_sn = " ")) THEN
                  LET ls_max_sn = 0
               ELSE
                  LET ls_max_sn = ls_max_sn.subString(5,li_sn_cnt)
               END IF
               LET li_max_num = ls_max_pre.subString(1,(li_sn_cnt-4))
               LET li_max_comp = ls_max_sn + 1
               IF li_max_comp > li_max_num THEN
                  CALL cl_err("","sub-518",1)
               ELSE
                  LET lc_sn = ls_date,(ls_max_sn + 1) USING ls_format
               END IF
            END IF
        #CHI-C90040---add---E
            
      END CASE
   ELSE
      # 檢查單號碼數是否符合設定值
      IF ls_sn.getLength() <> li_no_cnt THEN
         IF g_bgerr THEN                                                                                                      
            CALL s_errmsg('','','','sub-143',0)                                                                               
         ELSE                                                                                                                 
            CALL cl_err(ls_sn,"sub-143",1)   # TQC-5B0162 0->1
         END IF                                                                                                               
         RETURN FALSE,ps_slip
      END IF
         
      CALL cl_chk_data_continue(ls_sn) RETURNING li_result
      IF NOT li_result THEN
         IF g_bgerr THEN                                                                                                      
            CALL s_errmsg('','','','sub-143',0)                                                                               
         ELSE                                                                                                                 
            CALL cl_err(ls_sn,"sub-143",1)   # TQC-5B0162 0->1
         END IF                                                                                                               
         RETURN li_result,ps_slip
      END IF
 
      # 編號重複檢查
      LET ls_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(ps_plant,ls_slip_table),
                   " WHERE ",ls_slip_field," = '",ps_slip.trim(),"'"
      LET ls_sql = cl_replace_sqldb(ls_sql)
      PREPARE repeat_final_chk_pre FROM ls_sql
      EXECUTE repeat_final_chk_pre INTO li_cnt
      IF li_cnt > 0 THEN
         IF g_bgerr THEN                                                                                                      
            CALL s_errmsg(ps_slip,ps_slip.trim(),'','sub-144',0)                                                                               
         ELSE                                                                                                                 
            CALL cl_err(ps_slip,"sub-144",1)
         END IF                                                                                                               
         RETURN FALSE,ps_slip
      END IF
   END IF
 
   # 組單據編號，runcard的部份另外組
   IF cl_null(ps_slip.subString(g_no_sp,g_no_ep)) THEN
      IF ps_runcard = "Y" THEN
         LET ls_no = lc_doc CLIPPED,"-",ls_plantcode,lc_sn CLIPPED,"-00"
         IF ls_no.getLength() <> g_no_ep + 3 THEN
            IF g_bgerr THEN                                                                                                      
               CALL s_errmsg('','','','sub-145',0)                                                                               
            ELSE                                                                                                                 
               CALL cl_err(ls_no,"sub-145",0)
            END IF                                                                                                               
            RETURN FALSE,ps_slip
         END IF
      ELSE
         LET ls_no = lc_doc CLIPPED,"-",ls_plantcode,lc_sn CLIPPED
         IF ls_no.getLength() <> g_no_ep THEN
            IF g_bgerr THEN                                                                                                      
               CALL s_errmsg('','','','sub-145',0)                                                                               
            ELSE                                                                                                                 
               CALL cl_err(ls_no,"sub-145",0)
            END IF                                                                                                               
            RETURN FALSE,ps_slip
         END IF
      END IF
   ELSE
      # 本來就有流水號且通過檢查,則直接組合回傳
      LET ls_no = lc_doc CLIPPED,"-",ls_sn
   END IF
 
   RETURN TRUE,ls_no
END FUNCTION
 
# Descriptions...: 單據編號檢查
# Date & Author..: 2010/02/22 by saki 翻寫
# Input Parameter: ps_sys         系統別
#                  ps_slip        新單號
#                  ps_slip_o      舊單號
#                  ps_type        單據性質
#                  ps_tab         單據編號是否重複要檢查的table名稱
#                  ps_fld         單據編號對應要檢查的key欄位名稱
#                  ps_plant       Plant Code
# Return Code....: li_result      結果(TRUE/FALSE)
#                  ls_no          單據編號
# Usage..........: CALL s_check_no("apm",g_pmw.pmw01,g_pmw_o.pmw01,"6","pmw_file","pmw01","") RETURNING li_result,g_pmw.pmw01
 
FUNCTION s_check_no(ps_sys,ps_slip,ps_slip_o,ps_type,ps_tab,ps_fld,ps_plant)
   DEFINE   ps_sys          STRING
   DEFINE   ps_slip         STRING
   DEFINE   ps_slip_o       STRING
   DEFINE   ps_type         STRING
   DEFINE   ps_tab          STRING
   DEFINE   ps_fld          STRING
   DEFINE   ps_dbs          STRING
   DEFINE   ps_plant        LIKE type_file.chr20    #FUN-980094
   DEFINE   ls_plantcode    STRING
   DEFINE   lc_legalcode    LIKE azw_file.azw02
   DEFINE   li_inx_s        LIKE type_file.num10    #No.FUN-680147 INTEGER
   DEFINE   ls_doc          STRING                  # 單別
   DEFINE   ls_sn           STRING                  # 單號
   DEFINE   li_cnt          LIKE type_file.num10    #No.FUN-680147 INTEGER
   DEFINE   li_sn_cnt       LIKE type_file.num5     # 流水號碼數
   DEFINE   li_no_cnt       LIKE type_file.num5     # 單號碼數
   DEFINE   lc_gen03        LIKE gen_file.gen03     # 部門代號
   DEFINE   lc_aaz70        LIKE type_file.chr1     # 是否依 User 區分單別(Y/N) 	#No.FUN-680147 VARCHAR(1)
   DEFINE   ls_sql          STRING
   DEFINE   li_result       LIKE type_file.num5     #No.FUN-680147 SMALLINT
   #DEFINE   ls_no           LIKE zld_file.zld19     #No.FUN-680147 VARCHAR(16)
   DEFINE   ls_no           LIKE type_file.chr50     #FUN-A80044
   DEFINE   lc_progname     LIKE gaz_file.gaz03
   DEFINE   lc_plantadd     LIKE aza_file.aza97
   DEFINE   li_plantlen     LIKE aza_file.aza98
   DEFINE   lc_doc_set      LIKE aza_file.aza41
   DEFINE   lc_sn_set       LIKE aza_file.aza42
   DEFINE   lc_method       LIKE aza_file.aza101
   DEFINE   li_add_zero     LIKE type_file.num5
   DEFINE   lc_dockind      LIKE doc_file.dockind
   DEFINE   lc_docauno      LIKE doc_file.docauno
   DEFINE   lc_docacti      LIKE doc_file.docacti
   DEFINE   lc_sys          LIKE smy_file.smysys
   DEFINE   ls_sys          STRING
   DEFINE   lc_gee06        LIKE gee_file.gee06
   DEFINE   lc_gee07        LIKE gee_file.gee07
   DEFINE   lc_gee08        LIKE gee_file.gee08
   DEFINE   ls_slip_table   STRING
   DEFINE   ls_slip_field   STRING
   DEFINE   li_i            LIKE type_file.num5
   DEFINE   ls_temp         STRING                #TQC-AC0360 add 
   #FUN-B50026 add
   DEFINE   lc_sn           LIKE type_file.chr20  #單號编码检查
   DEFINE   li_date         LIKE type_file.dat    #某一年月对应的第一天
   DEFINE   li_year         LIKE azn_file.azn02   #年
   DEFINE   li_month        LIKE azn_file.azn04   #月
   DEFINE   li_day          LIKE type_file.num5   #日
   DEFINE   li_num          LIKE type_file.num5   #某一年月对应有多少天
   DEFINE   li_week         LIKE azn_file.azn05   #周
   #FUN-B50026 add--end
   DEFINE   ls_bookno       LIKE aba_file.aba00   #No.MOD-C30079 
   DEFINE   l_azw09         LIKE azw_file.azw09   #MOD-D10012 add
   DEFINE   l_azp01         LIKE azp_file.azp01   #MOD-D10012 add
   
   WHENEVER ERROR CALL cl_err_msg_log
   LET li_result = TRUE
#No.MOD-C30079 --begin
   LET ps_sys = UPSHIFT(ps_sys) CLIPPED
   LET ls_bookno = NULL 
   IF ps_sys ='AGL' AND ps_type='*' AND NOT cl_null(ps_plant) AND ps_tab ='aba_file' THEN 
   	  LET ls_bookno = ps_plant
   	  LET ps_plant =NULL 
   END IF 
#No.MOD-C30079 --end  
   IF cl_null(ps_slip) THEN
      RETURN FALSE,ps_slip
   END IF
#FUN-AA0046 --------------STR
   IF cl_null(ps_type) THEN
      RETURN FALSE,ps_slip
   END IF
#FUN-AA0046 --------------END
   IF cl_null(ps_plant) THEN
      LET ps_plant = g_plant
      LET ps_dbs = g_dbs
   END IF

  LET ps_plant = UPSHIFT(ps_plant)               #MOD-AB0108 

   LET ls_plantcode = ps_plant
   SELECT azw02,azw09 INTO lc_legalcode,l_azw09         #MOD-D10012 add azw09
     FROM azw_file WHERE azw01 = ps_plant
   IF (SQLCA.SQLCODE) THEN
      CALL cl_err_msg("", "lib-605", ps_plant, 1)
      RETURN FALSE,ps_slip
   END IF

   LET ps_sys = UPSHIFT(ps_sys) CLIPPED
   IF ps_sys = "AGL" OR ps_sys = "GGL" THEN
      IF (g_aza.aza102 IS NULL) OR (g_aza.aza103 IS NULL) THEN
         CALL cl_get_progname("aoos010",g_lang) RETURNING lc_progname
         CALL cl_err_msg("","sub-140",lc_progname CLIPPED,0)
         RETURN FALSE,ps_slip
      END IF
   ELSE
     #FUN-BA0015 add START
      IF ps_sys = "AIM" AND (ps_type = "5" OR ps_type = "I") THEN  ##庫存盤點單或在製盤點單
         IF (g_aza.aza41 IS NULL) OR (g_aza.aza105 IS NULL) THEN
            CALL cl_get_progname("aoos010",g_lang) RETURNING lc_progname
            CALL cl_err_msg("","sub-140",lc_progname CLIPPED,0)
            RETURN FALSE,ps_slip
         END IF
      ELSE 
     #FUN-BA0015 add END
         IF (g_aza.aza41 IS NULL) OR (g_aza.aza42 IS NULL) THEN
            CALL cl_get_progname("aoos010",g_lang) RETURNING lc_progname
            CALL cl_err_msg("","sub-140",lc_progname CLIPPED,0)
            RETURN FALSE,ps_slip
         END IF
      END IF      #FUN-BA0015 add
   END IF

  #-----------------------MOD-D10012-----------------------------(S)
   IF ps_sys = 'AGL' OR ps_sys = 'GGL' OR ps_sys = 'AAP' OR
      ps_sys = 'GAP' OR ps_sys = 'AFA' OR ps_sys = 'GFA' OR
      ps_sys = 'ANM' OR ps_sys = 'GNM' OR ps_sys = 'AXR' OR
      ps_sys = 'GXR' OR ps_sys = 'AMD' OR ps_sys = 'GIS' THEN
      SELECT azp01 INTO l_azp01 FROM azp_file
       WHERE azp03 = l_azw09
      LET ps_plant = l_azp01
   END IF
  #-----------------------MOD-D10012-----------------------------(E)

   CASE
      # 傳票模組單據編號設定, plantcode依照財務模組設定的legalcode
      WHEN ps_sys = "AGL" OR ps_sys = "GGL"
         LET ls_plantcode = lc_legalcode
         LET ls_sql = "SELECT aza99,aza100,aza102,aza103,aza104",
                      "  FROM ",cl_get_target_table(ps_plant,"aza_file"),
                      " WHERE aza01 = '0'"
      # 財務模組單據編號設定
      WHEN ps_sys = "AAP" OR ps_sys = "GAP" OR
           ps_sys = "AFA" OR ps_sys = "GFA" OR
           ps_sys = "ANM" OR ps_sys = "GNM" OR
           ps_sys = "AXR" OR ps_sys = "GXR" OR
           ps_sys = "AMD" OR ps_sys = "GIS"
         LET ls_plantcode = lc_legalcode
         LET ls_sql = "SELECT aza99,aza100,aza41,aza42,aza101",
                      "  FROM ",cl_get_target_table(ps_plant,"aza_file"),
                      " WHERE aza01 = '0'"
      # 製造模組單據編號設定
      OTHERWISE
        #FUN-BA0015 add START
         IF ps_sys = "AIM" AND (ps_type = "5" OR ps_type = "I") THEN
            LET ls_sql = "SELECT aza97,aza98,aza41,aza105,aza106",
                         "  FROM ",cl_get_target_table(ps_plant,"aza_file"),
                         " WHERE aza01 = '0'"
         ELSE
        #FUN-BA0015 add END
            LET ls_sql = "SELECT aza97,aza98,aza41,aza42,aza101",
                         "  FROM ",cl_get_target_table(ps_plant,"aza_file"),
                         " WHERE aza01 = '0'"
         END IF   #FUN-BA0015 add
   END CASE
   LET ls_sql = cl_replace_sqldb(ls_sql)
   PREPARE chkno_aza_pre FROM ls_sql
   EXECUTE chkno_aza_pre INTO lc_plantadd,li_plantlen,lc_doc_set,lc_sn_set,lc_method
   IF lc_plantadd = "Y" THEN
      IF ls_plantcode.getLength() < li_plantlen THEN
         LET li_add_zero = li_plantlen - ls_plantcode.getLength()
         FOR li_i = 1 TO li_add_zero
             LET ls_plantcode = ls_plantcode,"0"
         END FOR
      ELSE
         LET ls_plantcode = ls_plantcode.subString(1,li_plantlen)
      END IF
   ELSE
      LET ls_plantcode = ""
   END IF
   CASE lc_doc_set
      WHEN "1"   LET g_doc_len = 3
      WHEN "2"   LET g_doc_len = 4
      WHEN "3"   LET g_doc_len = 5
   END CASE
   CASE lc_sn_set
      WHEN "1"   LET g_no_ep = g_doc_len + 1 + 8
      WHEN "2"   LET g_no_ep = g_doc_len + 1 + 9
      WHEN "3"   LET g_no_ep = g_doc_len + 1 + 10
   END CASE
   # 加入Plant Code以後的單號起訖調整
   IF lc_plantadd = "Y" THEN
      LET g_no_sp = g_doc_len + 2
      LET g_sn_sp = g_doc_len + 2 + li_plantlen
      LET g_no_ep = g_no_ep + li_plantlen
   ELSE
      LET g_no_sp = g_doc_len + 2
      LET g_sn_sp = g_no_sp
   END IF
 
   LET li_sn_cnt = g_no_ep - g_no_sp + 1
   LET li_no_cnt = g_no_ep - g_no_sp + 1
 
   LET li_inx_s = ps_slip.getIndexOf("-",1)
   IF li_inx_s > 0 THEN
      LET ls_doc = ps_slip.subString(1,g_doc_len) 
     #TQC-AC0360---modify---start---
     #LET ls_sn = ps_slip.subString(li_inx_s + 1,ps_slip.trim())
      LET ls_temp = ps_slip.trim()
      LET ls_sn = ps_slip.subString(li_inx_s + 1,ls_temp.getLength())
     #TQC-AC0360---modify---end---
   ELSE
      LET ls_doc = ps_slip
      LET ls_sn = NULL
   END IF

   IF cl_null(ls_doc) THEN
      IF g_bgerr THEN                                                                                                      
         CALL s_errmsg('','','','sub-146',0)                                                                               
      ELSE                                                                                                                 
         CALL cl_err(ls_doc,"sub-146",1) #MOD-590041 0->1
      END IF                                                                                                               
      RETURN FALSE,ps_slip
   END IF
 
   # 檢查單別碼數是否符合設定值
   LET ls_doc = ls_doc.trim()
   IF ls_doc.getLength() <> g_doc_len THEN
      IF g_bgerr THEN                                                                                                      
         CALL s_errmsg('','','','sub-146',0)                                                                               
      ELSE                                                                                                                 
         CALL cl_err(ls_doc,"sub-146",1) #MOD-590041 0->1
      END IF                                                                                                               
      RETURN FALSE,ps_slip
   END IF
 
   # 檢查單別資料是否連續
   CALL cl_chk_data_continue(ls_doc) RETURNING li_result
   IF NOT li_result THEN
      IF g_bgerr THEN                                                                                                      
         CALL s_errmsg('','','','sub-146',0)                                                                               
      ELSE                                                                                                                 
         CALL cl_err(ls_doc,"sub-146",1) #MOD-590041 0->1
      END IF                                                                                                               
     #RETURN li_result,ps_slip
      RETURN FALSE,ps_slip  #FUN-B50026 mod
   END IF
 
   # 單別檢查,原本的s_*slip程式
   IF ps_sys.subString(1,1) = "C" THEN
      IF ps_sys.getLength() >= "4" THEN
         LET ls_sys = ps_sys.subString(2,ps_sys.getLength())
      ELSE
         LET ls_sys = "A",ps_sys.subString(2,ps_sys.getLength())
      END IF
   ELSE
      LET ls_sys = ps_sys
   END IF

   #基本單別檢查：是否存在, 單據性質是否符合, 是否有效
   LET ls_sql = "SELECT dockind,docauno,docacti FROM ",cl_get_target_table(ps_plant,"doc_file"),
                " WHERE docsys = '",ps_sys CLIPPED,"'",
                "   AND docslip = '",ls_doc,"'"
   LET ls_sql = cl_replace_sqldb(ls_sql)
   PREPARE doc_check_pre FROM ls_sql
   EXECUTE doc_check_pre INTO lc_dockind,lc_docauno,lc_docacti
   CASE
      WHEN SQLCA.sqlcode = 100
         LET g_errno = "mfg0014"    #無此單別
      WHEN lc_dockind != ps_type AND ps_type <> "*"
         LET g_errno = "mfg0015"    #單據性質不符合
      WHEN lc_docacti = "N"
         LET g_errno = "9028"       #此筆資料已無效, 不可使用
      OTHERWISE LET g_errno = SQLCA.sqlcode USING "----------"
   END CASE

   #例外單別檢查
   CASE
      WHEN ((ps_sys = "AGL") OR (ps_sys = "CGL"))
         LET ls_sql = "SELECT aaz70 FROM ",cl_get_target_table(ps_plant,"aaz_file"),
                      " WHERE aaz00 = '0'"
 	 CALL cl_replace_sqldb(ls_sql) RETURNING ls_sql
         PREPARE chkno_aaz_pre FROM ls_sql
         EXECUTE chkno_aaz_pre INTO lc_aaz70
         IF cl_null(lc_aaz70) THEN LET lc_aaz70 = "N" END IF

         LET ls_sql = "SELECT * FROM ",cl_get_target_table(ps_plant,"aac_file"),
                      " WHERE aac01 = '",ls_doc,"'"
         LET ls_sql = cl_replace_sqldb(ls_sql)
         PREPARE chkno_aac_pre FROM ls_sql
         EXECUTE chkno_aac_pre INTO g_aac.*
         IF g_nmz.nmz52 = 'N' THEN
            IF g_aac.aac11 <> ps_type AND ps_type <> "*" THEN
               LET g_errno = "agl-164"                  #單據性質不符
            END IF
         ELSE
            IF g_aac.aac11 NOT MATCHES "[13]" AND ps_type <> "*" THEN
               LET g_errno = "agl-164"                  #單據性質不符
            END IF
         END IF
         # 傳票單別是否做user權限ctrl.
         IF lc_aaz70 = "Y" AND g_aac.aac10 != g_user THEN
            LET g_errno = "agl-126"
         END IF
   END CASE

   #取出單別設定值
   CASE
      WHEN (ps_sys = "AAP") OR (ps_sys = "CAP")
         LET ls_sql = "SELECT * FROM ",cl_get_target_table(ps_plant,"apy_file"),
                      " WHERE apyslip = '",ls_doc,"'"
         LET ls_sql = cl_replace_sqldb(ls_sql)
         PREPARE slipset_apy_pre FROM ls_sql
         EXECUTE slipset_apy_pre INTO g_apy.*
      WHEN (ps_sys = "AXR") OR (ps_sys = "CXR")
         LET ls_sql = "SELECT * FROM ",cl_get_target_table(ps_plant,"ooy_file"),
                      " WHERE ooyslip = '",ls_doc,"'"
         LET ls_sql = cl_replace_sqldb(ls_sql)
         PREPARE slipset_ooy_pre FROM ls_sql
         EXECUTE slipset_ooy_pre INTO g_ooy.*
      WHEN (ps_sys = "ABM") OR (ps_sys = "CBM") OR
           (ps_sys = "ASF") OR (ps_sys = "CSF") OR
           (ps_sys = "AEM") OR (ps_sys = "CEM") OR
           (ps_sys = "AQC") OR (ps_sys = "CQC") OR
           (ps_sys = "ASR") OR (ps_sys = "CSR") OR
           (ps_sys = "APM") OR (ps_sys = "CPM") OR
          #No.FUN-A70130 -BEGIN-----
          #(ps_sys = "AIM") OR (ps_sys = "CIM") OR
          #(ps_sys = "ART") OR (ps_sys = "CRT")
           (ps_sys = "AIM") OR (ps_sys = "CIM")
          #No.FUN-A70130 -END-------
         LET ls_sql = "SELECT * FROM ",cl_get_target_table(ps_plant,"smy_file"),
                      " WHERE smyslip = '",ls_doc,"' AND UPPER(smysys) = '",ps_sys,"'"
         LET ls_sql = cl_replace_sqldb(ls_sql)
         PREPARE slipset_smy_pre FROM ls_sql
         EXECUTE slipset_smy_pre INTO g_smy.*
     #No.FUN-A70130 -BEGIN-----
     #WHEN (ps_sys = "ALM") OR (ps_sys = "CLM")        
     #   LET ls_sql = "SELECT * FROM ",cl_get_target_table(ps_plant,"lrk_file"),
     #                " WHERE lrkslip = '",ls_doc,"'"
     #   LET ls_sql = cl_replace_sqldb(ls_sql)
     #   PREPARE slipset_lrk_pre FROM ls_sql
     #   EXECUTE slipset_lrk_pre INTO g_lrk.*
     #No.FUN-A70130 -END-------
      WHEN (ps_sys = "ABX") OR (ps_sys = "CBX")
         LET ls_sql = "SELECT * FROM ",cl_get_target_table(ps_plant,"bna_file"),
                      " WHERE bna01 = '",ls_doc,"'"
         LET ls_sql = cl_replace_sqldb(ls_sql)
         PREPARE slipset_bna_pre FROM ls_sql
         EXECUTE slipset_bna_pre INTO g_bna.*
      WHEN (ps_sys = "ACO") OR (ps_sys = "CCO")
         LET ls_sql = "SELECT * FROM ",cl_get_target_table(ps_plant,"coy_file"),
                      " WHERE coyslip = '",ls_doc,"'"
         LET ls_sql = cl_replace_sqldb(ls_sql)
         PREPARE slipset_coy_pre FROM ls_sql
         EXECUTE slipset_coy_pre INTO g_coy.*
      WHEN (ps_sys = "AFA") OR (ps_sys = "CFA")
         LET ls_sql = "SELECT * FROM ",cl_get_target_table(ps_plant,"fah_file"),
                      " WHERE fahslip = '",ls_doc,"'"
         LET ls_sql = cl_replace_sqldb(ls_sql)
         PREPARE slipset_fah_pre FROM ls_sql
         EXECUTE slipset_fah_pre INTO g_fah.*
      WHEN (ps_sys = "ANM") OR (ps_sys = "CNM")
         LET ls_sql = "SELECT * FROM ",cl_get_target_table(ps_plant,"nmy_file"),
                      " WHERE nmyslip = '",ls_doc,"'"
         LET ls_sql = cl_replace_sqldb(ls_sql)
         PREPARE slipset_nmy_pre FROM ls_sql
         EXECUTE slipset_nmy_pre INTO g_nmy.*
      #-----TQC-B90211---------
      #WHEN (ps_sys = "APY") OR (ps_sys = "CPY") OR
      #     (ps_sys = "GPY") OR (ps_sys = "CGPY")
      #   LET ls_sql = "SELECT * FROM ",cl_get_target_table(ps_plant,"cpl_file"),
      #                " WHERE cplslip = '",ls_doc,"'"
      #   LET ls_sql = cl_replace_sqldb(ls_sql)
      #   PREPARE slipset_cpl_pre FROM ls_sql
      #   EXECUTE slipset_cpl_pre INTO g_cpl.*
      #-----END TQC-B90211-----
      WHEN (ps_sys = "ARM") OR (ps_sys = "CRM") OR
           (ps_sys = "ATM") OR (ps_sys = "CTM") OR
           (ps_sys = "AXM") OR (ps_sys = "CXM")
        OR (ps_sys = "ALM") OR (ps_sys = "CLM")    #No.FUN-A70130
        OR (ps_sys = "ART") OR (ps_sys = "CRT")    #No.FUN-A70130
         LET ls_sql = "SELECT * FROM ",cl_get_target_table(ps_plant,"oay_file"),
                      " WHERE oayslip = '",ls_doc,"'"
         LET ls_sql = cl_replace_sqldb(ls_sql)
         PREPARE slipset_oay_pre FROM ls_sql
         EXECUTE slipset_oay_pre INTO g_oay.*
      WHEN (ps_sys = "AXD") OR (ps_sys = "CXD")
         LET ls_sql = "SELECT * FROM ",cl_get_target_table(ps_plant,"adz_file"),
                      " WHERE adzslip = '",ls_doc,"'"
         LET ls_sql = cl_replace_sqldb(ls_sql)
         PREPARE slipset_adz_pre FROM ls_sql
         EXECUTE slipset_adz_pre INTO g_adz.*
      WHEN (ps_sys = "AXS") OR (ps_sys = "CXS")
         LET ls_sql = "SELECT * FROM ",cl_get_target_table(ps_plant,"osy_file"),
                      " WHERE osyslip = '",ls_doc,"'"
         LET ls_sql = cl_replace_sqldb(ls_sql)
         PREPARE slipset_osy_pre FROM ls_sql
         EXECUTE slipset_osy_pre INTO g_osy.*
      #No:DEV-D30026--add--begin
      WHEN (ps_sys = "ABA") OR (ps_sys = "CBA")
         LET ls_sql = "SELECT * FROM ",cl_get_target_table(ps_plant,"ibe_file"),
                      " WHERE ibeslip = '",ls_doc,"'"
         LET ls_sql = cl_replace_sqldb(ls_sql)
         PREPARE slipset_ibe_pre FROM ls_sql
         EXECUTE slipset_ibe_pre INTO g_ibe.*
      #No:DEV-D30026--add--end
   END CASE

   # 抓取使用者所屬部門
   LET ls_sql = "SELECT zx03 FROM ",cl_get_target_table(ps_plant,"zx_file"),
                " WHERE zx01 = '",g_user CLIPPED,"'"    #抓此人所屬部門
   LET ls_sql = cl_replace_sqldb(ls_sql)
   PREPARE chkno_zx_pre FROM ls_sql
   EXECUTE chkno_zx_pre INTO lc_gen03
   IF SQLCA.SQLCODE THEN
      LET lc_gen03 = NULL
   END IF

   #銷售系統單據重取系統別
   IF ps_sys = "AXM" OR ps_sys = "CXM" OR ps_sys="ATM" OR ps_sys="CTM" THEN
     #TQC-D10002 -- mark start --
     #LET ls_sql = "SELECT smysys FROM ",cl_get_target_table(ps_plant,"smy_file"),
     #             " WHERE smyslip = '",ls_doc,"'"
     #LET ls_sql = cl_replace_sqldb(ls_sql)
     #PREPARE chkno_reget_smy_pre FROM ls_sql
     #EXECUTE chkno_reget_smy_pre INTO lc_sys
     #TQC-D10002 -- mark end
     #TQC-D10002 -- add start --
      LET ls_sql = "SELECT oaysys FROM ",cl_get_target_table(ps_plant,"oay_file"),
                   " WHERE oayslip = '",ls_doc,"'"
      LET ls_sql = cl_replace_sqldb(ls_sql)
      PREPARE chkno_reget_oay_pre FROM ls_sql
      EXECUTE chkno_reget_oay_pre INTO lc_sys
     #TQC-D10002 -- add end --
      LET ls_sys = UPSHIFT(lc_sys) CLIPPED
   END IF

   # 先Check此單別有無設定User權限 (無設定代表不控管), 先Check使用者再Check部門
   LET ls_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(ps_plant,"smu_file"),
                " WHERE smu01 = '",ls_doc,"' AND UPPER(smu03) = '",ls_sys,"'"
   LET ls_sql = cl_replace_sqldb(ls_sql)
   PREPARE chkcnt_smu_pre FROM ls_sql
   EXECUTE chkcnt_smu_pre INTO li_cnt
   IF li_cnt > 0 THEN
      # 需做User控管, Check此User是否有此單別使用權限
      LET ls_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(ps_plant,"smu_file"),
                   " WHERE smu01 = '",ls_doc,"' AND smu02 = '",g_user CLIPPED,"'",
                   "   AND UPPER(smu03) = '",ls_sys,"'"
      LET ls_sql = cl_replace_sqldb(ls_sql)
      PREPARE chkno_smu_pre FROM ls_sql
      EXECUTE chkno_smu_pre INTO li_cnt
      IF li_cnt <= 0 THEN
         IF lc_gen03 IS NULL THEN   #g_user沒有部門
            LET g_errno = "aoo-104" 
         ELSE
            LET ls_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(ps_plant,"smv_file"),
                         " WHERE smv01 = '",ls_doc,"' AND smv02 = '",lc_gen03 CLIPPED,"'",
                         "   AND UPPER(smv03) = '",ls_sys,"'"
            LET ls_sql = cl_replace_sqldb(ls_sql)
            PREPARE chkno_smv_pre FROM ls_sql
            EXECUTE chkno_smv_pre INTO li_cnt
            IF li_cnt = 0 THEN
               LET g_errno = "aoo-104" 
            END IF
         END IF
      END IF
   ELSE
      LET ls_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(ps_plant,"smv_file"),
                   " WHERE smv01 = '",ls_doc,"' AND UPPER(smv03) = '",ls_sys,"'"
      LET ls_sql = cl_replace_sqldb(ls_sql)
      PREPARE chkcnt_smv_pre FROM ls_sql
      EXECUTE chkcnt_smv_pre INTO li_cnt
      IF li_cnt > 0 THEN
         # 需做部門控管, Check User部門是否有此單別使用權限
         IF lc_gen03 IS NULL THEN   #g_user沒有部門
            LET g_errno = "aoo-104" 
         ELSE
            LET ls_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(ps_plant,"smv_file"),
                         " WHERE smv01 = '",ls_doc,"' AND smv02 = '",lc_gen03 CLIPPED,"'",
                         "   AND UPPER(smv03) = '",ls_sys,"'"
            LET ls_sql = cl_replace_sqldb(ls_sql)
            PREPARE chkno2_smv_pre FROM ls_sql
            EXECUTE chkno2_smv_pre INTO li_cnt
            IF li_cnt = 0 THEN
               LET g_errno = "aoo-104" 
            END IF
         END IF
       END IF
   END IF

   # 錯誤, 將單別敘述清空
   IF NOT cl_null(g_errno) THEN
      CASE
         WHEN (ps_sys = "AAP") OR (ps_sys = "CAP")
            LET g_apy.apydesc = ""
         WHEN (ps_sys = "AXR") OR (ps_sys = "CXR")
            LET g_ooy.ooydesc = ""
         WHEN (ps_sys = "ABM") OR (ps_sys = "CBM") OR
              (ps_sys = "ASF") OR (ps_sys = "CSF") OR
              (ps_sys = "AEM") OR (ps_sys = "CEM") OR
              (ps_sys = "AQC") OR (ps_sys = "CQC") OR
              (ps_sys = "ASR") OR (ps_sys = "CSR") OR
              (ps_sys = "APM") OR (ps_sys = "CPM") OR
             #No.FUN-A70130 -BEGIN-----
             #(ps_sys = "AIM") OR (ps_sys = "CIM") OR
             #(ps_sys = "ART") OR (ps_sys = "CRT")
              (ps_sys = "AIM") OR (ps_sys = "CIM")
             #No.FUN-A70130 -END-------
            LET g_smy.smydesc = ""
      #   WHEN (ps_sys = "ALM") OR (ps_sys = "CLM")     #FUN-AA0046    mark
      #      LET g_lrk.lrkdesc = ""                     #FUN-AA0046    mark
         WHEN (ps_sys = "ABX") OR (ps_sys = "CBX")
            LET g_bna.bna02 = "" 
         WHEN (ps_sys = "ACO") OR (ps_sys = "CCO")
            LET g_coy.coydesc = ""
         WHEN (ps_sys = "AFA") OR (ps_sys = "CFA")
            LET g_fah.fahdesc = ""
         WHEN (ps_sys = "ANM") OR (ps_sys = "CNM")
            LET g_nmy.nmydesc = ""
         #-----TQC-B90211--------- 
         #WHEN (ps_sys = "APY") OR (ps_sys = "CPY") OR
         #     (ps_sys = "GPY") OR (ps_sys = "CGPY")
         #   LET g_cpl.cpldesc = ""
         #-----END TQC-B90211-----
         WHEN (ps_sys = "ARM") OR (ps_sys = "CRM") OR
              (ps_sys = "ATM") OR (ps_sys = "CTM") OR
              (ps_sys = "AXM") OR (ps_sys = "CXM")
           OR (ps_sys = "ALM") OR (ps_sys = "CLM")    #No.FUN-A70130
           OR (ps_sys = "ART") OR (ps_sys = "CRT")    #No.FUN-A70130
            LET g_oay.oaydesc = ""
         WHEN (ps_sys = "AXD") OR (ps_sys = "CXD")
            LET g_adz.adzdesc = ""
         WHEN (ps_sys = "AXS") OR (ps_sys = "CXS")
            LET g_osy.osydesc = ""
         #No:DEV-D30026--add--begin
         WHEN (ps_sys = "ABA") OR (ps_sys = "CBA")
            LET g_ibe.ibedesc = ""
         #No:DEV-D30026--add--end
      END CASE
      IF g_bgerr THEN                                                                                                      
         CALL s_errmsg('','','',g_errno,0)                                                                               
      ELSE                                                                                                                 
         CALL cl_err(ls_doc,g_errno,1)
      END IF                                                                                                               
      RETURN FALSE,ps_slip
   END IF
 
   #不自動編號且無單號
   IF lc_docauno = "N" AND cl_null(ls_sn) THEN
      IF g_bgerr THEN                                                                                                      
         CALL s_errmsg('','','','sub-147',0)                                                                               
      ELSE                                                                                                                 
         CALL cl_err(ls_sn,"sub-147",0)
      END IF                                                                                                               
      RETURN FALSE,ps_slip
   END IF

   #取得取號的Table與field
   LET ls_sql = "SELECT gee06,gee07 FROM gee_file",
                " WHERE gee01 = '",ps_sys CLIPPED,"' AND gee02 = '",ps_type,"'",
                "   AND gee03 = '0'"
   PREPARE checksql_pre FROM ls_sql
   EXECUTE checksql_pre INTO lc_gee06,lc_gee07
   LET ls_slip_table = lc_gee06 CLIPPED
   LET ls_slip_field = lc_gee07 CLIPPED

   #不自動編號或是單號部分有輸入
   IF lc_docauno = "N" OR (NOT cl_null(ls_sn)) THEN
      #檢查單號碼數是否符合設定值
      IF ls_sn.getLength() <> li_sn_cnt THEN
         IF g_bgerr THEN                                                                                                      
            CALL s_errmsg('','','','sub-143',0)                                                                               
         ELSE                                                                                                                 
            CALL cl_err(ls_sn,"sub-143",1)
         END IF                                                                                                               
         RETURN FALSE,ps_slip
      END IF
            
      CALL cl_chk_data_continue(ls_sn) RETURNING li_result
      IF NOT li_result THEN
         IF g_bgerr THEN                                                                                                      
            CALL s_errmsg('','','','sub-143',0)                                                                               
         ELSE                                                                                                                 
            CALL cl_err(ls_sn,"sub-143",1)  # TQC-5B0162 0->1
         END IF                                                                                                               
        #RETURN li_result,ps_slip
         RETURN FALSE,ps_slip  #FUN-B50026 mod
      END IF

      #編號重複檢查
      IF (ps_slip != ps_slip_o) OR (ps_slip_o IS NULL) THEN
         IF (NOT cl_null(ls_slip_table)) AND (NOT cl_null(ls_slip_field)) THEN
            LET ls_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(ps_plant,ls_slip_table),
                         " WHERE ",ls_slip_field," = '",ps_slip.trim(),"'"
#No.MOD-C30079 --begin
         IF NOT cl_null(ls_bookno) THEN 
         	  LET ls_sql = ls_sql,"   AND aba00 ='",ls_bookno,"'"
         END IF 
#No.MOD-C30079 --end
            LET ls_sql = cl_replace_sqldb(ls_sql)
            PREPARE chkno_sn_curs FROM ls_sql
            EXECUTE chkno_sn_curs INTO li_cnt
            IF li_cnt > 0 THEN
               IF g_bgerr THEN                                                                                                      
                  CALL s_errmsg('','','','sub-144',0)                                                                               
               ELSE                                                                                                                 
                  CALL cl_err(ps_slip,"sub-144",1)
               END IF                                                                                                               
               RETURN FALSE,ps_slip
            END IF
         END IF
      END IF

      #FUN-B50026 add 检查单号合理性
      #若单号编入Plant Code,需检查Plant Code正确性
      LET lc_sn = ls_sn
      IF lc_plantadd = 'Y' THEN
        IF li_plantlen > 0 THEN                                #TQC-B80251
         IF lc_sn[1,li_plantlen] != ls_plantcode THEN
            IF g_bgerr THEN                                                                                                      
               CALL s_errmsg('','','','sub-235',0)                                                                               
            ELSE                                                                                                                 
               CALL cl_err(lc_sn,"sub-235",1)
            END IF                                                                                                               
            RETURN FALSE,ps_slip
         END IF
        END IF                                                #TQC-B80251
      END IF

      #检查 自动编号方式 的合理性
      #备注:此处不能用ls_date的形式先按编码方式编号码去判断，应为日期不能确定，可能不按单据日期给补单的情况
      CASE
         WHEN (lc_method = "2")   #依年月
           #LET li_year  = lc_sn[li_plantlen+1,li_plantlen+2]
           #LET li_month = lc_sn[li_plantlen+3,li_plantlen+4]
            #需数字型
            IF NOT cl_numchk(lc_sn[li_plantlen+1,li_plantlen+2],0) OR NOT cl_numchk(lc_sn[li_plantlen+3,li_plantlen+4],0) THEN
               IF g_bgerr THEN                                                                                                      
                  CALL s_errmsg('','','','sub-236',0)                                                                               
               ELSE                                                                                                                 
                  CALL cl_err(lc_sn,"sub-236",1)
               END IF                                                                                                               
               RETURN FALSE,ps_slip
            END IF
            #月
            IF lc_sn[li_plantlen+3,li_plantlen+4] > 12 OR lc_sn[li_plantlen+3,li_plantlen+4] < 1 THEN
               IF g_bgerr THEN                                                                                                      
                  CALL s_errmsg('','','','sub-236',0)                                                                               
               ELSE                                                                                                                 
                  CALL cl_err(lc_sn,"sub-236",1)
               END IF                                                                                                               
               RETURN FALSE,ps_slip
            END IF
         WHEN (lc_method = "3")   #依年週
           #LET li_year = lc_sn[li_plantlen+1,li_plantlen+2]
           #LET li_week = lc_sn[li_plantlen+3,li_plantlen+4]
            #需数字型
            IF NOT cl_numchk(lc_sn[li_plantlen+1,li_plantlen+2],0) OR NOT cl_numchk(lc_sn[li_plantlen+3,li_plantlen+4],0) THEN
               IF g_bgerr THEN                                                                                                      
                  CALL s_errmsg('','','','sub-236',0)                                                                               
               ELSE                                                                                                                 
                  CALL cl_err(lc_sn,"sub-236",1)
               END IF                                                                                                               
               RETURN FALSE,ps_slip
            END IF
            #周
            IF lc_sn[li_plantlen+3,li_plantlen+4] > 53 OR lc_sn[li_plantlen+3,li_plantlen+4] < 1 THEN
               IF g_bgerr THEN                                                                                                      
                  CALL s_errmsg('','','','sub-236',0)                                                                               
               ELSE                                                                                                                 
                  CALL cl_err(lc_sn,"sub-236",1)
               END IF                                                                                                               
               RETURN FALSE,ps_slip
            END IF
         WHEN (lc_method = "4")   #依年月日
            LET li_year  = lc_sn[li_plantlen+1,li_plantlen+2]
            LET li_month = lc_sn[li_plantlen+3,li_plantlen+4]
            LET li_day   = lc_sn[li_plantlen+5,li_plantlen+6]
            #需数字型
            IF NOT cl_numchk(lc_sn[li_plantlen+1,li_plantlen+2],0)
            OR NOT cl_numchk(lc_sn[li_plantlen+3,li_plantlen+4],0)
            OR NOT cl_numchk(lc_sn[li_plantlen+5,li_plantlen+6],0)
            THEN
               IF g_bgerr THEN                                                                                                      
                  CALL s_errmsg('','','','sub-236',0)                                                                               
               ELSE                                                                                                                 
                  CALL cl_err(lc_sn,"sub-236",1)
               END IF                                                                                                               
               RETURN FALSE,ps_slip
            END IF
            #月
            IF li_month > 12 OR li_month < 1 THEN
               IF g_bgerr THEN                                                                                                      
                  CALL s_errmsg('','','','sub-236',0)                                                                               
               ELSE                                                                                                                 
                  CALL cl_err(lc_sn,"sub-236",1)
               END IF                                                                                                               
               RETURN FALSE,ps_slip
            END IF
            #日
            LET li_date = MDY(li_month,1,li_year)
            CALL s_months(li_date) RETURNING li_num  #此月该有多少天
            IF li_day > li_num OR li_day < 1 THEN
               IF g_bgerr THEN                                                                                                      
                  CALL s_errmsg('','','','sub-236',0)                                                                               
               ELSE                                                                                                                 
                  CALL cl_err(lc_sn,"sub-236",1)
               END IF                                                                                                               
               RETURN FALSE,ps_slip
            END IF
      END CASE
      #FUN-B50026 add--end
   END IF
 
   # 回傳檢查結果及單號
   IF lc_docauno THEN
      LET ls_no = ps_slip
   ELSE
      LET ls_no = ls_doc,"-",ls_sn
   END IF
 
   RETURN li_result,ls_no
END FUNCTION
 
# Descriptions...: 由單據編號中取單別
# Date & Author..: 2010/02/22 by saki 翻寫
# Input Parameter: ps_slip        單據編號
# Return Code....: ls_doc         單別編號
# Usage..........: CALL s_get_doc_no(g_pmw.pmw01) RETURNING g_sheet

FUNCTION s_get_doc_no(ps_slip)
   DEFINE   ps_slip   STRING
   DEFINE   ls_doc    STRING
   DEFINE   li_inx    LIKE type_file.num10
 
   LET li_inx = ps_slip.getIndexOf("-",1)
   IF li_inx <= 0 THEN
      LET ls_doc = ps_slip
   ELSE
      LET ls_doc = ps_slip.subString(1,li_inx - 1)
   END IF
 
   RETURN ls_doc
END FUNCTION
 
# Descriptions...: 由單據編號中取單號
# Date & Author..: 2010/02/22 by saki 翻寫
# Input Parameter: ps_sys         系統別
#                  ps_slip        單據編號
#                  ps_plant       Plant Code
# Return Code....: ls_no          單號
# Usage..........: CALL s_get_serial_no(g_pmw.pmw01,g_plant) RETURNING g_no
 
FUNCTION s_get_serial_no(ps_sys,ps_slip,ps_plant)  
   DEFINE   ps_sys        LIKE smu_file.smu03
   DEFINE   ps_slip       STRING
   DEFINE   ps_plant      LIKE type_file.chr20
   DEFINE   ps_type       LIKE doc_file.dockind    #FUN-BA0015 add 
   DEFINE   ps_dbs        STRING
   DEFINE   ls_plantcode  STRING
   DEFINE   lc_legalcode  LIKE azw_file.azw02
   DEFINE   ls_sql        STRING
   DEFINE   lc_plantadd   LIKE aza_file.aza97
   DEFINE   li_plantlen   LIKE aza_file.aza98
   DEFINE   lc_doc_set    LIKE aza_file.aza41
   DEFINE   lc_sn_set     LIKE aza_file.aza42
   DEFINE   lc_method     LIKE aza_file.aza101
   DEFINE   li_add_zero   LIKE type_file.num5
   DEFINE   li_i          LIKE type_file.num5
   DEFINE   ls_no         STRING

   IF cl_null(ps_plant) THEN
      LET ps_plant = g_plant
      LET ps_dbs = g_dbs
   END IF

  #FUN-BA0015 add START
   LET ls_sql = "SELECT dockind FROM ",cl_get_target_table(ps_plant,"doc_file"),
                " WHERE docsys = '",ps_sys CLIPPED,"'",
                "   AND docslip = '",ps_slip.subString(1,g_doc_len),"'",
                "   AND docacti = 'Y'"
   LET ls_sql = cl_replace_sqldb(ls_sql)
   PREPARE aunoset_pre1 FROM ls_sql
   EXECUTE aunoset_pre1 INTO ps_type 
  #FUN-BA0015 add END

   LET ps_plant = UPSHIFT(ps_plant)               #MOD-AB0108 

   LET ls_plantcode = ps_plant
   SELECT azw02 INTO lc_legalcode FROM azw_file WHERE azw01 = ps_plant
   IF (SQLCA.SQLCODE) THEN
      CALL cl_err_msg("", "lib-605", ps_plant, 1)
      RETURN ps_slip
   END IF

   LET ps_sys = UPSHIFT(ps_sys) CLIPPED

   CASE
      # 傳票模組單據編號設定, plantcode依照財務模組設定的legalcode
      WHEN ps_sys = "AGL" OR ps_sys = "GGL"
         LET ls_plantcode = lc_legalcode
         LET ls_sql = "SELECT aza99,aza100,aza102,aza103,aza104",
                      "  FROM ",cl_get_target_table(ps_plant,"aza_file"),
                      " WHERE aza01 = '0'"
      # 財務模組單據編號設定
      WHEN ps_sys = "AAP" OR ps_sys = "GAP" OR
           ps_sys = "AFA" OR ps_sys = "GFA" OR
           ps_sys = "ANM" OR ps_sys = "GNM" OR
           ps_sys = "AXR" OR ps_sys = "GXR" OR
           ps_sys = "AMD" OR ps_sys = "GIS"
         LET ls_plantcode = lc_legalcode
         LET ls_sql = "SELECT aza99,aza100,aza41,aza42,aza101",
                      "  FROM ",cl_get_target_table(ps_plant,"aza_file"),
                      " WHERE aza01 = '0'"
      # 製造模組單據編號設定
      OTHERWISE
         IF g_prog='apcp200' THEN
            LET ls_sql = "SELECT ryz07,ryz03,ryz04,ryz05,ryz06",
                         "  FROM ",cl_get_target_table(ps_plant,"ryz_file"),
                         " WHERE ryz01 = '0'"
         ELSE
          #FUN-BA0015 add START
            IF ps_sys = "AIM" AND (ps_type = "5" OR ps_type = "I") THEN
                   LET ls_sql = "SELECT aza97,aza98,aza41,aza105,aza106",
                              "  FROM ",cl_get_target_table(ps_plant,"aza_file"),
                              " WHERE aza01 = '0'"
            ELSE
          #FUN-BA0015 add END
               LET ls_sql = "SELECT aza97,aza98,aza41,aza42,aza101",
                            "  FROM ",cl_get_target_table(ps_plant,"aza_file"),
                            " WHERE aza01 = '0'"
            END IF   #FUN-BA0015 add
         END IF
   END CASE
   LET ls_sql = cl_replace_sqldb(ls_sql)
   PREPARE getsn_aza_pre FROM ls_sql
   EXECUTE getsn_aza_pre INTO lc_plantadd,li_plantlen,lc_doc_set,lc_sn_set,lc_method
   IF lc_plantadd = "Y" THEN
      IF ls_plantcode.getLength() < li_plantlen THEN
         LET li_add_zero = li_plantlen - ls_plantcode.getLength()
         FOR li_i = 1 TO li_add_zero
             LET ls_plantcode = ls_plantcode,"0"
         END FOR
      ELSE
         LET ls_plantcode = ls_plantcode.subString(1,li_plantlen)
      END IF
   ELSE
      LET ls_plantcode = ""
   END IF
   CASE lc_doc_set
      WHEN "1"   LET g_doc_len = 3
      WHEN "2"   LET g_doc_len = 4
      WHEN "3"   LET g_doc_len = 5
   END CASE
   CASE lc_sn_set
      WHEN "1"   LET g_no_ep = g_doc_len + 1 + 8
      WHEN "2"   LET g_no_ep = g_doc_len + 1 + 9
      WHEN "3"   LET g_no_ep = g_doc_len + 1 + 10
   END CASE
   IF g_prog='apcp200' AND lc_method='5' THEN   #FUN-A50068
      LET g_no_ep = g_doc_len + 1 + 14
   END IF
   # 加入Plant Code以後的單號起訖調整
   IF lc_plantadd = "Y" THEN
      LET g_no_sp = g_doc_len + 2
      LET g_sn_sp = g_doc_len + 2 + li_plantlen
      LET g_no_ep = g_no_ep + li_plantlen
   ELSE
      LET g_no_sp = g_doc_len + 2
      LET g_sn_sp = g_no_sp
   END IF
 
   LET ls_no = ps_slip.subString(g_no_sp,g_no_ep)
 
   RETURN ls_no
END FUNCTION

# Descriptions...: 取得指定Plant及模組的單據編號設定
# Date & Author..: 2010/03/15 by saki
# Input Parameter: ps_sys       系統別
#                  ps_plant     Plant
# Return Code....: void
# Usage..........: CALL s_doc_global_setting(g_sys,g_plant)

FUNCTION s_doc_global_setting(ps_sys,ps_plant)  
   DEFINE   ps_sys        LIKE smu_file.smu03
   DEFINE   ps_plant      LIKE type_file.chr20
   DEFINE   ls_sql        STRING
   DEFINE   lc_plantadd   LIKE aza_file.aza97
   DEFINE   li_plantlen   LIKE aza_file.aza98
   DEFINE   lc_doc_set    LIKE aza_file.aza41
   DEFINE   lc_sn_set     LIKE aza_file.aza42

   IF cl_null(ps_sys) THEN
      LET ps_sys = g_sys
   END IF

   IF cl_null(ps_plant) THEN
      LET ps_plant = g_plant
   END IF

   CASE
      # 傳票模組單據編號設定
      WHEN ps_sys = "AGL" OR ps_sys = "GGL"
         LET ls_sql = "SELECT aza99,aza100,aza102,aza103",
                      "  FROM ",cl_get_target_table(ps_plant,"aza_file"),
                      " WHERE aza01 = '0'"
      # 財務模組單據編號設定
      WHEN ps_sys = "AAP" OR ps_sys = "GAP" OR
           ps_sys = "AFA" OR ps_sys = "GFA" OR
           ps_sys = "ANM" OR ps_sys = "GNM" OR
           ps_sys = "AXR" OR ps_sys = "GXR" OR
           ps_sys = "AMD" OR ps_sys = "GIS"
         LET ls_sql = "SELECT aza99,aza100,aza41,aza42",
                      "  FROM ",cl_get_target_table(ps_plant,"aza_file"),
                      " WHERE aza01 = '0'"
      # 製造模組單據編號設定
      OTHERWISE
         LET ls_sql = "SELECT aza97,aza98,aza41,aza42",
                      "  FROM ",cl_get_target_table(ps_plant,"aza_file"),
                      " WHERE aza01 = '0'"
   END CASE
   LET ls_sql = cl_replace_sqldb(ls_sql)
   PREPARE global_aza_pre FROM ls_sql
   EXECUTE global_aza_pre INTO lc_plantadd,li_plantlen,lc_doc_set,lc_sn_set

   CASE lc_doc_set
      WHEN "1"   LET g_doc_len = 3
      WHEN "2"   LET g_doc_len = 4
      WHEN "3"   LET g_doc_len = 5
   END CASE
   CASE lc_sn_set
      WHEN "1"   LET g_no_ep = g_doc_len + 1 + 8
      WHEN "2"   LET g_no_ep = g_doc_len + 1 + 9
      WHEN "3"   LET g_no_ep = g_doc_len + 1 + 10
   END CASE
   # 加入Plant Code以後的單號起訖調整
   IF lc_plantadd = "Y" THEN
      LET g_no_sp = g_doc_len + 2
      LET g_sn_sp = g_doc_len + 2 + li_plantlen
      LET g_no_ep = g_no_ep + li_plantlen
   ELSE
      LET g_no_sp = g_doc_len + 2
      LET g_sn_sp = g_no_sp
   END IF
END FUNCTION
# FUN-A30020
