# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: s_chart_sale_s2.4gl
# Descriptions...: 查詢某一年度(月份)內各產品分類業績
# Date & Author..: No.FUN-BA0095 2011/10/26 By baogc
# Input Parameter: p_year     年度
#                  p_month    月份
#                  p_cusclass 客戶分類
#                  p_salarea  銷售地區
#                  p_salcalss 出貨類別
#                  p_loc      圖表位置
#                  p_grup     部門編號
# Usage..........: CALL s_chart_sale_s2(p_year,p_month,p_cusclass,p_salarea,p_salclass,p_loc,p_grup)
# Modify.........: 

DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION s_chart_sale_s2(p_year,p_month,p_cusclass,p_salarea,p_salclass,p_loc,p_grup)
DEFINE p_year       LIKE type_file.num5
DEFINE p_month      LIKE type_file.num5
DEFINE p_cusclass   LIKE occ_file.occ03
DEFINE p_salarea    LIKE occ_file.occ22
DEFINE p_salclass   LIKE oga_file.oga08
DEFINE p_loc        LIKE type_file.chr10
DEFINE p_grup       LIKE oga_file.oga15
DEFINE l_sql        STRING
DEFINE l_substr     STRING
DEFINE l_sale       RECORD
             ima131 LIKE ima_file.ima131,
             sale   LIKE ogb_file.ogb14t
                    END RECORD
