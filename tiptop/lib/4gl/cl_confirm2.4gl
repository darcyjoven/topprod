# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: cl_confirm2.4gl
# Descriptions...: 確認畫面.
# Memo...........: 參數為兩個,適用顯示額外資料
# Input parameter: ps_msg     訊息字串或訊息代碼
#                  ps_msg2    訊息字串
# Return code....: none
# Usage..........: IF (cl_confirm2("agl-021"),'xxxx') THEN ...                                                           
# Date & Author..: 2004/10/13 by ching
# Modify.........: No.FUN-690005 06/09/04 By cheunl  欄位型態定義，改為LIKE 
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION cl_confirm2(ps_msg,ps_msg2)
   DEFINE   ps_msg          STRING
   DEFINE   ps_msg2         STRING
   DEFINE   ls_msg          LIKE type_file.chr1000       #No.FUN-690005 VARCHAR(1000)
   DEFINE   lc_msg          LIKE ze_file.ze03
   DEFINE   li_result       LIKE type_file.num5          #No.FUN-690005 SMALLINT
   DEFINE   lc_title        LIKE ze_file.ze03            #No.FUN-690005 VARCHAR(50)
 
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (cl_null(g_lang)) THEN
      LET g_lang = "1"
   END IF
   IF (cl_null(ps_msg)) THEN
      LET ps_msg = ""
   END IF
 
   SELECT ze03 INTO lc_title FROM ze_file WHERE ze01 = 'lib-042' AND ze02 = g_lang
   IF SQLCA.SQLCODE THEN
      LET lc_title = "Confirm"
   END IF
 
   LET ls_msg = ps_msg.trim()
   SELECT ze03 INTO lc_msg FROM ze_file WHERE ze01 = ls_msg AND ze02 = g_lang
   IF NOT SQLCA.SQLCODE THEN
      LET ps_msg =lc_msg CLIPPED
      LET ps_msg =ps_msg CLIPPED,ps_msg2 CLIPPED
   END IF
  
   LET li_result = FALSE
 
    LET lc_title=lc_title CLIPPED,'(',ls_msg,')' #MOD-4A0143 show ze01
 
   MENU lc_title ATTRIBUTE (STYLE="dialog", COMMENT=ps_msg.trim(), IMAGE="question")
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
