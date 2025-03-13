# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: almi250.4gl
# Descriptions...: 經營小類顏色設定作業
# Date & Author..: NO.FUN-960058 09/06/12 By  destiny  
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0136 09/11/25 By destiny construct新增字段
# Modify.........: No:FUN-A60010 10/07/13 By huangtao 小类代号用產品分類代替
# Modify.........: No.TQC-B20116 11/02/21 By lilingyu "資料建立者、資料建立部門"的值未能顯示出來
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-960058--begin 
DEFINE g_lmr       RECORD LIKE lmr_file.*,
       g_lmr_t     RECORD LIKE lmr_file.*,  #掘爺導硉
       g_lmr01_t   LIKE lmr_file.lmr01,  #Key硉掘爺
       g_lmr02_t   LIKE lmr_file.lmr02,
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
 
   INITIALIZE g_lmr.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM lmr_file WHERE lmr01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i250_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   OPEN WINDOW i250_w WITH FORM "alm/42f/almi250"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   LET g_action_choice = ""
   CALL i250_menu()
 
   CLOSE WINDOW i250_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION i250_curs()
   DEFINE ls STRING
   DEFINE l_lmr02 LIKE lmr_file.lmr02   #add by chenl 
 
   CLEAR FORM
   CONSTRUCT BY NAME g_wc ON                     # 茤躉奻□沭璃
        lmr01,lmr02,lmr03,lmruser,lmrgrup,
        lmrmodu,lmrdate,lmracti,lmrcrat,lmrorig,lmroriu  #No.FUN-9B0136             
 
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
       ON ACTION controlp
          CASE
              WHEN INFIELD(lmr01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_lmr_11"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lmr01
#                 CALL i250_lmk02()            #FUN-A60010
                  CALL i250_oba02()            #FUN-A60010
                 NEXT FIELD lmr01 
              WHEN INFIELD(lmr02)
                CALL s_color(g_lmr.lmr02) RETURNING g_lmr.lmr02
                CALL cl_chg_comp_att('lmr02','color',g_lmr.lmr02)      
                DISPLAY g_lmr.lmr02 TO lmr02
                LET l_lmr02 = g_lmr.lmr02     
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
   #      LET g_wc = g_wc clipped," AND lmruser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #硐夔妏蚚眈骯□腔訧蹋
   #      LET g_wc = g_wc clipped," AND lmrgrup MATCHES '",
   #                 g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN
   #      LET g_wc = g_wc clipped," AND lmrgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lmruser', 'lmrgrup')
   #End:FUN-980030
 
   #add by chenl
   IF NOT cl_null(l_lmr02) THEN 
      LET g_wc = g_wc CLIPPED ," AND lmr02 = '",l_lmr02,"'"
   END IF 
   #add by chenl
   LET g_sql = "SELECT lmr01 FROM lmr_file ", # 郪磁堤 SQL 硌鍔
               " WHERE ",g_wc CLIPPED," ",
               " ORDER BY lmr01"
   PREPARE i250_prepare FROM g_sql
   DECLARE i250_cs                                # SCROLL CURSOR
      SCROLL CURSOR WITH HOLD FOR i250_prepare
   LET g_sql = " SELECT COUNT(*) FROM lmr_file WHERE ",g_wc CLIPPED
   PREPARE i250_precount FROM g_sql
   DECLARE i250_count CURSOR FOR i250_precount
END FUNCTION
 
FUNCTION i250_menu()
 
   DEFINE l_cmd  VARCHAR(100)
 
   MENU ""
      BEFORE MENU
         CALL cl_navigator_setting(g_curs_index, g_row_count)
 
         ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
               CALL i250_a()
               CALL cl_chg_comp_att('lmr02','color',g_lmr.lmr02)      
            END IF
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
               CALL i250_q()
            END IF
 
        ON ACTION next
            CALL i250_fetch('N')
 
        ON ACTION previous
            CALL i250_fetch('P')
 
        ON ACTION modify
           LET g_action_choice="modify"
           IF cl_chk_act_auth() THEN
              CALL i250_u()
           END IF
           
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL i250_x()
            END IF
 
        ON ACTION delete                                                        
           LET g_action_choice="delete"                                         
           IF cl_chk_act_auth() THEN                                            
              CALL i250_r()                                                     
           END IF    
 
        ON ACTION help
           CALL cl_show_help()
 
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
 
        ON ACTION jump
           CALL i250_fetch('/')
 
        ON ACTION first
           CALL i250_fetch('F')
 
        ON ACTION last
           CALL i250_fetch('L')
 
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
    CLOSE i250_cs
END FUNCTION
 
 
FUNCTION i250_a()
    MESSAGE ""
    CLEAR FORM                                   # ь茤贏戲弇囀□
    INITIALIZE g_lmr.* LIKE lmr_file.*
    LET g_lmr01_t = NULL
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_lmr.lmruser = g_user
        LET g_lmr.lmrgrup = g_grup 
        LET g_lmr.lmracti = 'Y'
        LET g_lmr.lmrcrat = g_today
        LET g_lmr.lmroriu = g_user     #TQC-B20116         
        LET g_lmr.lmrorig = g_grup     #TQC-B20116    
                
        CALL i250_i("a")                         # 跪戲弇懷□
        IF INT_FLAG THEN                         # □偌賸DEL瑩
           INITIALIZE g_lmr.* TO NULL
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           CLEAR FORM
           EXIT WHILE
        END IF
        IF g_lmr.lmr01 IS NULL THEN              # KEY 祥褫諾啞
           CONTINUE WHILE
        END IF
 
        LET g_lmr.lmroriu = g_user      #No.FUN-980030 10/01/04
        LET g_lmr.lmrorig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO lmr_file VALUES(g_lmr.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","lmr_file",g_lmr.lmr01,"",SQLCA.sqlcode,"","",0)   
           CONTINUE WHILE
        ELSE
           SELECT lmr01 INTO g_lmr.lmr01 FROM lmr_file
            WHERE lmr01 = g_lmr.lmr01
        END IF
        EXIT WHILE
    END WHILE
    CALL cl_chg_comp_att('lmr02','color',g_lmr.lmr02)     
    LET g_wc=' '
END FUNCTION
 
FUNCTION i250_i(p_cmd)
   DEFINE   p_cmd     VARCHAR(1),
            l_gen02   LIKE gen_file.gen02,
            l_gen03   LIKE gen_file.gen03,
            l_gen04   LIKE gen_file.gen04,
            l_gem02   LIKE gem_file.gem02,
            l_input   VARCHAR(1),
            l_n       LIKE type_file.num5,
            l_n1      LIKE type_file.num5,
#           l_lmk05   LIKE lmk_file.lmk05                #FUN-A60010 
            l_obaacti LIKE oba_file.obaacti              #FUN-A60010
 
   DISPLAY BY NAME
      g_lmr.lmr01,g_lmr.lmr02,g_lmr.lmr03,g_lmr.lmruser,g_lmr.lmrgrup,
      g_lmr.lmrmodu,g_lmr.lmrdate,g_lmr.lmracti,g_lmr.lmrcrat
     ,g_lmr.lmroriu,g_lmr.lmrorig                      #TQC-B20116         
 
   INPUT BY NAME 
      g_lmr.lmr01,g_lmr.lmr02,g_lmr.lmr03,g_lmr.lmruser,g_lmr.lmrgrup,
      g_lmr.lmrmodu,g_lmr.lmrdate,g_lmr.lmracti,g_lmr.lmrcrat
      WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET l_input='N'
         LET g_before_input_done = FALSE
         CALL i250_set_entry(p_cmd)
         CALL i250_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER FIELD lmr01
         DISPLAY "AFTER FIELD lmr01"
          IF g_lmr.lmr01 IS NOT NULL THEN
            IF p_cmd = "a" OR                    # □懷□麼載蜊й蜊KEY
               (p_cmd = "u" AND g_lmr.lmr01 != g_lmr01_t) THEN
#            SELECT COUNT(*) INTO l_n FROM lmk_file 
#             WHERE lmk01 = g_lmr.lmr01                        #FUN-A60010
             SELECT COUNT(*) INTO l_n FROM oba_file
              WHERE oba01 = g_lmr.lmr01 AND oba14 ='0'                    #FUN-A60010
#            SELECT lmk05 INTO l_lmk05 FROM lmk_file 
#             WHERE lmk01 = g_lmr.lmr01                        #FUN-A60010
             SELECT obaacti INTO l_obaacti FROM oba_file
              WHERE oba01 = g_lmr.lmr01                        #FUN-A60010
             IF l_n = 0 THEN
                CALL cl_err('','alm-845',1)                    #FUN-A60010
                LET g_lmr.lmr01 = g_lmr01_t
                NEXT FIELD lmr01
             ELSE
#               IF l_lmk05='N' THEN                          #FUN-A60010
                IF l_obaacti ='N' THEN                       #FUN-A60010
                  CALL cl_err('lmr01:','9028',1)
                  LET g_lmr.lmr01 = g_lmr01_t
                  NEXT FIELD lmr01
               ELSE 
               	  SELECT  COUNT(*) INTO l_n1 FROM lmr_file 
               	   WHERE lmr01=g_lmr.lmr01
               	   IF l_n1>0 THEN 
               	      CALL cl_err('','-239',1)
               	      LET g_lmr.lmr01 = g_lmr01_t
               	      NEXT FIELD lmr01
               	   END IF
               END IF
             END IF
           END IF 
#           CALL i250_lmk02()            #FUN-A60010
            CALL i250_oba02()            #FUN-A60010
          END IF 
 
       AFTER FIELD lmr02
          IF g_lmr.lmr02 IS NOT NULL THEN
            IF p_cmd = "a" OR                    # □懷□麼載蜊й蜊KEY
               (p_cmd = "u" AND g_lmr.lmr02 != g_lmr_t.lmr02) THEN
             SELECT COUNT(*) INTO l_n FROM lmr_file 
              WHERE lmr02 = g_lmr.lmr02
             IF l_n > 0 THEN
                CALL cl_err('',-239,1)
                LET g_lmr.lmr02=g_lmr_t.lmr02
                NEXT FIELD lmr02
             END IF
            END IF
          END IF
 
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         IF g_lmr.lmr01 IS NULL OR g_lmr.lmr02 IS NULL  THEN
            DISPLAY BY NAME g_lmr.lmr01
            LET l_input='Y'
          END IF
          IF l_input='Y' THEN
             NEXT FIELD lmr01
          END IF
 
      ON ACTION CONTROLO                        # 朓蚚垀衄戲弇
         IF INFIELD(lmr01) THEN
            LET g_lmr.* = g_lmr_t.*
            CALL i250_show()
            NEXT FIELD lmr01
         END IF
 
     ON ACTION controlp
        CASE
           WHEN INFIELD(lmr01)
              CALL cl_init_qry_var()
#modify by hellen --090608 begin
#             LET g_qryparam.form = "q_lmk"
              LET g_qryparam.form = "q_oba_10"          #FUN-A60010
#modify by hellen --090608 end
              LET g_qryparam.default1 = g_lmr.lmr01
              CALL cl_create_qry() RETURNING g_lmr.lmr01
              DISPLAY BY NAME g_lmr.lmr01
#              CALL i250_lmk02()              #FUN-A60010
             CALL i250_oba02()                #FUN-A60010
              NEXT FIELD lmr01
           WHEN INFIELD(lmr02)
           CALL s_color(g_lmr.lmr02) RETURNING g_lmr.lmr02
           CALL cl_chg_comp_att('lmr02','color',g_lmr.lmr02) 
           DISPLAY BY NAME g_lmr.lmr02
           OTHERWISE
              EXIT CASE
        END CASE
 
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                        # 戲弇佽隴
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 250913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()     
 
      ON ACTION help          
         CALL cl_show_help() 
 
   END INPUT
END FUNCTION
#FUN-A60010--------------mark------------------------ 
#FUNCTION i250_lmk02()
#DEFINE
#   l_lmk02    LIKE lmk_file.lmk02
 
#   SELECT lmk02
#     INTO l_lmk02
#    FROM lmk_file
#    WHERE lmk01=g_lmr.lmr01
 
#    DISPLAY l_lmk02 TO FORMONLY.lmk02
 
 
#END FUNCTION
#FUN-A60010----------------------mark----------------------
#FUN-A60010--------------------START------------------------
FUNCTION i250_oba02()
DEFINE
   l_oba02     LIKE oba_file.oba02

   SELECT oba02
     INTO l_oba02
     FROM oba_file
    WHERE oba01=g_lmr.lmr01  

    DISPLAY l_oba02 TO FORMONLY.oba02
END FUNCTION
#FUN-A60010----------------------------------END-------------------- 
FUNCTION i250_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)
   MESSAGE ""
   CALL cl_opmsg('q')
   DISPLAY '   ' TO FORMONLY.cnt
   CALL i250_curs()                      # 哫豢 SCROLL CURSOR
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLEAR FORM
      RETURN
   END IF
   OPEN i250_count
   FETCH i250_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
   OPEN i250_cs                          # 植DB莉汜磁綱沭璃TEMP(0-30鏃)
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lmr.lmr01,SQLCA.sqlcode,0)
      INITIALIZE g_lmr.* TO NULL
   ELSE
      CALL i250_fetch('F')              # 黍堤TEMP菴珨捩甜珆尨
   END IF
