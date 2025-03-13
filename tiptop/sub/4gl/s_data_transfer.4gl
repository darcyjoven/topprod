# Prog. Version..: '5.30.04-12.12.27(00001)'
#
# Program name...: s_data_transfer.4gl
# Descriptions...: 資料拋轉作業，用於料件/客戶/廠商的相關文件拋轉
# Date & Author..: 12/12/03 By Lori(CHI-CB0017)
# Usage..........: CALL s_data_transfer(p_plant,p_flag,p_prog,p_value1,p_value2,p_value3,p_value4,p_value5)
# Input PARAMETER: p_plant    營運中心
#                  p_flag     標識 1.料件資料
#                                  2.客戶資料
#                                  3.廠商資料
#                                  4.基本資料
#                  p_prog     作業程式代碼/Table Name(當拋轉基本資料時改傳Table Name)
#                  p_value1   搜尋條件值1
#                  p_value2   搜尋條件值2
#                  p_value3   搜尋條件值3
#                  p_value4   搜尋條件值4
#                  p_value5   搜尋條件值5

GLOBALS "../../config/top.global"
DATABASE ds
#CHI-CB0017

DEFINE g_db_center  STRING   #資料中心的DB Schema
DEFINE g_db_sch     STRING   #拋轉營運中心的DB Schema
DEFINE g_msg        STRING
DEFINE g_column1    LIKE   type_file.chr10
DEFINE g_column2    LIKE   type_file.chr10
DEFINE g_column3    LIKE   type_file.chr10
DEFINE g_column4    LIKE   type_file.chr10
DEFINE g_column5    LIKE   type_file.chr10
DEFINE g_value1     LIKE   type_file.chr30
DEFINE g_value2     LIKE   type_file.chr30
DEFINE g_value3     LIKE   type_file.chr30
DEFINE g_value4     LIKE   type_file.chr30
DEFINE g_value5     LIKE   type_file.chr30
DEFINE g_flag       LIKE   type_file.chr1
DEFINE l_prog       LIKE   type_file.chr20
DEFINE l_time       STRING
DEFINE g_gca01_o    LIKE   gca_file.gca01    #拋轉來源
DEFINE g_gca02_o    LIKE   gca_file.gca02    #拋轉來源
DEFINE g_gca03_o    LIKE   gca_file.gca03    #拋轉來源
DEFINE g_gca04_o    LIKE   gca_file.gca04    #拋轉來源
DEFINE g_gca05_o    LIKE   gca_file.gca05    #拋轉來源
DEFINE g_gca01_n    LIKE   gca_file.gca01    #拋轉目的
DEFINE g_gca02_n    LIKE   gca_file.gca02    #拋轉目的
DEFINE g_gca03_n    LIKE   gca_file.gca03    #拋轉目的
DEFINE g_gca04_n    LIKE   gca_file.gca04    #拋轉目的  
DEFINE g_gca05_n    LIKE   gca_file.gca05    #拋轉目的

FUNCTION s_data_transfer(p_plant,p_flag,p_prog,p_value1,p_value2,p_value3,p_value4,p_value5)
   DEFINE p_plant       LIKE   azp_file.azp01
   DEFINE p_flag        LIKE   type_file.chr1
   DEFINE p_prog        LIKE   type_file.chr20
   DEFINE p_value1      LIKE   type_file.chr30
   DEFINE p_value2      LIKE   type_file.chr30
   DEFINE p_value3      LIKE   type_file.chr30
   DEFINE p_value4      LIKE   type_file.chr30
   DEFINE p_value5      LIKE   type_file.chr30
   DEFINE l_azp03_cen   LIKE   azp_file.azp03
   DEFINE l_azp03       LIKE   azp_file.azp03

   IF cl_null(p_plant) THEN 
      RETURN 
   END IF

   LET g_db_sch = p_plant
   LET g_db_center = g_plant

   LET l_prog    = p_prog
   LET g_column1 = NULL
   LET g_column2 = NULL
   LET g_column3 = NULL
   LET g_column4 = NULL
   LET g_column5 = NULL
   LET g_value1  = p_value1
   LET g_value2  = p_value2
   LET g_value3  = p_value3
   LET g_value4  = p_value4
   LET g_value5  = p_value5
   LET g_flag    = p_flag
   LET g_gca01_o = NULL
   LET g_gca02_o = NULL
   LET g_gca03_o = NULL
   LET g_gca04_o = NULL
   LET g_gca05_o = NULL
   LET g_gca01_n = NULL
   LET g_gca02_n = NULL
   LET g_gca03_n = NULL
   LET g_gca04_n = NULL
   LET g_gca05_n = NULL

   IF p_flag = '1' THEN
      CALL s_data_item()
   END IF
   IF p_flag = '2' THEN
      CALL s_data_customer()
   END IF
   IF p_flag = '3' THEN
      CALL s_data_supplier()
   END IF
   IF p_flag = '4' THEN
      CALL s_data_basic()
   END IF
