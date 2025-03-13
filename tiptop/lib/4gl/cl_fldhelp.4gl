# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: cl_fldhelp.4gl
# Descriptions...: 畫面欄位說明資料維護作業
# Date & Author..: 04/06/11 Mandy
# Modify.........: No.MOD-490233 04/09/13 saki
# Modify.........: No.MOD-540037 05/04/06 alex 修COMBOBOX的問題
# Modify.........: No.MOD-570207 05/07/15 By saki 修正tiptop按第二次controlf時沒有資料顯示問題
# Modify.........: No.FUN-5A0198 05/10/27 By saki gae04顯示，增加(欄位代碼)
# Modify.........: No.FUN-690005 06/09/04 By cheunl 欄位型態定義，改為LIKE
# Modify.........: NO.FUN-640161 07/01/16 by yiting cl_err->cl_err3
# Modify.........: NO.FUN-7B0081 07/11/27 by alex 將gae06移出至gbs07
# Modify.........: NO.MOD-820175 08/02/27 by alexstar SQL語法錯誤
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
         g_gae       RECORD                       #FUN-7B0081
           gae01            LIKE gae_file.gae01,
           gae02            LIKE gae_file.gae02,
           gae03            LIKE gae_file.gae03,
           gae04            LIKE gae_file.gae04,
#          gae05            LIKE gae_file.gae05,
#          gae06            LIKE gae_file.gae06,
           gbs07            LIKE gbs_file.gbs07,  #FUN-7B0081
           gae07            LIKE gae_file.gae07,
           gae08            LIKE gae_file.gae08,
           gae09            LIKE gae_file.gae09,
           gae10            LIKE gae_file.gae10,
           gae11            LIKE gae_file.gae11,
           gae12            LIKE gae_file.gae12 
                     END RECORD,
         g_gae_t     RECORD                 
           gae01            LIKE gae_file.gae01,
           gae02            LIKE gae_file.gae02,
           gae03            LIKE gae_file.gae03,
           gae04            LIKE gae_file.gae04,
#          gae05            LIKE gae_file.gae05,
#          gae06            LIKE gae_file.gae06,
           gbs07            LIKE gbs_file.gbs07,  #FUN-7B0081
           gae07            LIKE gae_file.gae07,
           gae08            LIKE gae_file.gae08,
           gae09            LIKE gae_file.gae09,
           gae10            LIKE gae_file.gae10,
           gae11            LIKE gae_file.gae11,
           gae12            LIKE gae_file.gae12 
                     END RECORD,
#        g_gae_o     RECORD LIKE gae_file.*,         #FUN-7B0081
         g_gae01_t          LIKE gae_file.gae01,
         g_gae02_t          LIKE gae_file.gae02,
         g_gae03_t          LIKE gae_file.gae03,
         g_gae11_t          LIKE gae_file.gae11,
         g_gae12_t          LIKE gae_file.gae12,
         g_wc,g_sql         string,  #No.FUN-580092 HCN
         g_argv1            LIKE gae_file.gae01,
         g_argv2            LIKE gae_file.gae02,
         g_argv3            LIKE gae_file.gae03
 
DEFINE   g_forupd_sql   STRING                       #SELECT ... FOR UPDATE SQL
DEFINE   g_msg          LIKE ze_file.ze03            #No.FUN-690005 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-690005 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-690005 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-690005 INTEGER
DEFINE   g_no_ask       LIKE type_file.num5          #No.FUN-690005 SMALLINT
 
