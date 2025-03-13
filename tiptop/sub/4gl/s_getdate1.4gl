# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_getdate1.4gl
# Descriptions...: 推算某一日期推算前置前間的工作日
# Date & Author..: 90/12/13 By Lee
# Usage..........: CALL s_getdate1(p_date,p_offset) RETURNIGN l_date
# Input Parameter: p_date     起始工作日
#                  p_offset   工作期間
# Return code....: l_date     新工作日
# Memo...........: When date
#                  1.out of array range
#                  2.can't find in array
#                  use Julain date operaion algorithm to compute date
# Modify.........: No.FUN-680147 06/09/01 By Czl  類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
FUNCTION s_getdate1(p_date,p_offset)
DEFINE
    p_date    LIKE type_file.dat,          #No.FUN-680147 DATE
    p_offset  LIKE ima_file.ima62,         #No.FUN-680147 DECIMAL(9,3)
    l_int     LIKE type_file.num5,         #No.FUN-680147 SMALLINT
    l_offset  LIKE type_file.num5,         #No.FUN-680147 SMALLINT
    l_total   LIKE type_file.num10,        #No.FUN-680147 INTEGER
    l_i       LIKE type_file.num5          #No.FUN-680147 SMALLINT
 
 
    WHENEVER ERROR CALL cl_err_msg_log
	IF p_offset=0 THEN RETURN p_date END IF
	#換算成整數天, 若不足一天, 則以一天計算
	IF p_offset > 0 THEN
		LET l_int=p_offset+0.999
	ELSE
		LET l_int=p_offset-0.999
	END IF
    IF p_date < g_mind OR p_date > g_maxd THEN #out of range
		RETURN (p_date+l_int)
	END IF
	LET l_offset=p_date-g_mind
	FOR l_i=l_offset TO 1 STEP -1 #get start date in array
		IF p_date = g_work[l_i] THEN
			EXIT FOR
		END IF
	END FOR
	IF (l_i<=1 AND p_date != g_mind) OR
		(l_i+l_int<1 OR l_i+l_int >l_total) THEN #can't find
		LET p_date=p_date+l_int
	ELSE
		LET p_date=g_work[l_i+l_int] #find out date with offset
	END IF
	RETURN p_date
END FUNCTION
