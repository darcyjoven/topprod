# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: cl_set_doctype_format.4gl
# Descriptions...: 依照系統參數(aoos010)設定單別欄位格式
# Date & Author..: 05/06/21 by ice
# Modify.........: No.FUN-690005 06/09/05 By chen 類型轉換
# Modify.........: No.FUN-720042 07/03/02 By saki 因應4fd使用, findNode搜尋修改
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No:FUN-A70010 10/07/05 By tsai_yen 增加尋找ScrollGrid的Matrix屬性的元件
# Modify.........: No.FUN-B50102 11/05/17 By tsai_yen 函式說明
 
DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 

#FUN-B50102 函式說明
##################################################
# Descriptions...: 傳入單別欄位設定格式
# Date & Author..: 2005/05/02 By ice
# Input Parameter: ps_field       欄位名稱
# Return code....: none
# Usage..........: CALL cl_set_no_format("apyslip")
# Memo...........: 依照系統參數(aoos010)設定單別欄位格式
##################################################
FUNCTION cl_set_doctype_format(ps_field)
   DEFINE   ps_field     STRING
   DEFINE   lwin_curr    ui.Window
   DEFINE   lfrm_curr    ui.Form
   DEFINE   lnode_item   om.DomNode
   DEFINE   lnode_child  om.DomNode
   DEFINE   ls_picture   STRING              # 單別格式設定
   DEFINE   li_i         LIKE type_file.num10            #No.FUN-690005  INTEGER
   DEFINE   ls_tabname   STRING              #No.FUN-720042
 
   LET lwin_curr = ui.Window.getCurrent()
   LET lfrm_curr = lwin_curr.getForm()
   IF lfrm_curr IS NULL THEN
      RETURN
   END IF
 
   LET ls_tabname = cl_get_table_name(ps_field)    #No.FUN-720042
   LET lnode_item = lfrm_curr.findNode("FormField",ls_tabname||"."||ps_field)  #No.FUN-720042
   IF lnode_item IS NULL THEN
      LET lnode_item = lfrm_curr.findNode("TableColumn",ls_tabname||"."||ps_field) #No.FUN-720042
      IF lnode_item IS NULL THEN
         LET lnode_item = lfrm_curr.findNode("Matrix",ls_tabname||"."||ps_field) #FUN-A70010
         IF lnode_item IS NULL THEN
            RETURN
         END IF
      END IF
   END IF
 
   LET lnode_child = lnode_item.getFirstChild()
   FOR li_i = 1 TO g_doc_len
       LET ls_picture = ls_picture,"X"
   END FOR
 
   CALL lnode_child.setAttribute("picture",ls_picture)
END FUNCTION
