# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_udsday.4gl
# Descriptions...: 更新目前系統使用工作日期
# Date & Author..: 90/11/19 By Sara
# Usage..........: CALL s_udsday()
# Input Parameter: NONE
# Return code....: NONE
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_udsday()
   DEFINE  l_sma30     LIKE type_file.dat,     	#No.FUN-680147 DATE
           l_sw        LIKE type_file.chr1,   	#No.FUN-680147 VARCHAR(1)
           l_day       LIKE type_file.dat    	#No.FUN-680147 DATE
 
  SELECT sma30 INTO l_sma30 FROM sma_file WHERE sma00='0'
 
  CALL s_wkday(today) RETURNING l_sw,l_day 
  IF l_sw = '0' THEN LET l_day = today END IF 
  IF l_sma30 != l_day  THEN
     UPDATE sma_file SET sma30 = l_day  WHERE sma00 = '0'
     UPDATE sma_file SET sma51 = YEAR(l_day),sma52 = MONTH(l_day) WHERE sma00 = '0' #darcy:2022/08/01 add
  END IF 
END FUNCTION
