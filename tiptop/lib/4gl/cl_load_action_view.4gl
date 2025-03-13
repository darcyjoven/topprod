# Prog. Version..: '5.30.06-13.03.12(00000)'     #
 
# Program name...: cl_load_action_view.4gl
# Program ver....: 7.0
# Descriptions...: 設定 TopMenu 與 ToolBar.
# Date & Author..: 2003/12/26 by Hiko
# Memo...........: 雖然TopMenu與ToolBar都是跟Form有關,但是TIPTOP的架構是以主程式在zz_file的type為主.
#                  因此不以Form name為抓取程式type的key,這樣才可以避免CALL FUNCTION開窗時,程式自動乎
#                  叫此FUNCTION,而將主程式的ToolBar與TopMenu覆蓋掉.
# Usage..........: CALL cl_load_action_view()
# Modify.........: 04/03/30 by Brendan
# Modify.........: 04/09/16 alex 使用 g_sys時後方需加上 CLIPPED or .trim()
# Modify.........: NO.FUN-620044 06/06/20 by Alexstar  udm_tree 使用獨立的toolbar(toolbar_m1.4tb)
# Modify.........: No.FUN-690005 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
GLOBALS
   DEFINE mi_call_by_dynamic_locale   LIKE type_file.num5      #No.FUN-690005 SMALLINT
END GLOBALS
 
 
# Descriptions....: 載入 TopMenu 與 ToolBar.
# Date & Author...: 2003/11/04 by Hiko
# Inpuut Parameter: void
# Return Code.....: void
# Memo............: 檔案抓取流程為:
#                   1. 先判斷是否指定客制的設定檔(路徑: $TOPCONFIG), 若不存在, 則抓取預設的設定檔(路徑: $TOP).
#                   2. 再判斷是否存在客制的程式名稱設定檔, 若存在, 則與設定檔一起載入.
# Modify..........: 04/03/30 by Brendan
# Modify..........: 04/09/07 hjwang 新增 TOPCONFIG
 
FUNCTION cl_load_action_view()
   DEFINE la_config_set      DYNAMIC ARRAY WITH DIMENSION 2 OF STRING
   DEFINE lc_type            LIKE zz_file.zz03
   DEFINE li_i               LIKE type_file.num5      #No.FUN-690005 SMALLINT
   DEFINE ldoc_global        om.DomDocument,
          ldoc_prog          om.DomDocument
   DEFINE lwin_curr          ui.Window,
          lfrm_curr          ui.Form
   DEFINE li_useDefault      LIKE type_file.num10     #No.FUN-690005 INTEGER
   DEFINE ls_topPath         STRING
   DEFINE ls_defaultGlobal   STRING,
          ls_defaultProg     STRING
   DEFINE ls_globalFile      STRING,
          ls_progFile        STRING
   DEFINE ls_globalPath      STRING,
          ls_progPath        STRING
 
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   # 2004/09/07 新增 TOPCONFIG
   LET ls_topPath = FGL_GETENV("TOPCONFIG")
   IF cl_null(ls_topPath.trim()) THEN
      LET ls_topPath = FGL_GETENV("TOP"),"/config"
   END IF
 
   LET lwin_curr = ui.Window.getCurrent()
   LET lfrm_curr = lwin_curr.getForm()
 
   LET la_config_set[1,1] = "4tm"
   LET la_config_set[1,2] = "topmenu"
   LET la_config_set[1,3] = "TopMenu"
   LET la_config_set[2,1] = "4tb"
   LET la_config_set[2,2] = "toolbar"
   LET la_config_set[2,3] = "ToolBar"
 
--Get type of program
   SELECT zz03 INTO lc_type FROM zz_file WHERE zz01 = g_prog
   IF SQLCA.SQLCODE THEN
      LET lc_type = 'o'
   END IF
--#
 
   IF NOT cl_null(lc_type) THEN
      FOR li_i = 1 TO 2
 
          LET ls_globalPath = la_config_set[li_i,2], "_", DOWNSHIFT(lc_type), ".", la_config_set[li_i,1]
          LET ls_progPath = DOWNSHIFT(g_sys) CLIPPED, "/", g_prog CLIPPED, ".", la_config_set[li_i,1]
 
          LET ls_defaultGlobal = ls_topPath, "/", la_config_set[li_i,1], "/", ls_globalPath
          LET ls_defaultProg = ls_topPath, "/", la_config_set[li_i,1], "/", ls_progPath
 
--Loading global action view file
          LET li_useDefault = 0
          LET ls_globalFile = NULL
          CASE la_config_set[li_i,1]
               WHEN "4tm"
                    IF NOT cl_null(gs_4tm_path) THEN
                       LET ls_globalFile = gs_4tm_path, "/", ls_globalPath
                    END IF
               WHEN "4tb"
                    IF NOT cl_null(gs_4tb_path) THEN
                       IF g_prog = "udm_tree" THEN       #FUN-620044
                          LET ls_globalFile = gs_4tb_path, "/", "toolbar_m1.4tb"   #FUN-620044
                       ELSE
                          LET ls_globalFile = gs_4tb_path, "/", ls_globalPath
                       END IF
                    END IF
          END CASE
 
          IF NOT cl_null(ls_globalFile) THEN
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
                DISPLAY "ERROR: Can't load " || la_config_set[li_i,1] || " for Interface Level."
                CONTINUE FOR
             END IF
          END IF
          
          CASE la_config_set[li_i,1]
               WHEN "4tm"
                    CALL ui.Interface.loadTopMenu(ls_globalFile)
               WHEN "4tb"
                    CALL ui.Interface.loadToolBar(ls_globalFile)
          END CASE
 
          DISPLAY "INFO: " || la_config_set[li_i,1] || " for Interface Level = " || ls_globalFile
--#
 
--Loading program specific action view file
          LET li_useDefault = 0
          LET ls_progFile = NULL
          CASE la_config_set[li_i,1]
               WHEN "4tm"
                    IF NOT cl_null(gs_4tm_path) THEN
                       LET ls_progFile = gs_4tm_path, "/", ls_progPath
                    END IF
               WHEN "4tb"
                    IF NOT cl_null(gs_4tb_path) THEN
                         LET ls_progFile = gs_4tb_path, "/", ls_progPath
                    END IF
          END CASE
 
          IF NOT cl_null(ls_progFile) THEN
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
             CASE la_config_set[li_i,1]
                  WHEN "4tm"
                       CALL lfrm_curr.loadTopMenu(ls_progFile)
                  WHEN "4tb"
                       CALL lfrm_curr.loadToolBar(ls_progFile)
             END CASE
 
             DISPLAY "INFO: " || la_config_set[li_i,1] || " for Form Level = " || ls_progFile
          END IF
--#
 
      END FOR
   END IF
END FUNCTION
