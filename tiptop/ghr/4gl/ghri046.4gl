# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri046.4gl
# Descriptions...: 
# Date & Author..: 13/05/07 by yougs


DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"

DEFINE  g_hrcf    RECORD LIKE hrcf_file.*
DEFINE  g_hrcf_t  RECORD LIKE hrcf_file.*
DEFINE  g_forupd_sql        STRING
DEFINE  g_before_input_done LIKE type_file.num5
DEFINE  g_wc      STRING
DEFINE  g_sql     STRING
DEFINE g_row_count  LIKE type_file.num5       
DEFINE g_curs_index LIKE type_file.num5
DEFINE g_msg                 LIKE type_file.chr1000
DEFINE g_jump                LIKE type_file.num10
DEFINE g_no_ask             LIKE type_file.num5
DEFINE g_chr                LIKE type_file.chr1
DEFINE g_cnt                LIKE type_file.num5
DEFINE g_argv1              LIKE hrcf_file.hrcf01
DEFINE g_argv2              LIKE hrcf_file.hrcf02
DEFINE g_hrcf01             LIKE hrcf_file.hrcf01
DEFINE g_flag               LIKE type_file.chr1

MAIN
    DEFINE
    p_row,p_col         LIKE type_file.num5      #No.FUN-680123 SMALLINT
    OPTIONS 
          INPUT NO WRAP
    DEFER INTERRUPT 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF
   
   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)

   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   INITIALIZE g_hrcf.* TO NULL

   LET g_forupd_sql = "SELECT * FROM hrcf_file WHERE hrcf01 = ? AND hrcf02 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)        
   DECLARE i046_cl CURSOR FROM g_forupd_sql                 
   
   OPEN WINDOW i046_w AT p_row,p_col 
      WITH FORM "ghr/42f/ghri046"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
   
   CALL cl_ui_init()
   CALL cl_set_label_justify("i046_w","right")

   LET g_action_choice=""
   
   IF NOT cl_null(g_argv1) THEN
      IF cl_null(g_argv2) THEN
        LET g_argv2 = ' '
      END IF  
      LET g_wc=" hrcf01='",g_argv1,"' AND hrcf02 = '",g_argv2,"' "
      CALL i046_q()
   END IF

   CALL i046_menu()
 
   CLOSE WINDOW i046_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION i046_curs()

    CLEAR FORM
    INITIALIZE g_hrcf.* TO NULL
    IF g_argv1 IS NULL THEN
       CONSTRUCT BY NAME g_wc ON                              
           hrcf01,hrcf02,hrcf03,hrcf06,hrcf04,hrcf05,hrcf07,hrcf08,hrcf09,hrcf10,hrcf11,hrcf12,hrcf13,hrcf14,hrcf15,
           hrcf18,hrcf19,hrcf20,hrcf16,hrcf17,hrcf21,hrcf22,hrcf23,hrcf24,hrcf25,hrcf26,hrcf27,hrcf28,hrcf29,
           hrcforiu,hrcforig,hrcfuser,hrcfgrup,hrcfmodu,hrcfdate
       
           BEFORE CONSTRUCT                                    
              CALL cl_qbe_init()                               
       
           ON ACTION controlp
              CASE
                 WHEN INFIELD(hrcf01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_hraa01"
                    LET g_qryparam.state = "c" 
                    LET g_qryparam.construct = 'N'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO hrcf01
                    NEXT FIELD hrcf01
                    
                 WHEN INFIELD(hrcf02)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_hrao01"
                    LET g_qryparam.state = "c" 
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO hrcf02
                    NEXT FIELD hrcf02
                     
                 WHEN INFIELD(hrcf09)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_hrag06"
                    LET g_qryparam.arg1 = '503'
                    LET g_qryparam.where = " hrag07 = '特殊假' "
                    LET g_qryparam.state = "c" 
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO hrcf09
                    NEXT FIELD hrcf09

                 WHEN INFIELD(hrcf20)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_hrag06" 
                    LET g_qryparam.arg1 = '603'
                    LET g_qryparam.state = "c" 
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO hrcf20
                    NEXT FIELD hrcf20
                 
                 WHEN INFIELD(hrcf29)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_hrag06" 
                    LET g_qryparam.arg1 = '519'
                    LET g_qryparam.state = "c" 
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO hrcf29
                    NEXT FIELD hrcf29                     
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
       
         ON ACTION qbe_select                                  
            CALL cl_qbe_select()
       
         ON ACTION qbe_save                                    
            CALL cl_qbe_save()
       END CONSTRUCT
    END IF 
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hrcfuser', 'hrcfgrup')
                                                                     

    LET g_sql = "SELECT hrcf01,hrcf02 FROM hrcf_file ",                     
                " WHERE ",g_wc CLIPPED, " ORDER BY hrcf01"
    PREPARE i046_prepare FROM g_sql
    DECLARE i046_cs                                                  
        SCROLL CURSOR WITH HOLD FOR i046_prepare

    LET g_sql = "SELECT COUNT(DISTINCT hrcf01||hrcf02) FROM hrcf_file WHERE ",g_wc CLIPPED
    PREPARE i046_precount FROM g_sql
    DECLARE i046_count CURSOR FOR i046_precount
END FUNCTION
 
FUNCTION i046_menu()
    DEFINE l_cmd    STRING

    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)

        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i046_a()
            END IF

        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i046_q()
            END IF

        ON ACTION next
            CALL i046_fetch('N')

        ON ACTION previous
            CALL i046_fetch('P')

        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i046_u()
            END IF
 
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i046_r()
            END IF

       ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                 CALL i046_copy()
            END IF

        ON ACTION help
            CALL cl_show_help()

        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU

        ON ACTION jump
            CALL i046_fetch('/')

        ON ACTION first
            CALL i046_fetch('F')

        ON ACTION last
            CALL i046_fetch('L')

        ON ACTION controlg
            CALL cl_cmdask()

        ON ACTION locale
           CALL cl_dynamic_locale() 

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
              IF g_hrcf.hrcf01 IS NOT NULL THEN
                 LET g_doc.column1 = "hrcf01"
                 LET g_doc.value1 = g_hrcf.hrcf01
                 LET g_doc.column2 = "hrcf02"
                 LET g_doc.value2 = g_hrcf.hrcf02
                 CALL cl_doc()
              END IF
           END IF
    END MENU
    CLOSE i046_cs
