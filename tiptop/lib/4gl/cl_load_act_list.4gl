# Prog. Version..: '5.30.06-13.03.12(00000)'     #
 
# Program name...: cl_load_act_list.4gl
# Descriptions...: 載入ActionList.
# Date & Author..: 2003/07/03 by Hiko
# Usage..........: CALL cl_load_act_list(NULL)
# Modify.........: 03/11/25 by Hiko : 為了s_act_def而改變程式架構:
#                  1.增加 FUNCTION cl_set_act_lang.
#                  2.增加 FUNCTION cl_get_act_path.
# Modify.........: 04/03/31 by Brendan
# Modify.........: 04/09/07 alex 修改 TOPCONFIG
# Modify.........: 04/09/16 alex 使用 g_sys時後方需加上 CLIPPED or .trim()
# Modify.........: No.FUN-690005 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
IMPORT os
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   mc_lang       STRING,
         ms_tmp_path   STRING
 
 
# Descriptions...: 載入 ActionList.
# Date & Author..: 2003/11/06 by Hiko
# Input Parameter: ps_prog   STRING    程式代號
# Return code....: void
# Modify.........: 04/03/31 by Brendan
 
FUNCTION cl_load_act_list(ps_prog)
   DEFINE ps_prog            STRING
   DEFINE ls_topPath         STRING
   DEFINE ls_globalFile      STRING,
          ls_progFile        STRING,
          ls_defaultGlobal   STRING,
          ls_defaultProg     STRING
   DEFINE ldoc_global        om.DomDocument,
          ldoc_prog          om.DomDocument
   DEFINE li_useDefault      LIKE type_file.num10      #No.FUN-690005 INTEGER
   DEFINE lwin_curr          ui.Window,
          lfrm_curr          ui.Form
 
 
   WHENEVER ERROR CALL cl_err_msg_log
   
   IF cl_null(ps_prog) THEN
      LET ps_prog = g_prog CLIPPED
   END IF
 
   IF cl_null(mc_lang) THEN
      LET mc_lang = g_lang CLIPPED
   END IF
 
   #04/09/07 增加 TOPCONFIG
   LET ls_topPath = FGL_GETENV("TOPCONFIG")
   IF cl_null(ls_toppath.trim()) THEN
      LET ls_topPath = os.Path.join(FGL_GETENV("TOP"),"config")
   END IF
   LET ls_defaultProg = os.Path.join(os.Path.join(ls_topPath,"4ad"),mc_lang CLIPPED)
   LET ls_defaultProg = os.Path.join(os.Path.join(ls_defaultProg,DOWNSHIFT(g_sys) CLIPPED), ps_prog||".4ad")
 
   # Loading program specific action default file
   LET li_useDefault = 0
   IF NOT cl_null(gs_4ad_path) THEN
      LET ls_progFile = os.Path.join(os.Path.join(gs_4ad_path, mc_lang),DOWNSHIFT(g_sys) CLIPPED)
      LET ls_progFile = os.Path.join(ls_progFile, ps_prog||".4ad")
      LET ldoc_prog = om.DomDocument.createFromXmlFile(ls_progFile)
      IF ldoc_prog IS NULL THEN
         LET li_useDefault = 1
         LET ls_progFile = ls_defaultProg
      END IF
   ELSE
      LET li_useDefault = 1
      LET ls_progFile = ls_defaultProg
   END IF
   IF li_useDefault THEN
      LET ldoc_prog = om.DomDocument.createFromXmlFile(ls_progFile)
   END IF
 
   IF ldoc_prog IS NOT NULL THEN
      LET lwin_curr = ui.Window.getCurrent()
      LET lfrm_curr = lwin_curr.getForm()
 
      CALL lfrm_curr.loadActionDefaults(ls_progFile)
 
      DISPLAY "INFO: 4ad for Form Level = " || ls_progFile
   END IF
 
END FUNCTION
 
 
# Descriptions...: 設定所要載入ActionList的語言別.
# Date & Author..: 2003/11/25 by Hiko
# Input Parameter: pc_lang   VARCHAR(1)   語言別
# Return Code....: void
 
FUNCTION cl_set_act_lang(pc_lang)
   DEFINE   pc_lang   LIKE type_file.chr1       #No.FUN-690005  VARCHAR(1)
 
   LET mc_lang = pc_lang 
END FUNCTION
 
 
# Descriptions...: 回傳ActionList的載入路徑.
# Date & Author..: 2003/11/25 by Hiko
# Input Parameter: ps_prog   STRING    程式代號
# Return Code....: STRING    ActionList的載入路徑
 
