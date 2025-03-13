# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_chart_purreturn_s1.4gl
# Descriptions...: 各年度銷售業績
# Date & Author..: No.FUN-BA0095 2011/11/16 By linlin
# Input Parameter: p_loc  圖表位置
#                  p_year 年度
#                  p_grup 部門編號
# Usage..........: CALL s_chart_purreturn_s1(p_year,p_loc,p_grup)
# Modify.........: 

DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION s_chart_purreturn_s1(p_year,p_loc,p_grup)
DEFINE p_loc                   LIKE type_file.chr10
DEFINE p_year                  LIKE type_file.num5
DEFINE p_grup                  LIKE rvu_file.rvu06
DEFINE l_year                  LIKE type_file.num5
DEFINE l_month                 LIKE type_file.num5
DEFINE purreturn_sum           LIKE apb_file.apb10 #銷售金額匯總
DEFINE l_str                   STRING               #子標題
DEFINE l_sql                   STRING
DEFINE l_chk_auth              STRING
DEFINE l_gem02                 LIKE gem_file.gem02

   WHENEVER ERROR CONTINUE
   CALL cl_chart_init(p_loc) #初始WebComponent的資料

   IF NOT s_chart_auth("s_chart_purreturn_s1",g_user) AND cl_null(p_grup) THEN 
      LET l_chk_auth = cl_getmsg('azz1135',g_lang) CLIPPED
      CALL cl_chart_set_empty(p_loc, l_chk_auth)  
      RETURN 
   END IF                                            #判斷權限
   IF cl_null(p_year) THEN LET p_year = YEAR(TODAY) END IF
   #抓取金額
   LET l_year = p_year
   FOR  l_month = 1  TO  12
      LET l_sql = " SELECT SUM(apb10) FROM rvu_file,rvv_file,apb_file ",
                  "  WHERE rvu01=rvv01 ",
                  "    AND rvv01=apb21 ",
                  "    AND rvv02=apb22 ",
                  "    AND rvuconf='Y' ",
                  "    AND YEAR(rvu03)='",l_year,"'",
                  "    AND MONTH(rvu03)='",l_month,"'",
                  "    AND rvu00<>'1'"
      IF NOT cl_null(p_grup) THEN LET l_sql = l_sql CLIPPED," AND rvu06 = '",p_grup,"' " END IF
      PREPARE sel_rvv_pre FROM l_sql
      DECLARE sel_rvv_cs CURSOR FOR sel_rvv_pre
      FOREACH sel_rvv_cs INTO purreturn_sum
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         IF cl_null(purreturn_sum) THEN LET purreturn_sum = 0 END IF
         CALL cl_chart_array_data(p_loc,"categories","",l_month)
         CALL cl_chart_array_data(p_loc,"dataset"," ",purreturn_sum) #
      END FOREACH
   END FOR
   
   LET l_str = cl_getmsg('agl-172',g_lang) CLIPPED,":",p_year CLIPPED
   IF NOT cl_null(p_grup) THEN
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = p_grup
      LET l_str = l_str CLIPPED," / ",cl_getmsg('sub-100',g_lang) CLIPPED,":",p_grup CLIPPED,"(",l_gem02,")"
   END IF 
   CALL cl_chart_attr(p_loc,"subcaption",l_str)    #設定子標題
   IF NOT cl_null(p_grup) THEN
      CALL cl_chart_create(p_loc,"s_chart_purreturn2_s1")
   ELSE
      CALL cl_chart_create(p_loc,"s_chart_purreturn_s1")
   END IF
   CALL cl_chart_clear(p_loc) #清除p_loc相關變數資料(釋放記憶體)
   

END FUNCTION

#FUN-BA0095
