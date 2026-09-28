# Prog. Version..: '5.30.06-13.03.12(00001)'      #
#
# Pattern name...: axct329.4gl
# Descriptions...: 结存调整分录结转作业
# Date & Author..: NO.FUN-C90002 12/09/05  BY minpp

 
DATABASE ds
GLOBALS "../../config/top.global"

#FUN-C90002 
MAIN
  DEFINE g_argv1       LIKE cdm_file.cdm00
                  
    OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
   LET g_argv1=ARG_VAL(1)     
    
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("axc")) THEN
      EXIT PROGRAM
   END IF
 
 
   CALL  cl_used(g_prog,g_time,1)       
         RETURNING g_time    
   CALL t326('2')           
   CALL  cl_used(g_prog,g_time,2)       
         RETURNING g_time    
END MAIN