END FUNCTION


FUNCTION i046_a()

    CLEAR FORM                                   
    INITIALIZE g_hrcf.* LIKE hrcf_file.*
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
      LET g_hrcf.hrcf04 = 'N'
       LET g_hrcf.hrcf05 = 'N'
       LET g_hrcf.hrcf06 = 15
      LET g_hrcf.hrcf07 = 'Y'
      LET g_hrcf.hrcf08 = 20
      LET g_hrcf.hrcf10 = 10
      LET g_hrcf.hrcf11 = 40
      LET g_hrcf.hrcf12 = 20
      LET g_hrcf.hrcf13 = 60
      LET g_hrcf.hrcf14 = 20
      LET g_hrcf.hrcf15 = 80
      LET g_hrcf.hrcf16 = 'N'
      LET g_hrcf.hrcf17 = 'N'
      LET g_hrcf.hrcf19 = 1
      LET g_hrcf.hrcf21 = 'N'
      LET g_hrcf.hrcf22 = 'N'
      LET g_hrcf.hrcf23 = 'Y'
      LET g_hrcf.hrcf24 = 'N'
      LET g_hrcf.hrcf25 = 'Y'
      LET g_hrcf.hrcf26 = 'N'
      LET g_hrcf.hrcf27 = 'N'
      LET g_hrcf.hrcf28 = 'N' 
       LET g_hrcf.hrcforiu = g_user
       LET g_hrcf.hrcforig = g_grup
       LET g_hrcf.hrcfuser = g_user
       LET g_hrcf.hrcfgrup = g_grup             
       LET g_hrcf.hrcfdate = g_today  
       CALL i046_i("a")                         
       IF INT_FLAG THEN                         
          INITIALIZE g_hrcf.* TO NULL
          LET INT_FLAG = 0
          CALL cl_err('',9001,0)
          CLEAR FORM
          EXIT WHILE
       END IF
       IF g_hrcf.hrcf01 IS NULL THEN              
          CONTINUE WHILE
       END IF
       IF cl_null(g_hrcf.hrcf02) THEN
          LET g_hrcf.hrcf02 = ' '
       END IF    
       INSERT INTO hrcf_file VALUES(g_hrcf.*)     
       IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","hrcf_file",g_hrcf.hrcf01,"",SQLCA.sqlcode,"","",0)   
           CONTINUE WHILE 
       END IF
       EXIT WHILE
    END WHILE 
