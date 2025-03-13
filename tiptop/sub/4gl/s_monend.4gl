# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_monend.4gl
# Descriptions...: 
# Date & Author..: 
# Usage..........: 
# Input Parameter: 
# Return code....: 
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_monend(p_yy,p_mm)
   DEFINE p_yy,p_mm	LIKE type_file.num10         #No.FUN-680147 INTEGER
   DEFINE n_yy,n_mm	LIKE type_file.num10         #No.FUN-680147 INTEGER
   DEFINE ddd		LIKE type_file.dat           #No.FUN-680147 DATE
   LET n_yy=p_yy
   LET n_mm=p_mm+1
   IF n_mm>12 THEN LET n_yy=n_yy+1 LET n_mm=n_mm-12 END IF
   LET ddd=MDY(n_mm,1,n_yy)-1
   RETURN ddd
END FUNCTION
