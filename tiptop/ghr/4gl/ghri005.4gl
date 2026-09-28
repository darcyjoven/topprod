# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri005.4gl
# Descriptions...: 
# Date & Author..: 03/19/13 by zhangbo


DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"

DEFINE  g_hras    RECORD LIKE hras_file.*
DEFINE  g_hras_t  RECORD LIKE hras_file.*
DEFINE  g_hras_b  DYNAMIC ARRAY OF RECORD
          hras02_b    LIKE   hras_file.hras02,
          hras02_1_b  LIKE   hraa_file.hraa12,
          hras01_b    LIKE   hras_file.hras01,
          hras04_b    LIKE   hras_file.hras04,
          hras06_b    LIKE   hras_file.hras06,
          hras13_b    LIKE   hras_file.hras13,
          hras05_b    LIKE   hras_file.hras05,
          hras12_b    LIKE   hras_file.hras12,
          hras07_b    LIKE   hras_file.hras07,
          hrasud01_b  LIKE   hras_file.hrasud01,
          hrasacti_b  LIKE   hras_file.hrasacti
                  END RECORD
DEFINE  g_forupd_sql        STRING
DEFINE  g_before_input_done LIKE type_file.num5
DEFINE  g_rec_b,l_ac             LIKE type_file.num5
DEFINE  g_hras01            LIKE hras_file.hras01
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
DEFINE g_bp_flag    LIKE type_file.chr1
DEFINE g_cnt        LIKE type_file.num5


MAIN
    DEFINE
    p_row,p_col         LIKE type_file.num5      #No.FUN-680123 SMALLINT
    DEFINE  l_year      LIKE   type_file.chr10
    DEFINE  l_month     LIKE   type_file.chr10
    DEFINE  l_day       LIKE   type_file.chr10


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
 
   INITIALIZE g_hras.* TO NULL

   LET l_year=YEAR(g_today)  
   LET l_month=MONTH(g_today) USING "&&"
   LET l_day=DAY(g_today) USING "&&"

   LET g_forupd_sql = "SELECT * FROM hras_file WHERE hras01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)        
   DECLARE i005_cl CURSOR FROM g_forupd_sql                 
   
   LET p_row=15
   LET p_col=10
   OPEN WINDOW i005_w AT p_row,p_col 
     WITH FORM "ghr/42f/ghri005"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
   CALL cl_ui_init()
   
   LET g_action_choice=""
   CALL i005_menu()
 
   CLOSE WINDOW i005_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 
END MAIN

FUNCTION i005_curs()

    CLEAR FORM
    INITIALIZE g_hras.* TO NULL
    CONSTRUCT BY NAME g_wc ON                              
        hras01,hras02,hras03,hras04,hras05,hras06,
        hras07,hras08,hras09,hras10,hras11,hras12,hras13,hrasud01,hrasud02,
        hrasuser,hrasgrup,hrasmodu,hrasdate,hrasacti,hrasoriu,hrasorig

        BEFORE CONSTRUCT                                    
           CALL cl_qbe_init()                               

        ON ACTION controlp
           CASE
              WHEN INFIELD(hras02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hraa10"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.construct = "N"     #add by zhangbo130830
                 LET g_qryparam.default1 = g_hras.hras02
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hras02
                 NEXT FIELD hras02
                 
              WHEN INFIELD(hras03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrar03"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.construct = "N"     #add by zhangbo130830
                 LET g_qryparam.default1 = g_hras.hras03
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hras03
                 NEXT FIELD hras03
                 
#             WHEN INFIELD(hras06)
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = "q_hrag06"
#                 LET g_qryparam.state = "c"
#                 LET g_qryparam.construct = "N"     #add by zhangbo130830
#                 LET g_qryparam.default1 = g_hras.hras06
#                 LET g_qryparam.arg1 = '205'
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
#                 DISPLAY g_qryparam.multiret TO hras06
#                 NEXT FIELD hras06
                    
                        
             WHEN INFIELD(hras08)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.construct = "N"     #add by zhangbo130830
                 LET g_qryparam.default1 = g_hras.hras08
                 LET g_qryparam.arg1 = '317'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hras08
                 NEXT FIELD hras08

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

    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hrasuser', 'hrasgrup')  #
                                                                     #

    LET g_sql = "SELECT hras01 FROM hras_file ",                       #
                " WHERE ",g_wc CLIPPED, " ORDER BY hras01"
    PREPARE i005_prepare FROM g_sql
    DECLARE i005_cs                                                  # 
        SCROLL CURSOR WITH HOLD FOR i005_prepare

    LET g_sql = "SELECT COUNT(DISTINCT hras01) FROM hras_file WHERE ",g_wc CLIPPED
    PREPARE i005_precount FROM g_sql
    DECLARE i005_count CURSOR FOR i005_precount
END FUNCTION
	
FUNCTION i005_menu()
    DEFINE l_cmd    STRING

    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
           
        ON ACTION item_list
           LET g_action_choice = ""  #MOD-8A0193 add
           CALL i005_b_menu()   #MOD-8A0193
           LET g_action_choice = ""  #MOD-8A0193 add   

        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i005_a()
            END IF

        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i005_q()
            END IF

        ON ACTION next
            CALL i005_fetch('N')

        ON ACTION previous
            CALL i005_fetch('P')

        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i005_u()
            END IF

        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL i005_x()
            END IF

        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i005_r()
            END IF
            	
        ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                 CALL i005_copy()
            END IF 
            	
        ON ACTION ghri005_a
           LET g_action_choice="ghri005_a"
           IF cl_chk_act_auth() THEN
                CALL i005_hrasa()
           END IF
           	
        ON ACTION ghri005_b
           LET g_action_choice="ghri005_b"
           IF cl_chk_act_auth() THEN
                CALL i005_hrasb()
           END IF    	
        
        ON ACTION ghri005_c
           LET g_action_choice="ghri005_c"
           IF cl_chk_act_auth() THEN
                CALL i005_hrasc()
           END IF       	   	

        ON ACTION help
            CALL cl_show_help()

        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU

        ON ACTION jump
            CALL i005_fetch('/')

        ON ACTION first
            CALL i005_fetch('F')

        ON ACTION last
            CALL i005_fetch('L')

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
              IF g_hras.hras01 IS NOT NULL THEN
                 LET g_doc.column1 = "hras01"
                 LET g_doc.value1 = g_hras.hras01
                 CALL cl_doc()
              END IF
           END IF
           	
        ON ACTION exporttoexcel   #No.FUN-4B0020
           LET g_action_choice = 'exporttoexcel'
           IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hras_b),'','')
           END IF 
        ON ACTION ghr_import
            LET g_action_choice="ghr_import"
            IF cl_chk_act_auth() THEN
                 CALL i005_import()
            END IF  	
    END MENU

END FUNCTION


FUNCTION i005_a()

    CLEAR FORM                                   #
    INITIALIZE g_hras.* LIKE hras_file.*
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_hras.hrasuser = g_user
        LET g_hras.hrasoriu = g_user
        LET g_hras.hrasorig = g_grup
        LET g_hras.hrasgrup = g_grup               #
        LET g_hras.hrasdate = g_today
        LET g_hras.hrasacti = 'Y'
        LET g_hras.hras09 = '1'
        LET g_hras.hras10 = '1'
        CALL i005_i("a")                         #
        IF INT_FLAG THEN                         #
            INITIALIZE g_hras.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_hras.hras01 IS NULL THEN              #
            CONTINUE WHILE
        END IF
        INSERT INTO hras_file VALUES(g_hras.*)     #
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","hras_file",g_hras.hras01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660131
            CONTINUE WHILE
        ELSE
            SELECT hras01 INTO g_hras.hras01 FROM hras_file WHERE hras01 = g_hras.hras01
            CALL i005_b_fill(g_wc)
        END IF
        EXIT WHILE
    END WHILE
    	
END FUNCTION

FUNCTION i005_i(p_cmd)

   DEFINE p_cmd         LIKE type_file.chr1
   DEFINE l_input       LIKE type_file.chr1
   DEFINE l_n           LIKE type_file.num5
   DEFINE l_hraa12      LIKE hraa_file.hraa12
   DEFINE l_hraa10      LIKE hraa_file.hraa10
   DEFINE l_sql         STRING
   DEFINE l_hras02_1    LIKE hraa_file.hraa12
   DEFINE l_hras03_1    LIKE hrar_file.hrar04
   DEFINE l_hras06_1    LIKE hrag_file.hrag07
   DEFINE l_hras08_1    LIKE hrag_file.hrag07
   DEFINE l_hras11_1    LIKE hrag_file.hrag07
   
   DISPLAY BY NAME
      g_hras.hras01,g_hras.hras02,g_hras.hras03,g_hras.hras04,
      g_hras.hras05,g_hras.hras06,g_hras.hras07,g_hras.hras08,
      g_hras.hras09,g_hras.hras10,g_hras.hras11,g_hras.hras12,g_hras.hras13,g_hras.hrasud01,g_hras.hrasud02,
      g_hras.hrasuser,g_hras.hrasgrup,g_hras.hrasmodu,g_hras.hrasdate,g_hras.hrasacti

   INPUT BY NAME
      g_hras.hras02,g_hras.hras01,g_hras.hras03,g_hras.hras04,
      g_hras.hras05,g_hras.hras06,g_hras.hras07,g_hras.hras08,
      g_hras.hras09,g_hras.hras10,g_hras.hras11,g_hras.hras12,g_hras.hras13,g_hras.hrasud01,g_hras.hrasud02
      WITHOUT DEFAULTS

      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          CALL i005_set_entry(p_cmd)
          CALL i005_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
          IF p_cmd='a' THEN
          	 SELECT hraa01,hraa12 INTO g_hras.hras02,l_hras02_1 FROM hraa_file WHERE hraa10 IS NULL
          	 #CALL i005_gen_pre(g_hras.hras02,'') 
          	 #LET g_hras.hras01=g_hras01
                 CALL hr_gen_no('hras_file','hras01','002',g_hras.hras02,'') RETURNING g_hras.hras01,g_flag
                 IF g_flag='Y' THEN
                    CALL cl_set_comp_entry("hras01",TRUE)
                 ELSE
                    CALL cl_set_comp_entry("hras01",FALSE)
                 END IF
          	 DISPLAY BY NAME g_hras.hras01,g_hras.hras02
          	 DISPLAY l_hras02_1 TO hras02_1
          END IF	
      
      AFTER FIELD hras02
         IF NOT cl_null(g_hras.hras02) THEN
         	  LET l_n=0
         	  SELECT COUNT(*) INTO l_n FROM hraa_file WHERE hraa01=g_hras.hras02
         	                                            AND hraaacti='Y'
         	  IF l_n=0 THEN
         	  	 CALL cl_err(g_hras.hras02,'',0)
         	  	 NEXT FIELD hras02
         	  END IF
         	                                           	
         	  
         	  SELECT hraa12 INTO l_hras02_1 FROM hraa_file WHERE hraa01=g_hras.hras02
         	  IF p_cmd='a' THEN
         	     LET l_hraa10=''
          	     SELECT hraa10 INTO l_hraa10 FROM hraa_file WHERE hraa01=g_hras.hras02 
          	     #CALL i005_gen_pre(g_hras.hras02,l_hraa10)
          	     #LET g_hras.hras01=g_hras01
                     CALL hr_gen_no('hras_file','hras01','002',g_hras.hras02,l_hraa10) RETURNING g_hras.hras01,g_flag
                     IF g_flag='Y' THEN
                        CALL cl_set_comp_entry("hras01",TRUE)
                     ELSE
                        CALL cl_set_comp_entry("hras01",FALSE)
                     END IF
                  END IF
          	DISPLAY BY NAME g_hras.hras01,g_hras.hras02
          	DISPLAY l_hras02_1 TO hras02_1	
         ELSE
         	  NEXT FIELD hras02	  	
         END IF
         	
      AFTER FIELD hras03
         IF NOT cl_null(g_hras.hras03) THEN
         	  LET l_n=0
         	  SELECT COUNT(*) INTO l_n FROM hrar_file WHERE hrar03=g_hras.hras03
         	                                            AND hraracti='Y'
         	  IF l_n=0 THEN
         	  	 CALL cl_err('无此职务编号','!',0)
         	  	 NEXT FIELD hras03
         	  END IF
         	  	   	
         	  SELECT hrar04 INTO l_hras03_1 FROM hrar_file WHERE hrar03=g_hras.hras03
         	                                                 AND hraracti='Y'	
         	  DISPLAY l_hras03_1 TO hras03_1                                               	 		
         END IF	  			           
         	                                    	  		                                           
      AFTER FIELD hras01
         IF g_hras.hras01 IS NOT NULL THEN
         	  IF g_hras.hras01 != g_hras_t.hras01 OR g_hras_t.hras01 IS NULL THEN 
         	     LET l_n=0
               SELECT count(*) INTO l_n FROM hras_file WHERE hras01 = g_hras.hras01
               IF l_n > 0 THEN                  
                  CALL cl_err(g_hras.hras01,-239,1)
                  LET g_hras.hras01 = g_hras_t.hras01
                  DISPLAY BY NAME g_hras.hras01
                  NEXT FIELD hras01
               END IF
            END IF   	
         END IF
         	
      AFTER FIELD hras04
         IF NOT cl_null(g_hras.hras04) THEN
         	  IF g_hras.hras04 != g_hras_t.hras04 OR g_hras_t.hras04 IS NULL THEN 
         	  	 LET l_n=0
         	  	 SELECT COUNT(*) INTO l_n FROM hras_file WHERE hras04=g_hras.hras04
         	  	 IF l_n>0 THEN
         	  	 	  CALL cl_err(g_hras.hras04,-239,1)
         	  	 	  NEXT FIELD hras04
         	  	 END IF
         	  END IF   	
         END IF	  		 		
         	
