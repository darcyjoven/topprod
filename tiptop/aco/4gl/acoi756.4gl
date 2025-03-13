# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: acoi756.4gl
# Descriptions...: 海關商品編號資料維護作業
# Date & Author..: FUN-930151 09/04/01 BY rainy 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/10 By destiny display xxx.*改為display對應欄位
# Modify.........: No:TQC-9A0118 09/10/23 By liuxqa 替换ROWID
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50062 11/05/18 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_ceg   RECORD LIKE ceg_file.*,		
    g_ceg_t RECORD LIKE ceg_file.*,	
    g_ceg01_t           LIKE ceg_file.ceg01,
    g_ceg00_t           LIKE ceg_file.ceg00, 
    g_wc,g_sql          STRING 
 
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE  SQL 
DEFINE   g_before_input_done   STRING     
DEFINE   g_chr           LIKE type_file.chr1    
DEFINE   g_cnt           LIKE type_file.num10  
DEFINE   g_i             LIKE type_file.num5  #count/index for any purpose 
DEFINE   g_msg           LIKE type_file.chr1000  
DEFINE   g_row_count     LIKE type_file.num10    
DEFINE   g_curs_index    LIKE type_file.num10 
DEFINE   g_jump          LIKE type_file.num10
DEFINE   g_no_ask       LIKE type_file.num5  
DEFINE   g_str           STRING              
 
MAIN
   OPTIONS					
       INPUT NO WRAP
   DEFER INTERRUPT				
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ACO")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   INITIALIZE g_ceg.* TO NULL
   INITIALIZE g_ceg_t.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM ceg_file WHERE ceg00 = ? AND ceg01 = ?  FOR UPDATE "   #wujie 091019
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i756_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
   OPEN WINDOW i756_w WITH FORM "aco/42f/acoi756"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()
 
   LET g_action_choice=""
   CALL i756_menu()
 
   CLOSE WINDOW i756_w

   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
 
