# Prog. Version..: '5.20.01-10.05.01(00000)'     #
#
# Pattern name...: ghri096
# Descriptions...: 预算分摊权数管理
# Date & Author..: by wangxh 130806


DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_hrdz       RECORD LIKE hrdz_file.*,
       g_hrdz_t     RECORD LIKE hrdz_file.*,
       g_hrdz00_t   LIKE hrdz_file.hrdz00
       
DEFINE g_fqs       RECORD
       fqs1 LIKE hrdz_file.hrdz01,
       fqs2 LIKE hrdz_file.hrdz01,
       fqs3 LIKE hrdz_file.hrdz01,
       fqs4 LIKE hrdz_file.hrdz01
                   END RECORD
DEFINE  g_hrdz_b  DYNAMIC ARRAY OF RECORD
          hrdz00_b    LIKE   hrdz_file.hrdz00,
          hrdz01_b    LIKE   hrdz_file.hrdz01,
          hrdz02_b    LIKE   hrdz_file.hrdz02,
          hrdz03_b    LIKE   hrdz_file.hrdz03,
          fqs1_b      LIKE   hrdz_file.hrdz01,
          hrdz04_b    LIKE   hrdz_file.hrdz04,
          hrdz05_b    LIKE   hrdz_file.hrdz05,
          hrdz06_b    LIKE   hrdz_file.hrdz06,
          fqs2_b      LIKE   hrdz_file.hrdz01,
          hrdz07_b    LIKE   hrdz_file.hrdz07,
          hrdz08_b    LIKE   hrdz_file.hrdz08,
          hrdz09_b    LIKE   hrdz_file.hrdz09,
          fqs3_b      LIKE   hrdz_file.hrdz01,
          hrdz10_b    LIKE   hrdz_file.hrdz10,
          hrdz11_b    LIKE   hrdz_file.hrdz11,
          hrdz12_b    LIKE   hrdz_file.hrdz12,
          fqs4_b      LIKE   hrdz_file.hrdz01
                  END RECORD

DEFINE g_forupd_sql          STRING         #SELECT ... FOR UPDATE  SQL        #No.FUN-680962
DEFINE g_before_input_done   LIKE type_file.num5          #判斷是否已執行 Before Input指令        #No.FUN-680962 SMALLINT
DEFINE g_chr                 LIKE hrdz_file.hrdzacti        #No.FUN-680962 VARCHAR(1)
DEFINE g_cnt                 LIKE type_file.num10         #No.FUN-680962 INTEGER
DEFINE g_i                   LIKE type_file.num5          #count/index for any purpose        #No.FUN-680962 SMALLINT
DEFINE g_msg                 LIKE type_file.chr1000       #No.FUN-680962 VARCHAR(72)
DEFINE g_curs_index          LIKE type_file.num10         #No.FUN-680962 INTEGER
DEFINE g_row_count           LIKE type_file.num10         #總筆數        #No.FUN-680962 INTEGER
DEFINE g_jump                LIKE type_file.num10         #查詢指定的筆數        #No.FUN-680962 INTEGER
DEFINE g_flag                LIKE type_file.chr1
DEFINE  g_rec_b,l_ac         LIKE type_file.num5
DEFINE  g_hrdz00             LIKE hrdz_file.hrdz00
DEFINE  g_wc   STRING
DEFINE  g_sql  STRING  
DEFINE g_no_ask     LIKE type_file.num5      
DEFINE g_str        STRING 
DEFINE g_bp_flag           LIKE type_file.chr10
DEFINE l_name       STRING

MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT                            #擷取中斷鍵

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF

   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
   INITIALIZE g_hrdz.* TO NULL

   LET g_forupd_sql = "SELECT * FROM hrdz_file WHERE hrdz00 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i096_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR


   OPEN WINDOW i096_w WITH FORM "ghr/42f/ghri096"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()
   
   CALL cl_set_combo_items("hrdz00",NULL,NULL)
   CALL i096_get_items() RETURNING l_name
   CALL cl_set_combo_items("hrdz00",l_name,l_name)


   LET g_action_choice = ""
   CALL i096_menu()

   CLOSE WINDOW i096_w

   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
END MAIN

FUNCTION i096_get_items()
DEFINE p_name   STRING
DEFINE p_hrac01 LIKE hrac_file.hrac01
DEFINE l_sql    STRING

       LET p_name=''
       
       LET l_sql=" SELECT DISTINCT hrac01 FROM hrac_file ",
                 "  WHERE hrac01 NOT IN( SELECT hrct04 FROM hrct_file WHERE hrct06='Y')",
                 "  ORDER BY hrac01 "
       PREPARE i099_get_items_pre FROM l_sql
       DECLARE i099_get_items CURSOR FOR i099_get_items_pre
       FOREACH i099_get_items INTO p_hrac01
          IF cl_null(p_name) THEN
            LET p_name=p_hrac01
          ELSE
            LET p_name=p_name CLIPPED,",",p_hrac01 CLIPPED
          END IF
       END FOREACH
       
       RETURN p_name