END FUNCTION

FUNCTION i046_i(p_cmd)

   DEFINE p_cmd         LIKE type_file.chr1 
   DEFINE l_n           LIKE type_file.num5
   DEFINE l_hraa12      LIKE hraa_file.hraa12
   DEFINE l_hrao02      LIKE hrao_file.hrao02
   DEFINE l_hrag07      LIKE hrag_file.hrag07  

   DISPLAY BY NAME
           g_hrcf.hrcf01,g_hrcf.hrcf02,g_hrcf.hrcf03,g_hrcf.hrcf06,g_hrcf.hrcf04,g_hrcf.hrcf05,
           g_hrcf.hrcf07,g_hrcf.hrcf08,g_hrcf.hrcf09,g_hrcf.hrcf10,g_hrcf.hrcf11,g_hrcf.hrcf12,
           g_hrcf.hrcf13,g_hrcf.hrcf14,g_hrcf.hrcf15,g_hrcf.hrcf18,g_hrcf.hrcf19,g_hrcf.hrcf20,
           g_hrcf.hrcf16,g_hrcf.hrcf17,g_hrcf.hrcf21,g_hrcf.hrcf22,g_hrcf.hrcf23,g_hrcf.hrcf24,
           g_hrcf.hrcf25,g_hrcf.hrcf26,g_hrcf.hrcf27,g_hrcf.hrcf28,g_hrcf.hrcf29,g_hrcf.hrcforiu,
           g_hrcf.hrcforig,g_hrcf.hrcfuser,g_hrcf.hrcfgrup,g_hrcf.hrcfmodu,g_hrcf.hrcfdate
       

   INPUT BY NAME
           g_hrcf.hrcf01,g_hrcf.hrcf02,g_hrcf.hrcf03,g_hrcf.hrcf06,g_hrcf.hrcf04,g_hrcf.hrcf05,
           g_hrcf.hrcf07,g_hrcf.hrcf08,g_hrcf.hrcf09,g_hrcf.hrcf10,g_hrcf.hrcf11,g_hrcf.hrcf12,
           g_hrcf.hrcf13,g_hrcf.hrcf14,g_hrcf.hrcf15,g_hrcf.hrcf18,g_hrcf.hrcf19,g_hrcf.hrcf20,
           g_hrcf.hrcf16,g_hrcf.hrcf17,g_hrcf.hrcf21,g_hrcf.hrcf22,g_hrcf.hrcf23,g_hrcf.hrcf24,
           g_hrcf.hrcf25,g_hrcf.hrcf26,g_hrcf.hrcf27,g_hrcf.hrcf28,g_hrcf.hrcf29,g_hrcf.hrcforiu,
           g_hrcf.hrcforig,g_hrcf.hrcfuser,g_hrcf.hrcfgrup,g_hrcf.hrcfmodu,g_hrcf.hrcfdate
      WITHOUT DEFAULTS

      BEFORE INPUT 
          LET g_before_input_done = FALSE
          CALL i046_set_entry(p_cmd)
          CALL i046_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
          
      
      AFTER FIELD hrcf01
         IF NOT cl_null(g_hrcf.hrcf01) AND ((p_cmd = 'u' AND g_hrcf.hrcf01 <> g_hrcf_t.hrcf01) OR (p_cmd = 'a'))THEN
            LET l_n=0
            SELECT COUNT(*) INTO l_n FROM hraa_file
             WHERE hraa01 = g_hrcf.hrcf01
               AND hraaacti = 'Y'
            IF l_n=0 THEN
               CALL cl_err(g_hrcf.hrcf01,'ghr-001',0)
               NEXT FIELD hrcf01
            END IF 
            LET l_n=0
            SELECT COUNT(*) INTO l_n FROM hrcf_file
             WHERE hrcf01 = g_hrcf.hrcf01
            IF l_n>0 THEN
               CALL cl_err(g_hrcf.hrcf01,-239,0)
               NEXT FIELD hrcf01
            END IF
            IF NOT cl_null(g_hrcf.hrcf02) THEN 
               LET l_n=0
               SELECT COUNT(*) INTO l_n FROM hrao_file
                WHERE hrao00 = g_hrcf.hrcf01
                  AND hrao01 = g_hrcf.hrcf02
                  AND hraoacti = 'Y'
               IF l_n=0 THEN
                  CALL cl_err(g_hrcf.hrcf01,'ghr-060',0)
                  NEXT FIELD hrcf01
               END IF  
            END IF    
           SELECT hraa12 INTO l_hraa12 FROM hraa_file WHERE hraa01 = g_hrcf.hrcf01
           DISPLAY l_hraa12 TO hrcf01_name 
         END IF 
                                                         
      AFTER FIELD hrcf02
         IF NOT cl_null(g_hrcf.hrcf02) THEN 
            LET l_n=0
            SELECT count(*) INTO l_n FROM hrao_file WHERE hrao01 = g_hrcf.hrcf02 AND hraoacti = 'Y'
            IF l_n=0 THEN
               CALL cl_err(g_hrcf.hrcf02,'asf-624',0)
               NEXT FIELD hrcf02
            END IF
            IF NOT cl_null(g_hrcf.hrcf01) THEN 
               LET l_n=0
               SELECT COUNT(*) INTO l_n FROM hrao_file
                WHERE hrao00 = g_hrcf.hrcf01
                  AND hrao01 = g_hrcf.hrcf02
                  AND hraoacti = 'Y'
               IF l_n=0 THEN
                  CALL cl_err(g_hrcf.hrcf01||g_hrcf.hrcf02,'ghr-060',0)
                  NEXT FIELD hrcf02
               END IF  
            END IF 
            SELECT hrao02 INTO l_hrao02 FROM hrao_file WHERE hrao01 = g_hrcf.hrcf02
           DISPLAY l_hrao02 TO hrcf02_name    
         END IF


      AFTER FIELD hrcf09
         IF NOT cl_null(g_hrcf.hrcf09) THEN
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM hrag_file 
             WHERE hrag01 = '503'
               AND hrag07 = '特殊假'
               AND hrag06 = g_hrcf.hrcf09
            IF l_n = 0 OR cl_null(l_n) THEN
               CALL cl_err(g_hrcf.hrcf09,'ghr-032',0)
               NEXT FIELD hrcf09
            END IF
         END IF

      AFTER FIELD hrcf23
         IF g_hrcf.hrcf05='N' THEN
            CALL cl_set_comp_entry("hrcf28",TRUE)
            CALL cl_set_comp_required("hrcf28",TRUE)
         ELSE
            CALL cl_set_comp_entry("hrcf28",FALSE)
            CALL cl_set_comp_required("hrcf28",FALSE)
            LET g_hrcf.hrcf28='N'
         END IF
                    
      AFTER FIELD hrcf24
         IF g_hrcf.hrcf05='N' THEN
            CALL cl_set_comp_entry("hrcf16,hrcf17,hrcf18,hrcf19,hrcf20,hrcf25",TRUE) 
         ELSE
            CALL cl_set_comp_entry("hrcf16,hrcf17,hrcf18,hrcf19,hrcf20,hrcf25",FALSE) 
            LET g_hrcf.hrcf16 = 'N'
            LET g_hrcf.hrcf17 = 'N'
            LET g_hrcf.hrcf18 = '001'
            LET g_hrcf.hrcf19 = 1
            SELECT hrag06,hrag07 INTO g_hrcf.hrcf20,l_hrag07 FROM hrag_file WHERE hrag01 = '603' and rownum = 1 
            LET g_hrcf.hrcf25 = 'Y' 
            DISPLAY BY NAME g_hrcf.hrcf16,g_hrcf.hrcf17,g_hrcf.hrcf18,g_hrcf.hrcf19,g_hrcf.hrcf20,g_hrcf.hrcf25
            DISPLAY l_hrag07 TO hrcf20_name
         END IF
          
      AFTER FIELD hrcf20
         IF NOT cl_null(g_hrcf.hrcf20) THEN
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM hrag_file 
             WHERE hrag01 = '519'
               AND hrag06 = g_hrcf.hrcf20
            IF l_n=0 THEN
               CALL cl_err(g_hrcf.hrcf20,'ghr-032',0)
               NEXT FIELD hrcf20
            END IF 
            LET l_hrag07 = '' 
            SELECT hrag07 INTO l_hrag07 FROM hrag_file WHERE hrag01='603' AND hrag06 = g_hrcf.hrcf20
            DISPLAY l_hrag07 TO hrcf20_name
         END IF 
      
      AFTER FIELD hrcf29
         IF NOT cl_null(g_hrcf.hrcf29) THEN
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM hrag_file 
             WHERE hrag01 = '519'
               AND hrag06 = g_hrcf.hrcf29
            IF l_n=0 THEN
               CALL cl_err(g_hrcf.hrcf29,'ghr-032',0)
               NEXT FIELD hrcf29
            END IF 
            LET l_hrag07 = '' 
            SELECT hrag07 INTO l_hrag07 FROM hrag_file WHERE hrag01='519' AND hrag06 = g_hrcf.hrcf29
            DISPLAY l_hrag07 TO hrcf29_name
         END IF                                                                       

     AFTER INPUT
         IF INT_FLAG THEN 
            EXIT INPUT
         END IF
          
     ON ACTION CONTROLO                        
       IF INFIELD(hrcf01) THEN
          LET g_hrcf.* = g_hrcf_t.*
          CALL i046_show()
          NEXT FIELD hrcf01
       END IF

     ON ACTION controlp
        CASE
           WHEN INFIELD(hrcf01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hraa01"
              LET g_qryparam.default1 = g_hrcf.hrcf01
              LET g_qryparam.construct = 'N'
              CALL cl_create_qry() RETURNING g_hrcf.hrcf01
              DISPLAY BY NAME g_hrcf.hrcf01
              NEXT FIELD hrcf01
           
           WHEN INFIELD(hrcf02)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrao02"
              LET g_qryparam.default1 = g_hrcf.hrcf02
              LET g_qryparam.arg1 = g_hrcf.hrcf01 
              CALL cl_create_qry() RETURNING g_hrcf.hrcf02
              DISPLAY BY NAME g_hrcf.hrcf02
              NEXT FIELD hrcf02

           WHEN INFIELD(hrcf09)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrag06"
              LET g_qryparam.arg1 = '503'
              LET g_qryparam.where = " hrag07 = '特殊假' "
              LET g_qryparam.default1 = g_hrcf.hrcf09
              CALL cl_create_qry() RETURNING g_hrcf.hrcf09
              DISPLAY BY NAME g_hrcf.hrcf09
              NEXT FIELD hrcf09

           WHEN INFIELD(hrcf20)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrag06"
              LET g_qryparam.default1 = g_hrcf.hrcf20
              LET g_qryparam.arg1 = '603'
              CALL cl_create_qry() RETURNING g_hrcf.hrcf20
              DISPLAY BY NAME g_hrcf.hrcf20
              NEXT FIELD hrcf20
           
          WHEN INFIELD(hrcf29)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrag06"
              LET g_qryparam.default1 = g_hrcf.hrcf29
              LET g_qryparam.arg1 = '519'
              CALL cl_create_qry() RETURNING g_hrcf.hrcf29
              DISPLAY BY NAME g_hrcf.hrcf29
              NEXT FIELD hrcf29

           OTHERWISE
              EXIT CASE
           END CASE

      ON ACTION CONTROLZ
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLF                       
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
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

FUNCTION i046_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_hrcf.* TO NULL
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i046_curs()                      
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       RETURN
    END IF
    OPEN i046_count
    FETCH i046_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i046_cs                           
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrcf.hrcf01,SQLCA.sqlcode,0)
        INITIALIZE g_hrcf.* TO NULL
    ELSE
        CALL i046_fetch('F')              
    END IF
