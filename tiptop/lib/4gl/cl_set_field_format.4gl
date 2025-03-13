# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: cl_set_field_format.4gl
# Descriptions...: 設定元件的format(金額,日期)
# Date & Author..: 03/12/10 by saki
# Memo...........: 可以設定format的元件有EDIT,BUTTONEDIT,LABEL.
# Usage..........: CALL cl_set_field_format("oea01,oea04", "###,###.##")
#                  CALL cl_set_field_format("oea01,oea04", "mm/dd/yy")
# Modify.........: No.FUN-690005 06/09/05 By chen 類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No;CHI-A60022 10/06/15 By saki 針對目前的畫面檔作設定
 
DATABASE ds   #No.FUN-690005   #FUN-7C0053
 
 
# Descriptions...: 設定元件的format
# Date & Author..: 2003/12/10 by saki
# Input Parameter: ps_fields   STRING   欄位名稱字串(中間以逗點分隔)
#                  pi_format   STRING   要設定的format字串
# Return Code....: void
 
FUNCTION cl_set_field_format(ps_fields, ps_format)
   DEFINE   ps_fields           STRING,
            ps_format           STRING
   DEFINE   lst_fields          base.StringTokenizer,
            ls_field_name       STRING  
   DEFINE   lnode_root          om.DomNode,
            llst_items          om.NodeList,
            li_i                LIKE type_file.num5,             #No.FUN-690005  SMALLINT
            lnode_item          om.DomNode,
            ls_item_name        STRING,
            lnode_item_child    om.DomNode,
            ls_item_child_tag   STRING
   DEFINE   lwin_curr           ui.Window                        #No:CHI-A60022
          
   IF (ps_fields IS NULL) THEN
      RETURN
   ELSE
      LET ps_fields = ps_fields.toLowerCase()
   END IF
  
   #No:CHI-A60022 --start--
#  LET lnode_root = ui.Interface.getRootNode()
   LET lwin_curr = ui.Window.getCurrent()
   LET lnode_root = lwin_curr.getNode()
   #No:CHI-A60022 ---end---
   LET llst_items = lnode_root.selectByPath("//Form//*")    
   LET lst_fields = base.StringTokenizer.create(ps_fields, ",")
   WHILE lst_fields.hasMoreTokens() 
      LET ls_field_name = lst_fields.nextToken()
      LET ls_field_name = ls_field_name.trim()
      
      FOR li_i = 1 TO llst_items.getLength()
         LET lnode_item = llst_items.item(li_i)
         LET ls_item_name = lnode_item.getAttribute("colName")
      
         IF (ls_item_name IS NULL) THEN
            LET ls_item_name = lnode_item.getAttribute("name")
      
            IF (ls_item_name IS NULL) THEN
               CONTINUE FOR
            END IF
         END IF
      
         IF (ls_item_name.equals(ls_field_name)) THEN
            LET lnode_item_child = lnode_item.getFirstChild()
            LET ls_item_child_tag = lnode_item_child.getTagName()
            
            IF (ls_item_child_tag.equals("Edit") OR
                ls_item_child_tag.equals("ButtonEdit") OR
                ls_item_child_tag.equals("Label") OR 
                ls_item_child_tag.equals("DateEdit")) THEN
 
               CALL lnode_item_child.setAttribute("format", "")
               CALL lnode_item_child.setAttribute("format", ps_format)
            END IF
 
            EXIT FOR
         END IF
      END FOR
   END WHILE
END FUNCTION
