# Prog. Version..: '5.30.06-13.03.12(00000)'     #
 
# Program name...: cl_set_comp_lab_text.4gl
# Program ver....: 7.0
# Descriptions...: 設定 Static Label (dummy) 的顯示名稱 
#                  Referance from cl_set_comp_att_text.4gl  FUN-520010
# Date & Author..: 05/02/14 by alex
# Modify.........: No.FUN-530030 05/03/21 alex 放寬限制
# Modify.........: No.FUN-690005 06/09/05 By chen 類型轉換
# Modify.........: No.TQC-720036 07/02/13 By chingyuan 當程式為背景執行時,直接RETURN
# Modify.........: No.TQC-740146 07/04/24 By Echo 判斷是否背景作業，條件需再加上 g_gui_type 
# Modify.........: No.FUN-7B0028 07/11/12 alex 修訂註解以配合自動抓取機制
 
DATABASE ds    #No.FUN-690005
 
GLOBALS "../../config/top.global"   #No.TQC-720036
    
##################################################
# Descriptions...: 設定 Static Label (dummy) 的顯示名稱 
# Input Parameter: ps_fields 欲轉換哪個欄位前的label或是table title
#                  ps_att_value 欲轉換的字串
# Return Code....: void
# Modify.........: No.FUN-7B0028 07/11/12 alex 修訂註解以配合自動抓取機制
##################################################
 
FUNCTION cl_set_comp_lab_text(ps_fields, ps_att_value)
   DEFINE   ps_fields          STRING,
            ps_att_value       STRING
   DEFINE   lst_fields         base.StringTokenizer,
            lst_string         base.StringTokenizer,
            ls_field_name      STRING,
            ls_field_value     STRING,
            ls_win_name        STRING
   DEFINE   lnode_root         om.DomNode,
            lnode_win          om.DomNode,
            lnode_pre          om.DomNode,
            llst_items         om.NodeList,
            li_i               LIKE type_file.num5,             #No.FUN-690005  SMALLINT
            lnode_item         om.DomNode,
            ls_item_name       STRING,
            lnode_item_child   om.DomNode,
            ls_item_pre_tag    STRING,
            ls_item_tag_name   STRING
   DEFINE   g_chg              DYNAMIC ARRAY OF RECORD
               item            STRING,
               value           STRING
                               END RECORD
   DEFINE   lwin_curr          ui.Window
   
   #No.TQC-720036 --start--
   #IF g_bgjob MATCHES '[Yy]' THEN
   IF g_bgjob MATCHES '[Yy]' AND g_gui_type NOT MATCHES "[13]"  THEN    #TQC-740146
      RETURN
   END IF
   #No.TQC-720036 --end--
   
   IF (ps_fields IS NULL) THEN
      RETURN
   ELSE
      LET ps_fields = ps_fields.toLowerCase()
   END IF
  
   LET lwin_curr = ui.Window.getCurrent()
   LET lnode_win = lwin_curr.getNode()
   LET ls_win_name = lnode_win.getAttribute("name")
 
   LET llst_items = lnode_win.selectByPath("//Form//*")    
   LET lst_fields = base.StringTokenizer.create(ps_fields, ",")
   LET lst_string = base.StringTokenizer.create(ps_att_value,",")
   WHILE lst_fields.hasMoreTokens() AND lst_string.hasMoreTokens()
      LET ls_field_name = lst_fields.nextToken()
      LET ls_field_value = lst_string.nextToken()
      LET ls_field_name = ls_field_name.trim()
 
      IF ls_field_name.equals(ls_win_name) THEN
         CALL lnode_win.setAttribute("text",ls_field_value)
      END IF
 
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
            LET ls_item_tag_name = lnode_item.getTagName()
#           #FUN-530030
#           CALL lnode_item.setAttribute("text",ls_field_value.toLowerCase())
            CALL lnode_item.setAttribute("text",ls_field_value.trim())
            EXIT FOR
         END IF
      END FOR
   END WHILE
END FUNCTION
 
