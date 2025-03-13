# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: s_chart_sale_s1.4gl
# Descriptions...: 查詢某一年度內各月業績
# Date & Author..: No.FUN-BA0095 2011/10/26 By baogc
# Input Parameter: p_year  年度
#                  p_loc   圖表位置
#                  p_grup  部門編號
# Usage..........: CALL s_chart_sale_s1(p_year,p_loc,p_grup)
# Modify.........: 

DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION s_chart_sale_s1(p_year,p_loc,p_grup)
DEFINE p_year           LIKE type_file.num5
DEFINE p_loc            LIKE type_file.chr10
DEFINE p_grup           LIKE type_file.chr10
DEFINE l_sql            STRING
DEFINE l_sql1           STRING
DEFINE l_sql2           STRING
DEFINE l_sale_tyear     LIKE ogb_file.ogb14t #今年銷售金額匯總
DEFINE l_sale_lyear     LIKE ogb_file.ogb14t #去年銷售金額匯總
DEFINE l_return_tyear   LIKE ohb_file.ohb14t #今年銷退金額匯總
DEFINE l_return_lyear   LIKE ohb_file.ohb14t #去年銷退金額匯總
DEFINE l_sale_per_tyear LIKE ogb_file.ogb14t #今年銷售業績
DEFINE l_sale_per_lyear LIKE ogb_file.ogb14t #去年銷售業績
DEFINE l_str            STRING               #子標題
DEFINE l_month          LIKE type_file.num5  #月份
DEFINE l_chk_auth       STRING
DEFINE l_gem02          LIKE gem_file.gem02

   WHENEVER ERROR CONTINUE

   CALL cl_chart_init(p_loc) #初始WebComponent的資料

   IF NOT s_chart_auth("s_chart_sale_s1",g_user) AND cl_null(p_grup) THEN 
      LET l_chk_auth = cl_getmsg('azz1135',g_lang) CLIPPED
      CALL cl_chart_set_empty(p_loc,l_chk_auth)  
      RETURN 
   END IF #判斷權限
  
   FOR l_month = 1 TO 12

      #抓取銷售金額
      LET l_sql = "SELECT SUM(ogb14t*oga24) FROM oga_file,ogb_file ",
                  " WHERE oga01 = ogb01 ",
                  "   AND oga09 IN ('2','3','4','6') ",
                  "   AND ogapost = 'Y' ",
                  "   AND MONTH(oga02) = '",l_month,"' "
      IF NOT cl_null(p_grup) THEN LET l_sql = l_sql CLIPPED," AND oga15 = '",p_grup,"' " END IF
      LET l_sql1 = l_sql CLIPPED," AND YEAR(oga02) = '",p_year,"' "
      LET l_sql2 = l_sql CLIPPED," AND YEAR(oga02) = '",p_year-1,"' "

      PREPARE sel_sale_tyear FROM l_sql1
      EXECUTE sel_sale_tyear INTO l_sale_tyear #今年銷售
      PREPARE sel_sale_lyear FROM l_sql2
      EXECUTE sel_sale_lyear INTO l_sale_lyear #去年銷售
      IF cl_null(l_sale_tyear) THEN LET l_sale_tyear = 0 END IF
      IF cl_null(l_sale_lyear) THEN LET l_sale_lyear = 0 END IF

      #抓取銷退金額
      LET l_sql = "SELECT SUM(ohb14t*oha24) FROM oha_file,ohb_file ",
                  " WHERE oha01 = ohb01 ",
                  "   AND oha05 IN ('1','2') ",
                  "   AND ohapost = 'Y' ",
                  "   AND MONTH(oha02) = '",l_month,"' "
      IF NOT cl_null(p_grup) THEN LET l_sql = l_sql CLIPPED," AND oha15 = '",p_grup,"' " END IF
      LET l_sql1 = l_sql CLIPPED," AND YEAR(oha02) = '",p_year,"' "
      LET l_sql2 = l_sql CLIPPED," AND YEAR(oha02) = '",p_year-1,"' "

      PREPARE sel_return_tyear FROM l_sql1
      EXECUTE sel_return_tyear INTO l_return_tyear #今年銷退
      PREPARE sel_return_lyear FROM l_sql2
      EXECUTE sel_return_lyear INTO l_return_lyear #去年銷退
      IF cl_null(l_return_tyear) THEN LET l_return_tyear = 0 END IF
      IF cl_null(l_return_lyear) THEN LET l_return_lyear = 0 END IF

      LET l_sale_per_tyear = l_sale_tyear - l_return_tyear #今年業績
      LET l_sale_per_lyear = l_sale_lyear - l_return_lyear #去年業績

      CALL cl_chart_array_data(p_loc,"categories","",l_month)
      CALL cl_chart_array_data(p_loc,"dataset",p_year,l_sale_per_tyear)
      CALL cl_chart_array_data(p_loc,"dataset",p_year-1,l_sale_per_lyear)
   END FOR

   LET l_str = cl_getmsg('agl-172',g_lang) CLIPPED,":",p_year
   IF NOT cl_null(p_grup) THEN
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = p_grup
      LET l_str = l_str CLIPPED," / ",cl_getmsg('sub-100',g_lang) CLIPPED,":",p_grup CLIPPED,"(",l_gem02,")"
   END IF
   CALL cl_chart_attr(p_loc,"subcaption",l_str)    #設定子標題
   IF NOT cl_null(p_grup) THEN
      CALL cl_chart_create(p_loc,"s_chart_sale3_s1")
   ELSE
      CALL cl_chart_create(p_loc,"s_chart_sale_s1")
   END IF
   CALL cl_chart_clear(p_loc)

END FUNCTION

#FUN-BA0095
