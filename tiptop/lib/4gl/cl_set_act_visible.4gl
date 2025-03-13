# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: cl_set_act_visible.4gl
# Descriptions...: 動態顯現/隱藏畫面上的Action.
# Date & Author..: 03/06/26 by Hiko
# Usage..........: CALL cl_set_act_visible("qry_accept,qry_refresh", FALSE)
# Modify.........: No.MOD-580073 by Brendan 修正呼叫後, 已定義在 ToolBar or TopMenu 的 action 會同樣出現在 RingMenu 上
# Modify.........: No.TQC-740281 07/04/24 By Echo 判斷是否背景作業，條件需再加上 g_gui_type 
# Modify.........: No.FUN-660164 07/06/07 By saki 指定筆功能顯示accept/cancel
# Modify.........: No.FUN-690005 06/09/05 By chen 類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-960070 09/08/13 By tsai_yen 偵測是否有Dialog使用，若有的話增加用Dialog物件屬性setActionHidden、setActionActive
# Modify.........: No.FUN-A10131 10/01/26 By tommas 針對GDC 2.21的nextpage/prevpage做隱藏，以tag來識別。
# Modify.........: No:CHI-B60075 11/06/21 By tsai_yen 在RETURN加上FALSE
# Modify.........: No:FUN-C60042 12/12/12 By zack 修正切換語言別後action數量與切換前不一致
DATABASE ds          #No.FUN-690005
 
GLOBALS "../../config/top.global"           #TQC-740281   #FUN-7C0053

#FUN-C60042 --start--
GLOBALS
   DEFINE  gs_act_visible_on    STRING,                  #是否維護g_act_visible array
           g_act_visible        DYNAMIC ARRAY OF RECORD  #記錄哪些action要隱藏或顯示
               name               STRING,
               value              LIKE type_file.num5
                                END RECORD
END GLOBALS
#FUN-C60042 --end--
 
 
# Descriptions...: 顯現/隱藏畫面上的元件.
# Date & Author..: 2003/06/26 by Hiko
# Input Parameter: ps_act_names   STRING     要顯現/隱藏Action的名稱字串(中間以逗點分隔)
#                  pi_visible     SMALLINT   是否顯現(TRUE→顯現,FALSE→隱藏)
# Return Code....: void
 
