# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: cl_set_focus_form.4gl
# Descriptions...: get focus field and form 
# Date & Author..: 2004/06/11 by CoCo
# Usage..........: CALL cl_set_focus_form(ui.Interface.getRootNode())
# Modify.........: No.MOD-560169 05/06/29 By saki 增加Matrix判斷
# Modify.........: No.FUN-690005 06/09/05 By chen 類型轉換
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-710055 07/03/02 By saki 畫面檔名抓取規則更動
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-A10029 10/01/06 By alex 抓取formname 含.tmp字樣時自動刪除
# Modify.........: No:FUN-AA0090 10/10/28 By Hiko 將判斷字串的方式改為subString 

DATABASE ds        #FUN-6C0017   #FUN-7C0053
 
GLOBALS "../../config/top.global"
 
FUNCTION cl_set_focus_form(ui_node)
 DEFINE  ui_node,n1_node,n11_node  om.DomNode,
         n_list                    om.NodeList,
         i,table_col               LIKE type_file.num10,            #No.FUN-690005  integer
         id,focus_id,focus_window  LIKE type_file.chr5,             #No.FUN-690005  VARCHAR(5)
         fld_name,frm_name         string
 
   LET fld_name = ""
 
###取focus的idRef
   LET n_list = ui_node.selectByTagName("UserInterface")
   LET n1_node= n_list.item(1)
   LET focus_id = n1_node.getAttribute("focus")
   LET focus_window = n1_node.getAttribute("currentWindow")
   display "focus_id:",focus_id,"  currentwindow:",focus_window
 
###取idRef的name
   LET n_list = ""
   LET n_list = ui_node.selectByTagName("FormField")
   FOR i=1 to n_list.getLength()
      LET n1_node= n_list.item(i)
      LET id = n1_node.getId()
      IF id = focus_id THEN
         LET fld_name = n1_node.getAttribute("colName")
         EXIT FOR
      END IF
   END FOR
 
   LET n_list = ""
   IF cl_null(fld_name) THEN
      LET n_list = ui_node.selectByTagName("Table")
      FOR i=1 to n_list.getLength()
         LET n1_node= n_list.item(i)
         Let id = n1_node.getId()
         #display "id:",id
         IF id=focus_id THEN
            LET table_col = n1_node.getAttribute("currentColumn")
            EXIT FOR
         END IF
      END FOR
      LET n_list = n1_node.selectByTagName("TableColumn")
      LET n1_node= n_list.item(table_col+1)
       #No.MOD-560169 --start--
      IF n1_node IS NOT NULL THEN
         LET fld_name = n1_node.getAttribute("colName")
      ELSE
         LET n_list = ui_node.selectByTagName("Matrix")
         FOR i=1 to n_list.getLength()
            LET n1_node = n_list.item(i)
            LET id = n1_node.getId()
            IF id = focus_id THEN
               LET fld_name = n1_node.getAttribute("colName")
               EXIT FOR
            END IF
         END FOR
      END IF
       #No.MOD-560169 ---end---
   END IF
   DISPLAY "fld_name:",fld_name
 
###取per_name
   LET n_list = ui_node.selectByTagName("Window")
   FOR i=1 to n_list.getLength()
      LET n1_node= n_list.item(i)
      #display n1_node.getId()
      IF focus_window =  n1_node.getId() THEN
         LET n11_node = n1_node.getFirstChild()
         LET frm_name = n11_node.getAttribute("name")
         EXIT FOR
      END IF
   END FOR  
   #No.FUN-710055 --start--
   #IF frm_name.getLength() = ".tmp" THEN    #FUN-A10029 #FUN-AA0090
   IF frm_name.subString(frm_name.getLength()-3,frm_name.getLength()) = ".tmp" THEN
      LET frm_name = frm_name.subString(1,frm_name.getLength()-4)
   END IF
   #IF frm_name.getLength() = "T" THEN #FUN-AA0090
   IF frm_name.subString(frm_name.getLength(),frm_name.getLength()) = "T" THEN
      LET frm_name = frm_name.subString(1,frm_name.getLength()-1)
   END IF
   #No.FUN-710055 ---end---
   display "frm_name:",frm_name
   RETURN fld_name,frm_name
END FUNCTION
 
