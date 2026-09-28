# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_chart_salereturn_s5.4gl
# Descriptions...: 各客戶銷退余額
# Date & Author..: No.FUN-BA0095 2011/11/17 By qiaozy
# Input Parameter: p_year     年度
#                  p_month    月份
#                  p_rtnreason    銷退原因
#                  p_itemclass 產品分類
#                  p_cusclass 客戶分類
#                  p_loc      圖表位置
#                  p_grup     部門編號
# Usage..........: CALL s_chart_salereturn_s5(p_year,p_month,p_rtnreason,p_itemclass,p_cusclass,p_loc,p_grup)
# Modify.........: 

DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION s_chart_salereturn_s5(p_year,p_month,p_rtnreason,p_itemclass,p_cusclass,p_loc,p_grup)
DEFINE p_year       LIKE type_file.num5
DEFINE p_month      LIKE type_file.num5
DEFINE p_rtnreason  LIKE ohb_file.ohb50
DEFINE p_itemclass  LIKE ima_file.ima131
DEFINE p_cusclass   LIKE occ_file.occ03
DEFINE p_loc        LIKE type_file.chr10
DEFINE p_grup       LIKE oga_file.oga15
DEFINE l_sql        STRING
DEFINE l_substr     STRING
DEFINE l_sale       RECORD               #客戶分類
             oha03  LIKE oha_file.oha03,
             sale   LIKE ogb_file.ogb14t
                    END RECORD
