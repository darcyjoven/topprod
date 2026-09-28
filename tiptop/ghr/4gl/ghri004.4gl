# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri004.4gl
# Descriptions...: 
# Date & Author..: 03/19/13 by zhangbo


DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"

DEFINE  g_hrar    RECORD LIKE hrar_file.*
DEFINE  g_hrar_t  RECORD LIKE hrar_file.*
DEFINE  g_hrar_b  DYNAMIC ARRAY OF RECORD
          hrar01_b    LIKE   hrar_file.hrar01,
          hrar01_1_b  LIKE   hraa_file.hraa12,
          hrar02_b    LIKE   hrar_file.hrar02,
          hrar02_1_b  LIKE   hrag_file.hrag07,
          hrar03_b    LIKE   hrar_file.hrar03,
          hrar04_b    LIKE   hrar_file.hrar04,
          hrar06_b    LIKE   hrar_file.hrar06,
          hrar06_1_b  LIKE   hrag_file.hrag07,
          hrar05_b    LIKE   hrar_file.hrar05,
          hraracti_b  LIKE   hrar_file.hraracti
                  END RECORD
DEFINE  g_forupd_sql        STRING
DEFINE  g_before_input_done LIKE type_file.num5
DEFINE  g_rec_b,l_ac             LIKE type_file.num5
DEFINE  g_hrar03            LIKE hrar_file.hrar03
DEFINE  g_wc   STRING
DEFINE  g_sql  STRING  
DEFINE g_row_count  LIKE type_file.num5       
DEFINE g_curs_index LIKE type_file.num5
DEFINE g_jump       LIKE type_file.num10
DEFINE g_no_ask     LIKE type_file.num5      
DEFINE g_str        STRING 
DEFINE g_msg        LIKE type_file.chr1000
DEFINE g_chr        LIKE type_file.chr1
DEFINE g_flag       LIKE type_file.chr1
DEFINE g_bp_flag           LIKE type_file.chr10

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
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
 
   INITIALIZE g_hrar.* TO NULL

   LET g_forupd_sql = "SELECT * FROM hrar_file WHERE hrar03 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)        
   DECLARE i004_cl CURSOR FROM g_forupd_sql                 
   
   OPEN WINDOW i004_w AT p_row,p_col 
     WITH FORM "ghr/42f/ghri004"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
   CALL cl_ui_init()
   
   LET g_action_choice=""
   CALL i004_menu()

 
   CLOSE WINDOW i004_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 
END MAIN

FUNCTION i004_curs()

    CLEAR FORM
    INITIALIZE g_hrar.* TO NULL
    CONSTRUCT BY NAME g_wc ON                              
        hrar01,hrar02,hrar03,hrar04,hrar05,hrar06,
        hraruser,hrargrup,hrarmodu,hrardate,hraracti,hraroriu,hrarorig

        BEFORE CONSTRUCT                                    
           CALL cl_qbe_init()                               

        ON ACTION controlp
           CASE
           	  WHEN INFIELD(hrar01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hraa10"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.construct = "N"        #add by zhangbo130831
                 LET g_qryparam.default1 = g_hrar.hrar01
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrar01
                 NEXT FIELD hrar01
           	
              WHEN INFIELD(hrar02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.construct = "N"        #add by zhangbo130831
                 LET g_qryparam.default1 = g_hrar.hrar02
                 LET g_qryparam.arg1='203'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrar02
                 NEXT FIELD hrar02
                 
              WHEN INFIELD(hrar06)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.construct = "N"        #add by zhangbo130831
                 LET g_qryparam.default1 = g_hrar.hrar06
                 LET g_qryparam.arg1='204'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrar06
                 NEXT FIELD hrar06
                                 

              OTHERWISE
                 EXIT CASE
           END CASE

      ON IDLE g_idle_seconds                                #
         CALL cl_on_idle()
         CONTINUE CONSTRUCT

      ON ACTION about                                       #
         CALL cl_about()

      ON ACTION help                                        #
         CALL cl_show_help()

      ON ACTION controlg                                    #
         CALL cl_cmdask()

      ON ACTION qbe_select                                  #
         CALL cl_qbe_select()

      ON ACTION qbe_save                                    #
         CALL cl_qbe_save()
    END CONSTRUCT

    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hraruser', 'hrargrup')  #
                                                                     #

    LET g_sql = "SELECT hrar03 FROM hrar_file ",                       #
                " WHERE ",g_wc CLIPPED, " ORDER BY hrar01"
    PREPARE i004_prepare FROM g_sql
    DECLARE i004_cs                                                  # 
        SCROLL CURSOR WITH HOLD FOR i004_prepare

    LET g_sql = "SELECT COUNT(DISTINCT hrar03) FROM hrar_file WHERE ",g_wc CLIPPED
    PREPARE i004_precount FROM g_sql
    DECLARE i004_count CURSOR FOR i004_precount
END FUNCTION
	
FUNCTION i004_menu()
    DEFINE l_cmd    STRING

    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
           
        ON ACTION item_list
           LET g_action_choice = ""  #MOD-8A0193 add
           CALL i004_b_menu()   #MOD-8A0193
           LET g_action_choice = ""  #MOD-8A0193 add   

        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i004_a()
            END IF

        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i004_q()
            END IF

        ON ACTION next
            CALL i004_fetch('N')

        ON ACTION previous
            CALL i004_fetch('P')

        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i004_u()
            END IF

        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL i004_x()
            END IF

        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i004_r()
            END IF

        ON ACTION help
            CALL cl_show_help()

        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU

        ON ACTION jump
            CALL i004_fetch('/')

        ON ACTION first
            CALL i004_fetch('F')

        ON ACTION last
            CALL i004_fetch('L')

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
              IF g_hrar.hrar01 IS NOT NULL THEN
                 LET g_doc.column1 = "hrar03"
                 LET g_doc.value1 = g_hrar.hrar03
                 CALL cl_doc()
              END IF
           END IF
           	
        ON ACTION exporttoexcel   #No.FUN-4B0020
           LET g_action_choice = 'exporttoexcel'
           IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrar_b),'','')
           END IF   	
    END MENU

