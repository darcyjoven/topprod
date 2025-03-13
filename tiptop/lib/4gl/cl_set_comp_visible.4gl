# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: cl_set_comp_visible.4gl
# Descriptions...: 動態顯現/隱藏畫面上的元件.
# Date & Author..: 03/06/26 by Hiko
# Usage..........: CALL cl_set_comp_visible("oea01,oea04", FALSE)
# Modify.........: No.FUN-4B0078 04/11/29 saki 若為必要欄位, 則不可隱藏, 但可在p_per自由格式設定輸入hidden強制隱藏
# Modify.........: No.MOD-4C0124 04/12/20 saki 上述拿掉
# Modify.........: No.FUN-550113 05/05/26 alex 新增 Label
# Modify.........: No.FUN-640184 06/04/12 Echo 自動執行確認功能
# Modify.........: No.FUN-690005 06/09/05 By chen 類型轉換
# Modify.........: No.FUN-570225 07/01/23 By saki 程式串查功能
# Modify.........: No.TQC-710024 07/04/04 by claire 修改當 GUI 模式時, always 顯示錯誤訊息(無論 g_bgjob 是否設為 'Y') 為TQC-630101再補充
# Modify.........: No.MOD-750003 07/05/01 By saki 搜尋Form以當下的視窗為主
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-A10029 10/01/06 By alex 抓取formname 含.tmp字樣時自動刪除
# Modify.........: No:FUN-B80041 11/08/04 By jacklai 可在4gl指定GR報表樣板,增加可隱藏的物件
 
DATABASE ds      #FUN-7C0053
 
GLOBALS "../../config/top.global"                 #FUN-640184
 
# Descriptions...: 顯現/隱藏畫面上的元件.
# Date & Author..: 2003/06/26 by Hiko
# Input Parameter: ps_fields STRING 要顯現/隱藏元件的欄位名稱字串(中間以逗點分隔)
#                  pi_visible SMALLINT 是否顯現(TRUE→顯現,FALSE→隱藏)
# Return Code....: void
# Modify.........: 04/04/23 saki 若是FormField欄位前有跟Label的敘述要一併顯示或隱藏
 
FUNCTION cl_set_comp_visible(ps_fields, pi_visible)
   DEFINE   ps_fields       STRING,
            pi_visible      LIKE type_file.num5             #No.FUN-690005  SMALLINT
   DEFINE   lst_fields      base.StringTokenizer,
            ls_field_name   STRING  
   DEFINE   lnode_root      om.DomNode,
            llst_items      om.NodeList,
            li_i            LIKE type_file.num5,            #No.FUN-690005  SMALLINT
            lnode_item      om.DomNode,
            lnode_prev      om.DomNode,
            ls_item_name    STRING,
            ls_prev_name    STRING,                         #No.FUN-570225
            ls_item_tag     STRING,
            ls_prev_tag     STRING
   DEFINE   lwin_curr       ui.Window,
            lfrm_curr       ui.Form
   DEFINE   lnode_frm       om.DomNode
   DEFINE   ls_formName     STRING
   DEFINE   li_idx          LIKE type_file.num5             #No.FUN-690005  SMALLINT
   DEFINE   li_gav_cnt      LIKE type_file.num5             #No.FUN-690005  SMALLINT
   DEFINE   lc_cust_flag    LIKE type_file.chr1             #No.FUN-690005  VARCHAR(1)
   DEFINE   ls_gav09        LIKE gav_file.gav09
   DEFINE   ls_notNull      STRING,
            ls_required     STRING
   DEFINE   ls_gav01        LIKE gav_file.gav01,
            ls_gav02        LIKE gav_file.gav02
           
   #FUN-640184
   IF g_bgjob = 'Y'
      AND g_gui_type NOT MATCHES "[13]"  THEN   #TQC-710024 add
      RETURN
   END IF
   #END FUN-640184
 
   IF (ps_fields IS NULL) THEN
      RETURN
   ELSE
      LET ps_fields = ps_fields.toLowerCase()
   END IF
 
   LET lwin_curr = ui.Window.getCurrent()
   LET lfrm_curr = lwin_curr.getForm()
   LET lnode_frm = lfrm_curr.getNode()
   LET lnode_root = ui.Interface.getRootNode()
   #No.MOD-750003 --start--
