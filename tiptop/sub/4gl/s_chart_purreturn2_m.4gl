# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_chart_purreturn2_m.4gl
# Descriptions...: 部門各年度採購退貨金額
# Date & Author..: No.FUN-BA0095 2012/01/11 By baogc
# Input Parameter: p_loc  圖表位置
# Usage..........: CALL s_chart_purreturn2_m(p_loc)
# Modify.........: 

DATABASE ds

GLOBALS "../../config/top.global"
GLOBALS "../4gl/s_chart.global"

FUNCTION s_chart_purreturn2_m(p_loc)
DEFINE p_loc                  LIKE type_file.chr10
DEFINE l_chk_auth             STRING

   WHENEVER ERROR CONTINUE

   IF NOT s_chart_auth("s_chart_purreturn2_m",g_user) THEN 
      LET l_chk_auth = cl_getmsg('azz1135',g_lang) CLIPPED
      CALL cl_chart_set_empty(p_loc, l_chk_auth)
      RETURN 
   END IF #判斷權限

   #聯動各年度採購退貨金額4gl程式(s_chart_purreturn_m),并傳參g_grup
   CALL s_chart_purreturn_m(p_loc,g_grup)
END FUNCTION

#FUN-BA0095