END FUNCTION

FUNCTION i096_cs()

    CLEAR FORM
    INITIALIZE g_hrdz.* TO NULL      
    CONSTRUCT BY NAME g_wc ON                
        hrdz00,hrdz01,hrdz02,hrdz03,fqs1,hrdz04,hrdz05,hrdz06,fqs2,hrdz07,hrdz08,hrdz09,
        fqs3,hrdz10,hrdz11,hrdz12,fqs4,hrdzuser,hrdzgrup,hrdzoriu,hrdzmodu,hrdzdate,hrdzorig,hrdzacti
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
            
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
      
      ON ACTION about    
         CALL cl_about()  
      
      ON ACTION help       
         CALL cl_show_help()
      
      ON ACTION controlg    
         CALL cl_cmdask()    

                 ON ACTION qbe_select
                   CALL cl_qbe_select()
                 ON ACTION qbe_save
                   CALL cl_qbe_save()
    END CONSTRUCT

    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hrdzuser', 'hrdzgrup')
    #End:FUN-980030
    LET g_sql="SELECT hrdz00 FROM hrdz_file ", 
        " WHERE ",g_wc CLIPPED, " ORDER BY hrdz01"
    PREPARE i096_prepare FROM g_sql
    DECLARE i096_cs                                # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i096_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM hrdz_file WHERE ",g_wc CLIPPED
    PREPARE i096_precount FROM g_sql
    DECLARE i096_count CURSOR FOR i096_precount
END FUNCTION

FUNCTION i096_menu()
   DEFINE l_cmd  LIKE type_file.chr1000
    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
           
          ON ACTION item_list
           LET g_action_choice = ""  #MOD-8A0193 add
           CALL i096_b_menu()   #MOD-8A0193
           LET g_action_choice = ""  #MOD-8A0193 add   

        
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i096_a()
            END If        
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i096_q()
            END IF
        ON ACTION next
            CALL i096_fetch('N')

        ON ACTION previous
            CALL i096_fetch('P')

       ON ACTION modify
          LET g_action_choice="modify"
           IF cl_chk_act_auth() THEN
                CALL i096_u()
           END IF

       ON ACTION invalid
           LET g_action_choice="invalid"
           IF cl_chk_act_auth() THEN
                CALL i096_x()
           END IF

       ON ACTION delete
           LET g_action_choice="delete"
           IF cl_chk_act_auth() THEN
                CALL i096_r()
           END IF

#      ON ACTION reproduce
#           LET g_action_choice="reproduce"
#           IF cl_chk_act_auth() THEN
#                CALL i096_copy()
#           END IF

        ON ACTION help
            CALL cl_show_help()

        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU

        ON ACTION jump
            CALL i096_fetch('/')

        ON ACTION first
            CALL i096_fetch('F')

        ON ACTION last
            CALL i096_fetch('L')

        ON ACTION controlg
            CALL cl_cmdask()

        ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE MENU

      ON ACTION about
         CALL cl_about()

        ON ACTION close
             LET INT_FLAG=FALSE
           LET g_action_choice = "exit"
           EXIT MENU

         ON ACTION related_document
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
              IF g_hrdz.hrdz01 IS NOT NULL THEN
                 LET g_doc.column1 = "hrdz00"
                 LET g_doc.value1 = g_hrdz.hrdz00
                 CALL cl_doc()
              END IF
           END IF

    END MENU
    CLOSE i096_cs
END FUNCTION

FUNCTION i096_q()

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_hrdz.* TO NULL            #No.FUN-6A0015
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY ' ' TO FORMONLY.cnt
    CALL i096_cs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i096_count
    FETCH i096_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i096_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrdz.hrdz01,SQLCA.sqlcode,0)
        INITIALIZE g_hrdz.* TO NULL
    ELSE
        CALL i096_fetch('F')              # 讀出TEMP第一筆並顯示
        CALL i096_b_fill(g_wc)
    END IF
END FUNCTION

FUNCTION i096_fetch(p_flag)
DEFINE p_flag     LIKE type_file.chr1

    CASE p_flag
        WHEN 'N' FETCH NEXT     i096_cs INTO g_hrdz.hrdz00
        WHEN 'P' FETCH PREVIOUS i096_cs INTO g_hrdz.hrdz00
        WHEN 'F' FETCH FIRST    i096_cs INTO g_hrdz.hrdz00
        WHEN 'L' FETCH LAST     i096_cs INTO g_hrdz.hrdz00
        WHEN '/'
            IF (NOT g_no_ask) THEN                   #No.FUN-6A0066
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
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
            FETCH ABSOLUTE g_jump i096_cs INTO g_hrdz.hrdz00
            LET g_no_ask = FALSE         #No.FUN-6A0066
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrdz.hrdz00,SQLCA.sqlcode,0)
        INITIALIZE g_hrdz.* TO NULL  #TQC-6B0965
        LET g_hrdz.hrdz00 = NULL      #TQC-6B0965
        RETURN
    ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE

      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx                 #No.FUN-4A0089
    END IF

    SELECT * INTO g_hrdz.* FROM hrdz_file    # 重讀DB,因TEMP有不被更新特性
       WHERE hrdz00 = g_hrdz.hrdz00
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","hrdz_file",g_hrdz.hrdz00,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
    ELSE
        LET g_data_owner=g_hrdz.hrdzuser           #FUN-4C0044權限控管
        LET g_data_group=g_hrdz.hrdzgrup
        CALL i096_show()                   # 重新顯示
    END IF