#  LET llst_items = lnode_root.selectByPath("//Form//*")    
   LET llst_items = lnode_frm.selectByPath("//Form//*")
   #No.MOD-750003 ---end---
   LET lst_fields = base.StringTokenizer.create(ps_fields, ",")
 
   # FUN-4B0078 
   LET ls_formName = lnode_frm.getAttribute("name")
   LET li_idx = ls_formName.getIndexOf(".tmp", 1)     #FUN-A10029
   IF li_idx != 0 THEN
      LET ls_formName = ls_formName.subString(1, li_idx - 1)
   END IF
   LET li_idx = ls_formName.getIndexOf("T", 1)
   IF li_idx != 0 THEN
      LET ls_formName = ls_formName.subString(1, li_idx - 1)
   END IF
   LET ls_gav01 = ls_formName
 
   SELECT COUNT(*) INTO li_gav_cnt FROM gav_file
    WHERE gav01 = ls_gav01 AND gav08 = 'Y'
   IF li_gav_cnt > 0 THEN
      LET lc_cust_flag = "Y"
   ELSE
      LET lc_cust_flag = "N"
   END IF
   # ---
 
   WHILE lst_fields.hasMoreTokens() 
      LET ls_field_name = lst_fields.nextToken()
      LET ls_field_name = ls_field_name.trim()
      LET ls_gav02 = ls_field_name
      
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
            LET ls_item_tag = lnode_item.getTagName()
            
            IF (ls_item_tag.equals("Group") OR
                ls_item_tag.equals("Grid") OR
                ls_item_tag.equals("Folder") OR
                ls_item_tag.equals("Page") OR
                ls_item_tag.equals("Label") OR      #FUN-550113
                #No.FUN-B80041 --start--
                #增加可以隱藏的物件
                ls_item_tag.equals("Button") OR　#隱藏GROUP,BUTTON這類的元件　#modified
                ls_item_tag.equals("Table") OR
                ls_item_tag.equals("ScrollGrid") OR
                ls_item_tag.equals("VBox") OR
                ls_item_tag.equals("HBox") OR
                ls_item_tag.equals("Image") OR
                ls_item_tag.equals("HLine") OR
                ls_item_tag.equals("Convas")) THEN
                #No.FUN-B80041 --end--
               IF (pi_visible) THEN
                  CALL lfrm_curr.setElementHidden(ls_field_name,0)   
               ELSE
                  CALL lfrm_curr.setElementHidden(ls_field_name,1)
               END IF
               EXIT FOR
            END IF
      
            IF (pi_visible) THEN
               CALL lfrm_curr.setFieldHidden(ls_field_name,0)      
               IF (ls_item_tag.equals("FormField")) THEN
                  LET lnode_prev = lnode_item.getPrevious()
                  IF lnode_prev IS NOT NULL THEN
                     LET ls_prev_tag = lnode_prev.getTagName()
                     LET ls_prev_name = lnode_prev.getAttribute("name")   #No.FUN-570225
                     #No.FUN-570225 --start--
                     IF ls_prev_tag = "Button" AND lnode_prev.getAttribute("tag") = "+" THEN
                        CALL lnode_prev.setAttribute("hidden",0)
                        LET lnode_prev = lnode_prev.getPrevious()
                        IF lnode_prev IS NOT NULL THEN
                           LET ls_prev_tag = lnode_prev.getTagName()
                        END IF
                     END IF
                     #No.FUN-570225 ---end---
                     IF (ls_prev_tag.equals("Label")) AND 
                        (ls_prev_name NOT MATCHES "dummy*" OR cl_null(ls_prev_name)) THEN   #No.FUN-570225
                        CALL lnode_prev.setAttribute("hidden",0)
                     END IF
                  END IF
               END IF
            ELSE
                #FUN-4B0078  #MOD-4C0124
               CALL lfrm_curr.setFieldHidden(ls_field_name,1)
               IF (ls_item_tag.equals("FormField")) THEN
                  LET lnode_prev = lnode_item.getPrevious()
                  IF lnode_prev IS NOT NULL THEN
                     LET ls_prev_tag = lnode_prev.getTagName()
                     LET ls_prev_name = lnode_prev.getAttribute("name")   #No.FUN-570225
                     #No.FUN-570225 --start--
                     IF ls_prev_tag = "Button" AND lnode_prev.getAttribute("tag") = "+" THEN
                        CALL lnode_prev.setAttribute("hidden",1)
                        LET lnode_prev = lnode_prev.getPrevious()
                        IF lnode_prev IS NOT NULL THEN
                           LET ls_prev_tag = lnode_prev.getTagName()
                        END IF
                     END IF
                     #No.FUN-570225 ---end---
                     IF (ls_prev_tag.equals("Label")) AND 
                        (ls_prev_name NOT MATCHES "dummy*" OR cl_null(ls_prev_name)) THEN   #No.FUN-570225
                        CALL lnode_prev.setAttribute("hidden",1)
                     END IF
                  END IF
               END IF
            END IF
      
            EXIT FOR
         END IF
      END FOR
   END WHILE
END FUNCTION
