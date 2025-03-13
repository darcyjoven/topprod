# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: almi240.4gl
# Descriptions...: 出租狀態顏色設定作業
# Date & Author..: NO.FUN-960058 09/06/12 By  destiny 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0136 09/11/25 By destiny construct新增字段
# Modify.........: No.TQC-B20116 11/02/21 By lilingyu "資料建立者、資料建立部門"的值未能顯示出來
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-960058--begin 
DEFINE g_lmq       RECORD LIKE lmq_file.*,
       g_lmq_t     RECORD LIKE lmq_file.*,  #掘爺導硉
       g_lmq01_t   LIKE lmq_file.lmq01,  #Key硉掘爺
       g_lmq02_t   LIKE lmq_file.lmq02,  #Key硉掘爺
       g_wc           STRING,                     #揣湔 user 腔脤戙沭璃
       g_sql          STRING                     #郪 sql 蚚
       
DEFINE g_forupd_sql         STRING         #SELECT ... FOR UPDATE  SQL
DEFINE g_before_input_done  SMALLINT       #瓚剿岆瘁眒硒俴 Before Input硌鍔
DEFINE g_chr                VARCHAR(1)
DEFINE g_cnt                INTEGER
DEFINE g_i                  SMALLINT       #count/index for any purpose
DEFINE g_msg                VARCHAR(72)
DEFINE g_curs_index         INTEGER
DEFINE g_row_count          INTEGER        #軞捩杅
DEFINE g_jump               INTEGER        #脤戙硌隅腔捩杅
DEFINE g_no_ask             SMALLINT       #岆瘁羲ゐ硌隅捩弝敦   #No.FUN-6A0066
DEFINE gv_time              VARCHAR(8)  #QR070828
 
MAIN
    OPTIONS
        INPUT NO WRAP    #No.FUN-9B0136
    #   FIELD ORDER FORM #No.FUN-9B0136
    DEFER INTERRUPT                            #腡□笢剿瑩
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   INITIALIZE g_lmq.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM lmq_file WHERE lmq01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i240_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   OPEN WINDOW i240_w WITH FORM "alm/42f/almi240"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   LET g_action_choice = ""
   CALL i240_menu()
 
   CLOSE WINDOW i240_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION i240_curs()
   DEFINE ls STRING
   DEFINE l_lmq02 LIKE lmq_file.lmq02
 
   CLEAR FORM
   CONSTRUCT BY NAME g_wc ON                     # 茤躉奻□沭璃
        lmq01,lmq02,lmq03,lmquser,lmqgrup,
        lmqmodu,lmqdate,lmqacti,lmqcrat,lmqoriu,lmqorig          #No.FUN-9B0136
 
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
      
        ON ACTION controlp
           CASE
              WHEN INFIELD(lmq02)
              CALL s_color(g_lmq.lmq02) RETURNING g_lmq.lmq02
              CALL cl_chg_comp_att('lmq02','color',g_lmq.lmq02)  
              DISPLAY g_lmq.lmq02 TO lmq02
              OTHERWISE
                 EXIT CASE
           END CASE
           LET l_lmq02 = g_lmq.lmq02   
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
       ON ACTION about
          CALL cl_about()
 
       ON ACTION help
          CALL cl_show_help()
 
       ON ACTION controlg
          CALL cl_cmdask()
 
   END CONSTRUCT
 
   #訧蹋□癹腔潰脤
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #硐夔妏蚚赻撩腔訧蹋
   #      LET g_wc = g_wc clipped," AND lmquser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #硐夔妏蚚眈骯□腔訧蹋
   #      LET g_wc = g_wc clipped," AND lmqgrup MATCHES '",
   #                 g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN
   #      LET g_wc = g_wc clipped," AND lmqgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lmquser', 'lmqgrup')
   #End:FUN-980030
 
  #add by ice
   IF NOT cl_null(l_lmq02) THEN
      LET g_wc = g_wc CLIPPED," AND lmq02 = '",l_lmq02,"'"
   END IF
  #add by ice
   LET g_sql = "SELECT lmq01 FROM lmq_file ", # 郪磁堤 SQL 硌鍔
               " WHERE ",g_wc CLIPPED," ",
               " ORDER BY lmq01"
   PREPARE i240_prepare FROM g_sql
   DECLARE i240_cs                                # SCROLL CURSOR
      SCROLL CURSOR WITH HOLD FOR i240_prepare
   LET g_sql = " SELECT COUNT(*) FROM lmq_file WHERE ",g_wc CLIPPED
   PREPARE i240_precount FROM g_sql
   DECLARE i240_count CURSOR FOR i240_precount
END FUNCTION
 
