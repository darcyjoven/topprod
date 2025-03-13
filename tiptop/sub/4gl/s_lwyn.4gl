# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_lwyn.4gl
# Descriptions...: 檢查儲位是否為可用
# Date & Author..: 92/05/23 By  Pin
# Usage..........: CALL s_lwyn(p_ware,p_loc) RETURNING l_flag1,l_flag2
# Input Parameter: p_ware   倉庫號碼
#                  p_loc    儲位號碼
# Return code....: l_flag1  不可用倉
#                  l_flag2  MPS/MRP 不可用
# Modify.........: No.FUN-680147 06/09/04 By chen 類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No:FUN-D40103 13/05/10 By lixh1 增加儲位有效性檢查
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_lwyn(p_ware,p_loc)
DEFINE
    p_ware       LIKE ime_file.ime01,           #No.FUN-680147 VARCHAR(10)
    p_loc        LIKE ime_file.ime02,           #No.FUN-680147 VARCHAR(10)
    flag1,flag2  LIKE type_file.num5,           #No.FUN-680147 SMALLINT
	l_ime05      LIKE ime_file.ime05,
	l_ime06      LIKE ime_file.ime06
    IF p_loc IS NULL THEN LET p_loc=' ' END IF
 
    IF p_loc IS NULL THEN LET p_loc=' ' END IF
    SELECT ime05,ime06 INTO l_ime05,l_ime06 FROM ime_file
          WHERE ime01 = p_ware
			AND ime02 = p_loc
                        AND imeacti = 'Y'    #FUN-D40103
	 IF l_ime05 MATCHES '[Nn]' THEN LET flag1=1 END IF
	 IF l_ime06 MATCHES '[Nn]' THEN LET flag2=2 END IF
 #FUN-D40103 -----Begin------
         IF cl_null(l_ime05) THEN LET flag1=1 END IF
         IF cl_null(l_ime06) THEN LET flag2=2 END IF
 #FUN-D40103 -----End--------
	 RETURN flag1,flag2
END FUNCTION
