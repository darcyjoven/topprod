# Prog. Version..: '5.30.06-13.03.12(00000)'     #
 
# Program name...: cl_navigator_setting.4gl
# Descriptions...: 設定ToolBar上瀏覽上下筆資料的按鈕狀態.
# Date & Author..: 04/02/02 by Hiko
# Usage..........: CALL cl_navigator_setting(g_curr_index, g_cnt2)
# Modify.........: No.FUN-530067 05/03/30 By saki 拿掉匯率comment顯示
# Modify.........: No.FUN-640184 06/04/12 By Echo 自動執行確認功能
# Modify.........: No.FUN-690005 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6A0092 06/10/23 By Jackho 加入controls功能
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-710055 07/02/06 By saki 隱藏不需要使用的串聯button
# Modify.........: No.TQC-740146 07/04/24 By Echo 判斷是否背景作業，條件需再加上 g_gui_type 
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-770104 08/01/07 By saki 串查功能修正
# Modify.........: No.TQC-810061 08/01/17 By saki 串查功能修正
# Modify.........: No.FUN-960070 09/08/13 By tsai_yen 偵測是否有Dialog使用，若有的話增加用Dialog物件屬性setActionHidden、setActionActive
# Modify.........: No.MOD-980173 09/08/20 By saki 重設Menu隱藏按鍵
# Modify.........: No.FUN-A10029 10/01/06 By alex 抓取formname 含.tmp字樣時自動刪除
# Modify.........: No:FUN-A10059 10/01/11 By saki 串查按鈕若經過有開窗的副函式則可能被隱藏
# Modify.........: No:FUN-A30047 10/03/11 by Echo GP5.2 控制簽核action的顯示
# Modify.........: No:FUN-B10036 11/01/17 By Hiko 增加條件判斷來改善效能
# Modify.........: No:FUN-B60104 11/06/21 By saki 使用tiptop.4ad隱藏串查Action
# Modify.........: No:FUN-BA0098 11/10/28 By Hiko 隱藏沒有權限的Action時,要避開gap06='N'的狀況.
# Modify.........: No:FUN-C60042 12/12/12 By zack 修正切換語言別後action數量與切換前不一致
DATABASE ds        #FUN-6C0017  #FUN-7C0053
 
GLOBALS "../../config/top.global"
#No.FUN-710055 --start--
GLOBALS
   DEFINE   mi_btn_sn           LIKE type_file.num5
   DEFINE   mi_table_flag       LIKE type_file.num5    #No.FUN-770104
   DEFINE   mi_btnb_flag        LIKE type_file.num5    #No.FUN-770104
   #No.TQC-810061 --start--
   DEFINE   mr_btnb             DYNAMIC ARRAY OF RECORD
               form_name        LIKE gae_file.gae01,
               table_flag       LIKE type_file.num5,
               btnb_flag        LIKE type_file.num5 
                                END RECORD
   #No.TQC-810061 ---end---  

   #No:FUN-A30047 -- start --
   DEFINE  g_approve_act        DYNAMIC ARRAY OF RECORD
               name               STRING,
               value              LIKE type_file.num5
                                END RECORD
   #No:FUN-A30047 -- end --
   
   #FUN-C60042 --start--
   DEFINE  gs_act_visible_on    STRING,                   #是否維護g_act_visible array
           g_act_visible        DYNAMIC ARRAY OF RECORD   #記錄哪些action要隱藏或顯示
               name               STRING,
               value              LIKE type_file.num5
                                END RECORD
   #FUN-C60042 --end--

END GLOBALS
#No.FUN-710055 ---end---
 
# Descriptions...: 設定ToolBar上瀏覽上下筆資料的按鈕狀態.
# Date & Author..: 2004/02/02 by Hiko
# Input Parameter: pi_curr_index   LIKE type_file.num10     #No.FUN-690005 INTEGER   目前Cursor索引值
#                  pi_row_count    INTEGER   資料筆數
# Return Code....: void
 
FUNCTION cl_navigator_setting(pi_curr_index, pi_row_count)
   DEFINE   pi_curr_index   LIKE type_file.num10,     #No.FUN-690005 INTEGER,
            pi_row_count    LIKE type_file.num10      #No.FUN-690005 INTEGER
   #No.FUN-710055 --start--
   DEFINE   li_cnt          LIKE type_file.num5
   DEFINE   lwin_curr       ui.Window
   DEFINE   lfrm_curr       ui.Form
   DEFINE   lnode_button    om.DomNode
   DEFINE   ls_btn_name     STRING
   DEFINE   ls_btn_hidden   STRING
   #No.FUN-710055 ---end---
   #No.TQC-810061 --start--
   DEFINE   lnode_frm       om.DomNode
   DEFINE   ls_formName     STRING
   #No.TQC-810061 ---end---
   DEFINE   ls_btn_unhidden STRING   #No:FUN-A10059
   DEFINE   ls_act_visible_list_true  STRING #FUN-C60042 要顯示的action list
   DEFINE   ls_act_visible_list_false STRING #FUN-C60042 要隱藏的action list

 
   #FUN-640184
   #IF g_bgjob = 'Y' THEN
   IF g_bgjob = 'Y' AND g_gui_type NOT MATCHES "[13]"  THEN    #TQC-740146
 
      RETURN
   END IF
   #END FUN-640184

   #No:FUN-B60104 --mark start--
   #No:FUN-B10036 --start--
