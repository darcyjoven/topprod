# Prog. Version..: '5.30.06-13.03.12(00001)'     #
# Pattern name...: aecp110.4gl
# Descriptions...: 下製程段偵錯作業 
# Date & Author..: FUN-A50100 10/06/01 By lilingyu 

DATABASE ds   #FUN-A50100
 
GLOBALS "../../config/top.global"
GLOBALS "../../aec/4gl/aecp110.global"

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT		
 
   LET g_arg1 = ARG_VAL(1)
   LET g_arg2 = ARG_VAL(2)
   LET g_arg3 = ARG_VAL(3)
    
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AEC")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   
   CALL p110_sub()
   
   CALL cl_used(g_prog,g_time,2) RETURNING g_time   
  
END MAIN




