# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: p_zba.4gl
# Descriptions...: 客戶需求處理
# Date & Author..: 94/05/31 By Roger
# Modify.........: No.FUN-510050 05/02/21 pengu 報表轉XML
# Modify.........: No.MOD-580056 05/08/05 yiting key可更改
# Modify.........: No.FUN-570276 05/08/12 alex 修改一些明顯易見的 bug
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能monster代
# Modify.........: No.FUN-660081 06/06/25 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0080 06/10/23 By Czl g_no_ask改成mi_no_ask
# Modify.........: No.FUN-6A0096 06/10/27 By johnray l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-860017 08/06/09 By Jerry 修改程式控制區間內,缺乏ON IDLE的部份
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A10067 10/01/13 By Hiko 將shell增加錯誤的地方移除..
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_zba                   RECORD LIKE zba_file.*,
    g_zba_t                 RECORD LIKE zba_file.*,
    g_zba01_t               LIKE zba_file.zba01,
    g_wc,g_sql              STRING                 #No.FUN-580092 HCN
 
 DEFINE g_before_input_done LIKE type_file.num5     #NO.MOD-580056 #No.FUN-680135 SMALLINT
DEFINE g_forupd_sql         STRING                  #SELECT ... FOR UPDATE SQL
DEFINE g_cnt                LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE g_i                  LIKE type_file.num5     #count/index for any purpose #No.FUN-680135 SMALLINT
DEFINE g_msg                LIKE type_file.chr1000  #No.FUN-680135 VARCHAR(72)
DEFINE g_curs_index         LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE g_row_count          LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE g_jump               LIKE type_file.num10,   #No.FUN-680135 INTEGER
       mi_no_ask            LIKE type_file.num5     #No.FUN-680135 SMALLINT #No.FUN-6A0080
 
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
  
    #FUN-A10067:因為只是移除一段多餘的程式碼,所以就沒有其他註記了.

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
   INITIALIZE g_zba.* TO NULL
   INITIALIZE g_zba_t.* TO NULL
   LET g_forupd_sql = "SELECT * FROM zba_file WHERE zba01=? AND zba02=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_zba_curl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
    OPEN WINDOW p_zba_w WITH FORM "azz/42f/p_zba" 
         ATTRIBUTE(STYLE=g_win_style CLIPPED)
    CALL cl_ui_init()
 
    CALL p_zba_menu()
 
    CLOSE WINDOW p_zba_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
END MAIN
 
FUNCTION p_zba_curs()
    CLEAR FORM
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
              zba01, zba02, zba03, zba04, zba05,
              zba061, zba07, zba08,
#             zba061, zba062, zba063, zba07, zba08,
              zba111, zba112, zba113,
              zba12, zba122,zba13, zba14, zba15,
              zba16, zba17, zba18, zba19,
              zba21, zba22, zba23, zba24
#TQC-860017 start
       ON ACTION about
          CALL cl_about()
 
       ON ACTION controlg
          CALL cl_cmdask()
 
       ON ACTION help
          CALL cl_show_help()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
#TQC-860017 end
    LET g_sql="SELECT zba01,zba02 FROM zba_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY zba01"
    PREPARE p_zba_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE p_zba_curs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR p_zba_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM zba_file WHERE ",g_wc CLIPPED
    PREPARE p_zba_pcount FROM g_sql
    DECLARE p_zba_count CURSOR FOR p_zba_pcount
 
END FUNCTION
 
