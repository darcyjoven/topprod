# Prog. Version..: '5.30.08-13.07.05(00000)'     #
#               
# Pattern name...: asfp301.4gl  
# Descriptions...: 整批工單產生作業
# Date & Author..: NO.FUN-D50098 13/06/03 BY lixh1

IMPORT os   
DATABASE ds

GLOBALS "../../config/top.global"

MAIN 
   DEFINE
        p_argv1 LIKE sfb_file.sfb01,
        p_argv2 LIKE sfb_file.sfb81,
        p_argv3 LIKE sfb_file.sfb42,
        p_argv4 LIKE type_file.chr1,         
        p_trans LIKE type_file.num5 

   OPTIONS
      INPUT NO WRAP,
      FIELD ORDER FORM
   DEFER INTERRUPT

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time    
   
   LET p_argv1 = ARG_VAL(1)
   LET p_argv2 = ARG_VAL(2)
   LET p_argv3 = ARG_VAL(3)
   LET p_argv4 = ARG_VAL(4)
   LET p_trans = ARG_VAL(5)
   IF cl_null(p_trans) THEN
      LET p_trans = FALSE
   END IF
   CALL p301(p_argv1, p_argv2, p_argv3, p_argv4, p_trans)
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN        
#FUN-D50098
