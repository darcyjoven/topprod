# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: cl_chkym
# Descriptions...: 檢查文字型態變數是否為年月型態
# Memo...........: Check YYMM
# Input parameter: p_str   文字型態變數
# Return code....: TRUE/FALSE
# Usage..........: IF cl_chkym(p_str) THEN
# Date & Author..: 90/04/26 By LYS
# Modify.........: No.FUN-690005 06/09/04 By cheunl  欄位型態定義，改為LIKE
 
DATABASE ds
 
FUNCTION cl_chkym(p_str)
   DEFINE   p_str   LIKE type_file.chr6,  #No.FUN-690005 VARCHAR(6)
            yy	    LIKE type_file.chr4,  #No.FUN-690005 VARCHAR(4)
            mm	    LIKE type_file.chr2   #No.FUN-690005 VARCHAR(2)
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   LET yy = p_str[1,4]
   LET mm = p_str[5,6]
 
   IF yy < '00' OR yy > '9999'
      THEN RETURN 0
   END IF
   IF mm < '01' OR mm > '12'
      THEN RETURN 0
   END IF
   RETURN 1
END FUNCTION
