# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: p_view.4gl
# Descriptions...: Report Viewer for TIPTOP
# Date & Author..: 03/12/04 By Brendan
# Modify.........: No.MOD-530218 05/03/23 By Brendan 
# Modify.........: No.MOD-550032 05/05/05 By Brendan (1)Line counter failed if invalid character meets,
#                                                    (2)Prompt where possible has invaild character
# Modify.........: No.TQC-5B0082 05/11/10 By Brendan Using p_ze 'azz-123' message instead of hard code
# Modify.........: No.TQC-5B0177 06/02/06 By alex add close() description
# Modify.........: No.TQC-610093 06/04/14 By Echo add idle control
# Modify.........: No.FUN-680135 06/09/19 By Hellen 欄位類型修改
# Modify.........: No.TQC-860038 08/06/24 By claire 加入 cl_used()
# Modify.........: No:FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60022 10/07/27 By Echo GP5.2 SQL Server 調整
# Modify.........: No.FUN-A80029 10/08/13 By Echo GP5.2 SQL Server 調整-part2

IMPORT os        #FUN-A60022

DATABASE ds

GLOBALS "../../config/top.global"

CONSTANT MAX_LINE   INTEGER = 660

DEFINE g_content    STRING,                # Page Content
       g_filename   STRING,                # Report File Name(Original One)
       g_report     STRING,                # Report File Name(After Process)
       g_curr_page  LIKE type_file.num10,  # Current Page Number #No.FUN-680135 INTEGER
       g_total_page LIKE type_file.num10,  # Total Pages #No.FUN-680135 INTEGER
       g_total_line LIKE type_file.num10,  # Total Lines of Report #No.FUN-680135 INTEGER
       g_showline   LIKE type_file.num10   # Show Line Number or not #No.FUN-680135 INTEGER
DEFINE g_error_line LIKE type_file.num10   # MOD-550032, indicate where possibly contains invalid character #No.FUN-680135 INTEGER

MAIN
   DEFINE l_ch               base.Channel
   DEFINE l_cmd              STRING
   DEFINE l_status           LIKE type_file.num10   #No.FUN-680135 INTEGER
   DEFINE l_window           ui.Window
   DEFINE l_i                LIKE type_file.num10   #No.FUN-680135 INTEGER #MOD-550032
   DEFINE l_buf              STRING                 #MOD-550032
   DEFINE prog_idle_seconds  LIKE type_file.num10   #No.FUN-680135 SMALLINT  ### TQC-610093 ###
   DEFINE l_report           STRING                 #FUN-A60022
   DEFINE l_tok              base.StringTokenizer   #FUN-A60022

    OPTIONS
       INPUT NO WRAP
       DEFER INTERRUPT                # Supress DEL key function
    WHENEVER ERROR CONTINUE

    LET g_filename = ARG_VAL(1)    # Report File Name

    IF cl_null(g_filename) THEN
       DISPLAY "You need to specify a report file as parameter."
       EXIT PROGRAM
    END IF

    ### TQC-610093 START###
    LET prog_idle_seconds = ARG_VAL(3)    # Program Idle Seconds
    ### TQC-610093 END###

# Determine if Report File exist or not
    #FUN-A60022 -- start --
    #LET l_cmd = "ls ", g_filename CLIPPED, " >/dev/null 2>/dev/null"
    #RUN l_cmd RETURNING l_status
    #IF l_status > 0 THEN   #MOD-530218
  
    IF NOT os.Path.exists(g_filename CLIPPED) THEN
       DISPLAY "Report file doesn't exist."
       EXIT PROGRAM
    END IF
    #FUN-A60022 -- end --
