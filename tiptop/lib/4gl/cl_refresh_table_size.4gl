# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Modify........: No.FUN-690005 06/09/05 By chen 類型轉換
DATABASE ds                #No.FUN-690005
 
FUNCTION cl_refresh_table_size(ps_table_name, pi_size)
   DEFINE   ps_table_name   STRING,
            pi_size         LIKE type_file.num5             #No.FUN-690005  SMALLINT
   DEFINE   lwin_curr       ui.Window,
            lfrm_curr       ui.Form,
            lnode_frm       om.DomNode,
            llst_table      om.NodeList,
            li_i            LIKE type_file.num5,             #No.FUN-690005  SMALLINT
            lnode_table     om.DomNode,
            ls_table_name   STRING,
            li_find_target  LIKE type_file.num5              #No.FUN-690005  SMALLINT
 
 
   LET lwin_curr = ui.Window.getCurrent()
   LET lfrm_curr = lwin_curr.getForm()
   LET lnode_frm = lfrm_curr.getNode()
   LET llst_table = lnode_frm.selectByTagName("Table")
   FOR li_i = 1 TO llst_table.getLength()
      LET lnode_table = llst_table.item(li_i)
      LET ls_table_name = lnode_table.getAttribute("tabName")
      IF (ls_table_name.equals(ps_table_name.trim())) THEN
         LET li_find_target = TRUE
         EXIT FOR
      END IF
   END FOR
 
   IF (li_find_target) THEN
      CALL lnode_table.setAttribute("size", pi_size)
   END IF
END FUNCTION
