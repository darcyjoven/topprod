# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: amdt002.4gl
# Descriptions...: 國外勞務
# Date & Author..: 11/10/19 By Belle (FUN-BA0021)
DATABASE ds

 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
#FUN-BA0021
DEFINE
    g_amk01           LIKE amk_file.amk01,
    g_amk01_t         LIKE amk_file.amk01,
    g_amk02           LIKE amk_file.amk02,
    g_amk02_t         LIKE amk_file.amk02,
    g_amk03           LIKE amk_file.amk03,
    g_amk03_t         LIKE amk_file.amk03,
    g_amk             RECORD                 #程式變數(Program Variables)
        amk01         LIKE amk_file.amk01,
        amk02         LIKE amk_file.amk02,
        amk03         LIKE amk_file.amk03,
        amk77         LIKE amk_file.amk77,
        amk78         LIKE amk_file.amk78,
        amk79         LIKE amk_file.amk79,
        amk80         LIKE amk_file.amk80,
        amk81         LIKE amk_file.amk81,
        amk82         LIKE amk_file.amk82,
        amk83         LIKE amk_file.amk83,
        amk84         LIKE amk_file.amk84
                      END RECORD,
    g_amk_t           RECORD                 #程式變數 (舊值)
        amk01         LIKE amk_file.amk01,
        amk02         LIKE amk_file.amk02,
        amk03         LIKE amk_file.amk03,
        amk77         LIKE amk_file.amk77,
        amk78         LIKE amk_file.amk78,
        amk79         LIKE amk_file.amk79,
        amk80         LIKE amk_file.amk80,
        amk81         LIKE amk_file.amk81,
        amk82         LIKE amk_file.amk82,
        amk83         LIKE amk_file.amk83,
        amk84         LIKE amk_file.amk84
                      END RECORD
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL  
DEFINE   g_before_input_done   LIKE type_file.num5 #No.FUN-680102 SMALLINT
DEFINE   g_cnt        LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE   g_i          LIKE type_file.num5          #count/index for any purpose
DEFINE   g_msg        LIKE type_file.chr1000       #No.FUN-680102 CHAR(72)
DEFINE   g_row_count  LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE   g_curs_index LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE   g_jump       LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE   mi_no_ask    LIKE type_file.num5          #No.FUN-680102 SMALLINT
DEFINE   l_table      STRING                       #No.FUN-760083
DEFINE   g_str        STRING                       #No.FUN-760083
DEFINE   g_wc,g_sql   STRING
DEFINE   g_argv1      LIKE amk_file.amk01 
#主程式開始
MAIN
   DEFINE p_row,p_col     LIKE type_file.num5          #No.FUN-680102 SMALLINT
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

   LET g_argv1 = ARG_VAL(1)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AMD")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time
   INITIALIZE g_amk.* TO NULL
   INITIALIZE g_amk_t.* TO NULL
 

   LET g_forupd_sql = " SELECT amk01,amk02,amk03,amk77,amk78",
                             ",amk79,amk80,amk81,amk82,amk83",
                             ",amk84",
                        " FROM amk_file",
                       " WHERE amk01=? AND amk02=? AND amk03=? FOR UPDATE"                                                          
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t002_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR    
   LET p_row = 4 LET p_col = 14
   OPEN WINDOW t002_w AT p_row,p_col
        WITH FORM "amd/42f/amdt002"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   IF NOT cl_null(g_argv1) THEN CALL t002_q() END IF

   LET g_action_choice=""
   CALL t002_menu()
 
   CLOSE WINDOW t002_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
