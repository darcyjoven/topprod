# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: artt624.4gl
# Descriptions...: 押金收取單
# Date & Author..: FUN-870100 09/09/27 By Cockroach
# Modify.........: FUN-9B0025 09/12/09 By cockroach PASS NO.
# Modify.........: TQC-A10085 10/01/20 By cockroach 增加參數
# Modify.........: TQC-B20065 11/02/16 By elva 增加參數
# Modify.........: FUN-BB0117 11/11/24 By fanbj	,將artt624更名為artt624 

DATABASE ds
 
GLOBALS "../../config/top.global"
#GLOBALS "../4gl/sartt624.global"      # FUN-BB0117 mark
GLOBALS "../4gl/sartt624.global"        # FUN-BB0117 add

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
      
   LET g_argv1 = ARG_VAL(1)       #TQC-A10085 ADD
   LET g_argv2 = ARG_VAL(2)       #TQC-A10085 ADD
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
  #CALL t624('1',g_argv1)    #TQC-B20065
  # CALL t624('1',g_argv1,g_argv2)  #TQC-B20065   # FUN-BB0117 mark
   CALL t624('1',g_argv1,g_argv2)  #TQC-B20065    # FUN-BB0117 add
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
#FUN-9B0025
