# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: cl_dynamic_locale.4gl
# Descriptions...: 動態轉換畫面語言別.
# Memo...........: 
# Date & Author..: 03/11/06 by Hiko
# Modify.........: 05/01/13 by Brendan Automatically doing BIG5/GB2312 conversion 
# Modify.........: No.MOD-540082 05/04/12 By Brendan Fix BIG5/GB2312 can't automatically switch in HP-UX
# Modify.........: No.MOD-540177 05/04/26 By Brendan Fix BIG5/GB2312 switch issue under direct connection(telnet)
# Modify.........: No.MOD-550021 05/05/05 By Brendan Take GBK/GB18030 into account.
# Modify.........: No.TQC-5B0117 05/11/18 By Echo 直接執行整合單據，切換語別後簽核的按紐應不能顯示...
# Modify.........: No.FUN-660169 06/08/04 By saki 增加語言別切換控制選項
# Modify.........: No.MOD-680048 06/08/16 By Alexstar 在簡體操作系統下從繁體切換到簡體會切不過來
# Modify.........: No.FUN-680095 06/09/19 By Alexstar 在執行程式前讀取不到p_perlang相關語言資料時,
#                                                      open window顯示[讀取不到xxxx語言畫面介面資料,所以將以預設的xxx語言顯示畫面]
# Modify.........: No.FUN-690005 06/09/15 By chen 類型轉換
# Modify.........: No.FUN-640161 07/01/16 BY Yiting cl_err->cl_err3
# Modify.........: No.FUN-770022 07/07/11 By Echo 非標準整合單據時，隱藏"EasyFlow 送簽","簽核狀況" Action
# Modify.........: No.FUN-7B0109 07/12/10 By Brendan 簡繁轉碼功能調整
# Modify.........: No.FUN-830021 08/03/05 By alex 取消gay02欄位使用
# Modify.........: No.TQC-A30157 10/03/30 By joyce 取消HIDE寫法，改用CALL DIALOG.setActionHidden()
# Modify.........: No.FUN-B30004 11/03/07 By jrg542 檢查是否有購買語言包licence

DATABASE ds
 
GLOBALS "../../config/top.global"
 
GLOBALS
   DEFINE mi_call_by_dynamic_locale   LIKE type_file.num5           #No.FUN-690005 SMALLINT
 
#----------
# FUN-510030
#----------
   DEFINE ms_locale                   STRING,
          ms_codeset                  STRING,
          ms_b5_gb                    STRING
#----------
 
END GLOBALS
 
DEFINE gr_gay   DYNAMIC ARRAY OF RECORD
                  gay01   LIKE gay_file.gay01,
                  gay03   LIKE gay_file.gay03
                END RECORD
DEFINE gi_cnt   LIKE type_file.num10          #No.FUN-690005 INTEGER
DEFINE gw_win   ui.Window
DEFINE gn_win   om.DomNode
 
CONSTANT TIMEOUT INTEGER = 300
 
##########################################################################
# Descriptions...: 動態轉換畫面語言別.
# Memo...........: 
# Input parameter: none
# Return code....: void
# Usage..........: CALL cl_dynamic_locale()
# Date & Author..: 2003/11/06 by Hiko
# Modify.........: 
##########################################################################
FUNCTION cl_dynamic_locale()
   DEFINE p_g_lang     LIKE type_file.chr1           #No.FUN-690005 VARCHAR(1)
   DEFINE ls_lang      STRING,
          ls_hide      STRING                        #FUN-510030
   DEFINE li_i         LIKE type_file.num10          #No.FUN-690005 INTEGER
   DEFINE lch_file     base.Channel                  #FUN-510030
   DEFINE ls_notify    STRING                        #FUN-510030
   DEFINE ls_udm7      STRING                        #MOD-540177
   DEFINE lc_zx15      LIKE zx_file.zx15             #No.FUN-660169
   DEFINE l_cnt        LIKE type_file.num10          #FUN-770022
   DEFINE l_str        STRING                        #FUN-B30004

   WHENEVER ERROR CALL cl_err_msg_log
 
   LET p_g_lang = g_lang
 
   #No.FUN-660169 --start--
   SELECT zx15 INTO lc_zx15 FROM zx_file WHERE zx01 = g_user
   IF NOT cl_null(lc_zx15) AND 
      ((lc_zx15 = "1") OR ((lc_zx15 = "2") AND (g_prog != "udm_tree"))) THEN
      CALL cl_err("","lib-352",0)
      RETURN
   END IF
   #No.FUN-660169 ---end---
 