END FUNCTION

FUNCTION i046_fetch(p_flhrcf)
    DEFINE p_flhrcf         LIKE type_file.chr1

    CASE p_flhrcf
        WHEN 'N' FETCH NEXT     i046_cs INTO g_hrcf.hrcf01,g_hrcf.hrcf02
        WHEN 'P' FETCH PREVIOUS i046_cs INTO g_hrcf.hrcf01,g_hrcf.hrcf02
        WHEN 'F' FETCH FIRST    i046_cs INTO g_hrcf.hrcf01,g_hrcf.hrcf02
        WHEN 'L' FETCH LAST     i046_cs INTO g_hrcf.hrcf01,g_hrcf.hrcf02
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
            FETCH ABSOLUTE g_jump i046_cs INTO g_hrcf.hrcf01,g_hrcf.hrcf02
            LET g_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrcf.hrcf01,SQLCA.sqlcode,0)
        INITIALIZE g_hrcf.* TO NULL 
        RETURN
    ELSE
      CASE p_flhrcf
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE

      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx
    END IF

    SELECT * INTO g_hrcf.* FROM hrcf_file    
       WHERE hrcf01 = g_hrcf.hrcf01
         AND hrcf02 = g_hrcf.hrcf02
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","hrcf_file",g_hrcf.hrcf01,"",SQLCA.sqlcode,"","",0)
    ELSE
        CALL i046_show()                 
    END IF
