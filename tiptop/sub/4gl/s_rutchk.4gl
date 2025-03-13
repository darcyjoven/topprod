# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_rutchk.4gl
# Descriptions...: 檢查製程
# Date & Author..: 91/12/19 By Lee
# Usage..........: IF s_rutchk(p_part,p_rut,p_date)
# Input Parameter: p_rut   primary code
#                  p_part  part number
#                  p_date  effective date
# Return code....: 1   OK
#                  0   FAIL
# Modify.........: No.MOD-490217 04/09/10 by yiting 料號欄位使用like方式
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_rutchk(p_part,p_rut,p_date)
DEFINE
    p_part    LIKE ima_file.ima01,        #part number  #No.MOD-490217
    p_rut     LIKE ecb_file.ecb02,        #No.FUN-680147 VARCHAR(6) #primary code
    p_date    LIKE type_file.dat,         #No.FUN-680147 DATE #effective date
    l_part    LIKE ima_file.ima01,
    l_exit    LIKE type_file.num5,        #No.FUN-680147 SMALLINT
    l_cnt     LIKE type_file.num5         #No.FUN-680147 SMALLINT
 
	WHENEVER ERROR CALL cl_err_msg_log
	LET l_part=p_part
	LET l_exit=FALSE
	WHILE TRUE
		SELECT COUNT(*) INTO l_cnt FROM ecb_file
			WHERE ecb01=l_part AND ecbacti='Y' AND ecb02=p_rut
		IF l_exit THEN EXIT WHILE END IF
		IF SQLCA.sqlcode OR l_cnt IS NULL OR l_cnt=0 THEN
			LET l_exit=TRUE
			SELECT ima571 INTO l_part
				FROM ima_file
				WHERE ima01=p_part
			IF SQLCA.SQLCODE OR l_part IS NULL OR l_part=' ' THEN
				LET l_cnt=0
				EXIT WHILE
			END IF
		ELSE
			RETURN TRUE
		END IF
	END WHILE
 
	IF SQLCA.sqlcode OR l_cnt IS NULL OR l_cnt=0 THEN
        CALL cl_err(p_rut,'asf-301',0)
        RETURN FALSE
    END IF
    RETURN TRUE
END FUNCTION
