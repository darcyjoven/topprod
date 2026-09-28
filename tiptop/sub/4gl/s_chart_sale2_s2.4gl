# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: s_chart_sale2_s2.4gl
# Descriptions...: 查詢某一年度(月份)內各產品分類業績
# Date & Author..: No.FUN-BA0095 2011/11/10 By qiaozy
# Input Parameter: p_year     年度
#                  p_month    月份
#                  p_area     銷售城區
#                  p_plant    營運中心
#                  p_loc      圖表位置
# Usage..........: CALL s_chart_sale2_s2(p_year,p_month,p_area,p_plant,p_loc)
# Modify.........: 

DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION s_chart_sale2_s2(p_year,p_month,p_area,p_plant,p_loc)
DEFINE p_year       LIKE type_file.num5
DEFINE p_month      LIKE type_file.num5
DEFINE p_area       LIKE rtz_file.rtz10
DEFINE p_plant      LIKE rtz_file.rtz01
DEFINE p_loc        LIKE type_file.chr10
DEFINE l_sql        STRING
DEFINE l_sql1       STRING
DEFINE l_sql3       STRING
DEFINE l_substr     STRING
DEFINE l_sale       RECORD
             ima131 LIKE ima_file.ima131,
             sale   LIKE ogb_file.ogb14t
                    END RECORD
DEFINE l_sale1       RECORD
             ima131 LIKE ima_file.ima131,
             sale   LIKE ogb_file.ogb14t
                    END RECORD
