# Prog. Version..: '5.30.07-13.05.16(00000)'     #
#
# Program name...: cl_set_comp_att_text.4gl
# Descriptions...: 設定欄位的顯示名稱 (元件前面LABEL的text)
# Date & Author..: 04/03/12 by saki
# Modify.........: No.FUN-530037 05/03/22 by saki 字串不轉為小寫
# Modify.........: No.FUN-570234 05/08/30 by Lifeng 增加對Button的支持
# Modify.........: No.FUN-640184 06/04/12 by Echo 自動執行確認功能
# Modify.........: No.FUN-690005 06/09/05 By chen 類型轉換
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.TQC-740146 07/04/24 By Echo 判斷是否背景作業，條件需再加上 g_gui_type 
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.TQC-880020 08/08/14 By saki 單頭串查Button加入後，Label判斷修正
# Modify.........: No.FUN-D20057 13/02/20 by odyliao 增加 CheckBox 的顯示修改
# Modify.........: No.FUN-D30094 13/03/26 By By yougs 添加Page/Group/Label/RadioGroup/ComboBox的item設定顯示名稱,item命名按RadioGroup+item的name
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"    #FUN-640184  #FUN-7C0053
 
# Descriptions...: 設定欄位的顯示名稱 (元件前面LABEL的text)
# Input Parameter: ps_fields 欲轉換哪個欄位前的label或是table title
#                  ps_att_value 欲轉換的字串
# Return Code....:
 
