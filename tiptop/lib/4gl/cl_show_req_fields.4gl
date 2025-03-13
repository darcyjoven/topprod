# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: cl_show_req_fields.4gl
# Descriptions...: 顯現畫面上需要輸入卻還未輸入的所有欄位.
# Date & Author..: 2003/07/03 by Hiko
# Usage..........: CALL cl_show_req_fields()
# Modify.........: No.MOD-4C0051 04/12/13 by saki 找不到value的節點暫時以錯誤訊息警告
# Modify.........: No.FUN-690005 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds        #FUN-6C0017   #FUN-7C0053
 
GLOBALS "../../config/top.global"
 
 
# Descriptions...: 顯現畫面上需要輸入卻還未輸入的所有欄位.
# Date & Author..: 2003/07/03 by Hiko
# Input Parameter: none
# Return Code....: void
 
 
FUNCTION cl_show_req_fields()
  DEFINE lnode_root om.DomNode,
         llst_items om.NodeList,
         ls_warning,ls_master_warning,ls_detail_warning STRING
  DEFINE ls_msg     LIKE ze_file.ze03
  DEFINE ls_nonode_flag LIKE type_file.num5          #No.FUN-690005 SMALLINT
  
  LET lnode_root = ui.Interface.getRootNode()
  LET llst_items = lnode_root.selectByTagName("FormField")
  CALL cl_chk_master_req(llst_items) RETURNING ls_master_warning
  LET llst_items = lnode_root.selectByTagName("TableColumn")
  CALL cl_chk_detail_req(llst_items) RETURNING ls_nonode_flag,ls_detail_warning
 
  IF (ls_master_warning IS NOT NULL) THEN
     LET ls_warning = ls_master_warning
  END IF
     
   IF (ls_detail_warning IS NOT NULL) AND (NOT ls_nonode_flag) THEN  #MOD-4C0051
     IF (ls_warning IS NOT NULL) THEN
        LET ls_warning = ls_warning || "\n" ||
                        "--------------------" || "\n"
     END IF
 
     LET ls_warning = ls_warning,ls_detail_warning
  ELSE
     IF (ls_nonode_flag) THEN
        SELECT ze03 INTO ls_msg FROM ze_file WHERE ze01 = 'lib-220' AND ze02 = g_lang
        LET ls_warning = ls_warning,ls_msg CLIPPED
     END IF
  END IF
 
  IF (ls_warning IS NULL) THEN
     SELECT ze03 INTO ls_msg FROM ze_file WHERE ze01 = 'lib-032' AND ze02 = g_lang
     LET ls_warning = ls_msg CLIPPED
  END IF
 
  MENU "Exclamation" ATTRIBUTE(STYLE="dialog", COMMENT=ls_warning, IMAGE="exclamation")
    ON ACTION ok
       EXIT MENU
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE MENU
  
  END MENU
END FUNCTION
 
##################################################
# Descriptions...: 檢查單頭需要輸入卻還未輸入的所有欄位.
# Date & Author..: 2003/07/03 by Hiko
# Input Parameter: plst_items <FormField>串列
# Return Code....: void
##################################################
 
