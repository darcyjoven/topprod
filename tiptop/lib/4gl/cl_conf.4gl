# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: cl_conf
# Private Func...: TRUE
# Descriptions...: 根據 MESSAGE CODE 取出正確訊息, 詢問類似
#                  "是否......(Y/N):", 注意訊息不可超過 60 Byte
# Memo...........: 
#                  
# Input parameter: p_row,p_col
#                  p_msgcode       訊息代碼
# Return code....: TRUE/FALSE
# Usage..........: IF cl_conf(p_row,p_col,p_msgcode) THEN
# Date & Author..: 92/10/13 By Roger
# Modify.........: No.FUN-690005 06/09/04 By cheunl  欄位型態定義，改為LIKE                                                          
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"
 
#GLOBALS
#   DEFINE g_lang VARCHAR(1)
#END GLOBALS
 
FUNCTION cl_conf(p_row,p_col,p_msgcode)
   DEFINE l_chr		LIKE type_file.chr1,         #No.FUN-690005 VARCHAR(1)
          p_row,p_col,l	LIKE type_file.num5,         #No.FUN-690005 SMALLINT
          p_msgcode	LIKE type_file.chr8,         #No.FUN-690005 VARCHAR(8)
          l_msg		LIKE ze_file.ze03            #No.FUN-690005 VARCHAR(8)
   DEFINE g_i           LIKE type_file.num5,         #No.FUN-690005 SMALLINT
          g_ans         LIKE type_file.chr20         #No.FUN-690005 VARCHAR(10)
 
   WHENEVER ERROR CALL cl_err_msg_log
   LET l_msg =''
   SELECT ze03 INTO l_msg FROM ze_file WHERE ze01=p_msgcode AND ze02=g_lang
 
   LET g_i=g_gui_type
 
  IF g_i=1 OR g_i=3  ## GUI or JAVA mode
     THEN
#    --# CALL fgl_init4js()
     --# LET g_ans=fgl_winquestion("",l_msg,"Yes","Yes|No|Cancel","question",1)
      IF g_ans='Yes'
         THEN
         RETURN 1
      ELSE
         RETURN 0
     END IF
   ELSE
 
   LET l = LENGTH(l_msg)
   LET l = (60 - l) / 2
   IF p_row = 0 THEN LET p_row = 20 END IF
   IF p_col = 0 THEN LET p_col = 10 END IF
#--genero
#  OPEN WINDOW cl_conf_w AT p_row,p_col WITH 1 ROWS, 62 COLUMNS
#                        ATTRIBUTE (BORDER)
   WHILE TRUE
      PROMPT l_msg CLIPPED FOR CHAR l_chr
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
#            CONTINUE PROMPT
      
      END PROMPT
      IF INT_FLAG THEN LET INT_FLAG = 0 LET l_chr = "N" END IF
      IF l_chr MATCHES "[Yy]" THEN RETURN 1 END IF
      IF l_chr MATCHES "[Nn]" THEN RETURN 0 END IF
   END WHILE
  END IF
  
END FUNCTION
