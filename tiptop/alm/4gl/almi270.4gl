# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: almi270.4gl
# Descriptions...: 戰盟顏色設定作業
# Date & Author..: No.FUN-960058 09/06/12 By destiny 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0136 09/11/25 By destiny construct新增字段
# Modify.........: No.TQC-B20116 11/02/21 By lilingyu "資料建立者、資料建立部門"的值未能顯示出來
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-960058--begin 
DEFINE g_lmt       RECORD LIKE lmt_file.*,
       g_lmt_t     RECORD LIKE lmt_file.*,  #掘爺導硉
       g_lmt01_t   LIKE lmt_file.lmt01,     #Key硉掘爺
       g_lmt02_t   LIKE lmt_file.lmt02,     #Key硉掘爺
       g_wc           STRING,                     #揣湔 user 腔脤戙沭璃
       g_sql          STRING                      #郪 sql 蚚
 
  
DEFINE g_forupd_sql         STRING         #SELECT ... FOR UPDATE  SQL
DEFINE g_before_input_done  SMALLINT       #瓚剿岆瘁眒硒俴 Before Input硌鍔
DEFINE g_chr                VARCHAR(1)
DEFINE g_cnt                INTEGER
DEFINE g_i                  SMALLINT       #count/index for any purpose
DEFINE g_msg                VARCHAR(72)
DEFINE g_curs_index         INTEGER
DEFINE g_row_count          INTEGER        #軞捩杅
DEFINE g_jump               INTEGER        #脤戙硌隅腔捩杅
DEFINE g_no_ask            SMALLINT       #岆瘁羲ゐ硌隅捩弝敦 
DEFINE gv_time  VARCHAR(8)  #QR070828
 
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
 
   INITIALIZE g_lmt.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM lmt_file WHERE lmt01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i270_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   OPEN WINDOW i270_w WITH FORM "alm/42f/almi270"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   LET g_action_choice = ""
   CALL i270_menu()
 
   CLOSE WINDOW i270_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION i270_curs()
   DEFINE ls STRING
   DEFINE l_lmt02  LIKE lmt_file.lmt02 
 
   CLEAR FORM
   CONSTRUCT BY NAME g_wc ON                     # 茤躉奻□沭璃
      lmt01,lmt02,lmt03,lmtuser,lmtgrup,
      lmtmodu,lmtdate,lmtacti,lmtcrat,
      lmtorig,lmtoriu                       #No.FUN-9B0136              
 
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(lmt02)
            CALL s_color(g_lmt.lmt02) RETURNING g_lmt.lmt02
            CALL cl_chg_comp_att('lmt02','color',g_lmt.lmt02) 
            LET l_lmt02 = g_lmt.lmt02   
            DISPLAY g_lmt.lmt02 TO lmt02
            OTHERWISE
               EXIT CASE
         END CASE
 
 
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
    #    IF g_priv2='4' THEN                           #硐夔妏蚚赻撩腔訧蹋
    #       LET g_wc = g_wc clipped," AND lmtuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #硐夔妏蚚眈骯□腔訧蹋
    #       LET g_wc = g_wc clipped," AND lmtgrup MATCHES '",
    #                  g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN
    #       LET g_wc = g_wc clipped," AND lmtgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lmtuser', 'lmtgrup')
    #End:FUN-980030
 
 
   IF NOT cl_null(l_lmt02) THEN
      LET g_wc = g_wc CLIPPED , " AND lmt02 = '",l_lmt02,"'"
   END IF 
 
   LET g_sql = "SELECT lmt01 FROM lmt_file ", # 郪磁堤 SQL 硌鍔
               " WHERE ",g_wc CLIPPED," ",
               " ORDER BY lmt01"
   PREPARE i270_prepare FROM g_sql
   DECLARE i270_cs                                # SCROLL CURSOR
      SCROLL CURSOR WITH HOLD FOR i270_prepare
   LET g_sql = " SELECT COUNT(*) FROM lmt_file WHERE ",g_wc CLIPPED
   PREPARE i270_precount FROM g_sql
   DECLARE i270_count CURSOR FOR i270_precount
END FUNCTION
 