END FUNCTION

FUNCTION i046_show()
DEFINE l_hraa12      LIKE hraa_file.hraa12
DEFINE l_hrao02      LIKE hrao_file.hrao02
DEFINE l_hrag07      LIKE hrag_file.hrag07 
    LET g_hrcf_t.* = g_hrcf.*
    DISPLAY BY NAME g_hrcf.hrcf01,g_hrcf.hrcf02,g_hrcf.hrcf03,g_hrcf.hrcf06,g_hrcf.hrcf04,g_hrcf.hrcf05,
                    g_hrcf.hrcf07,g_hrcf.hrcf08,g_hrcf.hrcf09,g_hrcf.hrcf10,g_hrcf.hrcf11,g_hrcf.hrcf12,
                    g_hrcf.hrcf13,g_hrcf.hrcf14,g_hrcf.hrcf15,g_hrcf.hrcf18,g_hrcf.hrcf19,g_hrcf.hrcf20,
                    g_hrcf.hrcf16,g_hrcf.hrcf17,g_hrcf.hrcf21,g_hrcf.hrcf22,g_hrcf.hrcf23,g_hrcf.hrcf24,
                    g_hrcf.hrcf25,g_hrcf.hrcf26,g_hrcf.hrcf27,g_hrcf.hrcf28,g_hrcf.hrcf29,g_hrcf.hrcforiu,
                    g_hrcf.hrcforig,g_hrcf.hrcfuser,g_hrcf.hrcfgrup,g_hrcf.hrcfmodu,g_hrcf.hrcfdate
    SELECT hraa12 INTO l_hraa12 FROM hraa_file WHERE hraa01=g_hrcf.hrcf01
    DISPLAY l_hraa12 TO hrcf01_name
    SELECT hrao02 INTO l_hrao02 FROM hrao_file WHERE hrao01=g_hrcf.hrcf02 AND hrao01=g_hrcf.hrcf01
    DISPLAY l_hrao02 TO hrcf02_name
    LET l_hrag07 = ''
    SELECT hrag07 INTO l_hrag07 FROM hrag_file WHERE hrag06=g_hrcf.hrcf20 AND hrag01 = '603'
    DISPLAY l_hrag07 TO hrcf20_name
    LET l_hrag07 = ''
    SELECT hrag07 INTO l_hrag07 FROM hrag_file WHERE hrag06=g_hrcf.hrcf29 AND hrag01 = '519'
    DISPLAY l_hrag07 TO hrcf29_name 
     
