# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: p_contview.4gl
# Descriptions...: Report Continuous View for TIPTOP
# Date & Author..: 05/12/30 By Echo
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS
  DEFINE g_header     DYNAMIC ARRAY WITH DIMENSION 2 OF STRING
  DEFINE g_body       DYNAMIC ARRAY WITH DIMENSION 3 OF STRING
  DEFINE g_trailer    DYNAMIC ARRAY WITH DIMENSION 2 OF STRING
  DEFINE g_title      DYNAMIC ARRAY WITH DIMENSION 2 OF RECORD         
                        zaa05  LIKE zaa_file.zaa05,   #寬度
                        zaa08  LIKE zaa_file.zaa08    #欄位內容
                      END RECORD
END GLOBALS
 
DEFINE g_header_str    STRING     # Header Content
DEFINE g_trailer_str   STRING,    # Trailer Content
       g_filename   STRING,    # Report File Name(Original One)
       g_report     STRING,    # Report File Name(After Process)
       g_curr_page  LIKE type_file.num10,  #FUN-680135   INTEGER # Current Page Number
       g_total_page LIKE type_file.num10,  #FUN-680135   INTEGER # Total Pages
       g_total_line LIKE type_file.num10,  #FUN-680135   INTEGER # Total Lines of Report
       g_showline   LIKE type_file.num10   #FUN-680135   INTEGER # Show Line Number or not
DEFINE g_error_line LIKE type_file.num10   #FUN-680135   INTEGER # MOD-550032, indicate where possibly contains invalid character
DEFINE g_rec_b      LIKE type_file.num5    #單身筆數     #No.FUN-680135 SMALLINT
DEFINE l_ac         LIKE type_file.num5    #目前處理的ARRAY CNT  #No.FUN-680135 SMALLINT
 
CONSTANT MAX_LINE   INTEGER = 660
CONSTANT GI_MAX_COLUMN_COUNT INTEGER = 100,
         GI_COLUMN_WIDTH     INTEGER = 10
DEFINE   ga_table_data DYNAMIC ARRAY OF RECORD
                       field001 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field002 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field003 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field004 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field005 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field006 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field007 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field008 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field009 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field010 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field011 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field012 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field013 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field014 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field015 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field016 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field017 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field018 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field019 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field020 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field021 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field022 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field023 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field024 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field025 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field026 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field027 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field028 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255) 
                       field029 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field030 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field031 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field032 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field033 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255) 
                       field034 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field035 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field036 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255) 
                       field037 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field038 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field039 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field040 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field041 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field042 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field043 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field044 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field045 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field046 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field047 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field048 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255) 
                       field049 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field050 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field051 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field052 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255) 
                       field053 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field054 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field055 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field056 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field057 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field058 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field059 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field060 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255) 
                       field061 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field062 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field063 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field064 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field065 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field066 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field067 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field068 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field069 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field070 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field071 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field072 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field073 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field074 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field075 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field076 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field077 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field078 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field079 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field080 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field081 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255) 
                       field082 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field083 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field084 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field085 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255) 
                       field086 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field087 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255) 
                       field088 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field089 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255) 
                       field090 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field091 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field092 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255) 
                       field093 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field094 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field095 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field096 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field097 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field098 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field099 LIKE type_file.chr1000,#FUN-680135 VARCHAR(255)
                       field100 LIKE type_file.chr1000 #FUN-680135 VARCHAR(255)
                  END RECORD
 
 
MAIN
    DEFINE l_ch        base.Channel
    DEFINE l_cmd       STRING
    DEFINE l_status    LIKE type_file.num10         #FUN-680135   INTEGER
    DEFINE l_window    ui.Window
    DEFINE l_i         LIKE type_file.num10         #FUN-680135   INTEGER #MOD-550032
    DEFINE l_buf       STRING    #MOD-550032
    DEFINE l_file      STRING
 
    OPTIONS
       INPUT NO WRAP
    DEFER INTERRUPT                # Supress DEL key function
 
    WHENEVER ERROR CONTINUE
 
    LET g_filename = ARG_VAL(1)    # Report File Name
    IF cl_null(g_filename) THEN
       DISPLAY "You need to specify a report file as parameter." 
       EXIT PROGRAM
    END IF
 
# Determine if Report File exist or not
    LET l_cmd = "ls ", g_filename CLIPPED, " >/dev/null 2>/dev/null"
    RUN l_cmd RETURNING l_status
     IF l_status > 0 THEN   #MOD-530218
       DISPLAY "Report file doesn't exist." 
       EXIT PROGRAM
    END IF
###
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
   
    WHENEVER ERROR CALL cl_err_msg_log
   
    IF (NOT cl_setup("AZZ")) THEN
       EXIT PROGRAM
    END IF
 
# Adding Delimiter to End of Report File(Temporary)
    LET g_report = g_filename CLIPPED, ".tmp"
    LET l_cmd = "cat ", g_filename CLIPPED, " | sed -e 's/$//' > ", g_report
    RUN l_cmd
### 
# Calculate Total Lines of Report
    LET l_ch = base.Channel.create()
 
  # Unset LANG locale setting before counter line numbers
    LET l_cmd = "unset LANG; wc -l ", g_report CLIPPED, " | awk ' { print $1 }'"
  #----------
    CALL l_ch.openPipe(l_cmd, "r")
    WHILE l_ch.read(g_total_line)
    END WHILE
 
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
    LET g_prog = g_filename.substring(1,7)
    CALL cl_outnam('aapr121') RETURNING l_file
    CALL cl_trans_xml(g_filename,'9')
    LET g_prog = 'p_contview'
    CALL cl_contview(g_filename)
 
END MAIN
   