FUNCTION p_zba_menu()  #中文
    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        ON ACTION insert                         #"A.輸入" HELP 32001
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
               CALL p_zba_a() 
            END IF
 
        ON ACTION query                          #"Q.查詢" HELP 32002
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN 
               CALL p_zba_q() 
            END IF
 
        ON ACTION first                          #KEY(F)
            CALL p_zba_fetch('F')
 
        ON ACTION previous                       #"P.上筆" HELP 32004
            CALL p_zba_fetch('P')
 
        ON ACTION jump                           #KEY('/')
            CALL p_zba_fetch('/')
 
        ON ACTION next                           #"N.下筆" HELP 32003
            CALL p_zba_fetch('N') 
 
        ON ACTION last                           #KEY(L)
            CALL p_zba_fetch('L')
 
        ON ACTION modify                         #"U.更改" HELP 32005
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN 
               CALL p_zba_u() 
            END IF
 
        ON ACTION delete                         #"R.取消" HELP 32006
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
               CALL p_zba_r() 
            END IF
 
        ON ACTION output                         #"O.列印"
            LET g_action_choice="output"
            IF cl_chk_act_auth() THEN
               CALL p_zba_out()
            END IF
 
        ON ACTION confirm 
            LET g_action_choice="confirm"
            IF cl_chk_act_auth() THEN 
               CALL p_zba_2() 
            END IF
 
        ON ACTION start 
            LET g_action_choice="start"
            IF cl_chk_act_auth() THEN 
               CALL p_zba_3(3) 
            END IF
 
        ON ACTION finish
            LET g_action_choice="finish" 
            IF cl_chk_act_auth() THEN 
               CALL p_zba_3(4) 
            END IF
 
        ON ACTION help                           #"H.說明" HELP 10102
            CALL cl_show_help()
 
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#          EXIT MENU
 
        ON ACTION exit                           #"Esc.結束"
           LET g_action_choice="exit"
           EXIT MENU
 
        ON ACTION controlg                       #KEY(CONTROL-G)
           CALL cl_cmdask()
 
#       ON ACTION interrupt
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145                     #FUN-570276
            LET g_action_choice = "exit"
            EXIT MENU
 
#       ON ACTION print                          #"T.列印"   #FUN-570276
#           LET g_action_choice="print"                      #FUN-570276
#           IF cl_chk_act_auth() THEN
#              CALL p_zba_out()
#           END IF
                        
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE MENU
                        
    END MENU
    CLOSE p_zba_curs
END FUNCTION
 