END FUNCTION


FUNCTION i046_u()
    IF g_hrcf.hrcf01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_hrcf.* FROM hrcf_file WHERE hrcf01 = g_hrcf.hrcf01 AND hrcf02 = g_hrcf.hrcf02
    CALL cl_opmsg('u')
    BEGIN WORK

    OPEN i046_cl USING g_hrcf.hrcf01,g_hrcf.hrcf02
    IF STATUS THEN
       CALL cl_err("OPEN i046_cl:", STATUS, 1)
       CLOSE i046_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i046_cl INTO g_hrcf.*               #
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrcf.hrcf01,SQLCA.sqlcode,1)
        RETURN
    END IF              
    CALL i046_show()                          
    WHILE TRUE
        CALL i046_i("u")                      
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_hrcf.*=g_hrcf_t.*
            CALL i046_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        LET g_hrcf.hrcfmodu=g_user
        LET g_hrcf.hrcfdate=g_today 
        UPDATE hrcf_file SET hrcf_file.* = g_hrcf.*    
         WHERE hrcf01 = g_hrcf_t.hrcf01
           AND hrcf02 = g_hrcf_t.hrcf02  
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","hrcf_file",g_hrcf.hrcf01,"",SQLCA.sqlcode,"","",0)  
            CONTINUE WHILE
        END IF
        CALL i046_show() 
        EXIT WHILE
    END WHILE
    CLOSE i046_cl
    COMMIT WORK
END FUNCTION

