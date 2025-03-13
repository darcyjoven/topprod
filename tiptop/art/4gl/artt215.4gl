# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: artt215.4gl
# Descriptions...: 
# Date & Author..: No.FUN-870006 08/10/08 By Sunyanchun能
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-960130 09/12/09 By Cockroach PASS NO.
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/sartt212.global"
 
MAIN
   OPTIONS           
       INPUT NO WRAP,
       FIELD ORDER FORM
   DEFER INTERRUPT
   
   LET g_argv2 = ARG_VAL(2)
   LET g_argv3 = ARG_VAL(3)
   LET g_argv1 = ARG_VAL(1)
   IF g_argv1 = '0' THEN LET g_argv1=' ' END IF
   IF cl_null(g_argv1) THEN LET g_argv1 = '1' END IF        
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   CALL t212('2')

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
#FUN-960130 
