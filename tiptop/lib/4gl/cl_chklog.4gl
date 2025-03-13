# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: cl_chklog
# Descriptions...: 檢查資料庫是否使用 Transaction Log
# Memo...........: 
# Input parameter: none
# Return code....: TRUE/FALSE
# Usage..........: IF cl_chklog() THEN
# Date & Author..: 92/05/07 By LYS
# Modify.........: No.FUN-690005 06/09/04 By cheunl  欄位型態定義，改為LIKE
                   
DATABASE ds
 
FUNCTION cl_chklog()
   DEFINE   p_str    LIKE fan_file.fan02,   #No.FUN-690005 VARCHAR(4)
            l_zb01   LIKE zb_file.zb01
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   SELECT zb01 INTO l_zb01 FROM zb_file WHERE zb00 = '0'
 
   IF SQLCA.sqlcode OR l_zb01 != 'Y' THEN
      RETURN 1
   ELSE
      RETURN 0
   END IF
END FUNCTION