FUNCTION t002_i(p_cmd)
DEFINE l_n         LIKE type_file.num5
DEFINE l_n1       LIKE type_file.num20_6
DEFINE p_cmd       LIKE type_file.chr8  
DEFINE li_result   LIKE type_file.num5
#DEFINE l_amk77     LIKE type_file.num10
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_amk.amk01,g_amk.amk02,g_amk.amk03,g_amk.amk77,g_amk.amk78
                  ,g_amk.amk79,g_amk.amk80,g_amk.amk81,g_amk.amk82,g_amk.amk83
                  ,g_amk.amk84
   INPUT BY NAME   g_amk.amk79,g_amk.amk80,g_amk.amk81
          WITHOUT DEFAULTS
 
      AFTER FIELD amk79
         if not cl_null(g_amk.amk79) then
            LET l_n1 = g_amk.amk79 * 0.05
            CALL cl_digcut(l_n1,0) RETURNING g_amk.amk83
            if not cl_null(g_amk.amk84) then
               LET g_amk.amk82 = g_amk.amk83 + g_amk.amk84
            end if
            if not cl_null(g_amk.amk80) and not cl_null(g_amk.amk81) then
               IF g_amk.amk78 != g_amk.amk79 + g_amk.amk80 + g_amk.amk81 THEN
                   CALL cl_err('','amd-035',0) 
               END IF
            end if
         ELSE 
            LET g_amk.amk83 = 0
            IF NOT cl_null(g_amk.amk84) THEN
               LET g_amk.amk82 = g_amk.amk84
            ELSE
               LET g_amk.amk82 = 0
            END IF
         END if
         DISPLAY BY NAME g_amk.amk78,g_amk.amk82,g_amk.amk83
      
      AFTER FIELD amk80
         if not cl_null(g_amk.amk80) then
           #LET l_n1 = g_amk.amk80 *  l_amk77 * 0.05
            LET l_n1 = g_amk.amk80 *  (g_amk.amk77)/100 * 0.05
            CALL cl_digcut(l_n1,0) RETURNING g_amk.amk84
            if not cl_null(g_amk.amk83) then
               LET g_amk.amk82 = g_amk.amk83 + g_amk.amk84
            end if
            if not cl_null(g_amk.amk79) and not cl_null(g_amk.amk81) then
               IF g_amk.amk78 != g_amk.amk79 + g_amk.amk80 + g_amk.amk81 THEN
                   CALL cl_err('','amd-035',0) 
               END IF
            end if
         ELSE
            LET g_amk.amk84 = 0
            IF NOT cl_null(g_amk.amk83) THEN
               LET g_amk.amk82 = g_amk.amk83
            ELSE
               LET g_amk.amk82 = 0
            END IF
         END if
         DISPLAY BY NAME g_amk.amk78,g_amk.amk82,g_amk.amk84

      AFTER FIELD amk81
         if not cl_null(g_amk.amk79) and not cl_null(g_amk.amk80) and not cl_null(g_amk.amk81) then
             IF g_amk.amk78 != g_amk.amk79 + g_amk.amk80 + g_amk.amk81 THEN
                 CALL cl_err('','amd-035',0) 
             END IF
         end if
         DISPLAY BY NAME g_amk.amk78,g_amk.amk83,g_amk.amk84
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about          
         CALL cl_about()       
 
      ON ACTION help           
         CALL cl_show_help()   

      AFTER INPUT
         IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_amk.amk79 = g_amk_t.amk79
            LET g_amk.amk80 = g_amk_t.amk80
            LET g_amk.amk81 = g_amk_t.amk81
            RETURN
         END IF

         IF g_amk.amk78 != g_amk.amk79 + g_amk.amk80 + g_amk.amk81 THEN
             CALL cl_err('','amd-035',0) 
             NEXT FIELD amk79
         END IF
   END INPUT
END FUNCTION
FUNCTION t002_u()
   IF s_shut(0) THEN RETURN END IF
   IF g_amk.amk01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
   END IF
   SELECT amk01,amk02,amk03,amk77,amk78
         ,amk79,amk80,amk81,amk82,amk83
         ,amk84
     INTO g_amk.* FROM amk_file WHERE amk01=g_amk.amk01
                                  AND amk02=g_amk.amk02
                                  AND amk03=g_amk.amk03
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_amk_t.* = g_amk.*
    BEGIN WORK
 
    OPEN t002_cl USING g_amk.amk01,g_amk.amk02,g_amk.amk03
    IF STATUS THEN
       CALL cl_err("OPEN t002_cl:", STATUS, 1)
       CLOSE t002_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t002_cl INTO g_amk.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_amk.amk01,SQLCA.sqlcode,0)
        RETURN
    END IF

    CALL t002_show()                          # 顯示最新資料
    WHILE TRUE
        CALL t002_i("u")                      # 欄位更改
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           LET g_amk.*=g_amk_t.*
           CALL t002_show()
           CALL cl_err('',9001,0)
           EXIT WHILE
        END IF
        UPDATE amk_file SET amk78 = g_amk.amk78,amk79 = g_amk.amk79    # 更新DB
                           ,amk80 = g_amk.amk80,amk81 = g_amk.amk81
                           ,amk82 = g_amk.amk82,amk83 = g_amk.amk83
                           ,amk84 = g_amk.amk84
         WHERE amk01=g_amk.amk01 AND amk02=g_amk.amk02 AND amk03=g_amk.amk03
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","amk_file",g_amk_t.amk01,g_amk_t.amk02,SQLCA.sqlcode,"","",1)
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t002_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t002_cs()
    CLEAR FORM
    INITIALIZE g_amk.* TO NULL
    IF cl_null(g_argv1) THEN
       CONSTRUCT BY NAME g_wc ON amk01,amk02,amk03
          BEFORE CONSTRUCT
             CALL cl_qbe_init()
             ON ACTION controlp                        # 查詢其他主檔資料
          CASE
             WHEN INFIELD(amk01)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form = "q_gem"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO amk01
                NEXT FIELD amk01
             END CASE
   
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
    
          ON ACTION about         #MOD-4C0121
             CALL cl_about()      #MOD-4C0121
    
          ON ACTION help          #MOD-4C0121
             CALL cl_show_help()  #MOD-4C0121
    
          ON ACTION controlg      #MOD-4C0121
             CALL cl_cmdask()     #MOD-4C0121
   
          ON ACTION qbe_select
             CALL cl_qbe_select()
   
          ON ACTION qbe_save
             CALL cl_qbe_save()
   
       END CONSTRUCT
       IF INT_FLAG THEN RETURN END IF
    ELSE
       LET g_wc = " amk01 = '",g_argv1 CLIPPED,"'"
    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('amkuser', 'amkgrup')
 
    LET g_sql="SELECT amk01,amk02,amk03,amk77,amk78,amk79,amk80,amk81,amk82,amk83"
                   ,",amk84"
              ," FROM amk_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY amk01"
    PREPARE t002_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE t002cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t002_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM amk_file WHERE ",g_wc CLIPPED
    PREPARE t002_precount FROM g_sql
    DECLARE t002_count CURSOR FOR t002_precount
