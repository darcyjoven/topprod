# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Descriptions...: cl_wcsub(p_str): 1.TEXT     mode:p_str中用"取代'
#                                   2.GUI/WEB  mode:p_str中用'取代"
# Input Parameter: none
# Return Code....: none
# Usage .........: call cl_wcsub()
# Date & Author..: 89/11/02 By Roger
# Modify.........: No.FUN-690005 06/09/01 By hongmei 欄位類型轉換
 
DATABASE ds
 
 
FUNCTION cl_wcsub(p_str)
DEFINE p_str          LIKE type_file.chr1000,       #No.FUN-690005 VARCHAR(1000),
       l_chr1,l_chr2  LIKE type_file.chr1,          #No.FUN-690005 VARCHAR(01)
       l_str          LIKE type_file.chr1000,       #No.FUN-690005 VARCHAR(1000),
       l_i,l_j        LIKE type_file.num5           #No.FUN-690005 SMALLINT
 
   LET l_chr1="'"
   LET l_chr2='"'
 
   FOR l_i=1 TO 1000
       IF p_str[l_i,l_i]=l_chr1
          THEN
          LET l_str[l_i,l_i]=l_chr2
       ELSE
          LET l_str[l_i,l_i]=p_str[l_i,l_i]
       END IF
   END FOR
   RETURN l_str
END FUNCTION
 
