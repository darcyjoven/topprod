# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: aapt910.4gl
# Descriptions...: 費用分攤作業
# Date & Author..: NO.FUN-C70093 12/07/24  BY minpp

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
MAIN
  DEFINE g_argv1       LIKE aqa_file.aqa01
  DEFINE g_argv2       STRING                  
  DEFINE g_argv3       STRING                  
    OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
   LET g_argv1=ARG_VAL(1)     
   LET g_argv2=ARG_VAL(2)     
   LET g_argv3=ARG_VAL(3)    
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
 
     CALL  cl_used(g_prog,g_time,1)       
         RETURNING g_time    
   CALL t910(g_argv1,g_argv2,g_argv3)           
     CALL  cl_used(g_prog,g_time,2)       
         RETURNING g_time    
END MAIN
#FUN-C70093
