# Prog. Version..: '5.30.06-13.03.12(00003)'     #
 
# Program name...: cl_load_act_sys.4gl
# Descriptions...: 載入ActionList.
# Date & Author..: 2003/07/03 by Hiko
# Usage..........: CALL cl_load_act_sys(NULL)
# Modify.........: 03/11/25 by Hiko : 為了s_act_def而改變程式架構:
# Modify.........: 04/03/31 by Brendan
# Modify.........: No.FUN-690005 06/09/01 By hongmei欄位類型轉換
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-970119 09/10/09 By Echo 控制簽核按紐是否顯示 
# Modify.........: No.FUN-C40045 12/04/12 By tommas B2B時,FGL_GETENV("TOP")要改用FGL_GETENV("WTOP")
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
DEFINE   mc_lang       STRING
 
# Descriptions...: 載入 ActionList.
# Date & Author..: 2003/11/06 by Hiko
# Input Parameter: ps_prog   STRING    程式代號
# Return Code....: void
# Modify.........: 04/03/31 by Brendan
 
FUNCTION cl_load_act_sys(ps_prog)
   DEFINE ps_prog            STRING
   DEFINE ls_topPath         STRING
   DEFINE ls_globalFile      STRING,
          ls_defaultGlobal   STRING
   DEFINE ldoc_global        om.DomDocument,
          ldoc_prog          om.DomDocument
   DEFINE li_useDefault      LIKE type_file.num10     #No.FUN-690005 INTEGER
   #No.FUN-970119 -- start --
   DEFINE l_i                LIKE type_file.num10
   DEFINE li_approve         DYNAMIC ARRAY OF RECORD
             name            STRING,
             value           LIKE type_file.num5
                             END RECORD
   #No.FUN-970119 -- end --
 
   WHENEVER ERROR CALL cl_err_msg_log
   
   #No.FUN-970119 -- start --
   #記錄簽核 action 目前是顯示/隱藏
   LET li_approve[1].name  = "agree"
   LET li_approve[2].name  = "deny"
   LET li_approve[3].name  = "modify_flow"
   LET li_approve[4].name  = "withdraw"
   LET li_approve[5].name  = "org_widthdraw"
   LET li_approve[6].name  = "phrase"
   FOR l_i = 1 TO li_approve.getLength()
       LET li_approve[l_i].value = cl_detect_act_visible(li_approve[l_i].name)
   END FOR
   #No.FUN-970119 -- end --
 
   IF cl_null(ps_prog) THEN
      LET ps_prog = g_prog CLIPPED
   END IF
 
   # 2004/04/26 呃 不太清楚下面為什麼要判斷  現在有判斷反而會錯  先 mark 起來
#  IF cl_null(mc_lang) THEN
      LET mc_lang = g_lang
#  END IF
 
   # 2004/09/07 增加 TOPCONFIG
   LET ls_topPath = FGL_GETENV("TOPCONFIG")
   
   IF NOT cl_null(FGL_GETENV("WEBAREA")) THEN  #No.FUN-C40045
      LET ls_topPath = FGL_GETENV("WTOPCONFIG") 
   END IF 

   IF cl_null(ls_topPath.trim()) THEN
      LET ls_topPath = FGL_GETENV("TOP")
      IF NOT cl_null(FGL_GETENV("WEBAREA")) THEN #No.FUN-C40045
         LET ls_topPath = FGL_GETENV("WTOP")
      END IF
      LET ls_topPath = ls_topPath,"/config"
   END IF

   LET ls_defaultGlobal = ls_topPath, "/4ad/", mc_lang, "/tiptop.4ad"
   # Loading global action default file
   LET li_useDefault = 0
   IF NOT cl_null(gs_4ad_path) THEN
      LET ls_globalFile = gs_4ad_path, "/", mc_lang, "/tiptop.4ad"
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
         LET ls_globalFile = ls_topPath, "/config/4ad/1/tiptop.4ad"
         DISPLAY "ERROR: Can't load correspondent 4ad file, use english locale instead."
      END IF
   END IF
 
   CALL ui.Interface.loadActionDefaults(ls_globalFile)
 
   DISPLAY "INFO: 4ad for Interface Level = " || ls_globalFile
 
   #No.FUN-970119 -- start --
   #還原簽核 action 原先呈現的狀況，判斷簽核 action 是否該隱藏
   FOR l_i = 1 TO li_approve.getLength()
       IF NOT li_approve[l_i].value THEN
          CALL cl_set_act_visible(li_approve[l_i].name, FALSE)
       END IF
   END FOR
   #No.FUN-970119 -- end --
END FUNCTION
