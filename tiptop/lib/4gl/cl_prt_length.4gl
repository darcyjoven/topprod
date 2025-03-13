# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: cl_prt_length
# Descriptions...: 詢問報表長度between 104-155 要印80 or 132 column
# Input parameter: l_msg
# RETURN code....: 1 FOR TRUE  : 是
#                  0 FOR FALSE : 否
# Usage .........: if cl_prt_length(l_msg)
# Date & Author..: 04/05/27 By CoCo
# Modify........: No.FUN-690005 06/09/05 By chen 類型轉換
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"
 
FUNCTION cl_prt_length()
   DEFINE   l_msg       LIKE type_file.chr1             #No.FUN-690005   VARCHAR(01)
          
   WHENEVER ERROR CALL cl_err_msg_log
 
   OPEN WINDOW cl_prt_length_w WITH FORM "lib/42f/cl_prt_length"
        ATTRIBUTE(STYLE="lib")
 
   CALL cl_ui_locale('cl_prt_length')
   CALL cl_set_win_title('cl_prt_length')
 
   LET l_msg=1
   DISPLAY l_msg to FORMONLY.a
   INPUT l_msg WITHOUT DEFAULTS FROM FORMONLY.a
 
     ON ACTION accept
         CALL GET_FLDBUF(FORMONLY.a) RETURNING l_msg
         EXIT INPUT
 
     ON ACTION cancel
         LET l_msg = ""
         EXIT INPUT
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
   END INPUT
 
   IF (INT_FLAG) THEN
      LET INT_FLAG = FALSE
      LET l_msg = ""
   END IF
 
   CLOSE WINDOW cl_prt_length_w
display 'l_msg=',l_msg
   RETURN l_msg
 
END FUNCTION
