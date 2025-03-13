# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_recode.4gl
# Descriptions...: 詢問 "是否重新產生低階碼(Y/N):"
# Date & Author..: 92/11/10 By Keith
# Usage..........: IF s_recode(p_row,p_col)
# Input Parameter: p_row  視窗左上角x坐標
#                  p_col  視窗左上角y坐標
# Return code....: 1  YES
#                  0  NO
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_recode(p_row,p_col,p_yn)
   DEFINE l_chr		LIKE type_file.chr1,          #No.FUN-680147 VARCHAR(1)
          p_yn 		LIKE type_file.chr1,          #No.FUN-680147 VARCHAR(1)
          p_row,p_col	LIKE type_file.num5,          #No.FUN-680147 SMALLINT
          ls_msg        LIKE ze_file.ze03,            #No.FUN-680147 VARCHAR(100)
          li_result     LIKE type_file.num5           #No.FUN-680147 SMALLINT
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   SELECT ze03 INTO ls_msg FROM ze_file WHERE ze01 = 'sub-097' AND ze02 = g_lang
 
   MENU "Confirm dialog" ATTRIBUTE (STYLE="dialog", COMMENT= ls_msg CLIPPED, IMAGE = "question")
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