#      AFTER FIELD hras06
#         IF NOT cl_null(g_hras.hras06) THEN
#            
#            LET l_n=0
#         	  SELECT COUNT(*) INTO l_n FROM hrag_file WHERE hrag01='205'
#         	                                            AND hrag06=g_hras.hras06
#         	  IF l_n=0 THEN
#         	  	 CALL cl_err('无此职位等级','!',0)
#         	  	 NEXT FIELD hras06
#         	  END IF
#            SELECT hrag07 INTO l_hras06_1 FROM hrag_file WHERE hrag01='205'
#         	                                                 AND hrag06=g_hras.hras06
#         	  DISPLAY l_hras06_1 TO hras06_1                                                  	  	
#         END IF	
         	
         	
      AFTER FIELD hras08
         IF NOT cl_null(g_hras.hras08) THEN
            
            LET l_n=0
         	  SELECT COUNT(*) INTO l_n FROM hrag_file WHERE hrag01='317'
         	                                            AND hrag06=g_hras.hras08
         	  IF l_n=0 THEN
         	  	 CALL cl_err('无此学历要求','!',0)
         	  	 NEXT FIELD hras08
         	  END IF
            SELECT hrag07 INTO l_hras08_1 FROM hrag_file WHERE hrag01='317'
         	                                                 AND hrag06=g_hras.hras08
         	  DISPLAY l_hras08_1 TO hras08_1                                                  	  	
         END IF
         	    	    	 		                     	  	                    	  	   	 	                                             	    		  	      	

      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         

      ON ACTION controlp
        CASE
           WHEN INFIELD(hras02)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hraa10"
              LET g_qryparam.construct = "N"     #add by zhangbo130830
              LET g_qryparam.default1 = g_hras.hras02
              CALL cl_create_qry() RETURNING g_hras.hras02
              DISPLAY BY NAME g_hras.hras02
              NEXT FIELD hras02
           
           WHEN INFIELD(hras03)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrar03"
              LET g_qryparam.construct = "N"     #add by zhangbo130830
              LET g_qryparam.default1 = g_hras.hras02
              CALL cl_create_qry() RETURNING g_hras.hras03
              DISPLAY BY NAME g_hras.hras03
              NEXT FIELD hras03
           
#           WHEN INFIELD(hras06)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_hrag06"
#              LET g_qryparam.construct = "N"     #add by zhangbo130830
#              LET g_qryparam.default1 = g_hras.hras06
#              LET g_qryparam.arg1 = '205' 
#              CALL cl_create_qry() RETURNING g_hras.hras06
#              DISPLAY BY NAME g_hras.hras06
#              NEXT FIELD hras06
              
           WHEN INFIELD(hras08)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrag06"
              LET g_qryparam.construct = "N"     #add by zhangbo130830
              LET g_qryparam.default1 = g_hras.hras08
              LET g_qryparam.arg1 = '317'
              CALL cl_create_qry() RETURNING g_hras.hras08
              DISPLAY BY NAME g_hras.hras08
              NEXT FIELD hras08
              
           OTHERWISE
              EXIT CASE
           END CASE

      ON ACTION CONTROLZ
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLF                        # 欄位說明
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

FUNCTION i005_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_hras.* TO NULL
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i005_curs()                      
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       RETURN
    END IF
    OPEN i005_count
    FETCH i005_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i005_cs                           
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hras.hras01,SQLCA.sqlcode,0)
        INITIALIZE g_hras.* TO NULL
    ELSE
        CALL i005_fetch('F')              # 讀出TEMP第一筆並顯示
        CALL i005_b_fill(g_wc)
    END IF
END FUNCTION

FUNCTION i005_fetch(p_flhras)
    DEFINE p_flhras         LIKE type_file.chr1

    CASE p_flhras
        WHEN 'N' FETCH NEXT     i005_cs INTO g_hras.hras01
        WHEN 'P' FETCH PREVIOUS i005_cs INTO g_hras.hras01
        WHEN 'F' FETCH FIRST    i005_cs INTO g_hras.hras01
        WHEN 'L' FETCH LAST     i005_cs INTO g_hras.hras01
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
            FETCH ABSOLUTE g_jump i005_cs INTO g_hras.hras01
            LET g_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hras.hras01,SQLCA.sqlcode,0)
        INITIALIZE g_hras.* TO NULL
        LET g_hras.hras01 = NULL
        RETURN
    ELSE
      CASE p_flhras
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE

      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx
    END IF

    SELECT * INTO g_hras.* FROM hras_file    
       WHERE hras01 = g_hras.hras01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","hras_file",g_hras.hras01,"",SQLCA.sqlcode,"","",0)
    ELSE
        CALL i005_show()                 
    END IF
END FUNCTION

FUNCTION i005_show()
DEFINE l_hras02_1     LIKE     hraa_file.hraa12
DEFINE l_hras03_1     LIKE     hrar_file.hrar04	
DEFINE l_hras06_1     LIKE     hrag_file.hrag07
DEFINE l_hras08_1     LIKE     hrag_file.hrag07
DEFINE l_hras11_1     LIKE     hrag_file.hrag07

    LET g_hras_t.* = g_hras.*
    DISPLAY BY NAME g_hras.hras01,g_hras.hras02,g_hras.hras03,
                    g_hras.hras04,g_hras.hras05,g_hras.hras06,
                    g_hras.hras07,g_hras.hras08,g_hras.hras09,
                    g_hras.hras10,g_hras.hras11,g_hras.hras12,g_hras.hras13,g_hras.hrasud01,
                    g_hras.hrasud02,g_hras.hrasuser,g_hras.hrasgrup,g_hras.hrasmodu,
                    g_hras.hrasdate,g_hras.hrasacti,g_hras.hrasorig,g_hras.hrasoriu
    SELECT hraa12 INTO l_hras02_1 FROM hraa_file WHERE hraa01=g_hras.hras02
    SELECT hrar04 INTO l_hras03_1 FROM hrar_file WHERE hrar03=g_hras.hras03
#    SELECT hrag07 INTO l_hras06_1 FROM hrag_file WHERE hrag01='206'
#                                                   AND hrag06=g_hras.hras06
    SELECT hrag07 INTO l_hras08_1 FROM hrag_file WHERE hrag01='317'
                                                   AND hrag06=g_hras.hras08
                                                                                                                                               
    DISPLAY l_hras02_1 TO hras02_1
    DISPLAY l_hras03_1 TO hras03_1
#    DISPLAY l_hras06_1 TO hras06_1
    DISPLAY l_hras08_1 TO hras08_1
    CALL cl_show_fld_cont()
END FUNCTION


FUNCTION i005_u()
    IF g_hras.hras01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_hras.* FROM hras_file WHERE hras01=g_hras.hras01
    IF g_hras.hrasacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    CALL cl_opmsg('u')
    BEGIN WORK

    OPEN i005_cl USING g_hras.hras01
    IF STATUS THEN
       CALL cl_err("OPEN i005_cl:", STATUS, 1)
       CLOSE i005_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i005_cl INTO g_hras.*               #
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hras.hras01,SQLCA.sqlcode,1)
        RETURN
    END IF              
    CALL i005_show()                          
    WHILE TRUE
        CALL i005_i("u")                      
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_hras.*=g_hras_t.*
            CALL i005_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        LET g_hras.hrasmodu=g_user
        LET g_hras.hrasdate=g_today	
        UPDATE hras_file SET hras_file.* = g_hras.*    
            WHERE hras01 = g_hras_t.hras01
        UPDATE hrap_file SET hrap06=g_hras.hras04 WHERE hrap05=g_hras.hras01
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","hras_file",g_hras.hras01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
            CONTINUE WHILE
        END IF
        CALL i005_show()	
        EXIT WHILE
    END WHILE
    CLOSE i005_cl
    COMMIT WORK
    CALL i005_b_fill(g_wc)
END FUNCTION

FUNCTION i005_x()
    IF g_hras.hras01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK

    OPEN i005_cl USING g_hras.hras01
    IF STATUS THEN
       CALL cl_err("OPEN i005_cl:", STATUS, 1)
       CLOSE i005_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i005_cl INTO g_hras.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hras.hras01,SQLCA.sqlcode,1)
       RETURN
    END IF
    CALL i005_show()
    IF cl_exp(0,0,g_hras.hrasacti) THEN
        LET g_chr = g_hras.hrasacti
        IF g_hras.hrasacti='Y' THEN
            LET g_hras.hrasacti='N'
        ELSE
            LET g_hras.hrasacti='Y'
        END IF
        UPDATE hras_file
            SET hrasacti=g_hras.hrasacti
            WHERE hras01=g_hras.hras01
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(g_hras.hras01,SQLCA.sqlcode,0)
            LET g_hras.hrasacti = g_chr
        END IF
        DISPLAY BY NAME g_hras.hrasacti
    END IF
    CLOSE i005_cl
    COMMIT WORK
    CALL i005_b_fill(g_wc)
END FUNCTION

FUNCTION i005_r()
    IF g_hras.hras01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    BEGIN WORK

    OPEN i005_cl USING g_hras.hras01
    IF STATUS THEN
       CALL cl_err("OPEN i005_cl:", STATUS, 0)
       CLOSE i005_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i005_cl INTO g_hras.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hras.hras01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i005_show()
    IF cl_delete() THEN
       LET g_doc.column1 = "hras01"
       LET g_doc.value1 = g_hras.hras01
       CALL cl_del_doc()
       
       DELETE FROM hrasa_file WHERE hrasa01 = g_hras.hras01
       DELETE FROM hrasb_file WHERE hrasb01 = g_hras.hras01
       DELETE FROM hrasc_file WHERE hrasc01 = g_hras.hras01
       DELETE FROM hras_file WHERE hras01 = g_hras.hras01
       
       CLEAR FORM
       OPEN i005_count
       #FUN-B50065-add-start--
       IF STATUS THEN
          CLOSE i005_cl
          CLOSE i005_count
          COMMIT WORK
          RETURN
       END IF
       FETCH i005_count INTO g_row_count
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i005_cl
          CLOSE i005_count
          COMMIT WORK
          CALL i005_b_fill(g_wc)
          RETURN
       END IF
       DISPLAY g_row_count TO FORMONLY.cnt

       OPEN i005_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i005_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE                 #No.FUN-6A0066
          CALL i005_fetch('/')
       END IF
    END IF
    CLOSE i005_cl
    COMMIT WORK
    CALL i005_b_fill(g_wc)
END FUNCTION
	
FUNCTION i005_copy()
    DEFINE l_newno01         LIKE hras_file.hras01
    DEFINE l_newno02         LIKE hras_file.hras02
    DEFINE l_newno04         LIKE hras_file.hras04
    DEFINE l_oldno01         LIKE hras_file.hras01
    DEFINE l_oldno02         LIKE hras_file.hras02
    DEFINE l_oldno04         LIKE hras_file.hras04
    DEFINE p_cmd             LIKE type_file.chr1
    DEFINE l_input           LIKE type_file.chr1
    DEFINE l_hraa10          LIKE hraa_file.hraa10
    DEFINE l_n               LIKE type_file.num5

    IF g_hras.hras01 IS NULL THEN
       CALL cl_err('',-400,0)
        RETURN
    END IF

    LET l_input='N'
    LET g_before_input_done = FALSE
    LET g_before_input_done = TRUE

    INPUT l_newno01,l_newno02,l_newno04 FROM hras01,hras02,hras04
    
    BEFORE INPUT
       LET l_newno02=g_hras.hras02
       LET l_hraa10=''
       SELECT hraa10 INTO l_hraa10 FROM hraa_file WHERE hraa01=l_newno02 
       #CALL i005_gen_pre(l_newno02,'')
       #LET l_newno01=g_hras01
       CALL hr_gen_no('hras_file','hras01','002',l_newno02,l_hraa10) RETURNING l_newno01,g_flag
       IF g_flag='Y' THEN
          CALL cl_set_comp_entry("hras01",TRUE)
       ELSE
          CALL cl_set_comp_entry("hras01",FALSE)
       END IF
       DISPLAY l_newno02 TO hras02
       DISPLAY l_newno01 TO hras01
       
        AFTER FIELD hras02
           IF NOT cl_null(l_newno02) THEN
         	    LET l_n=0
         	    SELECT COUNT(*) INTO l_n FROM hraa_file WHERE hraa01=l_newno02
         	                                              AND hraaacti='Y'
         	    IF l_n=0 THEN
         	  	   CALL cl_err(l_newno02,'',0)
         	  	   NEXT FIELD hras02
         	    END IF
         	  
         	  LET l_hraa10=''
          	  SELECT hraa10 INTO l_hraa10 FROM hraa_file WHERE hraa01=l_newno02 
          	  #CALL i005_gen_pre(l_newno02,l_hraa10)
          	  #LET l_newno01=g_hras01
                  CALL hr_gen_no('hras_file','hras01','002',l_newno02,l_hraa10) RETURNING l_newno01,g_flag
                  IF g_flag='Y' THEN
                     CALL cl_set_comp_entry("hras01",TRUE)
                  ELSE
                     CALL cl_set_comp_entry("hras01",FALSE)
                  END IF    
              DISPLAY l_newno01 TO hras01
              DISPLAY l_newno02 TO hras02	
           ELSE
         	    NEXT FIELD hras02	  	
           END IF   

        AFTER FIELD hras01
           IF l_newno01 IS NOT NULL THEN
           	  LET l_n=0
              SELECT count(*) INTO l_n FROM hras_file WHERE hras01 = l_newno01
              IF l_n > 0 THEN
                 CALL cl_err(l_newno01,-239,0)
                 NEXT FIELD hras01
              END IF
              
           END IF
           	
         	
        AFTER FIELD hras04
           IF NOT cl_null(l_newno04) THEN
           	  LET l_n=0
         	    SELECT COUNT(*) INTO l_n FROM hras_file WHERE hras04=l_newno04
         	    IF l_n>0 THEN
         	       CALL cl_err(l_newno04,'',0)
         	       NEXT FIELD hras04
         	    END IF
         	  	
           END IF	
              		  	     	

        ON ACTION controlp                        
           IF INFIELD(hras02) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hraa10"
              LET g_qryparam.default1 = g_hras.hras02
              CALL cl_create_qry() RETURNING l_newno02
              DISPLAY l_newno02 TO hras02
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
        DISPLAY BY NAME g_hras.hras01,g_hras.hras02,g_hras.hras04
        RETURN
    END IF
    DROP TABLE x
    SELECT * FROM hras_file
        WHERE hras01=g_hras.hras01
        INTO TEMP x
    UPDATE x
        SET hras01=l_newno01,
            hras02=l_newno02,
            hras04=l_newno04,    
            hrasacti='Y',      
            hrasuser=g_user,   
            hrasgrup=g_grup,   
            hrasmodu=NULL,     
            hrasdate=g_today   

    INSERT INTO hras_file SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","hras_file",g_hras.hras01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
    ELSE
        MESSAGE 'ROW(',l_newno01,') O.K'
        LET l_oldno01 = g_hras.hras01
        LET l_oldno02 = g_hras.hras02
        LET l_oldno04 = g_hras.hras04
        LET g_hras.hras01 = l_newno01
        LET g_hras.hras02 = l_newno02
        LET g_hras.hras04 = l_newno04
        SELECT hras_file.* INTO g_hras.* FROM hras_file
               WHERE hras01 = l_newno01
        CALL i005_u()
        SELECT hras_file.* INTO g_hras.* FROM hras_file
               WHERE hras01 = l_oldno01
    END IF
    LET g_hras.hras01 = l_oldno01
    LET g_hras.hras02 = l_oldno02
    LET g_hras.hras04 = l_oldno04
    CALL i005_show()
