# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_chart_purreturn_s5.4gl
# Descriptions...: 各年度銷售業績
# Date & Author..: No.FUN-BA0095 2011/11/17 By linlin
# Input Parameter: p_loc       圖表位置
#                  p_year      年度
#                  p_month     月份
#                  p_rtnreason 倉貨原因
#                  p_itemclass 產品分類
#                  p_vendclass 廠商分類
#                  p_grup      部門編號
# Usage..........: CALL s_chart_purreturn_s5(p_year,p_month,p_rtnreason,p_itemclass,p_vendclass,p_loc,p_grup)
# Modify.........: 

DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION s_chart_purreturn_s5(p_year,p_month,p_rtnreason,p_itemclass,p_vendclass,p_loc,p_grup)
DEFINE p_loc                   LIKE type_file.chr10
DEFINE p_year                  LIKE type_file.num5
DEFINE p_month                 LIKE type_file.num5
DEFINE p_itemclass             LIKE ima_file.ima131 
DEFINE p_rtnreason             LIKE rvv_file.rvv26
DEFINE p_vendclass             LIKE pmc_file.pmc02
DEFINE p_vendorno              LIKE rvu_file.rvu04
DEFINE p_grup                  LIKE rvu_file.rvu06
DEFINE purreturn_sum           LIKE apb_file.apb10 #銷售金額匯總
DEFINE l_substr                STRING              #子標題
DEFINE l_str1                  STRING   
DEFINE l_sql                   STRING
DEFINE l_rvu01                 LIKE rvu_file.rvu01
DEFINE l_pmc03                 LIKE pmc_file.pmc03 #廠商名稱
DEFINE l_azf03                 LIKE azf_file.azf03 #銷退原因說明
DEFINE l_oba02                 LIKE oba_file.oba02
DEFINE l_pmc02                 LIKE pmc_file.pmc02 #廠商分類
DEFINE l_pmy02                 LIKE pmy_file.pmy02
DEFINE l_chk_auth              STRING
DEFINE l_gem02                 LIKE gem_file.gem02

   WHENEVER ERROR CONTINUE
   CALL cl_chart_init(p_loc) #初始WebComponent的資料

   IF NOT s_chart_auth("s_chart_purreturn_s5",g_user) AND cl_null(p_grup) THEN 
      LET l_chk_auth = cl_getmsg('azz1135',g_lang) CLIPPED
      CALL cl_chart_set_empty(p_loc, l_chk_auth)  
      RETURN 
   END IF                                            #判斷權限
   #抓取資料
   LET l_sql = "SELECT rvu04,SUM(apb10)", 
               "  FROM rvu_file", 
               "  JOIN rvv_file  ON rvu01 = rvv01 AND rvu00<>'1' AND rvuconf='Y'",      
               "  JOIN apb_file  ON rvv01 = apb21 AND rvv02 = apb22",     
               "  JOIN ima_file  ON ima01 = rvv31",
               "  JOIN pmc_file  ON pmc01 = rvu04",
               " WHERE YEAR(rvu03) = '",p_year,"'"
     
   IF NOT cl_null(p_month) THEN 
      LET l_sql = l_sql CLIPPED, " AND MONTH(rvu03)= '",p_month CLIPPED,"'"
   END IF
   IF NOT cl_null(p_rtnreason) THEN 
      LET l_sql = l_sql CLIPPED, " AND rvv26 = '",p_rtnreason CLIPPED,"'"
   END IF
   IF NOT cl_null(p_itemclass) THEN 
      LET l_sql = l_sql CLIPPED, " AND ima131 = '",p_itemclass CLIPPED,"'"
   END IF
   IF NOT cl_null(p_vendclass) THEN 
      LET l_sql = l_sql CLIPPED, " AND pmc02 = '",p_vendclass CLIPPED,"'"
   END IF
   IF NOT cl_null(p_grup) THEN LET l_sql = l_sql CLIPPED," AND rvu06 = '",p_grup,"' " END IF
   LET l_sql = l_sql CLIPPED, " GROUP BY rvu04"
   PREPARE sel_rvv_pre FROM l_sql
   DECLARE sel_rvv_cs CURSOR FOR sel_rvv_pre
   FOREACH sel_rvv_cs INTO l_rvu01,purreturn_sum
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF cl_null(purreturn_sum) THEN LET purreturn_sum = 0 END IF
      SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01 = l_rvu01
      LET l_str1 = l_rvu01 CLIPPED,"(",l_pmc03 CLIPPED,")" #廠商編號(廠商名稱)
      CALL cl_chart_array_data(p_loc,"dataset",l_str1,purreturn_sum) #
      INITIALIZE l_rvu01,purreturn_sum TO NULL
   END FOREACH
   
   INITIALIZE l_substr TO NULL
   LET l_substr = cl_getmsg('agl-172',g_lang),":",p_year  #年度
   IF NOT cl_null( p_month ) THEN                         #月份
      LET l_substr = l_substr CLIPPED," / ",cl_getmsg('azz-159',g_lang),":",p_month CLIPPED
   END IF 
   IF NOT cl_null( p_rtnreason ) THEN                     #倉貨原因
      SELECT azf03 INTO l_azf03 FROM azf_file WHERE azf01 = p_rtnreason AND azf02='2'
      LET l_substr = l_substr CLIPPED, " / ",cl_getmsg('azz-195',g_lang),":",p_rtnreason CLIPPED, "(", l_azf03 , ")"
   END IF
   IF NOT cl_null( p_itemclass ) THEN                     #產品分類
      SELECT oba02 INTO l_oba02 FROM oba_file WHERE oba01 = p_itemclass
      LET l_substr = l_substr CLIPPED, " / ",cl_getmsg('azz-191',g_lang),":",p_itemclass  CLIPPED, "(", l_oba02 , ")"
   END IF
   IF NOT cl_null( p_vendclass ) THEN                     #廠商分類
      SELECT pmy02 INTO l_pmy02 FROM pmy_file WHERE pmy01 = p_vendclass
      LET l_substr = l_substr CLIPPED, " / ",cl_getmsg('azz-192',g_lang),":",p_vendclass CLIPPED,"(",l_pmy02,")"
   END IF
   IF NOT cl_null(p_grup) THEN
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = p_grup
      LET l_substr = l_substr CLIPPED," / ",cl_getmsg('sub-100',g_lang),":",p_grup CLIPPED,"(",l_gem02,")"      #部門
   END IF

   IF NOT cl_null(l_substr) THEN
      CALL cl_chart_attr(p_loc,"subcaption",l_substr)    #設定子標題
   END IF
   IF NOT cl_null(p_grup) THEN
      CALL cl_chart_create(p_loc,"s_chart_purreturn2_s5")
   ELSE
      CALL cl_chart_create(p_loc,"s_chart_purreturn_s5")
   END IF
   CALL cl_chart_clear(p_loc) #清除p_loc相關變數資料(釋放記憶體)
END FUNCTION

#FUN-BA0095
