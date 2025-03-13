# Prog. Version..: '5.30.06-13.03.12(00004)'     #
 
# Program name   : cl_transfer_file.4gl
# Program verion : 7.0
# Descriptions...: Transfer files between Server/Client
# Memo...........:
# Usage          : CALL cl_download_file("/tmp/a.doc", "C:/temp/b.doc")
#                  --transfer file from Server to Client
#                  CALL cl_upload_file("C:/temp/a.doc", "/tmp/b.doc")
#                  --transfer file from Client to Server
#                  CALL cl_browse_file()
#                  --open a file dialog to get a file on Client
#                  CALL cl_browse_dir()
#                  --open a directory dialog to get a directory on Client
#                  CALL cl_server_file()
#                  --open a file dialog to get a file on Server
# Date & Author  : 2004/06/24 by Brendan
# Modify         : 2005/01/03 by Brendan 
#                    -- Add functin to get file on Server side 
#                : 2005/07/06 FUN-570070 by Brendan
#                    -- Using Genero built-in File Transfer functionality
#                    -- NEED GENERO 1.32 OR HIGHER VERSION 
#                : MOD-590017 2005/09/02 by Brendan
#                    -- Need to check DVM version also
#                    -- More convenience: for example, if using $TOP inside file path(SERVER side), take into account
#
# Modify         : No.TQC-630109 06/03/10 By saki Array最大筆數控制
#}
# Modify.........: No.FUN-690005 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-7B0109 07/12/10 By Brendan 調整取得系統目前語系等資料的方式 --> 呼叫 sub function
# Modify.........: No.FUN-7C0057 07/12/19 By Brendan 調整註解(for p_findfunc)
# Modify.........: No.TQC-860016 08/06/06 By saki 修改ON IDLE段
# Modify.........: NO.FUN-980097 09/08/21 By alex 合併wos至單一4gl
# Modify.........: No.FUN-A60022 10/07/22 By Echo MSV 版本調整
 
IMPORT os
DATABASE ds        #FUN-6C0017
 
#-- No.FUN-7C0057 --------------------------------------------------------------
 
GLOBALS "../../config/top.global"
 
DEFINE gs_client   STRING,
       gs_rcp      STRING,
       g_fe_ver    LIKE bnc_file.bnc06,     #No.FUN-690005  DECIMAL(3,2),
       g_dvm_ver   LIKE bnc_file.bnc06      #No.FUN-690005  DECIMAL(3,2)   #MOD-590017
 
##################################################
# Descriptions...: 將檔案由 ERP 主機端傳輸至使用者 PC 端
# Input Parameter: ps_source STRING - 主機端來源檔完整路徑
#                  ps_target STRING - 使用者端目的檔完整路徑(含檔名)
# Return code....: TRUE  - 下載成功
#                  FALSE - 下載失敗
# Usage..........: .dbo.CALL cl_download_file("/tmp/myfile.txt", "C:/myfile.txt")
# Date & Author..: 2004/06/24 by Brendan
##################################################
FUNCTION cl_download_file(ps_source, ps_target)
  DEFINE ps_source    STRING,
         ps_target    STRING
  DEFINE ls_command   STRING
  DEFINE li_status    LIKE type_file.num10      #No.FUN-690005 INTEGER
  DEFINE lch_ch       base.Channel   #MOD-590017
 
 
  WHENEVER ERROR CALL cl_err_msg_log
 
  IF cl_null(ps_source) OR cl_null(ps_target) THEN
     RETURN FALSE
  END IF
 
  CALL cl_transferPrepare()
 
  #-- MOD-590017
  IF ps_source.getIndexOf("$", 1) THEN
     LET lch_ch = base.Channel.create()
     CALL lch_ch.openPipe("echo \"" || ps_source CLIPPED || "\"", "r")
     WHILE lch_ch.read(ps_source)
     END WHILE
     CALL lch_ch.close()
  END IF
  #-- MOD-590017 end
 
  #-- FUN-570070 -------------------------------------------------------------
  # Determine FrontEnd version,
  #   if greater than 1.32, then using built-in file transfer functionality
  #   if less than 1.32, then using rcp functionality
  #----------------------------------------------------------------------------
  IF g_dvm_ver >= 1.32 AND g_fe_ver >= 1.32 THEN   #MOD-590017
     CALL FGL_PUTFILE(ps_source, ps_target)
     IF STATUS THEN
        RETURN FALSE
     ELSE
        RETURN TRUE
     END IF
  ELSE
     IF NOT cl_startRcpDaemon() THEN
        RETURN FALSE
     END IF
     LET ls_command = gs_rcp, " ", ps_source, " ", gs_client, ":\"", ps_target, "\" >/dev/null 2>&1"
     RUN ls_command RETURNING li_status
     CALL cl_stopRcpDaemon()
     IF li_status > 0 THEN
        RETURN FALSE
     ELSE
        RETURN TRUE
     END IF
  END IF
