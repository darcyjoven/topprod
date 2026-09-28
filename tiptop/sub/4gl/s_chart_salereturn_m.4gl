# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_chart_salereturn_m.4gl
# Descriptions...: 各年度銷退金額
# Date & Author..: No.FUN-BA0095 2011/11/15 By qiaozy
# Input Parameter: p_loc  圖表位置
#                  p_grup 部門編號
# Usage..........: CALL s_chart_salereturn_m(p_loc,p_grup)
# Modify.........: 

DATABASE ds

GLOBALS "../../config/top.global"
GLOBALS "../4gl/s_chart.global"

FUNCTION s_chart_salereturn_m(p_loc,p_grup)
DEFINE p_loc             LIKE type_file.chr10
DEFINE p_grup            LIKE oga_file.oga15  #部門
DEFINE nyear             LIKE type_file.num5
DEFINE sale_sum          LIKE ogb_file.ogb14t #ogb14t<0金額匯總
DEFINE return_sum        LIKE ohb_file.ohb14t #ohb14t>0金額匯總
DEFINE sale_performance  LIKE ogb_file.ogb14t #銷退金額
DEFINE l_chk_auth        STRING
DEFINE l_sql             STRING
DEFINE l_substr          STRING
DEFINE l_gem02           LIKE gem_file.gem02

   CALL cl_chart_init(p_loc) #初始WebComponent的資料

   IF NOT s_chart_auth("s_chart_salereturn_m",g_user) AND cl_null(p_grup) THEN
      LET l_chk_auth=cl_getmsg('azz1135',g_lang) CLIPPED
      CALL cl_chart_set_empty(p_loc, l_chk_auth)
      RETURN
   END IF #判斷權限
  
   FOR nyear = YEAR(TODAY) - 4 TO YEAR(TODAY)

      #抓取ogb14t<0金額
      LET l_sql = "SELECT SUM(ogb14t*oga24) FROM oga_file,ogb_file ",
                  " WHERE oga01 = ogb01 ",
                  "   AND oga09 IN ('2','3','4','6') ",
                  "   AND ogapost = 'Y' ",
                  "   AND YEAR(oga02) = '",nyear,"' ",
                  "   AND ogb14t<0 "
      IF NOT cl_null(p_grup) THEN LET l_sql = l_sql CLIPPED," AND oga15 = '",p_grup,"' " END IF
      PREPARE sel_oga_pre FROM l_sql
      EXECUTE sel_oga_pre INTO sale_sum
      IF cl_null(sale_sum) THEN LET sale_sum = 0 END IF

      #抓取ogb14t>0金額
      LET l_sql = "SELECT SUM(ohb14t*oha24) FROM oha_file,ohb_file ",
                  " WHERE oha01 = ohb01 ",
                  "   AND oha09 != '6' ",
                  "   AND ohapost = 'Y' ",
                  "   AND YEAR(oha02) = '",nyear,"' ",
                  "   AND ohb14t>0 "
      IF NOT cl_null(p_grup) THEN LET l_sql = l_sql CLIPPED," AND oha15 = '",p_grup,"' " END IF
      PREPARE sel_oha_pre FROM l_sql
      EXECUTE sel_oha_pre INTO return_sum
      IF cl_null(return_sum) THEN LET return_sum = 0 END IF

      LET sale_performance = sale_sum*(-1) + return_sum #計算
      CALL cl_chart_array_data(p_loc,"categories","",nyear)
      CALL cl_chart_array_data(p_loc,"dataset"," ",sale_performance) #
   END FOR

   IF NOT cl_null(p_grup) THEN
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = p_grup
      LET l_substr = cl_getmsg('sub-100',g_lang) CLIPPED,":",p_grup CLIPPED,"(",l_gem02,")"
      CALL cl_chart_attr(p_loc,"subcaption",l_substr)
      CALL cl_chart_create(p_loc,"s_chart_salereturn2_m")
   ELSE
      CALL cl_chart_create(p_loc,"s_chart_salereturn_m")
   END IF
   CALL cl_chart_clear(p_loc) #清除p_loc相關變數資料(釋放記憶體)
   
   #以最後一個年度連動其他5個圖表
   CALL s_chart_salereturn_s1(nyear-1,"wc_2",p_grup)
   CALL s_chart_salereturn_s2(nyear-1,'','','','',"wc_3",p_grup)
   CALL s_chart_salereturn_s3(nyear-1,'','','','',"wc_4",p_grup)
   CALL s_chart_salereturn_s4(nyear-1,'','','',"wc_5",p_grup)
   CALL s_chart_salereturn_s5(nyear-1,'','','','',"wc_6",p_grup)

   LET g_lnkchart4.argv1 = nyear-1

END FUNCTION

#FUN-BA0095
