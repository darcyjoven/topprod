# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: apmq001.4gl
# Descriptions...: 
# Date & Author : No.FUN-C90076 12/10/27 by fengrui

DATABASE ds
 
GLOBALS "../../config/top.global"
 
MAIN
         
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT   
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   WHENEVER ERROR CALL cl_err_msg_log
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  
   CALL sapmq001('apmq001')       
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time  
END MAIN
#FUN-C90076
