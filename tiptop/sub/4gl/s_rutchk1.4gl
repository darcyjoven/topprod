# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_rutchk1.4gl
# Descriptions...: 檢查製程
# Date & Author..: 91/12/19 By Lee
# Usage..........: IF s_rutchk1(p_part,p_rut,p_date)
# Input Parameter: p_rut    primary code
#                  p_part   part number
#                  p_date   effective date
# Return code....: 1   OK
#                  0   FAIL
# Modify.........: No.MOD-490217 04/09/10 by yiting 料號欄位使用like方式
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_rutchk1(p_part,p_rut,p_date)
DEFINE
     p_part like ecb_file.ecb01, #part number #No.MOD-490217
    p_rut    LIKE ecb_file.ecb02,        #No.FUN-680147 VARCHAR(6) #primary code
    p_date   LIKE type_file.dat,         #No.FUN-680147 DATE #effective date
    l_cnt    LIKE type_file.num5         #No.FUN-680147 SMALLINT
 
    WHENEVER ERROR CALL cl_err_msg_log
    SELECT COUNT(*) INTO l_cnt FROM ecb_file
        WHERE ecb01=p_part AND ecbacti='Y'
              AND ecb02=p_rut
    IF SQLCA.sqlcode OR l_cnt IS NULL OR l_cnt=0 THEN
#       CALL cl_err(p_rut,'asf-301',0)
        RETURN 0
    END IF
    RETURN 1
END FUNCTION
