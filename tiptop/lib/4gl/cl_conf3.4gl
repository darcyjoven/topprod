# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: cl_conf3
# Private Func...: TRUE
# Descriptions...: 根據 MESSAGE CODE 取出正確訊息, 詢問
# Memo...........: 1.配合發票的使用, 本作業允許使用者不輸入資料
# Input parameter: p_row,p_col
#                  p_msgcode    訊息代碼
# Return code....: TRUE/FALSE
# Usage..........: if cl_conf3(p_row,p_col,p_msgcode)
# Date & Author..: 92/10/13 By Roger
# Modify.........: No.FUN-690005 06/09/04 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"
 
#GLOBALS
#   DEFINE g_lang VARCHAR(1)
#END GLOBALS
 
FUNCTION cl_conf3(p_row,p_col,p_msgcode)
DEFINE
	l_ret           LIKE type_file.chr8,     #No.FUN-690005 VARCHAR(8)
	p_row,p_col,l	LIKE type_file.num5,     #No.FUN-690005 SMALLINT
	p_msgcode	LIKE ze_file.ze01,       #No.FUN-690005 VARCHAR(8)
	l_l,l_i         LIKE type_file.num5,     #No.FUN-690005 SMALLINT
	l_msg,l_msg2 	LIKE ze_file.ze03        #No.FUN-690005 VARCHAR(60)
 
	WHENEVER ERROR CALL cl_err_msg_log
	LET l_msg =''
	LET l_msg2=''
	SELECT ze03 INTO l_msg FROM ze_file WHERE ze01=p_msgcode AND ze02=g_lang
	LET l = LENGTH(l_msg)
	LET l = (60 - l) / 2
	LET l_msg2[l,60] = l_msg
	IF p_row = 0 THEN LET p_row = 20 END IF
	IF p_col = 0 THEN LET p_col = 10 END IF
#--genero
#       OPEN WINDOW cl_conf_w AT p_row,p_col WITH 1 ROWS, 62 COLUMNS
#       	ATTRIBUTE (BORDER)
	WHILE TRUE
		PROMPT l_msg2 CLIPPED FOR l_ret
		   ON IDLE g_idle_seconds
		      CALL cl_on_idle()
##	      CONTINUE PROMPT
		
		END PROMPT
		IF INT_FLAG THEN LET INT_FLAG = 0 CONTINUE WHILE END IF
#		IF l_ret IS NOT NULL AND l_ret!=' ' THEN EXIT WHILE END IF
		EXIT WHILE
	END WHILE
#CLOSE WINDOW cl_conf_w
	RETURN l_ret 
END FUNCTION
