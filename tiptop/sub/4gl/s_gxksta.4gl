# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_gxksta.4gl
# Descriptions...: 將定存性質轉換為性質說明
# Date & Author..: 02/12/10 BY Kitty
# Usage..........: CALL s_gxksta(p_code) RETURNING l_sta
# Input Parameter: p_code  性質碼
# Return code....: l_sta   性質說明
# Modify.........: No.FUN-680147 06/09/01 By Czl  類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds        #No.FUN-680147 
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_gxksta(p_code)
   DEFINE  
           p_code   LIKE type_file.chr1,         #No.FUN-680147 VARCHAR(1)
           l_no     LIKE ze_file.ze01,           #No.FUN-680147 VARCHAR(7)     
           l_string LIKE type_file.chr1000,      #No.FUN-680147 VARCHAR(90)
           l_n      LIKE type_file.num5,         #No.FUN-680147 SMALLINT
           l_sta    LIKE ze_file.ze03            #No.FUN-680147 VARCHAR(4)
   LET l_sta = " "
   IF p_code IS NULL OR p_code = ' ' THEN RETURN  l_sta END IF
   CASE
    WHEN p_code = '1'
         LET l_no='anm-281'
    WHEN p_code = '2'
         LET l_no='anm-282'
    WHEN p_code = '3'
         LET l_no='anm-283'
 
   END CASE
   SELECT ze03 INTO l_sta FROM ze_file
    WHERE ze01 = l_no AND ze02 = g_lang
   IF STATUS THEN LET l_sta='' END IF
   RETURN l_sta
END FUNCTION
