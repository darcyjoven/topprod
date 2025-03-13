# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: aglp0031.4gl
# Descriptions...: 期末結轉作業(總帳) (整批資料處理作業)
# Date & Author..: 11/07/01 By lixiang (No.FUN-B60144)

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
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 

   CALL aglp003('2')      
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

#FUN-B60144--
