# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: s_chart_ap_m.4gl
# Descriptions...: 應付帳款狀況
# Date & Author..: No.FUN-BA0095 2011/11/22 By qiaozy
# Input Parameter:            
#                  p_loc      圖表位置
# Usage..........: CALL s_chart_ap_m(p_loc)
# Modify.........: 

DATABASE ds

GLOBALS "../../config/top.global"
GLOBALS "../4gl/s_chart.global"

FUNCTION s_chart_ap_m(p_loc)
DEFINE p_loc        LIKE type_file.chr10
DEFINE l_sql        STRING
DEFINE l_sql1       STRING
DEFINE l_substr     STRING
DEFINE l_str1       STRING
DEFINE l_str2       STRING
DEFINE l_apa02      LIKE type_file.chr6  #年月
DEFINE l_apa34      LIKE apa_file.apa34 #應付金額
DEFINE l_apa35      LIKE apa_file.apa35 #已付金額
DEFINE l_chk_auth        STRING

   WHENEVER ERROR CONTINUE

   CALL cl_chart_init(p_loc) #

   IF NOT s_chart_auth("s_chart_ap_m",g_user) THEN
      LET l_chk_auth=cl_getmsg('azz1135',g_lang) CLIPPED
      CALL cl_chart_set_empty(p_loc, l_chk_auth)
      RETURN 
   END IF

   #抓取期別
   
   INITIALIZE l_apa02 TO NULL
   LET l_apa35 = 0
   LET l_apa34 = 0
   LET l_sql= "SELECT ",cl_tp_tochar('apa02','YYYYMM'),",SUM(apa34),SUM(apa35)",
              "  FROM apa_file",
              " WHERE apa34>apa35 ",
              "   AND apa41 = 'Y' ",
              " GROUP BY ",cl_tp_tochar('apa02','YYYYMM'),
              " ORDER BY ",cl_tp_tochar('apa02','YYYYMM')
   PREPARE amout_money_pre FROM l_sql
   DECLARE amout_money_cs  CURSOR FOR amout_money_pre
   FOREACH amout_money_cs INTO l_apa02,l_apa34,l_apa35
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET l_str1=cl_getmsg('azz1123',g_lang)
      LET l_str2=cl_getmsg('azz1124',g_lang)
      CALL cl_chart_array_data(p_loc,"categories","",l_apa02)
      CALL cl_chart_array_data(p_loc,"dataset",l_str1,l_apa34)
      CALL cl_chart_array_data(p_loc,"dataset",l_str2,l_apa35)
   END FOREACH
   CALL cl_chart_create(p_loc,"s_chart_ap_m") 
   CALL cl_chart_clear(p_loc)

   CALL s_chart_ap_s1(l_apa02,'','','','',"wc_2")
   CALL s_chart_ap_s2(l_apa02,'','','','',"wc_3")
   CALL s_chart_ap_s3(l_apa02,'','','','',"wc_4")
   CALL s_chart_ap_s4(l_apa02,'','','','',"wc_5")
   CALL s_chart_ap_s5(l_apa02,'','','','',"wc_6")

   LET g_lnkchart8.argv1 = l_apa02

END FUNCTION
  
#FUN-BA0095
