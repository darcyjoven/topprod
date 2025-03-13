# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: cl_set_comments.4gl
# Descriptions...: 設定欄位的comments 
# Date & Author..: 04/07/01 by saki
# Usage..........: CALL cl_set_comments("oea01,oea02","string1|string2")
# Modify.........: No.FUN-690005 06/09/05 By chen 類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds     #No.FUN-690005   #FUN-7C0053
 
# Descriptions...: 設定欄位的comments 
# Input Parameter: ps_fields 欲轉換哪個欄位﹙以字串代表﹚
#                  ps_att_value 欲轉換的字串
# Return Code....:
 
FUNCTION cl_set_comments(ps_fields, ps_att_value)
   DEFINE   ps_fields          STRING,
            ps_att_value       STRING
   DEFINE   lst_fields         base.StringTokenizer,
            lst_string         base.StringTokenizer,
            ls_field_name      STRING,
            ls_field_value     STRING
   DEFINE   lnode_root         om.DomNode,
            lnode_win          om.DomNode,
            llst_items         om.NodeList,
            li_i               LIKE type_file.num5,             #No.FUN-690005  SMALLINT
            lnode_item         om.DomNode,
            lnode_child        om.DomNode,
            ls_item_name       STRING
   DEFINE   g_chg              DYNAMIC ARRAY OF RECORD
               item            STRING,
               value           STRING
                               END RECORD
   DEFINE   lwin_curr          ui.Window
          
   IF (ps_fields IS NULL) THEN
      RETURN
   ELSE
      LET ps_fields = ps_fields.toLowerCase()
   END IF
  
   LET lwin_curr = ui.Window.getCurrent()
   LET lnode_win = lwin_curr.getNode()
 
   LET llst_items = lnode_win.selectByPath("//Form//*")    
   LET lst_fields = base.StringTokenizer.create(ps_fields, ",")
   LET lst_string = base.StringTokenizer.create(ps_att_value,"|")
   WHILE lst_fields.hasMoreTokens() AND lst_string.hasMoreTokens()
      LET ls_field_name = lst_fields.nextToken()
      LET ls_field_value = lst_string.nextToken()
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
            LET lnode_child = lnode_item.getFirstChild()
            CALL lnode_child.setAttribute("comment",ls_field_value.toLowerCase())
            EXIT FOR
         END IF
      END FOR
   END WHILE
END FUNCTION
