# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: cl_set_action_active.4gl
# Descriptions...: Active/Deactive Action
# Date & Author..: 2004/07/02 by Brendan
# Usage..........: CALL cl_set_action_active("act1,act2", TRUE)
#                 - Set Action(act1, act2) active
#                  CALL cl_set_action_active("act1,act2", FALSE)
#                 - Set Action(act1, act2) deactive
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-960070 09/08/13 By tsai_yen 偵測是否有Dialog使用，若有的話增加用Dialog物件屬性setActionHidden、setActionActive
 
DATABASE ds             #No.FUN-690005   #FUN-7C0053
 
# Descriptions...: Active/Deactive Action
# Date & Author..: 2004/07/02 by Brendan
# Input Parameter: ps_actions STRING  - action names(seprated by comma)
#                  pi_active  INTEGER - active or deactive
# Return Code....: void
# Modify.........: No.FUN-690005 06/09/05 By chen 類型轉換
 
FUNCTION cl_set_action_active(ps_actions, pi_active)
   DEFINE ps_actions    STRING,
          pi_active     LIKE type_file.num10       #No.FUN-690005  INTEGER
   DEFINE lwin_curr     ui.Window  
   DEFINE lnl_actions   om.NodeList
   DEFINE ln_action     om.DomNode,
          ln_win        om.DomNode
   DEFINE lst_actions   base.StringTokenizer
   DEFINE ls_action     STRING
   DEFINE li_i          LIKE type_file.num10       #No.FUN-690005  INTEGER
   DEFINE ld_curr       ui.Dialog                  #FUN-960070
 
   
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF cl_null(ps_actions) THEN
      RETURN
   ELSE
      LET ps_actions = ps_actions.toLowerCase()
   END IF
  
   LET lwin_curr = ui.Window.getCurrent()
   LET ln_win = lwin_curr.getNode()
   LET lnl_actions = ln_win.selectByPath("//Dialog/Action")
   LET ld_curr = ui.Dialog.getCurrent()   #FUN-960070
   
   LET lst_actions = base.StringTokenizer.create(ps_actions, ",")
   WHILE lst_actions.hasMoreTokens() 
      LET ls_action = lst_actions.nextToken()
      LET ls_action = ls_action.trim()
      
      FOR li_i = 1 TO lnl_actions.getLength()
          LET ln_action = lnl_actions.item(li_i)
 
          IF ls_action = ln_action.getAttribute("name") THEN
             ###FUN-960070 START ###
             IF ld_curr IS NOT NULL THEN
                IF pi_active THEN
                   CALL ld_curr.setActionActive(ls_action,TRUE)
                ELSE
                   CALL ld_curr.setActionActive(ls_action,FALSE)
                END IF
             END IF
             ###FUN-960070 END ###
             IF pi_active THEN
                CALL ln_action.setAttribute("active", 1)
             ELSE
                CALL ln_action.setAttribute("active", 0)
             END IF
             EXIT FOR
          END IF
      END FOR
   END WHILE
END FUNCTION
