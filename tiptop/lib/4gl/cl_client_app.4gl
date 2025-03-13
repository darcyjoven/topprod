# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Library name...: cl_client_app.4gl
# Descriptions...: Start client application
# Memo...........: 
# Usage..........: CALL cl_open_url("http://www.kimo.com.tw")
#                  --start browser to access an URL
#                  CALL cl_open_doc("C:/tiptop/tiptop.txt")
#                  --open the documentation with associated application
#                  CALL cl_open_prog("C:/Editor.exe", "C:/tiptop/tiptop.txt")
#                  --start an application following by argument
#                  CALL cl_client_env("PATH")
#                  --Get value of environment variable in Client
# Date & Author..: 2004/06/24 by Brendan
# Modify.........: No.FUN-690005 06/09/04 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-6C0017 06/12/13 By jamie   程式開頭增加'database ds'
# Modify.........: No.FUN-760043 07/06/14 By Brendan 調整呼叫程式時參數處理方式
# Modify.........: No.TQC-7B0061 07/11/13 By Echo 網址太長時，字元會被截斷
# Modify.........: No.TQC-830002 08/03/03 By Echo WEB 登入時異常，調整 browser 啟動方式
# Modify.........: No:FUN-A70081 10/07/16 By tsai_yen 若是ftp網址,直接用frontCall傳送
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"
 
##########################################################################
# Descriptions...: Start browser to access an URL
# Memo...........: 
# Input parameter: ps_url     STRING - URL location
# Return code....: TRUE/FALSE        - Success/Fail
# Usage..........: CALL cl_open_url("http://www.kimo.com.tw")
# Date & Author..: 2004/06/24 by Brendan
# Modify.........: 
##########################################################################
FUNCTION cl_open_url(ps_url)
  DEFINE ps_url       STRING
  DEFINE ls_browser   STRING
 
 
  WHENEVER ERROR CALL cl_err_msg_log
 
  #No.TQC-830002
  IF cl_null(ps_url) THEN                                
     RETURN FALSE
  END IF
  #END No.TQC-830002
 
# LET ls_browser = "C:/Program Files/Internet Explorer/IEXPLORE.EXE"
# LET ls_browser = "explorer.exe"                       #No.TQC-7B0061
  #No.TQC-830002
  IF ps_url.getindexof("ftp://",1) = 1 OR ps_url.getindexof("FTP://",1) = 1 THEN #FUN-A70081
     LET ls_browser = NULL                                                       #FUN-A70081
  ELSE                                                                           #FUN-A70081
     LET ls_browser = cl_client_env("ComSpec")           
     LET ls_browser = "\"", ls_browser, "\" /c explorer"
  END IF  #FUN-A70081
  #END No.TQC-830002
  IF cl_execClientApp(ls_browser, ps_url) THEN
     RETURN TRUE
  ELSE 
     RETURN FALSE
  END IF
END FUNCTION
 
##########################################################################
# Descriptions...: Open a documentation with associated application
# Memo...........: 
# Input parameter: ps_doc STRING - Documentation location
# Return code....: TRUE/FALSE  - Success/Error
# Usage..........: CALL cl_open_doc("C:/tiptop/tiptop.txt")
# Date & Author..: 2004/06/24 by Brendan
# Modify.........: 
##########################################################################
FUNCTION cl_open_doc(ps_doc)
  DEFINE ps_doc   STRING
 
 
  IF cl_execClientApp("", ps_doc) THEN
     RETURN TRUE
  ELSE 
     RETURN FALSE
  END IF
END FUNCTION
 
##########################################################################
# Descriptions...: Start an application following by argument
# Memo...........: 
# Input parameter: ps_prog STRING - Application location
#                  ps_arg  STRING - Executation argument
# Return code....: TRUE/FALSE     - Success/Error
# Usage..........: CALL cl_open_prog("C:/Editor.exe", "C:/tiptop/tiptop.txt")
# Date & Author..: 2004/06/24 by Brendan
# Modify.........: 
##########################################################################
FUNCTION cl_open_prog(ps_prog, ps_arg)
  DEFINE ps_prog   STRING,
         ps_arg    STRING
 
 
  #No.TQC-830002
  IF cl_null(ps_arg) THEN                                
     RETURN FALSE
  END IF
  #END No.TQC-830002
 
  #-----------------------------------------------------------------------------
  # ps_arg 多參數時以 | 作為分隔, e.x. ps_arg = "arg1|arg2|arg3 ......"
  #-----------------------------------------------------------------------------
  IF cl_execClientApp(ps_prog, ps_arg) THEN
     RETURN TRUE
  ELSE 
     RETURN FALSE
  END IF
