# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: asft700_tch.4gl
# Descriptions...: 
# Date & Author..: 99/06/10 By Lilan
# Modify.........: No:FUN-A60032 10/06/10 By Lilan
# Modify.........: No.FUN-B30216 11/03/30
# Modify.........: No:FUN-B80086 11/08/09 By Lujh 模組程序撰寫規範修正

DATABASE ds

#FUN-B30216

GLOBALS "../../config/top.global"

MAIN
   DEFINE l_time            LIKE type_file.chr8       #VARCHAR(8)
   DEFINE p_argv2           CHAR(1)

   IF FGL_GETENV("FGLGUI") <> "0" THEN 
      OPTIONS                           
          INPUT NO WRAP,                
          FIELD ORDER FORM               
   END IF
   DEFER INTERRUPT

   LET p_argv2 = ARG_VAL(1)              
  #LET p_argv2 = 1

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF

  # CALL cl_used(g_prog,l_time,1)                           #FUN-B80086   MARK
  # RETURNING l_time                                        #FUN-B80086   MARK
   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #FUN-B80086   ADD
   
   IF p_argv2 = '1' THEN
      CALL cl_cmdrun('asft700_tch1')
   ELSE
      CALL cl_cmdrun('asft700_tch2')
   END IF

  # CALL cl_used(g_prog,l_time,2)                           #FUN-B80086   MARK
  # RETURNING l_time                                        #FUN-B80086   MARK
   CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80086   ADD
END MAIN
