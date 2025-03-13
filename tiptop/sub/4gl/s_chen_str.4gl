# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: s_chen_str.4gl
# Descriptions...: * ---> %
# Date & Author..: 04/10/19 By ching MOD-4A0259 
# Usage..........: CALL s_chen_str(p_str) RETURNING p_str
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds    #FUN-7C0053
 
#No.7657 ADD FOR ORACLE
FUNCTION s_chen_str(p_str)
   DEFINE     p_str       LIKE type_file.chr1000,       #No.FUN-680147 VARCHAR(3000)
              l_str       LIKE type_file.chr1000,       #No.FUN-680147 VARCHAR(3000)
              l_buf       LIKE type_file.chr1000,       #No.FUN-680147 VARCHAR(3000)
              l_i         LIKE type_file.num5,          #No.FUN-680147 SMALLINT
              l_j         LIKE type_file.num5           #No.FUN-680147 SMALLINT
              
   WHENEVER ERROR CONTINUE
   LET INT_FLAG = 0
   LET l_buf   = p_str CLIPPED
   LET l_j = length(p_str)
   FOR l_i = 1 TO l_j
       #====>'*'變成'%'
       IF l_buf[l_i,l_i] = '*' THEN 
           LET l_buf[l_i,l_i] = '%'
       END IF
       #====>'?'變成'_'
       IF l_buf[l_i,l_i] = '?' THEN 
           LET l_buf[l_i,l_i] = '_'
       END IF
   END FOR
   LET l_str = l_buf CLIPPED
   RETURN l_str
END FUNCTION