END FUNCTION


FUNCTION i004_a()

    CLEAR FORM                                   #
    INITIALIZE g_hrar.* LIKE hrar_file.*
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_hrar.hraruser = g_user
        LET g_hrar.hraroriu = g_user
        LET g_hrar.hrarorig = g_grup
        LET g_hrar.hrargrup = g_grup               #
        LET g_hrar.hrardate = g_today
        LET g_hrar.hraracti = 'Y'
        CALL i004_i("a")                         #
        IF INT_FLAG THEN                         #
            INITIALIZE g_hrar.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_hrar.hrar03 IS NULL THEN              #
            CONTINUE WHILE
        END IF
        INSERT INTO hrar_file VALUES(g_hrar.*)     #
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","hrar_file",g_hrar.hrar03,"",SQLCA.sqlcode,"","",0)   #No.FUN-660131
            CONTINUE WHILE
        ELSE
            SELECT hrar03 INTO g_hrar.hrar03 FROM hrar_file WHERE hrar03 = g_hrar.hrar03
            CALL i004_b_fill(g_wc)
        END IF
        EXIT WHILE
    END WHILE
    	
END FUNCTION

FUNCTION i004_i(p_cmd)

   DEFINE p_cmd         LIKE type_file.chr1
   DEFINE l_input       LIKE type_file.chr1
   DEFINE l_n           LIKE type_file.num5
   DEFINE l_hraa02      LIKE hraa_file.hraa02
   DEFINE l_hrar06_1    LIKE hrar_file.hrar02
   DEFINE l_hraa10      LIKE hraa_file.hraa10
   DEFINE l_sql         STRING
   DEFINE l_hrar01_1    LIKE hraa_file.hraa12
   DEFINE l_hrar02_1    LIKE hrag_file.hrag07
   
   DISPLAY BY NAME
      g_hrar.hrar01,g_hrar.hrar02,g_hrar.hrar03,g_hrar.hrar04,
      g_hrar.hrar06,g_hrar.hrar05,
      g_hrar.hraruser,g_hrar.hrargrup,g_hrar.hrarmodu,g_hrar.hrardate,g_hrar.hraracti

   INPUT BY NAME
      g_hrar.hrar01,g_hrar.hrar02,g_hrar.hrar03,g_hrar.hrar04,
      g_hrar.hrar06,g_hrar.hrar05
      WITHOUT DEFAULTS

      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          #CALL i004_set_entry(p_cmd)
          #CALL i004_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
          IF p_cmd='a' THEN
          	 SELECT hraa01,hraa12 INTO g_hrar.hrar01,l_hrar01_1 FROM hraa_file WHERE hraa10 IS NULL
          	 #CALL i004_gen_pre(g_hrar.hrar01,'')
          	 #LET g_hrar.hrar03=g_hrar03
                 CALL hr_gen_no('hrar_file','hrar03','001',g_hrar.hrar01,'') RETURNING g_hrar.hrar03,g_flag
                 IF g_flag='Y' THEN
                    CALL cl_set_comp_entry("hrar03",TRUE)
                 ELSE
                    CALL cl_set_comp_entry("hrar03",FALSE)
                 END IF
          	 DISPLAY BY NAME g_hrar.hrar01,g_hrar.hrar03
          	 DISPLAY l_hrar01_1 TO hrar01_1
          END IF	 
      
      AFTER FIELD hrar01
         IF NOT cl_null(g_hrar.hrar01) THEN
         	  LET l_n=0
         	  SELECT COUNT(*) INTO l_n FROM hraa_file WHERE hraa01=g_hrar.hrar01
         	                                            AND hraaacti='Y'
         	  IF l_n=0 THEN
         	  	 CALL cl_err(g_hrar.hrar01,'ghr-001',0)
         	  	 NEXT FIELD hrar01
         	  END IF
         	  
            IF g_hrar.hrar01 != g_hrar_t.hrar01 OR g_hrar_t.hrar01 IS NULL THEN
         	     IF NOT cl_null(g_hrar.hrar02) AND NOT cl_null(g_hrar.hrar04) THEN
         	  	    LET l_n=0
         	  	    SELECT COUNT(*) INTO l_n FROM hrar_file WHERE hrar01=g_hrar.hrar01
         	  	                                              AND hrar02=g_hrar.hrar02
         	  	                                              AND hrar04=g_hrar.hrar04
         	  	    IF l_n>0 THEN
         	  	 	     CALL cl_err(g_hrar.hrar01,-239,1)
         	  	 	     NEXT FIELD hrar01
         	  	    END IF
         	     END IF
         	  END IF   		 		                                            	
         	  
         	  SELECT hraa12 INTO l_hrar01_1 FROM hraa_file WHERE hraa01=g_hrar.hrar01
         	  IF p_cmd='a' THEN
         	  	 LET l_hraa10=''
          	   SELECT hraa10 INTO l_hraa10 FROM hraa_file WHERE hraa01=g_hrar.hrar01 
          	   #CALL i004_gen_pre(g_hrar.hrar01,l_hraa10)
          	   #LET g_hrar.hrar03=g_hrar03
                   CALL hr_gen_no('hrar_file','hrar03','001',g_hrar.hrar01,l_hraa10) RETURNING g_hrar.hrar03,g_flag
                   IF g_flag='Y' THEN
                      CALL cl_set_comp_entry("hrar03",TRUE)
                   ELSE
                      CALL cl_set_comp_entry("hrar03",FALSE)
                   END IF
            END IF
          	DISPLAY BY NAME g_hrar.hrar01,g_hrar.hrar03
          	DISPLAY l_hrar01_1 TO hrar01_1	
         ELSE
         	  NEXT FIELD hrar01	  	
         END IF
         	
      AFTER FIELD hrar02
         IF NOT cl_null(g_hrar.hrar02) THEN
         	  LET l_n=0
         	  SELECT COUNT(*) INTO l_n FROM hrag_file WHERE hrag01='203'
         	                                            AND hrag06=g_hrar.hrar02
         	  IF l_n=0 THEN
         	  	 CALL cl_err(g_hrar.hrar02,'ghr-014',0)
         	  	 NEXT FIELD hrar02
         	  END IF
         	  
         	  IF g_hrar.hrar02 != g_hrar_t.hrar02 OR g_hrar_t.hrar02 IS NULL THEN	
         	     IF NOT cl_null(g_hrar.hrar01) AND NOT cl_null(g_hrar.hrar04) THEN
         	  	    LET l_n=0
         	  	    SELECT COUNT(*) INTO l_n FROM hrar_file WHERE hrar01=g_hrar.hrar01
         	  	                                              AND hrar02=g_hrar.hrar02
         	  	                                              AND hrar04=g_hrar.hrar04
         	  	    IF l_n>0 THEN
         	  	 	     CALL cl_err(g_hrar.hrar02,-239,1)
         	  	 	     NEXT FIELD hrar02
         	  	    END IF
         	     END IF
         	  END IF
         	  	   	
         	  SELECT hrag07 INTO l_hrar02_1 FROM hrag_file WHERE hrag01='203'
         	                                                 AND hrag06=g_hrar.hrar02	
         	  DISPLAY l_hrar02_1 TO hrar02_1                                               	 		
         END IF	  			           
         	                                    	  		                                           
      AFTER FIELD hrar03
         IF g_hrar.hrar03 IS NOT NULL THEN
         	  IF g_hrar.hrar03 != g_hrar_t.hrar03 OR g_hrar_t.hrar03 IS NULL THEN  
         	     LET l_n=0
               SELECT count(*) INTO l_n FROM hrar_file WHERE hrar03 = g_hrar.hrar03
               IF l_n > 0 THEN                  
                  CALL cl_err(g_hrar.hrar03,-239,1)
                  LET g_hrar.hrar03 = g_hrar_t.hrar03
                  DISPLAY BY NAME g_hrar.hrar03
                  NEXT FIELD hrar03
               END IF
            END IF   	
         END IF
         	
      AFTER FIELD hrar04
         IF NOT cl_null(g_hrar.hrar04) THEN
         	  IF g_hrar.hrar04 != g_hrar_t.hrar04 OR g_hrar_t.hrar04 IS NULL THEN 
         	     IF NOT cl_null(g_hrar.hrar01) AND NOT cl_null(g_hrar.hrar02) THEN
         	  	    LET l_n=0
         	  	    SELECT COUNT(*) INTO l_n FROM hrar_file WHERE hrar01=g_hrar.hrar01
         	  	                                              AND hrar02=g_hrar.hrar02
         	  	                                              AND hrar04=g_hrar.hrar04
         	  	    IF l_n>0 THEN
         	  	 	     CALL cl_err(g_hrar.hrar04,-239,1)
         	  	 	     NEXT FIELD hrar04
         	  	    END IF
         	     END IF
         	  END IF   	
         END IF	  		 		
         	
      AFTER FIELD hrar06
         IF NOT cl_null(g_hrar.hrar06) THEN
            
            LET l_n=0
         	  SELECT COUNT(*) INTO l_n FROM hrag_file WHERE hrag01='204'
         	                                            AND hrag06=g_hrar.hrar06
         	  IF l_n=0 THEN
         	  	 CALL cl_err(g_hrar.hrar06,'ghr-015',0)
         	  	 NEXT FIELD hrar06
         	  END IF
            SELECT hrag07 INTO l_hrar06_1 FROM hrag_file WHERE hrag01='204'
         	                                                 AND hrag06=g_hrar.hrar06
         	  DISPLAY l_hrar06_1 TO hrar06_1                                                  	  	
         END IF	
               	    	 		                     	  	                    	  	   	 	                                             	    		  	      	

     AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         

     ON ACTION controlp
        CASE
           WHEN INFIELD(hrar01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hraa10"
              LET g_qryparam.default1 = g_hrar.hrar01
              LET g_qryparam.construct = "N"        #add by zhangbo130831
              CALL cl_create_qry() RETURNING g_hrar.hrar01
              DISPLAY BY NAME g_hrar.hrar01
              NEXT FIELD hrar01
           
           WHEN INFIELD(hrar02)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrag06"
              LET g_qryparam.construct = "N"        #add by zhangbo130831
              LET g_qryparam.default1 = g_hrar.hrar02
              LET g_qryparam.arg1 = '203' 
              CALL cl_create_qry() RETURNING g_hrar.hrar02
              DISPLAY BY NAME g_hrar.hrar02
              NEXT FIELD hrar02
              
           WHEN INFIELD(hrar06)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrag06"
              LET g_qryparam.construct = "N"        #add by zhangbo130831
              LET g_qryparam.default1 = g_hrar.hrar06
              LET g_qryparam.arg1 = '204'
              CALL cl_create_qry() RETURNING g_hrar.hrar06
              DISPLAY BY NAME g_hrar.hrar06
              NEXT FIELD hrar06
           
           OTHERWISE
              EXIT CASE
           END CASE

      ON ACTION CONTROLZ
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLF                        
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about 
         CALL cl_about()

      ON ACTION help  
         CALL cl_show_help()

   END INPUT
END FUNCTION

FUNCTION i004_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_hrar.* TO NULL
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i004_curs()                      
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       RETURN
    END IF
    OPEN i004_count
    FETCH i004_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i004_cs                           
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrar.hrar03,SQLCA.sqlcode,0)
        INITIALIZE g_hrar.* TO NULL
    ELSE
        CALL i004_fetch('F')              #
        CALL i004_b_fill(g_wc)
    END IF