END FUNCTION	

PRIVATE FUNCTION i005_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1

   IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("hras01",TRUE)
   END IF
END FUNCTION


PRIVATE FUNCTION i005_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1

   IF p_cmd = 'u' THEN
      CALL cl_set_comp_entry("hras01",FALSE)
   END IF
END FUNCTION
	
FUNCTION i005_gen_pre(p_hraa01,p_hraa10)
DEFINE p_hraa01     LIKE 	  hraa_file.hraa01
DEFINE p_hraa10     LIKE    hraa_file.hraa10
DEFINE l_hram       RECORD LIKE   hram_file.*
DEFINE l_hraa10     LIKE    hraa_file.hraa10
DEFINE l_hras01     LIKE    hras_file.hras01
  
       IF cl_null(p_hraa01) THEN RETURN END IF
       	 
       INITIALIZE l_hram.* TO NULL  
       SELECT * INTO l_hram.* FROM hram_file WHERE hram02=p_hraa01 AND hram12='Y'
                                               AND hram01='002'
       IF NOT cl_null(l_hram.hram01) AND l_hram.hram12='Y' THEN
       	  CALL i005_gen(l_hram.*) 
       ELSE
       	  SELECT hraa10 INTO l_hraa10 FROM hraa_file WHERE hraa01=p_hraa10 AND hraaacti='Y'       	    	                                             
          CALL i005_gen_pre(p_hraa10,l_hraa10)
       END IF
       	
#       RETURN l_hras01	

END FUNCTION
	
FUNCTION i005_gen(p_hram)	       	   
DEFINE  p_hram      RECORD LIKE   hram_file.*
DEFINE  l_check     LIKE    type_file.chr1000
DEFINE  l_check1    LIKE    type_file.chr1000
DEFINE  l_check2    LIKE    type_file.chr1000
DEFINE  l_str       STRING
DEFINE  l_str2      STRING
DEFINE  l_str3      STRING
DEFINE  l_length    LIKE    type_file.num5
DEFINE  l_hras01    LIKE    hras_file.hras01
DEFINE  l_format    STRING
DEFINE  l_sql       STRING
DEFINE  l_i         LIKE   type_file.num5

    
     LET g_hras01=''
    
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
          LET l_sql=" SELECT MAX(hras01) FROM hras_file WHERE hras01 LIKE '",l_check,"'",
                    "                                     AND length(hras01)=",l_length
       ELSE
       	  LET l_sql=" SELECT MAX(hras01) FROM hras_file WHERE hras01 LIKE '",l_check,"'",
       	            "                                     AND hras01 NOT LIKE '",l_check1,"'",
       	            #"                                     AND hras01 NOT LIKE '",l_check2,"'",
       	            "                                     AND instr(hras01,'_')=0 ", 
                    "                                     AND length(hras01)=",l_length
       END IF             
       	                	        
       PREPARE i005_gen_pre FROM l_sql
       EXECUTE i005_gen_pre INTO l_hras01
       
       IF NOT cl_null(l_hras01) THEN
          LET l_hras01=l_hras01[l_length-p_hram.hram04+1,l_length]
          LET l_hras01=l_hras01+1
       	  LET l_format=''
       	  FOR l_i = 1 TO p_hram.hram04
       	      LET l_format=l_format,"&"
       	  END FOR           	  
       	  LET l_hras01=l_hras01 USING l_format 
          LET l_hras01=l_str CLIPPED,l_str2,l_hras01
       ELSE
       	  LET l_hras01=l_str CLIPPED,l_str2,p_hram.hram15
       END IF
       	
       LET l_sql=" SELECT substr('",l_hras01,"',1,",l_length,") FROM DUAL"
       
       PREPARE i005_gen FROM l_sql
       EXECUTE i005_gen INTO l_hras01
       
       IF p_hram.hram11='Y' THEN
       	  CALL cl_set_comp_entry("hras01",TRUE)
       ELSE
       	  CALL cl_set_comp_entry("hras01",FALSE)
       END IF	  	   
       
       LET g_hras01=l_hras01
#       RETURN l_hras01
END FUNCTION	 	  	    
	
FUNCTION i005_b_fill(p_wc)
DEFINE p_wc     STRING
DEFINE l_sql    STRING
DEFINE l_i      LIKE   type_file.num5
		
        CALL g_hras_b.clear()
        
        LET l_sql=" SELECT hras02,'',hras01,hras04,hras06,hras13,hrasud01,hras05,hras12,hras07,hrasacti ",
                  "   FROM hras_file WHERE ",p_wc CLIPPED,
                  "  ORDER BY hras01 "
                  
        PREPARE i005_b_pre FROM l_sql
        DECLARE i005_b_cs CURSOR FOR i005_b_pre
        
        LET l_i=1
        
        FOREACH i005_b_cs INTO g_hras_b[l_i].*
        
           SELECT hraa12 INTO g_hras_b[l_i].hras02_1_b FROM hraa_file
            WHERE hraa01=g_hras_b[l_i].hras02_b
           
#           SELECT hrag07 INTO g_hras_b[l_i].hras06_1_b FROM hrag_file
#            WHERE hrag01='205'
#              AND hrag06=g_hras_b[l_i].hras06_b
              
           LET l_i=l_i+1
           
           IF l_i > g_max_rec THEN
              IF g_action_choice ="query"  THEN   #CHI-BB0034 add
                 CALL cl_err( '', 9035, 0 )
              END IF                              #CHI-BB0034 add
              EXIT FOREACH
           END IF
        END FOREACH
        CALL g_hras_b.deleteElement(l_i)
        LET g_rec_b = l_i - 1
        DISPLAY ARRAY g_hras_b TO s_hras_b.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
        BEFORE DISPLAY
              EXIT DISPLAY
        END DISPLAY

END FUNCTION 
	
FUNCTION i005_hrasa()
DEFINE l_hrasa   DYNAMIC ARRAY OF RECORD
         hrasa02     LIKE   hrasa_file.hrasa02,
         hrasa03     LIKE   hrasa_file.hrasa03,
         hrasa04     LIKE   hrasa_file.hrasa04,
         hrasa05     LIKE   hrasa_file.hrasa05		
         		END RECORD

DEFINE l_hrasa_t     RECORD
         hrasa02     LIKE   hrasa_file.hrasa02,
         hrasa03     LIKE   hrasa_file.hrasa03,
         hrasa04     LIKE   hrasa_file.hrasa04,
         hrasa05     LIKE   hrasa_file.hrasa05		
         		END RECORD
         		         		