FUNCTION p_zba_a()
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_zba.* LIKE zba_file.*
    LET g_zba01_t = NULL
    CALL cl_opmsg('a')
 
    WHILE TRUE
        LET g_zba.zba02 = TODAY
        LET g_zba.zba07 = 'Open'
        LET g_zba.zba08 = g_user
        CALL p_zba_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF cl_null(g_zba.zba01) THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO zba_file VALUES(g_zba.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_zba.zba01,SQLCA.sqlcode,0)   #No.FUN-660081
            CALL cl_err3("ins","zba_file",g_zba.zba01,g_zba.zba02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
            CONTINUE WHILE
        ELSE
            LET g_zba_t.* = g_zba.*                # 保存上筆資料
            SELECT zba01,zba02 INTO g_zba.zba01,g_zba.zba02 FROM zba_file
                WHERE zba01 = g_zba.zba01
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION p_zba_i(p_cmd)
    DEFINE l_str           LIKE zba_file.zba01,         #No.FUN-680135 VARCHAR(10)
           p_cmd           LIKE type_file.chr1,         #No.FUN-680135 VARCHAR(1)
           l_n             LIKE type_file.num5          #No.FUN-680135 SMALLINT
 
    CALL p_zba_show_zba07()
    INPUT BY NAME
            g_zba.zba01, g_zba.zba02, g_zba.zba03, g_zba.zba04, g_zba.zba05,
            g_zba.zba061,g_zba.zba08
#           g_zba.zba061, g_zba.zba062, g_zba.zba063, g_zba.zba08
        WITHOUT DEFAULTS 
 
    #NO.MOD-580056------
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL p_zba_set_entry(p_cmd)
         CALL p_zba_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
   #--------END
 
            
        AFTER FIELD zba01
            IF NOT cl_null(g_zba.zba01) THEN
               LET g_zba.zba03 = g_zba.zba01[1,3]
               DISPLAY BY NAME g_zba.zba03
               IF cl_null(g_zba.zba01[5,10]) THEN
                  LET l_str = g_zba.zba01[1,3]
                  SELECT MAX(zba01) INTO l_str FROM zba_file
                         WHERE zba01[1,3] = l_str
                  IF STATUS THEN LET l_str = NULL END IF
                  IF l_str IS NULL THEN LET l_str = '0000000000' END IF
                  LET g_zba.zba01[5,10] = (l_str[5,10] + 1) USING '&&&&&&'
                  DISPLAY BY NAME g_zba.zba01
               END IF
               IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
                 (p_cmd = "u" AND g_zba.zba01 != g_zba01_t) THEN
                   SELECT count(*) INTO l_n FROM zba_file
                    WHERE zba01 = g_zba.zba01
                  IF l_n > 0 THEN                  # Duplicated
                     CALL cl_err(g_zba.zba01,-239,0)
                     LET g_zba.zba01 = g_zba01_t
                     DISPLAY BY NAME g_zba.zba01 
                     NEXT FIELD zba01
                 END IF
               END IF
            END IF
      #MOD-650015 --start
      #  ON ACTION CONTROLO                        # 沿用所有欄位
      #      IF INFIELD(zba01) THEN
      #          LET g_zba.* = g_zba_t.*
      #          LET g_zba.zba01[4,10] = '-'
      #          DISPLAY BY NAME g_zba.* 
      #          NEXT FIELD zba01
      #      END IF
      #MOD-650015 --end
        ON ACTION insert_customer
            INSERT INTO zbb_file VALUES(g_zba.zba03,g_zba.zba04)
 
        ON ACTION controlp 
            CASE WHEN INFIELD(zba04)
#                             CALL q_zbb(g_zba.zba03,g_zba.zba04)
#                                  RETURNING g_zba.zba04
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = 'q_zbb'
                      LET g_qryparam.default1 = g_zba.zba03
                      LET g_qryparam.default2 = g_zba.zba04
                      CALL cl_create_qry() RETURNING g_zba.zba04
#                      CALL FGL_DIALOG_SETBUFFER( g_zba.zba04 )
                      DISPLAY BY NAME g_zba.zba04
                 WHEN INFIELD(zba05)
#                             CALL q_zz(g_zba.zba05) RETURNING g_zba.zba05
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = 'q_zz'
                      LET g_qryparam.default1 = g_zba.zba05
                      CALL cl_create_qry()
#                      CALL FGL_DIALOG_SETBUFFER( g_zba.zba05 )
                      DISPLAY BY NAME g_zba.zba05
            END CASE
 
        ON ACTION CONTROLG 
            CALL cl_cmdask()
 
        ON ACTION controlf                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
#TQC-860017 start
 
        ON ACTION about
           CALL cl_about()
 
        ON ACTION help
           CALL cl_show_help()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
          CONTINUE INPUT
#TQC-860017 end          
    END INPUT
    CALL update_zba07()
    CALL p_zba_show_zba07()
END FUNCTION
 
FUNCTION p_zba_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL p_zba_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN p_zba_count
    FETCH p_zba_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt  
 
    OPEN p_zba_curs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_zba.zba01,SQLCA.sqlcode,0)
       INITIALIZE g_zba.* TO NULL
    ELSE
       CALL p_zba_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION p_zba_fetch(p_flzba)
    DEFINE
        p_flzba         LIKE type_file.chr1,    #No.FUN-680135 VARCHAR(1)
        l_abso          LIKE type_file.num10    #No.FUN-680135 INTEGER
 
    CASE p_flzba
        WHEN 'N' FETCH NEXT     p_zba_curs INTO g_zba.zba01,g_zba.zba02
        WHEN 'P' FETCH PREVIOUS p_zba_curs INTO g_zba.zba01,g_zba.zba02
        WHEN 'F' FETCH FIRST    p_zba_curs INTO g_zba.zba01,g_zba.zba02
        WHEN 'L' FETCH LAST     p_zba_curs INTO g_zba.zba01,g_zba.zba02
        WHEN '/'
            IF (NOT mi_no_ask) THEN          #No.FUN-6A0080
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump p_zba_curs INTO g_zba.zba01,g_zba.zba02
            LET mi_no_ask = FALSE            #No.FUN-6A0080
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_zba.zba01,SQLCA.sqlcode,0)
        INITIALIZE g_zba.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
      CASE p_flzba
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
    END IF
 
    SELECT * INTO g_zba.* FROM zba_file            # 重讀DB,因TEMP有不被更新特性
     WHERE zba01=g_zba.zba01 AND zba02=g_zba.zba02
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_zba.zba01,SQLCA.sqlcode,0)   #No.FUN-660081
        CALL cl_err3("sel","zba_file",g_zba.zba01,"",SQLCA.sqlcode,"","",0)    #No.FUN-660081
    ELSE
        CALL p_zba_show()                      # 重新顯示
    END IF
 