FUNCTION cl_fldhelp(p_argv1,p_argv2,p_argv3)
    DEFINE l_time          LIKE type_file.chr8,      #No.FUN-690005 VARCHAR(8) 
	   l_row,l_col     LIKE type_file.num5,      #No.FUN-690005 SMALLINT,
           p_argv1         LIKE gae_file.gae01,
           p_argv2         LIKE gae_file.gae02,
           p_argv3         LIKE gae_file.gae03
 
    WHENEVER ERROR CALL cl_err_msg_log

    INITIALIZE g_gae.* TO NULL
    INITIALIZE g_gae_t.* TO NULL
 
    LET g_forupd_sql = " SELECT gae01,gae02,gae03,gae04,'',gae07,gae08, ",
                              " gae09,gae10,gae11,gae12 FROM gae_file ",
                        " WHERE gae01=? AND gae02=? AND gae03=? ",
                          " AND gae11=? AND gae12=? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE cl_fldhelp_curl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET g_argv1 = p_argv1
    LET g_argv2 = p_argv2
    LET g_argv3 = p_argv3
 
    IF g_user = "tiptop" THEN
       OPEN WINDOW cl_fldhelp_w WITH FORM "lib/42f/cl_fldhelp"
            ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    ELSE
       OPEN WINDOW cl_fldhelp_w WITH FORM "lib/42f/cl_fldhelp_view"
            ATTRIBUTE(STYLE="show_log")
       CALL cl_ui_locale('cl_fldhelp_view')
       CALL cl_set_combo_lang("gae03")             #No.FUN-5A0198
       CALL cl_fldhelp_view()
       CLOSE WINDOW cl_fldhelp_w
       RETURN
    END IF
 
    CALL cl_ui_locale('cl_fldhelp')
    # 2004/03/24 新增語言別選項
    CALL cl_set_combo_lang("gae03")
 
    IF NOT cl_null(g_argv1) THEN 
       CALL cl_fldhelp_q()
    END IF
 
    WHILE TRUE
      LET g_action_choice=""
      CALL cl_fldhelp_menu()
      IF g_action_choice="exit" THEN EXIT WHILE END IF
    END WHILE
 
    CLOSE WINDOW cl_fldhelp_w
 
END FUNCTION
   
 
# Private Func...: TRUE
# Descriptions...: 
# Date & Author..: 
# Input Parameter: none
# Return code....: void
 
FUNCTION cl_fldhelp_curs()
 
   CLEAR FORM
   IF cl_null(g_argv1) THEN 
      CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
         gae01,gae03,gae02,gae04,gae08,gae09,gae07,gbs07  #gae06  #FUN-7B0081
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
      END CONSTRUCT 
 
      IF INT_FLAG THEN
          LET INT_FLAG = 0                          #No.MOD-570207
         RETURN
      END IF
 
   ELSE
       LET g_wc = "     gae01 = '",g_argv1 CLIPPED,"'",     #MOD-540037不變
                 " AND (gae02 = '",g_argv2 CLIPPED,"'",
                 "  OR  gae02 MATCHES '",g_argv2 CLIPPED,"_*')",
                 " AND gae03 = '",g_argv3 CLIPPED,"'"
   END IF
 
#  #FUN-7B0081
#  LET g_sql="SELECT rowid,gae01,gae02,gae03 FROM gae_file ", # 組合出 SQL 指令
#            " WHERE ",g_wc CLIPPED, 
#              " AND gae01 = gbs01 AND gae02=gbs02 AND gae03=gbs03 ",
#              " AND gae11 = gbs04 AND gae12=gbs05 ",
#            " ORDER BY gae01,gae02,gae03 "
   LET g_sql="SELECT gae01,gae02,gae03,gae11,gae12 FROM gae_file,gbs_file ", # 組合出 SQL 指令    #MOD-820175
             " WHERE ",g_wc CLIPPED, 
               " AND gae01 = gbs01 AND gae02=gbs02 AND gae03=gbs03 ",
               " AND gae11 = gbs04 AND gae12=gbs05 ",
             " ORDER BY gae01,gae02,gae03 "
 
   PREPARE cl_fldhelp_prepare FROM g_sql         # RUNTIME 編譯
   DECLARE cl_fldhelp_cs                         # SCROLL CURSOR
      SCROLL CURSOR WITH HOLD FOR cl_fldhelp_prepare
   LET g_sql= "SELECT COUNT(*) FROM gae_file WHERE ",g_wc CLIPPED
   PREPARE cl_fldhelp_precount FROM g_sql
   DECLARE cl_fldhelp_count CURSOR FOR cl_fldhelp_precount
END FUNCTION
 
 
# Private Func...: TRUE
# Descriptions...: 
# Date & Author..: 
# Input Parameter: none
# Return code....: void
 