END FUNCTION

FUNCTION i004_fetch(p_flhrar)
    DEFINE p_flhrar         LIKE type_file.chr1

    CASE p_flhrar
        WHEN 'N' FETCH NEXT     i004_cs INTO g_hrar.hrar03
        WHEN 'P' FETCH PREVIOUS i004_cs INTO g_hrar.hrar03
        WHEN 'F' FETCH FIRST    i004_cs INTO g_hrar.hrar03
        WHEN 'L' FETCH LAST     i004_cs INTO g_hrar.hrar03
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
            FETCH ABSOLUTE g_jump i004_cs INTO g_hrar.hrar03
            LET g_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrar.hrar03,SQLCA.sqlcode,0)
        INITIALIZE g_hrar.* TO NULL
        LET g_hrar.hrar03 = NULL
        RETURN
    ELSE
      CASE p_flhrar
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE

      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx
    END IF

    SELECT * INTO g_hrar.* FROM hrar_file    
       WHERE hrar03 = g_hrar.hrar03
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","hrar_file",g_hrar.hrar03,"",SQLCA.sqlcode,"","",0)
    ELSE
        CALL i004_show()                 
    END IF
END FUNCTION

FUNCTION i004_show()
DEFINE l_hrar01_1     LIKE     hraa_file.hraa12
DEFINE l_hrar02_1     LIKE     hrag_file.hrag07	
DEFINE l_hrar06_1     LIKE     hrag_file.hrag07
    LET g_hrar_t.* = g_hrar.*
    DISPLAY BY NAME g_hrar.hrar01,g_hrar.hrar02,g_hrar.hrar03,
                    g_hrar.hrar04,g_hrar.hrar05,g_hrar.hrar06,
                    g_hrar.hraruser,g_hrar.hrargrup,g_hrar.hrarmodu,
                    g_hrar.hrardate,g_hrar.hraracti,g_hrar.hrarorig,g_hrar.hraroriu
    SELECT hraa12 INTO l_hrar01_1 FROM hraa_file WHERE hraa01=g_hrar.hrar01
    SELECT hrag07 INTO l_hrar02_1 FROM hrag_file WHERE hrag01='203'
                                                   AND hrag06=g_hrar.hrar02
    SELECT hrag07 INTO l_hrar06_1 FROM hrag_file WHERE hrag01='204'
                                                   AND hrag06=g_hrar.hrar06                                              
    DISPLAY l_hrar01_1 TO hrar01_1
    DISPLAY l_hrar02_1 TO hrar02_1
    DISPLAY l_hrar06_1 TO hrar06_1
    CALL cl_show_fld_cont()
