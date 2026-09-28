# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri080.4gl
# Descriptions...: 
# Date & Author..: 06/25/13 by zhangbo

DATABASE ds

GLOBALS "../../config/top.global"


DEFINE g_hrdm         RECORD LIKE hrdm_file.*    
DEFINE g_hrdm_t       RECORD LIKE hrdm_file.*
DEFINE g_sql          STRING
DEFINE g_wc           STRING
DEFINE g_forupd_sql        STRING               
DEFINE g_before_input_done LIKE type_file.num5 
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_i                 LIKE type_file.num5  
DEFINE g_curs_index        LIKE type_file.num10
DEFINE g_row_count         LIKE type_file.num10
DEFINE g_jump              LIKE type_file.num10
DEFINE g_no_ask            LIKE type_file.num5
DEFINE g_msg               STRING
DEFINE g_chr               LIKE type_file.chr1
DEFINE g_flag              LIKE type_file.chr1
DEFINE g_bp_flag           LIKE type_file.chr1
DEFINE gs_wc               STRING
DEFINE g_argv1             LIKE hrdm_file.hrdm01

MAIN

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
   
   OPEN WINDOW i080_w WITH FORM "ghr/42f/ghri080"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)  
      
   LET g_forupd_sql =" SELECT * FROM hrdm_file ",
                      "  WHERE hrdm01 = ? ",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i080_cl CURSOR FROM g_forupd_sql
      
   CALL cl_ui_init() 
   
   IF NOT cl_null(g_argv1) THEN
      LET g_wc=" hrdm01='",g_argv1,"'"
      CALL i080_q()
   END IF
   
   CALL i080_menu()
   CLOSE WINDOW i080_w        
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION i080_curs()

    CLEAR FORM
    INITIALIZE g_hrdm.* TO NULL
    IF g_argv1 IS NULL THEN
       CONSTRUCT BY NAME g_wc ON                              
           hrdm02,hrdm08,hrdm03,hrdm04,hrdm05,hrdm07,hrdm11,hrdm13    #mod by zhangbo130917
       
           BEFORE CONSTRUCT                                    
              CALL cl_qbe_init()                               
       
           ON ACTION controlp
              CASE
                 WHEN INFIELD(hrdm02)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_hrat01"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.default1 = g_hrdm.hrdm02
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO hrdm02
                    NEXT FIELD hrdm02
                    
                 WHEN INFIELD(hrdm03)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_hrdl01"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.default1 = g_hrdm.hrdm03
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO hrdm03
                    NEXT FIELD hrdm03
                    
                WHEN INFIELD(hrdm04)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_hrct11"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.default1 = g_hrdm.hrdm04
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO hrdm04
                    NEXT FIELD hrdm04
                    
                WHEN INFIELD(hrdm05)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_hrct11"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.default1 = g_hrdm.hrdm05
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO hrdm05
                    NEXT FIELD hrdm05             
       
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
    END IF 
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hrdmuser', 'hrdmgrup')
    
    CALL cl_replace_str(g_wc,'hrdm02','hrat01') RETURNING g_wc    

    LET g_sql = "SELECT hrdm01 FROM hrdm_file,hrat_file ",                       #
                " WHERE ",g_wc CLIPPED,
                "   AND hratid=hrdm02 ", 
                " ORDER BY hrdm01"
    PREPARE i080_prepare FROM g_sql
    DECLARE i080_cs                                                  # 
        SCROLL CURSOR WITH HOLD FOR i080_prepare

    LET g_sql = "SELECT COUNT(DISTINCT hrdm01) FROM hrdm_file,hrat_file WHERE ",g_wc CLIPPED,
                "   AND hrdm02=hratid "
    PREPARE i080_precount FROM g_sql
    DECLARE i080_count CURSOR FOR i080_precount
END FUNCTION
	
FUNCTION i080_menu()
    DEFINE l_cmd    STRING

    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)

        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i080_a()
            END IF

        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i080_q()
            END IF

        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i080_u()
            END IF

        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i080_r()
            END IF
            	
        ON ACTION piliang
            LET g_action_choice="piliang"
            IF cl_chk_act_auth() THEN
               CALL i080_gen()
               CALL i080_show()
            END IF   	

        ON ACTION help
            CALL cl_show_help()

        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
            
        ON ACTION next
            CALL i080_fetch('N')

        ON ACTION previous
            CALL i080_fetch('P')    

        ON ACTION jump
            CALL i080_fetch('/')

        ON ACTION first
            CALL i080_fetch('F')

        ON ACTION last
            CALL i080_fetch('L')

        ON ACTION controlg
            CALL cl_cmdask()

        ON ACTION locale
           CALL cl_dynamic_locale()
           #CALL cl_show_fld_cont()

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
              IF g_hrdm.hrdm01 IS NOT NULL THEN
                 LET g_doc.column1 = "hrdm01"
                 LET g_doc.value1 = g_hrdm.hrdm01
                 CALL cl_doc()
              END IF
           END IF
    END MENU
    CLOSE i080_cs
END FUNCTION	

FUNCTION i080_a()
DEFINE l_year       STRING
DEFINE l_month      STRING 
DEFINE l_day        STRING	
DEFINE l_no         LIKE type_file.chr10
DEFINE l_sql        STRING
DEFINE l_hrdm01     LIKE  hrdm_file.hrdm01
DEFINE l_hrdm       RECORD LIKE hrdm_file.*	

    CLEAR FORM                                   #
    INITIALIZE g_hrdm.* LIKE hrdm_file.*
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
    	  LET g_hrdm.hrdm07 = g_today
    	  LET g_hrdm.hrdm08 = 1
    	  LET g_hrdm.hrdm12 = '0'
    	  LET g_hrdm.hrdm13 = 'N'        #add by zhangbo130917
        LET g_hrdm.hrdmuser = g_user
        LET g_hrdm.hrdmoriu = g_user
        LET g_hrdm.hrdmorig = g_grup
        LET g_hrdm.hrdmgrup = g_grup               #
        LET g_hrdm.hrdmdate = g_today
        LET g_hrdm.hrdmacti = 'Y'
        CALL i080_i("a")                         #
        IF INT_FLAG THEN                         #
            INITIALIZE g_hrdm.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        
        IF g_hrdm.hrdm02 IS NULL THEN              #
            CONTINUE WHILE
        END IF	
        	
        LET l_year=YEAR(g_today) USING "&&&&"
        LET l_month=MONTH(g_today) USING "&&"
        LET l_day=DAY(g_today) USING "&&"
        LET l_year=l_year.trim()
        LET l_month=l_month.trim()
        LET l_day=l_day.trim()
        LET g_hrdm.hrdm01=l_year CLIPPED,l_month CLIPPED,l_day CLIPPED
        LET l_hrdm01=g_hrdm.hrdm01,"%"
        LET l_sql="SELECT MAX(hrdm01) FROM hrdm_file",
                  " WHERE hrdm01 LIKE '",l_hrdm01,"'"
        PREPARE i080_hrdm01 FROM l_sql
        EXECUTE i080_hrdm01 INTO g_hrdm.hrdm01
        IF cl_null(g_hrdm.hrdm01) THEN 
           LET g_hrdm.hrdm01=l_hrdm01[1,8],'0001'
        ELSE
           LET l_no=g_hrdm.hrdm01[9,12]
           LET l_no=l_no+1 USING "&&&&"
           LET g_hrdm.hrdm01=l_hrdm01[1,8],l_no
        END IF	
        
        LET l_hrdm.*=g_hrdm.*
        
        SELECT hratid INTO l_hrdm.hrdm02 
          FROM hrat_file 
         WHERE hrat01=g_hrdm.hrdm02
        	
        INSERT INTO hrdm_file VALUES(l_hrdm.*)    
        UPDATE hrat_file SET hrat71 = l_hrdm.hrdm03 WHERE hratid = hrdm02
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","hrdm_file",g_hrdm.hrdm01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660131
            CONTINUE WHILE
        ELSE
            SELECT hrdm01 INTO g_hrdm.hrdm01 FROM hrdm_file WHERE hrdm01 = g_hrdm.hrdm01
        END IF
        EXIT WHILE
    END WHILE

