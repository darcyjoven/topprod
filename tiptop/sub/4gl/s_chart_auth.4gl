# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: s_chart_auth.4gl
# Descriptions...: Check 是否有執行某圖表的權限
# Date & Author..: No.FUN-BA0095 2011/10/25 By baogc
# Input Parameter: p_chart  圖表代號
#                  p_user   使用者
# Return code....: TRUE:  有權限
#                  FALSE: 無權限
# Usage..........: IF s_chart_auth("s_chart_sale_m",g_user) THEN
# Modify.........: 

DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION s_chart_auth(p_chart,p_user)
DEFINE p_chart   LIKE gdj_file.gdj01   #圖表代號
DEFINE p_user    LIKE zx_file.zx01     #當前使用者
DEFINE l_count   LIKE type_file.num5   #查詢資料的筆數
DEFINE l_gdj02   LIKE gdj_file.gdj02   #圖表權限類型
DEFINE l_zx03    LIKE zx_file.zx03     #使用者所屬部門

   IF cl_null(p_chart) THEN RETURN FALSE END IF
   IF p_user = "ALL" THEN RETURN TRUE END IF
   IF cl_null(p_user) THEN LET p_user = g_user END IF

   LET l_count = 0
   #判斷該動態圖表中是否有設訂權限
   SELECT COUNT(*) INTO l_count FROM gdj_file WHERE gdj01 = p_chart
   IF l_count = 0 THEN RETURN TRUE END IF #無任何設限，所有用戶都具有權限使用

   #判斷該動態圖表是否設定部門權限
   LET l_count = 0
   SELECT COUNT(*) INTO l_count FROM gdj_file WHERE gdj01 = p_chart AND gdj02 = '1'
   IF l_count > 0 THEN
      #首先根據當前使用者帶出對應的部門信息
      SELECT zx03 INTO l_zx03 FROM zx_file WHERE zx01 = p_user
      SELECT COUNT(*) INTO l_count FROM gdj_file WHERE gdj01 = p_chart AND gdj02 = '1' AND gdj03 = l_zx03
      IF l_count <= 0 THEN RETURN FALSE END IF
   END IF

   #判斷該動態圖表是否設定使用者權限
   LET l_count = 0
   SELECT COUNT(*) INTO l_count FROM gdj_file WHERE gdj01 = p_chart AND gdj02 = '2'
   IF l_count > 0 THEN
      SELECT COUNT(*) INTO l_count FROM gdj_file WHERE gdj01 = p_chart AND gdj02 = '2' AND gdj03 = p_user
      IF l_count <= 0 THEN RETURN FALSE END IF
   END IF

   RETURN TRUE
END FUNCTION

#FUN-BA0095