END FUNCTION


FUNCTION i004_u()
DEFINE l_n   LIKE type_file.num5
	
    IF g_hrar.hrar03 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_hrar.* FROM hrar_file WHERE hrar03=g_hrar.hrar03
    IF g_hrar.hraracti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    
    LET l_n=0 
    SELECT COUNT(*) INTO l_n FROM hras_file WHERE hras03=g_hrar.hrar03
    IF l_n>0 THEN
    	 CALL cl_err(g_hrar.hrar03,'ghr-016',0)
    	 RETURN
    END IF 	      	
    	
    CALL cl_opmsg('u')
    BEGIN WORK

    OPEN i004_cl USING g_hrar.hrar03
    IF STATUS THEN
       CALL cl_err("OPEN i004_cl:", STATUS, 1)
       CLOSE i004_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i004_cl INTO g_hrar.*               #
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrar.hrar03,SQLCA.sqlcode,1)
        RETURN
    END IF              
    CALL i004_show()                          
    WHILE TRUE
        CALL i004_i("u")                      
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_hrar.*=g_hrar_t.*
            CALL i004_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        LET g_hrar.hrarmodu=g_user
        LET g_hrar.hrardate=g_today	
        UPDATE hrar_file SET hrar_file.* = g_hrar.*    
            WHERE hrar03 = g_hrar_t.hrar03
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","hrar_file",g_hrar.hrar03,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
            CONTINUE WHILE
        END IF
        CALL i004_show()	
        EXIT WHILE
    END WHILE
    CLOSE i004_cl
    COMMIT WORK
    CALL i004_b_fill(g_wc)