END FUNCTION

FUNCTION s_data_item()
   DEFINE l_sql        STRING
   DEFINE l_gca01      LIKE   gca_file.gca01

   IF g_success = 'N' THEN RETURN END IF
   LET l_time = TIME

   IF l_prog = 'aimi150' THEN
      LET g_column1 = "imaano"
      LET g_column2 = "ima01"
   END IF

   IF l_prog = 'aimi100' THEN
      LET g_column1 = "ima01"
      LET g_column2 = "ima01"
   END IF

   IF cl_null(g_column1) OR cl_null(g_value1) OR
      cl_null(g_column2) OR cl_null(g_value2) THEN
      RETURN
   END IF

   LET g_gca01_o = g_column1 cLIPPED || "=" || g_value1 CLIPPED
   LET g_gca01_n = g_column2 CLIPPED || "=" || g_value2 CLIPPED
   CALL s_doc_carry()
END FUNCTION

FUNCTION s_data_customer()
   DEFINE l_sql        STRING
   DEFINE l_gca01      LIKE   gca_file.gca01

   IF g_success = 'N' THEN RETURN END IF
   LET l_time = TIME

   IF l_prog = 'axmi250' THEN
      LET g_column1 = "occano"
      LET g_column2 = "occ01"
   END IF

   IF l_prog = 'axmi221' THEN
      LET g_column1 = "occ01"
      LET g_column2 = "occ01"
   END IF

   IF cl_null(g_column1) OR cl_null(g_value1) OR
      cl_null(g_column2) OR cl_null(g_value2) THEN
      RETURN
   END IF

   LET g_gca01_o = g_column1 cLIPPED || "=" || g_value1 CLIPPED
   LET g_gca01_n = g_column2 CLIPPED || "=" || g_value2 CLIPPED
   CALL s_doc_carry()
END FUNCTION

FUNCTION s_data_supplier()
   DEFINE l_sql        STRING
   DEFINE l_gca01      LIKE   gca_file.gca01

   IF g_success = 'N' THEN RETURN END IF
   LET l_time = TIME

   IF l_prog = 'apmi610' THEN
      LET g_column1 = "pmcano"
      LET g_column2 = "pmc01"
   END IF

   IF l_prog = 'apmi600' THEN
      LET g_column1 = "pmc01"
      LET g_column2 = "pmc01"
   END IF

   IF cl_null(g_column1) OR cl_null(g_value1) OR
      cl_null(g_column2) OR cl_null(g_value2) THEN
      RETURN
   END IF

   LET g_gca01_o = g_column1 cLIPPED || "=" || g_value1 CLIPPED
   LET g_gca01_n = g_column2 CLIPPED || "=" || g_value2 CLIPPED  
   CALL s_doc_carry() 
END FUNCTION

