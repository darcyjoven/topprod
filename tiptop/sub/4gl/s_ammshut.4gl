# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_ammshut.4gl
# Descriptions...: 判斷目前系統是否可使用
# Date & Author..: 92/05/08 By Nora
# Usage..........: IF NOT s_ammshut()
# Input Parameter: NONE
# Return code....: 1  YES
#                  0  NO
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_ammshut(p_pause)
DEFINE
    p_pause LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
    l_oaz01 LIKE oaz_file.oaz01         #No.FUN-680147 VARCHAR(1)
 
    WHENEVER ERROR CALL cl_err_msg_log
    SELECT oaz01 INTO l_oaz01 FROM oaz_file WHERE oaz00='0'
    IF l_oaz01='N' THEN
        CALL cl_err('','9037',p_pause)
	    RETURN 1
	ELSE
        RETURN 0
    END IF
END FUNCTION