END FUNCTION

FUNCTION i004_x()
DEFINE l_n    LIKE   type_file.num5
	
    IF g_hrar.hrar03 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    	
    LET l_n=0 
    SELECT COUNT(*) INTO l_n FROM hras_file WHERE hras03=g_hrar.hrar03
    IF l_n>0 THEN
    	 CALL cl_err(g_hrar.hrar03,'ghr-017',0)
    	 RETURN
    END IF
    	    	
    BEGIN WORK

    OPEN i004_cl USING g_hrar.hrar03
    IF STATUS THEN
       CALL cl_err("OPEN i004_cl:", STATUS, 1)
       CLOSE i004_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i004_cl INTO g_hrar.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrar.hrar03,SQLCA.sqlcode,1)
       RETURN
    END IF
    CALL i004_show()
    IF cl_exp(0,0,g_hrar.hraracti) THEN
        LET g_chr = g_hrar.hraracti
        IF g_hrar.hraracti='Y' THEN
            LET g_hrar.hraracti='N'
        ELSE
            LET g_hrar.hraracti='Y'
        END IF
        UPDATE hrar_file
            SET hraracti=g_hrar.hraracti
            WHERE hrar03=g_hrar.hrar03
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(g_hrar.hrar03,SQLCA.sqlcode,0)
            LET g_hrar.hraracti = g_chr
        END IF
        DISPLAY BY NAME g_hrar.hraracti
    END IF
    CLOSE i004_cl
    COMMIT WORK
    CALL i004_b_fill(g_wc)
