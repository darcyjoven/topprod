# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_monck.4gl
# Descriptions...: 調整日期為星期一
# Date & Author..: 92/09/29 By Lin
# Usage..........: CALL s_monck(p_date)	RETURNING l_date
# Input Parameter: p_date  欲調整日期
# Return code....: l_date  該週星期一
# Modify.........: No.FUN-680147 06/09/04 By chen 類型轉換 
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_monck(p_date)
    DEFINE  p_date     LIKE type_file.dat,              #No.FUN-680147 DATE
            l_tmp      LIKE type_file.num5              #No.FUN-680147 SMALLINT
 
	LET l_tmp = WEEKDAY(p_date)
	IF  l_tmp != 1 THEN
	    IF l_tmp = 0 THEN 
            LET p_date = p_date - 6
     	ELSE
            LET p_date = p_date - (l_tmp - 1)
        END IF
    END IF
    RETURN p_date
END FUNCTION