FUNCTION i240_menu()
 
   DEFINE l_cmd  VARCHAR(100)
 
   MENU ""
      BEFORE MENU
         CALL cl_navigator_setting(g_curs_index, g_row_count)
 
         ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
               CALL i240_a()
               CALL cl_chg_comp_att('lmq02','color',g_lmq.lmq02)  
            END IF
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
               CALL i240_q()
            END IF
 
        ON ACTION next
            CALL i240_fetch('N')
 
        ON ACTION previous
            CALL i240_fetch('P')
 
        ON ACTION modify
           LET g_action_choice="modify"
           IF cl_chk_act_auth() THEN
              CALL i240_u()
           END IF
 
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL i240_x()
            END IF
            
        ON ACTION delete                                                        
           LET g_action_choice="delete"                                         
           IF cl_chk_act_auth() THEN                                            
              CALL i240_r()                                                     
           END IF    
 
        ON ACTION help
           CALL cl_show_help()
 
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
 
 
        ON ACTION jump
           CALL i240_fetch('/')
 
        ON ACTION first
           CALL i240_fetch('F')
 
        ON ACTION last
           CALL i240_fetch('L')
 
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
 
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
           LET INT_FLAG=FALSE 		#MOD-570244	mars
           LET g_action_choice = "exit"
           EXIT MENU
 
    END MENU
    CLOSE i240_cs
END FUNCTION
 
 
FUNCTION i240_a()
    MESSAGE ""
    CLEAR FORM                                   # ь茤贏戲弇囀□
    INITIALIZE g_lmq.* LIKE lmq_file.*
    LET g_lmq01_t = NULL
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_lmq.lmquser = g_user
        LET g_lmq.lmqgrup = g_grup 
        LET g_lmq.lmqacti = 'Y'
        LET g_lmq.lmqcrat = g_today
        LET g_lmq.lmqoriu = g_user           #TQC-B20116 
        LET g_lmq.lmqorig = g_grup           #TQC-B20116 
        LET g_lmq.lmq01 = '1'
        CALL i240_i("a")                         # 跪戲弇懷□
        IF INT_FLAG THEN                         # □偌賸DEL瑩
           INITIALIZE g_lmq.* TO NULL
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           CLEAR FORM
           EXIT WHILE
        END IF
        IF g_lmq.lmq01 IS NULL THEN              # KEY 祥褫諾啞
           CONTINUE WHILE
        END IF
             
        LET g_lmq.lmqoriu = g_user      #No.FUN-980030 10/01/04
        LET g_lmq.lmqorig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO lmq_file VALUES(g_lmq.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","lmq_file",g_lmq.lmq01,"",SQLCA.sqlcode,"","",0)   
           CONTINUE WHILE
#        ELSE
#           SELECT ROWID INTO g_lmq.lmq01 FROM lmq_file
#            WHERE lmq01 = g_lmq.lmq01 
        END IF
        EXIT WHILE
    END WHILE
    CALL cl_chg_comp_att('lmq02','color',g_lmq.lmq02)  
    LET g_wc=' '
END FUNCTION
 
FUNCTION i240_i(p_cmd)
   DEFINE   p_cmd     VARCHAR(1),
            l_gen02   LIKE gen_file.gen02,
            l_gen03   LIKE gen_file.gen03,
            l_gen04   LIKE gen_file.gen04,
            l_gem02   LIKE gem_file.gem02,
            l_input   VARCHAR(1),
            l_n       SMALLINT
 
   DISPLAY BY NAME
      g_lmq.lmq01,g_lmq.lmq02,g_lmq.lmq03,g_lmq.lmquser,g_lmq.lmqgrup,
      g_lmq.lmqmodu,g_lmq.lmqdate,g_lmq.lmqacti,g_lmq.lmqcrat
     ,g_lmq.lmqoriu,g_lmq.lmqorig         #TQC-B20116  
 
   INPUT BY NAME 
      g_lmq.lmq01,g_lmq.lmq02,g_lmq.lmq03,g_lmq.lmquser,g_lmq.lmqgrup,
      g_lmq.lmqmodu,g_lmq.lmqdate,g_lmq.lmqacti,g_lmq.lmqcrat
      WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET l_input='N'
         LET g_before_input_done = FALSE
         CALL i240_set_entry(p_cmd)
         CALL i240_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER FIELD lmq01
         DISPLAY "AFTER FIELD lmq01"
          IF g_lmq.lmq01 IS NOT NULL THEN
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_lmq.lmq01 != g_lmq01_t) THEN
             SELECT COUNT(*) INTO l_n FROM lmq_file 
              WHERE lmq01 = g_lmq.lmq01 
             IF l_n > 0 THEN
                CALL cl_err('',-239,1)
                NEXT FIELD lmq01
             END IF
            END IF
          END IF 
 
       AFTER FIELD lmq02
          IF g_lmq.lmq02 IS NOT NULL THEN
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_lmq.lmq02 != g_lmq_t.lmq02) THEN
             SELECT COUNT(*) INTO l_n FROM lmq_file 
              WHERE lmq02 = g_lmq.lmq02
             IF l_n > 0 THEN
                CALL cl_err('',-239,1)
                LET g_lmq.lmq02=g_lmq_t.lmq02
                NEXT FIELD lmq02
             END IF
            END IF
          END IF
 
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         IF g_lmq.lmq01 IS NULL OR g_lmq.lmq02 IS NULL  THEN
            DISPLAY BY NAME g_lmq.lmq01
            DISPLAY BY NAME g_lmq.lmq02
            LET l_input='Y'
          END IF
          IF l_input='Y' THEN
             NEXT FIELD lmq01
          END IF
 
      ON ACTION CONTROLO                        # 朓蚚垀衄戲弇
         IF INFIELD(lmq01) THEN
            LET g_lmq.* = g_lmq_t.*
            CALL i240_show()
            NEXT FIELD lmq01
         END IF
 
     ON ACTION controlp
        CASE
           WHEN INFIELD(lmq02)
           CALL s_color(g_lmq.lmq02) RETURNING g_lmq.lmq02
           CALL cl_chg_comp_att('lmq02','color',g_lmq.lmq02) 
           DISPLAY BY NAME g_lmq.lmq02
           OTHERWISE
              EXIT CASE
        END CASE
 
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                        # 戲弇佽隴
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
 
 
FUNCTION i240_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)
   MESSAGE ""
   CALL cl_opmsg('q')
   DISPLAY '   ' TO FORMONLY.cnt
   CALL i240_curs()                      # 哫豢 SCROLL CURSOR
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLEAR FORM
      RETURN
   END IF
   OPEN i240_count
   FETCH i240_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
   OPEN i240_cs                          # 植DB莉汜磁綱沭璃TEMP(0-30鏃)
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lmq.lmq01,SQLCA.sqlcode,0)
      INITIALIZE g_lmq.* TO NULL
   ELSE
      CALL i240_fetch('F')              # 黍堤TEMP菴珨捩甜珆尨
   END IF
