# Prog. Version..: '5.30.06-13.03.25(00003)'     #
# Pattern name...: aglp801.4gl
# Descriptions...: 立沖賬資料拋轉
# Date & Author..: NO.FUN-BB0124 11/12/23 By Lori
# Modify.........: NO.CHI-C90001 12/11/08 BY belle 增加科目置換參數
# Modify.........: No.CHI-CB0015 13/03/06 By apo 增加傳遞傳票編號起起迄參數 

DATABASE ds

GLOBALS "../../config/top.global"                   #FUN-BB0124

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

  IF s_aglshut(0) THEN
     CALL cl_used(g_prog,g_time,2) RETURNING g_time
     EXIT PROGRAM
  END IF

  #CALL p801_sub('','','','','','N')      #CHI-C90001 mark
  #CALL p801_sub('','','','','','N','')   #CHI-CB0015 mark   #CHI-C90001 mod
   CALL p801_sub('','','','','','N','','','')   #CHI-CB0015
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