FUNCTION i756_cs()
    CLEAR FORM
    INITIALIZE g_ceg.* TO NULL    
    CONSTRUCT BY NAME g_wc ON ceg00,ceg01,
                              ceg03,ceg04,ceg05,ceg06,
                              ceg07,ceg08,ceg09,ceg10,
                              ceg11,ceg12,ceg13,ceg14,
                              ceg02,
                              ceguser,cegmodu,cegacti,
                              ceggrup,cegdate
 
            BEFORE CONSTRUCT
               CALL cl_qbe_init()
 
            ON ACTION controlp
               CASE
                 WHEN INFIELD(ceg01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = 'c'
                    LET g_qryparam.form = "q_ceg01"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ceg01
                    NEXT FIELD ceg01
                 WHEN INFIELD(ceg08)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = 'c'
                    LET g_qryparam.form = "q_gfe"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ceg08
                    NEXT FIELD ceg08
                 WHEN INFIELD(ceg09)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = 'c'
                    LET g_qryparam.form = "q_cev01"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ceg09
                    NEXT FIELD ceg09
                 WHEN INFIELD(ceg10)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = 'c'
                    LET g_qryparam.form = "q_cea01"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ceg10
                    NEXT FIELD ceg10
                 WHEN INFIELD(ceg11)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = 'c'
                    LET g_qryparam.form = "q_gfe"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ceg11
                    NEXT FIELD ceg11
                 WHEN INFIELD(ceg13)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = 'c'
                    LET g_qryparam.form = "q_gfe"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ceg13
                    NEXT FIELD ceg13
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
 
            ON ACTION qbe_select
               CALL cl_qbe_select()
 
            ON ACTION qbe_save
	       CALL cl_qbe_save()
 
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           
    #        LET g_wc = g_wc clipped," AND ceguser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                          
    #        LET g_wc = g_wc clipped," AND ceggrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN   
    #        LET g_wc = g_wc clipped," AND ceggrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ceguser', 'ceggrup')
    #End:FUN-980030
 
    LET g_sql = "SELECT ",   #wujie 0911019
                "       ceg01, ",
                "       ceg00 FROM ceg_file ", 
                " WHERE ",g_wc CLIPPED," ORDER BY ceg00,ceg01"
    PREPARE i756_prepare FROM g_sql         
    DECLARE i756_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i756_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM ceg_file WHERE ",g_wc CLIPPED
    PREPARE i756_precount FROM g_sql
    DECLARE i756_count CURSOR FOR i756_precount
END FUNCTION
 
 
FUNCTION i756_menu()
 
    MENU ""
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i756_a()
            END IF
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i756_q()
            END IF
 
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i756_u()
            END IF
 
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL i756_x()
            END IF
 
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i756_r()
            END IF
 
        ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                 CALL i756_copy()
            END IF
            
        ON ACTION uprate   #更改退稅率
           LET g_action_choice="uprate"
           IF cl_chk_act_auth() THEN
              CALL i756_uprate()  
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
            CALL i756_fetch('/')
        ON ACTION first
            CALL i756_fetch('F')
        ON ACTION last
            CALL i756_fetch('L')
        ON ACTION next
            CALL i756_fetch('N')
        ON ACTION previous
            CALL i756_fetch('P')
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         
           CALL cl_about()   
 
        ON ACTION related_document  
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
               IF g_ceg.ceg01 IS NOT NULL THEN
                  LET g_doc.column1 = "ceg01"
                  LET g_doc.value1 = g_ceg.ceg01
                  CALL cl_doc()
               END IF
           END IF
 
           LET g_action_choice = "exit"
           CONTINUE MENU
 
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		
            LET g_action_choice = "exit"
            EXIT MENU
    END MENU
    CLOSE i756_cs
END FUNCTION
 
 
FUNCTION i756_a()
    IF s_shut(0) THEN RETURN END IF              
    MESSAGE ""
    CLEAR FORM                                  
    INITIALIZE g_ceg.* LIKE ceg_file.*
    LET g_ceg01_t = NULL
    LET g_ceg00_t = NULL  
    LET g_ceg_t.*=g_ceg.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_ceg.ceg03 = 0
        LET g_ceg.ceg04 = 0
        LET g_ceg.ceg05 = 0
        LET g_ceg.ceg06 = 0
        LET g_ceg.ceg07 = 0
        LET g_ceg.cegacti = 'Y'                
        LET g_ceg.ceguser = g_user	
        LET g_ceg.ceggrup = g_grup     
        LET g_ceg.cegdate = g_today
        LET g_ceg.ceg12 = 1
        LET g_ceg.ceg14 = 1
 
        CALL i756_i("a")                  
        IF INT_FLAG THEN                 
            INITIALIZE g_ceg.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF cl_null(g_ceg.ceg01) OR cl_null(g_ceg.ceg00) THEN   
            CONTINUE WHILE
        END IF
        LET g_ceg.cegoriu = g_user      #No.FUN-980030 10/01/04
        LET g_ceg.cegorig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO ceg_file VALUES(g_ceg.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","ceg_file",g_ceg.ceg00,g_ceg.ceg01,SQLCA.sqlcode,"","",1)  
             CONTINUE WHILE
        ELSE
            LET g_ceg_t.* = g_ceg.*  
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
 
FUNCTION i756_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,          
        l_flag          LIKE type_file.chr1,  		
        l_n             LIKE type_file.num5          
    
    #No.FUN-9A0024--begin 
    DISPLAY BY NAME g_ceg.*
    DISPLAY BY NAME g_ceg.ceg00,g_ceg.ceg01,
                    g_ceg.ceg02,g_ceg.ceg03,                                                                                        
                    g_ceg.ceg04,g_ceg.ceg05,                                                                                        
                    g_ceg.ceg06,g_ceg.ceg07,g_ceg.ceg08,                                                                            
                    g_ceg.ceg09,g_ceg.ceg10,                                                                                        
                    g_ceg.ceg11,g_ceg.ceg12,                                                                                        
                    g_ceg.ceg13,g_ceg.ceg14,                                                                                        
                    g_ceg.ceguser,g_ceg.ceggrup,g_ceg.cegdate,                                                                      
                    g_ceg.cegacti,g_ceg.cegmodu
    #No.FUN-9A0024--end 
    INPUT BY NAME  g_ceg.ceg00,g_ceg.ceg01,
                   g_ceg.ceg03,g_ceg.ceg04,
                   g_ceg.ceg05,g_ceg.ceg06,
                   g_ceg.ceg07,g_ceg.ceg08,
                   g_ceg.ceg09,g_ceg.ceg10,
                   g_ceg.ceg11,g_ceg.ceg12,
                   g_ceg.ceg13,g_ceg.ceg14,
                   g_ceg.ceg02
        
        WITHOUT DEFAULTS
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i756_set_entry(p_cmd)
           CALL i756_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
 
        AFTER FIELD ceg01			 
          IF NOT cl_null(g_ceg.ceg01) 
             AND NOT cl_null(g_ceg.ceg01) THEN
            IF p_cmd = "a" OR                    
              (p_cmd = "u" AND g_ceg.ceg01 != g_ceg01_t) THEN
                SELECT count(*) INTO l_n FROM ceg_file
                    WHERE ceg01 = g_ceg.ceg01
                      AND ceg00 = g_ceg.ceg00
                IF l_n > 0 THEN                  # Duplicated
                    CALL cl_err(g_ceg.ceg01,-239,0)
                    LET g_ceg.ceg01 = g_ceg01_t
                    DISPLAY BY NAME g_ceg.ceg01
                    NEXT FIELD ceg01
                END IF
            END IF
          END IF
         
        AFTER FIELD ceg03
          IF g_ceg.ceg03 < 0 THEN
             CALL cl_err('','aim-391',1)
             NEXT FIELD ceg03
          END IF
 
        AFTER FIELD ceg04
          IF g_ceg.ceg04 < 0 THEN
             CALL cl_err('','aim-391',1)
             NEXT FIELD ceg04
          END IF
 
        AFTER FIELD ceg05
          IF g_ceg.ceg05 < 0 THEN
             CALL cl_err('','aim-391',1)
             NEXT FIELD ceg05
          END IF
 
        AFTER FIELD ceg06
          IF g_ceg.ceg06 < 0 THEN
             CALL cl_err('','aim-391',1)
             NEXT FIELD ceg06
          END IF
 
        AFTER FIELD ceg07
          IF g_ceg.ceg07 < 0 THEN
             CALL cl_err('','aim-391',1)
             NEXT FIELD ceg07
          END IF
        
        AFTER FIELD ceg08  
          IF NOT cl_null(g_ceg.ceg08) THEN
             CALL i756_ceg08('d')
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_ceg.ceg08,g_errno,1)
                NEXT FIELD ceg08
             END IF
          END IF
        
        AFTER FIELD ceg09  
          IF NOT cl_null(g_ceg.ceg09) THEN
             CALL i756_ceg09('d')
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_ceg.ceg09,g_errno,1)
                NEXT FIELD ceg09
             END IF
          END IF
 
        AFTER FIELD ceg10 
          IF NOT cl_null(g_ceg.ceg10) THEN
             CALL i756_ceg10('d')
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_ceg.ceg10,g_errno,1)
                NEXT FIELD ceg10
             END IF
          END IF
 
        AFTER FIELD ceg11  
          IF NOT cl_null(g_ceg.ceg11) THEN
             CALL i756_ceg11('d')
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_ceg.ceg11,g_errno,1)
                NEXT FIELD ceg11
             END IF
          END IF
 
        AFTER FIELD ceg12 
          IF NOT cl_null(g_ceg.ceg12) THEN
             IF NOT cl_null(g_ceg.ceg11) AND g_ceg.ceg12 <= 0 THEN
                CALL cl_err('','mfg9243',0)
                NEXT FIELD ceg12
             END IF
          END IF
 
        AFTER FIELD ceg13  
          IF NOT cl_null(g_ceg.ceg13) THEN
             CALL i756_ceg13('d')
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_ceg.ceg13,g_errno,1)
                NEXT FIELD ceg13
             END IF
          END IF
 
        AFTER FIELD ceg14 
          IF NOT cl_null(g_ceg.ceg14) THEN
             IF NOT cl_null(g_ceg.ceg13) AND g_ceg.ceg14 <= 0 THEN
                CALL cl_err('','mfg9243',0)
                NEXT FIELD ceg14
             END IF
          END IF
 
        AFTER INPUT  
           LET l_flag='N'
           IF INT_FLAG THEN EXIT INPUT  END IF
              IF p_cmd = "a" OR          
                (p_cmd = "u" AND (g_ceg.ceg01 != g_ceg01_t) 
                                  OR g_ceg.ceg00 != g_ceg00_t) THEN
                  SELECT count(*) INTO l_n FROM ceg_file
                      WHERE ceg01 = g_ceg.ceg01
                        AND ceg00 = g_ceg.ceg00
                  IF l_n > 0 THEN                  # KEY值重覆
                      CALL cl_err(g_ceg.ceg01,-239,0)
                      LET g_ceg.ceg00 = g_ceg00_t
                      LET g_ceg.ceg01 = g_ceg01_t
                      DISPLAY BY NAME g_ceg.ceg00
                      DISPLAY BY NAME g_ceg.ceg01
                      NEXT FIELD ceg00
                  END IF
              END IF
              IF cl_null(g_ceg.ceg01) THEN  
                  LET l_flag='Y'
                  DISPLAY BY NAME g_ceg.ceg01
              END IF
              IF cl_null(g_ceg.ceg03) THEN #
                 CALL cl_err('','9033',0)
                 NEXT FIELD ceg03
              END IF
              IF cl_null(g_ceg.ceg04) THEN
                 CALL cl_err('','9033',0)
                 NEXT FIELD ceg04
              END IF
              IF cl_null(g_ceg.ceg05) THEN
                 CALL cl_err('','9033',0)
                 NEXT FIELD ceg05
              END IF
              IF cl_null(g_ceg.ceg06) THEN
                 CALL cl_err('','9033',0)
                 NEXT FIELD ceg06
              END IF
              IF cl_null(g_ceg.ceg07) THEN
                 CALL cl_err('','9033',0)
                 NEXT FIELD ceg07
              END IF          
              IF NOT cl_null(g_ceg.ceg11) AND g_ceg.ceg12 <= 0 THEN
                 CALL cl_err('','mfg9243',0)
                 NEXT FIELD ceg12
              END IF
              IF NOT cl_null(g_ceg.ceg13) AND g_ceg.ceg14 <= 0 THEN
                 CALL cl_err('','mfg9243',0)
                 NEXT FIELD ceg14
              END IF
              IF l_flag='Y' THEN
                 CALL cl_err('','9033',0)
                 NEXT FIELD ceg01
              END IF
 
          ON ACTION controlp
             CASE
                WHEN INFIELD(ceg08)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gfe"
                   LET g_qryparam.default1 = g_ceg.ceg08
                   CALL cl_create_qry() RETURNING g_ceg.ceg08
                   DISPLAY BY NAME g_ceg.ceg08
                   CALL i756_ceg08('d')
                WHEN INFIELD(ceg09)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_cev01"    
                   LET g_qryparam.default1 = g_ceg.ceg09
                   CALL cl_create_qry() RETURNING g_ceg.ceg09
                   DISPLAY BY NAME g_ceg.ceg09
                   CALL i756_ceg09('d')
                WHEN INFIELD(ceg10)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_cea01"
                   LET g_qryparam.default1 = g_ceg.ceg10
                   CALL cl_create_qry() RETURNING g_ceg.ceg10
                   DISPLAY BY NAME g_ceg.ceg10
                   CALL i756_ceg10('d')
                WHEN INFIELD(ceg11)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gfe"
                   LET g_qryparam.default1 = g_ceg.ceg11
                   CALL cl_create_qry() RETURNING g_ceg.ceg11
                   DISPLAY BY NAME g_ceg.ceg11
                   CALL i756_ceg11('d')
                WHEN INFIELD(ceg13)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gfe"
                   LET g_qryparam.default1 = g_ceg.ceg13
                   CALL cl_create_qry() RETURNING g_ceg.ceg13
                   DISPLAY BY NAME g_ceg.ceg13
                   CALL i756_ceg13('d')
             END CASE
           
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
       ON ACTION CONTROLF         
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
       ON ACTION CONTROLG
          CALL cl_cmdask()
       ON ACTION about        
          CALL cl_about()    
       ON ACTION help         
          CALL cl_show_help()  
    END INPUT