FUNCTION cl_set_comp_att_text(ps_fields, ps_att_value)
   DEFINE   ps_fields          STRING,
            ps_att_value       STRING
   DEFINE   lst_fields         base.StringTokenizer,
            lst_string         base.StringTokenizer,
            ls_field_name      STRING,
            ls_field_value     STRING,
            ls_win_name        STRING
   DEFINE   lnode_root         om.DomNode,
            lnode_win          om.DomNode,
            lnode_pre          om.DomNode,
            llst_items         om.NodeList,
            lnode_list         om.NodeList,  #TEST
            li_i               LIKE type_file.num5,             #No.FUN-690005  SMALLINT
            lnode_item         om.DomNode,
            ls_item_name       STRING,
            lnode_item_child   om.DomNode,
            ls_item_pre_tag    STRING,
            ls_item_tag_name   STRING
   DEFINE   g_chg              DYNAMIC ARRAY OF RECORD
               item            STRING,
               value           STRING
                               END RECORD
   DEFINE   lwin_curr          ui.Window
   DEFINE   ls_btn_name        STRING                           #No.TQC-880020
   DEFINE l_str STRING
   DEFINE l_cnt SMALLINT
   DEFINE   lnode_p            om.DomNode,            #FUN-D30094
            ls_item_tag_name_p STRING,                #FUN-D30094
            ls_item_name_p     STRING,                #FUN-D30094      
            ls_str_p           LIKE type_file.chr100  #FUN-D30094
  
   #FUN-D30094用法:找到組件各細項的名稱name，以comboBox為例,下拉框第一項name是1，ComboBox的fieldname是ctype.那麼在調用函數傳入的fieldname就是"ctype_1"CALL cl_set_comp_att_text("ctype_1","測試1")
 
   #FUN-640184
   #IF g_bgjob = 'Y' THEN
   IF g_bgjob = 'Y' AND g_gui_type NOT MATCHES "[13]"  THEN    #TQC-740146
 
      RETURN
   END IF
   #END FUN-640184
          
   IF (ps_fields IS NULL) THEN
      RETURN
   ELSE
      LET ps_fields = ps_fields.toLowerCase()
   END IF
  
   LET lwin_curr = ui.Window.getCurrent()
   LET lnode_win = lwin_curr.getNode()
   LET ls_win_name = lnode_win.getAttribute("name")
 
   LET llst_items = lnode_win.selectByPath("//Form//*")    
   LET lst_fields = base.StringTokenizer.create(ps_fields, ",")
   LET lst_string = base.StringTokenizer.create(ps_att_value,",")
   WHILE lst_fields.hasMoreTokens() AND lst_string.hasMoreTokens()
      LET ls_field_name = lst_fields.nextToken()
      LET ls_field_value = lst_string.nextToken()
      LET ls_field_name = ls_field_name.trim()
 
      IF ls_field_name.equals(ls_win_name) THEN
         CALL lnode_win.setAttribute("text",ls_field_value)
      END IF
 
      FOR li_i = 1 TO llst_items.getLength()
         LET lnode_item = llst_items.item(li_i)
         LET ls_item_name = lnode_item.getAttribute("colName")
 
         IF (ls_item_name IS NULL) THEN
            LET ls_item_name = lnode_item.getAttribute("name")

            #add by FUN-D30094 begin
            LET ls_item_tag_name = lnode_item.getTagName()
            IF ls_item_tag_name.equals("Item") THEN
               IF (ls_item_name IS NOT NULL) THEN
            	    LET lnode_p = lnode_item.getParent()   #取父結點
                  LET ls_item_tag_name_p = lnode_p.getTagName()   #父結點類型
                  IF ls_item_tag_name_p.equals("RadioGroup") OR ls_item_tag_name_p.equals("ComboBox") THEN
                  	 LET ls_item_name_p = lnode_p.getAttribute("comment")  #取comment因為裡面一定會有[***]
                  	 LET ls_str_p = ls_item_name_p     
                  	 #取[]之間的東西
                  	 select substr(ls_str_p,instr(ls_str_p,'[',1)+1,length(ls_str_p)-instr(ls_str_p,'[',1)-1) INTO ls_str_p from dual
                  	 LET ls_item_name = ls_str_p CLIPPED || '_' || ls_item_name
                  END IF
               END IF
            END IF  
            #add by FUN-D30094 end 	
 
            IF (ls_item_name IS NULL) THEN
               CONTINUE FOR
            END IF
         END IF
      
         IF (ls_item_name.equals(ls_field_name)) THEN
           #FUN-D20057 add---(S)
            LET ls_item_tag_name = lnode_item.getTagName()
            LET lnode_list = lnode_item.selectByTagName("CheckBox")
            LET l_cnt = lnode_list.getlength()
           #FUN-D20057 add---(E)
            IF ls_item_tag_name.equals("TableColumn") OR
               ls_item_tag_name.equals("Page") OR     #add by FUN-D30094 begin   
               ls_item_tag_name.equals("Item") OR   
               ls_item_tag_name.equals("Group") OR      
               ls_item_tag_name.equals("Label") OR    #add by FUN-D30094 end 
               ls_item_tag_name.equals("Window")OR
               ls_item_tag_name.equals("Button") THEN   #FUN.570234 Add By Lifeng
               CALL lnode_item.setAttribute("text",ls_field_value.trim())  #FUN-530037
            ELSE
              #FUN-D20057 add--- (S)
               IF l_cnt > 0 THEN
                  LET lnode_item_child = lnode_item.getFirstChild()
                  CALL lnode_item_child.setAttribute("text",ls_field_value.trim())
               ELSE
              #FUN-D20057 add--- (E)
                  LET lnode_pre = lnode_item.getPrevious()
                  LET ls_item_pre_tag = lnode_pre.getTagName()
                  IF ls_item_pre_tag.equals("Label") THEN
                     CALL lnode_pre.setAttribute("text",ls_field_value.trim()) #FUN-530037
                  #No.TQC-880020 --start--
                  ELSE
                     IF ls_item_pre_tag.equals("Button") THEN
                        LET ls_btn_name = lnode_pre.getAttribute("name")
                        IF ls_btn_name.subString(1,4) = "btn_" THEN
                           LET lnode_pre = lnode_pre.getPrevious()
                           LET ls_item_pre_tag = lnode_pre.getTagName()
                           IF ls_item_pre_tag.equals("Label") THEN
                              CALL lnode_pre.setAttribute("text",ls_field_value.trim())
                           END IF
                        END IF
                     END IF
                  #No.TQC-880020 ---end---
                  END IF
              END IF #FUN-D20057
            END IF
            EXIT FOR
         END IF
      END FOR
   END WHILE
END FUNCTION
