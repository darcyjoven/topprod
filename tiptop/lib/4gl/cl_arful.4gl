# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: cl_arful
# Descriptions...: 詢問是否因buffer size too small 要繼續執行 
# Memo...........:
# Input parameter: p_row,p_col
#                  p_arrno : 陣列的數目
# Return code....: 1 FOR TRUE  : 是
#                  0 FOR FALSE : 否
# Usage..........: IF cl_arful(p_row,p_col)
# Date & Author..: 89/10/17 By LYS
# Modify.........: No.MOD-4C0141 04/12/27 ching 取消中文寫死
# Modify.........: No.FUN-690005 06/09/04 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"
 
FUNCTION cl_arful(p_row,p_col,p_arrno)
   DEFINE l_chr		LIKE type_file.chr1,         #No.FUN-690005   VARCHAR(1)
          l_msg		LIKE ze_file.ze03    ,       #No.FUN-690005   VARCHAR(200)
          p_arrno       LIKE type_file.num5,         #No.FUN-690005   SMALLINT
          p_row,p_col	LIKE type_file.num5          #No.FUN-690005   SMALLINT
 
   WHENEVER ERROR CALL cl_err_msg_log
   IF p_row = 0
      THEN LET p_row = 10 LET p_col = 20
   END IF
   WHILE TRUE
     CALL cl_getmsg('lib-222',g_lang)
     RETURNING l_msg
      PROMPT l_msg FOR CHAR l_chr
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
      END PROMPT
      IF l_chr NOT MATCHES'[12]' THEN CONTINUE WHILE END IF
      IF INT_FLAG THEN LET INT_FLAG = 0 LET l_chr = "2" END IF
      IF l_chr MATCHES "[1]" THEN RETURN 1 END IF
      IF l_chr MATCHES "[2]" THEN RETURN 0 END IF
   END WHILE
  
END FUNCTION
