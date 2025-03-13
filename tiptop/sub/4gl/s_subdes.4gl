# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_subdes.4gl
# Descriptions...: 將驗收單之收貨狀況轉換為狀況說明
# Date & Author..: 93/11/03 By Apple
# Usage..........: CALL s_subdes(p_code) RETURNING l_str
# Input Parameter: p_code  狀況碼
# Return code....: l_str   狀況說明
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds        #FUN-6C0017   #FUN-7C0053
 
GLOBALS "../../config/top.global"
 
FUNCTION s_subdes(p_code)
   DEFINE  p_code   LIKE aba_file.aba18, 	#No.FUN-680147 VARCHAR(02)
           l_str    LIKE zaa_file.zaa08         #No.FUN-680147 VARCHAR(06)
 
   LET l_str = " "
   CASE p_code
     WHEN '1' CALL cl_getmsg('mfg3510',g_lang) RETURNING l_str
     WHEN '2' CALL cl_getmsg('mfg3511',g_lang) RETURNING l_str
     OTHERWISE EXIT CASE
   END CASE
   RETURN l_str
END FUNCTION
