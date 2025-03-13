# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program Name...: s_yp.4gl
# Descriptions...: 取得會計年度與期別
# Date & Author..: 92/05/27 By  Pin
# Usage..........: CALL s_yp(p_date) RETURNING l_year,l_month
# Input Parameter: p_date  日期
# Return Code....: l_year  會計年度
#                  l_month 期別
# Memo...........: 1993/05/14(lee): 若不使用年份及期份資料時, 則假定其跟著年曆走
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_yp(p_date)
DEFINE
    p_date        LIKE type_file.dat,    	#No.FUN-680147 DATE
    l_year,l_month  LIKE type_file.num10  	#No.FUN-680147 INTEGER
 
    WHENEVER ERROR CALL cl_err_msg_log
    SELECT azn02,azn04 #取得年份及期份資料
        INTO l_year,l_month
        FROM azn_file
        WHERE azn01=p_date
	#若不設定年份及期份資料, 則使用12月為期
    IF SQLCA.sqlcode THEN
		LET l_year=YEAR(p_date)
		LET l_month=MONTH(p_date)
    END IF
    RETURN l_year,l_month
END FUNCTION
