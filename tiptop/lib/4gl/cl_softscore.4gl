# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: cl_softscore.4gl
# Descriptions...: For SoftScore integration.
# Date & Author..: 2004/07/07 by Brendan
# Usage..........: CALL cl_softscore()
#                 - Dump AUI tree and convert to .sco file format for SoftScore
#                  CALL cl_softscore_check()
#                 - Check client environment; if SoftScore has been installed
#                 - [IMPORTANT] MUST CALL BEFORE cl_softscore()
# Modify.........: 04/09/10 by Brendan
#                 - change for UNICODE environment(MOD-490220)
# Modify.........: No.FUN-690005 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds    #FUN-7C0053
 
GLOBALS "../../config/top.global"
 
DEFINE gs_command   STRING,
       gs_client    STRING,
       gs_scoPath   STRING
 
 
# Descriptions...: For SoftScore integration.
# Date & Author..: 2004/07/07 by Brendan
# Input Parameter: none
# Return Code....: void
 
FUNCTION cl_softscore()
  DEFINE ls_fname     STRING,
         ls_path      STRING,
         ls_xmlPath   STRING,
         ls_scoPath   STRING
 
 
  WHENEVER ERROR CALL cl_err_msg_log
 
  LET ls_fname = cl_dumpAUITree()
  IF ls_fname IS NULL THEN
     RETURN FALSE
  END IF
 
  LET ls_path = cl_client_env("TEMP")
  IF ls_path IS NULL THEN
     LET ls_path = cl_client_env("TMP")
     IF ls_path IS NULL THEN
        RETURN FALSE
     END IF
  END IF
 
  LET ls_xmlPath = ls_path, "\\", g_prog CLIPPED, ".xml"
  IF NOT cl_download_file(ls_fname, ls_xmlPath) THEN
     RETURN FALSE
  END IF
 
  LET ls_scoPath = gs_scoPath, "\\Converter.exe" 
  IF NOT cl_open_prog(ls_scoPath, ls_xmlPath) THEN
     RETURN FALSE
  END IF
 
  RETURN TRUE
END FUNCTION
 
 
# Descriptions...: For SoftScore integration.
# Date & Author..: 2004/07/07 by Brendan
# Input Parameter: none
# Return Code....: TRUE  - SoftScore has been installed
#                  FALSE - No SoftScore environment
 
FUNCTION cl_softscore_check()
  DEFINE lch_pipe     base.Channel
  DEFINE li_status    LIKE type_file.num10,      #No.FUN-690005 INTEGER,
         li_idx       LIKE type_file.num10,      #No.FUN-690005 INTEGER,
         li_capture   LIKE type_file.num10       #No.FUN-690005 INTEGER
  DEFINE ls_string    STRING,
         ls_scoPath   STRING,
         ls_scoStr    STRING,
         ls_scoFlag   STRING
 
 
  IF ( gs_scoPath := cl_client_env("ScoGeneratorPath") ) IS NULL THEN
     RETURN FALSE
  END IF
 
   #MOD-490220
  IF ( ls_scoFlag := cl_client_env("SCO_CaptureFlag") ) IS NULL THEN
     IF NOT cl_startRcpDaemon() THEN
        RETURN FALSE
     END IF
 
     LET gs_client = cl_getClientIP()
 
     LET lch_pipe = base.Channel.create()
     LET ls_scoPath = gs_scoPath, "\\ScoGenerator.ini"
     LET gs_command = "rsh ", gs_client, " \"type \\\"", ls_scoPath, "\\\"\""
     LET ls_scoStr = "[CAPTURE SETTINGS]"
     LET li_status = FALSE
     LET li_capture = FALSE
     CALL lch_pipe.openPipe(gs_command, "r")
     IF STATUS THEN
        CALL lch_pipe.close()
        RETURN FALSE
     END IF
     WHILE lch_pipe.read(ls_string)
         LET ls_string = ls_string.toUpperCase()
         IF ls_string.getIndexOf(ls_scoStr, 1) THEN
            LET li_capture = TRUE
            CONTINUE WHILE
         END IF
         IF ( li_capture ) AND ( ls_string.getIndexOf("[", 1) ) THEN
            LET li_capture = FALSE
         END IF
         IF ( li_capture ) AND ( ls_string.getIndexOf("ENABLED=TRUE", 1) ) THEN
            LET li_status = TRUE
            EXIT WHILE
         END IF
     END WHILE
     CALL lch_pipe.close()
     IF NOT li_status THEN
        RETURN FALSE
     END IF
  
     CALL cl_stopRcpDaemon()
  ELSE
     IF ls_scoFlag.toUpperCase() != "TRUE" THEN
        RETURN FALSE
     END IF
  END IF
  #--
 
  RETURN TRUE
END FUNCTION
 
# Descriptions...: Dump AUI Tree
# Input Parameter: none
# Return Code....: 
 
FUNCTION cl_dumpAUITree()
  DEFINE ln_root    om.DomNode
  DEFINE ls_fname   STRING
 
 
  LET ln_root = ui.Interface.getRootNode()
  LET ls_fname = FGL_GETENV("TEMPDIR"), "/", g_prog CLIPPED, "_", FGL_GETPID() USING "<<<<<<<<<<", ".xml"
  CALL ln_root.writeXml(ls_fname)
  IF STATUS THEN
     RETURN NULL
  ELSE
     RETURN ls_fname
  END IF
END FUNCTION