DEFINE p_row,p_col       LIKE type_file.num5
DEFINE l_allow_insert    LIKE type_file.chr1
DEFINE l_allow_delete    LIKE type_file.chr1
DEFINE p_cmd             LIKE type_file.chr1
DEFINE l_rec_b           LIKE type_file.num5
DEFINE i,l_ac,l_ac_t,l_n LIKE type_file.num5
DEFINE l_max_rec         LIKE type_file.num10
DEFINE l_success         LIKE type_file.chr1 

       IF cl_null(g_hras.hras01) THEN
       	  CALL cl_err("无职位资料","!",0)
       	  RETURN
       END IF
       	
       LET p_row = 11 LET p_col = 3
       OPEN WINDOW i005a AT p_row,p_col WITH FORM "ghr/42f/ghri005a"
          ATTRIBUTE (STYLE = g_win_style CLIPPED)

       CALL cl_ui_locale("ghri005a")
       CALL l_hrasa.clear()
       LET g_sql = " SELECT hrasa02,hrasa03,hrasa04,hrasa05 ",
                   "   FROM hrasa_file",
                   "  WHERE hrasa01 = '",g_hras.hras01,"'"
       PREPARE i005_a FROM g_sql
       DECLARE i005_a_curs CURSOR FOR i005_a
   
       LET i = 1
       LET l_rec_b = 0
       FOREACH i005_a_curs INTO l_hrasa[i].*
          IF SQLCA.sqlcode THEN
             CALL cl_err('foreach hrasa',STATUS,0)
             EXIT FOREACH
          END IF
          
          LET i = i + 1
          IF i > g_max_rec THEN
              CALL cl_err( '', 9035, 0 )
              EXIT FOREACH
          END IF
       END FOREACH
       CALL l_hrasa.deleteElement(i)
       LET l_rec_b = i-1
       
       CALL cl_set_act_visible("accept,cancel", FALSE)
       DISPLAY ARRAY l_hrasa TO s_hrasa.* ATTRIBUTE(COUNT=l_rec_b,UNBUFFERED)   #=No:MOD-110308
          BEFORE DISPLAY
             LET l_ac = ARR_CURR()   		        		                 
        
       ON ACTION detail
          LET l_success='Y'
          IF g_hras.hrasacti !='Y' THEN
             LET l_success='N'
       	     CALL cl_err("资料已无效","!",0)
          END IF
          
          IF l_success ='Y' THEN 		
             CALL cl_set_act_visible("accept,cancel", TRUE)
             LET g_forupd_sql = " SELECT hrasa02,hrasa03,hrasa04,hrasa05 ",
                                "   FROM hrasa_file ",
                                "  WHERE hrasa01 = '",g_hras.hras01,"' ",
                                "    AND hrasa02 = ? ",
                                "  FOR UPDATE NOWAIT "
             DECLARE i005_a_bc1 CURSOR FROM g_forupd_sql

             LET l_allow_delete = cl_detail_input_auth("delete")
             LET l_allow_insert = cl_detail_input_auth("insert")
             
           WHILE TRUE  
             INPUT ARRAY l_hrasa WITHOUT DEFAULTS FROM s_hrasa.*
               ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED, #No.TQC-6B0067
                         INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                         APPEND ROW=l_allow_insert)

             BEFORE INPUT
               IF l_rec_b != 0 THEN
                  CALL fgl_set_arr_curr(l_ac)
               END IF

             BEFORE ROW
               LET p_cmd = ''
               LET l_ac = ARR_CURR()
               BEGIN WORK
               IF l_rec_b >= l_ac THEN
                  LET p_cmd = 'u'
                  LET l_hrasa_t.* = l_hrasa[l_ac].*
                  OPEN i005_a_bc1 USING l_hrasa_t.hrasa02
                  IF STATUS THEN
                     CALL cl_err("OPEN i005_a_bc1:", STATUS, 1)
                  ELSE
                     FETCH i005_a_bc1 INTO l_hrasa[l_ac].*
                     IF SQLCA.sqlcode THEN
                        CALL cl_err(l_hrasa_t.hrasa02,SQLCA.sqlcode,1)
                     END IF
                  END IF
               END IF

             BEFORE INSERT
               LET p_cmd = 'a'
               INITIALIZE l_hrasa[l_ac].* TO NULL
               LET l_hrasa_t.* = l_hrasa[l_ac].*
               NEXT FIELD hrasa02

             AFTER INSERT
               IF INT_FLAG THEN
                  CALL cl_err('',9001,0)
                  LET INT_FLAG = 0
                  CANCEL INSERT
               END IF
               INSERT INTO hrasa_file(hrasa01,hrasa02,hrasa03,hrasa04,hrasa05)
                VALUES(g_hras.hras01,l_hrasa[l_ac].hrasa02,l_hrasa[l_ac].hrasa03,
                       l_hrasa[l_ac].hrasa04,l_hrasa[l_ac].hrasa05)
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("ins","hrasa_file",g_hras.hras01,
                                l_hrasa[l_ac].hrasa02,SQLCA.sqlcode,"","",1)
                  CANCEL INSERT
               ELSE
                  MESSAGE 'INSERT O.K'
                  LET l_rec_b=l_rec_b+1
                  COMMIT WORK
               END IF

            ON ROW CHANGE
               IF INT_FLAG THEN
                  CALL cl_err('',9001,0)
                  LET INT_FLAG = 0
                  LET l_hrasa[l_ac].* = l_hrasa_t.*
                  CLOSE i005_a_bc1
                  ROLLBACK WORK
                  EXIT INPUT
               END IF

               UPDATE hrasa_file SET  hrasa02 = l_hrasa[l_ac].hrasa02,
                                      hrasa03 = l_hrasa[l_ac].hrasa03,
                                      hrasa04 = l_hrasa[l_ac].hrasa04,
                                      hrasa05 = l_hrasa[l_ac].hrasa05
                                WHERE hrasa01 = g_hras.hras01
                                  AND hrasa02 = l_hrasa_t.hrasa02
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","hrasa_file",g_hras.hras01,
                               l_hrasa_t.hrasa02,SQLCA.sqlcode,"","",1)
                  LET l_hrasa[l_ac].* = l_hrasa_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF

            AFTER ROW
               LET l_ac = ARR_CURR()
               LET l_ac_t = l_ac
               IF INT_FLAG THEN
                  CALL cl_err('',9001,0)
                  LET INT_FLAG = 0
                  IF p_cmd = 'u' THEN
                     LET l_hrasa[l_ac].* = l_hrasa_t.*
                  END IF
                  CLOSE i005_a_bc1
                  ROLLBACK WORK
                  EXIT INPUT
               END IF
               CLOSE i005_a_bc1
               COMMIT WORK

            BEFORE DELETE                            #是否取消單身
               IF l_hrasa_t.hrasa02 IS NOT NULL THEN
                  IF NOT cl_delete() THEN
                     CANCEL DELETE
                  END IF
                  DELETE FROM hrasa_file
                   WHERE hrasa01 = g_hras.hras01
                     AND hrasa02 = l_hrasa_t.hrasa02
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("del","hrasa_file",g_hras.hras01,l_hrasa_t.hrasa02,
                                  SQLCA.sqlcode,"","",1)
                     EXIT INPUT
                  END IF
                  LET l_rec_b=l_rec_b-1
                  COMMIT WORK

               END IF

            BEFORE FIELD hrasa02
               IF cl_null(l_hrasa[l_ac].hrasa02) OR l_hrasa[l_ac].hrasa02 = 0 THEN
                  SELECT MAX(hrasa02)+1 INTO l_hrasa[l_ac].hrasa02
                    FROM hrasa_file
                   WHERE hrasa01 = g_hras.hras01
                  IF cl_null(l_hrasa[l_ac].hrasa02) THEN
                     LET l_hrasa[l_ac].hrasa02 = 1
                  END IF
               END IF

            AFTER FIELD hrasa02
               IF NOT cl_null(l_hrasa[l_ac].hrasa02) THEN
                  IF l_hrasa[l_ac].hrasa02 != l_hrasa_t.hrasa02
                             OR cl_null(l_hrasa_t.hrasa02) THEN
                     SELECT COUNT(*) INTO l_n
                       FROM hrasa_file
                      WHERE hrasa01 = g_hras.hras01
                        AND hrasa02 = l_hrasa[l_ac].hrasa02
                     IF l_n > 0 THEN
                        CALL cl_err('',-239,0)
                        LET l_hrasa[l_ac].hrasa02 = l_hrasa_t.hrasa02
                        NEXT FIELD hrasa02
                     END IF
                  END IF
               END IF
            	
            AFTER FIELD hrasa03
               IF NOT cl_null(l_hrasa[l_ac].hrasa03) THEN    	
                  IF l_hrasa[l_ac].hrasa03 != l_hrasa_t.hrasa03
                             OR cl_null(l_hrasa_t.hrasa03) THEN
                     LET l_n=0
                     SELECT COUNT(*) INTO l_n FROM hrasa_file WHERE hrasa03=l_hrasa[l_ac].hrasa03
                                                                AND hrasa01=g_hras.hras01
                     IF l_n>0 THEN
                     	  CALL cl_err("此职责在本职位中已维护","!",0)
                     	  NEXT FIELD hrasa03
                     END IF                                 
                  END IF	
               END IF  
            
            AFTER FIELD hrasa05
               IF NOT cl_null(l_hrasa[l_ac].hrasa03) THEN
               	  IF l_hrasa[l_ac].hrasa03>100 OR l_hrasa[l_ac].hrasa03<0 THEN
               	  	 CALL cl_err("责任程度必须在0到100之间","!",0)
               	  	 NEXT FIELD hrasa05
               	  END IF
               END IF
            	
            ON ACTION exporttoexcel     #FUN-4B0038
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(l_hrasa),'','')


            ON ACTION locale
               CALL cl_dynamic_locale()
               CALL cl_show_fld_cont()

#--NO.MOD0078 start------
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE INPUT
#--NO.MOD0078 end--------

            ON ACTION controlg
               CALL cl_cmdask()

            ON ACTION about
               CALL cl_about()

            ON ACTION help
               CALL cl_show_help()

            ON ACTION CONTROLF
               CALL cl_set_focus_form(ui.Interface.getRootNode())
                  RETURNING g_fld_name,g_frm_name
               CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

            ON ACTION CONTROLZ
               CALL cl_show_req_fields()
            ON ACTION exit
               EXIT INPUT

            END INPUT
            
            LET l_n=0 
            SELECT SUM(hrasa05) INTO l_n FROM hrasa_file WHERE hrasa01=g_hras.hras01
            IF l_n != 100 THEN
            	 CALL cl_err("职责权重之和不为100","!",0)
            	 CONTINUE WHILE
            ELSE
            	 EXIT WHILE
            END IF
            	
           END WHILE  		 		 	
             
         END IF
         	
      ON ACTION accept
         LET l_success='Y'
         IF g_hras.hrasacti !='Y' THEN
             LET l_success='N'
       	     CALL cl_err("资料已无效","!",0)
         END IF
          
         IF l_success ='Y' THEN 		
             CALL cl_set_act_visible("accept,cancel", TRUE)
             LET g_forupd_sql = " SELECT hrasa02,hrasa03,hrasa04,hrasa05 ",
                                "   FROM hrasa_file ",
                                "  WHERE hrasa01 = '",g_hras.hras01,"' ",
                                "    AND hrasa02 = ? ",
                                "  FOR UPDATE NOWAIT "
             DECLARE i005_a_bc2 CURSOR FROM g_forupd_sql

             LET l_allow_delete = cl_detail_input_auth("delete")
             LET l_allow_insert = cl_detail_input_auth("insert")
             
           WHILE TRUE  
             INPUT ARRAY l_hrasa WITHOUT DEFAULTS FROM s_hrasa.*
               ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED, #No.TQC-6B0067
                         INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                         APPEND ROW=l_allow_insert)

             BEFORE INPUT
               IF l_rec_b != 0 THEN
                  CALL fgl_set_arr_curr(l_ac)
               END IF

             BEFORE ROW
               LET p_cmd = ''
               LET l_ac = ARR_CURR()
               BEGIN WORK
               IF l_rec_b >= l_ac THEN
                  LET p_cmd = 'u'
                  LET l_hrasa_t.* = l_hrasa[l_ac].*
                  OPEN i005_a_bc2 USING l_hrasa_t.hrasa02
                  IF STATUS THEN
                     CALL cl_err("OPEN i005_a_bc1:", STATUS, 1)
                  ELSE
                     FETCH i005_a_bc2 INTO l_hrasa[l_ac].*
                     IF SQLCA.sqlcode THEN
                        CALL cl_err(l_hrasa_t.hrasa02,SQLCA.sqlcode,1)
                     END IF
                  END IF
               END IF

             BEFORE INSERT
               LET p_cmd = 'a'
               INITIALIZE l_hrasa[l_ac].* TO NULL
               LET l_hrasa_t.* = l_hrasa[l_ac].*
               NEXT FIELD hrasa02

             AFTER INSERT
               IF INT_FLAG THEN
                  CALL cl_err('',9001,0)
                  LET INT_FLAG = 0
                  CANCEL INSERT
               END IF
               INSERT INTO hrasa_file(hrasa01,hrasa02,hrasa03,hrasa04,hrasa05)
                VALUES(g_hras.hras01,l_hrasa[l_ac].hrasa02,l_hrasa[l_ac].hrasa03,
                       l_hrasa[l_ac].hrasa04,l_hrasa[l_ac].hrasa05)
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("ins","hrasa_file",g_hras.hras01,
                                l_hrasa[l_ac].hrasa02,SQLCA.sqlcode,"","",1)
                  CANCEL INSERT
               ELSE
                  MESSAGE 'INSERT O.K'
                  LET l_rec_b=l_rec_b+1
                  COMMIT WORK
               END IF

            ON ROW CHANGE
               IF INT_FLAG THEN
                  CALL cl_err('',9001,0)
                  LET INT_FLAG = 0
                  LET l_hrasa[l_ac].* = l_hrasa_t.*
                  CLOSE i005_a_bc2
                  ROLLBACK WORK
                  EXIT INPUT
               END IF

               UPDATE hrasa_file SET  hrasa02 = l_hrasa[l_ac].hrasa02,
                                      hrasa03 = l_hrasa[l_ac].hrasa03,
                                      hrasa04 = l_hrasa[l_ac].hrasa04,
                                      hrasa05 = l_hrasa[l_ac].hrasa05
                                WHERE hrasa01 = g_hras.hras01
                                  AND hrasa02 = l_hrasa_t.hrasa02
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","hrasa_file",g_hras.hras01,
                               l_hrasa_t.hrasa02,SQLCA.sqlcode,"","",1)
                  LET l_hrasa[l_ac].* = l_hrasa_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF

            AFTER ROW
               LET l_ac = ARR_CURR()
               LET l_ac_t = l_ac
               IF INT_FLAG THEN
                  CALL cl_err('',9001,0)
                  LET INT_FLAG = 0
                  IF p_cmd = 'u' THEN
                     LET l_hrasa[l_ac].* = l_hrasa_t.*
                  END IF
                  CLOSE i005_a_bc2
                  ROLLBACK WORK
                  EXIT INPUT
               END IF
               CLOSE i005_a_bc2
               COMMIT WORK

            BEFORE DELETE                            #是否取消單身
               IF l_hrasa_t.hrasa02 IS NOT NULL THEN
                  IF NOT cl_delete() THEN
                     CANCEL DELETE
                  END IF
                  DELETE FROM hrasa_file
                   WHERE hrasa01 = g_hras.hras01
                     AND hrasa02 = l_hrasa_t.hrasa02
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("del","hrasa_file",g_hras.hras01,l_hrasa_t.hrasa02,
                                  SQLCA.sqlcode,"","",1)
                     EXIT INPUT
                  END IF
                  LET l_rec_b=l_rec_b-1
                  COMMIT WORK

               END IF

            BEFORE FIELD hrasa02
               IF cl_null(l_hrasa[l_ac].hrasa02) OR l_hrasa[l_ac].hrasa02 = 0 THEN
                  SELECT MAX(hrasa02)+1 INTO l_hrasa[l_ac].hrasa02
                    FROM hrasa_file
                   WHERE hrasa01 = g_hras.hras01
                  IF cl_null(l_hrasa[l_ac].hrasa02) THEN
                     LET l_hrasa[l_ac].hrasa02 = 1
                  END IF
               END IF

            AFTER FIELD hrasa02
               IF NOT cl_null(l_hrasa[l_ac].hrasa02) THEN
                  IF l_hrasa[l_ac].hrasa02 != l_hrasa_t.hrasa02
                             OR cl_null(l_hrasa_t.hrasa02) THEN
                     SELECT COUNT(*) INTO l_n
                       FROM hrasa_file
                      WHERE hrasa01 = g_hras.hras01
                        AND hrasa02 = l_hrasa[l_ac].hrasa02
                     IF l_n > 0 THEN
                        CALL cl_err('',-239,0)
                        LET l_hrasa[l_ac].hrasa02 = l_hrasa_t.hrasa02
                        NEXT FIELD hrasa02
                     END IF
                  END IF
               END IF
            	
            AFTER FIELD hrasa03
               IF NOT cl_null(l_hrasa[l_ac].hrasa03) THEN    	
                  IF l_hrasa[l_ac].hrasa03 != l_hrasa_t.hrasa03
                             OR cl_null(l_hrasa_t.hrasa03) THEN
                     LET l_n=0
                     SELECT COUNT(*) INTO l_n FROM hrasa_file WHERE hrasa03=l_hrasa[l_ac].hrasa03
                                                                AND hrasa01=g_hras.hras01
                     IF l_n>0 THEN
                     	  CALL cl_err("此职责在本职位中已维护","!",0)
                     	  NEXT FIELD hrasa03
                     END IF                                 
                  END IF	
               END IF  
               	
            AFTER FIELD hrasa05
               IF NOT cl_null(l_hrasa[l_ac].hrasa03) THEN
               	  IF l_hrasa[l_ac].hrasa03>100 OR l_hrasa[l_ac].hrasa03<0 THEN
               	  	 CALL cl_err("责任程度必须在0到100之间","!",0)
               	  	 NEXT FIELD hrasa05
               	  END IF
               END IF	  	 	    	
         
            	
            ON ACTION exporttoexcel     #FUN-4B0038
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(l_hrasa),'','')


            ON ACTION locale
               CALL cl_dynamic_locale()
               CALL cl_show_fld_cont()

