# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_delarr.4gl
# Descriptions...: 詢問 "是否確定取消此筆資料(Y/N):"
# Date & Author..: 93/05/08 By Keith
# Input Parameter: p_row,p_col
# Return code....: 1 FOR TRUE  : 是
#                  0 FOR FALSE : 否
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
FUNCTION s_delarr(p_row,p_col)
   DEFINE l_chr		LIKE type_file.chr1,         #No.FUN-680147 VARCHAR(1)
          p_row,p_col	LIKE type_file.num5          #No.FUN-680147 SMALLINT
 
   CALL cl_delete() RETURNING l_chr

   RETURN l_chr
END FUNCTION