END FUNCTION
 
##################################################
# Descriptions...: 將檔案由使用者 PC 端傳輸至 ERP 主機端
# Input Parameter: ps_source STRING - 使用者端來源檔完整路徑
#                  ps_target STRING - 主機端目錄檔完整路徑(含檔名)
# Return code....: TRUE  - 上載成功
#                  FALSE - 上載失敗
# Usage..........: .dbo.CALL cl_upload_file("C:/myfile.txt", "/tmp/myfile.txt")
# Date & Author..: 2004/06/24 by Brendan
##################################################
FUNCTION cl_upload_file(ps_source, ps_target)
  DEFINE ps_source    STRING,
         ps_target    STRING
  DEFINE ls_command   STRING
  DEFINE li_status    LIKE type_file.num10      #No.FUN-690005 INTEGER
  DEFINE lch_ch       base.Channel   #MOD-590017
 
 
  IF cl_null(ps_source) OR cl_null(ps_target) THEN
     RETURN FALSE
  END IF
 
  CALL cl_transferPrepare()
 
  #-- MOD-590017
  IF ps_target.getIndexOf("$", 1) THEN
     LET lch_ch = base.Channel.create()
     CALL lch_ch.openPipe("echo \"" || ps_target CLIPPED || "\"", "r")
     WHILE lch_ch.read(ps_target)
     END WHILE
     CALL lch_ch.close()
  END IF
  #-- MOD-590017 end
 
  #-- FUN-570070 -------------------------------------------------------------
  # Determine FrontEnd version,
  #   if greater than 1.32, then using built-in file transfer functionality
  #   if less than 1.32, then using rcp functionality
  #----------------------------------------------------------------------------
  IF g_dvm_ver >= 1.32 AND g_fe_ver >= 1.32 THEN   #MOD-590017
     CALL FGL_GETFILE(ps_source, ps_target)
     IF STATUS THEN
        RETURN FALSE
     ELSE
        RETURN TRUE
     END IF
  ELSE
     IF NOT cl_startRcpDaemon() THEN
        RETURN FALSE
     END IF
     LET ls_command = gs_rcp, " ", gs_client, ":\"", ps_source, "\" ", ps_target, " >/dev/null 2>&1"
     RUN ls_command RETURNING li_status
     CALL cl_stopRcpDaemon()
     IF li_status > 0 THEN
        RETURN FALSE
     ELSE
        RETURN TRUE
     END IF
  END IF
END FUNCTION
 
##################################################
# Descriptions...: 於使用者端開啟一檔案選擇視窗
# Input Parameter: none
# Return code....: file STRING - 選擇的檔案路徑或 NULL 值表示沒有選取任何檔案
# Usage..........: CALL cl_browse_file()
# Date & Author..: 2004/06/24 by Brendan
##################################################
FUNCTION cl_browse_file()
  DEFINE ls_file   STRING
 
 
  CALL ui.Interface.frontCall("standard",
                              "openfile",
                              ["C:", "All Files", "*.*", "File Browser"],
                              [ls_file])
 
  IF STATUS THEN
     RETURN NULL
  END IF
 
  RETURN ls_file
