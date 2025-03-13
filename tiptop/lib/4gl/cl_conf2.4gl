# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: cl_conf2
# Private Func...: TRUE
# Descriptions...: 根據 MESSAGE CODE 篩選輸入值 
#                  "是否......(1/2/3/4):", 注意訊息不可超過 60 Byte
# Memo...........: 
# Input parameter: p_row,p_col,p_msgcode,p_velue
# Return code....: TRUE/FALSE
# Usage..........: IF cl_conf2(p_row,p_col,p_msgcode) THEN
# Date & Author..: 92/10/13 By Roger
# Modify.........: No.FUN-690005 06/09/04 By cheunl  欄位型態定義，改為LIKE
# Modify.........: NO.TQC-6A0073 06/10/25 BY yiting 型態錯誤
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"
 
#GLOBALS
#   DEFINE g_lang VARCHAR(1)
#END GLOBALS
 
FUNCTION cl_conf2(p_row,p_col,p_msgcode,p_value)
   DEFINE l_ret,l_chr	  LIKE type_file.chr1,         #No.FUN-690005 VARCHAR(1)
          p_row,p_col,l	  LIKE type_file.num5,         #No.FUN-690005 SMALLINT
          p_msgcode	  LIKE ze_file.ze01,           #No.FUN-690005 VARCHAR(8)
	  p_value         LIKE cre_file.cre08,         #No.FUN-690005 VARCHAR(10)
	  l_l,l_i         LIKE type_file.num5,         #No.FUN-690005 SMALLINT
          #l_msg,l_msg2   LIKE ze_file.ze01            #No.FUN-690005 VARCHAR(60)
          l_msg,l_msg2 	  LIKE ze_file.ze03            #No.TQC-6A0073
 
   WHENEVER ERROR CALL cl_err_msg_log
	LET INT_FLAG=0
	LET l_l=LENGTH(p_value)
   LET l_msg =''
   LET l_msg2=''
   SELECT ze03 INTO l_msg FROM ze_file WHERE ze01=p_msgcode AND ze02=g_lang
   LET l = LENGTH(l_msg)
   LET l = (60 - l) / 2
	IF l<=0 THEN LET l=1 END IF
   LET l_msg2[l,60] = l_msg
   IF p_row = 0 THEN LET p_row = 20 END IF
   IF p_col = 0 THEN LET p_col = 10 END IF
#--genero
#  OPEN WINDOW cl_conf_w AT p_row,p_col WITH 1 ROWS, 62 COLUMNS
#                        ATTRIBUTE (BORDER)
   WHILE TRUE
      PROMPT l_msg2 CLIPPED FOR CHAR l_chr
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
##           CONTINUE PROMPT
      
      END PROMPT
      IF INT_FLAG THEN LET INT_FLAG = 0 LET l_chr = "" END IF
		LET l_ret=''
		LET l_chr=UPSHIFT(l_chr)
		FOR l_i=1 TO l_l		
			IF l_chr=p_value[l_i,l_i] THEN LET l_ret=l_chr EXIT FOR END IF
		END FOR
		IF l_ret IS NOT NULL AND l_ret!=' ' THEN EXIT WHILE END IF
   END WHILE
#CLOSE WINDOW cl_conf_w
 	RETURN l_ret 
END FUNCTION
