# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: s_abxshut.4gl
# Descriptions...: 判斷目前系統是否可使用
# Date & Author..: 92/05/08 By Nora
# Usage..........: IF NOT s_abxshut()
# Input Parameter: NONE
# Return Code....: 1 YES
#                  0 NO
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.TQC-6A0079 06/11/6 By king 改正被誤定義為apm08類型的
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_abxshut(p_pause)
DEFINE
    p_pause LIKE type_file.num5,   	#No.FUN-680147 SMALLINT 
    l_bxa10 LIKE type_file.chr10 	#No.FUN-680147 VARCHAR(10)  #No.TQC-6A0079
 
    WHENEVER ERROR CALL cl_err_msg_log
    SELECT bxa10 INTO l_bxa10 FROM bxa_file WHERE bxa00='0'
    IF l_bxa10='N' THEN
        CALL cl_err('','9037',p_pause)
	    RETURN 1
	ELSE
        RETURN 0
    END IF
END FUNCTION