FUNCTION i046_r()
DEFINE l_n    LIKE  type_file.num5
      
    IF g_hrcf.hrcf01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK

    OPEN i046_cl USING g_hrcf.hrcf01,g_hrcf.hrcf02
    IF STATUS THEN
       CALL cl_err("OPEN i046_cl:", STATUS, 0)
       CLOSE i046_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i046_cl INTO g_hrcf.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrcf.hrcf01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i046_show()
    IF cl_delete() THEN
       LET g_doc.column1 = "hrcf01"
       LET g_doc.value1 = g_hrcf.hrcf01
       LET g_doc.column2 = "hrcf02"
       LET g_doc.value2 = g_hrcf.hrcf02

       CALL cl_del_doc()
       DELETE FROM hrcf_file 
        WHERE hrcf01 = g_hrcf.hrcf01 
          AND hrcf02 = g_hrcf.hrcf02 

       CLEAR FORM
       OPEN i046_count 
       IF STATUS THEN
          CLOSE i046_cl
          CLOSE i046_count
          COMMIT WORK
          RETURN
       END IF
       FETCH i046_count INTO g_row_count
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i046_cl
          CLOSE i046_count
          COMMIT WORK
          RETURN
       END IF
       DISPLAY g_row_count TO FORMONLY.cnt

       OPEN i046_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i046_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE                 #No.FUN-6A0066
          CALL i046_fetch('/')
       END IF
    END IF
    CLOSE i046_cl
    COMMIT WORK
END FUNCTION

