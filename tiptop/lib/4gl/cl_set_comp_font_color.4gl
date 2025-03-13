# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: cl_set_comp_font_color.4gl
# Descriptions...: 設定元件的字型顏色.
# Date & Author..: 03/09/16 by Hiko
# Memo...........: 1.顏色種類有:BLACK,BLUE,CYAN,GREEN,MAGENTA,RED,WHITE,YELLOW.
#                  2.可以設定顏色的元件有EDIT,BUTTONEDIT,COMBOBOX,DATEEDIT,LABEL.
# Usage..........: CALL cl_set_comp_font_color("oea01,oea04", "red")
# Modify.........: No.FUN-690005 06/09/05 By chen 類型轉換
# Modify.........: No.FUN-720021 07/06/23 By Echo 背景執行時則直接 Return
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-B50102 11/05/17 By tsai_yen 函式說明
 
DATABASE ds    #No.FUN-690005   #FUN-7C0053
 
GLOBALS "../../config/top.global"   #No.FUN-720021
 

#FUN-B50102 函式說明
##################################################
# Descriptions...: 設定元件的字型顏色
# Date & Author..: 2003/09/16 By Hiko
# Input Parameter: ps_fields   STRING   欄位名稱字串(中間以逗點分隔)
#                  pi_color    STRING   要設定的顏色(black,blue,cyan,green,magenta,red,white,yellow)
# Return code....: none
# Usage..........: CALL cl_set_comp_font_color("oea01,oea04", "red")
# Memo...........: 1.顏色種類有:BLACK,BLUE,CYAN,GREEN,MAGENTA,RED,WHITE,YELLOW.
#                  2.可以設定顏色的元件有EDIT,BUTTONEDIT,COMBOBOX,DATEEDIT,LABEL.
##################################################
FUNCTION cl_set_comp_font_color(ps_fields, ps_color)
   DEFINE   ps_fields           STRING,
            ps_color            STRING
   DEFINE   lst_fields          base.StringTokenizer,
            ls_field_name       STRING  
   DEFINE   lnode_root          om.DomNode,
            llst_items          om.NodeList,
            li_i                LIKE type_file.num5,             #No.FUN-690005  SMALLINT
            lnode_item          om.DomNode,
            ls_item_name        STRING,
            lnode_item_child    om.DomNode,
            ls_item_child_tag   STRING
          
 
   #FUN-720021
   IF g_bgjob = 'Y' AND g_gui_type NOT MATCHES "[13]"  THEN
      RETURN
   END IF
   #FUN-720021
 
   IF (ps_fields IS NULL) THEN
      RETURN
   ELSE
      LET ps_fields = ps_fields.toLowerCase()
   END IF
  
   LET lnode_root = ui.Interface.getRootNode()
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
                ls_item_child_tag.equals("ComboBox") OR
                ls_item_child_tag.equals("DateEdit") OR
                ls_item_child_tag.equals("Label")) THEN
 
               CALL lnode_item_child.setAttribute("color", ps_color.toLowerCase())
            END IF
 
            EXIT FOR
         END IF
      END FOR
   END WHILE
END FUNCTION
