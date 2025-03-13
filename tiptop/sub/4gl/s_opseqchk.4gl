# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_opseqchk.4gl
# Descriptions...: 檢查主製程作業序號是否存在
# Date & Author..: 90/12/18 By Wu   
# Usage..........: IF s_opseqchk(p_item,p_seq)
# Input Parameter: p_item   料件編號
#                  p_seq    作業順序
# Return code....: 1:YES  0:NO
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
FUNCTION s_opseqchk(p_item,p_seq) 
    DEFINE p_item  LIKE ecb_file.ecb01,
           p_seq   LIKE ecb_file.ecb02,
           l_flag  LIKE type_file.chr1          #No.FUN-680147 VARCHAR(1)
 
    SELECT UNIQUE ecb03 FROM ecb_file 
                        WHERE  ecb01 = p_item AND 
                               ecb02 = 1      AND
                               ecb03 = p_seq 
 
    IF SQLCA.sqlcode THEN 
       CALL cl_err(p_seq,'mfg0036',0)
       RETURN 0 
    ELSE RETURN 1
    END IF
END FUNCTION