#  IF (pi_curr_index=0 OR pi_curr_index=1) THEN 
#     #No.FUN-770104 --start--   #No.TQC-810061 --modify start--
#     LET lwin_curr = ui.Window.getCurrent()
#     LET lfrm_curr = lwin_curr.getForm()
#     IF lfrm_curr IS NOT NULL THEN
#        LET lnode_frm = lfrm_curr.getNode()
#        LET ls_formName = lnode_frm.getAttribute("name")
#        IF ls_formName.subString(ls_formName.getLength()-3,ls_formName.getLength()) = ".tmp" THEN
#           LET ls_formName = ls_formName.subString(1,ls_formName.getLength()-4)  #FUN-A10029
#        END IF
#        IF ls_formName.subString(ls_formName.getLength(),ls_formName.getLength()) = "T" THEN
#           LET ls_formName = ls_formName.subString(1,ls_formName.getLength()-1)
#        END IF
#     END IF
#     FOR li_cnt = 1 TO mr_btnb.getLength()
#         IF mr_btnb[li_cnt].form_name = ls_formName THEN
#            IF NOT mr_btnb[li_cnt].table_flag OR NOT mr_btnb[li_cnt].btnb_flag THEN
#               CALL cl_set_act_visible("btn_detail",FALSE)
#            ELSE
#               CALL cl_set_act_visible("btn_detail",TRUE)
#            END IF
#         END IF
#     END FOR
#     #No.FUN-770104 ---end---   #No.TQC-810061 ---modify end---
#     
#     #No.FUN-710055 --start--
#     FOR li_cnt = 1 TO 20
#         IF lfrm_curr IS NOT NULL THEN
#            LET ls_btn_name = "btn_",li_cnt USING '&&'
#            LET lnode_button = lfrm_curr.findNode("Button",ls_btn_name)
#            IF lnode_button IS NULL THEN
#               LET ls_btn_hidden = ls_btn_hidden,ls_btn_name,","
#            END IF
#            LET ls_btn_unhidden = ls_btn_unhidden,ls_btn_name,","   #No:FUN-A10059
#         END IF
#     END FOR
#     CALL cl_set_act_visible(ls_btn_unhidden.subString(1,ls_btn_unhidden.getLength()-1),TRUE)   #No:FUN-A10059
#     CALL cl_set_act_visible(ls_btn_hidden.subString(1,ls_btn_hidden.getLength()-1),FALSE)
#     #No.FUN-710055 ---end---
#     
#     # 2004/09/24 by saki : 重設action的active
#     CALL cl_reset_action_active()
#  END IF
   #No:FUN-B10036 ---end---
   #No:FUN-B60104 ---mark end---
 
   # 2004/02/02 by Hiko : 一開始預設為全部顯現.
   CALL cl_reset_local_action("first,previous,jump,next,last", TRUE)
 
   CASE
      WHEN pi_row_count <= 1
         CALL cl_reset_local_action("first,previous,jump,next,last", FALSE)
      WHEN pi_row_count > 1 AND pi_curr_index = 1
         CALL cl_reset_local_action("first,previous", FALSE)
      WHEN pi_row_count > 1 AND pi_curr_index = pi_row_count
         CALL cl_reset_local_action("next,last", FALSE)
   END CASE

   # 2010/03/11 by Echo : 還原簽核 action 原先呈現的狀況，判斷簽核 action 是否該隱藏
   #No:FUN-A30047 -- start --
   IF g_aza.aza23 matches '[yY]' THEN
      FOR li_cnt = 1 TO g_approve_act.getLength()
         # display g_approve_act[li_cnt].name  #FUN-C60042
         # display g_approve_act[li_cnt].value #FUN-C60042 
          CALL cl_set_act_visible(g_approve_act[li_cnt].name, g_approve_act[li_cnt].value)
      END FOR
   END IF
   #No:FUN-A30047 -- start --
   
  #FUN-C60042 --start--
   #2012/12/12 by zack:程式開始到現在為止呼叫cl_set_act_visible的action都記錄在g_act_visible這個dynamic array,
   #                    根據g_act_visible再重跑一次cl_set_act_visible確保有效
   LET gs_act_visible_on = "N"  #此次呼叫cl_set_act_visible並不需要維護g_act_visible,所以將gs_act_visible_on設為N
   LET ls_act_visible_list_true = ''
   LET ls_act_visible_list_false = ''
   FOR li_cnt = 1 TO g_act_visible.getLength()
       IF g_act_visible[li_cnt].value = TRUE THEN
          IF cl_null(ls_act_visible_list_true) THEN
             LET ls_act_visible_list_true = g_act_visible[li_cnt].name
          ELSE
             LET ls_act_visible_list_true = ls_act_visible_list_true || "," || g_act_visible[li_cnt].name
          END IF
       ELSE
          IF cl_null(ls_act_visible_list_false) THEN
             LET ls_act_visible_list_false = g_act_visible[li_cnt].name
          ELSE
             LET ls_act_visible_list_false = ls_act_visible_list_false || "," || g_act_visible[li_cnt].name
          END IF
       END IF
   END FOR
   CALL cl_set_act_visible(ls_act_visible_list_true,TRUE)
   CALL cl_set_act_visible(ls_act_visible_list_false,FALSE)
   LET gs_act_visible_on = "Y"   #將gs_act_visible_on設為Y,讓之後程式若呼叫cl_set_act_visible時自動維護g_act_visible
   #FUN-C60042 --end--