#----------
# FUN-510030
#----------
   LET ls_hide = NULL
  #----------
   # MOD-540082
   # MOD-550021
  #----------
   IF ( ms_codeset.getIndexOf("BIG5", 1) OR 
        ( ms_codeset.getIndexOf("GB2312", 1) OR ms_codeset.getIndexOf("GBK", 1) OR ms_codeset.getIndexOf("GB18030", 1) ) ) AND 
      g_prog CLIPPED != "udm_tree" THEN
  #----------
      CASE g_lang
           WHEN '0'
                LET ls_hide = "lang_2"
           WHEN '2'
                LET ls_hide = "lang_0"
           WHEN '1'
                IF ms_b5_gb = "BIG5" THEN
                   LET ls_hide = "lang_2"
                   EXIT CASE
                END IF
                IF ms_b5_gb = "GB2312" OR ms_b5_gb = "GBK" THEN   #No.FUN-7B0109
                   LET ls_hide = "lang_0"
                   EXIT CASE
                END IF
                IF ms_locale = "ZH_TW" THEN
                   LET ls_hide = "lang_2"
                   EXIT CASE
                END IF
                IF ms_locale = "ZH_CN" THEN
                   LET ls_hide = "lang_0"
                   EXIT CASE
                END IF
           OTHERWISE                                  #FUN-680095   
                IF ms_b5_gb = "BIG5" THEN
                   LET ls_hide = "lang_2"
                   EXIT CASE
                END IF
                IF ms_b5_gb = "GB2312" OR ms_b5_gb = "GBK" THEN   #No.FUN-7B0109
                   LET ls_hide = "lang_0"
                   EXIT CASE
                END IF
                IF ms_locale = "ZH_TW" THEN
                   LET ls_hide = "lang_2"
                   EXIT CASE
                END IF
                IF ms_locale = "ZH_CN" THEN
                   LET ls_hide = "lang_0"
                   EXIT CASE
                END IF
      END CASE
   END IF
#----------
 
--Retrieve how many locale settings has been defined
   DECLARE locale_cs CURSOR FOR
    SELECT gay01, gay03 FROM gay_file WHERE gayacti = "Y" ORDER BY gay01
#    WHERE gay02 = g_lang ORDER BY gay01    #FUN-830021
   IF SQLCA.SQLCODE THEN
      CALL cl_err("gay_file", "lib-044", 1)
      RETURN
   END IF
   LET gi_cnt = 1
   FOREACH locale_cs INTO gr_gay[gi_cnt].*
       LET gi_cnt = gi_cnt + 1
   END FOREACH
   CALL gr_gay.deleteElement(gi_cnt)
   LET gi_cnt = gi_cnt - 1
   IF gi_cnt = 1 THEN
      CALL cl_err("gay_file", "lib-044", 1)
      RETURN
   END IF
