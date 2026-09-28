# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_chart_budget_s1.4gl
# Descriptions...: 各費用原因費用使用比例
# Date & Author..: No.FUN-BA0095 2011/11/17 By qiaozy
# Input Parameter: p_year     年度
#                  p_acccode  科目
#                  p_deptno   部門編號
#                  p_projno   專案代號
#                  p_period   期別
#                  p_loc      圖表位置
# Usage..........: CALL s_chart_budget_s1(p_year,p_deptno,p_projno,p_acccode,p_period,p_loc)
# Modify.........: 

DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION s_chart_budget_s1(p_year,p_deptno,p_projno,p_acccode,p_period,p_loc)
DEFINE p_year       LIKE type_file.num5
DEFINE p_acccode    LIKE afc_file.afc02
DEFINE p_deptno     LIKE afc_file.afc041
DEFINE p_projno     LIKE afc_file.afc042
DEFINE p_period     LIKE afc_file.afc05
DEFINE p_loc        LIKE type_file.chr10
DEFINE l_sql        STRING
DEFINE l_substr     STRING
DEFINE l_sale       RECORD               #費用原因
             afc01  LIKE afc_file.afc01,
             sale   LIKE afc_file.afc07
                    END RECORD
DEFINE l_aag02      LIKE aag_file.aag02 #科目名稱
DEFINE l_gem02      LIKE gem_file.gem02  #部門名稱
DEFINE l_afc_str    STRING               #
DEFINE l_pja02      LIKE pja_file.pja02  #專案名稱
DEFINE l_azf03      LIKE azf_file.azf03  #費用原因說明
DEFINE l_aag_str    STRING
DEFINE l_gem_str    STRING
DEFINE l_chk_auth        STRING


   WHENEVER ERROR CONTINUE

   CALL cl_chart_init(p_loc) #

   IF NOT s_chart_auth("s_chart_budget_s1",g_user) THEN 
      LET l_chk_auth=cl_getmsg('azz1135',g_lang) CLIPPED
      CALL cl_chart_set_empty(p_loc, l_chk_auth)
      RETURN
   END IF

   #抓取費用
   INITIALIZE l_sale.afc01 TO NULL
   LET l_sale.sale=0
   LET l_sql = "SELECT afc01,SUM(afc07) ",
               "  FROM afc_file",
               " WHERE afc03= '",p_year,"' ",
               "   AND afc00= '",g_aza.aza81 CLIPPED,"' "
   IF NOT cl_null(p_acccode) THEN LET l_sql = l_sql CLIPPED," AND afc02 = '",p_acccode,"' " END IF
   IF NOT cl_null(p_deptno) THEN LET l_sql = l_sql CLIPPED," AND afc041 = '",p_deptno,"' " END IF
   IF NOT cl_null(p_projno) THEN LET l_sql = l_sql CLIPPED," AND afc042 = '",p_projno,"' " END IF
   IF NOT cl_null(p_period) THEN LET l_sql = l_sql CLIPPED," AND afc05 = '",p_period,"' " END IF
   LET l_sql = l_sql CLIPPED," GROUP BY afc01"
   PREPARE cost_sale_pre FROM l_sql
   DECLARE cost_sale_cs CURSOR FOR cost_sale_pre
   FOREACH cost_sale_cs INTO l_sale.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF cl_null(l_sale.sale) THEN LET l_sale.sale = 0 END IF
      INITIALIZE l_azf03,l_afc_str TO NULL
      SELECT azf03 INTO l_azf03 FROM azf_file WHERE azf01=l_sale.afc01 AND azf02='2'
      IF cl_null(l_azf03) THEN 
         LET l_afc_str=l_sale.afc01 CLIPPED
      ELSE 
         LET l_afc_str=l_sale.afc01 CLIPPED,"(",l_azf03 CLIPPED,")"
      END IF
      CALL cl_chart_array_data(p_loc,"dataset",l_afc_str,l_sale.sale)
      INITIALIZE l_sale.afc01 TO NULL
      LET l_sale.sale=0
   END FOREACH
   
   INITIALIZE l_substr TO NULL
   LET l_substr = cl_getmsg('agl-172',g_lang),":",p_year  #年度
   IF NOT cl_null(p_period) THEN
      LET l_substr = l_substr CLIPPED," / ",cl_getmsg('azz1105',g_lang),":",p_period CLIPPED  #期別
   END IF
   IF NOT cl_null( p_acccode) THEN 
      SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01 = p_acccode
      LET l_substr = l_substr CLIPPED," / ",cl_getmsg('azz1106',g_lang),":",p_acccode CLIPPED,"(",l_aag02,")"  #科目分類
   END IF
   IF NOT cl_null( p_deptno ) THEN 
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = p_deptno
      LET l_substr = l_substr CLIPPED," / ",cl_getmsg('azz1107',g_lang),":",p_deptno CLIPPED,"(",l_gem02,")" #部門分類
   END IF
   IF NOT cl_null( p_projno ) THEN 
      SELECT pja02 INTO l_pja02 FROM pja_file WHERE pja01=p_projno
      LET l_substr = l_substr CLIPPED," / ",cl_getmsg('azz1108',g_lang),":",p_projno CLIPPED,"(",l_pja02,")"  #項目分類
   END IF

   IF NOT cl_null(l_substr) THEN
      CALL cl_chart_attr(p_loc,"subcaption",l_substr)    #設定子標題
   END IF
   CALL cl_chart_create(p_loc,"s_chart_budget_s1")  
   CALL cl_chart_clear(p_loc)   


END FUNCTION
      

#FUN-BA0095
