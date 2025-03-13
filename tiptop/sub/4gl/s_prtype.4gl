# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_prtype.4gl
# Descriptions...: 將P/R與P/O 之性質轉換為中文說明
# Date & Author..: 92/12/02 By Apple
# Usage..........: CALL s_prtype(p_code) RETURNING l_str
# Input Parameter: p_code  性質碼
# Return code....: l_str   狀況說明
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds      #No.FUN-680147 
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_prtype(p_code)
   DEFINE  p_code   LIKE type_file.chr3,        #No.FUN-680147 VARCHAR(03)
           l_sta    LIKE ze_file.ze03           #No.FUN-680147 VARCHAR(10)
 
   LET l_sta = " "
   CASE p_code
		WHEN 'REG' CALL cl_getmsg('mfg3228',g_lang) RETURNING l_sta
		WHEN 'EXP' CALL cl_getmsg('mfg3229',g_lang) RETURNING l_sta
		WHEN 'CAP' CALL cl_getmsg('mfg3231',g_lang) RETURNING l_sta
		WHEN 'SUB' CALL cl_getmsg('mfg3232',g_lang) RETURNING l_sta
		WHEN 'TRI' CALL cl_getmsg('axm-999',g_lang) RETURNING l_sta
		WHEN 'TAP' CALL cl_getmsg('apm-997',g_lang) RETURNING l_sta
   END CASE
   RETURN l_sta
END FUNCTION