FUNCTION s_data_basic()
   IF l_prog = "gem_file" THEN
      LET g_column1 = "gem01"
   END IF
   IF l_prog = "gen_file" THEN
      LET g_column1 = "gen01"
   END IF
   IF l_prog = "azi_file" THEN
      LET g_column1 = "azi01"
   END IF
   IF l_prog = "azf_file" THEN
      LET g_column1 = "azf01"
      LET g_column2 = "azf02"
   END IF
   IF l_prog = "geb_file" THEN
      LET g_column1 = "geb01"
   END IF
   IF l_prog = "gea_file" THEN
      LET g_column1 = "gea01"
   END IF
   IF l_prog = "gfe_file" THEN
      LET g_column1 = "gfe01"
   END IF
  #IF l_prog = "tag_file" THEN
   IF l_prog = "smc_file" THEN           
      LET g_column1 = "smc01"
      LET g_column2 = "smc02"
   END IF
   IF l_prog = "geo_file" THEN
      LET g_column1 = "geo01"
   END IF 
   IF l_prog = "gec_file" THEN
      LET g_column1 = "gec01"
      LET g_column2 = "gec011"
   END IF 
   IF l_prog = "ged_file" THEN
      LET g_column1 = "ged01"
   END IF 
   IF l_prog = "azh_file" THEN
      LET g_column1 = "azh01"
   END IF 
   IF l_prog = "apr_file" THEN
      LET g_column1 = "apr01"
   END IF 
   IF l_prog = "apo_file" THEN
      LET g_column1 = "apo01"
   END IF 
   IF l_prog = "fab_file" THEN
      LET g_column1 = "fab01"
   END IF 
   IF l_prog = "fac_file" THEN 
      LET g_column1 = "fac01"
   END IF
   IF l_prog = "fag_file" THEN 
      LET g_column1 = "fag01"
   END IF
   IF l_prog = "nmb_file" THEN 
      LET g_column1 = "nmb01"
   END IF
   IF l_prog = "nmc_file" THEN 
      LET g_column1 = "nmc01"
   END IF
   IF l_prog = "nmk_file" THEN 
      LET g_column1 = "nmk01"
   END IF
   IF l_prog = "nml_file" THEN 
      LET g_column1 = "nml01"
   END IF
   IF l_prog = "nmo_file" THEN 
      LET g_column1 = "nmo01"
   END IF
   IF l_prog = "nmt_file" THEN 
      LET g_column1 = "nmt01"
   END IF
   IF l_prog = "pma_file" THEN 
      LET g_column1 = "pma01"
   END IF
   IF l_prog = "pmb_file" THEN 
      LET g_column1 = "pmb01"
      LET g_column1 = "pmb03"
   END IF
  #IF l_prog = "cph_file" THEN 
  #   LET g_column1 = "cph01"
  #END IF
  #IF l_prog = "cpj_file" THEN 
  #   LET g_column1 = "cpj01"
  #END IF
  #IF l_prog = "cpw_file" THEN 
  #   LET g_column1 = "cpw01"
  #END IF
   IF l_prog = "qca_file" THEN 
      LET g_column1 = "qca01"
      LET g_column2 = "qca02"
      LET g_column3 = "qca03"
      LET g_column4 = "qca07"
   END IF
   IF l_prog = "qch_file" THEN 
      LET g_column1 = "qch01"
      LET g_column2 = "qch02"
      LET g_column3 = "qch03"
      LET g_column4 = "qch07"
   END IF
   IF l_prog = "qce_file" THEN 
      LET g_column1 = "qce01"
   END IF
   IF l_prog = "qcj_file" THEN 
      LET g_column1 = "qcj01"
      LET g_column2 = "qcj02"
      LET g_column3 = "qcj03"
      LET g_column4 = "qcj04"
   END IF
   IF l_prog = "qcb_file" THEN 
      LET g_column1 = "qcb01"
      LET g_column2 = "qcb02"
      LET g_column3 = "qcb03"
   END IF
   IF l_prog = "oaj_file" THEN
      LET g_column1 = "oaj01"
   END IF
  #IF l_prog = "obm_file" THEN
  #   LET g_column1 = "obm01"
  #END IF
   IF l_prog = "tqa_file" THEN
      LET g_column1 = "tqa01"
      LET g_column2 = "tqa03"
   END IF
   IF l_prog = "ccd_file" THEN
      LET g_column1 = "ccd01"
   END IF
   IF l_prog = "oab_file" THEN
      LET g_column1 = "oab01"
   END IF
   IF l_prog = "oac_file" THEN
      LET g_column1 = "oac01"
   END IF
   IF l_prog = "oae_file" THEN
      LET g_column1 = "oae01"
   END IF
   IF l_prog = "oaf_file" THEN
      LET g_column1 = "oaf01"
      LET g_column2 = "oaf02"
   END IF
   IF l_prog = "oag_file" THEN
      LET g_column1 = "oag01"
   END IF
   IF l_prog = "oak_file" THEN
      LET g_column1 = "oak01"
   END IF
   IF l_prog = "ock_file" THEN
      LET g_column1 = "ock01"
   END IF
   IF l_prog = "oba_file" THEN
      LET g_column1 = "oba01"
   END IF
   IF l_prog = "obb_file" THEN
      LET g_column1 = "obb01"
   END IF
   IF l_prog = "obe_file" THEN
      LET g_column1 = "obe01"
   END IF
   IF l_prog = "oca_file" THEN
      LET g_column1 = "oca01"
   END IF
   IF l_prog = "oza_file" THEN
      LET g_column1 = "oza01"
   END IF
   IF l_prog = "ozb_file" THEN
      LET g_column1 = "ozb01"
   END IF
   IF l_prog = "ozc_file" THEN
      LET g_column1 = "ozc01"
   END IF
   IF l_prog = "imz_file" THEN
      LET g_column1 = "imz01"
   END IF
   IF l_prog = "lmm_file" THEN
      LET g_column1 = "lmm01"
   END IF 
   IF l_prog = "lmn_file" THEN
      LET g_column1 = "lmn01"
      LET g_column2 = "lmn02"
   END IF 
   IF l_prog = "lmq_file" THEN 
      LET g_column1 = "lmq01"
   END IF 
   IF l_prog = "lmr_file" THEN 
      LET g_column1 = "lmr01"
   END IF 
   IF l_prog = "lms_file" THEN 
      LET g_column1 = "lms01"
   END IF 
   IF l_prog = "lmt_file" THEN 
      LET g_column1 = "lmt01"
   END IF 
   IF l_prog = "lnj_file" THEN 
      LET g_column1 = "lnj01"
   END IF 
   IF l_prog = "lnr_file" THEN 
      LET g_column1 = "lnr01"
   END IF 
  #IF l_prog = "lpa_file" THEN 
  #   LET g_column1 = "lpa01"
  #END IF 
  #IF l_prog = "lpb_file" THEN 
  #   LET g_column1 = "lpb01"
  #END IF 
   IF l_prog = "lpc_file" THEN 
      LET g_column1 = "lpc00"
      LET g_column2 = "lpc01"
   END IF 
  #IF l_prog = "lpd_file" THEN 
  #   LET g_column1 = "lpd01"
  #END IF 
  #IF l_prog = "lpe_file" THEN 
  #   LET g_column1 = "lpe01"
  #END IF 
  #IF l_prog = "lpf_file" THEN 
  #   LET g_column1 = "lpf01"
  #END IF 
  #IF l_prog = "lpg_file" THEN 
  #   LET g_column1 = "lpg01"
  #END IF 
   IF l_prog = "lph_file" THEN 
      LET g_column1 = "lph01"
   END IF 
   IF l_prog = "lrz_file" THEN 
      LET g_column1 = "lrz01"
   END IF 
   IF l_prog = "lpx_file" THEN 
      LET g_column1 = "lpx01"
   END IF 
   IF l_prog = "lqf_file" THEN 
      LET g_column1 = "lqf01"
   END IF 
   IF l_prog = "lnk_file" THEN 
      LET g_column1 = "lnk01"
      LET g_column2 = "lnk02"
      LET g_column3 = "lnk03"
      LET g_column4 = "lnk04"
   END IF       
   IF l_prog = "rya_file" THEN 
      LET g_column1 = "rya01"
   END IF 
   IF l_prog = "ryb_file" THEN 
      LET g_column1 = "ryb01"
   END IF 
   IF l_prog = "ryf_file" THEN 
      LET g_column1 = "ryf01"
   END IF 
   IF l_prog = "ryd_file" THEN 
      LET g_column1 = "ryd01"
      LET g_column2 = "ryd10"
   END IF 
   IF l_prog = "rxw_file" THEN 
      LET g_column1 = "rxw01"
   END IF 
   IF l_prog = "rta_file" THEN 
      LET g_column1 = "rta01"
      LET g_column2 = "rta02"
   END IF 
   IF l_prog = "rtb_file" THEN 
      LET g_column1 = "rtb01"
   END IF 
   IF l_prog = "rtc_file" THEN 
      LET g_column1 = "rtc01"
      LET g_column2 = "rtc02"
   END IF 
   IF l_prog = "rvi_file" THEN 
      LET g_column1 = "rvi01"
   END IF 
   IF l_prog = "rvj_file" THEN 
      LET g_column1 = "rvj02"
   END IF 
   IF l_prog = "rvk_file" THEN 
      LET g_column1 = "rvk01"
      LET g_column2 = "rvk02"
      LET g_column3 = "rvk04"
   END IF 
   IF l_prog = "obp_file" THEN 
      LET g_column1 = "obp01"
      LET g_column2 = "obp02"
      LET g_column3 = "obp03"
   END IF 
   IF l_prog = "obn_file" THEN 
      LET g_column1 = "obn01"
   END IF 
   IF l_prog = "obo_file" THEN 
      LET g_column1 = "obo01"
      LET g_column2 = "obo02"
   END IF 
   IF l_prog = "obq_file" THEN 
      LET g_column1 = "obq01"
   END IF 
   IF l_prog = "obr_file" THEN 
      LET g_column1 = "obr01"
   END IF 
   IF l_prog = "obs_file" THEN 
      LET g_column1 = "obs_file"
   END IF 
   IF l_prog = "obt_file" THEN 
      LET g_column1 = "obt01"
      LET g_column2 = "obt02"
   END IF 
   IF l_prog = "obu_file" THEN 
      LET g_column1 = "obu01"
   END IF 
   IF l_prog = "obv_file" THEN 
      LET g_column1 = "obv01"
      LET g_column2 = "obv02"
   END IF 
   IF l_prog = "obz_file" THEN 
      LET g_column1 =  "obz01"
   END IF 
   IF l_prog = "adj_file" THEN 
      LET g_column1 = "adj01"
   END IF 
   IF l_prog = "raa_file" THEN 
      LET g_column1 = "raa01"
      LET g_column2 = "raa02"
   END IF 
   IF l_prog = "tqb_file" THEN 
      LET g_column1 = "tqb01"
   END IF 
   IF l_prog = "imd_file" THEN 
      LET g_column1 = "imd01"
   END IF  
   IF l_prog = "ime_file" THEN 
      LET g_column1 = "ime01"
      LET g_column2 = "ime02"
   END IF 
   IF l_prog = "lqq_file" THEN 
      LET g_column1 = "lqq01"
      LET g_column1 = "lqq02"
   END IF 

   IF NOT cl_null(g_column1) AND NOT cl_null(g_value1) THEN
      LET g_gca01_o = g_column1 cLIPPED || "=" || g_value1 CLIPPED
      LET g_gca01_n = g_column1 CLIPPED || "=" || g_value1 CLIPPED
   END IF
   IF NOT cl_null(g_column2) AND NOT cl_null(g_value2) THEN
      LET g_gca02_o = g_column2 cLIPPED || "=" || g_value2 CLIPPED
      LET g_gca02_n = g_column2 CLIPPED || "=" || g_value2 CLIPPED
   END IF
   IF NOT cl_null(g_column3) AND NOT cl_null(g_value3) THEN
      LET g_gca03_o = g_column3 cLIPPED || "=" || g_value3 CLIPPED
      LET g_gca03_n = g_column3 CLIPPED || "=" || g_value3 CLIPPED
   END IF
   IF NOT cl_null(g_column4) AND NOT cl_null(g_value4) THEN
      LET g_gca04_o = g_column4 cLIPPED || "=" || g_value4 CLIPPED
      LET g_gca04_n = g_column4 CLIPPED || "=" || g_value4 CLIPPED
   END IF
   IF NOT cl_null(g_column5) AND NOT cl_null(g_value5) THEN
      LET g_gca05_o = g_column5 cLIPPED || "=" || g_value5 CLIPPED
      LET g_gca05_n = g_column5 CLIPPED || "=" || g_value5 CLIPPED
   END IF

   CALL s_doc_carry()
