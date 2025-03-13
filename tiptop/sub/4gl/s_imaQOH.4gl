# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: s_imaQOH.4gl
# Descriptions...: 取得該料件之總庫存量   
# Date & Author..: 92/05/25 By Pin
# Usage..........: LET l_qoh=s_imaQOH(p_item)
# Input Parameter: p_item  欲檢查之料件
# Return code....: l_qoh   該料件之所有QOH(可用+不可用)
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26* 
DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
FUNCTION s_imaQOH(p_item)
DEFINE
    p_item  LIKE img_file.img01, #料件
 #   l_qoh LIKE ima_file.ima262 #FUN-A20044
    l_qoh LIKE type_file.num15_3 #FUN-A20044
DEFINE l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk LIKE type_file.num15_3 #FUN-A20044
    #####FUN-A20044-----BEGIN
       # SELECT  ima261+ima262  INTO l_qoh
        #    FROM ima_file
         #   WHERE ima01=p_item
    ####FUN-A20044-----END	
      CALL s_getstock(p_item,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk #FUN-A20044
      LET l_qoh = l_unavl_stk + l_avl_stk #FUN-A20044	
          IF SQLCA.sqlcode OR l_qoh IS NULL
		   THEN LET l_qoh=0
		END IF
    RETURN l_qoh
END FUNCTION
