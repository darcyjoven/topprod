# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: cl_set_act_title.4gl
# Descriptions...: 動態呈現/隱藏畫面上的ACTION
# Date & Author..: 08/05/27 by arman 
# Usage..........: CALL cl_set_act_title("qry_accept,qry_refresh", FALSE)
# Modify.........: No.FUN-870127 08/08/19 By arman
 
DATABASE ds          #No.FUN-690005
 
GLOBALS "../../config/top.global"           #TQC-740281   #FUN-7C0053
 
# Descriptions...: 呈現/隱藏畫面上的元件
# Date & Author..: 2008/05/27 by arman
# Input Parameter: ps_act_names   STRING  要呈現/隱藏ACTION的名稱字串(中間以豆號分隔) 
#                  pi_title     SMALLINT  是否呈現(TRUE -->呈現,FALSE -->隱藏)
# Return Code....: void
 
FUNCTION cl_set_act_title(ps_act_names, pi_title)
   DEFINE   ps_act_names    STRING,
            pi_title        STRING 
   DEFINE   la_act_type     DYNAMIC ARRAY OF STRING,
            lnode_root      om.DomNode,
            li_i            LIKE type_file.num5,             #No.FUN-690005  SMALLINT
            lst_act_names   base.StringTokenizer,
            ls_act_name     STRING,
            llst_items      om.NodeList,
            li_j            LIKE type_file.num5,             #No.FUN-690005  SMALLINT
            lnode_item      om.DomNode,
            ls_item_name    STRING,
            ls_item_tag     STRING
 
   #TQC-740281
   IF g_bgjob = 'Y' AND g_gui_type NOT MATCHES "[13]"  THEN    #TQC-740146
      RETURN
   END IF
   #END TQC-740281
 
   IF (ps_act_names IS NULL) THEN
      RETURN
   ELSE
      LET ps_act_names = ps_act_names.toLowerCase()
   END IF
 
 
   LET la_act_type[1] = "ActionDefault"
   LET la_act_type[2] = "LocalAction"
   LET la_act_type[3] = "Action"
   # 2003/10/28 by Hiko : MenuAction  下個版本才會有相關做法.
   # 2004/08/26 by saki : open
   LET la_act_type[4] = "MenuAction"
   LET lnode_root = ui.Interface.getRootNode()
   FOR li_i = 1 TO la_act_type.getLength()
      LET lst_act_names = base.StringTokenizer.create(ps_act_names, ",")
      WHILE lst_act_names.hasMoreTokens() 
         LET ls_act_name = lst_act_names.nextToken()
         LET ls_act_name = ls_act_name.trim()
         LET llst_items = lnode_root.selectByTagName(la_act_type[li_i])
 
         FOR li_j = 1 TO llst_items.getLength()
            LET lnode_item = llst_items.item(li_j)
            LET ls_item_name = lnode_item.getAttribute("name")
            IF (ls_item_name IS NULL) THEN
               CONTINUE FOR
            END IF
 
            IF (ls_item_name.equals(ls_act_name)) THEN
                CALL lnode_item.setAttribute("text",pi_title)
               EXIT FOR
            END IF
         END FOR
      END WHILE
   END FOR
END FUNCTION
#No.FUN-870127
 