END FUNCTION

FUNCTION i004_r()
DEFINE l_n    LIKE   type_file.num5
	
    IF g_hrar.hrar03 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    
    LET l_n=0 
    SELECT COUNT(*) INTO l_n FROM hras_file WHERE hras03=g_hrar.hrar03
    IF l_n>0 THEN
    	 CALL cl_err(g_hrar.hrar03,'ghr-018',0)
    	 RETURN
    END IF	
        	
    BEGIN WORK

    OPEN i004_cl USING g_hrar.hrar03
    IF STATUS THEN
       CALL cl_err("OPEN i004_cl:", STATUS, 0)
       CLOSE i004_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i004_cl INTO g_hrar.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrar.hrar03,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i004_show()
    IF cl_delete() THEN
       LET g_doc.column1 = "hrar03"
       LET g_doc.value1 = g_hrar.hrar03
       CALL cl_del_doc()
       DELETE FROM hrar_file WHERE hrar03 = g_hrar.hrar03

       CLEAR FORM
       OPEN i004_count
       #FUN-B50065-add-start--
       IF STATUS THEN
          CLOSE i004_cl
          CLOSE i004_count
          COMMIT WORK
          RETURN
       END IF
       FETCH i004_count INTO g_row_count
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i004_cl
          CLOSE i004_count
          COMMIT WORK
          CALL i004_b_fill(g_wc)
          RETURN
       END IF
       DISPLAY g_row_count TO FORMONLY.cnt

       OPEN i004_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i004_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE                 #No.FUN-6A0066
          CALL i004_fetch('/')
       END IF
    END IF
    CLOSE i004_cl
    COMMIT WORK
    CALL i004_b_fill(g_wc)
END FUNCTION


{
PRIVATE FUNCTION i004_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1

   IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("hrar00,hrar01,hrar05",TRUE)
   END IF
END FUNCTION


PRIVATE FUNCTION i004_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1

   IF p_cmd = 'u' AND g_chkey = 'N' THEN
      CALL cl_set_comp_entry("hrar00,hrar01,hrar05",FALSE)
   END IF
END FUNCTION
}
	
FUNCTION i004_gen_pre(p_hraa01,p_hraa10)
DEFINE p_hraa01     LIKE 	  hraa_file.hraa01
DEFINE p_hraa10     LIKE    hraa_file.hraa10
DEFINE l_hram       RECORD LIKE   hram_file.*
DEFINE l_hraa10     LIKE    hraa_file.hraa10
DEFINE l_hrar01     LIKE    hrar_file.hrar01
  
       IF cl_null(p_hraa01) THEN RETURN END IF
       	 
       INITIALIZE l_hram.* TO NULL  
       SELECT * INTO l_hram.* FROM hram_file WHERE hram02=p_hraa01 AND hram12='Y'
                                               AND hram01='001'
       IF NOT cl_null(l_hram.hram01) AND l_hram.hram12='Y' THEN
       	  CALL i004_gen(l_hram.*) 
       ELSE
       	  SELECT hraa10 INTO l_hraa10 FROM hraa_file WHERE hraa01=p_hraa10 AND hraaacti='Y'       	    	                                             
          CALL i004_gen_pre(p_hraa10,l_hraa10)
       END IF
       	
#       RETURN l_hrar01	

END FUNCTION
	
