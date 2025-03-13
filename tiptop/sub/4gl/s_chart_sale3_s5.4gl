# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: s_chart_sale3_s5.4gl
# Descriptions...: 查詢某一年度(月份)內銷售地區的銷售業績
# Date & Author..: No.FUN-BA0095 2012/01/06 By baogc
# Input Parameter: p_year      年度
#                  p_month     月份
#                  p_itemclass 產品分類
#                  p_cusclass  客戶分類
#                  p_salarea   銷售地區
#                  p_loc       圖表位置
# Usage..........: CALL s_chart_sale3_s5(p_year,p_month,p_itemclass,p_cusclass,p_salarea,p_loc)
# Modify.........: 

DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION s_chart_sale3_s5(p_year,p_month,p_itemclass,p_cusclass,p_salarea,p_loc)
DEFINE p_year       LIKE type_file.num5
DEFINE p_month      LIKE type_file.num5
DEFINE p_itemclass  LIKE ima_file.ima131
DEFINE p_cusclass   LIKE occ_file.occ03
DEFINE p_salarea    LIKE occ_file.occ22
DEFINE p_loc        LIKE type_file.chr10
DEFINE l_chk_auth   STRING

   WHENEVER ERROR CONTINUE

   IF NOT s_chart_auth("s_chart_sale3_s5",g_user) THEN 
      LET l_chk_auth = cl_getmsg('azz1135',g_lang) CLIPPED
      CALL cl_chart_set_empty(p_loc, l_chk_auth)  
      RETURN 
   END IF                         #判斷權限

   #聯動至銷售業績4gl程式(s_chart_sale_s5)并傳參當前部門編號g_grup
   CALL s_chart_sale_s5(p_year,p_month,p_itemclass,p_cusclass,p_salarea,p_loc,g_grup)
END FUNCTION

#FUN-BA0095