END FUNCTION
 
 
##################################################
# Descriptions...: 於使用者端開啟一目錄選擇視窗
# Input Parameter: none
# Return code....: directory STRING - 選擇的目錄路徑或 NULL 值表示沒有選取任何目錄
# Usage..........: CALL cl_browse_dir()
# Date & Author..: 2004/07/14 by Brendan
##################################################
FUNCTION cl_browse_dir()
  DEFINE ls_dir   STRING
 
 
  CALL ui.Interface.frontCall("standard",
                              "opendir",
                              ["C:", "Directory Browser"],
                              [ls_dir])
 
  IF STATUS THEN
     RETURN NULL
  END IF
 
  RETURN ls_dir
END FUNCTION
 
 
##################################################
# Descriptions...: 於使用者端開啟一檔案選擇視窗(主機端檔案列表)
# Input Parameter: ps_path STRING - 預設開啟的主機端目錄
# Return code....: file STRING - 選擇的檔案路徑或 NULL 值表示沒有選取任何檔案
# Usage..........: CALL cl_server_file("/u1/topprod/tiptop")
# Date & Author..: 2005/01/03 by Brendan
##################################################
FUNCTION cl_server_file(ps_path)
  DEFINE ps_path     STRING
  DEFINE la_list     DYNAMIC ARRAY OF RECORD
                        t            STRING,
                        file         STRING,
                        size         STRING,
                        date         STRING,
                        permission   STRING,
                        owner        STRING,
                        group        STRING 
                     END RECORD
  DEFINE la_list_t   DYNAMIC ARRAY OF RECORD
                        t            STRING,
                        file         STRING,
                        size         STRING,
                        date         STRING,
                        permission   STRING,
                        owner        STRING,
                        group        STRING 
                     END RECORD
  DEFINE ls_prefix   STRING,
         ls_str      STRING,
         ls_buf      STRING,
         ls_cmd      STRING
  DEFINE lch_cmd     base.Channel 
  DEFINE li_ac       LIKE type_file.num10,      #No.FUN-690005 INTEGER 
         li_rec      LIKE type_file.num10,      #No.FUN-690005 INTEGER 
         li_status   LIKE type_file.num10,      #No.FUN-690005 INTEGER 
         li_i        LIKE type_file.num10,      #No.FUN-690005 INTEGER 
         li_j        LIKE type_file.num10,      #No.FUN-690005 INTEGER 
         li_year     LIKE type_file.num10,      #No.FUN-690005 INTEGER 
         li_month    LIKE type_file.num10,      #No.FUN-690005 INTEGER 
         li_day      LIKE type_file.num10,      #No.FUN-690005 INTEGER 
         li_select   LIKE type_file.num10       #No.FUN-690005 INTEGER
  DEFINE lst_list    base.StringTokenizer
  DEFINE g_db_type   LIKE type_file.chr3    # FUN-A60022---add 
  DEFINE l_str       STRING                 # FUN-A60022---add
  DEFINE l_i         LIKE type_file.num10   # FUN-A60022---add 
 
  IF cl_null(ps_path) THEN
     LET ps_path = "."
  ELSE
    #RUN "cd " || ps_path || " >/dev/null 2>&1" RETURNING li_status          #FUN-980097
    #IF li_status != 0 THEN

    IF NOT os.Path.isdirectory(ps_path) THEN
       LET ps_path = "."
    END IF
  END IF
 
  OPEN WINDOW cl_server_file_w WITH FORM 'lib/42f/cl_server_file'
       ATTRIBUTE(STYLE="lib")
  CALL cl_ui_locale("cl_server_file")
  

  # FUN-A60022---start  
  IF os.Path.separator() = "/" THEN
     #LET ls_cmd = "unset LANG; cd ", ps_path CLIPPED, "; pwd; ls -al"
     RUN "unset LANG"
  END IF    
  IF os.Path.chdir(ps_path CLIPPED) THEN
     LET ls_cmd = "ls -a1"
  END IF
  # FUN-A60022---end

  WHILE TRUE
      LET li_rec = 1
      CALL la_list.clear()
      CALL la_list_t.clear()
      LET li_i = 0
 
    #----------
    # List files on current working directory
    #----------
      LET lch_cmd = base.Channel.create()
      CALL lch_cmd.openPipe(ls_cmd, "r")
      WHILE lch_cmd.read(ls_buf)
        LET li_i = li_i + 1
 
        #----------
        # Getting current changed directory
        #----------
        
          IF li_i = 1  THEN             #FUN-A60022
             IF li_i = 1 THEN
                #LET ls_prefix = ls_buf
                LET ls_prefix = os.Path.pwd()       #FUN-A60022

                IF ls_prefix != "/" THEN
                   IF os.Path.separator() = "/" THEN
                      LET ls_prefix = ls_prefix CLIPPED, "/"
                   ELSE
                      LET ls_prefix = ls_prefix CLIPPED, "\\"
                   END IF
                END IF
             END IF
             CONTINUE WHILE
          END IF
        #----------
 
        #----------
        # If now is in top directory
        #----------
          IF ls_prefix = "/" AND li_i = 2 THEN   #FUN-A60022
             CONTINUE WHILE
          END IF
        #----------