END FUNCTION
 
# Descriptions...: 讀入action資料
# Input Parameter: ps_act_names
#                  pi_visible
# Return Code....: void
 
FUNCTION cl_reset_local_action(ps_act_names, pi_visible)
   DEFINE   ps_act_names    STRING,
            pi_visible      LIKE type_file.num5      #No.FUN-690005 SMALLINT
   DEFINE   lnode_root      om.DomNode,
            li_i            LIKE type_file.num5,      #No.FUN-690005 SMALLINT,
            li_j            LIKE type_file.num5,      #No.FUN-690005 SMALLINT,
            lst_act_names   base.StringTokenizer,
            ls_act_name     STRING,
            llst_items      om.NodeList,
            lnode_item      om.DomNode,
            ls_item_name    STRING 
   DEFINE   la_act_type     DYNAMIC ARRAY OF STRING
   DEFINE   ld_curr         ui.Dialog                 #FUN-960070
 
   WHENEVER ERROR CALL cl_err_msg_log                 #FUN-960070
   
   LET la_act_type[1] = "Action"
   LET la_act_type[2] = "MenuAction"
   LET lnode_root = ui.Interface.getRootNode()
   LET ld_curr = ui.Dialog.getCurrent()              #FUN-960070
 
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
               ###FUN-960070 START ###
               IF ld_curr IS NOT NULL THEN
                  IF (pi_visible) THEN
                     CALL ld_curr.setActionActive(ls_act_name,TRUE)
                  ELSE
                     CALL ld_curr.setActionActive(ls_act_name,FALSE)
                  END IF
               END IF
               ###FUN-960070 END ###
               
               IF (pi_visible) THEN
                  # 2004/02/18 by Hiko : 若是設定"hidden",則畫面會閃爍一次.
#                 CALL lnode_item.setAttribute("hidden", "0")
                  CALL lnode_item.setAttribute("active", "1")
               ELSE
                  # 2004/02/18 by Hiko : 若是設定"hidden",則畫面會閃爍一次.
#                 CALL lnode_item.setAttribute("hidden", "1")
                  CALL lnode_item.setAttribute("active", "0")
               END IF
 
               EXIT FOR
            END IF
         END FOR
      END WHILE
   END FOR
END FUNCTION
 
 
# Descriptions...: 將隱藏的Action屬性active改為0
# Date & Author..: 2004/09/24 by saki
# Input Parameter: None
# Return Code....: void
# Memo...........: 為了將dialog內的hidden欄位active設為0,才能將右鍵選單action隱藏
# Modify.........: No.MOD-980173 09/08/20 By saki 因進入Menu前未產生MenuAction Node,導致進入後右鍵選單出現隱藏Action
 