FUNCTION cl_set_act_visible(ps_act_names, pi_visible)
   DEFINE   ps_act_names    STRING,
            pi_visible      LIKE type_file.num5        #No.FUN-690005  SMALLINT
   DEFINE   la_act_type     DYNAMIC ARRAY OF STRING,
            lnode_root      om.DomNode,
            li_i            LIKE type_file.num5,       #No.FUN-690005  SMALLINT
            lst_act_names   base.StringTokenizer,
            ls_act_name     STRING,
            llst_items      om.NodeList,
            li_j            LIKE type_file.num5,       #No.FUN-690005  SMALLINT
            lnode_item      om.DomNode,
            ls_item_name    STRING,
            ls_item_tag     STRING
   DEFINE   ld_curr         ui.Dialog                  #FUN-960070
   DEFINE   li_act_visible_cnt  LIKE type_file.num5,   #FUN-C60042
            ls_act_visible_flag STRING                 #FUN-C60042 


   WHENEVER ERROR CALL cl_err_msg_log                  #FUN-960070
 
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
   # 2003/10/28 by Hiko : MenuAction下個版本才會有相關做法.
   # 2004/08/26 by saki : open
   LET la_act_type[4] = "MenuAction"
 
   LET lnode_root = ui.Interface.getRootNode()
   LET ld_curr = ui.Dialog.getCurrent()   #FUN-960070
 
   FOR li_i = 1 TO la_act_type.getLength()
      LET lst_act_names = base.StringTokenizer.create(ps_act_names, ",")
      WHILE lst_act_names.hasMoreTokens() 
         LET ls_act_name = lst_act_names.nextToken()
         LET ls_act_name = ls_act_name.trim()
   #FUN-C60042 --start--
         #將需隱藏或顯示的action清單及狀態保留一份至dynamic array=g_act_visible,供cl_navigator_setting使用
         IF li_i = 1 THEN                                                             #以下每次FOR迴圈執行的結果都一樣，避免重覆執行所以僅在第一次FOR迴圈時記錄
            IF gs_act_visible_on IS NULL OR gs_act_visible_on != "N" THEN             #當gs_act_visible_on = N時,表示本次不需要維護g_act_visible的狀態
               IF ls_act_name.equals("accept") OR ls_act_name.equals("cancel") THEN   #accept及cancel不處理,因為cancel有可能造成右上角x無法關閉
               ELSE
                  LET ls_act_visible_flag = "N"             #是否找到
                  FOR li_act_visible_cnt = 1 TO g_act_visible.getLength()
                      IF g_act_visible[li_act_visible_cnt].name.equals(ls_act_name) THEN
                         LET ls_act_visible_flag = "Y"      #找到則更新狀態
                         LET g_act_visible[li_act_visible_cnt].value = pi_visible
                         EXIT FOR
                      END IF
                  END FOR
                  IF ls_act_visible_flag != "Y" THEN        #沒找到則新增一筆
                     LET li_act_visible_cnt = g_act_visible.getLength() +1
                     LET g_act_visible[li_act_visible_cnt].name = ls_act_name
                     LET g_act_visible[li_act_visible_cnt].value = pi_visible
                  END IF
               END IF
            END IF
         END IF
   #FUN-C60042 --end--
        LET llst_items = lnode_root.selectByTagName(la_act_type[li_i])
 
         FOR li_j = 1 TO llst_items.getLength()
            LET lnode_item = llst_items.item(li_j)
            LET ls_item_name = lnode_item.getAttribute("name")

            ##### No.FUN-A10131 START #####
            IF lnode_item.getAttribute("tag") = "sys_nextpage" OR lnode_item.getAttribute("tag") = "sys_prevpage" THEN 
               CONTINUE WHILE
            END IF
            ##### No.FUN-A10131 END   #####

            IF (ls_item_name IS NULL) THEN
               CONTINUE FOR
            END IF
            
            IF (ls_item_name.equals(ls_act_name)) THEN
               ###FUN-960070 START ###
               IF ld_curr IS NOT NULL THEN
                  IF (pi_visible) THEN
                     CALL ld_curr.setActionHidden(ls_act_name,FALSE)
                     CALL ld_curr.setActionActive(ls_act_name,TRUE)
                  ELSE
                     CALL ld_curr.setActionHidden(ls_act_name,TRUE)
                     CALL ld_curr.setActionActive(ls_act_name,FALSE)
                  END IF
               END IF
               ###FUN-960070 END ###
            
               IF (pi_visible) THEN
                  CASE 
                     WHEN (li_i = "1")
                       #-- MOD-580073
                        CASE ls_item_name
                            WHEN "accept"
                                 CALL lnode_item.setAttribute("defaultView", "yes")
                            WHEN "cancel"
                                 CALL lnode_item.setAttribute("defaultView", "yes")
                            OTHERWISE
                                 CALL lnode_item.setAttribute("defaultView", "auto")
                        END CASE
                       #-- MOD-580073 end
                     WHEN (li_i = "2") OR (li_i = "3")
                       #-- MOD-580073
                        CASE ls_item_name
                            WHEN "accept"
                                 CALL lnode_item.setAttribute("defaultView", "yes")
                            WHEN "cancel"
                                 CALL lnode_item.setAttribute("defaultView", "yes")
                            OTHERWISE
                                 CALL lnode_item.setAttribute("defaultView", "auto")
                        END CASE
                       #-- MOD-580073 end
                        CALL lnode_item.setAttribute("hidden", "0")
                        CALL lnode_item.setAttribute("active", "1")
                     WHEN (li_i = "4")
                        CALL lnode_item.setAttribute("hidden", "0")
                        CALL lnode_item.setAttribute("active", "1")
                  END CASE
