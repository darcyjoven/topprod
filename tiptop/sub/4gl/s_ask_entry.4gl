# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_ask_entry(p_no)
# Descriptions...: 詢問是否重新產生分錄 
# Date & Author..: 04/05/12 By Kammy
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_ask_entry(p_no)
   DEFINE p_no          STRING
   DEFINE ps_msg        STRING
   DEFINE ls_sql        STRING,
          lc_msg        LIKE ze_file.ze03
   DEFINE li_result     LIKE type_file.num5   	#No.FUN-680147 SMALLINT
 
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (cl_null(g_lang)) THEN
      LET g_lang = "1"
   END IF
 
   SELECT ze03 INTO lc_msg FROM ze_file WHERE ze01='mfg8002' AND ze02=g_lang 
 
   LET ps_msg = '[ ',p_no CLIPPED,' ] ',lc_msg CLIPPED         
   
   MENU "Re-Generate Confirm" ATTRIBUTE (STYLE="dialog", COMMENT=ps_msg.trim(), IMAGE="question")
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
