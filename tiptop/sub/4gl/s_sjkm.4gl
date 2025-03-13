# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_sjkm.4gl
# Descriptions...: 追溯上級科目名稱且將其連成一體
# Date & Author..: FUN-6C0012 06/12/12 By elva
# Usage..........: CALL s_sjkm(p_aag01) RETURNING l_aag13  
# Input Parameter: p_aag01  科目名稱
# Return code....: l_aag13  追溯上級科目名稱且將其連成一體
# Modify.........: No.FUN-730020 07/03/13 By Carrier 會計科目加帳套
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_sjkm(p_aag00,p_aag01)   #No.FUN-730020
   DEFINE p_aag00 LIKE aag_file.aag00  #No.FUN-730020
   DEFINE p_aag01 LIKE aag_file.aag01
   DEFINE s_aag08 LIKE aag_file.aag08
   DEFINE s_aag24 LIKE aag_file.aag24
   DEFINE s_aag02 LIKE aag_file.aag02
   DEFINE l_aag02,l_aag021    LIKE type_file.chr1000
   DEFINE l_aag13 LIKE aag_file.aag13
   DEFINE l_success,l_i       LIKE type_file.num5  
   
   LET l_success = 1
   LET l_i = 1
   WHILE l_success
      SELECT aag02,aag08,aag24 INTO s_aag02,s_aag08,s_aag24 FROM aag_file
       WHERE aag01 = p_aag01
         AND aag00 = p_aag00   #No.FUN-730020
      IF SQLCA.sqlcode THEN
         LET l_success = 0
         EXIT WHILE
      END IF
      IF l_i = 1 THEN
         LET l_aag02 = s_aag02
      ELSE
         LET l_aag021 = l_aag02
         LET l_aag02 = s_aag02 CLIPPED,'-',l_aag021 CLIPPED
      END IF
      LET l_i = l_i + 1
      IF s_aag24 = 1 OR s_aag08 = p_aag01 THEN LET l_success = 1 EXIT WHILE END IF
      LET p_aag01 = s_aag08
   END WHILE
   LET l_aag13 = l_aag02[1,60]
   RETURN l_aag13   #結果
END FUNCTION
#FUN-6C0012 -End