FUNCTION cl_fldhelp_menu()
 
    MENU ""
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION query 
            IF g_user = "tiptop" THEN
               CALL cl_fldhelp_q()
            END IF
 
        ON ACTION next 
            CALL cl_fldhelp_fetch('N') 
 
        ON ACTION previous 
            CALL cl_fldhelp_fetch('P')
 
        ON ACTION modify 
            IF g_user = "tiptop" THEN
               CALL cl_fldhelp_u()
            END IF
 
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
 
        ON ACTION jump
            CALL cl_fldhelp_fetch('/')
 
        ON ACTION first
            CALL cl_fldhelp_fetch('F')
 
        ON ACTION last
            CALL cl_fldhelp_fetch('L')
 
        ON ACTION controlg  
            CALL cl_cmdask()
 
        ON ACTION help 
            CALL cl_show_help()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            LET g_action_choice = "exit"
            CONTINUE MENU
 
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
             LET INT_FLAG = 0                 #No.MOD-570207
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE cl_fldhelp_cs
END FUNCTION
 
 
 
# Private Func...: TRUE
# Descriptions...: 
# Date & Author..: 
# Input Parameter: none
# Return code....: void
 
FUNCTION cl_fldhelp_i(p_cmd)
 
    DEFINE p_cmd    LIKE type_file.chr1     #No.FUN-690005 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
 
#   #FUN-7B0081
#   DISPLAY BY NAME g_gae.gae01,g_gae.gae02,g_gae.gae03,g_gae.gae04,
#                   g_gae.gae06,g_gae.gae07,g_gae.gae08,g_gae.gae09
    DISPLAY BY NAME g_gae.gae01,g_gae.gae02,g_gae.gae03,g_gae.gae04,
                    g_gae.gbs07,g_gae.gae07,g_gae.gae08,g_gae.gae09
 
#   INPUT BY NAME   g_gae.gae01,g_gae.gae03,g_gae.gae02,g_gae.gae04,
#                   g_gae.gae09,g_gae.gae06,g_gae.gae08,g_gae.gae07
#       WITHOUT DEFAULTS 
 
    INPUT BY NAME   g_gae.gae01,g_gae.gae03,g_gae.gae02,g_gae.gae04,
                    g_gae.gae09,g_gae.gbs07,g_gae.gae08,g_gae.gae07
        WITHOUT DEFAULTS 
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
    END INPUT
END FUNCTION
 
# Private Func...: TRUE
# Descriptions...: 
# Date & Author..: 
# Input Parameter: none
# Return code....: void
 
FUNCTION cl_fldhelp_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL cl_fldhelp_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN cl_fldhelp_count
    FETCH cl_fldhelp_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt  
    OPEN cl_fldhelp_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_gae.gae01,SQLCA.sqlcode,0)
        INITIALIZE g_gae.* TO NULL
    ELSE
        CALL cl_fldhelp_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
 
# Private Func...: TRUE
# Descriptions...: 
# Date & Author..: 
# Input Parameter: none
# Return code....: void
 
FUNCTION cl_fldhelp_fetch(p_flgae)
 
    DEFINE p_flgae        LIKE type_file.chr1     #No.FUN-690005    VARCHAR(1)
 
    CASE p_flgae
        WHEN 'N' FETCH NEXT     cl_fldhelp_cs INTO g_gae.gae01,g_gae.gae02,g_gae.gae03,g_gae.gae11,g_gae.gae12 
        WHEN 'P' FETCH PREVIOUS cl_fldhelp_cs INTO g_gae.gae01,g_gae.gae02,g_gae.gae03,g_gae.gae11,g_gae.gae12
        WHEN 'F' FETCH FIRST    cl_fldhelp_cs INTO g_gae.gae01,g_gae.gae02,g_gae.gae03,g_gae.gae11,g_gae.gae12
        WHEN 'L' FETCH LAST     cl_fldhelp_cs INTO g_gae.gae01,g_gae.gae02,g_gae.gae03,g_gae.gae11,g_gae.gae12 
        WHEN '/'
            IF (NOT g_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
 
                PROMPT g_msg CLIPPED,': ' FOR g_jump
 
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                     CONTINUE PROMPT
 
                   ON ACTION about         #MOD-4C0121
                      CALL cl_about()      #MOD-4C0121
 
                   ON ACTION controlg      #MOD-4C0121
                      CALL cl_cmdask()     #MOD-4C0121
 
                   ON ACTION help          #MOD-4C0121
                      CALL cl_show_help()  #MOD-4C0121
                
                END PROMPT
                IF INT_FLAG THEN
                    LET INT_FLAG = 0
                    EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump cl_fldhelp_cs INTO g_gae.gae01,g_gae.gae02,g_gae.gae03,g_gae.gae11,g_gae.gae12
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_gae.gae01,SQLCA.sqlcode,0)
        RETURN
    ELSE
       CASE p_flgae
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT gae01,gae02,gae03,gae04,'',gae07,gae08,gae09,gae10,gae11,gae12
      INTO g_gae.* FROM gae_file
     WHERE gae01=g_gae.gae01 AND gae02=g_gae.gae02 AND gae03=g_gae.gae03
       AND gae11=g_gae.gae11 AND gae12=g_gae.gae12
    IF SQLCA.sqlcode THEN
        #CALL cl_err(g_gae.gae01,SQLCA.sqlcode,0)
        CALL cl_err3("sel","gae_file","","",SQLCA.sqlcode,"","",0)   #No.FUN-640161
    ELSE
        SELECT gbs07 INTO g_gae.gbs07 FROM gbs_file
         WHERE gbs01=g_gae.gae01 AND gbs02=g_gae.gae02 AND gbs03=g_gae.gae03
           AND gbs04=g_gae.gae11 AND gbs05=g_gae.gae12
        CALL cl_fldhelp_show()                      # 重新顯示
    END IF
