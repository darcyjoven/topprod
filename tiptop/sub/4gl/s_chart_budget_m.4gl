# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: s_chart_budget_m.4gl
# Descriptions...: 各年度銷售業績
# Date & Author..: No.FUN-BA0095 2011/11/16 By qiaozy
# Input Parameter: p_loc  圖表位置
# Usage..........: CALL s_chart_budget_m(p_loc)
# Modify.........: 

DATABASE ds

GLOBALS "../../config/top.global"
GLOBALS "../4gl/s_chart.global"

FUNCTION s_chart_budget_m(p_loc)
DEFINE p_loc             LIKE type_file.chr10
DEFINE nyear             LIKE type_file.num5
DEFINE cost_sum          LIKE afc_file.afc07 #费用金額匯總
DEFINE l_chk_auth        STRING


   CALL cl_chart_init(p_loc) #初始WebComponent的資料

   IF NOT s_chart_auth("s_chart_budget_m",g_user) THEN 
      LET l_chk_auth=cl_getmsg('azz1135',g_lang) CLIPPED
      CALL cl_chart_set_empty(p_loc, l_chk_auth)
      RETURN 
   END IF #判斷權限

   FOR nyear = YEAR(TODAY) - 4 TO YEAR(TODAY)

      #各年度費用金額
      LET cost_sum=0
      SELECT SUM(afc07) INTO cost_sum FROM afc_file
       WHERE afc00=g_aza.aza81
         AND afc03=nyear
      IF cl_null(cost_sum) THEN LET cost_sum=0 END IF
      CALL cl_chart_array_data(p_loc,"categories","",nyear)
      CALL cl_chart_array_data(p_loc,"dataset"," ",cost_sum) #
   END FOR

   CALL cl_chart_create(p_loc,"s_chart_budget_m")
   CALL cl_chart_clear(p_loc) #清除p_loc相關變數資料(釋放記憶體)
   
   #以最後一個年度連動其他5個圖表
   CALL s_chart_budget_s1(nyear-1,'','','','',"wc_2")
   CALL s_chart_budget_s2(nyear-1,'','','','',"wc_3")
   CALL s_chart_budget_s3(nyear-1,'','','','',"wc_4")
   CALL s_chart_budget_s4(nyear-1,'','','','',"wc_5")
   CALL s_chart_budget_s5(nyear-1,'','','','',"wc_6")

   LET g_lnkchart6.argv1 = nyear-1

END FUNCTION

#FUN-BA0095