END FUNCTION
	
FUNCTION i080_i(p_cmd)
   DEFINE p_cmd         LIKE type_file.chr1
   DEFINE l_input       LIKE type_file.chr1
   DEFINE l_n           LIKE type_file.num5
   DEFINE l_sql         STRING
   DEFINE l_hratid      LIKE hrat_file.hratid
   DEFINE l_hrct07_b,l_hrct07_e    LIKE hrct_file.hrct07
   DEFINE l_hrct08_e,l_hrct08_b    LIKE hrct_file.hrct08
   DEFINE l_hrat02      LIKE hrat_file.hrat02
   DEFINE l_hrat04      LIKE hrdm_file.hrdm02
   DEFINE l_hrat05      LIKE hras_file.hras04
   DEFINE l_hrat19      LIKE hrad_file.hrad03
   DEFINE l_hrat66      LIKE hrat_file.hrat66
   DEFINE l_hrdl02      LIKE hrdl_file.hrdl02
   DEFINE l_hrat03      LIKE hrat_file.hrat03       #add by zhangbo130705

   DISPLAY BY NAME
      g_hrdm.hrdm02,g_hrdm.hrdm08,g_hrdm.hrdm03,
      g_hrdm.hrdm13,                                #add by zhangbo130917
      g_hrdm.hrdm04,g_hrdm.hrdm05,
      g_hrdm.hrdm11,g_hrdm.hrdm07

   INPUT BY NAME
      g_hrdm.hrdm02,g_hrdm.hrdm08,g_hrdm.hrdm03,
      g_hrdm.hrdm13,                               #add by zhangbo130917
      g_hrdm.hrdm04,g_hrdm.hrdm05,
      g_hrdm.hrdm07,g_hrdm.hrdm11
      WITHOUT DEFAULTS

      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          LET g_before_input_done = TRUE
          #add by zhangbo130917---begin
         	IF g_hrdm.hrdm13 = 'N' THEN
          	 CALL cl_set_comp_required("hrdm05",TRUE)
          	 CALL cl_set_comp_entry("hrdm05",TRUE)
          ELSE
          	 LET g_hrdm.hrdm05=''
          	 DISPLAY BY NAME g_hrdm.hrdm05 
          	 CALL cl_set_comp_required("hrdm05",FALSE)
          	 CALL cl_set_comp_entry("hrdm05",FALSE)
          END IF
          #add by zhangbo130917---end	
          
      
      AFTER FIELD hrdm02
         IF NOT cl_null(g_hrdm.hrdm02) THEN
         	  LET l_n=0
         	  SELECT COUNT(*) INTO l_n FROM hrat_file 
         	   WHERE hrat01=g_hrdm.hrdm02
         	     AND hratconf='Y'
         	  IF l_n=0 THEN
         	  	 CALL cl_err('无此员工信息','!',0)
         	  	 NEXT FIELD hrdm02
         	  END IF
            SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrdm.hrdm02
            #mark by zhangbo130917----begin 
            #IF l_hratid != g_hrdm_t.hrdm02 OR g_hrdm_t.hrdm02 IS NULL THEN
            #   IF NOT cl_null(g_hrdm.hrdm04) AND 
            #	    NOT cl_null(g_hrdm.hrdm05) THEN
            #	    SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrdm.hrdm02
            #       SELECT hrat03 INTO l_hrat03 FROM hrat_file WHERE hrat01=g_hrdm.hrdm02    #add by zhangbo130705
            #	    SELECT hrct07 INTO l_hrct07_b FROM hrct_file WHERE hrct11=g_hrdm.hrdm04
            #                                                               AND hrct03=l_hrat03       #add by zhangbo130705
            #	    SELECT hrct08 INTO l_hrct08_e FROM hrct_file WHERE hrct11=g_hrdm.hrdm05
            #                                                               AND hrct03=l_hrat03       #add by zhangbo130705 
            #	    LET l_n=0
            #	    IF p_cmd='a' THEN
            #         SELECT COUNT(*) INTO l_n FROM hrct_file A,hrct_file B,hrdm_file
            #           WHERE hrdm02=l_hratid
            #            #AND hrdm01<>g_hrdm.hrdm01
            #            AND hrdm12='0'                                   #add by zhangbo130911---已设置状态
            #            AND A.hrct11=hrdm04
            #            AND B.hrct11=hrdm05
            #            AND A.hrct03=l_hrat03       #add by zhangbo130705
            #            AND B.hrct03=l_hrat03       #add by zhangbo130705
            #            AND ((l_hrct07_b>=A.hrct07 AND l_hrct08_e<=B.hrct08)
            #                 OR (A.hrct07 BETWEEN l_hrct07_b AND l_hrct08_e)
            #                 OR (B.hrct08 BETWEEN l_hrct07_b AND l_hrct08_e))
            #       ELSE
            #          SELECT COUNT(*) INTO l_n FROM hrct_file A,hrct_file B,hrdm_file
            #           WHERE hrdm02=l_hratid
            #             AND hrdm01<>g_hrdm.hrdm01
            #             AND hrdm12='0'                                   #add by zhangbo130911---已设置状态
            #             AND A.hrct11=hrdm04
            #             AND B.hrct11=hrdm05
            #             AND A.hrct03=l_hrat03     #add by zhangbo130705
            #             AND B.hrct03=l_hrat03     #add by zhangbo130705
            #             AND ((l_hrct07_b>=A.hrct07 AND l_hrct08_e<=B.hrct08)
            #                  OR (A.hrct07 BETWEEN l_hrct07_b AND l_hrct08_e)
            #                  OR (B.hrct08 BETWEEN l_hrct07_b AND l_hrct08_e))
            #      END IF
            #      IF l_n>0 THEN
            #         CALL cl_err('该员工的此周期薪资日期有交叉','!',0)
            #         NEXT FIELD hrdm02
            #      END IF
            #	 END IF
            #END IF
         	  
            #add by zhangbo130917----begin
            LET l_n=0
            SELECT hrat03 INTO l_hrat03 FROM hrat_file WHERE hrat01=g_hrdm.hrdm02
            IF l_hratid != g_hrdm_t.hrdm02 OR g_hrdm_t.hrdm02 IS NULL THEN
               IF g_hrdm.hrdm13='Y' THEN
         	  IF NOT cl_null(g_hrdm.hrdm04) THEN
         	     SELECT hrct07 INTO l_hrct07_b FROM hrct_file WHERE hrct11=g_hrdm.hrdm04
                                                                    AND hrct03=l_hrat03
                     IF p_cmd='a' THEN                                               
                        SELECT COUNT(*) INTO l_n FROM hrdm_file,hrct_file A,hrct_file B
                         WHERE hrdm02=l_hratid AND hrdm12='0'
                           AND A.hrct11=hrdm04 AND A.hrct03=l_hrat03
                           AND ((hrdm13='N' AND B.hrct11=hrdm05 AND B.hrct03=l_hrat03 
                                 AND B.hrct08>=l_hrct07_b ) 
                                OR (hrdm13='Y'))          #两个都是无限期肯定交叉 
                     ELSE
                     	SELECT COUNT(*) INTO l_n FROM hrdm_file,hrct_file A,hrct_file B
                         WHERE hrdm02=l_hratid AND hrdm12='0'
                           AND hrdm01<>g_hrdm.hrdm01
                           AND A.hrct11=hrdm04 AND A.hrct03=l_hrat03
                           AND ((hrdm13='N' AND B.hrct11=hrdm05 AND B.hrct03=l_hrat03 
                                 AND B.hrct08>=l_hrct07_b ) 
                                OR (hrdm13='Y'))          #两个都是无限期肯定交叉
                     END IF	
                  END IF   	                                                      
               ELSE
         	  IF NOT cl_null(g_hrdm.hrdm04) AND 
         	     NOT cl_null(g_hrdm.hrdm05) THEN
         	     SELECT hrct07 INTO l_hrct07_b FROM hrct_file WHERE hrct11=g_hrdm.hrdm04
                                                                    AND hrct03=l_hrat03     
         	     SELECT hrct08 INTO l_hrct08_e FROM hrct_file WHERE hrct11=g_hrdm.hrdm05
                                                                    AND hrct03=l_hrat03
                     IF p_cmd='a' THEN
                     	SELECT COUNT(*) INTO l_n FROM hrdm_file,hrct_file A,hrct_file B
                         WHERE hrdm02=l_hratid AND hrdm12='0'
                           AND A.hrct11=hrdm04 AND A.hrct03=l_hrat03
                           AND ((hrdm13='N' AND B.hrct11=hrdm05 AND B.hrct03=l_hrat03
                                 AND ((l_hrct07_b>=A.hrct07 AND l_hrct08_e<=B.hrct08)
                                       OR (A.hrct07 BETWEEN l_hrct07_b AND l_hrct08_e)
                                       OR (B.hrct08 BETWEEN l_hrct07_b AND l_hrct08_e))) 
                                OR (hrdm13='Y' AND A.hrct07<=l_hrct08_e)) 
                     ELSE
                     	SELECT COUNT(*) INTO l_n FROM hrdm_file,hrct_file A,hrct_file B
                         WHERE hrdm02=l_hratid AND hrdm12='0'
                           AND hrdm01<>g_hrdm.hrdm01
                           AND A.hrct11=hrdm04 AND A.hrct03=l_hrat03
                           AND ((hrdm13='N' AND B.hrct11=hrdm05 AND B.hrct03=l_hrat03
                                 AND ((l_hrct07_b>=A.hrct07 AND l_hrct08_e<=B.hrct08)
                                       OR (A.hrct07 BETWEEN l_hrct07_b AND l_hrct08_e)
                                       OR (B.hrct08 BETWEEN l_hrct07_b AND l_hrct08_e))) 
                                OR (hrdm13='Y' AND A.hrct07<=l_hrct08_e))
                     END IF		                                                  
         	  END IF 	 
               END IF	  	   
            END IF
            IF l_n>0 THEN
               CALL cl_err('该员工的此周期薪资日期有交叉','!',0)
               NEXT FIELD hrdm02
            END IF	 	 		  	   
            #add by zhangbo130917----end
         	  
         	  SELECT hrat02 INTO l_hrat02 FROM hrat_file WHERE hrat01=g_hrdm.hrdm02
         	  SELECT hrao02 INTO l_hrat04 FROM hrat_file,hrao_file
         	   WHERE hrat01=g_hrdm.hrdm02 AND hrat04=hrao01 
         	  SELECT hras04 INTO l_hrat05 FROM hrat_file,hras_file
         	   WHERE hrat01=g_hrdm.hrdm02 AND hrat05=hras01
         	  SELECT hrad03 INTO l_hrat19 FROM hrat_file,hrad_file
         	   WHERE hrat01=g_hrdm.hrdm02 AND hrat19=hrad02
         	  SELECT hrat66 INTO l_hrat66 FROM hrat_file WHERE hrat01=g_hrdm.hrdm02
         	  DISPLAY l_hrat02 TO hrat02
         	  DISPLAY l_hrat04 TO hrat04
         	  DISPLAY l_hrat05 TO hrat05
         	  DISPLAY l_hrat19 TO hrat19
         	  DISPLAY l_hrat66 TO hrat66   		 	   
         	  	  	
         END IF
         	
         	  		                                           
      AFTER FIELD hrdm03
         IF g_hrdm.hrdm03 IS NOT NULL THEN 
         	  LET l_n=0
            SELECT COUNT(*) INTO l_n FROM hrdl_file WHERE hrdl01 = g_hrdm.hrdm03
            IF l_n = 0 THEN                  
               CALL cl_err('无此薪资类别','!',0)
               NEXT FIELD hrdm03
            END IF
            SELECT hrdl02 INTO l_hrdl02 FROM hrdl_file WHERE hrdl01=g_hrdm.hrdm03
            DISPLAY l_hrdl02 TO hrdl02	
         END IF
         	
      #add by zhangbo130917---begin
      AFTER FIELD hrdm13
         IF NOT cl_null(g_hrdm.hrdm13) THEN
            IF g_hrdm.hrdm13 = 'N' THEN
               CALL cl_set_comp_required("hrdm05",TRUE)
               CALL cl_set_comp_entry("hrdm05",TRUE)
            ELSE
               LET g_hrdm.hrdm05=''
               DISPLAY BY NAME g_hrdm.hrdm05
               CALL cl_set_comp_required("hrdm05",FALSE)
               CALL cl_set_comp_entry("hrdm05",FALSE)
            END IF
         END IF
      #add by zhangbo130917---end   	
         	
      AFTER FIELD hrdm04
         IF NOT cl_null(g_hrdm.hrdm04) THEN
            LET l_n=0
            SELECT hrat03 INTO l_hrat03 FROM hrat_file WHERE hrat01=g_hrdm.hrdm02         #add by zhangbo130705
            SELECT COUNT(*) INTO l_n FROM hrct_file WHERE hrct11=g_hrdm.hrdm04
                                                      AND hrct03=l_hrat03           #add by zhangbo130705
            IF l_n=0 THEN
               CALL cl_err('无此薪资月','!',0)
               NEXT FIELD hrdm04
            END IF
         	  
         	  	
            IF NOT cl_null(g_hrdm.hrdm05) THEN
               #SELECT hrct08 INTO l_hrct08_b FROM hrct_file WHERE hrct11=g_hrdm.hrdm04
               SELECT hrct07 INTO l_hrct07_b FROM hrct_file WHERE hrct11=g_hrdm.hrdm04
                                                              AND hrct03=l_hrat03       #add by zhangbo130705
               SELECT hrct07 INTO l_hrct07_e FROM hrct_file WHERE hrct11=g_hrdm.hrdm05
                                                              AND hrct03=l_hrat03       #add by zhangbo130705
               #IF l_hrct08_b>=l_hrct07_e THEN       #mark by zhangbo130705
               IF l_hrct07_b>l_hrct07_e THEN         #add by zhangbo130705
                  CALL cl_err('开始期间不可比结束期间大','!',0)
                  NEXT FIELD hrdm04
               END IF
            END IF	
            #mark by zhangbo130917----begin
            #IF g_hrdm.hrdm04 != g_hrdm_t.hrdm04 OR g_hrdm_t.hrdm04 IS NULL THEN
            #   IF NOT cl_null(g_hrdm.hrdm02) AND 
            #	    NOT cl_null(g_hrdm.hrdm05) THEN
            #	    SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrdm.hrdm02
            #	    SELECT hrct07 INTO l_hrct07_b FROM hrct_file WHERE hrct11=g_hrdm.hrdm04
            #	    SELECT hrct08 INTO l_hrct08_e FROM hrct_file WHERE hrct11=g_hrdm.hrdm05
            #	    LET l_n=0
            #	    IF p_cmd='a' THEN
            #         SELECT COUNT(*) INTO l_n FROM hrct_file A,hrct_file B,hrdm_file
            #           WHERE hrdm02=l_hratid
            #            #AND hrdm01<>g_hrdm.hrdm01
            #            AND hrdm12='0'                                   #add by zhangbo130911---已设置状态
            #            AND A.hrct11=hrdm04
            #            AND B.hrct11=hrdm05
            #            AND A.hrct03=l_hrat03         #add by zhangbo130705
            #            AND B.hrct03=l_hrat03         #add by zhangbo130705
            #            AND ((l_hrct07_b>=A.hrct07 AND l_hrct08_e<=B.hrct08)
            #                 OR (A.hrct07 BETWEEN l_hrct07_b AND l_hrct08_e)
            #                 OR (B.hrct08 BETWEEN l_hrct07_b AND l_hrct08_e))
            #       ELSE
            #          SELECT COUNT(*) INTO l_n FROM hrct_file A,hrct_file B,hrdm_file
            #           WHERE hrdm02=l_hratid
            #             AND hrdm01<>g_hrdm.hrdm01
            #             AND hrdm12='0'                                   #add by zhangbo130911---已设置状态
            #             AND A.hrct11=hrdm04
            #             AND B.hrct11=hrdm05
            #             AND A.hrct03=l_hrat03         #add by zhangbo130705
            #             AND B.hrct03=l_hrat03         #add by zhangbo130705
            #             AND ((l_hrct07_b>=A.hrct07 AND l_hrct08_e<=B.hrct08)
            #                  OR (A.hrct07 BETWEEN l_hrct07_b AND l_hrct08_e)
            #                  OR (B.hrct08 BETWEEN l_hrct07_b AND l_hrct08_e))
            #      END IF
            #      IF l_n>0 THEN
            #         CALL cl_err('该员工的此周期薪资日期有交叉','!',0)
            #         NEXT FIELD hrdm04
            #      END IF
            #	 END IF
            #END IF
            #mark by zhangbo130917---end
         	  
            #add by zhangbo130917----begin
            LET l_n=0
            SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrdm.hrdm02
            SELECT hrat03 INTO l_hrat03 FROM hrat_file WHERE hrat01=g_hrdm.hrdm02
            IF g_hrdm.hrdm04 != g_hrdm_t.hrdm04 OR g_hrdm_t.hrdm04 IS NULL THEN
               IF g_hrdm.hrdm13='Y' THEN
         	  SELECT hrct07 INTO l_hrct07_b FROM hrct_file WHERE hrct11=g_hrdm.hrdm04
                                                                 AND hrct03=l_hrat03
                  IF p_cmd='a' THEN                                               
                     SELECT COUNT(*) INTO l_n FROM hrdm_file,hrct_file A,hrct_file B
                      WHERE hrdm02=l_hratid AND hrdm12='0'
                        AND A.hrct11=hrdm04 AND A.hrct03=l_hrat03
                        AND ((hrdm13='N' AND B.hrct11=hrdm05 AND B.hrct03=l_hrat03 
                              AND B.hrct08>=l_hrct07_b ) 
                             OR (hrdm13='Y'))          #两个都是无限期肯定交叉 
                  ELSE
                     SELECT COUNT(*) INTO l_n FROM hrdm_file,hrct_file A,hrct_file B
                      WHERE hrdm02=l_hratid AND hrdm12='0'
                        AND hrdm01<>g_hrdm.hrdm01
                        AND A.hrct11=hrdm04 AND A.hrct03=l_hrat03
                        AND ((hrdm13='N' AND B.hrct11=hrdm05 AND B.hrct03=l_hrat03 
                              AND B.hrct08>=l_hrct07_b ) 
                             OR (hrdm13='Y'))          #两个都是无限期肯定交叉
	          END IF                                   
               ELSE
         	  IF NOT cl_null(g_hrdm.hrdm05) THEN
         	     SELECT hrct07 INTO l_hrct07_b FROM hrct_file WHERE hrct11=g_hrdm.hrdm04
                                                                    AND hrct03=l_hrat03     
         	     SELECT hrct08 INTO l_hrct08_e FROM hrct_file WHERE hrct11=g_hrdm.hrdm05
                                                                    AND hrct03=l_hrat03
                     IF p_cmd='a' THEN
                     	SELECT COUNT(*) INTO l_n FROM hrdm_file,hrct_file A,hrct_file B
                         WHERE hrdm02=l_hratid AND hrdm12='0'
                           AND A.hrct11=hrdm04 AND A.hrct03=l_hrat03
                           AND ((hrdm13='N' AND B.hrct11=hrdm05 AND B.hrct03=l_hrat03
                                 AND ((l_hrct07_b>=A.hrct07 AND l_hrct08_e<=B.hrct08)
                                       OR (A.hrct07 BETWEEN l_hrct07_b AND l_hrct08_e)
                                       OR (B.hrct08 BETWEEN l_hrct07_b AND l_hrct08_e))) 
                                OR (hrdm13='Y' AND A.hrct07<=l_hrct08_e)) 
                     ELSE
                     	SELECT COUNT(*) INTO l_n FROM hrdm_file,hrct_file A,hrct_file B
                         WHERE hrdm02=l_hratid AND hrdm12='0'
                           AND hrdm01<>g_hrdm.hrdm01
                           AND A.hrct11=hrdm04 AND A.hrct03=l_hrat03
                           AND ((hrdm13='N' AND B.hrct11=hrdm05 AND B.hrct03=l_hrat03
                                 AND ((l_hrct07_b>=A.hrct07 AND l_hrct08_e<=B.hrct08)
                                       OR (A.hrct07 BETWEEN l_hrct07_b AND l_hrct08_e)
                                       OR (B.hrct08 BETWEEN l_hrct07_b AND l_hrct08_e))) 
                                OR (hrdm13='Y' AND A.hrct07<=l_hrct08_e))
                     END IF		                                                  
         	  END IF 	 
               END IF	  	   
            END IF
            IF l_n>0 THEN
               CALL cl_err('该员工的此周期薪资日期有交叉','!',0)
               NEXT FIELD hrdm04
            END IF	 	 		  	   
            #add by zhangbo130917----end
         	  	 	  		 
         END IF	  	
     
     AFTER FIELD hrdm05
         IF NOT cl_null(g_hrdm.hrdm05) THEN
            LET l_n=0
            SELECT hrat03 INTO l_hrat03 FROM hrat_file WHERE hrat01=g_hrdm.hrdm02   #add by zhangbo130705
            SELECT COUNT(*) INTO l_n FROM hrct_file WHERE hrct11=g_hrdm.hrdm05
                                                      AND hrct03=l_hrat03           #add by zhangbo130705
            IF l_n=0 THEN
               CALL cl_err('无此薪资月','!',0)
               NEXT FIELD hrdm05
            END IF
         	  	
            IF NOT cl_null(g_hrdm.hrdm04) THEN
               #SELECT hrct08 INTO l_hrct08_b FROM hrct_file WHERE hrct11=g_hrdm.hrdm04     #mark by zhangbo130705
               SELECT hrct07 INTO l_hrct07_b FROM hrct_file WHERE hrct11=g_hrdm.hrdm04      #add by zhangbo130705
                                                              AND hrct03=l_hrat03           #add by zhangbo130705  
               SELECT hrct07 INTO l_hrct07_e FROM hrct_file WHERE hrct11=g_hrdm.hrdm05      
                                                              AND hrct03=l_hrat03           #add by zhangbo130705 
               #IF l_hrct08_b>=l_hrct07_e THEN         #mark by zhangbo130705
               IF l_hrct07_b>l_hrct07_e THEN          #add by zhangbo130705
                  CALL cl_err('开始期间不可比结束期间大','!',0)
                  NEXT FIELD hrdm05
               END IF
            END IF	
         	  
            #mark by zhangbo130917---begin
            #IF g_hrdm.hrdm05 != g_hrdm_t.hrdm05 OR g_hrdm_t.hrdm05 IS NULL THEN
            #   IF NOT cl_null(g_hrdm.hrdm02) AND 
            #	    NOT cl_null(g_hrdm.hrdm04) THEN
            #	    SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrdm.hrdm02
            #	    SELECT hrct07 INTO l_hrct07_b FROM hrct_file WHERE hrct11=g_hrdm.hrdm04
            #	    SELECT hrct08 INTO l_hrct08_e FROM hrct_file WHERE hrct11=g_hrdm.hrdm05
            #	    LET l_n=0
            #	    IF p_cmd='a' THEN
            #         SELECT COUNT(*) INTO l_n FROM hrct_file A,hrct_file B,hrdm_file
            #           WHERE hrdm02=l_hratid
            #            #AND hrdm01<>g_hrdm.hrdm01
            #            AND hrdm12='0'                                   #add by zhangbo130911---已设置状态
            #            AND A.hrct11=hrdm04
            #            AND B.hrct11=hrdm05
            #            AND A.hrct03=l_hrat03         #add by zhangbo130705
            #            AND B.hrct03=l_hrat03         #add by zhangbo130705
            #            AND ((l_hrct07_b>=A.hrct07 AND l_hrct08_e<=B.hrct08)
            #                 OR (A.hrct07 BETWEEN l_hrct07_b AND l_hrct08_e)
            #                 OR (B.hrct08 BETWEEN l_hrct07_b AND l_hrct08_e))
            #       ELSE
            #          SELECT COUNT(*) INTO l_n FROM hrct_file A,hrct_file B,hrdm_file
            #           WHERE hrdm02=l_hratid
            #             AND hrdm01<>g_hrdm.hrdm01
            #             AND hrdm12='0'                                   #add by zhangbo130911---已设置状态
            #             AND A.hrct11=hrdm04
            #             AND B.hrct11=hrdm05
            #             AND A.hrct03=l_hrat03         #add by zhangbo130705
            #             AND B.hrct03=l_hrat03         #add by zhangbo130705
            #             AND ((l_hrct07_b>=A.hrct07 AND l_hrct08_e<=B.hrct08)
            #                  OR (A.hrct07 BETWEEN l_hrct07_b AND l_hrct08_e)
            #                  OR (B.hrct08 BETWEEN l_hrct07_b AND l_hrct08_e))
            #      END IF
            #      IF l_n>0 THEN
            #         CALL cl_err('该员工的此周期薪资日期有交叉','!',0)
            #         NEXT FIELD hrdm05
            #      END IF
            #	 END IF
            #END IF
            #mark by zhangbo130917---end
 	  
            #add by zhangbo130917----begin
            LET l_n=0
            SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrdm.hrdm02
            SELECT hrat03 INTO l_hrat03 FROM hrat_file WHERE hrat01=g_hrdm.hrdm02
            IF g_hrdm.hrdm05 != g_hrdm_t.hrdm05 OR g_hrdm_t.hrdm05 IS NULL THEN
               IF NOT cl_null(g_hrdm.hrdm04) THEN
         	  SELECT hrct07 INTO l_hrct07_b FROM hrct_file WHERE hrct11=g_hrdm.hrdm04
                                                                 AND hrct03=l_hrat03     
         	  SELECT hrct08 INTO l_hrct08_e FROM hrct_file WHERE hrct11=g_hrdm.hrdm05
                                                                 AND hrct03=l_hrat03
                  IF p_cmd='a' THEN
                     SELECT COUNT(*) INTO l_n FROM hrdm_file,hrct_file A,hrct_file B
                      WHERE hrdm02=l_hratid AND hrdm12='0'
                        AND A.hrct11=hrdm04 AND A.hrct03=l_hrat03
                        AND ((hrdm13='N' AND B.hrct11=hrdm05 AND B.hrct03=l_hrat03
                              AND ((l_hrct07_b>=A.hrct07 AND l_hrct08_e<=B.hrct08)
                                    OR (A.hrct07 BETWEEN l_hrct07_b AND l_hrct08_e)
                                    OR (B.hrct08 BETWEEN l_hrct07_b AND l_hrct08_e))) 
                             OR (hrdm13='Y' AND A.hrct07<=l_hrct08_e)) 
                  ELSE
                     SELECT COUNT(*) INTO l_n FROM hrdm_file,hrct_file A,hrct_file B
                      WHERE hrdm02=l_hratid AND hrdm12='0'
                        AND hrdm01<>g_hrdm.hrdm01
                        AND A.hrct11=hrdm04 AND A.hrct03=l_hrat03
                        AND ((hrdm13='N' AND B.hrct11=hrdm05 AND B.hrct03=l_hrat03
                              AND ((l_hrct07_b>=A.hrct07 AND l_hrct08_e<=B.hrct08)
                                    OR (A.hrct07 BETWEEN l_hrct07_b AND l_hrct08_e)
                                    OR (B.hrct08 BETWEEN l_hrct07_b AND l_hrct08_e))) 
                             OR (hrdm13='Y' AND A.hrct07<=l_hrct08_e))
                  END IF		                                                  	 
               END IF	  	   
            END IF
            IF l_n>0 THEN
               CALL cl_err('该员工的此周期薪资日期有交叉','!',0)
               NEXT FIELD hrdm05
            END IF	 	 		  	   
            #add by zhangbo130917----end	
         	  	  		 
         END IF	      		
      
     AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF

     ON ACTION controlp
        CASE
           WHEN INFIELD(hrdm02)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrat01"
              LET g_qryparam.default1 = g_hrdm.hrdm02
              CALL cl_create_qry() RETURNING g_hrdm.hrdm02
              DISPLAY BY NAME g_hrdm.hrdm02
              NEXT FIELD hrdm02
           
           WHEN INFIELD(hrdm03)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrdl01"
              LET g_qryparam.default1 = g_hrdm.hrdm03
              CALL cl_create_qry() RETURNING g_hrdm.hrdm03
              DISPLAY BY NAME g_hrdm.hrdm03
              NEXT FIELD hrdm03
              
           WHEN INFIELD(hrdm04)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrct11"
              LET g_qryparam.default1 = g_hrdm.hrdm04
              CALL cl_create_qry() RETURNING g_hrdm.hrdm04
              DISPLAY BY NAME g_hrdm.hrdm04
              NEXT FIELD hrdm04
           
           WHEN INFIELD(hrdm05)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrct11"
              LET g_qryparam.default1 = g_hrdm.hrdm05
              CALL cl_create_qry() RETURNING g_hrdm.hrdm05
              DISPLAY BY NAME g_hrdm.hrdm05
              NEXT FIELD hrdm05   

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
	