END FUNCTION
 
FUNCTION t002_menu()
    MENU ""
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL t002_q()
            END IF
        ON ACTION next
            CALL t002_fetch('N')
        ON ACTION previous
            CALL t002_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL t002_u()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
        ON ACTION jump
           CALL t002_fetch('/')
        ON ACTION first
           CALL t002_fetch('F')
        ON ACTION last
           CALL t002_fetch('L')

        ON IDLE g_idle_seconds
           CALL cl_on_idle()

        ON ACTION about
           CALL cl_about()
 
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121
 
        ON ACTION close
            LET INT_FLAG=FALSE
            LET g_action_choice = "exit"
            EXIT MENU

    END MENU
    CLOSE t002cs
END FUNCTION

FUNCTION t002_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_amk.* TO NULL
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t002_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN t002_count
    FETCH t002_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t002cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_amk.amk01,SQLCA.sqlcode,0)
        INITIALIZE g_amk.* TO NULL
    ELSE
    CALL t002_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
 
FUNCTION t002_fetch(p_flamk)
   DEFINE
      p_flamk         LIKE type_file.chr1,
      l_abso          LIKE type_file.num10

   CASE p_flamk
       WHEN 'N' FETCH NEXT     t002cs INTO g_amk.amk01,g_amk.amk02,g_amk.amk03
       WHEN 'P' FETCH PREVIOUS t002cs INTO g_amk.amk01,g_amk.amk02,g_amk.amk03
       WHEN 'F' FETCH FIRST    t002cs INTO g_amk.amk01,g_amk.amk02,g_amk.amk03
       WHEN 'L' FETCH LAST     t002cs INTO g_amk.amk01,g_amk.amk02,g_amk.amk03
       WHEN '/'
          IF (NOT mi_no_ask) THEN
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
             LET INT_FLAG = 0
             PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()

                ON ACTION about         #MOD-4C0121
                  CALL cl_about()      #MOD-4C0121

                ON ACTION help          #MOD-4C0121
                   CALL cl_show_help()  #MOD-4C0121
 
                ON ACTION controlg      #MOD-4C0121
                   CALL cl_cmdask()     #MOD-4C0121

             END PROMPT
             IF INT_FLAG THEN
                LET INT_FLAG = 0
                EXIT CASE
             END IF
          END IF
       FETCH ABSOLUTE g_jump t002cs INTO g_amk.amk01,g_amk.amk02,g_amk.amk03
       LET mi_no_ask = FALSE
   END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_amk.amk01,SQLCA.sqlcode,0)
        INITIALIZE g_amk.* TO NULL  #TQC-6B0105
        LET g_amk.amk01 = NULL      #TQC-6B0105
        RETURN
    ELSE
       CASE p_flamk
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT amk01,amk02,amk03,amk77,amk78,amk79,amk80,amk81,amk82,amk83
          ,amk84
      INTO g_amk.* FROM amk_file            # 重讀DB,因TEMP有不被更新特性
     WHERE amk01=g_amk.amk01 AND amk02=g_amk.amk02 AND amk03=g_amk.amk03
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","amk_file",g_amk.amk01,g_amk.amk02,SQLCA.sqlcode,"","",1)
    ELSE
       CALL t002_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t002_show()
    LET g_amk_t.* = g_amk.*
    DISPLAY BY NAME g_amk.amk01,g_amk.amk02,g_amk.amk03,g_amk.amk77,g_amk.amk78
                   ,g_amk.amk79,g_amk.amk80,g_amk.amk81,g_amk.amk82,g_amk.amk83
                   ,g_amk.amk84
 
    CALL cl_show_fld_cont()
END FUNCTION
 
