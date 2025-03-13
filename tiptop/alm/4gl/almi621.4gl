# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: almi621.4gl
# Descriptions...: 卡密碼設置作業
# Date & Author..: NO.FUN-CA0103 12/10/25 By xumeimei

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
  
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   CALL si621_set('1','2',NULL,NULL,'1',FALSE)
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
#FUN-CA0103