END FUNCTION

FUNCTION i096_show()
    
   LET g_fqs.fqs1=g_hrdz.hrdz01+g_hrdz.hrdz02+g_hrdz.hrdz03
   LET g_fqs.fqs2=g_hrdz.hrdz04+g_hrdz.hrdz05+g_hrdz.hrdz06
   LET g_fqs.fqs3=g_hrdz.hrdz07+g_hrdz.hrdz08+g_hrdz.hrdz09
   LET g_fqs.fqs4=g_hrdz.hrdz10+g_hrdz.hrdz11+g_hrdz.hrdz12
    LET g_hrdz_t.* = g_hrdz.*
    DISPLAY BY NAME g_hrdz.hrdz00,g_hrdz.hrdz01,g_hrdz.hrdz02,g_hrdz.hrdz03,g_hrdz.hrdz04,g_hrdz.hrdz05,g_hrdz.hrdz06,
                    g_hrdz.hrdz07,g_hrdz.hrdz08,g_hrdz.hrdz09,g_hrdz.hrdz10,g_hrdz.hrdz11,g_hrdz.hrdz12,
                    g_hrdz.hrdzuser ,g_hrdz.hrdzgrup,g_hrdz.hrdzoriu,g_hrdz.hrdzorig,g_hrdz.hrdzmodu,
                    g_hrdz.hrdzdate,g_hrdz.hrdzacti,g_fqs.fqs1,g_fqs.fqs2,g_fqs.fqs3,g_fqs.fqs4 
    CALL cl_show_fld_cont()
END FUNCTION

FUNCTION i096_a()

    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_hrdz.* LIKE hrdz_file.*
    INITIALIZE g_fqs.* TO NULL
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_hrdz.hrdzuser = g_user
        LET g_hrdz.hrdzoriu = g_user #FUN-980030
        LET g_hrdz.hrdzorig = g_grup #FUN-980030
        LET g_hrdz.hrdzgrup = g_grup               #使用者所屬群      
        LET g_hrdz.hrdzacti = 'Y'
        #add by shenran start
        LET g_hrdz.hrdz01 = '0'
        LET g_hrdz.hrdz02 = '0'
        LET g_hrdz.hrdz03 = '0'
        LET g_hrdz.hrdz04 = '0'
        LET g_hrdz.hrdz05 = '0'
        LET g_hrdz.hrdz06 = '0'
        LET g_hrdz.hrdz07 = '0'
        LET g_hrdz.hrdz08 = '0'
        LET g_hrdz.hrdz09 = '0'
        LET g_hrdz.hrdz10 = '0'
        LET g_hrdz.hrdz11 = '0'
        LET g_hrdz.hrdz12 = '0' 
        #add by shenran start
        CALL i096_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_hrdz.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_hrdz.hrdz00 IS NULL THEN              # KEY 不可空白
            CONTINUE WHILE
        END IF 
        INSERT INTO hrdz_file VALUES(g_hrdz.*)
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","hrdz_file",g_hrdz.hrdz01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660131
            CONTINUE WHILE
        ELSE
            SELECT hrdz00 INTO g_hrdz.hrdz00 FROM hrdz_file
                     WHERE hrdz00 = g_hrdz.hrdz00
            CALL i096_b_fill(g_wc)         
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION

FUNCTION i096_i(p_cmd)
DEFINE p_cmd  LIKE type_file.chr1
DEFINE l_n    LIKE type_file.num5
DEFINE l_sum1 LIKE hrdz_file.hrdz01 

   DISPLAY BY NAME  g_hrdz.hrdz00,g_hrdz.hrdz01,g_hrdz.hrdz02,g_hrdz.hrdz03,g_hrdz.hrdz04,g_hrdz.hrdz05,g_hrdz.hrdz06,
                    g_hrdz.hrdz07,g_hrdz.hrdz08,g_hrdz.hrdz09,g_hrdz.hrdz10,g_hrdz.hrdz11,g_hrdz.hrdz12,
                    g_hrdz.hrdzuser ,g_hrdz.hrdzgrup,g_hrdz.hrdzoriu,g_hrdz.hrdzorig,g_hrdz.hrdzmodu,
                    g_hrdz.hrdzdate,g_hrdz.hrdzacti,g_fqs.fqs1,g_fqs.fqs2,g_fqs.fqs3,g_fqs.fqs4

  INPUT BY NAME
     g_hrdz.hrdz00,g_hrdz.hrdz01,g_hrdz.hrdz02,g_hrdz.hrdz03,g_fqs.fqs1,g_hrdz.hrdz04,g_hrdz.hrdz05,g_hrdz.hrdz06,
     g_fqs.fqs2,g_hrdz.hrdz07,g_hrdz.hrdz08,g_hrdz.hrdz09,g_fqs.fqs3,g_hrdz.hrdz10,g_hrdz.hrdz11,g_hrdz.hrdz12,
     g_fqs.fqs4,g_hrdz.hrdzuser,g_hrdz.hrdzgrup,g_hrdz.hrdzoriu,g_hrdz.hrdzorig,g_hrdz.hrdzmodu,
     g_hrdz.hrdzdate,g_hrdz.hrdzacti
      WITHOUT DEFAULTS

      BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL i096_set_entry(p_cmd)
          CALL i096_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE

      AFTER FIELD hrdz00
           IF g_hrdz.hrdz00 IS NOT NULL THEN
            IF p_cmd = "a" OR (p_cmd = "u" AND g_hrdz.hrdz00 != g_hrdz00_t) THEN # 若輸入或更改且改KEY
               SELECT count(*) INTO l_n FROM hrdz_file WHERE hrdz00 = g_hrdz.hrdz00
               IF l_n > 0 THEN                  # Duplicated
                  CALL cl_err(g_hrdz.hrdz00,-239,1)
                  LET g_hrdz.hrdz00 = g_hrdz00_t
                  DISPLAY BY NAME g_hrdz.hrdz00
                  NEXT FIELD hrdz00
               END IF            
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('hrdz00:',g_errno,1)
                  LET g_hrdz.hrdz00 = g_hrdz00_t
                  DISPLAY BY NAME g_hrdz.hrdz00
                  NEXT FIELD hrdz00
               END IF
            END IF
         END IF
         IF cl_null(g_hrdz.hrdz00) THEN 
             NEXT FIELD hrdz00
             END IF
      
      AFTER FIELD hrdz01
           CALL i096_check(g_hrdz.hrdz01)
           IF g_flag='N' THEN
           NEXT FIELD hrdz01
           END IF
            IF NOT cl_null(g_hrdz.hrdz01) AND NOT cl_null(g_hrdz.hrdz02) AND NOT cl_null(g_hrdz.hrdz03)
             THEN
               LET g_fqs.fqs1=g_hrdz.hrdz01+g_hrdz.hrdz02+g_hrdz.hrdz03
            END IF
            DISPLAY g_fqs.fqs1 TO fqs1
      AFTER FIELD hrdz02
           CALL i096_check(g_hrdz.hrdz02)
           IF g_flag='N' THEN
           NEXT FIELD hrdz02
           END IF
             IF NOT cl_null(g_hrdz.hrdz01) AND NOT cl_null(g_hrdz.hrdz02) AND NOT cl_null(g_hrdz.hrdz03)
             THEN
               LET g_fqs.fqs1=g_hrdz.hrdz01+g_hrdz.hrdz02+g_hrdz.hrdz03
            END IF
            DISPLAY g_fqs.fqs1 TO fqs1
      AFTER FIELD hrdz03
           CALL i096_check(g_hrdz.hrdz03)
           IF g_flag='N' THEN
           NEXT FIELD hrdz03
           END IF
           IF NOT cl_null(g_hrdz.hrdz01) AND NOT cl_null(g_hrdz.hrdz02) AND NOT cl_null(g_hrdz.hrdz03)
             THEN
               LET g_fqs.fqs1=g_hrdz.hrdz01+g_hrdz.hrdz02+g_hrdz.hrdz03
            END IF
            DISPLAY g_fqs.fqs1 TO fqs1
      AFTER FIELD fqs1
           IF NOT cl_null(g_hrdz.hrdz01) AND NOT cl_null(g_hrdz.hrdz02) AND NOT cl_null(g_hrdz.hrdz03)
             THEN
               LET g_fqs.fqs1=g_hrdz.hrdz01+g_hrdz.hrdz02+g_hrdz.hrdz03
            END IF
            DISPLAY g_fqs.fqs1 TO fqs1
           
      AFTER FIELD hrdz04
          CALL i096_check(g_hrdz.hrdz04)
          IF g_flag='N' THEN
          NEXT FIELD hrdz04
          END IF
          IF NOT cl_null(g_hrdz.hrdz04) AND NOT cl_null(g_hrdz.hrdz05) AND NOT cl_null(g_hrdz.hrdz06)
             THEN
               LET g_fqs.fqs2=g_hrdz.hrdz04+g_hrdz.hrdz05+g_hrdz.hrdz06
          END IF
          DISPLAY g_fqs.fqs2 TO fqs2
      AFTER FIELD hrdz05
           CALL i096_check(g_hrdz.hrdz05)
           IF g_flag='N' THEN
            NEXT FIELD hrdz05
           END IF
           IF NOT cl_null(g_hrdz.hrdz04) AND NOT cl_null(g_hrdz.hrdz05) AND NOT cl_null(g_hrdz.hrdz06)
             THEN
               LET g_fqs.fqs2=g_hrdz.hrdz04+g_hrdz.hrdz05+g_hrdz.hrdz06
           END IF
           DISPLAY g_fqs.fqs2 TO fqs2
      AFTER FIELD hrdz06
           CALL i096_check(g_hrdz.hrdz06)
          IF g_flag='N' THEN
           NEXT FIELD hrdz06
          END IF
          IF NOT cl_null(g_hrdz.hrdz04) AND NOT cl_null(g_hrdz.hrdz05) AND NOT cl_null(g_hrdz.hrdz06)
             THEN
               LET g_fqs.fqs2=g_hrdz.hrdz04+g_hrdz.hrdz05+g_hrdz.hrdz06
            END IF
            DISPLAY g_fqs.fqs2 TO fqs2
      AFTER FIELD fqs2
           IF NOT cl_null(g_hrdz.hrdz04) AND NOT cl_null(g_hrdz.hrdz05) AND NOT cl_null(g_hrdz.hrdz06)
             THEN
               LET g_fqs.fqs2=g_hrdz.hrdz04+g_hrdz.hrdz05+g_hrdz.hrdz06
            END IF
            DISPLAY g_fqs.fqs2 TO fqs2
           
      AFTER FIELD hrdz07
           CALL i096_check(g_hrdz.hrdz07)
           IF g_flag='N' THEN
           NEXT FIELD hrdz07
           END IF
           IF NOT cl_null(g_hrdz.hrdz07) AND NOT cl_null(g_hrdz.hrdz08) AND NOT cl_null(g_hrdz.hrdz09)
             THEN
               LET g_fqs.fqs3=g_hrdz.hrdz07+g_hrdz.hrdz08+g_hrdz.hrdz09
           END IF
           DISPLAY g_fqs.fqs3 TO fqs3
      AFTER FIELD hrdz08
           CALL i096_check(g_hrdz.hrdz08)
           IF g_flag='N' THEN
           NEXT FIELD hrdz08
           END IF
           IF NOT cl_null(g_hrdz.hrdz07) AND NOT cl_null(g_hrdz.hrdz08) AND NOT cl_null(g_hrdz.hrdz09)
             THEN
               LET g_fqs.fqs3=g_hrdz.hrdz07+g_hrdz.hrdz08+g_hrdz.hrdz09
            END IF
            DISPLAY g_fqs.fqs3 TO fqs3
      AFTER FIELD hrdz09
           CALL i096_check(g_hrdz.hrdz09)
           IF g_flag='N' THEN
           NEXT FIELD hrdz09
          END IF
          IF NOT cl_null(g_hrdz.hrdz07) AND NOT cl_null(g_hrdz.hrdz08) AND NOT cl_null(g_hrdz.hrdz09)
             THEN
               LET g_fqs.fqs3=g_hrdz.hrdz07+g_hrdz.hrdz08+g_hrdz.hrdz09
            END IF
            DISPLAY g_fqs.fqs3 TO fqs3
      AFTER FIELD fqs3
         IF NOT cl_null(g_hrdz.hrdz07) AND NOT cl_null(g_hrdz.hrdz08) AND NOT cl_null(g_hrdz.hrdz09)
             THEN
               LET g_fqs.fqs3=g_hrdz.hrdz07+g_hrdz.hrdz08+g_hrdz.hrdz09
            END IF
            DISPLAY g_fqs.fqs3 TO fqs3
        
      AFTER FIELD hrdz10
           CALL i096_check(g_hrdz.hrdz10)
           IF g_flag='N' THEN
           NEXT FIELD hrdz10
           END IF
             IF NOT cl_null(g_hrdz.hrdz10) AND NOT cl_null(g_hrdz.hrdz11) AND NOT cl_null(g_hrdz.hrdz12)
             THEN
               LET g_fqs.fqs4=g_hrdz.hrdz10+g_hrdz.hrdz11+g_hrdz.hrdz12
            END IF
            DISPLAY g_fqs.fqs4 TO fqs4
      AFTER FIELD hrdz11
            CALL i096_check(g_hrdz.hrdz11)
           IF g_flag='N' THEN
           NEXT FIELD hrdz11
           END IF
             IF NOT cl_null(g_hrdz.hrdz10) AND NOT cl_null(g_hrdz.hrdz11) AND NOT cl_null(g_hrdz.hrdz12)
             THEN
               LET g_fqs.fqs4=g_hrdz.hrdz10+g_hrdz.hrdz11+g_hrdz.hrdz12
            END IF
            DISPLAY g_fqs.fqs4 TO fqs4
      AFTER FIELD hrdz12
           CALL i096_check(g_hrdz.hrdz12)
           IF g_flag='N' THEN
           NEXT FIELD hrdz12
           END IF
           IF NOT cl_null(g_hrdz.hrdz10) AND NOT cl_null(g_hrdz.hrdz11) AND NOT cl_null(g_hrdz.hrdz12)
             THEN
               LET g_fqs.fqs4=g_hrdz.hrdz10+g_hrdz.hrdz11+g_hrdz.hrdz12
            END IF
            DISPLAY g_fqs.fqs4 TO fqs4
      AFTER FIELD fqs4
           IF NOT cl_null(g_hrdz.hrdz10) AND NOT cl_null(g_hrdz.hrdz11) AND NOT cl_null(g_hrdz.hrdz12)
             THEN
               LET g_fqs.fqs4=g_hrdz.hrdz10+g_hrdz.hrdz11+g_hrdz.hrdz12
            END IF
            DISPLAY g_fqs.fqs4 TO fqs4
               

      AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            LET l_sum1=g_hrdz.hrdz01+g_hrdz.hrdz02+g_hrdz.hrdz03+g_hrdz.hrdz04+g_hrdz.hrdz05+g_hrdz.hrdz06+
                      g_hrdz.hrdz07+g_hrdz.hrdz08+g_hrdz.hrdz09+g_hrdz.hrdz10+g_hrdz.hrdz11+g_hrdz.hrdz12
            IF l_sum1<>100
             THEN
              CALL cl_err('','ghr-908',0) 
              NEXT FIELD hrdz01
            END IF
            IF g_flag='N' THEN
              NEXT FIELD hrdz01
             END IF
            
    

   ON ACTION CONTROLZ
      CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913

      
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
            
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
            
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
        
            
   END INPUT
       