DEFINE l_ryf02      LIKE ryf_file.ryf02  #城區名稱
DEFINE l_ryf03      LIKE ryf_file.ryf03
DEFINE l_azw08      LIKE azw_file.azw08  #營運中心名稱
DEFINE l_oba02      LIKE oba_file.oba02  #產品分類名稱
DEFINE l_oba_str    STRING               #存放產品分類信息
DEFINE l_oba021     LIKE oba_file.oba02  #去年產品分類名稱
DEFINE l_sql2       STRING
DEFINE l_rtz01      LIKE rtz_file.rtz01  #營運中心
DEFINE l_ima131     LIKE ima_file.ima131
DEFINE l_chk_auth   STRING

   WHENEVER ERROR CONTINUE
   CALL cl_chart_init(p_loc) #
   
   IF NOT s_chart_auth("s_chart_sale2_s2",g_user) THEN
      LET l_chk_auth=cl_getmsg('azz1135',g_lang) CLIPPED
      CALL cl_chart_set_empty(p_loc,l_chk_auth)
      RETURN
   END IF

   DROP TABLE sale_per_s2_temp
   CREATE TEMP TABLE sale_per_s2_temp(
   ima131 LIKE ima_file.ima131,
   sale   LIKE ogb_file.ogb14t)
   DROP TABLE sale_per_s2_temp1
   CREATE TEMP TABLE sale_per_s2_temp1(
   ima131 LIKE ima_file.ima131,
   sale   LIKE ogb_file.ogb14t)
   DROP TABLE sale_per_s2_temp2
   CREATE TEMP TABLE sale_per_s2_temp2(
   ima131 LIKE ima_file.ima131
   )
   
   IF cl_null(p_year) THEN LET p_year=YEAR(TODAY) END IF
   LET l_sql3 = "SELECT azw01 FROM azw_file,rtz_file WHERE azw01=rtz01 AND azw01 IN ",g_auth CLIPPED
   IF NOT cl_null(p_area) THEN LET l_sql3=l_sql3 CLIPPED," AND rtz10= '",p_area,"' " END IF
   IF NOT cl_null(p_plant) THEN LET l_sql3=l_sql3 CLIPPED," AND azw01= '",p_plant,"' " END IF
   PREPARE s_chart_sale2_s FROM l_sql3
   DECLARE s_chart_sale2_s2 CURSOR FOR s_chart_sale2_s   #查找營運中心
    
   FOREACH s_chart_sale2_s2 INTO l_rtz01   

   #抓取銷售金額
      INITIALIZE l_sale.ima131 TO NULL
      INITIALIZE l_sale1.ima131 TO NULL
      LET l_sale.sale=0
      LET l_sale1.sale=0
      LET l_sql = "SELECT c.ima131,SUM(a.ogb14t*oga24) FROM ",cl_get_target_table(l_rtz01,'ogb_file')," a ",
                  " JOIN ",cl_get_target_table(l_rtz01,'oga_file')," b  ON a.ogb01 = b.oga01 ",
                  "                                 AND b.oga09 IN ('2','3','4','6') ",
                  "                                 AND b.ogapost = 'Y' ",
                  "       LEFT OUTER JOIN ",cl_get_target_table(l_rtz01,'ima_file'),"  c ON c.ima01 = a.ogb04 "
      LET l_sql1=l_sql CLIPPED," WHERE YEAR(b.oga02) = '",p_year,"' "
      LET l_sql2=l_sql CLIPPED," WHERE YEAR(b.oga02) = '",p_year-1,"' "
      IF NOT cl_null(p_month) THEN 
         LET l_sql1 = l_sql1 CLIPPED," AND MONTH(b.oga02) = '",p_month,"' "
         LET l_sql2 = l_sql2 CLIPPED," AND MONTH(b.oga02) = '",p_month,"' "
      END IF
   
      LET l_sql1 = l_sql1 CLIPPED," GROUP BY ima131"
      LET l_sql2 = l_sql2 CLIPPED," GROUP BY ima131"
      CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        
      CALL cl_parse_qry_sql(l_sql1,l_rtz01) RETURNING l_sql1
      CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        
      CALL cl_parse_qry_sql(l_sql2,l_rtz01) RETURNING l_sql2
      PREPARE sel_sale_pre FROM l_sql1
      DECLARE sel_sale_cs CURSOR FOR sel_sale_pre
      PREPARE sel_sale_pre1 FROM l_sql2
      DECLARE sel_sale_cs1 CURSOR FOR sel_sale_pre1
      FOREACH sel_sale_cs INTO l_sale.*
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         IF cl_null(l_sale.sale) THEN LET l_sale.sale = 0 END IF
         INSERT INTO sale_per_s2_temp values(l_sale.ima131,l_sale.sale)
         INITIALIZE l_sale.ima131 TO NULL
         LET l_sale.sale=0
      END FOREACH
   
      FOREACH sel_sale_cs1 INTO l_sale1.*
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         IF cl_null(l_sale1.sale) THEN LET l_sale1.sale = 0 END IF
         INSERT INTO sale_per_s2_temp1 values(l_sale1.ima131,l_sale1.sale)
         INITIALIZE l_sale1.ima131 TO NULL
         LET l_sale1.sale=0
      END FOREACH
   

   #抓取销退金额
      INITIALIZE l_sale.ima131 TO NULL
      INITIALIZE l_sale1.ima131 TO NULL
      LET l_sale.sale=0
      LET l_sale1.sale=0
      LET l_sql = "SELECT c.ima131,SUM(a.ohb14t*oha24)*(-1) FROM ",cl_get_target_table(l_rtz01,'ohb_file')," a ",
                  " JOIN ",cl_get_target_table(l_rtz01,'oha_file')," b ON a.ohb01 = b.oha01 ",
                  "                                 AND b.oha05 IN ('1','2') ",
                  "                                 AND b.ohapost = 'Y' ",
                  "       LEFT OUTER JOIN ",cl_get_target_table(l_rtz01,'ima_file'),"  c ON c.ima01 = a.ohb04 "
      LET l_sql1 = l_sql CLIPPED," WHERE YEAR(b.oha02) = '",p_year,"' "
      LET l_sql2 = l_sql CLIPPED," WHERE YEAR(b.oha02) = '",p_year-1,"' "
      IF NOT cl_null(p_month) THEN 
         LET l_sql1 = l_sql1 CLIPPED," AND MONTH(b.oha02) = '",p_month,"' "
         LET l_sql2 = l_sql2 CLIPPED," AND MONTH(b.oha02) = '",p_month,"' "
      END IF
   
      LET l_sql1 = l_sql1 CLIPPED," GROUP BY ima131"
      LET l_sql2 = l_sql2 CLIPPED," GROUP BY ima131"
      CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        
      CALL cl_parse_qry_sql(l_sql1,l_rtz01) RETURNING l_sql1
      CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        
      CALL cl_parse_qry_sql(l_sql2,l_rtz01) RETURNING l_sql2
      PREPARE sel_return_pre FROM l_sql1
      DECLARE sel_return_cs CURSOR FOR sel_return_pre
      PREPARE sel_return_pre1 FROM l_sql2
      DECLARE sel_return_cs1 CURSOR FOR sel_return_pre1
      FOREACH sel_return_cs INTO l_sale.*
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         IF cl_null(l_sale.sale) THEN LET l_sale.sale = 0 END IF
         INSERT INTO sale_per_s2_temp values(l_sale.ima131,l_sale.sale)
         INITIALIZE l_sale.ima131 TO NULL
         LET l_sale.sale=0
      END FOREACH
      FOREACH sel_return_cs1 INTO l_sale1.*
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         IF cl_null(l_sale1.sale) THEN LET l_sale1.sale = 0 END IF
         INSERT INTO sale_per_s2_temp1 values(l_sale1.ima131,l_sale1.sale)
         INITIALIZE l_sale1.ima131 TO NULL
         LET l_sale1.sale=0
      END FOREACH
   END FOREACH
   LET l_sql3 = "SELECT DISTINCT ima131 FROM sale_per_s2_temp WHERE ima131 IS NOT NULL"  #ima131不可為空暫定
   PREPARE sel_sale_perfor_pre2 FROM l_sql3
   DECLARE sel_sale_perfor_cs2 CURSOR FOR sel_sale_perfor_pre2
   FOREACH sel_sale_perfor_cs2 INTO l_ima131
      LET l_sale.sale=0
      LET l_sale1.sale=0
      INITIALIZE l_sale.ima131,l_sale1.ima131 TO NULL      
      LET l_sql1 = "SELECT ima131,SUM(sale) FROM sale_per_s2_temp WHERE ima131= ? GROUP BY ima131"
      LET l_sql2 = "SELECT ima131,SUM(sale) FROM sale_per_s2_temp1 WHERE ima131= ? GROUP BY ima131"
      PREPARE sel_sale_perfor_pre FROM l_sql1
      EXECUTE sel_sale_perfor_pre USING l_ima131 INTO l_sale.*
      PREPARE sel_sale_perfor_pre1 FROM l_sql2
      EXECUTE sel_sale_perfor_pre1 USING l_ima131 INTO l_sale1.*
      INITIALIZE l_oba02,l_oba_str TO NULL
      SELECT oba02 INTO l_oba02 FROM oba_file WHERE oba01 = l_ima131
      IF NOT cl_null(l_oba02) THEN
         LET l_oba_str = l_ima131 CLIPPED,"(",l_oba02 CLIPPED,")"
      ELSE
         LET l_oba_str = l_ima131 CLIPPED
      END IF
      CALL cl_chart_array_data(p_loc,"categories","",l_oba_str)
      CALL cl_chart_array_data(p_loc,"dataset",p_year,l_sale.sale)
      CALL cl_chart_array_data(p_loc,"dataset",p_year-1,l_sale1.sale)
   END FOREACH  

   INITIALIZE l_substr TO NULL
   LET l_substr = cl_getmsg('agl-172',g_lang),":",p_year  #年度
   IF NOT cl_null(p_month) THEN
      LET l_substr = l_substr CLIPPED," / ",cl_getmsg('azz-159',g_lang),":",p_month CLIPPED  #月份
   END IF
   IF NOT cl_null(p_area) THEN 
      SELECT ryf02 INTO l_ryf02 FROM ryf_file WHERE ryf01 = p_area
      
      LET l_substr = l_substr CLIPPED," / ",cl_getmsg('azz1099',g_lang),":",p_area CLIPPED,"(",l_ryf02,")"  #銷售城區
   END IF
   IF NOT cl_null(p_plant) THEN 
      SELECT azw08 INTO l_azw08 FROM azw_file WHERE azw01=p_plant
      LET l_substr = l_substr CLIPPED," / ",cl_getmsg('azz1100',g_lang),":",p_plant CLIPPED,"(",l_azw08,")"   #營運中心

   END IF

   IF NOT cl_null(l_substr) THEN
      CALL cl_chart_attr(p_loc,"subcaption",l_substr)    #設定子標題
   END IF
   CALL cl_chart_create(p_loc,"s_chart_sale2_s2")  
   CALL cl_chart_clear(p_loc)   


END FUNCTION

#FUN-BA0095
