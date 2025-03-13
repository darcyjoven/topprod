# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: cl_set_comp_required.4gl
# Descriptions...: 動態設定元件是否需輸入值.
# Date & Author..: 03/06/30 by Hiko
# Usage..........: CALL cl_set_comp_required("m01,m03,m07", TRUE)
# Modify.........: No.FUN-690005 06/09/05 By chen 類型轉換
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-710055 07/03/07 By saki 自定義欄位功能
# Modify.........: No.TQC-740127 07/04/18 claire 背景執行時不需進入此程式
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds        #FUN-6C0017   #FUN-7C0053
 
GLOBALS "../../config/top.global"
 
 
# Descriptions...: 設定元件是否需輸入值.
# Date & Author..: 2003/06/30 by Hiko
# Input Parameter: ps_fields STRING 要設定元件是否需輸入值的欄位名稱字串(中間以逗點分隔)
#                  pi_required SMALLINT 是否需輸入值(TRUE→需要輸入值,FALSE→不需輸入值)
# Return Code....: void
# Modify.........: No.TQC-5A0065 05/10/14 設定成必要欄位的時候，欄位一定顯示在畫面上
# Modify.........: No.FUN-5A0084 05/11/02 alex color setting
# Modify.........: No.FUN-550113 05/11/03 alex Remove color in Checkbox/Radiogroup
# Modify.........: No.TQC-5B0206 05/11/29 alex Remove color in Reverse of C/R
 
FUNCTION cl_set_comp_required(ps_fields, pi_required)
  DEFINE ps_fields STRING,
         pi_required   LIKE type_file.num5              #No.FUN-690005   SMALLINT
  DEFINE lst_fields base.StringTokenizer,
         ls_field_name STRING
  DEFINE lwin_curr     ui.Window,
         lfrm_curr     ui.Form         #TQC-5A0065
  DEFINE lnode_win     om.DomNode,
         llst_items    om.NodeList,
         li_i          LIKE type_file.num5,             #No.FUN-690005  SMALLINT
         lnode_item    om.DomNode,
         lnode_child   om.DomNode,     #FUN-550113
         ls_item_name  STRING
  
  IF (ps_fields IS NULL) THEN RETURN END IF
 
  #TQC-740127-begin-add
  IF g_bgjob = 'Y' AND g_gui_type NOT MATCHES "[13]"  THEN 
     RETURN
  END IF
  #TQC-740127-end-add
 
  LET ps_fields = ps_fields.toLowerCase()
 
  LET lst_fields = base.StringTokenizer.create(ps_fields, ",")
 
  LET lwin_curr = ui.Window.getCurrent()
  LET lfrm_curr = lwin_curr.getForm()       #No.TQC-5A0065
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
              CONTINUE FOR
           END IF
           
           LET ls_item_name = ls_item_name.trim()
  
           IF (ls_item_name.equals(ls_field_name)) THEN
              IF (pi_required) THEN
                 CALL lfrm_curr.setFieldHidden(ls_field_name,0)  #TQC-5A0065
                 CALL lnode_item.setAttribute("required", "1")
                 CALL lnode_item.setAttribute("notNull", "1")
                 IF lnode_item.getTagName() = "FormField" THEN   #FUN-5A0084
                    LET lnode_child = lnode_item.getFirstChild() #FUN-550113
                    IF lnode_child IS NOT NULL AND 
                       lnode_child.getTagName() <> "CheckBox" AND
                       lnode_child.getTagName() <> "RadioGroup" THEN
                       #No.FUN-710055 --start-- demo中
#                      CALL lfrm_curr.setFieldStyle(ls_field_name,"bgcolor_"||g_gas.gas02 CLIPPED)
                       CALL lfrm_curr.setFieldStyle(ls_field_name,"inputbgcolor_"||g_gas.gas02 CLIPPED)
                       #No.FUN-710055 ---end---
                    END IF
                 ELSE
                    #No.FUN-710055 --start-- demo中
#                   CALL lfrm_curr.setFieldStyle(ls_field_name,"bgcolor_"||g_gas.gas03 CLIPPED)
                    CALL lfrm_curr.setFieldStyle(ls_field_name,"inputbgcolor_"||g_gas.gas03 CLIPPED)
                    #No.FUN-710055 ---end---
                 END IF
              ELSE
                 CALL lnode_item.setAttribute("required", "0")
                 CALL lnode_item.setAttribute("notNull", "0")
                 IF lnode_item.getTagName() = "FormField" THEN   #TQC-5B0206
                    LET lnode_child = lnode_item.getFirstChild()
                    IF lnode_child IS NOT NULL AND
                       lnode_child.getTagName() <> "CheckBox"   AND
                       lnode_child.getTagName() <> "RadioGroup" THEN
                       #No.FUN-710055 --start-- demo中
#                      CALL lfrm_curr.setFieldStyle(ls_field_name,"bgcolor_white")
                       CALL lfrm_curr.setFieldStyle(ls_field_name,"inputbgcolor_white")
                       #No.FUN-710055 ---end---
                    END IF
                 ELSE
                    #No.FUN-710055 --start-- demo中
#                   CALL lfrm_curr.setFieldStyle(ls_field_name,"bgcolor_white")
                    CALL lfrm_curr.setFieldStyle(ls_field_name,"inputbgcolor_white")
                    #No.FUN-710055 ---end---
                 END IF
              END IF
           
              EXIT FOR
           END IF
       END FOR
    END IF
  END WHILE
END FUNCTION
