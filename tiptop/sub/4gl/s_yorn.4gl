# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program Name...: s_yorn.4gl
# Descriptions...: 詢問 "是否............(Y/N):"
# Usage..........: IF s_yorn(p_row,p_col,p_yn)
# Input Parameter: p_row  視窗左上角x坐標
#                  p_col  視窗左上角y坐標
#                  p_yn   詢問訊息
# Return Code....: 1	YES
#                  0	NO
# Date & Author..: 92/11/10 By Keith
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
FUNCTION s_yorn(p_row,p_col,p_yn)
   DEFINE l_msg         STRING
   DEFINE l_chr		LIKE type_file.chr1,   	#No.FUN-680147 VARCHAR(1)
          p_yn 		LIKE type_file.chr1,   	#No.FUN-680147 VARCHAR(1)
          p_row,p_col	LIKE type_file.num5   	#No.FUN-680147 SMALLINT
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   CASE p_yn
        WHEN "1"    LET l_msg = 'sub-006'
        WHEN "2"    LET l_msg = 'sub-007'
        WHEN "3"    LET l_msg = 'sub-008'
        WHEN "4"    LET l_msg = 'sub-009'
   END CASE
   CALL cl_confirm(l_msg CLIPPED) RETURNING l_chr
   RETURN l_chr
END FUNCTION