FUNCTION i270_menu()
 
   DEFINE l_cmd  VARCHAR(100)
 
   MENU ""
      BEFORE MENU
         CALL cl_navigator_setting(g_curs_index, g_row_count)
 
         ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
               CALL i270_a()
               CALL cl_chg_comp_att('lmt02','color',g_lmt.lmt02)  
            END IF
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
               CALL i270_q()
            END IF
 
        ON ACTION next
            CALL i270_fetch('N')
 
        ON ACTION previous
            CALL i270_fetch('P')
 
        ON ACTION modify
           LET g_action_choice="modify"
           IF cl_chk_act_auth() THEN
              CALL i270_u()
           END IF
 
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL i270_x()
            END IF
            
        ON ACTION delete                                                        
           LET g_action_choice="delete"                                         
           IF cl_chk_act_auth() THEN                                            
              CALL i270_r()                                                     
           END IF    
 
        ON ACTION help
           CALL cl_show_help()
 
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
 
        ON ACTION jump
           CALL i270_fetch('/')
 
        ON ACTION first
           CALL i270_fetch('F')
 
        ON ACTION last
           CALL i270_fetch('L')
 
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
           LET INT_FLAG=FALSE 		
           LET g_action_choice = "exit"
           EXIT MENU
 
 
    END MENU
    CLOSE i270_cs
END FUNCTION
 
 
FUNCTION i270_a()
    MESSAGE ""
    CLEAR FORM                                   # ь茤贏戲弇囀□
    INITIALIZE g_lmt.* LIKE lmt_file.*
    LET g_lmt01_t = NULL
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_lmt.lmtuser = g_user
        LET g_lmt.lmtgrup = g_grup 
        LET g_lmt.lmtacti = 'Y'
        LET g_lmt.lmtcrat = g_today
        LET g_lmt.lmtorig = g_grup        #TQC-B20116
        LET g_lmt.lmtoriu = g_user        #TQC-B20116
                
        LET g_lmt.lmt01 = '0'
        
        CALL i270_i("a")                         # 跪戲弇懷□
        IF INT_FLAG THEN                         # □偌賸DEL瑩
           INITIALIZE g_lmt.* TO NULL
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           CLEAR FORM
           EXIT WHILE
        END IF
        IF g_lmt.lmt01 IS NULL THEN              # KEY 祥褫諾啞
           CONTINUE WHILE
        END IF
        
        LET g_lmt.lmtoriu = g_user      #No.FUN-980030 10/01/04
        LET g_lmt.lmtorig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO lmt_file VALUES(g_lmt.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","lmt_file",g_lmt.lmt01,"",SQLCA.sqlcode,"","",0)   
           CONTINUE WHILE
        ELSE
           SELECT lmt01 INTO g_lmt.lmt01 FROM lmt_file
            WHERE lmt01 = g_lmt.lmt01
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
    CALL cl_chg_comp_att('lmt02','color',g_lmt.lmt02)
END FUNCTION
 
FUNCTION i270_i(p_cmd)
   DEFINE   p_cmd     VARCHAR(1),
            l_gen02   LIKE gen_file.gen02,
            l_gen03   LIKE gen_file.gen03,
            l_gen04   LIKE gen_file.gen04,
            l_gem02   LIKE gem_file.gem02,
            l_input   VARCHAR(1),
            l_n       SMALLINT
 
   DISPLAY BY NAME
      g_lmt.lmt01,g_lmt.lmt02,g_lmt.lmt03,g_lmt.lmtuser,g_lmt.lmtgrup,
      g_lmt.lmtmodu,g_lmt.lmtdate,g_lmt.lmtacti,g_lmt.lmtcrat
     ,g_lmt.lmtorig,g_lmt.lmtoriu        #TQC-B20116
 
   INPUT BY NAME 
      g_lmt.lmt01,g_lmt.lmt02,g_lmt.lmt03,g_lmt.lmtuser,g_lmt.lmtgrup,
      g_lmt.lmtmodu,g_lmt.lmtdate,g_lmt.lmtacti,g_lmt.lmtcrat
      WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET l_input='N'
         LET g_before_input_done = FALSE
         CALL i270_set_entry(p_cmd)
         CALL i270_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER FIELD lmt01
         DISPLAY "AFTER FIELD lmt01"
          IF g_lmt.lmt01 IS NOT NULL THEN
            IF p_cmd = "a" OR                    # □懷□麼載蜊й蜊KEY
               (p_cmd = "u" AND g_lmt.lmt01 != g_lmt01_t) THEN
             SELECT COUNT(*) INTO l_n FROM lmt_file 
              WHERE lmt01 = g_lmt.lmt01
             IF l_n > 0 THEN
                CALL cl_err('',-239,1)
                NEXT FIELD lmt01
             END IF
            END IF
          END IF 
 
       AFTER FIELD lmt02
          IF g_lmt.lmt02 IS NOT NULL THEN
            IF p_cmd = "a" OR                    # □懷□麼載蜊й蜊KEY
               (p_cmd = "u" AND g_lmt.lmt02 != g_lmt_t.lmt02) THEN
             SELECT COUNT(*) INTO l_n FROM lmt_file 
              WHERE lmt02 = g_lmt.lmt02
             IF l_n > 0 THEN
                CALL cl_err('',-239,1)
                LET g_lmt.lmt02=g_lmt_t.lmt02
                NEXT FIELD lmt02
             END IF
             END IF
          END IF 
 
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         IF g_lmt.lmt01 IS NULL OR g_lmt.lmt02 IS NULL  THEN
            DISPLAY BY NAME g_lmt.lmt01
            LET l_input='Y'
          END IF
          IF l_input='Y' THEN
             NEXT FIELD lmt01
          END IF
 
      ON ACTION CONTROLO                        # 朓蚚垀衄戲弇
         IF INFIELD(lmt01) THEN
            LET g_lmt.* = g_lmt_t.*
            CALL i270_show()
            NEXT FIELD lmt01
         END IF
 
     ON ACTION controlp
        CASE
           WHEN INFIELD(lmt02)
           CALL s_color(g_lmt.lmt02) RETURNING g_lmt.lmt02
           CALL cl_chg_comp_att('lmt02','color',g_lmt.lmt02) 
           DISPLAY BY NAME g_lmt.lmt02 
           OTHERWISE
              EXIT CASE
        END CASE
 
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                        # 戲弇佽隴
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   END INPUT
END FUNCTION
 
FUNCTION i270_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)
   MESSAGE ""
   CALL cl_opmsg('q')
   DISPLAY '   ' TO FORMONLY.cnt
   CALL i270_curs()                      # 哫豢 SCROLL CURSOR
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLEAR FORM
      RETURN
   END IF
   OPEN i270_count
   FETCH i270_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
   OPEN i270_cs                          # 植DB莉汜磁綱沭璃TEMP(0-30鏃)
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lmt.lmt01,SQLCA.sqlcode,0)
      INITIALIZE g_lmt.* TO NULL
   ELSE
      CALL i270_fetch('F')              # 黍堤TEMP菴珨捩甜珆尨
   END IF
