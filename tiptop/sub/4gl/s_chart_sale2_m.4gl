# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: s_chart_sale2_m.4gl
# Descriptions...: 多營運中心各年度銷售業績
# Date & Author..: No.FUN-BA0095 2011/11/09 By qiaozy
# Input Parameter: p_loc  圖表位置
# Usage..........: CALL s_chart_sale2_m(p_loc)
# Modify.........: 

DATABASE ds

GLOBALS "../../config/top.global"
GLOBALS "../4gl/s_chart.global"

FUNCTION s_chart_sale2_m(p_loc)
DEFINE p_loc             LIKE type_file.chr10
DEFINE nyear             LIKE type_file.num5
DEFINE sale_sum          LIKE ogb_file.ogb14t #銷售金額匯總
DEFINE return_sum        LIKE ohb_file.ohb14t #銷退金額匯總
DEFINE sale_sum1         LIKE ogb_file.ogb14t #銷售金額匯總
DEFINE return_sum1       LIKE ohb_file.ohb14t #銷退金額匯總
DEFINE sale_performance  LIKE ogb_file.ogb14t #銷售業績
DEFINE sale_performance1 LIKE ogb_file.ogb14t #年度業績
DEFINE l_sql             STRING
DEFINE l_rtz01           LIKE rtz_file.rtz01
DEFINE l_sql1            STRING
DEFINE l_sql2            STRING
DEFINE l_chk_auth        STRING   

   CALL cl_chart_init(p_loc) # #初始WebComponent的資料
   
   IF NOT s_chart_auth("s_chart_sale2_m",g_user) THEN
      LET l_chk_auth=cl_getmsg('azz1135',g_lang) CLIPPED
      CALL cl_chart_set_empty(p_loc, l_chk_auth)
      RETURN
   END IF 

   FOR nyear=YEAR(TODAY)-4 TO YEAR(TODAY)
      LET sale_performance=0
      LET sale_sum=0
      LET return_sum=0
      LET l_sql="SELECT azw01 FROM azw_file WHERE azw01 IN ",g_auth CLIPPED
      PREPARE s_chart_sale2_m FROM l_sql
      DECLARE s_chart_sale2_m1 CURSOR FOR s_chart_sale2_m
      FOREACH s_chart_sale2_m1  INTO l_rtz01
         #抓取銷售金額
         LET sale_sum1=0
         LET l_sql1="SELECT SUM(ogb14t*oga24) FROM ",cl_get_target_table(l_rtz01,'oga_file'),
                    ",",cl_get_target_table(l_rtz01,'ogb_file'),
                    " WHERE oga01 = ogb01",
                    "   AND oga09 IN ('2','3','4','6')",
                    "   AND ogapost = 'Y' AND YEAR(oga02) = '",nyear,"'"
         CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        
         CALL cl_parse_qry_sql(l_sql1,l_rtz01) RETURNING l_sql1
         PREPARE s_chart_sela2_m11 FROM l_sql1
         EXECUTE s_chart_sela2_m11 INTO sale_sum1 
         IF cl_null(sale_sum1) THEN LET sale_sum1 = 0 END IF

         #抓取銷退金額
         LET return_sum1=0
         LET l_sql2="SELECT SUM(ohb14t*oha24) FROM ",cl_get_target_table(l_rtz01,'oha_file'),
                    ",",cl_get_target_table(l_rtz01,'ohb_file'),
                    " WHERE oha01 = ohb01",
                    "   AND oha05 IN ('1','2')",
                    "   AND ohapost = 'Y' AND YEAR(oha02) = '",nyear,"'"
         CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        
         CALL cl_parse_qry_sql(l_sql2,l_rtz01) RETURNING l_sql2
         PREPARE s_chart_sela2_m12 FROM l_sql2
         EXECUTE s_chart_sela2_m12 INTO return_sum1
         IF cl_null(return_sum1) THEN LET return_sum1 = 0 END IF
         
         LET sale_sum=sale_sum+sale_sum1
         LET return_sum=return_sum+return_sum1
      END FOREACH
      LET sale_performance=sale_sum - return_sum
      CALL cl_chart_array_data(p_loc,"categories","",nyear)
      CALL cl_chart_array_data(p_loc,"dataset"," ",sale_performance)
   END FOR
   CALL cl_chart_create(p_loc,"s_chart_sale2_m")
   CALL cl_chart_clear(p_loc) #清除p_loc相關變數資料(釋放記憶體)
   
   #以最後一個年度連動其他5個圖表
   CALL s_chart_sale2_s1(nyear-1,"wc_2")
   CALL s_chart_sale2_s2(nyear-1,'','','',"wc_3")
   CALL s_chart_sale2_s3(nyear-1,'','',"wc_4")
   CALL s_chart_sale2_s4(nyear-1,'','','',"wc_5")
   CALL s_chart_sale2_s5(nyear-1,'','','',"wc_6")

   LET g_lnkchart2.argv1 = nyear-1
    
END FUNCTION 

#FUN-BA0095