DEFINE l_ima131     LIKE ima_file.ima131
DEFINE l_oca02      LIKE oca_file.oca02
DEFINE l_oga08      STRING
DEFINE l_oak02      LIKE oak_file.oak02  #銷退原因說明
DEFINE l_oha_str    STRING               #分類說明
DEFINE l_oba02      LIKE oba_file.oba02
DEFINE l_oha032     LIKE oha_file.oha032
DEFINE l_occ02      LIKE occ_file.occ02
DEFINE l_chk_auth   STRING
DEFINE l_gem02      LIKE gem_file.gem02

   WHENEVER ERROR CONTINUE
   CALL cl_chart_init(p_loc) #

   IF NOT s_chart_auth("s_chart_salereturn_s5",g_user) AND cl_null(p_grup) THEN
      LET l_chk_auth=cl_getmsg('azz1135',g_lang) CLIPPED
      CALL cl_chart_set_empty(p_loc, l_chk_auth)
      RETURN
   END IF

   DROP TABLE sale_per_s5_temp
   CREATE TEMP TABLE sale_per_s5_temp(
   oha03  LIKE oha_file.oha03,
   sale   LIKE ogb_file.ogb14t)

   #抓取銷售中的銷退金額
   INITIALIZE l_sale.oha03 TO NULL
   LET l_sale.sale=0
   LET l_sql = "SELECT b.oga03,SUM(a.ogb14t*oga24)*(-1) ",
               "  FROM ogb_file a JOIN oga_file b ON a.ogb01 = b.oga01 ",
               "                                 AND b.oga09 IN ('2','3','4','6') ",
               "                                 AND b.ogapost = 'Y' ",
               "                  JOIN occ_file d ON d.occ01 = b.oga03 ",
               "       LEFT OUTER JOIN ima_file c ON c.ima01 = a.ogb04 ",               
               " WHERE YEAR(b.oga02) = '",p_year,"' AND a.ogb14t<0 "
   IF NOT cl_null(p_month) THEN LET l_sql = l_sql CLIPPED," AND MONTH(b.oga02) = '",p_month,"' " END IF
   IF NOT cl_null(p_rtnreason) THEN LET l_sql = l_sql CLIPPED," AND a.ogb1001 = '",p_rtnreason,"' " END IF
   IF NOT cl_null(p_itemclass) THEN LET l_sql = l_sql CLIPPED," AND c.ima131 = '",p_itemclass,"' " END IF
   IF NOT cl_null(p_cusclass)  THEN LET l_sql = l_sql CLIPPED," AND d.occ03 = '",p_cusclass,"'" END IF
   IF NOT cl_null(p_grup) THEN LET l_sql = l_sql CLIPPED," AND b.oga15 = '",p_grup,"' " END IF
   LET l_sql = l_sql CLIPPED," GROUP BY oga03"
   PREPARE sel_sale_pre FROM l_sql
   DECLARE sel_sale_cs CURSOR FOR sel_sale_pre
   FOREACH sel_sale_cs INTO l_sale.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF cl_null(l_sale.sale) THEN LET l_sale.sale = 0 END IF
      INSERT INTO sale_per_s5_temp values(l_sale.oha03,l_sale.sale)
      INITIALIZE l_sale.oha03 TO NULL
      LET l_sale.sale=0
   END FOREACH

   #抓取ohb14t>0金額
   INITIALIZE l_sale.oha03 TO NULL
   LET l_sale.sale=0
   LET l_sql = "SELECT b.oha03,SUM(a.ohb14t*oha24) ",
               "  FROM ohb_file a JOIN oha_file b ON a.ohb01 = b.oha01 ",
               "                                 AND b.oha09 !='6' ",
               "                                 AND b.ohapost = 'Y' ",
               "                  JOIN occ_file d ON d.occ01 = b.oha03 ",               
               "       LEFT OUTER JOIN ima_file c ON c.ima01 = a.ohb04 ",
               " WHERE YEAR(b.oha02) = '",p_year,"' AND a.ohb14t>0 "
   IF NOT cl_null(p_month) THEN LET l_sql = l_sql CLIPPED," AND MONTH(b.oha02) = '",p_month,"' " END IF
   IF NOT cl_null(p_rtnreason) THEN LET l_sql = l_sql CLIPPED," AND a.ohb50 = '",p_rtnreason,"' " END IF
   IF NOT cl_null(p_itemclass) THEN LET l_sql = l_sql CLIPPED," AND c.ima131 = '",p_itemclass,"' " END IF
   IF NOT cl_null(p_cusclass)  THEN LET l_sql = l_sql CLIPPED," AND d.occ03 = '",p_cusclass,"'" END IF
   IF NOT cl_null(p_grup) THEN LET l_sql = l_sql CLIPPED," AND b.oha15 = '",p_grup,"' " END IF
   LET l_sql = l_sql CLIPPED," GROUP BY oha03"
   PREPARE sel_return_pre FROM l_sql
   DECLARE sel_return_cs CURSOR FOR sel_return_pre
   FOREACH sel_return_cs INTO l_sale.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF cl_null(l_sale.sale) THEN LET l_sale.sale = 0 END IF
      INSERT INTO sale_per_s5_temp values(l_sale.oha03,l_sale.sale)
      INITIALIZE l_sale.oha03 TO NULL
      LET l_sale.sale=0
   END FOREACH

   LET l_sql = "SELECT oha03,SUM(sale) FROM sale_per_s5_temp GROUP BY oha03 "
   PREPARE sel_sale_perfor_pre FROM l_sql
   DECLARE sel_sale_perfor_cs CURSOR FOR sel_sale_perfor_pre
   FOREACH sel_sale_perfor_cs INTO l_sale.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF cl_null(l_sale.sale) THEN LET l_sale.sale = 0 END IF
      INITIALIZE l_occ02,l_oha_str TO NULL
      SELECT occ02  INTO l_occ02 FROM occ_file  WHERE occ01 = l_sale.oha03
      IF NOT cl_null(l_occ02) THEN
         LET l_oha_str = l_sale.oha03 CLIPPED,"(",l_occ02 CLIPPED,")"
      ELSE
         LET l_oha_str = l_sale.oha03 CLIPPED
      END IF
      CALL cl_chart_array_data(p_loc,"dataset",l_oha_str,l_sale.sale)
   END FOREACH

   INITIALIZE l_substr TO NULL
   LET l_substr = cl_getmsg('agl-172',g_lang),":",p_year  #年度
   IF NOT cl_null(p_month) THEN
      LET l_substr = l_substr CLIPPED," / ",cl_getmsg('azz-159',g_lang),":",p_month CLIPPED  #月份
   END IF
   IF NOT cl_null( p_rtnreason ) THEN
      SELECT oak02 INTO l_oak02 FROM oak_file WHERE oak01 = p_rtnreason AND oak03='2'
      LET l_substr = l_substr CLIPPED," / ",cl_getmsg('azz1103',g_lang),":",p_rtnreason CLIPPED,"(",l_oak02,")" #銷退原因
   END IF
   IF NOT cl_null( p_itemclass) THEN 
      SELECT oba02 INTO l_oba02 FROM oba_file WHERE oba01 = p_itemclass
      LET l_substr = l_substr CLIPPED," / ",cl_getmsg('azz-167',g_lang),":",p_cusclass CLIPPED,"(",l_oba02,")"  #產品分類
   END IF
   IF NOT cl_null( p_cusclass) THEN 
      SELECT oca02 INTO l_oca02 FROM oca_file WHERE oca01 = p_cusclass
      LET l_substr = l_substr CLIPPED," / ",cl_getmsg('azz-163',g_lang),":",p_cusclass CLIPPED,"(",l_oca02,")"  #客戶分類
   END IF 
   IF NOT cl_null(p_grup) THEN
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = p_grup
      LET l_substr = l_substr CLIPPED," / ",cl_getmsg('sub-100',g_lang),":",p_grup CLIPPED,"(",l_gem02,")"      #部門
   END IF

   IF NOT cl_null(l_substr) THEN
      CALL cl_chart_attr(p_loc,"subcaption",l_substr)    #設定子標題
   END IF
   IF NOT cl_null(p_grup) THEN
      CALL cl_chart_create(p_loc,"s_chart_salereturn2_s5")
   ELSE
      CALL cl_chart_create(p_loc,"s_chart_salereturn_s5")  
   END IF
   CALL cl_chart_clear(p_loc)   


END FUNCTION

#FUN-BA0095
