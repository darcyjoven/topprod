# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_chart_forecast_s5.4gl
# Descriptions...: 人員目標與實際比較
# Date & Author..: No.FUN-BA0095 2011/11/11 By linlin
# Input Parameter: p_year   年度
#                  p_month  月份
#                  p_plant 營運中心
#                  p_loc   圖表位置
# Usage..........: CALL s_chart_forecast_s5(p_year,p_month,p_loc)
# Modify.........: 

DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION s_chart_forecast_s5(p_year,p_month,p_plant,p_loc)
DEFINE p_year                    LIKE type_file.num5
DEFINE p_loc                     LIKE type_file.chr10
DEFINE p_month                   LIKE type_file.num5
DEFINE p_plant                   LIKE azw_file.azw01
DEFINE l_sql                     STRING
DEFINE l_str1                    STRING               
DEFINE l_str2                    STRING               
DEFINE l_str3                    STRING               
DEFINE l_str                     STRING               #子標題
DEFINE l_month                   LIKE type_file.num5  #月份
DEFINE forecast_s5_shop          LIKE rwt_file.rwt201 #各店实际銷售金額
DEFINE forecast_performance      LIKE rwt_file.rwt201 #目標金額
DEFINE forecast_s5_shop1         LIKE rwt_file.rwt201 #銷售金額
DEFINE forecast_s5_shop2         LIKE rwt_file.rwt201 #消退金額
DEFINE forecast_s5_shopsum       LIKE rwt_file.rwt201 #各店銷售金額
DEFINE forecast_s3               LIKE rwt_file.rwt201 #分配金額
DEFINE forecast_s5               LIKE rwt_file.rwt201 #未分配金額
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
DEFINE l_rwu201                  LIKE rwu_file.rwu201
DEFINE l_rwu202                  LIKE rwu_file.rwu202
DEFINE l_rwu203                  LIKE rwu_file.rwu203
DEFINE l_rwu204                  LIKE rwu_file.rwu204
DEFINE l_rwu205                  LIKE rwu_file.rwu205
DEFINE l_rwu206                  LIKE rwu_file.rwu206
DEFINE l_rwu207                  LIKE rwu_file.rwu207
DEFINE l_rwu208                  LIKE rwu_file.rwu208
DEFINE l_rwu209                  LIKE rwu_file.rwu209
DEFINE l_rwu210                  LIKE rwu_file.rwu210
DEFINE l_rwu211                  LIKE rwu_file.rwu211
DEFINE l_rwu212                  LIKE rwu_file.rwu212
DEFINE l_azw01                   LIKE rtz_file.rtz01 #營運中心
DEFINE l_rwt01                   LIKE rtz_file.rtz01 
DEFINE l_rwu03                   LIKE rwu_file.rwu03 #員工編號
DEFINE l_flag                    LIKE type_file.num5
DEFINE l_i                       LIKE type_file.num5
DEFINE l_gen02                   LIKE gen_file.gen02 #姓名
DEFINE l_chk_auth                STRING

   WHENEVER ERROR CONTINUE
   CALL cl_chart_init(p_loc) 
   
   IF NOT s_chart_auth("s_chart_forecast_s5",g_user) THEN 
      LET l_chk_auth = cl_getmsg('azz1135',g_lang) CLIPPED
      CALL cl_chart_set_empty(p_loc, l_chk_auth)  
      RETURN 
   END IF                                            #判斷權限
   IF cl_null(p_year) THEN LET p_year = YEAR(TODAY) END IF
   IF cl_null(p_plant) THEN LET p_plant = g_plant END IF
 
   #定義臨時表  
   DROP TABLE forecast_s5_temp1
   CREATE TEMP TABLE forecast_s5_temp1(
   flag  LIKE type_file.num5,
   rwt01 LIKE rwt_file.rwt01)
   DROP TABLE forecast_s5_temp2
   CREATE TEMP TABLE forecast_s5_temp2(
   rwt01 LIKE rwt_file.rwt01)
   
   #抓取營運中心： 以及入的營運中心往下展到最底層，抓取最底層的營運中心
   LET l_sql = "SELECT '1',rwt01 ",
               "  FROM rwt_file ",
               " WHERE rwt04 = '",p_plant,"' AND rwt02 = '",p_year,"' "
   PREPARE sel_rwt01_pre1 FROM l_sql
   DECLARE sel_rwt01_cs1 CURSOR FOR sel_rwt01_pre1
   FOREACH sel_rwt01_cs1 INTO l_flag,l_rwt01
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      INSERT INTO forecast_s5_temp1 VALUES(l_flag,l_rwt01)
   END FOREACH
   INSERT INTO forecast_s5_temp2 VALUES(p_plant)
   LET l_i = 1
   WHILE TRUE
      LET l_n = 0
      SELECT COUNT(*) INTO l_n FROM forecast_s5_temp1 WHERE flag = l_i
      IF l_n = 0 THEN
         EXIT WHILE
      ELSE
         INITIALIZE l_rwt01 TO NULL
         LET l_sql = "SELECT rwt01 FROM forecast_s5_temp1 WHERE flag = '",l_i,"' "
         PREPARE sel_rwt01_pre2 FROM l_sql
         DECLARE sel_rwt01_cs2 CURSOR FOR sel_rwt01_pre2
         FOREACH sel_rwt01_cs2 INTO l_rwt01 
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            SELECT COUNT(*) INTO l_n FROM rwt_file
             WHERE rwt04 = l_rwt01
               AND rwt02 = p_year
            IF l_n = 0 THEN
               INSERT INTO forecast_s5_temp2 VALUES(l_rwt01)   #底層
            ELSE
               LET l_sql = "SELECT ",l_i +1,",rwt01 FROM rwt_file ",
                           " WHERE rwt04 = '",l_rwt01,"' ",
                           "   AND rwt02 = '",p_year,"' "
               PREPARE ins_tmp_pre FROM l_sql
               DECLARE ins_tmp_cs CURSOR FOR ins_tmp_pre
               FOREACH ins_tmp_cs INTO l_flag,l_rwt01
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('foreach:',SQLCA.sqlcode,1)
                     EXIT FOREACH
                  END IF
                  INSERT INTO forecast_s5_temp1 VALUES(l_flag,l_rwt01)
               END FOREACH
            END IF
         END FOREACH
         LET l_i = l_i + 1
      END IF
   END WHILE
   
     #抓取總金額
   SELECT rwu201,rwu202,rwu203,rwu204,rwu205,rwu206,rwu207,
          rwu208,rwu209,rwu210,rwu211,rwu212 
     INTO l_rwu201,l_rwu202,l_rwu203,l_rwu204,l_rwu205,l_rwu206,
          l_rwu207,l_rwu208,l_rwu209,l_rwu210,l_rwu211,l_rwu212
     FROM rwu_file
    WHERE rwu01 = p_plant
      AND rwu02 = p_year
   IF NOT cl_null(p_month) THEN 
      CASE p_month
         WHEN 1  LET forecast_performance=l_rwu201 
         WHEN 2  LET forecast_performance=l_rwu202
         WHEN 3  LET forecast_performance=l_rwu203 
         WHEN 4  LET forecast_performance=l_rwu204 
         WHEN 5  LET forecast_performance=l_rwu205
         WHEN 6  LET forecast_performance=l_rwu206 
         WHEN 7  LET forecast_performance=l_rwu207 
         WHEN 8  LET forecast_performance=l_rwu208 
         WHEN 9  LET forecast_performance=l_rwu209 
         WHEN 10 LET forecast_performance=l_rwu210
         WHEN 11 LET forecast_performance=l_rwu211 
         WHEN 12 LET forecast_performance=l_rwu212
      END CASE
   ELSE
      LET forecast_performance = l_rwu201+l_rwu202+l_rwu203+l_rwu204+l_rwu205+
                                 l_rwu206+l_rwu207+l_rwu208+l_rwu209+l_rwu210+l_rwu211+l_rwu212 
   END IF
   LET forecast_s3 = 0
   LET forecast_s5 = 0 
   #抓取已分配金額
   INITIALIZE l_rwt01 TO NULL
   LET l_sql = "SELECT rwt01 FROM forecast_s5_temp2 "
   PREPARE sel_rwt01_pre3 FROM l_sql
   DECLARE sel_rwt01_cs3 CURSOR FOR sel_rwt01_pre3
   FOREACH sel_rwt01_cs3 INTO l_rwt01
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET forecast_s5_shopsum = NULL
      LET l_n = 0 
      SELECT COUNT(*) INTO l_n FROM azw_file WHERE azw07 = l_rwt01
      IF l_n > 0 THEN CONTINUE FOREACH END IF 
      LET l_sql = "SELECT rwu03 FROM rwu_file",
                  " WHERE rwu01 = '",l_rwt01,"' AND rwu02 = '",p_year,"' "
      PREPARE sel_rwu_pre FROM l_sql
      DECLARE sel_rwu_cs CURSOR FOR sel_rwu_pre
      FOREACH sel_rwu_cs INTO l_rwu03
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH 
         END IF
         INITIALIZE l_rwu201,l_rwu202,l_rwu203,l_rwu204,l_rwu205,l_rwu206,
                    l_rwu207,l_rwu208,l_rwu209,l_rwu210,l_rwu211,l_rwu212
                 TO NULL
         SELECT rwu201,rwu202,rwu203,rwu204,rwu205,rwu206,
                rwu207,rwu208,rwu209,rwu210,rwu211,rwu212
           INTO l_rwu201,l_rwu202,l_rwu203,l_rwu204,l_rwu205,l_rwu206,
                l_rwu207,l_rwu208,l_rwu209,l_rwu210,l_rwu211,l_rwu212
           FROM rwu_file 
          WHERE rwu01 = l_rwt01 AND rwu02 = p_year AND rwu03 = l_rwu03
         IF NOT cl_null(p_month) THEN 
            CASE p_month
               WHEN 1  LET forecast_s5_shopsum=l_rwu201 
               WHEN 2  LET forecast_s5_shopsum=l_rwu202
               WHEN 3  LET forecast_s5_shopsum=l_rwu203 
               WHEN 4  LET forecast_s5_shopsum=l_rwu204 
               WHEN 5  LET forecast_s5_shopsum=l_rwu205
               WHEN 6  LET forecast_s5_shopsum=l_rwu206 
               WHEN 7  LET forecast_s5_shopsum=l_rwu207 
               WHEN 8  LET forecast_s5_shopsum=l_rwu208 
               WHEN 9  LET forecast_s5_shopsum=l_rwu209 
               WHEN 10 LET forecast_s5_shopsum=l_rwu210
               WHEN 11 LET forecast_s5_shopsum=l_rwu211 
               WHEN 12 LET forecast_s5_shopsum=l_rwu212
            END CASE
         ELSE
            LET forecast_s5_shopsum = l_rwu201+l_rwu202+l_rwu203+l_rwu204+l_rwu205+
                                      l_rwu206+l_rwu207+l_rwu208+l_rwu209+l_rwu210+l_rwu211+l_rwu212 
         END IF
         IF NOT cl_null(forecast_s5_shopsum) AND forecast_s5_shopsum > 0 THEN
            #抓取出貨單
            LET l_sql = "SELECT SUM(ogb14t) ",
                        "  FROM ",cl_get_target_table(l_rwt01,'ogb_file'),
                        "      ,",cl_get_target_table(l_rwt01,'oga_file'),
                        " WHERE ogb01 = oga01 ",
                        "   AND YEAR(oga02) = '",p_year ,"' ",
                        "   AND oga09 IN ('2','3','4','6')", 
                        "   AND oga14 = '",l_rwu03,"' ",
                        "   AND ogapost = 'Y' "
            IF NOT cl_null(p_month) THEN LET l_sql = l_sql CLIPPED," AND MONTH(oga02) = '",p_month,"' " END IF
            PREPARE sel_ogb_pre FROM l_sql
            EXECUTE sel_ogb_pre INTO forecast_s5_shop1
            #抓取銷退單
            LET l_sql = "SELECT SUM(ohb14t)*(-1) ",
                        "  FROM ",cl_get_target_table(l_rwt01,'ohb_file'),
                        "      ,",cl_get_target_table(l_rwt01,'oha_file'),
                        " WHERE ohb01 = oha01 ",
                        "   AND YEAR(oha02) = '",p_year,"' ",
                        "   AND oha05 IN ('1','2') ",
                        "   AND ohapost = 'Y' ",
                        "   AND oha14 = '",l_rwu03,"' "
            IF NOT cl_null(p_month) THEN LET l_sql = l_sql CLIPPED," AND MONTH(oha02) = '",p_month,"' " END IF
            PREPARE sel_ohb_pre FROM l_sql
            EXECUTE sel_ohb_pre INTO forecast_s5_shop2
            IF cl_null(forecast_s5_shop1) THEN LET forecast_s5_shop1 = 0 END IF
            IF cl_null(forecast_s5_shop2) THEN LET forecast_s5_shop2 = 0 END IF
            #計算出個人實際銷售業績
            LET forecast_s5_shop = forecast_s5_shop1 + forecast_s5_shop2
 
            #抓取員工姓名，目標金額，實際金額
            SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = l_rwu03
            LET l_str1 = l_rwu03 CLIPPED,"(",l_gen02 CLIPPED,")" #員工姓名，編號
            LET l_str2 = cl_getmsg('azz-186',g_lang)             #目標金額
            LET l_str3 = cl_getmsg('azz-187',g_lang)             #實際金額
            
            CALL cl_chart_array_data( p_loc ,"categories","", l_str1)
            CALL cl_chart_array_data( p_loc ,"dataset",l_str2, forecast_s5_shopsum)
            CALL cl_chart_array_data( p_loc ,"dataset",l_str3, forecast_s5_shop)
         END IF 
      END FOREACH
   END FOREACH
   INITIALIZE l_str TO NULL
   LET l_str = cl_getmsg('agl-172',g_lang),":",p_year  #年度
   IF NOT cl_null( p_month ) THEN                      #月份
   LET l_str = l_str CLIPPED," / ",cl_getmsg('azz-159',g_lang),":",p_month CLIPPED
   END IF
   IF NOT cl_null( p_plant ) THEN                      #營運中心
   LET l_str = l_str CLIPPED," / ",cl_getmsg('azz1100',g_lang),":",p_plant CLIPPED
   END IF
   IF NOT cl_null(l_str) THEN
      CALL cl_chart_attr(p_loc,"subcaption",l_str)    #設定子標題
   END IF
   CALL cl_chart_create(p_loc,"s_chart_forecast_s5")
   CALL cl_chart_clear(p_loc)
END FUNCTION


#FUN-BA0095