FUNCTION i080_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_hrdm.* TO NULL
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i080_curs()                      
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       RETURN
    END IF
    OPEN i080_count
    FETCH i080_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i080_cs                           
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrdm.hrdm01,SQLCA.sqlcode,0)
        INITIALIZE g_hrdm.* TO NULL
    ELSE
        CALL i080_fetch('F')              
    END IF
END FUNCTION
	
FUNCTION i080_fetch(p_flhrdm)
    DEFINE p_flhrdm         LIKE type_file.chr1

    CASE p_flhrdm
        WHEN 'N' FETCH NEXT     i080_cs INTO g_hrdm.hrdm01
        WHEN 'P' FETCH PREVIOUS i080_cs INTO g_hrdm.hrdm01
        WHEN 'F' FETCH FIRST    i080_cs INTO g_hrdm.hrdm01
        WHEN 'L' FETCH LAST     i080_cs INTO g_hrdm.hrdm01
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
            FETCH ABSOLUTE g_jump i080_cs INTO g_hrdm.hrdm01
            LET g_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrdm.hrdm01,SQLCA.sqlcode,0)
        INITIALIZE g_hrdm.* TO NULL
        LET g_hrdm.hrdm01 = NULL
        RETURN
    ELSE
      CASE p_flhrdm
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE

      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx
    END IF

    SELECT * INTO g_hrdm.* FROM hrdm_file    
       WHERE hrdm01 = g_hrdm.hrdm01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","hrdm_file",g_hrdm.hrdm01,"",SQLCA.sqlcode,"","",0)
    ELSE
        CALL i080_show()                 
    END IF