FUNCTION i004_gen(p_hram)	       	   
DEFINE  p_hram      RECORD LIKE   hram_file.*
DEFINE  l_check     LIKE    type_file.chr1000
DEFINE  l_check1    LIKE    type_file.chr1000
DEFINE  l_check2    LIKE    type_file.chr1000
DEFINE  l_str       STRING
DEFINE  l_str2      STRING
DEFINE  l_str3      STRING
DEFINE  l_length    LIKE    type_file.num5
DEFINE  l_hrar03    LIKE    hrar_file.hrar03
DEFINE  l_format    STRING
DEFINE  l_sql       STRING
DEFINE  l_i         LIKE    type_file.num5
    
     LET g_hrar03=''
    
     LET l_str=''
	   CASE p_hram.hram09
	     WHEN 'N'    LET l_str2=''
	   	 WHEN 'Y'    IF p_hram.hram10='1' THEN LET l_str2=' ' END IF
	   	 	           IF p_hram.hram10='2' THEN LET l_str2='_' END IF 		
	   END CASE
	   	
	     IF NOT cl_null(p_hram.hram03) THEN
	     	  LET l_str=l_str.trim()
	     	  LET l_str=l_str CLIPPED,p_hram.hram03
	     END IF
	     	
	     IF p_hram.hram05='Y' THEN
	     	  LET l_str=l_str.trim()
	     	  IF cl_null(l_str) THEN	     	  
	     	     LET l_str=l_str CLIPPED,p_hram.hram06
	     	  ELSE
	     	  	 LET l_str=l_str CLIPPED,l_str2,p_hram.hram06
	     	  END IF	     
	     END IF
	     	
	     IF p_hram.hram07='Y' THEN
	     	  LET l_str=l_str.trim()
	     	  IF cl_null(l_str) THEN	     	  
	     	     LET l_str=l_str CLIPPED,'MM'
	     	  ELSE
	     	  	 LET l_str=l_str CLIPPED,l_str2,'MM'
	     	  END IF	     
	     END IF
	     	
	     IF p_hram.hram08='Y' THEN
	     	  LET l_str=l_str.trim()
	     	  IF cl_null(l_str) THEN	     	  
	     	     LET l_str=l_str CLIPPED,'DD'
	     	  ELSE
	     	  	 LET l_str=l_str CLIPPED,l_str2,'DD'
	     	  END IF	     
	     END IF
	     	
	     LET l_str=l_str.trim()
	     LET l_check=l_str CLIPPED,l_str2,"%"
	     IF l_str2 IS NULL THEN
	     	  LET l_check1=l_str CLIPPED," %"
	     	  LET l_check2=l_str CLIPPED,"_%"
	        LET l_length=l_str.getLength()+p_hram.hram04
	     ELSE
	     	  LET l_length=l_str.getLength()+p_hram.hram04+1
	     END IF	     
       
       IF l_str2 IS NOT NULL THEN
          LET l_sql=" SELECT MAX(hrar03) FROM hrar_file WHERE hrar01 LIKE '",l_check,"'",
                    "                                     AND length(hrar03)=",l_length
       ELSE
       	  LET l_sql=" SELECT MAX(hrar03) FROM hrar_file WHERE hrar01 LIKE '",l_check,"'",
       	            "                                     AND hrar01 NOT LIKE '",l_check1,"'",
       	            #"                                     AND hrar01 NOT LIKE '",l_check2,"'",
       	            "                                     AND instr(hrar03,'_')=0 ", 
                    "                                     AND length(hrar03)=",l_length
       END IF             
       	                	        
       PREPARE i004_gen_pre FROM l_sql
       EXECUTE i004_gen_pre INTO l_hrar03
       
       IF NOT cl_null(l_hrar03) THEN
          LET l_hrar03=l_hrar03[l_length-p_hram.hram04+1,l_length]
          LET l_hrar03=l_hrar03+1
       	  LET l_format=''
       	  FOR l_i = 1 TO p_hram.hram04
       	      LET l_format=l_format,"&"
       	  END FOR           	  
       	  LET l_hrar03=l_hrar03 USING l_format 
          LET l_hrar03=l_str CLIPPED,l_str2,l_hrar03
       ELSE
       	  LET l_hrar03=l_str CLIPPED,l_str2,p_hram.hram15
       END IF
       	
       LET l_sql=" SELECT substr('",l_hrar03,"',1,",l_length,") FROM DUAL"
       
       PREPARE i004_gen FROM l_sql
       EXECUTE i004_gen INTO l_hrar03
       
       IF p_hram.hram11='Y' THEN
       	  CALL cl_set_comp_entry("hrar03",TRUE)
       ELSE
       	  CALL cl_set_comp_entry("hrar03",FALSE)
       END IF	  	   
       
       LET g_hrar03=l_hrar03
#       RETURN l_hrar01
END FUNCTION	 	  	    
	
