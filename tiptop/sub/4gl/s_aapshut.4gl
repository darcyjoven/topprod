# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program Name...: s_aapshut
# Descriptions...: 判斷目前系統是否可使用
# Date & Author..: 92/05/08 By Nora
# Usage..........: IF NOT s_aapshut()
# Input Parameter: NONE
# Returning Code.: 1 YES
#                  0 No
# Revise record..:
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_aapshut(p_pause)
 
DEFINE
    p_pause LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
    l_apz01 LIKE apz_file.apz01         #No.FUN-680147 VARCHAR(1)
 
    WHENEVER ERROR CALL cl_err_msg_log
    SELECT apz01 INTO l_apz01 FROM apz_file WHERE apz00='0'
    IF l_apz01='N' THEN
        CALL cl_err('','9037',p_pause)
        RETURN 1
    END IF
    RETURN 0
END FUNCTION