END FUNCTION
 
FUNCTION i270_fetch(p_fllmt)
   DEFINE   p_fllmt          VARCHAR(1)
 
   CASE p_fllmt
      WHEN 'N' FETCH NEXT     i270_cs INTO g_lmt.lmt01
      WHEN 'P' FETCH PREVIOUS i270_cs INTO g_lmt.lmt01
      WHEN 'F' FETCH FIRST    i270_cs INTO g_lmt.lmt01
      WHEN 'L' FETCH LAST     i270_cs INTO g_lmt.lmt01
      WHEN '/'
         IF (NOT g_no_ask) THEN         
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
         FETCH ABSOLUTE g_jump i270_cs INTO g_lmt.lmt01
         LET g_no_ask = FALSE      
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lmt.lmt01,SQLCA.sqlcode,0)
      RETURN
   ELSE
      CASE p_fllmt
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      CALL cl_navigator_setting(g_curs_index, g_row_count)
   END IF
 
   SELECT * INTO g_lmt.* FROM lmt_file    # 笭黍DB,秪TEMP衄祥掩載陔杻俶
    WHERE lmt01 = g_lmt.lmt01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","lmt_file",g_lmt.lmt01,"",SQLCA.sqlcode,"","",0) 
   ELSE
      CALL i270_show()                   # 笭陔珆尨
   END IF
END FUNCTION
 
FUNCTION i270_show()
   DEFINE l_color  VARCHAR(10)
   LET g_lmt_t.* = g_lmt.*
   DISPLAY BY NAME g_lmt.lmt01,g_lmt.lmt02,g_lmt.lmt03,g_lmt.lmtuser,g_lmt.lmtmodu, 
                   g_lmt.lmtgrup,g_lmt.lmtdate,g_lmt.lmtacti,g_lmt.lmtcrat
                  ,g_lmt.lmtorig,g_lmt.lmtoriu        #TQC-B20116                   
  
   CASE
      WHEN g_lmt.lmt02 = '0'
         LET l_color = 'blue'
      WHEN g_lmt.lmt02 = '1'
         LET l_color = 'cyan'
      WHEN g_lmt.lmt02 = '2'
         LET l_color = 'green'
      WHEN g_lmt.lmt02 = '3'
         LET l_color = 'magenta'
      WHEN g_lmt.lmt02 = '4'
         LET l_color = 'red'
      WHEN g_lmt.lmt02 = '5'
         LET l_color = 'white'
      WHEN g_lmt.lmt02 = '6'
         LET l_color = 'yellow'
   END CASE
   CALL cl_chg_comp_att('lmt02','color',g_lmt.lmt02) 
   CALL cl_show_fld_cont()          
END FUNCTION
 
