# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: s_wotype.4gl
# Descriptions...: 將工單之狀況碼轉換為狀況說明
# Date & Author..: 92/08/03 By Nora
# Usage..........: CALL s_wotype(p_code) RETURNING l_sta
# Input Parameter: p_code  狀況碼
# Return Code....: l_sta   狀況說明
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.TQC-840070 08/04/30 By baofei 修改 CASE p_code
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_wotype(p_code)
   DEFINE  p_code   LIKE sfb_file.sfb02,
           l_sta    LIKE zaa_file.zaa08        #No.FUN-680147 VARCHAR(12)
   LET l_sta = " "
   LET g_errno = " "
   IF cl_null(p_code) OR p_code IS NULL THEN RETURN  l_sta END IF
   CASE p_code
		WHEN 1 CALL cl_getmsg('mfg5040',g_lang) RETURNING l_sta
                WHEN 2 CALL cl_getmsg('mfg5041',g_lang) RETURNING l_sta #No.TQC-840070 
		WHEN 5 CALL cl_getmsg('mfg5042',g_lang) RETURNING l_sta 
		WHEN 7 CALL cl_getmsg('mfg5043',g_lang) RETURNING l_sta 
                WHEN 8 CALL cl_getmsg('mfg5045',g_lang) RETURNING l_sta #No.TQC-840070
		WHEN 11 CALL cl_getmsg('mfg5044',g_lang) RETURNING l_sta
                WHEN 12 CALL cl_getmsg('mfg5017',g_lang) RETURNING l_sta  #No.TQC-840070 
		WHEN 13 CALL cl_getmsg('mfg9386',g_lang) RETURNING l_sta
                WHEN 15 CALL cl_getmsg('mfg5046',g_lang) RETURNING l_sta  #No.TQC-840070
		OTHERWISE LET g_errno='mfg5053'
   END CASE
   RETURN l_sta
END FUNCTION
