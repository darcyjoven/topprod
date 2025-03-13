# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: artt625.4gl
# Descriptions...: 押金返還單
# Date & Author..: FUN-870100 09/09/27 By Cockroach
# Modify.........: FUN-9B0025 09/12/09 By cockroach PASS NO.
# Modify.........: TQC-A10085 10/01/20 By cockroach 增加參數
# Modify.........: TQC-B20065 10/02/16 By elva 增加參數
# Modify.........: FUN-BB0117 11/11/24 By fanbj 將t624替換為t624
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/sartt624.global" 
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
 
   LET g_argv1= ARG_VAL(1)   #TQC-A10085 ADD
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
  #CALL t624('2',g_argv1)    #TQC-B20065
   CALL t624('2',g_argv1,'')  #TQC-B20065  #FUN-BB0117
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
#FUN-9B0025
