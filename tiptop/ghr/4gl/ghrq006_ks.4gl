# Prog. Version..: '5.30.03-12.09.18(00008)'     #
#
# Pattern name...: ghrq006_ks.4gl
# Descriptions...: 员工信息快速录入
# Date & Author..: 13/04/07 By yangjian 

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE p_row  LIKE  type_file.num5 
DEFINE p_col  LIKE  type_file.num5 
DEFINE g_argv1 LIKE type_file.chr100
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   LET g_argv1 = ARG_VAL(1)
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
    
    CALL sghrq006_ks(g_argv1)
    
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