###

    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("AZZ")) THEN
       EXIT PROGRAM
    END IF
 
    IF NOT cl_null(prog_idle_seconds) THEN     ### TQC-610093 ###
       LET g_idle_seconds = prog_idle_seconds
    END IF                                     ### TQC-610093 ###

    CALL cl_used(g_prog,g_time,1) RETURNING g_time

    OPEN WINDOW p_view_w WITH FORM "azz/42f/p_view"
       ATTRIBUTE(STYLE="reportViewer")
    CALL cl_ui_init()
        
# Adding Delimiter to End of Report File(Temporary)
    #FUN-A60022 --start--
    LET g_report = g_filename CLIPPED, ".tmp"
    LET l_report = g_filename CLIPPED,".bak"
    IF os.Path.separator() = "/" THEN 
       LET l_cmd = "cat ", g_filename CLIPPED, " | sed -e 's/$//' > ", g_report
    ELSE
       LET l_cmd = "cat ", g_filename CLIPPED, " > ", l_report
       RUN l_cmd 
       LET l_cmd = "%FGLRUN% ",os.Path.join( os.Path.join( FGL_GETENV("DS4GL"),"bin" ),"rsed.42m"),   #FUN-930058
                   ' "$" "" ', l_report ," ", g_report
    END IF
    #FUN-A60022 --end--
    RUN l_cmd

    #FUN-A80029 -- start --
    #LET l_cmd = "chmod a+wx ", g_report
    #RUN l_cmd
    IF os.Path.chrwx(g_report,511) THEN #chmod 777 => 7*8^2 +7*8^1 +7*8^
    END IF
    #FUN-A80029 -- end --
###

# Calculate Total Lines of Report
    LET l_ch = base.Channel.create()
   #--- MOD-550032
  # Unset LANG locale setting before counter line numbers

    #FUN-A60022 --start--
    IF os.Path.separator() = "/" THEN 
       LET l_cmd = "unset LANG; wc -l ", g_report CLIPPED, " | awk ' { print $1 }'"
       CALL l_ch.openPipe(l_cmd, "r")
       WHILE l_ch.read(g_total_line)
       END WHILE
    ELSE
       #無法使用 awk，則改自行抓取第一個值
       LET l_cmd = "wc -l ", g_report CLIPPED, " > ", l_report
       RUN l_cmd
       CALL l_ch.openFile(l_report, "r")
       WHILE l_ch.read(l_buf)
             LET l_tok = base.StringTokenizer.createExt(l_buf.trim()," ","",TRUE)
             WHILE l_tok.hasMoreTokens()
                   LET g_total_line=l_tok.nextToken()
                   EXIT WHILE
             END WHILE          
       END WHILE
    END IF
  #----------
    CALL l_ch.close()   #TQC-5B0177
    #FUN-A60022 --end--

#--- MOD-550032
  # Check if any line contains invalid character
    CALL l_ch.openFile(g_report, "r")
    LET l_i = 0
    WHILE l_ch.read(l_buf)
        LET l_i = l_i + 1
    END WHILE
    IF l_i != g_total_line THEN
       LET l_i = l_i + 1
       LET g_error_line = l_i
    ELSE
       LET g_error_line = 0
    END IF
  #----------
    CALL l_ch.close()
###

    IF cl_null(ARG_VAL(2)) THEN
       LET g_page_line = 66
    ELSE
       IF ARG_VAL(3) = '1' THEN
          LET g_page_line = g_total_line
       ELSE
          CASE
              WHEN ( ( ARG_VAL(2) <= MAX_LINE ) AND ( ARG_VAL(2) > g_total_line ) ) OR
                   ( ( ARG_VAL(2) > MAX_LINE ) AND ( g_total_line <= MAX_LINE ) )
                   LET g_page_line = g_total_line
              WHEN ( ARG_VAL(2) <= MAX_LINE ) AND ( ARG_VAL(2) <= g_total_line )
                   LET g_page_line = ARG_VAL(2)
              WHEN ( ARG_VAL(2) > MAX_LINE ) AND ( g_total_line > MAX_LINE )
                   LET g_page_line = MAX_LINE
              OTHERWISE
                   LET g_page_line = MAX_LINE
          END CASE
       END IF
    END IF

    LET l_window = ui.Window.getCurrent()
    CALL l_window.setText(g_filename)
    CALL p_view_showPage()

    #FUN-A60022 --start--
    #LET l_cmd = "rm -f ", g_report   # Remove Temporary File
    #RUN l_cmd
    CALL os.Path.delete(g_report) RETURNING l_status   # Remove Temporary File 
    CALL os.Path.delete(l_report) RETURNING l_status   # Remove Temporary File 
    #FUN-A60022 --end--

    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 