END FUNCTION

FUNCTION i096_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1 
 
   IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("hrdz00",TRUE)
   END IF
END FUNCTION

FUNCTION i096_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1
 
   IF p_cmd = 'u' AND g_chkey = 'N' THEN
      CALL cl_set_comp_entry("hrdz00",FALSE)
   END IF
END FUNCTION

FUNCTION i096_r()
    IF g_hrdz.hrdz00 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i096_cl USING g_hrdz.hrdz00
    IF STATUS THEN
       CALL cl_err("OPEN i096_cl:", STATUS, 0)
       CLOSE i096_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i096_cl INTO g_hrdz.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrdz.hrdz00,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i096_show()
    IF cl_delete() THEN
       LET g_doc.column1 = "hrdz00"   
       LET g_doc.value1 = g_hrdz.hrdz00 

       CALL cl_del_doc()
       DELETE FROM hrdz_file WHERE hrdz00 = g_hrdz.hrdz00

       CLEAR FORM
       OPEN i096_count
       #FUN-B50065-add-start--
       IF STATUS THEN
          CLOSE i096_cl
          CLOSE i096_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50065-add-end--
       FETCH i096_count INTO g_row_count
       #FUN-B50065-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i096_cl
          CLOSE i096_count
          COMMIT WORK
          CALL i096_b_fill(g_wc)
          RETURN
       END IF
       #FUN-B50065-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt

       OPEN i096_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i096_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE                 #No.FUN-6A0066
          CALL i096_fetch('/')
       END IF
    END IF
    CLOSE i096_cl
    COMMIT WORK
    CALL i096_b_fill(g_wc)
