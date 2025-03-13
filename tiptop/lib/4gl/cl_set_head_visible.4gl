# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: cl_set_head_visible.4gl
# Descriptions...: 動態顯現/隱藏畫面上的單頭元件.
# Date & Author..: 2006/09/04 by saki
# Usage..........: CALL cl_set_head_visible("folder01,folder02","AUTO")
# Modify.........: No.FUN-6C0017 06/12/14 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds        #FUN-6C0017   #FUN-7C0053
 
GLOBALS "../../config/top.global"
 
 
# Descriptions...: 顯現/隱藏畫面上的單頭元件.
# Date & Author..: 2006/09/04 by saki
# Input Parameter: ps_comps   STRING 要顯現/隱藏元件的欄位名稱字串(中間以逗點分隔)
#                  ps_visible STRING 是否顯現(YES→顯現,NO→隱藏,AUTO→自動判斷)
# Return Code....: void
# Memo...........: 如果畫面隱藏的元件是folder01,folder02...folder10,ps_comps可不傳
 
FUNCTION cl_set_head_visible(ps_comps,ps_visible)
   DEFINE   ps_comps   STRING
   DEFINE   ps_visible   STRING
 
   IF cl_null(ps_comps) THEN
     LET ps_comps = "folder01,folder02,folder03,folder04,folder05,
                     folder06,folder07,folder08,folder09,folder10"
   END IF
 
   CASE
      WHEN UPSHIFT(ps_visible) = "YES"
         CALL cl_set_comp_visible(ps_comps,TRUE)
         LET g_head_disable = FALSE
      WHEN UPSHIFT(ps_visible) = "NO"
         CALL cl_set_comp_visible(ps_comps,FALSE)
         LET g_head_disable = TRUE
      WHEN UPSHIFT(ps_visible) = "AUTO"
         IF NOT g_head_disable THEN
            CALL cl_set_comp_visible(ps_comps,FALSE)
            LET g_head_disable = TRUE
         ELSE
            CALL cl_set_comp_visible(ps_comps,TRUE)
            LET g_head_disable = FALSE
         END IF
   END CASE
END FUNCTION