END FUNCTION	
	
FUNCTION i080_show()
DEFINE l_hrat02     LIKE     hrat_file.hrat02
DEFINE l_hrat04     LIKE     hrao_file.hrao02	
DEFINE l_hrat05     LIKE     hras_file.hras04
DEFINE l_hrat19     LIKE     hrad_file.hrad03
DEFINE l_hrat66     LIKE     hrat_file.hrat66
DEFINE l_hrdl02     LIKE     hrdl_file.hrdl02

    LET g_hrdm_t.* = g_hrdm.*
    SELECT hrat01 INTO g_hrdm.hrdm02 FROM hrat_file WHERE hratid=g_hrdm.hrdm02
    DISPLAY BY NAME g_hrdm.hrdm02,g_hrdm.hrdm08,g_hrdm.hrdm03,g_hrdm.hrdm04,
                    g_hrdm.hrdm05,g_hrdm.hrdm11,g_hrdm.hrdm07,g_hrdm.hrdm13    #mod by zhangbo130917
                    
    SELECT hrat02 INTO l_hrat02 FROM hrat_file WHERE hrat01=g_hrdm.hrdm02
    SELECT hrao02 INTO l_hrat04 FROM hrat_file,hrao_file 
     WHERE hrat01=g_hrdm.hrdm02 AND hrat04=hrao01
    SELECT hras04 INTO l_hrat05 FROM hrat_file,hras_file 
     WHERE hrat01=g_hrdm.hrdm02 AND hrat05=hras01
    SELECT hrad03 INTO l_hrat19 FROM hrat_file,hrad_file
     WHERE hrat01=g_hrdm.hrdm02 AND hrat19=hrad02
    SELECT hrat66 INTO l_hrat66 FROM hrat_file WHERE hrat01=g_hrdm.hrdm02
    SELECT hrdl02 INTO l_hrdl02 FROM hrdl_file WHERE hrdl01=g_hrdm.hrdm03  
    
    DISPLAY l_hrat02 TO hrat02
    DISPLAY l_hrat04 TO hrat04
    DISPLAY l_hrat05 TO hrat05
    DISPLAY l_hrat19 TO hrat19
    DISPLAY l_hrat66 TO hrat66
    DISPLAY l_hrdl02 TO hrdl02
    
    CALL cl_show_fld_cont()
