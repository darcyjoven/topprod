# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: s_fieldchk.4gl
# Descriptions...: 欄位檢查共用函式庫 (FUN-6C0006)
# Date & Author..: 07/01/05 by kim
# Modify.........: No.FUN-710037 07/01/18 By kim 
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"     #FUN-7C0053
 
#FUN-6C0006 #檢查checkbox的值是否為'YN'
FUNCTION s_chk_checkbox(p_chr)
   DEFINE p_chr LIKE type_file.chr1
   
   IF NOT cl_null(p_chr) THEN
      IF p_chr not matches '[YN]' THEN
         CALL cl_err(p_chr,'mfg1002',0)
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION
 
#FUN-710037 #檢查值是否<0
FUNCTION s_chk_minus(p_value)
   DEFINE p_value LIKE type_file.num26_10
   
   IF p_value<0 THEN
      CALL cl_err('','aim-391',1)
      RETURN FALSE
   END IF
   RETURN TRUE
END FUNCTION
