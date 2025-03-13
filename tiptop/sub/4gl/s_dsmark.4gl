# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_dsmark.4gl
# Descriptions...: 依帳別帳別中公司別於顯示螢幕左上角 
# Date & Author..: 92/04/06 BY MAY
# Usage..........: CALL s_dsmark(p_bookno)
# Input Parameter: p_bookno  帳別
# Return code....: NONE
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"     #FUN-7C0053
 
GLOBALS
   DEFINE l_i     LIKE type_file.num5,          #No.FUN-680147 SMALLINT
          g_aaz69 LIKE aaz_file.aaz69           #No.FUN-680147 VARCHAR(1)
END GLOBALS
 
FUNCTION s_dsmark(p_bookno)
 
   DEFINE p_bookno  LIKE aaf_file.aaf01
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   CALL cl_call_by_s_dsmark(p_bookno)
 
END FUNCTION
 
