# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: almi260.4gl
# Descriptions...: 合同狀態顏色設定作業
# Date & Author..: NO.FUN-960058 09/06/12 By  destiny 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0136 09/11/25 By destiny construct新增字段 
# Modify.........: No.TQC-B20116 11/02/21 By lilingyu "資料建立者、資料建立部門"的值未能顯示出來

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#No.FUN-960058--begin
DEFINE g_lms       RECORD LIKE lms_file.*,
       g_lms_t     RECORD LIKE lms_file.*,  #掘爺導硉
       g_lms01_t   LIKE lms_file.lms01,  #Key硉掘爺
       g_lms02_t   LIKE lms_file.lms02,  #Key硉掘爺
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
   INITIALIZE g_lms.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM lms_file WHERE lms01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i260_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   OPEN WINDOW i260_w WITH FORM "alm/42f/almi260"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   LET g_action_choice = ""
   CALL i260_menu()
 
   CLOSE WINDOW i260_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION i260_curs()
   DEFINE ls STRING
   DEFINE l_lms02     LIKE lms_file.lms02 
 
   CLEAR FORM
   CONSTRUCT BY NAME g_wc ON                     # 茤躉奻□沭璃
      lms01,lms02,lms03,lmsuser,lmsgrup,
        lmsmodu,lmsdate,lmsacti,lmscrat,
        lmsorig,lmsoriu                   #No.FUN-9B0136               
 
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(lms02)
            CALL s_color(g_lms.lms02) RETURNING g_lms.lms02
            CALL cl_chg_comp_att('lms02','color',g_lms.lms02)  
            LET l_lms02 = g_lms.lms02  
            DISPLAY g_lms.lms02 TO lms02
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
   #   IF g_priv2='4' THEN                           #硐夔妏蚚赻撩腔訧蹋
   #      LET g_wc = g_wc clipped," AND lmsuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #硐夔妏蚚眈骯□腔訧蹋
   #      LET g_wc = g_wc clipped," AND lmsgrup MATCHES '",
   #                 g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN
   #      LET g_wc = g_wc clipped," AND lmsgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lmsuser', 'lmsgrup')
   #End:FUN-980030
 
 
   IF NOT cl_null(l_lms02) THEN 
      LET g_wc = g_wc CLIPPED ," AND lms02 ='",l_lms02,"'"
   END IF 
 
   LET g_sql = "SELECT lms01 FROM lms_file ", # 郪磁堤 SQL 硌鍔
               " WHERE ",g_wc CLIPPED," ",
               " ORDER BY lms01"
   PREPARE i260_prepare FROM g_sql
   DECLARE i260_cs                                # SCROLL CURSOR
      SCROLL CURSOR WITH HOLD FOR i260_prepare
   LET g_sql = " SELECT COUNT(*) FROM lms_file WHERE ",g_wc CLIPPED
   PREPARE i260_precount FROM g_sql
   DECLARE i260_count CURSOR FOR i260_precount
END FUNCTION
 
FUNCTION i260_menu()
 
   DEFINE l_cmd  VARCHAR(100)
 
   MENU ""
      BEFORE MENU
         CALL cl_navigator_setting(g_curs_index, g_row_count)
 
         ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
               CALL i260_a()
               CALL cl_chg_comp_att('lms02','color',g_lms.lms02) 
            END IF
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
               CALL i260_q()
            END IF
 
        ON ACTION next
            CALL i260_fetch('N')
 
        ON ACTION previous
            CALL i260_fetch('P')
 
        ON ACTION modify
           LET g_action_choice="modify"
           IF cl_chk_act_auth() THEN
              CALL i260_u()
           END IF
 
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL i260_x()
            END IF
            
        ON ACTION delete                                                        
           LET g_action_choice="delete"                                         
           IF cl_chk_act_auth() THEN                                            
              CALL i260_r()                                                     
           END IF    
 
        ON ACTION help
           CALL cl_show_help()
 
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
 
        ON ACTION jump
           CALL i260_fetch('/')
 
        ON ACTION first
           CALL i260_fetch('F')
 
        ON ACTION last
           CALL i260_fetch('L')
 
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
    CLOSE i260_cs
