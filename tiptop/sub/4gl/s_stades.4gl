# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_stades.4gl
# Descriptions...: 將廠商交易狀況轉換為狀況說明
# Date & Author..: 92/08/21 By Keith
# Usage..........: CALL s_stades(p_code) RETURNING l_sta
# Input Parameter: p_code  狀況碼
# Return code....: l_sta   狀況說明 
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_stades(p_code)
   DEFINE  p_code   LIKE sma_file.sma26,
           l_sta    LIKE zaa_file.zaa08         #No.FUN-680147 VARCHAR(40)
    WHENEVER ERROR CALL cl_err_msg_log
   LET l_sta = " "
   LET g_errno = " "
   IF cl_null(p_code) OR p_code IS NULL THEN RETURN  l_sta END IF
   CASE p_code
        WHEN '0' CALL cl_getmsg('mfg3268',g_lang) RETURNING l_sta
        WHEN '1' CALL cl_getmsg('mfg3269',g_lang) RETURNING l_sta
        WHEN '2' CALL cl_getmsg('mfg3270',g_lang) RETURNING l_sta
   END CASE
   RETURN l_sta
END FUNCTION
