# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program Name...: s_ymtodate.4gl
# Descriptions...: 將輸入之年月轉成日期輸出
# Date & Author..: 92/12/21 By Lin
# Usage..........: CALL s_ymtodate(p_year1,p_mon1,p_year2,p_mon2)
#                       RETURNING l_bdate,l_edate
# Input PARAMETER: p_year1  起始年
#                  p_mon1   起始月
#                  p_year2  截止年
#                  p_mon2   截止月
# RETURN Code....: l_bdate  起始日期
#                  l_edate  截止日期
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_ymtodate(l_year1,l_mon1,l_year2,l_mon2)
DEFINE
    p_date      LIKE type_file.dat,    	#No.FUN-680147 DATE
    l_dat       LIKE aab_file.aab02, 	#No.FUN-680147 VARCHAR(06)
    l_bdate     LIKE type_file.dat,     #區間的起始日期 	#No.FUN-680147 DATE
    l_edate     LIKE type_file.dat,     #區間的截止日期 	#No.FUN-680147 DATE
    l_year1     LIKE type_file.num10,  	#No.FUN-680147 INTEGER
    l_mon1      LIKE type_file.num10,  	#No.FUN-680147 INTEGER
    l_year2     LIKE type_file.num10,  	#No.FUN-680147 INTEGER
    l_mon2      LIKE type_file.num10  	#No.FUN-680147 INTEGER
    
	  LET l_bdate = MDY(l_mon1,1,l_year1)
      LET l_mon2=l_mon2+1 USING "&&"
      IF l_mon2 > 12 THEN 
         LET l_mon2=1 
         LET l_year2=l_year2+1 USING "&&&&"
      END IF
      LET l_edate = MDY(l_mon2,1,l_year2) - 1
      RETURN l_bdate,l_edate
END FUNCTION
