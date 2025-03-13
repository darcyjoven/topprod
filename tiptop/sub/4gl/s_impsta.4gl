# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_impsta.4gl
# Descriptions...: 將借料資料單身檔中的'償還方式' 改為說明
# Date & Author..: 92/06/10 By Lin
# Usage..........: CALL s_impsta(p_code) RETURNING l_str
# Input Parameter: p_code   償還方式
# Return code....: l_str    償還方式說明
# Modify.........: No.FUN-680147 06/09/04 By Czl  類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds        #No.FUN-680147 
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
FUNCTION s_impsta(p_code)
   DEFINE  p_code   LIKE type_file.chr1,          #No.FUN-680147 VARCHAR(1)
           l_n      LIKE type_file.num5,          #No.FUN-680147 SMALLINT
           l_sta    LIKE ze_file.ze03             #No.FUN-680147 CHA(8)
   LET l_sta = " "
   IF cl_null(p_code) THEN RETURN l_sta END IF
 
   CASE p_code
      WHEN '0'
         SELECT ze03 INTO l_sta FROM ze_file WHERE ze01 = 'sub-057' AND ze02 = g_lang
      WHEN '1'
         SELECT ze03 INTO l_sta FROM ze_file WHERE ze01 = 'sub-058' AND ze02 = g_lang
      WHEN '2'
         SELECT ze03 INTO l_sta FROM ze_file WHERE ze01 = 'sub-059' AND ze02 = g_lang
   END CASE
 
#  CASE  
#   WHEN  g_lang = '0'
#     CASE p_code
#       WHEN '0' LET l_sta='尚未償還'
#       WHEN '1' LET l_sta='原數償還'
#       WHEN '2' LET l_sta='原價償還'
#        OTHERWISE EXIT CASE
#     END CASE
#   WHEN  g_lang = '2'
#     CASE p_code
#       WHEN '0' LET l_sta='尚未償還'
#       WHEN '1' LET l_sta='原數償還'
#       WHEN '2' LET l_sta='原價償還'
#        OTHERWISE EXIT CASE
#     END CASE
#   OTHERWISE
#     CASE p_code
#       WHEN '0' LET l_sta='unrepay'
#       WHEN '1' LET l_sta='qty'
#       WHEN '2' LET l_sta='price'
#        OTHERWISE EXIT CASE
#     END CASE
#  END CASE
   RETURN l_sta
END FUNCTION
