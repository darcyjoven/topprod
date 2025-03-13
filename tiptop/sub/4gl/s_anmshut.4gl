# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_anmshut.4gl
# Descriptions...: 判斷目前系統是否可使用
# Date & Author..: 92/04/10 By May
# Usage..........: IF NOT s_anmshut()
# Input Parameter: NONE
# Return code....: 1  YES
#                  0  NO
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_anmshut(p_pause)
DEFINE
    p_pause LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
    l_nmz01 LIKE nmz_file.nmz01         #No.FUN-680147 VARCHAR(1)
 
    WHENEVER ERROR CALL cl_err_msg_log
    SELECT nmz01 INTO l_nmz01 FROM nmz_file WHERE nmz00='0'
    IF l_nmz01='N' THEN
        CALL cl_err('','9037',p_pause)
        RETURN 1
    END IF
    RETURN 0
END FUNCTION
