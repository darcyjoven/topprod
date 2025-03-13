# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: cl_cmdret
# Descriptions...: 自 zz_file 讀取該程式的UNIX執行指令, 並呼叫UNIX執行之
#                  本作業和cmdrun不同之處在於執行完後, 可以透過g_chr
#                  來判斷上一個指令執行的結果
# Memo...........: 
# Input parameter: p_cmd    執行指令(ex: aooi020 'X2045' 'Y')
# Return code....: none
# Usage..........: CALL cl_cmdret(p_cmd)
# Date & Author..: 91/05/30 By LYS
# Modify.........: No.FUN-690005 06/09/04 By cheunl  欄位型態定義，改為LIKE 
# Modify.........: No.FUN-7C0045 07/12/14 By alex 修改說明 
 
DATABASE ds
 
GLOBALS "../../config/top.global"  #FUN-7C0045
 
GLOBALS
DEFINE
	g_chr LIKE type_file.chr1          #No.FUN-690005  VARCHAR(1)
END GLOBALS
 
FUNCTION cl_cmdret(p_cmd)
DEFINE
	p_cmd 	   LIKE type_file.chr1000,  # Ex: aooi020 'A009' 'Y'        #No.FUN-690005  VARCHAR(200)
	p_code 	   LIKE zz_file.zz01,       #No.FUN-690005 VARCHAR(10)
	l_cmd 	   LIKE zz_file.zz08,       # Ex: fglgo $AOM/4go/aooi020 'A009' 'Y'    #No.FUN-690005 VARCHAR(200)
	l_i 	   LIKE type_file.num5,     #No.FUN-690005 SMALLINT
        ls_msg     LIKE ze_file.ze01,       #No.FUN-690005 VARCHAR(100)
        ls_title   LIKE ze_file.ze01        #No.FUN-690005 VARCHAR(50)
 
	WHENEVER ERROR CALL cl_err_msg_log
	FOR l_i = 1 TO 20
		IF p_cmd[l_i,l_i] = ' ' OR p_cmd[l_i,l_i] IS NULL THEN EXIT FOR END IF
	END FOR
	LET p_code = p_cmd[1,l_i]
	SELECT zz08 INTO l_cmd FROM zz_file
		WHERE zz01 = p_code
 
        SELECT ze03 INTO ls_msg FROM ze_file WHERE ze01 = 'lib-020' AND ze02 = g_lang
        SELECT ze03 INTO ls_title FROM ze_file WHERE ze01 = 'lib-041' AND ze02 = g_lang
 
	IF SQLCA.sqlcode THEN
           MENU ls_title ATTRIBUTE (STYLE="dialog", COMMENT=ls_msg CLIPPED, IMAGE="question")
              ON ACTION ok
                 EXIT MENU
              ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                 CONTINUE MENU
           END MENU
#          ERROR "No such command ! "
	ELSE
		LET l_cmd = l_cmd CLIPPED,p_cmd[l_i,200]
		RUN l_cmd
	END IF
	RETURN g_chr
END FUNCTION