END FUNCTION
 
 
FUNCTION i260_a()
    MESSAGE ""
    CLEAR FORM                                   # ь茤贏戲弇囀□
    INITIALIZE g_lms.* LIKE lms_file.*
    LET g_lms01_t = NULL
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_lms.lms01 = '1'
        LET g_lms.lmsuser = g_user
        LET g_lms.lmsgrup = g_grup 
        LET g_lms.lmsacti = 'Y'
        LET g_lms.lmscrat = g_today
        LET g_lms.lmsoriu = g_user     #TQC-B20116
        LET g_lms.lmsorig = g_grup     #TQC-B20116
         
        CALL i260_i("a")                         # 跪戲弇懷□
        IF INT_FLAG THEN                         # □偌賸DEL瑩
           INITIALIZE g_lms.* TO NULL
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           CLEAR FORM
           EXIT WHILE
        END IF
        IF g_lms.lms01 IS NULL THEN              # KEY 祥褫諾啞
           CONTINUE WHILE
        END IF
 
        LET g_lms.lmsoriu = g_user      #No.FUN-980030 10/01/04
        LET g_lms.lmsorig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO lms_file VALUES(g_lms.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","lms_file",g_lms.lms01,"",SQLCA.sqlcode,"","",0)   
           CONTINUE WHILE
        ELSE
           SELECT lms01 INTO g_lms.lms01 FROM lms_file
            WHERE lms01 = g_lms.lms01 
        END IF
        EXIT WHILE
    END WHILE
    CALL cl_chg_comp_att('lms02','color',g_lms.lms02)  
    LET g_wc=' '
END FUNCTION
 
FUNCTION i260_i(p_cmd)
   DEFINE   p_cmd     VARCHAR(1),
            l_gen02   LIKE gen_file.gen02,
            l_gen03   LIKE gen_file.gen03,
            l_gen04   LIKE gen_file.gen04,
            l_gem02   LIKE gem_file.gem02,
            l_input   VARCHAR(1),
            l_n       SMALLINT
 
   DISPLAY BY NAME
      g_lms.lms01,g_lms.lms02,g_lms.lms03,g_lms.lmsuser,g_lms.lmsgrup,
      g_lms.lmsmodu,g_lms.lmsdate,g_lms.lmsacti,g_lms.lmscrat
 
   INPUT BY NAME 
      g_lms.lms01,g_lms.lms02,g_lms.lms03,g_lms.lmsuser,g_lms.lmsgrup,
      g_lms.lmsmodu,g_lms.lmsdate,g_lms.lmsacti,g_lms.lmscrat
     ,g_lms.lmsoriu,g_lms.lmsorig      #TQC-B20116
      WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET l_input='N'
         LET g_before_input_done = FALSE
         CALL i260_set_entry(p_cmd)
         CALL i260_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER FIELD lms01
         DISPLAY "AFTER FIELD lms01"
          IF g_lms.lms01 IS NOT NULL THEN
            IF p_cmd = "a" OR                    # □懷□麼載蜊й蜊KEY
               (p_cmd = "u" AND g_lms.lms01 != g_lms01_t) THEN
             SELECT COUNT(*) INTO l_n FROM lms_file 
              WHERE lms01 = g_lms.lms01
             IF l_n > 0 THEN
                CALL cl_err('',-239,1)
                NEXT FIELD lms01
             END IF
            END IF
            IF g_lms.lms01 > 12 OR g_lms.lms01 < 1 THEN
               CALL cl_err('','aom-580',1)
               NEXT FIELD lms01
            END IF
          END IF 
 
       AFTER FIELD lms02
          IF g_lms.lms02 IS NOT NULL THEN
            IF p_cmd = "a" OR                    # □懷□麼載蜊й蜊KEY
               (p_cmd = "u" AND g_lms.lms02 != g_lms_t.lms02) THEN
             SELECT COUNT(*) INTO l_n FROM lms_file 
              WHERE lms02 = g_lms.lms02
             IF l_n > 0 THEN
                CALL cl_err('',-239,1)
                LET g_lms.lms02=g_lms_t.lms02
                NEXT FIELD lms02
             END IF
            END IF
          END IF
 
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         IF g_lms.lms01 IS NULL OR g_lms.lms02 IS NULL  THEN
            DISPLAY BY NAME g_lms.lms01
            DISPLAY BY NAME g_lms.lms02
            LET l_input='Y'
          END IF
          IF l_input='Y' THEN
             NEXT FIELD lms01
          END IF
 
      ON ACTION CONTROLO                        # 朓蚚垀衄戲弇
         IF INFIELD(lms01) THEN
            LET g_lms.* = g_lms_t.*
            CALL i260_show()
            NEXT FIELD lms01
         END IF
 
     ON ACTION controlp
        CASE
           WHEN INFIELD(lms02)
           CALL s_color(g_lms.lms02) RETURNING g_lms.lms02
           CALL cl_chg_comp_att('lms02','color',g_lms.lms02) 
           DISPLAY BY NAME g_lms.lms02
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
 
FUNCTION i260_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)
   MESSAGE ""
   CALL cl_opmsg('q')
   DISPLAY '   ' TO FORMONLY.cnt
   CALL i260_curs()                      # 哫豢 SCROLL CURSOR
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLEAR FORM
      RETURN
   END IF
   OPEN i260_count
   FETCH i260_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
   OPEN i260_cs                          # 植DB莉汜磁綱沭璃TEMP(0-30鏃)
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lms.lms01,SQLCA.sqlcode,0)
      INITIALIZE g_lms.* TO NULL
   ELSE
      CALL i260_fetch('F')              # 黍堤TEMP菴珨捩甜珆尨
   END IF