FUNCTION i046_copy()
 
    DEFINE l_newno01         LIKE hrcf_file.hrcf01
    DEFINE l_newno02         LIKE hrcf_file.hrcf02
    DEFINE l_oldno01         LIKE hrcf_file.hrcf01
    DEFINE l_oldno02         LIKE hrcf_file.hrcf02  
    DEFINE l_n               LIKE type_file.num5
    DEFINE l_hraa12          LIKE hraa_file.hraa12
    DEFINE l_hrao02          LIKE hrao_file.hrao02
    
    IF g_hrcf.hrcf01 IS NULL THEN
       CALL cl_err('',-400,0)
        RETURN
    END IF
 
    LET g_before_input_done = FALSE
    LET g_before_input_done = TRUE

    INPUT l_newno01,l_newno02 FROM hrcf01,hrcf02
    
    BEFORE INPUT
       LET l_newno01=g_hrcf.hrcf01
       LET l_newno02=g_hrcf.hrcf02  
       DISPLAY l_newno01 TO hrcf01
       DISPLAY l_newno02 TO hrcf02 
       
       AFTER FIELD hrcf01
         IF NOT cl_null(l_newno01) THEN
            LET l_n=0
            SELECT COUNT(*) INTO l_n FROM hraa_file
             WHERE hraa01 = l_newno01
               AND hraaacti = 'Y'
            IF l_n=0 THEN
              CALL cl_err(l_newno01,'ghr-001',0)
              NEXT FIELD hrcf01
            END IF 
            IF NOT cl_null(l_newno02) THEN 
               LET l_n=0
               SELECT COUNT(*) INTO l_n FROM hrao_file
                WHERE hrao00 = l_newno01
                  AND hrao01 = l_newno02
                  AND hraoacti = 'Y'
               IF l_n=0 THEN
                  CALL cl_err(l_newno01,'ghr-060',0)
                  NEXT FIELD hrcf01
               END IF  
            END IF    
           SELECT hraa12 INTO l_hraa12 FROM hraa_file WHERE hraa01 = l_newno01
           DISPLAY l_hraa12 TO hrcf01_name 
         END IF 
                                                         
      AFTER FIELD hrcf02
         IF NOT cl_null(l_newno02) THEN 
            LET l_n=0
            SELECT count(*) INTO l_n FROM hrao_file WHERE hrao01 = l_newno02 AND hraoacti = 'Y'
            IF l_n=0 THEN
               CALL cl_err(l_newno02,'asf-624',0)
               NEXT FIELD hrcf02
            END IF
            IF NOT cl_null(l_newno01) THEN 
               LET l_n=0
               SELECT COUNT(*) INTO l_n FROM hrao_file
                WHERE hrao00 = l_newno01
                  AND hrao01 = l_newno02
                  AND hraoacti = 'Y'
               IF l_n=0 THEN
                  CALL cl_err(l_newno01||l_newno02,'ghr-060',0)
                  NEXT FIELD hrcf02
               END IF  
            END IF 
            SELECT hrao02 INTO l_hrao02 FROM hrao_file WHERE hrao01 = l_newno02
           DISPLAY l_hrao02 TO hrcf02_name    
         END IF

        ON ACTION controlp     
           CASE 
              WHEN INFIELD(hrcf01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hraa01"
                 LET g_qryparam.default1 = l_newno01
                 LET g_qryparam.construct = 'N'
                 CALL cl_create_qry() RETURNING l_newno01
                 DISPLAY BY NAME l_newno01
                 NEXT FIELD hrcf01
              
              WHEN INFIELD(hrcf02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrao02"
                 LET g_qryparam.default1 = l_newno02
                 LET g_qryparam.arg1 = g_hrcf.hrcf01 
                 CALL cl_create_qry() RETURNING l_newno02
                 DISPLAY BY NAME l_newno02
                 NEXT FIELD hrcf02  
           END CASE
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
        DISPLAY BY NAME g_hrcf.hrcf01,g_hrcf.hrcf02
        RETURN
    END IF
    DROP TABLE x
    SELECT * FROM hrcf_file
        WHERE hrcf01=g_hrcf.hrcf01
          AND hrcf02=g_hrcf.hrcf02
        INTO TEMP x
    UPDATE x
        SET hrcf01=l_newno01,
            hrcf02=l_newno02,  
            hrcfuser=g_user,   
            hrcfgrup=g_grup,   
            hrcfmodu=NULL,     
            hrcfdate=g_today   

    INSERT INTO hrcf_file SELECT * FROM x
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","hrcf_file",g_hrcf.hrcf01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
    ELSE
       MESSAGE 'ROW(',l_newno01,') O.K' 
       LET l_oldno01 = g_hrcf.hrcf01
       LET l_oldno02 = g_hrcf.hrcf02  
       SELECT hrcf_file.* INTO g_hrcf.* FROM hrcf_file
        WHERE hrcf01 = l_newno01
          AND hrcf02 = l_newno02
       CALL i046_u()
       SELECT hrcf_file.* INTO g_hrcf.* FROM hrcf_file
        WHERE hrcf01 = l_oldno01
          AND hrcf02 = l_oldno02
    END IF 
    CALL i046_show()
END FUNCTION


PRIVATE FUNCTION i046_set_entry(p_cmd) 
   DEFINE l_hrag07      LIKE hrag_file.hrag07 
   DEFINE   p_cmd     LIKE type_file.chr1

   IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("hrcf01,hrcf02",TRUE)
   END IF
   IF g_hrcf.hrcf05='N' THEN
      CALL cl_set_comp_entry("hrcf28",TRUE)
      CALL cl_set_comp_required("hrcf28",TRUE)
   ELSE
      CALL cl_set_comp_entry("hrcf28",FALSE)
      CALL cl_set_comp_required("hrcf28",FALSE)
      LET g_hrcf.hrcf28='N'
   END IF
   IF g_hrcf.hrcf05='N' THEN
      CALL cl_set_comp_entry("hrcf16,hrcf17,hrcf18,hrcf19,hrcf20,hrcf25",TRUE) 
   ELSE
      CALL cl_set_comp_entry("hrcf16,hrcf17,hrcf18,hrcf19,hrcf20,hrcf25",FALSE) 
      LET g_hrcf.hrcf16 = 'N'
      LET g_hrcf.hrcf18 = '001'
      LET g_hrcf.hrcf17 = 'N'
      LET g_hrcf.hrcf19 = 1
      SELECT hrag06,hrag07 INTO g_hrcf.hrcf20,l_hrag07 FROM hrag_file WHERE hrag01 = '603' and rownum = 1 
      LET g_hrcf.hrcf25 = 'Y' 
      DISPLAY BY NAME g_hrcf.hrcf16,g_hrcf.hrcf17,g_hrcf.hrcf18,g_hrcf.hrcf19,g_hrcf.hrcf20,g_hrcf.hrcf25
      DISPLAY l_hrag07 TO hrcf20_name
   END IF        
END FUNCTION


PRIVATE FUNCTION i046_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1

   IF p_cmd = 'u' AND g_chkey = 'N' THEN
      CALL cl_set_comp_entry("hrcf01,hrcf02",FALSE)
   END IF
END FUNCTION
 