FUNCTION cl_chk_master_req(plst_items)
  DEFINE plst_items om.NodeList
  DEFINE lsb_master base.StringBuffer,
         ls_warning_locale,ls_warning STRING
  DEFINE li_i LIKE type_file.num5,          #No.FUN-690005 SMALLINT,
         lnode_item,lnode_item_child,lnode_label om.DomNode,
         ls_item_name,ls_item_child_tag,ls_item_value,ls_item_text STRING,
         lc_required LIKE type_file.chr1          #No.FUN-690005 VARCHAR(1) 
  DEFINE ls_msg      LIKE ze_file.ze03
 
  LEt lsb_master = base.StringBuffer.create()
 
  FOR li_i = 1 TO plst_items.getLength()
      LET lnode_item = plst_items.item(li_i)
      # 2003/05/21 By Hiko : 可輸入欄位都有'colName'屬性.
      LET ls_item_name = lnode_item.getAttribute("colName")
 
      IF (ls_item_name IS NULL) THEN
         CONTINUE FOR
      END IF
 
      LET lc_required = lnode_item.getAttribute("required")
      # 2003/05/23 By Hiko : 其實以預設的per上的屬性設定來看,有設定REQUIRED,其值一定為1.
      IF ((lc_required IS NOT NULL) AND (lc_required = "1")) THEN
         # 2003/06/11 by hiko : 要先判斷此欄位是哪一種元件,以此為依據去抓取對應的LABEL之text.
         LET lnode_item_child = lnode_item.getFirstChild()
         LET ls_item_child_tag = lnode_item_child.getTagName()
         # 2003/05/26 By Hiko : 將ls_item_text重設為NULL,是為了初始化資料,避免沒有text時,會顯現上一元件的text.
         LET ls_item_text = NULL
 
         IF (ls_item_child_tag.equals("CheckBox")) THEN
            LET ls_item_text = lnode_item_child.getAttribute("text")
         ELSE
            LET lnode_label = lnode_item.getPrevious()
  
            IF (lnode_label IS NOT NULL) THEN
               LET ls_item_child_tag = lnode_label.getTagName()
              
               IF (ls_item_child_tag.equals("Label")) THEN
                  LET ls_item_text = lnode_label.getAttribute("text")
               END IF
            END IF
         END IF
 
         # 2003/05/23 By Hiko : 需要輸入的欄位都會有value屬性. 
         LET ls_item_value = lnode_item.getAttribute("value")
 
         IF (ls_item_value IS NULL) THEN
            CONTINUE FOR
         END IF
 
         LET ls_item_value = ls_item_value.trim()
 
         IF (ls_item_value.equals("")) THEN
            IF (lsb_master.getLength() = 0) THEN
               CALL lsb_master.append("Master :" || "\n")
            END IF
 
            CALL lsb_master.append(ls_item_text || "\n")
         END IF
      END IF
  END FOR
 
  IF (lsb_master.getLength() > 0) THEN
     SELECT ze03 INTO ls_msg FROM ze_file WHERE ze01 = 'lib-033' AND ze02 = g_lang
     LET ls_warning_locale = ls_msg CLIPPED
#    CASE g_lang
#      WHEN "0" LET ls_warning_locale = "為必要輸入欄位."
#      WHEN "1" LET ls_warning_locale = "must key in value."
#      WHEN "2" LET ls_warning_locale = "為必要輸入欄位."
#    END CASE
 
     LET ls_warning = lsb_master.toString() || ls_warning_locale || "\n"
  END IF
 
  RETURN ls_warning
END FUNCTION
 
##################################################
# Descriptions...: 檢查單身需要輸入卻還未輸入的所有欄位.
# Date & Author..: 2003/07/03 by Hiko
# Input Parameter: plst_items <TableColumn>串列
# Return Code....: void
##################################################
 
