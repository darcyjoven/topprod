# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: artt605.4gl
# Descriptions...: 商品寄存單
# Date & Author..: No:FUN-870007 09/09/21 By Zhangyajun
# Modify.........: No:FUN-9B0034 09/11/05 By Cockroach PASS NO.
# Modify.........: No:FUN-870007 09/12/09 By Cockroach PASS NO. 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
MAIN
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   CALL t600('1')   
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
#FUN-9B0034
#FUN-870007
