# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_nmd12.4gl
# Descriptions...: 將[應付票據資料檔]的票況碼轉換成票況
# Date & Author..: 92/05/02 Modify By Jones
# Usage..........: CALL s_nmd12(p_code) RETURNING l_sta
# Input Parameter: p_code  票況碼      
# Return code....: l_sta   票況            
# Memo...........: 英文版時,請將l_sta的長度加長變成(C20),及畫面上的
#                  欄位長度亦同時修改之。
# Modify.........: No.MOD-5B0308 05/11/23 By kim 原票狀屬於0的未顯示中文名
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_nmd12(p_code)
   DEFINE  p_code   LIKE type_file.chr1,       #No.FUN-680147 VARCHAR(01)
           l_sta    LIKE ze_file.ze03          #No.FUN-680147 VARCHAR(10)
   LET l_sta = " "
   IF cl_null(p_code) OR p_code IS NULL THEN RETURN l_sta END IF
 
   CASE p_code
      #MOD-5B0308...............begin
      WHEN '0'
         SELECT ze03 INTO l_sta FROM ze_file WHERE ze01 = 'sub-060' AND ze02 = g_lang
      #MOD-5B0308...............end
      WHEN '1'
         SELECT ze03 INTO l_sta FROM ze_file WHERE ze01 = 'sub-060' AND ze02 = g_lang
      WHEN 'X'
         SELECT ze03 INTO l_sta FROM ze_file WHERE ze01 = 'sub-060' AND ze02 = g_lang
      WHEN '6'
         SELECT ze03 INTO l_sta FROM ze_file WHERE ze01 = 'sub-061' AND ze02 = g_lang
      WHEN '7'
         SELECT ze03 INTO l_sta FROM ze_file WHERE ze01 = 'sub-062' AND ze02 = g_lang
      WHEN '8'
         SELECT ze03 INTO l_sta FROM ze_file WHERE ze01 = 'sub-063' AND ze02 = g_lang
      WHEN '9'
         SELECT ze03 INTO l_sta FROM ze_file WHERE ze01 = 'sub-064' AND ze02 = g_lang
      OTHERWISE LET l_sta = " "
   END CASE
 
#  CASE
#    WHEN g_lang = '0'
#         CASE p_code
#           WHEN '1' LET l_sta='開立'    
#           WHEN 'X' LET l_sta='開立'    
#           WHEN '6' LET l_sta='撤票'
#           WHEN '7' LET l_sta='退票'
#           WHEN '8' LET l_sta='兌現'
#           WHEN '9' LET l_sta='作廢'        
#           OTHERWISE LET l_sta=' '
#         END CASE
#    WHEN g_lang = '2'
#         CASE p_code
#           WHEN '1' LET l_sta='開立'    
#           WHEN 'X' LET l_sta='開立'    
#           WHEN '6' LET l_sta='撤票'
#           WHEN '7' LET l_sta='退票'
#           WHEN '8' LET l_sta='兌現'
#           WHEN '9' LET l_sta='作廢'        
#           OTHERWISE LET l_sta=' '
#         END CASE
#    OTHERWISE
#         CASE p_code
#           WHEN '1' LET l_sta='Open'    
#           WHEN 'X' LET l_sta='Open'    
#           WHEN '6' LET l_sta='Withdraw'
#           WHEN '7' LET l_sta='Return'
#           WHEN '8' LET l_sta='To Cash'
#           WHEN '9' LET l_sta='Void'        
#           OTHERWISE LET l_sta=' '
#        END CASE
#  END CASE
   RETURN l_sta
END FUNCTION
