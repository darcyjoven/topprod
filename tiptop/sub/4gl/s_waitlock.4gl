# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: s_waitlock.4gl
# Descriptions...: Waitting Lock
# Date & Author..: 92/12/26 By  Pin
# Usage..........: IF s_waitlock(p_name)
# Input Parameter: p_name  Table Name
# Return Code....: 1       Lock fail
#                  0       OK
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.CHI-950007 09/05/15 By Carrier EXECUTE后接prepare_id,非cursor_id
 
DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
FUNCTION s_waitlock(s_name)
DEFINE
      s_name  LIKE type_file.chr20,     #No.FUN-680147 VARCHAR(10)
      s_sql   LIKE type_file.chr1000	#No.FUN-680147 VARCHAR(1000)
 
    WHENEVER ERROR CALL cl_err_msg_log
        BEGIN WORK
           
           LET s_sql='LOCK TABLE ',s_name, ' IN SHARE MODE' 
           #No.CHI-950007  --Begin
           PREPARE x_per  FROM s_sql
#          DECLARE x_p CURSOR FOR x_per         
           EXECUTE x_per
           #No.CHI-950007  --End  
          IF SQLCA.sqlcode 
             THEN COMMIT WORK RETURN 1
             ELSE COMMIT WORK RETURN 0
          END IF
END FUNCTION
