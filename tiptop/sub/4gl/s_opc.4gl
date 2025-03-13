# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_opc.4gl
# Descriptions...: 將[料件基本資料]的補貨策略碼轉換成說明
# Date & Author..: 92/02/26 By Lin
# Usage..........: CALL s_opc(p_code) RETURNING l_sta
# Input Parameter: p_code    補貨策略碼 
# Return code....: l_sta     補貨策略碼說明
# Memo...........: 英文版時,請將l_sta的長度加長變成(C20),及畫面上的
#                  欄位長度亦同時修改之。
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_opc(p_code)
   DEFINE  p_code   LIKE type_file.chr1,          #No.FUN-680147 VARCHAR(01)
           l_sta    LIKE ze_file.ze03             #No.FUN-680147 VARCHAR(10)
   LET l_sta = " "
   IF cl_null(p_code) OR p_code IS NULL THEN RETURN l_sta END IF
 
   CASE p_code
     WHEN '0'
        SELECT ze03 INTO l_sta FROM ze_file WHERE ze01 = "sub-073" AND ze02 = g_lang
     WHEN '1'
        SELECT ze03 INTO l_sta FROM ze_file WHERE ze01 = "sub-074" AND ze02 = g_lang
     WHEN '2'
        SELECT ze03 INTO l_sta FROM ze_file WHERE ze01 = "sub-075" AND ze02 = g_lang
     WHEN '3'
        SELECT ze03 INTO l_sta FROM ze_file WHERE ze01 = "sub-076" AND ze02 = g_lang
     WHEN '4'
        SELECT ze03 INTO l_sta FROM ze_file WHERE ze01 = "sub-077" AND ze02 = g_lang
     WHEN '5'
        SELECT ze03 INTO l_sta FROM ze_file WHERE ze01 = "sub-078" AND ze02 = g_lang
   END CASE
 
#  CASE 
#    WHEN g_lang = '0'
#         CASE p_code
#           WHEN '0' LET l_sta='再訂購點'
#           WHEN '1' LET l_sta='MPS'
#           WHEN '2' LET l_sta='MRP'
#           WHEN '3' LET l_sta='FAS'
#           WHEN '4' LET l_sta='訂單式生產'
#           WHEN '5' LET l_sta='期間採購'
#         END CASE
#    WHEN g_lang = '2'
#         CASE p_code
#           WHEN '0' LET l_sta='再訂購點'
#           WHEN '1' LET l_sta='MPS'
#           WHEN '2' LET l_sta='MRP'
#           WHEN '3' LET l_sta='FAS'
#           WHEN '4' LET l_sta='訂單式生產'
#           WHEN '5' LET l_sta='期間採購'
#         END CASE
#    OTHERWISE
#         CASE p_code
#           WHEN '0' LET l_sta='Reorder point parts'
#           WHEN '1' LET l_sta='MPS parts'
#           WHEN '2' LET l_sta='MRP parts'
#           WHEN '3' LET l_sta='FAS parts'
#           WHEN '4' LET l_sta='On-order parts'
#           WHEN '5' LET l_sta='Fixed interval parts'
#         END CASE
#  END CASE
   RETURN l_sta
END FUNCTION
