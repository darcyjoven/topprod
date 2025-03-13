# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: s_get_cay05
# Descriptions...: 按 年/月/帐套/科目/部门/总权数/当前权数 得出比率
# Date & Author..: 09/12/22 By Carrier #No.FUN-9C0112
# Modify.........:
 
DATABASE ds
 
GLOBALS "../../config/top.global"

FUNCTION s_get_cay05(p_year,p_month,p_bookno,p_account,p_department,p_cay05)     #No.FUN-9C0112
  DEFINE p_year             LIKE cay_file.cay01
  DEFINE p_month            LIKE cay_file.cay02
  DEFINE p_bookno           LIKE cay_file.cay11
  DEFINE p_account          LIKE cay_file.cay06
  DEFINE p_department       LIKE cay_file.cay03
  DEFINE p_cay05            LIKE cay_file.cay05
  DEFINE l_tot              LIKE cay_file.cay05
  DEFINE l_rate             LIKE abb_file.abb25

  WHENEVER ERROR CONTINUE

  LET l_tot = 0
  SELECT SUM(cay05) INTO l_tot FROM cay_file  #总权数
   WHERE cay11 = p_bookno       #帐套
     AND cay01 = p_year         #年
     AND cay02 = p_month        #月
     AND cay03 = p_department   #部门
     AND cay06 = p_account      #科目
     AND cayacti = 'Y'          #有效
  IF cl_null(l_tot) THEN LET l_tot = 0 END IF

  IF cl_null(p_cay05) THEN LET p_cay05 = 0 END IF   #当前权数
  IF l_tot <> 0 THEN
     LET l_rate = p_cay05 / l_tot
  ELSE
     LET l_rate = 1
  END IF

  RETURN l_rate 

END FUNCTION