#--NO.MOD0078 start------
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE INPUT
#--NO.MOD0078 end--------

            ON ACTION controlg
               CALL cl_cmdask()

            ON ACTION about
               CALL cl_about()

            ON ACTION help
               CALL cl_show_help()

            ON ACTION CONTROLF
               CALL cl_set_focus_form(ui.Interface.getRootNode())
                  RETURNING g_fld_name,g_frm_name
               CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

            ON ACTION CONTROLZ
               CALL cl_show_req_fields()
            ON ACTION exit
               EXIT INPUT

            END INPUT
            
            LET l_n=0 
            SELECT SUM(hrasa05) INTO l_n FROM hrasa_file WHERE hrasa01=g_hras.hras01
            IF l_n != 100 THEN
            	 CALL cl_err("职责权重之和不为100","!",0)
            	 CONTINUE WHILE
            ELSE
            	 EXIT WHILE
            END IF
            	
           END WHILE  		 		 	
             
         END IF


      CLOSE i005_a_bc2
      COMMIT WORK

      CALL cl_set_act_visible("accept,cancel", FALSE)
      CONTINUE DISPLAY

      ON ACTION exit
         EXIT DISPLAY
      
      ON ACTION close
         EXIT DISPLAY   

      ON ACTION controlg
         CALL cl_cmdask()

#--NO.MOD-860078 start------
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
#--NO.MOD-860078 end--------

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)

   LET INT_FLAG=0
   CLOSE WINDOW i005a
END FUNCTION  
	
FUNCTION i005_hrasb()
DEFINE l_hrasb   DYNAMIC ARRAY OF RECORD
         hrasb02     LIKE   hrasb_file.hrasb02,
         hrasb03     LIKE   hrasb_file.hrasb03,
         hrasb04     LIKE   hrasb_file.hrasb04,
         hrasb05     LIKE   hrasb_file.hrasb05,
         hrasb06     LIKE   hrasb_file.hrasb06		
         		END RECORD

DEFINE l_hrasb_t     RECORD
         hrasb02     LIKE   hrasb_file.hrasb02,
         hrasb03     LIKE   hrasb_file.hrasb03,
         hrasb04     LIKE   hrasb_file.hrasb04,
         hrasb05     LIKE   hrasb_file.hrasb05,
         hrasb06     LIKE   hrasb_file.hrasb06		
         		END RECORD
         		         		
DEFINE p_row,p_col       LIKE type_file.num5
DEFINE l_allow_insert    LIKE type_file.chr1
DEFINE l_allow_delete    LIKE type_file.chr1
DEFINE p_cmd             LIKE type_file.chr1
DEFINE l_rec_b           LIKE type_file.num5
DEFINE i,l_ac,l_ac_t,l_n LIKE type_file.num5
DEFINE l_max_rec         LIKE type_file.num10
DEFINE l_success         LIKE type_file.chr1 

       IF cl_null(g_hras.hras01) THEN
       	  CALL cl_err("无职位资料","!",0)
       	  RETURN
       END IF
       	
       LET p_row = 11 LET p_col = 3
       OPEN WINDOW i005b AT p_row,p_col WITH FORM "ghr/42f/ghri005b"
          ATTRIBUTE (STYLE = g_win_style CLIPPED)

       CALL cl_ui_locale("ghri005b")
       CALL l_hrasb.clear()
       LET g_sql = " SELECT hrasb02,hrasb03,hrasb04,hrasb05,hrasb06 ",
                   "   FROM hrasb_file",
                   "  WHERE hrasb01 = '",g_hras.hras01,"'"
       PREPARE i005_b FROM g_sql
       DECLARE i005_b_curs CURSOR FOR i005_b
   
       LET i = 1
       LET l_rec_b = 0
       FOREACH i005_b_curs INTO l_hrasb[i].*
          IF SQLCA.sqlcode THEN
             CALL cl_err('foreach hrasb',STATUS,0)
             EXIT FOREACH
          END IF
          
          LET i = i + 1
          IF i > g_max_rec THEN
              CALL cl_err( '', 9035, 0 )
              EXIT FOREACH
          END IF
       END FOREACH
       CALL l_hrasb.deleteElement(i)
       LET l_rec_b = i-1
       
       CALL cl_set_act_visible("accept,cancel", FALSE)
       DISPLAY ARRAY l_hrasb TO s_hrasb.* ATTRIBUTE(COUNT=l_rec_b,UNBUFFERED)   #=No:MOD-110308
          BEFORE DISPLAY
             LET l_ac = ARR_CURR()   		        		                 
        
       ON ACTION detail
          LET l_success='Y'
          IF g_hras.hrasacti !='Y' THEN
             LET l_success='N'
       	     CALL cl_err("资料已无效","!",0)
          END IF
          
          IF l_success ='Y' THEN 		
             CALL cl_set_act_visible("accept,cancel", TRUE)
             LET g_forupd_sql = " SELECT hrasb02,hrasb03,hrasb04,hrasb05,hrasb06 ",
                                "   FROM hrasb_file ",
                                "  WHERE hrasb01 = '",g_hras.hras01,"' ",
                                "    AND hrasb02 = ? ",
                                "  FOR UPDATE NOWAIT "
             DECLARE i005_b_bc1 CURSOR FROM g_forupd_sql

             LET l_allow_delete = cl_detail_input_auth("delete")
             LET l_allow_insert = cl_detail_input_auth("insert")
             
           WHILE TRUE  
             INPUT ARRAY l_hrasb WITHOUT DEFAULTS FROM s_hrasb.*
               ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED, #No.TQC-6B0067
                         INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                         APPEND ROW=l_allow_insert)

             BEFORE INPUT
               IF l_rec_b != 0 THEN
                  CALL fgl_set_arr_curr(l_ac)
               END IF

             BEFORE ROW
               LET p_cmd = ''
               LET l_ac = ARR_CURR()
               BEGIN WORK
               IF l_rec_b >= l_ac THEN
                  LET p_cmd = 'u'
                  LET l_hrasb_t.* = l_hrasb[l_ac].*
                  OPEN i005_b_bc1 USING l_hrasb_t.hrasb02
                  IF STATUS THEN
                     CALL cl_err("OPEN i005_b_bc1:", STATUS, 1)
                  ELSE
                     FETCH i005_b_bc1 INTO l_hrasb[l_ac].*
                     IF SQLCA.sqlcode THEN
                        CALL cl_err(l_hrasb_t.hrasb02,SQLCA.sqlcode,1)
                     END IF
                  END IF
               END IF

             BEFORE INSERT
               LET p_cmd = 'a'
               INITIALIZE l_hrasb[l_ac].* TO NULL
               LET l_hrasb_t.* = l_hrasb[l_ac].*
               NEXT FIELD hrasb02

             AFTER INSERT
               IF INT_FLAG THEN
                  CALL cl_err('',9001,0)
                  LET INT_FLAG = 0
                  CANCEL INSERT
               END IF
               INSERT INTO hrasb_file(hrasb01,hrasb02,hrasb03,hrasb04,hrasb05,hrasb06)
                VALUES(g_hras.hras01,l_hrasb[l_ac].hrasb02,l_hrasb[l_ac].hrasb03,
                       l_hrasb[l_ac].hrasb04,l_hrasb[l_ac].hrasb05,l_hrasb[l_ac].hrasb06)
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("ins","hrasb_file",g_hras.hras01,
                                l_hrasb[l_ac].hrasb02,SQLCA.sqlcode,"","",1)
                  CANCEL INSERT
               ELSE
                  MESSAGE 'INSERT O.K'
                  LET l_rec_b=l_rec_b+1
                  COMMIT WORK
               END IF

            ON ROW CHANGE
               IF INT_FLAG THEN
                  CALL cl_err('',9001,0)
                  LET INT_FLAG = 0
                  LET l_hrasb[l_ac].* = l_hrasb_t.*
                  CLOSE i005_b_bc1
                  ROLLBACK WORK
                  EXIT INPUT
               END IF

               UPDATE hrasb_file SET  hrasb02 = l_hrasb[l_ac].hrasb02,
                                      hrasb03 = l_hrasb[l_ac].hrasb03,
                                      hrasb04 = l_hrasb[l_ac].hrasb04,
                                      hrasb05 = l_hrasb[l_ac].hrasb05,
                                      hrasb06 = l_hrasb[l_ac].hrasb06
                                WHERE hrasb01 = g_hras.hras01
                                  AND hrasb02 = l_hrasb_t.hrasb02
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","hrasb_file",g_hras.hras01,
                               l_hrasb_t.hrasb02,SQLCA.sqlcode,"","",1)
                  LET l_hrasb[l_ac].* = l_hrasb_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF

            AFTER ROW
               LET l_ac = ARR_CURR()
               LET l_ac_t = l_ac
               IF INT_FLAG THEN
                  CALL cl_err('',9001,0)
                  LET INT_FLAG = 0
                  IF p_cmd = 'u' THEN
                     LET l_hrasb[l_ac].* = l_hrasb_t.*
                  END IF
                  CLOSE i005_b_bc1
                  ROLLBACK WORK
                  EXIT INPUT
               END IF
               CLOSE i005_b_bc1
               COMMIT WORK

            BEFORE DELETE                            #是否取消單身
               IF l_hrasb_t.hrasb02 IS NOT NULL THEN
                  IF NOT cl_delete() THEN
                     CANCEL DELETE
                  END IF
                  DELETE FROM hrasb_file
                   WHERE hrasb01 = g_hras.hras01
                     AND hrasb02 = l_hrasb_t.hrasb02
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("del","hrasb_file",g_hras.hras01,l_hrasb_t.hrasb02,
                                  SQLCA.sqlcode,"","",1)
                     EXIT INPUT
                  END IF
                  LET l_rec_b=l_rec_b-1
                  COMMIT WORK

               END IF

            BEFORE FIELD hrasb02
               IF cl_null(l_hrasb[l_ac].hrasb02) OR l_hrasb[l_ac].hrasb02 = 0 THEN
                  SELECT MAX(hrasb02)+1 INTO l_hrasb[l_ac].hrasb02
                    FROM hrasb_file
                   WHERE hrasb01 = g_hras.hras01
                  IF cl_null(l_hrasb[l_ac].hrasb02) THEN
                     LET l_hrasb[l_ac].hrasb02 = 1
                  END IF
               END IF

            AFTER FIELD hrasb02
               IF NOT cl_null(l_hrasb[l_ac].hrasb02) THEN
                  IF l_hrasb[l_ac].hrasb02 != l_hrasb_t.hrasb02
                             OR cl_null(l_hrasb_t.hrasb02) THEN
                     SELECT COUNT(*) INTO l_n
                       FROM hrasb_file
                      WHERE hrasb01 = g_hras.hras01
                        AND hrasb02 = l_hrasb[l_ac].hrasb02
                     IF l_n > 0 THEN
                        CALL cl_err('',-239,0)
                        LET l_hrasb[l_ac].hrasb02 = l_hrasb_t.hrasb02
                        NEXT FIELD hrasb02
                     END IF
                  END IF
               END IF
            	
            AFTER FIELD hrasb03
               IF NOT cl_null(l_hrasb[l_ac].hrasb03) THEN    	
                  IF l_hrasb[l_ac].hrasb03 != l_hrasb_t.hrasb03
                             OR cl_null(l_hrasb_t.hrasb03) THEN
                     LET l_n=0
                     SELECT COUNT(*) INTO l_n FROM hrasb_file WHERE hrasb03=l_hrasb[l_ac].hrasb03
                                                                AND hrasb01=g_hras.hras01
                     IF l_n>0 THEN
                     	  CALL cl_err("此指标在本职位中已维护","!",0)
                     	  NEXT FIELD hrasb03
                     END IF                                 
                  END IF	
               END IF  
            
            AFTER FIELD hrasb04
               IF NOT cl_null(l_hrasb[l_ac].hrasb04) THEN
               	  IF l_hrasb[l_ac].hrasb04<0 OR l_hrasb[l_ac].hrasb04>100 THEN
               	  	 CALL cl_err("权重必须在0到100之间","!",0)
               	  	 NEXT FIELD hrasb04
               	  END IF
               END IF	  		 
            	
            ON ACTION exporttoexcel     #FUN-4B0038
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(l_hrasb),'','')


            ON ACTION locale
               CALL cl_dynamic_locale()
               CALL cl_show_fld_cont()