END FUNCTION

FUNCTION i096_u()
    IF g_hrdz.hrdz00 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_hrdz.* FROM hrdz_file WHERE hrdz=g_hrdz.hrdz00
   
    CALL cl_opmsg('u')
    LET g_hrdz00_t = g_hrdz.hrdz00
    BEGIN WORK
 
    OPEN i096_cl USING g_hrdz.hrdz00
    IF STATUS THEN
       CALL cl_err("OPEN i096_cl:", STATUS, 1)
       CLOSE i096_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i096_cl INTO g_hrdz.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrdz.hrdz00,SQLCA.sqlcode,1)
        RETURN
    END IF
    LET g_hrdz.hrdzmodu=g_user                  #修改者
    LET g_hrdz.hrdzdate = g_today               #修改日期
    CALL i096_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i096_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_hrdz.*=g_hrdz_t.*
            CALL i096_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE hrdz_file SET hrdz_file.* = g_hrdz.*    # 更新DB
            #WHERE hrdz01 = g_hrdz.hrdz01     #MOD-BB0113 mark
            WHERE hrdz00 = g_hrdz_t.hrdz00    #MOD-BB0113 add
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","hrdz_file",g_hrdz.hrdz00,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i096_cl
    COMMIT WORK
    CALL i096_b_fill(g_wc)
END FUNCTION

FUNCTION i096_x()
    IF g_hrdz.hrdz00 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i096_cl USING g_hrdz.hrdz00
    IF STATUS THEN
       CALL cl_err("OPEN i096_cl:", STATUS, 1)
       CLOSE i096_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i096_cl INTO g_hrdz.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrdz.hrdz00,SQLCA.sqlcode,1)
       RETURN
    END IF
    CALL i096_show()
    IF cl_exp(0,0,g_hrdz.hrdzacti) THEN
        LET g_chr = g_hrdz.hrdzacti
        IF g_hrdz.hrdzacti='Y' THEN
            LET g_hrdz.hrdzacti='N'
        ELSE
            LET g_hrdz.hrdzacti='Y'
        END IF
        UPDATE hrdz_file
            SET hrdzacti=g_hrdz.hrdzacti
            WHERE hrdz00=g_hrdz.hrdz00
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(g_hrdz.hrdz00,SQLCA.sqlcode,0)
            LET g_hrdz.hrdzacti = g_chr
        END IF
        DISPLAY BY NAME g_hrdz.hrdzacti
    END IF
    CLOSE i096_cl
    COMMIT WORK
    CALL i096_b_fill(g_wc)