#        
         LET la_list_t[li_rec].file = ls_buf
  
         #取得檔案修改日期
         LET la_list_t[li_rec].date = os.Path.atime(ls_buf)
   
         #判斷為目錄或檔案
         IF os.Path.isdirectory(ls_buf) THEN
            LET la_list_t[li_rec].t = "dircrea"
            LET la_list_t[li_rec].size = NULL
         ELSE
            LET la_list_t[li_rec].t = "new"
            #取得檔案size
            LET la_list_t[li_rec].size = os.Path.size(ls_buf)
         END IF
#FUN-A60022---start
{
        #----------
        # Getting individual information from file listing
        #----------
          LET lst_list = base.StringTokenizer.create(ls_buf, " 	")
          LET li_j = 1
          WHILE lst_list.hasMoreTokens()
              LET ls_str = lst_list.nextToken()
              CASE
              #----------
              # 1. Determine if it's directory or a file
              # 2. Getting file(directory) permission
              #----------
                WHEN li_j = 1
                     IF ls_str.subString(1, 1) = "d" THEN
                        LET la_list_t[li_rec].t = "dircrea"
                     ELSE
                        LET la_list_t[li_rec].t = "new"
                     END IF
                     LET la_list_t[li_rec].permission = ls_str
              #----------
 
              #----------
              # Getting owner of this file(directory)
              #----------
                WHEN li_j = 3
                     LET la_list_t[li_rec].owner = ls_str
              #----------
 
              #----------
              # Getting owner group of this file(directory)
              #----------
                WHEN li_j = 4
                     LET la_list_t[li_rec].group = ls_str
              #----------
 
              #----------
              # Getting file size except direcroty
              #----------
                WHEN li_j = 5
                     IF la_list_t[li_rec].t != "dircrea" THEN
                        LET la_list_t[li_rec].size = ls_str
                     END IF
              #----------
 
              #----------
              # Getting last modify day of file(directory)
              #----------
                WHEN li_j = 6
                     CASE ls_str.toUpperCase()
                          WHEN "JAN"
                               LET li_month = 1
                          WHEN "FEB"
                               LET li_month = 2
                          WHEN "MAR"
                               LET li_month = 3
                          WHEN "APR"
                               LET li_month = 4
                          WHEN "MAY"
                               LET li_month = 5
                          WHEN "JUN"
                               LET li_month = 6
                          WHEN "JUL"
                               LET li_month = 7
                          WHEN "AUG"
                               LET li_month = 8
                          WHEN "SEP"
                               LET li_month = 9
                          WHEN "OCT"
                               LET li_month = 10
                          WHEN "NOV"
                               LET li_month = 11
                          WHEN "DEC"
                               LET li_month = 12
                     END CASE
                WHEN li_j = 7
                     LET li_day = ls_str
                WHEN li_j = 8
                     IF ls_str.getIndexOf(":", 1) THEN
                        LET li_year = YEAR(TODAY)
                     ELSE
                        LET li_year = ls_str
                     END IF
                     LET la_list_t[li_rec].date = li_year USING '####', "-", li_month USING '&&', "-", li_day USING '&&'
              #----------
 
              #----------
              # Getting file(directory) name 
              #----------
                WHEN li_j = 9 
                     LET la_list_t[li_rec].file = ls_str
              #----------

              END CASE
              LET li_j = li_j + 1
          END WHILE
} 
#FUN-A60022---end

          LET li_rec = li_rec + 1
          #No.TQC-630109 --start--
          IF li_rec > g_max_rec THEN
             CALL cl_err( '', 9035, 0 )
             EXIT WHILE
          END IF
          #No.TQC-630109 ---end---
        #----------
      END WHILE
      CALL lch_cmd.close()
    #----------
    
    #----------
    # Re-sort appearance, directories first, then files
    #----------
      LET li_j = 1
      FOR li_i = 1 TO la_list_t.getLength()
          IF la_list_t[li_i].t = "dircrea" THEN
             LET la_list[li_j].* = la_list_t[li_i].*
             LET li_j = li_j + 1
          END IF
      END FOR
      FOR li_i = 1 TO la_list_t.getLength()
          IF la_list_t[li_i].t != "dircrea" THEN
             LET la_list[li_j].* = la_list_t[li_i].*
             LET li_j = li_j + 1
          END IF
      END FOR
    #----------
 
    #----------
    # File browser functionality
    #----------
      DISPLAY ARRAY la_list TO s_list.*  
          ATTRIBUTE(COUNT=la_list.getLength(), UNBUFFERED)
 
          BEFORE DISPLAY
              LET li_select = FALSE
              CALL DIALOG.setActionHidden("accept", TRUE)
              CALL DIALOG.setActionHidden("cancel", TRUE)
 
            #----------
            # If now is in top directory, then you can't use 'updir' action
            #----------
              IF ls_prefix = "/" THEN
                 CALL DIALOG.setActionActive("updir", FALSE)
              END IF
            #----------
 
              DISPLAY ls_prefix TO path
 
          BEFORE ROW
              LET li_ac = ARR_CURR()
 
        #----------
        # Change to selected directory, if failed(permission denied) then shows what error happen
        #----------
          AFTER DISPLAY
              # FUN-A60022---start 
              #RUN "cd " || ls_prefix CLIPPED || la_list[li_ac].file CLIPPED || " >/dev/null 2>&1" RETURNING li_status
              IF os.Path.chdir(os.Path.join(ls_prefix CLIPPED, la_list[li_ac].file CLIPPED)) THEN
                 LET ls_cmd = "ls -a1"
                 EXIT DISPLAY
              ELSE
                 LET ls_str = NULL
                 LET lch_cmd = base.Channel.create()
                 CALL lch_cmd.openPipe("cd " || os.Path.join(ls_prefix CLIPPED, la_list[li_ac].file CLIPPED) || " 2>&1", "r")
                 WHILE lch_cmd.read(ls_buf)
                     LET ls_str = ls_str, ls_buf, "\n"
                 END WHILE
              # FUN-A60022---end
                 CALL lch_cmd.close()
                 MENU "Error" ATTRIBUTE(STYLE="dialog", COMMENT=ls_str, IMAGE="exclamation")
                      ON ACTION ok
                          EXIT MENU
                      #No.TQC-860016 --start--
                      ON IDLE g_idle_seconds
                         CALL cl_on_idle()
                         CONTINUE MENU
 
                      ON ACTION controlg
                         CALL cl_cmdask()
 
                      ON ACTION about
                         CALL cl_about()
 
                      ON ACTION help
                         CALL cl_show_help()
                      #No.TQC-860016 ---end---
                 END MENU
                 CONTINUE DISPLAY
              END IF
        #----------
 
        #----------
        # Go up directory
        #----------
          ON ACTION updir
              LET li_ac = 1
              ACCEPT DISPLAY
        #----------
 
        #----------
        # If user select a directory, then goto
        #----------
          ON ACTION accept
              IF la_list[li_ac].t = "dircrea" THEN
                 ACCEPT DISPLAY
              ELSE
                 LET li_select = TRUE
                 EXIT DISPLAY
              END IF
        #---------
 
          ON ACTION cancel
              EXIT DISPLAY
 
          #No.TQC-860016 --start--
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE DISPLAY
 
          ON ACTION controlg
             CALL cl_cmdask()
 
          ON ACTION about
             CALL cl_about()
 
          ON ACTION help
             CALL cl_show_help()
          #No.TQC-860016 ---end---
      END DISPLAY
    #----------
 
      IF INT_FLAG OR li_select THEN
         EXIT WHILE
      END IF
  END WHILE
 
  CLOSE WINDOW cl_server_file_w
 