END FUNCTION
 
##########################################################################
# Descriptions...: Get an environment variable set in the user session on the front end workstation
# Memo...........: 
# Input parameter: ps_env    STRING   - Environment variable
# Return code....: ls_value  STRING   - Value of environment variable
# Usage..........: CALL cl_client_env("PATH")
# Date & Author..: 2004/07/16 by Brendan
# Modify.........: 
##########################################################################
FUNCTION cl_client_env(ps_env)
  DEFINE ps_env     STRING
  DEFINE ls_value   STRING
 
 
  IF cl_null(ps_env) THEN
     RETURN NULL
  END IF
 
  CALL ui.Interface.frontCall("standard",
                              "getenv",
                              [ps_env],
                              [ls_value])
                               
  IF ( STATUS ) OR ( cl_null(ls_value) ) THEN
     RETURN NULL
  ELSE
     RETURN ls_value
  END IF
END FUNCTION
 
##########################################################################
# Descriptions...: 指定開啟的程式
# Memo...........:
# Input parameter: ps_app  STRING  開啟程式
#                : ps_doc  STRING  指令,檔案或URL
# Return code....: TRUE/FALSE      Success/Fail
# Usage..........: CALL cl_execClientApp(ls_browser,ls_url)
# Date & Author..: 2004/07/16 by Brendan
# Modify.........: 
##########################################################################
FUNCTION cl_execClientApp(ps_app, ps_doc)
   DEFINE ps_app       STRING,
          ps_doc       STRING
   DEFINE li_status    LIKE type_file.num10    #No.FUN-690005  INTEGER
   DEFINE ls_command   STRING
   DEFINE lt_tok       base.StringTokenizer,   #No.FUN-760043
          ls_arg       STRING                  #No.FUN-760043
 
   IF cl_null(ps_app) AND cl_null(ps_doc) THEN
      RETURN FALSE
   END IF
 
   #----------------------------------------------------------------------------
   # 若沒有指定程式, 則預設以 shellexec 方式執行指定文件(依照 Windows Registry)
   #----------------------------------------------------------------------------
   IF cl_null(ps_app) THEN
      CALL ui.Interface.frontCall("standard",
                                  "shellexec",
                                  [ps_doc],
                                  [li_status])
   ELSE
      #-------------------------------------------------------------------------
      # 指定執行程式與參數, 多參數需以 | 作為分隔 (暫不使用 No.TQC-830002)
      #-------------------------------------------------------------------------
      #LET ls_command = "\"", ps_app, "\""
      LET ls_command = ps_app                       #No.TQC-830002
 
      IF NOT cl_null(ps_doc) THEN
         #-- No.FUN-760043 BEGIN -----------------------------------------------
         LET lt_tok = base.StringTokenizer.create(ps_doc, "|")
         WHILE lt_tok.hasMoreTokens()
             LET ls_arg = lt_tok.nextToken()
             LET ls_command = ls_command, " \"", ls_arg, "\""
         END WHILE
#         LET ls_command = ls_command, " \"", ps_doc, "\""
         #-- No.FUN-760043 END -------------------------------------------------
      END IF
#     CALL ui.Interface.frontCall("standard", 
#                                 "execute",
#                                 [ls_command, 0],
#                                 [li_status])
 
      CALL ui.Interface.frontCall("standard", 
                                  "shellexec",
                                  [ls_command],
                                  [li_status])
   END IF
 
   IF ( STATUS ) OR ( NOT li_status ) THEN
      RETURN FALSE
   END IF
 
   RETURN TRUE
END FUNCTION
