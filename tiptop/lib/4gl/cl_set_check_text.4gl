# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: cl_set_check_text.4gl
# Descriptions...: 設定CHECKBOX的顯示文字
# Date & Author..: 2004/06/30 by saki
# Usage..........: CALL cl_set_check_text("oea01", "新的文字標籤")
# Modify.........: No.FUN-690005 06/09/05 By chen 類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds     #No.FUN-690005    #FUN-7C0053
 
 
# Descriptions...: 設定CHECKBOX的顯示文字
# Date & Author..: 2004/06/30 by saki
# Input Parameter: ps_field   STRING   要設定的欄位名稱
#                  ps_text    STRING   要設定的TEXT
# Return Code....: void
 
FUNCTION cl_set_check_text(ps_field, ps_text)
   DEFINE   ps_field            STRING,
            ps_text             STRING
   DEFINE   lst_fields          base.StringTokenizer,
            ls_field_name       STRING  
   DEFINE   lnode_root          om.DomNode,
            llst_items          om.NodeList,
            li_i                LIKE type_file.num5,             #No.FUN-690005  SMALLINT
            lnode_item          om.DomNode,
            ls_item_name        STRING,
            lnode_item_child    om.DomNode,
            ls_item_child_tag   STRING
          
   IF (ps_field IS NULL) THEN
      RETURN
   ELSE
      LET ps_field = ps_field.toLowerCase()
   END IF
  
   LET lnode_root = ui.Interface.getRootNode()
   LET llst_items = lnode_root.selectByPath("//Form//*")    
      
   FOR li_i = 1 TO llst_items.getLength()
      LET lnode_item = llst_items.item(li_i)
      LET ls_item_name = lnode_item.getAttribute("colName")
   
      IF (ls_item_name IS NULL) THEN
         LET ls_item_name = lnode_item.getAttribute("name")
   
         IF (ls_item_name IS NULL) THEN
            CONTINUE FOR
         END IF
      END IF
   
      IF (ls_item_name.equals(ps_field)) THEN
         LET lnode_item_child = lnode_item.getFirstChild()
         LET ls_item_child_tag = lnode_item_child.getTagName()
         
         IF (ls_item_child_tag.equals("CheckBox")) THEN
            CALL lnode_item_child.setAttribute("text", ps_text)
         END IF
 
         EXIT FOR
      END IF
   END FOR
END FUNCTION
