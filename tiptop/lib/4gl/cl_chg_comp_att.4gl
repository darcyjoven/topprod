# Prog. Version..: '5.30.06-13.03.12(00003)'     #
# 
# Library name...: cl_chg_comp_att.4gl
# Descriptions...: 更動原有物件的attribute
# Memo...........: 
# Usage..........: CALL cl_chg_comp_att("ima01","NOENTRY|ITEMS","1|(1,2,3),(red,blue,green)")
# Date & Author..: 2005/06/01 by saki
# Modify.........: No.FUN-570089 05/07/08 By saki 不要reset欄位的屬性值，若要reset由呼叫的程式去做
# Modify.........: No.MOD-5A0069 05/10/05 By saki 替換attribute的節點加入FORMONLY的判斷
# Modify.........: No.FUN-690005 06/09/15 By cheunl  欄位型態定義，改為LIKE 
# Modify.........: No.FUN-720042 07/03/02 By saki 因應4fd使用, findNode搜尋修改
# Modify.........: No.FUN-7C0045 07/12/14 By alex 修改說明
# Modify.........: No.CHI-8C0026 08/12/24 By Smapmin 增加hidden屬性設定,並允許一次可設定多個欄位
# Modify.........: No:FUN-A70010 10/07/05 By tsai_yen 增加尋找ScrollGrid的Matrix屬性的元件
 
DATABASE ds
                                           
GLOBALS "../../config/top.global"
 
##########################################################################
# Descriptions...: 改變欄位attributes
# Memo...........: 
# Input parameter: ps_field   STRING   欲更動欄位
#                  ps_atts    STRING   欄位type屬性
#                  ps_values  STRING   欄位type屬性值
# Return code....: none
# Usage..........: CALL cl_chg_comp_att("ima01","NOENTRY|ITEMS","1|(1,2,3),(red,blue,green)")
# Date & Author..: 2005/04/07 by saki
# Modify.........: No.FUN-7C0045 alex 修改說明
##########################################################################
FUNCTION cl_chg_comp_att(ps_fields,ps_atts,ps_values)   #CHI-8C0026 ps_field-->ps_fields
   DEFINE   ps_field          STRING
   DEFINE   ps_fields         STRING   #CHI-8C0026
   DEFINE   lst_fields        base.StringTokenizer   #CHI-8C0026
   DEFINE   ps_atts           STRING
   DEFINE   ps_values         STRING
   DEFINE   lwin_curr         ui.Window
   DEFINE   lfrm_curr         ui.Form
   DEFINE   ls_tag_name       STRING
   DEFINE   lnode_item        om.DomNode
   DEFINE   lnode_child       om.DomNode
   DEFINE   lnode_child2      om.DomNode
   DEFINE   ls_item_name      STRING
   DEFINE   li_width          LIKE type_file.num5     #No.FUN-690005 SMALLINT
   DEFINE   li_gridWidth      LIKE type_file.num5     #No.FUN-690005 SMALLINT
   DEFINE   li_posX           LIKE type_file.num10    #No.FUN-690005 INTEGER
   DEFINE   li_posY           LIKE type_file.num10    #No.FUN-690005 INTEGER
   DEFINE   li_inx_s          LIKE type_file.num5     #No.FUN-690005 SMALLINT
   DEFINE   li_inx_e          LIKE type_file.num5     #No.FUN-690005 SMALLINT
   DEFINE   ls_combo_itms     STRING
   DEFINE   ls_combo_vals     STRING
   DEFINE   llst_atts         base.StringTokenizer
   DEFINE   llst_vals         base.StringTokenizer
   DEFINE   ls_att            STRING
   DEFINE   ls_val            STRING
   DEFINE   llst_combo_itms   base.StringTokenizer
   DEFINE   llst_combo_vals   base.StringTokenizer
   DEFINE   ls_combo_itm      STRING
   DEFINE   ls_combo_val      STRING
   DEFINE   ls_tabname        STRING                  #No.FUN-720042
 
 
   IF (ps_fields IS NULL) THEN   #CHI-8C0026 ps_field-->ps_fields
      RETURN
   END IF
 
   LET lwin_curr = ui.Window.getCurrent()
   LET lfrm_curr = lwin_curr.getForm()
   IF lfrm_curr IS NULL THEN
      RETURN
   END IF
 
   LET lst_fields = base.StringTokenizer.create(ps_fields, ",")   #CHI-8C0026
   #No.MOD-5A0069 --start--
   WHILE lst_fields.hasMoreTokens()    #CHI-8C0026
      LET ps_field = lst_fields.nextToken()   #CHI-8C0026
      LET ps_field = ps_field.trim()   #CHI-8C0026
      LET ls_tabname = cl_get_table_name(ps_field)    #No.FUN-720042
      LET lnode_item = lfrm_curr.findNode("FormField",ls_tabname||"."||ps_field)  #No.FUN-720042
      IF lnode_item IS NULL THEN
         LET lnode_item = lfrm_curr.findNode("FormField","formonly." || ps_field)
         IF lnode_item IS NULL THEN
            LET lnode_item = lfrm_curr.findNode("TableColumn",ls_tabname||"."||ps_field)   #No.FUN-720042
            IF lnode_item IS NULL THEN
               LET lnode_item = lfrm_curr.findNode("TableColumn","formonly." || ps_field)
               IF lnode_item IS NULL THEN
                  LET lnode_item = lfrm_curr.findNode("Matrix",ls_tabname||"."||ps_field)  #FUN-A70010
                  IF lnode_item IS NULL THEN
                     LET lnode_item = lfrm_curr.findNode("Matrix","formonly." || ps_field) #FUN-A70010
                     IF lnode_item IS NULL THEN
                        RETURN
                     END IF
                  END IF
               END IF
            END IF
         END IF
      END IF
      LET ls_tag_name = lnode_item.getTagName()
      #No.MOD-5A0069 ---end---
      
      #No.FUN-570089