#--NO.MOD0078 start------
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE INPUT
#--NO.MOD0078 end--------

            ON ACTION controlg
               CALL cl_cmdask()

            ON ACTION about
               CALL cl_about()

            ON ACTION help
               CALL cl_show_help()

            ON ACTION CONTROLF
               CALL cl_set_focus_form(ui.Interface.getRootNode())
                  RETURNING g_fld_name,g_frm_name
               CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

            ON ACTION CONTROLZ
               CALL cl_show_req_fields()
            ON ACTION exit
               EXIT INPUT

            END INPUT
            
            LET l_n=0 
            SELECT SUM(hrasb04) INTO l_n FROM hrasb_file WHERE hrasb01=g_hras.hras01
            IF l_n != 100 THEN
            	 CALL cl_err("职责权重之和不为100","!",0)
            	 CONTINUE WHILE
            ELSE
            	 EXIT WHILE
            END IF
            	
           END WHILE  		 		 	
             
         END IF
         	
      ON ACTION accept
         LET l_success='Y'
         IF g_hras.hrasacti !='Y' THEN
             LET l_success='N'
       	     CALL cl_err("资料已无效","!",0)
         END IF
          
         IF l_success ='Y' THEN 		
             CALL cl_set_act_visible("accept,cancel", TRUE)
             LET g_forupd_sql = " SELECT hrasb02,hrasb03,hrasb04,hrasb05,hrasb06 ",
                                "   FROM hrasb_file ",
                                "  WHERE hrasb01 = '",g_hras.hras01,"' ",
                                "    AND hrasb02 = ? ",
                                "  FOR UPDATE NOWAIT "
             DECLARE i005_b_bc2 CURSOR FROM g_forupd_sql

             LET l_allow_delete = cl_detail_input_auth("delete")
             LET l_allow_insert = cl_detail_input_auth("insert")
             
           WHILE TRUE  
             INPUT ARRAY l_hrasb WITHOUT DEFAULTS FROM s_hrasb.*
               ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED, #No.TQC-6B0067
                         INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                         APPEND ROW=l_allow_insert)

             BEFORE INPUT
               IF l_rec_b != 0 THEN
                  CALL fgl_set_arr_curr(l_ac)
               END IF

             BEFORE ROW
               LET p_cmd = ''
               LET l_ac = ARR_CURR()
               BEGIN WORK
               IF l_rec_b >= l_ac THEN
                  LET p_cmd = 'u'
                  LET l_hrasb_t.* = l_hrasb[l_ac].*
                  OPEN i005_b_bc2 USING l_hrasb_t.hrasb02
                  IF STATUS THEN
                     CALL cl_err("OPEN i005_b_bc2:", STATUS, 1)
                  ELSE
                     FETCH i005_b_bc2 INTO l_hrasb[l_ac].*
                     IF SQLCA.sqlcode THEN
                        CALL cl_err(l_hrasb_t.hrasb02,SQLCA.sqlcode,1)
                     END IF
                  END IF
               END IF

             BEFORE INSERT
               LET p_cmd = 'a'
               INITIALIZE l_hrasb[l_ac].* TO NULL
               LET l_hrasb_t.* = l_hrasb[l_ac].*
               NEXT FIELD hrasb02

             AFTER INSERT
               IF INT_FLAG THEN
                  CALL cl_err('',9001,0)
                  LET INT_FLAG = 0
                  CANCEL INSERT
               END IF
               INSERT INTO hrasb_file(hrasb01,hrasb02,hrasb03,hrasb04,hrasb05,hrasb06)
                VALUES(g_hras.hras01,l_hrasb[l_ac].hrasb02,l_hrasb[l_ac].hrasb03,
                       l_hrasb[l_ac].hrasb04,l_hrasb[l_ac].hrasb05,l_hrasb[l_ac].hrasb06)
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("ins","hrasb_file",g_hras.hras01,
                                l_hrasb[l_ac].hrasb02,SQLCA.sqlcode,"","",1)
                  CANCEL INSERT
               ELSE
                  MESSAGE 'INSERT O.K'
                  LET l_rec_b=l_rec_b+1
                  COMMIT WORK
               END IF

            ON ROW CHANGE
               IF INT_FLAG THEN
                  CALL cl_err('',9001,0)
                  LET INT_FLAG = 0
                  LET l_hrasb[l_ac].* = l_hrasb_t.*
                  CLOSE i005_b_bc2
                  ROLLBACK WORK
                  EXIT INPUT
               END IF

               UPDATE hrasb_file SET  hrasb02 = l_hrasb[l_ac].hrasb02,
                                      hrasb03 = l_hrasb[l_ac].hrasb03,
                                      hrasb04 = l_hrasb[l_ac].hrasb04,
                                      hrasb05 = l_hrasb[l_ac].hrasb05,
                                      hrasb06 = l_hrasb[l_ac].hrasb06
                                WHERE hrasb01 = g_hras.hras01
                                  AND hrasb02 = l_hrasb_t.hrasb02
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","hrasb_file",g_hras.hras01,
                               l_hrasb_t.hrasb02,SQLCA.sqlcode,"","",1)
                  LET l_hrasb[l_ac].* = l_hrasb_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF

            AFTER ROW
               LET l_ac = ARR_CURR()
               LET l_ac_t = l_ac
               IF INT_FLAG THEN
                  CALL cl_err('',9001,0)
                  LET INT_FLAG = 0
                  IF p_cmd = 'u' THEN
                     LET l_hrasb[l_ac].* = l_hrasb_t.*
                  END IF
                  CLOSE i005_b_bc2
                  ROLLBACK WORK
                  EXIT INPUT
               END IF
               CLOSE i005_b_bc2
               COMMIT WORK

            BEFORE DELETE                            #是否取消單身
               IF l_hrasb_t.hrasb02 IS NOT NULL THEN
                  IF NOT cl_delete() THEN
                     CANCEL DELETE
                  END IF
                  DELETE FROM hrasb_file
                   WHERE hrasb01 = g_hras.hras01
                     AND hrasb02 = l_hrasb_t.hrasb02
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("del","hrasb_file",g_hras.hras01,l_hrasb_t.hrasb02,
                                  SQLCA.sqlcode,"","",1)
                     EXIT INPUT
                  END IF
                  LET l_rec_b=l_rec_b-1
                  COMMIT WORK

               END IF

            BEFORE FIELD hrasb02
               IF cl_null(l_hrasb[l_ac].hrasb02) OR l_hrasb[l_ac].hrasb02 = 0 THEN
                  SELECT MAX(hrasb02)+1 INTO l_hrasb[l_ac].hrasb02
                    FROM hrasb_file
                   WHERE hrasb01 = g_hras.hras01
                  IF cl_null(l_hrasb[l_ac].hrasb02) THEN
                     LET l_hrasb[l_ac].hrasb02 = 1
                  END IF
               END IF

            AFTER FIELD hrasb02
               IF NOT cl_null(l_hrasb[l_ac].hrasb02) THEN
                  IF l_hrasb[l_ac].hrasb02 != l_hrasb_t.hrasb02
                             OR cl_null(l_hrasb_t.hrasb02) THEN
                     SELECT COUNT(*) INTO l_n
                       FROM hrasb_file
                      WHERE hrasb01 = g_hras.hras01
                        AND hrasb02 = l_hrasb[l_ac].hrasb02
                     IF l_n > 0 THEN
                        CALL cl_err('',-239,0)
                        LET l_hrasb[l_ac].hrasb02 = l_hrasb_t.hrasb02
                        NEXT FIELD hrasb02
                     END IF
                  END IF
               END IF
            	
            AFTER FIELD hrasb03
               IF NOT cl_null(l_hrasb[l_ac].hrasb03) THEN    	
                  IF l_hrasb[l_ac].hrasb03 != l_hrasb_t.hrasb03
                             OR cl_null(l_hrasb_t.hrasb03) THEN
                     LET l_n=0
                     SELECT COUNT(*) INTO l_n FROM hrasb_file WHERE hrasb03=l_hrasb[l_ac].hrasb03
                                                                AND hrasb01=g_hras.hras01
                     IF l_n>0 THEN
                     	  CALL cl_err("此指标在本职位中已维护","!",0)
                     	  NEXT FIELD hrasb03
                     END IF                                 
                  END IF	
               END IF  
            
            AFTER FIELD hrasb04
               IF NOT cl_null(l_hrasb[l_ac].hrasb04) THEN
               	  IF l_hrasb[l_ac].hrasb04<0 OR l_hrasb[l_ac].hrasb04>100 THEN
               	  	 CALL cl_err("权重必须在0到100之间","!",0)
               	  	 NEXT FIELD hrasb04
               	  END IF
               END IF	  		 
            	
            ON ACTION exporttoexcel     #FUN-4B0038
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(l_hrasb),'','')


            ON ACTION locale
               CALL cl_dynamic_locale()
               CALL cl_show_fld_cont()

#--NO.MOD0078 start------
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE INPUT
#--NO.MOD0078 end--------

            ON ACTION controlg
               CALL cl_cmdask()

            ON ACTION about
               CALL cl_about()

            ON ACTION help
               CALL cl_show_help()

            ON ACTION CONTROLF
               CALL cl_set_focus_form(ui.Interface.getRootNode())
                  RETURNING g_fld_name,g_frm_name
               CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

            ON ACTION CONTROLZ
               CALL cl_show_req_fields()
            ON ACTION exit
               EXIT INPUT

            END INPUT
            
            LET l_n=0 
            SELECT SUM(hrasb04) INTO l_n FROM hrasb_file WHERE hrasb01=g_hras.hras01
            IF l_n != 100 THEN
            	 CALL cl_err("职责权重之和不为100","!",0)
            	 CONTINUE WHILE
            ELSE
            	 EXIT WHILE
            END IF
            	
           END WHILE  		 		 	
             
         END IF


      CLOSE i005_b_bc2
      COMMIT WORK

      CALL cl_set_act_visible("accept,cancel", FALSE)
      CONTINUE DISPLAY

      ON ACTION exit
         EXIT DISPLAY
         
      ON ACTION close
         EXIT DISPLAY   

      ON ACTION controlg
         CALL cl_cmdask()

#--NO.MOD-860078 start------
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
#--NO.MOD-860078 end--------

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)

   LET INT_FLAG=0
   CLOSE WINDOW i005b

END FUNCTION   
	
FUNCTION i005_hrasc()
DEFINE l_hrasc   DYNAMIC ARRAY OF RECORD
         hrasc02     LIKE   hrasc_file.hrasc02,
         hrasc03     LIKE   hrasc_file.hrasc03,
         hrasc04     LIKE   hrasc_file.hrasc04,
         hrasc05     LIKE   hrasc_file.hrasc05,
         hrasc06     LIKE   hrasc_file.hrasc06,
         hrasc07     LIKE   hrasc_file.hrasc07		
         		END RECORD

DEFINE l_hrasc_t     RECORD
         hrasc02     LIKE   hrasc_file.hrasc02,
         hrasc03     LIKE   hrasc_file.hrasc03,
         hrasc04     LIKE   hrasc_file.hrasc04,
         hrasc05     LIKE   hrasc_file.hrasc05,
         hrasc06     LIKE   hrasc_file.hrasc06,
         hrasc07     LIKE   hrasc_file.hrasc07		
         		END RECORD
         		         		
