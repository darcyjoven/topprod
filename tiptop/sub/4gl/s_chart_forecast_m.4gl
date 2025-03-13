# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_chart_forecast_m.4gl
# Descriptions...: 年度銷售目標金額
# Date & Author..: No.FUN-BA0095 2011/11/10 By linlin
# Input Parameter: p_loc  圖表位置
# Usage..........: CALL s_chart_forecast_m(p_loc)
# Modify.........: 

DATABASE ds

GLOBALS "../../config/top.global"
GLOBALS "../4gl/s_chart.global"

FUNCTION s_chart_forecast_m(p_loc)
DEFINE p_loc                 LIKE type_file.chr10
DEFINE nyear                 LIKE type_file.num5
DEFINE forecast_performance  LIKE rwt_file.rwt201 #銷售目標
DEFINE l_chk_auth            STRING

   WHENEVER ERROR CONTINUE

   CALL cl_chart_init(p_loc) #初始WebComponent的資料

   IF NOT s_chart_auth("s_chart_forecast_m",g_user) THEN 
      LET l_chk_auth = cl_getmsg('azz1135',g_lang) CLIPPED
      CALL cl_chart_set_empty(p_loc, l_chk_auth)  
      RETURN 
   END IF                                            #判斷權限

   LET forecast_performance = 0

   FOR nyear = YEAR(TODAY) - 4 TO YEAR(TODAY)

      #銷售目標金額
      SELECT rwt201+rwt202+rwt203+rwt204+rwt205+rwt206+
             rwt207+rwt208+rwt209+rwt210+rwt211+rwt212 
        INTO forecast_performance 
        FROM rwt_file        
       WHERE rwt01 = g_plant
         AND rwt02 = nyear
      IF cl_null(forecast_performance) THEN LET forecast_performance = 0 END IF

      CALL cl_chart_array_data(p_loc,"categories","",nyear)
      CALL cl_chart_array_data(p_loc,"dataset"," ",forecast_performance)
   END FOR
   CALL cl_chart_create(p_loc,"s_chart_forecast_m")
   CALL cl_chart_clear(p_loc) #清除p_loc相關變數資料(釋放記憶體)
   
   #以最後一個年度連動其他5個圖表
   CALL s_chart_forecast_s1(nyear-1,"wc_2")
   CALL s_chart_forecast_s2(nyear-1,'',"wc_3")
   CALL s_chart_forecast_s3(nyear-1,'',"wc_4")
   CALL s_chart_forecast_s4(nyear-1,'','',"wc_5")
   CALL s_chart_forecast_s5(nyear-1,'','',"wc_6")

   LET g_lnkchart3.argv1 = nyear-1

END FUNCTION

#FUN-BA0095