END FUNCTION

FUNCTION i096_check(p_qsz)
  DEFINE p_qsz    LIKE hrdz_file.hrdz01
  DEFINE l_a      LIKE hrdz_file.hrdz01
  DEFINE l_sum    LIKE hrdz_file.hrdz01
  
  IF cl_null(g_hrdz.hrdz01) THEN LET g_hrdz.hrdz01=0 END IF
  IF cl_null(g_hrdz.hrdz02) THEN LET g_hrdz.hrdz02=0 END IF
  IF cl_null(g_hrdz.hrdz03) THEN LET g_hrdz.hrdz03=0 END IF
  IF cl_null(g_hrdz.hrdz04) THEN LET g_hrdz.hrdz04=0 END IF
  IF cl_null(g_hrdz.hrdz05) THEN LET g_hrdz.hrdz05=0 END IF
  IF cl_null(g_hrdz.hrdz06) THEN LET g_hrdz.hrdz06=0 END IF

  IF cl_null(g_hrdz.hrdz07) THEN LET g_hrdz.hrdz07=0 END IF
  IF cl_null(g_hrdz.hrdz08) THEN LET g_hrdz.hrdz08=0 END IF
  IF cl_null(g_hrdz.hrdz09) THEN LET g_hrdz.hrdz09=0 END IF
  IF cl_null(g_hrdz.hrdz10) THEN LET g_hrdz.hrdz10=0 END IF
  IF cl_null(g_hrdz.hrdz11) THEN LET g_hrdz.hrdz11=0 END IF
  IF cl_null(g_hrdz.hrdz12) THEN LET g_hrdz.hrdz12=0 END IF

  LET g_flag='Y'
  LET l_sum=g_hrdz.hrdz01+g_hrdz.hrdz02+g_hrdz.hrdz03+g_hrdz.hrdz04+g_hrdz.hrdz05+g_hrdz.hrdz06+
            g_hrdz.hrdz07+g_hrdz.hrdz08+g_hrdz.hrdz09+g_hrdz.hrdz10+g_hrdz.hrdz11+g_hrdz.hrdz12
  LET l_a=100-l_sum
  
  IF cl_null(p_qsz) THEN
      LET g_flag='N'
  END IF
  
  IF p_qsz<0 OR p_qsz=0 THEN 
     CALL cl_err('','ghr-906',0)
     LET g_flag='N'
  END IF
  
  IF l_a<0  THEN 
     CALL cl_err('','ghr-907',0)
     LET g_flag='N'
  END IF
       
END FUNCTION
	
FUNCTION i096_b_fill(p_wc)
DEFINE p_wc     STRING
DEFINE l_sql    STRING
DEFINE l_i      LIKE   type_file.num5
		
        CALL g_hrdz_b.clear()
        
        LET l_sql=" SELECT hrdz00,hrdz01,hrdz02,hrdz03,'',hrdz04,hrdz05,hrdz06,'',hrdz07,hrdz08,hrdz09,'',hrdz10,hrdz11,hrdz12,''  ",
                  "   FROM hrdz_file WHERE ",p_wc CLIPPED,
                  "  ORDER BY hrdz00 "
                  
        PREPARE i096_b_pre FROM l_sql
        DECLARE i096_b_cs CURSOR FOR i096_b_pre
        
        LET l_i=1
        
        FOREACH i096_b_cs INTO g_hrdz_b[l_i].*
        
         LET  g_hrdz_b[l_i].fqs1_b=g_hrdz_b[l_i].hrdz01_b+g_hrdz_b[l_i].hrdz02_b+g_hrdz_b[l_i].hrdz03_b
         LET  g_hrdz_b[l_i].fqs2_b=g_hrdz_b[l_i].hrdz04_b+g_hrdz_b[l_i].hrdz05_b+g_hrdz_b[l_i].hrdz06_b
         LET  g_hrdz_b[l_i].fqs3_b=g_hrdz_b[l_i].hrdz07_b+g_hrdz_b[l_i].hrdz08_b+g_hrdz_b[l_i].hrdz09_b
         LET  g_hrdz_b[l_i].fqs4_b=g_hrdz_b[l_i].hrdz10_b+g_hrdz_b[l_i].hrdz11_b+g_hrdz_b[l_i].hrdz12_b
           
           LET l_i=l_i+1
           
           IF l_i > g_max_rec THEN
              IF g_action_choice ="query"  THEN   #CHI-BB0034 add
                 CALL cl_err( '', 9035, 0 )
              END IF                              #CHI-BB0034 add
              EXIT FOREACH
           END IF
        END FOREACH
        CALL g_hrdz_b.deleteElement(l_i)
        LET g_rec_b = l_i - 1
        DISPLAY ARRAY g_hrdz_b TO s_hrdz_b.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
           BEFORE DISPLAY
              EXIT DISPLAY
        END DISPLAY

