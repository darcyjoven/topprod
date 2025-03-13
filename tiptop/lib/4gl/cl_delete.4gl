# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: cl_delete.4gl
# Descriptions...: 出現詢問 "是否刪除此筆資料 ?" 視窗
# Memo...........: 
# Input parameter: none
# Return code....: TRUE/FALSE
# Date & Author..: 2004/02/05 by Hiko
# Modify.........: No.FUN-690005 06/09/04 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-7C0045 07/12/14 By alex 修改說明
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
FUNCTION cl_delete()    #FUN-7C0045
   DEFINE   ls_msg      LIKE ze_file.ze03         #No.FUN-690005 VARCHAR(100)
   DEFINE   li_result   LIKE type_file.num5       #No.FUN-690005 SMALLINT
   DEFINE   lc_title    LIKE ze_file.ze03         #No.FUN-690005 VARCHAR(50)
 
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   SELECT ze03 INTO lc_title FROM ze_file WHERE ze01 = 'lib-043' AND ze02 = g_lang
   SELECT ze03 INTO ls_msg FROM ze_file WHERE ze01 = 'lib-001' AND ze02 = g_lang
 
   MENU lc_title ATTRIBUTE (STYLE="dialog", COMMENT=ls_msg CLIPPED, IMAGE="question")
      ON ACTION yes
         LET li_result = TRUE
         EXIT MENU
      ON ACTION no
         EXIT MENU
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE MENU
   
   END MENU
 
   IF (INT_FLAG) THEN
      LET INT_FLAG = FALSE
      LET li_result = FALSE
   END IF
 
   RETURN li_result
END FUNCTION