END FUNCTION		
	
FUNCTION i080_u()
DEFINE l_hrdm    RECORD LIKE  hrdm_file.*
    IF g_hrdm.hrdm01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    	
    SELECT * INTO g_hrdm.* FROM hrdm_file WHERE hrdm01=g_hrdm.hrdm01
    
    IF g_hrdm.hrdmacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    
    IF g_hrdm.hrdm12 != '0' THEN
    	 CALL cl_err('不是已设置人员不可更改','!',0)
    	 RETURN
    END IF	
    	 	
    CALL cl_opmsg('u')
    BEGIN WORK

    OPEN i080_cl USING g_hrdm.hrdm01
    IF STATUS THEN
       CALL cl_err("OPEN i080_cl:", STATUS, 1)
       CLOSE i080_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i080_cl INTO g_hrdm.*               #
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrdm.hrdm01,SQLCA.sqlcode,1)
        RETURN
    END IF              
    CALL i080_show()                          
    WHILE TRUE
        CALL i080_i("u")                      
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_hrdm.*=g_hrdm_t.*
            CALL i080_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        LET g_hrdm.hrdmmodu=g_user
        LET g_hrdm.hrdmdate=g_today	
        LET l_hrdm.*=g_hrdm.*
        SELECT hratid INTO l_hrdm.hrdm02 FROM hrat_file WHERE hrat01=g_hrdm.hrdm02
        UPDATE hrdm_file SET hrdm_file.* = l_hrdm.*    
            WHERE hrdm01 = g_hrdm_t.hrdm01
        UPDATE hrat_file SET hrat71 = l_hrdm.hrdm03 WHERE hratid = hrdm02
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","hrdm_file",g_hrdm.hrdm01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
            CONTINUE WHILE
        END IF
        CALL i080_show()	
        EXIT WHILE
    END WHILE
    CLOSE i080_cl
    COMMIT WORK
