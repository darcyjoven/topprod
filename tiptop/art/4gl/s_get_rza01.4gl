# Prog. Version..: '5.30.06-13.03.12(00002)'     #
# Program name...: s_get_rza01.4gl
# Descriptions...: 取rza01的值给g_rza01使用
# Date & Author..: FUN-A30113 10/04/02 By chenmoyan
# Modify.........: No:FUN-B30031 11/03/23 By shiwuying 增加生效范围判断

DATABASE ds
#FUN-B30031 Begin---
#FUNCTION s_get_rza01()
FUNCTION s_get_rza01(p_rza03,p_plant)
   DEFINE   p_rza03      LIKE rza_file.rza03
   DEFINE   p_plant      LIKE azw_file.azw01
#FUN-B30031 End-----
   DEFINE   ls_sql       STRING
   DEFINE   lc_rza01     LIKE rza_file.rza01
   DEFINE   ls_value     STRING
   DEFINE   ls_desc      STRING
  #FUN-B30031 Begin---
  #LET ls_sql = "SELECT rza01 FROM rza_file ORDER BY rza01"
   LET ls_sql = "SELECT rza01 FROM rza_file,rzb_file ",
                " WHERE rza01 = rzb01 ",
                "   AND rza03 = '",p_rza03,"'",
                "   AND rzb02 = '",p_plant,"'"
  #FUN-B30031 End-----
   PREPARE rza_pre FROM ls_sql
   DECLARE rza_curs CURSOR FOR rza_pre
   FOREACH rza_curs INTO lc_rza01
      LET ls_value = ls_value,lc_rza01 CLIPPED,","
      LET ls_desc = ls_value CLIPPED," : ",lc_rza01 CLIPPED,",",ls_desc
   END FOREACH
   CALL cl_set_combo_items("g_rza01",ls_value.subString(1,ls_value.getLength()-1),ls_desc.subString(1,ls_desc.getLength()-1))
END FUNCTION
#FUN-A30113
