# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: s_wostatus.4gl
# Descriptions...: 將工單之狀態碼轉換為狀態說明
# Date & Author..: 92/09/01 By Pin  
# Usage..........: CALL s_wostatus(p_cdoe) RETURNING l_sta
# Input Parameter: p_code 狀況碼
# Return Code....: l_sta  狀況說明
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
FUNCTION s_wostatus(p_code)
   DEFINE  p_code   LIKE sfb_file.sfb04,
           l_sta    LIKE zaa_file.zaa08         #No.FUN-680147 VARCHAR(24)
   LET l_sta = " "
   LET g_errno = " "
   IF cl_null(p_code) OR p_code IS NULL THEN RETURN  l_sta END IF
   CASE p_code
		WHEN 1 CALL cl_getmsg('mfg6173',g_lang) RETURNING l_sta
		WHEN 2 CALL cl_getmsg('mfg6174',g_lang) RETURNING l_sta
		WHEN 3 CALL cl_getmsg('mfg6175',g_lang) RETURNING l_sta
		WHEN 4 CALL cl_getmsg('mfg6176',g_lang) RETURNING l_sta
		WHEN 5 CALL cl_getmsg('mfg6177',g_lang) RETURNING l_sta
		WHEN 6 CALL cl_getmsg('mfg6178',g_lang) RETURNING l_sta
		WHEN 7 CALL cl_getmsg('mfg6179',g_lang) RETURNING l_sta
		WHEN 8 CALL cl_getmsg('mfg6180',g_lang) RETURNING l_sta
        OTHERWISE LET l_sta=' '
   END CASE
   IF l_sta IS NULL THEN LET l_sta=' ' END IF
   RETURN l_sta
END FUNCTION