END FUNCTION
	
FUNCTION i080_r()
    IF g_hrdm.hrdm01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK

    OPEN i080_cl USING g_hrdm.hrdm01
    IF STATUS THEN
       CALL cl_err("OPEN i080_cl:", STATUS, 0)
       CLOSE i080_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i080_cl INTO g_hrdm.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrdm.hrdm01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i080_show()
    IF cl_delete() THEN
       LET g_doc.column1 = "hrdm01"
       LET g_doc.value1 = g_hrdm.hrdm01

       CALL cl_del_doc()
       DELETE FROM hrdm_file WHERE hrdm01 = g_hrdm.hrdm01

       CLEAR FORM
       OPEN i080_count
       #FUN-B50065-add-start--
       IF STATUS THEN
          CLOSE i080_cl
          CLOSE i080_count
          COMMIT WORK
          RETURN
       END IF
       FETCH i080_count INTO g_row_count
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i080_cl
          CLOSE i080_count
          COMMIT WORK
          RETURN
       END IF
       DISPLAY g_row_count TO FORMONLY.cnt

       OPEN i080_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i080_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE                 #No.FUN-6A0066
          CALL i080_fetch('/')
       END IF
    END IF
    CLOSE i080_cl
    COMMIT WORK
END FUNCTION
	
FUNCTION i080_gen()
DEFINE l_hrdm     RECORD LIKE   hrdm_file.*
DEFINE l_n           LIKE type_file.num5
DEFINE l_sql         STRING
DEFINE   li_k                    LIKE type_file.num5
DEFINE   li_i_r                  LIKE type_file.num5
DEFINE   lr_err    DYNAMIC ARRAY OF RECORD
            line    STRING,
            key1    STRING,
            err     STRING
                   END RECORD	