--#
 
   LET gw_win = ui.Window.getCurrent()
   LET gn_win = gw_win.getNode()
 
   MENU "locale" ATTRIBUTE(STYLE="popup")
         BEFORE MENU
            #HIDE OPTION ALL    # mark by No:TQC-A30157

             # No:TQC-A30157 ---start---
             # 先將預設的語言別全部隱藏起來
             FOR li_i = 1 TO 10
                LET ls_lang = (li_i - 1)
                LET ls_lang = "lang_",ls_lang.trim()
                CALL DIALOG.setActionHidden(ls_lang,1)   # 1 表示隱藏   0 表示顯示
             END FOR
             # No:TQC-A30157 --- end ---

             FOR li_i = 1 TO gi_cnt
                 IF gr_gay[li_i].gay01 CLIPPED <> g_lang CLIPPED THEN
                    LET ls_lang = "lang_" || gr_gay[li_i].gay01 CLIPPED
                   #SHOW OPTION ls_lang    # mark by No:TQC-A30157
                    CALL DIALOG.setActionHidden(ls_lang,0)   # add by No:TQC-A30157
                 END IF
 
               #----------
               # FUN-510030
               #----------
                 IF ls_hide IS NOT NULL THEN
                   #HIDE OPTION ls_hide   # mark by No:TQC-A30157
                    CALL DIALOG.setActionHidden(ls_hide,0)   # add by No:TQC-A30157
                 END IF
               #----------
 
             END FOR
             CALL cl_setLocaleOption()
 
         ON ACTION lang_0
             LET g_lang = '0'
             EXIT MENU
 
         ON ACTION lang_1
             LET g_lang = '1'
             EXIT MENU
 
         ON ACTION lang_2
             LET g_lang = '2'
             EXIT MENU
 
         ON ACTION lang_3
             LET g_lang = '3'
             EXIT MENU
 
         ON ACTION lang_4
             LET g_lang = '4'
             EXIT MENU
 
         ON ACTION lang_5
             LET g_lang = '5'
             EXIT MENU
 
         ON ACTION lang_6
             LET g_lang = '6'
             EXIT MENU
 
         ON ACTION lang_7
             LET g_lang = '7'
             EXIT MENU
 
         ON ACTION lang_8
             LET g_lang = '8'
             EXIT MENU
 
         ON ACTION lang_9
             LET g_lang = '9'
             EXIT MENU
 
         ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE MENU
   END MENU
 
   IF INT_FLAG THEN
      LET INT_FLAG = FALSE
   ELSE
      #FUN-B30004 start
      CALL cl_system_allow_langs() RETURNING l_str
      #LET l_str = cl_system_allow_langs()    #取得語言包license
      #DISPLAY "l_str=",l_str
      CASE
          #WHEN g_lang = '0' OR '2' #繁體、簡體不判斷
               #EXIT CASE
          WHEN g_lang = '1'
               IF l_str.getIndexOf("English",1) <= 0  THEN   #英文
                  CALL cl_err('','lib-512',1)  #錯誤訊息提示 沒有語言包licence
                  RETURN
               END IF
          WHEN g_lang = '3'
          IF l_str.getIndexOf("Japenese",1) <= 0  THEN  #日文
                  CALL cl_err('','lib-512',1)  #錯誤訊息提示 沒有語言包licence
                  RETURN
               END IF
          WHEN g_lang = '4'
               IF l_str.getIndexOf("Vinetnam",1) <=0  THEN   #越南文
                  CALL cl_err('','lib-512',1)  #錯誤訊息提示 沒有語言包licence
                  RETURN
               END IF
          WHEN g_lang = '5'
               IF l_str.getIndexOf("Thai",1) <= 0  THEN      #泰文
                  CALL cl_err('','lib-512',1)  #錯誤訊息提示 沒有語言包licence
                  RETURN
               END IF
          OTHERWISE
               EXIT CASE
      END CASE
      #FUN-B30004 END
      IF p_g_lang != g_lang THEN
         LET mi_call_by_dynamic_locale = TRUE
         UPDATE zx_file SET zx06 = g_lang WHERE zx01 = g_user
         IF STATUS THEN
            CALL cl_err3("upd","zx_file",g_user,"",STATUS,"","Update Language Setting",0)   #No.FUN-640161
            #CALL cl_err("Update Language Setting",STATUS,1)
         ELSE
            LET g_rlang=g_lang
         END IF
 
       #----------
       # FUN-510030
       #----------
        #----------
         # MOD-540082
         # MOD-550021
        #----------
         IF ms_codeset.getIndexOf("BIG5", 1) OR 
            ( ms_codeset.getIndexOf("GB2312", 1) OR ms_codeset.getIndexOf("GBK", 1) OR ms_codeset.getIndexOf("GB18030", 1) ) THEN
        #----------
            IF g_prog CLIPPED = "udm_tree" THEN
               IF ( ms_locale = "ZH_TW" AND g_lang = '2' AND ( ( ms_b5_gb != "GB2312" AND ms_b5_gb != "GBK" ) OR ms_b5_gb IS NULL ) ) OR   #No.FUN-7B0109 加入 GBK 判斷
                  ( ms_locale = "ZH_CN" AND g_lang = '0' AND ( ms_b5_gb != "BIG5" OR ms_b5_gb IS NULL ) ) OR
                  ( ms_locale = "ZH_TW" AND g_lang = '0' AND ms_b5_gb IS NOT NULL ) OR
                  ( ms_locale = "ZH_TW" AND g_lang = '2' AND ms_b5_gb IS NOT NULL ) OR
                  ( ms_locale = "ZH_CN" AND g_lang = '2' AND ms_b5_gb IS NOT NULL ) THEN  #MOD-680048
                 #--- MOD-540177
                  LET ls_udm7 = FGL_GETENV("UDM7")   #Set by udm7 shell
                  IF ls_udm7 IS NULL OR ls_udm7 != 'Y' THEN
                #----------
                     LET ls_notify = FGL_GETPID()
                     RUN "rm -f " || ls_notify
                     CALL cl_cmdrun("udm_tree '' " || ls_notify)
                 
                     LET lch_file = base.Channel.create()
                     FOR li_i = 1 TO TIMEOUT
                         CALL lch_file.openFile(ls_notify, "r")
                         IF NOT STATUS THEN
                            RUN "rm -rf " || ls_notify
                            EXIT FOR
                         END IF
                         SLEEP 1
                     END FOR
                     CALL lch_file.close()
                  END IF
                 #--- MOD-540177
                  IF ls_udm7 = "Y" THEN
                     EXIT PROGRAM (g_lang + 10)
                  ELSE
                     EXIT PROGRAM
                  END IF
                #----------
               END IF
            END IF
         END IF
       #----------
 
         --CALL cl_call_by_dynamic_locale()
         CALL cl_ui_init()
         CALL cl_changeDialogText()
      END IF
   END IF
   LET mi_call_by_dynamic_locale = FALSE
   LET g_dyloc2sfld = TRUE
 
   #TQC-5B0117
   CALL cl_set_act_visible("agree, deny, modify_flow, withdraw, org_withdraw, phrase", FALSE)
   #END TQC-5B0117
   #FUN-640181---start---
   SELECT COUNT(*) INTO l_cnt FROM wsd_file WHERE wsd01 = g_prog  #FUN-770022
   IF g_aza.aza23 matches '[ Nn]' OR l_cnt = 0 THEN               #FUN-770022
      CALL cl_set_act_visible("easyflow_approval,approval_status",FALSE)
   END IF
   #FUN-640181---end---
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
# Descriptions...: 轉換選單的多語言名稱
# Memo...........:
# Input parameter: none
# Return code....: none
# Usage..........: CALL cl_changeDialogText()
# Date & Author..: 2003/11/06 by Hiko
# Modify.........: 
##########################################################################
FUNCTION cl_changeDialogText()
  DEFINE lw_win              ui.Window
  DEFINE ln_root             om.DomNode,
         ln_win              om.DomNode,
         ln_action           om.DomNode
  DEFINE lst_actionDefault   om.NodeList,
         lst_action          om.NodeList
  DEFINE li_i                LIKE type_file.num10,          #No.FUN-690005 INTEGER
         li_j                LIKE type_file.num10,          #No.FUN-690005 INTEGER
         li_cnt              LIKE type_file.num10           #No.FUN-690005 INTEGER
  DEFINE ls_name             STRING
  DEFINE la_actionDefault    DYNAMIC ARRAY OF RECORD
                                name      STRING,
                                text      STRING,
                                comment   STRING
                             END RECORD
 
 
