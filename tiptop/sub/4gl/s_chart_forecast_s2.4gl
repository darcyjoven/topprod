# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_chart_forecast_s2.4gl
# Descriptions...: 各營運中心銷售目標金額
# Date & Author..: No.FUN-BA0095 2011/11/10 By linlin
# Input Parameter: p_year   年度
#                  p_month  月份
#                  p_loc   圖表位置
# Usage..........: CALL s_chart_forecast_s2(p_year,p_month,p_loc)
# Modify.........: 

DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION s_chart_forecast_s2(p_year,p_month,p_loc)
DEFINE p_year                   LIKE type_file.num5
DEFINE p_loc                    LIKE type_file.chr10
DEFINE p_month                  LIKE type_file.num5
DEFINE l_sql                    STRING
DEFINE l_str                    STRING               #子標題
DEFINE l_str1                   STRING            
DEFINE forecast_performance     LIKE rwt_file.rwt201#銷售目標
DEFINE forecast_s2_shopsum      LIKE rwt_file.rwt201 #各店銷售總金額
DEFINE forecast_s3              LIKE rwt_file.rwt201 #分配金額
DEFINE forecast_s4              LIKE rwt_file.rwt201 #未分配金額
DEFINE l_rwt201                  LIKE rwt_file.rwt201  
DEFINE l_rwt202                  LIKE rwt_file.rwt202  
DEFINE l_rwt203                  LIKE rwt_file.rwt203  
DEFINE l_rwt204                  LIKE rwt_file.rwt204  
DEFINE l_rwt205                  LIKE rwt_file.rwt205  
DEFINE l_rwt206                  LIKE rwt_file.rwt206  
DEFINE l_rwt207                  LIKE rwt_file.rwt207  
DEFINE l_rwt208                  LIKE rwt_file.rwt208  
DEFINE l_rwt209                  LIKE rwt_file.rwt209 
DEFINE l_rwt210                  LIKE rwt_file.rwt210
DEFINE l_rwt211                  LIKE rwt_file.rwt211  
DEFINE l_rwt212                  LIKE rwt_file.rwt212 
DEFINE l_n                       LIKE type_file.num5 
DEFINE l_azw01                   LIKE rtz_file.rtz01 #營運中心
DEFINE l_chk_auth               STRING

   WHENEVER ERROR CONTINUE

   CALL cl_chart_init(p_loc) 

   IF NOT s_chart_auth("s_chart_forecast_s2",g_user) THEN
      LET l_chk_auth = cl_getmsg('azz1135',g_lang) CLIPPED
      CALL cl_chart_set_empty(p_loc, l_chk_auth)  
      RETURN 
   END IF                                            #判斷權限

   IF cl_null(p_year) THEN LET p_year = YEAR(TODAY) END IF

   SELECT rwt201,rwt202,rwt203,rwt204,rwt205,rwt206,rwt207,
          rwt208,rwt209,rwt210,rwt211,rwt212 
     INTO l_rwt201,l_rwt202,l_rwt203,l_rwt204,l_rwt205,l_rwt206,l_rwt207,
          l_rwt208,l_rwt209,l_rwt210,l_rwt211,l_rwt212
     FROM rwt_file
    WHERE rwt01 = g_plant
      AND rwt02 = p_year

   IF NOT cl_null(p_month) THEN 
      CASE p_month
         WHEN 1  LET forecast_performance=l_rwt201 
         WHEN 2  LET forecast_performance=l_rwt202
         WHEN 3  LET forecast_performance=l_rwt203 
         WHEN 4  LET forecast_performance=l_rwt204 
         WHEN 5  LET forecast_performance=l_rwt205
         WHEN 6  LET forecast_performance=l_rwt206 
         WHEN 7  LET forecast_performance=l_rwt207 
         WHEN 8  LET forecast_performance=l_rwt208 
         WHEN 9  LET forecast_performance=l_rwt209 
         WHEN 10 LET forecast_performance=l_rwt210
         WHEN 11 LET forecast_performance=l_rwt211 
         WHEN 12 LET forecast_performance=l_rwt212
      END CASE
   ELSE 
      SELECT rwt201+rwt202+rwt203+rwt204+rwt205+rwt206+rwt207+rwt208
             +rwt209+rwt210+rwt211+rwt212 
        INTO forecast_performance
        FROM rwt_file
       WHERE rwt01 = g_plant
         AND rwt02 = p_year
   END IF

   LET forecast_s3 = 0
   LET forecast_s4 = 0
   INITIALIZE l_rwt201,l_rwt202,l_rwt203,l_rwt204,l_rwt205,l_rwt206,
              l_rwt207,l_rwt208,l_rwt209,l_rwt210,l_rwt211,l_rwt212
           TO NULL
   LET l_sql = "SELECT azw01 FROM azw_file WHERE azw01 IN ",g_auth CLIPPED
   PREPARE sel_azw_pre FROM l_sql
   DECLARE sel_azw_cs CURSOR FOR sel_azw_pre
   FOREACH sel_azw_cs INTO l_azw01
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET forecast_s2_shopsum = NULL
      SELECT COUNT(*) INTO l_n FROM azw_file WHERE azw07 = l_azw01
      IF l_n > 0 THEN CONTINUE FOREACH END IF 
      SELECT rwt201,rwt202,rwt203,rwt204,rwt205,rwt206,rwt207,
             rwt208,rwt209,rwt210,rwt211,rwt212 
        INTO l_rwt201,l_rwt202,l_rwt203,
             l_rwt204,l_rwt205,l_rwt206,l_rwt207,l_rwt208,l_rwt209,l_rwt210,
             l_rwt211,l_rwt212
        FROM rwt_file
       WHERE rwt01 =l_azw01
         AND rwt02 = p_year
      IF NOT  cl_null(p_month) THEN 
         CASE p_month
            WHEN 1  LET forecast_s2_shopsum=l_rwt201 
            WHEN 2  LET forecast_s2_shopsum=l_rwt202
            WHEN 3  LET forecast_s2_shopsum=l_rwt203 
            WHEN 4  LET forecast_s2_shopsum=l_rwt204 
            WHEN 5  LET forecast_s2_shopsum=l_rwt205
            WHEN 6  LET forecast_s2_shopsum=l_rwt206 
            WHEN 7  LET forecast_s2_shopsum=l_rwt207 
            WHEN 8  LET forecast_s2_shopsum=l_rwt208 
            WHEN 9  LET forecast_s2_shopsum=l_rwt209 
            WHEN 10 LET forecast_s2_shopsum=l_rwt210
            WHEN 11 LET forecast_s2_shopsum=l_rwt211 
            WHEN 12 LET forecast_s2_shopsum=l_rwt212
         END CASE
      ELSE
         SELECT rwt201+rwt202+rwt203+rwt204+rwt205+rwt206+rwt207+rwt208
                +rwt209+rwt210+rwt211+rwt212 
           INTO forecast_s2_shopsum
           FROM rwt_file
          WHERE rwt01 = l_azw01
            AND rwt02 = p_year
      END IF
      IF NOT cl_null(forecast_s2_shopsum) THEN
         CALL cl_chart_array_data(p_loc,"dataset",l_azw01,forecast_s2_shopsum)
         LET forecast_s3 = forecast_s3 + forecast_s2_shopsum
      END IF
      INITIALIZE l_rwt201,l_rwt202,l_rwt203,l_rwt204,l_rwt205,l_rwt206,
                 l_rwt207,l_rwt208,l_rwt209,l_rwt210,l_rwt211,l_rwt212
              TO NULL
   END FOREACH
   LET forecast_s4 = forecast_performance - forecast_s3
   LET l_str1 = cl_getmsg('azz-185',g_lang) 
   IF forecast_s4 > 0 THEN
      CALL cl_chart_array_data(p_loc,"dataset",l_str1,forecast_s4)
   END IF
   INITIALIZE l_str TO NULL
   LET l_str = cl_getmsg('agl-172',g_lang),":",p_year  #年度
   IF NOT cl_null(p_month) THEN                      #月份
      LET l_str = l_str CLIPPED," / ",cl_getmsg('azz-159',g_lang),":",p_month CLIPPED
   END IF
   IF NOT cl_null(l_str) THEN
      CALL cl_chart_attr(p_loc,"subcaption",l_str)    #設定子標題
   END IF
   CALL cl_chart_create(p_loc,"s_chart_forecast_s2")
   CALL cl_chart_clear(p_loc)
END FUNCTION


#FUN-BA0095
