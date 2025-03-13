# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: cl_anykey
# Descriptions...: 顯示『請按Enter鍵繼續』視窗
# Memo...........:
# Input parameter: p_sw		Not used
# Return code....: none
# Usage..........: CALL cl_anykey()
# Date & Author..: 89/09/04 By LYS
# Modify.........: 04/02/17 By saki
# Modify.........: No.FUN-690005 06/09/04 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"
 
FUNCTION cl_anykey(p_sw)
   DEFINE   p_sw        LIKE type_file.chr1          #No.FUN-690005   VARCHAR(1)
   DEFINE   ls_msg      LIKE ze_file.ze03            #No.FUN-690005   VARCHAR(100)
   DEFINE   ls_title    LIKE type_file.chr50         #No.FUN-690005   VARCHAR(50)
   DEFINE   li_result   LIKE type_file.num5          #No.FUN-690005   SMALLINT
 
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   SELECT ze03 INTO ls_msg FROM ze_file WHERE ze01 = 'lib-002' AND ze02 = g_lang
   SELECT ze03 INTO ls_title FROM ze_file WHERE ze01 = 'lib-041' AND ze02 = g_lang
 
   MENU ls_title ATTRIBUTE (STYLE="dialog", COMMENT=ls_msg CLIPPED, IMAGE="information")
      ON ACTION ok
         EXIT MENU
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE MENU
   
   END MENU
 
   IF INT_FLAG THEN LET INT_FLAG = 0 END IF
 
END FUNCTION
