# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: cl_set_comp_entry.4gl
# Descriptions...: 動態設定元件是否可輸入.
# Date & Author..: 03/06/26 by Hiko
# Usage..........: CALL cl_set_comp_entry("m01,m03,m07", FALSE)
# Modify.........: 03/10/06 by Hiko : 新增cl_allow_set_entry.
# Modify.........: No.TQC-740281 07/04/24 By Echo 判斷是否背景作業，條件需再加上 g_gui_type 
# Modify.........: No.FUN-690005 06/09/05 By chen 類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds     #No.FUN-690005   #FUN-7C0053
 
GLOBALS "../../config/top.global"           #TQC-740281
 
 
# Descriptions...: 設定元件是否可輸入.
# Date & Author..: 2003/06/26 by Hiko
# Input Parameter: ps_fields STRING 要設定元件是否可輸入的欄位名稱字串(中間以逗點分隔)
#                  pi_entry SMALLINT 是否可輸入(TRUE→可輸入,FALSE→不可輸入)
# Return Code....: void
 
FUNCTION cl_set_comp_entry(ps_fields, pi_entry)
  DEFINE ps_fields STRING,
         pi_entry  LIKE type_file.num5              #No.FUN-690005  SMALLINT
  DEFINE lst_fields base.StringTokenizer,
         ls_field_name STRING
  DEFINE lwin_curr     ui.Window
  DEFINE lnode_win     om.DomNode,
         llst_items    om.NodeList,
         li_i          LIKE type_file.num5,             #No.FUN-690005  SMALLINT
         lnode_item    om.DomNode,
         ls_item_name  STRING
  
  #TQC-740281
  IF g_bgjob = 'Y' AND g_gui_type NOT MATCHES "[13]"  THEN    #TQC-740146
     RETURN
  END IF
  #END TQC-740281
 
  IF (ps_fields IS NULL) THEN
     RETURN
  END IF
 
  LET ps_fields = ps_fields.toLowerCase()
 
  LET lst_fields = base.StringTokenizer.create(ps_fields, ",")
 
  LET lwin_curr = ui.Window.getCurrent()
  LET lnode_win = lwin_curr.getNode()
 
  LET llst_items = lnode_win.selectByPath("//Form//*")
 
  WHILE lst_fields.hasMoreTokens()
    LET ls_field_name = lst_fields.nextToken()
    LET ls_field_name = ls_field_name.trim()
 
    IF (ls_field_name.getLength() > 0) THEN
       FOR li_i = 1 TO llst_items.getLength()
           LET lnode_item = llst_items.item(li_i)
           LET ls_item_name = lnode_item.getAttribute("colName")
  
           IF (ls_item_name IS NULL) THEN
              LET ls_item_name = lnode_item.getAttribute("name")
 
              IF (ls_item_name IS NULL) THEN
                 CONTINUE FOR
              END IF
           END IF
  
           LET ls_item_name = ls_item_name.trim()
  
           IF (ls_item_name.equals(ls_field_name)) THEN
              IF (pi_entry) THEN
                 # 2003/10/08 by Hiko : 因為cl_ui_locale暫時移除此類程式判斷,因此這裡也暫時拿掉.
#                IF (cl_allow_set_entry(ls_field_name)) THEN
                    CALL lnode_item.setAttribute("noEntry", "0")
                    CALL lnode_item.setAttribute("active", "1")
#                END IF
              ELSE
                 CALL lnode_item.setAttribute("noEntry", "1")
                 CALL lnode_item.setAttribute("active", "0")
              END IF
           
              EXIT FOR
           END IF
       END FOR
    END IF
  END WHILE
END FUNCTION
 
##################################################
# Descriptions...: 判斷欄位是否允許設定NOENTRY
# Date & Author..: 2003/10/06 by Hiko
# Input Parameter: ps_field_name   STRING   欄位名稱
# Return Code....: SMALLINT   是否允許
##################################################
 
FUNCTION cl_allow_set_entry(ps_field_name)
   DEFINE   ps_field_name        STRING
   DEFINE   lst_noentry_fields   base.StringTokenizer
   DEFINE   li_allow             LIKE type_file.num5             #No.FUN-690005  SMALLINT
 
   
   LET li_allow = TRUE
 
   LET lst_noentry_fields = base.StringTokenizer.create(cl_get_noentry_fields(), ",")
   WHILE lst_noentry_fields.hasMoreTokens()
      IF (ps_field_name.equals(lst_noentry_fields.nextToken())) THEN
         LET li_allow = FALSE
         EXIT WHILE
      END IF
   END WHILE
 
   RETURN li_allow
END FUNCTION