FUNCTION cl_chk_detail_req(plst_items)
  DEFINE plst_items om.NodeList
  DEFINE lsb_detail base.StringBuffer,
         ls_warning_locale,ls_warning STRING
  DEFINE li_i LIKE type_file.num5,          #No.FUN-690005 SMALLINT,
         lnode_item,lnode_value_list,lnode_value om.DomNode,
         ls_item_name,ls_item_value,ls_item_text STRING,
         lc_required LIKE type_file.chr1,          #No.FUN-690005 VARCHAR(1),
         lst_value om.NodeList 
  DEFINE ls_msg    LIKE ze_file.ze03
  DEFINE li_curr   LIKE type_file.num5          #No.FUN-690005 SMALLINT
  DEFINE li_show_curr LIKE type_file.num5          #No.FUN-690005 SMALLINT
  DEFINE lnode_parent om.DomNode
  DEFINE li_offset    LIKE type_file.num5          #No.FUN-690005 SMALLINT
  DEFINE li_pagesize  LIKE type_file.num5          #No.FUN-690005 SMALLINT
  DEFINE ls_nonode    LIKE type_file.num5          #No.FUN-690005 SMALLINT
  DEFINE ls_type      STRING
  DEFINE li_master_flag LIKE type_file.num5          #No.FUN-690005 SMALLINT
 
 
  LEt lsb_detail = base.StringBuffer.create()
 
  FOR li_i = 1 TO plst_items.getLength()
      LET lnode_item = plst_items.item(li_i)
      LET lnode_parent = lnode_item.getParent()
      LET ls_type = lnode_parent.getAttribute("dialogType")
      IF ls_type.equals("DisplayArray") THEN
         LET ls_nonode = FALSE
         LET li_master_flag = TRUE
         EXIT FOR
      END IF
      LET li_curr = lnode_parent.getAttribute("currentRow")
      LET li_offset = lnode_parent.getAttribute("offset")
      LET li_pagesize = lnode_parent.getAttribute("pageSize")
 
      # 2003/05/21 By Hiko : 可輸入欄位都有'colName'屬性.
      LET ls_item_name = lnode_item.getAttribute("colName")
 
      IF (ls_item_name IS NULL) THEN
         CONTINUE FOR
      END IF
 
      LET lc_required = lnode_item.getAttribute("required")
      # 2003/05/23 By Hiko : 其實以預設的per上的屬性設定來看,有設定REQUIRED,其值一定為1.
      IF ((lc_required IS NOT NULL) AND (lc_required = "1")) THEN
         LET ls_item_text = lnode_item.getAttribute("text")
         # 2003/05/21 By Hiko : 如果所要檢查的欄位是單身的話,則value的部分要抓到其孫子級的節點.
         LET lnode_value_list = lnode_item.getLastChild()
         LET lst_value = lnode_value_list.selectByTagName("Value")
         # 2004/06/30 by saki : 程式一開始ARR_CURR()為0會有錯誤
#        IF (ARR_CURR() = 0) THEN
#           LET li_curr = ARR_CURR() + 1
#        ELSE
#           LET li_curr = ARR_CURR()
#        END IF
#        LET lnode_value = lst_value.item(li_curr)
          # MOD-4C0051 by saki : 只有顯示在畫面上的row才能被擷取到值
         LET li_show_curr = li_curr - li_offset + 1
         IF (li_curr >= li_offset) AND (li_curr < li_offset + li_pagesize) AND 
            (li_show_curr != 0) THEN
            LET lnode_value = lst_value.item(li_show_curr)
            # 2003/05/23 By Hiko : 需要輸入的欄位都會有value屬性. 
            LET ls_item_value = lnode_value.getAttribute("value")
         ELSE
            LET ls_nonode = TRUE
            EXIT FOR
         END IF
 
         IF (ls_item_value IS NULL) THEN
            CONTINUE FOR
         END IF
 
         LET ls_item_value = ls_item_value.trim()
  
         IF (ls_item_value.equals("")) THEN
            IF (lsb_detail.getLength() = 0) THEN
               CALL lsb_detail.append("Detail :" || "\n")
            END IF
 
            CALL lsb_detail.append(ls_item_text || "\n")
         END IF
      END IF
  END FOR
 
  IF (lsb_detail.getLength() > 0) THEN
     SELECT ze03 INTO ls_msg FROM ze_file WHERE ze01 = 'lib-033' AND ze02 = g_lang
     LET ls_warning_locale = ls_msg CLIPPED
#    CASE g_lang
#      WHEN "0" LET ls_warning_locale = "為必要輸入欄位."
#      WHEN "1" LET ls_warning_locale = "must key in value."
#      WHEN "2" LET ls_warning_locale = "為必要輸入欄位."
#    END CASE
 
     LET ls_warning = lsb_detail.toString() || ls_warning_locale || "\n"
  ELSE
     IF (li_master_flag) THEN
        LET ls_warning = " "
     END IF
  END IF
 
  RETURN ls_nonode,ls_warning
END FUNCTION
