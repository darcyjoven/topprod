# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_chart_salereturn_s1.4gl
# Descriptions...: 查詢某一年度內各月銷退金額
# Date & Author..: No.FUN-BA0095 2011/11/15 By qiaozy
# Input Parameter: p_year  年度
#                  p_loc   圖表位置
#                  p_grup  部門編號
# Usage..........: CALL s_chart_salereturn_s1(p_year,p_loci,p_grup)
# Modify.........: 

DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION s_chart_salereturn_s1(p_year,p_loc,p_grup)
DEFINE p_year           LIKE type_file.num5
DEFINE p_loc            LIKE type_file.chr10
DEFINE p_grup           LIKE oga_file.oga15
DEFINE l_str            STRING               #子標題
DEFINE l_month          LIKE type_file.num5  #月份
DEFINE sale_sum         LIKE ogb_file.ogb14t #銷售金額匯總
DEFINE return_sum       LIKE ohb_file.ohb14t #銷退金額匯總
DEFINE sale_performance LIKE ogb_file.ogb14t #銷退額
DEFINE l_chk_auth       STRING
DEFINE l_sql            STRING
DEFINE l_gem02          LIKE gem_file.gem02

   CALL cl_chart_init(p_loc) #

   IF NOT s_chart_auth("s_chart_salereturn_s1",g_user) AND cl_null(p_grup) THEN
      LET l_chk_auth=cl_getmsg('azz1135',g_lang) CLIPPED
      CALL cl_chart_set_empty(p_loc, l_chk_auth)
      RETURN 
   END IF

   IF cl_null(p_year) THEN LET p_year=YEAR(TODAY) END IF
   FOR l_month = 1 TO 12

      #抓取ogb14t<0金額
      LET l_sql = "SELECT SUM(ogb14t*oga24) FROM oga_file,ogb_file ",
                  " WHERE oga01 = ogb01 ",
                  "   AND oga09 IN ('2','3','4','6') ",
                  "   AND ogapost = 'Y' ",
                  "   AND ogaconf !='X' ",
                  "   AND YEAR(oga02) = '",p_year,"' ",
                  "   AND MONTH(oga02)= '",l_month,"' ",
                  "   AND ogb14t < 0 "
      IF NOT cl_null(p_grup) THEN LET l_sql = l_sql CLIPPED," AND oga15 = '",p_grup,"' " END IF
      PREPARE sel_oga_pre FROM l_sql
      EXECUTE sel_oga_pre INTO sale_sum
      IF cl_null(sale_sum) THEN LET sale_sum = 0 END IF

      #抓取ohb14t>0金額
      LET l_sql = "SELECT SUM(ohb14t*oha24) FROM oha_file,ohb_file ",
                  " WHERE oha01 = ohb01 ",
                  "   AND oha09 != '6' ",
                  "   AND ohapost = 'Y' ",
                  "   AND ohaconf !='X' ",
                  "   AND YEAR(oha02) = '",p_year,"' ",
                  "   AND MONTH(oha02) = '",l_month,"' ",
                  "   AND ohb14t > 0 "
      IF NOT cl_null(p_grup) THEN LET l_sql = l_sql CLIPPED," AND oha15 = '",p_grup,"' " END IF
      PREPARE sel_oha_pre FROM l_sql
      EXECUTE sel_oha_pre INTO return_sum
      IF cl_null(return_sum) THEN LET return_sum = 0 END IF

      LET sale_performance = sale_sum*(-1) + return_sum #
      CALL cl_chart_array_data(p_loc,"categories","",l_month)
      CALL cl_chart_array_data(p_loc,"dataset"," ",sale_performance) 

      
   END FOR

   LET l_str = cl_getmsg('agl-172',g_lang) CLIPPED,":",p_year
   IF NOT cl_null(p_grup) THEN
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = p_grup
      LET l_str = l_str CLIPPED," / ",cl_getmsg('sub-100',g_lang) CLIPPED,":",p_grup CLIPPED,"(",l_gem02,")"
   END IF
   CALL cl_chart_attr(p_loc,"subcaption",l_str)    #設定子標題
   IF NOT cl_null(p_grup) THEN
      CALL cl_chart_create(p_loc,"s_chart_salereturn2_s1")
   ELSE
      CALL cl_chart_create(p_loc,"s_chart_salereturn_s1")
   END IF
   CALL cl_chart_clear(p_loc)

END FUNCTION

#FUN-BA0095
