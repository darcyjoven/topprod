# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: s_wkday.4gl
# Descriptions...: 檢查輸入的日期是否為Working Date
# Date & Author..: 90/10/23 By  Wu
# Usage..........: CALL s_wkday(p_date)	RETURNING l_flag,l_date
# Input Parameter: p_date  日期
# Return Code....: l_flag  是否為working date
#                    0.YES 1.NO
#                  l_date  最近的working date
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_wkday(p_date)
   DEFINE  p_date     LIKE type_file.dat,     	#No.FUN-680147 DATE
           l_flag     LIKE type_file.chr1,   	#No.FUN-680147 VARCHAR(1)
           l_date     LIKE type_file.dat    	#No.FUN-680147 DATE
 
  WHENEVER ERROR CALL cl_err_msg_log
  LET l_flag = '0'
     SELECT sme01 FROM sme_file WHERE sme01 = p_date 
                                  AND sme02 IN ('Y','y') 
     IF SQLCA.sqlcode != 0
        THEN LET l_flag = '1' 
             CALL cl_err(p_date,'mfg3152',0)
             SELECT min(sme01) INTO l_date FROM sme_file 
                 WHERE sme01 > p_date AND sme02 IN ('Y','y')
             IF SQLCA.sqlcode  THEN 
                CALL cl_err(p_date,'mfg3120',1)
             END IF
#            LET l_date = p_date
#            LET l_flag='0'
        ELSE LET l_date = p_date
     END IF
     RETURN l_flag,l_date
END FUNCTION
