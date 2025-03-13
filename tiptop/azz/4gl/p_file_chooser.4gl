# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: p_file_chooser.4gl
# Descriptions...: 檔案瀏覽器.
# Date & Author..: 03/10/22 by Hiko
# Sample.........: r.r2 p_file_chooser 
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.TQC-860017 08/06/06 By Jerry 修改程式控制區間內,缺乏ON IDLE的部份
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"
 
DEFINE   ma_file   DYNAMIC ARRAY OF STRING
 
FUNCTION open_file_chooser(ps_default_path)
   DEFINE   ps_default_path   STRING
   DEFINE   ls_log_path       STRING,
            lch_path_log      base.Channel,
            ls_path_log       STRING,
            ls_path           STRING,
            li_accept         LIKE type_file.num5    #FUN-680135 SMALLINT
            
 
   WHENEVER ERROR CONTINUE
 
   LET ls_log_path = FGL_GETENV("HOME")
 
   IF (cl_null(ps_default_path)) THEN
      LET lch_path_log = base.Channel.create()
      CALL lch_path_log.openFile(ls_log_path || "/FileChooser.log", "r")
      IF (lch_path_log.read(ls_path_log)) THEN
         LET ls_path = ls_path_log
      END IF
      CALL lch_path_log.close()
   ELSE
      LET ls_path = ps_default_path
   END IF
 
   OPEN WINDOW w_file_chooser WITH FORM "azz/42f/p_file_chooser" ATTRIBUTE(STYLE="file_chooser")
    
    CALL cl_ui_init()
 
   CLOSE WINDOW screen
 
   CALL chooser_display(ls_path) RETURNING li_accept,ls_path
 
   IF (li_accept) THEN
      LET lch_path_log = base.Channel.create()
      CALL lch_path_log.openFile(ls_log_path || "/FileChooser.log", "w")
      CALL lch_path_log.write(ls_path)
      CALL lch_path_log.close()
   ELSE
      LET ls_path = ps_default_path
   END IF
 
   CLOSE WINDOW w_file_chooser   
 
   RETURN ls_path
END FUNCTION
 
##################################################
# Description  	: 依照路徑列出所有目錄.
# Date & Author : 2003/10/23 by Hiko
# Parameter   	: ps_path   STRING   路徑條件
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION chooser_display(ps_path)
   DEFINE   ps_path         STRING
   DEFINE   lch_dir         base.Channel,
            ls_dir          STRING,
            li_i            LIKE type_file.num5,    #FUN-680135 SMALLINT
            la_dir          DYNAMIC ARRAY OF STRING
   DEFINE   lst_path        base.StringTokenizer,
            li_token        LIKE type_file.num5,    #FUN-680135 SMALLINT
            li_token_cnt    LIKE type_file.num5,    #FUN-680135 SMALLINT
            ls_path_token   STRING    
   DEFINE   li_accept       LIKE type_file.num5,    #FUN-680135 SMALLINT
            li_result       LIKE type_file.num5     #No.FUN-680135 SMALLINT
 
 
   LET ps_path = ps_path.trim()
 
   IF (cl_null(ps_path)) THEN
      LET ps_path = "/"
   ELSE
      IF (ps_path.getCharAt(ps_path.getLength()) != '/') THEN
         LET ps_path = ps_path || "/"
      END IF
   END IF
 
   DISPLAY ps_path TO dir
 
   # 2003/10/15 by Hiko : 列出此路徑的下的所有目錄.
   LET lch_dir = base.Channel.create()
   CALL lch_dir.openPipe("ls " || ps_path || " -F | grep '/'", "r")
   WHILE lch_dir.read(ls_dir)
      LET ls_dir = ls_dir.subString(1, ls_dir.getLength()-1)
      LET la_dir[li_i+1] = ls_dir
      LET li_i = li_i + 1 
   END WHILE
   CALL lch_dir.close()
 
   DISPLAY ARRAY la_dir TO s_dir.* ATTRIBUTE(COUNT=la_dir.getLength())
      ON ACTION query_1
         CALL chooser_input(ps_path) RETURNING ps_path
         EXIT DISPLAY
      ON ACTION up
         LET lst_path = base.StringTokenizer.create(ps_path, "/")
         LET li_token_cnt = lst_path.countTokens()
         WHILE lst_path.hasMoreTokens()
            LET li_token = li_token + 1
            IF (li_token = li_token_cnt) THEN
               EXIT WHILE
            END IF
 
            LET ls_path_token = ls_path_token,lst_path.nextToken(),"/" 
         END WHILE
 
         LET ps_path = "/",ls_path_token
 
         EXIT DISPLAY         
      ON ACTION down
         LET ps_path = ps_path.append(la_dir[ARR_CURR()] || "/")
         EXIT DISPLAY
      ON ACTION accept
         LET ps_path = ps_path.append(la_dir[ARR_CURR()] || "/")
         LET li_accept = TRUE
         EXIT DISPLAY
      ON ACTION cancel
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
   IF (NOT INT_FLAG) THEN
      IF (li_accept) THEN
         LET li_result = TRUE
      ELSE
         CALL chooser_display(ps_path) RETURNING li_result,ps_path
      END IF
   ELSE
      LET INT_FLAG = FALSE
      LET li_result = FALSE
   END IF
 
   RETURN li_result,ps_path
END FUNCTION
 
##################################################
# Description  	: 查詢路徑.
# Date & Author : 2003/10/23 by Hiko
# Parameter   	: dir   STRING   路徑條件
# Return   	: void
# Memo        	: 
# Modify   	:
##################################################
FUNCTION chooser_input(dir)
   DEFINE   dir   STRING
   DEFINE   ls_path   STRING
 
   
   INPUT BY NAME dir WITHOUT DEFAULTS ATTRIBUTES(UNBUFFERED)
              ON ACTION go
                 EXIT INPUT         
              ON ACTION home
                 LET dir = FGL_GETENV("HOME")
                 EXIT INPUT
   #TQC-860017 start
 
              ON ACTION about
                 CALL cl_about()
 
              ON ACTION controlg
                 CALL cl_cmdask()
 
              ON ACTION help
                 CALL cl_show_help()
 
              ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                CONTINUE INPUT
#TQC-860017 end
   END INPUT
 
   RETURN dir
END FUNCTION
