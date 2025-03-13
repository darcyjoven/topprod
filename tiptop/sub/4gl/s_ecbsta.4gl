# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_ecbsta.4gl
# Descriptions...: 製程資料中成本基準之中文說明
# Date & Author..: 90/11/22 By Nora
# Usage..........: CALL s_ecbsta(p_code) RETURNING l_sta
# Input Parameter: p_code  成本基準
# Return code....: l_sta   成本基準說明
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds   #No.FUN-680147 
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
FUNCTION s_ecbsta(p_code)
   DEFINE  p_code   LIKE type_file.chr1,          #No.FUN-680147 VARCHAR(01)
           l_string LIKE ze_file.ze03,            #No.FUN-680147 VARCHAR(14)
           l_n      LIKE type_file.num5,          #No.FUN-680147 SMALLINT
           l_sta    LIKE tod_file.tod09           #No.FUN-680147 VARCHAR(09)
#modify 91/12/19 by pin
   IF p_code IS NULL OR p_code = ' '
      THEN RETURN " "
   END IF
   LET l_sta = ""
  
   SELECT ze03 INTO l_string FROM ze_file WHERE ze01 = "sub-056" AND ze02 = g_lang 
 
#  CASE 
#   WHEN g_lang = '0'
#     LET l_string = '小時/單位/小時'
#   WHEN g_lang = '2'
#     LET l_string = '小時/單位/小時'
#   OTHERWISE
#     LET l_string = 'HOUR/UNIT/HOUR'
#  END CASE
   LET l_n = (p_code - 1) * 5 + 1 USING'&'
   LET l_sta=l_string[l_n,l_n+8]
   RETURN l_sta
END FUNCTION
