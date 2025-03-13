# Prog. Version..: '5.30.06-13.03.12(00000)'     #
 
# Program name...: cl_load_style_list.4gl
# Descriptions...: 載入 StyleList.
# Date & Author..: 03/11/20 by Hiko
# Usage..........: CALL cl_load_style_list(NULL)
# Modify.........: 04/03/30 by Brendan
# Modify.........: 04/08/13 by Brendan
# Modify.........: 04/09/16 alex 使用 g_sys時後方需加上 CLIPPED or .trim()
# Modify.........: No.FUN-690005 06/09/25 By cheunl 欄位定義類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-B50102 11/05/17 By tsai_yen 函式說明
 
IMPORT os
 
DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
# Descriptions...: 載入 StyleList.
# Date & Author..: 2003/11/06 by Hiko
# Input Parameter: ps_prog   STRING    程式代號
# Return Code....: void
# Modify.........: 04/03/30 by Brendan
# Modify.........: 04/08/13 by Brendan
# Modify.........: 04/09/07 alex 新增 TOPCONFIG
 
FUNCTION cl_load_style_list(ps_prog)
   DEFINE ps_prog            STRING 
   DEFINE ls_topPath         STRING
   DEFINE ls_globalFile      STRING,
          ls_defaultGlobal   STRING
   DEFINE ldoc_global        om.DomDocument
   DEFINE li_useDefault      LIKE type_file.num10    #No.FUN-690005 INTEGER
 
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF ( cl_null(ps_prog) ) THEN
      LET ps_prog = g_prog CLIPPED
   END IF
 
   #04/09/07 新增TOPCONFIG
   LET ls_topPath = FGL_GETENV("TOPCONFIG")
   IF cl_null(ls_topPath.trim()) THEN
      LET ls_topPath = os.Path.join(FGL_GETENV("TOP"),"config")
   END IF
   LET ls_defaultGlobal = os.Path.join(os.Path.join(ls_topPath,"4st"),"tiptop.4st")
 
   #--Loading Global Style File   
   LET li_useDefault = 0
   IF NOT cl_null(gs_4st_path) THEN
      LET ls_globalFile = os.Path.join(gs_4st_path, "tiptop.4st")
      LET ldoc_global = om.DomDocument.createFromXmlFile(ls_globalFile)
      IF ldoc_global IS NULL THEN
         LET li_useDefault = 1
         LET ls_globalFile = ls_defaultGlobal
      END IF
   ELSE
      LET li_useDefault = 1
      LET ls_globalFile = ls_defaultGlobal
   END IF
   IF li_useDefault THEN
      LET ldoc_global = om.DomDocument.createFromXmlFile(ls_globalFile)
      IF ldoc_global IS NULL THEN
         DISPLAY "ERROR: Can't load 4st file."
         RETURN
      END IF
   END IF
 
   --Loading style file to user interface
   CALL ui.Interface.loadStyles(ls_globalFile)
   DISPLAY "INFO: 4st for Interface Level = " || ls_globalFile
   
   # 2004/05/17 by saki : 有用到backgroundImage的style全部換路徑
   CALL cl_chg_style_pic_url()
END FUNCTION
 
#FUN-B50102 函式說明
##################################################
# Private Func...: TRUE
# Descriptions...: 有用到backgroundImage的style全部換路徑
# Date & Author..: 04/05/17 By saki
# Input Parameter: none
# Return code....: none
# Usage..........: CALL cl_chg_style_pic_url()
# Memo...........:
##################################################
FUNCTION cl_chg_style_pic_url()
   DEFINE   li_i         LIKE type_file.num10    #No.FUN-690005 INTEGER
   DEFINE   lnode_root   om.DomNode
   DEFINE   llst_items   om.NodeList
   DEFINE   lnode_item   om.DomNode
   DEFINE   ls_item_name STRING
   DEFINE   ls_pic_name  STRING
   DEFINE   ls_pic_url   STRING
 
   LET ls_pic_url = FGL_GETENV("FGLASIP") || "/tiptop/pic/"
 
   LET lnode_root = ui.Interface.getRootNode()
   LET llst_items = lnode_root.selectByPath("/UserInterface/StyleList/Style/StyleAttribute[@name=\"backgroundImage\"]")
   FOR li_i = 1 TO llst_items.getLength()
       LET lnode_item = llst_items.item(li_i)
       LET ls_item_name = lnode_item.getAttribute("name")
       IF (ls_item_name.equals("backgroundImage")) THEN
          LET ls_pic_name = lnode_item.getAttribute("value")
          CALL lnode_item.setAttribute("value",ls_pic_url || ls_pic_name)
       END IF
   END FOR
END FUNCTION
