# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_version.4gl
# Descriptions...: 讀取版本中的有效日期
# Date & Author..: 92/07/31 By Apple
# Usage..........: CALL s_version(p_part,p_version) RETURNING l_bmx07,l_bmx08,l_stat
# Input Parameter: p_part     料件編號
#                  p_version  版本
# Return code....: l_bmx07    生效日期
#                  l_bmx08    失效日期
#                  l_stat     成功否 1:NO 0:YES
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_version(p_part,p_version)
 DEFINE p_part		LIKE ima_file.ima01,	 #料件編號
	p_version	LIKE ima_file.ima05,     #版本
        l_bmx07		LIKE bmx_file.bmx07,     #生效日
        l_bmx08		LIKE bmx_file.bmx08      #失效日
 
   LET l_bmx07=NULL
   LET l_bmx08=NULL
   WHENEVER ERROR CALL cl_err_msg_log            
   SELECT MAX(bmx07) INTO l_bmx07
         FROM bmz_file,bmx_file
        WHERE bmz02 = p_part AND bmz01 = bmx01
          AND bmz03 = p_version AND bmx04 <> 'X'
   SELECT MIN(bmx08) INTO l_bmx08
         FROM bmz_file,bmx_file
        WHERE bmz02 = p_part AND bmz01 = bmx01
          AND bmz03 > p_version AND bmx04 <> 'X'
   RETURN l_bmx07,l_bmx08,0
END FUNCTION
