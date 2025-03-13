# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: artt726.4gl
# Descriptions...: 
# Date & Author..: FUN-9B0025 09/11/11 By Cockroach
# Modify.........: FUN-9B0025 09/12/09 By cockroach PASS NO.
DATABASE ds

GLOBALS "../../config/top.global"

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   CALL t726('1')   
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
#FUN-9B0025
