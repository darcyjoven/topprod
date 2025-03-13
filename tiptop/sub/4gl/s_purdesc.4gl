# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_purdesc.4gl
# Descriptions...: 購料特性:以中文顯示  
# Date & Author..: 92/10/15 By fiona
# Usage..........: CALL s_purdesc(p_code) RETURNING l_sta
# Input Parameter: p_code  狀況碼
# Return code....: l_sta   狀況說明
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_purdesc(p_code)
   DEFINE  p_code   LIKE ima_file.ima103,
           l_sta    LIKE ze_file.ze03          #No.FUN-680147 VARCHAR(12)
 
   LET l_sta = " "
   LET g_errno = " "
   IF cl_null(p_code) OR p_code IS NULL THEN RETURN  l_sta END IF
   CASE p_code
		WHEN '0' CALL cl_getmsg('mfg0148',g_lang) RETURNING l_sta
		WHEN '1' CALL cl_getmsg('mfg0149',g_lang) RETURNING l_sta
		OTHERWISE CALL cl_getmsg('mfg0150',g_lang) RETURNING l_sta
   END CASE
   RETURN l_sta
END FUNCTION