END FUNCTION
 
FUNCTION i260_fetch(p_fllms)
   DEFINE   p_fllms          VARCHAR(1)
 
   CASE p_fllms
      WHEN 'N' FETCH NEXT     i260_cs INTO g_lms.lms01
      WHEN 'P' FETCH PREVIOUS i260_cs INTO g_lms.lms01
      WHEN 'F' FETCH FIRST    i260_cs INTO g_lms.lms01
      WHEN 'L' FETCH LAST     i260_cs INTO g_lms.lms01
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
         FETCH ABSOLUTE g_jump i260_cs INTO g_lms.lms01
         LET g_no_ask = FALSE      
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lms.lms01,SQLCA.sqlcode,0)
      RETURN
   ELSE
      CASE p_fllms
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      CALL cl_navigator_setting(g_curs_index, g_row_count)
   END IF
 
   SELECT * INTO g_lms.* FROM lms_file    # 笭黍DB,秪TEMP衄祥掩載陔杻俶
    WHERE lms01 = g_lms.lms01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","lms_file",g_lms.lms01,"",SQLCA.sqlcode,"","",0)  
   ELSE
      CALL i260_show()                   # 笭陔珆尨
   END IF
END FUNCTION
 
FUNCTION i260_show()
   DEFINE l_color  VARCHAR(10)
   LET g_lms_t.* = g_lms.*
   DISPLAY BY NAME g_lms.lms01,g_lms.lms02,g_lms.lms03,g_lms.lmsuser,g_lms.lmsmodu, 
                   g_lms.lmsgrup,g_lms.lmsdate,g_lms.lmsacti,g_lms.lmscrat
                  ,g_lms.lmsoriu,g_lms.lmsorig      #TQC-B20116                   
   
   CASE
      WHEN g_lms.lms02 = '0'
         LET l_color = 'blue'
      WHEN g_lms.lms02 = '1'
         LET l_color = 'cyan'
      WHEN g_lms.lms02 = '2'
         LET l_color = 'green'
      WHEN g_lms.lms02 = '3'
         LET l_color = 'magenta'
      WHEN g_lms.lms02 = '4'
         LET l_color = 'red'
      WHEN g_lms.lms02 = '5'
         LET l_color = 'white'
      WHEN g_lms.lms02 = '6'
         LET l_color = 'yellow'
   END CASE
   CALL cl_chg_comp_att('lms02','color',g_lms.lms02)  
   CALL cl_show_fld_cont()                  
END FUNCTION
 