END FUNCTION
 
 
FUNCTION i756_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_ceg.* TO NULL             
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i756_cs()                          #SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        INITIALIZE g_ceg.* TO NULL
        RETURN
    END IF
    OPEN i756_count
    FETCH i756_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i756_cs                            
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ceg.ceg01,SQLCA.sqlcode,0)
        INITIALIZE g_ceg.* TO NULL
    ELSE
        CALL i756_fetch('F')                  
    END IF
END FUNCTION
 
 
FUNCTION i756_fetch(p_flceg)
    DEFINE
        p_flceg         LIKE type_file.chr1         
 
    CASE p_flceg
        WHEN 'N' FETCH NEXT     i756_cs INTO g_ceg.ceg01  #wujie 091019
                                            ,g_ceg.ceg00
        WHEN 'P' FETCH PREVIOUS i756_cs INTO g_ceg.ceg01  #wujie 091019
                                            ,g_ceg.ceg00
        WHEN 'F' FETCH FIRST    i756_cs INTO g_ceg.ceg01  #wujie 091019
                                            ,g_ceg.ceg00
        WHEN 'L' FETCH LAST     i756_cs INTO  g_ceg.ceg01  #wujie 091019
                                            ,g_ceg.ceg00
        WHEN '/'
          IF (NOT g_no_ask) THEN
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
             LET INT_FLAG = 0  
             PROMPT g_msg CLIPPED,': ' FOR g_jump #CKP3
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
          FETCH ABSOLUTE g_jump i756_cs INTO g_ceg.ceg01     #wujie 091019
                                            ,g_ceg.ceg00
          LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        LET g_msg = g_ceg.ceg01 CLIPPED
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        INITIALIZE g_ceg.* TO NULL 
        LET g_ceg.ceg00 = NULL
        LET g_ceg.ceg01 = NULL
        RETURN
    ELSE
       CASE p_flceg
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump 
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_ceg.* FROM ceg_file       
     WHERE ceg00 = g_ceg.ceg00
       AND ceg01 = g_ceg.ceg01
    IF SQLCA.sqlcode THEN
        LET g_msg = g_ceg.ceg01 CLIPPED
         CALL cl_err3("sel","ceg_file",g_msg,"",SQLCA.sqlcode,"","",1)
    ELSE
        CALL i756_show()                      
    END IF