#                 IF (li_i = 1) THEN #ActionDefault
#                    CALL lnode_item.setAttribute("defaultView", "yes")
#                 ELSE
#                    CALL lnode_item.setAttribute("defaultView", "yes")
#                    CALL lnode_item.setAttribute("hidden", "0")
#                    CALL lnode_item.setAttribute("active", "1")
#                 END IF
               ELSE
                  CASE
                     WHEN (li_i = "1")
                        CALL lnode_item.setAttribute("defaultView", "no")
                     WHEN (li_i = "2") OR (li_i = "3")
                        CALL lnode_item.setAttribute("defaultView", "no")
                        CALL lnode_item.setAttribute("hidden", "1")
                        CALL lnode_item.setAttribute("active", "0")
                     WHEN (li_i = "4")
                        CALL lnode_item.setAttribute("hidden", "1")
                        CALL lnode_item.setAttribute("active", "0")
                  END CASE
#                 IF (li_i = 1) THEN #ActionDefault
#                    CALL lnode_item.setAttribute("defaultView", "no")
#                 ELSE
#                    CALL lnode_item.setAttribute("defaultView", "no")
#                    CALL lnode_item.setAttribute("hidden", "1")
#                    CALL lnode_item.setAttribute("active", "0")
#                 END IF
               END IF
 
               EXIT FOR
            END IF
         END FOR
      END WHILE
   END FOR
END FUNCTION
 

##################################################
# Descriptions...: 偵測畫面上的Action元件目前為顯示或隱藏.
# Date & Author..: 2007/06/07 by saki
# Input Parameter: ps_act_name    STRING     要偵測的Action名稱
# Return Code....: li_result      TRUE/FALSE 是否顯示
# Memo...........: No:FUN-660164  指定筆功能顯示accept/cancel
##################################################
FUNCTION cl_detect_act_visible(ps_act_name)
   DEFINE   ps_act_name     STRING,
            li_result       LIKE type_file.num5
   DEFINE   la_act_type     DYNAMIC ARRAY OF STRING,
            lnode_root      om.DomNode,
            li_i            LIKE type_file.num5,
            li_j            LIKE type_file.num5,
            llst_items      om.NodeList,
            lnode_item      om.DomNode,
            ls_item_name    STRING
 
   IF g_bgjob = 'Y' AND g_gui_type NOT MATCHES "[13]"  THEN
      #RETURN        #CHI-B60075 mark
      RETURN FALSE   #CHI-B60075
   END IF
 
   LET la_act_type[1] = "Action"
   LET la_act_type[2] = "MenuAction"
   LET la_act_type[3] = "ActionDefault"
   LET la_act_type[4] = "LocalAction"
  
   LET lnode_root = ui.Interface.getRootNode()
 
   FOR li_i = 1 TO la_act_type.getLength()
       LET llst_items = lnode_root.selectByTagName(la_act_type[li_i])
 
       FOR li_j = 1 TO llst_items.getLength()
           LET lnode_item = llst_items.item(li_j)
           LET ls_item_name = lnode_item.getAttribute("name")
           IF (ls_item_name IS NULL) THEN
              CONTINUE FOR
           END IF
 
           IF (ls_item_name.equals(ps_act_name)) THEN
              CASE 
                 WHEN (li_i = "4") OR (li_i = "1")
                    IF lnode_item.getAttribute("defaultView") = "yes" AND
                       lnode_item.getAttribute("hidden") = "0" THEN
                       LET li_result = TRUE
                    END IF
                 WHEN (li_i = "2")
                    IF lnode_item.getAttribute("hidden") = "0" THEN
                       LET li_result = TRUE
                    END IF
                 WHEN (li_i = "3")
                    IF lnode_item.getAttribute("defaultView") = "yes" THEN
                       LET li_result = TRUE
                    END IF
              END CASE
              EXIT FOR
           END IF
       END FOR
       IF li_result THEN
          EXIT FOR
       END IF
   END FOR
 
   RETURN li_result
END FUNCTION
