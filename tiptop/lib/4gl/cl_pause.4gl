# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: cl_pause
# Descriptions...: 告訴使用者, 按任一鍵繼續
# Input parameter: None
# RETURN code....: None
# Usage .........: if cl_pause()
# Date & Author..: 93/03/24 By Lee
#        Modify..: 04/02/17 By saki
# Revise record..:
# Modify.........: No.FUN-690005 06/09/05 By chen 類型轉換
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"
 
FUNCTION cl_pause()
   DEFINE   ls_msg      LIKE ze_file.ze03               #No.FUN-690005  VARCHAR(100)
   DEFINE   li_result   LIKE type_file.num5             #No.FUN-690005  SMALLINT
   DEFINE   lc_title    LIKE ze_file.ze03               #No.FUN-690005  VARCHAR(50)
 
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   SELECT ze03 INTO ls_msg FROM ze_file WHERE ze01 = 'lib-002' AND ze02 = g_lang
   SELECT ze03 INTO lc_title FROM ze_file WHERE ze01 = 'lib_041' AND ze02 = g_lang
 
   MENU lc_title ATTRIBUTE (STYLE="dialog", COMMENT=ls_msg CLIPPED, IMAGE="information")
      ON ACTION ok
         EXIT MENU
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE MENU
   
   END MENU
 
   IF INT_FLAG THEN LET INT_FLAG = 0 END IF
 
END FUNCTION