FUNCTION i260_u()
DEFINE l_where      VARCHAR(1000)   
DEFINE l_flag       VARCHAR(1)      
   IF g_lms.lms01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_lms.* FROM lms_file 
    WHERE lms01=g_lms.lms01
 
 
   IF g_lms.lmsacti = 'N' THEN
       CALL cl_err('',9027,1) 
       RETURN
   END IF
   
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_lms01_t = g_lms.lms01
   BEGIN WORK
 
   OPEN i260_cl USING g_lms01_t
   IF STATUS THEN
       CALL cl_err("OPEN i260_cl:", STATUS, 1)
       CLOSE i260_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i260_cl INTO g_lms.*               # 勤DB坶隅
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lms.lms01,SQLCA.sqlcode,1)
       RETURN
    END IF
 
    CALL i260_show()                          # 珆尨郔陔訧蹋
    LET g_lms.lmsmodu=g_user                  
    LET g_lms.lmsdate = g_today    
    WHILE TRUE
       CALL i260_i("u")                      # 戲弇載蜊
       IF INT_FLAG THEN
          LET INT_FLAG = 0
          LET g_lms.*=g_lms_t.*
          CALL i260_show()
          CALL cl_err('',9001,0)
          EXIT WHILE
       END IF    
       UPDATE lms_file SET lms_file.* = g_lms.*    # 載陔DB
        WHERE lms01 = g_lms01_t
       IF SQLCA.sqlcode THEN
          CALL cl_err3("upd","lms_file",g_lms.lms01,"",SQLCA.sqlcode,"","",0)  
          CONTINUE WHILE
       END IF
       EXIT WHILE
    END WHILE
    CLOSE i260_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i260_x()
    IF g_lms.lms01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i260_cl USING g_lms.lms01
    IF STATUS THEN
       CALL cl_err("OPEN i260_cl:", STATUS, 1)
       CLOSE i260_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i260_cl INTO g_lms.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lms.lms01,SQLCA.sqlcode,1)
       RETURN
    END IF
    LET g_lms.lmsmodu=g_user                  
    LET g_lms.lmsdate = g_today
    CALL i260_show()
    IF cl_exp(0,0,g_lms.lmsacti) THEN
        LET g_chr=g_lms.lmsacti
        IF g_lms.lmsacti='Y' THEN
            LET g_lms.lmsacti='N'
            LET g_lms.lmsmodu=g_user
            LET g_lms.lmsdate=g_today 
        ELSE
            LET g_lms.lmsacti='Y'
            LET g_lms.lmsmodu=g_user
            LET g_lms.lmsdate=g_today 
        END IF
        UPDATE lms_file
            SET lmsacti=g_lms.lmsacti,
                lmsmodu=g_lms.lmsmodu,
                lmsdate=g_lms.lmsdate
            WHERE lms01=g_lms.lms01
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(g_lms.lms01,SQLCA.sqlcode,0)
            LET g_lms.lmsacti=g_chr
        END IF
        DISPLAY BY NAME g_lms.lmsacti,g_lms.lmsmodu,g_lms.lmsdate
    END IF
    CLOSE i260_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i260_r()
DEFINE l_where      VARCHAR(1000)   #baogui add
DEFINE l_flag       VARCHAR(1)      #baogui add
   IF g_lms.lms01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF g_lms.lmsacti = 'N' THEN
       CALL cl_err('','alm-147',1) 
       RETURN
   END IF      
   LET g_lms01_t=g_lms.lms01
   BEGIN WORK
 
   OPEN i260_cl USING g_lms01_t
   IF STATUS THEN
      CALL cl_err("OPEN i260_cl:", STATUS, 0)
      CLOSE i260_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i260_cl INTO g_lms.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lms.lms01,SQLCA.sqlcode,0)
      RETURN
   END IF
   CALL i260_show()
   IF cl_delete() THEN
      DELETE FROM lms_file 
       WHERE lms01 = g_lms01_t
       
      CLEAR FORM
      OPEN i260_count
      FETCH i260_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i260_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i260_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE       
         CALL i260_fetch('/')
      END IF
   END IF
   CLOSE i260_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION i260_set_entry(p_cmd)
   DEFINE   p_cmd     VARCHAR(1)
 
   IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
     # CALL cl_set_comp_entry("lms01,lms02",TRUE)
      CALL cl_set_comp_entry("lms01",TRUE)
   END IF
END FUNCTION
 
FUNCTION i260_set_no_entry(p_cmd)
   DEFINE   p_cmd     VARCHAR(1)
 
   IF p_cmd  = 'u' AND g_chkey = 'N' THEN
      CALL cl_set_comp_entry("lms01",FALSE)
   END IF
 
END FUNCTION
 
#No.FUN-960058--end
