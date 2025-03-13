# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_textedit.4gl
# Descriptions...: 出現一個可供輸入的 TEXT 對話框
# Date & Author..: 03/12/04 saki  
# Input parameter: ls_text 原來的字串
# Return code....: ls_text 修改後的字串
# Usage..........: CALL s_textedit(ls_txtedit)
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
DEFINE   g_txtedit        STRING
DEFINE   g_txtedit_t      STRING
 
FUNCTION s_textedit(ls_txtedit)
 
   DEFINE ls_txtedit      STRING
 
   WHENEVER ERROR CALL cl_err_msg_log
  
   LET g_txtedit   = ls_txtedit
   LET g_txtedit_t = ls_txtedit
 
   OPEN WINDOW s_textedit_w WITH FORM "sub/42f/s_textedit"
   ATTRIBUTE(STYLE=g_win_style)
    
   CALL cl_ui_locale("s_textedit")
 
   DISPLAY g_txtedit TO txtedit
   INPUT g_txtedit WITHOUT DEFAULTS FROM txtedit
 
   IF INT_FLAG THEN 
      LET INT_FLAG = 0
      CALL cl_err('',9001,0)
      CLEAR FORM
      LET g_txtedit =  g_txtedit_t
   END IF
 
   CLOSE WINDOW s_textedit_w 
   RETURN g_txtedit
 
END FUNCTION
 
 