END FUNCTION
 
FUNCTION p_zba_show()
    LET g_zba_t.* = g_zba.*
    DISPLAY BY NAME
            g_zba.zba01, g_zba.zba02, g_zba.zba03, g_zba.zba04, g_zba.zba05,
            g_zba.zba061, g_zba.zba08,
#           g_zba.zba061, g_zba.zba062, g_zba.zba063, g_zba.zba08,
            g_zba.zba111, g_zba.zba112, g_zba.zba113,
            g_zba.zba12, g_zba.zba122,g_zba.zba13, g_zba.zba14, g_zba.zba15,
            g_zba.zba16, g_zba.zba17, g_zba.zba18, g_zba.zba19,
            g_zba.zba21, g_zba.zba22, g_zba.zba23, g_zba.zba24
    CALL p_zba_show_zba07()
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION p_zba_show_zba07()
    DISPLAY BY NAME g_zba.zba07
    IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        DISPLAY "Open,Hold,Accept,Work,Finish,Reject,Close" AT 8,22
          CASE WHEN g_zba.zba07[1,1] = 'O' DISPLAY "Open"   AT 8,22 
               WHEN g_zba.zba07[1,1] = 'H' DISPLAY "Hold"   AT 8,27 
               WHEN g_zba.zba07[1,1] = 'A' DISPLAY "Accept" AT 8,32 
               WHEN g_zba.zba07[1,1] = 'W' DISPLAY "Work"   AT 8,39 
               WHEN g_zba.zba07[1,1] = 'F' DISPLAY "Finish" AT 8,44 
               WHEN g_zba.zba07[1,1] = 'R' DISPLAY "Reject" AT 8,51 
               WHEN g_zba.zba07[1,1] = 'C' DISPLAY "Close " AT 8,58 
          END CASE
    ELSE 
        DISPLAY "Open,Hold,Accept,Work,Finish,Reject,Close" AT 8,16
          CASE WHEN g_zba.zba07[1,1] = 'O' DISPLAY "Open"   AT 8,16 
               WHEN g_zba.zba07[1,1] = 'H' DISPLAY "Hold"   AT 8,21 
               WHEN g_zba.zba07[1,1] = 'A' DISPLAY "Accept" AT 8,26 
               WHEN g_zba.zba07[1,1] = 'W' DISPLAY "Work"   AT 8,33 
               WHEN g_zba.zba07[1,1] = 'F' DISPLAY "Finish" AT 8,38 
               WHEN g_zba.zba07[1,1] = 'R' DISPLAY "Reject" AT 8,45 
               WHEN g_zba.zba07[1,1] = 'C' DISPLAY "Close " AT 8,55 
          END CASE
    END IF 
#123456789012345678901234567890123456789012345678901234567890
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#狀態:[zba07 ] (Open,Hold,Accept,Work,Finish,Reject,Close)
END FUNCTION
 
FUNCTION p_zba_u()
    IF g_zba.zba01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    MESSAGE "" CALL cl_opmsg('u')
    LET g_zba01_t = g_zba.zba01
    BEGIN WORK
    OPEN p_zba_curl USING g_zba.zba01, g_zba.zba02
    IF STATUS THEN 
       CALL cl_err(g_zba.zba01,STATUS,0) 
       CLOSE p_zba_curl
       ROLLBACK WORK
       RETURN 
    END IF
    FETCH p_zba_curl INTO g_zba.*
    IF STATUS THEN 
       CALL cl_err(g_zba.zba01,STATUS,0) 
       CLOSE p_zba_curl
       ROLLBACK WORK
       RETURN 
    END IF
    CALL p_zba_show()                          # 顯示最新資料
    WHILE TRUE
        CALL p_zba_i("u")                      # 欄位更改
        IF INT_FLAG THEN LET INT_FLAG = 0 CALL cl_err('',9001,0) EXIT WHILE
        END IF
        UPDATE zba_file SET zba_file.* = g_zba.*    # 更新DB
            WHERE zba01=g_zba.zba01 AND zba02=g_zba.zba02             # COLAUTH?
        IF STATUS THEN 
