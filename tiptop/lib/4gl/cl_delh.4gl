# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: cl_delh
# Descriptions...: 詢問 "是否確定刪除此筆單頭及所有單身資料(Y/N):"
#                  (for 單檔建檔程式單頭取消功能)
# Memo...........: 
# Input parameter: p_row,p_col
# Return code....: TRUE/FALSE
# Usage..........: IF cl_delh(p_row,p_col) THEN
# Date & Author..: 89/10/17 By LYS
# Modify.........: 04/02/17 By saki
# Modify.........: No.FUN-690005 06/09/04 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"
	
FUNCTION cl_delh(p_row,p_col)
   DEFINE   ls_msg        LIKE ze_file.ze03       #No.FUN-690005 VARCHAR(100)
   DEFINE   ls_title      LIKE ze_file.ze03       #No.FUN-690005 VARCHAR(50)
   DEFINE   li_result     LIKE type_file.num5     #No.FUN-690005 SMALLINT
   DEFINE   p_row,p_col   LIKE type_file.num5     #No.FUN-690005 SMALLINT
 
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   SELECT ze03 INTO ls_msg FROM ze_file WHERE ze01 = 'lib-008' AND ze02 = g_lang
   SELECT ze03 INTO ls_title FROM ze_file WHERE ze01 = 'lib-039' AND ze02 = g_lang
 
   MENU ls_title ATTRIBUTE (STYLE="dialog", COMMENT=ls_msg CLIPPED, IMAGE="question")
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