END FUNCTION
 
FUNCTION i250_fetch(p_fllmr)
   DEFINE   p_fllmr          VARCHAR(1)
 
   CASE p_fllmr
      WHEN 'N' FETCH NEXT     i250_cs INTO g_lmr.lmr01
      WHEN 'P' FETCH PREVIOUS i250_cs INTO g_lmr.lmr01
      WHEN 'F' FETCH FIRST    i250_cs INTO g_lmr.lmr01
      WHEN 'L' FETCH LAST     i250_cs INTO g_lmr.lmr01
      WHEN '/'
         IF (NOT g_no_ask) THEN         
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  
            PROMPT g_msg CLIPPED,': ' FOR g_jump
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
 
               ON ACTION about        
                  CALL cl_about()   
 
               ON ACTION help         
                  CALL cl_show_help() 
 
               ON ACTION controlg     
                  CALL cl_cmdask()    
 
            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump i250_cs INTO g_lmr.lmr01
         LET g_no_ask = FALSE      
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lmr.lmr01,SQLCA.sqlcode,0)
      RETURN
   ELSE
      CASE p_fllmr
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      CALL cl_navigator_setting(g_curs_index, g_row_count)
   END IF
 
   SELECT * INTO g_lmr.* FROM lmr_file    # 笭黍DB,秪TEMP衄祥掩載陔杻俶
    WHERE lmr01 = g_lmr.lmr01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","lmr_file",g_lmr.lmr01,"",SQLCA.sqlcode,"","",0) 
   ELSE
      CALL i250_show()                   # 笭陔珆尨
   END IF