DEFINE p_row,p_col       LIKE type_file.num5
DEFINE l_allow_insert    LIKE type_file.chr1
DEFINE l_allow_delete    LIKE type_file.chr1
DEFINE p_cmd             LIKE type_file.chr1
DEFINE l_rec_b           LIKE type_file.num5
DEFINE i,l_ac,l_ac_t,l_n LIKE type_file.num5
DEFINE l_max_rec         LIKE type_file.num10
DEFINE l_success         LIKE type_file.chr1 

       IF cl_null(g_hras.hras01) THEN
       	  CALL cl_err("无职位资料","!",0)
       	  RETURN
       END IF
       	
       LET p_row = 11 LET p_col = 3
       OPEN WINDOW i005c AT p_row,p_col WITH FORM "ghr/42f/ghri005c"
          ATTRIBUTE (STYLE = g_win_style CLIPPED)

       CALL cl_ui_locale("ghri005c")
       CALL l_hrasc.clear()
       LET g_sql = " SELECT hrasc02,hrasc03,hrasc04,hrasc05,hrasc06,hrasc07 ",
                   "   FROM hrasc_file",
                   "  WHERE hrasc01 = '",g_hras.hras01,"'"
       PREPARE i005_c FROM g_sql
       DECLARE i005_c_curs CURSOR FOR i005_c
   
       LET i = 1
       LET l_rec_b = 0
       FOREACH i005_c_curs INTO l_hrasc[i].*
          IF SQLCA.sqlcode THEN
             CALL cl_err('foreach hrasc',STATUS,0)
             EXIT FOREACH
          END IF        
          
          LET i = i + 1
          IF i > g_max_rec THEN
              CALL cl_err( '', 9035, 0 )
              EXIT FOREACH
          END IF
       END FOREACH
       CALL l_hrasc.deleteElement(i)
       LET l_rec_b = i-1
       
       CALL cl_set_act_visible("accept,cancel", FALSE)
       DISPLAY ARRAY l_hrasc TO s_hrasc.* ATTRIBUTE(COUNT=l_rec_b,UNBUFFERED)   #=No:MOD-110308
          BEFORE DISPLAY
             LET l_ac = ARR_CURR()   		        		                 
        
       ON ACTION detail
          LET l_success='Y'
          IF g_hras.hrasacti !='Y' THEN
             LET l_success='N'
       	     CALL cl_err("资料已无效","!",0)
          END IF
          
          IF l_success ='Y' THEN 		
             CALL cl_set_act_visible("accept,cancel", TRUE)
             LET g_forupd_sql = " SELECT hrasc02,hrasc03,hrasc04,hrasc05,hrasc06,hrasc07 ",
                                "   FROM hrasc_file ",
                                "  WHERE hrasc01 = '",g_hras.hras01,"' ",
                                "    AND hrasc02 = ? ",
                                "  FOR UPDATE NOWAIT "
             DECLARE i005_c_bc1 CURSOR FROM g_forupd_sql

             LET l_allow_delete = cl_detail_input_auth("delete")
             LET l_allow_insert = cl_detail_input_auth("insert")
              
             INPUT ARRAY l_hrasc WITHOUT DEFAULTS FROM s_hrasc.*
               ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED, #No.TQC-6B0067
                         INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                         APPEND ROW=l_allow_insert)

             BEFORE INPUT
               IF l_rec_b != 0 THEN
                  CALL fgl_set_arr_curr(l_ac)
               END IF

             BEFORE ROW
               LET p_cmd = ''
               LET l_ac = ARR_CURR()
               BEGIN WORK
               IF l_rec_b >= l_ac THEN
                  LET p_cmd = 'u'
                  LET l_hrasc_t.* = l_hrasc[l_ac].*
                  OPEN i005_c_bc1 USING l_hrasc_t.hrasc02
                  IF STATUS THEN
                     CALL cl_err("OPEN i005_c_bc1:", STATUS, 1)
                  ELSE
                     FETCH i005_c_bc1 INTO l_hrasc[l_ac].*
                     IF SQLCA.sqlcode THEN
                        CALL cl_err(l_hrasc_t.hrasc02,SQLCA.sqlcode,1)
                     END IF
                  END IF
               END IF

             BEFORE INSERT
               LET p_cmd = 'a'
               INITIALIZE l_hrasc[l_ac].* TO NULL
               LET l_hrasc_t.* = l_hrasc[l_ac].*
               NEXT FIELD hrasc02

             AFTER INSERT
               IF INT_FLAG THEN
                  CALL cl_err('',9001,0)
                  LET INT_FLAG = 0
                  CANCEL INSERT
               END IF
               INSERT INTO hrasc_file(hrasc01,hrasc02,hrasc03,hrasc04,hrasc05,hrasc06,hrasc07)
                VALUES(g_hras.hras01,l_hrasc[l_ac].hrasc02,l_hrasc[l_ac].hrasc03,
                       l_hrasc[l_ac].hrasc04,l_hrasc[l_ac].hrasc05,l_hrasc[l_ac].hrasc06,
                       l_hrasc[l_ac].hrasc07)
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("ins","hrasc_file",g_hras.hras01,
                                l_hrasc[l_ac].hrasc02,SQLCA.sqlcode,"","",1)
                  CANCEL INSERT
               ELSE
                  MESSAGE 'INSERT O.K'
                  LET l_rec_b=l_rec_b+1
                  COMMIT WORK
               END IF

            ON ROW CHANGE
               IF INT_FLAG THEN
                  CALL cl_err('',9001,0)
                  LET INT_FLAG = 0
                  LET l_hrasc[l_ac].* = l_hrasc_t.*
                  CLOSE i005_c_bc1
                  ROLLBACK WORK
                  EXIT INPUT
               END IF

               UPDATE hrasc_file SET  hrasc02 = l_hrasc[l_ac].hrasc02,
                                      hrasc03 = l_hrasc[l_ac].hrasc03,
                                      hrasc04 = l_hrasc[l_ac].hrasc04,
                                      hrasc05 = l_hrasc[l_ac].hrasc05,
                                      hrasc06 = l_hrasc[l_ac].hrasc06,
                                      hrasc07 = l_hrasc[l_ac].hrasc07
                                WHERE hrasc01 = g_hras.hras01
                                  AND hrasc02 = l_hrasc_t.hrasc02
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","hrasc_file",g_hras.hras01,
                               l_hrasc_t.hrasc02,SQLCA.sqlcode,"","",1)
                  LET l_hrasc[l_ac].* = l_hrasc_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF

            AFTER ROW
               LET l_ac = ARR_CURR()
               LET l_ac_t = l_ac
               IF INT_FLAG THEN
                  CALL cl_err('',9001,0)
                  LET INT_FLAG = 0
                  IF p_cmd = 'u' THEN
                     LET l_hrasc[l_ac].* = l_hrasc_t.*
                  END IF
                  CLOSE i005_c_bc1
                  ROLLBACK WORK
                  EXIT INPUT
               END IF
               CLOSE i005_c_bc1
               COMMIT WORK

            BEFORE DELETE                            #是否取消單身
               IF l_hrasc_t.hrasc02 IS NOT NULL THEN
                  IF NOT cl_delete() THEN
                     CANCEL DELETE
                  END IF
                  DELETE FROM hrasc_file
                   WHERE hrasc01 = g_hras.hras01
                     AND hrasc02 = l_hrasc_t.hrasc02
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("del","hrasc_file",g_hras.hras01,l_hrasc_t.hrasc02,
                                  SQLCA.sqlcode,"","",1)
                     EXIT INPUT
                  END IF
                  LET l_rec_b=l_rec_b-1
                  COMMIT WORK

               END IF

            BEFORE FIELD hrasc02
               IF cl_null(l_hrasc[l_ac].hrasc02) OR l_hrasc[l_ac].hrasc02 = 0 THEN
                  SELECT MAX(hrasc02)+1 INTO l_hrasc[l_ac].hrasc02
                    FROM hrasc_file
                   WHERE hrasc01 = g_hras.hras01
                  IF cl_null(l_hrasc[l_ac].hrasc02) THEN
                     LET l_hrasc[l_ac].hrasc02 = 1
                  END IF
               END IF

            AFTER FIELD hrasc02
               IF NOT cl_null(l_hrasc[l_ac].hrasc02) THEN
                  IF l_hrasc[l_ac].hrasc02 != l_hrasc_t.hrasc02
                             OR cl_null(l_hrasc_t.hrasc02) THEN
                     SELECT COUNT(*) INTO l_n
                       FROM hrasc_file
                      WHERE hrasc01 = g_hras.hras01
                        AND hrasc02 = l_hrasc[l_ac].hrasc02
                     IF l_n > 0 THEN
                        CALL cl_err('',-239,0)
                        LET l_hrasc[l_ac].hrasc02 = l_hrasc_t.hrasc02
                        NEXT FIELD hrasc02
                     END IF
                  END IF
               END IF
            	
            AFTER FIELD hrasc03
               IF NOT cl_null(l_hrasc[l_ac].hrasc03) THEN    	
                  IF l_hrasc[l_ac].hrasc03 != l_hrasc_t.hrasc03
                             OR cl_null(l_hrasc_t.hrasc03) THEN
                     LET l_n=0
                     SELECT COUNT(*) INTO l_n FROM hrasc_file WHERE hrasc03=l_hrasc[l_ac].hrasc03
                                                                AND hrasc01=g_hras.hras01
                     IF l_n>0 THEN
                     	  CALL cl_err("此课程编号在本职位中已维护","!",0)
                     	  NEXT FIELD hrasc03
                     END IF                                 
                  END IF	
               END IF  
            
            AFTER FIELD hrasc04
               IF NOT cl_null(l_hrasc[l_ac].hrasc04) THEN    	
                  IF l_hrasc[l_ac].hrasc04 != l_hrasc_t.hrasc04
                             OR cl_null(l_hrasc_t.hrasc04) THEN
                     LET l_n=0
                     SELECT COUNT(*) INTO l_n FROM hrasc_file WHERE hrasc04=l_hrasc[l_ac].hrasc04
                                                                AND hrasc01=g_hras.hras01
                     IF l_n>0 THEN
                     	  CALL cl_err("此课程名称在本职位中已维护","!",0)
                     	  NEXT FIELD hrasc04
                     END IF                                 
                  END IF	
               END IF 
               			    		                                            		 
            	
            ON ACTION exporttoexcel     #FUN-4B0038
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(l_hrasc),'','')


            ON ACTION locale
               CALL cl_dynamic_locale()
               CALL cl_show_fld_cont()

#--NO.MOD0078 start------
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE INPUT
#--NO.MOD0078 end--------

            ON ACTION controlg
               CALL cl_cmdask()

            ON ACTION about
               CALL cl_about()

            ON ACTION help
               CALL cl_show_help()

            ON ACTION CONTROLF
               CALL cl_set_focus_form(ui.Interface.getRootNode())
                  RETURNING g_fld_name,g_frm_name
               CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

            ON ACTION CONTROLZ
               CALL cl_show_req_fields()
            ON ACTION exit
               EXIT INPUT

            END INPUT	 		 	
             
         END IF	
       
       ON ACTION accept
         LET l_success='Y'
          IF g_hras.hrasacti !='Y' THEN
             LET l_success='N'
       	     CALL cl_err("资料已无效","!",0)
          END IF
          
          IF l_success ='Y' THEN 		
             CALL cl_set_act_visible("accept,cancel", TRUE)
             LET g_forupd_sql = " SELECT hrasc02,hrasc03,hrasc04,hrasc05,hrasc06,hrasc07 ",
                                "   FROM hrasc_file ",
                                "  WHERE hrasc01 = '",g_hras.hras01,"' ",
                                "    AND hrasc02 = ? ",
                                "  FOR UPDATE NOWAIT "
             DECLARE i005_c_bc2 CURSOR FROM g_forupd_sql

             LET l_allow_delete = cl_detail_input_auth("delete")
             LET l_allow_insert = cl_detail_input_auth("insert")
              
             INPUT ARRAY l_hrasc WITHOUT DEFAULTS FROM s_hrasc.*
               ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED, #No.TQC-6B0067
                         INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                         APPEND ROW=l_allow_insert)

             BEFORE INPUT
               IF l_rec_b != 0 THEN
                  CALL fgl_set_arr_curr(l_ac)
               END IF

             BEFORE ROW
               LET p_cmd = ''
               LET l_ac = ARR_CURR()
               BEGIN WORK
               IF l_rec_b >= l_ac THEN
                  LET p_cmd = 'u'
                  LET l_hrasc_t.* = l_hrasc[l_ac].*
                  OPEN i005_c_bc2 USING l_hrasc_t.hrasc02
                  IF STATUS THEN
                     CALL cl_err("OPEN i005_c_bc2:", STATUS, 1)
                  ELSE
                     FETCH i005_c_bc2 INTO l_hrasc[l_ac].*
                     IF SQLCA.sqlcode THEN
                        CALL cl_err(l_hrasc_t.hrasc02,SQLCA.sqlcode,1)
                     END IF
                  END IF
               END IF

             BEFORE INSERT
               LET p_cmd = 'a'
               INITIALIZE l_hrasc[l_ac].* TO NULL
               LET l_hrasc_t.* = l_hrasc[l_ac].*
               NEXT FIELD hrasc02

             AFTER INSERT
               IF INT_FLAG THEN
                  CALL cl_err('',9001,0)
                  LET INT_FLAG = 0
                  CANCEL INSERT
               END IF
               INSERT INTO hrasc_file(hrasc01,hrasc02,hrasc03,hrasc04,hrasc05,hrasc06,hrasc07)
                VALUES(g_hras.hras01,l_hrasc[l_ac].hrasc02,l_hrasc[l_ac].hrasc03,
                       l_hrasc[l_ac].hrasc04,l_hrasc[l_ac].hrasc05,l_hrasc[l_ac].hrasc06,
                       l_hrasc[l_ac].hrasc07)
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("ins","hrasc_file",g_hras.hras01,
                                l_hrasc[l_ac].hrasc02,SQLCA.sqlcode,"","",1)
                  CANCEL INSERT
               ELSE
                  MESSAGE 'INSERT O.K'
                  LET l_rec_b=l_rec_b+1
                  COMMIT WORK
               END IF

            ON ROW CHANGE
               IF INT_FLAG THEN
                  CALL cl_err('',9001,0)
                  LET INT_FLAG = 0
                  LET l_hrasc[l_ac].* = l_hrasc_t.*
                  CLOSE i005_c_bc2
                  ROLLBACK WORK
                  EXIT INPUT
               END IF

               UPDATE hrasc_file SET  hrasc02 = l_hrasc[l_ac].hrasc02,
                                      hrasc03 = l_hrasc[l_ac].hrasc03,
                                      hrasc04 = l_hrasc[l_ac].hrasc04,
                                      hrasc05 = l_hrasc[l_ac].hrasc05,
                                      hrasc06 = l_hrasc[l_ac].hrasc06,
                                      hrasc07 = l_hrasc[l_ac].hrasc07
                                WHERE hrasc01 = g_hras.hras01
                                  AND hrasc02 = l_hrasc_t.hrasc02
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","hrasc_file",g_hras.hras01,
                               l_hrasc_t.hrasc02,SQLCA.sqlcode,"","",1)
                  LET l_hrasc[l_ac].* = l_hrasc_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF

            AFTER ROW
               LET l_ac = ARR_CURR()
               LET l_ac_t = l_ac
               IF INT_FLAG THEN
                  CALL cl_err('',9001,0)
                  LET INT_FLAG = 0
                  IF p_cmd = 'u' THEN
                     LET l_hrasc[l_ac].* = l_hrasc_t.*
                  END IF
                  CLOSE i005_c_bc2
                  ROLLBACK WORK
                  EXIT INPUT
               END IF
               CLOSE i005_c_bc2
               COMMIT WORK

            BEFORE DELETE                            #是否取消單身
               IF l_hrasc_t.hrasc02 IS NOT NULL THEN
                  IF NOT cl_delete() THEN
                     CANCEL DELETE
                  END IF
                  DELETE FROM hrasc_file
                   WHERE hrasc01 = g_hras.hras01
                     AND hrasc02 = l_hrasc_t.hrasc02
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("del","hrasc_file",g_hras.hras01,l_hrasc_t.hrasc02,
                                  SQLCA.sqlcode,"","",1)
                     EXIT INPUT
                  END IF
                  LET l_rec_b=l_rec_b-1
                  COMMIT WORK

               END IF

            BEFORE FIELD hrasc02
               IF cl_null(l_hrasc[l_ac].hrasc02) OR l_hrasc[l_ac].hrasc02 = 0 THEN
                  SELECT MAX(hrasc02)+1 INTO l_hrasc[l_ac].hrasc02
                    FROM hrasc_file
                   WHERE hrasc01 = g_hras.hras01
                  IF cl_null(l_hrasc[l_ac].hrasc02) THEN
                     LET l_hrasc[l_ac].hrasc02 = 1
                  END IF
               END IF

            AFTER FIELD hrasc02
               IF NOT cl_null(l_hrasc[l_ac].hrasc02) THEN
                  IF l_hrasc[l_ac].hrasc02 != l_hrasc_t.hrasc02
                             OR cl_null(l_hrasc_t.hrasc02) THEN
                     SELECT COUNT(*) INTO l_n
                       FROM hrasc_file
                      WHERE hrasc01 = g_hras.hras01
                        AND hrasc02 = l_hrasc[l_ac].hrasc02
                     IF l_n > 0 THEN
                        CALL cl_err('',-239,0)
                        LET l_hrasc[l_ac].hrasc02 = l_hrasc_t.hrasc02
                        NEXT FIELD hrasc02
                     END IF
                  END IF
               END IF
            	
            AFTER FIELD hrasc03
               IF NOT cl_null(l_hrasc[l_ac].hrasc03) THEN    	
                  IF l_hrasc[l_ac].hrasc03 != l_hrasc_t.hrasc03
                             OR cl_null(l_hrasc_t.hrasc03) THEN
                     LET l_n=0
                     SELECT COUNT(*) INTO l_n FROM hrasc_file WHERE hrasc03=l_hrasc[l_ac].hrasc03
                                                                AND hrasc01=g_hras.hras01
                     IF l_n>0 THEN
                     	  CALL cl_err("此课程编号在本职位中已维护","!",0)
                     	  NEXT FIELD hrasc03
                     END IF                                 
                  END IF	
               END IF  
            
            AFTER FIELD hrasc04
               IF NOT cl_null(l_hrasc[l_ac].hrasc04) THEN    	
                  IF l_hrasc[l_ac].hrasc04 != l_hrasc_t.hrasc04
                             OR cl_null(l_hrasc_t.hrasc04) THEN
                     LET l_n=0
                     SELECT COUNT(*) INTO l_n FROM hrasc_file WHERE hrasc04=l_hrasc[l_ac].hrasc04
                                                                AND hrasc01=g_hras.hras01
                     IF l_n>0 THEN
                     	  CALL cl_err("此课程名称在本职位中已维护","!",0)
                     	  NEXT FIELD hrasc04
                     END IF                                 
                  END IF	
               END IF     		                                            		 
            	
            ON ACTION exporttoexcel     #FUN-4B0038
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(l_hrasc),'','')


            ON ACTION locale
               CALL cl_dynamic_locale()
               CALL cl_show_fld_cont()