#          CALL cl_err(g_zba.zba01,STATUS,0)   #No.FUN-660081
           CALL cl_err3("upd","zba_file",g_zba01_t,"",STATUS,"","",0)    #No.FUN-660081
           CONTINUE WHILE 
        END IF
        EXIT WHILE
    END WHILE
    CLOSE p_zba_curl
    COMMIT WORK
END FUNCTION
 
FUNCTION p_zba_2()
    IF g_zba.zba01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    MESSAGE "" CALL cl_opmsg('u')
    LET g_zba01_t = g_zba.zba01
 
    BEGIN WORK
 
    OPEN p_zba_curl USING g_zba.zba01, g_zba.zba02 
    IF STATUS THEN 
       CALL cl_err(g_zba.zba01,STATUS,0) 
       CLOSE p_zba_curl
       ROLLBACK WORK
       RETURN 
    END IF
    FETCH p_zba_curl INTO g_zba.*
    IF STATUS THEN 
       CALL cl_err(g_zba.zba01,STATUS,0) 
       CLOSE p_zba_curl
       ROLLBACK WORK
       RETURN 
    END IF
 
    CALL p_zba_show()                          # 顯示最新資料
    WHILE TRUE
        IF g_zba.zba12 IS NULL THEN
           LET g_zba.zba12 = g_user DISPLAY BY NAME g_zba.zba12
        END IF
        IF g_zba.zba13 IS NULL THEN
           LET g_zba.zba13 = TODAY DISPLAY BY NAME g_zba.zba13
        END IF
        INPUT BY NAME
            g_zba.zba111,g_zba.zba112,g_zba.zba113,
            g_zba.zba12, g_zba.zba122,g_zba.zba13, g_zba.zba14, g_zba.zba15,
            g_zba.zba16, g_zba.zba17, g_zba.zba18, g_zba.zba19
            WITHOUT DEFAULTS
            AFTER FIELD zba12
               IF g_zba.zba12 IS NULL THEN NEXT FIELD zba12 END IF
            AFTER FIELD zba13
               IF g_zba.zba13 IS NULL THEN NEXT FIELD zba13 END IF
            AFTER FIELD zba14
               IF g_zba.zba14 IS NULL THEN NEXT FIELD zba14 END IF
            AFTER FIELD zba15
               CASE WHEN g_zba.zba15[1,1] = 'H' LET g_zba.zba15 = 'Hold'
                    WHEN g_zba.zba15[1,1] = 'A' LET g_zba.zba15 = 'Accept'
                    WHEN g_zba.zba15[1,1] = 'R' LET g_zba.zba15 = 'Reject'
                    WHEN g_zba.zba15[1,1] = 'C' LET g_zba.zba15 = 'Close'
                    OTHERWISE NEXT FIELD zba15
               END CASE
               DISPLAY BY NAME g_zba.zba15
        ON ACTION CONTROLP
            CASE WHEN INFIELD(zba111)
#                             CALL q_zbb('ANS',g_zba.zba111)
#                                  RETURNING g_zba.zba111
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = 'q_zba'
                      LET g_qryparam.arg1 = 'ANS'
                      LET g_qryparam.default1 = g_zba.zba111
                      CALL cl_create_qry() RETURNING g_zba.zba111
#                      CALL FGL_DIALOG_SETBUFFER( g_zba.zba111 )
                      DISPLAY BY NAME g_zba.zba111
            END CASE
 
        ON ACTION insert_customer
            INSERT INTO zbb_file VALUES('ANS',g_zba.zba111)
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
        IF INT_FLAG THEN LET INT_FLAG = 0 CALL cl_err('',9001,0) EXIT WHILE
        END IF
        CALL update_zba07()
        CALL p_zba_show_zba07()
        UPDATE zba_file SET zba_file.* = g_zba.*    # 更新DB
         WHERE zba01=g_zba.zba01 AND zba02=g_zba.zba02             # COLAUTH?
        IF STATUS THEN 
