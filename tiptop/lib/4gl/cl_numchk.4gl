# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: cl_numchk
# Descriptions...: 檢查 'p_str' 是否為數值型態
# Input parameter: p_str
#                  p_len
# Return code....: IF p_str IS     NUMERIC THEN RETURN 1 (TRUE)
#                  IF p_str IS NOT NUMERIC THEN RETURN 0 (FALSE)
# Usage .........: if cl_numchk(p_str,p_len)
# Date & Author..: 89/09/04 By LYS
# Modify........: No.FUN-690005 06/09/25 By cheunl 欄位定義類型轉換
#
DATABASE ds
 
FUNCTION cl_numchk(p_str,p_len)
   DEFINE p_str    	LIKE type_file.chr50,   #No.FUN-690005 VARCHAR(40),
          p_len		LIKE type_file.num5,    #No.FUN-690005 SMALLINT,
          l_i   	LIKE type_file.num5     #No.FUN-690005 SMALLINT
 
   IF p_len = 0
      THEN LET p_len = LENGTH(p_str)
   END IF
   FOR l_i = 1 TO p_len
       IF p_str[l_i,l_i] NOT MATCHES "[0123456789]"
          THEN RETURN 0
       END IF
   END FOR
   RETURN 1
END FUNCTION