#--NO.MOD0078 start------
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE INPUT
#--NO.MOD0078 end--------

            ON ACTION controlg
               CALL cl_cmdask()

            ON ACTION about
               CALL cl_about()

            ON ACTION help
               CALL cl_show_help()

            ON ACTION CONTROLF
               CALL cl_set_focus_form(ui.Interface.getRootNode())
                  RETURNING g_fld_name,g_frm_name
               CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

            ON ACTION CONTROLZ
               CALL cl_show_req_fields()
            ON ACTION exit
               EXIT INPUT

            END INPUT	 		 	
            
              
         END IF	      	
         
      CLOSE i005_c_bc2
      COMMIT WORK

      CALL cl_set_act_visible("accept,cancel", FALSE)
      CONTINUE DISPLAY

      ON ACTION exit
         EXIT DISPLAY
      
      ON ACTION close
         EXIT DISPLAY   

      ON ACTION controlg
         CALL cl_cmdask()

#--NO.MOD-860078 start------
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
#--NO.MOD-860078 end--------

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)

   LET INT_FLAG=0
   CLOSE WINDOW i005c
 
END FUNCTION  
	
FUNCTION i005_b_menu()
   DEFINE   l_priv1   LIKE zy_file.zy03,           # 使用者執行權限
            l_priv2   LIKE zy_file.zy04,           # 使用者資料權限
            l_priv3   LIKE zy_file.zy05            # 使用部門資料權限
   DEFINE   l_cmd     LIKE type_file.chr1000


   WHILE TRUE

      CALL i005_bp("G")

      IF NOT cl_null(g_action_choice) AND l_ac>0 THEN #將清單的資料回傳到主畫面
         SELECT hras_file.*
           INTO g_hras.*
           FROM hras_file
          WHERE hras01=g_hras_b[l_ac].hras01_b
      END IF

      IF g_action_choice!= "" THEN
         LET g_bp_flag = 'Page1'
         LET l_ac = ARR_CURR()
         LET g_jump = l_ac
         LET g_no_ask = TRUE
         IF g_rec_b >0 THEN
             CALL i005_fetch('/')
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
               CALL i005_a()
            END IF
            EXIT WHILE

        WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i005_q()
            END IF
            EXIT WHILE

        WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i005_r()
            END IF

        WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i005_u()
            END IF
            EXIT WHILE

        WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i005_x()
               CALL i005_show()
            END IF

        WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i005_copy()
               CALL i005_show() #FUN-6C0006
            END IF
            	
         WHEN "ghri005_a"
           IF cl_chk_act_auth() THEN
                CALL i005_hrasa()
           END IF
           	
        WHEN "ghri005_b"
           #LET g_action_choice="ghri005_b"
           IF cl_chk_act_auth() THEN
                CALL i005_hrasb()
           END IF    	
        
        WHEN "ghri005_c"
           #LET g_action_choice="ghri005_c"
           IF cl_chk_act_auth() THEN
                CALL i005_hrasc()
           END IF       	        	

        WHEN "exporttoexcel"
           IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hras_b),'','')
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


FUNCTION i005_bp(p_ud)
   DEFINE   p_ud      LIKE type_file.chr1          #No.FUN-680126 VARCHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hras_b TO s_hras_b.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

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
             CALL i005_fetch('/')
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
         CALL i005_fetch('/')
         CALL cl_set_comp_visible("Page2", FALSE)
         #CALL cl_set_comp_visible("Page2", TRUE)
         CALL cl_set_comp_visible("Page3", FALSE)   #NO.FUN-840018 ADD
         CALL ui.interface.refresh()                  #NO.FUN-840018 ADD
         CALL cl_set_comp_visible("Page2", TRUE)
         CALL cl_set_comp_visible("Page3", TRUE)    #NO.FUN-840018 ADD
         EXIT DISPLAY

      ON ACTION first
         CALL i005_fetch('F')
         CONTINUE DISPLAY

      ON ACTION previous
         CALL i005_fetch('P')
         CONTINUE DISPLAY

      ON ACTION jump
         CALL i005_fetch('/')
         CONTINUE DISPLAY

      ON ACTION next
         CALL i005_fetch('N')
         CONTINUE DISPLAY

      ON ACTION last
         CALL i005_fetch('L')
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

      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY

      #No.FUN-9C0089 add begin----------------
      ON ACTION exporttoexcel
         LET g_action_choice="exporttoexcel"
         EXIT DISPLAY
      #No.FUN-9C0089 add -end-----------------
      
      ON ACTION ghri005_a
         LET g_action_choice="ghri005_a"
         EXIT DISPLAY
         
      ON ACTION ghri005_b
         LET g_action_choice="ghri005_b"
         EXIT DISPLAY   
      
      ON ACTION ghri005_c
         LET g_action_choice="ghri005_c"
         EXIT DISPLAY   
   
      AFTER DISPLAY
         CONTINUE DISPLAY

      &include "qry_string.4gl"

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#--->No:100823 begin <---shenran-----
#=================================================================#
# Function name...: i005_import()
# Descriptions...: 打开文件选择窗口允许用户打开本地TXT，EXCEL文件并
# ...............  导入数据到dateBase中
# Input parameter: p_argv1 文件类型 0-TXT 1-EXCEL
# RETURN code....: 'Y' FOR TRUE  : 数据操作成功
#                  'N' FOR FALSE : 数据操作失败
# Date & Author..: 131021 shenran 
#=================================================================#
FUNCTION i005_import()
DEFINE l_file   LIKE  type_file.chr200,
       l_filename LIKE type_file.chr200,
       l_sql    STRING,
       l_data   VARCHAR(300),
       p_argv1  LIKE type_file.num5
DEFINE l_count  LIKE type_file.num5,
       m_tempdir  VARCHAR(240) ,
       m_file     VARCHAR(256) ,
       sr     RECORD    
         hras02  LIKE hras_file.hras02,
         hras01  LIKE hras_file.hras01,
         hras04  LIKE hras_file.hras04,
         hras05  LIKE hras_file.hras05,
         hras03  LIKE hras_file.hras03,
         hras07  LIKE hras_file.hras07
              END RECORD      
DEFINE    l_tok       base.stringTokenizer 
DEFINE xlapp,iRes,iRow,i,j     INTEGER
DEFINE li_k ,li_i_r   LIKE  type_file.num5
DEFINE l_n     LIKE type_file.num5
DEFINE l_racacti     LIKE rac_file.racacti
DEFINE    l_imaacti  LIKE ima_file.imaacti, 
          l_ima02    LIKE ima_file.ima02,
          l_ima25    LIKE ima_file.ima25

DEFINE    l_obaacti  LIKE oba_file.obaacti,
          l_oba02    LIKE oba_file.oba02

DEFINE    l_tqaacti  LIKE tqa_file.tqaacti,
          l_tqa02    LIKE tqa_file.tqa02,
          l_tqa05    LIKE tqa_file.tqa05,
          l_tqa06    LIKE tqa_file.tqa06
DEFINE l_gfe02     LIKE gfe_file.gfe02
DEFINE l_gfeacti   LIKE gfe_file.gfeacti
DEFINE    l_flag    LIKE type_file.num5,
          l_fac     LIKE ima_file.ima31_fac 

   LET g_errno = ' '
   LET l_n=0
   CALL s_showmsg_init() #初始化
   
   LET l_file = cl_browse_file() 
   LET l_file = l_file CLIPPED
   MESSAGE l_file
   IF NOT cl_null(l_file) THEN 
       LET l_count =  LENGTH(l_file)
          IF l_count = 0 THEN  
             LET g_success = 'N'
             RETURN 
          END IF 
       INITIALIZE sr.* TO NULL
       LET li_k = 1
       LET li_i_r = 1
       LET g_cnt = 1 
       LET l_sql = l_file
     
       CALL ui.interface.frontCall('WinCOM','CreateInstance',
                                   ['Excel.Application'],[xlApp])
       IF xlApp <> -1 THEN
          LET l_file = "C:\\Users\\dcms1\\Desktop\\import.xls"
          CALL ui.interface.frontCall('WinCOM','CallMethod',
                                      [xlApp,'WorkBooks.Open',l_sql],[iRes])
                                    # [xlApp,'WorkBooks.Open',"C:/Users/dcms1/Desktop/import.xls"],[iRes]) 

          IF iRes <> -1 THEN
             CALL ui.interface.frontCall('WinCOM','GetProperty',
                  [xlApp,'ActiveSheet.UsedRange.Rows.Count'],[iRow])
             IF iRow > 0 THEN  
                LET g_success = 'Y'
                BEGIN WORK  
              # CALL s_errmsg_init()
                CALL s_showmsg_init()
                FOR i = 1 TO iRow             
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',1).Value'],[sr.hras02])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',3).Value'],[sr.hras01])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',4).Value'],[sr.hras04])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',5).Value'],[sr.hras05])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',6).Value'],[sr.hras03])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',8).Value'],[sr.hras07])
                 
                IF NOT cl_null(sr.hras01) AND NOT cl_null(sr.hras02) 
                	 AND NOT cl_null(sr.hras04) AND NOT cl_null(sr.hras05) THEN 
                	 IF i > 1 THEN
                    INSERT INTO hras_file(hras01,hras02,hras03,hras04,hras05,hras07,hrasacti,hrasuser,hrasgrup,hrasdate,hrasorig,hrasoriu)
                      VALUES (sr.hras01,sr.hras02,sr.hras03,sr.hras04,sr.hras05,sr.hras07,'Y',g_user,g_grup,g_today,g_grup,g_user)
                    IF SQLCA.sqlcode THEN 
                       CALL cl_err3("ins","hras_file",sr.hras01,'',SQLCA.sqlcode,"","",1)   
                       LET g_success  = 'N'
                       CONTINUE FOR 
                    END IF 
                   END IF 
                END IF 
                  # LET i = i + 1
                  # LET l_ac = g_cnt 
                                
                END FOR 
                IF g_success = 'N' THEN 
                   ROLLBACK WORK 
                   CALL s_showmsg() 
                ELSE IF g_success = 'Y' THEN 
                        COMMIT WORK 
                        CALL cl_err( '导入成功','!', 1 )
                     END IF 
                END IF 
            END IF
          ELSE 
              DISPLAY 'NO FILE'
          END IF
       ELSE
       	  DISPLAY 'NO EXCEL'
       END IF     
       CALL ui.interface.frontCall('WinCOM','CallMethod',[xlApp,'Quit'],[iRes])
       CALL ui.interface.frontCall('WinCOM','ReleaseInstance',[xlApp],[iRes]) 
       
       SELECT * INTO g_hras.* FROM hras_file
       WHERE hras01=sr.hras01
       
       CALL i005_show()
   END IF 

END FUNCTION 
#TQC-AC0326 add --------------------end-----------------------


