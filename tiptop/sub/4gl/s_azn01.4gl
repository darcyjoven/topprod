# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: s_azn01.4gl
# Descriptions...: 取得該年度該期之起始日期/截止日期
# Date & Author..: 92/11/23 By  Pin
# Usage..........: CALL s_azn01(p_year,p_month) RETURNING l_bdate,l_edate
# Input PARAMETER: p_year   會計年度
#                  p_month  期別
# RETURN Code....: l_bdate  起始日期
#                  l_edate  截止日期
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_azn01(l_year,l_month)
DEFINE
    l_year,l_month  LIKE type_file.num5   , 	#No.FUN-680147 SMALLINT
    b_date,e_date   LIKE type_file.dat,    	#No.FUN-680147 DATE
    l_azm  RECORD LIKE azm_file.*
 
    WHENEVER ERROR CALL cl_err_msg_log
 
{
    SELECT min(azn01),max(azn01) 
        INTO b_date,e_date
        FROM azn_file
        WHERE azn02=l_year   #年度
          AND azn04=l_month
}
    SELECT * INTO l_azm.*
      FROM azm_file
     WHERE azm01=l_year
 
    CASE l_month
       WHEN  1 LET b_date=l_azm.azm011 LET e_date=l_azm.azm012
       WHEN  2 LET b_date=l_azm.azm021 LET e_date=l_azm.azm022
       WHEN  3 LET b_date=l_azm.azm031 LET e_date=l_azm.azm032
       WHEN  4 LET b_date=l_azm.azm041 LET e_date=l_azm.azm042
       WHEN  5 LET b_date=l_azm.azm051 LET e_date=l_azm.azm052
       WHEN  6 LET b_date=l_azm.azm061 LET e_date=l_azm.azm062
       WHEN  7 LET b_date=l_azm.azm071 LET e_date=l_azm.azm072
       WHEN  8 LET b_date=l_azm.azm081 LET e_date=l_azm.azm082
       WHEN  9 LET b_date=l_azm.azm091 LET e_date=l_azm.azm092
       WHEN 10 LET b_date=l_azm.azm101 LET e_date=l_azm.azm102
       WHEN 11 LET b_date=l_azm.azm111 LET e_date=l_azm.azm112
       WHEN 12 LET b_date=l_azm.azm121 LET e_date=l_azm.azm122
       WHEN 13 LET b_date=l_azm.azm131 LET e_date=l_azm.azm132
    END CASE
    
      IF b_date IS NULL OR b_date=' ' THEN LET b_date='01/01/01' END IF
      IF e_date IS NULL OR e_date=' ' THEN LET e_date='01/01/01' END IF
 
    RETURN b_date,e_date 
END FUNCTION
