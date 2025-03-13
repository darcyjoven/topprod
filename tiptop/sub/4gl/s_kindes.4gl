# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_kindes.4gl
# Descriptions...: 將廠商性值轉換為狀況說明
# Date & Author..: 92/08/21 By Keith
# Usage..........: CALL s_kindes(p_code) RETURNING l_sta
# Input Parameter: p_code   狀況碼
# Return code....: l_sta    狀況說明 
# Modify.........: No.FUN-680147 06/09/04 By Czl  類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"        #No.FUN-680147  #FUN-7C0053
 
FUNCTION s_kindes(p_code)
   DEFINE  p_code   LIKE sma_file.sma26,
           l_sta    LIKE ze_file.ze03     #No.FUN-680147 VARCHAR(40)
    WHENEVER ERROR CALL cl_err_msg_log
   LET l_sta = " "
   LET g_errno = " "
   IF cl_null(p_code) OR p_code IS NULL THEN RETURN  l_sta END IF
   CASE p_code
        WHEN '1' CALL cl_getmsg('mfg3271',g_lang) RETURNING l_sta
        WHEN '2' CALL cl_getmsg('mfg3272',g_lang) RETURNING l_sta
        WHEN '3' CALL cl_getmsg('mfg3273',g_lang) RETURNING l_sta
#	OTHERWISE LET g_errno='mfg5061'
   END CASE
   RETURN l_sta
END FUNCTION
