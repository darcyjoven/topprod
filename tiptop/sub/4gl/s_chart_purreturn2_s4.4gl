# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_chart_purreturn2_s4.4gl
# Descriptions...: 部門各廠商分類採購退貨金額
# Date & Author..: No.FUN-BA0095 2012/01/11 By baogc
# Input Parameter: p_loc       圖表位置
#                  p_year      年度
#                  p_month     月份
#                  p_rtnreason 倉貨原因
#                  p_itemclass 產品分類
#                  p_vendclass 廠商分類
# Usage..........: CALL s_chart_purreturn2_s4(p_year,p_month,p_rtnreason,p_itemclass,p_loc)
# Modify.........: 

DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION s_chart_purreturn2_s4(p_year,p_month,p_rtnreason,p_itemclass,p_loc)
DEFINE p_loc                   LIKE type_file.chr10
DEFINE p_year                  LIKE type_file.num5
DEFINE p_month                 LIKE type_file.num5
DEFINE p_itemclass             LIKE ima_file.ima131 
DEFINE p_rtnreason             LIKE rvv_file.rvv26
DEFINE p_vendclass             LIKE pmc_file.pmc02
DEFINE l_chk_auth              STRING

   WHENEVER ERROR CONTINUE

   IF NOT s_chart_auth("s_chart_purreturn2_s4",g_user) THEN 
      LET l_chk_auth = cl_getmsg('azz1135',g_lang) CLIPPED
      CALL cl_chart_set_empty(p_loc,l_chk_auth)  
      RETURN 
   END IF                                            #判斷權限

   #聯動各廠商分類採購退貨金額4gl程式(s_chart_purreturn_s4),并傳參g_grup 
   CALL s_chart_purreturn_s4(p_year,p_month,p_rtnreason,p_itemclass,p_loc,g_grup)
END FUNCTION

#FUN-BA0095
