# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_minopseq.4gl
# Descriptions...: 取得最小作業序號
# Date & Author..: 
# Usage..........: CALL s_minopseq(p_item,p_op,p_date)	RETURNING l_ecb03
# Input Parameter: p_item  料件編號
#                  p_op    製程編號
#                  p_date  有效日期
# Return code....: l_ecb03  得到之最小作業序號
# Modify.........: No.FUN-680147 06/09/04 By chen 類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE DS
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_minopseq(p_item,p_op,p_date)
DEFINE
	p_item LIKE ecb_file.ecb01,		#Item
	p_op LIKE ecb_file.ecb02,		#Primary Code
	p_date LIKE type_file.dat,              #No.FUN-680147 DATE                #Effective Date
	l_part LIKE ima_file.ima01,
	l_exit LIKE type_file.num5,             #No.FUN-680147 SMALLINT
	l_ecb03 LIKE ecb_file.ecb03		#OPSEQ
 
	WHENEVER ERROR CALL cl_err_msg_log
	LET l_exit=FALSE
	LET l_part=p_item
	WHILE TRUE
		SELECT MIN(ecb03)
			INTO l_ecb03
			FROM ecb_file
			WHERE ecb01=p_item AND ecb02=p_op
		IF SQLCA.SQLCODE OR l_ecb03 IS NULL OR l_ecb03=' ' THEN
			IF NOT l_exit THEN
				LET l_exit=TRUE
				SELECT ima571 INTO l_part
					FROM ima_file
					WHERE ima01=p_item
				IF SQLCA.SQLCODE OR l_part IS NULL OR l_part=' ' THEN
					EXIT WHILE
				END IF
			ELSE
				LET l_ecb03=''
				EXIT WHILE
			END IF
		ELSE
			EXIT WHILE
		END IF
	END WHILE
	IF SQLCA.SQLCODE THEN LET l_ecb03='' END IF
	RETURN l_ecb03	
END FUNCTION