END FUNCTION
 
 
FUNCTION i756_show()
    LET g_ceg_t.* = g_ceg.*
    DISPLAY BY NAME g_ceg.ceg00,g_ceg.ceg01,
                    g_ceg.ceg02,g_ceg.ceg03,
                    g_ceg.ceg04,g_ceg.ceg05,
                    g_ceg.ceg06,g_ceg.ceg07,g_ceg.ceg08,
                    g_ceg.ceg09,g_ceg.ceg10,
                    g_ceg.ceg11,g_ceg.ceg12,
                    g_ceg.ceg13,g_ceg.ceg14,
                    g_ceg.ceguser,g_ceg.ceggrup,g_ceg.cegdate,
                    g_ceg.cegacti,g_ceg.cegmodu
 
    CALL i756_ceg08('d')
    CALL i756_ceg09('d')
    CALL i756_ceg10('d')
    CALL i756_ceg11('d')
    CALL i756_ceg13('d')
    CALL cl_show_fld_cont()                
END FUNCTION
 
 
FUNCTION i756_u()
    IF s_shut(0) THEN RETURN END IF             
    IF cl_null(g_ceg.ceg01) OR cl_null(g_ceg.ceg00) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_ceg.cegacti ='N' THEN                 
        CALL cl_err(g_ceg.ceg01,'mfg1000',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_ceg01_t = g_ceg.ceg01
    LET g_ceg00_t = g_ceg.ceg00
    BEGIN WORK
 
    OPEN i756_cl USING g_ceg.ceg00,g_ceg.ceg01    #wujie 091019
    IF STATUS THEN
       CALL cl_err("OPEN i756_cl:", STATUS, 1)
       CLOSE i756_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i756_cl INTO g_ceg.*              
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ceg.ceg01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_ceg.cegmodu = g_user                
    LET g_ceg.cegdate = g_today               
    CALL i756_show()                          
 
    WHILE TRUE
        CALL i756_i("u")                      
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_ceg.* = g_ceg_t.*
            CALL i756_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE ceg_file SET ceg_file.* = g_ceg.*    
         WHERE ceg00 = g_ceg.ceg00
           AND ceg01 = g_ceg.ceg01
        IF SQLCA.sqlcode THEN
           LET g_msg = g_ceg.ceg00,g_ceg.ceg01 CLIPPED
            CALL cl_err3("upd","ceg_file",g_msg,"",SQLCA.sqlcode,"","",1)     
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i756_cl
    COMMIT WORK
END FUNCTION
 
 
FUNCTION i756_x()
 
    IF s_shut(0) THEN RETURN END IF              
    IF cl_null(g_ceg.ceg01) OR cl_null(g_ceg.ceg00) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i756_cl USING g_ceg.ceg00,g_ceg.ceg01    #wujie 091019
    IF STATUS THEN
       CALL cl_err("OPEN i756_cl:", STATUS, 1)
       CLOSE i756_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i756_cl INTO g_ceg.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ceg.ceg01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i756_show()
    IF cl_exp(0,0,g_ceg.cegacti) THEN
        LET g_chr = g_ceg.cegacti
        IF g_ceg.cegacti = 'Y' THEN
           LET g_ceg.cegacti = 'N'
        ELSE
           LET g_ceg.cegacti = 'Y'
        END IF
        UPDATE ceg_file
            SET cegacti = g_ceg.cegacti,
                cegmodu = g_user, cegdate = g_today
            WHERE ceg00 = g_ceg.ceg00
              AND ceg01 = g_ceg.ceg01
        IF SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err3("upd","ceg_file",g_ceg.ceg01,g_ceg.ceg00,SQLCA.sqlcode,"","",1)  
            LET g_ceg.cegacti = g_chr
        END IF
        DISPLAY BY NAME g_ceg.cegacti
    END IF
    CLOSE i756_cl
    COMMIT WORK
END FUNCTION
 
 
FUNCTION i756_r()
 
    IF s_shut(0) THEN RETURN END IF      
    IF cl_null(g_ceg.ceg01) OR cl_null(g_ceg.ceg00) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i756_cl USING g_ceg.ceg00,g_ceg.ceg01    #wujie 091019
    IF STATUS THEN
       CALL cl_err("OPEN i756_cl:", STATUS, 1)
       CLOSE i756_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i756_cl INTO g_ceg.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ceg.ceg01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i756_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "ceg01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_ceg.ceg01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM ceg_file WHERE ceg00 = g_ceg.ceg00 AND ceg01 =g_ceg.ceg01   #wujie 091019
       CLEAR FORM
         OPEN i756_count
         #FUN-B50062-add-start--
         IF STATUS THEN
            CLOSE i756_cs
            CLOSE i756_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         FETCH i756_count INTO g_row_count
         #FUN-B50062-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i756_cs
            CLOSE i756_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i756_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i756_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE
            CALL i756_fetch('/')
         END IF
    END IF
    CLOSE i756_cl
    COMMIT WORK
END FUNCTION
 
 
FUNCTION i756_copy()
    DEFINE
        l_n             LIKE type_file.num5,         
        l_newno,l_oldno LIKE ceg_file.ceg01,
        l_newno2,l_oldno2 LIKE ceg_file.ceg00
 
    IF s_shut(0) THEN RETURN END IF                
    IF cl_null(g_ceg.ceg01) OR cl_null(g_ceg.ceg00) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
    LET g_before_input_done = FALSE
    CALL i756_set_entry("a")
    CALL i756_set_no_entry("a")
    LET g_before_input_done = TRUE
 
    INPUT l_newno2,l_newno FROM ceg00,ceg01
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i756_set_entry("a")
           CALL i756_set_no_entry("a")
           LET g_before_input_done = TRUE
 
        AFTER FIELD ceg01
          IF NOT cl_null(l_newno) AND NOT cl_null(l_newno2) THEN
            SELECT count(*) INTO g_cnt FROM ceg_file
                WHERE ceg01 = l_newno
                  AND ceg00 = l_newno2
            IF g_cnt > 0 THEN
                CALL cl_err(l_newno,-239,0)
                NEXT FIELD ceg01
            END IF
          END IF
 
        AFTER INPUT
           LET g_cnt = 0
           SELECT COUNT(*) INTO g_cnt
             FROM ceg_file
            WHERE ceg01 = l_newno
              AND ceg00 = l_newno2
           IF g_cnt > 0 THEN
               CALL cl_err(l_newno,-239,0)
               NEXT FIELD ceg00
           END IF
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
       ON ACTION about         
          CALL cl_about()      
       ON ACTION help          
          CALL cl_show_help()  
       ON ACTION controlg      
          CALL cl_cmdask()     
    END INPUT
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_ceg.ceg01
        DISPLAY BY NAME g_ceg.ceg00
        RETURN
    END IF
    DROP TABLE x
    SELECT * FROM ceg_file
        WHERE ceg00 = g_ceg.ceg00 AND ceg01 = g_ceg.ceg01   #No.TQC-9A0118 mod
        INTO TEMP x
    UPDATE x
        SET ceg01   = l_newno,    
            ceg00   = l_newno2,   
            ceguser = g_user,     
            ceggrup = g_grup,    
            cegmodu = NULL,       
            cegdate = g_today,    
            cegacti = 'Y'          
    INSERT INTO ceg_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","ceg_file",g_ceg.ceg00,g_ceg.ceg01,SQLCA.sqlcode,"","",1)  
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K'
        LET l_oldno = g_ceg.ceg01
        SELECT ceg_file.* INTO g_ceg.* FROM ceg_file     #wujie 091019
         WHERE ceg01 = l_newno
           AND ceg00 = l_newno2
        CALL i756_u()
        #FUN-C30027---begin
        #SELECT ceg_file.* INTO g_ceg.* FROM ceg_file     #wujie 091019
        #               WHERE ceg01 = l_oldno
        #                 AND ceg00 = l_oldno2
        #FUN-C30027---end
    END IF
    CALL i756_show()
END FUNCTION
 
 
FUNCTION i756_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("ceg00,ceg01",TRUE)
   END IF
END FUNCTION
 
FUNCTION i756_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1        
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("ceg00,ceg01",FALSE)
   END IF
   
   IF NOT g_before_input_done THEN
      CALL cl_set_comp_entry("ceg07",FALSE)     
   END IF
END FUNCTION
 
 
FUNCTION i756_uprate()  
  IF NOT cl_Null(g_ceg.ceg01) THEN
      CALL cl_set_comp_entry("ceg07",TRUE)     
 
    INPUT BY NAME g_ceg.ceg07  WITHOUT DEFAULTS
      AFTER FIELD ceg07
         IF cl_null(g_ceg.ceg07) THEN
            CALL cl_err(g_ceg.ceg07,'lib-296',0)
            RETURN  
         END IF              
         DISPLAY BY NAME g_ceg.ceg07          
    END INPUT
    UPDATE ceg_file SET ceg07 = g_ceg.ceg07                      
     WHERE ceg00 = g_ceg.ceg00
       AND ceg01 = g_ceg.ceg01
  END IF   
END FUNCTION        
 
FUNCTION i756_ceg08(p_act)
  DEFINE p_act      LIKE type_file.chr1
  DEFINE l_gfe02    LIKE gfe_file.gfe02,
         l_gfeacti  LIKE gfe_file.gfeacti
 
  LET g_errno = NULL
  LET l_gfe02 = NULL
  LET l_gfeacti = NULL
 
  SELECT gfe02,gfeacti INTO l_gfe02,l_gfeacti
    FROM gfe_file
   WHERE gfe01 = g_ceg.ceg08
  
  CASE WHEN SQLCA.SQLCODE = 100
            LET g_errno = 'aoo-012'
       WHEN l_gfeacti = 'N'
            LET g_errno = '9028'
       OTHERWISE          
            LET g_errno = SQLCA.SQLCODE USING '-------' 
  END CASE
 
  IF p_act = 'd' THEN
    DISPLAY l_gfe02 TO FORMONLY.gfe02
  END IF
END FUNCTION
 
 
FUNCTION i756_ceg11(p_act)
  DEFINE p_act      LIKE type_file.chr1
  DEFINE l_gfe02    LIKE gfe_file.gfe02,
         l_gfeacti  LIKE gfe_file.gfeacti
 
  LET g_errno = NULL
  LET l_gfe02 = NULL
  LET l_gfeacti = NULL
 
  SELECT gfe02,gfeacti INTO l_gfe02,l_gfeacti
    FROM gfe_file
   WHERE gfe01 = g_ceg.ceg11
 
  CASE WHEN SQLCA.SQLCODE = 100
            LET g_errno = 'aoo-012'
       WHEN l_gfeacti = 'N'
            LET g_errno = '9028'
       OTHERWISE          
            LET g_errno = SQLCA.SQLCODE USING '-------' 
  END CASE
 
  IF p_act = 'd' THEN
    DISPLAY l_gfe02 TO FORMONLY.gfe02_1
  END IF
END FUNCTION
 
FUNCTION i756_ceg13(p_act)
  DEFINE p_act      LIKE type_file.chr1
  DEFINE l_gfe02    LIKE gfe_file.gfe02,
         l_gfeacti  LIKE gfe_file.gfeacti
 
  LET g_errno = NULL
  LET l_gfe02 = NULL
  LET l_gfeacti = NULL
 
  SELECT gfe02,gfeacti INTO l_gfe02,l_gfeacti
    FROM gfe_file
   WHERE gfe01 = g_ceg.ceg13
 
  CASE WHEN SQLCA.SQLCODE = 100
            LET g_errno = 'aoo-012'
       WHEN l_gfeacti = 'N'
            LET g_errno = '9028'
       OTHERWISE          
            LET g_errno = SQLCA.SQLCODE USING '-------' 
  END CASE
 
  IF p_act = 'd' THEN
    DISPLAY l_gfe02 TO FORMONLY.gfe02_2
  END IF
END FUNCTION
 
FUNCTION i756_ceg10(p_act)
  DEFINE p_act      LIKE type_file.chr1
  DEFINE l_cea02    LIKE cea_file.cea02,
         l_ceaacti  LIKE cea_file.ceaacti
 
  LET g_errno = NULL
  LET l_cea02 = NULL
  LET l_ceaacti = NULL
 
  SELECT cea02,ceaacti INTO l_cea02,l_ceaacti
    FROM cea_file
   WHERE cea01 = g_ceg.ceg10
 
  CASE WHEN SQLCA.SQLCODE = 100
            LET g_errno = 'aco-700'
       WHEN l_ceaacti = 'N'
            LET g_errno = '9028'
       OTHERWISE          
            LET g_errno = SQLCA.SQLCODE USING '-------' 
  END CASE
  
  IF p_act = 'd' THEN
    DISPLAY l_cea02 TO FORMONLY.cea02
  END IF
END FUNCTION
 
FUNCTION i756_ceg09(p_act)
  DEFINE p_act      LIKE type_file.chr1
  DEFINE l_cev02    LIKE cev_file.cev02,
         l_cevacti  LIKE cev_file.cevacti
  
  LET g_errno = NULL
  LET l_cev02 = NULL
  LET l_cevacti = NULL
 
  SELECT cev02,cevacti INTO l_cev02,l_cevacti
    FROM cev_file
   WHERE cev01 = g_ceg.ceg09
  CASE WHEN SQLCA.SQLCODE = 100
            LET g_errno = 'aco-741'
       WHEN l_cevacti = 'N'
            LET g_errno = '9028'
       OTHERWISE          
            LET g_errno = SQLCA.SQLCODE USING '-------' 
  END CASE
 
  IF p_act = 'd' THEN
    DISPLAY l_cev02 TO FORMONLY.cev02
  END IF
END FUNCTION
 
#FUN-930151
