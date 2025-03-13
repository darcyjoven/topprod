# Prog. Version..: '5.30.07-13.05.16(00000)'     #
#              
# Library name...: cl_set_toolbaritem_visible
# Descriptions...: 隱藏TOOLBAR ITEM功能參考
# Usage .........: call cl_set_toolbaritem_visible(ps_act_names,pi_visible) #pi_visible 1:顯示 0:隱藏
# Date & Author..: FUN-CB0113 12/11/26 By benson

DATABASE ds
GLOBALS "../../config/top.global" 

#FUN-CB0113 add
FUNCTION cl_set_toolbaritem_visible(ps_act_names, pi_visible)
   DEFINE   ps_act_names    STRING,
            pi_visible      LIKE type_file.num5  
   DEFINE   lnode_root      om.DomNode,
            li_i            LIKE type_file.num5,
            li_j            LIKE type_file.num5,
            lst_act_names   base.StringTokenizer,     
            ls_act_name     STRING,
            llst_items      om.NodeList,
            lnode_item      om.DomNode,
            ls_item_name    STRING 
   DEFINE   la_act_type     DYNAMIC ARRAY OF STRING
   DEFINE   ld_curr         ui.Dialog
   
   WHENEVER ERROR CALL cl_err_msg_log
   
   LET la_act_type[1] = "Action"
   LET la_act_type[2] = "ToolBarItem"
   LET lnode_root = ui.Interface.getRootNode()
   LET ld_curr = ui.Dialog.getCurrent()

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
               IF ld_curr IS NOT NULL THEN
                  IF (pi_visible) THEN
                     CALL ld_curr.setActionActive(ls_act_name,TRUE)
                  ELSE
                     CALL ld_curr.setActionActive(ls_act_name,FALSE)
                  END IF
               END IF

               IF (pi_visible) THEN
                  CALL lnode_item.setAttribute("hidden", "0")
               ELSE
                  CALL lnode_item.setAttribute("hidden", "1")
               END IF

               EXIT FOR
            END IF
         END FOR
      END WHILE
   END FOR
END FUNCTION