DEFINE l_oca02      LIKE oca_file.oca02
DEFINE l_geo02      LIKE geo_file.geo02
DEFINE l_oga08      STRING
DEFINE l_oba02      LIKE oba_file.oba02  #產品分類名稱
DEFINE l_oba_str    STRING               #存放產品分類信息
DEFINE l_chk_auth   STRING
DEFINE l_gem02      LIKE gem_file.gem02

   WHENEVER ERROR CONTINUE

   CALL cl_chart_init(p_loc) #

   IF NOT s_chart_auth("s_chart_sale_s2",g_user) AND cl_null(p_grup) THEN 
      LET l_chk_auth = cl_getmsg('azz1135',g_lang) CLIPPED
      CALL cl_chart_set_empty(p_loc, l_chk_auth)  
      RETURN 
   END IF                                #判斷權限

   #創建臨時表
   DROP TABLE sale_per_s2_temp
   CREATE TEMP TABLE sale_per_s2_temp(
   ima131 LIKE ima_file.ima131,
   sale   LIKE ogb_file.ogb14t)

   #抓取銷售金額
   INITIALIZE l_sale.* TO NULL
   LET l_sql = "SELECT c.ima131,SUM(a.ogb14t*oga24) ",
               "  FROM ogb_file a JOIN oga_file b ON a.ogb01 = b.oga01 ",
               "                                 AND b.oga09 IN ('2','3','4','6') ",
               "                                 AND b.ogapost = 'Y' ",
               "       LEFT OUTER JOIN ima_file c ON c.ima01 = a.ogb04 ",
               "       LEFT OUTER JOIN occ_file d ON d.occ01 = b.oga03 ",
               "       LEFT OUTER JOIN occ_file e ON e.occ01 = b.oga04 ",
               " WHERE YEAR(b.oga02) = '",p_year,"' "
   IF NOT cl_null(p_month) THEN LET l_sql = l_sql CLIPPED," AND MONTH(b.oga02) = '",p_month,"' " END IF
   IF NOT cl_null(p_cusclass) THEN LET l_sql = l_sql CLIPPED," AND d.occ03 = '",p_cusclass,"' " END IF
   IF NOT cl_null(p_salarea) THEN LET l_sql = l_sql CLIPPED," AND e.occ22 = '",p_salarea,"' " END IF
   IF NOT cl_null(p_salclass) THEN LET l_sql = l_sql CLIPPED," AND b.oga08 = '",p_salclass,"' " END IF
   IF NOT cl_null(p_grup) THEN LET l_sql = l_sql CLIPPED," AND b.oga15 = '",p_grup,"' " END IF
   LET l_sql = l_sql CLIPPED," GROUP BY ima131"
   PREPARE sel_sale_pre FROM l_sql
   DECLARE sel_sale_cs CURSOR FOR sel_sale_pre
   FOREACH sel_sale_cs INTO l_sale.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF cl_null(l_sale.sale) THEN LET l_sale.sale = 0 END IF
      INSERT INTO sale_per_s2_temp values(l_sale.ima131,l_sale.sale)
      INITIALIZE l_sale.* TO NULL
   END FOREACH

   #抓取销退金额
   INITIALIZE l_sale.* TO NULL
   LET l_sql = "SELECT c.ima131,SUM(a.ohb14t*oha24)*(-1) ",
               "  FROM ohb_file a JOIN oha_file b ON a.ohb01 = b.oha01 ",
               "                                 AND b.oha05 IN ('1','2') ",
               "                                 AND b.ohapost = 'Y' ",
               "       LEFT OUTER JOIN ima_file c ON c.ima01 = a.ohb04 ",
               "       LEFT OUTER JOIN occ_file d ON d.occ01 = b.oha03 ",
               "       LEFT OUTER JOIN occ_file e ON e.occ01 = b.oha04 ",
               " WHERE YEAR(b.oha02) = '",p_year,"' "
   IF NOT cl_null(p_month) THEN LET l_sql = l_sql CLIPPED," AND MONTH(b.oha02) = '",p_month,"' " END IF
   IF NOT cl_null(p_cusclass) THEN LET l_sql = l_sql CLIPPED," AND d.occ03 = '",p_cusclass,"' " END IF
   IF NOT cl_null(p_salarea) THEN LET l_sql = l_sql CLIPPED," AND e.occ22 = '",p_salarea,"' " END IF
   IF NOT cl_null(p_salclass) THEN LET l_sql = l_sql CLIPPED," AND b.oha08 =  '",p_salclass,"' " END IF
   IF NOT cl_null(p_grup) THEN LET l_sql = l_sql CLIPPED," AND b.oha15 = '",p_grup,"' " END IF
   LET l_sql = l_sql CLIPPED," GROUP BY ima131"
   PREPARE sel_return_pre FROM l_sql
   DECLARE sel_return_cs CURSOR FOR sel_return_pre
   FOREACH sel_return_cs INTO l_sale.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF cl_null(l_sale.sale) THEN LET l_sale.sale = 0 END IF
      INSERT INTO sale_per_s2_temp values(l_sale.ima131,l_sale.sale)
      INITIALIZE l_sale.* TO NULL
   END FOREACH

   LET l_sql = "SELECT ima131,SUM(sale) FROM sale_per_s2_temp GROUP BY ima131 "
   PREPARE sel_sale_perfor_pre FROM l_sql
   DECLARE sel_sale_perfor_cs CURSOR FOR sel_sale_perfor_pre
   FOREACH sel_sale_perfor_cs INTO l_sale.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF cl_null(l_sale.sale) THEN LET l_sale.sale = 0 END IF
      INITIALIZE l_oba02,l_oba_str TO NULL
      SELECT oba02 INTO l_oba02 FROM oba_file WHERE oba01 = l_sale.ima131
      IF NOT cl_null(l_oba02) THEN
         LET l_oba_str = l_sale.ima131 CLIPPED,"(",l_oba02 CLIPPED,")"
      ELSE
         LET l_oba_str = l_sale.ima131 CLIPPED
      END IF
      CALL cl_chart_array_data(p_loc,"dataset",l_oba_str,l_sale.sale)
   END FOREACH

   INITIALIZE l_substr TO NULL
   LET l_substr = cl_getmsg('agl-172',g_lang),":",p_year  #年度
   IF NOT cl_null(p_month) THEN
      LET l_substr = l_substr CLIPPED," / ",cl_getmsg('azz-159',g_lang),":",p_month CLIPPED  #月份
   END IF
   IF NOT cl_null( p_cusclass) THEN 
      SELECT oca02 INTO l_oca02 FROM oca_file WHERE oca01 = p_cusclass
      LET l_substr = l_substr CLIPPED," / ",cl_getmsg('azz-163',g_lang),":",p_cusclass CLIPPED,"(",l_oca02,")"  #客戶分類
   END IF
   IF NOT cl_null( p_salarea ) THEN 
      SELECT geo02 INTO l_geo02 FROM geo_file WHERE geo01 = p_salarea
      LET l_substr = l_substr CLIPPED," / ",cl_getmsg('azz-164',g_lang),":",p_salarea CLIPPED,"(",l_geo02,")"   #銷售地區
   END IF
   IF NOT cl_null( p_salclass ) THEN 
      CASE p_salclass
         WHEN '1' LET l_oga08 = cl_getmsg('aws-023',g_lang)  #內銷
         WHEN '2' LET l_oga08 = cl_getmsg('aws-024',g_lang)  #外銷
         WHEN '3' LET l_oga08 = cl_getmsg('aws-025',g_lang)  #視同外銷
      END CASE
      LET l_substr = l_substr CLIPPED," / ",cl_getmsg('azz-165',g_lang),":",p_salclass CLIPPED,"(",l_oga08,")"  #出貨類別
   END IF
   IF NOT cl_null(p_grup) THEN
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = p_grup
      LET l_substr = l_substr CLIPPED," / ",cl_getmsg('sub-100',g_lang),":",p_grup CLIPPED,"(",l_gem02,")"      #部門
   END IF

   IF NOT cl_null(l_substr) THEN
      CALL cl_chart_attr(p_loc,"subcaption",l_substr)    #設定子標題
   END IF
   IF NOT cl_null(p_grup) THEN
      CALL cl_chart_create(p_loc,"s_chart_sale3_s2")
   ELSE
      CALL cl_chart_create(p_loc,"s_chart_sale_s2")  
   END IF
   CALL cl_chart_clear(p_loc)   


END FUNCTION

#FUN-BA0095
