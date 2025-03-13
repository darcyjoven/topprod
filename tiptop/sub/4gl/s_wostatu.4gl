# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: s_wostatu.4gl
# Descriptions...: 將工單之狀態轉換為狀態說明
# Date & Author..: 92/08/03 By Nora
# Usage..........: CALL s_wostatu(p_code) RETURNING l_sta
# Input Parameter: p_code 狀態
# Return Code....: l_sta  狀態說明
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_wostatu(p_code)
   DEFINE  p_code   LIKE sfb_file.sfb04,
           l_sta    LIKE zaa_file.zaa08        #No.FUN-680147 VARCHAR(22)
   LET l_sta = " "
   IF cl_null(p_code) OR p_code IS NULL THEN RETURN  l_sta END IF
   CASE p_code
		WHEN '1' CALL cl_getmsg('mfg5022',g_lang) RETURNING l_sta
		WHEN '2' CALL cl_getmsg('mfg5023',g_lang) RETURNING l_sta
		WHEN '3' CALL cl_getmsg('mfg5024',g_lang) RETURNING l_sta
		WHEN '4' CALL cl_getmsg('mfg5025',g_lang) RETURNING l_sta
		WHEN '5' CALL cl_getmsg('mfg5026',g_lang) RETURNING l_sta
		WHEN '6' CALL cl_getmsg('mfg5027',g_lang) RETURNING l_sta
		WHEN '7' CALL cl_getmsg('mfg5028',g_lang) RETURNING l_sta
		WHEN '8' CALL cl_getmsg('mfg5029',g_lang) RETURNING l_sta
   END CASE
   IF l_sta IS NULL THEN LET l_sta=' ' END IF
   RETURN l_sta
END FUNCTION
