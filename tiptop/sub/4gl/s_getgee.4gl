# Prog. Version..: '5.30.06-13.03.12(00001)'     #
# FUN-A10109
# Pattern name...: s_getgee.4gl
# Descriptions...: 根據傳入的參數顯示gee_file的設定到指定的combobox
# Date & Author..: 20/02/10
# Usage..........: CALL s_getgee1(p_prog,p_lang,p_feld) 
# Input Parameter: p_prog  程式代碼
#                  p_lang  語言別
#                  p_feld  combobox欄位
# Return code....: l_str1:單別字串
#                  l_str2:單別說明字串
 
DATABASE ds
 
GLOBALS "../../config/top.global"      
 
DEFINE g_azi RECORD LIKE azi_file.*
 
FUNCTION s_getgee(p_prog,p_lang,p_feld)
   DEFINE p_lang  LIKE type_file.chr1
   DEFINE p_feld  LIKE type_file.chr50
   DEFINE p_prog  LIKE type_file.chr50
   DEFINE l_str1  STRING
   DEFINE l_str2  STRING
   DEFINE l_str3  STRING
   DEFINE l_gee02 LIKE gee_file.gee02
   DEFINE l_gee05 LIKE gee_file.gee05
    
   LET l_str1 = ''
   LET l_str2 = ''

   #FUN-A10109
   DECLARE s_getgee_cur CURSOR FOR
      SELECT gee02,gee05 FROM gee_file
       WHERE gee04 = p_prog
         AND gee03 = p_lang
       ORDER BY gee02
   FOREACH s_getgee_cur INTO l_gee02,l_gee05
      IF cl_null(l_gee02) THEN CONTINUE FOREACH END IF 
      IF cl_null(l_gee05) THEN LET l_gee05 = ' ' END IF

      IF cl_null(l_str1) THEN 
         LET l_str1 = l_gee02 CLIPPED
         LET l_str2 = l_gee02,":",l_gee05 CLIPPED
      ELSE
         LET l_str1 = l_str1 CLIPPED,",",l_gee02 CLIPPED
         LET l_str2 = l_str2 CLIPPED,",",l_gee02,":",l_gee05 CLIPPED
      END IF
   END FOREACH
   
   CALL cl_set_combo_items(p_feld,l_str1,l_str2)
END FUNCTION
