# Prog. Version..: '5.30.06-13.03.12(00000)'     #
 
# Program name...: cl_load_toolbar_only.4gl
# Descriptions...:
# Usage..........: CALL cl_load_toolbar_only()
# Modify.........: No.FUN-690005 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
# Descriptions...: 載入ToolBar.
# Date & Author..: 
# Input Parameter: none
# Return Code....:
 
FUNCTION cl_load_toolbar_only()
   DEFINE   la_config_set     DYNAMIC ARRAY WITH DIMENSION 2 OF STRING
   DEFINE   li_i                    LIKE type_file.num5,     #No.FUN-690005  SMALLINT,
            ls_final_path           STRING,
            ls_tmp_path             STRING,
            ldoc_default            om.DomDocument,
            lnode_default_root      om.DomNode,
            lnode_item              om.DomNode
   DEFINE   lwin_curr    ui.Window,
            lfrm_curr    ui.Form
 
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   LET lwin_curr = ui.Window.getCurrent()
   LET lfrm_curr = lwin_curr.getForm()
 
   LET ls_final_path = FGL_GETENV("CUSTCONFIG"),"/4tb/toolbar_w.4tb"
   LET ldoc_default = om.DomDocument.createFromXmlFile(ls_final_path)
 
   IF (ldoc_default IS NULL) THEN
#     # 2004/09/07 gs_config_path 若在客製時移往他處 則下行與上列同意
#     LET ls_final_path = gs_config_path,"/4tb/toolbar_w.4tb"
      LET ls_final_path = gs_4tb_path,"/toolbar_w.4tb"
      LET ldoc_default = om.DomDocument.createFromXmlFile(ls_final_path)
   END IF
   CALL lfrm_curr.loadToolBar(ls_final_path)
   RETURN
END FUNCTION
 