END FUNCTION
 
FUNCTION i250_show()
   DEFINE l_color  VARCHAR(10)
   LET g_lmr_t.* = g_lmr.*
   DISPLAY BY NAME g_lmr.lmr01,g_lmr.lmr02,g_lmr.lmr03,g_lmr.lmruser,g_lmr.lmrmodu,
                   g_lmr.lmrgrup,g_lmr.lmrdate,g_lmr.lmracti,g_lmr.lmrcrat
                  ,g_lmr.lmroriu,g_lmr.lmrorig                      #TQC-B20116       
   
   CASE
      WHEN g_lmr.lmr02 = '0'
         LET l_color = 'blue'
      WHEN g_lmr.lmr02 = '1'
         LET l_color = 'cyan'
      WHEN g_lmr.lmr02 = '2'
         LET l_color = 'green'
      WHEN g_lmr.lmr02 = '3'
         LET l_color = 'magenta'
      WHEN g_lmr.lmr02 = '4'
         LET l_color = 'red'
      WHEN g_lmr.lmr02 = '5'
         LET l_color = 'white'
      WHEN g_lmr.lmr02 = '6'
         LET l_color = 'yellow'
   END CASE
   CALL cl_chg_comp_att('lmr02','color',g_lmr.lmr02) 
#   CALL i250_lmk02()                  #FUN-A60010
    CALL i250_oba02()                  #FUN-A60010
   CALL cl_show_fld_cont()               
