# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_nmdsta.4gl
# Descriptions...: 將應付票據狀況碼轉換為狀況說明
# Date & Author..: 92/05/01 BY MAY 
# Usage..........: CALL s_nmdsta(p_code) RETURNING l_sta
# Input Parameter: p_code  狀況碼
# Return code....: l_sta   狀況說明
# Modify.........: No.MOD-5A0223 05/11/24 By kim 票狀屬於0的未顯示中文名,0:開立 
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds      #No.FUN-680147 
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
FUNCTION s_nmdsta(p_code)
   DEFINE  
           p_code   LIKE type_file.chr1,          #No.FUN-680147 VARCHAR(01)
           l_string LIKE type_file.chr1000,       #No.FUN-680147 VARCHAR(90)
           l_n      LIKE type_file.num5,          #No.FUN-680147 SMALLINT
           l_sta    LIKE ze_file.ze03             #No.FUN-680147 VARCHAR(04)
   LET l_sta = " "
   IF p_code IS NULL OR p_code = ' ' THEN RETURN  l_sta END IF
  {
   IF p_code NOT MATCHES '[16789]' OR p_code IS NULL OR p_code = ' ' THEN
	  RETURN l_sta
   END IF
  }
 
   CASE p_code
      WHEN '0'
         SELECT ze03 INTO l_sta FROM ze_file WHERE ze01 = 'sub-060' AND ze02 = g_lang
      WHEN '1'
         SELECT ze03 INTO l_sta FROM ze_file WHERE ze01 = 'sub-060' AND ze02 = g_lang
      WHEN 'X'
         SELECT ze03 INTO l_sta FROM ze_file WHERE ze01 = 'sub-060' AND ze02 = g_lang
      WHEN '2'
         SELECT ze03 INTO l_sta FROM ze_file WHERE ze01 = 'sub-068' AND ze02 = g_lang
      WHEN '3'
         SELECT ze03 INTO l_sta FROM ze_file WHERE ze01 = 'sub-069' AND ze02 = g_lang
      WHEN '4'
         SELECT ze03 INTO l_sta FROM ze_file WHERE ze01 = 'sub-070' AND ze02 = g_lang
      WHEN '5'
         SELECT ze03 INTO l_sta FROM ze_file WHERE ze01 = 'sub-071' AND ze02 = g_lang
      WHEN '6'
         SELECT ze03 INTO l_sta FROM ze_file WHERE ze01 = 'sub-061' AND ze02 = g_lang
      WHEN '7'
         SELECT ze03 INTO l_sta FROM ze_file WHERE ze01 = 'sub-062' AND ze02 = g_lang
      WHEN '8'
         SELECT ze03 INTO l_sta FROM ze_file WHERE ze01 = 'sub-063' AND ze02 = g_lang
      WHEN '9'
         SELECT ze03 INTO l_sta FROM ze_file WHERE ze01 = 'sub-064' AND ze02 = g_lang
      OTHERWISE LET l_sta = ' '
   END CASE
#  CASE
#   WHEN g_lang = '0'
#        CASE p_code
#             WHEN '1' LET l_sta = '開立'
#             WHEN 'X' LET l_sta = '開立'
#             WHEN '2' LET l_sta = '託收'
#             WHEN '3' LET l_sta = '質押'
#             WHEN '4' LET l_sta = '票貼'
#             WHEN '5' LET l_sta = '轉付'
#             WHEN '6' LET l_sta = '撤票'
#             WHEN '7' LET l_sta = '退票'
#             WHEN '8' LET l_sta = '兌現'
#             WHEN '9' LET l_sta = '作廢'
#             OTHERWISE LET l_sta = ' '
#        END CASE
#   WHEN g_lang = '2'
#        CASE p_code
#             WHEN '1' LET l_sta = '開立'
#             WHEN 'X' LET l_sta = '開立'
#             WHEN '2' LET l_sta = '託收'
#             WHEN '3' LET l_sta = '質押'
#             WHEN '4' LET l_sta = '票貼'
#             WHEN '5' LET l_sta = '轉付'
#             WHEN '6' LET l_sta = '撤票'
#             WHEN '7' LET l_sta = '退票'
#             WHEN '8' LET l_sta = '兌現'
#             WHEN '9' LET l_sta = '作廢'
#             OTHERWISE LET l_sta = ' '
#        END CASE
#   OTHERWISE 
#        CASE 
#             WHEN '1' LET l_sta = 'OPEN'
#             WHEN 'X' LET l_sta = 'OPEN'
#             WHEN '2' LET l_sta = 'TAK1'
#             WHEN '3' LET l_sta = 'TAK2'
#             WHEN '4' LET l_sta = 'TAK3'
#             WHEN '5' LET l_sta = 'TRSF'
#             WHEN '6' LET l_sta = 'DRAW'
#             WHEN '7' LET l_sta = 'RETN'
#             WHEN '8' LET l_sta = 'CASH'
#             WHEN '9' LET l_sta = 'VOID'
#             OTHERWISE LET l_sta = ' '
#        END CASE
#  END CASE
   RETURN l_sta
END FUNCTION