FUNCTION p_view_showPage()
    DEFINE l_page LIKE type_file.num10  #No.FUN-680135 INTEGER


    CALL p_view_calculatePage()
    LET g_showline = 0

    WHILE TRUE

        CALL p_view_loadPage()
 
        LET l_page = g_curr_page
        INPUT g_content, l_page WITHOUT DEFAULTS
              FROM FORMONLY.content, FORMONLY.curr
              ATTRIBUTE(UNBUFFERED)

            BEFORE INPUT
                DISPLAY g_total_page TO FORMONLY.total
                CALL p_view_disableAction(DIALOG)
               #--- MOD-550032
              # Prompt which line might contain invalid character
                IF g_error_line != 0 THEN
                   CALL cl_err_msg(NULL, "azz-115", g_error_line, 1)
                   LET g_error_line = 0   #Shows in first time
                END IF
              #----------

            AFTER FIELD curr
# Change Current Display Page, MUST Equal to/Less than Total Pages
                IF g_curr_page != l_page THEN
                   IF ( l_page <= 0 ) OR ( l_page > g_total_page ) THEN
                      LET l_page = g_curr_page
                   ELSE
                      LET g_curr_page = l_page
                      EXIT INPUT
                   END IF
                END IF
###

            ON IDLE g_idle_seconds  ### TQC-610093 start###
               CALL cl_on_idle()
               CONTINUE INPUT       ### TQC-610093 end###

            ON ACTION first_page   # Jump to First Page
                LET g_curr_page = 1
                EXIT INPUT

            ON ACTION next_page    # Jump to Next Page
                LET g_curr_page = g_curr_page + 1
                EXIT INPUT

            ON ACTION prev_page    # Jump to Previous Page
                LET g_curr_page = g_curr_page - 1
                EXIT INPUT

            ON ACTION last_page    # Jump to Last Page
                LET g_curr_page = g_total_page
                EXIT INPUT

            ON ACTION option       # Options for Line setting
                IF p_view_lineOption() THEN
                   EXIT INPUT
                END IF

        END INPUT
 
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           EXIT WHILE
        END IF

    END WHILE
END FUNCTION


FUNCTION p_view_loadPage()
    DEFINE l_ch           base.Channel,
           l_buf          STRING
    DEFINE l_i            LIKE type_file.num10  #No.FUN-680135 INTEGER
    DEFINE l_offset_begin LIKE type_file.num10, #No.FUN-680135 INTEGER
           l_offset_end   LIKE type_file.num10  #No.FUN-680135 INTEGER
    DEFINE l_str          STRING


    LET g_content = NULL   # Initialize Page Content
    LET l_i = 0

# Calculate Offset for this Page of Report; Begin Line & End Line
    LET l_offset_begin = ( ( g_curr_page - 1 ) * g_page_line ) + 1
    LET l_offset_end = ( l_offset_begin + g_page_line ) - 1
    IF l_offset_end > g_total_line THEN
       LET l_offset_end = g_total_line
    END IF