END FUNCTION
 
 
# Private Func...: TRUE
# Descriptions...: 
# Date & Author..: 
# Input Parameter: none
# Return code....: void
 
FUNCTION cl_fldhelp_show()
  DEFINE l_gaq03    LIKE gaq_file.gaq03
  DEFINE l_gaq04    LIKE gaq_file.gaq04
  DEFINE l_gaq05    LIKE gaq_file.gaq05
  DEFINE ls_str     STRING
    LET g_gae_t.* = g_gae.*
 
#   #FUN-7B0081
#   DISPLAY BY NAME g_gae.gae01,g_gae.gae02,g_gae.gae03,g_gae.gae04,
#                   g_gae.gae06,g_gae.gae07,g_gae.gae08,g_gae.gae09
    DISPLAY BY NAME g_gae.gae01,g_gae.gae02,g_gae.gae03,g_gae.gae04,
                    g_gae.gbs07,g_gae.gae07,g_gae.gae08,g_gae.gae09
 
    SELECT gaq03,gaq04,gaq05 INTO l_gaq03,l_gaq04,l_gaq05
      FROM gaq_file
     WHERE gaq01 = g_gae.gae02
       AND gaq02 = g_gae.gae03
 
    DISPLAY l_gaq03,l_gaq04,l_gaq05 TO FORMONLY.gaq03,FORMONLY.gaq04,FORMONLY.gaq05
 
END FUNCTION
 
 
# Private Func...: TRUE
# Descriptions...: 
# Date & Author..: 
# Input Parameter: none
# Return code....: void
 
FUNCTION cl_fldhelp_u()
 
    IF s_shut(0) THEN RETURN END IF
    IF g_gae.gae01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_gae01_t = g_gae.gae01
    LET g_gae02_t = g_gae.gae02
    LET g_gae03_t = g_gae.gae03
    LET g_gae11_t = g_gae.gae11
    LET g_gae12_t = g_gae.gae12
