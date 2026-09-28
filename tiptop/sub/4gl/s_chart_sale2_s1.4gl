# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: s_chart_sale2_s1.4gl
# Descriptions...: 查詢某一年度內各月業績
# Date & Author..: No.FUN-BA0095 2011/11/09 By qiaozy
# Input Parameter: p_year  年度
#                  p_loc   圖表位置
# Usage..........: CALL s_chart_sale2_s1(p_year,p_loc)
# Modify.........: 

DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION s_chart_sale2_s1(p_year,p_loc)
DEFINE p_year           LIKE type_file.num5
DEFINE p_loc            LIKE type_file.chr10
DEFINE l_sql            STRING
DEFINE l_sql1           STRING
DEFINE l_sql2           STRING
DEFINE l_sale_tyear     LIKE ogb_file.ogb14t #今年銷售金額匯總
DEFINE l_sale_lyear     LIKE ogb_file.ogb14t #去年銷售金額匯總
DEFINE l_return_tyear   LIKE ohb_file.ohb14t #今年銷退金額匯總
DEFINE l_return_lyear   LIKE ohb_file.ohb14t #去年銷退金額匯總
DEFINE l_sale_tyear1    LIKE ogb_file.ogb14t #單個營運中心今年銷售金額匯總
DEFINE l_sale_lyear1    LIKE ogb_file.ogb14t #單個營運中心去年銷售金額匯總
DEFINE l_return_tyear1  LIKE ohb_file.ohb14t #單個營運中心今年銷退金額匯總
DEFINE l_return_lyear1  LIKE ohb_file.ohb14t #單個營運中心去年銷退金額匯總
DEFINE l_sale_per_tyear LIKE ogb_file.ogb14t #今年銷售業績
DEFINE l_sale_per_lyear LIKE ogb_file.ogb14t #去年銷售業績
DEFINE l_str            STRING               #子標題
DEFINE l_month          LIKE type_file.num5  #月份
DEFINE l_rtz01          LIKE azw_file.azw01
DEFINE l_sql3           STRING
DEFINE l_chk_auth       STRING

   CALL cl_chart_init(p_loc) #
   IF NOT s_chart_auth("s_chart_sale2_s1",g_user) THEN
      LET l_chk_auth=cl_getmsg('azz1135',g_lang) CLIPPED
      CALL cl_chart_set_empty(p_loc,l_chk_auth)
      RETURN
   END IF

   LET l_sql3="SELECT azw01 FROM azw_file WHERE azw01 IN",g_auth
   PREPARE s_chart_sale2_s FROM l_sql3
   DECLARE s_chart_sale2_s1 CURSOR FOR s_chart_sale2_s
   FOR l_month = 1 TO 12
      LET l_sale_tyear=0
      LET l_sale_lyear=0
      LET l_return_tyear=0
      LET l_return_lyear=0
      LET l_sale_per_tyear=0
      LET l_sale_per_lyear=0    
      FOREACH s_chart_sale2_s1 INTO l_rtz01

      #抓取銷售金額
         LET l_sql = "SELECT SUM(ogb14t*oga24) FROM ",cl_get_target_table(l_rtz01,'oga_file'),
                     ",",cl_get_target_table(l_rtz01,'ogb_file'),
                     " WHERE oga01 = ogb01 ",
                     "   AND oga09 IN ('2','3','4','6') ",
                     "   AND ogapost = 'Y' ",
                     "   AND MONTH(oga02) = '",l_month,"' "
         LET l_sql1 = l_sql CLIPPED," AND YEAR(oga02) = '",p_year,"' "
         LET l_sql2 = l_sql CLIPPED," AND YEAR(oga02) = '",p_year-1,"' "
         CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        
         CALL cl_parse_qry_sql(l_sql1,l_rtz01) RETURNING l_sql1
         CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        
         CALL cl_parse_qry_sql(l_sql2,l_rtz01) RETURNING l_sql2

         PREPARE sel_sale_tyear FROM l_sql1
         EXECUTE sel_sale_tyear INTO l_sale_tyear1
         PREPARE sel_sale_lyear FROM l_sql2
         EXECUTE sel_sale_lyear INTO l_sale_lyear1
         IF cl_null(l_sale_tyear1) THEN LET l_sale_tyear1 = 0 END IF
         IF cl_null(l_sale_lyear1) THEN LET l_sale_lyear1 = 0 END IF

      #抓取銷退金額
         LET l_sql = "SELECT SUM(ohb14t*oha24) FROM ",cl_get_target_table(l_rtz01,'oha_file'),
                     ",",cl_get_target_table(l_rtz01,'ohb_file'),
                     " WHERE oha01 = ohb01 ",
                     "   AND oha05 IN ('1','2') ",
                     "   AND ohapost = 'Y' ",
                     "   AND MONTH(oha02) = '",l_month,"' "
         LET l_sql1 = l_sql CLIPPED," AND YEAR(oha02) = '",p_year,"' "
         LET l_sql2 = l_sql CLIPPED,"  AND YEAR(oha02) = '",p_year-1,"' "
         CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        
         CALL cl_parse_qry_sql(l_sql1,l_rtz01) RETURNING l_sql1
         CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        
         CALL cl_parse_qry_sql(l_sql2,l_rtz01) RETURNING l_sql2

         PREPARE sel_return_tyear FROM l_sql1
         EXECUTE sel_return_tyear INTO l_return_tyear1
         PREPARE sel_return_lyear FROM l_sql2
         EXECUTE sel_return_lyear INTO l_return_lyear1
         IF cl_null(l_return_tyear1) THEN LET l_return_tyear1 = 0 END IF
         IF cl_null(l_return_lyear1) THEN LET l_return_lyear1 = 0 END IF
         
         LET l_sale_tyear = l_sale_tyear + l_sale_tyear1
         LET l_sale_lyear = l_sale_lyear + l_sale_lyear1
         LET l_return_tyear=l_return_tyear + l_return_tyear1
         LET l_return_lyear=l_return_lyear + l_return_lyear1
      END FOREACH 
      LET l_sale_per_tyear = l_sale_tyear - l_return_tyear
      LET l_sale_per_lyear = l_sale_lyear - l_return_lyear

      CALL cl_chart_array_data(p_loc,"categories","",l_month)
      CALL cl_chart_array_data(p_loc,"dataset",p_year,l_sale_per_tyear)
      CALL cl_chart_array_data(p_loc,"dataset",p_year-1,l_sale_per_lyear)
   END FOR

   LET l_str = cl_getmsg('agl-172',g_lang) CLIPPED,":",p_year
   CALL cl_chart_attr(p_loc,"subcaption",l_str)    #設定子標題
   CALL cl_chart_create(p_loc,"s_chart_sale2_s1")
   CALL cl_chart_clear(p_loc)

END FUNCTION

#FUN-BA0095
