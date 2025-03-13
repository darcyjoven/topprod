# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: s_getima.4gl
# Descriptions...: 取得該料件之數量/單位
# Date & Author..: 92/09/15 By Pin
# Usage..........: CALL s_getima(p_item) RETURNING l_ima262,l_ima25,l_ima55,l_ima86
# Input Parameter: p_item    欲檢查之料件
# Return code....: p_ima262  該料件之可用量
#                  p_ima25   庫存單位
#                  p_ima55   生產單位
#                  p_ima86   成本單位
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26*
 
DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
FUNCTION s_getima(p_item)
DEFINE
    p_item  LIKE img_file.img01, #料件
#    p_ima262 LIKE ima_file.ima262, #FUN-A20044
    p_avl_stk LIKE type_file.num15_3, #FUN-A20044
    p_avl_stk_mpsmrp LIKE type_file.num15_3, #FUN-A20044
    p_unavl_stk LIKE type_file.num15_3, #FUN-A20044 
    p_ima25  LIKE ima_file.ima25,
    p_ima55  LIKE ima_file.ima55 ,
    p_ima86  LIKE ima_file.ima86
 
#        SELECT  ima262,ima25,ima55,ima86  INTO p_ima262,p_ima25,p_ima55,p_ima86 #FUN-A20044
        SELECT ima25,ima55,ima86  INTO p_ima25,p_ima55,p_ima86 #FUN-A20044
            FROM ima_file
            WHERE ima01=p_item
        CALL s_getstock(p_item,g_plant) RETURNING p_avl_stk_mpsmrp,p_unavl_stk,p_avl_stk #FUN-A20044
		IF SQLCA.sqlcode 
#		   THEN LET p_ima262=0 #FUN-A20044
		   THEN LET p_avl_stk=0 #FUN-A20044
                LET p_ima25=''
                LET p_ima55=''
                LET p_ima86=''
		END IF 
#   RETURN  p_ima262,p_ima25,p_ima55,p_ima86 #FUN-A20044
   RETURN  p_avl_stk,p_ima25,p_ima55,p_ima86 #FUN-A20044
END FUNCTION
