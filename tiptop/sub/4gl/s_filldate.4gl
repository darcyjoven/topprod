# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_filldate.4gl
# Descriptions...: 將工作日期填入陣列中以加速計算
# Date & Author..: 
# Usage..........: CALL s_filldate()
# Input Parameter: none
# Return code....: none
# Memo...........: 1.陣列大小為500個
#                  2.工作日期以今天往前推30個工作日, 其餘往後推
#                  to speed up date calculation, let's put work date 
#                  in an 500 array
# Modify.........: No.FUN-680147 06/09/01 By Czl  類型轉換
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_filldate()
DEFINE
    l_date  LIKE type_file.dat,          #No.FUN-680147 DATE
    l_total LIKE type_file.num5,         #No.FUN-680147 SMALLINT
    l_i     LIKE type_file.num5          #No.FUN-680147 SMALLINT
 
    LET l_date=g_today-30
    DECLARE s_ddd CURSOR FOR
        SELECT sme01 FROM sme_file
        WHERE sme02='Y' AND sme01 >=l_date
    LET l_i=1
    FOREACH s_ddd INTO g_work[l_i] 
        IF SQLCA.sqlcode THEN EXIT FOREACH END IF
        LET l_i=l_i+1
        IF l_i > 500 THEN EXIT FOREACH END IF
    END FOREACH
    LET l_total=l_i-1 #total filled array number
    IF l_total > 0 THEN
        LET g_mind=g_work[1]
        LET g_maxd=g_work[l_total]
    END IF
END FUNCTION
