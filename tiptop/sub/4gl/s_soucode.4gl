# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_soucode.4gl
# Descriptions...: 將[料件基本資料]的來源碼轉換成說明
# Date & Author..: 93/03/13 By Apple
# Usage..........: CALL s_soucode(p_code) RETURNING l_sta
# Input Parameter: p_code  來源碼 
# Return code....: l_sta   來源碼說明
# Memo...........: 英文版時,請將l_sta的長度加長變成(C20),及畫面上的
#                  欄位長度亦同時修改之。
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds        #FUN-6C0017   #FUN-7C0053
 
GLOBALS "../../config/top.global"
 
FUNCTION s_soucode(p_code)
   DEFINE  p_code   LIKE type_file.chr1,           #NO.FUN-680147 VARCHAR(01)
           l_sta    LIKE zaa_file.zaa08            #NO.FUN-680147 VARCHAR(12)
 
   LET l_sta = " "
   IF cl_null(p_code) THEN RETURN l_sta END IF
   CASE p_code
		WHEN 'C' CALL cl_getmsg('mfg9148',g_lang) RETURNING l_sta
		WHEN 'T' CALL cl_getmsg('mfg9149',g_lang) RETURNING l_sta
		WHEN 'D' CALL cl_getmsg('mfg9150',g_lang) RETURNING l_sta
		WHEN 'A' CALL cl_getmsg('mfg9151',g_lang) RETURNING l_sta
		WHEN 'M' CALL cl_getmsg('mfg9152',g_lang) RETURNING l_sta
		WHEN 'P' CALL cl_getmsg('mfg9153',g_lang) RETURNING l_sta
		WHEN 'X' CALL cl_getmsg('mfg9154',g_lang) RETURNING l_sta
		WHEN 'K' CALL cl_getmsg('mfg9155',g_lang) RETURNING l_sta
		WHEN 'U' CALL cl_getmsg('mfg9156',g_lang) RETURNING l_sta
		WHEN 'V' CALL cl_getmsg('mfg9157',g_lang) RETURNING l_sta
		WHEN 'R' CALL cl_getmsg('mfg9158',g_lang) RETURNING l_sta
		WHEN 'Z' CALL cl_getmsg('mfg9159',g_lang) RETURNING l_sta
		WHEN 'S' CALL cl_getmsg('mfg9160',g_lang) RETURNING l_sta
   END CASE
   RETURN l_sta
END FUNCTION
