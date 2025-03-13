# Prog. Version..: '5.30.06-13.03.12(00002)'     #
# Pattern name...: apsq841.4gl
# Descriptions...: APS料件供需明細查詢
# Date & Author..: 98/04/03 By Duke   #FUN-940016
# Modify.........: No.FUN-B50050 11/05/11 By Mandy---GP5.25 追版:以上為GP5.1 的單號---
# Modify.........: No.FUN-B80053 11/08/08 By fengrui  程式撰寫規範修正

DATABASE ds

GLOBALS "../../config/top.global"

#FUN-940016  09/04/07 create by duke
MAIN
   DEFER INTERRUPT



   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APS")) THEN
      EXIT PROGRAM
   END IF
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-B80053--add--
   CALL apsq841()
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80053--add--
END MAIN
#FUN-B50050
