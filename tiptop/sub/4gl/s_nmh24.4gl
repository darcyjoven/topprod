# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_nmh24.4gl
# Descriptions...: 將[應收票據資料檔]的票況碼轉換成票況
# Date & Author..: 06/04/11 By Smapmin
# Usage..........: CALL s_nmh24(p_code) RETURNING l_sta
# Input Parameter: p_code  票況碼      
# Return code....: l_sta   票況            
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_nmh24(p_code)
   DEFINE  p_code   LIKE type_file.chr1,          #No.FUN-680147 VARCHAR(01) 
           l_sta    LIKE ze_file.ze03             #No.FUN-680147 VARCHAR(10)
   LET l_sta = " "
   IF cl_null(p_code) OR p_code IS NULL THEN RETURN l_sta END IF
 
   CASE p_code
      WHEN '1'
         SELECT ze03 INTO l_sta FROM ze_file WHERE ze01 = 'sub-072' AND ze02 = g_lang
      WHEN '2'
         SELECT ze03 INTO l_sta FROM ze_file WHERE ze01 = 'sub-151' AND ze02 = g_lang
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
      OTHERWISE LET l_sta = " "
   END CASE
 
   RETURN l_sta
END FUNCTION
