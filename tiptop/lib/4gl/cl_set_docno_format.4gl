# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: cl_set_docno_format.4gl
# Descriptions...: 依照系統參數(aoos010)設定單據編號欄位格式
# Date & Author..: 05/05/02 by saki
# Modify.........: No.FUN-550078 05/05/18 by saki 使用g_doc_len,g_no_sp,g_no_ep共用變數
# Modify.........: No.FUN-690005 06/09/05 By chen 類型轉換
# Modify.........: No.FUN-720042 07/03/02 By saki 因應4fd使用, findNode搜尋修改
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-A30020 10/03/08 By saki 單據編號規格改變,加入PlantCode
# Modify.........: No:FUN-A70010 10/07/05 By tsai_yen 增加尋找ScrollGrid的Matrix屬性的元件
# Modify.........: No:FUN-AC0103 11/01/03 By tsai_yen 判斷客製模組
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
# Descriptions...: 傳入單據編號欄位設定格式
# Date & Author..: 2005/05/02 by saki
# Input Parameter: ps_field       欄位名稱
# Return Code....: none
# Memo...........: CALL cl_set_no_format("pmw01",TRUE)
 
FUNCTION cl_set_docno_format(ps_field)
   DEFINE   ps_field     STRING
   DEFINE   lwin_curr    ui.Window
   DEFINE   lfrm_curr    ui.Form
   DEFINE   lnode_item   om.DomNode
   DEFINE   lnode_child  om.DomNode
   DEFINE   ls_picture   STRING              # 單據編號格式設定
   DEFINE   li_i         LIKE type_file.num10             #No.FUN-690005  INTEGER
   DEFINE   ls_tabname   STRING              #No.FUN-720042
   #No.FUN-A30020 --start--
   DEFINE   ls_sql          STRING
   DEFINE   lc_plantadd     LIKE aza_file.aza97
   DEFINE   li_plantlen     LIKE aza_file.aza98
   #No.FUN-A30020 ---end---
 
 
   LET lwin_curr = ui.Window.getCurrent()
   LET lfrm_curr = lwin_curr.getForm()
   IF lfrm_curr IS NULL THEN
      RETURN
   END IF
 
   LET ls_tabname = cl_get_table_name(ps_field)    #No.FUN-720042
   LET lnode_item = lfrm_curr.findNode("FormField",ls_tabname||"."||ps_field)  #No.FUN-720042
   IF lnode_item IS NULL THEN
      LET lnode_item = lfrm_curr.findNode("TableColumn",ls_tabname||"."||ps_field)   #No.FUN-720042
      IF lnode_item IS NULL THEN
         LET lnode_item = lfrm_curr.findNode("Matrix",ls_tabname||"."||ps_field) #FUN-A70010
         IF lnode_item IS NULL THEN
            RETURN
         END IF
      END IF
   END IF
 
   LET lnode_child = lnode_item.getFirstChild()

   FOR li_i = 1 TO g_doc_len
       LET ls_picture = ls_picture,"X"
   END FOR
 
   LET ls_picture = ls_picture,"-"
 
   #No.FUN-A30020 --start-- 
   CASE
      # 財務模組單據編號PlantCode設定
      ###FUN-AC0103 START ###
      WHEN g_sys = "AAP" OR g_sys = "CAP" OR g_sys = "GAP" OR g_sys = "CGAP" OR
           g_sys = "AFA" OR g_sys = "CFA" OR g_sys = "GFA" OR g_sys = "CGFA" OR
           g_sys = "AGL" OR g_sys = "CGL" OR g_sys = "GGL" OR g_sys = "CGGL" OR
           g_sys = "ANM" OR g_sys = "CNM" OR g_sys = "GNM" OR g_sys = "CGNM" OR
           g_sys = "AXR" OR g_sys = "CXR" OR g_sys = "GXR" OR g_sys = "CGXR" OR
           g_sys = "AMD" OR g_sys = "CMD" OR 
           g_sys = "GIS" OR g_sys = "CGIS"
      ###FUN-AC0103 END ###
         LET ls_sql = "SELECT aza99,aza100 FROM aza_file WHERE aza01 = '0'"
      # 製造模組單據編號設定
      OTHERWISE
         LET ls_sql = "SELECT aza97,aza98 FROM aza_file WHERE aza01 = '0'"
   END CASE
   PREPARE aza_pre FROM ls_sql
   EXECUTE aza_pre INTO lc_plantadd,li_plantlen
   IF lc_plantadd = "Y" THEN
      FOR li_i = 1 TO li_plantlen
          LET ls_picture = ls_picture,"X"
      END FOR
   END IF
   #No.FUN-A30020 ---end---

   FOR li_i = 1 TO g_no_ep - g_sn_sp + 1   #No.FUN-A30020
       LET ls_picture = ls_picture,"#"
   END FOR
 
   CALL lnode_child.setAttribute("picture",ls_picture)
END FUNCTION
 