FUNCTION i004_b_fill(p_wc)
DEFINE p_wc     STRING
DEFINE l_sql    STRING
DEFINE l_i      LIKE   type_file.num5
		
        CALL g_hrar_b.clear()
        
        LET l_sql=" SELECT hrar01,'',hrar02,'',hrar03,hrar04,hrar06,'',hrar05,hraracti ",
                  "   FROM hrar_file WHERE ",p_wc CLIPPED,
                  "  ORDER BY hrar01 "
                  
        PREPARE i004_b_pre FROM l_sql
        DECLARE i004_b_cs CURSOR FOR i004_b_pre
        
        LET l_i=1
        
        FOREACH i004_b_cs INTO g_hrar_b[l_i].*
        
           SELECT hraa12 INTO g_hrar_b[l_i].hrar01_1_b FROM hraa_file
            WHERE hraa01=g_hrar_b[l_i].hrar01_b
           
           SELECT hrag07 INTO g_hrar_b[l_i].hrar02_1_b FROM hrag_file
            WHERE hrag01='203'
              AND hrag06=g_hrar_b[l_i].hrar02_b
           
           SELECT hrag07 INTO g_hrar_b[l_i].hrar06_1_b FROM hrag_file
            WHERE hrag01='204'
              AND hrag06=g_hrar_b[l_i].hrar06_b
              
           LET l_i=l_i+1
           
           IF l_i > g_max_rec THEN
              IF g_action_choice ="query"  THEN   #CHI-BB0034 add
                 CALL cl_err( '', 9035, 0 )
              END IF                              #CHI-BB0034 add
              EXIT FOREACH
           END IF
        END FOREACH
        CALL g_hrar_b.deleteElement(l_i)
        LET g_rec_b = l_i - 1
        DISPLAY ARRAY g_hrar_b TO s_hrar_b.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
           BEFORE DISPLAY
              EXIT DISPLAY
        END DISPLAY

END FUNCTION                  


FUNCTION i004_b_menu()
   DEFINE   l_cmd     LIKE type_file.chr1000


   WHILE TRUE

      CALL i004_bp("G")

      IF NOT cl_null(g_action_choice) AND l_ac>0 THEN #將清單的資料回傳到主畫面
         SELECT hrar_file.*
           INTO g_hrar.*
           FROM hrar_file
          WHERE hrar03=g_hrar_b[l_ac].hrar03_b
      END IF

      IF g_action_choice!= "" THEN
         LET g_bp_flag = 'Page1'
         LET l_ac = ARR_CURR()
         LET g_jump = l_ac
         LET g_no_ask = TRUE
         IF g_rec_b >0 THEN
             CALL i004_fetch('/')
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
               CALL i004_a()
            END IF
            EXIT WHILE

        WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i004_q()
            END IF
            EXIT WHILE

        WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i004_r()
            END IF

        WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i004_u()
            END IF
            EXIT WHILE

        WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i004_x()
               CALL i004_show()
            END IF
            	
        WHEN "related_document"
            IF cl_chk_act_auth() THEN
               IF g_hrar.hrar03 IS NOT NULL THEN
                  LET g_doc.column1 = "hrar03"
                  LET g_doc.value1 = g_hrar.hrar03
                  CALL cl_doc()
               END IF
            END IF    	 	

        WHEN "exporttoexcel"
           IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrar_b),'','')
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


FUNCTION i004_bp(p_ud)
   DEFINE   p_ud      LIKE type_file.chr1          #No.FUN-680126 VARCHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrar_b TO s_hrar_b.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

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
             CALL i004_fetch('/')
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
         CALL i004_fetch('/')
         CALL cl_set_comp_visible("Page2", FALSE)
         #CALL cl_set_comp_visible("Page2", TRUE)
         CALL cl_set_comp_visible("Page3", FALSE)   #NO.FUN-840018 ADD
         CALL ui.interface.refresh()                  #NO.FUN-840018 ADD
         CALL cl_set_comp_visible("Page2", TRUE)
         CALL cl_set_comp_visible("Page3", TRUE)    #NO.FUN-840018 ADD
         EXIT DISPLAY

      ON ACTION first
         CALL i004_fetch('F')
         CONTINUE DISPLAY

      ON ACTION previous
         CALL i004_fetch('P')
         CONTINUE DISPLAY

      ON ACTION jump
         CALL i004_fetch('/')
         CONTINUE DISPLAY

      ON ACTION next
         CALL i004_fetch('N')
         CONTINUE DISPLAY

      ON ACTION last
         CALL i004_fetch('L')
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
        
        			 