END FUNCTION

FUNCTION s_doc_carry()
   DEFINE l_sql        STRING
   DEFINE l_gca        RECORD LIKE gca_file.*
   DEFINE l_gcb        RECORD LIKE gcb_file.*
   DEFINE l_filename   LIKE   gca_file.gca07
   DEFINE i            LIKE   type_file.num5
   DEFINE l_cnt1       LIKE   type_file.num5
   DEFINE l_gca07      LIKE   gca_file.gca07

   DISPLAY "Source: ",g_db_center," to Target: ",g_db_sch   #background message

   #清除拋轉目地營運中心的資料
   LET l_cnt1 = 0
   IF cl_null(g_db_sch) THEN RETURN END IF

   LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(g_db_sch CLIPPED,'gca_file'),
               "    WHERE gca01 = '",g_gca01_n,"' "
   IF NOT cl_null(g_gca02_n) THEN   LET l_sql = l_sql CLIPPED," AND gca02 ='",g_gca02_n,"' "   END IF
   IF NOT cl_null(g_gca03_n) THEN   LET l_sql = l_sql CLIPPED," AND gca03 ='",g_gca03_n,"' "   END IF
   IF NOT cl_null(g_gca04_n) THEN   LET l_sql = l_sql CLIPPED," AND gca04 ='",g_gca04_n,"' "   END IF
   IF NOT cl_null(g_gca05_n) THEN   LET l_sql = l_sql CLIPPED," AND gca05 ='",g_gca05_n,"' "   END IF
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,g_db_sch) RETURNING l_sql
   PREPARE chk_doc_pre1 FROM l_sql
   DECLARE chk_doc_cur1 CURSOR WITH HOLD FOR chk_doc_pre1
   EXECUTE chk_doc_cur1 INTO l_cnt1

   DISPLAY "   Target gca_file rows: ",l_cnt1   #background message

   IF l_cnt1 > 0 THEN
      LET l_sql = "DELETE FROM ",cl_get_target_table(g_db_sch CLIPPED,'gcb_file'),
                  " WHERE gcb01 IN ( SELECT gca07 FROM ",cl_get_target_table(g_db_sch CLIPPED,'gca_file'),
                  "                   WHERE gca01 = '",g_gca01_n,"' "
      IF NOT cl_null(g_gca02_n) THEN   LET l_sql = l_sql CLIPPED," AND gca02 ='",g_gca02_n,"' "   END IF
      IF NOT cl_null(g_gca03_n) THEN   LET l_sql = l_sql CLIPPED," AND gca03 ='",g_gca03_n,"' "   END IF
      IF NOT cl_null(g_gca04_n) THEN   LET l_sql = l_sql CLIPPED," AND gca04 ='",g_gca04_n,"' "   END IF
      IF NOT cl_null(g_gca05_n) THEN   LET l_sql = l_sql CLIPPED," AND gca05 ='",g_gca05_n,"' "   END IF
      LET l_sql = l_sql CLIPPED,") "
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,g_db_sch) RETURNING l_sql
      EXECUTE IMMEDIATE l_sql
      IF SQLCA.sqlcode  THEN
          LET g_msg = 'DELETE ','gcb_file'
          CALL cl_err(g_msg,'lib-028',1)
          LET g_success = 'N'
          RETURN
      END IF
      DISPLAY "   Delete gcb_file rows: ",SQLCA.sqlerrd[3]   #background message

      LET l_sql = "DELETE FROM ",cl_get_target_table(g_db_sch CLIPPED,'gca_file'),
                  " WHERE gca01 = '",g_gca01_n,"' "
      IF NOT cl_null(g_gca02_n) THEN   LET l_sql = l_sql CLIPPED," AND gca02 ='",g_gca02_n,"' "   END IF
      IF NOT cl_null(g_gca03_n) THEN   LET l_sql = l_sql CLIPPED," AND gca03 ='",g_gca03_n,"' "   END IF
      IF NOT cl_null(g_gca04_n) THEN   LET l_sql = l_sql CLIPPED," AND gca04 ='",g_gca04_n,"' "   END IF
      IF NOT cl_null(g_gca05_n) THEN   LET l_sql = l_sql CLIPPED," AND gca05 ='",g_gca05_n,"' "   END IF
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,g_db_sch) RETURNING l_sql
      EXECUTE IMMEDIATE l_sql
      IF SQLCA.sqlcode  THEN
          LET g_msg = 'DELETE ','gca_file'
          CALL cl_err(g_msg,'lib-028',1)
          LET g_success = 'N'
          RETURN
      END IF
      DISPLAY "   Delete gca_file rows: ",SQLCA.sqlerrd[3]   #background message
   END IF

   #從拋轉來源(資料中心)取得資料並拋轉
   LET l_sql = " SELECT * FROM  ",cl_get_target_table(g_db_center CLIPPED,'gca_file')
   LET l_sql = l_sql CLIPPED,"  WHERE gca01 = '",g_gca01_o,"' "
   IF NOT cl_null(g_gca02_o) THEN     LET l_sql = l_sql CLIPPED," AND gca02 ='",g_gca02_o,"' "     END IF
   IF NOT cl_null(g_gca03_o) THEN     LET l_sql = l_sql CLIPPED," AND gca03 ='",g_gca03_o,"' "     END IF
   IF NOT cl_null(g_gca04_o) THEN     LET l_sql = l_sql CLIPPED," AND gca04 ='",g_gca04_o,"' "     END IF
   IF NOT cl_null(g_gca05_o) THEN     LET l_sql = l_sql CLIPPED," AND gca05 ='",g_gca05_o,"' "     END IF

   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,g_db_center) RETURNING l_sql
   PREPARE doc_pre1 FROM l_sql
   DECLARE doc_cur1 CURSOR WITH HOLD FOR doc_pre1
   FOREACH doc_cur1 INTO l_gca.*

      DISPLAY "   Source gca01: ",l_gca.gca01   #background message

      IF cl_null(g_db_sch) THEN CONTINUE FOREACH END IF

      IF NOT cl_null(g_gca01_n) THEN   LET l_gca.gca01 = g_gca01_n   END IF
      IF NOT cl_null(g_gca02_n) THEN   LET l_gca.gca02 = g_gca02_n   END IF
      IF NOT cl_null(g_gca03_n) THEN   LET l_gca.gca03 = g_gca03_n   END IF
      IF NOT cl_null(g_gca04_n) THEN   LET l_gca.gca04 = g_gca04_n   END IF
      IF NOT cl_null(g_gca05_n) THEN   LET l_gca.gca05 = g_gca05_n   END IF


      LET l_time = CURRENT HOUR TO FRACTION(3)    #取時分秒毫秒(毫秒取3位)
      LET l_filename = s_get_docnum(l_gca.gca08)

      DISPLAY "   filename: ",l_filename   #background message
      #Insert gca_file
      LET l_sql = " INSERT INTO ",cl_get_target_table(g_db_sch CLIPPED,'gca_file'),
                  "  (gca01 ,gca02 ,gca03 ,gca04 ,gca05 ,",
                  "   gca06 ,gca07 ,gca08 ,gca09 ,gca10 ,",
                  "   gca11 ,gca12 ,gca13 ,gca14 ,gca15 ,",
                  "   gca16 , gca17 )",
                  " VALUES ( ?,?,?,?,?,   ?,?,?,?,?, ",
                  "          ?,?,?,?,?,   ?,?       )"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,g_db_sch) RETURNING l_sql
      PREPARE ins_doc FROM l_sql
      EXECUTE ins_doc USING g_gca01_n  , l_gca.gca02, l_gca.gca03, l_gca.gca04, l_gca.gca05,
                            l_gca.gca06, l_filename , l_gca.gca08, l_gca.gca09, l_gca.gca10,
                            l_gca.gca11, l_gca.gca12, l_gca.gca13, l_gca.gca14, l_gca.gca15,
                            l_gca.gca16, l_gca.gca17
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          LET g_msg = 'INSERT ','gca_file'
          CALL cl_err(g_msg,'lib-028',1)
          LET g_success = 'N'
          EXIT FOREACH
      END IF

      DISPLAY "   Insert gca_file rows: ",SQLCA.sqlerrd[3]     #background message

      #Insert gcb_file
      LET l_sql = " SELECT * FROM ",cl_get_target_table(g_db_center CLIPPED,'gcb_file'),
                  "   WHERE gcb01= '",l_gca.gca07,"' "
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,g_db_center) RETURNING l_sql
      PREPARE sel_gcb_pre FROM l_sql
      DECLARE sel_gcb_cur CURSOR WITH HOLD FOR sel_gcb_pre
      LOCATE l_gcb.gcb09 IN MEMORY
      FOREACH sel_gcb_cur INTO l_gcb.*
         LET l_sql = " INSERT INTO ",cl_get_target_table(g_db_sch CLIPPED,'gcb_file'),
                     "   ( gcb01 ,gcb02 ,gcb03 ,gcb04 ,gcb05 ,",
                     "     gcb06 ,gcb07 ,gcb08 ,gcb09 ,gcb10 ,",
                     "     gcb11 ,gcb12 ,gcb13 ,gcb14 ,gcb15 ,",
                     "     gcb16 ,gcb17 ,gcb18 )",
                     " VALUES ( ?,?,?,?,?,   ?,?,?,?,?, ",
                     "          ?,?,?,?,?,   ?,?,?     )"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,g_db_sch) RETURNING l_sql
         PREPARE ins_doc2 FROM l_sql
         EXECUTE ins_doc2 USING l_filename , l_gcb.gcb02, l_gcb.gcb03, l_gcb.gcb04, l_gcb.gcb05,
                                l_gcb.gcb06, l_gcb.gcb07, l_gcb.gcb08, l_gcb.gcb09, l_gcb.gcb10,
                                l_gcb.gcb11, l_gcb.gcb12, l_gcb.gcb13, l_gcb.gcb14, l_gcb.gcb15,
                                l_gcb.gcb16, l_gcb.gcb17, l_gcb.gcb18
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
             LET g_msg = 'INSERT ','gcb_file'
             CALL cl_err(g_msg,'lib-028',1)
             LET g_success = 'N'
             EXIT FOREACH
         END IF

         DISPLAY "   Insert gcb_file rows: ",SQLCA.sqlerrd[3]     #background message

         FREE l_gcb.gcb09
      END FOREACH
   END FOREACH
END FUNCTION

FUNCTION s_get_docnum(p_gca08)
   DEFINE p_gca08    LIKE gca_file.gca08
   DEFINE l_filename LIKE gca_file.gca07

      LET l_time = CURRENT HOUR TO FRACTION(3)    #取時分秒毫秒(毫秒取3位)
      LET l_filename = p_gca08 CLIPPED, "-",
                       FGL_GETPID() USING "<<<<<<<<<<", "-",
                       TODAY USING "YYYYMMDD", "-",
                       l_time.subString(1,2), l_time.subString(4,5), l_time.subString(7,8), l_time.subString(10,12)
   RETURN l_filename
END FUNCTION

