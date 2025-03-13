# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: s_costdesc.4gl
# Descriptions...: 成本特性:以中文顯示  
# Date & Author..: 93/11/05 By Apple
# Usage..........: CALL s_costdesc(p_code) RETURNING l_sta
# Input Parameter: p_code  狀況碼
# Return code....: l_sta   狀況說明
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.MOD-8C0068 08/12/08 By claire l_sta定義長度調整
 
DATABASE ds
 
GLOBALS "../../config/top.global"        #No.FUN-680147  #FUN-7C0053
 
FUNCTION s_costdesc(p_code)
   DEFINE  p_code   LIKE type_file.chr1,         #No.FUN-680147 VARCHAR(01)
           l_sta    LIKE ze_file.ze03            #MOD-8C0068
          #l_sta    LIKE cre_file.cre08          #No.FUN-680147 VARCHAR(10) #MOD-8C0068 mark
 
   LET l_sta = " "
   LET g_errno = " "
   IF cl_null(p_code) OR p_code IS NULL THEN RETURN  l_sta END IF
   CASE p_code
		WHEN '1' CALL cl_getmsg('mfg1315',g_lang) RETURNING l_sta
		WHEN '2' CALL cl_getmsg('mfg1316',g_lang) RETURNING l_sta
		WHEN '3' CALL cl_getmsg('mfg1317',g_lang) RETURNING l_sta
		OTHERWISE CALL cl_getmsg('mfg1315',g_lang) RETURNING l_sta
   END CASE
   RETURN l_sta
END FUNCTION
