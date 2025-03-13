# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: cl_end1
# Descriptions...: 顯示 "資料已拋轉成功,請按任何鍵繼續:"
# Memo...........: 
# Input parameter: p_row,p_col
# Return code....: none
# Usage..........: CALL cl_end1(p_row,p_col)
# Date & Author..: TQC-7B0152 2007/11/28 By Judy

DATABASE ds        

GLOBALS "../../config/top.global"

FUNCTION cl_end1(p_row,p_col)
   DEFINE l_chr		LIKE type_file.chr1,   
          p_row,p_col	LIKE type_file.num5    
   DEFINE g_i           LIKE type_file.num5,   
          g_ans         LIKE type_file.chr20,  
          l_msg         LIKE type_file.chr1000,
          ls_msg        LIKE ze_file.ze03,     
          lc_title      LIKE ze_file.ze03     

   WHENEVER ERROR CALL cl_err_msg_log

   SELECT ze03 INTO ls_msg FROM ze_file WHERE ze01 = 'lib-485' AND ze02 = g_lang #TQC-7B0152
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