END FUNCTION
 
FUNCTION i250_u()
DEFINE l_where      VARCHAR(1000)  
DEFINE l_flag       VARCHAR(1)   
   IF g_lmr.lmr01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_lmr.* FROM lmr_file 
    WHERE lmr01=g_lmr.lmr01
    
   IF g_lmr.lmracti = 'N' THEN
       CALL cl_err('',9027,1) 
       RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_lmr01_t = g_lmr.lmr01
   BEGIN WORK
 
   OPEN i250_cl USING g_lmr01_t
   IF STATUS THEN
       CALL cl_err("OPEN i250_cl:", STATUS, 1)
       CLOSE i250_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i250_cl INTO g_lmr.*               # 勤DB坶隅
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lmr.lmr01,SQLCA.sqlcode,1)
       RETURN
    END IF
 
    CALL i250_show()                          # 珆尨郔陔訧蹋
    LET g_lmr.lmrmodu=g_user                  
    LET g_lmr.lmrdate = g_today    
    WHILE TRUE
       CALL i250_i("u")                      # 戲弇載蜊
       IF INT_FLAG THEN
          LET INT_FLAG = 0
          LET g_lmr.*=g_lmr_t.*
          CALL i250_show()
          CALL cl_err('',9001,0)
          EXIT WHILE
       END IF
        
       UPDATE lmr_file SET lmr_file.* = g_lmr.*    # 載陔DB
        WHERE lmr01 = g_lmr01_t
       IF SQLCA.sqlcode THEN
          CALL cl_err3("upd","lmr_file",g_lmr.lmr01,"",SQLCA.sqlcode,"","",0) 
          CONTINUE WHILE
       END IF
       EXIT WHILE
    END WHILE
    CLOSE i250_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i250_x()
    IF g_lmr.lmr01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i250_cl USING g_lmr.lmr01
    IF STATUS THEN
       CALL cl_err("OPEN i250_cl:", STATUS, 1)
       CLOSE i250_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i250_cl INTO g_lmr.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lmr.lmr01,SQLCA.sqlcode,1)
       RETURN
    END IF
    LET g_lmr.lmrmodu=g_user                  
    LET g_lmr.lmrdate = g_today
    CALL i250_show()
    IF cl_exp(0,0,g_lmr.lmracti) THEN
        LET g_chr=g_lmr.lmracti
        IF g_lmr.lmracti='Y' THEN
            LET g_lmr.lmracti='N'
            LET g_lmr.lmrmodu=g_user
            LET g_lmr.lmrdate=g_today            
        ELSE
            LET g_lmr.lmracti='Y'
            LET g_lmr.lmrmodu=g_user
            LET g_lmr.lmrdate=g_today            
        END IF
        UPDATE lmr_file
            SET lmracti=g_lmr.lmracti,
                lmrmodu=g_lmr.lmrmodu,
                lmrdate=g_lmr.lmrdate
            WHERE lmr01=g_lmr.lmr01
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(g_lmr.lmr01,SQLCA.sqlcode,0)
            LET g_lmr.lmracti=g_chr
        END IF
        DISPLAY BY NAME g_lmr.lmracti,g_lmr.lmrmodu,g_lmr.lmrdate
    END IF
    CLOSE i250_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i250_r()
