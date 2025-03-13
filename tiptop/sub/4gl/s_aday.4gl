# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Program name...: s_addy.4gl
# Descriptions...: 推算日期, 但跳過非工作日
# Date & Author..: 03/05/07  By Jiunn
# Usage..........: CALL s_aday(p_date,p_op,p_offset) RETURNING l_date
# Input Parameter: p_date  日期
#                  p_op    1:往後推算
#                         -1:往前推算
#                  p_offset       天數,無條件進位
# Return Code....: p_wdate        working date
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No:MOD-B30217 11/03/15 By Pengu 當行事曆不足時，應判斷p_op正負決定是往後加或是往前減
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_aday(p_date,p_op,p_offset)
  DEFINE p_date     LIKE type_file.dat,    	#No.FUN-680147 DATE
         p_op       LIKE type_file.num5,   	#No.FUN-680147 DEC(1,0)
         p_offset   LIKE con_file.con06, 	#No.FUN-680147 DECIMAL(8,4)
         l_int      LIKE type_file.num10,  	#No.FUN-680147 INTEGER
         p_wdate    LIKE type_file.dat,    	#No.FUN-680147 DATE
         l_work     LIKE sme_file.sme02,        #No.FUN-680147 VARCHAR(1)
         l_sql      LIKE type_file.chr1000	#No.FUN-680147 VARCHAR(200)
 
  WHENEVER ERROR CALL cl_err_msg_log
  LET p_wdate = p_date
  IF (cl_null(p_offset) OR p_offset = 0) THEN
    IF p_op > 0 THEN
      LET l_sql = "SELECT sme01,sme02 FROM sme_file",
                  " WHERE sme01 >= '",p_date,"'",
                  " ORDER BY sme01"
    ELSE
      LET l_sql = "SELECT sme01,sme02 FROM sme_file",
                  " WHERE sme01 <= '",p_date,"'",
                  " ORDER BY sme01 DESC"
    END IF
    PREPARE s_sme_p0 FROM l_sql
    DECLARE s_sem_c0 CURSOR FOR s_sme_p0
    FOREACH s_sem_c0 INTO p_wdate, l_work
      IF SQLCA.sqlcode THEN EXIT FOREACH END IF
      IF l_work MATCHES '[Yy]' THEN EXIT FOREACH END IF
    END FOREACH
    RETURN p_wdate
  ELSE
    IF (p_offset*p_op) > 0 THEN
      LET l_int=(p_offset*p_op)+0.999
      LET l_sql = "SELECT sme01,sme02 FROM sme_file",
                  " WHERE sme01 > '",p_date,"'",
                  " ORDER BY sme01"
      LET l_int = l_int * -1
    ELSE
      LET l_int=(p_offset*p_op)-0.999
      LET l_sql = "SELECT sme01,sme02 FROM sme_file",
                  " WHERE sme01 < '",p_date,"'",
                  " ORDER BY sme01 DESC"
    END IF
    PREPARE s_sme_p FROM l_sql
    DECLARE s_sem_c CURSOR FOR s_sme_p
    FOREACH s_sem_c INTO p_wdate, l_work
      IF SQLCA.sqlcode THEN EXIT FOREACH END IF
      IF l_work MATCHES '[Yy]' THEN LET l_int = l_int + 1 END IF
      IF l_int = 0 THEN EXIT FOREACH END IF
    END FOREACH
    #行事曆不足
   #----------------No:MOD-B30217 modify
   #IF l_int !=0 THEN LET p_wdate = p_date - p_offset END IF
    IF l_int !=0 THEN 
       IF p_op > 0 THEN
         LET p_wdate = p_date + p_offset
       ELSE
         LET p_wdate = p_date - p_offset 
       END IF
    END IF
   #----------------No:MOD-B30217 end
    RETURN p_wdate
  END IF
END FUNCTION