END FUNCTION
 
FUNCTION i240_fetch(p_fllmq)
   DEFINE   p_fllmq          VARCHAR(1)
 
   CASE p_fllmq
      WHEN 'N' FETCH NEXT     i240_cs INTO g_lmq.lmq01
      WHEN 'P' FETCH PREVIOUS i240_cs INTO g_lmq.lmq01
      WHEN 'F' FETCH FIRST    i240_cs INTO g_lmq.lmq01
      WHEN 'L' FETCH LAST     i240_cs INTO g_lmq.lmq01
      WHEN '/'
         IF (NOT g_no_ask) THEN          #No.FUN-6A0066
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
         FETCH ABSOLUTE g_jump i240_cs INTO g_lmq.lmq01
         LET g_no_ask = FALSE       #No.FUN-6A0066
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lmq.lmq01,SQLCA.sqlcode,0)
      RETURN
   ELSE
      CASE p_fllmq
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      CALL cl_navigator_setting(g_curs_index, g_row_count)
   END IF
 
   SELECT * INTO g_lmq.* FROM lmq_file    # 笭黍DB,秪TEMP衄祥掩載陔杻俶
    WHERE lmq01 = g_lmq.lmq01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","lmq_file",g_lmq.lmq01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
   ELSE
      CALL i240_show()                   # 笭陔珆尨
   END IF
END FUNCTION
 
FUNCTION i240_show()
   DEFINE l_color  VARCHAR(10)
   LET g_lmq_t.* = g_lmq.*
   DISPLAY BY NAME g_lmq.lmq01,g_lmq.lmq02,g_lmq.lmq03,
                   g_lmq.lmquser,g_lmq.lmqmodu,g_lmq.lmqgrup,
                   g_lmq.lmqdate,g_lmq.lmqacti,g_lmq.lmqcrat
                  ,g_lmq.lmqoriu,g_lmq.lmqorig         #TQC-B20116                     
   
   CASE
      WHEN g_lmq.lmq02 = '0'
         LET l_color = 'blue'
      WHEN g_lmq.lmq02 = '1'
         LET l_color = 'cyan'
      WHEN g_lmq.lmq02 = '2'
         LET l_color = 'green'
      WHEN g_lmq.lmq02 = '3'
         LET l_color = 'magenta'
      WHEN g_lmq.lmq02 = '4'
         LET l_color = 'red'
      WHEN g_lmq.lmq02 = '5'
         LET l_color = 'white'
      WHEN g_lmq.lmq02 = '6'
         LET l_color = 'yellow'
   END CASE
 
   CALL cl_chg_comp_att('lmq02','color',g_lmq.lmq02)  
   CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION i240_u()
