# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: cl_digcut
# Descriptions...: 將數值依指定的小數位數做四捨五入.
# Memo...........: 
# Input parameter: p_value	數值
#                  p_digit	允許小數位數
# Return code....: p_value	四捨五入後的數值
# Usage..........: LET a = cl_digcut(p_value,p_digit)
# Date & Author..: 91/06/11 By LYS
# Modify.........: 2005/01/12 By CoCo p_digit from 8 to 10
# Modify.........: No.MOD-590093 05/09/22 By Echo 1.即使資料長度超過欄位寬度也不會出現星號,而是往後擠
#                                                 2.欄位最大寬度為29
# Modify.........: No.FUN-690005 06/09/04 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.CHI-690007 06/12/05 By kim 當p_digit 為 null 時,讓他為0
 
DATABASE ds 
 
FUNCTION cl_digcut(p_value,p_digit)
   DEFINE p_value       LIKE type_file.num26_10, #No.FUN-690005 DECIMAL(26,10),     #MOD-590093
          p_digit	LIKE type_file.num5      #No.FUN-690005 SMALLINT
 
   WHENEVER ERROR CALL cl_err_msg_log
   IF p_digit IS NULL THEN LET p_digit=0 END IF #CHI-690007
 
   #MOD-590093
   CASE
        WHEN p_digit = 10 LET p_value = p_value USING '--,---,---,---,---,---.----------'
        WHEN p_digit = 9 LET p_value = p_value USING '--,---,---,---,---,---.---------'
        WHEN p_digit = 8 LET p_value = p_value USING '--,---,---,---,---,---.--------'
        WHEN p_digit = 7 LET p_value = p_value USING '--,---,---,---,---,---.-------'
        WHEN p_digit = 6 LET p_value = p_value USING '--,---,---,---,---,---.------'
        WHEN p_digit = 5 LET p_value = p_value USING '--,---,---,---,---,---.-----'
        WHEN p_digit = 4 LET p_value = p_value USING '--,---,---,---,---,---.----'
        WHEN p_digit = 3 LET p_value = p_value USING '--,---,---,---,---,---.---'
        WHEN p_digit = 2 LET p_value = p_value USING '--,---,---,---,---,---.--'
        WHEN p_digit = 1 LET p_value = p_value USING '--,---,---,---,---,---.-'
        WHEN p_digit = 0 LET p_value = p_value USING '--,---,---,---,---,--&'
   END CASE
   #END MOD-590093
   RETURN p_value
END FUNCTION