#   LET g_gae_o.* = g_gae.*             #FUN-7B0081
    BEGIN WORK
 
    OPEN cl_fldhelp_curl USING g_gae.gae01,g_gae.gae02,g_gae.gae03,g_gae.gae11,g_gae.gae12
    IF STATUS THEN
       CALL cl_err("OPEN cl_fldhelp_curl:", STATUS, 1)
       CLOSE cl_fldhelp_curl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH cl_fldhelp_curl INTO g_gae.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_gae.gae01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL cl_fldhelp_show()                          # 顯示最新資料
    WHILE TRUE
        CALL cl_fldhelp_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_gae.*=g_gae_t.*
            CALL cl_fldhelp_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
 
        UPDATE gae_file SET gae_file.gae01 = g_gae.gae01,
                            gae_file.gae02 = g_gae.gae02,
                            gae_file.gae03 = g_gae.gae03,
                            gae_file.gae04 = g_gae.gae04,
                            gae_file.gae07 = g_gae.gae07,
                            gae_file.gae08 = g_gae.gae08,
                            gae_file.gae09 = g_gae.gae09
         WHERE gae01=g_gae01_t AND gae02=g_gae02_t AND gae03=g_gae03_t
           AND gae11=g_gae11_t AND gae12=g_gae12_t
        IF SQLCA.sqlcode THEN
            #CALL cl_err(g_gae.gae01,SQLCA.sqlcode,1)
            CALL cl_err3("upd","gae_file","","",SQLCA.sqlcode,"","",0)   #No.FUN-640161
            CONTINUE WHILE
        ELSE
            UPDATE gbs_file SET gbs_file.gbs07 = g_gae.gbs07
             WHERE gbs01=g_gae01_t AND gbs02=g_gae02_t AND gbs03=g_gae03_t
               AND gbs04=g_gae11_t AND gbs05=g_gae12_t
        END IF
        EXIT WHILE
    END WHILE
    CLOSE cl_fldhelp_curl
    COMMIT WORK   
END FUNCTION
 
 
 
# Private Func...: TRUE
# Descriptions...: 
# Date & Author..: 
# Input Parameter: none
# Return code....: void
 
FUNCTION cl_fldhelp_view()
   DEFINE   l_gae04   LIKE gae_file.gae04,
            l_gae09   LIKE gae_file.gae09,
#           l_gae06   LIKE gae_file.gae06       #FUN-7B0081
            l_gbs07   LIKE gbs_file.gbs07
   DEFINE   l_str     LIKE gae_file.gae02
 
   MENU ""  
      BEFORE MENU
#        LET l_str = g_argv2 CLIPPED,"_*"
#        SELECT gae04,gae09,gae06 INTO l_gae04,l_gae09,l_gae06 FROM gae_file 
#         WHERE gae01 = g_argv1 AND (gae02 = g_argv2 OR gae02 MATCHES l_str)
#           AND gae03 = g_argv3 
 
#        #FUN-7B0081
#        LET g_sql = "SELECT gae04,gae09,gae06 FROM gae_file",
#                    " WHERE gae01 = '",g_argv1 CLIPPED,"' ",
#                       " AND gae02 = '",g_argv2 CLIPPED,"' ",  #MOD-540037
##                     " AND (gae02 = '",g_argv2 CLIPPED,"' OR gae02 MATCHES '",g_argv2 CLIPPED,"_*')",
#                      " AND gae03 = '",g_argv3 CLIPPED,"'"
#        PREPARE cl_fldhelp_view_pre FROM g_sql
#        EXECUTE cl_fldhelp_view_pre INTO l_gae04,l_gae09,l_gae06
 
         LET g_sql = "SELECT gae04,gae09,gbs07 FROM gae_file,OUTER gbs_file ",
                     " WHERE gae01 = '",g_argv1 CLIPPED,"' ",
                       " AND gae02 = '",g_argv2 CLIPPED,"' ",
                       " AND gae03 = '",g_argv3 CLIPPED,"' ",
                       " AND gae01 = gbs01 AND gae02=gbs02 AND gae03=gbs03 ",
                       " AND gae11 = gbs04 AND gae12=gbs05 "
 
         PREPARE cl_fldhelp_view_pre FROM g_sql
         EXECUTE cl_fldhelp_view_pre INTO l_gae04,l_gae09,l_gbs07
 
         #No.FUN-5A0198 --start--
         DISPLAY g_argv1 TO gae01
         DISPLAY g_argv2 TO gae02
         DISPLAY g_argv3 TO gae03
         #No.FUN-5A0198 ---end---
         DISPLAY l_gae04 TO gae04
         DISPLAY l_gae09 TO gae09
#        DISPLAY l_gae06 TO gae06     #FUN-7B0081
         DISPLAY l_gbs07 TO gbs07
 
#     ON ACTION about         #MOD-4C0121
#        CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
#     ON ACTION help          #MOD-4C0121
#        CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION exit
         EXIT MENU
 
      ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
         LET INT_FLAG=FALSE               #MOD-570244  mars
         LET INT_FLAG = 0                 #No.MOD-570207
         EXIT MENU
 
   END MENU
END FUNCTION
        