DEFINE l_where      VARCHAR(1000)   
DEFINE l_flag       VARCHAR(1)      
   IF g_lmq.lmq01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_lmq.* FROM lmq_file 
    WHERE lmq01=g_lmq.lmq01
 
   IF g_lmq.lmqacti = 'N' THEN
       CALL cl_err('',9027,1) 
       RETURN
   END IF
    
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_lmq01_t = g_lmq.lmq01
   BEGIN WORK
 
   OPEN i240_cl USING g_lmq01_t
   IF STATUS THEN
       CALL cl_err("OPEN i240_cl:", STATUS, 1)
       CLOSE i240_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i240_cl INTO g_lmq.*               # 勤DB坶隅
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lmq.lmq01,SQLCA.sqlcode,1)
       RETURN
    END IF
 
    CALL i240_show()                          # 珆尨郔陔訧蹋
    LET g_lmq.lmqmodu=g_user                  
    LET g_lmq.lmqdate = g_today
    WHILE TRUE
       CALL i240_i("u")                      # 戲弇載蜊
       IF INT_FLAG THEN
          LET INT_FLAG = 0
          LET g_lmq.*=g_lmq_t.*
          CALL i240_show()
          CALL cl_err('',9001,0)
          EXIT WHILE
       END IF
       UPDATE lmq_file SET lmq_file.* = g_lmq.*    # 載陔DB
        WHERE lmq01 = g_lmq01_t
       IF SQLCA.sqlcode THEN
          CALL cl_err3("upd","lmq_file",g_lmq.lmq01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
          CONTINUE WHILE
       END IF
       EXIT WHILE
    END WHILE
    CLOSE i240_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i240_x()
    IF g_lmq.lmq01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i240_cl USING g_lmq.lmq01
    IF STATUS THEN
       CALL cl_err("OPEN i240_cl:", STATUS, 1)
       CLOSE i240_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i240_cl INTO g_lmq.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lmq.lmq01,SQLCA.sqlcode,1)
       RETURN
    END IF
    LET g_lmq.lmqmodu=g_user                  
    LET g_lmq.lmqdate = g_today
    CALL i240_show()
    IF cl_exp(0,0,g_lmq.lmqacti) THEN
        LET g_chr=g_lmq.lmqacti
        IF g_lmq.lmqacti='Y' THEN
            LET g_lmq.lmqacti='N'
            LET g_lmq.lmqmodu=g_user
            LET g_lmq.lmqdate=g_today
        ELSE
            LET g_lmq.lmqacti='Y'
            LET g_lmq.lmqmodu=g_user
            LET g_lmq.lmqdate=g_today
        END IF
        UPDATE lmq_file
            SET lmqacti=g_lmq.lmqacti,
                lmqmodu=g_lmq.lmqmodu,
                lmqdate=g_lmq.lmqdate
            WHERE lmq01=g_lmq.lmq01
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(g_lmq.lmq01,SQLCA.sqlcode,0)
            LET g_lmq.lmqacti=g_chr
        END IF
        DISPLAY BY NAME g_lmq.lmqacti,g_lmq.lmqmodu,g_lmq.lmqdate
    END IF
    CLOSE i240_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i240_r()
DEFINE l_where      VARCHAR(1000)   #baogui add
DEFINE l_flag       VARCHAR(1)      #baogui add
   IF g_lmq.lmq01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF g_lmq.lmqacti = 'N' THEN
       CALL cl_err('','alm-147',1) 
       RETURN
   END IF
   LET g_lmq01_t=g_lmq.lmq01
   BEGIN WORK
 
   OPEN i240_cl USING g_lmq01_t
   IF STATUS THEN
      CALL cl_err("OPEN i240_cl:", STATUS, 0)
      CLOSE i240_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i240_cl INTO g_lmq.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lmq.lmq01,SQLCA.sqlcode,0)
      RETURN
   END IF
   CALL i240_show()
   IF cl_delete() THEN
      DELETE FROM lmq_file 
       WHERE lmq01 = g_lmq01_t
      CLEAR FORM
      OPEN i240_count
      FETCH i240_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i240_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i240_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE        #No.FUN-6A0066
         CALL i240_fetch('/')
      END IF
   END IF
   CLOSE i240_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION i240_set_entry(p_cmd)
   DEFINE   p_cmd     VARCHAR(1)
 
   IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("lmq01",TRUE)
   END IF
END FUNCTION
 
FUNCTION i240_set_no_entry(p_cmd)
   DEFINE   p_cmd     VARCHAR(1)
 
   IF p_cmd  = 'u' AND g_chkey = 'N' THEN
      CALL cl_set_comp_entry("lmq01",FALSE)
   END IF
 
END FUNCTION
 
