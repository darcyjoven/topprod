# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: cl_show_field_help.4gl
# Descriptions...: 顯示欄位的說明文件.
# Date & Author..: 03/08/08 by Hiko
# Memo...........: 文件的存放路徑→http://{TIPTOP主機IP}/tiptop/{程式模組代號}/doc/{程式代號}/field_help/{欄位名稱}.html
#                  範例→http://10.40.40.99/tiptop/axm/doc/axmt410/field_help/oea00.html
# Usage..........: CALL cl_show_field_help()
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds        #FUN-6C0017   #FUN-7C0053
 
GLOBALS "../../config/top.global"
 
 
# Descriptions...: 顯示欄位的說明文件.
# Date & Author..: 03/08/08 by Hiko
# Input Parameter: none
# Return Code....: void
 
FUNCTION cl_show_field_help()
   DEFINE   ldoc_root       om.DomDocument,
            lnode_root      om.DomNode,
            lnode_focus     om.DomNode,         
            llst_items      om.NodeList,
            ls_focus_name   STRING
   DEFINE   ls_help_url     STRING,
            ls_program      STRING,
            ls_module       STRING
   DEFINE   ls_ie_path      STRING
 
   LET ldoc_root = ui.Interface.getDocument()
   LET lnode_root = ldoc_root.getDocumentElement()
   LET lnode_focus = ldoc_root.getElementById(lnode_root.getAttribute("focus"))
   IF (lnode_focus.getTagName() = "Table") THEN
      LET llst_items = lnode_focus.selectByTagName("TableColumn")
      LET lnode_focus = llst_items.item(lnode_focus.getAttribute("currentColumn")+1)
   END IF
   LET ls_focus_name = lnode_focus.getAttribute("colName")
   IF (ls_focus_name IS NOT NULL) THEN
      LET ls_program = g_prog CLIPPED
      LET ls_module = ls_program.subString(1,3)
      LET ls_help_url = "http://10.40.40.86/tiptop/" || ls_module || "/doc/" || ls_program || "/field_help/" || ls_focus_name || ".html" 
      LET ls_ie_path = "C:\\\\Progra~1\\\\Internet Explorer\\\\IEXPLORE.EXE"
      IF (NOT WinExec(ls_ie_path || " " || ls_help_url)) THEN
         CALL cl_err(ls_help_url, status, 0)
      END IF
   END IF 
END FUNCTION