#----------
# Return selected file name expcet cancel the selection
#----------
  IF INT_FLAG THEN
     LET INT_FLAG = FALSE
     RETURN NULL
  ELSE
     RETURN ls_prefix CLIPPED || la_list[li_ac].file CLIPPED
  END IF
#----------
END FUNCTION
 
##################################################
# Private Func...: TRUE
##################################################
FUNCTION cl_transferPrepare()
  DEFINE li_idx     LIKE type_file.num10       #No.FUN-690005 INTEGER
  DEFINE lch_ch     base.Channel
  DEFINE ls_str     STRING,
         ls_fe_ver  STRING,
         ls_dvm_ver STRING,   #MOD-590017
         ls_ver     STRING
  DEFINE lst_tok    base.StringTokenizer
  DEFINE li_cnt     LIKE type_file.num10       #No.FUN-690005 INTEGER
 
 
  #-- FUN-570070 --------------------------------------------------------------
  # Determine FrontEnd version, 
  #   if greater than 1.32, then using built-in file transfer functionality
  #   if less than 1.32, then using rcp functionality
  #----------------------------------------------------------------------------
#-- No.FUN-7B0109 BEGIN --------------------------------------------------------
# 呼叫 sub function 取得 GDC 版本
#-------------------------------------------------------------------------------
  #LET ls_fe_ver = ui.Interface.getFrontEndVersion()
  LET ls_fe_ver = cl_get_gdc_version()