END FUNCTION                  


FUNCTION i096_b_menu()
   DEFINE   l_cmd     LIKE type_file.chr1000


   WHILE TRUE

      CALL i096_bp("G")

      IF NOT cl_null(g_action_choice) AND l_ac>0 THEN #將清單的資料回傳到主畫面
         SELECT hrdz_file.*
           INTO g_hrdz.*
           FROM hrdz_file
          WHERE hrdz00=g_hrdz_b[l_ac].hrdz00_b
      END IF

      IF g_action_choice!= "" THEN
         LET g_bp_flag = 'Page1'
         LET l_ac = ARR_CURR()
         LET g_jump = l_ac
         LET g_no_ask = TRUE
         IF g_rec_b >0 THEN
             CALL i096_fetch('/')
         END IF
         CALL cl_set_comp_visible("Page3", FALSE)
         CALL cl_set_comp_visible("Page2", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("Page3", TRUE)
         CALL cl_set_comp_visible("Page2", TRUE)
       END IF

      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN    #cl_prichk('A') THEN
               CALL i096_a()
            END IF
            EXIT WHILE

        WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i096_q()
            END IF
            EXIT WHILE

        WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i096_r()
            END IF

        WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i096_u()
            END IF
            EXIT WHILE

        WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i096_x()
               CALL i096_show()
            END IF
            	
        WHEN "related_document"
            IF cl_chk_act_auth() THEN
               IF g_hrdz.hrdz00 IS NOT NULL THEN
                  LET g_doc.column1 = "hrdz00"
                  LET g_doc.value1 = g_hrdz.hrdz00
                  CALL cl_doc()
               END IF
            END IF    	 	

        WHEN "exporttoexcel"
           IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrdz_b),'','')
           END IF
        
        WHEN "help"
            CALL cl_show_help()

        WHEN "controlg"
            CALL cl_cmdask()

        WHEN "locale"
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()

        WHEN "exit"
            EXIT WHILE

        WHEN "g_idle_seconds"
            CALL cl_on_idle()

        WHEN "about"
            CALL cl_about()

        OTHERWISE
            EXIT WHILE
      END CASE
   END WHILE
END FUNCTION	 		


FUNCTION i096_bp(p_ud)
   DEFINE   p_ud      LIKE type_file.chr1          #No.FUN-680126 VARCHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrdz_b TO s_hrdz_b.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()

      ON ACTION main
         LET g_bp_flag = 'Page1'
         LET l_ac = ARR_CURR()
         LET g_jump = l_ac
         LET g_no_ask = TRUE
         IF g_rec_b >0 THEN
             CALL i096_fetch('/')
         END IF
         CALL cl_set_comp_visible("Page3", FALSE)
         CALL cl_set_comp_visible("Page2", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("Page3", TRUE)
         CALL cl_set_comp_visible("Page2", TRUE)
         EXIT DISPLAY

      ON ACTION accept
         LET l_ac = ARR_CURR()
         LET g_jump = l_ac
         LET g_no_ask = TRUE
         LET g_bp_flag = NULL
         CALL i096_fetch('/')
         CALL cl_set_comp_visible("Page2", FALSE)
         #CALL cl_set_comp_visible("Page2", TRUE)
         CALL cl_set_comp_visible("Page3", FALSE)   #NO.FUN-840018 ADD
         CALL ui.interface.refresh()                  #NO.FUN-840018 ADD
         CALL cl_set_comp_visible("Page2", TRUE)
         CALL cl_set_comp_visible("Page3", TRUE)    #NO.FUN-840018 ADD
         EXIT DISPLAY

      ON ACTION first
         CALL i096_fetch('F')
         CONTINUE DISPLAY

      ON ACTION previous
         CALL i096_fetch('P')
         CONTINUE DISPLAY

      ON ACTION jump
         CALL i096_fetch('/')
         CONTINUE DISPLAY

      ON ACTION next
         CALL i096_fetch('N')
         CONTINUE DISPLAY

      ON ACTION last
         CALL i096_fetch('L')
         CONTINUE DISPLAY

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION exit
         LET g_action_choice="exit"  #MOD-8A0193 add
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

      ON ACTION cancel
         LET INT_FLAG=FALSE          #MOD-8A0193
         LET g_action_choice="exit"  #MOD-8A0193 add
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about         #MOD-4C0121
         LET g_action_choice="about"  #MOD-8A0193 add
         EXIT DISPLAY                 #MOD-8A0193 add

      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY

      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY

      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY

      #No.FUN-9C0089 add begin----------------
      ON ACTION exporttoexcel
         LET g_action_choice="exporttoexcel"
         EXIT DISPLAY
      #No.FUN-9C0089 add -end-----------------
      
      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY 
   
      AFTER DISPLAY
         CONTINUE DISPLAY

      &include "qry_string.4gl"

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
        
        			 


