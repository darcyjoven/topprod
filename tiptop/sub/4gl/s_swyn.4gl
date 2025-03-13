# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_swyn.4gl
# Descriptions...: 檢查是否為可用倉
# Date & Author..: 92/05/23 By  Pin
# Usage..........: CALL s_swyn(p_ware) RETURNING l_flag1,l_flag2
# Input Parameter: p_ware  倉庫號碼
# Return code....: flag1   不可用倉
#                  flag2   MPS/MRP 不可用
# Modify ........: 92/07/14 By Jones
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_swyn(p_ware)
DEFINE
    p_ware        LIKE imd_file.imd01,          #No.FUN-680147 VARCHAR(10)
    flag1,flag2   LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
    l_imd11       LIKE imd_file.imd11,
    l_imd12       LIKE imd_file.imd12
 
    LET flag1 = 0
    LET flag2 = 0
    SELECT imd11,imd12 INTO l_imd11,l_imd12 FROM imd_file
          WHERE imd01 = p_ware
	IF l_imd11 MATCHES '[Nn]' THEN LET flag1 = 1 END IF
	IF l_imd12 MATCHES '[Nn]' THEN LET flag2 = 2 END IF
    RETURN flag1,flag2
END FUNCTION