#-- No.FUN-7B0109 END ----------------------------------------------------------
  LET lst_tok = base.StringTokenizer.create(ls_fe_ver, ".")
  LET li_cnt = 1
  INITIALIZE ls_ver TO NULL
  WHILE lst_tok.hasMoreTokens()
      IF li_cnt > 2 THEN
         EXIT WHILE
      END IF
      IF li_cnt != 1 THEN
         LET ls_ver = ls_ver CLIPPED, "."
      END IF
      LET ls_ver = ls_ver CLIPPED, lst_tok.nextToken()
      LET li_cnt = li_cnt + 1
  END WHILE
  LET g_fe_ver = ls_ver
 
  #-- MOD-590017 --------------------------------------------------------------
  # Determine DVM version, 
  #   if greater than 1.32, then using built-in file transfer functionality
  #   if less than 1.32, then using rcp functionality
  #----------------------------------------------------------------------------
#-- No.FUN-7B0109 BEGIN --------------------------------------------------------
# 呼叫 sub function 取得 DVM 版本
#-------------------------------------------------------------------------------
  INITIALIZE ls_ver TO NULL
#  LET lch_ch = base.Channel.create()
#  CALL lch_ch.openPipe("fpi", "r")
#  IF NOT STATUS THEN
#     WHILE lch_ch.read(ls_str)
#         LET ls_str = ls_str.toUpperCase()
#         IF ( li_idx := ls_str.getIndexOf("VERSION", 1) ) THEN
#            LET ls_dvm_ver = ls_str.subString(li_idx + 7, ls_str.getLength())
#            LET ls_dvm_ver = ls_dvm_ver.trim()
#            EXIT WHILE
#         END IF
#     END WHILE
#     CALL lch_ch.close()
   LET ls_dvm_ver = cl_get_dvm_version()
     
   LET lst_tok = base.StringTokenizer.create(ls_dvm_ver, ".")
   LET li_cnt = 1
   WHILE lst_tok.hasMoreTokens()
       IF li_cnt > 2 THEN
          EXIT WHILE
       END IF
       IF li_cnt != 1 THEN
          LET ls_ver = ls_ver CLIPPED, "."
       END IF
       LET ls_ver = ls_ver CLIPPED, lst_tok.nextToken()
       LET li_cnt = li_cnt + 1
   END WHILE