#          CALL cl_err(g_zba.zba01,STATUS,0)   #No.FUN-660081
           CALL cl_err3("upd","zba_file",g_zba01_t,"",STATUS,"","",0)    #No.FUN-660081
           CONTINUE WHILE 
        END IF
        EXIT WHILE
    END WHILE
    CLOSE p_zba_curl
    COMMIT WORK
END FUNCTION
 
FUNCTION p_zba_3(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1    #No.FUN-680135 VARCHAR(1)
    IF g_zba.zba01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    MESSAGE "" CALL cl_opmsg('u')
    LET g_zba01_t = g_zba.zba01
 
    BEGIN WORK
    OPEN p_zba_curl USING g_zba.zba01, g_zba.zba02 
    IF STATUS THEN 
       CALL cl_err(g_zba.zba01,STATUS,0) 
       CLOSE p_zba_curl
       ROLLBACK WORK
       RETURN 
    END IF
    FETCH p_zba_curl INTO g_zba.*
    IF STATUS THEN 
       CALL cl_err(g_zba.zba01,STATUS,0) 
       CLOSE p_zba_curl
       ROLLBACK WORK
       RETURN 
    END IF
 
    CALL p_zba_show()                          # 顯示最新資料
    WHILE TRUE
        INPUT BY NAME g_zba.zba21, g_zba.zba22, g_zba.zba23, g_zba.zba24
                      WITHOUT DEFAULTS
            AFTER FIELD zba21
               IF p_cmd = 4 AND
                  g_zba.zba21 IS NULL THEN NEXT FIELD zba21 END IF
            AFTER FIELD zba22
               IF g_zba.zba22 IS NULL THEN NEXT FIELD zba22 END IF
            AFTER FIELD zba23
               IF p_cmd = 4 AND
                  g_zba.zba23 IS NULL THEN NEXT FIELD zba23 END IF
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
        IF INT_FLAG THEN LET INT_FLAG = 0 CALL cl_err('',9001,0) EXIT WHILE
        END IF
        CALL update_zba07()
        CALL p_zba_show_zba07()
        UPDATE zba_file SET zba_file.* = g_zba.*    # 更新DB
         WHERE zba01=g_zba.zba01 AND zba02=g_zba.zba02             # COLAUTH?
        IF STATUS THEN 
#          CALL cl_err(g_zba.zba01,STATUS,0)   #No.FUN-660081
           CALL cl_err3("upd","zba_file",g_zba01_t,"",STATUS,"","",0)    #No.FUN-6660081
           CONTINUE WHILE 
        END IF
        EXIT WHILE
    END WHILE
    CLOSE p_zba_curl
    COMMIT WORK
END FUNCTION
 
FUNCTION update_zba07()
    IF g_zba.zba22 IS NULL AND g_zba.zba15 IS NOT NULL THEN
       LET g_zba.zba07 = g_zba.zba15
    END IF
    IF g_zba.zba22 IS NOT NULL THEN
       IF g_zba.zba23 IS NULL
          THEN LET g_zba.zba07 = 'Work'
          ELSE LET g_zba.zba07 = 'Finish'
       END IF
    END IF
END FUNCTION
 
FUNCTION p_zba_r()
    DEFINE
        l_chr LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
 
    IF g_zba.zba01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
    BEGIN WORK
    OPEN p_zba_curl USING g_zba.zba01, g_zba.zba02
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_zba.zba01,SQLCA.sqlcode,0)
        CLOSE p_zba_curl
        ROLLBACK WORK
        RETURN
    END IF
 
    FETCH p_zba_curl INTO g_zba.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_zba.zba01,SQLCA.sqlcode,0)
        CLOSE p_zba_curl
        ROLLBACK WORK
        RETURN
    END IF
 
    CALL p_zba_show()
    IF cl_delete() THEN
        DELETE FROM zba_file WHERE zba01=g_zba.zba01 AND zba02=g_zba.zba02
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_zba.zba01,SQLCA.sqlcode,0)   #No.FUN-660081
           CALL cl_err3("del","zba_file",g_zba.zba01,g_zba.zba02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
           ROLLBACK WORK
        ELSE
           CLEAR FORM
           INITIALIZE g_zba.* LIKE zba_file.*
           OPEN p_zba_count
           FETCH p_zba_count INTO g_row_count
           DISPLAY g_row_count TO FORMONLY.cnt
           OPEN p_zba_curs
           IF g_curs_index = g_row_count + 1 THEN
              LET g_jump = g_row_count
              CALL p_zba_fetch('L')
           ELSE
              LET g_jump = g_curs_index
              LET mi_no_ask = TRUE             #No.FUN-6A0080
              CALL p_zba_fetch('/')
           END IF
        END IF
    END IF
    CLOSE p_zba_curl
    COMMIT WORK
END FUNCTION
 
FUNCTION p_zba_out()
    DEFINE
        l_i             LIKE type_file.num5,     #No.FUN-680135 SMALLINT
        l_name          LIKE type_file.chr20,    # External(Disk) file name  #No.FUN-680135 VARCHAR(20)
        l_za05          LIKE type_file.chr1000,  #No.FUN-680135 VARCHAR(40)
        l_chr           LIKE type_file.chr1      #No.FUN-680135 VARCHAR(1)
 
    IF cl_null(g_wc) THEN 
       LET g_wc=" zba01= '",g_zba.zba01,"' AND"," zba02='",g_zba.zba02,"'"
    END IF 
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0) RETURN END IF
 
    CALL cl_wait()
    CALL cl_outnam('p_zba') RETURNING l_name
    SELECT zo12 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
    LET g_sql="SELECT * FROM zba_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED
    PREPARE p_zba_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE p_zba_curo                         # SCROLL CURSOR
         CURSOR FOR p_zba_p1
 
    START REPORT p_zba_rep TO l_name
 
    FOREACH p_zba_curo INTO g_zba.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1) 
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT p_zba_rep(g_zba.*)
    END FOREACH
 
    FINISH REPORT p_zba_rep
 
    CLOSE p_zba_curo
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT p_zba_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,    #No.FUN-680135 VARCHAR(1)
        sr RECORD LIKE zba_file.*,
        l_chr           LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line   #No.MOD-580242
 
    ORDER BY sr.zba01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT g_dash[1,g_len]
            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
                  g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
                  g_x[39] CLIPPED,g_x[40] CLIPPED
            PRINT g_dash1
            LET l_trailer_sw = 'y'
        ON EVERY ROW
            PRINT COLUMN g_c[31],sr.zba01,
                  COLUMN g_c[32],sr.zba02,
                  COLUMN g_c[33],sr.zba05,
                  COLUMN g_c[34],sr.zba04,
                  COLUMN g_c[35],sr.zba08[1,6],
                  COLUMN g_c[36],sr.zba07,
                  COLUMN g_c[37],sr.zba12,
                  COLUMN g_c[38],sr.zba14,
                  COLUMN g_c[39],sr.zba15,
                  COLUMN g_c[40],sr.zba19
            PRINT
            PRINT COLUMN g_c[31],g_x[13],COLUMN g_c[36],g_x[14]
            IF g_zba.zba113 IS NULL THEN
               LET g_zba.zba113 = g_zba.zba24
               LET g_zba.zba24 = NULL
            END IF
            PRINT COLUMN g_c[31],sr.zba061,COLUMN g_c[36],sr.zba111 CLIPPED
#           PRINT COLUMN g_c[31],sr.zba062,COLUMN g_c[36],sr.zba112 CLIPPED
#           PRINT COLUMN g_c[31],sr.zba063,COLUMN g_c[36],sr.zba113 CLIPPED
            IF g_zba.zba24 IS NOT NULL THEN
               PRINT COLUMN g_c[32], g_zba.zba24
            END IF
            PRINT g_dash2[1,g_len]
        ON LAST ROW
            LET l_trailer_sw = 'y'
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            END IF
END REPORT
 
 #No.MOD-580056 --start
FUNCTION p_zba_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("zba01,zba02",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION p_zba_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("zba01,zba02",FALSE)
   END IF
END FUNCTION
#--END
 
