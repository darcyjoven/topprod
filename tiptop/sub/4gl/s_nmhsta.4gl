# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_nmhsta.4gl
# Descriptions...: 將應收票據狀況碼轉換為狀況說明
# Date & Author..: 92/05/20 BY MAY 
# Usage..........: CALL s_nmhsta(p_code) RETURNING l_sta
# Input Parameter: p_code  狀況碼
# Return code....: l_sta   狀況說明
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds      #No.FUN-680147 
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_nmhsta(p_code)
   DEFINE  
           p_code   LIKE type_file.chr1,          #No.FUN-680147 VARCHAR(01)
           l_string LIKE type_file.chr1000,       #No.FUN-680147 VARCHAR(90)
           l_n      LIKE type_file.num5,          #No.FUN-680147 SMALLINT
           l_sta    LIKE ze_file.ze03             #No.FUN-680147 VARCHAR(6)
   LET l_sta = " "
   IF cl_null(p_code) THEN RETURN  l_sta END IF
   IF p_code NOT MATCHES '[12345678]' OR p_code IS NULL OR p_code = ' ' THEN
	  RETURN l_sta
   END IF
 
   CASE p_code
      WHEN '1'
         SELECT ze03 INTO l_sta FROM ze_file WHERE ze01 = 'sub-072' AND ze02 = g_lang
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
#         WHEN '1' LET l_sta = '未異動'
#         WHEN '2' LET l_sta = '託收'
#         WHEN '3' LET l_sta = '質押'
#         WHEN '4' LET l_sta = '票貼'
#         WHEN '5' LET l_sta = '轉付'
#         WHEN '6' LET l_sta = '撤票'
#         WHEN '7' LET l_sta = '退票'
#         WHEN '8' LET l_sta = '兌現'
#         OTHERWISE LET l_sta = ' '
#        END CASE
#   WHEN g_lang = '2'
#        CASE p_code
#         WHEN '1' LET l_sta = '未異動'
#         WHEN '2' LET l_sta = '託收'
#         WHEN '3' LET l_sta = '質押'
#         WHEN '4' LET l_sta = '票貼'
#         WHEN '5' LET l_sta = '轉付'
#         WHEN '6' LET l_sta = '撤票'
#         WHEN '7' LET l_sta = '退票'
#         WHEN '8' LET l_sta = '兌現'
#         OTHERWISE LET l_sta = ' '
#        END CASE
#   OTHERWISE
#        CASE 
#         WHEN '1' LET l_sta = 'None'
#         WHEN '2' LET l_sta = 'Dis'
#         WHEN '3' LET l_sta = 'SUB'
#         WHEN '4' LET l_sta = 'Over'
#         WHEN '5' LET l_sta = 'Pay'
#         WHEN '6' LET l_sta = 'Draw'
#         WHEN '7' LET l_sta = 'Return'
#         WHEN '8' LET l_sta = 'Cash'
#         OTHERWISE LET l_sta = ' '
#        END CASE
#  END CASE
   RETURN l_sta
END FUNCTION
