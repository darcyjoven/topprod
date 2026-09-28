# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_chart_budget_s5.4gl
# Descriptions...: 各部門費用使用比例
# Date & Author..: No.FUN-BA0095 2011/11/21 By qiaozy
# Input Parameter: p_year     年度
#                  p_acccode  科目編號
#                  p_expreason   費用原因
#                  p_deptno   部門編號
#                  p_projno   專案編號            
#                  p_loc      圖表位置
# Usage..........: CALL s_chart_budget_s5(p_year,p_expreason,p_deptno,p_projno,p_acccode,p_loc)
# Modify.........: 

DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION s_chart_budget_s5(p_year,p_expreason,p_deptno,p_projno,p_acccode,p_loc)
DEFINE p_year       LIKE type_file.num5
DEFINE p_projno     LIKE afc_file.afc042
DEFINE p_expreason  LIKE afc_file.afc01
DEFINE p_deptno     LIKE afc_file.afc041
DEFINE p_acccode    LIKE afc_file.afc02
DEFINE p_loc        LIKE type_file.chr10
DEFINE l_sql        STRING
DEFINE l_sql1       STRING
DEFINE l_substr     STRING
DEFINE l_str1       STRING
DEFINE l_str2       STRING
DEFINE l_afc05      LIKE afc_file.afc05
DEFINE l_afc06      LIKE afc_file.afc06
DEFINE l_afc07      LIKE afc_file.afc07
DEFINE l_aag02      LIKE aag_file.aag02  #科目名稱
DEFINE l_gem02      LIKE gem_file.gem02  #部門名稱
DEFINE l_aag_str    STRING               #
DEFINE l_pja02      LIKE pja_file.pja02  #專案名稱
DEFINE l_azf03      LIKE azf_file.azf03  #費用原因說明
DEFINE l_chk_auth   STRING

   WHENEVER ERROR CONTINUE

   CALL cl_chart_init(p_loc) #

   IF NOT s_chart_auth("s_chart_budget_s5",g_user) THEN
      LET l_chk_auth=cl_getmsg('azz1135',g_lang) CLIPPED
      CALL cl_chart_set_empty(p_loc, l_chk_auth)
      RETURN
   END IF


   #抓取期別
   
   LET l_afc05 = 0
   LET l_sql = "SELECT UNIQUE afc05 ",
               "  FROM afc_file",
               " WHERE afc00= '",g_aza.aza81,"' ",
               "   AND afc03= '",p_year,"' "
   IF NOT cl_null(p_projno) THEN LET l_sql = l_sql CLIPPED," AND afc042 = '",p_projno,"' " END IF
   IF NOT cl_null(p_expreason) THEN LET l_sql = l_sql CLIPPED," AND afc01 = '",p_expreason,"' " END IF
   IF NOT cl_null(p_deptno) THEN LET l_sql = l_sql CLIPPED," AND afc041 = '",p_deptno,"' " END IF
   LET l_sql=l_sql CLIPPED," ORDER BY afc05"
   PREPARE cost_sale_pre FROM l_sql
   DECLARE cost_sale_cs CURSOR FOR cost_sale_pre
   FOREACH cost_sale_cs INTO l_afc05
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET l_afc06=0
      LET l_afc07=0
      #抓取費用
      LET l_sql1 = "SELECT SUM(afc06),SUM(afc07) ",
                   "  FROM afc_file",
                   " WHERE afc00= '",g_aza.aza81,"' ",
                   "   AND afc03= '",p_year,"' ",
                   "   AND afc05= ",l_afc05
      IF NOT cl_null(p_acccode) THEN LET l_sql1 = l_sql1 CLIPPED," AND afc02 = '",p_acccode,"' " END IF
      IF NOT cl_null(p_projno) THEN LET l_sql1 = l_sql1 CLIPPED," AND afc042 = '",p_projno,"' " END IF
      IF NOT cl_null(p_expreason) THEN LET l_sql1 = l_sql1 CLIPPED," AND afc01 = '",p_expreason,"' " END IF
      IF NOT cl_null(p_deptno) THEN LET l_sql1 = l_sql1 CLIPPED," AND afc041 = '",p_deptno,"' " END IF
      PREPARE cost_sale_pre1 FROM l_sql1
      EXECUTE cost_sale_pre1 INTO l_afc06,l_afc07
      IF cl_null(l_afc06) THEN LET l_afc06=0 END IF
      IF cl_null(l_afc07) THEN LET l_afc07=0 END IF
      LET l_str1=cl_getmsg('azz1110',g_lang)
      LET l_str2=cl_getmsg('azz1111',g_lang)
      CALL cl_chart_array_data(p_loc,"categories","",l_afc05)
      CALL cl_chart_array_data(p_loc,"dataset",l_str1,l_afc06)
      CALL cl_chart_array_data(p_loc,"dataset",l_str2,l_afc07)
      
   END FOREACH
   
   
   INITIALIZE l_substr TO NULL
   LET l_substr = cl_getmsg('agl-172',g_lang),":",p_year  #年度
   IF NOT cl_null( p_acccode) THEN 
      SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01 = p_acccode
      LET l_substr = l_substr CLIPPED," / ",cl_getmsg('azz1106',g_lang),":",p_acccode CLIPPED,"(",l_aag02,")"  #科目分類
   END IF
   IF NOT cl_null( p_expreason ) THEN 
      SELECT azf03 INTO l_azf03 FROM azf_file WHERE azf01 = p_expreason AND azf02='2'
      LET l_substr = l_substr CLIPPED," / ",cl_getmsg('azz1109',g_lang),":",p_expreason CLIPPED,"(",l_azf03,")" #費用原因
   END IF
   IF NOT cl_null( p_deptno ) THEN 
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=p_deptno
      LET l_substr = l_substr CLIPPED," / ",cl_getmsg('azz1107',g_lang),":",p_deptno CLIPPED,"(",l_gem02,")"  #部門名稱
   END IF
   IF NOT cl_null( p_projno ) THEN 
      SELECT pja02 INTO l_pja02 FROM pja_file WHERE pja01=p_projno
      LET l_substr = l_substr CLIPPED," / ",cl_getmsg('azz1108',g_lang),":",p_projno CLIPPED,"(",l_pja02,")"  #專案名稱
   END IF
   IF NOT cl_null(l_substr) THEN
      CALL cl_chart_attr(p_loc,"subcaption",l_substr)    #設定子標題
   END IF
   CALL cl_chart_create(p_loc,"s_chart_budget_s5") 
   CALL cl_chart_clear(p_loc)   


END FUNCTION
      
#FUN-BA0095