FUNCTION cl_get_act_path(ps_prog)
   DEFINE   ps_prog           STRING 
   DEFINE   ls_final_path           STRING,
            ls_customer_path        STRING,
            ldoc_default            om.DomDocument,
            lnode_default_root      om.DomNode,
            ldoc_customer           om.DomDocument,
            lnode_customer_root     om.DomNode,
            lnode_item              om.DomNode,
            ls_sys                  STRING,
            lc_sys_key              LIKE type_file.chr1       #No.FUN-690005 VARCHAR(1)
 
   IF (cl_null(ps_prog)) THEN
      LET ps_prog = g_prog CLIPPED
      LET ls_sys = g_sys CLIPPED
   ELSE
      LET ls_sys = ps_prog.subString(1,3)
      LET lc_sys_key = ls_sys.subString(1,1)
      CASE lc_sys_key
         WHEN 'l' LET ls_sys = "lib"
         WHEN 'p' LET ls_sys = "azz"
         WHEN 's' LET ls_sys = "sub"  
      END CASE
   END IF
 
   IF (cl_null(mc_lang)) THEN
      LET mc_lang = g_lang
   END IF
 
   # 2003/11/05 by Hiko : 如果ls_final_path是NULL,則程式會hold.
   # 2004/09/07 先尋找是否有客製定義的 tiptop.4ad, 有則引用, 無則用出貨標準
 
   LET ls_final_path = FGL_GETENV("CUSTCONFIG"),"/4ad/",mc_lang,"/tiptop.4ad"
   LET ldoc_default = om.DomDocument.createFromXmlFile(ls_final_path)
   IF (ldoc_default IS NULL) THEN
      LET ls_final_path = gs_config_path,"/4ad/",mc_lang,"/tiptop.4ad"
      LET ldoc_default = om.DomDocument.createFromXmlFile(ls_final_path)
      IF (ldoc_default IS NULL) THEN
         ERROR ls_final_path || " cann't to load."
         RETURN ls_final_path
      END IF  
   END IF
 
   # 2004/09/07 個別部份則先檢查 gs_4ad_path 目錄下是否存在已定義好的
   #            沒有再搜尋 TOPCONFIG
   LET ls_customer_path = gs_4ad_path,"/",mc_lang,"/",DOWNSHIFT(ls_sys),"/",ps_prog.trim(),".4ad"
   LET ldoc_customer = om.DomDocument.createFromXmlFile(ls_customer_path)
   IF (ldoc_customer IS NULL) THEN
      LET ls_customer_path = FGL_GETENV("TOPCONFIG")
      IF cl_null(ls_customer_path.trim()) THEN
         LET ls_customer_path = os.Path.join(FGL_GETENV("TOP"),"config")
      END IF
      LET ls_customer_path = ls_customer_path.trim(),"/4ad/",mc_lang,"/",DOWNSHIFT(ls_sys),"/",ps_prog.trim(),".4ad"
      LET ldoc_customer = om.DomDocument.createFromXmlFile(ls_customer_path)
   END IF
 
   # 2003/12/17 by Hiko : 若存在程式別之設定檔,則要與tiptop.4ad合併.
   IF (ldoc_customer IS NOT NULL) THEN
      LET ls_final_path = g_user CLIPPED || "_" || FGL_GETPID() || ".4ad"
      LET ms_tmp_path = ls_final_path
      LET lnode_default_root = ldoc_default.getDocumentElement()
      LET lnode_customer_root = ldoc_customer.getDocumentElement()
      LET lnode_item = lnode_customer_root.getFirstChild()
      WHILE lnode_item IS NOT NULL
         CALL lnode_default_root.appendChild(ldoc_default.copy(lnode_item, TRUE))
         LET lnode_item = lnode_item.getNext()
      END WHILE
 
      CALL lnode_default_root.writeXml(ls_final_path)
   END IF
 
   RETURN ls_final_path
END FUNCTION
 
 
# Descriptions...: 刪除ActionList的特殊合併檔案.
# Date & Author..: 2003/11/25 by Hiko
# Input Parameter: pc_lang   VARCHAR(1)   語言別
# Return Code....: void
# Memo...........: 還需讓s_act_def呼叫.
 
FUNCTION cl_act_del_tmp_path()
  #RUN "rm -f " || ms_tmp_path   
   IF os.Path.delete(ms_tmp_path) THEN
   END IF
END FUNCTION
 