DEFINE l_where      VARCHAR(1000)  
DEFINE l_flag       VARCHAR(1)      
   IF g_lmr.lmr01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF g_lmr.lmracti = 'N' THEN
       CALL cl_err('','alm-147',1) 
       RETURN
   END IF   
   LET g_lmr01_t=g_lmr.lmr01
   BEGIN WORK
 
   OPEN i250_cl USING g_lmr01_t
   IF STATUS THEN
      CALL cl_err("OPEN i250_cl:", STATUS, 0)
      CLOSE i250_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i250_cl INTO g_lmr.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lmr.lmr01,SQLCA.sqlcode,0)
      RETURN
   END IF
   CALL i250_show()
   IF cl_delete() THEN
      DELETE FROM lmr_file 
       WHERE lmr01 = g_lmr01_t
 
      CLEAR FORM
      OPEN i250_count
      FETCH i250_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i250_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i250_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE       
         CALL i250_fetch('/')
      END IF
   END IF
   CLOSE i250_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION i250_set_entry(p_cmd)
   DEFINE   p_cmd     VARCHAR(1)
 
   IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("lmr01",TRUE)
   END IF
END FUNCTION
 
FUNCTION i250_set_no_entry(p_cmd)
   DEFINE   p_cmd     VARCHAR(1)
 
   IF p_cmd  = 'u' AND g_chkey = 'N' THEN
      CALL cl_set_comp_entry("lmr01",FALSE)
   END IF
 
END FUNCTION
 
