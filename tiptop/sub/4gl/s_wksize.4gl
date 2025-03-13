# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: s_wksize.4gl
# Descriptions...: 計算某個區間的工作日天數
# Date & Author..: 92/03/04 By Lin
# Usage..........: CALL s_wksize(p_fdate,p_edate) RETURNING l_flag,l_n
# Input Parameter: p_fdate  起始日期
#                  p_edate  截止日期
# Return Code....: l_flag   0:正確 1:錯誤
#                  l_n      工作日天數
# Modify.........: NO.FUN-670091 06/08/02 BY rainy cl_err->cl_err3
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_wksize(p_fdate,p_edate)
   DEFINE  p_fdate     LIKE type_file.dat,     	#No.FUN-680147 DATE
           p_edate     LIKE type_file.dat,     	#No.FUN-680147 DATE
           l_flag      LIKE type_file.num5   , 	#No.FUN-680147 SMALLINT
           l_n         LIKE type_file.num5    	#No.FUN-680147 SMALLINT
 
     LET l_n  = 0
     LET l_flag  = 0
     SELECT COUNT(*) INTO l_n
#       FROM sme_file WHERE sme01 >= p_fdate AND sme01 <= p_edate
       FROM sme_file WHERE sme01 between p_fdate AND p_edate
			AND sme02 IN ('Y','y')
     IF SQLCA.sqlcode != 0 THEN  
        #CALL cl_err('cannot select sme_file',SQLCA.sqlcode,0)   #FUN-670091
         CALL cl_err3("sel","sme_file","","",STATUS,"","cannot select sme_file",0) #FUN-670091 
        LET l_flag = 1
     END IF
     RETURN l_flag,l_n
END FUNCTION