#  END IF
#-- No.FUN-7B0109 END ----------------------------------------------------------
  LET g_dvm_ver = ls_ver
  #-- MOD-590017 end
 
  IF g_dvm_ver < 1.32 OR g_fe_ver < 1.32 THEN   #MOD-590017
     LET gs_client = cl_getClientIP()
  
     LET gs_rcp = "rcp"
     LET lch_ch = base.Channel.create()
     CALL lch_ch.openPipe("uname -a", "r")
     IF NOT STATUS THEN
        WHILE lch_ch.read(ls_str)
        END WHILE
        CALL lch_ch.close()
  
        LET ls_str = ls_str.toUpperCase()
        CASE
            WHEN ls_str.getIndexOf("AIX", 1) != 0
                 LET gs_rcp = "rcp.aix"
            WHEN ls_str.getIndexOf("SUNOS", 1) != 0
                 LET gs_rcp = "rcp.sun"
        END CASE
     END IF
  END IF
END FUNCTION
 
##################################################
# Descriptions...: 取得目前使用者端 IP
# Input Parameter: none
# Return code....: ls_client STRING - 使用者端 IP
# Usage..........: CALL cl_getclientip()
# Date & Author..: 2004/06/24 by Brendan
##################################################
FUNCTION cl_getClientIP()
  DEFINE li_idx      LIKE type_file.num10       #No.FUN-690005 INTEGER
  DEFINE ls_client   STRING
  
 
  LET ls_client = FGL_GETENV("FGL_WEBSERVER_REMOTE_ADDR") 
  IF cl_null(ls_client) THEN
     LET ls_client = FGL_GETENV("FGLSERVER")
  END IF
  LET li_idx = ls_client.getIndexOf(":", 1)
  IF li_idx != 0 THEN
     LET ls_client = ls_client.subString(1, li_idx - 1)
  END IF
  
  RETURN ls_client
END FUNCTION
 
##################################################
# Private Func...: TRUE
##################################################
FUNCTION cl_startRcpDaemon()
  DEFINE li_status   LIKE type_file.num10       #No.FUN-690005 INTEGER
 
 
  CALL ui.Interface.frontCall("rcpd", "isStarted", [], [li_status])  
  IF NOT li_status THEN
     CALL ui.Interface.frontCall("rcpd", "start", [], [li_status])
     IF ( STATUS ) OR ( NOT li_status ) THEN
        RETURN FALSE
     END IF
  END IF
 
  RETURN TRUE
END FUNCTION
 
##################################################
# Private Func...: TRUE
##################################################
FUNCTION cl_stopRcpDaemon()
  DEFINE li_status   LIKE type_file.num10       #No.FUN-690005 INTEGER
 
 
  CALL ui.Interface.frontCall("rcpd", "stop", [], [li_status])
END FUNCTION
