# Prog. Version..: '5.30.06-13.03.12(00001)'     #
# Pattern name...: arti001.4gl
# Descriptions...: Design price tag  
# Date & Author..: FUN-A30113 2010/03/31 by David Lee

#No.FUN-A30113
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

  IF (NOT cl_setup("ART")) THEN
    EXIT PROGRAM
  END IF

  CALL cl_used(g_prog,g_time,1) RETURNING g_time

  IF NOT p_pricetag_open() THEN END IF

  CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
#No.FUN-A30113
