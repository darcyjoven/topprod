# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: cl_parse
# Descriptions...: 將 MATCHES '[xyz]' 的指令 轉成 ORACLE 的 IN ('x','y','z')
# Input parameter: p_type
# RETURN code....: l_str
# Date & Author..: 01/06/04 By Kammy
# Modify.........: No.FUN-690005 06/09/14 By chen 類型轉換
DATABASE ds  #No.FUN-690005
FUNCTION cl_parse(p_type)
   DEFINE p_type        LIKE type_file.chr1000,        #No.FUN-690005 VARCHAR(1000)
          l_str         LIKE type_file.chr1000,        #No.FUN-690005 VARCHAR(1000)
          l_length,i    LIKE type_file.num10           #No.FUN-690005 INTEGER
 
   WHENEVER ERROR CALL cl_err_msg_log
   LET l_length = LENGTH(p_type)
   LET l_str = "("
   FOR i = 1 TO l_length
       LET l_str = l_str CLIPPED,"'",p_type[i,i],"'"
       IF i <> l_length THEN
          LET l_str = l_str CLIPPED,","
       END IF
   END FOR
   LET l_str = l_str CLIPPED,")"
   RETURN l_str
 
END FUNCTION