FUNCTION cl_reset_action_active()
   DEFINE lwin_curr     ui.Window  
   DEFINE lnl_actions   om.NodeList
   DEFINE ln_action     om.DomNode,
          ln_win        om.DomNode
   DEFINE ls_defview    STRING
   DEFINE ls_hidden     STRING
   DEFINE ls_act_name   STRING
   DEFINE li_i          LIKE type_file.num10     #No.FUN-690005 INTEGER
   DEFINE ld_curr     ui.Dialog                  #FUN-960070
   
   WHENEVER ERROR CALL cl_err_msg_log            #FUN-960070
   
   LET lwin_curr = ui.Window.getCurrent()
   LET ln_win = lwin_curr.getNode()
   LET lnl_actions = ln_win.selectByPath("//Dialog/Action")
   LET ld_curr = ui.Dialog.getCurrent()          #FUN-960070
   
   FOR li_i = 1 TO lnl_actions.getLength()
       LET ln_action = lnl_actions.item(li_i)
 
       LET ls_defview = ln_action.getAttribute("defaultView")
       LET ls_hidden = ln_action.getAttribute("hidden")
       LET ls_act_name = ln_action.getAttribute("name")
 
       IF ls_act_name.equals("accept") OR ls_act_name.equals("cancel") OR
          ls_act_name.equals("close") OR ls_act_name.equals("controlg") OR
          ls_act_name.equals("controls")                                        #No.FUN-6A0092
       THEN
          CONTINUE FOR
       END IF
 
       
       IF ls_defview.equals("no") OR ls_hidden.equals("1") THEN
          CALL ln_action.setAttribute("active", 0)
          ###FUN-960070 START ###
          IF ld_curr IS NOT NULL THEN
             CALL ld_curr.setActionActive(ls_act_name,FALSE)
          END IF
          ###FUN-960070 END ###
       ELSE
          CALL ln_action.setAttribute("active", 1)
          ###FUN-960070 START ###
          IF ld_curr IS NOT NULL THEN
             CALL ld_curr.setActionActive(ls_act_name,TRUE)
          END IF
          ###FUN-960070 END ###
       END IF
   END FOR
 
   #No.MOD-980173 --start--
   LET lnl_actions = ln_win.selectByPath("//Menu/MenuAction")
   
   FOR li_i = 1 TO lnl_actions.getLength()
       LET ln_action = lnl_actions.item(li_i)
 
       LET ls_defview = ln_action.getAttribute("defaultView")
       LET ls_hidden = ln_action.getAttribute("hidden")
       LET ls_act_name = ln_action.getAttribute("name")
 
       IF ls_act_name.equals("accept") OR ls_act_name.equals("cancel") OR
          ls_act_name.equals("close") OR ls_act_name.equals("controlg") OR
          ls_act_name.equals("controls")                                        #No.FUN-6A0092
       THEN
          CONTINUE FOR
       END IF
 
       
       IF ls_defview.equals("no") OR ls_hidden.equals("1") THEN
          CALL ln_action.setAttribute("active", 0)
          IF ld_curr IS NOT NULL THEN
             CALL ld_curr.setActionActive(ls_act_name,FALSE)
          END IF
       ELSE
          CALL ln_action.setAttribute("active", 1)
          IF ld_curr IS NOT NULL THEN
             CALL ld_curr.setActionActive(ls_act_name,TRUE)
          END IF
       END IF
   END FOR
   #No.MOD-980173 ---end---
END FUNCTION
 
# Descriptions...: 將無權限的Action隱藏起來 (test)
# Date & Author..: 2004/11/18 by saki
# Input Parameter: None
# Return Code....: void
# Memo...........: FUN-4B0029 不確定gap02是否可代表此程式所有的action
 
FUNCTION cl_act_noauth_disable()
   DEFINE   lst_act_list   base.StringTokenizer,
            ls_act         STRING,
            li_act_allow   LIKE type_file.num5,      #No.FUN-690005 SMALLINT,
            lr_act         DYNAMIC ARRAY OF RECORD
               act_name    LIKE gap_file.gap02
                           END RECORD,
            li_cnt         LIKE type_file.num10,     #No.FUN-690005 INTEGER,
            li_i           LIKE type_file.num10,     #No.FUN-690005 INTEGER,
            ls_auth        LIKE type_file.num5      #No.FUN-690005 SMALLINT
 
 
   DECLARE gap02_curs CURSOR FOR
      #SELECT gap02 FROM gap_file WHERE gap01 = g_prog
      SELECT gap02 FROM gap_file WHERE gap01 = g_prog AND gap06='Y' #FUN-BA0098

   LET li_cnt = 1
   FOREACH gap02_curs INTO lr_act[li_cnt].*
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
      LET li_cnt = li_cnt + 1
   END FOREACH
   CALL lr_act.deleteElement(li_cnt)
 
 
   FOR li_i = 1 TO lr_act.getLength()
       LET ls_auth = FALSE
       LET lst_act_list = base.StringTokenizer.create(g_priv1 CLIPPED, ",")
       WHILE lst_act_list.hasMoreTokens()
          LET ls_act = lst_act_list.nextToken()
          LET ls_act = ls_act.trim()
 
          IF ls_act.equals(lr_act[li_i].act_name CLIPPED) THEN
             LET ls_auth = TRUE
             EXIT WHILE
          END IF
       END WHILE
       IF NOT ls_auth THEN
          CALL cl_set_act_visible(lr_act[li_i].act_name CLIPPED,FALSE)
       END IF
   END FOR
 
END FUNCTION
