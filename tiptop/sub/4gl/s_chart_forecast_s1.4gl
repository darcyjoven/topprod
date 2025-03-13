# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_chart_forecast_s1.4gl
# Descriptions...: 年度各月銷售目標金額
# Date & Author..: No.FUN-BA0095 2011/11/10 By linlin
# Input Parameter: p_year  年度
#                  p_loc   圖表位置
# Usage..........: CALL s_chart_forecast_s1(p_year,p_loc)
# Modify.........: 

DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION s_chart_forecast_s1(p_year,p_loc)
DEFINE p_year                    LIKE type_file.num5
DEFINE p_loc                     LIKE type_file.chr10
DEFINE l_str                     STRING               #子標題
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
DEFINE l_forecast                LIKE rwt_file.rwt212
DEFINE l_month                   LIKE type_file.num5
DEFINE l_chk_auth                STRING   

   WHENEVER ERROR CONTINUE

   CALL cl_chart_init(p_loc) 

   IF NOT s_chart_auth("s_chart_forecast_s1",g_user) THEN 
      LET l_chk_auth = cl_getmsg('azz1135',g_lang) CLIPPED
      CALL cl_chart_set_empty(p_loc, l_chk_auth)  
      RETURN 
   END IF                                            #判斷權限

   IF cl_null(p_year) THEN LET p_year = YEAR(TODAY) END IF

   SELECT rwt201,rwt202,rwt203,rwt204,rwt205,rwt206,rwt207,
          rwt208,rwt209,rwt210,rwt211,rwt212 
     INTO l_rwt201,l_rwt202,l_rwt203,l_rwt204,l_rwt205,l_rwt206,l_rwt207,l_rwt208,l_rwt209,l_rwt210,
          l_rwt211,l_rwt212
     FROM rwt_file
    WHERE rwt01 = g_plant
      AND rwt02 = p_year

   FOR l_month = 1 TO 12
      CASE l_month
         WHEN 1  LET l_forecast = l_rwt201
         WHEN 2  LET l_forecast = l_rwt202
         WHEN 3  LET l_forecast = l_rwt203
         WHEN 4  LET l_forecast = l_rwt204
         WHEN 5  LET l_forecast = l_rwt205
         WHEN 6  LET l_forecast = l_rwt206
         WHEN 7  LET l_forecast = l_rwt207
         WHEN 8  LET l_forecast = l_rwt208
         WHEN 9  LET l_forecast = l_rwt209
         WHEN 10 LET l_forecast = l_rwt210
         WHEN 11 LET l_forecast = l_rwt211
         WHEN 12 LET l_forecast = l_rwt212
      END CASE
      CALL cl_chart_array_data(p_loc,"categories","",l_month)
      CALL cl_chart_array_data(p_loc,"dataset"," ",l_forecast)
   END FOR

   LET l_str = cl_getmsg('agl-172',g_lang) CLIPPED,":",p_year CLIPPED
   CALL cl_chart_attr(p_loc,"subcaption",l_str)    #設定子標題
   CALL cl_chart_create(p_loc,"s_chart_forecast_s1")
   CALL cl_chart_clear(p_loc)
END FUNCTION

#FUN-BA0095
