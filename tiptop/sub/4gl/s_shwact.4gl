# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_shwact.4gl
# Descriptions...: 顯示所要處理的帳別
# Date & Author..: 92/04/01 BY LYS
# Usage..........: CALL s_shwact(p_row,p_col,p_book)
# Input Parameter: p_row  視窗左上角x坐標
#                  p_col  視窗左上角y坐標
#                  p_book 帳別
# Return code....: NONE
# Modify.........: No.FUN-640004 06/04/05 By Tracy  賬別位數擴大到5碼 
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
FUNCTION s_shwact(p_row,p_col,p_argv1)
 
  DEFINE g_aaz69    LIKE aaz_file.aaz69,        #No.FUN-680147 VARCHAR(1)
#        p_argv1    LIKE aba_file.aba18,          #No.FUN-680147 VARCHAR(2)
         p_argv1    LIKE aaa_file.aaa01,          #No.FUN-640004
         p_row      LIKE type_file.num5,          #No.FUN-680147 SMALLINT
         p_col      LIKE type_file.num5           #No.FUN-680147 SMALLINT
 
  WHENEVER ERROR CALL cl_err_msg_log
 
  SELECT aaz69 INTO g_aaz69 FROM aaz_file
  IF g_aaz69 ='N' THEN 
     CALL cl_set_comp_visible("g_bookno",FALSE)
  ELSE
     DISPLAY p_argv1 TO g_bookno
  END IF
 
END FUNCTION
