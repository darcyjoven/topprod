# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: s_azm.4gl
# Descriptions...: 根據會計年度、期間得到其起始、截止的日期
# Date & Author..: 92/03/06 BY MAY
# Usage..........: CALL s_azm(p_year,p_mon) RETURNING l_flag,l_bdate,l_edate
# Input PARAMETER: p_year  會計年度
#                  p_mon    日期
# RETURN Code....: l_flag   成功否
#                     1   YES
#                     0   NO
#                  l_bdate  起始日期
#                  l_edate  截止日期
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_azm(p_year,p_mon)
   DEFINE  p_mon      LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
           p_year     LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
           l_flag     LIKE type_file.chr1,   	#No.FUN-680147 VARCHAR(1)
           b_date     LIKE type_file.dat,    	#No.FUN-680147 DATE
           e_date     LIKE type_file.dat    	#No.FUN-680147 DATE
 
  LET l_flag  = '0'
  WHENEVER ERROR CALL cl_err_msg_log
      CASE p_mon
        WHEN 1 SELECT azm011,azm012 INTO b_date,e_date FROM azm_file   
               WHERE azm01 = p_year
        WHEN 2 SELECT azm021,azm022 INTO b_date,e_date FROM azm_file   
               WHERE azm01 = p_year
        WHEN 3 SELECT azm031,azm032 INTO b_date,e_date FROM azm_file   
               WHERE azm01 = p_year
        WHEN 4 SELECT azm041,azm042 INTO b_date,e_date FROM azm_file   
               WHERE azm01 = p_year
        WHEN 5 SELECT azm051,azm052 INTO b_date,e_date FROM azm_file   
               WHERE azm01 = p_year
        WHEN 6 SELECT azm061,azm062 INTO b_date,e_date FROM azm_file   
               WHERE azm01 = p_year
        WHEN 7 SELECT azm071,azm072 INTO b_date,e_date FROM azm_file   
               WHERE azm01 = p_year
        WHEN 8 SELECT azm081,azm082 INTO b_date,e_date FROM azm_file   
               WHERE azm01 = p_year
        WHEN 9 SELECT azm091,azm092 INTO b_date,e_date FROM azm_file   
               WHERE azm01 = p_year
        WHEN 10 SELECT azm101,azm102 INTO b_date,e_date FROM azm_file   
               WHERE azm01 = p_year
        WHEN 11 SELECT azm111,azm112 INTO b_date,e_date FROM azm_file   
               WHERE azm01 = p_year
        WHEN 12 SELECT azm121,azm122 INTO b_date,e_date FROM azm_file   
               WHERE azm01 = p_year
        WHEN 13 SELECT azm131,azm132 INTO b_date,e_date FROM azm_file   
               WHERE azm01 = p_year
      END CASE
     IF SQLCA.sqlcode != 0 OR b_date IS NULL OR b_date = ' ' 
			  OR e_date IS NULL OR e_date = ' ' 
        THEN 
			LET l_flag = '1' 
     END IF
     RETURN l_flag,b_date,e_date
END FUNCTION
