# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Program name...: s_zero.4gl
# Descriptions...: 將料件立檔歸零
# Date & Author..: 92/08/28 By David
# Usage..........: CALL s_zero(p_item)
# Input Parameter: p_item	欲歸零之料件
# Return Code....: NONE
# Memo...........: 歸零欄位 ima26,ima261,ima262,ima40,ima41,ima91,ima95
# Modify.........: No.FUN-670091 06/08/02 by rainy cl_err->cl_err3
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26* 
# Modify.........: No.FUN-C30315 13/01/09 By Nina 只要程式有UPDATE ima_file 的任何一個欄位時,多加imadate=g_today

DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_zero(p_item)
DEFINE
    p_item  LIKE ima_file.ima01 
 
    WHENEVER ERROR CALL cl_err_msg_log
{ckp#1}  UPDATE ima_file
           # SET ima26  = 0,  ima261 = 0, ima262 = 0, ima40  = 0, #FUN-A20044
            SET  ima40  = 0, #FUN-A20044
                ima41  = 0,  ima91  = 0, ima95  = 0,
                imadate = g_today     #FUN-C30315 add
            WHERE ima01=p_item 
         IF SQLCA.sqlcode THEN
            LET g_success='N' 
            #CALL cl_err('(s_zero:ckp#1)',SQLCA.sqlcode,1)  #FUN-670091
            CALL cl_err3("upd","ima_file",p_item,"",SQLCA.sqlcode,"","s_zero:ckp#1",1)  #FUN-670091
            RETURN 
         END IF
 
END FUNCTION
