# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_nmd14.4gl
# Descriptions...: 將[應付票據資料檔]的寄領方式碼轉換成寄領方式
# Date & Author..: 92/05/02 Modify By Jones
# Usage..........: CALL s_nmd14(p_code) RETURNING l_sta
# Input Parameter: p_code  寄領方式碼      
# Return code....: l_sta   寄領方式            
# Memo...........: 英文版時,請將l_sta的長度加長變成(C20),及畫面上的
#                  欄位長度亦同時修改之。
# Modify.........: No.MOD-630042 06/03/13 By Smapmin 調整訊息
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_nmd14(p_code)
   DEFINE  p_code   LIKE type_file.chr1,       #No.FUN-680147 VARCHAR(01)
           l_sta    LIKE ze_file.ze03          #No.FUN-680147 VARCHAR(10)
   LET l_sta = " "
   IF cl_null(p_code) OR p_code IS NULL THEN RETURN l_sta END IF
 
   CASE p_code
      WHEN '1' 
         SELECT ze03 INTO l_sta FROM ze_file WHERE ze01 = 'sub-065' AND ze02 = g_lang
      WHEN '2'
         SELECT ze03 INTO l_sta FROM ze_file WHERE ze01 = 'sub-066' AND ze02 = g_lang   #MOD-630042
      WHEN '3'
         SELECT ze03 INTO l_sta FROM ze_file WHERE ze01 = 'sub-067' AND ze02 = g_lang   #MOD-630042
      OTHERWISE
         SELECT ze03 INTO l_sta FROM ze_file WHERE ze01 = 'sub-067' AND ze02 = g_lang   #MOD-630042
   END CASE
#  CASE
#   WHEN g_lang = '0'
#        CASE p_code
#          WHEN '1' LET l_sta='寄出'    
#          WHEN '2' LET l_sta='自領'
#          WHEN '3' LET l_sta='其它'
#        END CASE
#   WHEN g_lang = '2'
#        CASE p_code
#          WHEN '1' LET l_sta='寄出'    
#          WHEN '2' LET l_sta='自領'
#          WHEN '3' LET l_sta='其它'
#        END CASE
#   OTHERWISE
#        CASE p_code
#          WHEN '1' LET l_sta='Mail'    
#          WHEN '2' LET l_sta='Take away'
#          WHEN '3' LET l_sta='Other'
#       END CASE
#  END CASE
   RETURN l_sta
END FUNCTION
