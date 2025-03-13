# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: cl_choice
# Descriptions...: 讓使用者輸入選擇
# Memo...........: 
# Input parameter: l_msg        VARCHAR(1000)     顯示訊息
# Return code....: l_choice     VARCHAR(1)        回傳選擇碼
# Usage..........: CALL cl_choice(l_msg) RETURNING g_choice
# Date & Author..: 93/02/18 By Raymon
# Modify.........: No.FUN-690005 06/09/04 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify........: No.TQC-860016 08/06/10 By saki 增加ON IDLE段
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"
 
FUNCTION cl_choice(ls_msg)
   DEFINE   ls_msg        LIKE type_file.chr1000     #No.FUN-690005 VARCHAR(100)
   DEFINE   l_choice      LIKE type_file.chr1        #No.FUN-690005 VARCHAR(1)
 
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   OPEN WINDOW cl_choice_w AT 10,10 WITH FORM "lib/42f/cl_choice"
       ATTRIBUTE(STYLE="lib")
 
   DISPLAY ls_msg TO FORMONLY.msg
 
   INPUT l_choice WITHOUT DEFAULTS
         FROM FORMONLY.choice
 
      BEFORE FIELD choice
         LET l_choice=''
 
      ON ACTION accept
         CLOSE WINDOW cl_choice_w
         RETURN l_choice
 
      ON ACTION cancel
         CLOSE WINDOW cl_choice_w
         RETURN ''
 
      #No.TQC-860016 --start--
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
      #No.TQC-860016 ---end---
 
   END INPUT
 
   CLOSE WINDOW cl_choice_w
 
   IF (INT_FLAG) THEN
      LET INT_FLAG = FALSE
      LET l_choice = ''
   END IF
 
   RETURN l_choice
  
END FUNCTION
