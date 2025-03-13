# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: cl_days
# Descriptions...: 取得該年月的天數
# Memo...........: 
# Input parameter: p_year   年份
#                  p_month  月份
# Return code....: l_days   天數
# Usage..........: LET l_days = cl_days(p_yy,p_mm)
# Date & Author..: 91/12/21 By Lee
# Modify.........: No.FUN-690005 06/09/04 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.TQC-7B0145 07/11/29 By alexstar  潤年判定修改
DATABASE ds
 
FUNCTION cl_days(p_year,p_month)
DEFINE
	p_year  LIKE type_file.num5,       #No.FUN-690005 SMALLINT
	p_month LIKE type_file.num5,       #No.FUN-690005 SMALLINT
	l_days  LIKE type_file.num5,       #No.FUN-690005 SMALLINT
	i,j	LIKE type_file.num5        #No.FUN-690005 SMALLINT
 
	WHENEVER ERROR CALL cl_err_msg_log
 
	#大小月口訣如下:
	#一月大, 二月小, 三月大, 四月小, 五月大 , 六月小, 七月大,
	#八月大, 九月小, 十月大, 十一月小, 十二月大
 
	LET l_days=0
	#大月有三十一天
	IF p_month=1 OR p_month=3 OR p_month=5
		OR p_month=7 OR p_month=8 OR p_month=10 OR p_month=12
	THEN
		LET l_days=31
	END IF
 
	#小月有三十天
	IF p_month=4 OR p_month=6 OR p_month=9 OR p_month=11
	THEN
		LET l_days=30
	END IF
 
	#二月雖然是小月, 但要判斷是否潤年
	IF p_month=2 THEN
           LET l_days=28
          #LET i = (p_year-1)/4
          #LET j = i * 4
          #IF (p_year-1) = j THEN
          #    LET l_days=29
          #END IF
           #--- 潤年可 與 100 及 4 整除
          #IF p_year mod 100 = 0  AND p_year mod 4 = 0 THEN  #TQC-7B0145 mark
          #   LET l_days=29
          #END IF
           IF p_year mod 100 = 0 THEN     #TQC-7B0145 
              IF p_year mod 400 = 0 THEN
                 LET l_days = 29 
              END IF
           ELSE
              IF p_year mod 4 = 0 THEN 
                 LET l_days = 29 
              END IF
           END IF
 
	END IF
 
	RETURN l_days
END FUNCTION