###
 
    LET l_ch = base.Channel.create()
    CALL l_ch.openFile(g_report, "r")
    IF STATUS THEN
       DISPLAY "Can't open/read report file."
       CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出時間) #TQC-860038 add
        RETURNING g_time
       EXIT PROGRAM
    END IF
    CALL l_ch.setDelimiter("")
    WHILE l_ch.read(l_buf)
        LET l_i = l_i + 1
        IF l_i < l_offset_begin THEN   # If Current Line Less than Begin of Offset, Continue Loop
           CONTINUE WHILE
        END IF
        IF l_i > l_offset_end THEN     # If Current Line Great than End of Offset, Exit Loop
           EXIT WHILE
        END IF
        IF g_showline THEN             # Put Line Number to Begin of Line
           LET l_buf = l_i USING '########', ": ", l_buf
        END IF
        IF l_i < l_offset_end THEN
           LET l_buf = l_buf.append("\n")
        END IF
        LET g_content = g_content.append(l_buf)
    END WHILE
    CALL l_ch.close()
END FUNCTION


FUNCTION p_view_disableAction(pd_dialog)
    DEFINE pd_dialog ui.Dialog


# If on First Page, disable "First_Page" & "Prev_Page" Action
    IF g_curr_page = 1 THEN
       CALL pd_dialog.setActionActive("first_page", FALSE)
       CALL pd_dialog.setActionActive("prev_page", FALSE)
    END IF
###

# If on Last Page, disable "Lastt_Page" & "Next_Page" Action
    IF g_curr_page = g_total_page THEN
       CALL pd_dialog.setActionActive("last_page", FALSE)
       CALL pd_dialog.setActionActive("next_page", FALSE)
    END IF
###
END FUNCTION

FUNCTION p_view_calculatePage()
    LET g_curr_page = 1
    LET g_total_page = g_total_line / g_page_line
    IF (g_total_line MOD g_page_line) THEN
       LET g_total_page = g_total_page + 1
    END IF
END FUNCTION


FUNCTION p_view_lineOption()
    DEFINE l_line   LIKE type_file.num10  #No.FUN-680135 INTEGER
    DEFINE l_status LIKE type_file.num10  #No.FUN-680135 INTEGER
    DEFINE l_msg    STRING                #TQC-5B0082
 
 
    LET l_status = FALSE
    MENU "" ATTRIBUTE(STYLE = "popup")
         ON IDLE g_idle_seconds  ### TQC-610093 start###
            CALL cl_on_idle()
            CONTINUE MENU        ### TQC-610093 end###

         ON ACTION line1
             WHILE TRUE
                 LET l_line = g_page_line
              #--- TQC-5B0082 BEGIN
                 LET l_msg = cl_getmsg("azz-123", g_lang) CLIPPED, "(Max = ", MAX_LINE USING '<<<', ") "
                 PROMPT l_msg FOR l_line
                        ATTRIBUTE(WITHOUT DEFAULTS)
                        ON IDLE g_idle_seconds  ### TQC-610093 start###
                           CALL cl_on_idle()    ### TQC-610093 end###
                 END PROMPT

              #--- TQC-5B0082 END
                 IF INT_FLAG THEN
                    LET INT_FLAG = FALSE
                    EXIT WHILE
                 ELSE
                    IF g_page_line != l_line THEN
                       IF ( l_line <= 0 ) OR ( l_line > MAX_LINE ) THEN
                          CONTINUE WHILE
                       ELSE
                          IF l_line > g_total_line THEN
                             LET g_page_line = g_total_line
                          ELSE
                             LET g_page_line = l_line
                          END IF
                          CALL p_view_calculatePage()
                          LET l_status = TRUE
                          EXIT WHILE
                       END IF
                    ELSE
                       EXIT WHILE
                    END IF
                 END IF
             END WHILE
             EXIT MENU

         ON ACTION line2
             IF g_showline THEN
                LET g_showline = 0
             ELSE
                LET g_showline = 1
             END IF
             LET l_status = TRUE
             EXIT MENU
    END MENU
    RETURN l_status
END FUNCTION

#Patch....NO:TQC-610037 <001> #