FUNCTION i270_u()
DEFINE l_where      VARCHAR(1000)   
DEFINE l_flag       VARCHAR(1)     
   IF g_lmt.lmt01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_lmt.* FROM lmt_file 
    WHERE lmt01=g_lmt.lmt01
 
   IF g_lmt.lmtacti = 'N' THEN
       CALL cl_err('',9027,1) 
       RETURN
   END IF
   
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_lmt01_t = g_lmt.lmt01
   LET g_lmt02_t = g_lmt.lmt02
   BEGIN WORK
 
   OPEN i270_cl USING g_lmt01_t
   IF STATUS THEN
       CALL cl_err("OPEN i270_cl:", STATUS, 1)
       CLOSE i270_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i270_cl INTO g_lmt.*               # 勤DB坶隅
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lmt.lmt01,SQLCA.sqlcode,1)
       RETURN
    END IF
 
    CALL i270_show()                          # 珆尨郔陔訧蹋
    LET g_lmt.lmtmodu=g_user                  
    LET g_lmt.lmtdate = g_today    
    WHILE TRUE
       CALL i270_i("u")                      # 戲弇載蜊
       IF INT_FLAG THEN
          LET INT_FLAG = 0
          LET g_lmt.*=g_lmt_t.*
          CALL i270_show()
          CALL cl_err('',9001,0)
          EXIT WHILE
       END IF   
       UPDATE lmt_file SET lmt_file.* = g_lmt.*    # 載陔DB
        WHERE lmt01 = g_lmt01_t
       IF SQLCA.sqlcode THEN
          CALL cl_err3("upd","lmt_file",g_lmt.lmt01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
          CONTINUE WHILE
       END IF
       EXIT WHILE
    END WHILE
    CLOSE i270_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i270_x()
    IF g_lmt.lmt01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i270_cl USING g_lmt.lmt01
    IF STATUS THEN
       CALL cl_err("OPEN i270_cl:", STATUS, 1)
       CLOSE i270_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i270_cl INTO g_lmt.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lmt.lmt01,SQLCA.sqlcode,1)
       RETURN
    END IF
    LET g_lmt.lmtmodu=g_user                  
    LET g_lmt.lmtdate = g_today
    CALL i270_show()
    IF cl_exp(0,0,g_lmt.lmtacti) THEN
        LET g_chr=g_lmt.lmtacti
        IF g_lmt.lmtacti='Y' THEN
            LET g_lmt.lmtacti='N'
            LET g_lmt.lmtmodu=g_user
            LET g_lmt.lmtdate=g_today
        ELSE
            LET g_lmt.lmtacti='Y'
            LET g_lmt.lmtmodu=g_user
            LET g_lmt.lmtdate=g_today
        END IF
        UPDATE lmt_file
            SET lmtacti=g_lmt.lmtacti,
                lmtmodu=g_lmt.lmtmodu,
                lmtdate=g_lmt.lmtdate
            WHERE lmt01=g_lmt.lmt01
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(g_lmt.lmt01,SQLCA.sqlcode,0)
            LET g_lmt.lmtacti=g_chr
        END IF
        DISPLAY BY NAME g_lmt.lmtacti,g_lmt.lmtmodu,g_lmt.lmtdate
    END IF
    CLOSE i270_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i270_r()
DEFINE l_where      VARCHAR(1000)   
DEFINE l_flag       VARCHAR(1)      
   IF g_lmt.lmt01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   
   IF g_lmt.lmtacti = 'N' THEN
       CALL cl_err('','alm-147',1) 
       RETURN
   END IF      
   LET g_lmt01_t=g_lmt.lmt01
   BEGIN WORK
 
   OPEN i270_cl USING g_lmt01_t
   IF STATUS THEN
      CALL cl_err("OPEN i270_cl:", STATUS, 0)
      CLOSE i270_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i270_cl INTO g_lmt.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lmt.lmt01,SQLCA.sqlcode,0)
      RETURN
   END IF
   CALL i270_show()
   IF cl_delete() THEN 
      DELETE FROM lmt_file 
       WHERE lmt01 = g_lmt01_t
      CLEAR FORM
      OPEN i270_count
      FETCH i270_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i270_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i270_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE        
         CALL i270_fetch('/')
      END IF
   END IF
   CLOSE i270_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION i270_set_entry(p_cmd)
   DEFINE   p_cmd     VARCHAR(1)
 
   IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("lmt01",TRUE)
   END IF
END FUNCTION
 
FUNCTION i270_set_no_entry(p_cmd)
   DEFINE   p_cmd     VARCHAR(1)
 
   IF p_cmd  = 'u' AND g_chkey = 'N' THEN
      CALL cl_set_comp_entry("lmt01",FALSE)
   END IF
 
END FUNCTION
 