--Keep all current ActionDefaults setting, for later replacing
  LET ln_root = ui.Interface.getRootNode()
  LET lst_actionDefault = ln_root.selectByTagName("ActionDefault")
  FOR li_i = 1 TO lst_actionDefault.getLength()
      LET ln_action = lst_actionDefault.item(li_i)
      LET la_actionDefault[li_i].name = ln_action.getAttribute("name")
      LET la_actionDefault[li_i].text = ln_action.getAttribute("text")
      LET la_actionDefault[li_i].comment = ln_action.getAttribute("comment")
  END FOR
  LET li_cnt = li_i - 1
--#
 
--Replace text of Action node of dialog, respectively
  LET lst_action = gn_win.selectByTagName("MenuAction")
  IF lst_action.getLength() = 0 THEN
     LET lst_action = gn_win.selectByTagName("Action")
  END IF
  FOR li_i = 1 TO lst_action.getLength()
      LET ln_action = lst_action.item(li_i)
      LET ls_name = ln_action.getAttribute("name")
      FOR li_j = 1 TO li_cnt
          IF ls_name = la_actionDefault[li_j].name THEN
             CALL ln_action.setAttribute("text", la_actionDefault[li_j].text)
             CALL ln_action.setAttribute("comment", la_actionDefault[li_j].comment)
             EXIT FOR
          END IF
      END FOR
  END FOR
--# 
 
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
# Descriptions...: 轉換多語言選單的多語言名稱
# Memo...........:
# Input parameter: none
# Return code....: void
# Usage..........: CALL cl_setLocaleOption()
# Date & Author..: 2003/11/06 by Hiko
# Modify.........: 
##########################################################################
FUNCTION cl_setLocaleOption()
  DEFINE ln_menu         om.DomNode,
         ln_menuAction   om.DomNode
  DEFINE ll_menu         om.NodeList,
         ll_menuAction   om.NodeList
  DEFINE li_i            LIKE type_file.num10,          #No.FUN-690005 INTEGER
         li_j            LIKE type_file.num10           #No.FUN-690005 INTEGER
 
 
  LET ll_menu = gn_win.selectByPath("//Menu[@text=\"locale\"]")
  LET ln_menu = ll_menu.item(1)
  IF ln_menu IS NULL THEN
     RETURN
  END IF
  LET ll_menuAction = ln_menu.selectByTagName("MenuAction")
  FOR li_i = 1 TO ll_menuAction.getLength()
      LET ln_menuAction = ll_menuAction.item(li_i)
      FOR li_j = 1 TO gi_cnt
          IF gr_gay[li_j].gay01 CLIPPED = g_lang CLIPPED THEN
             CONTINUE FOR
          END IF
          IF ln_menuAction.getAttribute("name") = "lang_" || gr_gay[li_j].gay01 CLIPPED THEN
             CALL ln_menuAction.setAttribute("text", gr_gay[li_j].gay03 CLIPPED)
          END IF
      END FOR
  END FOR
END FUNCTION