DEFINE l_hrdl02    LIKE   hrdl_file.hrdl02
DEFINE l_hrct07_b,l_hrct07_e    LIKE hrct_file.hrct07
DEFINE l_hrct08_e,l_hrct08_b    LIKE hrct_file.hrct08
DEFINE l_str      STRING  
DEFINE tok base.StringTokenizer
DEFINE l_value    LIKE   hrat_file.hrat01
DEFINE l_year       STRING
DEFINE l_month      STRING 
DEFINE l_day        STRING	
DEFINE l_no         LIKE type_file.chr10
DEFINE l_hrdm01     LIKE  hrdm_file.hrdm01
DEFINE l_hrat03     LIKE  hrat_file.hrat03      #add by zhangbo130705
DEFINE l_n1,l_n2    LIKE  type_file.num5        #add by zhangbo130705
                 
         CLEAR FORM
         INITIALIZE l_hrdm.* TO NULL
         
         WHILE TRUE
         	
         INPUT l_hrdm.hrdm08,l_hrdm.hrdm03,
               l_hrdm.hrdm13,                 #add by zhangbo130917 
               l_hrdm.hrdm04,
               l_hrdm.hrdm05,l_hrdm.hrdm07,l_hrdm.hrdm11
         WITHOUT DEFAULTS FROM hrdm08,hrdm03,
                               hrdm13,                 #add by zhangbo130917
                               hrdm04,hrdm05,hrdm07,hrdm11
         
         BEFORE INPUT
            LET l_hrdm.hrdm08=1
            LET l_hrdm.hrdm07=g_today
            LET l_hrdm.hrdm12 = '0'
            LET l_hrdm.hrdm13 = 'N'              #add by zhangbo130917
            LET l_hrdm.hrdmuser = g_user
            LET l_hrdm.hrdmoriu = g_user
            LET l_hrdm.hrdmorig = g_grup
            LET l_hrdm.hrdmgrup = g_grup               #
            LET l_hrdm.hrdmdate = g_today
            LET l_hrdm.hrdmacti = 'Y'
            
            #add by zhangbo130917---begin
            IF l_hrdm.hrdm13 = 'N' THEN
               CALL cl_set_comp_required("hrdm05",TRUE)
               CALL cl_set_comp_entry("hrdm05",TRUE)
            ELSE
               LET l_hrdm.hrdm05=''
               DISPLAY l_hrdm.hrdm05 TO hrdm05
               CALL cl_set_comp_required("hrdm05",FALSE)
               CALL cl_set_comp_entry("hrdm05",FALSE)
            END IF
            #add by zhangbo130917---end		  
          
            DISPLAY l_hrdm.hrdm07 TO hrdm07
            DISPLAY l_hrdm.hrdm08 TO hrdm08
            
            DISPLAY l_hrdm.hrdm13 TO hrdm13    #add by zhangbo130917
            
            
        
         AFTER FIELD hrdm03
            IF NOT cl_null(l_hrdm.hrdm03) THEN
               LET l_n=0
               SELECT COUNT(*) INTO l_n FROM hrdl_file 
                WHERE hrdl01=l_hrdm.hrdm03
                                                      
               IF l_n=0 THEN
                  CALL cl_err('无此薪资类别','!',0)
                  NEXT FIELD hrdm03
               END IF
             	
               SELECT hrdl02 INTO l_hrdl02 FROM hrdl_file WHERE hrdl01=l_hrdm.hrdm03
               DISPLAY l_hrdl02 TO hrdl02	
                         
            END IF
            	
         #add by zhangbo130917---begin
         AFTER FIELD hrdm13
         IF NOT cl_null(l_hrdm.hrdm13) THEN
            IF l_hrdm.hrdm13 = 'N' THEN
               CALL cl_set_comp_required("hrdm05",TRUE)
               CALL cl_set_comp_entry("hrdm05",TRUE)
            ELSE
               LET l_hrdm.hrdm05=''
               DISPLAY l_hrdm.hrdm05 TO hrdm05
               CALL cl_set_comp_required("hrdm05",FALSE)
               CALL cl_set_comp_entry("hrdm05",FALSE)
            END IF
         END IF
         #add by zhangbo130917---end   	
           
         AFTER FIELD hrdm04
            IF NOT cl_null(l_hrdm.hrdm04) THEN
               LET l_n=0
               SELECT COUNT(*) INTO l_n FROM hrct_file WHERE hrct11=l_hrdm.hrdm04
               IF l_n=0 THEN
         	  CALL cl_err('无此薪资月','!',0)
         	  NEXT FIELD hrdm04
               END IF
         	  	
               IF NOT cl_null(l_hrdm.hrdm05) THEN
                  #SELECT hrct08 INTO l_hrct08_b FROM hrct_file WHERE hrct11=l_hrdm.hrdm04   #mark by zhangbo130705
                  SELECT hrct07 INTO l_hrct07_b FROM hrct_file WHERE hrct11=l_hrdm.hrdm04    #add by zhangbo130705
                  SELECT hrct07 INTO l_hrct07_e FROM hrct_file WHERE hrct11=l_hrdm.hrdm05
                  IF l_hrct07_b>l_hrct07_e THEN                                              #mod by zhangbo130705
                     CALL cl_err('开始期间不可比结束期间大','!',0)
                     NEXT FIELD hrdm04
                  END IF
               END IF	
                
            END IF
             
         AFTER FIELD hrdm05
            IF NOT cl_null(l_hrdm.hrdm05) THEN
               LET l_n=0
               SELECT COUNT(*) INTO l_n FROM hrct_file WHERE hrct11=l_hrdm.hrdm05
               IF l_n=0 THEN
         	  CALL cl_err('无此薪资月','!',0)
         	  NEXT FIELD hrdm05
               END IF
         	  	
               IF NOT cl_null(l_hrdm.hrdm04) THEN
                  SELECT hrct07 INTO l_hrct07_b FROM hrct_file WHERE hrct11=l_hrdm.hrdm04    #mod by zhangbo130705
                  SELECT hrct07 INTO l_hrct07_e FROM hrct_file WHERE hrct11=l_hrdm.hrdm05
                  IF l_hrct07_b>l_hrct07_e THEN                                        #mod by zhangbo130705
                     CALL cl_err('开始期间不可比结束期间大','!',0)
                     NEXT FIELD hrdm05
                  END IF
               END IF	
                
            END IF
             
         AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
             
         ON ACTION controlp
            CASE
              WHEN INFIELD(hrdm03)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrdl01"
              LET g_qryparam.default1 = l_hrdm.hrdm03
              CALL cl_create_qry() RETURNING l_hrdm.hrdm03
              DISPLAY l_hrdm.hrdm03 TO hrdm03
              NEXT FIELD hrdm03
              
              WHEN INFIELD(hrdm04)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrct11"
              LET g_qryparam.default1 = l_hrdm.hrdm04
              CALL cl_create_qry() RETURNING l_hrdm.hrdm04
              DISPLAY l_hrdm.hrdm04 TO hrdm04
              NEXT FIELD hrdm04
              
              WHEN INFIELD(hrdm05)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrct11"
              LET g_qryparam.default1 = l_hrdm.hrdm05
              CALL cl_create_qry() RETURNING l_hrdm.hrdm05
              DISPLAY l_hrdm.hrdm05 TO hrdm05
              NEXT FIELD hrdm05
               
            END CASE
             
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about         
            CALL cl_about()      
 
         ON ACTION help          
            CALL cl_show_help()
 
         ON ACTION exit      
            LET INT_FLAG = 1
            EXIT INPUT  
       END INPUT
        
       IF INT_FLAG THEN
          LET INT_FLAG=0
          RETURN
       END IF    
       	
       LET l_str=''
       
       CALL cl_init_qry_var()
       LET g_qryparam.form  = "q_hrat01"
       LET g_qryparam.state = "c"
       CALL cl_create_qry() RETURNING	l_str
       
       IF cl_null(l_str) THEN
          LET INT_FLAG=0
          CONTINUE WHILE
       ELSE
          EXIT WHILE
       END IF      
       
       END WHILE
       	
       LET g_success='Y'
       LET li_k=1
       
       BEGIN WORK	
       	
       LET tok = base.StringTokenizer.create(l_str,"|")
       IF NOT cl_null(l_str) THEN
          WHILE tok.hasMoreTokens()
             LET l_value=tok.nextToken()
             SELECT hratid INTO l_hrdm.hrdm02 FROM hrat_file WHERE hrat01=l_value
             SELECT hrat03 INTO l_hrat03 FROM hrat_file WHERE hrat01=l_value        #add by zhangbo130705
             #add by zhangbo130705---begin
             LET l_n1=0
             LET l_n2=0
             SELECT COUNT(*) INTO l_n1 FROM hrct_file WHERE hrct11=l_hrdm.hrdm04
                                                        AND hrct03=l_hrat03
             SELECT COUNT(*) INTO l_n2 FROM hrct_file WHERE hrct11=l_hrdm.hrdm05
                                                        AND hrct03=l_hrat03
             IF l_n1=0 OR l_n2=0 THEN
                LET g_success='N'
                LET lr_err[li_k].line=li_k
                LET lr_err[li_k].key1=l_value
                LET lr_err[li_k].err="薪资月不属于该员工所属公司"
                LET li_k=li_k+1
                CONTINUE WHILE
             END IF
             #add by zhangbo130705---end
             
             
             #mark by zhangbo130917---begin
             #SELECT hrct07 INTO l_hrct07_b FROM hrct_file WHERE hrct11=l_hrdm.hrdm04
             #                                               AND hrct03=l_hrat03        #add by zhangbo130705
             #SELECT hrct08 INTO l_hrct08_e FROM hrct_file WHERE hrct11=l_hrdm.hrdm05
             #                                               AND hrct03=l_hrat03        #add by zhangbo130705
             #LET l_n=0
             #SELECT COUNT(*) INTO l_n FROM hrct_file A,hrct_file B,hrdm_file
             # WHERE hrdm02=l_hrdm.hrdm02
             #   AND hrdm12='0'                                   #add by zhangbo130911---已设置状态
             #   AND A.hrct11=hrdm04
             #   AND B.hrct11=hrdm05
             #   AND A.hrct03=l_hrat03        #add by zhangbo130705
             #   AND B.hrct03=l_hrat03        #add by zhangbo130705 
             #   AND ((l_hrct07_b>=A.hrct07 AND l_hrct08_e<=B.hrct08)
             #         OR (A.hrct07 BETWEEN l_hrct07_b AND l_hrct08_e)
             #         OR (B.hrct08 BETWEEN l_hrct07_b AND l_hrct08_e))
             #IF l_n>0 THEN
             #	LET g_success='N'
             #   LET lr_err[li_k].line=li_k
             #   LET lr_err[li_k].key1=l_value
             #   LET lr_err[li_k].err="此员工薪资月有交叉"
             #   LET li_k=li_k+1
             #   CONTINUE WHILE
             #END IF
             #mark by zhangbo130917---end
             
             #add by zhangbo130917----begin
             LET l_n=0
             IF l_hrdm.hrdm13='Y' THEN
         	SELECT hrct07 INTO l_hrct07_b FROM hrct_file WHERE hrct11=g_hrdm.hrdm04
                                                               AND hrct03=l_hrat03                     
                SELECT COUNT(*) INTO l_n FROM hrdm_file,hrct_file A,hrct_file B
                 WHERE hrdm02=l_hratid AND hrdm12='0'
                   AND A.hrct11=hrdm04 AND A.hrct03=l_hrat03
                   AND ((hrdm13='N' AND B.hrct11=hrdm05 AND B.hrct03=l_hrat03 
                        AND B.hrct08>=l_hrct07_b ) 
                        OR (hrdm13='Y'))          #两个都是无限期肯定交叉 
	
  	                                                      
             ELSE
         	SELECT hrct07 INTO l_hrct07_b FROM hrct_file WHERE hrct11=g_hrdm.hrdm04
                                                               AND hrct03=l_hrat03     
         	SELECT hrct08 INTO l_hrct08_e FROM hrct_file WHERE hrct11=g_hrdm.hrdm05
                                                               AND hrct03=l_hrat03

                SELECT COUNT(*) INTO l_n FROM hrdm_file,hrct_file A,hrct_file B
                 WHERE hrdm02=l_hratid AND hrdm12='0'
                   AND A.hrct11=hrdm04 AND A.hrct03=l_hrat03
                   AND ((hrdm13='N' AND B.hrct11=hrdm05 AND B.hrct03=l_hrat03
                        AND ((l_hrct07_b>=A.hrct07 AND l_hrct08_e<=B.hrct08)
                             OR (A.hrct07 BETWEEN l_hrct07_b AND l_hrct08_e)
                             OR (B.hrct08 BETWEEN l_hrct07_b AND l_hrct08_e))) 
                        OR (hrdm13='Y' AND A.hrct07<=l_hrct08_e))                                 	 
             END IF	
             IF l_n>0 THEN
              	LET g_success='N'
                LET lr_err[li_k].line=li_k
                LET lr_err[li_k].key1=l_value
                LET lr_err[li_k].err="此员工薪资月有交叉"
                LET li_k=li_k+1
                CONTINUE WHILE
             END IF  	  
             #add by zhangbo130917---end
             
             LET l_year=YEAR(g_today) USING "&&&&"
             LET l_month=MONTH(g_today) USING "&&"
             LET l_day=DAY(g_today) USING "&&"
             LET l_year=l_year.trim()
             LET l_month=l_month.trim()
             LET l_day=l_day.trim()
             LET l_hrdm.hrdm01=l_year CLIPPED,l_month CLIPPED,l_day CLIPPED
             LET l_hrdm01=l_hrdm.hrdm01,"%"
             LET l_sql="SELECT MAX(hrdm01) FROM hrdm_file",
                       " WHERE hrdm01 LIKE '",l_hrdm01,"'"
             PREPARE i080_gen_hrdm01 FROM l_sql
             EXECUTE i080_gen_hrdm01 INTO l_hrdm.hrdm01
             IF cl_null(l_hrdm.hrdm01) THEN 
                LET l_hrdm.hrdm01=l_hrdm01[1,8],'0001'
             ELSE
                LET l_no=l_hrdm.hrdm01[9,12]
                LET l_no=l_no+1 USING "&&&&"
                LET l_hrdm.hrdm01=l_hrdm01[1,8],l_no
             END IF
             	
             INSERT INTO hrdm_file VALUES (l_hrdm.*)
             UPDATE hrat_file SET hrat71 = l_hrdm.hrdm03 WHERE hratid = hrdm02
             
             IF SQLCA.sqlcode THEN  
                LET g_success='N'
                LET lr_err[li_k].line=li_k
                LET lr_err[li_k].key1=l_value
                LET lr_err[li_k].err=SQLCA.sqlcode
                LET li_k=li_k+1
                CONTINUE WHILE
             END IF 	
             	           
          END WHILE
       END IF	
       	
       IF lr_err.getLength() > 0 AND g_success='N' THEN
          ROLLBACK WORK
          CALL cl_show_array(base.TypeInfo.create(lr_err),cl_getmsg("lib-314",g_lang),"序号|工号|错误描述")
       ELSE
          COMMIT WORK
          CALL cl_err('生成成功','!',1)
       END IF   	
       
END FUNCTION			
	
		
