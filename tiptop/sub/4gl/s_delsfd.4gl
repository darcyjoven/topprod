# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_delsfd.4gl
# Descriptions...: 詢問 "是否確定取消原有料件批號資料(Y/N):"
# Date & Author..: 92/10/15 By Keith
# Usage..........: IF s_delsfd(p_row,p_col,p_pt)
# Input Parameter: p_row  視窗左上角x坐標
#                  p_col  視窗左上角y坐標
#                  p_pt   訊息代號
# Return code....: 1  YES
#                  0  NO
# Memo...........: 預設視窗位置(17,15)
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
FUNCTION s_delsfd(p_row,p_col,p_pt)
   DEFINE l_chr		LIKE type_file.chr1,          #No.FUN-680147 VARCHAR(1)
          p_pt 		LIKE type_file.chr1,          #No.FUN-680147 VARCHAR(1)
          p_row,p_col	LIKE type_file.num5,          #No.FUN-680147 SMALLINT
          ls_msg        LIKE ze_file.ze03,            #No.FUN-680147 VARCHAR(100)
          li_result     LIKE type_file.num5           #No.FUN-680147 SMALLINT
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF cl_null(p_pt) THEN
      RETURN
   END IF
 
   CASE p_pt
      WHEN "1"
         SELECT ze03 INTO ls_msg FROM ze_file WHERE ze01 = "sub-053" AND ze02 = g_lang
      WHEN "2"
         SELECT ze03 INTO ls_msg FROM ze_file WHERE ze01 = "sub-054" AND ze02 = g_lang
      WHEN "3"
         SELECT ze03 INTO ls_msg FROM ze_file WHERE ze01 = "sub-055" AND ze02 = g_lang
   END CASE
 
   MENU "Delete dialog" ATTRIBUTE (STYLE="dialog", COMMENT = ls_msg CLIPPED, IMAGE = "question")
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
