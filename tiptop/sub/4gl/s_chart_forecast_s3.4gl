# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_chart_forecast_s3.4gl
# Descriptions...: 營運中心目標與實際比較(含坪效/人效)
# Date & Author..: No.FUN-BA0095 2011/11/10 By linlin
# Input Parameter: p_year   年度
#                  p_month  月份
#                  p_loc   圖表位置
# Usage..........: CALL s_chart_forecast_s3(p_year,p_month,p_loc)
# Modify.........: 

DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION s_chart_forecast_s3(p_year,p_month,p_loc)
DEFINE p_year                   LIKE type_file.num5
DEFINE p_loc                    LIKE type_file.chr10
DEFINE p_month                  LIKE type_file.num5
DEFINE l_sql                    STRING
DEFINE l_str                    STRING               #子標題
DEFINE l_str1                   STRING               
DEFINE l_str2                   STRING               
DEFINE l_str3                   STRING               
DEFINE l_str4                   STRING 
DEFINE l_str5                   STRING                
DEFINE l_month                  LIKE type_file.num5  #月份
DEFINE forecast_performance     LIKE rwt_file.rwt201 #銷售目標
DEFINE forecast_s3_performance  LIKE rwt_file.rwt201 #各月銷售目標
DEFINE forecast_s3_shop         LIKE rwt_file.rwt201 #各店实际銷售金額
DEFINE forecast_s3_shop1        LIKE type_file.num5  #銷售金額
DEFINE forecast_s3_shop2        LIKE type_file.num5  #消退金額
DEFINE forecast_s3_shop3        LIKE type_file.num5  #實際金額
DEFINE forecast_s3_shopsum      LIKE rwt_file.rwt201 #各店銷售金額
DEFINE forecast_s3              LIKE rwt_file.rwt201 #分配金額
DEFINE forecast_s4              LIKE rwt_file.rwt201 #未分配金額
DEFINE l_rwt201                 LIKE rwt_file.rwt201
DEFINE l_rwt202                 LIKE rwt_file.rwt202
DEFINE l_rwt203                 LIKE rwt_file.rwt203
DEFINE l_rwt204                 LIKE rwt_file.rwt204
DEFINE l_rwt205                 LIKE rwt_file.rwt205
DEFINE l_rwt206                 LIKE rwt_file.rwt206
DEFINE l_rwt207                 LIKE rwt_file.rwt207
DEFINE l_rwt208                 LIKE rwt_file.rwt208
DEFINE l_rwt209                 LIKE rwt_file.rwt209
DEFINE l_rwt210                 LIKE rwt_file.rwt210
DEFINE l_rwt211                 LIKE rwt_file.rwt211
DEFINE l_rwt212                 LIKE rwt_file.rwt212
DEFINE l_n                      LIKE type_file.num5 
DEFINE l_azw01                  LIKE azw_file.azw01 
DEFINE l_azw08                  LIKE azw_file.azw08
DEFINE l_cont                   LIKE type_file.num5 #人數
DEFINE l_s                      LIKE type_file.num5 #坪效
DEFINE l_s1                     LIKE type_file.num5 #人效
DEFINE l_rtz23                  LIKE type_file.num5 
DEFINE forecast_ogb14t          LIKE ogb_file.ogb14t 
DEFINE forecast_ohb14t          LIKE ohb_file.ohb14t 
DEFINE l_chk_auth               STRING

   WHENEVER ERROR CONTINUE
   CALL cl_chart_init(p_loc) 

   IF NOT s_chart_auth("s_chart_forecast_s3",g_user) THEN 
      LET l_chk_auth = cl_getmsg('azz1135',g_lang) CLIPPED
      CALL cl_chart_set_empty(p_loc, l_chk_auth)  
      RETURN 
   END IF                                            #判斷權限
   IF cl_null(p_year) THEN LET p_year = YEAR(TODAY) END IF
   LET forecast_s3_shop1 = 0
   LET forecast_s3_shop2 = 0
   LET forecast_s3_shop3 = 0
   #抓底層營運中心
   LET l_sql = "SELECT azw01 FROM azw_file WHERE azw01 IN ",g_auth CLIPPED
   PREPARE sel_azw_pre FROM l_sql
   DECLARE sel_azw_cs CURSOR FOR sel_azw_pre
   FOREACH sel_azw_cs INTO l_azw01
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET forecast_s3_shopsum = NULL
      INITIALIZE l_rwt201,l_rwt202,l_rwt203,l_rwt204,l_rwt205,l_rwt206,
                 l_rwt207,l_rwt208,l_rwt209,l_rwt210,l_rwt211,l_rwt212
              TO NULL
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
            WHEN '01' LET forecast_s3_shopsum=l_rwt201 
            WHEN '02' LET forecast_s3_shopsum=l_rwt202
            WHEN '03' LET forecast_s3_shopsum=l_rwt203 
            WHEN '04' LET forecast_s3_shopsum=l_rwt204 
            WHEN '05' LET forecast_s3_shopsum=l_rwt205
            WHEN '06' LET forecast_s3_shopsum=l_rwt206 
            WHEN '07' LET forecast_s3_shopsum=l_rwt207 
            WHEN '08' LET forecast_s3_shopsum=l_rwt208 
            WHEN '09' LET forecast_s3_shopsum=l_rwt209 
            WHEN '10' LET forecast_s3_shopsum=l_rwt210
            WHEN '11' LET forecast_s3_shopsum=l_rwt211 
            WHEN '12' LET forecast_s3_shopsum=l_rwt212
        END CASE
      ELSE
         LET forecast_s3_shopsum = l_rwt201+l_rwt202+l_rwt203+l_rwt204+l_rwt205+
                                   l_rwt206+l_rwt207+l_rwt208+l_rwt209+l_rwt210+l_rwt211+l_rwt212 
      END IF
      IF NOT cl_null(forecast_s3_shopsum) AND forecast_s3_shopsum > 0 THEN
        #抓取出貨單
         LET l_sql = "SELECT SUM(ogb14t) ",
                     "  FROM ",cl_get_target_table(l_azw01,'ogb_file'),
                     "      ,",cl_get_target_table(l_azw01,'oga_file'),
                     " WHERE ogb01 = oga01 ",
                     "   AND YEAR(oga02) = '",p_year ,"' ",
                     "   AND oga09 IN ('2','3','4','6') AND ogapost = 'Y' "
         IF NOT cl_null(p_month) THEN
            LET l_sql = l_sql CLIPPED," AND MONTH(oga02) = '",p_month,"' "
         END IF
         PREPARE sel_ogb_pre FROM l_sql
         EXECUTE sel_ogb_pre INTO forecast_s3_shop1
        #抓取銷退單
         LET l_sql = "SELECT SUM(ohb14t)*(-1) ",
                     "  FROM ",cl_get_target_table(l_azw01,'ohb_file'),
                     "      ,",cl_get_target_table(l_azw01,'oga_file'),
                     " WHERE ohb01 = oha01 ",
                     "   AND YEAR(oha02) = '",p_year,"' ",
                     "   AND oha05 IN ('1','2') ",
                     "   AND ohapost = 'Y' "
         IF NOT cl_null(p_month) THEN
            LET l_sql = l_sql CLIPPED," AND MONTH(oha02) = '",p_month,"' "
         END IF
         PREPARE sel_ohb_pre FROM l_sql
         EXECUTE sel_ohb_pre INTO forecast_s3_shop2
         IF cl_null(forecast_s3_shop1) THEN LET forecast_s3_shop1 = 0 END IF
         IF cl_null(forecast_s3_shop2) THEN LET forecast_s3_shop2 = 0 END IF
        #計算出銷售業績
         LET forecast_s3_shop = forecast_s3_shop1 + forecast_s3_shop2

        #計算坪效
         SELECT rtz23 INTO l_rtz23 FROM rtz_file WHERE rtz01 = l_azw01
         LET l_s =  forecast_s3_shopsum / l_rtz23  
        #計算人效
         SELECT COUNT(*) INTO l_cont 
           FROM gen_file 
          WHERE gen07 = l_azw01 AND genacti = 'Y'
         LET l_s1 = forecast_s3_shopsum / l_cont  

        #組出 營運中心編號(營運中心名稱)的樣式
         SELECT azw08 INTO l_azw08 FROM azw_file WHERE azw01 = l_azw01
         LET l_str5 = l_azw01 CLIPPED,"(",l_azw08 CLIPPED,")" #營運中心編號(營運中心名稱)
         LET l_str1 = cl_getmsg('azz-186',g_lang)             #目標金額
         LET l_str2 = cl_getmsg('azz-187',g_lang)             #實際金額
         LET l_str3 = cl_getmsg('azz-188',g_lang)             #坪效
         LET l_str4 = cl_getmsg('azz-189',g_lang)             #人效

        #
         CALL cl_chart_array_data( p_loc ,"categories","",l_str5)
         CALL cl_chart_array_data(p_loc,"dataset",l_str1,forecast_s3_shopsum)
         CALL cl_chart_array_data(p_loc,"dataset",l_str2,forecast_s3_shop)
         CALL cl_chart_array_data(p_loc,"dataset",l_str3,l_s)
         CALL cl_chart_array_data(p_loc,"dataset",l_str4,l_s1)
      END IF 
   END FOREACH
   
   INITIALIZE l_str TO NULL
   LET l_str = cl_getmsg('agl-172',g_lang),":",p_year  #年度
   IF NOT cl_null( p_month ) THEN
      LET l_str = l_str CLIPPED," / ",cl_getmsg('azz-159',g_lang),":",p_month CLIPPED
   END IF
   IF NOT cl_null(l_str) THEN
      CALL cl_chart_attr(p_loc,"subcaption",l_str)    #設定子標題
   END IF
   CALL cl_chart_create(p_loc,"s_chart_forecast_s3")
   CALL cl_chart_clear(p_loc)
END FUNCTION

#FUN-BA0095
