# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: cl_dummy
# Descriptions...: Dummy
# Memo...........: 
# Input parameter: none
# Return code....: none
# Usage..........: CALL cl_dummy()
# Date & Author..: 89/09/04 By LYS
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
 
DATABASE ds        #FUN-6C0017
 
FUNCTION cl_dummy()
   WHENEVER ERROR CALL cl_err_msg_log
END FUNCTION
