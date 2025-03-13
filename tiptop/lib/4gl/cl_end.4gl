# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: cl_end
# Descriptions...: 顯示 "作業結束,請按任何鍵繼續:"
# Memo...........: 
# Input parameter: p_row,p_col
# Return code....: none
# Usage..........: CALL cl_end(p_row,p_col)
# Date & Author..: 90/02/02 By LYS
# Modify.........: No.FUN-690005 06/09/04 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"
 
FUNCTION cl_end(p_row,p_col)
   DEFINE l_chr		LIKE type_file.chr1,   #No.FUN-690005  VARCHAR(1)
          p_row,p_col	LIKE type_file.num5    #No.FUN-690005  SMALLINT
   DEFINE g_i           LIKE type_file.num5,   #No.FUN-690005  SMALLINT
          g_ans         LIKE type_file.chr20,  #No.FUN-690005  VARCHAR(10),
          l_msg         LIKE type_file.chr1000,#No.FUN-690005  VARCHAR(55),
          ls_msg        LIKE ze_file.ze03,     #No.FUN-690005  VARCHAR(100),
          lc_title      LIKE ze_file.ze03      #No.FUN-690005  VARCHAR(50)
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   SELECT ze03 INTO ls_msg FROM ze_file WHERE ze01 = 'lib-026' AND ze02 = g_lang
   SELECT ze03 INTO lc_title FROM ze_file WHERE ze01 = 'lib-041' AND ze02 = g_lang
 
   MENU lc_title ATTRIBUTE (STYLE="dialog", COMMENT=ls_msg CLIPPED, IMAGE="information")
      ON ACTION ok
         EXIT MENU
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE MENU
   END MENU
   
   IF INT_FLAG THEN
      LET INT_FLAG = 0
   END IF
  
END FUNCTION