#     CALL cl_reset_field(lnode_item,ls_tag_name)
      
      LET lnode_child = lnode_item.getFirstChild()
      IF (ls_tag_name = "TableColumn") AND (lnode_child.getTagName() = "ValueList") THEN
         LET lnode_child = lnode_child.getNext()
      END IF
      LET ls_item_name = lnode_child.getTagName()
      
      LET llst_atts = base.StringTokenizer.create(ps_atts,"|")
      LET llst_vals = base.StringTokenizer.create(ps_values,"|")
      WHILE llst_atts.hasMoreTokens() AND llst_vals.hasMoreTokens()
         LET ls_att = llst_atts.nextToken()
         LET ls_val = llst_vals.nextToken()
         LET ls_att = UPSHIFT(ls_att)
         CASE ls_att
            WHEN "ITEMS"
               IF (ls_item_name = "ComboBox") OR (ls_item_name = "RadioGroup") THEN
                  LET li_inx_s = ls_val.getIndexOf("(",1)
                  IF li_inx_s > 0 THEN
                     LET li_inx_e = ls_val.getIndexOf(")",1)
                     LET ls_combo_itms = ls_val.subString(li_inx_s + 1,li_inx_e - 1)
                     LET li_inx_s = ls_val.getIndexOf("(",li_inx_s + ls_combo_itms.getLength() + 1)
                     LET li_inx_e = ls_val.getIndexOf(")",li_inx_e + 1)
                     LET ls_combo_vals = ls_val.subString(li_inx_s + 1,li_inx_e - 1)
                     LET llst_combo_itms = base.StringTokenizer.create(ls_combo_itms, ",")
                     LET llst_combo_vals = base.StringTokenizer.create(ls_combo_vals, ",")
      
                     WHILE llst_combo_vals.hasMoreTokens() AND llst_combo_itms.hasMoreTokens()
                         LET ls_combo_itm = llst_combo_itms.nextToken()
                         LET ls_combo_val = llst_combo_vals.nextToken()
                         LET lnode_child2 = lnode_child.createChild("Item")
                         CALL lnode_child2.setAttribute("name",ls_combo_itm)
                         CALL lnode_child2.setAttribute("text",ls_combo_itm || ":" || ls_combo_val)
                     END WHILE
                  END IF
               END IF
            WHEN "DEFAULT"
               CALL lnode_item.setAttribute("value",ls_val)
            WHEN "NOT NULL"
               CALL lnode_item.setAttribute("notNull",ls_val)
            WHEN "COMMENT"
               CALL lnode_child.setAttribute("comment",ls_val)
            WHEN "COLOR"
               CALL lnode_child.setAttribute("color",ls_val)
            WHEN "REVERSE"
               CALL lnode_child.setAttribute("reverse",ls_val)
            WHEN "QUERYEDITABLE"
               CALL lnode_child.setAttribute("queryEditable",ls_val)
            WHEN "NOENTRY"
               CALL lnode_item.setAttribute("noEntry",ls_val)
            WHEN "REQUIRED"
               CALL lnode_item.setAttribute("required",ls_val)
            WHEN "FORMAT"
               CALL lnode_child.setAttribute("format",ls_val)
            WHEN "SCROLL"
               CALL lnode_child.setAttribute("scroll",ls_val)
            WHEN "WIDTH"
               CALL lnode_child.setAttribute("width",ls_val)
            WHEN "GRIDWIDTH"
               CALL lnode_child.setAttribute("gridWidth",ls_val)
            WHEN "HIDDEN"   #CHI-8C0026
               CALL lnode_item.setAttribute("hidden",ls_val)   #CHI-8C0026
         END CASE
      END WHILE
   END WHILE   #CHI-8C0026
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
# Descriptions...: 重設屬性值
# Memo...........:
# Input parameter: pnode_item   元件節點
#                : ps_tag_name  元件Tag
# Return code....: none
# Usage..........: CALL cl_reset_field(lnode_item,"TableColumn")
# Date & Author..: 2005/04/07 by saki
# Modify.........: 
##########################################################################
FUNCTION cl_reset_field(pnode_item,ps_tag_name)
   DEFINE   pnode_item   om.DomNode
   DEFINE   ps_tag_name  STRING
   DEFINE   li_i         LIKE type_file.num10    #No.FUN-690005 INTEGER
   DEFINE   ls_att_name  STRING
 
 
   FOR li_i = 1 TO pnode_item.getAttributesCount()
      LET ls_att_name = pnode_item.getAttributeName(li_i)
      CASE 
         WHEN (ls_att_name = "value") OR (ls_att_name = "comment")
            CALL pnode_item.setAttribute(ls_att_name,"")
         WHEN (ls_att_name = "color") OR (ls_att_name = "queryEditable") OR
              (ls_att_name = "format") OR (ls_att_name = "scroll")
            CALL pnode_item.removeAttribute(ls_att_name)
         WHEN (ls_att_name = "notNull") OR (ls_att_name = "required") OR
              (ls_att_name = "noEntry") OR (ls_att_name = "reverse")
            CALL pnode_item.setAttribute(ls_att_name,0)
      END CASE
   END FOR
   
END FUNCTION
