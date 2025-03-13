# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Program name...: s_wkday3.4gl
# Descriptions...: 檢查輸入的日期往前推算其前置期間其正確工作日
# Date & Author..: 92/04/28  By Apple
# Usage..........: CALL s_wkday3(p_date,p_offset) RETURNING l_date
# Input Parameter: p_date    日期
#                  p_offset  正值
# Return Code....: p_wdate   working date
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
FUNCTION s_wkday3(p_date,p_offset)
   DEFINE  p_date     LIKE type_file.dat,     	#No.FUN-680147 DATE
           p_offset   LIKE type_file.num20_6,   #LIKE cqh_file.cqh071,     #No.FUN-680147 DECIMAL(8,4)   #TQC-B90211
           l_int      LIKE type_file.num10,  	#No.FUN-680147 INTEGER
           p_wdate    LIKE type_file.dat    	#No.FUN-680147 DATE
 
  WHENEVER ERROR CALL cl_err_msg_log
    LET p_wdate = p_date
    IF p_offset is null THEN RETURN p_wdate END IF
    IF p_offset >0 THEN LET p_offset = p_offset * -1 END IF
	LET l_int=p_offset-0.999
    DECLARE s_ddd CURSOR FOR
        SELECT sme01 FROM sme_file
        WHERE sme02 IN ('Y','y') AND sme01 <p_date
     ORDER BY sme01 DESC
 
    FOREACH s_ddd INTO p_wdate 
        IF SQLCA.sqlcode THEN EXIT FOREACH END IF
        LET l_int = l_int + 1
        IF l_int = 0 THEN EXIT FOREACH END IF
    END FOREACH
    #行事曆不足
    IF l_int !=0 THEN  LET p_wdate = p_date - p_offset END IF
    RETURN p_wdate
END FUNCTION
